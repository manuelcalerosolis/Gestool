#include "FiveWin.ch"
#include "Constant.ch"
#include "Inkey.ch"

#define GW_CHILD      5
#define GW_HWNDNEXT   2
#define RT_BITMAP     2

#define COLOR_WINDOW         5
#define COLOR_WINDOWTEXT     8
#define COLOR_BTNFACE       15

#define CF_BITMAP            2

#define WM_NCHITTEST       132  // 0x84

#define SRCCOPY       13369376

#ifdef __XPP__
   #define ::Super ::TControl
   #define New _New
#endif

#define TME_LEAVE            2
#define WM_MOUSELEAVE      675

//----------------------------------------------------------------------------//

CLASS TBitmap FROM TControl

   CLASSDATA lRegistered AS LOGICAL
   CLASSDATA aProperties INIT { "cVarName", "cBmpFile", "lStretch", "nTop",;
                                  "nLeft", "nWidth", "nHeight", "nZoom" }

   DATA   nX, nY, nOldX, nOldY
   DATA   hBitmap, hPalette
   DATA   cBmpFile, cResName
   DATA   lScroll, lStretch
   DATA   aHotAreas
   DATA   nVStep, nHStep
   DATA   nZoom
   DATA   lTransparent AS LOGICAL INIT .f.
   DATA   lHasAlpha AS LOGICAL INIT .f.
   DATA   bAlphaLevel
   DATA   hAlphaLevel
   DATA   bMLeave

   METHOD New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder,;
               oWnd, bLClicked, bRClicked, lScroll, lStretch,;
               oCursor, cMsg, lUpdate, bWhen, lPixel, bValid,;
               lDesign ) CONSTRUCTOR

   METHOD Define( cResName, cBmpFile, oWnd, hBitmap ) CONSTRUCTOR

   METHOD ReDefine( nId, cResName, cBmpFile, oWnd, bLClicked, bRClicked,;
                    lScroll, lStretch, oCursor, cMsg, lUpdate,;
                    bWhen, bValid, lTransparent ) CONSTRUCTOR

   METHOD AdjControls( lDown )

   METHOD Center()

   METHOD CopyToClipboard()

   METHOD Destroy()

   METHOD EraseBkGnd( hDC )

   METHOD Zoom( nZoom )

   METHOD Command( nWParam, nLParam ) INLINE ;
                   SendMessage( nLoWord( nLParam ), FM_CLICK, 0, 0 ), 0

   METHOD Default()

   METHOD GotFocus() INLINE ::Super:GotFocus(), ::SetFore()

   METHOD Inspect( cData )

   METHOD KeyDown( nKey, nFlag )

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD End() INLINE If( ::hWnd == 0, ::Destroy(), ::Super:End() )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD PageUp()
   METHOD PageDown()
   METHOD PageLeft()
   METHOD PageRight()

   METHOD Paint()

   METHOD LoadFromClipboard( oWnd )

   METHOD LoadFromString( cString )

   METHOD LoadImage( cResName, cBmpFile )

   METHOD ReLoad( cResName, cBmpFile )

   METHOD ReSize( nType, nWidth, nHeight ) INLINE ;
                             ::ScrollAdjust(),;
                             ::Super:ReSize( nType, nWidth, nHeight )

   METHOD SetBMP( cResName )  INLINE ::ReLoad( cResName )

   METHOD SetFore() INLINE SetForeBmp( ::hBitmap, ::hPalette )

   METHOD LoadBMP( cBmpFile ) INLINE ::ReLoad( "", AllTrim( cBmpFile ) ), ::HasAlpha()

   METHOD ScrollAdjust()

   METHOD Initiate( hDlg ) INLINE  ::Super:Initiate( hDlg ), ::Default()

   METHOD nHeight() INLINE If( ::lDrag == nil, ::lDrag := .f.,),; // Xbase++ requirement
                           If( ::lDrag, ::Super:nHeight(),;
                           If( ! Empty( ::hBitmap ),;
                               nBmpHeight( ::hBitmap ) * ::nZoom, 0 ) )

   METHOD nWidth() INLINE  If( ::lDrag == nil, ::lDrag := .f.,),; // Xbase++ requirement
                           If( ::lDrag, ::Super:nWidth(),;
                           If( ! Empty( ::hBitmap ),;
                               nBmpWidth( ::hBitmap ) * ::nZoom, 0 ) )
   METHOD ScrollUp()
   METHOD ScrollLeft()

   METHOD ScrollDown()

   METHOD ScrollRight()

   METHOD nXExtra() INLINE ::nHeight() - ( ::Super:nHeight() ) + 1
   METHOD nYExtra() INLINE ::nWidth()  - ( ::Super:nWidth() ) + 1

   METHOD VScroll( nWParam, nLParam )
   METHOD HScroll( nWParam, nLParam )

   METHOD HasAlpha() INLINE ::lHasAlpha := .f. // HasAlpha( ::hBitmap )
   METHOD nAlphaLevel( nLevel ) SETGET

   METHOD MouseLeave( nRow, nCol, nFlags )

   METHOD Clear()

   /*
   METHOD Disable() INLINE ;   It paints on the desktop cause hDC is not ready!
                               Also users may not want to see their bitmaps in gray!
      DrawGray( ::GetDC(), ::hBitmap ), ::ReleaseDC(), ::Super:Disable() */

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder,;
            oWnd, bLClicked, bRClicked, lScroll, lStretch, oCursor,;
            cMsg, lUpdate, bWhen, lPixel, bValid, lDesign ) CLASS TBitmap

   #ifdef __XPP__
      #undef New
   #endif

   DEFAULT nTop := 0, nLeft := 0,;
           oWnd := GetWndDefault(),;
           lNoBorder := .f., lScroll := .f., lStretch := .f., lUpdate := .f.,;
           lPixel := .f., lDesign := .f.

   ::nZoom     = 1
   ::hBitmap   = 0
   ::hPalette  = 0
   ::lStretch  = lStretch

   ::LoadImage( cResName, cBmpFile )

   if ! Empty( cResName ) .or. ! Empty( cBmpFile )
      DEFAULT nWidth  := Min( ::nWidth(), oWnd:nWidth() ),;
              nHeight := Min( ::nHeight(), oWnd:nHeight() )

   else
      DEFAULT nWidth  := 100, nHeight := 100

   endif

   #ifdef FWPLUS
      x2RowCol(@nTop, @nLeft, @nHeight, @nWidth, lPixel, Self, oWnd)
      ::nTop   = nTop
      ::nLeft  = nLeft
   #else
      ::nTop   = If( lPixel, nTop, nTop * BMP_CHARPIX_H )   // 14
      ::nLeft  = If( lPixel, nLeft, nLeft * BMP_CHARPIX_W)  // 8
   #endif

   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1
   ::nX        = 0
   ::nY        = 0
   ::nStyle    = nOR( If( ! lNoBorder, WS_BORDER, 0 ),;
                      If( lScroll, nOR( WS_VSCROLL, WS_HSCROLL ), 0 ),;
                      WS_CHILD, WS_VISIBLE, WS_CLIPSIBLINGS,;
                      WS_CLIPCHILDREN, WS_GROUP ) // , WS_TABSTOP )
   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::lCaptured = .f.
   ::lDrag     = lDesign
   ::bLClicked = bLClicked
   ::bRClicked = bRClicked
   ::lScroll   = lScroll
   ::aHotAreas = {}
   ::nVStep    = 1
   ::nHStep    = 1
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bValid    = bValid
   ::lTransparent = .f.

   ::hAlphaLevel = 255

   ::SetColor( GetSysColor( COLOR_WINDOWTEXT ), GetSysColor( COLOR_BTNFACE ) )

   if ! Empty( cBmpFile )
      ::cBmpFile = cBmpFile
   endif

   ::oCursor   = oCursor

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::Default()
      ::lVisible = .t.
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
      ::lVisible  = .f.
   endif

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//
// This method does not create a control, it just creates a bitmap object to
// be used somewhere else.

METHOD Define( cResName, cBmpFile, oWnd, hBitmap ) CLASS TBitmap 

   local aBmpPal

   DEFAULT oWnd := GetWndDefault()

   ::oWnd     = oWnd
   ::nZoom    = 1
   ::hWnd     = 0
   ::hBitmap  = 0
   ::hPalette = 0
   ::lScroll  = .f.

   ::hAlphaLevel = 255

   ::SetColor( GetSysColor( COLOR_WINDOWTEXT ), GetSysColor( COLOR_BTNFACE ) )

   if ! Empty( cResName )
      aBmpPal    = PalBmpLoad( cResName )
      ::hBitmap  = aBmpPal[ 1 ]
      ::hPalette = aBmpPal[ 2 ]
      cBmpFile   = nil
   endif

   if cBmpFile != nil
      cBmpFile = AllTrim( cBmpFile )
   endif

   if ! Empty( cBmpFile ) .and. File( cBmpFile )
      ::cBmpFile = cBmpFile
      aBmpPal = PalBmpRead( If( oWnd != nil, oWnd:GetDC(), 0 ), cBmpFile )
      ::hBitmap  = aBmpPal[ 1 ]
      ::hPalette = aBmpPal[ 2 ]
      If( oWnd != nil, oWnd:ReleaseDC(),)
   endif

   if ! Empty( hBitmap )
      ::hBitmap = hBitmap
   endif   

   if ::hBitmap != 0
      PalBmpNew( 0, ::hBitmap, ::hPalette )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD EraseBkGnd( hDC ) CLASS TBitmap

   if ! Empty( ::bEraseBkGnd )
      return Eval( ::bEraseBkGnd, hDC )
   endif

   if ::hBitmap != 0   // let ::Paint do erasing IF we have an image to display
      return 1
   elseif ::oBrush != nil  // else clear the region
      FillRect( hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )
      return 1
   endif

return nil

//----------------------------------------------------------------------------//

METHOD AdjControls( lDown ) CLASS TBitmap

   local n, oCtl

   DEFAULT lDown := .f.

   if ! Empty( ::aControls ) .and. ::nOldX != ::nX
      if ! lDown
         for n = 1 to Len( ::aControls )
             oCtl = ::aControls[ n ]
             ::aControls[ n ]:Move( oCtl:nTop + ( ::nX - ::nOldX ), oCtl:nLeft )
         next
      else
         for n = Len( ::aControls ) to 1 step -1
             oCtl = ::aControls[ n ]
             ::aControls[ n ]:Move( oCtl:nTop + ( ::nX - ::nOldX ), oCtl:nLeft )
         next
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Center() CLASS TBitmap

   local aRect := ::oWnd:GetCliRect()
   local oRect := TRect():New( aRect:nTop, aRect:nLeft, aRect:nBottom,;
                               aRect:nRight )

   oRect:nTop    := Max( 0, Int( ( aRect:nBottom - ::nHeight ) / 2 ) )
   oRect:nBottom := oRect:nTop  + ::nHeight - 1
   oRect:nLeft   := Max( 0, Int( ( aRect:nRight - ::nWidth ) / 2 ) )
   oRect:nRight  := oRect:nLeft + ::nWidth - 1

   ::SetCoors( oRect )

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TBitmap

   if ::lScroll == nil
      ::lScroll = WndHasScrolls( ::hWnd )
   endif

   if ::lScroll
      DEFINE SCROLLBAR ::oVScroll VERTICAL   OF Self
      DEFINE SCROLLBAR ::oHScroll HORIZONTAL OF Self
      ::ScrollAdjust()
   endif

   // Register the Bitmap for its later destruction on severe error.
   // From resource and file.

   if ::hBitmap != 0
      PalBmpNew( ::hWnd, ::hBitmap, ::hPalette )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD CopyToClipboard() CLASS TBitmap

   local oClipboard := TClipboard():New( CF_BITMAP )

   oClipboard:SetBitmap( Self )

   oClipboard:End()

return nil

//----------------------------------------------------------------------------//

METHOD LoadFromClipboard( oWnd ) CLASS TBitmap

   local oClipboard := TClipboard():New( CF_BITMAP, oWnd )
   local hBitmap    := oClipboard:GetBitmap()
   local lSuccess   := .F.

   if hBitmap != 0
      if ::hBitmap != 0
         PalBmpFree( ::hBitmap, ::hPalette )
         ::hBitmap  = 0
         ::hPalette = 0
      endif

      ::hBitmap  = hBitmap
      ::hPalette = 0  // Where to get it from ?
      PalBmpNew( ::hWnd, hBitmap, 0 )
      ::ScrollAdjust()
      ::nX = 0
      ::nY = 0
      lSuccess = .T.
      ::hBitmap()
   endif


   oClipboard:End()

return lSuccess

//----------------------------------------------------------------------------//

METHOD LoadFromString( cString ) CLASS TBitmap

   local hBmpOld := ::hBitmap
   local hPalOld := ::hPalette

   if Empty( cString )
      return .F.
   endif

   ::hBitmap = CreateMemBitmap( ::GetDC(), cString )
   ::ReleaseDC()

   if ! Empty( hBmpOld )
      PalBmpFree( hBmpOld, hPalOld )
   endif

   PalBmpNew( ::hWnd, ::hBitmap, nil )
   ::HasAlpha()

return .T.

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TBitmap

   if ::hBitmap != 0
      PalBmpFree( ::hBitmap, ::hPalette )
      ::hBitmap  = 0
      ::hPalette = 0
   endif

   if ::oVScroll != nil
      ::oVScroll:End()
   endif

   if ::oHScroll != nil
      ::oHScroll:End()
   endif

   if ::hWnd != 0
      ::Super:Destroy()
   else
      if ::oBrush != nil
         ::oBrush:End()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, cResName, cBmpFile, oWnd, bLClicked, bRClicked,;
                 lScroll, lStretch, oCursor, cMsg, lUpdate, ;
                 bWhen, bValid, lTransparent ) CLASS TBitmap

   DEFAULT lScroll := .f., lStretch := .f., lUpdate := .f., lTransparent := .f.,;
           oWnd := GetWndDefault()

   ::nId       = nId
   ::nX        = 0
   ::nY        = 0
   ::nOldX     = 0
   ::nOldY     = 0
   ::lCaptured = .f.
   ::lDrag     = .f.
   ::bLClicked = bLClicked
   ::bRClicked = bRClicked
   ::lScroll   = lScroll
   ::lStretch  = lStretch
   ::aHotAreas = {}
   ::oCursor   = oCursor
   ::oWnd      = oWnd
   ::nVStep    = 1
   ::nHStep    = 1
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bValid    = bValid
   ::nZoom     = 1
   ::lTransparent = lTransparent

   ::LoadImage( cResName, If( cBmpFile != nil, AllTrim( cBmpFile ), nil ) )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if oWnd != nil
      oWnd:DefControl( Self )
   endif

   // To avoid different background color when desktop large fonts are used

   ::SetColor( GetSysColor( COLOR_WINDOWTEXT ), GetSysColor( COLOR_BTNFACE ) )

return Self

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TBitmap

   if nMsg == WM_MOUSELEAVE
      return ::MouseLeave( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )
   elseif nMsg == WM_NCHITTEST
      return DefWindowProc( ::hWnd, nMsg, nWParam, nLParam )
   endif

return ::Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD MouseLeave( nRow, nCol, nFlags ) CLASS TBitmap

   if ! Empty( ::bMLeave )
      Eval( ::bMLeave, nRow, nCol, nFlags, Self )
   endif

return nil


//----------------------------------------------------------------------------//


METHOD KeyDown( nKey, nFlags ) CLASS TBitmap

   if ::lScroll

      do case
         case nKey == VK_UP
              ::ScrollDown()

         case nKey == VK_DOWN
              ::ScrollUp()

         case nKey == VK_PRIOR
              ::PageUp()

         case nKey == VK_NEXT
              ::PageDown()

         otherwise
              return ::Super:KeyDown( nKey, nFlags )
      endcase
   else
      return ::Super:KeyDown( nKey, nFlags )
   endif

return 0

//----------------------------------------------------------------------------//

METHOD nAlphaLevel( uNew ) CLASS TBitmap

   if uNew != NIL
      ::hAlphaLevel := uNew
   else
      if ::bAlphaLevel != NIL
         ::hAlphaLevel = eval( ::bAlphaLevel, Self )
      endif
   endif

return ::hAlphaLevel

//----------------------------------------------------------------------------//

METHOD PageUp() CLASS TBitmap

   local nVisible := ::Super:nHeight() - If( ::oHScroll:nMax != 0, GetSysMetrics( 3 ), 0 ) - 1

   ::nOldX = ::nX
   if ::nX < -nVisible
      ::nX += nVisible
   else
      ::nX = 0
   endif
   ::Refresh( .f. )
   ::oVScroll:SetPos( Int( -::nX / ::nVStep ) )

   ::AdjControls()

return nil

//----------------------------------------------------------------------------//

METHOD PageDown() CLASS TBitmap

   local nVisible := ::Super:nHeight() - If( ::oHScroll:nMax != 0, GetSysMetrics( 3 ), 0 ) - 1

   ::nOldX = ::nX
   ::nX -= Min( nVisible, ::nHeight() + ::nX - nVisible )
   ::Refresh( .f. )
   ::oVScroll:SetPos( Int( -::nX / ::nVStep ) )

   ::AdjControls()

return nil

//----------------------------------------------------------------------------//

METHOD PageLeft() CLASS TBitmap

   local nVisible := ::Super:nWidth() - If( ::oVScroll:nMax != 0, GetSysMetrics( 2 ), 0 ) - 1

   ::nOldY = ::nY
   if ::nY < -nVisible
      ::nY += nVisible
   else
      ::nY = 0
   endif
   ::Refresh( .f. )
   ::oHScroll:SetPos( Int( -::nY / ::nHStep ) )

   ::AdjControls()

return nil

//----------------------------------------------------------------------------//

METHOD PageRight() CLASS TBitmap

   local nVisible := ::Super:nWidth() - If( ::oVScroll:nMax != 0, GetSysMetrics( 2 ), 0 ) - 1

   ::nOldY = ::nY
   ::nY -= Min( nVisible, ::nWidth() + ::nY - nVisible )
   ::Refresh( .f. )
   ::oHScroll:SetPos( Int( -::nY / ::nHStep ) )

   ::AdjControls()

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TBitmap

   local aInfo := ::DispBegin(), hBmpOld, nZeroZeroClr, nOldClr
   local nAlphaLevel, hBitmap

   if IsAppThemed() .and. Empty( ::oBrush:hBitmap ) .and. ::lTransparent
      if ::oWnd:ClassName() == "TDIALOG"
         DrawPBack( ::hWnd, ::hDC )
      else
         FillRect( ::hDC, GetClientRect( ::hWnd ), ::oWnd:oBrush:hBrush )
      endif
   else
      #ifdef __CLIPPER__
         SetBrushOrgEx( ::hDC, 8 - ::nLeft() % 8, 8 - ::nTop() % 8 )
      #else
         SetBrushOrgEx( ::hDC, nBmpWidth( ::oBrush:hBitmap ) - ::nLeft, nBmpHeight( ::oBrush:hBitmap ) - ::nTop )
      #endif
      FillRect( ::hDC, GetClientRect( ::hWnd ), ::oWnd:oBrush:hBrush )
   endif

   if Empty( ::hBitmap ) .and. ! Empty( ::cBmpFile )
      ::LoadBmp( ::cBmpFile )
   endif

   if ! Empty( ::hBitmap )
      if ::lStretch
         if SetAlpha() .and. ::lHasAlpha
            hBitmap := resizebmp( ::hBitmap, ::Super:nWidth(), ::Super:nHeight )
            ABPaint( ::hDC, ::nX, ::nY, hBitmap, ::nAlphaLevel() )
         else
            if ! ::lTransparent
               PalBmpDraw( ::hDC, ::nX, ::nY, ::hBitmap, ::hPalette,;
                           ::Super:nWidth(), ::Super:nHeight(),, ::lTransparent, ::nClrPane )
            else
               hBmpOld = SelectObject( ::hDC, ::hBitmap )
               nZeroZeroClr = GetPixel( ::hDC, 0, 0 )
               SelectObject( ::hDC, hBmpOld )
               nOldClr = SetBkColor( ::hDC, nRGB( 255, 255, 255 ) )
               TransBmp( ::hBitmap, ::nWidth(), ::nHeight(), nZeroZeroClr, ::hDC,;
                         ::nY, ::nX, ::Super:nWidth(), ::Super:nHeight() )
               SetBkColor( ::hDC, nOldClr )
            endif
         endif
      else
         if ::nZoom > 0
            if SetAlpha() .and. ::lHasAlpha
               hBitmap := resizebmp( ::hBitmap, ::nWidth, ::nHeight )
               ABPaint( ::hDC, ::nX, ::nY, hBitmap, ::nAlphaLevel() )
            else
              if ! ::lTransparent
                  PalBmpDraw( ::hDC, ::nX, ::nY, ::hBitmap, ::hPalette,;
                              ::nWidth(), ::nHeight(),, ::lTransparent, ::nClrPane )
               else
                  hBmpOld = SelectObject( ::hDC, ::hBitmap )
                  nZeroZeroClr = GetPixel( ::hDC, 0, 0 )
                  SelectObject( ::hDC, hBmpOld )
                  nOldClr = SetBkColor( ::hDC, nRGB( 255, 255, 255 ) )
                  TransBmp( ::hBitmap, ::nWidth(), ::nHeight(), nZeroZeroClr, ::hDC,;
                            ::nY, ::nX, ::nWidth(), ::nHeight() )
                  SetBkColor( ::hDC, nOldClr )
               endif
            endif
         endif
      endif
   endif

   if ::bPainted != nil
      Eval( ::bPainted, ::hDC )
   endif

   ::DispEnd( aInfo )

return nil

//---------------------------------------------------------------------------//

METHOD ReLoad( cResName, cBmpFile ) CLASS TBitmap

  local lSuccess := ::LoadImage( cResName, cBmpFile )

  if lSuccess .and. ! Empty( ::hWnd )
     ::ScrollAdjust()
     ::nX = 0
     ::nY = 0
     ::Refresh()
  endif

return lSuccess

//---------------------------------------------------------------------------//

METHOD LoadImage( cResName, cBmpFile ) CLASS TBitmap

   local lChanged := .f.
   local hBmpOld  := ::hBitmap
   local hPalOld  := ::hPalette
   local aBmpPal

   DEFAULT cResName := ::cResName, cBmpFile := ::cBmpFile

   if ! Empty( cResName )
       aBmpPal    = PalBmpLoad( cResName )
       ::hBitmap  = aBmpPal[ 1 ]
       ::hPalette = aBmpPal[ 2 ]
       lChanged   = .T.
       cBmpFile   = nil

    elseif File( cBmpFile )
       if Upper( Right( cBmpFile, 3 ) ) == "PNG"
          ::hBitmap  = FWOpenPngFile( cBmpFile )
          ::hPalette = 0
       else
         aBmpPal = PalBmpRead( ::GetDC(), AllTrim( cBmpFile ) )
         ::hBitmap  = aBmpPal[ 1 ]
         ::hPalette = aBmpPal[ 2 ]
         ::ReleaseDC()
         lChanged   = .T.
         cResName   = nil
      endif
   endif

   if lChanged

      ::cResName = cResName
      ::cBmpFile = cBmpFile

      if ! Empty( hBmpOld )
         PalBmpFree( hBmpOld, hPalOld )
      endif

   endif

  ::HasAlpha()

return lChanged

//----------------------------------------------------------------------------//

METHOD ScrollUp() CLASS TBitmap

   local nVisible := ::Super:nHeight() - If( ::oHScroll:nMax != 0, GetSysMetrics( 3 ), 0 )
   local nStep

   ::nOldX = ::nX
   ::oVScroll:GoDown()

   nStep := ( ::nHeight() + ::nX ) - nVisible

   if ::nHeight() > nVisible
      if ::nX > -::nXExtra() - If( ::oHScroll:nMax != 0, GetSysMetrics( 3 ), 0 )
         ::nX -= Min( nStep, ::nVStep )
         ::Refresh( .f. )
      endif
   endif

   ::AdjControls()

return nil

//----------------------------------------------------------------------------//

METHOD ScrollDown() CLASS TBitmap

   ::nOldX = ::nX

   ::oVScroll:GoUp()
   ::nX := Min( ::nX + ::nVStep, 0 )
   ::Refresh( .f. )

   ::AdjControls( .t. )

return nil

//----------------------------------------------------------------------------//

METHOD ScrollLeft() CLASS TBitmap

   local nVisible := ::Super:nWidth() - If( ::oVScroll:nMax != 0, GetSysMetrics( 2 ), 0 ) - 1
   local nStep, n

   nStep := ( ::nWidth() + ::nY ) - nVisible

   ::oHScroll:GoDown()
   if ::nWidth() > nVisible
      if ::nY > -::nYExtra() - If( ::oVScroll:nMax != 0, GetSysMetrics( 2 ), 0 )
         ::nY -= Min( nStep, ::nHStep )
         ::Refresh( .f. )
      endif
   endif

   if ! Empty( ::aControls )
      for n = Len( ::aControls ) to 1 step -1
          ::aControls[ n ]:Move( ::aControls[ n ]:nTop,;
                                 ::aControls[ n ]:nLeft - 10 )
      next
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ScrollRight() CLASS TBitmap

   local nVisible := ::Super:nWidth() - If( ::oVScroll != nil .and. ;
                     ::oVScroll:nMax != 0, GetSysMetrics( 2 ), 0 ) - 1
   local n

   ::oHScroll:GoUp()
   if ::nWidth() > nVisible
      ::nY := Min( ::nY + ::nHStep, 0 )
      ::Refresh( .f. )
   endif

   if ! Empty( ::aControls )
      for n = Len( ::aControls ) to 1 step -1
          ::aControls[ n ]:Move( ::aControls[ n ]:nTop,;
                                 ::aControls[ n ]:nLeft + 10 )
      next
   endif

return nil

//----------------------------------------------------------------------------//

METHOD VScroll( nWParam, nLParam ) CLASS TBitmap

   #ifdef __CLIPPER__
      local nScrollCode := nWParam
   #else
      local nScrollCode := nLoWord( nWParam )
   #endif

   local nPos := nHiWord( nWParam )

   do case
      case nScrollCode == SB_LINEUP
           ::ScrollDown()

      case nScrollCode == SB_LINEDOWN
           ::ScrollUp()

      case nScrollCode == SB_PAGEUP
           ::PageUp()

      case nScrollCode == SB_PAGEDOWN
           ::PageDown()

      case nScrollCode == SB_TOP
           ::nX = 0
           ::oVScroll:GoTop()
           ::Refresh( .f. )

      case nScrollCode == SB_BOTTOM
           ::nX = ::nXExtra()
           ::oVScroll:GoBottom()
           ::Refresh( .f. )

      // case nScrollCode == SB_THUMBPOSITION
      //     ::oVScroll:SetPos( nPos )
      //     ::Refresh( .f. )
      //     ::oVScroll:ThumbPos( nPos )

      otherwise
           return nil
   endcase

return 0

//----------------------------------------------------------------------------//

METHOD HScroll( nWParam, nLParam ) CLASS TBitmap

   #ifdef __CLIPPER__
      local nScrollCode := nWParam
   #else
      local nScrollCode := nLoWord( nWParam )
   #endif

   local nPos := nHiWord( nWParam )

   do case
      case nScrollCode == SB_LINEUP
           ::ScrollRight()

      case nScrollCode == SB_LINEDOWN
           ::ScrollLeft()

      case nScrollCode == SB_PAGEUP
           ::PageLeft()

      case nScrollCode == SB_PAGEDOWN
           ::PageRight()

      case nScrollCode == SB_TOP
           ::nY = 0
           ::oHScroll:GoTop()
           ::Refresh( .f. )

      case nScrollCode == SB_BOTTOM
           ::nY = ::nYExtra()
           ::oHScroll:GoBottom()
           ::Refresh( .f. )

      // case nScrollCode == SB_THUMBPOSITION
      //     ::oHScroll:SetPos( nPos )
      //     ::Refresh( .f. )
      //     ::oHScroll:ThumbPos( nPos )

      otherwise
           return nil
   endcase

return 0

//----------------------------------------------------------------------------//

METHOD ScrollAdjust() CLASS TBitmap

   local nVisHeight, nVisWidth
   local lHor := .f., lVer := .f.

   nVisHeight = ::Super:nHeight()
   nVisWidth  = ::Super:nWidth()

   if ::lScroll .and. ! Empty( ::hBitmap ) .and. ::oVScroll != nil
      if ::nHeight() <= nVisHeight .or. ::lStretch
         ::oVScroll:SetRange( 0, 0 )
         ::nX = 0
         // ::nY = 0                  bug fixed  19/07
      else
         lVer = .t.
      endif
      if ::nWidth() <= nVisWidth .or. ::lStretch .and. ::oHScroll != nil
         ::oHScroll:SetRange( 0, 0 )
         // ::nX = 0                  bug fixed 19/07
         ::nY = 0
      else
         lHor = .t.
      endif
      if lVer .and. ::oVScroll != nil
         ::oVScroll:SetRange( 0, ( ( ::nXExtra() + ;
                              If( lHor, GetSysMetrics( 3 ), 0 ) ) / ::nVStep ) )
         if ::nX == 0
            ::oVScroll:SetPos( 0 )
         endif
      endif
      if lHor .and. ::oHScroll != nil
         ::oHScroll:SetRange( 0, Int( ( ::nYExtra() + ;
                              If( lVer, GetSysMetrics( 2 ), 0 ) ) / ::nHStep ) )
         if ::nY == 0
            ::oHScroll:SetPos( 0 )
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Zoom( nZoom ) CLASS TBitmap

   if nZoom != nil
      ::nZoom = nZoom
   endif

return ::nZoom

//----------------------------------------------------------------------------//

METHOD Inspect( cData ) CLASS TBitmap

   do case
      case cData == "cBmpFile"
           return { | cFileName | ;
                    cFileName := If( cFileName == nil,;
                    "*.bmp|*.bmp", cFileName + "|*.bmp" ),;
                    cFileName := cGetFile( cFileName,;
                    "Select a BMP file" ), ::LoadImage( ,cFileName ),;
                    cFileName }
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD Clear() CLASS TBitmap

   if ! Empty( ::hBitmap )
      PalBmpFree( ::hBitmap, ::hPalette )
      ::hBitmap := ::hPalette := 0
      ::cBmpFile := ::cResName := nil
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

function PalBmpFree( hBmp, hPal )

   DeleteObject( hBmp )
   DeleteObject( hPal )

return nil

//------------------------------------------------------------------//

