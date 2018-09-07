#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SQLClientesModel FROM SQLTercerosModel

   DATA cTableName               INIT "clientes"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getSentenceClienteDireccionPrincipal( cBy, cId )

   METHOD getClienteDireccionPrincipal( cBy, cId ) ;
                                 INLINE ( atail( ::getDatabase():selectTrimedFetchHash( ::getSentenceClienteDireccionPrincipal( cBy, cId ) ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLClientesModel

   ::super:getColumns()

   hset( ::hColumns, "agente_codigo",              {  "create"    => "VARCHAR( 20 )"       ,;
                                                      "default"   => {|| space( 20 ) } }   )

   hset( ::hColumns, "cuenta_remesa_codigo",       {  "create"    => "VARCHAR( 20 )"       ,;
                                                      "default"   => {|| space( 20 ) } }   )

   hset( ::hColumns, "tarifa_codigo",              {  "create"    => "VARCHAR( 20 )"       ,;
                                                      "default"   => {|| space( 20 ) } }   )

   hset( ::hColumns, "ruta_codigo",                {  "create"    => "VARCHAR( 20 )"       ,;
                                                      "default"   => {|| space( 20 ) } }   )

   hset( ::hColumns, "cliente_grupo_codigo",       {  "create"    => "VARCHAR( 20 )"       ,;
                                                      "default"   => {|| space( 20 ) } }   )

   hset( ::hColumns, "establecimiento",            {  "create"    => "VARCHAR( 100 )"      ,;
                                                      "default"   => {|| space( 100 ) } }  )

   hset( ::hColumns, "primer_dia_pago",            {  "create"    => "INT UNSIGNED"        ,;
                                                      "default"   => {|| 0 } }             )

   hset( ::hColumns, "segundo_dia_pago",           {  "create"    => "INT UNSIGNED"        ,;
                                                      "default"   => {|| 0 } }             )

   hset( ::hColumns, "tercer_dia_pago",            {  "create"    => "INT UNSIGNED"        ,;
                                                      "default"   => {|| 0 } }             )

   hset( ::hColumns, "mes_vacaciones",             {  "create"    => "VARCHAR( 15 )"       ,;
                                                      "default"   => {|| space( 15 ) } }   )

   hset( ::hColumns, "regimen_iva",                {  "create"    => "VARCHAR( 15 )"       ,;
                                                      "default"   => {|| space( 15 ) } }   )

   hset( ::hColumns, "recargo_equivalencia",       {  "create"    => "TINYINT( 1 )"        ,;
                                                      "default"   => {|| .f. } }           )

   hset( ::hColumns, "porcentaje_irpf",            {  "create"    => "DECIMAL(19,6)"       ,;
                                                      "default"   => {|| 0 } }             )

   hset( ::hColumns, "bloqueado",                  {  "create"    => "TINYINT( 1 )"        ,;
                                                      "default"   => {|| .f. } }           )

   hset( ::hColumns, "fecha_bloqueo",              {  "create"    => "DATE"                ,;
                                                      "default"   => {|| ctod( "" ) } }    )

   hset( ::hColumns, "causa_bloqueo",              {  "create"    => "VARCHAR( 100 )"      ,;
                                                      "default"   => {|| space( 100 ) } }  )

   hset( ::hColumns, "excluir_fidelizacion",       {  "create"    => "TINYINT( 1 )"        ,;
                                                      "default"   => {|| .f. } }           )

   hset( ::hColumns, "no_editar_datos",            {  "create"    => "TINYINT( 1 )"        ,;
                                                      "default"   => {|| .f. } }           )

   hset( ::hColumns, "fecha_ultima_llamada",       {  "create"    => "DATE"                ,;
                                                      "default"   => {|| ctod( "" ) } }    )

   hset( ::hColumns, "autorizado_venta_credito",   {  "create"    => "TINYINT( 1 )"        ,;
                                                      "default"   => {|| .f. } }           )

   hset( ::hColumns, "bloquear_riesgo_alcanzado",  {  "create"    => "TINYINT( 1 )"        ,;
                                                      "default"   => {|| .f. } }           )

   hset( ::hColumns, "fecha_peticion_riesgo",      {  "create"    => "DATE"                ,;
                                                      "default"   => {|| ctod( "" ) } }    )

   hset( ::hColumns, "fecha_concesion_riesgo",     {  "create"    => "DATE"                ,;
                                                      "default"   => {|| ctod( "" ) } }    )

   hset( ::hColumns, "riesgo",                     {  "create"    => "DECIMAL(19,6)"       ,;
                                                      "default"   => {|| 0 } }             )

   hset( ::hColumns, "subcuenta",                  {  "create"    => "VARCHAR( 12 )"       ,;
                                                      "default"   => {|| space( 12 ) } }   )

   hset( ::hColumns, "cuenta_venta",               {  "create"    => "VARCHAR( 3 )"        ,;
                                                      "default"   => {|| space( 3 ) } }    )

   hset( ::hColumns, "subcuenta_descuento",        {  "create"    => "VARCHAR( 12 )"       ,;
                                                      "default"   => {|| space( 12 ) } }   )
   
RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLClientesModel

   local cSelect  := "SELECT clientes.id AS id,"                                                                           + " " + ;
                        "clientes.uuid AS uuid,"                                                                           + " " + ;
                        "clientes.codigo AS codigo,"                                                                       + " " + ;
                        "clientes.nombre AS nombre,"                                                                       + " " + ;
                        "clientes.dni AS dni,"                                                                             + " " + ;
                        "clientes.establecimiento AS establecimiento,"                                                     + " " + ;
                        "clientes.fecha_ultima_llamada AS fecha_ultima_llamada,"                                           + " " + ;
                        "clientes.forma_pago_codigo AS forma_pago_codigo,"                                                 + " " + ;
                        "forma_pago.nombre AS nombre_forma_pago,"                                                          + " " + ;
                        "clientes.agente_codigo AS agente_codigo,"                                                         + " " + ;
                        "agentes.nombre AS nombre_agente,"                                                                 + " " + ;
                        "clientes.cliente_grupo_codigo AS cliente_grupo_codigo,"                                           + " " + ;
                        "clientes_grupos.nombre AS nombre_grupo_cliente,"                                                  + " " + ;
                        "clientes.cuenta_remesa_codigo AS cuenta_remesa_codigo,"                                           + " " + ;
                        "cuentas_remesa.nombre AS nombre_remesa,"                                                          + " " + ;
                        "clientes.ruta_codigo AS ruta_codigo,"                                                             + " " + ;
                        "rutas.nombre AS nombre_ruta,"                                                                     + " " + ;
                        "direcciones.direccion AS direccion,"                                                              + " " + ;
                        "direcciones.poblacion AS poblacion,"                                                              + " " + ;
                        "direcciones.provincia AS provincia,"                                                              + " " + ;
                        "direcciones.codigo_postal AS codigo_postal,"                                                      + " " + ;
                        "direcciones.telefono AS telefono,"                                                                + " " + ;
                        "direcciones.movil AS movil,"                                                                      + " " + ;
                        "direcciones.movil AS movil,"                                                                      + " " + ;
                        "tarifas.codigo AS tarifa_codigo, "                                                                + " " + ;
                        "tarifas.nombre AS tarifa_nombre "                                                                 + " " + ;
                     "FROM " + ::getTableName() + " AS clientes"                                                           + " " + ;
                        "LEFT JOIN " + SQLDireccionesModel():getTableName() + " direcciones"                               + " " + ;  
                           "ON clientes.uuid = direcciones.parent_uuid AND direcciones.codigo = 0"                          + " " + ;  
                        "LEFT JOIN " + SQLFormaPagoModel():getTableName() + " forma_pago"                                  + " " + ;  
                           "ON clientes.forma_pago_codigo = forma_pago.codigo"                                             + " " + ;
                        "LEFT JOIN " + SQLAgentesModel():getTableName() + " agentes"                                       + " " + ;   
                           "ON clientes.agente_codigo = agentes.codigo"                                                    + " " + ;
                        "LEFT JOIN " + SQLRutasModel():getTableName() + " rutas"                                           + " " + ;
                           "ON clientes.ruta_codigo = rutas.codigo"                                                        + " " + ;
                        "LEFT JOIN " + SQLClientesGruposModel():getTableName() + " clientes_grupos"                        + " " + ;
                           "ON clientes.cliente_grupo_codigo = clientes_grupos.codigo"                                     + " " + ;
                        "LEFT JOIN " + SQLCuentasRemesaModel():getTableName() + " cuentas_remesa"                          + " " + ;
                           "ON clientes.cuenta_remesa_codigo = cuentas_remesa.codigo"                                      + " " + ;
                        "LEFT JOIN " + SQLArticulosTarifasModel():getTableName() + " tarifas "                             + " " + ;
                           "ON clientes.tarifa_codigo = tarifas.codigo "


RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getSentenceClienteDireccionPrincipal( cBy, cId ) CLASS SQLClientesModel

   local cSelect  := "SELECT clientes.id AS id,"                                                                           + " " + ;
                        "clientes.uuid AS uuid,"                                                                           + " " + ;
                        "clientes.codigo AS codigo,"                                                                       + " " + ;
                        "clientes.nombre AS nombre,"                                                                       + " " + ;
                        "clientes.dni AS dni,"                                                                             + " " + ;
                        "clientes.tarifa_codigo AS tarifa_codigo,"                                                         + " " + ;
                        "direcciones.direccion AS direccion,"                                                              + " " + ;
                        "direcciones.poblacion AS poblacion,"                                                              + " " + ;
                        "direcciones.provincia AS provincia,"                                                              + " " + ;
                        "direcciones.codigo_postal AS codigo_postal,"                                                      + " " + ;
                        "direcciones.telefono AS telefono,"                                                                + " " + ;
                        "direcciones.movil AS movil,"                                                                      + " " + ;
                        "direcciones.email AS email"                                                                       + " " + ;
                     "FROM " + ::getTableName() + " AS clientes"                                                           + " " + ;
                        "LEFT JOIN " + SQLDireccionesModel():getTableName() + " direcciones"                               + " " + ;  
                            "ON clientes.uuid = direcciones.parent_uuid AND direcciones.codigo = 0"                        + " " + ;
                        "LEFT JOIN " + SQLArticulosTarifasModel():getTableName() + " tarifas "                             + " " + ;
                           "ON clientes.tarifa_codigo = tarifas.codigo"                                                    + " " 
                     "WHERE clientes." + cBy + " = " + quoted( cId ) 

RETURN ( cSelect )

//---------------------------------------------------------------------------//

