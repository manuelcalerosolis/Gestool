#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SeriesGetSelector FROM GetSelector

   DATA cKey                           INIT  "serie"

   DATA oGetNumber 

   METHOD getFields()                  

   METHOD assignResults( hResult )

   METHOD setGetNumber( oGetNumber )   INLINE ( ::oGetNumber := oGetNumber )

END CLASS

//---------------------------------------------------------------------------//

METHOD getFields()

   ::uFields   := ::oController:getModel():getFieldWhere( "contador", { "serie" => eval( ::bValue ), "documento" => ::getParentController:getName() } )

   msgalert( ::uFields, "::uFields" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD assignResults( hResult ) CLASS SeriesGetSelector

   if !hhaskey( hResult, ::getKey() )
      RETURN ( nil )
   end if 

   ::cText( hGet( hResult, ::getKey() ) )

   if !empty( ::oGetNumber)
      ::oGetNumber:cText( ::uFields ) 
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
