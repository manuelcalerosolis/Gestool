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
   local oGetNombre
   local oGetCodigo
   local oControlBrw

   DEFINE DIALOG oDlg RESOURCE "PROP" TITLE ::lblTitle() + "propiedades"

   REDEFINE GET   oGetCodigo ;
      VAR         ::oController:oModel:hBuffer[ "codigo" ] ;
      MEMO ;
      ID          100 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      OF          oDlg

   REDEFINE GET   oGetNombre ;
      VAR         ::oController:oModel:hBuffer[ "nombre" ] ;
      MEMO ;
      ID          110 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      OF          oDlg

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "is_color" ] ;
      ID       	200 ;
      WHEN     	( !::oController:isZoomMode() ) ;
      OF       	oDlg
/*
   oControlBrw 	:= ::oController:oPropiedadesLineasController:showBrowseInDialog( 120, oDlg )

   REDEFINE BUTTON;
      ID       	500 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
      ACTION   	( oControlBrw:Append( oControlBrw:oView:oBrowse ) )

   REDEFINE BUTTON;
      ID       	501 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
      ACTION   	( WinEdtRec( oBrw, bEdtDet, dbfTmpProL, aTmp ) )

   REDEFINE BUTTON;
      ID       	502 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
      ACTION   	( DeleteLinea( oBrw ) )

   REDEFINE BUTTON;
      ID      		503 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
      ACTION   	( UpDet( oBrw ) )

   REDEFINE BUTTON;
      ID       	504 ;
      OF       	oDlg ;
      WHEN     	( !::oController:isZoomMode() ) ;
      ACTION   	( DownDet( oBrw ) )
*/
   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( !::oController:isZoomMode() ) ;
      ACTION      ( ::oController:validDialog( oDlg, oGetNombre, oGetCodigo ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   // Teclas rpidas-----------------------------------------------------------

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   // evento bstart-----------------------------------------------------------

   oDlg:bStart    := {|| oGetNombre:setFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//