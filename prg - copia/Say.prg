#include "FiveWin.ch"
#include "Constant.ch"

#define LTGRAY_BRUSH       1
#define TRANSPARENT        1

#define SS_CENTER          1
#define SS_RIGHT           2
#define SS_GRAYRECT        5 // BOXRECT

#define DLGC_BUTTON     8192   // 0x2000

#define COLOR_WINDOW       5
#define COLOR_WINDOWTEXT   8
#define COLOR_BTNFACE     15

#define WM_NCHITTEST     132  // 0x84

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
#endif

//----------------------------------------------------------------------------//

CLASS TSay FROM TControl

   DATA   l3D
   DATA   cPicture
   DATA   bGet
   DATA   lWantClick

   METHOD New( nRow, nCol, bText, oWnd, cPicture, oFont,;
               lCentered, lRight, lBorder, lPixels, nClrText, nClrBack,;
               nWidth, nHeight, lDesign, lUpdate, lShaded, lBox, lRaised ) CONSTRUCTOR

   METHOD ReDefine( nId, bText, oWnd, cPicture, ;
                    nClrText, nClrBack, lUpdate, oFont )  CONSTRUCTOR

   METHOD cToChar() INLINE  Super:cToChar( "STATIC" )

   METHOD Default()

   METHOD cGenPrg()

   #ifndef __CLIPPER__
      METHOD EraseBkGnd( hDC )
   #endif

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Initiate( hDlg )

   METHOD Refresh() INLINE If( ::bSetGet != nil, ::SetText( Eval( ::bSetGet ) ),)

   METHOD SetText( cText )

   METHOD VarPut( cValue )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bText, oWnd, cPicture, oFont,;
            lCentered, lRight, lBorder, lPixels, nClrText, nClrBack,;
            nWidth, nHeight, lDesign, lUpdate, lShaded, lBox, lRaised ) CLASS TSay

   DEFAULT nRow     := 0, nCol := 0,;
           lBorder  := .f., lCentered := .f., lRight := .f., lPixels := .f.,;
           oWnd     := GetWndDefault(),;
           nClrText := oWnd:nClrText,;
           nClrBack := iif(Upper( oWnd:Classname() ) != "TWINDOW",;
                           GetSysColor( COLOR_BTNFACE ),;
                           oWnd:nClrPane),;
           nHeight  := If( oFont != nil, Abs( oFont:nHeight ), SAY_CHARPIX_H ),;
           lDesign  := .f., bText := { || "" },;
           lUpdate  := .f., lShaded := .f., lBox := .f., lRaised := .f.

   ::l3D       = lShaded .or. lBox .or. lRaised
   ::bGet      = bText
   ::bSetGet   = bText
   ::oFont     = oFont
   ::cPicture  = cPicture

   ::cCaption  = If( Empty( cPicture ), cValToChar( Eval( bText ) ),;
                     Transform( Eval( bText ), cPicture ) )

   DEFAULT nWidth := SAY_CHARPIX_W * Len( ::cCaption ) - 4

   if ! lPixels
      ::nTop  = nRow * SAY_CHARPIX_H + 2
      ::nLeft = nCol * SAY_CHARPIX_W
   else
      ::nTop  = nRow
      ::nLeft = nCol
   endif

   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1

   ::oWnd      = oWnd
   ::nId       = ::GetNewId()
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                 If( lDesign, nOr( WS_CLIPSIBLINGS, WS_TABSTOP ), 0 ),;
                 If( lCentered, SS_CENTER, If( lRight, SS_RIGHT, SS_LEFT ) ),;
                 If( lBorder, WS_BORDER, 0 ),;
                 If( lShaded, SS_BLACKRECT, 0 ),;
                 If( lBox,    SS_GRAYRECT,  0 ),;
                 If( lRaised, SS_WHITERECT, 0 ) )
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::lUpdate   = lUpdate
   ::lWantClick = .f.

   ::SetColor( nClrText, nClrBack )

   if ! Empty( oWnd:hWnd )
      ::Create( "STATIC" )
      ::Default()
      if oFont != nil
         ::SetFont( oFont )
      endif
      if ::l3D
         ::Set3DLook()
      endif
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   if ::lDrag
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bText, oWnd, cPicture,;
                 nClrText, nClrBack, lUpdate, oFont ) CLASS TSay

   DEFAULT oWnd      := GetWndDefault(),;
           nClrText  := oWnd:nClrText,;
           nClrBack  := GetSysColor( COLOR_BTNFACE ),;
           lUpdate   := .f.

   ::l3D       = .f.
   ::nId       = nId
   ::bGet      = bText
   ::bSetGet   = bText
   ::cPicture  = cPicture
   ::oFont     = oFont

   if bText != nil
      ::cCaption = If( Empty( cPicture ), cValToChar( Eval( bText ) ),;
                       Transform( Eval( bText ), cPicture ) )
   endif

   ::oWnd      = oWnd
   ::hWnd      = 0
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lUpdate   = lUpdate
   ::lWantClick = .f.

   ::SetColor( nClrText, nClrBack )
   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TSay

   Super:Initiate( hDlg )

   if ! IsAppThemed()
      if ::lTransparent
         if ! Empty( ::oWnd:oBrush:hBitmap )
            ::SetBrush( ::oWnd:oBrush )
         endif
      endif
   endif

   if ::cCaption != nil // don't use Empty() here or blank texts will not show
      SetWindowText( ::hWnd, ::cCaption )
   else
      ::cCaption = GetWindowText( ::hWnd )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TSay

   if nMsg == WM_LBUTTONDOWN
      return ::LButtonDown( nHiWord( nLParam ), nLoWord( nLParam ),;
                            nWParam )
   endif

   if ( ( ::lDrag .or. ::lWantClick ) .and. nMsg == WM_NCHITTEST ) // To have a standard behavior on Clicks
      return DefWindowProc( ::hWnd, nMsg, nWParam, nLParam )
   endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD Default() CLASS TSay

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::SetFont( ::oWnd:oFont )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TSay

   local cCode := CRLF + "   @ " + Str( ::nTop, 3 ) + ", " + ;
                  Str( ::nLeft, 3 ) + ' SAY "' + ::cCaption + ;
                  '" SIZE ' + Str( ::nRight - ::nTop, 3 ) + ", " + ;
                  Str( ::nBottom - ::nTop, 3 ) + " PIXEL OF oWnd" + CRLF
return cCode

//----------------------------------------------------------------------------//

#ifndef __CLIPPER__

METHOD EraseBkGnd( hDC ) CLASS TSay

   DEFAULT ::lTransparent := .f.

   if IsAppThemed() .or. ::lTransparent
      return 1
   endif

return Super:EraseBkGnd( hDC )

#endif

//----------------------------------------------------------------------------//

METHOD SetText( cText ) CLASS TSay

   local hDC

   DEFAULT ::lTransparent := .f.

   ::cCaption := If( ::cPicture != nil, Transform( cText, ::cPicture ),;
                     cValToChar( cText ) )

   #ifndef __CLIPPER__
      if IsAppThemed() .or. ::lTransparent
         DrawPBack( ::hWnd, hDC := GetDC( ::hWnd ) )
         ReleaseDC( ::hWnd, hDC )
      endif
   #endif

   SetWindowText( ::hWnd, ::cCaption )
   ::VarPut( ::cCaption )

return nil

//----------------------------------------------------------------------------//

METHOD VarPut( cValue ) CLASS TSay

   if ! Empty( ::cPicture )
      cValue = Transform( cValue, ::cPicture )
   else
      cValue = cValToChar( cValue )
   endif

   ::bGet = { || cValue }

return nil

//----------------------------------------------------------------------------//