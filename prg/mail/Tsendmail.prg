#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TSendMail

   DATA oSender

   DATA lCancel               INIT .f.

   DATA bPostSendMail         

   DATA mailServer

   DATA mailServerHost        
   DATA mailServerPort    
   DATA mailServerUserName
   DATA mailServerPassword
   DATA mailServerConCopia
   DATA mailServerAuthenticate
   DATA mailServerSSL

   // Log de información

   DATA cLogFile              
   DATA hLogFile              INIT  -1 

   DATA oDlg

   METHOD New( oSender )

   // Metodos para controlar la vista

   METHOD getTime()           INLINE ( val( ::oSender:cTiempo ) )
   METHOD setButtonCancel()   
   METHOD setButtonEnd()      

   // Metodos para manejar el metter

   METHOD setMeterTotal( nTotal );
                              INLINE ( iif( !empty( ::oSender ), ::oSender:setMeterTotal( nTotal ), ) )
   METHOD setMeter( nSet )    INLINE ( iif( !empty( ::oSender ), ::oSender:setMeter( nSet ), ) )

   METHOD initLogFile()       INLINE ( ::cLogFile := cPatLog() + "Mail" + Dtos( Date() ) + StrTran( Time(), ":", "" ) + ".log",;
                                       ::hLogFile := fCreate( ::cLogFile ) )
   METHOD writeLogFile( cText ) ;
                              INLINE ( if( ::hLogFile != -1, fWrite( ::hLogFile, cText + CRLF ), ) )
   METHOD endLogFile()        INLINE ( fClose( ::hLogFile ) )

   // Metodos para mostrar la informacion

   METHOD messenger( cText )  INLINE ( ::writeLogFile( cText ),;
                                       iif(  !empty( ::oSender ),;
                                             ::oSender:oTree:Select( ::oSender:oTree:Add( cText) ),;
                                             ) )
   METHOD deleteMessenger( cText );
                              INLINE ( iif( !empty( ::oSender ), ::oSender:oTree:deleteAll(), ) )

   METHOD initMessage()       INLINE ( ::deleteMessenger(),;
                                       ::messenger( "Se ha iniciado el proceso de envio" ) )
   METHOD readyMessage( hMail );
                              INLINE ( ::messenger( "Se ha elaborado el correo electrónico con el asunto '" + ::getSubjectFromHash( hMail ) + "' para enviar a " + ::getMailsFromHash( hMail ) ) )

   METHOD sendMessage( hMail );
                              INLINE ( ::messenger( "El correo electrónico con el asunto '" + ::getSubjectFromHash( hMail ) + "' se ha enviado con exito, al correo " + ::getMailsFromHash( hMail ) ) )
   METHOD errorMessage( hMail );
                              INLINE ( ::messenger( "Error al enviar el correo electrónico " + ::getMailsFromHash( hMail ) ) )
   METHOD endMessage()        INLINE ( iif(  ::lCancel,;
                                             ::messenger( "El envio ha sido cancelado por el usuario" ),;
                                             ::messenger( "El proceso de envio ha finalizado" ) ),;
                                       ::messenger( "Fichero log : " + ::cLogFile ) )

   // Envios de los mails

   METHOD sendList( aMails )
   METHOD sendMail( hMail )   

   // Construir objetos para envio de mails

   METHOD buildMailerObject()

   // Utilidades

   METHOD isMailServer()      
   METHOD mailServerString()  INLINE ( ::mailServer + if( !empty( ::mailServerPort ), ":" + alltrim( str( ::mailServerPort ) ), "" ) )
   METHOD getMensajeHTML()    INLINE ( "<HTML>" + strtran( alltrim( ::oSender:cGetMensaje ), CRLF, "<p>" ) + "</HTML>" )

   METHOD getFromHash( hMail, cKey ) ;
                              INLINE ( iif( hhaskey( hMail, cKey ), hGet( hMail, cKey ), nil ) )      

   METHOD getMailsFromHash( hMail ) ;
                              INLINE ( ::getFromHash( hMail, "mail" ) )      

   METHOD getSubjectFromHash( hMail ) ;
                              INLINE ( ::getFromHash( hMail, "subject" ) )

   METHOD getPostSendFromHash( hMail ) ;
                              INLINE ( ::getFromHash( hMail, "postSend" ) )

   METHOD evalPostSendMail( hMail ) ;
                              INLINE ( iif(  !empty( ::getPostSendFromHash( hMail ) ),;
                                             eval( ::getPostSendFromHash( hMail ), hMail ), ) )

   METHOD showNoModalDialog( cTitle, cText )

   METHOD endNoModalDialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TSendMail

   ::oSender                  := oSender

   ::mailServerHost           := Rtrim( uFieldEmpresa( "cSrvMai" ) )
   ::mailServerPort           := uFieldEmpresa( "nPrtMai" )
   ::mailServerUserName       := Rtrim( uFieldEmpresa( "cCtaMai" ) )
   ::mailServerPassword       := Rtrim( uFieldEmpresa( "cPssMai" ) )
   ::mailServerConCopia       := Rtrim( uFieldEmpresa( "cCcpMai" ) )
   ::mailServerAuthenticate   := uFieldEmpresa( "lAutMai")
   ::mailServerSSL            := uFieldEmpresa( "lSSLMai")

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD isMailServer()

RETURN ( !empty( ::mailServerHost ) .and. !empty( ::mailServerUserName ) .and. !empty( ::mailServerPassword ) )

//---------------------------------------------------------------------------//

METHOD sendList( aMails ) CLASS TSendMail

   local hMail

   CursorWait()

   ::setButtonCancel()

   ::setMeter( 0 ) 
   ::setMeterTotal( len( aMails ) )

   ::initLogFile()

   if ::buildMailerObject()

      for each hMail in aMails

         if ::sendMail( hMail )
            ::sendMessage( hMail )
            ::evalPostSendMail( hMail )
         end if
      
         ::setMeter( hb_EnumIndex() ) 
      
      next 

   end if 

   ::endMessage()

   ::endLogFile()

   ::setButtonEnd()

   CursorArrow()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD setButtonCancel() CLASS TSendMail

   if !empty( ::oSender )
      ::oSender:oBtnCancel:bAction := {|| ::lCancel := .t. }
   end if 

RETURN ( self )

//--------------------------------------------------------------------------//

METHOD setButtonEnd() CLASS TSendMail

   if !empty( ::oSender )
      ::oSender:oBtnCancel:bAction := {|| ::oSender:oDlg:End() } 
   end if 

RETURN ( self )

//--------------------------------------------------------------------------//

METHOD buildMailerObject() CLASS TSendMail

   if ::isMailServer()
      ::mailServer   := TSendMailCDO():New( self )
   else
      ::mailServer   := TSendMailOutlook():New( self )
   end if 

RETURN ( !empty( ::mailServer ) )

//--------------------------------------------------------------------------//

METHOD sendMail( hMail ) CLASS TSendMail
   
   local cMail    := ::getMailsFromHash( hMail )

   if empty( cMail )
      ::messenger( "El correo electrónico con el asunto '" + ::getSubjectFromHash( hMail ) + "' esta vacio." )
      RETURN .f.
   end if 

   if empty( ::mailServer )
      ::messenger( "No se ha creado el objeto para los envios" )
      RETURN .f.
   end if

RETURN ( isTrue( ::mailServer:sendMail( hMail ) ) )

//--------------------------------------------------------------------------//

METHOD showNoModalDialog( cTitle, cText ) CLASS TSendMail

   DEFAULT cTitle    := "Por favor espere..."
   DEFAULT cText     := "Generando correo electrónico"

   ::oDlg            := TWaitMeter():New( cText, cTitle )
   ::oDlg:run()

RETURN ( self )

//--------------------------------------------------------------------------//

METHOD endNoModalDialog() CLASS TSendMail

   if !empty( ::oDlg )
      ::oDlg:end()
   end if 

RETURN ( self )

//--------------------------------------------------------------------------//
