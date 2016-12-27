#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ProductStock FROM Editable

   DATA oSender

   DATA aStockArticulo

   DATA oGridProductStock

   METHOD New()

   METHOD Init( oSender )

   METHOD setEnviroment( cCodArt, cCodAlm )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ProductStock

   ::aStockArticulo        := {}

Return ( self )

//---------------------------------------------------------------------------//

METHOD Init( oSender ) CLASS ProductStock

   ::nView                                := oSender:nView
   ::oSender                              := oSender

   ::oGridProductStock                    := StockViewNavigator():New( self )
   ::oGridProductStock:setSelectorMode()
   ::oGridProductStock:setTitleDocumento( "Stock por lotes" )
   ::oGridProductStock:setDblClickBrowseGeneral( {|| ::oGridProductStock:endView() } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setEnviroment( cCodArt, cCodAlm ) CLASS ProductStock

   ::aStockArticulo    := ::oSender:oStock:aStockArticulo( cCodArt, cCodAlm, , .t., .f. )

   ::setDataArray( ::aStockArticulo )

Return ( self )

//---------------------------------------------------------------------------//