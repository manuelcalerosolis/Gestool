//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '1994-2001                  //
//  e-Mail....: expo2001@wanadoo.es                                           //
//  CLASE.....: TDbArray                                                      //
//  FECHA MOD.: 17/04/2002                                                    //
//  VERSION...: 12.00                                                         //
//  PROPOSITO.: Gesti¢n se array como DBFs (DBF virtuales)                    //
//----------------------------------------------------------------------------//

#include "Obj2Hb.ch"

// De DbStruct.ch

#define DBS_NAME 1
#define DBS_TYPE 2
#define DBS_LEN  3
#define DBS_DEC  4
#define DBS_DEF  5

//---------------------------------------------------------------------------//

static __aTDbV := {}

//----------------------------------------------------------------------------//

CLASS TDbArray

    DATA aFields,   ;
         aRecords,  ;
         aStatus,   ;
         aBlank         AS ARRAY

    DATA Eof,       ;
         Bof,       ;
         Used           AS LOGICAL

    DATA cAlias,    ;
         cComment       AS CHARACTER

    DATA nRecIni,   ;
         RecNo,     ;
         LastRec,   ;
         nArea,     ;
         FCount         AS NUMERIC

    METHOD  New( cAlias, aRecords, lDatas, cComment ) CONSTRUCTOR

    METHOD  DefNew( cComment ) CONSTRUCTOR
    METHOD  AddField( cName, cType, nLen, nDec )
    METHOD  Activate()
    METHOD  DbLink( xWorkArea ) INLINE ::nArea := xArea( xWorkArea )

    METHOD  Append()
    METHOD  Update( aVal )
    METHOD  Insert( aVal )  INLINE ::Append():Update( aVal )

    MESSAGE Delete()        METHOD _Delete()

    METHOD  GoTo( n )
    METHOD  GoTop()         INLINE ::GoTo( 1 ), Self
    METHOD  GoBottom()      INLINE ::GoTo( ::LastRec ), Self

    METHOD  Skip( n )
    METHOD  Skipper( n )

    METHOD  Record()        INLINE ::aRecords[ ::RecNo ]
    METHOD  RecCount()      INLINE len( ::aRecords )

    METHOD  Eval( bBlock )  INLINE AEval( ::aRecords, bBlock )
    METHOD  SetBrowse( oBrw )

    METHOD  Load( bFor, bWhile )
    METHOD  RecLoad( nRec, lNew )

    METHOD  Save()
    METHOD  RecSave( nRec )

    METHOD  Clean()         INLINE ::aRecords := aSize( ::aRecords, 1 ), ::RecNo := 1, ::Update( ::aBlank ), ::Eof := .f., ::Bof := .f., ::nRecIni := 1, ::LastRec := 1

    METHOD  Syncronize()    INLINE ( ::nArea )->( DbGoto( ::nRecIni ) ), Self

    METHOD  FieldGet( nFld )       INLINE if( ::RecNo == 0 .or. ::RecNo > ::RecCount(), ::FieldDef( nFld ), ::aRecords[ ::RecNo, nFld ] )
    METHOD  FieldPut( nFld, Val )  INLINE ::aRecords[ ::RecNo, nFld ] := Val
    METHOD  FieldPos( cName )

    METHOD  FieldName( nFld ) INLINE ::aFields[ nFld, DBS_NAME ]
    METHOD  FieldType( nFld ) INLINE ::aFields[ nFld, DBS_TYPE ]
    METHOD  FieldLen( nFld )  INLINE ::aFields[ nFld, DBS_LEN  ]
    METHOD  FieldDec( nFld )  INLINE ::aFields[ nFld, DBS_DEC  ]
    METHOD  FieldDef( nFld )  INLINE ::aFields[ nFld, DBS_DEF  ]

    METHOD  DbCore( cFileName, lNew )   // if lNew, crear, incluir

    METHOD  Clone( lNew )  VIRTUAL  // Hacerlo

    METHOD  Destroy()

    /*
    Nuevas por manuel calero
    */

    METHOD  OrdKeyNo()             INLINE ( ::RecNo )
    METHOD  LoadArray( aArray )
    METHOD  Seek( xVal, nField )
    METHOD  GetStatus()
    METHOD  SetStatus()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( cAlias, aRecords, lDatas, cComment ) CLASS TDbArray

    local i     := 0
    local nLen  := 0
    local nRec  := 0
    local cName := ""

    DEFAULT lDatas := .f.

    ::nArea := xArea( cAlias )

// Se supone que aRecords tiene la misma estructura que el record de la DBF

#ifdef __C3__
    ::aRecords := if( ValType( aRecords ) != "A", {}, __objClone( aRecords ) )
#else
    ::aRecords := if( ValType( aRecords ) != "A", {}, oClone( aRecords ) )
#endif

    ::cAlias   := "ARRAY"
    ::Eof      := .f.
    ::Bof      := .f.
    ::RecNo    := 0
    ::nRecIni  := 1
    ::cComment := if( ValType( cComment ) == "C", cComment, ::cAlias )

    if ::Used := ( ::nArea > 0 )
        ::aFields := ( ::nArea )->( DbStruct() )
        // Carga el registro fantasma
        nRec := ( ::nArea )->( RecNo() )
        nLen := ( ::nArea )->( FCount() )
        ( ::nArea )->( DbGoTo( 0 ) )
        ::aBlank := {}
        if lDatas       // Si tiene que crear dataFields
            FOR i := 1 TO nLen
                cName := ( ::nArea )->( FieldName( i ) )
                AAdd( ::aBlank, ( ::nArea )->( FieldGet( i ) ) )
                GenData( Self, cName, i, ::FieldType( i ) )
            NEXT
        else
            FOR i := 1 TO nLen
                AAdd( ::aBlank, ( ::nArea )->( FieldGet( i ) ) )
            NEXT
        endif
        ::FCount := len( ::aBlank )
        ( ::nArea )->( DbGoTo( nRec ) )
    endif


    /*
    Hay q tener al menos un registro-------------------------------------------

    if ValType( ::aRecords ) != "A" .or. len( ::aRecords ) == 0
       aRec := {}
       FOR i := 1 TO nLen
          AAdd( aRec, ( ::nArea )->( FieldGet( i ) ) )
       NEXT
       AAdd( ::aRecords, aRec )
    end if
    */

return( Self )

//---------------------------------------------------------------------------//

METHOD DefNew( cComment ) CLASS TDbArray

    ::cAlias   := "ARRAY"
    ::nArea    := 0
    ::RecNo    := 0
    ::nRecIni  := 1
    ::LastRec  := 0
    ::FCount   := 0
    ::aFields  := {}
    ::aRecords := {}
    ::aBlank   := {}
    ::Eof      := .f.
    ::Bof      := .f.
    ::Used     := .f.
    ::cComment := if( ValType( cComment ) == "C", cComment, ::cAlias )

return( Self )

//---------------------------------------------------------------------------//

METHOD AddField( cName, cType, nLen, nDec, DefaultVal ) CLASS TDbArray

    local aRow := {}

    cName := upper( cName )
    cType := upper( cType )

    /*
    Nuevo por manuel calero
    */

    do case
      case cType == "C"
         DefaultVal := Space( nLen )
      case cType == "N"
         DefaultVal := 0
      case cType == "L"
         DefaultVal := .f.
      case cType == "D"
         DefaultVal := Ctod( "" )
    end case

    AAdd( aRow, cName )
    AAdd( aRow, upper( cType ) )
    AAdd( aRow, nLen )
    AAdd( aRow, nDec )
    AAdd( aRow, DefaultVal )

    AAdd( ::aFields, aRow )

return( aRow )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TDbArray

    local xVal
    local nFld := 0
    local cType := "C"
    local nCount := ::FCount := len( ::aFields )

    FOR nFld := 1 TO nCount

        cType := ::FieldType( nFld )

        DEFAULT Self:aFields[ nFld, DBS_LEN  ] := 10
        DEFAULT Self:aFields[ nFld, DBS_DEC ]  := 0

        DO CASE

           CASE cType == 'C'
                xVal := space( ::FieldLen( nFld ) )

           CASE cType  == "N"
                xVal  := replicate( "0", ::FieldLen( nFld ) )
                if ::FieldDec( nFld ) > 0
                  xVal := Stuff( xVal, ;
                               ( ::FieldLen( nFld ) - ::FieldDec( nFld ) ), 1, '.' )
                endif
                xVal := Val( xVal )

           CASE cType == 'L'
                xVal := .f.
                ::aFields[ nFld, DBS_LEN ] := 1
                ::aFields[ nFld, DBS_DEC ] := 0

           CASE cType == 'D'
                xVal  := CToD( "" )
                ::aFields[ nFld, DBS_LEN ] := 8
                ::aFields[ nFld, DBS_DEC ] := 0

           CASE cType == 'M'
                xVal := space( 10 )
                ::aFields[ nFld, DBS_LEN ] := 10
                ::aFields[ nFld, DBS_DEC ] := 0

        ENDCASE

        AAdd( ::aBlank, xVal )
        GenData( Self, ::FieldName( nFld ), nFld, aType( cType ) )
    NEXT

return( Self )

//---------------------------------------------------------------------------//

METHOD GoTo( n ) CLASS TDbArray

    local nRec := ::RecNo

    if ValType( n ) == "N" .and. n > 0
        ::Eof := .f.
        ::Bof := .f.
        if n > ::LastRec
            ::RecNo := ::LastRec
            ::Eof := .t.
        else
            ::RecNo := n
        endif
    endif

return( nRec )

//---------------------------------------------------------------------------//

METHOD _Delete() CLASS TDbArray

    ADel( ::aRecords, ::RecNo )
    ASize( ::aRecords, --::LastRec )

    ::GoTo( ::RecNo )

return( Self )

//---------------------------------------------------------------------------//

METHOD Update( aVal ) CLASS TDbArray

    local lRet := .f.

    if ValType( aVal ) == "A"
        //aSize( aVal )
        AEval( ::aRecords[ ::RecNo ], { | v, i | v := aVal[ i ] } )
        lRet := .t.
    endif

return( lRet )

//---------------------------------------------------------------------------//

METHOD Append() CLASS TDbArray

    AAdd( ::aRecords, AClone( ::aBlank ) )
    ::RecNo := ++::LastRec
    ::Eof := ::Bof := .f.

return( Self )

//---------------------------------------------------------------------------//

METHOD Skip( n ) CLASS TDbArray

    local nPos := 0

    DEFAULT n := 1

    ::Eof := ::Bof := .f.

    if ValType( n ) == "N"
        nPos := ::RecNo + n
        if nPos > ::LastRec
            ::GoBottom()
            ::Eof := .t.
        elseif nPos < 1
            ::GoTop()
            ::Bof := .t.
        else
            ::RecNo := nPos
        endif
    endif

return( Self )

//---------------------------------------------------------------------------//

METHOD Skipper( nSkip ) CLASS TDbArray

    local nSkipped := 0

    nSkipped := Min( Max( nSkip, 1 - ::RecNo ), ::LastRec - ::RecNo )

    ::RecNo += nSkipped

return( nSkipped )

//---------------------------------------------------------------------------//

METHOD SetBrowse( oBrw )

    if upper( oBrw:ClassName() ) $ "TBROWSE TDBBRW"    // Del DOS y Harbour
        oBrw:goTopBlock    := { || ::GoTop() }
        oBrw:goBottomBlock := { || ::GoBottom() }
        oBrw:SkipBlock     := { | n | ::Skipper( n ) }
    elseif upper( oBrw:ClassName() ) $ "TWBROWSE TCBROWSE TGRID" // De FW y FWH
        oBrw:bGoTop    := { || ::GoTop() }
        oBrw:bGoBottom := { || ::GoBottom() }
        oBrw:bSkip     := { | n | ::Skipper( n ) }
        oBrw:bLogicLen := { || ::LastRec }
        oBrw:bLogicPos := { || ::Recno }                          // mcs
        oBrw:Refresh()
    endif

return( oBrw )

//---------------------------------------------------------------------------//

METHOD Load( bFor, bWhile ) CLASS TDbArray

    local i    := 0
    local aRec := {}
    local nLen := ::FCount

    ::nRecIni := ( ::nArea )->( RecNo() )

    bFor   := if( ValType( bFor )   != "B", { || .t. },    bFor )
    bWhile := if( ValType( bWhile ) != "B", ;
                        { |o| !( o:nArea )->( Eof() ) }, bWhile )

    while eval( bWhile, Self )
        if eval( bFor, Self )
            aRec := {}
            FOR i := 1 TO nLen
                AAdd( aRec, ( ::nArea )->( FieldGet( i ) ) )
            NEXT
            AAdd( ::aRecords, aRec )
        endif
        ( ::nArea )->( DbSkip( 1 ) )
    end

    /*
    Hay q tener al menos un registro
    */

    if ValType( ::aRecords ) != "A" .or. len( ::aRecords ) == 0
       aRec := {}
       FOR i := 1 TO nLen
          AAdd( aRec, ( ::nArea )->( FieldGet( i ) ) )
       NEXT
       AAdd( ::aRecords, aRec )
    end if

    ::Syncronize()

    ::RecNo := 1
    ::Eof := ::Bof := ( ( ::LastRec := ::RecCount() ) == 0 )

return( Self )

//---------------------------------------------------------------------------//

METHOD  FieldPos( cName ) CLASS TDbArray
return( AScan( ::aFields, { | aRow | aRow[ DBS_NAME ] == upper( cName ) } ) )

//---------------------------------------------------------------------------//

METHOD RecLoad( nRec, lAdd ) CLASS TDbArray

    local i    := 0
    local aRec := {}
    local nLen := ( ::nArea )->( FCount() )

    DEFAULT nRec := ( ::nArea )->( RecNo() )
    DEFAULT lAdd := .f.

    ( ::nArea )->( DbGoto( nRec ) )

    aRec := {}
    FOR i := 1 TO nLen
        AAdd( aRec, ( ::nArea )->( FieldGet( i ) ) )
    NEXT

    if( lAdd, AAdd( ::aRecords, aRec ), ::Update( aRec ) )

return( Self )

//---------------------------------------------------------------------------//

METHOD Save( lAppend, bFor ) CLASS TDbArray

    local i    := 0
    local nRec := ::FCount

    bFor := if( ValType( bFor ) != "B", { || .t. }, bFor )
    lAppend := if( ValType( lAppend ) != "L", .t., lAppend )

    if lAppend
        while !::Eof()
            if eval( bFor )
                ( ::nArea )->( DbAppend() )
                FOR i := 1 TO nRec
                    ( ::nArea )->( FieldPut( i, ::FieldGet( i ) ) )
                NEXT
                ( ::nArea )->( DbCommit() )
            endif
            ::Skip( 1 )
        end
    else
        ::Syncronize()
        while !::Eof()
            if eval( bFor )
                ( ::nArea )->( DbSkip( 1 ) )
                ( ::nArea )->( if( Eof(), DbAppend(), ) )
                FOR i := 1 TO nRec
                    ( ::nArea )->( FieldPut( i, ::FieldGet( i ) ) )
                NEXT
                ( ::nArea )->( DbCommit() )
            endif
            ::Skip( 1 )
        end
    endif

return( Self )

//---------------------------------------------------------------------------//

METHOD RecSave( nRec ) CLASS TDbArray

    local i    := 0
    local nLen := ::FCount
    local nAct := ( ::nArea )->( RecNo() )

    nRec := if( ValType( nRec ) != "N", nAct, nRec )

    ( ::nArea )->( DbGoTo( nRec ) )
    ( ::nArea )->( if( Eof(), DbAppend(), ) )

    FOR i := 1 TO nLen
        FieldPut( i, ::FieldGet( i ) )
    NEXT

    ( ::nArea )->( DbGoto( nAct ) )

return( Self )

//---------------------------------------------------------------------------//

METHOD DbCore( cFileName, lOpen ) CLASS TDbArray

    local lRet := .f.
    local Area := 0

    if ValType( cFileName ) == "C"
        lOpen := if( ValType( lOpen ) == "L", lOpen, .f. )
        Area := Select()
        DbCreate( cFileName, ::aFields )
        DbUseArea( .t.,, cFileName )
        ::nArea := Select()
        ::GoTop()
        ::Save( .t. )
        if( !lOpen, ( ::nArea )->( DbCloseArea() ), )
        if( Area > 0, DbSelectArea( Area ), )
        lRet := .t.
    endif


return( lRet )

//---------------------------------------------------------------------------//

METHOD Destroy() CLASS TDbArray

    ::aRecords := {}
    ::aBlank   := {}
    ::aFields  := {}

    Self       := nil

return( .t. )

//---------------------------------------------------------------------------//

function TDbVirtual( cAlias, cClassName )

    local n      := 0
    local hCls   := 0
    local TVCls  := upper( "T" + if( empty( cClassName ), ;
                                   Alias( xArea( cAlias ) ), cClassName ) )

#ifdef __C3__
    local __oDb
#endif
    if ( n := AScan( __aTDbV, { |aClass| aClass[ 1 ] == TVCls } ) ) == 0
#ifdef __C3__
        _HB_CLASS TVCls
        __oDb := HbClass():New( TVCls, __CLS_PARAM ( "TDBARRAY" ) )
        __oDb:Create()
        hCls := __oDb:hClass
#else
        hCls := _ObjNewCls( TVCls, TDbArray() )
#endif
        AAdd( __aTDbV, { TVCls, hCls, 1 } )
    else
        ++__aTDbV[ n, 3 ]
        hCls := __aTDbV[ n, 2 ]
    endif
#ifdef __C3__
    return( __clsInst( hCls ) )
#else
    return( _ObjClsIns( hCls ) )
#endif

//---------------------------------------------------------------------------//

static function GenData( o, cName, i, aType )

#ifdef __C3__
    __clsAddMsg( o:ClassH, cName, ;
        { | o | o:aRecords[ o:RecNo, i ] }, HB_OO_MSG_INLINE )
    __clsAddMsg( o:ClassH, "_" + cName, ;
        { | o, Val | o:aRecords[ o:RecNo, i ] := Val }, HB_OO_MSG_INLINE )
#else
    _ObjAddMet( o:ClassHandle(), NIL, aType, 3, cName, ;
        &( "{ | o | o:FieldGet( " + Str( i, 3 ) + " ) }" ) )
    _ObjAddMet( o:ClassHandle(), NIL, aType, 3, "_" + cName, ;
        &( "{ | o, Val | o:FieldPut( " + Str( i, 3) + ", Val ) }" ) )
#endif

return( o )

//---------------------------------------------------------------------------//

METHOD Seek( xVal, nField ) CLASS TDbArray

   local nScan       := 0

   DEFAULT  nField   := 1

   nScan := AScan( ::aRecords, { | aRow | aRow[ nField ] == xVal } )
   if nScan != 0
      ::GoTo( nScan )
   end if

return ( nScan != 0 )

//---------------------------------------------------------------------------//

METHOD LoadArray( aArray ) CLASS TDbArray

   ::aRecords  := aArray
   ::RecNo     := 1
   ::LastRec   := ::RecCount()

return( Self )

//---------------------------------------------------------------------------//

METHOD GetStatus() CLASS TDbArray

    ::aStatus := {}

    AAdd( ::aStatus, ::Recno )

return( Self )

//----------------------------------------------------------------------------//

METHOD SetStatus() CLASS TDbArray

    ::Goto( ::aStatus[ 1 ] )

return( Self )

//----------------------------------------------------------------------------//