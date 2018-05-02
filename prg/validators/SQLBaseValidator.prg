#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseValidator

   DATA oController

   DATA oView

   DATA hValidators
   DATA hAsserts

   DATA cColumnToProced

   DATA lDebugMode                        INIT .f.

   DATA uValue
  
   METHOD New()
   METHOD End()

   METHOD setValue( uValue )              INLINE   ( ::uValue := uValue )

   METHOD assignValue( cColumn, uValue )  INLINE   (  iif( hb_isnil( uValue ),;
                                                      ::setValue( ::oController:getModelBuffer( cColumn ) ),;
                                                      ::setValue( uValue ) ) )

   METHOD getValidators()                 VIRTUAL
   METHOD getAsserts()                    VIRTUAL

   METHOD Validate( cColumn, uValue )     INLINE   ( ::assignValue( cColumn, uValue ), ::ProcessAll( cColumn, ::getValidators() ) )
   METHOD Assert( cColumn, uValue )       INLINE   ( ::assignValue( cColumn, uValue ), ::ProcessAll( cColumn, ::getAsserts() ) )

   METHOD ProcessAll()
      METHOD Process()

   METHOD sayMessage( cMessage )

   METHOD Required()
   METHOD RequiredOrEmpty( uValue )

   METHOD getUniqueSenctence( uValue )
   METHOD Unique()

   METHOD Exist()
   METHOD EmptyOrExist()

   METHOD onlyAlphanumeric( uValue )

   METHOD Password( uValue )
   METHOD Mail( uValue )

   METHOD existArticulo( uValue )
   METHOD existFamilia( uValue )
   METHOD existTipoArticulo( uValue )

   METHOD setDialog( oView )                 INLINE ( ::oView := oView )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController, oView )

   ::oController                 := oController

   ::oView                       := oView

Return ( Self )

//---------------------------------------------------------------------------//

METHOD End()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD ProcessAll( cColumn, hProcess )

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

   for each hColumn in hColumnProcess

      if !::Process( hColumn:__enumKey(), hColumn:__enumValue() )
         RETURN ( .f. )
      end if 

   next 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Process( cMethod, cMessage )

   local oError
   local lValidate   := .f.

   try 

      lValidate      := Self:&( cMethod )( ::uValue ) 

      if !lValidate .and. !empty( cMessage )
         ::sayMessage( cMessage )         
      end if

   catch oError

      eval( errorBlock(), oError )

   end 

RETURN ( lValidate )

//---------------------------------------------------------------------------//

METHOD sayMessage( cMessage )

   local cText    := strtran( cMessage, "{value}", alltrim( cvaltostr( ::uValue ) ) )

   if empty( ::oView ) .or. empty( ::oView:oMessage )
      msgstop( cText, "Error" )
      RETURN ( self )
   end if 

   ::oView:showMessage( cText )

RETURN ( self )

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

METHOD getUniqueSenctence( uValue )

   local id
   local cSQLSentence

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName()       + space( 1 )
   cSQLSentence      +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )   + space( 1 )
   cSQLSentence      += ::oController:getModel():addEmpresaWhereUuid()

   id                := ::oController:getModelBufferColumnKey()
   if !empty( id )
      cSQLSentence   +=    "AND " + ::oController:getModelColumnKey() + " <> " + toSQLString( id )
   end if 

RETURN ( cSQLSentence )

//---------------------------------------------------------------------------//

METHOD Unique( uValue )

   local nCount
   local cSQLSentence   := ::getUniqueSenctence( uValue )

   nCount               := getSQLDatabase():getValue( cSQLSentence )

RETURN ( hb_isnumeric( nCount ) .and. nCount == 0 )

//---------------------------------------------------------------------------//

METHOD Exist( uValue )

   local nCount
   local cSQLSentence

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName() + space( 1 )
   cSQLSentence      +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )
   cSQLSentence      += ::addEmpresaWhereUuid()

   nCount            := getSQLDatabase():getValue( cSQLSentence )

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

   nCount            := getSQLDatabase():getValue( cSQLSentence )

RETURN ( hb_isnumeric( nCount ) .and. nCount != 0 )

//---------------------------------------------------------------------------//

METHOD Mail( uValue )

   if empty( uValue )
      RETURN .t.
   end if

RETURN ( hb_regexmatch( "[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}", uValue, .f. ) )

//---------------------------------------------------------------------------//

METHOD Password( uValue )

//RETURN ( hb_regexmatch( "^(?=(?:.*\d){2})(?=(?:.*[A-Z]){2})(?=(?:.*[a-z]){2})\S{8,}$", uValue, .f. ) ) 

RETURN ( Len( uValue) >= 8 .and. Len( uValue) <= 18 ) 

//---------------------------------------------------------------------------//

METHOD onlyAlphanumeric( uValue )

RETURN ( hb_regexmatch( "[a-zA-Z0-9]", uValue, .f. ) )

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
