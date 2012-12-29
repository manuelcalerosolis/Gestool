// FiveWin Internet outgoing mail Class
// Modifications by Pipeline Solutions

#include "FiveWin.Ch"

// Different session status
#define ST_INIT       0
#define ST_CONNECTED  1
#define ST_RESET      2
#define ST_MAILFROM   3
#define ST_RCPTTO     4
#define ST_DATA       5
#define ST_SENT       6
#define ST_QUIT       7
#define ST_DONE       8
#define ST_ERROR      9

//----------------------------------------------------------------------------//

CLASS TSmtp

  DATA  oSocket     // socket used during the mail session
  DATA  cIPServer   // IP of the mail server

  DATA  cFrom       // Sender email address
  DATA  aTo         // Array of strings for each recipient email address
  DATA  cCc         // Carbon Copy moniker containing aTo's above 1

  DATA  nStatus     // Temporary session status
  DATA  nTo         // Temporary recipient index into aTo recipients array
  DATA  cMsg        // Msg Text to send
  DATA  cSubject    // msg subject
  DATA  dDate       // msg date
  DATA  cTime       // msg time
  DATA  nGmt        // GMT deviation
  DATA  cPriority   // msg priority: normal, high, low
  DATA  aFiles      // Attached files

  // Pipeline Modification
  DATA  cMailer     // Mailer Name
  DATA  cClient     // Mail Client Name
  DATA  cErrMsg     // Error Message

  DATA  bConnecting // Action to perform while trying to connect
  DATA  bConnected  // Action to perform when already connected
  DATA  bDone       // Action to perform when Msg has been already sent

  // Pipeline Modification
  DATA  bError      // Action to perform when an error occurs

  METHOD New( cIPServer, nPort ) CONSTRUCTOR

  METHOD OnRead( oSocket )

  METHOD SendMail( cFrom, aTo, cMsg, cSubject, aFiles )

  METHOD Priority()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cIPServer, nPort ) CLASS TSmtp

  DEFAULT nPort := 25
  DEFAULT ::cMsg := "", ::cSubject := "" ,;
          ::dDate := Date(), ::cTime := Time(),;
          ::nGmt := 0, ::cPriority := "Normal"

  ::oSocket := TSocket():New( nPort )

  ::oSocket:bRead := { | o | ::OnRead( o ) }

  ::cIPServer := cIPServer
  ::nStatus   := ST_INIT

  // Predefined events actions
  ::bDone = { || MsgInfo( "Message sent successfully" ) }

RETURN NIL

//----------------------------------------------------------------------------//

METHOD OnRead( oSocket ) CLASS TSmtp

  LOCAL cData := oSocket:GetData()
  LOCAL n

  STATIC cLogText := ""

  cLogText += cData

  DO CASE
    CASE SUBSTR( cData, 1, 3 ) == "220"
      oSocket:SendData( "HELO "+::cClient+CRLF )
      ::nStatus := ST_CONNECTED
      IF ::bConnected != nil
         EVAL( ::bConnected )
      ENDIF

    // Pipeline Modification
    CASE VAL( SUBSTR( cData, 1, 3 ) ) > 400
      IF ::nStatus == ST_CONNECTED
        ::nStatus := ST_RESET
        oSocket:SendData( "EHLO "+::cClient+CRLF )
      ELSE
        ::nStatus := ST_ERROR
        ::cErrMsg := cData
        IF ::bError != nil
          EVAL( ::bError, cData )
        ENDIF
      ENDIF

    CASE ::nStatus == ST_CONNECTED .OR. ::nStatus == ST_RESET
      oSocket:SendData( StrTran( "MAIL FROM:<%>", "%", ::cFrom )+CRLF )
      ::nStatus := ST_MAILFROM
      ::nTo     := 1    // First recipient index to send mail to

    CASE ::nStatus == ST_MAILFROM .OR. ::nStatus == ST_RCPTTO
      IF ::nTo <= LEN( ::aTo )
        oSocket:SendData( StrTran( "RCPT TO:<%>", "%", ;
            ::aTo[ ::nTo ] )+CRLF )
        ::nStatus := ST_RCPTTO
        ::nTo++
      ELSE
        ::nStatus = ST_DATA
        oSocket:SendData( "DATA"+CRLF )
      ENDIF

     CASE ::nStatus == ST_DATA
       // Header
       oSocket:SendData( ;
           "From: "    +::cFrom+CRLF+;
           "To: "      +::aTo[ 1 ]+CRLF+;
           "Cc: "      +::cCc + CRLF + ;
           "Subject: " +::cSubject+CRLF+;
           "Date: "    +DTtoEDT(::dDate, ::cTime, ::nGmt)+CRLF+;
           "MIME-Version: 1.0"+CRLF+;
           IF( !EMPTY( ::aFiles ), ;
               "Content-Type: multipart/mixed;"+CRLF+ ;
                CHR( 9 )+'boundary="NextPart"', ;
               "Content-Type: text/plain; "+CRLF+ ;
                CHR( 9 )+'charset="iso-8859-1"' )+CRLF+ ;
           "Content-Transfer-Encoding: 7bit"+CRLF+ ;
           "X-MSMail-Priority: "+::cPriority+CRLF+ ;
           "X-Priority: "+LTRIM( STR( ::Priority() ) )+CRLF+;
           "X-Mailer: "+::cMailer+CRLF )

       // If we have an attachment, indicate that it's multi-part
       IF !EMPTY( ::aFiles )
         oSocket:SendData( ;
             CRLF+ ;
             "This is a multi-part message in MIME format."+CRLF+CRLF + ;
             "--NextPart"+CRLF+ ;
             "Content-Type: text/plain;"+CRLF+ ;
              CHR( 9 )+'charset="iso-8859-1"'+CRLF+ ;
             "Content-Transfer-Encoding: 7bit"+CRLF )
       ENDIF

       // Send the message body
       oSocket:SendData( CRLF+::cMsg+CRLF )

       // Send any file attachments
       IF !EMPTY( ::aFiles )
         FOR n := 1 to LEN( ::aFiles )
           IF FILE( ::aFiles[ n ] )
             IF UPPER( cFileExt( ::aFiles[ n ] ) ) != "TXT"
               oSocket:SendData( ;
                   CRLF+ ;
                   "--NextPart"+CRLF+;
                   "Content-Type: application/octet-stream;"+CRLF+ ;
                   CHR( 9 )+'name="'+cFileNoPath( ::aFiles[ n ] )+'"'+CRLF+;
                   "Content-Transfer-Encoding: base64"+CRLF+;
                   "Content-Disposition: attachment;"+CRLF+;
                   CHR( 9 )+'filename="'+cFileNoPath( ::aFiles[ n ] )+ ;
                       '"'+CRLF+CRLF )
               FMimeEnc( ::aFiles[ n ], "__temp" )
               oSocket:SendFile( "__temp" )
               FErase( "__temp" )
             ELSE
               oSocket:SendData( CRLF+ ;
                   "--NextPart--"+CRLF+;
                   "Content-Type: text/plain;"+CRLF+;
                   CHR( 9 )+'name="'+cFileNoPath( ::aFiles[ n ] )+'"'+CRLF+;
                   "Content-Transfer-Encoding: quoted-printable"+CRLF+;
                   "Content-Disposition: attachment;"+CRLF+;
                   CHR( 9 )+'filename="'+cFileNoPath( ::aFiles[ n ] )+ ;
                       '"'+CRLF+CRLF )
               oSocket:SendFile( ::aFiles[ n ] )
             ENDIF
           ENDIF
         NEXT
       ENDIF

       // End the session
       oSocket:SendData( CRLF+;
           IF( !EMPTY( ::aFiles ), "--NextPart"+CRLF+CRLF, "" )+"."+CRLF )

       ::nStatus = ST_SENT

     CASE ::nStatus == ST_SENT
       oSocket:SendData( "QUIT"+CRLF )
      ::nStatus = ST_QUIT

     CASE ::nStatus == ST_QUIT
      ::nStatus = ST_DONE
      IF ::bDone != nil
        EVAL( ::bDone )
      ENDIF

  ENDCASE

  // Write the session log
  IF ::nStatus == ST_QUIT .OR. ::nStatus == ST_ERROR
    MEMOWRIT( "smtp.log", cLogText )
    cLogText := ""
  ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SendMail( cFrom, aTo, cMsg, cSubject, aFiles ) CLASS TSmtp

  LOCAL i

  ::cFrom    := cFrom
  ::aTo      := aTo
  ::cCc      := ""
  ::cMsg     := cMsg
  ::cSubject := cSubject
  ::aFiles   := aFiles

  IF EMPTY( ::aTo )
    MsgStop( "You must provide at least one mail recipient." )
    RETURN NIL
  ENDIF

  DEFAULT ::cMsg := ""
  DEFAULT ::cSubject := ""
  DEFAULT ::cClient := "smtp-client"
  DEFAULT ::cMailer := "FiveWin Mailer"

  IF LEN( aTo ) > 1
    FOR i := 2 TO LEN( aTo )
      ::cCC += aTo[ i ]+IF( i < LEN( aTo ), ",", "" )
    NEXT
  ENDIF

  IF ::bConnecting != nil
     EVAL( ::bConnecting )
  ENDIF

  ::oSocket:Connect( ::cIPServer )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Priority() CLASS TSmtp

  LOCAL nType

  DO CASE
    CASE  Upper(::cPriority) == "HIGH"
      nType := 1
    CASE  Upper(::cPriority) == "LOW"
      nType := 5
    OTHERWISE
      nType := 3
  ENDCASE

RETURN nType

//----------------------------------------------------------------------------//

STATIC FUNCTION DTtoEDT( dDate, cTime, nGmt )

  LOCAL aWeek  := {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"}
  LOCAL aMonth := {"Jan", "Feb", "Mar", "Apr", "May", "Jun",;
                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
  LOCAL cGmt

  IF nGmt != 0
    cGmt := " "+IF( nGmt > 0,"+" ,"-" )+"0"+LTRIM(STR(ABS(nGmt)))+"00"
  ELSE
    cGmt := ""
  ENDIF

RETURN ( aWeek[DOW(dDate)]   +", "+LTRIM(STR(DAY(dDate))) +" "+;
         aMonth[MONTH(dDate)]+" " +LTRIM(STR(YEAR(dDate)))+" "+;
         cTime+cGmt )