#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TFpgRPrv FROM TInfGen

   DATA  oEstado
   DATA  cEstado     AS CHARACTER     INIT  "Pagados"
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Pagados", "Todos" }
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oDbfIva     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD lIsValid()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodPgo", "C",  2, 0, {|| "@!" },         "Pgo.",                   .f., "Código de formas de pago"  ,  4, .f.)
   ::AddField( "cNomPgo", "C", 40, 0, {|| "@!" },         "Forma de pago",          .f., "Nombre de formas de pago"  , 40, .f.)
   ::AddField( "cDocMov", "C", 18, 0, {|| "@!" },         "Recibo",                 .t., "Recibo"                    , 14, .f.)
   ::AddField( "cCodPrv", "C", 12, 0, {|| "@!" },         "Prv.",                   .t., "Cod. Proveedor",              9 )
   ::AddField( "cNomPrv", "C", 50, 0, {|| "@!" },         "Proveedor",              .t., "Nombre Proveedor",           35 )
   ::AddField( "cNifPrv", "C", 15, 0, {|| "@!" },         "Nif",                    .f., "Nif",                        15 )
   ::AddField( "cDomPrv", "C", 35, 0, {|| "@!" },         "Domicilio",              .f., "Domicilio",                  35 )
   ::AddField( "cPobPrv", "C", 25, 0, {|| "@!" },         "Población",              .f., "Población",                  25 )
   ::AddField( "cProPrv", "C", 20, 0, {|| "@!" },         "Provincia",              .f., "Provincia",                  20 )
   ::AddField( "cCdpPrv", "C",  7, 0, {|| "@!" },         "CP",                     .f., "Cod. Postal",                 7 )
   ::AddField( "cTlfPrv", "C", 12, 0, {|| "@!" },         "Tlf",                    .f., "Teléfono",                   12 )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },    "Tot. Rec",               .t., "Total recibo"              , 14, .t.)
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                  .t., "Fecha de expedición"       , 10, .f.)
   ::AddField( "dFecCob", "D",  8, 0, {|| "@!" },         "Fecha pago",             .f., "Fecha de cobro"            , 10, .f.)
   ::AddField( "nTotFac", "N", 16, 6, {|| ::cPicOut },    "Tot. Fac",               .f., "Total factura"             , 14, .t.)
   ::AddField( "nTotCob", "N", 16, 6, {|| ::cPicOut },    "Tot. Cob",               .f., "Total cobrado"             , 14, .t.)
   ::AddField( "nTotPen", "N", 16, 6, {|| ::cPicOut },    "Tot. Pen",               .f., "Total pendiente"           , 14, .t.)
   ::AddField( "cBanco",  "C", 50, 0, {|| "@!" },         "Banco",                  .f., "Nombre del banco"          , 20, .f. )
   ::AddField( "cCuenta", "C", 30, 0, {|| "@!" },         "Cuenta",                 .f., "Cuenta bancaria"           , 35, .f. )

   ::AddTmpIndex( "cCodPgo", "cCodPgo" )

   ::AddGroup( {|| ::oDbf:cCodPgo }, {|| "Forma de pago : " + Rtrim( ::oDbf:cCodPgo ) + "-" + Rtrim( ::oDbf:cNomPgo ) }, {|| Space(1) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE  "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE  "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE  "FACPRVP.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE  "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

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

METHOD lResource( cFld )

   if !::StdResource( "INFPGPRVREC" )
      return .f.
   end if

   /*
   Montamos las formas de pago
   */

   if !::oDefFpgInf( 70, 80, 90, 100, 300 )
      return .f.
   end if

   if !::oDefPrvInf( 110, 120, 130, 140, 400 )
      return .f.
   end if

   REDEFINE COMBOBOX ::oEstado VAR ::cEstado ;
      ID       210 ;
      ITEMS    ::aEstado ;
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

   local cCodPgo  := ""
   local nTotDia  := 0
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf )   },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ]                      },;
                     {|| "Proveedor : " + lTrim( ::cPrvOrg ) + " > " + lTrim( ::cPrvDes ) },;
                     {|| "F. pago   : " + lTrim( ::cFpgDes ) + " > " + lTrim( ::cFpgHas ) } }

   ::oFacPrvP:OrdSetFocus( "DENTRADA" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oFacPrvP:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvP:cFile ), ::oFacPrvP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oFacPrvP:GoTop()

   while !::lBreak .and. !::oFacPrvP:Eof()

      cCodPgo  := cPgoFacPrv( ::oFacPrvP:cSerFac + Str( ::oFacPrvP:nNumFac ) + ::oFacPrvP:cSufFac, ::oFacPrvT:cAlias )

      if ::lIsValid()                                                                                   .AND.;
         ::oFacPrvP:dPreCob >= ::dIniInf                                                                .AND.;
         ::oFacPrvP:dPreCob <= ::dFinInf                                                                .AND.;
         ( ::lAllFpg .or. ( cCodPgo >= ::cFpgDes .AND. cCodPgo <= ::cFpgHas ) )                         .AND.;
         ( ::lAllPrv .or. ( ::oFacPrvP:cCodPrv >= ::cPrvOrg .AND. ::oFacPrvP:cCodPrv <= ::cPrvDes ) )   .AND.;
         lChkSer( ::oFacPrvP:cSerFac, ::aSer )

         /*
         Si cumple todas, empezamos a añadir
         */

         ::oDbf:Append()

         ::oDbf:cDocMov := ::oFacPrvP:cSerFac + "/" + Str( ::oFacPrvP:nNumFac ) + "/" + ::oFacPrvP:cSufFac + "/" + Str( ::oFacPrvP:nNumRec )
         ::oDbf:cCodPrv := ::oFacPrvP:cCodPrv
         if ::oDbfPrv:Seek( ::oFacPrvP:cCodPrv )
            ::oDbf:cNomPrv := ::oDbfPrv:Titulo
            ::oDbf:cNifPrv := ::oDbfPrv:Nif
            ::oDbf:cDomPrv := ::oDbfPrv:Domicilio
            ::oDbf:cPobPrv := ::oDbfPrv:Poblacion
            ::oDbf:cProPrv := ::oDbfPrv:Provincia
            ::oDbf:cCdpPrv := ::oDbfPrv:CodPostal
            ::oDbf:cTlfPrv := ::oDbfPrv:Telefono
         end if
         ::oDbf:dFecMov := ::oFacPrvP:dPreCob
         ::oDbf:dFecCob := ::oFacPrvP:dEntrada
         ::oDbf:nTotDoc := nTotRecPrv( ::oFacPrvP:cAlias, ::oDbfDiv:cAlias, ::cDivInf )
         ::oDbf:nTotFac := nTotFacPrv( ::oFacPrvP:cSerFac + Str( ::oFacPrvP:nNumFac ) + ::oFacPrvP:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias )
         ::oDbf:nTotCob := nPagFacPrv( ::oFacPrvP:cSerFac + Str( ::oFacPrvP:nNumFac ) + ::oFacPrvP:cSufFac, ::oFacPrvP:cAlias )
         ::oDbf:nTotPen := ::oDbf:nTotFac - ::oDbf:nTotCob
         ::oDbf:cBanco  := ::oFacPrvP:cBncPrv
         ::oDbf:cCuenta := ::oFacPrvP:cEntPrv + "-" + ::oFacPrvP:cSucPrv + "-" + ::oFacPrvP:cDigPrv + "-" + ::oFacPrvP:cCtaPrv

         ::oDbf:cCodPgo := cCodPgo
         ::oDbf:cNomPgo := cNbrFPago( cCodPgo, ::oDbfFpg )

         ::oDbf:Save()

      end if

      ::oFacPrvP:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvP:OrdKeyNo() )

   end while

   ::oFacPrvP:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvP:cFile ) )

   ::oMtrInf:AutoInc( ::oFacPrvP:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD lIsValid()

   local lRet  := .t.

   do case
      case ::oEstado:nAt == 1 // "Pendientes"
         lRet  := !::oFacPrvP:lCobrado
      case ::oEstado:nAt == 2 // "Pagados"
         lRet  := ::oFacPrvP:lCobrado
      case ::oEstado:nAt == 3 // "Todos"
         lRet  := .t.
   end case

RETURN ( lRet )

//---------------------------------------------------------------------------//