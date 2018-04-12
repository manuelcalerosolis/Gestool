#include "FiveWin.ch"
#include "Constant.ch"
#include "URLLink.ch"

#define COLOR_BTNFACE   15
#define WM_NCHITTEST   132  // 0x84

//----------------------------------------------------------------------------//

CLASS TURLLink FROM TControl

   DATA   cURL, nClrInit, nClrOver, nClrVisit
   DATA   bAction
   DATA   hBmp
   DATA   lWantClick

   METHOD New( nTop, nLeft, oWnd, lPixel, lDesign, oFont, cMsg, cURL, ;
               cToolTip, nClrInit, nClrOver, nClrVisit, lTransp ) CONSTRUCTOR

   METHOD ReDefine( nId, oWnd, oFont, cMsg, cURL, cToolTip, nClrInit, ;
                    nClrOver, nClrVisit, lTransp ) CONSTRUCTOR

   METHOD cToChar() INLINE  ::Super:cToChar( "STATIC" )


   METHOD Default()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Initiate( hDlg ) INLINE ::Super:Initiate( hDlg ), ::SetText( ::cCaption ), ::Default()

   METHOD LButtonDown( nRow, nCol, nFlags, lTouch )

   METHOD MouseLeave( nRow, nCol, nFlags )
   METHOD MouseMove( nRow, nCol, nFlags )

   METHOD Paint()
   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD Destroy()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, oWnd, lPixel, lDesign, oFont, cMsg, cURL, ;
            cToolTip, nClrInit, nClrOver, nClrVisit, lTransp ) CLASS TURLLink

   local nClrPane

   DEFAULT nTop      := 0, nLeft := 0, ;
           oWnd      := GetWndDefault(),;
           lPixel    := .F.,;
           lDesign   := .F.,;
           nClrInit  := CLR_HBLUE,;
           nClrOver  := CLR_HRED,;
           nClrVisit := CLR_MAGENTA,;
           nClrPane  := oWnd:nClrPane,;
           lTransp   := .f.

   ::nStyle     := nOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP, ;
                        If( lDesign, WS_CLIPSIBLINGS, 0 ) )
   ::nId        := ::GetNewId()
   ::oWnd       := oWnd
   ::cMsg       := cMsg
   ::cCaption   := cURL
   ::cURL       := cURL
   ::cToolTip   := cToolTip
   ::nClrInit   := nClrInit
   ::nClrOver   := nClrOver
   ::nClrVisit  := nClrVisit
   ::nTop       := If( lPixel, nTop,  nTop  * SAY_CHARPIX_H )
   ::nLeft      := If( lPixel, nLeft, nLeft * SAY_CHARPIX_W )
   ::lDrag      := lDesign
   ::lCaptured  := .f.
   ::lWantClick := .t.
   if oFont == nil
      ::oFont     := TFont():New( GetSysFont(), 0, -12,,,,,,, .T. )
   else
      ::SetFont( oFont )
   endif
   ::oCursor      := TCursor():New( , "HAND" )
   ::lUnicode     := FW_SetUnicode()
   ::lTransparent := lTransp

   ::SetColor( nClrInit, nClrPane )

   if ! Empty( oWnd:hWnd )
      ::Create( "STATIC" )
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

METHOD ReDefine( nId, oWnd, oFont, cMsg, cURL, cToolTip, nClrInit, nClrOver, ;
                 nClrVisit, lTransp ) CLASS TURLLink

   DEFAULT oWnd      := GetWndDefault(), ;
           nClrInit  := CLR_HBLUE, ;
           nClrOver  := CLR_HRED, ;
           nClrVisit := CLR_MAGENTA, ;
           lTransp   := .f.



   ::nId        := nId
   ::oWnd       := oWnd
   ::cMsg       := cMsg
   ::cCaption   := cURL
   ::cURL       := cURL
   ::cToolTip   := cToolTip
   ::nClrInit   := nClrInit
   ::nClrOver   := nClrOver
   ::nClrVisit  := nClrVisit
   ::lCaptured  := .f.
   ::lWantClick := .t.

   if oFont == nil
      ::oFont     := TFont():New( GetSysFont(), 0, -12,,,,,,, .T. )
   else
      ::SetFont( oFont )
   endif

   ::oCursor      := TCursor():New( , "HAND" )
   ::lUnicode     := FW_SetUnicode()
   ::lTransparent := lTransp

   ::SetColor( nClrInit, GetSysColor( COLOR_BTNFACE ) )

   if ::lTransparent
      ::SetBrush( ::oWnd:oBrush )
   endif

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Default() CLASS TURLLink

   local aRect := GetLabelDim( ::hWnd, ::cCaption, ::oFont:hFont )

   ::nRight  := ::nLeft + aRect[ 1 ]
   ::nBottom := ::nTop  + aRect[ 2 ]

   ::SetFont( ::oFont )

   ::Move( ::nTop, ::nLeft, ::nRight - ::nLeft, ::nBottom - ::nTop, .t. )

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TURLLink

   if nMsg == WM_MOUSELEAVE
      return ::MouseLeave( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )
   endif

   if ( ( ::lDrag .or. ::lWantClick ) .and. nMsg == WM_NCHITTEST ) // To have a standard behavior on Clicks
      return DefWindowProc( ::hWnd, nMsg, nWParam, nLParam )
   endif

return ::Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags, lTouch ) CLASS TURLLink

   if ! Empty( ::cURL ) .and. Empty( ::bAction )
      ShellExecute( ::hWnd, "open", ::cURL )
      ::nClrInit := ::nClrVisit
   endif

   if ! Empty( ::bAction )
      Eval( ::bAction, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseLeave( nRow, nCol, nFlags ) CLASS TURLLink

   if ::nClrText != ::nClrInit
      ::nClrText = ::nClrInit

      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nFlags ) CLASS TURLLink

   ::Super:MouseMove( nRow, nCol, nFlags )

   if ::nClrText != ::nClrOver
      ::nClrText = ::nClrOver

      ::Refresh()
   endif

   TrackMouseEvent( ::hWnd, TME_LEAVE )

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TURLLink

   local aInfo := ::DispBegin()


   if GetTextColor( ::hDC ) != ::nClrText
      SetTextColor( ::hDC, ::nClrText )
   endif

   FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )

   CallWindowProc( ::nOldProc, ::hWnd, WM_PAINT, ::hDC, 0 )

   if ValType( ::bPainted ) == "B"
      Eval( ::bPainted, ::hDC, ::cPS, Self )
   endif

   ::DispEnd( aInfo )

return nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TURLLink

  DeleteObject( ::hBmp )

return ::Super:Destroy()

//----------------------------------------------------------------------------//
