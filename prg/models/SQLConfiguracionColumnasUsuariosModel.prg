#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLConfiguracionColumnasUsuariosModel FROM SQLBaseModel

   DATA cTableName           INIT "configuracion_columnas_usuarios"

   METHOD New()

   METHOD delete( cViewName )

   METHOD get( cViewName )

   METHOD set( cViewName, cBrowseState, cColumnOrder, cOrientation, idToFind )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::hColumns                    := {  "id"           =>  { "create" => "INTEGER PRIMARY KEY AUTO_INCREMENT"   },;
                                       "usuario_id"   =>  { "create" => "CHARACTER ( 3 ) NOT NULL"             },;
                                       "view_name"    =>  { "create" => "VARCHAR( 60 ) NOT NULL"               },;
                                       "browse_state" =>  { "create" => "LONGTEXT"                             },;
                                       "column_order" =>  { "create" => "VARCHAR( 60 )"               },;
                                       "orientation"  =>  { "create" => "CHARACTER ( 1 )"	            },;
                                       "id_to_find"   =>  { "create" => "INT"                         } }

   ::Super:New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD get( cViewName )

   local oStmt
   local aFetch
   local cSentence   := "SELECT browse_state, column_order, orientation, id_to_find "        + ;
                           "FROM " + ::cTableName + " "                                      + ;
                           "WHERE view_name = " + quoted( cViewName ) + " "                  + ;
                              "AND usuario_id = " + quoted( oUser():cCodigo() ) + " "        + ;
                           "LIMIT 1"

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

   if hb_isarray( aFetch )
    	RETURN ( atail( aFetch ) )
   end if 

RETURN ( nil )
       
//---------------------------------------------------------------------------//

METHOD set( cViewName, cBrowseState, cColumnOrder, cOrientation, idToFind )

   local id
   local cUpdateHistory 
   local cInternalSelect

   DEFAULT cColumnOrder    := ""
   DEFAULT cOrientation    := ""
   DEFAULT idToFind        := 0

   cInternalSelect         := "SELECT id FROM " + ::cTableName + " "                         + ;
                                 "WHERE view_name = " + quoted( cViewName ) + " "            + ;
                                    "AND usuario_id = " + quoted( oUser():cCodigo() ) 

   id                      := getSQLDatabase():selectFetchArrayOneColumn( cInternalSelect )                   

   logwrite( cInternalSelect)

   msgalert( hb_valtoexp(id), "id")

   if empty(id)

      cUpdateHistory       := "INSERT INTO " + ::cTableName + " ( "                          + ;
                                    "usuario_id, "                                           + ;
                                    "view_name, "                                            + ;
                                    "browse_state, "                                         + ;
                                    "column_order, "                                         + ;
                                    "orientation, "                                          + ;
                                    "id_to_find ) "                                          + ;
                                 "VALUES ( "                                                 + ;
                                    quoted( oUser():cCodigo() ) + ", "                       + ;
                                    quoted( cViewName ) + ","                                + ;
                                    quoted( cBrowseState ) + ", "                            + ;
                                    quoted( cColumnOrder ) + ", "                            + ;
                                    quoted( cOrientation ) + ", "                            + ;
                                    alltrim( cvaltostr( idToFind ) )                         + ")"

   else                                     

      cUpdateHistory       := "UPDATE " + ::cTableName + " "                                 + ;
                                 "SET browse_state = " + quoted( cBrowseState ) + ", "       + ;
                                    "column_order = " + quoted( cColumnOrder ) + ", "        + ;
                                    "orientation = " + quoted( cOrientation ) + ", "         + ;
                                    "id_to_find = " + alltrim( cvaltostr( idToFind ) ) + " " + ;
                                 "WHERE id = " + alltrim( cvaltostr( id ) )  

   end if 

   logwrite( cUpdateHistory )

   msgalert( hb_valtoexp( getSQLDatabase():Exec( cUpdateHistory ) ), "Query" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD delete( cViewName )

   local oStmt
   local cSentence   := "DELETE FROM " + ::cTableName + " "                                  + ;
                           "WHERE view_name = " + quoted( cViewName ) + " "                  + ;
                              "AND usuario_id = " + quoted( oUser():cCodigo() )

   try 
      oStmt          := getSQLDatabase():Exec( cSentence )

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

   finally

      if !empty( oStmt )
        oStmt:free()
      end if    
   
   end

RETURN ( nil )
       
//---------------------------------------------------------------------------//
