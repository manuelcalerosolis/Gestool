#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS HistoricosUsuariosModel FROM SQLBaseModel

   DATA     cTableName           INIT "historicos_usuarios"

   METHOD   New()

   METHOD   getHistory( cTable )

   METHOD   saveHistory( cTable, cBrowseState, cColumnOrder, cOrientation, nIdForRecno )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hColumns                    := {  "id"         	=>  { "create" => "INTEGER PRIMARY KEY AUTOINCREMENT"  },;
                                       "usuario_id"   =>  { "create" => "CHARACTER ( 3 ) NOT NULL"           },;
                                       "cTableName"   =>  { "create" => "VARCHAR( 30 ) NOT NULL"             },;
                                       "cBrowseState" =>  { "create" => "VARCHAR(250)"                       },;
                                       "cColumnOrder" =>  { "create" => "VARCHAR( 30 ) NOT NULL" 		       },;
                                       "cOrientation"	=>  { "create" => "CHARACTER ( 1 ) NOT NULL"			    },;
                                       "nIdForRecno"  =>  { "create" => "INT NOT NULL"                       } }


   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getHistory( cTable )

   local oStmt
   local aFetch
   local cSentence   := "SELECT cBrowseState, cColumnOrder, cOrientation, nIdForRecno "                                 + ;
                           "FROM " + ::cTableName + " "                                                                 + ;
                           "WHERE cTableName = " + toSQLString( cTable ) + " AND usuario_id = " + toSQLString( oUser():cCodigo() )

   try 
    	oStmt          := getSQLDatabase():Query( cSentence )
    	aFetch         := oStmt:fetchAll( FETCH_HASH )
   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

   finally

      if !empty( oStmt )
        oStmt:free()
      end if    
   
   end

   if !empty( aFetch ) .and. hb_isarray( aFetch )
    	Return ( atail( aFetch ) )
   end if 

Return ( nil )
       
//---------------------------------------------------------------------------//

METHOD saveHistory( cTable, cBrowseState, cColumnOrder, cOrientation, nIdForRecno )

   local cUpdateHistory 
   local cInternalSelect

   if empty( nIdForRecno )
      RETURN ( Self )
   end if 

   cInternalSelect   := "( SELECT id FROM " + ::cTableName                 + ;
                           " WHERE cTableName = " + toSQLString( cTable )  + ;
                           " AND "                                         + ;
                           " usuario_id = " + toSQLString( oUser():cCodigo() ) + " )"

   cUpdateHistory    := "REPLACE INTO " + ::cTableName                     + ;
                        "  (  id, "                                        + ;
                              "usuario_id, "                               + ;
                              "cTableName, "                               + ;
                              "cBrowseState, "                             + ;
                              "cColumnOrder, "                             + ;
                              "cOrientation, "                             + ;
                              "nIdForRecno ) "                             + ;
                        "  VALUES (" + cInternalSelect +  ", "             + ;
                              toSQLString( oUser():cCodigo() ) + ", "      + ;
                              toSQLString( cTable ) + ","                  + ;
                              cBrowseState + ", "                          + ;
                              toSQLString( cColumnOrder ) + ", "           + ;
                              toSQLString( cOrientation ) + ", "           + ;
                              alltrim( cvaltostr( nIdForRecno ) )          + ")"

  ::Query( cUpdateHistory )

RETURN ( Self )

//---------------------------------------------------------------------------//
