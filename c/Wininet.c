#include <Windows.h>
#include <Wininet.h>
#include <hbapi.h>

static HMODULE hModule = NULL;

//----------------------------------------------------------------------------//

HB_FUNC( WININET )
{
    if( hModule == NULL )
        {
        hModule = LoadLibrary( "WinINet.dll" );
        }
    hb_retnl( ( LONG ) hModule );
}

//----------------------------------------------------------------------------//
 
HB_FUNC( WININETEXIT )
{
    if( hModule != NULL )
    {
        FreeLibrary( hModule );
        hModule = NULL;
    }
}

//----------------------------------------------------------------------------//

HB_FUNC( INTERNETOPEN )
{

    HINTERNET hInternet;

    LPCTSTR lpszAgent       = hb_parc( 1 );
    DWORD dwAccessType      = hb_parnl( 2 );
    LPCTSTR lpszProxyName   = hb_parc( 3 );
    LPCTSTR lpszProxyBypass = hb_parc( 4 );
    DWORD dwFlags           = hb_parnl( 5 );

    if( hModule == NULL )
        hModule = LoadLibrary( "WinINet.dll" );

    hInternet               = InternetOpenA( lpszAgent, dwAccessType, lpszProxyName, lpszProxyBypass, dwFlags );

    hb_retnl( ( LONG ) hInternet );
}

//---------------------------------------------------------------------------//

HB_FUNC( INTERNETCONNECT )
{

    HINTERNET hInternet         = ( HINTERNET ) hb_parnl( 1 );
    LPCTSTR lpszServerName      = hb_parc( 2 );
    INTERNET_PORT nServerPort   = ( INTERNET_PORT ) hb_parnl( 3 );
    LPCTSTR lpszUsername        = hb_parc( 4 );
    LPCTSTR lpszPassword        = hb_parc( 5 );
    DWORD dwService             = hb_parnl( 6 );
    DWORD dwFlags               = hb_parnl( 7 );
    DWORD_PTR dwContext         = ( DWORD_PTR ) hb_parnl( 8 );

    if( hModule == NULL )
        hModule = LoadLibrary( "WinINet.dll" );

    hInternet                   = InternetConnectA( hInternet, lpszServerName, nServerPort, lpszUsername, lpszPassword, dwService, dwFlags, dwContext );

    hb_retnl( ( LONG ) hInternet );
}

//---------------------------------------------------------------------------//

HB_FUNC( INTERNETCLOSEHANDLE )
{
    hb_retl( InternetCloseHandle( ( HINTERNET ) hb_parnl( 1 ) ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( FTPPUTFILE )
{
    HINTERNET hConnect          = ( HINTERNET ) hb_parnl( 1 );
    LPCTSTR lpszLocalFile       = hb_parc( 2 );
    LPCTSTR lpszNewRemoteFile   = hb_parc( 3 );
    DWORD dwFlags               = hb_parnl( 4 );
    DWORD_PTR dwContext         = ( DWORD_PTR ) hb_parnl( 5 );

    hb_retl( FtpPutFileA( hConnect, lpszLocalFile, lpszNewRemoteFile, dwFlags, dwContext ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( FTPGETFILE )
{
    HINTERNET hConnect          = ( HINTERNET ) hb_parnl( 1 );
    LPCTSTR lpszRemoteFile      = hb_parc( 2 );
    LPCTSTR lpszNewFile         = hb_parc( 3 );
    BOOL fFailIfExists          = hb_parl( 4 );
    DWORD dwFlagsAndAttributes  = hb_parnl( 5 );
    DWORD dwFlags               = hb_parnl( 6 );
    DWORD_PTR dwContext         = ( DWORD_PTR ) hb_parnl( 7 );

    hb_retl( FtpGetFileA( hConnect, lpszRemoteFile, lpszNewFile, fFailIfExists, dwFlagsAndAttributes, dwFlags, dwContext ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( FTPOPENFILE )
{
    HINTERNET hConnect          = ( HINTERNET ) hb_parnl( 1 );
    LPCTSTR lpszFileName        = hb_parc( 2 );
    DWORD dwAccess              = hb_parnl( 3 );
    DWORD dwFlags               = hb_parnl( 4 );
    DWORD_PTR dwContext         = ( DWORD_PTR ) hb_parnl( 5 );

    hb_retnl( ( LONG ) FtpOpenFileA( hConnect, lpszFileName, dwAccess, dwFlags, dwContext ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( INTERNETWRITEFILE )
{
    HINTERNET hFile                     = ( HINTERNET ) hb_parnl( 1 );
    LPCVOID lpBuffer                    = hb_parc( 2 );
    DWORD dwNumberOfBytesToWrite        = hb_parnl( 3 );
    DWORD dwNumberOfBytesWritten        = 0;

    hb_retl( InternetWriteFile( hFile, lpBuffer, dwNumberOfBytesToWrite, &dwNumberOfBytesWritten ) );
    hb_stornl( dwNumberOfBytesWritten, 4 );
}

//---------------------------------------------------------------------------//

HB_FUNC( INTERNETREADFILE )
{
    HINTERNET hFile                     = ( HINTERNET ) hb_parnl( 1 );
    DWORD dwNumberOfBytesToRead         = hb_parnl( 3 );
    DWORD dwNumberOfBytesRead           = hb_parnl( 4 );
    char * pBuffer;

    if( hb_parcsiz( 2 ) >= dwNumberOfBytesToRead )
    {
        pBuffer = ( char * ) hb_xgrab( dwNumberOfBytesToRead );

        if( InternetReadFile( hFile, pBuffer, dwNumberOfBytesToRead, &dwNumberOfBytesRead ) )
        {
            hb_storclen( pBuffer, dwNumberOfBytesRead, 2 );
            hb_stornl( dwNumberOfBytesRead, 4 );

            hb_retl( TRUE );
        }

        hb_xfree( pBuffer );
    }

    hb_retl( FALSE );
}


//---------------------------------------------------------------------------//

HB_FUNC( FTPDELETEFILE )
{
    HINTERNET hConnect      = ( HINTERNET ) hb_parnl( 1 );
    LPCTSTR lpszFileName    = hb_parc( 2 );

    hb_retnl( ( LONG ) FtpDeleteFileA( hConnect, lpszFileName ) );

}

//---------------------------------------------------------------------------//

HB_FUNC( INTERNETDIRECTORY )
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

   bRet = FtpGetCurrentDirectoryA( hInternet, lpszCurrentDirectory, &dwCurrentDirectory ) ;
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