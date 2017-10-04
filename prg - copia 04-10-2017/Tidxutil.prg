//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez   Soft 4U                              //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: General                                                       //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Funciones auxiliares para TIndex                              //
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// Funciones para el manejo de punteros de la DBF con scopes con RDD que no   //
// los soporta directamente                                                   //
//----------------------------------------------------------------------------//

#ifndef __PDA__

// Cuenta el numero de registros reales desde la posicion del puntero hasta
// ::eof o ::bof dependiendo de la direccion. OJO mueve el puntero

function iCounter( _DB_, nSkip )

    local nSkipped := 0

    msgStop( nSkip, "COUNTER" )

    DO CASE
    CASE nSkip > 0
        if _DB_:lScope
            while nSkipped < nSkip .and. eval( _DB_:oIndex:bBottom, _DB_ )
                ( _DB_:nArea )->( DbSkip( 1 ) )
                ++nSkipped
            end
        else
            while nSkipped < nSkip .and. !( _DB_:nArea )->( Eof() )
                ( _DB_:nArea )->( DbSkip( 1 ) )
                ++nSkipped
            end
        endif
    CASE nSkip < 0
        if _DB_:lScope
            while nSkipped > nSkip .and. eval( _DB_:oIndex:bTop, _DB_ )
                ( _DB_:nArea )->( DbSkip( -1 ) )
                --nSkipped
            end
        else
            while nSkipped > nSkip .and. !( _DB_:nArea )->( Bof() )
                ( _DB_:nArea )->( DbSkip( -1 ) )
                --nSkipped
            end
        endif
    END CASE

return( nSkipped )

#endif

//---------------------------------------------------------------------------//
// Devuelve un objeto TIndex con el orden natural "_NONE_"
//
function GetIdxNone( oDbf )

    local oIdxNone := TIndex()

    oIdxNone:oDbf     := oDbf
    oIdxNone:cFile    := ""
    oIdxNone:cName    := "_NONE_"
    oIdxNone:cComment := "NATURAL ORDER _NONE_"
    oIdxNone:cFor     := ".t."
    oIdxNone:cKey     := "RecNo()"
    oIdxNone:bKey     := { || RecNo() }
    oIdxNone:bFor     := { || .t. }
    oIdxNone:bWhile   := { || .t. }
    oIdxNone:bTop     := { || .t. }
    oIdxNone:bBottom  := { || .t. }
    oIdxNone:bRange   := { || .t. }
    oIdxNone:bOption  := { || nil }
    oIdxNone:lScope   := .f.
    oIdxNone:lUniq    := .t.
    oIdxNone:lDes     := .f.
    oIdxNone:nStep    := 0
    oIdxNone:uTop     := NIL
    oIdxNone:uBottom  := NIL
    oIdxNone:Cargo    := NIL

return( oIdxNone )

//---------------------------------------------------------------------------//

function iScpTop( _DB_ )

    ( _DB_:nArea )->( DbSeek( _DB_:oIndex:uTop, .t. ) )

    if !eval( _DB_:oIndex:bBottom, _DB_ )
        ( _DB_:nArea )->( DbGoTo( 0 ) )
        _DB_:Eof := .t.
    endif

return( _DB_ )

//----------------------------------------------------------------------------//

function iScpBottom( _DB_ )

    ( _DB_:nArea )->( DbSeek( NextVal( _DB_:oIndex:uBottom ), .t. ) )
    ( _DB_:nArea )->( DbSkip( -1 ) )

    if !eval( _DB_:oIndex:bBottom, _DB_ )
        ( _DB_:nArea )->( DbGoTo( 0 ) )
        _DB_:Eof := .t.
    endif

return( _DB_ )

//----------------------------------------------------------------------------//