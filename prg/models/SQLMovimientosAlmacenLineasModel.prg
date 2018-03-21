#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenLineasModel FROM SQLExportableModel

   DATA cTableName            INIT  "movimientos_almacen_lineas"

   DATA cTableTemporal        

   DATA cConstraints          INIT  "PRIMARY KEY ( id ), "                       + ; 
                                       "KEY ( uuid ), "                          + ;
                                       "KEY ( parent_uuid ), "                   + ;
                                       "KEY ( codigo_articulo ) "               

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

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT"         ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"    ,;
                                                      "default"   => {|| win_uuidcreatestring() } }   )

   hset( ::hColumns, "parent_uuid",                {  "create"    => "VARCHAR(40) NOT NULL"           ,;
                                                      "default"   => {|| space(40) } }                )

   hset( ::hColumns, "codigo_articulo",            {  "create"    => "VARCHAR(18) NOT NULL"           ,;
                                                      "default"   => {|| space(18) } }                )

   hset( ::hColumns, "nombre_articulo",            {  "create"    => "VARCHAR(250) NOT NULL"          ,;
                                                      "default"   => {|| space(250) } }               )

   hset( ::hColumns, "codigo_primera_propiedad",   {  "create"    => "VARCHAR(20)"                    ,;
                                                      "default"   => {|| space(20) } }                )

   hset( ::hColumns, "valor_primera_propiedad",    {  "create"    => "VARCHAR(200)"                   ,;
                                                      "default"   => {|| space(200) } }               )

   hset( ::hColumns, "codigo_segunda_propiedad",   {  "create"    => "VARCHAR(20)"                    ,;
                                                      "default"   => {|| space(20) } }                )

   hset( ::hColumns, "valor_segunda_propiedad",    {  "create"    => "VARCHAR(200)"                   ,;
                                                      "default"   => {|| space(200) } }               )

   hset( ::hColumns, "fecha_caducidad",            {  "create"    => "DATE"                           ,;
                                                      "default"   => {|| ctod('') } }                 )

   hset( ::hColumns, "lote",                       {  "create"    => "VARCHAR(40)"                    ,;
                                                      "default"   => {|| space(40) } }                )

   hset( ::hColumns, "bultos_articulo",            {  "create"    => "DECIMAL(19,6)"                  ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "cajas_articulo",             {  "create"    => "DECIMAL(19,6)"                  ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "unidades_articulo",          {  "create"    => "DECIMAL(19,6)"                  ,;
                                                      "default"   => {|| 1 } }                        )

   hset( ::hColumns, "precio_articulo",            {  "create"    => "DECIMAL(19,6)"                  ,;
                                                      "default"   => {|| 0 } }                        )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect()

   local cSelect  := "SELECT id, "                                            + ;
                        "uuid, "                                              + ;
                        "parent_uuid, "                                       + ;
                        "codigo_articulo, "                                   + ;
                        "nombre_articulo, "                                   + ;
                        "codigo_primera_propiedad, "                          + ;
                        "valor_primera_propiedad, "                           + ;
                        "codigo_segunda_propiedad, "                          + ;
                        "valor_segunda_propiedad, "                           + ;
                        "fecha_caducidad, "                                   + ;
                        "lote, "                                              + ;
                        "bultos_articulo, "                                   + ;
                        "cajas_articulo, "                                    + ;
                        "unidades_articulo, "                                 + ;
                        ::getSQLSubSentenceTotalUnidadesLinea() + ", "        + ;
                        "precio_articulo, "                                   + ;
                        ::getSQLSubSentenceTotalPrecioLinea()                 + ;
                     "FROM " + ::getTableName()    

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getInsertSentence()

   local nId

   nId            := ::getIdProductAdded()

   if empty( nId )
      RETURN ( ::Super:getInsertSentence() )
   end if 

   ::setSQLInsert( ::getUpdateUnitsSentece( nId ) )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addInsertSentence( aSQLInsert, oProperty )

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

METHOD addUpdateSentence( aSQLUpdate, oProperty )

   aadd( aSQLUpdate, "UPDATE " + ::cTableName + " " +                                                       ;
                        "SET unidades_articulo = " + toSqlString( oProperty:Value )                + ", " + ;
                        "precio_articulo = " + toSqlString( hget( ::hBuffer, "precio_articulo" ) ) + " " +  ;
                        "WHERE uuid = " + quoted( oProperty:Uuid ) +  "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addDeleteSentence( aSQLUpdate, oProperty )

   aadd( aSQLUpdate, "DELETE FROM " + ::cTableName + " " +                          ;
                        "WHERE uuid = " + quoted( oProperty:Uuid ) + "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addDeleteSentenceById( aSQLUpdate, nId )

   aadd( aSQLUpdate, "DELETE FROM " + ::cTableName + " " +                          ;
                        "WHERE id = " + quoted( nId ) + "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteWhereUuid( uuid )

   local cSentence   := "DELETE FROM " + ::cTableName + " " + ;
                           "WHERE parent_uuid = " + quoted( uuid )

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD aUuidToDelete( aParentsUuid )

   local cSentence   

   cSentence            := "SELECT uuid FROM " + ::cTableName + " "
   cSentence            +=    "WHERE parent_uuid IN ( " 

   aeval( aParentsUuid, {| v | cSentence += toSQLString( v ) + ", " } )

   cSentence            := chgAtEnd( cSentence, ' )', 2 )

RETURN ( ::getDatabase():selectFetchArray( cSentence ) )

//---------------------------------------------------------------------------//

METHOD getDeleteSentenceFromParentsUuid( aParentsUuid )

   local aUuid       := ::aUuidToDelete( aParentsUuid )

   if !empty( aUuid )
      RETURN ::getDeleteSentence( aUuid )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD getSQLSubSentenceTotalUnidadesLinea( cTable, cAs )

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

METHOD getSQLSubSentenceTotalPrecioLinea( cTable, cAs )

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

METHOD getSQLSubSentenceSumatorioUnidadesLinea( cTable, cAs )

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

METHOD getSQLSubSentenceSumatorioTotalPrecioLinea( cTable, cAs )

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

METHOD getSentenceNotSent( aFetch )

   local cSentence   := "SELECT * FROM " + ::cTableName + " "

   cSentence         +=    "WHERE parent_uuid IN ( " 

   aeval( aFetch, {|h| cSentence += toSQLString( hget( h, "uuid" ) ) + ", " } )

   cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getIdProductAdded()

   local aId         := MovimientosAlmacenLineasRepository():getIdFromBuffer( ::hBuffer )

   if !empty( aId )
      RETURN( hget( atail( aId ), "id" ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getUpdateUnitsSentece( id )
   
   local cSentence   := "UPDATE " + ::cTableName                                                                                    + " " +  ;
                           "SET unidades_articulo = unidades_articulo + " + toSQLString( hget( ::hBuffer, "unidades_articulo" ) )   + " " +  ;
                        "WHERE id = " + quoted( id )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD createTemporalTableWhereUuid( originalUuid )

   local cSentence

   ::cTableTemporal  := ::cTableName + hb_ttos( hb_datetime() )

   cSentence         := "CREATE TEMPORARY TABLE " + ::cTableTemporal          + " "
   cSentence         +=    "SELECT * from " + ::cTableName                    + " " 
   cSentence         += "WHERE parent_uuid = " + quoted( originalUuid )       + "; "

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD alterTemporalTableWhereUuid()

   local cSentence

   cSentence         := "ALTER TABLE " + ::cTableTemporal + " DROP id"

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD replaceUuidInTemporalTable( duplicatedUuid )

   local cSentence

   cSentence         := "UPDATE " + ::cTableTemporal                          + " "
   cSentence         +=    "SET id = 0"                                       + ", "
   cSentence         +=       "uuid = UUID()"                                 + ", "
   cSentence         +=       "parent_uuid = " + quoted( duplicatedUuid )    

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD insertTemporalTable()

   local cSentence

   cSentence         := "INSERT INTO " + ::cTableName                         + " "
   cSentence         +=    "SELECT * FROM " + ::cTableTemporal

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD dropTemporalTable()

   local cSentence

   cSentence         := "DROP TABLE " + ::cTableTemporal           

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD duplicateByUuid( originalUuid, duplicatedUuid )

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
