#include <Windows.h>
#include <CommCtrl.h>
#include "Extend.api"

typedef struct tagINITCOMMONCONTROLSEX {
    DWORD dwSize;             // size of this structure
    DWORD dwICC;              // flags indicating which classes to be initialized
} _INITCOMMONCONTROLSEX, *LPINITCOMMONCONTROLSEX;

#define ICC_LISTVIEW_CLASSES 0x00000001 // listview, header
#define ICC_TREEVIEW_CLASSES 0x00000002 // treeview, tooltips
#define ICC_BAR_CLASSES      0x00000004 // toolbar, statusbar, trackbar, tooltips
#define ICC_TAB_CLASSES      0x00000008 // tab, tooltips
#define ICC_UPDOWN_CLASS     0x00000010 // updown
#define ICC_PROGRESS_CLASS   0x00000020 // progress
#define ICC_HOTKEY_CLASS     0x00000040 // hotkey
#define ICC_ANIMATE_CLASS    0x00000080 // animate
#define ICC_WIN95_CLASSES    0x000000FF
#define ICC_DATE_CLASSES     0x00000100 // month picker, date picker, time picker, updown
#define ICC_USEREX_CLASSES   0x00000200 // comboex
#define ICC_COOL_CLASSES     0x00000400 // rebar (coolbar) control
#define ICC_INTERNET_CLASSES 0x00000800

#define ICC_PAGESCROLLER_CLASS 0x00001000   // page scroller
#define ICC_NATIVEFNTCTL_CLASS 0x00002000   // native font control

WINCOMMCTRLAPI BOOL WINAPI InitCommonControlsEx(LPINITCOMMONCONTROLSEX);

#undef  MAKELONG
#define DWORD_PTR            DWORD
#define MAKELONG(a, b)       ((LONG)(((WORD)((DWORD_PTR)(a) & 0xffff)) | ((DWORD)((WORD)((DWORD_PTR)(b) & 0xffff))) << 16))

#define PCOUNT()             ( _parinfo(0) )

extern void _bset( void *, BYTE, ULONG );

HINSTANCE GetResources( void );

//----------------------------------------------------------------------------//

CLIPPER INITCOMMONCONTROLS()
{
   static bInit = FALSE;

   if( ! bInit )
   {
      InitCommonControls();
      bInit = TRUE;
   }
}

//----------------------------------------------------------------------------//

#ifdef __XPP__
   CLIPPER INITCCEX( PARAMS )
#else
   CLIPPER INITCOMMONCONTROLSEX()
#endif
{
   _INITCOMMONCONTROLSEX icce;

     icce.dwSize = sizeof( _INITCOMMONCONTROLSEX );
	 icce.dwICC  = _parnl( 1 );

   _retl( InitCommonControlsEx( &icce ) );
}

//----------------------------------------------------------------------------//

#ifdef __XPP__
   CLIPPER CREATETLBA( PARAMS )
#else
   CLIPPER CREATETLBAR() // hWndParent, nId --> hWnd
#endif
{
   HWND hToolBar = CreateWindowEx( 0, TOOLBARCLASSNAME, NULL, WS_CHILD | WS_VISIBLE | WS_BORDER,
                   0, 0, 0, 0, ( HWND ) _parnl( 1 ), ( HMENU ) _parnl( 2 ),
                   GetModuleHandle( NULL ), NULL );

   SendMessage( hToolBar, TB_BUTTONSTRUCTSIZE, ( WPARAM ) sizeof( TBBUTTON ), 0 );
   SendMessage( hToolBar, TB_SETBUTTONSIZE, 0, ( LPARAM ) MAKELONG( _parnl( 3 ), _parnl( 4 ) ) );

   _retnl( ( LONG ) hToolBar );
}

//----------------------------------------------------------------------------//

#ifdef __XPP__
   CLIPPER TBADDBUTTO( PARAMS )
#else
   CLIPPER TBADDBUTTON( PARAMS ) // hToolBar, nIdCommand, nButton, cText
#endif
{
   HWND hToolBar = ( HWND ) _parnl( 1 );
   TBBUTTON tbButton;

   _bset( &tbButton, 0, sizeof( tbButton ) );

   tbButton.iBitmap   = _parnl( 3 ) - 1;
   tbButton.idCommand = _parnl( 2 );
   tbButton.fsState   = TBSTATE_ENABLED;
   tbButton.fsStyle   = TBSTYLE_BUTTON | TBSTYLE_TOOLTIPS;
   tbButton.dwData    = NULL;
   if( PCOUNT() > 3 )
      tbButton.iString = SendMessage( hToolBar, TB_ADDSTRING, 0,
                                      ( LPARAM ) _parc( 4 ) );
   else
      tbButton.iString = NULL;

   SendMessage( hToolBar, TB_ADDBUTTONS, 1, ( LONG ) &tbButton );
//   SendMessage( hToolBar, TB_AUTOSIZE, 0, 0 );
}

//----------------------------------------------------------------------------//

#ifdef __XPP__
   CLIPPER TBADDSEPAR( PARAMS )
#else
   CLIPPER TBADDSEPARATOR( PARAMS )
#endif
{
   HWND hToolBar = ( HWND ) _parnl( 1 );
   TBBUTTON tbButton;

   tbButton.iBitmap   = 0;
   tbButton.idCommand = 0;
   tbButton.fsState   = TBSTATE_ENABLED;
   tbButton.fsStyle   = TBSTYLE_SEP;
   tbButton.dwData    = NULL;
   tbButton.iString   = NULL;

   SendMessage( hToolBar, TB_ADDBUTTONS, 1, ( LONG ) &tbButton );
   SendMessage( hToolBar, TB_AUTOSIZE, 0, 0 );
}

//----------------------------------------------------------------------------//

CLIPPER TTNSETTEXT( PARAMS ) // pNMTTDISPINFO, cTooltipText
{
   LPNMTTDISPINFO pti = ( LPNMTTDISPINFO ) _parnl( 1 );

   MultiByteToWideChar( CP_OEMCP, MB_PRECOMPOSED,
                        ( LPCSTR ) _parc( 2 ), -1, ( LPWSTR ) pti->szText,
                        _parclen( 2 ) + 1 );

   pti->hinst = NULL;
   pti->lpszText = NULL;
   pti->uFlags = 0;
}

//----------------------------------------------------------------------------//

#ifdef __XPP__
   CLIPPER TBENABLEBU( PARAMS )
#else
   CLIPPER TBENABLEBUTTON( PARAMS )
#endif
{
   HWND hToolBar = ( HWND ) _parnl( 1 );

   _retl( SendMessage( hToolBar, TB_ENABLEBUTTON, _parnl( 2 ),
                     ( LPARAM ) MAKELONG( _parl( 3 ), 0 ) ) );
}

//----------------------------------------------------------------------------//