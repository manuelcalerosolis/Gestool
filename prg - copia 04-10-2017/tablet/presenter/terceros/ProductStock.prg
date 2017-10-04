#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ProductStock FROM Editable

   DATA oSender

   DATA aStockArticulo

   DATA oGridProductStock

   METHOD New()

   METHOD Init( oSender )

   METHOD setEnviroment( cCodArt, cCodAlm )

   METHOD ClearArrayStock()

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

   if GetPvProfString( "Tablet", "OcultarStockLoteCero", ".F.", cIniAplication() ) == ".T."
      ::ClearArrayStock()
   end if

   ::setDataArray( ::aStockArticulo )

Return ( self )

//---------------------------------------------------------------------------//

METHOD ClearArrayStock() CLASS ProductStock

   local oStocks
   local aPuente  := {}

   for each oStocks in ::aStockArticulo

      if Round( oStocks:nUnidades, 6 ) > 0.000000
         aAdd( aPuente, oStocks )
      end if

   next

   ::aStockArticulo  := aPuente

Return ( self )

//---------------------------------------------------------------------------//