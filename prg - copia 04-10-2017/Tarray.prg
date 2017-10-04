//----------------------------------------------------------------------------//
// Archivo        : TARRAY.PRG
// Aplicacion     : Clase OOPS
// Version        : 1.2
// Descripcion    : Array orientado a objetos
// Lenguaje       : CA-Clipper 5.x + FiveWin's OOPS
// Fecha Original : 01/05/1999 V1.0
// Fecha Upgrade  : 12/07/2000 V1.1, 18/07/2000 V1.2
// Copyright      : (c) 1994-2000 Hernan Diego Ceccarelli checanet@tutopia.com
//----------------------------------------------------------------------------//

#include "objects.ch"

STATIC aTArray

//----------------------------------------------------------------------------//

Function __StructNew( aInit )

 LOCAL oTArray, oTArrayPrevio
    oTArray:= TArray():New()
    If aInit != Nil
       oTArray:aData:= aInit
    EndIf

    If aTArray == Nil          // Primera estructura
       aTArray:= { oTArray }
    Else
       oTArrayPrevio:= ATail( aTArray )
       oTArrayPrevio:aBuffer[ Len(oTArrayPrevio:aBuffer) ]:= oTArray
       Aadd( oTArrayPrevio:aFieldsObj, oTArray )
       Aadd( aTArray, oTArray ) // Anidado
    EndIf

return oTArray

//----------------------------------------------------------------------------//

Function __StructField( cName, uInit )

 LOCAL oTArray:= ATail( aTArray )
    oTArray:AddField( PadR( cName, 8 ), uInit )

return .t.

//----------------------------------------------------------------------------//

Function __StructEnd()

 LOCAL nLen:= Len( aTArray )
    If nLen == 1
       aTArray:= Nil
    Else
       ASize( aTArray, nLen - 1 )
    EndIf
return .t.

//----------------------------------------------------------------------------//
CLASS TArray

   DATA aData
   DATA aFields
   DATA aBuffer
   DATA lCheckUpper INIT .t.
   DATA aFieldsObj

   METHOD  New() CONSTRUCTOR

   METHOD  AddField()

   ERROR HANDLER ArrayErrorHand()

ENDCLASS


//----------------------------------------------------------------------------//

METHOD New() CLASS TArray

    ::aData       := {} // Array multidimensional que aloja los datos
    ::aFields     := {} // Array con nombres de los campos
    ::aBuffer     := {} // Array con el valor del Buffer. Idem tama¤o que ::aFields.
    ::aFieldsObj  := {}

return self

//----------------------------------------------------------------------------//

METHOD AddField( cName, uInit ) CLASS TArray
    aAdd( ::aFields, Upper( cName ) )
    aAdd( ::aBuffer, uInit )
return .t.

//----------------------------------------------------------------------------//

METHOD ArrayErrorHand( cMethod, nError ) CLASS TArray

 LOCAL lAssign:= .f.
 LOCAL nId
 LOCAL lExact:= Set( _SET_EXACT, .t. )
 LOCAL uDev

    If SubStr( cMethod, 1, 1 ) == '_'
       lAssign:= .t.
       cMethod:= SubStr( cMethod, 2 )
    EndIf

    If ::lCheckUpper
       AEval( ::aFields, {|cVal,nId| ::aFields[nId]:= Upper(cVal) } )
       ::lCheckUpper:= .f.
    EndIf

    If ( nId:= AScan( ::aFields, cMethod ) ) > 0
       If lAssign
          uDev:= GetParam( 1, 1 )  /// Traigo el par metro del Stack de Clipper
          ::aBuffer[ nId ]:= uDev
       Else
          uDev:= ::aBuffer[ nId ]
       EndIf
    Else
       uDev:= _ClsSetError( _GenError( nError, ::ClassName, cMethod ) )
    EndIf

    Set( _SET_EXACT, lExact )

return uDev

//----------------------------------------------------------------------------//