#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS ImportadorMovimientosAlmacenLineasView FROM SQLBaseView 

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

   DEFINE DIALOG oDialog RESOURCE "Importar_Inventario" 

      REDEFINE GET   cLines ;
         MEMO ;
         ID          110 ;
         OF          oDialog

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          oDialog ;
         ACTION      ( ::oController:processLines( cLines ), oDialog:end( IDOK ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDialog ;
         CANCEL ;
         ACTION      ( oDialog:end() )

      oDialog:AddFastKey( VK_F5, {|| ::oController:processLines( cLines ), oDialog:end( IDOK ) } )

   ACTIVATE DIALOG oDialog CENTER

RETURN ( self )

//----------------------------------------------------------------------------//
