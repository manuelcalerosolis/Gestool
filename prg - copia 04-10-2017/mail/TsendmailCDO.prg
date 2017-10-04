#include "FiveWin.Ch"
#include "Factu.ch" 

#define schemas "http://schemas.microsoft.com/cdo/configuration/"

//---------------------------------------------------------------------------//

CLASS TSendMailCDO

   DATA oSender

   DATA mailServer

   METHOD New( oSender )

   // Construir objetos para envio de mails

   METHOD build()

   // Envios de los mails

   METHOD sendMail( hMail )

      METHOD setRecipients( oMail, hMail )
      METHOD setRecipientsCC( oMail, cRecipients )
      METHOD setRecipientsCCO( oMail, cRecipients )
      METHOD setAttachment( oMail, hMail )
      METHOD setMessage( oMail, hMail )
      METHOD setSubject( oMail, hMail )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) 

   ::oSender         := oSender

   ::build()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD sendMail( hMail ) 

   local oError
   local oBlock
   local oMail
   local lSend             := .t.

   if empty( ::mailServer )
      return .f.
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      oMail                := win_oleCreateObject( "CDO.Message" )
      oMail:Configuration  := ::mailServer
      oMail:From           := ::oSender:mailServerUserName

      ::setRecipients( oMail, hMail )

      ::setAttachment( oMail, hMail )

      ::setRecipientsCC( oMail, hMail )
   
      ::setRecipientsCCO( oMail, hMail )

      ::setMessage( oMail, hMail )

      ::setSubject( oMail, hMail )

      oMail:Send()

   RECOVER USING oError

      lSend                := .f.

      msgStop( "Error al enviar el objeto de correo electrónico." + CRLF + ErrorMessage( oError ) )   

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lSend )

//--------------------------------------------------------------------------//

METHOD setRecipients( oMail, hMail )

   local cItem
   local cMails            := ::oSender:getMailsFromHash( hMail )

   if !empty( cMails )
      oMail:To             := cMails
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setAttachment( oMail, hMail )

   local cItem
   local cAttachments      := ::oSender:getFromHash( hMail, "attachments" )      

   if empty( cAttachments )
      return nil
   end if 

   for each cItem in hb_aTokens( cAttachments, ";" )

      if file( rtrim( cItem ) )
         oMail:AddAttachment( rtrim( cItem ) )
      else
         msgStop( "File to attachment " + rtrim( cItem ) + " not found." )
     end if 
   next

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setRecipientsCC( oMail, hMail )

   local cMailsCC          := ::oSender:getFromHash( hMail, "mailcc" )      

   if !empty( cMailsCC )
      oMail:Cc             := cMailsCC
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setRecipientsCCO( oMail, hMail )

   local cMailsCCO         := ::oSender:getFromHash( hMail, "mailcco" )      

   if !empty( cMailsCCO )
      oMail:Bcc            := cMailsCCO
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setMessage( oMail, hMail )

   local cMessage          := ::oSender:getFromHash( hMail, "message" )      

   if !empty( cMessage )
      oMail:HTMLBody       := cMessage // CreateMHTMLBody( cMessage )
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setSubject( oMail, hMail )

   local cSubject          := ::oSender:getSubjectFromHash( hMail )      

   if !empty( cSubject )
      oMail:Subject        := cSubject
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD build() 

   local oError
   local oBlock

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::mailServer         := win_oleCreateObject( "CDO.Configuration" )
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpserver" ):Value             := ::oSender:mailServerHost
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpserverport" ):Value         := ::oSender:mailServerPort
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/sendusing" ):Value              := 2
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate" ):Value       := ::oSender:mailServerAuthenticate
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpusessl" ):Value             := ::oSender:mailServerSSL
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/sendusername" ):Value           := ::oSender:mailServerUserName
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/sendpassword" ):Value           := ::oSender:mailServerPassword
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout"):Value   := 30
      ::mailServer:Fields:Update()

   RECOVER USING oError

      msgStop( "Error al crear el objeto de correo electrónico." + CRLF + ErrorMessage( oError ) )   

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( !empty( ::mailServer ) )   

//--------------------------------------------------------------------------//