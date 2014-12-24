#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TSendMail

   DATA oSender
   DATA nView

   DATA lCancel               INIT .f.

   METHOD New( oSender )

   METHOD setView( nView )    INLINE ( ::nView  := nView )
   METHOD getView()           INLINE ( ::nView )
   METHOD getTime()           INLINE ( val( ::oSender:cTiempo ) )
   METHOD setButtonCancel()   
   METHOD setButtonEnd()      
   METHOD setMeterTotal( nTotal );
                              INLINE ( ::oSender:setMeterTotal( nTotal ) )
   METHOD setMeter( nSet )    INLINE ( ::oSender:setMeter( nSet ) )

   METHOD initMessage()       INLINE ( ::oSender:oTree:Select( ::oSender:oTree:Add( "Se ha iniciado el proceso de envio" ) ) )
   METHOD endMessage()        INLINE ( iif(  ::lCancel,;
                                             ::oSender:oTree:Select( ::oSender:oTree:Add( "El envio ha sido cancelado por el usuario" ) ),;
                                             ::oSender:oTree:Select( ::oSender:oTree:Add( "El proceso de envio ha finalizado" ) ) ) )

   METHOD sendList( aMails )
   METHOD sendMail( hMail )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TSendMail

   ::oSender  := oSender

   ::setView( oSender:nView )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD sendList( aMails ) CLASS TSendMail

   local hMail

   CursorWait()

   ::setButtonCancel()
   ::setMeterTotal( len( aMails ) )

   ::initMessage()

   for each hMail in aMails
      ::sendMail( hMail )
      ::setMeter( hb_EnumIndex() ) 
   next 

   ::endMessage()
   ::setButtonEnd()

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD sendMail( hMail ) CLASS TSendMail

   msgAlert( valtoprg( hMail ) )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD setButtonCancel()

   ::oSender:oBtnCancel:bAction := {|| ::lCancel := .t. }

Return ( self )

//--------------------------------------------------------------------------//

METHOD setButtonEnd()

   ::oSender:oBtnCancel:bAction := {|| ::oSender:oDlg:End() } 

Return ( self )

//--------------------------------------------------------------------------//




