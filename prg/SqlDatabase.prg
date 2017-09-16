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

   DATA aModels                           INIT {}

   METHOD New()                           CONSTRUCTOR
   
   METHOD Conexion()                      INLINE ( ::oConexion )
   METHOD Connect() 
   METHOD Disconnect()                    INLINE ( if( !empty( ::oConexion ), ::oConexion:disconnect(), ) )
        
   METHOD Exec( cSql )             
   METHOD Execs( aSql )             
   METHOD Query( cSql )                   INLINE ( if( !empty( ::oConexion ), ::oConexion:Query( cSql ),  msgstop( "No ha conexiones disponibles" ) ) )
   METHOD Prepare( cSql )                 INLINE ( if( !empty( ::oConexion ), ::oConexion:Prepare( cSql ),  msgstop( "No ha conexiones disponibles" ) ) )

   METHOD selectFetch( cSql )
   METHOD selectFetchHash( cSentence )    INLINE ::selectFetch( cSentence, FETCH_HASH )
   METHOD selectFetchArray( cSentence )   INLINE ::selectFetch( cSentence, FETCH_ARRAY )
   METHOD selectFetchArrayOneColumn( cSentence )

   METHOD selectValue( cSql )

   METHOD lastInsertId()                  INLINE ( if( !empty( ::oConexion ), ::oConexion:lastInsertId(), msgstop( "No ha conexiones disponibles" ) ) )

   METHOD beginTransaction()              INLINE ( if( !empty( ::oConexion ), ::oConexion:beginTransaction(),  msgstop( "No ha conexiones disponibles" ) ) )
   METHOD commit()                        INLINE ( if( !empty( ::oConexion ), ::oConexion:commit(), msgstop( "No ha conexiones disponibles" ) ) )
   METHOD rollback()                      INLINE ( if( !empty( ::oConexion ), ::oConexion:rollback(),  msgstop( "No ha conexiones disponibles" ) ) )

   METHOD startForeignKey()               VIRTUAL // INLINE ( ::Query( "pragma foreign_keys = ON" ) )
   METHOD endForeignKey()                 VIRTUAL // INLINE ( ::Query( "pragma foreign_keys = OFF" ) )

   METHOD errorInfo()                     INLINE ( if( !empty( ::oConexion ), ::oConexion:errorInfo(), ) )

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
   local oError

   if empty( ::oConexion )
      msgstop( "No hay conexiones disponibles" )
      RETURN ( .f. )  
   end if 

   try
   
      ::oConexion:Exec( cSql )
       
   catch oError

      eval( errorBlock(), oError )

      lExec       := .f.
   
   end

RETURN ( lExec )  

//----------------------------------------------------------------------------//

METHOD Execs( aSql )

RETURN ( aeval( aSql, {|cSql| ::Exec( cSql ) } ) ) 

//----------------------------------------------------------------------------//

METHOD selectFetch( cSentence, fetchType )

   local oError
   local aFetch
   local oStatement

   default fetchType := FETCH_ARRAY

   if empty( ::oConexion )
      msgstop( "No hay conexiones disponibles" )
      RETURN ( nil )  
   end if  

   try 

      oStatement     := ::oConexion:Query( cSentence )
   
      aFetch         := oStatement:fetchAll( fetchType )

   catch oError

      eval( errorBlock(), oError )

   finally

      if !empty( oStatement )
         oStatement:Free()
      end if

   end

   if !empty( aFetch ) .and. hb_isarray( aFetch )
      RETURN ( aFetch )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD selectValue( cSentence )

   local oError
   local nValue
   local oStatement

   if empty( ::oConexion )
      msgstop( "No hay conexiones disponibles" )
      RETURN ( .f. )  
   end if  

   try 

      oStatement     := ::oConexion:Query( cSentence )

      oStatement:fetchDirect()
   
      nValue         := oStatement:getValue( 1 )

   catch oError

      eval( errorBlock(), oError )

   finally

      if !empty( oStatement )
         oStatement:Free()
      end if 

   end

RETURN ( nValue )

//---------------------------------------------------------------------------//

METHOD selectFetchArrayOneColumn( cSentence )

   local uFetch
   local aFetch   
   local aResult  

   aFetch         := ::selectFetchArray( cSentence )

   if !hb_isarray( aFetch )
      RETURN ( nil )
   end if 

   aResult        := array( len( aFetch ) )

   for each uFetch in aFetch 
      aResult[ hb_enumindex() ]  := uFetch[ 1 ] 
   next

RETURN ( aResult )

//---------------------------------------------------------------------------//

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

   local oError
   local cSentence
   local oStatement
   local aSchemaColumns

   if empty( ::oConexion )
      msgstop( "No hay conexiones disponibles" )
      RETURN ( nil )  
   end if  

   cSentence               := "SELECT COLUMN_NAME "                              +;
                                 "FROM INFORMATION_SCHEMA.COLUMNS "              +;
                                 "WHERE table_name = " + quoted( oModel:cTableName )

   try

      oStatement           := ::oConexion:Query( cSentence )
   
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


