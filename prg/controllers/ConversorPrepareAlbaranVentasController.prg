#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS ConversorPrepareAlbaranVentasController FROM ConversorPrepareController

   DATA aControllers                   INIT {}

   DATA oConversorAlbaranesController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Run()           

   METHOD getWhereOrigen()

   METHOD getWhereDestino()

   METHOD generatePreview()

   METHOD generateConvert()

   //Construcciones tardias----------------------------------------------------

   METHOD getConversorView()           INLINE ( iif( empty( ::oConversorView ), ::oConversorView := ConversorAlbaranVentasView():New( self ), ), ::oConversorView ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ConversorPrepareAlbaranVentasController

   local oRutasController
   local oAgentesController
   local oTercerosController
   local oAlmacenesController
   local oMetodosPagosController
   local oArticulosTarifasController
   local oContadoresAlbaranesVentasController

   ::Super:New( AlbaranesVentasConversorController():New( self ) )

   ::oDestinoController                   := FacturasVentasConversorController():New( self )

   ::oConversorAlbaranesController        := ConversorAlbaranesController():New( self )

   // Series-------------------------------------------------------------------

   oContadoresAlbaranesVentasController   := ContadoresAlbaranesVentasController():New()
   oContadoresAlbaranesVentasController:getRange():setAlias( ::oOrigenController:getModel():getAlias() ) 

   aadd( ::aControllers, oContadoresAlbaranesVentasController )

   // Grupos terceros----------------------------------------------------------

   aadd( ::aControllers, TercerosGruposController():New() )

   // Terceros-----------------------------------------------------------------

   oTercerosController                    := TercerosController():New()
   oTercerosController:getRange():setAlias( ::oOrigenController:getModel():getAlias() ) 

   aadd( ::aControllers, oTercerosController )

   // Metodos de pago----------------------------------------------------------

   oMetodosPagosController                := MetodosPagosController():New()
   oMetodosPagosController:getRange():setAlias( ::oOrigenController:getModel():getAlias() ) 

   aadd( ::aControllers, oMetodosPagosController )

   // Almacenes-----------------------------------------------------------------

   oAlmacenesController                   := AlmacenesController():New()
   oAlmacenesController:getRange():setAlias( ::oOrigenController:getModel():getAlias() ) 

   aadd( ::aControllers, oAlmacenesController )

   // Tarifas------------------------------------------------------------------

   oArticulosTarifasController            := ArticulosTarifasController():New()
   oArticulosTarifasController:getRange():setAlias( ::oOrigenController:getModel():getAlias() ) 

   aadd( ::aControllers, oArticulosTarifasController )

   // Rutas--------------------------------------------------------------------

   oRutasController                       := RutasController():New()
   oRutasController:getRange():setAlias( ::oOrigenController:getModel():getAlias() ) 

   aadd( ::aControllers, oRutasController )

   // Agentes------------------------------------------------------------------

   oAgentesController                     := AgentesController():New()
   oAgentesController:getRange():setAlias( ::oOrigenController:getModel():getAlias() ) 

   aadd( ::aControllers, oAgentesController )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConversorPrepareAlbaranVentasController

   if !empty( ::oOrigenController )
      ::oOrigenController:End()
   end if

   if !empty( ::oDestinoController )
      ::oDestinoController:End()
   end if

   if !empty( ::oConversorAlbaranesController )
      ::oConversorAlbaranesController:End()
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

   ::oOrigenController:getModel():setLimit( 0 )

   ::oDestinoController:getModel():setLimit( 0 )

RETURN ( ::getConversorView():Activate() )

//---------------------------------------------------------------------------//

METHOD generatePreview() CLASS ConversorPrepareAlbaranVentasController

   ::oOrigenController:getModel():setLimit( nil )

   ::oOrigenController:getModel():setGeneralWhere( ::getWhereOrigen() )

   ::oOrigenController:getRowset():build( ::oOrigenController:getModel():getSelectSentence() )

   ::oOrigenController:getBrowseView():selectAll()

RETURN ( ::oOrigenController:getRowset():recCount() > 0 )

//---------------------------------------------------------------------------//

METHOD getWhereOrigen() CLASS ConversorPrepareAlbaranVentasController

   local cWhere   := ''

   cWhere         += "canceled_at = 0 "
   cWhere         += "AND fecha >= " + dtos( ::getConversorView():oPeriodo:oFechaInicio:Value() )  + " "
   cWhere         += "AND fecha <= " + dtos( ::getConversorView():oPeriodo:oFechaFin:Value() )     + " "

   aeval( ::aControllers,;
      {|oController| ; 
         cWhere += oController:getRange():getWhere(),;
         cWhere += oController:getFilterController():getWhere() } )

RETURN ( cWhere )

//---------------------------------------------------------------------------//

METHOD generateConvert() CLASS ConversorPrepareAlbaranVentasController

   ::aCreatedDocument   := ::oConversorAlbaranesController():Convert( ::oOrigenController:getUuids() )

   ::oDestinoController:getModel():setLimit( nil )

   ::oDestinoController:getModel():setGeneralWhere( ::getWhereDestino( ::aCreatedDocument ) )

   ::oDestinoController:getRowSet():Build( ::oDestinoController:getModel():getSelectSentence() )

   ::oDestinoController:getBrowseView():Refresh()

   ::aCreatedDocument := {}

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getWhereDestino( aSelected ) CLASS ConversorPrepareAlbaranVentasController
   
   local cWhere
   
   if empty( aSelected )
      RETURN ( '' )
   end if 
   
   cWhere         :=  ::oDestinoController:getModel():cTableName + ".uuid IN( "

   aeval( aSelected, {| v | cWhere += quotedUuid( v ) + ", " } )

   cWhere         := chgAtEnd( cWhere, ' )', 2 )

RETURN ( cWhere )

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
      RESOURCE    "gc_funnel_red_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Seleccione el rango de fechas y condiciones para la generación de albaranes" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "Rangos" ,;
                  "Albaranes",;
                  "Facturas generadas" ;
      DIALOGS     "CONVERTIR_ALBARAN_VENTAS",;
                  "CONVERTIR_ALBARAN_VENTAS_PREVIA",;
                  "CONVERTIR_ALBARAN_VENTAS_PREVIA"

   ::oPeriodo     := GetPeriodo():New( 110, 120, 130 )
   ::oPeriodo:Resource( ::oFolder:aDialogs[ 1 ] )

   ::oBrwRange    := BrowseRange():New( 140, ::oFolder:aDialogs[ 1 ], ::oController )

   ::oBrwRange:Resource()

   ::oController:oOrigenController:Activate( 100, ::oFolder:aDialogs[ 2 ] )

   ::oController:oDestinoController:Activate( 100, ::oFolder:aDialogs[ 3 ] )

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::okActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oFolder:aDialogs[ 1 ]:bKeyDown := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }
   ::oFolder:aDialogs[ 2 ]:bKeyDown := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }
   ::oFolder:aDialogs[ 3 ]:bKeyDown := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }
   ::oDialog:bKeyDown               := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }

   ::oDialog:bStart                 := {|| ::starActivate(), ::paintedActivate() }

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

      ::oController:getConversorView():setMessage( "Seleccione los albaranes que deseas convertir a factura" )

      ::setFolderToPreview()

   else

      ::oController:getConversorView():showMessage( "No existen albaranes con el filtro seleccionado" )

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD okActivateFolderTwo() CLASS ConversorAlbaranVentasView
   
   if empty( ::oController:oOrigenController:getUuids() )

      ::oController:getConversorView():showMessage( "Debe seleccionar al menos un albarán" )

      RETURN ( nil )

   end if

   ::oController:generateConvert()

   ::setFolderConvertion()

   ::oController:getConversorView():setMessage( "Facturas generadas" )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
