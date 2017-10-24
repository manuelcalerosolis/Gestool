#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS ImportarMovimientosAlmacenLineasView FROM SQLBaseView 

   DATA memoInventario

   METHOD New( oController )

   METHOD Activate()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

   msgalert( ::oController:className(), "className" )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   local oDialog

   local cLineas

   DEFINE DIALOG oDialog RESOURCE "Importar_Inventario" 

      REDEFINE GET   cLineas ;
         MEMO ;
         ID          110 ;
         OF          oDialog

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          oDialog ;
         ACTION      ( ::oController:procesarLineas( cLineas ), oDialog:end( IDOK ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDialog ;
         CANCEL ;
         ACTION      ( oDialog:end() )

      oDialog:AddFastKey( VK_F5, {|| ::oController:procesarLineas( cLineas ), oDialog:end( IDOK ) } )

   ACTIVATE DIALOG oDialog CENTER

RETURN ( self )

//----------------------------------------------------------------------------//
