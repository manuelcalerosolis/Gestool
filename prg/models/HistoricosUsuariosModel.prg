#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS HistoricosUsuariosModel FROM SQLBaseModel

   DATA     cTableName           INIT "historicos_usuarios"

   METHOD   New()

   METHOD   getHistory()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hColumns                    := {  "id"         	=>   "INTEGER PRIMARY KEY AUTOINCREMENT" , ;
                                       "usuario_id"	=>   "CHARACTER ( 3 ) NOT NULL"          , ;
                                       "tabla"    		=>   "VARCHAR( 30 ) NOT NULL"            , ;
                                       "orden"    		=>   "VARCHAR( 30 ) NOT NULL" 		     , ;
                                       "orientacion"	=>   "CHARACTER ( 1 ) NOT NULL"			  , ;
                                       "recno"    		=>   "INT NOT NULL" }

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getHistory( cTable )

   local oStmt
   local aFetch
   local cSentence   := "SELECT orden, orientacion, recno "    + ;
                           "FROM " + ::cTableName + " "        + ;
                           "WHERE tabla = " + quoted( cTable ) + " AND usuario_id = " + quoted( oUser():cCodigo() )

   msgalert( cSentence, "cSentence" )

   try 
      oStmt          := getSQLDatabase():Query( cSentence )

      aFetch         := oStmt:fetchAll( FETCH_HASH )
      msgalert( hb_valtoexp( aFetch ), "array()" )

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

      if !empty( oStmt )
         oStmt:free()
      end if    
   
   end

   if !empty( aFetch ) .and. hb_isarray( aFetch )
      msgalert( hb_valtoexp( atail( aFetch ) ), "hHash" )

      Return ( atail( aFetch ) )
   end if 

Return ( nil )
       
//---------------------------------------------------------------------------//
