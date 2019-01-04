#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesLineasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFacturasVentasLineasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//

