#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLArticulosModel FROM SQLCompanyModel

   DATA cTableName               INIT "articulos"

   DATA cAs                      INIT "articulos"

   METHOD getColumns()

   METHOD getGeneralSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosModel
   
   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",                     {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",                     {  "create"    => "VARCHAR( 200 )"                          ,;
                                                      "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "articulo_familia_codigo",    {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "articulo_tipo_codigo",       {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "articulo_categoria_codigo",  {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "articulo_fabricante_codigo", {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "articulo_temporada_codigo",  {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "tipo_iva_codigo",            {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "impuesto_especial_codigo",   {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "unidades_medicion_grupos_codigo",;
                                                   {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "obsoleto",                   {  "create"    => "BIT"                                     ,;
                                                      "default"   => {|| .f. } }                               )

   hset( ::hColumns, "caducidad",                  {  "create"    => "INTEGER"                                 ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "periodo_caducidad",          {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "lote",                       {  "create"    => "BIT"                                     ,;
                                                      "default"   => {|| .f. } }                               )

   hset( ::hColumns, "lote_actual",                {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "precio_costo",               {  "create"    => "FLOAT( 16, 6 )"                          ,;
                                                      "default"   => {|| 0 } }                                 )

   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getGeneralSelect() CLASS SQLArticulosModel

   local cSelect  := "SELECT articulos.id AS id, "                                                                         + ;
                        "articulos.uuid AS uuid, "                                                                         + ;
                        "articulos.codigo AS codigo, "                                                                     + ;
                        "articulos.nombre AS nombre, "                                                                     + ;
                        "articulos.obsoleto AS obsoleto, "                                                                 + ;
                        "articulos.caducidad AS caducidad, "                                                               + ;
                        "articulos.periodo_caducidad AS periodo_caducidad, "                                               + ;
                        "articulos.lote AS lote, "                                                                         + ;
                        "articulos.lote_actual AS lote_actual, "                                                           + ;
                        "articulos.precio_costo AS precio_costo, "                                                         + ;
                        "articulos.articulo_familia_codigo, "                                                              + ;
                        "articulos_familias.nombre AS articulo_familia_nombre, "                                           + ;
                        "articulos.articulo_tipo_codigo, "                                                                 + ;
                        "articulos_tipos.nombre AS articulo_tipo_nombre, "                                                 + ;
                        "articulos.articulo_categoria_codigo, "                                                            + ;
                        "articulos_categorias.nombre AS articulo_categoria_nombre, "                                       + ;
                        "articulos.articulo_fabricante_codigo, "                                                           + ;
                        "articulos_fabricantes.nombre AS articulo_fabricante_nombre, "                                     + ;
                        "articulos.tipo_iva_codigo, "                                                                      + ;
                        "tipos_iva.nombre AS tipo_iva_nombre, "                                                            + ;
                        "articulos.impuesto_especial_codigo, "                                                             + ;
                        "impuestos_especiales.nombre AS impuesto_especial_nombre, "                                        + ;
                        "articulos.unidades_medicion_grupos_codigo, "                                                      + ;
                        "unidades_medicion_grupos.nombre AS unidades_medicion_grupos_nombre, "                             + ;
                        "articulos.articulo_temporada_codigo, "                                                            + ;
                        "articulos_temporadas.nombre AS articulo_temporada_nombre "                                        + ;
                     "FROM " + ::getTableName() + " AS articulos "                                                         + ;
                        "LEFT JOIN " + SQLArticulosFamiliaModel():getTableName() + " AS articulos_familias "               + ;
                           "ON articulos.articulo_familia_codigo = articulos_familias.codigo "                             + ;
                        "LEFT JOIN " + SQLArticulosTipoModel():getTableName() + " AS articulos_tipos "                     + ; 
                           "ON articulos.articulo_tipo_codigo = articulos_tipos.codigo "                                   + ;
                        "LEFT JOIN " + SQLArticulosTipoModel():getTableName() + " AS articulos_categorias "                + ;
                           "ON articulos.articulo_categoria_codigo = articulos_categorias.codigo "                         + ; 
                        "LEFT JOIN " + SQLArticulosCategoriasModel():getTableName() + " AS articulos_fabricantes "         + ;
                           "ON articulos.articulo_fabricante_codigo = articulos_fabricantes.codigo "                       + ;
                        "LEFT JOIN " + SQLArticulosCategoriasModel():getTableName() + " AS tipos_iva "                     + ;
                           "ON articulos.tipo_iva_codigo = tipos_iva.codigo "                                              + ;
                        "LEFT JOIN " + SQLArticulosTemporadasModel():getTableName() + " AS articulos_temporadas "          + ;
                           "ON articulos.articulo_temporada_codigo = articulos_temporadas.codigo "                         + ;
                        "LEFT JOIN " + SQLImpuestosEspecialesModel():getTableName() + " AS impuestos_especiales "          + ;
                           "ON articulos.impuesto_especial_codigo = impuestos_especiales.codigo "                          + ;
                        "LEFT JOIN " + SQLUnidadesMedicionGruposModel():getTableName() + " AS unidades_medicion_grupos "   + ;
                           "ON articulos.unidades_medicion_grupos_codigo = unidades_medicion_grupos.codigo "                                       

RETURN ( cSelect )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
