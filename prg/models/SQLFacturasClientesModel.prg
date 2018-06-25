#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SQLFacturasClientesModel FROM SQLCompanyModel

   DATA cTableName               INIT "facturas_clientes"

   METHOD getColumns()

   METHOD getInitialSelect() 

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFacturasClientesModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"        ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"        ,;
                                                         "default"   => {|| win_uuidcreatestring() } }         )

   hset( ::hColumns, "delegacion_uuid",               {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| Delegation():Uuid() } }            )

   hset( ::hColumns, "sesion_uuid",                   {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| Session():Uuid() } }               )

   hset( ::hColumns, "serie",                         {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "numero",                        {  "create"    => "INT UNSIGNED"                         ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "fecha",                         {  "create"    => "DATE"                                 ,;
                                                         "default"   => {|| date() } }                         )

   hset( ::hColumns, "fecha_valor_stock",             {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"   ,;
                                                         "default"   => {|| hb_datetime() } }                  )

   hset( ::hColumns, "cliente_codigo",                {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

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

METHOD getInitialSelect() CLASS SQLFacturasClientesModel

   local cSelect  := "SELECT facturas_clientes.id AS id,"                                             + " " + ;
                        "facturas_clientes.uuid AS uuid,"                                             + " " + ;
                        "CONCAT( facturas_clientes.serie, '/', facturas_clientes.numero ) AS numero," + " " + ;
                        "facturas_clientes.delegacion_uuid AS delegacion_uuid,"                       + " " + ;
                        "facturas_clientes.sesion_uuid AS sesion_uuid,"                               + " " + ;
                        "facturas_clientes.cliente_codigo AS cliente_codigo,"                         + " " + ;
                        "clientes.nombre AS cliente_nombre,"                                          + " " + ;
                        "direcciones.direccion AS direccion_direccion,"                               + " " + ;
                        "direcciones.poblacion AS direccion_poblacion,"                               + " " + ;
                        "direcciones.codigo_provincia AS direccion_codigo_provincia,"                 + " " + ;
                        "direcciones.provincia AS direccion_provincia,"                               + " " + ;
                        "direcciones.codigo_postal AS direccion_codigo_postal,"                       + " " + ;
                        "direcciones.telefono AS direccion_telefono,"                                 + " " + ;
                        "direcciones.movil AS direccion_movil,"                                       + " " + ;
                        "direcciones.email AS direccion_email"                                        + " " + ;
                     "FROM " + ::getTableName() + " AS facturas_clientes"                             + " " + ;
                        "LEFT JOIN " + SQLClientesModel():getTableName() + " clientes"                + " " + ;  
                           "ON facturas_clientes.cliente_codigo = clientes.codigo"                    + " " + ;  
                        "LEFT JOIN " + SQLDireccionesModel():getTableName() + " direcciones"          + " " + ;  
                           "ON clientes.uuid = direcciones.parent_uuid AND direcciones.principal" 

RETURN ( cSelect )

//---------------------------------------------------------------------------//

