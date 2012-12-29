#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>

#include <Wininet.h>

static HMODULE hModule = NULL;

//----------------------------------------------------------------------------//

HB_FUNC( WININET_C3 )
{
    if( hModule == NULL )
        {
        hModule = LoadLibrary( "WinINet.dll" );
        }
    _retnl( ( LONG ) hModule );
}

//----------------------------------------------------------------------------//

HB_FUNC( WININETEXIT_C3 )
{
    if( hModule != NULL )
    {
        FreeLibrary( hModule );
        hModule = NULL;
    }
}

//----------------------------------------------------------------------------//

HB_FUNC( INTERNETOPEN_C3 )
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

HB_FUNC( INTERNETCONNECT_C3 )
{

    HINTERNET hInternet         = ( HINTERNET ) _parnl( 1 );
    LPCTSTR lpszServerName      = _parc( 2 );
    INTERNET_PORT nServerPort   = ( INTERNET_PORT ) _parnl( 3 );
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

HB_FUNC( INTERNETCLOSEHANDLE_C3 )
{
    _retl( InternetCloseHandle( ( HINTERNET ) _parnl( 1 ) ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( FTPPUTFILE_C3 )
{
    HINTERNET hConnect          = ( HINTERNET ) _parnl( 1 );
    LPCTSTR lpszLocalFile       = _parc( 2 );
    LPCTSTR lpszNewRemoteFile   = _parc( 3 );
    DWORD dwFlags               = _parnl( 4 );
    DWORD_PTR dwContext         = ( DWORD_PTR ) _parnl( 5 );

    _retl( FtpPutFileA( hConnect, lpszLocalFile, lpszNewRemoteFile, dwFlags, dwContext ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( FTPGETFILE_C3 )
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

HB_FUNC( FTPOPENFILE_C3 )
{
    HINTERNET hConnect          = ( HINTERNET ) _parnl( 1 );
    LPCTSTR lpszFileName        = _parc( 2 );
    DWORD dwAccess              = _parnl( 3 );
    DWORD dwFlags               = _parnl( 4 );
    DWORD_PTR dwContext         = ( DWORD_PTR ) _parnl( 5 );

    _retnl( ( LONG ) FtpOpenFileA( hConnect, lpszFileName, dwAccess, dwFlags, dwContext ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( INTERNETWRITEFILE_C3 )
{
    HINTERNET hFile                     = ( HINTERNET ) _parnl( 1 );
    LPCVOID lpBuffer                    = _parc( 2 );
    DWORD dwNumberOfBytesToWrite        = _parnl( 3 );
    DWORD dwNumberOfBytesWritten        = 0;

    _retl( InternetWriteFile( hFile, lpBuffer, dwNumberOfBytesToWrite, &dwNumberOfBytesWritten ) );
    _stornl( dwNumberOfBytesWritten, 4 );
}

//---------------------------------------------------------------------------//

HB_FUNC( INTERNETREADFILE_C3 )
{
    HINTERNET hFile                     = ( HINTERNET ) _parnl( 1 );
    DWORD dwNumberOfBytesToRead         = _parnl( 3 );
    DWORD dwNumberOfBytesRead           = _parnl( 4 );
    char * pBuffer;

    if( _parcsiz( 2 ) >= dwNumberOfBytesToRead )
    {
        pBuffer = ( char * ) _xgrab( dwNumberOfBytesToRead );

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

HB_FUNC( FTPDELETEFILE_C3 )
{
    HINTERNET hConnect      = ( HINTERNET ) _parnl( 1 );
    LPCTSTR lpszFileName    = _parc( 2 );

    _retnl( ( LONG ) FtpDeleteFileA( hConnect, lpszFileName ) );

}

//---------------------------------------------------------------------------//

HB_FUNC( INTERNETDIRECTORY_C3 )
{

   HINTERNET hConnect = ( HINTERNET ) hb_parnl( 1 );
   LPCTSTR lpszSearchFile = hb_parc( 2 );
   DWORD dwFlags = hb_parnl( 3 );
   DWORD_PTR dwContext = ( DWORD_PTR ) hb_parnl( 4 );
   PHB_ITEM pFiles;
   PHB_ITEM pItem;
   unsigned int iFiles = 0;
   unsigned int iCount;

   WIN32_FIND_DATA lpFindFileData;
   HINTERNET hFind ;

   hFind = FtpFindFirstFileA( hConnect, lpszSearchFile, &lpFindFileData, dwFlags, dwContext );

   if ( hFind )
   {
      iFiles++;

	while( InternetFindNextFileA( hFind, &lpFindFileData ) )
      {
         iFiles++;
       }
       InternetCloseHandle( hFind );
   }

   InternetCloseHandle( hFind );

   hb_reta( iFiles );
   pFiles = hb_gcGripGet( hb_stackReturnItem() );

   for( iCount = 1; iCount <= iFiles; iCount++ )
   {
      hb_reta( 2 );
      hb_arraySet( pFiles, iCount, hb_stackReturnItem() );
   }

   iCount = 1;
   pItem = hb_gcGripGet( NULL );

   hFind = FtpFindFirstFileA( hConnect, lpszSearchFile, &lpFindFileData, dwFlags, dwContext );

   if( hFind )
   {
      hb_arrayGet( pFiles, iCount++, pItem );
      hb_retclen( ( char * ) lpFindFileData.cFileName, lstrlen( lpFindFileData.cFileName ) );
      hb_arraySet( pItem, 1, hb_stackReturnItem() );
      hb_retnl( lpFindFileData.nFileSizeLow + lpFindFileData.nFileSizeHigh * 0xFFFFFFFF );
      hb_arraySet( pItem, 2, hb_stackReturnItem() );

      while( InternetFindNextFileA( hFind, &lpFindFileData ) )
      {
         hb_arrayGet( pFiles, iCount++, pItem );
         hb_retclen( ( char * ) lpFindFileData.cFileName, lstrlen( lpFindFileData.cFileName ) );
         hb_arraySet( pItem, 1, hb_stackReturnItem() );
         hb_retnl( lpFindFileData.nFileSizeLow + lpFindFileData.nFileSizeHigh * 0xFFFFFFFF );
         hb_arraySet( pItem, 2, hb_stackReturnItem() );
      }

      InternetCloseHandle( hFind );
   }

   hb_itemCopy( hb_stackReturnItem(), pFiles );
   hb_gcGripDrop( pFiles );
   hb_gcGripDrop( pItem );

}

//---------------------------------------------------------------------------//

HB_FUNC( FTPGETCURRENTDIRECTORY )
{
   HINTERNET hInternet           = ( HINTERNET ) hb_parnl( 1 ) ;
   LPTSTR   lpszCurrentDirectory = ( LPTSTR ) hb_xgrab( MAX_PATH ) ;
   DWORD    dwCurrentDirectory   = MAX_PATH     ;
   BOOL     bRet ;

   bRet = FtpGetCurrentDirectory( hInternet, lpszCurrentDirectory, &dwCurrentDirectory ) ;
   hb_retl( bRet ) ;

   if ( bRet )
   {
      if ( ISBYREF( 2 ) )
         hb_storclen( ( char * ) lpszCurrentDirectory, ( ULONG ) dwCurrentDirectory, 2 ) ;
   }

   hb_xfree( lpszCurrentDirectory ) ;
}

//---------------------------------------------------------------------//

HB_FUNC( FTPSETCURRENTDIRECTORY )
{
   HINTERNET hInternet     = ( HINTERNET ) hb_parnl( 1 ) ;
   LPTSTR    lpszDirectory = hb_parcx( 2 ) ;

   hb_retl( FtpSetCurrentDirectoryA( hInternet, lpszDirectory ) ) ;
}

//---------------------------------------------------------------------//

HB_FUNC( FTPCREATEDIRECTORY )
{
   HINTERNET hInternet     = ( HINTERNET ) hb_parnl( 1 ) ;
   LPCTSTR   lpszDirectory = hb_parcx( 2 ) ;

   hb_retl( FtpCreateDirectoryA( hInternet, lpszDirectory ) ) ;

}

//---------------------------------------------------------------------//

HB_FUNC( FTPREMOVEDIRECTORY )
{
   HINTERNET hInternet     = ( HINTERNET ) hb_parnl( 1 ) ;
   LPCTSTR   lpszDirectory = hb_parcx( 2 ) ;

   hb_retl( FtpRemoveDirectoryA( hInternet, lpszDirectory ) ) ;

}

//---------------------------------------------------------------------//









































































































































































































































































































