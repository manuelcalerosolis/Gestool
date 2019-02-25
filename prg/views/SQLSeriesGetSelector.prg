#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SeriesGetSelector FROM GetSelector

   DATA cKey                           INIT  "serie"

   METHOD getFields()                  

END CLASS

//---------------------------------------------------------------------------//

METHOD getFields()

   ::uFields   := ::oController:getModel():getFieldWhere( "contador", { "serie" => eval( ::bValue ), "documento" => ::getParentController:getName() } )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
