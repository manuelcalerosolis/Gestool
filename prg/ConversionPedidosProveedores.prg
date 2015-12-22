#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TConversionPedidosProveedores FROM TConversionDocumentos // FROM DialogBuilder

   METHOD New()

   METHOD Dialog()

   METHOD startDialog()

   METHOD loadLinesDocument()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New()

   ::OpenFiles()

   ::cDocument       := "Pedido proveedores"

   ::oDocumentLines  := DocumentLines():New( Self ) // AliasDocumentLine():New( Self )   

   ::setDocumentPedidosProveedores()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog() 

   local oBmp

   DEFINE DIALOG ::oDlg ;
      RESOURCE    "ASS_CONVERSION_DOCUMENTO"

   REDEFINE BITMAP oBmp ;
      ID          500 ;
      RESOURCE    "hand_point_48" ;
      TRANSPARENT ;
      OF          ::oDlg

   REDEFINE PAGES ::oFld ;
      ID          100 ;
      OF          ::oDlg ;
      DIALOGS     "ASS_CONVERSION_DOCUMENTO_3"

   ::DialogSelectionLines( ::oFld:aDialogs[1] )
   
   // Botones -----------------------------------------------------------------

   REDEFINE BUTTON ::oBtnAnterior;
      ID          3 ;
      OF          ::oDlg ;
      ACTION      ( ::BotonAnterior() )

   REDEFINE BUTTON ::oBtnSiguiente;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::BotonSiguiente() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:End() )

   ::oDlg:bStart  := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::CloseFiles()

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD startDialog()

   ::oBrwLines:Load()

   ::loadLinesDocument()

   ::setBrowseLinesDocument()

RETURN ( Self )

//---------------------------------------------------------------------------//
//
// Convierte las lineas del albaran en objetos
//

METHOD loadLinesDocument() 

   local aStatus
   local hDictionary    

   ::oDocumentLines:reset()

   aStatus              := aGetStatus( ::getLineAlias(), .t. )

   ( ::getLineAlias() )->( dbgotop() )  
   while !( ::getLineAlias() )->( eof() ) 

      hDictionary       := D():getHashFromAlias( ::getLineAlias(), ::getLineDictionary() )

      ::oDocumentLines:addLines( DocumentLine():newFromDictionary( hDictionary ) )

      ( ::getLineAlias() )->( dbskip() ) 
   
   end while

   setStatus( ::getLineAlias(), aStatus ) 

RETURN ( .t. ) 

//---------------------------------------------------------------------------//
