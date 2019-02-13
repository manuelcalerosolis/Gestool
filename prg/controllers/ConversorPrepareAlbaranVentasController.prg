#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS ConversorPrepareAlbaranVentasController FROM ConversorPrepareController

   DATA oConvertirAlbaranVentasTemporalController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()                        

   METHOD convertDocument( aConvert )

   //Construcciones tardias----------------------------------------------------

   METHOD getConversorView()           INLINE ( if( empty( ::oConversorView ), ::oConversorView := ConversorAlbaranVentasView():New( self ), ), ::oConversorView ) 

   METHOD getConvertirAlbaranVentasTemporalController();
                                       INLINE ( if( empty( ::oConvertirAlbaranVentasTemporalController ), ::oConvertirAlbaranVentasTemporalController := ConvertirAlbaranVentasTemporalController():New( self ), ), ::oConvertirAlbaranVentasTemporalController )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oOrigenController, oDestinoController ) CLASS ConversorPrepareAlbaranVentasController

   ::Super:New( oOrigenController )

   ::oDestinoController              := oDestinoController

   ::oConversorDocumentosController := ConversorDocumentosController():New( self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorPrepareAlbaranVentasController

   if !empty( ::oConvertirAlbaranVentasTemporalController )
      ::oConvertirAlbaranVentasTemporalController:End()
   end if

   if !empty( ::oConversorDocumentosController )
      ::oConversorDocumentosController:End()
   end if

   if !empty( ::oConversorView )
      ::oConversorView:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD convertDocument( aSelected )

 ::aCreatedDocument := ::getConversorDocumentosController():convertDocument()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Run() CLASS ConversorPrepareAlbaranVentasController

   ::getConvertirAlbaranVentasTemporalController():getModel():createTemporalTable()

   ::getConversorView():Activate()

   ::getConvertirAlbaranVentasTemporalController():getModel():dropTemporalTable()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ConversorAlbaranVentasView FROM SQLBaseView

   DATA oPeriodo

   DATA oBrwRange

   METHOD insertTemporalAlbaranes( aAlbaranes )

   METHOD Activate()
      METHOD starActivate()
      METHOD okActivate()
         METHOD okActivateFolderOne()
         METHOD okActivateFolderTwo()

   METHOD convertAlbaranVentas( aSelected )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ConversorAlbaranVentasView

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


   ::oPeriodo     := GetPeriodo():New( 110, 120, 130 )
   ::oPeriodo:Resource( ::oFolder:aDialogs[ 1 ] )

   ::oController:getConvertirAlbaranVentasTemporalController():Activate( 100, ::oFolder:aDialogs[2] )

   ::oController:Activate( 100, ::oFolder:aDialogs[3] )

   ::oBrwRange    := BrowseRange():New( 140, ::oFolder:aDialogs[1] )

   ::oBrwRange:addController( ContadoresAlbaranesVentasController():New() )

   ::oBrwRange:addController( TercerosController():New() )

   ::oBrwRange:Resource()

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::okActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown      := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }

   ::oDialog:bStart        := {|| ::starActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

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

         ::oDialog:end()

   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD okActivateFolderOne() CLASS ConversorAlbaranVentasView

   local aAlbaranes
   local hWhere /*:= { "tercero_codigo" => "003",;
                     "ruta_codigo" => "002" }*/

   aAlbaranes := SQLAlbaranesVentasModel():getArrayAlbaranWhereHash( ::oPeriodo:oFechaInicio:Value(), ::oPeriodo:oFechaFin:Value(), hWhere )
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

   ::oController:aCreatedDocument := ::oController:getConversorDocumentosController():convertDocument()

   ::oController:getRowSet():Build( ::oController:getModel():getInitialSelect() )

   ::oFolder:aEnable[ 3 ]  := .t.
   ::oFolder:setOption( 3 )
   ::oFolder:aEnable[ 2 ]  := .f.

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertTemporalAlbaranes( hWhere ) CLASS ConversorAlbaranVentasView

   ::oController:getConvertirAlbaranVentasTemporalController():getModel():insertTemporalAlbaranes( ::oPeriodo:oFechaInicio:Value(), ::oPeriodo:oFechaFin:value(), hWhere )

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
