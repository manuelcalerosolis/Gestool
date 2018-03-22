#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfKit FROM TInfGen

   DATA  oDbfKit     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

   END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },            "Código",        .t.,  "Código artículo",          8 )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },            "Componente",    .t.,  "Descripción breve",       50 )
   ::AddField( "cCodEsc", "C", 18, 0, {|| "@!" },            "Cód.",          .f.,  "Código",                   8 )
   ::AddField( "cNomEsc", "C", 50, 0, {|| "@!" },            "Compuesto",     .f.,  "Compuesto",               50 )
   ::AddField( "nUndKit", "N", 16, 6, {|| MasEsc() },        cNombreUnidades(),.t.,  cNombreunidades() + " de escandallo",  12 )
   ::AddField( "cUniDad", "C",  2, 0, {|| "@!" },            "Und.",          .t.,  "Unidad de medición",       4 )
   ::AddField( "nPreKit", "N", 16, 6, {|| ::cPicImp },       "Precio",        .f.,  "Precio de escandallo",    12 )
   ::AddField( "nTotal",  "N", 16, 6, {|| ::cPicImp },       "Total",         .f.,  "Total",                   12 )

   ::AddTmpIndex( "cCodEsc", "cCodEsc" )

   ::AddGroup( {|| ::oDbf:cCodEsc },{|| "Compuesto : " + Rtrim( ::oDbf:cCodEsc ) + "-" + Rtrim( ::oDbf:cNomEsc ) }, {||"Total compuesto..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfKit PATH ( cPatArt() ) FILE "ARTKIT.DBF" VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"
   ::oDbfKit:OrdSetFocus( "cCodKit" )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfKit ) .and. ::oDbfKit:Used()
      ::oDbfKit:End()
   end if

   ::oDbfKit := nil


RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.

   if !::StdResource( "INF_ESCAN" )
      return .f.
   end if

   /*
   Monta los Artículos de manera automatica
   */

   if !::lDefArtInf( 70, 80, 90, 100, 800 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfKit:Lastrec() )

   ::CreateFilter( aItmKit(), ::oDbfKit:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Artículos : " + AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) } }

   ::oDbfKit:OrdSetFocus( "CCODKIT" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfKit:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfKit:cFile ), ::oDbfKit:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oDbfKit:GoTop()

   while !::lBreak .and. !::oDbfKit:Eof()

      if ( ::lAllArt .or.( ::oDbfKit:cCodKit >= ::cArtOrg .and. ::oDbfKit:cCodKit <= ::cArtDes ) ) .AND.;
         ::oDbfArt:Seek( ::oDbfKit:cRefKit )

         while ::oDbfKit:cRefKit == ::oDbfArt:Codigo .and. !::oDbfArt:Eof()

            ::oDbf:Append()

            ::oDbf:cCodArt := ::oDbfArt:Codigo
            ::oDbf:cNomArt := ::oDbfArt:Nombre
            ::oDbf:cCodEsc := ::oDbfKit:cCodKit
            ::oDbf:cNomEsc := RetArticulo( ::oDbfKit:cCodKit, ::oDbfArt )
            ::oDbf:nUndKit := ::oDbfKit:nUndKit
            ::oDbf:cUniDad := ::oDbfKit:cUniDad
            ::oDbf:nPreKit := nCosto( ::oDbf:cCodArt, ::oDbfArt:cAlias, ::oDbfKit:cAlias, .f., ::cDivInf, ::oDbfDiv:cAlias )
            ::oDbf:nTotal := ::oDbf:nUndKit * ::oDbf:nPreKit

            ::oDbf:Save()

            ::oDbfArt:Skip()

         end while

      end if

      ::oDbfKit:Skip()

      ::oMtrInf:AutoInc( ::oDbfKit:OrdKeyNo() )

   end while

   ::oDbfKit:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfKit:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfKit:Lastrec() )

   ::oDlg:Enable()

   RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//