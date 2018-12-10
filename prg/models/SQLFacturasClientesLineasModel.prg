#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLFacturasClientesLineasModel FROM SQLCompanyModel

   DATA cTableName            INIT  "facturas_clientes_lineas"

   DATA cTableTemporal        

   DATA cConstraints          INIT  "PRIMARY KEY ( id ), "                       + ; 
                                       "KEY ( uuid ), "                          + ;
                                       "KEY ( parent_uuid ), "                   + ;
                                       "KEY ( deleted_at ), "                    + ;
                                       "KEY ( articulo_codigo ) "              

   DATA cGroupBy              INIT  "facturas_clientes_lineas.id" 

   METHOD getColumns()

   METHOD getColumnsSelect()

   METHOD getInitialSelect()

   METHOD getInitialWhereParentUuid( uuidParent )

   METHOD getInsertSentence()

   METHOD addUpdateSentence()
   
   METHOD addDeleteSentence()

   METHOD addDeleteSentenceById()

   METHOD deleteWhereUuid( uuid )

   METHOD aUuidToDelete( uuid )

   METHOD getDeleteSentenceFromParentsUuid()

   METHOD getSentenceNotSent( aFetch )

   METHOD getIdProductAdded()

   METHOD getUpdateUnitsSentece()

   METHOD createTemporalTableWhereUuid( originalUuid )

   METHOD alterTemporalTableWhereUuid()

   METHOD replaceUuidInTemporalTable( duplicatedUuid )

   METHOD insertTemporalTable()

   METHOD dropTemporalTable()

   METHOD duplicateByUuid( originalUuid, duplicatedUuid )

   METHOD getSentenceCountLineas( uuidParent )

   METHOD countLinesWhereUuidParent( uuidParent )  INLINE ( getSQLDatabase():getValue( ::getSentenceCountLineas( uuidParent ), 0 ) )

#ifdef __TEST__

   METHOD testCreateIVAal0( uuid )
   METHOD testCreateIVAal0Con10PorcientoDescuento( uuid )

   METHOD testCreateIVAal10( uuid )
   METHOD testCreateIVAal10ConRecargoEquivalencia( uuid )
   
   METHOD testCreateIVAal10Con15PorcientoDescuento( uuid )

   METHOD testCreateIVAal21( uuid )
   METHOD testCreateIVAal21ConRecargoEquivalencia( uuid )
   
   METHOD testCreateIVAal21Con20PorcientoDescuento( uuid )   

   METHOD testCreateIVAal21ConIncrememtoPrecio( uuid ) 

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFacturasClientesLineasModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT"         ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"    ,;
                                                      "default"   => {|| win_uuidcreatestring() } }   )

   hset( ::hColumns, "parent_uuid",                {  "create"    => "VARCHAR(40) NOT NULL"           ,;
                                                      "default"   => {|| ::getControllerParentUuid() } } )

   hset( ::hColumns, "articulo_codigo",            {  "create"    => "VARCHAR( 20 ) NOT NULL"         ,;
                                                      "default"   => {|| space( 20 ) } }              )

   hset( ::hColumns, "articulo_nombre",            {  "create"    => "VARCHAR(250) NOT NULL"          ,;
                                                      "default"   => {|| space(250) } }               )

   hset( ::hColumns, "fecha_caducidad",            {  "create"    => "DATE"                           ,;
                                                      "default"   => {|| ctod('') } }                 )

   hset( ::hColumns, "lote",                       {  "create"    => "VARCHAR(40)"                    ,;
                                                      "default"   => {|| space(40) } }                )

   hset( ::hColumns, "articulo_unidades",          {  "create"    => "DECIMAL(19,6)"                  ,;
                                                      "default"   => {|| 1 } }                        )

   hset( ::hColumns, "articulo_precio",            {  "create"    => "DECIMAL( 19, 6 )"               ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "unidad_medicion_codigo",     {  "create"    => "VARCHAR( 20 )"                  ,;
                                                      "default"   => {|| space( 20 ) } }              )

   hset( ::hColumns, "unidad_medicion_factor",     {  "create"    => "DECIMAL( 19, 6 )"               ,;
                                                      "default"   => {|| 1 } }                        )

   hset( ::hColumns, "descuento",                  {  "create"    => "FLOAT( 7, 4 )"                  ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "combinaciones_uuid",         {  "create"    => "VARCHAR( 40 )"                  ,;
                                                      "default"   => {|| space( 40 ) } } )

   hset( ::hColumns, "incremento_precio",          {  "create"    => "FLOAT( 19, 6)"                  ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "iva",                        {  "create"    => "FLOAT( 7, 4 )"                  ,;
                                                      "default"   => {|| 0 }  }                       )

   hset( ::hColumns, "recargo_equivalencia",       {  "create"    => "FLOAT( 7, 4 )"                  ,;
                                                      "default"   => {|| 0 }  }                       )

   hset( ::hColumns, "almacen_codigo",             {  "create"    => "VARCHAR( 20 ) NOT NULL"         ,;
                                                      "default"   => {|| space( 20 ) } }              )

   hset( ::hColumns, "agente_codigo",              {  "create"    => "VARCHAR( 20 ) NOT NULL"         ,;
                                                      "default"   => {|| space( 20 ) } }              )

   hset( ::hColumns, "agente_comision",            {  "create"    => "FLOAT( 7, 4 )"                  ,;
                                                      "default"   => {|| 0 } }                        )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getColumnsSelect()

   local cColumns

   TEXT INTO cColumns
      facturas_clientes_lineas.id AS id,
      facturas_clientes_lineas.uuid AS uuid,
      facturas_clientes_lineas.parent_uuid AS parent_uuid,
      facturas_clientes_lineas.articulo_codigo AS articulo_codigo,
      facturas_clientes_lineas.articulo_nombre AS articulo_nombre,
      facturas_clientes_lineas.fecha_caducidad AS fecha_caducidad,
      facturas_clientes_lineas.lote AS lote,
      facturas_clientes_lineas.articulo_unidades AS articulo_unidades,
      facturas_clientes_lineas.unidad_medicion_factor AS unidad_medicion_factor,
      ( @total_unidades := articulo_unidades * unidad_medicion_factor ) AS total_unidades,
      facturas_clientes_lineas.articulo_precio AS articulo_precio,
      facturas_clientes_lineas.incremento_precio AS incremento_precio,
      ( @total_bruto := ROUND( @total_unidades * ( articulo_precio + incremento_precio ), 2 ) ) AS total_bruto,
      facturas_clientes_lineas.unidad_medicion_codigo AS unidad_medicion_codigo,
      facturas_clientes_lineas.descuento AS descuento,
      ( @importe_descuento := IF( descuento IS NULL OR descuento = 0, 0, @total_bruto * descuento / 100 ) ) AS importe_descuento,
      ( @total_bruto - @importe_descuento ) AS total_precio,
      facturas_clientes_lineas.iva AS iva,
      facturas_clientes_lineas.recargo_equivalencia AS recargo_equivalencia,
      facturas_clientes_lineas.almacen_codigo AS almacen_codigo,
      almacenes.nombre AS almacen_nombre,
      facturas_clientes_lineas.agente_codigo AS agente_codigo,
      facturas_clientes_lineas.agente_comision AS agente_comision, 
      agentes.nombre AS agente_nombre, 
      RTRIM( GROUP_CONCAT( articulos_propiedades_lineas.nombre ORDER BY combinaciones_propiedades.id ) ) AS articulos_propiedades_nombre,
      facturas_clientes_lineas.deleted_at AS deleted_at
   ENDTEXT
      
RETURN ( cColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLFacturasClientesLineasModel

   local cSql

   TEXT INTO cSql

      SELECT 
         %6$s
         
      FROM %1$s AS facturas_clientes_lineas

      LEFT JOIN %2$s AS almacenes
         ON almacenes.codigo = facturas_clientes_lineas.almacen_codigo

      LEFT JOIN %3$s AS agentes
         ON agentes.codigo = facturas_clientes_lineas.agente_codigo
  
      LEFT JOIN %4$s AS combinaciones_propiedades
         ON combinaciones_propiedades.parent_uuid = facturas_clientes_lineas.combinaciones_uuid

      LEFT JOIN %5$s AS articulos_propiedades_lineas
         ON articulos_propiedades_lineas.uuid = combinaciones_propiedades.propiedad_uuid
       
   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           SQLAlmacenesModel():getTableName(),;
                           SQLAgentesModel():getTableName(),;
                           SQLCombinacionesPropiedadesModel():getTableName(),;
                           SQLPropiedadesLineasModel():getTableName(),;
                           ::getColumnsSelect() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getInitialWhereParentUuid( uuidParent )

RETURN ( "WHERE facturas_clientes_lineas.parent_uuid = " + quoted( uuidParent ) )

//---------------------------------------------------------------------------//

METHOD getInsertSentence() CLASS SQLFacturasClientesLineasModel

   local nId

   nId            := ::getIdProductAdded()

   if empty( nId )
      RETURN ( ::Super:getInsertSentence() )
   end if 

   ::setSQLInsert( ::getUpdateUnitsSentece( nId ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addUpdateSentence( aSQLUpdate, oProperty ) CLASS SQLFacturasClientesLineasModel

   aadd( aSQLUpdate, "UPDATE " + ::getTableName() + " " +                                                       ;
                        "SET unidades_articulo = " + toSqlString( oProperty:Value )                + ", " + ;
                        "precio_articulo = " + toSqlString( hget( ::hBuffer, "precio_articulo" ) ) + " " +  ;
                        "WHERE uuid = " + quoted( oProperty:Uuid ) +  "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addDeleteSentence( aSQLUpdate, oProperty ) CLASS SQLFacturasClientesLineasModel

   aadd( aSQLUpdate, "DELETE FROM " + ::getTableName() + " " +                          ;
                        "WHERE uuid = " + quoted( oProperty:Uuid ) + "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addDeleteSentenceById( aSQLUpdate, nId ) CLASS SQLFacturasClientesLineasModel

   aadd( aSQLUpdate, "DELETE FROM " + ::getTableName() + " " +                          ;
                        "WHERE id = " + quoted( nId ) + "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteWhereUuid( uuid ) CLASS SQLFacturasClientesLineasModel

   local cSentence   := "DELETE FROM " + ::getTableName() + " " + ;
                           "WHERE parent_uuid = " + quoted( uuid )

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD aUuidToDelete( aParentsUuid ) CLASS SQLFacturasClientesLineasModel

   local cSentence   

   cSentence            := "SELECT uuid FROM " + ::getTableName() + " "
   cSentence            +=    "WHERE parent_uuid IN ( " 

   aeval( aParentsUuid, {| v | cSentence += toSQLString( v ) + ", " } )

   cSentence            := chgAtEnd( cSentence, ' )', 2 )

RETURN ( ::getDatabase():selectFetchArray( cSentence ) )

//---------------------------------------------------------------------------//

METHOD getDeleteSentenceFromParentsUuid( aParentsUuid ) CLASS SQLFacturasClientesLineasModel

   local aUuid       := ::aUuidToDelete( aParentsUuid )

   if !empty( aUuid )
      RETURN ::getDeleteSentence( aUuid )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD getSentenceNotSent( aFetch ) CLASS SQLFacturasClientesLineasModel

   local cSentence   := "SELECT * FROM " + ::getTableName() + " "

   cSentence         +=    "WHERE parent_uuid IN ( " 

   aeval( aFetch, {|h| cSentence += toSQLString( hget( h, "uuid" ) ) + ", " } )

   cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getIdProductAdded() CLASS SQLFacturasClientesLineasModel

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getUpdateUnitsSentece( id ) CLASS SQLFacturasClientesLineasModel
   
   local cSentence   := "UPDATE " + ::getTableName() +                                                                                  + " " +  ;
                           "SET unidades_articulo = unidades_articulo + " + toSQLString( hget( ::hBuffer, "unidades_articulo" ) )   + " " +  ;
                        "WHERE id = " + quoted( id )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD createTemporalTableWhereUuid( originalUuid ) CLASS SQLFacturasClientesLineasModel

   local cSentence

   ::cTableTemporal  := ::cTableName + hb_ttos( hb_datetime() )

   cSentence         := "CREATE TEMPORARY TABLE " + ::cTableTemporal          + " "
   cSentence         +=    "SELECT * from " + ::getTableName()                + " " 
   cSentence         += "WHERE parent_uuid = " + quoted( originalUuid )       + "; "

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD alterTemporalTableWhereUuid() CLASS SQLFacturasClientesLineasModel

RETURN ( ::getDatabase():Exec( "ALTER TABLE " + ::cTableTemporal + " DROP id" ) )

//---------------------------------------------------------------------------//

METHOD replaceUuidInTemporalTable( duplicatedUuid ) CLASS SQLFacturasClientesLineasModel

   local cSentence

   cSentence         := "UPDATE " + ::cTableTemporal                          + " "
   cSentence         +=    "SET id = 0"                                       + ", "
   cSentence         +=       "uuid = UUID()"                                 + ", "
   cSentence         +=       "parent_uuid = " + quoted( duplicatedUuid )    

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD insertTemporalTable() CLASS SQLFacturasClientesLineasModel

   local cSentence

   cSentence         := "INSERT INTO " + ::getTableName() +                       + " "
   cSentence         +=    "SELECT * FROM " + ::cTableTemporal

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD dropTemporalTable() CLASS SQLFacturasClientesLineasModel

RETURN ( ::getDatabase():Exec( "DROP TABLE " + ::cTableTemporal ) )

//---------------------------------------------------------------------------//

METHOD duplicateByUuid( originalUuid, duplicatedUuid ) CLASS SQLFacturasClientesLineasModel

   if !( ::createTemporalTableWhereUuid( originalUuid ) )
      RETURN ( nil )
   end if 

   if !( ::replaceUuidInTemporalTable( duplicatedUuid ) )
      RETURN ( nil )
   end if 

   if !( ::insertTemporalTable() )
      RETURN ( nil )
   end if 

   if !( ::dropTemporalTable() )
      RETURN ( nil )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getSentenceCountLineas( uuidParent ) CLASS SQLFacturasClientesLineasModel

   local cSql

   TEXT INTO cSql

   SELECT COUNT(*)

      FROM %1$s AS facturas_clientes_lineas

      WHERE facturas_clientes_lineas.parent_uuid = %2$s  

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidParent ) )

RETURN ( cSql )

//---------------------------------------------------------------------------// 

#ifdef __TEST__

METHOD testCreateIVAal0( uuid ) CLASS SQLFacturasClientesLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 0% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal0Con10PorcientoDescuento( uuid ) CLASS SQLFacturasClientesLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 0% IVA con 10% descuento" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "incremento_precio", 15 )
   hset( hBuffer, "descuento", 10 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal10( uuid ) CLASS SQLFacturasClientesLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 10% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 10 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal10ConRecargoEquivalencia( uuid ) CLASS SQLFacturasClientesLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 10% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 10 )
   hset( hBuffer, "recargo_equivalencia", 1.4 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal10Con15PorcientoDescuento( uuid ) CLASS SQLFacturasClientesLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 10% IVA con 15% descuento" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 10 )
   hset( hBuffer, "descuento", 15 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal21( uuid ) CLASS SQLFacturasClientesLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 21% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 21 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal21ConRecargoEquivalencia( uuid ) CLASS SQLFacturasClientesLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 21% IVA" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 21 )
   hset( hBuffer, "recargo_equivalencia", 5.2 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal21Con20PorcientoDescuento( uuid ) CLASS SQLFacturasClientesLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 21% IVA con 20% descuento" )
   hset( hBuffer, "articulo_unidades", 1 )
   hset( hBuffer, "articulo_precio", 100 )
   hset( hBuffer, "iva", 21 )
   hset( hBuffer, "descuento", 20 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateIVAal21ConIncrememtoPrecio( uuid ) CLASS SQLFacturasClientesLineasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "parent_uuid", uuid )
   hset( hBuffer, "articulo_codigo", "0" )
   hset( hBuffer, "articulo_nombre", "Test al 21% IVA con 20% descuento" )
   hset( hBuffer, "articulo_unidades", 13.22 )
   hset( hBuffer, "articulo_precio", 0.40438 )
   hset( hBuffer, "incremento_precio", 0.17000 )
   hset( hBuffer, "descuento", 15.889 )
   hset( hBuffer, "iva", 21 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

#endif
