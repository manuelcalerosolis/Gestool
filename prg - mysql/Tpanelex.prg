#include "fivewin.ch"

#define GW_CHILD              5
#define GW_HWNDNEXT           2

#define DEFAULT_GUI_FONT      17
#define WM_ERASEBKGND         20
#define SWP_NOSIZE            1

#define SB_HORZ               0
#define SB_VERT               1
#define SB_CTL                2
#define SB_BOTH               3

*************************************************************************************************************************************

CLASS TPanelEx FROM TPanel

      DATA lVScroll
      DATA WM_RESETPOS
      DATA nClrBorder

      CLASSDATA lRegistered AS LOGICAL

      METHOD New( nTop, nLeft, nBottom, nRight, oWnd, nClrPane, lVScroll ) CONSTRUCTOR

      METHOD Paint()
      METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(),0

      METHOD VScroll( nWParam, nLParam )
      METHOD MouseWheel( nKey, nDelta, nXPos, nYPos )
      METHOD HandleEvent( nMsg, nWParam, nLParam )

      METHOD Disable()
      METHOD Enable()

      METHOD Destroy()

      METHOD GetText() INLINE ::cCaption

ENDCLASS

*************************************************************************************************************************************

METHOD New( nTop, nLeft, nBottom, nRight, oWnd, nClrPane, lVScroll ) CLASS TPanelEx

   DEFAULT nTop := 0, nLeft := 0, nBottom := 100, nRight := 100,;
           oWnd := GetWndDefault(), nClrPane :=  CLR_WHITE, lVScroll := .f.

   ::nTop      := nTop
   ::nLeft     := nLeft
   ::nBottom   := nBottom
   ::nRight    := nRight
   ::oWnd      := oWnd
   ::nStyle    := nOr( WS_CHILD, WS_VISIBLE, WS_CLIPSIBLINGS, WS_CLIPCHILDREN, WS_VSCROLL )
   ::lDrag     := .f.
   ::nClrPane  := nClrPane
   ::aControls := {}
   ::lVScroll  := lVScroll
   ::cCaption  := ""

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::Register()
   ::SetColor( 0, nClrPane )

   if ! Empty( ::oWnd:hWnd )
      ::Create()
      ::oWnd:AddControl( Self )
   else
      ::oWnd:DefControl( Self )
   endif

   ::oVScroll := TScrollBar():WinNew( ,,, .t., self )
   ::oVScroll:SetRange(0,0)

   ::WM_RESETPOS := RegisterWindowMessage( "WM_RESETPOS" )

   ShowScrollBar( ::hWnd, 1, .f. )

return Self

*************************************************************************************************************************************

METHOD Destroy() CLASS TPanelEx

return ::Super:Destroy()

*************************************************************************************************************************************

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TPanelEx


local n, nLen

   do case
      case nMsg == WM_ERASEBKGND
           return 1

      case nMsg == ::WM_RESETPOS
           nLen := len( ::aControls )
           for n := 1 to nLen
               ::aControls[n]:Move(0,0,,,.t.)
           next
           ::oVScroll:SetPos(0)
           ::Refresh()
   endcase

return ::Super:HandleEvent( nMsg, nWParam, nLParam )

***************************************************************************
   METHOD Paint() CLASS TPanelEx
***************************************************************************
local cText
local hFont
local hOldFont
local nHLen
local n, nLen
local nHeight := ::nHeight
local nMaxB := 0
local nMinTop    := int(nHeight / 2)
local nMaxBottom := int(nHeight / 2)
local rc := GetClientRect(::hWnd)

::Super:Paint()

if ::lVScroll

   nLen := len( ::aControls )

   for n := 1 to nLen
       if IsWindowVisible( ::aControls[n]:hWnd )
          nMinTop    := min( WndTop( ::aControls[n]:hWnd ), nMinTop )
          nMaxBottom := max( WndTop( ::aControls[n]:hWnd )+ ::aControls[n]:nHeight, nMaxBottom )
       endif
   next

   if nMinTop < 0 .or. nMaxBottom > nHeight
      ::oVScroll:SetRange( 0, 10 )
   else
      ::oVScroll:SetRange( 0, 0 )
   endif

endif

if ::nClrPane != nil
   FillSolidRect( ::hDC, rc, ::nClrPane )
endif

if ::nClrBorder != nil
   Box( ::hDC, {rc[1],rc[2],rc[3]-1,rc[4]-1},::nClrBorder )
endif

if ::bPainted != nil
   Eval( ::bPainted, ::hDC, self )
endif

return nil

***************************************************************************
  METHOD VScroll( nWParam, nLParam ) CLASS TPanelEx
***************************************************************************


   local nScrollCode := nLoWord( nWParam )
   local nPos := nHiWord( nWParam )
   local n, nLen
   local nTop
   local nLeft
   local n2, nLen2

   do case
      case nScrollCode == SB_LINEUP

           ::oVScroll:GoUp()
           nPos := ::oVScroll:GetPos()

           nLen := len( ::aControls )
           for n := 1 to nLen
               nTop  := -(((::aControls[n]:nHeight - GetClientRect(::hWnd )[3])/10)*nPos)
               if nTop > 3
                  nTop := 0
               endif
               nLeft := ::aControls[n]:nLeft
               ::aControls[n]:Move( nTop,nLeft,,,.t. )
               ::aControls[n]:Refresh()
           next

           return 0

      case nScrollCode == SB_LINEDOWN

           ::oVScroll:GoDown()
           nPos := ::oVScroll:GetPos()

           nLen := len( ::aControls )
           for n := 1 to nLen
               nTop  := -(((::aControls[n]:nHeight - GetClientRect(::hWnd )[3])/10)*nPos)
               if nTop > 3
                  nTop := 0
               endif
               nLeft := ::aControls[n]:nLeft
               ::aControls[n]:Move( nTop,nLeft,,,.t. )
               ::aControls[n]:Refresh()

           next

           return 0

      case nScrollCode == SB_PAGEUP

           ::oVScroll:PageUp()
           nPos := ::oVScroll:GetPos()

           nLen := len( ::aControls )
           for n := 1 to nLen
               nTop  := -(((::aControls[n]:nHeight - GetClientRect(::hWnd )[3])/10)*nPos)
               if nTop > 3
                  nTop := 0
               endif
               nLeft := ::aControls[n]:nLeft
               ::aControls[n]:Move( nTop,nLeft,,,.t. )
           next

           return 0


      case nScrollCode == SB_PAGEDOWN

           ::oVScroll:PageDown()
           nPos := ::oVScroll:GetPos()

           nLen := len( ::aControls )
           for n := 1 to nLen
               nTop  := -(((::aControls[n]:nHeight - GetClientRect(::hWnd )[3])/10)*nPos)
               if nTop > 3
                  nTop := 0
               endif
               nLeft := ::aControls[n]:nLeft
               ::aControls[n]:Move( nTop,nLeft,,,.t. )

           next


      case nScrollCode == SB_TOP

           ::oVScroll:GoTop()
           nPos = ::oVScroll:nMin
           ::oVScroll:SetPos(nPos)
           nLen := len( ::aControls )
           for n := 1 to nLen
               nTop  := -(((::aControls[n]:nHeight - GetClientRect(::hWnd )[3])/10)*nPos)
               if nTop > 3
                  nTop := 0
               endif
               nLeft := ::aControls[n]:nLeft
               ::aControls[n]:Move( nTop,nLeft,,,.t. )

           next

           ::Refresh( .f. )
           ::Refresh( .f. )

      case nScrollCode == SB_BOTTOM
           nPos = ::oVScroll:nMax
           ::oVScroll:SetPos(nPos)
           nLen := len( ::aControls )
           for n := 1 to nLen
               nTop  := -(((::aControls[n]:nHeight - GetClientRect(::hWnd )[3])/10)*nPos)
               if nTop > 3
                  nTop := 0
               endif
               nLeft := ::aControls[n]:nLeft
               ::aControls[n]:Move( nTop,nLeft,,,.t. )

           next

           ::Refresh( .f. )
           return 0

       case nScrollCode == SB_THUMBTRACK

           nPos := GetScrollInfoPos( ::hWnd, 1 )

           nLen := len( ::aControls )
           for n := 1 to nLen
               nTop  := -(((::aControls[n]:nHeight - GetClientRect(::hWnd )[3])/10)*nPos)
               if nTop > 3
                  nTop := 0
               endif
               nLeft := ::aControls[n]:nLeft
               ::aControls[n]:Move( nTop,nLeft,,,.t. )
           next

       case nScrollCode == SB_THUMBPOSITION

           ::oVScroll:ThumbPos( nPos )

      otherwise
           return nil
   endcase


   ::oVScroll:SetPos( nPos )

return 0

*************************************************************************************
  METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos ) CLASS TPanelEx
*************************************************************************************

if ::lVScroll
   if nDelta < 0
      ::VScroll( nMakeLong( SB_LINEUP, 0 ),0)
   else
      ::VScroll( nMakeLong( SB_LINEDOWN, 0 ),0)
   endif
endif

return nil

*************************************************************************************
      METHOD Disable() CLASS TPanelEx
*************************************************************************************
   local hCtrl := GetWindow( ::hWnd, GW_CHILD )
   local oCtrl

   while hCtrl != 0
         oCtrl := oWndFromhWnd( hCtrl )
         if oCtrl != nil
            oCtrl:Disable()
            oCtrl:Refresh()
         endif
         hCtrl = GetWindow( hCtrl, GW_HWNDNEXT )
   end

return 0


*************************************************************************************
      METHOD Enable() CLASS TPanelEx
*************************************************************************************

   local hCtrl := GetWindow( ::hWnd, GW_CHILD )
   local oCtrl

   while hCtrl != 0
         oCtrl := oWndFromhWnd( hCtrl )
         if oCtrl != nil
            oCtrl:Enable()
            oCtrl:Refresh()
         endif
         hCtrl = GetWindow( hCtrl, GW_HWNDNEXT )
   end

return 0

*************************************************************************************

#pragma BEGINDUMP

#include <windows.h>
#include <hbapi.h>

HB_FUNC( SHOWSCROLLBAR )
{
    hb_retl( ShowScrollBar( (HWND) hb_parnl( 1 ), hb_parni( 2 ), hb_parl( 3 ) ) );
}

#pragma ENDDUMP

*************************************************************************************
