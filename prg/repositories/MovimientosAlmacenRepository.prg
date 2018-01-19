#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenRepository FROM SQLBaseRepository

   METHOD getTableName()            INLINE ( SQLMovimientosAlmacenModel():getTableName() )

   METHOD getSqlSentenceByIdOrLast( id ) 

   METHOD getSqlSentenceIdByNumber( nNumber ) 

   METHOD getIdByNumber( nNumber )  INLINE ( getSQLDataBase():selectValue( ::getSqlSentenceIdByNumber( nNumber ) ) )

   METHOD getSqlSentenceIdByUuid( uuid ) 

   METHOD getIdByUuid( uuid )       INLINE ( getSQLDataBase():selectValue( ::getSqlSentenceIdByUuid( uuid ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSqlSentenceByIdOrLast( id ) 

   local cSql  := "SELECT * FROM " + ::getTableName() + " " 

   if empty( id )
      cSql     +=    "ORDER BY id DESC LIMIT 1"
      RETURN ( cSql )
   end if 

   if hb_isstring( id )
      cSql     +=    "WHERE id = " + alltrim( str( id ) ) 
   end if 

   if hb_isarray( id ) 
      cSql     +=    "WHERE id IN ( " 
      aeval( id, {| v | cSql += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )
      cSql     := chgAtEnd( cSql, ' )', 2 )
   end if 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSqlSentenceIdByNumber( nNumber ) 

   local cSql  := "SELECT id FROM " + ::getTableName()         + " " 

   cSql        +=    "WHERE empresa = " + quoted( cCodEmp() )  + " AND "  
   cSql        +=       "numero = " + quoted( nNumber ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSqlSentenceIdByUuid( uuid ) 

   local cSql  := "SELECT id FROM " + ::getTableName()         + " " 

   cSql        +=    "WHERE uuid = " + quoted( uuid ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//
