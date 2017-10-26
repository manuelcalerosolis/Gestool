#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseModel
  
   DATA oDatabase

   DATA oController

   DATA oEvents

   DATA oRowSet

   DATA oStatement

   DATA cTableName

   DATA cConstraints

   DATA hColumns                                   INIT {=>}

   DATA cColumnOrientation

   DATA cGeneralSelect                                 

   DATA cGeneralWhere
   
   DATA cColumnOrder                  
   DATA cColumnKey                    
   DATA cColumnCode                                INIT "codigo"

   DATA hBuffer 

   DATA cFind
   DATA idToFind

   DATA aRecordsToDelete

   METHOD New()
   METHOD End()

   METHOD setDatabase( oDb )                       INLINE ( ::oDatabase := oDb )
   METHOD getDatabase()                            INLINE ( if( empty( ::oDatabase ), getSQLDatabase(), ::oDatabase ) )

   METHOD TimeStampFields()

   // Facades -----------------------------------------------------------------

   METHOD getTableName()                           INLINE ( ::cTableName )
   METHOD getColumns()                             INLINE ( ::hColumns )
   METHOD getTableColumns()                        

   METHOD getColumnsForBrowse()
   METHOD getHeadersForBrowse()

   METHOD getValueFromColumn( cColumn, cKey )
   METHOD getHeaderFromColumn( cColumn )           INLINE ( ::getValueFromColumn( cColumn, "header" ) )
   METHOD getHeaderFromColumnOrder()               INLINE ( ::getValueFromColumn( ::cColumnOrder, "header" ) )

   // -------------------------------------------------------------------------

   METHOD isEmpresaColumn()                        INLINE ( hb_hhaskey( ::hColumns, "empresa" ) )

   // Sentences----------------------------------------------------------------
 
   METHOD getCreateTableSentence()
   METHOD getAlterTableSentences()

   METHOD getGeneralSelect()
   METHOD getSelectSentence()
   
   METHOD getInsertSentence()
   METHOD getUpdateSentence()
   METHOD getdeleteSentence()
   
   METHOD getDropTableSentence()

   METHOD setGeneralSelect( cSelect )                 INLINE ( ::cGeneralSelect  := cSelect )
   METHOD setGeneralWhere( cWhere )                   INLINE ( ::cGeneralWhere   := cWhere )

   // Where for columns---------------------------------------------------------

   METHOD getWhereOrAnd( cSQLSelect )                 INLINE ( if( hb_at( "WHERE", cSQLSelect ) != 0, " AND ", " WHERE " ) )

   METHOD getWhereGeneral( cSQLSelect )
   METHOD getWhereEmpresa()                           

   // Get edit value for xbrowse-----------------------------------------------

   METHOD getEditValue()
   METHOD getValueField( cColumn, uValue )

   METHOD getMethod( cMethod )

   METHOD convertRecnoToId( aRecno )

   METHOD setIdToFind( idToFind )                     INLINE ( ::idToFind := idToFind )
   METHOD saveIdToFind()                              INLINE ( ::idToFind := ::getRowSet():fieldGet( ::cColumnKey ) ) 

   METHOD setColumnOrder( cColumnOrder )              INLINE ( ::cColumnOrder := cColumnOrder )
   METHOD getColumnOrder()                            INLINE ( ::cColumnOrder )

   METHOD setColumnOrientation( cColumnOrientation )  INLINE ( ::cColumnOrientation := cColumnOrientation )

   // Rowset-------------------------------------------------------------------

   METHOD buildRowSet( cSentence )                    
   METHOD newRowSet( cSentence )                      
   METHOD buildRowSetAndFind( idToFind )              INLINE ( ::buildRowSet(), ::findInRowSet( idToFind ) )


   METHOD findInRowSet()          
   METHOD getRowSet()                                 INLINE ( if( empty( ::oRowSet ), ::buildRowSet(), ), ::oRowSet )
   METHOD freeRowSet()                                INLINE ( if( !empty( ::oRowSet ), ( ::oRowSet:free(), ::oRowSet := nil ), ) )
   METHOD freeStatement()                             INLINE ( if( !empty( ::oStatement ), ( ::oStatement:free(), ::oStatement := nil ), ) )

   METHOD getRowSetRecno()                            INLINE ( ::getRowSet():recno() )
   METHOD setRowSetRecno( nRecno )                    INLINE ( ::getRowSet():goto( nRecno ) )
   METHOD getRowSetFieldGet( cColumn )                INLINE ( ::getRowSet():fieldget( cColumn ) )
   METHOD getRowSetFieldValueByName( cColumn )        INLINE ( ::getRowSet():getValueByName( cColumn ) )

   METHOD getSelectByColumn()
   METHOD getSelectByOrder()

   METHOD setFind( cFind )                            INLINE ( ::cFind := cFind )
   METHOD find( cFind )

   METHOD getBuffer( cColumn )                        INLINE ( hget( ::hBuffer, cColumn ) )
   
   METHOD insertBuffer( hBuffer )                     INLINE ( ::getDatabase():Execs( ::getInsertSentence( hBuffer ) ), ::buildRowSetAndFind( ::getDatabase():LastInsertId() ) )
   METHOD updateBuffer( hBuffer )                     INLINE ( ::getDatabase():Execs( ::getUpdateSentence( hBuffer ) ), ::buildRowSetAndFind() )
   METHOD deleteSelection( aRecno )

   METHOD loadBlankBuffer()
   METHOD loadDuplicateBuffer() 
   METHOD loadCurrentBuffer()
   METHOD defaultCurrentBuffer()

   METHOD serializeColumns()

   // Events-------------------------------------------------------------------

   METHOD setEvent( cEvent, bEvent )                  INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )                         INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   if empty( ::hColumns )
      msgstop( "La definición de columnas no puede estar vacia" )
      RETURN ( Self )
   end if 

   ::oController                 := oController

   ::oDatabase                   := getSQLDatabase()

   ::oEvents                     := Events():New()

   if empty( ::cColumnKey )
      ::cColumnKey               := hGetKeyAt( ::hColumns, 1 )
   end if 

   if empty( ::cColumnOrder )
      ::cColumnOrder             := hGetKeyAt( ::hColumns, 1 )
   end if 

   ::cGeneralSelect              := "SELECT * FROM " + ::getTableName()    

   ::cColumnOrientation          := "A"

   ::cConstraints                := "" 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oEvents:End()
   
   ::freeRowSet()

   ::freeStatement()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD TimeStampFields()

   hset( ::hColumns, "created_at",  {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"      ,;
                                       "text"      => "Creación fecha y hora"                   ,;
                                       "header"    => "Creación"                                ,;
                                       "default"   => {|| hb_datetime() } }                     )

   hset( ::hColumns, "updated_at",  {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"      ,;
                                       "text"      => "Modificación fecha y hora"               ,;
                                       "header"    => "Modificación"                            ,;
                                       "default"   => {|| hb_datetime() } }                     )

   hset( ::hColumns, "deleted_at",  {  "create"    => "DATETIME"      ,;
                                       "text"      => "Eliminación fecha y hora"                ,;
                                       "header"    => "Eliminación"                             ,;
                                       "default"   => {|| nil } }                            )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getGeneralSelect()

   local cSQLSelect        := ::cGeneralSelect

   cSQLSelect              := ::getWhereGeneral( cSQLSelect )

   cSQLSelect              := ::getWhereEmpresa( cSQLSelect )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectSentence() 

   local cSQLSelect        := ::getGeneralSelect()

   cSQLSelect              := ::getSelectByColumn( cSQLSelect )

   cSQLSelect              := ::getSelectByOrder( cSQLSelect )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getWhereEmpresa( cSQLSelect )

   if !::isEmpresaColumn()
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) + "empresa = " + toSQLString( cCodEmp() )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getWhereGeneral( cSQLSelect )

   if empty( ::cGeneralWhere )
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) + ::cGeneralWhere 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectByColumn( cSQLSelect )

   if empty( ::cColumnOrder ) .or. empty( ::cFind )
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) + "UPPER(" + ::cColumnOrder +") LIKE '%" + Upper( ::cFind ) + "%'" 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectByOrder( cSQLSelect )

   if !empty( ::cColumnOrder )
      cSQLSelect     += " ORDER BY " + ::cColumnOrder 
   end if 

   if !empty( ::cColumnOrientation ) .and. ::cColumnOrientation == "D"
      cSQLSelect     += " DESC"
   end if

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getCreateTableSentence()
   
   local cSQLCreateTable 

   cSQLCreateTable         := "CREATE TABLE " + ::cTableName + " ( "

   hEval( ::hColumns,;
      {| k, hash | if( hhaskey( hash, "create" ), cSQLCreateTable += k + " " + hget( hash, "create" ) + ", ", ) } )
   
   if !empty( ::cConstraints )

      cSQLCreateTable      += ::cConstraints + " )"

   else

      cSQLCreateTable      := ChgAtEnd( cSQLCreateTable, ' )', 2 )

   end if 

RETURN ( cSQLCreateTable )

//---------------------------------------------------------------------------//

METHOD getAlterTableSentences( aSchemaColumns ) 

   local aAlter
   local hColumn
   local hColumns
   local nPosition

   if empty( aSchemaColumns )
      RETURN ( self )
   end if 

   aAlter         := {}
   hColumns       := hClone( ::hColumns )

   for each hColumn in aSchemaColumns

      nPosition   := ascan( hb_hkeys( hColumns ), hget( hColumn, "COLUMN_NAME" ) )
      
      if nPosition != 0
         hb_hdelat( hColumns, nPosition )
      end if

   next

   if !empty( hColumns )
      heval( hColumns, {| k, hash | aadd( aAlter, "ALTER TABLE " + ::cTableName + " ADD COLUMN " + k + " " + hget( hash, "create" ) ) } )
   end if 

RETURN ( aAlter )

//---------------------------------------------------------------------------//

METHOD getDropTableSentence()
   
RETURN ( "DROP TABLE " + ::cTableName )

//---------------------------------------------------------------------------//

METHOD buildRowSet( cSentence )

   ::fireEvent( 'buildingRowSet')

   ::oRowSet   := ::newRowSet( cSentence )

   ::fireEvent( 'builtRowSet')

RETURN ( ::oRowSet )

//---------------------------------------------------------------------------//

METHOD newRowSet( cSentence )

   local oError
   local oRowSet

   DEFAULT cSentence    := ::getSelectSentence()

   try
 
      ::freeStatement()

      ::oStatement      := ::getDatabase():Query( cSentence )

      ::oStatement:setAttribute( ATTR_STR_PAD, .t. )
      
      oRowSet           := ::oStatement:fetchRowSet()

   catch oError

      eval( errorBlock(), oError )

   end

   oRowSet:goTop()

RETURN ( oRowSet )

//---------------------------------------------------------------------------//

METHOD findInRowSet( idToFind )

   if empty( ::oRowSet )
      RETURN ( self )
   end if 

   DEFAULT idToFind  := ::idToFind

   if empty( idToFind ) .or. empty( ::cColumnKey )
      RETURN ( self )
   end if 

   if ::oRowSet:find( idToFind, ::cColumnKey, .t. ) == 0
      ::oRowSet:goTop()
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getInsertSentence( hBuffer )

   local cSQLInsert

   DEFAULT hBuffer   := ::hBuffer

   cSQLInsert        := "INSERT INTO " + ::cTableName + " ( "

   hEval( hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += k + ", ", ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' ) VALUES ( ', 2 )

   hEval( hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += toSQLString( v ) + ", ", ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' )', 2 )

RETURN ( cSQLInsert )

//---------------------------------------------------------------------------//

METHOD getUpdateSentence( hBuffer )

   local uValue
   local cSQLUpdate  

   DEFAULT hBuffer   := ::hBuffer

   cSQLUpdate        := "UPDATE " + ::cTableName + " SET "

   for each uValue in hBuffer
      if ( uValue:__enumkey() != ::cColumnKey )
         cSQLUpdate  += uValue:__enumKey() + " = " + toSQLString( uValue ) + ", "
      end if 
   next

   cSQLUpdate        := chgAtEnd( cSQLUpdate, '', 2 )

   cSQLUpdate        += " WHERE " + ::cColumnKey + " = " + toSQLString( hget( hBuffer, ::cColumnKey ) )

RETURN ( cSQLUpdate )

//---------------------------------------------------------------------------//

METHOD getDeleteSentence( aRecno )

   local aId            := ::convertRecnoToId( aRecno )
   local cSQLDelete     := "DELETE FROM " + ::cTableName + " WHERE " 

   aeval( aId, {| v | cSQLDelete += ::cColumnKey + " = " + toSQLString( v ) + " or " } )

   cSQLDelete           := ChgAtEnd( cSQLDelete, '', 4 )

RETURN ( cSQLDelete )

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

METHOD getEditValue( cColumn )

   local bValue
   local hColumn

   if !hhaskey( ::hColumns, cColumn ) 
      RETURN ( nil )
   end if 

   hColumn        := hGet( ::hColumns, cColumn )

   if hhaskey( hColumn, "edit" )
      RETURN ( hGet( hColumn, "edit" ) )
   end if 

RETURN ( {|| ::getRowSet():fieldGet( cColumn ) } )

//---------------------------------------------------------------------------//

METHOD getMethod( cMethod )

RETURN ( {|| Self:&( cMethod ) } )

//---------------------------------------------------------------------------//

METHOD convertRecnoToId( aRecno, cColumnKey )

   local nRecno
   local aId         := {}

   DEFAULT cColumnKey   := ::cColumnKey

   for each nRecno in ( aRecno )
      ::oRowSet:goTo( nRecno )
      aadd( aId, ::oRowSet:fieldget( cColumnKey ) )
   next

RETURN ( aId )

//---------------------------------------------------------------------------//

METHOD find( uFind, cColumn )

   ::setFind( uFind )

   ::buildRowSet()

RETURN ( ::getRowSet():reccount() > 0 )

//----------------------------------------------------------------------------//

METHOD loadBlankBuffer()

   local nRecno
   local hColumn

   ::hBuffer            := {=>}

   nRecno               := ::oRowSet:recno()
   ::oRowSet:goto( 0 )

   ::fireEvent( 'loadingBlankBuffer' )

   heval( ::getTableColumns(), {|k| hset( ::hBuffer, k, ::oRowSet:fieldget( k ) ) } )

   ::oRowSet:goto( nRecno )

   ::defaultCurrentBuffer()

   ::fireEvent( 'loadedBlankBuffer' )

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer()                

   if empty( ::oRowSet )
      RETURN ( .f. )
   end if 

   ::fireEvent( 'loadingcurrentbuffer' )

   ::hBuffer            := {=>}

   hEval( ::getTableColumns(), {|k| hset( ::hBuffer, k, ::oRowSet:fieldget( k ) ) } )

   ::fireEvent( 'loadedcurrentbuffer' )

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD loadDuplicateBuffer()                

   if empty( ::oRowSet )
      RETURN ( .f. )
   end if 

   ::hBuffer            := {=>}

   ::fireEvent( 'loadingduplicatebuffer' )

   hEval( ::getTableColumns(), {|k| if( k != ::cColumnKey, hset( ::hBuffer, k, ::oRowSet:fieldget( k ) ), ) } )

   ::fireEvent( 'loadedduplicatebuffer' )

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD defaultCurrentBuffer()                

   local h

   for each h in ::getTableColumns()

      if hhaskey( h, "default" ) .and. hb_isblock( hget( h, "default" ) )

         hset( ::hBuffer, h:__enumkey(), eval( hget( h, "default" ) ) )

      end if

   next

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD serializeColumns()

   local cColumns       := ""

   heval( ::getTableColumns(), {|k| cColumns += k + ";" } )

RETURN ( cColumns )

//---------------------------------------------------------------------------//

STATIC FUNCTION validColumnForNavigator( hash )

RETURN ( hhaskey( hash, "visible" ) .and. hget( hash, "visible" ) .and. hhaskey( hash, "header" ) .and. hhaskey( hash, "width" ) )
                                    
//---------------------------------------------------------------------------//

METHOD getTableColumns()

   local hColumns    := {=>}

   heval( ::hColumns, {|k,v| if( hhaskey( v, "create" ), hset( hColumns, k, v ), ) } )

RETURN ( hColumns )   

//---------------------------------------------------------------------------//

METHOD getColumnsForBrowse()
   
   local hColumns    := {=>}

   hEval( ::hColumns, {|k,v| if( validColumnForNavigator( v ), hset( hColumns, k, v ), ) } )
         
RETURN ( hColumns )

//---------------------------------------------------------------------------//

METHOD getHeadersForBrowse()

   local aHeaders    := {}

   hEval( ::hColumns, {|k,v| if( validColumnForNavigator( v ), aadd( aHeaders, hget( v, "header" ) ), ) } )
         
RETURN ( aHeaders )

//---------------------------------------------------------------------------//

METHOD getValueFromColumn( cColumn, cKey )

   local nScan      
   local hValue 
   local uValue   := ""

   nScan          := hScan( ::hColumns,  {|k| k == cColumn } )
   if nScan != 0

      hValue      := hGetValueAt( ::hColumns, nScan )
   
      if hb_ishash( hValue ) .and. hhaskey( hValue, cKey )
         uValue  := hGet( hValue, cKey )
      end if 

   end if 

RETURN ( uValue )

//---------------------------------------------------------------------------//

METHOD deleteSelection( aRecno ) 

   ::aRecordsToDelete   := aRecno

   ::fireEvent( 'deletingSelection' )

   ::getDatabase():Query( ::getdeleteSentence( aRecno ) )

   ::buildRowSet()

   ::fireEvent( 'deletedSelection' )

RETURN ( Self )

//---------------------------------------------------------------------------//