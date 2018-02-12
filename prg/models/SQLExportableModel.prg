#include "fivewin.ch"
#include "factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLExportableModel FROM SQLBaseModel

   DATA aFetch

   DATA cJsonFileToExport

   DATA cJsonFileToImport

   METHOD setJsonFileToExport( cFile )       INLINE ( ::cJsonFileToExport := cFile )
   METHOD getJsonFileToExport()              INLINE ( iif(  empty( ::cJsonFileToExport ),;
                                                            cpatout() + ::cTableName + ".json",;
                                                            ::cJsonFileToExport ) )

   METHOD setJsonFileToImport( cFile )       INLINE ( ::cJsonFileToImport := cFile )
   METHOD getJsonFileToImport()              INLINE ( iif(  empty( ::cJsonFileToImport ),;
                                                            cpatin() + ::cTableName + ".json",;
                                                            ::cJsonFileToImport ) )


   METHOD getSentenceNotSent()

   METHOD selectNotSentToJson( cFile )

   METHOD selectFetchToHash( cSentence )

   METHOD saveToJson( cFile )

   METHOD selectFetchToJson( cSentence, cFile )

   METHOD isInsertOrUpdateFromJson( cFile )

   METHOD getSentenceSentFromFetch()      

   METHOD getSentenceSentFromIds( aIds )     INLINE ( ::getSentenceSenderFromIds( aIds, toSQLString( hb_datetime() ) ) )
   METHOD getSentenceNotSentFromIds( aIds )  INLINE ( ::getSentenceSenderFromIds( aIds, "null" ) )
   
   METHOD getSentenceSenderFromIds( aIds, uValue )

END CLASS

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

   ::fireEvent( 'selectingFetchToHash' )   

   ::aFetch          := ::getDatabase():selectFetchHash( cSentence, .f. )

   ::fireEvent( 'selectedFetchToHash' )   

RETURN ( ::aFetch )

//---------------------------------------------------------------------------//

METHOD saveToJson( cFile )

   DEFAULT cFile     := ::getJsonFileToExport()

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

METHOD isInsertOrUpdateFromJson( cFile )

   local cJson
   local aJson
   local hBuffer

   DEFAULT cFile     := ::getJsonFileToImport()

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

METHOD getSentenceSentFromFetch( aFetch )

   local cSentence 

   DEFAULT aFetch    := ::aFetch

   if empty( aFetch )
      RETURN ( nil )
   end if  

   cSentence         := "UPDATE " + ::cTableName + " SET "

   cSentence         +=    "enviado = " + toSQLString( hb_datetime() ) + " "

   cSentence         += "WHERE uuid IN ( " 

   aeval( aFetch, {| h | cSentence += quoted( hget( h, "uuid" ) ) + ", " } )

   cSentence         := chgAtEnd( cSentence, " )", 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getSentenceSenderFromIds( aIds, uValue )

   local cSentence 

   if empty( aIds )
      RETURN ( nil )
   end if  

   cSentence         := "UPDATE " + ::cTableName + " SET "

   cSentence         +=    "enviado = " + ( uValue ) + " "

   cSentence         += "WHERE id IN ( " 

   aeval( aIds, {| id | cSentence += quoted( id ) + ", " } )

   cSentence         := chgAtEnd( cSentence, " )", 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

