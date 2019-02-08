#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConversorPrepareController 

   DATA aSelected

   DATA aDocumentosDestino 

   DATA aCreatedDocument               INIT {}

   DATA oDestinoController

   DATA oOrigenCOntroller

   DATA oResumenView

   DATA oConvertirView

   DATA oConvertirAlbaranVentasView

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()

   METHOD getDestinoController()       INLINE ( ::oDestinoController )

   METHOD convertDocument( aConvert )

   METHOD runConvert( aSelected )

   //Construcciones tardias----------------------------------------------------

   METHOD setDocumentosDestino()

   METHOD getModel()                   INLINE ( ::getConversorDocumentosController():getModel() ) 

   METHOD setAlbaranesComprasController() ;
                                       INLINE ( ::oDestinoController := AlbaranesComprasController():New( self ), ::oDestinoController ) 

   METHOD setAlbaranesVentasController() ;
                                       INLINE ( ::oDestinoController := AlbaranesVentasController():New( self ), ::oDestinoController ) 

   METHOD setFacturasComprasControllerAsDestino() ;
                                       INLINE ( ::oDestinoController := FacturasComprasController():New( self ), ::oDestinoController ) 

   METHOD setFacturasVentasControllerAsDestino() ;
                                       INLINE ( ::oDestinoController := FacturasVentasController():New( self ), ::oDestinoController ) 


   METHOD setFacturasVentasSimplificadasController() ;
                                       INLINE ( ::oDestinoController := FacturasVentasSimplificadasController():New( self ), ::oDestinoController ) 

   METHOD setPedidosComprasController() ;
                                       INLINE ( ::oDestinoController := PedidosComprasController():New( self ), ::oDestinoController ) 

   METHOD setPedidosVentasController() ;
                                       INLINE ( ::oDestinoController := PedidosVentasController():New( self ), ::oDestinoController ) 

   METHOD setPresupuestosVentasController() ;
                                       INLINE ( ::oDestinoController := PresupuestosVentasController():New( self ), ::oDestinoController )

   METHOD getConvertirView()           INLINE ( if( empty( ::oConvertirView ), ::oConvertirView := ConversorDocumentoView():New( self ), ), ::oConvertirView )

   METHOD getResumenView()             INLINE ( if( empty( ::oResumenView ), ::oResumenView := ConversorResumenView():New( self ), ), ::oResumenView )

   METHOD getAlbaranVentasView()       INLINE ( if( empty( ::oConvertirAlbaranVentasView ), ::oConvertirAlbaranVentasView := ConvertirAlbaranVentasView():New( self ), ), ::oConvertirAlbaranVentasView )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := ::oController:getFacturasComprasController():getDialogView(), ::oDialogView ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oOrigenController, oDestinoController, aSelected ) CLASS ConversorPrepareController 

   ::oOrigenController              := oOrigenController

   ::oDestinoController             := oDestinoController

   ::aSelected                      := aSelected

   ::oConversorDocumentosController := ConversorDocumentosController():New( self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorPrepareController

   if !empty( ::oConversorDocumentosControllerModel )
      ::oConversorDocumentosController:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setDocumentosDestino()

   ::aDocumentosDestino := {  "Albarán de compras"             => {|| ::setAlbaranesComprasController() },;
                              "Albarán de ventas"              => {|| ::setAlbaranesVentasController() },;
                              "Factura de compras"             => {|| ::setFacturasComprasControllerAsDestino() },;
                              "Factura de ventas"              => {|| ::setFacturasventasController() },;
                              "Factura de ventas simplificada" => {|| ::setFacturasVentasSimplificadasController() },;
                              "Pedido de compras"              => {|| ::setPedidosComprasController() },;
                              "Pedido de ventas"               => {|| ::setPedidosVentasController() },;
                              "Presupuesto de ventas"          => {|| ::setPresupuestosVentasController() } }

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Run() CLASS ConversorPrepareController

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
/*
METHOD Edit( nId ) CLASS ConversorDocumentosController

   if empty( nId )
      nId   := ::getIdFromRowSet()
   end if

RETURN ( ::getDestinoController():Edit( nId ) )
*/
//---------------------------------------------------------------------------//

METHOD convertDocument( aCreatedDocument ) CLASS ConversorPrepareController

   if !empty( aCreatedDocument )
      ::getResumenView():Activate()
   end if

RETURN ( aCreatedDocument )

//---------------------------------------------------------------------------//

METHOD runConvert() CLASS ConversorPrepareController

   local aCreatedDocument

   msgalert( hb_valtoexp( ::aSelected ), "aSelected" )

   ::getConversorDocumentosController():runConvertAlbaran( ::aSelected )

   aCreatedDocument := ::getConversorDocumentosController():convertDocument()

   ::convertDocument( aCreatedDocument )

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

   METHOD convertAlbaranVentas( aSelected )
         
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

METHOD convertAlbaranVentas( aSelected )

   local Selected 
   ::getController():runConvertAlbaranCompras( aSelected )
   /*for each Selected in aSelected
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