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

	::oController		:=oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oGetNombre
   local oGetCodigo
   local oGetOrden
   local oGetCodigoBarras

   DEFINE DIALOG oDlg RESOURCE "PRODET_SQL" TITLE ::lblTitle() + "propiedad"

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

   REDEFINE GET 	oGetOrden ;
   	VAR ::oController:oModel:hBuffer[ "orden" ] ;
      MEMO ;
      ID       	120 ;
      WHEN     	( !::oController:isZoomMode() ) ;
      OF       	oDlg

   REDEFINE GET 	oGetCodigoBarras ;
   	VAR ::oController:oModel:hBuffer[ "codigo_barras" ] ;
      MEMO ;
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

