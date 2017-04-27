#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasModel FROM SQLBaseModel

   DATA cTableName               INIT "tipos_impresoras"

   DATA cDbfTableName            INIT "TipImp"

   DATA hColumns                 INIT {  "id"     =>  {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT",;
                                                         "text"      => "Identificador" ,;
                                                         "dbfField"  => "" },;
                                          "nombre" => {  "create"    => "VARCHAR( 50 ) NOT NULL",;
                                                         "text"      => "Nombre de impresora",;
                                                         "dbfField"  => "cTipImp" } }

   METHOD   New()

   METHOD   arrayTiposImpresoras()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTableName                  := "tipos_impresoras"

   ::cDbfTableName				 	:= "TipImp"

   ::hColumns                   	:= {  "id"     => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT",;
                                                      "text"		=> "Identificador" ,;
   															      "dbfField" 	=> "" },;
                                       "nombre" => {  "create"    => "VARCHAR( 50 ) NOT NULL",;
   															      "text"		=> "Nombre de impresora",;
   															      "dbfField" 	=> "cTipImp" } }

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD arrayTiposImpresoras()

   local aResult                 := {}
   local arrayTiposImpresoras    := ::selectFetchArray( "SELECT nombre FROM " + ::cTableName ) 

   if !empty( arrayTiposImpresoras )
      aeval( arrayTiposImpresoras, {|a| aadd( aResult, a[ 1 ] ) } )
   end if 

Return ( aResult )

//---------------------------------------------------------------------------//


