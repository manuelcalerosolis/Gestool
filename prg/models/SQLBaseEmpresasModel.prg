#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseEmpresasModel FROM SQLBaseModel

   METHOD CommunFields()

   METHOD TimeStampFields()

END CLASS

//---------------------------------------------------------------------------//

METHOD CommunFields()

   ::hColumns              := {  "id"              => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"       ,;
                                                         "text"      => "Identificador"                           ,;
                                                         "header"    => "Id"                                      ,;
                                                         "visible"   => .f.}                                      ,;
                                 "empresa"         => {  "create"    => "CHAR ( 4 ) NOT NULL"                     ,;
                                                         "text"      => "Empresa"                                 ,;
                                                         "visible"   => .f.                                       ,;
                                                         "default"   => {|| cCodEmp() } }                         ,;
                                 "delegacion"      => {  "create"    => "VARCHAR(2) NOT NULL"                     ,;
                                                         "text"      => "Delegación"                              ,;
                                                         "header"    => "Dlg."                                    ,;
                                                         "visible"   => .t.                                       ,;
                                                         "width"     => 40                                        ,;
                                                         "field"     => "cSufRem"                                 ,;
                                                         "type"      => "C"                                       ,;
                                                         "len"       => 2                                         ,;
                                                         "default"   => {|| retSufEmp() } }                       ,;
                                 "usuario"         => {  "create"    => "VARCHAR(2) NOT NULL"                     ,;
                                                         "text"      => "usuario"                                 ,;
                                                         "header"    => "Usr."                                    ,;
                                                         "visible"   => .t.                                       ,;
                                                         "width"     => 40                                        ,;
                                                         "field"     => "cCodUsr"                                 ,;
                                                         "type"      => "C"                                       ,;
                                                         "len"       => 2                                         ,;
                                                         "default"   => {|| cCurUsr() } }                         }

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD TimeStampFields()

   hset( ::hColumns, "creacion_timestamp",   {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"      ,;
                                                "text"      => "Creación fecha y hora"                   ,;
                                                "header"    => "Creación" }                               )


RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

