#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLArticulosPreciosModel FROM SQLCompanyModel

   DATA cTableName                     INIT "articulos_precios"

   DATA cConstraints                   INIT "PRIMARY KEY ( id ), UNIQUE KEY ( articulo_uuid, tarifa_uuid )"

   METHOD getColumns()

   METHOD addParentUuidWhere( cSQLSelect )    

   METHOD isParentUuidColumn()         INLINE ( hb_hhaskey( ::hColumns, "articulo_uuid" ) )

   METHOD getInitialSelect()

   METHOD getPrecioSobre( nPrecioCosto )

   METHOD getPrecioBase( nPrecioCosto ) ;
                                       INLINE ( "( " + ::getPrecioSobre( nPrecioCosto ) + " * articulos_tarifas.margen / 100 ) + " + ::getPrecioSobre( nPrecioCosto ) )

   METHOD getPrecioIVA( nPrecioCosto ) ;
                                       INLINE ( "( " + ::getPrecioBase( nPrecioCosto ) + " * tipos_iva.porcentaje / 100 ) + " + ::getPrecioBase( nPrecioCosto ) )

   METHOD getInnerJoinArticulosTarifas( uuidTarifa ) INLINE ;
                                       (  "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas " + CRLF + ;
                                             "ON articulos_tarifas.uuid = " + quoted( uuidTarifa ) + " " + CRLF )

   METHOD getInnerJoinTiposIva()       INLINE ;
                                       (  "LEFT JOIN " + SQLTiposIvaModel():getTableName() + " AS tipos_iva " + CRLF + ;
                                             "ON tipos_iva.codigo = articulos.tipo_iva_codigo " + CRLF )

   METHOD getSQLDeletePrecioWhereUuidTarifa( uuidTarifa )

   METHOD deletePrecioWhereUuidTarifa( uuidTarifa ) ;
                                       INLINE ( ::getDatabase():Exec( ::getSQLDeletePrecioWhereUuidTarifa( uuidTarifa ) ) )

   METHOD getSQLInsertPrecioWhereTarifa( uuidTarifa )

   METHOD insertPrecioWhereTarifa( uuidTarifa ) ;
                                       INLINE ( ::getDatabase():Exec( ::getSQLInsertPrecioWhereTarifa( uuidTarifa ) ) )

   METHOD getSQLUpdatePrecioWhereTarifa( uuidTarifa )

   METHOD updatePrecioWhereTarifa( uuidTarifa ) ;
                                       INLINE ( ::getDatabase():Exec( ::getSQLUpdatePrecioWhereTarifa( uuidTarifa ) ) )

   METHOD updatePrecioWhereArticulo( uuidArticulo ) ;
                                       INLINE ( ::getDatabase():Exec( ::getSQLUpdatePrecioWhereArticulo( uuidArticulo ) ) )

   METHOD getSQLUpdatePrecioWhereArticulo( uuidArticulo ) 

   METHOD insertUpdatePrecioWhereTarifa( uuidTarifa, lCosto ) ;
                                       INLINE ( ::getDatabase():Exec( ::getSQLInsertPrecioWhereTarifa( uuidTarifa, lCosto ) ),;
                                                ::getDatabase():Exec( ::getSQLUpdatePrecioWhereTarifa( uuidTarifa ) ) )

   METHOD updatePrecioWhereTarifaAndArticulo( idPrecio, nPrecioCosto ) ;
                                       INLINE ( ::getDatabase():Exec( ::getSQLUpdatePrecioWhereTarifaAndArticulo( idPrecio, nPrecioCosto ) ) )

   METHOD getSQLUpdatePrecioWhereTarifaAndArticulo( idPrecio, nPrecioCosto )

   METHOD getSQLInsertPreciosWhereTarifa( codigoTarifa )

   METHOD insertPreciosWhereTarifa( codigoTarifa ) ;
                                       INLINE ( ::getDatabase():Execs( ::getSQLInsertPreciosWhereTarifa( codigoTarifa ) ) )

   METHOD getSQLInsertPreciosWhereArticulo( uuidArticulo )

   METHOD insertPreciosWhereArticulo( uuidArticulo ) ;     
                                       INLINE ( ::getDatabase():Querys( ::getSQLInsertPreciosWhereArticulo( uuidArticulo ) ) )

   METHOD getPrecioBaseWhereArticuloUuidAndTarifaCodigo( uuidArticulo, cCodigoTarifa ) ;
                                       INLINE ( ::getDatabase():getValue( ::getSQLPrecioBaseWhereArticuloUuidAndTarifaCodigo( uuidArticulo, cCodigoTarifa ) ) )

   METHOD getSQLPrecioBaseWhereArticuloUuidAndTarifaCodigo( uuidArticulo, cCodigoTarifa )

   METHOD getPrecioBaseWhereArticuloCodigoAndTarifaCodigo( cCodigoArticulo, cCodigoTarifa ) ;
                                       INLINE ( ::getDatabase():getValue( ::getSQLPrecioBaseWhereArticuloCodigoAndTarifaCodigo( cCodigoArticulo, cCodigoTarifa ) ) )

   METHOD getSQLPrecioBaseWhereArticuloCodigoAndTarifaCodigo( cCodigoArticulo, cCodigoTarifa )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosPreciosModel
   
   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "articulo_uuid",              {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| ::getControllerParentUuid() } } )

   hset( ::hColumns, "tarifa_uuid",                {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "manual",                     {  "create"    => "TINYINT ( 1 )"                           ,;
                                                      "default"   => {|| "0" } }                               )

   hset( ::hColumns, "margen",                     {  "create"    => "FLOAT( 8, 4 )"                           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "margen_real",                {  "create"    => "FLOAT( 8, 4 )"                           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "precio_base",                {  "create"    => "FLOAT( 16, 6 )"                          ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "precio_iva_incluido",        {  "create"    => "FLOAT( 16, 6 )"                          ,;
                                                      "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLArticulosPreciosModel

   local cSQL

   TEXT INTO cSql

   SELECT 
      articulos_precios.id AS articulos_precios_id,     
      articulos_precios.uuid AS articulos_precios_uuid,       
      articulos_precios.articulo_uuid AS articulos_precios_articulo_uuid, 
      articulos_precios.tarifa_uuid AS articulos_precios_tarifa_uuid,
      articulos_precios.margen AS articulos_precios_margen, 
      articulos_precios.margen_real AS articulos_precios_margen_real,                                                            
      articulos_precios.precio_base AS articulos_precios_precio_base, 
      articulos_precios.precio_iva_incluido AS articulos_precios_precio_iva_incluido,                                                    
      articulos_precios.manual AS articulos_precios_manual,                                                                 
      articulos_tarifas.nombre AS articulos_tarifas_nombre,                                                                 
      articulos_tarifas.parent_uuid AS articulos_tarifas_parent_uuid,                                                            
      IF( articulos_tarifas_base.nombre IS NULL OR articulos_precios.manual = 1, 'Costo', articulos_tarifas_base.nombre ) AS articulos_tarifas_base_nombre   

   FROM %1$s AS articulos_precios                 

      INNER JOIN %2$s AS articulos_tarifas         
         ON articulos_tarifas.uuid = articulos_precios.tarifa_uuid                               

      LEFT JOIN %2$s AS articulos_tarifas_base         
         ON articulos_tarifas_base.uuid = articulos_tarifas.parent_uuid                              

      LEFT JOIN %1$s AS articulos_precios_parent         
         ON articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid AND articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid

   WHERE 
      ( articulos_tarifas.activa = 1 
         AND ( articulos_tarifas.valido_desde IS NULL OR articulos_tarifas.valido_desde >= CURDATE() )
         AND ( articulos_tarifas.valido_hasta IS NULL OR articulos_tarifas.valido_hasta <= CURDATE() ) 
      ) 

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLArticulosTarifasModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getPrecioSobre( nPrecioCosto ) 

   if !empty( nPrecioCosto )
      RETURN ( "IF( articulos_tarifas.parent_uuid = '', " + hb_ntos( nPrecioCosto ) + ", articulos_precios_parent.precio_base )" )
   end if 

RETURN ( "IF( articulos_tarifas.parent_uuid = '', articulos.precio_costo, articulos_precios_parent.precio_base )" ) 

//---------------------------------------------------------------------------//

METHOD getSQLInsertPrecioWhereTarifa( uuidTarifa ) CLASS SQLArticulosPreciosModel

   local cSQL

   TEXT INTO cSql

   INSERT IGNORE INTO %2$s 
      (  uuid,
         articulo_uuid,
         tarifa_uuid )
      SELECT 
         UUID(),
         articulos.uuid,
         %1$s
      FROM %3$s AS articulos

   ENDTEXT

   cSql  := hb_strformat( cSql, quoted( uuidTarifa ), ::getTableName(), SQLArticulosModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLUpdatePrecioWhereTarifa( uuidTarifa ) CLASS SQLArticulosPreciosModel

   local cSQL

   TEXT INTO cSql
   
   UPDATE %2$s AS articulos_precios

      INNER JOIN %4$s AS articulos_tarifas  
         ON articulos_tarifas.uuid = %1$s

      INNER JOIN %3$s AS articulos 
        ON articulos.uuid = articulos_precios.articulo_uuid 

      LEFT JOIN %2$s AS articulos_precios_parent 
         ON articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid
         AND articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid

      LEFT JOIN %5$s AS tipos_iva
         ON tipos_iva.codigo = articulos.tipo_iva_codigo

      SET 
         articulos_precios.margen = articulos_tarifas.margen, 

         articulos_precios.precio_base = 
         (  @precio_base := 
            (
            IF( articulos_tarifas.parent_uuid = '', 
               IFNULL( articulos.precio_costo, 0 ), 
               IFNULL( articulos_precios_parent.precio_base, 0 ) ) * IFNULL( articulos_tarifas.margen, 0 ) / 100 ) + 
            IF( articulos_tarifas.parent_uuid = '',
               IFNULL( articulos.precio_costo, 0 ),
               IFNULL( articulos_precios_parent.precio_base, 0 ) )
         ),

         articulos_precios.precio_iva_incluido = ( ( @precio_base * IFNULL( tipos_iva.porcentaje, 0 ) / 100 ) + @precio_base )

      WHERE 
         (  articulos_precios.manual IS NULL OR articulos_precios.manual != 1 )
            AND articulos_precios.tarifa_uuid = %1$s 

   ENDTEXT

   cSql  := hb_strformat( cSql, quoted( uuidTarifa ), ::getTableName(), SQLArticulosModel():getTableName(), SQLArticulosTarifasModel():getTableName(), SQLTiposIvaModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLUpdatePrecioWhereArticulo( uuidArticulo ) CLASS SQLArticulosPreciosModel

   local cSQL

   TEXT INTO cSql
   
   UPDATE %2$s AS articulos_precios

      INNER JOIN %4$s AS articulos_tarifas  
         ON articulos_tarifas.uuid = articulos_precios.tarifa_uuid

      LEFT JOIN %2$s AS articulos_precios_parent 
         ON articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid
         AND articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid

      LEFT JOIN %3$s AS articulos 
        ON articulos.uuid = articulos_precios.articulo_uuid 

      LEFT JOIN %5$s AS tipos_iva
         ON tipos_iva.codigo = articulos.tipo_iva_codigo

      SET 
         articulos_precios.margen = articulos_tarifas.margen, 

         articulos_precios.precio_base = 
            ( ( @precioSobre :=                
               IF( articulos_tarifas.parent_uuid = '',
                  articulos.precio_costo,
                  articulos_precios_parent.precio_base ) )               
               * articulos_tarifas.margen / 100 ) + @precioSobre, 

         articulos_precios.precio_iva_incluido = 
            ( @precioBase * tipos_iva.porcentaje / 100 ) + @precioBase

      WHERE 
         (  articulos_precios.manual IS NULL OR articulos_precios.manual != 1 )
            AND articulos_precios.articulo_uuid = %1$s 

   ENDTEXT

   cSql  := hb_strformat( cSql, quoted( uuidArticulo ), ::getTableName(), SQLArticulosModel():getTableName(), SQLArticulosTarifasModel():getTableName(), SQLTiposIvaModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLDeletePrecioWhereUuidTarifa( uuidTarifa ) CLASS SQLArticulosPreciosModel

   local cSQL

   TEXT INTO cSql
   
   DELETE FROM %1$s 
      WHERE tarifa_uuid = %2$s 

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidTarifa ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLUpdatePrecioWhereTarifaAndArticulo( idPrecio, nPrecioCosto ) CLASS SQLArticulosPreciosModel

   local cSql

   TEXT INTO cSql

   UPDATE %1$s AS articulos_precios 

      INNER JOIN %2$s AS articulos_tarifas 
         ON articulos_tarifas.uuid = articulos_precios.tarifa_uuid 

      LEFT JOIN %3$s AS articulos  
         ON articulos.uuid = articulos_precios.articulo_uuid 

      LEFT JOIN %4$s AS tipos_iva 
         ON tipos_iva.codigo = articulos.tipo_iva_codigo 

      LEFT JOIN  %1$s AS articulos_precios_parent     
         ON articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid
            AND articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid 

      SET 
         articulos_precios.margen = articulos_tarifas.margen, 
         articulos_precios.precio_base = %5$s, 
         articulos_precios.precio_iva_incluido = ( articulos_precios.precio_base * IFNULL( tipos_iva.porcentaje, 0 ) / 100 ) + articulos_precios.precio_base 

      WHERE 
         ( articulos_precios.manual IS NULL OR articulos_precios.manual != 1 ) 
         AND articulos_precios.id = %6$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLArticulosTarifasModel():getTableName(), SQLArticulosModel():getTableName(), SQLTiposIvaModel():getTableName(), ::getPrecioBase( nPrecioCosto ), quoted( idPrecio ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLInsertPreciosWhereTarifa( codigoTarifa ) CLASS SQLArticulosPreciosModel

   local cSql 

   TEXT INTO cSql

   INSERT IGNORE INTO %1$s  
      ( uuid, articulo_uuid, tarifa_uuid )

   SELECT UUID(), articulos.uuid, articulos_tarifas.uuid
      FROM %2$s AS articulos

   INNER JOIN %3$s AS articulos_tarifas
      ON articulos_tarifas.codigo = %4$s AND articulos_tarifas.deleted_at = 0

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLArticulosModel():getTableName(), SQLArticulosTarifasModel():getTableName(), quoted( codigoTarifa ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLInsertPreciosWhereArticulo( uuidArticulo ) CLASS SQLArticulosPreciosModel

   local cSql 

   TEXT INTO cSql

   INSERT IGNORE INTO %1$s  
      ( uuid, articulo_uuid, tarifa_uuid, margen, precio_base, precio_iva_incluido )

   SELECT uuid(), %3$s, articulos_tarifas.uuid, articulos_tarifas.margen, 0, 0  
      FROM %2$s AS articulos_tarifas

      WHERE articulos_tarifas.deleted_at = 0

      ORDER BY id

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLArticulosTarifasModel():getTableName(), quoted( uuidArticulo ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD addParentUuidWhere( cSQLSelect ) CLASS SQLArticulosPreciosModel    

   local uuid     := ::oController:getController():getUuid() 

   if !empty( uuid )
      cSQLSelect  += ::getWhereOrAnd( cSQLSelect ) + ::getTableName() + ".articulo_uuid = " + quoted( uuid )
   end if 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSQLPrecioBaseWhereArticuloUuidAndTarifaCodigo( uuidArticulo, cCodigoTarifa ) CLASS SQLArticulosPreciosModel

   local cSql     := "SELECT articulos_precios.precio_base"                                              + " "  
   cSQL           +=    "FROM " + ::getTableName() + " AS articulos_precios"                             + " "  
   
   cSQL           += "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas" + " "  
   cSQL           +=    "ON articulos_tarifas.codigo = " + quoted( cCodigoTarifa )                       + " "  
   
   cSQL           += "WHERE"                                                                             + " "  
   cSQL           +=    "articulos_precios.articulo_uuid = " + quoted( uuidArticulo ) + " AND"           + " "  
   cSQL           +=    "articulos_precios.tarifa_uuid = articulos_tarifas.uuid" 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLPrecioBaseWhereArticuloCodigoAndTarifaCodigo( cCodigoArticulo, cCodigoTarifa ) CLASS SQLArticulosPreciosModel

   local cSql     := "SELECT articulos_precios.precio_base"                                              + " "  
   cSQL           +=    "FROM " + ::getTableName() + " AS articulos_precios"                             + " " 

   cSQL           += "INNER JOIN " + SQLArticulosModel():getTableName() + " AS articulos"                + " "  
   cSQL           +=    "ON articulos.codigo = " + quoted( cCodigoArticulo )                             + " "  
   
   cSQL           += "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas" + " "  
   cSQL           +=    "ON articulos_tarifas.codigo = " + quoted( cCodigoTarifa )                       + " "  
   
   cSQL           += "WHERE"                                                                             + " "  
   cSQL           +=    "articulos_precios.articulo_uuid = articulos.uuid AND"                           + " "  
   cSQL           +=    "articulos_precios.tarifa_uuid = articulos_tarifas.uuid" 

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosPreciosTarifasModel FROM SQLArticulosPreciosModel 

   METHOD getInitialSelect()

   METHOD addParentUuidWhere( cSQLSelect ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLArticulosPreciosTarifasModel

   local cSql

   TEXT INTO cSql

   SELECT 
      articulos_precios.id AS articulos_precios_id,     
      articulos_precios.uuid AS articulos_precios_uuid,       
      articulos_precios.articulo_uuid AS articulos_precios_articulo_uuid, 
      articulos_precios.tarifa_uuid AS articulos_precios_tarifa_uuid,
      articulos_precios.margen AS articulos_precios_margen, 
      articulos_precios.margen_real AS articulos_precios_margen_real,                                                            
      articulos_precios.precio_base AS articulos_precios_precio_base, 
      articulos_precios.precio_iva_incluido AS articulos_precios_precio_iva_incluido,                                                    
      articulos_precios.manual AS articulos_precios_manual,                                                                 
      articulos.codigo AS articulos_codigo,                                                           
      articulos.nombre AS articulos_nombre,                                                           
      articulos_tarifas.nombre AS articulos_tarifas_nombre,                                                                 
      articulos_tarifas.parent_uuid AS articulos_tarifas_parent_uuid,                                                            
      IF( articulos_tarifas_base.nombre IS NULL OR articulos_precios.manual = 1, 'Costo', articulos_tarifas_base.nombre ) AS articulos_tarifas_base_nombre   

   FROM %1$s AS articulos_precios                 

      INNER JOIN %2$s AS articulos         
         ON articulos.uuid = articulos_precios.articulo_uuid                               

      INNER JOIN %3$s AS articulos_tarifas         
         ON articulos_tarifas.uuid = articulos_precios.tarifa_uuid      

      LEFT JOIN %3$s AS articulos_tarifas_base         
         ON articulos_tarifas_base.uuid = articulos_tarifas.parent_uuid                              

      LEFT JOIN %1$s AS articulos_precios_parent         
         ON articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid AND articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid

   WHERE 
      ( articulos_tarifas.activa = 1 
         AND ( articulos_tarifas.valido_desde IS NULL OR articulos_tarifas.valido_desde >= CURDATE() )
         AND ( articulos_tarifas.valido_hasta IS NULL OR articulos_tarifas.valido_hasta <= CURDATE() ) 
      ) 

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName, SQLArticulosModel():getTableName(), SQLArticulosTarifasModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD addParentUuidWhere( cSql ) CLASS SQLArticulosPreciosTarifasModel    

   local uuid     := ::oController:getController():getUuid() 

   if !empty( uuid )
      cSql        += ::getWhereOrAnd( cSql ) + ::getTableName() + ".tarifa_uuid = " + quoted( uuid )
   end if 

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
