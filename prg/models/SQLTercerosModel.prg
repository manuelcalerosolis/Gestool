#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SQLTercerosModel FROM SQLBaseModel

   DATA cTableName               INIT "terceros"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (codigo)"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTercerosModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER UNIQUE AUTO_INCREMENT"        ,;
                                          "text"      => "Identificador"                        ,;
                                          "default"   => {|| 0 } }                              )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"        ,;
                                          "text"      => "Uuid"                                 ,;
                                          "default"   => {|| win_uuidcreatestring() } }         )

   ::getEmpresaColumns()

   hset( ::hColumns, "codigo",         {  "create"    => "VARCHAR( 12 )"                        ,;
                                          "default"   => {|| space( 12 ) } }                    )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR( 140 )"                       ,;
                                          "default"   => {|| space( 140 ) } }                   )

   hset( ::hColumns, "dni",            {  "create"    => "VARCHAR( 20 )"                        ,;
                                          "default"   => {|| space( 20 ) } }                    )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//