//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TEagle1                                                      //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Clase virtual para la jerarquia de clases de Eagle1, de esta //
//              derivan las clases con data oError para gestion de errores   //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TEagle1 FROM TSQLVirtual

    DATA oError INIT TMSError() // Objeto error

    METHOD IsError()
    METHOD Succeeded()

    METHOD SetAutoError( lOnOff )
    METHOD GetLastError()

    METHOD Free()               // Destructor por defecto es el que desarrolla

ENDCLASS

//---------------------------------------------------------------------------//

METHOD IsError() CLASS TEagle1
return( ::oError:IsError() )

//---------------------------------------------------------------------------//

METHOD Succeeded() CLASS TEagle1
return( !::oError:IsError() )

//---------------------------------------------------------------------------//
// Establece o desactiva el control de errores interno

METHOD SetAutoError( lOnOff ) CLASS TEagle1
return( ::oError:SetAutoError( lOnOff ) )

//---------------------------------------------------------------------------//
// Devuelve el último error producido

METHOD GetLastError() CLASS TEagle1
return( ::oError:GetError() )

//---------------------------------------------------------------------------//
// Destructor por defecto de la clase
// Este es el que hay que desarrollar en cada clase que tenga algo especial

PROCEDURE Free() CLASS TEagle1

    if upper( ::oError:ClassName() ) == "TMSERROR"
        ::oError:Free()
    endif

    Super:Free()

return

//---------------------------------------------------------------------------//



