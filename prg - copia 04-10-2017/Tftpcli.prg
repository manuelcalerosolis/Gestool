// FiveWin Internet FTP Client Class

#include "FiveWin.Ch"

// different session status

// CONNECT
#define ST_CONNECTING    1
#define ST_IDENTIFY1     2
#define ST_IDENTIFY2     3

// STOR
#define ST_STOR_PORT     "ST_PORT"
#define ST_STOR_OPENCONN "ST_OPENCONN"
#define ST_STOR_START    "ST_START"

#define RCODE_OK         "220"
#define IDENTIFY_OK      "331"
#define LOGIN_OK         "230"
#define ST_NOOP          "ST_NOOP"

//----------------------------------------------------------------------------//

CLASS TFtpClient

   DATA   oSocket     // socket used during the Control session
   DATA   oDataSOcket // Socket used during the transmission data

   DATA   oMultiplex
   DATA   nBasePort   AS NUMERIC INIT 4
   DATA   nPort       AS NUMERIC INIT 1
   DATA   User
   DATA   Pass
   DATA   lOk

   DATA   cIPServer   // IP of the mail server
   DATA   AllOk

   DATA   nStatus     // Temporary session status

   DATA   bConnecting // Action to perform while trying to connect
   DATA   bConnected  // Action to perform when already connected
   DATA   bDone       // Action to perform when Msg has been already sent
   DATA   SrvLastMsg
   DATA   lWaiting
   DATA   lTimeOut
   DATA   nSended

   METHOD New( cIPServer, nPort, User, Pass ) CONSTRUCTOR

   METHOD OnConnect( oSocket )
   METHOD PWD()             INLINE ( ::oSocket:SendData( "PWD" + CRLF ), ::DoWait() ), ::SrvLastMsg
   METHOD CWD( cDirName )   INLINE ( ::oSocket:SendData( "CWD " + cDirName + CRLF ), ::DoWait()), ::SrvLastMsg
   METHOD MKD( cDirName )   INLINE ( ::oSocket:SendData( "MKD " + cDirName + CRLF ), ::DoWait()), ::SrvLastMsg
   METHOD DELE( cFileName ) INLINE ( ::oSocket:SendData( "DELE " + cFileName + CRLF ), ::DoWait()), ::SrvLastMsg
   METHOD QUIT()            INLINE ( ::oSocket:SendData( "QUIT" + CRLF ), ::DoWait() ), ::SrvLastMsg
   METHOD TYPE( cType )     INLINE ( ::oSocket:SendData( "TYPE " + cType + CRLF ), ::DoWait()), ::SrvLastMsg
   METHOD STOR( cFileName )
   METHOD RETR( cFileName )
   METHOD PORT()
   METHOD DoWait()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cIPServer, nPort, User, Pass ) CLASS TFtpClient

   DEFAULT nPort := 21

   ::AllOk      := .f.
   ::cIPServer  := cIPServer
   ::User       := User
   ::Pass       := Pass
   ::nStatus    := ST_CONNECTING
   ::oMultiplex := TCtrlSocket():New()

   ::oSocket := TSocket():New( 21 )

   ::oSocket:bRead = { | o | ::OnConnect( o ) }
   ::oSocket:Connect( ::cIpServer )

return Self

//----------------------------------------------------------------------------//

METHOD PORT( oTransSocket ) CLASS TFtpClient

   local cIp := GetIp( ::oSocket:nSocket )
   local nPort
   local cPort
   local cComplement

   BindToPort( oTransSocket:nSocket, 0 )    // Get a free port from 1024 - 5000

   nPort       := GetPort( oTransSocket:nSocket )
   cPort       := AllTrim( Str( Int( nPort / 256 ), 3 ) )
   cComplement := AllTrim( Str( Int( nPort % 256 ), 3 ) )

return "PORT " + StrTran( AllTrim( StrTran( cIp, ".", "," ) ) + ;
       "," + cPort + "," + cComplement, " ", "" )

//----------------------------------------------------------------------------//

METHOD DoWait() CLASS TFtpClient

   local IniTime := Seconds()

   ::lTimeOut = .f.
   ::lWaiting = .t.
   ::oSocket:bRead = {|| ::SrvLastMsg := ::oSocket:Getdata(),;
                         ::lWaiting := .f. }

   while ::lWaiting
      if Seconds() - IniTime > 30
         ::lTimeOut := .t.
         exit
      endif
      SysRefresh()
   end

return nil

//----------------------------------------------------------------------------//

METHOD STOR( cFileName, bBlock ) CLASS TFtpClient

   local oTransSocket := TSocket():New( 0 )
   local cPort
   local bStor
   local cFName := cFileName

   if At( "\", cFileName ) > 0
      cFName := AllTrim( SubStr( cFileName, At( "\", cFileName ) + 1 ) )
   endif

   cFileName = Alltrim( cFileName )

   ::Type( "I" )
   cPort := ::Port( oTransSocket )

   oTransSocket:bAccept  = { | oTransSocket | ;
      ::oDataSocket := TSocket():Accept( oTransSocket:nSocket),;
      Eval( bStor ) }

   bStor = {|| ::oDataSocket:SetHeader( Nil ),;
               ::oDataSocket:SetFile( cFileName ),;
               ::oDataSocket:oMultiplex := ::oMultiplex,;
               ::oDataSocket:oMultiplex:AddRequest( ::oDataSocket, nil, bBlock ),;
               ::oDataSocket:oMultiplex:ServeClients(),;
               ::DoWait(),;
               oTransSocket:End() }

   oTransSocket:Listen()
   ::oSocket:SendData( cPort+CRLF )
   ::DoWait()
   ::oSocket:SendData( "STOR " + cFName + CRLF )
   ::DoWait()

return nil

//----------------------------------------------------------------------------//

METHOD RETR( cFileName, bBlock ) CLASS TFtpClient

   local oTransSocket := TSocket():New( 0 )
   local cPort
   local bStor
   local cFName := cFileName
   local fHandle
   local LastMsg
   local lOk := .t.

   cFileName = Alltrim( cFileName )

   ::Type("I")
   cPort = ::Port( oTransSocket )

   oTransSocket:bAccept  = { | oTransSocket | ;
      fHandle := FCreate( cFileName ),;
      ::oDataSocket := TSocket():Accept( oTransSocket:nSocket),;
      Eval( bStor ), ::DoWait() }

    bStor = {|| ::oDataSocket:bRead := ( {| oDataSocket | fWrite(fHandle, oDataSocket:GetData()) } ),;
                ::oDataSocket:bClose:= ( {| oDataSocket | FClose( fHandle ), oTransSocket:End() } ) }

   oTransSocket:Listen()
   ::oSocket:SendData( cPort + CRLF )
   ::DoWait()
   ::oSocket:SendData( "RETR " + cFName + CRLF )
   ::DoWait()

   if At( "550", ::SrvLastMsg ) > 0
      lOk = .f.
   endif

return lOk

//----------------------------------------------------------------------------//

METHOD OnConnect( oSocket ) CLASS TFtpClient

   local cData    := oSocket:GetData()
   local rCode    := SubStr( cData, 1, 3 )
   local cMsg     := SubStr( cData, 3 )
   local cCommand := ""

   ::SrvLastMsg := cData

   do case
      case ::nStatus == ST_CONNECTING
           if rCode == RCODE_OK
              cCommand  = "USER " + ::User + CRLF
              ::nStatus = ST_IDENTIFY1
           endif

      case ::nStatus == ST_IDENTIFY1
           if rCode == IDENTIFY_OK
              cCommand  = "PASS " + ::Pass + CRLF
              ::nStatus = ST_IDENTIFY2
           endif

      case ::nStatus == ST_IDENTIFY2
           if rCode == LOGIN_OK
              ::AllOk   = .t.
              ::nStatus = ST_NOOP
           endif
   endcase

   if !Empty( cCommand )
      oSocket:SendData( cCommand )
   endif

return nil

//----------------------------------------------------------------------------//