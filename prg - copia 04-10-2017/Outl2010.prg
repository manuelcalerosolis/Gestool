#include "FiveWin.ch"

//----------------------------------------------------------------------------//

#define COLOR_WINDOW         5
#define COLOR_BTNFACE       15
#define TME_LEAVE            2
#define WM_MOUSELEAVE      675

#define LIGHTBLUE    nRGB(  89, 135, 214 )
#define DARKBLUE     nRGB(   3,  56, 147 )
#define LIGHTORANGE1 nRGB( 250, 227, 143 )
#define DARKORANGE1  nRGB( 238, 152, 25 )
#define LIGHTCYAN    nRGB( 203, 225, 252 )
#define DARKCYAN     nRGB( 125, 165, 224 )
#define LIGHTORANGE2 nRGB( 255, 255, 220 )
#define DARKORANGE2  nRGB( 247, 192, 91 )

CLASS TOutLook2010 FROM TControl

   DATA  oHeader
   DATA  aGroups, aDialogs
   DATA  oFontHeader
   DATA  oFontGroup
   DATA  nOver
   DATA  bChange
   DATA  nOption
   DATA  hBmpDots
   DATA  oPopup

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( oWnd, aPrompts, aBmpNames, bChange )
   METHOD Redefine( nId, oWnd, aPrompts, aBmpNames, bChange, aDialogs )
   METHOD Paint()
   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0
   METHOD EraseBkGnd( hDC ) INLINE 1
   METHOD AddGroup( cPrompt, cBitmap )
   METHOD AtGroup( nRow, nCol )
   METHOD BuildPopup()
   METHOD Default()
   METHOD Initiate( hDlg )
   METHOD MouseMove( nRow, nCol, nFlags )
   METHOD LButtonDown( nRow, nCol, nFlags )
   METHOD Destroy()
   METHOD HandleEvent( nMsg, nWParam, nLParam )
   METHOD MouseLeave( nRow, nCol, nFlags )
   METHOD SetOption( nOption )
   METHOD AdjustDialogs( nWidth, nHeight )
   METHOD SetPopup( oPopup ) INLINE ::oPopup:End(), ::oPopup := oPopup

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, aPrompts, aBmpNames, bChange )

   local n, oDlg

   DEFAULT oWnd := GetWndDefault()

   ::nTop    = 0
   ::nLeft   = 0
   ::nBottom = oWnd:nBottom
   ::nRight  = 190
   ::oWnd    = oWnd
   ::nStyle  = nOr( WS_CHILD, WS_VISIBLE, WS_BORDER )
   ::lDrag   = .f.
   ::nClrPane = nRGB( 220, 223, 228 )
   ::aGroups = {}
   ::bChange = bChange
   ::aDialogs = {}
   ::bResized = { | nType, nWidth, nHeight | ::AdjustDialogs( nWidth, nHeight ) }
   ::nOption  = 1
   ::hBmpDots = BmpOLDots()
   ::oPopup   = ::BuildPopup()

   ::Register()

   if ! Empty( ::oWnd:hWnd )
      ::Create()
      ::oWnd:AddControl( Self )
   else
      ::oWnd:DefControl( Self )
   endif

   ::oWnd:oLeft = Self

   DEFINE FONT ::oFontHeader NAME "Verdana" SIZE 0, -16 BOLD
   DEFINE FONT ::oFontGroup  NAME "Verdana" SIZE 0, -12 BOLD

   ::oHeader = TOutLook2010Group():New( "", Self )

   if ! Empty( aPrompts )
      for n = 1 to Len( aPrompts )
         if ! Empty( aBmpNames ) .and. n <= Len( aBmpNames )
            ::AddGroup( aPrompts[ n ], aBmpNames[ n ] )
         else
            ::AddGroup( aPrompts[ n ] )
         endif
      next
   endif

   for n = 1 to Len( ::aGroups )
      DEFINE DIALOG oDlg OF Self STYLE WS_CHILD  ;
         FROM 33, 0 TO ::nHeight - ( Len( ::aGroups ) * 32 ), ::nWidth() - 1 PIXEL ;
         FONT Self:oFont
      AAdd( ::aDialogs, oDlg )
   next

   if ! Empty( oWnd:hWnd )
      ::Default()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, aPrompts, aBmpNames, bChange, aDialogs ) CLASS TOutLook2010

   local n, oDlg, oFont

   DEFAULT aDialogs := Array( Len( aPrompts ) ), oWnd := GetWndDefault(), aBmpNames := {}

   ::nId      = nId
   ::oWnd     = oWnd
   ::aGroups  = {}
   ::aDialogs = {}
   ::bChange  = bChange
   ::nClrPane = nRGB( 0, 45, 150 )
   ::hBmpDots = BmpOLDots()
   ::oPopup   = ::BuildPopup()

   ::Register()

   DEFINE FONT ::oFontHeader NAME "Verdana" SIZE 0, -16 BOLD
   DEFINE FONT ::oFontGroup  NAME "Verdana" SIZE 0, -12 BOLD

   ::oHeader = TOutLook2010Group():New( "", Self )

   if ! Empty( aPrompts )
      for n = 1 to Len( aPrompts )
         if ! Empty( aBmpNames ) .and. n <= Len( aBmpNames )
            ::AddGroup( aPrompts[ n ], aBmpNames[ n ] )
         else
            ::AddGroup( aPrompts[ n ] )
         endif
      next
   endif

   oFont = TFont():New( GetSysFont(), 0, -9 )

   for n = 1 to Len( aPrompts )
      DEFINE DIALOG oDlg OF Self RESOURCE aDialogs[ n ] FONT oFont
      AAdd( ::aDialogs, oDlg )
   next

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Default() CLASS TOutLook2010

   local oDlg, n

   ::SetColor( ::nClrText, ::nClrPane )

   for n = 1 to Len( ::aDialogs )
      oDlg = ::aDialogs[ n ]

      ACTIVATE DIALOG oDlg NOWAIT ;
         ON INIT oDlg:Move( 33, 0 ) ;
         VALID .F.                // to avoid exiting pressing Esc !!!

      if IsAppThemed()
         if Empty( oDlg:oBrush:hBitmap )
            // oDlg:bEraseBkGnd = { | hDC | DrawPBack( oDlg:hWnd, hDC ), 1 }
         endif
      endif

      oDlg:Hide()
   next

   if Len( ::aDialogs ) > 0
      ::aDialogs[ 1 ]:Show()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TOutLook2010

   Super:Initiate( hDlg )

   ::Default()
   ::AdjustDialogs()

return nil

//----------------------------------------------------------------------------//

METHOD AddGroup( cPrompt, cBitmap ) CLASS TOutLook2010

  AAdd( ::aGroups, TOutLook2010Group():New( cPrompt, Self, cBitmap ) )

  if Empty( ::oHeader:cPrompt )
     ::oHeader:cPrompt = cPrompt
  endif

return nil

//----------------------------------------------------------------------------//

METHOD BuildPopup() CLASS TOutLook2010

   local oPopup

   MENU oPopup POPUP 2007
      MENUITEM "Show &More Buttons"
      MENUITEM "Show &Fewer Buttons"
      MENUITEM "Na&vigation Pane Options..."
      SEPARATOR
      MENUITEM "&Add or Remove Buttons"
   ENDMENU

return oPopup

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TOutLook2010

   local n, nTop
   local aInfo := ::DispBegin()

   FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )

   ::oHeader:Paint()

   // Grab bar
   nTop = ::nHeight - ( Len( ::aGroups ) * 32 ) - 7
   Gradient( ::hDC, { nTop, 0, nTop + 7, ::nWidth() }, DARKBLUE, LIGHTBLUE, .T. )
   DrawTransparent( ::hDC, ::hBmpDots, nTop + 2, ( ::nWidth() / 2 ) - ( nBmpWidth( ::hBmpDots ) / 2 ) )

   if Len( ::aGroups ) > 0
      for n = 1 to Len( ::aGroups )
         ::aGroups[ n ]:Paint()
      next
   endif

   ::DispEnd( aInfo )

return nil

//----------------------------------------------------------------------------//

METHOD AtGroup( nRow, nCol ) CLASS TOutLook2010

   local nGroupsArea := ::nHeight - ( Len( ::aGroups ) * 32 )

   if nRow > nGroupsArea
      return Len( ::aGroups ) - Int( ( ::nHeight - nRow ) / 32 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nFlags ) CLASS TOutLook2010

   local nGroup := ::AtGroup( nRow, nCol )

   if nGroup == nil
      CursorArrow()
      if ::nOver != nil
         ::aGroups[ ::nOver ]:Paint()
         ::nOver = nil
      endif
   endif

   if nGroup != nil .and. nGroup != ::nOver
      if ::nOver != nil
         ::aGroups[ ::nOver ]:Paint()
      endif
      ::aGroups[ nGroup ]:Paint( .T. )
      ::nOver = nGroup
      CursorHand()
   endif

   TrackMouseEvent( ::hWnd, TME_LEAVE )

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TOutLook2010

   local nGroup := ::AtGroup( nRow, nCol )

   if nGroup != nil
      ::SetOption( nGroup )
      if nCol > ::nWidth - 30 .and. nCol < ::nWidth
         if nGroup == Len( ::aGroups )
            ::oPopup:Activate( ::nHeight, ::nWidth + 1, Self, .F., 32 )
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TOutLook2010

   local n

   ::oFontHeader:End()
   ::oFontGroup:End()

   for n = 1 to Len( ::aDialogs )
      ::aDialogs[ n ]:bValid = nil
      ::aDialogs[ n ]:End()
   next

   DeleteObject( ::hBmpDots )

   for n = 1 to Len( ::aGroups )
      ::aGroups[ n ]:Destroy()
   next
   ::oHeader:Destroy()
   ::oPopup:End()

return Super:Destroy()

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TOutLook2010

   if nMsg == WM_MOUSELEAVE
      return ::MouseLeave( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )
   endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD MouseLeave( nRow, nCol, nFlags ) CLASS TOutLook2010

   if ::nOver != nil
      ::aGroups[ ::nOver ]:Paint()
      ::nOver = nil
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetOption( nOption ) CLASS TOutLook2010

   local nOldOption := AScan( ::aGroups, { | o | o:lSelected } )

   if nOption > 0 .and. nOption != nOldOption
      ::aGroups[ nOldOption ]:lSelected = .F.
      ::aGroups[ nOldOption ]:nClrStart = LIGHTCYAN
      ::aGroups[ nOldOption ]:nClrEnd   = DARKCYAN
      ::aGroups[ nOldOption ]:Paint()
      ::aGroups[ nOption ]:lSelected = .T.
      ::aGroups[ nOption ]:nClrStart = LIGHTORANGE1
      ::aGroups[ nOption ]:nClrEnd   = DARKORANGE1
      ::aGroups[ nOption ]:Paint( .T. )
      ::oHeader:cPrompt = ::aGroups[ nOption ]:cPrompt
      ::oHeader:Paint()

      if nOldOption <= Len( ::aDialogs ) .and. ::aDialogs[ nOldOption ] != nil
         ::aDialogs[ nOldOption ]:Hide()
      endif

      if nOption <= Len( ::aDialogs ) .and. ::aDialogs[ nOption ] != nil
         ::nOption = nOption
         if ::bChange != nil
            Eval( ::bChange, nOption, nOldOption )
         endif
         ::aDialogs[ nOption ]:AEvalWhen()
         ::aDialogs[ nOption ]:Show()
         ::aDialogs[ nOption ]:SetFocus()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD AdjustDialogs( nWidth, nHeight ) CLASS TOutLook2010

   local n

   DEFAULT nWidth := ::nWidth, nHeight := ::nHeight;

   nHeight := Max( 0, nHeight - 6 - ( ( Len( ::aGroups ) + 1 ) * 32 ) )

   for n = 1 to Len( ::aDialogs )
      ::aDialogs[ n ]:SetSize( nWidth, nHeight )
   next

return nil

//----------------------------------------------------------------------------//

CLASS TOutLook2010Group

   DATA   cPrompt
   DATA   hBmp, hBmpArrow
   DATA   lSelected, lHeader
   DATA   nClrStart, nClrEnd, nClrText
   DATA   oContainer

   METHOD New( cPrompt, oContainer, cBitmap )
   METHOD Paint( lOver )
   METHOD Destroy()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPrompt, oContainer, cBitmap ) CLASS TOutLook2010Group

   ::cPrompt    = cPrompt
   ::oContainer = oContainer
   ::lHeader    = ( ::oContainer:oHeader == nil )
   ::lSelected  = ! ::lHeader .and. Len( ::oContainer:aGroups ) == 0
   ::nClrStart  = If( ::lHeader, LIGHTBLUE, If( ::lSelected, LIGHTORANGE1, LIGHTCYAN ) )
   ::nClrEnd    = If( ::lHeader, DARKBLUE, If( ::lSelected, DARKORANGE1, DARKCYAN ) )
   ::nClrText   = If( ::lHeader, CLR_WHITE, CLR_BLACK )
   ::hBmpArrow  = BmpOLArrow()

   if File( cBitmap )
      ::hBmp = ReadBitmap( 0, cBitmap )
   else
      ::hBmp = LoadBitmap( GetResources(), cBitmap )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Paint( lOver ) CLASS TOutLook2010Group

   local nTop, hDC, oBmp, oCon := ::oContainer
   local hGrayPen, hOldPen

   DEFAULT lOver := .F.

   if ::lHeader
      nTop = 0
   else
      nTop = oCon:nHeight - ;
             ( ( Len( oCon:aGroups ) + 1 - AScan( oCon:aGroups, { | o | o == Self } ) ) * 32 )
   endif

   if ::lSelected
      GradientFill( hDC := oCon:GetDC(), nTop + 2, 2, nTop + 28, oCon:nWidth() - 2,;
                    { { 0.5, RGB( 222, 227, 233 ), RGB( 209, 213, 222 ) },;
                      { 0.5, RGB( 209, 213, 222 ), RGB( 222, 227, 233 ) } } )
   else
      FillRect( hDC := oCon:GetDC(), { nTop, 0, nTop + 32, oCon:nWidth() }, oCon:oBrush:hBrush )
   endif

   if ! Empty( ::hBmp )
      DrawTransparent( hDC, ::hBmp, nTop + 5, 8 )
   endif
   oCon:Say( nTop + 8 - If( ::lHeader, 2, 0 ), 40 - If( ::lHeader, 30, 0 ),;
             ::cPrompt, If( ::lSelected, ::nClrText, RGB( 57, 75, 97 ) ),,;
             If( ::lHeader, oCon:oFontHeader, oCon:oFontGroup ), .T., ::lSelected )
   if Self == ATail( oCon:aGroups )
      DrawTransparent( hDC, ::hBmpArrow, nTop + 10, oCon:nWidth() - nBmpWidth( ::hBmpArrow ) * 2 )
   endif

   if ::lSelected
      hGrayPen = CreatePen( PS_SOLID, 1, nRGB( 165, 168, 173 ) )
      WndBoxClr( hDC, nTop + 1, 3, nTop + 30, oCon:nWidth - 6, hGrayPen )
      DeleteObject( hGrayPen )
   endif

   oCon:ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD Destroy CLASS TOutLook2010Group

   if ! Empty( ::hBmp )
      DeleteObject( ::hBmp )
   endif

   if ! Empty( ::hBmpArrow )
      DeleteObject( ::hBmpArrow )
   endif

return nil

//----------------------------------------------------------------------------//