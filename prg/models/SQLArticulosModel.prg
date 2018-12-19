#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLArticulosModel FROM SQLCompanyModel

   DATA cTableName               INIT "articulos"

   DATA cConstraints             INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD getInitialSelect()

#ifdef __TEST__   

   METHOD testCreatePrecioConDescuentos() 

   METHOD testCreateArticuloConUuid( uuid )

   METHOD testCreateArticuloConUnidadeDeMedicionCajasPalets( uuid )

   METHOD testCreateArticuloConTarifaMayorista() 

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosModel
   
   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"          ,;
                                                      "default"   => {|| 0 } }                                )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"          ,;
                                                      "default"   => {|| win_uuidcreatestring() } }           )

   hset( ::hColumns, "codigo",                     {  "create"    => "VARCHAR( 20 )"                          ,;
                                                      "default"   => {|| space( 20 ) } }                      )

   hset( ::hColumns, "nombre",                     {  "create"    => "VARCHAR( 200 )"                         ,;
                                                      "default"   => {|| space( 200 ) } }                     )

   hset( ::hColumns, "familia_codigo",             {  "create"    => "VARCHAR( 20 )"                          ,;
                                                      "default"   => {|| space( 20 ) } }                      )

   hset( ::hColumns, "tipo_codigo",                {  "create"    => "VARCHAR( 20 )"                          ,;
                                                      "default"   => {|| space( 20 ) } }                      )

   hset( ::hColumns, "categoria_codigo",           {  "create"    => "VARCHAR( 20 )"                          ,;
                                                      "default"   => {|| space( 20 ) } }                      )

   hset( ::hColumns, "fabricante_codigo",          {  "create"    => "VARCHAR( 20 )"                          ,;
                                                      "default"   => {|| space( 20 ) } }                      )

   hset( ::hColumns, "temporada_codigo",           {  "create"    => "VARCHAR( 20 )"                          ,;
                                                      "default"   => {|| space( 20 ) } }                      )

   hset( ::hColumns, "tipo_iva_codigo",            {  "create"    => "VARCHAR( 20 )"                          ,;
                                                      "default"   => {|| space( 20 ) } }                      )

   hset( ::hColumns, "impuesto_especial_codigo",   {  "create"    => "VARCHAR( 20 )"                          ,;
                                                      "default"   => {|| space( 20 ) } }                      )

   hset( ::hColumns, "unidades_medicion_grupos_codigo",;
                                                   {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "obsoleto",                   {  "create"    => "TINYINT"                                 ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "caducidad",                  {  "create"    => "INTEGER"                                 ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "periodo_caducidad",          {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "lote",                       {  "create"    => "TINYINT"                                 ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "lote_actual",                {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "precio_costo",               {  "create"    => "FLOAT( 16, 6 )"                          ,;
                                                      "default"   => {|| 0 } }                                 )

   ::getTimeStampColumns()

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLArticulosModel

  local cSql

   TEXT INTO cSql

   SELECT articulos.id AS id,
      articulos.uuid AS uuid, 
      articulos.codigo AS codigo, 
      articulos.nombre AS nombre, 
      articulos.obsoleto AS obsoleto, 
      articulos.caducidad AS caducidad, 
      articulos.periodo_caducidad AS periodo_caducidad,
      articulos.lote AS lote, 
      articulos.lote_actual AS lote_actual, 
      articulos.precio_costo AS precio_costo, 
      articulos.familia_codigo AS familia_codigo, 
      articulos_familias.nombre AS articulo_familia_nombre, 
      articulos.tipo_codigo AS tipo_codigo, 
      articulos_tipos.nombre AS articulo_tipo_nombre, 
      articulos.categoria_codigo AS categoria_codigo, 
      articulos_categorias.nombre AS articulo_categoria_nombre, 
      articulos.fabricante_codigo AS fabricante_codigo,
      articulos_fabricantes.nombre AS articulo_fabricante_nombre, 
      articulos.tipo_iva_codigo AS tipo_iva_codigo, 
      tipos_iva.nombre AS tipo_iva_nombre,
      articulos.impuesto_especial_codigo AS impuesto_especial_codigo, 
      impuestos_especiales.nombre AS impuesto_especial_nombre, 
      articulos.unidades_medicion_grupos_codigo AS unidades_medicion_grupos_codigo, 
      unidades_medicion_grupos.nombre AS unidades_medicion_grupos_nombre, 
      articulos.temporada_codigo AS temporada_codigo,
      articulos_temporadas.nombre AS articulo_temporada_nombre, 
      articulos.created_at AS created_at,
      articulos.updated_at AS updated_at,
      articulos.deleted_at AS deleted_at 

   FROM %1$s AS articulos 

   LEFT JOIN %2$s AS articulos_familias 
      ON articulos.familia_codigo = articulos_familias.codigo 

   LEFT JOIN %3$s AS articulos_tipos 
      ON articulos.tipo_codigo = articulos_tipos.codigo 

   LEFT JOIN %4$s AS articulos_categorias 
      ON articulos.categoria_codigo = articulos_categorias.codigo

   LEFT JOIN %5$s AS articulos_fabricantes 
      ON articulos.fabricante_codigo = articulos_fabricantes.codigo 

   LEFT JOIN %5$s AS tipos_iva 
      ON articulos.tipo_iva_codigo = tipos_iva.codigo

   LEFT JOIN %6$s AS articulos_temporadas 
      ON articulos.temporada_codigo = articulos_temporadas.codigo

   LEFT JOIN %7$s AS impuestos_especiales 
      ON articulos.impuesto_especial_codigo = impuestos_especiales.codigo

   LEFT JOIN %8$s AS unidades_medicion_grupos 
      ON articulos.unidades_medicion_grupos_codigo = unidades_medicion_grupos.codigo

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           SQLArticulosFamiliaModel():getTableName(),;
                           SQLArticulosTipoModel():getTableName(),;
                           SQLArticulosTipoModel():getTableName(),;
                           SQLTiposIvaModel():getTableName(),;
                           SQLArticulosCategoriasModel():getTableName(),;
                           SQLArticulosTemporadasModel():getTableName(),;
                           SQLImpuestosEspecialesModel():getTableName(),;
                           SQLUnidadesMedicionGruposModel():getTableName() )                                      

RETURN ( cSql )                                      

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD testCreatePrecioConDescuentos() CLASS SQLArticulosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "codigo", "0" )
   hset( hBuffer, "nombre", "Articulo con descuentos" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateArticuloConUuid( uuid ) CLASS SQLArticulosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "codigo", "0" )
   hset( hBuffer, "nombre", "Articulo test" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateArticuloConUnidadeDeMedicionCajasPalets() CLASS SQLArticulosModel

   local uuid
   local hBuffer

   uuid     := win_uuidcreatestring()

   SQLArticulosModel():truncateTable()
   SQLUnidadesMedicionGruposModel():truncateTable()
   SQLUnidadesMedicionOperacionesModel():truncateTable()

   SQLUnidadesMedicionGruposModel():testCreate()
   SQLUnidadesMedicionOperacionesModel():testCreateVentasPorCajas( uuid )
   SQLUnidadesMedicionOperacionesModel():testCreateComprasPorPalets( uuid )
   SQLUnidadesMedicionOperacionesModel():testCreateInventarioPorUnidades( uuid )

   hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "codigo", "0" )
   hset( hBuffer, "nombre", "Artículo con unidad de venta como cajas y palets" )
   hset( hBuffer, "unidades_medicion_grupos_codigo", "0" )
   hset( hBuffer, "precio_costo", 50 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD testCreateArticuloConTarifaMayorista() CLASS SQLArticulosModel

   local uuid
   local hBuffer

   uuid     := win_uuidcreatestring()

   SQLArticulosModel():truncateTable()
   SQLArticulosTarifasModel():truncateTable() 
   SQLUnidadesMedicionGruposModel():truncateTable()
   SQLUnidadesMedicionOperacionesModel():truncateTable()

   SQLArticulosTarifasModel():testCreateTarifaBase() 
   SQLArticulosTarifasModel():testCreateTarifaMayorista() 

   hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "codigo", "1" )
   hset( hBuffer, "nombre", "Artículo con tarifa mayorista" )
   hset( hBuffer, "precio_costo", 50 )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
