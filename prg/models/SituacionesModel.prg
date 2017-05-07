#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SituacionesModel FROM SQLBaseModel

   DATA     cTableName

   DATA     cDbfTableName

   DATA     hColumns

   METHOD   New()

   METHOD   buildRowSetWithRecno()                 INLINE   ( ::buildRowSet( .t. ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTableName                  := "sitaciones"

   ::cDbfTableName               := "Situa"

   ::hColumns                    := {  "id"              => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"    ,;
                                                               "text"		=> "Identificador"                        ,;
   															               "dbfField" 	=> "" }                                   ,;
                                       "situacion"       => {  "create"    => "VARCHAR( 140 ) NOT NULL"              ,;
   															               "text"		=> "Tipo de situacion"                    ,;
   															               "dbfField" 	=> "cSitua" } }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//