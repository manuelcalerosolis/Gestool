#include "FiveWin.Ch"
#include "Factu.ch"
#include "Xbrowse.ch"

CLASS DeliveryNoteCustomer FROM DocumentsSales  

   METHOD New()
   METHOD Build()
   METHOD Default()

   METHOD getAppendDocumento()
   METHOD getEditDocumento()

   METHOD getLinesDocument( id )
   METHOD getDocumentLine()

   METHOD getLines()                   INLINE ( ::oDocumentLines:getLines() )
   METHOD getLineDetail()              INLINE ( ::oDocumentLines:getLineDetail( ::nPosDetail ) )

   METHOD getAppendDetail()
   METHOD deleteLinesDocument()

   METHOD printDocument()

   METHOD insertLineDocument( oLine )
   
   METHOD getLastLineNumber( id )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS DeliveryNoteCustomer

   ::super:New( self )

   ::hTextDocuments                    := {  "textMain"     => "Albaranes de clientes",;
                                             "textShort"    => "Albarán",;
                                             "textTitle"    => "lineas de albaranes",;
                                             "textSummary"  => "Resumen albarán",;
                                             "textGrid"     => "Grid albarán clientes" }

   // Vistas-------------------------------------------------------------------

   ::oViewSearchNavigator:setTitleDocumento( "Albaranes de clientes" )  

   ::oViewEdit:setTitleDocumento( "Albarán" )  

   ::oViewEditResumen:setTitleDocumento( "Resumen albarán" )

   // Valores por defecto------------------------------------------------------

   ::Default()

Return ( self )

//---------------------------------------------------------------------------//

METHOD Build() CLASS DeliveryNoteCustomer

   ::super:Build()

   ::Default()

Return ( self )

//---------------------------------------------------------------------------//

METHOD Default() CLASS DeliveryNoteCustomer

   ::setTypePrintDocuments( "AC" )

   ::setCounterDocuments( "nAlbCli" )

   ::setDataTable( "AlbCliT" )
   
   ::setDataTableLine( "AlbCliL" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getAppendDocumento() CLASS DeliveryNoteCustomer

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

Return ( DictionaryDocumentLine():New( self, hLine ) )

//---------------------------------------------------------------------------//

METHOD GetAppendDetail() CLASS DeliveryNoteCustomer

   local hLine             := D():getAlbaranClienteLineaDefaultValues( ::nView )

   ::oDocumentLineTemporal := DictionaryDocumentLine():New( self, hLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD deleteLinesDocument() CLASS DeliveryNoteCustomer

   local statement

   if lAIS()

      statement   := "DELETE FROM " + cPatEmp() + "AlbCliL " + ;
                        "WHERE cSerAlb = '" + ::getSerie() + "' AND nNumAlb = " + alltrim( ::getStrNumero() ) + " AND cSufAlb = '" + ::getSufijo() + "'" 

      TDataCenter():ExecuteSqlStatement( statement )

   else

      D():getStatusAlbaranesClientesLineas( ::nView )
      ( D():AlbaranesClientesLineas( ::nView ) )->( ordsetfocus( 1 ) )

      while ( D():AlbaranesClientesLineas( ::nView ) )->( dbseek( ::getID() ) ) 
         ::delDocumentLine()
      end while

      D():setStatusAlbaranesClientesLineas( ::nView ) 

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD printDocument() CLASS DeliveryNoteCustomer

   imprimeAlbaranCliente( ::getID(), ::cFormatToPrint )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD insertLineDocument( oLine )

   local lineNumber        := ::getLastLineNumber()

   // obtener el numero de la ultima linea existente

   oLine:setNumeroLinea( lineNumber )

   oLine:setPosicionImpresion( lineNumber )
   oLine:setSerie( ( D():AlbaranesClientes( ::nView ) )->cSerAlb )
   oLine:setNumero( ( D():AlbaranesClientes( ::nView ) )->nNumAlb )
   oLine:setSufijo( ( D():AlbaranesClientes( ::nView ) )->cSufAlb )

   oLine:setStore( ( D():AlbaranesClientes( ::nView ) )->cCodAlm )

   oLine:setFechaDocumento( ( D():AlbaranesClientes( ::nView ) )->dFecAlb )
   oLine:setHoraDocumento( ( D():AlbaranesClientes( ::nView ) )->tFecAlb )

   // asginar a la linea el id del albaran

   // pasar la linea al fichero de lineas de albaranes

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD getLastLineNumber()

   local id                := D():AlbaranesClientesId( ::nView )
   local lineNumber        := 0

   D():getStatusAlbaranesClientesLineas( ::nView )

   ( D():AlbaranesClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbSeek( id ) )  

      while ( D():AlbaranesClientesLineasId( ::nView ) == id ) .and. !( D():AlbaranesClientesLineas( ::nView ) )->( eof() ) 

         if ( D():AlbaranesClientesLineas( ::nView ) )->nNumLin > lineNumber
            lineNumber     := ( D():AlbaranesClientesLineas( ::nView ) )->nNumLin
         end if 
      
         ( D():AlbaranesClientesLineas( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 
   
   D():setStatusAlbaranesClientesLineas( ::nView ) 

RETURN ( ++lineNumber ) 

//---------------------------------------------------------------------------//

