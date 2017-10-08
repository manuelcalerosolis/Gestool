#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseValidator

   DATA oDatabase

   DATA oController

   DATA hValidators
   DATA hAsserts

   DATA uColumnValue
   DATA cColumnToProced

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
   local hColumnProcess

   if !hhaskey( hProcess, cColumn )
      RETURN ( .t. )
   end if 

   hColumnProcess          := hget( hProcess, cColumn )
   if empty( hColumnProcess )
      RETURN ( .t. )
   end if 

   default uValue          := ::oController:getModelBuffer( cColumn )

   ::cColumnToProced       := cColumn
   ::uColumnValue          := uValue

   for each hColumn in hColumnProcess

      if !::Process( hColumn:__enumKey(), uValue, hColumn:__enumValue() )
         RETURN ( .f. )
      end if 

   next 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Process( cMethod, uValue, cMessage )

   local oError
   local lValidate   := .f.

   try 

      lValidate      := Self:&( cMethod )( uValue )

      if !lValidate
         msgstop( cMessage, "Error" )
      end if

   catch oError

      eval( errorBlock(), oError )

   end 

RETURN ( lValidate )

//---------------------------------------------------------------------------//

METHOD Required( uValue )

   default uValue    := ::uColumnValue  

   if ::lDebugMode
      msgInfo( !empty( uValue ), "Required validator" )
   end if 

RETURN ( !empty( ::uColumnValue ) )

//---------------------------------------------------------------------------//

METHOD Unique( uValue )

   local id
   local nCount
   local cSQLSentence

   default uValue    := ::uColumnValue  

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

   default uValue    := ::uColumnValue  

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

   default uValue    := ::uColumnValue  

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