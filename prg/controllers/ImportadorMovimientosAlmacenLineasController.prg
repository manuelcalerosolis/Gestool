#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImportadorMovimientosAlmacenLineasController FROM SQLBaseController

   DATA oStock

   METHOD New( oController )

   METHOD End()

   METHOD Activate()    INLINE ( ::oDialogView:Activate() )

   METHOD importarAlmacen()

   METHOD calculaStock( cArea )

   METHOD creaRegistro()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::oStock             := TStock():New()

   ::cTitle             := "Importador movimientos almacen lineas"

   ::oDialogView        := ImportadorMovimientosAlmacenLineasView():New( self )

   ::oValidator         := ImportadorMovimientosAlmacenLineasValidator():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::Super:End()

   ::oStock:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD importarAlmacen()

   local cArea          := "ArtToImport"

   ArticulosModel():getArticulosToImport( @cArea, ::oDialogView:getRange() )

   ::oDialogView:oMtrStock:setTotal( ( cArea )->( lastrec() ) )

   while !( cArea )->( eof() )

      ::calculaStock( cArea )

      ::oDialogView:oMtrStock:autoInc()

      ( cArea )->( dbskip() )

   end while

   CLOSE ( cArea )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD calculaStock( cArea )

   local aStockArticulo 

   msgalert( ::oSenderController:oDialogView:oGetAlmacenDestino:varGet(), "oSenderController")

   aStockArticulo       := ::oStock:aStockArticulo( ( cArea )->Codigo, ::oSenderController:oDialogView:oGetAlmacenDestino:varGet() )

   aeval( aStockArticulo, {|sStockArticulo| if( sStockArticulo:nUnidades != 0, ::creaRegistro( sStockArticulo ), ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD creaRegistro( sStockArticulo)

   msgalert( hb_valtoexp( sStockArticulo ), "sStockArticulo" )

RETURN ( Self )

//---------------------------------------------------------------------------//
