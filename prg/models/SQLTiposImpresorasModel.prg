#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLTiposImpresorasModel FROM SQLBaseModel

   DATA cColumnCode              INIT "nombre"

   DATA cTableName               INIT "tipos_impresoras"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

<<<<<<< HEAD:prg/models/SQLTiposImpresorasModel.prg
METHOD getColumns()
=======
METHOD getColumns( oController )
>>>>>>> 355ea3c649962138d29d3c3423a16e5bab093774:prg/models/TiposImpresorasModel.prg

   ::hColumns                   	:= {  "id"     => {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT",;
                                                      "text"		=> "Identificador"                     ,;
   															      "field" 	   => ""                                  ,;
                                                      "header"    => "Id"                                ,;
                                                      "visible"   => .t.                                 ,;
                                                      "width"     => 40 }                                ,;
                                       "nombre" => {  "create"    => "CHAR( 50 ) NOT NULL"               ,;
   															      "text"		=> "Nombre de impresora"               ,;
                                                      "header"    => "Nombre"                            ,;
                                                      "visible"   => .t.                                 ,;
                                                      "width"     => 200                                 ,;
                                                      "field"     => "cTipImp"                           ,;
                                                      "type"      => "C"                                 ,;
                                                      "len"       => 50 }                                 } 

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
