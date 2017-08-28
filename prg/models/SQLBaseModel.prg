#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"
#include "Hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseModel
  
   DATA     oStatement
   DATA     oRowSet

   DATA     cTableName
   DATA     cDbfTableName
	DATA	   hColumns

   DATA     cConstraints

   DATA     hExtraColumns

   DATA     cGeneralSelect

   DATA     cOrientation
   DATA     idToFind

   DATA     cSQLInsert     
   DATA     cSQLSelect      
   
   DATA     cColumnOrder                  INIT "codigo"
   DATA     cColumnKey                    INIT "id"
   DATA     cColumnCode                   INIT "codigo"

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

   METHOD   getTableName                           INLINE   ( ::cTableName )

   METHOD   setColumnOrder( cColumnOrder )         INLINE   ( ::cColumnOrder := cColumnOrder )
   METHOD   setOrientation( cOrientation )         INLINE   ( ::cOrientation := cOrientation )
   METHOD   setIdToFind( idToFind )                INLINE   ( ::idToFind := idToFind )

   METHOD   buildRowSet()
   METHOD   buildRowSetAndFind()       
   METHOD   findInRowSet()          
   METHOD   getRowSet()                            INLINE   ( if( empty( ::oRowSet ), ::buildRowSet(), ), ::oRowSet )
   METHOD   freeRowSet()                           INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet := nil ), ) )
   METHOD   getRowSetRecno()                       INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:recno() ) , 0 ) )
   METHOD   setRowSetRecno( nRecno )               INLINE   ( if( !empty( ::oRowSet ), ( ::oRowSet:goto( nRecno ) ), ) )

   METHOD   getStatement()                         INLINE   ( ::oStatement )
   METHOD   freeStatement()                        INLINE   ( if( !empty( ::oStatement ), ( ::oStatement := nil ), ) )
 
   METHOD   getSelectByColumn()
   METHOD   getSelectByOrder()

   METHOD   setFind( cFind )                       INLINE   ( ::cFind := cFind )
   METHOD   find( cFind )

   METHOD   existId( id )
   METHOD   existCodigo( codigo )

   METHOD   getName()                              INLINE   ( "" )

   METHOD   getBuffer( cColumn )                   INLINE   ( hget( ::hBuffer, cColumn ) )

   METHOD   Query( cSentence )                     INLINE   ( getSQLDatabase():Query( cSentence ) )
   METHOD   Exec( cSentence )                      INLINE   ( getSQLDatabase():Exec( cSentence ) )
   METHOD   Prepare( cSentence )                   INLINE   ( getSQLDatabase():Prepare( cSentence ) )

   METHOD   updateCurrentBuffer()                  INLINE   ( ::Query( ::getUpdateSentence() ), ::buildRowSetAndFind() )
   METHOD   insertBuffer()                         INLINE   ( ::Query( ::getInsertSentence() ), ::buildRowSet() )
   METHOD   deleteSelection( aRecno )              INLINE   ( ::Query( ::getdeleteSentence( aRecno ) ), ::buildRowSet() )

   METHOD   loadBlankBuffer()
   METHOD   defaultCurrentBuffer()
   METHOD   loadCurrentBuffer()

   METHOD   selectFetch( cSentence )
   METHOD   selectFetchArray( cSentence )          
   METHOD   selectFetchHash( cSentence )           INLINE   ( ::selectFetch( cSentence, FETCH_HASH ) )

   METHOD   getDbfTableName()                      INLINE   ( ::cDbfTableName + ".dbf" )
   METHOD   getOldTableName()                      INLINE   ( ::cDbfTableName + ".old" )

   METHOD   getSchemaColumns()

   METHOD   checkTable()
   METHOD   createTable()
   METHOD   updateTable()

   METHOD   serializeColumns()

   METHOD   checksForValid()

   METHOD   getNameFromId( uValue )
   METHOD   getNameFromCodigo( uValue )

   METHOD   getValueField( cColumn, uValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cColumnKey                  := "id"

   ::cFind                       := ""

   ::cGeneralSelect              := "SELECT * FROM " + ::cTableName

   ::cConstraints                := "" 

   ::cOrientation                := "A"

   ::idToFind                    := 0

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()
   
   ::freeRowSet()

   ::freeStatement()

RETURN ( nil )

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

RETURN ( cSQLCreateTable )

//---------------------------------------------------------------------------//

METHOD getSQLDropTable()
   
RETURN ( "DROP TABLE " + ::cTableName )

//---------------------------------------------------------------------------//

METHOD getImportSentence( cPath )
   
   local dbf
   local cValues     := ""
   local cInsert     := ""

   dbUseArea( .t., cLocalDriver(), cPath + "\" + ::getDbfTableName(), cCheckArea( "dbf", @dbf ), .f. )
   if ( dbf )->( neterr() )
      RETURN ( cInsert )
   end if

   cInsert           := "INSERT INTO " + ::cTableName + " ( "
   hEval( ::hColumns, {| k | if ( k != ::cColumnKey, cInsert += k + ", ", ) } )
   cInsert           := ChgAtEnd( cInsert, ' ) VALUES ', 2 )

   ( dbf )->( dbgotop() )
   while ( dbf )->( !eof() )

      cValues        += "( "

            hEval( ::hColumns, {| k, hash | if ( k != ::cColumnKey,;
                                                if ( k == "empresa",;
                                                      cValues += toSQLString( cCodEmp() ) + ", ",;
                                                      cValues += toSQLString( ( dbf )->( fieldget( fieldpos( hget( hash, "field" ) ) ) ) ) + ", "), ) } )
      
      cValues        := chgAtEnd( cValues, ' ), ', 2 )

      ( dbf )->( dbskip() )
   end while

   ( dbf )->( dbclosearea() )

   if empty( cValues )
      RETURN ( nil )
   end if 

   cValues           := chgAtEnd( cValues, '', 2 )

   cInsert           += cValues

RETURN ( cInsert )

//---------------------------------------------------------------------------//

METHOD makeImportDbfSQL( cPath )

   local cImportSentence

   if empty( cPath ) 
      if ( hb_hhaskey( ::hColumns, "empresa" ) )
         cPath       := cPatEmp()
      else
         cPath       := cPatDat()
      end if 
   end if

   if ( file( cPath + "\" + ::getOldTableName() ) )
      RETURN ( self )
   end if

   if !( file( cPath + "\" + ::getDbfTableName() ) )
      msgStop( "El fichero " + cPath + "\" + ::getDbfTableName() + " no se ha localizado", "Atención" )  
      RETURN ( self )
   end if 

   cImportSentence   := ::getImportSentence( cPath )

   if !empty( cImportSentence )

      ::Exec( ::getSQLCreateTable() )

      ::Exec( cImportSentence )
      
   end if 

   frename( cPath + "\" + ::getDbfTableName(), cPath + "\" + ::getOldTableName() )
   
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD buildRowSetAndFind()

   ::buildRowSet()

   ::findInRowSet()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD buildRowSet( cSentence )

   default cSentence    := ::getSelectSentence()

   try

      //oStatement             := ::Query( cSentence )
      ::oStatement      := ::Prepare( cSentence )
      ::oRowSet         := ::oStatement:fetchRowSet()

      msgalert( hb_valtoexp( ::oRowset ), "oRowset" )

   catch
      
      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )
      
   finally

//      if !empty( oStatement )
//         oStatement:free()
//      end if    
   
   end

   ::oRowSet:goTop()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD findInRowSet()

   if empty( ::oRowSet )
      RETURN ( self )
   end if 

   if empty( ::idToFind ) .or. empty( ::cColumnKey )
      RETURN ( self )
   end if 

   if ::oRowSet:find( ::idToFind, ::cColumnKey, .t. ) == 0
      ::oRowSet:goTop()
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getUpdateSentence()

  local cSQLUpdate  := "UPDATE " + ::cTableName + " SET "

  hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLUpdate += k + " = " + toSQLString( v ) + ", ", ) } )

  cSQLUpdate        := ChgAtEnd( cSQLUpdate, '', 2 )

  cSQLUpdate        += " WHERE " + ::cColumnKey + " = " + toSQLString( ::hBuffer[ ::cColumnKey ] )

RETURN ( cSQLUpdate )

//---------------------------------------------------------------------------//

METHOD getInsertSentence()

   Local cSQLInsert

   cSQLInsert        := "INSERT INTO " + ::cTableName + " ( "

   hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += k + ", ", ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' ) VALUES ( ', 2 )

   hEval( ::hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += toSQLString( v ) + ", ", ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' )', 2 )

   msgalert( cSQLInsert, "getInsertSentence" )

RETURN ( cSQLInsert )

//---------------------------------------------------------------------------//

METHOD getValueField( cColumn, uValue )

   local bValue
   local hColumn

   if !hhaskey( ::hColumns, cColumn )
      RETURN ( uValue )
   end if 

   hColumn        := hGet( ::hColumns, cColumn )

   if hhaskey( hColumn, "default" )

      bValue      := hGet( hColumn, "default" )
      
      if !empty( bValue ) .and. hb_isblock( bValue )
         uValue   := eval( bValue )
      end if

   end if

RETURN ( uValue )

//---------------------------------------------------------------------------//

METHOD convertRecnoToId( aRecno )

   local nRecno
   local aId         := {}

   for each nRecno in ( aRecno )
      ::oRowset:goTo( nRecno )
      aadd( aId, ::oRowset:fieldget( ::cColumnKey ) )
   next

RETURN ( aId )

//---------------------------------------------------------------------------//

METHOD getDeleteSentence( aRecno )

   local aId            := ::convertRecnoToId( aRecno )

   local cSQLDelete     := "DELETE FROM " + ::cTableName + " WHERE " 

   aeval( aId, {| v | cSQLDelete += ::cColumnKey + " = " + toSQLString( v ) + " or " } )

   cSQLDelete           := ChgAtEnd( cSQLDelete, '', 4 )

RETURN ( cSQLDelete )

//---------------------------------------------------------------------------//

METHOD getSelectSentence() 

   local cSQLSelect  := ::cGeneralSelect

   if ( hb_hhaskey( ::hColumns, "empresa" ) )
      cSQLSelect     += " WHERE empresa = " + toSQLString( cCodEmp() )
   end if

   cSQLSelect        := ::getSelectByColumn( cSQLSelect )

   cSQLSelect        := ::getSelectByOrder( cSQLSelect )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectByColumn( cSQLSelect )

   if !empty( ::cColumnOrder ) .and. !empty( ::cFind )
      
      if ( hb_at( "WHERE", cSQLSelect) != 0 )
         cSQLSelect  += " AND"
      else
         cSQLSelect  += " WHERE"
      end if

      cSQLSelect     += " UPPER(" + ::cColumnOrder +") LIKE '%" + Upper( ::cFind ) + "%'" 

   end if

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectByOrder( cSQLSelect )

   if !empty( ::cColumnOrder )
      cSQLSelect     += " ORDER BY " + ::cColumnOrder 
   end if 

   if !empty( ::cOrientation ) .and. ::cOrientation == "D"
      cSQLSelect     += " DESC"
   end if

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD find( cFind )

   ::setFind( cFind )

   ::buildRowSet()

RETURN ( ::oRowSet:recCount() > 0 )

//----------------------------------------------------------------------------//

METHOD loadBlankBuffer()

   if empty( ::oRowSet )
      RETURN ( .f. )
   end if 

   ::oRowSet:goto( 0 )

   ::loadCurrentBuffer()

RETURN ( ::defaultCurrentBuffer() )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer()                

   local h

   if empty( ::oRowSet )
      RETURN ( .f. )
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

         case ( hhaskey( h, "type" ) .and. h[ "type" ] == "T" .and. empty( ::oRowSet:fieldget( h:__enumkey() ) ) )

            hset( ::hBuffer, h:__enumkey(), hb_datetime() )

         case ( !hhaskey( h, "type" ) .and. empty( ::oRowSet:fieldget( h:__enumkey() ) ) )

            hset( ::hBuffer, h:__enumkey(), nil )

         otherwise

            hset( ::hBuffer, h:__enumkey(), ::oRowSet:fieldget( h:__enumkey() ) )

      end if

   next

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD defaultCurrentBuffer()                

   local h

   for each h in ::hColumns

      if hhaskey( h, "default" ) .and. hb_isblock( hget( h, "default" ) )

         hset( ::hBuffer, h:__enumkey(), eval( hget( h, "default" ) ) )

      end if

   next

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD selectFetch( cSentence, fetchType )

   local aFetch

   default fetchType := FETCH_ARRAY

   try 

      ::oStatement   := ::Prepare( cSentence )
   
      aFetch         := ::oStatement:fetchAll( fetchType )

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

   finally

      // if !empty( oStatement )
      //   oStatement:free()
      // end if    
   
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

METHOD getSchemaColumns()

   local oStatement
   local aSchemaColumns
   local cSentence

   cSentence         := "SELECT COLUMN_NAME "                              +;
                           "FROM INFORMATION_SCHEMA.COLUMNS "              +;
                           "WHERE table_name = " + quoted( ::cTableName )

   try

      oStatement           := ::Query( cSentence )
   
      aSchemaColumns       := oStatement:fetchAll( FETCH_HASH )

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

   finally

      if !empty( oStatement )
        oStatement:free()
      end if    
   
   end

   if empty( aSchemaColumns ) .or. !hb_isarray( aSchemaColumns )
      RETURN ( nil )
   end if

RETURN ( aSchemaColumns )

//---------------------------------------------------------------------------//

METHOD updateTable( aSchemaColumns )

   local hColumn
   local hColumns
   local nPosition

   hColumns       := hClone( ::hColumns )

   for each hColumn in aSchemaColumns

      nPosition   := ascan( hb_hkeys( hColumns ), hget( hColumn, "COLUMN_NAME" ) )
      
      if nPosition != 0
         hb_hdelat( hColumns, nPosition )
      end if

   next

   if !empty( hColumns )
      heval( hColumns, {| k, hash | ::Exec( "ALTER TABLE " + ::cTableName + " ADD COLUMN " + k + " " + hget( hash, "create" ) ) } )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD checkTable()

   local aSchemaColumns    := ::getSchemaColumns()

   if empty( aSchemaColumns )
      ::createTable()
   else 
      ::updateTable( aSchemaColumns )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD createTable()

RETURN ( ::Exec( ::getSQLCreateTable() ) )  

//----------------------------------------------------------------------------//

METHOD serializeColumns()

   local cColumns       := ""

   heval( ::hColumns, {|k| cColumns += k + ";" } )

RETURN ( cColumns )

//---------------------------------------------------------------------------//

METHOD checksForValid( cColumnToValid )

   local cSentence := "SELECT " + ::cColumnKey + " FROM " + ::cTableName + " WHERE " + cColumnToValid + " = " + toSQLString( ::hBuffer[ cColumnToValid ] )
   local aIDsToValid
   local nIDToValid

   if ( hb_hhaskey( ::hColumns, "empresa" ) )
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

   if ( hb_hhaskey( ::hColumns, "empresa" ) )
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
