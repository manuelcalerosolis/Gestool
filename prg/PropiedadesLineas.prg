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
      OF       	oDlg

   REDEFINE GET 	oGetCodigoBarras ;
   	VAR         ::oController:oModel:hBuffer[ "codigo_barras" ] ;
      ID       	130 ;
      WHEN     	( !::oController:isZoomMode() ) ;
      OF       	oDlg
/*
   REDEFINE GET   oGetColor ;
      VAR      ::oController:oModel:hBuffer[ "color" ] ;
      ID       200 ;
      COLOR    if( aTmpPro[ ( dbfProT )->( FieldPos( "lColor" ) ) ], aTmp[ ( dbfProL )->( FieldPos( "nColor" ) ) ], CLR_GET ), if( aTmpPro[ ( dbfProT )->( FieldPos( "lColor" ) ) ], aTmp[ ( dbfProL )->( FieldPos( "nColor" ) ) ], CLR_GET ) ;
      BITMAP   "LUPA" ;
      WHEN     ( nMode != ZOOM_MODE .and. aTmpPro[ ( dbfProT )->( FieldPos( "lColor" ) ) ] ) ;
      ON HELP  (  aTmp[ ( dbfProL )->( FieldPos( "nColor" ) ) ]  := ChooseColor(),;
                  aGet[ ( dbfProL )->( FieldPos( "nColor" ) ) ]:SetColor( aTmp[ ( dbfProL )->( FieldPos( "nColor" ) ) ], aTmp[ ( dbfProL )->( FieldPos( "nColor" ) ) ] ),;
                  aGet[ ( dbfProL )->( FieldPos( "nColor" ) ) ]:Refresh() ) ;
      OF       oDlg
*/

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

