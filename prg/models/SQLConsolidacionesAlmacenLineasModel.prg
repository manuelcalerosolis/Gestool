#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLConsolidacionesAlmacenLineasModel FROM SQLOperacionesComercialesLineasModel

   DATA cTableName            INIT  "consolidaciones_almacenes_lineas"

   DATA cGroupBy              INIT  "consolidaciones_almacenes_lineas.id" 

#ifdef __TEST__

#endif

END CLASS

//---------------------------------------------------------------------------//

#ifdef __TEST__

#endif
