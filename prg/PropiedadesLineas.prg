#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PropiedadesLineas FROM SQLBaseView

	METHOD New()

	METHOD Dialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

	::oController		  := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oBtnOk
   local oGetColor
   local oGetOrden
   local oGetNombre
   local oGetCodigo
   local oGetCodigoBarras

   DEFINE DIALOG oDlg RESOURCE "PRODET_SQL" TITLE ::lblTitle() + "propiedad"

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

   REDEFINE GET   oGetOrden ;
   	VAR         ::oController:oModel:hBuffer[ "orden" ] ;
      PICTURE     "9999" ;
      ID       	120 ;
      WHEN     	( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validOrden( oGetOrden ) ) ;
      OF       	oDlg

   REDEFINE GET 	oGetCodigoBarras ;
   	VAR         ::oController:oModel:hBuffer[ "codigo_barras" ] ;
      ID       	130 ;
      WHEN     	( !::oController:isZoomMode() ) ;
      OF       	oDlg

   REDEFINE GET   oGetColor ;
      VAR         ::oController:oModel:hBuffer[ "color" ] ;
      ID          200 ;
      BITMAP      "LUPA" ;
      WHEN        (  !::oController:isZoomMode() ) ;
      OF          oDlg

   if !empty( ::oController:oModel:hBuffer[ "color" ] )
      oGetColor:setColor( ::oController:oModel:hBuffer[ "color" ], ::oController:oModel:hBuffer[ "color" ] )
   else
      oGetColor:setColor( CLR_GET, CLR_GET )
   end if 

   oGetColor:bHelp   := {||   ::oController:oModel:hBuffer[ "color" ] := ChooseColor(),;
                              oGetColor:setColor( ::oController:oModel:hBuffer[ "color" ], ::oController:oModel:hBuffer[ "color" ] ),;
                              oGetColor:Refresh() }

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

   oDlg:addFastKey( VK_F5, {|| oBtnOk:Click() } )

   // evento bstart-----------------------------------------------------------

   oDlg:bStart    := {|| oGetCodigo:setFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

