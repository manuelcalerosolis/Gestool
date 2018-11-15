#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PagosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()        INLINE( if( empty( ::oBrowseView ), ::oBrowseView := PagosBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()        INLINE( if( empty( ::oDialogView ), ::oDialogView := pagosView():New( self ), ), ::oDialogView )

   METHOD getRepository()        INLINE( if(empty( ::oRepository ), ::oRepository := pagosRepository():New( self ), ), ::oRepository )

   METHOD getValidator()         INLINE( if( empty( ::oValidator ), ::oValidator := PagosValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLPagosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PagosController

   ::Super:New( oController )

   ::cTitle                      := "Cobros"

   ::cName                       := "cobros"

   ::hImage                      := {  "16" => "gc_hand_money_16",;
                                       "32" => "gc_hand_money_32",;
                                       "48" => "gc_hand_money_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::getModel():setEvent( 'loadedCurrentBuffer',          {|| ::getCuentasBancariasController():loadedCurrentBuffer( "d8499d5b-8bf1-4be2-8a0e-509221332f25" ) } )

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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PagosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

END CLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS PagosBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cliente_codigo'
      :cHeader             := 'C�digo cliente'
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
      :cSortOrder          := 'fecha'
      :cHeader             := 'Expedicion'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha' ) }
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
      :cSortOrder          := 'estado'
      :cHeader             := 'Estado'
      :nWidth              := 90
      :bEditValue          := {|| ::getRowSet():fieldGet( 'estado' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PagosView FROM SQLBaseView

   DATA oEstado

   DATA aEstado INIT { "Presentado", "Rechazado" }
  
   METHOD Activate()

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

  REDEFINE GET   ::oController:getModel():hBuffer[ "importe" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "importe" ) ) ;
      PICTURE     "@E 999999999999.99";
      OF          ::oFolder:aDialogs[1]


   REDEFINE GET   ::oController:getModel():hBuffer[ "fecha" ] ;
      ID          120 ;
      VALID       ( ::oController:validate( "fecha" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oController:getMediosPagoController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "medio_pago_codigo" ] ) )
   ::oController:getMediosPagoController():getSelector():Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oFolder:aDialogs[1] } )

   ::oController:getCuentasBancariasController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "cuenta_bancaria_codigo" ] ) )
   ::oController:getCuentasBancariasController():getSelector():Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oFolder:aDialogs[1] } )

   REDEFINE GET   ::oController:getModel():hBuffer[ "comentario" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR         ::oController:getModel():hBuffer[ "estado" ] ;
      ID          160 ;
      ITEMS       ::aEstado;
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

   /*if ::oController:isNotAppendOrDuplicateMode()

      oPanel:AddLink(   "Factura...",;
                        {||::oController:getFacturasClientesController():ZoomUuid( ::oController:getModelBuffer( "parent_uuid" ) ) },;
                           ::oController:getFacturasClientesController():getImage( "16" ) )

      oPanel:AddLink(   "Pagos...",;
                        {|| msgalert( "to-do" ) },;
                           ::oController:getFacturasClientesController():getImage( "16" ) )

   end if*/ 

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
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS PagosValidator

   ::hValidators  := {  "cliente" =>   {  "required"           => "El c�digo del cliente es un dato requerido" ,;
                                          "unique"             => "EL c�digo del cliente introducido ya existe" },;
                        "importe" =>   {  "required"           => "El importe es un dato requerido" },;
                        "fecha"   =>   {  "required"           => "La fecha es un dato requerido" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPagosModel FROM SQLCompanyModel

   DATA cTableName               INIT "pagos"

   METHOD getColumns()

   METHOD getInitialSelect()

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

    hset( ::hColumns, "cuenta_bancaria_codigo",    {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "fecha",                      {  "create"    => "DATE"                                       ,;
                                                      "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "importe",                    {  "create"    => "FLOAT( 16,2 )"                              ,;
                                                      "default"   => {||  0  } }                                   )

   hset( ::hColumns, "estado",                     {  "create"     => "ENUM( 'Presentado', 'Rechazado' )"          ,;
                                                      "default"    => {|| 'Presentado' }  }                        )

   hset( ::hColumns, "comentario",                 {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   ::getDeletedStampColumn()


RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLPagosModel

   local cSql

   TEXT INTO cSql

   SELECT pagos.id AS id,
      pagos.uuid AS uuid,
      pagos.cliente_codigo AS cliente_codigo,
      pagos.fecha AS fecha,
      pagos.importe AS importe,
      pagos.medio_pago_codigo AS medio_pago_codigo,
      pagos.cuenta_bancaria_codigo AS cuenta_bancaria_codigo,
      pagos.comentario AS comentario,
      pagos.estado AS estado,
      pagos.deleted_at AS deleted_at,
      clientes.nombre AS cliente_nombre,
      medio_pago.nombre AS medio_pago_nombre,
      cuentas_bancarias.nombre AS nombre_banco

   FROM %1$s AS pagos

   INNER JOIN %2$s AS clientes
      ON pagos.cliente_codigo = clientes.codigo

   INNER JOIN %3$s AS medio_pago
      ON pagos.medio_pago_codigo = medio_pago.codigo

   INNER JOIN %4$s AS cuentas_bancarias
      ON pagos.cuenta_bancaria_codigo = cuentas_bancarias.codigo

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLClientesModel():getTableName(), SQLMediosPagoModel():getTableName(), SQLCuentasBancariasModel():getTableName() )

RETURN ( cSql )

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