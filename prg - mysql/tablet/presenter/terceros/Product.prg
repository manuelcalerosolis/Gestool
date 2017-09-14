#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Product FROM Editable

   DATA oGridProduct

   METHOD New()

   METHOD Init( oSender )

   METHOD OpenFiles()
   METHOD CloseFiles()                 INLINE ( D():DeleteView( ::nView ) )

   METHOD setEnviroment()              INLINE ( ::setDataTable( "Articulo" ) ) 

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Product

   if ::OpenFiles()
      ::setEnviroment()
   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD Init( oSender ) CLASS Product

   ::nView                               := oSender:nView

   ::oGridProduct                        := ProductViewSearchNavigator():New( self )
   ::oGridProduct:setSelectorMode()
   ::oGridProduct:setTitleDocumento( "Seleccione artículo" )
   ::oGridProduct:setDblClickBrowseGeneral( {|| ::oGridProduct:endView() } )

   ::setEnviroment()

Return ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS Product

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():Articulos( ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      ApoloMsgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      ::CloseFiles( "" )
   end if

Return ( lOpenFiles )

//---------------------------------------------------------------------------//