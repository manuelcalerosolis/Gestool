//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSStatement                                                 //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de sentecias SQL preparadas o compiladas en MySQL    //
//---------------------------------------------------------------------------//

/*
    Notas:
    En desarrollo

    Probar a asignar una variable xBase y en C asociar el Value al Bind
*/

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSPreparedStmt FROM TMSStatement

    DATA hStmt
    DATA hResPre
    DATA aBindResult INIT {}    // Para las columnas de un resultado
    DATA aBindParameter INIT {} // Parametros de sentencias que usan ?
    DATA lPrepared INIT .f.

    METHOD New( oDbCon, cStatement ) CONSTRUCTOR

    METHOD Prepare( cStmt )
    METHOD Execute()
    METHOD ResultMetaData()
    METHOD ParamCount()
    METHOD BindResult()

    METHOD AddBindResult( oBindResult )
    METHOD InsBind( n, nType, nLen )    VIRTUAL
    METHOD DelBind( n )                 VIRTUAL

    METHOD AddParameter( xValue )       VIRTUAL

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oDbCon, cStatement ) CLASS TMSPreparedStmt

    Super:New( oDbCon, cStatement )

    ::hStmt := E1StmtInit( oDbCon:hConnect )

    ::SetIName( "PreparedStmt" )

return( Self )

//---------------------------------------------------------------------------//

METHOD Prepare( cStmt ) CLASS TMSPreparedStmt

    ::SetStatement( cStmt )

return( E1StmtPrepare( ::hStmt, ::cStatement ) )

//---------------------------------------------------------------------------//

METHOD Execute() CLASS TMSPreparedStmt
return( E1StmtExecute( ::hstmt ) )

//---------------------------------------------------------------------------//

METHOD ResultMetaData() CLASS TMSPreparedStmt
return( ::hResPre := E1StmtResultMetaData( ::hStmt ) )

//---------------------------------------------------------------------------//

METHOD ParamCount() CLASS TMSPreparedStmt
return( E1StmtParamCount( ::hStmt ) )

//---------------------------------------------------------------------------//

METHOD AddBindResult( oBindResult ) CLASS TMSPreparedStmt

    AAdd( ::aBindResult, oBindResult )

return( Self )

//---------------------------------------------------------------------------//

METHOD BindResult() CLASS TMSPreparedStmt

    local n
    local nLen := len( ::aBindResult )
    local aBind := {}

    for n := 1 to nLen
        AAdd( aBind, ::aBindResult[ n ]:GetAsArray() )
    next

return( E1_BindResult( ::hStmt, aBind ) )

//---------------------------------------------------------------------------//

//===========================================================================//

CLASS TMSBindResult

    DATA Buffer
    DATA nType
    DATA Length
    DATA IsNull

    METHOD New( cType, Length, IsNull ) CONSTRUCTOR
    METHOD GetAsArray()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( cType, Length, IsNull ) CLASS TMSBindResult

    DEFAULT cType := "C" TYPE "C"
    BYNAME Length TYPE "N"
    BYNAME IsNull TYPE "L"

    SWITCH cType

        CASE 'C'
            ::Buffer := space( ::Length )
            ::nType := 254      // MYSQL_TYPE_STRING
            EXIT

        CASE 'N'
            ::Buffer := 0
            ::nType := 0        // MYSQL_TYPE_DECIMAL
            EXIT

        DEFAULT
            ::Buffer := space( ::Length )

    END


return( Self )

//---------------------------------------------------------------------------//

METHOD GetAsArray() CLASS TMSBindResult
return( { ::Buffer, ::nType, ::Length, ::IsNull } )

//---------------------------------------------------------------------------//

