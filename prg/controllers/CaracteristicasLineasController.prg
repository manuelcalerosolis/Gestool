#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CaracteristicasLineasController FROM SQLBrowseController

   METHOD New()

   METHOD End()

    //Contrucciones tardias---------------------------------------------------//

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := CaracteristicasLineasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := CaracteristicasLineasView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := CaracteristicasLineasValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()                   INLINE( if( empty( ::oModel ), ::oModel := SQLCaracteristicasLineasModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CaracteristicasLineasController

   ::Super:New( oController )

   ::cTitle                      := "Características lineas"

   ::cName                       := "articulos_caracteristicas_lineas" 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CaracteristicasLineasController
   
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
   
   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CaracteristicasLineasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CaracteristicasLineasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 60
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
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
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CaracteristicasLineasView FROM SQLBaseView

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS CaracteristicasLineasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CARACTERISTICAS_LINEAS" ;
      TITLE       ::LblTitle() + "lineas de caracterísicas"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_tags_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Lineas de características" ;
      ID          800 ;
      FONT        oFontBold() ; 
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   // Botones PropiedadesLineas -------------------------------------------------------

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
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   else
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   end if

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CaracteristicasLineasValidator FROM SQLParentValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CaracteristicasLineasValidator

   ::hValidators  := {  "nombre" =>    {  "required"  => "El nombre es un dato requerido",;
                                          "unique"    => "El nombre introducido ya existe" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCaracteristicasLineasModel FROM SQLCompanyModel

   DATA cTableName                        INIT "articulos_caracteristicas_lineas"

   METHOD getColumns()

   METHOD getNombreWhereUuid( uuid )      INLINE ( ::getField( 'nombre', 'uuid', uuid ) )

   METHOD getArrayNombreValoresFromUuid( uuid )

   METHOD getNamesFromIdLanguagesPS( uuidCaracteristica, aIdsLanguages )

   METHOD testCreateCaracteristicaLineaSinParent( uuidParent )

   METHOD testCreateCaracteristicaLineaConParent( uuidParent )

   METHOD testCreateCaracteristicaLineaSinNombre( uuidParent )

   METHOD testCreateCaracteristicaLineaConUuidAndParent( uuid, uuidParent )


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
