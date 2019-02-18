#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS ConversorPrepareAlbaranVentasController FROM ConversorPrepareController

   DATA aControllers                   INIT {}

   DATA oConversorAlbaranesController

   DATA oRowset

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()                        

   METHOD generatePreview()

   METHOD generateConvert()

   METHOD getUuids()                   INLINE ( ::getRowSet():uuidFromRecno( ::getBrowseView():oBrowse:aSelected ) )

   //Construcciones tardias----------------------------------------------------

   METHOD getConversorView()           INLINE ( if( empty( ::oConversorView ), ::oConversorView := ConversorAlbaranVentasView():New( self ), ), ::oConversorView ) 

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesPreviewBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getRowSet()                  INLINE ( iif( empty( ::oRowSet ), ::oRowSet := SQLRowSet():New( self ), ), ::oRowSet )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oOrigenController, oDestinoController ) CLASS ConversorPrepareAlbaranVentasController

   ::Super:New( oOrigenController )

   ::oDestinoController              := oDestinoController

   ::oConversorAlbaranesController := ConversorAlbaranesController():New( self )

   aadd( ::aControllers, ContadoresAlbaranesVentasController():New() )

   aadd( ::aControllers, TercerosController():New() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorPrepareAlbaranVentasController

   if !empty( ::oConversorDocumentosController )
      ::oConversorDocumentosController:End()
   end if

   if !empty( ::oConversorView )
      ::oConversorView:End()
   end if

   if !empty( ::oRowset )
      ::oRowset:End()
   end if

   aeval( ::aControllers, {| oController | oController:End() } )

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD Run() CLASS ConversorPrepareAlbaranVentasController

RETURN ( ::getConversorView():Activate() )

//---------------------------------------------------------------------------//

METHOD generatePreview() CLASS ConversorPrepareAlbaranVentasController

   local aWhere   := {}

   /*aeval( ::aControllers,;
      {|oController| aeval( oController:getRange():getWhere(),;
         {|cCondition| aadd( aWhere, cCondition ) } ) } )*/

   ::getRowset():build( SQLAlbaranesVentasModel():getSentenceAlbaranWhereHash( ::getConversorView():oPeriodo:oFechaInicio:Value(), ::getConversorView():oPeriodo:oFechaFin:Value(), aWhere ) )

   ::getBrowseView():selectAll()

RETURN ( ::getRowSet():recCount() > 0 )

//---------------------------------------------------------------------------//

METHOD generateConvert() CLASS ConversorPrepareAlbaranVentasController

   ::oConversorAlbaranesController():Convert( ::getUuids() )

   ::aCreatedDocument := ::oConversorAlbaranesController():convertDocument()

   ::getRowSet():Build( ::getModel():getInitialSelect() )

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

   METHOD Activate()
      METHOD starActivate()
      METHOD okActivate()
         METHOD okActivateFolderOne()
         METHOD okActivateFolderTwo()

   METHOD setFolderToPreview()         INLINE ( ::oFolder:aEnable[ 2 ] := .t., ::oFolder:setOption( 2 ) )

   METHOD setFolderConvertion()        INLINE ( ::oFolder:aEnable[ 3 ]  := .t., ::oFolder:setOption( 3 ), ::oFolder:aEnable[ 1 ]  := .f., ::oFolder:aEnable[ 2 ]  := .f. )

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

   ::oController:Activate( 100, ::oFolder:aDialogs[2] )

   ::oController:Activate( 100, ::oFolder:aDialogs[3] )

   ::oBrwRange    := BrowseRange():New( 140, ::oFolder:aDialogs[1], ::oController:aControllers )

   ::oBrwRange:Resource()

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::okActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }

   ::oDialog:bStart     := {|| ::starActivate(), ::paintedActivate() }

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

   if ::oController:generatePreview()

      ::setFolderToPreview()

   else

      msgstop( "No existen albaranes con el filtro seleccionado" )

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD okActivateFolderTwo() CLASS ConversorAlbaranVentasView
   
   if empty( ::oController:getUuids() )
      msgstop("Debe seleccionar al menos un albaran")
      RETURN( nil )
   end if

   ::oController:generateConvert()

   ::setFolderConvertion()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
