#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UnidadesMedicionOperacionesController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS UnidadesMedicionOperacionesController

   ::Super:New( oSenderController )

   ::cTitle                         := "Unidades operacion"

   ::cName                          := "unidades_medicion_operacion"

   ::lTransactional                 := .t.

   ::hImage                         := {  "16" => "gc_tape_measure2_16",;
                                          "32" => "gc_tape_measure2_32",;
                                          "48" => "gc_tape_measure2_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLUnidadesMedicionOperacionesModel():New( self )

   ::oBrowseView                    := UnidadesMedicionOperacionesBrowseView():New( self )

   ::oDialogView                    := UnidadesMedicionOperacionesView():New( self )

   ::oValidator                     := UnidadesMedicionOperacionesValidator():New( self, ::oDialogView )

   ::oRepository                    := UnidadesMedicionOperacionesRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS UnidadesMedicionOperacionesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oGetSelector:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionOperacionesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS UnidadesMedicionOperacionesBrowseView

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
      :cSortOrder          := 'operacion'
      :cHeader             := 'Operación'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'operacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_medicion_codigo'
      :cHeader             := 'Código unidad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_medicion_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_medicion_nombre'
      :cHeader             := 'Nombre unidad'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_medicion_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionOperacionesView FROM SQLBaseView

   DATA oUnidades

   DATA hUnidades

   DATA oTipo

   DATA aTiposOperaciones  INIT ( {  "Compras", "Venta", "Inventarios" } )

   METHOD Activate()

   METHOD Activating()     INLINE ( ::hUnidades := ::oController:oModel:getUnidadesWhereGrupo( ::oController:oSenderController:getModelBuffer( 'unidades_medicion_grupos_codigo' ) ) ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UnidadesMedicionOperacionesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "UNIDAD_MEDICION_OPERACION" ;
      TITLE       ::LblTitle() + "unidad de operaciones"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;
   
   REDEFINE COMBOBOX ::oUnidades ;
      VAR         ::oController:oModel:hBuffer[ "uuid_unidad" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "uuid_unidad" ) ) ;
      ITEMS       ( ::hUnidades ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:oModel:hBuffer[ "operacion" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "operacion" ) ) ;
      ITEMS       ( ::aTiposOperaciones ) ;
      OF          ::oDialog ;

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

CLASS UnidadesMedicionOperacionesValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS UnidadesMedicionOperacionesValidator

   ::hValidators  := {  "uuid_unidad " => {  "required"  => "La unidad es un dato requerido" },;
                        "operacion" =>    {  "required"  => "La operación es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLUnidadesMedicionOperacionesModel FROM SQLCompanyModel

   DATA cTableName               INIT "unidades_medicion_operacion"

   DATA cConstraints             INIT "PRIMARY KEY ( parent_uuid, uuid_unidad, operacion )"

   DATA aConsulta                INIT {}

   METHOD sqlUnidadesWhereGrupo( cCodigoGrupo )

   METHOD getUnidadesWhereGrupo( cCodigoGrupo )

   METHOD setUuidUnidadAttribute( value ) ;
                                 INLINE ( SQLUnidadesMedicionModel():getUuidWhereColumn( Value, "nombre" ) )

   METHOD getUuidUnidadAttribute( uuid ) ;
                                 INLINE ( SQLUnidadesMedicionModel():getColumnWhereUuid( uuid, "nombre" ) )

   METHOD getInitialSelect() 

   METHOD getUnidadVentaWhereArticulo( cCodigoArticulo )

   METHOD getUnidad() 

   METHOD getNumeroOperacionesWhereArticulo( cCodigoArticulo )                            

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUnidadesMedicionOperacionesModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                          "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
                                          "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",    {  "create"    => "VARCHAR( 40 ) NOT NULL"                     ,;
                                          "default"   => {|| ::getSenderControllerParentUuid() } }    )

   hset( ::hColumns, "uuid_unidad",    {  "create"    => "VARCHAR( 40 )"                              ,;
                                          "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "operacion",      {  "create"    => "VARCHAR( 200 )"                             ,;
                                          "default"   => {|| space( 200 ) } }                         )
   
   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD sqlUnidadesWhereGrupo( cCodigoGrupo ) CLASS SQLUnidadesMedicionOperacionesModel

   local cSQL

   TEXT INTO cSql

      SELECT 

         unidades_medicion.*     
      
      FROM %1$s AS unidades_medicion_grupos                                               

      INNER JOIN %2$s AS unidades_medicion_grupos_lineas         
         ON unidades_medicion_grupos.uuid = unidades_medicion_grupos_lineas.parent_uuid                             

      INNER JOIN %3$s AS unidades_medicion         
         ON unidades_medicion.codigo = unidades_medicion_grupos_lineas.unidad_alternativa_codigo

      WHERE 
         unidades_medicion_grupos.codigo = %4$s 

   ENDTEXT


   cSql  := hb_strformat( cSql, SQLUnidadesMedicionGruposModel():getTableName(), SQLUnidadesMedicionGruposLineasModel():getTableName(),SQLUnidadesMedicionModel():getTableName() , quoted( cCodigoGrupo ) ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getUnidadesWhereGrupo( cCodigoGrupo ) CLASS SQLUnidadesMedicionOperacionesModel

   local aUnidades   := {}

   if empty( cCodigoGrupo )
      RETURN ( aUnidades )
   end if 

   ::aConsulta       := getSQLDatabase():selectTrimedFetchHash( SQLUnidadesMedicionOperacionesModel():sqlUnidadesWhereGrupo( cCodigoGrupo ) )  

   aeval( ::aConsulta, {| h | aadd( aUnidades, h[ "nombre" ] ) } )

RETURN ( aUnidades )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLUnidadesMedicionOperacionesModel

   local cSQL

   TEXT INTO cSql

      SELECT 
         unidades_medicion_operacion.id as id,
         unidades_medicion_operacion.uuid as uuid,     
         unidades_medicion_operacion.operacion as operacion,
         unidades_medicion.codigo as unidad_medicion_codigo,
         unidades_medicion.nombre as unidad_medicion_nombre
      
      FROM %1$s AS unidades_medicion_operacion
      
      INNER JOIN %2$s AS unidades_medicion
         ON unidades_medicion_operacion.uuid_unidad = unidades_medicion.uuid

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLUnidadesMedicionModel():getTableName() ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getUnidadVentaWhereArticulo( cCodigoArticulo ) CLASS SQLUnidadesMedicionOperacionesModel
   
   local cSQL
   local cUnidad

   TEXT INTO cSql

   SELECT 
      unidades_medicion.codigo

      FROM  %1$s AS unidades_medicion_operacion

      INNER JOIN %2$s AS articulos
         ON articulos.uuid = unidades_medicion_operacion.parent_uuid AND articulos.codigo= %4$s 
 
      INNER JOIN %3$s AS unidades_medicion
         ON unidades_medicion.uuid = unidades_medicion_operacion.uuid_unidad

      WHERE unidades_medicion_operacion.operacion = "Venta"

   ENDTEXT

   cSql        := hb_strformat( cSql, ::getTableName(), SQLArticulosModel():getTableName(), SQLUnidadesMedicionModel():getTableName(), cCodigoArticulo )

   cUnidad     := getSQLDatabase():getValue ( cSql )

RETURN ( cUnidad )

//---------------------------------------------------------------------------//

METHOD getUnidad() CLASS SQLUnidadesMedicionOperacionesModel

   local cSql

   TEXT INTO cSql

      SELECT 
         unidades_medicion.codigo

      FROM %1$s AS unidades_medicion

         WHERE unidades_medicion.sistema = 1

   ENDTEXT

   cSql  := hb_strformat( cSql, SQLUnidadesMedicionModel():getTableName() )

RETURN( getSQLDatabase():getValue( cSql ) )

//---------------------------------------------------------------------------//

METHOD getNumeroOperacionesWhereArticulo( cCodigoArticulo ) CLASS SQLUnidadesMedicionOperacionesModel

   local cSql

   TEXT INTO cSql

      SELECT 
         COUNT(*) 

      FROM %1$s AS unidades_medicion_operacion

      INNER JOIN %2$s AS articulos
         ON unidades_medicion_operacion.parent_uuid = articulos.uuid AND articulos.codigo = %3$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLArticulosModel():getTableName(), quoted( cCodigoArticulo ) )

RETURN ( getSQLDatabase():getValue( cSql ) )
   
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionOperacionesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLUnidadesMedicionOperacionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
