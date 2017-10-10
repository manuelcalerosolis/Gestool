#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "Client" )

   METHOD Riesgo( idCliente )

   METHOD getClientesPorRuta( cWhere, cOrderBy )

END CLASS

//---------------------------------------------------------------------------//

METHOD Riesgo( idCliente )

   local nRiesgo  := 0

   nRiesgo        += AlbaranesClientesModel():Riesgo( idCliente )

   nRiesgo        += RecibosClientesModel():Riesgo( idCliente )

   nRiesgo        += TicketsClientesModel():Riesgo( idCliente )

Return ( nRiesgo )

//---------------------------------------------------------------------------//

METHOD getClientesPorRuta( cWhere, cOrderBy )

   local cStm  := "ADSRutas"
   local cSql  := "SELECT "                                              + ;
                     "nVisDom, "                                         + ;
                     "Cod, "                                             + ;
                     "Titulo "                                           + ;
                  "FROM " + ::getTableName() + " "                         

   if !empty( cWhere )
         cSql  += "WHERE " + cWhere + " "
   end if 

   if !empty( cOrderBy )
         cSql  += "ORDER BY " + cOrderBy + " ASC"
   end if 

   /*MsgInfo( cSql, "cSql" )
   logwrite( cSql )*/

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( cStm )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//