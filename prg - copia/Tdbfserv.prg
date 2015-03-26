//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '1994-2001                  //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: DbfServer                                                     //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Genera una clase particular por DBF controlando duplicidades  //
//----------------------------------------------------------------------------//

#ifndef __PDA__
   #include "Obj2Hb.ch"
#endif

//----------------------------------------------------------------------------//

#ifndef __PDA__

static __ahTDbf := {}

//----------------------------------------------------------------------------//
//Funciones del programa normal
//----------------------------------------------------------------------------//

function DbAt( DbCls )

    local nRet := 0

    if ValType( DbCls ) == "C"
        DbCls := upper( DbCls )
        nRet := AScan( __ahTDbf, { | aClass | aClass[ 1 ] == DbCls } )
    endif

return( nRet )

//----------------------------------------------------------------------------//

function lDbClass( DbCls ) ; return( DbAt( DbCls ) > 0 )

//----------------------------------------------------------------------------//

function ADbClass() ; return( __ahTDbf )

//----------------------------------------------------------------------------//

function nInsDbClass( DbCls )

    local nAt  := DbAt( DbCls )

return( if( nAt > 0, __ahTDbf[ nAt, 3 ], 0 ) )

//----------------------------------------------------------------------------//

function InitDbClass()

    __ahTDbf := {}

return ( nil )

//----------------------------------------------------------------------------//
//Funciones del programa y del pda
//----------------------------------------------------------------------------//

function DbfServer( cFile, DbClass )

    local __nClassH := 0
    local __oDb

    cFile   := if( ValType( cFile )   != "C", Alias() + ".DBF", cFile )
    DbClass := if( ValType( DbClass ) != "C", "T" + GetFileNoExt( cFile ), DbClass )
    DbClass := upper( DbClass )

    EXTERNAL TDbf
    _HB_CLASS DbClass

    __oDb := HbClass():New( DbClass, "TDBF" ) // __CLS_PARAM ( "TDBF" ) )
    __oDb:Create()
    __nClassH := __oDb:hClass

return( __clsInst( __nClassH ) )

//----------------------------------------------------------------------------//

#else

function DbfServer( cFile, DbClass )
return( TDbf() )

#endif
