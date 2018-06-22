#include "FiveWin.Ch"
#include "Factu.ch" 

static oDelegation

//----------------------------------------------------------------------------//

CLASS DelegationManager

   DATA id                       INIT 0
   DATA uuid                     INIT ""
   DATA codigo                   INIT ""
   DATA nombre                   INIT ""
   DATA almacenUuid              INIT ""
   DATA sistema                  INIT 0

   METHOD New()

   METHOD Set( hDelegation )     INLINE ( ::guard( hDelegation ) )
   METHOD Guard( hDelegation )

   METHOD guardWhereUuid( uuid )
   
   METHOD guardWhereNombre( cNombre )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( hDelegation )

   if !empty( hDelegation )
      ::guard( hDelegation )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guard( hDelegation )

   if !hb_ishash( hDelegation )
      RETURN ( self )
   end if 

   if hhaskey( hDelegation, "id" )
      ::id           := hget( hDelegation, "id" ) 
   end if 

   if hhaskey( hDelegation, "uuid" )
      ::uuid         := hget( hDelegation, "uuid" ) 
   end if 

   if hhaskey( hDelegation, "codigo" )
      ::codigo       := hget( hDelegation, "codigo" ) 
   end if 
   
   if hhaskey( hDelegation, "nombre" )
      ::nombre       := hget( hDelegation, "nombre" ) 
   end if 

   if hhaskey( hDelegation, "almacen_uuid" )
      ::almacenUuid  := hget( hDelegation, "almacen_uuid" ) 
   end if 

   if hhaskey( hDelegation, "sistema" )
      ::sistema      := hget( hDelegation, "sistema" ) 
   end if 

   setAlmacenMessageBar( ::nombre )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereUuid( uuid )

   local hDelegation    := SQLCajasModel():getWhereUuid( Uuid )

   if hb_ishash( hDelegation )
      ::guard( hDelegation )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereNombre( cNombre )

   local hDelegation    := SQLCajasModel():getWhereNombre( cNombre )

   if hb_ishash( hDelegation )
      ::guard( hDelegation )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION Delegation( hDelegation )

   if empty( oDelegation )
      oDelegation       := DelegationManager():New() 
   end if

   if !empty( hDelegation )
      oDelegation:Guard( hDelegation )
   end if 

RETURN ( oDelegation )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

