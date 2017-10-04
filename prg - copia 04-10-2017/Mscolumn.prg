//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSColumn                                                    //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Clase para la gestión de columnas                            //
//---------------------------------------------------------------------------//
/*
Posibles datas o propiedades.

    cName, nombre por el q se accede al objeto, oTable:Fieldget( "Codigo" ) , oTable:FieldPut( "Codigo", "1234" )
    Buffer, valor del buffer de edición.
    ShortDescription, descripción breve para titulo de las columnas etc.
    LongDescription, para reconocimiento del campo en toda la aplicación, realizar filtros, inserción en informes y listados.
    cType, tipo q puede ser en formato xBase "N" o en sql "INT"
    DefautValue, pues eso
    lAllowsNull, lógico para saber si el campo permite valores vacios.
    lEditable, lógico para saber si lo podemos editar.
    lModified, lógico para saber si cambiamos el valor del campo.
    nLen, numero de caracteres.
    nDecimals, numero de decimales.
    oTable, referencia al objeto table.
    Value, valor actual del campo
    cPicture, picture para la edición.
    lAutoIncremental, lógico para autoincremental.
    lPrimaryKey, lógico para clave primaria.

//---------------------------------------------------------------------------//
// Estructura de atributos de las columnas

struct st_MYSQL_col {
    E1PFGETVALUE * GetValue;     // Puntero a funcion de lectura de campo
    char * szColName;           // Nombre
    unsigned int uiColSize;     // Ancho de la columna
    unsigned int uiDec;         // Decimales
    BOOL bNullable;             // Puede ser nulo?
    unsigned int uiSQLType;     // Tipo SQL
    BYTE Type;                  // Tipo xBase
//----------------------------- // Miembros propios
    MYSQL_FIELD * MyField;      // Puntero a la columna original MySQL
};
//---------------------------------------------------------------------------//
// Devuelve el nombre del campo

METHOD ColName( n ) CLASS TMSQuery
return( E1ColName( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el nombre de la tabla del campo

METHOD ColTable( n ) CLASS TMSQuery
return( E1ColTable(  ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el tipo MySQL del campo

METHOD ColType( n ) CLASS TMSQuery
return( E1ColType( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el ancho del campo

METHOD ColLength( n ) CLASS TMSQuery
return( E1ColLength( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve los decimales del campo

METHOD ColDec( n ) CLASS TMSQuery
return( E1ColDec( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el flags del campo

METHOD ColFlags( n ) CLASS TMSQuery
return( E1ColFlags( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el valor por defecto del campo

METHOD ColDefaultVal( n ) CLASS TMSQuery
return( E1ColDefaultVal( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el maximo ancho del campo

METHOD ColMaxLength( n ) CLASS TMSQuery
return( E1ColMaxLength( ::hMySQL, n ) )

//---------------------------------------------------------------------------//

*/
#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSColumn FROM TSQLVirtual

    DATA oDataSet
    DATA nIndex
    DATA cType
    DATA nLen
    DATA nDecimals
    DATA SQLType
    DATA Value
    DATA Buffer
    DATA DefautValue
    DATA cPicture
    DATA DisplayName
    DATA Description
    DATA aStruct                // Para crear la estructura de crear en tabla

    METHOD Init() CONSTRUCTOR
    METHOD GetName()
    METHOD IsPrimaryKey()
    METHOD IsNullable()
    METHOD IsAutoIncremental()
    METHOD IsEditable()
    METHOD IsModified()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD Init() CLASS TMSColumn
return( Self )

//---------------------------------------------------------------------------//

METHOD GetName() CLASS TMSColumn
return(
