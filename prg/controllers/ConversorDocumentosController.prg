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

   DATA aConvert                       INIT { "header" => , "lines" => , "discounts" => }

   DATA hHeader                        INIT {}

   DATA hLines                         INIT {}

   DATA hDiscounts                     INIT {}

   DATA oResumenView

   DATA oConvertirView

   DATA hProcesedAlbaran               INIT{}

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()

   METHOD getDestinoController()       INLINE ( ::oDestinoController )

   METHOD Convert()
      METHOD convertHeader()
      METHOD convertLines()
      METHOD convertDiscounts()

   METHOD runConvertAlbaranCompras( aSelected ) 
      METHOD convertAlbaranCompras( aSelected )

   Method isAlbaranEquals( hAlbaran )

   METHOD setWhereArray( aSelected )

   METHOD isAlbaranNotConverted( hAlbaran ) ;
                                       INLINE ( ::getModel():countDocumentoWhereUuidOigen( hget( hAlbaran, "uuid" ) ) == 0 )

   METHOD insertRelationDocument()     INLINE ( ::getModel():insertRelationDocument( ::uuidDocumentoOrigen, ::getController():getModel():cTableName, ::uuidDocumentoDestino, ::oDestinoController:getModel():cTableName ) )

   METHOD Edit( nId )

   //Construcciones tardias----------------------------------------------------

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
                              "Factura de compras"             => {|| ::setFacturasComprasController() },;
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

   ::convertHeader()

   ::convertLines()

   ::convertDiscounts()

   ::oDestinoController:Edit( ::idDocumentoDestino )

RETURN ( nil )   

//---------------------------------------------------------------------------//

METHOD convertHeader() CLASS ConversorDocumentosController

   local hBufferDocumentoOrigen

   hBufferDocumentoOrigen     := ::getController():getModel():getHashWhere( "uuid", ::uuidDocumentoOrigen )

   aadd( ::hHeader, hBufferDocumentoOrigen )

   //::aCreatedDocument:add( ::uuidDocumentoDestino )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertLines() CLASS ConversorDocumentosController

   local hLine
   local uuidOriginLine
   local uuidDestinationLine
   local aLinesDocumentoOrigen

   aLinesDocumentoOrigen   := ::getController():getLinesController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aLinesDocumentoOrigen )
      
      RETURN ( nil )
   
   end if

   aadd( ::hLines, aLinesDocumentoOrigen )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertDiscounts() CLASS ConversorDocumentosController

   local hDiscount
   local aDiscountsDocumentoOrigen
   local uuidOriginDiscount
   local uuidDestinationDiscount

   aDiscountsDocumentoOrigen  := ::getController():getDiscountController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   /*if empty( aDiscountsDocumentoOrigen )

      RETURN ( nil )
   end if*/

   aadd( ::hDiscounts, aDiscountsDocumentoOrigen )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD runConvertAlbaranCompras( aSelected ) CLASS ConversorDocumentosController
   
   local header
   local lines
   local discounts

   ::convertAlbaranCompras( aSelected ) 


   /*if !empty( ::aCreatedDocument )

      aeval( ::aCreatedDocument, {|uuidDocument| ::generate }, nStart, nCount)

      ::getResumenView():Activate()
   end if*/

   hset( ::aConvert, "header", ::hHeader )

   hset( ::aConvert,"lines", ::hLines )
   
   hset( ::aConvert, "discounts", ::hDiscounts )
   
   
   for each header in ::hHeader
      
      msgalert(hb_valtoexp( header ), "cabecera" )
   
   next

   for each lines in ::hLines
      
      msgalert(hb_valtoexp( lines ), "lineas" )
   
   next

   for each discounts in ::hDiscounts
      
      msgalert(hb_valtoexp( discounts ), "discounts" )
   
   next

   msgalert( hb_valtoexp( ::aConvert ), "::aConvert" )
   //::aCreatedDocument   := {}

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertAlbaranCompras( aSelected ) CLASS ConversorDocumentosController

   Local hAlbaran
   local hAlbaranes 

   if empty( ::getController() )
      RETURN ( nil )
   end if

   ::setFacturasComprasController()

   hAlbaranes  := SQLAlbaranesComprasModel():getHashWhereUuidAndOrder( ::setWhereArray( aSelected ) )

   for each hAlbaran in hAlbaranes

      if ::isAlbaranNotConverted( hAlbaran ) 

         ::uuidDocumentoOrigen   := hget( hAlbaran, "uuid")

         if ::isAlbaranEquals( hAlbaran )

            //::sumDocument()
               
            ::convertLines()

            //::insertRelationDocument()

         else

            //::addDocument()

               ::convertHeader()

               ::convertLines()
            
               ::convertDiscounts()

         end if

         ::hProcesedAlbaran      := hAlbaran

      end if

   next

RETURN ( ::aCreatedDocument )

//---------------------------------------------------------------------------//

METHOD isAlbaranEquals( hAlbaran )

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

   if !empty( ::getController():getDiscountController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen ) ) 
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

METHOD Edit( nId )

   if empty( nId )
      nId   := ::getIdFromRowSet()
   end if

RETURN ( ::getDestinoController():Edit( nId ) )

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

   msgalert( ::getController():className(), "controller:className()")

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
   
   ::oDialog:Activate( , , , .t. )

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
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
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestOperacionesController FROM TestCase

   DATA oController

   METHOD beforeClass()                VIRTUAL

   METHOD afterClass()

   METHOD Before() 

END CLASS

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestOperacionesController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestOperacionesController

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

   SQLUnidadesMedicionGruposModel():truncateTable()
   SQLUnidadesMedicionOperacionesModel():truncateTable()

   SQLTercerosModel():test_create_contado()
   SQLTercerosModel():test_create_tarifa_mayorista()
   SQLTercerosModel():test_create_con_plazos()

   SQLAlmacenesModel():test_create_almacen_principal()
   SQLAlmacenesModel():test_create_almacen_auxiliar()

   SQLAgentesModel():test_create_agente_principal()
   SQLAgentesModel():test_create_agente_auxiliar()

   SQLUbicacionesModel():test_create_trhee_with_parent( SQLAlmacenesModel():test_get_uuid_almacen_principal() )
   SQLUbicacionesModel():test_create_trhee_with_parent( SQLAlmacenesModel():test_get_uuid_almacen_auxiliar() )

   SQLTiposIvaModel():test_create_iva_al_4()
   SQLTiposIvaModel():test_create_iva_al_10()
   SQLTiposIvaModel():test_create_iva_al_21()

   SQLMetodoPagoModel():test_create_contado()
   SQLMetodoPagoModel():test_create_reposicion()
   SQLMetodoPagoModel():test_create_con_plazos()

   SQLUnidadesMedicionGruposModel():test_create()

   SQLArticulosModel():test_create_con_unidad_de_medicion_cajas_palets()
   SQLArticulosModel():test_create_con_tarifa_mayorista()
   SQLArticulosModel():test_create_con_lote()

   SQLArticulosTarifasModel():test_create_tarifa_base()
   SQLArticulosTarifasModel():test_create_tarifa_mayorista()

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

