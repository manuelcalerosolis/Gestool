#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasValidator FROM SQLBaseValidator

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

   uColumnBuffer           := ::oController:getModelBuffer( cColumn )

   for each hColumnValidator in hColumnValidators
      if !::executeValidate( uColumnBuffer, hColumnValidator:__enumKey(), hColumnValidator:__enumValue() )
         RETURN ( .f. )
      end if 
   next 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD ExecuteValidate( uColumnBuffer, cValidateMethod, cValidateMessage )

   local lValidate   := .f.

   try 

      lValidate      := Self:&( cValidateMethod )( uColumnBuffer ) 

      if !lValidate
         msgstop( cValidateMessage, "Error" )
      end if

   catch

      msgstop( "Error el metodo " + cValidateMethod + " no está definido" )

   end 

RETURN ( lValidate )

//---------------------------------------------------------------------------//

METHOD Required( uColumnBuffer )

RETURN ( !empty( uColumnBuffer ) )

//---------------------------------------------------------------------------//

METHOD Unique( uColumnBuffer )

   local cSQLSentence   

   "SELECT nombre FROM " + ::cTableName + " WHERE nombre = " + toSQLString( cValue )

   if empty(xExpr)

   msgalert( ::oController:getModelBufferColumnKey(), "Unique" )

RETURN ( empty( uColumnBuffer ) )



