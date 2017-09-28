//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expsito Surez    Soft 4U '1994-2001                  //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TDbf                                                          //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gestin y control de DBFs                                     //
//----------------------------------------------------------------------------//

#include "Obj2Hb.ch"
#include "FileIO.ch"
#include "TDbfMsg.ch"
#include "DBStruct.ch"
#include "TDbfVer.ch"

#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                  <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
                [ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]

#ifdef __HARBOUR__
   #ifndef __XHARBOUR__
      #xtranslate DbSkipper => __DbSkipper
   #endif
#endif

//----------------------------------------------------------------------------//

CLASS TDbf

    DATA aTField, aTIndex, aTFilter, aStatus        AS ARRAY
    DATA cAlias, cVer, cRDD, cFile, cName, cPath,   ;
         cFldInvalid, cComment                      AS STRING
    DATA nArea, FieldCount, Count,       ;
         nType, nLang, nRecno                       AS NUMERIC
    DATA hDataFile
    DATA lRecycle, lShared, lReadOnly, lProtec,     ;
         lScope,                                    ;
         lMemo, lValid, lAppend, lCount, lFilter 
    DATA bNetError, bOnCreate, bOnOpen, bOnClose,   ;
         bOpenError, bBof, bEof, bLFor, bLWhile     AS BLOCK
    DATA oIndex, oFilter                            AS OBJECT
    DATA Cargo
    DATA lBuffer                                    AS LOGICAL

    DATA ClsName                                    AS STRING INIT "TDBF"

//-- INITIALIZE AND ACTIVATE METHODS -----------------------------------------//

    METHOD  New( cFile, cName, cRDD, cComment, cPath )          CONSTRUCTOR
    METHOD  Use( cFile, cPath, cComment )                       CONSTRUCTOR
    METHOD  NewOpen( cFile, cName, cRDD, cComment, cPath, lRecycle, lShared, lReadOnly, lProtec )          CONSTRUCTOR
    METHOD  AutoField()
    METHOD  AutoIndex()
    METHOD  Activate( lRecycle, lShared, lReadOnly, lProtec, lAutoField, lAutoIndex, lOpen, lNewArea )
    METHOD  ReActivate()

//-- WORKAREA METHODS -------------------------------------------------------//

    METHOD  Bof()       INLINE ( ::nArea )->( Bof() )
    METHOD  Eof()       INLINE ( ::nArea )->( Eof() )
    METHOD  Found()     INLINE ( ::nArea )->( Found() )
    MESSAGE GoTo()      METHOD _GoTo( nRec )
    MESSAGE GoTop()     METHOD _GoTop()
    MESSAGE GoBottom()  METHOD _GoBottom()

    METHOD  Seek( uVal, lSoft, lLast )
    METHOD  SeekInOrd( uVal, cOrd, lSoft, lLast )
    METHOD  SeekInOrdBack( uVal, cOrd, lSoft, lLast )
    METHOD  SeekBack( uVal, cOrd, lSoft, lLast )

    MESSAGE Skip( n )   METHOD _Skip( nSkip )
    METHOD  Skipper( nSkip )
    METHOD  SkipperLoad( nSkip )

    METHOD  First()     INLINE ::GoTop()
    METHOD  Next()      INLINE ::Skip( 1 )
    METHOD  Prior()     INLINE ::Skip( -1 )
    METHOD  Last()      INLINE ::GoBottom()

//-- DATA MANAGEMENT METHODS -------------------------------------------------//

    METHOD  AddField( cName, cType, nLen, nDec, cPic, xDefault, bValid, bSetGet, cComment, lColAlign, nColSize, lHide )

    METHOD getBuffer()              INLINE ( ::lBuffer )
    METHOD setBuffer( lValue )      INLINE ( ::lBuffer := lValue )
    METHOD putBuffer()              INLINE ( ::lBuffer := .t. )
    METHOD quitBuffer()             INLINE ( ::lBuffer := .f. )

    METHOD  Append()
    MESSAGE Delete( lNext )         METHOD _Delete( lNext )
    METHOD  Deleted()               INLINE ( ::nArea )->( Deleted() )
    METHOD  FieldName( nPos )       INLINE ( ::nArea )->( FieldName( nPos ) )
    METHOD  FieldSize( cFld )       INLINE ( ::nArea )->( FieldSize( ::FieldPos( cFld ) ) ) //mcs)
    METHOD  FCount()                INLINE ( ::nArea )->( FCount() )
    METHOD  FieldGet( nPos )        INLINE ( ::nArea )->( FieldGet( nPos ) )
    METHOD  FieldGetName( cFld )    INLINE ( ::nArea )->( FieldGet( ::FieldPos( cFld ) ) ) //mcs
    METHOD  FieldGetByName( cFld )  INLINE ( ::nArea )->( FieldGet( ::FieldPos( cFld ) ) ) //mcs
    MESSAGE FieldPut()              METHOD _FieldPut( nField, uVal )
    MESSAGE FieldPutByName()        METHOD _FieldPutByName( cField, uVal )
    METHOD  FieldPos( cFld )        INLINE ( ::nArea )->( FieldPos( cFld ) )
    METHOD  FldGet( nPos )          INLINE ( if( ::getBuffer(), ::aTField[ nPos ]:Val, ::aTField[ nPos ]:GetVal() ) )
    METHOD  FldPut( nPos, Val )     INLINE ( if( ::getBuffer(), ::aTField[ nPos ]:Val := Val, ::aTField[ nPos ]:PutVal( Val ) ) )
    METHOD  LastRec()               INLINE ( ::nArea )->( LastRec() )
    METHOD  RecCount()              INLINE ( ::nArea )->( OrdKeyCount() )
    MESSAGE RecNo( uGo )            METHOD  _RecNo( uGo )
    METHOD  GetRecno()              INLINE ::nRecno := ( ::nArea )->( RecNo() )
    METHOD  SetRecno()              INLINE ( ::nArea )->( DbGoTo( ::nRecno ) )
    METHOD  ReCall()

    METHOD  fieldGetBuffer( cFld )          INLINE ( if( ::getBuffer(), ::aTField[ ::FieldPos( cFld ) ]:Val, nil ) )
    METHOD  fieldPutBuffer( cFld, Val )     INLINE ( if( ::getBuffer(), ::aTField[ ::FieldPos( cFld ) ]:Val := Val, nil ) )

    METHOD  Say()

//-- WORKAREA/DATABASE MANAGEMENT METHODS ------------------------------------//

    METHOD  Alias()             INLINE Alias( ::nArea )
    METHOD  Create()
    METHOD  UseArea( lNew, lOpen )
    METHOD  Pack( bRecord )
    METHOD  HardPack( bRecord )
    METHOD  Zap()               INLINE ( ::nArea )->( __DbZap() ), Self
    MESSAGE Eval() METHOD _Eval( bBlock, bFor, bWhile, nNext, nRecord, lRest )

    // Destructores de CIERRE de la DBF, del OBJETO y de los DOS
    METHOD  Close()
    METHOD  Destroy()
    METHOD  End()       INLINE if( ::Close(), ::Destroy(), .f. )

//-- Metodos basados en indices ---------------------------------------------

    METHOD  Locate( bFor, bWhile, lRest )
    METHOD  Continue()          INLINE ::Locate( ,, .t. )
    METHOD  Sort( cFile, aField, bFor, bWhile, next, rec, lRest )
    METHOD  Total( cFile, bKey, aField, bFor, bWhile, next, rec, lRest )
    METHOD  Sum( bSum, bFor, bWhile, lRest )

//-- ORDER MANAGEMENT METHODS ------------------------------------------------//

    METHOD OrdBagExt() INLINE ( ::nArea )->( OrdBagExt() )
    METHOD OrdBagName( cnTag ) INLINE ( ::nArea )->( OrdBagName( cnTag ) )
    METHOD OrdCreate( cFile, cName, cExp, bExp, lUniq ) INLINE ( ::nArea )->( OrdCreate( cFile, cName, cExp, bExp, lUniq ) ), ::AutoIndex()
    METHOD OrdDestroy( cnTag, cFile )                   INLINE ( ::nArea )->( OrdDestroy( cnTag, cFile ) ), ::AutoIndex()
    METHOD OrdFor( cnTag, cFile ) INLINE ( ::nArea )->( OrdFor( cnTag, cFile ) )
    METHOD OrdKey( cnTag, cFile ) INLINE ( ::nArea )->( OrdKey( cnTag, cFile ) )
    METHOD OrdKeyNo()      INLINE ( ::nArea )->( OrdKeyNo() )                             // mcs
    METHOD OrdKeyVal()     INLINE ( ::nArea )->( OrdKeyVal() )                            // mcs
    METHOD OrdKeyCount()   INLINE ( ::nArea )->( OrdKeyCount() )                          // mcs
    MESSAGE OrdScope()     METHOD _OrdScope( uTop, uBottom )                              // mcs
    METHOD OrdClearScope()                                                                // mcs

    METHOD OrdListAdd( cFile, cnTag )   INLINE ( ::nArea )->( OrdListAdd( cFile, cnTag ) ), ::AutoIndex()
    METHOD OrdListClear()               INLINE ( ::nArea )->( OrdListClear() ), ::aTindex := {}
    METHOD OrdListReBuild()             INLINE ( ::nArea )->( OrdListReBuild() ), ::AutoIndex()
    METHOD OrdName( nTag, cFile )       INLINE ( ::nArea )->( OrdName( nTag, cFile ) )
    METHOD OrdNumber( cName, cFile )    INLINE ( ::nArea )->( OrdNumber( cName, cFile ) )
    METHOD OrdDescend()                 INLINE ( ::nArea )->( OrdDescend() )
    METHOD OrdSetFocus( cnTag, cFile )  INLINE ( ::nArea )->( OrdSetFocus( cnTag, cFile ) )

//---------------------------------------------------------------------------//

    METHOD IdxByTag( cnTag, cFile )
    METHOD IdxByName( cName, cFile )
    METHOD IdxByOrder( nOrder, cFile )

    METHOD AddIndex()
    METHOD AddTmpIndex()
    METHOD AddBag( cFile )

    METHOD IdxFCheck()
    METHOD IdxCreate( oIdx )    INLINE ( ::nArea )->( oIdx:Create() )
    METHOD ReIndexAll( bOption, nStep )

    METHOD IdxActivate()
    METHOD IdxFDel()
    METHOD IdxDelete( cName, cFile )

    METHOD SetIndex( cnTag, cFile )
    METHOD SetOrder( cnTag, cFile );
                INLINE ( ::nArea )->( OrdNumber( ::SetIndex( cnTag, cFile ) ) )

    // Operaciones con registros logicos
    METHOD IdxKeyVal()          INLINE ( ::nArea )->( OrdKeyVal() )
    METHOD IdxKeyGoTo( nRec )   INLINE ( ::nArea )->( OrdKeyGoTo( nRec ) )
    METHOD OrdKeyGoTo( nRec )   INLINE ( ::nArea )->( OrdKeyGoTo( nRec ) )
    METHOD IdxKeyNo()           INLINE ( ::nArea )->( OrdKeyNo() )
    METHOD IdxKeyCount()        INLINE ( ::nArea )->( OrdKeyCount() )

//-- SCOPING METHODS ---------------------------------------------------------//

    MESSAGE SetScope( uTop, uBottom )  METHOD _SetScope( uTop, uBottom )
    METHOD  ClearScope()

//-- FILTER METHODS ----------------------------------------------------------//

    METHOD  SetFilter( coFlt )
    METHOD  KillFilter()        INLINE ::SetFilter()

//-- NETWORK OPERATION METHODS -----------------------------------------------//

    METHOD  Lock()              INLINE ( ::nArea )->( FLock() )
    METHOD  RecLock()
    METHOD  UnLock()            INLINE ( ( ::nArea )->( DBUnLock() ), Self )

//-- MISCELLANEOUS AND NEWS METHODS ------------------------------------------//

    METHOD  Protec( nAcction )
    METHOD  Used()              INLINE ( ::nArea )->( Used() )

    METHOD  aField()
    METHOD  Blank()
    METHOD  Insert( lMessage )  

    METHOD  LoadLock()          INLINE ( if( ::RecLock(), ::Load(), .f. ) )
    METHOD  Load()
    METHOD  Cancel( lMessage )  INLINE ( ::RollBack(), if( !empty( lMessage ), msgInfo("Cancel"), ) )     // mcs like VB does
    METHOD  RollBack()

    METHOD  Save()
    METHOD  SaveFields()    
    METHOD  SaveUnLock()        INLINE ( ::SaveFields(), ::UnLock(), ::lAppend := .f. )
    METHOD  Update()            INLINE ::Save()

    METHOD  Valid()
    METHOD  Commit()            INLINE ( ::nArea )->( DBCommit() )

    METHOD  SetCalField( cName, bSetGet, cPic, cComment  )
    METHOD  SetFieldEmpresa( nCount )
    METHOD  SetDefault()
    METHOD  SetBrowse( oBrw, lLoad )
    METHOD  SetFocus()          INLINE DbSelectArea( ::nArea ), Self
    METHOD  SetDeleted()

    METHOD  FieldByName( cName )

    METHOD  Clone( lNewArea, cComment )
    METHOD  Refresh()

    METHOD  GetStatus()
    METHOD  GetStatusInit()     INLINE ( ::GetStatus( .t. ) )
    METHOD  SetStatus()

    METHOD  aMsg( nMsg )        INLINE GetMsg( ::nLang )[ nMsg ]
    METHOD  DbError( Error )    INLINE MsgInfo( if( ValType( Error ) != "N", Error, ::aMsg( Error ) ) )

    //Nuevos por manuel calero

    METHOD lSetMarkRec( cMark, nRec )
    METHOD GetMarkRec( nRec )
    METHOD lMarked( cMark, nRec )
    METHOD ChgMarked( cMark, nRec )
    METHOD SetAllMark( cMark )
    METHOD nGetAllMark( cMark, cAlias )

    METHOD AppendFromObject( oDbf )

    METHOD AppendFrom( cFile, aFields, bFor, bWhile, nNet, nRec, cRest, cRdd ) INLINE ( ::nArea )->( __dbApp( cFile, aFields, bFor, bWhile, nNet, nRec, cRest, cRdd ) )
    METHOD DbEval( bBlock, bForCondition, bWhileCondition, nNextRecords, nRecord, lRest) INLINE ( ::nArea )->( DbEval( bBlock, bForCondition, bWhileCondition, nNextRecords, nRecord, lRest ) )

    METHOD SwapUp()
    METHOD SwapDown()

    METHOD lRddAdsCdx()                   INLINE ( ::cRDD == "ADSCDX" )

    METHOD aCommentIndex()

    METHOD lExistFile( cFile )            INLINE ( ::cRDD != "DBFCDX" .or. File( cFile ) ) // 

    METHOD aScatter()

    METHOD aDbfToArray()
    
    METHOD CreateFromHash( hDefinition )

    METHOD setCustomFilter( cExpresionFilter )
    METHOD quitCustomFilter( cExpresionFilter )

    METHOD adsSetAOF( cExpresionFilter ) INLINE ( ( ::nArea )->( adsSetAOF( cExpresionFilter ) ) )
    METHOD adsClearAOF()                 INLINE ( ( ::nArea )->( adsClearAOF() ) )  

ENDCLASS

//----------------------------------------------------------------------------//
// Constructor por defecto si la DBF no esta abierta
//@@
METHOD New( cFile, cName, cRDD, cComment, cPath ) CLASS TDbf

    ::nType       := idNORMAL
    ::nArea       := 0
    ::cAlias      := ""

    Set( _SET_OPTIMIZE  , "ON" )
    Set( _SET_AUTOPEN   , "OFF" )
    Set( _SET_AUTORDER  , "OFF" )
    Set( _SET_AUTOSHARE , "OFF" )

    cFile         := if( ValType( cFile )  != "C", Alias() + ".DBF", upper( cFile ) )
    cFile         := if( empty( GetFileExt( cFile ) ), cFile + ".DBF", cFile )

    DEFAULT cPath := GetPath( cFile )

    cPath         := if( !empty( cPath ), cPath, Set( _SET_DEFAULT ) )
    cPath         := if( empty( cPath ), ".\", cPath )

    ::cPath       := cPath // if( right( cPath, 1 ) != "\", cPath += "\", cPath )

    ::cFile       := ::cPath + GetFileName( cFile )
    ::cName       := if( ValType( cName ) != "C", GetFileNoExt( ::cFile ), cName )

    ::cRDD        := if( ValType( cRDD )     != "C", cDriver(), upper( cRDD ) )
    ::cComment    := if( ValType( cComment ) != "C", "", cComment )

    ::cVer := ID_VTDBF
    ::cFldInvalid := ""

    ::nLang       := SetLang( LANGSYS )

    ::aTIndex     := {}
    ::aTField     := {}
    ::aTFilter    := {}

    ::FieldCount  := 0

    ::lValid      := .t.
    ::lCount      := .t.

    ::lScope      := .f.
    ::lFilter     := .f.
    ::lBuffer     := .f.

    ::bLFor       := { || .t. }
    ::bLWhile     := { || .t. }
    ::bBof        := { || nil }
    ::bEof        := { || nil }
    ::bOnCreate   := { || .t. }
    ::bOnOpen     := { || .t. }
    ::bOnClose    := { || .t. }

    ::bNetError   := { | o | ApoloMsgNoYes( o:aMsg( dbBLOCREG ) + " Num. " + alltrim( str( o:RecNo() ) ), o:aMsg( dbRETRY ) ) }
    ::bOpenError  := { | o | MsgStop( o:aMsg( dbOPENDB ) + CRLF + o:cFile, o:aMsg( dbSELEC ) ) }

    ::oIndex      := GetIdxNone( Self )

    ::aStatus     := {}

return( Self )

//----------------------------------------------------------------------------//
// Constructor si la DBF existe sin definir campos :::->>> nType 1
//

METHOD  NewOpen( cFile, cName, cRDD, cComment, cPath, ;
                 lRecycle, lShared, lReadOnly, lProtec ) CLASS TDbf

    ::New( cFile, cName, cRDD, cComment, cPath ):nType := idNEWOPEN
    ::Activate( lRecycle, lShared, lReadOnly, lProtec, .t., .t., .f., .t. )

return( Self )

//----------------------------------------------------------------------------//
// Constructor si la DBF esta abierta :::->>> nType 2

METHOD Use( cFile, cPath, cComment, lRecycle, lProtec ) CLASS TDbf

    local cFor := ""

    ::New( cFile,,, cComment, cPath ):nType := idUSE
    ::Activate( lRecycle,,, lProtec, .t., .t., .t., .f. )

    cFor := ( ::nArea )->( DbFilter() )
    if ( ::lFilter := !empty( cFor ) )
        ::AddFilter( cFor,, cFor )
    endif

return( Self )

//----------------------------------------------------------------------------//
// Inicializa el objeto y la tabla de campos del fichero de datos
//
METHOD Activate( lRecycle, lShared, lReadOnly, lProtec, lAutoField, lAutoIndex, lOpen, lNewArea ) CLASS TDbf

   DEFAULT lAutoField   := .f.
   DEFAULT lAutoIndex   := .f.
   DEFAULT lOpen        := .f.
   DEFAULT lNewArea     := .t.

   BYNAME lRecycle      DEFAULT .f.
   BYNAME lShared       DEFAULT .f. // !set( _SET_EXCLUSIVE )
   BYNAME lReadOnly     DEFAULT .f.
   BYNAME lProtec       DEFAULT .f.

   ::cComment           := if( empty( ::cComment ), ::cName, ::cComment )

   if !lOpen .and. !::lExistFile( ::cFile )
      ::Create()
   endif

   if ::UseArea( lNewArea, lOpen )

      ::cAlias    := Alias()
      ::nArea     := Select( ::cAlias )
      ::cRDD      := ( ::nArea )->( RDDName() )
      ::lShared   := ( ::nArea )->( IsShared() )
      ::lReadOnly := ( ::nArea )->( IsReadOnly() )
      ::hDataFile := ( ::nArea )->( DbfHdl() )

      if lAutoField
         ::AutoField()
      end if

      FieldToData( Self )

      aEval( ::aTField, { |o| o:Activate() } )

      if ::nType != idNEWOPEN
         if lAutoIndex
            ::AutoIndex()
         else
            ( ::nArea )->( ::IdxActivate() )
         end if
      endif

      ::GoTop()

   else

      eval( ::bOpenError, Self )

      /*
      if !ApoloMsgNoYes( ::aMsg( dbCONT ), ::aMsg( dbSELEC ) )
         QUIT        // <----------------------  �� Ojo se sale del programa !!
      endif
      */

   endif

return( Self )

//----------------------------------------------------------------------------//
// Inicia el objeto nuevamente despues de un ::Close()
//
METHOD ReActivate() CLASS TDbf
return( ::Activate( ::lRecycle, ::lShared, ;
                    ::lReadOnly, ::lProtec, .f., .f., .f. ) )

//----------------------------------------------------------------------------//
// Activa objetos TField:
//
METHOD AutoField() CLASS TDbf

    local aInfo := ( ::nArea )->( DbStruct() )
    local nFld  := len( aInfo )
    local n     := 0

    ::aTField := {}

    FOR n := 1 TO nFld
        ::AddField( TField():New( Self, aInfo[ n ][ DBS_NAME ], ;
                                        aInfo[ n ][ DBS_TYPE ], ;
                                        aInfo[ n ][ DBS_LEN  ], ;
                                        aInfo[ n ][ DBS_DEC  ] ) )
    NEXT

return( Self )

//----------------------------------------------------------------------------//
// Activa objetos TIndex:
//
METHOD AutoIndex() CLASS TDbf

   local n     := 0
   local cFor  := ""
   local lDel  := .f.
   local cIdx  := ( ::nArea )->( OrdName( 0 ) )
   local cOrd  := ""

   ::aTIndex   := {}

   while !empty( cOrd := ( ::nArea )->( OrdName( ++n ) ) )
       cFor    := upper( ( ::nArea )->( OrdFor( n ) ) )
       lDel    := if( "!DELETED" $ cFor, .t., .f. )
       ( ::nArea )->( ::AddIndex( cOrd, OrdBagName( n ), OrdKey( n ), cFor,,,,,, lDel ) )
       if( cOrd == cIdx, ::oIndex := ::aTIndex[ n ], )
   end

return( ::oIndex )

//----------------------------------------------------------------------------//
//-- WORKAREA METHODS --------------------------------------------------------//
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
//
METHOD _GoTo( nRecNo ) CLASS TDbf

    ( ::nArea )->( DbGoTo( nRecNo ) )

return( Self )

//----------------------------------------------------------------------------//
//
METHOD _GoTop() CLASS TDbf

    ( ::nArea )->( DbGoTop() )

return( Self )

//---------------------------------------------------------------------------//
//
METHOD _GoBottom() CLASS TDbf

    ( ::nArea )->( DbGoBottom() )

return( Self )

//----------------------------------------------------------------------------//
//  Busca un registro
//  Compatible el tercer parametro de DbSeek de clipper 5.3, busca el ultimo
//
METHOD Seek( uVal, lSoft, lLast ) CLASS TDbf

    local lRet := .f.

    DEFAULT lSoft := Set( _SET_SOFTSEEK )
    DEFAULT lLast := .f.

    lRet       := ( ::nArea )->( dbSeek( uVal, lSoft, lLast ) )

    if ::lScope
        if !Eval( ::oIndex:bBottom, Self )
            ( ::nArea )->( dbGoTo( 0 ) )
            lRet  := .f.
        elseif !eval( ::oIndex:bTop, Self )
            if( lSoft, ::GoTop(), ( ( ::nArea )->( dbGoTo( 0 ) ) ) )
            lRet  := .f.
        endif
    endif

return( lRet )

//---------------------------------------------------------------------------//

METHOD SeekInOrd( uVal, cOrd, lSoft, lLast ) CLASS TDbf

    local lRet := .f.
    local nOrd := ( ::nArea )->( OrdSetFocus( cOrd ) )

    lRet       := ::Seek( uVal, lSoft, lLast )

    ( ::nArea )->( OrdSetFocus( nOrd ) )

return( lRet )

//----------------------------------------------------------------------------//

METHOD SeekInOrdBack( uVal, cOrd, lSoft, lLast ) CLASS TDbf

    local lRet := .f.
    local nRec := ( ::nArea )->( Recno() )

    lRet       := ::SeekInOrd( uVal, cOrd, lSoft, lLast )

    ( ::nArea )->( dbGoTo( nRec ) )

return ( lRet )

//----------------------------------------------------------------------------//


METHOD SeekBack( uVal, cOrd, lSoft, lLast ) CLASS TDbf

    local lRet := .f.
    local nRec := ( ::nArea )->( Recno() )
    local nOrd := ( ::nArea )->( OrdSetFocus( cOrd ) )

    lRet       := ::Seek( uVal, lSoft, lLast )

    ( ::nArea )->( OrdSetFocus( nOrd ) )
    ( ::nArea )->( dbGoTo( nRec ) )

return( lRet )

//----------------------------------------------------------------------------//

METHOD _Skip( nSkip ) CLASS TDbf

    ( ::nArea )->( DbSkip( nSkip ) )

    if ::lScope
        DEFAULT nSkip := 1
        if nSkip > 0
            if !eval( ::oIndex:bBottom, Self )
                ( ::nArea )->( DbGoTo( 0 ) )
                eval( ::bEof, Self )
            endif
        else
            if !eval( ::oIndex:bTop, Self )
                iScpTop( Self )
                eval( ::bBof, Self )
            endif
        endif
    else
        if ( ::Eof() )
            eval( ::bEof, Self )
        elseif ( ::Bof() )
            eval( ::bBof, Self )
        endif
    endif

return( Self )

//---------------------------------------------------------------------------//
// No carga buffer, mueve puntero y devuelve registros saltados realmente
//
METHOD Skipper( nSkip ) CLASS TDbf

    local nSkipped := 0


    DO CASE
    CASE nSkip > 0
        if ::lScope
            while nSkipped < nSkip
                ( ::nArea )->( DbSkip( 1 ) )
                if eval( ::oIndex:bBottom, Self )
                    ++nSkipped
                else
                    ( ::nArea )->( DbSkip( -1 ) )
                    EXIT
                endif
            end
        else
            while nSkipped < nSkip
                ( ::nArea )->( DbSkip( 1 ) )
                if !( ::Eof() )
                    ++nSkipped
                else
                    ( ::nArea )->( DbSkip( -1 ) )
                    EXIT
                endif
            end
        endif
    CASE nSkip < 0
        if ::lScope
            while nSkipped > nSkip
                ( ::nArea )->( DbSkip( -1 ) )
                if eval( ::oIndex:bTop, Self )
                    --nSkipped
                else
                    if( !( ::Bof() ), ( ::nArea )->( dbSkip( 1 ) ), )
                    EXIT
                endif
            end
        else
            while nSkipped > nSkip
                ( ::nArea )->( DbSkip( -1 ) )
                if !( ::Bof() )
                    --nSkipped
                else
                    EXIT
                endif
            end
        endif
    END CASE

return( nSkipped )

//---------------------------------------------------------------------------//
// Como Skipper pero carga buffer
//
METHOD SkipperLoad( nSkip ) CLASS TDbf

    local nSkipped := 0

    DO CASE
    CASE nSkip > 0
        if ::lScope
            while nSkipped < nSkip
                ( ::nArea )->( DbSkip( 1 ) )
                if eval( ::oIndex:bBottom, Self )
                    ++nSkipped
                    ::Load()
                else
                    ( ::nArea )->( DbSkip( -1 ) )
                    EXIT
                endif
            end
        else
            while nSkipped < nSkip
                ( ::nArea )->( DbSkip( 1 ) )
                if !( ::Eof() )
                    ++nSkipped
                    ::Load()
                else
                    ( ::nArea )->( DbSkip( -1 ) )
                    EXIT
                endif
            end
        endif
    CASE nSkip < 0
        if ::lScope
            while nSkipped > nSkip
                ( ::nArea )->( DbSkip( -1 ) )
                if eval( ::oIndex:bTop, Self )
                    --nSkipped
                    ::Load()
                else
                    if( !( ::Bof() ), ( ::nArea )->( dbSkip( 1 ) ), )
                    EXIT
                endif
            end
        else
            while nSkipped > nSkip
                ( ::nArea )->( dbSkip( -1 ) )
                if !( ::Bof() )
                    --nSkipped
                    ::Load()
                else
                    EXIT
                endif
            end
        endif
    END CASE

return( nSkipped )

//----------------------------------------------------------------------------//
//-- DATA MANAGEMENT METHODS -------------------------------------------------//
//----------------------------------------------------------------------------//
//@@
// modificado por mcs para soportar nuevos parametros

METHOD AddField( cName, cType, nLen, nDec, cPic, xDefault, ;
                 bValid, bSetGet, cComment, lColAlign, nColSize, lHide, aBitmaps ) CLASS TDbf
    local oFld

    ++::FieldCount

    if cName:ClassName() == "TFIELD"
        oFld   := cName
    else
        oFld   := TField():New( Self, cName, cType, nLen, nDec, cPic, xDefault, ;
                                  bValid, bSetGet, cComment, lColAlign, nColSize, lHide, aBitmaps )
    end if

    aAdd( ::aTField, oFld )

return( oFld )

//----------------------------------------------------------------------------//
//@@

METHOD Append( lUnLock ) CLASS TDbf

    ::putBuffer()
    ( ::nArea )->( DbAppend( lUnLock ) )

return( ::lAppend := !( ::nArea )->( NetErr() ) )

//----------------------------------------------------------------------------//
//@@

METHOD _Delete( lNext ) CLASS TDbf

   local nNext
   local nRecNo
   local lDeleted := .f.

   DEFAULT lNext  := .f.

   if lNext
      nRecNo      := ( ::nArea )->( OrdKeyNo() )
      ( ::nArea )->( dbSkip() )
      nNext       := ( ::nArea )->( OrdKeyNo() )
      ( ::nArea )->( OrdKeyGoTo( nRecNo ) )
   end if

   if ::RecLock()
      ( ::nArea )->( dbDelete() )
      lDeleted    := .t.
      ::UnLock()
   endif

   if lDeleted .and. lNext
      ( ::nArea )->( OrdKeyGoTo( nRecNo ) )
      if ( ::Eof() ) .or. nNext == nRecNo
         ( ::nArea )->( dbGoBottom() )
      end if
   end if

return( lDeleted )

//----------------------------------------------------------------------------//

METHOD _FieldPut( nPos, Val ) CLASS TDbf

   if ::RecLock()
      ( ::nArea )->( FieldPut( nPos, Val ) )
      ::UnLock()
   endif

return( Val )

//----------------------------------------------------------------------------//

METHOD _FieldPutByName( cFld, Val ) CLASS TDbf

    local nPos := ::FieldPos( cFld )

    if nPos != 0
      ::FieldPut( nPos, Val )
    endif

return( Val )

//----------------------------------------------------------------------------//


METHOD _RecNo( uGo ) CLASS TDbf

    local Ret := ( ::nArea )->( RecNo() )

    if( uGo != nil, ::GoTo( uGo ), )

return( Ret )

//----------------------------------------------------------------------------//

METHOD Recall() CLASS TDbf

    local lRet := ( ::nArea )->( Deleted() ) .and. ::RecLock()

    if lRet
        ( ::nArea )->( DbRecall() )
        ::UnLock()
    endif

return( lRet )

//----------------------------------------------------------------------------//
//-- WORKAREA/DATABASE MANAGEMENT METHODS ------------------------------------//
//----------------------------------------------------------------------------//
//@@
METHOD Create() CLASS TDbf

   if Eval( ::bOnCreate, Self )
      if len( ::aTField ) != 0
         dbCreate( ::cFile, ::aField(), ::cRDD )
         ::IdxFDel() // Los indices hay que borrarlos si existen:
      endif
   endif

Return ( ::lExistFile( ::cFile ) )

//----------------------------------------------------------------------------//
//@@

METHOD UseArea( lNewArea, lOpen ) CLASS TDbf

   local cName

   DEFAULT lOpen        := .f.    // No esta abierta por defecto
   DEFAULT lNewArea     := .t.

   cName                := alltrim( padl( ::cName, 10 ) )

   if lOpen
      return ( lOpen )
   end if 

   if !eval( ::bOnOpen, Self )
      return ( lOpen )
   end if 

   ::cAlias             := cCheckArea( "DBA" )

   /*
   if select( cName ) > 0
       dbSelectArea( 0 )
       ::cAlias := "DBA" + padl( alltrim( str( select() ) ), 3, "0" )
       lNewArea := .f.
   else
       ::cAlias := cName
   endif
   */

   dbUseArea( lNewArea, ::cRDD, ::cFile, ::cAlias, ::lShared, ::lReadOnly )
   if netErr()
       lOpen    := .f.
   else
       lOpen    := .t.
   end if

return( lOpen )

//----------------------------------------------------------------------------//
//@
METHOD Pack( bRecord ) CLASS TDBF

    local lDel    := .t.
    local lRet    := !::lShared
    local cOrder  := ""

    if lRet
        lDel      := Set( _SET_DELETED, .t. )
        cOrder    := ( ::nArea )->( OrdSetFocus( 0 ) ) // Sin indices
        ( ::nArea )->( __DbPack() )

        Set( _SET_DELETED, lDel )
        ( ::nArea )->( OrdSetFocus( cOrder ) )
    endif

return( lRet )

//----------------------------------------------------------------------------//
//@
METHOD HardPack( bRecord ) CLASS TDBF

    local lRet    := .f.
    local cFPack  := ""
    local cMmExt  := ".DBT"
    local cMmFile := ""
    local cMmNew  := ""
    local nCount  := 0
    local i       := 0

    while file( cFPack := ::cPath + "WPck" + ;
        PadL( ++nCount, 3, "0" ) + ".DBF" )
    end

    ::Close()
    ::IdxFDel()

    if lRet := ( FRename( ::cFile, cFPack ) != 0 )
        Alert( "No puedo renombrar " + ::cFile + ";a " + cFPack )
    elseif ::lMemo
        cMmExt := if( ::cRDD $ "_DBFCDX REDBDCDX COMIX", ".FPT", ".DBT" )
        cMmFile := ::cPath + GetFileNoExt( ::cFile ) + cMmExt
        cMmNew  := ::cPath + GetFileNoExt( cFPack )  + cMmExt
        if !( lRet := ( FRename( cMmFile, cMmNew ) == 0 ) )
            Alert( "No puedo renombrar el MEMO" )
        endif
     endif

    if lRet
        ::ReActivate()
        DbUseArea( .t., ::cRDD, cFPack, "_WPck" )
        _WPck->( DbGoTop() )
        nCount := _WPck->( FCount() )
        if ValType( bRecord ) == "B"
            while !_WPck->( Eof() )
                ( ::nArea )->( DbAppend() )
                FOR i := 1 TO nCount
                    ( ::nArea )->( FieldPut( i, _WPck->( FieldGet( i ) ) ) )
                NEXT
                eval( bRecord, Self )
                _WPck->( DbSkip() )
            end
        else
            while !_WPck->( Eof() )
                ( ::nArea )->( DbAppend() )
                FOR i := 1 TO nCount
                    ( ::nArea )->( FieldPut( i, _WPck->( FieldGet( i ) ) ) )
                NEXT
                _WPck->( DbSkip() )
            end
        end
        _WPck->( DbCloseArea() )
        if FErase( cFPack ) != 0
            Alert( "No puedo borrar: " + cFPack )
        elseif ::lMemo .and. FErase( cMmNew ) != 0
            Alert( "No puedo borrar: " + cMmNew )
        endif
    endif

return( lRet )

//----------------------------------------------------------------------------//
//@

METHOD Close() CLASS TDbf

    local lRet := ( ::Used() .and. Eval( ::bOnClose, Self ) )

    if lRet
        ( ::nArea )->( ordlistclear() )
        ( ::nArea )->( dbclosearea() )

        ::nArea  := 0
        ::cAlias := ""
    else
        Alert( "No puedo cerrar el area de trabajo: " + ::cAlias + ":" + ::cFile() )
    endif

return( lRet )

//----------------------------------------------------------------------------//
//-- Metodos basados en indices ---------------------------------------------
//----------------------------------------------------------------------------//
//@

METHOD _Eval( bBlock, bFor, bWhile, nNext, nRecord, lRest ) CLASS TDbf

    local nEval := 0
    local nRec  := ( ::nArea )->( RecNo() )
    local lBuf  := ::getBuffer()

    ::quitBuffer()

    DEFAULT bBlock  := { || .t. }
    DEFAULT bFor    := { || .t. }
    DEFAULT bWhile  := { || .t. }
    DEFAULT nNext   := ( ::nArea )->( LastRec() )
    DEFAULT lRest   := .f.

    if ValType( nRecord ) == 'N'
        ( ::nArea )->( DbGoTo( nRecord ) )
        if ::lScope
            if eval( ::oIndex:bRange, Self )
                ( ::nArea )->( eval( bBlock, Self ) )
                nEval++
            endif
        else
            ( ::nArea )->( eval( bBlock, Self ) )
            nEval++
        endif
    else
        if( !lRest, ::GoTop(), )

        if ::lScope
            while eval( ::oIndex:bBottom, Self ) .and. ;
                  ( ::nArea )->( eval( bWhile, Self ) ) .and. nNext > 0
                if ( ::nArea )->( eval( bFor, Self ) )
                    ( ::nArea )->( eval( bBlock, Self ) )
                    nEval++
                endif
                nNext--
                ( ::nArea )->( DbSkip() )
            enddo
        else
           while !( ::Eof() ) .and. ;
                 ( ::nArea )->( eval( bWhile, Self ) ) .and. nNext > 0
               if ( ::nArea )->( eval( bFor, Self ) )
                   ( ::nArea )->( eval( bBlock, Self ) )
                   nEval++
               endif
               nNext--
               ( ::nArea )->( DbSkip() )
           enddo
        endif
   endif

   ( ::nArea )->( DbGoTo( nRec ) )

   ::setBuffer( lBuf )

return( nEval )

//----------------------------------------------------------------------------//
// El m�todo LOCATE establece los CodeBlock ::bLFor y ::bLWhile
// para que funcione el m�todo CONTINUE
// Devuelve .f. si no encuentra mas ocurrencias
//@

METHOD Locate( bFor, bWhile, lRest ) CLASS TDbf

    local lBuf := ::getBuffer()

    ::quitBuffer()

    ::bLFor    := if( ValType( bFor )   == "B", bFor,   ::bLFor )
    ::bLWhile  := if( ValType( bWhile ) == "B", bWhile, ::bLWhile )

    DEFAULT lRest := .f.

    if( lRest, ( ::nArea )->( DbSkip() ), ::GoTop() )

   if ::lScope
      while eval( ::oIndex:bBottom, Self ) .and. ;
                    ( ::nArea )->( eval( ::bLWhile, Self ) )
         if ( ::nArea )->( eval( ::bLFor, Self ) )
            EXIT
         endif
         ( ::nArea )->( DbSkip() )
      enddo
   else
      while !( ::Eof() ) .and. ( ::nArea )->( eval( ::bLWhile, Self ) )
         if ( ::nArea )->( eval( ::bLFor, Self ) )
            EXIT
         endif
         ( ::nArea )->( DbSkip() )
      enddo
   endif

   ::setBuffer( lBuf )

return( self )


//----------------------------------------------------------------------------//
//
/*
METHOD _RecCount() CLASS TDBf

    local nRec := 0
    local nCnt := 0

    if ::lCount
        nRec := ( ::nArea )->( RecNo() )
        if ::lScope
            iScpTop( Self )
            while eval( ::oIndex:bBottom, Self )
                ( ::nArea )->( DbSkip( 1 ) )
                ++nCnt
            end
        else
            ( ::nArea )->( DbGoTop() )
            while !( ::nArea )->( Eof() )
                ( ::nArea )->( DbSkip( 1 ) )
                ++nCnt
            end
        endif
        ::Count  := nCnt
        ::lCount := .f.
        ( ::nArea )->( DbGoTo( nRec ) )
    endif

return( ::Count )
*/
//----------------------------------------------------------------------------//
//@

METHOD Sort( cFile, aField, bFor, bWhile, next, rec, lRest ) CLASS TDbf
    ( ::nArea )->( __DbSort( cFile, aField, bFor, bWhile, next, rec, lRest ) )
return( Self )

//----------------------------------------------------------------------------//
//@

METHOD Total( cFile, bKey, aField, bFor, bWhile, next, rec, lRest ) CLASS TDbf
 ( ::nArea )->( __DbTotal( cFile, bKey, aField, bFor, bWhile, next, rec, lRest ) )
return( Self )

//----------------------------------------------------------------------------//
//@

METHOD Sum( bSum, bFor, bWhile, nNext, nRecord, lRest ) CLASS TDbf
return( ::Eval( bSum, bFor, bWhile, nNext, nRecord, lRest ) )

//----------------------------------------------------------------------------//
//-- ORDER MANAGEMENT METHODS ------------------------------------------------//
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
//  Encuentra un oIndex pasandole el tag
//
METHOD IdxByTag( cnTag, cFile ) CLASS TDbf

    local cType := ValType( cnTag )
    local oIdx  := nil

    if cType == "C"
        oIdx := ::IdxByName( cnTag, cFile )
    elseif cType == "N"
        oIdx := ::IdxByOrder( cnTag, cFile )
    endif

return( if( oIdx == nil, ::oIndex, oIdx ) )

//----------------------------------------------------------------------------//
//  Encuentra un oIndex pasandole el NOMBRE del Tag
//
METHOD IdxByName( cName, cFile ) CLASS TDbf

    local nLen := len( ::aTIndex )
    local oIdx := nil
    local n    := 0

    if nLen == 0
       // No hay objetos indices
    elseif ValType( cName ) != "C"
        ::DbError( "Error en tipo de parametro - Se requiere STRING" )
    elseif cName == "_NONE_"
        oIdx      := GetIdxNone( Self )
    else
        if empty( cName )
            oIdx  := ::oIndex
        else
            cName := Upper( cName )
            for n := 1 to nLen
                if upper( ::aTIndex[ n ]:cName ) == cName
                    oIdx := ::aTIndex[ n ]
                    EXIT
                endif
            next
        endif
    endif

return( oIdx )

//----------------------------------------------------------------------------//
//  Encuentra un oIndex pasandole el ORDEN del Tag
//
METHOD IdxByOrder( nOrder, cFile ) CLASS TDbf

    local oIdx  := nil
    local cName := ""

    if ValType( nOrder ) != "N"
        ::DbError( "Error en tipo de parametro - Se requiere NUMERIC" )
    else
        cName := if( nOrder == 0, "_NONE_", ;
                           ( ::nArea )->( OrdName( nOrder, cFile ) ) )
        oIdx  := ::IdxByName( cName, cFile )
    endif

return( oIdx )

//----------------------------------------------------------------------------//
// A�ade un array de definicion de orden a ::aTIndex
//
METHOD AddIndex( cName, cFile, cKey, cFor, bWhile, lUniq, lDes, cComment, bOption, nStep, lNoDel, lTmp ) CLASS TDbf

    local oIdx

    if cName:ClassName() $ idTINDEX
        oIdx := cName
    else
        oIdx := TIndex():New( Self, cName, cFile, cKey, cFor, bWhile, lUniq, lDes, cComment, bOption, nStep, lNoDel, lTmp )
    endif

    aAdd( ::aTIndex, oIdx )

return( oIdx )

//----------------------------------------------------------------------------//
// A�ade un array de definicion de orden a ::aTIndex durante la ejecucion.
// Para indices posteriores o temporales o subindices
//

METHOD AddTmpIndex( cName, cFile, cKey, cFor, bWhile, lUniq, lDes, cComment, bOption, nStep, lNoDel, lFocus ) CLASS TDbf

    local nRec
    local oIdx

    if ::lRddAdsCdx()

        if ::nArea != 0 .and. !empty(cFor)
            ( ::nArea )->( adsSetAOF( cFor ) )
        end if 

    else

        DEFAULT lFocus  := .t.

        nRec            := ::RecNo()
        oIdx            := ::AddIndex( cName, cFile, cKey, cFor, bWhile, lUniq, lDes, cComment, bOption, nStep, lNoDel, .t. )

        oIdx:IdxExt()
        oIdx:Create()

        if ::nArea != 0
            ( ::nArea )->( OrdListClear() )
            if !::lRddAdsCdx() 
                aEval( ::aTIndex, { | o | ( ::nArea )->( OrdListAdd( o:cFile, o:cName ) ) } )
            end if 
            ( ::nArea )->( OrdSetFocus( 1 ) )
        end if

        if( lFocus, oIdx:SetFocus(), ::oIndex:SetFocus() )

        ::GoTo( nRec )

    end if

return( oIdx )

//----------------------------------------------------------------------------//

METHOD AddBag( cFile ) CLASS TDbf

    local cPath      := ""
    local cExt       := ""

    if !empty( cFile )

        cPath        := if( !empty( cPath := GetPath( cFile ) ) .and. right( cPath, 1 ) != "\", cPath + "\", ::cPath )

        cExt         := GetFileExt( cFile )

        if empty( cExt )
            cExt     := ( ::nArea )->( OrdBagExt() )
            cFile    += cExt
        endif

        cFile        := if( !empty( cPath ), cPath + cFile, cFile )


        if ::lExistFile( cFile )
            if !::lRddAdsCdx() 
                ( ::nArea )->( OrdListAdd( cFile ) )
            end if
            ( ::nArea )->( OrdSetFocus( 1 ) )
        else
            if !ApoloMsgNoYes( "No existe INDEX BAG FILE: " + cFile  )
                ::End()
                QUIT   // <----------------  �� Ojo se sale del programa !!
            endif
        endif

    endif

return( Self )

//----------------------------------------------------------------------------//
// Activa los �ndices como un SET ADSINDEX TO y pone el foco en el primero:
//
//@
METHOD IdxActivate() CLASS TDbf

   local oIdx
   local nNum  := 0
   local nLen  := len( ::aTIndex )
   local nRec  := ( ::nArea )->( RecNo() )

   if nLen > 0

      ( ::nArea )->( ::IdxFCheck() )
      ( ::nArea )->( OrdListClear() )

      // A�adimos todos los indices a la lista de ordenes

      while ++nNum <= nLen
         ::aTIndex[ nNum ]:Add()
      end

      // Para no seleccionar de entrada el orden de registros borrados

      if lAIS()
         oIdx  := ::IdxByName( ( ::nArea )->( OrdName( 1 ) ) )
      else
         oIdx  := ::IdxByName( ( ::nArea )->( OrdName( 0 ) ) )
      end if

      if !Empty( oIdx )
         oIdx:SetFocus()
      end if

   end if

   ::GoTo( nRec )

return( Self )

//----------------------------------------------------------------------------//
// Chequea la existencia del fichero contenedor de indices BAG
//
METHOD IdxFCheck() CLASS TDbf

   local lCreate := .f.

   aEval( ::aTIndex, { | oIdx | oIdx:IdxExt(), if( !::lExistFile( oIdx:cFile ), lCreate := .t., ) } )

   if lCreate
      aEval( ::aTIndex, { | oIdx |::IdxCreate( oIdx ) } )
   end if

return( Self )

//----------------------------------------------------------------------------//
// Borra fichero de indices
//
METHOD IdxFDel( cIdxFile ) CLASS TDbf

    if len( ::aTIndex ) > 0
        if ValType( cIdxFile ) != "C"
            aEval( ::aTIndex, { | oIdx | oIdx:IdxExt(), if( ::lExistFile( oIdx:cFile ), fEraseIndex( oIdx:cFile, ::cRdd ), ) } )
        else
            fEraseIndex( cIdxFile, ::cRdd )
        endif
    endif

return( Self )

//----------------------------------------------------------------------------//
//  Borra un Orden
//

METHOD IdxDelete( cnTag, cFile ) CLASS TDbf

    local oIdx
    local cType
    local nLen
    local cName
    local lRet
    local n

    if ::cRDD == "SQLRDD"

       ( ::nArea )->( dbClearFilter() )

    else

        cType := ValType( cnTag )
        nLen  := len( ::aTIndex )
        cName := ""
        lRet  := .f.
        n     := 0

        if cType == "C"
            oIdx := ::IdxByName( cnTag, cFile )
        elseif cType == "N"
            oIdx := ::IdxByOrder( cnTag, cFile )
        elseif cnTag:ClassName() $ idTINDEX
            oIdx := cnTag
        endif

        if oIdx != nil
            cName := upper( oIdx:cName )
            oIdx:Delete()
            FOR n := 1 TO nLen
                if upper( ::aTIndex[ n ]:cName ) == cName
                    lRet := .t.
                    ADel( ::aTIndex, n )
                    ASize( ::aTIndex, nLen - 1 )
                    EXIT
                endif
            NEXT
        endif

        if len( ::aTIndex ) > 0
            ::aTIndex[ 1 ]:SetFocus()
        end if

    end if

return( lRet )

//----------------------------------------------------------------------------//
//  Regenera todos los indice activos de la DBF
//
METHOD ReIndexAll( bOption, nStep ) CLASS TDbf

    ( ::nArea )->( OrdCondSet(,,,, bOption, nStep ) )
    ( ::nArea )->( OrdListRebuild() )

return( Self )

//----------------------------------------------------------------------------//
// Devuelve el orden activo y asume el mandado
//
METHOD SetIndex( cnTag, cFile ) CLASS TDbf

    local oOld := ::oIndex
    local oIdx := ::IdxByTag( cnTag, cFile )

    if !( upper( oIdx:cName ) == upper( ( ::nArea )->( OrdName( 0 ) ) ) )
        oIdx:SetFocus()
        ::lCount := ::lScope .or. ::SetDeleted() .or. ( ::Count == 0 )
        if ( ::lScope := ::oIndex:lScope ) .and. !eval( ::oIndex:bRange, Self )
            iScpTop( Self )
        endif
    endif

return( oOld:cName )

//----------------------------------------------------------------------------//
//-- SCOPING METHODS ---------------------------------------------------------//
//----------------------------------------------------------------------------//
// Pone un scope para el cnTag que le digamos y si es el actual lo activa
//
METHOD _SetScope( uTop, uBottom ) CLASS TDbf

    DEFAULT uBottom := uTop

    ( ::nArea )->( OrdScope( 0, uTop ) )
    ( ::nArea )->( OrdScope( 1, uBottom ) )
    ( ::nArea )->( DbGoTop() )

return( Self )

//----------------------------------------------------------------------------//

METHOD ClearScope() CLASS TDbf

    ( ::nArea )->( OrdScope( 0, nil ) )
    ( ::nArea )->( OrdScope( 1, nil ) )
    ( ::nArea )->( DbGoTop() )

return( Self )

//----------------------------------------------------------------------------//
//-- FILTER METHODS ----------------------------------------------------------//
//----------------------------------------------------------------------------//

METHOD SetFilter( cFlt ) CLASS TDbf

    if !Empty( cFlt )
        ( ::nArea )->( DbSetFilter( c2Block( cFlt ), cFlt ) )
    else
        ( ::nArea )->( DbClearFilter( nil ) )
    endif

    ( ::nArea )->( DbGoTop() )

return( Self )

//----------------------------------------------------------------------------//
//-- NETWORK OPERATION METHODS -----------------------------------------------//
//----------------------------------------------------------------------------//

METHOD RecLock() CLASS TDbf

    local lRet := .f.

    while !( lRet := dblock( ::nArea ) ) .and. eval( ::bNetError, Self )
    end

return( lRet )

//----------------------------------------------------------------------------//
//-- MISCELLANEOUS AND NEWS METHODS ------------------------------------------//
//----------------------------------------------------------------------------//

METHOD Protec( nAction ) CLASS TDbf

return( nil )

//----------------------------------------------------------------------------//
// Devuelve un array con la estructura de la DBF aunque la DBF este cerrada

METHOD aField() CLASS TDbf

    local n         := 0
    local aDef      := {}
    local aField    := {}

    FOR n := 1 TO ::FieldCount
        if !::aTField[ n ]:lCalculate
            aDef := {}
            aAdd( aDef, ::aTField[ n ]:cName )
            aAdd( aDef, ::aTField[ n ]:cType )
            aAdd( aDef, ::aTField[ n ]:nLen  )
            aAdd( aDef, ::aTField[ n ]:nDec  )
            aAdd( aField, aDef )
        endif
    NEXT

return( aField )

//----------------------------------------------------------------------------//
// Crea y activa un TField Calculado despues de haber sido activado el TDbf

METHOD SetCalField( cName, bSetGet, cPic, cComment ) CLASS TDbf

    local oFld

    if ::FieldByName( cName ) == nil
        ::AddField( cName, "B",,, cPic,,, bSetGet, cComment )
        oFld := GenDataField( Self, ::FieldCount )
    endif

return( oFld )

//----------------------------------------------------------------------------//
// Cuando se esta manipulando desde dos o mas objetos TDbf una misma area de
// trabajo es conveniente refrescar el sistema, sobre todo si se trabaja con
// indices

METHOD Refresh() CLASS TDBf

    ::nArea  := Select( ::cAlias )
    ::SetIndex( ( ::nArea )->( OrdName( 0 ) ) )

    ::cRDD := ( ::nArea )->( RDDName() )

    ::lShared   := ( ::nArea )->( IsShared() )
    ::lReadOnly := ( ::nArea )->( IsReadOnly() )
    ::hDataFile := ( ::nArea )->( DbfHdl() )

    ::lCount := ::lShared

return( Self )

//----------------------------------------------------------------------------//
//  Inicializa el array con valores vacios

METHOD Blank( lMessage ) CLASS TDbf

    ::putBuffer()

    ( ::nArea )->( aeval( ::aTField, {|oFld| oFld:Blank() } ) )

    if !empty(lMessage)
        msgInfo("Blank")
    end if 

return( Self )

//----------------------------------------------------------------------------//

METHOD Insert( lMessage )

    local lInsert   := .f.

    if ::Append()
        ::Save()
        lInsert     := .t.
    end if 

    if !empty( lMessage )
        msgInfo("Insert")
    end if 

return( lInsert )

//----------------------------------------------------------------------------//
//  Inicializa el array con valores por defecto

METHOD SetDefault() CLASS TDbf

    // ::aBuffer  := {}
    // ( ::nArea )->( AEval(::aTField, {|oFld| AAdd( ::aBuffer, oFld:SetDefault() ) } ) )
    ( ::nArea )->( aeval( ::aTField, {|oFld| oFld:SetDefault() } ) )

return( Self )

//----------------------------------------------------------------------------//
//  Carga la tabla con los valores actuales en ::aBuffer para RollBack

METHOD Load() CLASS TDbf

   ::putBuffer()
   ( ::nArea )->( aeval( ::aTField, {|oFld| oFld:Load() } ) )

return ( Self )

//----------------------------------------------------------------------------//
//  Carga en el buffer los valores de ::aBuffer

METHOD RollBack() CLASS TDbf
    
    // if !empty( ::aBuffer ) .and. !empty( ::aTField )
    //     ( ::nArea )->( aeval( ::aTField, { | oFld, i | oFld:Val := ::aBuffer[ i ] } ) )
    // end if

    ::quitBuffer()

return ( Self )

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

METHOD Save( lLock ) CLASS TDbf

    local lRet          := .f.

    DEFAULT lLock       := .t.

    if lLock
        if ::RecLock()
            ::SaveFields()
            lRet        := .t.
            ::UnLock()
        end if 
    else 
        ::SaveFields()
        lRet            := .t.
    end if 

    ::lAppend           := .f.
    ::quitBuffer()

return( lRet )

//----------------------------------------------------------------------------//

METHOD Valid() CLASS TDbf

    ::lValid      := .t.  // Estas DATAs se cargan en TField
    ::cFldInvalid := ""

    ( ::nArea )->( aEval( ::aTField, { | oFld | oFld:Valid() } ) )

return( ::lValid )

//----------------------------------------------------------------------------//

METHOD SetFieldEmpresa( nRec ) CLASS TDbf

    local nOldCount := ::Count

    if ValType( nRec ) == "N"
        ::Count  := nRec
        ::lCount := .f.
    endif

return( nOldCount )

//----------------------------------------------------------------------------//
// Establece los CodeBlock de movimiento en Browses, muy util para los Scopes
// Atencion a�adir el ClassName del Browse si no est� contemplado aqu�.

METHOD SetBrowse( oBrw ) CLASS TDbf

   if Upper( oBrw:ClassName() ) $ "TXBROWSE IXBROWSE"

      oBrw:nDataType    := 0
      oBrw:cAlias       := ::cAlias
      oBrw:bGoTop       := {|| if( ( ::cAlias )->( Used() ), ( ::cAlias )->( DbGoTop() ), ) }
      oBrw:bGoBottom    := {|| if( ( ::cAlias )->( Used() ), ( ::cAlias )->( DbGoBottom() ), ) }
      oBrw:bSkip        := {| n | iif( n == nil, n := 1, ), if( ( ::cAlias )->( Used() ), ( ::cAlias )->( DbSkipper( n ) ), ) }
      oBrw:bBof         := {|| if( ( ::cAlias )->( Used() ), ( ::cAlias )->( Bof() ), ) }
      oBrw:bEof         := {|| if( ( ::cAlias )->( Used() ), ( ::cAlias )->( Eof() ), ) }

      oBrw:bBookMark    := {| n | iif( n == nil,;
                                  iif( ( ::cAlias )->( Used() ), ( ::cAlias )->( RecNo() ), 0 ),;
                                  iif( ( ::cAlias )->( Used() ), ( ::cAlias )->( DbGoto( n ) ), 0 ) ) }

      if lAIS()
         oBrw:bKeyNo    := {| n | iif( n == nil,;
                              iif( ( ::cAlias )->( Used() ), ( ::cAlias )->( adsKeyNo(,,1) ), 0 ),;
                              iif( ( ::cAlias )->( Used() ), ( ::cAlias )->( OrdKeyGoto( n ) ), 0 ) ) }
         oBrw:bKeyCount := {|| if( ( ::cAlias )->( Used() ), ( ::cAlias )->( ADSKeyCount(,,1) ), ) }
      else
         oBrw:bKeyNo    := {| n | iif( n == nil,;
                              iif( ( ::cAlias )->( Used() ), ( ::cAlias )->( OrdKeyNo() ), 0 ),;
                              iif( ( ::cAlias )->( Used() ), ( ::cAlias )->( OrdKeyGoto( n ) ), 0 ) ) }
         oBrw:bKeyCount := {|| if( ( ::cAlias )->( Used() ), ( ::cAlias )->( OrdKeyCount() ), 0 ) }
      end if

      oBrw:bLock        := {|| if( ( ::cAlias )->( Used() ), ( ::cAlias )->( DbrLock() ), ) }
      oBrw:bUnlock      := {|| if( ( ::cAlias )->( Used() ), ( ::cAlias )->( DbrUnlock() ), ) }

   elseif Upper( oBrw:ClassName() ) $ "TWBROWSE TCBROWSE TSBROWSE"

      oBrw:bGoTop     := {|| ::GoTop() }
      oBrw:bGoBottom  := {|| ::GoBottom() }
      oBrw:bSkip      := {| n | ::Skipper( n ) }
      oBrw:bLogicLen  := {|| ::OrdKeyCount() }
      oBrw:bLogicPos  := {|| ::OrdKeyNo() }
      if oBrw:oVScroll() != nil
          oBrw:oVscroll():SetRange( 1, ::OrdKeyCount() )
      endif
      oBrw:Refresh()

   else

      ::DbError( dbBRWBLOCK )

   endif

return( oBrw )

//----------------------------------------------------------------------------//
// Devuelve el objeto TField dando su nombre
//
METHOD FieldByName( cName ) CLASS TDbf

    local n    := 0
    local oFld := nil

    cName := upper( cName )

    FOR n := 1 TO ::FieldCount
        if upper( ::aTField[ n ]:cName ) == cName
            oFld := ::aTField[ n ]
            EXIT
        endif
    NEXT

return( oFld )

//----------------------------------------------------------------------------//
// Duplica un objeto en memoria, si lNewArea es .t. lo abre en un nuevo area
// de trabajo, si no en la misma con lo que habra dos objetos TDbf accediendo
// a una misma WorkArea...
//
METHOD Clone( lNewArea, cComment ) CLASS TDbf

    local oDb := Self
    local oClon

    DEFAULT lNewArea := .f.
    DEFAULT cComment := ::cComment

    if lNewArea
        oClon := DbfServer( oDb:cFile )
        oClon:New( oDb:cFile, oDb:cName, oDb:cRDD, cComment, oDb:cPath )
        oClon:aTField := __objClone( oDb:aTField )
        oClon:aTIndex := __objClone( oDb:aTIndex )
        oClon:FieldCount := len( oClon:aTField )
        AEval( oClon:aTField, { |o| o:oDbf := oClon } )
        AEval( oClon:aTIndex, { |o| o:oDbf := oClon } )
        oClon:Activate( oDb:lRecycle, oDb:lShared, oDb:lReadOnly, oDb:lProtec )
    else
        oClon := __objClone( oDb )
        oClon:aTField := __objClone( oDb:aTField )
        oClon:aTIndex := __objClone( oDb:aTIndex )
        oClon:cComment := cComment
        AEval( oClon:aTField, { |o| o:oDbf := oClon } )
        AEval( oClon:aTIndex, { |o| o:oDbf := oClon } )
    endif

return( oClon )

//----------------------------------------------------------------------------//

METHOD GetStatus( lInit ) CLASS TDbf

    local hStatus   := {=>}

    DEFAULT lInit   := .f.

    hset( hStatus, "ordsetfocus", ::ordsetfocus() )
    hset( hStatus, "recno"      , ( ::nArea )->( recno() ) )
    hset( hStatus, "scope"      , ::lScope )
    
    if ::lScope
        hset( hStatus, "top"    , ::oIndex:uTop )
        hset( hStatus, "bottom" , ::oIndex:uBottom )
    end if 

    if lInit
        ::setIndex( 1 )
    end if

    if !Empty( hStatus )
        aadd( ::aStatus, hStatus )
    end if

return ( hStatus )

//----------------------------------------------------------------------------//

METHOD SetStatus( hStatus ) CLASS TDbf

    if empty( hStatus )
        if empty( ::aStatus )
            Return ( self )
        end if 
        hStatus     := atail( ::aStatus )
        aSize( ::aStatus, len( ::aStatus ) - 1 )
    end if 

    ::goTo( hget( hStatus, "recno" ) )
    ::ordSetFocus( hget( hStatus, "ordsetfocus" ) )

    if hget( hStatus, "scope" )
        ::setScope( hget( hStatus, "top" ), hget( hStatus, "bottom" ) )
    endif

return( Self )

//----------------------------------------------------------------------------//

METHOD SetDeleted( lDel ) CLASS TDbf

    local lRet := Set( _SET_DELETED ) .or. ::oIndex:lNoDel

    if( ValType( lDel ) == "L", Set( _SET_DELETED, lDel ), )

return( lRet )

//----------------------------------------------------------------------------//
// Operaciones con registros logicos
//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TDbf

    local oDb := Self

    ( oDb:nArea )->( AEval( oDb:aTFilter,   { | oFlt | oFlt:Destroy() } ) )
    ( oDb:nArea )->( AEval( oDb:aTIndex,    { | oIdx | oIdx:Destroy() } ) )
    ( oDb:nArea )->( AEval( oDb:aTField,    { | oFld | oFld:Destroy() } ) )

    oDb:aTFilter    := {}
    oDb:aTIndex     := {}
    oDb:aTField     := {}

    Self            := nil

return( .t. )

//----------------------------------------------------------------------------//
//  Activa la DATA del TField para tomar y dar valores
//----------------------------------------------------------------------------//

static function GenDataField( oDb, nPos )

    local oFld := oDb:aTField[ nPos ]

    __clsAddMsg( oDb:ClassH, oFld:cName, ;
        &( "{ | o | o:FldGet( " + Str( nPos, 3 ) + " ) }" ), HB_OO_MSG_INLINE )
    __clsAddMsg( oDb:ClassH, "_" + oFld:cName, ;
        &( "{ | o, Val | o:FldPut( " + Str( nPos, 3) + ", Val ) }" ), HB_OO_MSG_INLINE )

    //msgWait( Str( ++nCont ), "", .1 )

    // AAdd( oDb:aBuffer, oFld:Val )  // Buffer para RollBack

return( oFld )

//----------------------------------------------------------------------------//
//------ End of File TDbf.PRG ------------------------------------------------//
//----------------------------------------------------------------------------//

METHOD lSetMarkRec( cMark, nRec )

   local nRecNo   := ::RecNo()
   local nOffSet  := 0

   nRec           := if( ValType( nRec )  != "N", ::RecNo(), nRec  )
   cMark          := if( ValType( cMark ) != "C", "#", cMark )

   nOffSet        := ( ( ::nArea )->( RecSize() ) * ( nRec - 1 ) ) + ( ::nArea )->( Header() )

   FSeek( ::hDataFile, nOffSet, 0 )
   FWrite( ::hDataFile, cMark, 1 )

   ::GoTo( nRecNo )

return( FError() == 0 )

//----------------------------------------------------------------------------//
// Extrae la marca del registro a bajo nivel del espacio de la marca de deleted
//----------------------------------------------------------------------------//

METHOD GetMarkRec( nRec )

   local nRecNo   := ::RecNo()
   local nOffSet  := 0
   local cMark    := " "

   nRec           := if( ValType( nRec ) != "N", ::RecNo(), nRec  )
   nOffSet        := ( ( ::nArea )->( RecSize() ) * ( nRec - 1 ) ) + ( ::nArea )->( Header() )

   FSeek( ::hDataFile, nOffSet, 0 )
   FRead( ::hDataFile, @cMark, 1  )

   ::GoTo( nRecNo )

return( cMark )

//---------------------------------------------------------------------------//
// Esta marcado el registro?

METHOD lMarked( cMark, nRec )

    cMark := if( ValType( cMark ) == "C", cMark, "#" )

return( ::GetMarkRec( cMark, nRec ) == cMark )

//---------------------------------------------------------------------------//
// Invierte la marca del registro

METHOD ChgMarked( cMark, nRec )

   if ::lMarked( cMark, nRec )
      ::lSetMarkRec( Space( 1 ), nRec )
   else
      ::lSetMarkRec( cMark, nRec )
   end if

return ( nil )

//---------------------------------------------------------------------------//
// Marca registro a bajo nivel en el espacio de la marca del deleted
// si lo consigue devuelve .t.

METHOD SetAllMark( cMark )

   local nRecNo   := ::RecNo()

   cMark          := if( ValType( cMark ) != "C", "#", cMark )

   ::GoTop()
   while !( ::Eof() )

      ::lSetMarkRec( cMark )
      ::Skip()

   end while

   ::GoTo( nRecNo )

return ( nil )

//---------------------------------------------------------------------------//

METHOD nGetAllMark( cMark, cAlias )

   local nNum     := 0
   local nRecNo   := ::RecNo()

   cMark          := if( ValType( cMark ) != "C", "#", cMark )

   ::GoTop()
   while !( ::Eof() )

      if ::lMarked( cMark )
         ++nNum
      end if
      ::Skip()

   end while

   ::GoTo( nRecNo )

return ( nNum )

//---------------------------------------------------------------------------//

METHOD _OrdScope( uTop, uBottom )

   uBottom  := if( uBottom == nil, uTop, uBottom )

   ( ::nArea )->( OrdScope( 0, uTop ) )
   ( ::nArea )->( OrdScope( 1, uBottom ) )

   ( ::nArea )->( DbGoTop() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OrdClearScope()

   ( ::nArea )->( OrdScope( 0, nil ) )
   ( ::nArea )->( OrdScope( 1, nil ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SwapUp() CLASS TDbf

   local nRecno      := ( ::nArea )->( RecNo() )
   local aNewBuffer  := {}
   local aOldBuffer  := {}

   ( ::nArea )->( AEval( ::aTField, {|oFld| AAdd( aOldBuffer, oFld:GetVal() ) } ) )
   ( ::nArea )->( dbSkip( -1 ) )

   if ( ::nArea )->( Bof() )
      ( ::nArea )->( dbGoTo( nRecno ) )
   else
      ( ::nArea )->( AEval( ::aTField, {|oFld| AAdd( aNewBuffer, oFld:GetVal() ) } ) )
      ( ::nArea )->( dbSkip( 1 ) )
      ( ::nArea )->( aEval( ::aTField, {|oFld, n| oFld:PutVal( aNewBuffer[ n ] ) } ) )
      ( ::nArea )->( dbSkip( -1 ) )
      ( ::nArea )->( aEval( ::aTField, {|oFld, n| oFld:PutVal( aOldBuffer[ n ] ) } ) )
      ( ::nArea )->( dbSkip( 1 ) )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SwapDown() CLASS TDbf

   local nRecno      := ( ::nArea )->( RecNo() )
   local aNewBuffer  := {}
   local aOldBuffer  := {}

   ( ::nArea )->( AEval( ::aTField, {|oFld| AAdd( aOldBuffer, oFld:GetVal() ) } ) )
   ( ::nArea )->( dbSkip( 1 ) )

   if ( ::nArea )->( Eof() )
      ( ::nArea )->( dbGoTo( nRecno ) )
   else
      ( ::nArea )->( AEval( ::aTField, {|oFld| AAdd( aNewBuffer, oFld:GetVal() ) } ) )
      ( ::nArea )->( dbSkip( -1 ) )
      ( ::nArea )->( aEval( ::aTField, {|oFld, n| oFld:PutVal( aNewBuffer[ n ] ) } ) )
      ( ::nArea )->( dbSkip( 1 ) )
      ( ::nArea )->( aEval( ::aTField, {|oFld, n| oFld:PutVal( aOldBuffer[ n ] ) } ) )
      ( ::nArea )->( dbSkip( -1 ) )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SaveFields() CLASS TDbf

    local aLockList     :=  ( ::nArea )->( dbrlocklist() )

    if ascan( aLockList, ( ::nArea )->( recno() ) ) == 0
        ( ::nArea )->( dbrlock() )
    end if 

    ( ::nArea )->( aeval( ::aTField, { | oFld | oFld:Save() } ) )

Return ( Self )

//---------------------------------------------------------------------------//
/*
Relaci�n de ordenes
*/

METHOD aCommentIndex() CLASS TDbf

   local oIndex
   local aIndex   := {}

   for each oIndex in ::aTIndex
      if !Empty( oIndex:cComment )
         aAdd( aIndex, oIndex:cComment )
      end if
   next

Return ( aIndex )

//---------------------------------------------------------------------------//

METHOD AppendFromObject( oDbf ) CLASS TDbf

   local n
   local nCount   := ( ::nArea )->( fCount() )

   ( ::nArea )->( dbAppend() )

   if !( ::nArea )->( NetErr() )

      for n := 1 to nCount
         ( ::nArea )->( FieldPut( n, ( oDbf:nArea )->( FieldGet( n ) ) ) )
      next

      ( ::nArea )->( dbUnLock() )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD aScatter() class TDbf

   local i
   local aField  := {}
   local nField  := ::FCount()

   for i := 1 to nField
      aAdd( aField, ::FieldGet(i) )
   next

Return ( aField )

//----------------------------------------------------------------------------//

METHOD aDbfToArray() class TDbf

  local aDbf  := {}

  ::GetStatus()

  ::First()

  while !( ::Eof() )  

    aAdd( aDbf, ::aScatter() )

    ( ::nArea )->( dbSkip() )

  end while  

  ::SetStatus()

Return ( aDbf )

//---------------------------------------------------------------------------//

METHOD CreateFromHash( hDefinition, cDriver, cPath ) CLASS TDbf

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Say() CLASS TDbf

    local say   := ""

    ( ::nArea )->( aeval( ::aTField, { | oFld | say += cvaltochar( oFld:GetVal() ) + " : " } ) )

Return ( say )        

//----------------------------------------------------------------------------//

METHOD setCustomFilter( cExpresionFilter )

   if lAIS()
      ( ::nArea )->( adsSetAOF( cExpresionFilter ) ) 
   else 
      ( ::nArea )->( dbSetFilter( bCheck2Block( cExpresionFilter ), cExpresionFilter ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD quitCustomFilter( cExpresionFilter )

   if lAIS()
      ( ::nArea )->( adsClearAOF() ) 
   else 
      ( ::nArea )->( dbSetFilter() )
   end if 

RETURN ( Self )

//------ Funciones amigas ----------------------------------------------------//
//----------------------------------------------------------------------------//
// Este metodo crea la DATA de cada TField

static function FieldToData( oDb )

    ( oDb:nArea )->( AEval( oDb:aTField, { | oFld, i | GenDataField( oDb, i ) } ) )

return ( oDb )

//---------------------------------------------------------------------------//

static function FullDatabase( hDefinition )

return ( hDefinition[ "Table" ] + "." + hDefinition[ "ExtensionTable" ] )    

//--------------------------------------------------------------------