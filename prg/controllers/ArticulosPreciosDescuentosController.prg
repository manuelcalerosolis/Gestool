#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosPreciosDescuentosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD gettingSelectSentence()

   METHOD End()

   METHOD activatingDialogModalView()

   METHOD getBrowseView()           INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := ArticulosPreciosDescuentosBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()           INLINE ( if( empty( ::oDialogView ), ::oDialogView := ArticulosPreciosDescuentosView():New( self ), ), ::oDialogView )

   METHOD getValidator ()           INLINE ( if( empty( ::oValidator ), ::oValidator := ArticulosPreciosDescuentosValidator():New( self ), ), ::oValidator )

   METHOD getRepository()           INLINE ( if( empty( ::oRepository ), ::oRepository := ArticulosPreciosDescuentosRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                INLINE ( if( empty( ::oModel ), ::oModel := SQLArticulosPreciosDescuentosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosPreciosDescuentosController

   ::Super:New( oController )

   ::cTitle                         := "Descuentos artículos" 

   ::cName                          := "descuentos_articulos"

   ::hImage                         := {  "16" => "gc_symbol_percent_16",;
                                          "32" => "gc_symbol_percent_32",;
                                          "48" => "gc_symbol_percent_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

   ::getDialogModalView():setEvent( 'activating', {|| ::activatingDialogModalView() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosPreciosDescuentosController

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

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD activatingDialogModalView()

   local cTitle 

   cTitle   := "Descuentos artículo : " + alltrim( ::oController:oController:getModelBuffer( "codigo" ) )
   
   cTitle   += " - "

   cTitle   += alltrim( ::oController:oController:getModelBuffer( "nombre" ) )

   cTitle   += ", "

   cTitle   += "sobre tarifa : " + ::oController:getRowSet():fieldGet( 'articulos_tarifas_nombre' )

   ::oDialogModalView:setTitle( cTitle )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS ArticulosPreciosDescuentosController

   local uuid        := ::getController():getUuid() 

   if !empty( uuid )
      ::getModel():setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosDescuentosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosPreciosDescuentosBrowseView

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
      :cSortOrder          := 'porcentaje'
      :cHeader             := '% Descuento'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'porcentaje' ) }
      :cEditPicture        := "@E 999.9999"
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidades'
      :cHeader             := 'Unidades'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidades' ) }
      :cEditPicture        := "@E 999,999.999999"
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_inicio'
      :cHeader             := 'Fecha inicio'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_inicio' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_fin'
      :cHeader             := 'Fecha fin'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_fin' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosDescuentosView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosPreciosDescuentosView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ARTICULOS_PRECIOS_DESCUENTOS" ;
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

   REDEFINE GET   ::oController:oModel:hBuffer[ "porcentaje" ] ;
      ID          100 ;
      SPINNER ;
      PICTURE     "@E 999.9999" ;
      VALID       ( ::oController:validate( "porcentaje" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_inicio" ] ;
      ID          110 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_fin" ] ;
      ID          120 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "unidades" ] ;
      ID          130 ;
      SPINNER ;
      PICTURE     "@E 999,999.999999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
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

CLASS ArticulosPreciosDescuentosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosPreciosDescuentosValidator

   ::hValidators  := {  "porcentaje" =>           {  "required"              => "El porcentaje de descuento es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosPreciosDescuentosModel FROM SQLCompanyModel

   DATA cTableName               INIT "articulos_precios_descuentos"

   DATA cConstraints             INIT "PRIMARY KEY ( porcentaje, unidades, fecha_inicio ), FOREIGN KEY ( parent_uuid ) REFERENCES " + SQLArticulosPreciosModel():getTableName() + " ( uuid ) ON DELETE CASCADE"

   METHOD getColumns()

   METHOD getIdWhereParentUuid( uuid ) ;
                                 INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD getParentUuidAttribute( value )

   METHOD sqlDescuentoWhereArticuloUuid( uuidArticulo, cCodigoTarifa, nUnidades, dFechaVenta )

   METHOD getDescuentoWhereArticuloUuid( uuidArticulo, cCodigoTarifa, nUnidades, dFechaVenta ) ;
                                 INLINE ( getSQLDatabase():getValue( ::sqlDescuentoWhereArticuloUuid( uuidArticulo, cCodigoTarifa, nUnidades, dFechaVenta ) ) )

   METHOD sqlDescuentoWhereArticuloCodigo( cCodigoArticulo, cCodigoTarifa, nUnidades, dFechaVenta )

   METHOD getDescuentoWhereArticuloCodigo( cCodigoArticulo, cCodigoTarifa, nUnidades, dFechaVenta ) ;
                                 INLINE ( getSQLDatabase():getValue( ::sqlDescuentoWhereArticuloCodigo( cCodigoArticulo, cCodigoTarifa, nUnidades, dFechaVenta ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosPreciosDescuentosModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                   "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "fecha_inicio",            {  "create"    => "DATE"                                    ,;
                                                   "default"   => {|| getSysDate() } }                      )

   hset( ::hColumns, "fecha_fin",               {  "create"    => "DATE"                                    ,;
                                                   "default"   => {|| ctod( "" ) } }                        )

   hset( ::hColumns, "porcentaje",              {  "create"    => "FLOAT( 7, 4 )"                           ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "unidades",                {  "create"    => "FLOAT( 16, 6 )"                          ,;
                                                   "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getParentUuidAttribute( value ) CLASS SQLArticulosPreciosDescuentosModel

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oController )
      RETURN ( value )
   end if

RETURN ( ::oController:oController:getUuid() )

//---------------------------------------------------------------------------//

METHOD sqlDescuentoWhereArticuloUuid( uuidArticulo, cCodigoTarifa, nUnidades, dFechaVenta ) CLASS SQLArticulosPreciosDescuentosModel
   
   local cSql

   cSql  := "SELECT articulos_precios_descuentos.porcentaje as porcentaje "                                                                                                                                
   cSql  +=    "FROM "+ ::getTableName() + " AS articulos_precios_descuentos " 

   cSql  +=    "INNER JOIN "+ SQLArticulosPreciosModel():getTableName() +" as articulos_precios "                                                                  
   cSql  +=       "ON articulos_precios_descuentos.parent_uuid = articulos_precios.uuid "

   cSql  +=    "INNER JOIN " + SQLArticulosModel():getTableName() + " as articulos "                                                                  
   cSql  +=       "ON articulos_precios.articulo_uuid = " + quoted( uuidArticulo ) + " " 

   cSql  +=    "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " as articulos_tarifas "                                                                  
   cSql  +=       "ON articulos_tarifas.codigo = " + quoted( cCodigoTarifa ) + " "

   cSql  +=    "WHERE articulos_precios_descuentos.fecha_inicio <= " + toSqlString( dFechaVenta ) + " "                                                                  
   cSql  +=       "AND ( articulos_precios_descuentos.fecha_fin IS NULL OR articulos_precios_descuentos.fecha_fin >= " + toSqlString( dFechaVenta ) + " ) "                                                                  
   cSql  +=       "AND articulos_precios_descuentos.unidades <= " + quoted( nUnidades ) + " "                                                                  
   cSql  +=       "AND articulos_precios.uuid = articulos_precios_descuentos.parent_uuid "                                                                  

   cSql  +=    "ORDER BY articulos_precios_descuentos.porcentaje DESC " 

   cSql  +=    "LIMIT 1 "

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD sqlDescuentoWhereArticuloCodigo( cCodigoArticulo, cCodigoTarifa, nUnidades, dFechaVenta ) CLASS SQLArticulosPreciosDescuentosModel
   
   local cSql

   TEXT INTO cSql

   SELECT articulos_precios_descuentos.porcentaje AS porcentaje
      FROM %1$s AS articulos_precios_descuentos 

      INNER JOIN %2$s AS articulos
         ON articulos.codigo = %5$s 

      INNER JOIN %3$s AS articulos_precios
         ON articulos_precios_descuentos.parent_uuid = articulos_precios.uuid

      INNER JOIN %4$s AS articulos_tarifas 
         ON articulos_tarifas.codigo = %6$s

      WHERE articulos_precios_descuentos.fecha_inicio <= %8$s
         AND ( articulos_precios_descuentos.fecha_fin IS NULL OR articulos_precios_descuentos.fecha_fin >= %8$s )
         AND articulos_precios_descuentos.unidades <= %7$s
         AND articulos_precios.uuid = articulos_precios_descuentos.parent_uuid 
         AND articulos_precios.tarifa_uuid = articulos_tarifas.uuid

      ORDER BY articulos_precios_descuentos.porcentaje DESC
         LIMIT 1 

   ENDTEXT 

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           SQLArticulosModel():getTableName(),;
                           SQLArticulosPreciosModel():getTableName(),;
                           SQLArticulosTarifasModel():getTableName(),;
                           quoted( cCodigoArticulo ),;
                           quoted( cCodigoTarifa ),;
                           quoted( nUnidades ),;
                           toSqlString( dFechaVenta ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosDescuentosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosPreciosDescuentosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//