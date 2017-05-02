#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS EtiquetasModel FROM SQLBaseModel

   DATA     cTableName

   DATA     cDbfTableName

   DATA     hColumns

   METHOD   New()

   METHOD   buildRowSetWithRecno()                 INLINE   ( ::buildRowSet( .t. ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTableName                  := "etiquetas"

   ::cDbfTableName               := ""

   ::hColumns                    := {  "id"        => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"  ,;
                                                         "text"		=> "Identificador"                      ,;
   															         "dbfField" 	=> "" }                                 ,;
                                       "nombre"    => {  "create"    => "VARCHAR( 50 ) NOT NULL"             ,;
   															         "text"		=> "Nombre de la etiqueta"              ,;
   															         "dbfField" 	=> "" }                                 ,;
                                       "imagen"    => {  "create"    => "VARCHAR ( 50 )"                     ,;
                                                         "text"      => "Imagen que acompaña la etiqueta"    ,;
                                                         "dbfField"  => "" }                                 ,;
                                       "id_padre"  => {  "create"    => "INTEGER"                            ,;
                                                         "text"      => "Identificador de la etiqueta padre" ,;
                                                         "dbfField"  => "" }                                 }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//
