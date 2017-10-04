#include "FiveWin.Ch"
#include "Constant.ch"

#define IDI_HAND         32513

#define WM_NCHITTEST       132  // 0x84

#define COLOR_WINDOW         5
#define COLOR_WINDOWTEXT     8
#define COLOR_BTNFACE       15

#ifdef __XPP__
   #define Super ::TControl
   #define New _New
#endif

//----------------------------------------------------------------------------//

CLASS TIcon FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   DATA   cIcoFile, cResName
   DATA   hIcon
   DATA   hBitmap

   METHOD New( nRow, nCol, cResName, cIcoFile, lBorder, bClick,;
               oWnd, lUpdate, bWhen, nClrFore, nClrBack ) CONSTRUCTOR

   METHOD ReDefine( nId, cResName, cIcoFile, bClick, lUpdate, oDlg,;
                    bWhen ) CONSTRUCTOR

   METHOD Define( cResName, cIcoFile, oWnd )

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD Paint() INLINE DrawIcon( ::hDC, 0, 0, ::hIcon )

   METHOD Destroy()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD SetName( cNewName )

   METHOD SetFile( cIcoFile )

   METHOD Initiate( hDlg )

   METHOD End()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cResName, cIcoFile, lBorder, bClick, oWnd,;
            lUpdate, bWhen, nClrFore, nClrBack ) CLASS TIcon

   DEFAULT nRow := 0, nCol := 0, cResName := "",;
           cIcoFile := "", lBorder := .f., lUpdate := .f.

   ::nTop      = nRow * ICO_CHARPIX_H // 14
   ::nLeft     = nCol * ICO_CHARPIX_W // 8
   ::nBottom   = ::nTop  + 32
   ::nRight    = ::nLeft + 32
   ::oWnd      = oWnd
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE, If( lBorder, WS_BORDER, 0 ) )
   ::nId       = ::GetNewId()
   ::cIcoFile  = cIcoFile
   ::cResName  = cResName
   ::bLClicked = bClick
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if oWnd != nil
      ::nClrText  = oWnd:nClrText
      ::nClrPane  = oWnd:nClrPane
      if ! Empty( oWnd:hWnd )
         ::Create()
      else
         oWnd:DefControl( Self )
      endif
   else
      oWnd   = GetWndDefault()
      ::hWnd = 0
      if oWnd != nil
         ::nClrText = oWnd:nClrText
         ::nClrPane = oWnd:nClrPane
      endif
   endif

   ::SetColor( nClrFore, nClrBack )

   if ! Empty( cIcoFile )
      ::hIcon = ExtractIcon( cIcoFile )
   endif

   if ! Empty( cResName )
      ::hIcon = LoadIcon( GetResources(), cResName )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, cResName, cIcoFile, bClick, lUpdate, oDlg,;
                    bWhen ) CLASS TIcon

   DEFAULT lUpdate := .f.

   ::nId       = nId
   ::cResName  = cResName
   ::cIcoFile  = cIcoFile
   ::bLClicked = bClick
   ::lUpdate   = lUpdate
   ::oWnd      = oDlg
   ::bWhen     = bWhen

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   oDlg:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Define( cResName, cIcoFile, oWnd ) CLASS TIcon

   DEFAULT cResName  := "",;
           cIcoFile  := "",;
           oWnd      := GetWndDefault()

   ::oWnd      = oWnd
   ::cIcoFile  = cIcoFile
   ::cResName  = cResName
   ::lDrag     = .f.
   ::lCaptured = .f.

   // ::SetColor( GetSysColor( COLOR_WINDOWTEXT ), GetSysColor( COLOR_BTNFACE ) )

   if ! Empty( cIcoFile )
      ::hIcon  = ExtractIcon( cIcoFile )
   endif

   if ! Empty( cResName )
      ::hIcon  = LoadIcon( GetResources(), cResName )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TIcon

   if nMsg == WM_NCHITTEST
      return DefWindowProc( ::hWnd, nMsg, nWParam, nLParam )
   endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD SetName( cNewName ) CLASS TIcon

   if ! Empty( cNewName )
      ::cResName = cNewName
      if ::hIcon != 0
         DestroyIcon( ::hIcon )
      endif
      ::hIcon = LoadIcon( GetResources(), cNewName )
      ::Refresh( .t. )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetFile( cIcoFile ) CLASS TIcon

   if ! Empty( cIcoFile ) .and. File( cIcoFile )
      ::cIcoFile = cIcoFile
      if ::hIcon != 0
         DestroyIcon( ::hIcon )
      endif
      ::hIcon = ExtractIcon( cIcoFile )
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TIcon

   Super:Initiate( hDlg )

   if ! Empty( ::cIcoFile )
      ::hIcon = ExtractIcon( ::cIcoFile )
   endif

   if ! Empty( ::cResName )
      ::hIcon = LoadIcon( GetResources(), ::cResName )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS TIcon

   if ::hWnd == 0
      ::Destroy()
   else
      return Super:End()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TIcon

   if ::hIcon != 0
      DestroyIcon( ::hIcon )
      ::hIcon = 0
   endif

return Super:Destroy()

//----------------------------------------------------------------------------//