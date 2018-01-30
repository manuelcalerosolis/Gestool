#include "fivewin.ch"
#include "factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLExportableModel FROM SQLBaseModel

   DATA aFetch

   METHOD lCheckEnvioRecepcion()             INLINE ( ConfiguracionEmpresasRepository():getLogic( 'envio_recepcion', .f. ) )

   METHOD CheckFolders()

   METHOD getInsertIgnoreSentence( hBuffer )

   METHOD insertIgnoreBuffer( hBuffer )

   METHOD selectNotSentToJson( cFile )

   METHOD selectFetchToHash( cSentence )

   METHOD saveJson( cFile )

   METHOD selectFetchToJson( cSentence, cFile )

   METHOD insertFromJson( cFile )

   METHOD getSentenceSentFromFetch()

END CLASS

//---------------------------------------------------------------------------//

METHOD CheckFolders()

   MsgInfo( ::cTableName, "cTableName" )

   MsgInfo( ::lCheckEnvioRecepcion() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getInsertIgnoreSentence( hBuffer )

   local cSQLInsert

   DEFAULT hBuffer   := ::hBuffer

   cSQLInsert        := "INSERT IGNORE INTO " + ::cTableName + " ( "

   hEval( hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += k + ", ", ) } )

   cSQLInsert        := chgAtEnd( cSQLInsert, " ) VALUES ( ", 2 )

   hEval( hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += toSQLString( v ) + ", ", ) } )

   cSQLInsert        := chgAtEnd( cSQLInsert, " )", 2 )

RETURN ( cSQLInsert )

//---------------------------------------------------------------------------//

METHOD insertIgnoreBuffer( hBuffer )

   local nId

   ::fireEvent( 'insertingIgnoreBuffer' )

   ::getDatabase():Execs( ::getInsertIgnoreSentence( hBuffer ) )

   nId         := ::getDatabase():LastInsertId()

   ::fireEvent( 'insertedIgnoreBuffer' )

RETURN ( nId )

//---------------------------------------------------------------------------//

METHOD selectNotSentToJson( cFile )

   local cSentence   := "SELECT * FROM " + ::cTableName + " "

   cSentence         +=    "WHERE enviado IS NULL"

RETURN ( ::selectFetchToJson( cSentence, cFile ) )

//---------------------------------------------------------------------------//

METHOD selectFetchToHash( cSentence )

   ::fireEvent( 'selectingFetchToHash' )   

   ::aFetch          := ::getDatabase():selectFetchHash( cSentence, .f. )

   ::fireEvent( 'selectedFetchToHash' )   

RETURN ( ::aFetch )

//---------------------------------------------------------------------------//

METHOD saveJson( cFile )

   if hb_memowrit( cFile, hb_jsonencode( ::aFetch, .t. ) )
      RETURN ( .t. )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD selectFetchToJson( cSentence, cFile )

   ::selectFetchHash( cSentence, .f. )

   if !hb_isarray( ::aFetch ) 
      RETURN ( .f. )
   end if

   ::saveJson( cFile )

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
      ::insertIgnoreBuffer( hBuffer )
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


