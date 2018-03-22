#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS CentroCosteModel FROM ADSBaseModel

   METHOD getTableName()                   INLINE ::getDatosTableName( "CCoste" )

   MESSAGE getNombre( Uuid )               INLINE ::getField( "cNombre", "uuid", Uuid )

END CLASS

//---------------------------------------------------------------------------//