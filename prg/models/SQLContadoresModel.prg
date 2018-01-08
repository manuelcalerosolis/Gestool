#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLContadoresModel FROM SQLExportableModel

   DATA cTableName            INIT "contadores"

   DATA cConstraints          INIT "PRIMARY KEY (id)"

   DATA cColumnOrder          INIT "id"

   METHOD getColumns()

   METHOD getInitialSelect()
   
END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",          {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                       "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "empresa",     {  "create"    => "CHAR ( 4 ) NOT NULL"                     ,;
                                       "default"   => {|| cCodEmp() } }                         )

   hset( ::hColumns, "delegacion",  {  "create"    => "VARCHAR(2) NOT NULL"                     ,;
                                       "default"   => {|| retSufEmp() } }                       )

   hset( ::hColumns, "tabla",       {  "create"    => "VARCHAR ( 250 )"                         ,;
                                       "default"   => {|| space( 250 ) } }                      )

   hset( ::hColumns, "serie",       {  "create"    => "VARCHAR ( 1 )"                           ,;
                                       "default"   => {|| space( 1 ) } }                        )

   hset( ::hColumns, "value",       {  "create"    => "INT UNSIGNED NOT NULL"                   ,;
                                       "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect()

   local cSelect     := "SELECT * FROM " + ::getTableName()    

RETURN ( cSelect )

//---------------------------------------------------------------------------//

