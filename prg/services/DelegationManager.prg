#include "FiveWin.Ch"
#include "Factu.ch" 

static oDelegation

//----------------------------------------------------------------------------//

CLASS DelegationManager

   DATA id                       INIT 0
   DATA uuid                     INIT ""
   DATA codigo                   INIT ""
   DATA nombre                   INIT ""
   DATA parentUuid               INIT ""

   METHOD New()

   METHOD Set( hDelegation )     INLINE ( ::guard( hDelegation ) )
   METHOD Guard( hDelegation )

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

   if hhaskey( hDelegation, "parent_uuid" )
      ::parentUuid   := hget( hDelegation, "parent_uuid" ) 
   end if 

   setDelegacionMessageBar( ::nombre )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereNombre( cNombre, uuidParent )

   local hDelegation    := SQLDelegacionesModel():getWhereNombre( cNombre, uuidParent )

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

