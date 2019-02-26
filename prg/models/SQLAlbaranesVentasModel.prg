#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesVentasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "AlbaranesVentas"

   DATA cTableName                     INIT "albaranes_ventas"

   METHOD getSelectSentence( cOrderBy, cOrientation )

#ifdef __TEST__

   METHOD create_albaran_ventas( hDatos )

   METHOD test_get_uuid_albaran_ventas( cSerie, nNumero )

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getSelectSentence( cOrderBy, cOrientation ) CLASS SQLAlbaranesVentasModel

   local cSql

   cSql        := ::Super:getSelectSentence( cOrderBy, cOrientation )

RETURN ( cSql )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD create_albaran_ventas( hDatos ) CLASS SQLAlbaranesVentasModel

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

METHOD test_get_uuid_albaran_ventas( cSerie, nNumero ) CLASS SQLAlbaranesVentasModel

RETURN ( ::getUuidWhereSerieAndNumero( cSerie, nNumero ) )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
