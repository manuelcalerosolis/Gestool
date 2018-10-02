#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseRepository

   DATA oController

   METHOD New() CONSTRUCTOR

   METHOD End()                                 

   METHOD getController()                       INLINE ( ::oController )

   METHOD getDatabase()                         INLINE ( getSQLDatabase() )

   METHOD getModel()                            INLINE ( ::getController():getModel() )

   METHOD getModelTableName()                   INLINE ( ::getController():getModelTableName() )
   
   METHOD getAll()

   METHOD getSQLSentenceByIdOrLast( uId ) 

   METHOD getSQLSentenceWhereParentUuid( cParentUuid )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                                := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getAll() 

   local cSQL     := "SELECT * FROM " + ::getTableName()

RETURN ( ::getDatabase():selectFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceByIdOrLast( uId ) 

   local cSql     := "SELECT * FROM " + ::getTableName() + " " 

   if empty( uId )
      cSql        +=    "ORDER BY id DESC LIMIT 1"
      RETURN ( cSql )
   end if 

   if hb_isnumeric( uId )
      cSql        +=    "WHERE id = " + alltrim( str( uId ) ) 
   end if 

   if hb_isarray( uId ) 
      cSql        +=    "WHERE id IN ( " 
      aeval( uId, {| v | cSql += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )
      cSql        := chgAtEnd( cSql, ' )', 2 )
   end if

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSQLSentenceWhereParentUuid( cParentUuid )

   local cSql     := "SELECT * FROM " + ::getTableName() + " " 

   cSql           +=    "WHERE parent_uuid = " + quoted( cParentUuid ) + " " 

   cSql           +=    "ORDER BY id"

RETURN ( cSql )

//---------------------------------------------------------------------------//
