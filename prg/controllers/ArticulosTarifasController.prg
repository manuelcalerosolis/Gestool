#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosTarifasController FROM SQLNavigatorController

   DATA uuidToDelete

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Deleting()
   
   METHOD deletingSelection()

   METHOD endAppendedTarifa()

   METHOD endEditedTarifa()

   METHOD updatedTarifa( uuidTarifaActualizar, lCosto )

   // Construcciones tardias---------------------------------------------------

   METHOD getRepository()              INLINE ( iif( empty( ::oRepository ), ::oRepository := ArticulosTarifasRepository():New( self ), ), ::oRepository )

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := ArticulosTarifasBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := ArticulosTarifasView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( iif( empty( ::oValidator ), ::oValidator := ArticulosTarifasValidator():New( self ), ), ::oValidator )
   
   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLArticulosTarifasModel():New( self ), ), ::oModel )

   METHOD getRange()                   INLINE ( iif( empty( ::oRange ), ::oRange := ArticulosTarifasItemRange():New( self ), ), ::oRange )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosTarifasController

   ::Super:New( oController )

   ::cTitle                            := "Tarifas"

   ::cName                             := "tarifas"

   ::lMultiDelete                      := .f.

   ::hImage                            := {  "16" => "gc_money_interest_16",;
                                             "32" => "gc_money_interest_32",;
                                             "48" => "gc_money_interest_48" }

   ::nLevel                            := Auth():Level( ::cName )

   ::setEvents( { 'appended', 'duplicated' }, {|| ::endAppendedTarifa() } )

   ::setEvent( 'edited', {|| ::endEditedTarifa() } )

   ::setEvent( 'deleting', {|| ::Deleting() } )
   
   ::setEvent( 'deletingSelection', {|| ::deletingSelection() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosTarifasController

   iif( !empty( ::oModel ), ::oModel:End(), )

   iif( !empty( ::oBrowseView ), ::oBrowseView:End(), )

   iif( !empty( ::oDialogView ), ::oDialogView:End(), )

   iif( !empty( ::oValidator ), ::oValidator:End(), )

   iif( !empty( ::oRepository ), ::oRepository:End(), )

   iif( !empty( ::oRange ), ::oRange:End(), )

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD deleting()

   if ::isRowSetSystemRegister()
      msgStop( "Este registro pertenece al sistema, no se puede alterar." )
      RETURN ( .f. )
   end if 

   ::uuidToDelete    := ::getRowSet():fieldGet( 'uuid' )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD deletingSelection()

RETURN ( SQLArticulosPreciosModel():deletePrecioWhereUuidTarifa( ::uuidToDelete ) )

//---------------------------------------------------------------------------//

METHOD endAppendedTarifa() CLASS ArticulosTarifasController

   local oWaitMessage

   oWaitMessage         := TWaitMeter():New( "Actualizando tarifa", "Espere por favor..." )
   oWaitMessage:Run()

   ::getArticulosPreciosController():getModel():insertPrecioWhereTarifa( hget( ::getModel():hBuffer, "uuid" ) )

   ::getArticulosPreciosController():getModel():updatePrecioWhereTarifa( hget( ::getModel():hBuffer, "uuid" ) )

   oWaitMessage:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD endEditedTarifa() CLASS ArticulosTarifasController

   local oWaitMessage

   oWaitMessage         := TWaitMeter():New( "Actualizando tarifa", "Espere por favor..." )
   oWaitMessage:Run()

   ::getArticulosPreciosController():getModel():updatePrecioWhereTarifa( hget( ::getModel():hBuffer, "uuid" ) )

   oWaitMessage:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updatedTarifa( uuidTarifaActualizar, lCosto ) CLASS ArticulosTarifasController

   local cTarifaParent  

   DEFAULT lCosto       := .f.

   ::getArticulosPreciosController():getModel():insertUpdatePrecioWhereTarifa( uuidTarifaActualizar, lCosto )

   cTarifaParent        := ::getModel():getTarifaWhereTarifaParent( uuidTarifaActualizar )

   if !empty( cTarifaParent ) .and. ( uuidTarifaActualizar != cTarifaParent )
      ::updatedTarifa( cTarifaParent )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTarifasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosTarifasBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'margen'
      :cHeader             := 'Incremento %'
      :nWidth              := 80
      :bEditValue          := {|| transform( ::getRowSet():fieldGet( 'margen' ), "@E 9999.99" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_tarifa_base'
      :cHeader             := 'Tarifa base'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_tarifa_base' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'activa'
      :cHeader             := "Activa"
      :bStrData            := {|| "" }
      :bEditValue          := {|| ::getRowSet():fieldGet( 'activa' ) }
      :nWidth              := 60
      :SetCheck( { "bullet_square_green_16", "bullet_square_red_16" } )
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'valido_desde'
      :cHeader             := 'Valido desde'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'valido_desde' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'valido_hasta'
      :cHeader             := 'Valido hasta'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'valido_hasta' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnsCreatedUpdatedAt()
   
   ::getColumnDeletedAt()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTarifasView FROM SQLBaseView

   DATA oGetCodigo

   DATA oGetMargen

   DATA oGetNombre

   DATA oComboTarifaPadre

   DATA aComboTarifaPadre

   DATA oCheckActiva

   METHOD Activate()

   METHOD Activating()              INLINE ( ::aComboTarifaPadre  := ::getItemsComboTarifaPadre() )

   METHOD startActivate()

   METHOD getItemsComboTarifaPadre()

   METHOD setItemsComboTarifaPadre()

   METHOD whenTarifaBase()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosTarifasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM_EXTENDED" ;
      TITLE       ::LblTitle() + "precios de tarifa"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Tarifa" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::redefineExplorerBar()

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General" ;
      DIALOGS     "TARIFA_GENERAL"    
   
   REDEFINE GET   ::oGetCodigo ;
      VAR         ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oGetNombre ;
      VAR         ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:getModel():isNotBufferSystemRegister() .and. ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[1]

   ::oGetNombre:bChange := {|| ::setItemsComboTarifaPadre() }

   REDEFINE COMBOBOX ::oComboTarifaPadre ;
      VAR         ::oController:getModel():hBuffer[ "parent_uuid" ] ;
      ITEMS       ( ::aComboTarifaPadre ) ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "parent_uuid" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oGetMargen ;
      VAR         ::oController:getModel():hBuffer[ "margen" ] ;
      ID          130 ;
      SPINNER ;
      PICTURE     "@E 9999.9999" ;
      WHEN        ( ::whenTarifaBase() ) ;
      VALID       ( ::oController:validate( "margen" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAYCHECKBOX ::oCheckActiva ;
      VAR         ::oController:getModel():hBuffer[ "activa" ] ;
      ID          140 ;
      IDSAY       141 ;
      WHEN        ( ::oController:getModel():isNotBufferSystemRegister() .and. ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET ::oController:getModel():hBuffer[ "valido_desde" ] ;
      ID          150 ;
      SPINNER ;
      WHEN        ( ::oController:getModel():isNotBufferSystemRegister() .and. ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET ::oController:getModel():hBuffer[ "valido_hasta" ] ;
      ID          160 ;
      SPINNER ;
      WHEN        ( ::oController:getModel():isNotBufferSystemRegister() .and. ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate( ::oFolder:aDialogs[ 1 ] ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::closeActivate( ::oFolder:aDialogs[ 1 ] ), ) }

   ::oDialog:bStart     := {|| ::startActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS ArticulosTarifasView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( nil )
   end if

   oPanel:AddLink(   "Precios...",;
                     {||   ::oController:getArticulosPreciosTarifasController():Edit( ::oController:getUuid() ) },;
                           ::oController:getArticulosPreciosTarifasController():getImage( "16" ) )

   oPanel           := ::oExplorerBar:AddPanel( "Otros", nil, 1 )

   oPanel:AddLink(   "Campos extra...",;
                     {||   ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) },;
                           ::oController:getCamposExtraValoresController():getImage( "16" ) )

   sendMessage( ::oComboTarifaPadre:hWnd, 0x0153, -1, 14 )

   ::oGetCodigo:setFocus()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getItemsComboTarifaPadre() CLASS ArticulosTarifasView

   local cItem 
   local aItems   

   if ::oController:isRowSetSystemRegister()
      aItems      := { __tarifa_base__ }
   else 
      aItems      := ::oController:getModel():getNombres()
   end if 

   ains( aItems, 1, __tarifa_costo__, .t. )

RETURN ( aItems )

//---------------------------------------------------------------------------//

METHOD setItemsComboTarifaPadre() CLASS ArticulosTarifasView

   local aItems
   local cNombreTarifa  := ::oController:getModelBuffer( "nombre" )

   if ::oController:isAppendOrDuplicateMode()

      aItems            := ::getItemsComboTarifaPadre()  

      aadd( aItems, cNombreTarifa )

      ::oComboTarifaPadre:setItems( aItems )

      ::oComboTarifaPadre:set( cNombreTarifa )

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD whenTarifaBase() CLASS ArticulosTarifasView

RETURN ( alltrim( ::oController:getModelBuffer( "nombre" ) ) != alltrim( ::oController:getModelBuffer( "parent_uuid" ) ) .and. ::oController:isNotZoomMode() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTarifasValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD notNameCosto( value )        INLINE ( alltrim( lower( value ) ) != __tarifa_costo__ )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosTarifasValidator

   ::hValidators  := {  "margen" =>       {  "positive"     => "El margen tiene que ser mayor o igual que cero" },;
                        "nombre" =>       {  "required"     => "El nombre es un dato requerido",;
                                             "unique"       => "El nombre introducido ya existe",;
                                             "notNameCosto" => "El nombre de la tarifa no puede ser '" + __tarifa_costo__ + "'" },;
                        "codigo" =>       {  "required"     => "El código es un dato requerido" ,;
                                             "unique"       => "EL código introducido ya existe" },;
                        "parent_uuid" =>  {  "required"     => "La tarifa base es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosTarifasModel FROM SQLCompanyModel

   DATA cTableName                     INIT "articulos_tarifas"

   DATA cConstraints                   INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD isParentUuidColumn()         INLINE ( .f. )

   METHOD insertTarifaBase()

   METHOD getParentUuidAttribute( uuid ) ;
                                       INLINE ( if( empty( uuid ), __tarifa_costo__, SQLArticulosTarifasModel():getNombreWhereUuid( uuid ) ) )

   METHOD setParentUuidAttribute( nombre )   

   METHOD getInitialSelect()

   METHOD getTarifaWhereTarifaParent( uuidTarifaParent ) ;
                                       INLINE ( ::getField( "uuid", "parent_uuid", uuidTarifaParent ) )

   METHOD getNombres()      

#ifdef __TEST__

   METHOD test_create_tarifa_base() 

   METHOD test_create_tarifa_mayorista()    

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLArticulosTarifasModel

   local cSql

   TEXT INTO cSql

      SELECT articulos_tarifas.id,
         articulos_tarifas.uuid,
         articulos_tarifas.parent_uuid,
         articulos_tarifas.codigo,
         articulos_tarifas.nombre,
         articulos_tarifas.margen,
         articulos_tarifas.activa,
         articulos_tarifas.valido_desde,
         articulos_tarifas.valido_hasta, 
         articulos_tarifas.sistema,
         articulos_tarifas.created_at,
         articulos_tarifas.updated_at,
         articulos_tarifas.deleted_at,

      IFNULL( articulos_tarifas_base.nombre, %2$s ) AS nombre_tarifa_base  

      FROM %1$s AS articulos_tarifas 

      LEFT JOIN %1$s AS articulos_tarifas_base
         ON articulos_tarifas_base.uuid = articulos_tarifas.parent_uuid

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( __tarifa_costo__ ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosTarifasModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                "text"      => "Identificador"                           ,;
                                                "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"          ,;                                 
                                                "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",          {  "create"    => "VARCHAR ( 40 ) NOT NULL"                 ,;                                 
                                                "default"   => {|| space( 40 ) } }                       )
   
   hset( ::hColumns, "codigo",               {  "create"    => "VARCHAR ( 20 ) NOT NULL"                 ,;
                                                "text"      => "Código"                                  ,;
                                                "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",               {  "create"    => "VARCHAR ( 200 ) NOT NULL"                ,;
                                                "text"      => "Nombre"                                  ,;
                                                "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "margen",               {  "create"    => "FLOAT ( 8, 4 )"                          ,;
                                                "text"      => "Margen"                                  ,;
                                                "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "activa",               {  "create"    => "TINYINT ( 1 )"                           ,;
                                                "text"      => "Activa"                                  ,;
                                                "default"   => {|| 1 } }                                 )

   hset( ::hColumns, "valido_desde",         {  "create"    => "DATE"                                    ,;
                                                "text"      => "Valido desde"                            ,;
                                                "default"   => {|| ctod( "" ) } }                        )

   hset( ::hColumns, "valido_hasta",         {  "create"    => "DATE"                                    ,;
                                                "text"      => "Valido hasta"                            ,;
                                                "default"   => {|| ctod( "" ) } }                        )

   hset( ::hColumns, "sistema",              {  "create"    => "TINYINT ( 1 )"                           ,;
                                                "text"      => "Sistema"                                 ,;
                                                "default"   => {|| 0 } }                                 )

   ::getTimeStampColumns()

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD setParentUuidAttribute( nombre )   

   if hb_isnil( nombre ) .or. ( alltrim( nombre ) == __tarifa_costo__ )
      RETURN ( "" )
   end if

   if hb_ischar( nombre ) .and. ( alltrim( nombre ) == alltrim( ::hBuffer[ "nombre" ] ) )
      RETURN ( ::hBuffer[ "uuid" ] )
   end if 

RETURN ( SQLArticulosTarifasModel():getUuidWhereNombre( nombre ) )  

//---------------------------------------------------------------------------//

METHOD insertTarifaBase() CLASS SQLArticulosTarifasModel

   local uuid     := win_uuidcreatestring()
   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "codigo", "0" )
   hset( hBuffer, "nombre", __tarifa_base__ )

RETURN ( ::insertIgnore( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS SQLArticulosTarifasModel

   local cSql

   TEXT INTO cSql

   SELECT nombre FROM %1$s 

   WHERE
      activa = 1 
      AND ( valido_desde IS NULL OR valido_desde >= CURDATE() )
      AND ( valido_hasta IS NULL OR valido_hasta <= CURDATE() ) 
      AND ( deleted_at = 0 )

   ORDER BY id

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName() )

RETURN ( getSQLDatabase():selectFetchArrayOneColumn( cSql ) )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_create_tarifa_base() CLASS SQLArticulosTarifasModel

   local uuid     := ::getFieldWhere( "uuid", { "nombre" => __tarifa_base__ } )
   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "codigo", "0" )
   hset( hBuffer, "nombre", "Base" )
   hset( hBuffer, "margen", 30 )

RETURN ( ::insertIgnore( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_tarifa_mayorista() CLASS SQLArticulosTarifasModel

   local uuid     := ::getFieldWhere( "uuid", { "nombre" => __tarifa_base__ } )
   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "codigo", "1" )
   hset( hBuffer, "nombre", "Mayorista" )
   hset( hBuffer, "margen", 50 )

RETURN ( ::insertIgnore( hBuffer ) )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTarifasRepository FROM SQLBaseRepository

   METHOD getTableNameSQL()            INLINE ( SQLArticulosTarifasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTarifasItemRange FROM ItemRange

   DATA cKey                           INIT 'metodo_pago_codigo'

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestArticulosTarifasController FROM TestCase

   METHOD initModels()

   METHOD testDialogoCambioPorcentajeTarifaBase() 

   METHOD testDialogoCreacionNuevaTarifa()

END CLASS

//---------------------------------------------------------------------------//

METHOD initModels() CLASS TestArticulosTarifasController

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogoCambioPorcentajeTarifaBase() CLASS TestArticulosTarifasController

   local nId
   local oController

   ::initModels()

   oController             := ArticulosTarifasController():New()

   nId                     := oController:getModel():getField( "id", "nombre", __tarifa_base__ )
   
   ::Assert():notnull( nId, "test identificador de la tarifa base" )

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:oGetMargen():cText( 50 ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click() } )

   ::Assert():true( oController:Edit( nId ), "test modificación porcentaje tarifa base" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogoCreacionNuevaTarifa() CLASS TestArticulosTarifasController

   local oController

   ::initModels()

   oController             := ArticulosTarifasController():New()

   oController:getModel():deleteWhere( { "nombre" => "Mayorista" } )   

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:oGetCodigo:cText( "1" ),;
         testWaitSeconds(),;
         self:oGetNombre:cText( "Mayorista" ),;
         testWaitSeconds(),;
         self:oComboTarifaPadre:set( __tarifa_base__ ),;
         testWaitSeconds(),;
         self:oGetMargen:cText( 50 ),;
         testWaitSeconds(),;
         self:oCheckActiva():Click(),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click() } )

   ::Assert():true( oController:Append(), "test creación tarifa mayorista" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

