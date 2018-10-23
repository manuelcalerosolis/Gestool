#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch"

//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//

CLASS SQLBrowseView

   DATA oBrowse

   DATA oController

   DATA bMenuSelect

   DATA lFooter                              INIT .f.
   
   DATA lFastEdit                            INIT .f.
   
   DATA lMultiSelect                         INIT .t.

   DATA nMarqueeStyle                        INIT MARQSTYLE_HIGHLROWRC

   DATA nColSel                              INIT 1

   DATA bSelectedColumnDblClick

   DATA bChange

   DATA cType 

   DATA cName

   DATA nFreeze                              INIT 0

   DATA oEvents

   METHOD New( oController ) CONSTRUCTOR
   METHOD End()

   METHOD Create()

   METHOD ActivateDialog()
   METHOD ActivateMDI()

   METHOD onDblClick()
   
   METHOD setSize( nTop, nLeft, nRight, nBottom ) 

   METHOD setFooter( lFooter )               INLINE ( ::lFooter := lFooter )

   // Type and name -----------------------------------------------------------

   METHOD getType()                          INLINE ( if( hb_isnil( ::cType ), "", ::cType ) )
   METHOD setType( cType )                   INLINE ( ::cType := cType )

   METHOD getName()                          INLINE ( if( empty( ::cName ), ::getController():getName(), ::cName ) )
   METHOD setName( cName )                   INLINE ( ::cName := cName )

   // Facades------------------------------------------------------------------

   METHOD getController()                    INLINE ( ::oController:getController() )

   METHOD getBrowse()                        INLINE ( ::oBrowse )

   METHOD getState()                         INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:saveState(), ) )
   
   METHOD getBrowseSelected()                INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:aSelected, ) )

   METHOD getColumnByHeader( cHeader )       INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnByHeader( cHeader ), ) )
   
   METHOD getColumnOrder( cSortOrder )       INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnOrder( cSortOrder ), ) )
   METHOD getColumnBySortOrder( cSortOrder ) INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnBySortOrder( cSortOrder ), ) )
   METHOD getHeaderBySortOrder( cSortOrder ) 
   
   METHOD getColumnOrderHeader( cSortOrder ) INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnOrderHeader( cSortOrder ), ) )

   METHOD setColumnOrder( cSortOrder, cColumnOrientation ) ;
                                             INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:setColumnOrder( cSortOrder, cColumnOrientation ), ) )
   
   METHOD setFirstColumnOrder()              INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:setFirstColumnOrder(), ) )

   METHOD getColumnHeaderByOrder( cSortOrder )  
   METHOD getColumnOrderByHeader( cHeader )  INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnOrderByHeader( cHeader ), ) )

   METHOD getColumnSortOrder()               INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnSortOrder(), ) )
   METHOD getColumnSortOrientation()         INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getColumnSortOrientation(), ) )

   METHOD selectColumnOrder( oColumn, cOrientation ) ;
                                             INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:selectColumnOrder( oColumn, cOrientation ), ) )
   
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

   METHOD getSelectedCol()                   INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:SelectedCol(), ) )

   METHOD changeColumnOrder( oCol )          INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:changeColumnOrder( oCol ), ) )

   METHOD setOriginalState()                 INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:setOriginalState(), ) )

   METHOD getFirstVisibleColumn()            INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:getFirstVisibleColumn(), ) )

   METHOD makeTotals( aCols )                INLINE ( iif( !empty( ::oBrowse ), ::oBrowse:makeTotals( aCols ), ) )

   // Controller---------------------------------------------------------------

   METHOD setController( oController )       INLINE ( ::oController := oController )
   METHOD getController()                    INLINE ( ::oController )

   METHOD isNotSenderControllerZoomMode()    INLINE ( empty( ::getController() ) .or. ::getController():isNotZoomMode() )
   
   METHOD getComboBoxOrder()                 INLINE ( iif( !empty( ::getController() ), ::getController():getComboBoxOrder(), ) )
   METHOD getMenuTreeView()                  INLINE ( iif( !empty( ::getController() ), ::getController():getMenuTreeView(), ) )

   // Models-------------------------------------------------------------------

   METHOD getModel()                         INLINE ( ::getController():getModel() )

   // RowSet-------------------------------------------------------------------

   METHOD getRowSet()                        INLINE ( ::getController():getRowSet() )

   // Selected Columns---------------------------------------------------------

   METHOD insertSelectedColumn()

   METHOD setSelectedColumnDblClick( bLDClick ) ;
                                             INLINE ( ::bSelectedColumnDblClick := bLDClick )

   METHOD getSelectedColumnDblClick()        INLINE ( ::bSelectedColumnDblClick )

   // Columns------------------------------------------------------------------

   METHOD addColumns()                       VIRTUAL

   METHOD getColumnsHeaders()

   METHOD getVisibleColumnsHeaders()   

   METHOD getVisibleColumnsSortOrder()

   METHOD getFirstColumnHeader()

   // Events---------------------------------------------------------------------

   METHOD onKeyChar( nKey )

   METHOD onClickHeader( oColumn )          

   METHOD findId( nId )

   // Vistas manege -----------------------------------------------------------

   METHOD setState( cState )

   METHOD restoreState()

   METHOD saveStateView()           

   METHOD setIdView( cType, cName, nId )              

   METHOD getIdView( cType, cName )                       

   METHOD setColumnOrderView( cType, cName, cColumnOrder ) 

   METHOD getColumnOrderView( cType, cName )          

   METHOD setColumnOrientationView( cType, cName, cColumnOrientation ) 
                                                      
   METHOD getColumnOrientationView( cType, cName )    

   METHOD getStateView( cType, cName )        

   METHOD getColumnsCreatedUpdatedAt()

   METHOD getColumnDeletedAt()

   METHOD getColumnIdAndUuid()

   METHOD getStdColors()

   METHOD getSelColors()

   METHOD getSelFocusColors()

   // Menus--------------------------------------------------------------------

   METHOD BuildMenu( nRow, nCol, nFlags )

   // Events-------------------------------------------------------------------

   METHOD setEvent( cEvent, bEvent )         INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )                INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

   ::oEvents               := Events():New()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

   if !empty( ::oBrowse )
      ::oBrowse:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Create( oWindow ) 

   DEFAULT oWindow            := ::oController:getWindow()

   if empty( ::getRowSet() )
      RETURN ( nil )
   endif

   ::fireEvent( 'creating' )

   ::oBrowse                  := SQLXBrowse():New( ::oController, oWindow )
   ::oBrowse:l2007            := .f.

   ::oBrowse:lRecordSelector  := .t.
   ::oBrowse:lAutoSort        := .t.
   ::oBrowse:lSortDescend     := .f.  
   ::oBrowse:lGDIP            := .f.

   ::oBrowse:lFooter          := ::lFooter
   ::oBrowse:lFastEdit        := ::lFastEdit
   ::oBrowse:lMultiSelect     := ::lMultiSelect
   ::oBrowse:nColSel          := ::nColSel
   ::oBrowse:nFreeze          := ::nFreeze

   ::oBrowse:nMarqueeStyle    := ::nMarqueeStyle

   ::oBrowse:setRowSet( ::getRowSet() )
   
   ::oBrowse:bClrStd          := {|| ::getStdColors() }
   ::oBrowse:bClrSel          := {|| ::getSelColors() }
   ::oBrowse:bClrSelFocus     := {|| ::getSelFocusColors() }

   ::oBrowse:bRClicked        := {| nRow, nCol, nFlags | ::BuildMenu( nRow, nCol, nFlags ) }

   ::oBrowse:setName( ::getName() )

   ::oBrowse:bKeyChar         := {|nKey| ::getController():onKeyChar( nKey ) }

   if ::isNotSenderControllerZoomMode() 
      ::setLDblClick( {|| ::onDblClick() } )
   end if 

   ::fireEvent( 'created' )

RETURN ( ::oBrowse )

//---------------------------------------------------------------------------//

METHOD onDblClick()

   if isFalse( ::fireEvent( 'doubleClicking' ) )
      RETURN ( .f. )
   end if

   ::getController():Edit()

   ::Refresh() 

   ::fireEvent( 'doubleClicked' )

RETURN ( .t. )

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

METHOD getVisibleColumnsSortOrder()

   local aSortOrders := {}

   aeval( ::oBrowse:aCols, {|oCol| if( oCol:lHide .or. empty( oCol:cSortOrder ), , aadd( aSortOrders, oCol:cSortOrder ) ) } )

RETURN ( aSortOrders )

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

   ::fireEvent( 'onclickheader' )

   ::getController():onChangeCombo( oColumn )

   ::fireEvent( 'onclickedheader' )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD onKeyChar( nKey )

RETURN ( heval( ::oController:oMenuTreeView:hFastKey, {|k,v| msgalert( nKey, "nKey" ), if( k == nKey, eval( v ), ) } ) ) 
   
//----------------------------------------------------------------------------//

METHOD ActivateDialog( oDialog, nId )

   ::fireEvent( 'activatingDialog' )

   ::Create( oDialog )

   ::setViewTypeToSelector()

   ::insertSelectedColumn()

   ::addColumns()

   ::createFromResource( nId )

   ::restoreState()

   ::fireEvent( 'activatedDialog' )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ActivateMDI( oWindow, nTop, nLeft, nRight, nBottom )

   ::fireEvent( 'activatingMDI' )

   ::Create( oWindow )

   ::setViewTypeToNavigator()

   ::setSize( nTop, nLeft, nRight, nBottom )

   ::insertSelectedColumn()

   ::addColumns()

   ::createFromCode()

   ::restoreState()

   ::fireEvent( 'activatedMDI' )

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
      :nWidth        := 24
      :bLDClickData  := ::getSelectedColumnDblClick()
      :bEditValue    := {|| ascan( ::oBrowse:aSelected, ::oBrowse:BookMark ) > 0 }
      :nHeadBmpNo    := {|| if( len( ::oBrowse:aSelected ) == ::oBrowse:nLen, 1, 2 ) }
      :bLClickHeader := {|| if( len( ::oBrowse:aSelected ) == ::oBrowse:KeyCount(), ( ::oBrowse:SelectNone(), ::oBrowse:Select( 1 ) ), ::oBrowse:SelectAll() ) }
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

METHOD getHeaderBySortOrder( cSortOrder )

   local oColumn

   oColumn                    := ::getColumnBySortOrder( cSortOrder )

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

   if !empty( cState )
      ::oBrowse:restoreState( cState )
   end if 

RETURN ( nil )

//------------------------------------------------------------------------//

METHOD BuildMenu( nRow, nCol, nFlags )

   local oCol
   local oMenu
   local bMenuSelect

   ::fireEvent( 'buildingMenu' )

   oMenu             := MenuBegin( .t., , ::oBrowse, , , , , , , , , , , , , , , , , .t. )
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

      MenuAddItem( "Guardar vista actual", "Guarda la vista actual de la rejilla de datos", .f., .t., {|| ::saveStateView() }, , "gc_table_selection_column_disk_16", oMenu )

      MenuAddItem( "Cargar vista por defecto", "Carga la vista por defecto de la rejilla de datos", .f., .t., {|| ::setOriginalState() }, , "gc_table_selection_column_refresh_16", oMenu )

   MenuEnd() 

   oMenu:Activate( nRow, nCol, ::oBrowse )

   ::bMenuSelect     := bMenuSelect

   oMenu:end()

   ::SetFocus()

   ::fireEvent( 'buildedMenu' )

RETURN ( nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION GenMenuBlock( oCol )

RETURN {|| iif( oCol:lHide, oCol:Show(), oCol:Hide() ) }

//----------------------------------------------------------------------------//

METHOD saveStateView()              

   if empty( ::getController() )
      RETURN ( nil )
   end if 

RETURN ( ::getController():saveState() )

//----------------------------------------------------------------------------//

METHOD setIdView( cType, cName, nId )              

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::getController() )
      RETURN ( nil )
   end if 

RETURN ( ::getController():setId( cType, cName, nId ) )

//----------------------------------------------------------------------------//

METHOD getIdView( cType, cName )

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::getController() )
      RETURN ( nil )
   end if 

RETURN ( ::getController():getId( cType, cName ) )

//---------------------------------------------------------------------------//

METHOD setColumnOrderView( cType, cName, cColumnOrder ) 

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::getController() )
      RETURN ( nil )
   end if 

RETURN ( ::getController():setColumnOrder( cType, cName, cColumnOrder ) )

//---------------------------------------------------------------------------//

METHOD getColumnOrderView( cType, cName )          
   
   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::getController() )
      RETURN ( "" )
   end if 

RETURN ( ::getController():getColumnOrder( cType, cName ) )

//----------------------------------------------------------------------------//

METHOD setColumnOrientationView( cType, cName, cColumnOrientation )

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::getController() )
      RETURN ( nil )
   end if 

RETURN ( ::getController():setColumnOrientation( cType, cName, cColumnOrientation ) )

//----------------------------------------------------------------------------//

METHOD getColumnOrientationView( cType, cName ) 

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::getController() )
      RETURN ( nil )
   end if 

RETURN ( ::getController():getColumnOrientation( cType, cName ) )

//----------------------------------------------------------------------------//

METHOD getStateView( cType, cName )                

   DEFAULT cType  := ::getType()
   DEFAULT cName  := ::getName()

   if empty( ::getController() )
      RETURN ( nil )
   end if 

RETURN ( ::getController():getState( cType, cName ) )

//----------------------------------------------------------------------------//

METHOD getColumnsCreatedUpdatedAt()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'created_at'
      :cHeader             := 'Creado'
      :cEditPicture        := '@DT'
      :nWidth              := 140
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :lHide               := .t.
      :bEditValue          := {|| ::getRowSet():fieldGet( 'created_at' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'updated_at'
      :cHeader             := 'Modificado'
      :cEditPicture        := '@DT'
      :nWidth              := 140
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :lHide               := .t.
      :bEditValue          := {|| ::getRowSet():fieldGet( 'updated_at' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD getColumnDeletedAt()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'deleted_at'
      :cHeader             := 'Borrado'
      :cEditPicture        := '@DT'
      :nWidth              := 140
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :lHide               := .t.
      :bEditValue          := {|| ::getRowSet():fieldGet( 'deleted_at' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

RETURN ( nil )
//----------------------------------------------------------------------------//

METHOD getStdColors()

RETURN ( { CLR_BLACK, if( empty( ::getRowSet():fieldget( 'deleted_at' ) ), CLR_WHITE, rgb( 255, 235, 238 ) ) } )

//----------------------------------------------------------------------------//

METHOD getSelColors()

RETURN ( { CLR_BLACK, if( empty( ::getRowSet():fieldget( 'deleted_at' ) ), Rgb( 229, 229, 229 ), rgb( 255, 235, 238 ) ) } )

//----------------------------------------------------------------------------//

METHOD getSelFocusColors()

RETURN ( { CLR_BLACK, if( empty( ::getRowSet():fieldget( 'deleted_at' ) ), Rgb( 229, 229, 229 ), rgb( 239, 154, 154 ) ) } )

//----------------------------------------------------------------------------//

