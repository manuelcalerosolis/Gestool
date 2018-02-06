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

      REDEFINE BUTTON   oBtnAceptar ;
         ID             IDOK ;
         OF             ::oDialog ;
         ACTION         ( ::oDialog:End( IDOK ) )

      REDEFINE BUTTON  ;
         ID             IDCANCEL ;
         OF             ::oDialog ;
         CANCEL ;
         ACTION         ( ::oDialog:End( IDCANCEL ) )

      ::oDialog:AddFastKey( VK_F5, {|| oBtnAceptar:Click() } )

   ACTIVATE DIALOG ::oDialog CENTER

   oBmp:End()

   if ::oDialog:nResult == IDOK
      RETURN ( ::idRegistro )
   end if 

RETURN ( 0 )

//--------------------------------------------------------------------------//

