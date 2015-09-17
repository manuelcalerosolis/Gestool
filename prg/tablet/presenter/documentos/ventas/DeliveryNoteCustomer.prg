#include "FiveWin.Ch"
#include "Factu.ch"
#include "Xbrowse.ch"

CLASS DeliveryNoteCustomer FROM DocumentsSales  

   DATA oLinesDeliveryNoteCustomer

   METHOD New()

   METHOD ResourceDetail( nMode )         INLINE ( ::oLinesDeliveryNoteCustomer:ResourceDetail( nMode ) )

   METHOD getAppendDocumento()
   METHOD getEditDocumento()

   METHOD getLinesDocument( id )
   METHOD getDocumentLine()

   METHOD getLines()                      INLINE ( ::oDocumentLines:getLines() )
   METHOD getLineDetail()                 INLINE ( ::oDocumentLines:getLineDetail( ::nPosDetail ) )

   METHOD getAppendDetail()
   METHOD deleteLinesDocument()

   METHOD printDocument()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS DeliveryNoteCustomer

   ::super:New( self )

   ::setTextSummaryDocument( "Resumen albarán" )
   ::setTypePrintDocuments( "AC" )
   ::setCounterDocuments( "nAlbCli" )

   ::oViewSearchNavigator:setTitle( "Albaranes de clientes" )  

   ::oViewEdit:setTitle( "Albarán" )  

   ::oLinesDeliveryNoteCustomer           := LinesDeliveryNoteCustomer():New( self )
 
   // Areas

   ::setDataTable( "AlbCliT" )
   ::setDataTableLine( "AlbCliL" )

   ( ::getWorkArea() )->( ordSetFocus( "dFecDes" ) )
   ( ::getWorkArea() )->( dbgotop() ) 

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS DeliveryNoteCustomer

   ::hDictionaryMaster      := D():GetDefaultHashAlbaranCliente( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDocumento() CLASS DeliveryNoteCustomer

   local id                := D():AlbaranesClientesId( ::nView )

   if Empty( id )
      Return .f.
   end if  

   ::hDictionaryMaster     := D():getAlbaranCliente( ::nView )

   ::getLinesDocument( id )

Return ( .t. )

//---------------------------------------------------------------------------//
//
// Convierte las lineas del albaran en objetos
//

METHOD getLinesDocument( id ) CLASS DeliveryNoteCustomer

   ::oDocumentLines:reset()

   D():getStatusAlbaranesClientesLineas( ::nView )

   ( D():AlbaranesClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbSeek( id ) )  

      while ( D():AlbaranesClientesLineasId( ::nView ) == id ) .and. !( D():AlbaranesClientesLineas( ::nView ) )->( eof() ) 

         ::addDocumentLine()
      
         ( D():AlbaranesClientesLineas( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 
   
   D():setStatusAlbaranesClientesLineas( ::nView ) 

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD getDocumentLine() CLASS DeliveryNoteCustomer

   local hLine    := D():GetAlbaranClienteLineasHash( ::nView )

   if empty( hLine )
      Return ( nil )
   end if 

Return ( DocumentLine():New( hLine, self ) )

//---------------------------------------------------------------------------//

METHOD GetAppendDetail() CLASS DeliveryNoteCustomer

   local hLine             := D():GetAlbaranClienteLineaBlank( ::nView )
   ::oDocumentLineTemporal := DocumentLine():New( hLine, self )

Return ( self )

//---------------------------------------------------------------------------//

METHOD deleteLinesDocument() CLASS DeliveryNoteCustomer

   D():getStatusAlbaranesClientesLineas( ::nView )

   ( D():AlbaranesClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   while ( D():AlbaranesClientesLineas( ::nView ) )->( dbSeek( ::getID() ) ) 
      ::delDocumentLine()
   end while

   D():setStatusAlbaranesClientesLineas( ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD printDocument() CLASS DeliveryNoteCustomer

   imprimeAlbaranCliente( ::getID(), ::cFormatToPrint )

Return ( .t. )

//---------------------------------------------------------------------------//