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

   METHOD checkValues()

   METHOD getSchemaColumns( oModel )   

   METHOD syncronizeModels()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Run() 

   ::createDatabase()

   ::addModels()

   ::checkModels()

   ::syncronizeModels()

   ::checkValues()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD createDatabase()

   getSQLDatabase():oConexion:Exec( "CREATE DATABASE IF NOT EXISTS " + getSQLDatabase():cDatabaseMySQL + ";" )
   getSQLDatabase():oConexion:Exec( "USE " + getSQLDatabase():cDatabaseMySQL + ";" )
       
RETURN ( self )    

//----------------------------------------------------------------------------//

METHOD syncronizeModels()

   SQLMovimientosAlmacenModel():Syncronize()   

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

METHOD checkValues()

   getSQLDatabase():Exec( SQLRolesModel():getInsertRolesSentence() )

   getSQLDatabase():Exec( SQLUsuariosModel():getInsertUsuariosSentence() ) 

   getSQLDatabase():Exec( SQLAjustesModel():getInsertAjustesSentence() )

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

   aadd( ::aModels, SQLEmpresasModel():New() )

   aadd( ::aModels, SQLTiposImpresorasModel():New() )

   aadd( ::aModels, SQLTagsModel():New() )

   aadd( ::aModels, SQLUsuariosModel():New() )

   aadd( ::aModels, SQLRolesModel():New() )

   aadd( ::aModels, SQLPermisosModel():New() )

   aadd( ::aModels, SQLPermisosOpcionesModel():New() )

   aadd( ::aModels, SQLAjustesModel():New() )

   aadd( ::aModels, SQLAjustableModel():New() )

   aadd( ::aModels, SQLSituacionesModel():New() )

   aadd( ::aModels, SQLCajonesPortamonedasModel():New() )

   aadd( ::aModels, SQLTransportistasModel():New() )

   aadd( ::aModels, SQLAgentesModel():New() )

   aadd( ::aModels, SQLFabricantesModel():New() )

   aadd( ::aModels, SQLImagenesModel():New() )

   aadd( ::aModels, SQLCamposExtraModel():New() )

   aadd( ::aModels, SQLCamposExtraEntidadesModel():New() )
   
   aadd( ::aModels, SQLCamposExtraValoresModel():New() )

   aadd( ::aModels, SQLListinModel():New() )

   aadd( ::aModels, SQLCodigosPostalesModel():New() )

   aadd( ::aModels, SQLProvinciasModel():New() )

   aadd( ::aModels, SQLPaisesModel():New() )

   aadd( ::aModels, SQLLenguajesModel():New() )

   aadd( ::aModels, SQLDireccionesModel():New() )

   aadd( ::aModels, SQLComentariosModel():New() )

   aadd( ::aModels, SQLComentariosLineasModel():New() )

   aadd( ::aModels, SQLArticulosTipoModel():New() )

   aadd( ::aModels, SQLIvaTipoModel():New() )
   
   aadd( ::aModels, SQLCuentasRemesaModel():New() )

   aadd( ::aModels, SQLBancosModel():New() )

   aadd( ::aModels, SQLRutasModel():New() )

   aadd( ::aModels, SQLClientesGruposModel():New() )

   aadd( ::aModels, SQLArticulosTemporadaModel():New() )

   aadd( ::aModels, SQLArticulosCategoriasModel():New() )

   aadd( ::aModels, SQLAlmacenesModel():New() )

   aadd( ::aModels, SQLConfiguracionVistasModel():New() )

   aadd( ::aModels, SQLTageableModel():New() )
                                      
   aadd( ::aModels, SQLTiposVentasModel():New() )

   aadd( ::aModels, SQLConfiguracionEmpresasModel():New() )

   aadd( ::aModels, SQLConfiguracionesModel():New() )

   aadd( ::aModels, SQLMovimientosAlmacenModel():New() )

   aadd( ::aModels, SQLMovimientosAlmacenLineasModel():New() )

   aadd( ::aModels, SQLMovimientosAlmacenLineasNumerosSeriesModel():New() )

   aadd( ::aModels, SQLFiltrosModel():New() )
   
   aadd( ::aModels, SQLUsuarioFavoritosModel():New() )

   aadd( ::aModels, SQLRelacionesEntidadesModel():New() )

   aadd( ::aModels, SQLClientesModel():New() )

   aadd( ::aModels, SQLProveedoresModel():New() )

RETURN ( ::aModels )
 
//----------------------------------------------------------------------------//