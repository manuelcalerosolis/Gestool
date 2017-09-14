#include "FiveWin.Ch"
#include "Factu.ch"

CLASS OrderCustomer FROM DocumentsSales  

   METHOD New()

   METHOD GetAppendDocumento()
   METHOD GetEditDocumento()

   METHOD getLinesDocument()
   METHOD getDocumentLine()

   METHOD getLines()                      INLINE ( ::oDocumentLines:getLines() )
   METHOD getLineDetail()                 INLINE ( ::oDocumentLines:getLineDetail( ::nPosDetail ) )

   METHOD getAppendDetail()
   METHOD deleteLinesDocument() 

   METHOD printDocument()

   METHOD Build( oSender )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS OrderCustomer

   ::super:New( self )

   ::hTextDocuments                    := {  "textMain"     => getConfigTraslation("Pedidos de clientes"),;
                                             "textShort"    => "Pedido",;
                                             "textTitle"    => "lineas de pedidos",;
                                             "textSummary"  => "Resumen pedido",;
                                             "textGrid"     => "Grid pedido clientes" }

   // Vistas--------------------------------------------------------------------

   ::oViewSearchNavigator:setTitleDocumento( getConfigTraslation("Pedidos de clientes") )

   ::oViewEdit:setTitleDocumento( "Pedido" )  

   ::oViewEditResumen:setTitleDocumento( "Resumen pedidos" )

   // Tipos--------------------------------------------------------------------
   
   ::setTypePrintDocuments( "PC" )

   ::setCounterDocuments( "nPedCli" )

   // Areas--------------------------------------------------------------------

   ::setDataTable( "PedCliT" )
   ::setDataTableLine( "PedCliL" )
   
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Build( oSender ) CLASS OrderCustomer

   ::oSender               := oSender

   ::oViewSearchNavigator  := DocumentSalesViewSearchNavigator():New( self )

   ::oViewEdit             := DocumentSalesViewEdit():New( self )

   ::oViewEditResumen      := ViewEditResumen():New( self )

   ::oCliente              := Customer():init( self )  

   ::oProduct              := Product():init( self )

   ::oProductStock         := ProductStock():init( self )

   ::oStore                := Store():init( self )

   ::oPayment              := Payment():init( self )

   ::oDirections           := Directions():init( self )

   ::oDocumentLines        := DocumentLines():New( self )

   ::oLinesDocumentsSales  := LinesOrderCustomer():New( self )

   ::oTotalDocument        := TotalDocument():New( self )

return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS OrderCustomer

   ::hDictionaryMaster      := D():getDefaultHashPedidoCliente( ::nView )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDocumento() CLASS OrderCustomer

   local id                := D():PedidosClientesId( ::nView )

   if Empty( id )
      RETURN .f.
   end if

   ::hDictionaryMaster     := D():GetPedidoCliente( ::nView )

   if empty( ::hDictionaryMaster )
      RETURN .f.
   end if 

   ::getLinesDocument( id )

RETURN ( .t. ) 

//---------------------------------------------------------------------------//
//
// Convierte las lineas del pedido en objetos
//

METHOD getLinesDocument( id ) CLASS OrderCustomer

   ::oDocumentLines:reset()

   D():getStatusPedidosClientesLineas( ::nView )

   ( D():PedidosClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   if ( D():PedidosClientesLineas( ::nView ) )->( dbSeek( id ) )  

      while ( D():PedidosClientesLineasId( ::nView ) == id ) .and. !( D():PedidosClientesLineas( ::nView ) )->( eof() ) 

         ::addDocumentLine()
      
         ( D():PedidosClientesLineas( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 
   
   D():setStatusPedidosClientesLineas( ::nView ) 

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD getDocumentLine() CLASS OrderCustomer

   local hLine    := D():GetPedidoClienteLineasHash( ::nView )

RETURN ( DictionaryDocumentLine():New( self, hLine ) )

//---------------------------------------------------------------------------//

METHOD getAppendDetail() CLASS OrderCustomer

   local hLine             := D():GetPedidoClienteLineasDefaultValue( ::nView )

   ::oDocumentLineTemporal := DictionaryDocumentLine():New( self, hLine )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteLinesDocument() CLASS OrderCustomer

   D():getStatusPedidosClientesLineas( ::nView )

   ( D():PedidosClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   while ( D():PedidosClientesLineas( ::nView ) )->( dbSeek( ::getID() ) ) 
      ::delDocumentLine()
   end while

   D():setStatusPedidosClientesLineas( ::nView ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD printDocument() CLASS OrderCustomer

   imprimePedidoCliente( ::getID(), ::cFormatToPrint )

RETURN ( .t. )

//---------------------------------------------------------------------------//