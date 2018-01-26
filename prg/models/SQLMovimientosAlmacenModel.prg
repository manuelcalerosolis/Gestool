#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenModel FROM SQLExportableModel

   DATA cTableName               INIT "movimientos_almacen"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid)"

   DATA cColumnOrder             INIT "id"

   DATA aTextoMovimiento         INIT { "Entre almacenes", "Regularización", "Objetivos", "Consolidación" }

   METHOD getColumns()

   METHOD getColumnMovimiento()  

   METHOD getInitialSelect()
   
   METHOD cTextoMovimiento()  

   METHOD getDeleteSentence( aId )

   METHOD loadDuplicateBuffer( id )                

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   ::getEmpresaColumns()

   hset( ::hColumns, "numero",            {  "create"    => "CHAR ( 50 )"                             ,;
                                             "default"   => {|| space( 50 ) } }                       )

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

   hset( ::hColumns, "comentarios",       {  "create"    => "VARCHAR ( 250 )"                         ,;
                                             "default"   => {|| space( 250 ) } }                      )

   ::getTimeStampColumns()   

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect()

   local cSelect     := "SELECT id, "                                            + ;
                           "numero, "                                            + ;
                           "uuid, "                                              + ;
                           "tipo_movimiento, "                                   + ;
                           ::getColumnMovimiento()                               + ;
                           "fecha_hora, "                                        + ;
                           "almacen_origen, "                                    + ;
                           "almacen_destino, "                                   + ;
                           "grupo_movimiento, "                                  + ;
                           "agente, "                                            + ;
                           "divisa, "                                            + ;
                           "divisa_cambio, "                                     + ;
                           "comentarios "                                        + ;        
                        "FROM " + ::getTableName()    

   logwrite( cSelect )

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD cTextoMovimiento( nPosition )

   DEFAULT nPosition := 1

   nPosition         := max( nPosition, 1 )
   nPosition         := min( nPosition, len( ::aTextoMovimiento ) )

RETURN ( ::aTextoMovimiento[ nPosition ] ) 

//---------------------------------------------------------------------------//

METHOD getDeleteSentence( aUuid )

   local aSQLDelete        := {}
   local aUuidLineasToDelete
   local aUuidSeriesToDelete

   aUuidLineasToDelete     := SQLMovimientosAlmacenLineasModel():aUuidToDelete( aUuid )

   aadd( aSQLDelete, ::Super:getDeleteSentence( aUuid ) )

   if !empty( aUuidLineasToDelete )
   
      aadd( aSQLDelete, SQLMovimientosAlmacenLineasModel():getDeleteSentence( aUuidLineasToDelete ) )

      aUuidSeriesToDelete  := SQLMovimientosAlmacenLineasNumerosSeriesModel():aUuidToDelete( aUuidLineasToDelete )

      if !empty( aUuidSeriesToDelete )
         aadd( aSQLDelete, SQLMovimientosAlmacenLineasNumerosSeriesModel():getDeleteSentence( aUuidSeriesToDelete ) )
      end if 

   end if 
   
RETURN ( aSQLDelete )

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

METHOD loadDuplicateBuffer( id )                

   ::Super:loadDuplicateBuffer( id )

   if hhaskey( ::hBuffer, "fecha_hora" )
      hset( ::hBuffer, "fecha_hora", hb_datetime() )
   end if 

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//
