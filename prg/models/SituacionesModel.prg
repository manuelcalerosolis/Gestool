#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SituacionesModel FROM SQLBaseModel

   DATA     cColumnCode                            INIT "nombre"

   DATA     cTableName                             INIT "situaciones"

   DATA     cDbfTableName

   DATA     hColumns

   METHOD   New()

<<<<<<< HEAD
   METHOD   buildRowSetWithRecno()                 INLINE   ( ::buildRowSet( .t. ) ) 

=======
>>>>>>> SQLite
   METHOD   arraySituaciones()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cDbfTableName               := "Situa"

<<<<<<< HEAD
   ::hColumns                    := {  "id"        => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"    ,;
                                                         "text"		=> "Identificador"                        ,;
   															         "dbfField" 	=> "" }                                   ,;
                                       "nombre"    => {  "create"    => "VARCHAR( 140 ) NOT NULL"              ,;
   															         "text"		=> "Tipo de situacion"                    ,;
   															         "dbfField" 	=> "cSitua" } }
=======
   ::hColumns                    := {  "id"              => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"    ,;
                                                               "text"		=> "Identificador"                        ,;
   															               "header"    => "Id"                                   ,;
                                                               "visible"   => .f.                                    ,;
                                                               "width"     => 40}                                    ,;
                                       "nombre"          => {  "create"    => "VARCHAR( 140 ) NOT NULL"              ,;
   															               "text"		=> "Tipo de situacion"                    ,;
                                                               "header"    => "Situación"                            ,;
                                                               "visible"   => .t.                                    ,;
                                                               "width"     => 200                                    ,;
   															               "field"   	=> "cSitua"                               ,;
                                                               "type"      => "C"                                    ,;
                                                               "len"       => 140}                                   }
>>>>>>> SQLite

   ::Super:New()

   ::cColumnOrder                := "nombre"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD arraySituaciones()

   local cSentence               := "SELECT nombre FROM " + ::cTableName
   local aSelect                 := ::selectFetchArray( cSentence ) 

RETURN ( aSelect )

//---------------------------------------------------------------------------//
