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
                                       "KEY ( articulo_codigo ) "              

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getInsertSentence()

   METHOD addInsertSentence()

   METHOD addUpdateSentence()
   
   METHOD addDeleteSentence()

   METHOD addDeleteSentenceById()

   METHOD deleteWhereUuid( uuid )

   METHOD aUuidToDelete( uuid )

   METHOD getDeleteSentenceFromParentsUuid()

   METHOD getSQLSubSentenceTotalUnidadesLinea( cTable, cAs )

   METHOD getSQLSubSentenceTotalPrecioLinea( cTable, cAs )

   METHOD getSQLSubSentenceSumatorioUnidadesLinea( cTable, cAs )

   METHOD getSQLSubSentenceSumatorioTotalPrecioLinea( cTable, cAs )

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

   METHOD countLinesWhereUuidParent( uuidParent )  INLINE ( getSQLDatabase():getValue( ::getSentenceCountLineas( uuidParent ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFacturasClientesLineasModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT"         ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"    ,;
                                                      "default"   => {|| win_uuidcreatestring() } }   )

   hset( ::hColumns, "parent_uuid",                {  "create"    => "VARCHAR(40) NOT NULL"           ,;
                                                      "default"   => {|| ::getSenderControllerParentUuid() } } )

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

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLFacturasClientesLineasModel

   local cSql

   TEXT INTO cSql

      SELECT 
         facturas_clientes_lineas.id,
         facturas_clientes_lineas.uuid,                                                        
         facturas_clientes_lineas.parent_uuid,                                                 
         articulo_codigo,                                             
         articulo_nombre,                                             
         fecha_caducidad,                                             
         lote,                                                        
         articulo_unidades,                                           
         unidad_medicion_factor,                                      
         ( @total_unidades := articulo_unidades * unidad_medicion_factor ) as total_unidades, 
         articulo_precio,                                             
         ( @total_bruto := ROUND( @total_unidades * articulo_precio, 2 ) ) as total_bruto,
         unidad_medicion_codigo,                                      
         descuento,       
         ( @importe_descuento := IF( descuento IS NULL OR descuento = 0, 0, @total_bruto * descuento / 100 ) ),
         ( @total_bruto - @importe_descuento ) AS total_precio,
         incremento_precio,
         iva,
         recargo_equivalencia,
         almacen_codigo,
         almacenes.nombre AS almacen_nombre,
         agente_codigo,
         agentes.nombre AS agente_nombre,
         agente_comision
         
      FROM %1$s AS facturas_clientes_lineas

      LEFT JOIN %2$s AS almacenes
         ON almacenes.codigo = facturas_clientes_lineas.almacen_codigo

      LEFT JOIN %3$s AS agentes
         ON agentes.codigo = facturas_clientes_lineas.agente_codigo   

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLAlmacenesModel():getTableName(), SQLAgentesModel():getTableName() )

   logwrite( cSql )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getInsertSentence() CLASS SQLFacturasClientesLineasModel

   local nId

   nId            := ::getIdProductAdded()

   if empty( nId )
      RETURN ( ::Super:getInsertSentence() )
   end if 

   ::setSQLInsert( ::getUpdateUnitsSentece( nId ) )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addInsertSentence( aSQLInsert, oProperty ) CLASS SQLFacturasClientesLineasModel

   if empty( oProperty:Value )
      RETURN ( nil )
   end if

   hset( ::hBuffer, "uuid",                     win_uuidcreatestring() )
   hset( ::hBuffer, "codigo_primera_propiedad", oProperty:cCodigoPropiedad1 )
   hset( ::hBuffer, "valor_primera_propiedad",  oProperty:cValorPropiedad1 )
   hset( ::hBuffer, "codigo_segunda_propiedad", oProperty:cCodigoPropiedad2 )
   hset( ::hBuffer, "valor_segunda_propiedad",  oProperty:cValorPropiedad2 )
   hset( ::hBuffer, "unidades_articulo",        oProperty:Value )

   aadd( aSQLInsert, ::Super:getInsertSentence() + "; " )

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

METHOD getSQLSubSentenceTotalUnidadesLinea( cTable, cAs ) CLASS SQLFacturasClientesLineasModel

   DEFAULT cTable    := ""
   DEFAULT cAs       := "total_unidades"
   
   if !empty( cTable )
      cTable         += "."
   end if 

   if lCalCaj()   
      RETURN ( "( IF( " + cTable + "cajas_articulo = 0, 1, " + cTable + "cajas_articulo ) * " + cTable + "unidades_articulo ) AS " + cAs + " " )
   end if 

RETURN ( cTable + "unidades_articulo AS " + cAs + " " )

//---------------------------------------------------------------------------//

METHOD getSQLSubSentenceTotalPrecioLinea( cTable, cAs ) CLASS SQLFacturasClientesLineasModel

   DEFAULT cTable    := ""
   DEFAULT cAs       := "total_precio"

   if !empty( cTable )
      cTable         += "."
   end if 

   if lCalCaj()   
      RETURN ( "( IF( " + cTable + "cajas_articulo = 0, 1, " + cTable + "cajas_articulo ) * " + cTable + "unidades_articulo * " + cTable + "precio_articulo ) AS " + cAs + " " )
   end if 

RETURN ( cTable + "unidades_articulo * " + cTable + "precio_articulo AS " + cAs + " " )

//---------------------------------------------------------------------------//

METHOD getSQLSubSentenceSumatorioUnidadesLinea( cTable, cAs ) CLASS SQLFacturasClientesLineasModel

   DEFAULT cAs       := "total_unidades"

   if empty( cTable )
      cTable         := ""
   else
      cTable         += "."
   end if

   if lCalCaj()   
      RETURN ( "SUM( IF( " + cTable + "cajas_articulo = 0, 1, " + cTable + "cajas_articulo ) * " + cTable + "unidades_articulo ) AS " + cAs + " " )
   end if 

RETURN ( "SUM( " + cTable + "unidades_articulo ) AS " + cAs + " " )

//---------------------------------------------------------------------------//

METHOD getSQLSubSentenceSumatorioTotalPrecioLinea( cTable, cAs ) CLASS SQLFacturasClientesLineasModel

   DEFAULT cAs       := "total_precio"

   if empty( cTable )
      cTable         := ""
   else
      cTable         += "."
   end if

   if lCalCaj()   
      RETURN ( "SUM( IF( " + cTable + "cajas_articulo = 0, 1, " + cTable + "cajas_articulo ) * " + cTable + "unidades_articulo * " + cTable + "precio_articulo ) AS " + cAs + " " )
   end if 

RETURN ( "SUM( " + cTable + "unidades_articulo * " + cTable + "precio_articulo ) AS " + cAs + " " )

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

   local cSentence

   cSentence         := "ALTER TABLE " + ::cTableTemporal + " DROP id"

RETURN ( ::getDatabase():Exec( cSentence ) )

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

   local cSentence

   cSentence         := "DROP TABLE " + ::cTableTemporal           

RETURN ( ::getDatabase():Exec( cSentence ) )

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

METHOD getSentenceCountLineas( UuidParent ) CLASS SQLFacturasClientesLineasModel

   local cSql

   TEXT INTO cSql

      SELECT COUNT(*)

      FROM %1$s AS facturas_clientes_lineas

      WHERE facturas_clientes_lineas.parent_uuid = %2$s  

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( UuidParent ) )

RETURN ( cSql )

//---------------------------------------------------------------------------// 

