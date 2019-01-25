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

   DATA aDescuentos                    INIT {}
   DATA aDescuentosActuales            INIT {}

   DATA oResumenView

   DATA oConvertirView

   DATA cRuta                          INIT nil
   DATA cTarifa                        INIT nil
   DATA cMetodoPago                    INIT nil
   DATA cTerceroCodigo                 INIT nil
   DATA cRecargoEquivalencia           INIT nil

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()

   METHOD getDestinoController()       INLINE ( ::oDestinoController )

   METHOD Convert()
      METHOD convertHeader()
      METHOD convertLines()
      METHOD convertDiscounts()

   METHOD convertAlbaranCompras()

   METHOD setWhereArray( aSelecteds )

   //Construcciones tardias----------------------------------------------------

   METHOD getAlbaranesComprasController() ;
                                       INLINE ( ::oDestinoController := AlbaranesComprasController():New( self ), ::oDestinoController ) 

   METHOD getAlbaranesVentasController() ;
                                       INLINE ( ::oDestinoController := AlbaranesVentasController():New( self ), ::oDestinoController ) 

   METHOD getFacturasComprasController() ;
                                       INLINE ( ::oDestinoController := FacturasComprasController():New( self ), ::oDestinoController ) 

   METHOD getFacturasVentasController() ;
                                       INLINE ( ::oDestinoController := FacturasVentasController():New( self ), ::oDestinoController ) 

   METHOD getFacturasVentasSimplificadasController() ;
                                       INLINE ( ::oDestinoController := FacturasVentasSimplificadasController():New( self ), ::oDestinoController ) 

   METHOD getPedidosComprasController() ;
                                       INLINE ( ::oDestinoController := PedidosComprasController():New( self ), ::oDestinoController ) 

   METHOD getPedidosVentasController() ;
                                       INLINE ( ::oDestinoController := PedidosVentasController():New( self ), ::oDestinoController ) 

   METHOD getPresupuestosVentasController() ;
                                       INLINE ( ::oDestinoController := PresupuestosVentasController():New( self ), ::oDestinoController ) 
   


   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLConversorDocumentosModel():New( self ), ), ::oModel ) 

   METHOD getConvertirView()           INLINE ( if( empty( ::oConvertirView ), ::oConvertirView := ConversorDocumentoView():New( self ), ), ::oConvertirView )

   METHOD getResumenView()             INLINE ( if( empty( ::oResumenView ), ::oResumenView := ConversorResumenView():New( self ), ), ::oResumenView )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()              INLINE ( ::oDialogView := ::oController:getFacturasComprasController():getDialogView() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ConversorDocumentosController 

   ::aDocumentosDestino := {  "Albarán de compras"             => {|| ::getAlbaranesComprasController() },;
                              "Albarán de ventas"              => {|| ::getAlbaranesVentasController() },;
                              "Factura de compras"             => {|| ::getFacturasComprasController() },;
                              "Factura de ventas"              => {|| ::getFacturasventasController() },;
                              "Factura de ventas simplificada" => {|| ::getFacturasVentasSimplificadasController() },;
                              "Pedido de compras"              => {|| ::getPedidosComprasController() },;
                              "Pedido de ventas"               => {|| ::getPedidosVentasController() },;
                              "Presupuesto de ventas"          => {|| ::getPresupuestosVentasController() } }

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
      msgstop("No puede seleccionar el mismo tipo de documento")
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

   hBufferDocumentoOrigen  := ::getController():getModel():getHashWhere( "uuid", ::uuidDocumentoOrigen )

   hdel( hBufferDocumentoOrigen, 'id' )
   hdel( hBufferDocumentoOrigen, 'uuid' )
   hdel( hBufferDocumentoOrigen, 'fecha' )

   ::oDestinoController:getModel():insertBlankBuffer( hBufferDocumentoOrigen )

   ::uuidDocumentoDestino    := ::oDestinoController:getModelBuffer( "uuid" )

   ::idDocumentoDestino      := ::oDestinoController:getModelBuffer( "id" )

   ::getModel():insertRelationDocument( ::uuidDocumentoOrigen, ::getController():getModel():cTableName, ::uuidDocumentoDestino ,::oDestinoController:getModel():cTableName )

   ::aCreatedDocument:add( ::uuidDocumentoDestino )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertLines() CLASS ConversorDocumentosController

   local hLine
   local uuidOriginLine
   local uuidDestinyLine
   local aLinesDocumentoOrigen

   aLinesDocumentoOrigen   := ::getController():getLinesController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if aLinesDocumentoOrigen == nil
      RETURN ( nil )
   end if

   for each hLine in aLinesDocumentoOrigen

         uuidOriginLine := hget( hLine, "uuid" )

         hdel( hLine, 'id' )
         hdel( hLine, 'uuid' )
         hset( hLine, 'parent_uuid', ::uuidDocumentoDestino )

         ::oDestinoController:getLinesController():getModel():insertBlankBuffer( hLine )

         uuidDestinyLine := ::oDestinoController:getLinesController():getModelBuffer( "uuid" )

         ::getModel():insertRelationDocument( uuidOriginLine, ::getController():getLinesController():getModel():cTableName, uuidDestinyLine, ::oDestinoController:getLinesController():getModel():cTableName )
   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertDiscounts() CLASS ConversorDocumentosController

   local hDiscount
   local aDiscountsDocumentoOrigen
   local uuidOriginDiscount
   local uuidDestinyDiscount

   aDiscountsDocumentoOrigen   := ::getController():getDiscountController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aDiscountsDocumentoOrigen )
      RETURN ( nil )
   end if

   for each hDiscount in aDiscountsDocumentoOrigen

         uuidOriginDiscount:= hget(hDiscount, "uuid")
         hdel( hDiscount, 'id' )
         hdel( hDiscount, 'uuid' )
         hset( hDiscount, 'parent_uuid', ::uuidDocumentoDestino )

         ::oDestinoController:getDiscountController():getModel():insertBlankBuffer( hDiscount )

         uuidDestinyDiscount := ::oDestinoController:getDiscountController():getModelBuffer( "uuid" )

         ::getModel():insertRelationDocument( uuidOriginDiscount, ::getController:getDiscountController():getModel():cTableName, uuidDestinyDiscount, ::oDestinoController:getDiscountController():getModel():cTableName )
   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertAlbaranCompras( aSelecteds ) CLASS ConversorDocumentosController

   local hAlbaranes := {}
   Local hAlbaran
   local aDescuentosActuales

   if empty( ::getController() )
      RETURN ( nil )
   end if

   ::oDestinoController := ::getFacturasComprasController()

   hAlbaranes:= SQLAlbaranesComprasModel():getHashWhereUuid( ::setWhereArray( aSelecteds ) )

   for each hAlbaran in hAlbaranes

      if (::getModel():countDocumentoWhereUuidOigen( hget( hAlbaran, "uuid") ) == 0 )

          ::aDescuentosActuales := ::getController():getDiscountController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen ) 
      
         if( ::cTerceroCodigo != hget(hAlbaran, "tercero_codigo") .OR. ::cRuta != hget( hAlbaran, "ruta_codigo" ) .OR. ::cMetodoPago !=hget( hAlbaran ,"metodo_pago_codigo" ) .OR. ::cTarifa != hget( hAlbaran, "tarifa_codigo") .OR. ::cRecargoEquivalencia != hget( hAlbaran, "recargo_equivalencia" ) .OR. hb_valtoexp(::aDescuentos) != hb_valtoexp(::aDescuentosActuales ) )

            ::uuidDocumentoOrigen   := hget( hAlbaran, "uuid")

            ::cRuta                 := hget( hAlbaran, "ruta_codigo" )

            ::cMetodoPago           := hget( hAlbaran, "metodo_pago_codigo" )

            ::cTarifa               := hget( hAlbaran, "tarifa_codigo")

            ::cRecargoEquivalencia  := hget( hAlbaran, "recargo_equivalencia" )

            ::aDescuentos           := ::getController():getDiscountController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )
            
            ::convertHeader()

            ::convertDiscounts()

         else
         
         ::uuidDocumentoOrigen   := hget(hAlbaran, "uuid")

         ::getModel():insertRelationDocument( ::uuidDocumentoOrigen, ::getController():getModel():cTableName, ::uuidDocumentoDestino ,::oDestinoController:getModel():cTableName )

         ::aDescuentos           := ::getController():getDiscountController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )
         
         end if

         ::cTerceroCodigo  :=  hget(hAlbaran, "tercero_codigo")

         ::convertLines()

         end if

   next

   if !empty( ::aCreatedDocument )
       ::getResumenView():Activate()
       ::aCreatedDocument := {}
   end if 

RETURN( nil )

//---------------------------------------------------------------------------//

METHOD setWhereArray( aSelecteds ) CLASS ConversorDocumentosController
   
   local aSelected
   local nWhere := 0
   local cWhere := " IN("

 for each aSelected in aSelecteds
   nWhere++

   cWhere += quoted( aSelected )

   if(nWhere != Len( aSelecteds ) )
      cWhere +=","
   end if
   next

   cWhere += " )"

RETURN ( cWhere )
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

/*CLASS ConversorDocumentosBrowseView FROM OperacionesComercialesBrowseView

   METHOD addColumns() 

END class

//---------------------------------------------------------------------------//

METHOD addColumns() CLASS ConversorDocumentosBrowseView

   ::Super:addColumns()

   RETURN ( nil )*/

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

   ::getController():Activate(100, ::oDialog )


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

   METHOD insertRelationDocument( uuidOrigin, cTableOrigin, uuidDestiny, cTableDestiny )

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

METHOD insertRelationDocument( uuidOrigin, cTableOrigin, uuidDestiny, cTableDestiny ) CLASS SQLConversorDocumentosModel

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
                                 quoted( cTableDestiny ),;
                                 quoted( uuidDestiny ) )
                                 
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
