#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"

//---------------------------------------------------------------------------//

CLASS SQLRowSet 

   DATA oEvents

   DATA oRowSet 

   DATA oStatement

   DATA oController

   DATA nRecno

   DATA nId

   METHOD New()
   METHOD End()

   METHOD Get()                                       INLINE ( ::oRowSet )

   METHOD fieldget( nField )                          INLINE ( ::oRowSet:fieldget( nField ) )

   METHOD saveRecno()                                 INLINE ( ::nRecno := ::oRowSet:recno() ) 
   METHOD restoreRecno()                              INLINE ( ::oRowSet:goto( ::nRecno ) ) 
   METHOD gotoRecno( nRecno )                         INLINE ( ::oRowSet:goto( nRecno ) ) 

   METHOD Find( nId )

   METHOD Build( cSentence )                    

   METHOD refreshAndFind( nId )                       INLINE ( ::Refresh(), ::Find( nId ) )
   METHOD buildAndFind( nId )                         INLINE ( ::Build(), ::Find( nId ) )

   METHOD getRowSet()                                 INLINE ( if( empty( ::oRowSet ), ::Build(), ), ::oRowSet )
   METHOD freeRowSet()                                INLINE ( if( !empty( ::oRowSet ), ( ::oRowSet:free(), ::oRowSet := nil ), ) )

   METHOD getStatement()                              INLINE ( ::oStatement )
   METHOD freeStatement()                             INLINE ( if( !empty( ::oStatement ), ( ::oStatement:free(), ::oStatement := nil ), ) )

   METHOD Refresh()                                   INLINE ( ::oRowSet:Refresh() )

   METHOD Recno( nRecno )                             INLINE ( if( empty( nRecno ), ::getRowSet():Recno(), ::getRowSet():goto( nRecno ) ) )
   METHOD FieldGet( cColumn )                         INLINE ( ::oRowSet:fieldget( cColumn ) )
   METHOD FieldValueByName( cColumn )                 INLINE ( ::oRowSet:getValueByName( cColumn ) )

   // METHOD getSelectByColumn()                         VIRTUAL
   // METHOD getSelectByOrder()                          VIRTUAL
   
   METHOD RecnoToId( aRecno, cColumnKey )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                                      := oController

   ::oEvents                                          := Events():New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oEvents:End()
   
   ::freeRowSet()

   ::freeStatement()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Build( cSentence )

   local oError

   if empty( cSentence )
      msgStop( "La sentencia esta vacia" )
      RETURN ( nil )
   end if 

   ::oEvents:fire( 'buildingRowSet')

   try

      ::freeRowSet()

      ::freeStatement()

      ::oStatement      := getSQLDatabase():Query( cSentence )

      ::oStatement:setAttribute( ATTR_STR_PAD, .t. )
      
      ::oRowSet         := ::oStatement:fetchRowSet()

   catch oError

      eval( errorBlock(), oError )

   end

   ::oRowSet:goTop()

   ::oEvents:fire( 'builtRowSet')

RETURN ( ::oRowSet )

//---------------------------------------------------------------------------//

METHOD Find( cFind, cColumnKey )

   DEFAULT cColumnKey   := 'id'

   if empty( ::oRowSet )
      RETURN ( .t. )
   end if 

   if empty( cFind )
      RETURN ( .t. )
   end if 

   ::saveRecno()

   if ::oRowSet:find( cFind, cColumnKey, .t. ) == 0
      ::restoreRecno()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD RecnoToId( aRecno, cColumnKey )

   local aId            := {}

   DEFAULT cColumnKey   := 'id'

   aeval( aRecno, {|nRecno| ::oRowSet:goTo( nRecno ), aadd( aId, ::oRowSet:fieldget( cColumnKey ) ) } )

RETURN ( aId )

//---------------------------------------------------------------------------//
