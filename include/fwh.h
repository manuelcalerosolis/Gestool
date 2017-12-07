// fwh.h : common include file for c modules

#ifdef _MSC_VER
   #if _MSC_VER <= 1200
      #define __VC98__
   #endif
#endif

#ifndef _WIN64
#define fw_parH( i )    ( (HANDLE) hb_parnl( i ) )
#define fw_retnll( l )  hb_retnl( (LONG) l )
#else
#define fw_parH( i )    ( (HANDLE) hb_parnll( i ) )
#define fw_retnll( l )  hb_retnll( (LONGLONG) l )
#endif

#ifdef __cplusplus
extern "C" {
#endif


LPWSTR   fw_parWide( int iParam );               // source: msgsapi.c
BOOL     isutf8( LPCSTR, int );                  // source: msgsapi.c
LPWSTR   AnsiToWide( LPCSTR );
LPWSTR   UTF8toUTF16( LPCSTR utf8 );             // source: unicode.c
LPSTR    UTF16toSTR8( LPWSTR utf16, int iLen );  // source: gettext.c
//size_t   wcslen( const wchar_t* wcs );

int DrawTextAW( HDC hDC, LPSTR lpchText, int nCount, LPRECT lpRect, UINT uFormat ); // source: text.c
LRESULT SendMessageU( HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam ); // msgsapi.c
//int DrawTextAW2( HDC hDC, LPSTR lpchText, int nCount, LPRECT lpRect, BOOL bRight ); // old. revised below
int DrawTextAW2( HDC hDC, LPSTR lpchText, int nCount, LPRECT lpRect, UINT uFormat, int iTopMargin );
int DrawTextAWC( HDC hDC, LPSTR lpchText, int nCount, LPRECT lpRect, UINT uFormat, BOOL bRight );

#ifdef __cplusplus
}
#endif


