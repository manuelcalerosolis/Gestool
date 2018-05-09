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

   METHOD getColumns()

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

