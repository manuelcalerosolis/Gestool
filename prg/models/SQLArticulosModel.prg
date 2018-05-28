#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLArticulosModel FROM SQLCompanyModel

   DATA cTableName               INIT "articulos"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getArticuloFamiliaUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLArticulosFamiliaModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setArticuloFamiliaUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLArticulosFamiliaModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getArticuloTipoUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLArticulosTipoModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setArticuloTipoUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLArticulosTipoModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getArticuloCategoriaUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLArticulosCategoriasModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setArticuloCategoriaUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLArticulosCategoriasModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getArticuloFabricanteUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLArticulosFabricantesModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setArticuloFabricanteUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLArticulosFabricantesModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getTipoIvaUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLTiposIvaModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setTipoIvaUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLTiposIvaModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getImpuestoEspecialAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLImpuestosEspecialesModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setImpuestoEspecialAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLImpuestosEspecialesModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getPrimeraPropiedadUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLPropiedadesModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setPrimeraPropiedadUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLPropiedadesModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getSegundaPropiedadUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLPropiedadesModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setSegundaPropiedadUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLPropiedadesModel():getUuidWhereCodigo( uValue ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosModel
   
   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   ::getEmpresaColumns()

   hset( ::hColumns, "codigo",                     {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",                     {  "create"    => "VARCHAR( 200 )"                          ,;
                                                      "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "articulo_familia_uuid",      {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulo_tipo_uuid",         {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulo_categoria_uuid",    {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulo_fabricante_uuid",   {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "tipo_iva_uuid",              {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "impuesto_especial_uuid",     {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

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

   hset( ::hColumns, "primera_propiedad_uuid",     {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "segunda_propiedad_uuid",     {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLArticulosModel

   local cSelect  := "SELECT articulos.id AS id, "                                  + ;
                        "articulos.uuid AS uuid, "                                  + ;
                        "articulos.codigo AS codigo, "                              + ;
                        "articulos.nombre AS nombre, "                              + ;
                        "articulos.obsoleto AS obsoleto, "                          + ;
                        "articulos.caducidad AS caducidad, "                        + ;
                        "articulos.periodo_caducidad AS periodo_caducidad, "        + ;
                        "articulos.lote AS lote, "                                  + ;
                        "articulos.lote_actual AS lote_actual, "                    + ;
                        "articulos.precio_costo AS precio_costo, "                  + ;
<<<<<<< HEAD
                        "RPAD( IFNULL( articulos_familias.codigo, '' ), 20, ' ' ) AS articulo_familia_codigo, "               + ;
                        "articulos_familias.nombre AS articulo_familia_nombre, "                                              + ;
                        "RPAD( IFNULL( articulos_tipos.codigo, '' ), 20, ' ' ) AS articulo_tipo_codigo, "                     + ;
                        "articulos_tipos.nombre AS articulo_tipo_nombre, "                                                    + ;
                        "RPAD( IFNULL( articulos_categorias.codigo, '' ), 20, ' ' ) AS articulo_categoria_codigo, "           + ;
                        "articulos_categorias.nombre AS articulo_categoria_nombre, "                                          + ;
                        "RPAD( IFNULL( articulos_fabricantes.codigo, '' ), 20, ' ' ) AS articulo_fabricante_codigo, "         + ;
                        "articulos_fabricantes.nombre AS articulo_fabricante_nombre, "                                        + ;
                        "RPAD( IFNULL( tipos_iva.codigo, '' ), 20, ' ' ) AS tipo_iva_codigo, "                                + ;
                        "tipos_iva.nombre AS tipo_iva_nombre, "                                                               + ;
                        "RPAD( IFNULL( impuestos_especiales.codigo, '' ), 20, ' ' ) AS impuesto_especial_codigo, "            + ;
                        "impuestos_especiales.nombre AS impuesto_especial_nombre "                                            + ;
                     "FROM articulos "                                                                                        + ;
                        "LEFT JOIN articulos_familias ON articulos.articulo_familia_uuid = articulos_familias.uuid "          + ; 
                        "LEFT JOIN articulos_tipos ON articulos.articulo_tipo_uuid = articulos_tipos.uuid "                   + ;
                        "LEFT JOIN articulos_categorias ON articulos.articulo_categoria_uuid = articulos_categorias.uuid "    + ; 
                        "LEFT JOIN articulos_fabricantes ON articulos.articulo_fabricante_uuid = articulos_fabricantes.uuid " + ;
                        "LEFT JOIN tipos_iva ON articulos.tipo_iva_uuid = tipos_iva.uuid "                                    + ;
                        "LEFT JOIN impuestos_especiales ON articulos.impuesto_especial_uuid = impuestos_especiales.uuid " 
=======
                        "RPAD( IFNULL( articulos_familia.codigo, '' ), 20, ' ' ) AS articulos_familia_codigo, "      + ;
                        "articulos_familia.nombre AS articulos_familia_nombre, "    + ;
                        "RPAD( IFNULL( articulos_tipo.codigo, '' ), 20, ' ' ) AS articulos_tipo_codigo, "            + ;
                        "articulos_tipo.nombre AS articulos_tipo_nombre, "          + ;
                        "RPAD( IFNULL( articulos_categoria.codigo, '' ), 20, ' ' ) AS articulos_categoria_codigo, "  + ;
                        "articulos_categoria.nombre AS articulos_categoria_nombre, "          + ;
                        "RPAD( IFNULL( articulos_fabricante.codigo, '' ), 20, ' ' ) AS articulos_fabricante_codigo, "  + ;
                        "articulos_fabricante.nombre AS articulos_fabricante_nombre "           + ;
                     "FROM articulos "                                              + ;
                        "LEFT JOIN articulos_familia ON articulos.articulos_familia_uuid = articulos_familia.uuid "  + ; 
                        "LEFT JOIN articulos_tipo ON articulos.articulos_tipo_uuid = articulos_tipo.uuid "           + ;
                        "LEFT JOIN articulos_categoria ON articulos.articulos_categoria_uuid = articulos_categoria.uuid " + ;
                        "LEFT JOIN articulos_fabricante ON articulos.articulos_fabricante_uuid = articulos_fabricante.uuid " 
>>>>>>> 2d0ffb78ce5a5899d3bdfea67eb2ee592f662821

RETURN ( cSelect )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
