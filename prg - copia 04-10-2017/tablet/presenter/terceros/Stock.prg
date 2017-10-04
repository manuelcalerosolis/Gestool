#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Stock FROM Editable

   DATA oGridProduct

   METHOD New()

   METHOD Init( oSender )

   METHOD setEnviroment()              INLINE ( ::setDataTable( "Articulo" ) ) 

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Stock

Return ( self )

//---------------------------------------------------------------------------//

METHOD Init( oSender ) CLASS Stock

   ::nView                               := oSender:nView

   /*::oGridProduct                        := ProductViewSearchNavigator():New( self )
   ::oGridProduct:setSelectorMode()
   ::oGridProduct:setTitleDocumento( "Seleccione artículo" )
   ::oGridProduct:setDblClickBrowseGeneral( {|| ::oGridProduct:endView() } )

   ::setEnviroment()*/

Return ( self )

//---------------------------------------------------------------------------//