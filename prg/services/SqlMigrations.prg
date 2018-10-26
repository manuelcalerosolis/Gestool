#include "fiveWin.ch"
#include "hdo.ch"

//----------------------------------------------------------------------------//

CLASS SQLBaseMigrations

   DATA aModels                           INIT {}

   DATA aRepositories                     INIT {}

   METHOD Run( cDatabaseMySQL ) 

   METHOD createDatabase()

   METHOD addModels()                     VIRTUAL

   METHOD checkValues()                   VIRTUAL

   METHOD checkModels()                   

   METHOD checkModel( oModel ) 

   METHOD checkRepositories()      

   METHOD checkRepository( oRepository ) 

   METHOD getSchemaColumns( cDatabaseMySQL, cTableName )    

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Run( cDatabaseMySQL ) CLASS SQLBaseMigrations

   DEFAULT cDatabaseMySQL  := 'Gestool'

   ::createDatabase( cDatabaseMySQL )

   ::addModels()

   ::checkModels( cDatabaseMySQL )

   ::checkValues()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD createDatabase( cDatabaseMySQL ) CLASS SQLBaseMigrations

   if empty( cDatabaseMySQL )
      RETURN ( self )
   end if 

   getSQLDatabase():ExecWithOutParse( "CREATE DATABASE IF NOT EXISTS " + cDatabaseMySQL + ";" )
   
RETURN ( self )    

//----------------------------------------------------------------------------//

METHOD checkModels( cDatabaseMySQL ) CLASS SQLBaseMigrations

RETURN ( aeval( ::aModels, {|oModel| ::checkModel( cDatabaseMySQL, oModel ) } ) )

//----------------------------------------------------------------------------//

METHOD checkModel( cDatabaseMySQL, oModel ) CLASS SQLBaseMigrations

   local aSchemaColumns    := ::getSchemaColumns( cDatabaseMySQL, oModel:cTableName )

   if empty( aSchemaColumns )
      getSQLDatabase():Exec( oModel:getCreateTableSentence( cDatabaseMySQL ) )
   else
      getSQLDatabase():Execs( oModel:getAlterTableSentences( cDatabaseMySQL, aSchemaColumns ) )
   end if 
  
RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD checkRepositories() CLASS SQLBaseMigrations

RETURN ( aeval( ::aRepositories, {|oRepository| ::checkRepository( oRepository ) } ) )

//----------------------------------------------------------------------------//

METHOD checkRepository( oRepository ) CLASS SQLBaseMigrations

   getSQLDatabase():ExecsWithOutParse( oRepository:getSQLFunctions() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD getSchemaColumns( cDatabaseMySQL, cTableName ) CLASS SQLBaseMigrations

   local oError
   local cSentence
   local oStatement
   local aSchemaColumns

   if empty( cDatabaseMySQL )
      msgstop( "No se especifico la base de datos" )
      RETURN ( nil )  
   end if  
   
   if empty( cTableName )
      msgstop( "No se especifico la tabla" )
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

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

CLASS SQLGestoolMigrations FROM SQLBaseMigrations

   METHOD addModels()  

   METHOD checkValues()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addModels() CLASS SQLGestoolMigrations

   aadd( ::aModels, SQLEmpresasModel():New() )

   aadd( ::aModels, SQLDireccionesGestoolModel():New() )

   aadd( ::aModels, SQLCodigosPostalesGestoolModel():New() )

   aadd( ::aModels, SQLProvinciasGestoolModel():New() )

   aadd( ::aModels, SQLPaisesGestoolModel():New() )

   aadd( ::aModels, SQLDelegacionesModel():New() )

   aadd( ::aModels, SQLUsuariosModel():New() )

   aadd( ::aModels, SQLRolesModel():New() )

   aadd( ::aModels, SQLPermisosModel():New() )

   aadd( ::aModels, SQLPermisosOpcionesModel():New() )

   aadd( ::aModels, SQLAjustesModel():New() )

   aadd( ::aModels, SQLAjustableModel():New() )

   aadd( ::aModels, SQLConfiguracionVistasGestoolModel():New() )

   aadd( ::aModels, SQLCamposExtraGestoolModel():New() )

   aadd( ::aModels, SQLCamposExtraEntidadesGestoolModel():New() )
   
   aadd( ::aModels, SQLCamposExtraValoresGestoolModel():New() )

   aadd( ::aModels, SQLFiltrosModel():New() ) 

   aadd( ::aModels, SQLConfiguracionEmpresasModel():New() )

RETURN ( ::aModels )
 
//----------------------------------------------------------------------------//

METHOD checkValues() CLASS SQLGestoolMigrations

   getSQLDatabase():Exec( SQLRolesModel():getInsertRolesSentence() )

   getSQLDatabase():Exec( SQLUsuariosModel():getInsertUsuariosSentence() ) 

RETURN ( Self )

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

CLASS SQLCompanyMigrations FROM SQLBaseMigrations

   METHOD Run( cCodigoEmpresa )

   METHOD addModels()

   METHOD addRepositories()

   METHOD checkValues()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Run( cCodigoEmpresa ) CLASS SQLCompanyMigrations

   Company():guardWhereCodigo( cCodigoEmpresa )

   ::createDatabase( Company():getDatabase() )

   ::addModels()

   ::checkModels( Company():getDatabase() )

   ::checkValues()

   ::addRepositories()

   ::checkRepositories()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD addModels() CLASS SQLCompanyMigrations

   aadd( ::aModels, SQLTiposImpresorasModel():New() )

   //aadd( ::aModels, SQLDireccionTiposModel():New() )

   aadd( ::aModels, SQLDireccionTipoDocumentoModel():New() )

   aadd( ::aModels, SQLTagsModel():New() )

   aadd( ::aModels, SQLContadoresModel():New() )

   aadd( ::aModels, SQLSituacionesModel():New() )

   aadd( ::aModels, SQLCajonesPortamonedasModel():New() )

   aadd( ::aModels, SQLTransportistasModel():New() )

   aadd( ::aModels, SQLAgentesModel():New() )

   aadd( ::aModels, SQLArticulosFabricantesModel():New() )

   aadd( ::aModels, SQLImagenesModel():New() )

   aadd( ::aModels, SQLListinModel():New() )

   aadd( ::aModels, SQLDireccionesModel():New() )

   aadd( ::aModels, SQLDireccionesTiposModel():New() )

   aadd( ::aModels, SQLCodigosPostalesModel():New() )

   aadd( ::aModels, SQLProvinciasModel():New() )

   aadd( ::aModels, SQLPaisesModel():New() )

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

   aadd( ::aModels, SQLUnidadesMedicionGruposLineasModel():New() )

   aadd( ::aModels, SQLArticulosUnidadesMedicionModel():New() )

   aadd( ::aModels, SQLUnidadesMedicionOperacionesModel():New() )

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

   aadd( ::aModels, SQLTageableModel():New() )
                                      
   aadd( ::aModels, SQLConfiguracionVistasModel():New() )

   aadd( ::aModels, SQLConfiguracionesModel():New() ) 

   //aadd( ::aModels, SQLMovimientosAlmacenModel():New() )

   //aadd( ::aModels, SQLMovimientosAlmacenLineasModel():New() )

   //aadd( ::aModels, SQLMovimientosAlmacenLineasNumerosSeriesModel():New() )

   //aadd( ::aModels, SQLFiltrosCompanyModel():New() )
   
   aadd( ::aModels, SQLUsuarioFavoritosModel():New() )

   aadd( ::aModels, SQLRelacionesEntidadesModel():New() )

   aadd( ::aModels, SQLClientesModel():New() )

   aadd( ::aModels, SQLArticulosModel():New() )

   aadd( ::aModels, SQLPropiedadesModel():New() )

   aadd( ::aModels, SQLPropiedadesLineasModel():New() )

   aadd( ::aModels, SQLProveedoresModel():New() ) 

   aadd( ::aModels, SQLTraduccionesModel():New() ) 

   aadd( ::aModels, SQLDescuentosModel():New() )
    
   aadd( ::aModels, SQLArticulosPreciosDescuentosModel():New() ) 

   aadd( ::aModels, SQLFacturasClientesModel():New() ) 

   aadd( ::aModels, SQLFacturasClientesLineasModel():New() ) 

   aadd( ::aModels, SQLFacturasClientesDescuentosModel():New() ) 

   aadd( ::aModels, SQLCamposExtraModel():New() )

   aadd( ::aModels, SQLCamposExtraEntidadesModel():New() )
   
   aadd( ::aModels, SQLCamposExtraValoresModel():New() )

   aadd( ::aModels, SQLLenguajesModel():New() )

   aadd( ::aModels, SQLCombinacionesModel():New() )

   aadd( ::aModels, SQLCombinacionesPropiedadesModel():New() )

   aadd( ::aModels, SQLClientesTarifasModel():New() )

RETURN ( ::aModels )
 
//----------------------------------------------------------------------------//

METHOD checkValues() CLASS SQLCompanyMigrations

   getSQLDatabase():Exec( SQLAjustesModel():getInsertAjustesSentence() )

   getSQLDatabase():Exec( SQLCajasModel():getInsertCajasSentence() )

   getSQLDatabase():Exec( SQLUnidadesMedicionModel():getInsertUnidadesMedicionSentence() )

   getSQLDatabase():Exec( SQLAlmacenesModel():getInsertAlmacenSentence() )

   getSQLDatabase():Execs( SQLUnidadesMedicionGruposModel():getInsertUnidadesMedicionGruposSentence() )

   getSQLDatabase():Exec( SQLArticulosTarifasModel():getInsertArticulosTarifasSentence() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD addRepositories() CLASS SQLCompanyMigrations

   aadd( ::aRepositories, ArticulosPreciosRepository():New() )

   aadd( ::aRepositories, FacturasClientesRepository():New() )

RETURN ( Self )

//----------------------------------------------------------------------------//


