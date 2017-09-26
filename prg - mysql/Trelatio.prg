//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez  Soft 4U                               //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TRelation (TDbf)                                              //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gesti¢n de Relaciones                                         //
//----------------------------------------------------------------------------//

#include "Obj2Hb.ch"

//----------------------------------------------------------------------------//

CLASS TRelation

    DATA cLink                      AS STRING
    DATA bLink, bTrigger            AS BLOCK
    DATA oDbChild                   AS OBJECT
    DATA lLoad, lCanDelete, ;
         lCanTrigger                AS LOGICAL
    DATA cName, cComment            AS STRING
    DATA nOrder                     AS NUMERIC
    DATA Cargo                      AS ALL
    DATA oDbf                       AS OBJECT

    METHOD New( oDbf, cName, cLink, bLink, oDbChild, ;
              cComment, lCanDelete, lCanTrigger, bTrigger  ) CONSTRUCTOR
    MESSAGE Delete()  METHOD _Delete()
    METHOD Sync()
    METHOD Trigger()

    METHOD Destroy()    INLINE Self := nil, .t.

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oDbf, cName, cLink, bLink, oDbChild, cComment, ;
            lCanDelete, lCanTrigger, bTrigger, lLoad ) CLASS TRelation

   static nRel := 0

   ::nOrder := ++nRel

   BYNAME oDbf
   BYNAME oDbChild
   BYNAME cName         DEFAULT "Rel" + PadL( ::nOrder, 5, "0" )
   BYNAME cLink         DEFAULT ""
   BYNAME bLink         DEFAULT c2Block( ::cLink )
   BYNAME cComment      DEFAULT Self:cLink
   BYNAME lCanDelete    DEFAULT .f.
   BYNAME lCanTrigger   DEFAULT .f.
   BYNAME bTrigger      DEFAULT { || .t. }
   BYNAME lLoad         DEFAULT .t.

return( Self )

//----------------------------------------------------------------------------//

METHOD Sync() CLASS TRelation

    local lRet := ::oDbChild:Seek( eval( ::bLink ), .f. )

    //if( ::lLoad, ::oDbChild:QLoad(), )

return( lRet )

//----------------------------------------------------------------------------//

METHOD Trigger() CLASS TRelation

    local xVal
    local nRec := 0

    if ::Sync() .and. ::lCanTrigger
        nRec := ::oDbChild:RecNo()
        xVal := eval( ::bLink )
        while !::oDbChild:Eof() .and. ::oDbChild:IdxKeyVal() == xVal
            eval( ::bTrigger, ::oDbChild )
            ::oDbChild:Skip()//:QLoad()
        end
        ::oDbChild:GoTo( nRec )
    endif

return( Self )

//----------------------------------------------------------------------------//

METHOD _Delete() CLASS TRelation

    local xVal
    local nRec := 0

    if ::Sync() .and. ::lCanDelete
        xVal := eval( ::bLink )
        nRec := ::oDbChild:RecNo()
        while ::oDbChild:Seek( xVal, .f. ) .and. !::oDbChild:Deleted()
            if (::oDbChild:nArea)->( dbRLock() )
                (::oDbChild:nArea)->( DbDelete() )
                (::oDbChild:nArea)->( DbUnLock() )
            endif
            (::oDbChild:nArea)->( DbSkip() )
        end
        ::oDbChild:GoTo( nRec )
    endif

return( Self )

//----------------------------------------------------------------------------//