#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesDescuentosController FROM SQLBrowseController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD updateField( cField, uValue )

   METHOD validateNombre( uValue )

   METHOD validateDescuento( uValue )

   //Construcciones tardias----------------------------------------------------
   
   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := FacturasClientesDescuentosBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := FacturasClientesDescuentosView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := FacturasClientesDescuentosValidator():New( self ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := FacturasClientesDescuentosRepository():New( self ), ), ::oRepository )

   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel := SQLFacturasClientesDescuentosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasClientesDescuentosController

   ::Super:New( oController )

   ::cTitle                      := "Facturas clientes descuentos"

   ::cName                       := "facturas_clientes_descuentos"

   ::hImage                      := {  "16" => "gc_symbol_percent_16",;
                                       "32" => "gc_symbol_percent_32",;
                                       "48" => "gc_symbol_percent_48" }

   ::lTransactional              := .t.

   ::setEvent( 'exitAppended',   {|| ::getBrowseView():selectCol( ::getBrowseView():oColumnNombre:nPos ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasClientesDescuentosController

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

METHOD updateField( cField, uValue ) CLASS FacturasClientesDescuentosController

   ::getModel():updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), cField, uValue )
   
   ::getRowSet():Refresh()
   
   ::getBrowseView():Refresh()
   
   ::oController:calculateTotals() 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validateDescuento() CLASS FacturasClientesDescuentosController

   if empty( ::getRowSet:fieldGet( 'nombre' ) )
      msgstop( "Debes introducir un nombre valido para el descuento" )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validateNombre( oGet ) CLASS FacturasClientesDescuentosController

   local cNombre  := oGet:varGet()

   if empty( cNombre )
      msgstop( "Debes introducir un nombre valido para el descuento" )
      RETURN ( .f. )
   end if
 
   if !empty( ::getModel():CountNombreWhereFacturaUuid( cNombre ) )
      msgstop( "El nombre del descuento introducido ya existe" )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesDescuentosBrowseView FROM SQLBrowseView

   DATA lFastEdit          INIT .t.

   DATA lFooter            INIT .t.

   DATA nFreeze            INIT 1

   DATA nMarqueeStyle      INIT 3

   DATA oColumnNombre

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS FacturasClientesDescuentosBrowseView

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

   with object ( ::oBrowse:AddCol() )
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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesDescuentosView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS FacturasClientesDescuentosView

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

CLASS FacturasClientesDescuentosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FacturasClientesDescuentosValidator

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

CLASS SQLFacturasClientesDescuentosModel FROM SQLCompanyModel

   DATA cTableName               INIT "facturas_clientes_descuentos"

   DATA cConstraints             INIT "PRIMARY KEY ( nombre, deleted_at )"

   METHOD getColumns() 

   METHOD insertWhereClienteCodigo( cCodigoCliente )

   METHOD CountNombreWhereFacturaUuid( cNombre )

   METHOD testCreatel0PorCiento( uuid ) 

   METHOD testCreate20PorCiento( uuid ) 

   METHOD testCreate30PorCiento( uuid ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFacturasClientesDescuentosModel

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

METHOD insertWhereClienteCodigo( cCodigoCliente ) CLASS SQLFacturasClientesDescuentosModel

   local cSql

   TEXT INTO cSql

      INSERT IGNORE INTO %1$s 
         ( uuid, parent_uuid, nombre, descuento )

      SELECT 
         UUID(), %4$s, descuentos.nombre, descuentos.descuento

      FROM %2$s AS descuentos

      INNER JOIN %3$s AS clientes 
         ON clientes.codigo = %5$s    

      WHERE 
         descuentos.parent_uuid = clientes.uuid
         AND ( descuentos.fecha_fin IS NULL 
               OR descuentos.fecha_fin >= curdate() 
               ) 
         AND ( descuentos.fecha_inicio IS NULL
               OR descuentos.fecha_inicio <= curdate() )

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLDescuentosModel():getTableName(), SQLClientesModel():getTableName(), quoted( ::getControllerParentUuid() ), quoted( cCodigoCliente ) )

RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//

METHOD CountNombreWhereFacturaUuid( cNombre ) CLASS SQLFacturasClientesDescuentosModel

   local cSql

   TEXT INTO cSql

      SELECT COUNT( facturas_clientes_descuentos.nombre )

      FROM %1$s AS facturas_clientes_descuentos
      
      WHERE parent_uuid = %2$s
         AND facturas_clientes_descuentos.nombre = %3$s
         AND facturas_clientes_descuentos.deleted_at = 0

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( ::getControllerParentUuid() ), quoted( cNombre ) )

RETURN ( getSQLDatabase():getValue( cSql ) )

//---------------------------------------------------------------------------//

METHOD testCreatel0PorCiento( uuid ) CLASS SQLFacturasClientesDescuentosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "nombre", "Test 10" )
   hset( hBuffer, "descuento", 10 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreate20PorCiento( uuid ) CLASS SQLFacturasClientesDescuentosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "nombre", "Test 20" )
   hset( hBuffer, "descuento", 20 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreate30PorCiento( uuid ) CLASS SQLFacturasClientesDescuentosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "nombre", "Test 30" )
   hset( hBuffer, "descuento", 30 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FacturasClientesDescuentosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFacturasClientesDescuentosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//