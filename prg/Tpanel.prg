// TPanel Class. Mainly used for Automatic Alignment techniques

#include "FiveWin.ch"

#define COLOR_BTNFACE   15

//----------------------------------------------------------------------------//

CLASS TPanel FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   CLASSDATA aProperties INIT { "aControls", "nAlign", "nClrPane", "Cargo" }

   DATA nOpacity AS NUMERIC INIT 255

   METHOD New( nTop, nLeft, nBottom, nRight, oWnd, lDesign, cVarName ) CONSTRUCTOR

   METHOD EraseBkGnd( hDC )

   METHOD Paint()
   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD Notify( nIdCtrl, nPtrNMHDR ) INLINE ::oWnd:Notify( nIdCtrl, nPtrNMHDR )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, oWnd, lDesign, cVarName ) CLASS TPanel

   DEFAULT nTop := 0, nLeft := 0, nBottom := 100, nRight := 100,;
           oWnd := GetWndDefault(), lDesign := .F.

   ::lUnicode  = FW_SetUnicode()
   ::nTop    = nTop
   ::nLeft   = nLeft
   ::nBottom = nBottom
   ::nRight  = nRight
   ::oWnd    = oWnd
   ::nStyle  = nOr( WS_CHILD, WS_VISIBLE, WS_CLIPCHILDREN )
   //::lDrag   = .f.
   ::lDrag   = lDesign
   ::nClrPane = GetSysColor( COLOR_BTNFACE )

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::Register()

   if ! Empty( ::oWnd:hWnd )
      ::Create()
      ::oWnd:AddControl( Self )
      if ::oWnd:oBrush != nil
         ::SetBrush( ::oWnd:oBrush )
      endif
      if ::oWnd:oFont != nil
         ::SetFont( ::oWnd:oFont )
      endif
   else
      ::oWnd:DefControl( Self )
   endif
   DEFAULT cVarName := "oPnel" + ::GetCtrlIndex()
   ::cVarName = cVarName
   if lDesign
      ::CheckDots()
   endif


return Self

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TPanel

   local nTop, nLeft, nHeight, nWidth, nBevel
   local aInfo := ::DispBegin()

   if ::lTransparent .or. ::nOpacity < 255
      SetBrushOrgEx( ::hDC, -::nLeft, -::nTop )
      FillRect( ::hDC, GetClientRect( ::hWnd ), ::oWnd:oBrush:hBrush )
      if ! ::lTransparent
         FillRectEx( ::hDC, GetClientRect( ::hWnd ), nARGB( ::nOpacity, ::nClrPane ) )
      endif
   else
      ::PaintBack( ::hDC )
      // FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush ) // fwh 16.12
   endif

   if ::oClient != nil .and. ( nBevel := ::oClient:nClientBevel ) > 0
      nBevel  -= 1
      nTop    := nBevel
      nLeft   := nBevel
      nHeight := ::nHeight - nBevel - 1
      nWidth  := ::nWidth - nBevel - 1
      if ::oTop != nil
         nTop += ::oTop:nHeight
      endif
      if ::oBottom != nil
         nHeight -= ::oBottom:nHeight
      endif
      if ::oLeft != nil
         nLeft += ::oLeft:nWidth
      endif
      if ::oRight != nil
         nWidth -= ::oRight:nWidth
      endif
      WndBoxIn( ::hDC, nTop, nLeft, nHeight, nWidth )
   endif

   if ValType( ::bPainted ) == "B"
      Eval( ::bPainted, ::hDC, ::cPS, Self )
   endif

   ::DispEnd( aInfo )

return 0

//----------------------------------------------------------------------------//

METHOD EraseBkGnd( hDC ) CLASS TPanel

   if ::oWnd != nil .and. IsAppThemed() .and. ;
      Upper( ::oWnd:ClassName() ) $ "TFOLDER,TFOLDEREX,TREBAR,TGROUP,TPANEL"
      DrawPBack( ::hWnd, hDC )
      return 1
   endif

return 1

//----------------------------------------------------------------------------//
