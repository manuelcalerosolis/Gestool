#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MailSender

   DATA oController

   DATA oEvents

   DATA lCancel                        INIT .f.

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

   METHOD New( oController ) CONSTRUCTOR
   METHOD End()

   METHOD isMailServer()      

   METHOD send( hMail )   

   METHOD getMailServer()

   // Metodos para mostrar la informacion--------------------------------------

   METHOD messenger( cText )           INLINE ( ::getEvents():Fire( 'message', cText ) )

   METHOD readyMessage( hMail )        INLINE ( ::messenger( "Se ha elaborado el correo electrónico con el asunto '" + ::getSubjectFromHash( hMail ) + "' para enviar a " + ::getMailsFromHash( hMail ) ) )
   METHOD sendMessage( hMail )         INLINE ( ::messenger( "El correo electrónico con el asunto '" + ::getSubjectFromHash( hMail ) + "' se ha enviado con exito, al correo " + ::getMailsFromHash( hMail ) ) )
   METHOD errorMessage( hMail )        INLINE ( ::messenger( "Error al enviar el correo electrónico " + ::getMailsFromHash( hMail ) ) )

   // Utilidades---------------------------------------------------------------

   METHOD mailServerString()           INLINE ( ::oMailServer + if( !empty( ::mailServerPort ), ":" + alltrim( str( ::mailServerPort ) ), "" ) )
   METHOD getMensajeHTML()             INLINE ( "<HTML>" + strtran( alltrim( ::oController:cGetMensaje ), CRLF, "<p>" ) + "</HTML>" )

   METHOD getFromHash( hMail, cKey )   INLINE ( iif( hhaskey( hMail, cKey ), hGet( hMail, cKey ), nil ) )      
   METHOD getMailsFromHash( hMail )    INLINE ( ::getFromHash( hMail, "mail" ) )      
   METHOD getSubjectFromHash( hMail )  INLINE ( ::getFromHash( hMail, "subject" ) )
   METHOD getPostSendFromHash( hMail ) INLINE ( ::getFromHash( hMail, "postSend" ) )

   // Contrucciones tardias----------------------------------------------------

   METHOD getEvents()                  INLINE ( if( empty( ::oEvents ), ::oEvents := Events():New(), ), ::oEvents )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS MailSender

   ::oController              := oController

   ::mailServerHost           := Auth():emailServidor()
   ::mailServerPort           := Auth():emailPuerto()
   ::mailServerUserName       := Auth():email()
   ::mailServerPassword       := Auth():emailPassword()
   ::mailServerConCopia       := Auth():enviarEmailCopia()
   ::mailServerConCopiaOculta := Auth():enviarCopiaOculta()
   ::mailServerAuthenticate   := Auth():autenticacionSMTP()
   ::mailServerSSL            := Auth():requiereSSL()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS MailSender

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

   if !empty( ::oMailServer )
      ::oMailServer:End()
   end if 

RETURN ( nil )

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

METHOD isMailServer() CLASS MailSender

RETURN ( !empty( ::mailServerHost ) .and. !empty( ::mailServerUserName ) .and. !empty( ::mailServerPassword ) )

//---------------------------------------------------------------------------//

METHOD send( hMail ) CLASS MailSender
   
   local cMail          := ::getMailsFromHash( hMail )

   if empty( cMail )
      ::messenger( "El correo electrónico con el asunto '" + ::getSubjectFromHash( hMail ) + "' esta vacio." )
      RETURN ( .f. )
   end if

   if isTrue( ::getMailServer():sendMail( hMail ) )
      ::messenger( "El correo electrónico con el asunto '" + ::getSubjectFromHash( hMail ) + "' se ha enviado con exito." )
      ::getEvents():Fire( 'sendSuccessful' )
      RETURN ( .t. )
   end if 

   ::messenger( ::getMailServer():getError() )
   ::messenger( "El correo electrónico con el asunto '" + ::getSubjectFromHash( hMail ) + "' no se ha enviado." )
   ::getEvents():Fire( 'sendError' )

RETURN ( .f. )

//--------------------------------------------------------------------------//

