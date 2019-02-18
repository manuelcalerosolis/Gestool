#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesVentasConversorModel FROM SQLAlbaranesVentasModel

   METHOD getSentenceAlbaranLimitCero() 

   METHOD getSentenceAlbaranWhere( dFechadesde, dFechaHasta, hWhere )

   METHOD getArrayAlbaranWhereHash( dFechaDesde, dFechaHasta, hWhere ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceAlbaranWhere( dFechaDesde, dFechaHasta, aWhere ) CLASS SQLAlbaranesVentasConversorModel

   local cSql

   cSql        := ::Super:getInitialSelect()

   msgalert( cSql, "sentencia inicial")

   cSql        +=    "WHERE canceled_at IS NULL"            + " "
   cSql        +=    "AND fecha >= " + dtos( dFechadesde )  + " "
   cSQL        +=    "AND fecha <= " + dtos( dFechaHasta )  + " "

   msgalert( cSql, "sentencia con fechas")

   if !empty( aWhere ) 
      aeval( aWhere, { | cCondition | cSql += "AND " + cCondition + " " } )
   end if

   msgalert( cSql, "sentencia con where" )

RETURN ( cSql )  

//---------------------------------------------------------------------------//

METHOD getSentenceAlbaranLimitCero() CLASS SQLAlbaranesVentasConversorModel

   local cSql

   cSql        := ::Super:getInitialSelect()

   cSql        += "LIMIT 0"

   msgalert( cSql, "sentencia inicial CON LIMIT 0")

RETURN ( cSql )  

//---------------------------------------------------------------------------//


METHOD getArrayAlbaranWhereHash( dFechaDesde, dFechaHasta, hWhere ) CLASS SQLAlbaranesVentasConversorModel

   local aAlbaranes  := ::getDatabase():selectTrimedFetchHash( ::getSentenceAlbaranWhere( dFechaDesde, dFechaHasta, hWhere ) )

   aeval( aAlbaranes, {|h| hset( h, "selected", .t. ) } )

RETURN ( aAlbaranes )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
