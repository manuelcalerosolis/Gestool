#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS DireccionesGetSelector FROM TerceroGetSelector

   METHOD getFields()               

   METHOD setHelpText( value )

END CLASS

//---------------------------------------------------------------------------//

METHOD getFields() CLASS DireccionesGetSelector

   local uuidParent  := ::oController:getUuidParent()

   if empty( uuidParent )
      RETURN ( nil )
   end if 
   
   ::uFields   := ::oController:oModel:getClienteDireccion( ::getKey(), ::oGet:varGet(), uuidParent ) 

RETURN ( ::uFields )

//---------------------------------------------------------------------------//

METHOD setHelpText( value ) CLASS DireccionesGetSelector

   if !( hb_ishash( value ) )
      RETURN ( nil )
   end if 

   ::Super():Super():setHelpText( value[ "direccion" ] )
 
   if( !empty( ::oGetCodigoPostal ),   ::oGetCodigoPostal:cText( value[ "codigo_postal" ] ), ) 

   if( !empty( ::oGetPoblacion ),      ::oGetPoblacion:cText( value[ "poblacion" ] ), ) 

   if( !empty( ::oGetProvincia ),      ::oGetProvincia:cText( value[ "provincia" ] ), )

   if( !empty( ::oGetPais ),           ::oGetPais:cText( value[ "nombre_pais" ] ), ) 

RETURN ( nil )

//---------------------------------------------------------------------------//




