// Developed by Ramón Avendaño

#include "FiveWin.ch"
#include "Constant.ch"

#define COLOR_BTNFACE    15
#define COLOR_BTNSHADOW  16

#define TME_LEAVE           2
#define WM_MOUSELEAVE     675

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
#endif

//----------------------------------------------------------------------------//

CLASS TSplitter FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   DATA   lVertical, aPrevCtrols, aHindCtrols
   DATA   bFirstMargin, bLastMargin


   DATA   nLong, nWidth
   DATA   nBreadth, nAdjust, nAdjTop, nAdjLeft

   DATA   nFirst, nLast

   DATA   lStatic, l3D, lMoving, lStyle, lMOver

   DATA   aGradient, aGradientOver

   METHOD New( nRow, nCol, lVertical, aPrevCtrols, lAdjPrev, aHindCtrols, lAdjHind, ;
               bMargin1, bMargin2, oWnd, bChange, nWidth, nHeight, ;
               lPixel, l3D, nClrBack, lDesign, lUpdate ) CONSTRUCTOR

   METHOD ReDefine( nId, lVertical, aPrevCtrols, lAdjPrev, aHindCtrols, lAdjHind, ;
                    bMargin1, bMargin2, oWnd, bChange, ;
                    l3D, nClrBack, lUpdate ) CONSTRUCTOR

   METHOD Default() INLINE ::_CoorsUpdate() //, ::Refresh()

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD _CoorsUpdate()

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD Initiate( hDlg ) INLINE Super:Initiate( hDlg ), ::Default()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD AdjClient() INLINE ::Adjust()

   METHOD AdjTop()    INLINE ::Adjust( .t., .f. )
   METHOD AdjBottom() INLINE ::Adjust( .f., .t. )
   METHOD AdjLeft()   INLINE ::Adjust( .t., .t., .t., .f. )
   METHOD AdjRight()  INLINE ::Adjust( .t., .t., .f., .t. )

   METHOD Paint()

   METHOD FirstMargin() INLINE Eval( ::bFirstMargin )
   METHOD LastMargin()  INLINE Eval( ::bLastMargin )

   METHOD SetPosition( nPos )

   METHOD Move( nTop, nLeft, nWidth, nHeight, lRepaint )

   #ifdef __HARBOUR__
      METHOD Moved() VIRTUAL    // Temporary workaround
   #endif

   METHOD LButtonDown( nRow, nCol, nFlags )
   METHOD LButtonUp( nRow, nCol, nFlags )

   METHOD MouseLeave( nRow, nCol, nFlags )
   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD Invert( nPos, nColInit )

   METHOD Adjust( lTop, lBottom, lLeft, lRight )

   METHOD AdjustCtrols( nAdjust )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, lVertical, aPrevCtrols, lAdjPrev, aHindCtrols, lAdjHind, ;
            bMargin1, bMargin2, oWnd, bChange, nWidth, nHeight, ;
            lPixel, l3D, nClrBack, lDesign, lUpdate, lStyle, aGradient, aGradientOver ) CLASS TSplitter

   DEFAULT lVertical := .t., aPrevCtrols := {}, aHindCtrols := {}, ;
           bMargin1 := {|| 0 }, bMargin2 := {|| 0 }, lAdjPrev := .f.,;
           lAdjHind := .f., lPixel := .f.

   if( !lAdjPrev, AAdd( aPrevCtrols, .f. ), )
   if( !lAdjHind, AAdd( aHindCtrols, .f. ), )

   DEFAULT nRow := 0, nCol := 0, oWnd := GetWndDefault()

   DEFAULT l3D := .f., nClrBack := GetSysColor( COLOR_BTNFACE ) // oWnd:nClrPane
   DEFAULT lStyle := .F.

   DEFAULT nWidth  := If( lVertical, 4, 100 ),;
           nHeight := If( lVertical, 100, 4 ),;
           lUpdate := .f., lDesign := .f.


   DEFAULT aGradientOver:= { { 1/4, nRGB( 255, 255, 255 ),  nRGB( 0, 160, 230) },;
                   	          { 1/2,  nRGB( 0, 160, 230),  nRGB( 0, 160, 230) },;
      	                      { 1/4,  nRGB( 0, 160, 230), nRGB( 255, 255, 255 ) } },;
           aGradient    := { { 1/4, nRGB( 255, 255, 255 ),  nRGB( 190, 210, 220) },;
                   	          { 1/2,  nRGB( 190, 210, 220),  nRGB( 190, 210, 220) },;
      	                      { 1/4,  nRGB( 190, 210, 220), nRGB( 255, 255, 255 ) } }

   ::lVertical    = lVertical
   ::aPrevCtrols  = aPrevCtrols
   ::aHindCtrols  = aHindCtrols
   ::bFirstMargin = bMargin1
   ::bLastMargin  = bMargin2

   ::nTop      = If( lPixel, nRow, nRow * WIN_CHARPIX_H ) //16
   ::nLeft     = If( lPixel, nCol, nCol * WIN_CHARPIX_W ) //8
   ::nBottom   = ::nTop  + nHeight - 1
   ::nRight    = ::nLeft + nWidth
   ::bChange   = bChange
   ::oWnd      = oWnd
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                 If( lDesign, nOr( WS_CLIPSIBLINGS, WS_TABSTOP ), 0 ) )
   ::nId       = ::GetNewId()
   ::l3D       = l3D
   ::lStatic   = .f.
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::lUpdate   = lUpdate
   ::lMoving   = .f.
   ::lMOver    = .f.
   ::lStyle    = lStyle
   ::aGradientOver = aGradientOver
   ::aGradient = aGradient

   ::SetColor( nClrBack, nClrBack )

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif
   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::Default()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, lVertical, aPrevCtrols, lAdjPrev, aHindCtrols, lAdjHind, ;
                 bMargin1, bMargin2, oWnd, bChange, ;
                 l3D, nClrBack, lUpdate ) CLASS TSplitter

   DEFAULT lVertical := .t., aPrevCtrols := {}, aHindCtrols := {}, ;
           bMargin1 := {|| 0 }, bMargin2 := {|| 0 }
   DEFAULT oWnd := GetWndDefault()

   if( !lAdjPrev, AAdd( aPrevCtrols, .f. ), )
   if( !lAdjHind, AAdd( aHindCtrols, .f. ), )

   DEFAULT lUpdate := .f.

   DEFAULT l3D := .f., nClrBack := GetSysColor( COLOR_BTNFACE ) // oWnd:nClrPane

   ::lVertical    = lVertical
   ::aPrevCtrols  = aPrevCtrols
   ::aHindCtrols  = aHindCtrols
   ::bFirstMargin = bMargin1
   ::bLastMargin  = bMargin2

   ::nId       = nId
   ::bChange   = bChange
   ::oWnd      = oWnd
   ::l3D       = l3D
   ::lStatic   = .f.
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lUpdate   = lUpdate
   ::lMoving   = .f.
   ::lStyle    = .t.
   ::lMoving   = .f.
   ::lMOver    = .f.

   ::aGradientOver   = {   { 1/4, nRGB( 255, 255, 255 ),  nRGB( 0, 160, 230) },;
                           { 1/2,  nRGB( 0, 160, 230),  nRGB( 0, 160, 230) },;
                           { 1/4,  nRGB( 0, 160, 230), nRGB( 255, 255, 255 ) } }
   ::aGradient       = {   { 1/4, nRGB( 255, 255, 255 ),  nRGB( 190, 210, 220) },;
                           { 1/2,  nRGB( 190, 210, 220),  nRGB( 190, 210, 220) },;
                           { 1/4,  nRGB( 190, 210, 220), nRGB( 255, 255, 255 ) } }

   ::SetColor( nClrBack, nClrBack )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if oWnd != nil
      oWnd:DefControl( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TSplitter

   do case

      case nMsg == WM_PAINT
         ::BeginPaint()
         ::Paint()
         ::EndPaint()
         return 0

      case nMsg == WM_MOUSELEAVE
         return ::MouseLeave( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )

   endcase

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TSplitter

   local aInfo := ::DispBegin()
   local aRect := GetClientRect( ::hWnd )
   local aGrad

   if ::lStyle

      if ::lMOver
         aGrad = ::aGradientOver
      else
         aGrad = ::aGradient
      endif

      GradientFill( ::hDC, aRect[ 1 ], aRect[ 2 ], aRect[ 3 ], aRect[ 4 ], aGrad, ::lVertical )

   else

      FillRect( ::hDC, aRect, ::oBrush:hBrush )

      if ::l3D
         if ::lVertical
            WndVRaised( ::hWnd, ::hDC )
         else
            WndHRaised( ::hWnd, ::hDC )
         endif
      endif

   endif

   ::DispEnd( aInfo )

return nil

//----------------------------------------------------------------------------//

METHOD SetPosition( nPos ) CLASS TSplitter

   if ::lMoving
      return nil
   endif

   ::nAdjust = ::nFirst

   if ::lVertical
      ::Move( ::nTop, nPos, ::nWidth, ::nLong, .t. )
   else
      ::Move( nPos, ::nLeft, ::nLong, ::nWidth, .t. )
   endif

   ::AdjustCtrols( ::nFirst - ::nAdjust )

return nil

//----------------------------------------------------------------------------//

METHOD Move( nTop, nLeft, nWidth, nHeight, lRepaint ) CLASS TSplitter

   ::lMoving = .t.

   MoveWindow( ::hWnd, nTop, nLeft, nWidth, nHeight, lRepaint )

   ::_CoorsUpdate()

   ::lMoving = .f.

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TSplitter

   local nPos, aRect

   if ::lStatic .or. ::lDrag
      return Super:LButtonDown( nRow, nCol, nFlags )
   endif

   if ! ::lCaptured

      aRect = GetClientRect( ::oWnd:hWnd )

      ::nAdjust = ::nFirst

      if ::lvertical
         nPos = nCol
         ::nBreadth = MAX( aRect[ 4 ] - ::FirstMargin() - ::LastMargin(), ;
                           ::nLeft + ::nWidth - ::FirstMargin() )
         MoveWindow( ::hWnd, ::nTop, ::FirstMargin(), ::nBreadth, ::nLong, .f. )
      else
         nPos = nRow
         ::nBreadth = MAX( aRect[ 3 ] - ::FirstMargin() - ::LastMargin(), ;
                           ::nTop + ::nWidth - ::FirstMargin() )
         MoveWindow( ::hWnd, ::FirstMargin(), ::nLeft, ::nLong, ::nBreadth, .f. )
      endif

      ::lCaptured = .t.
      ::Capture()
      ::Invert( , nPos )

   endif

   Super:LButtonDown( nRow, nCol, nFlags )

return nil

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TSplitter

   if ::lStatic .or. ::lDrag
      return Super:LButtonUp( nRow, nCol, nFlags )
   endif

   if ::lCaptured

      ::lCaptured = .f.
      ReleaseCapture()
      ::Invert()

      if ::lvertical
         MoveWindow( ::hWnd, ::nTop, ::nFirst, ::nWidth, ::nLong, .t. )
      else
         MoveWindow( ::hWnd, ::nFirst, ::nLeft, ::nLong, ::nWidth, .t. )
      endif
      ::_CoorsUpdate()

      ::AdjustCtrols( ::nFirst - ::nAdjust )

   endif

   if ::bChange != nil
      Eval( ::bChange, Self, ::nFirst, ::nLast)
   endif

   Super:LButtonUp( nRow, nCol, nFlags )

return nil

//----------------------------------------------------------------------------//

METHOD MouseLeave( nRow, nCol, nFlags ) CLASS TSplitter

   ::lCaptured = .F.
   ::lMOver    = .F.
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TSplitter

   if ::lStatic .or. ::lDrag
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

   ::lMOver := .T.

   if ::lCaptured //.and. ! ::lStyle
      ::Invert( If( ::lVertical, nCol, nRow ) )
      return 0
   endif

   if ::lVertical
      CursorWE()
   else
      CursorNS()
   endif

   ::refresh()

   TrackMouseEvent( ::hWnd, TME_LEAVE )

return 0

//----------------------------------------------------------------------------//

METHOD Invert( nPos, nInit ) CLASS TSplitter

   static nInitPos, nOldPos

   ::GetDC()

   if nPos = nil

      if nInit = nil
         nPos = nOldPos
         ::nFirst = nPos + ::FirstMargin()
      else
         nInitPos = nInit
         nPos = ::nFirst
      endif

   else

      nPos = nPos - nInitPos

      if nPos < 0 .or. (nPos + ::nWidth) > ::nBreadth
         ::ReleaseDC()
         return nil
      endif

      if ::lVertical
         InvertRect( ::hDC, { 0, nOldPos, ::nLong, nOldPos + ::nWidth } )
      else
         InvertRect( ::hDC, { nOldPos, 0, nOldPos + ::nWidth, ::nLong } )
      endif

   endif

   if ::lVertical
      InvertRect( ::hDC, { 0, nPos, ::nLong, nPos + ::nWidth } )
   else
      InvertRect( ::hDC, { nPos, 0, nPos + ::nWidth, ::nLong } )
   endif

   nOldPos = nPos

   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD Adjust( lTop, lBottom, lLeft, lRight ) CLASS TSplitter

  Local aRect

  Local oCtrol
  Local nTop, nLeft, nWidth, nHeight
  Local nCtrlTop, nCtrlLeft, nCtrlWidth, nCtrlHeight

  Local nSplitTop := 0, nSplitLeft := 0

  DEFAULT lTop := .t., lBottom := .t., lLeft := .t., lRight := .t.

  ClientCoors( ::oWnd, @nTop, @nLeft, @nWidth, @nHeight )

  DEFAULT ::nAdjTop := nTop, ::nAdjLeft := nLeft

  if ::nAdjTop != nTop
     nSplitTop = nTop - ::nAdjTop
     ::nAdjTop = nTop
  endif
  if ::nAdjLeft != nLeft
     nSplitLeft = nLeft - ::nAdjLeft
     ::nAdjLeft = nLeft
  endif

  // Ajust previous controls

  if Len( ::aPrevCtrols ) == 1

     oCtrol = ::aPrevCtrols[ 1 ]
     aRect = GetCoors( oCtrol:hWnd )

     nCtrlTop  = if( lTop, nTop, aRect[1] + nSplitTop )
     nCtrlLeft = if( lLeft, nLeft, aRect[2] + nSplitLeft )
     if ::lVertical
        nCtrlHeight = if( lTop, ;
                          if( lBottom, nHeight, aRect[3] - nTop + nSplitTop ), ;
                          nHeight + nTop - nCtrlTop )
        nCtrlWidth  = if( lLeft, aRect[4] - nLeft + nSplitLeft, aRect[4] - aRect[2] )
     else
        nCtrlHeight = iF( lTop, aRect[3] - nTop + nSplitTop, aRect[3] - aRect[1] )
        nCtrlWidth  = if( lLeft,;
                          if( lRight, nWidth, aRect[4] - nLeft + nSplitLeft ), ;
                          nWidth + nLeft - nCtrlLeft )
     endif

     oCtrol:Move( nCtrlTop, nCtrlLeft, nCtrlWidth, nCtrlHeight, .t. )

  endif

  // Ajust hinds controls

  if Len( ::aHindCtrols ) == 1

     oCtrol = ::aHindCtrols[ 1 ]
     aRect = GetCoors( oCtrol:hWnd )

     if ::lVertical
        nCtrlTop    = if( lTop, nTop, aRect[1] + nSplitTop )
        nCtrlLeft   = aRect[2] + nSplitLeft
        nCtrlHeight = if( lTop, ;
                          if( lBottom, nHeight, aRect[3] - nTop + nSplitTop ), ;
                          nHeight + nTop - nCtrlTop )
        nCtrlWidth  = if( lRight, nWidth + nLeft - nCtrlLeft, aRect[4] - aRect[2] )
     else
        nCtrlTop    = aRect[1] + nSplitTop
        nCtrlLeft   = if( lLeft, nLeft, aRect[2] + nSplitLeft )
        nCtrlHeight = if( lBottom, nHeight + nTop - nCtrlTop, aRect[3] - aRect[1] )
        nCtrlWidth  = if( lLeft, ;
                          if( lRight, nWidth, aRect[4] - nLeft + nSplitLeft ), ;
                          nWidth + nLeft - nCtrlLeft )
     endif

     oCtrol:Move( nCtrlTop, nCtrlLeft, nCtrlWidth, nCtrlHeight, .t. )

  endif

  // Ajust splitter

  if ::lVertical
     ::Move( if( lTop, nTop, ::nTop + nSplitTop ), ;
             ::nFirst + nSplitLeft, ;
             ::nWidth, ;
             if( lTop, if( lBottom, nHeight, ::nBottom - nTop + nSplitTop ), ;
                 nHeight + nTop - ( ::nTop + nSplitTop ) ), ;
             .t. )
  else
     ::Move( ::nFirst + nSplitTop, ;
             if( lLeft, nLeft, ::nLeft + nSplitLeft ), ;
             if( lLeft, if( lRight, nWidth, ::nRight - nLeft + nSplitLeft ), ;
                 nWidth + nleft - (::nLeft + nSplitLeft ) ), ;
             ::nWidth, ;
             .t. )
  endif

return nil

//----------------------------------------------------------------------------//

METHOD AdjustCtrols( nAdjust ) CLASS TSplitter

  Local nLen, aRect

  Local oCtrol, nCtrol
  Local nTop, nLeft, nWidth, nHeight

  // Ajust previous controls

  nLen := Len( ::aPrevCtrols )

  for nCtrol = 1 to nLen

      oCtrol = ::aPrevCtrols[ nCtrol ]
      if ValType( oCtrol ) != "O"
         loop
      endif
      aRect = GetCoors( oCtrol:hWnd )

      if ::lVertical
         nHeight = aRect[3] - aRect[1]
         nWidth  = aRect[4] - aRect[2] + nAdjust
      else
         nHeight = aRect[3] - aRect[1] + nAdjust
         nWidth  = aRect[4] - aRect[2]
      endif

     oCtrol:Move( aRect[1], aRect[2], nWidth, nHeight, .t. )

  next

  // Ajust hinds controls

  nLen := Len( ::aHindCtrols )

  for nCtrol = 1 to nLen

      oCtrol = ::aHindCtrols[ nCtrol ]
      if ValType( oCtrol ) != "O"
         loop
      endif
      aRect = GetCoors( oCtrol:hWnd )

      if ::lVertical
         nTop  = aRect[1]
         nLeft = aRect[2] + nAdjust
         nHeight = aRect[3] - aRect[1]
         nWidth  = aRect[4] - aRect[2] - nAdjust
      else
         nTop  = aRect[1] + nAdjust
         nLeft = aRect[2]
         nHeight = aRect[3] - aRect[1]  - nAdjust
         nWidth  = aRect[4] - aRect[2]
      endif

     oCtrol:Move( nTop, nLeft, nWidth, nHeight, .t., NIL )

  next

return nil

//----------------------------------------------------------------------------//

METHOD _CoorsUpdate() CLASS TSplitter

   local aRect := GetCoors( ::hWnd )

   ::nTop    = aRect[1]
   ::nLeft   = aRect[2]
   ::nBottom = aRect[3]
   ::nRight  = aRect[4]

   aRect := GetClientRect( ::oWnd:hWnd )

   if ::lVertical
      ::nLong  = ::nBottom - ::nTop
      ::nWidth = ::nRight - ::nLeft
      ::nFirst = ::nLeft
      ::nLast  = aRect[4] - ::nRight
   else
      ::nLong  = ::nRight - ::nLeft
      ::nWidth = ::nBottom - ::nTop
      ::nFirst = ::nTop
      ::nLast  = aRect[3] - ::nBottom
   endif

return nil


//  Static functions
//----------------------------------------------------------------------------//

static function ClientCoors( oWnd, nTop, nLeft, nWidth, nHeight )

   local hWnd  := oWnd:hWnd
   local aRect := GetClientRect( hWnd ), aRectBar
   local nSubWidth := 0, nSubHeight := 0
   local oMsgBar, lIsThemed := 0

   nLeft = 0
   nTop  = if( oWnd:oMenu = nil, -1, 0 )
   if GetClassName( hWnd ) == "TMDICHILD" .and. IsZoomed( hWnd )
      nTop := if( oWnd:oWnd:oTop = nil .and. oWnd:oWnd:oBar = nil, 1, 0 )
   endif

   if oWnd:oTop != nil .or. oWnd:oBar != nil
      if oWnd:oTop = nil
         oWnd:oTop := oWnd:oBar
      endif
      aRectBar := GetClientRect( oWnd:oTop:hWnd )
      nSubHeight += aRectBar[3]
      nTop = nSubHeight + 1
   endif

   if oWnd:oLeft != nil
      aRectBar := GetClientRect( oWnd:oLeft:hWnd )
      nSubWidth += aRectBar[4]
      nLeft = nSubWidth
   endif

   if oWnd:oRight != nil
      aRectBar := GetClientRect( oWnd:oRight:hWnd )
      nSubWidth += aRectBar[4]
   endif

   if oWnd:oBottom != nil
      oMsgBar = oWnd:oBottom
      #ifndef __CLIPPER__
      if IsAppThemed()
         lIsThemed = -1 // 1
      endif
      #endif
   else
      oMsgBar = oWnd:oMsgBar
   endif

   nWidth  = aRect[4] - nSubWidth
   nHeight = aRect[3] - nSubHeight - ;
             If( oMsgBar != nil, oMsgBar:nHeight() + lIsThemed, 0 )

return nil

//----------------------------------------------------------------------------//
// R.Avendaño. 1998









