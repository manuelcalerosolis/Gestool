#include "fivewin.ch"
#include "factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLBaseEmpresasModel FROM SQLBaseModel

   METHOD getColumns() 

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",          {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT"      ,;
                                       "text"      => "Identificador"                           ,;
                                       "header"    => "Id"                                      ,;
                                       "visible"   => .t.                                       ,;
                                       "width"     => 40 }                                      )   

   hset( ::hColumns, "uuid",        {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                       "text"      => "uuid"                                    ,;
                                       "header"    => "Uuid"                                    ,;
                                       "visible"   => .t.                                       ,;
                                       "hide"      => .t.                                       ,;
                                       "width"     => 240                                       ,;
                                       "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "empresa",     {  "create"    => "CHAR ( 4 ) NOT NULL"                     ,;
                                       "text"      => "Empresa"                                 ,;
                                       "visible"   => .f.                                       ,;
                                       "default"   => {|| cCodEmp() } }                         )

   hset( ::hColumns, "delegacion",  {  "create"    => "VARCHAR(2) NOT NULL"                     ,;
                                       "text"      => "Delegación"                              ,;
                                       "header"    => "Dlg."                                    ,;
                                       "visible"   => .t.                                       ,;
                                       "hide"      => .t.                                       ,;
                                       "width"     => 140                                       ,;
                                       "field"     => "cSufRem"                                 ,;
                                       "type"      => "C"                                       ,;
                                       "len"       => 2                                         ,;
                                       "default"   => {|| retSufEmp() } }                       )

   hset( ::hColumns, "usuario",     {  "create"    => "VARCHAR(3) NOT NULL"                     ,;
                                       "text"      => "usuario"                                 ,;
                                       "header"    => "Usuario"                                 ,;
                                       "visible"   => .t.                                       ,;
                                       "hide"      => .t.                                       ,;
                                       "width"     => 100                                       ,;
                                       "field"     => "cCodUsr"                                 ,;
                                       "type"      => "C"                                       ,;
                                       "len"       => 3                                         ,;
                                       "default"   => {|| cCurUsr() } }                         )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

