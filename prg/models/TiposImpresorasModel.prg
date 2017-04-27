#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasModel FROM SQLBaseModel

   DATA cTableName               INIT "tipos_impresoras"

   DATA cDbfTableName            INIT "TipImp"

   DATA aDbfFields               INIT {  "cTipImp" }

   DATA hColumns                 INIT {  "id"     =>  {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT",;
                                                         "text"      => "Identificador" ,;
                                                         "dbfField"  => "" },;
                                          "nombre" => {  "create"    => "VARCHAR( 50 ) NOT NULL",;
                                                         "text"      => "Nombre de impresora",;
                                                         "dbfField"  => "cTipImp" } }

   METHOD New()

   METHOD arrayTiposImpresoras()

   METHOD existTiposImpresoras( cValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTableName                  := "tipos_impresoras"

   ::cDbfTableName				 	:= "TipImp"

   ::aDbfFields			 			:=	{  "cTipImp" }

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

   local aResult                 := {}
   local cSentence               := "SELECT nombre FROM " + ::cTableName
   local aSelect                 := ::selectFetchArray( cSentence ) 

   if !empty( aSelect )
      aeval( aSelect, {|a| aadd( aResult, a[ 1 ] ) } )
   end if 

RETURN ( aResult )

//---------------------------------------------------------------------------//

METHOD existTiposImpresoras( cValue )

   local cSentence               := "SELECT nombre FROM " + ::cTableName + " WHERE nombre = " + quoted( cValue )
   local aSelect                 := ::selectFetchArray( cSentence )

RETURN ( !empty( aSelect ) )

//---------------------------------------------------------------------------//

