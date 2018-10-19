#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS ImprimirSeriesView FROM SQLBaseView

   DATA oDialog

   DATA oDocument
   DATA cDocument                      INIT ""

   DATA oCopies
   DATA nCopies                        INIT 1

   DATA cPrinter                       INIT prnGetName()

   METHOD New( oController )

   METHOD Activate()

   METHOD startActivate()

   METHOD runActivate()

   METHOD loadDocuments()              INLINE ( ::getController():loadDocuments() )
   
   METHOD getDocumentPrint()           INLINE ( ::getController():getDocumentPrint() )

   METHOD getCopyPrint()               INLINE ( ::getController():getCopyPrint() )

   METHOD reLoadDocuments()            INLINE ( ::oDocument:SetItems( ::oController:loadDocuments(), .t. ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super():New( oController )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG ::oDialog RESOURCE "IMPRIMIR_SERIES" 

      REDEFINE BITMAP   ;
         ID             500 ;
         RESOURCE       "gc_printer2_48" ;
         TRANSPARENT    ;
         OF             ::oDialog

      REDEFINE SAY      ;
         PROMPT         ::getSelectedRecords() ;
         ID             100 ;
         OF             ::oDialog

      TBtnBmp():ReDefine( 110, "new16",,,,, {|| ::oController:newDocument() }, ::oDialog, .f., , .f., "Añadir formato" )

      TBtnBmp():ReDefine( 120, "edit16",,,,, {|| ::oController:editDocument( ::cDocument ) }, ::oDialog, .f., , .f., "Modificar formato" )

      TBtnBmp():ReDefine( 130, "del16",,,,, {|| ::oController:deleteDocument( ::cDocument ) }, ::oDialog, .f., , .f., "Eliminar formato" )

      TBtnBmp():ReDefine( 140, "refresh16",,,,, {|| ::reLoadDocuments() }, ::oDialog, .f., , .f., "Recargar formatos" )

      // Xbrowse files --------------------------------------------------------

      REDEFINE COMBOBOX ::oDocument ;
         VAR            ::cDocument ;
         ID             150 ;
         ITEMS          ::oController:loadDocuments() ;
         OF             ::oDialog

      REDEFINE GET      ::oCopies ;
         VAR            ::nCopies ;
         ID             170 ;
         PICTURE        "99999" ;
         SPINNER ;
         MIN            1 ;
         MAX            99999 ;
         OF             ::oDialog

      REDEFINE COMBOBOX ::cPrinter ;
         ID             190 ;
         ITEMS          aGetPrinters() ;
         OF             ::oDialog

      // Botones generales--------------------------------------------------------

      ApoloBtnFlat():Redefine( IDOK, {|| ::runActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

      ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::runActivate(), ) }

      ::oDialog:bStart     := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//--------------------------------------------------------------------------//

METHOD startActivate()

   ::oDocument:Set( ::getDocumentPrint() )

   ::oCopies:cText( ::getCopyPrint() )

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD runActivate()

   ::oDialog:disable()

   ::oController:showDocument( IS_PRINTER, ::cDocument, ::nCopies, ::cPrinter )

   ::oDialog:enable()

RETURN ( nil )

//--------------------------------------------------------------------------//

