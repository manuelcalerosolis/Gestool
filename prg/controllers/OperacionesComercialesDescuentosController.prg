#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionesComercialesDescuentosController FROM SQLBrowseController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD updateField( cField, uValue )

   METHOD validateNombre( uValue )

   METHOD validateDescuento( uValue )

   METHOD generateDiscount( hDiscount )

   //Construcciones tardias----------------------------------------------------
   
   METHOD getModel()                   VIRTUAL

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesDescuentosBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := OperacionesComercialesDescuentosView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := OperacionesComercialesDescuentosValidator():New( self ), ), ::oValidator )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := OperacionesComercialesDescuentosRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS OperacionesComercialesDescuentosController

   ::Super:New( oController )

   ::lTransactional                    := .t.

   ::setEvent( 'exitAppended', {|| ::getBrowseView():selectCol( ::getBrowseView():oColumnNombre:nPos ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS OperacionesComercialesDescuentosController

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

METHOD updateField( cField, uValue ) CLASS OperacionesComercialesDescuentosController

   ::getModel():updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), cField, uValue )
   
   ::getRowSet():Refresh()
   
   ::getBrowseView():Refresh()
   
   ::oController:calculateTotals() 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validateDescuento() CLASS OperacionesComercialesDescuentosController

   if empty( ::getRowSet:fieldGet( 'nombre' ) )
      msgstop( "Debes introducir un nombre válido para el descuento" )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validateNombre( oGet ) CLASS OperacionesComercialesDescuentosController

   local cNombre  := oGet:varGet()

   if empty( cNombre )
      msgstop( "Debes introducir un nombre valido para el descuento" )
      RETURN ( .f. )
   end if
 
   if !empty( ::getModel():countNombreWhereOperacionUuid( cNombre ) )
      msgstop( "El nombre del descuento introducido ya existe" )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD generateDiscount( hDiscount ) CLASS OperacionesComercialesDescuentosController
   
   local nId

   nId      := ::getModel():insertBlankBuffer( hDiscount ) 

   if !empty( nId )
      RETURN ( ::getModelBuffer( "uuid" ) )
   end if 
 
RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS OperacionesComercialesDescuentosBrowseView FROM SQLBrowseView

   DATA lFastEdit          INIT .t.

   DATA lFooter            INIT .t.

   DATA nFreeze            INIT 1

   DATA nMarqueeStyle      INIT 3

   DATA oColumnNombre

   DATA oColumnDescuento

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS OperacionesComercialesDescuentosBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oColumnNombre := ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 130
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nEditType           := EDIT_GET
      :bEditValid          := {| oGet, oCol | ::oController:validateNombre( oGet ) }
      :bOnPostEdit         := {| oCol, uNewValue | ::oController:updateField( 'nombre', uNewValue ) }
   end with

   with object ( ::oColumnDescuento := ::oBrowse:AddCol() )
      :cSortOrder          := 'descuento'
      :cHeader             := 'Descuento %'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descuento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nFootStyle          := :nDataStrAlign               
      :nFooterType         := AGGR_SUM
      :cEditPicture        := "@E 999.9999"
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := oFontBold()
      :cDataType           := "N"
      :nEditType           := EDIT_GET
      :bEditValid          := {|| ::oController:validateDescuento() }
      :bOnPostEdit         := {| oCol, uNewValue | ::oController:updateField( 'descuento', uNewValue ) }
   end with

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS OperacionesComercialesDescuentosView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS OperacionesComercialesDescuentosView

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
      FONT        oFontBold() ;
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

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS OperacionesComercialesDescuentosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS OperacionesComercialesDescuentosValidator

   ::hValidators  := {  "descuento" => {  "required"  => "El porcentaje de descuento es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLOperacionesComercialesDescuentosModel FROM SQLCompanyModel

   DATA cConstraints             INIT "PRIMARY KEY ( nombre, deleted_at, parent_uuid )"

   METHOD getColumns() 

   METHOD insertWhereTerceroCodigo( cCodigoTercero )

   METHOD countNombreWhereOperacionUuid( cNombre )

   METHOD getSentenceDescuentosWhereUuid( uuidOperacionComercial, importeBruto ) 

   METHOD selectDescuentosWhereUuid( uuidOperacionComercial, importeBruto ) 

   METHOD getHashWhereUuid( uuidOrigen )

#ifdef __TEST__   

   METHOD test_create_l0_por_ciento( uuid ) 

   METHOD test_create_20_por_ciento( uuid ) 

   METHOD test_create_30_por_ciento( uuid ) 

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLOperacionesComercialesDescuentosModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",    {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| ::getControllerParentUuid() } }       )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR( 200 ) NOT NULL"                 ,;
                                          "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "descuento",      {  "create"    => "FLOAT( 7, 4 )"                           ,;
                                          "default"   => {|| 0 } }                                 )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD insertWhereTerceroCodigo( cCodigoTercero ) CLASS SQLOperacionesComercialesDescuentosModel

   local cSql

   TEXT INTO cSql

   INSERT IGNORE INTO %1$s 
      ( uuid, parent_uuid, nombre, descuento )

   SELECT 
      UUID(), %4$s, descuentos.nombre, descuentos.descuento

   FROM %2$s AS descuentos

   INNER JOIN %3$s AS terceros 
      ON terceros.codigo = %5$s    

   WHERE 
      descuentos.parent_uuid = terceros.uuid
      AND ( descuentos.fecha_fin IS NULL 
            OR descuentos.fecha_fin >= curdate() 
            ) 
      AND ( descuentos.fecha_inicio IS NULL
            OR descuentos.fecha_inicio <= curdate() )

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLDescuentosModel():getTableName(), SQLTercerosModel():getTableName(), quoted( ::getControllerParentUuid() ), quoted( cCodigoTercero ) )

RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//

METHOD countNombreWhereOperacionUuid( cNombre ) CLASS SQLOperacionesComercialesDescuentosModel

   local cSql

   TEXT INTO cSql

   SELECT 
      COUNT( operaciones_comeciales_descuentos.nombre )

      FROM %1$s AS operaciones_comeciales_descuentos
      
      WHERE parent_uuid = %2$s
         AND operaciones_comeciales_descuentos.nombre = %3$s
         AND operaciones_comeciales_descuentos.deleted_at = 0

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( ::getControllerParentUuid() ), quoted( cNombre ) )

RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//

METHOD getSentenceDescuentosWhereUuid( uuidOperacionComercial, importeBruto ) CLASS SQLOperacionesComercialesDescuentosModel 

   local cSql
 
   TEXT INTO cSql

   SELECT 
      operaciones_comeciales_descuentos.nombre AS nombre_descuento,
      operaciones_comeciales_descuentos.descuento AS porcentaje_descuento, 
      ROUND( operaciones_comeciales_descuentos.descuento * %3$s / 100, 2 ) AS importe_descuento

      FROM %1$s AS operaciones_comeciales_descuentos 
   
      WHERE operaciones_comeciales_descuentos.parent_uuid = %2$s 
         AND operaciones_comeciales_descuentos.deleted_at = 0; 

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidOperacionComercial ), toSqlString( importeBruto ) )

RETURN ( alltrim( cSql ) )

//---------------------------------------------------------------------------//

METHOD selectDescuentosWhereUuid( uuidOperacionComercial, importeBruto ) CLASS SQLOperacionesComercialesDescuentosModel

RETURN ( ::getDatabase():selectTrimedFetchHash( ::getSentenceDescuentosWhereUuid( uuidOperacionComercial, importeBruto ) ) )

//---------------------------------------------------------------------------//

METHOD getHashWhereUuid( uuidOrigen ) CLASS SQLOperacionesComercialesDescuentosModel

   local cSql

   TEXT INTO cSql

      SELECT 
         *  
      FROM %1$s

      WHERE parent_uuid = %2$s AND deleted_at = 0
       
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName(), quoted( uuidOrigen ) )

RETURN ( ::getDatabase():selectTrimedFetchHash( cSql ) ) 

//---------------------------------------------------------------------------//

#ifdef __TEST__   

METHOD test_create_l0_por_ciento( uuid ) CLASS SQLOperacionesComercialesDescuentosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "nombre", "Test 10" )
   hset( hBuffer, "descuento", 10 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_20_por_ciento( uuid ) CLASS SQLOperacionesComercialesDescuentosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "nombre", "Test 20" )
   hset( hBuffer, "descuento", 20 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_30_por_ciento( uuid ) CLASS SQLOperacionesComercialesDescuentosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "nombre", "Test 30" )
   hset( hBuffer, "descuento", 30 )

RETURN ( ::insertBuffer( hBuffer ) )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS OperacionesComercialesDescuentosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLOperacionesComercialesDescuentosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//