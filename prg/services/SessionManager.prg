#include "FiveWin.Ch"
#include "Factu.ch" 

static oSession

//----------------------------------------------------------------------------//

CLASS SessionManager

   DATA id                          INIT 0
   DATA uuid                        INIT ""
   DATA numero                      INIT 0
   DATA cajaCodigo                  INIT ""
   DATA fechaHoraInicio             
   DATA fechaHoraCierre             

   METHOD New()

   METHOD Set( hSession )           INLINE ( ::guard( hSession ) )
   METHOD Guard( hSession )

   METHOD guardWhereUuid( uuid )
   
   METHOD guardWhereNombre( cNombre )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( hSession )

   if !empty( hSession )
      ::guard( hSession )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guard( hSession )

   if !hb_ishash( hSession )
      RETURN ( self )
   end if 

   if hhaskey( hSession, "id" )
      ::id                 := hget( hSession, "id" ) 
   end if 

   if hhaskey( hSession, "uuid" )
      ::uuid               := hget( hSession, "uuid" ) 
   end if 

   if hhaskey( hSession, "numero" )
      ::numero             := hget( hSession, "numero" ) 
   end if 
   
   if hhaskey( hSession, "caja_codigo" )
      ::cajaCodigo         := hget( hSession, "caja_codigo" ) 
   end if 

   if hhaskey( hSession, "fecha_hora_inicio" )
      ::fechaHoraInicio    := hget( hSession, "fecha_hora_inicio" ) 
   end if 

   if hhaskey( hSession, "fecha_hora_fin" )
      ::fechaHoraFin       := hget( hSession, "fecha_hora_fin" ) 
   end if 

   setSesionMessageBar( ::numero )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereUuid( uuid )

   local hSession    := SQLSesionesModel():getWhereUuid( Uuid )

   if hb_ishash( hSession )
      ::guard( hSession )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereNombre( cNombre )

   local hSession    := SQLSesionesModel():getWhereNombre( cNombre )

   if hb_ishash( hSession )
      ::guard( hSession )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION Session( hSession )

   if empty( oSession )
      oSession       := SessionManager():New() 
   end if

   if !empty( hSession )
      oSession:Guard( hSession )
   end if 

RETURN ( oSession )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

