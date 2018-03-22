#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfPrevisionPagos FROM TNewInfGen

   DATA   oFacPrvP  AS OBJECT
   DATA   oFacPrvT  AS OBJECT

   METHOD Create()

   METHOD lResource( cFld )

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTipDoc",   "C", 20, 0, {|| "@!" },      "Tipo",              .f., "Tipo documento",                    15, .f. )
   ::AddField( "cNumDoc",   "C", 17, 0, {|| "@!" },      "N. Recibo",         .t., "Número recibo",                     15, .f. )
   ::AddField( "cCodGPrv",  "C",  4, 0, {|| "@!" },      "Grp. prv.",         .f., "Cod. grupo proveedor",               9, .f. )
   ::AddField( "cNomGPrv",  "C", 30, 0, {|| "@!" },      "Grupo",             .f., "Nombre grupo",                      35, .f. )
   ::AddField( "cCodPrv",   "C", 12, 0, {|| "@!" },      "Prv.",              .f., "Cod. proveedor",                     9, .f. )
   ::AddField( "cNomPrv",   "C", 50, 0, {|| "@!" },      "Proveedor",         .f., "Nombre proveedor",                  35, .f. )
   ::AddField( "cCodFpg",   "C",  2, 0, {|| "@!" },      "Cod. pago",         .f., "Cod. pago",                          9, .f. )
   ::AddField( "cNomFpg",   "C", 30, 0, {|| "@!" },      "Forma de pago",     .f., "Forma de pago",                     35, .f. )
   ::AddField( "dFecMov",   "D",  8, 0, {|| "@!" },      "F. Exped.",         .t., "Fecha expedición",                  12, .f. )
   ::AddField( "dFecPre",   "D",  8, 0, {|| "@!" },      "F. Vncto.",         .t., "Fecha de vencimiento",              12, .f. )
   ::AddField( "cSuDoc",    "C", 20, 0, {|| "@!" },      "N. Documento",      .t., "Número de documento",               12, .f. )
   ::AddField( "cDescrip",  "C",100, 0, {|| "@!" },      "Descrip.",          .t., "Concepto del pago",                 50, .f. )
   ::AddField( "nImporte",  "N", 16, 3, {|| ::cPicOut }, "Importe",           .t., "Importe",                           15, .f. )
   ::AddField( "cBanco",    "C", 50, 0, {|| "@!" },      "Banco proveedor",   .f., "Nombre del banco del proveedor",    20, .f. )
   ::AddField( "cCuenta",   "C", 30, 0, {|| "@!" },      "Cuenta proveedor",  .f., "Cuenta bancaria del proveedor",     35, .f. )
   ::AddField( "cBncEmp",   "C", 50, 0, {|| "@!" },      "Banco empresa",     .f., "Nombre del banco de la empresa",    20, .f. )
   ::AddField( "cCtaEmp",   "C", 30, 0, {|| "@!" },      "Cuenta empresa",    .f., "Cuenta bancaria de la empresa",     35, .f. )

   ::AddTmpIndex( "cNumDoc", "cNumDoc" )
   ::AddTmpIndex( "dFecMov", "dFecMov" )
   ::AddTmpIndex( "dFecPre", "dFecPre" )

   ::lExcCero  := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oFacPrvP PATH ( cPatEmp() )   FILE "FACPRVP.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

      DATABASE NEW ::oFacPrvT PATH ( cPatEmp() )   FILE "FACPRVT.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   ::oFacPrvP := nil
   ::oFacPrvT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   ::dIniInf            := BoM( Date() ) 
   ::lGrpFecInf         := .f.
   ::lNewInforme        := .t.
   ::lDefCondiciones    := .f.
   ::lDefEstadoUno      := .t.
   ::lDefEstadoDos      := .t.
   ::cEstadoUno         := "Ordenar por número"
   ::aEstadoUno         := { "Ordenar por número", "Ordenar por fecha exp.", "Ordenar por fecha prev." }
   ::cEstadoDos         := "Facturas"
   ::aEstadoDos         := { "Todas", "Facturas", "Rectificativas" }

   if !::NewResource( "INF_GEN_02" )
      return .f.
   end if

   if !::lGrupoGProveedor( .f. )
      return .f.
   end if

   if !::lGrupoProveedor( .f. )
      return .f.
   end if

   if !::lGrupoFPago( .f. )
      return .f.
   end if

   ::oDefExcInf( 1515 )

   ::CreateFilter( aItmRecPrv(), ::oFacPrvP:cAlias )

   ::oMtrInf:SetTotal( ::oFacPrvP:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cCodGPrv
   //local cCodPrv
   local cExpHead    := ""

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| Padr( "Fecha", 13 ) + ": " + Dtoc( Date() ) },;
                     {|| Padr( "Periodo", 13 ) + ": " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) } }

   if !::oGrupoGProveedor:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Grp. proveedor", 13 ) + ": " + AllTrim( ::oGrupoGProveedor:Cargo:Desde ) + " > " + AllTrim( ::oGrupoGProveedor:Cargo:Hasta ) } )
   end if

   if !::oGrupoProveedor:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Proveedor", 13 ) + ": " + AllTrim( ::oGrupoProveedor:Cargo:Desde ) + " > " + AllTrim( ::oGrupoProveedor:Cargo:Hasta ) } )
   end if

   if !::oGrupoFPago:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Forma de pago", 13 ) + ": " + AllTrim( ::oGrupoFPago:Cargo:Desde ) + " > " + AllTrim( ::oGrupoFPago:Cargo:Hasta ) } )
   end if

   ::oFacPrvP:OrdSetFocus( "nNumFac" )

   if ::lExcCero
      cExpHead       := '!lCobrado .and. ( ( dFecVto >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) ) .or. Empty( dFecVto ) )'
   else
      cExpHead       := '!lCobrado .and. ( ( dFecVto >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) ) )'
   end if

   if !::oGrupoProveedor:Cargo:Todos
      cExpHead       += '.and. cCodPrv >= "' + Rtrim( ::oGrupoProveedor:Cargo:Desde ) + '" .and. cCodPrv <= "' + Rtrim( ::oGrupoProveedor:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoFPago:Cargo:Todos
      cExpHead       += '.and. cCodPgo >= "' + Rtrim( ::oGrupoFPago:Cargo:Desde ) + '" .and. cCodPgo <= "' + Rtrim( ::oGrupoFPago:Cargo:Hasta ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvP:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvP:cFile ), ::oFacPrvP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacPrvP:OrdKeyCount() )

   ::oFacPrvP:GoTop()

   while !::oFacPrvP:Eof()

      cCodGPrv    := RetFld( ::oFacPrvP:cCodPrv, ::oDbfPrv:cAlias, "cCodGrp" )

      if ( ::oGrupoGProveedor:Cargo:Todos .or. ( cCodGPrv >= ::oGrupoGProveedor:Cargo:Desde .AND. cCodGPrv <= ::oGrupoGProveedor:Cargo:Hasta ) ) .AND.;
         Empty( ::oFacPrvP:dEntrada )                                                                                                            .AND.;
         ( ::oEstadoDos:nAt == 1                                     .or.;
         ( ::oEstadoDos:nAt == 2 .and. Empty( ::oFacPrvP:cTipRec ) ) .or.;
         ( ::oEstadoDos:nAt == 3 .and. !Empty( ::oFacPrvP:cTipRec ) ) )

         ::oDbf:Append()

         ::oDbf:cTipDoc   := if( !Empty( ::oFacPrvP:cTipRec ), "Rectificativa", "Factura" )
         ::oDbf:cNumDoc   := ::oFacPrvP:cSerFac + "/" + AllTrim( Str( ::oFacPrvP:nNumFac ) ) + if( Empty( ::oFacPrvP:cSufFac ), "" + "-" + AllTrim( Str( ::oFacPrvP:nNumRec ) ), "/" + ::oFacPrvP:cSufFac + "-" + AllTrim( Str( ::oFacPrvP:nNumRec ) ) )
         ::oDbf:cCodGPrv  := cCodGPrv
         ::oDbf:cNomGPrv  := oRetFld( cCodGPrv, ::oGrpPrv:oDbf )
         ::oDbf:cCodPrv   := ::oFacPrvP:cCodPrv
         ::oDbf:cNomPrv   := ::oFacPrvP:cNomPrv
         ::oDbf:cCodFpg   := ::oFacPrvP:cCodPgo
         ::oDbf:cNomFpg   := oRetFld( ::oFacPrvP:cCodPgo, ::oDbfFpg )
         ::oDbf:dFecMov   := ::oFacPrvP:dPreCob
         ::oDbf:dFecPre   := ::oFacPrvP:dFecVto
         ::oDbf:cSuDoc    := ::oFacPrvT:cNumDoc
         ::oDbf:cDescrip  := ::oFacPrvP:cDesCrip
         ::oDbf:nImporte  := ::oFacPrvP:nImporte / ::oFacPrvP:nVdvPgo
         ::oDbf:cBanco    := AllTrim( cNombreBancoProvee( ::oFacPrvP:cCodPrv ) )
         //::oFacPrvP:cBncPrv
         ::oDbf:cCuenta   := Trans( cProveeCuenta( ::oFacPrvP:cCodPrv ), "@R ####-####-##-##########" )
         //::oFacPrvP:cEntPrv + "-" + ::oFacPrvP:cSucPrv + "-" + ::oFacPrvP:cDigPrv + "-" + ::oFacPrvP:cCtaPrv
         ::oDbf:cBncEmp   := ::oFacPrvP:cBncEmp
         ::oDbf:cCtaEmp   := ::oFacPrvP:cEntEmp + "-" + ::oFacPrvP:cSucEmp + "-" + ::oFacPrvP:cDigEmp + "-" + ::oFacPrvP:cCtaEmp

         ::oDbf:Save()

      end if

      ::oFacPrvP:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvP:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacPrvP:LastRec() )

   ::oFacPrvP:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvP:cFile ) )

   do case
      case ::oEstadoUno:nAt == 1
         ::oDbf:OrdSetFocus( "cNumDoc" )

      case ::oEstadoUno:nAt == 2
         ::oDbf:OrdSetFocus( "dFecMov" )

      case ::oEstadoUno:nAt == 3
         ::oDbf:OrdSetFocus( "dFecPre" )

   end case

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//