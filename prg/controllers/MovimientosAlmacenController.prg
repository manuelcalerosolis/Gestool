#include "Fivewin.ch"
#include "Factu.ch" 
#include "Fastreph.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenController FROM SQLNavigatorController

   DATA cFileName

   DATA oLineasController

   DATA oImportadorController

   DATA oCapturadorController

   DATA oEtiquetasController

   DATA oConfiguracionesController

   DATA oImprimirSeriesController

   DATA oReport

   METHOD New()

   METHOD End()

   METHOD validateNumero()          

   METHOD validateAlmacenOrigen()   INLINE ( iif(  ::validate( "almacen_origen" ),;
                                                   ::stampAlmacenNombre( ::oDialogView:oGetAlmacenOrigen ),;
                                                   .f. ) )

   METHOD validateAlmacenDestino()  INLINE ( iif(  ::validate( "almacen_destino" ),;
                                                   ::stampAlmacenNombre( ::oDialogView:oGetAlmacenDestino ),;
                                                   .f. ) )

   METHOD validateGrupoMovimiento() INLINE ( iif(  ::validate( "grupo_movimiento" ),;
                                                   ::stampGrupoMovimientoNombre( ::oDialogView:oGetGrupoMovimiento ),;
                                                   .f. ) )

   METHOD validateAgente()          INLINE ( iif(  ::validate( "agente" ),;
                                                   ::stampAgente( ::oDialogView:oGetAgente ),;
                                                   .f. ) )

   METHOD setFileName( cFileName )  INLINE ( ::cFileName := cFileName )
   METHOD getFileName()             INLINE ( ::cFileName )

   METHOD stampNumero()

   METHOD checkSerie( oGetNumero )

   METHOD stampAlmacenNombre()

   METHOD stampGrupoMovimientoNombre()

   METHOD stampAgente()

   METHOD printDocument()  

   METHOD labelDocument()

   METHOD setConfig()              

   METHOD deleteLines()

   METHOD getBrowse()               INLINE ( ::oBrowseView:getBrowse() )

   METHOD loadedBlankBuffer()

   METHOD printSerialDocument()     INLINE ( ::oImprimirSeriesController:Activate() )       

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

   ::cTitle                      := "Movimientos de almacén"

   ::cName                       := "movimientos_almacen"

   ::cDirectory                  := cPatDocuments( "Movimientos almacen" ) 

   ::hImage                      := {  "16"  => "gc_pencil_package_16",;
                                       "48"  => "gc_package_48",;
                                       "64"  => "gc_package_64" }

   ::nLevel                      := nLevelUsr( "01050" )

   ::lTransactional              := .t.

   ::lDocuments                  := .t.

   ::lLabels                     := .t.

   ::lCounter                    := .t.

   ::oModel                      := SQLMovimientosAlmacenModel():New( self )

   ::oBrowseView                 := MovimientosAlmacenBrowseView():New( self )

   ::oDialogView                 := MovimientosAlmacenView():New( self )

   ::oValidator                  := MovimientosAlmacenValidator():New( self )

   ::oLineasController           := MovimientosAlmacenLineasController():New( self )

   ::oImportadorController       := ImportadorMovimientosAlmacenLineasController():New( self )

   ::oCapturadorController       := CapturadorMovimientosAlmacenLineasController():New( self )

   ::oImprimirSeriesController   := ImprimirSeriesController():New( self )

   ::oEtiquetasController        := EtiquetasMovimientosAlmacenController():New( self )

   ::oConfiguracionesController  := ConfiguracionesController():New( self )
   
   ::loadDocuments()

   ::oReport                     := MovimientosAlmacenReport():New( Self )

   ::oModel:setEvent( 'loadedBlankBuffer',      {|| ::loadedBlankBuffer() } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',  {|| ::loadedBlankBuffer() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oLineasController:End()

   ::oCapturadorController:End()

   ::oImportadorController:End()

   ::oEtiquetasController:End()

   ::oConfiguracionesController:End()

   ::oReport:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
   
METHOD validateNumero()

   if !::validate( "numero" )
      RETURN ( .f. )
   end if 
      
   ::stampNumero( ::oDialogView:oGetNumero )
      
RETURN ( ::checkSerie( ::oDialogView:oGetNumero ) )

//---------------------------------------------------------------------------//

METHOD stampNumero( oGetNumero )

   local nAt
   local cSerie   := ""
   local nNumero
   local cNumero  := alltrim( oGetNumero:varGet() )

   nAt            := rat( "/", cNumero )
   if nAt == 0
      cNumero     := padr( rjust( cNumero, "0", 6 ), 50 )
   else 
      cSerie      := upper( substr( cNumero, 1, nAt - 1 ) )
      nNumero     := substr( cNumero, nAt + 1 )
      cNumero     := padr( cSerie + "/" + rjust( nNumero, "0", 6 ), 50 )
   end if 
      
   oGetNumero:cText( cNumero )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD checkSerie( oGetNumero )

   local nAt
   local cSerie
   local cNumero  := alltrim( oGetNumero:varGet() )

   nAt            := rat( "/", cNumero )
   if nAt == 0
      RETURN ( .t. )
   end if 

   cSerie         := upper( substr( cNumero, 1, nAt - 1 ) )

   if SQLConfiguracionesModel():isSerie( ::cName, cSerie )
      RETURN ( .t. )
   end if

   if msgYesNo( "La serie " + cSerie + ", no existe.", "¿ Desea crear una nueva serie ?" )
      SQLConfiguracionesModel():setSerie( ::cName, cSerie ) 
   else 
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampAlmacenNombre( oGetAlmacen )

   local cCodigoAlmacen    := oGetAlmacen:varGet()
   local cNombreAlmacen    := AlmacenesModel():getNombre( cCodigoAlmacen )

   oGetAlmacen:oHelpText:cText( cNombreAlmacen )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampGrupoMovimientoNombre( oGetGrupoMovimiento )

   local cCodigoGrupo      := oGetGrupoMovimiento:varGet()
   local cNombreGrupo      := GruposMovimientosModel():getNombre( cCodigoGrupo )

   oGetGrupoMovimiento:oHelpText:cText( cNombreGrupo )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampAgente( oGetAgente )

   local cCodigoAgente     := oGetAgente:varGet()
   local cNombreAgente     := AgentesModel():getNombre( cCodigoAgente )

   oGetAgente:oHelpText:cText( cNombreAgente )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD deleteLines()

   aeval( ::getRowSet():IdFromRecno( ::aSelected, "uuid" ), {| uuid | ::oLineasController:deleteLines( uuid ) } )

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD printDocument( nDevice, cFileName )

   DEFAULT nDevice   := IS_SCREEN

   if empty( ::aDocuments )
      msgStop( "No hay formatos para impresión" )
      RETURN ( self )  
   end if 

   if empty( cFileName )
      cFileName      := ::aDocuments[ 1 ]
   end if 

   if empty( cFileName )
      msgStop( "No hay formatos por defecto" )
      RETURN ( self )  
   end if 

   ::oImprimirSeriesController:showDocument( nDevice, cFileName )

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD labelDocument()

  ::oEtiquetasController:Activate()

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD setConfig()

   ::oConfiguracionesController:Edit()

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer()

   hset( ::oModel:hBuffer, "numero", MovimientosAlmacenRepository():getLastNumber() )

RETURN ( self ) 

//---------------------------------------------------------------------------//

