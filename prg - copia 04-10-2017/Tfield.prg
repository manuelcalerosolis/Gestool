//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U                             //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TField (TDbf)                                                 //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gesti¢n de Campos                                             //
//----------------------------------------------------------------------------//

#include "Obj2Hb.ch"
#include "TDbfMsg.ch"

//----------------------------------------------------------------------------//

CLASS TField

    DATA cName, cType                        AS STRING
    DATA cPict, cComment       
    DATA nPos, nLen, nDec                    AS NUMERIC
    DATA bSetGet, bValid, bString, bDirect   AS BLOCK
    DATA lCalculate, lOEM                    AS LOGICAL
    DATA oDbf                                AS OBJECT
    DATA LowVal, Val, HighVal, Cargo, ;
         DefaultVal

    DATA lColAlign
    DATA nColSize
    DATA lHide
    DATA aBitmaps

    METHOD New( oDbf, cName, cType, nLen, nDec, cPict, DefaultVal, bValid, ;
                bSetGet, cComment, lColAlign, nColSize, lHide, aBitmaps ) CONSTRUCTOR

    METHOD Activate()

    METHOD Destroy()    INLINE Self  := nil, .t. 

    METHOD Blank()      INLINE ::Val := ::LowVal
    METHOD Load()       INLINE ::Val := ( ::oDbf:nArea )->( eval( ::bSetGet ) )
    METHOD Save()       INLINE ( ( ::oDbf:nArea )->( eval( ::bSetGet, ::Val ) ) )
    METHOD SetHigh()    INLINE ::Val := ::HighVal
    METHOD SetLow()     INLINE ::Val := ::LowVal
    METHOD SetDefault() INLINE ::Val := ::DefaultVal
    METHOD AsString()   INLINE transform( ::Val, ::cPict )
    METHOD Valid()
    METHOD GetVal()     INLINE ( ::oDbf:nArea )->( eval( ::bSetGet ) ) // mcs
    METHOD PutVal(Val)  INLINE ( ::oDbf:nArea )->( eval( ::bSetGet, Val ) )
    METHOD GetString()  INLINE transform( ( ::oDbf:nArea )->( eval( ::bSetGet ) ), if( ValType( ::cPict ) == "B", Eval( ::cPict, Self ), ::cPict ) ) // mcs

    METHOD FieldGet()   INLINE ( ::oDbf:nArea )->( FieldGet( ::nPos ) )
    MESSAGE FieldGetByName()  METHOD _FieldGetByName()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oDbf, cName, cType, nLen, nDec, cPict, DefaultVal, bValid, ;
            bSetGet, cComment, lColAlign, nColSize, lHide, aBitmaps ) CLASS TField

   local cDateFormat := ""

   cName := upper( cName )
   cType := upper( cType )

   BYNAME oDbf
   BYNAME cName
   BYNAME cType      DEFAULT "C"
   BYNAME nLen       DEFAULT 10
   BYNAME nDec       DEFAULT 0
   BYNAME cPict      DEFAULT "@"
   BYNAME cComment   DEFAULT cName 

   BYNAME lColAlign  DEFAULT ( ::cType == "N" )
   BYNAME nColSize   DEFAULT ( GetTextWidth( 0, replicate( "B", ::nLen ) ) )
   BYNAME lHide      DEFAULT .f.
   BYNAME aBitmaps   DEFAULT {}

   ::nPos := len( ::oDbf:ATField ) + 1

   ::lCalculate := .f.

   do case
      case ::cType == 'C'
           ::LowVal  := space( ::nLen )
           ::HighVal := replicate( "þ", ::nLen )
           if !empty( DefaultVal )
                DefaultVal := PADR( DefaultVal, ::nLen, " " )
           endif

      case ::cType  == "N"
           ::LowVal  := replicate( "0", ::nLen )
           ::HighVal := replicate( "9", ::nLen )
           if ::nDec > 0
                ::LowVal  := Stuff( ::LowVal,  ( ::nLen - ::nDec ), 1, '.' )
                ::HighVal := Stuff( ::HighVal, ( ::nLen - ::nDec ), 1, '.' )
           endif
           ::LowVal     := Val( ::LowVal )
           ::HighVal    := Val( ::HighVal )

      case ::cType == 'L'
           ::nLen       := 1
           ::nDec       := 0
           ::LowVal     := .f.
           ::HighVal    := .t.

      case ::cType == 'D'
           ::nLen       := 8
           ::nDec       := 0
           cDateFormat  := Set( _SET_DATEFORMAT, "dd/mm/yyyy" )
           ::LowVal     := CToD( "" )
           ::HighVal    := CToD( "31/12/2999" )
           Set( _SET_DATEFORMAT, cDateFormat )

      case ::cType == 'M'
           ::LowVal     := ::HighVal := ::DefaultVal := ""
           ::nLen       := 10
           ::nDec       := 0
           ::oDbf:lMemo := .t.

      case ::cType == 'B'
           ::lCalculate := .t.
           if bSetGet == nil
               bSetGet  := { || "" }
           end if
           BYNAME bSetGet
   endcase

   BYNAME DefaultVal DEFAULT ::LowVal
   BYNAME bValid     DEFAULT { || .t. }

   ::Val := ::LowVal

return( Self )

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TField

    ::bSetGet := if( ::lCalculate, ::bSetGet, ( ::oDbf:nArea )->( FieldBlock( ::cName ) ) ) //mcs
    ::bString := { || transform( if( ::oDbf:lBuffer, ::Val, ::GetVal() ), if( ValType( ::cPict ) == "B", Eval( ::cPict, Self ), ::cPict ) ) }
    ::bDirect := { || transform( ::FieldGetByName(), if( ValType( ::cPict ) == "B", Eval( ::cPict, Self ), ::cPict ) ) }// mcs

return( Self )

//----------------------------------------------------------------------------//

METHOD Valid() CLASS TField

    local lRet := .t.

    if !eval( ::bValid )
        lRet := ::oDbf:lValid := .f.
        ::oDbf:cFldInvalid  := ::cName
    endif

return( lRet )

//----------------------------------------------------------------------------//

METHOD _FieldGetByName() CLASS TField

    local Val
    local nPos := ( ::oDbf:nArea )->( FieldPos( ::cName ) )

    if nPos != 0
       Val     := ( ::oDbf:nArea )->( FieldGet( nPos ) )
    endif

return( Val )

//----------------------------------------------------------------------------//