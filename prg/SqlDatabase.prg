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
   METHOD Execs( aSql )             
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

   METHOD checkModels()   
   METHOD checkModel( oModel )   
   METHOD getSchemaColumns()

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

METHOD Execs( aSql )

RETURN ( aeval( aSql, {|cSql| ::Exec( cSql ) } ) ) 

//----------------------------------------------------------------------------//

METHOD checkModels()

RETURN ( aeval( ::aModels, {|oModel| ::checkModel( oModel ) } ) )

//----------------------------------------------------------------------------//

METHOD checkModel( oModel )

   local aSchemaColumns    := ::getSchemaColumns( oModel )

   if empty( aSchemaColumns )
      ::Exec( oModel:getCreateTableSentence() )
   else
      ::Execs( oModel:getAlterTableSentences( aSchemaColumns ) )
   end if 
  
RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD getSchemaColumns( oModel )

   local cSentence
   local oStatement
   local aSchemaColumns

   cSentence               := "SELECT COLUMN_NAME "                              +;
                                 "FROM INFORMATION_SCHEMA.COLUMNS "              +;
                                 "WHERE table_name = " + quoted( oModel:cTableName )

   try

      oStatement           := getSQLDatabase():Query( cSentence )
   
      aSchemaColumns       := oStatement:fetchAll( FETCH_HASH )

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

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

   aadd( ::aModels, TiposImpresorasModel():New() )

   aadd( ::aModels, TiposNotasModel():New() )

   aadd( ::aModels, EtiquetasModel():New() )

   aadd( ::aModels, SituacionesModel():New() )

   aadd( ::aModels, HistoricosUsuariosModel():New() )

   aadd( ::aModels, RelacionesEtiquetasModel():New() )
                                      
   aadd( ::aModels, TiposVentasModel():New() )

   aadd( ::aModels, ConfiguracionEmpresasModel():New() )

   aadd( ::aModels, PropiedadesModel():New() )

   aadd( ::aModels, PropiedadesLineasModel():New() )

   aadd( ::aModels, SQLMovimientosAlmacenModel():New() )

RETURN ( ::aModels )

//----------------------------------------------------------------------------//

Function getSQLDatabase()

   if empty( oSqlDatabase )
      oSqlDatabase            := SQLDatabase():New()
   end if

RETURN ( oSqlDatabase )

//----------------------------------------------------------------------------//


