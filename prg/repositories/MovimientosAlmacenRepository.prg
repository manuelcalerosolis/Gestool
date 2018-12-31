#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenRepository FROM SQLBaseRepository

   METHOD getTableName()            INLINE ( SQLConsolidacionesAlmacenModel():getTableName() )

   METHOD getSQLSentenceIdByNumber( nNumber ) 

   METHOD getIdByNumber( nNumber )  INLINE ( getSQLDataBase():getValue( ::getSQLSentenceIdByNumber( nNumber ) ) )

   METHOD getSQLSentenceIdByUuid( uuid ) 

   METHOD getIdByUuid( uuid )       INLINE ( getSQLDataBase():getValue( ::getSQLSentenceIdByUuid( uuid ) ) )

   METHOD getNextNumber( cUser )

   METHOD getLastNumber( cUser )

   METHOD getLastNumberByUser( cUser )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSQLSentenceIdByNumber( nNumber ) 

   local cSql  := "SELECT id FROM " + ::getTableName()         + " " 
   cSql        +=    "WHERE numero = " + quoted( nNumber ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceIdByUuid( uuid ) 

   local cSql  := "SELECT id FROM " + ::getTableName()         + " " 
   cSql        +=    "WHERE uuid = " + quoted( uuid ) 

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getLastNumberByUser( cUser )

   local cSql  := "SELECT numero FROM " + ::getTableName()        + " " 

   if empty( cUser )
      cSql     +=    "WHERE usuario_uuid = " + quoted( cUser )    + " " 
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
