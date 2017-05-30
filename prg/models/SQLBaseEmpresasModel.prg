#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseEmpresasModel From SQLBaseModel

   METHOD   New()
   METHOD   End()

   METHOD   getImportSentence( cPath )
   METHOD   makeImportDbfSQL( cPath )

   METHOD   getSelectSentence()
   METHOD   getInsertSentence()                     
   METHOD   getUpdateSentence()

   METHOD   getSelectByColumn()

   METHOD   getNameFromId( uValue )
   METHOD   getNameFromCodigo( uValue )

   METHOD   checksForValid( cColumnToValid )

   METHOD   exist( cValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD End()
   
   ::freeRowSet()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getImportSentence( cPath )
   
   local dbf
   local cValues        := ""
   local cInsert        := ""

   default cPath        := cPatEmp()

   dbUseArea( .t., cDriver(), cPatEmp() + ::getDbfTableName(), cCheckArea( "dbf", @dbf ) )
   if ( dbf )->( neterr() )
      Return ( cInsert )
   end if

   cInsert              := "INSERT INTO " + ::cTableName + " ( "
   hEval( ::hColumns, {| k | if ( k != ::cColumnKey, cInsert += k + ", ", ) } )
   cInsert              := ChgAtEnd( cInsert, ' ) VALUES ', 2 )


   ( dbf )->( dbgotop() )
   while ( dbf )->( !eof() )

      cValues           += "( "

      hEval( ::hColumns, {| k, hash | if ( k != ::cColumnKey, if ( k == "empresa", cValues += + toSQLString( cCodEmp() ) + ", ", cValues += toSQLString( ( dbf )->( fieldget( fieldpos( hget( hash, "dbfField" ) ) ) ) ) + ", "), ) } )
      
      cValues           := chgAtEnd( cValues, ' ), ', 2 )

      ( dbf )->( dbskip() )
   end while

   ( dbf )->( dbclosearea() )

   if empty( cValues )
      Return ( nil )
   end if 

   cValues              := chgAtEnd( cValues, '', 2 )

   cInsert              += cValues

Return ( cInsert )

//---------------------------------------------------------------------------//

METHOD makeImportDbfSQL( cPath )

   local cImportSentence

   default cPath     := cPatEmp()

   if ( file( cPath + ::getOldTableName() ) )
      Return ( self )
   end if

   if !( file( cPath + ::getDbfTableName() ) )
      msgStop( "El fichero " + cPath + "\" + ::getDbfTableName() + " no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   cImportSentence   := ::getImportSentence( cPath )

   if !empty( cImportSentence )

      getSQLDatabase():Exec( ::getSQLDropTable() )

      getSQLDatabase():Exec( ::getSQLCreateTable() )

      getSQLDatabase():Exec( cImportSentence )
      
   end if 

   frename( cPath + "\" + ::getDbfTableName(), cPath + "\" + ::getOldTableName() )
Return ( self )

//---------------------------------------------------------------------------//

METHOD getSelectSentence()

   local cSQLSelect
   
   cSQLSelect  := ::cGeneralSelect + " WHERE empresa = " + toSQLString( cCodEmp() )

   cSQLSelect        += ::getSelectByColumn()

   cSQLSelect        += ::getSelectByOrder()

Return ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getUpdateSentence()

  local cSQLUpdate  := "UPDATE " + ::cTableName + " SET "

  hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, if ( empty( v ), cSQLUpdate += k + " = null, ", cSQLUpdate += k + " = " + toSQLString( v ) + ", "), ) } )

  cSQLUpdate        := ChgAtEnd( cSQLUpdate, '', 2 )

  cSQLUpdate        += " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND " + ::cColumnKey + " = " + toSQLString( ::hBuffer[ ::cColumnKey ] )

Return ( cSQLUpdate )

//---------------------------------------------------------------------------//

METHOD getInsertSentence()

   Local cSQLInsert

   cSQLInsert               := "INSERT INTO " + ::cTableName + " ( "

   hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += k + ", ", ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' ) VALUES ( ', 2 )

   hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, if ( k == "empresa", cSQLInsert += + toSQLString( cCodEmp() ) + ", ", cSQLInsert += toSQLString( v ) + ", "), ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' )', 2 )

Return ( cSQLInsert )

//---------------------------------------------------------------------------//

METHOD getSelectByColumn()

   local cSQLSelect     := ""

   if !empty( ::cColumnOrder ) .and. !empty( ::cFind )
      cSQLSelect        += " AND upper(" + ::cColumnOrder +") LIKE '%" + ::cFind + "%'" 
   end if

Return ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getNameFromId( uValue )

   local cName       := ""
   local cSentence   := "SELECT nombre FROM " + ::cTableName + ;
                           " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND id = " + toSQLString( uValue )
   local aSelect     := ::selectFetchHash( cSentence )

   if !empty( aSelect )
      cName          := hget( atail( aSelect ), "nombre" )
   end if 

RETURN ( cName )

//---------------------------------------------------------------------------//

METHOD getNameFromCodigo( uValue )

   local cName       := ""
   local cSentence   := "SELECT nombre FROM " + ::cTableName + ;
                           " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND codigo = " + toSQLString( uValue )
   local aSelect     := ::selectFetchHash( cSentence )

   if !empty( aSelect )
      cName          := hget( atail( aSelect ), "nombre" )
   end if 

RETURN ( cName )

//---------------------------------------------------------------------------//


METHOD checksForValid( cColumnToValid )

   local id
   local cSentence   := "SELECT id FROM " + ::cTableName + ;
                           " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND " + cColumnToValid + " = " + toSQLString( hget( ::hBuffer, cColumnToValid ) )
   local aSelect     := ::selectFetchHash( cSentence )

   if !empty( aSelect )
      id             := hget( atail( aSelect ), "id" )
   end if 
   
RETURN ( id )

//---------------------------------------------------------------------------//

METHOD exist( cValue )

   local cSentence   := "SELECT " + ::cColumnKey + " FROM " + ::cTableName + ;
                           " WHERE empresa = " + toSQLString( cCodEmp() ) + " AND id = " + toSQLString( cValue )

RETURN ( !empty( ::selectFetchArray( cSentence ) ) )

//---------------------------------------------------------------------------//