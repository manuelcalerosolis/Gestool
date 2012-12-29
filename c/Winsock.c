// WinSock.dll API support
// TCP/IP InterNet connections from FiveWin !!!

#define SOCKET _SOCKET

#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>
#include <WinSock.h>

void _strcpy( char *, char * );

#ifndef __FLAT__
   //#define SOCKADDR_IN sockaddr_in    // LKM huge error. won't complile under 16 bits if used!!!!!
#else
   #define _send send
#endif

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_WSASTARTUP( PARAMS )
#else
    CLIPPER WSASTARTUP( PARAMS )
#endif
{
   WSADATA wsa;

   _retni( WSAStartup( 0x101, &wsa ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   HARBOUR HB_FUN_WSAASYNCSELECT( PARAMS ) // ( nSocket, nHWnd, nMsg, nModes ) --> nReturn
#else
   CLIPPER WSAASYNCSE( PARAMS ) // LECT( nSocket, nHWnd, nMsg, nModes ) --> nReturn
#endif
{
   _retni( WSAAsyncSelect( _parni( 1 ), ( HWND ) _parnl( 2 ), _parni( 3 ),
                           _parnl( 4 ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   HARBOUR HB_FUN_WSAGETLASTERROR( PARAMS ) // () --> nError
#else
   CLIPPER WSAGETLAST( PARAMS ) // ERROR() --> nError
#endif
{
  _retni( WSAGetLastError() );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_WSACLEANUP( PARAMS )
#else
    CLIPPER WSACLEANUP( PARAMS )
#endif
{
   _retni( WSACleanup() );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   HARBOUR HB_FUN_GETHOSTNAME( PARAMS ) // () --> cHostName
#else
   CLIPPER GETHOSTNAM( PARAMS ) // E() --> cHostName
#endif
{
   BYTE Name[ 255 ];

   gethostname( ( char * ) Name, 255 );

   _retc( ( char * ) Name );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   HARBOUR HB_FUN_GETHOSTBYADDRESS( PARAMS ) // ( cIPAddress )
#else
   CLIPPER GETHOSTBYA( PARAMS ) // DDRESS( cIPAddress )
#endif
{
   LONG lAddr;
   struct hostent * pHostent;

   if( ISCHAR( 1 ) )
   {
      lAddr = inet_addr( _parc( 1 ) );
      pHostent = gethostbyaddr( ( LPSTR ) &lAddr, 4, PF_INET );
   }
   else
   {
      lAddr = _parnl( 1 );
      pHostent = gethostbyaddr( ( char * ) &lAddr, 4, PF_INET );
   }

   // if( ( int ) pHostent != INADDR_NONE )      // GPF's with some servers with no associated host name
   if( pHostent )                                // Changed by Jorge Mason, www.htcsoft.cl, Sept.2002
      _retc( pHostent->h_name );
   else
      _retc( "Unknown" );                        // changed from "" to "unknown" by LKM
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   HARBOUR HB_FUN_GETHOSTBYNAME( PARAMS ) // ( cName ) --> cIPAddress
#else
   CLIPPER GETHOSTBYN( PARAMS ) // AME( cName ) --> cIPAddress
#endif
{
   struct hostent * pHost;
   BYTE addr[ 20 ];

   strcpy( ( char * ) addr, "0.0.0.0" );

   pHost = gethostbyname( _parc( 1 ) );

   if( pHost )
   {
      wsprintf( ( char * ) addr, "%i.%i.%i.%i",
               ( BYTE ) pHost->h_addr[ 0 ],
               ( BYTE ) pHost->h_addr[ 1 ],
               ( BYTE ) pHost->h_addr[ 2 ],
               ( BYTE ) pHost->h_addr[ 3 ] );
   }

   _retc( ( char * ) addr );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   HARBOUR HB_FUN_GETSERVBYNAME( PARAMS ) // ( cServerName ) --> nPort
#else
   CLIPPER GETSERVBYN( PARAMS ) // AME( cServerName ) --> nPort
#endif
{
   struct servent * pServer;

   pServer = getservbyname( _parc( 1 ), _parc( 2 ) );

   _retnl( IF( pServer, pServer->s_port, 0 ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_HTONS( PARAMS )   // ( nAddress ) --> nAddress
#else
    CLIPPER HTONS( PARAMS )   // ( nAddress ) --> nAddress
#endif
{
   _retnl( htons( _parnl( 1 ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_SOCKET( PARAMS )  // ( nAf, nType, nProtocol ) --> nSocket
#else
    CLIPPER SOCKET( PARAMS )  // ( nAf, nType, nProtocol ) --> nSocket
#endif
{
   _retnl( socket( _parni( 1 ), _parni( 2 ), _parni( 3 ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_BINDTOPORT( PARAMS )   // nSocket, nPort, nAddr1, nAddr2, nAddr3, nAddr4 --> lSuccess
#else
    CLIPPER BINDTOPORT( PARAMS )   // nSocket, nPort, nAddr1, nAddr2, nAddr3, nAddr4 --> lSuccess
#endif
{
   SOCKADDR_IN sa; // sockaddr_in sa;

   _bset( ( char * ) &sa, 0, sizeof( sa ) );

   sa.sin_family       = AF_INET;
   sa.sin_port         = htons( _parni( 2 ) );
/*
   sa.sin_addr.s_net   = _parni( 3 );
   sa.sin_addr.s_host  = _parni( 4 );
   sa.sin_addr.s_lh    = _parni( 5 );
   sa.sin_addr.s_impno = _parni( 6 );
 */
   sa.sin_addr.s_addr  = htonl( INADDR_ANY );

   _retl( bind( _parni( 1 ), ( SOCKADDR * ) &sa, sizeof( sa ) ) == 0 );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_LISTEN( PARAMS )  //  nSocket, nBackLog --> nResult
#else
    CLIPPER LISTEN( PARAMS )  //  nSocket, nBackLog --> nResult
#endif
{
   _retni( listen( _parni( 1 ), _parni( 2 ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_ACCEPT( PARAMS )  //  nSocket --> nResult
#else
    CLIPPER ACCEPT( PARAMS )  //  nSocket --> nResult
#endif
{
   SOCKADDR_IN sa; // sockaddr_in sa;
   int iLen = sizeof( sa );

   sa.sin_family       = AF_INET;
   sa.sin_port         = 0;
   sa.sin_addr.s_net   = 0;
   sa.sin_addr.s_host  = 0;
   sa.sin_addr.s_lh    = 0;
   sa.sin_addr.s_impno = 0;

   _retni( accept( _parni( 1 ), ( SOCKADDR * ) &sa, &iLen ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   HARBOUR HB_FUN_CLOSESOCKET( PARAMS ) // ( nSocket )  --> nResult
#else
   CLIPPER CLOSESOCKE( PARAMS ) // T( nSocket )  --> nResult
#endif
{
   _retni( closesocket( _parni( 1 ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_RECV( PARAMS )  //  nSocket --> cResult
#else
    CLIPPER RECV( PARAMS )  //  nSocket --> cResult
#endif
{
   LPBYTE buffer = ( LPBYTE ) _xgrab( 8192 );
   WORD wLen = recv( _parni( 1 ), ( char * ) buffer, 8192, 0 );

   if( wLen < 10000 )  // socket errors = 10000 + ...
      _storclen( ( char * ) buffer, wLen, 2 );
   else
      _storclen( "", 0, 2 );

   _retni( wLen );
   _xfree( buffer );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_SOCKETSEND( PARAMS )  //  nSocket, cText --> nResult
#else
    CLIPPER SOCKETSEND( PARAMS )  //  nSocket, cText --> nResult
#endif
{
   WORD wLen = _parclen( 2 );

   if( wLen > 32350 )
       wLen = 32350;

   _retni( _send( _parni( 1 ), _parc( 2 ), wLen, 0 ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_SENDBINARY( PARAMS )  //  nSocket, pMemory --> nResult
#else
    CLIPPER SENDBINARY( PARAMS )  //  nSocket, pMemory --> nResult
#endif
{
   WORD wLen = _parnl( 3 );

   if( wLen > 32350 )
       wLen = 32350;

   _retni( _send( _parni( 1 ), ( LPSTR ) _parnl( 2 ), wLen, 0 ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_CONNECTTO( PARAMS )  // nSocket, nPort, cIPAddr --> lSuccess
#else
    CLIPPER CONNECTTO( PARAMS )  // nSocket, nPort, cIPAddr --> lSuccess
#endif
{
   SOCKADDR_IN sa; // sockaddr_in sa;

   _bset( ( char * ) &sa, 0, sizeof( sa ) );

   sa.sin_family      = AF_INET;
   sa.sin_port        = htons( _parni( 2 ) );
   sa.sin_addr.s_addr = inet_addr( _parc( 3 ) );

  _retnl( connect( _parni( 1 ), ( SOCKADDR * ) &sa, sizeof( sa ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_SETSOCKOPT( PARAMS ) //  SOCKET s, int level, int optname, const char FAR * optval, int optlen
#else
    CLIPPER SETSOCKOPT( PARAMS ) //  SOCKET s, int level, int optname, const char FAR * optval, int optlen
#endif
{
   BOOL bTrue = 1;

   _retl( setsockopt( _parni( 1 ), _parni( 2 ), _parni( 3 ),
                      ( char * ) &bTrue, 2 ) == 0 );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   HARBOUR HB_FUN_GETPEERNAME( PARAMS ) // ( nSocket )
#else
   CLIPPER GETPEERNAM( PARAMS ) // E( nSocket )
#endif
{
   SOCKADDR_IN sa; // sockaddr_in sa;
   int iLen = sizeof( sa );

   _bset( ( char * ) &sa, 0, sizeof( sa ) );
   getpeername( _parni( 1 ), ( SOCKADDR * ) &sa, &iLen );
   _retc( inet_ntoa( sa.sin_addr ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   HARBOUR HB_FUN_SOCKETSELECT( PARAMS ) // ( nSocket )
#else
   CLIPPER SOCKETSELE( PARAMS ) // CT( nSocket )
#endif
{
   struct timeval timeout;
   fd_set setWrite;

   FD_ZERO( &setWrite );
   FD_SET( ( /*WORD*/ unsigned int ) _parni( 1 ), &setWrite );
   timeout.tv_sec  = 0;
   timeout.tv_usec = 0;

   // _retl( select( 0, 0, &setWrite, 0, &timeout ) == 0 );
   _retni( select( 0, 0, &setWrite, 0, 0 ) );  // 0 instead &timeout makes wait
}                                                  // for ever.

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_INET_ADDR( PARAMS ) // cIPAddress --> nAddress
#else
    CLIPPER INET_ADDR( PARAMS ) // cIPAddress --> nAddress
#endif
{
   _retnl( inet_addr( _parc( 1 ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_GETPORT( PARAMS ) // nSocket
#else
    CLIPPER GETPORT( PARAMS ) // nSocket
#endif
{
   SOCKADDR_IN sa; // sockaddr_in sa;
   int iLen = sizeof( sa );

   _bset( ( char * ) &sa, 0, sizeof( sa ) );
   getsockname( _parni( 1 ), ( SOCKADDR * ) &sa, &iLen );

   _retni( ntohs( sa.sin_port ) );
}

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
    HARBOUR HB_FUN_GETIP( PARAMS ) // nSocket
#else
    CLIPPER GETIP( PARAMS ) // nSocket
#endif
{
   SOCKADDR_IN sa; // sockaddr_in sa;
   int iLen = sizeof( sa );
   BYTE addr[ 20 ];

   _bset( ( char * ) &sa, 0, sizeof( sa ) );
   getsockname( _parni( 1 ), ( SOCKADDR * ) &sa, &iLen );
   strcpy( ( char * ) addr, "error" );

   wsprintf( ( char * ) addr, "%i.%i.%i.%i",
               ( BYTE ) sa.sin_addr.s_net, ( BYTE ) sa.sin_addr.s_host,
               ( BYTE ) sa.sin_addr.s_lh, ( BYTE ) sa.sin_addr.s_impno );

   _retc( ( char * ) addr );
}

//----------------------------------------------------------------------------//
