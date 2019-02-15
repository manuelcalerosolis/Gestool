#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesVentasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "AlbaranesVentas"

   DATA cTableName                     INIT "albaranes_ventas"

   METHOD getSentenceAlbaranWhereHash( dFechadesde, dFechaHasta, hWhere )

   METHOD getArrayAlbaranWhereHash( dFechaDesde, dFechaHasta, hWhere ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceAlbaranWhereHash( dFechaDesde, dFechaHasta, aWhere ) CLASS SQLAlbaranesVentasModel

   local cSql
   cSql          := ::Super:getInitialSelect()

   cSql        +=    "WHERE fecha >= " + DtoS( dFechadesde )          + " "
   cSQL        +=    "AND fecha <= "   + DtoS( dFechaHasta )          + " "


   if !empty( aWhere ) 
      aeval( aWhere, { | cCondition | cSql += "AND " + cCondition + " " } )
   end if

RETURN ( cSql )  

//---------------------------------------------------------------------------//

METHOD getArrayAlbaranWhereHash( dFechaDesde, dFechaHasta, hWhere ) CLASS SQLAlbaranesVentasModel

   local aAlbaranes  := ::getDatabase():selectTrimedFetchHash( ::getSentenceAlbaranWhereHash( dFechaDesde, dFechaHasta, hWhere ) )

   aeval( aAlbaranes, {|h| hset( h, "selected", .t. ) } )

RETURN ( aAlbaranes )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
