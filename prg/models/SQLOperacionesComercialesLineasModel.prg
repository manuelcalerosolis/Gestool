#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLOperacionesComercialesLineasModel FROM SQLCompanyModel

   DATA cTableTemporal        

   DATA cConstraints          INIT  "PRIMARY KEY ( id ), "                       + ; 
                                       "KEY ( uuid ), "                          + ;
                                       "KEY ( parent_uuid ), "                   + ;
                                       "KEY ( deleted_at ), "                    + ;
                                       "KEY ( articulo_codigo ) "              


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

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLOperacionesComercialesLineasModel

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

METHOD getColumnsSelect() CLASS SQLOperacionesComercialesLineasModel

   local cColumns

   TEXT INTO cColumns
      %1$s.id AS id,
      %1$s.uuid AS uuid,
      %1$s.parent_uuid AS parent_uuid,
      %1$s.articulo_codigo AS articulo_codigo,
      %1$s.articulo_nombre AS articulo_nombre,
      %1$s.fecha_caducidad AS fecha_caducidad,
      %1$s.lote AS lote,
      %1$s.articulo_unidades AS articulo_unidades,
      %1$s.unidad_medicion_factor AS unidad_medicion_factor,
      ( @total_unidades := articulo_unidades * unidad_medicion_factor ) AS total_unidades,
      %1$s.articulo_precio AS articulo_precio,
      %1$s.incremento_precio AS incremento_precio,
      ( @total_bruto := ROUND( @total_unidades * ( articulo_precio + incremento_precio ), 2 ) ) AS total_bruto,
      %1$s.unidad_medicion_codigo AS unidad_medicion_codigo,
      %1$s.descuento AS descuento,
      ( @importe_descuento := IF( descuento IS NULL OR descuento = 0, 0, @total_bruto * descuento / 100 ) ) AS importe_descuento,
      ( @total_bruto - @importe_descuento ) AS total_precio,
      %1$s.iva AS iva,
      %1$s.recargo_equivalencia AS recargo_equivalencia,
      %1$s.almacen_codigo AS almacen_codigo,
      almacenes.nombre AS almacen_nombre,
      %1$s.agente_codigo AS agente_codigo,
      %1$s.agente_comision AS agente_comision, 
      agentes.nombre AS agente_nombre, 
      RTRIM( GROUP_CONCAT( articulos_propiedades_lineas.nombre ORDER BY combinaciones_propiedades.id ) ) AS articulos_propiedades_nombre,
      %1$s.deleted_at AS deleted_at
   
   ENDTEXT

   cColumns  := hb_strformat(  cColumns, ::cTableName )
      
RETURN ( cColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLOperacionesComercialesLineasModel

   local cSql

   TEXT INTO cSql

      SELECT 
         %7$s
         
      FROM %1$s AS %2$s

      LEFT JOIN %3$s AS almacenes
         ON almacenes.codigo = %2$s.almacen_codigo

      LEFT JOIN %4$s AS agentes
         ON agentes.codigo = %2$s.agente_codigo
  
      LEFT JOIN %5$s AS combinaciones_propiedades
         ON combinaciones_propiedades.parent_uuid = %2$s.combinaciones_uuid

      LEFT JOIN %6$s AS articulos_propiedades_lineas
         ON articulos_propiedades_lineas.uuid = combinaciones_propiedades.propiedad_uuid
       
   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           ::cTableName,;
                           SQLAlmacenesModel():getTableName(),;
                           SQLAgentesModel():getTableName(),;
                           SQLCombinacionesPropiedadesModel():getTableName(),;
                           SQLPropiedadesLineasModel():getTableName(),;
                           ::getColumnsSelect() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getInitialWhereParentUuid( uuidParent ) CLASS SQLOperacionesComercialesLineasModel

RETURN ( "WHERE facturas_clientes_lineas.parent_uuid = " + quoted( uuidParent ) )

//---------------------------------------------------------------------------//

METHOD getInsertSentence() CLASS SQLOperacionesComercialesLineasModel

   local nId

   nId            := ::getIdProductAdded()

   if empty( nId )
      RETURN ( ::Super:getInsertSentence() )
   end if 

   ::setSQLInsert( ::getUpdateUnitsSentece( nId ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addUpdateSentence( aSQLUpdate, oProperty ) CLASS SQLOperacionesComercialesLineasModel

   aadd( aSQLUpdate, "UPDATE " + ::getTableName() + " " +                                                       ;
                        "SET unidades_articulo = " + toSqlString( oProperty:Value )                + ", " + ;
                        "precio_articulo = " + toSqlString( hget( ::hBuffer, "precio_articulo" ) ) + " " +  ;
                        "WHERE uuid = " + quoted( oProperty:Uuid ) +  "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addDeleteSentence( aSQLUpdate, oProperty ) CLASS SQLOperacionesComercialesLineasModel

   aadd( aSQLUpdate, "DELETE FROM " + ::getTableName() + " " +                          ;
                        "WHERE uuid = " + quoted( oProperty:Uuid ) + "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addDeleteSentenceById( aSQLUpdate, nId ) CLASS SQLOperacionesComercialesLineasModel

   aadd( aSQLUpdate, "DELETE FROM " + ::getTableName() + " " +                          ;
                        "WHERE id = " + quoted( nId ) + "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteWhereUuid( uuid ) CLASS SQLOperacionesComercialesLineasModel

   local cSentence   := "DELETE FROM " + ::getTableName() + " " + ;
                           "WHERE parent_uuid = " + quoted( uuid )

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD aUuidToDelete( aParentsUuid ) CLASS SQLOperacionesComercialesLineasModel

   local cSentence   

   cSentence            := "SELECT uuid FROM " + ::getTableName() + " "
   cSentence            +=    "WHERE parent_uuid IN ( " 

   aeval( aParentsUuid, {| v | cSentence += toSQLString( v ) + ", " } )

   cSentence            := chgAtEnd( cSentence, ' )', 2 )

RETURN ( ::getDatabase():selectFetchArray( cSentence ) )

//---------------------------------------------------------------------------//

METHOD getDeleteSentenceFromParentsUuid( aParentsUuid ) CLASS SQLOperacionesComercialesLineasModel

   local aUuid       := ::aUuidToDelete( aParentsUuid )

   if !empty( aUuid )
      RETURN ::getDeleteSentence( aUuid )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD getSentenceNotSent( aFetch ) CLASS SQLOperacionesComercialesLineasModel

   local cSentence   := "SELECT * FROM " + ::getTableName() + " "

   cSentence         +=    "WHERE parent_uuid IN ( " 

   aeval( aFetch, {|h| cSentence += toSQLString( hget( h, "uuid" ) ) + ", " } )

   cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getIdProductAdded() CLASS SQLOperacionesComercialesLineasModel

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getUpdateUnitsSentece( id ) CLASS SQLOperacionesComercialesLineasModel
   
   local cSentence   := "UPDATE " + ::getTableName() +                                                                                  + " " +  ;
                           "SET unidades_articulo = unidades_articulo + " + toSQLString( hget( ::hBuffer, "unidades_articulo" ) )   + " " +  ;
                        "WHERE id = " + quoted( id )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD createTemporalTableWhereUuid( originalUuid ) CLASS SQLOperacionesComercialesLineasModel

   local cSentence

   ::cTableTemporal  := ::cTableName + hb_ttos( hb_datetime() )

   cSentence         := "CREATE TEMPORARY TABLE " + ::cTableTemporal          + " "
   cSentence         +=    "SELECT * from " + ::getTableName()                + " " 
   cSentence         += "WHERE parent_uuid = " + quoted( originalUuid )       + "; "

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD alterTemporalTableWhereUuid() CLASS SQLOperacionesComercialesLineasModel

RETURN ( ::getDatabase():Exec( "ALTER TABLE " + ::cTableTemporal + " DROP id" ) )

//---------------------------------------------------------------------------//

METHOD replaceUuidInTemporalTable( duplicatedUuid ) CLASS SQLOperacionesComercialesLineasModel

   local cSentence

   cSentence         := "UPDATE " + ::cTableTemporal                          + " "
   cSentence         +=    "SET id = 0"                                       + ", "
   cSentence         +=       "uuid = UUID()"                                 + ", "
   cSentence         +=       "parent_uuid = " + quoted( duplicatedUuid )    

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD insertTemporalTable() CLASS SQLOperacionesComercialesLineasModel

   local cSentence

   cSentence         := "INSERT INTO " + ::getTableName() +                       + " "
   cSentence         +=    "SELECT * FROM " + ::cTableTemporal

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD dropTemporalTable() CLASS SQLOperacionesComercialesLineasModel

RETURN ( ::getDatabase():Exec( "DROP TABLE " + ::cTableTemporal ) )

//---------------------------------------------------------------------------//

METHOD duplicateByUuid( originalUuid, duplicatedUuid ) CLASS SQLOperacionesComercialesLineasModel

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

METHOD getSentenceCountLineas( uuidParent ) CLASS SQLOperacionesComercialesLineasModel

   local cSql

   TEXT INTO cSql

   SELECT COUNT(*)

      FROM %1$s AS facturas_clientes_lineas

      WHERE facturas_clientes_lineas.parent_uuid = %2$s  

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidParent ) )

RETURN ( cSql )

//---------------------------------------------------------------------------// 
