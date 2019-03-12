#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TSendMailOutlook

   DATA oSender

   DATA mailServer

   METHOD New( oSender )

   METHOD End()                        VIRTUAL

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD sendMail( hMail ) 

   local oMail
   local oError
   local oBlock
   local lSend          := .t.

   if empty( ::mailServer )
      RETURN ( .f. )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      oMail             := ::mailServer:CreateItem( 0 ) // olMailItem 

      ::setRecipients( oMail, hMail )

      ::setAttachment( oMail, hMail )

      ::setRecipientsCC( oMail, hMail )

      ::setRecipientsCCO( oMail, hMail )

      ::setMessage( oMail, hMail )

      ::setSubject( oMail, hMail )

      oMail:Send()

   RECOVER USING oError

      lSend             := .f.

      msgStop( "Error al enviar el objeto de correo electrónico." + CRLF + ErrorMessage( oError ) )   

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lSend )

//--------------------------------------------------------------------------//

METHOD setRecipients( oMail, hMail )

   local cItem
   local cMails            := ::oSender:getFromHash( hMail, "mail" )

   if !empty( cMails )
      for each cItem in hb_aTokens( cMails, ";" )
         oMail:Recipients:Add( cItem )  
      next
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD setAttachment( oMail, hMail )

   local cItem
   local cAttachments      := ::oSender:getFromHash( hMail, "attachments" )      

   if empty( cAttachments )
      RETURN nil
   end if

   for each cItem in hb_aTokens( cAttachments, ";" )
      if file( rtrim( cItem ) )
         oMail:Attachments:Add( rtrim( cItem ) )
      else
         msgStop( "File to attachment " + rtrim( cItem ) + " not found" )         
      end if 
   next

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD setRecipientsCC( oMail, hMail )

   local cItem
   local oRecipient
   local cMailsCC          := ::oSender:getFromHash( hMail, "mailcc" )      

   if !empty( cMailsCC )
      for each cItem in hb_aTokens( cMailsCC, ";" )
         oRecipient        := oMail:Recipients:Add( cItem ) 
         oRecipient:Type   := 2 
      next
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD setRecipientsCCO( oMail, hMail )

   local cItem
   local oRecipient
   local cMailsCCO         := ::oSender:getFromHash( hMail, "mailcco" )      

   if !empty( cMailsCCO )
      for each cItem in hb_aTokens( cMailsCCO, ";" )
         oRecipient        := oMail:Recipients:Add( cItem ) 
         oRecipient:Type   := 3
      next
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD setMessage( oMail, hMail )

   local cMessage          := ::oSender:getFromHash( hMail, "message" )      

   if !empty( cMessage )
      oMail:BodyFormat     := 2 // olFormatHTML 
      oMail:HTMLBody       := cMessage
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD setSubject( oMail, hMail )

   local cItem
   local cSubject          := ::oSender:getSubjectFromHash( hMail )      

   if !empty( cSubject )
      oMail:Subject        := cSubject
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD build() 

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

RETURN ( !empty( ::mailServer ) )   

//--------------------------------------------------------------------------//