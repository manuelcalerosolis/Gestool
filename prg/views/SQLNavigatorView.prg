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
   
   METHOD New( oController )

   METHOD End()

   METHOD Activate()

   // Facades------------------------------------------------------------------

   METHOD getComboBoxOrder()              INLINE ( ::oController:oWindowsBar:oComboBox() )

   METHOD getGetSearch()                  INLINE ( ::oController:oWindowsBar:oGet() )

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

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::Super():New( oController )

   ::aRect                 := GetWndRect( GetDeskTopWindow() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oController:DisableWindowsBar()

   ::oController:End()

   if !empty( ::oMdiChild )
      ::oMdiChild:End()
   end if 

   if !empty( ::oMenuTreeView )
      ::oMenuTreeView:End()
   end if 

   if !empty( ::oTopWebBar )
      ::oTopWebBar:End()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Activate()

   ::CreateMDIChild()

   ::CreateTopWebBar()

   // Tree menu ---------------------------------------------------------------

   ::oMenuTreeView:ActivateMDI( dfnTreeViewWidth, ::aRect[ 3 ] - dfnSplitterHeight )

   ::oMenuTreeView:AddAutoButtons()

   // Browse view -------------------------------------------------------------

   ::getBrowseView():ActivateMDI( ::getWindow(), dfnSplitterHeight + dfnSplitterWidth, dfnTreeViewWidth + dfnSplitterWidth, ::oMdiChild:nRight - ::oMdiChild:nLeft, ::oMdiChild:nBottom - ::oMdiChild:nTop - dfnSplitterHeight - 162 )

   ::getBrowseView():setView()

   // Splitters----------------------------------------------------------------

   ::CreateSplitters()

   ::ActivateMDIChild()

   // Eventos------------------------------------------------------------------

   ::oMdiChild:bKeyDown          := {|nKey, nFlags| ::keyDown( nKey, nFlags ) }

   ::getComboBoxOrder():bChange  := {|| ::onChangeCombo() } 

   ::oController:oWindowsBar:setGetChange( {|| ::onChangeSearch() } )

   // ::getGetSearch():bChange      := {|| ::onChangeSearch() } 

RETURN ( Self )

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
                                                /*aPrevCtrols*/ { ::oMenuTreeView:oTreeView }, /*lAdjPrev*/ .t., /*aHindCtrols*/ { ::oTopWebBar, ::oHorizontalSplitter, ::getBrowse() },;
                                                /*lAdjHind*/ .t., /*bMargin1*/ {|| 0}, /*bMargin2*/ {|| 0}, /*oWnd*/ ::oMdiChild,;
                                                /*bChange*/, /*nWidth*/ dfnSplitterWidth, /*nHeight*/ ::aRect[ 3 ] - dfnSplitterHeight, /*lPixel*/ .t., /*l3D*/.t.,;
                                                /*nClrBack*/ , /*lDesign*/ .f., /*lUpdate*/ .t., /*lStyle*/ .t. )  


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD keyDown( nKey, nFlags )

   do case
      case nKey == VK_ESCAPE
         ::End()
      case nKey == VK_INSERT 
         ::oController:Append() 
      case nKey == VK_RETURN 
         ::oController:Edit( ) 
      case nKey == VK_DELETE 
         ::oController:Delete( ::getBrowse():aSelected )
      case nKey == VK_F5
         ::RefreshRowSet()
   end case

RETURN ( 0 )

//----------------------------------------------------------------------------//