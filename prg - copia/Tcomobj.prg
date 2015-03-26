// Class TComObject to support COM interface

#include "FiveWin.Ch"

//----------------------------------------------------------------//

CLASS TComObject

   DATA   nIDispatch

   METHOD New( cClassName ) CONSTRUCTOR

   METHOD End() INLINE OleUninitialize()

   METHOD ClassName() INLINE OleGetProperty( ::nIDispatch, "ClassName" )

   METHOD Invoke( cMethodName, uParam1, uParam2, uParam3 )

   #ifdef __CLIPPER__
      ERROR HANDLER OnError( cMsg, nError )
   #else
      ERROR HANDLER OnError( uParam )
   #endif

ENDCLASS

//----------------------------------------------------------------//

METHOD New( cClassName ) CLASS TComObject

   if ValType( cClassName ) == "C"
      ::nIDispatch = CreateOleObject( cClassName )
   endif

   if ValType( cClassName ) == "N"  // nIDispatch is already instantiated
      ::nIDispatch = cClassName
   endif

return Self

//----------------------------------------------------------------//

METHOD Invoke( cMethodName, uParam1, uParam2, uParam3 ) CLASS TComObject

   local nParams := PCount() - 1
   local nIDispatch

   do case
      case nParams == 0
           OleInvoke( ::nIDispatch, cMethodName )

      case nParams == 1
           OleInvoke( ::nIDispatch, cMethodName, uParam1 )

      case nParams == 2
           OleInvoke( ::nIDispatch, cMethodName, uParam1, uParam2 )

      case nParams == 3
           OleInvoke( ::nIDispatch, cMethodName, uParam1, uParam2, uParam3 )

      otherwise
           msgStop( "Please modify Class TComObject METHOD Invoke " + ;
                     "to accept more parameters" )
   endcase

   if ( nIDispatch := OleGetResult() ) != 0
      return TComObject():New( nIDispatch )
   endif

return nil

//----------------------------------------------------------------//

#ifdef __CLIPPER__
   METHOD OnError( cMsg, nError ) CLASS TComObject
#else
   METHOD OnError( uParam ) CLASS TComObject

   local cMsg := __GetMessage()
#endif
   local uResult

   if SubStr( cMsg, 1, 1 ) != "_"  // Get property
      uResult = OleGetProperty( ::nIDispatch, cMsg )
      if OleIsObject()
         uResult = TComObject():New( uResult )
      endif
   else
      #ifdef __CLIPPER__
         return OleSetProperty( ::nIDispatch, SubStr( cMsg, 2 ), GetParam( 1, 1 ) )
      #else
         return OleSetProperty( ::nIDispatch, SubStr( cMsg, 2 ), uParam )
      #endif
   endif

return uResult

//----------------------------------------------------------------//