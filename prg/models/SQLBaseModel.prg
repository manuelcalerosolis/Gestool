#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseModel
  
   DATA     oRowSet

   DATA     cTableName
   DATA     cDbfTableName
	DATA	   hColumns

   DATA     cConstraints

   DATA     hExtraColumns

   DATA     cGeneralSelect

   DATA     cColumnOrder
   DATA     cOrientation
   DATA     nIdForRecno

   DATA	   cSQLInsert     
   DATA     cSQLSelect      
   
   DATA     cColumnKey                     INIT "id"
   DATA     cColumnCode                    INIT "codigo"

  	DATA	   hBuffer   
   DATA     cFind

   METHOD   New()
   METHOD   End()
 
   METHOD   getSQLCreateTable()
   METHOD   getSQLDropTable()
   METHOD   getImportSentence( cPath )
   METHOD   makeImportDbfSQL( cPath )
   METHOD   getSelectSentence()
   METHOD   getInsertSentence()
   METHOD   getUpdateSentence()
   METHOD   getDeleteSentence()

   METHOD   convertRecnoToId( aRecno )

   METHOD   getTableName                           INLINE ( ::cTableName )

   METHOD   setColumnOrder( cColumnOrder )         INLINE ( ::cColumnOrder := cColumnOrder )
   METHOD   setOrientation( cOrientation )         INLINE ( ::cOrientation := cOrientation )
   METHOD   setIdForRecno( nIdForRecno )           INLINE ( ::nIdForRecno := nIdForRecno )

   METHOD   buildRowSet()
   METHOD   buildRowSetWithRecno()                 
   METHOD   freeRowSet()                           INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet := nil ), ) )
   METHOD   getRowSetRecno()                       INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:recno() ) , 0 ) )
   METHOD   setRowSetRecno( nRecno )               INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:goto( nRecno ) ), ) )
 
   METHOD   getSelectByColumn()
   METHOD   getSelectByOrder()

   METHOD   setFind( cFind )                       INLINE   ( ::cFind := cFind )

   METHOD   find( cFind )

   METHOD   existId( id )
   METHOD   existCodigo( codigo )

   METHOD   getName()                              INLINE   ( "" )

   METHOD   getBuffer( cColumn )                   INLINE   ( hget( ::hBuffer, cColumn ) )
   METHOD   updateCurrentBuffer()                  INLINE   ( getSQLDatabase():Query( ::getUpdateSentence() ), ::buildRowSetWithRecno() )
   METHOD   insertBuffer()                         INLINE   ( getSQLDatabase():Query( ::getInsertSentence() ), ::buildRowSet() )
   METHOD   deleteSelection( aRecno )              INLINE   ( getSQLDatabase():Query( ::getdeleteSentence( aRecno ) ), ::buildRowSet() )

   METHOD   loadBlankBuffer()
   METHOD   loadCurrentBuffer()

   METHOD   selectFetch( cSentence )
   METHOD   selectFetchArray( cSentence )          
   METHOD   selectFetchHash( cSentence )           INLINE   ( ::selectFetch( cSentence, FETCH_HASH ) )

   METHOD   getDbfTableName()                      INLINE   ( ::cDbfTableName + ".dbf" )
   METHOD   getOldTableName()                      INLINE   ( ::cDbfTableName + ".old" )

   METHOD   getColumnsOfCurrentTable()
   METHOD   compareCurrentAndActualColumns()
   METHOD   updateTableColumns()

   METHOD   serializeColumns()

   METHOD   checksForValid()

   METHOD   getNameFromId( uValue )
   METHOD   getNameFromCodigo( uValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cColumnKey                  := "id"

   ::cFind                       := ""

   ::cGeneralSelect              := "SELECT * FROM " + ::cTableName

   ::cConstraints                := "" 

   ::cColumnOrder                := "codigo"

   ::cOrientation                := "A"

   ::nIdForRecno                 := 1

Return ( Self )

//---------------------------------------------------------------------------//

METHOD End()
   
   ::freeRowSet()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getSQLCreateTable()
   
   local cSQLCreateTable 

   cSQLCreateTable         := "CREATE TABLE " + ::cTableName + " ( "

   hEval( ::hColumns, {| k, hash | cSQLCreateTable += k + " " + hget( hash, "create" ) + ", " } )
   
   if !empty( ::cConstraints )

      cSQLCreateTable      += ::cConstraints + " )"

   else

      cSQLCreateTable      := ChgAtEnd( cSQLCreateTable, ' )', 2 )

   end if 

Return ( cSQLCreateTable )

//---------------------------------------------------------------------------//

METHOD getSQLDropTable()
   
   local cSQLDropTable := "DROP TABLE " + ::cTableName

Return ( cSQLDropTable )

//---------------------------------------------------------------------------//

METHOD getImportSentence( cPath )
   
   local dbf
   local cValues     := ""
   local cInsert     := ""

   dbUseArea( .t., cLocalDriver(), cPath + "\" + ::getDbfTableName(), cCheckArea( "dbf", @dbf ), .f. )
   if ( dbf )->( neterr() )
      Return ( cInsert )
   end if

   cInsert              := "INSERT INTO " + ::cTableName + " ( "
   hEval( ::hColumns, {| k | if ( k != ::cColumnKey, cInsert += k + ", ", ) } )
   cInsert           := ChgAtEnd( cInsert, ' ) VALUES ', 2 )


   ( dbf )->( dbgotop() )
   while ( dbf )->( !eof() )

      cValues           += "( "

            hEval( ::hColumns, {| k, hash | if ( k != ::cColumnKey,;
                                                if ( k == "empresa",;
                                                      cValues += toSQLString( cCodEmp() ) + ", ",;
                                                      cValues += toSQLString( ( dbf )->( fieldget( fieldpos( hget( hash, "field" ) ) ) ) ) + ", "), ) } )

      
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

   if empty( cPath ) 
      if ( hb_HHasKey( ::hColumns, "empresa" ) )
         cPath     := cPatEmp()
      else
         cPath     := cPatDat()
      end if 
   end if

   if ( file( cPath + "\" + ::getOldTableName() ) )
      Return ( self )
   end if

   if !( file( cPath + "\" + ::getDbfTableName() ) )
      msgStop( "El fichero " + cPath + "\" + ::getDbfTableName() + " no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   cImportSentence   := ::getImportSentence( cPath )

   if !empty( cImportSentence )

      getSQLDatabase():Exec( ::getSQLCreateTable() )

      msgalert( cImportSentence )

      getSQLDatabase():Exec( cImportSentence )
      
   end if 

   frename( cPath + "\" + ::getDbfTableName(), cPath + "\" + ::getOldTableName() )
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD buildRowSetWithRecno()

   ::buildRowSet()

   if ::oRowSet:find( ::nIdForRecno, ::cColumnKey, .t. ) == 0
      ::oRowSet:goTop()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD buildRowSet( cSentence )

   local oStmt

   default cSentence    := ::getSelectSentence()


   

   try

      oStmt             := getSQLDatabase():Query( cSentence ) 
      ::oRowSet         := oStmt:fetchRowSet()

   catch
      
      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )
      
   finally

      if !empty( oStmt )
         oStmt:free()
      end if    
   
   end

   ::oRowSet:goTop()

Return ( self )

//---------------------------------------------------------------------------//

METHOD getUpdateSentence()

  local cSQLUpdate  := "UPDATE " + ::cTableName + " SET "

  hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLUpdate += k + " = " + toSQLString( v ) + ", ", ) } )

  cSQLUpdate        := ChgAtEnd( cSQLUpdate, '', 2 )

  cSQLUpdate        += " WHERE " + ::cColumnKey + " = " + toSQLString( ::hBuffer[ ::cColumnKey ] )

Return ( cSQLUpdate )

//---------------------------------------------------------------------------//

METHOD getInsertSentence()

   Local cSQLInsert

   cSQLInsert               := "INSERT INTO " + ::cTableName + " ( "

   hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += k + ", ", ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' ) VALUES ( ', 2 )

   hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, if ( k == "empresa", cSQLInsert += toSQLString( cCodEmp() ) + ", ", cSQLInsert += toSQLString( v ) + ", "), ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' )', 2 )

Return ( cSQLInsert )

//---------------------------------------------------------------------------//

METHOD convertRecnoToId( aRecno )

   local nRecno
   local aId         := {}

   for each nRecno in ( aRecno )
      ::oRowset:goto( nRecno )
      aadd( aId, ::oRowset:fieldget( ::cColumnKey ) )
   next

Return ( aId )

//---------------------------------------------------------------------------//

METHOD getDeleteSentence( aRecno )

   local aId            := ::convertRecnoToId( aRecno )

   local cSQLDelete     := "DELETE FROM " + ::cTableName + " WHERE " 

   aeval( aId, {| v | cSQLDelete += ::cColumnKey + " = " + toSQLString( v ) + " or " } )

   cSQLDelete           := ChgAtEnd( cSQLDelete, '', 4 )

Return ( cSQLDelete )

//---------------------------------------------------------------------------//

METHOD getSelectSentence()

   local cSQLSelect  := ::cGeneralSelect

   if ( hb_HHasKey( ::hColumns, "empresa" ) )
      cSQLSelect += " WHERE empresa = " + toSQLString( cCodEmp() )
   end if

   cSQLSelect := ::getSelectByColumn( cSQLSelect )

   cSQLSelect := ::getSelectByOrder( cSQLSelect )

Return ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectByColumn( cSQLSelect )


   if !empty( ::cColumnOrder ) .and. !empty( ::cFind )
      
      if ( hb_at( "WHERE", cSQLSelect) != 0 )
         cSQLSelect += " AND"
      else
         cSQLSelect += " WHERE"
      end if

      cSQLSelect        += " UPPER(" + ::cColumnOrder +") LIKE '%" + Upper( ::cFind ) + "%'" 
   end if

Return ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectByOrder( cSQLSelect )

   if !empty( ::cColumnOrder )
      cSQLSelect     += " ORDER BY " + ::cColumnOrder 
   end if 

   if !empty( ::cOrientation ) .and. ::cOrientation == "D"
      cSQLSelect     += " DESC"
   end if

Return ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD find( cFind )

   ::setFind( cFind )

   ::buildRowSet()

Return ( ::oRowSet:recCount() > 0 )

//----------------------------------------------------------------------------//

METHOD loadBlankBuffer()

   if empty( ::oRowSet )
      Return ( .f. )
   end if 

   ::oRowSet:goto( 0 )

Return ( ::loadCurrentBuffer() )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer()                

   local h
   local aColumnNames   := hb_hkeys( ::hColumns )

   if empty( ::oRowSet )
      Return ( .f. )
   end if 

   ::hBuffer            := {=>}

   for each h in ::hColumns

      do case
         case ( hhaskey( h, "type" ) .and. h[ "type" ] == "L" )

            hset( ::hBuffer, h:__enumkey(), ::oRowSet:fieldget( h:__enumkey() ) == 1 )

         case ( hhaskey( h, "type" ) .and. h[ "type" ] == "N" .and. hb_isnil( ::oRowSet:fieldget( h:__enumkey() ) ) )

            hset( ::hBuffer, h:__enumkey(), 0 )

         case ( hhaskey( h, "type" ) .and. h[ "type" ] == "C" .and. hhaskey( h, "len" ) )

            if hb_isnil( ::oRowSet:fieldget( h:__enumkey() ) )
               hset( ::hBuffer, h:__enumkey(), space( h[ "len" ] ) )
            else 
               hset( ::hBuffer, h:__enumkey(), padr( ::oRowSet:fieldget( h:__enumkey() ), h[ "len" ] ) )
            end if 

         case ( !hhaskey( h, "type" ) .and. empty( ::oRowSet:fieldget( h:__enumkey() ) ) )

            hset( ::hBuffer, h:__enumkey(), nil )

         otherwise

            hset( ::hBuffer, h:__enumkey(), ::oRowSet:fieldget( h:__enumkey() ) )

      end if

   next

Return ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD selectFetch( cSentence, fetchType )

   local oStmt
   local aFetch

   default fetchType := FETCH_ARRAY

   try 
      oStmt          := getSQLDatabase():Query( cSentence )
      aFetch         := oStmt:fetchAll( fetchType )

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

   finally

      if !empty( oStmt )
        oStmt:free()
      end if    
   
   end

   if !empty( aFetch ) .and. hb_isarray( aFetch )
      RETURN ( aFetch )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD selectFetchArray( cSentence )

   local aResult  := {}
   local aFetch   := ::selectFetch( cSentence, FETCH_ARRAY )

   if !empty( aFetch ) .and. hb_isarray( aFetch )
      aeval( aFetch, {|a| aadd( aResult, a[ 1 ] ) } )
      RETURN ( aResult )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getColumnsOfCurrentTable()

   local oStmt
   local cSentence
   local aTableInfo
   local hFetch
   local aCurrentColumns   := {}

   cSentence               := "PRAGMA table_info(" + ::cTableName + ")"

   try

      oStmt                := getSQLDatabase():Query( cSentence )
      aTableInfo           := oStmt:fetchAll( FETCH_HASH )

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

   finally

      if !empty( oStmt )
        oStmt:free()
      end if    
   
   end

   if empty( aTableInfo ) .or. !hb_isarray( aTableInfo )
      Return ( nil )
   end if

Return ( aTableInfo )

//---------------------------------------------------------------------------//

METHOD compareCurrentAndActualColumns()

   local nPosColumn
   local hCurrentColumn
   local aCurrentColumns   := ::getColumnsOfCurrentTable()

   for each hCurrentColumn in aCurrentColumns

      nPosColumn           := ascan( hb_hkeys( ::hColumns ), hget( hCurrentColumn, "name" ) )
      
      if nPosColumn != 0

         hb_HDelAt( ::hColumns, nPosColumn )


      end if

   next

Return ( self )

//---------------------------------------------------------------------------//

METHOD updateTableColumns()

   local cAlterTables := ""

   ::compareCurrentAndActualColumns()

   hEval( ::hColumns, {| k, hash | getSQLDatabase():Query( "ALTER TABLE " + ::cTableName + " ADD COLUMN " + k + " " + hget( hash, "create" ) ) } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD serializeColumns()

   local cColumns       := ""

   heval( ::hColumns, {|k| cColumns += k + ";" } )

Return ( cColumns )

//---------------------------------------------------------------------------//

METHOD checksForValid( cColumnToValid )

   local cSentence := "SELECT " + ::cColumnKey + " FROM " + ::cTableName + " WHERE " + cColumnToValid + " = " + toSQLString( ::hBuffer[ cColumnToValid ] )
   local aIDsToValid
   local nIDToValid

   if ( hb_HHasKey( ::hColumns, "empresa" ) )
      cSentence += " AND empresa = " + toSQLString( cCodEmp() )
   end if

   aIDsToValid    := ::selectFetchArray( cSentence )

   if empty( aIDsToValid )
       RETURN ( nil )
   endif
   
   nIDToValid     := aIDsToValid[1]

RETURN ( nIDToValid )

//---------------------------------------------------------------------------//

METHOD getNameFromId( uValue )

   local cName                   := ""
   local cSentence               := "SELECT nombre FROM " + ::cTableName + " WHERE id = " + toSQLString( uValue )
   local aSelect 

   if ( hb_HHasKey( ::hColumns, "empresa" ) )
      cSentence += " AND empresa = " + toSQLString( cCodEmp() )
   end if

   aSelect                       := ::selectFetchHash( cSentence )

   if !empty( aSelect )
      cName                      := hget( atail( aSelect ), "nombre" )
   end if 

RETURN ( cName )

//---------------------------------------------------------------------------//

METHOD getNameFromCodigo( uValue )

   local cName                   := ""
   local cSentence               := "SELECT nombre FROM " + ::cTableName + " WHERE codigo = " + toSQLString( uValue )
   local aSelect                 := ::selectFetchHash( cSentence )

   if !empty( aSelect )
      cName                      := hget( atail( aSelect ), "nombre" )
   end if 

RETURN ( cName )

//---------------------------------------------------------------------------//

METHOD existId( id )

   local cSentence               := "SELECT " + ::cColumnKey + " FROM " + ::cTableName + " WHERE id = " + toSQLString( id )

RETURN ( !empty( ::selectFetchArray( cSentence ) ) )

//---------------------------------------------------------------------------//

METHOD existCodigo( cValue )

   local cSentence               := "SELECT " + ::cColumnKey + " FROM " + ::cTableName + " WHERE " + ::cColumnCode + " = " + toSQLString( cValue )

RETURN ( !empty( ::selectFetchArray( cSentence ) ) )

//---------------------------------------------------------------------------//
