#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PagosAssistantController FROM SQLNavigatorController

   DATA nImporte                       

   DATA cCodigoCliente                 INIT ""

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD gettingSelectSentence()

   METHOD getRecibos()

   METHOD insertRecibosPago()

   METHOD getImportePagar( nImporte )

   METHOD OtherClient()

   METHOD resetImporteAndCliente()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE ( if( !empty(::oController), ::oController:getBrowseView(), nil ) )
   
   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := PagosAssistantView():New( self ), ), ::oDialogView )
   
   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLPagosModel():New( self ), ), ::oModel )
   
   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := PagosValidator():New( self  ), ), ::oValidator ) 

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
   ::setEvent( 'appended',     {|| ::getRecibosPagosController():getModel():InsertPagoReciboAssistant( ::getModelBuffer( "uuid" ) ) } )
   ::setEvent( 'exitAppended', {|| ::getRecibosPagosTemporalController():getModel():dropTemporalTable(), ::resetImporteAndCliente() } )

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

METHOD resetImporteAndCliente()

   ::cCodigoCliente :=""

   ::getDialogView():oImporte:cText( 0 )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS PagosAssistantController

   ::getCuentasBancariasController():getModel():setGeneralWhere( "parent_uuid = " + quoted( Company():Uuid() ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD OtherClient( cCodigoCliente ) CLASS PagosAssistantController

   ::getRecibosPagosTemporalController():getModel():deleteTemporal()

   ::insertRecibosPago()

   ::getRecibosPagosTemporalController():getRowset():buildPad( ::getRecibosPagosTemporalController():getModel():getGeneralSelect( ::getModelBuffer( "uuid" ), ::getModelBuffer( "cliente_codigo" ) ) )

   ::getRecibosPagosTemporalController():getBrowseView():Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getRecibos() CLASS PagosAssistantController

   if ::cCodigoCliente == ::getModelBuffer("cliente_codigo")
      RETURN ( nil )
   end if

   ::cCodigoCliente := ::getModelBuffer("cliente_codigo")

   ::OtherClient()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertRecibosPago() CLASS PagosAssistantController

   ::getRecibosPagosTemporalController():getModel():InsertPagoReciboTemporal( ::getModelBuffer( "uuid" ), ::getModelBuffer('cliente_codigo') )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getImportePagar( nImporte )

   if ::nImporte == nImporte
      RETURN ( .t. )
   end if

   if nImporte <= 0 
      msgstop("Debe introducir un importe válido")
      RETURN ( .f. )
   end if

   ::nImporte  := nImporte

   ::getRecibosPagosTemporalController():getRowSet():Refresh()

   ::getRecibosPagosTemporalController():calculatePayment( nImporte )

   ::getRecibosPagosTemporalController():getRowSet():Refresh()

   ::getRecibosPagosTemporalController():getBrowseView():Refresh()

RETURN ( .t. )

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

   ::getController():getRecibosPagosTemporalController():Activate( 500, ::oFolder:aDialogs[1] )

   REDEFINE GET   ::oImporte ;
      VAR         ::nImporte ;
      ID          110 ;
      VALID       ( ::oController:getImportePagar( ::nImporte ) );
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 99,999,999.99";
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

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::startActivate(), ::paintedActivate() }

   ::oDialog:Activate( , , , .t. )

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS PagosAssistantView

   ::oController:getClientesController():getSelector():setFocus()

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

CLASS TestPagosAssistantController FROM TestCase

/*METHOD testCreateAsistenteSinCliente()

METHOD testCreateAsistenteSinMedeioPago() 

METHOD testCreateAsistenteNoImporte()  

METHOD testCreateAsistenteConPagoParcial() 
 

METHOD testCreateAsistenteUnPagoCompleto()

METHOD testCreateAsistenteCambioImporte()*/

METHOD testCreateAsistentePagosParciales()

METHOD testCreateAsistenteTodosPagosCambioImporte() VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

/*METHOD testCreateAsistenteSinCliente() CLASS TestPagosAssistantController

   local oController 
   local uuidFactura                   := win_uuidcreatestring()
   local uuidPrimerRecibo              := win_uuidcreatestring()
   local uuidTercerRecibo              := win_uuidcreatestring()
   local uuidSegundoRecibo             := win_uuidcreatestring()

   SQLClientesModel():truncateTable()
   SQLPagosModel():truncateTable()
   SQLRecibosModel():truncateTable() 
   SQLMediosPagoModel():truncateTable()
   SQLMetodoPagoModel():truncateTable()
   SQLRecibosPagosModel():truncateTable()
   SQLFacturasClientesModel():truncateTable() 
   SQLRecibosPagosTemporalModel():dropTemporalTable()

   SQLRecibosPagosTemporalModel():createTemporalTable() 

   ::assert:notEquals( 0, SQLClientesModel():testCreateContado(), "test creacion de cliente" ) 

   ::assert:notEquals( 0, SQLMediosPagoModel():testCreateMetalico(), "test de creacion de medio de pago" )

   ::assert:notEquals( 0, SQLMetodoPagoModel():testCreateConPlazos(), "test de creacion de metodo de pago" )

   ::assert:notEquals( 0, SQLFacturasClientesModel():testCreateFacturaConPlazos( uuidFactura ), "test creacion de factura" ) 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidPrimerRecibo, uuidFactura ), "test create recibo1" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidSegundoRecibo, uuidFactura ), "test create recibo2" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidTercerRecibo, uuidFactura ), "test create recibo3" )

   oController             := PagosAssistantController():New() 

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),; 
         apoloWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } )

   ::assert:false( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateAsistenteSinMedioPago() CLASS TestPagosAssistantController

   local oController 
   local uuidFactura                   := win_uuidcreatestring()
   local uuidPrimerRecibo              := win_uuidcreatestring()
   local uuidTercerRecibo              := win_uuidcreatestring()
   local uuidSegundoRecibo             := win_uuidcreatestring()

   SQLClientesModel():truncateTable()
   SQLPagosModel():truncateTable()
   SQLRecibosModel():truncateTable() 
   SQLMediosPagoModel():truncateTable()
   SQLMetodoPagoModel():truncateTable()
   SQLRecibosPagosModel():truncateTable()
   SQLFacturasClientesModel():truncateTable() 
   SQLRecibosPagosTemporalModel():dropTemporalTable()

   SQLRecibosPagosTemporalModel():createTemporalTable() 

   ::assert:notEquals( 0, SQLClientesModel():testCreateContado(), "test creacion de cliente" ) 

   ::assert:notEquals( 0, SQLMediosPagoModel():testCreateMetalico(), "test de creacion de medio de pago" )

   ::assert:notEquals( 0, SQLMetodoPagoModel():testCreateConPlazos(), "test de creacion de metodo de pago" )

   ::assert:notEquals( 0, SQLFacturasClientesModel():testCreateFacturaConPlazos( uuidFactura ), "test creacion de factura" ) 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidPrimerRecibo, uuidFactura ), "test create recibo1" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidSegundoRecibo, uuidFactura ), "test create recibo2" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidTercerRecibo, uuidFactura ), "test create recibo3" )

   oController             := PagosAssistantController():New() 

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 20 ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),; 
         apoloWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } ) 

   ::assert:false( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateAsistenteNoImporte() CLASS TestPagosAssistantController

   local oController 
   local uuidFactura                   := win_uuidcreatestring()
   local uuidPrimerRecibo              := win_uuidcreatestring()
   local uuidTercerRecibo              := win_uuidcreatestring()
   local uuidSegundoRecibo             := win_uuidcreatestring()

   SQLClientesModel():truncateTable()
   SQLPagosModel():truncateTable()
   SQLRecibosModel():truncateTable() 
   SQLMediosPagoModel():truncateTable()
   SQLMetodoPagoModel():truncateTable()
   SQLRecibosPagosModel():truncateTable()
   SQLFacturasClientesModel():truncateTable() 
   SQLRecibosPagosTemporalModel():dropTemporalTable()

   SQLRecibosPagosTemporalModel():createTemporalTable() 

   ::assert:notEquals( 0, SQLClientesModel():testCreateContado(), "test creacion de cliente" ) 

   ::assert:notEquals( 0, SQLMediosPagoModel():testCreateMetalico(), "test de creacion de medio de pago" )

   ::assert:notEquals( 0, SQLMetodoPagoModel():testCreateConPlazos(), "test de creacion de metodo de pago" )

   ::assert:notEquals( 0, SQLFacturasClientesModel():testCreateFacturaConPlazos( uuidFactura ), "test creacion de factura" ) 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidPrimerRecibo, uuidFactura ), "test create recibo1" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidSegundoRecibo, uuidFactura ), "test create recibo2" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidTercerRecibo, uuidFactura ), "test create recibo3" )

   oController             := PagosAssistantController():New() 

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "1" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),; 
         apoloWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } ) 

   ::assert:false( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateAsistenteConPagoParcial() CLASS TestPagosAssistantController

   local oController 
   local uuidFactura                   := win_uuidcreatestring()
   local uuidPrimerRecibo              := win_uuidcreatestring()
   local uuidTercerRecibo              := win_uuidcreatestring()
   local uuidSegundoRecibo             := win_uuidcreatestring()

   SQLClientesModel():truncateTable()
   SQLPagosModel():truncateTable()
   SQLRecibosModel():truncateTable() 
   SQLMediosPagoModel():truncateTable()
   SQLMetodoPagoModel():truncateTable()
   SQLRecibosPagosModel():truncateTable()
   SQLFacturasClientesModel():truncateTable() 
   SQLRecibosPagosTemporalModel():dropTemporalTable()

   SQLRecibosPagosTemporalModel():createTemporalTable() 

   ::assert:notEquals( 0, SQLClientesModel():testCreateContado(), "test creacion de cliente" ) 

   ::assert:notEquals( 0, SQLMediosPagoModel():testCreateMetalico(), "test de creacion de medio de pago" )

   ::assert:notEquals( 0, SQLMetodoPagoModel():testCreateConPlazos(), "test de creacion de metodo de pago" )

   ::assert:notEquals( 0, SQLFacturasClientesModel():testCreateFacturaConPlazos( uuidFactura ), "test creacion de factura" ) 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidPrimerRecibo, uuidFactura ), "test create recibo1" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidSegundoRecibo, uuidFactura ), "test create recibo2" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidTercerRecibo, uuidFactura ), "test create recibo3" )

   oController             := PagosAssistantController():New() 

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 20 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )   

   ::assert:true( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateAsistenteUnPagoCompleto() CLASS TestPagosAssistantController

   local oController 
   local uuidFactura                   := win_uuidcreatestring()
   local uuidPrimerRecibo              := win_uuidcreatestring()
   local uuidTercerRecibo              := win_uuidcreatestring()
   local uuidSegundoRecibo             := win_uuidcreatestring()

   SQLClientesModel():truncateTable()
   SQLPagosModel():truncateTable()
   SQLRecibosModel():truncateTable() 
   SQLMediosPagoModel():truncateTable()
   SQLMetodoPagoModel():truncateTable()
   SQLRecibosPagosModel():truncateTable()
   SQLFacturasClientesModel():truncateTable() 
   SQLRecibosPagosTemporalModel():dropTemporalTable()

   SQLRecibosPagosTemporalModel():createTemporalTable() 

   ::assert:notEquals( 0, SQLClientesModel():testCreateContado(), "test creacion de cliente" ) 

   ::assert:notEquals( 0, SQLMediosPagoModel():testCreateMetalico(), "test de creacion de medio de pago" )

   ::assert:notEquals( 0, SQLMetodoPagoModel():testCreateConPlazos(), "test de creacion de metodo de pago" )

   ::assert:notEquals( 0, SQLFacturasClientesModel():testCreateFacturaConPlazos( uuidFactura ), "test creacion de factura" ) 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidPrimerRecibo, uuidFactura ), "test create recibo1" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidSegundoRecibo, uuidFactura ), "test create recibo2" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidTercerRecibo, uuidFactura ), "test create recibo3" )

   oController             := PagosAssistantController():New() 

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 100 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "1" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )   

   ::assert:true( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateAsistenteCambioImporte() CLASS TestPagosAssistantController

   local oController 
   local uuidFactura                   := win_uuidcreatestring()
   local uuidPrimerRecibo              := win_uuidcreatestring()
   local uuidTercerRecibo              := win_uuidcreatestring()
   local uuidSegundoRecibo             := win_uuidcreatestring()

   SQLClientesModel():truncateTable()
   SQLPagosModel():truncateTable()
   SQLRecibosModel():truncateTable() 
   SQLMediosPagoModel():truncateTable()
   SQLMetodoPagoModel():truncateTable()
   SQLRecibosPagosModel():truncateTable()
   SQLFacturasClientesModel():truncateTable() 
   SQLRecibosPagosTemporalModel():dropTemporalTable()

   SQLRecibosPagosTemporalModel():createTemporalTable() 

   ::assert:notEquals( 0, SQLClientesModel():testCreateContado(), "test creacion de cliente" ) 

   ::assert:notEquals( 0, SQLMediosPagoModel():testCreateMetalico(), "test de creacion de medio de pago" )

   ::assert:notEquals( 0, SQLMetodoPagoModel():testCreateConPlazos(), "test de creacion de metodo de pago" )

   ::assert:notEquals( 0, SQLFacturasClientesModel():testCreateFacturaConPlazos( uuidFactura ), "test creacion de factura" ) 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidPrimerRecibo, uuidFactura ), "test create recibo1" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidSegundoRecibo, uuidFactura ), "test create recibo2" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidTercerRecibo, uuidFactura ), "test create recibo3" )

   oController             := PagosAssistantController():New() 

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 175.36 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 90 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 4 ),;
         self:getControl( IDOK ):Click() } )   

   ::assert:true( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )*/

//---------------------------------------------------------------------------//

METHOD testCreateAsistentePagosParciales() CLASS TestPagosAssistantController

   local oController 
   local uuidFactura                   := win_uuidcreatestring()
   local uuidPrimerRecibo              := win_uuidcreatestring()
   local uuidTercerRecibo              := win_uuidcreatestring()
   local uuidSegundoRecibo             := win_uuidcreatestring()

   SQLClientesModel():truncateTable()
   SQLPagosModel():truncateTable()
   SQLRecibosModel():truncateTable() 
   SQLMediosPagoModel():truncateTable()
   SQLMetodoPagoModel():truncateTable()
   SQLRecibosPagosModel():truncateTable()
   SQLFacturasClientesModel():truncateTable() 
   SQLRecibosPagosTemporalModel():dropTemporalTable()

   SQLRecibosPagosTemporalModel():createTemporalTable() 

   ::assert:notEquals( 0, SQLClientesModel():testCreateContado(), "test creacion de cliente" ) 

   ::assert:notEquals( 0, SQLMediosPagoModel():testCreateMetalico(), "test de creacion de medio de pago" )

   ::assert:notEquals( 0, SQLMetodoPagoModel():testCreateConPlazos(), "test de creacion de metodo de pago" )

   ::assert:notEquals( 0, SQLFacturasClientesModel():testCreateFacturaConPlazos( uuidFactura ), "test creacion de factura" ) 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidPrimerRecibo, uuidFactura ), "test create recibo1" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidSegundoRecibo, uuidFactura ), "test create recibo2" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateReciboConParent( uuidTercerRecibo, uuidFactura ), "test create recibo3" )

   oController             := PagosAssistantController():New() 

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         eval( self:getControl( 500, self:oFolder:aDialogs[ 1 ] ):aCols[8]:bEditValue, 90 ),;
         oController:getRecibosPagosTemporalController():getRowSet():Refresh(),;
         apoloWaitSeconds( 5 ) ,;
         self:getControl( IDOK ):Click() } )   

   ::assert:true( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

