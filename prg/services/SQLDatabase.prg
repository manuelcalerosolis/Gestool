#include "fiveWin.ch"
#include "hdo.ch"
#include "hdomysql.ch"

//----------------------------------------------------------------------------//

static oSqlDatabase

static oSqlCompany

//----------------------------------------------------------------------------//

CLASS SQLDatabase

   DATA oConexion

   DATA oStatement

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
   METHOD ExecWithOutParse( cSql )        INLINE ( ::Exec( cSql, .f. ) )     
   
   METHOD Execs( aSql ) 
   METHOD ExecsWithOutParse( aSql )       INLINE ( ::Execs( aSql, .f. ) )

   METHOD TransactionalExec( cSql )       INLINE ( ::BeginTransaction(), ::Exec( cSql ), ::Commit() )            
   
   METHOD Query( cSql )                   INLINE ( if( !empty( ::oConexion ), ::oConexion:Query( cSql ), msgstop( "No ha conexiones disponibles" ) ) )
   METHOD Prepare( cSql )                 INLINE ( if( !empty( ::oConexion ), ::oConexion:Prepare( cSql ), msgstop( "No ha conexiones disponibles" ) ) )
   METHOD Parse( cSql )                   INLINE ( if( !empty( ::oConexion ), ::oConexion:Parse( cSql ), msgstop( "No ha conexiones disponibles" ) ) )

   METHOD escapeStr( cEscape )            INLINE ( if( !empty( ::oConexion ), ::oConexion:escapeStr( cEscape ), cEscape ) ) 

   METHOD genStatement( cStatement )

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

   METHOD getValue( cSql, nColumn )       

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

   METHOD showError( e )

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

   ::oConexion                := THDO():new( "mysql" )

   ::oConexion:setAttribute( HDO_ATTR_ERRMODE, .t. )

   ::oConexion:setAttribute( MYSQL_OPT_RECONNECT, .t. )

   ::oConexion:setAttribute( STMT_ATTR_TINY_AS_BOOL, .t. )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Connect()

   local lConnect    := .t.

   try
   
      if !empty( ::oConexion )

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

   local e

   if empty( cSentence )
      msgstop( "La sentencia esta vacia", "SQLDatabase" )
      RETURN ( .t. )  
   end if  

   if empty( ::oConexion )
      msgstop( "No hay conexiones disponibles" )
      RETURN ( .t. )  
   end if  

   ::oConexion:Ping()

   try
      
      ::oConexion:Parse( cSentence )

   catch e
      
      logwrite( cSentence )

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
   
      ::oConexion:Exec( cSentence )
       
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

METHOD genStatement( cSentence )
/*
   local cExpr, cContain, uContain

   while "{{" $ cSentence
      
      cExpr          := substr( cSentence, at( "{{", cSentence ) + 2, at( "}}", cSentence ) - at( "{{", cSentence ) - 2 )

      msgalert( cExpr, "cExpr" )

      if "|" $ cExpr
         
         msgalert( valtype( &( "{" + cExpr + " }" ) ), "valtype" )
         
         uContain    := eval( &( "{" + cExpr + " }" ) )
      else
         uContain    := eval( &( "{||" + cExpr + " }" ) )
      end if 

      msgalert( uContain, "uContain" )

      cContain    := transform( uContain, "@" )

      msgalert( cContain, "cContain" )

      cSentence   := strtran( cSentence, "{{" + cExpr + "}}", cContain, 1 )

      msgalert( cSentence, "cSentence" )

    end
*/
RETURN ( cSentence )

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

      oStatement:setAttribute( STMT_ATTR_TINY_AS_BOOL, .t. )

      oStatement:setAttribute( STMT_ATTR_CURSOR_TYPE, CURSOR_TYPE_READ_ONLY )         
   
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

METHOD getValue( cSentence, uDefault )

   local oError
   local uValue
   local oStatement

   try 

      oStatement     := ::Query( cSentence )

      oStatement:setAttribute( STMT_ATTR_STR_PAD, .t. )

      oStatement:setAttribute( STMT_ATTR_TINY_AS_BOOL, .t. )
   
      oStatement:setAttribute( STMT_ATTR_CURSOR_TYPE, CURSOR_TYPE_READ_ONLY )   
      
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

   local nCount
   local aFetch
   local oQuery
   local cString

   oQuery         := ::Query( "SELECT Count(*) " + cTable )

   aFetch         := oQuery:fetch()

   oQuery:free()

   if nCount == 0
      RETURN ( self )
   end if 

   cString        := "--  Datos de la tabla " + cTable + hb_osnewline()
   cString        += "INSERT INTO `" + cTable + "` VALUES " + hb_osnewline()

   fwrite( hFileName, cString )

   hdo_rowprocess( ::oConexion:getHandle(), hFileName, cTable )  // Hacerlo en lenguaje C
   
   cString        :=  hb_osnewline() + "--  Fin de datos de la tabla " + cTable + hb_osnewline() + hb_osnewline()

   fwrite( hFileName, cString )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD showError( e )

   do case 
      case ( "Duplicate entry " $ e:Description )
         msgstop( "Clave primaria duplicada, la combinación de datos ya existe", "Error" )
      otherwise
         msgstop( e:SubSystem + ";" + padl( e:SubCode, 4 ) + ";" + e:Operation + ";" + e:Description, "Error en sentencia" )  
   end case

RETURN ( self )

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