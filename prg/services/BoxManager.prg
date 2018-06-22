#include "FiveWin.Ch"
#include "Factu.ch" 

static oBox

//----------------------------------------------------------------------------//

CLASS BoxManager

   DATA id                       INIT 0
   DATA uuid                     INIT ""
   DATA codigo                   INIT ""
   DATA nombre                   INIT ""
   DATA numeroSesion             INIT 1

   METHOD New()

   METHOD Set( hBox )           INLINE ( ::guard( hBox ) )
   METHOD Guard( hBox )

   METHOD guardWhereUuid( uuid )
   
   METHOD guardWhereNombre( cNombre )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( hBox )

   if !empty( hBox )
      ::guard( hBox )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guard( hBox )

   if !hb_ishash( hBox )
      RETURN ( self )
   end if 

   if hhaskey( hBox, "id" )
      ::id           := hget( hBox, "id" ) 
   end if 

   if hhaskey( hBox, "uuid" )
      ::uuid         := hget( hBox, "uuid" ) 
   end if 

   if hhaskey( hBox, "codigo" )
      ::codigo       := hget( hBox, "codigo" ) 
   end if 
   
   if hhaskey( hBox, "nombre" )
      ::nombre       := hget( hBox, "nombre" ) 
   end if 

   if hhaskey( hBox, "numero_sesion" )
      ::numeroSesion := hget( hBox, "numero_sesion" ) 
   end if 

   setCajaMessageBar( ::nombre )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereUuid( uuid )

   local hBox    := SQLCajasModel():getWhereUuid( Uuid )

   if hb_ishash( hBox )
      ::guard( hBox )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereNombre( cNombre )

   local hBox    := SQLCajasModel():getWhereNombre( cNombre )

   if hb_ishash( hBox )
      ::guard( hBox )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION Box( hBox )

   if empty( oBox )
      oBox       := BoxManager():New() 
   end if

   if !empty( hBox )
      oBox:Guard( hBox )
   end if 

RETURN ( oBox )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

