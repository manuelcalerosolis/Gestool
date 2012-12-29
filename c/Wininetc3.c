#include <Windows.h>
#include "Extend.api"

typedef void * ITEM;
extern BYTE * __pascal _ARRAYNEW( ULONG );
extern USHORT _cAtPutStr( ITEM, ULONG, BYTE *, ULONG );
extern unsigned short _cAt( void *, long, unsigned short, void * );
extern void _putln( long );
extern void _cAtPut( ITEM, unsigned long, ITEM );
extern void _DropGrip( ITEM );
extern ITEM _GetGrip( ITEM );
extern ITEM _tos;
extern ITEM _eval;
extern void _xpopm( ITEM );
extern unsigned short _xpushm( void * );
extern void * _xgrab( ULONG );
extern void _xfree( void * );

typedef unsigned short int INTERNET_PORT;
typedef LPVOID HINTERNET;
typedef long * DWORD_PTR;

typedef struct WIN32_FIND_DATA {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
    DWORD dwReserved0;
    DWORD dwReserved1;
    TCHAR cFileName[MAX_PATH];
    TCHAR cAlternateFileName[14];
};

HINTERNET WINAPI InternetOpenA( LPCSTR, DWORD, LPCSTR, LPCSTR, DWORD );
HINTERNET WINAPI InternetConnectA( HINTERNET, LPCSTR, INTERNET_PORT, LPCSTR, LPCSTR, DWORD, DWORD, DWORD_PTR );
BOOL WINAPI InternetCloseHandle( HINTERNET );
BOOL WINAPI FtpPutFileA( HINTERNET, LPCSTR, LPCSTR, DWORD, DWORD_PTR );
BOOL WINAPI FtpGetFileA( HINTERNET, LPCTSTR, LPCTSTR, BOOL, DWORD, DWORD, DWORD_PTR );
HINTERNET WINAPI FtpOpenFileA( HINTERNET, LPCTSTR, DWORD, DWORD, DWORD_PTR );
BOOL WINAPI InternetWriteFile( HINTERNET, LPCVOID, DWORD, LPDWORD );
BOOL WINAPI InternetReadFile( HINTERNET, LPCVOID, DWORD, LPDWORD );
BOOL WINAPI FtpDeleteFileA( HINTERNET, LPCTSTR );
HINTERNET WINAPI FtpFindFirstFileA( HINTERNET, LPCTSTR, LPWIN32_FIND_DATA, DWORD, DWORD_PTR );
HINTERNET WINAPI InternetFindNextFileA( HINTERNET, LPWIN32_FIND_DATA );

static HMODULE hModule = NULL;

//----------------------------------------------------------------------------//

CLIPPER WININET_C3( void )
{
    if( hModule == NULL )
        {
        hModule = LoadLibrary( "WinINet.dll" );
        }
    _retnl( ( LONG ) hModule );
}

//----------------------------------------------------------------------------//

CLIPPER WININETEXIT_C3( void )
{
    if( hModule != NULL )
    {
        FreeLibrary( hModule );
        hModule = NULL;
    }
}

//----------------------------------------------------------------------------//

CLIPPER INTERNETOPEN_C3( void )
{

    HINTERNET hInternet;

    LPCTSTR lpszAgent       = _parc( 1 );
    DWORD dwAccessType      = _parnl( 2 );
    LPCTSTR lpszProxyName   = _parc( 3 );
    LPCTSTR lpszProxyBypass = _parc( 4 );
    DWORD dwFlags           = _parnl( 5 );

    if( hModule == NULL )
        hModule = LoadLibrary( "WinINet.dll" );

    hInternet               = InternetOpenA( lpszAgent, dwAccessType, lpszProxyName, lpszProxyBypass, dwFlags );

    _retnl( ( LONG ) hInternet );
}

//---------------------------------------------------------------------------//

CLIPPER INTERNETCONNECT_C3( void )
{

    HINTERNET hInternet         = ( HINTERNET ) _parnl( 1 );
    LPCTSTR lpszServerName      = _parc( 2 );
    INTERNET_PORT nServerPort   = _parnl( 3 );
    LPCTSTR lpszUsername        = _parc( 4 );
    LPCTSTR lpszPassword        = _parc( 5 );
    DWORD dwService             = _parnl( 6 );
    DWORD dwFlags               = _parnl( 7 );
    DWORD_PTR dwContext         = ( DWORD_PTR ) _parnl( 8 );

    if( hModule == NULL )
        hModule = LoadLibrary( "WinINet.dll" );

    hInternet                   = InternetConnectA( hInternet, lpszServerName, nServerPort, lpszUsername, lpszPassword, dwService, dwFlags, dwContext );

    _retnl( ( LONG ) hInternet );
}

//---------------------------------------------------------------------------//

CLIPPER INTERNETCLOSEHANDLE_C3( void )
{
    _retl( InternetCloseHandle( ( HINTERNET ) _parnl( 1 ) ) );
}

//---------------------------------------------------------------------------//

CLIPPER FTPPUTFILE_C3( void )
{
    HINTERNET hConnect          = ( HINTERNET ) _parnl( 1 );
    LPCTSTR lpszLocalFile       = _parc( 2 );
    LPCTSTR lpszNewRemoteFile   = _parc( 3 );
    DWORD dwFlags               = _parnl( 4 );
    DWORD_PTR dwContext         = ( DWORD_PTR ) _parnl( 5 );

    _retl( FtpPutFileA( hConnect, lpszLocalFile, lpszNewRemoteFile, dwFlags, dwContext ) );
}

//---------------------------------------------------------------------------//

CLIPPER FTPGETFILE_C3( void )
{
    HINTERNET hConnect          = ( HINTERNET ) _parnl( 1 );
    LPCTSTR lpszRemoteFile      = _parc( 2 );
    LPCTSTR lpszNewFile         = _parc( 3 );
    BOOL fFailIfExists          = _parl( 4 );
    DWORD dwFlagsAndAttributes  = _parnl( 5 );
    DWORD dwFlags               = _parnl( 6 );
    DWORD_PTR dwContext         = ( DWORD_PTR ) _parnl( 7 );

    _retl( FtpGetFileA( hConnect, lpszRemoteFile, lpszNewFile, fFailIfExists, dwFlagsAndAttributes, dwFlags, dwContext ) );
}

//---------------------------------------------------------------------------//

CLIPPER FTPOPENFILE_C3( void )
{
    HINTERNET hConnect          = ( HINTERNET ) _parnl( 1 );
    LPCTSTR lpszFileName        = _parc( 2 );
    DWORD dwAccess              = _parnl( 3 );
    DWORD dwFlags               = _parnl( 4 );
    DWORD_PTR dwContext         = ( DWORD_PTR ) _parnl( 5 );

    _retnl( ( LONG ) FtpOpenFileA( hConnect, lpszFileName, dwAccess, dwFlags, dwContext ) );
}

//---------------------------------------------------------------------------//

CLIPPER INTERNETWRITEFILE_C3( void )
{
    HINTERNET hFile                     = ( HINTERNET ) _parnl( 1 );
    LPCVOID lpBuffer                    = _parc( 2 );
    DWORD dwNumberOfBytesToWrite        = _parnl( 3 );
    DWORD dwNumberOfBytesWritten        = 0;

    _retl( InternetWriteFile( hFile, lpBuffer, dwNumberOfBytesToWrite, &dwNumberOfBytesWritten ) );
    _stornl( dwNumberOfBytesWritten, 4 );
}

//---------------------------------------------------------------------------//

CLIPPER INTERNETREADFILE_C3( void )
{
    HINTERNET hFile                     = ( HINTERNET ) _parnl( 1 );
    DWORD dwNumberOfBytesToRead         = _parnl( 3 );
    DWORD dwNumberOfBytesRead           = _parnl( 4 );
    BYTE * pBuffer;

    if( _parcsiz( 2 ) >= dwNumberOfBytesToRead )
    {
        pBuffer = _xgrab( dwNumberOfBytesToRead );

        if( InternetReadFile( hFile, pBuffer, dwNumberOfBytesToRead, &dwNumberOfBytesRead ) )
        {
            _storclen( pBuffer, dwNumberOfBytesRead, 2 );
            _stornl( dwNumberOfBytesRead, 4 );

            _retl( TRUE );
        }

        _xfree( pBuffer );
    }

    _retl( FALSE );
}


//---------------------------------------------------------------------------//

CLIPPER FTPDELETEFILE_C3( void )
{
    HINTERNET hConnect      = ( HINTERNET ) _parnl( 1 );
    LPCTSTR lpszFileName    = _parc( 2 );

    _retnl( ( LONG ) FtpDeleteFileA( hConnect, lpszFileName ) );

}

//---------------------------------------------------------------------------//

CLIPPER INTERNETDIRECTORY_C3( void )
{
    HINTERNET hConnect          = ( HINTERNET ) _parnl( 1 );
    LPCTSTR lpszSearchFile      = _parc( 2 );
    DWORD dwFlags               = _parnl( 3 );
    DWORD_PTR dwContext         = ( DWORD_PTR ) _parnl( 4 );
    ITEM pFiles;
    ITEM pItem;

    unsigned int iFiles         = 0;
    unsigned int iCount;

    WIN32_FIND_DATA lpFindFileData;
    HINTERNET hFind ;

    hFind = FtpFindFirstFileA( hConnect, lpszSearchFile, &lpFindFileData, dwFlags, dwContext );
    if ( hFind )
    {
        iFiles++;
        while ( InternetFindNextFileA( hFind, &lpFindFileData ) )
        {
            iFiles++;
        }
        InternetCloseHandle( hFind );
    }

    InternetCloseHandle( hFind );

    _ARRAYNEW( iFiles );

    pFiles = _GetGrip( _eval );

    for( iCount = 1; iCount <= iFiles; iCount++ )
    {
       _ARRAYNEW( 2 );

       _cAtPut( pFiles, iCount, _eval );
    }

    iCount = 1;

    pItem = _GetGrip( NULL );

    hFind = FtpFindFirstFileA( hConnect, lpszSearchFile, &lpFindFileData, dwFlags, dwContext );

    if ( hFind )
    {
        _cAt( pFiles, iCount++, S_ARRAY, pItem );

        _cAtPutStr( pItem, 1, ( BYTE * ) lpFindFileData.cFileName, lstrlen( lpFindFileData.cFileName ) );

        _putln( lpFindFileData.nFileSizeLow + lpFindFileData.nFileSizeHigh * 0xFFFFFFFF );

        _cAtPut( pItem, 2, _tos );
        _xpopm( _tos );

        while ( InternetFindNextFileA( hFind, &lpFindFileData ) )
        {
            _cAt( pFiles, iCount++, S_ARRAY, pItem );

            _cAtPutStr( pItem, 1, ( BYTE * ) lpFindFileData.cFileName, lstrlen( lpFindFileData.cFileName ) );

            _putln( lpFindFileData.nFileSizeLow + lpFindFileData.nFileSizeHigh * 0xFFFFFFFF );

            _cAtPut( pItem, 2, _tos );
            _xpopm( _tos );
        }
        InternetCloseHandle( hFind );
    }

    _xpushm( pFiles );
    _xpopm( _eval );

    _DropGrip( pFiles );
    _DropGrip( pItem );
}

//---------------------------------------------------------------------------//

/*
DLL32 FUNCTION FtpCreateDirectory( hFTP AS LONG, cDirName AS LPSTR ) AS BOOL PASCAL ;
                                   FROM "FtpCreateDirectoryA" LIB hWinINet

DLL32 FUNCTION FtpFindFirstFile( hFTP AS LONG, cMask AS LPSTR,;
                                 @cWin32DataInfo AS LPSTR, n1 AS LONG, n2 AS LONG ) ;
                                 AS LONG PASCAL FROM "FtpFindFirstFileA" LIB hWinINet

DLL32 FUNCTION InternetFindNextFile( hFTPDir AS LONG, @cWin32DataInfo AS LPSTR ) ;
                             AS BOOL PASCAL FROM "InternetFindNextFileA" LIB hWinINet

DLL32 FUNCTION InternetSetFilePointer( hFile AS LONG, nPos AS LONG,;
                                       n1 AS LONG, nFrom AS LONG, n2 AS LONG ) ;
                             AS BOOL PASCAL LIB hWinINet

DLL32 FUNCTION InternetAt(  Dwreserve AS LONG) ;
               AS LONG PASCAL FROM "InternetAttemptConnect" LIB hWinINet

DLL32 FUNCTION InternetGo( Lpurl AS LPSTR, Hwnd AS LONG, dwreserve AS LONG);
               AS BOOL PASCAL FROM "InternetGoOnline" LIB hWinInet

DLL32 FUNCTION InternetAu( Dwflags AS LONG, Hwnd AS WORD) ;
               AS BOOL PASCAL FROM "InternetAutoDial" LIB hWinInet

DLL32 FUNCTION Internetdi( Hwnd AS LONG, Cconnect AS LPSTR, Dwflag AS LONG, ;
               @Dwconnect AS PTR , Dwreserve AS LONG) AS DWORD ;
               PASCAL FROM "InternetDial" LIB hWinInet

DLL32 FUNCTION Internetha( dwconnect AS LONG, Dwreserve AS LONG) AS DWORD ;
               PASCAL FROM "InternetHangUp" LIB hWinInet

DLL32 FUNCTION Interautha( Dwreserve AS LONG) AS BOOL PASCAL FROM ;
               "InternetAutodialHangup" LIB hWinInet

DLL32 FUNCTION InternetSt( @LpDwflags AS PTR, Dwreserve AS LONG) AS BOOL ;
               PASCAL FROM "InternetGetConnectedState" LIB hWinInet

DLL32 Function IntRespinf( @Lpdwerror AS PTR,Lpzbuffer AS LPSTR, @Lplen AS PTR) ;
               AS BOOL PASCAL FROM "InternetGetLastResponseInfoA" ;
               LIB hWininet
*/

//----------------------------------------------------------------------------//