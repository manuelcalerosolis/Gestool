#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SituacionesView FROM SQLBaseView

   METHOD   New()
    
   METHOD   Dialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController        := oController

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oBtnOk
   local oGetNombre

   DEFINE DIALOG oDlg RESOURCE "SITUACION" TITLE ::LblTitle() + "situación"

   REDEFINE GET   oGetNombre ;
      VAR         ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          100 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDlg

   REDEFINE BUTTON oBtnOk ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( !::oController:isZoomMode() ) ;
      ACTION      ( if( validateDialog( oDlg ), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   // Teclas rpidas-----------------------------------------------------------

   oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//
