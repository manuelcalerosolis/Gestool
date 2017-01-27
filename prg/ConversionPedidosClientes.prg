#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TConversionPedidosClientes FROM TConversionDocumentos 

   DATA cCodigoCliente                             INIT ""

   METHOD Dialog()

   METHOD setCodigoCliente( cCodigoCliente )       INLINE ( ::cCodigoCliente := cCodigoCliente )
   METHOD getCodigoCliente()                       INLINE ( ::cCodigoCliente )

   METHOD startDialog()
      METHOD botonSiguiente()

   METHOD loadLinesDocument()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Dialog() 

   local oBmp

   DEFINE DIALOG ::oDlg ;
      RESOURCE    "ASS_CONVERSION_DOCUMENTO"

   REDEFINE BITMAP oBmp ;
      ID          500 ;
      RESOURCE    "gc_clipboard_empty_user_48" ;
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

   ::setDocumentPedidosClientes()

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

   local oDocumentLine

   if empty( ::getCodigoCliente() )
      msgStop( "Es necesario codificar un cliente." )
      Return .f.
   end if 

   ::oDocumentLines:reset()

   ( ::getHeaderAlias() )->( ordsetfocus( "cCodCli" ) )

   if ( ::getHeaderAlias() )->( dbseek( ::getCodigoCliente() ) )

      while ( ::getHeaderAlias() )->cCodCli == ::getCodigoCliente() .and. !::getHeaderEof() // 

         if ( ( ::getHeaderAlias() )->nEstado != 3 ) .and. ( ::getLineAlias() )->( dbSeek( ::getHeaderId() ) )

            while ::getHeaderId() == ::aliasDocumentLine:getDocumentId() .and. ! ( ::getLineAlias() )->( eof() )

               oDocumentLine     := CustomerOrderDocumentLine():new( self )

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