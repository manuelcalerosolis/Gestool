#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLArticulosPreciosModel FROM SQLCompanyModel

   DATA cTableName                  INIT "articulos_precios"

   DATA cAs                         INIT "articulos_precios"

   DATA cConstraints                INIT "PRIMARY KEY ( id ), UNIQUE KEY ( articulo_uuid, tarifa_uuid )"

   DATA cOrderBy                    INIT "id"

   METHOD getColumns()

   METHOD addParentUuidWhere( cSQLSelect )    

   METHOD isParentUuidColumn()      INLINE ( hb_hhaskey( ::hColumns, "articulo_uuid" ) )

   METHOD getInitialSelect()

   METHOD getPrecioSobre( nPrecioCosto )

   METHOD getPrecioBase( nPrecioCosto ) ;
                                    INLINE ( "( " + ::getPrecioSobre( nPrecioCosto ) + " * articulos_tarifas.margen / 100 ) + " + ::getPrecioSobre( nPrecioCosto ) )

   METHOD getPrecioIVA( nPrecioCosto ) ;
                                    INLINE ( "( " + ::getPrecioBase( nPrecioCosto ) + " * tipos_iva.porcentaje / 100 ) + " + ::getPrecioBase( nPrecioCosto ) )

   METHOD getInnerJoinArticulosTarifas( uuidTarifa ) INLINE ;
                                    (  "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas " + CRLF + ;
                                          "ON articulos_tarifas.uuid = " + quoted( uuidTarifa ) + " " + CRLF )

   METHOD getInnerJoinTiposIva()    INLINE ;
                                    (  "LEFT JOIN " + SQLTiposIvaModel():getTableName() + " AS tipos_iva " + CRLF + ;
                                          "ON tipos_iva.codigo = articulos.tipo_iva_codigo " + CRLF )

   METHOD getSQLInsertPrecioWhereTarifa( uuidTarifa )

   METHOD insertPrecioWhereTarifa( uuidTarifa ) ;
                                    INLINE ( ::getDatabase():Exec( ::getSQLInsertPrecioWhereTarifa( uuidTarifa ) ) )

   METHOD getSQLUpdatePrecioWhereTarifa( uuidTarifa, lCosto )

   METHOD updatePrecioWhereTarifa( uuidTarifa ) ;
                                    INLINE ( ::getDatabase():Exec( ::getSQLUpdatePrecioWhereTarifa( uuidTarifa ) ) )

   METHOD updatePrecioWhereArticulo( uuidArticulo ) ;
                                    INLINE ( ::getDatabase():Exec( ::getSQLUpdatePrecioWhereArticulo( uuidArticulo ) ) )

   METHOD getSQLUpdatePrecioWhereArticulo( uuidArticulo ) 

   METHOD insertUpdatePrecioWhereTarifa( uuidTarifa, lCosto ) ;
                                    INLINE ( ::getDatabase():Exec( ::getSQLInsertPrecioWhereTarifa( uuidTarifa, lCosto ) ),;
                                             ::getDatabase():Exec( ::getSQLUpdatePrecioWhereTarifa( uuidTarifa, lCosto ) ) )

   METHOD updatePrecioWhereTarifaAndArticulo( idPrecio, nPrecioCosto ) ;
                                    INLINE ( ::getDatabase():Exec( ::getSQLUpdatePrecioWhereTarifaAndArticulo( idPrecio, nPrecioCosto ) ) )

   METHOD getSQLUpdatePrecioWhereTarifaAndArticulo( idPrecio, nPrecioCosto )

   METHOD getSQLInsertPreciosWhereTarifa( codigoTarifa )

   METHOD insertPreciosWhereTarifa( codigoTarifa ) ;
                                    INLINE ( ::getDatabase():Execs( ::getSQLInsertPreciosWhereTarifa( codigoTarifa ) ) )

   METHOD getSQLInsertPreciosWhereArticulo( uuidArticulo )

   METHOD insertPreciosWhereArticulo( uuidArticulo ) ;     
                                    INLINE ( ::getDatabase():Execs( ::getSQLInsertPreciosWhereArticulo( uuidArticulo ) ) )

   METHOD getPrecioBaseWhereArticuloUuidAndTarifaCodigo( uuidArticulo, cCodigoTarifa ) ;
                                    INLINE ( ::getDatabase():getValue( ::getSQLPrecioBaseWhereArticuloUuidAndTarifaCodigo( uuidArticulo, cCodigoTarifa ) ) )

   METHOD getSQLPrecioBaseWhereArticuloUuidAndTarifaCodigo( uuidArticulo, cCodigoTarifa )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosPreciosModel
   
   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "articulo_uuid",              {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| ::getSenderControllerParentUuid() } } )

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

      articulos_precios.id,     
      articulos_precios.uuid,       
      articulos_precios.articulo_uuid, 
      articulos_precios.tarifa_uuid,
      articulos_precios.margen, 
      articulos_precios.margen_real,                                                            
      articulos_precios.precio_base, 
      articulos_precios.precio_iva_incluido,                                                    
      articulos_precios.manual,                                                                 
      articulos_tarifas.nombre AS articulos_tarifas_nombre,                                                                 
      articulos_tarifas.parent_uuid,                                                            
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
         tarifa_uuid,
         margen,
         precio_base,
         precio_iva_incluido )
      SELECT 
         UUID(),
         articulos.uuid,
         %1$s,
         articulos_tarifas.margen,
         @precioBase :=             
         ( ( @precioSobre :=                
            IF( articulos_tarifas.parent_uuid = '', articulos.precio_costo, articulos_precios_parent.precio_base )                
            * articulos_tarifas.margen / 100 ) + @precioSobre ),
         @precioIVA := ( ( @precioBase * tipos_iva.porcentaje / 100 ) + @precioBase )
      FROM %3$s AS articulos

      LEFT JOIN %2$s AS articulos_precios_parent 
         ON articulos_precios_parent.articulo_uuid = articulos.uuid 
         AND articulos_precios_parent.tarifa_uuid = articulos_tarifas.uuid

      INNER JOIN %4$s AS articulos_tarifas  
         ON articulos_tarifas.uuid = %1$s

      LEFT JOIN %5$s AS tipos_iva
         ON tipos_iva.codigo = articulos.tipo_iva_codigo

   ENDTEXT

   cSql  := hb_strformat( cSql, quoted( uuidTarifa ), ::getTableName(), SQLArticulosModel():getTableName(), SQLArticulosTarifasModel():getTableName(), SQLTiposIvaModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLUpdatePrecioWhereTarifa( uuidTarifa ) CLASS SQLArticulosPreciosModel

   local cSQL

   TEXT INTO cSql
   
   UPDATE %2$s AS articulos_precios

      INNER JOIN %4$s AS articulos_tarifas  
         ON articulos_tarifas.uuid = %1$s

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
            @precioBase :=             
            ( ( @precioSobre :=                
               IF( articulos_tarifas.parent_uuid = '', articulos.precio_costo, articulos_precios_parent.precio_base )                
               * articulos_tarifas.margen / 100 ) + @precioSobre ),

         articulos_precios.precio_iva_incluido = ( ( @precioBase * tipos_iva.porcentaje / 100 ) + @precioBase )

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

METHOD getSQLUpdatePrecioWhereTarifaAndArticulo( idPrecio, nPrecioCosto ) CLASS SQLArticulosPreciosModel

   local cSQL
   
   cSQL  := "UPDATE " + ::getTableName() + " AS articulos_precios " + CRLF  

   cSQL  += "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas " + CRLF + ;
               "ON articulos_tarifas.uuid = articulos_precios.tarifa_uuid " + CRLF

   cSQL  += "LEFT JOIN " + SQLArticulosModel():getTableName() + " AS articulos " + CRLF 
   cSQL  +=    "ON articulos.uuid = articulos_precios.articulo_uuid " + CRLF

   cSQL  += ::getInnerJoinTiposIva()

   cSQL  += "LEFT JOIN " + ::getTableName() + " AS articulos_precios_parent " + CRLF    
   cSQL  +=    "ON articulos_precios_parent.tarifa_uuid = articulos_tarifas.parent_uuid " + CRLF
   cSQL  +=    "AND articulos_precios_parent.articulo_uuid = articulos_precios.articulo_uuid " + CRLF

   cSQL  += "SET " + CRLF

   cSQL  +=    "articulos_precios.margen = articulos_tarifas.margen, " + CRLF
   cSQL  +=    "articulos_precios.precio_base = " + ::getPrecioBase( nPrecioCosto ) + ", " + CRLF 
   cSQL  +=    "articulos_precios.precio_iva_incluido = ( articulos_precios.precio_base * IFNULL( tipos_iva.porcentaje, 0 ) / 100 ) + articulos_precios.precio_base " + CRLF   

   cSQL  += "WHERE " + CRLF
   cSQL  +=    "( articulos_precios.manual IS NULL OR articulos_precios.manual != 1 ) " + CRLF
   cSQL  +=    "AND articulos_precios.id = " + quoted( idPrecio ) + " " + CRLF

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLInsertPreciosWhereTarifa( codigoTarifa ) CLASS SQLArticulosPreciosModel

   local cSQL     := "INSERT IGNORE INTO " + ::getTableName()                                                  + " "  
   cSQL           +=    "( uuid, articulo_uuid, tarifa_uuid )"                                                 + " "  
   cSQL           += "SELECT UUID(), articulos.uuid, articulos_tarifas.uuid"                                   + " "  
   cSQL           +=    "FROM " + SQLArticulosModel():getTableName() + " AS articulos"                         + " "
   cSQL           +=    "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas"    + " "
   cSql           +=    "ON articulos_tarifas.codigo = " + quoted( codigoTarifa )

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD getSQLInsertPreciosWhereArticulo( uuidArticulo ) CLASS SQLArticulosPreciosModel

   local cSQL     := "INSERT IGNORE INTO " + ::getTableName()                                                                 + " "  
   cSQL           +=    "( uuid, articulo_uuid, tarifa_uuid, margen, precio_base, precio_iva_incluido )"                      + " "  
   cSQL           += "SELECT uuid(), " + quoted( uuidArticulo ) + ", articulos_tarifas.uuid, articulos_tarifas.margen, 0, 0"  + " "  
   cSQL           +=    "FROM " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas"                         + " "  
   cSQL           +=    "ORDER BY id"

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD addParentUuidWhere( cSQLSelect ) CLASS SQLArticulosPreciosModel    

   local uuid     := ::oController:getSenderController():getUuid() 

   if !empty( uuid )
      cSQLSelect  += ::getWhereOrAnd( cSQLSelect ) + ::getTableName() + ".articulo_uuid = " + quoted( uuid )
   end if 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSQLPrecioBaseWhereArticuloUuidAndTarifaCodigo( uuidArticulo, cCodigoTarifa )

   local cSql     := "SELECT articulos_precios.precio_base"                                              + " "  
   cSQL           +=    "FROM " + ::getTableName() + " AS articulos_precios"                             + " "  
   cSQL           += "INNER JOIN " + SQLArticulosTarifasModel():getTableName() + " AS articulos_tarifas" + " "  
   cSQL           +=    "ON articulos_tarifas.codigo = " + quoted( cCodigoTarifa )                       + " "  
   cSQL           += "WHERE"                                                                             + " "  
   cSQL           +=    "articulos_precios.articulo_uuid = " + quoted( uuidArticulo ) + " AND"           + " "  
   cSQL           +=    "articulos_precios.tarifa_uuid = articulos_tarifas.uuid" 

RETURN ( cSql )

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

      articulos_precios.id,     
      articulos_precios.uuid,       
      articulos_precios.articulo_uuid, 
      articulos_precios.tarifa_uuid,
      articulos.codigo AS articulos_codigo,                                                           
      articulos.nombre AS articulos_nombre,                                                           
      articulos_precios.margen, 
      articulos_precios.margen_real,                                                            
      articulos_precios.precio_base, 
      articulos_precios.precio_iva_incluido,                                                    
      articulos_precios.manual,                                                                 
      articulos_tarifas.nombre AS articulos_tarifas_nombre,                                                                 
      articulos_tarifas.parent_uuid,                                                            
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

METHOD addParentUuidWhere( cSQLSelect ) CLASS SQLArticulosPreciosTarifasModel    

   local uuid     := ::oController:getSenderController():getUuid() 

   if !empty( uuid )
      cSQLSelect  += ::getWhereOrAnd( cSQLSelect ) + ::getTableName() + ".tarifa_uuid = " + quoted( uuid )
   end if 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
