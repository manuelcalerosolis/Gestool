#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesComprasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "AlbaranesCompras"

   DATA cTableName                     INIT "albaranes_compras"

   METHOD getHashWhereUuidAndOrder( aSelected )

#ifdef __TEST__

   METHOD test_create_albaran_compras_con_tercero( cCodigoTercero )
   
#endif

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

#ifdef __TEST__

METHOD test_create_albaran_compras_con_tercero( cCodigoTercero ) 

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "serie", "TEST" )
   hset( hBuffer, "tercero_codigo", quoted( cCodigoTercero ) )
   hset( hBuffer, "metodo_pago_codigo", "1" )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "tarifa_codigo", "0" )

   ::insertBuffer()

RETURN ( ::insertBuffer() )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
