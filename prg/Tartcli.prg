#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TArtCli()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },         "Cod. Artículo",  .f. } )
   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Cliente",        .f. } )
   aAdd( aCol, { "CNOMART", "C",100, 0, {|| "@!" },         "Descripción",    .t. } )
   aAdd( aCol, { "NTOTCAJ", "N", 16, 6, {|| MasUnd() },     "Cajas",          .t. } )
   aAdd( aCol, { "NTOTUNI", "N", 16, 6, {|| MasUnd() },     "Unds.",          .t. } )
   aAdd( aCol, { "NTOTIMP", "N", 16, 6, {|| oInf:cPicOut }, "Importe",        .t. } )
   aAdd( aCol, { "NCOSART", "N", 16, 6, {|| oInf:cPicOut }, "Costo",          .t. } )
   aAdd( aCol, { "NTOTCOS", "N", 16, 6, {|| oInf:cPicOut }, "Tot. Costo",     .t. } )
   aAdd( aCol, { "NMARGEN", "N", 16, 6, {|| oInf:cPicOut }, "Margen",         .t. } )
   aAdd( aCol, { "NRENTAB", "N", 16, 6, {|| oInf:cPicOut }, "%RENT",          .t. } )
   aAdd( aCol, { "NPREMED", "N", 16, 6, {|| oInf:cPicImp }, "Precio medio",   .f. } )

   aAdd( aIdx, { "CCODFAM", "cCodFam + CCODART" } )

   oInf        := TInfRentFac():New( "Resumen de rentabilidad artículos en facturas", aCol, aIdx, "01041" )

   oInf:AddGroup( {|| oInf:oDbf:cCodFam },                     {|| "Familia  : " + Rtrim( oInf:oDbf:cCodFam ) + "-" + oRetFld( oInf:oDbf:cCodFam, oInf:oDbfFam ) }, {||"Total familia..."} )
   //oInf:AddGroup( {|| oInf:oDbf:cCodFam + oInf:oDbf:cCodArt } )


   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfRentFac FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  nEstado     AS NUMERIC  INIT 1

   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFamilia    AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

   METHOD nImpDivFac()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfVenFac

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"
   ::oFacCliL:OrdSetFocus( "CREF" )

   DATABASE NEW ::oFamilia PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfVenFac

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oFamilia ) .and. ::oFamilia:Used()
      ::oFamilia:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TInfVenFac

   if !::StdResource( "INF_GEN11" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )


   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDefExcInf(204)

   ::oDefResInf(202)

   ::oDefSalInf(201)

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]


RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfVenFac

   local lExcCero := .f.
   local nCajEnt
   local nUntEnt
   local nPreDiv
   local nIvaArt
   local cFac

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oDbfArt:GoTop():Load()

   /*
   do case
      case ::nEstado == 1
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::nEstado == 2
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::nEstado == 3
         bValid   := {|| .t. }
   end case
   */

	/*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

   WHILE !::oDbfArt:Eof()

      IF ::oDbfArt:CODIGO >= ::cArtOrg .AND. ::oDbfArt:CODIGO <= ::cArtDes


         /*
         Calculamos las cajas en vendidas entre dos fechas
         */

         nCajEnt        := 0
         nUntEnt        := 0
         nPreDiv        := 0
         nIvaArt        := 0

         ::oFacCliL:GoTop():Load()

         IF ::oFacCliL:Seek( ::oDbfArt:Codigo )
            ::oFacCliL:Load()

            cFac := ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac

            WHILE ::oFacCliL:CREF = ::oDbfArt:Codigo .AND. !::oFacCliL:Eof()

               ::oFacCliT:Seek( cFac )
               ::oFacCliT:Load()

               IF ::oFacCliT:DFECFAC >= ::dIniInf .AND. ::oFacCliT:DFECFAC <= ::dFinInf
                  IF lChkSer( ::oFacCliT:CSERIE, ::aSer )  .AND. ;
                     !( ::lExcCero .AND. ::oFacCliL:NPREUNIT == 0 )


                     nCajEnt += ::oFacCliL:NCANENT
                     nUntEnt += nUnitEnt( ::oFacCliL:cAlias )
                     nPreDiv += ::nImpDivFac()
                     nIvaArt += Round( nPreDiv * ::oFacCliL:NIVA / 100, ::nDerOut )

                  END IF

               END IF

               ::oFacCliL:Skip( 1 ):Load()

            END WHILE

         END IF


         ::oDbf:Append()
         ::oDbf:CCODART := ::oDbfArt:CODIGO
         ::oDbf:CNOMART := ::oDbfArt:NOMBRE
         ::oDbf:cCodFam := ::oDbfArt:FAMILIA
         ::oDbf:NTOTCAJ := nCajEnt
         ::oDbf:NTOTUNI := nUntEnt
         ::oDbf:NTOTIMP := nPreDiv
         ::oDbf:NCOSART := ::oDbfArt:PCOSTO
         ::oDbf:NTOTCOS := ::oDbf:NTOTUNI * ::oDbf:NCOSART
         ::oDbf:NMARGEN := ::oDbf:NTOTIMP - ( ::oDbf:NTOTUNI * ::oDbf:NCOSART )
         ::oDbf:NRENTAB := ( ( ::oDbf:NTOTIMP / ( ::oDbf:NTOTUNI * ::oDbf:NCOSART ) ) - 1 ) * 100
         ::oDbf:NPREMED := ::oDbf:NTOTIMP / ::oDbf:NTOTUNI

         ::oDbf:Save()

         ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

      END IF

      ::oDbfArt:Skip():Load()

   END WHILE

   ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )
   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )


//---------------------------------------------------------------------------//

METHOD nImpDivFac() CLASS TInfVenFac

   local cFac     := ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac
   local nRec     := ::oFacCliT:RecNo()
   local nOrdAnt  := ::oFacCliT:OrdSetFocus( "NNUMFAC" )
   local nDivArt  := nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

	/*
	Posicionamos en el area de trabajo
	*/

   IF ::oFacCliT:Seek( cFac )
      ::oFacCliT:Load()

      nDivArt     -= Round( nDivArt * ::oFacCliT:nDtoEsp / 100, 0)
      nDivArt     -= Round( nDivArt * ::oFacCliT:nDpp    / 100, 0)
      nDivArt     -= Round( nDivArt * ::oFacCliT:nDtoUno / 100, 0)
      nDivArt     -= Round( nDivArt * ::oFacCliT:nDtoDos / 100, 0)
      nDivArt     -= Round( nDivArt * ::oFacCliT:nDtoCnt / 100, 0)
      nDivArt     -= Round( nDivArt * ::oFacCliT:nDtoRap / 100, 0)
      nDivArt     -= Round( nDivArt * ::oFacCliT:nDtoPub / 100, 0)
      nDivArt     -= Round( nDivArt * ::oFacCliT:nDtoPgo / 100, 0)
      nDivArt     -= Round( nDivArt * ::oFacCliT:nDtoPtf / 100, 0)

   END IF

   ::oFacCliT:GoTo( nRec ):Load()
   ::oFacCliT:OrdSetFocus( nOrdAnt )

RETURN ( nDivArt )

//---------------------------------------------------------------------------//