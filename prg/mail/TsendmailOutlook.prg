#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TSendMailOutlook

   DATA oSender

   DATA mailServer

   METHOD New( oSender )
   METHOD end()               INLINE ( iif( !empty( ::mailServer ), ::mailServer:end(), ) )

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

   if !empty( oSender )
      ::oSender               := oSender
   end if 

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
   local cMails            := ::oSender:getMailsFromHash( hMail )
   
   if !empty( cMails )
      for each cItem in hb_aTokens( cMails, ";" )
         oMail:Recipients:Add( cItem )  
      next
   end if

Return ( nil )

//--------------------------------------------------------------------------//

METHOD setAttachmentServer( oMail, hMail )

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

METHOD setRecipientsCCServer( oMail, hMail )

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

METHOD setMessageServer( oMail, hMail )

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

METHOD setSubjectServer( oMail, hMail )

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

METHOD buildServer() 

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