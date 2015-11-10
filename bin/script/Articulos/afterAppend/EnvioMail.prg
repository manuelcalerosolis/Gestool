#include "hbclass.ch"

#define CRLF                        chr( 13 ) + chr( 10 )

#define __mail__                    "praposo@zemtrum.es"

//---------------------------------------------------------------------------//

Function EnvioMail( aTmp, nView )

   local cMensajeMail   := ""
   local hMail          := {=>}

   // Envío de  mail al usuario----------------------------------------------

   /*hSet( hMail, "mail", __mail__ )
   hSet( hMail, "subject", "Nuevo producto " + alltrim( aTmp[ 1 ] ) + "" )
   hSet( hMail, "message", "Nuevo producto agregado " + alltrim( aTmp[ 1 ] ) + ", " + alltrim( aTmp[ 2 ] ) )

   with object TSendMail():New()
      if :buildMailerObject()
         :sendMail( hMail )
      end if 
   end with

   msgAlert( "Mail enviado" )*/

Return ( nil )

//---------------------------------------------------------------------------//

