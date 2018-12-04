#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PagosController FROM SQLNavigatorController

   DATA uuidRecibo 

   DATA nImporte                       INIT 0

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD gettingSelectSentence()

   METHOD insertPagoRecibo()

   METHOD getImporte()                 INLINE( ::getDialogView():nImporte )

   METHOD setUuidRecibo( uuidRecibo )  INLINE( ::uuidRecibo := uuidRecibo )
   METHOD getUuidRecibo()              INLINE( ::uuidRecibo )

   METHOD appendAssistant()

   METHOD addExtraButtons()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := PagosBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := PagosView():New( self ), ), ::oDialogView )

   METHOD getRepository()              INLINE( if(empty( ::oRepository ), ::oRepository := PagosRepository():New( self ), ), ::oRepository )

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := PagosValidator():New( self ), ), ::oValidator ) 
   
   METHOD getModel()                   INLINE( if( empty( ::oModel ), ::oModel := SQLPagosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PagosController

   ::Super:New( oController )

   ::cTitle                      := "Cobros"

   ::cName                       := "cobros"

   ::lTransactional              := .t.

   ::hImage                      := {  "16" => "gc_hand_money_16",;
                                       "32" => "gc_hand_money_32",;
                                       "48" => "gc_hand_money_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::getNavigatorView():getMenuTreeView():setEvent( 'addingDeleteButton', { || .f. } )
   ::getNavigatorView():getMenuTreeView():setEvent( 'addingDuplicateButton', { || .f. } )
   ::getNavigatorView():getMenuTreeView():setEvent( 'addingAppendButton', { || .f. } )
   ::getNavigatorView():getMenuTreeView():setEvent( 'addedRefreshButton', {|| ::addExtraButtons() } )

   ::getCuentasBancariasController():getModel():setEvent( 'addingParentUuidWhere', {|| .f. } )
   ::getCuentasBancariasController():getModel():setEvent( 'gettingSelectSentence', {|| ::gettingSelectSentence() } )
   
   ::setEvents( { 'appended', 'duplicated' }, {|| ::insertPagoRecibo() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS PagosController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD addExtraButtons() CLASS PagosController

   ::oNavigatorView:getMenuTreeView():AddButton( "Asistente de pagos", "New16", {|| ::getPagosController():AppendAssistant() } ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS PagosController

   ::getCuentasBancariasController():getModel():setGeneralWhere( "parent_uuid = " + quoted( Company():Uuid() ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD AppendAssistant() CLASS PagosController

   ::getRecibosPagosTemporalController():getModel():createTemporalTable()
 
   ::getPagosAssistantController():Append()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertPagoRecibo() CLASS PagosController

   ::getRecibosPagosController():getModel():insertPagoRecibo( ::getModelBuffer( "uuid" ), ::getUuidRecibo(), ::getImporte() )
    
RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PagosBrowseView FROM SQLBrowseView

   METHOD addColumns()

   METHOD getPaidIcon()                       

END CLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS PagosBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha'
      :cHeader             := 'Expedicion'
      :cDataType           := 'D'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'estado'
      :cHeader             := 'Estado'
      :bBmpData            := {|| ::getPaidIcon() }
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'estado' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :AddResource( "bullet_square_green_16" )
      :AddResource( "bullet_square_red_16" )
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cliente_codigo'
      :cHeader             := 'Código cliente'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cliente_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cliente_nombre'
      :cHeader             := 'Cliente'
      :nWidth              := 250
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cliente_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'importe'
      :cHeader             := 'Importe'
      :nWidth              := 100
      :cEditPicture        := "@E 999999999999.99" 
      :bEditValue          := {|| ::getRowSet():fieldGet( 'importe' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'medio_pago_nombre'
      :cHeader             := 'Medio de Pago'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'medio_pago_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_banco'
      :cHeader             := 'Cuenta bancaria'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_banco' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'comentario'
      :cHeader             := 'Comentario'
      :nWidth              := 250
      :bEditValue          := {|| ::getRowSet():fieldGet( 'comentario' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getPaidIcon() CLASS PagosBrowseView

RETURN ( if( ::getRowSet():fieldGet( 'estado' ) == "Presentado", 1, 2 ) ) 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PagosView FROM SQLBaseView

   DATA oImporte

   DATA nImporte                            

   DATA oEstado

   DATA aEstado                        INIT { "Presentado", "Rechazado" }
  
   METHOD getImporte()                 INLINE ( ::nImporte )
   METHOD setImporte( nImporte )       INLINE ( ::nImporte := nImporte )

   METHOD Activate()
      METHOD Activating() 
      METHOD startActivate()

   METHOD addLinksToExplorerBar()

   METHOD defaultTitle()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS PagosView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM_EXTENDED" ;
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
      DIALOGS     "PAGO_LIBRE_SQL" 

   ::oController:getClientesController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "cliente_codigo" ] ) )
   ::oController:getClientesController():getSelector():Build( { "idGet" => 100, "idText" => 101, "idLink" => 102, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getClientesController():getSelector():setWhen( {|| ::oController:isAppendMode() } )
   ::oController:getClientesController():getSelector():setValid( {|| ::oController:validate( "cliente_codigo" ) } )

  REDEFINE GET    ::oImporte ;
      VAR         ::nImporte ;
      ID          110 ;
      WHEN        ( ::oController:isAppendMode() ) ;
      VALID       ( ::oController:validate( "importe_maximo", ::nImporte ) ) ;
      PICTURE     "@E 999999999999.99";
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:getModel():hBuffer[ "fecha" ] ;
      ID          120 ;
      VALID       ( ::oController:validate( "fecha" ) ) ;
      WHEN        ( ::oController:isAppendMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oController:getMediosPagoController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "medio_pago_codigo" ] ) )
   ::oController:getMediosPagoController():getSelector():Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getMediosPagoController():getSelector():setWhen( {|| ::oController:isAppendMode() } )
   ::oController:getMediosPagoController():getSelector():setValid( {|| ::oController:validate( "medio_pago_codigo" ) } )

   ::oController:getCuentasBancariasController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "cuenta_bancaria_codigo" ] ) )
   ::oController:getCuentasBancariasController():getSelector():Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getCuentasBancariasController():getSelector():setWhen( {|| ::oController:isAppendMode() } )

   REDEFINE GET   ::oController:getModel():hBuffer[ "comentario" ] ;
      ID          150 ;
      WHEN        ( ::oController:isAppendMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR         ::oController:getModel():hBuffer[ "estado" ] ;
      ID          160 ;
      ITEMS       ::aEstado;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   else
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart        := {|| ::startActivate() }

   ::oDialog:Activate( , , {|| ::paintedActivate() }, .t. )

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD Activating() CLASS PagosView 

   if !::oController:isAppendMode()
      
      ::setImporte( SQLRecibosPagosModel():getImporte( ::getController():getModelBuffer( 'uuid' ) ) )
      
   else 

      ::setImporte( SQLRecibosModel():getDiferencia( ::oController:getUuidRecibo() ) )

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS PagosView

   ::addLinksToExplorerBar()

   ::oController:getClientesController():getSelector():Start()

   ::oController:getMediosPagoController():getSelector():Start()

   ::oController:getCuentasBancariasController():getSelector():Start()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS PagosView

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

METHOD defaultTitle() CLASS PagosView

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

CLASS PagosValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD validateImporteMaximo( value )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS PagosValidator

   ::hValidators  := {  "cliente_codigo"     =>   {  "required"   => "El código del cliente es un dato requerido" },;
                        "importe"            =>   {  "required"   => "El importe es un dato requerido" },;
                        "fecha"              =>   {  "required"   => "La fecha es un dato requerido" },;
                        "medio_pago_codigo"  =>   {  "required"   => "El medio de pago es un dato requerido" },;
                        "importe_maximo"     =>   {  "validateImporteMaximo"  => "El importe no puede ser mayor que la cantidad adeudada" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD validateImporteMaximo( nImporte ) CLASS PagosValidator
   
   if empty( ::getSuperController() )
      RETURN ( .t. )
   end if 

RETURN ( ::getSuperController():getImporte() >= nImporte )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPagosModel FROM SQLCompanyModel

   DATA cTableName               INIT "pagos"

   DATA cGroupBy                 INIT "pagos.uuid"
   
   DATA cOrderBy                 INIT "pagos.fecha"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD testCreatePagoPresentado( uuid )

   METHOD testCreatePagoRechazado( uuid ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPagosModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"                ,;                                  
                                                      "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "cliente_codigo",             {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "medio_pago_codigo",          {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "cuenta_bancaria_codigo",     {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "fecha",                      {  "create"    => "DATE"                                       ,;
                                                      "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "estado",                     {  "create"     => "ENUM( 'Presentado', 'Rechazado' )"          ,;
                                                      "default"    => {|| 'Presentado' }  }                        )

   hset( ::hColumns, "comentario",                 {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLPagosModel

   local cSql

   TEXT INTO cSql

   SELECT pagos.id AS id,
      pagos.uuid AS uuid,
      pagos.cliente_codigo AS cliente_codigo,
      pagos.fecha AS fecha,
      pagos.medio_pago_codigo AS medio_pago_codigo,
      pagos.cuenta_bancaria_codigo AS cuenta_bancaria_codigo,
      pagos.comentario AS comentario,
      pagos.estado AS estado,
      clientes.nombre AS cliente_nombre,
      medio_pago.nombre AS medio_pago_nombre,
      cuentas_bancarias.nombre AS nombre_banco,
      SUM( pagos_recibos.importe ) AS importe

   FROM %1$s AS pagos

   LEFT JOIN %2$s AS clientes
      ON pagos.cliente_codigo = clientes.codigo AND clientes.deleted_at = 0

   LEFT JOIN %3$s AS medio_pago
      ON pagos.medio_pago_codigo = medio_pago.codigo AND medio_pago.deleted_at = 0

   LEFT JOIN %4$s AS cuentas_bancarias
      ON pagos.cuenta_bancaria_codigo = cuentas_bancarias.codigo AND cuentas_bancarias.deleted_at = 0 
      AND cuentas_bancarias.parent_uuid = %6$s

   LEFT JOIN %5$s AS pagos_recibos
      ON pagos_recibos.pago_uuid = pagos.uuid

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLClientesModel():getTableName(), SQLMediosPagoModel():getTableName(), SQLCuentasBancariasModel():getTableName(), SQLRecibosPagosModel():getTableName(), quoted( Company():Uuid() ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD testCreatePagoPresentado( uuid ) CLASS SQLPagosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "estado", "Presentado" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreatePagoRechazado( uuid ) CLASS SQLPagosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "estado", "Rechazado" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PagosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLPagosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TestPagosController FROM TestCase

   METHOD testCreateReciboComoPagado()

   METHOD testCreateReciboConDoblePago()

   METHOD testCreatePagoComoRechazado()   

   METHOD testCreatePagoConDobleRecibo()    

   METHOD testCreateReciboConPagoPresentadoYPagoRechazado()   

   METHOD testCreateReciboConPagosRechazados()  

   METHOD testDialogAppend()

   METHOD testDialogAppendConImporteMayor() 

   METHOD testDialogAppendClienteInexistente()

//   METHOD testDialogEmptyNombre()

END CLASS

//---------------------------------------------------------------------------//

METHOD testCreateReciboComoPagado() CLASS TestPagosController

   local uuidRecibo  := win_uuidcreatestring()
   local uuidPago    := win_uuidcreatestring()

   SQLRecibosModel():truncateTable() 
   SQLPagosModel():truncateTable() 
   SQLRecibosPagosModel():truncateTable() 

   ::assert:notEquals( SQLRecibosModel():testCreateRecibo( uuidRecibo ), 0, "test create recibo" )

   ::assert:notEquals( SQLPagosModel():testCreatePagoPresentado( uuidPago ), 0, "test create pago" )

   SQLRecibosPagosModel():insertPagoRecibo( uuidPago, uuidRecibo, 100 )

   ::assert:Equals( RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( uuidRecibo ), 100, "test pago del recibo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreatePagoComoRechazado() CLASS TestPagosController

   local uuidRecibo  := win_uuidcreatestring()
   local uuidPago    := win_uuidcreatestring()

   SQLRecibosModel():truncateTable() 
   SQLPagosModel():truncateTable() 
   SQLRecibosPagosModel():truncateTable() 

   ::assert:notEquals( SQLRecibosModel():testCreateRecibo( uuidRecibo ), 0, "test create recibo" )

   ::assert:notEquals( SQLPagosModel():testCreatePagoRechazado( uuidPago ), 0, "test create pago" )

   SQLRecibosPagosModel():insertPagoRecibo( uuidPago, uuidRecibo, 100 )

   ::assert:Equals( RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( uuidRecibo ), 0, "test pago del recibo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateReciboConDoblePago() CLASS TestPagosController

   local uuidRecibo        := win_uuidcreatestring()
   local uuidPrimerPago    := win_uuidcreatestring()
   local uuidSegundoPago   := win_uuidcreatestring()

   SQLRecibosModel():truncateTable() 
   SQLPagosModel():truncateTable() 
   SQLRecibosPagosModel():truncateTable() 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateRecibo( uuidRecibo ), "test create recibo" )

   ::assert:notEquals( 0, SQLPagosModel():testCreatePagoPresentado( uuidPrimerPago ), "test create pago" )

   ::assert:notEquals( 0, SQLPagosModel():testCreatePagoPresentado( uuidSegundoPago ), "test create pago" )

   SQLRecibosPagosModel():insertPagoRecibo( uuidPrimerPago, uuidRecibo, 50 )
   SQLRecibosPagosModel():insertPagoRecibo( uuidSegundoPago, uuidRecibo, 50 )

   ::assert:Equals( 100, RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( uuidRecibo ), "test pago del recibo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreatePagoConDobleRecibo() CLASS TestPagosController

   local uuidPago          := win_uuidcreatestring()
   local uuidPrimerRecibo  := win_uuidcreatestring()
   local uuidSegundoRecibo := win_uuidcreatestring()

   SQLRecibosModel():truncateTable() 
   SQLPagosModel():truncateTable() 
   SQLRecibosPagosModel():truncateTable() 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateRecibo( uuidPrimerRecibo ), "test create recibo" )
   ::assert:notEquals( 0, SQLRecibosModel():testCreateRecibo( uuidSegundoRecibo ), "test create recibo" )

   ::assert:notEquals( 0, SQLPagosModel():testCreatePagoPresentado( uuidPago ), "test create pago" )

   SQLRecibosPagosModel():insertPagoRecibo( uuidPago, uuidPrimerRecibo, 100 )
   SQLRecibosPagosModel():insertPagoRecibo( uuidPago, uuidSegundoRecibo, 100 )

   ::assert:Equals( 200, RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( uuidPrimerRecibo ) + RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( uuidSegundoRecibo ) , "test pago del recibo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateReciboConPagoPresentadoYPagoRechazado() CLASS TestPagosController

   local uuidRecibo        := win_uuidcreatestring()
   local uuidPrimerPago    := win_uuidcreatestring()
   local uuidSegundoPago   := win_uuidcreatestring()

   SQLRecibosModel():truncateTable() 
   SQLPagosModel():truncateTable() 
   SQLRecibosPagosModel():truncateTable() 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateRecibo( uuidRecibo ), "test create recibo" )

   ::assert:notEquals( 0, SQLPagosModel():testCreatePagoPresentado( uuidPrimerPago ), "test create pago" )

   ::assert:notEquals( 0, SQLPagosModel():testCreatePagoRechazado( uuidSegundoPago ), "test create pago" )

   SQLRecibosPagosModel():insertPagoRecibo( uuidPrimerPago, uuidRecibo, 50 )
   SQLRecibosPagosModel():insertPagoRecibo( uuidSegundoPago, uuidRecibo, 50 )

   ::assert:Equals( 50, RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( uuidRecibo ), "test pago del recibo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateReciboConPagosRechazados() CLASS TestPagosController

   local uuidRecibo        := win_uuidcreatestring()
   local uuidPrimerPago    := win_uuidcreatestring()
   local uuidSegundoPago   := win_uuidcreatestring()

   SQLRecibosModel():truncateTable() 
   SQLPagosModel():truncateTable() 
   SQLRecibosPagosModel():truncateTable() 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateRecibo( uuidRecibo ), "test create recibo" )

   ::assert:notEquals( 0, SQLPagosModel():testCreatePagoRechazado( uuidPrimerPago ), "test create pago" )

   ::assert:notEquals( 0, SQLPagosModel():testCreatePagoRechazado( uuidSegundoPago ), "test create pago" )

   SQLRecibosPagosModel():insertPagoRecibo( uuidPrimerPago, uuidRecibo, 50 )
   SQLRecibosPagosModel():insertPagoRecibo( uuidSegundoPago, uuidRecibo, 50 )

   ::assert:Equals( 0, RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( uuidRecibo ), "test pago del recibo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogAppend() CLASS TestPagosController

   local oController 
   local uuidRecibo        := win_uuidcreatestring()

   SQLPagosModel():truncateTable()
   SQLRecibosModel():truncateTable() 
   SQLClientesModel():truncateTable()
   SQLMediosPagoModel():truncateTable()
   SQLRecibosPagosModel():truncateTable() 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateRecibo( uuidRecibo ), "test create recibo" )
   
   ::assert:notEquals( 0, SQLClientesModel():testCreateContado(), "test creacion de cliente" )

   ::assert:notEquals( 0, SQLMediosPagoModel():testCreateMetalico(), "test de creacion de medio de pago" )

   oController             := PagosController():New()
   oController:setUuidRecibo( uuidRecibo )

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 50 ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )

   ::assert:true( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogAppendConImporteMayor() CLASS TestPagosController

   local oController 
   local uuidRecibo        := win_uuidcreatestring()

   SQLPagosModel():truncateTable()
   SQLRecibosModel():truncateTable() 
   SQLClientesModel():truncateTable()
   SQLMediosPagoModel():truncateTable()
   SQLRecibosPagosModel():truncateTable() 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateRecibo( uuidRecibo ), "test create recibo" )
   
   ::assert:notEquals( 0, SQLClientesModel():testCreateContado(), "test creacion de cliente" )

   ::assert:notEquals( 0, SQLMediosPagoModel():testCreateMetalico(), "test de creacion de medio de pago" )

   oController             := PagosController():New()
   oController:setUuidRecibo( uuidRecibo )

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 500 ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } )

   ::assert:false( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogAppendClienteInexistente() CLASS TestPagosController

   local oController 
   local uuidRecibo        := win_uuidcreatestring()

   SQLPagosModel():truncateTable()
   SQLRecibosModel():truncateTable() 
   SQLClientesModel():truncateTable()
   SQLMediosPagoModel():truncateTable()
   SQLRecibosPagosModel():truncateTable() 

   ::assert:notEquals( 0, SQLRecibosModel():testCreateRecibo( uuidRecibo ), "test create recibo" )
   
   ::assert:notEquals( 0, SQLMediosPagoModel():testCreateMetalico(), "test de creacion de medio de pago" )

   oController             := PagosController():New()
   oController:setUuidRecibo( uuidRecibo )

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( 500 ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } )

   ::assert:false( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

