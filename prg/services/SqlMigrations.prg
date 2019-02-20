#include "fiveWin.ch"
#include "hdo.ch"

//----------------------------------------------------------------------------//

CLASS SQLBaseMigrations

   DATA aModels                           INIT {}

   DATA aRepositories                     INIT {}

   METHOD messageRun()                    

   METHOD Run()                           VIRTUAL 

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

METHOD messageRun() CLASS SQLBaseMigrations

RETURN ( msgRun( "Actualizando estructuras de datos", "Espere por favor...", {|| ::Run() } ) )

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
  
RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD checkRepositories() CLASS SQLBaseMigrations

RETURN ( aeval( ::aRepositories, {|oRepository| ::checkRepository( oRepository ) } ) )

//----------------------------------------------------------------------------//

METHOD checkRepository( oRepository ) CLASS SQLBaseMigrations

RETURN ( getSQLDatabase():ExecsWithOutParse( oRepository:getSQLFunctions() ) )

//----------------------------------------------------------------------------//

METHOD getSchemaColumns( cDatabaseMySQL, cTableName ) CLASS SQLBaseMigrations

   local oError
   local cSentence
   local aSchemaColumns

   if empty( cDatabaseMySQL )
      msgstop( "No se especifico la base de datos" )
      RETURN ( nil )  
   end if  
   
   if empty( cTableName )
      msgstop( "No se especifico la tabla" )
      RETURN ( nil )  
   end if  

   cSentence            := "SELECT COLUMN_NAME "                                       + ;
                              "FROM INFORMATION_SCHEMA.COLUMNS "                       + ;
                              "WHERE table_schema = " + quoted( cDatabaseMySQL ) + " " + ; 
                                 "AND table_name = " + quoted( cTableName )
                                  
   try

      aSchemaColumns    := getSQLDatabase():selectFetchHash( cSentence )

   catch oError

      eval( errorBlock(), oError )

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

   METHOD Run( cDatabaseMySQL )

   METHOD addModels()  

   METHOD checkValues()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Run( cDatabaseMySQL ) CLASS SQLGestoolMigrations

   DEFAULT cDatabaseMySQL  := 'gestool'

   ::createDatabase( cDatabaseMySQL )

   ::addModels()

   ::checkModels( cDatabaseMySQL )

   ::checkValues()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD addModels() CLASS SQLGestoolMigrations

   aadd( ::aModels, SQLEmpresasModel():New() )

   aadd( ::aModels, SQLDelegacionesModel():New() )

   aadd( ::aModels, SQLUsuariosModel():New() )

   aadd( ::aModels, SQLRolesModel():New() )

   aadd( ::aModels, SQLPermisosModel():New() )

   aadd( ::aModels, SQLPermisosOpcionesModel():New() )

   aadd( ::aModels, SQLConfiguracionVistasGestoolModel():New() )

   aadd( ::aModels, SQLCamposExtraGestoolModel():New() )

   aadd( ::aModels, SQLCamposExtraEntidadesGestoolModel():New() )
   
   aadd( ::aModels, SQLCamposExtraValoresGestoolModel():New() )

   aadd( ::aModels, SQLConfiguracionEmpresasModel():New() )

   // Modelos duplicados-------------------------------------------------------
   
   aadd( ::aModels, SQLDireccionesGestoolModel():New() )

   aadd( ::aModels, SQLCodigosPostalesGestoolModel():New() )

   aadd( ::aModels, SQLProvinciasGestoolModel():New() )

   aadd( ::aModels, SQLPaisesGestoolModel():New() )

   aadd( ::aModels, SQLAjustesGestoolModel():New() )

   aadd( ::aModels, SQLAjustableGestoolModel():New() )

   aadd( ::aModels, SQLCuentasBancariasGestoolModel():New() )

RETURN ( ::aModels )
 
//----------------------------------------------------------------------------//

METHOD checkValues() CLASS SQLGestoolMigrations

   getSQLDatabase():Query( SQLAjustesGestoolModel():getInsertAjustesSentence() )

   getSQLDatabase():Query( SQLRolesModel():getInsertRolesSentence() )

   getSQLDatabase():Query( SQLUsuariosModel():getInsertUsuariosSentence() ) 

RETURN ( nil )

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

   aadd( ::aModels, SQLAjustesModel():New() )

   aadd( ::aModels, SQLFiltrosModel():New() )

   aadd( ::aModels, SQLAjustableModel():New() )

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

   aadd( ::aModels, SQLPagosModel():New() )

   aadd( ::aModels, SQLRecibosPagosModel():New() )

   aadd( ::aModels, SQLBalanzasModel():New() )

   aadd( ::aModels, SQLImpresorasModel():New() )

   aadd( ::aModels, SQLCajasModel():New() )

   aadd( ::aModels, SQLEntradaSalidaModel():New() )

   aadd( ::aModels, SQLArticulosEnvasadoModel():New() )

   aadd( ::aModels, SQLOrdenComandasModel():New() )

   aadd( ::aModels, SQLTercerosEntidadesModel():New() )

   aadd( ::aModels, SQLEntidadesModel():New() )

   aadd( ::aModels, SQLDocumentosModel():New() )

   aadd( ::aModels, SQLIncidenciasModel():New() )

   aadd( ::aModels, SQLArticulosTarifasModel():New() )

   aadd( ::aModels, SQLArticulosPreciosModel():New() )

   aadd( ::aModels, SQLCaracteristicasModel():New() )

   aadd( ::aModels, SQLCaracteristicasLineasModel():New() ) 

   aadd( ::aModels, SQLCaracteristicasValoresArticulosModel():New() ) 

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

   aadd( ::aModels, SQLMediosPagoModel():New() )

   aadd( ::aModels, SQLMetodoPagoModel():New() )

   aadd( ::aModels, SQLTiposIvaModel():New() )
   
   aadd( ::aModels, SQLCuentasRemesaModel():New() )

   aadd( ::aModels, SQLCuentasBancariasModel():New() )

   aadd( ::aModels, SQLRutasModel():New() )

   aadd( ::aModels, SQLTercerosGruposModel():New() )

   aadd( ::aModels, SQLArticulosTemporadasModel():New() )

   aadd( ::aModels, SQLArticulosCategoriasModel():New() )

   aadd( ::aModels, SQLAlmacenesModel():New() )

   aadd( ::aModels, SQLUbicacionesModel():New() )

   aadd( ::aModels, SQLTageableModel():New() )
                                      
   aadd( ::aModels, SQLConfiguracionVistasModel():New() )

   aadd( ::aModels, SQLConfiguracionesModel():New() ) 

   //aadd( ::aModels, SQLMovimientosAlmacenLineasModel():New() )

   //aadd( ::aModels, SQLMovimientosAlmacenLineasNumerosSeriesModel():New() )

   //aadd( ::aModels, SQLFiltrosCompanyModel():New() )
   
   aadd( ::aModels, SQLUsuarioFavoritosModel():New() )

   aadd( ::aModels, SQLRelacionesEntidadesModel():New() )

   aadd( ::aModels, SQLTercerosModel():New() )

   aadd( ::aModels, SQLArticulosModel():New() )

   aadd( ::aModels, SQLPropiedadesModel():New() )

   aadd( ::aModels, SQLPropiedadesLineasModel():New() )

   aadd( ::aModels, SQLTraduccionesModel():New() ) 

   aadd( ::aModels, SQLDescuentosModel():New() )
    
   aadd( ::aModels, SQLArticulosPreciosDescuentosModel():New() )  

   aadd( ::aModels, SQLFacturasVentasModel():New() )

   aadd( ::aModels, SQLAlbaranesVentasModel():New() )

   aadd( ::aModels, SQLConvertirAlbaranVentasTemporalModel():New() )

   aadd( ::aModels, SQLPedidosVentasModel():New() )

   aadd( ::aModels, SQLPresupuestosVentasModel():New() )

   aadd( ::aModels, SQLFacturasVentasRectificativasModel():New() ) 

   aadd( ::aModels, SQLFacturasComprasModel():New() )

   aadd( ::aModels, SQLPedidosComprasModel():New() ) 

   aadd( ::aModels, SQLPresupuestosComprasModel():New() )   

   aadd( ::aModels, SQLPresupuestosComprasDescuentosModel():New() ) 

   aadd( ::aModels, SQLPresupuestosComprasLineasModel():New() )  

   aadd( ::aModels, SQLFacturasComprasLineasModel():New() ) 

   aadd( ::aModels, SQLFacturasVentasRectificativasLineasModel():New() ) 
   
   aadd( ::aModels, SQLFacturasVentasRectificativasDescuentosModel():New() ) 

   aadd( ::aModels, SQLConsolidacionesAlmacenesModel():New() )

   aadd( ::aModels, SQLConsolidacionesAlmacenesLineasModel():New() ) 

   aadd( ::aModels, SQLMovimientosAlmacenesLineasModel():New() ) 

   aadd( ::aModels, SQLMovimientosAlmacenesModel():New() )

   aadd( ::aModels, SQLFacturasComprasLineasModel():New() ) 

   aadd( ::aModels, SQLFacturasVentasLineasModel():New() )

   aadd( ::aModels, SQLAlbaranesVentasLineasModel():New() )

   aadd( ::aModels, SQLPedidosComprasLineasModel():New() )

   aadd( ::aModels, SQLPedidosComprasDescuentosModel():New() )

   aadd( ::aModels, SQLPedidosVentasLineasModel():New() ) 

   aadd( ::aModels, SQLPedidosVentasDescuentosModel():New() ) 

   aadd( ::aModels, SQLPresupuestosVentasLineasModel():New() ) 

   aadd( ::aModels, SQLFacturasComprasRectificativasModel():New() ) 

   aadd( ::aModels, SQLFacturasComprasRectificativasLineasModel():New() ) 

   aadd( ::aModels, SQLFacturasVentasDescuentosModel():New() ) 

   aadd( ::aModels, SQLFacturasVentasSimplificadasModel():New() ) 

   aadd( ::aModels, SQLFacturasVentasSimplificadasLineasModel():New() ) 

   aadd( ::aModels, SQLFacturasVentasSimplificadasDescuentosModel():New() ) 

   aadd( ::aModels, SQLPresupuestosVentasDescuentosModel():New() ) 

   aadd( ::aModels, SQLFacturasComprasDescuentosModel():New() ) 

   aadd( ::aModels, SQLAlbaranesVentasDescuentosModel():New() ) 
   
   aadd( ::aModels, SQLFacturasComprasRectificativasDescuentosModel():New() )
   
   aadd( ::aModels, SQLConversorDocumentosModel():New() )

   aadd( ::aModels, SQLAlbaranesVentasConversorModel():New() )

   aadd( ::aModels, SQLAlbaranesComprasLineasModel():New() ) 
   
   aadd( ::aModels, SQLAlbaranesComprasDescuentosModel():New() ) 

   aadd( ::aModels, SQLAlbaranesComprasModel():New() ) 

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

   getSQLDatabase():Query( SQLAjustesModel():getInsertAjustesSentence() )

   getSQLDatabase():Query( SQLCajasModel():getInsertCajasSentence() )

   getSQLDatabase():Query( SQLAlmacenesModel():getInsertAlmacenSentence() )

   getSQLDatabase():Query( SQLUnidadesMedicionModel():getInsertUnidadesMedicionSentence() )

   getSQLDatabase():Querys( SQLUnidadesMedicionGruposModel():getInsertUnidadesMedicionGruposSentence() )

   SQLArticulosTarifasModel():insertTarifaBase()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addRepositories() CLASS SQLCompanyMigrations

   aadd( ::aRepositories, ArticulosPreciosRepository():New() )

   aadd( ::aRepositories, RecibosRepository():New() )

   aadd( ::aRepositories, RecibosPagosRepository():New() )
   
   aadd( ::aRepositories, FacturasVentasRepository():New() )

   aadd( ::aRepositories, FacturasVentasSimplificadasRepository():New() )

   aadd( ::aRepositories, PresupuestosVentasRepository():New() )

   aadd( ::aRepositories, PedidosVentasRepository():New() )

   aadd( ::aRepositories, AlbaranesVentasRepository():New() )

   aadd( ::aRepositories, FacturasVentasRectificativasRepository():New() )

   aadd( ::aRepositories, FacturasComprasRepository():New() )

   aadd( ::aRepositories, PedidosComprasRepository():New() )

   aadd( ::aRepositories, PresupuestosComprasRepository():New() )

   aadd( ::aRepositories, FacturasComprasRectificativasRepository():New() )
   
   aadd( ::aRepositories, ConsolidacionesAlmacenesRepository():New() )

   aadd( ::aRepositories, MovimientosAlmacenesRepository():New() )

   aadd( ::aRepositories, AlbaranesComprasRepository():New() )

   aadd( ::aRepositories, StocksRepository():New() )

   aadd( ::aRepositories, ConversorDocumentosRepository():New() )

RETURN ( nil )

//----------------------------------------------------------------------------//


