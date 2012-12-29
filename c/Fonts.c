#define CHOOSEFONT _CHOOSEFONT

#include <WinTen.h>
#include <Windows.h>
#include <CommDlg.h>
#include <ClipApi.h>

#define LF_HEIGHT          1
#define LF_WIDTH           2
#define LF_ESCAPEMENT      3
#define LF_ORIENTATION     4
#define LF_WEIGHT          5
#define LF_ITALIC          6
#define LF_UNDERLINE       7
#define LF_STRIKEOUT       8
#define LF_CHARSET         9
#define LF_OUTPRECISION   10
#define LF_CLIPPRECISION  11
#define LF_QUALITY        12
#define LF_PITCHANDFAMILY 13
#define LF_FACENAME       14

#define WF_WINNT      0x4000

void RegisterResource( HANDLE hRes, LPSTR szType );
BOOL IsWin95( void );

#define CHOOSEFONT CHOOSEFONT

typedef UINT (CALLBACK* lpfnHook)(HWND, UINT, WPARAM, LPARAM);

extern HINSTANCE __hInstance;
static far int nFontIndex = 0;
static far BOOL bGetName = FALSE;

#ifdef __FLAT__
   static far void * _params;
#endif

//----------------------------------------------------------------------------//

static BOOL CALLBACK ComDlgHkFont(HWND hDlg,
                           UINT uMsg,
                           WPARAM wParam,
                           LPARAM lPar)
{
   return FALSE;
}

//----------------------------------------------------------------------------//

CLIPPER CHOOSEFONT( PARAMS )
       // aPreviousFont, @nRGBColor, hPrinterDC, nFlags --> aNewFont
{
   _CHOOSEFONT cf;
   LOGFONT    lf;
   BYTE    bChars[ 15 ];  // Keep this under lf for the name
   BOOL      bOk, bInitLF = ISARRAY( 1 );
   HDC     hPrinterDC = ( HDC ) _parnl( 3 );
   DWORD   dwFlags = _parnl( 4 );

   _bset( ( BYTE * ) &cf, 0, sizeof( _CHOOSEFONT ) );
   _bset( ( BYTE * ) &lf, 0, sizeof( LOGFONT ) );

   #ifdef __XPP__
      #define _parc( x, y )      PARC( x, params, y )
      #define _parclen( x, y )   PARCLEN( x, params, y )
      #define _parni( x, y )     PARNI( x, params, y )
      #define _parl( x, y )      PARL( x, params, y )
      #define _storc( x, y, z )  STORC( x, params, y, z )
      #define _storni( x, y, z ) STORNI( x, params, y, z )
      #define _stornl( x, y, z ) STORNL( x, params, y, z )
      #define _storl( x, y, z )  STORL( x, params, y, z )
   #endif

   if( bInitLF )      // Previous Font is provided
   {
      lf.lfHeight         = _parni( 1, LF_HEIGHT );
      lf.lfWidth          = _parni( 1, LF_WIDTH );
      lf.lfEscapement     = _parni( 1, LF_ESCAPEMENT );
      lf.lfOrientation    = _parni( 1, LF_ORIENTATION );
      lf.lfWeight         = _parni( 1, LF_WEIGHT );
      lf.lfItalic         = _parl(  1, LF_ITALIC );
      lf.lfUnderline      = _parl(  1, LF_UNDERLINE );
      lf.lfStrikeOut      = _parl(  1, LF_STRIKEOUT );
      lf.lfCharSet        = _parni( 1, LF_CHARSET );
      lf.lfOutPrecision   = _parni( 1, LF_OUTPRECISION );
      lf.lfClipPrecision  = _parni( 1, LF_CLIPPRECISION );
      lf.lfQuality        = _parni( 1, LF_QUALITY );
      lf.lfPitchAndFamily = _parni( 1, LF_PITCHANDFAMILY );

      if( _parclen( 1, LF_FACENAME ) )
         strcpy( ( char * ) &( lf.lfFaceName ), _parc( 1, LF_FACENAME ) );
   }

   cf.lStructSize = sizeof( _CHOOSEFONT );
   cf.hwndOwner   = GetActiveWindow();
   cf.lpLogFont   = &lf;
   cf.Flags       = CF_SCREENFONTS | IF( _pcount() > 1, CF_EFFECTS, 0 ) |
                    IF( bInitLF, CF_INITTOLOGFONTSTRUCT, 0 );
   cf.rgbColors   = ( COLORREF ) IF( _pcount() > 1, _parnl( 2 ), 0 );
   cf.nFontType   = PRINTER_FONTTYPE;

   if( hPrinterDC )
   {
      cf.hDC    = hPrinterDC;
      cf.Flags |= CF_PRINTERFONTS;
   }

   #ifndef __FLAT__
   if( IsWin95() || GetWinFlags() & WF_WINNT )
   {
   #endif
   cf.Flags      |= CF_ENABLEHOOK;
   cf.lpfnHook    = ( lpfnHook ) ComDlgHkFont;
   #ifndef __FLAT__
   }
   #endif

   if( dwFlags )
      cf.Flags = dwFlags;

   bOk = ChooseFont( &cf );

   _reta( 14 );
   _storni( ( bOk || bInitLF ) ? lf.lfHeight:         0, -1, LF_HEIGHT );
   _storni( ( bOk || bInitLF ) ? lf.lfWidth:          0, -1, LF_WIDTH );
   _storni( ( bOk || bInitLF ) ? lf.lfEscapement:     0, -1, LF_ESCAPEMENT );
   _storni( ( bOk || bInitLF ) ? lf.lfOrientation:    0, -1, LF_ORIENTATION );
   _storni( ( bOk || bInitLF ) ? lf.lfWeight:         0, -1, LF_WEIGHT );
   _storl(  ( bOk || bInitLF ) ? lf.lfItalic:         0, -1, LF_ITALIC );
   _storl(  ( bOk || bInitLF ) ? lf.lfUnderline:      0, -1, LF_UNDERLINE );
   _storl(  ( bOk || bInitLF ) ? lf.lfStrikeOut:      0, -1, LF_STRIKEOUT );
   _storni( ( bOk || bInitLF ) ? lf.lfCharSet:        0, -1, LF_CHARSET );
   _storni( ( bOk || bInitLF ) ? lf.lfOutPrecision:   0, -1, LF_OUTPRECISION );
   _storni( ( bOk || bInitLF ) ? lf.lfClipPrecision:  0, -1, LF_CLIPPRECISION );
   _storni( ( bOk || bInitLF ) ? lf.lfQuality:        0, -1, LF_QUALITY );
   _storni( ( bOk || bInitLF ) ? lf.lfPitchAndFamily: 0, -1, LF_PITCHANDFAMILY );
   _storc(  ( bOk || bInitLF ) ? lf.lfFaceName:      "", -1, LF_FACENAME );

   #ifdef __XPP__
      #define _stornl( x, y ) STORNL( x, params, y, 1 )
   #endif

   if( bOk && ( _pcount() == 2 ) )
      _stornl( cf.rgbColors, 2 );
}

//----------------------------------------------------------------------------//

CLIPPER CREATEFONT( PARAMS ) // ( aFont ) --> hFont
{
   HFONT hFont = CreateFont( _parni( 1, LF_HEIGHT ),
                             _parni( 1, LF_WIDTH ),
                             _parni( 1, LF_ESCAPEMENT ),
                             _parni( 1, LF_ORIENTATION ),
                             _parni( 1, LF_WEIGHT ),
                             _parl( 1, LF_ITALIC ),
                             _parl( 1, LF_UNDERLINE ),
                             _parl( 1, LF_STRIKEOUT ),
                             _parni( 1, LF_CHARSET ),
                             _parni( 1, LF_OUTPRECISION ),
                             _parni( 1, LF_CLIPPRECISION ),
                             _parni( 1, LF_QUALITY ),
                             _parni( 1, LF_PITCHANDFAMILY ),
                             _parc( 1, LF_FACENAME ) );

   #ifndef __FLAT__
   RegisterResource( hFont, "FONT" );
   #endif

   _retnl( ( LONG ) hFont );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER ADDFONTRESOURCE( PARAMS ) // ()   cFontFile or hFontResource  --> nFontsAdded
#else
   CLIPPER ADDFONTRES( PARAMS ) // OURCE()   cFontFile or hFontResource  --> nFontsAdded
#endif
{
   #ifdef __XPP__
      #define _parc( x )  PARC( x, params )
      #define _parni( x ) PARNI( x, params )
   #endif

   _retni( AddFontResource( IF( ISCHAR( 1 ), _parc( 1 ),
                                MAKEINTRESOURCE( _parni( 1 ) ) ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER REMOVEFONTRESOURCE( PARAMS ) // () cFontFile or hFontResource  --> lSuccess
#else
   CLIPPER REMOVEFONT( PARAMS ) // RESOURCE() cFontFile or hFontResource  --> lSuccess
#endif
{
   _retl( RemoveFontResource( IF( ISCHAR( 1 ), _parc( 1 ),
                                  MAKEINTRESOURCE( _parni( 1 ) ) ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER GETFONTINFO( PARAMS ) // ( hFont )  --> aInfo
#else
   CLIPPER GETFONTINF( PARAMS ) // o( hFont )  --> aInfo
#endif
{
   TEXTMETRIC tm;
   HFONT hFont    = ( HFONT ) _parnl( 1 );
   HWND hWnd      = GetActiveWindow();
   HDC hDC        = GetDC( hWnd );
   HFONT hOldFont = SelectObject( hDC, hFont );

   GetTextMetrics( hDC, &tm );
   SelectObject( hDC, hOldFont );
   ReleaseDC( hWnd, hDC );

   _reta( 3 );
   _storni( tm.tmHeight, -1, 1 );
   _storni( tm.tmAveCharWidth, -1, 2 );
   _storl( tm.tmWeight & FW_BOLD, -1, 3 );
}

//----------------------------------------------------------------------------//

// EnumFonts call back routine
static int CALLBACK EnumFontsCallBack( LOGFONT FAR *lpLogFont,
    TEXTMETRIC FAR *lpTextMetric, int nFontType, LPARAM lParam )
{
  #ifdef __FLAT__
     void * params = _params;
  #endif

  ++nFontIndex;
  if ( bGetName )
    _storc( lpLogFont->lfFaceName, -1, nFontIndex );
  return 1;
}

// GetFontNames: Count and return an unsorted array of font names
#ifdef __HARBOUR__
   CLIPPER GETFONTNAMES( PARAMS ) // ( hDC )
#else
   CLIPPER GETFONTNAM( PARAMS ) // ES ( hDC )
#endif
{
  FONTENUMPROC lpEnumFontsCallBack = ( FONTENUMPROC )
      MakeProcInstance( ( FARPROC ) EnumFontsCallBack, __hInstance );

  #ifdef __XPP__
     _params = params;
  #endif

  // Get the number of fonts
  nFontIndex = 0;
  bGetName = FALSE;
  EnumFonts( ( HDC ) _parnl( 1 ), NULL, lpEnumFontsCallBack, NULL );

  // Get the font names
  _reta( nFontIndex );
  nFontIndex = 0;
  bGetName = TRUE;
  EnumFonts( ( HDC ) _parnl( 1 ), NULL, lpEnumFontsCallBack, NULL );

  FreeProcInstance( ( FARPROC ) EnumFontsCallBack );
}

//----------------------------------------------------------------------------//