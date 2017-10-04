#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfEntAlbPgo FROM TInfGen

   DATA  oAlbCliT AS  OBJECT
   DATA  oAlbCliP AS  OBJECT

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()


   ::AddField( "cNumEnt",  "C",  14, 0, {|| "@!" },      "Documento",        .t., "Documento",                18, .f. )
   ::AddField( "dEntrega", "D",   8, 0, {|| "@!" },      "Fecha",            .t., "Fecha de la entrega",      12, .f. )
   ::AddField( "dFecAlb",  "D",   8, 0, {|| "@!" },      "Fecha albarán",    .f., "Fecha del albarán",        12, .f. )
   ::AddField( "cCodCli",  "C",  12, 0, {|| "@!" },      "Cód. cli.",        .t., "Código cliente",            8, .f. )
   ::AddField( "cNomCli",  "C",  50, 0, {|| "@!" },      "Cliente",          .t., "Nombre cliente",           30, .f. )
   ::AddField( "cDescrip", "C", 100, 0, {|| "@!" },      "Concepto",         .t., "Concepto de la entrega",   30, .f. )
   ::AddField( "cPgdoPor", "C",  50, 0, {|| "@!" },      "Pagado por.",      .f., "Pagado por",               12, .f. )
   ::AddField( "nImporte", "N",  16, 6, {|| ::cPicOut }, "Importe",          .t., "Importe de la entrega",    12, .t. )
   ::AddField( "cNumAlb",  "C",  12, 0, {|| "@!" },      "Albarán",          .f., "Albarán",                  12, .f. )
   ::AddField( "cCodCaj",  "C",   3, 0, {|| "@!" },      "Caja",             .f., "Código de la caja",        12, .f. )
   ::AddField( "cCodAge",  "C",   3, 0, {|| "@!" },      "Agente",           .f., "Código del agente",        12, .f. )
   ::AddField( "cCodPgo",  "C",   2, 0, {|| "@!" },      "F. pago",          .f., "Forma de pago",            12, .f. )
   ::AddField( "cNomPgo",  "C",  30, 0, {|| "@!" },      "Pago",             .f., "Nombre de la f. Pago",     12, .f. )

   ::AddTmpIndex( "CCODPGO", "CCODPGO" )

   ::AddGroup( {|| ::oDbf:cCodPgo }, {|| "F. Pago: " + Rtrim( ::oDbf:cCodPgo ) + "-" + AllTrim( ::oDbf:cNomPgo ) }, {|| "Total f. pago..." } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()
   DATABASE NEW ::oAlbCliP PATH ( cPatEmp() )   FILE "ALBCLIP.DBF"   VIA ( cDriver() ) SHARED INDEX "ALBCLIP.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbCliP ) .and. ::oAlbCliP:Used()
      ::oAlbCliP:End()
   end if
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliP := nil

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

   ::CreateFilter( aItmAlbPgo(), ::oAlbCliP:cAlias )

   ::oMtrInf:SetTotal( ::oAlbCliP:Lastrec() )

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

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "F. pago  : " + if( ::lAllFpg, "Todas", AllTrim( ::cFpgDes ) + " > " + AllTrim( ::cFpgHas ) ) },;
                        {|| "Clientes : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) } }

   ::oAlbCliP:OrdSetFocus( "dEntrega" )

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

   ::oAlbCliP:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliP:cFile ), ::oAlbCliP:OrdKey(), ( cExpresion ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliP:OrdKeyCount() )

   ::oAlbCliP:GoTop()

   while !::lBreak .and. !::oAlbCliP:Eof()

      if lChkSer( ::oAlbCliP:cSerAlb, ::aSer )

         ::oDbf:Append()

         ::oDbf:cNumEnt     := ::oAlbCLiP:cSerAlb + "/" + AllTrim( Str( ::oAlbCliP:nNumAlb ) ) + "/" + ::oAlbCliP:cSufAlb + "-" + AllTrim( Str( ::oAlbCliP:nNumRec ) )
         ::oDbf:dEntrega    := ::oAlbCliP:dEntrega
         ::oDbf:cCodCli     := ::oAlbCliP:cCodCli
         if ::oAlbCliT:Seek( ::oAlbCLiP:cSerAlb + Str( ::oAlbCliP:nNumAlb ) + ::oAlbCliP:cSufAlb )
            ::oDbf:cNomCli  := ::oAlbCliT:cNomCLi
            ::oDbf:dFecAlb  := ::oAlbCliT:dFecAlb
         end if
         ::oDbf:nImporte    := ::oAlbCliP:nImporte
         ::oDbf:cDescrip    := ::oAlbCliP:cDesCrip
         ::oDbf:cPgdoPor    := ::oAlbCliP:cPgdoPor
         ::oDbf:cNumAlb     := ::oAlbCLiP:cSerAlb + "/" + AllTrim( Str( ::oAlbCliP:nNumAlb ) ) + "/" + ::oAlbCliP:cSufAlb
         ::oDbf:cCodCaj     := ::oAlbCliP:cCodCaj
         ::oDbf:cCodAge     := ::oAlbCliP:cCodAge
         ::oDbf:cCodPgo     := ::oAlbCliP:cCodPgo
         ::oDbf:cNomPgo     := cNbrFPago( ::oAlbCliP:cCodPgo, ::oDbfFpg )

         ::oDbf:Save()

      end if

      ::oAlbCliP:Skip()

      ::oMtrInf:AutoInc( ::oAlbCliP:OrdKeyNo() )

   end while

   ::oAlbCliP:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliP:cFile ) )

   ::oMtrInf:AutoInc( ::oAlbCliP:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//