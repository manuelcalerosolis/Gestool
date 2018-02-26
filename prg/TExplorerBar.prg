#include "FiveWin.ch"

//----------------------------------------------------------------------------//

// Class TExplorerBar

#define COLOR_BTNFACE    15

#define TME_LEAVE         2
#define WM_MOUSELEAVE   675

//Bitmap Array Columns

#define BMP_HANDLE         1
#define BMP_BRIGHT         2
#define BMP_HASALPHA       3
#define BMP_WIDTH          4
#define BMP_HEIGHT         5

//Bitmap Array position
#define BMPDEFAULT         0
#define BMPEXPAND          1
#define BMPCOLLAP          2

#define GWL_STYLE       (-16)
#define D_HEIGHT           13

//----------------------------------------------------------------------------//

CLASS TExplorerBar FROM TControl

   DATA aPanels         INIT {}
   DATA nTopColor       INIT RGB( 122, 161, 230 )
   DATA nBottomColor    INIT RGB( 99, 117, 214 )
   DATA oVScroll
   DATA nVPos
   DATA nVirtualHeight
   DATA nVirtualTop
   DATA lSBVisible

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CONSTRUCTOR

   METHOD Redefine( nId, oDlg )

   METHOD AddPanel( cName, cBmpName )

   METHOD CheckScroll( oPanel )

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD Paint()
   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD Initiate( hDlg )

   METHOD Notify( nIdCtrl, nPtrNMHDR ) INLINE ::oWnd:Notify( nIdCtrl, nPtrNMHDR )

   METHOD ReSize( nSizeType, nWidth, nHeight )

   METHOD VScrollSetPos( nPos )
   METHOD VScrollSkip( nSkip )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CLASS TExplorerBar

   DEFAULT oWnd := GetWndDefault(),;
           nTop := 0, nLeft := 0, nHeight := oWnd:nHeight(), nWidth := oWnd:nWidth()

   ::lUnicode  = FW_SetUnicode()
   ::nTop    = nTop
   ::nLeft   = nLeft
   ::nBottom = nHeight - nTop
   ::nRight  = nWidth - nLeft
   ::oWnd    = oWnd
   ::nStyle  = nOr( WS_CHILD, WS_VISIBLE, WS_CLIPCHILDREN, WS_TABSTOP )
   ::lDrag   = .F.
   ::nClrPane = GetSysColor( COLOR_BTNFACE )

   ::nVirtualTop = 0
   ::nVirtualHeight = 0

   ::Register()

   if ! Empty( ::oWnd:hWnd )
      ::Create()
      ::oWnd:AddControl( Self )
      if ::oWnd:oBrush != nil
         ::SetBrush( ::oWnd:oBrush )
      endif
   else
      ::oWnd:DefControl( Self )
   endif

   DEFINE SCROLLBAR ::oVScroll VERTICAL OF Self

   ::oVScroll:bGoUp     = {|| ::VScrollSkip( - 10 ) }
   ::oVScroll:bGoDown   = {|| ::VScrollSkip( 10 ) }
   ::oVScroll:bPageUp   = {|| ::VScrollSkip( - ::oVScroll:nPgStep ) }
   ::oVScroll:bPageDown = {|| ::VScrollSkip( ::oVScroll:nPgStep ) }
   ::oVScroll:bPos      = {|nPos| ::VScrollSetPos( nPos ) }
   ::oVScroll:bTrack    = {|nPos| ::VScrollSetPos( nPos ) }

RETURN Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oDlg ) CLASS TExplorerBar

   DEFAULT oDlg := GetWndDefault()

   ::lUnicode  = FW_SetUnicode()
   ::nId      = nId
   ::oWnd     = oDlg
   ::lDrag    = .F.
   ::nClrPane = GetSysColor( COLOR_BTNFACE )
   ::nVirtualTop = 0
   ::nVirtualHeight = 0

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   oDlg:DefControl( Self )

RETURN Self

//----------------------------------------------------------------------------//

METHOD AddPanel( cName, cBmpName, nBodyHeight ) CLASS TExplorerBar

   local oPanel

   oPanel := AAdd( ::aPanels, TTaskPanel():New( cName, Self, Len( ::aPanels ), cBmpName, nBodyHeight ) )

   ::CheckScroll( oPanel )

RETURN oPanel

//----------------------------------------------------------------------------//

METHOD CheckScroll() CLASS TExplorerBar

   local nLastRow
   local oLastItem
   local nPos

   oLastItem = ATail( ::aPanels )

   nLastRow = ::nVirtualTop + oLastItem:nTop + ;
              If( ! oLastItem:lCollapsed, oLastItem:nTotalHeight,;
                  oLastItem:nTitleHeight )

   if nLastRow > ::nHeight - ::nVirtualTop
      ::nVirtualHeight = nLastRow
      SetScrollRangeX( ::hWnd, 1, 0, ::nVirtualHeight - 1 )

      ::oVScroll:SetPage( ::nHeight, .F. )
      ::oVScroll:SetPos( ::nVirtualTop )
      ::lSBVisible = .T.
   else
      ::nVirtualTop = 0
      ::nVirtualHeight = ::nHeight
      SetScrollRangeX( ::hWnd, 1, 0, 0 )
      ::lSBVisible = .F.
   endif

RETURN nil

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TExplorerBar

   local uValue := ::Super:Initiate( hDlg )

   __ChangeStyleWindow( ::hWnd, WS_CLIPCHILDREN, GWL_STYLE, .T. )

RETURN uValue

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TExplorerBar

   local aInfo := ::DispBegin(), n, hBmpPanel

   Gradient( ::hDC, { 0, 0, ::nHeight(), ::nWidth() }, ::nTopColor, ::nBottomColor, .T. )

   if ! Empty( ::aPanels )
      for n = 1 to Len( ::aPanels )
          if ! Empty( hBmpPanel := ::aPanels[ n ]:hBmpPanel )
             if ::aPanels[ n ]:lHasAlpha
                ABPaint( ::hDC, ;
                 ::aPanels[ n ]:nLeft - ( nBmpWidth( hBmpPanel ) / 3 ),;
                 ::aPanels[ n ]:nTop - ( nBmpHeight( hBmpPanel ) / 3 ),;
                 hBmpPanel, 255 )
             else
                DrawTransparent( ::hDC, hBmpPanel, ::aPanels[ n ]:nTop - ( nBmpHeight( hBmpPanel ) / 3 ),;
                              ::aPanels[ n ]:nLeft - ( nBmpWidth( hBmpPanel ) / 3 ) )
            endif
          endif
      next
   endif

   if ValType( ::bPainted ) == "B"
      Eval( ::bPainted, ::hDC, ::cPS, Self )
   endif

   ::DispEnd( aInfo )

RETURN 0

//----------------------------------------------------------------------------//

METHOD ReSize( nSizeType, nWidth, nHeight ) CLASS TExplorerBar

   local oPanel

   ::CoorsUpdate()

   if nHeight > ::nVirtualHeight
      ::nVirtualHeight = nHeight
      for each oPanel in ::aPanels
         oPanel:nWidth = nWidth - oPanel:nLeftMargin - ;
                                 oPanel:nRightMargin // - GetSysMetrics( 2 )

         oPanel:nTop += ::nVirtualTop
         oPanel:CoorsUpdate()
         oPanel:UpdateRegion()
      next
      ::nVirtualTop = 0

   else
      for each oPanel in ::aPanels
         oPanel:nWidth = nWidth - oPanel:nLeftMargin - ;
                                 oPanel:nRightMargin // - GetSysMetrics( 2 )

         if nHeight + ::nVirtualTop > ::nVirtualHeight .and. ::nVirtualTop > 0
            oPanel:nTop += nHeight + ::nVirtualTop - ::nVirtualHeight
         endif

         oPanel:CoorsUpdate()
         oPanel:UpdateRegion()
      next
      if nHeight + ::nVirtualTop > ::nVirtualHeight .and. ::nVirtualTop > 0
         ::nVirtualTop -= ( nHeight + ::nVirtualTop - ::nVirtualHeight )
      endif
   endif
   ::CheckScroll()

//   ::oWnd:cTitle = Time() + Str( nHeight )
RETURN ::Super:ReSize( nSizeType, nWidth, nHeight )

//----------------------------------------------------------------------------//

METHOD VScrollSetPos( nPos ) CLASS TExplorerBar

   LOCAL nHeight := ( ::nVirtualHeight - ::nHeight )
   LOCAL oPanel
   LOCAL nAdvance := ::nVirtualTop - nPos
   LOCAL nTop

   ::nVirtualTop = nPos

   IF ::nVirtualTop < 0
      ::nVirtualTop := 0
   ELSEIF ::nVirtualTop > nHeight
      ::nVirtualTop := nHeight
   ENDIF
   ::oVScroll:SetPos( ::nVirtualTop )

   for each oPanel in ::aPanels
      nTop := oPanel:nTop + nAdvance
      oPanel:Move( nTop )
   next

   ::Refresh()

RETURN nil

//----------------------------------------------------------------------------//

METHOD VScrollSkip( nSkip ) CLASS TExplorerBar

   LOCAL oPanel
   LOCAL nHeight := ( ::nVirtualHeight - ::nHeight )

   IF (::nVirtualTop == 0 .And. nSkip < 0) .Or. ;
      (::nVirtualTop == nHeight .And. nSkip > 0)
      RETURN nil
   ENDIF

   ::nVirtualTop += nSkip

   IF ::nVirtualTop < 0
      ::nVirtualTop := 0
   ELSEIF ::nVirtualTop > nHeight
      ::nVirtualTop := nHeight
   ENDIF
   ::oVScroll:SetPos( ::nVirtualTop )

   for each oPanel in ::aPanels
      oPanel:Move( oPanel:nTop - nSkip )
   next

   ::Refresh()

RETURN nil

//----------------------------------------------------------------------------//

CLASS TTaskPanel FROM TControl

   DATA   cTitle, nIndex
   DATA   nTopMargin, nLeftMargin, nRightMargin INIT 16
   DATA   nTitleHeight    INIT 25
   DATA   nBodyHeight     //INIT 50
   DATA   lCollapsed      INIT .F.
   DATA   lOverTitle      INIT .F.
   DATA   lHasAlpha       INIT .F.
   DATA   aLinks          INIT {}
   DATA   nClrHover       INIT RGB( 0, 0, 0 )
   DATA   hRegion
   DATA   aBitmaps
   DATA   hBmpPanel

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( cTitle, oWnd, nIndex, cBmpPanel )
   METHOD AddLink( cPrompt, bAction, cBitmap )
   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0
   METHOD Destroy()
   METHOD End()       INLINE ::Destroy()
   METHOD EraseBkGnd( hDC ) INLINE 1
   METHOD Paint()
   METHOD HandleEvent()
   METHOD nTotalHeight() INLINE ::nTitleHeight + ::nBodyHeight
   METHOD KeyDown( nKey, nFlags )
   METHOD LButtonUp( nRow, nCol, nFlags )
   METHOD LoadBitmaps()
   METHOD MouseMove( nRow, nCol, nFlags )
   METHOD MouseLeave( nRow, nCol, nFlags )
   METHOD UpdateRegion()
   METHOD SetPanelBitmap( cnBmp )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cTitle, oWnd, nIndex, cBmpPanel, nBodyHeight ) CLASS TTaskPanel

   local n

   DEFAULT nBodyHeight  := 50

   ::lUnicode           := FW_SetUnicode()
   ::cTitle             := cTitle
   ::nTop               := ::nTopMargin

   ::nBodyHeight        := nBodyHeight

   if nIndex > 0
      ::nTop += oWnd:aPanels[ nIndex ]:nTop 
      ::nTop += oWnd:aPanels[ nIndex ]:nTotalHeight 
      ::nTop += oWnd:aPanels[ nIndex ]:nTopMargin
   endif

   ::nLeft   = ::nLeftMargin
   ::nBottom = ::nTop + ::nTotalHeight()
   ::nRight  = oWnd:nWidth - ::nRightMargin
   ::oWnd    = oWnd
   ::nStyle  = nOr( WS_CHILD, WS_VISIBLE, WS_CLIPCHILDREN, WS_TABSTOP )
   ::lDrag   = .F.
   ::nClrPane = nRGB( 214, 223, 247 )
   ::nClrText = nRGB( 0, 0, 0 )
   ::nIndex  = nIndex + 1
   ::LoadBitmaps()

   ::SetPanelBitmap( cBmpPanel )

   DEFINE FONT ::oFont NAME "Tahoma" SIZE 0, -11

   ::Register()

   if ! Empty( ::oWnd:hWnd )
      ::Create()
      ::oWnd:AddControl( Self )
      ::UpdateRegion()
   else
      ::oWnd:DefControl( Self )
   endif

   ::SetColor( ::nClrText, ::nClrPane )

RETURN Self

//----------------------------------------------------------------------------//

METHOD AddLink( cPrompt, bAction, cBitmap ) CLASS TTaskPanel

   local nTop := ::nTitleHeight + 10, n, oUrlLink

   if ! Empty( ::aControls )
      for n = 1 to Len( ::aControls )
         nTop += ::aControls[ n ]:nHeight + 7
      next
   endif

   oUrlLink := TUrlLink():New( nTop, 33, Self, .T., .F., ::oFont, "", cPrompt )

   oUrlLink:SetColor( ::nClrHover, ::nClrPane )
   oUrlLink:nClrOver = ::nClrHover
   oUrlLink:bAction = bAction

   if File( cBitmap )
      oUrlLink:hBmp = ReadBitmap( 0, cBitmap )
   else
      oUrlLink:hBmp = LoadBitmap( GetResources(), cBitmap )
   endif

   if oUrlLink:nTop + oUrlLink:nHeight > ::nHeight
      ::nHeight      := oUrlLink:nTop + oUrlLink:nHeight + 10
      ::nBodyHeight  := ::nHeight - ::nTitleHeight
      ::UpdateRegion()
   endif

RETURN nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TTaskPanel

   AEval( ::aBitmaps,;
          { | aItem | DeleteObject( aItem[ BMP_HANDLE ] ),;
                      DeleteObject( aItem[ BMP_BRIGHT ] ) } )

   DeleteObject( ::hBmpPanel )

   DeleteObject( ::hRegion )

RETURN ::Super:Destroy()

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TTaskPanel

   if nMsg == WM_MOUSELEAVE
      RETURN ::MouseLeave( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )
   endif

RETURN ::Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TTaskPanel

   if nKey == VK_TAB
      if GetKeyState( VK_SHIFT )
         ::oWnd:GoPrevCtrl()
      else
         ::oWnd:GoNextCtrl()
      endif
      SysRefresh()
      ::Refresh()
      if GetParent( GetFocus() ) == ::oWnd:hWnd
         oWndFromHwnd( GetFocus() ):Refresh()
      endif
   endif

RETURN nil

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TTaskPanel

   local n, hWndFocus

   if nRow < ::nTitleHeight
      if ( ::lCollapsed := ::nHeight > ::nTitleHeight )
         ::nHeight = ::nTitleHeight
         for n = ::nIndex + 1 to Len( ::oWnd:aPanels )
            ::oWnd:aPanels[ n ]:nTop -= ::nBodyHeight
         next
      else
         ::nHeight = ::nTotalHeight()
         for n = ::nIndex + 1 to Len( ::oWnd:aPanels )
            ::oWnd:aPanels[ n ]:nTop += ::nBodyHeight
         next
      endif
      if ( hWndFocus := GetFocus() ) != ::hWnd
         SetFocus( ::hWnd )
      endif
      ::oWnd:Refresh()
      AEval( ::oWnd:aPanels, { | o | o:Refresh() } )

      ::oWnd:CheckScroll()
   endif

RETURN nil

//----------------------------------------------------------------------------//

METHOD LoadBitmaps( nType, cnBitmap ) CLASS TTaskPanel

   local nWidth, nHeight, lHasAlpha
   local hBitmap

   DEFAULT nType := BMPDEFAULT

   if nType > BMPCOLLAP .OR. nType < BMPDEFAULT
      RETURN nil
   endif

   if nType == BMPDEFAULT
      ::aBitmaps = {}
      hBitmap = fwBmpDes()
      AAdd( ::aBitmaps, { hBitmap, 0, HasAlpha( hBitmap ), nBmpWidth( hBitmap ), nBmpHeight( hBitmap ) } )
      ::aBitmaps[ BMPEXPAND ][ BMP_BRIGHT ] = BrightImg( ::hDC, hBitmap, 90 )
      hBitmap = fwBmpAsc()
      AAdd( ::aBitmaps, { hBitmap, 0, HasAlpha( hBitmap ), nBmpWidth( hBitmap ), nBmpHeight( hBitmap ) } )
      ::aBitmaps[ BMPCOLLAP ][ BMP_BRIGHT ] = BrightImg( ::hDC, hBitmap, 90 )
   else
      if File( cnBitmap )
         hBitmap = ReadBitmap( 0, cnBitmap )
      else
         hBitmap = LoadBitmap( GetResources(), cnBitmap )
      endif
      nWidth  = nBmpWidth( hBitmap )
      nHeight = nBmpHeight( hBitmap )
      lHasAlpha = HasAlpha( hBitmap )
      DeleteObject( ::aBitmaps[ nType ][ BMP_HANDLE ] )
      DeleteObject( ::aBitmaps[ nType ][ BMP_BRIGHT ] )
      ::aBitmaps[ nType ] = { hBitmap, , lHasAlpha, nWidth, nHeight }
      ::aBitmaps[ nType ][ BMP_BRIGHT ] = BrightImg( ::hDC, hBitmap, 2 )
   endif

RETURN nil

//----------------------------------------------------------------------------//

METHOD MouseLeave( nRow, nCol, nFlags ) CLASS TTaskPanel

   ::lOverTitle = .F.
   ::Refresh()

RETURN nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nFlags ) CLASS TTaskPanel

   if ( ::lOverTitle := nRow < ::nTitleHeight )
      CursorHand()
   else
      CursorArrow()
   endif

   ::Refresh()

   ::SetMsg( ::cMsg )
   ::CheckToolTip()

   if ::bMMoved != nil
      RETURN Eval( ::bMMoved, nRow, nCol, nFlags )
   endif

   TrackMouseEvent( ::hWnd, TME_LEAVE )

RETURN 0

//----------------------------------------------------------------------------//

METHOD Paint( nIndex ) CLASS TTaskPanel

   local aInfo := ::DispBegin(), oItem, n

   Gradient( ::hDC, { 0, 0, ::nTitleHeight, ::nWidth }, nRGB( 240, 240, 240 ), nRGB( 240, 240, 240 ), .f. )

   ::Say( 6, 15 + if( !empty( ::hBmpPanel ), nBmpWidth( ::hBmpPanel ) / 2, 0 ), ::cTitle, ::nClrHover, , ::oFont, .t., .t. )

   fillRect( ::hDC,;
             { ::nTitleHeight, 0, ::nTitleHeight + ::nBodyHeight + 1, ::nWidth },;
             ::oBrush:hBrush )

   if ::lCollapsed
      if ::aBitmaps[ BMPEXPAND ][ BMP_HASALPHA ]
        ABPaint( ::hDC, ;
                 ::nWidth - ::aBitmaps[ BMPEXPAND ][ BMP_WIDTH ] * 1.5, 4,;
                 ::aBitmaps[ BMPEXPAND ][ BMP_HANDLE ],;
                 255 )
      else
        DrawTransparent( ::hDC, ::aBitmaps[ BMPEXPAND ][ BMP_HANDLE ],;
                         4, ::nWidth - ::aBitmaps[ BMPEXPAND ][ BMP_WIDTH ] * 1.5 )
      endif
   else
      if ::aBitmaps[ BMPCOLLAP ][ BMP_HASALPHA ]
        ABPaint( ::hDC, ;
                 ::nWidth - ::aBitmaps[ BMPCOLLAP ][ BMP_WIDTH ] * 1.5, 4,;
                 ::aBitmaps[ BMPCOLLAP ][ BMP_HANDLE ], ;
                 255 )
      else
        DrawTransparent( ::hDC, ::aBitmaps[ BMPCOLLAP ][ BMP_HANDLE ],;
                         4, ::nWidth - ::aBitmaps[ BMPCOLLAP ][ BMP_WIDTH ] * 1.5 )
      endif
   endif
//
//   if GetFocus() == ::hWnd
//      FrameDot( ::hDC, 2, 3, ::nTitleHeight - 2, ::nWidth - 5 )
//   endif

   if ! Empty( ::aControls )
      for n = 1 to Len( ::aControls )
         oItem = ::aControls[ n ]
         if oItem:ClassName == "TURLLINK" .and. ! Empty( oItem:hBmp )
            DrawTransparent( ::hDC, oItem:hBmp, oItem:nTop - 2,;
                             oItem:nLeft - nBmpWidth( oItem:hBmp ) - 3 )
         endif
      next
   endif

   if ::hBmpPanel != 0

      if ::lHasAlpha
         ABPaint( ::hDC, ;
          - nBmpWidth( ::hBmpPanel ) / 3,;
          - nBmpHeight( ::hBmpPanel ) / 3,;
          ::hBmpPanel, 255 )
      else
         DrawTransparent( ::hDC, ::hBmpPanel,  - nBmpHeight( ::hBmpPanel ) / 3,;
                          - nBmpWidth( ::hBmpPanel ) / 3 )
      endif

   endif
   if ! Empty( ::aControls )
      AEval( ::aControls, { | oControl | oControl:Refresh() } )
   endif

   ::DispEnd( aInfo )

RETURN 0

//----------------------------------------------------------------------------//

METHOD SetPanelBitmap( cnBitmap, hInstance ) CLASS TTaskPanel

   ::hBmpPanel = fnAddBitmap( cnBitmap, hInstance )

   ::lHasAlpha = HasAlpha( ::hBmpPanel )

RETURN nil

//----------------------------------------------------------------------------//

METHOD UpdateRegion() CLASS TTaskPanel
/*
   if ! Empty( ::hRegion )
      DeleteObject( ::hRegion )
      ::hRegion = nil
   endif

   ::hRegion = CreateRoundRectRgn( { 0, 0, ::nTitleHeight + ::nBodyHeight + 4,;
                                   ::nWidth }, 6, 6 )
   SetWindowRgn( ::hWnd, ::hRegion )
*/
RETURN nil

//----------------------------------------------------------------------------//
