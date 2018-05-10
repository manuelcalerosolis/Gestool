#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosPreciosValidator

   ::hValidators  := {  "nombre" =>    {  "required"  => "El nombre es un dato requerido",;
                                          "unique"    => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"  => "El código es un dato requerido" ,;
                                          "unique"    => "El código introducido ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosPreciosModel FROM SQLBaseModel

   DATA cTableName               INIT "articulos_precios"

   DATA cConstraints             INIT "PRIMARY KEY ( id ), UNIQUE KEY ( tarifa_uuid, articulo_uuid )"

   METHOD getColumns()

   METHOD getSQLInsertPreciosWhereTarifa( uuidTarifa )

   METHOD insertPreciosWhereTarifa( uuidTarifa )        INLINE ( ::getDatabase():Execs( ::getSQLInsertPreciosWhereTarifa( uuidTarifa ) ) )

   METHOD getSQLInsertPreciosWhereArticulo( uuidArticulo )

   METHOD insertPreciosWhereArticulo( uuidArticulo )     INLINE ( ::getDatabase():Execs( ::getSQLInsertPreciosWhereArticulo( uuidArticulo ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosPreciosModel
   
   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "tarifa_uuid",                {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulo_uuid",              {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "margen",                     {  "create"    => "FLOAT( 8, 4 )"                           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "precio_base",                {  "create"    => "FLOAT( 16, 6 )"                          ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "precio_iva_incluido",        {  "create"    => "FLOAT( 16, 6 )"                          ,;
                                                      "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getSQLInsertPreciosWhereTarifa( uuidTarifa )

   local cSQL

   cSQL           := "INSERT IGNORE INTO articulos_precios"                                                                + " "  
   cSQL           +=    "( uuid, tarifa_uuid, articulo_uuid, margen, precio_base, precio_iva_incluido )"                   + " "  
   cSQL           += "SELECT uuid(), articulos_tarifas.uuid, articulos.uuid, articulos_tarifas.margen_predefinido, 0, 0"   + " "  
   cSQL           +=    "FROM articulos"                                                                                   + " "  
   cSQL           += "INNER JOIN articulos_tarifas ON articulos_tarifas.empresa_uuid = articulos.empresa_uuid"             + " "  
   cSQL           += "WHERE articulos.empresa_uuid = " + quoted( Company():Uuid() )                                        + " "
   cSQL           +=    "AND articulos_tarifas.uuid = " + quoted( uuidTarifa )

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD getSQLInsertPreciosWhereArticulo( uuidArticulo )

   local cSQL

   cSQL           := "INSERT IGNORE INTO articulos_precios"                                                                + " "  
   cSQL           +=    "( uuid, tarifa_uuid, articulo_uuid, margen, precio_base, precio_iva_incluido )"                   + " "  
   cSQL           += "SELECT uuid(), articulos_tarifas.uuid, " + quoted( uuidArticulo ) + ", articulos_tarifas.margen_predefinido, 0, 0"   + " "  
   cSQL           +=    "FROM articulos_tarifas"                                                                           + " "  
   cSQL           += "WHERE articulos_tarifas.empresa_uuid = " + quoted( Company():Uuid() )                                 

   msgalert( cSQL, "cSQL" )

RETURN ( cSQL )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosPreciosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosPreciosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

