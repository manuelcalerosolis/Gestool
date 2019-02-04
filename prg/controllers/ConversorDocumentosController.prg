#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConversorDocumentosController FROM SQLNavigatorController

   DATA aDocumentosDestino 

   DATA aCreatedDocument               INIT {}

   DATA oDestinoController

   DATA oAlbaranesComprasController

   DATA uuidDocumentoOrigen

   DATA uuidDocumentoDestino

   DATA idDocumentoDestino

   DATA aConvert                       INIT {}

   DATA aHeader                        INIT {}

   DATA aLines                         INIT {}

   DATA aDiscounts                     INIT {}

   DATA oResumenView

   DATA oConvertirView

   DATA hProcesedAlbaran               INIT{}

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()

   METHOD getDestinoController()       INLINE ( ::oDestinoController )

   METHOD Convert()
      METHOD setHeader()
      METHOD addHeader()
      METHOD setLines()
      METHOD addLines()
      METHOD setDiscounts()

   METHOD runConvertAlbaranCompras( aSelected ) 
      METHOD convertAlbaranCompras( aSelected )

   Method isAlbaranEquals( hAlbaran )

   METHOD setWhereArray( aSelected )

   METHOD isAlbaranNotConverted( hAlbaran ) ;
                                       INLINE ( ::getModel():countDocumentoWhereUuidOigen( hget( hAlbaran, "uuid" ) ) == 0 )

   METHOD insertRelationDocument()     INLINE ( ::getModel():insertRelationDocument( ::uuidDocumentoOrigen, ::getController():getModel():cTableName, ::uuidDocumentoDestino, ::oDestinoController:getModel():cTableName ) )

   METHOD Edit( nId )

   METHOD addConvert()

   METHOD convertDocument( aConvert )

   //Construcciones tardias----------------------------------------------------

   METHOD setAlbaranesComprasController() ;
                                       INLINE ( ::oDestinoController := AlbaranesComprasController():New( self ), ::oDestinoController ) 

   METHOD setAlbaranesVentasController() ;
                                       INLINE ( ::oDestinoController := AlbaranesVentasController():New( self ), ::oDestinoController ) 

   METHOD setFacturasComprasControllerAsDestino() ;
                                       INLINE ( ::oDestinoController := FacturasComprasController():New( self ), ::oDestinoController ) 

   METHOD setFacturasVentasController() ;
                                       INLINE ( ::oDestinoController := FacturasVentasController():New( self ), ::oDestinoController ) 

   METHOD setFacturasVentasSimplificadasController() ;
                                       INLINE ( ::oDestinoController := FacturasVentasSimplificadasController():New( self ), ::oDestinoController ) 

   METHOD setPedidosComprasController() ;
                                       INLINE ( ::oDestinoController := PedidosComprasController():New( self ), ::oDestinoController ) 

   METHOD setPedidosVentasController() ;
                                       INLINE ( ::oDestinoController := PedidosVentasController():New( self ), ::oDestinoController ) 

   METHOD setPresupuestosVentasController() ;
                                       INLINE ( ::oDestinoController := PresupuestosVentasController():New( self ), ::oDestinoController ) 
   
   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLConversorDocumentosModel():New( self ), ), ::oModel ) 

   METHOD getConvertirView()           INLINE ( if( empty( ::oConvertirView ), ::oConvertirView := ConversorDocumentoView():New( self ), ), ::oConvertirView )

   METHOD getResumenView()             INLINE ( if( empty( ::oResumenView ), ::oResumenView := ConversorResumenView():New( self ), ), ::oResumenView )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := ::oController:getFacturasComprasController():getDialogView(), ::oDialogView ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ConversorDocumentosController 

   ::aDocumentosDestino := {  "Albarán de compras"             => {|| ::setAlbaranesComprasController() },;
                              "Albarán de ventas"              => {|| ::setAlbaranesVentasController() },;
                              "Factura de compras"             => {|| ::setFacturasComprasControllerAsDestino() },;
                              "Factura de ventas"              => {|| ::setFacturasventasController() },;
                              "Factura de ventas simplificada" => {|| ::setFacturasVentasSimplificadasController() },;
                              "Pedido de compras"              => {|| ::setPedidosComprasController() },;
                              "Pedido de ventas"               => {|| ::setPedidosVentasController() },;
                              "Presupuesto de ventas"          => {|| ::setPresupuestosVentasController() } }

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorDocumentosController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oDestinoController )
      ::oDestinoController:End()
   end if 

   if !empty( ::oConvertirView )
      ::oConvertirView:End() 
   end if 

   if !empty( ::oResumenView )
      ::oResumenView:End()
   end if 
   
   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Run() CLASS ConversorDocumentosController

   if ::getConvertirView():Activate() != IDOK
      RETURN ( nil )
   end if 

   if hhaskey( ::aDocumentosDestino, ::getConvertirView():getDocumentoDestino() )
      ::oDestinoController    := eval( hget( ::aDocumentosDestino, ::getConvertirView():getDocumentoDestino() ) )
   end if 

   if !empty( ::oDestinoController )
      ::Convert()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Convert() CLASS ConversorDocumentosController

   if empty( ::getController() )
      RETURN ( nil )
   end if

   if ::getController:className() == ::oDestinoController:className()
      msgstop( "No puede seleccionar el mismo tipo de documento" )
      RETURN ( nil )
   end if

   ::uuidDocumentoOrigen     := ::getController():getRowSet():fieldGet( "uuid" )

   if empty( ::uuidDocumentoOrigen )
      RETURN( nil )
   end if

   ::setHeader()

   ::setLines()

   ::setDiscounts()

   ::oDestinoController:Edit( ::idDocumentoDestino )

RETURN ( nil )   

//---------------------------------------------------------------------------//

METHOD setHeader() CLASS ConversorDocumentosController

   local hNewHeader   := ::getController():getModel():getHashWhere( "uuid", ::uuidDocumentoOrigen )

   aadd( ::aHeader, hNewHeader )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addHeader() CLASS ConversorDocumentosController

   local hHeader  := ::getController():getModel():getHashWhere( "uuid", ::uuidDocumentoOrigen )

   if empty( hHeader )
      RETURN ( nil )
   end if

   aadd( hget( atail( ::aConvert ), "header" ), hHeader )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setLines() CLASS ConversorDocumentosController

   local aLines   := ::getController():getLinesController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aLines )
      RETURN ( nil )
   end if

   aeval( aLines, {|hLine| aadd( ::aLines, hLine ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLines() CLASS ConversorDocumentosController

   local aLines   := ::getController():getLinesController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aLines )
      RETURN ( nil )
   end if

   aeval( aLines, {|hLine| aadd( hget( atail( ::aConvert ), "lines" ), hLine ) } ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setDiscounts() CLASS ConversorDocumentosController

   local aDiscounts  := ::getController():getDiscountController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aDiscounts )
      RETURN ( nil )
   end if

   aeval( aDiscounts, {|hDiscount| aadd( ::aDiscounts, hDiscount ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD runConvertAlbaranCompras( aSelected ) CLASS ConversorDocumentosController
   
   ::aConvert     := {}

   ::aHeader      := {}

   ::aLines       := {}

   ::aDiscounts   := {}

   ::setFacturasComprasControllerAsDestino()

   ::convertAlbaranCompras( aSelected ) 

   ::convertDocument()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertAlbaranCompras( aSelected ) CLASS ConversorDocumentosController

   Local hAlbaran
   local hAlbaranes 

   if empty( ::getController() )
      RETURN ( nil )
   end if

   hAlbaranes                    := SQLAlbaranesComprasModel():getHashWhereUuidAndOrder( ::setWhereArray( aSelected ) )

   for each hAlbaran in hAlbaranes

      if ::isAlbaranNotConverted( hAlbaran ) 

         ::uuidDocumentoOrigen   := hget( hAlbaran, "uuid" )

         if ::isAlbaranEquals( hAlbaran )

            ::addHeader()

            ::addLines()

         else

            ::setHeader()

            ::setLines()

            ::setDiscounts()

            ::addConvert()

         end if

         ::hProcesedAlbaran      := hAlbaran

      end if

   next

RETURN ( ::aCreatedDocument )

//---------------------------------------------------------------------------//

METHOD addConvert() CLASS ConversorDocumentosController

   if empty( ::aHeader )
      RETURN ( nil )
   end if 

   aadd( ::aConvert, { "header" => ::aHeader, "lines" => ::aLines, "discounts" => ::aDiscounts } )

   ::aHeader      := {}

   ::aLines       := {}

   ::aDiscounts   := {}

RETURN ( ::aConvert )

//---------------------------------------------------------------------------//

METHOD isAlbaranEquals( hAlbaran ) CLASS ConversorDocumentosController

   if !( hb_ishash( ::hProcesedAlbaran ) )
      RETURN ( .f. )
   end if 

   if hget( ::hProcesedAlbaran, "tercero_codigo" ) != hget( hAlbaran, "tercero_codigo" )
      RETURN ( .f. )
   end if 

   if hget( ::hProcesedAlbaran, "ruta_codigo" ) != hget( hAlbaran, "ruta_codigo" )
      RETURN ( .f. )
   end if 

   if hget( ::hProcesedAlbaran, "metodo_pago_codigo" ) != hget( hAlbaran ,"metodo_pago_codigo" )
      RETURN ( .f. )
   end if 

   if hget( ::hProcesedAlbaran, "tarifa_codigo" ) != hget( hAlbaran, "tarifa_codigo" )
      RETURN ( .f. )
   end if 

   if hget( ::hProcesedAlbaran, "recargo_equivalencia" ) != hget( hAlbaran, "recargo_equivalencia" )
      RETURN ( .f. )
   end if 

   if hget( ::hProcesedAlbaran, "serie" ) != hget( hAlbaran, "serie" )
      RETURN ( .f. )
   end if 

   if !empty( ::getController():getDiscountController():getModel():countWhere( { "parent_uuid" => hget( hAlbaran, "uuid" ) } ) ) 
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD setWhereArray( aSelected ) CLASS ConversorDocumentosController
   
   local cWhere   := " IN( "

   aeval( aSelected, {| v | cWhere += quotedUuid( v ) + ", " } )

   cWhere         := chgAtEnd( cWhere, ' )', 2 )

RETURN ( cWhere )

//---------------------------------------------------------------------------//

METHOD Edit( nId ) CLASS ConversorDocumentosController

   if empty( nId )
      nId   := ::getIdFromRowSet()
   end if

RETURN ( ::getDestinoController():Edit( nId ) )

//---------------------------------------------------------------------------//

METHOD convertDocument() CLASS ConversorDocumentosController

   ::aCreatedDocument            := ::oDestinoController:convertDocument( ::aConvert )

   if !empty( ::aCreatedDocument )
      ::getResumenView():Activate()
   end if

RETURN ( ::aCreatedDocument )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ConversorDocumentoView FROM SQLBaseView

   DATA cDocumentoDestino

   DATA oComboDocumentoDestino
                                          
   METHOD Activate()
      METHOD Activating()

   METHOD getDocumentoDestino()        INLINE ( alltrim( ::cDocumentoDestino ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ConversorDocumentoView

   DEFINE DIALOG  ::oDialog;
      RESOURCE    "CONVERTIR_DOCUMENTO"; 
      TITLE       "Convertir documento a ..."

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_tags_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Convertir documento" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oComboDocumentoDestino ;
      VAR         ::cDocumentoDestino ;
      ITEMS       ( hgetkeys( ::getController():aDocumentosDestino ) ) ;
      ID          100 ;
      OF          ::oDialog

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::oDialog:end( IDOK ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   ::oDialog:Activate( , , , .t. )

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD Activating() CLASS ConversorDocumentoView

   ::cDocumentoDestino  := ""

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ConversorResumenView FROM SQLBaseView
                                          
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ConversorResumenView

   DEFINE DIALOG  ::oDialog;
      RESOURCE    "RESUMEN_CONVERSION"; 
      TITLE       "Resumen de la conversión ..."

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_tags_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Resumen de la conversión a facturas" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::getController():Activate( 100, ::oDialog )

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )
   
   ::oDialog:bStart     := {|| ::paintedActivate() }

   ::oDialog:Activate( , , , .t. )

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLConversorDocumentosModel FROM SQLCompanyModel

   DATA cTableName               INIT "documentos_conversion"

   //DATA cConstraints             INIT "PRIMARY KEY ( pago_uuid, recibo_uuid )"

   METHOD getColumns()

   METHOD insertRelationDocument( uuidOrigin, cTableOrigin, uuidDestination, cTableDestination )

   METHOD deleteWhereDestinoUuid( Uuid )

   METHOD countDocumentoWhereUuidOigen( uuidOrigen )

   METHOD getInitialSelect()

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

   hset( ::hColumns, "documento_destino_tabla",     {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

   hset( ::hColumns, "documento_destino_uuid",      {  "create"    => "VARCHAR( 40 )"                              ,;
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

   cSql  := hb_strformat(  cSql, ::getTableName(),;
                                 quoted( cTableOrigin ),;
                                 quoted( uuidOrigin ),;
                                 quoted( cTableDestination ),;
                                 quoted( uuidDestination ) )
                                 
RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//

METHOD deleteWhereDestinoUuid( Uuid ) CLASS SQLConversorDocumentosModel

local cSql

   TEXT INTO cSql

   DELETE FROM %1$s
   WHERE documento_destino_uuid= %2$s

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           quoted( Uuid ) )
   
RETURN ( getSQLDatabase():Exec( cSql ) )

//---------------------------------------------------------------------------//

METHOD countDocumentoWhereUuidOigen( uuidOrigen ) CLASS SQLConversorDocumentosModel
 
local cSql

   TEXT INTO cSql

   SELECT COUNT(*)
   
   FROM %1$s

   WHERE documento_origen_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           quoted( uuidOrigen ) )
  
RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLConversorDocumentosModel
  
RETURN ( SQLFacturasComprasModel():getInitialWhereDocumentos(::oController:setWhereArray( ::oController:aCreatedDocument ) ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestConversorDocumentosController FROM TestCase

   DATA oController

   DATA aCategories                    INIT { "all", "conversor_documento" }

   DATA oAlbaranesComprasController

   METHOD getAlbaranesComprasController();
                                       INLINE ( if( empty( ::oAlbaranesComprasController ), ::oAlbaranesComprasController := AlbaranesComprasController():New( self ), ), ::oAlbaranesComprasController )

   METHOD beforeClass() 

   METHOD afterClass()

   METHOD Before() 

   METHOD test_create_distinto_tercero()

   METHOD test_create_distinta_ruta()

   METHOD test_create_distinto_metodo_pago() 

   METHOD test_create_distinta_tarifa()

   METHOD test_create_distinto_recargo()

   METHOD test_create_distinta_serie()

   METHOD test_create_distinto_descuento()

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

/*truncates*/

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

   SQLArticulosTarifasModel():truncateTable()

   SQLAgentesModel():truncateTable()

   SQLTiposIvaModel():truncateTable()
   SQLUbicacionesModel():truncateTable()
   SQLArticulosTarifasModel():truncateTable()
   SQLRutasModel():truncateTable()

   SQLConversorDocumentosModel():truncateTable()

   SQLMetodoPagoModel():test_create_contado() 
   SQLMetodoPagoModel():test_create_reposicion() 

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

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinto_tercero() CLASS TestConversorDocumentosController

   local aSelected      := {}

   local hDatosLineaA   := {}

   local hDatosLineaB   := {}
   
   local hDatosAlbaranA := { "tercero_codigo"           => "0" ,;
                             "recargo_equivalencia"     =>  0  ,;
                             "metodo_pago_codigo"       => "0" ,;
                             "almacen_codigo"           => "0" ,;
                             "agente_codigo"            => "0" ,;
                             "ruta_codigo"              => "0" ,;
                             "tarifa_codigo"            => "0" ,;
                             "serie"                    => "A" ,;
                             "numero"                   => 3   }

   local hDatosAlbaranB := { "tercero_codigo"           => "1" ,;
                             "recargo_equivalencia"     =>  0  ,;
                             "metodo_pago_codigo"       => "0" ,;
                             "almacen_codigo"           => "0" ,;
                             "agente_codigo"            => "0" ,;
                             "ruta_codigo"              => "0" ,;
                             "tarifa_codigo"            => "0" ,;
                             "serie"                    => "A" ,;
                             "numero"                   => 4   }

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranA )

   hDatosLineaA   := {  "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 )  ,;
                        "iva"                      => 21                         ,;
                        "articulo_codigo"          => "0"                        ,;
                        "articulo_precio"          => 100                        ,;
                        "descuento"                => 2                          ,;
                        "recargo_equivalencia"     => 5                          ,;
                        "almacen_codigo"           => "0"                        ,;
                        "ubicacion_codigo"         => "0"                        ,;
                        "agente_codigo"            => "0"                        ,;
                        "unidad_medicion_codigo"   => "UDS"                      ,;
                        "articulo_nombre"          => "Articulo con descuentos"  }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )
   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranB )

   hDatosLineaB := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 ) )
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 ) )
   
   ::oController:getResumenView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 3 ),;
         self:getControl( IDCANCEL ):Click() } )
   
   ::oController:runConvertAlbaranCompras( aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "Genera dos facturas con distintos terceros" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinta_ruta() CLASS TestConversorDocumentosController

   local aSelected      := {}

   local hDatosLineaA   := {}

   local hDatosLineaB   := {}
   
   local hDatosAlbaranA := { "tercero_codigo"           => "0" ,;
                             "recargo_equivalencia"     =>  0  ,;
                             "metodo_pago_codigo"       => "0" ,;
                             "almacen_codigo"           => "0" ,;
                             "agente_codigo"            => "0" ,;
                             "ruta_codigo"              => "0" ,;
                             "tarifa_codigo"            => "0" ,;
                             "serie"                    => "A" ,;
                             "numero"                   => 3   }

   local hDatosAlbaranB := { "tercero_codigo"           => "0" ,;
                             "recargo_equivalencia"     =>  0  ,;
                             "metodo_pago_codigo"       => "0" ,;
                             "almacen_codigo"           => "0" ,;
                             "agente_codigo"            => "0" ,;
                             "ruta_codigo"              => "1" ,;
                             "tarifa_codigo"            => "0" ,;
                             "serie"                    => "A" ,;
                             "numero"                   => 4   }

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranA )

   hDatosLineaA := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )
   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranB )

   hDatosLineaB := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 ) )
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 ) )
   
   ::oController:getResumenView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 3 ),;
         self:getControl( IDCANCEL ):Click() } )
   
   ::oController:runConvertAlbaranCompras( aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera dos facturas con distintas rutas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinto_metodo_pago() CLASS TestConversorDocumentosController

   local aSelected      := {}

   local hDatosLineaA   := {}

   local hDatosLineaB   := {}
   
   local hDatosAlbaranA := {  "tercero_codigo"           => "0" ,;
                              "recargo_equivalencia"     =>  0  ,;
                              "metodo_pago_codigo"       => "0" ,;
                              "almacen_codigo"           => "0" ,;
                              "agente_codigo"            => "0" ,;
                              "ruta_codigo"              => "0" ,;
                              "tarifa_codigo"            => "0" ,;
                              "serie"                    => "A" ,;
                              "numero"                   => 3   }

   local hDatosAlbaranB := {  "tercero_codigo"           => "0" ,;
                              "recargo_equivalencia"     =>  0  ,;
                              "metodo_pago_codigo"       => "1" ,;
                              "almacen_codigo"           => "0" ,;
                              "agente_codigo"            => "0" ,;
                              "ruta_codigo"              => "0" ,;
                              "tarifa_codigo"            => "0" ,;
                              "serie"                    => "A" ,;
                              "numero"                   => 4   }

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranA )

   hDatosLineaA := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )
   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranB )

   hDatosLineaB := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 ) )
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 ) )
   
   ::oController:getResumenView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 3 ),;
         self:getControl( IDCANCEL ):Click() } )
   
   ::oController:runConvertAlbaranCompras( aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera facturas con distintos metodos de pago" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinta_tarifa() CLASS TestConversorDocumentosController

   local aSelected      := {}

   local hDatosLineaA   := {}

   local hDatosLineaB   := {}
   
   local hDatosAlbaranA := { "tercero_codigo"           => "0" ,;
                             "recargo_equivalencia"     =>  0  ,;
                             "metodo_pago_codigo"       => "0" ,;
                             "almacen_codigo"           => "0" ,;
                             "agente_codigo"            => "0" ,;
                             "ruta_codigo"              => "0" ,;
                             "tarifa_codigo"            => "0" ,;
                             "serie"                    => "A" ,;
                             "numero"                   => 3   }

   local hDatosAlbaranB := { "tercero_codigo"           => "0" ,;
                             "recargo_equivalencia"     =>  0  ,;
                             "metodo_pago_codigo"       => "0" ,;
                             "almacen_codigo"           => "0" ,;
                             "agente_codigo"            => "0" ,;
                             "ruta_codigo"              => "0" ,;
                             "tarifa_codigo"            => "1" ,;
                             "serie"                    => "A" ,;
                             "numero"                   => 4   }

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranA )

   hDatosLineaA := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )
   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranB )

   hDatosLineaB := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 ) )
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 ) )
   
   ::oController:getResumenView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 3 ),;
         self:getControl( IDCANCEL ):Click() } )
   
   ::oController:runConvertAlbaranCompras( aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "creacion de facturas con dos tarifas diferentes" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinto_recargo() CLASS TestConversorDocumentosController

   local aSelected      := {}

   local hDatosLineaA   := {}

   local hDatosLineaB   := {}
   
   local hDatosAlbaranA := { "tercero_codigo"           => "0" ,;
                             "recargo_equivalencia"     =>  0  ,;
                             "metodo_pago_codigo"       => "0" ,;
                             "almacen_codigo"           => "0" ,;
                             "agente_codigo"            => "0" ,;
                             "ruta_codigo"              => "0" ,;
                             "tarifa_codigo"            => "0" ,;
                             "serie"                    => "A" ,;
                             "numero"                   =>  3   }

   local hDatosAlbaranB := { "tercero_codigo"           => "0" ,;
                             "recargo_equivalencia"     =>  1  ,;
                             "metodo_pago_codigo"       => "0" ,;
                             "almacen_codigo"           => "0" ,;
                             "agente_codigo"            => "0" ,;
                             "ruta_codigo"              => "0" ,;
                             "tarifa_codigo"            => "0" ,;
                             "serie"                    => "A" ,;
                             "numero"                   =>  4   }

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranA )

   hDatosLineaA := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )
      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranB )

   hDatosLineaB := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 ) )
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 ) )
   
   ::oController:getResumenView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 3 ),;
         self:getControl( IDCANCEL ):Click() } )
   
   ::oController:runConvertAlbaranCompras( aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera facturas con distintos recargos de equivalencia" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinta_serie() CLASS TestConversorDocumentosController

   local aSelected      := {}

   local hDatosLineaA   := {}

   local hDatosLineaB   := {}
   
   local hDatosAlbaranA := { "tercero_codigo"           => "0" ,;
                             "recargo_equivalencia"     =>  0  ,;
                             "metodo_pago_codigo"       => "0" ,;
                             "almacen_codigo"           => "0" ,;
                             "agente_codigo"            => "0" ,;
                             "ruta_codigo"              => "0" ,;
                             "tarifa_codigo"            => "0" ,;
                             "serie"                    => "A" ,;
                             "numero"                   =>  3   }

   local hDatosAlbaranB := { "tercero_codigo"           => "0" ,;
                             "recargo_equivalencia"     =>  1  ,;
                             "metodo_pago_codigo"       => "0" ,;
                             "almacen_codigo"           => "0" ,;
                             "agente_codigo"            => "0" ,;
                             "ruta_codigo"              => "0" ,;
                             "tarifa_codigo"            => "0" ,;
                             "serie"                    => "B" ,;
                             "numero"                   =>  4   }

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranA )

   hDatosLineaA := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )
      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranB )

   hDatosLineaB := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "B", 4 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 ) )
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "B", 4 ) )
  
   ::oController:getResumenView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 3 ),;
         self:getControl( IDCANCEL ):Click() } )
   
   ::oController:runConvertAlbaranCompras( aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera factras con distintas series" )

RETURN ( nil )


//---------------------------------------------------------------------------//

METHOD test_create_distinto_descuento() CLASS TestConversorDocumentosController

   local aSelected         := {}

   local hDatosLineaA      := {}

   local hDatosLineaB      := {}

   local hDatosDescuentos  := {}
   
   local hDatosAlbaranA    := { "tercero_codigo"           => "0" ,;
                                "recargo_equivalencia"     =>  0  ,;
                                "metodo_pago_codigo"       => "0" ,;
                                "almacen_codigo"           => "0" ,;
                                "agente_codigo"            => "0" ,;
                                "ruta_codigo"              => "0" ,;
                                "tarifa_codigo"            => "0" ,;
                                "serie"                    => "A" ,;
                                "numero"                   =>  3   }

   local hDatosAlbaranB    := { "tercero_codigo"           => "0" ,;
                                "recargo_equivalencia"     =>  1  ,;
                                "metodo_pago_codigo"       => "0" ,;
                                "almacen_codigo"           => "0" ,;
                                "agente_codigo"            => "0" ,;
                                "ruta_codigo"              => "0" ,;
                                "tarifa_codigo"            => "0" ,;
                                "serie"                    => "A" ,;
                                "numero"                   =>  4   }

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranA )

   hDatosLineaA := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )
   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )

   hDatosDescuentos := { "parent_uuid"           => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 )  ,;
                         "nombre"                => "Descuento 1" ,;
                         "descuento"             => 15            }

   SQLAlbaranesComprasDescuentosModel():test_create_descuento( hDatosDescuentos )

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranB )

   hDatosLineaB := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 ) )
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 ) )
  
   ::oController:getResumenView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 3 ),;
         self:getControl( IDCANCEL ):Click() } )
   
   ::oController:runConvertAlbaranCompras( aSelected )

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "test ::Assert():equals on small integers" )

RETURN ( nil )


//---------------------------------------------------------------------------//

METHOD test_create_iguales_y_distinto() CLASS TestConversorDocumentosController

   local aSelected         := {}

   local hDatosLineaA      := {}

   local hDatosLineaB      := {}

   local hDatosLineaC      := {}
   
   local hDatosAlbaranA    := { "tercero_codigo"           => "0" ,;
                                "recargo_equivalencia"     =>  0  ,;
                                "metodo_pago_codigo"       => "0" ,;
                                "almacen_codigo"           => "0" ,;
                                "agente_codigo"            => "0" ,;
                                "ruta_codigo"              => "0" ,;
                                "tarifa_codigo"            => "0" ,;
                                "serie"                    => "A" ,;
                                "numero"                   =>  3   }

   local hDatosAlbaranB    := { "tercero_codigo"           => "1" ,;
                                "recargo_equivalencia"     =>  1  ,;
                                "metodo_pago_codigo"       => "0" ,;
                                "almacen_codigo"           => "0" ,;
                                "agente_codigo"            => "0" ,;
                                "ruta_codigo"              => "0" ,;
                                "tarifa_codigo"            => "0" ,;
                                "serie"                    => "A" ,;
                                "numero"                   =>  4   }

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranA )

   hDatosLineaA := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )
   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranB )

   hDatosLineaB := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 ) )
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 ) )
  
   ::oController:getResumenView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 3 ),;
         self:getControl( IDCANCEL ):Click() } )
   
   ::oController:runConvertAlbaranCompras( aSelected )

    ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "test ::Assert():equals on small integers" )

RETURN ( nil )


//---------------------------------------------------------------------------//

METHOD test_create_iguales() CLASS TestConversorDocumentosController

   local aSelected      := {}

   local hDatosLineaA   := {}

   local hDatosLineaB   := {}
   
   local hDatosAlbaranA := { "tercero_codigo"           => "0" ,;
                             "recargo_equivalencia"     =>  0  ,;
                             "metodo_pago_codigo"       => "0" ,;
                             "almacen_codigo"           => "0" ,;
                             "agente_codigo"            => "0" ,;
                             "ruta_codigo"              => "0" ,;
                             "tarifa_codigo"            => "0" ,;
                             "serie"                    => "A" ,;
                             "numero"                   =>  3   }

   local hDatosAlbaranB := { "tercero_codigo"           => "0" ,;
                             "recargo_equivalencia"     =>  0  ,;
                             "metodo_pago_codigo"       => "0" ,;
                             "almacen_codigo"           => "0" ,;
                             "agente_codigo"            => "0" ,;
                             "ruta_codigo"              => "0" ,;
                             "tarifa_codigo"            => "0" ,;
                             "serie"                    => "A" ,;
                             "numero"                   =>  4   }

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranA )

   hDatosLineaA := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )
      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaA )

   SQLAlbaranesComprasModel():create_albaran_compras( hDatosAlbaranB )

   hDatosLineaB := { "parent_uuid"              => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 )  ,;
                     "iva"                      => 21                         ,;
                     "articulo_codigo"          => "0"                        ,;
                     "articulo_precio"          => 100                        ,;
                     "descuento"                => 2                          ,;
                     "recargo_equivalencia"     => 5                          ,;
                     "almacen_codigo"           => "0"                        ,;
                     "ubicacion_codigo"         => "0"                        ,;
                     "agente_codigo"            => "0"                        ,;
                     "unidad_medicion_codigo"   => "UDS"                      ,;
                     "articulo_nombre"          => "Articulo con descuentos"  }

      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
      SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hDatosLineaB )
   
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 ) )
   aadd( aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 ) )
   
   ::oController:getResumenView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 3 ),;
         self:getControl( IDCANCEL ):Click() } )
   
   ::oController:runConvertAlbaranCompras( aSelected )

   ::Assert():equals( 1, SQLFacturasComprasModel():countFacturas(), "test ::Assert():equals on small integers" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

