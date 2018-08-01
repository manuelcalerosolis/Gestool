#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosTarifasController FROM SQLNavigatorController

   DATA oCamposExtraValoresController

   DATA oArticulosPreciosController

   METHOD New()

   METHOD End()

   METHOD Delete( aSelectedRecno )

   METHOD endAppendedTarifa()

   METHOD endEditedTarifa()

   METHOD updatedTarifa( uuidTarifaActualizar, lCosto )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS ArticulosTarifasController

   ::Super:New( oSenderController )

   ::cTitle                         := "Tarifas"

   ::cName                          := "tarifas"

   ::hImage                         := {  "16" => "gc_money_interest_16",;
                                          "32" => "gc_money_interest_32",;
                                          "48" => "gc_money_interest_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLArticulosTarifasModel():New( self )

   ::oBrowseView                    := ArticulosTarifasBrowseView():New( self )

   ::oDialogView                    := ArticulosTarifasView():New( self )

   ::oValidator                     := ArticulosTarifasValidator():New( self, ::oDialogView )

   ::oGetSelector                   := GetSelector():New( self )

   ::oArticulosPreciosController    := ArticulosPreciosTarifasController():New( self )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, ::oModel:cTableName )

   ::oRepository                    := ArticulosTarifasRepository():New( self )

   ::setEvents( { 'appended', 'duplicated' },  {|| ::endAppendedTarifa() } )

   ::setEvent( 'edited',            {|| ::endEditedTarifa() } )

   ::setEvent( 'deleting',          {|| if( ::isRowSetSystemRegister(), ( msgStop( "Este registro pertenece al sistema, no se puede alterar." ), .f. ), .t. ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosTarifasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oArticulosPreciosController:End()

   ::oCamposExtraValoresController:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Delete( aSelectedRecno ) CLASS ArticulosTarifasController

   if len( aSelectedRecno ) > 1
      msgStop( "No se pueden realizar eliminaciones multiples en tarifas." )
      RETURN .f.
   end if 

   if ( ::getRowSet():fieldGet( 'uuid' ) == Company():Uuid() ) 
      msgStop( "No se puede eliminar la tarifa General." )
      RETURN .f.
   end if 

RETURN ( ::Super:Delete( aSelectedRecno ) )

//---------------------------------------------------------------------------//

METHOD endAppendedTarifa() CLASS ArticulosTarifasController

   local oWaitMessage
   local uuidTarifaActualizar  

   oWaitMessage         := TWaitMeter():New( "Actualizando tarifa", "Espere por favor..." )
   oWaitMessage:Run()

   uuidTarifaActualizar := hget( ::oModel:hBuffer, "uuid" )

   ::oArticulosPreciosController:oModel:insertPrecioWhereTarifa( uuidTarifaActualizar )

   oWaitMessage:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD endEditedTarifa() CLASS ArticulosTarifasController

   local oWaitMessage
   local uuidTarifaActualizar  

   oWaitMessage         := TWaitMeter():New( "Actualizando tarifa", "Espere por favor..." )
   oWaitMessage:Run()

   uuidTarifaActualizar := hget( ::oModel:hBuffer, "uuid" )

   ::oArticulosPreciosController:oModel:updatePrecioWhereTarifa( uuidTarifaActualizar )

   oWaitMessage:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

// quitar

METHOD updatedTarifa( uuidTarifaActualizar, lCosto ) CLASS ArticulosTarifasController

   local cTarifaParent  

   DEFAULT lCosto       := .f.

   ::oArticulosPreciosController:oModel:insertUpdatePrecioWhereTarifa( uuidTarifaActualizar, lCosto )

   cTarifaParent        := ::oModel:getTarifaWhereTarifaParent( uuidTarifaActualizar )

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

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

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
      :bEditValue          := {|| ::getRowSet():fieldGet( 'activa' ) == 1 }
      :nWidth              := 60
      :SetCheck( { "Sel16", "Nil16" } )
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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTarifasView FROM SQLBaseView

   DATA oGetMargen

   DATA oComboTarifaPadre

   DATA aComboTarifaPadre

   METHOD Activate()

   METHOD Activating()              INLINE ( ::aComboTarifaPadre  := ::getItemsComboTarifaPadre() )

   METHOD startActivate()

   METHOD getItemsComboTarifaPadre()

   METHOD setItemsComboTarifaPadre()

   METHOD changeComboTarifaPadre()

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
      FONT        getBoldFont() ;
      OF          ::oDialog

   ::redefineExplorerBar()

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General" ;
      DIALOGS     "TARIFA_GENERAL"    
   
   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:oModel:isNotBufferSystemRegister() .and. ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) .and. ::setItemsComboTarifaPadre() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE COMBOBOX ::oComboTarifaPadre ;
      VAR         ::oController:oModel:hBuffer[ "parent_uuid" ] ;
      ITEMS       ( ::aComboTarifaPadre ) ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "parent_uuid" ) ) ;
      OF          ::oFolder:aDialogs[1]

   ::oComboTarifaPadre:bChange   := {|| ::changeComboTarifaPadre() }

   REDEFINE GET   ::oGetMargen ;
      VAR         ::oController:oModel:hBuffer[ "margen" ] ;
      ID          130 ;
      SPINNER ;
      PICTURE     "@E 9999.9999" ;
      WHEN        ( ::whenTarifaBase() ) ;
      VALID       ( ::oController:validate( "margen" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "activa" ] ;
      ID          140 ;
      IDSAY       141 ;
      WHEN        ( ::oController:oModel:isNotBufferSystemRegister() .and. ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET ::oController:oModel:hBuffer[ "valido_desde" ] ;
      ID          150 ;
      SPINNER ;
      WHEN        ( ::oController:oModel:isNotBufferSystemRegister() .and. ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET ::oController:oModel:hBuffer[ "valido_hasta" ] ;
      ID          160 ;
      SPINNER ;
      WHEN        ( ::oController:oModel:isNotBufferSystemRegister() .and. ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS ArticulosTarifasView

   local oPanel            

   sendMessage( ::oComboTarifaPadre:hWnd, 0x0153, -1, 14 )

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( self )
   end if

   oPanel:AddLink(   "Precios...",;
                     {|| ::oController:oArticulosPreciosController:Edit( ::oController:getUuid() ) },;
                     ::oController:oArticulosPreciosController:getImage( "16" ) )

   oPanel           := ::oExplorerBar:AddPanel( "Otros", nil, 1 )

   oPanel:AddLink(   "Campos extra...",;
                     {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) },;
                     ::oController:oCamposExtraValoresController:getImage( "16" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changeComboTarifaPadre() CLASS ArticulosTarifasView

   ::oGetMargen:varPut( 0 )

   ::oGetMargen:Refresh()

   ::oGetMargen:setFocus()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getItemsComboTarifaPadre() CLASS ArticulosTarifasView

   local cItem 
   local aItems   

   if ::oController:isRowSetSystemRegister()
      aItems      := { __tarifa_base__ }
   else 
      aItems      := ::oController:oModel:getNombres()
   end if 

   ains( aItems, 1, __tarifa_costo__, .t. )

RETURN ( aItems )

//---------------------------------------------------------------------------//

METHOD setItemsComboTarifaPadre() CLASS ArticulosTarifasView

   local aItems
   local cNombreTarifa  := ::oController:oModel:hBuffer[ "nombre" ]

   if ::oController:isAppendOrDuplicateMode()

      aItems            := ::getItemsComboTarifaPadre()  

      aadd( aItems, cNombreTarifa )

      ::oComboTarifaPadre:setItems( aItems )

      ::oComboTarifaPadre:set( cNombreTarifa )

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD whenTarifaBase() CLASS ArticulosTarifasView

RETURN ( alltrim( ::oController:oModel:hBuffer[ "nombre" ] ) != alltrim( ::oController:oModel:hBuffer[ "parent_uuid" ] ) .and. ::oController:isNotZoomMode() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTarifasValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD notNameCosto( value )           INLINE ( alltrim( lower( value ) ) != __tarifa_costo__ )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosTarifasValidator

   ::hValidators  := {  "nombre" =>       {  "required"     => "El nombre es un dato requerido",;
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

   DATA cTableName                           INIT "articulos_tarifas"

   DATA cConstraints                         INIT "PRIMARY KEY ( id ), UNIQUE KEY ( codigo )"

   METHOD getColumns()

   METHOD isParentUuidColumn()               INLINE ( .f. )

   METHOD getInsertArticulosTarifasSentence()

   METHOD getParentUuidAttribute( uuid )     INLINE ( if( empty( uuid ), __tarifa_costo__, SQLArticulosTarifasModel():getNombreWhereUuid( uuid ) ) )

   METHOD setParentUuidAttribute( nombre )   // INLINE ( if( hb_isnil( nombre ) .or. ( alltrim( nombre ) == __tarifa_costo__ ), "", SQLArticulosTarifasModel():getUuidWhereNombre( nombre ) ) )

   METHOD getActivaAttribute( activa )       INLINE ( if( hb_isnil( activa ), .t., ( activa == 1 ) ) )

   METHOD setActivaAttribute( activa )       INLINE ( if( hb_isnil( activa ), 1, if( activa, 1, 0 ) ) )

   METHOD getInitialSelect()

   METHOD getTarifaWhereTarifaParent( uuidTarifaParent ) ;
                                             INLINE ( ::getField( "uuid", "parent_uuid", uuidTarifaParent ) )

   METHOD getNombres( cColumn )              INLINE ( ::getDatabase():selectFetchArrayOneColumn( "SELECT nombre FROM " + ::getTableName() + " ORDER BY id" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLArticulosTarifasModel

   local cSelect  := "SELECT articulos_tarifas.id, "                                                                
   cSelect        +=    "articulos_tarifas.uuid, "                                                                  
   cSelect        +=    "articulos_tarifas.parent_uuid, "                                                           
   cSelect        +=    "articulos_tarifas.codigo, "                                                         
   cSelect        +=    "articulos_tarifas.nombre, "                                                         
   cSelect        +=    "articulos_tarifas.margen, "                                                         
   cSelect        +=    "articulos_tarifas.activa, "                                                         
   cSelect        +=    "articulos_tarifas.valido_desde, "                                                         
   cSelect        +=    "articulos_tarifas.valido_hasta, "                                                         
   cSelect        +=    "articulos_tarifas.sistema, "                            

   cSelect        +=    "IFNULL( articulos_tarifas_base.nombre, " + quoted( __tarifa_costo__ ) + " ) AS nombre_tarifa_base " 

   cSelect        += "FROM " + ::getTableName() + " AS articulos_tarifas "

   cSelect        +=    "LEFT JOIN " + ::getTableName() + " AS articulos_tarifas_base "        
   cSelect        +=       "ON articulos_tarifas_base.uuid = articulos_tarifas.parent_uuid"

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosTarifasModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                                "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",          {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;                                  
                                                "default"   => {|| space( 40 ) } }                       )
   
   hset( ::hColumns, "codigo",               {  "create"    => "VARCHAR( 20 ) NOT NULL UNIQUE"           ,;
                                                "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",               {  "create"    => "VARCHAR( 200 ) NOT NULL UNIQUE"          ,;
                                                "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "margen",               {  "create"    => "FLOAT( 8, 4 )"                           ,;
                                                "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "activa",               {  "create"    => "TINYINT ( 1 )"                           ,;
                                                "default"   => {|| 1 } }                                 )

   hset( ::hColumns, "valido_desde",         {  "create"    => "DATE"                                    ,;
                                                "default"   => {|| ctod( "" ) } }                        )

   hset( ::hColumns, "valido_hasta",         {  "create"    => "DATE"                                    ,;
                                                "default"   => {|| ctod( "" ) } }                        )

   hset( ::hColumns, "sistema",              {  "create"    => "TINYINT ( 1 )"                           ,;
                                                "default"   => {|| 0 } }                                 )

   ::getTimeStampColumns()

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

METHOD getInsertArticulosTarifasSentence() CLASS SQLArticulosTarifasModel

   local uuid 
   local cSentence 

   uuid        := win_uuidcreatestring()

   cSentence   := "INSERT IGNORE INTO " + ::getTableName() + " "
   cSentence   +=    "( uuid, parent_uuid, codigo, nombre, margen, activa, sistema ) "
   cSentence   += "VALUES "
   cSentence   +=    "( '" + uuid + "', '" + uuid + "', '1', '" + __tarifa_base__ + "', 0, 1, 1 )"

RETURN ( cSentence )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTarifasRepository FROM SQLBaseRepository

   METHOD getTableNameSQL()               INLINE ( SQLArticulosTarifasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//