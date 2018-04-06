#include "FiveWin.Ch"
#include "Factu.ch" 

//------------------------------------------------------------------//

CLASS TransportistasModel FROM ADSBaseModel

   METHOD getTableName()                         INLINE ::getEmpresaTableName( "transpor" )

   METHOD getUuid( cCodigo )                     INLINE ( ::getField( 'uuid', 'cCodTrn', cCodigo ) )

END CLASS

//---------------------------------------------------------------------------//