#include "FiveWin.Ch"
#include "objects.ch"

#define SRCCOPY                13369376

CLASS TAnimat FROM TControl

      DATA acBitmaps
      DATA aBitmaps
      DATA lGo
      DATA oTimer
      DATA nSpeed
      DATA nActual
      DATA nHBmp, nWBmp

      DATA lWorking
      DATA lPainted
      DATA lFromTimer

      CLASSDATA lRegistered AS LOGICAL

      METHOD Redefine( oWnd, nId, acBitmaps, nSpeed ) CONSTRUCTOR

      METHOD Go   () INLINE ::oTimer:Activate()
      METHOD Stop () INLINE ::oTimer:End()

      METHOD Destroy() INLINE aeval( ::aBitmaps, {|x| DeleteObject( x ) } ) ,;
                              ::oTimer:End()                          ,;
                              ::Super:Destroy()

      METHOD Initiate( hDlg ) INLINE ::Super:Initiate( hDlg ), ::Default()
      METHOD Init    ( hDlg ) INLINE ::Super:Init    ( hDlg ), ::Default()

      METHOD Display() INLINE ::BeginPaint(),::Paint(),::EndPaint()

      METHOD Paint( lFromTimer )

      METHOD LoadBmps( acBitmaps )

      METHOD Default()

ENDCLASS

***************************************************
 METHOD Redefine( oWnd, nId, acBitmaps, nSpeed )
***************************************************

 DEFAULT nSpeed := 4 // decimas de segundos

 ::oWnd       := oWnd
 ::nId        := nId
 ::acBitmaps  := acBitmaps
 ::aBitmaps   := {}
 ::nSpeed     := nSpeed
 ::lWorking   := .f.
 ::lPainted   := .f.
 ::lFromTimer := .f.
 ::nActual    := 0

 ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

 if oWnd != nil
    oWnd:DefControl( Self )
 endif

 if ::oBrush != nil
    ::oBrush:End()
 endif

 ::oBrush := TBrush():New("NUL")

return ( Self )

***********************************************
 METHOD Default()
***********************************************

DEFINE TIMER ::oTimer INTERVAL ::nSpeed * 100 ACTION ( ::lFromTimer := .t.,::Refresh()) OF Self

::LoadBmps( ::acBitmaps )

::SetSize( ::nWBmp, ::nHBmp, .t. )

return ( Self )

****************************
 METHOD Paint()
****************************

local nLeft
local nW1
local nW2
local hDCMem
local hOldBmp

if !::lPainted
   ::lPainted := .t.
   ACTIVATE TIMER ::oTimer
   return nil
endif

::GetDC()

if  ::lFromTimer  .and. !::lWorking

   ::lWorking := .t.

   if ::nActual > 10
      ::nActual := 0
   endif

   nLeft := ( ::nWBmp / 10 ) * ::nActual

   nW1   := nLeft
   nW2   := ::nWBmp - nLeft

   ::nActual++

endif

   hDCMem   = CompatDC( ::hDC )
   hOldBmp  = SelectObject( hDCMem, ::aBitMaps[1] )

   StretchBlt( ::hDC,   nLeft,  0, nW2, ::nHBmp, hDCMem, 0,   0, nW2, ::nHBmp, SRCCOPY )
   StretchBlt( ::hDC,       0,  0, nW1, ::nHBmp, hDCMem, nW2, 0, nW1, ::nHBmp, SRCCOPY )

   SelectObject( hDCMem, hOldBmp )
   DeleteDC( hDCMem )

   // DrawBitmap( ::hDC, ::aBitmaps[ max( ::nActual , 1 ) ], 0, 0, ::nWBmp, ::nHBmp, SRCCOPY )

   ::ReleaseDC()

   ::lFromTimer := .f.
   ::lWorking   := .f.

   SysRefresh()

   if ::bPainted != nil
      eval( ::bPainted, self )
   endif

return ( Self )

***************************************
  METHOD LoadBmps( acBitmaps )
***************************************
local n

::GetDC()

for n := 1 to len( ::acBitmaps )

    if "." $ ::acBitmaps[ n ]
       aadd( ::aBitmaps, ReadBitmap( ::hDC, ::acBitmaps[ n ] ) )
    else
       aadd( ::aBitmaps, LoadBitmap( GetResources(), ::acBitmaps[ n ] ) )
    endif

next n

::nHBmp := nBmpHeight( ::aBitmaps[ 1 ] )
::nWBmp := nBmpWidth ( ::aBitmaps[ 1 ] )

::ReleaseDC()

return ( Self )