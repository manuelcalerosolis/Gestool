#include "Fivewin.ch"
#include "Factu.ch" 
#include "Fastreph.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenController FROM SQLNavigatorController

   DATA oLineasController

   DATA oImportadorController

   DATA oCapturadorController

   DATA oEtiquetasController

   METHOD New()
   METHOD End()

   METHOD getUuid()                 INLINE ( iif( !empty( ::oModel ) .and. !empty( ::oModel:hBuffer ),;
                                                   hget( ::oModel:hBuffer, "uuid" ),;
                                                   nil ) )

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

   METHOD deleteLines()

   METHOD getBrowse()               INLINE ( ::oBrowseView:getBrowse() )

   // METHOD addColumns( oSQLBrowse )

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

   ::oModel                   := SQLMovimientosAlmacenModel():New( self )

   ::oBrowseView              := MovimientosAlmacenBrowseView():New( self )

   ::oDialogView              := MovimientosAlmacenView():New( self )

   ::oValidator               := MovimientosAlmacenValidator():New( self )

   ::oLineasController        := MovimientosAlmacenLineasController():New( self )

   ::hDocuments               := DocumentosModel():getWhereMovimientosAlmacen() 

   ::oImportadorController    := ImportadorMovimientosAlmacenLineasController():New( self )

   ::oCapturadorController    := CapturadorMovimientosAlmacenLineasController():New( self )

   ::oEtiquetasController     := EtiquetasMovimientosAlmacenController():New( self )

   ::oFilterController:setTableName( ::cTitle ) 

   ::setEvent( 'deletingSelection', {|| ::deleteLines() } )

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

   local aUuids   := ::oModel:convertRecnoToId( ::aSelected, "uuid" )

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

   ::oEtiquetasController:setId( ::getRowSet():fieldget( 'id' ) )

   ::oEtiquetasController:Activate()

RETURN ( self ) 

//---------------------------------------------------------------------------//
