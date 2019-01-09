#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConsolidacionAlmacenRepository FROM SQLBaseRepository

   METHOD getTableName()               INLINE ( SQLConsolidacionesAlmacenesModel():getTableName() ) 

   METHOD getPackage( cContext )       INLINE ( SQLConsolidacionesAlmacenesModel():getPackage( cContext ) )

   METHOD getSQLFunctions()            INLINE ( {} )

END CLASS

//---------------------------------------------------------------------------//

