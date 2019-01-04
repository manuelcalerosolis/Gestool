#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasVentasRepository FROM OperacionesComercialesRepository

   METHOD getTableName()               INLINE ( SQLFacturasVentasModel():getTableName() ) 

   METHOD getPackage( cContext )       INLINE ( SQLFacturasVentasModel():getPackage( cContext ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
  
