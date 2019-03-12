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

   METHOD isCanceled( uuid )

   METHOD insertEmail( uuid, cDestino )

   METHOD insertErrorEmail( uuid, cDestino )

   METHOD InsertFacturaOrigen( hHeader, uuidDestino )
   METHOD InsertFacturaDestino( aHedaers, uuidDestino )

   METHOD getOrigenController()           INLINE ( ::oController:getOrigenController() )

   METHOD getDestinoController()          INLINE ( ::oController:getDestinoController() )

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

METHOD insertHistory( aChanges, cOperation ) CLASS HistoryController
   
   if !empty( aChanges )
      ::getModel():insertHistory( ::getHistory( aChanges, cOperation ) )
   end if

RETURN ( nil )

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

METHOD InsertFacturaOrigen( hHedaer, uuidDestino ) CLASS HistoryController

   ::getModel():insertConvert( hget( hHedaer, "uuid" ) ,;
                               ::getDestinoController:cTitle ,;
                               ::getDestinoController:getModel():getField( "serie", "uuid", uuidDestino ),;
                               ::getDestinoController:getModel():getField( "numero", "uuid", uuidDestino ) )

   //::getModel():insertConvertDestino( uuidDestino, hget( hHedaer, "uuid" ) )

RETURN( nil )

//---------------------------------------------------------------------------//

METHOD InsertFacturaDestino( aHedaers, uuidDestino )

RETURN ( ::getModel():insertConvertDestinoMultiple( aHedaers, uuidDestino ) )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS HistoryController

   local uuid        := ::getController():getModelBuffer( "uuid" )

   if !empty( uuid )
      ::getModel():setGeneralWhere( "documento_uuid = " + quoted( uuid ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isCanceled( uuid ) CLASS HistoryController

RETURN ( ::oController:getModel():isCanceledWhereUuid( uuid ) != 0 )

//---------------------------------------------------------------------------//

METHOD insertEmail( uuid, cDestino ) CLASS HistoryController

   local cDetails

   cDetails := "Enviado a : " + alltrim( cDestino )

   ::getModel():insertHistory( { "documento_uuid" => uuid, "operacion" => hget( OPERATION_TEXT, IS_SENDED ), "detalle" => cDetails } )
  
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertErrorEmail( uuid, cDestino ) CLASS HistoryController

   local cDetails

   cDetails := "Intento de envío a: " + alltrim( cDestino )

   ::getModel():insertHistory( { "documento_uuid" => uuid, "operacion" => hget( OPERATION_TEXT, IS_NOTSENDED ), "detalle" => cDetails } )
  
RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS HistoryBrowseView FROM SQLBrowseView
 
   METHOD addColumns()         

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS HistoryBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'usuario_codigo'
      :cHeader             := 'Código usuario'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'usuario_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

    with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'usuario_nombre'
      :cHeader             := 'Nombre usuario'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'usuario_nombre' )  }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'operacion'
      :cHeader             := 'Operación'
      :nWidth              := 150
      :bEditValue          := {||  ::getRowSet():fieldGet( 'operacion' )  }
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

   METHOD updateDetalle()              INLINE ( ::oDetalle:setText( ::oController:getFieldFromRowSet( "detalle" ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS HistoryView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "HISTORY_MEDIUM" ;
      TITLE       "Historial"

   REDEFINE BITMAP ::oBitmap ; 
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   ::oController:Activate( 100, ::oDialog )

   ::oController:getBrowseView():setChange( {|| ::updateDetalle() } )

   REDEFINE SAY   ::oDetalle ;
      VAR         ::cDetalle ;
      ID          110 ; 
      OF          ::oDialog

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bStart     := {|| ::startActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate()

RETURN ( ::updateDetalle() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLHistoryModel FROM SQLCompanyModel

   DATA cTableName                     INIT "historial"

   METHOD getColumns()

   METHOD insertHistory( hHistory )

   METHOD getInitialSelect()

   METHOD insertCanceled()

   METHOD insertOthers( uuid, cOperation )

   METHOD insertConvert( uuid, cDestino, cSerie, nNumero  )

   METHOD insertConvertDestino( UuidDestino, uuidOrigen )

   METHOD insertConvertDestinoMultiple( aHeaders, uuidDestino )

   METHOD countHistory( cOperation )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLHistoryModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"          ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "documento_uuid",    {  "create"    => "VARCHAR ( 40 ) NOT NULL"                 ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "operacion",         {  "create"    => "VARCHAR ( 200 ) NOT NULL"                ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "detalle",           {  "create"    => "TEXT NOT NULL"                           ,;
                                             "default"   => {|| space( 250 ) } }                       )

   hset( ::hColumns, "fecha_hora",        {  "create"    => "TIMESTAMP NULL DEFAULT NULL"             ,;
                                             "default"   => {|| hb_datetime() } }                     ) 

   hset( ::hColumns, "usuario_codigo",    {  "create"    => "VARCHAR ( 200 ) NOT NULL"                ,;
                                             "default"   => {|| Auth():codigo } }                     )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD insertHistory( hHistory ) CLASS SQLHistoryModel

RETURN ( ::insertBuffer( ::loadBlankBuffer( hHistory ) ) )

//---------------------------------------------------------------------------//

METHOD insertCanceled() CLASS SQLHistoryModel

   local uuid
   local uuids    := ::oController:oController:getUuids()

   for each uuid in uuids

      if !( ::oController:isCanceled( uuid ) )
         ::insertBuffer( ::loadBlankBuffer( { "documento_uuid" => uuid, "operacion" => hget( OPERATION_TEXT, IS_CANCELED ) } ) )
      end if 

   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertOthers( uuid, cOperation ) CLASS SQLHistoryModel

RETURN ( ::insertBuffer( ::loadBlankBuffer( { "documento_uuid" => uuid, "operacion" => cOperation } ) ) )

//---------------------------------------------------------------------------//

METHOD insertConvert( uuidOrigen, cDestino, cSerie, nNumero ) CLASS SQLHistoryModel

   local cDetails := "Conversión a " + cDestino + " : " + alltrim( cSerie ) + "-" + alltrim( hb_valtostr( nNumero ) )

RETURN ( ::insertBuffer( ::loadBlankBuffer(  {  "documento_uuid"  => uuidOrigen ,;
                                                "operacion"       => hget( OPERATION_TEXT, IS_CONVERTED ) ,;
                                                "detalle"         =>  cDetails } ) ) )

//---------------------------------------------------------------------------//

METHOD insertConvertDestino( uuidDestino, uuidOrigen ) CLASS SQLHistoryModel

   local cDetails 

   cDetails := "Creación a través de " + alltrim( ::oController:getOrigenController():cTitle ) + " : "
   cDetails += alltrim( ::oController:getOrigenController():getModel():getField( "serie", "uuid", uuidOrigen ) ) + "-" 
   cDetails += alltrim( hb_valtostr( ::oController:getOrigenController():getModel():getField( "numero", "uuid", uuidOrigen ) ) ) 

RETURN ( ::insertHistory(  {  "documento_uuid"  => uuidDestino,;
                              "operacion"       => hget( OPERATION_TEXT, IS_INSERTED ),;
                              "detalle"         => cDetails } ) )

//---------------------------------------------------------------------------//

METHOD insertConvertDestinoMultiple( aHeaders, uuidDestino ) CLASS SQLHistoryModel

   local aHeader
   local cDetails 

   cDetails    := "Creación a través de " + alltrim( ::oController:getOrigenController():cTitle ) + " : " 

   for each aHeader in aHeaders
      cDetails += alltrim( ::oController:getOrigenController():getModel():getField( "serie", "uuid", hget( aHeader, "uuid" ) ) )
      cDetails += "-"
      cDetails += alltrim( hb_valtostr( ::oController:getOrigenController():getModel():getField( "numero", "uuid", hget( aHeader, "uuid" ) ) )  ) + ", "
   next 

   cDetails    := chgAtEnd( cDetails, '', 2 )

RETURN ( ::insertHistory(  {  "documento_uuid"  => uuidDestino,;
                              "operacion"       => hget( OPERATION_TEXT, IS_INSERTED ),;
                              "detalle"         => cDetails } ) )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLHistoryModel

   local cSql

   TEXT INTO cSql

      SELECT 
         historial.uuid AS uuid,
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

METHOD countHistory( cOperation ) CLASS SQLHistoryModel

 local cSql

   TEXT INTO cSql

   SELECT COUNT(*)
   
      FROM %1$s AS historial
   WHERE historial.operacion = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( cOperation ) )

RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

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