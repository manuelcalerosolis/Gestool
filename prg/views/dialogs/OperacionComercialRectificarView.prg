#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionComercialRectificarView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS OperacionComercialRectificarView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "FACTURA_RECTIFICATIVA" ;
      TITLE       "Rectificar factura"

   REDEFINE BITMAP ::oBitmap ; 
      ID          900 ;
      RESOURCE    ::oController:GetImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog ;

   ::oController:getFacturasController():getSelector():Bind( bSETGET( ::oController:getModel():hBuffer[ "parent_uuid" ] ) )
   ::oController:getFacturasController():getSelector():Build( { "idGet" => 100, "idText" => 101, "idLink" => 102, "oDialog" => ::oDialog } )
   ::oController:getFacturasController():getSelector():setValid( {||msgalert( ::oController:getRectifictivaValidator():validate("factura"), "validacion de factura" ), ::oController:getRectifictivaValidator():validate( "factura" ) } )
   
   REDEFINE COMBOBOX ::getController():getModel():hBuffer[ "causa" ];
      ITEMS    RECTIFICATIVA_ITEMS ;
      ID       110 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oDialog ;

      REDEFINE COMBOBOX ::getController():getModel():hBuffer[ "motivo" ];
      ITEMS    RECTIFICATIVA_ITEMS ;
      ID       120 ;
      WHEN     ( ::getController():isNotZoomMode() ) ;
      OF       ::oDialog ;

   /*ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

    ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if*/

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS OperacionComercialRectificarValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD sayMessage( cMessage )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS OperacionComercialRectificarValidator

   ::hValidators  := {  "factura"   =>               {  "required"           => "La factura es un dato requerido"},;
                        "causa"     =>               {  "required"           => "La causa es un dato requerido"},;
                        "motivo"    =>               {  "required"           => "El motivo es un dato requerido"} }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD sayMessage( cMessage )

   local cText    := strtran( cMessage, "{value}", alltrim( cvaltostr( ::uValue ) ) )

   if empty( ::oController:getRectificativaDialogView() ) .or. empty( ::oController:getRectificativaDialogView():oMessage )
      msgstop( cText, "Error" )
      RETURN ( nil )
   end if 
   ::oController:getRectificativaDialogView():showMessage( cText )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//