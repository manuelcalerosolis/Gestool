#include "FiveWin.ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfPreCli FROM TNewInfGen

   DATA   oFacCliP  AS OBJECT
   DATA   oFacCliT  AS OBJECT

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
   ::AddField( "cCodGCli",  "C",  4, 0, {|| "@!" },      "Grp. cli.",         .f., "Cod. grupo cliente",                 9, .f. )
   ::AddField( "cNomGCli",  "C", 30, 0, {|| "@!" },      "Grupo",             .f., "Nombre grupo",                      35, .f. )
   ::AddField( "cCodCli",   "C", 12, 0, {|| "@!" },      "Cod. cli.",         .f., "Cod. cliente",                       9, .f. )
   ::AddField( "cNomCli",   "C", 50, 0, {|| "@!" },      "Cliente",           .f., "Nombre cliente",                    35, .f. )
   ::AddField( "cCodFpg",   "C",  2, 0, {|| "@!" },      "Cod. pago",         .f., "Cod. pago",                          9, .f. )
   ::AddField( "cNomFpg",   "C", 30, 0, {|| "@!" },      "Forma de pago",     .f., "Forma de pago",                     35, .f. )
   ::AddField( "dFecMov",   "D",  8, 0, {|| "@!" },      "F. Exped.",         .t., "Fecha expedición",                  12, .f. )
   ::AddField( "dFecPre",   "D",  8, 0, {|| "@!" },      "F. Vncto.",         .t., "Fecha de vencimiento",              12, .f. )
   ::AddField( "cDescrip",  "C",100, 0, {|| "@!" },      "Descrip.",          .t., "Concepto del pago",                 50, .f. )
   ::AddField( "nImporte",  "N", 16, 3, {|| ::cPicOut }, "Importe",           .t., "Importe",                           15, .f. )
   ::AddField( "cBanco",    "C", 50, 0, {|| "@!" },      "Banco cliente",     .f., "Nombre del banco del cliente",      20, .f. )
   ::AddField( "cCuenta",   "C", 30, 0, {|| "@!" },      "Cuenta cliente",    .f., "Cuenta bancaria del cliente",       35, .f. )
   ::AddField( "cBncEmp",   "C", 50, 0, {|| "@!" },      "Banco empresa",     .f., "Nombre del banco de la empresa",    20, .f. )
   ::AddField( "cCtaEmp",   "C", 30, 0, {|| "@!" },      "Cuenta empresa",    .f., "Cuenta bancaria de la empresa",     35, .f. )

   ::AddTmpIndex ( "cNumDoc", "cNumDoc" )
   ::AddTmpIndex ( "dFecMov", "dFecMov" )
   ::AddTmpIndex ( "dFecPre", "dFecPre" )

   ::lExcCero  := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::oFacCliP := TDataCenter():oFacCliP()

      ::oFacCliT := TDataCenter():oFacCliT()

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   ::oFacCliP := nil
   ::oFacCliT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   ::dIniInf            := BoM( Month( Date() ) )
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

   if !::lGrupoGrupoCliente( .f. )
      return .f.
   end if

   if !::lGrupoCliente( .f. )
      return .f.
   end if

   if !::lGrupoFPago( .f. )
      return .f.
   end if

   ::oDefExcInf( 1515 )

   ::CreateFilter( aItmRecCli(), ::oFacCliP:cAlias )

   ::oMtrInf:SetTotal( ::oFacCliP:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cCodGCli
   local cExpHead := ""

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) } }

   if !::oGrupoGCliente:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Grp. cliente", 13 ) + ": " + AllTrim( ::oGrupoGCliente:Cargo:Desde ) + " > " + AllTrim( ::oGrupoGCliente:Cargo:Hasta ) } )
   end if

   if !::oGrupoCliente:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Cliente", 13 ) + ": " + AllTrim( ::oGrupoCliente:Cargo:Desde ) + " > " + AllTrim( ::oGrupoCliente:Cargo:Hasta ) } )
   end if

   if !::oGrupoFPago:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Forma de pago", 13 ) + ": " + AllTrim( ::oGrupoFPago:Cargo:Desde ) + " > " + AllTrim( ::oGrupoFPago:Cargo:Hasta ) } )
   end if

   ::oFacCliP:OrdSetFocus( "nNumFac" )

   if ::lExcCero
      cExpHead       := '!lCobrado .and. ( ( dFecVto >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) ) .or. Empty( dFecVto ) )'
   else
      cExpHead       := '!lCobrado .and. ( ( dFecVto >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) ) )'
   end if

   if !::oGrupoCliente:Cargo:Todos
      cExpHead    += '.and. cCodCli >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde ) + '" .and. cCodCli <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoFPago:Cargo:Todos
      cExpHead    += '.and. cCodPgo >= "' + Rtrim( ::oGrupoFPago:Cargo:Desde ) + '" .and. cCodPgo <= "' + Rtrim( ::oGrupoFPago:Cargo:Hasta ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliP:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliP:cFile ), ::oFacCliP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliP:OrdKeyCount() )

   ::oFacCliP:GoTop()

   while !::oFacCliP:Eof()

      cCodGCli     := oRetFld( ::oFacCliP:cCodCli, ::oGrpCli:oDbf, "cCodGrp" )

      if ( ::oGrupoGCliente:Cargo:Todos .or. ( cCodGCli >= ::oGrupoGCliente:Cargo:Desde .AND. cCodGCli <= ::oGrupoGCliente:Cargo:Hasta ) )    .AND.;
         Empty( ::oFacCliP:dEntrada )                                                                                                         .AND.;
         ( ::oEstadoDos:nAt == 1                                     .or.;
         ( ::oEstadoDos:nAt == 2 .and. Empty( ::oFacCliP:cTipRec ) ) .or.;
         ( ::oEstadoDos:nAt == 3 .and. !Empty( ::oFacCliP:cTipRec ) ) )

         ::oDbf:Append()

         ::oDbf:cTipDoc   := if( !Empty( ::oFacCliP:cTipRec ), "Rectificativa", "Factura" )
         ::oDbf:cNumDoc   := ::oFacCliP:cSerie + "/" + AllTrim( Str( ::oFacCliP:nNumFac ) ) + if( Empty( ::oFacCliP:cSufFac ), "" + "-" + AllTrim( Str( ::oFacCliP:nNumRec ) ), "/" + ::oFacCliP:cSufFac + "-" + AllTrim( Str( ::oFacCliP:nNumRec ) ) )
         ::oDbf:cCodGCli  := cCodGCli
         ::oDbf:cNomGCli  := oRetFld( cCodGCli, ::oGrpCli:oDbf )
         ::oDbf:cCodCli   := ::oFacCliP:cCodCli
         ::oDbf:cNomCli   := ::oFacCliP:cNomCli
         ::oDbf:cCodFpg   := ::oFacCliP:cCodPgo
         ::oDbf:cNomFpg   := oRetFld( ::oFacCliP:cCodPgo, ::oDbfFpg )
         ::oDbf:dFecMov   := ::oFacCliP:dPreCob
         ::oDbf:dFecPre   := ::oFacCliP:dFecVto
         ::oDbf:cDescrip  := ::oFacCliP:cDesCrip
         ::oDbf:nImporte  := ::oFacCliP:nImporte / ::oFacCliP:nVdvPgo
         ::oDbf:cBanco    := ::oFacCliP:cBncCli
         ::oDbf:cCuenta   := Trans( cClientCuenta( ::oFacCliP:cCodCli ), "@R ####-####-##-##########" )
         //::oFacCliP:cEntCli + "-" + ::oFacCliP:cSucCli + "-" + ::oFacCliP:cDigCli + "-" + ::oFacCliP:cCtaCli
         ::oDbf:cBncEmp   := ::oFacCliP:cBncEmp
         ::oDbf:cCtaEmp   := ::oFacCliP:cEntEmp + "-" + ::oFacCliP:cSucEmp + "-" + ::oFacCliP:cDigEmp + "-" + ::oFacCliP:cCtaEmp

         ::oDbf:Save()

      end if

      ::oFacCliP:Skip()

      ::oMtrInf:AutoInc( ::oFacCliP:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacCliP:LastRec() )

   ::oFacCliP:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliP:cFile ) )

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