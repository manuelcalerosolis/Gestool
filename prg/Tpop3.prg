// FiveWin Internet incomming mail Class
// Modified by Ray Alich (IBTC)  November 5, 2002
//   Code optimized by Luis Krause

#include "FiveWin.ch"

// different session status

// CONNECT
#define ST_CONNECTING  1
#define ST_IDENTIFY1   2
#define ST_IDENTIFY2   3
#define ST_STAT       99
#define ST_REQLIST     4
#define ST_IDENTIFY4   5
#define ST_IDENTIFY5   6
#define ST_SENDBODY    7
#define ST_SENDQUIT    8
#define ST_ENDED      10
#define ST_REQNEXT    98
#define ST_REQMSG     96
#define ST_DELMSG     97

// STOR
#define ST_STOR_PORT     "ST_PORT"
#define ST_STOR_OPENCONN "ST_OPENCONN"
#define ST_STOR_START    "ST_START"

#define CONNECT_OK      "220"
#define HELLO_OK        "250"
#define MAILFROM_OK     "250"
#define MAILTO_OK       "250"
#define DATA_OK         "354"
#define LOGIN_OK        "230"
#define MSG_OK          "250"
#define CLOSE_OK        "221"
#define ENDMSG          "."
#define ST_NOOP       6
#define ST_OK           "+OK"

#define MSG_CAPTION   "POP3 Services"

//----------------------------------------------------------------------------//

CLASS TPop3

   DATA   oSocket     // socket used during the Control session
   DATA   nPort
   DATA   User
   DATA   Pass
   DATA   lOk
   DATA   aMsgs
   DATA   nAtMsg
   DATA   cIPServer   // IP of the mail server
   DATA   AllOk
   DATA   nStatus     // Temporary session status
   DATA   lDelMsgs
   DATA   lCheckOnly                             // IBTC
   DATA   cCheckInfo                             // IBTC
   DATA   cStatus                                // LKM

   DATA   bConnecting AS CODEBLOCK INIT NIL      // Action to perform while trying to connect to the server
   DATA   bConnected  AS CODEBLOCK INIT NIL      // Action to perform when already connected to the server
   DATA   bDone       AS CODEBLOCK INIT NIL      // Action to perform when Msgs have been retrieved
   DATA   bFailure    AS CODEBLOCK INIT NIL      // LKM

   METHOD New( cIPServer, nPort, cUser, cPass ) CONSTRUCTOR
   METHOD GetMail( lCheckOnly )                  // IBTC added lCheckOnly param
   METHOD OnRead( oSocket, nWSAError  )          // IBTC added nWSAError param
   METHOD OnConnect( oSocket, nWSAError  )       // IBTC
   METHOD LogError( cData, oSocket )
   METHOD Dump( pcText, oSocket )                // IBTC; added oSocket

   METHOD End()  INLINE  ;                       // IBTC
      If( ::oSocket # Nil, ::oSocket:End(), Nil )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cIPServer, nPort, cUser, cPass ) CLASS TPop3

   Default nPort := 110, ;
           cUser := "", ;                        // IBTC
           cPass := ""                           // IBTC

   If Empty( cIPServer )                         // IBTC
      cIPServer := "0.0.0.0"                     // IBTC
   Endif                                         // IBTC

   ::AllOk     := .F.
   ::cIPServer := cIPServer
   ::User      := AllTrim( cUser )
   ::Pass      := AllTrim( cPass )
   ::nStatus   := ST_CONNECTING
   ::nPort     := nPort
   ::lDelMsgs  := .F.                            // IBTC (was .t.)
   ::cStatus   := ""

   ::oSocket := TSocket():New( nPort )           // IBTC, moved from ::GetMail()

   ::oSocket:bRead    := {|o,n| ::OnRead( o, n ) }    // IBTC
   ::oSocket:bConnect := {|o,n| ::OnConnect( o, n ) } // IBTC

   // by lkm now you can provide either the IPAddress or the server name (friendly name)
   ::cIPServer := If( IsAlpha( cIPServer ), GetHostByName( AllTrim( cIPServer ) ), cIPServer )   // IBTC
   ::cCheckInfo := ""                            // IBTC

   ::bFailure := {|cError| ;
      MsgStop( "Session did not complete successfully" + CRLF + CRLF + cError, MSG_CAPTION ) }

Return Self

//----------------------------------------------------------------------------//

METHOD GetMail( lCheckOnly ) CLASS TPop3

   Default lCheckOnly := .T.                     // IBTC

   ::lCheckOnly := lCheckOnly
 /*::oSocket := TSocket():New( ::nPort )         // Socket is now created
   ::oSocket:bRead := { | o | ::OnRead( o ) }*/  // in ::New()
   ::oSocket:Connect( ::cIPServer, ::nPort )

Return Self

//----------------------------------------------------------------------------//
// New method IBTC; code optimized by LKM
METHOD OnConnect( oSocket, nWSAError )  CLASS TPop3

   Local cHost := "", cMsg := "", lRetVal := .F.

   If Empty( ::cIPServer ) .or. ::cIPServer == "0.0.0.0"
      cMsg := "No POP3 server"
   Elseif Empty( ::User )
      cMsg := "No user"
   Elseif Empty( ::Pass )
      cMsg := "No password"
   Elseif nWSAError # 0
      cHost := GetHostByAddress( ::cIPServer )
      cMsg := "Could not establish connection to " + If( Empty( cHost ), ::cIPServer, cHost )
   Else
      lRetVal := .T.
      ::Dump( "Connected", oSocket )             // LKM added oSocket
   Endif

   If ! lRetVal
      ::LogError( cMsg, oSocket )
      ::AllOK   := .F.
      ::nStatus := ST_ENDED
   Endif

Return lRetVal

//----------------------------------------------------------------------------//

METHOD OnRead( oSocket, nWSAError ) CLASS TPop3

   Local cData    := oSocket:GetData()
   Local rCode    := SubStr( cData, 1, 3 )
   //Local cMsg     := SubStr( cData, 3 )        // not used LKM
   Local cCommand := ""
   Local nI
   Local nMsgs := 0                              // LKM

   ::cStatus := cData                            // LKM
   ::Dump( "Received " + cData, oSocket )        // IBTC; LKM added oSocket

   do case
      case ::nStatus == ST_CONNECTING
         if rCode == ST_OK
            cCommand  := "USER " + ::User + CRLF
            ::nStatus := ST_IDENTIFY1
            If ::bConnecting != nil
               Eval( ::bConnecting, Self )
            Endif
         else
            ::LogError( cData, oSocket )
         endif

      case ::nStatus == ST_IDENTIFY1
         if rCode == ST_OK
            cCommand  := "PASS " + ::Pass + CRLF
            ::nStatus := ST_IDENTIFY2
         else
            ::LogError( oSocket:HidePwd( cData ), oSocket )
         endif

      case ::nStatus == ST_IDENTIFY2
         if rCode == ST_OK
            cCommand  := "STAT " + CRLF
            ::nStatus := ST_STAT
         else
            ::LogError( cData, oSocket )
         endif

      case ::nStatus == ST_STAT
         if rCode == ST_OK
            If ::bConnected != nil
               Eval( ::bConnected, Self )
            Endif
            cData := StrTran( cData, " ", "&" ) + "&"
            ::aMsgs := Array( nMsgs := Val( StrToken( cData, 2, "&" ) ) )
            for nI := 1 To nMsgs
               ::aMsgs[ nI ] := ""
            next
            if nMsgs == 0 .or. ::lCheckOnly
               If ::lCheckOnly                   // LKM, based on IBTC
                  ::cCheckInfo := If( nMsgs == 0, ;
                     "There are no new messages on the server", ;
                     "You have " + AllTrim( Str( nMsgs ) ) + " new messages" )
               Endif                             // LKM
               cCommand  := "QUIT" + CRLF
               ::nStatus := ST_SENDQUIT
            else
               ::nAtMsg  := 1
               cCommand  := "RETR " + AllTrim( Str( 1, 4, 0 ) ) + CRLF
               ::nStatus := ST_REQMSG
            endif
         else
            ::LogError( cData, oSocket )
         endif

      case ::nStatus == ST_DELMSG
         if rCode == ST_OK
            if ::nAtMsg < Len( ::aMsgs )
               cCommand  := "RETR " + AllTrim( Str( ++::nAtMsg, 4, 0 ) ) + CRLF
               ::nStatus := ST_REQMSG
            else
               cCommand  := "QUIT" + CRLF
               ::nStatus := ST_SENDQUIT
            endif
         else
            ::LogError( cData, oSocket )
         endif

      case ::nStatus == ST_REQMSG
         if ::nAtMsg <= Len( ::aMsgs )
            ::aMsgs[ ::nAtMsg ] += cData
            if Right( ::aMsgs[ ::nAtMsg ], 5 ) == CRLF + "." + CRLF  //if At( Chr( 13 ) + Chr( 10 ) + "." + Chr( 13 ) + Chr( 10 ), cData ) > 0
               if ::lDelMsgs
                  cCommand  := "DELE " + AllTrim( Str( ::nAtMsg, 4, 0 ) ) + CRLF
                  ::nStatus := ST_DELMSG
               else
                  cCommand  := "RETR " + AllTrim( Str( ++::nAtMsg, 4, 0 ) ) + CRLF
                  ::nStatus := ST_REQMSG
               endif
            else
               ::nStatus := ST_REQMSG
            endif
         else
            cCommand  := "QUIT" + CRLF
            ::nStatus := ST_SENDQUIT
            ::AllOk   := .t.
         endif

      case ::nStatus == ST_SENDQUIT
         if rCode == ST_OK
            cCommand := ""
            oSocket:End()
            ::nStatus := ST_ENDED
            ::AllOk   := .t.
         else
            ::LogError( cData, oSocket )
         endif

   endcase

   if ! Empty( cCommand )
      ::Dump( "Sending " + cCommand, oSocket )   // IBTC; LKM added oSocket
      oSocket:SendData( cCommand )
      if cCommand == "QUIT" + CRLF
         If ::bDone != nil                       // IBTC
            Eval( ::bDone, Self )                //
         Endif                                   //
      endif
   endif

Return Nil

//----------------------------------------------------------------------------//

METHOD LogError( cData, oSocket ) CLASS TPop3

   If oSocket:lDebug                             // IBTC
      LogFile( oSocket:cLogFile, { ::nStatus, oSocket:HidePwd( cData ) } )
   Endif

   If ::bFailure != nil                          // IBTC
      Eval( ::bFailure, cData )
   Endif

   oSocket:End()
   //LogFile( "MailErr.log", { ::nStatus, cData } )  // commented by IBTC
   ::AllOk   := .f.
   ::nStatus := ST_ENDED                         // IBTC

Return Nil

//----------------------------------------------------------------------------//
// new method by IBTC; LKM added oSocket param
METHOD Dump( pcText, oSocket ) CLASS TPop3

   If oSocket:lDebug
      LogFile( oSocket:cLogFile, { "-> " + StrTran( oSocket:HidePwd( pcText ), CRLF, "" ) } )
   Endif

Return Nil

//----------------------------------------------------------------------------//
