#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TDetPrc()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },             "Cod. Artículo",  .t., "Codigo Artículo" } )
   aAdd( aCol, { "CNOMART", "C",100, 0, {|| "@!" },             "Descripción",    .t., "Descripción"     } )
   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },             "Cod. Cliente",   .t., "Codigo Cliente"  } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },             "Cliente",        .t., "Cliente"         } )
   aAdd( aCol, { "NCAJENT", "N", 13, 6, {|| MasUnd() },         "Cajas",          .t., "Cajas"           } )
   aAdd( aCol, { "NUNTENT", "N", 13, 6, {|| MasUnd() },         "Unidades",       .t., "Unidades"        } )
   aAdd( aCol, { "NPREDIV", "N", 13, 6, {|| oInf:cPicOut },     "Importe",        .t., "Importe"         } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0, {|| "@!" },             "Presupuesto",    .t., "Presupuesto"     } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },             "Fecha",          .t., "Fecha"           } )

   aAdd( aIdx, { "CCODART", "CCODART" } )

   oInf  := TInfDetPrc():New( "Detalle de ventas de artículos en presupuestos a clientes", aCol, aIdx, "01041" )

   //oInf:AddGroup( {|| oInf:oDbf:cCodArt },                     {|| "Articulo  : " + Rtrim( oInf:oDbf:cCodArt ) + "-" + oRetFld( oInf:oDbf:cCodArt, oInf:oDbfArt ) }, {||""} )
   //oInf:AddGroup( {|| oInf:oDbf:cCodFam },                     {|| "Familia  : " + Rtrim( oInf:oDbf:cCodFam ) + "-" + oRetFld( oInf:oDbf:cCodAlm, oInf:oDbfFam ) }, {||"Total Familia..."} )
   //oInf:AddGroup( {|| oInf:oDbf:cCodFam + oInf:oDbf:cCodArt }, {|| "Artículo : " + Rtrim( oInf:oDbf:cCodArt ) + "-" + oRetFld( oInf:oDbf:cCodArt, oInf:oDbfArt ) }, {||""} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfDetPrc FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  nEstado     AS NUMERIC  INIT 1

   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  oFamilia    AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfDetPrc

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"
   ::oPreCliL:OrdSetFocus( "CREF" )

   DATABASE NEW ::oFamilia PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfDetPrc

   if !Empty( ::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:End()
   end if

   if !Empty( ::oPreCliL ) .and. ::oPreCliL:Used()
      ::oPreCliL:End()

   if!Empty( ::oFamilia ) .and. ::oFamilia:Used()
      ::oFamilia:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfDetPrc

   if !::StdResource( "INF_GEN10" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   ::oDefExcInf(204)

   ::oDefResInf(202)

   ::oDefSalInf(201)


   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

   REDEFINE RADIO ::nEstado ;
      ID       206, 207, 208 ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfDetPrc

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oPreCliT:GoTop():Load()

   do case
      case ::nEstado == 1
         bValid   := {|| !::oPreCliT:lEstado }
      case ::nEstado == 2
         bValid   := {|| ::oPreCliT:lEstado }
      case ::nEstado == 3
         bValid   := {|| .t. }
   end case

   /*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

      WHILE ! ::oPreCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oPreCliT:DFECPRE >= ::dIniInf                                                    .AND.;
         ::oPreCliT:DFECPRE <= ::dFinInf                                                    .AND.;
         lChkSer( ::oPreCliT:CSERPRE, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

           if ::oPreCliL:Seek( ::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE )

            ::oPreCliL:load()

            while ::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE == ::oPreCliL:CSERPRE + Str( ::oPreCliL:NNUMPRE ) + ::oPreCliL:CSUFPRE .AND. !::oPreCliL:eof()

               if ::oPreCliL:CREF >= ::cArtOrg                 .AND.;
                  ::oPreCliL:CREF <= ::cArtDes                 .AND.;
                  !( ::lExcCero .AND. ::oPreCliL:NPREDIV == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodCli := ::oPreCliT:CCODCLI
                  ::oDbf:cNomCli := ::oPreCliT:CNOMCLI
                  ::oDbf:dFecMov := ::oPreCliT:DFECPRE

                  ::oDbf:cCodArt := ::oPreCliL:CREF
                  ::oDbf:nCajEnt := ::oPreCliL:NCANENT
                  ::oDbf:nUntEnt := NotCaja( ::oPreCliL:NCANPRE ) * ::oPreCliL:NUNICAJA
                  ::oDbf:nPreDiv := nTotLPreCli( ::oPreCliL:cAlias, ::nDerOut, ::nValDiv )
                  ::oDbf:cDocMov := ::oPreCliL:CSERPRE + "/" + Str( ::oPreCliL:NNUMPRE ) + "/" + ::oPreCliL:CSUFPRE

                  ::oDbf:Save()

               end if

               ::oPreCliL:Skip():Load()

            end while

         end if

      end if

      ::oPreCliT:Skip():Load()

   end while

   ::oDlg:Enable()

   ::oMtrInf:AutoInc()


RETURN ( ::oDbf:LastRec() > 0 )


//---------------------------------------------------------------------------//