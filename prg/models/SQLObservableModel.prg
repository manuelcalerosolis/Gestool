#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"

//---------------------------------------------------------------------------//

CLASS SQLObservableModel FROM SQLCompanyModel

   DATA aChanges

   DATA hFinalBuffer
   DATA hInitialBuffer  

   DATA nInitialAmount INIT 0
   DATA nFinalAmount

   METHOD storeInitialBuffer()         INLINE ( ::hInitialBuffer := hClone( ::hBuffer ) )
   METHOD storeFinalBuffer()           INLINE ( ::hFinalBuffer := hClone( ::hBuffer ) )

   METHOD storeInitialAmount()         INLINE ( ::nInitialAmount := ::oController:getRepository():selectTotalSummaryWhereUuid( ::oController:getModelBuffer("uuid") ) )

   METHOD storeFinalAmount()           INLINE ( ::nFinalAmount := ::oController:getRepository():selectTotalSummaryWhereUuid( ::oController:getModelBuffer("uuid") ) )

   METHOD insertBuffer( hBuffer, lIgnore )

   METHOD updateInsertedBuffer( hBuffer, nId ) ;
                                       INLINE ( ::Super():updateInsertedBuffer( hBuffer, nId ), ::storeFinalBuffer(), ::storeFinalAmount() )

   METHOD loadCurrentBuffer( id )

   METHOD updateBuffer( hBuffer )

   METHOD getBufferChanged()
      METHOD getBufferLine( cKey, uValue )
      METHOD getBufferRelation( hBuffer, cKey )
      METHOD getBufferText( cKey )

END CLASS

//---------------------------------------------------------------------------//

METHOD insertBuffer( hBuffer, lIgnore )

   local nId         := ::Super():insertBuffer( hBuffer, lIgnore )

   ::storeInitialBuffer()

RETURN ( nId )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer( id )                

   ::Super():loadCurrentBuffer( id )
   
   ::hInitialBuffer  := hClone( ::hBuffer )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updateBuffer( hBuffer )

   ::Super:updateBuffer()

   ::hFinalBuffer := hClone( ::hBuffer )

   ::storeFinalAmount()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getBufferChanged()

   ::aChanges     := {}

   heval( ::hInitialBuffer,;
      {|k,v| if( v != hget( ::hFinalBuffer, k ), ::getBufferLine( k, v ), ) } )

   aadd( ::aChanges, { "importe" => {  "old" => ::nInitialAmount,;
                                       "new" => ::nFinalAmount,;
                                       "relation_old" => "",;
                                       "relation_new" => "",;
                                       "text" => "importe" } })

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

