#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasValidator FROM SQLBaseValidator

   DATA uColumnBuffer
   DATA cColumnToValidate
   DATA cValidateMethod  
   DATA cValidateMessage   

   METHOD New( oController )

   METHOD Validate()

   METHOD ExecuteValidate()

   METHOD Required( cColumn )

   METHOD Unique( uColumnBuffer )
  
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::hValidators  := { "nombre" =>  {  "required"  => "El nombre es un dato requerido",;
                                       "unique"    => "El nombre ya existe" } }

   ::Super:New( oController )

RETURN ( Self )

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

   local lValidate   := .f.

   try 

      lValidate      := Self:&( ::cValidateMethod )

      if !lValidate
         msgstop( ::cValidateMessage, "Error" )
      end if

   catch

      msgstop( "Error el método " + ::cValidateMethod + " no está definido" )

   end 

RETURN ( lValidate )

//---------------------------------------------------------------------------//

METHOD Required()

RETURN ( !empty( ::uColumnBuffer ) )

//---------------------------------------------------------------------------//

METHOD Unique()

   local id
   local cSQLSentence

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName() 
   cSQLSentence      += " WHERE " + ::cColumnToValidate + " = " + toSQLString( ::uColumnBuffer )

   id                := ::oController:getModelBufferColumnKey()
   if !empty(id)
      cSQLSentence   += " AND " + ::oController:getModelColumnKey() + " <> " + toSQLString( id )
   end if 

   msgalert( cSQLSentence, "Unique" )

   msgalert( hb_valtoexp( ::oController:getModelSelectValue( "PEPIOto" ) ), "getModelSelectFetch" )

RETURN ( .t. )



