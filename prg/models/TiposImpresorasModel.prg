#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasModel FROM SQLBaseModel

   METHOD   New()

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

Return ( Self )

//---------------------------------------------------------------------------//
