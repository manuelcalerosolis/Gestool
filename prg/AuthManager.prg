#include "FiveWin.Ch"
#include "Factu.ch" 

Static oAuth

//----------------------------------------------------------------------------//

CLASS AuthManager

   DATA id
   DATA uuid
   DATA nombre
   DATA codigo
   DATA email
   DATA password
   DATA rolUuid

   METHOD New()

   METHOD set( hUser )        INLINE ( ::guard( hUser ) )
   METHOD guard( hUser )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( hUser )

   if !empty( hUser )
      ::guard( hUser )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guard( hUser )

   if !hb_ishash( hUser )
      RETURN ( self )
   end if 

   if hhaskey( hUser, "id" )
      ::id        := hget( hUser, "id" ) 
   end if 

   if hhaskey( hUser, "uuid" )
      ::uuid      := hget( hUser, "uuid" ) 
   end if 
   
   if hhaskey( hUser, "nombre" )
      ::nombre    := hget( hUser, "nombre" ) 
   end if 

   if hhaskey( hUser, "codigo" )
      ::codigo    := hget( hUser, "codigo" ) 
   end if 

   if hhaskey( hUser, "email" )
      ::email     := hget( hUser, "email" ) 
   end if 

   if hhaskey( hUser, "password" )
      ::password  := hget( hUser, "password" ) 
   end if 

   if hhaskey( hUser, "rol_uuid" )
      ::rolUuid   := hget( hUser, "rol_uuid" ) 
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION Auth( hUser )

   if oAuth == nil
      oAuth := AuthManager():New( hUser )
   end if

RETURN ( oAuth )

//--------------------------------------------------------------------------//

