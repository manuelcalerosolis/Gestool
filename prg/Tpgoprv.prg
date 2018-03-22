#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TPgoPrv FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lNumDias    AS LOGIC    INIT .f.
   DATA  nNumDias    AS NUMERIC  INIT 15
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oEstado
   DATA  cEstado     AS CHARACTER     INIT  "Pagados"
   DATA  aEstado     AS ARRAY    INIT  { "Pagados", "Pendientes", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD AddLine()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE  "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE  "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE  "FACPRVP.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   DATABASE NEW ::oDbfIva PATH ( cPatDat() ) FILE  "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
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
   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oFacPrvP := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodPrv", "C", 12, 0, {|| "@!" },         "Prv.",                   .t., "Cod. Proveedor",              9 )
   ::AddField( "cNomPrv", "C", 50, 0, {|| "@!" },         "Proveedor",              .t., "Nombre Proveedor",           35 )
   ::AddField( "cDocMov", "C", 20, 0, {|| "@!" },         "Recibo",                 .t., "Recibo"                    , 14, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "" },           "Fecha",                  .t., "Fecha"                     , 10, .f. )
   ::AddField( "dFecCob", "D",  8, 0, {|| "" },           "Pago",                   .t., "Fecha de pago"             , 10, .f. )
   ::AddField( "cNifPrv", "C", 15, 0, {|| "@!" },         "Nif",                    .f., "Nif",                        15 )
   ::AddField( "cDomPrv", "C", 35, 0, {|| "@!" },         "Domicilio",              .f., "Domicilio",                  35 )
   ::AddField( "cPobPrv", "C", 25, 0, {|| "@!" },         "Población",              .f., "Población",                  25 )
   ::AddField( "cProPrv", "C", 20, 0, {|| "@!" },         "Provincia",              .f., "Provincia",                  20 )
   ::AddField( "cCdpPrv", "C",  7, 0, {|| "@!" },         "CP",                     .f., "Cod. Postal",                 7 )
   ::AddField( "cTlfPrv", "C", 12, 0, {|| "@!" },         "Tlf",                    .f., "Teléfono",                   12 )
   ::AddField( "cDesCri", "C",100, 0, {|| "@!" },         "Descripción",            .t., "Descripción"               , 50, .f. )
   ::AddField( "nImporte","N", 16, 6, {|| ::cPicOut },    "Tot. Rec",               .t., "Total recibo"              , 10, .t. )
   ::AddField( "cEstado", "C", 20, 0, {|| "@!" },         "Estado",                 .f., "Estado"                    , 10, .f. )
   ::AddField( "nTotDia", "N", 16, 0, {|| "99999" },      "Dias",                   .f., "Dias transcurridos"        , 10, .f. )
   ::AddField( "nTotFac", "N", 16, 6, {|| ::cPicOut },    "Tot. Fac",               .f., "Total factura"             , 10, .t. )
   ::AddField( "nTotCob", "N", 16, 6, {|| ::cPicOut },    "Tot. Pgo",               .f., "Total pagado"              , 10, .t. )
   ::AddField( "nTotPen", "N", 16, 6, {|| ::cPicOut },    "Tot. Pen",               .f., "Total pendiente"           , 10, .t. )
   ::AddField( "cBanco",  "C", 50, 0, {|| "@!" },         "Banco",                  .f., "Nombre del banco"          , 20, .f. )
   ::AddField( "cCuenta", "C", 30, 0, {|| "@!" },         "Cuenta",                 .f., "Cuenta bancaria"           , 35, .f. )

   ::AddTmpIndex( "cCodPrv", "cCodPrv" )

   ::AddGroup( {|| ::oDbf:cCodPrv }, {|| "Proveedor : " + Rtrim( ::oDbf:cCodPrv ) + Rtrim( ::oDbf:cNomPrv ) }, {|| "Total Proveedor..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN28C" )
      return .f.
   end if

   /*
   Montamos agentes
   */

   if !::oDefPrvInf( 70, 71, 80, 81, 400)
      return .f.
   end if

   REDEFINE COMBOBOX ::oEstado ;
      VAR      ::cEstado ;
      ID       210 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lNumDias ;
      ID       190;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::nNumDias ;
      WHEN     ::lNumDias ;
      PICTURE  "999" ;
      SPINNER ;
      MIN      0 ;
      MAX      999 ;
      ID       200 ;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacPrvP:Lastrec() )

   ::CreateFilter( aItmRecPrv(), ::oFacPrvP:cAlias  )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local bValid   := {|| .t. }
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| ::oFacPrvP:lCobrado }
      case ::oEstado:nAt == 2
         bValid   := {|| !::oFacPrvP:lCobrado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   /*
   Nos movemos por las cabeceras de los facturas de Proveedores
	*/

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Proveedor : " + AllTrim( ::cPrvOrg ) + " > " + AllTrim( ::cPrvDes ) },;
                     {|| "Estado    : " + ::cEstado },;
                     {|| "Dias      : " + if( ::lNumDias, Trans( ::nNumDias, "999" ), "Sin especificar" ) } }

   ::oFacPrvP:OrdSetFocus( "DENTRADA" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oFacPrvP:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvP:cFile ), ::oFacPrvP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oFacPrvP:GoTop()

   while !::lBreak .and. !::oFacPrvP:Eof()

      if Eval( bValid )                                                                                 .AND.;
         ::oFacPrvP:dPreCob >= ::dIniInf                                                                .AND.;
         ::oFacPrvP:dPreCob <= ::dFinInf                                                                .AND.;
         ( ::lAllPrv .or. ( ::oFacPrvP:cCodPrv >= ::cPrvOrg .AND. ::oFacPrvP:cCodPrv <= ::cPrvDes ) )   .AND.;
         lChkSer( ::oFacPrvP:cSerFac, ::aSer )

         if ::lNumDias
            if GetSysDate() - ::oFacPrvP:dPreCob <= ::nNumDias
               ::AddLine()
            end if
         else
            ::AddLine()
         end if

      end if

   ::oFacPrvP:Skip()

   ::oMtrInf:AutoInc( ::oFacPrvP:OrdKeyNo() )

   end while

   ::oFacPrvP:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvP:cFile ) )

   ::oMtrInf:AutoInc( ::oFacPrvP:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AddLine()

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cCodPrv := ::oFacPrvP:cCodPrv
   if ::oDbfPrv:Seek( ::oFacPrvP:cCodPrv )
      ::oDbf:cNifPrv := ::oDbfPrv:Nif
      ::oDbf:cNomPrv := ::oDbfPrv:Titulo
      ::oDbf:cDomPrv := ::oDbfPrv:Domicilio
      ::oDbf:cPobPrv := ::oDbfPrv:Poblacion
      ::oDbf:cProPrv := ::oDbfPrv:Provincia
      ::oDbf:cCdpPrv := ::oDbfPrv:CodPostal
      ::oDbf:cTlfPrv := ::oDbfPrv:Telefono
   end if
   ::oDbf:dFecMov := ::oFacPrvP:dPreCob
   ::oDbf:nImporte:= nTotRecPrv( ::oFacPrvP:cAlias, ::oDbfDiv:cAlias, ::cDivInf )
   ::oDbf:nTotFac := nTotFacPrv( ::oFacPrvP:cSerFac + Str( ::oFacPrvP:nNumFac ) + ::oFacPrvP:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias )
   ::oDbf:nTotCob := nPagFacPrv( ::oFacPrvP:cSerFac + Str( ::oFacPrvP:nNumFac ) + ::oFacPrvP:cSufFac, ::oFacPrvP:cAlias )
   ::oDbf:nTotPen := ::oDbf:nTotFac - ::oDbf:nTotCob
   ::oDbf:cDocMov := StrTran( ::oFacPrvP:cSerFac+ "/" + Str( ::oFacPrvP:nNumFac ) + "/" + ::oFacPrvP:cSufFac + "/" + Str( ::oFacPrvP:nNumRec ), " ", "" )
   ::oDbf:nTotDia := GetSysDate() - ::oFacPrvP:dPreCob
   ::oDbf:cBanco  := ::oFacPrvP:cBncPrv
   ::oDbf:cCuenta := ::oFacPrvP:cEntPrv + "-" + ::oFacPrvP:cSucPrv + "-" + ::oFacPrvP:cDigPrv + "-" + ::oFacPrvP:cCtaPrv

   if ::oFacPrvP:lCobrado
      ::oDbf:cEstado := "Cobrado"
      ::oDbf:dFecCob := ::oFacPrvP:dEntrada
   else
      ::oDbf:cEstado := "Pendiente"
   end if

   ::oDbf:cDesCri := ::oFacPrvP:cDesCriP

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//