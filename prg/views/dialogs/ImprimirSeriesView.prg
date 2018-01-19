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

   DATA lNumeroCopias                  INIT .t.
   DATA nNumeroCopias                  INIT 1

   DATA lInvertirOrden                 INIT .f.

   DATA cPrinter                       INIT prnGetName()

   METHOD Activate()

   METHOD StartActivate()

   METHOD getRegistrosSeleccionados()  INLINE  ( iif( !empty( ::oController ),;
                                                      "( " + alltrim( str( len( ::oController:getIds() ) ) ) + ") registro(s) seleccionado(s)",;
                                                      "( 0 ) registro(s) seleccionado(s)" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   local oBmp

   DEFINE DIALOG ::oDialog RESOURCE "IMPRIMIR_SERIES" TITLE "Imprimir series de documentos"

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

      REDEFINE LISTBOX ::oListboxFile ;
         VAR         ::cListboxFile ;
         ITEMS       ::aListboxFile ;
         ID          150 ;
         OF          ::oDialog 

      REDEFINE CHECKBOX ::lNumeroCopias ;
         ID          160 ;
         OF          ::oDialog

      REDEFINE GET   ::nNumeroCopias ;
         ID          170 ;
         PICTURE     "99999" ;
         SPINNER ;
         MIN         1 ;
         MAX         99999 ;
         WHEN        ( !::lNumeroCopias ) ;
         OF          ::oDialog

      REDEFINE CHECKBOX ::lInvertirOrden ;
         ID          180 ;
         OF          ::oDialog

      REDEFINE COMBOBOX ::cPrinter ;
         ID          190 ;
         ITEMS       aGetPrinters() ;
         OF          ::oDialog

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ::oDialog ;
         ACTION      ( ::oController:Print() )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:end() )

      ::oDialog:AddFastKey( VK_F5, {|| ::oController:Print() } )

      ::oDialog:bStart  := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   oBmp:end()   

RETURN ( ::oDialog:nResult )

//--------------------------------------------------------------------------//

METHOD StartActivate()

   ::oController:loadDocuments()

RETURN ( self )

//--------------------------------------------------------------------------//
