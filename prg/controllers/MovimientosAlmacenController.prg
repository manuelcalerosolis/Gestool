#include "Fivewin.ch"
#include "Factu.ch" 
#include "Fastreph.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenController FROM SQLBaseController

   DATA oLineasController

   DATA oImportadorController

   METHOD New()

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

   METHOD deleteLines()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                   := "Movimientos de almacén"

   ::cImage                   := "gc_pencil_package_16"

   ::nLevel                   := nLevelUsr( "01050" )

   ::lTransactional           := .t.

   ::lDocuments               := .t.

   ::hDocuments               := DocumentosModel():getWhereMovimientosAlmacen() 

   ::oModel                   := SQLMovimientosAlmacenModel():New( self )

   ::oDialogView              := MovimientosAlmacenView():New( self )

   ::oValidator               := MovimientosAlmacenValidator():New( self )

   ::oLineasController        := MovimientosAlmacenLineasController():New( self )

   ::oImportadorController    := ImportadorMovimientosAlmacenLineasController():New( self )

   ::Super:New()

   ::setEvent( 'openingDialog',     {|| ::oLineasController:oModel:buildRowSet() } ) 
   ::setEvent( 'closedDialog',      {|| ::oLineasController:oModel:freeRowSet() } ) 

   ::setEvent( 'deletingSelection', {|| ::deleteLines() } )

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














//ALTER TABLE movimientos_almacen DROP COLUMN numero;