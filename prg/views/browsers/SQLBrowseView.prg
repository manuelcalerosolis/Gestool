#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch"

//------------------------------------------------------------------------//

CLASS SQLBrowseView

   DATA oModel

   DATA oBrowse

   DATA oController

   DATA nId

   DATA cColumnOrder

   DATA cColumnOrientation

   DATA lFooter                              INIT .f.
   
   DATA lFastEdit                            INIT .f.
   
   DATA lMultiSelect                         INIT .t.

   DATA nMarqueeStyle                        INIT MARQSTYLE_HIGHLROWRC

   DATA lRestoreState                        INIT .t.

   METHOD New( oController )
   METHOD End()

   METHOD Create()

   METHOD ActivateDialog()
   METHOD ActivateMDI()
   
   METHOD setSize( nTop, nLeft, nRight, nBottom ) 

   METHOD setFooter( lFooter )               INLINE ( ::lFooter := lFooter )

   // Facades------------------------------------------------------------------

   METHOD getBrowse()                        INLINE ( ::oBrowse )
   METHOD getBrowseSelected()                INLINE ( ::oBrowse:aSelected )

   METHOD restoreStateFromModel()   
   METHOD saveStateToModel()         

   METHOD getColumnByHeader( cHeader )       INLINE ( ::oBrowse:getColumnByHeader( cHeader ) )
   METHOD getColumnOrder( cSortOrder )       INLINE ( ::oBrowse:getColumnOrder( cSortOrder ) )
   METHOD getColumnOrderHeader( cSortOrder ) INLINE ( ::oBrowse:getColumnOrderHeader( cSortOrder ) )

   METHOD setColumnOrder( cSortOrder )

   METHOD getColumnHeaderByOrder( cSortOrder )  
   METHOD getColumnOrderByHeader( cHeader )  INLINE ( ::oBrowse:getColumnOrderByHeader( cHeader ) )

   METHOD selectColumnOrder( oCol )          INLINE ( ::oBrowse:selectColumnOrder( oCol ) )
   METHOD refreshCurrent()                   INLINE ( ::oBrowse:refreshCurrent() )

   METHOD createFromCode()                   INLINE ( ::oBrowse:CreateFromCode() )
   METHOD createFromResource( id )           INLINE ( ::oBrowse:CreateFromResource( id ) )

   METHOD setLDblClick( bLDblClick )         INLINE ( ::oBrowse:bLDblClick := bLDblClick )
   METHOD setLDClickDatas( bLDClickDatas )   INLINE ( ::oBrowse:bLDClickDatas := bLDClickDatas )

   METHOD Refresh()                          INLINE ( ::oBrowse:makeTotals(), ::oBrowse:Refresh() )
   METHOD goTop()                            INLINE ( ::oBrowse:goTop() )

   METHOD setViewTypeToNavigator()           INLINE ( ::oBrowse:setViewType( "navigator" ) )
   METHOD setViewTypeToSelector()            INLINE ( ::oBrowse:setViewType( "selector" ) )
   METHOD getViewType()                      INLINE ( ::oBrowse:getViewType() )

   METHOD setController( oController )       INLINE ( ::oController := oController )
   METHOD getController()                    INLINE ( ::oController )

   METHOD getSenderController()              INLINE ( ::oController:oSenderController )

   METHOD isNotSenderControllerZoomMode()    INLINE ( empty( ::getSenderController() ) .or. ::getSenderController():isNotZoomMode() )
   
   METHOD getName()                          INLINE ( ::getController():getName() )

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

   METHOD getSelectedCol()                   INLINE ( if( !empty( ::oBrowse ), ::oBrowse:SelectedCol(), nil ) )

   // Events---------------------------------------------------------------------

   METHOD onKeyChar( nKey )

   METHOD onClickHeader( oColumn )          

   // State--------------------------------------------------------------------

   METHOD saveToModel()

   METHOD saveIdToModel( nId )
   METHOD getIdFromModel()

   METHOD gotoIdFromModel()
   
   METHOD saveColumnOrderToModel()
   METHOD getColumnOrderFromModel()

   METHOD saveColumnOrientationToModel()
   METHOD getColumnOrientationFromModel()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController              := oController

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD saveToModel()

   ::saveIdToModel()

   ::saveColumnOrderToModel()

   ::saveColumnOrientationToModel()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   CursorWait()

   if !empty( ::oBrowse )
      ::oBrowse:End()
   end if 

   Self                       := nil

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

   // Propiedades del control--------------------------------------------------

   ::oBrowse:nMarqueeStyle    := ::nMarqueeStyle

   ::oBrowse:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 221, 221, 221 ) } }

   ::oBrowse:bRClicked        := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }

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

   if hb_isarray( ::oBrowse:aCols )
      for each oCol in ::oBrowse:aCols 
         if !( oCol:lHide ) .and. !empty( oCol:cHeader )
            RETURN ( oCol:cHeader )
         end if 
      next
   end if 

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

   ::CreateFromResource( nId )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ActivateMDI( oWindow, nTop, nLeft, nRight, nBottom )

   ::Create( oWindow )

   ::setViewTypeToNavigator()

   ::setSize( nTop, nLeft, nRight, nBottom )

   ::insertSelectedColumn()

   ::addColumns()

   ::CreateFromCode()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD setSize( nTop, nLeft, nRight, nBottom ) 

   ::oBrowse:nStyle     := nOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP )

   ::oBrowse:nTop       := nTop 
   ::oBrowse:nLeft      := nLeft 
   ::oBrowse:nRight     := nRight 
   ::oBrowse:nBottom    := nBottom 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD insertSelectedColumn()

   if !( ::oBrowse:lMultiSelect )
      RETURN ( self )
   end if 

   with object (::oBrowse:InsCol( 1 ) )
      :Cargo         := .t.
      :bEditValue    := { || ascan( ::oBrowse:aSelected, ::oBrowse:BookMark ) > 0 }
      :nHeadBmpNo    := { || if( len( ::oBrowse:aSelected ) == ::oBrowse:nLen, 1, 2 ) }
      :setCheck()
   end with

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD saveIdToModel()

   local nId   

   if empty( ::getRowSet() )
      RETURN ( self )
   end if 

   if empty( ::getModel() )
      RETURN ( self )
   end if 

   nId               := ::getRowSet():fieldGet( ::getModel():cColumnKey )

   if !empty( nId )
      ::oController:setIdView( ::getViewType(), ::getName(), nId )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getIdFromModel()

RETURN ( ::oController:getIdView( ::getViewType(), ::getName() ) )

//---------------------------------------------------------------------------//

METHOD gotoIdFromModel()

   local nId         := ::getIdFromModel()

   if empty( nId )
      RETURN ( Self )
   end if 

   ::getRowSet():findId( nId )

   ::oBrowse:SelectCurrent()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD saveColumnOrderToModel()

   local cColumnOrder   

   if empty( ::oBrowse )
      RETURN ( Self )
   end if 

   aeval( ::oBrowse:aCols, {|o| if( !empty( o:cOrder ), cColumnOrder := o:cSortOrder, ) } )

   if !empty( cColumnOrder )
      ::oController:setColumnOrderView( ::getViewType(), ::getName(), cColumnOrder )
   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD getColumnOrderFromModel()

   local cColumnOrder

   cColumnOrder   := ::oController:getColumnOrderView( ::getViewType(), ::getName() )

RETURN ( cColumnOrder )

//------------------------------------------------------------------------//

METHOD saveColumnOrientationToModel()

   local cColumnOrientation

   if empty( ::oBrowse )
      RETURN ( Self )
   end if 

   aeval( ::oBrowse:aCols, {|o| if( !empty( o:cOrder ), cColumnOrientation := o:cOrder, ) } )

   if !empty( cColumnOrientation )
      ::oController:setColumnOrientationView( ::getViewType(), ::getName(), cColumnOrientation )
   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD getColumnOrientationFromModel()

   local cColumnOrientation

   cColumnOrientation   := ::oController:getColumnOrientationView( ::getViewType(), ::getName() )

RETURN ( cColumnOrientation )

//------------------------------------------------------------------------//

METHOD setColumnOrder( cSortOrder, cSortOrientation )

   local oColumn

   DEFAULT cSortOrder         := ::getColumnOrderFromModel()
   DEFAULT cSortOrientation   := ::getColumnOrientationFromModel()

   oColumn                    := ::getColumnOrder( cSortOrder )

   if empty( oColumn )
      RETURN ( Self )
   end if 

   if !empty( cSortOrientation )
      oColumn:cOrder          := cSortOrientation
   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD getColumnHeaderByOrder( cSortOrder )

   local oColumn

   oColumn                    := ::getColumnOrder( cSortOrder )

   if empty( oColumn )
      RETURN ( "" )
   end if 

RETURN ( oColumn:cHeader )

//------------------------------------------------------------------------//

METHOD restoreStateFromModel()

   local cBrowseState

   ::oBrowse:getOriginalState()

   cBrowseState         := ::oController:getStateView( ::getViewType(), ::getName() )

   if !empty( cBrowseState )
      ::oBrowse:restoreState( cBrowseState )
   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD saveStateToModel()

   ::oController:setStateView( ::getViewType(), ::getName(), ::saveState() )

RETURN ( Self )

//----------------------------------------------------------------------------//
