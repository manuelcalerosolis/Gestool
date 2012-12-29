#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>

static BOOL bCommOpen;

void nError( LONG lNum, char * szTitle )
{
	char szBuffer[ 80 ];
    wsprintf( szBuffer, "%ld", lNum );
    MessageBox( 0, szBuffer, szTitle, MB_ICONINFORMATION | MB_SYSTEMMODAL );
}

//---------------------------------------------------------------------------//

HB_FUNC( OPENCOMMPORT )
{

    HANDLE hCom;

    COMMTIMEOUTS stTimeOuts;

    char * szPort           = _parc( 1 );
    DWORD dBaudRate         = _parnl( 2 );
    BYTE bByteSize          = ( BYTE ) _parnl( 3 );
    BYTE bParity            = ( BYTE ) _parnl( 4 );
    BYTE bStopBits          = ( BYTE ) _parnl( 5 );

    DCB stDCB;
    stDCB.DCBlength         = sizeof( DCB );

    hCom = CreateFile(      szPort,
                            GENERIC_READ | GENERIC_WRITE,
                            0,              /* comm devices must be opened w/exclusive-access */
                            NULL,           /* no security attrs */
                            OPEN_EXISTING,  /* comm devices must use OPEN_EXISTING */
                            0,              /* not overlapped I/O */
                            NULL            /* hTemplate must be NULL for comm devices */
                            );

    // If CreateFile fails, throw an exception. CreateFile will fail if the
    // port is already open, or if the com port does not exist.
    if( hCom != INVALID_HANDLE_VALUE )
    {
        // Now get the DCB properties of the port we just opened
        if( !GetCommState( hCom, &stDCB ) )
        {
            nError( ( LONG ) GetLastError(), "error in GetCommState" );
            CloseHandle( hCom );
            hCom = INVALID_HANDLE_VALUE;
        }
        else
        {
            stDCB.BaudRate  =  dBaudRate;
            stDCB.ByteSize  =  bByteSize;
            stDCB.Parity    =  bParity;
            stDCB.StopBits  =  bStopBits;

            // now we can set the properties of the port with our settings.
            if( !SetCommState( hCom, &stDCB ) )
            {
                nError( ( LONG ) GetLastError(), "error in SetCommState" );
                CloseHandle( hCom );
                hCom = INVALID_HANDLE_VALUE;
            }
            else
            {
                // set the intial size of the transmit and receive queues. These are
                // not exposed to outside clients of the class either. Perhaps they should be?
                // I set the receive buffer to 32k, and the transmit buffer to 9k (a default).
                if( !SetupComm( hCom, 1024 * 32, 1024 * 9 ) )
                {
                    nError( ( LONG ) GetLastError(), "error in SetupComm" );
                    CloseHandle( hCom );
                    hCom = INVALID_HANDLE_VALUE;
                }
                else
                {
                    // These values are just default values that I determined empirically.
                    // Adjust as necessary. I don't expose these to the outside because
                    // most people aren't sure how they work (uhhh, like me included).
                    stTimeOuts.ReadIntervalTimeout         = 15;
                    stTimeOuts.ReadTotalTimeoutMultiplier  = 1;
                    stTimeOuts.ReadTotalTimeoutConstant    = 250;
                    stTimeOuts.WriteTotalTimeoutMultiplier = 1;
                    stTimeOuts.WriteTotalTimeoutConstant   = 250;

                    if( !SetCommTimeouts( hCom, &stTimeOuts ) )
                    {
                        nError( ( LONG ) GetLastError(), "error in SetCommTimeouts" );
                        CloseHandle( hCom );
                        hCom = INVALID_HANDLE_VALUE;
                    }
                }
            }
        }
    }
    // if we made it to here then success
    bCommOpen = TRUE;

    _retnl( ( LONG ) hCom );
}

//---------------------------------------------------------------------------//

HB_FUNC( WRITECOMMBUFFER )
{
    HANDLE hCom             = ( HANDLE ) _parnl( 1 );
    char * bBuffer          = _parc( 2 );
    unsigned int iByteCount = _parclen( 2 );
    DWORD dummy;

    if( bCommOpen )       // if already closed, return
        if( ( iByteCount != 0 ) && ( bBuffer != NULL ) )
            _retnl( WriteFile( hCom, bBuffer, iByteCount, &dummy, NULL ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( WRITECOMMBUFFERSLOWLY )
{
    HANDLE hCom             = ( HANDLE ) _parnl( 1 );
    char * bBuffer          = _parc( 2 );
    unsigned int iByteCount = _parclen( 2 );
    char * ptr              = bBuffer;
    unsigned int j;
    DWORD dummy;

    if( bCommOpen )       // if already closed, return
        for( j = 0; j < iByteCount; j++ )
        {
            if( !WriteFile( hCom, ptr, 1, &dummy, NULL ) )
            {
                nError( ( LONG ) GetLastError(), "error in WriteFile" );
            }
            else
            {
                if( !FlushFileBuffers( hCom ) )
                {
                    nError( ( LONG ) GetLastError(), "error in FlushFileBuffers" );
                }
            }
            ++ptr;
        }
}

//---------------------------------------------------------------------------//

HB_FUNC( WRITECOMMSTRING )
{
    HANDLE hCom             = ( HANDLE ) _parnl( 1 );
    const char *bBuffer     = _parc( 2 );
    unsigned int iByteCount = _parclen( 2 );
    DWORD dummy;

    if( bCommOpen )       // if already closed, return
        if( ( iByteCount != 0 ) && ( bBuffer != NULL ) )
            _retnl( WriteFile( hCom, bBuffer, iByteCount, &dummy, NULL ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( FLUSHCOMMPORTBUFFER )
{
    HANDLE hCom             = ( HANDLE ) _parnl( 1 );
    _retnl( !FlushFileBuffers( hCom ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( PURGETXABORTCOMMPORT )
{
    HANDLE hCom             = ( HANDLE ) _parnl( 1 );

    if( bCommOpen )     // if already closed, return
        _retnl( PurgeComm( hCom, PURGE_TXABORT ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( PURGERXABORTCOMMPORT )
{
    HANDLE hCom             = ( HANDLE ) _parnl( 1 );

    if( bCommOpen )     // if already closed, return
        _retnl( PurgeComm( hCom, PURGE_RXABORT ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( PURGETXCLEARCOMMPORT )
{
    HANDLE hCom             = ( HANDLE ) _parnl( 1 );

    if( bCommOpen )     // if already closed, return
        _retnl( PurgeComm( hCom, PURGE_TXCLEAR ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( PURGERXCLEARCOMMPORT )
{
    HANDLE hCom             = ( HANDLE ) _parnl( 1 );

    if( bCommOpen )     // if already closed, return
        _retnl( PurgeComm( hCom, PURGE_RXCLEAR ) );
}

//---------------------------------------------------------------------------//

HB_FUNC( CLOSECOMMPORT )
{
    HANDLE hCom             = ( HANDLE ) _parnl( 1 );

    if( bCommOpen )       // if already closed, return
        PurgeComm( hCom, PURGE_TXABORT );
        if( CloseHandle( hCom ) != 0 ) // CloseHandle is non-zero on success
        {
            bCommOpen = FALSE;
        }
}

//---------------------------------------------------------------------------//

/*
 * Lee o establece los parámetros del DCB.
*/

HB_FUNC(FDCB)
{

    HANDLE hCom             = ( HANDLE ) _parnl( 1 );
    DWORD dBaudRate         = _parnl( 2 );
    BYTE bByteSize          = ( BYTE ) _parnl( 3 );
    BYTE bParity            = ( BYTE ) _parnl( 4 );
    BYTE bStopBits          = ( BYTE ) _parnl( 5 );

    DCB stDCB;

    // Now get the DCB properties of the port we just opened

    if( GetCommState( hCom, &stDCB ) )
    {
        stDCB.BaudRate  =  dBaudRate;
        stDCB.ByteSize  =  bByteSize;
        stDCB.Parity    =  bParity;
        stDCB.StopBits  =  bStopBits;

        // now we can set the properties of the port with our settings.

        // SetCommState( hCom, ( DCB FAR * ) stDCB );
    }

    _retnl( ( LONG ) hCom );

}

//---------------------------------------------------------------------------//























































































