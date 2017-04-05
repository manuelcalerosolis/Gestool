#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasModel FROM BaseModel

   DATA     cTableName
   DATA     cSQLSelect           
   DATA     cSQLCreateTable

   METHOD   New()
   METHOD   End()

   METHOD   getSQLCreateTable()  INLINE   ( ::cSQLCreateTable )
   METHOD   getSQLSelect()       INLINE   ( ::cSQLSelect )

   METHOD   getOrderRowSet()
   METHOD   freeRowSet()         INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:= nil ), ) )

   METHOD   refreshSelectOrderBy( cNomCol, cOrder ) ;
                                 INLINE   ( ::getOrderRowSet( cNomCol, cOrder, .t. ) )

   METHOD   getSelectOrderBy( cNomCol, cOrder ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTableName                  := "tipos_impresoras"

   ::cSQLCreateTable             := "CREATE TABLE " + ::cTableName + " ( "                 + ;
                                       "id         INTEGER PRIMARY KEY AUTOINCREMENT, "    + ;
                                       "nombre     VARCHAR( 50 ) NOT NULL );"

   ::cSQLSelect                  := "SELECT * FROM " + ::cTableName 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD End()
   
   ::freeRowSet()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getOrderRowSet( cNomCol, cOrder, lRefresh )

   local oStmt

   if hb_isnil( lRefresh ) .and. !empty( ::oRowSet )
      Return ( ::oRowSet )
   end if 

   try
      oStmt          := getSQLDatabase():Query( ::getSelectOrderBy( cNomCol, cOrder ) )

      ::oRowSet      := oStmt:fetchRowSet()
      ::oRowSet:goTop()

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

      oStmt:free()
   
   end

Return ( ::oRowSet )

//---------------------------------------------------------------------------//

METHOD getSelectOrderBy( cNomCol, cOrder )

   local cSQLSelect  := ::cSQLSelect

   if !empty( cNomCol )
      cSQLSelect     += " ORDER BY " + cNomCol
   end if 

   if !empty( cOrder  ) .and. cOrder == "D"
      cSQLSelect     += " DESC"
   end if

Return ( cSQLSelect )

//---------------------------------------------------------------------------//