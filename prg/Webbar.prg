#include "FiveWin.Ch"
#include "Constant.ch"
#include "Objects.ch"
#include "Inkey.ch"

//--------------------------------------------------------------------------//

#define STEP_CTL        2
#define STEP_BMP        5

#define COLOR_BTNFACE   15
#define COLOR_BTNTEXT   18

#define OPAQUE          0
#define TRANSPARENT     1

#define CS_DBLCLKS      8

//--------------------------------------------------------------------------//

CLASS TWebBar FROM TControl

   CLASSDATA lRegistered   AS LOGICAL

   DATA hBitmap
   DATA hPalette
   DATA lCaptured          INIT .F.
   DATA nDesp              INIT 0
   DATA cBitmap
   DATA cResBmp
   DATA nCtlHeight         INIT 20
   DATA nClrLine
   DATA aSay
   DATA nLeftMargin        AS NUMERIC  INIT 10
   DATA nRightMargin       AS NUMERIC  INIT 0
   DATA nTopMargin         AS NUMERIC  INIT 0
   DATA nDnMargin          AS NUMERIC  INIT 0

   DATA nOption            AS NUMERIC  INIT 1

   METHOD New( nTop, nLeft, nWidth, nHeight, nCtlHeight, cBitmap,;
               cResBmp, nClrFore, nClrBack, nStyle, oBrush, oFont, ;
               lPixel, cMsg, oWnd, nHelpID, bRClick ) CONSTRUCTOR

   METHOD Redefine(  nId, nCtlHeight, cBitmap, cResBmp, nClrFore,;
                     nClrBack, nStyle, oBrush, oFont, lPixel, cMsg,;
                     oWnd, nHelpID, bRClick ) CONSTRUCTOR

   METHOD End()            INLINE ( if( ::hWnd == 0, ::Destroy(), ::Super:End() ) )

   METHOD Display()        INLINE ( ::BeginPaint(), ::Paint(), ::EndPaint() )

   METHOD Paint()

   METHOD EraseBkground()  INLINE 1

   METHOD Destroy()

   METHOD LoadImage( cResName, cBmpFile )

   METHOD Say( nRow, nCol, cText )

ENDCLASS

//--------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, nCtlHeight, cBitmap,;
            cResBmp, nClrFore, nClrBack, nStyle, oBrush, oFont, ;
            lPixel, cMsg, oWnd, nHelpID, bRClick ) CLASS TWebBar

   DEFAULT  nClrFore    := CLR_WHITE, ;
            nClrBack    := GetSysColor( COLOR_BTNFACE ), ;
            nStyle      := nOr( WS_CHILD, WS_VISIBLE, WS_CLIPSIBLINGS, WS_CLIPCHILDREN ) ,;
            nCtlHeight  := 30 ,;
            lPixel      := .t.,;
            oBrush      := TBrush():New( , Rgb( 255,255,255 ) )

            // oFont       := TFont():New( "Segoe UI Light", 0, -48, .f., .f. ),; //TFont():New( "Verdana", 0, -22, .f., .t. ),;

   ::nStyle       = nStyle
   ::nId          = ::GetNewId()
   ::oWnd         = oWnd
   ::nTop         = If( lPixel, nTop, nTop * WIN_CHARPIX_H )
   ::nLeft        = If( lPixel, nLeft, nLeft * WIN_CHARPIX_W )
   ::nBottom      = ::nTop + nHeight - 1
   ::nRight       = ::nLeft + nWidth - 1
   ::nCtlHeight   = nCtlHeight
   ::lCaptured    = .f.
   ::cBitmap      = cBitmap
   ::cResBmp      = cResBmp
   ::hBitmap      = 0
   ::nClrPane     = nClrBack
   ::nClrText     = nClrFore
   ::bRClicked    = bRClick
   ::nHelpID      = nHelpID
   ::nClrLine     = Rgb( 51, 51, 255 )
   ::oBrush       = oBrush
   ::nOption      = 1
   
   //::oFont        = oFont

   ::setFont( oFontBigTitle() )

   if ValType( cResBmp ) == "C" .or. ValType( cBitmap ) == "C"
      ::LoadImage( cResBmp, cBitmap )
   elseif ValType( cResBmp ) == "N"
      ::SetBitmap( cResBmp )
   else
      ::SetColor( nClrFore, nClrBack )
   end if

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if !Empty( oWnd:hWnd )
      ::Create()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return Self

//--------------------------------------------------------------------------//

METHOD Redefine(  nId, nCtlHeight, cBitmap, cResBmp, nClrFore, nClrBack, nStyle, ;
                  oBrush, oFont, lPixel, cMsg, oWnd, nHelpID, bRClick ) CLASS TWebBar

   DEFAULT  nClrFore    := CLR_BLACK, ;
            nClrBack    := GetSysColor( COLOR_BTNFACE ), ;
            nStyle      := nOr( WS_CHILD, WS_VISIBLE, WS_CLIPSIBLINGS, WS_CLIPCHILDREN ) ,;
            nCtlHeight  := 30 ,;
            lPixel      := .t.,;
            oWnd        := GetWndDefault(),;
            oBrush      := TBrush():New( , nClrBack )
            // oFont       := TFont():New( "Verdana", 0, -22, .f., .t. ),;

   ::nStyle       = nStyle
   ::nId          = nId
   ::oWnd         = oWnd
   ::nCtlHeight   = nCtlHeight
   ::lCaptured    = .f.
   ::cBitmap      = cBitmap
   ::cResBmp      = cResBmp
   ::hBitmap      = 0
   ::nClrPane     = nClrBack
   ::nClrText     = nClrFore
   ::bRClicked    = bRClick
   ::nHelpID      = nHelpID
   ::nClrLine     = Rgb( 255, 154, 49 )
   ::oBrush       = oBrush
   // ::oFont        = oFont

   ::setFont( oFontBigTitle() )

   ::LoadImage( cResBmp, cBitmap )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if oWnd != nil
      oWnd:DefControl( Self )
   end if

return Self

//--------------------------------------------------------------------------//

METHOD Paint() CLASS TWebBar

   local n
   local nWidth
   local nHeight
   local nBmpWidth
   local nBmpHeight
   local nRow        := 0
   local nCol        := 0
   local aInfo       := ::DispBegin()

   if !Empty( ::hBitmap )

      nWidth         := ::nWidth()
      nHeight        := ::nHeight()
      nBmpWidth      := nBmpWidth( ::hBitmap )
      nBmpHeight     := nBmpHeight( ::hBitmap )

      while nRow <= nHeight
         nCol        := 0
         while nCol <= nWidth
            PalBmpDraw( ::hDC, nRow, nCol, ::hBitmap, ::hPalette )
            nCol     += nBmpWidth
         end
         nRow        += nBmpHeight
      end

   else

      FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hbrush )

   end if

   if ::aSay != nil
      for n := 1 to len( ::aSay )
         wSay( ::hWnd, ::hDC, ::aSay[ n, 1 ], ::aSay[ n, 2 ], ::aSay[ n, 3 ], ::nClrText, , ::oFont:hFont, .t., .t. ) //
      next
   end if

   ::DispEnd( aInfo )

return nil

//--------------------------------------------------------------------------//

METHOD Destroy() CLASS TWebBar

   if ::oBrush != nil
      ::oBrush:End()
   end if

   // if ::oFont != nil
   //    ::oFont:End()
   // end if

   PalBmpFree( ::hBitmap, ::hPalette )

   if ::hWnd != 0
      ::Super:Destroy()
   endif

   ::oBrush    := nil
   ::hBitmap   := nil
   ::hPalette  := nil

return Self

//--------------------------------------------------------------------------//

METHOD LoadImage( cResName, cBmpFile )

   local aBmp

   if !Empty( cResName )
      aBmp        := PalBmpLoad( cResName )
      ::hBitmap   := aBmp[ 1 ]
      ::hPalette  := aBmp[ 2 ]
      ::cBitmap   := cResName
   endif

   if !Empty( cBmpFile ) .and. File( cBmpFile )
      aBmp        := PalBmpRead( ::GetDC(), cBmpFile )
      ::hBitmap   := aBmp[ 1 ]
      ::hPalette  := aBmp[ 2 ]
      ::cBitmap   := AllTrim( cBmpFile )
      ::ReleaseDC()
   endif

   if ::hBitmap != 0
      PalBmpNew( ::hWnd, ::hBitmap, ::hPalette )
   endif

return Self

//--------------------------------------------------------------------------//

METHOD Say( nRow, nCol, cText )

   DEFAULT  nRow  := 0,;
            nCol  := 0,;
            cText := ""

   if ::aSay == nil
      ::aSay   := {}
   end if

   aAdd( ::aSay, { nRow, nCol, cText } )

RETURN Self

//----------------------------------------------------------------------------//