#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SeriesGetSelector FROM GetSelector

   DATA cKey                           INIT  "Serie"


   METHOD getFields()                  INLINE ( ::uFields := ::oController:getModel():getField( "contador", ::getKey(), ::oGet:varGet() ) )
   
END CLASS
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
