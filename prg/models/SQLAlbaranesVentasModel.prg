#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesVentasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "AlbaranesVentas"

   DATA cTableName                     INIT "albaranes_ventas"

   METHOD getSentenceAlbaranLimitCero() 

   METHOD getSentenceAlbaranWhere( dFechadesde, dFechaHasta, hWhere )

   METHOD getArrayAlbaranWhereHash( dFechaDesde, dFechaHasta, hWhere ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceAlbaranWhere( dFechaDesde, dFechaHasta, aWhere ) CLASS SQLAlbaranesVentasModel

   local cSql

   cSql        := ::Super:getInitialSelect()

   msgalert( cSql, "sentencia inicial")

   cSql        +=    "WHERE canceled_at = 0"                + " "
   cSql        +=    "AND fecha >= " + dtos( dFechadesde )  + " "
   cSQL        +=    "AND fecha <= " + dtos( dFechaHasta )  + " "

   msgalert( cSql, "sentencia con fechas")

   if !empty( aWhere ) 
      aeval( aWhere, { | cCondition | cSql += "AND " + cCondition + " " } )
   end if

   msgalert( cSql, "sentencia con where" )

RETURN ( cSql )  

//---------------------------------------------------------------------------//

METHOD getSentenceAlbaranLimitCero() CLASS SQLAlbaranesVentasModel

   local cSql

   cSql        := ::Super:getInitialSelect()

   cSql        += "LIMIT 0"

   msgalert( cSql, "sentencia inicial CON LIMIT 0")

RETURN ( cSql )  

//---------------------------------------------------------------------------//


METHOD getArrayAlbaranWhereHash( dFechaDesde, dFechaHasta, hWhere ) CLASS SQLAlbaranesVentasModel

   local aAlbaranes  := ::getDatabase():selectTrimedFetchHash( ::getSentenceAlbaranWhere( dFechaDesde, dFechaHasta, hWhere ) )

   aeval( aAlbaranes, {|h| hset( h, "selected", .t. ) } )

RETURN ( aAlbaranes )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
