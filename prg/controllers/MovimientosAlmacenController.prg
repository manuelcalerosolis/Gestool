#include "Fivewin.ch"
#include "Factu.ch" 
#include "Fastreph.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenController FROM SQLNavigatorController

   DATA aIds

   DATA cFileName

   DATA oLineasController

   DATA oImportadorController

   DATA oCapturadorController

   DATA oEtiquetasController

   DATA oContadoresController

   DATA oReport

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

   METHOD setFileName( cFileName )  INLINE ( ::cFileName := cFileName )
   METHOD getFileName()             INLINE ( ::cFileName )

   METHOD stampAlmacenNombre()

   METHOD stampGrupoMovimientoNombre()

   METHOD stampAgente()

   METHOD printDocument()  

   METHOD labelDocument()

   METHOD setCounter()              

   METHOD deleteLines()

   METHOD getBrowse()               INLINE ( ::oBrowseView:getBrowse() )

   METHOD insertingBuffer()

   METHOD getIds()                  INLINE ( ::aIds )
   METHOD setIds( aIds )            INLINE ( ::aIds := aIds )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

   ::cTitle                   := "Movimientos de almacén"

   ::hImage                   := {  "16"  => "gc_pencil_package_16",;
                                    "48"  => "gc_package_48",;
                                    "64"  => "gc_package_64" }

   ::nLevel                   := nLevelUsr( "01050" )

   ::cDirectory               := cPatDocuments( "Movimientos almacen" ) 

   ::lTransactional           := .t.

   ::lDocuments               := .t.

   ::lLabels                  := .t.

   ::lCounter                 := .t.

   ::oModel                   := SQLMovimientosAlmacenModel():New( self )

   ::oBrowseView              := MovimientosAlmacenBrowseView():New( self )

   ::oDialogView              := MovimientosAlmacenView():New( self )

   ::oValidator               := MovimientosAlmacenValidator():New( self )

   ::oLineasController        := MovimientosAlmacenLineasController():New( self )

   ::loadDocuments()

   ::oImportadorController    := ImportadorMovimientosAlmacenLineasController():New( self )

   ::oCapturadorController    := CapturadorMovimientosAlmacenLineasController():New( self )

   ::oEtiquetasController     := EtiquetasMovimientosAlmacenController():New( self )

   ::oContadoresController    := ContadoresController():New( self )

   ::oReport                  := MovimientosAlmacenReport():New( Self )

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

   ::oReport:End()

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

   aUuids         := ::getRowSet():IdFromRecno( ::aSelected, "uuid" )

   aeval( aUuids, {| uuid | ::oLineasController:deleteLines( uuid ) } )

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD printDocument( nDevice, cFileName )

   local nCopies

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

   ::setFileName( cFileName )
   
   nCopies           := ContadoresModel():getCopiasMovimientosAlmacen()

   if empty( nCopies )
      nCopies        := 1
   end if 

   ::oReport:setIds( ::oRowSet:fieldGet( ::getModelColumnKey() ) )

   ::oReport:createFastReport()

   ::oReport:setDevice( nDevice )
   
   ::oReport:setCopies( nCopies )
   
   ::oReport:setDirectory( ::getDirectory() )

   ::oReport:setFileName( ::getFileName() )

   ::oReport:buildRowSet()

   ::oReport:setUserDataSet()

   if ::oReport:isLoad()

      ::oReport:show()

   end if 
   
   ::oReport:DestroyFastReport()

   ::oReport:freeRowSet()

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD labelDocument()

   ::setIds( ::oBrowseView:getRowSet():idFromRecno( ::oBrowseView:oBrowse:aSelected ) )

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

