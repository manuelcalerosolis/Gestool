#include "FiveWin.Ch"
#include "Constant.ch"
#include "Objects.ch"
#include "Inkey.ch"
//--------------------------------------------------------------------------//

#define STEP_CTL    2
#define STEP_BMP    5
#define SAY_HEIGHT  18
#define LSPIN       14

//--------------------------------------------------------------------------//

CLASS TOutLook FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   DATA aGroup       AS ARRAY INIT {}
   DATA nAlign
   DATA nOption
   DATA nGroup       INIT 1
   DATA nActual      INIT 1
   DATA lCaptured    INIT .F.
   DATA oBtnTop
   DATA oBtnBottom
   DATA nDesp        INIT 0
   DATA cBitmap
   DATA cResBmp
   DATA hBmpPal
   DATA oSayBr
   DATA nCtlHeight   INIT 20

   METHOD New( nTop, nLeft, nWidth, nHeight, nCtlHeight, cBitmap,;
               cResBmp, nClrFore, nClrBack, nStyle, oBrush, oFont, ;
               lPixel, cMsg, oWnd, nHelpID, bRClick ) CONSTRUCTOR

   METHOD Redefine(  nID, oWnd, cBitmap, cResBmp, ;
                     nClrFore, nClrBack, oBrush, oFont, ;
                     cMsg, nHelpID, bRClick ) CONSTRUCTOR

   METHOD End() INLINE if( ::hWnd == 0, ::Destroy(), Super:End() )

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint()

   METHOD Paint()

   METHOD AddItem(   cResName1, cResName2, cBmpFile1, cBmpFile2,;
                     bAction, oBar, cMsg, bWhen, lUpdate,;
                     cPrompt, cPad, oFont, oFontOver, nClrText,;
                     nClrTextOver, nClrPane, nClrPaneOver, lBorder )

   METHOD Add( oBtnBmp, nPos )

   METHOD Destroy()

   METHOD LoadImage( cResName, cBmpFile )

   METHOD SetColor( nFore, nBack )

ENDCLASS

//--------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, nCtlHeight, cBitmap,;
            cResBmp, nClrFore, nClrBack, nStyle, oBrush, oFont, ;
            lPixel, cMsg, oWnd, nHelpID, bRClick ) CLASS TOutLook

   DEFAULT  nClrFore  := CLR_BLACK, ;
            nClrBack  := GetSysColor( COLOR_BTNFACE ), ;
            nStyle    := nOr( WS_CHILD, WS_VISIBLE, WS_CLIPSIBLINGS ) ,;
            nCtlHeight:= 20

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
   ::hBmpPal      = 0
   ::nClrPane     = nClrBack
   ::nClrText     = nClrFore
   ::bRClicked    = bRClick
   ::nHelpID      = nHelpID
   ::oFont        = oFont
   ::aControls    = {}

   if oBrush == nil
      DEFINE BRUSH ::oBrush STYLE TABS
   else
      ::oBrush := oBrush
   endif

   DEFINE BRUSH ::oSayBr STYLE NULL
   ::SetColor( nClrFore, nClrBack )

   ::Register()

   if ! Empty( oWnd:hWnd )
      ::Create()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   // se crean los botones de desplazamiento arriba y abajo
   /*
   @ 0,0 BTNBMP ::oBtnTop RESOURCE 32753 SIZE 16, 16 OF Self NOBORDER
   ::oBtnTop:bAction := {|| if( ::nDesp > 0, ( ::nDesp-- ), ) }
   ::oBtnTop:hBmpPal1 := LoadBitmap( 0, 32753 )

   @ 0,0 BTNBMP ::oBtnBottom SIZE 16, 16 OF Self NOBORDER
   ::oBtnBottom:bAction:= {|| ( ::nDesp++ ) }
   ::oBtnBottom:hBmpPal1 := LoadBitmap( 0, 32752 )
   */

   // cargo el bitmap de fondo si existe ...
   if !Empty( cResBmp )
      ::hBmpPal := PalBmpLoad( cResBmp )
      cBitmap  := nil
   endif

   if cBitmap != nil
      cBitmap := AllTrim( cBitmap )
   endif

   if !Empty( cBitmap ) .and. File( cBitmap )
      ::cBitmap := cBitmap
      ::hBmpPal := PalBmpRead( if( oWnd != nil, oWnd:GetDC(), 0 ), cBitmap )
      if( oWnd != nil, oWnd:ReleaseDC(), )
   endif

   if ::hBmpPal != 0
      PalBmpNew( 0, ::hBmpPal )
   endif

return Self

//--------------------------------------------------------------------------//

METHOD Redefine( nID, oWnd, cBitmap, cResBmp, ;
                 nClrFore, nClrBack, oBrush, oFont, ;
                 cMsg, nHelpID, bRClick ) CLASS TOutLook

   DEFAULT nClrFore  := CLR_BLACK, ;
            nClrBack := GetSysColor( COLOR_BTNFACE )

   ::nID       = nID
   ::oWnd      = oWnd
   ::lCaptured = .f.
   ::cBitmap   = cBitmap
   ::cResBmp   = cResBmp
   ::hBmpPal   = 0
   ::nClrPane  = nClrBack
   ::nClrText  = nClrFore
   ::bRClicked = bRClick
   ::nHelpID   = nHelpID
   ::oFont     = oFont
   ::aGroup    = {}

   if oBrush == nil
      DEFINE BRUSH ::oBrush STYLE NULL //TABS
   else
      ::oBrush := oBrush
   endif

   ::SetColor( nClrFore, nClrBack )

   if !Empty( cResBmp )
      ::hBmpPal := PalBmpLoad( cResBmp )
      cBitmap  := nil
   endif

   if cBitmap != nil
      cBitmap := AllTrim( cBitmap )
   endif

   if !Empty( cBitmap ) .and. File( cBitmap )
      ::cBitmap := cBitmap
      ::hBmpPal := PalBmpRead( if( oWnd != nil, oWnd:GetDC(), 0 ), cBitmap )
      if( oWnd != nil, oWnd:ReleaseDC(), )
   endif

   if ::hBmpPal != 0
      PalBmpNew( 0, ::hBmpPal )
   endif

   if oWnd != nil
      oWnd:DefControl( Self )
   endif

return Self

//--------------------------------------------------------------------------//

METHOD AddItem( cResName1, cResName2, cBmpFile1, cBmpFile2,;
               bAction, oBar, cMsg, bWhen, lUpdate,;
               cPrompt, cPad, oFont, oFontOver, nClrText,;
               nClrTextOver, nClrPane, nClrPaneOver, lBorder )

   local oBtn

   oBtn  := TWebBtn():NewBar( cResName1, cResName2, cBmpFile1, cBmpFile2,;
                              bAction, oBar, cMsg, bWhen, .t., lUpdate,;
                              cPrompt, cPad, oFont, oFontOver, nil, nil,;
                              nClrText, nClrTextOver, nClrPane, nClrPaneOver, lBorder )

return nil

//--------------------------------------------------------------------------//

METHOD Paint() CLASS TOutLook

   LOCAL n
   local o
   LOCAL nRow     := 0
   LOCAL nOffLeft := 0
   LOCAL hBrush   := CreateSolidBrush( ::nClrPane )

   ::AEvalWhen()

   ::GetDC()

   if ::aControls != nil

      for n := 1 to len( ::aControls )

         o  := ::aControls[ n ]
         o:Move( nRow, nOffLeft, o:nWidth, o:nHeight, .t. )
         o:Show()
         nRow  += o:nHeight
         FillRect( o:hDC, { 0, 0, o:nWidth, o:nHeight }, hBrush )
         MoveTo( ::hDC, nOffLeft, nRow + 1 )
         LineTo( ::hDC, o:nWidth, nRow + 1 )
         nRow  += STEP_CTL

      next
   end if

   ::ReleaseDC()
   DeleteObject( hBrush )

return nil

//--------------------------------------------------------------------------//

METHOD Destroy() CLASS TOutLook

   if ::hBmpPal != 0
      DeleteObject( ::hBmpPal )
      ::hBmpPal = 0
   endif

   ::oSayBr:End()

   if ::hWnd != 0
      Super:Destroy()
   endif

return nil

//--------------------------------------------------------------------------//

METHOD LoadImage( cResName, cBmpFile )

   if !Empty( cResName )
      ::hBmpPal := PalBmpLoad( cResName )
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

   if ::hBmpPal != 0
      PalBmpNew( 0, ::hBmpPal )
   endif

   ::Refresh()

return nil

//--------------------------------------------------------------------------//

METHOD SetColor( nFore, nBack )

   LOCAL n
   LOCAL m

   DEFAULT nFore  := ::nClrText, ;
            nBack := ::nClrPane

   Super:SetColor( nFore, nBack )

   for n := 1 to Len( ::aGroup )
      for m := 1 to Len( ::aGroup[ n, 4 ] )
         ::aGroup[ n, 4, m ]:SetColor( nFore, nBack )
         ::aGroup[ n, 5, m ]:SetColor( nFore, nBack )
      next
   next

   ::Refresh()

return nil

//--------------------------------------------------------------------------//

static function BmpTiled( oWnd, hBmp )

   LOCAL nWidth   := oWnd:nWidth()
   LOCAL nHeight  := oWnd:nHeight()
   LOCAL nRow     := 0
   LOCAL nCol     := 0
   LOCAL nBmpWidth  := nbmpwidth( hBmp )
   LOCAL nBmpHeight := nBmpHeight( hBmp )
   LOCAL hDC
   LOCAL n

   hDC := oWnd:GetDC()

   while nRow <= nHeight
      nCol := 0
      while nCol <= nWidth
         PalBmpDraw( hDC, nRow, nCol, hBmp )
         nCol += nBmpWidth
      end
      nRow += nBmpHeight
   end

   oWnd:ReleaseDC()

return nil

//--------------------------------------------------------------------------//

METHOD Add( oWebBtn, nPos ) CLASS TOutLook

  if nPos == nil
     AAdd( ::aControls, oWebBtn )
  else
     AAdd( ::aControls, nil )
     AIns( ::aControls, nPos )
     ::aControls[ nPos ] = oWebBtn
  endif

return nil

//----------------------------------------------------------------------------//