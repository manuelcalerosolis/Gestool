#include "Obj2Hb.ch"

//----------------------------------------------------------------------------//

CLASS TDbAux

   DATA     aBuffer                    AS ARRAY
   DATA     aFldNames                  AS ARRAY

   METHOD   New( oDbf ) CONSTRUCTOR

   METHOD   FieldGet( nPos )           INLINE ::aBuffer[ nPos ]

   METHOD   FieldPut( nPos, uValue )   INLINE ::aBuffer[ nPos ] := uValue

   METHOD   FieldPos( cMsg )

   ERROR HANDLER OnError( cMsg, nError )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oDbf ) CLASS TDbAux

   local i
   local nLen  := oDbf:FCount()

   ::aFldNames := {}
   ::aBuffer   := Array( nLen )

   for i := 1 to nLen
      AAdd( ::aFldNames, oDbf:FieldName( i ) )
   next

return( Self )

//---------------------------------------------------------------------------//

METHOD FieldPos( cMsg )

return ( AScan( ::aFldNames, { | cField | cMsg == RTrim( SubStr( cField, 1, 9 ) ) } ) )

//---------------------------------------------------------------------------//

METHOD OnError( cMsg, nError ) CLASS TDbAux

   local nField

   if SubStr( cMsg, 1, 1 ) == "_"
      if( ( nField := ::FieldPos( SubStr( cMsg, 2 ) ) ) != 0 )
         ::FieldPut( nField, GetParam( 1, 1 ) )
      else
         _ClsSetError( _GenError( nError, ::ClassName(), SubStr( cMsg, 2 ) ) )
      endif
   else
      if( ( nField := ::FieldPos( cMsg ) ) != 0 )
         return ::FieldGet( nField )
      else
         _ClsSetError( _GenError( nError, ::ClassName(), cMsg ) )
      endif
   endif

return nil

//---------------------------------------------------------------------------//