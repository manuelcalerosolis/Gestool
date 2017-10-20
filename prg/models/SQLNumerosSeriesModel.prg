#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLNumerosSeriesModel FROM SQLBaseEmpresasModel

   DATA cTableName            INIT "numeros_series" 

   METHOD New()
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   hset( ::hColumns, "id",                {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT"      ,;
                                             "text"      => "Identificador"                           ,;
                                             "header"    => "Id"                                      ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 40 }                                      )   

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                             "text"      => "Uuid"                                    ,;
                                             "header"    => "Uuid"                                    ,;
                                             "visible"   => .f.                                       ,;
                                             "width"     => 240                                       ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                             "text"      => "parent_uuid"                             ,;
                                             "header"    => "Parent uuid"                             ,;
                                             "visible"   => .f.                                       ,;
                                             "width"     => 240 }                                     )

   hset( ::hColumns, "numero_serie",      {  "create"    => "VARCHAR(30) NOT NULL"                    ,;
                                             "text"      => "Número serie"                            ,;
                                             "header"    => "Número serie"                            ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 120 }                                     )

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

