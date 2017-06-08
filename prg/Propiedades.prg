#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS Propiedades FROM SQLBaseView

   METHOD   New()
 
   METHOD   Dialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

   ::cImageName		:= "gc_coathanger_16"

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oBtnOk
   local oGetNombre
   local oGetCodigo

   DEFINE DIALOG oDlg RESOURCE "PROP_SQL" TITLE ::lblTitle() + "propiedades"

   REDEFINE GET   oGetCodigo ;
      VAR         ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validCodigo( oGetCodigo ) ) ;
      OF          oDlg

   REDEFINE GET   oGetNombre ;
      VAR         ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validNombre( oGetNombre ) ) ;
      OF          oDlg

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "is_color" ] ;
      ID       	200 ;
      WHEN     	( !::oController:isZoomMode() ) ;
      OF       	oDlg

   ::oController:getController( 'lineas' ):oView:buildSQLNuclearBrowse( 120, oDlg )

   REDEFINE BUTTON;
      ID       	500 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
      ACTION   	( ::oController:getController( 'lineas' ):Append() )

   REDEFINE BUTTON;
      ID       	501 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
      ACTION   	( ::oController:getController( 'lineas' ):Edit() )

   REDEFINE BUTTON;
      ID       	502 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
      ACTION   	( ::oController:getController( 'lineas' ):Delete() )

   REDEFINE BUTTON;
      ID      		503 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
      ACTION   	( ::oController:getController( 'lineas' ):UpDet() )

   REDEFINE BUTTON;
      ID       	504 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
      ACTION   	( ::oController:getController( 'lineas' ):DownDet() )

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

   // evento bstart-----------------------------------------------------------

   oDlg:bStart    := {|| oGetCodigo:setFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//