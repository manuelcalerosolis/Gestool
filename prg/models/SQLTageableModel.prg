#include "fivewin.ch"

//---------------------------------------------------------------------------//

CLASS SQLTageableModel FROM SQLBaseModel

   DATA cTableName                     INIT "Tageables"

   DATA cConstraints                   INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"            ,;
                                          "default"   => {|| 0 } }                           )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"     ,;
                                          "default"   => {|| win_uuidcreatestring() } }      )

   hset( ::hColumns, "tag_uuid",       {  "create"    => "VARCHAR( 40 ) NOT NULL"            ,;
                                          "default"   => {|| space( 40 ) } }                 )

   hset( ::hColumns, "tageable_type",  {  "create"    => "VARCHAR( 50 )"                     ,;
                                          "default"   => {|| space( 50 ) } }                 )

   hset( ::hColumns, "tageable_uuid",  {  "create"    => "VARCHAR( 40 ) NOT NULL"            ,;
                                          "default"   => {|| space( 40 ) } }                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

