#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RectificativasClientesLineasModel FROM FacturasClientesLineasModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "FacRecL" )

END CLASS

//---------------------------------------------------------------------------//

