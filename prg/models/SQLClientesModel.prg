#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SQLClientesModel FROM SQLTercerosModel

   DATA cTableName               INIT "clientes"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLClientesModel

   ::super:getColumns()

   hset( ::hColumns, "agente_uuid",                {  "create"    => "VARCHAR( 40 )"       ,;
                                                      "default"   => {|| space( 40 ) } }   )

   hset( ::hColumns, "cuenta_remesa_uuid",         {  "create"    => "VARCHAR( 40 )"       ,;
                                                      "default"   => {|| space( 40 ) } }   )

   hset( ::hColumns, "ruta_uuid",                  {  "create"    => "VARCHAR( 40 )"       ,;
                                                      "default"   => {|| space( 40 ) } }   )

   hset( ::hColumns, "cliente_grupo_uuid",         {  "create"    => "VARCHAR( 40 )"       ,;
                                                      "default"   => {|| space( 40 ) } }   )

   hset( ::hColumns, "establecimiento",            {  "create"    => "VARCHAR( 100 )"      ,;
                                                      "default"   => {|| space( 100 ) } }  )

   hset( ::hColumns, "primer_dia_pago",            {  "create"    => "INT UNSIGNED"        ,;
                                                      "default"   => {|| 0 } }             )

   hset( ::hColumns, "segundo_dia_pago",           {  "create"    => "INT UNSIGNED"        ,;
                                                      "default"   => {|| 0 } }             )

   hset( ::hColumns, "mes_vacaciones",             {  "create"    => "VARCHAR( 15 )"       ,;
                                                      "default"   => {|| padr( "Ninguno", 15 ) } }   )

   hset( ::hColumns, "regimen_iva",                {  "create"    => "VARCHAR( 15 )"       ,;
                                                      "default"   => {|| padr( "General", 15 ) } }   )

   hset( ::hColumns, "recargo_equivalencia",       {  "create"    => "BIT"                 ,;
                                                      "default"   => {|| .f. } }           )

   hset( ::hColumns, "porcentaje_irpf",            {  "create"    => "DECIMAL(19,6)"       ,;
                                                      "default"   => {|| 0 } }             )

   hset( ::hColumns, "bloqueado",                  {  "create"    => "BIT"                 ,;
                                                      "default"   => {|| .f. } }           )

   hset( ::hColumns, "fecha_bloqueo",              {  "create"    => "DATE"                ,;
                                                      "default"   => {|| ctod( "" ) } }    )

   hset( ::hColumns, "causa_bloqueo",              {  "create"    => "VARCHAR( 100 )"      ,;
                                                      "default"   => {|| space( 100 ) } }  )

   hset( ::hColumns, "excluir_fidelizacion",       {  "create"    => "BIT"                 ,;
                                                      "default"   => {|| .f. } }           )

   hset( ::hColumns, "no_editar_datos",            {  "create"    => "BIT"                 ,;
                                                      "default"   => {|| .f. } }           )

   hset( ::hColumns, "fecha_ultima_llamada",       {  "create"    => "DATE"                ,;
                                                      "default"   => {|| ctod( "" ) } }    )

   hset( ::hColumns, "autorizado_venta_credito",   {  "create"    => "BIT"                 ,;
                                                      "default"   => {|| .f. } }           )

   hset( ::hColumns, "bloquear_riesgo_alcanzado",  {  "create"    => "BIT"                 ,;
                                                      "default"   => {|| .f. } }           )

   hset( ::hColumns, "fecha_peticion_riesgo",      {  "create"    => "DATE"                ,;
                                                      "default"   => {|| ctod( "" ) } }    )

   hset( ::hColumns, "fecha_concesion_riesgo",     {  "create"    => "DATE"                ,;
                                                      "default"   => {|| ctod( "" ) } }    )

   hset( ::hColumns, "riesgo",                     {  "create"    => "DECIMAL(19,6)"       ,;
                                                      "default"   => {|| 0 } }             )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//