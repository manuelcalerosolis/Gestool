//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez   Soft 4U                              //
//  e-Mail....: expo2001@wanadoo.es                                           //
//  CLASE.....: TFilter (TDbf)                                                //
//  FECHA MOD.: 17/04/2002                                                    //
//  VERSION...: 12.00                                                         //
//  PROPOSITO.: Gesti¢n de Filtros                                            //
//----------------------------------------------------------------------------//

#include "Obj2Hb.ch"
#include "TDbfMsg.ch"

//----------------------------------------------------------------------------//

CLASS TFilter

    DATA cName, ;
         cFor,  ;
         cComment AS STRING
    DATA bFor     AS BLOCK
    DATA oDbf     AS OBJECT
    DATA Cargo    AS ALL

    METHOD New( oDbf, cName, bFor, cFor, cComment ) CONSTRUCTOR
    METHOD SetFocus()

    METHOD Destroy  INLINE Self := nil, .t.

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oDbf, cName, bFor, cFor, cComment ) CLASS TFilter

    local oFlt := Self

    ::oDbf := oDbf

    BYNAME cFor     DEFAULT ""
    BYNAME bFor     DEFAULT &("{ || " + oFlt:cFor + " }")

    ::cName := upper( if( ValType( cName ) != "C", cFor, cName ) )

    BYNAME cComment DEFAULT Self:cName + " / " + Self:cFor

return( Self )

//----------------------------------------------------------------------------//

METHOD SetFocus() CLASS TFilter

    local oFlt := Self

    ( ::oDbf:nArea )->( DbSetFilter( ::bFor, ::cFor ) )

    ::oDbf:lCount  := .t.
    ::oDbf:oFilter := oFlt

return( Self )

//----------------------------------------------------------------------------//