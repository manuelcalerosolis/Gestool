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

METHOD getClientesPorRuta( cWhere, cAgente, cOrderBy )

   local cStm  := "ADSRutas"
   local cSql  := "SELECT "                                                + ;
                     "Cod, "                                               + ;
                     "Titulo "                                             + ;
                  "FROM " + ::getTableName() + " "                         

   if !empty( cWhere )
      cSql     += "WHERE " + cWhere + " "
      if !empty( cAgente )
         cSql  += "AND cAgente = " + quoted( cAgente ) + " "
      end if
   else 
      if !empty( cAgente )
         cSql  += "WHERE cAgente = " + quoted( cAgente ) + " "
      end if
   end if 

   if !empty( cOrderBy )
         cSql  += "ORDER BY " + cOrderBy + " ASC"
   end if 

   if ::ExecuteSqlStatement( cSql, @cStm )
      ::clearFocus( cStm )
      RETURN ( cStm )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//