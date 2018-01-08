#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS ContadoresView FROM SQLBaseView

   DATA oDialog

   DATA comboDocumentCounter

   DATA getDocumentCounter

   METHOD changeDocumentCounter()      INLINE ( .t. )

   METHOD Activate()

   METHOD StartActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   local oBmp

   DEFINE DIALOG  ::oDialog ;
      TITLE       "Estrablecer contadores" ;
      RESOURCE    "SETCONTADORES"

   REDEFINE BITMAP oBmp ;
      ID          500 ;
      RESOURCE    "gc_document_text_pencil_48" ;
      TRANSPARENT ;
      OF          ::oDialog 

   REDEFINE COMBOBOX ::comboDocumentCounter ;
      VAR         ::oController:oModel:hBuffer[ "serie" ] ;
      ITEMS       DOCUMENT_SERIES ;
      ID          100 ;
      OF          ::oDialog 

   REDEFINE GET   ::getDocumentCounter ;
      VAR         ::oController:oModel:hBuffer[ "value" ] ;
      ID          110 ;
      SPINNER ;
      PICTURE     "999999999" ;
      VALID       ( ::oController:oModel:hBuffer[ "value" ] > 0 ) ;
      OF          ::oDialog  

   ::getDocumentCounter:bChange  := {|| ::changeDocumentCounter() }

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      ACTION      ( ::oDialog:end( IDOK ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

      ::oDialog:bStart  := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   oBmp:End()

RETURN ( ::oDialog:nResult )

//--------------------------------------------------------------------------//

METHOD StartActivate()

   if empty( ::oController:oModel:hBuffer[ "serie" ] )
      ::comboDocumentCounter:hide()
   end if 

RETURN ( self )

//--------------------------------------------------------------------------//
