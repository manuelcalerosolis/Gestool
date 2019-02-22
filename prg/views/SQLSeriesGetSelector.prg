#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SeriesGetSelector FROM GetSelector

   DATA cKey                           INIT  "serie"

   METHOD getFields()                  INLINE ( ::uFields := ::oController:getModel():getField( "contador", ::getKey(), ::oGet:varGet() ) )
   
   METHOD assignResults( hResult )

END CLASS
//---------------------------------------------------------------------------//

METHOD assignResults( hResult ) CLASS SeriesGetSelector

   if hhaskey( hResult, ::getKey() )
      ::cText( hGet( hResult, ::getKey() ) )
   
      hset( ::oController:oController:getModel():hBuffer, "numero", ::oController:getModel():getLastCounter( ::oController:oController:getModel():cTableName, hGet( hResult, ::getKey() ) ) )

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
