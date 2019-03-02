#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLOperacionesLineasModel FROM SQLCompanyModel

   DATA cTableTemporal        

   METHOD getColumns()                 VIRTUAL

   METHOD getColumnsSelect()           VIRTUAL

   METHOD getInitialSelect()           VIRTUAL

   METHOD getInitialWhereParentUuid( uuidParent )

   METHOD addUpdateSentence()
   
   METHOD addDeleteSentence()

   METHOD addDeleteSentenceById()

   METHOD deleteWhereUuid( uuid )

   METHOD aUuidToDelete( uuid )

   METHOD getDeleteSentenceFromParentsUuid()

   METHOD getSentenceNotSent( aFetch )

   METHOD getUpdateUnitsSentece()

   METHOD createTemporalTableWhereUuid( originalUuid )

   METHOD alterTemporalTableWhereUuid()

   METHOD replaceUuidInTemporalTable( duplicatedUuid )

   METHOD insertTemporalTable()

   METHOD dropTemporalTable()

   METHOD duplicateByUuid( originalUuid, duplicatedUuid )

   METHOD getSentenceCountLines( uuidParent )

   METHOD countLinesWhereUuidParent( uuidParent ) ;
                                       INLINE ( getSQLDatabase():getValue( ::getSentenceCountLines( uuidParent ), 0 ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialWhereParentUuid( uuidParent ) CLASS SQLOperacionesLineasModel

RETURN ( "WHERE " + ::cTableName + ".parent_uuid = " + quoted( uuidParent ) )

//---------------------------------------------------------------------------//

METHOD addUpdateSentence( aSQLUpdate, oProperty ) CLASS SQLOperacionesLineasModel

   aadd( aSQLUpdate, "UPDATE " + ::getTableName() + " " +                                                       ;
                        "SET unidades_articulo = " + toSqlString( oProperty:Value )                + ", " + ;
                        "precio_articulo = " + toSqlString( hget( ::hBuffer, "precio_articulo" ) ) + " " +  ;
                        "WHERE uuid = " + quoted( oProperty:Uuid ) +  "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addDeleteSentence( aSQLUpdate, oProperty ) CLASS SQLOperacionesLineasModel

   aadd( aSQLUpdate, "DELETE FROM " + ::getTableName() + " " +                          ;
                        "WHERE uuid = " + quoted( oProperty:Uuid ) + "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addDeleteSentenceById( aSQLUpdate, nId ) CLASS SQLOperacionesLineasModel

   aadd( aSQLUpdate, "DELETE FROM " + ::getTableName() + " " +                          ;
                        "WHERE id = " + quoted( nId ) + "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteWhereUuid( uuid ) CLASS SQLOperacionesLineasModel

   local cSentence   := "DELETE FROM " + ::getTableName() + " " + ;
                           "WHERE parent_uuid = " + quoted( uuid )

RETURN ( getSQLDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD aUuidToDelete( aParentsUuid ) CLASS SQLOperacionesLineasModel

   local cSentence   

   cSentence            := "SELECT uuid FROM " + ::getTableName() + " "
   cSentence            +=    "WHERE parent_uuid IN ( " 

   aeval( aParentsUuid, {| v | cSentence += toSQLString( v ) + ", " } )

   cSentence            := chgAtEnd( cSentence, ' )', 2 )

RETURN ( getSQLDatabase():selectFetchArray( cSentence ) )

//---------------------------------------------------------------------------//

METHOD getDeleteSentenceFromParentsUuid( aParentsUuid ) CLASS SQLOperacionesLineasModel

   local aUuid       := ::aUuidToDelete( aParentsUuid )

   if !empty( aUuid )
      RETURN ::getDeleteSentence( aUuid )
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD getSentenceNotSent( aFetch ) CLASS SQLOperacionesLineasModel

   local cSentence   := "SELECT * FROM " + ::getTableName() + " "

   cSentence         +=    "WHERE parent_uuid IN ( " 

   aeval( aFetch, {|h| cSentence += toSQLString( hget( h, "uuid" ) ) + ", " } )

   cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getUpdateUnitsSentece( id ) CLASS SQLOperacionesLineasModel
   
   local cSentence   := "UPDATE " + ::getTableName() +                                                                                  + " " +  ;
                           "SET unidades_articulo = unidades_articulo + " + toSQLString( hget( ::hBuffer, "unidades_articulo" ) )   + " " +  ;
                        "WHERE id = " + quoted( id )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD createTemporalTableWhereUuid( originalUuid ) CLASS SQLOperacionesLineasModel

   local cSentence

   ::cTableTemporal  := ::cTableName + hb_ttos( hb_datetime() )

   cSentence         := "CREATE TEMPORARY TABLE " + ::cTableTemporal          + " "
   cSentence         +=    "SELECT * from " + ::getTableName()                + " " 
   cSentence         += "WHERE parent_uuid = " + quoted( originalUuid )       + "; "

RETURN ( getSQLDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD alterTemporalTableWhereUuid() CLASS SQLOperacionesLineasModel

RETURN ( getSQLDatabase():Exec( "ALTER TABLE " + ::cTableTemporal + " DROP id" ) )

//---------------------------------------------------------------------------//

METHOD replaceUuidInTemporalTable( duplicatedUuid ) CLASS SQLOperacionesLineasModel

   local cSentence

   cSentence         := "UPDATE " + ::cTableTemporal                          + " "
   cSentence         +=    "SET id = 0"                                       + ", "
   cSentence         +=       "uuid = UUID()"                                 + ", "
   cSentence         +=       "parent_uuid = " + quoted( duplicatedUuid )    

RETURN ( getSQLDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD insertTemporalTable() CLASS SQLOperacionesLineasModel

   local cSentence

   cSentence         := "INSERT INTO " + ::getTableName() +                       + " "
   cSentence         +=    "SELECT * FROM " + ::cTableTemporal

RETURN ( getSQLDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD dropTemporalTable() CLASS SQLOperacionesLineasModel

RETURN ( getSQLDatabase():Exec( "DROP TABLE " + ::cTableTemporal ) )

//---------------------------------------------------------------------------//

METHOD duplicateByUuid( originalUuid, duplicatedUuid ) CLASS SQLOperacionesLineasModel

   if !( ::createTemporalTableWhereUuid( originalUuid ) )
      RETURN ( nil )
   end if 

   if !( ::replaceUuidInTemporalTable( duplicatedUuid ) )
      RETURN ( nil )
   end if 

   if !( ::insertTemporalTable() )
      RETURN ( nil )
   end if 

   if !( ::dropTemporalTable() )
      RETURN ( nil )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getSentenceCountLines( uuidParent ) CLASS SQLOperacionesLineasModel

   local cSql

   TEXT INTO cSql

   SELECT COUNT(*)

      FROM %1$s AS operaciones_lineas

      WHERE operaciones_lineas.parent_uuid = %2$s AND operaciones_lineas.deleted_at = 0 

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidParent ) )

RETURN ( cSql )

//---------------------------------------------------------------------------// 

