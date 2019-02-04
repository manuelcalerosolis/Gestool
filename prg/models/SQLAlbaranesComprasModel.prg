#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesComprasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "AlbaranesCompras"

   DATA cTableName                     INIT "albaranes_compras"

   METHOD getHashWhereUuidAndOrder( aSelected )

#ifdef __TEST__

   METHOD test_create_albaran_compras_con_tercero( cCodigoTercero )

   METHOD create_albaran_compras( hDatos )

   METHOD test_get_uuid_albaran_compras( cSerie, nNumero )
   
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

METHOD test_create_albaran_compras_con_tercero( cCodigoTercero )  CLASS SQLAlbaranesComprasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "serie", "TEST" )
   hset( hBuffer, "tercero_codigo", quoted( cCodigoTercero ) )
   hset( hBuffer, "metodo_pago_codigo", "1" )
   hset( hBuffer, "almacen_codigo", "0" )
   hset( hBuffer, "tarifa_codigo", "0" )

   ::insertBuffer()

RETURN ( ::insertBuffer() )

//---------------------------------------------------------------------------//

METHOD create_albaran_compras( hDatos ) CLASS SQLAlbaranesComprasModel

   local hBuffer    := ::loadBlankBuffer( {  "tercero_codigo"           => "0" ,;
                                             "recargo_equivalencia"     =>  0  ,;
                                             "metodo_pago_codigo"       => "0" ,;
                                             "almacen_codigo"           => "0" ,;
                                             "agente_codigo"            => "0" ,;
                                             "ruta_codigo"              => "0" ,;
                                             "tarifa_codigo"            => "0" ,;
                                             "serie"                    => "A" ,;
                                             "numero"                   =>  3  } )
 
   if hb_ishash( hDatos )
      heval( hDatos, {|k,v| hset( hBuffer, k, v) } )
   end if

   ::insertBuffer( hBuffer )

RETURN( nil )

//---------------------------------------------------------------------------//

METHOD test_get_uuid_albaran_compras( cSerie, nNumero ) CLASS SQLAlbaranesComprasModel

RETURN ( ::getUuidWhereSerieAndNumero( cSerie, nNumero ) )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
