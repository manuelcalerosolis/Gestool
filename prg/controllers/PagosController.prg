#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PagosController FROM SQLNavigatorController

   DATA uuidRecibo 

   DATA nImporte                       INIT 0

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD gettingSelectSentenceTercero()
   METHOD gettingSelectSentenceEmpresa()

   METHOD insertPagoRecibo()

   METHOD getImporte()                 INLINE( ::getDialogView():nImporte )

   METHOD setUuidRecibo( uuidRecibo )  INLINE( ::uuidRecibo := uuidRecibo )
   METHOD getUuidRecibo()              INLINE( ::uuidRecibo )

   METHOD appendAssistant()

   METHOD addExtraButtons()

   METHOD isClient()                   INLINE ( nil )                 

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
   ::getCuentasBancariasController():getModel():setEvent( 'gettingSelectSentence', {|| ::gettingSelectSentenceTercero() } )
   ::getCuentasBancariasGestoolController():getModel():setEvent( 'addingParentUuidWhere', {|| .f. } )
   ::getCuentasBancariasGestoolController():getModel():setEvent( 'gettingSelectSentence', {|| ::gettingSelectSentenceEmpresa() } )
   
   //::setEvents( { 'appended', 'duplicated' }, {|| ::insertPagoRecibo() } )

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

   ::oNavigatorView:getMenuTreeView():AddButton( "Asistente de pagos", "New16", {|| ::AppendAssistant() } ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentenceTercero() CLASS PagosController

   ::getCuentasBancariasController():getModel():setGeneralWhere( "parent_uuid = " + quoted( SQLtercerosModel():getuuidWhereCodigo( ::getModelBuffer( "tercero_codigo" ) ) ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentenceEmpresa() CLASS PagosController

   ::getCuentasBancariasGestoolController():getModel():setGeneralWhere( "parent_uuid = " + quoted( Company():Uuid() ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD AppendAssistant() CLASS PagosController

   ::getPagosAssistantController():Append()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertPagoRecibo() CLASS PagosController

   ::getRecibosPagosController():getModel():insertPagoRecibo( ::getModelBuffer( "uuid" ), ::getUuidRecibo(), ::getImporte() )

   ::getRecibosController():getRowset():refresh()
    
RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PagosBrowseView FROM SQLBrowseView

   DATA lDeletedColored          INIT .f.

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
      :cSortOrder          := 'tipo'
      :cHeader             := 'Tipo'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tipo' ) }
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
      :cSortOrder          := 'tercero_codigo'
      :cHeader             := 'Código tercero'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tercero_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cliente_nombre'
      :cHeader             := 'Tercero'
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
      :cSortOrder          := 'nombre_banco_tercero'
      :cHeader             := 'Cuenta tercero'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_banco_tercero' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_banco_empresa'
      :cHeader             := 'Cuenta empresa'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_banco_empresa' ) }
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

CLASS PagosView FROM SQLBaseView

   DATA oImporte

   DATA nImporte                            

   DATA oEstado

   DATA aEstado                        INIT { "Presentado", "Rechazado" }

   DATA oTipo

   DATA aTipo                          INIT { "Cobro", "Pago" }
  
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

   REDEFINE COMBOBOX ::oEstado ;
      VAR         ::oController:getModel():hBuffer[ "tipo" ] ;
      ID          100 ;
      ITEMS       ::aTipo;
      WHEN        ( ::oController:isNotZoomMode() .AND. ::oController:isNotEditMode() .AND. ::oController:isNotAppendOrDuplicateMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oController:getTercerosController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "tercero_codigo" ] ) )
   ::oController:getTercerosController():getSelector():Build( { "idGet" => 110, "idText" => 111, "idLink" => 112, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getTercerosController():getSelector():setWhen( {|| ::oController:isNotAppendOrDuplicateMode() .AND. ::oController:isNotZoomMode() .AND. ::oController:isNotEditMode() } )
   ::oController:getTercerosController():getSelector():setValid( {|| ::oController:validate( "tercero_codigo" ) } )

  REDEFINE GET    ::oImporte ;
      VAR         ::nImporte ;
      ID          120 ;
      WHEN        ( ::oController:isAppendMode() ) ;
      VALID       ( ::oController:validate( "importe_maximo", ::nImporte ) ) ;
      PICTURE     "@E 999999999999.99";
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:getModel():hBuffer[ "fecha" ] ;
      ID          130 ;
      VALID       ( ::oController:validate( "fecha" ) ) ;
      WHEN        ( ::oController:isAppendMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oController:getMediosPagoController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "medio_pago_codigo" ] ) )
   ::oController:getMediosPagoController():getSelector():Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getMediosPagoController():getSelector():setWhen( {|| ::oController:isAppendMode() } )
   ::oController:getMediosPagoController():getSelector():setValid( {|| ::oController:validate( "medio_pago_codigo" ) } )

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

   //Cuenta tercero------------------------------------------------------------

   ::oController:getCuentasBancariasController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "cuenta_bancaria_tercero_uuid" ] ) )
   ::oController:getCuentasBancariasController():getSelector():Build( { "idGet" => 170, "idText" => 171, "idLink" => 172, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getCuentasBancariasController():getSelector():setWhen( {|| ::oController:isAppendMode() } )

   //Cuenta empresa------------------------------------------------------------

   ::oController:getCuentasBancariasGestoolController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "cuenta_bancaria_empresa_uuid" ] ) )
   ::oController:getCuentasBancariasGestoolController():getSelector():Build( { "idGet" => 180, "idText" => 181, "idLink" => 182, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getCuentasBancariasGestoolController():getSelector():setWhen( {|| ::oController:isAppendMode() } )

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

   ::oController:getTercerosController():getSelector():Start()

   ::oController:getMediosPagoController():getSelector():Start()

   ::oController:getCuentasBancariasController():getSelector():Start()

   ::oController:getCuentasBancariasGestoolController():getSelector():Start()

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

   ::hValidators  := {  "tercero_codigo"     =>   {  "required"               => "El código del cliente es un dato requerido" },;
                        "importe"            =>   {  "required"               => "El importe es un dato requerido" },;
                        "fecha"              =>   {  "required"               => "La fecha es un dato requerido" },;
                        "medio_pago_codigo"  =>   {  "required"               => "El medio de pago es un dato requerido" },;
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

CLASS SQLPagosModel FROM SQLCompanyModel

   DATA cTableName                     INIT "pagos"

   DATA cGroupBy                       INIT "pagos.uuid"
   
   DATA cOrderBy                       INIT "pagos.fecha"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getCuentaBancariaTerceroUuidAttribute( uValue ) ; 
                                       INLINE ( if( empty( uValue ), space( 3 ), SQLCuentasBancariasModel():getCodigoWhereUuidAndNotDeleted( uValue ) ) )

   METHOD setCuentaBancariaTerceroUuidAttribute( uValue ) ;
                                       INLINE ( if( empty( uValue ), "", SQLCuentasBancariasModel():getUuidWhereCodigoAndParentAndNotDeleted( uValue, SQLtercerosModel():getuuidWhereCodigo( ::getController():getModelBuffer( "tercero_codigo" ) ) ) ) )

   METHOD getCuentaBancariaEmpresaUuidAttribute( uValue ) ; 
                                       INLINE ( if( empty( uValue ), space( 3 ), SQLCuentasBancariasGestoolModel():getCodigoWhereUuidAndNotDeleted( uValue ) ) )

   METHOD setCuentaBancariaEmpresaUuidAttribute( uValue ) ;
                                       INLINE ( if( empty( uValue ), "", SQLCuentasBancariasGestoolModel():getUuidWhereCodigoAndParentAndNotDeleted( uValue, Company():Uuid() ) ) )

#ifdef __TEST__

   METHOD test_create_pago_presentado( uuid )

   METHOD test_create_pago_rechazado( uuid ) 

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPagosModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                         "text"      => "Identificador"                              ,;
                                                         "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"             ,;                                  
                                                         "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "tercero_codigo",                {  "create"    => "VARCHAR ( 20 )"                             ,;
                                                         "text"      => "Código de tercero"                          ,;
                                                         "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "medio_pago_codigo",             {  "create"    => "VARCHAR ( 20 )"                             ,;
                                                         "text"      => "Código de medio de pago"                    ,;
                                                         "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "cuenta_bancaria_tercero_uuid",  {  "create"    => "VARCHAR ( 20 )"                             ,;
                                                         "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "cuenta_bancaria_empresa_uuid",  {  "create"    => "VARCHAR ( 20 )"                             ,;
                                                         "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "fecha",                         {  "create"    => "DATE"                                       ,;
                                                         "text"      => "Fecha"                                      ,;
                                                         "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "estado",                        {  "create"    => "ENUM ( 'Presentado', 'Rechazado' )"         ,;
                                                         "text"      => "Estado"                                     ,;
                                                         "default"   => {|| 'Presentado' }  }                        )

   hset( ::hColumns, "comentario",                    {  "create"    => "VARCHAR ( 200 )"                            ,;
                                                         "text"      => "Comentario"                                 ,;
                                                         "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "tipo",                          {  "create"    => "ENUM ( 'Pago', 'Cobro' )"                   ,;
                                                         "text"      => "Tipo"                                       ,;
                                                         "default"   => {|| 'Cobro' }  }                             )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLPagosModel

   local cSql

   TEXT INTO cSql

   SELECT pagos.id AS id,
      pagos.uuid AS uuid,
      pagos.tercero_codigo AS tercero_codigo,
      pagos.fecha AS fecha,
      pagos.medio_pago_codigo AS medio_pago_codigo,
      pagos.cuenta_bancaria_tercero_uuid AS cuenta_bancaria_tercero_uuid,
      pagos.cuenta_bancaria_empresa_uuid AS cuenta_bancaria_empresa_uuid,
      pagos.comentario AS comentario,
      pagos.estado AS estado,
      clientes.nombre AS cliente_nombre,
      medio_pago.nombre AS medio_pago_nombre,
      cuentas_bancarias.nombre AS nombre_banco_tercero,
      gestool_cuentas_bancarias.nombre AS nombre_banco_empresa,
      SUM( pagos_recibos.importe ) AS importe,
      pagos.tipo AS tipo

   FROM %1$s AS pagos

   LEFT JOIN %2$s AS clientes
      ON pagos.tercero_codigo = clientes.codigo AND clientes.deleted_at = 0

   LEFT JOIN %3$s AS medio_pago
      ON pagos.medio_pago_codigo = medio_pago.codigo AND medio_pago.deleted_at = 0

  LEFT JOIN %4$s AS cuentas_bancarias
      ON pagos.cuenta_bancaria_tercero_uuid = cuentas_bancarias.uuid AND cuentas_bancarias.deleted_at = 0 
   
   LEFT JOIN %5$s AS gestool_cuentas_bancarias
      ON pagos.cuenta_bancaria_empresa_uuid = gestool_cuentas_bancarias.uuid AND gestool_cuentas_bancarias.deleted_at = 0 

   LEFT JOIN %6$s AS pagos_recibos
      ON pagos_recibos.pago_uuid = pagos.uuid 

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(),;
                                 SQLTercerosModel():getTableName(),;
                                 SQLMediosPagoModel():getTableName(),;
                                 SQLCuentasBancariasModel():getTableName(),;
                                 SQLCuentasBancariasGestoolModel():getTableName(),;
                                 SQLRecibosPagosModel():getTableName() ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_create_pago_presentado( uuid ) CLASS SQLPagosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "estado", "Presentado" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_pago_rechazado( uuid ) CLASS SQLPagosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "estado", "Rechazado" )

RETURN ( ::insertBuffer( hBuffer ) )

#endif

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

#ifdef __TEST__

CLASS TestPagosController FROM TestCase

   DATA oController

   DATA uuidPrimerPagoPresentado
   DATA uuidSegundoPagoPresentado  

   DATA uuidPrimerPagoRechazado
   DATA uuidSegundoPagoRechazado

   DATA uuidPrimerRecibo 
   DATA uuidSegundoRecibo
   
   DATA uuidPrimerPago 
   DATA uuidSegundoPago 

   METHOD beforeClass()

   METHOD afterClass()

   METHOD Before() 

   METHOD test_create_recibo_como_pagado()

   METHOD test_create_pago_como_Rechazado()   

   METHOD test_create_recibo_con_doble_pago()

   METHOD test_create_pago_con_doble_recibo()    

   METHOD test_create_recibo_con_pago_presentado_y_pago_rechazado()   

   METHOD test_create_recibo_con_pagos_rechazados() 

   METHOD test_dialog_append()

   METHOD test_dialog_append_con_bancos()

   METHOD test_dialog_append_con_importe_mayor() 

   METHOD test_dialog_append_cliente_inexistente()

   METHOD test_dialog_append_medio_pago_inexistente()

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestPagosController

   ::oController  := PagosController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestPagosController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestPagosController 

   ::uuidPrimerRecibo            := win_uuidcreatestring()
   ::uuidSegundoRecibo           := win_uuidcreatestring()

   ::uuidPrimerPagoPresentado    := win_uuidcreatestring()
   ::uuidSegundoPagoPresentado   := win_uuidcreatestring()

   ::uuidPrimerPagoRechazado     := win_uuidcreatestring()
   ::uuidSegundoPagoRechazado    := win_uuidcreatestring()

   SQLPagosModel():truncateTable()

   SQLRecibosModel():truncateTable() 

   SQLTercerosModel():truncateTable()

   SQLMediosPagoModel():truncateTable()

   SQLRecibosPagosModel():truncateTable()

   SQLCuentasBancariasModel():truncateTable()

   SQLCuentasBancariasGestoolModel():truncateTable() 

   SQLTercerosModel():test_create_contado()

   SQLMediosPagoModel():test_create_metalico()

   SQLRecibosModel():test_create_recibo( ::uuidPrimerRecibo )
   SQLRecibosModel():test_create_recibo( ::uuidSegundoRecibo )
   
   SQLCuentasBancariasModel():create_cuenta( SQLTercerosModel():test_get_uuid_contado() )
   
   SQLCuentasBancariasGestoolModel():create_cuenta( Company():Uuid() )

   SQLPagosModel():test_create_pago_presentado( ::uuidPrimerPagoPresentado )
   SQLPagosModel():test_create_pago_presentado( ::uuidSegundoPagoPresentado )

   SQLPagosModel():test_create_pago_rechazado( ::uuidPrimerPagoRechazado )
   SQLPagosModel():test_create_pago_rechazado( ::uuidSegundoPagoRechazado )

   ::oController:setUuidRecibo( ::uuidPrimerRecibo )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_recibo_como_pagado() CLASS TestPagosController

   SQLRecibosPagosModel():insertPagoRecibo( ::uuidPrimerPagoPresentado , ::uuidPrimerRecibo, 100 )

   ::Assert():Equals( RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( ::uuidPrimerRecibo ), 100, "test pago del recibo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_pago_como_rechazado() CLASS TestPagosController

   SQLRecibosPagosModel():insertPagoRecibo( ::uuidPrimerPagoRechazado, ::uuidPrimerRecibo, 100 )

   ::Assert():Equals( RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( ::uuidPrimerRecibo ), 0, "test pago del recibo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_recibo_con_doble_pago() CLASS TestPagosController

   SQLRecibosPagosModel():insertPagoRecibo( ::uuidPrimerPagoPresentado, ::uuidPrimerRecibo, 50 )

   SQLRecibosPagosModel():insertPagoRecibo( ::uuidSegundoPagoPresentado, ::uuidPrimerRecibo, 50 )

   ::Assert():Equals( 100, RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( ::uuidPrimerRecibo ), "test pago del recibo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_pago_con_doble_recibo() CLASS TestPagosController

   SQLRecibosPagosModel():insertPagoRecibo( ::uuidPrimerPagoPresentado, ::uuidPrimerRecibo, 100 )

   SQLRecibosPagosModel():insertPagoRecibo( ::uuidPrimerPagoPresentado, ::uuidSegundoRecibo, 100 )

   ::Assert():Equals( 200, RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( ::uuidPrimerRecibo ) + RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( ::uuidSegundoRecibo ) , "test pago del recibo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_recibo_con_pago_presentado_y_pago_rechazado() CLASS TestPagosController

   SQLRecibosPagosModel():insertPagoRecibo( ::uuidPrimerPagoPresentado, ::uuidPrimerRecibo, 50 )

   SQLRecibosPagosModel():insertPagoRecibo( ::uuidPrimerPagoRechazado, ::uuidPrimerRecibo, 50 )

   ::Assert():Equals( 50, RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( ::uuidPrimerRecibo ), "test pago del recibo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_recibo_con_pagos_rechazados() CLASS TestPagosController

   SQLRecibosPagosModel():insertPagoRecibo( ::uuidPrimerPagoRechazado, ::uuidPrimerRecibo, 50 )

   SQLRecibosPagosModel():insertPagoRecibo( ::uuidSegundoPagoRechazado, ::uuidPrimerRecibo, 50 )

   ::Assert():Equals( 0, RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( ::uuidPrimerRecibo ), "test pago del recibo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_append() CLASS TestPagosController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),; 
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( "0"),;
         testWaitSeconds(),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( 120, self:oFolder:aDialogs[ 1 ] ):cText( 50 ),;
         testWaitSeconds(),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( 150, self:oFolder:aDialogs[ 1 ] ):cText( "Comentario del pago" ),;
         testWaitSeconds( 3 ),;
         self:getControl( IDOK ):Click() } )

   ::Assert():true( ::oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_append_con_bancos() CLASS TestPagosController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),; 
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( "0"),;
         testWaitSeconds(),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( 120, self:oFolder:aDialogs[ 1 ] ):cText( 50 ),;
         testWaitSeconds(),;
         self:getControl( 120, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( 150, self:oFolder:aDialogs[ 1 ] ):cText( "Comentario del pago" ),;
         testWaitSeconds(),;
         self:getControl( 170, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( 170, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( 180, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( 180, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds( 3 ),;
         self:getControl( IDOK ):Click() } )

   ::Assert():true( ::oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_append_con_importe_mayor() CLASS TestPagosController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( 120, self:oFolder:aDialogs[ 1 ] ):cText( 500 ),;
         testWaitSeconds(),;
         self:getControl( 120, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds( 3 ),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds( 3 ),;
         self:getControl( IDCANCEL ):Click() } )

   ::Assert():false( ::oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_append_cliente_inexistente() CLASS TestPagosController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( "2" ),;
         testWaitSeconds(),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( 120, self:oFolder:aDialogs[ 1 ] ):cText( 50 ),;
         testWaitSeconds(),;
         self:getControl( 120, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds( 3 ),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds(),;
         self:getControl( IDCANCEL ):Click() } )

   ::Assert():false( ::oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_append_medio_pago_inexistente() CLASS TestPagosController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( 110, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( 120, self:oFolder:aDialogs[ 1 ] ):cText( 50 ),;
         testWaitSeconds(),;
         self:getControl( 120, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):cText( "1" ),;
         testWaitSeconds(),;
         self:getControl( 140, self:oFolder:aDialogs[ 1 ] ):lValid(),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds( 3 ),;
         self:getControl( IDCANCEL ):Click() } )

   ::Assert():false( ::oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )

#endif

//---------------------------------------------------------------------------//

