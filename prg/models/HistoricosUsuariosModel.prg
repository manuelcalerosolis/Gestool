#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS HistoricosUsuariosModel FROM SQLBaseModel

   DATA     cTableName           INIT "historicos_usuarios"

   METHOD   New()

   METHOD   getHistory( cTable )

   METHOD   saveHistory( cColumnOrder, cOrientation, nIdForRecno, cTable )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hColumns                    := {  "id"         	=>  { "create" => "INTEGER PRIMARY KEY AUTOINCREMENT"  }, ;
                                       "usuario_id"	  =>  { "create" => "CHARACTER ( 3 ) NOT NULL"           }, ;
                                       "cTableName"   =>  { "create" => "VARCHAR( 30 ) NOT NULL"             }, ;
                                       "cColumnOrder" =>  { "create" => "VARCHAR( 30 ) NOT NULL" 		         }, ;
                                       "cOrientation"	=>  { "create" => "CHARACTER ( 1 ) NOT NULL"			     }, ;
                                       "nIdForRecno"  =>  { "create" => "INT NOT NULL" } }

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getHistory( cTable )

   local oStmt
   local aFetch
   local cSentence   := "SELECT cColumnOrder, cOrientation, nIdForRecno "    + ;
                           "FROM " + ::cTableName + " "                 + ;
                           "WHERE cTableName = " + quoted( cTable ) + " AND usuario_id = " + quoted( oUser():cCodigo() )

   try 
    	oStmt          := getSQLDatabase():Query( cSentence )
    	aFetch         := oStmt:fetchAll( FETCH_HASH )
   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

      if !empty( oStmt )
        oStmt:free()
      end if    
   
   end

   if !empty( aFetch ) .and. hb_isarray( aFetch )
    	Return ( atail( aFetch ) )
   end if 

Return ( nil )
       
//---------------------------------------------------------------------------//

METHOD   saveHistory( cColumnOrder, cOrientation, nIdForRecno, cTable )

  local cInternalSelect :=  "( SELECT id FROM " + ::cTableName + " WHERE cTableName = " + quoted( cTable ) + " AND "           + ;
                            " usuario_id = " + quoted( oUser():cCodigo() )

  local cUpdateHistory := "REPLACE INTO " + ::cTableName + " ( id, usuario_id, cTableName, cColumnOrder, cOrientation, nIdForRecno ) " + ;
                          " VALUES ( " + cInternalSelect +  " ), " + quoted( oUser():cCodigo() ) + ", " + quoted( cTable )             + ;
                          ", " + quoted( cColumnOrder ) + ", " + quoted ( cOrientation ) + ", " + alltrim( str( nIdForRecno ) ) + ")"

  getSQLDatabase():Query( cUpdateHistory )

Return ( Self )

//---------------------------------------------------------------------------//
