#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfChgBar FROM TInfGen

   DATA  oDbfArt     AS OBJECT
   DATA  oDbfCodeBar AS OBJECT
   DATA  oDbfKit     AS OBJECT
   DATA  oDbfDiv     AS OBJECT

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodFam",  "C", 16, 0, {|| "@!" },        'Familia',        .f., 'Familia'                ,  8, .f. )
   ::AddField( "cCodArt",  "C", 18, 0, {|| "@!" },        'Código artículo',      .f., 'Cod. artículo'          , 15, .f. )
   ::AddField( "cNomArt",  "C",100, 0, {|| "@!" },        'Descripción',    .f., 'Descripción'            , 50, .f. )
   ::AddField( "cCodeBar", "C", 20, 0, {|| "@!" },        'Código barras',  .t., 'Código de barras'       , 50, .f. )
   ::AddField( "LastChg",  "D",  8, 0, {|| "@!" },        'Cambio',         .t., 'Fecha de cambio'        , 15, .f. )

   ::AddTmpIndex( "CCODFAM", "CCODFAM + CCODART + CCODEBAR" )

   ::AddGroup( {|| ::oDbf:cCodFam }, {|| "Familia  : " + Rtrim( ::oDbf:cCodFam ) + "-" + oRetFld( ::oDbf:cCodFam, ::oDbfFam ) }, {|| "Total familia..." } )
   ::AddGroup( {|| ::oDbf:cCodFam + ::oDbf:cCodArt }, {|| "Artículo  : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( ::oDbf:cNomArt ) }, {|| "" } )

   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt     PATH ( cPatArt() ) FILE "ARTICULO.DBF"    VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfCodeBar PATH ( cPatArt() ) FILE "ARTCODEBAR.DBF"  VIA ( cDriver() ) SHARED INDEX "ARTCODEBAR.CDX"

   DATABASE NEW ::oDbfKit     PATH ( cPatArt() ) FILE "ARTKIT.DBF"      VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   DATABASE NEW ::oDbfDiv     PATH ( cPatDat() ) FILE "DIVISAS.DBF"     VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfCodeBar ) .and. ::oDbfCodeBar:Used()
      ::oDbfCodeBar:End()
   end if

   if !Empty( ::oDbfKit ) .and. ::oDbfKit:Used()
      ::oDbfKit:End()
   end if

   if !Empty( ::oDbfDiv ) .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   ::oDbfArt      := nil
   ::oDbfCodeBar  := nil
   ::oDbfKit      := nil
   ::oDbfDiv      := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   if !::StdResource( "INFCHGART" )
      return .f.
   end if

   if !::lDefFamInf( 110, 120, 130, 140, 600 )
      return .f.
   end if

   ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

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

   ::aHeader      := {  {|| 'Fecha    : ' + Dtoc( Date() ) },;
                        {|| 'Periodo  : ' + Dtoc( ::dIniInf ) + ' > ' + Dtoc( ::dFinInf ) },;
                        {|| 'Familias : ' + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + ' > ' + AllTrim( ::cFamDes ) ) } }

   ::oDbfArt:OrdSetFocus( "CODIGO" )

   cExpHead          := '( dChgBar >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dChgBar <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'

   if !::lAllFam
      cExpHead       += ' .and. Familia >= "' + Rtrim( ::cFamOrg ) + '" .and. Familia <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oDbfArt:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oDbfArt:OrdKeyCount() )

   ::oDbfArt:GoTop()

   while !::lBreak .and. !::oDbfArt:Eof()

      if lMultipleCodeBar()

         if ::oDbfCodeBar:Seek( ::oDbfArt:Codigo )

            while ::oDbfCodeBar:cCodArt == ::oDbfArt:Codigo .and. !::oDbfCodeBar:Eof()

               ::oDbf:Append()

               ::oDbf:LastChg    := ::oDbfArt:dChgBar
               ::oDbf:cCodArt    := ::oDbfArt:Codigo
               ::oDbf:cNomArt    := ::oDbfArt:Nombre
               ::oDbf:cCodFam    := ::oDbfArt:Familia
               ::oDbf:cCodeBar   := ::oDbfCodeBar:cCodBar

               ::oDbf:Save()

               ::oDbfCodeBar:Skip()

            end while

         end if

      else

         ::oDbf:Append()

         ::oDbf:LastChg       := ::oDbfArt:dChgBar
         ::oDbf:cCodArt       := ::oDbfArt:Codigo
         ::oDbf:cNomArt       := ::oDbfArt:Nombre
         ::oDbf:cCodFam       := ::oDbfArt:Familia
         ::oDbf:cCodeBar      := ::oDbfArt:CodeBar

         ::oDbf:Save()

      end if

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   end while

   ::oDbfArt:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfArt:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//