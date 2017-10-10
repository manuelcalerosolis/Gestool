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
<<<<<<< HEAD
   local cSql  := "SELECT "                                              + ;
                     "nVisDom, "                                         + ;
                     "Cod, "                                             + ;
                     "Titulo "                                           + ;
=======
   local cSql  := "SELECT "                                                + ;
                     "Cod, "                                               + ;
                     "Titulo "                                             + ;
>>>>>>> beb854c5c6b8350b63e9193d506601299199db88
                  "FROM " + ::getTableName() + " "                         

   if !empty( cWhere )
         cSql  += "WHERE " + cWhere + " "
   end if 

   if !empty( cOrderBy )
         cSql  += "ORDER BY " + cOrderBy + " ASC"
   end if 

<<<<<<< HEAD
   /*MsgInfo( cSql, "cSql" )
   logwrite( cSql )*/

=======
>>>>>>> beb854c5c6b8350b63e9193d506601299199db88
   if ::ExecuteSqlStatement( cSql, @cStm )
      ::clearFocus( cStm )
      RETURN ( cStm )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//