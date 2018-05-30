#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SQLClientesModel FROM SQLTercerosModel

   DATA cTableName               INIT "clientes"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getSentenceClienteDireccionPrincipal( cBy, cId )

   METHOD getClienteDireccionPrincipal( cBy, cId ) ;
                                 INLINE ( atail( ::getDatabase():selectTrimedFetchHash( ::getSentenceClienteDireccionPrincipal( cBy, cId ) ) ) )

   METHOD getAgenteUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 3 ), SQLAgentesModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setAgenteUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLAgentesModel():getUuidWhereCodigo( uValue ) ) )
   
   METHOD getCuentaRemesaUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 3 ), SQLCuentasRemesaModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setCuentaRemesaUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLCuentasRemesaModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getRutaUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 4 ), SQLRutasModel():getCodigoWhereUuid( uValue ) ) )
   
   METHOD setRutaUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLRutasModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getClienteGrupoUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 4 ), SQLClientesGruposModel():getCodigoWhereUuid( uValue ) ) )
   
   METHOD setClienteGrupoUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLClientesGruposModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getFormaPagoUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 3 ), SQLFormaPagoModel():getCodigoWhereUuid( uValue ) ) )
   
   METHOD setFormaPagoUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLFormaPagoModel():getUuidWhereCodigo( uValue ) ) )

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

   hset( ::hColumns, "tercer_dia_pago",            {  "create"    => "INT UNSIGNED"        ,;
                                                      "default"   => {|| 0 } }             )

   hset( ::hColumns, "mes_vacaciones",             {  "create"    => "VARCHAR( 15 )"       ,;
                                                      "default"   => {|| space( 15 ) } }   )

   hset( ::hColumns, "regimen_iva",                {  "create"    => "VARCHAR( 15 )"       ,;
                                                      "default"   => {|| space( 15 ) } }   )

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
                        "RPAD( IFNULL( agentes.codigo, ''), 20, ' ' ) AS codigo_agente,"                                   + " " + ;
                        "agentes.nombre AS nombre_agente,"                                                                 + " " + ;
                        "RPAD( IFNULL( forma_pago.codigo, ''), 20, ' ' )  AS codigo_forma_pago,"                           + " " + ;
                        "forma_pago.nombre AS nombre_forma_pago,"                                                          + " " + ;
                        "RPAD( IFNULL( rutas.codigo, ''), 20, ' ' ) AS codigo_ruta,"                                       + " " + ;
                        "rutas.nombre AS nombre_ruta,"                                                                     + " " + ;
                        "RPAD( IFNULL( clientes_grupos.codigo, ''), 20, ' ' ) AS codigo_grupo_cliente,"                    + " " + ;
                        "clientes_grupos.nombre AS nombre_grupo_cliente,"                                                  + " " + ;
                        "RPAD( IFNULL( cuentas_remesa.codigo, ''), 20, ' ' ) AS codigo_remesa,"                            + " " + ;
                        "cuentas_remesa.nombre AS nombre_remesa"                                                           + " " + ;
                     "FROM  clientes"                                                                                      + " " + ;
                        "LEFT JOIN direcciones ON clientes.uuid = direcciones.parent_uuid AND direcciones.principal"       + " " + ;
                        "LEFT JOIN forma_pago ON clientes.forma_pago_uuid = forma_pago.uuid"                               + " " + ;
                        "LEFT JOIN agentes ON clientes.agente_uuid = agentes.uuid"                                         + " " + ;
                        "LEFT JOIN rutas ON clientes.ruta_uuid = rutas.uuid"                                               + " " + ;
                        "LEFT JOIN clientes_grupos ON clientes.cliente_grupo_uuid = clientes_grupos.uuid"                  + " " + ;
                        "LEFT JOIN cuentas_remesa ON clientes.cuenta_remesa_uuid = cuentas_remesa.uuid"                    + " "

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getSentenceClienteDireccionPrincipal( cBy, cId ) CLASS SQLClientesModel

   local cSelect  := "SELECT clientes.id AS id,"                                                                           + " " + ;
                        "clientes.uuid AS uuid,"                                                                           + " " + ;
                        "clientes.codigo AS codigo,"                                                                       + " " + ;
                        "clientes.nombre AS nombre,"                                                                       + " " + ;
                        "clientes.dni AS dni,"                                                                             + " " + ;
                        "direcciones.direccion AS direccion,"                                                              + " " + ;
                        "direcciones.poblacion AS poblacion,"                                                              + " " + ;
                        "direcciones.provincia AS provincia,"                                                              + " " + ;
                        "direcciones.codigo_postal AS codigo_postal,"                                                      + " " + ;
                        "direcciones.telefono AS telefono,"                                                                + " " + ;
                        "direcciones.movil AS movil,"                                                                      + " " + ;
                        "direcciones.email AS email"                                                                       + " " + ;
                     "FROM clientes"                                                                                       + " " + ;
                        "LEFT JOIN direcciones ON clientes.uuid = direcciones.parent_uuid AND direcciones.principal"       + " " + ;
                     "WHERE clientes." + cBy + " = " + quoted( cId ) 

   cSelect        := ::addEmpresaWhere( cSelect )    

RETURN ( cSelect )

//---------------------------------------------------------------------------//

