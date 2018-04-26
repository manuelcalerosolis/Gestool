#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenModel FROM SQLExportableModel

   DATA cTableName               INIT "movimientos_almacen"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid, empresa_uuid, usuario_uuid)"

   DATA aTextoMovimiento         INIT { 'Entre almacenes', 'Regularización', 'Objetivos', 'Consolidación', 'Vacio' }
 
   METHOD getColumns()

   METHOD getColumnMovimiento()  

   METHOD getInitialSelect()

   METHOD getGroupBy()           INLINE ( "GROUP BY movimientos_almacen.id " )
   
   METHOD getDeleteSentenceById( aId )

   METHOD loadDuplicateBuffer( id )                

   METHOD getInsertSentence( hBuffer )

   METHOD assingNumber()

   METHOD cTextoMovimiento( nTipoMovimiento ) ;
                                 INLINE ( ::aTextoMovimiento[ minmax( nTipoMovimiento, 1, len( ::aTextoMovimiento ) ) ] )

   METHOD Syncronize()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()
   
   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   ::getEmpresaColumns()

   hset( ::hColumns, "empresa",           {  "create"    => "VARCHAR( 4 )"                            ,;
                                             "default"   => {|| space( 4 ) } }                        )

   hset( ::hColumns, "numero",            {  "create"    => "CHAR ( 50 )"                             ,;
                                             "default"   => {|| MovimientosAlmacenRepository():getNextNumber() } }                       )

   hset( ::hColumns, "fecha_hora",        {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"      ,;
                                             "default"   => {|| hb_datetime() } }                     )

   hset( ::hColumns, "tipo_movimiento",   {  "create"    => "TINYINT UNSIGNED NOT NULL"               ,;
                                             "default"   => {|| 1 } }                                 )

   hset( ::hColumns, "almacen_origen",    {  "create"    => "CHAR ( 16 )"                             ,;
                                             "default"   => {|| space( 16 ) } }                       )

   hset( ::hColumns, "almacen_destino",   {  "create"    => "CHAR ( 16 )"                             ,;
                                             "default"   => {|| space( 16 ) } }                       )

   hset( ::hColumns, "grupo_movimiento",  {  "create"    => "CHAR ( 2 )"                              ,;
                                             "default"   => {|| space( 2 ) } }                        )

   hset( ::hColumns, "divisa",            {  "create"    => "CHAR ( 3 )"                              ,;
                                             "default"   => {|| cDivEmp() } }                         )

   hset( ::hColumns, "divisa_cambio",     {  "create"    => "DECIMAL( 16, 6 )"                        ,;
                                             "default"   => {|| 1 } }                                 )

   hset( ::hColumns, "comentarios",       {  "create"    => "TEXT"                                    ,;
                                             "default"   => {|| "" } }                                )

   ::getDateTimeColumns()   

   ::getTimeStampSentColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect()
   
   local cSelect  

   cSelect  := "SELECT "                                                                  + ;
                  "movimientos_almacen.id                         AS id, "                + ;
                  "movimientos_almacen.uuid                       AS uuid, "              + ;
                  "movimientos_almacen.numero                     AS numero, "            + ;
                  "movimientos_almacen.tipo_movimiento            AS tipo_movimiento, "   + ;
                  ::getColumnMovimiento( "movimientos_almacen" )                          + ;
                  "movimientos_almacen.fecha_hora                 AS fecha_hora, "        + ;
                  "movimientos_almacen.almacen_origen             AS almacen_origen, "    + ;
                  "movimientos_almacen.almacen_destino            AS almacen_destino, "   + ;
                  "movimientos_almacen.grupo_movimiento           AS grupo_movimiento, "  + ;
                  SQLMovimientosAlmacenLineasModel():getSQLSubSentenceSumatorioTotalPrecioLinea( "movimientos_almacen_lineas" ) + ", " +;
                  "movimientos_almacen.divisa                     AS divisa, "            + ;
                  "movimientos_almacen.divisa_cambio              AS divisa_cambio, "     + ;
                  "movimientos_almacen.comentarios                AS comentarios, "       + ;        
                  "movimientos_almacen.creado                     AS creado, "            + ;
                  "movimientos_almacen.modificado                 AS modificado, "        + ;
                  "movimientos_almacen.enviado                    AS enviado "            + ;  
               "FROM " + ::getTableName() + " "                                           + ;
                  "INNER JOIN movimientos_almacen_lineas "                                + ;
                  "ON movimientos_almacen.uuid = movimientos_almacen_lineas.parent_uuid " 

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getColumnMovimiento( cTable )  

   local cSql  

   DEFAULT cTable := ""

   if !empty( cTable )
      cTable      += "."
   end if

   cSql           := "CASE "                                                                                                  
   cSql           +=    "WHEN " + cTable + "tipo_movimiento = 1 THEN '" + ::aTextoMovimiento[ 1 ] + "'" 
   cSql           +=    "WHEN " + cTable + "tipo_movimiento = 2 THEN '" + ::aTextoMovimiento[ 2 ] + "'" 
   cSql           +=    "WHEN " + cTable + "tipo_movimiento = 3 THEN '" + ::aTextoMovimiento[ 3 ] + "'" 
   cSql           +=    "WHEN " + cTable + "tipo_movimiento = 4 THEN '" + ::aTextoMovimiento[ 4 ] + "'" 
   cSql           +=    "ELSE '"                                        + ::aTextoMovimiento[ 5 ] + "'" 
   cSql           += "END as nombre_movimiento, "

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getDeleteSentenceById( aIds, aUuids )

   local aSQLDelete        := {}
   local aUuidLineasToDelete
   local aUuidSeriesToDelete

   aadd( aSQLDelete, ::Super:getDeleteSentenceById( aIds ) )

   aUuidLineasToDelete     := SQLMovimientosAlmacenLineasModel():aUuidToDelete( aUuids )

   if empty( aUuidLineasToDelete )
      RETURN ( aSQLDelete )
   end if 
   
   aadd( aSQLDelete, SQLMovimientosAlmacenLineasModel():getDeleteSentenceByUuid( aUuidLineasToDelete ) )

   aUuidSeriesToDelete     := SQLMovimientosAlmacenLineasNumerosSeriesModel():aUuidToDelete( aUuidLineasToDelete )

   if empty( aUuidSeriesToDelete )
      RETURN ( aSQLDelete )
   end if 

   aadd( aSQLDelete, SQLMovimientosAlmacenLineasNumerosSeriesModel():getDeleteSentenceByUuid( aUuidSeriesToDelete ) )

RETURN ( aSQLDelete )

//---------------------------------------------------------------------------//

METHOD loadDuplicateBuffer( id )         

   local originalUuid   
   local duplicatedUuid 
   
   ::Super:loadDuplicateBuffer( id )

   originalUuid         := hget( ::hBuffer, "uuid" )       

   hset( ::hBuffer, "numero", MovimientosAlmacenRepository():getNextNumber() )

   hset( ::hBuffer, "fecha_hora", hb_datetime() )

   duplicatedUuid       := hget( ::hBuffer, "uuid" )       

   SQLMovimientosAlmacenLineasModel():duplicateByUuid( originalUuid, duplicatedUuid )

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD getInsertSentence( hBuffer )

   DEFAULT hBuffer   := ::hBuffer

   ::assingNumber( hBuffer )

   ::Super:getInsertSentence( hBuffer )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD assingNumber( hBuffer )

   local cNumero     := hget( hBuffer, "numero" )

   if empty( cNumero )
      RETURN ( .f. )
   end if 

   while !empty( MovimientosAlmacenRepository():getIdByNumber( cNumero ) )
      cNumero        := nextDocumentNumber( cNumero )
   end while

   hset( hBuffer, "numero", cNumero )

RETURN ( .t. )

//---------------------------------------------------------------------------//
// Actualizar datos de empresa----------------------------------------------
//---------------------------------------------------------------------------//

METHOD Syncronize()

   local cSql       
   local cEmpresaTableName := SQLEmpresasModel():cTableName       

   cSql                    := "UPDATE " + ::cTableName + " "
   cSql                    +=    "INNER JOIN " + cEmpresaTableName + " ON " + ::cTableName + ".empresa = " + cEmpresaTableName + ".codigo "
   cSql                    += "SET " + ::cTableName + ".empresa_uuid = " + cEmpresaTableName + ".uuid "
   cSql                    +=    "WHERE " + ::cTableName + ".empresa_uuid = '' "

   msgalert( cSql, "cSql" )
   logwrite( cSql )

   getSQLDatabase():Exec( cSql )

RETURN ( .t. )

//---------------------------------------------------------------------------//

