#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosTarifasController FROM SQLNavigatorController

   DATA oCamposExtraValoresController

   DATA oArticulosPreciosController

   METHOD New()

   METHOD End()

   METHOD Delete( aSelectedRecno )

   METHOD insertPreciosWhereTarifa()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ArticulosTarifasController

   ::Super:New()

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

   ::oArticulosPreciosController    := ArticulosPreciosController():New( self )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, ::oModel:cTableName )

   ::oRepository                    := ArticulosTarifasRepository():New( self )

   ::setEvents( { 'appended', 'duplicated', 'edited' },  {|| ::insertPreciosWhereTarifa() } )

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

METHOD insertPreciosWhereTarifa() CLASS ArticulosTarifasController

   local cTarifa     
   local uuidTarifa

   cTarifa           := hget( ::oModel:hBuffer, "parent_uuid" )

   if cTarifa == __tarifa_costo__
      RETURN ( ::oArticulosPreciosController:oModel:insertUpdatePreciosSobreCostoWhereTarifa( hget( ::oModel:hBuffer, "uuid" ), hget( ::oModel:hBuffer, "margen" ) ) )
   end if

   uuidTarifa        := SQLArticulosTarifasModel():getUuidWhereNombre( cTarifa )

   msgalert( cTarifa, "cTarifa" )
   msgalert( uuidTarifa, "uuidTarifa" )

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

   DATA oSayCamposExtra

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

   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TARIFA" ;
      TITLE       ::LblTitle() + "tarifa"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage( "48" )  ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:oModel:isNotBufferSystemRegister() .and. ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oComboTarifaPadre ;
      VAR         ::oController:oModel:hBuffer[ "parent_uuid" ] ;
      ITEMS       ( ::aComboTarifaPadre ) ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "parent_uuid" ) ) ;
      OF          ::oDialog ;

   ::oComboTarifaPadre:bChange   := {|| ::changeComboTarifaPadre() }

   REDEFINE GET   ::oGetMargen ;
      VAR         ::oController:oModel:hBuffer[ "margen" ] ;
      ID          130 ;
      SPINNER ;
      PICTURE     "@E 9999.9999" ;
      WHEN        ( ::whenTarifaBase() ) ;
      VALID       ( ::oController:validate( "margen" ) ) ;
      OF          ::oDialog ;

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "activa" ] ;
      ID          140 ;
      IDSAY       141 ;
      WHEN        ( ::oController:oModel:isNotBufferSystemRegister() .and. ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET ::oController:oModel:hBuffer[ "valido_desde" ] ;
      ID          150 ;
      SPINNER ;
      WHEN        ( ::oController:oModel:isNotBufferSystemRegister() .and. ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET ::oController:oModel:hBuffer[ "valido_hasta" ] ;
      ID          160 ;
      SPINNER ;
      WHEN        ( ::oController:oModel:isNotBufferSystemRegister() .and. ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        getBoldFont() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          170 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }

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

   sendMessage( ::oComboTarifaPadre:hWnd, 0x0153, -1, 14 )

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
      aItems      := ::oController:oModel:getColumnWhere( 'nombre', 'uuid', '!=', ::oController:oModel:hBuffer[ 'uuid' ] )
   end if 

   ains( aItems, 1, __tarifa_costo__, .t. )

RETURN ( aItems )

//---------------------------------------------------------------------------//

METHOD setItemsComboTarifaPadre() CLASS ArticulosTarifasView

   local cItem 
   local aItems   

   if ::oController:isRowSetSystemRegister()
      aItems      := { __tarifa_base__ }
   else 
      aItems      := ::oController:oModel:getColumnWhere( 'nombre', 'uuid', '!=', ::oController:oModel:hBuffer[ 'uuid' ] )
   end if 

   ains( aItems, 1, __tarifa_costo__, .t. )

   ::oComboTarifaPadre:setItems( aItems )

   cItem          := ::oController:oModel:hBuffer[ "parent_uuid" ]

   ::oComboTarifaPadre:set( cItem )

RETURN ( nil )

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

   METHOD getInsertArticulosTarifasSentence()

   METHOD getParentUuidAttribute( uuid )     INLINE ( if( empty( uuid ), __tarifa_costo__, SQLArticulosTarifasModel():getNombreWhereUuid( uuid ) ) )

   METHOD setParentUuidAttribute( nombre )   INLINE ( if( hb_isnil( nombre ) .or. ( alltrim( nombre ) == __tarifa_costo__ ), "", SQLArticulosTarifasModel():getUuidWhereNombre( nombre ) ) )

   METHOD getActivaAttribute( activa )       INLINE ( if( hb_isnil( activa ), .t., ( activa == 1 ) ) )

   METHOD setActivaAttribute( activa )       INLINE ( if( hb_isnil( activa ), 1, if( activa, 1, 0 ) ) )

   METHOD getInitialSelect()

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

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInsertArticulosTarifasSentence()

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