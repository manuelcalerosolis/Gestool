#include "fivewin.ch"
#include "factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLBaseEmpresasModel FROM SQLBaseModel

   METHOD CommunFields()

END CLASS

//---------------------------------------------------------------------------//

METHOD CommunFields()

   hset( ::hColumns, "empresa",     {  "create"    => "CHAR ( 4 ) NOT NULL"                     ,;
                                       "text"      => "Empresa"                                 ,;
                                       "visible"   => .f.                                       ,;
                                       "default"   => {|| cCodEmp() } }                         )

   hset( ::hColumns, "delegacion",  {  "create"    => "VARCHAR(2) NOT NULL"                     ,;
                                       "text"      => "Delegación"                              ,;
                                       "header"    => "Dlg."                                    ,;
                                       "visible"   => .f.                                       ,;
                                       "width"     => 40                                        ,;
                                       "field"     => "cSufRem"                                 ,;
                                       "type"      => "C"                                       ,;
                                       "len"       => 2                                         ,;
                                       "default"   => {|| retSufEmp() } }                       )

   hset( ::hColumns, "usuario",     {  "create"    => "VARCHAR(2) NOT NULL"                     ,;
                                       "text"      => "usuario"                                 ,;
                                       "header"    => "Usuario"                                 ,;
                                       "visible"   => .t.                                       ,;
                                       "width"     => 80                                        ,;
                                       "field"     => "cCodUsr"                                 ,;
                                       "type"      => "C"                                       ,;
                                       "len"       => 3                                         ,;
                                       "default"   => {|| cCurUsr() } }                         )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

