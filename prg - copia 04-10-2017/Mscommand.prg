//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSCommand                                                   //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de peticiones generales en MySQL                     //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSCommand FROM TMSStatement

    METHOD New( oDbCon, cStmt ) CONSTRUCTOR

    METHOD ExecDirect( cStmt )
    MESSAGE Execute() METHOD ExecDirect()
    METHOD AffectedRows()
    METHOD MoreResults()
    METHOD NextResult()

ENDCLASS

//---------------------------------------------------------------------------//
// Inicia y asigna una sentencia SQL lista para ser ejecutada

METHOD New( oDbCon, cStmt ) CLASS TMSCommand

    Super:New( oDbCon, cStmt )

    ::SetIName( "Command" )

return( Self )

//---------------------------------------------------------------------------//
// IMPORTANTE ejecuta sentecias SQL que no devuelven registros.

METHOD ExecDirect( cStatement ) CLASS TMSCommand

    local lRet := ( ValType( cStatement ) == "C" )

    if lRet
        ::cStatement := cStatement
        if !( lRet := E1ExecDirect( ::oConnect:hConnect, ::cStatement ) )
            ::oError:Show( .f. )
        endif
    endif

return( lRet )

//---------------------------------------------------------------------------//

METHOD AffectedRows() CLASS TMSCommand
return( E1AffectedRows( ::oConnect:hConnect ) )

//---------------------------------------------------------------------------//
// Comprueba si hay mas resultados pendientes de devolver, .t. si hay y
// .f. si por el contrario no hay

METHOD MoreResults() CLASS TMSCommand
return( E1MoreResults( ::oConnect:hConnect ) )

//---------------------------------------------------------------------------//
// Ejecuta el siguiente comando.
// Los valores de retorno son:
//  0  -> Éxito y hay más resultados
// -1  -> Éxito y no hay más resultados
// >0  -> Se ha producido un error

METHOD NextResult() CLASS TMSCommand
return( E1NextResult( ::oConnect:hConnect ) )

//---------------------------------------------------------------------------//

