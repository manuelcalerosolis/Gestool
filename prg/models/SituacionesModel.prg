#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SituacionesModel FROM SQLBaseModel

   DATA     cTableName                             INIT "situaciones"

   DATA     cDbfTableName

   DATA     hColumns

   METHOD   New()

   METHOD   buildRowSetWithRecno()                 INLINE   ( ::buildRowSet( .t. ) ) 

   METHOD   arraySituaciones()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cDbfTableName               := "Situa"

   ::hColumns                    := {  "id"        => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"    ,;
                                                         "text"		=> "Identificador"                        ,;
   															         "dbfField" 	=> "" }                                   ,;
                                       "nombre"    => {  "create"    => "VARCHAR( 140 ) NOT NULL"              ,;
   															         "text"		=> "Tipo de situacion"                    ,;
   															         "dbfField" 	=> "cSitua" } }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arraySituaciones()

   local cSentence               := "SELECT nombre FROM " + ::cTableName
   local aSelect                 := ::selectFetchArray( cSentence ) 

RETURN ( aSelect )

//---------------------------------------------------------------------------//
