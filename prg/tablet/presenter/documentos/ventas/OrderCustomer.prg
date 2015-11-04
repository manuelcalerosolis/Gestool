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

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS OrderCustomer

   ::super:New( self )

   ::hTextDocuments                    := {  "textMain"     => "Pedidos de clientes",;
                                             "textShort"    => "Pedido",;
                                             "textTitle"    => "lineas de pedidos",;
                                             "textSummary"  => "Resumen pedido",;
                                             "textGrid"     => "Grid pedido clientes" }

   // Vistas--------------------------------------------------------------------

   ::oViewSearchNavigator:setTitleDocumento( "Pedidos de clientes" )

   ::oViewEdit:setTitleDocumento( "Pedido" )  

   ::oViewEditResumen:setTitleDocumento( "Resumen pedidos" )

   // Tipos--------------------------------------------------------------------
   
   ::setTypePrintDocuments( "PC" )

   ::setCounterDocuments( "nPedCli" )

   // Areas--------------------------------------------------------------------

   ::setDataTable( "PedCliT" )
   ::setDataTableLine( "PedCliL" )
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS OrderCustomer

   ::hDictionaryMaster      := D():getDefaultHashPedidoCliente( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDocumento() CLASS OrderCustomer

   local id                := D():PedidosClientesId( ::nView )

   if Empty( id )
      Return .f.
   end if

   ::hDictionaryMaster     := D():GetPedidoCliente( ::nView )

   if empty( ::hDictionaryMaster )
      Return .f.
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

   if empty( hLine )
      Return ( nil )
   end if 

Return ( DocumentLine():New( hLine, self ) )

//---------------------------------------------------------------------------//

METHOD getAppendDetail() CLASS OrderCustomer

   local hLine             := D():GetPedidoClienteLineaBlank( ::nView )
   ::oDocumentLineTemporal := DocumentLine():New( hLine, self )

Return ( self )

//---------------------------------------------------------------------------//

METHOD deleteLinesDocument() CLASS OrderCustomer

   D():getStatusPedidosClientesLineas( ::nView )

   ( D():PedidosClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   while ( D():PedidosClientesLineas( ::nView ) )->( dbSeek( ::getID() ) ) 
      ::delDocumentLine()
   end while

   D():setStatusPedidosClientesLineas( ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD printDocument() CLASS OrderCustomer

   imprimePedidoCliente( ::getID(), ::cFormatToPrint )

Return ( .t. )

//---------------------------------------------------------------------------//