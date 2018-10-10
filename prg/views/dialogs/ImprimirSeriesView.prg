#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS ImprimirSeriesView FROM SQLBaseView

   DATA oDialog

   DATA oSayRegistrosSeleccionados

   DATA oListboxFile
   DATA aListboxFile                   INIT {}
   DATA cListboxFile                   INIT ""

   DATA lCopies                        INIT .t.
   DATA nCopies                        INIT 1

   DATA cPrinter                       INIT prnGetName()

   METHOD Activate()

   METHOD startActivate()

   METHOD runActivate()

   METHOD getRegistrosSeleccionados()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   local oBmp

   DEFINE DIALOG ::oDialog RESOURCE "IMPRIMIR_SERIES" 

      REDEFINE BITMAP oBmp ;
         ID          500 ;
         RESOURCE    "gc_printer2_48" ;
         TRANSPARENT ;
         OF          ::oDialog

      REDEFINE SAY   ::oSayRegistrosSeleccionados ;
         VAR         ::getRegistrosSeleccionados() ;
         ID          100 ;
         OF          ::oDialog

      TBtnBmp():ReDefine( 110, "new16",,,,, {|| ::oController:newDocument() }, ::oDialog, .f., , .f., "Añadir formato" )

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

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ::oDialog ;
         ACTION      ( ::runActivate() )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ::oDialog ;
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

   ::oController:runActivate( IS_PRINTER, ::cListboxFile, ::nCopies, ::cPrinter )

   ::oDialog:enable()

RETURN ( self )

//--------------------------------------------------------------------------//

METHOD getRegistrosSeleccionados()

   local nLen  := len( ::oController:getIds() )

   if nLen > 1 
      RETURN ( hb_ntos( nLen ) + " registros seleccionados" )
   end if 

RETURN ( hb_ntos( nLen ) + " registro seleccionado" )

//---------------------------------------------------------------------------//
