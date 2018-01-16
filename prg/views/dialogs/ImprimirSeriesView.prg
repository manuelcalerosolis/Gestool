#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS ImprimirSeriesView FROM SQLBaseView

   DATA oDialog

   METHOD Activate()

   METHOD StartActivate()

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

   msgalert( "StartActivate" )

RETURN ( self )

//--------------------------------------------------------------------------//
