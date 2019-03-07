#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS HistoryController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD insertHistory( aChanges, cOperation )

   METHOD getHistory( aChanges, cOperation )

   METHOD getDetails( aChanges )

   METHOD gettingSelectSentence()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := HistoryBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE ( if( empty( ::oDialogView ), ::oDialogView := HistoryView():New( self ), ), ::oDialogView )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := HistoryRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel := SQLHistoryModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS HistoryController

   ::Super:New( oController )

   ::cTitle                   := "Historico"

   ::cName                    := "historico"

   ::hImage                   := {  "16" => "gc_bookmark_16",;
                                    "32" => "gc_bookmark_32",;
                                    "48" => "gc_bookmark_48" }

   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

   ::getBrowseView():setEvent( 'doubleClicking', {|| .f. } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS HistoryController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD insertHistory( aChanges, cOperation )

RETURN ( ::getModel():insertHistory( ::getHistory( aChanges, cOperation ) ) )

//---------------------------------------------------------------------------//

METHOD getHistory( aChanges, cOperation ) CLASS HistoryController

   local hHash    := {=>}
   local cDetails := ""

   hset( hHash, "documento_uuid", ::oController:getModelBuffer( "uuid" ) )

   hset( hHash, "operacion", cOperation )

   aeval( aChanges, {| aChange | cDetails += ::getDetails( aChange ) } )

   hset( hHash, "detalle", cDetails )

RETURN ( hHash )

//---------------------------------------------------------------------------//

METHOD getDetails( aChanges ) CLASS HistoryController

   local hChange
   local cDetails := ""

   for each hChange in aChanges

      if hhaskey( hChange, "text" ) .and. !empty( hget( hChange, "text" ) )

         cDetails    += alltrim( hget( hChange, "text" ) ) + " : " 

         if !empty( alltrim( hb_valtostr( hget( hChange, "old" ) ) ) )
            cDetails += alltrim( hb_valtostr( hget( hChange, "old" ) ) ) + " "
         end if 
       
         if hhaskey( hChange, "relation_old" ) .and. !empty( hget( hChange, "relation_old" ) )
            cDetails += alltrim( hb_valtostr( hget( hChange, "relation_old" ) ) )
         end if
        
         cDetails    += " > " + alltrim( hb_valtostr( hget( hChange, "new" ) ) ) + " "

         if hhaskey( hChange, "relation_new") .and. !empty( hget( hChange, "relation_new" ) )
            cDetails += alltrim( hb_valtostr( hget( hChange, "relation_new" ) ) )
         end if

         cDetails    += CRLF
      
      end if

   next

RETURN ( cDetails )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence()

   local uuid        := ::getController():getModelBuffer( "uuid" )

   if !empty( uuid )
      ::getModel():setGeneralWhere( "documento_uuid = " + quoted( uuid ) )
   end if 

   ::getModel():setOrderBy( "fecha_hora" )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS HistoryBrowseView FROM SQLBrowseView

   DATA hText                          INIT  {  'insert' => 'Creación',;
                                                'update' => 'Modificación' }

   METHOD addColumns()         

   METHOD getOperacion( cOperation )   INLINE ( hget( ::hText, cOperation ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS HistoryBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'usuario_codigo'
      :cHeader             := 'Usuario'
      :nWidth              := 250
      :bEditValue          := {|| ::getRowSet():fieldGet( 'usuario_codigo' ) + " " + ::getRowSet():fieldGet( 'usuario_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'operacion'
      :cHeader             := 'Operación'
      :nWidth              := 150
      :bEditValue          := {|| ::getOperacion( ::getRowSet():fieldGet( 'operacion' ) ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_hora'
      :cHeader             := 'Fecha y hora'
      :cEditPicture        := '@DT'
      :nWidth              := 140
      :cDataType           := 'D'
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_hora' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS HistoryView FROM SQLBaseView

   DATA oDetalle

   DATA cDetalle INIT ""
  
   METHOD Activate()

   METHOD startActivate()

   METHOD updateDetalle()     INLINE ( ::oDetalle:setText( ::oController:getFieldFromRowSet( "detalle" ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS HistoryView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "HISTORY_MEDIUM" ;
      TITLE       ::LblTitle() + "Historial"

   REDEFINE BITMAP ::oBitmap ; 
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   ::oController:Activate( 100, ::oDialog )

   ::oController:getBrowseView():setChange( {|| ::updateDetalle() } )

   REDEFINE GET   ::oDetalle ;
      VAR         ::cDetalle ;
      MEMO ;
      WHEN        .f. ;
      ID          110 ; 
      OF          ::oDialog

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart     := {|| ::startActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate()

   ::updateDetalle()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLHistoryModel FROM SQLCompanyModel

   DATA cTableName                  INIT "historial"

   //DATA cConstraints                INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD insertHistory( hHistory )

   METHOD getInitialSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLHistoryModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "documento_uuid",    {  "create"    => "VARCHAR ( 40 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "operacion",         {  "create"    => "VARCHAR ( 200 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "detalle",           {  "create"    => "TEXT NOT NULL"                  ,;
                                             "default"   => {|| space( 250 ) } }                       )

   hset( ::hColumns, "fecha_hora",        {  "create"    => "TIMESTAMP NULL DEFAULT NULL" ,;
                                             "default"   => {|| hb_datetime() } }         ) 

   hset( ::hColumns, "usuario_codigo",    {  "create"    => "VARCHAR ( 200 ) NOT NULL"   ,;
                                             "default"   => {|| Auth():codigo }                         }  )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD insertHistory( hHistory ) CLASS SQLHistoryModel

   local hBuffer := ::loadBlankBuffer( hHistory ) 

   ::insertBuffer( hBuffer )

RETURN( nil )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLHistoryModel

   local cSql

   TEXT INTO cSql

      SELECT historial.uuid AS uuid,
            historial.id AS id,
            historial.documento_uuid AS documento_uuid,
            historial.operacion AS operacion,
            historial.detalle AS detalle,
            historial.fecha_hora AS fecha_hora,
            historial.usuario_codigo AS usuario_codigo,
            usuarios.nombre AS usuario_nombre

      FROM %1$s AS historial 

      INNER JOIN gestool.usuarios AS usuarios

         ON historial.usuario_codigo = usuarios.codigo

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS HistoryRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLHistoryModel():getTableName() )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//