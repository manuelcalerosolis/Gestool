#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDiaPrFa FROM TPrvInf

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oDbfDiv     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   if ::xOthers
      ::AddField ( "CCODPRV", "C", 12, 0, {|| "@!" },         "Código",                .f., "Cod. proveedor",         8 )
      ::AddField ( "CNOMPRV", "C", 50, 0, {|| "@!" },         "Proveedor",             .f., "Nombre proveedor",      25 )
      ::AddField ( "cDocMov", "C", 14, 0, {|| "@!" },         "Documento",             .t., "Documento",             14 )
      ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                 .t., "Fecha",                 14 )
      ::AddField ( "cNifPrv", "C", 15, 0, {|| "@!" },         "Nif",                   .f., "Nif",                    8 )
      ::AddField ( "cDomPrv", "C", 35, 0, {|| "@!" },         "Domicilio",             .f., "Domicilio",             10 )
      ::AddField ( "cPobPrv", "C", 25, 0, {|| "@!" },         "Población",             .f., "Población",             25 )
      ::AddField ( "cProPrv", "C", 20, 0, {|| "@!" },         "Provincia",             .f., "Provincia",             20 )
      ::AddField ( "cCdpPrv", "C",  7, 0, {|| "@!" },         "CP",                    .f., "Cod. Postal",           20 )
      ::AddField ( "cTlfPrv", "C", 12, 0, {|| "@!" },         "Tlf",                   .f., "Teléfono",               7 )
      ::AddField ( "nTotNet", "N", 16, 6, {|| ::cPicOut },    "Neto",                  .t., "Neto",                  10 )
      ::AddField ( "nTotIva", "N", 16, 6, {|| ::cPicOut },    cImp(),                  .t., cImp(),                  10 )
      ::AddField ( "nTotReq", "N", 16, 3, {|| ::cPicOut },    "Rec",                   .f., "Rec",                   10 )
      ::AddField ( "nTotDoc", "N", 16, 6, {|| ::cPicOut },    "Total",                 .t., "Total",                 10 )
      ::AddField ( "nCobros", "N", 16, 6, {|| ::cPicOut },    "Cobrado",               .t., "Cobrado factura",       10, .t. )
      ::AddField ( "nPdtFac", "N", 16, 6, {|| ::cPicOut },    "Pendiente",             .t., "Pendiente factura",     12, .t. )
      ::AddField ( "cSuFac",  "C", 50, 0, {|| "@!" },         "Su factura",            .t., "Su factura",            12, .t. )

      ::AddTmpIndex( "cCodPrv", "cCodPrv" )
      ::AddGroup( {|| ::oDbf:cCodPrv }, {|| "Proveedor  : " + Rtrim( ::oDbf:cCodPrv ) + "-" + oRetFld( ::oDbf:cCodPrv, ::oDbfPrv ) } )
   else
      ::AddField ( "CCODPRV", "C", 12, 0, {|| "@!" },         "Código",                .t., "Cod. proveedor",         8 )
      ::AddField ( "CNOMPRV", "C", 50, 0, {|| "@!" },         "Proveedor",             .t., "Nombre proveedor",      25 )
      ::AddField ( "cDocMov", "C", 14, 0, {|| "@!" },         "Documento",             .t., "Documento",             14 )
      ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                 .t., "Fecha",                 14 )
      ::AddField ( "cNifPrv", "C", 15, 0, {|| "@!" },         "Nif",                   .f., "Nif",                    8 )
      ::AddField ( "cDomPrv", "C", 35, 0, {|| "@!" },         "Domicilio",             .f., "Domicilio",             10 )
      ::AddField ( "cPobPrv", "C", 25, 0, {|| "@!" },         "Población",             .f., "Población",             25 )
      ::AddField ( "cProPrv", "C", 20, 0, {|| "@!" },         "Provincia",             .f., "Provincia",             20 )
      ::AddField ( "cCdpPrv", "C",  7, 0, {|| "@!" },         "CP",                    .f., "Cod. Postal",           20 )
      ::AddField ( "cTlfPrv", "C", 12, 0, {|| "@!" },         "Tlf",                   .f., "Teléfono",               7 )
      ::AddField ( "nTotNet", "N", 16, 6, {|| ::cPicOut },    "Neto",                  .t., "Neto",                  10 )
      ::AddField ( "nTotIva", "N", 16, 6, {|| ::cPicOut },    cImp(),                  .t., cImp(),                  10 )
      ::AddField ( "nTotReq", "N", 16, 3, {|| ::cPicOut },    "Rec",                   .f., "Rec",                   10 )
      ::AddField ( "nTotDoc", "N", 16, 6, {|| ::cPicOut },    "Total",                 .t., "Total",                 10 )
      ::AddField ( "nCobros", "N", 16, 6, {|| ::cPicOut },    "Cobrado",               .t., "Cobrado factura",       10 )
      ::AddField ( "nPdtFac", "N", 16, 6, {|| ::cPicOut },    "Pendiente",             .t., "Pendiente factura",     12 )
      ::AddField ( "cSuFac",  "C", 50, 0, {|| "@!" },         "Su factura",            .t., "Su factura",            12 )

      ::AddTmpIndex( "dFecMov", "dFecMov" )
   end if

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacPrvT  PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL  PATH ( cPatEmp() ) FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oFacPrvP  PATH ( cPatEmp() ) FILE "FACPRVP.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   DATABASE NEW ::oDbfDiv   PATH ( cPatDat() ) FILE "DIVISAS.DBF" VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if
   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if
   if !Empty( ::oDbfDiv ) .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oDbfIva  := nil
   ::oFacPrvP := nil
   ::oDbfDiv  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todas"

   if !::StdResource( "INFDIAPRV" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   if !::oDefPrvInf( 70, 80, 90, 100, 900 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )

   ::oDefExcInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmFacPrv(), ::oFacPrvT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local aTotTmp  := {}

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Proveedor : " + if( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim( ::cPrvDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oFacPrvT:OrdSetFocus( "dFecFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllPrv
      cExpHead       += ' .and. cCodPrv >= "' + ::cPrvOrg + '" .and. cCodPrv <= "' + ::cPrvDes + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   ::oFacPrvT:GoTop()

   while !::lBreak .and. !::oFacPrvT:Eof()

      if lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         ::oDbf:Append()

         ::AddProveedor ( ::oFacPrvT:cCodPrv )
         ::oDbf:dFecMov := ::oFacPrvT:dFecFac
         ::oDbf:cSuFac  := ::oFacPrvT:cSuPed

         aTotTmp        := aTotFacPrv( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, ::cDivInf )

         ::oDbf:nTotNet := aTotTmp[1]
         ::oDbf:nTotIva := aTotTmp[2]
         ::oDbf:nTotReq := aTotTmp[3]
         ::oDbf:nTotDoc := aTotTmp[4]
         ::oDbf:cDocMov := AllTrim ( ::oFacPrvT:cSerFac ) + "/" + AllTrim ( Str( ::oFacPrvT:nNumFac ) ) + "/" + AllTrim ( ::oFacPrvT:cSufFac )

         ::oDbf:nCobros := nPagFacPrv( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvP:cAlias, , ::oDbfDiv:cAlias )
         ::oDbf:nPdtFac := ::oDbf:nTotDoc - ::oDbf:nCobros

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

      ::oFacPrvT:Skip()

   end while

   ::oMtrInf:AutoInc( ::oFacPrvT:LastRec() )

   ::oFacPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//