#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseValidator

   DATA oDatabase

   DATA oController

   DATA hValidators
   DATA hAsserts

   DATA cColumnToProced

   DATA lDebugMode                     INIT .f.
  
   METHOD New()
   METHOD End()

   METHOD getValidators()              VIRTUAL
   METHOD getAsserts()                 VIRTUAL

   METHOD Validate( cColumn, uValue )  INLINE ( ::ProcessAll( cColumn, uValue, ::getValidators() ) )
   METHOD Assert( cColumn, uValue )    INLINE ( ::ProcessAll( cColumn, uValue, ::getAsserts() ) )

   METHOD ProcessAll()
      METHOD Process()

   METHOD Required()
   METHOD RequiredOrEmpty( uValue )

   METHOD Unique()
   METHOD Exist()
   METHOD EmptyOrExist()

   METHOD existArticulo( uValue )
   METHOD existFamilia( uValue )
   METHOD existTipoArticulo( uValue )

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

METHOD ProcessAll( cColumn, uValue, hProcess )

   local hColumn
   local hColumnProcess

   if !hhaskey( hProcess, cColumn )
      RETURN ( .t. )
   end if 

   hColumnProcess          := hget( hProcess, cColumn )
   if empty( hColumnProcess )
      RETURN ( .t. )
   end if 

   ::cColumnToProced       := cColumn

   if empty( uValue )
      uValue               := ::oController:getModelBuffer( cColumn )
   end if 

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
         msgstop( strtran( cMessage, "{value}", alltrim( cvaltostr( uValue ) ) ), "Error" )
      end if

   catch oError

      eval( errorBlock(), oError )

   end 

RETURN ( lValidate )

//---------------------------------------------------------------------------//

METHOD Required( uValue )

RETURN ( !empty( uValue ) )

//---------------------------------------------------------------------------//

METHOD RequiredOrEmpty( uValue )

   if empty( uValue ) .or. ( uValue == replicate( "Z", len( uValue ) ) )
      RETURN ( .t. )
   end if 

RETURN ( ::Required( uValue ) )

//---------------------------------------------------------------------------//

METHOD Unique( uValue )

   local id
   local nCount
   local cSQLSentence

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

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName() + space( 1 )
   cSQLSentence      +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )

   nCount            := ::oDatabase:SelectValue( cSQLSentence )

RETURN ( hb_isnumeric( nCount ) .and. nCount != 0 )

//---------------------------------------------------------------------------//

METHOD EmptyOrExist( uValue )

   local nCount
   local cSQLSentence

   if empty( uValue )
      RETURN ( .t. )
   end if 

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName() + space( 1 )
   cSQLSentence      +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )

   nCount            := ::oDatabase:SelectValue( cSQLSentence )

RETURN ( hb_isnumeric( nCount ) .and. nCount != 0 )

//---------------------------------------------------------------------------//

METHOD existArticulo( uValue )

   if empty( uValue ) .or. ( uValue == replicate( "Z", len( uValue ) ) )
      RETURN ( .t. )
   end if 

   if ArticulosModel():exist( uValue )
      RETURN ( .t. )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD existFamilia( uValue )

   if empty( uValue ) .or. ( uValue == replicate( "Z", len( uValue ) ) )
      RETURN ( .t. )
   end if 

   if FamiliasModel():exist( uValue )
      RETURN ( .t. )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD existTipoArticulo( uValue )

   if empty( uValue ) .or. ( uValue == replicate( "Z", len( uValue ) ) )
      RETURN ( .t. )
   end if 

   if TiposArticulosModel():exist( uValue )
      RETURN ( .t. )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//
