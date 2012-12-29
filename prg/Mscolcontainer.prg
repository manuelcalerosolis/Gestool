//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2007                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSColumnContainer                                           //
//  FECHA MOD.: 09/12/2007                                                   //
//  VERSION...: 5.05                                                         //
//  PROPOSITO.: Gestión de objetos contenedores de columnas                  //
//---------------------------------------------------------------------------//

#include "Eagle1.Ch"

//---------------------------------------------------------------------------//

CLASS TMSColumnContainer FROM TMSStatement

    DATA hMySQL INIT 0          // Puntero a estructura Eagle1_MySQL
    DATA oCmd                   // Objeto command que ejecuta sentencias SQL
    DATA lOpened INIT .f.       // Indicador de estado de apertura

    METHOD New CONSTRUCTOR
    METHOD AffectedRows
    METHOD Free

    METHOD Execute

//    DATA aColumns INIT {}   // Array de objetos Columna
    METHOD GenObjColumns VIRTUAL

ENDCLASS

//---------------------------------------------------------------------------//
// Constructor de la clase

METHOD New( oDbCon, cStatement ) CLASS TMSColumnContainer

    Super:New( oDbCon, cStatement )

    if ::lInit
        ::hMySQL := E1InitSt( ::oConnect:hConnect )
        if ::hMySQL == 0
            ::oError:Say( "No se pudo reservar memoria en ST", .f.  )
            ::lInit := .f.
        else
            ::oCmd := TMSCommand():New( ::oConnect )
        endif
    endif

return( Self )

//---------------------------------------------------------------------------//
// Devuelve el numero de filas afectado por el ultimo comando ejecutado

METHOD AffectedRows() CLASS TMSColumnContainer
return( ::oCmd:AffectedRows() )

//---------------------------------------------------------------------------//
// Ejecuta una sentencia desde el objeto

METHOD Execute( cStmt ) CLASS TMSColumnContainer
return( ::oCmd:ExecDirect( cStmt ) )

//---------------------------------------------------------------------------//
// Libera la memoria y el objeto

METHOD Free() CLASS TMSColumnContainer

    ::oCmd:Free()

    E1FreeResult( ::hMySQL )
    ::lOpened := .f.
    ::hMySQL := 0

return( Super:Free() )

//---------------------------------------------------------------------------//

