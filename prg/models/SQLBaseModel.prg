#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseModel
<<<<<<< HEAD
  
   DATA     oRowSet
<<<<<<< HEAD

=======
>>>>>>> 1c2b54d10eb1748101cee5c2c1a759baee531d62
   DATA     cTableName
	DATA	   hColumns
  	DATA	   hBuffer

   DATA	   cSQLInsert     
   DATA     cSQLSelect      
<<<<<<< HEAD

=======
=======
 
  DATA     oRowSet

  DATA	   cSQLInsert     
  DATA     cSQLSelect      
>>>>>>> origin/master
>>>>>>> 1c2b54d10eb1748101cee5c2c1a759baee531d62
	DATA     cTableName
	DATA	   hColumns
  DATA     cColumnKey

<<<<<<< HEAD
  	DATA	   hBuffer
   DATA     idBuffer    
<<<<<<< HEAD
=======
=======
 	DATA	   hBuffer
  DATA     idBuffer    
>>>>>>> origin/master
>>>>>>> 1c2b54d10eb1748101cee5c2c1a759baee531d62
 
  DATA     cFind
  DATA     cColumnOrder
  DATA     cColumnOrientation
 
  METHOD   New()
  METHOD   End()

<<<<<<< HEAD
   METHOD   getSQLCreateTable()

=======
<<<<<<< HEAD
   METHOD   getSQLCreateTable()
>>>>>>> 1c2b54d10eb1748101cee5c2c1a759baee531d62
   METHOD	getInsertInto()                       INLINE	  ( ::cSQLInsert )
   METHOD   getSQLSelect()                        INLINE   ( ::cSQLSelect )
=======
  METHOD   getSQLCreateTable()
>>>>>>> origin/master

  METHOD	 getInsertInto()                       INLINE	 ( ::cSQLInsert )
  METHOD   getSQLSelect()                        INLINE   ( ::cSQLSelect )

  METHOD   getOrderRowSet()
  METHOD   freeRowSet()                          INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:= nil ), ) )

  METHOD   setFind( cFind )                      INLINE   ( ::cFind := cFind )
 
<<<<<<< HEAD
   METHOD   setColumnOrderBy( cColumn )           INLINE   ( ::cColumnOrder := cColumn )
   METHOD   setOrderOrientation( cOrientation )   INLINE   ( ::cColumnOrientation := cOrientation )

   METHOD   refreshSelect()                       INLINE   ( ::getOrderRowSet( .t. ) )
<<<<<<< HEAD

=======
>>>>>>> 1c2b54d10eb1748101cee5c2c1a759baee531d62
   METHOD	getInsertSentence()						    
   METHOD   getUpdateSentence()
   METHOD   getDeleteSentence()
=======
  METHOD   setColumnOrderBy( cColumn )           INLINE   ( ::cColumnOrder := cColumn )
  METHOD   setOrderOrientation( cOrientation )   INLINE   ( ::cColumnOrientation := cOrientation )

  METHOD   refreshSelect()                       INLINE   ( ::getOrderRowSet( .t. ) )

  METHOD 	getInsertSentence()						    
  METHOD   getUpdateSentence()
  METHOD   getDeleteSentence()
>>>>>>> origin/master
   
  METHOD   getOrderRowSet()
  METHOD   freeRowSet()                           INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet := nil ), ) )
  METHOD   getRowSetRecno()                       INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:recno() ) , 0 ) )
  METHOD   setRowSetRecno( nRecno )               INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:goto( nRecno ) ), ) )

<<<<<<< HEAD
   METHOD   setFind( cFind )                       INLINE   ( ::cFind := cFind )
 
   METHOD   setColumnOrderBy( cColumn )            INLINE   ( ::cColumnOrder := cColumn )
   METHOD   setOrderOrientation( cOrientation )    INLINE   ( ::cColumnOrientation := cOrientation )
=======
  METHOD   setFind( cFind )                      INLINE   ( ::cFind := cFind )
 
  METHOD   setColumnOrderBy( cColumn )           INLINE   ( ::cColumnOrder := cColumn )
  METHOD   setOrderOrientation( cOrientation )   INLINE   ( ::cColumnOrientation := cOrientation )
>>>>>>> 1c2b54d10eb1748101cee5c2c1a759baee531d62

<<<<<<< HEAD
    METHOD   refreshSelect()                       INLINE   ( ::getOrderRowSet( .t. ) )
<<<<<<< HEAD
=======
=======
  METHOD   refreshSelect()                       INLINE   ( ::getOrderRowSet( .t. ) )
>>>>>>> origin/master
>>>>>>> 1c2b54d10eb1748101cee5c2c1a759baee531d62

  METHOD   getSelectSentence()
 
  METHOD   getSelectByColumn()
 
  METHOD   getSelectByOrder()

  METHOD   find( cFind )

  METHOD   loadBuffer( id )
  METHOD   loadBlankBuffer()
  METHOD   loadCurrentBuffer()

<<<<<<< HEAD
   METHOD   getBuffer( cColumn )                   INLINE   ( hget( ::hBuffer, cColumn ) )
   METHOD   updateCurrentBuffer()                  INLINE   ( getSQLDatabase():Query( ::getUpdateSentence() ), ::refreshSelect() )
   METHOD   insertBuffer()                         INLINE   ( getSQLDatabase():Query( ::getInsertSentence() ), ::refreshSelect() )
   METHOD   deleteSelection()                      INLINE   ( getSQLDatabase():Query( ::getdeleteSentence() ), ::refreshSelect() )

   METHOD   getBuffer( cColumn )                   INLINE   ( hget( ::hBuffer, cColumn ) )
=======
<<<<<<< HEAD
   METHOD   getBuffer( cColumn )                  INLINE   ( hget( ::hBuffer, cColumn ) )
   METHOD   updateCurrentBuffer()                 INLINE   ( getSQLDatabase():Query( ::getUpdateSentence() ), ::refreshSelect() )
   METHOD   insertBuffer()                        INLINE   ( getSQLDatabase():Query( ::getInsertSentence() ), ::refreshSelect() )
   METHOD   deleteSelection()                     INLINE   ( getSQLDatabase():Query( ::getdeleteSentence() ), ::refreshSelect() )
   
   METHOD   getBuffer( cColumn )                  INLINE   ( hget( ::hBuffer, cColumn ) )
=======
  METHOD   updateCurrentBuffer()                 INLINE ( getSQLDatabase():Query( ::getUpdateSentence() ), ::refreshSelect() )
  METHOD   insertBuffer()                        INLINE ( getSQLDatabase():Query( ::getInsertSentence() ), ::refreshSelect() )
  METHOD   deleteSelection()                     INLINE ( getSQLDatabase():Query( ::getdeleteSentence() ), ::refreshSelect() )

  METHOD   getBuffer( cColumn )                  INLINE   ( hget( ::hBuffer, cColumn ) )
>>>>>>> origin/master
>>>>>>> 1c2b54d10eb1748101cee5c2c1a759baee531d62

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

      if !empty( oStmt )
         oStmt:free()
      end if    
   
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

   local cSQLDelete  := "DELETE FROM " + ::cTableName + " WHERE " + ::cColumnKey + " = " + convertToSql( ::oRowSet:fieldGet( ::cColumnKey ) )

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





















