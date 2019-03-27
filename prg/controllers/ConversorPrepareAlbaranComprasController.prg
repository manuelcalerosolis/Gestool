#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS ConversorPrepareAlbaranComprasController FROM ConversorPrepareController

   DATA aCreatedDocument               INIT {}

   DATA oConversorAlbaranesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()             

   //METHOD convertDocument()

   METHOD showResume()

   //Construcciones tardias----------------------------------------------------

   METHOD getConversorView()              INLINE ( if( empty( ::oConversorView ), ::oConversorView := ConversorResumenView():New( self ), ), ::oConversorView )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oOrigenController , oDestinoController, aSelected ) CLASS ConversorPrepareAlbaranComprasController

   ::Super:New( oOrigenController )

   ::oDestinoController             := oDestinoController

   ::aSelected                      := aSelected

   ::oConversorAlbaranesController := ConversorAlbaranesController():New( self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorPrepareAlbaranComprasController

   if !empty( ::oConversorAlbaranesController )
      ::oConversorAlbaranesController:End()
   end if

   if !empty( ::oConversorView )
      ::oConversorView:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD Run() CLASS ConversorPrepareAlbaranComprasController

   ::aCreatedDocument := ::oConversorAlbaranesController():Convert( ::aSelected )

   ::showResume()

RETURN ( nil )

//---------------------------------------------------------------------------//

/*METHOD convertDocument() CLASS ConversorPrepareAlbaranComprasController

   ::aCreatedDocument := ::oConversorAlbaranesController():convertDocument()

   ::showResume()

RETURN ( nil )*/

//---------------------------------------------------------------------------//

METHOD showResume() CLASS ConversorPrepareAlbaranComprasController

   if !empty( ::aCreatedDocument )
      ::getConversorView:Activate()
   end if

   ::aCreatedDocument := {}

RETURN ( nil )

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
      RESOURCE    "gc_document_gear_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Resumen de la conversión a facturas" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::oController:getFacturasComprasController():Activate( 100, ::oDialog )

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
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestConversorToFacturaComprasController FROM TestCase

   DATA aSelected                      INIT {}

   DATA oController

   DATA aCategories                    INIT { "all", "conversor_to_factura_compras" }

   DATA oAlbaranesComprasController

   data oFacturasComprasController

   METHOD getAlbaranesComprasController();
                                       INLINE ( if( empty( ::oAlbaranesComprasController ), ::oAlbaranesComprasController := AlbaranesComprasController():New( self ), ), ::oAlbaranesComprasController )
   METHOD getFacturasComprasController();
                                       INLINE ( if( empty( ::oFacturasComprasController ), ::oFacturasComprasController := FacturasComprasController():New( self ), ), ::oFacturasComprasController )

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

METHOD beforeClass() CLASS TestConversorToFacturaComprasController 

   //::oController  := ConversorPrepareAlbaranComprasController():New( ::getAlbaranesComprasController() , ::getFacturasComprasController() )  

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestConversorToFacturaComprasController

   ::oController:End()

   if !empty( ::oAlbaranesComprasController )
      ::oAlbaranesComprasController:End()
   end if

   if !empty( ::oFacturasComprasController )
      ::oFacturasComprasController:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestConversorToFacturaComprasController

   getSQLDataBase():quitForeingKeyChecks()

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

   SQLRutasModel():truncateTable()

   SQLConversorDocumentosModel():truncateTable()

   getSQLDataBase():setForeingKeyChecks()

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

   ::aSelected                      := {}

   //::oController:hProcesedAlbaran   := {}

   //::oController:lDescuento         := .f.

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD create_albaran( hAlbaran ) CLASS TestConversorToFacturaComprasController

   local hLinea         := {}

   SQLAlbaranesComprasModel():create_albaran_compras( hAlbaran )

   hLinea               := { "parent_uuid"   => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( hget( hAlbaran,"serie" ), hget( hAlbaran, "numero" ) ) }

   SQLAlbaranesComprasLineasModel():create_linea_albaran_compras( hLinea )
  
   aadd( ::aSelected, SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( hget( hAlbaran, "serie" ), hget( hAlbaran, "numero" ) ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD close_resumen_view() CLASS TestConversorToFacturaComprasController

   ::oController:getConversorView():setEvent( 'painted',;
         {| self | ;
            testWaitSeconds(),;
            self:getControl( IDCANCEL ):Click() } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinto_tercero() CLASS TestConversorToFacturaComprasController
  

   ::create_albaran( {  "serie"  => "A",;
                        "numero" =>  3 } )

   ::create_albaran( {  "tercero_codigo"  => "1" ,;
                        "numero"          =>  4,;
                        "serie"           => "A"  } )

   ::oController  := ConversorPrepareAlbaranComprasController():New( ::getAlbaranesComprasController() , ::getFacturasComprasController(), ::aSelected )  
   
   ::close_resumen_view()
   
   ::oController:Run()

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "Genera dos facturas con distintos terceros" )
   //::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con distintos terceros" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinta_ruta() CLASS TestConversorToFacturaComprasController

   ::create_albaran( {  "serie"        => "A",;
                        "numero"       =>  3 } )

   ::create_albaran( {  "ruta_codigo"  => "1" ,;
                        "numero"       =>  4  ,;
                        "serie"        => "A" } )

   ::oController  := ConversorPrepareAlbaranComprasController():New( ::getAlbaranesComprasController() , ::getFacturasComprasController(), ::aSelected )  
   
   ::close_resumen_view()
   
   ::oController:Run()

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera dos facturas con distintas rutas" )
   //::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con distintas rutas" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinto_metodo_pago() CLASS TestConversorToFacturaComprasController

   ::create_albaran( {  "serie"                 => "A",;
                        "numero"                =>  3 } )

   ::create_albaran( {  "metodo_pago_codigo"    => "1" ,;
                        "numero"                =>  4  ,;
                        "serie"                 => "A" } )

   ::oController  := ConversorPrepareAlbaranComprasController():New( ::getAlbaranesComprasController() , ::getFacturasComprasController(), ::aSelected )  
   
   ::close_resumen_view()
   
   ::oController:Run()

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera facturas con distintos metodos de pago" )
   //::Assert():equals( 8, SQLRecibosModel():countRecibos(), "Genera 8 recibos a traves de 2 albaranes con distintos metodos de pago" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinta_tarifa() CLASS TestConversorToFacturaComprasController

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  3 } )

   ::create_albaran( {  "tarifa_codigo"   => "1" ,;
                        "numero"          =>  4  ,;
                        "serie"           => "A" } )

   ::oController  := ConversorPrepareAlbaranComprasController():New( ::getAlbaranesComprasController() , ::getFacturasComprasController(), ::aSelected )  
   
   ::close_resumen_view()

   ::oController:Run()

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "creacion de facturas con dos tarifas diferentes" )
   //::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con dos tarifas diferentes" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinto_recargo() CLASS TestConversorToFacturaComprasController

   ::create_albaran( {  "serie"                    => "A",;
                        "numero"                   =>  3 } )

   ::create_albaran( {  "recargo_equivalencia"     =>  1  ,;
                        "numero"                   =>  4  ,;
                        "serie"                    => "A" } )

   ::oController  := ConversorPrepareAlbaranComprasController():New( ::getAlbaranesComprasController() , ::getFacturasComprasController(), ::aSelected )  

   ::close_resumen_view()
   
   ::oController:Run()

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera facturas con distintos recargos de equivalencia" )
   //::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con distintos recargos de equivalencia" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_distinta_serie() CLASS TestConversorToFacturaComprasController

   ::create_albaran( {  "serie"     => "A",;
                        "numero"    =>  3 } )

   ::create_albaran( {   "serie"    => "B",;
                         "numero"   =>  5 } )

   ::oController  := ConversorPrepareAlbaranComprasController():New( ::getAlbaranesComprasController() , ::getFacturasComprasController(), ::aSelected )  

   ::close_resumen_view()
  
   ::oController:Run()

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera factras con distintas series" )
   //::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con distintas series" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_con_a_descuento() CLASS TestConversorToFacturaComprasController

   ::create_albaran( {  "serie"        => "A",;
                        "numero"       =>  3 } )

   SQLAlbaranesComprasDescuentosModel():test_create_descuento( { "parent_uuid" => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 3 ) } )

   ::create_albaran( {  "numero"       =>  4 ,;
                        "serie"        => "A" } )

   ::oController  := ConversorPrepareAlbaranComprasController():New( ::getAlbaranesComprasController() , ::getFacturasComprasController(), ::aSelected )  

   ::close_resumen_view()
  
   ::oController:Run()

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera 2 facturas con descuento en el primero" )
   //::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con descuento en el primero" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_con_b_descuento() CLASS TestConversorToFacturaComprasController

   ::create_albaran( {  "serie"        => "A",;
                        "numero"       =>  3 } )


   ::create_albaran( {  "numero"       =>  4 ,;
                        "serie"        => "A" } )

   SQLAlbaranesComprasDescuentosModel():test_create_descuento( { "parent_uuid" => SQLAlbaranesComprasModel():test_get_uuid_albaran_compras( "A", 4 ) } )

   ::oController  := ConversorPrepareAlbaranComprasController():New( ::getAlbaranesComprasController() , ::getFacturasComprasController(), ::aSelected )  

   ::close_resumen_view()
  
   ::oController:Run()

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera 2 facturas con descuentos en el segundo" )
   //::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 2 albaranes con descuento en el segundo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_iguales_y_distinto() CLASS TestConversorToFacturaComprasController

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  3 } )

   ::create_albaran( {  "tercero_codigo"  => "1" ,;
                        "numero"          =>  4  ,;
                        "serie"           => "A" } )

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  5 } )

   ::oController  := ConversorPrepareAlbaranComprasController():New( ::getAlbaranesComprasController() , ::getFacturasComprasController(), ::aSelected )  

   ::close_resumen_view()
   
   ::oController:Run()

   ::Assert():equals( 2, SQLFacturasComprasModel():countFacturas(), "genera 2 facturas a traves de 3 albaranes" )
   //::Assert():equals( 6, SQLRecibosModel():countRecibos(), "Genera 6 recibos a traves de 3 albaranes" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_iguales() CLASS TestConversorToFacturaComprasController

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  3 } )

   ::create_albaran( {  "serie"           => "A",;
                        "numero"          =>  4 } )

   ::oController  := ConversorPrepareAlbaranComprasController():New( ::getAlbaranesComprasController() , ::getFacturasComprasController(), ::aSelected )  

   ::close_resumen_view()
   
   ::oController:Run()

   ::Assert():equals( 1, SQLFacturasComprasModel():countFacturas(), "genera 1 factura a traves de 2 albaranes iguales" )
   //::Assert():equals( 3, SQLRecibosModel():countRecibos(), "Genera 3 recibos a traves de 2 albaranes iguales" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

