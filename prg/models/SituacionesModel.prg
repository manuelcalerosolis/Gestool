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

   ::cTableName                  := "situaciones"

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

METHOD arraySituaciones()

   local cSentence               := "SELECT situacion FROM " + ::cTableName
   local aSelect                 := ::selectFetchArray( cSentence ) 

RETURN ( aSelect )

//---------------------------------------------------------------------------//
