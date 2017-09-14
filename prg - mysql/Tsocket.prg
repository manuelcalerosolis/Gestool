// FiveWin WinSocket.dll support !!!

#include "FiveWin.ch"
#include "Fileio.ch"

#define AF_INET            2
#define SOCK_STREAM        1

#define IPPROTO_IP         0
#define SOL_SOCKET        -1

#define FD_READ            1
#define FD_WRITE           2
#define FD_OOB             4
#define FD_ACCEPT          8
#define FD_CONNECT        16
#define FD_CLOSE          32

#define SO_REUSEADDR       4

#define FILE_BLOCK     30000

#define WSAEWOULDBLOCK 10035

#ifdef __XPP__
   #define New _New
#endif

//----------------------------------------------------------------------------//

CLASS TSocket

   DATA    nPort    AS NUMERIC INIT  0      // socket port number
   DATA    cIPAddr  AS String  INIT ""      // socket IP address
   DATA    nTimeOut AS NUMERIC INIT 30
   DATA    nBackLog AS NUMERIC INIT  5
   DATA    nSocket  AS NUMERIC INIT -1
   DATA    hFile    AS NUMERIC INIT  0

   DATA    bAccept, bRead, bWrite, bClose, bConnect, bOOB
   DATA    lDebug
   DATA    cLogFile

   DATA    cMsg, nRetCode, Cargo
   DATA    aBuffer                         // data sending buffer
   DATA    lSending                        // sending in progress

   CLASSDATA aSockets INIT {}

   METHOD  New( nPort )  CONSTRUCTOR

   MESSAGE Accept METHOD _Accept( nSocket )

   METHOD  End()

   METHOD  HandleEvent( nSocket, nOperation, nErrorCode )

   METHOD  GetData()

   METHOD  SendBin( pMemory, nSize ) INLINE SendBinary( pMemory, nSize )
   // LKM: added nDelay based on RG idea for smtp servers that "drown" w/o an additional delay
   METHOD  SendChunk( nBlockSize, nDelay )
   METHOD  SendFile( cFileName, nBlockSize, nDelay )

   METHOD  SendData( cData )

   MESSAGE Listen METHOD _Listen()

   METHOD  Close()

   METHOD  Connect( cIPAddr, nPort ) INLINE ;
         ConnectTo( ::nSocket, If( nPort != nil, nPort, ::nPort ), cIPAddr )

   METHOD  Refresh() INLINE SocketSelect( ::nSocket )
   // LKM: added nWSAError as parameter to all On...() methods
   METHOD  OnAccept( nWSAError )  INLINE If( ::bAccept  != nil, Eval( ::bAccept,  Self, nWSAError ),)
   METHOD  OnRead( nWSAError )    INLINE If( ::bRead    != nil, Eval( ::bRead,    Self, nWSAError ),)
   METHOD  OnWrite( nWSAError )   INLINE If( ::bWrite   != nil, Eval( ::bWrite,   Self, nWSAError ),)
   METHOD  OnClose( nWSAError )   INLINE If( ::bClose   != nil, Eval( ::bClose,   Self, nWSAError ),)
   METHOD  OnConnect( nWSAError ) INLINE If( ::bConnect != nil, Eval( ::bConnect, Self, nWSAError ),)
   METHOD  OnOOB( nWSAError )     INLINE If( ::bOOB     != nil, Eval( ::bOOB,     Self, nWSAError ),)  // <newfw25>

   METHOD  ClientIP()  INLINE GetPeerName( ::nSocket )

   METHOD  HidePwd( cData )                      // added by LKM

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nPort ) CLASS TSocket

   local oWndMain

   DEFAULT ::aSockets := {}

   if Len( ::aSockets ) == 0
      if WSAStartup() != 0
         msgStop( "WSAStartup error" )
      endif
   endif

   if ( ::nSocket := Socket( AF_INET, SOCK_STREAM, IPPROTO_IP ) ) == 0
      msgStop( "Socket creation error: " + Str( WsaGetLastError() ) )
   endif

   ::cIPAddr  := GetHostByName( GetHostName() )
   ::aBuffer  := {}
   ::lSending := .f.
   ::lDebug   := .f.

   if nPort != nil
      ::nPort := nPort
      BindToPort( ::nSocket, nPort )  // Bind is not needed for connect sockets
   endif

   AAdd( ::aSockets, Self )

   if ( oWndMain := WndMain() ) != nil
      oWndMain:bSocket := { | nSocket, nLParam | ::HandleEvent( nSocket,;
                              nLoWord( nLParam ), nHiWord( nLParam ) ) }

      WSAAsyncSelect( ::nSocket, oWndMain:hWnd, WM_ASYNCSELECT,;
            nOr( FD_ACCEPT, FD_OOB, FD_READ, FD_CLOSE, FD_CONNECT, FD_WRITE ) )
   else
      msgStop( "You must create a main window in order to use a TSocket object" )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD _Accept( nSocket ) CLASS TSocket

   ::nSocket  := Accept( nSocket )
   ::aBuffer  := {}
   ::lSending := .f.
   ::lDebug   := .f.

   AAdd( ::aSockets, Self )

   WSAAsyncSelect( ::nSocket, WndMain():hWnd, WM_ASYNCSELECT,;
      nOr( FD_ACCEPT, FD_OOB, FD_READ, FD_CLOSE, FD_CONNECT, FD_WRITE ) )

return Self

//----------------------------------------------------------------------------//

METHOD GetData() CLASS TSocket

   local cData := ""

   ::nRetCode := Recv( ::nSocket, @cData )

   if ::lDebug .and. ! Empty( ::cLogFile )
      LogFile( ::cLogFile, { ::HidePwd( cData ) } )
   endif

return cData

//----------------------------------------------------------------------------//

METHOD _Listen() CLASS TSocket

   local nRetCode := Listen( ::nSocket, ::nBackLog )

return ( nRetCode == 0 )

//----------------------------------------------------------------------------//

METHOD End() CLASS TSocket

   local nAt := AScan( ::aSockets, { | oSocket | oSocket:nSocket == ::nSocket } )

   while ::lSending
      SysRefresh()
   end

   if nAt != 0
      ADel( ::aSockets, nAt )
      ASize( ::aSockets, Len( ::aSockets ) - 1 )
      if Len( ::aSockets ) == 0
         WSACleanUp()
      endif
   endif

   if ! Empty( ::nSocket )
      CloseSocket( ::nSocket )
      ::nSocket := 0
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Close() CLASS TSocket

   while ::lSending
      SysRefresh()
   end

return CloseSocket( ::nSocket )

//----------------------------------------------------------------------------//
// LKM: added nErrorCode (the WSA errors) as param to all On...() methods; added info to LogFile()
METHOD HandleEvent( nSocket, nOperation, nErrorCode ) CLASS TSocket

   local nAt := AScan( ::aSockets, { | oSocket | oSocket:nSocket == nSocket } )
   local oSocket

   if nAt != 0
      oSocket := ::aSockets[ nAt ]

      do case
         case nOperation == FD_ACCEPT
              if ::lDebug .and. ! Empty( ::cLogFile )
                 LogFile( ::cLogFile, { "Accept ",;
                          "Socket handle:" + Str( nSocket ),;
                          "WSA Error:" + Str( nErrorCode ) } )
              endif
              oSocket:OnAccept( nErrorCode )

         case nOperation == FD_READ
              if ::lDebug .and. ! Empty( ::cLogFile )
                 LogFile( ::cLogFile, { "Read   ",;
                          "Socket handle:" + Str( nSocket ),;
                          "WSA Error:" + Str( nErrorCode ) } )
              endif
              oSocket:OnRead( nErrorCode )

         case nOperation == FD_WRITE
              if ::lDebug .and. ! Empty( ::cLogFile )
                 LogFile( ::cLogFile, { "Write  ",;
                          "Socket handle:" + Str( nSocket ),;
                          "WSA Error:" + Str( nErrorCode ) } )
              endif
              oSocket:OnWrite( nErrorCode )

         case nOperation == FD_CLOSE
              if ::lDebug .and. ! Empty( ::cLogFile )
                 LogFile( ::cLogFile, { "Close  ",;
                          "Socket handle:" + Str( nSocket ),;
                          "WSA Error:" + Str( nErrorCode ) } )
              endif
              oSocket:OnClose( nErrorCode )

         case nOperation == FD_CONNECT
              if ::lDebug .and. ! Empty( ::cLogFile )
                 LogFile( ::cLogFile, { "Connect",;
                          "Socket handle:" + Str( nSocket ),;
                          "WSA Error:" + Str( nErrorCode ) } )
              endif
              oSocket:OnConnect( nErrorCode )

         case nOperation == FD_OOB
              if ::lDebug .and. ! Empty( ::cLogFile )
                 LogFile( ::cLogFile, { "OOB    ",;
                          "Socket handle:" + Str( nSocket ),;
                          "WSA Error:" + Str( nErrorCode ) } )
              endif
              oSocket:OnOOB( nErrorCode )

         otherwise
              if ::lDebug .and. ! Empty( ::cLogFile )
                 LogFile( ::cLogFile, { "nOperation not recognized",;
                          Str( nOperation ),;
                          "Socket handle:" + Str( nSocket ),;
                          "WSA Error:" + Str( nErrorCode ) } )
              endif
      endcase
   endif

return nil

//----------------------------------------------------------------------------//
// LKM: added nDelay based on RG idea for smtp servers that "drown" w/o an additional delay
METHOD SendChunk( nBlockSize, nDelay ) CLASS TSocket

   local cBuffer, nBytes := 0

   DEFAULT nBlockSize := FILE_BLOCK, nDelay := 0

   cBuffer := Space( nBlockSize )

   if ::hFile != 0
      nBytes := FRead( ::hFile, @cBuffer, nBlockSize )
      if nBytes < nBlockSize
         cBuffer := SubStr( cBuffer, 1, nBytes )
         FClose( ::hFile )
         ::hFile := 0
      endif

      ::SendData( cBuffer )
      If nDelay > 0                              // Sep/28/2002 LKM based on RG idea
         SysWait( nDelay )                       // recomended values 0.1 to 1.0
      Endif
   end

return nBytes

//----------------------------------------------------------------------------//

METHOD SendFile( cFileName, nBlockSize, nDelay ) CLASS TSocket

   DEFAULT nBlockSize := FILE_BLOCK

   if ! Empty( cFileName ) .and. File( cFileName )
      If( ( ::hFile := FOpen( cFileName, FO_SHARED ) ) != -1 )  // IVT shared para poder abrirlo muchas veces
         while ::SendChunk( nBlockSize, nDelay ) == nBlockSize
         end
      endif
   endif

return nil

//----------------------------------------------------------------------------//
// LKM: update ::nRetCode to trap timeouts
METHOD SendData( cData ) CLASS TSocket

   local nSize := Len( cData )
   local nLen  := nSize
   local nSent := 0

   if ! ::lSending
      ::lSending := .t.
   else
      AAdd( ::aBuffer, cData )
      return nSize
   endif

   while ( nLen > 0 .and. ;
           ( nSent := SocketSend( ::nSocket, cData ) ) < nLen ) .or. ;
         Len( ::aBuffer ) > 0
      if ::lDebug .and. ! Empty( ::cLogFile )
         LogFile( ::cLogFile, { "Sent:", nSent, "Len:", Len( cData ), "Buffer Len:", Len( ::aBuffer ) } )
      endif
      // Check for buffered packets to send
      if nLen == 0 .and. Len( ::aBuffer ) > 0
         cData := ::aBuffer[ 1 ]
         ADel( ::aBuffer, 1 )
         ASize( ::aBuffer, Len( ::aBuffer ) - 1 )
      endif
      ::nRetCode := nSent                        // added by lkm to trap timeout error (increment nDelay by one and try again)
      if nSent != -1
         cData := SubStr( cData, nSent + 1 )
         nLen  := Len( cData )
      else
         if WSAGetLastError() != WSAEWOULDBLOCK
            exit
         endif
      endif
      SysRefresh()
   end

   if ::lDebug .and. ! Empty( ::cLogFile )
      LogFile( ::cLogFile, { ::HidePwd( cData ) } )
   endif

   ::lSending := .f.

return nSize

//----------------------------------------------------------------------------//
// LKM
METHOD HidePwd( cData ) CLASS TSocket

   Local nPwd

   If ( nPwd := At( "PASS ", cData ) ) > 0
      cData := SubStr( cData, 1, nPwd + 4 ) + Replicate( "*", Len( SubStr( cData, nPwd + 5 ) ) )
   Endif

Return cData

//----------------------------------------------------------------------------//
