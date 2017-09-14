// Selector control by Ramón Avendaño
// 20-09-99

#include "FiveWin.Ch"
#include "Constant.ch"

#define COLOR_WINDOW              5
#define COLOR_WINDOWTEXT          8
#define COLOR_BTNFACE            15
#define COLOR_BTNSHADOW          16

#define PI   3.14159265359
#define DEG  PI / 180

#ifdef __XPP__
   #define Super ::TControl
#endif

//----------------------------------------------------------------------------//

CLASS TSelector FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   DATA   nOrigin
   DATA   nLast

   DATA   nRow, nCol, nPos
   DATA   nArc, nRadius
   DATA   nClrBtn, nClrMarks

   DATA   bPos

   DATA   nMin, nMax

   DATA   nMarks, lExact
   DATA   aMarks

   DATA   lCaptured

   METHOD New( nRow, nCol, bSetGet, nAngle1, nAngle2, nMin, nMax, ;
               nMarks, lExact, oWnd, bChange, bPos, nWidth, nHeight, lPixel, ;
               cMsg, nClrFore, nClrBack, nClrBtn, lDesign, lUpdate ) CONSTRUCTOR

   METHOD ReDefine( nId, bSetGet, nAngle1, nAngle2, nMin, nMax, ;
                    nMarks, lExact, oWnd, bChange, bPos, ;
                    cMsg, nClrFore, nClrBack, nClrBtn, lUpdate ) CONSTRUCTOR

   METHOD Default()

   METHOD GetDlgCode( nLastKey )

   METHOD Initiate( hDlg ) INLINE Super:Initiate( hDlg ), ::Default()

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint()

   METHOD nGetPos( nVal ) INLINE ::nArc * ( nVal - ::nMin ) / ;
                                 ( ::nMax - ::nMin ) + ::nOrigin

   METHOD nGetVal( nPos ) INLINE Round( ( ::nMax - ::nMin ) * ;
                                 AdjPos( nPos - ::nOrigin ) / ::nArc, 0 ) + ::nMin

   METHOD Paint()

   METHOD ShowFocus( lFocused )

   METHOD GotFocus( hCtlLost ) INLINE ::ShowFocus( .t. ), Super:GotFocus( hCtlLost )
   METHOD LostFocus( hWndGetFocus ) INLINE ::ShowFocus( .f. ), Super:LostFocus( hWndGetFocus )

   METHOD Set( nVal ) INLINE Eval( ::bSetGet, nVal ), ;
                             ::SetPosition( ::nGetPos( nVal ) )

   METHOD Change() INLINE Eval( ::bSetGet, ::nGetVal( ::nPos ) ), ;
                          if( ::bChange != nil, Eval( ::bChange, Eval( ::bSetGet ) ), nil )

   METHOD SetPosition( nPos ) INLINE ::Position( , nPos, 0 ), ::Position( nPos )

   METHOD ReSize( nType, nWidth, nHeight ) INLINE ::Default(), Super:ReSize( nType, nWidth, nHeight )

   METHOD LButtonDown( nRow, nCol, nFlags )
   METHOD LButtonUp( nRow, nCol, nFlags )

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD KeyDown( nKey, nFlags )

   METHOD PlaceMark( nPos, nStep )

   METHOD Position( nPos, nInit, nDeviation )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, nAngle1, nAngle2, nMin, nMax, ;
            nMarks, lExact, oWnd, bChange, bPos, nWidth, nHeight, lPixel, ;
            cMsg, nClrFore, nClrBack, nClrBtn, lDesign, lUpdate ) CLASS TSelector

   DEFAULT nAngle1 := 0, nAngle2 := 360, ;
           nMin := 0, nMax := 10, lExact := .f., nMarks := 0

   DEFAULT nRow := 0, nCol := 0, oWnd := GetWndDefault()

   DEFAULT nClrFore  := oWnd:nClrText,; // GetSysColor( COLOR_WINDOWTEXT ),;
           nClrBack  := oWnd:nClrPane,; // GetSysColor( COLOR_WINDOW ),;
           nClrBtn   := GetSysColor( COLOR_BTNFACE )

   DEFAULT nWidth  := 100, nHeight := 100,;
           lUpdate := .f., lDesign := .f.

   ::nOrigin = MIN( MAX( nAngle1, 0 ), 360 ) * DEG
   ::nLast   = MIN( MAX( nAngle2, 0 ), 360 ) * DEG

   ::nMin   = nMin
   ::nMax   = nMax
   ::lExact = If( nMarks > 1, lExact, .f. )
   ::nMarks = nMarks

   ::nTop      = If( lPixel, nRow, nRow * WIN_CHARPIX_H ) //16
   ::nLeft     = If( lPixel, nCol, nCol * WIN_CHARPIX_W ) //8
   ::nBottom   = ::nTop  + nHeight
   ::nRight    = ::nLeft + nWidth
   ::bChange   = bChange
   ::bPos      = bPos
   ::oWnd      = oWnd
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP, ;
                 If( lDesign, WS_CLIPSIBLINGS, 0 ) )
   ::nId       = ::GetNewId()
   ::bSetGet   = bSetGet
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate

   ::nClrBtn   = nClrBtn

   ::SetColor( nClrFore, nClrBack )

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

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, nAngle1, nAngle2, nMin, nMax, ;
                 nMarks, lExact, oWnd, bChange, bPos, ;
                 cMsg, nClrFore, nClrBack, nClrBtn, lUpdate ) CLASS TSelector

   DEFAULT nAngle1 := 0, nAngle2 := 360, ;
           nMin := 0, nMax := 10, lExact := .f., nMarks := 0

   DEFAULT nClrFore  := oWnd:nClrText,; // GetSysColor( COLOR_WINDOWTEXT ),;
           nClrBack  := oWnd:nClrPane,; // GetSysColor( COLOR_WINDOW ),;
           nClrBtn   := GetSysColor( COLOR_BTNFACE )

   DEFAULT lUpdate := .f.

   ::nOrigin = MIN( MAX( nAngle1, 0 ), 360 ) * DEG
   ::nLast   = MIN( MAX( nAngle2, 0 ), 360 ) * DEG

   ::nMin   = nMin
   ::nMax   = nMax
   ::lExact = If( nMarks > 1, lExact, .f. )
   ::nMarks = nMarks

   ::nId       = nId
   ::bSetGet   = bSetGet
   ::bChange   = bChange
   ::bPos      = bPos
   ::oWnd      = oWnd
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate

   ::nClrBtn   = nClrBtn

   ::SetColor( nClrFore, nClrBack )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if oWnd != nil
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TSelector

   local nVal

   local aRect := GetClientRect( ::hWnd )

   local n, nMark, nMarks := ::nMarks * 2
   local nLap

   if ValType( Eval( ::bSetGet ) ) == "U"
      nVal := ::nMin
   else
      if ::nMin > ::nMax
         nVal := Max( Min( Eval( ::bSetGet ), ::nMin ), ::nMax )
      else
         nVal := Min( Max( Eval( ::bSetGet ), ::nMin ), ::nMax )
      endif
   endif

   Eval( ::bSetGet, nVal )

   ::nRow = Int( aRect[ 3 ] / 2 )
   ::nCol = Int( aRect[ 4 ] / 2 )

   ::nRadius = Min( ::nRow, ::nCol ) - 12

   ::nArc  := If( ::nOrigin >= ::nLast, ::nLast + ( 2 * PI - ::nOrigin ), ;
                  ::nLast - ::nOrigin)
   ::nPos  := ::nGetPos( nVal )

   nMark := ::nOrigin

   ::aMarks := ARRAY( nMarks )
   nLap := ::nArc / ( nMarks / 2 - 1 )

   for n := 1 to nMarks step 2
       ::aMarks[ n ]     := ::nRow - Cos( nMark ) * ( ::nRadius + 2 )
       ::aMarks[ n + 1 ] := ::nCol + Sin( nMark ) * ( ::nRadius + 2 )
       nMark += nLap
   next

   // ::nClrBtn   := GetSysColor( COLOR_BTNFACE )
   ::nClrMarks := ::nClrText

return nil

//----------------------------------------------------------------------------//

METHOD GetDlgCode( nLastKey ) CLASS TSlider

   if .not. ::oWnd:lValidating
      if nLastKey == VK_RETURN .or. nLastKey == VK_TAB
         ::oWnd:nLastKey = nLastKey
      endif
   endif

return DLGC_WANTALLKEYS

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TSelector

   local hDC, hFont

   local nRow := Round( ::nRow - ::nRadius * Cos( ::nPos ), 0)
   local nCol := Round( ::nCol + ::nRadius * Sin( ::nPos ), 0)

   hDC := GetDC( ::hWnd )

   DrawSelector ( hDC, ::nRow, ::nCol, ::nRadius, nRow, nCol, ;
                  ::aMarks, ::nClrBtn, ::nClrMarks )

   ReleaseDC( ::hWnd, hDC )

   If !::lCaptured
      ::ShowFocus( ::lFocused )
   endif

return Super:Paint()

//----------------------------------------------------------------------------//

METHOD ShowFocus( lFocused ) CLASS TSelector

   local hDC

   local aRect := GetClientRect( ::hWnd )

   local hOldPen, hPen := CreatePen( PS_SOLID, 1, ::nClrPane )

   hDC   := GetDC( ::hWnd )

   hOldPen = SelectObject( hDC, hPen )

   MoveTo( hDC, 0, 0 )
   LineTo( hDC, 0, aRect[ 3 ] - 1, hPen )
   LineTo( hDC, aRect[ 4 ] - 1, aRect[ 3 ] - 1 , hPen )
   LineTo( hDC, aRect[ 4 ] - 1 , 0, hPen )
   LineTo( hDC, 0, 0, hPen )

   if lFocused
      DrawFocusRect( hDC, 0, 0, aRect[ 3 ], aRect[ 4 ] )
   endif

   SelectObject( hDC, hOldPen )

   ReleaseDC( ::hWnd, hDC )

   DeleteObject( hPen );

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TSelector

   local nPos

   if ::lDrag
      return Super:LButtonDown( nRow, nCol, nFlags )
   endif

   if !::lFocused
      ::SetFocus()
   endif

   if ! ::lCaptured

      nPos := ATang( ( ::nRow - nRow) / ( ::nCol - nCol ) ) + ;
              if( nCol = ::nCol, if( nRow > ::nRow, PI, 0 ), ;
                                 if( nCol > ::nCol, PI * 0.5, PI * 1.5 ) )

      if SQRT( ABS( ::nRow - nRow) ** 2 + ABS( ::nCol - nCol ) ** 2 ) > ;
         ::nRadius

         ::SetPosition( nPos )

      endif

      ::lCaptured = .t.
      ::Capture()
      ::Position( , nPos )

   endif

   Super:LButtonDown( nRow, nCol, nFlags )

return nil

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TSelector

   local nPos

   if ::lDrag
      return Super:LButtonUp( nRow, nCol, nFlags )
   endif

   if ::lCaptured

      ::lCaptured = .f.
      ReleaseCapture()
      ::Position()

   endif

   if ::lExact

      ::PlaceMark( ::nPos, 0 )

   endif

   ::Change()

   Super:LButtonUp( nRow, nCol, nFlags )

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TSelector

   local nPos

   if ::lDrag
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

   if ::lCaptured

      nRow -= if( nRow > 32768, 65536, 0 )
      nCol -= if( nCol > 32768, 65536, 0 )

      nPos := ATang( ( ::nRow - nRow) / ( ::nCol - nCol ) ) + ;
              if( nCol = ::nCol, if( nRow > ::nRow, PI, 0 ), ;
                                 if( nCol > ::nCol, PI * 0.5, PI * 1.5 ) )
      ::Position( nPos )

      if ::bPos != nil
         Eval( ::bPos, ::nGetVal( ::nPos ) )
      endif

      /*
      Esto esta modificado por mi
      */

      ::Change()

      return 0

   else
      ::oWnd:SetMsg( ::cMsg )
   endif

   if ::oCursor != nil
      SetCursor( ::oCursor:hCursor )
   else
      CursorArrow()
   endif

return 0

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TSelector

   do case
      case nKey == VK_UP .or. nKey == VK_LEFT
           If ::lExact
              ::PlaceMark( ::nPos, -1 )
           else
              ::SetPosition( ::nPos - 1 * DEG )
           endif

           ::Change()

           return 0

      case nKey == VK_DOWN .or. nKey == VK_RIGHT
           If ::lExact
              ::PlaceMark( ::nPos, 1 )
           else
              ::SetPosition( ::nPos + 1 * DEG )
           endif

           ::Change()

           return 0

   endcase

return Super:KeyDown( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD PlaceMark( nPos, nStep ) CLASS TSelector

   local nMark
   local nLap := ::nArc / ( ::nMarks - 1 )

   nPos  += if( nPos < ::nOrigin, PI * 2, 0 )
   nMark := Round( ( nPos - ::nOrigin ) / nLap, 0 ) + 1

   nPos := AdjPos( ::nOrigin + ;
                 ( Max( 1, Min( nMark + nStep, ::nMarks ) ) - 1 ) * nLap )

   ::SetPosition( nPos )

return nil

//----------------------------------------------------------------------------//

METHOD Position( nPos, nInit, nDeviation ) CLASS TSelector

   static nDev := 0
   static nOldPos

   ::GetDC()

   if nPos = nil

      if nInit = nil
         nPos := nOldPos
      else
         nPos := nOldPos := ::nPos // ::nGetPos( Eval( ::bSetGet ) )
         nDev := if( nDeviation != nil, nDeviation, nPos - nInit )
      endif

   else

      nPos := AdjPos( nPos += nDev )

      nPos := EvalPos( nPos, ::nOrigin, ::nLast )

   endif

   ::nPos := nPos

   ::Paint()

   nOldPos := nPos

   ::ReleaseDC()

return nil

//  Static functions
//----------------------------------------------------------------------------//

static function EvalPos( nPos, nInit, nLast )
  static nLimit

  if nInit > nLast

     if nPos < nInit .and. nPos > nLast
        if nLimit = nil
           nPos := nLimit := if( nInit - nPos < nPos - nLast, nInit, nLast )
        else
           nPos := nLimit
        endif
     else
        nLimit := nil
     endif

  else

     if nPos < nInit .or. nPos > nLast
        if nLimit = nil
           nPos := nLimit := if( nPos < nInit, nInit, nLast )
        else
           nPos := nLimit
        endif
     else
        nLimit := nil
     endif

  endif

return nPos

//----------------------------------------------------------------------------//

static function AdjPos( nPos )
return  nPos + if( nPos < 0, 2 * PI, if( nPos > 2 * PI, -2 * PI, 0 ) )

//----------------------------------------------------------------------------//

function Sin( nAng )

   local nSin, nOld
   local nMod := 3
   local lSgn := .f.

   nSin := nAng

   do while nSin != nOld

      nOld = nSin

      if lSgn
         nSin += (nAng ** nMod) / Fac( nMod )
      else
         nSin -= (nAng ** nMod) / Fac( nMod )
      endif

      nMod += 2

      lSgn = !lSgn

   enddo

return nSin

//----------------------------------------------------------------------------//

function Cos( nAng )

   local nCos, nOld
   local nMod := 2
   local lSgn := .f.

   nCos := 1

   do while nCos != nOld

      nOld = nCos

      if lSgn
         nCos += (nAng ** nMod) / Fac( nMod )
      else
         nCos -= (nAng ** nMod) / Fac( nMod )
      endif

      nMod += 2

      lSgn = !lSgn

   enddo

return nCos

//----------------------------------------------------------------------------//

function Tang( nAng )

   local nTang := Sin( nAng ) / Cos( nAng )

return nTang

//----------------------------------------------------------------------------//

function ATang( nTang )

   local nAng, nOld
   local nMod := 3
   local lSgn := .f.

   if nTang >= 0.95 .and. nTang <= 1.05
      return PI / 4
   endif

   if nTang <= -0.95 .and. nTang >= -1.05
      return -PI / 4
   endif

   if nTang >= 1

      nAng :=   PI / 2 - 1 / nTang

   elseif nTang <= -1

      nAng := - PI / 2 - 1 / nTang

   else

     nAng := nTang

     do while nAng != nOld

        nOld = nAng

        if lSgn
           nAng += nTang ** nMod / nMod
        else
           nAng -= nTang ** nMod / nMod
        endif

        nMod += 2

        lSgn = !lSgn

     enddo

     return nAng

   endif

   lSgn := .t.

   do while nAng != nOld

      nOld = nAng

      if lSgn
         nAng += 1 / ( nMod * nTang ** nMod )
      else
         nAng -= 1 / ( nMod * nTang ** nMod )
      endif

      nMod += 2

      lSgn = !lSgn

   enddo

return nAng

//----------------------------------------------------------------------------//

static function Fac( nNum )
  local n, nFac := 1

  for n := 2 to nNum
      nFac *= n
  next

return nFac

//----------------------------------------------------------------------------//
// R.Avendaño. 1998, 1999