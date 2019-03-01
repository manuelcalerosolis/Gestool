#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLConfiguracionVistasGestoolController FROM SQLConfiguracionVistasController

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLConfiguracionVistasGestoolModel():New( self ), ), ::oModel )

ENDCLASS

//---------------------------------------------------------------------------//

CLASS SQLConfiguracionVistasController FROM SQLBaseController

   METHOD New( oController )

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLConfiguracionVistasModel():New( self ), ), ::oModel )

   METHOD setId( cViewType, cViewName, nId ) ;
                                       INLINE ( ::getModel():setId( cViewType, cViewName, nId ) )
   
   METHOD getId( cViewType, cViewName ) ;
                                       INLINE ( ::getModel():getId( cViewType, cViewName ) )

   METHOD setColumnOrder( cViewType, cViewName, cColumnOrder ) ;
                                       INLINE ( ::getModel():setColumnOrder( cViewType, cViewName, cColumnOrder ) )
   
   METHOD getColumnOrder( cViewType, cViewName ) ;
                                       INLINE ( ::getModel():getColumnOrder( cViewType, cViewName ) )

   METHOD setState( cViewType, cViewName, cState ) ;
                                       INLINE ( ::getModel():setState( cViewType, cViewName, cState ) )
   
   METHOD getState( cViewType, cViewName ) ;
                                       INLINE ( ::getModel():getState( cViewType, cViewName ) )

   METHOD getColumnOrderNavigator( cViewName ) ;
                                       INLINE ( ::getModel():getColumnOrderNavigator( cViewName ) )

   METHOD setColumnOrientation( cViewType, cViewName, cColumnOrientation ) ;
                                       INLINE ( ::getModel():setColumnOrientation( cViewType, cViewName, cColumnOrientation ) ) 
   
   METHOD getColumnOrientation( cViewType, cViewName ) ;
                                       INLINE ( ::getModel():getColumnOrientation( cViewType, cViewName ) ) 

   METHOD getColumnOrientationNavigator( cViewName ) ;
                                       INLINE ( ::getModel():getColumnOrientationNavigator( cViewName ) )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS SQLConfiguracionVistasController

   ::oController                 := oController

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLConfiguracionVistasGestoolModel FROM SQLConfiguracionVistasModel

   METHOD getTableName()               INLINE ( "gestool." + ::cTableName )

END CLASS

//---------------------------------------------------------------------------//

CLASS SQLConfiguracionVistasModel FROM SQLCompanyModel

   DATA cTableName                     INIT "configuracion_vistas"

   DATA cConstraints                   INIT  "PRIMARY KEY ( id ), UNIQUE KEY ( usuario_codigo, view_type, view_name )"

   METHOD getColumns()

   METHOD get( cViewType, cViewName )

   METHOD getNavigator( cViewName, cBrowseState, cColumnOrder, cOrientation, idToFind ) ;
                                       INLINE ( ::get( "navigator", cViewName, cBrowseState, cColumnOrder, cOrientation, idToFind ) )

   METHOD getFieldName( cViewName )
   
   METHOD getState( cViewType, cViewName )
   METHOD setState( cViewType, cViewName, cBrowseState ) ;
                                       INLINE ( ::set( cViewType, cViewName, cBrowseState ) )

   METHOD getStateNavigator( cViewName ) ;
                                       INLINE ( ::getState( "navigator", cViewName ) )   

   METHOD getColumnOrder( cViewType, cViewName, cUserCode ) ;
                                       INLINE ( ::getFieldName( cViewType, cViewName, cUserCode, "column_order" ) )
   METHOD getColumnOrderNavigator( cViewName, cUserCode ) ;
                                       INLINE ( ::getFieldName( "navigator", cViewName, cUserCode, "column_order" ) )
   METHOD getColumnOrderSelector( cViewName, cUserCode ) ;
                                       INLINE ( ::getFieldName( "selector", cViewName, cUserCode, "column_order" ) )
   
   METHOD getColumnOrientation( cViewType, cViewName, cUserCode ) ;      
                                       INLINE ( ::getFieldName( cViewType, cViewName, cUserCode, "column_orientation" ) )
   METHOD getColumnOrientationNavigator( cViewName, cUserCode ) ;       
                                       INLINE ( ::getFieldName( "navigator", cViewName, cUserCode, "column_orientation" ) )
   METHOD getColumnOrientationSelector( cViewName, cUserCode ) ;        
                                       INLINE ( ::getFieldName( "selector", cViewName, cUserCode, "column_orientation" ) )

   METHOD getId( cViewType, cViewName, cUserCode ) ;                    
                                       INLINE ( ::getFieldName( cViewType, cViewName, cUserCode, "id_to_find" ) )
   
   METHOD set( cViewType, cViewName, cUserCode, cBrowseState, cColumnOrder, cOrientation, idToFind )
   
   METHOD setId( cViewType, cViewName, cUserCode, nId ) ;               
                                       INLINE ( ::set( cViewType, cViewName, cUserCode, nil, nil, nil, nId ) ) 

   METHOD setNavigator( cViewName, cUserCode, cBrowseState, cColumnOrder, cOrientation, idToFind ) ;
                                       INLINE ( ::set( "navigator", cViewName, cUserCode, cBrowseState, cColumnOrder, cOrientation, idToFind ) )
   
   METHOD setSelector( cViewName, cUserCode, cBrowseState, cColumnOrder, cOrientation, idToFind ) ;
                                       INLINE ( ::set( "selector", cViewName, cUserCode, cBrowseState, cColumnOrder, cOrientation, idToFind ) )
   
   METHOD setColumnOrder( cViewType, cViewName, cUserCode, cColumnOrder ) ;
                                       INLINE ( ::set( cViewType, cViewName, cUserCode, nil, cColumnOrder ) ) 

   METHOD setColumnOrientation( cViewType, cViewName, cUserCode, cColumnOrientation ) ;
                                       INLINE ( ::set( cViewType, cViewName, cUserCode, nil, nil, cColumnOrientation ) ) 

   METHOD delete( cViewType, cViewName, cUserCode )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLConfiguracionVistasModel

   ::hColumns  := {  "id"                 =>  { "create" => "INTEGER AUTO_INCREMENT"      },;
                     "view_type"          =>  { "create" => "VARCHAR ( 40 ) NOT NULL"     },;
                     "view_name"          =>  { "create" => "VARCHAR ( 60 ) NOT NULL"     },;
                     "usuario_codigo"     =>  { "create" => "VARCHAR ( 20 ) NOT NULL"     },;                     
                     "browse_state"       =>  { "create" => "TEXT"                        },;
                     "column_order"       =>  { "create" => "VARCHAR ( 60 )"              },;
                     "column_orientation" =>  { "create" => "CHARACTER ( 1 )"	            },;
                     "id_to_find"         =>  { "create" => "INT"                         } }

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD get( cViewType, cViewName, cUserCode ) CLASS SQLConfiguracionVistasModel

   local aFetch
   local cSentence

   DEFAULT cUserCode := Auth():Codigo()

   cSentence         := "SELECT browse_state, column_order, column_orientation, id_to_find "       + ;
                           "FROM " + ::getTableName() + " "                                        + ;
                           "WHERE "                                                                + ;
                              "view_type = " + quoted( cViewType )   + " AND "                     + ;
                              "view_name = " + quoted( cViewName )   + " AND "                     + ;
                              "usuario_codigo = " + quoted( cUserCode ) + " "                      + ; 
                           "LIMIT 1"

   aFetch            := getSQLDatabase():selectFetchHash( cSentence, .f. )

   if hb_isarray( aFetch ) .and. !empty( aFetch )
      RETURN ( atail( aFetch ) )
   end if 

RETURN ( nil )
       
//---------------------------------------------------------------------------//

METHOD getFieldName( cViewType, cViewName, cUserCode, cFieldName ) CLASS SQLConfiguracionVistasModel

   local aFetch      := ::get( cViewType, cViewName, cUserCode )

   if empty( aFetch )
      RETURN ( nil )
   end if 

RETURN ( hget( aFetch, cFieldName ) )
       
//---------------------------------------------------------------------------//

METHOD getState( cViewType, cViewName, cUserCode ) CLASS SQLConfiguracionVistasModel

   local cState
   local hFetch      := ::get( cViewType, cViewName, cUserCode )

   if empty( hFetch )
      RETURN ( nil )
   end if 
   
   cState            := hget( hFetch, "browse_state" )
   if empty( cState )
      RETURN ( nil )
   end if 

   cState            := strtran( cState, '\"', '"' )

RETURN ( cState )
       
//---------------------------------------------------------------------------//

METHOD set( cViewType, cViewName, cUserCode, cBrowseState, cColumnOrder, cOrientation, idToFind ) CLASS SQLConfiguracionVistasModel

   local cSentence  

   DEFAULT cUserCode    := Auth():Codigo()

   if hb_isnil( cViewType )
      RETURN ( nil )
   end if 

   if hb_isnil( cViewName )
      RETURN ( nil )
   end if 

   if empty( cBrowseState ) .and. empty( cColumnOrder ) .and. empty( cOrientation ) .and. empty( idToFind )
      RETURN ( nil )
   end if 
   
   cSentence            := "INSERT INTO " + ::getTableName() + " ( "                               
   cSentence            +=    "view_type, "                                               
   cSentence            +=    "view_name, "     
   cSentence            +=    "usuario_codigo, "     

   if !empty( cBrowseState )                                          
      cBrowseState      := getSQLDatabase():escapeStr( cBrowseState ) 
      cSentence         +=    "browse_state, "                                            
   end if 

   if !empty( cColumnOrder )
      cSentence         +=    "column_order, "                                          
   end if 
   
   if !empty( cOrientation )
      cSentence         +=    "column_orientation, "                                           
   end if 
   
   if !empty( idToFind )
      cSentence         +=    "id_to_find, "                                               
   end if 

   cSentence            := chgAtEnd( cSentence, ' ) ', 2 )

   cSentence            += "VALUES ( "                                                    
   cSentence            +=    quoted( cViewType ) + ", "                          
   cSentence            +=    quoted( cViewName ) + ", "  
   cSentence            +=    quoted( cUserCode ) + ", "

   if !empty( cBrowseState )                                          
      cSentence         +=    quoted( cBrowseState ) + ", "                               
   end if 

   if !empty( cColumnOrder )
      cSentence         +=    quoted( cColumnOrder ) + ", "                           
   end if 

   if !empty( cOrientation )
      cSentence         +=    quoted( cOrientation ) + ", "                           
   end if 

   if !empty( idToFind )
      cSentence         +=    alltrim( cvaltostr( idToFind ) ) + ", "
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

RETURN ( getSQLDatabase():Query( cSentence ) )

//---------------------------------------------------------------------------//

METHOD delete( cViewType, cViewName, cUserCode ) CLASS SQLConfiguracionVistasModel

   local cSentence

   DEFAULT cUserCode := Auth():Codigo()

   cSentence         := "DELETE FROM " + ::getTableName() + " "                              + ;
                           "WHERE "                                                          + ;
                              "view_type = " + quoted( cViewType ) + " AND "                 + ;
                              "view_name = " + quoted( cViewName ) + " AND "                 + ;
                              "usuario_codigo = " + quoted( cUserCode )

RETURN ( getSQLDatabase():Query( cSentence ) )
       
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

#ifdef __TEST__

CLASS TestConfiguracionVistasController FROM TestCase

   DATA oController

   DATA aCategories                    INIT { "all", "configuracion_vistas" }

   METHOD test_view_super_usuario()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD test_view_super_usuario() CLASS TestConfiguracionVistasController

   SQLConfiguracionVistasModel():set( "view_type", "view_name", "999", "browse_state", "D", "column_orientation", 1 )

   ::Assert():Equals( "D", SQLConfiguracionVistasModel():getColumnOrder( "view_type", "view_name", "999" ), "test get column order" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif