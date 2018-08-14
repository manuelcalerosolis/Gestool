#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesDescuentosLineasController FROM SQLNavigatorController

   METHOD New()

   /*METHOD loadBlankBuffer()            INLINE ( ::oModel:loadBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::oModel:insertBuffer() )

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )*/

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS FacturasClientesDescuentosLineasController

   ::Super:New( oSenderController )

   ::cTitle                      := "DescuentosLineas"

   ::cName                       := "facturas_clientes_descuentos_lineas"

   ::hImage                      := {  "16" => "gc_symbol_percent_16",;
                                       "32" => "gc_symbol_percent_32",;
                                       "48" => "gc_symbol_percent_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLFacturasClientesDescuentosLineasModel():New( self )

   ::oBrowseView                    := FacturasClientesDescuentosLineasBrowseView():New( self )

   ::oDialogView                    := FacturasClientesDescuentosLineasView():New( self )

   ::oValidator                     := FacturasClientesDescuentosLineasValidator():New( self, ::oDialogView )

   ::oRepository                    := FacturasClientesDescuentosLineasRepository():New( self )

   /*::setEvent( 'appended',                      {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',                        {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::oBrowseView:Refresh() } )

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )*/


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasClientesDescuentosLineasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

/*METHOD LoadedCurrentBuffer( uuiddescuento ) CLASS DescuentosController

   local idDescuento     

   if empty( uuiddescuento )
      ::oModel:insertBuffer()
   end if 

   idDescuento          := ::oModel:getIdWhereParentUuid( uuiddescuento )
   if empty( idDescuento )
      idDescuento       := ::oModel:insertBlankBuffer()
   end if 

   ::oModel:loadCurrentBuffer( idDescuento )

RETURN ( self )
*/
//---------------------------------------------------------------------------//

/*METHOD UpdateBuffer( uuidDescuento ) CLASS DescuentosController

   local idDescuento     

   idDescuento          := ::oModel:getIdWhereParentUuid( uuidDescuento )
   if empty( idDescuento )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:updateBuffer()

RETURN ( self )
*/
//---------------------------------------------------------------------------//
/*
METHOD loadedDuplicateCurrentBuffer( uuidDescuento ) CLASS DescuentosController

   local idDescuento     

   idDescuento          := ::oModel:getIdWhereParentUuid( uuidDescuento )
   if empty( idDescuento )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:loadDuplicateBuffer( idDescuento )

RETURN ( self )
*/
//---------------------------------------------------------------------------//
/*
METHOD loadedDuplicateBuffer( uuidDescuento ) CLASS DescuentosController

   hset( ::oModel:hBuffer, "parent_uuid", uuidDescuento )

RETURN ( self )
*/
//---------------------------------------------------------------------------//
/*
METHOD deleteBuffer( aUuidEntidades ) CLASS DescuentosController

   if empty( aUuidEntidades )
      RETURN ( self )
   end if

   ::oModel:deleteWhereParentUuid( aUuidEntidades )

RETURN ( self )
*/
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesDescuentosLineasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS FacturasClientesDescuentosLineasBrowseView

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
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 130
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'descuento'
      :cHeader             := 'Descuento'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descuento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesDescuentosLineasView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS FacturasClientesDescuentosLineasView

   local oDialog
   local oBmpGeneral

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DESCUENTOS" ;
      TITLE       ::LblTitle() + "descuento"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "descuento" ] ;
      ID          100 ;
      SPINNER ;
      PICTURE     "@E 999.9999" ;
      VALID       ( ::oController:validate( "descuento" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION     ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesDescuentosLineasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FacturasClientesDescuentosLineasValidator

   ::hValidators  := {  "descuento" =>           {  "required"              => "El porcentaje de descuento es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLFacturasClientesDescuentosLineasModel FROM SQLCompanyModel

   DATA cTableName               INIT "facturas_clientes_descuentos_lineas"

   METHOD getColumns()

   METHOD InsertWhereCliente( UuidCliente ) 

   /*METHOD getIdWhereParentUuid( uuid ) INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD getParentUuidAttribute( value )*/

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFacturasClientesDescuentosLineasModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                   "default"   => {|| ::getSenderControllerParentUuid() } } )


   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR( 200 ) NOT NULL"                 ,;
                                                   "default"   => {|| space( 200 ) } }                      )


   hset( ::hColumns, "descuento",               {  "create"    => "FLOAT(7,4)"                              ,;
                                                   "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

/*METHOD getParentUuidAttribute( value ) CLASS SQLDescuentosModel

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oSenderController )
      RETURN ( value )
   end if

RETURN ( ::oController:oSenderController:getUuid() )*/

//---------------------------------------------------------------------------//

METHOD InsertWhereCliente( UuidCliente ) CLASS SQLFacturasClientesDescuentosLineasModel
   local cSql

   TEXT INTO cSql

   INSERT IGNORE INTO %1$s (uuid, parent_uuid, nombre, descuento)

   SELECT %3$s,
          %4$s
          descuentos.nombre,
          descuentos.descuento
   FROM %2$s AS descuentos

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLDescuentosModel():getTableName(),quoted( win_uuidcreatestring() ),::getSenderControllerParentUuid()  )

RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesDescuentosLineasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFacturasClientesDescuentosLineasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//