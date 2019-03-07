#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"

//---------------------------------------------------------------------------//

CLASS SQLObservableModel FROM SQLCompanyModel

   DATA aChanges

   DATA hFinalBuffer
   DATA hInitialBuffer

   METHOD insertBuffer( hBuffer, lIgnore )

   METHOD updateInsertedBuffer( hBuffer, nId )

   METHOD getBufferChanged()
      METHOD getBufferLine( cKey, uValue )
      METHOD getBufferRelation( hBuffer, cKey )
      METHOD getBufferText( cKey )

END CLASS

//---------------------------------------------------------------------------//

METHOD insertBuffer( hBuffer, lIgnore )

   local nId         := ::Super():insertBuffer( hBuffer, lIgnore )

   ::hInitialBuffer  := hClone( ::hBuffer )

RETURN ( nId )

//---------------------------------------------------------------------------//

METHOD updateInsertedBuffer( hBuffer, nId )

   ::Super():updateInsertedBuffer( hBuffer, nId )

   ::hFinalBuffer    := hClone( ::hBuffer )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getBufferChanged()

   ::aChanges     := {}

   heval( ::hInitialBuffer,;
      {|k,v| if( v != hget( ::hFinalBuffer, k ), ::getBufferLine( k, v ), ) } )

RETURN ( ::aChanges )

//---------------------------------------------------------------------------//

METHOD getBufferLine( cKey, uValue )

   aadd( ::aChanges,;
      { cKey => { "old"          => uValue,;
                  "new"          => hget( ::hFinalBuffer, cKey ),;
                  "relation_old" => ::getBufferRelation( ::hInitialBuffer, cKey ),;
                  "relation_new" => ::getBufferRelation( ::hFinalBuffer, cKey ),;
                  "text"         => ::getBufferText( cKey ) } } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getBufferRelation( hBuffer, cKey )

   local uRelation   

   if hhaskey( hget( ::hColumns, cKey ), "relation" )
      uRelation   := eval( hget( hget( ::hColumns, cKey ), "relation" ), hget( hBuffer, cKey ) )   
   end if 

RETURN ( uRelation )

//---------------------------------------------------------------------------//

METHOD getBufferText( cKey )

   local cText

   if hhaskey( hget( ::hColumns, cKey ), "text" )
      cText       := hget( hget( ::hColumns, cKey ), "text" )
   end if

RETURN ( cText )

//---------------------------------------------------------------------------//

