#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConversorGenericoController FROM SQLBrowseController

   DATA oDestinoController

   DATA uuidDocumentoOrigen

   DATA uuidDocumentoDestino

   DATA idDocumentoDestino

   DATA oController

   DATA oModel

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getDestinoController()       INLINE ( ::oController:oDestinoController )

   METHOD getOrigenController()        INLINE ( ::oController:oOrigenController )

   METHOD getSelected()                INLINE ( ::oController:aSelected )

   METHOD Convert()                    VIRTUAL

   METHOD Edit( nId )

   //Contrucciones tarias------------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLConversorDocumentosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ConversorGenericoController 

   ::oController                       := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorGenericoController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Edit( nId ) CLASS ConversorGenericoController

   if empty( nId )
      nId   := ::getIdFromRowSet()
   end if

RETURN ( ::getDestinoController():Edit( nId ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLConversorDocumentosModel FROM SQLCompanyModel

   DATA cTableName                     INIT "documentos_conversion"

   METHOD getColumns()

   METHOD insertRelationDocument( uuidOrigin, cTableOrigin, uuidDestination, cTableDestination )

   METHOD deleteWhereDestinoUuid( Uuid )

   METHOD countDocumentoWhereUuidOigen( uuidOrigen )

   METHOD getInitialSelect()

   METHOD getDestinoController()       INLINE ( ::oController:oDestinoController )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLConversorDocumentosModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
                                                      "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "documento_origen_tabla",     {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   hset( ::hColumns, "documento_origen_uuid",      {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "documento_destino_tabla",    {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   hset( ::hColumns, "documento_destino_uuid",     {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| space( 40 ) } }                          )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD insertRelationDocument( uuidOrigin, cTableOrigin, uuidDestination, cTableDestination ) CLASS SQLConversorDocumentosModel

   local cSql

   TEXT INTO cSql

      INSERT  INTO %1$s
         ( uuid, documento_origen_tabla, documento_origen_uuid, documento_destino_tabla, documento_destino_uuid ) 
      VALUES
         ( UUID(), %2$s, %3$s,%4$s , %5$s )
      
   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( cTableOrigin ), quoted( uuidOrigin ), quoted( cTableDestination ), quoted( uuidDestination ) )
                                 
RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//

METHOD deleteWhereDestinoUuid( Uuid ) CLASS SQLConversorDocumentosModel

   local cSql

   TEXT INTO cSql

      DELETE FROM %1$s
         WHERE documento_destino_uuid= %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( Uuid ) )
   
RETURN ( getSQLDatabase():Exec( cSql ) )

//---------------------------------------------------------------------------//

METHOD countDocumentoWhereUuidOigen( uuidOrigen ) CLASS SQLConversorDocumentosModel
 
   local cSql

   TEXT INTO cSql

      SELECT COUNT(*)
         FROM %1$s
         WHERE documento_origen_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidOrigen ) )
  
RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLConversorDocumentosModel

RETURN ( ::getDestinoController():getModel():getInitialWhereDocumentos( ::oController:setWhereArray( ::oController:aCreatedDocument ) ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestConversorDocumentosController FROM TestCase

   DATA aSelected                      INIT {}

   DATA oController

   DATA aCategories                    INIT { "all", "conversor_documento" }

   DATA oAlbaranesComprasController

   METHOD getAlbaranesComprasController();
                                       INLINE ( if( empty( ::oAlbaranesComprasController ), ::oAlbaranesComprasController := AlbaranesComprasController():New( self ), ), ::oAlbaranesComprasController )

   METHOD beforeClass() 

   METHOD afterClass()

   METHOD Before() 

   METHOD create_albaran()

   METHOD close_resumen_view()

   METHOD test_create_distinto_tercero()

   METHOD test_create_distinta_ruta()

   METHOD test_create_distinto_metodo_pago() 

   METHOD test_create_distinta_tarifa()

   METHOD test_create_distinto_recargo()

   METHOD test_create_distinta_serie()

   METHOD test_create_con_a_descuento()

   METHOD test_create_con_b_descuento()

   METHOD test_create_iguales_y_distinto()

   METHOD test_create_iguales()

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestConversorDocumentosController

   ::oController  := ConversorDocumentosController():New( ::getAlbaranesComprasController() )  

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestConversorDocumentosController

   ::oController:End()

   if !empty( ::oAlbaranesComprasController )
      ::oAlbaranesComprasController:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestConversorDocumentosController

   SQLTercerosModel():truncateTable()

   SQLDireccionesModel():truncateTable()

   SQLAlmacenesModel():truncateTable()
      SQLUbicacionesModel():truncateTable()

   SQLMetodoPagoModel():truncateTable()

   SQLArticulosModel():truncateTable()
   
   SQLAlbaranesComprasModel():truncateTable()
      SQLAlbaranesComprasLineasModel():truncateTable()
      SQLAlbaranesComprasDescuentosModel():truncateTable()

   SQLFacturasComprasModel():truncateTable()
      SQLFacturasComprasLineasModel():truncateTable()
      SQLFacturasComprasDescuentosModel():truncateTable()

   SQLConversorDocumentosModel():truncateTable()
   SQLRecibosModel():truncateTable()

   SQLArticulosTarifasModel():truncateTable()

   SQLAgentesModel():truncateTable()

   SQLTiposIvaModel():truncateTable()
   SQLUbicacionesModel():truncateTable()
   SQLArticulosTarifasModel():truncateTable()
   SQLRutasModel():truncateTable()

   SQLConversorDocumentosModel():truncateTable()

   SQLMetodoPagoModel():test_create_con_plazos_con_hash() 
   SQLMetodoPagoModel():test_create_con_plazos_con_hash( {  "codigo"          => "1",;
                                                            "numero_plazos"   => 5  } ) 

   SQLTiposIvaModel():test_create_iva_al_21()

   SQLAlmacenesModel():test_create_almacen_principal()

   SQLUbicacionesModel():test_create_trhee_with_parent( SQLAlmacenesModel():test_get_uuid_almacen_principal() )

   SQLRutasModel():test_create_ruta_principal()
   SQLRutasModel():test_create_ruta_alternativa()

   SQLArticulosModel():test_create_precio_con_descuentos()

   SQLArticulosTarifasModel():test_create_tarifa_base()
   SQLArticulosTarifasModel():test_create_tarifa_mayorista()

   SQLAgentesModel():test_create_agente_principal()

   SQLTercerosModel():test_create_proveedor_con_plazos( 0 )
   SQLTercerosModel():test_create_proveedor_con_plazos( 1 )

   ::aSelected := {}

   ::oController:hProcesedAlbaran := {}

   ::oController:lDescuento := .f.

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD create_albaran( hAlbaran )

   local hLinea         := {}

   SQLAlbaranesComprasModel():create_albaran_compras( hAlbaran )

   hLinea               := { "parent_uuid"   => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( hget( hAlbaran,"serie" ), hget( hAlbaran, "numero" ) ) }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hLinea )
  
   aadd( ::aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( hget( hAlbaran, "serie" ), hget( hAlbaran, "numero" ) ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD close_resumen_view()

   ::oController:getResumenView():setEvent( 'painted',;
         {| self | ;
            testWaitSeconds( 1 ),;
            self:getControl( IDCANCEL ):Click() } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinto_tercero() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"  => "A",;
                        "numero" =>  3 } )

   ::create_albaran( {  "tercero_codigo"  => "1" ,;
                        "numero"          =>  4,;
                        "serie"           => "A"  } )
   
   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "Genera dos facturas con distintos terceros" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con distintos terceros" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinta_ruta() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"        => "A",;
                        "numero"       =>  3 } )

   ::create_albaran( {  "ruta_codigo"  => "1" ,;
                        "numero"       =>  4  ,;
                        "serie"        => "A" } )
   
   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera dos facturas con distintas rutas" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con distintas rutas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinto_metodo_pago() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"                 => "A",;
                        "numero"                =>  3 } )

   ::create_albaran( {  "metodo_pago_codigo"    => "1" ,;
                        "numero"                =>  4  ,;
                        "serie"                 => "A" } )
   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera facturas con distintos metodos de pago" )
   ::Assert():equals( 8, SQLRecibosModel():countRecibos(), "Genera 8 recibos a traves de 2 albaranes con distintos metodos de pago" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinta_tarifa() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  3 } )

   ::create_albaran( {  "tarifa_codigo"   => "1" ,;
                        "numero"          =>  4  ,;
                        "serie"           => "A" } )
   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "creacion de facturas con dos tarifas diferentes" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con dos tarifas diferentes" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinto_recargo() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"                    => "A",;
                        "numero"                   =>  3 } )

   ::create_albaran( {  "recargo_equivalencia"     =>  1  ,;
                        "numero"                   =>  4  ,;
                        "serie"                    => "A" } )

   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera facturas con distintos recargos de equivalencia" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con distintos recargos de equivalencia" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinta_serie() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"     => "A",;
                        "numero"    =>  3 } )

   ::create_albaran( {   "serie"    => "B",;
                         "numero"   =>  5 } )

   ::close_resumen_view()
  
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera factras con distintas series" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con distintas series" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_con_a_descuento() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"        => "A",;
                        "numero"       =>  3 } )

   SQLAlbaranesComprasDescuentosModel():test_create_descuento( { "parent_uuid" => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 ) } )

   ::create_albaran( {  "numero"       =>  4 ,;
                        "serie"        => "A" } )

   ::close_resumen_view()
  
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera 2 facturas con descuento en el primero" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con descuento en el primero" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_con_b_descuento() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"        => "A",;
                        "numero"       =>  3 } )


   ::create_albaran( {  "numero"       =>  4 ,;
                        "serie"        => "A" } )

   SQLAlbaranesComprasDescuentosModel():test_create_descuento( { "parent_uuid" => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 ) } )

   ::close_resumen_view()
  
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera 2 facturas con descuentos en el segundo" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con descuento en el segundo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_iguales_y_distinto() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  3 } )

   ::create_albaran( {  "tercero_codigo"  => "1" ,;
                        "numero"          =>  4  ,;
                        "serie"           => "A" } )

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  5 } )

   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera 2 facturas a traves de 3 albaranes" )
   ::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 3 albaranes" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_iguales() CLASS TestConversorDocumentosController

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  3 } )

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  4 } )

   ::close_resumen_view()
   
   ::oController:runConvertAlbaran( ::aSelected )

   ::Assert():equals( 1, SQLFacturasComprasModel():countFacturas(), "genera 1 factura a traves de 2 albaranes iguales" )
   ::Assert():equals( 3, SQLRecibosModel():countRecibos(), "Genera 3 recibos a traves de 2 albaranes iguales" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

