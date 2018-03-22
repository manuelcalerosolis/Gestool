#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenRepository FROM SQLBaseRepository

   METHOD getTableName()            INLINE ( SQLMovimientosAlmacenModel():getTableName() )

   METHOD getSQLSentenceByIdOrLast( id ) 

   METHOD getSQLSentenceIdByNumber( nNumber ) 

   METHOD getIdByNumber( nNumber )  INLINE ( getSQLDataBase():getValue( ::getSQLSentenceIdByNumber( nNumber ) ) )

   METHOD getSQLSentenceIdByUuid( uuid ) 

   METHOD getIdByUuid( uuid )       INLINE ( getSQLDataBase():getValue( ::getSQLSentenceIdByUuid( uuid ) ) )

   METHOD getNextNumber( cUser )

   METHOD getLastNumber( cUser )

   METHOD getLastNumberByUser( cUser )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSQLSentenceByIdOrLast( uId ) 

   local cSql  := "SELECT * FROM " + ::getTableName() + " " 

   if empty( uId )
      cSql     +=    "ORDER BY id DESC LIMIT 1"
      RETURN ( cSql )
   end if 

   if hb_isnumeric( uId )
      cSql     +=    "WHERE id = " + alltrim( str( uId ) ) 
   end if 

   if hb_isarray( uId ) 
      cSql     +=    "WHERE id IN ( " 
      aeval( uId, {| v | cSql += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )
      cSql     := chgAtEnd( cSql, ' )', 2 )
   end if

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceIdByNumber( nNumber ) 

   local cSql  := "SELECT id FROM " + ::getTableName()         + " " 

   cSql        +=    "WHERE empresa = " + quoted( cCodEmp() )  + " "  
   
   cSql        +=       "AND numero = " + quoted( nNumber ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceIdByUuid( uuid ) 

   local cSql  := "SELECT id FROM " + ::getTableName()         + " " 

   cSql        +=    "WHERE uuid = " + quoted( uuid ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getLastNumberByUser( cUser )

   local cSql  := "SELECT numero FROM " + ::getTableName()        + " " 

   cSql        +=    "WHERE empresa = " + quoted( cCodEmp() )     + " "  

   if empty( cUser )
      cSql     +=       "AND usuario = " + quoted( cUser )        + " " 
   end if 

   cSql        +=    "ORDER BY creado DESC, numero DESC"          + " "
   cSql        +=       "LIMIT 1"
      
RETURN ( cSql )

//---------------------------------------------------------------------------//
   
METHOD getLastNumber( cUser )

   local cNumero  

   DEFAULT cUser  := Auth():Codigo()

   cNumero        := getSqlDataBase():getValue( ::getLastNumberByUser( cUser ) )

   if empty( cNumero )
      cNumero     := getSqlDataBase():getValue( ::getLastNumberByUser() )
   end if 

RETURN ( cNumero )

//---------------------------------------------------------------------------//

METHOD getNextNumber( cUser )

   local cNumero  := ::getLastNumber( cUser ) 

RETURN ( nextDocumentNumber( cNumero ) )

//---------------------------------------------------------------------------//
