#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS DireccionGetSelector FROM ClientGetSelector

METHOD getFields()               INLINE ( ::uFields   := ::oController:oModel:getClienteDireccion( ::getKey(), ::oGet:varGet() ) )
   

END CLASS

//---------------------------------------------------------------------------//






