#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseModel
  
   DATA     oRowSet

	DATA     cTableName
	DATA	   hColumns
   DATA     cColumnKey

  	DATA	   hBuffer
   DATA     idBuffer    
 
   DATA     cFind
   DATA     cColumnOrder
   DATA     cColumnOrientation
 
   METHOD   New()
   METHOD   End()

   METHOD   getSQLCreateTable()
   METHOD	getInsertSentence()						    
   METHOD   getUpdateSentence()
   METHOD   getDeleteSentence()
   
   METHOD   getOrderRowSet()
   METHOD   freeRowSet()                           INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet := nil ), ) )
   METHOD   getRowSetRecno()                       INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:recno() ) , 0 ) )
   METHOD   setRowSetRecno( nRecno )               INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:goto( nRecno ) ), ) )

    METHOD   setFind( cFind )                      INLINE   ( ::cFind := cFind )
 
    METHOD   setColumnOrderBy( cColumn )           INLINE   ( ::cColumnOrder := cColumn )
    METHOD   setOrderOrientation( cOrientation )   INLINE   ( ::cColumnOrientation := cOrientation )

    METHOD   refreshSelect()                       INLINE   ( ::getOrderRowSet( .t. ) )

    METHOD   getSelectSentence()
 
    METHOD   getSelectByColumn()
 
    METHOD   getSelectByOrder()

    METHOD   find( cFind )

    METHOD   loadBuffer( id )
    METHOD   loadBlankBuffer()
    METHOD   loadCurrentBuffer()

    METHOD   updateCurrentBuffer()                 INLINE ( getSQLDatabase():Query( ::getUpdateSentence() ), ::refreshSelect() )
    METHOD   insertBuffer()                        INLINE ( getSQLDatabase():Query( ::getInsertSentence() ), ::refreshSelect() )
    METHOD   deleteSelection()                     INLINE ( getSQLDatabase():Query( ::getdeleteSentence() ), ::refreshSelect() )

    METHOD   getBuffer( cColumn )                  INLINE   ( hget( ::hBuffer, cColumn ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cColumnKey                  := "id"

   ::cFind                       := ""
   ::cColumnOrder                := ""
   ::cColumnOrientation          := ""

Return ( Self )

//---------------------------------------------------------------------------//

METHOD End()
   
   ::freeRowSet()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getSQLCreateTable()
   
   Local cSQLCreateTable := "CREATE TABLE " + ::cTableName + " ( "

   hEval( ::hColumns, {| k, v | cSQLCreateTable += k + " " + v + ", " } )

   cSQLCreateTable        := ChgAtEnd( cSQLCreateTable, ' )', 2 )

Return ( cSQLCreateTable )

//---------------------------------------------------------------------------//

METHOD getOrderRowSet( lRefresh )

   local oStmt

   if hb_isnil( lRefresh ) .and. !empty( ::oRowSet )
      Return ( ::oRowSet )
   end if 

   try 
      oStmt          := getSQLDatabase():Query( ::getSelectSentence() )

      ::oRowSet      := oStmt:fetchRowSet()
      ::oRowSet:goTop()

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

      oStmt:free()
   
   end

Return ( ::oRowSet )

//---------------------------------------------------------------------------//

METHOD getUpdateSentence()

  local cSQLUpdate  := "UPDATE " + ::cTableName + " SET "

  hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLUpdate += k + " = " + convertToSql( v ) + ", ", ) } )

  cSQLUpdate        := ChgAtEnd( cSQLUpdate, '', 2 )

  cSQLUpdate        += " WHERE " + ::cColumnKey + " = " + convertToSql( ::idBuffer ) 

Return ( cSQLUpdate )

//---------------------------------------------------------------------------//

METHOD getInsertSentence()

   Local cSQLInsert

   cSQLInsert               := "INSERT INTO " + ::cTableName + " ( "

   hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += k + ", ", ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' ) VALUES ( ', 2 )

   hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += convertToSql( v ) + ", ", ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' )', 2 )

Return ( cSQLInsert )

//---------------------------------------------------------------------------//

METHOD   getDeleteSentence()

Local cSQLDelete

cSQLDelete                := "DELETE FROM " + ::cTableName + " WHERE " + ::cColumnKey + " = " + convertToSql( ::oRowSet:fieldGet( ::cColumnKey ) )

Return ( cSQLDelete )

//---------------------------------------------------------------------------//

METHOD getSelectSentence()

   local cSQLSelect  := "SELECT * FROM " + ::cTableName

   cSQLSelect        += ::getSelectByColumn()

   cSQLSelect        += ::getSelectByOrder()

Return ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectByColumn()

   local cSQLSelect     := ""

   if !empty( ::cColumnOrder ) .and. !empty( ::cFind )
      cSQLSelect        += " WHERE upper(" + ::cColumnOrder +") LIKE '%" + ::cFind + "%'" 
   end if

Return ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectByOrder()

   local cSQLSelect  := ""

   if !empty( ::cColumnOrder )
      cSQLSelect     += " ORDER BY " + ::cColumnOrder
   end if 

   if !empty( ::cColumnOrientation ) .and. ::cColumnOrientation == "D"
      cSQLSelect     += " DESC"
   end if

Return ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD find( cFind )

   ::setFind( cFind )

   ::refreshSelect()

Return ( ::oRowSet:recCount() > 0 )

//---------------------------------------------------------------------------//

METHOD loadBlankBuffer()

   if empty( ::oRowSet )
      Return ( .f. )
   end if 

Return ( ::loadBuffer( 0 ) )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer()                

   if empty( ::oRowSet )
      Return ( .f. )
   end if 

Return ( ::loadBuffer( ::oRowSet:fieldGet( ::cColumnKey ) ) )   

//---------------------------------------------------------------------------//

METHOD loadBuffer( id )

   local n 

   ::hBuffer  := {=>}
   ::idBuffer := id

   ::oRowSet:goto( id )

   for n := 1 to ::oRowSet:fieldCount()
      hset( ::hBuffer, ::oRowSet:fieldname( n ), ::oRowSet:fieldget( n ) )
   next 

Return ( .t. )

//---------------------------------------------------------------------------//

Function convertToSql( value )

   if hb_isnumeric( value )
      Return ( alltrim(str( value ) ) )
   end if

   if hb_ischar( value )
      Return ( quoted( alltrim( value ) ) )
   end if

Return ( value )
       
//---------------------------------------------------------------------------//





















