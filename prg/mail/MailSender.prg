#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MailSender

   DATA oController

   DATA oEvents

   DATA lCancel               INIT .f.

   DATA bPostSendMail         

   DATA oMailServer

   DATA mailServerHost        
   DATA mailServerPort    
   DATA mailServerUserName
   DATA mailServerPassword
   DATA mailServerConCopia
   DATA mailServerConCopiaOculta
   DATA mailServerAuthenticate
   DATA mailServerSSL

   // Log de informaci�n-------------------------------------------------------

   DATA cLogFile              
   DATA hLogFile              INIT  -1 

   METHOD New( oController )

   METHOD isMailServer()      

   METHOD send( hMail )   

   METHOD getMailServer()

   // Log----------------------------------------------------------------------

   METHOD initLogFile()                INLINE ( ::cLogFile := cPatLog() + "Mail" + Dtos( Date() ) + StrTran( Time(), ":", "" ) + ".log", ::hLogFile := fCreate( ::cLogFile ) )

   METHOD writeLogFile( cText )        INLINE ( if( ::hLogFile != -1, fWrite( ::hLogFile, cText + CRLF ), ) )

   METHOD endLogFile()                 INLINE ( fClose( ::hLogFile ) )

   // Metodos para mostrar la informacion--------------------------------------

   METHOD messenger( cText )           INLINE ( ::writeLogFile( cText ), ::oEvents:Fire( 'message', cText ) )

   METHOD initMessage()                INLINE ( ::messenger( "Se ha iniciado el proceso de envio" ) )
   METHOD readyMessage( hMail )        INLINE ( ::messenger( "Se ha elaborado el correo electr�nico con el asunto '" + ::getSubjectFromHash( hMail ) + "' para enviar a " + ::getMailsFromHash( hMail ) ) )

   METHOD sendMessage( hMail )         INLINE ( ::messenger( "El correo electr�nico con el asunto '" + ::getSubjectFromHash( hMail ) + "' se ha enviado con exito, al correo " + ::getMailsFromHash( hMail ) ) )
   METHOD errorMessage( hMail )        INLINE ( ::messenger( "Error al enviar el correo electr�nico " + ::getMailsFromHash( hMail ) ) )

   // Utilidades---------------------------------------------------------------

   METHOD mailServerString()           INLINE ( ::oMailServer + if( !empty( ::mailServerPort ), ":" + alltrim( str( ::mailServerPort ) ), "" ) )
   METHOD getMensajeHTML()             INLINE ( "<HTML>" + strtran( alltrim( ::oController:cGetMensaje ), CRLF, "<p>" ) + "</HTML>" )

   METHOD getFromHash( hMail, cKey )   INLINE ( iif( hhaskey( hMail, cKey ), hGet( hMail, cKey ), nil ) )      
   METHOD getMailsFromHash( hMail )    INLINE ( ::getFromHash( hMail, "mail" ) )      
   METHOD getSubjectFromHash( hMail )  INLINE ( ::getFromHash( hMail, "subject" ) )
   METHOD getPostSendFromHash( hMail ) INLINE ( ::getFromHash( hMail, "postSend" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS MailSender

   ::oController              := oController

   ::oEvents                  := Events():New()

   ::mailServerHost           := Auth():emailServidor()
   ::mailServerPort           := Auth():emailPuerto()
   ::mailServerUserName       := Auth():email()
   ::mailServerPassword       := Auth():emailPassword()
   ::mailServerConCopia       := Auth():enviarEmailCopia()
   ::mailServerConCopiaOculta := Auth():enviarCopiaOculta()
   ::mailServerAuthenticate   := Auth():autenticacionSMTP()
   ::mailServerSSL            := Auth():requiereSSL()

   ::getMailServer()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD isMailServer() CLASS MailSender

RETURN ( !empty( ::mailServerHost ) .and. !empty( ::mailServerUserName ) .and. !empty( ::mailServerPassword ) )

//---------------------------------------------------------------------------//

METHOD getMailServer() CLASS MailSender

   if !empty( ::oMailServer )
      RETURN ( ::oMailServer )
   end if 

   if ::isMailServer()
      ::oMailServer     := TSendMailCDO():New( self )
   else
      ::oMailServer     := TSendMailOutlook():New( self )
   end if 

RETURN ( ::oMailServer )

//--------------------------------------------------------------------------//

METHOD send( hMail ) CLASS MailSender
   
   local cMail          := ::getMailsFromHash( hMail )

   if empty( cMail )
      ::messenger( "El correo electr�nico con el asunto '" + ::getSubjectFromHash( hMail ) + "' esta vacio." )
      RETURN .f.
   end if

   if isTrue( ::oMailServer:sendMail( hMail ) )
      ::messenger( "El correo electr�nico con el asunto '" + ::getSubjectFromHash( hMail ) + "' se ha enviado con exito." )
      ::oEvents:Fire( 'sendSuccessful' )
   else
      ::oEvents:Fire( 'sendError' )
   end if 

RETURN ( nil )

//--------------------------------------------------------------------------//
