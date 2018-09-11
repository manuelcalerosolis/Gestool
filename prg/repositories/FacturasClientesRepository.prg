#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFacturasClientesModel():getTableName() ) 

   METHOD getSQLFunctions()               INLINE ( {  ::dropProcedurePrecioTotalConDescuento(),;
                                                      ::createProcedurePrecioTotalConDescuento() } )

   METHOD dropProcedurePrecioTotalConDescuento()  

   METHOD createProcedurePrecioTotalConDescuento()

   METHOD callPrecioTotalConDescuento( UuidFactura )
  

END CLASS

//---------------------------------------------------------------------------//

METHOD dropProcedurePrecioTotalConDescuento() CLASS FacturasClientesRepository 

RETURN ( "DROP PROCEDURE IF EXISTS " + Company():getTableName( 'PrecioTotalConDescuento' ) + ";" )

//---------------------------------------------------------------------------//

METHOD callPrecioTotalConDescuento( UuidFactura ) CLASS FacturasClientesRepository

RETURN ( getSQLDatabase():Exec( "CALL " + Company():getTableName( 'PrecioTotalConDescuento' ) + "( " + UuidFactura + " )" ) )

//---------------------------------------------------------------------------//

METHOD createProcedurePrecioTotalConDescuento() CLASS FacturasClientesRepository

   local cSQL

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` PROCEDURE %1$s ( IN `UuidFactura` CHAR(40) ) 
      LANGUAGE SQL 
      NOT DETERMINISTIC 
      CONTAINS SQL 
      SQL SECURITY DEFINER 
      COMMENT '' 
      BEGIN 

      Declare totalprecio decimal(19,6);
      Declare totaldescuento decimal(7,4);
      Declare descuentoeuros decimal(19,6);
      Declare preciocondescuento decimal(19,6);

      SET @totalprecio = (SELECT SUM(facturas_clientes_lineas.unidad_medicion_factor * facturas_clientes_lineas.articulo_unidades * facturas_clientes_lineas.articulo_precio )
                           FROM %2$s AS facturas_clientes_lineas 
                           WHERE facturas_clientes_lineas.parent_uuid = %4$s);

      SET @totaldescuento = (SELECT SUM(facturas_clientes_descuentos.descuento)
                              FROM %3$s AS facturas_clientes_descuentos
                              WHERE facturas_clientes_descuentos.parent_uuid = %4$s); 

      SET @descuentoeuros= (@totalprecio * @totaldescuento /100); 

      SET @preciocondescuento = @totalprecio - @descuentoeuros ; 

      SELECT @preciocondescuento AS total_con_descuento;

      END

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           Company():getTableName( 'PrecioTotalConDescuento' ),;
                           SQLFactutasClientesLineasModel():getTableName(),;,;
                           SQLFactutasClientesDescuentosModel():getTableName(),;
                           quoted( UuidFactura ) )

RETURN ( cSQL )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

