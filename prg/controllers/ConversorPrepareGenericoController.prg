#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS ConversorPrepareGenericoController FROM ConversorPrepareController
   
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

METHOD Run() CLASS ConversorPrepareGenericoController

   ::setDocumentosDestino()

   if ::getConversorView():Activate() != IDOK
      RETURN ( nil )
   end if

   if hhaskey( ::aDocumentosDestino, ::getConversorView():getDocumentoDestino() )
      ::oDestinoController    := eval( hget( ::aDocumentosDestino, ::getConversorView():getDocumentoDestino() ) )
   end if

   if !empty( ::oDestinoController )

      ::oConversorDocumentosController():convert()

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
