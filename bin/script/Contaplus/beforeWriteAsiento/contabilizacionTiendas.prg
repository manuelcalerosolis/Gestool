#include "hbclass.ch"

//---------------------------------------------------------------------------//

Function ContabilizacionTiendas( aAsiento )
   
   debug( aAsiento )

   debug( aAsiento[ ( getDiarioDatabaseContaplus() )->( fieldPos( "SUBCTA" ) ) ], "subcuenta" )

Return .f.

//---------------------------------------------------------------------------//

