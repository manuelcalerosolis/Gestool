//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez   Soft 4U                              //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TIndex (TDbf)                                                 //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gesti¢n de Indices                                            //
//----------------------------------------------------------------------------//

#ifdef __PDA__
REQUEST DBFCDX
#endif
#include "Obj2Hb.ch"
#include "TDbfMsg.ch"
#include "TDbfVer.ch"

//----------------------------------------------------------------------------//

CLASS TIndex

    DATA cFile, cKey, cFor, cName, cComment AS STRING
    DATA lScope, lDes, lUniq, lTmp, lNoDel  AS LOGICAL
    DATA bRange, bTop, bBottom              AS BLOCK
    DATA bWhile, bOption
    DATA Cargo, uTop, uBottom
    DATA bFor, bKey                         AS BLOCK
    DATA nStep                              AS NUMERIC
    DATA oDbf

    DATA ClsName    AS STRING INIT "TINDEX"

    METHOD New( oDbf, cName, cFile, cKey, cFor, bWhile, lUniq, ;
                lDes, cComment, bOption, nStep, lNoDel, lTmp ) CONSTRUCTOR
    METHOD SetScope( uTop, uBottom )
    METHOD ClearScope()
    METHOD Order()  INLINE ( ::oDbf:nArea )->( OrdNumber( ::cName, ::cFile ) )
    METHOD KeyVal() INLINE ( ::oDbf:nArea )->( OrdKeyVal() )
    METHOD SetCond()
    METHOD Create()
    METHOD IdxExt()
    METHOD SetFocus()
    METHOD Add()    INLINE ( if( ( ::oDbf:cRDD != "ADSCDX" .or. !lAIS() ), ( ::oDbf:nArea )->( OrdListAdd( ::cFile, ::cName ) ), ) )
    MESSAGE Delete() METHOD _Delete()

    METHOD Destroy() INLINE Self := nil, .t.

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oDbf, cName, cFile, cKey, cFor, bWhile, ;
            lUniq, lDes, cComment, bOption, nStep, lNoDel, lTmp ) CLASS TIndex

    BYNAME oDbf

    DEFAULT cComment := ""

    ::cName          := Upper( if( ValType( cName ) == "C", cName, GetFileNoExt( cFile ) ) )
    ::cFile          := ::oDbf:cPath + GetFileName( if( ValType( cFile ) == "C", cFile, cName ) )

    BYNAME lNoDel DEFAULT .t.
    BYNAME lTmp   DEFAULT .f.

    if ValType( cFor ) != "C" .or. Empty( cFor )
        ::cFor       := if( ::lNoDel, "!Deleted()", ".t." )
    else
        ::cFor       := if( ::lNoDel, "!Deleted() .and.", "" ) + Upper( cFor )
    end if

    ::cKey           := Upper( if( ValType( cKey ) != "C", ".T.", cKey ) )

    BYNAME lUniq    DEFAULT Set( _SET_UNIQUE )
    BYNAME lDes     DEFAULT .f.
    BYNAME bWhile
    BYNAME bOption

    ::cComment := cComment
    ::bKey     := c2Block( ::cKey )
    ::bFor     := c2Block( ::cFor )

    ::bTop     := { || .t. }
    ::bBottom  := { || .t. }
    ::bRange   := { || .t. }

    ::uTop     := ::uBottom := nil

    ::lScope   := .f.

    if ValType( nStep ) != "N"
         nStep := if( ValType( bOption ) != "B", 100000000, 0 )
    endif

    BYNAME nStep

return( Self )

//----------------------------------------------------------------------------//

METHOD SetCond() CLASS TIndex

return( ( ::oDbf:nArea )->( OrdCondSet( ::cFor, ::bFor,, ::bWhile, ::bOption, ::nStep, RecNo(), .f., , , ::lDes ) ) )

//----------------------------------------------------------------------------//

METHOD Create() CLASS TIndex

    ::SetCond()

    ( ::oDbf:nArea )->( OrdCreate( ::cFile, ::cName, ::cKey, ::bKey, ::lUniq ) )

return( Self )

//----------------------------------------------------------------------------//
// Calcula el fichero con extension si no la lleva.
// Se hace aqui y no en NEW para que este la DBF abierta

METHOD IdxExt() CLASS TIndex
return( ::cFile := if( AT( ".", GetFileName( ::cFile ) ) > 0, ::cFile, ::cFile + ( ::oDbf:nArea )->( OrdBagExt() ) ) )

//----------------------------------------------------------------------------//

METHOD _Delete() CLASS TIndex

    if ::oDbf:cRdd $ idMULTITAG
        ( ::oDbf:nArea )->( OrdDestroy( ::cName, ::cFile ) )
    else
        FErase( ::cFile )
    endif

return( Self := nil )

//----------------------------------------------------------------------------//
// Controla lDescending

METHOD SetScope( uTop, uBottom ) CLASS TIndex

    if ::lDes
        if ::lScope := ( uBottom <= uTop )
            ::bTop    := ;
                { | o | !( o:nArea )->( Bof() ) .and. ::KeyVal() <= uTop }
            ::bBottom := ;
                { | o | !( o:nArea )->( Eof() ) .and. ::KeyVal() >= uBottom }
            ::bRange  := ;
                { | x | x := ::KeyVal(), x <= uTop .and. x >= uBottom }
        endif
    else
        if ::lScope := ( uTop <= uBottom  )
            ::bTop    := ;
                { | o | !( o:nArea )->( Bof() ) .and. ::KeyVal() >= uTop }
            ::bBottom := ;
                { | o | !( o:nArea )->( Eof() ) .and. ::KeyVal() <= uBottom }
            ::bRange  := ;
                { | x | x := ::KeyVal(), x >= uTop .and. x <= uBottom }
        endif
    endif

    if ::lScope
        ::uTop    := uTop
        ::uBottom := uBottom
    else
        ::oDbf:DbError( dbSCPRANG )
    endif

return( ::lScope )

//----------------------------------------------------------------------------//

METHOD ClearScope() CLASS TIndex

    ::uTop := ::uBottom := nil

    ::bTop    := { || .t. }
    ::bBottom := { || .t. }
    ::bRange  := { || .t. }

    ::lScope := .f.

return( Self )

//----------------------------------------------------------------------------//

METHOD SetFocus() CLASS TIndex

    local nOrder := 0

    if ::cName != "_NONE_"
        nOrder := ::Order()
        ( ::oDbf:nArea )->( OrdSetFocus( nOrder, ::cFile ) )
    else
        ( ::oDbf:nArea )->( OrdSetFocus( 0 ) )
    endif

return( ::oDbf:oIndex := Self )

//----------------------------------------------------------------------------//
//------ End of File TIndex.PRG-----------------------------------------------//
//----------------------------------------------------------------------------//











































