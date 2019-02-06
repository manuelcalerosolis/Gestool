#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesVentasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "AlbaranesVentas"

   DATA cTableName                     INIT "albaranes_ventas"

   METHOD getHashAlbaranWhereFechaIn( dfechadesde, dfechaHasta )

END CLASS

//---------------------------------------------------------------------------//

METHOD getHashAlbaranWhereFechaIn( dfechaDesde, dfechaHasta )

   local cSql

   TEXT INTO cSql

   SELECT
      *

   FROM %1$s

   WHERE fecha >= %2$s AND fecha <= %3$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( dfechaDesde ), quoted( dfechaHasta ) )

RETURN ( getSQLDatabase():selectFetch( cSql ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
