#include "FiveWin.Ch"
#include "Factu.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      1
#define dfnSplitterHeight     76
#define dfnBackColorTop       rgb( 255, 255, 255 )
#define dfnTextColorTop       rgb( 0, 0, 0 )

//------------------------------------------------------------------------//

CLASS SQLNavigatorView FROM SQLBrowseableView

   DATA aRect

   DATA oMdiChild

   DATA oTopWebBar

   DATA oVerticalSplitter
   DATA oHorizontalSplitter
   
   DATA oWindowsBar

   METHOD New( oController )

   METHOD End()

   METHOD Activate()

   // Facades------------------------------------------------------------------

   METHOD getComboBoxOrder()              INLINE ( ::oWindowsBar:oComboBox() )
   METHOD getGetSearch()                  INLINE ( ::oWindowsBar:oGet() )

   METHOD getWindow()                     INLINE ( ::oMdiChild )

   // MDI child----------------------------------------------------------------

   METHOD CreateMDIChild()                INLINE ( ::oMdiChild := TMdiChild():New(  ::aRect[ 1 ], ::aRect[ 2 ], ::aRect[ 3 ], ::aRect[ 4 ], /*cTitle*/, /*nStyle*/, /*oMenu*/, oWnd(),;
                                                                                    /*oIcon*/, /*lVScroll*/, /*nClrText*/, /*nClrBack*/, /*oCursor*/, /*oBrush*/, /*lPixel*/ .t.,;
                                                                                    /*lHScroll*/, /*nHelpId*/, /*cBorder*/ "NONE", /*lSysMenu*/, /*lCaption*/ .f., /*lMin*/, /*lMax*/, /*nMenuInfo*/ ) )

   METHOD ActivateMDIChild()              INLINE ( ::oMdiChild:Activate(   /*cShow*/, /*bLClicked*/, /*bRClicked*/, /*bMoved*/, /*bResized*/, /*bPainted*/,;
                                                                           /*bKeyDown*/, /*bInit*/, /*bUp*/, /*bDown*/, /*bPgUp*/, /*bPgDn*/,;
                                                                           /*bLeft*/, /*bRight*/, /*bPgLeft*/, /*bPgRight*/, /*bValid*/ ) ) 

   METHOD keyDown( nKey )

   // Top webbar---------------------------------------------------------------

   METHOD CreateTopWebBar()

   // Splitters----------------------------------------------------------------

   METHOD CreateSplitters()

   // Aplication windows bar---------------------------------------------------

   METHOD EnableWindowsBar()

   METHOD DisableWindowsBar()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

   ::aRect                 := GetWndRect( GetDeskTopWindow() )

   ::oMenuTreeView         := MenuTreeView():New( Self )

   ::oSQLBrowseView        := SQLBrowseViewMDI():New( Self )

   ::oWindowsBar           := oWndBar()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   ::CreateMDIChild()

   ::CreateTopWebBar()

   // Tree menu ---------------------------------------------------------------

   ::oMenuTreeView:ActivateMDI( dfnTreeViewWidth, ::aRect[ 3 ] - dfnSplitterHeight )

   ::oMenuTreeView:AddAutoButtons()

   // Browse view -------------------------------------------------------------

   ::oSQLBrowseView:Activate( dfnSplitterHeight + dfnSplitterWidth, dfnTreeViewWidth + dfnSplitterWidth, ::oMdiChild:nRight - ::oMdiChild:nLeft, ::oMdiChild:nBottom - ::oMdiChild:nTop - dfnSplitterHeight - 162 )

   ::oSQLBrowseView:setView()

   // Splitters----------------------------------------------------------------

   ::CreateSplitters()

   ::ActivateMDIChild()

   // Eventos------------------------------------------------------------------

   ::oMdiChild:bKeyDown          := {|nKey, nFlags| ::keyDown( nKey, nFlags ) }

   ::getComboBoxOrder():bChange  := {|| ::onChangeCombo() } 

   ::getGetSearch():bChange      := {|| ::onChangeSearch() } 

   ::EnableWindowsBar()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   ::DisableWindowsBar()

   ::oController:End()

   if !empty( ::oMdiChild )
      ::oMdiChild:End()
   end if 

   if !empty( ::oMenuTreeView )
      ::oMenuTreeView:End()
   end if 

   if !empty( ::oSQLBrowseView )
      ::oSQLBrowseView:End()
   end if 

   if !empty( ::oTopWebBar )
      ::oTopWebBar:End()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD CreateTopWebBar()

   ::oTopWebBar   := TWebBar():New( 0, dfnTreeViewWidth, ::aRect[ 4 ] - dfnTreeViewWidth, dfnSplitterHeight,,,, dfnTextColorTop, dfnBackColorTop, , , , , , ::oMdiChild )
   
   ::oTopWebBar:Say( 0, dfnSplitterWidth + 10, ::oController:cTitle ) 

RETURN ( ::oTopWebBar  )

//----------------------------------------------------------------------------//

METHOD CreateSplitters()

   ::oHorizontalSplitter   := TSplitter():New(  /*nRow*/ dfnSplitterHeight, /*nCol*/ dfnTreeViewWidth, /*lVertical*/ .f.,;
                                                /*aPrevCtrols*/ { ::oTopWebBar }, /*lAdjPrev*/ .t.,;
                                                /*aHindCtrols*/ { ::getBrowse() }, /*lAdjHind*/ .t.,;
                                                /*bMargin1*/ {|| 0}, /*bMargin2*/ {|| 0}, /*oWnd*/ ::oMdiChild,;
                                                /*bChange*/, /*nWidth*/ ::aRect[ 4 ], /*nHeight*/ dfnSplitterWidth, /*lPixel*/ .t.,;
                                                /*l3D*/ .t., /*nClrBack*/ rgb( 255, 255, 255 ), /*lDesign*/ .f.,;
                                                /*lUpdate*/ .f., /*lStyle*/ .f., /*aGradient*/, /*aGradientOver*/ )
   ::oHorizontalSplitter:lStatic := .t.

   ::oVerticalSplitter     := TSplitter():New(  /*nRow*/ 0, /*nCol*/ dfnTreeViewWidth, /*lVertical*/ .t.,;
                                                /*aPrevCtrols*/ { ::oMenuTreeView }, /*lAdjPrev*/ .t., /*aHindCtrols*/ { ::oTopWebBar, ::oHorizontalSplitter, ::getBrowse() },;
                                                /*lAdjHind*/ .t., /*bMargin1*/ {|| 0}, /*bMargin2*/ {|| 0}, /*oWnd*/ ::oMdiChild,;
                                                /*bChange*/, /*nWidth*/ dfnSplitterWidth, /*nHeight*/ ::aRect[ 3 ] - dfnSplitterHeight, /*lPixel*/ .t., /*l3D*/.t.,;
                                                /*nClrBack*/ , /*lDesign*/ .f., /*lUpdate*/ .t., /*lStyle*/ .t. )  


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD EnableWindowsBar()

   if empty( ::oWindowsBar )
      RETURN ( Self )
   end if 

   ::oWindowsBar:enableGet()

   ::oWindowsBar:enableComboBox( ::getModelHeadersForBrowse() )

   ::oWindowsBar:setCombo( ::getModelHeaderFromColumnOrder() )

   ::oWindowsBar:enableComboFilter()

   ::oWindowsBar:showAddButtonFilter()

   ::getBrowse():selectColumnOrderByHeader( ::getModelHeaderFromColumnOrder() )

   ::Refresh()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD DisableWindowsBar()

   if empty( ::oWindowsBar )
      RETURN ( Self )
   end if 

   ::oWindowsBar:DisableGet()

   ::oWindowsBar:DisableComboBox()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD keyDown( nKey, nFlags )

   do case
      case nKey == VK_ESCAPE
         ::End()
      case nKey == VK_INSERT 
         ::oController:Append() 
      case nKey == VK_RETURN 
         ::oController:Edit() 
      case nKey == VK_DELETE 
         ::oController:Delete( ::getBrowse():aSelected )
      case nKey == VK_F5
         ::RefreshRowSet()
   end case

RETURN ( 0 )

//----------------------------------------------------------------------------//