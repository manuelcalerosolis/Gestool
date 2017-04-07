#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasModel FROM SQLBaseModel

   METHOD   New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cFind                       := ""

   ::cColumnOrder                := ""
   ::cColumnOrientation          := ""

   ::hColumns                    := {  "id"     => "INTEGER PRIMARY KEY AUTOINCREMENT",;
                                       "nombre" => "VARCHAR( 50 ) NOT NULL" }

   ::cTableName                  := "tipos_impresoras"


   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//
