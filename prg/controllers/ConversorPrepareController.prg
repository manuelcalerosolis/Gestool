#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS ConversorPrepareController FROM SQLBrowseController

   DATA aSelected

   DATA aDocumentosDestino

   DATA aCreatedDocument               INIT {}

   DATA oDestinoController

   DATA oOrigenController

   DATA oConvertirView

   DATA oConvertirAlbaranVentasTemporalController

   DATA oConversorAlbaranVentasView

   DATA oConversorDocumentosController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()

   METHOD getDestinoController()       INLINE ( ::oDestinoController )

   METHOD convertDocument( aConvert )

   METHOD runConvert( aSelected )

   //Construcciones tardias----------------------------------------------------

   METHOD setDocumentosDestino()

   //METHOD getModel()                   INLINE ( ::getConversorDocumentosController():getModel() )

   METHOD getConvertirAlbaranVentasTemporalController();
                                       INLINE ( if( empty( ::oConvertirAlbaranVentasTemporalController ), ::oConvertirAlbaranVentasTemporalController := ConvertirAlbaranVentasTemporalController():New( self ), ), ::oConvertirAlbaranVentasTemporalController )

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

   METHOD getAlbaranVentasView()       INLINE ( if( empty( ::oConversorAlbaranVentasView ), ::oConversorAlbaranVentasView := ConversorAlbaranVentasView():New( self ), ), ::oConversorAlbaranVentasView )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := ::oController:getFacturasComprasController():getDialogView(), ::oDialogView ) )

   METHOD getConversorDocumentosController() ;
                                       INLINE ( if( empty( ::oConversorDocumentosController ), ::oConversorDocumentosController := ConversorDocumentosController():New( self ), ), ::oConversorDocumentosController )

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

   if !empty( ::oConversorDocumentosController )
      ::oConversorDocumentosController:End()
   end if

   if !empty( ::oConvertirAlbaranVentasTemporalController )
      ::oConvertirAlbaranVentasTemporalController:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setDocumentosDestino()

   ::aDocumentosDestino := {  "Albar�n de compras"             => {|| ::setAlbaranesComprasController() },;
                              "Albar�n de ventas"              => {|| ::setAlbaranesVentasController() },;
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

METHOD convertDocument() CLASS ConversorPrepareController

      ::getConversorDocumentosController():convertDocument()
      ::getConversorDocumentosController():showResume()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD runConvert() CLASS ConversorPrepareController

   local aCreatedDocument

   ::getConversorDocumentosController():runConvertAlbaran( ::aSelected )

   ::convertDocument()

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
      ITEMS       ( hgetkeys( ::oController:aDocumentosDestino ) ) ;
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

CLASS ConversorAlbaranVentasView FROM SQLBaseView

   DATA oFechaDesde
   DATA dFechaDesde     INIT boy()

   DATA oFechaHasta
   DATA dFechaHasta     INIT date()

   DATA oBrwRange

   METHOD insertTemporalAlbaranes( aAlbaranes )

   METHOD Activate()
   METHOD Activating()
      METHOD starActivate()
      METHOD okActivate()
         METHOD okActivateFolderOne()
         METHOD okActivateFolderTwo()

   METHOD convertAlbaranVentas( aSelected )

   METHOD cancelDialog()
         
END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ConversorAlbaranVentasView

   ::oController:getConvertirAlbaranVentasTemporalController():getModel():createTemporalTable()

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_LARGE" ;
      TITLE       "Convertir a factura de ventas"

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
                  "Vista previa",;
                  "Convertidos" ;
      DIALOGS     "CONVERTIR_ALBARAN_VENTAS",;
                  "CONVERTIR_ALBARAN_VENTAS_PREVIA",;
                  "CONVERTIR_ALBARAN_VENTAS_PREVIA"

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

   ::oController:getConvertirAlbaranVentasTemporalController():Activate( 100, ::oFolder:aDialogs[2] )

   ::oController:getConversorDocumentosController():Activate( 100, ::oFolder:aDialogs[3] )
   
   ::oBrwRange    := BrowseRange():New( 130, ::oFolder:aDialogs[1] )

   ::oBrwRange:addController( ArticulosController():New() )

   ::oBrwRange:Resource()

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::okActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::cancelDialog() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown      := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }

   ::oDialog:bStart        := {|| ::starActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD Activating() CLASS ConversorAlbaranVentasView

   msgalert( "activating" )
   
   ::oController:getConvertirAlbaranVentasTemporalController():getModel():createTemporalTable()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD starActivate() CLASS ConversorAlbaranVentasView

   ::oFolder:aEnable    := { .t., .f., .f. }

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD okActivate() CLASS ConversorAlbaranVentasView

   do case
      case ::oFolder:nOption == 1

         ::okActivateFolderOne()

      case ::oFolder:nOption == 2

         ::okActivateFolderTwo()

      case ::oFolder:nOption == 3

         ::cancelDialog()

   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD okActivateFolderOne() CLASS ConversorAlbaranVentasView

   local aAlbaranes
   local hWhere /*:= { "tercero_codigo" => "003",;
                     "ruta_codigo" => "002" }*/

   aAlbaranes := SQLAlbaranesVentasModel():getArrayAlbaranWhereHash( ::dFechaDesde, ::dFechaHasta, hWhere )
   if empty( aAlbaranes )
      msgstop("No existen albaranes con el filtro seleccionado")
      RETURN( nil )
   end if

   ::insertTemporalAlbaranes( hWhere )

   ::oController:getConvertirAlbaranVentasTemporalController():getRowSet():refresh()

   ::oFolder:aEnable[ 2 ]  := .t.
   ::oFolder:setOption( 2 ) 
   ::oFolder:aEnable[ 1 ]  := .f.

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD okActivateFolderTwo() CLASS ConversorAlbaranVentasView

   if empty( ::oController:getConvertirAlbaranVentasTemporalController():getUuids() )
      msgstop("Debe seleccionar al menos un albaran")
      RETURN( nil )
   end if

   ::oController:getConversorDocumentosController():runConvertAlbaran( ::oController:getConvertirAlbaranVentasTemporalController():getUuids() )
   
   ::oController:getConversorDocumentosController():convertDocument()
   
   ::oController:getConversorDocumentosController():getRowSet():Build( ::oController:getConversorDocumentosController():getModel():getInitialSelect() ) 
   
   ::oFolder:aEnable[ 3 ]  := .t.
   ::oFolder:setOption( 3 )
   ::oFolder:aEnable[ 2 ]  := .f. 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD cancelDialog() CLASS ConversorAlbaranVentasView

   ::oDialog:end()

   ::oController:getConvertirAlbaranVentasTemporalController():getModel():dropTemporalTable()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertTemporalAlbaranes( hWhere ) CLASS ConversorAlbaranVentasView

   ::oController:getConvertirAlbaranVentasTemporalController():getModel():insertTemporalAlbaranes( ::dFechaDesde, ::dFechaHasta, hWhere )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertAlbaranVentas( aSelected )

 ::oController:getConversorDocumentosController():runConvertAlbaran( aSelected )

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
      TITLE       "Resumen de la conversi�n ..."

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_tags_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Resumen de la conversi�n a facturas" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::oController():Activate( 100, ::oDialog )

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
