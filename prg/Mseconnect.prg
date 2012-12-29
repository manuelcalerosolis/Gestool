//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSEConnect                                                  //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de conexiones embebidas en MySQL                     //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSEConnect FROM TMSVConnect

    DATA aOptions
    DATA aGroups

    METHOD Init()
    METHOD Connect( aOptions, aGroups, cDbName, nClientFlag )
    METHOD ReConnect()
    METHOD RefreshVar()
    METHOD Free()

ENDCLASS

//---------------------------------------------------------------------------//
// Inicia variables de instancia

METHOD Init() CLASS TMSEConnect

    Super:Init()

    ::aOptions := {}
    ::aGroups := {}
    ::lClientServer := .f.

    ::SetIName( "EConnect" )

return( Self )

//---------------------------------------------------------------------------//
// Abre la conexion con los parametros especificados

METHOD Connect(  aOptions, aGroups, cDbName, nClientFlag ) CLASS TMSEConnect

    if ValType( aOptions ) == "A" .and. len( aOptions ) > 0
        ::aOptions := aOptions
    else
        ::aOptions := { "My_Eagle1_Program", "my.ini" }
    endif

    if ValType( aGroups ) == "A" .and. len( aGroups ) > 0
        ::aGroups := aGroups
    else
        ::aGroups := { "mysqld", "client" }
    endif

    ::hConnect := E1LibraryInit( ::aOptions, ::aGroups )

    if ::lInit := !( ::hConnect == 0 )
        ::oError:New( ::hConnect )
        if ::lConnected := E1RealConnect( ::hConnect,,,, cDbName, 0,, nClientFlag )
            if ValType( cDbName ) == "C"
                ::oDataBase := TMSDataBase():New( Self, cDbName )
            endif
            ::RefreshVar()
        else
            ::oError:Show()
        endif
    else
        ::oError:Say( "No se puede iniciar la estructura en MySQL", .f. )
    endif

return( ::lConnected )

//---------------------------------------------------------------------------//
// Reabre la conexion con los parametros anteriores

METHOD ReConnect() CLASS TMSEConnect

    local nClientFlag := if( !empty( ::nClientFlag ), ::nClientFlag, nil )
    local cDbName := ::oDataBase:cName

    ::Free()

    Self := TMSEConnect():New( ::aOptions, ::aGroups )

return( ::Connect( cDbName, nClientFlag ) )

//---------------------------------------------------------------------------//
// Actualiza las DATAs de la clase, por si se han hecho cambios desde fuera
// de la clase

METHOD RefreshVar() CLASS TMSEConnect

    ::nClientFlag := E1ClientFlag( ::hConnect )

return( Self )

//---------------------------------------------------------------------------//
// Libera memoria y destruye el objeto

PROCEDURE Free() CLASS TMSEConnect

    Super:Free()

    E1LibraryEnd()

    ::aOptions := nil
    ::aGroups := nil

return

//---------------------------------------------------------------------------//

