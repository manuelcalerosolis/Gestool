//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez   Soft 4U                              //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TDict ( TDbf )                                                //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gesti¢n y control de objetos TDbf                             //
//----------------------------------------------------------------------------//

#include "Obj2Hb.ch"
#include "TDbfVer.ch"

CLASS TDict

    DATA lRecycle, lShared, lReadOnly, ;
         lProtec, lBuffer               AS LOGICAL
    DATA cRDD, cPath, cComment, cName   AS STRING
    DATA aTDbf                          AS ARRAY
    DATA nDbfCount                      AS NUMERIC
    DATA oDbf                           AS OBJECT
    DATA Cargo                          AS ALL

    METHOD New( cRDD, cPath, cComment, ;
                lRecycle, lShared, lReadOnly, lProtec ) CONSTRUCTOR
    METHOD Activate( oDb )
    METHOD Create( oDb )
    METHOD AddDbf( oDb, lRecycle, lShared, lReadOnly, lProtec )
    METHOD CreateIndex( oDb )
    METHOD SetFocus( oDb )
    METHOD ReIndex( oDb )
    METHOD DbfByName( cnId )
    METHOD cDbfByName( cName )
    METHOD Close( oDb )
    METHOD End( oDb )

    METHOD Destroy() INLINE ::End(), ::oDbf := nil, Self := nil, .t.

ENDCLASS

//----------------------------------------------------------------------------//
//

METHOD New( cRDD, cPath, lRecycle, ;
            lShared, lReadOnly, lProtec, lBuffer, cComment ) CLASS TDict

  ::aTDbf := {}
  ::cRDD  := upper( if( ValType( cRDD ) != "C", RDDSetDefault(), cRDD ) )

  cPath := if( !empty( cPath ), cPath, Set( _SET_DEFAULT ) )
  cPath := if( empty( cPath ), ".\", cPath )

  ::cPath := upper( if( right( cPath, 1 ) != "\", cPath += "\", cPath ) )

  BYNAME lRecycle  DEFAULT .t.
  BYNAME lReadOnly DEFAULT .f.
  BYNAME lShared   DEFAULT !set( _SET_EXCLUSIVE )
  BYNAME lProtec   DEFAULT .f.
  BYNAME lBuffer   DEFAULT .f.
  BYNAME cComment  DEFAULT "Data dictionary " + Self:cPath

return( Self )

//----------------------------------------------------------------------------//

METHOD AddDbf( oDb, cRecycle, lShared, lReadOnly, cProtec, lBuffer ) CLASS TDict

    local nIndex := len( oDb:aTIndex )
    local n      := 0

    DEFAULT cRecycle := if( ::lRecycle, "RECYCLE", "NORECYCLE" )
    oDb:lRecycle := if( upper( cRecycle )  == "NORECYCLE", .f., .t. )

    DEFAULT cProtec := if( ::lProtec, "PROTEC", "NOPROTEC" )
    oDb:lProtec := if( upper( cProtec )  == "PROTEC", .t., .f. )

    oDb:lShared   := if( ValType( lShared )   != "L", ::lShared,   lShared )
    oDb:lReadOnly := if( ValType( lReadOnly ) != "L", ::lReadOnly, lReadOnly )
    oDb:lBuffer   := if( ValType( lBuffer )   != "L", ::lBuffer,   lBuffer )

    if empty( oDb:cPath ) .or. oDb:cPath == ".\"
        oDb:cPath := ::cPath
        oDb:cFile := ::cPath + GetFileName( oDb:cFile )
    endif

    oDb:cRDD := if( empty( oDb:cRDD ), ::cRDD, oDb:cRDD )
    oDb:cComment := if( empty( oDb:cComment ), ::cComment + " " + ;
                                               oDb:cFile, oDb:cComment )

    if nIndex > 0
        FOR n := 1 TO nIndex
            oDb:aTIndex[ n ]:cFile := ;
                oDb:cPath + GetFileName( oDb:aTIndex[ n ]:cFile )
        NEXT
    endif

    AAdd( ::aTDbf, oDb )

    ++::nDbfCount

return( Self )

//----------------------------------------------------------------------------//

METHOD Activate( oDb ) CLASS TDict

    local lAutoField := .f.
    local lAutoIndex := .f.
    local lOpen      := .f.
    local lNewArea   := .t.
    local n          := 0

    if ValType( oDb ) != "O"
        FOR n := 1 TO ::nDbfCount
            oDb := ::aTDbf[ n ]
            if oDb:nType            == idNEWOPEN        // NewOpen
                lAutoField := .t.
                lAutoIndex := .t.
                lOpen      := .f.
                lNewArea   := .t.
            elseif oDb:nType        == idUSE           // Use
                lAutoField := .t.
                lAutoIndex := .t.
                lOpen      := .t.
                lNewArea   := .f.
            else                 // == idNORMAL        // Tradicional TDbf
                lAutoField := .f.
                lAutoIndex := .f.
                lOpen      := .f.
                lNewArea   := .t.
            endif
            oDb:Activate( oDb:lRecycle, oDb:lShared, oDb:lReadOnly, ;
                          oDb:lProtec, lAutoField, lAutoIndex, lOpen, lNewArea )
            oDb:SetBuffer( if( !oDb:lBuffer, ::lBuffer, .f. ) )
        NEXT
        oDb := ::aTDbf[ 1 ] // Para ponerle el foco
    else
            if oDb:nType            == idNEWOPEN    // NewOpen
                lAutoField := .t.
                lAutoIndex := .t.
                lOpen      := .f.
                lNewArea   := .t.
            elseif oDb:nType        == idUSE        // Use
                lAutoField := .t.
                lAutoIndex := .t.
                lOpen      := .t.
                lNewArea   := .f.
            else                 // == idNORMAL     // Tradicional TDbf
                lAutoField := .f.
                lAutoIndex := .f.
                lOpen      := .f.
                lNewArea   := .t.
            endif
            oDb:Activate( oDb:lRecycle, oDb:lShared, oDb:lReadOnly, ;
                          oDb:lProtec, lAutoField, lAutoIndex, lOpen, lNewArea )
            oDb:SetBuffer( if( !oDb:lBuffer, ::lBuffer, .f. ) )
    endif

    ::SetFocus( oDb )

return( Self )

//----------------------------------------------------------------------------//

METHOD Create( oDb ) CLASS TDict

    if( ValType( oDb ) != "O", ;
        AEval( ::aTDbf, { |oDb| oDb:Create() } ), oDb:Create() )

return( Self )

//----------------------------------------------------------------------------//

METHOD CreateIndex( oDb ) CLASS TDict

    if ValType( oDb ) != "O"
        AEval( ::aTDbf, { |oDb| oDb:IdxFDel(), oDb:IdxFCheck() } )
    else
        oDb:IdxFDel()
        oDb:IdxFCheck()
    endif

return( Self )

//----------------------------------------------------------------------------//

METHOD ReIndex( oDb ) CLASS TDict

    if( ValType( oDb ) != "O" , ;
        AEval( ::aTDbf, { |oDb| oDb:ReIndexAll() } ), oDb:ReIndexAll() )

return( Self )

//----------------------------------------------------------------------------//

METHOD DbfByName( cnId ) CLASS TDict

    local oDb := nil
    local n   := 0

    if ValType( cnId ) != "N"
        cnId := Select( cnId )
    endif

    FOR n := 1 TO ::nDbfCount
        if ::aTDbf[ n ]:nArea == cnId
            oDb := ::aTDbf[ n ]
            EXIT
        endif
    NEXT

return( oDb )

//----------------------------------------------------------------------------//

METHOD cDbfByName( cName ) CLASS TDict

    local oDb := nil
    local n   := 0

    if ValType( cName ) == "C"
        cName := Upper( cName )
        FOR n := 1 TO ::nDbfCount
            if upper( ::aTDbf[ n ]:cName ) == cName
                oDb := oClone( ::aTDbf[ n ] )
                EXIT
            endif
        NEXT
    endif

return( oDb )

//----------------------------------------------------------------------------//

METHOD SetFocus( oDb ) CLASS TDict

    ::oDbf := if( ValType( oDb ) == "O", oDb, ::DbfByName( oDb ) )

return( ::oDbf:SetFocus() )

//----------------------------------------------------------------------------//

METHOD Close( oDb ) CLASS TDict

    if( ValType( oDb ) != "O", ;
        AEval( ::aTDbf, { |oDb| oDb:Close() } ), oDb:Close() )

return( Self )

//----------------------------------------------------------------------------//

METHOD End( oDb ) CLASS TDict

    local nDb := 0

    if ValType( oDb ) != "O"
        AEval( ::aTDbf, { |oDb| oDb:End() } )
        ::aTDbf := {}
    else
        nDb := Ascan( ::aTDbf, { |oDb| oDb:nArea == oDb:nArea } )
        oDb:End()
        ADel( ::aTDbf, nDb )
        ASize( ::aTDbf, ::nDbfCount - 1 )
    endif

return( Self := nil )

//----------------------------------------------------------------------------//