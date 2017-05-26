#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasModel FROM SQLBaseModel

   DATA     cTableName           INIT "tipos_ventas"

   DATA     cDbfTableName

   DATA     hColumns

   METHOD   New()

   METHOD   arrayTiposVentas()

   METHOD   arrayNombres()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cDbfTableName				 	:= "TVta"

   ::hColumns                   	:= {  "id"     => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"    ,;
                                                      "text"		=> "Identificador"                        ,;
   															      "header"    => "Id"                                   ,;
                                                      "visible"   => .f.                                    ,;
                                                      "width"     => 40}                                    ,;
                                       "codigo" => {  "create"    => "VARCHAR( 2 )"                         ,;
                                                      "text"      => "Código"                               ,; 
                                                      "header"    => "Código"                               ,;
                                                      "visible"   => .t.                                    ,;
                                                      "width"     => 50                                     ,;
                                                      "field"     => "cCodMov"                              ,;
                                                      "type"      => "C"                                    ,;
                                                      "len"       => 2}                                     ,;
                                       "nombre" => {  "create"    => "VARCHAR( 20 ) NOT NULL"               ,;
   															      "text"		=> "Nombre"                               ,;
                                                      "header"    => "Nombre"                               ,;
                                                      "visible"   => .t.                                    ,;
                                                      "width"     => 20                                     ,;
   															      "field" 	   => "cDesMov"                              ,;
                                                      "type"      => "C"                                    ,;
                                                      "len"       => 20}                                    }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arrayNombres()

   local cSentence               := "SELECT nombre FROM " + ::cTableName
   local aResult                 := ::selectFetchArray( cSentence ) 

RETURN ( aResult )

//---------------------------------------------------------------------------//

METHOD arrayTiposVentas()

   local cSentence               := "SELECT id, codigo FROM " + ::cTableName
   local aResult                 := ::selectFetchHash( cSentence ) 

RETURN ( aResult )

//---------------------------------------------------------------------------//

