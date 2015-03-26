//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2007                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSQueryLive                                                 //
//  FECHA MOD.: 09/12/2007                                                   //
//  VERSION...: 5.05                                                         //
//  PROPOSITO.: Gestión de consultas actualizables (vivas) en MySQL          //
//---------------------------------------------------------------------------//

#include "Eagle1.Ch"

//---------------------------------------------------------------------------//

CLASS TMSQueryLive FROM TMSQuery

    DATA cStmtInsert
    DATA cStmtUpdate
    DATA cStmtDelete

    METHOD New CONSTRUCTOR

    METHOD SetStmtInsert
    METHOD SetStmtUpdate
    METHOD SetStmtDelete

    METHOD GetStmtInsert
    METHOD GetStmtUpdate
    METHOD GetStmtDelete

    METHOD GenStatement

    METHOD Insert
    METHOD Update
    METHOD Delete

ENDCLASS

//---------------------------------------------------------------------------//
// Constructor de la clase

METHOD New( oDbCon, cStatement ) CLASS TMSQueryLive

    Super:New( oDbCon, cStatement )

    ::SetIName( "QueryLive" )

return( Self )

//---------------------------------------------------------------------------//
// Asigna la sentencia para Insert

METHOD SetStmtInsert( cStmtInsert ) CLASS TMSQueryLive

    local cStmt := ::cStmtInsert

    BYNAME cStmtInsert IFNONIL

return( cStmt )

//---------------------------------------------------------------------------//
// Asigna la sentencia para Update

METHOD SetStmtUpdate( cStmtUpdate ) CLASS TMSQueryLive

    local cStmt := ::cStmtUpdate

    BYNAME cStmtUpdate IFNONIL

return( cStmt )

//---------------------------------------------------------------------------//
// Asigna la sentencia para Delete

METHOD SetStmtDelete( cStmtDelete ) CLASS TMSQueryLive

    local cStmt := ::cStmtDelete

    BYNAME cStmtDelete IFNONIL

return( cStmt )

//---------------------------------------------------------------------------//
// Optine la sentencia para Insert

METHOD GetStmtInsert() CLASS TMSQueryLive
return( ::cStmtInsert )

//---------------------------------------------------------------------------//
// Optine la sentencia para Update

METHOD GetStmtUpdate() CLASS TMSQueryLive
return( ::cStmtUpdate )

//---------------------------------------------------------------------------//
// Optine la sentencia para Delete

METHOD GetStmtDelete() CLASS TMSQueryLive
return( ::cStmtDelete )

//---------------------------------------------------------------------------//
// Ejecuta Insert

METHOD Insert() CLASS TMSQueryLive

    local lRet := .f.

    if !empty( ::cStmtInsert )
        lRet := ::oCmd:ExecDirect( ::cStmtInsert )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Ejecuta Update

METHOD Update() CLASS TMSQueryLive

    local lRet := .f.

    if !empty( ::cStmtUpdate )
        lRet := ::oCmd:ExecDirect( ::cStmtUpdate )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Ejecuta Delete

METHOD Delete() CLASS TMSQueryLive

    local lRet := .f.

    if !empty( ::cStmtDelete )
        lRet := ::oCmd:ExecDirect( ::cStmtDelete )
    endif

return( lRet )

//---------------------------------------------------------------------------//

METHOD GenStatement( cStmt ) CLASS TMSQueryLive

    local cExpr, cContain, uContain

    while "{" $ cStmt
        cExpr := SubStr( cStmt, at( "{", cStmt ) + 1, ;
                                at( "}", cStmt ) ;
                              - at( "{", cStmt ) - 1 )
        uContain := eval( &( "{ ||" + cExpr + " }" ) )
        cContain := transform( uContain, "@" )
        cStmt    := StrTran( cStmt, "{" + cExpr + "}", cContain, 1 )
    end

return( cStmt )

//---------------------------------------------------------------------------//