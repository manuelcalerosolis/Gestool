#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLSeteableModel FROM SQLBaseModel

   DATA cTableName               INIT "Seteable"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLSeteableModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "setting_uuid",   {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "setting_value",  {  "create"    => "VARCHAR(10)"                             ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "seteable_type",  {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "seteable_uuid",  {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                          "default"   => {|| space( 40 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

