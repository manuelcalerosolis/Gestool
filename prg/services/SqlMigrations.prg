#include "fiveWin.ch"
#include "hdo.ch"

//----------------------------------------------------------------------------//

CLASS SQLMigrations

   DATA hJson                             INIT {=>}

   DATA aModels                           INIT {}

   DATA aRepositories                     INIT {}

   METHOD Run()

   METHOD checkDatabase()
   
   METHOD createDatabase()

   METHOD readGestoolDatabaseJSON()

   METHOD addModels()

   METHOD checkModels()   

   METHOD checkModel( oModel )

   METHOD addRepositories()

   METHOD checkRepositories()

   METHOD checkRepository( oRepository )

   METHOD checkValues()

   METHOD getSchemaColumns( cDatabaseMySQL, cTableName )    

ENDCLASS

//----------------------------------------------------------------------------//

METHOD checkDatabase()

   getSQLDatabase():ConnectWithoutDataBase()

   if !::readGestoolDatabaseJSON()
      RETURN ( self )
   end if 

   if hhaskey( ::hJson, "Databases" )
      aeval( hget( ::hJson, "Databases" ),;
         {|hDatabase| ::Run( hget( hDatabase, "Database" ) ) } )
   end if 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Run( cDatabaseMySQL ) 

   ::createDatabase( cDatabaseMySQL )

   ::addModels()

   ::checkModels( cDatabaseMySQL )

   // ::addRepositories()

   // ::checkRepositories()

   ::checkValues()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD createDatabase( cDatabaseMySQL )

   DEFAULT cDatabaseMySQL  := getSQLDatabase():cDatabaseMySQL

   getSQLDatabase():ExecWithOutParse( "CREATE DATABASE IF NOT EXISTS " + cDatabaseMySQL + ";" )
   
   getSQLDatabase():ExecWithOutParse( "USE " + cDatabaseMySQL + ";" )
       
RETURN ( self )    

//----------------------------------------------------------------------------//

METHOD checkModels( cDatabaseMySQL )

RETURN ( aeval( ::aModels, {|oModel| ::checkModel( cDatabaseMySQL, oModel ) } ) )

//----------------------------------------------------------------------------//

METHOD checkModel( cDatabaseMySQL, oModel )

   local aSchemaColumns    := ::getSchemaColumns( cDatabaseMySQL, oModel:cTableName )

   if empty( aSchemaColumns )
      getSQLDatabase():Exec( oModel:getCreateTableSentence( cDatabaseMySQL ) )
   else
      getSQLDatabase():Execs( oModel:getAlterTableSentences( cDatabaseMySQL, aSchemaColumns ) )
   end if 
  
RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD checkRepositories()

RETURN ( aeval( ::aRepositories, {|oRepository| ::checkRepository( oRepository ) } ) )

//----------------------------------------------------------------------------//

METHOD checkRepository( oRepository )

   getSQLDatabase():Execs( oRepository:getSQLFunctions() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD checkValues()

   getSQLDatabase():Exec( SQLUnidadesMedicionModel():getInsertUnidadesMedicionSentence() )

   getSQLDatabase():Exec( SQLRolesModel():getInsertRolesSentence() )

   getSQLDatabase():Exec( SQLUsuariosModel():getInsertUsuariosSentence() ) 

   getSQLDatabase():Exec( SQLAjustesModel():getInsertAjustesSentence() )

   getSQLDatabase():Exec( SQLArticulosTarifasModel():getInsertArticulosTarifasSentence() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD getSchemaColumns( cDatabaseMySQL, cTableName )

   local oError
   local cSentence
   local oStatement
   local aSchemaColumns

   DEFAULT cDatabaseMySQL  := getSQLDatabase():cDatabaseMySQL

   if empty( cTableName )
      RETURN ( nil )  
   end if  

   if empty( getSQLDatabase():oConexion )
      msgstop( "No hay conexiones disponibles" )
      RETURN ( nil )  
   end if  

   cSentence               := "SELECT COLUMN_NAME "                                       + ;
                                 "FROM INFORMATION_SCHEMA.COLUMNS "                       + ;
                                 "WHERE table_schema = " + quoted( cDatabaseMySQL ) + " " + ; 
                                    "AND table_name = " + quoted( cTableName )
                                  
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

   // aadd( ::aModels, SQLEmpresasModel():New() )

   // aadd( ::aModels, SQLUsuariosModel():New() )

   // aadd( ::aModels, SQLRolesModel():New() )

   // aadd( ::aModels, SQLPermisosModel():New() )

   // aadd( ::aModels, SQLPermisosOpcionesModel():New() )

   aadd( ::aModels, SQLTiposImpresorasModel():New() )

   aadd( ::aModels, SQLTagsModel():New() )

   aadd( ::aModels, SQLAjustesModel():New() )

   aadd( ::aModels, SQLAjustableModel():New() )

   aadd( ::aModels, SQLContadoresModel():New() )

   aadd( ::aModels, SQLSituacionesModel():New() )

   aadd( ::aModels, SQLCajonesPortamonedasModel():New() )

   aadd( ::aModels, SQLTransportistasModel():New() )

   aadd( ::aModels, SQLAgentesModel():New() )

   aadd( ::aModels, SQLArticulosFabricantesModel():New() )

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

   aadd( ::aModels, SQLSesionesModel():New() )

   aadd( ::aModels, SQLRecibosModel():New() )

   aadd( ::aModels, SQLBalanzasModel():New() )

   aadd( ::aModels, SQLImpresorasModel():New() )

   aadd( ::aModels, SQLCajasModel():New() )

    aadd( ::aModels, SQLEntradaSalidaModel():New() )

   aadd( ::aModels, SQLArticulosEnvasadoModel():New() )

   aadd( ::aModels, SQLOrdenComandasModel():New() )

   aadd( ::aModels, SQLClientesEntidadesModel():New() )

   aadd( ::aModels, SQLEntidadesModel():New() )

   aadd( ::aModels, SQLDocumentosModel():New() )

   aadd( ::aModels, SQLIncidenciasModel():New() )

   aadd( ::aModels, SQLArticulosTarifasModel():New() )

   aadd( ::aModels, SQLArticulosPreciosModel():New() )

   aadd( ::aModels, SQLContactosModel():New() )

   aadd( ::aModels, SQLArticulosFamiliaModel():New() )

   aadd( ::aModels, SQLUnidadesMedicionModel():New() )

   aadd( ::aModels, SQLUnidadesMedicionGruposModel():New() )

   aadd( ::aModels, SQLArticulosUnidadesMedicionModel():New() )

   aadd( ::aModels, SQLDivisasMonetariasModel():New() )

   aadd( ::aModels, SQLImpuestosEspecialesModel():New() )

   aadd( ::aModels, SQLFormaPagoModel():New() )

   aadd( ::aModels, SQLTiposIvaModel():New() )
   
   aadd( ::aModels, SQLCuentasRemesaModel():New() )

   aadd( ::aModels, SQLCuentasBancariasModel():New() )

   aadd( ::aModels, SQLRutasModel():New() )

   aadd( ::aModels, SQLClientesGruposModel():New() )

   aadd( ::aModels, SQLArticulosTemporadasModel():New() )

   aadd( ::aModels, SQLArticulosCategoriasModel():New() )

   aadd( ::aModels, SQLAlmacenesModel():New() )

   aadd( ::aModels, SQLDelegacionesModel():New() )

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

   aadd( ::aModels, SQLArticulosModel():New() )

   aadd( ::aModels, SQLPropiedadesModel():New() )

   aadd( ::aModels, SQLPropiedadesLineasModel():New() )

   aadd( ::aModels, SQLProveedoresModel():New() ) 

   aadd( ::aModels, SQLTraduccionesModel():New() ) 

   aadd( ::aModels, SQLDescuentosModel():New() ) 

   aadd( ::aModels, SQLFacturasClientesModel():New() ) 

RETURN ( ::aModels )
 
//----------------------------------------------------------------------------//

METHOD addRepositories()

   aadd( ::aRepositories, ArticulosPreciosRepository():New() )

RETURN ( ::aRepositories )
 
//----------------------------------------------------------------------------//

METHOD readGestoolDatabaseJSON()

   local hJson
   local cGestoolDatabase     := "GestoolDatabase.json"

   hb_jsonDecode( memoread( cGestoolDatabase ), @hJson )      

   if empty( hJson )
      RETURN ( .f. )
   end if 

   ::hJson                    := hJson

RETURN ( .t. )

//----------------------------------------------------------------//
