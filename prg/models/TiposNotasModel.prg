#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposNotasModel FROM SQLBaseModel

	DATA cTableName               INIT 	"tipos_notas"

   DATA cDbfTableName            INIT 	"TipoNotas"

   DATA hColumns                 INIT 	{ 	"id"     => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT",;
                                                         "text"      => "Identificador" ,;
                                                         "dbfField"  => "" },;
                                          "tipo" 	=> {  "create"    => "VARCHAR( 30 ) NOT NULL",;
                                                         "text"      => "Tipo de la nota",;
                                                         "dbfField"  => "cTipo" } }

   METHOD   New()

   METHOD   arrayTiposNotas()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

	::cTableName               	:= "tipos_notas"

   ::cDbfTableName            	:= "TipoNotas"

   ::hColumns                 	:= { 	"id"     => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT",;
                                                   "text"      => "Identificador" ,;
                                                   "dbfField"  => "" },;
                                    "tipo" 	=> {  "create"    => "VARCHAR( 30 ) NOT NULL",;
                                                   "text"      => "Tipo de la nota",;
                                                   "dbfField"  => "cTipo" } }

::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD arrayTiposNotas()

   local aResult                 := {}
   local arrayTiposNotas    := ::selectFetchArray( "SELECT tipo FROM " + ::cTableName ) 

   aeval( arrayTiposNotas, {|a| aadd( aResult, a[ 1 ] ) } )

Return ( aResult )

//---------------------------------------------------------------------------//