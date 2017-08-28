#include "fiveWin.ch"
#include "hdo.ch"

//----------------------------------------------------------------------------//

static oSqlDatabase

//----------------------------------------------------------------------------//

CLASS SQLDatabase

   DATA oConexion

   DATA cPathDatabaseMySQL    
   
   DATA cDatabaseMySQL    
   DATA cIpMySQL
   DATA cUserMySQL
   DATA cPasswordMySQL

   DATA aModels                     INIT {}

   METHOD New()                     CONSTRUCTOR
   
   METHOD Conexion()                INLINE ( ::oConexion )
   METHOD Connect() 
   METHOD Disconnect()              INLINE ( if( !empty( ::oConexion ), ::oConexion:disconnect(), ) )
        
   METHOD Exec( cSql )             
   METHOD Query( cSql )             INLINE ( if( !empty( ::oConexion ), ::oConexion:Query( cSql ), ) )
   METHOD Prepare( cSql )           INLINE ( if( !empty( ::oConexion ), ::oConexion:Prepare( cSql ), ) )

   METHOD LastInsertId()            INLINE ( if( !empty( ::oConexion ), ::oConexion:lastInsertId(), ) )

   METHOD beginTransaction()        INLINE ( if( !empty( ::oConexion ), ::oConexion:beginTransaction(), ) )
   METHOD commit()                  INLINE ( if( !empty( ::oConexion ), ::oConexion:commit(), ) )
   METHOD rollback()                INLINE ( if( !empty( ::oConexion ), ::oConexion:rollback(), ) )

   METHOD startForeignKey()         VIRTUAL // INLINE ( ::Query( "pragma foreign_keys = ON" ) )
   METHOD endForeignKey()           VIRTUAL // INLINE ( ::Query( "pragma foreign_keys = OFF" ) )

   METHOD errorInfo()               INLINE ( if( !empty( ::oConexion ), ::oConexion:errorInfo(), ) )

   METHOD addModels()
   METHOD checkModelsExistence()   

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() 

   ::cPathDatabaseMySQL       := fullCurDir() + "Database\" 

   ::cDatabaseMySQL           := GetPvProfString(  "MySQL",    "Database", "gestool",     cIniAplication() )
   ::cIpMySQL                 := GetPvProfString(  "MySQL",    "Ip",       "127.0.0.1",   cIniAplication() )
   ::cUserMySQL               := GetPvProfString(  "MySQL",    "User",     "root",        cIniAplication() )
   ::cPasswordMySQL           := GetPvProfString(  "MySQL",    "Password", "",            cIniAplication() )

   ::oConexion                := THDO():new( "mysql" )
   
   ::oConexion:setAttribute( ATTR_ERRMODE, .t. )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Connect()

   if !lIsDir( ::cPathDatabaseMySQL )
      makedir( ::cPathDatabaseMySQL )
   end if 

   if !empty( ::oConexion )
      RETURN ( ::oConexion:Connect( ::cDatabaseMySQL, ::cIpMySQL, ::cUserMySQL, ::cPasswordMySQL ) )
   end if 

RETURN ( .f. )    

//----------------------------------------------------------------------------//

METHOD Exec( cSql )

   local lExec    := .t.

   try
      if !empty( ::oConexion )
         ::oConexion:Exec( cSql )
      end if 
   catch
      lExec       := .f.
   end

RETURN ( lExec )  

//----------------------------------------------------------------------------//

METHOD checkModelsExistence()

   TiposImpresorasModel():New():checkTable()

   if empty( ::aModels )
      ::addModels()
   end if 
     
RETURN ( nil ) // aeval( ::aModels, { |cModel| ::Exec( cModel ) } ) )

//----------------------------------------------------------------------------//

METHOD addModels()

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

   aadd( ::aModels, SQLMovimientosAlmacenModel():New():getSQLCreateTable() )

RETURN ( ::aModels )

//----------------------------------------------------------------------------//

Function getSQLDatabase()

   if empty( oSqlDatabase )
      oSqlDatabase            := SQLDatabase():New()
   end if

RETURN ( oSqlDatabase )

//----------------------------------------------------------------------------//


