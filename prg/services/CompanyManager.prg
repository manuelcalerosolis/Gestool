#include "FiveWin.Ch"
#include "Factu.ch" 

static oCompany

//----------------------------------------------------------------------------//

CLASS CompanyManager

   DATA id
   DATA uuid
   DATA nombre
   DATA codigo
   DATA delegacionUuid

   METHOD New()

   METHOD Set( hCompany )           INLINE ( ::guard( hCompany ) )
   METHOD Guard( hCompany )

   METHOD guardWhereUuid( uuid )
   METHOD guardWhereCodigo( cCodigo )

   METHOD getDefaultDelegacion()

END CLASS

//--------------------------------------------------------------------------//

METHOD New( hCompany )

   if !empty( hCompany )
      ::guard( hCompany )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guard( hCompany )

   if !hb_ishash( hCompany )
      RETURN ( self )
   end if 

   if hhaskey( hCompany, "id" )
      ::id              := hget( hCompany, "id" ) 
   end if 

   if hhaskey( hCompany, "uuid" )
      ::uuid            := hget( hCompany, "uuid" ) 
   end if 
   
   if hhaskey( hCompany, "nombre" )
      ::nombre          := hget( hCompany, "nombre" ) 
   end if 

   if hhaskey( hCompany, "codigo" )
      ::codigo          := hget( hCompany, "codigo" ) 
   end if 

   ::delegacionUuid     := ::getDefaultDelegacion()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereUuid( uuid )

   local hCompany    := SQLEmpresasModel():getWhereUuid( Uuid )

   if hb_ishash( hCompany )
      ::guard( hCompany )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereCodigo( cCodigo )

   local hCompany    := SQLEmpresasModel():getWhereCodigo( cCodigo )

   if hb_ishash( hCompany )
      ::guard( hCompany )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getDefaultDelegacion()

   local delegacionUuid    
   
   delegacionUuid          := SQLAjustableModel():getUsuarioEmpresaExclusiva( Auth():Uuid() )

   if empty( delegacionUuid )
      delegacionUuid       := SQLAjustableModel():getEmpresaDelegacionDefecto( ::uuid )
   end if

RETURN ( delegacionUuid )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION Company( hCompany )

   if empty( oCompany )
      oCompany       := CompanyManager():New() 
   end if

   if !empty( hCompany )
      oCompany:Guard( hCompany )
   end if 

RETURN ( oCompany )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

