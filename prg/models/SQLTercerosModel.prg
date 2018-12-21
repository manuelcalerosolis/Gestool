#include "FiveWin.Ch"
#include "Factu.ch"

CLASS SQLTercerosModel FROM SQLCompanyModel

   DATA cTableName                     INIT "terceros"

   DATA cConstraints                   INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getByUuid( uuid )

   METHOD getSentenceClienteDireccionPrincipal( cBy, cId )

   METHOD getClienteDireccionPrincipal( cBy, cId ) ;
                                       INLINE ( atail( ::getDatabase():selectTrimedFetchHash( ::getSentenceClienteDireccionPrincipal( cBy, cId ) ) ) )

   METHOD getSentencePaymentDays( cId )

   METHOD getPaymentDays( cId )        INLINE ( atail( ::getDatabase():selectTrimedFetchHash( ::getSentencePaymentDays( cId ) ) ) )

   METHOD isWhereCodigoNotDeletedAndClient( cCodigo )

   METHOD isWhereCodigoNotDeletedAndProveedor( cCodigo )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTercerosModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;
                                                      "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "codigo",                     {  "create"    => "VARCHAR( 20 ) NOT NULL"                     ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "nombre",                     {  "create"    => "VARCHAR( 140 )"                             ,;
                                                      "default"   => {|| space( 140 ) } }                         )

   hset( ::hColumns, "dni",                        {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "tipo",                       {  "create"     => "ENUM( 'Cliente', 'Proveedor', 'Cliente y Proveedor' )"  ,;
                                                      "default"    => {|| 'Cliente' }  }                          )

   hset( ::hColumns, "metodo_pago_codigo",         {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "web",                        {  "create"    => "VARCHAR( 150 )"                             ,;
                                                      "default"   => {|| space( 150 ) } }                         )

   hset( ::hColumns, "agente_codigo",              {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "cuenta_remesa_codigo",       {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "tarifa_codigo",              {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "ruta_codigo",                {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "cliente_grupo_codigo",       {  "create"    => "VARCHAR( 20 )"                              ,;
                                                      "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "establecimiento",            {  "create"    => "VARCHAR( 100 )"                             ,;
                                                      "default"   => {|| space( 100 ) } }                         )

   hset( ::hColumns, "primer_dia_pago",            {  "create"    => "INT UNSIGNED"                               ,;
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "segundo_dia_pago",           {  "create"    => "INT UNSIGNED"                               ,;
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "tercer_dia_pago",            {  "create"    => "INT UNSIGNED"                               ,;
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "mes_vacaciones",             {  "create"    => "VARCHAR( 15 )"                              ,;
                                                      "default"   => {|| space( 15 ) } }                          )

   hset( ::hColumns, "regimen_iva",                {  "create"    => "VARCHAR( 15 )"                              ,;
                                                      "default"   => {|| space( 15 ) } }                          )

   hset( ::hColumns, "recargo_equivalencia",       {  "create"    => "TINYINT( 1 )"                               ,;
                                                      "default"   => {|| .f. } }                                  )

   hset( ::hColumns, "porcentaje_irpf",            {  "create"    => "DECIMAL(19,6)"                              ,;
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "bloqueado",                  {  "create"    => "TINYINT( 1 )"                               ,;
                                                      "default"   => {|| .f. } }                                  )

   hset( ::hColumns, "fecha_bloqueo",              {  "create"    => "DATE"                                       ,;
                                                      "default"   => {|| ctod( "" ) } }                           )

   hset( ::hColumns, "causa_bloqueo",              {  "create"    => "VARCHAR( 100 )"                             ,;
                                                      "default"   => {|| space( 100 ) } }                         )

   hset( ::hColumns, "excluir_fidelizacion",       {  "create"    => "TINYINT( 1 )"                               ,;
                                                      "default"   => {|| .f. } }                                  )

   hset( ::hColumns, "no_editar_datos",            {  "create"    => "TINYINT( 1 )"                               ,;
                                                      "default"   => {|| .f. } }                                  )

   hset( ::hColumns, "fecha_ultima_llamada",       {  "create"    => "DATE"                                       ,;
                                                      "default"   => {|| ctod( "" ) } }                           )

   hset( ::hColumns, "autorizado_venta_credito",   {  "create"    => "TINYINT( 1 )"                               ,;
                                                      "default"   => {|| .f. } }                                  )

   hset( ::hColumns, "bloquear_riesgo_alcanzado",  {  "create"    => "TINYINT( 1 )"                               ,;
                                                      "default"   => {|| .f. } }                                  )

   hset( ::hColumns, "fecha_peticion_riesgo",      {  "create"    => "DATE"                                       ,;
                                                      "default"   => {|| ctod( "" ) } }                           )

   hset( ::hColumns, "fecha_concesion_riesgo",     {  "create"    => "DATE"                                       ,;
                                                      "default"   => {|| ctod( "" ) } }                           )

   hset( ::hColumns, "riesgo",                     {  "create"    => "DECIMAL(19,6)"                              ,;
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "subcuenta",                  {  "create"    => "VARCHAR( 12 )"                              ,;
                                                      "default"   => {|| space( 12 ) } }                          )

   hset( ::hColumns, "cuenta_venta",               {  "create"    => "VARCHAR( 3 )"                               ,;
                                                      "default"   => {|| space( 3 ) } }                           )

   hset( ::hColumns, "subcuenta_descuento",        {  "create"    => "VARCHAR( 12 )"                              ,;
                                                      "default"   => {|| space( 12 ) } }                          )

   ::getTimeStampColumns()

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLTercerosModel

   local cSql

   TEXT INTO cSql

   SELECT terceros.id AS id,
      terceros.uuid AS uuid,
      terceros.codigo AS codigo,
      terceros.nombre AS nombre,
      terceros.dni AS dni,
      terceros.tipo AS tipo,
      terceros.establecimiento AS establecimiento,
      terceros.fecha_ultima_llamada AS fecha_ultima_llamada,
      terceros.metodo_pago_codigo AS metodo_pago_codigo,
      terceros.recargo_equivalencia AS recargo_equivalencia,
      metodos_pago.nombre AS nombre_metodo_pago,
      terceros.agente_codigo AS agente_codigo,
      agentes.nombre AS nombre_agente,
      terceros.cliente_grupo_codigo AS cliente_grupo_codigo,
      clientes_grupos.nombre AS nombre_grupo_cliente,
      terceros.cuenta_remesa_codigo AS cuenta_remesa_codigo,
      cuentas_remesa.nombre AS nombre_remesa,
      terceros.ruta_codigo AS ruta_codigo,
      rutas.nombre AS nombre_ruta,
      direcciones.direccion AS direccion,
      direcciones.poblacion AS poblacion,
      direcciones.provincia AS provincia,
      direcciones.codigo_postal AS codigo_postal,
      direcciones.telefono AS telefono,
      direcciones.movil AS movil,
      tarifas.codigo AS tarifa_codigo,
      tarifas.nombre AS tarifa_nombre,
      terceros.deleted_at
   FROM %1$s AS terceros
      LEFT JOIN %2$s AS direcciones
         ON terceros.uuid = direcciones.parent_uuid AND direcciones.codigo = 0
      LEFT JOIN %3$s AS metodos_pago
         ON terceros.metodo_pago_codigo = metodos_pago.codigo
      LEFT JOIN %4$s AS agentes
         ON terceros.agente_codigo = agentes.codigo
      LEFT JOIN %5$s AS rutas
         ON terceros.ruta_codigo = rutas.codigo
      LEFT JOIN %6$s AS clientes_grupos
         ON terceros.cliente_grupo_codigo = clientes_grupos.codigo
      LEFT JOIN %7$s AS cuentas_remesa
         ON terceros.cuenta_remesa_codigo = cuentas_remesa.codigo
      LEFT JOIN %8$s AS tarifas
         ON terceros.tarifa_codigo = tarifas.codigo

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLDireccionesModel():getTableName(), SQLMetodoPagoModel():getTableName(), SQLAgentesModel():getTableName(), SQLRutasModel():getTableName(), SQLClientesGruposModel():getTableName(), SQLCuentasRemesaModel():getTableName(), SQLArticulosTarifasModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getByUuid( uuid ) CLASS SQLTercerosModel

   local cGeneralSelect    := ::getInitialSelect()

   cGeneralSelect          += " WHERE clientes.uuid = " + quoted( uuid )

RETURN ( ::getDatabase():selectTrimedFetchHash( cGeneralSelect ) )

//---------------------------------------------------------------------------//

METHOD getSentenceClienteDireccionPrincipal( cBy, cId ) CLASS SQLTercerosModel

   local cSql

   TEXT INTO cSql

      SELECT %2$s.id AS id,
         %2$s.uuid AS uuid,
         %2$s.codigo AS codigo,
         %2$s.nombre AS nombre,
         %2$s.dni AS dni,
         %2$s.tarifa_codigo AS tarifa_codigo,
         %2$s.ruta_codigo AS ruta_codigo,
         %2$s.agente_codigo AS agente_codigo,
         %2$s.recargo_equivalencia AS recargo_equivalencia,
         %2$s.metodo_pago_codigo AS metodo_pago_codigo,
         direcciones.direccion AS direccion,
         direcciones.poblacion AS poblacion,
         direcciones.provincia AS provincia,
         direcciones.codigo_postal AS codigo_postal,
         direcciones.telefono AS telefono,
         direcciones.movil AS movil,
         direcciones.email AS email
      FROM %1$s AS %2$s
         LEFT JOIN %3$s direcciones
            ON %2$s.uuid = direcciones.parent_uuid AND direcciones.codigo = 0
         LEFT JOIN %4$s tarifas
            ON %2$s.tarifa_codigo = tarifas.codigo
      WHERE %2$s.%5$s = %6$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), ::cTableName, SQLDireccionesModel():getTableName(), SQLArticulosTarifasModel():getTableName(), cBy, quoted( cId ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSentencePaymentDays( cCodigoTercero ) CLASS SQLTercerosModel

   local cSql

   TEXT INTO cSql

   SELECT
      primer_dia_pago AS primer_dia_pago,
      segundo_dia_pago AS segundo_dia_pago,
      tercer_dia_pago AS tercer_dia_pago,
      mes_vacaciones AS mes_vacaciones

   FROM %1$s

   WHERE codigo = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( cCodigoTercero ) )

   logwrite( cSql )
   msgalert( cSql )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD isWhereCodigoNotDeletedAndClient( cCodigo )

   local cSql
   local nCount 

   TEXT INTO cSql

   SELECT
      COUNT(*)

   FROM %1$s

   WHERE codigo = %2$s AND deleted_at = 0 AND tipo LIKE '%Cliente%'

   ENDTEXT

   cSql     := hb_strformat( cSql, ::getTableName(), quoted( cCodigo ) )

   nCount   := ::getDatabase():getValue( cSQL )

RETURN ( hb_isnumeric( nCount ) .and. nCount > 0 )

//---------------------------------------------------------------------------//

METHOD isWhereCodigoNotDeletedAndProveedor( cCodigo )

   local cSql
   local nCount 

   TEXT INTO cSql

   SELECT
      COUNT(*)

   FROM %1$s

   WHERE codigo = %2$s AND deleted_at = 0 AND tipo LIKE '%Proveedor%'

   ENDTEXT

   cSql     := hb_strformat( cSql, ::getTableName(), quoted( cCodigo ) )

   nCount   := ::getDatabase():getValue( cSQL )

RETURN ( hb_isnumeric( nCount ) .and. nCount > 0 )

//---------------------------------------------------------------------------//