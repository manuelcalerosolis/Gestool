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

   DATA hColumns                                      INIT {=>}

   DATA cColumnOrientation

   DATA cGeneralSelect                                                              

   DATA cGeneralWhere

   DATA cFilterWhere
   
   DATA cColumnOrder                  
   DATA cColumnKey                    
   DATA cColumnCode                                   INIT "codigo"

   DATA hBuffer 

   DATA cFind

   DATA aRecordsToDelete

   METHOD New()
   METHOD End()

   // Facades -----------------------------------------------------------------

   METHOD setDatabase( oDb )                          INLINE ( ::oDatabase := oDb )
   METHOD getDatabase()                               INLINE ( if( empty( ::oDatabase ), getSQLDatabase(), ::oDatabase ) )

   METHOD getTableName()                              INLINE ( ::cTableName )

   // Columns-------------------------------------------------------------------

   METHOD getColumns()                                VIRTUAL
   METHOD getTableColumns() 

   METHOD getEmpresaColumns()
   METHOD getTimeStampColumns()

   METHOD getSerializeColumns()

   METHOD getColumnsForBrowse()
   METHOD getHeadersForBrowse()

   METHOD getValueFromColumn( cColumn, cKey )
   METHOD getHeaderFromColumn( cColumn )              INLINE ( ::getValueFromColumn( cColumn, "header" ) )
   METHOD getHeaderFromColumnOrder()                  INLINE ( ::getValueFromColumn( ::cColumnOrder, "header" ) )
   METHOD getLenFromColumn( cColumn )                 INLINE ( ::getValueFromColumn( cColumn, "len" ) )

   // Sentences----------------------------------------------------------------

   METHOD getCreateTableSentence()
   METHOD getAlterTableSentences()
   
   METHOD getGeneralSelect()
   METHOD getInitialSelect()                          VIRTUAL

   METHOD getIdSelect( id )
   METHOD getSelectSentence()
   
   METHOD getInsertSentence()
   METHOD getUpdateSentence()
   METHOD getdeleteSentence()
   
   METHOD getDropTableSentence()

   METHOD setGeneralSelect( cSelect )                 INLINE ( ::cGeneralSelect  := cSelect )
   METHOD setGeneralWhere( cWhere )                   INLINE ( ::cGeneralWhere   := cWhere )
   METHOD addGeneralWhere( cSQLSelect )
   
   METHOD addEmpresaWhere()                           

   METHOD setFilterWhere( cWhere )                    INLINE ( ::cFilterWhere   := cWhere )
   METHOD addFilterWhere( cSQLSelect )
   METHOD clearFilterWhere()                          INLINE ( ::cFilterWhere   := nil )
   METHOD addFindWhere( cSQLSelect )

   METHOD getWhereOrAnd( cSQLSelect )                 INLINE ( if( hb_at( "WHERE", cSQLSelect ) != 0, " AND ", " WHERE " ) )

   // Where for columns--------------------------------------------------------

   METHOD isEmpresaColumn()                           INLINE ( hb_hhaskey( ::hColumns, "empresa" ) )

   // Get edit value for xbrowse-----------------------------------------------

   METHOD getEditValue()
   METHOD getValueField( cColumn, uValue )

   METHOD getMethod( cMethod )

   METHOD setColumnOrder( cColumnOrder )              INLINE ( ::cColumnOrder := cColumnOrder )
   METHOD getColumnOrder()                            INLINE ( ::cColumnOrder )

   METHOD setColumnOrientation( cColumnOrientation )  INLINE ( ::cColumnOrientation := cColumnOrientation )

   METHOD getDeleteSentenceById( nId )

   METHOD getSelectByOrder()

   // Busquedas----------------------------------------------------------------

   METHOD setFind( cFind )                            INLINE ( ::cFind := cFind )
   METHOD findById( nId )
   
   // Busquedas----------------------------------------------------------------

   METHOD getBuffer( cColumn )                        
   METHOD setBuffer( cColumn, uValue )
   METHOD setBufferPadr( cColumn, uValue )
   
   METHOD insertBuffer( hBuffer )                     
   METHOD updateBuffer( hBuffer )
   METHOD deleteSelection( aRecno )
   METHOD deleteById( nId )

   METHOD loadBlankBuffer()
   METHOD loadDuplicateBuffer() 
   METHOD loadCurrentBuffer()
   METHOD defaultCurrentBuffer()

   // Events-------------------------------------------------------------------

   METHOD setEvent( cEvent, bEvent )                  INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )                         INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )

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
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getTimeStampColumns()

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

METHOD getEmpresaColumns()

   hset( ::hColumns, "id",          {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                       "text"      => "Identificador"                           ,;
                                       "header"    => "Id"                                      ,;
                                       "visible"   => .t.                                       ,;
                                       "type"      => "N"                                       ,;
                                       "width"     => 40                                        ,;
                                       "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",        {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
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

METHOD getGeneralSelect()

   local cSQLSelect        

   ::fireEvent( 'getingInitialSelect' )   

   cSQLSelect              := ::getInitialSelect()

   ::fireEvent( 'gotInitialSelect' )   

   cSQLSelect              := ::addGeneralWhere( cSQLSelect )

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

   local cSQLSelect        

   ::fireEvent( 'gettingSelectSentence')

   cSQLSelect              := ::getGeneralSelect()

   cSQLSelect              := ::addFindWhere( cSQLSelect )

   cSQLSelect              := ::getSelectByOrder( cSQLSelect )

   ::fireEvent( 'gotSelectSentence')

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addGeneralWhere( cSQLSelect )

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

METHOD addFindWhere( cSQLSelect )

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

   msgAlert( cSQLCreateTable, "cSQLCreateTable" )

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

RETURN ( atail( ::getDatabase():selectFetchHash( ::getIdSelect( id ) ) ) )

//---------------------------------------------------------------------------//

METHOD getInsertSentence( hBuffer )

   local cSQLInsert

   DEFAULT hBuffer   := ::hBuffer

   cSQLInsert        := "INSERT INTO " + ::cTableName + " ( "

   hEval( hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += k + ", ", ) } )

   cSQLInsert        := ChgAtEnd( cSQLInsert, ' ) VALUES ( ', 2 )

   hEval( hBuffer, {| k, v | if ( k != ::cColumnKey, cSQLInsert += toSQLString( v ) + ", ", ) } )

   cSQLInsert        := chgAtEnd( cSQLInsert, ' )', 2 )

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

METHOD getDeleteSentence( aUuid )

   local cSQLDelete     := "DELETE FROM " + ::cTableName + " " 

   cSQLDelete           +=    "WHERE uuid IN ( " 

   aeval( aUuid, {| v | cSQLDelete += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )

   cSQLDelete           := chgAtEnd( cSQLDelete, ' )', 2 )

RETURN ( cSQLDelete )

//---------------------------------------------------------------------------//

METHOD getDeleteSentenceById( nId )

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

RETURN ( cColumn ) 

//---------------------------------------------------------------------------//

METHOD getMethod( cMethod )

RETURN ( {|| Self:&( cMethod ) } )

//---------------------------------------------------------------------------//

METHOD loadBlankBuffer()

   ::hBuffer            := {=>}

   ::fireEvent( 'loadingBlankBuffer' )

   ::defaultCurrentBuffer()

   ::fireEvent( 'loadedBlankBuffer' )

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer( id )                

   ::hBuffer            := {=>}

   ::fireEvent( 'loadingcurrentbuffer' )

   ::hBuffer            := ::findById( id )

   ::fireEvent( 'loadedcurrentbuffer' )

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD loadDuplicateBuffer( id )                

   ::hBuffer            := {=>}

   ::fireEvent( 'loadingduplicatebuffer' )

   ::hBuffer            := ::findById( id )

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
         uValue   := hGet( hValue, cKey )
      end if 

   end if 

RETURN ( uValue )

//---------------------------------------------------------------------------//

METHOD insertBuffer( hBuffer )

   local nId

   ::fireEvent( 'insertingBuffer' )

   msgalert( ::getInsertSentence( hBuffer ), "insertBuffer" )

   ::getDatabase():Execs( ::getInsertSentence( hBuffer ) )

   nId         := ::getDatabase():LastInsertId()

   if !empty( ::cColumnKey )
      hset( ::hBuffer, ::cColumnKey, nId )
   end if 

   ::fireEvent( 'insertedBuffer' )

RETURN ( nId )

//---------------------------------------------------------------------------//

METHOD updateBuffer( hBuffer )

   ::fireEvent( 'updatingBuffer' )

   msgalert( ::getUpdateSentence( hBuffer ), "updateBuffer" )

   ::getDatabase():Execs( ::getUpdateSentence( hBuffer ) )

   ::fireEvent( 'updatedBuffer' )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteSelection( aRecno ) 

   ::aRecordsToDelete   := aRecno

   ::fireEvent( 'deletingSelection' )

   msgalert( ::getDeleteSentence( aRecno ), "deletingSelection" )

   ::getDatabase():Query( ::getDeleteSentence( aRecno ) )

   ::fireEvent( 'deletedSelection' )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteById( nId )

   ::fireEvent( 'deletingById' )

   msgAlert( ::getDeleteSentenceById( nId ), "deletedById" )

   ::getDatabase():Execs( ::getDeleteSentenceById( nId ) )

   ::fireEvent( 'deletedById' )
   
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

