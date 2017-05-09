#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasModel FROM SQLBaseModel

   DATA cTableName

   DATA cDbfTableName

   DATA hColumns

   METHOD New()

   METHOD arrayTiposImpresoras()

   METHOD existTiposImpresoras( cValue )

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arrayTiposImpresoras()

   local cSentence               := "SELECT nombre FROM " + ::cTableName
   local aResult                 := ::selectFetchArray( cSentence ) 

RETURN ( aResult )

//---------------------------------------------------------------------------//

METHOD existTiposImpresoras( cValue )

   local cSentence               := "SELECT nombre FROM " + ::cTableName + " WHERE nombre = " + quoted( cValue )
   local aSelect                 := ::selectFetchArray( cSentence )

RETURN ( !empty( aSelect ) )

//---------------------------------------------------------------------------//

