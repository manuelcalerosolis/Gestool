// FYI, you must set cServer, cUser, and cPassword for this to work

#include "FiveWin.Ch"
#include "common.ch"
#include "qftp.ch"
#define BLOCK_SIZE 10240

CLASS qFTPClient

  DATA oSocket, oTrnSocket  AS OBJECT INIT nil

  DATA cServer, cServerIP, cUser, cPass, cBuffer, ;
     cLastCmd, cReply, cDirBuffer, cDataIP  AS CHARACTER INIT ""

  DATA nPort, nDataPort AS NUMERIC INIT 21

  DATA nStatus, nRetrHandle AS NUMERIC INIT 0

  DATA bResolving, bResolved, bDump, bAbort, bStorProg AS Codeblock init nil

  DATA lResolved, lConnected, lClosed, lSent, ;
     lSendFile, lPassive, lSentUser AS Logical Init .F.

  DATA acDir, acReply, acAllReply AS Array

  DATA nRetrFSize, nRetrBRead AS NUMERIC INIT 0

  Method New(pcServer, pnPort, pbDump, bAbort, pcUser, pcPass)    Constructor
  /*
   Creates FTP Object
   Parameters : pcServer  : Servername e.g. ftp.microsoft.com or 207.46.133.140
                pnPort    : Server FTP Port. Defaults to 21
                pbDump    : Codeblock to send all commands sent, and replies received to. Useful for logging, etc.
                bAbort    : Codeblock, which if eval's to True, will abort any current waiting process.
                pcUser    : User name to log-in with
                pcPass    : Password to log-in with
  */

  Method End
  Method Connect
  /*
   Logs into the FTP Server, using parameters specified with New Method.
   Returns True or False based on connection success
  */
  Method OnConnect
  /*
   Internal method to handle connection established. Note it only checks
   for a bad connection. The rest is done by OnRead
  */
  Method OnRead
  /*
   Internal method to handle data received by control socket
  */
  Method OnClose
  /*
   Internal method to handle socket closed by server
  */
  Method Port
  /*
   Internal method to obtain unused port no for data connections.
  */
  Method Cd(pcPath)
  /*
   Change directory on FTP Server.
   Returns True or False based on success
  */
  Method Pwd
  /*
   Get current directory on FTP Server
   Returns True or False based on success
  */
  Method XfrType(pcType)
  /*
   Used internally to set Binary transfer mode for transfers
  */
  Method Stor(pcLocal, pcRemote, pbStorProg, oMeter)
  /*
   Used to store files on server.
   Parameters : pcLocal     : Local File to send
                pcRemote    : Location to store file remotely
                pbStorProg  : Codeblock to get percent complete
   Returns True or False based on success
   */
  Method StorAccept(pSocket, pcFile, oMeter)
  /*
   Internal method to manage file store socket
  */
  Method StorClose(poSocket)
  /*
   Internal method to manage file store socket
  */
  Method Dir(pcLoc)
  /*
   Used to get directory listing.
   pcLoc Parameter gives dir spec.
   Returns true or false based on success
   When True. Data var acDir will hold dir listing as returned by server.
  */
  Method DirAccept(pSocket)
  /*
   Internal method to manage directory socket
  */
  Method DirRead(poSocket)
  /*
   Internal method to manage directory socket
  */
  Method DirClose(poSocket)
  /*
   Internal method to manage directory socket
  */
  Method Dump(pcMsg)
  /*
   Internal method to give feedback to caller
  */
  Method Quit()
  /*
   Close FTP Connection
  */
  Method DoWait(pnState)
  /*
   Internal method to wait for responses from server.
  */
  Method Del(pcFile)
  /*
   Delete file (pcFile of server)
   Will return Success True or False
  */
  Method Rename(pcFrom, pcTo)
  /*
   Rename file on server
   Parameters : pcFrom  : Source file
                pcTo    : Target file
   Will return Success True or False
  */
  Method MkDir(pcDir)
  /*
   Create a directory
  */
  Method RmDir(pcDir)
  /*
   Removed a directory
  */
  Method Retr(pcRemote, pcLocal, nRetrFsize, oMeter)
  /*
   Retrieve file from server.
   Parameters : pcRemote  : Remote file name
                pcLocal   : Local file name
  */
  Method RetrAccept(pSocket,oMeter)
  /*
   Internal method to manage file retrieval socket
  */
  Method RetrRead(poSocket,oMeter)
  /*
   Internal method to manage file retrieval socket
  */
  Method RetrClose(poSocket,oMeter)
  /*
   Internal method to manage file retrieval socket
  */
  Method Abort()
  /*
   Cancel any transfer/command in progress.
   Called by class if bAbort block evals to true in wait state.
  */
  Method Pasv()
  /*
   Switch next transfer to passive mode
  */
EndClass

//---------------------------------------------------------------------------------------------//

Method New(pcServer, pnPort, pbDump, bAbort, pcUser, pcPass) CLASS qFTPClient
  /*
   Creates FTP Object
   Parameters : pcServer  : Servername e.g. ftp.microsoft.com or 207.46.133.140
                pnPort    : Server FTP Port. Defaults to 21
                pbDump    : Codeblock to send all commands sent, and replies received to. Useful for logging, etc.
                bAbort    : Codeblock, which if eval's to True, will abort any current waiting process.
                pcUser    : User name to log-in with
                pcPass    : Password to log-in with
  */

  DEFAULT pcServer := "server01"
  DEFAULT pnPort := 21
  DEFAULT bAbort := {|| .f.}
  DEFAULT pcUser := "utftp"
  DEFAULT pcPass  := "triusis"
  ::cServer    := pcServer
  ::nPort      := pnPort
  ::bAbort     := bAbort
  ::bDump      := pbDump

  ::acDir      := {}
  ::acReply    := {}
  ::acAllReply := {}

  ::cUser      := pcUser
  ::cPass      := pcPass
return Self

//---------------------------------------------------------------------------------------------//

Method Dump(pcMsg) CLASS qFTPClient
  if ValType(::bDump) == "B" .and. ValType(pcMsg) == "C"
    Eval(::bDump, pcMsg)
  else
    MsgInfo( pcMsg )
  endif
return nil

//---------------------------------------------------------------------------------------------//

Method Connect() CLASS qFTPClient
  local nReturn
  LOCAL lOK     := .t.
  ::lResolved := .F.
  ::oSocket := TSocket():New(0)
  if Val(::cServer) > 0
    ::cServerIP := ::cServer
    if ValType(::bResolved) == "B"
      Eval(::bResolved, Self)
    endif
    ::lResolved := .T.
  else
    if ValType(::bResolving) == "B"
      Eval(::bResolving, Self)
    endif
    ::lResolved := .f.
    ::cServerIP := GetHostByName(Alltrim(::cServer))  // PK Note this hogs the pc for up to 35 seconds if it cannot be resolved
    if Val(::cServerIP) == 0
      //msgStop("Could not resolve server name '" + ::cServer + "'", ::cTitle)
    else
      if ValType(::bResolved) == "B"
        Eval(::bResolved, Self)
      endif
      ::lResolved := .T.
    endif
  endif
  if ::lResolved
    ::oSocket:bConnect := {|oSocket| ::OnConnect(oSocket)}
    ::oSocket:bRead    := {|oSocket| ::OnRead(oSocket)}
    ::oSocket:bClose   := {|oSocket| ::OnClose(oSocket)}
    ::nStatus := ST_CONNECTING
    ::oSocket:Connect(::cServerIP, ::nPort)
    ::DoWait(ST_CONNECTING)
    lOK := ::nStatus == ST_CONNECTED
  endif
return lOk

//---------------------------------------------------------------------------------------------//

Method OnConnect(poSocket) CLASS qFTPClient
  If Val(poSocket:ClientIP()) == 0
    ::lConnected := .F.
    ::nStatus := ST_CONNECTERR
  endif
return nil

//---------------------------------------------------------------------------------------------//

Method OnRead(poSocket) CLASS qFTPClient
   local cData := ""
   local nPos  := 0
   local cCmd  := ""
   local aDesc := {}
   local aCodes := {}

   aadd( aDesc, "ST_CLOSED     " ); aadd( aCodes, 0 )
   aadd( aDesc, "ST_CONNECTING " ); aadd( aCodes, 1 )
   aadd( aDesc, "ST_CONNECTED  " ); aadd( aCodes, 2 )
   aadd( aDesc, "ST_CONNECTERR " ); aadd( aCodes, 3 )

   aadd( aDesc, "ST_DOCWD      " ); aadd( aCodes, 4 )
   aadd( aDesc, "ST_DONECWD    " ); aadd( aCodes, 5 )
   aadd( aDesc, "ST_CWDERROR   " ); aadd( aCodes, 6 )

   aadd( aDesc, "ST_DOTYPE     " ); aadd( aCodes, 7 )
   aadd( aDesc, "ST_TYPEOK     " ); aadd( aCodes, 8 )
   aadd( aDesc, "ST_TYPEBAD    " ); aadd( aCodes, 9 )

   aadd( aDesc, "ST_DOPORT     " ); aadd( aCodes, 0 )
   aadd( aDesc, "ST_PORTOK     " ); aadd( aCodes, 1 )
   aadd( aDesc, "ST_PORTBAD    " ); aadd( aCodes, 2 )

   aadd( aDesc, "ST_DOSTOR     " ); aadd( aCodes, 3 )
   aadd( aDesc, "ST_STOROK     " ); aadd( aCodes, 4 )
   aadd( aDesc, "ST_STORBAD    " ); aadd( aCodes, 5 )
   aadd( aDesc, "ST_STORDONE   " ); aadd( aCodes, 6 )

   aadd( aDesc, "ST_DOPASV     " ); aadd( aCodes, 7 )
   aadd( aDesc, "ST_PASVOK     " ); aadd( aCodes, 8 )
   aadd( aDesc, "ST_PASVBAD    " ); aadd( aCodes, 9 )

   aadd( aDesc, "ST_DOQUIT     " ); aadd( aCodes, 0 )
   aadd( aDesc, "ST_QUITOK     " ); aadd( aCodes, 1 )
   aadd( aDesc, "ST_QUITBAD    " ); aadd( aCodes, 2 )

   aadd( aDesc, "ST_DODIR      " ); aadd( aCodes, 3 )
   aadd( aDesc, "ST_DIROK      " ); aadd( aCodes, 4 )
   aadd( aDesc, "ST_DIRBAD     " ); aadd( aCodes, 5 )
   aadd( aDesc, "ST_DIRDONE    " ); aadd( aCodes, 6 )
   aadd( aDesc, "ST_DIRREADY   " ); aadd( aCodes, 2 )

   aadd( aDesc, "ST_DOPWD      " ); aadd( aCodes, 7 )
   aadd( aDesc, "ST_DONEPWD    " ); aadd( aCodes, 8 )
   aadd( aDesc, "ST_PWDERROR   " ); aadd( aCodes, 9 )

   aadd( aDesc, "ST_DORENFROM  " ); aadd( aCodes, 0 )
   aadd( aDesc, "ST_RENFROMOK  " ); aadd( aCodes, 1 )
   aadd( aDesc, "ST_RENFROMBAD " ); aadd( aCodes, 2 )
   aadd( aDesc, "ST_DORENTO    " ); aadd( aCodes, 3 )
   aadd( aDesc, "ST_RENTOOK    " ); aadd( aCodes, 4 )
   aadd( aDesc, "ST_RENTOBAD   " ); aadd( aCodes, 5 )

   aadd( aDesc, "ST_DODELETE   " ); aadd( aCodes, 6 )
   aadd( aDesc, "ST_DELETEOK   " ); aadd( aCodes, 7 )
   aadd( aDesc, "ST_DELETEBAD  " ); aadd( aCodes, 8 )

   aadd( aDesc, "ST_DOMKDIR    " ); aadd( aCodes, 9 )
   aadd( aDesc, "ST_MKDIROK    " ); aadd( aCodes, 0 )
   aadd( aDesc, "ST_MKDIRBAD   " ); aadd( aCodes, 1 )

   aadd( aDesc, "ST_DORETR     " ); aadd( aCodes, 2 )
   aadd( aDesc, "ST_RETROK     " ); aadd( aCodes, 3 )
   aadd( aDesc, "ST_RETRBAD    " ); aadd( aCodes, 4 )
   aadd( aDesc, "ST_RETRDONE   " ); aadd( aCodes, 5 )

   aadd( aDesc, "ST_DOABOR     " ); aadd( aCodes, 6 )
   aadd( aDesc, "ST_ABOROK     " ); aadd( aCodes, 7 )
   aadd( aDesc, "ST_ABORBAD    " ); aadd( aCodes, 8 )

   aadd( aDesc, "ST_DORMDIR    " ); aadd( aCodes, 9 )
   aadd( aDesc, "ST_RMDIROK    " ); aadd( aCodes, 0 )
   aadd( aDesc, "ST_RMDIRBAD   " ); aadd( aCodes, 1 )

   cData := poSocket:GetData()
   ::cBuffer += cData
   nPos := At( CRLF, ::cBuffer )
   do while nPos > 0 .and. !eval( ::bAbort )
      AAdd( ::acReply   , Left( ::cBuffer, nPos - 1 ) )
      AAdd( ::acAllReply, Left( ::cBuffer, nPos - 1 ) )
      ::cBuffer := Substr( ::cBuffer, nPos + 2 )
      nPos := At( CRLF, ::cBuffer )
   Enddo

   If Len( ::acReply ) > 0
      cCmd := Left( ::acReply[ 1 ], 3 )
     else
      cCmd := "zzz"
   endif

   nPos := Ascan( ::acReply, { |cReply| Left( cReply, 4 ) == cCmd + " " } )

   If nPos > 0
      // Full reply received
      // Aeval(::acReply, {| cReply | ::Dump("R:" + NTRIM(::nStatus) + ":" + cReply)})
      Aeval( ::acReply, { |cReply| ::Dump( "R:" + CodeDesc( aDesc, aCodes, ::nStatus ) + ":" + cReply ) } )
      ::cReply := ATail( ::acReply )
      cCmd := Left( ::acReply[ 1 ], 3 )
      ::acReply := {}
      Do Case
         Case ::nStatus == ST_CONNECTING
         Do Case
            Case cCmd == "220"
            // Ready for user
               poSocket:SendData( "USER " + Alltrim( ::cUser ) + CRLF )
              ::Dump( "S:USER " + Alltrim( ::cUser ) )
              ::lSentUser := .t.
            Case cCmd == "331"
              poSocket:SendData( "PASS " + Alltrim( ::cPass ) + CRLF )
              ::Dump( "S:PASS *****" )
            Case cCmd == "230"
              ::nStatus := ST_CONNECTED
              ::lConnected := .T.
            Otherwise
              ::nStatus := ST_CONNECTERR
         EndCase
        Case ::nStatus == ST_DOCWD
         Do Case
            Case cCmd == "250" // OK
              ::nStatus := ST_DONECWD
            Otherwise
              ::nStatus := ST_CWDERROR
         EndCase
        Case ::nStatus == ST_DOQUIT
         Do Case
            Case cCmd == "221"
              ::nStatus := ST_QUITOK
              ::lConnected := .f.
            Otherwise
              ::nStatus := ST_QUITBAD
          EndCase
         Case ::nStatus == ST_DODELETE
          Do Case
             Case cCmd == "250" // OK
               ::nStatus := ST_DELETEOK
             Otherwise
               ::nStatus := ST_DELETEBAD
          EndCase
         Case ::nStatus == ST_DOPWD
          Do Case
             Case cCmd == "257" // OK
               ::nStatus := ST_DONEPWD
             Otherwise
               ::nStatus := ST_PWDERROR
          EndCase
         Case ::nStatus == ST_DOPORT
          Do Case
             Case cCmd == "200" // OK
               ::nStatus := ST_PORTOK
             Otherwise
               ::nStatus := ST_PORTBAD
          EndCase
         Case ::nStatus == ST_DOTYPE
          Do Case
             Case cCmd == "200" // OK
               ::nStatus := ST_TYPEOK
             Otherwise
               ::nStatus := ST_TYPEBAD
          EndCase
         Case ::nStatus == ST_DOSTOR
          Do Case
             Case cCmd == "150"
               ::nStatus := ST_STOROK
               ::lSendFile := .t.
             Otherwise
               ::nStatus := ST_STORBAD
          EndCase
         Case ::nStatus == ST_STOROK
          Do Case
             Case cCmd == "226" // OK
               ::nStatus := ST_STORDONE
             Otherwise
               ::nStatus := ST_STORBAD
          EndCase
         Case ::nStatus == ST_DOPASV
          Do Case
             Case cCmd == "227" // OK
               ::nStatus := ST_PASVOK
             Otherwise
               ::nStatus := ST_PASVBAD
          EndCase
         Case ::nStatus == ST_DODIR
          Do Case
             Case cCmd == "150"
               ::nStatus := ST_DIROK
             Otherwise
               ::nStatus := ST_DIRBAD
          EndCase
         Case ::nStatus == ST_DIROK .or. ::nStatus == ST_DIRREADY
          Do Case
             Case cCmd == "226"
               ::nStatus := ST_DIRDONE
             Otherwise
               ::nStatus := ST_DIRBAD
          EndCase
         Case ::nStatus == ST_DORETR
          Do Case
             Case cCmd == "150"
               ::nStatus := ST_RETROK
             Otherwise
               ::nStatus := ST_RETRBAD
          EndCase
         Case ::nStatus == ST_RETROK
          Do Case
             Case cCmd == "226"
               ::nStatus := ST_RETRDONE
             Otherwise
               ::nStatus := ST_RETRBAD
          EndCase
         Case ::nStatus == ST_DORENFROM
          Do Case
             Case cCmd == "350"
               ::nStatus := ST_RENFROMOK
             Otherwise
               ::nStatus := ST_RENFROMBAD
          EndCase
         Case ::nStatus == ST_DORENTO
          Do Case
             Case cCmd == "250"
               ::nStatus := ST_RENTOOK
             Otherwise
               ::nStatus := ST_RENTOBAD
          EndCase
         Case ::nStatus == ST_DOQUIT
          Do Case
             Case cCmd == "221" // OK
               ::nStatus := ST_QUITOK
             Otherwise
               ::nStatus := ST_QUITBAD
          EndCase
         Case ::nStatus == ST_DOMKDIR
          Do Case
             Case cCmd == "257" // OK
               ::nStatus := ST_MKDIROK
             Otherwise
               ::nStatus := ST_MKDIRBAD
          EndCase
         Case ::nStatus == ST_DOABOR
          Do Case
             Case cCmd  == "225" // OK
               ::nStatus := ST_ABOROK
             Otherwise
               ::nStatus := ST_ABORBAD
          EndCase
         Case ::nStatus == ST_DORMDIR
          Do Case
             Case cCmd == "250" // OK
               ::nStatus := ST_RMDIROK
             Otherwise
               ::nStatus := ST_RMDIRBAD
          EndCase
         Case cCmd == "530"
          ::lConnected := .f.
         Otherwise
          ::Dump( "E:Unknown exception on cmd " + cCmd + " status " + NTRIM( ::nStatus ) )
          // B Hopp, 08/10/2001
          ::Dump( "E:All replys from server follow..." )
          ::Dump(" ")
          FOR nI := 1 TO LEN( ::acAllReply )
            ::Dump("E:" + ::acAllReply[nI])
          NEXT
      EndCase
      nPos := At(CRLF, ::cBuffer)
   Endif
return nil

//---------------------------------------------------------------------------------------------//

Method Dir(pcLoc) CLASS qFTPClient
  local lOK       := .t.
  local cPort     := ""
  local nPos      := 0
  local cLine     := ""
  local cSepChar := ""
  DEFAULT pcLoc TO ""

  ::acDir := {}
  ::cDirBuffer := ""

  ::oTrnSocket := TSocket():New(0)

  if !::lPassive
    cPort := ::Port(::oTrnSocket)

    ::oTrnSocket:bAccept := { | poSocket | ::DirAccept(poSocket:nSocket)}
    ::oTrnSocket:Listen()

    ::Dump("I:Listening on port " + NTRIM(::oTrnSocket:nPort))

    ::nStatus := ST_DOPORT
    ::Dump("S:" + cPort)

    ::oSocket:SendData(cPort + CRLF)

    Do While ::nStatus == ST_DOPORT .and. !::lClosed .and. !Eval(::bAbort)
      SysRefresh()
    Enddo

    if ::nStatus <> ST_PORTOK
      ::Dump("737 from byron")
      lOK := .f.
    endif
  else
    if ::Pasv()
      if ::nDataPort > 0
        ::oTrnSocket:bConnect := { | poSocket | ::DirAccept(poSocket)}
        ::oTrnSocket:bRead   := { | poSocket | ::DirRead  (poSocket)}
        ::oTrnSocket:bClose  := { | poSocket | ::DirClose (poSocket)}
        ::Dump("I:Connecting on ip:port " + ::cDataIP + ":" + NTRIM(::nDataPort))
        ::oTrnSocket:Connect(::cDataIP, ::nDataPort)

        lOK := .t.
      else
        ::Dump("751 from byron")
        lOK := .f.
      endif
    endif
  endif

  if lOK
    ::nStatus := ST_DODIR
    ::Dump("S:" + RTrim("LIST " + pcLoc) + CRLF)

    ::oSocket:SendData(RTrim("LIST " + pcLoc) + CRLF)
    ::DoWait(ST_DODIR)
    ::DoWait(ST_DIROK)

    if ::nStatus == ST_DIRDONE .or. ::nStatus == ST_DIRREADY
      ::DoWait(ST_DIRDONE)
      if ::nStatus == ST_DIRREADY
        ::Dump("I:Interpreting dir listing.")
        cSepChar := CRLF
        nPos := At(cSepChar, ::cDirBuffer)
        If nPos == 0
          cSepChar := Chr(10)
        Endif
        ::acDir := {}
        Do While nPos > 0 .and. !Eval(::bAbort)

          cLine := Alltrim(Left(::cDirBuffer, nPos - 1))
          ::cDirBuffer := Substr(::cDirBuffer, nPos + Len(cSepChar))
          cLine := Alltrim(StrTran(cLine, Chr(0), ""))

          AAdd(::acDir, cLine)

          nPos := At(cSepChar, ::cDirBuffer)
          SysRefresh()
        Enddo
      else
      ::Dump("791 from byron")
        lOK := .f.
        ::Abort()
        ::oTrnSocket:End()
      endif
    else
      ::Dump("797 from byron")
      lOK := .f.
      ::Abort()
      ::oTrnSocket:End()
    endif
  endif
return lOK

//---------------------------------------------------------------------------------------------//

Method DirAccept(pSocket) CLASS qFTPClient
  local oSocket
  if !::lPassive
    oSocket := TSocket():Accept(pSocket)
    oSocket:bRead   := { | poSocket | ::DirRead  (poSocket)}
    oSocket:bClose  := { | poSocket | ::DirClose (poSocket)}
  endif
  ::Dump("I:Dir data connection established")
return nil

//---------------------------------------------------------------------------------------------//

Method DirRead(poSocket) CLASS qFTPClient
  local cData := poSocket:GetData()
  ::cDirBuffer += cData
  ::Dump("I:Dir data received")
return nil

//---------------------------------------------------------------------------------------------//

Method DirClose(poSocket) CLASS qFTPClient
  ::Dump("I:Dir Data Socket closed")
  ::nStatus := ST_DIRREADY
  ::Dump("R:" + CRLF + ::cDirBuffer)
  poSocket:Close()
return nil

//---------------------------------------------------------------------------------------------//

Method OnClose(poSocket) CLASS qFTPClient
  ::Dump("I:Server closed down")
  ::lClosed := .T.
  ::nStatus := ST_CLOSED
  ::oSocket:Close()
  If ValType(::oTrnSocket) == "O"
    ::oTrnSocket:Close()
  endif
return nil

//---------------------------------------------------------------------------------------------//

Method End() CLASS qFTPClient
  ::oSocket:End()
  If ValType(::oTrnSocket) == "O"
    ::oTrnSocket:End()
  endif
return nil

//---------------------------------------------------------------------------------------------//

METHOD PORT( oTransSocket ) CLASS qFtpClient
   local cIp := GetIp( ::oSocket:nSocket )
   local nPort
   local cPort
   local cComplement

   BindToPort( oTransSocket:nSocket, 0 )    // Get a free port from 1024 - 5000

   nPort       := GetPort( oTransSocket:nSocket )
   cPort       := AllTrim( Str( Int( nPort / 256 ), 3 ) )
   cComplement := AllTrim( Str( Int( nPort % 256 ), 3 ) )

   oTransSocket:nPort := nPort

return ("PORT " + StrTran( AllTrim( StrTran( cIp, ".", "," ) ) + ;
       "," + cPort + "," + cComplement, " ", "" ))

//---------------------------------------------------------------------------------------------//

Method Cd(pcPath) CLASS qFTPClient
  local lOK := .t.
  ::nStatus := ST_DOCWD
  ::oSocket:SendData("CWD " + pcPath + CRLF)
  ::Dump("S:CWD " + pcPath)
  ::DoWait(ST_DOCWD)
  lOK := ::nStatus == ST_DONECWD
return lOK

//---------------------------------------------------------------------------------------------//

Method XfrType(pcType) CLASS qFTPClient
  local lOK := .t.
  DEFAULT pcType := "I"
  ::nStatus := ST_DOTYPE
  ::oSocket:SendData("TYPE " + pcType + CRLF)
  ::Dump("S:TYPE " + pcType)
  ::DoWait(ST_DOTYPE)
  lOK := ::nStatus == ST_TYPEOK
return lOK

//---------------------------------------------------------------------------------------------//

Method Stor( pcLocal, pcRemote, pbStorProgress, oMeter) CLASS qFTPClient

  local cRemFile  := ""
  local nPos      := 0
  local cPort     := ""
  local lOK       := .t.

  DEFAULT pcRemote TO ""
  DEFAULT pbStorProgress TO {|| nil}

  msginfo( pcLocal )
  msginfo( pcRemote )

  ::bStorProg := pbStorProgress
  ::lSendFile := False
  if Empty(pcRemote)
    if (nPos := RAt('\', pcLocal)) > 0
      cRemFile := Substr(pcLocal, nPos + 1)
    else
      cRemFile := pcLocal
    endif
  else
    cRemFile := pcRemote
  endif

msginfo( "hola" )
  if lOK
    msginfo( "Entro" )
    msginfo( !::lClosed )
    msginfo( !Eval(::bAbort) )

    ::XfrType("I")
    msginfo( ::nStatus, "Status" )
    Do While ::nStatus == ST_DOTYPE .and. !::lClosed .and. !Eval(::bAbort)
      SysRefresh()
    Enddo
    if ::nStatus <> ST_TYPEOK
      lOK := False
    endif
  endif

  if lOK
msginfo( 1 )
    ::oTrnSocket := TSocket():New(0)
msginfo( 2 )
    if !::lPassive
msginfo( 3 )
      cPort := ::Port(::oTrnSocket)
msginfo( 4 )
      ::oTrnSocket:bAccept := { | poSocket | ::StorAccept(poSocket:nSocket, pcLocal,oMeter)}
msginfo( 5 )
      ::oTrnSocket:Listen()
msginfo( 6 )
      ::Dump("I:Listening on port " + NTRIM(::oTrnSocket:nPort))
msginfo( 7 )

      ::nStatus := ST_DOPORT
msginfo( 8 )

      ::oSocket:SendData(cPort + CRLF)
msginfo( 9 )
      ::Dump("S:" + cPort)
msginfo( 10 )
      Do While ::nStatus == ST_DOPORT .and. !::lClosed .and. !Eval(::bAbort)
        SysRefresh()
      Enddo
msginfo( 11 )

      if ::nStatus <> ST_PORTOK
        lOK := False
      endif
    else
      if ::Pasv()
        if ::nDataPort > 0
          ::oTrnSocket:bConnect := { | poSocket | ::StorAccept(poSocket, pcLocal, oMeter)}
          ::oTrnSocket:bClose  := { | poSocket | ::StorClose (poSocket, oMeter)}
          ::Dump("I:Connecting on ip:port " + ::cDataIP + ":" + NTRIM(::nDataPort))
          ::oTrnSocket:Connect(::cDataIP, ::nDataPort)

          lOK := True
        else
          lOK := False
        endif
      endif
    endif
  endif
  if lOk
    ::nStatus := ST_DOSTOR
    ::Dump("S:STOR " + cRemFile)
    ::oSocket:SendData("STOR " + cRemFile + CRLF)

    ::DoWait(ST_DOSTOR)
    ::DoWait(ST_STOROK)

    if ::nStatus <> ST_STORDONE
      lOK := False
      ::Abort()
      ::oTrnSocket:End()
    endif
  endif
return lOK

//---------------------------------------------------------------------------------------------//

Method StorAccept(pSocket, pcFile, oMeter) CLASS qFTPClient
  local oSocket := NIL
  local hFile   := 0
  local cBuffer := ""
  local nSent   := 0
  local nTotal  := 0
  local lClosed := False
  local nNow      := 0
  local nSize

  IF !::lPassive
     oSocket := TSocket():Accept(pSocket)
     oSocket:bClose  := {| poSocket | ::StorClose(poSocket), lClosed := True}
  else
    oSocket := pSocket
  Endif
  Do While !::lSendFile .and. !::lClosed .and. !Eval(::bAbort)
    SysRefresh()
  Enddo
  if ::lSendfile
    ::Dump("I:Store data connection established")

    nNow := Seconds()
    hFile := FOpen(pcFile)
    if hFile > 0
      nSize := Directory(pcFile)[1,2]
      Do While True
        cBuffer := Space(BLOCK_SIZE)
        nSent := FRead(hFile, @cBuffer, BLOCK_SIZE)
        cBuffer := Left(cBuffer, nSent)
        oSocket:SendData(cBuffer)
        nTotal += nSent

        Eval(::bStorProg, Round(nTotal / nSize * 100, 2))

        if nSent < BLOCK_SIZE .or. lClosed .or. Eval(::bAbort)
          Exit
        endif
        SysRefresh()

      Enddo
      FClose(hFile)
      ::Dump("I:" + NTRIM(nTotal) + " bytes of file sent in " + LTrim(Str(Seconds() - nNow, 16, 2)) + " seconds. Closing socket")
      ::Dump("I:Waiting for acknowledgement ")

      oSocket:Close()
    else
      oSocket:Close()
      oSocket:End()
    endif
    SysRefresh()
  endif
return nil

//---------------------------------------------------------------------------------------------//

Method StorClose(poSocket) CLASS qFTPClient
  ::Dump("I:Store socket closed")
  poSocket:Close()
return nil

//---------------------------------------------------------------------------------------------//

Method Quit() CLASS qFTPClient
  local lRetVal := .t.
  ::Dump("S:QUIT")
  ::nStatus := ST_DOQUIT
  ::oSocket:SendData("QUIT" + CRLF)
  ::DoWait(ST_DOQUIT)
return lRetVal

//---------------------------------------------------------------------------------------------//

Method Pwd() CLASS qFTPClient
  local cRetVal := ""
  local nPos := ""
  local cReply
  ::nStatus := ST_DOPWD
  ::Dump(":SPWD")
  ::oSocket:SendData("PWD" + CRLF)
  ::DoWait(ST_DOPWD)
  cReply := ::cReply
  nPos := At('"', cReply)
  cReply := Substr(cReply, nPos + 1)
  nPos := At('"', cReply)
  cReply := Substr(cReply, 1, nPos - 1)
  cRetVal := cReply
return cRetVal

//---------------------------------------------------------------------------------------------//

Method Del(pcFile) CLASS qFTPClient
  local lOK := .t.
  DEFAULT pcFile := ""
  ::nStatus := ST_DODELETE
  if !Empty(pcFile)
    ::Dump("S:DELE " + pcFile)
    ::oSocket:SendData("DELE " + pcFile + CRLF)
    ::DoWait(ST_DODELETE)
    lOK := ::nStatus == ST_DELETEOK
  else
    lOK := .f.
  endif
return lOK

//---------------------------------------------------------------------------------------------//

Method Rename(pcFrom, pcTo) CLASS qFTPClient
  local lOK := .t.
  DEFAULT pcFrom := ""
  DEFAULT pcTo   := ""

  if Empty(pcFrom) .or. Empty(pcTo)
    lOK := .f.
  else
    ::nStatus := ST_DORENFROM
    ::Dump("S:RNFR " + pcFrom)
    ::oSocket:SendData("RNFR " + pcFrom + CRLF)
    ::DoWait(ST_DORENFROM)
    if ::nStatus == ST_RENFROMOK
      ::nStatus := ST_DORENTO
      ::Dump("S:RNTO " + pcTo)
      ::oSocket:SendData("RNTO " + pcTo + CRLF)
      ::DoWait(ST_DORENTO)
      lOK := ::nStatus == ST_RENTOOK
    else
      lOK := .f.
    endif
  endif
return lOk

//---------------------------------------------------------------------------------------------//

Method MkDir(pcDir) CLASS qFTPClient
  local lOK := .t.
  ::nStatus := ST_DOMKDIR
  ::Dump("S:MKD " + pcDir)
  ::oSocket:SendData("MKD " + pcDir + CRLF)
  ::DoWait(ST_DOMKDIR)
  lOK := ::nStatus == ST_MKDIROK
return lOK

//---------------------------------------------------------------------------------------------//

Method RmDir(pcDir) CLASS qFTPClient
  local lOK := .t.
  ::nStatus := ST_DORMDIR
  ::Dump("S:RMD " + pcDir)
  ::oSocket:SendData("RMD " + pcDir + CRLF)
  ::DoWait(ST_DORMDIR)
  lOK := ::nStatus == ST_RMDIROK
return lOK

//---------------------------------------------------------------------------------------------//

Method Abort() CLASS qFTPClient
  local lOK := .t.
  ::nStatus := ST_DOABOR
  ::Dump("S:ABOR")
  ::oSocket:SendData("ABOR" + CRLF)
  ::DoWait(ST_DOABOR)
  lOK := ::nStatus == ST_ABOROK
return lOK

//---------------------------------------------------------------------------------------------//

Method Pasv() CLASS qFTPClient
  local lOK     := .t.
  local cReply  := ""
  local nPos    := 0
  ::nStatus := ST_DOPASV
  ::Dump("S:PASV")
  ::oSocket:SendData("PASV" + CRLF)
  ::DoWait(ST_DOPASV)
  if (lOK := ::nStatus == ST_PASVOK)
    ::lPassive := .t.
    cReply := ::cReply
    nPos := At('(', cReply)

    cReply := Substr(cReply, nPos + 1)
    nPos := At(')', cReply)
    cReply := Left(cReply, nPos - 1)

    ::cDataIP := StrToken(cReply, 1, ",") + "."
    ::cDataIP += StrToken(cReply, 2, ",") + "."
    ::cDataIP += StrToken(cReply, 3, ",") + "."
    ::cDataIP += StrToken(cReply, 4, ",")

    ::nDataPort := 0

    ::nDataPort += 256 * Val(StrToken(cReply, 5, ","))

    ::nDataPort += Val(StrToken(cReply, 6, ","))
    ::Dump("I: Server has opened connection on port " + NTRIM(::nDataport))

  else
    lOK := .f.
  endif
return lOK

//---------------------------------------------------------------------------------------------//

Method DoWait(pnState) CLASS qFTPClient
  local IniTime := Seconds()

  Do While .t.

     IF pnState = ST_RETROK
        IF ::lClosed .OR. Eval(::bAbort)
           EXIT
        ENDIF
        IF ::nRetrFSize = ::nRetrBRead
           EXIT
        ENDIF
      ELSEIF ::nStatus <> pnState .OR. ::lClosed .OR. Eval(::bAbort)
        EXIT
     ENDIF

     if Seconds() - IniTime >  0.1 // or you can exclude this
        exit
     endif

     SysRefresh()
  Enddo

  if pnState <> ST_DOABOR
    if Eval(::bAbort)
      ::Abort()
    endif
  endif

return nil

//---------------------------------------------------------------------------------------------//

FUNCTION NTRIM(n)
    LOCAL cRV := ALLTRIM(STR(n))
RETURN cRV

static function CodeDesc( aDesc, aCodes, nCode)
local nEle := ascan( aCodes, nCode )
local cRV  := "N/A          "
if nEle > 0
   cRV := aDesc[ nEle ]
endif
return cRV

Method Retr(pcRemote, pcLocal, nRetrFsize, oMeter) CLASS qFTPClient

  local lOK       := True
  local cPort     := ""
  local nPos      := 0
  local cLine     := ""
  local nNow      := 0

  // ::Dir(pcRemote)

  ::nRetrFsize := nRetrFsize     // this line is added

  nPos := Rat('/', pcRemote)
  if nPos == 0
    DEFAULT pcLocal := pcRemote
  else
    DEFAULT pcLocal := Substr(pcRemote, nPos + 1)
  endif

  ::nRetrHandle := FCreate(pcLocal)
  if ::nRetrHandle > 0

    lOK := ::XfrType("I")
    if lOK
      ::oTrnSocket := TSocket():New(0)

      if !::lPassive
        cPort := ::Port(::oTrnSocket)

        ::oTrnSocket:bAccept := { | poSocket | ::RetrAccept(poSocket:nSocket,oMeter)}
        ::oTrnSocket:Listen()

        ::Dump("I:Listening on port " + NTRIM(::oTrnSocket:nPort))

        ::nStatus := ST_DOPORT
        ::Dump("S:" + cPort)

        ::oSocket:SendData(cPort + CRLF)

        ::DoWait(ST_DOPORT)
        if ::nStatus <> ST_PORTOK
          lOK := False
        endif
      else
        if ::Pasv()
          if ::nDataPort > 0
            ::oTrnSocket:bConnect := { | poSocket | ::RetrAccept(poSocket,oMeter)}
            ::oTrnSocket:bRead   := { | poSocket | ::RetrRead(poSocket,oMeter)}
            ::oTrnSocket:bClose  := { | poSocket | ::RetrClose(poSocket,oMeter)}
            ::Dump("I:Connecting on ip:port " + ::cDataIP + ":" + NTRIM(::nDataPort))
            ::oTrnSocket:Connect(::cDataIP, ::nDataPort)
            lOK := True
          else
            lOK := False
          endif
        endif
      endif
    endif
  else
    lOK := False
  endif

  if lOK
    ::nStatus := ST_DORETR
    ::Dump("S:RETR " + pcRemote)

    ::oSocket:SendData("RETR " + pcRemote + CRLF)
    ::DoWait(ST_DORETR)

    ::DoWait(ST_RETROK)

    lOK := ::nStatus == ST_RETRDONE
    if !lOK
      ::Abort()
      ::oTrnSocket:End()
    endif

  endif

return lOK

//---------------------------------------------------------------------------------------------//

Method RetrAccept(pSocket,oMeter) CLASS qFTPClient
  local oSocket := nil
  if !::lPassive
    oSocket := TSocket():Accept(pSocket)
    oSocket:bRead  := {| poSocket | ::RetrRead(poSocket,oMeter)}
    oSocket:bClose  := {| poSocket | ::RetrClose(poSocket,oMeter)}
  endif
  ::Dump("I:Retr data connection established")
return nil

//---------------------------------------------------------------------------------------------//

Method RetrRead(poSocket,oMeter) CLASS qFTPClient
   local cData := poSocket:GetData()
   if ::nRetrHandle > 0
       ::nRetrBRead += len(cData)
       oMeter:Set(::nRetrBRead)
       FWrite(::nRetrHandle, cData)
   endif
return nil

//---------------------------------------------------------------------------------------------//

Method RetrClose(poSocket,oMeter) CLASS qFTPClient
  ::Dump("I:Retr Data completed")
  FClose(::nRetrHandle)
  //::nStatus := ST_RETRDONE
  poSocket:Close()
return nil