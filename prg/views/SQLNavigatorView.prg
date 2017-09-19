#include "FiveWin.Ch"
#include "Factu.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      1
#define dfnSplitterHeight     76
#define dfnColorTop           rgb( 238, 110, 115 )

//------------------------------------------------------------------------//

CLASS SQLNavigatorView FROM SQLBrowseableView

   DATA aRect

   METHOD New( oController )

   METHOD Activate()

   METHOD End()

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

   // XBrowse------------------------------------------------------------------

   DATA oBrowse

   METHOD getBrowse()                     INLINE ( ::oBrowse )

   METHOD CreateBrowse()

   METHOD GenerateColumnsBrowse()

   METHOD AddColumnBrowse( cColumn, hColumn )

   METHOD CreateFromCodeBrowse()          INLINE ( ::oBrowse:CreateFromCode() )

   // Splitters------------------------------------------------------------------

   DATA oVerticalSplitter
   DATA oHorizontalSplitter

   METHOD CreateSplitters()

   // Aplication windows bar---------------------------------------------------

   DATA oWindowsBar

   METHOD EnableWindowsBar()

   METHOD DisableWindowsBar()

   // Eventos------------------------------------------------------------------

   METHOD onChangeCombo()

   METHOD onClickHeaderBrowse()

   METHOD onChangeSearch()

   METHOD onBrowseKeyChar( nKey )

   METHOD Refresh()                       INLINE ( ::oMenuTreeView:SelectButtonMain(), ::oBrowse:SetFocus() )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

   ::oMenuTreeView         := MenuTreeView():New( Self )

   ::aRect                 := GetWndRect( GetDeskTopWindow() )

   ::oWindowsBar           := oWndBar()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   ::CreateMDIChild()

   ::CreateTopWebBar()

   ::oMenuTreeView:MDIActivate( dfnTreeViewWidth, ::aRect[ 3 ] - dfnSplitterHeight )

   ::oMenuTreeView:AddAutoButtonTreeMenu()

   ::CreateBrowse()

      ::GenerateColumnsBrowse()

      ::CreateFromCodeBrowse()

   ::CreateSplitters()

   ::ActivateMDIChild()

   ::oWindowsBar:setComboBoxChange( {|| ::onChangeCombo() } )

   ::oWindowsBar:setGetChange( {|| ::onChangeSearch() } ) 

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

   if !empty( ::oTopWebBar )
      ::oTopWebBar:End()
   end if 

   if !empty( ::oBrowse )
      ::oBrowse:End()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD CreateTopWebBar()

   ::oTopWebBar   := TWebBar():New( 0, dfnTreeViewWidth, ::aRect[ 4 ] - dfnTreeViewWidth, dfnSplitterHeight,,,, rgb( 255, 255, 255 ), dfnColorTop, , , , , , ::oMdiChild )
   
   ::oTopWebBar:Say( 0, dfnSplitterWidth + 10, ::oController:cTitle ) 

RETURN ( ::oTopWebBar  )

//----------------------------------------------------------------------------//

METHOD CreateBrowse() 

   ::oBrowse                  := SQLXBrowse():New( ::oMdiChild )
   ::oBrowse:nStyle           := nOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP )
   ::oBrowse:l2007            := .f.

   ::oBrowse:lRecordSelector  := .f.
   ::oBrowse:lAutoSort        := .t.
   ::oBrowse:lSortDescend     := .f.   

   // Propiedades del control -------------------------------------------------

   ::oBrowse:nMarqueeStyle    := MARQSTYLE_HIGHLROWMS

   ::oBrowse:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrowse:bRClicked        := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }

   ::oBrowse:setModel( ::getModel() )

   ::oBrowse:bKeyChar         := {|nKey| ::onBrowseKeyChar( nKey ) }

   ::oBrowse:bLDblClick       := {|| ::oController:Edit(), ::Refresh() }

   // Dimensiones del control -------------------------------------------------

   ::oBrowse:nTop             := dfnSplitterHeight + dfnSplitterWidth

   ::oBrowse:nLeft            := dfnTreeViewWidth + dfnSplitterWidth 
   ::oBrowse:nRight           := ::oMdiChild:nRight - ::oMdiChild:nLeft
   ::oBrowse:nBottom          := ::oMdiChild:nBottom - ::oMdiChild:nTop

RETURN ( ::oBrowse )

//---------------------------------------------------------------------------//

METHOD GenerateColumnsBrowse()

   local hColumnstoBrowse  := ::getModelColumnsForNavigator()

   if empty( hColumnstoBrowse )
      RETURN ( self )
   end if 

   hEval( hColumnstoBrowse, { | cColumn, hColumn | ::addColumnBrowse( cColumn, hColumn ) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addColumnBrowse( cColumn, hColumn )

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := cColumn
      :cHeader             := hColumn[ "header" ]
      :nWidth              := hColumn[ "width" ]
      :bLClickHeader       := {| nMRow, nMCol, nFlags, oColumn | ::onClickHeaderBrowse( oColumn ) }
      :bEditValue          := ::getModel():getEditValue( cColumn ) 
   end with

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD CreateSplitters()

   ::oHorizontalSplitter   := TSplitter():New(  /*nRow*/ dfnSplitterHeight, /*nCol*/ dfnTreeViewWidth, /*lVertical*/ .f.,;
                                                /*aPrevCtrols*/ { ::oTopWebBar }, /*lAdjPrev*/ .t.,;
                                                /*aHindCtrols*/ { ::oBrowse }, /*lAdjHind*/ .t.,;
                                                /*bMargin1*/ {|| 0}, /*bMargin2*/ {|| 0}, /*oWnd*/ ::oMdiChild,;
                                                /*bChange*/, /*nWidth*/ ::aRect[ 4 ], /*nHeight*/ dfnSplitterWidth, /*lPixel*/ .t.,;
                                                /*l3D*/ .t., /*nClrBack*/ rgb( 255, 255, 255 ), /*lDesign*/ .f.,;
                                                /*lUpdate*/ .f., /*lStyle*/ .f., /*aGradient*/, /*aGradientOver*/ )
   ::oHorizontalSplitter:lStatic := .t.

   ::oVerticalSplitter     := TSplitter():New(  /*nRow*/ 0, /*nCol*/ dfnTreeViewWidth, /*lVertical*/ .t.,;
                                                /*aPrevCtrols*/ { ::oMenuTreeView }, /*lAdjPrev*/ .t., /*aHindCtrols*/ { ::oTopWebBar, ::oHorizontalSplitter, ::oBrowse },;
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

   ::oWindowsBar:EnableComboBox( ::getModelHeadersForNavigator() )

   ::oWindowsBar:setCombo( ::getModelHeaderFromColumnOrder() )

   ::oBrowse:selectColumnOrderByHeader( ::getModelHeaderFromColumnOrder() )

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

METHOD onChangeCombo( oColumn )

   local oComboBox   := ::oWindowsBar:oComboBox()

   if empty( oComboBox )
      RETURN ( Self )
   end if 

   if empty( oColumn )
      oColumn        := ::oBrowse:getColumnByHeader( oComboBox:VarGet() )
   end if 

   if empty( oColumn )
      RETURN ( Self )
   end if 

   oComboBox:set( oColumn:cHeader )

   ::oController:changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::oBrowse:selectColumnOrder( oColumn )

   ::oBrowse:refreshCurrent()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD onClickHeaderBrowse( oColumn )

   local oCombobox   := ::oWindowsBar:oComboBox()

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
   local oSearch        := ::oWindowsBar:oGet()
   local cOrder         := ::oWindowsBar:GetComboBox()
   local cColumnOrder   := ::oBrowse:getColumnOrderByHeader( cOrder )

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
   
   ::oBrowse:refreshCurrent()

RETURN ( nFind > 0 )

//----------------------------------------------------------------------------//

METHOD onBrowseKeyChar( nKey )

RETURN ( heval( ::oMenuTreeView:hFastKeyTreeMenu, {|k,v| if( nKey == asc( upper( k ) ) .or. nKey == asc( lower( k ) ), eval( v ), ) } ) ) 
   
//----------------------------------------------------------------------------//

