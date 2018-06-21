#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch"

//------------------------------------------------------------------------//

CLASS SQLBrowseView

   DATA oModel

   DATA oBrowse

   DATA oController

   DATA lFooter                              INIT .f.
   
   DATA lFastEdit                            INIT .f.
   
   DATA lMultiSelect                         INIT .t.

   DATA nMarqueeStyle                        INIT MARQSTYLE_HIGHLROWRC

   DATA nColSel                              INIT 1

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
   METHOD getSaveState()                     INLINE ( ::oBrowse:SaveState() )
   METHOD setSaveState( cState )             INLINE ( ::oBrowse:restoreState( cState ) )

   METHOD getColumnByHeader( cHeader )       INLINE ( ::oBrowse:getColumnByHeader( cHeader ) )
   METHOD getColumnOrder( cSortOrder )       INLINE ( ::oBrowse:getColumnOrder( cSortOrder ) )
   METHOD getColumnOrderHeader( cSortOrder ) INLINE ( ::oBrowse:getColumnOrderHeader( cSortOrder ) )

   METHOD setColumnOrder( cSortOrder, cColumnOrientation ) ;
                                             INLINE ( ::oBrowse:setColumnOrder( cSortOrder, cColumnOrientation ) )
   METHOD setFirstColumnOrder()              INLINE ( ::oBrowse:setFirstColumnOrder() )

   METHOD getColumnHeaderByOrder( cSortOrder )  
   METHOD getColumnOrderByHeader( cHeader )  INLINE ( ::oBrowse:getColumnOrderByHeader( cHeader ) )

   METHOD getColumnSortOrder()               INLINE ( ::oBrowse:getColumnSortOrder() )
   METHOD getColumnSortOrientation()         INLINE ( ::oBrowse:getColumnSortOrientation() )

   METHOD selectColumnOrder( oCol )          INLINE ( ::oBrowse:selectColumnOrder( oCol ) )
   METHOD refreshCurrent()                   INLINE ( ::oBrowse:refreshCurrent() )

   METHOD createFromCode()                   INLINE ( ::oBrowse:CreateFromCode() )
   METHOD createFromResource( id )           INLINE ( ::oBrowse:CreateFromResource( id ) )

   METHOD setLDblClick( bLDblClick )         INLINE ( ::oBrowse:bLDblClick    := bLDblClick )
   METHOD setLDClickDatas( bLDClickDatas )   INLINE ( ::oBrowse:bLDClickDatas := bLDClickDatas )

   METHOD Refresh()                          INLINE ( if( !empty( ::oBrowse ), ( ::oBrowse:makeTotals(), ::oBrowse:Refresh() ), ) )
   METHOD goTop()                            INLINE ( if( !empty( ::oBrowse ), ::oBrowse:goTop(), ) )

   METHOD setViewTypeToNavigator()           INLINE ( ::oBrowse:setViewType( "navigator" ) )
   METHOD setViewTypeToSelector()            INLINE ( ::oBrowse:setViewType( "selector" ) )
   METHOD getViewType()                      INLINE ( ::oBrowse:getViewType() )

   METHOD setFocus()                         INLINE ( ::oBrowse:setFocus() )

   METHOD selectCol( nCol, lOffset )         INLINE ( ::oBrowse:selectCol( nCol, lOffset ) )

   // Controller---------------------------------------------------------------

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

   METHOD restoreState()                     
   METHOD setState( cBrowseState )

   METHOD setId( nId )
  
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController              := oController

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
   ::oBrowse:nColSel          := ::nColSel

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

METHOD setId( nId )

   if empty( nId )
      RETURN ( Self )
   end if 

   ::getRowSet():findId( nId )

   ::oBrowse:SelectCurrent()

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

METHOD restoreState()

   ::oBrowse:getOriginalState()

   if !empty( ::oController )
      ::oController:restoreState()
   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD setState( cBrowseState )

   ::oBrowse:getOriginalState()

   if !empty( cBrowseState )
      ::oBrowse:restoreState( cBrowseState )
   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

