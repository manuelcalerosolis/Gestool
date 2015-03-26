// TPanel Class. Mainly used for Automatic Alignment techniques

#include "FiveWin.Ch"

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
#endif

//----------------------------------------------------------------------------//

CLASS TMPanel FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR
   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0
   METHOD Paint()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TMPanel

   DEFAULT nTop := 0, nLeft := 0, nBottom := 100, nRight := 100,;
           oWnd := GetWndDefault()

   ::nTop    = nTop
   ::nLeft   = nLeft
   ::nBottom = nBottom
   ::nRight  = nRight
   ::oWnd    = oWnd
   ::nStyle  = nOr( WS_CHILD, WS_VISIBLE, WS_CLIPSIBLINGS,;
                      WS_CLIPCHILDREN, )
   ::lDrag   = .f.

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::Register()

   if ! Empty( ::oWnd:hWnd )
      ::Create()
      ::oWnd:AddControl( Self )
   else
      ::oWnd:DefControl( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TMPanel

if ::bPainted != nil
   eval( ::bPainted, ::hDC )
endif

return nil