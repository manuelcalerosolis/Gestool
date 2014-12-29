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
   
   METHOD New( oSender )

   METHOD setView( nView )    INLINE ( ::nView  := nView )
   METHOD getView()           INLINE ( ::nView )
   METHOD getTime()           INLINE ( val( ::oSender:cTiempo ) )
   METHOD setButtonCancel()   
   METHOD setButtonEnd()      
   METHOD setMeterTotal( nTotal );
                              INLINE ( ::oSender:setMeterTotal( nTotal ) )
   METHOD setMeter( nSet )    INLINE ( ::oSender:setMeter( nSet ) )

   METHOD messenger( cText )  INLINE ( iif(  !empty(::oSender:oTree),;
                                             ::oSender:oTree:Select( ::oSender:oTree:Add( cText) ),;
                                             ) )

   METHOD initMessage()       INLINE ( ::messenger( "Se ha iniciado el proceso de envio" ) )
   METHOD endMessage()        INLINE ( iif(  ::lCancel,;
                                             ::messenger( "El envio ha sido cancelado por el usuario" ),;
                                             ::messenger( "El proceso de envio ha finalizado" ) ) )

   METHOD sendList( aMails )
   METHOD sendMail( hMail )
      METHOD sendJMailServer( hMail )
      METHOD sendOutlookServer( hMail ) 
         METHOD setRecipientsOutlookServer( oMail, hMail )
         METHOD setRecipientsCCOutlookServer( oMail, cRecipients )
         METHOD setAttachmentOutlookServer( oMail, hMail )

   METHOD isMailServer()      INLINE ( !empty( ::mailServerHost ) .and. !empty( ::mailServerUserName ) .and. !empty( ::mailServerPassword ) )
   
   METHOD getMensajeHTML()    INLINE ( "<HTML>" + strtran( alltrim( ::oSender:cGetMensaje ), CRLF, "<p>" ) + "</HTML>" )

/*
   METHOD isMailServer()      INLINE ( msgAlert( !empty( ::mailServer ), "!empty( ::mailServer )" ),;
                                       msgAlert( ::mailServer, "::mailServer" ),; 
                                       msgAlert( !empty( ::mailServerUserName ), "!empty( ::mailServerUserName )" ),;
                                       msgAlert( ::mailServerUserName, "::mailServerUserName" ),; 
                                       msgAlert( !empty( ::mailServerPassword ), "!empty( ::mailServerPassword )" ),;
                                       msgAlert( ::mailServerPassword, "::mailServerPassword" ),;
                                       !empty( ::mailServer ) .and. !empty( ::mailServerUserName ) .and. !empty( ::mailServerPassword ) ) 
*/

   METHOD mailServerString()  INLINE ( ::mailServer + if( !empty( ::mailServerPort ), ":" + alltrim( str( ::mailServerPort ) ), "" ) )

   METHOD buildMailerObject()
      METHOD buildOutlookServer()
      METHOD buildJMailServer()
   METHOD endMailerObject()   INLINE ( iif( !empty( ::mailServer ), ::mailServer:end(), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TSendMail

   ::oSender               := oSender

   ::mailServerHost        := Rtrim( uFieldEmpresa( "cSrvMai" ) )
   ::mailServerPort        := uFieldEmpresa( "nPrtMai" )
   ::mailServerUserName    := Rtrim( uFieldEmpresa( "cCtaMai" ) )
   ::mailServerPassword    := Rtrim( uFieldEmpresa( "cPssMai" ) )
   ::mailServerConCopia    := Rtrim( uFieldEmpresa( "cCcpMai" ) )

   ::setView( oSender:nView )

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
         ::sendMail( hMail )
         ::setMeter( hb_EnumIndex() ) 
      next 

   end if 

   ::endMessage()
   ::setButtonEnd()

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD sendMail( hMail ) CLASS TSendMail

   if ::isMailServer()
      ::sendJMailServer( hMail )
   else
      ::sendOutlookServer( hMail )
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD sendJMailServer( hMail ) CLASS TSendMail

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
   local lTLS, cSMTPPass, cCharset, cEncoding, cClientHost

   if hhaskey( hMail, "mail" )
      cMails                  := hGet( hMail, "mail" )      
   end if 

   if hhaskey( hMail, "message" )
      cMessage                := hGet( hMail, "message" )      
   end if 

   if hhaskey( hMail, "attachments" )
      cAttachment             := hGet( hMail, "attachments" )      
   end if 

/*
   msgAlert( cMails )
   msgAlert( cMessage )
   msgAlert( cAttachment )

   msgAlert( hb_SendMail(  "localhost", 587, "mcalero@zemtrum.es", "mcalero@zemtrum.es", , , "cBody", "cSubject", ;
                           aFiles, "mcalero@zemtrum.es", "123456Zx", "pop3.zemtrum.es", nPriority, .t., ;
                           .f., .t., lNoAuth, nTimeOut, cReplyTo, ;
                           lTLS, cSMTPPass, cCharset, cEncoding, cClientHost ), "resultado de envio" )

   msgAlert( hb_SendMail( ::mailServerHost, ::mailServerPort, ::oSender:cGetDe, cMails, , , , ::oSender:cGetAsunto, , ::mailServerUserName, ::mailServerPassword ) )
*/

   if !empty( ::mailServer )

      // ::mailServer:FromName   := rtrim( ::oSender:cGetDe )
      ::mailServer:Subject    := rtrim( ::oSender:cGetAsunto )

      ::mailServer:appendHTML( cMessage )

      if !empty( cMails )
         for each cItem in hb_aTokens( cMails, ";" )
            ::mailServer:AddRecipient( cItem )
         next
      end if

      if !empty( ::cGetPara )
         for each cItem in hb_aTokens( ::cGetPara, ";" )
            ::mailServer:AddRecipient( cItem )
         next
      end if

      if !empty( ::cGetCopia )
         for each cItem in hb_aTokens( ::cGetCopia, ";" )
            ::mailServer:AddRecipientBCC( cItem )
         next
      end if

      if !empty( ::cGetCopia )
         for each cItem in hb_aTokens( ::cGetCopia, ";" )
            ::mailServer:AddRecipientBCC( cItem )
         next
      end if

      if !empty( cAttachment )
         for each cItem in hb_aTokens( cAttachment, ";" )
            if file( rtrim( cItem ) )
               ::mailServer:AddAttachment( rtrim( cItem ) )
            end if 
         next
      end if

      lSendMail            := ::mailServer:Send( ::mailServerString() )

      if !lSendMail
         ::messenger( "Error al enviar correo electrónico." + CRLF + ::mailServer:ErrorMessage )
      else
         ::messenger( "Correo electrónico a " + cMails + " enviado." )
      end if

   end if

Return ( lSendMail )

//--------------------------------------------------------------------------//

METHOD sendOutlookServer( hMail)

   local oMail
   local oError
   local oBlock
   local oRecipient

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      oMail             := ::mailServer:CreateItem( 0 ) // olMailItem 

      ::setRecipientsOutlookServer( oMail, hMail )

      ::setAttachmentOutlookServer( oMail, hMail )

      ::setRecipientsCCOutlookServer( oMail, ::oSender:cGetCopia )

      oMail:Subject     := ::oSender:cGetAsunto

      oMail:BodyFormat  := 2 // olFormatHTML 
      oMail:HTMLBody    := ::GetMensajeHTML()

      oMail:Display()

   RECOVER USING oError

      msgStop( "Error al enviar el objeto de correo electrónico." + CRLF + ErrorMessage( oError ) )   

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( self )

//--------------------------------------------------------------------------//

METHOD setRecipientsOutlookServer( oMail, hMail )

   local cItem
   local cMails
   local oRecipient

   if hhaskey( hMail, "mail" )
      cMails               := hGet( hMail, "mail" )      
   end if 

   if !empty( cMails )
      for each cItem in hb_aTokens( cMails, ";" )
         oRecipient        := oMail:Recipients:Add( cItem )  
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

METHOD setRecipientsCCOutlookServer( oMail, cRecipients )

   local cItem
   local oRecipient

   if !empty( cRecipients )
      for each cItem in hb_aTokens( cRecipients, ";" )
         oRecipient        := oMail:Recipients:Add( cItem ) 
         oRecipient:Type   := 2 
      next
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setButtonCancel() CLASS TSendMail

   ::oSender:oBtnCancel:bAction := {|| ::lCancel := .t. }

Return ( self )

//--------------------------------------------------------------------------//

METHOD setButtonEnd() CLASS TSendMail

   ::oSender:oBtnCancel:bAction := {|| ::oSender:oDlg:End() } 

Return ( self )

//--------------------------------------------------------------------------//

METHOD buildMailerObject() CLASS TSendMail

   if ::isMailServer()
      ::buildJMailServer()
   else
      ::buildOutlookServer()
   end if 

Return ( .t. )

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

   return .t. 

   oBlock                              := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::mailServer                     := win_oleCreateObject( "JMail.Message" )
      ::mailServer:Logging             := .t.
      ::mailServer:Silent              := .t.

      ::mailServer:MailServerUserName  := ::mailServerUserName
      ::mailServer:MailServerPassword  := ::mailServerPassword
      ::mailServer:From                := ::mailServerUserName

      msgAlert(::mailServerUserName, "::mailServerUserName" )

   RECOVER USING oError

      msgStop( "Error al crear el objeto de correo electrónico." + CRLF + ErrorMessage( oError ) )   

      WaitRun( "regsvr32 /s " + fullcurDir() + "JMail.Dll" )

      // ::mailServer                     := win_oleCreateObject( "JMail.Message" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( !empty( ::mailServer ) )   

//--------------------------------------------------------------------------//



