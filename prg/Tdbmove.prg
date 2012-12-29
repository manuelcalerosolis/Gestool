//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez   Soft 4U                              //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TDbMove (TDbf)                                                //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gesti¢n de importaciones y exportaciones SDF o DELIMITED      //
//----------------------------------------------------------------------------//

#include "Obj2Hb.ch"

//----------------------------------------------------------------------------//

REQUEST SDF
REQUEST DELIM

//----------------------------------------------------------------------------//

CLASS TDbMove

    DATA cFile, cType, cName, ;
         cComment, cDelim  AS STRING
    DATA aFields           AS ARRAY
    DATA bFor, bWhile      AS BLOCK
    DATA nNext             AS NUMERIC
    DATA nRec              AS NUMERIC
    DATA lRest             AS LOGICAL
    DATA oDbf              AS OBJECT
    DATA Cargo             AS ALL

    METHOD New( oDbf, cName, cType, cFile, aFields, bFor, ;
                bWhile, nNext, nRec, lRest, cDelim, cComment ) CONSTRUCTOR

    METHOD Import()
    METHOD Export()

    METHOD Destroy()    INLINE ::aField := {}, Self := nil, .t.

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oDbf, cName, cType, cFile, aFields, bFor, ;
            bWhile, nNext, nRec, lRest, cDelim, cComment ) CLASS TDbMove

    if ValType( oDbf ) != "O"
        ::oDbf := DbfServer():Use()
    else
        ::oDbf := oDbf
    endif

    BYNAME cName    DEFAULT oDbf:cName
    BYNAME cType    DEFAULT "SDF"

    if upper( AllTrim( ::cType ) ) != "DELIM"
        ::cType := "SDF"
    endif

    BYNAME cFile    DEFAULT "Temp.txt"
    BYNAME aFields  DEFAULT {}
    BYNAME bFor     DEFAULT { || .t. }
    BYNAME bWhile   DEFAULT { || .t. }
    BYNAME nNext    DEFAULT 0
    BYNAME nRec     DEFAULT 0
    BYNAME lRest    DEFAULT .f.
    BYNAME cDelim   DEFAULT ""
    BYNAME cComment DEFAULT "Import/Export " + Self:cType

return( Self )

//----------------------------------------------------------------------------//
//  Append from ...

METHOD Import() CLASS TDbMove

    local nArea   := 0
    local nRecNo  := 0
    local aStruct := {}
    local lRet    := .f.
    local nNext   := if( ::nNext == 0, nil, ::nNext )
    local nRec    := if( ::nRec  == 0, nil, ::nRec  )
    local oMv := Self

    if ::oDbf:Used()
        nRecNo  := ::oDbf:RecNo()
        aStruct := SubStruct( oMv )
        if __DbOpenSd( ::cFile, aStruct, ::cType, .T., "", ::cDelim )
            nArea:= Select()
            if ::oDbf:nArea != 0
                __dbPass( ::oDbf:nArea, aStruct, ;
                    ::bFor, ::bWhile, nNext, nRec, ::lRest )
                lRet := .t.
            endif
            ( nArea )->( DbCloseArea() )
            ::oDbf:lCount := .t.
            ::oDbf:SetFocus()
            ::oDbf:GoTo( nRecNo )
        endif
    endif

return( lRet )

//----------------------------------------------------------------------------//
// Copy to ...

METHOD Export() CLASS TDbMove

    local nArea   := 0
    local nRecNo  := 0
    local aStruct := {}
    local lRet    := .f.
    local nNext   := if( ::nNext == 0, nil, ::nNext )
    local nRec    := if( ::nRec  == 0, nil, ::nRec  )
    local oMv := Self

    if ::oDbf:Used()
        nRecNo  := ::oDbf:RecNo()
        aStruct := SubStruct( oMv )
        DbCreate( ::cFile, aStruct, ::cType, .T., "", ::cDelim )
        nArea := Select()
        ::oDbf:SetFocus()
        if nArea != ::oDbf:nArea
            __dbPass( nArea, aStruct, ::bFor, ::bWhile, nNext, nRec, ::lRest )
            ( nArea )->( DbCloseArea() )
            lRet := .t.
        endif
        ::oDbf:GoTo( nRecNo )
    endif

return( lRet )

//----------------------------------------------------------------------------//

static function SubStruct( oMv )

    local bFindName := { || .t. }
    local aStruct   := oMv:oDbf:aField()
    local cName     := ""
    local aRStruct  := {}

    if empty( oMv:aFields )
        aRStruct  := oMv:oDbf:aField()
    else
        bFindName := { | aField | aField[ 1 ] == cName }
        aEval( oMv:aFields, { | cFieldName, i | ;
            cName := trim( upper( cFieldName ) ), ;
            i := aScan( aStruct, bFindName ), ;
            if( i == 0, nil, AAdd( aRStruct, aStruct[ i ] ) ) } )
    endif

return( aRStruct )

//---------------------------------------------------------------------------//
