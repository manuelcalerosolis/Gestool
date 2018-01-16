#include "Fivewin.ch"
#include "Factu.ch" 
#include "Fastreph.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenController FROM SQLNavigatorController

   DATA oLineasController

   DATA oImportadorController

   DATA oCapturadorController

   DATA oEtiquetasController

   DATA oContadoresController

   METHOD New()
   METHOD End()

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

   METHOD stampAlmacenNombre()

   METHOD stampGrupoMovimientoNombre()

   METHOD stampAgente()

   METHOD printDocument()  

   METHOD labelDocument()

   METHOD setCounter()              

   METHOD deleteLines()

   METHOD getBrowse()               INLINE ( ::oBrowseView:getBrowse() )

   METHOD insertingBuffer()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

   ::cTitle                   := "Movimientos de almacén"

   ::hImage                   := {  "16"  => "gc_pencil_package_16",;
                                    "48"  => "gc_package_48",;
                                    "64"  => "gc_package_64" }

   ::nLevel                   := nLevelUsr( "01050" )

   ::lTransactional           := .t.

   ::lDocuments               := .t.

   ::lLabels                  := .t.

   ::lCounter                 := .t.

   ::oModel                   := SQLMovimientosAlmacenModel():New( self )

   ::oBrowseView              := MovimientosAlmacenBrowseView():New( self )

   ::oDialogView              := MovimientosAlmacenView():New( self )

   ::oValidator               := MovimientosAlmacenValidator():New( self )

   ::oLineasController        := MovimientosAlmacenLineasController():New( self )

   ::hDocuments               := DocumentosModel():getWhereMovimientosAlmacen() 

   ::oImportadorController    := ImportadorMovimientosAlmacenLineasController():New( self )

   ::oCapturadorController    := CapturadorMovimientosAlmacenLineasController():New( self )

   ::oEtiquetasController     := EtiquetasMovimientosAlmacenController():New( self )

   ::oContadoresController    := ContadoresController():New( self )

   ::oContadoresController:setTabla( 'movimientos_almacen' )

   ::oFilterController:setTableName( ::cTitle ) 

   ::oModel:setEvent( 'insertingBuffer', {|| ::insertingBuffer() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD end()

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oLineasController:End()

   ::oCapturadorController:End()

   ::oImportadorController:End()

   ::oEtiquetasController:End()

   ::oContadoresController:End()

RETURN ( Self )

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

   local aUuids   

   msgalert( hb_valtoexp( ::aSelected ), "aSelected" )

   aUuids         := ::getRowSet():IdFromRecno( ::aSelected, "uuid" )

   msgalert( hb_valtoexp( aUuids ), "aUuids" )

   aeval( aUuids, {| uuid | ::oLineasController:deleteLines( uuid ) } )

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD printDocument( nDevice, cFormato )

   local cReport
   local nCopies
   local oMovimientosAlmacenReport  

   DEFAULT nDevice                  := IS_SCREEN

   nCopies                          := ContadoresModel():getCopiasMovimientosAlmacen()

   if empty( cFormato )
      cFormato                      := ContadoresModel():getFormatoMovimientosAlmacen()
   end if 

   if empty( cFormato )
      msgStop( "No hay formatos por defecto" )
      RETURN ( self )  
   end if 

   cReport                          := DocumentosModel():getReportWhereCodigo( cFormato )              

   if empty( cReport )
      msgStop( "El formato esta vacio" )
      RETURN ( self )  
   end if 

   oMovimientosAlmacenReport        := MovimientosAlmacenReport():New( Self )

   oMovimientosAlmacenReport:setId( ::getRowSet():fieldget( 'id' ) )
   oMovimientosAlmacenReport:setDevice( nDevice )
   oMovimientosAlmacenReport:setCopies( nCopies )
   oMovimientosAlmacenReport:setReport( cReport )

   oMovimientosAlmacenReport:Print()

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD labelDocument()

   local aIds

   aIds              := ::oBrowseView:getRowSet():idFromRecno( ::oBrowseView:oBrowse:aSelected )

   msgalert( hb_valtoexp( aIds ), "aIds" )

   ::oEtiquetasController:setIds( aIds )

   ::oEtiquetasController:Activate()

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD setCounter()

   ::oContadoresController:Edit()

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD insertingBuffer()

   hset( ::oModel:hBuffer, "numero", ContadoresRepository():getAndIncMovimientoAlmacen() )

RETURN ( self ) 

//---------------------------------------------------------------------------//
