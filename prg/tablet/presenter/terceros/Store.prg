#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Stores FROM Editable

   DATA oGrid

   METHOD New()

   METHOD Init( oSender )

   METHOD OpenFiles()
   METHOD CloseFiles()                 INLINE ( D():DeleteView( ::nView ) )

   METHOD setEnviroment()              INLINE ( ::setDataTable( "Almacen" ) ) 

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Stores

   if ::OpenFiles()
      ::setEnviroment()
   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD Init( oSender ) CLASS Stores

   ::nView                             := oSender:nView

   ::oGrid                             := StoreViewSearchNavigator():New( self )
   ::oGrid:setSelectorMode()
   ::oGrid:setTitleDocumento( "Seleccione almacén" )
   ::oGrid:setDblClickBrowseGeneral( {|| ::oGrid:endView() } )

   ::setEnviroment()

Return ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS Stores

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():Almacen( ::nView )

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