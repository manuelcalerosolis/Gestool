#include "FiveWin.Ch"
#include "Factu.Ch"

//---------------------------------------------------------------------------//

function updatePrecios( cSerie, nNumero, cSufijo, nMode )

   local cArea    := "LineasPedidosProveedor"

   //if nMode != APPD_MODE
      //Return nil
   //end if

   PedidosProveedoresModel():selectLineasById( cSerie, nNumero, cSufijo, @cArea )

   ( cArea )->( dbGoTop() )

   while !( cArea )->( Eof() )

      cSql  := "UPDATE " + cPatEmp() + "PedProvL "
      cSql  += "SET nPreDiv=" + AllTrim( Str( ( cArea )->nPreDiv ) )
      cSql  += " WHERE"
      cSql  += " cRef=" + AllTrim( ( cArea )->cRef )
      cSql  += " AND cCodPr1=" + AllTrim( ( cArea )->cCodPr1 )
      cSql  += " AND cCodPr2=" + AllTrim( ( cArea )->cCodPr2 )
      cSql  += " AND cValPr1=" + AllTrim( ( cArea )->cValPr1 )
      cSql  += " AND cValPr2=" + AllTrim( ( cArea )->cValPr2 )
      //cSql  += " AND "

      //cSql  += " ( SELECT nEstado FROM " + cPatEmp() + "PedProvT WHERE cSerPed=" + cSerie + " AND nNumPed=" + Str( nNumero ) + " AND cSufPed=" + cSufijo + ")"

      MsgInfo( cSql )

      ( cArea )->( dbSkip() )

   end while

return nil

//---------------------------------------------------------------------------//