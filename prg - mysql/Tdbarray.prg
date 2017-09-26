//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '1994-2001                  //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TDbArray                                                      //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gesti¢n se array como DBFs (DBF virtuales)                    //
//----------------------------------------------------------------------------//

#include "FiveWin.Ch"
#include "Obj2Hb.ch"

// De DbStruct.ch

#define DBS_NAME 1
#define DBS_TYPE 2
#define DBS_LEN  3
#define DBS_DEC  4

//---------------------------------------------------------------------------//
// Creacion de DATAs en tiempo de ejecucion

static __aTDbV := {}        // Aqui se guardan los handle de clase

/* Funcion que genera clase especializada */

#ifdef __HARBOUR__

function TDbVirtual( cAlias, cClassName )

    local n := 0
    local hCls := 0
    local __oDb

    local TVCls := "T" + upper( if( empty( cClassName ), ;
                                   Alias( xArea( cAlias ) ), cClassName ) )

    if ( n := AScan( __aTDbV, { |aClass| aClass[ 1 ] == TVCls } ) ) == 0
        _HB_CLASS TVCls
        __oDb := HbClass():New( TVCls, { "TDBARRAY" } )
        __oDb:Create()
        hCls := __oDb:hClass
        AAdd( __aTDbV, { TVCls, hCls, 1 } )
    else
        ++__aTDbV[ n, 3 ]
        hCls := __aTDbV[ n, 2 ]
    endif
    return( __clsInst( hCls ) )

//---------------------------------------------------------------------------//

static function GenData( o, cName, i, aType )

local nClassH

    nClassH := o:ClassH

    __clsAddMsg( nClassH, cName, ;
        { | o | o:aRecords[ o:RecNo, i ] }, HB_OO_MSG_INLINE )
    __clsAddMsg( nClassH, "_" + cName, ;
        { | o, Val | o:aRecords[ o:RecNo, i ] := Val }, HB_OO_MSG_INLINE )

return( o )

#else

function TDbVirtual( cAlias, cClassName )

    local n      := 0
    local hCls   := 0
    local TVCls  := upper( "T" + if( empty( cClassName ), ;
                                     Alias( xArea( cAlias ) ), cClassName ) )

    if ( n := AScan( __aTDbV, { |aClass| aClass[ 1 ] == TVCls } ) ) == 0
        hCls := _ObjNewCls( TVCls, TDbArray() )
        AAdd( __aTDbV, { TVCls, hCls, 1 } )
    else
        ++__aTDbV[ n, 3 ]
        hCls := __aTDbV[ n, 2 ]
    endif

return( _ObjClsIns( hCls ) )

/* Funcion que crea las DataFields dinamicamente */

static function GenData( o, cName, i, aType )

    _ObjAddMet( o:ClassHandle(), NIL, aType, 3, cName, ;
        &( "{ | o | o:FieldGet( " + Str( i, 3 ) + " ) }" ) )
    _ObjAddMet( o:ClassHandle(), NIL, aType, 3, "_" + cName, ;
        &( "{ | o, Val | o:FieldPut( " + Str( i, 3) + ", Val ) }" ) )

return( o )

#endif

//----------------------------------------------------------------------------//

CLASS TDbArray

    DATA oDbf

    DATA bFilter

    DATA aFields,   ;
         aRecords,  ;
         aBlank,    ;
         aStatus        AS ARRAY

    DATA Eof,       ;
         Bof,       ;
         Used           AS LOGICAL

    DATA cAlias,    ;
         cComment       

    DATA nRecIni,   ;
         RecNo,     ;
         LastRec,   ;
         FCount         AS NUMERIC

    METHOD  New( cAlias, aRecords, lDatas, cComment ) CONSTRUCTOR

    METHOD  DefNew( cComment ) CONSTRUCTOR
    METHOD  AddField( cName, cType, nLen, nDec )
    METHOD  Activate()

    METHOD  Append()
    METHOD  Update( aVal )
    METHOD  Insert( aVal )  INLINE ::Append():Update( aVal )

    MESSAGE Delete()        METHOD _Delete()
    MESSAGE Zap()           METHOD _Zap()

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

    METHOD  Clean()         INLINE ::aRecords := {}

    METHOD  Syncronize()    INLINE ( ::oDbf:Goto( ::nRecIni ), Self )

    METHOD  FieldGet( nFld )       INLINE ( if( ::RecNo == 0, ::aBlank[ nFld ], ::aRecords[ ::RecNo, nFld ] ) )
    METHOD  FieldPut( nFld, Val )  INLINE ::aRecords[ ::RecNo, nFld ] := Val
    METHOD  FieldPos( cName )

    METHOD  FieldName( nFld ) INLINE ::aFields[ nFld, DBS_NAME ]
    METHOD  FieldType( nFld ) INLINE ::aFields[ nFld, DBS_TYPE ]
    METHOD  FieldLen( nFld )  INLINE ::aFields[ nFld, DBS_LEN  ]
    METHOD  FieldDec( nFld )  INLINE ::aFields[ nFld, DBS_DEC  ]

    METHOD  DbCore( cFileName )

    METHOD  Clone( lNew )  VIRTUAL

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

METHOD New( oDbf, aRecords, lDatas, cComment ) CLASS TDbArray

    local i     := 0
    local nLen  := 0
    local nRec  := 0

    DEFAULT lDatas := .f.

// Se supone que aRecords tiene la misma estructura que el record de la DBF

    ::oDbf     := oDbf
    ::cAlias   := "ARRAY"
    ::aRecords := if( ValType( aRecords ) == "A", oClone( aRecords ), {} )
    ::Eof      := .f.
    ::Bof      := .f.
    ::RecNo    := 0
    ::nRecIni  := 1
    ::cComment := if( ValType( cComment ) == "C", cComment, "" )
    ::aBlank   := {}
    ::aFields  := {}

    if ::oDbf:Used()

        // Carga el registro fantasma
        nRec   := ::oDbf:RecNo()
        nLen   := len( ::oDbf:aTField )

        ::aFields := Array( nLen )

        ::oDbf:GoTo( 0 )
        for i := 1 TO nLen
            aAdd( ::aBlank, ::oDbf:aTField[ i ]:GetVal() )
            if lDatas       // Si tiene que crear dataFields
                GenData( Self, ::oDbf:aTField[ i ]:cName, i, ::oDbf:aTField[ i ]:cType )
            end if
        next

        ::FCount := len( ::aBlank )
        ::oDbf:GoTo( nRec )

    endif

return( Self )

//---------------------------------------------------------------------------//

METHOD DefNew( cComment ) CLASS TDbArray

    ::cAlias   := "ARRAY"
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

METHOD AddField( cName, cType, nLen, nDec ) CLASS TDbArray

    local aRow := {}

    cName := upper( cName )
    cType := upper( cType )

    AAdd( aRow, cName )
    AAdd( aRow, cType )
    AAdd( aRow, nLen )
    AAdd( aRow, nDec )

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

   local nRec  := ::RecNo

   if ValType( n ) == "N" .and. n > 0
      ::Eof := .f.
      ::Bof := .f.
      if n > ::LastRec
         ::RecNo := ::LastRec
         ::Eof := .t.
      else
         ::RecNo := n
      end if
   end if

return( nRec )

//---------------------------------------------------------------------------//

METHOD _Delete() CLASS TDbArray

    ADel( ::aRecords, ::RecNo )
    ASize( ::aRecords, --::LastRec )

    ::GoTo( ::RecNo )

return( Self )

//---------------------------------------------------------------------------//

METHOD _Zap() CLASS TDbArray

    ::GoTop()
    while !::Eof()
       ::Delete()
       ::Skip()
    end while

return( Self )

//---------------------------------------------------------------------------//

METHOD Update( aVal ) CLASS TDbArray

    local lRet := .f.

    if ValType( aVal ) == "A"
        aSize( aVal )
        AEval( ::aRecords[ ::RecNo ], { | v, i | v := aVal[ i ] } )
        lRet := .t.
    endif

return( lRet )

//---------------------------------------------------------------------------//

METHOD Append() CLASS TDbArray

    AAdd( ::aRecords, aClone( ::aBlank ) )
    ::RecNo := ++::LastRec
    ::Eof   := ::Bof := .f.

return( Self )

//---------------------------------------------------------------------------//

METHOD Skip( n ) CLASS TDbArray

   local nPos  := 0

   DEFAULT n   := 1

   ::Eof       := .f.
   ::Bof       := .f.

   nPos        := ::RecNo + n
   if nPos > ::LastRec
      ::GoBottom()
      ::Eof    := .t.
   elseif nPos < 1
      ::GoTop()
      ::Bof    := .t.
   else
      ::RecNo  := nPos
   endif

return( Self )

//---------------------------------------------------------------------------//

METHOD Skipper( nSkip ) CLASS TDbArray

    local nSkipped := 0

    nSkipped   := Min( Max( nSkip, 1 - ::RecNo ), ::LastRec - ::RecNo )

    ::RecNo    += nSkipped

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
        oBrw:Refresh()
    endif

return( oBrw )

//---------------------------------------------------------------------------//

METHOD Load( bFor, bWhile, bOnPreLoad, bOnPostLoad ) CLASS TDbArray

    local i          := 0
    local aRec       := {}
    local nLen       := ::FCount
    local lTrigger

    ::nRecIni        := ::oDbf:RecNo()

    bFor             := if( ValType( bFor )   != "B", { || .t. }, bFor )
    bWhile           := if( ValType( bWhile ) != "B", { || !::oDbf:Eof() }, bWhile )

    while eval( bWhile, Self )

       if eval( bFor, Self )

          if bOnPreLoad != nil
             lTrigger := Eval( bOnPreLoad, Self )
             if Valtype( lTrigger ) == "L" .and. !lTrigger
                return .f.
             end if
          end if

          aRec := {}
          for i := 1 TO nLen
              aAdd( aRec, ::oDbf:aTField[ i ]:GetVal() )
          next
          aAdd( ::aRecords, aRec )

          ::RecNo    := 1

          if bOnPostLoad != nil
             lTrigger := Eval( bOnPostLoad, Self )
             if Valtype( lTrigger ) == "L" .and. !lTrigger
                return .f.
             end if
          end if

       endif

       ::oDbf:Skip( 1 )

    end while

    ::Syncronize()

    ::Eof := ::Bof := ( ( ::LastRec := ::RecCount() ) == 0 )

return( Self )

//---------------------------------------------------------------------------//

METHOD  FieldPos( cName ) CLASS TDbArray
return( AScan( ::aFields, { | aRow | aRow[ DBS_NAME ] == upper( cName ) } ) )

//---------------------------------------------------------------------------//

METHOD RecLoad( nRec, lAdd, bOnPreLoad, bOnPostLoad ) CLASS TDbArray

    local i    := 0
    local aRec := {}
    local nLen := ::FCount
    local lTrigger

    DEFAULT nRec := ::oDbf:RecNo()
    DEFAULT lAdd := .f.

    ::oDbf:Goto( nRec )

    if bOnPreLoad != nil
       lTrigger := Eval( bOnPreLoad, Self )
       if Valtype( lTrigger ) == "L" .and. !lTrigger
          return .f.
       end if
    end if

    for i := 1 TO nLen
       aAdd( aRec, ::oDbf:aTField[ i ]:GetVal() )
    next

    if lAdd
       AAdd( ::aRecords, aRec )
       ::RecNo := ++::LastRec
    else
       ::Update( aRec )
    end if

    if bOnPostLoad != nil
       return Eval( bOnPostLoad, Self )
    end if

return ( Self )

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
            endif
            ::Skip( 1 )
        end
    endif

return( Self )

//---------------------------------------------------------------------------//

METHOD RecSave( lAppend ) CLASS TDbArray

    local i    := 0
    local nLen := ::FCount

    lAppend    := if( ValType( lAppend ) != "L", .t., lAppend )

    if lAppend
        ::oDbf:Append()
    else
        ::oDbf:Load()
    end if

    for i := 1 TO nLen
        if !::oDbf:aTField[ i ]:lCalculate
            ::oDbf:FldPut( i, ::FieldGet( i ) )
        end if
    next

    ::oDbf:Save()

return( Self )

//---------------------------------------------------------------------------//

METHOD DbCore( cFileName ) CLASS TDbArray

    local lRet := .f.

    if ValType( cFileName ) == "C"
        DbCreate( cFileName, ::aFields )
        DbUseArea( .t.,, cFileName )
        ::nArea := Select()
        ::GoTop()
        ::Save( .t. )
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

METHOD LoadArray( aArray ) CLASS TDbArray

   ::aRecords  := aArray
   ::RecNo     := 1
   ::LastRec   := ::RecCount()

return( Self )

//---------------------------------------------------------------------------//

METHOD Seek( xVal, nField ) CLASS TDbArray

   local nScan       := 0
   local nLen        := len( xVal )

   DEFAULT  nField   := 1

   nScan := AScan( ::aRecords, { | aRow | SubStr( aRow[ nField ], 1, nLen ) == xVal } )
   if nScan != 0
      ::GoTo( nScan )
   end if

return ( nScan != 0 )

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