#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLFacturasComprasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "FacturasCompras"

   DATA cTableName                     INIT "facturas_compras"

   METHOD getTercerosModel()           INLINE ( SQLTercerosModel() )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
