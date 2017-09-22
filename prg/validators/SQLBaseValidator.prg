#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseValidator

   DATA oDatabase

   DATA oController

   DATA hValidators

   DATA uColumnBuffer
   DATA cColumnToValidate

   DATA cValidateMethod  
   DATA cValidateMessage   

   DATA lDebugMode                     INIT .f.
  
   METHOD New()
   METHOD End()

   METHOD Validate()

   METHOD ExecuteValidate()

   METHOD Required()

   METHOD Unique()

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

METHOD Validate( cColumn )

   local uColumnBuffer
   local hColumnValidator
   local hColumnValidators

   if !hhaskey( ::hValidators, cColumn )
      RETURN ( .t. )
   end if 

   hColumnValidators       := hget( ::hValidators, cColumn )
   if empty( hColumnValidators )
      RETURN ( .t. )
   end if 

   ::cColumnToValidate     := cColumn
   ::uColumnBuffer         := ::oController:getModelBuffer( cColumn )

   for each hColumnValidator in hColumnValidators

      ::cValidateMethod    := hColumnValidator:__enumKey()
      ::cValidateMessage   := hColumnValidator:__enumValue()

      if !::executeValidate()
         RETURN ( .f. )
      end if 

   next 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD ExecuteValidate()

   local oError
   local lValidate   := .f.

   try 

      lValidate      := Self:&( ::cValidateMethod )

      if !lValidate
         msgstop( ::cValidateMessage, "Error" )
      end if

   catch oError

      eval( errorBlock(), oError )

   end 

RETURN ( lValidate )

//---------------------------------------------------------------------------//

METHOD Required()

   if ::lDebugMode
      msgInfo( !empty( ::uColumnBuffer ), "Required validator" )
   end if 

RETURN ( !empty( ::uColumnBuffer ) )

//---------------------------------------------------------------------------//

METHOD Unique()

   local id
   local nCount
   local cSQLSentence

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName() 
   cSQLSentence      += " WHERE " + ::cColumnToValidate + " = " + toSQLString( ::uColumnBuffer )

   id                := ::oController:getModelBufferColumnKey()
   if !empty(id)
      cSQLSentence   += " AND " + ::oController:getModelColumnKey() + " <> " + toSQLString( id )
   end if 

   if ::lDebugMode
      msgInfo( cSQLSentence, "Unique validator" )
   end if 

   nCount            := ::oDatabase:SelectValue( cSQLSentence )

RETURN ( hb_isnumeric( nCount ) .and. nCount == 0 )

//---------------------------------------------------------------------------//