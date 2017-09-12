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

METHOD New( oController )

   ::cDbfTableName				 	:= "TipImp"

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

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arrayTiposImpresoras() 

   local cSentence               := "SELECT nombre FROM " + ::cTableName
   local aResult                 := ::selectFetchArray( cSentence )

   if hb_isnil( aResult )
      aResult                    := {}
   end if 

   aadd( aResult, "" )

RETURN ( aResult )

//---------------------------------------------------------------------------//

METHOD existTiposImpresoras( cValue )

   local cSentence               := "SELECT nombre FROM " + ::cTableName + " WHERE nombre = " + toSQLString( cValue )
   local aSelect                 := ::selectFetchArray( cSentence )

RETURN ( !empty( aSelect ) )

//---------------------------------------------------------------------------//

