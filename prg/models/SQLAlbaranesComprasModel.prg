#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesComprasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "AlbaranesCompras"

   DATA cTableName                     INIT "albaranes_compras"

   METHOD getHashWhereUuidAndOrder( aSelected )


END CLASS

//---------------------------------------------------------------------------//

METHOD getHashWhereUuidAndOrder( cWhere ) CLASS SQLAlbaranesComprasModel
   
   local cSql
   local aSelected

   TEXT INTO cSql

      SELECT 
         *  
      FROM %1$s

      WHERE uuid %2$s

      Order by tercero_codigo, ruta_codigo, metodo_pago_codigo, tarifa_codigo, recargo_equivalencia, serie
       
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName(), cWhere )

RETURN ( ::getDatabase():selectFetchHash( cSQL ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
