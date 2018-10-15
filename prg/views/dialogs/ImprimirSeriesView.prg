#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS ImprimirSeriesView FROM SQLBaseView

   DATA oDialog

   DATA oXbrowseFile
   DATA aListboxFile                   INIT {}
   DATA cListboxFile                   INIT ""

   DATA lCopies                        INIT .t.
   DATA nCopies                        INIT 1

   DATA cPrinter                       INIT prnGetName()

   METHOD New( oController )

   METHOD Activate()

   METHOD startActivate()

   METHOD runActivate()

   METHOD loadDocuments()              INLINE ( ::oXbrowseFile:SetArray( ::oController:aFiles, , , .f. ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super():New( oController )

   ::oController:oEvents:Set( 'loadDocuments', {|| ::loadDocuments() } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate()

   local oBmp

   DEFINE DIALOG ::oDialog RESOURCE "IMPRIMIR_SERIES" 

      REDEFINE BITMAP   oBmp ;
         ID             500 ;
         RESOURCE       "gc_printer2_48" ;
         TRANSPARENT    ;
         OF             ::oDialog

      REDEFINE SAY      ;
         PROMPT         ::getSelectedRecords() ;
         ID             100 ;
         OF             ::oDialog

      TBtnBmp():ReDefine( 110, "new16",,,,, {|| ::oController:newDocument() }, ::oDialog, .f., , .f., "Añadir formato" )

      TBtnBmp():ReDefine( 120, "edit16",,,,, {|| ::oController:editDocument( ::oXbrowseFile:aRow ) }, ::oDialog, .f., , .f., "Modificar formato" )

      TBtnBmp():ReDefine( 130, "del16",,,,, {|| ::oController:deleteDocument( ::oXbrowseFile:aRow ) }, ::oDialog, .f., , .f., "Eliminar formato" )

      TBtnBmp():ReDefine( 140, "refresh16",,,,, {|| ::oController:loadDocuments() }, ::oDialog, .f., , .f., "Recargar formato" )

      // Xbrowse files --------------------------------------------------------

      ::oXbrowseFile                         := TXBrowse():New( ::oDialog )

      ::oXbrowseFile:bClrSel                 := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oXbrowseFile:bClrSelFocus            := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oXbrowseFile:SetArray( ::oController:aFiles, , , .f. )

      ::oXbrowseFile:lHScroll                := .f.
      ::oXbrowseFile:lVScroll                := .t.
      ::oXbrowseFile:lRecordSelector         := .f.
      ::oXbrowseFile:lHeader                 := .f.
      ::oXbrowseFile:nMarqueeStyle           := 5

      ::oXbrowseFile:CreateFromResource( 150 )

      with object ( ::oXbrowseFile:AddCol() )
         :cHeader       := ""
         :bStrData      := {|| if( !empty( ::oController:aFiles ), ::oController:aFiles[ ::oXbrowseFile:nArrayAt ], "" ) }
         :nWidth        := 400
      end with

      //-----------------------------------------------------------------------

      REDEFINE CHECKBOX ::lCopies ;
         ID             160 ;
         OF             ::oDialog

      REDEFINE GET      ::nCopies ;
         ID             170 ;
         PICTURE        "99999" ;
         SPINNER ;
         MIN            1 ;
         MAX            99999 ;
         WHEN           ( !::lCopies ) ;
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

   ::oController:loadDocuments()

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD runActivate()

   ::oDialog:disable()

   ::oController:showDocument( IS_PRINTER, ::oXbrowseFile:aRow, ::nCopies, ::cPrinter )

   ::oDialog:enable()

RETURN ( nil )

//--------------------------------------------------------------------------//

