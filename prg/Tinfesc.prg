#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfEsc FROM TInfGen

   DATA  oDbfKit     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

   END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },            "Código",        .f., "Código artículo",           8 )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },            "Componente",    .f., "Descripción breve",        50 )
   ::AddField( "cCodEsc", "C", 18, 0, {|| "@!" },            "Cód.",          .t., "Código",                    8 )
   ::AddField( "cNomEsc", "C",100, 0, {|| "@!" },            "Compuesto",     .t., "Compuesto",                50 )
   ::AddField( "nUndKit", "N", 16, 6, {|| MasEsc() },        cNombreUnidades(),.t.,cNombreUnidades() + " de escandallo",   12 )
   ::AddField( "cUniDad", "C",  2, 0, {|| "@!" },            "Und.",          .t., "Unidad de medición",        4 )
   ::AddField( "nPreKit", "N", 16, 6, {|| ::cPicImp },       "Precio",        .f., "Precio de escandallo",     12 )
   ::AddField( "nTotal",  "N", 16, 6, {|| ::cPicImp },       "Total",         .f., "Total",                    12 )

   ::AddTmpIndex( "cCodArt", "cCodArt" )

   ::AddGroup( {|| ::oDbf:cCodArt },{|| "Componente : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( ::oDbf:cNomArt ) }, {||"Total componente..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfKiT PATH ( cPatArt() ) FILE "ARTKIT.DBF" VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"
   ::oDbfKit:OrdSetFocus( "cRefKit" )

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
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

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

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

   ::oDbfArt:OrdSetFocus( "CODIGO" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfArt:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oDbfArt:GoTop()

   while !::lBreak .and. !::oDbfArt:Eof()

      if ( ::lAllArt .or. ( ::oDbfArt:Codigo >= ::cArtOrg .and. ::oDbfArt:Codigo <= ::cArtDes ) )
         ::oDbfKit:Seek( ::oDbfArt:Codigo )

         while ::oDbfKit:cRefKit == ::oDbfArt:Codigo .and. !::oDbfKit:Eof()

            ::oDbf:Append()

            ::oDbf:cCodArt := ::oDbfKit:cRefKit
            ::oDbf:cNomArt := ::oDbfKit:cDesKit
            ::oDbf:cCodEsc := ::oDbfKit:cCodKit

            ::oDbf:cNomEsc := RetArticulo( ::oDbfKit:cCodKit, ::oDbfArt )

            ::oDbf:nUndKit := ::oDbfKit:nUndKit
            ::oDbf:cUniDad := ::oDbfKit:cUniDad
            ::oDbf:nPreKit := nCosto( ::oDbf:cCodArt, ::oDbfArt:cAlias, ::oDbfKit:cAlias, .f., ::cDivInf, ::oDbfDiv:cAlias )
            ::oDbf:nTotal  := ::oDbf:nUndKit * ::oDbf:nPreKit

            ::oDbf:Save()

            ::oDbfKit:Skip()

         end while

      end if

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   end while

   ::oDbfArt:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfArt:Lastrec() )

   ::oDlg:Enable()

   RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//