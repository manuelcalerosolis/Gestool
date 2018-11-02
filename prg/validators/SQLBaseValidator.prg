#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseValidator

   DATA oController

   DATA hAsserts

   DATA hValidators

   DATA cColumnToProced

   DATA lDebugMode                        INIT .f.

   DATA uValue
  
   METHOD New() CONSTRUCTOR
   METHOD End()                           

   METHOD setValue( uValue )              INLINE   ( ::uValue := uValue )

   METHOD assignValue( cColumn, uValue )  INLINE   (  iif( hb_isnil( uValue ),;
                                                      ::setValue( ::oController:getModelBuffer( cColumn ) ),;
                                                      ::setValue( uValue ) ) )

   METHOD getValidators()                 VIRTUAL
   METHOD getAsserts()                    VIRTUAL

   METHOD getController()                 INLINE   ( ::oController )

   METHOD Validate( cColumn, uValue )     INLINE   ( ::assignValue( cColumn, uValue ), ::ProcessAll( cColumn, ::getValidators() ) )
   METHOD Assert( cColumn, uValue )       INLINE   ( ::assignValue( cColumn, uValue ), ::ProcessAll( cColumn, ::getAsserts() ) )

   METHOD ProcessAll()
      METHOD Process()

   METHOD sayMessage( cMessage )

   METHOD Required()
   METHOD RequiredOrEmpty( uValue )

   METHOD getUniqueSentence( uValue )
   METHOD Unique()

   METHOD Exist()
   METHOD EmptyOrExist()

   METHOD onlyAlphanumeric( uValue )

   METHOD Password( uValue )
   METHOD Mail( uValue )

   METHOD existArticulo( uValue )
   METHOD existFamilia( uValue )
   METHOD existTipoArticulo( uValue )

   METHOD Positive( uValue )

   METHOD getSenderControllerUuid()

   METHOD numeroDocumento( value )

   METHOD getDialogView()                 INLINE ( ::oController:getDialogView() )

   METHOD notPrincipal( value )          

   // Busquedas comnues en la aplicacion---------------------------------------

   METHOD clienteExist( cCodigo )         INLINE ( SQLClientesModel():isWhereCodigo( cCodigo ) )

   METHOD formaPagoExist( cCodigo )       INLINE ( SQLFormaPagoModel():isWhereCodigo( cCodigo ) )

   METHOD almacenExist( cCodigo )         INLINE ( SQLAlmacenesModel():isWhereCodigo( cCodigo ) )

   METHOD tarifaExist( cCodigo )          INLINE ( SQLArticulosTarifasModel():isWhereCodigo( cCodigo ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                 := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()     

   ::hAsserts                    := nil
   
   ::hValidators                 := nil

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

      if !( ::Process( hColumn:__enumKey(), hColumn:__enumValue() ) )
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

   if empty( ::getDialogView() ) .or. empty( ::getDialogView():oMessage )
      msgstop( cText, "Error" )
      RETURN ( nil )
   end if 

   ::getDialogView():showMessage( cText )

RETURN ( nil )

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

METHOD getUniqueSentence( uValue )

   local id
   local cSQLSentence

   cSQLSentence         := "SELECT COUNT(*) FROM " + ::oController:getModelTableName()       + space( 1 )
   cSQLSentence         +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )   + space( 1 )

   if ::oController:getModel():isDeletedAtColumn()
   
      cSQLSentence         +=    "AND deleted_at = 0 " 
   end if 
   
   id                   := ::oController:getModelBufferColumnKey()
   if !empty( id )
      cSQLSentence      +=    "AND " + ::oController:getModelColumnKey() + " <> " + toSQLString( id )
   end if 

RETURN ( cSQLSentence )

//---------------------------------------------------------------------------//

METHOD Unique( uValue )

   local nCount
   local cSQLSentence   := ::getUniqueSentence( uValue )

   nCount               := getSQLDatabase():getValue( cSQLSentence, 0 )

RETURN ( hb_isnumeric( nCount ) .and. nCount == 0 )

//---------------------------------------------------------------------------//

METHOD Exist( uValue )

   local nCount
   local cSQLSentence

   cSQLSentence         := "SELECT COUNT(*) FROM " + ::oController:getModelTableName() + " "
   cSQLSentence         +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )

   nCount               := getSQLDatabase():getValue( cSQLSentence, 0 )

RETURN ( hb_isnumeric( nCount ) .and. nCount != 0 )

//---------------------------------------------------------------------------//

METHOD EmptyOrExist( uValue )

   local nCount
   local cSQLSentence

   if empty( uValue )
      RETURN ( .t. )
   end if 

   cSQLSentence         := "SELECT COUNT(*) FROM " + ::oController:getModelTableName() + space( 1 )
   cSQLSentence         +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )

   nCount               := getSQLDatabase():getValue( cSQLSentence, 0 )

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

METHOD Positive( uValue )

RETURN ( hb_isnumeric( uValue ) .and. ( uValue >= 0 ) )

//---------------------------------------------------------------------------//

METHOD getSenderControllerUuid() 

   if empty( ::oController )
      RETURN ( '' )
   end if

   if empty( ::oController:getController() )
      RETURN ( '' )
   end if

RETURN ( ::oController:getController():getUuid() )

//---------------------------------------------------------------------------//

METHOD numeroDocumento( value )

   local nAt
   local cSerie   := ""
   local nNumero

   value          := alltrim( value )

   nAt            := rat( "/", value )
   if nAt != 0
      nNumero     := substr( value, nAt + 1 )
      cSerie      := substr( value, 1, nAt  )
   else
      nNumero     := value
   end if  

   if !hb_regexlike( "^[0-9]{1,6}$", nNumero )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD notPrincipal( value ) 

RETURN ( alltrim( value ) != '0' )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCompanyValidator FROM SQLBaseValidator

   METHOD getUniqueSentence( uValue )

   METHOD Exist( uValue )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD getUniqueSentence( uValue ) CLASS SQLCompanyValidator

   local id
   local cSQLSentence

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName()       + space( 1 )
   cSQLSentence      +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )   + space( 1 )

   id                := ::oController:getModelBufferColumnKey()
   if !empty( id )
      cSQLSentence   +=    "AND " + ::oController:getModelColumnKey() + " <> " + toSQLString( id )
   end if 

RETURN ( cSQLSentence )

//---------------------------------------------------------------------------//

METHOD Exist( uValue ) CLASS SQLCompanyValidator

   local nCount
   local cSQLSentence

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName()       + space( 1 )
   cSQLSentence      +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )   + space( 1 )

   nCount            := getSQLDatabase():getValue( cSQLSentence, 0 )

RETURN ( hb_isnumeric( nCount ) .and. nCount != 0 )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLParentValidator FROM SQLBaseValidator

   METHOD getUniqueSentence( uValue )

   METHOD Exist( uValue )

   METHOD numeroDocumento( value )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD getUniqueSentence( uValue ) CLASS SQLParentValidator

   local id
   local cSQLSentence

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName()       + space( 1 )
   cSQLSentence      +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )   + space( 1 )
   cSQLSentence      +=    "AND parent_uuid = " + quoted( ::getSenderControllerUuid() )   + space( 1 ) 

   id                := ::oController:getModelBufferColumnKey()
   if !empty( id )
      cSQLSentence   +=    "AND " + ::oController:getModelColumnKey() + " <> " + toSQLString( id )
   end if 

RETURN ( cSQLSentence )

//---------------------------------------------------------------------------//

METHOD Exist( uValue ) CLASS SQLParentValidator

   local nCount
   local cSQLSentence

   cSQLSentence      := "SELECT COUNT(*) FROM " + ::oController:getModelTableName()       + space( 1 )
   cSQLSentence      +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )   + space( 1 )
   cSQLSentence      +=    "AND parent_uuid = " + quoted( ::getSenderControllerUuid() )   + space( 1 ) 

   nCount            := getSQLDatabase():getValue( cSQLSentence, 0 )

RETURN ( hb_isnumeric( nCount ) .and. nCount != 0 )

//---------------------------------------------------------------------------//

METHOD numeroDocumento( value ) CLASS SQLParentValidator

   local nAt
   local cSerie      := ""
   local nNumero

   value             := alltrim( value )

   nAt               := rat( "/", value )
   if nAt != 0
      nNumero        := substr( value, nAt + 1 )
      cSerie         := substr( value, 1, nAt  )
   else
      nNumero        := value
   end if  

   if !hb_regexlike( "^[0-9]{1,6}$", nNumero )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//