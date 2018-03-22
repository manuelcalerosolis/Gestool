#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfEntPedPgo FROM TInfGen

   DATA  oPedCliT AS OBJECT
   DATA  oPedCliL AS OBJECT
   DATA  oPedCliP AS OBJECT
   DATA  oDbfIva  AS OBJECT
   DATA  oDivisas AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()


   ::AddField( "cNumEnt",  "C",  14, 0, {|| "@!" },      "Documento",         .t., "Documento",                   18, .f. )
   ::AddField( "dEntrega", "D",   8, 0, {|| "@!" },      "Fecha",             .t., "Fecha de la entrega",         12, .f. )
   ::AddField( "dFecPed",  "D",   8, 0, {|| "@!" },      "Fecha pedido",      .f., "Fecha del pedido",            12, .f. )
   ::AddField( "cCodCli",  "C",  12, 0, {|| "@!" },      "Cód. cli.",         .t., "Código cliente",               8, .f. )
   ::AddField( "cNomCli",  "C",  50, 0, {|| "@!" },      "Cliente",           .t., "Nombre cliente",              30, .f. )
   ::AddField( "cDescrip", "C", 100, 0, {|| "@!" },      "Concepto",          .t., "Concepto de la entrega",      30, .f. )
   ::AddField( "cPgdoPor", "C",  50, 0, {|| "@!" },      "Pagado por.",       .f., "Pagado por",                  12, .f. )
   ::AddField( "nImporte", "N",  16, 6, {|| ::cPicOut }, "Importe",           .t., "Importe de la entrega",       12, .t. )
   ::AddField( "nTotal",   "N",  16, 6, {|| ::cPicOut }, "Total",             .t., "Total pedido",                12, .t. )
   ::AddField( "cNumPed",  "C",  12, 0, {|| "@!" },      "Pedido",            .f., "Pedido",                      12, .f. )
   ::AddField( "cCodCaj",  "C",   3, 0, {|| "@!" },      "Caja",              .f., "Código de la caja",           12, .f. )
   ::AddField( "cCodAge",  "C",   3, 0, {|| "@!" },      "Agente",            .f., "Código del agente",           12, .f. )
   ::AddField( "cCodPgo",  "C",   2, 0, {|| "@!" },      "Fp",                .f., "Forma de pago",               12, .f. )
   ::AddField( "cNomPgo",  "C",  30, 0, {|| "@!" },      "Forma de pago",     .f., "Nombre de la forma de pago",  12, .f. )

   ::AddTmpIndex( "CCODPGO", "CCODPGO" )

   ::AddGroup( {|| ::oDbf:cCodPgo }, {|| "Forma pago: " + Rtrim( ::oDbf:cCodPgo ) + "-" + AllTrim( ::oDbf:cNomPgo ) }, {|| "Total forma pago..." } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::oPedCliT := TDataCenter():oPedCliT()

      DATABASE NEW ::oPedCliL PATH ( cPatEmp() )   FILE "PEDCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

      DATABASE NEW ::oPedCliP PATH ( cPatEmp() )   FILE "PEDCLIP.DBF"   VIA ( cDriver() ) SHARED INDEX "PEDCLIP.CDX"

      DATABASE NEW ::oDbfIva  FILE "TIVA.DBF"      PATH ( cPatDat() )   VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      DATABASE NEW ::oDivisas FILE "DIVISAS.DBF"   PATH ( cPatDat() )   VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos de pedidos" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPedCliP ) .and. ::oPedCliP:Used()
      ::oPedCliP:End()
   end if

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if

   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   if !Empty( ::oDivisas ) .and. ::oDivisas:Used()
      ::oDivisas:End()
   end if

   ::oPedCLiT  := nil
   ::oPedCliL  := nil
   ::oPedCliP  := nil
   ::oDbfIva   := nil
   ::oDivisas  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   if !::StdResource( "INFENTPED" )
      return .f.
   end if

   if !::oDefFpgInf( 100, 101, 110, 111, 120 )
      return .f.
   end if

   if !::oDefCliInf( 130, 131, 140, 141, , 150 )
      return .f.
   end if

   ::CreateFilter( aPedCliPgo(), ::oPedCliP:cAlias )

   ::oMtrInf:SetTotal( ::oPedCliP:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpresion  := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                           {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                           {|| "F. pago  : " + if( ::lAllFpg, "Todas", AllTrim( ::cFpgDes ) + " > " + AllTrim( ::cFpgHas ) ) },;
                           {|| "Clientes : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) } }

   ::oPedCliP:OrdSetFocus( "dEntrega" )

   cExpresion        := '!lPasado .and. dEntrega >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dEntrega <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllFpg
      cExpresion     += ' .and. cCodPgo >= "' + Rtrim( ::cFpgDes ) + '" .and. cCodPgo <= "' + Rtrim( ::cFpgHas ) + '"'
   end if

   if !::lAllCli
      cExpresion     += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpresion     += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedCliP:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedCliP:cFile ), ::oPedCliP:OrdKey(), ( cExpresion ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedCliP:OrdKeyCount() )

   ::oPedCliP:GoTop()

   while !::lBreak .and. !::oPedCliP:Eof()

      if lChkSer( ::oPedCliP:cSerPed, ::aSer )

         ::oDbf:Append()

         if ::oPedCliT:Seek( ::oPedCLiP:cSerPed + Str( ::oPedCliP:nNumPed ) + ::oPedCliP:cSufPed )

            ::oDbf:cNomCli  := ::oPedCliT:cNomCli
            ::oDbf:dFecPed  := ::oPedCliT:dFecPed

         end if

         ::oDbf:cNumEnt     := ::oPedCLiP:cSerPed + "/" + AllTrim( Str( ::oPedCliP:nNumPed ) ) + "/" + ::oPedCliP:cSufPed + "-" + AllTrim( Str( ::oPedCliP:nNumRec ) )
         ::oDbf:dEntrega    := ::oPedCliP:dEntrega
         ::oDbf:cCodCli     := ::oPedCliP:cCodCli
         ::oDbf:nImporte    := ::oPedCliP:nImporte
         ::oDbf:cDescrip    := ::oPedCliP:cDesCrip
         ::oDbf:cPgdoPor    := ::oPedCliP:cPgdoPor
         ::oDbf:cNumPed     := ::oPedCLiP:cSerPed + "/" + AllTrim( Str( ::oPedCliP:nNumPed ) ) + "/" + ::oPedCliP:cSufPed
         ::oDbf:cCodCaj     := ::oPedCliP:cCodCaj
         ::oDbf:cCodAge     := ::oPedCliP:cCodAge
         ::oDbf:cCodPgo     := ::oPedCliP:cCodPgo
         ::oDbf:cNomPgo     := cNbrFPago( ::oPedCliP:cCodPgo, ::oDbfFpg )
         ::oDbf:nTotal      := nTotPedCli( ::oPedCLiP:cSerPed + Str( ::oPedCliP:nNumPed ) + ::oPedCliP:cSufPed, ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfFpg:cAlias, nil, nil, .f. )

         ::oDbf:Save()

      end if

      ::oPedCliP:Skip()

      ::oMtrInf:AutoInc( ::oPedCliP:OrdKeyNo() )

   end while

   ::oPedCliP:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedCliP:cFile ) )

   ::oMtrInf:AutoInc( ::oPedCliP:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//