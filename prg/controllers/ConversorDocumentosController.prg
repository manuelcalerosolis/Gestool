#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConversorDocumentosController 

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

   DATA hProcesedAlbaran               INIT {}

   DATA lDescuento                     INIT .f.

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getDestinoController()       INLINE ( ::oController:oDestinoController )

   METHOD getOrigenController()        INLINE ( ::oController:oOrigenController )

   METHOD getSelected()                INLINE ( ::oController:aSelected )

   METHOD Convert()
      METHOD setHeader()
      METHOD addHeader()
      METHOD setLines()
      METHOD addLines()
      METHOD setDiscounts()

   METHOD runConvertAlbaran( aSelected ) 
      METHOD convertAlbaran( aSelected )

   Method isAlbaranEquals( hAlbaran )

   METHOD setWhereArray( aSelected )

   METHOD isAlbaranNotConverted( hAlbaran ) ;
                                       INLINE ( ::getModel():countDocumentoWhereUuidOigen( hget( hAlbaran, "uuid" ) ) == 0 )

   METHOD insertRelationDocument()     INLINE ( ::getModel():insertRelationDocument( ::uuidDocumentoOrigen, ::getController():getModel():cTableName, ::uuidDocumentoDestino, ::oDestinoController:getModel():cTableName ) )

   METHOD addConvert()

   METHOD Edit( nId )


   METHOD convertDocument()

   //Contrucciones tarias------------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLConversorDocumentosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ConversorDocumentosController 

   ::oController  := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorDocumentosController

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Convert() CLASS ConversorDocumentosController

   if empty( ::getOrigenController() )
      RETURN ( nil )
   end if

   if ::getOrigenController:className() == ::oDestinoController:className()
      msgstop( "No puede seleccionar el mismo tipo de documento" )
      RETURN ( nil )
   end if

   ::uuidDocumentoOrigen     := ::getOrigenController():getRowSet():fieldGet( "uuid" )

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

   local hNewHeader   := ::getOrigenController:getModel():getHashWhere( "uuid", ::uuidDocumentoOrigen )

   aadd( ::aHeader, hNewHeader )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addHeader() CLASS ConversorDocumentosController

   local hHeader  := ::getOrigenController():getModel():getHashWhere( "uuid", ::uuidDocumentoOrigen )

   if empty( hHeader )
      RETURN ( nil )
   end if

   aadd( hget( atail( ::aConvert ), "header" ), hHeader )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setLines() CLASS ConversorDocumentosController

   local aLines   := ::getOrigenController():getLinesController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aLines )
      RETURN ( nil )
   end if

   aeval( aLines, {|hLine| aadd( ::aLines, hLine ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLines() CLASS ConversorDocumentosController

   local aLines   := ::getOrigenController():getLinesController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aLines )
      RETURN ( nil )
   end if

   aeval( aLines, {|hLine| aadd( hget( atail( ::aConvert ), "lines" ), hLine ) } ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setDiscounts() CLASS ConversorDocumentosController

   local aDiscounts  := ::getOrigenController():getDiscountController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aDiscounts )
      RETURN ( nil )
   end if

   aeval( aDiscounts, {|hDiscount| aadd( ::aDiscounts, hDiscount ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD runConvertAlbaran( aSelected ) CLASS ConversorDocumentosController
   
   ::aConvert     := {}

   ::aHeader      := {}

   ::aLines       := {}

   ::aDiscounts   := {}

   ::convertAlbaran( aSelected ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertAlbaran( aSelected ) CLASS ConversorDocumentosController

   Local hAlbaran
   local hAlbaranes 

   if empty( ::getController() )
      RETURN ( nil )
   end if
   
   hAlbaranes                    := ::getOrigenController:getModel():getHashWhereUuidAndOrder( ::setWhereArray( aSelected ) )

   for each hAlbaran in hAlbaranes


      if ::isAlbaranNotConverted( hAlbaran ) 

         ::uuidDocumentoOrigen   := hget( hAlbaran, "uuid" )

         msgalert( ::uuidDocumentoOrigen)
         
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
            ::lDescuento := .t.
         else 
            ::lDescuento := .f.
         end if

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

   ::aCreatedDocument            := ::getController():oDestinoController:convertDocument( ::aConvert )

RETURN ( ::aCreatedDocument )

//---------------------------------------------------------------------------//
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

CLASS ConvertirAlbaranVentasView FROM SQLBaseView

   DATA oFechaDesde
   DATA dFechaDesde     INIT boy()

   DATA oFechaHasta
   DATA dFechaHasta     INIT date()
                                          
   METHOD insertTemporalAlbaranes( aAlbaranes )

   METHOD Activate()
      METHOD starActivate() 
      METHOD okActivate() 
         METHOD okActivateFolderOne()
         METHOD okActivateFolderTwo()

   METHOD convertAlbaranVentas( aSelecteds )
         
END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ConvertirAlbaranVentasView

   ::getController():getConvertirAlbaranVentasTemporalController():getModel():createTemporalTable()

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_LARGE" ;
      TITLE       ::LblTitle() + "convertir a factura de ventas"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_warning_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Convertir a factura de ventas" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "Rangos" ,;
                  "Vista Previa" ,;
                  "Pestaña 3" ;
      DIALOGS     "CONVERTIR_ALBARAN_VENTAS",;
                  "CONVERTIR_ALBARAN_VENTAS_PREVIA",;
                  "CONVERTIR_ALBARAN_VENTAS"   

   REDEFINE GET   ::oFechaDesde ;
      VAR         ::dFechaDesde ;
      ID          110 ;
      PICTURE     "@D" ;
      SPINNER ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oFechaHasta ;
      VAR         ::dFechaHasta ;
      ID          120 ;
      PICTURE     "@D" ;
      SPINNER ;
      OF          ::oFolder:aDialogs[1]

   ::getController():getConvertirAlbaranVentasTemporalController():Activate( 100, ::oFolder:aDialogs[2] )
   
   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::okActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown      := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }

   ::oDialog:bStart        := {|| ::starActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD starActivate() CLASS ConvertirAlbaranVentasView

   ::oFolder:aEnable    := { .t., .f., .f. }

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD okActivate() CLASS ConvertirAlbaranVentasView

   do case 
      case ::oFolder:nOption == 1
         ::okActivateFolderOne()


      case ::oFolder:nOption == 2
         ::okActivateFolderTwo()

      case ::oFolder:nOption == 3
         ::oDialog:End()
   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD okActivateFolderOne() CLASS ConvertirAlbaranVentasView

   local aAlbaranes 
   local hWhere /*:= { "tercero_codigo" => "003",;
                     "ruta_codigo" => "002" }*/

   aAlbaranes := SQLAlbaranesVentasModel():getArrayAlbaranWhereHash( ::dFechaDesde, ::dFechaHasta, hWhere )
   if empty( aAlbaranes )
      msgstop("No existen albaranes en el rango de fechas seleccionado")
      RETURN( nil )
   end if

   //msgalert( hb_valtoexp( aAlbaranes ), "albaraneeees")

   ::insertTemporalAlbaranes( hWhere )

   ::getController():getConvertirAlbaranVentasTemporalController():getRowSet():refresh()

   ::oFolder:aEnable[ 2 ]  := .t.
   ::oFolder:setOption( 2 ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD okActivateFolderTwo() CLASS ConvertirAlbaranVentasView

msgalert( hb_valtoexp( ::getController():getConvertirAlbaranVentasTemporalController():getUuids() ) )

   if empty(::getController():getConvertirAlbaranVentasTemporalController():getUuids() )
      msgstop("Debe seleccionar al menos un albaran")
      RETURN( nil )
   end if
   
   ::convertAlbaranVentas( ::getController():getConvertirAlbaranVentasTemporalController():getUuids() )

   ::oFolder:aEnable[ 3 ]  := .t.
   ::oFolder:setOption( 3 ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertTemporalAlbaranes( hWhere ) CLASS ConvertirAlbaranVentasView

   ::getController():getConvertirAlbaranVentasTemporalController():getModel():insertTemporalAlbaranes( ::dFechaDesde, ::dFechaHasta, hWhere )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertAlbaranVentas( aSelecteds )

   local Selected 
   ::getController():runConvertAlbaran( aSelecteds )
   /*for each Selected in aSelecteds
      msgalert( Selected, "uuidSelected" )
     
      if ::getController():getModel():countDocumentoWhereUuidOigen( Selected ) == 0
      

   next*/


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
  
RETURN ( ::getController:oDestinoController:getInitialWhereDocumentos(::oController:setWhereArray( ::oController:aCreatedDocument ) ) )

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

