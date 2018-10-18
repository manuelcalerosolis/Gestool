#include "FiveWin.Ch"
#include "Factu.ch" 

#define schemas "http://schemas.microsoft.com/cdo/configuration/"

//---------------------------------------------------------------------------//

CLASS TSendMailCDO

   DATA oController

   DATA mailServer

   DATA cError

   METHOD New( oController ) CONSTRUCTOR
   METHOD End()

   // Envios de los mails------------------------------------------------------

   METHOD sendMail( hMail )

      METHOD setRecipients( oMail, hMail )
      METHOD setRecipientsCC( oMail, cRecipients )
      METHOD setRecipientsCCO( oMail, cRecipients )
      METHOD setAttachment( oMail, hMail )
      METHOD setMessage( oMail, hMail )
      METHOD setSubject( oMail, hMail )

   METHOD getError()       INLINE   ( ::cError )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) 

   local oError
   local oBlock

   ::oController           := oController

   oBlock                  := errorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::mailServer         := win_oleCreateObject( "CDO.Configuration" )
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpserver" ):Value             := ::oController:mailServerHost
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpserverport" ):Value         := ::oController:mailServerPort
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate" ):Value       := ::oController:mailServerAuthenticate
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpusessl" ):Value             := ::oController:mailServerSSL
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/sendusername" ):Value           := ::oController:mailServerUserName
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/sendpassword" ):Value           := ::oController:mailServerPassword
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/sendusing" ):Value              := 2
      ::mailServer:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout"):Value   := 30
      ::mailServer:Fields:Update()

   RECOVER USING oError

      msgStop( "Error al crear el objeto de correo electrónico." + CRLF + ErrorMessage( oError ) )   

   END SEQUENCE

   errorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::mailServer )
      ::mailServer:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD sendMail( hMail ) 

   local oError
   local oBlock
   local oMail
   local lSend             := .t.

   ::cError                := ""

   if empty( ::mailServer )
      RETURN .f.
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      oMail                := win_oleCreateObject( "CDO.Message" )
      oMail:Configuration  := ::mailServer
      oMail:From           := ::oController:mailServerUserName

      ::setRecipients( oMail, hMail )

      ::setAttachment( oMail, hMail )

      ::setRecipientsCC( oMail, hMail )
   
      ::setRecipientsCCO( oMail, hMail )

      ::setMessage( oMail, hMail )

      ::setSubject( oMail, hMail )

      oMail:Send()

   RECOVER USING oError

      lSend                := .f.

      ::cError             := oError:Description

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lSend )

//--------------------------------------------------------------------------//

METHOD setRecipients( oMail, hMail )

   local cItem
   local cMails            := ::oController:getMailsFromHash( hMail )

   if !empty( cMails )
      oMail:To             := cMails
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD setAttachment( oMail, hMail )

   local cItem
   local cAttachments      := ::oController:getFromHash( hMail, "attachments" )      

   if empty( cAttachments )
      RETURN nil
   end if 

   for each cItem in hb_atokens( cAttachments, ";" )

      if file( rtrim( cItem ) )
         oMail:AddAttachment( rtrim( cItem ) )
      else
         msgStop( "File to attachment " + rtrim( cItem ) + " not found." )
     end if 
   next

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD setRecipientsCC( oMail, hMail )

   local cMailsCC          := ::oController:getFromHash( hMail, "mailcc" )      

   if !empty( cMailsCC )
      oMail:Cc             := cMailsCC
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD setRecipientsCCO( oMail, hMail )

   local cMailsCCO         := ::oController:getFromHash( hMail, "mailcco" )      

   if !empty( cMailsCCO )
      oMail:Bcc            := cMailsCCO
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD setMessage( oMail, hMail )

   local cMessage          := ::oController:getFromHash( hMail, "message" )      

   if !empty( cMessage )
      oMail:HTMLBody       := cMessage // CreateMHTMLBody( cMessage )
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD setSubject( oMail, hMail )

   local cSubject          := ::oController:getSubjectFromHash( hMail )      

   if !empty( cSubject )
      oMail:Subject        := cSubject
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

