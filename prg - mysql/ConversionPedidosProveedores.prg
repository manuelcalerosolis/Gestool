#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TConversionPedidosProveedores FROM TConversionDocumentos 

   DATA cCodigoProveedor                              INIT ""

   METHOD New( nView, oStock )

   METHOD Dialog()

   METHOD setCodigoProveedor( cCodigoProveedor )      INLINE ( ::cCodigoProveedor := cCodigoProveedor )
   METHOD getCodigoProveedor()                        INLINE ( ::cCodigoProveedor )

   METHOD startDialog()
      METHOD botonSiguiente()

   METHOD loadLinesDocument()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nView, oStock )

   ::Super:New( nView, oStock )

   ::setDocumentPedidosProveedores()

   ::setShoppingPictures()

RETURN ( Self )   

//----------------------------------------------------------------------------//

METHOD Dialog() 

   local oBmp

   DEFINE DIALOG ::oDlg ;
      RESOURCE    "ASS_CONVERSION_DOCUMENTO"

   REDEFINE BITMAP oBmp ;
      ID          500 ;
      RESOURCE    "gc_clipboard_empty_businessman_48" ;
      TRANSPARENT ;
      OF          ::oDlg

   REDEFINE SAY   ::oTitle ;
      PROMPT      ::cTitle ;
      ID          510 ;
      OF          ::oDlg

   REDEFINE PAGES ::oFld ;
      ID          100 ;
      OF          ::oDlg ;
      DIALOGS     "ASS_CONVERSION_DOCUMENTO_3"

   ::DialogSelectionLines( ::oFld:aDialogs[1] )
   
   // Botones -----------------------------------------------------------------

   REDEFINE BUTTON ::buttonPrior;
      ID          3 ;
      OF          ::oDlg ;
      ACTION      ( ::botonAnterior() )

   REDEFINE BUTTON ::buttonNext;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::botonSiguiente() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:End() )

   ::oDlg:bStart  := {|| ::startDialog() }

   ::oDlg:addFastKey( VK_F5, {|| ::botonSiguiente() } )   

   ACTIVATE DIALOG ::oDlg CENTER

   oBmp:End()

RETURN ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD startDialog()

   ::buttonPrior:Hide()

   ::buttonNext:setText( "&Importar")

   ::oBrwLines:Load()

   ::loadLinesDocument()

   ::setBrowseLinesDocument()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD botonSiguiente()

   if !::oDocumentLines:anySelect()
      msgStop( "No hay líneas seleccionadas." )
   else
      ::oDlg:End( IDOK )
   end if

Return ( Self )

//---------------------------------------------------------------------------//
//
// Convierte las lineas del albaran en objetos
//

METHOD loadLinesDocument() 

   local hDictionary    
   local oDocumentLine

   if empty( ::getCodigoProveedor() )
      msgStop( "Es necesario codificar un proveedor." )
      Return .f.
   end if 

   ::oDocumentLines:reset()

   ( ::getHeaderAlias() )->( ordsetfocus( "cCodPrv" ) )

   if ( ::getHeaderAlias() )->( dbseek( ::getCodigoProveedor() ) )

      while ( ::getHeaderAlias() )->cCodPrv == ::getCodigoProveedor() .and. !::getHeaderEof() // 

         if ( ( ::getHeaderAlias() )->nEstado != 3 ) .and. ( ::getLineAlias() )->( dbSeek( ::getHeaderId() ) )

            while ::getHeaderId() == ::aliasDocumentLine:getDocumentId() .and. ! ( ::getLineAlias() )->( eof() )

               hDictionary       := D():getHashFromAlias( ::getLineAlias(), ::getLineDictionary() )

               oDocumentLine     := SupplierDeliveryNoteDocumentLine():newFromDictionary( self, hDictionary )

               if oDocumentLine:getUnitsAwaitingReception() > 0
                  ::oDocumentLines:addLines( oDocumentLine )
               end if 

               ( ::getLineAlias() )->( dbskip() ) 

            end while

         end if 

         ( ::getHeaderAlias() )->( dbSkip() )

      end while

   end if 

RETURN ( .t. ) 

//---------------------------------------------------------------------------//