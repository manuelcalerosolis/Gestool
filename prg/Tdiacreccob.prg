#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDiaCRecCob FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lExcCredito AS LOGIC    INIT .f.
   DATA  oDbfIva     AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oTikCliP    AS OBJECT
   DATA  oTikCliT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTipDoc", "C",  8, 0, {|| "" },                          "Tipo",       .t., "Tipo de documento",         10 )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },                        "Doc.",       .t., "Documento",                 14 )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },                        "Fecha",      .t., "Fecha de expedición",       14 )
   ::AddField( "dFecCob", "D",  8, 0, {|| "@!" },                        "Cobro",      .t., "Fecha de cobro",            14 )
   ::AddField( "dFecVto", "D",  8, 0, {|| "@!" },                        "Vencimiento",.t., "Fecha de vencimiento",      14 )
   ::AddField( "cCodCaj", "C",  3, 0, {|| "@!" },                        "Caja",       .f., "Código de caja",            14 )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },                        "Cod. cli.",  .t., "Código cliente",             8 )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },                        "Cliente",    .t., "Nombre cliente",            40 )
   ::AddField( "cFpgPgo", "C",  2, 0, {|| "" },                          "FP",         .t., "Forma de pago del recibo",   2 )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },                   "Total",      .t., "Total",                     10 )
   ::AddField( "cBanco",  "C", 50, 0, {|| "@!" },                        "Banco",      .f., "Nombre del banco",          20 )
   ::AddField( "cCuenta", "C", 30, 0, {|| "@!" },                        "Cuenta",     .f., "Cuenta bancaria",           35 )

   ::AddTmpIndex( "DFECMOV", "CCODCLI + Dtos( DFECMOV )" )

   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) }, {|| "Total cliente..." } )

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Cliente : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) } }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCRecCob

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   ::oFacCliP     := TDataCenter():oFacCliP()

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliP  PATH ( cPatEmp() ) FILE "TIKEP.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKEP.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )

      ::CloseFiles()
      
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaCRecCob

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliP ) .and. ::oTikCliP:Used()
      ::oTikCliP:End()
   end if

   ::oDbfIva   := nil
   ::oFacCliP  := nil
   ::oTikCliT  := nil
   ::oTikCliP  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TDiaCRecCob

   ::StdResource( "INFDIARECCOB" )

   // Creamos el filtro

   ::CreateFilter( , ::oDbf, .t. )   

   // Monta los obras de manera automatica

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   // Damos valor al meter

   ::oMtrInf:SetTotal( ::oFacCliP:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaCRecCob

   local cCodCli  := ""
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   cExpHead          := ' lCobrado .and. dEntrada >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dEntrada <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if 

   ::oFacCliP:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliP:cFile ), ::oFacCliP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliP:OrdKeyCount() )

   ::oFacCliP:GoTop()

   while !::lBreak .and. !::oFacCliP:Eof()

      if lChkSer( ::oFacCliP:cSerie, ::aSer ) .and. !( ::lExcCero .and. nTotRecCli( ::oFacCliP, ::oDbfDiv ) == 0 )

         ::oDbf:Append()

         ::oDbf:cCodCli    := ::oFacCliP:cCodCli

         if ::oDbfCli:Seek( ::oFacCliP:cCodCli )
            ::oDbf:cNomCli := ::oDbfCli:Titulo
         end if

         ::oDbf:dFecMov    := ::oFacCliP:dPreCob
         ::oDbf:dFecCob    := ::oFacCliP:dEntrada
         ::oDbf:dFecVto    := ::oFacCliP:dFecVto

         ::oDbf:cCodCaj    := ::oFacCliP:cCodCaj

         ::oDbf:nTotDoc    := nTotRecCli( ::oFacCliP, ::oDbfDiv )
         ::oDbf:cDocMov    := ::oFacCliP:cSerie + "/" + AllTrim( Str( ::oFacCliP:nNumFac ) ) + "/" + ::oFacCliP:cSufFac
         ::oDbf:cTipDoc    := "Factura"
         ::oDbf:cBanco     := ::oFacCliP:cBncCli
         ::oDbf:cCuenta    := ::oFacCliP:cEntCli + "-" + ::oFacCliP:cSucCli + "-" + ::oFacCliP:cDigCli + "-" + ::oFacCliP:cCtaCli

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc( ::oFacCliP:OrdKeyNo() )

      ::oFacCliP:Skip()

   end while

   ::oFacCliP:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliP:cFile ) )

   /*
   Ahora sobre los tikets------------------------------------------------------
   */

   cExpHead       := ' dPgoTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dPgoTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if 

   ::oTikCliP:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliP:cFile ), ::oTikCliP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliP:OrdKeyCount() )

   ::oTikCliP:GoTop()

   while !::oTikCliP:Eof()

      cCodCli  := oRetFld( ::oTikCliP:cSerTik + ::oTikCliP:cNumTik + ::oTikCliP:cSufTik, ::oTikCliT, "cCliTik" )

      if lChkSer( ::oTikCliP:cSerTik, ::aSer ) .and. ( ::lAllCli .or. ( cCodCli >= ::cCliOrg .and. cCodCli <= ::cCliDes ) )

            ::oDbf:Append()

            ::oDbf:cCodCli    := cCodCli
            ::oDbf:cNomCli    := oRetFld( cCodCli, ::oDbfCli, "Titulo" )

            ::oDbf:dFecMov    := ::oTikCliP:dPgoTik
            ::oDbf:dFecCob    := ::oTikCliP:dPgoTik
            ::oDbf:dFecVto    := ::oTikCliP:dPgoTik

            ::oDbf:cCodCaj    := ::oTikCliP:cCodCaj

            ::oDbf:nTotDoc    := nTotUCobTik( ::oTikCliP, ::nDerOut, ::nValDiv )
            ::oDbf:cDocMov    := ::oTikCliP:cSerTik + "/" + AllTrim( Right( ::oTikCliP:cNumTik, 9 ) ) + "/" + ::oTikCliP:cSufTik
            ::oDbf:cFpgPgo    := ::oTikCliP:cFpgPgo
            ::oDbf:cTipDoc    := "Tiket"

            ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc( ::oTikCliP:OrdKeyNo() )

      ::oTikCliP:Skip()

   end while

   ::oTikCliP:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliP:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliP:Lastrec() )

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//