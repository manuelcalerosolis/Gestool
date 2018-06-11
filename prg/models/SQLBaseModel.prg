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

   DATA cFilterWhere                                  INIT ""

   DATA cOthersWhere

   DATA cColumnKey                                    INIT "id"
   
   DATA cColumnCode                                   INIT "codigo"

   DATA hBuffer 

   DATA cSQLInsert

   DATA cSQLUpdate

   DATA cGroupBy                                      INIT ""

   DATA cOrderBy 
   
   DATA cOrientation

   DATA cFind

   DATA aRecordsToDelete

   METHOD New()
   METHOD End()

   METHOD setSQLInsert( cSQLInsert )                  INLINE ( ::cSQLInsert := cSQLInsert )
   METHOD getSQLInsert()                              INLINE ( ::cSQLInsert )

   METHOD setSQLUpdate( cSQLUpdate )                  INLINE ( ::cSQLUpdate := cSQLUpdate )
   METHOD getSQLUpdate()                              INLINE ( ::cSQLUpdate )

   METHOD setAttribute( key, value )
   METHOD getAttribute( key, value )

   // Facades -----------------------------------------------------------------

   METHOD setDatabase( oDb )                          INLINE ( ::oDatabase := oDb )
   METHOD getDatabase()                               INLINE ( if( empty( ::oDatabase ), getSQLDatabase(), ::oDatabase ) )

   METHOD getTableName()                              INLINE ( "gestool." + ::cTableName )

   // Columns-------------------------------------------------------------------

   METHOD getColumns()                                INLINE ( ::hColumns )
   METHOD getTableColumns() 

   METHOD getEmpresaColumns()
   METHOD getDateTimeColumns()
   METHOD getTimeStampColumns()
   METHOD getTimeStampSentColumns()

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
   METHOD getInitialSelect()                          INLINE ( "SELECT * FROM " + ::getTableName() )

   METHOD getField( cField, cBy, cId )
   METHOD getHash( cField, cBy, cId )

   METHOD getIdSelect( id )
   METHOD getWhereSelect( cWhere )
   METHOD getSelectSentence()
   
   METHOD setCreatedTimeStamp( hBuffer )
   METHOD setUpdatedTimeStamp( hBuffer )

   METHOD getInsertSentence()
   METHOD getInsertIgnoreSentence( hBuffer )          INLINE ( ::getInsertSentence( hBuffer, .t. ) )
   METHOD getUpdateSentence()
   METHOD getInsertOnDuplicateSentence( hBuffer )   

   METHOD getdeleteSentenceByUuid( aUuid )
   METHOD getDeleteSentenceById( aId )
   METHOD getDeleteSentenceWhereParentUuid( uUuid )

   METHOD aUuidToDelete()
   
   METHOD getDropTableSentence()

   METHOD setGeneralSelect( cSelect )                 INLINE ( ::cGeneralSelect  := cSelect )
   METHOD setGeneralWhere( cWhere )                   INLINE ( ::cGeneralWhere   := cWhere )
   METHOD addGeneralWhere( cSQLSelect )
   
   METHOD addEmpresaWhere()
   METHOD addParentUuidWhere()                           

   METHOD setOthersWhere( cWhere )                    INLINE ( ::cOthersWhere   := cWhere )
   METHOD addOthersWhere( cSQLSelect )

   METHOD setFilterWhere( cWhere )                    INLINE ( ::cFilterWhere    := cWhere )
   METHOD clearFilterWhere()                          INLINE ( ::cFilterWhere    := "" )
   METHOD getFilterWhere( cWhere )                    INLINE ( ::cFilterWhere )
   METHOD insertFilterWhere( cWhere )                  
   METHOD addFilterWhere( cSQLSelect )

   METHOD addFindWhere( cSQLSelect )

   METHOD setOrderBy( cOrderBy )                      INLINE ( ::cOrderBy        := cOrderBy )
   METHOD getOrderBy()                                INLINE ( ::cOrderBy )

   METHOD setOrientation( cOrientation )              INLINE ( ::cOrientation    := cOrientation )
   METHOD getOrientation()                            INLINE ( ::cOrientation )

   METHOD setGroupBy( cGroupBy )                      INLINE ( ::cGroupBy        := cGroupBy )
   METHOD getGroupBy()                                INLINE ( ::cGroupBy )
   METHOD addGroupBy( cSQLSelect )

   METHOD getWhereOrAnd( cSQLSelect )                 INLINE ( if( hb_at( "WHERE", cSQLSelect ) != 0, " AND ", " WHERE " ) )

   // Where for columns--------------------------------------------------------

   METHOD isEmpresaColumn()                           INLINE ( hb_hhaskey( ::hColumns, "empresa_codigo" ) )
   METHOD isParentUuidColumn()                        INLINE ( hb_hhaskey( ::hColumns, "parent_uuid" ) )

   // Get edit value for xbrowse-----------------------------------------------

   METHOD getEditValue()
   METHOD getValueField( cColumn, uValue )

   METHOD getMethod( cMethod )

   METHOD getSelectByOrder()

   METHOD getWhere( cWhere )                          INLINE ( atail( ::getDatabase():selectFetchHash( ::getWhereSelect( cWhere ) ) ) )

   // Busquedas----------------------------------------------------------------

   METHOD setFind( cFind )                            INLINE ( ::cFind := cFind )
   METHOD findById( nId )
   
   // Busquedas----------------------------------------------------------------

   METHOD getBuffer( cColumn )                        
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

   METHOD insertBlankBuffer()                         INLINE ( ::loadBlankBuffer(), ::insertBuffer() ) 

   // Events-------------------------------------------------------------------

   METHOD setEvents( aEvents, bEvent )
   METHOD setEvent( cEvent, bEvent )                  INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )                         INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )

   METHOD updateFieldWhereId( id, cField, uValue )
   METHOD updateFieldWhereUuid( uuid, cField, uValue )
   METHOD updateFieldsWhereUuid( uuid, hFields )

   // Metodos de consulta------------------------------------------------------

   METHOD getUuidWhereColumn( uValue, cColumn, uDefault ) 
   METHOD getUuidWhereNombre( uValue )                INLINE ( ::getUuidWhereColumn( uValue, 'nombre', '' ) )
   METHOD getUuidWhereCodigo( uValue )                INLINE ( ::getUuidWhereColumn( uValue, 'codigo', '' ) )

   METHOD getWhereUuid( Uuid )
   METHOD getWhereCodigo( cCodigo )
   METHOD getWhereNombre( cNombre )

   METHOD getColumnWhereId( id, cColumn )
   METHOD getNombreWhereId( id )                      INLINE ( ::getColumnWhereId( id, 'nombre' ) )

   METHOD getColumnWhereUuid( uuid, cColumn ) 
   METHOD getNombreWhereUuid( uuid )                  INLINE ( ::getColumnWhereUuid( uuid, 'nombre' ) )
   METHOD getCodigoWhereUuid( uuid )                  INLINE ( ::getColumnWhereUuid( uuid, 'codigo' ) )

   METHOD getColumnWhereId( id, cColumn ) 

   METHOD getColumnWhereCodigo( codigo, cColumn ) 
   METHOD getNombreWhereCodigo( codigo )              INLINE ( ::getColumnWhereCodigo( codigo, 'nombre' ) )
   METHOD getCodigoWhereCodigo( codigo )              INLINE ( ::getColumnWhereCodigo( codigo, 'codigo' ) )

   METHOD getArrayColumns( cColumn ) 
   METHOD getArrayNombres( cColumn )                  INLINE ( ::getArrayColumns( 'nombre' ) )
   METHOD getArrayColumnsWithBlank( cColumn ) 

   METHOD getNombresWithBlank()                       INLINE ( ::getArrayColumnsWithBlank( 'nombre' ) )

   METHOD getSenderControllerParentUuid()

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

   ::cGeneralSelect              := "SELECT * FROM " + ::getTableName()    

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oEvents:End()
   
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

   hset( ::hColumns, "enviado",     {  "create"    => "DATETIME DEFAULT NULL"       ,;
                                       "text"      => "Enviado fecha y hora" }      )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getTimeStampColumns()

   hset( ::hColumns, "created_at",     {  "create"    => "TIMESTAMP NULL DEFAULT NULL" ,;
                                          "default"   => {|| hb_datetime() } }         )

   hset( ::hColumns, "updated_at",     {  "create"    => "TIMESTAMP NULL DEFAULT NULL" ,;
                                          "default"   => {|| hb_datetime() } }         )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getEmpresaColumns()
   
   hset( ::hColumns, "empresa_codigo", {  "create"    => "VARCHAR ( 40 ) NOT NULL"       ,;
                                          "default"   => {|| Company():Codigo() } }        )

   hset( ::hColumns, "usuario_codigo", {  "create"    => "VARCHAR ( 40 ) NOT NULL"       ,;
                                          "default"   => {|| Auth():Codigo() } }           )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getGeneralSelect()

   local cSQLSelect        

   ::fireEvent( 'getingInitialSelect' )   

   cSQLSelect              := ::getInitialSelect()

   ::fireEvent( 'gotInitialSelect' )   

   cSQLSelect              := ::addGeneralWhere( cSQLSelect )

   cSQLSelect              := ::addOthersWhere( cSQLSelect )

   cSQLSelect              := ::addEmpresaWhere( cSQLSelect )

   cSQLSelect              := ::addParentUuidWhere( cSQLSelect )

   cSQLSelect              := ::addFilterWhere( cSQLSelect )

   cSQLSelect              := ::addGroupBy( cSQLSelect )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getIdSelect( id )

   local cSQLSelect        := ::cGeneralSelect + " "
   cSQLSelect              += "WHERE id = " + toSQLString( id )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getWhereSelect( cWhere )

   local cSQLSelect        := ::cGeneralSelect + " "
   cSQLSelect              += "WHERE " + cWhere 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getSelectSentence( cOrderBy, cOrientation ) 

   local cSQLSelect        

   ::cOrderBy              := cOrderBy

   ::cOrientation          := cOrientation

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

METHOD addOthersWhere( cSQLSelect )

   if empty( ::cOthersWhere )
      RETURN ( cSQLSelect )
   end if 
   
   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) + ::cOthersWhere 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addEmpresaWhere( cSQLSelect )

   if !::isEmpresaColumn()
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) + ::getTableName() + ".empresa_codigo = " + toSQLString( Company():Codigo() )

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

   if empty( ::oController:getSenderController() )
      RETURN ( cSQLSelect )
   end if

   uuid           := ::oController:getSenderController():getUuid() 

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

   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) + ::cFilterWhere

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addGroupBy( cSQLSelect )

   if empty( ::getGroupBy() )
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect     += space( 1 ) 
   cSQLSelect     += ::getGroupBy()

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD addFindWhere( cSQLSelect )

   if empty( ::cOrderBy ) .or. empty( ::cFind )
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect     += space( 1 )
   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) + "UPPER(" + ::cOrderBy +") LIKE '%" + Upper( ::cFind ) + "%'" 

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//
/*
METHOD getSelectByOrder( cSQLSelect )

   if !empty( ::getColumnOrder() )
      cSQLSelect  += " ORDER BY " + ::getColumnOrder() 
   end if 

   if !empty( ::getColumnOrientation() ) .and. ::getColumnOrientation() == "A"
      cSQLSelect  += " DESC"
   else
      cSQLSelect  += " ASC"
   end if

RETURN ( cSQLSelect )
*/

//---------------------------------------------------------------------------//

METHOD getSelectByOrder( cSQLSelect )

   if empty( ::cOrderBy )
      RETURN ( cSQLSelect )
   end if 
   
   cSQLSelect     += " ORDER BY " + ::cOrderBy 

   if !empty( ::cOrientation ) .and. ::cOrientation == "A"
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

   // msgInfo( cSQLCreateTable, "cSQLCreateTable " + ::getTableName(), "Create sentence" ) 

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

   DEFAULT cDatabaseMySQL  := ::oDatabase:cDatabaseMySQL

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

METHOD findById( id )

   local hBuffer  

   if !hb_isnumeric( id )
      RETURN ( nil )
   end if 

   hBuffer        := atail( ::getDatabase():selectPadedFetchHash( ::getIdSelect( id ) ) )

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

METHOD setUpdatedTimeStamp( hBuffer )
   
   if ( hhaskey( hBuffer, "modificado" ) )
      hset( hBuffer, "modificado", hb_datetime() )
   end if 

   if ( hhaskey( hBuffer, "updated_at" ) )
      hset( hBuffer, "updated_at", hb_datetime() )
   end if 

RETURN ( hBuffer )

//---------------------------------------------------------------------------//

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

METHOD getInsertOnDuplicateSentence( hBuffer, lDebug )

   local uValue
   local cSQLUpdate  

   DEFAULT hBuffer   := ::hBuffer
   DEFAULT lDebug    := .f.

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

METHOD getDeleteSentenceByUuid( uUuid )

   local cSentence   := "DELETE FROM " + ::getTableName() + " " + ;
                           "WHERE uuid IN ( " 

   if hb_isarray( uUuid )
      aeval( uUuid, {| v | cSentence += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )
      cSentence      := chgAtEnd( cSentence, ' )', 2 )
   end if 

   if hb_ischar( uUuid )
      cSentence      += quoted( uUuid ) + ' )'
   end if 

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getDeleteSentenceWhereParentUuid( aUuid )

   local cSentence   := "DELETE FROM " + ::getTableName() + " " + ;
                           "WHERE parent_uuid IN ( " 

   aeval( aUuid, {| v | cSentence += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )

   cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD getDeleteSentenceById( aIds )

   local cSentence   

   if hb_isnumeric( aIds )
      aIds     := { aIds }
   end if 

   cSentence   := "DELETE FROM " + ::getTableName() + " " + ;
                     "WHERE " + ::cColumnKey + " IN ( "
   
   aeval( aIds, {| v | cSentence += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )

   cSentence   := chgAtEnd( cSentence, ' )', 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD aUuidToDelete( aParentsUuid )

   local cSentence   := "SELECT uuid FROM " + ::getTableName() + " " + ;
                           "WHERE parent_uuid IN ( " 

   aeval( aParentsUuid, {| v | cSentence += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )

   cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN ( ::getDatabase():selectFetchArray( cSentence ) )

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

   ::fireEvent( 'loadingBlankBuffer' )

   ::defaultCurrentBuffer()

   ::fireEvent( 'loadedBlankBuffer' )

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD loadCurrentBuffer( id )                

   ::hBuffer            := {=>}

   ::fireEvent( 'loadingCurrentBuffer' )

   ::hBuffer            := ::findById( id )

   ::fireEvent( 'loadedCurrentBuffer' )

RETURN ( ::hBuffer )

//---------------------------------------------------------------------------//

METHOD loadDuplicateBuffer( id ) 

   ::hBuffer            := {=>}

   ::fireEvent( 'loadingDuplicateBuffer' )

   ::hBuffer            := ::findById( id )

   ::fireEvent( 'loadedDuplicateCurrentBuffer' )

   if hhaskey( ::hBuffer, "id" )
      hset( ::hBuffer, "id", 0 )
   end if 

   if hhaskey( ::hBuffer, "uuid" )   
      hset( ::hBuffer, "uuid", win_uuidcreatestring() )
   end if 

   ::fireEvent( 'loadedDuplicateBuffer' )

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

   ::getInsertSentence( hBuffer )

   ::fireEvent( 'insertingBuffer' )

   if !empty( ::cSQLInsert )
      ::getDatabase():Execs( ::cSQLInsert )
   end if 

   nId         := ::getDatabase():LastInsertId()

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertOnDuplicate( hBuffer, lTransactional )

   DEFAULT lTransactional  := .f.

   ::fireEvent( 'insertingOnDuplicatingBuffer' )

   if lTransactional 
      ::getDatabase():TransactionalExec( ::getInsertOnDuplicateSentence( hBuffer ) )
   else
      ::getDatabase():Execs( ::getInsertOnDuplicateSentence( hBuffer ) )
   end  if 

   ::fireEvent( 'insertedOnDuplicatedBuffer' )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteSelection( aIds, aUuids ) 

   ::aRecordsToDelete   := aIds

   ::fireEvent( 'deletingSelection' )

   ::getDatabase():Execs( ::getDeleteSentenceById( aIds, aUuids ) )

   ::fireEvent( 'deletedSelection' )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteById( nId )

   ::fireEvent( 'deletingById' )

   ::getDatabase():Execs( ::getDeleteSentenceById( nId ) )

   ::fireEvent( 'deletedById' )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteByUuid( uUuid )

   ::fireEvent( 'deletingByUuid' )

   ::getDatabase():Execs( ::getDeleteSentenceByUuid( uUuid ) )

   ::fireEvent( 'deletedByUuid' )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteWhereParentUuid( uUuid )

   ::fireEvent( 'deletingWhereParentUuid' )

   ::getDatabase():Execs( ::getDeleteSentenceWhereParentUuid( uUuid ) )

   ::fireEvent( 'deletedWhereParentUuid' )
   
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

METHOD updateFieldWhereId( id, cField, uValue )

   local cSql  := "UPDATE " + ::getTableName() + " "
   cSql        +=    "SET " + cField + " = " + toSqlString( uValue ) + " "
   cSql        +=    "WHERE id = " + toSqlString( id )

RETURN ( ::getDatabase():Exec( cSql ) )

//----------------------------------------------------------------------------//

METHOD updateFieldWhereUuid( uuid, cField, uValue )

   local cSql  := "UPDATE " + ::getTableName() + " "
   cSql        +=    "SET " + cField + " = " + toSqlString( uValue )    + " "
   cSql        +=    "WHERE uuid = " + toSqlString( uuid )

RETURN ( ::getDatabase():Exec( cSql ) )

//----------------------------------------------------------------------------//

METHOD updateFieldsWhereUuid( uuid, hFields )

   local cSql  
   local uValue

   cSql           := "UPDATE " + ::getTableName() + " SET "

   for each uValue in hFields
      cSql        += uValue:__enumKey() + " = " + toSQLString( uValue ) + ", "
   next

   cSql           := chgAtEnd( cSql, '', 2 ) + " "

   cSql           +=    "WHERE uuid = " + toSqlString( uuid )

RETURN ( ::getDatabase():Exec( cSql ) )

//---------------------------------------------------------------------------//

METHOD getField( cField, cBy, cId )

   local cSql  := "SELECT " + cField                                    + " "                              
   cSql        +=    "FROM " + ::getTableName()                             + " "
   cSql        +=    "WHERE " + cBy + " = " + quoted( cId )             + " "

RETURN ( ::getDatabase():getValue( cSql ) )

//----------------------------------------------------------------------------//

METHOD getHash( cBy, cId )

   local cSql  := "SELECT * " 
   cSql        +=    "FROM "+ ::getTableName()                          + " "
   cSql        +=    "WHERE " + cBy + " = " + quoted( cId )             + " "

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

METHOD getWhereNombre( cNombre )

   local cSQL  := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE nombre = " + quoted( cNombre )                    + " "    
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getColumnWhereId( id, cColumn ) 

   local cSQL     := "SELECT " + cColumn + " FROM " + ::getTableName()  + " " + ;
                        "WHERE id = " + quoted( id )                    + " " + ;
                        "LIMIT 1"

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


METHOD getArrayColumns( cColumn ) 

   local cSQL     := "SELECT " + cColumn + "  FROM " + ::getTableName()
   
RETURN ( ::getDatabase():selectFetchArrayOneColumn( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getArrayColumnsWithBlank( cColumn )

   local aColumns                
   local cSQL     := "SELECT " + cColumn + "  FROM " + ::getTableName()
   
   aColumns       := ::getDatabase():selectFetchArrayOneColumn( cSQL )

   ains( aColumns, 1, "", .t. )
   
RETURN ( aColumns )

//---------------------------------------------------------------------------//

METHOD getSenderControllerParentUuid() 

   if empty( ::oController )
      RETURN ( space( 40 ) )
   end if

   if empty( ::oController:getSenderController() )
      RETURN ( space( 40 ) )
   end if

RETURN ( ::oController:getSenderController():getUuid() )

//---------------------------------------------------------------------------//

METHOD setEvents( aEvents, bEvent )

RETURN ( aeval( aEvents, {|cEvent| ::setEvent( cEvent, bEvent ) } ) )

//----------------------------------------------------------------------------//
