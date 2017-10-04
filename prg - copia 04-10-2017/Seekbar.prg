#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

CLASS TSeekBar FROM TControl

   CLASSDATA lRegistered AS LOGICAL
   CLASSDATA aBitmaps    AS ARRAY    INIT {}

   DATA hBmpPal
   DATA cTitle, cBitmap, cResBmp
   DATA oGet, oFont
   DATA lGet

   METHOD New()     CONSTRUCTOR

   METHOD Paint()
   METHOD Load()
   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint()
   METHOD destroy()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, lGet, cTitle, nFontSize, nHeigth, cResBmp, cBitmap ) CLASS TSeekBar

   local aBmpPal

   DEFAULT oWnd := GetWndDefault(), lGet := .t., cTitle := "", ;
           nFontSize := -12, nHeigth := 30

   ::oWnd      = oWnd
   ::lGet      = lGet
   ::cTitle    = cTitle
   ::nTop      = 0
   ::nLeft     = 0
   ::nBottom   = nHeigth
   ::nRight    = 0
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE )
   ::cBitmap   = cBitmap
   ::cResBmp   = cResBmp
   ::hBmpPal   = 0
   ::oFont     = TFont():New( "Arial", 0, nFontSize,,,,,,,,,,,,, )

   ::Load( cResBmp, cBitmap )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( ::oWnd:hWnd )
      ::Create()
      ::oWnd:AddControl( Self )
   else
      ::oWnd:DefControl( Self )
   endif

return Self

//--------------------------------------------------------------------------//

METHOD Load( cResName, cBmpFile ) CLASS TSeekBar

   local nPos  := aScan( ::aBitMaps, {| cBmp | cBmp[ 1 ] == cResName .or. cBmp[ 1 ] == cBmpFile } )

   if nPos != 0
      ::hBmpPal   := ::aBitMaps[ nPos, 2 ]

   else

      if !Empty( cResName )
         ::hBmpPal := PalBmpLoad( cResName )
         ::cBitmap := cResName
         cBmpFile  := nil
      endif

      if cBmpFile != nil
         cBmpFile := AllTrim( cBmpFile )
      endif

      if !Empty( cBmpFile ) .and. File( cBmpFile )
         ::cBitmap := cBmpFile
         ::hBmpPal := PalBmpRead( ::GetDC(), cBmpFile )
         ::ReleaseDC()
      endif

      aAdd( ::aBitMaps, { ::cBitmap, ::hBmpPal } )

      if ::hBmpPal != 0
         PalBmpNew( ::hWnd, ::hBmpPal )
      endif

   end if

   ::Refresh()

return Self

//--------------------------------------------------------------------------//

METHOD Paint() CLASS TSeekBar

   local oGet, cText := Space(20)
   local lDC         := .f.
   local nRow        := 0
   local nCol        := 0
   local nWidth
   local nHeight
   local nBmpWidth
   local nBmpHeight, oBmp

   if ::hDC == nil
      ::GetDC()
      lDC         := .t.
   end if

   if !Empty( ::hBmpPal )

      nWidth      := ::nWidth()
      nHeight     := ::nHeight()
      nBmpWidth   := pBmpWidth( ::hBmpPal )
      nBmpHeight  := pBmpHeight( ::hBmpPal )

      while nRow <= nHeight
         nCol := 0
         while nCol <= nWidth
            PalBmpDraw( ::hDC, nRow, nCol, ::hBmpPal )
            nCol  += nBmpWidth
         end
         nRow     += nBmpHeight
      enddo

   endif

   if !Empty( ::cTitle )
      wSay( ::oWnd:hWnd, ::hDC, 7, 150, ::cTitle, CLR_BLACK,, ;
            ::oFont:hFont, .t., .t. )
   endif

   if ::oGet = nil .and. ::lGet
      @ 5,200 GET ::oGet VAR cText OF Self FONT ::oFont SIZE 350,22 PIXEL
   endif

   @ 0,0 BITMAP oBmp FILE "manos.bmp" PIXEL OF Self

   if lDC
      ::ReleaseDC()
   endif

return nil

//--------------------------------------------------------------------------//

METHOD Destroy() CLASS TSeekBar

   ::oFont:End()

   if ::hWnd != 0
      Super:Destroy()
   endif

return( Self := nil )

//--------------------------------------------------------------------------//