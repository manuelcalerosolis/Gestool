#include "FiveWin.Ch"
#include "Factu.ch" 

#define __admin_name__  "Super administrador"

//----------------------------------------------------------------------------//

static oAuth

//----------------------------------------------------------------------------//

CLASS AuthManager

   DATA id                             INIT 0
   DATA uuid                           INIT ""
   DATA nombre                         INIT ""
   DATA codigo                         INIT ""
   DATA password                       INIT ""
   DATA rolUuid                        INIT ""
   DATA email                          INIT ""
   DATA emailPassword                  INIT ""
   DATA emailServidor                  INIT ""
   DATA emailPuerto                    INIT ""
   DATA autenticacionSMTP              INIT ""
   DATA requiereSSL                    INIT ""
   DATA enviarEmailCopia               INIT ""
   DATA enviarCopiaOculta              INIT ""

   METHOD New()

   METHOD Set( hUser )                 INLINE ( ::guard( hUser ) )

   METHOD Guard( hUser )

   METHOD guardIfUsed( hUser )

   METHOD Level( nOption )

   METHOD isSuperAdminRole()

   METHOD isSuperAdmin()               INLINE ( alltrim( ::nombre ) == __admin_name__ )

   METHOD guardWhereUuid( uuid )
   
   METHOD guardWhereCodigo( cCodigo )

   METHOD canSendMail()

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
      ::id                 := hget( hUser, "id" ) 
   end if 

   if hhaskey( hUser, "uuid" )
      ::uuid               := hget( hUser, "uuid" ) 
   end if 
   
   if hhaskey( hUser, "nombre" )
      ::nombre             := hget( hUser, "nombre" ) 
   end if 

   if hhaskey( hUser, "codigo" )
      ::codigo             := hget( hUser, "codigo" ) 
   end if 

   if hhaskey( hUser, "password" )
      ::password           := hget( hUser, "password" ) 
   end if 

   if hhaskey( hUser, "rol_uuid" )
      ::rolUuid            := hget( hUser, "rol_uuid" ) 
   end if

   if hhaskey( hUser, "email" )
      ::email              := hget( hUser, "email" ) 
   end if 

   if hhaskey( hUser, "email_password" )
      ::emailPassword      := hget( hUser, "email_password" ) 
   end if 

   if hhaskey( hUser, "email_servidor" )
      ::emailServidor      := hget( hUser, "email_servidor" ) 
   end if    

   if hhaskey( hUser, "email_puerto" )
      ::emailPuerto        := hget( hUser, "email_puerto" ) 
   end if 

   if hhaskey( hUser, "autenticacion_smtp" )
      ::autenticacionSMTP   := hget( hUser, "autenticacion_smtp" ) 
   end if 

   if hhaskey( hUser, "requiere_ssl" )
      ::requiereSSL        := hget( hUser, "requiere_ssl" ) 
   end if 

   if hhaskey( hUser, "email_enviar_copia" )
      ::enviarEmailCopia   := hget( hUser, "email_enviar_copia" ) 
   end if 

   if hhaskey( hUser, "email_copia_oculta" )
      ::enviarCopiaOculta   := hget( hUser, "email_copia_oculta" ) 
   end if 
   
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardIfUsed( hUser )

   if ::id == hget( hUser, "id" )
      ::Guard( hUser )
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

METHOD isSuperAdminRole()

   if empty( ::rolUuid ) 
      RETURN ( .f. ) 
   end if 

RETURN ( alltrim( SQLRolesModel():getFieldWhere( "nombre", { "uuid" => ::rolUuid } ) ) == __admin_name__ )

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

METHOD canSendMail()

   if empty( ::email )
      RETURN ( .f. )
   end if 

   if empty( ::emailPassword )
      RETURN ( .f. )
   end if 

   if empty( ::emailServidor )
      RETURN ( .f. )
   end if 

   if empty( ::emailPuerto )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

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

