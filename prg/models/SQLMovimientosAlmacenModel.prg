#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenModel FROM SQLBaseEmpresasModel

   DATA cTableName            INIT "movimientos_almacen"

   DATA cColumnOrder          INIT "id"

   DATA aTextoMovimiento      INIT { "Entre almacenes", "Regularización", "Objetivos", "Consolidación" }

   METHOD getColumns()
   
   METHOD cTextoMovimiento()  

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   ::Super:getColumns()

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
                                             "visible"   => .t.                                       ,;
                                             "type"      => "T"                                       ,;
                                             "picture"   => "@DT"                                     ,;
                                             "default"   => {|| hb_datetime() }                       ,;
                                             "headAlign" => AL_LEFT                                   ,; 
                                             "dataAlign" => AL_LEFT                                   ,; 
                                             "footAlign" => AL_LEFT                                   ,; 
                                             "width"     => 140 }                                     )

   hset( ::hColumns, "almacen_origen",    {  "create"    => "CHAR ( 16 )"                             ,;
                                             "text"      => "Almacén origen"                          ,;
                                             "header"    => "Almacén origen"                          ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "field"     => "cAlmOrg"                                 ,;
                                             "len"       => 16                                        ,;   
                                             "width"     => 80 }                                      )

   hset( ::hColumns, "almacen_destino",   {  "create"    => "CHAR ( 16 )"                             ,;
                                             "text"      => "Almacén destino"                         ,;
                                             "header"    => "Almacén destino"                         ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "field"     => "cAlmDes"                                 ,;
                                             "len"       => 16                                        ,;   
                                             "width"     => 80 }                                      )

   hset( ::hColumns, "grupo_movimiento",  {  "create"    => "CHAR ( 2 )"                              ,;
                                             "text"      => "Grupo"                                   ,;
                                             "header"    => "Grupo"                                   ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "len"       => 2                                         ,;   
                                             "width"     => 80 }                                      )

   hset( ::hColumns, "agente",            {  "create"    => "CHAR ( 3 )"                              ,;
                                             "text"      => "Agente"                                  ,;
                                             "header"    => "Agente"                                  ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "len"       => 3                                         ,;   
                                             "width"     => 80 }                                      )

   hset( ::hColumns, "divisa",            {  "create"    => "CHAR ( 3 )"                              ,;
                                             "text"      => "Divisa"                                  ,;
                                             "header"    => "Divisa"                                  ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "default"   => {|| cDivEmp() }                           ,;
                                             "len"       => 3                                         ,;   
                                             "width"     => 80 }                                      )

   hset( ::hColumns, "divisa_cambio",     {  "create"    => "DECIMAL(16,6)"                           ,;
                                             "text"      => "Cambio divisa"                           ,;
                                             "header"    => "Cambio"                                  ,;
                                             "visible"   => .f.                                       ,;
                                             "type"      => "N"                                       ,;
                                             "default"   => {|| 1 }                                   ,;
                                             "field"     => "nVdvDiv" }                                )

   hset( ::hColumns, "comentarios",       {  "create"    => "VARCHAR ( 250 )"                         ,;
                                             "text"      => "Comentarios"                             ,;
                                             "header"    => "Comentarios"                             ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "len"       => 250                                       ,;   
                                             "width"     => 240 }                                     )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD cTextoMovimiento()

   local nPosition   := ::getRowSet():fieldGet( "tipo_movimiento" )

   nPosition         := max( nPosition, 1 )
   nPosition         := min( nPosition, len( ::aTextoMovimiento ) )

RETURN ( ::aTextoMovimiento[ nPosition ] ) 

//---------------------------------------------------------------------------//