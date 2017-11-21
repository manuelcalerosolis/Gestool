#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLFiltrosModel FROM SQLBaseModel

   DATA cTableName               INIT "filtros"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",       {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT" ,;
                                    "text"		=> "Identificador"                      ,;
                                    "header"    => "Id"                                 ,;
                                    "visible"   => .t.                                  ,;
                                    "width"     => 40 }                                 )

   hset( ::hColumns, "tabla",    {  "create"    => "CHAR( 50 ) NOT NULL"                ,;
                                    "text"      => "Tabla"                              ,;
                                    "header"    => "Tabla"                              ,;
                                    "len"       => 50 }                                 ) 

   hset( ::hColumns, "nombre",   {  "create"    => "CHAR( 50 ) NOT NULL"                ,;
                                    "text"      => "Nombre de filtro"                   ,;
                                    "header"    => "Nombre"                             ,;
                                    "len"       => 50 }                                  )

   hset( ::hColumns, "filtro",   {  "create"    => "TEXT"                               ,;
                                    "text"      => "Sentencia filtro"                   ,;
                                    "header"    => "Filtro"                             ,;
                                    "len"       => 50 }                                  )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
