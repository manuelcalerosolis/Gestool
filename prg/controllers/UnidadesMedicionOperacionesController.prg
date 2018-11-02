#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UnidadesMedicionOperacionesController FROM SQLNavigatorController

   DATA hUnidades

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()           INLINE( if( empty( ::oBrowseView ), ::oBrowseView := UnidadesMedicionOperacionesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()           INLINE( if( empty( ::oDialogView ), ::oDialogView := UnidadesMedicionOperacionesView():New( self ), ), ::oDialogView )

   METHOD getValidator()            INLINE( if( empty( ::oValidator ), ::oValidator := UnidadesMedicionOperacionesValidator():New( self  ), ), ::oValidator )

   METHOD getRepository()           INLINE ( if( empty( ::oRepository ), ::oRepository := UnidadesMedicionOperacionesRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                INLINE ( if( empty( ::oModel ), ::oModel := SQLUnidadesMedicionOperacionesModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS UnidadesMedicionOperacionesController

   ::Super:New( oController )

   ::cTitle                         := "Unidades operación"

   ::cName                          := "unidades_medicion_operacion"

   ::lTransactional                 := .t.

   ::hImage                         := {  "16" => "gc_tape_measure2_16",;
                                          "32" => "gc_tape_measure2_32",;
                                          "48" => "gc_tape_measure2_48" }

   ::nLevel                         := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS UnidadesMedicionOperacionesController

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

CLASS UnidadesMedicionOperacionesView FROM SQLBaseView

   DATA oComboTipoOperaciones

   DATA aTiposOperaciones  INIT ( {  "Compras", "Ventas", "Inventarios" } )

   METHOD Activate()

   METHOD Activating()

   METHOD startActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UnidadesMedicionOperacionesView

   DEFINE DIALOG     ::oDialog ;
      RESOURCE       "UNIDAD_MEDICION_OPERACION" ;
      TITLE          ::LblTitle() + "unidad de operaciones"

      REDEFINE BITMAP ::oBitmap ;
         ID          900 ;
         RESOURCE    ::oController:getimage( "48" )  ;
         TRANSPARENT ;
         OF          ::oDialog ;

      REDEFINE SAY   ::oMessage ;
         ID          800 ;
         FONT        oFontBold() ;
         OF          ::oDialog ;
      
      REDEFINE COMBOBOX ::oComboTipoOperaciones ;
         VAR         ::oController:getModel():hBuffer[ "operacion" ] ;
         ID          100 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         VALID       ( ::oController:validate( "operacion" ) ) ;
         ITEMS       ( ::aTiposOperaciones ) ;
         OF          ::oDialog ;

      ::oController:getUnidadesMedicionController():getSelector():Bind( bSETGET( ::oController:getModel():hBuffer[ "unidad_medicion_codigo" ] ) )
      ::oController:getUnidadesMedicionController():getSelector():Build( { "idGet" => 110, "idText" => 111, "idLink" => 112, "oDialog" => ::oDialog } )
      ::oController:getUnidadesMedicionController():getSelector():bValid  := {|| ::oController:validate( "unidad_medicion_codigo" ) }

      apoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

      apoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

      if ::oController:isNotZoomMode() 
         ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
      end if

      ::oDialog:bStart        := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD Activating() CLASS UnidadesMedicionOperacionesView

   ::oController:hUnidades    := ::oController:getModel():getUnidadesWhereGrupo( ::oController:oController:getModelBuffer( 'unidades_medicion_grupos_codigo' ) ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS UnidadesMedicionOperacionesView

   SendMessage( ::oComboTipoOperaciones:hWnd, 0x0153, -1, 14 )

   ::oController:getUnidadesMedicioncontroller():getSelector():Start()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionOperacionesValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD inUnidades( cCodigoUnidad )

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS UnidadesMedicionOperacionesValidator

   ::hValidators  := {  "unidad_medicion_codigo"   => {  "required"     => "La unidad es un dato requerido",;
                                                         "inUnidades"   => "La unidad de medicón no esta dentro del grupo de unidades" },;
                        "operacion"                => {  "required"     => "La operación es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD inUnidades( cCodigoUnidad ) CLASS UnidadesMedicionOperacionesValidator

   local cCodigoGrupo  := ::oController:oController:getModelBuffer( 'unidades_medicion_grupos_codigo' )

   if empty( cCodigoGrupo )
      RETURN ( .f. )
   end if 

RETURN ( SQLUnidadesMedicionGruposModel():countUnidadesWhereUnidadAndGrupo( cCodigoUnidad, cCodigoGrupo ) > 0 )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLUnidadesMedicionOperacionesModel FROM SQLCompanyModel

   DATA cTableName               INIT "unidades_medicion_operacion"

   DATA cConstraints             INIT "PRIMARY KEY ( parent_uuid, operacion, unidad_medicion_codigo )"

   DATA aConsulta                INIT {}

   METHOD getSentenceUnidadesWhereGrupo( cCodigoGrupo )

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

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                   "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                     ,;
                                                   "default"   => {|| ::getControllerParentUuid() } }          )

   hset( ::hColumns, "unidad_medicion_codigo",  {  "create"    => "VARCHAR( 20 )"                              ,;
                                                   "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "operacion",               {  "create"    => "VARCHAR( 200 )"                             ,;
                                                   "default"   => {|| space( 200 ) } }                         )
   
   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getSentenceUnidadesWhereGrupo( cCodigoGrupo ) CLASS SQLUnidadesMedicionOperacionesModel

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

   cSql  := hb_strformat( cSql, SQLUnidadesMedicionGruposModel():getTableName(), SQLUnidadesMedicionGruposLineasModel():getTableName(), SQLUnidadesMedicionModel():getTableName() , quoted( cCodigoGrupo ) ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getUnidadesWhereGrupo( cCodigoGrupo ) CLASS SQLUnidadesMedicionOperacionesModel

   local aUnidades   := {}

   if empty( cCodigoGrupo )
      RETURN ( aUnidades )
   end if 

   ::aConsulta       := getSQLDatabase():selectTrimedFetchHash( ::getSentenceUnidadesWhereGrupo( cCodigoGrupo ) )  

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
         unidades_medicion_operacion.unidad_medicion_codigo as unidad_medicion_codigo,
         unidades_medicion.nombre as unidad_medicion_nombre
      
      FROM %1$s AS unidades_medicion_operacion
      
      INNER JOIN %2$s AS unidades_medicion
         ON unidades_medicion_operacion.unidad_medicion_codigo = unidades_medicion.codigo

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

RETURN ( getSQLDatabase():getValue( cSql, 0 ) )
   
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionOperacionesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLUnidadesMedicionOperacionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
