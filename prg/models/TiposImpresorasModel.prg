#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasModel FROM SQLBaseModel

   DATA  cColumnCode             INIT "nombre"

   DATA cTableName               INIT "tipos_impresoras"

   DATA cDbfTableName

   DATA hColumns

   METHOD New()

   METHOD arrayTiposImpresoras()

   METHOD existTiposImpresoras( cValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cDbfTableName				 	:= "TipImp"

   ::hColumns                   	:= {  "id"     => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT" ,;
                                                      "text"		=> "Identificador"                     ,;
   															      "field" 	   => ""                                  ,;
                                                      "header"    => "Id"                                ,;
                                                      "visible"   => .t.                                 ,;
                                                      "width"     => 40}                                 ,;
                                       "nombre" => {  "create"    => "VARCHAR( 50 ) NOT NULL"            ,;
   															      "text"		=> "Nombre de impresora"               ,;
                                                      "header"    => "Nombre"                            ,;
                                                      "visible"   => .t.                                 ,;
                                                      "width"     => 200                                 ,;
                                                      "field"     => "cTipImp"                           ,;
                                                      "type"      => "C"                                 ,;
                                                      "len"       => 50}                                 } 

   ::Super:New()

   ::cColumnOrder                := "nombre"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arrayTiposImpresoras()

   local cSentence               := "SELECT nombre FROM " + ::cTableName
   local aResult                 := ::selectFetchArray( cSentence ) 

   if !empty(aResult)
      aadd( aResult, "" )
   end if 

RETURN ( aResult )

//---------------------------------------------------------------------------//

METHOD existTiposImpresoras( cValue )

   local cSentence               := "SELECT nombre FROM " + ::cTableName + " WHERE nombre = " + toSQLString( cValue )
   local aSelect                 := ::selectFetchArray( cSentence )

RETURN ( !empty( aSelect ) )

//---------------------------------------------------------------------------//

