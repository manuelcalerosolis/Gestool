#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Product FROM Editable

   DATA oGridProduct

   METHOD New()

   METHOD Init( oSender )

   METHOD OpenFiles()
   METHOD CloseFiles()                 INLINE ( D():DeleteView( ::nView ) )

   METHOD setEnviroment()              INLINE ( ::setDataTable( "Articulo" ) ) 

   METHOD runGridProduct()

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
   ::oGridProduct:setTextoTipoDocumento( "Seleccione artículo" )
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

METHOD runGridProduct() CLASS Product

   local result   := ""

   if !Empty( ::oGridProduct )

      ::oGridProduct:showView()

      if ::oGridProduct:isEndOk()
         result   := ( D():Articulos( ::nView ) )->Codigo
      end if

   end if

Return ( result )

//---------------------------------------------------------------------------//