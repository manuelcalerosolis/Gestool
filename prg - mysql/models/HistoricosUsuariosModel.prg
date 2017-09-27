#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS HistoricosUsuariosModel FROM SQLBaseModel

   DATA     cTableName           INIT "historicos_usuarios"

   METHOD   New()

   METHOD   deleteHistory( cTable )

   METHOD   getHistory( cTable )

   METHOD   saveHistory( cTable, cBrowseState, cColumnOrder, cOrientation, idToFind )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hColumns                    := {  "id"         	=>  { "create" => "INTEGER PRIMARY KEY AUTO_INCREMENT" },;
                                       "usuario_id"   =>  { "create" => "CHARACTER ( 3 ) NOT NULL"           },;
                                       "table_name"   =>  { "create" => "VARCHAR( 30 ) NOT NULL"             },;
                                       "browse_state" =>  { "create" => "VARCHAR(250)"                       },;
                                       "column_order" =>  { "create" => "VARCHAR( 30 ) NOT NULL" 		       },;
                                       "orientation"	=>  { "create" => "CHARACTER ( 1 ) NOT NULL"			    },;
                                       "id_to_find"   =>  { "create" => "INT NOT NULL"                       } }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getHistory( cTable )

   local oStmt
   local aFetch
   local cSentence   := "SELECT browse_state, column_order, orientation, id_to_find "        + ;
                           "FROM " + ::cTableName + " "                                      + ;
                           "WHERE table_name = " + toSQLString( cTable ) + " "               + ;
                              "AND usuario_id = " + toSQLString( oUser():cCodigo() ) + " "   + ;
                           "LIMIT 1"

   try 

    	oStmt          := ::Query( cSentence )

    	aFetch         := oStmt:fetchAll( FETCH_HASH )

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

   finally

      if !empty( oStmt )
         oStmt:free()
      end if    
   
   end

   if hb_isarray( aFetch )
    	RETURN ( aFetch )
   end if 

RETURN ( nil )
       
//---------------------------------------------------------------------------//

METHOD saveHistory( cTable, cBrowseState, cColumnOrder, cOrientation, idToFind )

   local id
   local cUpdateHistory 
   local cInternalSelect

   DEFAULT cColumnOrder    := ""
   DEFAULT cOrientation    := ""
   DEFAULT idToFind        := 0

   cInternalSelect         := "SELECT id FROM " + ::cTableName + " "                         + ;
                                 "WHERE table_name = " + toSQLString( cTable ) + " "         + ;
                                    "AND "                                                   + ;
                                    "usuario_id = " + toSQLString( oUser():cCodigo() ) 

   id                      := ::selectFetchArray( cInternalSelect )                   

   if empty(id)

      cUpdateHistory       := "INSERT INTO " + ::cTableName + " ( "                          + ;
                                    "usuario_id, "                                           + ;
                                    "table_name, "                                           + ;
                                    "browse_state, "                                         + ;
                                    "column_order, "                                         + ;
                                    "orientation, "                                          + ;
                                    "id_to_find ) "                                          + ;
                                 "VALUES ( "                                                 + ;
                                    toSQLString( oUser():cCodigo() ) + ", "                  + ;
                                    toSQLString( cTable ) + ","                              + ;
                                    cBrowseState + ", "                                      + ;
                                    toSQLString( cColumnOrder ) + ", "                       + ;
                                    toSQLString( cOrientation ) + ", "                       + ;
                                    alltrim( cvaltostr( idToFind ) )                         + ")"

   else                                     

      cUpdateHistory       := "UPDATE " + ::cTableName + " "                                 + ;
                                 "SET browse_state = " + cBrowseState + ", "                 + ;
                                    "column_order = " + toSQLString( cColumnOrder ) + ", "   + ;
                                    "orientation = " + toSQLString( cOrientation ) + ", "    + ;
                                    "id_to_find = " + alltrim( cvaltostr( idToFind ) ) + " " + ;
                                 "WHERE id = " + alltrim( cvaltostr( id ) )  


   end if 

   ::Query( cUpdateHistory )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteHistory( cTable )

   local oStmt
   local cSentence   := "DELETE FROM " + ::cTableName + " " + ;
                           "WHERE table_name = " + toSQLString( cTable ) + " AND usuario_id = " + toSQLString( oUser():cCodigo() )

   try 
      oStmt          := getSQLDatabase():Execute( cSentence )

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

   finally

      if !empty( oStmt )
        oStmt:free()
      end if    
   
   end

RETURN ( nil )
       
//---------------------------------------------------------------------------//
