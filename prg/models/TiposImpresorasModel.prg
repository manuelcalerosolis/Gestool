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

   METHOD   getRowSet()
   METHOD   freeRowSet()         INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:free(), ::oRowSet := nil ), ) )

   METHOD   getSelectOrderBy( order ) ;
                                 INLINE   ( ::cSQLSelect + if( empty( order ), "", " ORDER BY " + order ) + ";" ) 

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

METHOD getRowSet( order )

   local oStmt

   if !empty( ::oRowSet )
      Return ( ::oRowSet )
   end if 

   try
      oStmt          := getSQLDatabase():Query( ::getSelectOrderBy( order ) )

      if empty( ::oRowSet )
         ::oRowSet   := oStmt:fetchRowSet()
         ::oRowSet:goTop()
      end if 

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

      oStmt:free()
   
   end

Return ( ::oRowSet )

//---------------------------------------------------------------------------//