#include "Fivewin.ch"
#include "Factu.ch" 
#include "Fastreph.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenController FROM SQLBaseController

   DATA oLineasController

   DATA oImportadorController

   METHOD New()

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

   METHOD DesignReport()

   METHOD DataReport()   

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTitle                   := "Movimientos de almacen"

   ::cImage                   := "gc_document_attachment_16"

   ::nLevel                   := nLevelUsr( "01050" )

   ::lTransactional           := .t.

   ::oModel                   := SQLMovimientosAlmacenModel():New( self )

   ::oDialogView              := MovimientosAlmacenView():New( self )

   ::oValidator               := MovimientosAlmacenValidator():New( self )

   ::oLineasController        := MovimientosAlmacenLineasController():New( self )

   ::oImportadorController    := ImportadorMovimientosAlmacenLineasController():New( self )

   ::Super:New()

   ::setEvent( 'openingDialog',   {|| ::oLineasController:oModel:buildRowSet() } ) 
   ::setEvent( 'closedDialog',    {|| ::oLineasController:oModel:freeRowSet() } ) 

   ::oNavigatorView:oMenuTreeView:setEvent( 'addedGeneralButton', {|| ::addPrintButtons() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD addPrintButtons()

   ::oNavigatorView:oMenuTreeView:AddButton( "Imprimir", "Imp16", {|| ::printMovimientosAlmacen() }, "I", ACC_IMPR )

   ( DocumentosModel():getWhereMovimientosAlmacen() )->( browse() )

   ::oNavigatorView:oMenuTreeView:AddButton( "Previsualizar", "Prev116", {|| ::printMovimientosAlmacen() }, "P", ACC_IMPR ) 

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

METHOD DesignReport( oFr, cReport ) 

   /*
   Zona de datos------------------------------------------------------------
   */

   ::DataReport( oFr )

   /*
   Paginas y bandas---------------------------------------------------------
   */

   if !empty( cReport )

      oFr:LoadFromString( cReport )

   else

      oFr:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )

      oFr:AddPage(         "MainPage" )

      oFr:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
      oFr:SetProperty(     "CabeceraDocumento", "Top", 0 )
      oFr:SetProperty(     "CabeceraDocumento", "Height", 200 )

      oFr:AddBand(         "MasterData",        "MainPage", frxMasterData )
      oFr:SetProperty(     "MasterData",        "Top", 200 )
      oFr:SetProperty(     "MasterData",        "Height", 0 )
      oFr:SetProperty(     "MasterData",        "StartNewPage", .t. )
      oFr:SetObjProperty(  "MasterData",        "DataSet", "Movimientos de almacén" )

      oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
      oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
      oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
      oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de movimientos" )
      oFr:SetProperty(     "DetalleColumnas",   "OnMasterDetail", "DetalleOnMasterDetail" )

      oFr:AddBand(         "PieDocumento",      "MainPage", frxPageFooter )
      oFr:SetProperty(     "PieDocumento",      "Top", 930 )
      oFr:SetProperty(     "PieDocumento",      "Height", 110 )

   end if

   oFr:DesignReport()

   oFr:DestroyFr()

RETURN .T.

//---------------------------------------------------------------------------//

METHOD DataReport( oFr ) 

   oFr:ClearDataSets()

   ::setFastReport( oFr, "Movimientos de almacén" )

/*   
   oFr:SetWorkArea(     "Lineas de movimientos", ::oDetMovimientos:oDbf:nArea )
   oFr:SetFieldAliases( "Lineas de movimientos", cObjectsToReport( ::oDetMovimientos:oDbf ) )

   oFr:SetMasterDetail( "Movimiento",              "Lineas de movimientos",   {|| Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem } )
   oFr:SetMasterDetail( "Lineas de movimientos",   "Artículos",               {|| ::oDetMovimientos:oDbf:cRefMov } )

   if !empty( ::oDetMovimientos )
      oFr:SetResyncPair(   "Movimiento",              "Lineas de movimientos" )
      oFr:SetResyncPair(   "Lineas de movimientos",   "Artículos" )
   end if
*/

RETURN NIL

//---------------------------------------------------------------------------//




