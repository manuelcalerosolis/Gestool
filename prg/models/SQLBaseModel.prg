#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseModel
  
   DATA oDatabase

   DATA oController

   DATA oEvents

   DATA oStatement

   DATA cTableName

   DATA cConstraints

   DATA hColumns                                   INIT {=>}

   DATA cColumnOrientation

   DATA cGeneralSelect                                                              

   DATA cGeneralWhere

   DATA cFilterWhere
   
   DATA cColumnOrder                  
   DATA cColumnKey                    
   DATA cColumnCode                                INIT "codigo"

   DATA hBuffer 

   DATA cFind

   DATA aRecordsToDelete

   METHOD New()
   METHOD End()

   // Facades -----------------------------------------------------------------

   METHOD setDatabase( oDb )                       INLINE ( ::oDatabase := oDb )
   METHOD getDatabase()                            INLINE ( if( empty( ::oDatabase ), getSQLDatabase(), ::oDatabase ) )

   METHOD getTableName()                           INLINE ( ::cTableName )

   // Columns-------------------------------------------------------------------

   METHOD getColumns()                             VIRTUAL
   METHOD getTableColumns() 

   METHOD getSerializeColumns()

   METHOD getColumnsForBrowse()
   METHOD getHeadersForBrowse()

   METHOD TimeStampColumns()

   METHOD getValueFromColumn( cColumn, cKey )
   METHOD getHeaderFromColumn( cColumn )              INLINE ( ::getValueFromColumn( cColumn, "header" ) )
   METHOD getHeaderFromColumnOrder()                  INLINE ( ::getValueFromColumn( ::cColumnOrder, "header" ) )
   METHOD getLenFromColumn( cColumn )                 INLINE ( ::getValueFromColumn( cColumn, "len" ) )

   // Sentences----------------------------------------------------------------

   METHOD getCreateTableSentence()
   METHOD getAlterTableSentences()
   
   METHOD getGeneralSelect()
   METHOD getIdSelect( id )
   METHOD getSelectSentence()
   
   METHOD getInsertSentence()
   METHOD getUpdateSentence()
   METHOD getdeleteSentence()
   
   METHOD getDropTableSentence()

   METHOD setGeneralSelect( cSelect )                 INLINE ( ::cGeneralSelect  := cSelect )
   METHOD setGeneralWhere( cWhere )                   INLINE ( ::cGeneralWhere   := cWhere )
   METHOD aadGeneralWhere( cSQLSelect )
   
   METHOD addEmpresaWhere()                           

   METHOD setFilterWhere( cWhere )                    INLINE ( ::cFilterWhere   := cWhere )
   METHOD clearFilterWhere()                          INLINE ( ::cFilterWhere   := nil )
   METHOD addFilterWhere( cSQLSelect )

   METHOD getWhereOrAnd( cSQLSelect )                 INLINE ( if( hb_at( "WHERE", cSQLSelect ) != 0, " AND ", " WHERE " ) )

   // Where for columns---------------------------------------------------------

   METHOD isEmpresaColumn()                           INLINE ( hb_hhaskey( ::hColumns, "empresa" ) )

   // Get edit value for xbrowse-----------------------------------------------

   METHOD getEditValue()
   METHOD getValueField( cColumn, uValue )

   METHOD getMethod( cMethod )

   METHOD convertRecnoToId( aRecno )

   METHOD setColumnOrder( cColumnOrder )              INLINE ( ::cColumnOrder := cColumnOrder )
   METHOD getColumnOrder()                            INLINE ( ::cColumnOrder )

   METHOD setColumnOrientation( cColumnOrientation )  INLINE ( ::cColumnOrientation := cColumnOrientation )

   // Rowset-------------------------------------------------------------------

   METHOD newRowSet( cSentence )                      
   METHOD buildRowSet( cSentence )                    

   METHOD getRowSet()                                 INLINE ( if( empty( ::oRowSet ), ::buildRowSet(), ), ::oRowSet )
   METHOD freeRowSet()                                INLINE ( if( !empty( ::oRowSet ), ( ::oRowSet:free(), ::oRowSet := nil ), ) )
   METHOD freeStatement()                             INLINE ( if( !empty( ::oStatement ), ( ::oStatement:free(), ::oStatement := nil ), ) )

   METHOD getRowSetRecno()                            INLINE ( ::getRowSet():recno() )
   METHOD setRowSetRecno( nRecno )                    INLINE ( ::getRowSet():goto( nRecno ) )
   METHOD getRowSetFieldGet( cColumn )                INLINE ( ::getRowSet():fieldget( cColumn ) )
   METHOD getRowSetFieldValueByName( cColumn )        INLINE ( ::getRowSet():getValueByName( cColumn ) )

   METHOD getSelectByColumn()
   METHOD getSelectByOrder()

   // Busquedas----------------------------------------------------------------

   METHOD setFind( cFind )                            INLINE ( ::cFind := cFind )
   METHOD findInRowSet()  
   METHOD findById( nId )
   METHOD findAndBuildRowSet()        
   
   // Busquedas----------------------------------------------------------------

   METHOD getBuffer( cColumn )                        
   METHOD setBuffer( cColumn, uValue )
   METHOD setBufferPadr( cColumn, uValue )
   
   METHOD insertBuffer( hBuffer )                     
   METHOD updateBuffer( hBuffer )
   METHOD deleteSelection( aRecno )

   METHOD loadBlankBuffer()
   METHOD loadDuplicateBuffer() 
   METHOD loadCurrentBuffer()
   METHOD defaultCurrentBuffer()

   // Events-------------------------------------------------------------------

   METHOD setEvent( cEvent, bEvent )                  INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )                         INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )

   METHOD getEmpresaColumns()

   METHOD getDeleteSentenceByColumnKey( nId )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   if empty( ::hColumns ) .and. empty( ::getColumns() )
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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oEvents:End()
   
   ::freeRowSet()

   ::freeStatement()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD TimeStampColumns()

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

   cSQLSelect              := ::aadGeneralWhere( cSQLSelect )

   cSQLSelect              := ::addEmpresaWhere( cSQLSelect )

   cSQLSelect              := ::addFilterWhere( cSQLSelect )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getIdSelect( id )

   local cSQLSelect        := ::cGeneralSelect + space( 1 )

   cSQLSelect              += "WHERE id = " + toSQLString( id )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectSentence() 

   local cSQLSelect        := ::getGeneralSelect()

   cSQLSelect              := ::getSelectByColumn( cSQLSelect )

   cSQLSelect              := ::getSelectByOrder( cSQLSelect )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD aadGeneralWhere( cSQLSelect )

   if empty( ::cGeneralWhere )
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) + ::cGeneralWhere 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addEmpresaWhere( cSQLSelect )

   if !::isEmpresaColumn()
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) + "empresa = " + toSQLString( cCodEmp() )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addFilterWhere( cSQLSelect )

   if empty( ::cFilterWhere )
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) + ::cFilterWhere

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

   hEval( ::getColumns(),;
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
   hColumns       := ::getTableColumns()

   for each hColumn in aSchemaColumns

      nPosition   := ascan( hb_hkeys( hColumns ), hget( hColumn, "COLUMN_NAME" ) )
      
      if nPosition != 0
         hb_hdelat( hColumns, nPosition )
      else 
         aadd( aAlter, "ALTER TABLE " + ::cTableName + " DROP COLUMN " + hget( hColumn, "COLUMN_NAME" ) )
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

METHOD findById( id )

   local cSentence   := ::getIdSelect( id )

RETURN ( atail( ::getDatabase():selectFetchHash( cSentence ) ) )

//---------------------------------------------------------------------------//

METHOD buildRowSet( cSentence )

   DEFAULT cSentence    := ::getSelectSentence()

   ::fireEvent( 'buildingRowSet')
   
   ::newRowSet( cSentence )

   ::fireEvent( 'builtRowSet')

RETURN ( ::oRowSet )

//---------------------------------------------------------------------------//

METHOD newRowSet( cSentence )

   local oError
   local oRowSet

   DEFAULT cSentence    := ::getSelectSentence()

   try

      ::freeRowSet()

      ::freeStatement()

      ::oStatement      := ::getDatabase():Query( cSentence )

      ::oStatement:setAttribute( ATTR_STR_PAD, .t. )
      
      ::oRowSet         := ::oStatement:fetchRowSet()

   catch oError

      eval( errorBlock(), oError )

   end

   ::oRowSet:goTop()

RETURN ( ::oRowSet )

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

METHOD getDeleteSentenceByColumnKey( nId )

   local cSQLDelete  := "DELETE FROM " + ::cTableName + space( 1 ) + ;
                           "WHERE " + ::cColumnKey + " = " + toSQLString( nId ) 

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

RETURN ( cColumn ) // {|| ::getRowSet():fieldGet( cColumn ) } )

//---------------------------------------------------------------------------//

METHOD getMethod( cMethod )

RETURN ( {|| Self:&( cMethod ) } )

//---------------------------------------------------------------------------//

METHOD convertRecnoToId( aRecno, cColumnKey )

   local nRecno
   local aId            := {}

   DEFAULT cColumnKey   := ::cColumnKey

   for each nRecno in ( aRecno )
      ::oRowSet:goTo( nRecno )
      aadd( aId, ::oRowSet:fieldget( cColumnKey ) )
   next

RETURN ( aId )

//---------------------------------------------------------------------------//

METHOD findAndBuildRowSet( uFind, cColumn )

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

METHOD loadCurrentBuffer( id )                

   ::hBuffer            := {=>}

   ::fireEvent( 'loadingcurrentbuffer' )

   if empty( id )
      if !empty( ::oRowSet )
         hEval( ::getTableColumns(), {|k| hset( ::hBuffer, k, ::oRowSet:fieldget( k ) ) } )
      end if
   else
      ::hBuffer         := ::findById( id )
   end if  

   ::fireEvent( 'loadedcurrentbuffer' )

   msgalert( hb_valtoexp( ::hBuffer ) )

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

METHOD getSerializeColumns()

   local cColumns       := ""

   heval( ::getTableColumns(), {|cColumn| cColumns += alltrim( cColumn ) + ";" } )

RETURN ( cColumns )

//---------------------------------------------------------------------------//

STATIC FUNCTION validColumnForNavigator( hash )

RETURN ( hhaskey( hash, "visible" ) .and. hget( hash, "visible" ) .and. hhaskey( hash, "header" ) .and. hhaskey( hash, "width" ) )
                                    
//---------------------------------------------------------------------------//

METHOD getTableColumns()

   local hColumns    := {=>}

   heval( ::getColumns(), {|k,v| if( hhaskey( v, "create" ), hset( hColumns, k, v ), ) } )

RETURN ( hColumns )   

//---------------------------------------------------------------------------//

METHOD getColumnsForBrowse()
   
   local hColumns    := {=>}

   hEval( ::getColumns(), {|k,v| if( validColumnForNavigator( v ), hset( hColumns, k, v ), ) } )
         
RETURN ( hColumns )

//---------------------------------------------------------------------------//

METHOD getHeadersForBrowse()

   local aHeaders    := {}

   hEval( ::getColumns(), {|k,v| if( validColumnForNavigator( v ), aadd( aHeaders, hget( v, "header" ) ), ) } )
         
RETURN ( aHeaders )

//---------------------------------------------------------------------------//

METHOD getValueFromColumn( cColumn, cKey )

   local nScan      
   local hValue 
   local uValue   := ""

   nScan          := hScan( ::hColumns, {|k| k == cColumn } )
   if nScan != 0

      hValue      := hGetValueAt( ::hColumns, nScan )
   
      if hb_ishash( hValue ) .and. hhaskey( hValue, cKey )
         uValue  := hGet( hValue, cKey )
      end if 

   end if 

RETURN ( uValue )

//---------------------------------------------------------------------------//

METHOD insertBuffer( hBuffer )

   ::fireEvent( 'insertingBuffer' )

   ::getDatabase():Execs( ::getInsertSentence( hBuffer ) )

   ::fireEvent( 'insertedBuffer' )

   ::buildRowSetAndFind( ::getDatabase():LastInsertId() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD updateBuffer( hBuffer )

   ::fireEvent( 'updatingBuffer' )

   ::getDatabase():Execs( ::getUpdateSentence( hBuffer ) )

   ::fireEvent( 'updatedBuffer' )

   ::buildRowSetAndFind() 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteSelection( aRecno ) 

   ::aRecordsToDelete   := aRecno

   ::fireEvent( 'deletingSelection' )

   ::getDatabase():Query( ::getdeleteSentence( aRecno ) )

   ::fireEvent( 'deletedSelection' )
   
   ::buildRowSet()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getBuffer( cColumn )

   if empty( ::hBuffer )
      RETURN ( nil )
   end if 

   if !hhaskey( ::hBuffer, cColumn )
      RETURN ( nil )
   end if  

RETURN ( hget( ::hBuffer, cColumn ) )

//----------------------------------------------------------------------------//

METHOD setBuffer( cColumn, uValue )

   if empty( ::hBuffer )
      RETURN ( nil )
   end if 

   if !hhaskey( ::hBuffer, cColumn )
      RETURN ( nil )
   end if  

RETURN ( hset( ::hBuffer, cColumn, uValue ) )

//----------------------------------------------------------------------------//

METHOD setBufferPadr( cColumn, uValue )

   local nLen

   if empty( ::hBuffer )
      RETURN ( nil )
   end if 

   if !hhaskey( ::hBuffer, cColumn )
      RETURN ( nil )
   end if  

   nLen           := ::getLenFromColumn( cColumn )
   if empty( nLen )
      RETURN ( hset( ::hBuffer, cColumn, uValue ) )
   end if 

   uValue         := padr( uValue, nLen )

RETURN ( hset( ::hBuffer, cColumn, uValue ) )

//----------------------------------------------------------------------------//

METHOD getEmpresaColumns()

   hset( ::hColumns, "id",          {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                       "text"      => "Identificador"                           ,;
                                       "header"    => "Id"                                      ,;
                                       "visible"   => .t.                                       ,;
                                       "type"      => "N"                                       ,;
                                       "width"     => 40 }                                      )   

   hset( ::hColumns, "uuid",        {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                       "text"      => "Uuid"                                    ,;
                                       "header"    => "Uuid"                                    ,;
                                       "visible"   => .t.                                       ,;
                                       "hide"      => .t.                                       ,;
                                       "type"      => "C"                                       ,;
                                       "width"     => 240                                       ,;
                                       "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "empresa",     {  "create"    => "CHAR ( 4 ) NOT NULL"                     ,;
                                       "text"      => "Empresa"                                 ,;
                                       "visible"   => .f.                                       ,;
                                       "type"      => "C"                                       ,;
                                       "default"   => {|| cCodEmp() } }                         )

   hset( ::hColumns, "delegacion",  {  "create"    => "VARCHAR(2) NOT NULL"                     ,;
                                       "text"      => "Delegación"                              ,;
                                       "header"    => "Dlg."                                    ,;
                                       "visible"   => .t.                                       ,;
                                       "hide"      => .t.                                       ,;
                                       "width"     => 140                                       ,;
                                       "field"     => "cSufRem"                                 ,;
                                       "type"      => "C"                                       ,;
                                       "len"       => 2                                         ,;
                                       "default"   => {|| retSufEmp() } }                       )

   hset( ::hColumns, "usuario",     {  "create"    => "VARCHAR(3) NOT NULL"                     ,;
                                       "text"      => "Usuario"                                 ,;
                                       "header"    => "Usuario"                                 ,;
                                       "visible"   => .t.                                       ,;
                                       "hide"      => .t.                                       ,;
                                       "width"     => 100                                       ,;
                                       "field"     => "cCodUsr"                                 ,;
                                       "type"      => "C"                                       ,;
                                       "len"       => 3                                         ,;
                                       "default"   => {|| cCurUsr() } }                         )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//