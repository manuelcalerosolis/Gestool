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

#define COLOR_WINDOW          5
#define COLOR_WINDOWTEXT      8

#define COLOR_BTNSHADOW      16
#define COLOR_BTNHIGHLIGHT   20

#define WM_NCHITTEST        132  // 0x84

#define GWL_STYLE           -16
#define GWL_EXSTYLE         -20

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
#endif

static oTimer, aTimer := {}

//----------------------------------------------------------------------------//

CLASS TDSay FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   DATA   l3D
   DATA   cPicture
   DATA   aCaption
   DATA   bGet

   DATA   lShaded, lBox, lRaised

   DATA   nDTop, nDLeft
   DATA   nTTop, nTLeft
   DATA   aRect, nLong
   DATA   nTxtWidth, nTxtHeight
   DATA   nAlign

   DATA   oTimer
   DATA   lScroll, lHorizontal, nSpeed, lWrap    // nSpeed: 0 to 100
   DATA   lBlink, lView

   METHOD New( nRow, nCol, bText, oWnd, cPicture, oFont,;
               lCentered, lRight, lBottom, lBorder, lPixels, nClrText, nClrBack,;
               nWidth, nHeight, cScroll, nSpeed, lWrap, lBlink,;
               lDesign, lUpdate, lShaded, lBox, lRaised ) CONSTRUCTOR

   METHOD ReDefine( nId, bText, oWnd, cPicture, lCentered, lRight, lBottom,;
                    nClrText, nClrBack, cScroll, nSpeed, lWrap, lBlink,;
                    lUpdate, oFont, lShaded, lBox, lRaised )  CONSTRUCTOR

   METHOD Default()

   METHOD Destroy()

   METHOD Initiate( hDlg ) INLINE Super:Initiate( hDlg ), ::Default()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint()

   METHOD Paint()

   METHOD Dynamic()

   METHOD Refresh() INLINE If( ::bGet != nil, ::SetText( Eval( ::bGet ) ),)

   METHOD ReSize( nType, nWidth, nHeight ) INLINE ::Default(), Super:ReSize( nType, nWidth, nHeight )

   METHOD SetText( cText ) INLINE ;
                    ::cCaption := If( ::cPicture != nil,;
                                  Transform( cText, ::cPicture ),;
                                  cValToChar( cText ) ),;
                                  ::Default(), ::Paint()
   METHOD VarPut( cValue )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bText, oWnd, cPicture, oFont,;
            lCentered, lRight, lBottom, lBorder, lPixels, nClrText, nClrBack,;
            nWidth, nHeight, cScroll, nSpeed, lWrap, lBlink,;
            lDesign, lUpdate, lShaded, lBox, lRaised ) CLASS TDSay

   DEFAULT nRow     := 0, nCol := 0,;
           lBorder  := .f., lCentered := .f., lRight := .f., lBottom := .f., lPixels := .f.,;
           oWnd     := GetWndDefault(),;
           nClrText := oWnd:nClrText, nClrBack := oWnd:nClrPane,;
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
      ::nLeft = nCol * If( oFont != nil, Abs( oFont:nWidth ), SAY_CHARPIX_W )                    // 8
   else
      ::nTop  = nRow
      ::nLeft = nCol
   endif

   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1

   DEFAULT nSpeed := 55, lWrap := .f., lBlink := .f.

   ::lScroll     = ( cScroll != nil )
   ::lHorizontal = ( cScroll == "HORIZONTAL" )
   ::nSpeed      = if( nSpeed < 50, ( 50 - nSpeed ) * 10, 100 - nSpeed )
   ::lWrap       = lWrap
   ::lBlink      = lBlink

   ::oWnd      = oWnd
   ::oFont     = oFont
   ::nId       = ::GetNewId()
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                 If( lDesign, nOr( WS_CLIPSIBLINGS, WS_TABSTOP ), 0 ),;
                 If( lBorder, WS_BORDER, 0 ) )
   ::lShaded  = lShaded
   ::lBox     = lBox
   ::lRaised  = lRaised

   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::lUpdate   = lUpdate

   ::SetColor( nClrText, nClrBack )

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

METHOD ReDefine( nId, bText, oWnd, cPicture, lCentered, lRight, lBottom,;
                 nClrText, nClrBack, cScroll, nSpeed, lWrap, lBlink,;
                 lUpdate, oFont, lShaded, lBox, lRaised ) CLASS TDSay

   DEFAULT lCentered := .f., lRight := .f., lBottom := .f.,;
           nClrText := oWnd:nClrText, nClrBack := oWnd:nClrPane,;
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

   DEFAULT nSpeed := 55, lWrap := .f., lBlink := .f.

   ::lScroll     = ( cScroll != nil )
   ::lHorizontal = ( cScroll == "HORIZONTAL" )
   ::nSpeed      = if( nSpeed < 50, ( 50 - nSpeed ) * 10, 100 - nSpeed )
   ::lWrap       = lWrap
   ::lBlink      = lBlink

   ::oWnd      = oWnd
   ::hWnd      = 0
   ::lShaded  = lShaded
   ::lBox     = lBox
   ::lRaised  = lRaised

   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lUpdate   = lUpdate

   ::SetColor( nClrText, nClrBack )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if oWnd != nil
      oWnd:DefControl( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TDSay

   if ::lDrag .and. nMsg == WM_NCHITTEST
      return DefWindowProc( ::hWnd, nMsg, nWParam, nLParam )
   endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD Default() CLASS TDSay

   local lCentered := nAnd( ::nAlign, TA_CENTER ) == TA_CENTER
   local lRight    := nAnd( ::nAlign, TA_RIGHT ) == TA_RIGHT
   local lBottom   := nAnd( ::nAlign, TA_BOTTOM ) == TA_BOTTOM

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::SetFont( ::oWnd:oFont )
   endif

   ::nTxtWidth  = 0
   ::nTxtHeight = GetTextHeight( ::hWnd, 0 )

   ::aCaption   = Array( MLCount( ::cCaption, 254 ) )
   AEval( ::aCaption, {|c, n| ::aCaption[ n ] := Trim( MemoLine( ::cCaption, 252, n ) ),;
                       ::nTxtWidth := Max( ::nTxtWidth, GetTextWidth( 0, ::aCaption[ n ],;
                       if( ::oFont != nil, ::oFont:hFont, 0 ) ) ) } )

   ::aRect := GetClientRect( ::hWnd )

   ::nDTop  := ::nTTop  := if( lBottom, ::aRect[ 3 ], 0 )
   ::nDLeft := ::nTLeft := if( lCentered, int( ::aRect[ 4 ] / 2 ), if( lRight, ::aRect[ 4 ], 0 ) )

   if ::lBox
      ::aRect := { 2, 2, ::aRect[ 3 ] - 2, ::aRect[ 4 ] - 2 }
   elseif ::lShaded .or. ::lRaised
      ::aRect := { 1, 1, ::aRect[ 3 ] - 1, ::aRect[ 4 ] - 1 }
   endif

   if ::lScroll
      if ::lHorizontal
         ::nLong := Max( ::nTxtWidth, ::aRect[ 4 ] )
      else
         ::nLong := Max( ::nTxtHeight * len( ::aCaption ), ::aRect[ 3 ] )
      endif
   endif

   InvalidateRect( ::hWnd, ::aRect, .t. )
   ::lView := .t.

   // Call dynamic and blinking

   if !::lDrag

      if ::lScroll .and. ::oTimer = nil
         DEFINE TIMER ::oTimer INTERVAL ::nSpeed ACTION ::Dynamic() OF Self
         ACTIVATE TIMER ::oTimer
      endif

      if ::lBlink .and. AScan( aTimer, { | oCtrl | oCtrl == Self } ) == 0
         AAdd( aTimer, Self )
         if oTimer = nil
            DEFINE TIMER oTimer INTERVAL 300 ACTION Blink() OF ::oWnd
            ACTIVATE TIMER oTimer
         endif
      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TDSay

  if ::lBlink

     ADel( aTimer, AScan( aTimer, { |o| o == Self} ) )
     ASize( aTimer, len( aTimer) - 1 )

     if len( aTimer ) = 0
        oTimer := nil
     endif

  endif

return Super:Destroy()

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TDSay

   local n
   local nColorShadow, nColorLight

   ::GetDC()

   if ::lActive

      if ::lView

         for n := 1 to len( ::aCaption )
             WSay( ::hWnd, ::hDC, ::nDTop + ( n - 1 ) * ::nTxtHeight, ::nDLeft, ::aCaption[ n ], ::nClrText,,;
                   If( ::oFont != nil, ::oFont:hFont, 0 ), .T., .T., ::nAlign )
         next

         if ::lScroll .and. ::lWrap
            if ::lHorizontal
                for n := 1 to len( ::aCaption )
                    WSay( ::hWnd, ::hDC, ::nDTop + ( n - 1 ) * ::nTxtHeight, ::nDLeft + ::nLong, ::aCaption[ n ], ::nClrText,,;
                          If( ::oFont != nil, ::oFont:hFont, 0 ), .T., .T., ::nAlign )
                next
             else
                for n := 1 to len( ::aCaption )
                    WSay( ::hWnd, ::hDC, ::nDTop + ( n - 1 ) * ::nTxtHeight + ::nLong, ::nDLeft, ::aCaption[ n ], ::nClrText,,;
                          If( ::oFont != nil, ::oFont:hFont, 0 ), .T., .T., ::nAlign )
                next
             endif
         endif

      else

         InvalidateRect( ::hWnd, ::aRect, .t. )

      endif

   else

      nColorShadow := GetSysColor( COLOR_BTNSHADOW )
      nColorLight  := GetSysColor( COLOR_BTNHIGHLIGHT )

      for n := 1 to len( ::aCaption )
          WSay( ::hWnd, ::hDC, ::nDTop + ( n - 1 ) * ::nTxtHeight + 1, ::nDLeft + 1, ::aCaption[ n ], nColorLight,,;
                If( ::oFont != nil, ::oFont:hFont, 0 ), .T., .T., ::nAlign )
          WSay( ::hWnd, ::hDC, ::nDTop + ( n - 1 ) * ::nTxtHeight, ::nDLeft, ::aCaption[ n ], nColorShadow,,;
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

return nil

//----------------------------------------------------------------------------//

METHOD Dynamic() CLASS TDSay

  local nSpeed := if( ::nSpeed < 50, int( ( 50 - ::nSpeed + 5 ) / 5 ), 1 )

  if !::lActive
     return nil
  endif

  if ::lHorizontal

     ::nDLeft -= nSpeed
     if ::nDLeft + ::nLong < ::nTLeft
        if ::lWrap
           ::nDLeft := ::nDLeft + ::nLong
        else
           ::oTimer:End()
        endif
     endif
     ScrollWindow( ::hWnd, -nSpeed, 0, ::aRect, ::aRect )

  else

     ::nDTop -= nSpeed
     if ::nDTop + ::nLong < if( ::nTTop = 0, 0, ::nTxtHeight )
        if ::lWrap
           ::nDTop := ::nDTop + ::nLong
        else
           ::oTimer:End()
        endif
     endif
     ScrollWindow( ::hWnd, 0, -nSpeed, ::aRect, ::aRect )

  endif

  /*  It is not necessary to use the method 'Paint()' because
      'ScrollWindow()' he calls directly to the method 'Paint()'  */

return nil

//----------------------------------------------------------------------------//

METHOD VarPut( cValue ) CLASS TDSay

   if ! Empty( ::cPicture )
      cValue = Transform( cValue, ::cPicture )
   else
      cValue = cValToChar( cValue )
   endif

   ::bGet = { || cValue }

return nil

//  Static functions
//----------------------------------------------------------------------------//

static Function Blink()
  AEval( aTimer, {| oCtrl | oCtrl:lView := !oCtrl:lView, if( oCtrl:lActive, oCtrl:Paint(), ) } )
return nil