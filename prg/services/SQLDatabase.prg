#include "fiveWin.ch"
#include "hdo.ch"
#include "hdomysql.ch"
#include "hdocommon.ch"

//----------------------------------------------------------------------------//

static oSqlDatabase

static oSqlCompany

//----------------------------------------------------------------------------//

CLASS SQLDatabase

   DATA aConexions                     INIT {} 

   DATA nCurrentConexion               INIT 1 

   DATA oStatement

   DATA nTransCount                    INIT 0

   DATA cDatabaseMySQL    

   DATA cIpMySQL
   DATA cUserMySQL
   DATA cPasswordMySQL
   DATA nPortMySQL

   DATA cBackUpFileName                INIT ""

   DATA aModels                        INIT {}

   METHOD New()                        CONSTRUCTOR
   
   METHOD createConexion()

   METHOD addConexion()

   METHOD getConexion()                INLINE ( atail( ::aConexions ) )

   METHOD Connect() 
   METHOD ConnectWithoutDataBase()
   METHOD Disconnect()                 INLINE ( if( !empty( ::getConexion() ), ::getConexion():Disconnect(), ) )
   
   METHOD RowSet( cSql )               INLINE ( if( !empty( ::getConexion() ), ::getConexion():RowSet( cSql ), ) )

   METHOD Ping()                       INLINE ( if( !empty( ::getConexion() ), ::getConexion():Ping(), ) )

   METHOD isParseError()

   METHOD Exec( cSql )        
   METHOD ExecWithOutParse( cSql )     INLINE ( ::Exec( cSql, .f. ) )     
   
   METHOD Execs( aSql ) 
   METHOD ExecsWithOutParse( aSql )    INLINE ( ::Execs( aSql, .f. ) )

   METHOD TransactionalExec( cSql )    INLINE ( ::Exec( cSql ) )            
   
   METHOD Query( cSql )                
   METHOD Querys( aSql )  

   METHOD Prepare( cSql )              INLINE ( if( !empty( ::getConexion() ), ::getConexion():Prepare( cSql ), msgstop( "No ha conexiones disponibles" ) ) )
   METHOD Parse( cSql )                INLINE ( if( !empty( ::getConexion() ), ::getConexion():Parse( cSql ), msgstop( "No ha conexiones disponibles" ) ) )

   METHOD escapeStr( cEscape )         INLINE ( if( !empty( ::getConexion() ), ::getConexion():escapeStr( cEscape ), cEscape ) ) 

   METHOD selectFetch( cSql )

   METHOD selectFetchHash( cSentence, attributePad );
                                       INLINE ::selectFetch( cSentence, FETCH_HASH, attributePad )
   METHOD selectTrimedFetchHash( cSentence );
                                       INLINE ::selectFetchHash( cSentence, .f. )
   METHOD selectPadedFetchHash( cSentence );
                                       INLINE ::selectFetchHash( cSentence, .t. )
   METHOD firstTrimedFetchHash( cSentence )           

   METHOD selectFetchArray( cSentence, attributePad ) ;
                                       INLINE ::selectFetch( cSentence, FETCH_ARRAY, attributePad )
   METHOD selectTrimedFetchArray( cSentence ) ;
                                       INLINE ::selectFetchArray( cSentence, .f. )

   METHOD selectFetchToJson( cSentence )
   
   METHOD selectFetchArrayOneColumn( cSentence )

   METHOD selectHashList( cSentence )

   METHOD getValue( cSql, nColumn )       

   METHOD lastInsertId()               INLINE ( iif( !empty( ::getConexion() ), ::getConexion():lastInsertId(), msgstop( "No ha conexiones disponibles" ) ) )

   METHOD beginTransaction()           
   METHOD Commit()                     
   METHOD rollBack()                   

   METHOD errorInfo()                  INLINE ( iif( !empty( ::getConexion() ), ::getConexion():errorInfo(), ) )

   METHOD Export( cBackUpFileName )
      METHOD exportTable( hFileName, cTable )

   METHOD checkModels()   
   METHOD checkModel( oModel ) 

   METHOD getSchemaColumns() 

   METHOD getListTables()

   METHOD sayConexionInfo()            INLINE ( "Database : " + ::cDatabaseMySQL + CRLF + ;
                                                "IP : " + ::cIpMySQL             + CRLF + ;
                                                "User : " + ::cUserMySQL         + CRLF + ;
                                                "Password : " + ::cPasswordMySQL + CRLF + ;
                                                "Port : " + alltrim( str( ::nPortMySQL ) ) )

   METHOD showError( e )

   METHOD setAutoCommitToTrue()        INLINE ( msgalert( "setAutoCommitToTrue" ), getSQLDatabase():Exec( "SET @@autocommit = 1;" ) )

   METHOD setAutoCommitToFalse()       INLINE ( msgalert( "setAutoCommitToFalse" ), getSQLDatabase():Exec( "SET @@autocommit = 0;" ) )

   METHOD commitData()                 INLINE ( msgalert( "commitData" ), getSQLDatabase():Exec( "COMMIT;" ) )                 

   METHOD rollbackData()               INLINE ( msgalert( "rollbackData" ), getSQLDatabase():Exec( "ROLLBACK;" ) ) 

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cDatabaseMySQL )

   if empty( cDatabaseMySQL ) 
      cDatabaseMySQL          := GetPvProfString(  "MySQL",    "Database", "gestool",     cIniAplication() )
   end if 

   ::cDatabaseMySQL           := cDatabaseMySQL

   ::cIpMySQL                 := GetPvProfString(  "MySQL",    "Ip",       "127.0.0.1",   cIniAplication() )
   ::cUserMySQL               := GetPvProfString(  "MySQL",    "User",     "root",        cIniAplication() )
   ::cPasswordMySQL           := GetPvProfString(  "MySQL",    "Password", "",            cIniAplication() )
   ::nPortMySQL               := GetPvProfInt(     "MySQL",    "Port",     3306,          cIniAplication() )

   ::addConexion()
   
RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD createConexion()

   local oConexion            := THDO():new( "mysql" )

   oConexion:setAttribute( HDO_ATTR_ERRMODE, .t. ) 

   oConexion:setAttribute( MYSQL_OPT_RECONNECT, .t. ) 

   oConexion:setAttribute( HDO_ATTR_DEF_TINY_AS_BOOL, .t. )     

RETURN ( oConexion )

//----------------------------------------------------------------------------//

METHOD addConexion()

   aadd( ::aConexions, ::createConexion() )

RETURN ( ::aConexions )

//----------------------------------------------------------------------------//

METHOD Connect()

   local lConnect    := .t.

   try
   
      if !empty( ::getConexion() )

         lConnect    := ::getConexion():Connect( ::cDatabaseMySQL, ::cIpMySQL, ::cUserMySQL, ::cPasswordMySQL, ::nPortMySQL )

      end if 
       
   catch 

      lConnect       := .f.
   
   end

RETURN ( lConnect )    

//----------------------------------------------------------------------------//

METHOD ConnectWithoutDataBase()

   local lConnect    := .t.

   try
   
      if !empty( ::getConexion() )
         
         lConnect    := ::getConexion():Connect( nil, ::cIpMySQL, ::cUserMySQL, ::cPasswordMySQL, ::nPortMySQL )

      end if 
       
   catch 

      lConnect       := .f.
   
   end

RETURN ( lConnect )    

//----------------------------------------------------------------------------//

METHOD isParseError( cSentence )

   local e

   if empty( cSentence )
      msgstop( "La sentencia esta vacia", "SQLDatabase" )
      RETURN ( .t. )  
   end if  

   if empty( ::getConexion() )
      msgstop( "No hay conexiones disponibles" )
      RETURN ( .t. )  
   end if  

   ::getConexion():Ping()

   try
      
      ::getConexion():Parse( cSentence )

   catch e
      
      ::showError( e )

      RETURN ( .t. )

   end 

RETURN ( .f. )

//----------------------------------------------------------------------------//

METHOD Exec( cSentence, lParse )

   local e
   local lExec    := .t.

   DEFAULT lParse := .t.

   if !hb_ischar( cSentence )
      RETURN ( .f. )  
   end if 

   if lParse .and. ::isParseError( cSentence )
      RETURN ( .f. )  
   end if 

   try
   
      ::getConexion():Exec( cSentence )

   catch e

      logwrite( cSentence )

      ::showError( e )

      lExec       := .f.
   
   end

RETURN ( lExec )  

//----------------------------------------------------------------------------//

METHOD Execs( cSentence, lParse )

   if hb_isarray( cSentence )
      RETURN ( aeval( cSentence, {|cSql| ::Exec( cSql, lParse ) } ) ) 
   end if 

RETURN ( ::Exec( cSentence, lParse ) ) 

//----------------------------------------------------------------------------//

METHOD Querys( cSentence, lParse )

   if hb_isarray( cSentence )
      RETURN ( aeval( cSentence, {|cSql| ::Query( cSql, lParse ) } ) ) 
   end if 

RETURN ( ::Query( cSentence, lParse ) ) 

//----------------------------------------------------------------------------//

METHOD selectFetch( cSentence, fetchType, attributePad )

   local oError
   local aFetch
   local oStatement

   DEFAULT fetchType    := 1
   DEFAULT attributePad := .t.

   if ::isParseError( cSentence )
      RETURN ( nil )  
   end if 

   try 

      oStatement        := ::Prepare( cSentence )

      oStatement:setAttribute( STMT_ATTR_STR_PAD, attributePad )

      oStatement:setAttribute( STMT_ATTR_CURSOR_TYPE, CURSOR_TYPE_READ_ONLY )

      oStatement:Execute()   
      
      aFetch            := oStatement:fetchAll( fetchType )

   catch oError
      
      eval( errorBlock(), oError )

   finally

      if !empty( oStatement )
         oStatement:Free()
      end if

      oStatement        := nil

   end

   if !empty( aFetch ) .and. hb_isarray( aFetch )
      RETURN ( aFetch )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Query( cSentence )

   local oError
   local oStatement

   try  

      oStatement        := ::getConexion():Query( cSentence )

   catch oError
      
      eval( errorBlock(), oError )

   finally

      if !empty( oStatement )
         oStatement:Free()
      end if

      oStatement        := nil

   end

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

      oStatement           := nil

   end

   if !empty( oHashList )
      RETURN ( oHashList )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getValue( cSentence, uDefault )

   local oError
   local uValue
   local oStatement

   try 

      oStatement     := ::Prepare( cSentence )

      oStatement:setAttribute( STMT_ATTR_STR_PAD, .t. )

      oStatement:setAttribute( STMT_ATTR_CURSOR_TYPE, CURSOR_TYPE_READ_ONLY ) 

      oStatement:Execute()  
      
      if oStatement:fetchDirect()
         uValue      := oStatement:getValue( 1 ) 
      end if
      
   catch oError

      eval( errorBlock(), oError )

   finally

      if !empty( oStatement )
         oStatement:Free()
      end if 

      oStatement     := nil

   end

RETURN ( if( empty( uValue ), uDefault, uValue ) )

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
  
RETURN ( nil )

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

      oStatement           := nil
   
   end

   if empty( aSchemaColumns ) .or. !hb_isarray( aSchemaColumns )
      RETURN ( nil )
   end if

RETURN ( aSchemaColumns )

//---------------------------------------------------------------------------//

METHOD getListTables()

RETURN ( ::selectFetchArray( "SHOW TABLES FROM " + ::cDatabaseMySQL ) )

//---------------------------------------------------------------------------//

METHOD beginTransaction()

   if ::nTransCount == 0
      ::getConexion():execDirect( "START TRANSACTION" )
   else
      ::getConexion():execDirect( "SAVEPOINT " + "trans" + hb_ntos( ::nTransCount ) )
   endif
   
RETURN ( ++::nTransCount, msgalert( ::nTransCount, "nTransCount" ) )

//---------------------------------------------------------------------------//

METHOD Commit()

   --::nTransCount

   msgalert( ::nTransCount, "Commit" )

   if ::nTransCount == 0
      RETURN ( ::getConexion():execDirect( "COMMIT" ) )
   endif

RETURN ( ::getConexion():execDirect( "RELEASE SAVEPOINT " + "trans" + hb_ntos( ::nTransCount ) ) )

//---------------------------------------------------------------------------//

METHOD rollBack()

   if ::nTransCount == 0
      RETURN ( nil )
   end if 

   --::nTransCount

    msgalert( ::nTransCount, "rollBack" )
    
   if ::nTransCount == 0
      RETURN ( ::getConexion():execDirect( "ROLLBACK" ) )
   endif

RETURN ( ::getConexion():execDirect( "ROLLBACK TO SAVEPOINT " + "trans" + hb_ntos( ::nTransCount ) ) )

//---------------------------------------------------------------------------//

METHOD Export( cBackUpFileName )

   local cString     
   local hFileName   
   local aListTables 

   DEFAULT cBackUpFileName := cPatSafe() + ::cDatabaseMySQL + dtos( date() ) + ".sql"

   ::cBackUpFileName       := cBackUpFileName

   hFileName               := fcreate( ::cBackUpFileName )
   if ferror() <> 0
      msgStop( "Error creando fichero de backup : " + ::cBackUpFileName + ", error " + alltrim( str( ferror() ) ), "Error" )
      RETURN ( .f. )
   endif

   aListTables             := ::getListTables()
   if empty( aListTables )
      RETURN ( .f. )
   endif

   cString                 := "USE `" + ::cDatabaseMySQL + "`;" + hb_osnewline() + hb_osnewline()

   fwrite( hFileName, cString )

   aeval( aListTables,;
      {|aTables| aeval( aTables,;
         {|cTable| ::exportTable( hFileName, cTable ) } ) } )

   cString                 := "--  " + hb_osnewline()
   cString                 += "--  Fin del procesado de la base de datos " + ::cDatabaseMySQL + hb_osnewline()
   cString                 += "--  " + hb_osnewline() + hb_osnewline()

   fwrite( hFileName, cString )

   fclose( hFileName )

RETURN ( file( ::cBackUpFileName ) )

//---------------------------------------------------------------------------//

METHOD exportTable( hFileName, cTable )

   local nCount
   local cString

   nCount         := ::getValue( "SELECT count(*) FROM " + cTable, 0 )

   if nCount == 0
      RETURN ( nil )
   end if 

   cString        := "-- Datos de la tabla " + cTable + hb_osnewline()
   cString        += "INSERT IGNORE INTO `" + cTable + "` VALUES " + hb_osnewline()

   fwrite( hFileName, cString )

   hdo_rowprocess( ::getConexion():getHandle(), hFileName, cTable )  // Hacerlo en lenguaje C
   
   cString        :=  hb_osnewline() + "-- Fin de datos de la tabla " + cTable + hb_osnewline() + hb_osnewline()

   fwrite( hFileName, cString )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD showError( e )

   do case 
      case ( "Duplicate entry " $ e:Description )
         msgstop( "Clave primaria duplicada, la combinación de datos ya existe", "Error" )
      otherwise
         msgstop( e:SubSystem + ";" + padl( e:SubCode, 4 ) + ";" + e:Operation + ";" + e:Description, "Error en sentencia" )  
   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION getSQLDatabase()

   if empty( oSqlDatabase )
      oSqlDatabase            := SQLDatabase():New()
   end if

RETURN ( oSqlDatabase )

//----------------------------------------------------------------------------//

FUNCTION getSQLCompany( cCompanyDatabase )

   if empty( oSqlCompany )
      oSqlCompany             := SQLDatabase():New( cCompanyDatabase )
      oSqlCompany:Connect()
   end if

RETURN ( oSqlCompany )

//----------------------------------------------------------------------------//

FUNCTION endSQLCompany( cCompanyDatabase )

   if !empty( oSqlCompany )
      oSqlCompany:Disconnect()
      oSqlCompany             := nil
   end if

RETURN ( nil )

//----------------------------------------------------------------------------//