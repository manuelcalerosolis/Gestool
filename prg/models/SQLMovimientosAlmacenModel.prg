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

   hset( ::hColumns, "id",                {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT"      ,;
                                             "text"      => "Identificador"                           ,;
                                             "header"    => "Id"                                      ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 40 }                                      )   

   ::CommunFields()

   hset( ::hColumns, "numero",            {  "create"    => "INT(9)"                                  ,;
                                             "text"      => "Número"                                  ,;
                                             "header"    => "Número"                                  ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 100                                       ,;
                                             "field"     => "nNumRem"                                 ,;
                                             "type"      => "N"                                       ,;
                                             "len"       => 40 }                                      )

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
                                             "picture"   => "@T"                                      ,;
                                             "default"   => {|| hb_datetime() }                       ,;
                                             "headAlign" => AL_LEFT                                   ,; 
                                             "dataAlign" => AL_LEFT                                   ,; 
                                             "footAlign" => AL_LEFT                                   ,; 
                                             "width"     => 180 }                                     )

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

   ::TimeStampFields()

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD cTextoMovimiento()

   local nPosition   := ::getRowSet():fieldGet( "tipo_movimiento" )

   nPosition         := max( nPosition, 1 )
   nPosition         := min( nPosition, len( ::aTextoMovimiento ) )

RETURN ( ::aTextoMovimiento[ nPosition ] ) // [ nPosition ] ) 

//---------------------------------------------------------------------------//

