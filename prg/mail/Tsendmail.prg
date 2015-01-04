#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TSendMail

   DATA oSender

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
   METHOD sendMail( hMail )   INLINE ( iif( !empty( ::mailServer ), ::mailServer:sendMail( hMail ), ) )   

   // Construir objetos para envio de mails

   METHOD buildMailerObject()

   // Utilidades

   METHOD isMailServer()      INLINE ( .f. )
   // METHOD isMailServer()      INLINE ( !empty( ::mailServerHost ) .and. !empty( ::mailServerUserName ) .and. !empty( ::mailServerPassword ) )
   METHOD mailServerString()  INLINE ( ::mailServer + if( !empty( ::mailServerPort ), ":" + alltrim( str( ::mailServerPort ) ), "" ) )
   METHOD getMensajeHTML()    INLINE ( "<HTML>" + strtran( alltrim( ::oSender:cGetMensaje ), CRLF, "<p>" ) + "</HTML>" )


   METHOD getFromHash( hMail, cKey ) ;
                              INLINE ( iif( hhaskey( hMail, cKey ), hGet( hMail, cKey ), nil ) )      

   METHOD getMailsFromHash( hMail ) ;
                              INLINE ( ::getFromHash( hMail, "mail" ) )      

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

   if ::isMailServer()
      ::mailServer   := TSendMailCDO():New( self )
   else
      ::mailServer   := TSendMailOutlook():New( self )
   end if 

Return ( !empty( ::mailServer ) )

//--------------------------------------------------------------------------//
