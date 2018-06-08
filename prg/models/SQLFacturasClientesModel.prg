#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SQLFacturasClientesModel FROM SQLCompanyModel

   DATA cTableName               INIT "facturas_clientes"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFacturasClientesModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"        ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"        ,;
                                                         "default"   => {|| win_uuidcreatestring() } }         )

   hset( ::hColumns, "delegacion_uuid",               {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| Company():delegacionUuid() } }    )

   hset( ::hColumns, "serie",                         {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "numero",                        {  "create"    => "INT UNSIGNED"                         ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "fecha",                         {  "create"    => "DATE"                                 ,;
                                                         "default"   => {|| date() } }                         )

   hset( ::hColumns, "fecha_valor_stock",             {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"   ,;
                                                         "default"   => {|| hb_datetime() } }                  )

   hset( ::hColumns, "cliente_uuid",                  {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| space( 40 ) } }                    )

   hset( ::hColumns, "direccion_principal_uuid",      {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| space( 40 ) } }                    )

   hset( ::hColumns, "forma_pago_uuid",               {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| space( 40 ) } }                    )

   hset( ::hColumns, "almacen_uuid",                  {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| space( 40 ) } }                    )

   hset( ::hColumns, "agente_uuid",                   {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| space( 40 ) } }                    )

   hset( ::hColumns, "ruta_uuid",                     {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| space( 40 ) } }                    )

   hset( ::hColumns, "transportista_uuid",            {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| space( 40 ) } }                    )
   
RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

/*METHOD getInitialSelect() CLASS SQLFacturasClientesModel

   local cSelect  := "SELECT clientes.id AS id,"                                                                           + " " + ;
                        "clientes.uuid AS uuid,"                                                                           + " " + ;
                        "clientes.codigo AS codigo,"                                                                       + " " + ;
                        "clientes.nombre AS nombre,"                                                                       + " " + ;
                        "clientes.dni AS dni,"                                                                             + " " + ;
                        "clientes.establecimiento AS establecimiento,"                                                     + " " + ;
                        "clientes.fecha_ultima_llamada AS fecha_ultima_llamada,"                                           + " " + ;
                        "clientes.forma_pago_uuid AS forma_pago_uuid,"                                                     + " " + ;
                        "clientes.agente_uuid AS agente_uuid,"                                                             + " " + ;
                        "clientes.cliente_grupo_uuid AS cliente_grupo_uuid,"                                               + " " + ;
                        "clientes.cuenta_remesa_uuid AS cuenta_remesa_uuid,"                                               + " " + ;
                        "clientes.ruta_uuid AS ruta_uuid,"                                                                 + " " + ;
                        "direcciones.direccion AS direccion,"                                                              + " " + ;
                        "direcciones.poblacion AS poblacion,"                                                              + " " + ;
                        "direcciones.provincia AS provincia,"                                                              + " " + ;
                        "direcciones.codigo_postal AS codigo_postal,"                                                      + " " + ;
                        "direcciones.telefono AS telefono,"                                                                + " " + ;
                        "direcciones.movil AS movil,"                                                                      + " " + ;
                        "direcciones.email AS email,"                                                                      + " " + ;
                        "agentes.codigo AS codigo_agente,"                                                                 + " " + ;
                        "agentes.nombre AS nombre_agente,"                                                                 + " " + ;
                        "forma_pago.codigo AS codigo_forma_pago,"                                                          + " " + ;
                        "forma_pago.nombre AS nombre_forma_pago,"                                                          + " " + ;
                        "rutas.codigo AS codigo_ruta,"                                                                     + " " + ;
                        "rutas.nombre AS nombre_ruta,"                                                                     + " " + ;
                        "clientes_grupos.codigo AS codigo_grupo_cliente,"                                                  + " " + ;
                        "clientes_grupos.nombre AS nombre_grupo_cliente,"                                                  + " " + ;
                        "cuentas_remesa.codigo AS codigo_remesa,"                                                          + " " + ;
                        "cuentas_remesa.nombre AS nombre_remesa"                                                           + " " + ;
                     "FROM  clientes"                                                                                      + " " + ;
                        "LEFT JOIN direcciones ON clientes.uuid = direcciones.parent_uuid AND direcciones.principal"       + " " + ;
                        "LEFT JOIN forma_pago ON clientes.forma_pago_uuid = forma_pago.uuid"                               + " " + ;
                        "LEFT JOIN agentes ON clientes.agente_uuid = agentes.uuid"                                         + " " + ;
                        "LEFT JOIN rutas ON clientes.ruta_uuid = rutas.uuid"                                               + " " + ;
                        "LEFT JOIN clientes_grupos ON clientes.cliente_grupo_uuid = clientes_grupos.uuid"                  + " " + ;
                        "LEFT JOIN cuentas_remesa ON clientes.cuenta_remesa_uuid = cuentas_remesa.uuid"                    + " "

RETURN ( cSelect )*/

//---------------------------------------------------------------------------//