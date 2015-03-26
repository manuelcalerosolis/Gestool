// FiveWin C language structures object oriented support

#include "FiveWin.Ch"

#define MEMBER_NAME   1
#define MEMBER_TYPE   2
#define MEMBER_LEN    3
#define MEMBER_OFFSET 4

//----------------------------------------------------------------------------//

CLASS TStruct

   DATA   cBuffer
   DATA   aMembers

   METHOD New() CONSTRUCTOR

   METHOD AddMember( cName, nType, nLen )
   METHOD SetMember( nMember, uData )
   METHOD GetMember( nMember )

   METHOD SizeOf() INLINE Len( ::cBuffer )

   ERROR HANDLER OnError( cMsg, nError )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS TStruct

   ::cBuffer  = ""
   ::aMembers = {}

return nil

//----------------------------------------------------------------------------//

METHOD AddMember( cName, nType, nLen ) CLASS TStruct

   local nOffset

   if nLen == nil
      do case
         case nType == BYTE .or. nType == CHAR
            nLen = 1

         case nType == WORD .or. nType == _INT .or. nType == BOOL
            nLen = 2

         case nType == LONG .or. nType == DWORD
            nLen = 4
      endcase
   endif

   if Len( ::aMembers ) == 0
      nOffset = 0
   else
      nOffset = ATail( ::aMembers )[ MEMBER_OFFSET ] + ATail( ::aMembers )[ MEMBER_LEN ]
   endif

   AAdd( ::aMembers, { Upper( cName ), nType, nLen, nOffset } )
   ::cBuffer += Replicate( Chr( 0 ), nLen )

return nil

//----------------------------------------------------------------------------//

METHOD OnError( cMsg, nError ) CLASS TStruct

   local nMember

   cMsg = Upper( cMsg )

   if SubStr( cMsg, 1, 1 ) == "_"  // Set
      cMsg = SubStr( cMsg, 2 )
      if ( nMember := AScan( ::aMembers,;
            { | aMember | aMember[ 1 ] == cMsg } ) ) != 0
         return ::SetMember( nMember, GetParam( 1, 1 ) )
      else
         _ClsSetError( _GenError( nError, ::ClassName(), cMsg ) )
      endif
   else                            // Get
      if ( nMember := AScan( ::aMembers,;
            { | aMember | aMember[ 1 ] == cMsg } ) ) != 0
         return ::GetMember( nMember )
      else
         _ClsSetError( _GenError( nError, ::ClassName(), cMsg ) )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetMember( nMember, uData ) CLASS TStruct

   local nType    := ::aMembers[ nMember ][ MEMBER_TYPE ]
   local nLen     := ::aMembers[ nMember ][ MEMBER_LEN ]
   local nOffset  := ::aMembers[ nMember ][ MEMBER_OFFSET ]
   local cType := ValType( uData )

   do case
      case nType == BYTE .or. nType == CHAR
         do case
            case cType == "N"
                 uData = Chr( uData )

            case cType == "C"
                 uData = Asc( SubStr( uData, 1, 1 ) )

            case cType == "L"
                 uData = If( uData, Chr( 1 ), Chr( 0 ) )

            otherwise
                 uData = Chr( 0 )
         endcase

         ::cBuffer = If( nOffset > 0, SubStr( ::cBuffer, 1, nOffset ), "" ) + ;
                   uData + SubStr( ::cBuffer, nOffset + 2 )

      case nType == WORD .or. nType == _INT
         do case
            case cType == "N"
                 uData = I2Bin( uData )

            case cType == "C"
                 uData = Asc( SubStr( uData, 1, 1 ) ) + If( Len( uData ) > 1,;
                         Asc( SubStr( uData, 2, 1 ) ), "" )

            case cType == "L"
                 uData = If( uData, I2Bin( 1 ), I2Bin( 0 ) )

            otherwise
                 uData = I2Bin( 0 )
         endcase

         ::cBuffer = If( nOffset > 0, SubStr( ::cBuffer, 1, nOffset ), "" ) + ;
                   uData + SubStr( ::cBuffer, nOffset + 3 )

      case nType == BOOL
         do case
            case cType == "N"
                 uData = If( uData != 0, I2Bin( 1 ), I2Bin( 0 ) )

            case cType == "C"
                 uData = If( ! Empty( uData ), I2Bin( 1 ), I2Bin( 0 ) )

            case cType == "L"
                 uData = If( uData, I2Bin( 1 ), I2Bin( 0 ) )

            otherwise
                 uData = I2Bin( 0 )
         endcase

         ::cBuffer = If( nOffset > 0, SubStr( ::cBuffer, 1, nOffset ), "" ) + ;
                   uData + SubStr( ::cBuffer, nOffset + 3 )

      case nType == LONG .or. nType == DWORD
         do case
            case cType == "N"
                 uData = L2Bin( uData )

            case cType == "L"
                 uData = If( uData, L2Bin( 1 ), L2Bin( 0 ) )

            otherwise
                 uData = L2Bin( 0 )
         endcase

         ::cBuffer = If( nOffset > 0, SubStr( ::cBuffer, 1, nOffset ), "" ) + ;
                   uData + SubStr( ::cBuffer, nOffset + 5 )

      case nType == STRING
         do case
            case cType == "N"
                 uData = PadR( AllTrim( Str( uData ) ), nLen )

            case cType == "C"
                 uData = PadR( uData, nLen )

            otherwise
                 uData = Space( nLen )
         endcase

         ::cBuffer = If( nOffset > 0, SubStr( ::cBuffer, 1, nOffset ), "" ) + ;
                   uData + SubStr( ::cBuffer, nOffset + nLen + 1 )

      otherwise
         msgStop( "Member type conversion not implemented yet!" )

   endcase

return uData

//----------------------------------------------------------------------------//

METHOD GetMember( nMember ) CLASS TStruct

   local nType   := ::aMembers[ nMember ][ MEMBER_TYPE ]
   local nLen    := ::aMembers[ nMember ][ MEMBER_LEN ]
   local nOffset := ::aMembers[ nMember ][ MEMBER_OFFSET ]

   do case
      case nType == BYTE .or. nType == CHAR
         return Asc( SubStr( ::cBuffer, nOffset + 1, 1 ) )

      case nType == WORD .or. nType == _INT
         return Bin2I( SubStr( ::cBuffer, nOffset + 1, 2 ) )

      case nType == BOOL
         return Bin2I( SubStr( ::cBuffer, nOffset + 1, 2 ) ) == 1

      case nType == LONG .or. nType == DWORD
         return Bin2L( SubStr( ::cBuffer, nOffset + 1, 4 ) )

      case nType == STRING
         return AllTrim( SubStr( ::cBuffer, nOffset + 1, nLen ) )

      otherwise
         msgStop( "Member type conversion not implemented yet!" )

   endcase

return nil

//----------------------------------------------------------------------------//

function ThisStruct( oStruct ) // support function for structure xBase commands

   static oStructure

   if pcount() > 0
      oStructure = oStruct
   endif

return oStructure

//----------------------------------------------------------------------------//