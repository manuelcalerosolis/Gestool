//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TSQLVirtual                                                  //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Clase virtual para la jerarquia de clases                    //
//---------------------------------------------------------------------------//

#include "util.ch"

//---------------------------------------------------------------------------//

CLASS TSQLVirtual

    //-----------------------------------------------------------------------
    // Variables de instancia:

    CLASSDATA cVersion          // Version actual de la LIB
    CLASSDATA dDateVersion      // Fecha de la LIB de la actual version
    CLASSDATA cAuthor           // Autor

    DATA cIName                 // Nombre interno
    DATA Cargo                  // Variable definible por el usuario

    //-----------------------------------------------------------------------
    // Metodos:

    METHOD Init                 // Inicializa las vaiables de instancia

    METHOD SetIName( cName )    // Asigna a cIName el valor pasado
    METHOD GetIName()           // Devuelve cIName
    METHOD GetVersion()         // Devuelve Versión de la clase

    //-----------------------------------------------------------------------
    // Metodo destructores:

    METHOD Free()               // Destructor, este es el que desarrolla
    METHOD Destroy()            // Sinonimo de ::Free()
    METHOD Close()              // Sinonimo de ::Free()
    METHOD End()                // Sinonimo de ::Free()

ENDCLASS

//---------------------------------------------------------------------------//
// Inicia datas generales - poner aquí

METHOD Init() CLASS TSQLVirtual

    ::cVersion := "Eagle1 v6.00"
    ::dDateVersion := CToD( "15/11/2010" )
    ::cAuthor := "Manu Exposito"
    ::cIName := "TEAGLE1_FAMILY"

return( Self )

//---------------------------------------------------------------------------//
// Asigna el nombre de la clase interno

METHOD SetIName( cIName ) CLASS TSQLVirtual

    local cNameOld := ::cIName

    BYNAME cIName UPPER

return( cNameOld )

//---------------------------------------------------------------------------//
// Obtiene el nombre interno de la clase

METHOD GetIName() CLASS TSQLVirtual
return( ::cIName )

//---------------------------------------------------------------------------//
// Obtiene la version de Eagle1

METHOD GetVersion() CLASS TSQLVirtual
return( ::cVersion + " " + CToD( ::dDateVersion ) )

//---------------------------------------------------------------------------//
// Destructor por defecto de la clase
// Este es el que hay que desarrollar en cada clase que tenga algo especial

PROCEDURE Free() CLASS TSQLVirtual

    Self := nil
    hb_gcAll( .t. )

return

//---------------------------------------------------------------------------//
// Otro destructor

PROCEDURE Destroy() CLASS TSQLVirtual

    ::Free()

return

//---------------------------------------------------------------------------//
// Otro destructor

PROCEDURE End() CLASS TSQLVirtual

    ::Free()

return

//---------------------------------------------------------------------------//
// Otro destructor

PROCEDURE Close() CLASS TSQLVirtual

    ::Free()

return

//---------------------------------------------------------------------------//






