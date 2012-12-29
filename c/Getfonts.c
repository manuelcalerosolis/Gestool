#include <Windows.h>
#include <ClipApi.h>

extern HINSTANCE __hInstance;
int nFontIndex = 0;
BOOL bGetName = FALSE;

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

//---------------------------------------------------------------------------//

// GetFontNames: Count and return an unsorted array of font names
CLIPPER GETFONTNAM() // ES ( hDC ) --> aFontNames
{
  FONTENUMPROC lpEnumFontsCallBack = ( FONTENUMPROC )
      MakeProcInstance( ( FARPROC ) EnumFontsCallBack, __hInstance );

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