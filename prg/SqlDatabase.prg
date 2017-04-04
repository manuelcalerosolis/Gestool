#include "fiveWin.ch"
#include "hdo.ch"

//----------------------------------------------------------------------------//

static oSqlDatabase

//----------------------------------------------------------------------------//

CLASS SQLDatabase

    DATA oConexion
    DATA cDatabaseSQLite        

    METHOD New()                CONSTRUCTOR
    METHOD isDatabaseSQLite()

    METHOD Conexion()           INLINE  ( ::oConexion )
    
    METHOD Connect()            INLINE  ( ::oConexion:Connect( ::cDatabaseSQLite ) )
    METHOD Exec( cSql )         INLINE  ( ::oConexion:Exec( cSql ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() 

    ::cDatabaseSQLite   := cPathDatabase() + "Gestool.db"

    ::oConexion         := THDO():new( "sqlite" )

Return ( Self )

//----------------------------------------------------------------------------//

Function getSQLDatabase()

    if empty( oSqlDatabase )
        oSqlDatabase    := SQLDatabase():New()
    end if

Return ( oSqlDatabase )

//----------------------------------------------------------------------------//

