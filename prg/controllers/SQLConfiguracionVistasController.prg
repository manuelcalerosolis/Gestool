#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLConfiguracionVistasController FROM SQLBaseController

   METHOD New( oController )

   METHOD setId( cViewType, cViewName, nId )    INLINE ( ::oModel:setId( cViewType, cViewName, nId ) )
   
   METHOD getId( cViewType, cViewName )         INLINE ( ::oModel:getId( cViewType, cViewName ) )

   METHOD setColumnOrder( cViewType, cViewName, cColumnOrder ) ;
                                                INLINE ( ::oModel:setColumnOrder( cViewType, cViewName, cColumnOrder ) )
   
   METHOD getColumnOrder( cViewType, cViewName ) ;
                                                INLINE ( ::oModel:getColumnOrder( cViewType, cViewName ) )

   METHOD setState( cViewType, cViewName, cState ) ;
                                                INLINE ( ::oModel:setState( cViewType, cViewName, cState ) )
   
   METHOD getState( cViewType, cViewName )      INLINE ( ::oModel:getState( cViewType, cViewName ) )

   METHOD getColumnOrderNavigator( cViewName )  INLINE ( ::oModel:getColumnOrderNavigator( cViewName ) )

   METHOD setColumnOrientation( cViewType, cViewName, cColumnOrientation ) ;
                                                INLINE ( ::oModel:setColumnOrientation( cViewType, cViewName, cColumnOrientation ) ) 
   
   METHOD getColumnOrientation( cViewType, cViewName ) ;
                                                INLINE ( ::oModel:getColumnOrientation( cViewType, cViewName ) ) 

   METHOD getColumnOrientationNavigator( cViewName ) ;
                                                INLINE ( ::oModel:getColumnOrientationNavigator( cViewName ) )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS SQLConfiguracionVistasController

   ::oSenderController                 := oSenderController

   ::oModel                            := SQLConfiguracionVistasModel():New( self )
   
RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLConfiguracionVistasModel FROM SQLBaseModel

   DATA cTableName                           INIT "configuracion_vistas"

   DATA cConstraints                         INIT  "PRIMARY KEY ( id ), UNIQUE KEY ( usuario_codigo, view_type, view_name )"

   METHOD getColumns()

   METHOD get( cViewType, cViewName )

   METHOD getNavigator( cViewName, cBrowseState, cColumnOrder, cOrientation, idToFind ) ;
                                                            INLINE ( ::get( "navigator", cViewName, cBrowseState, cColumnOrder, cOrientation, idToFind ) )

   METHOD getFieldName( cViewName )
   
   METHOD getState( cViewType, cViewName )
   METHOD setState( cViewType, cViewName, cBrowseState )    INLINE ( ::set( cViewType, cViewName, cBrowseState ) )

   METHOD getStateNavigator( cViewName )                    INLINE ( ::getState( "navigator", cViewName ) )   

   METHOD getColumnOrder( cViewType, cViewName )            INLINE ( ::getFieldName( cViewType, cViewName, "column_order" ) )
   METHOD getColumnOrderNavigator( cViewName )              INLINE ( ::getFieldName( "navigator", cViewName, "column_order" ) )
   METHOD getColumnOrderSelector( cViewName )               INLINE ( ::getFieldName( "selector", cViewName, "column_order" ) )
   
   METHOD getColumnOrientation( cViewType, cViewName )      INLINE ( ::getFieldName( cViewType, cViewName, "column_orientation" ) )
   METHOD getColumnOrientationNavigator( cViewName )        INLINE ( ::getFieldName( "navigator", cViewName, "column_orientation" ) )
   METHOD getColumnOrientationSelector( cViewName )         INLINE ( ::getFieldName( "selector", cViewName, "column_orientation" ) )

   METHOD getId( cViewType, cViewName )                     INLINE ( ::getFieldName( cViewType, cViewName, "id_to_find" ) )
   METHOD setId( cViewType, cViewName, nId )                INLINE ( ::set( cViewType, cViewName, nil, nil, nil, nId ) ) 

   METHOD set( cViewType, cViewName, cBrowseState, cColumnOrder, cOrientation, idToFind )

   METHOD setNavigator( cViewName, cBrowseState, cColumnOrder, cOrientation, idToFind ) ;
                                                            INLINE ( ::set( "navigator", cViewName, cBrowseState, cColumnOrder, cOrientation, idToFind ) )
   METHOD setSelector( cViewName, cBrowseState, cColumnOrder, cOrientation, idToFind ) ;
                                                            INLINE ( ::set( "selector", cViewName, cBrowseState, cColumnOrder, cOrientation, idToFind ) )
   
   METHOD setColumnOrder( cViewType, cViewName, cColumnOrder ) ;
                                                            INLINE ( ::set( cViewType, cViewName, nil, cColumnOrder ) ) 

   METHOD setColumnOrientation( cViewType, cViewName, cColumnOrientation ) ;
                                                            INLINE ( ::set( cViewType, cViewName, nil, nil, cColumnOrientation ) ) 

   METHOD delete( cViewType, cViewName )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLConfiguracionVistasModel

   ::hColumns  := {  "id"                 =>  { "create" => "INTEGER AUTO_INCREMENT"      },;
                     "view_type"          =>  { "create" => "VARCHAR( 40 ) NOT NULL"      },;
                     "view_name"          =>  { "create" => "VARCHAR( 60 ) NOT NULL"      },;
                     "usuario_codigo"     =>  { "create" => "VARCHAR( 20 ) NOT NULL"      },;                     
                     "browse_state"       =>  { "create" => "TEXT"                        },;
                     "column_order"       =>  { "create" => "VARCHAR( 60 )"               },;
                     "column_orientation" =>  { "create" => "CHARACTER( 1 )"	            },;
                     "id_to_find"         =>  { "create" => "INT"                         } }

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD get( cViewType, cViewName ) CLASS SQLConfiguracionVistasModel

   local aFetch
   local cSentence   := "SELECT browse_state, column_order, column_orientation, id_to_find "       + ;
                           "FROM " + ::getTableName() + " "                                        + ;
                           "WHERE "                                                                + ;
                              "view_type = " + quoted( cViewType )   + " AND "                     + ;
                              "view_name = " + quoted( cViewName )   + " AND "                     + ;
                              "usuario_codigo = " + quoted( Auth():Codigo() ) + " "                + ; 
                           "LIMIT 1"

   aFetch            := getSQLDatabase():selectFetchHash( cSentence, .f. )

   if hb_isarray( aFetch ) .and. !empty( aFetch )
    	RETURN ( atail( aFetch ) )
   end if 

RETURN ( nil )
       
//---------------------------------------------------------------------------//

METHOD getFieldName( cViewType, cViewName, cFieldName ) CLASS SQLConfiguracionVistasModel

   local aFetch   := ::get( cViewType, cViewName )

   if empty( aFetch )
      RETURN ( nil )
   end if 

RETURN ( hget( aFetch, cFieldName ) )
       
//---------------------------------------------------------------------------//

METHOD getState( cViewType, cViewName ) CLASS SQLConfiguracionVistasModel

   local cState
   local hFetch   := ::get( cViewType, cViewName )

   if empty( hFetch )
      RETURN ( nil )
   end if 
   
   cState         := hget( hFetch, "browse_state" )
   if empty( cState )
      RETURN ( nil )
   end if 

   cState         := strtran( cState, '\"', '"' )

RETURN ( cState )
       
//---------------------------------------------------------------------------//

METHOD set( cViewType, cViewName, cBrowseState, cColumnOrder, cOrientation, idToFind ) CLASS SQLConfiguracionVistasModel

   local cSentence  

   if empty( cViewType )
      RETURN ( Self )
   end if 

   if empty( cViewName )
      RETURN ( Self )
   end if 

   if empty( cBrowseState ) .and. empty( cColumnOrder ) .and. empty( cOrientation ) .and. empty( idToFind )
      RETURN ( Self )
   end if 
   
   cSentence            := "INSERT INTO " + ::getTableName() + " ( "                               
   cSentence            +=       "view_type, "                                               
   cSentence            +=       "view_name, "     
   cSentence            +=       "usuario_codigo, "     

   if !empty( cBrowseState )                                          
      cBrowseState      := getSQLDatabase():escapeStr( cBrowseState ) 
      cSentence         +=       "browse_state, "                                            
   end if 

   if !empty( cColumnOrder )
      cSentence         +=       "column_order, "                                          
   end if 
   
   if !empty( cOrientation )
      cSentence         +=       "column_orientation, "                                           
   end if 
   
   if !empty( idToFind )
      cSentence         +=       "id_to_find, "                                               
   end if 

   cSentence            := chgAtEnd( cSentence, ' ) ', 2 )

   cSentence            += "VALUES ( "                                                    
   cSentence            +=       quoted( cViewType ) + ", "                          
   cSentence            +=       quoted( cViewName ) + ", "  
   cSentence            +=       quoted( Auth():Codigo() ) + ", "

   if !empty( cBrowseState )                                          
      cSentence         +=       quoted( cBrowseState ) + ", "                               
   end if 

   if !empty( cColumnOrder )
      cSentence         +=       quoted( cColumnOrder ) + ", "                           
   end if 

   if !empty( cOrientation )
      cSentence         +=       quoted( cOrientation ) + ", "                           
   end if 

   if !empty( idToFind )
      cSentence         +=       alltrim( cvaltostr( idToFind ) ) + ", "
   end if

   cSentence            := chgAtEnd( cSentence, ' ) ', 2 )

   cSentence            += "ON DUPLICATE KEY "

   cSentence            += "UPDATE "                                                      
   
   if !empty( cBrowseState )                                          
      cSentence         +=    "browse_state = " + quoted( cBrowseState ) + ", "           
   end if

   if !empty( cColumnOrder )
      cSentence         +=    "column_order = " + quoted( cColumnOrder ) + ", "           
   end if

   if !empty( cOrientation )
      cSentence         +=    "column_orientation = " + quoted( cOrientation ) + ", "            
   end if

   if !empty( idToFind )
      cSentence         +=    "id_to_find = " + toSqlString( idToFind ) + ", "
   end if

   cSentence            := chgAtEnd( cSentence, '', 2 )

   getSQLDatabase():Exec( cSentence  )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD delete( cViewType, cViewName ) CLASS SQLConfiguracionVistasModel

   local cSentence   := "DELETE FROM " + ::getTableName() + " "                              + ;
                           "WHERE "                                                          + ;
                              "view_type = " + quoted( cViewType ) + " AND "                 + ;
                              "view_name = " + quoted( cViewName ) + " AND "                 + ;
                              "usuario_codigo = " + quoted( Auth():Codigo() )

   getSQLDatabase():Exec( cSentence  )

RETURN ( nil )
       
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLConfiguracionVistasCompanyModel FROM SQLConfiguracionVistasModel

   METHOD getTableName()   INLINE ( Company():getTableName( ::cTableName ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//