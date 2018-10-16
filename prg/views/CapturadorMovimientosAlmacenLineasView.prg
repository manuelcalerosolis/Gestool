#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS CapturadorMovimientosAlmacenLineasView FROM SQLBaseView 

   DATA memoInventario

   METHOD New( oController )

   METHOD Activate()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD Activate()

   local cLines
   local oDialog

   DEFINE DIALOG oDialog RESOURCE "IMPORTAR_INVENTARIO" 

      REDEFINE GET   cLines ;
         MEMO ;
         ID          110 ;
         OF          oDialog

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ACTIVATE DIALOG oDialog CENTER

RETURN ( self )

//----------------------------------------------------------------------------//
