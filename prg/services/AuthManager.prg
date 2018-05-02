#include "FiveWin.Ch"
#include "Factu.ch" 

static oAuth

//----------------------------------------------------------------------------//

CLASS AuthManager

   DATA id                       INIT 0
   DATA uuid                     INIT ""
   DATA nombre                   INIT ""
   DATA codigo                   INIT ""
   DATA email                    INIT ""
   DATA password                 INIT ""
   DATA rolUuid                  INIT ""

   METHOD New()

   METHOD Set( hUser )           INLINE ( ::guard( hUser ) )
   METHOD Guard( hUser )
   METHOD Level( nOption )

   METHOD guardWhereUuid( uuid )
   
   METHOD guardWhereCodigo( cCodigo )

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

METHOD Level( cOption )

   local nLevel   

   if empty( cOption )
      RETURN ( __permission_full__ ) 
   end if 

   if empty( ::rolUuid ) 
      RETURN ( __permission_full__ ) 
   end if 

   nLevel         := PermisosOpcionesRepository():getNivelRol( ::rolUuid, cOption )
   if !empty( nLevel )
      RETURN ( nLevel )
   end if 

RETURN ( __permission_full__ ) 

//---------------------------------------------------------------------------//

METHOD guardWhereUuid( uuid )

   local hUser    := SQLUsuariosModel():getWhereUuid( Uuid )

   if hb_ishash( hUser )
      ::guard( hUser )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereCodigo( cNombre )

   local hUser    := SQLUsuariosModel():getWhereNombre( cNombre )

   if hb_ishash( hUser )
      ::guard( hUser )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION Auth( hUser )

   if empty( oAuth )
      oAuth       := AuthManager():New() 
   end if

   if !empty( hUser )
      oAuth:Guard( hUser )
   end if 

RETURN ( oAuth )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

