#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CaracteristicasLineasController FROM SQLBrowseController

   METHOD New()

   METHOD End()

   METHOD validateNombre( uValue )

   METHOD updateField( cField, uValue )

   METHOD validLine()

    //Contrucciones tardias---------------------------------------------------//

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := CaracteristicasLineasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := CaracteristicasLineasValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()                   INLINE( if( empty( ::oModel ), ::oModel := SQLCaracteristicasLineasModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CaracteristicasLineasController

   ::Super:New( oController )

   ::cTitle                      := "Características lineas"

   ::cName                       := "articulos_caracteristicas_lineas" 

   ::setEvent( 'exitAppended', {|| ::getBrowseView():setFocusColumnNombre() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CaracteristicasLineasController
   
   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oValidator )
      ::oValidator:End()
   end if
   
RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD validateNombre( oGet ) CLASS CaracteristicasLineasController

RETURN ( ::validate( 'nombre', alltrim( oGet:varGet() ) ) )

//---------------------------------------------------------------------------//

METHOD updateField( uValue ) CLASS CaracteristicasLineasController

   ::getModel():updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), "nombre", uValue )
   
   ::getRowSet():Refresh()
   
   ::getBrowseView():Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validLine( uuidParent ) CLASS CaracteristicasLineasController

   if ::getRowSet():recCount == 0
      RETURN ( .t. )
   end if 

   if empty( ::getRowSet():fieldget( 'nombre' ) )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CaracteristicasLineasBrowseView FROM SQLBrowseView

   DATA oColumnNombre

   METHOD addColumns()

   METHOD getEditGet()                 INLINE ( if( ::getSuperController():isNotZoomMode(), EDIT_GET, 0 ) )                       

   METHOD setFocusColumnNombre()       INLINE ( ::oBrowse:setFocus(), ::oBrowse:goToCol( ::oColumnNombre ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CaracteristicasLineasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 60
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

   with object ( ::oColumnNombre := ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 590
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := ::getEditGet()
      :bEditValid          := {| oGet, oCol | ::oController:validateNombre( oGet ) }
      :bOnPostEdit         := {|oCol, uNewValue| ::getController():updateField( uNewValue )  }
   end with

   ::getColumnDeletedAt()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CaracteristicasLineasValidator FROM SQLParentValidator

   METHOD getValidators()
 
   METHOD getDialogView()              INLINE ( ::getController():getController():getDialogView() )

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CaracteristicasLineasValidator

   ::hValidators  := {  "nombre" =>    {  "required"  => "El valor de la caracteristica es un dato requerido" ,;
                                          "unique"    => "El valor introducido ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCaracteristicasLineasModel FROM SQLCompanyModel

   DATA cTableName                        INIT "articulos_caracteristicas_lineas" 

   DATA cConstraints                      INIT "PRIMARY KEY ( nombre, parent_uuid, deleted_at )"

   METHOD getColumns()

   METHOD getNombreWhereUuid( uuid )      INLINE ( ::getField( 'nombre', 'uuid', uuid ) )

   METHOD getArrayNombreValoresFromUuid( uuid )

   METHOD getNamesFromIdLanguagesPS( uuidCaracteristica, aIdsLanguages )

   METHOD testCreateCaracteristicaLineaSinParent( uuidParent )

   METHOD testCreateCaracteristicaLineaConParent( uuidParent )

   METHOD testCreateCaracteristicaLineaSinNombre( uuidParent )

   METHOD testCreateCaracteristicaLineaConUuidAndParent( uuid, uuidParent )

   METHOD detectDuplicate( uuidParent )

   METHOD deleteBlank( uuidParent )


END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCaracteristicasLineasModel
   
   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",    {  "create"    => "VARCHAR( 40 ) NOT NULL"                           ,;
                                          "default"   => {|| ::getControllerParentUuid() } }       )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR( 200 ) NOT NULL"                          ,;
                                          "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "personalizado",  {  "create"    => "TINYINT ( 1 )"                           ,;
                                          "default"   => {|| 0 } }                                 )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getArrayNombreValoresFromUuid( uuid ) CLASS SQLCaracteristicasLineasModel

local cSql

   TEXT INTO cSql

   SELECT nombre 

   FROM %1$s AS articulos_caracteristicas_lineas
      
   WHERE parent_uuid = %2$s AND personalizado = 0

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(),quoted( uuid ) ) 

RETURN ( getSQLDatabase():selectFetchArrayOneColumn( cSql ) )

//---------------------------------------------------------------------------//

METHOD getNamesFromIdLanguagesPS( uuidCaracteristica, aIdsLanguages ) CLASS SQLCaracteristicasLineasModel

   local cName
   local hNames   := {=>}

   if Len( aIdsLanguages ) == 0
      Return ( hNames )
   end if

   cName    := ::getNombreWhereUuid( uuidCaracteristica )

   if Empty( cName )
      Return ( hNames )
   end if

   aEval( aIdsLanguages, {|id| hSet( hNames, AllTrim( Str( id ) ), AllTrim( cName ) ) } )

RETURN ( hNames )

//---------------------------------------------------------------------------//

METHOD testCreateCaracteristicaLineaSinParent() CLASS SQLCaracteristicasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "nombre", "linea 1" )
   hset( hBuffer, "personalizado", "0" )
   hset( hBuffer, "parent_uuid",  )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateCaracteristicaLineaConParent( uuidParent ) CLASS SQLCaracteristicasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "nombre", "linea 1" )
   hset( hBuffer, "personalizado", "0" )
   hset( hBuffer, "parent_uuid", uuidParent )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateCaracteristicaLineaSinNombre( uuidParent ) CLASS SQLCaracteristicasLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "nombre",  )
   hset( hBuffer, "personalizado", "0" )
   hset( hBuffer, "parent_uuid", uuidParent )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateCaracteristicaLineaConUuidAndParent( uuid, uuidParent )

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid)
   hset( hBuffer, "nombre", "linea 1" )
   hset( hBuffer, "personalizado", "0" )
   hset( hBuffer, "parent_uuid", uuidParent )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD deleteBlank( uuidParent )

local cSql

   TEXT INTO cSql

   DELETE 

   FROM %1$s
      
   WHERE parent_uuid = %2$s AND nombre = ""

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(),quoted( uuidParent ) ) 

RETURN ( getSQLDatabase():Exec( cSql ) )

//---------------------------------------------------------------------------//

METHOD detectDuplicate( uuidParent )

local cSql

   TEXT INTO cSql

   SELECT 
      COUNT(*) AS recuento

   FROM %1$s AS articulos_caracteristicas_lineas

   WHERE articulos_caracteristicas_lineas.parent_uuid = %2$s
   
   GROUP BY nombre
   
   HAVING COUNT(*) > 1

   ORDER BY nombre

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidParent ) ) 
 
RETURN ( getSQLDatabase():getValue( cSql ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TestCaracteristicasLineasController FROM TestCase

   METHOD testCreateLineaSinPadre()

   METHOD testCreateLineaConPadre()

   METHOD testCreateLineaSinNombre()

END CLASS

//---------------------------------------------------------------------------//

METHOD testCreateLineaSinPadre() CLASS TestCaracteristicasLineasController

   local uuidParent  := win_uuidcreatestring()
   
   SQLCaracteristicasLineasModel():truncateTable()

   ::assert:notEquals( SQLCaracteristicasLineasModel():testCreateCaracteristicaLineaSinParent(), 1, "test create linea" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateLineaConPadre() CLASS TestCaracteristicasLineasController

   local uuidParent  := win_uuidcreatestring()
   
   SQLCaracteristicasModel():truncateTable() 
   SQLCaracteristicasLineasModel():truncateTable()
   
   ::assert:notEquals( SQLCaracteristicasModel():testCreateCaracteristica( uuidParent ), 0, "test create caracteristica" )

   ::assert:notEquals( SQLCaracteristicasLineasModel():testCreateCaracteristicaLineaConParent( uuidParent ), 0, "test create linea" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateLineaSinNombre() CLASS TestCaracteristicasLineasController

   local uuidParent  := win_uuidcreatestring()
   
   SQLCaracteristicasModel():truncateTable() 
   SQLCaracteristicasLineasModel():truncateTable()
   
   ::assert:notEquals( SQLCaracteristicasModel():testCreateCaracteristica( uuidParent ), 0, "test create caracteristica" )

   ::assert:notEquals( SQLCaracteristicasLineasModel():testCreateCaracteristicaLineaSinNombre( uuidParent ), 1, "test create linea" )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
