#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>

#ifndef __FLAT__
typedef struct
{
   DWORD cbSize;
   DWORD fMask;
   long  nMin;
   long  nMax;
   DWORD nPage;
   long  nPos;
   long  nTrackPos;
} SCROLLINFO;

typedef SCROLLINFO FAR * LPSCROLLINFO;
#endif

#define SIF_RANGE           1
#define SIF_PAGE            2
#define SIF_POS             4
#define SIF_DISABLENOSCROLL 8
#define SIF_TRACKPOS        16
#define SIF_ALL             (SIF_RANGE + SIF_PAGE + SIF_POS + SIF_TRACKPOS)


static int disable = FALSE;

//----------------------------------------------------------------------------//

static BOOL SetScrInfo(HWND hWnd, int nScrollBar, LPSCROLLINFO si, BOOL lRedraw)
{
   typedef BOOL ( WINAPI * FN )( HWND, int, LPSCROLLINFO, BOOL );

   FN p = ( FN ) GetProcAddress( GetModuleHandle( "USER" ), "SetScrollInfo" );

   if ( disable )
      si->fMask  = si->fMask | SIF_DISABLENOSCROLL;

   if( p )
      return ( p( ( HWND ) hWnd, nScrollBar, si, lRedraw ) );
   else
      return ( FALSE );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER SETSCROLLRANGE( PARAMS ) //
#else
   CLIPPER SETSCROLLR( PARAMS ) // ANGE
#endif
{
   SCROLLINFO si;

   si.cbSize = sizeof( si );
   si.fMask  = SIF_RANGE;
   si.nMin   = _parni( 3 );
   si.nMax   = _parni( 4 );

   _retl( SetScrInfo( ( HWND ) _parnl( 1 ), _parni( 2 ), &si, _parl( 5 ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER SETSCROLLPOS( PARAMS ) //
#else
   CLIPPER SETSCROLLP( PARAMS ) // OS
#endif
{
   SCROLLINFO si;

   si.cbSize = sizeof( si );
   si.fMask  = SIF_POS;
   si.nPos   = _parni( 3 );

   _retl( SetScrInfo( ( HWND ) _parnl( 1 ), _parni( 2 ), &si, _parl( 4 ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER GETSCROLLRANGE( PARAMS ) //
#else
   CLIPPER GETSCROLLR( PARAMS ) // ANGE
#endif
{
   int wMin = 0, wMax = 0;

   GetScrollRange( ( HWND ) _parnl( 1 ),           // its hWnd
                   _parnl( 2 ),           // Scroll bar flags
                   &wMin,
                   &wMax );
   _reta( 2 );                            // { nMin, nMax }

   #ifdef __FLAT__
      #ifndef __HARBOUR__
         #define _stornl( x, y, z ) STORNL( x, params, y, z )
      #endif
   #endif

   _stornl( wMin, -1, 1 );
   _stornl( wMax, -1, 2 );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER GETSCROLLPOS( PARAMS ) //
#else
   CLIPPER GETSCROLLP( PARAMS ) // OS
#endif
{
   _retni( GetScrollPos( ( HWND ) _parnl( 1 ),     // its hWnd
                         _parni( 2 ) ) ); // Scroll bar flags
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER SETSCROLLINFO( PARAMS ) // ()
#else
   CLIPPER SETSCROLLI( PARAMS ) // NFO()
#endif
{
   typedef BOOL ( WINAPI * FN )( HWND, int, LPSCROLLINFO, BOOL );

   FN p = ( FN ) GetProcAddress( GetModuleHandle( "USER" ), "SetScrollInfo" );
   SCROLLINFO si;

   disable = _parl( 5 );

   si.cbSize = sizeof( si );
   si.fMask  = SIF_PAGE;
   si.nPage  = _parni( 3 );

   if( p )
      _retl( p( ( HWND ) _parnl( 1 ), _parni( 2 ), &si, _parl( 4 ) ) );
   else
      _retl( FALSE );
}

//----------------------------------------------------------------------------//

