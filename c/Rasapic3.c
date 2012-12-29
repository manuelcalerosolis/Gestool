#include <Win32\Windows.h>
#include <Win32\Ras.h>
#include "Extend.api"

extern void _bset( void *, BYTE, ULONG );

#define  ERROR_VAL   634
#define  BUFFER_SIZE 512

CLIPPER RASHANGUP_C3( void )
{
    _retnl( RasHangUp( ( HRASCONN ) _parnl( 1 ) ) );
}

CLIPPER RASGETERRORSTRING_C3( void )
{
    DWORD cBufSize = BUFFER_SIZE;
    CHAR  lpszErrorString[ BUFFER_SIZE ];

    if( RasGetErrorString( _parnl( 1 ), lpszErrorString, cBufSize ) == 0 ) {
        _retc( lpszErrorString );
    }
    else {
        _retc( "RasGetErrorString failed" );
    }
}

CLIPPER RASDIAL_C3( void )
{
   char * szEntryName;
   RASDIALPARAMS stRasDialParams;
   HRASCONN hRasConn;

   szEntryName = _parc( 1 );
   _bset( &stRasDialParams, 0, sizeof( RASDIALPARAMS ) );
   stRasDialParams.dwSize  = sizeof( RASDIALPARAMS );

   if( * szEntryName != NULL )
   {
      lstrcpyn( stRasDialParams.szEntryName, _parc( 1 ), RAS_MaxEntryName );
      stRasDialParams.szEntryName[ RAS_MaxEntryName ] = NULL;
   }

   lstrcpyn( stRasDialParams.szUserName, _parc( 2 ), UNLEN );
   stRasDialParams.szUserName[ UNLEN ] = NULL;

   lstrcpyn( stRasDialParams.szPassword, _parc( 3 ), PWLEN );
   stRasDialParams.szPassword[ PWLEN ] = NULL;

   hRasConn = NULL;
   _retnl( RasDial( NULL, NULL, &stRasDialParams, 0, NULL, &hRasConn ) );

   _stornl( ( LONG ) hRasConn, 4 );
}