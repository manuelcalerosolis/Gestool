#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS DireccionGetSelector FROM ClientGetSelector

   METHOD getFields()               

   METHOD setHelpText( value )

END CLASS

//---------------------------------------------------------------------------//

METHOD getFields() CLASS DireccionGetSelector

   local uuidParent  := ::oController:getUuidParent()

   if empty( uuidParent )
      RETURN ( nil )
   end if 

   msgalert( uuidParent, "::getFields" )
   
   ::uFields   := ::oController:oModel:getClienteDireccion( ::getKey(), ::oGet:varGet(), uuidParent ) 

   msgalert( hb_valtoexp( ::uFields ) )

RETURN ( ::uFields )

//---------------------------------------------------------------------------//

METHOD setHelpText( value ) CLASS DireccionGetSelector

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




