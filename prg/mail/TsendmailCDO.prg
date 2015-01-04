#include "FiveWin.Ch"
#include "Factu.ch" 

#define schemas "http://schemas.microsoft.com/cdo/configuration/"

//---------------------------------------------------------------------------//

CLASS TSendMailCDO

   DATA oSender

   DATA mailServer

   METHOD New( oSender )

   // Construir objetos para envio de mails

   METHOD buildServer()

   // Envios de los mails

   METHOD sendMail( hMail )

      METHOD sendServer( hMail ) 
         METHOD setRecipientsServer( oMail, hMail )
         METHOD setRecipientsCCServer( oMail, cRecipients )
         METHOD setAttachmentServer( oMail, hMail )
         METHOD setMessageServer( oMail, hMail )
         METHOD setSubjectServer( oMail, hMail )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) 

   ::oSender         := oSender

   ::buildServer()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD sendMail( hMail ) 

   local lSendMail   := .f.

   if !empty( ::mailServer )
      lSendMail      := ::sendServer( hMail )
   end if

Return ( lSendMail )

//--------------------------------------------------------------------------//

METHOD sendServer( hMail)

   local oMail
   local oError
   local oBlock
   local lSend          := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      oMail             := ::mailServer:CreateItem( 0 ) // olMailItem 

      ::setRecipientsServer( oMail, hMail )

      ::setAttachmentServer( oMail, hMail )

      ::setRecipientsCCServer( oMail, hMail )

      ::setMessageServer( oMail, hMail )

      ::setSubjectServer( oMail, hMail )

      oMail:Display()

   RECOVER USING oError

      lSend             := .f.

      msgStop( "Error al enviar el objeto de correo electrónico." + CRLF + ErrorMessage( oError ) )   

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lSend )

//--------------------------------------------------------------------------//

METHOD setRecipientsServer( oMail, hMail )

   local cItem
   local cMails            := ::oSender:getFromHash( hMail, "mail" )

   if !empty( cMails )
      oMail:To             := cMails
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setAttachmentServer( oMail, hMail )

   local cItem
   local cAttachments      := ::oSender:getFromHash( hMail, "attachments" )      

   if !empty( cAttachments )
      for each cItem in hb_aTokens( cAttachments, ";" )
         if file( rtrim( cItem ) )
            oMail:AddAttachments( rtrim( cItem ) )
         end if 
      next
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setRecipientsCCServer( oMail, hMail )

   local cItem
   local oRecipient
   local cMailsCC          := ::oSender:getFromHash( hMail, "mailcc" )      

   if !empty( cMailsCC )
      for each cItem in hb_aTokens( cMailsCC, ";" )
         oRecipient        := oMail:Recipients:Add( cItem ) 
         oRecipient:Type   := 2 
      next
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setMessageServer( oMail, hMail )

   local cMessage          := ::oSender:getFromHash( hMail, "message" )      

   if !empty( cMessage )
      oMail:BodyFormat     := 2 // olFormatHTML 
      oMail:HTMLBody       := cMessage
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setSubjectServer( oMail, hMail )

   local cItem
   local cSubject          := ::oSender:getFromHash( hMail, "subject" )      

   if !empty( cSubject )
      oMail:Subject        := cSubject
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD buildServer() 

   local oError
   local oBlock

   oBlock                              := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::mailServer                     := win_oleCreateObject( "CDO.Configuration" )
      ::mailServer:Fields:Item( schemas + "smtpserver" ):Value             := ::oSender:mailServerHost
      ::mailServer:Fields:Item( schemas + "smtpserverport" ):Value         := ::oSender:mailServerPort
      ::mailServer:Fields:Item( schemas + "sendusing" ):Value              := 2
      ::mailServer:Fields:Item( schemas + "smtpauthenticate" ):Value       := ::oSender:mailServerAuthenticate
      ::mailServer:Fields:Item( schemas + "smtpusessl" ):Value             := .f.
      ::mailServer:Fields:Item( schemas + "sendusername" ):Value           := ::oSender:mailServerUserName
      ::mailServer:Fields:Item( schemas + "sendpassword" ):Value           := ::oSender:mailServerPassword
      ::mailServer:Fields:Item( schemas + "smtpconnectiontimeout"):Value   := 30

      ::mailServer:Fields:Update()

   RECOVER USING oError

      msgStop( "Error al crear el objeto de correo electrónico." + CRLF + ErrorMessage( oError ) )   

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( !empty( ::mailServer ) )   

//--------------------------------------------------------------------------//