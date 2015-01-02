#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TSendMail

   DATA oSender
   DATA nView

   DATA lCancel               INIT .f.

   DATA mailServer

   DATA mailServerHost        
   DATA mailServerPort    
   DATA mailServerUserName
   DATA mailServerPassword
   DATA mailServerConCopia
   DATA mailServerAuthenticate
   
   METHOD New( oSender )

   // Metodos para controlar la vista

   METHOD setView( nView )    INLINE ( ::nView  := nView )
   METHOD getView()           INLINE ( ::nView )
   METHOD getTime()           INLINE ( val( ::oSender:cTiempo ) )
   METHOD setButtonCancel()   
   METHOD setButtonEnd()      

   // Metodos para manejar el metter

   METHOD setMeterTotal( nTotal );
                              INLINE ( iif( !empty( ::oSender ), ::oSender:setMeterTotal( nTotal ), ) )
   METHOD setMeter( nSet )    INLINE ( iif( !empty( ::oSender ), ::oSender:setMeter( nSet ), ) )

   // Metodos para mostrar la informacion

   METHOD messenger( cText )  INLINE ( iif(  !empty( ::oSender ),;
                                             ::oSender:oTree:Select( ::oSender:oTree:Add( cText) ),;
                                             ) )
   METHOD deleteMessenger( cText );
                              INLINE ( iif( !empty( ::oSender ), ::oSender:oTree:deleteAll(), ) )

   METHOD initMessage()       INLINE ( ::deleteMessenger(),;
                                       ::messenger( "Se ha iniciado el proceso de envio" ) )
   METHOD sendMessage( hMail) INLINE ( ::messenger( "Se ha enviado el correo electrónico " + ::getMailsFromHash( hMail ) ) )
   METHOD endMessage()        INLINE ( iif(  ::lCancel,;
                                             ::messenger( "El envio ha sido cancelado por el usuario" ),;
                                             ::messenger( "El proceso de envio ha finalizado" ) ) )

   // Envios de los mails

   METHOD sendList( aMails )

   METHOD sendMail( hMail )
      METHOD sendJMailServer( hMail )
      METHOD setRecipientsJMailServer( oMail, hMail )
      METHOD setAttachmentJmailServer( oMail, hMail )

      METHOD sendOutlookServer( hMail ) 
         METHOD setRecipientsOutlookServer( oMail, hMail )
         METHOD setRecipientsCCOutlookServer( oMail, cRecipients )
         METHOD setAttachmentOutlookServer( oMail, hMail )
         METHOD setMessageOutlookServer( oMail, hMail )
         METHOD setSubjectOutlookServer( oMail, hMail )

   // Construir objetos para envio de mails

   METHOD buildMailerObject()
      METHOD buildOutlookServer()
      METHOD buildJMailServer()
   METHOD endMailerObject()   INLINE ( iif( !empty( ::mailServer ), ::mailServer:end(), ) )

   // Utilidades

   METHOD isMailServer()      INLINE ( !empty( ::mailServerHost ) .and. !empty( ::mailServerUserName ) .and. !empty( ::mailServerPassword ) )
   METHOD mailServerString()  INLINE ( ::mailServer + if( !empty( ::mailServerPort ), ":" + alltrim( str( ::mailServerPort ) ), "" ) )

   METHOD getMailsFromHash( hMail ) ;
                              INLINE ( iif( hhaskey( hMail, "mail" ), hGet( hMail, "mail" ), nil ) )      
   
   METHOD getMensajeHTML()    INLINE ( "<HTML>" + strtran( alltrim( ::oSender:cGetMensaje ), CRLF, "<p>" ) + "</HTML>" )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TSendMail

   ::mailServerHost           := Rtrim( uFieldEmpresa( "cSrvMai" ) )
   ::mailServerPort           := uFieldEmpresa( "nPrtMai" )
   ::mailServerUserName       := Rtrim( uFieldEmpresa( "cCtaMai" ) )
   ::mailServerPassword       := Rtrim( uFieldEmpresa( "cPssMai" ) )
   ::mailServerConCopia       := Rtrim( uFieldEmpresa( "cCcpMai" ) )
   ::mailServerAuthenticate   := uFieldEmpresa( "lAutMai")

   if !empty( oSender )
      ::oSender               := oSender
      ::setView( oSender:nView )
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD sendList( aMails ) CLASS TSendMail

   local hMail

   CursorWait()

   ::setButtonCancel()
   ::setMeterTotal( len( aMails ) )

   ::initMessage()

   if ::buildMailerObject()

      for each hMail in aMails
         if ::sendMail( hMail )
            ::sendMessage( hMail )
         end if
         ::setMeter( hb_EnumIndex() ) 
      next 

   end if 

   ::endMessage()
   ::setButtonEnd()

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD sendMail( hMail ) CLASS TSendMail

   local lSendMail   := .f.

   if ::isMailServer()
      lSendMail      := ::sendJMailServer( hMail )
   else
      lSendMail      := ::sendOutlookServer( hMail )
   end if

Return ( lSendMail )

//--------------------------------------------------------------------------//

METHOD sendJMailServer( hMail ) CLASS TSendMail

   local oMail
   local cItem
   local cMails     
   local cMessage             
   local cAttachment
   local lSendMail 

   local aFiles
   local nPriority := 1
   local lNoAuth
   local nTimeOut
   local cReplyTo
   local lTLS, cSMTPPass, cCharset, cEncoding, cClientHost, xCC, xBCC

   oMail                := win_oleCreateObject( "CDO.Message" )
   oMail:Configuration  := ::mailServer 
   oMail:From           := "mcalero@zemtrum.es"

/*
   ::setRecipientsJMailServer( oMail, hMail )

   oMail:Subject        := "Test"
   oMail:MDNRequested   := .t.
   oMail:TextBody       := "cMensaje"
*/
      ::setRecipientsJMailServer( oMail, hMail )

      ::setAttachmentJmailServer( oMail, hMail )

      //::setRecipientsCCOutlookServer( oMail, hMail )

      //::setMessageOutlookServer( oMail, hMail )

      ::setSubjectOutlookServer( oMail, hMail )

   oMail:Send()

Return .t.

//--------------------------------------------------------------------------//

METHOD setRecipientsJMailServer( oMail, hMail )

   local cMails

   cMails                  := ::getMailsFromHash( hMail )
   if !empty( cMails )
      oMail:To             := cMails
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setAttachmentJmailServer( oMail, hMail )

   local cItem
   local cAttachments

   if hhaskey( hMail, "attachments" )
      cAttachments         := hGet( hMail, "attachments" )      
   end if 

   if !empty( cAttachments )
      for each cItem in hb_aTokens( cAttachments, ";" )
         if file( rtrim( cItem ) )
            msgAlert( rtrim( cItem ) )
            oMail:AddAttachment( rtrim( cItem ) )
         end if 
      next
   end if

Return ( nil )

//--------------------------------------------------------------------------//



METHOD sendOutlookServer( hMail)

   local oMail
   local oError
   local oBlock
   local lSend          := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      oMail             := ::mailServer:CreateItem( 0 ) // olMailItem 

      ::setRecipientsOutlookServer( oMail, hMail )

      ::setAttachmentOutlookServer( oMail, hMail )

      ::setRecipientsCCOutlookServer( oMail, hMail )

      ::setMessageOutlookServer( oMail, hMail )

      ::setSubjectOutlookServer( oMail, hMail )

      oMail:Display()

   RECOVER USING oError

      lSend             := .f.

      msgStop( "Error al enviar el objeto de correo electrónico." + CRLF + ErrorMessage( oError ) )   

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lSend )

//--------------------------------------------------------------------------//

METHOD setRecipientsOutlookServer( oMail, hMail )

   local cItem
   local cMails

   cMails                  := ::getMailsFromHash( hMail )
   if !empty( cMails )
      for each cItem in hb_aTokens( cMails, ";" )
         oMail:Recipients:Add( cItem )  
      next
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setAttachmentOutlookServer( oMail, hMail )

   local cItem
   local cAttachments

   if hhaskey( hMail, "attachments" )
      cAttachments         := hGet( hMail, "attachments" )      
   end if 

   if !empty( cAttachments )
      for each cItem in hb_aTokens( cAttachments, ";" )
         if file( rtrim( cItem ) )
            oMail:Attachments:Add( rtrim( cItem ) )
         end if 
      next
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setRecipientsCCOutlookServer( oMail, hMail )

   local cItem
   local cMailsCC
   local oRecipient

   if hhaskey( hMail, "mailcc" )
      cMailsCC             := hGet( hMail, "mailcc" )      
   end if 

   if !empty( cMailsCC )
      for each cItem in hb_aTokens( cMailsCC, ";" )
         oRecipient        := oMail:Recipients:Add( cItem ) 
         oRecipient:Type   := 2 
      next
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setMessageOutlookServer( oMail, hMail )

   local cMessage

   if hhaskey( hMail, "message" )
      cMessage             := hGet( hMail, "message" )      
   end if 

   if !empty( cMessage )
      oMail:BodyFormat     := 2 // olFormatHTML 
      oMail:HTMLBody       := cMessage
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setSubjectOutlookServer( oMail, hMail )

   local cItem
   local cSubject

   if hhaskey( hMail, "subject" )
      cSubject             := hGet( hMail, "subject" )      
   end if 

   if !empty( cSubject )
      oMail:Subject        := cSubject
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setButtonCancel() CLASS TSendMail

   if !empty( ::oSender )
      ::oSender:oBtnCancel:bAction := {|| ::lCancel := .t. }
   end if 

Return ( self )

//--------------------------------------------------------------------------//

METHOD setButtonEnd() CLASS TSendMail

   if !empty( ::oSender )
      ::oSender:oBtnCancel:bAction := {|| ::oSender:oDlg:End() } 
   end if 

Return ( self )

//--------------------------------------------------------------------------//

METHOD buildMailerObject() CLASS TSendMail

   local lBuild

   if ::isMailServer()
      lBuild   := ::buildJMailServer()
   else
      lBuild   := ::buildOutlookServer()
   end if 

Return ( lBuild )

//--------------------------------------------------------------------------//

METHOD buildOutlookServer() CLASS TSendMail

   local oBlock
   local oError

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::mailServer   := win_oleCreateObject( "Outlook.Application" )

      if empty( ::mailServer )
         msgStop( "Error. MS Outlook no disponible.", win_oleErrorText() )
      end if 

   RECOVER USING oError

      msgStop( "Error al crear el objeto de correo electrónico." + CRLF + ErrorMessage( oError ) )   

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( !empty( ::mailServer ) )   

//--------------------------------------------------------------------------//

METHOD buildJMailServer() CLASS TSendMail

   local oError
   local oBlock

   oBlock                              := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::mailServer                     := win_oleCreateObject( "CDO.Configuration" )
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpserver" ):Value      := ::mailServerHost
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpserverport" ):Value  := ::mailServerPort
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/sendusing" ):Value       := 2
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate" ):Value := ::mailServerAuthenticate
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpusessl" ):Value      := .f.
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/sendusername" ):Value    := ::mailServerUserName
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/sendpassword" ):Value    := ::mailServerPassword
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout"):Value := 30

      ::mailServer:Fields:Update()

   RECOVER USING oError

      msgStop( "Error al crear el objeto de correo electrónico." + CRLF + ErrorMessage( oError ) )   

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( !empty( ::mailServer ) )   

//--------------------------------------------------------------------------//



