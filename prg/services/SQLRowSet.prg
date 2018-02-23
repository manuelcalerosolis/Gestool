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

   METHOD New()
   METHOD End()

   METHOD Get()                                       INLINE ( ::oRowSet )

   METHOD fieldGet( uField )                          INLINE ( if( !empty( ::oRowSet ), ::oRowSet:fieldget( uField ), ) )
   METHOD recCount()                                  INLINE ( if( !empty( ::oRowSet ), ::oRowSet:reccount(), ) )
   METHOD fieldValueByName( cColumn )                 INLINE ( if( !empty( ::oRowSet ), ::oRowSet:getValueByName( cColumn ), ) )

   METHOD saveRecno()                                 INLINE ( if( !empty( ::oRowSet ), ::nRecno := ::oRowSet:recno(), ) ) 
   METHOD restoreRecno()                              INLINE ( if( !empty( ::oRowSet ), ::oRowSet:goto( ::nRecno ), ) ) 
   METHOD gotoRecno( nRecno )                         INLINE ( if( !empty( ::oRowSet ), ::oRowSet:goto( nRecno ), ) ) 
   METHOD Recno( nRecno )                             INLINE ( if( !empty( ::oRowSet ) .and. empty( nRecno ), ::oRowSet:Recno(), ::oRowSet:goto( nRecno ) ) )

   METHOD goDown()                                    INLINE ( if( !empty( ::oRowSet ), ::oRowSet:skip(1), ) ) 
   METHOD goUp()                                      INLINE ( if( !empty( ::oRowSet ), ::oRowSet:skip(-1), ) ) 

   METHOD Find( nId )

   METHOD Build( cSentence )                    

   METHOD refreshAndFind( nId )                       INLINE ( ::Refresh(), ::Find( nId ) )
   METHOD buildAndFind( nId )                         INLINE ( ::Build(), ::Find( nId ) )

   METHOD freeRowSet()                                INLINE ( if( !empty( ::oRowSet ), ( ::oRowSet:free(), ::oRowSet := nil ), ) )

   METHOD getStatement()                              INLINE ( ::oStatement )
   METHOD freeStatement()                             INLINE ( if( !empty( ::oStatement ), ( ::oStatement:free(), ::oStatement := nil ), ) )

   METHOD Refresh()                                   INLINE ( if( !empty( ::oRowSet ), ::oRowSet:Refresh(), ) )

   METHOD IdFromRecno( aRecno, cColumnKey )
   METHOD UuidFromRecno( aRecno )                     INLINE ( ::IdFromRecno( aRecno, "uuid" ) )

   METHOD getFindValue()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                                      := oController

   ::oEvents                                          := Events():New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oEvents:End()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Build( cSentence )

   local oError

   if empty( cSentence )
      msgStop( "La sentencia esta vacia" )
      RETURN ( nil )
   end if 

   if !getSQLDatabase():parse( cSentence )
      msgStop( cSentence, "Sentencia no valida" )
      RETURN ( nil )
   end if 

   cursorWait()

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

   cursorWE()
   
RETURN ( ::oRowSet )

//---------------------------------------------------------------------------//

METHOD Find( cFind, cColumn )

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

   nRecno               := ::oRowSet:find( cFind, cColumn, .t. )

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

   cType                := ::oRowSet:fieldType( cColumn )

   do case
      case ( cType ) == "N"
         uFind          := val( alltrim( uFind ) )
      case ( cType ) == "C" .and. right( uFind, 1 ) != "*"
         uFind          += "*"
      case ( cType ) == "T" 
         if !empty( ctot( uFind ) )
            uFind       := ctot( uFind )
         else
            uFind       := nil
         end if 
   end case 

RETURN ( uFind )

//---------------------------------------------------------------------------//
