#include "fiveWin.ch"
#include "hdo.ch"
#include "hdomysql.ch"

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
   DATA lEmbeddedMySQL

   DATA aModels                           INIT {}

   METHOD New()                           CONSTRUCTOR
   METHOD NewEmbedded()                   CONSTRUCTOR
   
   METHOD Conexion()                      INLINE ( ::oConexion )
   METHOD Connect() 
   METHOD ConnectWithoutDataBase()
   METHOD Disconnect()                    INLINE ( if( !empty( ::oConexion ), ::oConexion:disconnect(), ) )

   METHOD Ping()                          INLINE ( if( !empty( ::oConexion ), ::oConexion:Ping(), ) )

   METHOD Exec( cSql )             
   METHOD Execs( aSql )             
   METHOD Query( cSql )                   INLINE ( if( !empty( ::oConexion ), ::oConexion:Query( cSql ),  msgstop( "No ha conexiones disponibles" ) ) )
   METHOD Prepare( cSql )                 INLINE ( if( !empty( ::oConexion ), ::oConexion:Prepare( cSql ),  msgstop( "No ha conexiones disponibles" ) ) )
   METHOD Parse( cSql )                   INLINE ( if( !empty( ::oConexion ), ::oConexion:Parse( cSql ),  msgstop( "No ha conexiones disponibles" ) ) )

   METHOD escapeStr( cEscape )            INLINE ( if( !empty( ::oConexion ), ::oConexion:escapeStr( cEscape ), cEscape ) )

   METHOD selectFetch( cSql )
   METHOD selectFetchHash( cSentence )    INLINE ::selectFetch( cSentence, FETCH_HASH )
   METHOD selectFetchArray( cSentence )   INLINE ::selectFetch( cSentence, FETCH_ARRAY )
   METHOD selectFetchArrayOneColumn( cSentence )

   METHOD selectValue( cSql )

   METHOD fetchRowSet( cSentence )

   METHOD lastInsertId()                  INLINE ( if( !empty( ::oConexion ), ::oConexion:lastInsertId(), msgstop( "No ha conexiones disponibles" ) ) )

   METHOD beginTransaction()              INLINE ( if( !empty( ::oConexion ), ::oConexion:beginTransaction(),  msgstop( "No ha conexiones disponibles" ) ) )
   METHOD commit()                        INLINE ( if( !empty( ::oConexion ), ::oConexion:commit(), msgstop( "No ha conexiones disponibles" ) ) )
   METHOD rollback()                      INLINE ( if( !empty( ::oConexion ), ::oConexion:rollback(),  msgstop( "No ha conexiones disponibles" ) ) )

   METHOD startForeignKey()               VIRTUAL // INLINE ( ::Query( "pragma foreign_keys = ON" ) )
   METHOD endForeignKey()                 VIRTUAL // INLINE ( ::Query( "pragma foreign_keys = OFF" ) )

   METHOD errorInfo()                     INLINE ( if( !empty( ::oConexion ), ::oConexion:errorInfo(), ) )

   METHOD checkModels()   
   METHOD checkModel( oModel )   
   METHOD getSchemaColumns()

   METHOD sayConexionInfo()               INLINE ( "Database : " + ::cDatabaseMySQL + CRLF + ;
                                                   "IP : " + ::cIpMySQL             + CRLF + ;
                                                   "User : " + ::cUserMySQL         + CRLF + ;
                                                   "Password : " + ::cPasswordMySQL )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() 

   local aOptions             := { "GESTOOL", "--defaults-file=./my.cnf" }             
   local aGroup               := { "server", "client" }                                 

   ::cPathDatabaseMySQL       := fullCurDir() + "Database\" 

   if !lIsDir( ::cPathDatabaseMySQL )
      makedir( ::cPathDatabaseMySQL )
   end if 

   ::cDatabaseMySQL           := GetPvProfString(  "MySQL",    "Database", "gestool",     cIniAplication() )
   ::cIpMySQL                 := GetPvProfString(  "MySQL",    "Ip",       "127.0.0.1",   cIniAplication() )
   ::cUserMySQL               := GetPvProfString(  "MySQL",    "User",     "root",        cIniAplication() )
   ::cPasswordMySQL           := GetPvProfString(  "MySQL",    "Password", "",            cIniAplication() )
   ::lEmbeddedMySQL           := GetPvProfString(  "MySQL",    "Embedded", ".F.",         cIniAplication() )
   ::lEmbeddedMySQL           := upper( ::lEmbeddedMySQL ) == ".T."

   if ::lEmbeddedMySQL
      initMySQLEmdSys( aOptions, aGroup, "client" )                             
   end if 

   ::oConexion                := THDO():new( "mysql" )

   ::oConexion:setAttribute( ATTR_ERRMODE, .t. )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD NewEmbedded()

   local aOptions := { 'GESTOOL', '--defaults-file=./mysql.cnf' }
   // local aOptions := { 'GESTOOL', '--datadir=./data/' } 
   local aGroup   := { "server", "embedded" }
   
   // ::oConexion    := MySQLEmbNew( aOptions, aGroup, "embedded" ) 

   ::oConexion:setAttribute( ATTR_ERRMODE, .t. )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Connect()

   local lConnect    := .t.

   try
   
      if !empty( ::oConexion )
         
         ::oConexion:setAttribute( MYSQL_OPT_RECONNECT, .t. )

         lConnect    := ::oConexion:Connect( ::cDatabaseMySQL, ::cIpMySQL, ::cUserMySQL, ::cPasswordMySQL )

      end if 
       
   catch 

      lConnect       := .f.
   
   end

RETURN ( lConnect )    

//----------------------------------------------------------------------------//

METHOD ConnectWithoutDataBase()

   local lConnect    := .t.

   try
   
      if !empty( ::oConexion )
         
         lConnect    := ::oConexion:Connect( nil, ::cIpMySQL, ::cUserMySQL, ::cPasswordMySQL )

      end if 
       
   catch 

      lConnect       := .f.
   
   end

RETURN ( lConnect )    

//----------------------------------------------------------------------------//

METHOD Exec( cSql )

   local lExec    := .t.
   local oError

   if empty( ::oConexion )
      msgstop( "No hay conexiones disponibles" )
      RETURN ( .f. )  
   end if 

   try

      ::oConexion:Ping()
   
      ::oConexion:Exec( cSql )
       
   catch oError

      eval( errorBlock(), oError )

      lExec       := .f.
   
   end

RETURN ( lExec )  

//----------------------------------------------------------------------------//

METHOD Execs( sqlSentence )

   if hb_isarray( sqlSentence )
      RETURN ( aeval( sqlSentence, {|cSql| ::Exec( cSql ) } ) ) 
   end if 

RETURN ( ::Exec( sqlSentence ) ) 

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

      ::oConexion:Ping()

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

      ::oConexion:Ping()   

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

METHOD fetchRowSet( cSentence )

   local oError
   local oRowSet
   local oStatement

   if empty( ::oConexion )
      msgstop( "No hay conexiones disponibles" )
      RETURN ( .f. )  
   end if  

   try 

      ::oConexion:Ping()   

      oStatement     := ::oConexion:Query( cSentence )

      oStatement:setAttribute( ATTR_STR_PAD, .t. )

      oRowSet        := oStatement:fetchRowSet()

   catch oError

      eval( errorBlock(), oError )

   finally

      // if !empty( oStatement )
      //    oStatement:Free()
      // end if 

   end

RETURN ( oRowSet )

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

Function getSQLDatabase()

   if empty( oSqlDatabase )
      oSqlDatabase            := SQLDatabase():New()
   end if

RETURN ( oSqlDatabase )

//----------------------------------------------------------------------------//


