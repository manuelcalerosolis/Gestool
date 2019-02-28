#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLTiposVentasModel FROM SQLCompanyModel

   DATA     cTableName                 INIT "tipos_ventas"

   METHOD   getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"            ,;
                                          "default"   => {|| 0 } }                           )

   hset( ::hColumns, "codigo",         {  "create"    => "VARCHAR ( 20 ) NOT NULL UNIQUE"     ,;
                                          "default"   => {|| space( 20 ) } }      )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR( 50 ) NOT NULL UNIQUE"     ,;
                                          "default"   => {|| space( 50 ) } }      )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

