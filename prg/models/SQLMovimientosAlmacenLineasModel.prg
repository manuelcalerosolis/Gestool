#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenLineasModel FROM SQLBaseEmpresasModel

   DATA cTableName            INIT "movimientos_almacen_lineas"

   METHOD New()
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   hset( ::hColumns, "id",                {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT"      ,;
                                             "text"      => "Identificador"                           ,;
                                             "header"    => "Id"                                      ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 40 }                                      )   

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                             "text"      => "Uuid"                                    ,;
                                             "header"    => "Uuid"                                    ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 240                                       ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                             "text"      => "parent_uuid"                             ,;
                                             "header"    => "Parent uuid"                             ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 240 }                                     )

   hset( ::hColumns, "codigo_articulo",   {  "create"    => "VARCHAR(18) NOT NULL"                    ,;
                                             "text"      => "C�digo art�culo"                         ,;
                                             "header"    => "C�digo art�culo"                         ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 240 }                                     )

   hset( ::hColumns, "nombre_articulo",   {  "create"    => "VARCHAR(250) NOT NULL"                   ,;
                                             "text"      => "Nombre art�culo"                         ,;
                                             "header"    => "Nombre art�culo"                         ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 240 }                                     )

   hset( ::hColumns, "codigo_primera_propiedad",   {  "create"    => "VARCHAR(20)"                          ,;
                                                      "text"      => "C�digo primera propiedad art�culo"    ,;
                                                      "header"    => "C�digo primera propiedad art�culo"    ,;
                                                      "visible"   => .f.                                    ,;
                                                      "width"     => 240 }                                  )

   hset( ::hColumns, "valor_primera_propiedad",    {  "create"    => "VARCHAR(200)"                         ,;
                                                      "text"      => "Valor primera propiedad art�culo"     ,;
                                                      "header"    => "Valor primera propiedad art�culo"     ,;
                                                      "visible"   => .t.                                    ,;
                                                      "width"     => 240 }                                  )

   hset( ::hColumns, "codigo_segunda_propiedad",   {  "create"    => "VARCHAR(20)"                          ,;
                                                      "text"      => "C�digo segunda propiedad art�culo"    ,;
                                                      "header"    => "C�digo segunda propiedad art�culo"    ,;
                                                      "visible"   => .f.                                    ,;
                                                      "width"     => 240 }                                  )

   hset( ::hColumns, "valor_segunda_propiedad",    {  "create"    => "VARCHAR(200)"                         ,;
                                                      "text"      => "Valor segunda propiedad art�culo"     ,;
                                                      "header"    => "Valor segunda propiedad art�culo"     ,;
                                                      "visible"   => .t.                                    ,;
                                                      "width"     => 240 }                                  )

   hset( ::hColumns, "fecha_caducidad",   {  "create"    => "DATE"                                 ,;
                                             "text"      => "Fecha caducidad"                      ,;
                                             "header"    => "Fecha caducidad"                      ,;
                                             "visible"   => .t.                                    ,;
                                             "width"     => 120 }                                  )

   hset( ::hColumns, "lote",              {  "create"    => "VARCHAR(40)"                          ,;
                                             "text"      => "Lote"                                 ,;
                                             "header"    => "Lote"                                 ,;
                                             "visible"   => .t.                                    ,;
                                             "width"     => 240 }                                  )

   hset( ::hColumns, "bultos_articulo",   {  "create"    => "DECIMAL(19,6)"                        ,;
                                             "text"      => "Bultos"                               ,;
                                             "header"    => "Bultos"                               ,;
                                             "visible"   => .t.                                    ,;
                                             "width"     => 240 }                                  )

   hset( ::hColumns, "cajas_articulo",    {  "create"    => "DECIMAL(19,6)"                        ,;
                                             "text"      => "Cajas"                                ,;
                                             "header"    => "Cajas"                                ,;
                                             "visible"   => .t.                                    ,;
                                             "width"     => 240 }                                  )

   hset( ::hColumns, "unidades_articulo", {  "create"    => "DECIMAL(19,6)"                        ,;
                                             "text"      => "Unidades"                             ,;
                                             "header"    => "Unidades"                             ,;
                                             "visible"   => .t.                                    ,;
                                             "width"     => 240 }                                  )

   hset( ::hColumns, "precio_articulo",   {  "create"    => "DECIMAL(19,6)"                        ,;
                                             "text"      => "Precio"                               ,;
                                             "header"    => "Precio"                               ,;
                                             "visible"   => .t.                                    ,;
                                             "width"     => 240 }                                  )

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

