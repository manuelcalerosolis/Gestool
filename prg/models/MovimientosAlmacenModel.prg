#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenModel FROM SQLBaseModel

   DATA cTableName            INIT "movimientos_almacen"

   DATA cColumnOrder          INIT "numero"

   DATA aTextoMovimiento      INIT { "Entre almacenes", "Regularización", "Objetivos", "Consolidación" }

   METHOD New()
   
   METHOD cTextoMovimiento()  

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hColumns              := {  "id"              => {  "create"    => "INTEGER PRIMARY KEY AUTOINCREMENT"       ,;
                                                         "text"      => "Identificador"                           ,;
                                                         "header"    => "Id"                                      ,;
                                                         "visible"   => .f.}                                      ,;
                                 "numero"          => {  "create"    => "INT(9)"                                  ,;
                                                         "text"      => "Número"                                  ,;
                                                         "header"    => "Número"                                  ,;
                                                         "visible"   => .t.                                       ,;
                                                         "width"     => 100                                       ,;
                                                         "field"     => "nNumRem"                                 ,;
                                                         "type"      => "N"                                       ,;
                                                         "len"       => 40 }                                      ,;
                                 "delegacion"      => {  "create"    => "VARCHAR(2) NOT NULL"                     ,;
                                                         "text"      => "Delegación"                              ,;
                                                         "header"    => "Dlg."                                    ,;
                                                         "visible"   => .t.                                       ,;
                                                         "width"     => 40                                        ,;
                                                         "field"     => "cSufRem"                                 ,;
                                                         "type"      => "C"                                       ,;
                                                         "len"       => 2 }                                       ,;
                                 "seleccionado"    => {  "create"    => "BOOLEAN"                                 ,;
                                                         "text"      => "Seleccionado"                            ,;
                                                         "header"    => "Sel"                                     ,;
                                                         "visible"   => .f.                                       ,;
                                                         "width"     => 20                                       ,;
                                                         "field"     => "lSelDoc"                                 ,;
                                                         "type"      => "L"                                       ,;
                                                         "len"       => 1 }                                       ,;
                                 "usuario"         => {  "create"    => "VARCHAR(2) NOT NULL"                     ,;
                                                         "text"      => "usuario"                                 ,;
                                                         "header"    => "Usr."                                    ,;
                                                         "visible"   => .t.                                       ,;
                                                         "width"     => 40                                        ,;
                                                         "field"     => "cCodUsr"                                 ,;
                                                         "type"      => "C"                                       ,;
                                                         "len"       => 2 }                                       ,;
                                 "tipo_movimiento" => {  "create"    => "INT NOT NULL"                            ,;
                                                         "text"      => "Tipo movimiento"                         ,;
                                                         "header"    => "Tipo movimiento"                         ,;
                                                         "visible"   => .t.                                       ,;
                                                         "edit"      => {|| ::cTextoMovimiento() }                ,;
                                                         "width"     => 100                                       ,;
                                                         "field"     => "nTipMov"                                 ,;
                                                         "type"      => "N"                                       ,;
                                                         "len"       => 4 }                                       ,;
                                 "fecha"           => {  "create"    => "DATE"                                    ,;
                                                         "text"      => "Fecha"                                   ,;
                                                         "header"    => "Fecha"                                   ,;
                                                         "field"     => "dFecRem"                                 ,;
                                                         "visible"   => .t.                                       ,;
                                                         "width"     => 40 }                                      }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD cTextoMovimiento()

   local nPosition   := ::getRowSet():fieldGet( "tipo_movimiento" )

   nPosition         := max( nPosition, 1 )
   nPosition         := min( nPosition, len( ::aTextoMovimiento ) )

RETURN ( ::aTextoMovimiento[ nPosition ] ) // [ nPosition ] ) 
