#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SituacionesModel FROM SQLBaseModel

   DATA     cTableName                             INIT "sitacionessitaciones"

   DATA     cDbfTableName

   DATA     hColumns

   METHOD   New()

   METHOD   buildRowSetWithRecno()                 INLINE   ( ::buildRowSet( .t. ) )

   METHOD   arraySituaciones()

   METHOD   existSituaciones()

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

METHOD arraySituaciones()

   local cSentence               := "SELECT situacion FROM " + ::cTableName
   local aSelect                 := ::selectFetchArray( cSentence ) 

RETURN ( aSelect )

//---------------------------------------------------------------------------//

METHOD existSituaciones( cValue )

   local cSentence               := "SELECT situacion FROM " + ::cTableName + " WHERE situacion = " + toSQLString( cValue )
   local aSelect                 := ::selectFetchArray( cSentence )

RETURN ( !empty( aSelect ) )

//---------------------------------------------------------------------------//