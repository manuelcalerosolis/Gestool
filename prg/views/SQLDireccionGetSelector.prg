#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS DireccionGetSelector FROM ClientGetSelector

METHOD getFields()               INLINE ( ::uFields   := ::oController:oModel:getClienteDireccion( ::getKey(), ::oGet:varGet() ) )
   
METHOD setHelpText( value )

END CLASS

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





