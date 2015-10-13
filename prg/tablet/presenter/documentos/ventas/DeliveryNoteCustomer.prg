#include "FiveWin.Ch"
#include "Factu.ch"
#include "Xbrowse.ch"

CLASS DeliveryNoteCustomer FROM DocumentsSales  

   METHOD New()

   METHOD getAppendDocumento()
   METHOD getEditDocumento()

   METHOD getLinesDocument( id )
   METHOD getDocumentLine()

   METHOD getLines()                   INLINE ( ::oDocumentLines:getLines() )
   METHOD getLineDetail()              INLINE ( ::oDocumentLines:getLineDetail( ::nPosDetail ) )

   METHOD getAppendDetail()
   METHOD deleteLinesDocument()

   METHOD printDocument()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS DeliveryNoteCustomer

   ::super:New( self )

   ::hTextDocuments                    := {  "textMain"     => "Albaranes de clientes",;
                                             "textShort"    => "Albarán",;
                                             "textTitle"    => "lineas de albaranes",;
                                             "textSummary"  => "Resumen albarán",;
                                             "textGrid"     => "Grid albarán clientes" }

  // Vistas--------------------------------------------------------------------

   ::oViewSearchNavigator:setTitle( "Albaranes de clientes" )  

   ::oViewEdit:setTitle( "Albarán" )  

   ::oViewEditResumen:setTitle( "Resumen albarán" )

   // Tipos--------------------------------------------------------------------

   ::setTypePrintDocuments( "AC" )

   ::setCounterDocuments( "nAlbCli" )

   // Areas--------------------------------------------------------------------

   ::setDataTable( "AlbCliT" )
   ::setDataTableLine( "AlbCliL" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS DeliveryNoteCustomer

   ::hDictionaryMaster      := D():GetDefaultHashAlbaranCliente( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getEditDocumento() CLASS DeliveryNoteCustomer

   local id                := D():AlbaranesClientesId( ::nView )

   if empty( id )
      Return .f.
   end if  

   ::hDictionaryMaster     := D():getHashAlbaranCliente( ::nView )

   if empty( ::hDictionaryMaster )
      Return .f.
   end if 

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