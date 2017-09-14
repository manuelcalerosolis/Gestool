//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Calero                                                 //
//  e-Mail....: mexposito@dipusevilla.es  ¢  maex14@dipusevilla.es            //
//  CLASE.....: TDbf                                                          //
//  FECHA MOD.: 07/07/99                                                      //
//  VERSION...: 3.50                                                          //
//  PROPOSITO.: Gesti¢n y control de DBFs                                     //
//----------------------------------------------------------------------------//

#include "Objects.ch"

#include "DBStruct.ch"
#include "FileIO.ch"

#include "TDbfMsg.ch"

//----------------------------------------------------------------------------//

#define idVERSION   "TDbf version 3.50"

#ifndef _SET_STRICTREAD
    #define vCL52
    #define _SET_STRICTREAD   43
    #define _SET_OPTIMIZE     44
    #define _SET_AUTOPEN      45
    #define _SET_AUTORDER     46
    #define _SET_AUTOSHARE    47
#endif

#define MULTITAG "DBFCDX DBFMDX DBFNSX SIXCDX SIXNSX COMIX"

//----------------------------------------------------------------------------//


CLASS TTrn

    DATA cTmp, cTmpFile, cTmpAlias                       AS CHARACTERACTER
    DATA bOnCreateTmp INIT { || .t. }                   	AS BLOCK

//-- INITIALIZE AND ACTIVATE METHODS -----------------------------------------//

    METHOD  New( cFile, cUsrAlias, cRDD, cComment, cPath, cTmp )  CONSTRUCTOR
    METHOD  Activate( lRecycle, lBuffer, lShared, lReadOnly, lProtec )
    METHOD  CreateTmp()
    METHOD  Open( lNew )
    METHOD  Charge()                   INLINE msginfo("charge" )
    METHOD  DisCharge()                INLINE msginfo("discharge" )

ENDCLASS

//----------------------------------------------------------------------------//
// Constructor por defecto si la DBF no esta aun abierta

METHOD New( cFile, cUsrAlias, cRDD, cComment, cPath, cTmp ) CLASS TTrn

    cFile  := if( ValType( cFile )  != "C", "DBF.DBF", upper( cFile ) )

    DEFAULT cPath := GetPath( cFile )
    DEFAULT cTmp  := cPatEmp()

    ::cPath       := if( !empty( cPath ) .and. ;
                          right( cPath, 1 ) != "\", cPath + "", cPath )
    ::cTmp        := if( !empty( cTmp ) .and. ;
                          right( cTmp, 1 ) != "\", cTmp + "\", cTmp )

    ::cFile       := ::cPath + GetFileName( cFile )
    ::cTmpFile    := ::cTmp + GetFileName( cFile )

    ::cUsrAlias   := if( ValType( cUsrAlias ) != "C", GetFileNoExt( ::cFile ), cUsrAlias )
    ::cTmpAlias   := "tmp" + ::cUsrAlias

    ::cRDD        := if( ValType( cRDD )     != "C", "", upper( cRDD ) )
    ::cComment    := if( ValType( cComment ) != "C", "", cComment )

    Set( _SET_OPTIMIZE  , "ON" )
    Set( _SET_AUTOPEN   , "OFF" )
    Set( _SET_AUTORDER  , "OFF" )
    Set( _SET_AUTOSHARE , "OFF" )

    ::iVarInit()

return( Self )

//----------------------------------------------------------------------------//
// Inicializa el objeto y la tabla de campos del fichero de datos

METHOD Activate( lRecycle, lBuffer, lShared, lReadOnly, lProtec ) CLASS TTrn

    super:activate( lRecycle, lBuffer, lShared, lReadOnly, lProtec )

    /*
    Ahora creamos el fichero temporal
    */

    ::CreateTmp()

return( Self )

//----------------------------------------------------------------------------//

METHOD CreateTmp() CLASS TTrn

    if Eval( ::bOnCreateTmp, Self )
        if len( ::aTField ) == 0
            MsgInfo( ::aMsg[ dbFLDNODEF ] )
        else
            DbCreate( ::cTmpFile, ::aField(), ::cRDD )
        endif
    endif

return( Self )

//----------------------------------------------------------------------------//

METHOD Open( lNewArea ) CLASS TTrn

    static nCont := 0

    local lContinue := .t.
    local lOpen     := .f.

    DEFAULT lNewArea := .t.

    if Eval( ::bOnOpen, Self )
        if Select( ::cUsrAlias ) > 0
            ++nCont
            ::cAlias := "DBA" + PadL( nCont, 5, "0" )
        else
            ::cAlias := ::cUsrAlias
        endif

        while lContinue
          DbUseArea( lNewArea, ::cRDD, ;
                    ::cFile, ::cAlias, ::lShared, ::lReadOnly )
          lContinue := if( lOpen := !NetErr(), .f., eval( ::bOpenError, Self ) )
        end while

        // Apertura de la base de datos temporal

        if Select( ::cTmpAlias ) > 0
            ++nCont
            ::cTmpAlias := "DBA" + PadL( nCont, 5, "0" )
        endif

        while lContinue
          DbUseArea( lNewArea, ::cRDD, ;
                    ::cTmpFile, ::cTmpAlias, ::lShared, ::lReadOnly )
          lContinue := if( lOpen := !NetErr(), .f., eval( ::bOpenError, Self ) )
        end while

    endif

return( lOpen )

//----------------------------------------------------------------------------//

METHOD Close() CLASS TTrn

    if ::Used()
        if Eval( ::bOnClose, Self )
            ( ::cAlias )->( OrdListClear() )
            ( ::cAlias )->( DbCloseArea() )
            ( ::cTmpAlias )->( OrdListClear() )
            ( ::cTmpAlias )->( DbCloseArea() )
            ::Protec( 0 )
        endif
    endif

return( Self )

//----------------------------------------------------------------------------//

METHOD End() CLASS TTrn

    ::Close()
    ::nArea := 0

    // Si se va controlar algo mas al cerrar hay que ponerlo aqui

return( Self := nil )

//----------------------------------------------------------------------------//

//------ End of File TTrn.PRG ------------------------------------------------//
//----------------------------------------------------------------------------//