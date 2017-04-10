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

   ::hColumns                    := {  "id"     => "INTEGER PRIMARY KEY AUTOINCREMENT",;
                                       "nombre" => "VARCHAR( 50 ) NOT NULL" }

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//
