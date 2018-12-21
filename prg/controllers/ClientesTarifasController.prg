#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesTarifasController FROM SQLNavigatorController

   DATA oArticulosTarifasController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD ApenndLinea()

   
   METHOD getArticulosTarifasController()    INLINE ( if( empty( ::oArticulosTarifasController ), ::oArticulosTarifasController := ArticulosTarifasController():New( self ), ), ::oArticulosTarifasController )

   //Construcciones tardias----------------------------------------------------
   
   METHOD getBrowseView()                    INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := ClientesTarifasBrowseView():New( self ), ), ::oBrowseView )

   METHOD getModel()                         INLINE ( if( empty( ::oModel ), ::oModel := SQLClientesTarifasModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ClientesTarifasController

   ::Super:New( oController )

   ::cTitle                         := "Tarifas Clientes"

   ::cName                          := "clientes_tarifas"

   ::hImage                         := {  "16" => "gc_money_interest_16",;
                                          "32" => "gc_money_interest_32",;
                                          "48" => "gc_money_interest_48" }

   ::nLevel                         := Auth():Level( ::cName )

   /*::oDialogModalView:setEvent( 'addingduplicatebutton', {|| .f. } )
   ::oDialogModalView:setEvent( 'addingeditbutton',      {|| .f. } )
   ::oDialogModalView:setEvent( 'addingzoombutton',      {|| .f. } )
   ::oDialogModalView:setEvent( 'appending',             {|| ::ApenndLinea() } )*/

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ClientesTarifasController
   
   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oArticulosTarifasController )
      ::oArticulosTarifasController:End()
   end if 

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD ApenndLinea()

   local hLine
   local aLines      := {}
   local hBuffer     := {=>}

   ::getArticulosTarifasController():oSelectorView:setLogicMultiselect( .t. )

   aLines            := ::getArticulosTarifasController():activateSelectorView()

   if empty( aLines )
      RETURN ( .f. )
   end if

   for each hLine in aLines

      hBuffer        := ::getModel():loadBlankBuffer()

      hSet( hBuffer, "parent_uuid", ::oController:getUuid() )
      hSet( hBuffer, "tarifa_uuid", hGet( hLine, "uuid" ) )

      ::getModel():insertIgnore( hBuffer )

   next

   ::getRowSet():RefreshAndGoTop()
   
   ::oBrowseView:getBrowse():Refresh()

RETURN ( .f. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLClientesTarifasModel FROM SQLCompanyModel

   DATA cTableName               INIT "clientes_tarifas"

   DATA cConstraints             INIT "PRIMARY KEY ( id ), UNIQUE KEY ( parent_uuid, tarifa_uuid )"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getTarifasNombreWhereClienteCodigo( cCodigoCliente )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLClientesTarifasModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "tarifa_uuid",       {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 40 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLClientesTarifasModel

   local cSelect  := "SELECT clientes_tarifas.id AS id, "                                 +  ;
                        "clientes_tarifas.uuid AS uuid, "                                 +  ;
                        "clientes_tarifas.parent_uuid AS parent_uuid, "                   +  ;
                        "clientes_tarifas.tarifa_uuid AS tarifa_uuid, "                   +  ;
                        "articulos_tarifas.nombre AS tarifa "                             +  ;
                     "FROM " + ::getTableName() + " AS clientes_tarifas "                 +  ;   
                        "LEFT JOIN " + SQLArticulosTarifasModel():getTableName() + " "    +  ;
                           "ON clientes_tarifas.tarifa_uuid = articulos_tarifas.uuid"

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getTarifasNombreWhereClienteCodigo( cCodigoCliente ) CLASS SQLClientesTarifasModel

   local aNombres
   local cSelect  := "SELECT articulos_tarifas.nombre AS tarifa "                         +  ;
                     "FROM " + ::getTableName() + " AS clientes_tarifas "                 +  ;   
                        "LEFT JOIN " + SQLArticulosTarifasModel():getTableName() + " "    +  ;
                           "ON clientes_tarifas.tarifa_uuid = articulos_tarifas.uuid "    +  ;
                        "LEFT JOIN " + SQLTercerosModel():getTableName() + " "            +  ;
                           "ON clientes_tarifas.parent_uuid = clientes.uuid "             +  ;
                     "WHERE clientes.codigo = " + quoted( cCodigoCliente )

   aNombres       := ::getDatabase():selectFetchArrayOneColumn( cSelect )

   if ascan( aNombres, __tarifa_base__ ) == 0
      ains( aNombres, 1, __tarifa_base__, .t. )
   end if 

RETURN ( aNombres )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ClientesTarifasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ClientesTarifasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'parent_uuid'
      :cHeader             := 'Uuid cliente'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'parent_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with
   
   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tarifa_uuid'
      :cHeader             := 'Uuid tarifa'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tarifa_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with
   
   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tarifa'
      :cHeader             := 'Tarifa'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tarifa' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//