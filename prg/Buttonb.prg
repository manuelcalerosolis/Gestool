#include "FiveWin.ch"

#define BS_BITMAP           128
#define BM_SETIMAGE         247

#define BM_GETSTATE      0x00F2

#define BS_OWNERDRAW         11
#define BST_PUSHED       0x0004

#define WM_UPDATEUISTATE 0x0128

#ifdef __XPP__
   #define Super ::TButton
   #define New   _New
#endif

//----------------------------------------------------------------------------//

CLASS TButtonBmp FROM TButton

   DATA   hBitmap

   DATA   cBitmap

   DATA   cPosText

   DATA   lHasAlpha AS LOGICAL INIT .f.
   DATA   bAlphaLevel
   DATA   hAlphaLevel


   METHOD New( nRow, nCol, cCaption, oWnd, bAction, nWidth, nHeight,;
               nHelpId, oFont, lDefault, lPixel, lDesign, cMsg,;
               lUpdate, bWhen, bValid, lCancel, cBitmap, cPosText ) CONSTRUCTOR

   METHOD ReDefine( nId, bAction, oWnd, nHelpId, cMsg,;
                    lUpdate, bWhen, bValid, cPrompt, lCancel, cBitmap, cPosText, cToolTip ) CONSTRUCTOR

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD KeyDown( nKey, nFlags ) INLINE Super:KeyDown( nKey, nFlags ), ::Refresh()

   METHOD LButtonDown( nRow, nCol, nKeyFlags ) INLINE Super:LButtonDown( nRow, nCol, nKeyFlags ), ::Refresh()

   METHOD LDblClick( nRow, nCol, nKeyFlags ) INLINE Super:LDblClick( nRow, nCol, nKeyFlags ), ::Refresh()

   METHOD LoadBitmap( cBmpName )

   if ! SetSkins()
      METHOD MouseMove( nRow, nCol, nFlags ) INLINE Super:MouseMove( nRow, nCol, nFlags ), ::oWnd:SetMsg( ::cMsg ), ::Refresh()
      METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0
   endif

   METHOD Destroy() INLINE DeleteObject( ::hBitmap ), Super:Destroy()

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD Paint()

   METHOD Enable() INLINE Super:Enable(), ::Refresh()

   METHOD Disable() INLINE Super:Disable(), ::Refresh()

   METHOD HasAlpha() INLINE ::lHasAlpha := HasAlpha( ::hBitmap )
   METHOD nAlphaLevel( nLevel ) SETGET

   METHOD SetText( cText ) INLINE Super:SetText( cText ), ::Refresh()

   METHOD End()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cCaption, oWnd, bAction, nWidth, nHeight,;
               nHelpId, oFont, lDefault, lPixel, lDesign, cMsg,;
               lUpdate, bWhen, bValid, lCancel, cBitmap, cPosText ) CLASS TButtonBmp

   DEFAULT cCaption := "", cPosText := ""

   ::cBitmap   = cBitmap
   ::hBitmap   = If( File( ::cBitmap ), ReadBitmap( 0, ::cBitmap ),;
                     LoadBitmap( GetResources(), ::cBitmap ) )
   ::cPosText  = Upper( cPosText )


   DEFAULT nWidth := nBmpWidth( ::hBitmap ) + 9, nHeight := nBmpHeight( ::hBitmap ) + 9
   ::HasAlpha()

return Super:New( nRow, nCol, cCaption, oWnd, bAction, nWidth, nHeight,;
                  nHelpId, oFont, lDefault, lPixel, lDesign, cMsg,;
                  lUpdate, bWhen, bValid, lCancel, cBitmap )

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bAction, oWnd, nHelpId, cMsg,;
                 lUpdate, bWhen, bValid, cPrompt, lCancel, cBitmap, cPosText, cToolTip ) CLASS TButtonBmp

   DEFAULT cPrompt := "", cPosText := ""

   ::cBitmap   = cBitmap
   ::hBitmap   = If( File( ::cBitmap ), ReadBitmap( 0, ::cBitmap ),;
                     LoadBitmap( GetResources(), ::cBitmap ) )
   ::cPosText  = Upper( cPosText )
   ::cToolTip  = cToolTip
   ::HasAlpha()

return Super:Redefine( nId, bAction, oWnd, nHelpId, cMsg, lUpdate, bWhen,;
                       bValid, cPrompt, lCancel )

//----------------------------------------------------------------------------//

METHOD LoadBitmap( cBmpName ) CLASS TButtonBmp

   if ! Empty( ::hBitmap )
      DeleteObject( ::hBitmap )
      ::hBitmap = nil
   endif

   ::cBitmap = cBmpName

   if File( cBmpName )
      ::hBitmap = ReadBitmap( 0, cBmpName )
   else
      ::hBitmap = LoadBitmap( GetResources(), cBmpName )
   endif
  ::HasAlpha()

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TButtonBmp

   local aInfo
   local nTop, nLeft, lPressed
   aInfo = ::DispBegin()

   CallWindowProc( ::nOldProc, ::hWnd, WM_PAINT, ::hDC, 0 )

   lPressed = lAnd( SendMessage( ::hWnd, BM_GETSTATE ), BST_PUSHED )


   if ! Empty( ::hBitmap )
      if ::cPosText == "TEXTBOTTOM"
         nTop = 7
      elseif ::cPosText == "TEXTTOP"
         nTop = ::nHeight() - 6 - nBmpHeight( ::hBitmap )
      else
         nTop = ( ::nHeight() / 2 ) - ( nBmpHeight( ::hBitmap ) / 2 )
      endif
      if ::cPosText == "TEXTRIGHT"
         nLeft = 7
      elseif ::cPosText == "TEXTLEFT"
         nLeft = ::nWidth() - 6 - nBmpWidth( ::hBitmap )
      else
         nLeft := ( ::nWidth() / 2 ) - ( nBmpWidth( ::hBitmap ) / 2 )
      endif

      if ::lActive
         if SetAlpha() .and. ::lHasAlpha
            ABPaint( ::hDC, nLeft + If( lPressed, 1, 0 ), nTop + If( lPressed, 1, 0 ), ::hBitmap, ::nAlphaLevel() )
         else
            DrawMasked( ::hDC, ::hBitmap, nTop + If( lPressed, 1, 0 ),;
                     nLeft + If( lPressed, 1, 0 ) )
         endif
      else
         DrawGray( ::hDC, ::hBitmap, nTop + If( lPressed, 1, 0 ),;
                     nLeft + If( lPressed, 1, 0 ) )
      endif
   endif

   ::DispEnd( aInfo )

return 1

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TButtonBmp

   local nResult

   do case
      case nMsg == WM_UPDATEUISTATE  // Buttons were erased when pressing ALT
           nResult = Super:HandleEvent( nMsg, nWParam, nLParam )
           ::Refresh()
           return nResult
   endcase

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD nAlphaLevel( uNew ) CLASS TButtonBmp

   if uNew != NIL
      ::hAlphaLevel := uNew
   else
      if ::bAlphaLevel != NIL
         ::hAlphaLevel = eval( ::bAlphaLevel, Self )
      endif
   endif

return ::hAlphaLevel

//----------------------------------------------------------------------------//

METHOD End() CLASS TButtonBmp

   if !Empty( ::hBitmap )
      DeleteObject( ::hBitmap )
      ::hBitmap = nil
   endif

RETURN ( Super:End() )

//----------------------------------------------------------------------------//
