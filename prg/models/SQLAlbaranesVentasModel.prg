#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLAlbaranesVentasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "AlbaranesVentas"

   DATA cTableName                     INIT "albaranes_ventas"

   METHOD getSentenceAlbaranWhereHash( dFechadesde, dFechaHasta, hWhere )

   METHOD getArrayAlbaranWhereHash( dFechaDesde, dFechaHasta, hWhere ) ;
                                       INLINE( ::getDatabase():selectTrimedFetchHash( ::getSentenceAlbaranWhereHash( dFechaDesde, dFechaHasta, hWhere ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceAlbaranWhereHash( dFechaDesde, dFechaHasta, hWhere )

   local cSql  := "SELECT * " 
   cSql        +=    "FROM " + ::getTableName()                       + " "
   cSql        +=    "WHERE fecha >= " + DtoS( dFechadesde )          + " "
   cSQL        +=    "AND fecha <= "   + DtoS( dFechaHasta )          + " "

   if hb_ishash( hWhere ) 
      msgalert( "hay hWhere")
      heval( hWhere, {|k,v| cSQL += "AND " + k + " = " + v + " " } )
   end if

RETURN ( cSql )  

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
