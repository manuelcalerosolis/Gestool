#define ENDDOC    _ENDDOC
#define DRAFTMODE _DRAFTMODE
#define STARTDOC  _STARTDOC

#include <WinTen.h>
#include <Windows.h>

#ifndef __FLAT__
#include <Print.h>
#endif

#include <CommDlg.h>
#include <ClipApi.h>

typedef struct
{
    WORD vlen;
    BYTE data[10];
} ESCDATA;

BOOL IsWin95( void );
static BOOL CALLBACK PrnSetupHkProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lPar);
static void SendFile(HDC, LPSTR);

typedef struct
{
  WORD wSize;
  BYTE bData[2];
} PASSTHROUGHSTRUCT, FAR *LPPTS;

extern HINSTANCE GetInstance( void );

static far PRINTDLG pd;
static far BOOL bInit = FALSE;

//----------------------------------------------------------------------------//

static void PrinterInit( void )
{
   if( ! bInit )
   {
      bInit = TRUE;
      _bset( ( char * ) &pd, 0, sizeof( PRINTDLG ) );
      pd.lStructSize = sizeof( PRINTDLG );
      pd.hwndOwner   = GetActiveWindow();
      pd.Flags       = PD_RETURNDEFAULT ;
      pd.nMinPage    = 1;
      pd.nMaxPage    = 65535;
      PrintDlg( &pd );
   }
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER PRINTERINIT( PARAMS ) //
#else
   CLIPPER PRINTERINI( PARAMS ) //T
#endif
{
   bInit = FALSE;
}

//----------------------------------------------------------------------------//

CLIPPER GETPRINTDC( PARAMS ) // ( hWndOwner ) --> hDC
{
   PrinterInit();

   pd.hwndOwner = ( HWND ) _parnl( 1 );
   pd.Flags     = PD_RETURNDC | PD_USEDEVMODECOPIES |
                  PD_HIDEPRINTTOFILE | PD_NOSELECTION ;

   _retnl( ( LONG ) ( PrintDlg( &pd ) ? pd.hDC: 0 ) );
}

//----------------------------------------------------------------------------//

#define WF_WINNT  0x4000

#ifdef __HARBOUR__
   CLIPPER PRINTERSETUP( PARAMS ) // ( hWndOwner ) --> nil
#else
   CLIPPER PRINTERSET( PARAMS ) // up( hWndOwner ) --> nil
#endif
{
   PrinterInit();

   pd.hwndOwner = IF( PCOUNT() == 0, GetActiveWindow(), ( HWND ) _parnl( 1 ) );
   pd.Flags     = PD_PRINTSETUP | PD_USEDEVMODECOPIES;

   #ifndef __FLAT__
   if( IsWin95() || GetWinFlags() & WF_WINNT )
    {
   #endif
      pd.Flags = pd.Flags  | PD_ENABLESETUPHOOK;

      #ifndef __FLAT__
         pd.lpfnSetupHook = PrnSetupHkProc;
      #else
         pd.lpfnSetupHook = ( LPPRINTHOOKPROC ) PrnSetupHkProc;
      #endif

   #ifndef __FLAT__
    }
   #endif

   _retnl( ( LONG ) ( PrintDlg( &pd ) ? pd.hDC : 0 ) );
}

//----------------------------------------------------------------------------//

static BOOL CALLBACK PrnSetupHkProc(HWND hDlg,
                                    UINT uMsg,
                                    WPARAM wParam,
                                    LPARAM lPar)
{
   return FALSE;
}

//----------------------------------------------------------------------------//

#undef STARTDOC

CLIPPER STARTDOC( PARAMS )
{
   DOCINFO info;
   char szDocName[ 32 ];
   int iLen = MIN( 31, _parclen( 2 ) );

   _bcopy( szDocName, _parc( 2 ), iLen );
   szDocName[ iLen ] = 0;

   info.cbSize      = sizeof( DOCINFO );
   info.lpszDocName = IF( ISCHAR( 2 ), szDocName, "" );
   info.lpszOutput  = IF( ISCHAR( 3 ), _parc( 3 ), 0 );

   #ifdef __FLAT__
      info.lpszDatatype = 0;
      info.fwType = 0;
   #endif

   _retni( StartDoc( ( HDC ) _parnl( 1 ),       // hDC printer device
                     &info ) );
}

//----------------------------------------------------------------------------//

#undef ENDDOC

CLIPPER ENDDOC( PARAMS )
{
   _retnl( ( LONG ) EndDoc( ( HDC ) _parnl( 1 ) ) );     // hDC printer device
}

//----------------------------------------------------------------------------//

CLIPPER STARTPAGE( PARAMS )
{
   _retnl( ( LONG ) StartPage( ( HDC ) _parnl( 1 ) ) );  // hDC printer device
}

//----------------------------------------------------------------------------//

CLIPPER ENDPAGE( PARAMS )
{
   _retnl( ( LONG ) EndPage( ( HDC ) _parnl( 1 ) ) );    // hDC printer device
}

//----------------------------------------------------------------------------//

CLIPPER ESCAPE( PARAMS ) // ( hDC, nEscape, cInput, @cOutPut ) --> nReturn
{
   BYTE * pBuffer = ( BYTE * ) IF( PCOUNT() == 4, _xgrab( _parclen( 3 ) ), 0 );

   _retni( Escape( ( HDC ) _parnl( 1 ), _parni( 2 ), _parclen( 3 ), _parc( 3 ),
                   pBuffer ) );

   if( pBuffer )
   {
      _storclen( ( char * ) pBuffer, _parclen( 3 ), 4 );
      _xfree( pBuffer );
   }
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER GETPRINTDEFAULT( PARAMS ) // ( hWndOwner ) --> nil
#else
   CLIPPER GETPRINTDE( PARAMS ) // FAULT( hWndOwner ) --> nil
#endif
{
   LPDEVNAMES lpDevNames;
   LPDEVMODE  lpDevMode;

   PrinterInit();

   if( pd.hDevNames )
   {
      lpDevNames = (LPDEVNAMES) GlobalLock( pd.hDevNames );
      lpDevMode  = (LPDEVMODE) GlobalLock( pd.hDevMode );

      _retnl( ( LONG ) CreateDC( ( LPSTR ) lpDevNames + lpDevNames->wDriverOffset,
                       ( LPSTR ) lpDevNames + lpDevNames->wDeviceOffset,
                       ( LPSTR ) lpDevNames + lpDevNames->wOutputOffset,
                       lpDevMode ) );

      GlobalUnlock( pd.hDevNames );
      GlobalUnlock( pd.hDevMode );
   }
   else
      _retnl( 0 );
}

//----------------------------------------------------------------------------//

CLIPPER PRNOFFSET( PARAMS ) // ( hDC)  --> aPoint
{
   POINT pt;

   pt.y = 0;
   pt.x = 0;

   Escape( ( HDC ) _parnl( 1 ),
           GETPRINTINGOFFSET,
           NULL, NULL, ( LPPOINT ) &pt ) ;

   _reta( 2 );

   #ifdef __FLAT__
      #ifndef __HARBOUR__
         #define _storni( x, y, z ) STORNI( x, params, y, z )
      #endif
   #endif

   _storni( pt.y, -1, 2 );
   _storni( pt.x, -1, 1 );
}

//----------------------------------------------------------------------------//

#ifdef __FLAT__

#ifdef __HARBOUR__
   CLIPPER PRNSETCOLLATE( PARAMS ) // ( hDC )  --> lSuccess
#else
   CLIPPER PRNSETCOLL( PARAMS ) // ATE( hDC )  --> lSuccess
#endif
{
   LPDEVMODE  lpDevMode;

   PrinterInit();

   lpDevMode  = (LPDEVMODE) GlobalLock( pd.hDevMode );

   if ( _parl( 1 ) )
      lpDevMode->dmCollate = DMCOLLATE_TRUE;
   else
      lpDevMode->dmCollate = DMCOLLATE_FALSE;

   GlobalUnlock( pd.hDevMode );

   _retl( TRUE );
}

#endif

//----------------------------------------------------------------------------//

CLIPPER RESETDC( PARAMS ) // hDC --> lSuccess
{
   LPDEVMODE  lpDevMode;

   PrinterInit();

   lpDevMode = ( LPDEVMODE ) GlobalLock( pd.hDevMode );

   _retl( ( BOOL ) ResetDC( ( HDC ) _parnl( 1 ), lpDevMode ) );

   GlobalUnlock( pd.hDevMode );
}

//----------------------------------------------------------------------------//

CLIPPER PRNGETSIZE( PARAMS ) // ( hDC)  --> aPoint
{
   POINT pt;

   pt.y = 0;
   pt.x = 0;

   Escape( ( HDC ) _parnl( 1 ),
           GETPHYSPAGESIZE,
           NULL, NULL, ( LPPOINT ) &pt ) ;

   _reta( 2 );
   _storni( pt.y, -1, 2 );
   _storni( pt.x, -1, 1 );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER PRNLANDSCAPE( PARAMS ) // (hDC)  --> lSuccess
#else
   CLIPPER PRNLANDSCA( PARAMS ) // PE(hDC)  --> lSuccess
#endif
{
   LPDEVMODE  lpDevMode;

   PrinterInit();

   lpDevMode  = (LPDEVMODE) GlobalLock( pd.hDevMode );

   lpDevMode->dmOrientation = DMORIENT_LANDSCAPE;

   GlobalUnlock( pd.hDevMode );

   _retl( TRUE );

}

//----------------------------------------------------------------------------//

CLIPPER PRNDUPLEX( PARAMS ) // ( nValue ) --> nOldValue
{
   LPDEVMODE  lpDevMode;
   int dmDuplex;

   PrinterInit();

   lpDevMode  = (LPDEVMODE) GlobalLock( pd.hDevMode );

   dmDuplex = lpDevMode->dmDuplex;

   if( PCOUNT() > 0 )
      lpDevMode->dmDuplex = _parni( 1 );

   _retni( dmDuplex );
   GlobalUnlock( pd.hDevMode );
}

//----------------------------------------------------------------------------//

CLIPPER PRNSETSIZE( PARAMS )
{
   LPDEVMODE  lpDevMode;

   PrinterInit();

   lpDevMode  = (LPDEVMODE) GlobalLock( pd.hDevMode );

   lpDevMode->dmFields      = lpDevMode->dmFields | DM_PAPERSIZE |
                              DM_PAPERLENGTH | DM_PAPERWIDTH;
   lpDevMode->dmPaperSize   = DMPAPER_USER;
   lpDevMode->dmPaperWidth  = _parnl( 1 );
   lpDevMode->dmPaperLength = _parnl( 2 );

   GlobalUnlock( pd.hDevMode );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER PRNPORTRAIT( PARAMS ) // ()  --> lSuccess
#else
   CLIPPER PRNPORTRAI( PARAMS ) // T()  --> lSuccess
#endif
{
   LPDEVMODE  lpDevMode;

   PrinterInit();

   lpDevMode  = (LPDEVMODE) GlobalLock( pd.hDevMode );

   lpDevMode->dmOrientation = DMORIENT_PORTRAIT;

   GlobalUnlock( pd.hDevMode );

   _retl( TRUE );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER PRNGETORIENTATION( PARAMS ) // ()  --> nOldOrient
#else
   CLIPPER PRNGETORIE( PARAMS ) // NTATION()  --> nOldOrient
#endif
{
   LPDEVMODE  lpDevMode;

   PrinterInit();

   lpDevMode  = (LPDEVMODE) GlobalLock( pd.hDevMode );

   _retni( lpDevMode->dmOrientation );

   GlobalUnlock( pd.hDevMode );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER PRNSETCOPIES( PARAMS ) // ( nCopies )  --> lSuccess
#else
   CLIPPER PRNSETCOPI( PARAMS ) // ES( nCopies )  --> lSuccess
#endif
{
   LPDEVMODE lpDevMode;

   PrinterInit();

   lpDevMode = (LPDEVMODE) GlobalLock( pd.hDevMode );

   lpDevMode->dmCopies = _parni( 1 );

   if( PCOUNT() == 2 )  // Compatibility with previous syntax!
      lpDevMode->dmCopies = _parni( 2 );

   GlobalUnlock( pd.hDevMode );

   _retl( TRUE );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER PRNGETPAGES( PARAMS ) // { nFrom, nTo }
#else
   CLIPPER PRNGETPAGE( PARAMS ) // S()  --> {nFrom, nTo}
#endif

{
   PrinterInit();

   _reta( 2 );

   #ifdef __XPP__
      #define _storni( x, y, z ) STORNI( x, params, y, z )
   #endif

   _storni( pd.nFromPage, -1, 1 );
   _storni( pd.nToPage, -1, 2 );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER PRNGETCOPIES( PARAMS ) //  --> nCopies
#else
   CLIPPER PRNGETCOPI( PARAMS ) // ES()  --> nCopies
#endif
{
   LPDEVMODE lpDevMode;

   PrinterInit();

   lpDevMode = (LPDEVMODE) GlobalLock( pd.hDevMode );

   _retni( lpDevMode->dmCopies);

   GlobalUnlock( pd.hDevMode );
}

//----------------------------------------------------------------------------//

CLIPPER PRINTERESC( PARAMS ) // ( hDC, cText ) --> lSuccess
{
  ESCDATA Data;

  Data.vlen = _parclen(2);
  _bcopy( ( char * ) Data.data, _parc(2), _parclen(2) );
  _retni( Escape( ( HDC ) _parni( 1 ), PASSTHROUGH, NULL, (LPSTR) &Data, NULL ) );

}

//----------------------------------------------------------------------------//

CLIPPER PRNGETNAME( PARAMS ) // () --> cPrinter
{
   LPDEVNAMES lpDevNames;

   PrinterInit();

   lpDevNames = (LPDEVNAMES) GlobalLock( pd.hDevNames );

   _retc( ( LPSTR ) lpDevNames + lpDevNames->wDeviceOffset );

   GlobalUnlock( pd.hDevNames );
}

//----------------------------------------------------------------------------//

CLIPPER PRNGETPORT( PARAMS ) // () --> cPort
{
   LPDEVNAMES lpDevNames;

   PrinterInit();

   lpDevNames = (LPDEVNAMES) GlobalLock( pd.hDevNames );

   _retc( ( LPSTR ) lpDevNames + lpDevNames->wOutputOffset );

   GlobalUnlock( pd.hDevNames );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER PRNGETDRIVE( PARAMS ) // () --> cDriver
#else
   CLIPPER PRNGETDRIV( PARAMS ) // ER () --> cDriver
#endif
{
   LPDEVNAMES lpDevNames;

   PrinterInit();

   lpDevNames = (LPDEVNAMES) GlobalLock( pd.hDevNames );

   _retc( ( LPSTR ) lpDevNames + lpDevNames->wDriverOffset );

   GlobalUnlock( pd.hDevNames );
}
//----------------------------------------------------------------------------//

CLIPPER PRNSETPAGE( PARAMS )
{
   LPDEVMODE  lpDevMode;

   PrinterInit();

   lpDevMode  = (LPDEVMODE) GlobalLock( pd.hDevMode );

   lpDevMode->dmPaperSize  = _parni( 1 );

   GlobalUnlock( pd.hDevMode );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER PRNBINSOURCE( PARAMS )  //( nBin )
#else
   CLIPPER PRNBINSOUR( PARAMS )  //CE( nBin )
#endif
{
   LPDEVMODE  lpDevMode;

   PrinterInit();

   lpDevMode  = (LPDEVMODE) GlobalLock( pd.hDevMode );

   _retni( ( LONG ) lpDevMode->dmDefaultSource );

   if ( PCOUNT() > 0 )
   {
    lpDevMode->dmDefaultSource  = _parni( 1 );
   }

   GlobalUnlock( pd.hDevMode );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER IMPORTRAWFILE( PARAMS ) // (hDC, cFile) --> lMode
#else
   CLIPPER IMPORTRAWF( PARAMS ) // ile(hDC, cFile) --> lMode
#endif
{
  int iEsc;

  iEsc = PASSTHROUGH;

  if ( Escape( ( HDC ) _parnl( 1 ), QUERYESCSUPPORT, sizeof(int), (LPSTR)&iEsc, NULL))
    {
     iEsc = EPSPRINTING;
     if (Escape( ( HDC ) _parnl( 1 ), QUERYESCSUPPORT, sizeof(int), (LPSTR)&iEsc, NULL))
      {
      iEsc = 1;
      Escape( ( HDC ) _parnl( 1 ), EPSPRINTING, sizeof(int), (LPSTR)&iEsc, NULL);
      }
    #ifndef __FLAT__
    SendFile( ( HDC ) _parnl( 1 ), (LPSTR) _parc( 2 ));
    #endif

    }
}

//----------------------------------------------------------------------------//

#define BUFSIZE 2048

#ifndef __FLAT__

static void SendFile(HDC hPrnDC, LPSTR szFile)
{
  static LPPTS lpPTS=NULL;          // Pointer to PASSTHROUGHSTRUCT
  OFSTRUCT ofs;
  HFILE hFile;

  hFile = OpenFile((LPSTR) szFile, &ofs, OF_READ);
  if (hFile == HFILE_ERROR)
    {
    _retni(0);
    return;
    }

  if (!lpPTS &&
       !(lpPTS = (LPPTS)GlobalLock(GlobalAlloc(GPTR, sizeof(WORD) + BUFSIZE))))
    {
    _retni(0);
    return;
    }

  do {
    lpPTS->wSize = _lread(hFile, lpPTS->bData, BUFSIZE);
    Escape(hPrnDC, PASSTHROUGH, NULL, (LPSTR)lpPTS, NULL);
    }
  while ((lpPTS->wSize == BUFSIZE));

  _lclose(hFile);
  _retni(1);

}

#endif

//----------------------------------------------------------------------------//

#undef DRAFTMODE

CLIPPER DRAFTMODE( PARAMS ) // lMode
{
   LPDEVMODE  lpDevMode;

   PrinterInit();

   lpDevMode  = (LPDEVMODE) GlobalLock( pd.hDevMode );

   lpDevMode->dmFields        = lpDevMode->dmFields | DM_PRINTQUALITY;
   lpDevMode->dmPrintQuality  = IF( _parl( 1 ), -1, -4 );

   GlobalUnlock( pd.hDevMode );
}

//----------------------------------------------------------------------------//

CLIPPER SPOOLFILE( PARAMS )
{
   #ifndef __FLAT__
   _retni( SpoolFile( _parc( 1 ), _parc( 2 ), _parc( 3 ), _parc( 4 ) ) );
   #endif
}

//----------------------------------------------------------------------------//

CLIPPER devMODE( PARAMS ) // lMode
{
   /*
   LPDEVMODE  lpDevMode;

   PrinterInit();

   lpDevMode  = (LPDEVMODE) GlobalLock( pd.hDevMode );

   if( PCOUNT() )
   {
      lpDevMode->dmDeviceName  = _parc( 1, 1 );
      lpDevMode->dmSpecVersion = _parni( 1, 2 );
      lpDevMode->dm...
   }

   _reta( 26 );

   _storc( lpDevMode->dmDeviceName,     -1, 1 );
   _storni( lpDevMode->dmSpecVersion,   -1, 2 );
   _storni( lpDevMode->dmDriverVersion, -1, 3 );

   _stornl( lpDevMode->dmSpecVersion, -1, 2 ); // use stornl for 4 bytes

       BCHAR  dmDeviceName[CCHDEVICENAME];
       WORD   dmSpecVersion;
       WORD   dmDriverVersion;
       WORD   dmSize;
       WORD   dmDriverExtra;
       DWORD  dmFields;
       short  dmOrientation;
       short  dmPaperSize;
       short  dmPaperLength;
       short  dmPaperWidth;
       short  dmScale;
       short  dmCopies;
       short  dmDefaultSource;
       short  dmPrintQuality;
       short  dmColor;
       short  dmDuplex;
       short  dmYResolution;
       short  dmTTOption;
       short  dmCollate;
       BCHAR  dmFormName[CCHFORMNAME];
       WORD  dmLogPixels;
       DWORD  dmBitsPerPel;
       DWORD  dmPelsWidth;
       DWORD  dmPelsHeight;
       DWORD  dmDisplayFlags;
       DWORD  dmDisplayFrequency;

   GlobalUnlock( pd.hDevMode );
   */
}

//----------------------------------------------------------------------------//

CLIPPER COMDLGXERR( PARAMS ) // () --> nError
{
      _retnl( CommDlgExtendedError() );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__

static int CALLBACK EnumFamCallBack( LOGFONT FAR * lpnlf,
     TEXTMETRIC FAR * lpntm, int FontType, LPARAM lParam )
{
   #ifndef __FLAT__
   _putsym( _SymEVAL );
   _xpushm( ( PCLIPVAR ) lParam );

   _reta( 14 );  // LOGFONT elements
   _stornl( lpnlf->lfHeight,         -1, 1 );
   _stornl( lpnlf->lfWidth,          -1, 2 );
   _stornl( lpnlf->lfEscapement,     -1, 3 );
   _stornl( lpnlf->lfOrientation,    -1, 4 );
   _stornl( lpnlf->lfWeight,         -1, 5 );
   _stornl( lpnlf->lfItalic,         -1, 6 );
   _stornl( lpnlf->lfUnderline,      -1, 7 );
   _stornl( lpnlf->lfStrikeOut,      -1, 8 );
   _stornl( lpnlf->lfCharSet,        -1, 9 );
   _stornl( lpnlf->lfOutPrecision,   -1, 10 );
   _stornl( lpnlf->lfClipPrecision,  -1, 11 );
   _stornl( lpnlf->lfQuality,        -1, 12 );
   _stornl( lpnlf->lfPitchAndFamily, -1, 13 );
   _storc( lpnlf->lfFaceName,        -1, 14 );
   _xpushm( _eval );

   _reta( 20 );  // TEXTMETRICS elements
   _stornl( lpntm->tmHeight,           -1, 1 );
   _stornl( lpntm->tmAscent,           -1, 2 );
   _stornl( lpntm->tmDescent,          -1, 3 );
   _stornl( lpntm->tmInternalLeading,  -1, 4 );
   _stornl( lpntm->tmExternalLeading,  -1, 5 );
   _stornl( lpntm->tmAveCharWidth,     -1, 6 );
   _stornl( lpntm->tmMaxCharWidth,     -1, 7 );
   _stornl( lpntm->tmWeight,           -1, 8 );
   _stornl( lpntm->tmItalic,           -1, 9 );
   _stornl( lpntm->tmUnderlined,       -1, 10 );
   _stornl( lpntm->tmStruckOut,        -1, 11 );
   _stornl( lpntm->tmFirstChar,        -1, 12 );
   _stornl( lpntm->tmLastChar,         -1, 13 );
   _stornl( lpntm->tmDefaultChar,      -1, 14 );
   _stornl( lpntm->tmBreakChar,        -1, 15 );
   _stornl( lpntm->tmPitchAndFamily,   -1, 16 );
   _stornl( lpntm->tmCharSet,          -1, 17 );
   _stornl( lpntm->tmOverhang,         -1, 18 );
   _stornl( lpntm->tmDigitizedAspectX, -1, 19 );
   _stornl( lpntm->tmDigitizedAspectY, -1, 20 );
   _xpushm( _eval );

   _PutLN( FontType );
   _xEval( 3 );

   return _parnl( -1 );
   #else
      return 0;
   #endif
}

#ifdef __HARBOUR__
   CLIPPER ENUMFONTFAMILIES( PARAMS ) // ( hDC, cFamily, bCallBack )
#else
   CLIPPER ENUMFONTFA( PARAMS ) // MILIES( hDC, cFamily, bCallBack )
#endif
{
   FONTENUMPROC lpEnumFamCallBack = ( FONTENUMPROC )
      MakeProcInstance( ( FARPROC ) EnumFamCallBack, GetInstance() );
   #ifndef __FLAT__
      LPVOID bCallBack = ( LPVOID ) _param( 3, 0xFFFF );
   #else
      LPARAM bCallBack;
   #endif

   EnumFontFamilies( ( HDC ) _parnl( 1 ),
                     IF( ISCHAR( 2 ), _parc( 2 ), NULL ),
                     lpEnumFamCallBack,
                     bCallBack ); // ( LPARAM ) aFontCount );

   FreeProcInstance( ( FARPROC ) lpEnumFamCallBack );
}

#endif

//----------------------------------------------------------------------------//