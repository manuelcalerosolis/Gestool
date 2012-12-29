//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSUpdateSQL                                                 //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de consultas actualizables en MySQL                  //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSUpdateSQL FROM TSQLVirtual

    DATA oDataSet
    DATA oCmd
    DATA cStmtInsert
    DATA cStmtUpdate
    DATA cStmtDelete

    METHOD New( oDataSet ) CONSTRUCTOR
    METHOD SetDataSet( oDataSet )

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

METHOD New( oDataSet ) CLASS TMSUpdateSQL

    if upper( oDataSet:ClassName() ) $ "TMSQUERY TMSDBFCURSOR TMSACURSOR"
        ::oDataSet := oDataSet
    endif

    ::SetIName( "UpdateSQL" )

return( Self )

//---------------------------------------------------------------------------//
// Asigna el DataSet.

METHOD SetDataSet( oDataSet ) CLASS TMSUpdateSQL

    local oDS := ::oDataSet

    if upper( oDataSet:ClassName() ) $ "TMSQUERY TMSDBFCURSOR TMSACURSOR"
        ::oDataSet := oDataSet
    endif

return( oDS )

//---------------------------------------------------------------------------//
// Asigna la sentencia para Insert

METHOD SetStmtInsert( cStmtInsert ) CLASS TMSUpdateSQL

    local cStmt := ::cStmtInsert

    BYNAME cStmtInsert TYPE "C"

return( cStmt )

//---------------------------------------------------------------------------//
// Asigna la sentencia para Update

METHOD SetStmtUpdate( cStmtUpdate ) CLASS TMSUpdateSQL

    local cStmt := ::cStmtUpdate

    BYNAME cStmtUpdate TYPE "C"

return( cStmt )

//---------------------------------------------------------------------------//
// Asigna la sentencia para Delete

METHOD SetStmtDelete( cStmtDelete ) CLASS TMSUpdateSQL

    local cStmt := ::cStmtDelete

    BYNAME cStmtDelete TYPE "C"

return( cStmt )

//---------------------------------------------------------------------------//
// Optine la sentencia para Insert

METHOD GetStmtInsert() CLASS TMSUpdateSQL
return( ::cStmtInsert )

//---------------------------------------------------------------------------//
// Optine la sentencia para Update

METHOD GetStmtUpdate() CLASS TMSUpdateSQL
return( ::cStmtUpdate )

//---------------------------------------------------------------------------//
// Optine la sentencia para Delete

METHOD GetStmtDelete() CLASS TMSUpdateSQL
return( ::cStmtDelete )

//---------------------------------------------------------------------------//
// Ejecuta Insert

METHOD Insert() CLASS TMSUpdateSQL

    local lRet := !empty( ::cStmtInsert )

    if lRet
        lRet := ::oCmd:ExecDirect( ::cStmtInsert )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Ejecuta Update

METHOD Update() CLASS TMSUpdateSQL

    local lRet := !empty( ::cStmtUpdate )

    if lRet
        lRet := ::oCmd:ExecDirect( ::cStmtUpdate )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Ejecuta Delete

METHOD Delete() CLASS TMSUpdateSQL

    local lRet := !empty( ::cStmtDelete )

    if lRet
        lRet := ::oCmd:ExecDirect( ::cStmtDelete )
    endif

return( lRet )

//---------------------------------------------------------------------------//

METHOD GenStatement( cStmt ) CLASS TMSUpdateSQL

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
