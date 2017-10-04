//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSDataSet                                           //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de objetos contenedores de columnas                  //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSDataSet FROM TMSStatement

    DATA hMySQL INIT 0          // Puntero a estructura Eagle1_MySQL
    DATA oCmd                   // Objeto command que ejecuta sentencias SQL
    DATA lOpened INIT .f.       // Indicador de estado de apertura

    METHOD New( oDbCon, cStatement ) CONSTRUCTOR
    METHOD AffectedRows()
    METHOD Free()

    METHOD Struct()
    METHOD XStruct()

    METHOD Execute( cStmt )

    METHOD EscapeStr( nCol )

    METHOD SetTinyAsLogical( lLogical )
    METHOD SetReadPADAll( lRead )

    METHOD ColRead( n ) VIRTUAL

    //------------------------------------------------------------
    // Para desarrollar la gestion de columnas

    DATA aColumns INIT {}       // Array de objetos Columna
    METHOD GenObjColumn( n ) VIRTUAL
    METHOD GenObjColumns() VIRTUAL

ENDCLASS

//---------------------------------------------------------------------------//
// Constructor de la clase

METHOD New( oDbCon, cStatement ) CLASS TMSDataSet

    Super:New( oDbCon, cStatement )

    if ::lInit
        ::hMySQL := E1INITDS( ::oConnect:hConnect )
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

METHOD AffectedRows() CLASS TMSDataSet
return( ::oCmd:AffectedRows() )

//---------------------------------------------------------------------------//
// Ejecuta una sentencia desde el objeto

METHOD Execute( cStmt ) CLASS TMSDataSet
return( ::oCmd:ExecDirect( cStmt ) )

//---------------------------------------------------------------------------//
// Filtra las secuencias de escape y las cadenas especiales

METHOD EscapeStr( nCol ) CLASS TMSDataSet
return( E1RealEscapeStr( ::oConnect:hConnect, ::ColRead( nCol ) ) )

//---------------------------------------------------------------------------//

PROCEDURE Free()CLASS TMSDataSet

    ::oCmd:Free()
    ::lOpened := .f.
    ::hMySQL := 0

    Super:Free()

return

//---------------------------------------------------------------------------//
// Obtiene un array con la estructura de la consulta al estilo de DbStruct

METHOD Struct() CLASS TMSDataSet
return( E1DbStruct( ::hMySQL ) )

//---------------------------------------------------------------------------//
// Obtiene un array con la estructura extendida de la consulta
// al estilo de DbStruct ( Autoinc y tipo dato numerico de momento )

METHOD XStruct() CLASS TMSDataSet
return( E1XStruct( ::hMySQL ) )

//---------------------------------------------------------------------------//
// Pone o quita todas las columnas Tiny como logicas

METHOD SetTinyAsLogical( lLogical ) CLASS TMSDataSet
return( E1SetTinyAsLogical( ::hMySQL, lLogical ) )

//---------------------------------------------------------------------------//
// Activa la lectura de todos los campos caracter formateados a su tamaño

METHOD SetReadPADAll( lRead ) CLASS TMSDataSet
return( E1SetPadAll( ::hMySQL, lRead ) )

//---------------------------------------------------------------------------//

