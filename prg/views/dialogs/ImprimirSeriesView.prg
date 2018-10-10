#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS ImprimirSeriesView FROM SQLBaseView

   DATA oDialog

   DATA oListboxFile
   DATA aListboxFile                   INIT {}
   DATA cListboxFile                   INIT ""

   DATA lCopies                        INIT .t.
   DATA nCopies                        INIT 1

   DATA cPrinter                       INIT prnGetName()

   METHOD Activate()

   METHOD startActivate()

   METHOD runActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   local oBmp
   local oButton

   DEFINE DIALOG ::oDialog RESOURCE "IMPRIMIR_SERIES" 

      REDEFINE BITMAP oBmp ;
         ID          500 ;
         RESOURCE    "gc_printer2_48" ;
         TRANSPARENT ;
         OF          ::oDialog

      REDEFINE SAY   ;
         PROMPT      ::getSelectedRecords() ;
         ID          100 ;
         OF          ::oDialog

      TBtnBmp():ReDefine( 110, "new16",,,,, {|| ::oController:newDocument() }, ::oDialog, .f., , .f., "A�adir formato" )

      TBtnBmp():ReDefine( 120, "edit16",,,,, {|| ::oController:editDocument() }, ::oDialog, .f., , .f., "Modificar formato" )

      TBtnBmp():ReDefine( 130, "del16",,,,, {|| ::oController:deleteDocument() }, ::oDialog, .f., , .f., "Eliminar formato" )

      TBtnBmp():ReDefine( 140, "refresh16",,,,, {|| ::oController:loadDocuments() }, ::oDialog, .f., , .f., "Recargar formato" )

      REDEFINE LISTBOX ::oListboxFile ;
         VAR         ::cListboxFile ;
         ITEMS       ::aListboxFile ;
         ID          150 ;
         OF          ::oDialog 

      REDEFINE CHECKBOX ::lCopies ;
         ID          160 ;
         OF          ::oDialog

      REDEFINE GET   ::nCopies ;
         ID          170 ;
         PICTURE     "99999" ;
         SPINNER ;
         MIN         1 ;
         MAX         99999 ;
         WHEN        ( !::lCopies ) ;
         OF          ::oDialog

      REDEFINE COMBOBOX ::cPrinter ;
         ID          190 ;
         ITEMS       aGetPrinters() ;
         OF          ::oDialog

      REDEFINE FLATBTN oButton ;
         ID          IDOK ;
         OF          ::oDialog ;
         COLOR       CLR_BLACK, RGB( 79, 192, 141 ) ;
         NOBORDER    ;
         ACTION      ( ::runActivate() )

      REDEFINE FLATBTN ;
         ID          IDCANCEL ;
         OF          ::oDialog ;
         COLOR       CLR_BLACK, CLR_HGRAY ;
         NOBORDER    ;
         ACTION      ( ::oDialog:end() )

      ::oDialog:AddFastKey( VK_F5, {|| ::runActivate() } )

      ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   oBmp:end()   

RETURN ( ::oDialog:nResult )

//--------------------------------------------------------------------------//

METHOD startActivate()

   ::oController:loadDocuments()

RETURN ( self )

//--------------------------------------------------------------------------//

METHOD runActivate()

   ::oDialog:disable()

   ::oController:showDocument( IS_PRINTER, ::cListboxFile, ::nCopies, ::cPrinter )

   ::oDialog:enable()

RETURN ( self )

//--------------------------------------------------------------------------//

