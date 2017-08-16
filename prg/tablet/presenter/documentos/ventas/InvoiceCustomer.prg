#include "FiveWin.Ch"
#include "Factu.ch"
#include "Xbrowse.ch"

CLASS InvoiceCustomer FROM DocumentsSales  
  
   METHOD New()
   METHOD Create( nView )   

   METHOD getAppendDocumento()

   METHOD getEditDocumento()

   METHOD getLinesDocument( id )
   METHOD getDocumentLine()

   METHOD getLines()                      INLINE ( ::oDocumentLines:getLines() )
   METHOD getLineDetail()                 INLINE ( ::oDocumentLines:getLineDetail( ::nPosDetail ) )

   METHOD getAppendDetail()
   METHOD deleteLinesDocument()

   METHOD printDocument()                 INLINE ( imprimeFacturaCliente( ::getID(), ::cFormatToPrint, ::nView ), .t. )

   METHOD onPostSaveAppend()              INLINE ( ::onPostSaveEdit(), ::actualizaUltimoLote() )

   METHOD onPostSaveEdit()                INLINE ( generatePagosFacturaCliente( ::getId(), ::nView ),;
                                                   checkPagosFacturaCliente( ::getId(), ::nView ),;
                                                   ::recalculateCacheStock() )

   METHOD appendButtonMode()              INLINE ( ::lAppendMode() .or. ( ::lEditMode() .and. accessCode():lInvoiceModify ) )
   METHOD editButtonMode()                INLINE ( ::appendButtonMode() )
   METHOD deleteButtonMode()              INLINE ( ::appendButtonMode() )
   METHOD onPreEditDocumento()

   METHOD actualizaUltimoLote()
   METHOD recalculateCacheStock() 

END CLASS

//---------------------------------------------------------------------------//

METHOD Create( nView ) CLASS InvoiceCustomer

   ::nView                 := nView

   ::super:oSender         := self

   ::oViewSearchNavigator  := DocumentSalesViewSearchNavigator():New( self )

   ::oViewEdit             := InvoiceDocumentSalesViewEdit():New( self )

   ::oViewEditResumen      := ViewEditResumen():New( self )

   ::oCliente              := Customer():init( self )  

   ::oProduct              := Product():init( self )

   ::oProductStock         := ProductStock():init( self )

   ::oStore                := Store():init( self )

   ::oPayment              := Payment():init( self )

   ::oDirections           := Directions():init( self )

   ::oDocumentLines        := DocumentLines():New( self )

   ::oLinesDocumentsSales  := LinesDocumentsSales():New( self )

   ::oTotalDocument        := TotalDocument():New( self )

   ::lAlowEdit             := accessCode():lInvoiceModify

   // Vistas--------------------------------------------------------------------

   ::oViewSearchNavigator:setTitleDocumento( "Facturas de clientes" )  

   ::oViewEdit:setTitleDocumento( "Factura cliente" )  

   ::oViewEditResumen:setTitleDocumento( "Resumen factura" )

   // Tipos--------------------------------------------------------------------

   ::setTypePrintDocuments( "FC" )

   ::setCounterDocuments( "nFacCli" )

   // Areas--------------------------------------------------------------------

   ::setSentenceTable( runScript( "FacturasClientes\SQLOpen.prg" ) )
   ::setDataTable( "FacCliT" )
   ::setDataTableLine( "FacCliL" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD New() CLASS InvoiceCustomer

   ::super:oSender         := self

   if !::openFiles()
      return ( self )
   end if 

   ::oViewSearchNavigator  := DocumentSalesViewSearchNavigator():New( self )

   ::oViewEdit             := InvoiceDocumentSalesViewEdit():New( self )

   ::oViewEditResumen      := ViewEditResumen():New( self )

   ::oCliente              := Customer():init( self )  

   ::oProduct              := Product():init( self )

   ::oProductStock         := ProductStock():init( self )

   ::oStore                := Store():init( self )

   ::oPayment              := Payment():init( self )

   ::oDirections           := Directions():init( self )

   ::oDocumentLines        := DocumentLines():New( self )

   ::oLinesDocumentsSales  := LinesDocumentsSales():New( self )

   ::oTotalDocument        := TotalDocument():New( self )

   ::lAlowEdit             := accessCode():lInvoiceModify

   // Vistas--------------------------------------------------------------------

   ::oViewSearchNavigator:setTitleDocumento( "Facturas de clientes" )  

   ::oViewEdit:setTitleDocumento( "Factura cliente" )  

   ::oViewEditResumen:setTitleDocumento( "Resumen factura" )

   // Tipos--------------------------------------------------------------------

   ::setTypePrintDocuments( "FC" )

   ::setCounterDocuments( "nFacCli" )

   // Areas--------------------------------------------------------------------

   ::setSentenceTable( runScript( "FacturasClientes\SQLOpen.prg" )  )
   ::setDataTable( "FacCliT" )
   ::setDataTableLine( "FacCliL" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS InvoiceCustomer

   ::hDictionaryMaster      := D():getDefaultHashFacturaCliente( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getEditDocumento() CLASS InvoiceCustomer

   local id                := D():FacturasClientesId( ::nView )

   if Empty( id )
      Return .f.
   end if

   ::hDictionaryMaster     := D():getHashRecordById( id, ::getWorkArea(), ::nView )

   if empty( ::hDictionaryMaster )
      Return .f.
   end if 

   ::getLinesDocument( id )

Return ( .t. )

//---------------------------------------------------------------------------//
//
// Convierte las lineas del albaran en objetos
//

METHOD getLinesDocument( id ) CLASS InvoiceCustomer

   ::oDocumentLines:reset()

   D():getStatusFacturasClientesLineas( ::nView )

   ( D():FacturasClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   if ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( id ) )  

      while ( D():FacturasClientesLineasId( ::nView ) == id ) .and. !( D():FacturasClientesLineas( ::nView ) )->( eof() ) 

         ::addDocumentLine()
      
         ( D():FacturasClientesLineas( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 
   
   D():setStatusFacturasClientesLineas( ::nView ) 

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD getDocumentLine() CLASS InvoiceCustomer

   local hLine    := D():GetFacturaClienteLineasHash( ::nView )

   if empty( hLine )
      Return ( nil )
   end if 

Return ( DictionaryDocumentLine():New( self, hLine ) )

//---------------------------------------------------------------------------//

METHOD getAppendDetail() CLASS InvoiceCustomer

   local hLine             := D():GetFacturaClienteLineaDefaultValues( ::nView )

   ::oDocumentLineTemporal := DictionaryDocumentLine():New( self, hLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD deleteLinesDocument() CLASS InvoiceCustomer

   D():getStatusFacturasClientesLineas( ::nView )

   ( D():FacturasClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   while ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( ::getID() ) ) 
      ::delDocumentLine()
   end while

   D():setStatusFacturasClientesLineas( ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD actualizaUltimoLote() CLASS InvoiceCustomer

   local nRec        := ( D():FacturasClientesLineas( ::nView ) )->( Recno() )
   local nOrdAnt     := ( D():FacturasClientesLineas( ::nView ) )->( ordSetFocus( "nNumFac" ) )

   if ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( ::getId() ) )

      while ( D():FacturasClientesLineasId( ::nView ) == ::getId() .and. D():FacturasClientesLineasNotEof( ::nView ) )

         if !Empty( ( D():FacturasClientesLineas( ::nView ) )->cRef ) .and. ( D():FacturasClientesLineas( ::nView ) )->lLote

            saveLoteActual( ( D():FacturasClientesLineas( ::nView ) )->cRef, ( D():FacturasClientesLineas( ::nView ) )->cLote, ::nView )

         end if

         ( D():FacturasClientesLineas( ::nView ) )->( dbSkip() )

      end while

   end if

   ( D():FacturasClientesLineas( ::nView ) )->( ordSetFocus( nOrdAnt ) )
   ( D():FacturasClientesLineas( ::nView ) )->( dbGoTo( nRec ) )

Return ( self )

//---------------------------------------------------------------------------//

METHOD recalculateCacheStock() CLASS InvoiceCustomer

   local nRec        := ( D():FacturasClientesLineas( ::nView ) )->( recno() )
   local nOrdAnt     := ( D():FacturasClientesLineas( ::nView ) )->( ordsetfocus( "nNumFac" ) )

   cursorWait()

   if ( D():FacturasClientesLineas( ::nView ) )->( dbseek( ::getId() ) )

      while ( D():FacturasClientesLineasId( ::nView ) == ::getId() .and. D():FacturasClientesLineasNotEof( ::nView ) )

         if !empty( ( D():FacturasClientesLineas( ::nView ) )->cRef )

            ::oStock:recalculateCacheStockActual( ( D():FacturasClientesLineas( ::nView ) )->cRef, ( D():FacturasClientesLineas( ::nView ) )->cAlmLin, ( D():FacturasClientesLineas( ::nView ) )->cValPr1, ( D():FacturasClientesLineas( ::nView ) )->cValPr2, ( D():FacturasClientesLineas( ::nView ) )->cLote, ( D():FacturasClientesLineas( ::nView ) )->lKitArt, nil, ( D():FacturasClientesLineas( ::nView ) )->nCtlStk )                      

         end if

         ( D():FacturasClientesLineas( ::nView ) )->( dbskip() )

      end while

   end if

   ( D():FacturasClientesLineas( ::nView ) )->( ordsetfocus( nOrdAnt ) )
   ( D():FacturasClientesLineas( ::nView ) )->( dbgoto( nRec ) )

   cursorWE()

Return ( self )

//---------------------------------------------------------------------------//


METHOD onPreEditDocumento() CLASS InvoiceCustomer

   ::nOrdenAnterior     := ( ::getDataTable() )->( OrdSetFocus() )

Return ( .t. )

//---------------------------------------------------------------------------//