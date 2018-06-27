#include "FiveWin.Ch"
#include "Factu.ch" 

//----------------------------------------------------------------------------//

CLASS HistoryManager

   DATA hHash

   METHOD New()

   METHOD End()                              INLINE ( ::hHash := nil )

   METHOD Set( hHash )

   METHOD setKey( key, value )               INLINE ( hSet( ::hHash, key, value ) )

   METHOD getKey( key )
   
   METHOD isEqual( key, value )              

   METHOD isDiferent( key, value )           INLINE ( !( ::isEqual( key, value ) ) )

   METHOD say()                              INLINE ( msgInfo( hb_valtoexp( ::hHash ), "HistoryManager" ) )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( hHash )

   ::Set( hHash )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Set( hHash )

   if !empty( hHash )
      ::hHash  := hHash 
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getKey( key )

   if !hb_ishash( ::hHash )
      RETURN ( nil )
   end if 

   if hhaskey( ::hHash, key )
      RETURN ( hGet( ::hHash, key ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isEqual( key, value )

   local uKey  := ::getKey( key )

   if valtype( uKey ) != valtype( value )
      RETURN ( .f. )
   end if 

   if hb_ischar( uKey )
      RETURN ( alltrim( uKey ) == alltrim( value ) )
   end if 

   if hb_isnumeric( uKey )
      RETURN ( uKey == value )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//
