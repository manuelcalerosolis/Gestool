#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenModel FROM SQLExportableModel

   DATA cTableName               INIT "movimientos_almacen"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

   METHOD getColumnMovimiento()  

   METHOD getInitialSelect()
   
   METHOD getDeleteSentenceById( aId )

   METHOD loadDuplicateBuffer( id )                

   METHOD getInsertSentence( hBuffer )

   METHOD assingNumber()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   ::getEmpresaColumns()

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

   hset( ::hColumns, "agente",            {  "create"    => "CHAR ( 3 )"                              ,;
                                             "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "divisa",            {  "create"    => "CHAR ( 3 )"                              ,;
                                             "default"   => {|| cDivEmp() } }                         )

   hset( ::hColumns, "divisa_cambio",     {  "create"    => "DECIMAL( 16, 6 )"                        ,;
                                             "default"   => {|| 1 } }                                 )

   hset( ::hColumns, "comentarios",       {  "create"    => "TEXT"                                    ,;
                                             "default"   => {|| "" } }                                )

   ::getTimeStampColumns()   

   ::getTimeStampSentColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect()

   local cSelect     := "SELECT "                                                         + ;
                           "movimientos_almacen.id                         AS id, "       + ;
                           "movimientos_almacen.numero                     AS numero, "   + ;
                           "movimientos_almacen.uuid, "                       + ;
                           "movimientos_almacen.tipo_movimiento, "            + ;
                           ::getColumnMovimiento( "movimientos_almacen" )     + ;
                           "movimientos_almacen.fecha_hora, "                 + ;
                           "movimientos_almacen.almacen_origen, "             + ;
                           "movimientos_almacen.almacen_destino, "            + ;
                           "movimientos_almacen.grupo_movimiento, "           + ;
                           "movimientos_almacen.agente, "                     + ;
                           "movimientos_almacen.divisa, "                     + ;
                           "movimientos_almacen.divisa_cambio, "              + ;
                           "movimientos_almacen.comentarios,"                 + ;        
                           "movimientos_almacen.creado, "                     + ;
                           "movimientos_almacen.modificado, "                 + ;
                           "movimientos_almacen.enviado "                     + ;  
                        "FROM " + ::getTableName() + " "                      + ;
                           "INNER JOIN movimientos_almacen_lineas "           + ;
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
   cSql           +=    "WHEN " + cTable + "tipo_movimiento = 1 THEN 'Entre almacenes' " 
   cSql           +=    "WHEN " + cTable + "tipo_movimiento = 2 THEN 'Regularización' " 
   cSql           +=    "WHEN " + cTable + "tipo_movimiento = 3 THEN 'Objetivos' " 
   cSql           +=    "WHEN " + cTable + "tipo_movimiento = 4 THEN 'Consolidación' " 
   cSql           +=    "ELSE 'Vacio' "
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

   ::Super:loadDuplicateBuffer( id )

   hset( ::hBuffer, "numero", MovimientosAlmacenRepository():getNextNumber() )

   hset( ::hBuffer, "fecha_hora", hb_datetime() )

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD getInsertSentence( hBuffer )

   DEFAULT hBuffer   := ::hBuffer

   ::assingNumber( hBuffer )

   ::Super:getInsertSentence( hBuffer )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD assingNumber( hBuffer )

   local cNumero  := hget( hBuffer, "numero" )

   if empty( cNumero )
      RETURN ( .f. )
   end if 

   while !empty( MovimientosAlmacenRepository():getIdByNumber( cNumero ) )
      cNumero     := nextDocumentNumber( cNumero )
   end while

   hset( hBuffer, "numero", cNumero )

RETURN ( .t. )

//---------------------------------------------------------------------------//
