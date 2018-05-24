#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"

//---------------------------------------------------------------------------//

CLASS SQLRowSet 

   DATA oEvents

   DATA oRowSet 

   DATA oController

   DATA nRecno

   METHOD New()
   METHOD End()
   METHOD Free()                                      INLINE ( ::End() )

   METHOD Get()                                       INLINE ( ::oRowSet )

   METHOD fieldGet( uField )                          INLINE ( if( !empty( ::oRowSet ), ::oRowSet:fieldget( uField ), ) )
   METHOD recCount()                                  INLINE ( if( !empty( ::oRowSet ), ::oRowSet:reccount(), ) )
   METHOD fieldValueByName( cColumn )                 INLINE ( if( !empty( ::oRowSet ), ::oRowSet:getValueByName( cColumn ), ) )

   METHOD saveRecno()                                 INLINE ( if( !empty( ::oRowSet ), ::nRecno := ::oRowSet:recno(), ) ) 
   METHOD restoreRecno()                              INLINE ( if( !empty( ::oRowSet ), ::oRowSet:goto( ::nRecno ), ) ) 
   METHOD gotoRecno( nRecno )                         INLINE ( if( !empty( ::oRowSet ), ::oRowSet:goto( nRecno ), ) ) 
   METHOD goTop()                                     INLINE ( if( !empty( ::oRowSet ), ::oRowSet:goTop(), ) )
   METHOD Skip()                                      INLINE ( if( !empty( ::oRowSet ), ::oRowSet:Skip(), ) )
   METHOD Recno( nRecno )                             INLINE ( if( !empty( ::oRowSet ) .and. empty( nRecno ), ::oRowSet:Recno(), ::oRowSet:goto( nRecno ) ) )
   METHOD Eof()                                       INLINE ( if( !empty( ::oRowSet ), ::oRowSet:eof(), ) ) 

   METHOD goDown()                                    INLINE ( if( !empty( ::oRowSet ), ::oRowSet:skip(1), ) ) 
   METHOD goUp()                                      INLINE ( if( !empty( ::oRowSet ), ::oRowSet:skip(-1), ) ) 

   METHOD FindString( nId )
   METHOD FindId( nId )

   METHOD Build( cSentence )          
   METHOD BuildPad( cSentence )                       INLINE ::Build( cSentence, .t. )          

   METHOD refreshAndFindId( nId )                     INLINE ( ::Refresh(), ::FindId( nId ) )
   METHOD buildAndFindId( nId )                       INLINE ( ::Build(), ::FindId( nId ) )

   METHOD refreshAndFindString( cFind, cColumn )      INLINE ( ::Refresh(), ::FindString( cFind, cColumn ) )
   METHOD buildAndFindString( cFind, cColumn )        INLINE ( ::Build(), ::FindString( cFind, cColumn ) )

   METHOD freeRowSet()                                INLINE ( if( !empty( ::oRowSet ), ( ::oRowSet:free(), ::oRowSet := nil ), ) )

   METHOD Refresh()                                   INLINE ( if( !empty( ::oRowSet ), ::oRowSet:Refresh(), ) )

   METHOD IdFromRecno( aRecno, cColumnKey )
   METHOD UuidFromRecno( aRecno )                     INLINE ( ::IdFromRecno( aRecno, "uuid" ) )

   METHOD getFindValue()

   METHOD setFilter( bFilter )                        INLINE ( if( !empty( ::oRowSet ), ::oRowSet:setFilter( bFilter ), ) ) 

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

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Build( cSentence, lPad )

   local oError

   DEFAULT lPad   := .f.

   if empty( cSentence )
      msgStop( "La sentencia esta vacia", "SQLRowSet" )
      RETURN ( nil )
   end if 

   if !getSQLDatabase():parse( cSentence )
      msgStop( cSentence, "Sentencia no valida" )
      logwrite( cSentence )
      RETURN ( nil )
   end if 

   cursorWait()

   ::oEvents:fire( 'buildingRowSet' )

   try 

      ::freeRowSet()

      ::oRowSet      := getSQLDatabase():RowSet( cSentence )

      ::oRowSet:setAttribute( STMT_ATTR_STR_PAD, lPad ) 
      
      ::oRowSet:Load()

   catch oError

      eval( errorBlock(), oError )

   end

   ::oRowSet:goTop()

   ::oEvents:fire( 'builtRowSet' )

   cursorWE()
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FindString( cFind, cColumn )

   local cType
   local nRecno         := 0

   DEFAULT cColumn      := 'id'

   if empty( ::oRowSet )
      RETURN ( .f. )
   end if 

   if empty( cFind )
      RETURN ( .f. )
   end if 

   cFind                := ::getFindValue( cFind, cColumn )

   if empty( cFind )
      RETURN ( .f. )
   end if 

   ::saveRecno()

   nRecno               := ::oRowSet:findString( cFind, cColumn )

   if nRecno == 0
      ::restoreRecno()
   end if

RETURN ( nRecno != 0 )

//---------------------------------------------------------------------------//

METHOD FindId( nId )

   local nRecno         := 0

   if empty( ::oRowSet )
      RETURN ( .f. )
   end if 

   if empty( nId )
      RETURN ( .f. )
   end if 

   ::saveRecno()

   nRecno               := ::oRowSet:find( nId, 'id' )

   if nRecno == 0
      ::restoreRecno()
   end if

RETURN ( nRecno != 0 )

//---------------------------------------------------------------------------//

METHOD IdFromRecno( aRecno, cColumnKey )

   local aId            := {}

   DEFAULT cColumnKey   := 'id'

   aeval( aRecno, {|nRecno| ::oRowSet:goTo( nRecno ), aadd( aId, ::oRowSet:fieldget( cColumnKey ) ) } )

RETURN ( aId )

//---------------------------------------------------------------------------//

METHOD getFindValue( uFind, cColumn )

   local cType

   if !( hb_ischar( uFind ) )
      RETURN ( uFind )
   end if 

   if empty( ::oRowSet )
      RETURN ( uFind )
   end if 

   if right( uFind, 1 ) != "*"
      uFind       += "*"
   end if 

RETURN ( uFind )

//---------------------------------------------------------------------------//
