#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseModel
  
   DATA     oRowSet

   DATA     cTableName
   DATA     cDbfTableName
	DATA	   hColumns

   DATA     aDbfFields

   DATA     cColumnOrder
   DATA     cOrientation
   DATA     nIdForRecno

   DATA	   cSQLInsert     
   DATA     cSQLSelect      
   
   DATA     cColumnKey

  	DATA	   hBuffer   
   DATA     cFind

   METHOD   New()
   METHOD   End()
 
   METHOD   getSQLCreateTable()
   METHOD   getSQLDropTable()
   METHOD   getImportSentence( cPath )
   METHOD   makeImportDbfSQL( cPath )
   METHOD   getSelectSentence()
   METHOD   getInsertSentence()                     
   METHOD   getUpdateSentence()
   METHOD   getDeleteSentence()

   METHOD   getTableName                           INLINE ( ::cTableName )

   METHOD   setColumnOrder( cColumnOrder )         INLINE ( ::cColumnOrder := cColumnOrder )
   METHOD   setOrientation( cOrientation )         INLINE ( ::cOrientation := cOrientation )
   METHOD   setIdForRecno( nIdForRecno )           INLINE ( ::nIdForRecno := nIdForRecno )


   METHOD   setFind( cFind )                      INLINE   ( ::cFind := cFind )
   METHOD   getRowSet()
   METHOD   buildRowSet()
   METHOD   buildRowSetWithRecno()                 INLINE   ( ::buildRowSet( .t. ) )
   METHOD   freeRowSet()                           INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet := nil ), ) )
   METHOD   getRowSetRecno()                       INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:recno() ) , 0 ) )
   METHOD   setRowSetRecno( nRecno )               INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:goto( nRecno ) ), ) )
   METHOD   setIdForRecno( nIdForRecno )           INLINE   ( ::nIdForRecno := nIdForRecno )
   METHOD   getKeyFieldOfRecno()                   INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:fieldGet( ::cColumnKey ) ), ) )
 
   METHOD   getSelectByColumn()
   METHOD   getSelectByOrder()

   METHOD   find( cFind )

   METHOD   loadBuffer( id )
   METHOD   loadBlankBuffer()
   METHOD   loadCurrentBuffer()

   METHOD   getBuffer( cColumn )                   INLINE   ( hget( ::hBuffer, cColumn ) )
   METHOD   updateCurrentBuffer()                  INLINE   ( getSQLDatabase():Query( ::getUpdateSentence() ), ::buildRowSet() )
   METHOD   insertBuffer()                         INLINE   ( getSQLDatabase():Query( ::getInsertSentence() ), ::buildRowSet() )
   METHOD   deleteSelection()                      INLINE   ( getSQLDatabase():Query( ::getdeleteSentence() ), ::buildRowSet() )

   METHOD   selectFetchArray( cSentence )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cColumnKey                  := "id"

   ::cFind                       := ""

   ::cColumnOrder                := "id"
   ::cOrientation                := "A"
   ::nIdForRecno                 := 1

Return ( Self )

//---------------------------------------------------------------------------//

METHOD End()
   
   ::freeRowSet()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getSQLCreateTable()
   
   Local cSQLCreateTable := "CREATE TABLE " + ::cTableName + " ( "

   hEval( ::hColumns, {| k, hash | cSQLCreateTable += k + " " + hget( hash, "create" ) + ", " } )

   cSQLCreateTable        := ChgAtEnd( cSQLCreateTable, ' )', 2 )

Return ( cSQLCreateTable )

//---------------------------------------------------------------------------//

METHOD getSQLDropTable()
   
   Local cSQLDropTable := "DROP TABLE " + ::cTableName

Return ( cSQLDropTable )

//---------------------------------------------------------------------------//

METHOD getImportSentence( cPath )
   
   local dbf
   local cValues     := ""
   local cInsert     := ""

   default cPath     := cPatDat()

   dbUseArea( .t., cLocalDriver(), cPath + "\" + ::cDbfTableName + ".dbf", cCheckArea( "dbf", @dbf ), .f. )
   if ( dbf )->( neterr() )
      Return ( cInsert )
   end if 

   cInsert              := "INSERT INTO " + ::cTableName + " ( "
   hEval( ::hColumns, {| k | if ( k != ::cColumnKey, cInsert += k + ", ", ) } )
   cInsert           := ChgAtEnd( cInsert, ' ) VALUES ', 2 )

   ( dbf )->( dbgotop() )
   while ( dbf )->( !eof() )

      cValues           += "( "
      hEval( ::hColumns, {| k, hash | if ( k != ::cColumnKey,;
                                             cValues += convertToSql( ( dbf )->( fieldget( fieldpos( hget( hash, "dbfField" ) ) ) ) ) + ", " , )  } )
      // aeval( ::aDbfFields, {|cField| cValues += convertToSql( ( dbf )->( fieldget( fieldpos( cField ) ) ) ) + ", " } )
      cValues           := chgAtEnd( cValues, ' ), ', 2 )

      ( dbf )->( dbskip() )
   end while

   cValues              := chgAtEnd( cValues, '', 2 )

   cInsert              += cValues

   ( dbf )->( dbclosearea() )

Return ( cInsert )

//---------------------------------------------------------------------------//

METHOD makeImportDbfSQL( cPath )

   local cImportSentence

   default cPath     := cPatDat()

   if !( file( cPath + "\" + ::cDbfTableName + ".dbf" ) )
      msgStop( "El fichero " + cPath + "\" + ::cDbfTableName + ".dbf" + " no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   cImportSentence   := ::getImportSentence( cPath )
   if empty( cImportSentence )
      Return ( self )
   end if 

   getSQLDatabase():Exec( ::getSQLDropTable() )

   getSQLDatabase():Exec( ::getSQLCreateTable() )

   getSQLDatabase():Exec( cImportSentence )

   frename( cPath + "\" + ::cDbfTableName + ".dbf", cPath + "\" + "old-" + ::cDbfTableName + ".dbf" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getRowSet()

   if empty( ::oRowSet )
      ::buildRowSet()
   end if

Return ( ::oRowSet )

//---------------------------------------------------------------------------//

METHOD buildRowSet( lWithRecno )

   local oStmt

   default  lWithRecno  := .f.

   try
      oStmt             := getSQLDatabase():Query( ::getSelectSentence() ) 
      ::oRowSet         := oStmt:fetchRowSet()

      if lWithRecno .and. !empty( ::nIdForRecno )
         if ::oRowSet:find( ::nIdForRecno , ::cColumnKey, .t. ) == 0
            ::oRowSet:goTop()
         end if
      else 
         ::oRowSet:goTop()
      end if

   catch
      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )
      if !empty( oStmt )
         oStmt:free()
      end if    
   
   end

Return ( self )

//---------------------------------------------------------------------------//

METHOD getUpdateSentence()

  local cSQLUpdate  := "UPDATE " + ::cTableName + " SET "

  hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLUpdate += k + " = " + convertToSql( v ) + ", ", ) } )

  cSQLUpdate        := ChgAtEnd( cSQLUpdate, '', 2 )

  cSQLUpdate        += " WHERE " + ::cColumnKey + " = " + convertToSql( ::oRowSet:fieldget( ::cColumnKey ) ) 

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

   local cSQLDelete  := "DELETE FROM " + ::cTableName + " WHERE " + ::cColumnKey + " = " + convertToSql( ::oRowSet:fieldGet( ::cColumnKey ) )

Return ( cSQLDelete )

//---------------------------------------------------------------------------//

METHOD getSelectSentence()

   local cSQLSelect  := "SELECT * FROM " + ::cTableName

   cSQLSelect        += ::getSelectByColumn()

   cSQLSelect        += ::getSelectByOrder()

Return ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectByColumn( cColumnOrder )

   local cSQLSelect     := ""

   if !empty( ::cColumnOrder ) .and. !empty( ::cFind )
      cSQLSelect        += " WHERE upper(" + ::cColumnOrder +") LIKE '%" + ::cFind + "%'" 
   end if

Return ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectByOrder( cColumnOrder, cOrientation )

   local cSQLSelect  := ""

   if !empty( ::cColumnOrder )
      cSQLSelect     += " ORDER BY " + ::cColumnOrder
   end if 

   if !empty( ::cOrientation ) .and. ::cOrientation == "D"
      cSQLSelect     += " DESC"
   end if

Return ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD find( cFind )

   ::setFind( cFind )

   ::buildRowSet()

Return ( ::oRowSet:recCount() > 0 )

//---------------------------------------------------------------------------//

METHOD loadBlankBuffer()

   if empty( ::oRowSet )
      Return ( .f. )
   end if 

Return ( ::loadBuffer( 0 ) )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer()                

   local n

   if empty( ::oRowSet )
      Return ( .f. )
   end if 

   ::hBuffer  := {=>}

   for n := 1 to ::oRowSet:fieldCount()
      hset( ::hBuffer, ::oRowSet:fieldname( n ), ::oRowSet:fieldget( n ) )
   next 

Return ( ::hBuffer )   

//---------------------------------------------------------------------------//

METHOD loadBuffer( id )

   local n 

   ::hBuffer  := {=>}

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

METHOD selectFetchArray( cSentence )

   local oStmt
   local aFetch

   try 
      oStmt          := getSQLDatabase():Query( cSentence )
      aFetch         := oStmt:fetchAll( FETCH_ARRAY )
   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

      if !empty( oStmt )
        oStmt:free()
      end if    
   
   end

   if !empty( aFetch ) .and. hb_isarray( aFetch )
      Return ( aFetch )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

