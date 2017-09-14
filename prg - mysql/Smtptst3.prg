// tested under FiveWin 2.1c
// tested under FiveWin 2.2d  // by Quim
// tested under FiveWin 2.3b  // by IBTC
// tested under FiveWin 2.5 Jan 2005  // by LKM

#include "FiveWin.ch"

#define COLOR_WINDOWTEXT           8
#define COLOR_BTNFACE             15

Static oWnd, oMail, oPop

Function Mailing()

   LOCAL oBar, hFocus
   LOCAL cHost     := Space(255)
   LOCAL cPOP3Host := Space(255)
   LOCAL cSender   := Space(255)
   LOCAL cReplyTo  := Space(255)
   LOCAL cMsg      := Space(255)
   LOCAL cUser     := Space(255)   // [jlalin]
   LOCAL cPass     := Space(255)   // [jlalin]
   LOCAL lReceipt  := .F.
   LOCAL lAuth     := .F.          // IBTC
   LOCAL lPop3     := .F.          // IBTC

   // my defaults add by Quim
    cMsg    := "This is a test to see how the plain text message" + CRLF + ;
               "is converted to html in the body of the email.<br><br>" + CRLF + ;
               "The email client must support html rendering."
   // end by Quim

   Define Window oWnd FROM 0, 0 TO 26, 70 ;
      Title "Sending EMail via TSmtp class from FiveWin" ;
      Color GetSysColor( COLOR_WINDOWTEXT ), GetSysColor( COLOR_BTNFACE )

   Define ButtonBar oBar _3D Of oWnd
   oBar:SetFont( TFont():New( "MS Sans Serif", 0, -11,, .T. ) )  // to avoid runtime error in TBtnBmp class!!!

   Define Button of oBar Prompt "S" Group ;
      Action SendMail( AllTrim( cHost ), AllTrim( cSender ), AllTrim( cReplyTo ), AllTrim( cMsg ), lReceipt, lAuth, AllTrim(cUser), AllTrim(cPass), lPop3, cPOP3Host ) ;  // IBTC
      ToolTip "Send EMail Autotest";
      Message "Send EMail Autotest"

   Define Button of oBar Prompt "P" Group ;         // IBTC
      Action CheckPop3( AllTrim( cPOP3Host ), AllTrim( cUser ), AllTrim( cPass ), {|o| MsgInfo( o:cCheckInfo ) } );
      ToolTip "Check if Email exists via POP3";
      Message "Check if Email exists via POP3"

   Define Button of oBar Prompt "X" Group;
      Action oWnd:end() ;
      ToolTip "Exit SMTP test";
      Message "Exit SMTP test"

   Set Message of oWnd To "Press button to start smtp test..."

   @  4-2, 5 Say "SMTP-Host name or IP address:" Size 450, 22 Of oWnd
   @  6-2, 5 Get cHost Size 450, 22 Of oWnd
   hFocus := ATail( oWnd:aControls ):hWnd

   @  8-2.5, 5 Say "Sender's email address:" Size 450, 22 Of oWnd
   @ 10-2,   5 Get cSender Size 450, 22 Of oWnd

   @ 12-3, 5 Say "Reply-To email address (optional):" Size 450, 22 Of oWnd
   @ 14-2, 5 Get cReplyTo Size 450, 22 Of oWnd

   @ 16-3.5, 5 Say "Username (Authentification/POP3):" Size 450, 22 Of oWnd         // IBTC
   @ 18-2, 5 Get cUser Size 450, 22 Of oWnd                                         // IBTC

   @ 20-4, 5 Say "Password (Authentification/POP3):" Size 450, 22 Of oWnd           // IBTC
   @ 22-2, 5 Get cPass Size 450, 22 Of oWnd Password                                // IBTC

   @ 24-4.5, 5 Say "POP3-Host name or IP address:" Size 450, 22 Of oWnd             // IBTC
   @ 26-2, 5 Get cPOP3Host Size 450, 22 Of oWnd                                     // IBTC

   @ 28.2-2,  5 CheckBox lReceipt Prompt " Return Receipt"    Size 150, 22 Of oWnd
   @ 28.2-2, 25 CheckBox lAuth    Prompt " Authentification"  Size 150, 22 Of oWnd   // IBTC
   @ 28.2-2, 45 CheckBox lPop3    Prompt " POP3-Login before" Size 150, 22 Of oWnd   // IBTC

   Activate Window oWnd;
      On Init SetFocus( hFocus )

Return Nil

// ---------------------------------------------------------------------------------- //

Exit Function Bye()

   If oMail # Nil
      oMail:end()
   Endif

   If oPop # Nil
      oPop:end()
   Endif

Return Nil

// ---------------------------------------------------------------------------------- //

Static Function SendMail( cHost, cSender, cReplyTo, cMsg, lReceipt, lAuth, cUser, cPass, lPop3, cPOP3Host )

   // the logic about 'Authenticate by doing prior POP3 mail check':
   /*
      SendToPOP3 ("USER" + " " + cUserName) // Login to POP3
      IF POP3Answer() == "OK" // User Name Is Accepted
         SendToPOP3("PASS" + " " + cUserPassword )  // Send Password
         IF POP3Answer() == "OK"  // Password Is Accepted
             Sleep( nMiliSec ) // Some Server MAY want This.
                               // Meaning we have to log for some time
                               //  before logging out from POP3.
             SendToPOP3("QUIT")
             // Then follows by SMTP routines here
             ....
             ....
         ENDIF
      ENDIF
   */

   IF lPop3
      CheckPop3( cPOP3Host, cUser, cPass,;
                 { |o| If( SubStr( o:cStatus, 1, 3 ) == "+OK",;
                           _SendMail( cHost, cSender, cReplyTo, cMsg, lReceipt, lAuth, cUser, cPass ), MsgStop( "POP3 Login was not possible." ) ) } )
   ELSE
      _SendMail( cHost, cSender, cReplyTo, cMsg, lReceipt, lAuth, cUser, cPass )
   ENDIF

Return Nil

Static Function _SendMail( cHost, cSender, cReplyTo, cMsg, lReceipt, lAuth, cUser, cPass )

   LOCAL oInit

   // initialize sockets (or nothing will happen) - it's a quirk in GetHostByName(), not TSmtp
   oInit := TSmtp():New( cHost )

   // no let's go for our socket
   oMail := TSmtp():New( cHost, , lAuth, cUser, cPass ) // [jlalin], IBTC
   oMail:cReplyTo := cReplyTo
   oMail:nGMT     := 8   // 8 = Pacific Standard Time (GMT -08:00) - Adjust this to your own Time Zone!

   // uncomment next line if you experience problems while sending email
   // descomentar sig. l¡nea en caso de experimentar problemas al enviar correo
   //oMail:nDelay := 1

   *oMail:lTxtAsAttach     := .F.          // uncomment to force txt, log and htm files as inline as opposed to attachement
   oMail:oSocket:lDebug   := .T.         // uncomment to create log file
   oMail:oSocket:cLogFile := "smtp.log"

   oMail:bConnecting := {|| oWnd:SetMsg( "Connecting to " + cHost + " (" + oMail:cIPServer + ") and waiting for response..." ) }
   oMail:bConnected  := {|| oWnd:SetMsg( "Connected and sending mail and attachments..." ) }

   oMail:SendMail( ;
      cSender, ;             // from/de
      { cSender }, ;         // to/para (arreglo) - I use cSender here also because it's an "autotest". Actually you would type a different address here
      "Hi guys:" + CRLF + "I've sent this from within FiveWin using TSmtp class" + CRLF + "This is just my first attempt to see if it works.",;  // Body/Mensaje
      "Testing SMTP class",; // Subject/Asunto
      { "smtptest.prg" }, ;  //  Array of filenames to attach/Arreglo de nombres de archivos a agregar
      { }, ;                 // aCC
      { }, ;                 // aBCC
      lReceipt, ;            // Return Receipt/acuse de recibo
      cMsg )                 // msg in HTML format/mensaje en HTML

   oInit:end()

Return .T.

// ---------------------------------------------------------------------------------- //

Static Function CheckPop3( cPOP3Host, cUser, cPass, bDone )

   LOCAL oInit

   // initialize sockets (or nothing will happen) - it's a quirk in GetHostByName(), not TSmtp
   oInit := TSmtp():New( cPOP3Host )

   oPop := TPOP3():New( cPOP3Host, , cUser, cPass )

   oPop:bConnecting := {|| oWnd:SetMsg( "Connecting to " + cPOP3Host + " (" + oPop:cIPServer + ") and waiting for response..." ) }
   oPop:bConnected  := {|| oWnd:SetMsg( "Checking for email messages..." ) }
   oPop:bDone       := bDone

   oPop:oSocket:lDebug   := .T.         // uncomment to create log file
   oPop:oSocket:cLogFile := "pop3.log"

   oPop:GetMail( .T. )

   oInit:end()

Return Nil

// ---------------------------------------------------------------------------------- //