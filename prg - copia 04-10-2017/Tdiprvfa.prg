#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TDPrvFac()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODPRV", "C", 12, 0, {|| "@!" },         "Cli",                       .f., "Cod. proveedor",             8 } )
   aAdd( aCol, { "CNOMPRV", "C", 50, 0, {|| "@!" },         "Nom",                       .f., "Nombre proveedor",          25 } )
   aAdd( aCol, { "CDOCMOV", "C", 18, 0, {|| "@!" },         "Fac",                       .t., "Factura",                   14 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                     14 } )
   aAdd( aCol, { "CNIFPRV", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                        8 } )
   aAdd( aCol, { "CDOMPRV", "C", 35, 0, {|| "@!" },         "Dom",                       .f., "Domicilio",                 10 } )
   aAdd( aCol, { "CPOBPRV", "C", 25, 0, {|| "@!" },         "Pob",                       .f., "Población",                 25 } )
   aAdd( aCol, { "CPROPRV", "C", 20, 0, {|| "@!" },         "Prov",                      .f., "Provincia",                 20 } )
   aAdd( aCol, { "CCDPPRV", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",               20 } )
   aAdd( aCol, { "CTLFPRV", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                   7 } )
   aAdd( aCol, { "NTOTNET", "N", 16, 6, {|| oInf:cPicIn },  "Neto",                      .t., "Neto",                      10 } )
   aAdd( aCol, { "NTOTIVA", "N", 16, 6, {|| oInf:cPicIn },  cImp(),                      .t., cImp(),                      10 } )
   aAdd( aCol, { "NTOTREQ", "N", 16, 3, {|| oInf:cPicIn },  "Rec",                       .t., "Rec",                       10 } )
   aAdd( aCol, { "NTOTDOC", "N", 16, 6, {|| oInf:cPicIn },  "Total",                     .t., "Total",                     10 } )

   aAdd( aIdx, { "CCODPRV", "CCODPRV" } )

   oInf  := TDiaPFac():New( "Informe totalizado de facturas de proveedores agrupadas por proveedor", aCol, aIdx, "01045" )

   oInf:AddGroup( {|| oInf:oDbf:cCodPrv }, {|| "Proveedor : " + Rtrim( oInf:oDbf:cCodPrv ) + "-" + oRetFld( oInf:oDbf:cCodPrv, oInf:oDbfPrv ) } )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TDiaPFac FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaPFac

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DATABASE NEW ::oFacPrvT  PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"
   ::oFacPrvT:SetOrder( "DFECFAC" )

   DATABASE NEW ::oFacPrvL  PATH ( cPatEmp() ) FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oFacPrvP  PATH ( cPatEmp() ) FILE "FACPRVP.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaPFac

   if !Empty( ::oFacPrvtT ) .and. ::oFacPrvtT:Used()
      ::oFacPrvtT:End()
   end if

   if !Empty( ::oFacPrvtL ) .and. ::oFacPrvtL:Used()
      ::oFacPrvtL:End()
   end if

   if !Empty( ::oFacPrvtP ) .and. ::oFacPrvtP:Used()
      ::oFacPrvtP:End()
   end if

   if !Empty( ::oDbfPrv ) .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
   end if

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TDiaPFac

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN05A" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   ::oDefPrvInf( 70, 80, 90, 100 )

   /*
   Monta los clientes de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaPFac

   local bValid   := {|| .t. }
   local aTotTmp  := {}

   ::oDlg:Disable()

   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacPrvT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacPrvT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Provedor: " + ::cPrvOrg         + " > " + ::cPrvDes         },;
                        {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por las cabeceras de los albaranes a clientes
	*/

   ::oFacPrvT:GoTop()
   while !::oFacPrvT:Eof()

      if Eval( bValid )                                                                      .AND.;
         ::oFacPrvT:DFECFAC >= ::dIniInf                                                     .AND.;
         ::oFacPrvT:DFECFAC <= ::dFinInf                                                     .AND.;
         ::oFacPrvT:CCODPRV >= ::cPrvOrg                                                     .AND.;
         ::oFacPrvT:CCODPRV <= ::cPrvDes                                                     .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         ::oDbf:Append()

         ::oDbf:CCODPRV := ::oFacPrvT:CCODPRV
         ::oDbf:CNOMPRV := ::oFacPrvT:CNOMPRV
         ::oDbf:DFECMOV := ::oFacPrvT:DFECFAC

         aTotTmp        := aTotFacPrv (::oFacPrvT:cSerFac + Str( ::oFacPrvT:NNUMFAC ) + ::oFacPrvT:CSUFFAC, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, ::cDivInf )

         ::oDbf:NTOTNET := aTotTmp[1]
         ::oDbf:NTOTIVA := aTotTmp[2]
         ::oDbf:NTOTREQ := aTotTmp[3]
         ::oDbf:NTOTDOC := aTotTmp[4]
         ::oDbf:CDOCMOV := ::oFacPrvT:cSerFac + "/" + Str( ::oFacPrvT:NNUMFAC ) + "/" + ::oFacPrvT:CSUFFAC

         if ::oDbfPrv:Seek ( ::oFacPrvT:CCODPRV )

            ::oDbf:CNIFPRV := ::oDbfPrv:Nif
            ::oDbf:CDOMPRV := ::oDbfPrv:Domicilio
            ::oDbf:CPOBPRV := ::oDbfPrv:Poblacion
            ::oDbf:CPROPRV := ::oDbfPrv:Provincia
            ::oDbf:CCDPPRV := ::oDbfPrv:CodPostal
            ::oDbf:CTLFPRV := ::oDbfPrv:Telefono

         end if

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

      ::oFacPrvT:Skip()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//