#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLFacturasProveedoresModel FROM SQLOperacionesComercialesModel

   DATA cTableName                     INIT "facturas_proveedores"

   METHOD getTercerosModel()           INLINE ( SQLProveedoresModel() )

   METHOD getColumnsSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumnsSelect() CLASS SQLFacturasProveedoresModel

   local cColumns

   TEXT INTO cColumns
      operaciones_comerciales.id AS id,
      operaciones_comerciales.uuid AS uuid,
      CONCAT( operaciones_comerciales.serie, '-', operaciones_comerciales.numero ) AS numero,
      operaciones_comerciales.fecha AS fecha,
      operaciones_comerciales.delegacion_uuid AS delegacion_uuid,
      operaciones_comerciales.sesion_uuid AS sesion_uuid,
      operaciones_comerciales.recargo_equivalencia AS recargo_equivalencia,
      operaciones_comerciales.cliente_codigo AS cliente_codigo,
      operaciones_comerciales.created_at AS created_at,
      operaciones_comerciales.updated_at AS updated_at,
      terceros.nombre AS cliente_nombre,
      terceros.dni AS cliente_dni,
      direcciones.direccion AS direccion_direccion,
      direcciones.poblacion AS direccion_poblacion,
      direcciones.codigo_provincia AS direccion_codigo_provincia,
      direcciones.provincia AS direccion_provincia,
      direcciones.codigo_postal AS direccion_codigo_postal,
      direcciones.telefono AS direccion_telefono,
      direcciones.movil AS direccion_movil,
      direcciones.email AS direccion_email,
      tarifas.codigo AS tarifa_codigo,
      tarifas.nombre AS tarifa_nombre,
      ( %1$s( operaciones_comerciales.uuid, operaciones_comerciales.recargo_equivalencia ) ) AS total
   ENDTEXT

   cColumns    := hb_strformat( cColumns, Company():getTableName( 'FacturaProveedorTotalSummaryWhereUuid' ) )

RETURN ( cColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
