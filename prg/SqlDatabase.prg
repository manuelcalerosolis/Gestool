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
   METHOD Disconnect()              INLINE ( if( !empty( ::oConexion ), ::oConexion:disconnect(), ) )
        
   METHOD Exec( cSql )             
   METHOD Query( cSql )             INLINE ( if( !empty( ::oConexion ), ::oConexion:Query( cSql ), ) )
   METHOD Prepare( cSql )           INLINE ( if( !empty( ::oConexion ), ::oConexion:Prepare( cSql ), ) )

   METHOD LastInsertId()            INLINE ( if( !empty( ::oConexion ), ::oConexion:lastInsertId(), ) )

   METHOD beginTransaction()        INLINE ( if( !empty( ::oConexion ), ::oConexion:beginTransaction(), ) )
   METHOD commit()                  INLINE ( if( !empty( ::oConexion ), ::oConexion:commit(), ) )
   METHOD rollback()                INLINE ( if( !empty( ::oConexion ), ::oConexion:rollback(), ) )

   METHOD startForeignKey()         INLINE ( ::Query( "pragma foreign_keys = ON" ) )
   METHOD endForeignKey()           INLINE ( ::Query( "pragma foreign_keys = OFF" ) )

   METHOD errorInfo()               INLINE ( if( !empty( ::oConexion ), ::oConexion:errorInfo(), ) )

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

#ifndef __TABLET__ 

   ::oConexion                := THDO():new( "sqlite" )
   
   ::oConexion:setAttribute( ATTR_ERRMODE, .t. )

#endif

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Connect()

   if !lIsDir( ::cPathDatabaseSQLite )
      makedir( ::cPathDatabaseSQLite )
   end if 

   if !empty(::oConexion)
      Return ( ::oConexion:Connect( ::cDatabaseSQLite ) )
   end if 

Return ( nil )    

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
