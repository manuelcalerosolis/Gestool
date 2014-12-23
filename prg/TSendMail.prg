#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TSendMail

   DATA oSender
   DATA nView

   DATA lCancel               INIT .f.

   METHOD New( oSender )

   METHOD setView( oSender )  INLINE ( ::nView  := oSender:nView )
   METHOD getView()           INLINE ( ::nView )
   METHOD getTime()           INLINE ( val( ::oSender:cTiempo ) )
   METHOD setButtonCancel()   INLINE ( ::oSender:oBtnCancel:bAction := {|| ::lCancel := .t. } )
   METHOD setButtonEnd()      INLINE ( ::oSender:oBtnCancel:bAction := {|| ::oSender:oDlg:End() } )
   METHOD setMeterTotal( nTotal );
                              INLINE ( ::oSender:setMeterTotal( nTotal ) )
   METHOD setMeter( nSet )    INLINE ( ::oSender:setMeter( nSet ) )

   METHOD initMessage()       INLINE ( ::oSender:oTree:Select( ::oSender:oTree:Add( "Se ha iniciado el proceso de envio" ) ) )
   METHOD endMessage()        INLINE ( iff( ::lCancel,;
                                       ::oSender:oTree:Select( ::oSender:oTree:Add( "El envio ha sido cancelado por el usuario" ) ),;
                                       ::oSender:oTree:Select( ::oSender:oTree:Add( "El proceso de envio ha finalizado" ) ) ) )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TSendMail

   ::oSender  := oSender

   ::setView( oSender )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD sendMailClients() CLASS TSendMail

   CursorWait()

   ::setButtonCancel()
   ::setMeterTotal( ( D():Clientes( ::nView ) )->( OrdKeyCount() ) )

   ::initMessage()

   ( D():Clientes( ::nView ) )->( dbGoTop() )
   while !::lCancel .and. !( D():Clientes( ::nView ) )->( eof() )

      if ( D():Clientes( ::nView ) )->lMail .and. !Empty( ( D():Clientes( ::nView ) )->cMeiInt )
         ::lBuildMail()
      end if

      ( D():Clientes( ::nView ) )->( dbSkip() )

      ::setMeter( ( D():Clientes( ::nView ) )->( OrdKeyNo() ) )

   end do

   ::endMessage()
   ::setButtonEnd()

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//



