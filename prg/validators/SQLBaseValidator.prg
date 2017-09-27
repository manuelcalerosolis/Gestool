#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseValidator

   DATA oDatabase

   DATA oController

   DATA hValidators
   DATA hAsserts

   DATA uColumnBuffer
   DATA cColumnToProced

   DATA cCurrentMethod  
   DATA cCurrentMessage   

   DATA lDebugMode                     INIT .f.
  
   METHOD New()
   METHOD End()

   METHOD Validate( cColumn )          INLINE ( ::ProcessAll( cColumn, ::hValidators ) )
   METHOD Assert( cColumn, uValue )    INLINE ( ::ProcessAll( cColumn, ::hAsserts, uValue ) )

   METHOD ProcessAll()
      METHOD Process()

   METHOD Required()
   METHOD Unique()
   METHOD Exist()
   METHOD EmptyOrExist()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oDatabase                   := getSQLDatabase()

   ::oController                 := oController

Return ( Self )

//---------------------------------------------------------------------------//

METHOD End()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD ProcessAll( cColumn, hProcess, uValue )

   local hColumn
   local uColumnBuffer
   local hColumnProcess

   if !hhaskey( hProcess, cColumn )
      RETURN ( .t. )
   end if 

   hColumnProcess          := hget( hProcess, cColumn )
   if empty( hColumnProcess )
      RETURN ( .t. )
   end if 

   ::cColumnToProced       := cColumn
   ::uColumnBuffer         := ::oController:getModelBuffer( cColumn )

   for each hColumn in hColumnProcess

      ::cCurrentMethod     := hColumn:__enumKey()
      ::cCurrentMessage    := hColumn:__enumValue()

      if !::Process( uValue )
         RETURN ( .f. )
      end if 

   next 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Process( uValue )

   local oError
   local lValidate   := .f.

   try 

      lValidate      := Self:&( ::cCurrentMethod )( uValue )

      if !lValidate
         msgstop( ::cCurrentMessage, "Error" )
      end if

   catch oError

      eval( errorBlock(), oError )

   end 

RETURN ( lValidate )

//---------------------------------------------------------------------------//

METHOD Required( uValue )

   default uValue    := ::uColumnBuffer  

   if ::lDebugMode
      msgInfo( !empty( uValue ), "Required validator" )
   end if 

RETURN ( !empty( ::uColumnBuffer ) )

//---------------------------------------------------------------------------//

METHOD Unique( uValue )

   local id
   local nCount
   local cSQLSentence

   default uValue    := ::uColumnBuffer  

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName()       + space( 1 )
   cSQLSentence      +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )   + space( 1 )

   id                := ::oController:getModelBufferColumnKey()
   if !empty(id)
      cSQLSentence   +=    "AND " + ::oController:getModelColumnKey() + " <> " + toSQLString( id )
   end if 

   if ::lDebugMode
      msgInfo( cSQLSentence, "Unique validator" )
   end if 

   nCount            := ::oDatabase:SelectValue( cSQLSentence )

RETURN ( hb_isnumeric( nCount ) .and. nCount == 0 )

//---------------------------------------------------------------------------//

METHOD Exist( uValue )

   local nCount
   local cSQLSentence

   default uValue    := ::uColumnBuffer  

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName()       + space( 1 )
   cSQLSentence      +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )

   if ::lDebugMode
      msgInfo( cSQLSentence, "Exist validator" )
   end if 

   nCount            := ::oDatabase:SelectValue( cSQLSentence )

RETURN ( hb_isnumeric( nCount ) .and. nCount != 0 )

//---------------------------------------------------------------------------//

METHOD EmptyOrExist( uValue )

   local nCount
   local cSQLSentence

   default uValue    := ::uColumnBuffer  

   if empty( uValue )
      RETURN ( .t. )
   end if 

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName()       + space( 1 )
   cSQLSentence      +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )

   if ::lDebugMode
      msgInfo( cSQLSentence, "EmptyOrExist validator" )
   end if 

   nCount            := ::oDatabase:SelectValue( cSQLSentence )

RETURN ( hb_isnumeric( nCount ) .and. nCount != 0 )

//---------------------------------------------------------------------------//