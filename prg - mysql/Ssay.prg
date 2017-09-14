// Sensitive Say control by Ramón Avendaño
// 23-02-00

#include "FiveWin.Ch"
#include "Constant.ch"

#define SS_CENTER             1
#define SS_RIGHT              2
#define SS_GRAYRECT           5 // BOXRECT

#define TA_LEFT               0
#define TA_RIGHT              2
#define TA_CENTER             6
#define TA_TOP                0
#define TA_BOTTOM             8

#define COLOR_ACTIVECAPTION   2
#define COLOR_WINDOW          5
#define COLOR_WINDOWTEXT      8

#define COLOR_BTNSHADOW      16
#define COLOR_BTNHIGHLIGHT   20

#define WM_SYSCOMMAND       274  // 0x112
#define WM_NCHITTEST        132  // 0x84
#define WM_NCMOUSEMOVE      160  // 0xA0

#define GWL_STYLE         -16
#define GWL_EXSTYLE       -20

#define WS_EX_TRANSPARENT    32

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
#endif


Static oSSayOver
Static oWndMMovedParent, bMMovedParent

//----------------------------------------------------------------------------//

CLASS TSSay FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   DATA   l3D
   DATA   cPicture
   DATA   aCaption
   DATA   bGet

   DATA   lTransparent
   DATA   lShaded, lBox, lRaised

   DATA   lOver
   DATA   nClrOver

   DATA   bAction
   DATA   bMOver, bNonMOver

   DATA   lDrawBox
   DATA   nSTop, nSLeft
   DATA   aRect
   DATA   nTxtWidth, nTxtHeight
   DATA   nAlign

   METHOD New( nRow, nCol, bText, oWnd, cPicture, oFont, oCursor,;
               bAction, lCentered, lRight, lBottom, lBorder, lPixels,;
               nClrText, nClrBack, nClrOver, nWidth, nHeight,;
               lDesign, lUpdate, lShaded, lBox, lRaised, lTransparent, bMOver ) CONSTRUCTOR

   METHOD ReDefine( nId, bText, oWnd, cPicture,;
                    bAction, lCentered, lRight, lBottom,;
                    nClrText, nClrBack, nClrOver, lUpdate, oFont, oCursor,;
                    lShaded, lBox, lRaised, lTransparent, bMOver )  CONSTRUCTOR

   METHOD Default()

   METHOD Initiate( hDlg ) INLINE Super:Initiate( hDlg ), ::Default()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Display() INLINE  ::BeginPaint(), ::Paint(), ::EndPaint()

   METHOD Paint()

   METHOD Refresh() INLINE If( ::bGet != nil, ::SetText( Eval( ::bGet ) ),)

   METHOD ReSize( nType, nWidth, nHeight );
                  INLINE ::Default(), Super:ReSize( nType, nWidth, nHeight )

   METHOD SetText( cText ) INLINE ;
                    ::cCaption := If( ::cPicture != nil,;
                                  Transform( cText, ::cPicture ),;
                                  cValToChar( cText ) ),;
                                  ::Default(), ::Paint()

   METHOD DrawBox( lOnOff )

   METHOD LButtonDown( nRow, nCol, nFlags )
   METHOD LButtonUp( nRow, nCol, nFlags )

   METHOD MouseMove( nRow, nCol, nKeyFlags )
   METHOD NcMouseMove( nHitTestCode, nRow, nCol )

   METHOD VarPut( cValue )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bText, oWnd, cPicture, oFont, oCursor,;
            bAction, lCentered, lRight, lBottom, lBorder, lPixels,;
            nClrText, nClrBack, nClrOver, nWidth, nHeight,;
            lDesign, lUpdate, lShaded, lBox, lRaised, lTransparent, bMOver ) CLASS TSSay

   DEFAULT nRow     := 0, nCol := 0,;
           lTransparent := .f.,;
           lBorder  := .f., lCentered := .f., lRight := .f., lBottom := .f., lPixels := .f.,;
           oWnd     := GetWndDefault(),;
           nClrText := oWnd:nClrText, nClrBack := oWnd:nClrPane,;
           nClrOver := GetSysColor( COLOR_ACTIVECAPTION ),;
           nHeight  := If( oFont != nil, Abs( oFont:nHeight ), SAY_CHARPIX_H ),;
           lDesign  := .f., bText := { || "" },;
           lUpdate  := .f., lShaded := .f., lBox := .f., lRaised := .f.

   ::l3D       = lShaded .or. lBox .or. lRaised
   ::nAlign    = nOr( If( lBottom, TA_BOTTOM, TA_TOP ),;
                      If( lCentered, TA_CENTER, If( lRight, TA_RIGHT, TA_LEFT ) ) )
   ::bGet      = bText
   ::bSetGet   = bText
   ::cPicture  = cPicture
   ::cCaption  = If( Empty( cPicture ), cValToChar( Eval( bText ) ),;
                     Transform( Eval( bText ), cPicture ) )

   DEFAULT nWidth := ( If( oFont != nil, Abs( oFont:nWidth ), SAY_CHARPIX_W ) * Len( ::cCaption ) ) - 4  // 8

   if ! lPixels
      ::nTop  = nRow * If( oFont != nil, Abs( oFont:nHeight ), SAY_CHARPIX_H ) + 2        // 13
      ::nLeft = nCol * If( oFont != nil, Abs( oFont:nWidth ), SAY_CHARPIX_W )             // 8
   else
      ::nTop  = nRow
      ::nLeft = nCol
   endif

   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1

   ::oWnd      = oWnd
   ::oFont     = oFont
   ::oCursor   = oCursor
   ::bAction   = bAction
   ::nId       = ::GetNewId()
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                 If( lDesign, nOr( WS_CLIPSIBLINGS, WS_TABSTOP ), 0 ),;
                 If( lBorder, WS_BORDER, 0 ) )
   ::lShaded  = lShaded
   ::lBox     = lBox
   ::lRaised  = lRaised

   ::lOver     = .f.
   ::nClrOver  = nClrOver
   ::bMOver    = bMOver

   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::lUpdate   = lUpdate

   ::lTransparent = lTransparent

   ::SetColor( nClrText, if( lTransparent,, nClrBack ) )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::Default()
      if ::l3D
         ::Set3DLook()
      endif
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   if ::lDrag
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bText, oWnd, cPicture,;
                 bAction, lCentered, lRight, lBottom,;
                 nClrText, nClrBack, nClrOver, lUpdate, oFont, oCursor,;
                 lShaded, lBox, lRaised, lTransparent, bMOver ) CLASS TSSay

   DEFAULT lTransparent := .f.,;
           lCentered := .f., lRight := .f., lBottom := .f.,;
           nClrText := oWnd:nClrText, nClrBack := oWnd:nClrPane,;
           nClrOver := GetSysColor( COLOR_ACTIVECAPTION ),;
           oWnd := GetWndDefault(),;
           lUpdate := .f., lShaded := .f., lBox := .f., lRaised := .f.

   ::l3D       = lShaded .or. lBox .or. lRaised
   ::nId       = nId
   ::nAlign    = nOr( If( lBottom, TA_BOTTOM, TA_TOP ),;
                      If( lCentered, TA_CENTER, If( lRight, TA_RIGHT, TA_LEFT ) ) )
   ::bGet      = bText
   ::bSetGet   = bText
   ::cPicture  = cPicture
   ::oFont     = oFont

   if bText != nil
      ::cCaption = If( Empty( cPicture ), cValToChar( Eval( bText ) ),;
                       Transform( Eval( bText ), cPicture ) )
   endif

   ::oWnd      = oWnd
   ::hWnd      = 0
   ::oCursor   = oCursor
   ::bAction   = bAction

   ::lShaded  = lShaded
   ::lBox     = lBox
   ::lRaised  = lRaised

   ::lOver     = .f.
   ::nClrOver  = nClrOver
   ::bMOver    = bMOver

   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lUpdate   = lUpdate

   ::lTransparent = lTransparent

   ::SetColor( nClrText, if( lTransparent,, nClrBack ) )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if oWnd != nil
      oWnd:DefControl( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TSSay

   if ::lDrag .and. nMsg == WM_NCHITTEST
      return DefWindowProc( ::hWnd, nMsg, nWParam, nLParam )
   elseif nMsg == WM_NCMOUSEMOVE
      return DefWindowProc( ::hWnd, nMsg, nWParam, nLParam )
   endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD Default() CLASS TSSay

   local lCentered := nAnd( ::nAlign, TA_CENTER ) == TA_CENTER
   local lRight    := nAnd( ::nAlign, TA_RIGHT ) == TA_RIGHT
   local lBottom   := nAnd( ::nAlign, TA_BOTTOM ) == TA_BOTTOM

   DEFAULT ::lDrawBox := .f.

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::SetFont( ::oWnd:oFont )
   endif

   ::nTxtWidth  = 0
   ::nTxtHeight = GetTextHeight( ::hWnd, 0 )

   if ! Empty( ::cCaption )
      SetWindowText( ::hWnd, ::cCaption )
   else
      ::cCaption = GetWindowText( ::hWnd )
   endif

   ::aCaption   = Array( MLCount( ::cCaption, 254 ) )
   AEval( ::aCaption, {|c, n| ::aCaption[ n ] := Trim( MemoLine( ::cCaption, 252, n ) ),;
                       ::nTxtWidth := Max( ::nTxtWidth, GetTextWidth( 0, ::aCaption[ n ],;
                       if( ::oFont != nil, ::oFont:hFont, 0 ) ) ) } )

   ::aRect := GetClientRect( ::hWnd )

   ::nSTop  := if( lBottom, ::aRect[ 3 ], 0 )
   ::nSLeft := if( lCentered, int( ::aRect[ 4 ] / 2 ), if( lRight, ::aRect[ 4 ], 0 ) )

   if ::lBox
      ::aRect := { 2, 2, ::aRect[ 3 ] - 2, ::aRect[ 4 ] - 2 }
   elseif ::lShaded .or. ::lRaised
      ::aRect := { 1, 1, ::aRect[ 3 ] - 1, ::aRect[ 4 ] - 1 }
   endif

   if ::lTransparent
      SetWindowLong( ::hWnd, GWL_EXSTYLE,;
         nOr( GetWindowLong( ::hWnd, GWL_EXSTYLE ), WS_EX_TRANSPARENT ) )
   endif

   if oWndMMovedParent = nil .and. bMMovedParent = nil .and. ::oWnd:bMMoved != nil
      bMMovedParent := ::oWnd:bMMoved
   endif
   oWndMMovedParent := ::oWnd

   ::oWnd:bMMoved := {| nRow, nCol, nKeyFlags | NcSSayOver( nRow, nCol, nKeyFlags ) }

   if !::ltransparent
      InvalidateRect( ::hWnd, ::aRect, .t. )
   else
      InvalidateRect( ::oWnd:hWnd, { ::nTop + ::aRect[1], ::nLeft + ::aRect[2],;
                                     ::nTop + ::aRect[3], ::nLeft + ::aRect[4] }, .f. )
      SysRefresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TSSay

   local n
   local nColorShadow, nColorLight

   ::GetDC()

   if ::lActive

      for n := 1 to len( ::aCaption )
          WSay( ::hWnd, ::hDC, ::nSTop + ( n - 1 ) * ::nTxtHeight, ::nSLeft, ::aCaption[ n ],;
                If( ::lOver, ::nClrOver, ::nClrText ),,;
                If( ::oFont != nil, ::oFont:hFont, 0 ), .T., .T., ::nAlign )
      next

      if ::lDrawBox
         ::DrawBox( ::lOver )
      endif

   else

      nColorShadow := GetSysColor( COLOR_BTNSHADOW )
      nColorLight  := GetSysColor( COLOR_BTNHIGHLIGHT )

      for n := 1 to len( ::aCaption )
          WSay( ::hWnd, ::hDC, ::nSTop + ( n - 1 ) * ::nTxtHeight + 1, ::nSLeft + 1, ::aCaption[ n ], nColorLight,,;
                If( ::oFont != nil, ::oFont:hFont, 0 ), .T., .T., ::nAlign )
          WSay( ::hWnd, ::hDC, ::nSTop + ( n - 1 ) * ::nTxtHeight, ::nSLeft, ::aCaption[ n ], nColorShadow,,;
                If( ::oFont != nil, ::oFont:hFont, 0 ), .T., .T., ::nAlign )
      next

   endif

   // 3D

   if ::lShaded
      WndInset( ::hWnd, ::hDC )   // SHADED, SHADOW
   endif

   if ::lRaised
      WndRaised( ::hWnd, ::hDC )  // RAISED
   endif

   if ::lBox
      WndBoxIn( ::hDC, 0, 0, ::nBottom-::nTop, ::nRight-::nLeft )
      WndBoxRaised( ::hDC, 1, 1, ::nBottom-::nTop-1, ::nRight-::nLeft-1 )
   endif

   ::ReleaseDC()

   if ::lTransparent
      SysRefresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DrawBox( lOnOff ) CLASS TSSay

  local hPen := CreatePen( PS_SOLID, 1, if( lOnOff, ::oWnd:nClrText, ::oWnd:nClrPane ) )

  MoveTo( ::hDC, ::aRect[2], ::aRect[1] )
  LineTo( ::hDC, ::aRect[4] - 1, ::aRect[1], hPen )
  LineTo( ::hDC, ::aRect[4] - 1, ::aRect[3] - 1, hPen )
  LineTo( ::hDC, ::aRect[2], ::aRect[3] - 1, hPen )
  LineTo( ::hDC, ::aRect[2], ::aRect[1], hPen )

  DeleteObject( hPen )

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TSSay

   local nPos, aRect

   if !::lActive .or. ::lDrag
      return Super:LButtonDown( nRow, nCol, nFlags )
   endif

   Super:LButtonDown( nRow, nCol, nFlags )

return nil

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TSSay

   if !::lActive .or. ::lDrag
      return Super:LButtonUp( nRow, nCol, nFlags )
   endif

   if ::bAction != nil
      Eval( ::bAction, Self )
   endif

   Super:LButtonUp( nRow, nCol, nFlags )

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TSSay

   ::SetMsg( ::cMsg )

   ::CheckToolTip()

   if !::lActive .or. ::lDrag
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

   if !::lOver

      if oSSayOver != nil
         NcSSayOver( nRow, nCol, nKeyFlags )
      endif

      ::lOver := .t.
      oSSayOver := Self

      ::Paint()

      if ::bMOver != nil
         Eval( ::bMOver )
      endif

   endif

   if ::oCursor != nil
      SetCursor( ::oCursor:hCursor )
   else
      CursorHAND()
   endif

return 0

//----------------------------------------------------------------------------//

METHOD NcMouseMove( nHitTestCode, nRow, nCol ) CLASS TSSay

   if !::lActive .or. ::lDrag
      return Super:NcMouseMove( nHitTestCode, nRow, nCol )
   endif

   if ::lOver
      ::lOver := .f.
      oSSayOver := nil

      ::Paint()

      if ::bNonMOver != nil
         Eval( ::bNonMOver )
      endif

   endif

return 0

//----------------------------------------------------------------------------//

METHOD VarPut( cValue ) CLASS TSSay

   if ! Empty( ::cPicture )
      cValue = Transform( cValue, ::cPicture )
   else
      cValue = cValToChar( cValue )
   endif

   ::bGet = { || cValue }

return nil


//  Public functions
//----------------------------------------------------------------------------//

function NcSSayOver( nRow, nCol, nKeyFlags )

  if oSSayOver != nil
     oSSayOver:NcMouseMove( 0, nRow, nCol )
  endif

  if bMMovedParent != nil
     Eval( bMMovedParent, nRow, nCol, nKeyFlags )
  endif

return nil

//----------------------------------------------------------------------------//
// R.Avendaño. 1998