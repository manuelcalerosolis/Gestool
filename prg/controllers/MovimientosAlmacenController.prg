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

   METHOD addPrintButtons()   

   METHOD stampAlmacenNombre()

   METHOD stampGrupoMovimientoNombre()

   METHOD stampAgente()

   METHOD printMovimientosAlmacen() INLINE ( msgalert( "¯\_(¨)_/¯" ) ) 

   METHOD deleteLines()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                   := "Movimientos de almacén"

   ::cImage                   := "gc_pencil_package_16"

   ::nLevel                   := nLevelUsr( "01050" )

   ::lTransactional           := .t.

   ::oModel                   := SQLMovimientosAlmacenModel():New( self )

   ::oDialogView              := MovimientosAlmacenView():New( self )

   ::oValidator               := MovimientosAlmacenValidator():New( self )

   ::oLineasController        := MovimientosAlmacenLineasController():New( self )

   ::oImportadorController    := ImportadorMovimientosAlmacenLineasController():New( self )

   ::Super:New()

   ::setEvent( 'openingDialog',     {|| ::oLineasController:oModel:buildRowSet() } ) 
   ::setEvent( 'closedDialog',      {|| ::oLineasController:oModel:freeRowSet() } ) 

   ::setEvent( 'deletingSelection', {|| ::deleteLines() } )

   ::oNavigatorView:oMenuTreeView:setEvent( 'addedGeneralButton', {|| ::addPrintButtons() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD addPrintButtons()

   local cWorkArea
   local oButtonPrint
   local oButtonLabel
   local oButtonPreview

   cWorkArea               := DocumentosModel():getWhereMovimientosAlmacen()

   oButtonPrint            := ::oNavigatorView:oMenuTreeView:AddButton( "Imprimir", "Imp16", {|| ::printMovimientosAlmacen() }, "I", ACC_IMPR )
   ( cWorkArea )->( dbeval( {|| ::oNavigatorView:oMenuTreeView:AddButton( alltrim( ( cWorkArea )->cDescrip ), "Imp16", {|| ::printMovimientosAlmacen() }, , ACC_IMPR, oButtonPrint ) } ) )

   oButtonPreview          := ::oNavigatorView:oMenuTreeView:AddButton( "Previsualizar", "Prev116", {|| ::printMovimientosAlmacen() }, "P", ACC_IMPR ) 

   ( cWorkArea )->( dbeval( {|| ::oNavigatorView:oMenuTreeView:AddButton( alltrim( ( cWorkArea )->cDescrip ), "Prev116", {|| ::printMovimientosAlmacen() }, , ACC_IMPR, oButtonPreview ) } ) )

   ::oNavigatorView:oMenuTreeView:AddButton( "Etiquetas", "gc_portable_barcode_scanner_16", {|| ::printMovimientosAlmacen() }, "Q", ACC_IMPR ) 

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













//ALTER TABLE movimientos_almacen DROP COLUMN numero;