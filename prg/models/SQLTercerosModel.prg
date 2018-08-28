#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SQLTercerosModel FROM SQLCompanyModel

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (codigo)"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTercerosModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"        ,;
                                                "default"   => {|| 0 } }                              )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"        ,;
                                                "default"   => {|| win_uuidcreatestring() } }         )

   hset( ::hColumns, "codigo",               {  "create"    => "VARCHAR( 20 ) NOT NULL UNIQUE"        ,;
                                                "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "nombre",               {  "create"    => "VARCHAR( 140 )"                       ,;
                                                "default"   => {|| space( 140 ) } }                   )

   hset( ::hColumns, "dni",                  {  "create"    => "VARCHAR( 20 )"                        ,;
                                                "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "forma_pago_codigo",    {  "create"    => "VARCHAR( 20 )"                        ,;
                                                "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "web",                  {  "create"    => "VARCHAR( 150 )"                       ,;
                                                "default"   => {|| space( 150 ) } }                   )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//