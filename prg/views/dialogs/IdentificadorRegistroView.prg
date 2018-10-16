#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS IdentificadorRegistroView FROM SQLBaseView

   DATA idRegistro      INIT 0

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate( nId )

   local oBmp
   local oBtnAceptar

   ::idRegistro         := iif( empty( nId ), 0, nId )

   DEFINE DIALOG        ::oDialog ;
      RESOURCE          "IDENTIFICADOR_REGISTRO"

      REDEFINE BITMAP oBmp ;
         ID             500 ;
         RESOURCE       "gc_map_location_48" ;
         TRANSPARENT ;
         OF             ::oDialog

      REDEFINE GET      ::idRegistro ; 
         ID             100 ;
         SPINNER ;    
         PICTURE        "999999999" ;      
         OF             ::oDialog    

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), oBtnAceptar:Click(), ) }
   end if



   ACTIVATE DIALOG ::oDialog CENTER

   oBmp:End()

   if ::oDialog:nResult == IDOK
      RETURN ( ::idRegistro )
   end if 

RETURN ( 0 )

//--------------------------------------------------------------------------//

