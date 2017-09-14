#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDiarioRecibos FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oTikCliP    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "No cobrados", "Cobrados", "Todos" }
   DATA  lExcCredito AS LOGIC    INIT .f.
   DATA  oDbfPago    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create() CLASS TDiarioRecibos

   ::AddField( "cModDoc", "C", 15, 0, {|| "@!" },        "Cobro o pago",        .f., "Cobro o pago",              15 )
   ::AddField( "cTipDoc", "C", 40, 0, {|| "@!" },        "Tipo",                .t., "Tipo de documento",         30 )
   ::AddField( "cDocMov", "C", 18, 0, {|| "@!" },        "Doc.",                .t., "Documento",                 15 )
   ::AddField( "cCodDel", "C",  2, 0, {|| "@!" },        "Deleg.",              .f., "Delegación",                15 )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },        "Fecha",               .t., "Fecha de expedición",       14 )
   ::AddField( "dFecCob", "D",  8, 0, {|| "@!" },        "Cobro",               .t., "Fecha de cobro",            14 )
   ::AddField( "dFecVto", "D",  8, 0, {|| "@!" },        "Vencimiento",         .t., "Fecha de vencimiento",      14 )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },        "Código",              .t., "Código",                     8 )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },        "Cliente/Proveedor",   .t., "Cliente/Proveedor",         40 )
   ::AddField( "cFpgPgo", "C",  2, 0, {|| "@!" },        "FP",                  .t., "Código forma de pago",       4 )
   ::AddField( "cNomPgo", "C",150, 0, {|| "@!" },        "Forma pago",          .f., "Nombre forma de pago",      25 )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },   "Total",               .t., "Total",                     18 )
   ::AddField( "cBanco",  "C", 50, 0, {|| "@!" },        "Banco",               .f., "Nombre del banco",          20 )
   ::AddField( "cCuenta", "C", 30, 0, {|| "@!" },        "Cuenta",              .f., "Cuenta bancaria",           35 )

   ::AddTmpIndex( "dFecMov", "cModDoc + Dtos ( dFecMov )" )

   ::AddGroup( {|| ::oDbf:cModDoc }, {|| Rtrim( ::oDbf:cModDoc ) } )

   ::dIniInf      := GetSysDate()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Cliente   : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                        {|| "Proveedor : " + if( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim( ::cPrvDes ) ) },;
                        {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiarioRecibos

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      ::oFacCliP := TDataCenter():oFacCliP()

      DATABASE NEW ::oFacPrvP  PATH ( cPatEmp() ) FILE "FACPRVP.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

      DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

      DATABASE NEW ::oTikCliP  PATH ( cPatEmp() ) FILE "TIKEP.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKEP.CDX"

      DATABASE NEW ::oDbfPago  PATH ( cPatEmp() ) FILE "FPAGO.DBF"   VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiarioRecibos

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if
   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliP ) .and. ::oTikCliP:Used()
      ::oTikCliP:End()
   end if
   if !Empty( ::oDbfPago ) .and. ::oDbfPago:Used()
      ::oDbfPago:End()
   end if

   ::oDbfIva   := nil
   ::oFacCliP  := nil
   ::oFacPrvP  := nil
   ::oTikCliT  := nil
   ::oTikCliP  := nil
   ::oDbfPago  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TDiarioRecibos

   local cEstado := "Todos"

   ::StdResource( "InfDiarioRecibos" )

   ::oBtnFilter:Disable()

   /*
   Monta los obras de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   if !::oDefPrvInf( 410, 420, 430, 440, 400 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliP:Lastrec() )

   REDEFINE CHECKBOX ::lExcCredito ;
      ID       191;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiarioRecibos

   local cCodCli     := ""
   local cExpHead    := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lCobrado .and. dPreCob >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dPreCob <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lCobrado.and. dEntrada >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dEntrada <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      otherwise
         cExpHead    := 'dPreCob >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dPreCob <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   ::oFacCliP:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliP:cFile ), ::oFacCliP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliP:OrdKeyCount() )

   ::oFacCliP:GoTop()

   while !::lBreak .and. !::oFacCliP:Eof()

      if !( ::lExcCredito .and. lClienteBloquearRiesgo( ::oFacCliP:cCodCli, ::oDbfCli:cAlias ) )          .and.;
         lChkSer( ::oFacCliP:cSerie, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if !( ::lExcCero .AND. nTotRecCli( ::oFacCliP, ::oDbfDiv ) == 0 )

            ::oDbf:Append()

            ::oDbf:cCodCli    := ::oFacCliP:cCodCli

            if ::oDbfCli:Seek( ::oFacCliP:cCodCli )
               ::oDbf:cNomCli := ::oDbfCli:Titulo
            end if

            ::oDbf:cModDoc    := "Cobro"
            ::oDbf:dFecMov    := ::oFacCliP:dPreCob
            ::oDbf:dFecCob    := ::oFacCliP:dEntrada
            ::oDbf:dFecVto    := ::oFacCliP:dFecVto
            ::oDbf:nTotDoc    := nTotRecCli( ::oFacCliP, ::oDbfDiv )
            ::oDbf:cDocMov    := ::oFacCliP:cSerie + "/" + AllTrim( Str( ::oFacCliP:nNumFac ) ) + "-" + AllTrim( Str( ::oFacCliP:nNumRec ) )
            ::oDbf:cCodDel    := ::oFacCliP:cSufFac
            ::oDbf:cTipDoc    := if( Empty( ::oFacCliP:cTipRec ), "Factura cliente", "Rectificativa cliente" )
            ::oDbf:cFpgPgo    := ::oFacCliP:cCodPgo
            ::oDbf:cNomPgo    := oRetFld( ::oFacCliP:cCodPgo, ::oDbfPago )
            ::oDbf:cBanco     := ::oFacCliP:cBncCli
            ::oDbf:cCuenta    := ::oFacCliP:cEntCli + "-" + ::oFacCliP:cSucCli + "-" + ::oFacCliP:cDigCli + "-" + ::oFacCliP:cCtaCli

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc( ::oFacCliP:OrdKeyNo() )

      ::oFacCliP:Skip()

   end while

   ::oFacCliP:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliP:cFile ) )

   /*
   Ahora sobre los tikets------------------------------------------------------
   */

   if ::oEstado:nAt > 1

      cExpHead       := 'dPgoTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dPgoTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

      ::oTikCliP:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliP:cFile ), ::oTikCliP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:SetTotal( ::oTikCliP:OrdKeyCount() )

      ::oTikCliP:GoTop()

      while !::oTikCliP:Eof()

         cCodCli  := oRetFld( ::oTikCliP:cSerTik + ::oTikCliP:cNumTik + ::oTikCliP:cSufTik, ::oTikCliT, "cCliTik" )

         if ::lAllCli .or. ( cCodCli >= ::cCliOrg .and. cCodCli <= ::cCliDes )

            if !( ::lExcCredito .and. lClienteBloquearRiesgo( cCodCli, ::oDbfCli:cAlias ) )   .and.;
               !( ::lExcCero .and. nTotUCobTik( ::oTikCliP, ::nDerOut, ::nValDiv ) == 0 )    .and.;
               lChkSer( ::oTikCliP:cSerTik, ::aSer )

               ::oDbf:Append()

               ::oDbf:cModDoc    := "Cobro"

               ::oDbf:cCodCli    := cCodCli
               ::oDbf:cNomCli    := oRetFld( cCodCli, ::oDbfCli, "Titulo" )

               ::oDbf:dFecMov    := ::oTikCliP:dPgoTik
               ::oDbf:dFecCob    := ::oTikCliP:dPgoTik
               ::oDbf:dFecVto    := ::oTikCliP:dPgoTik
               ::oDbf:nTotDoc    := nTotUCobTik( ::oTikCliP, ::nDerOut, ::nValDiv )
               ::oDbf:cDocMov    := ::oTikCliP:cSerTik + "/" + AllTrim( Right( ::oTikCliP:cNumTik, 9 ) ) + "-" + AllTrim( Str( ::oTikCliP:nNumRec ) )
               ::oDbf:cCodDel    := ::oTikCliP:cSufTik
               ::oDbf:cFpgPgo    := ::oTikCliP:cFpgPgo
               ::oDbf:cNomPgo    := oRetFld( ::oTikCliP:cFpgPgo, ::oDbfPago )
               ::oDbf:cTipDoc    := if( oRetFld( ::oTikCliP:cSerTik + ::oTikCliP:cNumTik + ::oTikCliP:cSufTik, ::oTikCliT, "lFreTik", "CNUMTIK" ), "Cheque regalo", "Tiket cliente" )

               ::oDbf:Save()

            end if

         end if

         ::oMtrInf:AutoInc( ::oTikCliP:OrdKeyNo() )

         ::oTikCliP:Skip()

      end while

      ::oTikCliP:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliP:cFile ) )

   end if

   ::oMtrInf:AutoInc( ::oTikCliP:Lastrec() )

   /*
   Factura de proveedores------------------------------------------------------
   */

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lCobrado .and. dPreCob >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dPreCob <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lCobrado.and. dEntrada >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dEntrada <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      otherwise
         cExpHead    := 'dPreCob >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dPreCob <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllPrv
      cExpHead       += ' .and. cCodPrv >= "' + Rtrim( ::cPrvOrg ) + '" .and. cCodPrv <= "' + Rtrim( ::cPrvDes ) + '"'
   end if

   ::oFacPrvP:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvP:cFile ), ::oFacPrvP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacPrvP:OrdKeyCount() )

   ::oFacPrvP:GoTop()
   while !::lBreak .and. !::oFacPrvP:Eof()

      if lChkSer( ::oFacPrvP:cSerFac, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if !( ::lExcCero .AND. nTotRecPrv( ::oFacPrvP:cAlias, ::oDbfDiv:cAlias, ::cDivInf ) == 0 )

            ::oDbf:Append()

            ::oDbf:cModDoc    := "Pago"
            ::oDbf:cCodCli    := ::oFacPrvP:cCodPrv
            ::oDbf:cNomCli    := oRetFld( ::oFacPrvP:cCodPrv, ::oDbfPrv, "Titulo" )
            ::oDbf:dFecMov    := ::oFacPrvP:dPreCob
            ::oDbf:dFecCob    := ::oFacPrvP:dEntrada
            ::oDbf:dFecVto    := ::oFacPrvP:dFecVto
            ::oDbf:nTotDoc    := nTotRecPrv( ::oFacPrvP:cAlias, ::oDbfDiv:cAlias, ::cDivInf )
            ::oDbf:cDocMov    := AllTrim( ::oFacPrvP:cSerFac ) + "/" + AllTrim( Str( ::oFacPrvP:nNumFac ) )+ "/" + AllTrim( ::oFacPrvP:cSufFac )
            ::oDbf:cCodDel    := ::oFacPrvP:cSufFac
            ::oDbf:cTipDoc    := "Factura proveedor"
            ::oDbf:cFpgPgo    := ::oFacPrvP:cCodPgo
            ::oDbf:cNomPgo    := oRetFld( ::oFacPrvP:cCodPgo, ::oDbfPago )
            ::oDbf:cBanco     := ::oFacPrvP:cBncPrv
            ::oDbf:cCuenta    := ::oFacPrvP:cEntPrv + "-" + ::oFacPrvP:cSucPrv + "-" + ::oFacPrvP:cDigPrv + "-" + ::oFacPrvP:cCtaPrv

            ::oDbf:Save()

         end if

      end if

      ::oFacPrvP:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvP:OrdKeyNo() )

   end while

   ::oFacPrvP:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvP:cFile ) )

   ::oMtrInf:AutoInc( ::oFacPrvP:LastRec() )

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//