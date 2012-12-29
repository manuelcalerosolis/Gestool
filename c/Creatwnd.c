#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>

void LogFile( LPSTR, LPSTR );
LPSTR LToStr( long w );

extern HANDLE __hInstance;

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER CREATEWINDOW( PARAMS ) // ( cClassName, cTitle, nStyle, nLeft, nTop,
#else                             //   nWidth, nHeight, hWndOwner, hMenu,
   CLIPPER CREATEWIND( PARAMS )   //   cExtraData, nExStyle ) --> hWnd
#endif
{
   DWORD dwStyle   = ( DWORD ) _parnl( 3 );
   DWORD dwExStyle = ( DWORD ) _parnl( 11 );

   #ifdef __FLAT__
      if( dwStyle == WS_BORDER )   // XBPP bug
      {
         dwStyle |= WS_POPUP;
         dwExStyle = WS_EX_TOOLWINDOW;
      }
   #endif

   _retnl( ( LONG ) CreateWindowEx( dwExStyle,
                         _parc( 1 ),              // Class
                         _parc( 2 ),              // Title
                         dwStyle,                 // Style
                         ( int ) _parni( 4 ),     // Left
                         ( int ) _parni( 5 ),     // Top
                         ( int ) _parni( 6 ),     // Width
                         ( int ) _parni( 7 ),     // Height
                         ( HWND ) _parnl( 8 ),    // Parent
                         ( HMENU ) _parnl( 9 ),   // Menu
                         __hInstance,
   ( PCOUNT() > 9 ) ? ( void * ) _parc( 10 ): 0 ) ); // Address Window-Creation-Data
}

//----------------------------------------------------------------------------//

#ifdef __FLAT__

#ifdef __HARBOUR__
   CLIPPER GETLASTERROR( PARAMS ) // () --> nError
#else
   CLIPPER GETLASTERR( PARAMS ) // OR() --> nError
#endif
{
   _retnl( GetLastError() );
}

#endif

//----------------------------------------------------------------------------//

#ifdef __FLAT__

CLIPPER GETERRMSG( PARAMS ) // --> cSystemError
{
   LPVOID lpMsgBuf;

   FormatMessage( FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
                  NULL,
                  GetLastError(),
                  MAKELANGID( LANG_NEUTRAL, SUBLANG_DEFAULT ), // Default language
                  (LPTSTR) &lpMsgBuf,
                  0,
                  NULL );

   _retc( lpMsgBuf );
   LocalFree( lpMsgBuf );
}

#endif

//----------------------------------------------------------------------------//