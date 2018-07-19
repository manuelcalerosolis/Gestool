#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch"

//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//

CLASS SQLBrowseView

   DATA oModel

   DATA oBrowse

   DATA oController

   DATA bMenuSelect

   DATA oConfiguracionVistasController

   DATA lFooter                              INIT .f.
   
   DATA lFastEdit                            INIT .f.
   
   DATA lMultiSelect                         INIT .t.

   DATA nMarqueeStyle                        INIT MARQSTYLE_HIGHLROWRC

   DATA nColSel                              INIT 1

   DATA bChange

   DATA cType 

   DATA cName

   METHOD New( oController )
   METHOD End()

   METHOD Create()

   METHOD ActivateDialog()
   METHOD ActivateMDI()
   
   METHOD setSize( nTop, nLeft, nRight, nBottom ) 

   METHOD setFooter( lFooter )               INLINE ( ::lFooter := lFooter )

   // Type and name -----------------------------------------------------------

   METHOD getType()                          INLINE ( if( hb_isnil( ::cType ), "", ::cType ) )
   METHOD setType( cType )                   INLINE ( ::cType := cType )

   METHOD getName()                          INLINE ( if( empty( ::cName ), ::getController():getName(), ::cName ) )
   METHOD setName( cName )                   INLINE ( ::cName := cName )

   // Facades------------------------------------------------------------------

   METHOD getBrowse()                        INLINE ( ::oBrowse )
   METHOD getBrowseSelected()                INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:aSelected, ) )
   METHOD getSaveState()                     INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:SaveState(), ) )
   METHOD setSaveState( cState )             INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:restoreState( cState ), ) )

   METHOD getColumnByHeader( cHeader )       INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnByHeader( cHeader ), ) )
   METHOD getColumnOrder( cSortOrder )       INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnOrder( cSortOrder ), ) )
   METHOD getColumnOrderHeader( cSortOrder ) INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnOrderHeader( cSortOrder ), ) )

   METHOD setColumnOrder( cSortOrder, cColumnOrientation ) ;
                                             INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:setColumnOrder( cSortOrder, cColumnOrientation ), ) )
   METHOD setFirstColumnOrder()              INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:setFirstColumnOrder(), ) )

   METHOD getColumnHeaderByOrder( cSortOrder )  
   METHOD getColumnOrderByHeader( cHeader )  INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnOrderByHeader( cHeader ), ) )

   METHOD getColumnSortOrder()               INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnSortOrder(), ) )
   METHOD getColumnSortOrientation()         INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnSortOrientation(), ) )

   METHOD selectColumnOrder( oCol )          INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:selectColumnOrder( oCol ), ) )
   METHOD refreshCurrent()                   INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:refreshCurrent(), ) )

   METHOD createFromCode()                   INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:CreateFromCode(), ) )
   METHOD createFromResource( id )           INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:CreateFromResource( id ), ) )

   METHOD setLDblClick( bLDblClick )         INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:bLDblClick    := bLDblClick, ) )
   METHOD setLDClickDatas( bLDClickDatas )   INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:bLDClickDatas := bLDClickDatas, ) )

   METHOD Refresh()                          INLINE ( iif( !empty( ::oBrowse ), ( ::oBrowse:makeTotals(), ::oBrowse:Refresh() ), ) )
   METHOD goTop()                            INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:goTop(), ) )

   METHOD setViewTypeToNavigator()           INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:setViewType( "navigator" ), ) )
   METHOD setViewTypeToSelector()            INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:setViewType( "selector" ), ) )
   METHOD getViewType()                      INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getViewType(), ) )

   METHOD setFocus()                         INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:setFocus(), ) )

   METHOD selectCol( nCol, lOffset )         INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:selectCol( nCol, lOffset ), ) )

   METHOD SelectedCol()                      INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:SelectedCol(), ) )

   METHOD hWnd()                             INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:hWnd, ) )

   METHOD oPopup()                           INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:oPopup, ) )

   METHOD getSelectedCol()                   INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:SelectedCol(), nil ) )

   METHOD changeColumnOrder( oCol )          INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:changeColumnOrder( oCol ), nil ) )

   // Controller---------------------------------------------------------------

   METHOD setController( oController )       INLINE ( ::oController := oController )
   METHOD getController()                    INLINE ( ::oController )

   METHOD getSenderController()              INLINE ( ::oController:oSenderController )

   METHOD isNotSenderControllerZoomMode()    INLINE ( empty( ::getSenderController() ) .or. ::getSenderController():isNotZoomMode() )
   
   METHOD getComboBoxOrder()                 INLINE ( if( !empty( ::oController ), ::oController:getComboBoxOrder(), ) )
   METHOD getMenuTreeView()                  INLINE ( if( !empty( ::oController ), ::oController:getMenuTreeView(), ) )

   // Models-------------------------------------------------------------------

   METHOD getModel()                         INLINE ( ::getController():getModel() )

   // RowSet-------------------------------------------------------------------

   METHOD getRowSet()                        INLINE ( ::getController():getRowSet() )

   // Columns------------------------------------------------------------------

   METHOD insertSelectedColumn()

   METHOD addColumns()                       VIRTUAL

   METHOD getColumnsHeaders()

   METHOD getVisibleColumnsHeaders()   

   METHOD getFirstColumnHeader()


   // Events---------------------------------------------------------------------

   METHOD onKeyChar( nKey )

   METHOD onClickHeader( oColumn )          

   METHOD findId( nId )

   // Vistas manege -----------------------------------------------------------

   METHOD restoreState()
   METHOD setState( cState )
   METHOD saveState( cState )

   METHOD setIdView( cType, cName, nId )              

   METHOD getIdView( cType, cName )                       

   METHOD setColumnOrderView( cType, cName, cColumnOrder ) 

   METHOD getColumnOrderView( cType, cName )          

   METHOD setColumnOrientationView( cType, cName, cColumnOrientation ) 
                                                      
   METHOD getColumnOrientationView( cType, cName )    

   METHOD setStateView( cType, cName, cState )        

   METHOD getStateView( cType, cName )        

   // Menus--------------------------------------------------------------------

   METHOD BuildMenu( nRow, nCol, nFlags )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                             := oController

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   CursorWait()

   ::saveState()

   ::oConfiguracionVistasController:End()

   if !empty( ::oBrowse )
      ::oBrowse:End()
   end if 

   Self                                      := nil

   CursorWE()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Create( oWindow ) 

   DEFAULT oWindow            := ::oController:getWindow()

   if empty( ::getRowSet() )
      RETURN ( nil )
   endif

   ::oBrowse                  := SQLXBrowse():New( ::oController, oWindow )
   ::oBrowse:l2007            := .f.

   ::oBrowse:lRecordSelector  := .t.
   ::oBrowse:lAutoSort        := .t.
   ::oBrowse:lSortDescend     := .f.  

   ::oBrowse:lFooter          := ::lFooter
   ::oBrowse:lFastEdit        := ::lFastEdit
   ::oBrowse:lMultiSelect     := ::lMultiSelect
   ::oBrowse:nColSel          := ::nColSel

   // Propiedades del control--------------------------------------------------

   ::oBrowse:nMarqueeStyle    := ::nMarqueeStyle

   ::oBrowse:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 221, 221, 221 ) } }

   ::oBrowse:bRClicked        := {| nRow, nCol, nFlags | ::BuildMenu( nRow, nCol, nFlags ) }

   ::oBrowse:setRowSet( ::getRowSet() )

   ::oBrowse:setName( ::getName() )

   ::oBrowse:bKeyChar         := {|nKey| ::getController():onKeyChar( nKey ) }

   if ::isNotSenderControllerZoomMode() 
      ::setLDblClick( {|| ::getController():Edit(), ::Refresh() } )
   end if 

RETURN ( ::oBrowse )

//---------------------------------------------------------------------------//

METHOD getColumnsHeaders()

   local aHeaders    := {}

   aeval( ::oBrowse:aCols, {|oCol| aadd( aHeaders, oCol:cHeader ) } )

RETURN ( aHeaders )

//---------------------------------------------------------------------------//

METHOD getVisibleColumnsHeaders()

   local aHeaders    := {}

   aeval( ::oBrowse:aCols, {|oCol| if( oCol:lHide, , aadd( aHeaders, oCol:cHeader ) ) } )

RETURN ( aHeaders )

//---------------------------------------------------------------------------//

METHOD getFirstColumnHeader()

   local oCol

   if !hb_isarray( ::oBrowse:aCols )
      RETURN ( "" )
   end if

   for each oCol in ::oBrowse:aCols 
      if !( oCol:lHide ) .and. !empty( oCol:cHeader )
         RETURN ( oCol:cHeader )
      end if 
   next

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD onClickHeader( oColumn ) 

RETURN ( ::getController():onChangeCombo( oColumn ) )

//---------------------------------------------------------------------------//

METHOD onKeyChar( nKey )

RETURN ( heval( ::oController:oMenuTreeView:hFastKey, {|k,v| msgalert( nKey, "nKey" ), if( k == nKey, eval( v ), ) } ) ) 
   
//----------------------------------------------------------------------------//

METHOD ActivateDialog( oDialog, nId )

   ::Create( oDialog )

   ::setViewTypeToSelector()

   ::insertSelectedColumn()

   ::addColumns()

   ::createFromResource( nId )

   ::restoreState()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ActivateMDI( oWindow, nTop, nLeft, nRight, nBottom )

   ::Create( oWindow )

   ::setViewTypeToNavigator()

   ::setSize( nTop, nLeft, nRight, nBottom )

   ::insertSelectedColumn()

   ::addColumns()

   ::createFromCode()

   ::restoreState()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD setSize( nTop, nLeft, nRight, nBottom ) 

   ::oBrowse:nStyle     := nOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP )

   ::oBrowse:nTop       := nTop 
   ::oBrowse:nLeft      := nLeft 
   ::oBrowse:nRight     := nRight 
   ::oBrowse:nBottom    := nBottom 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertSelectedColumn()

   if !( ::oBrowse:lMultiSelect )
      RETURN ( nil )
   end if 

   with object ( ::oBrowse:InsCol( 1 ) )
      :Cargo         := .t.
      :bEditValue    := { || ascan( ::oBrowse:aSelected, ::oBrowse:BookMark ) > 0 }
      :nHeadBmpNo    := { || if( len( ::oBrowse:aSelected ) == ::oBrowse:nLen, 1, 2 ) }
      :bLClickHeader := { || if( len( ::oBrowse:aSelected ) == ::oBrowse:KeyCount(), ( ::oBrowse:SelectNone(), ::oBrowse:Select( 1 ) ), ::oBrowse:SelectAll() ) }
      :setCheck()
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD findId( nId )

   if empty( nId )
      RETURN ( nil )
   end if 

   ::getRowSet():findId( nId )

   ::oBrowse:SelectCurrent()

RETURN ( nil )

//------------------------------------------------------------------------//

METHOD getColumnHeaderByOrder( cSortOrder )

   local oColumn

   oColumn                    := ::getColumnOrder( cSortOrder )

   if empty( oColumn )
      RETURN ( "" )
   end if 

RETURN ( oColumn:cHeader )

//------------------------------------------------------------------------//

METHOD restoreState()

   ::oBrowse:getOriginalState()

   if !empty( ::oController )
      ::oController:restoreState()
   end if 

RETURN ( nil )

//------------------------------------------------------------------------//

METHOD setState( cState )

   ::oBrowse:getOriginalState()

   if !empty( cState )
      ::oBrowse:restoreState( cState )
   end if 

RETURN ( nil )

//------------------------------------------------------------------------//

METHOD BuildMenu( nRow, nCol, nFlags )

   local oCol
   local oMenu
   local bMenuSelect

   oMenu             := MenuBegin( .t., , ::oBrowse )
   bMenuSelect       := ::bMenuSelect

   ::bMenuSelect     := nil

   if !empty( ::oBrowse:SelectedCol():cSortOrder ) .and. hb_isnil( ::oBrowse:SelectedCol():Cargo ) 

   MenuAddItem( "Filtro rápido", "Establecer fitro rápido en columna actual", .f., .t., , , "gc_funnel_add_16", oMenu )

   MenuBegin( .f., , ::oBrowse, .f., .f., , , , , , , , , , , , .f., .t., .f., .t. )

      MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' IN (" + toSqlString( ::SelectedCol():Value() ) + ")", "", .f., .t., {|| ::oController:buildInFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )
      
      MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' NOT IN ('" + toSqlString( ::SelectedCol():Value() ) + "')", "", .f., .t., {|| ::oController:buildNotInFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

      MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' > '" + toSqlString( ::SelectedCol():Value() ) + "'", "", .f., .t., {|| ::oController:buildBiggerFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

      MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' < '" + toSqlString( ::SelectedCol():Value() ) + "'", "", .f., .t., {|| ::oController:buildSmallerFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

      MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' LIKE '" + toSqlString( ::SelectedCol():Value() ) + "%'", "", .f., .t., {|| ::oController:buildStartLikeFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

      MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' LIKE '%" + toSqlString( ::SelectedCol():Value() ) + "'", "", .f., .t., {|| ::oController:buildEndLikeFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

      MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' LIKE '%" + toSqlString( ::SelectedCol():Value() ) + "%'", "", .f., .t., {|| ::oController:buildLikeFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

      MenuAddItem()

      MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' IN (...)", "", .f., .t., {|| ::oController:buildCustomInFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

      MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' NOT IN (...)", "", .f., .t., {|| ::oController:buildCustomNotInFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

      MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' > '", "", .f., .t., {|| ::oController:buildCustomBiggerFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

      MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' < '", "", .f., .t., {|| ::oController:buildCustomSmallerFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )

      MenuAddItem( "'" + ::SelectedCol():cSortOrder + "' LIKE '%...%'", "", .f., .t., {|| ::oController:buildCustomLikeFilter( ::SelectedCol():cSortOrder, ::SelectedCol():Value() ) }, "gc_funnel_add_16" )
      
      MenuAddItem()

      MenuAddItem( "Limpiar filtro", "", .f., .t., {|| ::oController:clearFilter() }, "gc_funnel_broom_16" )

   MenuEnd()

   end if 

   MenuAddItem( "Columnas", "Columnas de la rejilla de datos", .f., .t., , , "gc_table_selection_column_16", oMenu )

      MenuBegin( .f., , , .f., .f., , , , , , , , , , , , .f., .t., .f., .t. )

         for each oCol in ::oBrowse:aCols
            MenuAddItem( oCol:cHeader, , !oCol:lHide, ( len( ::oBrowse:aDisplay ) != 1 .or. oCol:nPos != 1 ), GenMenuBlock( oCol ) )
         next

      MenuEnd()

      MenuAddItem( "Seleccionar &todo", "Selecciona todas las filas de la rejilla", .f., .t., {|| ::SelectAll() }, , "gc_table_selection_all_16", oMenu )

      MenuAddItem( "&Quitar selección", "Quita la selección de todas las filas de la rejilla", .f., .t., {|| ::SelectNone() }, , "gc_table_16", oMenu )

      MenuAddItem()

      MenuAddItem( "Exportar a E&xcel", "Exportar rejilla de datos a Excel", .f., .t., {|| ::ExportToExcel() }, , "gc_spreadsheet_sum_16", oMenu )

      MenuAddItem()

      MenuAddItem( "Guardar vista actual", "Guarda la vista actual de la rejilla de datos", .f., .t., {|| ::SaveState() }, , "gc_table_selection_column_disk_16", oMenu )

      MenuAddItem( "Cargar vista por defecto", "Carga la vista por defecto de la rejilla de datos", .f., .t., {|| ::setOriginalState() }, , "gc_table_selection_column_refresh_16", oMenu )

   MenuEnd() 

   oMenu:Activate( nRow, nCol, ::oBrowse )

   ::bMenuSelect     := bMenuSelect

   oMenu:end()

   ::SetFocus()

RETURN ( nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION GenMenuBlock( oCol )

RETURN {|| iif( oCol:lHide, oCol:Show(), oCol:Hide() ) }

//----------------------------------------------------------------------------//

METHOD saveState()

   CursorWait()

   ::setIdView( ::getType(), ::getName(), ::getRowSet:fieldget( "id" ) )

   ::setColumnOrderView( ::getType(), ::getName(), ::getColumnSortOrder() )

   ::setColumnOrientationView( ::getType(), ::getName(), ::getColumnSortOrientation() )

   ::setStateView( ::getType(), ::getName(), ::getSaveState() ) 

   CursorWE()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD setIdView( cType, cName, nId )              

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::oConfiguracionVistasController )
      RETURN ( nil )
   end if 

RETURN ( ::oConfiguracionVistasController:setId( cType, cName, nId ) )

//----------------------------------------------------------------------------//

METHOD getIdView( cType, cName )

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::oConfiguracionVistasController )
      RETURN ( nil )
   end if 

RETURN ( ::oConfiguracionVistasController:getId( cType, cName ) )

//---------------------------------------------------------------------------//

METHOD setColumnOrderView( cType, cName, cColumnOrder ) 

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::oConfiguracionVistasController )
      RETURN ( nil )
   end if 

RETURN ( ::oConfiguracionVistasController:setColumnOrder( cType, cName, cColumnOrder ) )

//---------------------------------------------------------------------------//

METHOD getColumnOrderView( cType, cName )          
   
   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::oConfiguracionVistasController )
      RETURN ( "" )
   end if 

RETURN ( ::oConfiguracionVistasController:getColumnOrder( cType, cName ) )

//----------------------------------------------------------------------------//

METHOD setColumnOrientationView( cType, cName, cColumnOrientation )

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::oConfiguracionVistasController )
      RETURN ( nil )
   end if 

RETURN ( ::oConfiguracionVistasController:setColumnOrientation( cType, cName, cColumnOrientation ) )

//----------------------------------------------------------------------------//

METHOD getColumnOrientationView( cType, cName ) 

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::oConfiguracionVistasController )
      RETURN ( nil )
   end if 

RETURN ( ::oConfiguracionVistasController:getColumnOrientation( cType, cName ) )

//----------------------------------------------------------------------------//

METHOD setStateView( cType, cName, cState )        

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::oConfiguracionVistasController )
      RETURN ( nil )
   end if 

RETURN ( ::oConfiguracionVistasController:setState( cType, cName, cState ) )

//----------------------------------------------------------------------------//

METHOD getStateView( cType, cName )                

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::oConfiguracionVistasController )
      RETURN ( nil )
   end if 

RETURN ( ::oConfiguracionVistasController:getState( cType, cName ) )

//----------------------------------------------------------------------------//

