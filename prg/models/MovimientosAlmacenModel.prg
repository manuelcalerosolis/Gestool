#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenModel FROM SQLBaseEmpresasModel

   DATA cTableName            INIT "movimientos_almacen"

   DATA cColumnOrder          INIT "numero"

   DATA aTextoMovimiento      INIT { "Entre almacenes", "Regularización", "Objetivos", "Consolidación" }

   METHOD New()
   
   METHOD cTextoMovimiento()  

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::CommunFields()

   hset( ::hColumns, "numero",            {  "create"    => "INT(9)"                                  ,;
                                             "text"      => "Número"                                  ,;
                                             "header"    => "Número"                                  ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 100                                       ,;
                                             "field"     => "nNumRem"                                 ,;
                                             "type"      => "N"                                       ,;
                                             "len"       => 40 }                                      )

   hset( ::hColumns, "seleccionado",      {  "create"    => "BOOLEAN"                                 ,;
                                             "text"      => "Seleccionado"                            ,;
                                             "header"    => "Sel"                                     ,;
                                             "visible"   => .f.                                       ,;
                                             "width"     => 20                                        ,;
                                             "field"     => "lSelDoc"                                 ,;
                                             "type"      => "L"                                       ,;
                                             "len"       => 1 }                                       )

   hset( ::hColumns, "tipo_movimiento",   {  "create"    => "INT NOT NULL"                            ,;
                                             "text"      => "Tipo movimiento"                         ,;
                                             "header"    => "Tipo movimiento"                         ,;
                                             "visible"   => .t.                                       ,;
                                             "edit"      => {|| ::cTextoMovimiento() }                ,;
                                             "width"     => 100                                       ,;
                                             "field"     => "nTipMov"                                 ,;
                                             "type"      => "N"                                       ,;
                                             "len"       => 4 }                                       )

   hset( ::hColumns, "fecha_hora",        {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"      ,;
                                             "text"      => "Fecha"                                   ,;
                                             "header"    => "Fecha"                                   ,;
                                             "field"     => "dFecRem"                                 ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "T"                                       ,;
                                             "width"     => 40 }                                       )

   hset( ::hColumns, "almacen_origen",    {  "create"    => "CHAR ( 16 )"                             ,;
                                             "text"      => "Almacén origen"                          ,;
                                             "header"    => "Almacén origen"                          ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "field"     => "cAlmOrg" }                                )

   hset( ::hColumns, "almacen_destino",   {  "create"    => "CHAR ( 16 )"                             ,;
                                             "text"      => "Almacén destino"                         ,;
                                             "header"    => "Almacén destino"                         ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "field"     => "cAlmDes" }                                )

   hset( ::hColumns, "grupo_movimiento",  {  "create"    => "CHAR ( 2 )"                              ,;
                                             "text"      => "Grupo movimiento"                        ,;
                                             "header"    => "Grupo movimiento"                        ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "field"     => "cCodMov" }                                )

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD cTextoMovimiento()

   local nPosition   := ::getRowSet():fieldGet( "tipo_movimiento" )

   nPosition         := max( nPosition, 1 )
   nPosition         := min( nPosition, len( ::aTextoMovimiento ) )

RETURN ( ::aTextoMovimiento[ nPosition ] ) // [ nPosition ] ) 

//---------------------------------------------------------------------------//