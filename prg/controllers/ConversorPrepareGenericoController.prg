#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS ConversorPrepareGenericoController FROM ConversorPrepareController

   DATA uuidOrigen
   
   METHOD New()

   METHOD Run()

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD setDocumentosDestino()

   METHOD setAlbaranesComprasController() ;
                                       INLINE ( ::oDestinoController := AlbaranesComprasController():New( self ), ::oDestinoController )

   METHOD setAlbaranesVentasController() ;
                                       INLINE ( ::oDestinoController := AlbaranesVentasController():New( self ), ::oDestinoController )

   METHOD setFacturasComprasController() ;
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

   METHOD getConversorView()           INLINE ( if( empty( ::oConversorView ), ::oConversorView := ConversorDocumentoView():New( self ), ), ::oConversorView )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oOrigenController ) CLASS ConversorPrepareGenericoController

   ::oOrigenController              := oOrigenController

   ::oConversorDocumentosController := ConversorDocumentosController():New( self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorPrepareGenericoController

   if !empty( ::oDestinoController )
      ::oDestinoController:End()
   end if

   if !empty(::oConversorView )
      ::oConversorView:End()
   end if

   if !empty( ::oConversorDocumentosController )
      ::oConversorDocumentosController:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD setDocumentosDestino() CLASS ConversorPrepareGenericoController

   ::aDocumentosDestino := {  "Albarán de compras"             => {|| ::setAlbaranesComprasController() },;
                              "Albarán de ventas"              => {|| ::setAlbaranesVentasController() },;
                              "Factura de compras"             => {|| ::setFacturasComprasController() },;
                              "Factura de ventas"              => {|| ::setFacturasventasController() },;
                              "Factura de ventas simplificada" => {|| ::setFacturasVentasSimplificadasController() },;
                              "Pedido de compras"              => {|| ::setPedidosComprasController() },;
                              "Pedido de ventas"               => {|| ::setPedidosVentasController() },;
                              "Presupuesto de ventas"          => {|| ::setPresupuestosVentasController() } }

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Run( uuidOrigen ) CLASS ConversorPrepareGenericoController

   ::setDocumentosDestino()

   ::uuidOrigen := uuidOrigen

   if ::getConversorView():Activate() != IDOK
      RETURN ( nil )
   end if

   if hhaskey( ::aDocumentosDestino, ::getConversorView():getDocumentoDestino() )
      ::oDestinoController    := eval( hget( ::aDocumentosDestino, ::getConversorView():getDocumentoDestino() ) )
   end if

   if !empty( ::oDestinoController )

      ::oConversorDocumentosController():convert( ::uuidOrigen )

      ::getHistoryController():getModel():insertConvertHistory( ::uuidOrigen, ::getConversorView():cDocumentoDestino )

   end if

RETURN ( nil )

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

   METHOD validDialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ConversorDocumentoView

   DEFINE DIALOG  ::oDialog;
      RESOURCE    "CONVERTIR_DOCUMENTO";
      TITLE       "Convertir documento a ..."

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_convertir_documento_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Convertir documento" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oComboDocumentoDestino ;
      VAR         ::cDocumentoDestino ;
      ITEMS       ( hgetkeys( ::oController:aDocumentosDestino ) ) ;
      ID          100 ;
      OF          ::oDialog

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::validDialog() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }

   ::oDialog:bStart     := {|| ::paintedActivate() }

   ::oDialog:Activate( , , , .t. )

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD Activating() CLASS ConversorDocumentoView

   ::cDocumentoDestino  := ""

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validDialog() CLASS ConversorDocumentoView

   local oDestinoController

   if empty( ::getDocumentoDestino )
      ::showMessage("Debe seleccionar un documento de destino")
      RETURN( nil )
   end if

   oDestinoController := eval( hget( ::oController:aDocumentosDestino(), ::getDocumentoDestino ) )

   if ::oController:oOrigenController:className() == oDestinoController:className()
      ::showMessage( "No puede seleccionar el mismo documento de destino" )
      RETURN ( nil )
   end if

   if SQLConversorDocumentosModel():countDocumentoWhereUuidOigenAndTableDestino( ::oController:UuidOrigen, oDestinoController:getModel():cTableName ) > 0
      ::showMessage( "El documento seleccionado ya ha sido convertido" )
      RETURN ( nil )
   end if

RETURN( ::oDialog:end( IDOK ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestConversorGenericoController FROM TestCase

   DATA oController

   DATA aCategories                    INIT { "all", "conversor_documento_generico" }

   DATA oPedidosComprasController

   METHOD getPedidosComprasController();
                                       INLINE ( if( empty( ::oPedidosComprasController ), ::oPedidosComprasController := PedidosComprasController():New( self ), ), ::oPedidosComprasController )

   METHOD beforeClass() 

   METHOD afterClass()

   METHOD Before() 

   METHOD test_convert_generico_sin_destino()

   METHOD test_convert_generico_igual_destino()

   METHOD test_convert_generico_ya_convertido()

   METHOD test_convert_generico()

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestConversorGenericoController

   ::oController  := ConversorPrepareGenericoController():New( ::getPedidosComprasController() )  

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestConversorGenericoController

   ::oController:End()

   if !empty( ::oPedidosComprasController )
      ::oPedidosComprasController:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestConversorGenericoController

   SQLTercerosModel():truncateTable()

   SQLDireccionesModel():truncateTable()

   SQLAlmacenesModel():truncateTable()
      SQLUbicacionesModel():truncateTable()

   SQLMetodoPagoModel():truncateTable()

   SQLArticulosModel():truncateTable()
   
   SQLPedidosComprasModel():truncateTable()
      SQLPedidosComprasLineasModel():truncateTable()
      SQLPedidosComprasDescuentosModel():truncateTable()

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

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_convert_generico_sin_destino() CLASS TestConversorGenericoController

   local hLinea

   SQLPedidosComprasModel():create_pedido_compras()

   hLinea               := { "parent_uuid"   => SQLPedidosComprasModel():test_get_uuid_pedido_compras( "A", 3 ) }

   SQLPedidosComprasLineasModel():create_linea_pedido_compras( hLinea )
   
   ::oController:getConversorView():setEvent( 'painted',;
         {| self | ;
            testWaitSeconds( 2 ),;
            self:getControl( IDOK ):Click(),;
            testWaitSeconds( 2 ),;
            self:getControl( IDCANCEL ):Click() } )

   ::oController:Run( SQLPedidosComprasModel():test_get_uuid_pedido_compras( "A", 3 ) ) 

   ::Assert():equals( 0, SQLConversorDocumentosModel():countDocumentos(), "No realiza ninguna conversion" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_convert_generico_igual_destino() CLASS TestConversorGenericoController

   local hLinea

   SQLPedidosComprasModel():create_pedido_compras()

   hLinea               := { "parent_uuid"   => SQLPedidosComprasModel():test_get_uuid_pedido_compras( "A", 3 ) }

   SQLPedidosComprasLineasModel():create_linea_pedido_compras( hLinea )

   ::oController:getConversorView():setEvent( 'painted',;
         {| self | ;
            self:getControl( 100 ):VarPut( "Pedido de compras" ) ,;
            testWaitSeconds( 1 ),;
            self:getControl( IDOK ):Click(),;
            testWaitSeconds( 1 ),;
            self:getControl( IDCANCEL ):Click() } )

   ::oController():Run( SQLPedidosComprasModel():test_get_uuid_pedido_compras( "A", 3 ) ) 

   ::Assert():equals( 0, SQLConversorDocumentosModel():countDocumentos(), "No realiza ninguna conversion" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_convert_generico_ya_convertido() CLASS TestConversorGenericoController

   local hLinea

   local UuidOrigen

   SQLPedidosComprasModel():create_pedido_compras()

   uuidOrigen := SQLPedidosComprasModel():test_get_uuid_pedido_compras( "A", 3 )

   hLinea               := { "parent_uuid"   => uuidOrigen }

   SQLPedidosComprasLineasModel():create_linea_pedido_compras( hLinea )

   SQLConversorDocumentosModel():insertRelationDocument( uuidOrigen, "pedidos_compras", "b940734f-9974-4f1a-bb17-88f615756529", "albaranes_compras")

   ::oController:getConversorView():setEvent( 'painted',;
         {| self | ;
            self:getControl( 100 ):VarPut( "Albarán de compras" ) ,;
            testWaitSeconds( 1 ),;
            self:getControl( IDOK ):Click(),;
            testWaitSeconds( 1 ),;
            self:getControl( IDCANCEL ):Click() } )

   ::oController:Run( SQLPedidosComprasModel():test_get_uuid_pedido_compras( "A", 3 ) )

   ::Assert():equals( 1, SQLConversorDocumentosModel():countDocumentos(), "No realiza ninguna conversion" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_convert_generico() CLASS TestConversorGenericoController

 local hLinea

   SQLPedidosComprasModel():create_pedido_compras()

   hLinea               := { "parent_uuid"   => SQLPedidosComprasModel():test_get_uuid_pedido_compras( "A", 3 ) }

   SQLPedidosComprasLineasModel():create_linea_pedido_compras( hLinea )

   ::oController:getConversorView():setEvent( 'painted',;
         {| self | ;
            self:getControl( 100 ):VarPut( "Factura de ventas simplificada" ) ,;
            testWaitSeconds( 1 ),;
            self:getControl( IDOK ):Click() } )

   ::oController():Run( SQLPedidosComprasModel():test_get_uuid_pedido_compras( "A", 3 ) ) 

   ::Assert():equals( 2, SQLConversorDocumentosModel():countDocumentos(), "Convierte cabecera y linea" )

RETURN ( nil )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


