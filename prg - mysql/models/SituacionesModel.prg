#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SituacionesModel FROM SQLBaseModel

   DATA     cColumnCode                            INIT "nombre"

   DATA     cTableName                             INIT "situaciones"

   METHOD   New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hColumns                    := {  "id"              => {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT"   ,;
                                                               "text"		=> "Identificador"                        ,;
   															               "header"    => "Id"                                   ,;
                                                               "visible"   => .t.                                    ,;
                                                               "width"     => 40}                                    ,;
                                       "nombre"          => {  "create"    => "VARCHAR( 140 ) NOT NULL"              ,;
   															               "text"		=> "Tipo de situacion"                    ,;
                                                               "header"    => "Situación"                            ,;
                                                               "visible"   => .t.                                    ,;
                                                               "width"     => 400                                    ,;
   															               "field"   	=> "cSitua"                               ,;
                                                               "type"      => "C"                                    ,;
                                                               "len"       => 140}                                   }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

