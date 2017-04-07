#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseModel
  
    DATA     oRowSet

	  DATA     cTableName
	  DATA	   hColumns
  	DATA	   cColumns

    DATA	   cSQLInsert     
    DATA     cSQLSelect      
 
    DATA     cFind
    DATA     cColumnOrder
    DATA     cColumnOrientation
 
    METHOD   New()
    METHOD   End()

    METHOD   getSQLCreateTable()
    METHOD	 getInsertInto()						            INLINE	 ( ::cSQLInsert )
    METHOD   getSQLSelect()                         INLINE   ( ::cSQLSelect )

    METHOD 	 getcValues
 
    METHOD   getOrderRowSet()
    METHOD   freeRowSet()                           INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:= nil ), ) )

    METHOD   setFind( cFind )                       INLINE   ( ::cFind := cFind )
 
    METHOD   setColumnOrderBy( cColumn )            INLINE   ( ::cColumnOrder := cColumn )
    METHOD   setOrderOrientation( cOrientation )    INLINE   ( ::cColumnOrientation := cOrientation )

    METHOD   refreshSelect()                        INLINE   ( ::getOrderRowSet( .t. ) )

    METHOD   getSelectSentence()
 
    METHOD   getSelectByColumn()
 
    METHOD   getSelectByOrder()

    METHOD   find( cFind )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cSQLSelect          := "SELECT * FROM " + ::cTableName

   // ::cSQLInsert					 := "INSERT INTO " + ::cTableName + ::cColumns + " VALUES "

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

   msgalert( cSQLCreateTable, cSQLCreateTable )

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

METHOD getSelectSentence()

   local cSQLSelect  := ::cSQLSelect

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

METHOD getcValues()

  Local cValues

Return ( cValues )

//---------------------------------------------------------------------------//