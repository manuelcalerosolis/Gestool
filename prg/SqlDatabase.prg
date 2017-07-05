#include "fiveWin.ch"
#include "hdo.ch"

//----------------------------------------------------------------------------//

static oSqlDatabase

//----------------------------------------------------------------------------//

CLASS SQLDatabase

   DATA oConexion

   DATA cDatabaseSQLite    

   DATA cPathDatabaseSQLite    

   DATA aModels                     INIT {}

   METHOD New()                     CONSTRUCTOR

   METHOD Conexion()                INLINE ( ::oConexion )

   METHOD Connect() 
   METHOD Disconnect()              INLINE ( ::oConexion:disconnect() )
        
   METHOD Exec( cSql )             
   METHOD Query( cSql )             INLINE ( ::oConexion:Query( cSql ) )
   METHOD Prepare( cSql )           INLINE ( ::oConexion:Prepare( cSql ) )

   METHOD LastInsertId()            INLINE ( ::oConexion:lastInsertId() )

   METHOD beginTransaction()        INLINE ( ::oConexion:beginTransaction() )
   METHOD commit()                  INLINE ( ::oConexion:commit() )
   METHOD rollback()                INLINE ( ::oConexion:rollback() )

   METHOD startForeignKey()         INLINE ( ::Query( "pragma foreign_keys = ON" ) )
   METHOD endForeignKey()           INLINE ( ::Query( "pragma foreign_keys = OFF" ) )

   METHOD errorInfo()               INLINE ( ::oConexion:errorInfo() )

   METHOD checkModelsExistence()   

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() 

   aadd( ::aModels, TiposImpresorasModel():New():getSQLCreateTable() )

   aadd( ::aModels, TiposNotasModel():New():getSQLCreateTable() )

   aadd( ::aModels, EtiquetasModel():New():getSQLCreateTable() )

   aadd( ::aModels, SituacionesModel():New():getSQLCreateTable() )

   aadd( ::aModels, HistoricosUsuariosModel():New():getSQLCreateTable() )

   aadd( ::aModels, RelacionesEtiquetasModel():New():getSQLCreateTable() )
                                      
   aadd( ::aModels, TiposVentasModel():New():getSQLCreateTable() )

   aadd( ::aModels, ConfiguracionEmpresasModel():New():getSQLCreateTable() )

   aadd( ::aModels, PropiedadesModel():New():getSQLCreateTable() )

   aadd( ::aModels, PropiedadesLineasModel():New():getSQLCreateTable() )

   aadd( ::aModels, MovimientosAlmacenModel():New():getSQLCreateTable() )

   ::cPathDatabaseSQLite      := fullCurDir() + "Database\" 

   ::cDatabaseSQLite          := ::cPathDatabaseSQLite + "Gestool.db"

   ::oConexion                := THDO():new( "sqlite" )
   
   ::oConexion:setAttribute( ATTR_ERRMODE, .t. )

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Connect()

   if !lIsDir( ::cPathDatabaseSQLite )
      makedir( ::cPathDatabaseSQLite )
   end if 
    
Return ( ::oConexion:Connect( ::cDatabaseSQLite ) )

//----------------------------------------------------------------------------//

METHOD Exec( cSql )

   local lExec    := .t.

   try
      ::oConexion:Exec( cSql )
   catch
      lExec       := .f.
   end

Return ( lExec )

//----------------------------------------------------------------------------//

METHOD checkModelsExistence()
    
Return ( aeval( ::aModels, { |cModel| ::Exec( cModel ) } ) )

//----------------------------------------------------------------------------//

Function getSQLDatabase()

   if empty( oSqlDatabase )
      oSqlDatabase            := SQLDatabase():New()
   end if

Return ( oSqlDatabase )

//----------------------------------------------------------------------------//
