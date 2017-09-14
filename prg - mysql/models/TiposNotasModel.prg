#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposNotasModel FROM SQLBaseModel

   DATA cColumnCode             INIT "nombre"

	DATA cTableName              INIT "tipos_notas"

   DATA cDbfTableName

   DATA hColumns

   METHOD   New()

   METHOD   arrayTiposNotas()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cDbfTableName         := "TipoNotas"

   ::hColumns              := {  "id"        => {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT"   ,;
                                                   "text"      => "Identificador"                        ,;
                                                   "header"    => "Id"                                   ,;
                                                   "visible"   => .f.                                    ,;
                                                   "width"     => 40}                                    ,;
                                 "nombre"    => {  "create"    => "VARCHAR( 30 ) NOT NULL"               ,;
                                                   "text"      => "Tipo de la nota"                      ,;
                                                   "header"    => "Tipo"                                 ,;
                                                   "visible"   => .t.                                    ,;
                                                   "width"     => 100                                    ,;
                                                   "field"     => "cTipo"                                ,;
                                                   "type"      => "C"                                    ,;
                                                    "len"       => 30}                                    }

   ::Super:New()

   ::cColumnOrder          := "nombre"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD arrayTiposNotas()

   local cSentence         := "SELECT nombre FROM " + ::cTableName
   local aSelect           := ::selectFetchArray( cSentence )

Return ( aSelect )

//---------------------------------------------------------------------------//