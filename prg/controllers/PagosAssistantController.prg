#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PagosAssistantController FROM SQLNavigatorController

   DATA nImporte                       

   DATA cCodigoTercero                 INIT ""

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD isLoadRecibos()

   METHOD getImportePagar( nImporte )

   METHOD changeTercero()

   METHOD resetImporteAndCliente()

   METHOD isClient()                   INLINE ( .t. )

   METHOD gettingSelectSentenceTercero()
   METHOD gettingSelectSentenceEmpresa()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE ( if( !empty(::oController), ::oController:getBrowseView(), nil ) )
   
   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := PagosAssistantView():New( self ), ), ::oDialogView )
   
   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLPagosModel():New( self ), ), ::oModel )
   
   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := PagosAssistantValidator():New( self  ), ), ::oValidator ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PagosAssistantController

   ::Super:New( oController )

   ::cTitle                            := "Cobros"

   ::cName                             := "cobros"

   ::hImage                            := {  "16" => "gc_hand_money_16",;
                                             "32" => "gc_hand_money_32",;
                                             "48" => "gc_hand_money_48" }

   ::nLevel                            := Auth():Level( ::cName )

   ::getTercerosController():getSelector():setEvent( 'validated', {|| ::isLoadRecibos() } )
   
   ::setEvent( 'appending',    {|| ::getRecibosPagosTemporalController():getModel():createTemporalTable() } )
   ::setEvent( 'appended',     {|| ::getRecibosPagosController():getModel():InsertPagoReciboAssistant( ::getModelBuffer( "uuid" ) ), if ( !empty( ::getController() ), ::getController():getRowset():refresh(), )/*, ::getController():getRowset():refresh()*/ } )
   ::setEvent( 'exitAppended', {|| ::getRecibosPagosTemporalController():getModel():dropTemporalTable() } )
   
   ::getCuentasBancariasController():getModel():setEvent( 'addingParentUuidWhere', {|| .f. } )
   ::getCuentasBancariasController():getModel():setEvent( 'gettingSelectSentence', {|| ::gettingSelectSentenceTercero() } )
   
   ::getCuentasBancariasGestoolController():getModel():setEvent( 'addingParentUuidWhere', {|| .f. } )
   ::getCuentasBancariasGestoolController():getModel():setEvent( 'gettingSelectSentence', {|| ::gettingSelectSentenceEmpresa() } )

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

METHOD resetImporteAndCliente() CLASS PagosAssistantController

   ::cCodigoTercero := ""

   ::getDialogView():oImporte:cText( 0 )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentenceTercero() CLASS PagosAssistantController

RETURN ( ::getCuentasBancariasController():getModel():setGeneralWhere( "parent_uuid = " + quoted( SQLtercerosModel():getuuidWhereCodigo( ::getModelBuffer( "tercero_codigo" ) ) ) ) )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentenceEmpresa() CLASS PagosAssistantController

RETURN ( ::getCuentasBancariasGestoolController():getModel():setGeneralWhere( "parent_uuid = " + quoted( Company():Uuid() ) ) )

//---------------------------------------------------------------------------//

METHOD changeTercero( cCodigoTercero ) CLASS PagosAssistantController

   ::cCodigoTercero  := cCodigoTercero

   ::getRecibosPagosTemporalController():getModel():deleteTemporal()
   ::getRecibosPagosTemporalController():getModel():insertPagoReciboTemporal( ::getModelBuffer( "uuid" ), ::getModelBuffer( 'tercero_codigo' ) )
   ::getRecibosPagosTemporalController():getRowset():buildPad( ::getRecibosPagosTemporalController():getModel():getGeneralSelect() )
   ::getRecibosPagosTemporalController():getBrowseView():Refresh()

   ::getMediosPagoController():getSelector():setBlank()
   ::getMediosPagoController():getSelector():setOriginal()

   ::getCuentasBancariasController():getSelector():setBlank()
   ::getCuentasBancariasController():getSelector():setOriginal()

   ::getCuentasBancariasGestoolController():getSelector():setBlank()
   ::getCuentasBancariasGestoolController():getSelector():setOriginal()
   
   ::getDialogView():oImporte:cText( 0 ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isLoadRecibos() CLASS PagosAssistantController

   if ::cCodigoTercero != ::getModelBuffer( "tercero_codigo" )
      ::changeTercero( ::getModelBuffer( "tercero_codigo" ) )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getImportePagar( nImporte ) CLASS PagosAssistantController

   if ::nImporte == nImporte
      RETURN ( .t. )
   end if

   ::nImporte  := nImporte

   ::getRecibosPagosTemporalController():getRowSet():Refresh()

   ::getRecibosPagosTemporalController():calculatePayment( nImporte )

   ::getRecibosPagosTemporalController():getRowSet():refreshAndGoTop()
   
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
      METHOD Activating()

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

   ::oController:getTercerosController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "tercero_codigo" ] ) )
   ::oController:getTercerosController():getSelector():Build( { "idGet" => 100, "idLink" => 102, "idText" => 101, "idNif" => 103, "idDireccion" => 104, "idCodigoPostal" => 105, "idPoblacion" => 106, "idProvincia" => 107, "idTelefono" => 108, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getTercerosController():getSelector():setValid( {|| ::oController:validate( "tercero_codigo" ) } )

   ::getController():getRecibosPagosTemporalController():Activate( 500, ::oFolder:aDialogs[1] )

   REDEFINE GET   ::oImporte ;
      VAR         ::nImporte ;
      ID          110 ;
      VALID       ( ::oController:validate( "importe_minimo" ) );
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

   ::oController:getCuentasBancariasController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "cuenta_bancaria_tercero_uuid" ] ) )
   ::oController:getCuentasBancariasController():getSelector():Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oFolder:aDialogs[1] } )

   ::oController:getCuentasBancariasGestoolController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "cuenta_bancaria_empresa_uuid" ] ) )
   ::oController:getCuentasBancariasGestoolController():getSelector():Build( { "idGet" => 150, "idText" => 151, "idLink" => 152, "oDialog" => ::oFolder:aDialogs[1] } )

   REDEFINE GET   ::oController:getModel():hBuffer[ "comentario" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate( ::oFolder:aDialogs ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::closeActivate( ::oFolder:aDialogs ), ) }

   ::oDialog:bStart     := {|| ::startActivate(), ::paintedActivate() }

   ::oDialog:Activate( , , , .t. )

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD Activating() CLASS PagosAssistantView

   ::getController():cCodigoTercero := ""

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS PagosAssistantView

   ::oController:getTercerosController():getSelector():setFocus()

   ::addLinksToExplorerBar()

   ::oController:getTercerosController():getSelector():Start()

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

CLASS PagosAssistantValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD validateImporteMininmo( nImporte )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS PagosAssistantValidator

   ::hValidators  := {  "tercero_codigo"     =>   {  "required"               => "El código de tercero es un dato requerido" },;
                        "importe"            =>   {  "required"               => "El importe es un dato requerido" },;
                        "fecha"              =>   {  "required"               => "La fecha es un dato requerido" },;
                        "medio_pago_codigo"  =>   {  "required"               => "El medio de pago es un dato requerido" },;
                        "importe_minimo"     =>   {  "validateImporteMininmo" => "Debe introducir un importe válido"} }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD validateImporteMininmo() CLASS PagosAssistantValidator
   
   local nImporte := ::oController:oDialogView:nImporte

   if nImporte <= 0 
      RETURN ( .f. )
   end if

RETURN ( ::oController:getImportePagar( nImporte ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestPagosAssistantController FROM TestCase

   DATA oController

   METHOD beforeClass()

   METHOD afterClass()

   METHOD Before() 

   METHOD test_create_asistente_sin_cliente()

   METHOD test_create_asistente_sin_medio_pago() 

   METHOD test_create_asistente_no_importe()  

   METHOD test_create_asistente_con_pago_parcial() 
 
   METHOD test_create_asistente_pago_completo()

   METHOD test_create_asistente_cambio_importe()

   METHOD test_create_asistente_pagos_parciales()

   METHOD test_create_asistente_todos_pagos_cambio_importe()

   METHOD test_create_asistente_un_banco()

   METHOD test_create_asistente_dos_banco()

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestPagosAssistantController

   ::oController  := PagosAssistantController():New()  

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestPagosAssistantController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestPagosAssistantController 

   SQLTercerosModel():truncateTable()
   SQLPagosModel():truncateTable()
   SQLRecibosModel():truncateTable() 
   SQLMediosPagoModel():truncateTable()
   SQLMetodoPagoModel():truncateTable()
   SQLRecibosPagosModel():truncateTable()
   SQLFacturasVentasModel():truncateTable()
   SQLCuentasBancariasModel():truncateTable()
   SQLCuentasBancariasGestoolModel():truncateTable()

   // SQLRecibosPagosTemporalModel():createTemporalTable() 

   SQLTercerosModel():test_create_contado() 

   SQLMediosPagoModel():test_create_metalico()

   SQLMetodoPagoModel():test_create_con_plazos()

   SQLFacturasVentasModel():test_create_factura_con_varios_plazos() 

   SQLCuentasBancariasModel():create_cuenta( SQLTercerosModel():test_get_uuid_contado() )

   SQLCuentasBancariasGestoolModel():create_cuenta( Company():Uuid() )

   SQLRecibosModel():test_create_recibo_con_parent( SQLFacturasVentasModel():test_get_uuid_factura_con_varios_plazos() )
   SQLRecibosModel():test_create_recibo_con_parent( SQLFacturasVentasModel():test_get_uuid_factura_con_varios_plazos() )
   SQLRecibosModel():test_create_recibo_con_parent( SQLFacturasVentasModel():test_get_uuid_factura_con_varios_plazos() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_asistente_sin_cliente() CLASS TestPagosAssistantController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),; 
         apoloWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } )

   ::getAssert():false( ::oController:Append(), "test ::getAssert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_asistente_sin_medio_pago() CLASS TestPagosAssistantController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 20 ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),; 
         apoloWaitSeconds( 2 ),;
         self:getControl( IDCANCEL ):Click() } ) 

   ::getAssert():false( ::oController:Append(), "test ::getAssert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_asistente_no_importe() CLASS TestPagosAssistantController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "1" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),; 
         apoloWaitSeconds( 2 ),;
         self:getControl( IDCANCEL ):Click() } ) 

   ::getAssert():false( ::oController:Append(), "test ::getAssert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_asistente_con_pago_parcial() CLASS TestPagosAssistantController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 20 ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 2 ),;
         self:getControl( IDOK ):Click() } )   

   ::getAssert():true( ::oController:Append(), "test ::getAssert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_asistente_pago_completo() CLASS TestPagosAssistantController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 100 ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 2 ),;
         self:getControl( IDOK ):Click() } )   

   ::getAssert():true( ::oController:Append(), "test ::getAssert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_asistente_cambio_importe() CLASS TestPagosAssistantController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 175.36 ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 90 ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 2 ),;
         self:getControl( IDOK ):Click() } )   

   ::getAssert():true( ::oController:Append(), "test ::getAssert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_asistente_pagos_parciales() CLASS TestPagosAssistantController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "1" ),;
         apoloWaitSeconds( 1 ),;
         eval( ::oController:getRecibosPagosTemporalController():getBrowseView():oColumImporte:bOnPostEdit, , 90 ),;
         apoloWaitSeconds( 1 ),;
         ::oController:getRecibosPagosTemporalController():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         ::oController:getRecibosPagosTemporalController():getRowSet():goDown(),;
         apoloWaitSeconds( 1 ),;
         eval( ::oController:getRecibosPagosTemporalController():getBrowseView():oColumImporte:bOnPostEdit, , 50 ),;
         apoloWaitSeconds( 1 ),;
         ::oController:getRecibosPagosTemporalController():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 500, self:oFolder:aDialogs[ 1 ] ):Refresh(),;
         apoloWaitSeconds( 2 ),;
         self:getControl( IDOK ):Click() } )   

   ::getAssert():true( ::oController:Append(), "test ::getAssert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_asistente_todos_pagos_cambio_importe() CLASS TestPagosAssistantController 

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "1" ),;
         apoloWaitSeconds( 1 ),;
         eval( ::oController:getRecibosPagosTemporalController():getBrowseView():oColumImporte:bOnPostEdit, , 90 ),;
         apoloWaitSeconds( 1 ),;
         ::oController:getRecibosPagosTemporalController():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         ::oController:getRecibosPagosTemporalController():getRowSet():goDown(),;
         apoloWaitSeconds( 1 ),;
         eval( ::oController:getRecibosPagosTemporalController():getBrowseView():oColumImporte:bOnPostEdit, , 50 ),;
         apoloWaitSeconds( 1 ),;
         ::oController:getRecibosPagosTemporalController():getRowSet():Refresh(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 250 ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 3 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 500, self:oFolder:aDialogs[ 1 ] ):Refresh(),;
         apoloWaitSeconds( 2 ),;
         self:getControl( IDOK ):Click() } )   

   ::getAssert():true( ::oController:Append(), "test ::getAssert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_asistente_un_banco() CLASS TestPagosAssistantController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 20 ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 2 ),;
         self:getControl( IDOK ):Click() } )   

   ::getAssert():true( ::oController:Append(), "test ::getAssert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_asistente_dos_banco() CLASS TestPagosAssistantController 

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 20 ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 150, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 150, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         apoloWaitSeconds( 2 ),;
         self:getControl( IDOK ):Click() } )   

   ::getAssert():true( ::oController:Append(), "test ::getAssert():true with .t." )

RETURN ( nil )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

