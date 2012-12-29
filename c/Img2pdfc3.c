#include <Windows.h>
#include <CommDlg.h>
#include "Extend.api"

#define OPTION_NONE         0
#define OPTION_OPEN_PDF		1
#define OPTION_RESET		2

UINT WINAPI I2PDF_AddImage( char * );
UINT WINAPI I2PDF_SetDPI( UINT );
UINT WINAPI I2PDF_MakePDF( char *, int, char *, UINT );
UINT WINAPI I2PDF_License( char * );

UINT WINAPI GetSystemWindowsDirectoryA( LPSTR , UINT );

static HMODULE hModule = NULL;

static far PRINTDLG pd;
static far BOOL bInit = FALSE;

extern void _bset( void *, BYTE, ULONG );

//---------------------------------------------------------------------------//

UINT ShowError(char *which, UINT iErr)
{
	char message[200];

	wsprintf(message, "%s returned error %d", which, iErr);

	MessageBox(NULL, message, "Error Returned From Image2PDF DLL", MB_OK | MB_ICONERROR);

	return iErr;
}

//---------------------------------------------------------------------------//

CLIPPER I2PDF_ADDIMAGE_C3( void )
{

    LONG hResult;
    UINT iErr;

    LPSTR lpImage   = _parc( 1 );

    if( hModule == NULL )
        hModule = LoadLibrary( "IMAGE2PDF.DLL" );

    iErr            = I2PDF_AddImage( lpImage );

    if( hModule != NULL )
    {
        FreeLibrary( hModule );
        hModule = NULL;
    }

    _retnl( iErr );

}

//---------------------------------------------------------------------------//

CLIPPER I2PDF_SETDPI_C3( void )
{

    LONG hResult;
    UINT iErr;

    LONG lDpi       = _parnl( 1 );

    if( hModule == NULL )
        hModule = LoadLibrary( "IMAGE2PDF.DLL" );

    iErr            = I2PDF_SetDPI( lDpi );

    if( hModule != NULL )
    {
        FreeLibrary( hModule );
        hModule = NULL;
    }

    _retnl( iErr );

}

//---------------------------------------------------------------------------//

CLIPPER I2PDF_MAKEPDF_C3( void )
{

    LONG hResult;
    UINT iErr;

    char errorText[1024];

    LPSTR lpOutput  = _parc( 1 );

    if( hModule == NULL )
        hModule = LoadLibrary( "IMAGE2PDF.DLL" );

    iErr            = I2PDF_MakePDF( lpOutput, OPTION_OPEN_PDF, errorText, sizeof( errorText ) );

    if (iErr)
	{
		if (iErr == 3)
			ShowError(errorText, iErr);
		else
			ShowError("I2PDF_MakePDF", iErr);
	}

    if( hModule != NULL )
    {
        FreeLibrary( hModule );
        hModule = NULL;
    }

    _retnl( iErr );

}

//---------------------------------------------------------------------------//

CLIPPER I2PDF_LICENSE_C3( void )
{

    UINT iErr;

    char errorText[1024];

    if( hModule == NULL )
        hModule = LoadLibrary( "IMAGE2PDF.DLL" );

    iErr            = I2PDF_License( "IPD-TBFZ-1OTB4-5B0T8K-28VD0WC" );

    if (iErr)
	{
		if (iErr == 3)
			ShowError(errorText, iErr);
		else
            ShowError("I2PDF_License", iErr);
	}

    if( hModule != NULL )
    {
        FreeLibrary( hModule );
        hModule = NULL;
    }

    _retnl( iErr );

}

//---------------------------------------------------------------------------//

static void PrinterInit( void )
{
   if( ! bInit )
   {
      bInit = TRUE;
      _bset( ( char * ) &pd, 0, sizeof( PRINTDLG ) );
      pd.lStructSize = sizeof( PRINTDLG );
      pd.hwndOwner   = GetActiveWindow();
      pd.Flags       = PD_RETURNDEFAULT ;
      pd.nFromPage   = 1;
      pd.nToPage     = 1;
      pd.nMinPage    = 1;
      pd.nMaxPage    = 65535;
      pd.nCopies     = 1;
      PrintDlg( &pd );
   }
}

//---------------------------------------------------------------------------//

CLIPPER PRNGETNAME( void ) // () --> cPrinter
{
   LPDEVNAMES lpDevNames;

   PrinterInit();

   if( pd.hDevNames )
   {
      lpDevNames = (LPDEVNAMES) GlobalLock( pd.hDevNames );

      if( lpDevNames )
      {
         _retc( ( LPSTR ) lpDevNames + lpDevNames->wDeviceOffset );
         GlobalUnlock( pd.hDevNames );
      }
      else
         _retc( "" );
   }
   else
      _retc( "" );
}

//----------------------------------------------------------------------------//

CLIPPER GETSYSTEMWINDOWSDIRECTORY( void )
{
    CHAR Buffer[ MAX_PATH ];

    GetSystemWindowsDirectoryA( Buffer, MAX_PATH );

    _retc( Buffer );
}

//----------------------------------------------------------------------------//

static void getwinver(  OSVERSIONINFO * pOSvi )
{
  pOSvi->dwOSVersionInfoSize = sizeof( OSVERSIONINFO );
  GetVersionEx ( pOSvi );
}

CLIPPER OS_ISWTSCLIENT( void )
{
  int iResult = FALSE;
  OSVERSIONINFO osvi;
  getwinver( &osvi );
  if ( osvi.dwPlatformId == VER_PLATFORM_WIN32_NT && osvi.dwMajorVersion >= 4 )
  {
    // Only supported on NT Ver 4.0 SP3 & higher
    #ifndef SM_REMOTESESSION
       #define SM_REMOTESESSION        0x1000
    #endif
    iResult = GetSystemMetrics(SM_REMOTESESSION) ;
  }
  _retl( iResult );
}

//----------------------------------------------------------------------------//
