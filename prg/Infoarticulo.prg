#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

Static oInfoArticulo

//---------------------------------------------------------------------------//

Function CreateInfoArticulo()

   CloseInfoArticulo()

   if Empty( oInfoArticulo )
      oInfoArticulo  := TInfoArticulo():New()
   end if

Return nil

//---------------------------------------------------------------------------//

Function CloseInfoArticulo()

   if oInfoArticulo != nil
      oInfoArticulo:CloseFiles()
   end if

   oInfoArticulo     := nil

Return nil

//---------------------------------------------------------------------------//

CLASS TInfoArticulo

   DATA oDlg

   DATA oDbfArticulo
   DATA oDbfIva
   DATA oDbfKit
   DATA oDbfDivisa
   DATA oDbfArtCode

   DATA oCodigoArticulo
   DATA oNombreArticulo
   DATA oPrecioArticulo

   METHOD New()

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD LoadArticulo()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles( cPath )

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT cPath  := cPatEmp()

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfArticulo   PATH ( cPatArt() )   FILE "Articulo.Dbf"     VIA ( cDriver() ) SHARED INDEX "Articulo.Cdx"

      DATABASE NEW ::oDbfArtCode    PATH ( cPatArt() )   FILE "ArtCodebar.Dbf"   VIA ( cDriver() ) SHARED INDEX "ArtCodebar.Cdx"

      DATABASE NEW ::oDbfIva        PATH ( cPatDat() )   FILE "Tiva.Dbf"         VIA ( cDriver() ) SHARED INDEX "Tiva.Cdx"

      DATABASE NEW ::oDbfDivisa     PATH ( cPatDat() )   FILE "Divisas.Dbf"      VIA ( cDriver() ) SHARED INDEX "Divisas.Cdx"

      DATABASE NEW ::oDbfKit        PATH ( cPatArt() )   FILE "ArtKit.Dbf"       VIA ( cDriver() ) SHARED INDEX "ArtKit.Cdx"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

/*
Cerramos ficheros
*/

METHOD CloseFiles()

   if !Empty( ::oDbfArticulo )
      ::oDbfArticulo:End()
   end if

   if !Empty( ::oDbfArtCode )
      ::oDbfArtCode:End()
   end if

   if !Empty( ::oDbfIva )
      ::oDbfIva:End()
   end if

   if !Empty( ::oDbfDivisa )
      ::oDbfDivisa:End()
   end if

   if !Empty( ::oDbfKit )
      ::oDbfKit:End()
   end if

   ::oDbfArticulo    := nil
   ::oDbfArtCode     := nil
   ::oDbfIva         := nil
   ::oDbfDivisa      := nil
   ::oDbfKit         := nil

   oInfoArticulo     := nil

Return .t.

//---------------------------------------------------------------------------//

Method New()

   local cCodigoArticulo   := Space( 18 )
   local cNombreArticulo   := Space( 100 )
   local nPrecioArticulo   := 0

   if ::OpenFiles()

      DEFINE DIALOG ::oDlg NAME "SearchArticulo"

      REDEFINE GET ::oCodigoArticulo VAR cCodigoArticulo;
         ID       100 ;
         OF       ::oDlg ;
         BITMAP   "LUPA"

         ::oCodigoArticulo:bValid   := {|| ::LoadArticulo() }
         ::oCodigoArticulo:bHelp    := {|| BrwArticulo( ::oCodigoArticulo, ::oNombreArticulo ) }

      REDEFINE GET ::oNombreArticulo VAR cNombreArticulo ;
         ID       110 ;
         OF       ::oDlg

      REDEFINE GET ::oPrecioArticulo VAR nPrecioArticulo ;
         ID       120 ;
         PICTURE  "@E 999,999.99" ;
         OF       ::oDlg

      REDEFINE BUTTON ;
         ID       130 ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:end( IDOK ) )

      ::oDlg:bStart  := {|| ::oCodigoArticulo:SetFocus() }

      ::oDlg:Activate( , , , .t., {|| ::CloseFiles() }, .f. )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD LoadArticulo()

   local cCodigoArticulo   := ::oCodigoArticulo:VarGet()

   if Empty( ::oDbfArtCode ) .or. Empty( ::oDbfArticulo )
      Return .t.
   end if

   /*
   Primero buscamos por codigos de barra
   */

   cCodigoArticulo         := cSeekCodebar( cCodigoArticulo, ::oDbfArtCode:cAlias, ::oDbfArticulo:cAlias )



   /*
   Ahora buscamos por el codigo interno
   */

   if ::oDbfArticulo:Seek( cCodigoArticulo )

      ::oCodigoArticulo:cText( cCodigoArticulo )

      if !Empty( ::oDbfArticulo:cDesTik )
         ::oNombreArticulo:cText( ::oDbfArticulo:cDesTik )
      else
         ::oNombreArticulo:cText( ::oDbfArticulo:Nombre )
      end if

      ::oPrecioArticulo:cText( nRetPreArt( 1, cDivEmp(), .t., ::oDbfArticulo:cAlias, ::oDbfDivisa:cAlias, ::oDbfKit:cAlias, ::oDbfIva:cAlias ) )

   else

      MsgStop( 'Artículo no encontrado' )

   end if

Return .t.

//---------------------------------------------------------------------------//