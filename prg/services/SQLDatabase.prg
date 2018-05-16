#include "fiveWin.ch"
#include "hdo.ch"
#include "hdomysql.ch"

//----------------------------------------------------------------------------//

static oSqlDatabase

//----------------------------------------------------------------------------//

CLASS SQLDatabase

   DATA oConexion

   DATA oStatement

   DATA cPathDatabaseMySQL    
   
   DATA cDatabaseMySQL    

   DATA cIpMySQL
   DATA cUserMySQL
   DATA cPasswordMySQL
   DATA nPortMySQL

   DATA aModels                           INIT {}

   METHOD New()                           CONSTRUCTOR
   
   METHOD Conexion()                      INLINE ( ::oConexion )
   METHOD Connect() 
   METHOD ConnectWithoutDataBase()
   METHOD Disconnect()                    INLINE ( if( !empty( ::oConexion ), ::oConexion:disconnect(), ) )
   
   METHOD RowSet( cSql )                  INLINE ( if( !empty( ::oConexion ), ::oConexion:RowSet( cSql ), ) )

   METHOD Ping()                          INLINE ( if( !empty( ::oConexion ), ::oConexion:Ping(), ) )

   METHOD isParseError()

   METHOD Exec( cSql )             
   METHOD Execs( aSql ) 
   METHOD TransactionalExec( cSql )       INLINE ( ::BeginTransaction(), ::Exec( cSql ), ::Commit() )            
   METHOD Query( cSql )                   INLINE ( if( !empty( ::oConexion ), ::oConexion:Query( cSql ), msgstop( "No ha conexiones disponibles" ) ) )
   METHOD Prepare( cSql )                 INLINE ( if( !empty( ::oConexion ), ::oConexion:Prepare( cSql ), msgstop( "No ha conexiones disponibles" ) ) )
   METHOD Parse( cSql )                   INLINE ( if( !empty( ::oConexion ), ::oConexion:Parse( cSql ), msgstop( "No ha conexiones disponibles" ) ) )

   METHOD escapeStr( cEscape )            INLINE ( if( !empty( ::oConexion ), ::oConexion:escapeStr( cEscape ), cEscape ) ) 

   METHOD selectFetch( cSql )

   METHOD selectFetchHash( cSentence, attributePad )  INLINE ::selectFetch( cSentence, FETCH_HASH, attributePad )
   METHOD selectTrimedFetchHash( cSentence )          INLINE ::selectFetchHash( cSentence, .f. )
   METHOD selectPadedFetchHash( cSentence )           INLINE ::selectFetchHash( cSentence, .t. )
   METHOD firstTrimedFetchHash( cSentence )           

   METHOD selectFetchArray( cSentence, attributePad ) INLINE ::selectFetch( cSentence, FETCH_ARRAY, attributePad )
   METHOD selectTrimedFetchArray( cSentence )         INLINE ::selectFetchArray( cSentence, .f. )

   METHOD selectFetchToJson( cSentence )
   
   METHOD selectFetchArrayOneColumn( cSentence )

   METHOD selectHashList( cSentence )

   METHOD getValue( cSql, nColumn )       // INLINE ( if( !empty( ::oConexion ), ::oConexion:execScalar( cSql, nColumn ), msgstop( "No ha conexiones disponibles" ) ) )

   METHOD lastInsertId()                  INLINE ( if( !empty( ::oConexion ), ::oConexion:lastInsertId(), msgstop( "No ha conexiones disponibles" ) ) )

   METHOD beginTransaction()              INLINE ( if( !empty( ::oConexion ), ::oConexion:beginTransaction(),  msgstop( "No ha conexiones disponibles" ) ) )
   METHOD Commit()                        INLINE ( if( !empty( ::oConexion ), ::oConexion:commit(), msgstop( "No ha conexiones disponibles" ) ) )
   METHOD rollBack()                      INLINE ( if( !empty( ::oConexion ), ::oConexion:rollback(),  msgstop( "No ha conexiones disponibles" ) ) )

   METHOD errorInfo()                     INLINE ( if( !empty( ::oConexion ), ::oConexion:errorInfo(), ) )

   METHOD Export( cFileName )
      METHOD exportTable( hFileName, cTable )

   METHOD checkModels()   
   METHOD checkModel( oModel ) 

   METHOD getSchemaColumns()

   METHOD getListTables()

   METHOD sayConexionInfo()               INLINE ( "Database : " + ::cDatabaseMySQL + CRLF + ;
                                                   "IP : " + ::cIpMySQL             + CRLF + ;
                                                   "User : " + ::cUserMySQL         + CRLF + ;
                                                   "Password : " + ::cPasswordMySQL + CRLF + ;
                                                   "Port : " + alltrim( str( ::nPortMySQL ) ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() 

   ::cPathDatabaseMySQL       := fullCurDir() + "Database\" 

   if !lIsDir( ::cPathDatabaseMySQL )
      makedir( ::cPathDatabaseMySQL )
   end if 

   ::cDatabaseMySQL           := GetPvProfString(  "MySQL",    "Database", "gestool",     cIniAplication() )
   ::cIpMySQL                 := GetPvProfString(  "MySQL",    "Ip",       "127.0.0.1",   cIniAplication() )
   ::cUserMySQL               := GetPvProfString(  "MySQL",    "User",     "root",        cIniAplication() )
   ::cPasswordMySQL           := GetPvProfString(  "MySQL",    "Password", "",            cIniAplication() )
   ::nPortMySQL               := GetPvProfInt(     "MySQL",    "Port",     3306,          cIniAplication() )

   ::oConexion                := THDO():new( "mysql" )

   ::oConexion:setAttribute( HDO_ATTR_ERRMODE, .t. )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Connect()

   local lConnect    := .t.

   try
   
      if !empty( ::oConexion )
         
         ::oConexion:setAttribute( MYSQL_OPT_RECONNECT, .t. )

         lConnect    := ::oConexion:Connect( ::cDatabaseMySQL, ::cIpMySQL, ::cUserMySQL, ::cPasswordMySQL, ::nPortMySQL )

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
         
         lConnect    := ::oConexion:Connect( nil, ::cIpMySQL, ::cUserMySQL, ::cPasswordMySQL, ::nPortMySQL )

      end if 
       
   catch 

      lConnect       := .f.
   
   end

RETURN ( lConnect )    

//----------------------------------------------------------------------------//

METHOD isParseError( cSentence )

   if empty( cSentence )
      msgstop( "La sentencia esta vacia" )
      RETURN ( .t. )  
   end if  

   if empty( ::oConexion )
      msgstop( "No hay conexiones disponibles" )
      RETURN ( .t. )  
   end if  

   ::oConexion:Ping()

   if !::oConexion:Parse( cSentence )
      msgstop( cSentence, "Error en el comando SQL" )
      logwrite( cSentence )
      RETURN ( .t. )  
   end if 

RETURN ( .f. )

//----------------------------------------------------------------------------//

METHOD Exec( cSentence )

   local lExec    := .t.
   local oError

   if ::isParseError( cSentence )
      RETURN ( .f. )  
   end if 

   try
   
      ::oConexion:Exec( cSentence )
       
   catch oError

      eval( errorBlock(), oError )

      lExec       := .f.
   
   end

RETURN ( lExec )  

//----------------------------------------------------------------------------//

METHOD Execs( cSentence )

   if hb_isarray( cSentence )
      RETURN ( aeval( cSentence, {|cSql| ::Exec( cSql ) } ) ) 
   end if 

RETURN ( ::Exec( cSentence ) ) 

//----------------------------------------------------------------------------//

METHOD selectFetch( cSentence, fetchType, attributePad )

   local oError
   local aFetch
   local oStatement

   DEFAULT fetchType    := FETCH_ARRAY
   DEFAULT attributePad := .t.

   if ::isParseError( cSentence )
      RETURN ( nil )  
   end if 

   try 

      oStatement        := ::Query( cSentence )

      oStatement:setAttribute( STMT_ATTR_STR_PAD, attributePad )
   
      aFetch            := oStatement:fetchAll( fetchType )

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

METHOD firstTrimedFetchHash( cSentence )

   local aSelect        := ::selectTrimedFetchHash( cSentence )

   if hb_isarray( aSelect )
      RETURN ( afirst( aSelect ) )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD selectFetchToJson( cSentence, attributePad )

   local aFetch

   DEFAULT attributePad := .f.

   aFetch               := ::selectFetchHash( cSentence, attributePad )

   if hb_isarray( aFetch )
      RETURN ( hb_jsonencode( aFetch, .t. ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD selectHashList( cSentence )

   local oError
   local oHashList
   local oStatement
   local oStatementFetch

   if ::isParseError( cSentence )
      RETURN ( nil )  
   end if  

   try 

      oStatement           := ::Query( cSentence )

      if !empty( oStatement )

          oStatementFetch  := oStatement:fetchAll( FETCH_HASH )

          if !empty( oStatementFetch )
            oHashList      := THashList():new( oStatementFetch ) 
         end if 
         
      end if 

   catch oError

      eval( errorBlock(), oError )

   finally

      if !empty( oStatement )
         oStatement:Free()
      end if

   end

   if !empty( oHashList )
      RETURN ( oHashList )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getValue( cSentence )

   local oError
   local uValue
   local oStatement

   try 

      oStatement     := ::Query( cSentence )
      
      if oStatement:fetchDirect()
         uValue      := oStatement:getValue( 1 ) 
      end if
      
   catch oError

      eval( errorBlock(), oError )

   finally

      if !empty( oStatement )
         oStatement:Free()
      end if 

      oStatement  := nil

   end

RETURN ( uValue )

//---------------------------------------------------------------------------//

METHOD selectFetchArrayOneColumn( cSentence )

   local aFetch   
   local aResult  := {}  

   aFetch         := ::selectFetchArray( cSentence, .f. )

   if !hb_isarray( aFetch )
      RETURN ( aResult )
   end if 

   aResult        := array( len( aFetch ) )

   aeval( aFetch, {|x, n| aResult[ n ] := alltrim( afirst( x ) ) } )

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

   cSentence               := "SELECT COLUMN_NAME "                                 +;
                                 "FROM INFORMATION_SCHEMA.COLUMNS "                 +;
                                 "WHERE table_name = " + quoted( oModel:cTableName )

   if ::isParseError( cSentence )
      RETURN ( nil )  
   end if  

   try

      oStatement           := ::Query( cSentence )
   
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

METHOD getListTables()
   
   local oError
   local oStatement
   local aListTables

   try 

      oStatement           := ::Query( "SHOW TABLES FROM " + ::cDatabaseMySQL )      
            
      aListTables          := oStatement:fetchAllArray()

   catch oError

      eval( errorBlock(), oError )

   finally

      if !empty( oStatement )
         oStatement:Free()
      end if

   end

RETURN ( aListTables )

//---------------------------------------------------------------------------//

METHOD Export( cFileName )

   local cString     
   local hFileName   
   local aListTables 

   hFileName         := fcreate( cFileName )
   if ferror() <> 0
      msgStop( "Error creando fichero de backup : " + cFileName + ", error " + alltrim( str(  ferror() ) ), "Error" )
      RETURN ( .f. )
   endif

   aListTables       := ::getListTables()
   if empty( aListTables )
      RETURN ( .f. )
   endif

   cString           := "USE `" + ::cDatabaseMySQL + "`;" + hb_osnewline() + hb_osnewline()

   fwrite( hFileName, cString )

   aeval( aListTables,;
      {|aTables| aeval( aTables,;
         {|cTable| ::exportTable( hFileName, cTable ) } ) } )

   cString           := "--  " + hb_OSNewLine()
   cString           += "--  Fin del procesado de la base de datos " + ::cDatabaseMySQL + hb_OSNewLine()
   cString           += "--  " + hb_OSNewLine() + hb_OSNewLine()

   fwrite( hFileName, cString )

   fclose( hFileName )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD exportTable( hFileName, cTable )

   local cString

   cString        := "--  Datos de la tabla " + cTable + hb_osnewline()
   cString        += "INSERT INTO `" + cTable + "` VALUES " + hb_osnewline()

   fwrite( hFileName, cString )

   hdo_rowprocess( ::oConexion:getHandle(), hFileName, cTable )  // Hacerlo en lenguaje C
   
   cString        :=  hb_osnewline() + "--  Fin de datos de la tabla " + cTable + hb_osnewline() + hb_osnewline()

   fwrite( hFileName, cString )

RETURN ( self )

//---------------------------------------------------------------------------//

Function getSQLDatabase()

   if empty( oSqlDatabase )
      oSqlDatabase            := SQLDatabase():New()
   end if

RETURN ( oSqlDatabase )

//----------------------------------------------------------------------------//


