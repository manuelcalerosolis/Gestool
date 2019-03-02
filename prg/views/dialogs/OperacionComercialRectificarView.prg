#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionComercialRectificarView FROM SQLBaseView
  
   DATA cCausa

   DATA cNumeroDocumento

   DATA oMotivo
   DATA cMotivo

   METHOD InitActivate()               INLINE ( ::Activating(), ::Activate() )

   METHOD Activate()
      METHOD Activating()
      METHOD startActivate()

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

   ::oController:getFacturasController():getSelector():Bind( bSETGET( ::cNumeroDocumento ) )
   ::oController:getFacturasController():getSelector():Build( { "idGet" => 100, "idText" => 101, "idLink" => 102, "oDialog" => ::oDialog } )
   ::oController:getFacturasController():getSelector():setValid( {|| ::oController:getRectifictivaValidator():validate( "factura", ::cNumeroDocumento ) } )
   
   REDEFINE COMBOBOX ::cCausa;
      ITEMS       RECTIFICATIVA_ITEMS ;
      ID          110 ;
      VALID       ::oController:getRectifictivaValidator():validate( "causa", ::cCausa ) ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oMotivo ;
      VAR         ::cMotivo ;
      ID          120 ;
      VALID       ::oController:getRectifictivaValidator():validate( "motivo", ::cMotivo ) ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oDialog ;

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD Activating() CLASS OperacionComercialRectificarView

   ::cCausa             := ""

   ::cNumeroDocumento   := space( 20 )
   
   ::cMotivo            := space( 200 )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS OperacionComercialRectificarView

   ::oController:getFacturasController():getSelector():Start()

   ::oController:getFacturasController():getSelector():setFocus()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS OperacionComercialRectificarValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD getView()                    INLINE ( ::oController:getRectificativaDialogView() )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS OperacionComercialRectificarValidator

   ::hValidators  := {  "factura"   => {  "required"  => "La factura es un dato requerido" },;
                        "causa"     => {  "required"  => "La causa es un dato requerido" },;
                        "motivo"    => {  "required"  => "El motivo es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

