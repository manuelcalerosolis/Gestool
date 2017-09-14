//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2007                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TStoreProc                                                   //
//  FECHA MOD.: 09/12/2007                                                   //
//  VERSION...: 5.05                                                         //
//  PROPOSITO.: Gestión de prodimientos almacenados en MySQL                 //
//---------------------------------------------------------------------------//

#include "Eagle1.Ch"

//---------------------------------------------------------------------------//

CLASS TStoreProc FROM TMSQuery

    DATA cName
    DATA aParams

    METHOD New CONSTRUCTOR

    METHOD SetParam
    METHOD GetParam

    METHOD ShowCreate
    METHOD Call

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TStoreProc
return( Self )

//---------------------------------------------------------------------------//

METHOD SetParam( nParam, uVal ) CLASS TStoreProc

    local uValOld := ::aParams[ nParam ]

    if uVal != nil
        ::aParams[ nParam ] := uVal
    endif

return( uValOld )

//---------------------------------------------------------------------------//

METHOD GetParam( nParam ) CLASS TStoreProc
return( ::aParams[ nParam ] )

//---------------------------------------------------------------------------//

METHOD ShowCreate() CLASS TStoreProc

    local cRet, oQry

    oQry := TMSQuery():New( ::oConnect, "SHOW CREATE PROCEDURE " + ::cName )

    oQry:Open()

    cRet := oQry:FieldGet( 2 )

    oQry:Free()

return( cRet )

//---------------------------------------------------------------------------//

METHOD Call() CLASS TStoreProc

    local cStmt := "CALL " + ::cName


return( ::Execute( cStmt ) )


//---------------------------------------------------------------------------//
