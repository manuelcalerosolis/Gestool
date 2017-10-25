#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenModel FROM SQLBaseEmpresasModel

   DATA cTableName            INIT "movimientos_almacen"

   DATA cColumnOrder          INIT "numero"

   DATA aTextoMovimiento      INIT { "Entre almacenes", "Regularizaci�n", "Objetivos", "Consolidaci�n" }

   METHOD New()
   
   METHOD cTextoMovimiento()  

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::CommunFields()

   hset( ::hColumns, "numero",            {  "create"    => "INT(9)"                                  ,;
                                             "text"      => "N�mero"                                  ,;
                                             "header"    => "N�mero"                                  ,;
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
                                             "visible"   => .t.                                       ,;
                                             "type"      => "T"                                       ,;
                                             "picture"   => "@DT"                                     ,;
                                             "default"   => {|| hb_datetime() }                       ,;
                                             "headAlign" => AL_LEFT                                   ,; 
                                             "dataAlign" => AL_LEFT                                   ,; 
                                             "footAlign" => AL_LEFT                                   ,; 
                                             "width"     => 140 }                                     )

   hset( ::hColumns, "almacen_origen",    {  "create"    => "CHAR ( 16 )"                             ,;
                                             "text"      => "Almac�n origen"                          ,;
                                             "header"    => "Almac�n origen"                          ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "field"     => "cAlmOrg"                                 ,;   
                                             "width"     => 80 }                                      )

   hset( ::hColumns, "almacen_destino",   {  "create"    => "CHAR ( 16 )"                             ,;
                                             "text"      => "Almac�n destino"                         ,;
                                             "header"    => "Almac�n destino"                         ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "field"     => "cAlmDes"                                 ,;   
                                             "width"     => 80 }                                      )

   hset( ::hColumns, "grupo_movimiento",  {  "create"    => "CHAR ( 2 )"                              ,;
                                             "text"      => "Grupo movimiento"                        ,;
                                             "header"    => "Grupo movimiento"                        ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "field"     => "cCodMov"                                 ,;
                                             "width"     => 80 }                                      )

   hset( ::hColumns, "agente",            {  "create"    => "CHAR ( 3 )"                              ,;
                                             "text"      => "Agente movimiento"                       ,;
                                             "header"    => "Agente"                                  ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "field"     => "cCodAge"                                 ,;
                                             "width"     => 80 }                                      )

   hset( ::hColumns, "divisa",            {  "create"    => "CHAR ( 3 )"                              ,;
                                             "text"      => "Divisa"                                  ,;
                                             "header"    => "Divisa"                                  ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "default"   => {|| cDivEmp() }                           ,;
                                             "field"     => "cCodDiv"                                 ,;
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
                                             "field"     => "mComent"                                 ,;
                                             "width"     => 240 }                                     )

   ::TimeStampFields()

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD cTextoMovimiento()

   local nPosition   := ::getRowSet():fieldGet( "tipo_movimiento" )

   nPosition         := max( nPosition, 1 )
   nPosition         := min( nPosition, len( ::aTextoMovimiento ) )

RETURN ( ::aTextoMovimiento[ nPosition ] ) 

//---------------------------------------------------------------------------//