#include "FiveWin.Ch"
#include "Factu.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      1
#define dfnSplitterHeight     76
#define dfnColorTop           rgb( 238, 110, 115 )

//------------------------------------------------------------------------//

CLASS SQLNavigatorView FROM SQLBrowseableView

   DATA aRect

   DATA oMenuTreeView

   DATA oSQLBrowseView

   METHOD New( oController )

   METHOD Activate()

   METHOD End()

   // Facades------------------------------------------------------------------

   METHOD getComboBoxOrder()              INLINE ( ::oWindowsBar:oComboBox() )
   METHOD getGetSearch()                  INLINE ( ::oWindowsBar:oGet() )

   METHOD getWindow()                     INLINE ( ::oMdiChild )

   // MDI child----------------------------------------------------------------

   DATA oMdiChild

   METHOD CreateMDIChild()                INLINE ( ::oMdiChild := TMdiChild():New(  ::aRect[ 1 ], ::aRect[ 2 ], ::aRect[ 3 ], ::aRect[ 4 ], /*cTitle*/, /*nStyle*/, /*oMenu*/, oWnd(),;
                                                                                    /*oIcon*/, /*lVScroll*/, /*nClrText*/, /*nClrBack*/, /*oCursor*/, /*oBrush*/, /*lPixel*/ .t.,;
                                                                                    /*lHScroll*/, /*nHelpId*/, /*cBorder*/ "NONE", /*lSysMenu*/, /*lCaption*/ .f., /*lMin*/, /*lMax*/, /*nMenuInfo*/ ) )

   METHOD ActivateMDIChild()              INLINE ( ::oMdiChild:Activate() )   // cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                                                                              // bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn,;
                                                                              // bLeft, bRight, bPgLeft, bPgRight, bValid )

   // Top webbar---------------------------------------------------------------

   DATA oTopWebBar

   METHOD CreateTopWebBar()

   // Splitters------------------------------------------------------------------

   DATA oVerticalSplitter
   DATA oHorizontalSplitter

   METHOD CreateSplitters()

   // Aplication windows bar---------------------------------------------------

   DATA oWindowsBar

   METHOD EnableWindowsBar()

   METHOD DisableWindowsBar()

   // Eventos------------------------------------------------------------------

   METHOD onClickHeaderBrowse()

   METHOD onChangeSearch()

   METHOD onBrowseKeyChar( nKey )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

   ::aRect                 := GetWndRect( GetDeskTopWindow() )

   ::oMenuTreeView         := MenuTreeView():New( Self )

   ::oSQLBrowseView        := SQLBrowseView():New( Self )

   ::oWindowsBar           := oWndBar()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   ::CreateMDIChild()

   ::CreateTopWebBar()

   // Tree menu ---------------------------------------------------------------

   ::oMenuTreeView:ActivateMDI( dfnTreeViewWidth, ::aRect[ 3 ] - dfnSplitterHeight )

   ::oMenuTreeView:AddAutoButtons()

   // Browse view --------------------------------------------------------------

   ::oSQLBrowseView:ActivateMDI( dfnSplitterHeight + dfnSplitterWidth, dfnTreeViewWidth + dfnSplitterWidth, ::oMdiChild:nRight - ::oMdiChild:nLeft, ::oMdiChild:nBottom - ::oMdiChild:nTop )

   // Splitters----------------------------------------------------------------

   ::CreateSplitters()

   ::ActivateMDIChild()

   // Eventos------------------------------------------------------------------

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

   ::oTopWebBar   := TWebBar():New( 0, dfnTreeViewWidth, ::aRect[ 4 ] - dfnTreeViewWidth, dfnSplitterHeight,,,, rgb( 255, 255, 255 ), dfnColorTop, , , , , , ::oMdiChild )
   
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

   ::oWindowsBar:EnableGet()

   ::oWindowsBar:EnableComboBox( ::getModelHeadersForBrowse() )

   ::oWindowsBar:setCombo( ::getModelHeaderFromColumnOrder() )

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

METHOD onClickHeaderBrowse( oColumn )

   local oCombobox   := ::getComboBoxOrder()

   if empty( oComboBox )
      RETURN ( Self )
   end if 

   if empty( oColumn )
      RETURN ( Self )
   end if 

   if ascan( oCombobox:aItems, oColumn:cHeader ) == 0
      RETURN ( Self )
   end if

   oComboBox:Set( oColumn:cHeader )
   
RETURN ( ::onChangeCombo() )

//---------------------------------------------------------------------------//

METHOD onChangeSearch()

   local uValue
   local nFind          := 0
   local oSearch        := ::getGetSearch()
   local cOrder         := ::getComboBoxOrder()
   local cColumnOrder   := ::getBrowse():getColumnOrderByHeader( cOrder )

   if empty( oSearch )
      RETURN ( Self )
   end if 

   if empty( cColumnOrder )
      RETURN ( Self )
   end if 

   uValue               := oSearch:oGet:Buffer()
   uValue               := alltrim( upper( cvaltochar( uValue ) ) )
   uValue               := strtran( uValue, chr( 8 ), "" )
   
   if ::getModel():find( uValue, cColumnOrder )
      oSearch:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
   else
      oSearch:SetColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
   end if
   
   ::getBrowse():refreshCurrent()

RETURN ( nFind > 0 )

//----------------------------------------------------------------------------//

METHOD onBrowseKeyChar( nKey )

RETURN ( heval( ::oMenuTreeView:hFastKeyTreeMenu, {|k,v| if( nKey == asc( upper( k ) ) .or. nKey == asc( lower( k ) ), eval( v ), ) } ) ) 
   
//----------------------------------------------------------------------------//

