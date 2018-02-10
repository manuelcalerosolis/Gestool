#include "fiveWin.ch"
#include "hdo.ch"

//----------------------------------------------------------------------------//

CLASS SQLMigrations

   DATA aModels                           INIT {}

   METHOD Run()
   
   METHOD createDatabase()

   METHOD addModels()

   METHOD checkModels()   

   METHOD checkModel( oModel )

   METHOD getSchemaColumns( oModel )   

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Run() 

   ::createDatabase()

   ::addModels()

   ::checkModels()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD createDatabase()

   getSQLDatabase():oConexion:exec( "CREATE DATABASE IF NOT EXISTS " + getSQLDatabase():cDatabaseMySQL + ";" )
   getSQLDatabase():oConexion:exec( "USE " + getSQLDatabase():cDatabaseMySQL + ";" )
       
RETURN ( self )    

//----------------------------------------------------------------------------//

METHOD checkModels()

RETURN ( aeval( ::aModels, {|oModel| ::checkModel( oModel ) } ) )

//----------------------------------------------------------------------------//

METHOD checkModel( oModel )

   local aSchemaColumns    := ::getSchemaColumns( oModel )

   if empty( aSchemaColumns )
      getSQLDatabase():Exec( oModel:getCreateTableSentence() )
   else
      getSQLDatabase():Execs( oModel:getAlterTableSentences( aSchemaColumns ) )
   end if 
  
RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD getSchemaColumns( oModel )

   local oError
   local cSentence
   local oStatement
   local aSchemaColumns

   if empty( getSQLDatabase():oConexion )
      msgstop( "No hay conexiones disponibles" )
      RETURN ( nil )  
   end if  

   cSentence               := "SELECT COLUMN_NAME "                              +;
                                 "FROM INFORMATION_SCHEMA.COLUMNS "              +;
                                 "WHERE table_name = " + quoted( oModel:cTableName ) + " " +;
                                    "AND table_schema = " + quoted( getSQLDatabase():cDatabaseMySQL ) 

   try

      oStatement           := getSQLDatabase():oConexion:Query( cSentence )
   
      aSchemaColumns       := oStatement:fetchAll( FETCH_HASH )

   catch oError

      eval( errorBlock(), oError )

   finally

      if !empty( oStatement )
        oStatement:free()
      end if    
   
   end

   if empty( aSchemaColumns ) .or. !hb_isarray( aSchemaColumns )
      RETURN ( nil )
   end if

RETURN ( aSchemaColumns )

//---------------------------------------------------------------------------//

METHOD addModels()

   aadd( ::aModels, SQLTiposImpresorasModel():New() )

   aadd( ::aModels, SQLTiposNotasModel():New() )

   aadd( ::aModels, EtiquetasModel():New() )

   aadd( ::aModels, SituacionesModel():New() )

   aadd( ::aModels, SQLConfiguracionColumnasUsuariosModel():New() )

   aadd( ::aModels, RelacionesEtiquetasModel():New() )
                                      
   aadd( ::aModels, TiposVentasModel():New() )

   aadd( ::aModels, SQLConfiguracionEmpresasModel():New() )

   aadd( ::aModels, SQLConfiguracionesModel():New() )

   aadd( ::aModels, SQLMovimientosAlmacenModel():New() )

   aadd( ::aModels, SQLMovimientosAlmacenLineasModel():New() )

   aadd( ::aModels, SQLMovimientosAlmacenLineasNumerosSeriesModel():New() )

   aadd( ::aModels, SQLFiltrosModel():New() )   

RETURN ( ::aModels )
 
//----------------------------------------------------------------------------//