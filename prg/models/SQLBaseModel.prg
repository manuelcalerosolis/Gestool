#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseModel
  
   DATA oController

   DATA oEvents

   DATA cTableName

   DATA cAs

   DATA cConstraints

   DATA hColumns                                      INIT {=>}

   DATA cColumnOrientation

   DATA cGeneralSelect                                                                                             

   DATA cGeneralWhere

   DATA cGeneralHaving

   DATA nLimit

   DATA cFilterWhere                                  INIT ""

   DATA cOthersWhere

   DATA cColumnKey                                    INIT "id"
   
   DATA cColumnCode                                   INIT "codigo"

   DATA hBuffer 

   DATA cSQLInsert

   DATA cSQLUpdate

   DATA cGroupBy                                      INIT ""

   DATA cOrderBy                                      INIT ""    

   DATA cOrientation                                  INIT ""

   DATA cFind

   DATA aColumns                                      INIT {}

   DATA lShowDeleted                                  INIT .f.

   DATA aRecordsToDelete

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD setSQLInsert( cSQLInsert )                  INLINE ( ::cSQLInsert := cSQLInsert )
   METHOD getSQLInsert()                              INLINE ( ::cSQLInsert )

   METHOD setSQLUpdate( cSQLUpdate )                  INLINE ( ::cSQLUpdate := cSQLUpdate )
   METHOD getSQLUpdate()                              INLINE ( ::cSQLUpdate )

   METHOD setAttribute( key, value )
   METHOD getAttribute( key, value )

   // Facades -----------------------------------------------------------------

   METHOD getDatabase()                               INLINE ( getSQLDatabase() )

   METHOD getTableName()                              INLINE ( "gestool." + ::cTableName )

   // Columns-------------------------------------------------------------------

   METHOD getColumns()                                INLINE ( ::hColumns )

   METHOD getColumnsSelect()                          VIRTUAL

   METHOD getTableColumns() 

   METHOD getClosedColumns()
   METHOD getDateTimeColumns()
   METHOD getTimeStampColumns()
   METHOD getTimeStampSentColumns()
   METHOD getDeletedStampColumn()

   METHOD getSerializeColumns()
   METHOD getSerializeColumnsSelect()

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
   METHOD getInitialSelect()                          INLINE ( "SELECT * FROM " + ::getTableName() )

   METHOD getField( cField, cBy, cId )
   METHOD getFieldWhere( cField, hWhere )

   METHOD getHashWhere( cBy, cId )

   METHOD getWhereIdSelect( id )
   METHOD getWhereUuidSelect( uuid )
   METHOD getWhereCodigoSelect( codigo )

   METHOD getWhereSelect( cWhere )

   METHOD getSelectSentence()
   
   METHOD setCreatedTimeStamp( hBuffer )
   METHOD setUpdatedTimeStamp( hBuffer )
   Method setDeletedTimeStamp( hBuffer )

   METHOD isBufferSystemRegister( hBuffer )   
   METHOD isNotBufferSystemRegister( hBuffer )        INLINE ( !( ::isBufferSystemRegister( hBuffer ) ) )

   METHOD getInsertSentence()
   METHOD getInsertIgnoreSentence( hBuffer )          INLINE ( ::getInsertSentence( hBuffer, .t. ) )
   METHOD getUpdateSentence()
   METHOD getInsertOnDuplicateSentence( hBuffer )   

   METHOD isDeletedAtColumn()                         INLINE ( hhaskey( ::hColumns, "deleted_at" ) )
   METHOD isDeleted( nId )                            

   METHOD setShowDeleted( lShow )                     /*INLINE ( ::lShowDeleted := lShow )*/
   METHOD isShowDeleted()                             INLINE ( ::lShowDeleted )

   METHOD getDeleteOrUpdateSentenceByUuid( aUuid )
      METHOD SQLUpdateDeletedAtSentenceWhereUuid( uUuid )
      METHOD SQLDeletedSentenceWhereUuid( uUuid )
   METHOD getDeleteOrUpdateSentenceById( aId )
      METHOD SQLUpdateDeletedAtSentenceById( aIds )
      METHOD SQLDeletedSentenceById( aIds )
   METHOD getDeleteOrUpdateSentenceWhereParentUuid( uUuid )
      METHOD SQLUpdateDeletedAtSentenceWhereParentUuid( uUuid )
      METHOD SQLDeletedSentenceWhereParentUuid( uUuid )

   METHOD SQLDeletedSentenceById( aIds )

   METHOD aUuidToDelete()
   
   METHOD getDropTableSentence()

   METHOD setGeneralSelect( cSelect )                 INLINE ( ::cGeneralSelect  := cSelect )

   METHOD setLimit( nLimit )                          INLINE ( ::nLimit := nLimit )
   METHOD addLimit( cSQLSelect )

   METHOD getWhereOrAnd( cSQLSelect )                 INLINE ( if( hb_at( "WHERE", cSQLSelect ) != 0, " AND ", " WHERE " ) )
   METHOD setGeneralWhere( cWhere )                   INLINE ( ::cGeneralWhere   := cWhere )
   METHOD addGeneralWhere( cSQLSelect )
   METHOD addDeletedAtWhere( cSQLSelect )
   
   METHOD getHavingOrAnd( cSQLSelect )                INLINE ( if( hb_at( "HAVING", cSQLSelect ) != 0, " AND ", " HAVING " ) )
   METHOD setGeneralHaving( cHaving )                 INLINE ( ::cGeneralHaving := cHaving )
   METHOD addGeneralHaving( cSQLSelect )
   
   METHOD addParentUuidWhere()                           

   METHOD setOthersWhere( cWhere )                    INLINE ( ::cOthersWhere   := cWhere )
   METHOD addOthersWhere( cSQLSelect )

   METHOD setFilterWhere( cWhere )                    INLINE ( ::cFilterWhere    := cWhere )
   METHOD clearFilterWhere()                          INLINE ( ::cFilterWhere    := "" )
   METHOD getFilterWhere( cWhere )                    INLINE ( ::cFilterWhere )
   METHOD insertFilterWhere( cWhere )                  
   METHOD addFilterWhere( cSQLSelect )

   METHOD addFindWhere( cSQLSelect )
   METHOD getExpresionToFind()

   METHOD setOrderBy( cOrderBy )                      INLINE ( ::cOrderBy        := cOrderBy )
   METHOD getOrderBy()                                INLINE ( if( !empty( ::cAs ) .and. !empty( ::cOrderBy ), ::cAs + "." + ::cOrderBy, ::cOrderBy ) )

   METHOD setOrientation( cOrientation )              INLINE ( ::cOrientation    := cOrientation )
   METHOD getOrientation()                            INLINE ( ::cOrientation )

   METHOD setGroupBy( cGroupBy )                      INLINE ( ::cGroupBy        := cGroupBy )
   METHOD getGroupBy()                                INLINE ( ::cGroupBy )
   METHOD addGroupBy( cSQLSelect )

   METHOD findAll( nOffset, nLimit )
   METHOD getByUuid( uuid )

   // Where for columns--------------------------------------------------------

   METHOD isEmpresaColumn()                           INLINE ( hb_hhaskey( ::hColumns, "empresa_codigo" ) )
   METHOD isParentUuidColumn()                        INLINE ( hb_hhaskey( ::hColumns, "parent_uuid" ) )

   // Get edit value for xbrowse-----------------------------------------------

   METHOD getEditValue()
   METHOD getValueField( cColumn, uValue )

   METHOD getMethod( cMethod )

   METHOD getSelectByOrder()

   METHOD getWhere( cField, cOperator, uValue )       INLINE ( atail( ::getDatabase():selectFetchHash( ::getWhereSelect( cField, cOperator, uValue ) ) ) )

   // Busquedas----------------------------------------------------------------

   METHOD setFind( cFind, aColumns )                  INLINE ( ::cFind := cFind, ::aColumns := aColumns )

   METHOD getBufferById( nId )
   METHOD getBufferByUuid( uuid )
   METHOD getBufferByCodigo( cCodigo )
   
   // Buffer-------------------------------------------------------------------

   METHOD getBuffer( cColumn )    
   METHOD getBufferColumnKey()                        INLINE ( ::getBuffer( ::cColumnKey ) )
                    
   METHOD setBuffer( cColumn, uValue )
   METHOD setBufferPadr( cColumn, uValue )
   
   METHOD insertBuffer( hBuffer ) 
   METHOD insertIgnoreBuffer( hBuffer )                    
   METHOD updateBuffer( hBuffer )
   METHOD insertOnDuplicate( hBuffer )
   METHOD insertOnDuplicateTransactional( hBuffer )   INLINE ( ::insertOnDuplicate( hBuffer, .t. ) )
   METHOD deleteSelection( aIds )
   METHOD deleteById( uId )
   METHOD deleteByUuid( uUuid )
   METHOD deleteWhereParentUuid( uUuid )

   METHOD loadBlankBuffer()
   METHOD loadDuplicateBuffer() 
   METHOD loadCurrentBuffer()
   METHOD defaultCurrentBuffer()

   METHOD insertBlankBuffer()                         INLINE ( ::loadBlankBuffer(), ::insertBuffer( ::hBuffer ) ) 

   // Events-------------------------------------------------------------------

   METHOD setEvents( aEvents, bEvent )
   METHOD setEvent( cEvent, bEvent )                  INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )                         INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )

   METHOD updateFieldWhereId( id, cField, uValue )
   METHOD updateBufferWhereId( id, hBuffer )

   METHOD updateFieldWhereUuid( uuid, cField, uValue )
   METHOD updateBufferWhereUuid( uuid, hBuffer )

   // Metodos de consulta------------------------------------------------------

   METHOD getUuidWhereColumn( uValue, cColumn, uDefault ) 
   METHOD getUuidWhereNombre( uValue )                INLINE ( ::getUuidWhereColumn( uValue, 'nombre', '' ) )
   METHOD getUuidWhereCodigo( uValue )                INLINE ( ::getUuidWhereColumn( uValue, 'codigo', '' ) )

   METHOD getIdWhereColumn( uValue, cColumn, uDefault ) 
   METHOD getIdWhereNombre( uValue )                  INLINE ( ::getIdWhereColumn( uValue, 'nombre', '' ) )
   METHOD getIdWhereCodigo( uValue )                  INLINE ( ::getIdWhereColumn( uValue, 'codigo', '' ) )

   METHOD getWhereUuid( Uuid )
   METHOD getWhereCodigo( cCodigo )

   METHOD isWhereCodigo( cCodigo )

   METHOD getWhereNombre( uValue )               
   METHOD getColumnWhereNombre( uValue, cColumn, uDefault ) 
   METHOD getCodigoWhereNombre( uValue )              INLINE ( ::getColumnWhereNombre( uValue, 'codigo', '' ) )

   METHOD getColumnWhereId( id, cColumn )
   METHOD getNombreWhereId( id )                      INLINE ( ::getColumnWhereId( id, 'nombre' ) )

   METHOD getColumnWhereUuid( uuid, cColumn ) 
   METHOD getNombreWhereUuid( uuid )                  INLINE ( ::getColumnWhereUuid( uuid, 'nombre' ) )
   METHOD getCodigoWhereUuid( uuid )                  INLINE ( ::getColumnWhereUuid( uuid, 'codigo' ) )

   METHOD getColumnWhereId( id, cColumn ) 

   METHOD getColumnWhereCodigo( codigo, cColumn ) 
   METHOD getNombreWhereCodigo( codigo )              INLINE ( ::getColumnWhereCodigo( codigo, 'nombre' ) )
   METHOD getCodigoWhereCodigo( codigo )              INLINE ( ::getColumnWhereCodigo( codigo, 'codigo' ) )

   METHOD getColumn( cColumn ) 
   METHOD getColumnWhere( cColumn, cField, cCondition, cValue )
   METHOD getColumnsWithBlank( cColumn ) 

   METHOD getNombres()                                INLINE ( ::getColumn( 'nombre' ) )
   METHOD getNombresWithBlank()                       INLINE ( ::getColumnsWithBlank( 'nombre' ) )

   METHOD getControllerParentUuid()

   METHOD Count( oController )

   //duplicate-----------------------------------------------------------------

   METHOD getSentenceOthersWhereParentUuid( uuidParent ) VIRTUAL

   METHOD getHashOthersWhereParentUuid( uuidParent ) ;
                                             INLINE ( ::getDatabase():selectFetchHash( ::getSentenceOthersWhereParentUuid( uuidParent ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   if empty( ::hColumns ) .and. empty( ::getColumns() )
      msgstop( "La definición de columnas no puede estar vacia" )
      RETURN ( self )
   end if 

   ::oController                 := oController

   ::oEvents                     := Events():New()

   if empty( ::cColumnKey )
      ::cColumnKey               := hGetKeyAt( ::hColumns, 1 )
   end if 

   ::cGeneralSelect              := "SELECT * FROM " + ::getTableName()    

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

   ::oEvents                     := nil

   ::oController                 := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getDateTimeColumns()

   hset( ::hColumns, "creado",      {  "create"    => "DATETIME DEFAULT NULL"       ,;
                                       "default"   => {|| hb_datetime() } }         )

   hset( ::hColumns, "modificado",  {  "create"    => "DATETIME DEFAULT NULL"       ,;
                                       "default"   => {|| hb_datetime() } }         )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getTimeStampSentColumns()

   hset( ::hColumns, "send_at",     {  "create"    => "DATETIME DEFAULT NULL"       ,;
                                       "text"      => "Enviado fecha y hora" }      )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getTimeStampColumns()

   hset( ::hColumns, "created_at",  {  "create"    => "TIMESTAMP NULL DEFAULT NULL" ,;
                                       "default"   => {|| hb_datetime() } }         )

   hset( ::hColumns, "updated_at",  {  "create"    => "TIMESTAMP NULL DEFAULT NULL" ,;
                                       "default"   => {|| hb_datetime() } }         )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getDeletedStampColumn()

   hset( ::hColumns, "deleted_at",  {  "create"    => "TIMESTAMP NULL DEFAULT NULL" ,;
                                       "default"   => {|| hb_datetime( nil, nil, nil, nil, nil, nil, nil ) } } )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getClosedColumns()
   
   hset( ::hColumns, "closed_at",   {  "create"    => "TIMESTAMP NULL DEFAULT NULL" ,;
                                       "default"   => {|| nil } }         )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getGeneralSelect()

   local cSQLSelect        

   ::fireEvent( 'getingInitialSelect' )   

   cSQLSelect              := ::getInitialSelect()

   ::fireEvent( 'gotInitialSelect' )   

   cSQLSelect              := ::addGeneralWhere( cSQLSelect )

   cSQLSelect              := ::addDeletedAtWhere( cSQLSelect )

   cSQLSelect              := ::addOthersWhere( cSQLSelect )

   cSQLSelect              := ::addParentUuidWhere( cSQLSelect )

   cSQLSelect              := ::addFilterWhere( cSQLSelect )

   cSQLSelect              := ::addGroupBy( cSQLSelect )

   cSQLSelect              := ::addGeneralHaving( cSQLSelect )

   cSQLSelect              := ::addLimit( cSQLSelect )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getWhereIdSelect( id )

RETURN ( ::getWhereSelect( "id", "=", id ) )

//---------------------------------------------------------------------------//

METHOD getWhereUuidSelect( uuid )

RETURN ( ::getWhereSelect( "uuid", "=", uuid ) )

//---------------------------------------------------------------------------//

METHOD getWhereCodigoSelect( codigo )

RETURN ( ::getWhereSelect( "codigo", "=", codigo ) )

//---------------------------------------------------------------------------//

METHOD getWhereSelect( cField, cOperator, uValue )

   local cSQLSelect        := ::cGeneralSelect + " "

   cSQLSelect              += "WHERE "
   
   if !empty( ::cAs )
      cSQLSelect           += ::cAs + "."
   end if 

   cSQLSelect              += cField + " " + cOperator + " " + toSQLString( uValue ) 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectSentence( cOrderBy, cOrientation ) 

   local cSQL        

   if !empty( cOrderBy )
      ::setOrderBy( cOrderBy )
   end if 

   if !empty( cOrientation )
      ::setOrientation( cOrientation )
   end if 

   ::fireEvent( 'gettingSelectSentence' )

   cSQL              := ::getGeneralSelect()

   cSQL              := ::addFindWhere( cSQL )

   cSQL              := ::getSelectByOrder( cSQL )

   ::fireEvent( 'gotSelectSentence')

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD addGeneralWhere( cSQLSelect, cGeneralWhere )

   DEFAULT cGeneralWhere   := ::cGeneralWhere

   if empty( cGeneralWhere )
      RETURN ( cSQLSelect )
   end if 
   
   cSQLSelect              += ::getWhereOrAnd( cSQLSelect ) + cGeneralWhere 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addDeletedAtWhere( cSQLSelect )

   if ::isShowDeleted()
      RETURN ( cSQLSelect )
   end if

   if ::isDeletedAtColumn()
      cSQLSelect           += ::getWhereOrAnd( cSQLSelect ) + ::getTableName() + ".deleted_at = 0" 
   end if 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addLimit( cSQLSelect, nLimit )

   DEFAULT nLimit   := ::nLimit

   if empty( nLimit )
      RETURN ( cSQLSelect )
   end if 
   
   cSQLSelect              += " LIMIT " + hb_ntos( nLimit )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addGeneralHaving( cSQLSelect )

   if empty( ::cGeneralHaving )
      RETURN ( cSQLSelect )
   end if 
   
   cSQLSelect     += ::getHavingOrAnd( cSQLSelect ) + ::cGeneralHaving 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addOthersWhere( cSQLSelect )

   if empty( ::cOthersWhere )
      RETURN ( cSQLSelect )
   end if 
   
   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) + ::cOthersWhere 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addParentUuidWhere( cSQLSelect ) 

   local uuid        

   if !::isParentUuidColumn()
      RETURN ( cSQLSelect )
   end if 

   if empty( ::oController )
      RETURN ( cSQLSelect )
   end if

   if empty( ::oController:getController() )
      RETURN ( cSQLSelect )
   end if

   uuid           := ::oController:getController():getUuid()

   if !empty( uuid )
      cSQLSelect  += ::getWhereOrAnd( cSQLSelect ) + ::getTableName() + ".parent_uuid = " + quoted( uuid )
   end if 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD insertFilterWhere( cWhere )

   if empty( ::cFilterWhere )
      ::cFilterWhere    := cWhere
   else 
      ::cFilterWhere    += " AND " + cWhere
   end if 

RETURN ( ::cFilterWhere )

//---------------------------------------------------------------------------//

METHOD addFilterWhere( cSQLSelect )

   if empty( ::cFilterWhere )
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect           += ::getWhereOrAnd( cSQLSelect )

   if !empty( ::cAs )
      cSQLSelect        += ::cAs + "."
   end if 

   cSQLSelect           += ::cFilterWhere

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addGroupBy( cSQLSelect )

   if empty( ::getGroupBy() )
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect     += " GROUP BY " + ::getGroupBy()

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addFindWhere( cSQLSelect )

   if empty( ::cFind )
      RETURN ( cSQLSelect )
   end if 

   if empty( ::cOrderBy ) .and. empty( ::aColumns )
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect     += space( 1 )
   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) 
   cSQLSelect     += ::getExpresionToFind()

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getExpresionToFind()

   local cExpresionToFind  := ""

   if !empty( ::aColumns )
      aeval( ::aColumns, {|cColumn| cExpresionToFind += "UPPER(" + cColumn + ") LIKE '%" + upper( ::cFind ) + "%' OR " } )
      cExpresionToFind     := chgAtEnd( cExpresionToFind, '', 4 )
      RETURN ( cExpresionToFind )
   end if 

   cExpresionToFind        += "UPPER(" + ::cOrderBy + ") LIKE '%" + upper( ::cFind ) + "%'" 

RETURN ( cExpresionToFind )

//---------------------------------------------------------------------------//

METHOD getSelectByOrder( cSQLSelect )

   if empty( ::getOrderBy() )
      RETURN ( cSQLSelect )
   end if 
   
   cSQLSelect     += " ORDER BY " + ::getOrderBy() 

   if !empty( ::getOrientation() ) .and. ::getOrientation() == "A"
      cSQLSelect  += " DESC"
   else
      cSQLSelect  += " ASC"
   end if

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getCreateTableSentence( cDatabaseMySQL )
   
   local cSQLCreateTable 

   if empty( cDatabaseMySQL )
      msgstop( "Error al crear la tabla " + ::getTableName() + " no se proporciono el nombre de la base de datos" )
      RETURN ( "" )
   end if 

   cSQLCreateTable         := "CREATE TABLE " + ::getTableName() + " ( "

   hEval( ::getColumns(),;
      {| k, hash | if( hhaskey( hash, "create" ), cSQLCreateTable += k + " " + hget( hash, "create" ) + ", ", ) } )
   
   if !empty( ::cConstraints )
      cSQLCreateTable      += ::cConstraints + " )"
   else
      cSQLCreateTable      := chgAtEnd( cSQLCreateTable, ' )', 2 )
   end if

RETURN ( cSQLCreateTable )

//---------------------------------------------------------------------------//

METHOD getAlterTableSentences( cDatabaseMySQL, aSchemaColumns ) 

   local aAlter
   local hColumn
   local hColumns
   local nPosition

   if empty( aSchemaColumns )
      RETURN ( self )
   end if 

   DEFAULT cDatabaseMySQL  := getSQLDatabase():cDatabaseMySQL

   aAlter                  := {}
   hColumns                := ::getTableColumns()

   for each hColumn in aSchemaColumns

      nPosition            := ascan( hb_hkeys( hColumns ), hget( hColumn, "COLUMN_NAME" ) )
      
      if nPosition != 0
         hb_hdelat( hColumns, nPosition )
      else 
         aadd( aAlter, "ALTER TABLE " + ::getTableName() + " DROP COLUMN " + hget( hColumn, "COLUMN_NAME" ) )
      end if

   next

   if !empty( hColumns )
      heval( hColumns, {| k, hash | aadd( aAlter, "ALTER TABLE " + ::getTableName() + " ADD COLUMN " + k + " " + hget( hash, "create" ) ) } )
   end if 

   if !empty( hColumns )
      msgInfo( hb_valtoexp( hColumns ), "getAlterTableSentences " + ::getTableName(), "Alter table" )
   end if 

RETURN ( aAlter )

//---------------------------------------------------------------------------//

METHOD getDropTableSentence()
   
RETURN ( "DROP TABLE " + ::getTableName() )

//---------------------------------------------------------------------------//

METHOD getBufferById( id )

   local hBuffer  

   if !hb_isnumeric( id )
      RETURN ( nil )
   end if 

   hBuffer        := atail( ::getDatabase():selectPadedFetchHash( ::getWhereIdSelect( id ) ) )

   if hb_ishash( hBuffer )
      heval( hBuffer, {|k,v| hset( hBuffer, k, ::getAttribute( k, v ) ) } )
   end if 

RETURN ( hBuffer )

//---------------------------------------------------------------------------//

METHOD getBufferByUuid( uuid )

   local hBuffer  

   if !hb_ischar( uuid )
      RETURN ( nil )
   end if 

   hBuffer        := atail( ::getDatabase():selectPadedFetchHash( ::getWhereUuidSelect( uuid ) ) )

   if hb_ishash( hBuffer )
      heval( hBuffer, {|k,v| hset( hBuffer, k, ::getAttribute( k, v ) ) } )
   end if 

RETURN ( hBuffer )

//---------------------------------------------------------------------------//

METHOD getBufferByCodigo( cCodigo )

   local hBuffer  

   if !hb_ischar( cCodigo )
      RETURN ( nil )
   end if 

   hBuffer        := atail( ::getDatabase():selectPadedFetchHash( ::getWhereCodigoSelect( cCodigo ) ) )

   if hb_ishash( hBuffer )
      heval( hBuffer, {|k,v| hset( hBuffer, k, ::getAttribute( k, v ) ) } )
   end if 

RETURN ( hBuffer )

//---------------------------------------------------------------------------//

METHOD setCreatedTimeStamp( hBuffer )

   if ( hhaskey( hBuffer, "creado" ) )
      hset( hBuffer, "creado", hb_datetime() )
   end if 

   if ( hhaskey( hBuffer, "created_at" ) )
      hset( hBuffer, "created_at", hb_datetime() )
   end if 

RETURN ( hBuffer )

//---------------------------------------------------------------------------//

METHOD setDeletedTimeStamp( hBuffer )

   if ( hhaskey( hBuffer, "deleted_at" ) )
      hset( hBuffer, "deleted_at", hb_datetime() )
   end if 

RETURN ( hBuffer )

//---------------------------------------------------------------------------//

METHOD setUpdatedTimeStamp( hBuffer )
   
   if ( hhaskey( hBuffer, "modificado" ) )
      hset( hBuffer, "modificado", hb_datetime() )
   end if 

   if ( hhaskey( hBuffer, "updated_at" ) )
      hset( hBuffer, "updated_at", hb_datetime() )
   end if 

RETURN ( hBuffer )

//---------------------------------------------------------------------------//

METHOD isBufferSystemRegister( hBuffer )

   DEFAULT hBuffer   := ::hBuffer

   if !hb_ishash( hBuffer )
      RETURN ( nil )
   end if 

   if !( hhaskey( hBuffer, "sistema" ) )
      RETURN ( .f. )
   end if 

   if hb_isnumeric( hget( hBuffer, "sistema" ) ) 
      RETURN ( hget( hBuffer, "sistema" ) == 1 ) 
   end if 

RETURN ( hget( hBuffer, "sistema" ) )

//----------------------------------------------------------------------------//

METHOD getInsertSentence( hBuffer, lIgnore )

   DEFAULT hBuffer   := ::hBuffer
   DEFAULT lIgnore   := .f.
   
   if !hb_ishash( hBuffer )
      RETURN ( nil )
   end if 

   ::fireEvent( 'getingInsertSentence' )   

   hBuffer           := ::setCreatedTimeStamp( hBuffer )

   ::cSQLInsert      := "INSERT " 

   if lIgnore
      ::cSQLInsert   += "IGNORE "
   end if 

   ::cSQLInsert      += "INTO " + ::getTableName() + " ( "

   hEval( hBuffer, {| k, v | if( k != ::cColumnKey, ::cSQLInsert += k + ", ", ) } )

   ::cSQLInsert      := chgAtEnd( ::cSQLInsert, ' ) VALUES ( ', 2 )

   hEval( hBuffer, {| k, v | if( k != ::cColumnKey, ::cSQLInsert += toSQLString( ::setAttribute( k, v ) ) + ", ", ) } )

   ::cSQLInsert      := chgAtEnd( ::cSQLInsert, ' )', 2 )

   ::fireEvent( 'gotInsertSentence' ) 
   logwrite( ::cSQLInsert )

RETURN ( ::cSQLInsert )

//---------------------------------------------------------------------------//

METHOD getUpdateSentence( hBuffer )

   local uValue

   DEFAULT hBuffer      := ::hBuffer

   if !hb_ishash( hBuffer )
      RETURN ( nil )
   end if 

   ::fireEvent( 'getingUpdateSentence' )   

   hBuffer              := ::setUpdatedTimeStamp( hBuffer )

   ::cSQLUpdate         := "UPDATE " + ::getTableName() + " SET "

   for each uValue in hBuffer
      if ( uValue:__enumkey() != ::cColumnKey )
         ::cSQLUpdate  += uValue:__enumKey() + " = " + toSQLString( ::setAttribute( uValue:__enumKey(), uValue ) ) + ", "
      end if 
   next

   ::cSQLUpdate         := chgAtEnd( ::cSQLUpdate, '', 2 ) + " "

   ::cSQLUpdate         += "WHERE " + ::cColumnKey + " = " + toSQLString( hget( hBuffer, ::cColumnKey ) )

   ::fireEvent( 'gotUpdateSentence' )   

RETURN ( ::cSQLUpdate )

//---------------------------------------------------------------------------//

METHOD getInsertOnDuplicateSentence( hBuffer ) 

   local uValue
   local cSQLUpdate  

   DEFAULT hBuffer   := ::hBuffer

   if !hb_ishash( hBuffer )
      RETURN ( nil )
   end if 

   hBuffer           := ::setUpdatedTimeStamp( hBuffer )
   
   cSQLUpdate        := ::getInsertSentence( hBuffer ) + " "

   cSQLUpdate        += "ON DUPLICATE KEY UPDATE "

   hBuffer           := ::setUpdatedTimeStamp( hBuffer )

   for each uValue in hBuffer
      if ( uValue:__enumkey() != ::cColumnKey )
         cSQLUpdate  += uValue:__enumKey() + " = " + toSQLString( ::setAttribute( uValue:__enumKey(), uValue ) ) + ", "
      end if 
   next

   cSQLUpdate        := chgAtEnd( cSQLUpdate, '', 2 )

RETURN ( cSQLUpdate )

//---------------------------------------------------------------------------//
METHOD setShowDeleted( lShow )

   if !::isShowDeleted
   ::lShowDeleted := .t.
   RETURN ( nil )
   end if
   
   ::lShowDeleted := .f.

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getDeleteOrUpdateSentenceByUuid( uUuid )

   if hb_ischar( uUuid )
      uUuid          := { uUuid }
   end if 

   if ::isDeletedAtColumn()
      RETURN( ::SQLUpdateDeletedAtSentenceWhereUuid( uUuid ) )
   end if

RETURN ( ::SQLDeletedSentenceWhereUuid( uUuid ) )

//---------------------------------------------------------------------------//

METHOD SQLUpdateDeletedAtSentenceWhereUuid( uUuid )

   local cSentence

   cSentence   := "UPDATE " + ::getTableName() + " " + ;
                     "SET deleted_at = NOW() " + ; 
                     "WHERE uuid IN ( "
   
      aeval( uUuid, {| v | cSentence += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )

      cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD SQLDeletedSentenceWhereUuid( uUuid )
   
   local cSentence

   cSentence         := "DELETE FROM " + ::getTableName() + " " + ;
                           "WHERE uuid IN ( " 

   aeval( uUuid, {| v | cSentence += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )

   cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getDeleteOrUpdateSentenceWhereParentUuid( uUuid )   

   if hb_ischar( uUuid )
      uUuid          := { uUuid }
   end if 

   if ::isDeletedAtColumn()
      RETURN( ::SQLUpdateDeletedAtSentenceWhereParentUuid( uUuid ) )
   end if

RETURN ( ::SQLDeletedSentenceWhereParentUuid( uUuid ) )

//---------------------------------------------------------------------------//

METHOD SQLDeletedSentenceWhereParentUuid( uUuid)

   local cSentence

   cSentence         := "DELETE FROM " + ::getTableName() + " " + ;
                           "WHERE parent_uuid IN ( " 

   aeval( uUuid, {| v | cSentence += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )

   cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN( cSentence )
//---------------------------------------------------------------------------//

METHOD SQLUpdateDeletedAtSentenceWhereParentUuid( uUuid )

   local cSentence

      cSentence   := "UPDATE " + ::getTableName() + " " + ;
                        "SET deleted_at = NOW() " + ; 
                        "WHERE parent_uuid IN ( "
   
      aeval( uUuid, {| v | cSentence += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )

      cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getDeleteOrUpdateSentenceById( aIds )

   if hb_isnumeric( aIds )
      aIds     := { aIds }
   end if 

   if ::isDeletedAtColumn() 
      RETURN ( ::SQLUpdateDeletedAtSentenceById( aIds ) )
   end if 

RETURN ( ::SQLDeletedSentenceById( aIds ) )

//---------------------------------------------------------------------------//

METHOD SQLUpdateDeletedAtSentenceById( aIds )

   local cSentence

   cSentence   := "UPDATE " + ::getTableName() + " " + ;
                     "SET deleted_at = NOW() "  + ;
                     "WHERE " + ::cColumnKey + " IN ( "

   aeval( aIds, {| v | cSentence += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )

   cSentence   := chgAtEnd( cSentence, ' )', 2 ) + " "

   cSentence   +=    "AND deleted_at = 0" 

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD SQLDeletedSentenceById( aIds ) 

   local cSentence

   cSentence      := "DELETE FROM " + ::getTableName() + " " + ;
                        "WHERE " + ::cColumnKey + " IN ( "
   
   aeval( aIds, {| v | cSentence += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )

   cSentence      := chgAtEnd( cSentence, ' )', 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------// 

METHOD aUuidToDelete( aParentsUuid )

   local cSentence   := "SELECT uuid FROM " + ::getTableName() + " " + ;
                           "WHERE parent_uuid IN ( " 

   aeval( aParentsUuid, {| v | cSentence += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )

   cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN ( ::getDatabase():selectFetchArray( cSentence ) )

//---------------------------------------------------------------------------//

METHOD isDeleted( nId ) 

   local cSentence

   cSentence      := "SELECT " + ::cColumnKey                              + " " + ; 
                        "FROM " + ::getTableName()                         + " " + ;
                        "WHERE " + ::cColumnKey + " = " + hb_ntos( nId )   + " " + ;
                           "AND deleted_at > 0" 

RETURN ( ::getDatabase():getValue( cSentence ) != nil )

//---------------------------------------------------------------------------// 

METHOD getValueField( cColumn, uValue )

   local bValue
   local hColumn

   if !hhaskey( ::hColumns, cColumn )
      RETURN ( uValue )
   end if 

   hColumn        := hGet( ::hColumns, cColumn )

   if hhaskey( hColumn, "default" )
      RETURN ( uValue )
   end if 

   bValue         := hGet( hColumn, "default" )
   
   if !empty( bValue ) .and. hb_isblock( bValue )
      uValue      := eval( bValue )
   end if

RETURN ( uValue )

//---------------------------------------------------------------------------//

METHOD findAll( nOffset, nLimit )

RETURN ( ::getDatabase():selectTrimedFetchHash( ::getGeneralSelect() ) )

//---------------------------------------------------------------------------//

METHOD getByUuid( uuid )

   local cGeneralSelect    := ::cGeneralSelect + " WHERE uuid = " + quoted( uuid )

RETURN ( ::getDatabase():selectTrimedFetchHash( cGeneralSelect ) )

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

METHOD setAttribute( key, value )

   local cMethod  := "set" + strtran( key, "_", "" ) + "attribute"

   if __ObjHasMethod( Self, cMethod )
      RETURN ( Self:&( cMethod )( value ) )
   end if 

RETURN ( value )

//---------------------------------------------------------------------------//

METHOD getAttribute( key, value )

   local cMethod  := "get" + strtran( key, "_", "" ) + "attribute"

   if __ObjHasMethod( Self, cMethod )
      RETURN ( Self:&( cMethod )( value ) )
   end if 

RETURN ( value )

//---------------------------------------------------------------------------//

METHOD getMethod( cMethod )

RETURN ( {|| Self:&( cMethod ) } )

//---------------------------------------------------------------------------//

METHOD loadBlankBuffer()

   ::hBuffer            := {=>}

   ::fireEvent( 'loadingBuffer' )

   ::fireEvent( 'loadingBlankBuffer' )

   ::defaultCurrentBuffer()

   ::fireEvent( 'loadedBlankBuffer' )

   ::fireEvent( 'loadedBuffer' )

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer( id )                

   ::hBuffer            := {=>}

   ::fireEvent( 'loadingBuffer' )

   ::fireEvent( 'loadingCurrentBuffer' )

   ::hBuffer            := ::getBufferById( id )

   ::fireEvent( 'loadedCurrentBuffer' )
   
   ::fireEvent( 'loadedBuffer' )
   
RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD loadDuplicateBuffer( id, hFields ) 

   ::hBuffer            := {=>}

   ::fireEvent( 'loadingBuffer' )

   ::fireEvent( 'loadingDuplicateBuffer' )

   ::hBuffer            := ::getBufferById( id )

   if !( hb_ishash( ::hBuffer ) )
      RETURN ( nil )
   end if

   ::fireEvent( 'loadedDuplicateCurrentBuffer' )

   if hhaskey( ::hBuffer, "id" )
      hset( ::hBuffer, "id", 0 )
   end if 
   
   if hhaskey( ::hBuffer, "uuid" )   
      hset( ::hBuffer, "uuid", win_uuidcreatestring() )
   end if 

   if hhaskey( ::hBuffer, "deleted_at" )   
      hset( ::hBuffer, "deleted_at", hb_datetime( nil, nil, nil, nil, nil, nil, nil ) )
   end if 

   if !empty( hFields )
      heval( hFields, {|k,v| if( hhaskey( ::hBuffer, k ), hset( ::hBuffer, k, v ), ) } )
   end if 

   ::fireEvent( 'loadedDuplicateBuffer' )

   ::fireEvent( 'loadedBuffer' )
   
RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD defaultCurrentBuffer()                

   local h

   for each h in ::getTableColumns()

      if hhaskey( h, "default" ) .and. hb_isblock( hget( h, "default" ) )

         hset( ::hBuffer, h:__enumkey(), ::getAttribute( h:__enumkey(), eval( hget( h, "default" ) ) ) )
         
      end if

   next

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD getSerializeColumns()

   local cColumns       := ""

   heval( ::getTableColumns(), {|cColumn| cColumns += alltrim( cColumn ) + ";" } )

RETURN ( cColumns )

//---------------------------------------------------------------------------//

METHOD getSerializeColumnsSelect()

   local nPos
   local cColumn        
   local cColumns       := ""
   local aColumns       := hb_atokens( ::getColumnsSelect(), chr( 10 ) )

   if !hb_isarray( aColumns )
      RETURN ( cColumns )
   end if 

   for each cColumn in aColumns

      nPos              := rat( "AS ", cColumn )

      if nPos != 0
         cColumns       += substr( cColumn, nPos + 3 )
      end if 

   next 

   cColumns             := strtran( cColumns, ",", ";" )
   
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
   local cSQLInsert


   DEFAULT hBuffer   := ::hBuffer

   cSQLInsert        := ::getInsertSentence( hBuffer )

   if empty( cSQLInsert )
      RETURN ( nil )
   end if 

   ::fireEvent( 'insertingBuffer' )

   ::getDatabase():Execs( cSQLInsert )

   nId               := ::getDatabase():LastInsertId()

   hset( hBuffer, ::cColumnKey, nId )

   ::fireEvent( 'insertedBuffer' )

RETURN ( nId )

//---------------------------------------------------------------------------//

METHOD insertIgnoreBuffer( hBuffer )

   local nId

   ::getInsertIgnoreSentence( hBuffer )

   ::fireEvent( 'insertingBuffer' )

   if !empty( ::cSQLInsert )
      ::getDatabase():Execs( ::cSQLInsert )
   end if 

   nId         := ::getDatabase():LastInsertId()

   ::fireEvent( 'insertedBuffer' )

RETURN ( nId )

//---------------------------------------------------------------------------//

METHOD updateBuffer( hBuffer )

   ::getUpdateSentence( hBuffer )

   ::fireEvent( 'updatingBuffer' )

   if !empty( ::cSQLUpdate )

      ::getDatabase():Execs( ::cSQLUpdate )

   end if

   ::fireEvent( 'updatedBuffer' )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertOnDuplicate( hBuffer, lTransactional )

   local cSentence 

   DEFAULT lTransactional  := .f.

   ::fireEvent( 'insertingOnDuplicatingBuffer' )

   cSentence               := ::getInsertOnDuplicateSentence( hBuffer )

   if lTransactional 
      ::getDatabase():TransactionalExec( cSentence )
   else
      ::getDatabase():Execs( cSentence )
   end  if 

   ::fireEvent( 'insertedOnDuplicatedBuffer' )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteSelection( aIds, aUuids ) 

   ::aRecordsToDelete   := aIds

   ::fireEvent( 'deletingSelection' )

   ::getDatabase():Execs( ::getDeleteOrUpdateSentenceById( aIds, aUuids ) )

   ::fireEvent( 'deletedSelection' )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteById( nId )

   ::fireEvent( 'deletingById' )

   ::getDatabase():Execs( ::getDeleteOrUpdateSentenceById( nId ) )

   ::fireEvent( 'deletedById' )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteByUuid( uUuid )

   ::fireEvent( 'deletingByUuid' )

   ::getDatabase():Execs( ::getDeleteOrUpdateSentenceByUuid( uUuid ) )

   ::fireEvent( 'deletedByUuid' )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteWhereParentUuid( uUuid )

   ::fireEvent( 'deletingWhereParentUuid' )

   ::getDatabase():Execs( ::getDeleteOrUpdateSentenceWhereParentUuid( uUuid ) )

   ::fireEvent( 'deletedWhereParentUuid' )
   
RETURN ( nil )

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

METHOD updateFieldWhereId( id, cField, uValue )

   local cSql  

   if !hb_isnumeric( id ) .or. empty( id )
      RETURN ( nil )
   end if 

   cSql        := "UPDATE " + ::getTableName() + " "
   cSql        +=    "SET " + cField + " = " + toSqlString( uValue ) + " "
   cSql        +=    "WHERE id = " + toSqlString( id )

RETURN ( ::getDatabase():Exec( cSql ) )

//----------------------------------------------------------------------------//

METHOD updateBufferWhereId( id, hBuffer )

   local cSql 
   local uValue

   if !hb_isnumeric( id ) .or. empty( id )
      RETURN ( nil )
   end if 

   if !hb_ishash( hBuffer )
      RETURN ( nil )
   end if 
   
   cSQL        := "UPDATE " + ::getTableName() + " SET "

   for each uValue in hBuffer
      cSql     += uValue:__enumKey() + " = " + toSQLString( ::setAttribute( uValue:__enumKey(), uValue ) ) + ", "
   next

   cSql        := chgAtEnd( cSql, '', 2 ) + " "

   cSql        +=    "WHERE id = " + toSqlString( id )

RETURN ( ::getDatabase():Exec( cSql ) )

//---------------------------------------------------------------------------//

METHOD updateFieldWhereUuid( uuid, cField, uValue )

   local cSql  := "UPDATE " + ::getTableName() + " "
   cSql        +=    "SET " + cField + " = " + toSqlString( uValue )    + " "
   cSql        +=    "WHERE uuid = " + toSqlString( uuid )

RETURN ( ::getDatabase():Exec( cSql ) )

//----------------------------------------------------------------------------//

METHOD updateBufferWhereUuid( uuid, hBuffer )

   local cSql  
   local uValue

   cSql           := "UPDATE " + ::getTableName() + " SET "

   for each uValue in hBuffer
      cSql        += uValue:__enumKey() + " = " + toSQLString( uValue ) + ", "
   next

   cSql           := chgAtEnd( cSql, '', 2 ) + " "

   cSql           +=    "WHERE uuid = " + toSqlString( uuid )

RETURN ( ::getDatabase():Exec( cSql ) )

//---------------------------------------------------------------------------//

METHOD getField( cField, cBy, cId )

   local cSql  := "SELECT " + cField                                    + " "                              
   cSql        +=    "FROM " + ::getTableName()                         + " "
   cSql        +=    "WHERE " + cBy + " = " + quoted( cId )             + " "
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():getValue( cSql ) )

//----------------------------------------------------------------------------//

METHOD getFieldWhere( cField, hWhere )

   local cSql        := "SELECT " + cField                                       + " "                              
   cSql              +=    "FROM " + ::getTableName()                            + " "

   hEval( hWhere,; 
      {|k,v| cSql    += ::getWhereOrAnd( cSql ) + k + " = " + toSQLString( v )   + " " } )

   cSql              +=    "LIMIT 1"

RETURN ( ::getDatabase():getValue( cSql ) )

//----------------------------------------------------------------------------//

METHOD Count( oController )

   local cSql  := "SELECT COUNT(*) FROM " + ::getTableName()    

RETURN ( ::getDatabase():getValue( cSql ) )

//---------------------------------------------------------------------------//

METHOD getHashWhere( cBy, cId )

   local cSql  := "SELECT * " 
   cSql        +=    "FROM " + ::getTableName()                         + " "
   cSql        +=    "WHERE " + cBy + " = " + quoted( cId )             + " "
   cSQL        +=    "LIMIT 1"

RETURN ( atail( ::getDatabase():selectTrimedFetchHash( cSql ) ) )

//----------------------------------------------------------------------------//

METHOD getUuidWhereColumn( uValue, cColumn, uDefault ) 

   local uuid
   local cSQL  := "SELECT uuid FROM " + ::getTableName()                + " " 
   cSQL        +=    "WHERE " + cColumn + " = " + toSqlString( uValue ) + " " 
   cSQL        +=    "LIMIT 1"

   uuid        := ::getDatabase():getValue( cSQL )
   if !empty( uuid )
      RETURN ( uuid )
   end if 

RETURN ( uDefault )

//---------------------------------------------------------------------------//

METHOD getIdWhereColumn( uValue, cColumn, uDefault ) 

   local nId
   local cSQL  := "SELECT id FROM " + ::getTableName()                  + " " 
   cSQL        +=    "WHERE " + cColumn + " = " + toSqlString( uValue ) + " " 
   cSQL        +=    "LIMIT 1"

   nId         := ::getDatabase():getValue( cSQL )
   if !empty( nId )
      RETURN ( nId )
   end if 

RETURN ( uDefault )

//---------------------------------------------------------------------------//

METHOD getColumnWhereNombre( uValue, cColumn, uDefault ) 

   local uuid
   local cSQL  := "SELECT " + cColumn + "  FROM " + ::getTableName()          + " " 
   cSQL        +=    "WHERE nombre = " + toSqlString( uValue )                + " " 
   cSQL        +=    "LIMIT 1"

   uuid        := ::getDatabase():getValue( cSQL )
   if !empty( uuid )
      RETURN ( uuid )
   end if 

RETURN ( uDefault )

//---------------------------------------------------------------------------//

METHOD getWhereNombre( cNombre )

   local cSQL  := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE nombre = " + quoted( cNombre )                    + " "    
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getWhereUuid( Uuid )

   local cSQL  := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE uuid = " + quoted( uuid )                         + " "    
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getWhereCodigo( cCodigo )

   local cSQL  := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE codigo = " + quoted( cCodigo )                    + " " 
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD isWhereCodigo( cCodigo )

   local cSQL
   local nCount 

   cSQL        := "SELECT COUNT(*) FROM " + ::getTableName()                  + " "    
   cSQL        +=    "WHERE codigo = " + quoted( cCodigo )                    

   nCount      := ::getDatabase():getValue( cSQL )

RETURN ( hb_isnumeric( nCount ) .and. nCount > 0 )

//---------------------------------------------------------------------------//

METHOD getColumnWhereId( id, cColumn ) 

   local cSQL  := "SELECT " + cColumn + " FROM " + ::getTableName()           + " " 
   cSQL        +=    "WHERE id = " + quoted( id )                             + " " 
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getColumnWhereUuid( uuid, cColumn ) 

   local cSQL     := "SELECT " + cColumn + " FROM " + ::getTableName()  + " " + ;
                        "WHERE uuid = " + quoted( uuid )                + " " + ;
                        "LIMIT 1"

RETURN ( ::getDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getColumnWhereCodigo( uuid, cColumn ) 

   local cSQL     := "SELECT " + cColumn + " FROM " + ::getTableName()  + " " + ;
                        "WHERE codigo = " + quoted( uuid )              + " " + ;
                        "LIMIT 1"

RETURN ( ::getDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getColumn( cColumn ) 

   local cSQL     := "SELECT " + cColumn + "  FROM " + ::getTableName()
   
RETURN ( ::getDatabase():selectFetchArrayOneColumn( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getColumnWhere( cColumn, cField, cCondition, cValue ) 

   local cSQL     := "SELECT " + cColumn + "  FROM " + ::getTableName() + " " + ;
                        "WHERE " + cField + " " + cCondition + " " + toSQLString( cValue )    

RETURN ( ::getDatabase():selectFetchArrayOneColumn( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getColumnsWithBlank( cColumn )

   local aColumns                
   local cSQL     := "SELECT " + cColumn + "  FROM " + ::getTableName()
   
   aColumns       := ::getDatabase():selectFetchArrayOneColumn( cSQL )

   ains( aColumns, 1, "", .t. )
   
RETURN ( aColumns )

//---------------------------------------------------------------------------//

METHOD getControllerParentUuid() 

   if empty( ::oController )
      RETURN ( space( 40 ) )
   end if

   if empty( ::oController:getController() )
      RETURN ( space( 40 ) )
   end if

RETURN ( ::oController:getController():getUuid() )

//---------------------------------------------------------------------------//

METHOD setEvents( aEvents, bEvent )

RETURN ( aeval( aEvents, {|cEvent| ::setEvent( cEvent, bEvent ) } ) )

//----------------------------------------------------------------------------//
