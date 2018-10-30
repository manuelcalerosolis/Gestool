#include "FiveWin.Ch"
#include "Factu.ch" 

static oStore

//----------------------------------------------------------------------------//

CLASS StoreManager

   DATA id                       INIT 0
   DATA uuid                     INIT ""
   DATA codigo                   INIT ""
   DATA nombre                   INIT ""
   DATA almacenUuid              INIT ""
   DATA sistema                  INIT 0

   METHOD New()

   METHOD Set( hStore )          INLINE ( ::guard( hStore ) )
   METHOD Guard( hStore )

   METHOD guardWhereUuid( uuid )
   
   METHOD guardWhereNombre( cNombre )

   METHOD getCodigo()            INLINE ( padr( ::codigo, 20 ) )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( hStore )

   if !empty( hStore )
      ::guard( hStore )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guard( hStore )

   if !hb_ishash( hStore )
      RETURN ( self )
   end if 

   if hhaskey( hStore, "id" )
      ::id           := hget( hStore, "id" ) 
   end if 

   if hhaskey( hStore, "uuid" )
      ::uuid         := hget( hStore, "uuid" ) 
   end if 

   if hhaskey( hStore, "codigo" )
      ::codigo       := hget( hStore, "codigo" ) 
   end if 
   
   if hhaskey( hStore, "nombre" )
      ::nombre       := hget( hStore, "nombre" ) 
   end if 

   if hhaskey( hStore, "almacen_uuid" )
      ::almacenUuid  := hget( hStore, "almacen_uuid" ) 
   end if 

   if hhaskey( hStore, "sistema" )
      ::sistema      := hget( hStore, "sistema" ) 
   end if 

   setAlmacenMessageBar( ::nombre )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereUuid( uuid )

   local hStore    := SQLCajasModel():getWhereUuid( Uuid )

   if hb_ishash( hStore )
      ::guard( hStore )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereNombre( cNombre )

   local hStore    := SQLCajasModel():getWhereNombre( cNombre )

   if hb_ishash( hStore )
      ::guard( hStore )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION Store( hStore )

   if empty( oStore )
      oStore       := StoreManager():New() 
   end if

   if !empty( hStore )
      oStore:Guard( hStore )
   end if 

RETURN ( oStore )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

