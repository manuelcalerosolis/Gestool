#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TicketsClientesPagosModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "TikeP" )

END CLASS

//---------------------------------------------------------------------------//

