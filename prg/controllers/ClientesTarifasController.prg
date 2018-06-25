#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesTarifasController FROM SQLNavigatorController

   DATA oArticulosTarifasController

   METHOD New()

   METHOD End()

   METHOD ApenndLinea()

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

   ::oModel                         := SQLClientesTarifasModel():New( self )

   ::oBrowseView                    := ClientesTarifasBrowseView():New( self )

   ::oArticulosTarifasController    := ArticulosTarifasController():New( self )

   ::oDialogModalView:setEvent( 'addingduplicatebutton', {|| .f. } )
   ::oDialogModalView:setEvent( 'addingeditbutton', {|| .f. } )
   ::oDialogModalView:setEvent( 'addingzoombutton', {|| .f. } )
   ::oDialogModalView:setEvent( 'appending', {|| ::ApenndLinea() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ClientesTarifasController

   ::oModel:End()

   ::oArticulosTarifasController:End()

   ::Super:End()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD ApenndLinea()

   local hLine
   local aLines      := {}
   local hBuffer     := {=>}

   ::oArticulosTarifasController:oSelectorView:setLogicMultiselect( .t. )

   aLines            := ::oArticulosTarifasController:activateSelectorView()

   if Empty( aLines )
      Return ( .f. )
   end if

   for each hLine in aLines

      hBuffer        := ::oModel():loadBlankBuffer()

      hSet( hBuffer, "parent_uuid", ::oSenderController:getUuid() )
      hSet( hBuffer, "tarifa_uuid", hGet( hLine, "uuid" ) )

      ::oModel:insertIgnoreBuffer( hBuffer )

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

   local cSelect  := "SELECT clientes_tarifas.id AS id, "                                                      + ;
                        "clientes_tarifas.uuid AS uuid, "                                                      + ;
                        "clientes_tarifas.parent_uuid AS parent_uuid, "                                        + ;
                        "clientes_tarifas.tarifa_uuid AS tarifa_uuid, "                                        + ;
                        "articulos_tarifas.nombre AS tarifa "                                                  + ;
                     "FROM " + ::getTableName() + " AS clientes_tarifas "                                      + ;   
                        "LEFT JOIN " + SQLArticulosTarifasModel():getTableName() + " ON clientes_tarifas.tarifa_uuid = articulos_tarifas.uuid"

RETURN ( cSelect )

//---------------------------------------------------------------------------//

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
      :cHeader             := 'Uuid'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid cliente'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'parent_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with
   
   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid tarifa'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tarifa_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with
   
   with object ( ::oBrowse:AddCol() )
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