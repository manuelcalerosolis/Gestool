#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLArticulosModel FROM SQLCompanyModel

   DATA cTableName               INIT "Articulos"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getArticulosFamiliaUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLArticulosFamiliaModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setArticulosFamiliaUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLArticulosFamiliaModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getArticulosTipoUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLArticulosTipoModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setArticulosTipoUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLArticulosTipoModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getArticulosCategoriaUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLArticulosCategoriasModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setArticulosCategoriaUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLArticulosCategoriasModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getArticulosFabricanteUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLArticulosFabricantesModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setArticulosFabricanteUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLArticulosFabricantesModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getIvaTipoUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLIvaTiposModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setIvaTipoUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLIvaTiposModel():getUuidWhereCodigo( uValue ) ) )

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

   hset( ::hColumns, "articulos_familia_uuid",     {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulos_tipo_uuid",        {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulos_categoria_uuid",   {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulos_fabricante_uuid",  {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "iva_tipo_uuid",              {  "create"    => "VARCHAR( 40 )"                           ,;
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
                        "RPAD( IFNULL( articulos_familia.codigo, '' ), 20, ' ' ) AS articulos_familia_codigo, "      + ;
                        "articulos_familia.nombre AS articulos_familia_nombre, "    + ;
                        "RPAD( IFNULL( articulos_tipo.codigo, '' ), 20, ' ' ) AS articulos_tipo_codigo, "            + ;
                        "articulos_tipo.nombre AS articulos_tipo_nombre, "          + ;
                        "RPAD( IFNULL( articulos_categoria.codigo, '' ), 20, ' ' ) AS articulos_categoria_codigo, "  + ;
                        "articulos_categoria.nombre AS articulos_categoria_nombre "           + ;
                     "FROM articulos "                                              + ;
                        "LEFT JOIN articulos_familia ON articulos.articulos_familia_uuid = articulos_familia.uuid "  + ; 
                        "LEFT JOIN articulos_tipo ON articulos.articulos_tipo_uuid = articulos_tipo.uuid "           + ;
                        "LEFT JOIN articulos_categoria ON articulos.articulos_categoria_uuid = articulos_categoria.uuid " 

RETURN ( cSelect )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
