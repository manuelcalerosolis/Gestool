#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SQLClientesModel FROM SQLTercerosModel

   DATA cTableName               INIT "clientes"

   METHOD getColumns()

   METHOD getInitialSelect()

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
                        "clientes.agente_uuid AS agente_uuid,"                                                             + " " + ;
                        "direcciones.direccion AS direccion,"                                                              + " " + ;
                        "direcciones.poblacion AS poblacion,"                                                              + " " + ;
                        "direcciones.provincia AS provincia,"                                                              + " " + ;
                        "direcciones.codigo_postal AS codigo_postal,"                                                      + " " + ;
                        "direcciones.telefono AS telefono,"                                                                + " " + ;
                        "direcciones.movil AS movil,"                                                                      + " " + ;
                        "direcciones.email AS email,"                                                                      + " " + ;
                        "agentes.codigo AS codigo_agente,"                                                                 + " " + ;
                        "agentes.nombre AS nombre_agente"                                                                  + " " + ;
                     "FROM  clientes"                                                                                      + " " + ;
                        "LEFT JOIN direcciones ON clientes.uuid = direcciones.parent_uuid AND direcciones.principal"       + " " + ;
                        "LEFT JOIN agentes ON clientes.agente_uuid = agentes.uuid"                                         + " "

RETURN ( cSelect )

//---------------------------------------------------------------------------//