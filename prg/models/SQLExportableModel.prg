#include "fivewin.ch"
#include "factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLExportableModel FROM SQLBaseModel

   DATA aFetch

   DATA cFileToExport

   METHOD New( oController )

   METHOD setFileToExport( cFileToExport )   INLINE ( ::cFileToExport := cFileToExport )
   METHOD getFileToExport()                  INLINE ( ::cFileToExport )

   METHOD getSentenceNotSent()

   METHOD selectNotSentToJson( cFile )

   METHOD selectFetchToHash( cSentence )

   METHOD saveToJson( cFile )

   METHOD selectFetchToJson( cSentence, cFile )

   METHOD insertFromJson( cFile )

   METHOD getSentenceSentFromFetch()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cFileToExport                           := cPatOut() + ::cTableName + ".json" 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getSentenceNotSent()

   local cSentence   := "SELECT * FROM " + ::cTableName + " "

   cSentence         +=    "WHERE empresa = " + quoted( cCodEmp() ) + " "

   cSentence         +=       "AND enviado IS NULL"

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD selectNotSentToJson( cFile )

   local cSentence   := ::getSentenceNotSent()

RETURN ( ::selectFetchToJson( cSentence, cFile ) )

//---------------------------------------------------------------------------//

METHOD selectFetchToHash( cSentence )

   logwrite( cSentence )

   ::fireEvent( 'selectingFetchToHash' )   

   ::aFetch          := ::getDatabase():selectFetchHash( cSentence, .f. )

   ::fireEvent( 'selectedFetchToHash' )   

RETURN ( ::aFetch )

//---------------------------------------------------------------------------//

METHOD saveToJson( cFile )

   DEFAULT cFile     := ::getFileToExport()

   ::fireEvent( 'savingToJson' )   

   if hb_memowrit( cFile, hb_jsonencode( ::aFetch, .t. ) )
      RETURN ( .t. )
   end if 

   ::fireEvent( 'savedToJson' )   

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD selectFetchToJson( cSentence, cFile )

   ::selectFetchToHash( cSentence, .f. )

   if !hb_isarray( ::aFetch ) 
      RETURN ( .f. )
   end if

   ::saveToJson( cFile )

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD insertFromJson( cFile )

   local cJson
   local aJson
   local hBuffer

   if !file( cFile )
      RETURN ( .f. )
   end if 

   cJson             := memoread( cFile )

   if empty( cJson )
      RETURN ( .f. )
   end if 

   hb_jsondecode( cJson, @aJson )

   if !hb_isarray( aJson )
      RETURN ( .f. )
   end if 

   for each hBuffer in aJson
      ::insertOnDuplicate( hBuffer )
   next

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getSentenceSentFromFetch()

   local cSentence 

   if empty( ::aFetch )
      RETURN ( nil )
   end if  

   cSentence         := "UPDATE " + ::cTableName + " SET "

   cSentence         +=    "enviado = " + toSQLString( hb_datetime() ) + " "

   cSentence         += "WHERE uuid IN ( " 

   aeval( ::aFetch, {| h | cSentence += hget( h, "uuid" ) + ", " } )

   cSentence         := chgAtEnd( cSentence, " )", 2 )

   msgalert( cSentence, "cSentence" )

RETURN ( cSentence )

//---------------------------------------------------------------------------//


