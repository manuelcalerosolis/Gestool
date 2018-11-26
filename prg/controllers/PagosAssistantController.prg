#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PagosAssistantController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD gettingSelectSentence()

   METHOD getRecibos()

   METHOD insertRecibosPago()

   METHOD getImportePagar( nImporte )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()        INLINE( ::oController:getBrowseView() )
   
   METHOD getDialogView()        INLINE( if( empty( ::oDialogView ), ::oDialogView := PagosAssistantView():New( self ), ), ::oDialogView )
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLPagosModel():New( self ), ), ::oModel )
   
   METHOD getValidator()         INLINE( if( empty( ::oValidator ), ::oValidator := PagosValidator():New( self  ), ), ::oValidator ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PagosAssistantController

   ::Super:New( oController )

   ::cTitle                         := "Cobros"

   ::cName                          := "cobros"

   ::hImage                         := {  "16" => "gc_hand_money_16",;
                                          "32" => "gc_hand_money_32",;
                                          "48" => "gc_hand_money_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::getCuentasBancariasController():getModel():setEvent( 'addingParentUuidWhere', {|| .f. } )
   ::getCuentasBancariasController():getModel():setEvent( 'gettingSelectSentence', {|| ::gettingSelectSentence() } )

   ::getClientesController():getSelector():setEvent( 'validated', {|| ::getRecibos() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS PagosAssistantController

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oModel )
      ::oModel:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS PagosAssistantController

   ::getCuentasBancariasController():getModel():setGeneralWhere( "parent_uuid = " + quoted( Company():Uuid() ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getRecibos() CLASS PagosAssistantController

   ::insertRecibosPago()

   ::getRecibosPagosController():getRowset():buildPad( ::getRecibosPagosController():getModel():getGeneralSelect( ::getModelBuffer( "uuid" ), ::getModelBuffer( "cliente_codigo" ) ) )

   ::getRecibosPagosController():getBrowseView():Refresh()

      
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertRecibosPago() CLASS PagosAssistantController

   ::getRecibosPagosController():getModel():insertPagoRecibo( ::getModelBuffer( "uuid" ), ::getModelBuffer('cliente_codigo') )

   ::getRecibosPagosController():getModel():updateImporte( ::getModelBuffer( "uuid" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getImportePagar( nImporte )

   if nImporte < 0
      msgstop("Debe introducir un importe válido")
      RETURN ( nil )
   end if

   ::getRecibosPagosController():calculatePayment( nImporte )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PagosAssistantView FROM SQLBaseView

   DATA oImporte

   DATA nImporte                       INIT 0
  
   METHOD Activate()

   METHOD startActivate()

   METHOD addLinksToExplorerBar()

   METHOD defaultTitle()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS PagosAssistantView

   DEFINE DIALOG  ::oDialog;
      RESOURCE    "TRANSACION_COMERCIAL"; 
      TITLE       ::LblTitle() + "cobro"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Cobro" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::redefineExplorerBar()

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General" ;
      DIALOGS     "PAGO_ASISTENTE_SQL" 

   ::oController:getClientesController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "cliente_codigo" ] ) )
   ::oController:getClientesController():getSelector():Build( { "idGet" => 100, "idLink" => 102, "idText" => 101, "idNif" => 103, "idDireccion" => 104, "idCodigoPostal" => 105, "idPoblacion" => 106, "idProvincia" => 107, "idTelefono" => 108, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getClientesController():getSelector():setValid( {|| ::oController:validate( "cliente_codigo" ) } )

   ::getController():getRecibosPagosController():Activate( 500, ::oFolder:aDialogs[1] )

   REDEFINE GET   ::oImporte ;
      VAR         ::nImporte ;
      ID          110 ;
      VALID       ( ::oController:getImportePagar( ::nImporte ) );
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999999999999.99";
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:getModel():hBuffer[ "fecha" ] ;
      ID          120 ;
      VALID       ( ::oController:validate( "fecha" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oController:getMediosPagoController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "medio_pago_codigo" ] ) )
   ::oController:getMediosPagoController():getSelector():Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getMediosPagoController():getSelector():setValid( {|| ::oController:validate( "medio_pago_codigo" ) } )

   ::oController:getCuentasBancariasController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "cuenta_bancaria_codigo" ] ) )
   ::oController:getCuentasBancariasController():getSelector():Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oFolder:aDialogs[1] } )

   REDEFINE GET   ::oController:getModel():hBuffer[ "comentario" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER


RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS PagosAssistantView

   ::addLinksToExplorerBar()

   ::oController:getClientesController():getSelector():Start()

   ::oController:getMediosPagoController():getSelector():Start()

   ::oController:getCuentasBancariasController():getSelector():Start()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS PagosAssistantView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   oPanel:AddLink(   "Incidencias...",;
                        {||::oController:getIncidenciasController():activateDialogView( ::oController:getUuid() ) },;
                           ::oController:getIncidenciasController():getImage( "16" ) )
   
   oPanel:AddLink(   "Documentos...",;
                        {||::oController:getDocumentosController():activateDialogView( ::oController:getUuid() ) },;
                           ::oController:getDocumentosController():getImage( "16" ) )


RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD defaultTitle() CLASS PagosAssistantView

   local cTitle   

   if empty( ::oController:oModel )
      RETURN ( cTitle )
   end if 

   if empty( ::oController:oModel:hBuffer )
      RETURN ( cTitle )
   end if 

   if hhaskey( ::oController:oModel:hBuffer, "concepto" )
      cTitle      :=  alltrim( ::oController:oModel:hBuffer[ "concepto" ] )
   end if

RETURN ( cTitle )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

