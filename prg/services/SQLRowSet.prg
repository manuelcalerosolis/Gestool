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

   METHOD New()
   METHOD End()

   METHOD build( cSentence )                    

   METHOD buildRowSetAndFind( idToFind )              INLINE ( ::buildRowSet(), ::findInRowSet( idToFind ) )

   METHOD getRowSet()                                 INLINE ( if( empty( ::oRowSet ), ::buildRowSet(), ), ::oRowSet )
   METHOD freeRowSet()                                INLINE ( if( !empty( ::oRowSet ), ( ::oRowSet:free(), ::oRowSet := nil ), ) )
   METHOD freeStatement()                             INLINE ( if( !empty( ::oStatement ), ( ::oStatement:free(), ::oStatement := nil ), ) )

   METHOD getRowSetRecno()                            INLINE ( ::getRowSet():recno() )
   METHOD setRowSetRecno( nRecno )                    INLINE ( ::getRowSet():goto( nRecno ) )
   METHOD getRowSetFieldGet( cColumn )                INLINE ( ::getRowSet():fieldget( cColumn ) )
   METHOD getRowSetFieldValueByName( cColumn )        INLINE ( ::getRowSet():getValueByName( cColumn ) )

   METHOD getSelectByColumn()                         VIRTUAL
   METHOD getSelectByOrder()                          VIRTUAL

   METHOD findInRowSet( idToFind )
   
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

METHOD build( cSentence )

   local oError

   if empty( cSentence )
      msgStop( "La sentencia esta vacia" )
      RETURN ( nil )
   end if 

   ::oEvents:fire( 'buildingRowSet')

   try

      ::freeRowSet()

      ::freeStatement()

      ::oStatement      := ::getDatabase():Query( cSentence )

      ::oStatement:setAttribute( ATTR_STR_PAD, .t. )
      
      ::oRowSet         := ::oStatement:fetchRowSet()

   catch oError

      eval( errorBlock(), oError )

   end

   ::oRowSet:goTop()

   ::oEvents:fire( 'builtRowSet')

RETURN ( ::oRowSet )

//---------------------------------------------------------------------------//

METHOD findInRowSet( idToFind )

   if empty( ::oRowSet )
      RETURN ( self )
   end if 

   DEFAULT idToFind  := ::idToFind

   if empty( idToFind ) .or. empty( ::cColumnKey )
      RETURN ( self )
   end if 

   if ::oRowSet:find( idToFind, ::cColumnKey, .t. ) == 0
      ::oRowSet:goTop()
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD RecnoToId( aRecno, cColumnKey )

   local aId            := {}

   DEFAULT cColumnKey   := 'id'

   aeval( aRecno, {|nRecno| ::oRowSet:goTo( nRecno ), aadd( aId, ::oRowSet:fieldget( cColumnKey ) ) } )

RETURN ( aId )

//---------------------------------------------------------------------------//
