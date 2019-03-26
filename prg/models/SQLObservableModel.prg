#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"

//---------------------------------------------------------------------------//

CLASS SQLObservableModel FROM SQLCompanyModel

   DATA aChanges

   DATA hFinalBuffer
   DATA hInitialBuffer  

   DATA nInitialAmount INIT 0.00
   DATA nFinalAmount

   METHOD setLogic( uValue )

   METHOD storeInitialBuffer()

   METHOD storeFinalBuffer()           

   METHOD storeInitialAmount()         

   METHOD storeFinalAmount()           

   METHOD insertBuffer( hBuffer, lIgnore )

   METHOD updateInsertedBuffer( hBuffer, nId ) ;
                                       INLINE ( ::Super():updateInsertedBuffer( hBuffer, nId ), ::storeFinalBuffer(), ::storeFinalAmount() )

   METHOD loadCurrentBuffer( id )

   METHOD updateBuffer( hBuffer )

   METHOD loadDuplicateBuffer( id, hFields ) 

   METHOD getBufferChanged()
      METHOD getBufferLine( cKey, uValue )
      METHOD getBufferRelation( hBuffer, cKey )
      METHOD getBufferText( cKey )
      METHOD getAmountChanged()

END CLASS

//---------------------------------------------------------------------------//

METHOD insertBuffer( hBuffer, lIgnore )

   local nId         := ::Super():insertBuffer( hBuffer, lIgnore )

   ::storeInitialBuffer()

   ::storeFinalBuffer()

   ::storeFinalAmount()

RETURN ( nId )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer( id )                

   ::Super():loadCurrentBuffer( id )
   
   ::storeInitialBuffer()

   ::storeInitialAmount()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updateBuffer( hBuffer )

   ::Super:updateBuffer()

   ::hFinalBuffer := hClone( ::hBuffer )

   ::storeFinalAmount()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadDuplicateBuffer( id, hFields ) 

   ::Super:loadDuplicateBuffer(id, hFields)

   ::storeInitialBuffer()

   ::storeInitialAmount()
   
RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD getBufferChanged()

   ::aChanges     := {}

   if !( hb_ishash( ::hInitialBuffer ) )
      RETURN ( ::aChanges )
   end if 

   if !( hb_ishash( ::hFinalBuffer ) )
      RETURN ( ::aChanges )
   end if 

   heval( ::hInitialBuffer,;
      {|k,v| if( v != hget( ::hFinalBuffer, k ), ::getBufferLine( k, v ), ) } )
 
   ::getAmountChanged()

RETURN ( ::aChanges )

//---------------------------------------------------------------------------//

METHOD getBufferLine( cKey, uValue )

   if cKey == "updated_at"
      RETURN ( nil )
   end if

   aadd( ::aChanges,;
      { cKey => { "old"          => ::setLogic( alltrim( hb_valtostr( uValue ) ) ),;
                  "new"          => ::setLogic( alltrim( hb_valtostr( hget( ::hFinalBuffer, cKey ) ) ) ) ,;
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

METHOD getAmountChanged()

   if ::nInitialAmount != ::nFinalAmount

      aadd( ::aChanges, { "importe" => {  "old" => ::nInitialAmount,;
                                          "new" => ::nFinalAmount,;
                                          "text" => "Importe" } })
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setLogic( uValue )

   if uValue == ".F."
      RETURN( "inactivo" )
   end if

   if uValue == ".T."
      RETURN ("activo")
   end if 

RETURN( uValue )

//---------------------------------------------------------------------------//

METHOD storeInitialBuffer()

   if !( hb_ishash( ::hBuffer ) )
      RETURN ( NIL )
   end if 

RETURN ( ::hInitialBuffer := hClone( ::hBuffer ) )

//---------------------------------------------------------------------------//

METHOD storeFinalBuffer()

   if !( hb_ishash( ::hBuffer ) )
      RETURN ( NIL )
   end if 

RETURN ( ::hFinalBuffer := hClone( ::hBuffer ) )

//---------------------------------------------------------------------------//

METHOD storeInitialAmount()

   if empty(::oController)
      RETURN ( nil )
   end if 

   if empty( ::oController:getModelBuffer( "uuid" ) )
      RETURN ( nil )
   end if 

RETURN ( ::nInitialAmount := round( ::oController:getRepository():getTotalDocument( ::oController:getModelBuffer( "uuid" ) ), 2 ) )

//---------------------------------------------------------------------------//

METHOD storeFinalAmount()

   if empty(::oController)
      RETURN ( nil )
   end if 

   if empty( ::oController:getModelBuffer( "uuid" ) )
      RETURN ( nil )
   end if 

RETURN ( ::nFinalAmount := round( ::oController:getRepository():getTotalDocument( ::oController:getModelBuffer( "uuid" ) ), 2 ) )

//---------------------------------------------------------------------------//
