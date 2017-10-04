//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSFieldDef                                                  //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Clase para la gestión de columnas                            //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSFieldDef FROM TSQLVirtual

    DATA oDataSet
    DATA nColumn
    DATA cName
    DATA cType
    DATA nLen
    DATA nDecimals
    DATA SQLType
    DATA IsPrimaryKey
    DATA IsNullable
    DATA IsAutoIncremental
    DATA DefautValue
    DATA Value
    DATA Buffer
    DATA cPicture
    DATA ShortDescription
    DATA LongDescription
    DATA IsEditable
    DATA IsModified
    DATA aStruct                // Para crear la estructura de crear en tabla

    METHOD New( oDataSet ) CONSTRUCTOR
    METHOD SetDataSet( oDataSet )
    METHOD GetDataSet()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oDataSet ) CLASS TMSFieldDef

    BYNAME oDataSet

return( Self )

//---------------------------------------------------------------------------//

METHOD SetDataSet( oDataSet ) CLASS TMSFieldDef

    BYNAME oDataSet

return( Self )

//---------------------------------------------------------------------------//

METHOD GetDataSet() CLASS TMSFieldDef
return( ::oDataBase )

//---------------------------------------------------------------------------//



