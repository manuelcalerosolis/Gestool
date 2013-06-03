#include "FiveWin.Ch"
#include "Constant.ch"

#define LTGRAY_BRUSH 1

#ifdef __XPP__
   #define Super ::TControl
   #define New _New
#endif

//----------------------------------------------------------------------------//

CLASS TMeter FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   DATA   nTotal, nRefresh //add nRefresh 27 Jul 96, used for sysrefresh jrh
   DATA   nClrBar, nClrBText
   DATA   cText, lPercentage
   DATA   nCurrent

   METHOD New( nRow, nCol, bSetGet, nTotal, oWnd, nWidth, nHeight,;
               lUpdate, lPixel, oFont, cText, lNoPercentage, ;
               nClrPane, nClrText, nClrBar, nClrBText, lDesign ) CONSTRUCTOR

   METHOD ReDefine( nId, bSetGet, nTotal, oWnd, lUpdate, ;
                    oFont, cText, lNoPercentage, ;
                    nClrPane, nClrText, nClrBar, nClrBText ) CONSTRUCTOR
   METHOD Default()

   METHOD Initiate( hDlg ) INLINE Super:Initiate( hDlg ), ::Default()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Paint()

   METHOD Set( nActual )
   METHOD SetTotal( nTotal )  INLINE ( ::nTotal := nTotal, ::nCurrent := 0, ::Refresh() )

   METHOD AutoInc()

   METHOD SetText( cText )    INLINE ( ::cText := cText, ::Refresh() )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, nTotal, oWnd, nWidth, nHeight,;
            lUpdate, lPixel, oFont, cText, lNoPercentage, nClrPane, nClrText, ;
            nClrBar, nClrBText, lDesign ) CLASS TMeter

   #ifdef __XPP__
      #undef New
   #endif

   DEFAULT nRow            := 0
   DEFAULT nCol            := 0
   DEFAULT lNoPercentage   := .f.
   DEFAULT oWnd            := GetWndDefault()
   DEFAULT bSetGet         := { || 1 }
   DEFAULT lPixel          := .f.
   DEFAULT nClrBar         := Rgb( 128,255,0 )
   DEFAULT nClrBText       := CLR_WHITE
   DEFAULT nClrText        := oWnd:nClrText
   DEFAULT nClrPane        := oWnd:nClrPane
   DEFAULT cText           := Chr( 0 )
   DEFAULT nTotal          := 10
   DEFAULT nWidth          := 300
   DEFAULT nHeight         := 20
   DEFAULT lUpdate         := .f.
   DEFAULT lDesign         := .f.

   ::nTop      = If( lPixel, nRow, nRow * MTR_CHARPIX_H )  //14
   ::nLeft     = If( lPixel, nCol, nCol *  MTR_CHARPIX_W ) //8
   ::nBottom   = ::nTop  + nHeight
   ::nRight    = ::nLeft + nWidth
   ::oWnd      = oWnd
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                 If( lDesign, nOr( WS_CLIPSIBLINGS, WS_TABSTOP ), 0 ) )
   ::nId       = ::GetNewId()
   ::bSetGet   = bSetGet
   ::nTotal    = nTotal
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::lUpdate   = .f.

   ::nClrText  = nClrText
   ::nClrPane  = nClrPane
   ::nClrBar   = nClrBar
   ::nClrBText = nClrBText
   ::cText     = cText
   ::lPercentage = ! lNoPercentage

   ::oFont     = oFont

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   ::nCurrent  := 0
   ::nRefresh  := 0  // initailize for sysrefresh 27 Jul 96 jrh

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

METHOD ReDefine( nId, bSetGet, nTotal, oWnd, lUpdate, ;
                 oFont, cText, lNoPercentage, nClrPane, nClrText, ;
                 nClrBar, nClrBText ) CLASS TMeter

   DEFAULT lNoPercentage   := .f.
   DEFAULT nTotal          := 10
   DEFAULT lUpdate         := .f.
   DEFAULT nClrBar         := Rgb( 128,255,0 )
   DEFAULT nClrBText       := CLR_WHITE
   DEFAULT nClrText        := oWnd:nClrText
   DEFAULT nClrPane        := oWnd:nClrPane
   DEFAULT cText           := Chr( 0 )

   ::nId       = nId
   ::bSetGet   = bSetGet
   ::nTotal    = nTotal
   ::oWnd      = oWnd
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lUpdate   = lUpdate

   ::nClrText  = nClrText
   ::nClrPane  = nClrPane
   ::nClrBar   = nClrBar
   ::nClrBText = nClrBText
   ::cText     = cText
   ::lPercentage = ! lNoPercentage
   ::oFont     = oFont

   ::nCurrent  := 0
   ::nRefresh  := 0  // initailize for sysrefresh 27 Jul 96 jrh

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if oWnd != nil
      oWnd:DefControl( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TMeter

   if nMsg == WM_PAINT
      ::BeginPaint()
      ::Paint()
      ::EndPaint()
      return 0
   endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//
METHOD Paint() CLASS TMeter

   local nActual := Eval( ::bSetGet )

   MeterPaint( ::hWnd, ::hDC, nActual, ::nTotal,;
               nActual * 100 / If( ::nTotal != 0, ::nTotal, 1 ),;
               ::cText, ::lPercentage,;
               ::nClrPane, ::nClrText,;
               ::nClrBar,  ::nClrBText, ;
               If( ::oFont == NIL, 0, ::oFont:hFont ) )
return nil

//----------------------------------------------------------------------------//

METHOD Set( nActual ) CLASS TMeter

   DEFAULT nActual   := Eval( ::bSetGet )

   if nActual > ::nTotal
      nActual        := ::nTotal
   endif

   if nActual < 0
      nActual        := 0
   endif

   Eval( ::bSetGet, nActual )

   if ::nTotal != 0 .and. Int( ::nRefresh + ( nActual / ::nTotal ) * 100 ) >= ::nRefresh + 1
      ::nRefresh     += Int( ( nActual / ::nTotal ) * 100 )
      ::Refresh( .f. )
      SysRefresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TMeter

   if ValType( Eval( ::bSetGet ) ) == "U"
      Eval( ::bSetGet, 0 )
   endif

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::SetFont( ::oWnd:oFont )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD AutoInc()

   ::nCurrent++

   if ( ::nTotal < 100 ) .or. ( Mod( ::nCurrent, Int( ::nTotal / 100 ) ) == 0 )
      ::Set( ::nCurrent )
   end if

Return nil

//----------------------------------------------------------------------------//