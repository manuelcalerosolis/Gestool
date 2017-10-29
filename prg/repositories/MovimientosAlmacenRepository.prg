#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLMovimientosAlmacenModel():getTableName() )

   METHOD getSqlSentenceByIdOrLast( id ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getSqlSentenceByIdOrLast( id ) 

   local cSql  := "SELECT * FROM " + ::getTableName() + " " 

   if empty( id )
      cSql     +=    "ORDER BY id DESC LIMIT 1"
   else 
      cSql     +=    "WHERE id = " + id 
   end if 

RETURN ( cSql )

//---------------------------------------------------------------------------//
