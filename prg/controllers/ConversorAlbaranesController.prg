#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConversorAlbaranesController FROM ConversorGenericoController

   DATA aCreatedDocument               INIT {}

   DATA aConvert                       INIT {}

   DATA aHeader                        INIT {}

   DATA aLines                         INIT {}

   DATA aDiscounts                     INIT {}

   DATA hProcesedAlbaran               INIT {}

   DATA lDescuento                     INIT .f.

   METHOD getDestinoController()       INLINE ( ::oController:oDestinoController )

   METHOD getOrigenController()        INLINE ( ::oController:oOrigenController )

   METHOD getSelected()                INLINE ( ::oController:aSelected )

   METHOD Convert( aSelected ) 
      
      METHOD initConvert()

      METHOD setHeader()
      METHOD addHeader()
      METHOD setLines()
      METHOD addLines()
      METHOD setDiscounts()
      
      METHOD convertAlbaran( aSelected )

   Method isAlbaranEquals( hAlbaran )

   METHOD setWhereArray( aSelected )

   METHOD isAlbaranNotConverted( hAlbaran ) ;
                                       INLINE ( ::getModel():countDocumentoWhereUuidOigen( hget( hAlbaran, "uuid" ) ) == 0 )

   //METHOD insertRelationDocument()     INLINE ( ::getModel():insertRelationDocument( , ::getOrigenController():getModel():cTableName, ::uuidDocumentoDestino, ::getDestinoController():getModel():cTableName ) )

   METHOD addConvert()

   METHOD Edit( nId )

   METHOD convertDocument()

   METHOD insertHeader( aHeaders )
      METHOD generateHeader( hHeader )
      METHOD insertHeaderRelation( hHeader )

   METHOD insertLines( aLines, uuidDocumentoDestino )
      METHOD generateLine( hLine, uuidDocumentoDestino )
      METHOD insertLineRelation( hLine, uuidDestino )

   METHOD generateDiscount( hDiscount, uuidDocumentoDestino )
      METHOD insertDiscounts( hDiscounts, uuidDocumentoDestino )
      METHOD insertDiscountRelation( hDiscounts, uuidDestino )

END CLASS

//---------------------------------------------------------------------------//

METHOD setHeader() CLASS ConversorAlbaranesController 

   local hNewHeader   := ::getOrigenController:getModel():getHashWhere( "uuid", ::uuidDocumentoOrigen )

   aadd( ::aHeader, hNewHeader )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addHeader() CLASS ConversorAlbaranesController

   local hHeader  := ::getOrigenController():getModel():getHashWhere( "uuid", ::uuidDocumentoOrigen )

   if empty( hHeader )
      RETURN ( nil )
   end if

   aadd( hget( atail( ::aConvert ), "header" ), hHeader )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setLines() CLASS ConversorAlbaranesController

   local aLines   := ::getOrigenController():getLinesController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aLines )
      RETURN ( nil )
   end if

   aeval( aLines, {|hLine| aadd( ::aLines, hLine ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLines() CLASS ConversorAlbaranesController

   local aLines   := ::getOrigenController():getLinesController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aLines )
      RETURN ( nil )
   end if

   aeval( aLines, {|hLine| aadd( hget( atail( ::aConvert ), "lines" ), hLine ) } ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setDiscounts() CLASS ConversorAlbaranesController

   local aDiscounts  := ::getOrigenController():getDiscountController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aDiscounts )
      RETURN ( nil )
   end if

   aeval( aDiscounts, {|hDiscount| aadd( ::aDiscounts, hDiscount ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Convert( aSelected ) CLASS ConversorAlbaranesController
   
   ::initConvert()

   ::convertAlbaran( aSelected )

   ::convertDocument()

RETURN ( ::aCreatedDocument )

//---------------------------------------------------------------------------//

METHOD initConvert() CLASS ConversorAlbaranesController

   ::aConvert           := {}

   ::aHeader            := {}

   ::aLines             := {}

   ::aDiscounts         := {}

   ::aCreatedDocument   := {}

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertAlbaran( aSelected ) CLASS ConversorAlbaranesController

   Local hAlbaran
   local hAlbaranes 

   if empty( ::oController ) 
      RETURN ( nil )
   end if
   
   hAlbaranes                    := ::getOrigenController():getModel():getHashWhereUuidAndOrder( ::setWhereArray( aSelected ) )

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

         if (::getOrigenController():getDiscountController():getModel():countWhere( { "parent_uuid" => hget( hAlbaran, "uuid" ) } ) ) > 0
            ::lDescuento         := .t.
         else 
            ::lDescuento         := .f.
         end if

      end if

   next
 
RETURN ( ::aConvert )

//---------------------------------------------------------------------------//

METHOD convertDocument() CLASS ConversorAlbaranesController

   Local hConvert
   local uuidDocumentoDestino

   for each hConvert in ::aConvert

      uuidDocumentoDestino       := ::insertHeader( hget( hConvert, "header" ) )

      if !empty( uuidDocumentoDestino )

         ::insertLines( hget( hConvert, "lines" ), uuidDocumentoDestino )

         ::insertDiscounts( hget( hConvert, "discounts" ), uuidDocumentoDestino ) 

         // ::getDestinoController():getRecibosGeneratorController():GenerateNegative( uuidDocumentoDestino )

      end if 

   next

   ::hProcesedAlbaran   := {}

RETURN ( ::aCreatedDocument )

//---------------------------------------------------------------------------//

METHOD addConvert() CLASS ConversorAlbaranesController

   if empty( ::aHeader )
      RETURN ( nil )
   end if 

   aadd( ::aConvert, { "header" => ::aHeader, "lines" => ::aLines, "discounts" => ::aDiscounts } )

   ::aHeader      := {}

   ::aLines       := {}

   ::aDiscounts   := {}

RETURN ( ::aConvert )

//---------------------------------------------------------------------------//

METHOD isAlbaranEquals( hAlbaran ) CLASS ConversorAlbaranesController

   if ::lDescuento
      RETURN ( .f. )
   end if

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
  
   if !empty( ::getOrigenController():getDiscountController():getModel():countWhere( { "parent_uuid" => hget( hAlbaran, "uuid" ) } ) ) 
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD setWhereArray( aSelected ) CLASS ConversorAlbaranesController
   
   local cWhere
   
   if empty( aSelected )
      RETURN ( '' )
   end if 
   
   cWhere         := " IN( "

   aeval( aSelected, {| v | cWhere += notEscapedQuoted( v ) + ", " } )

   cWhere         := chgAtEnd( cWhere, ' )', 2 )

RETURN ( cWhere )

//---------------------------------------------------------------------------//

METHOD Edit( nId ) CLASS ConversorAlbaranesController

   if empty( nId )
      nId   := ::getIdFromRowSet()
   end if

RETURN ( ::getDestinoController():Edit( nId ) )

//---------------------------------------------------------------------------//

METHOD insertHeader( aHeaders ) CLASS ConversorAlbaranesController

   local hHeader

   ::uuidDocumentoDestino  := ::generateHeader( hClone( aFirst( aHeaders ) ) )

   if empty( ::uuidDocumentoDestino )
      RETURN ( nil )
   end if 

   aadd( ::aCreatedDocument, ::uuidDocumentoDestino )
      
   for each hHeader in aHeaders
      ::insertHeaderRelation( hHeader )
   next

RETURN ( ::uuidDocumentoDestino )

//---------------------------------------------------------------------------//

METHOD generateHeader( hHeader ) CLASS ConversorAlbaranesController

   hDels( hHeader, { "uuid", "id", "numero" } )

   if empty( ::getDestinoController():getModel():insertBlankBuffer( hHeader ) )
      RETURN ( nil )
   end if 

RETURN ( ::getDestinoController():getModelBuffer( "uuid" ) )

//---------------------------------------------------------------------------//

METHOD insertHeaderRelation( hHeader ) CLASS ConversorAlbaranesController

RETURN ( SQLConversorDocumentosModel():insertRelationDocument( hget( hHeader, "uuid" ), ::getOrigenController():getModel():cTableName, ::uuidDocumentoDestino, ::getDestinoController():getModel():cTableName ) )

//---------------------------------------------------------------------------//

METHOD generateLine( hLine, uuidDocumentoDestino ) CLASS ConversorAlbaranesController

   hDels( hLine, { "uuid", "id" } )

   hSet( hLine, "parent_uuid", uuidDocumentoDestino )

   if empty( ::getDestinoController():getLinesController():getModel():insertBlankBuffer( hLine ) )
      RETURN ( nil )
   end if 

RETURN ( ::getDestinoController():getLinesController():getModelBuffer( "uuid" ) )

//---------------------------------------------------------------------------//

METHOD insertLines( aLines, uuidDocumentoDestino ) CLASS ConversorAlbaranesController

   local hLine
   local uuidDestino

   for each hLine in aLines

      uuidDestino    := ::generateLine( hClone( hLine ), uuidDocumentoDestino )

      if !empty( uuidDestino )
         ::insertLineRelation( hLine, uuidDestino )
      end if 

   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertLineRelation( hLine, uuidDestino ) CLASS ConversorAlbaranesController

RETURN ( SQLConversorDocumentosModel():insertRelationDocument( hget( hline, "uuid" ), ::getOrigenController():getLinesController():getModel():cTableName, uuidDestino, ::getDestinoController():getLinesController():getModel():cTableName ) )

//---------------------------------------------------------------------------//

METHOD insertDiscounts( hDiscounts, uuidDocumentoDestino ) CLASS ConversorAlbaranesController

   local hDiscount
   local uuidDestino

   for each hDiscount in hDiscounts

      uuidDestino  := ::generateDiscount( hClone( hDiscount ), uuidDocumentoDestino  )

      if !empty( uuidDestino )
         ::insertDiscountRelation( hDiscount, uuidDestino )
      end if 

   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD generateDiscount( hDiscount, uuidDocumentoDestino ) CLASS ConversorAlbaranesController
   
   hDels( hDiscount, { "uuid", "id" } )

   hSet( hDiscount, "parent_uuid", uuidDocumentoDestino )

   if empty( ::getDestinoController():getDiscountController():getModel():insertBlankBuffer( hDiscount ) )
      RETURN ( nil )
   end if 
 
RETURN ( ::getDestinoController():getDiscountController():getModelBuffer( "uuid" ) )

//---------------------------------------------------------------------------//

METHOD insertDiscountRelation( hDiscount, uuidDestino ) CLASS ConversorAlbaranesController

RETURN ( SQLConversorDocumentosModel():insertRelationDocument( hget( hDiscount, "uuid" ), ::getOrigenController():getDiscountController():getModel():cTableName, uuidDestino, ::getDestinoController:getDiscountController:getModel():cTableName ) ) 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
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

