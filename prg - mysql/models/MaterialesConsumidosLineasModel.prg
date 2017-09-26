#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MaterialesConsumidosLineasModel FROM MaterialesProducidosLineasModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "ProMat" )

END CLASS

//---------------------------------------------------------------------------//

