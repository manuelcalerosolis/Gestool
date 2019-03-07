#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS HistoryController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD insertHistory( aChanges, cOperation )

   METHOD prepareHistory( aChanges, cOperation )

   METHOD prepareDetails( aChanges )

   METHOD gettingSelectSentence()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := HistoryBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := HistoryView():New( self ), ), ::oDialogView )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := HistoryRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel := SQLHistoryModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS HistoryController

   ::Super:New( oController )

   ::cTitle                   := "Historico"

   ::cName                    := "historico"

   ::hImage                   := {  "16" => "gc_user_message_16",;
                                    "32" => "gc_user_message_32",;
                                    "48" => "gc_user_message_48" }

   //::nLevel                   := Auth():Level( ::cName )

   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

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

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertHistory( aChanges, cOperation )

   ::getModel():insertHistory( ::prepareHistory( aChanges, cOperation ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD prepareHistory( aChanges, cOperation ) CLASS HistoryController

   local hHash := { "documento_uuid" =>, "operacion" => , "detalle" => }

   local cDetails := ""

   AEval( aChanges, { | aChange | cDetails += ::prepareDetails( aChange ) } )

   hset( hHash, "documento_uuid", ::oController:getModelBuffer( "uuid" ) )

   hset( hHash, "operacion", cOperation )

   hset( hHash, "detalle", cDetails )

RETURN ( hHash )

//---------------------------------------------------------------------------//

METHOD prepareDetails( aChanges ) CLASS HistoryController

   local cDetails := ""

   local hChange

   for each hChange in aChanges

      if hHasKey( hChange, "text" ) .and. hget( hChange, "text" ) != "" 

         cDetails += Alltrim( hget( hChange, "text" ) ) + " : "+ Alltrim( hb_valtostr( hget( hChange, "old" ) ) )
       
         if hHasKey( hChange, "relation_old" )

            if hget( hChange, "relation_old" ) != nil

               cDetails += " " + Alltrim( hget( hChange, "relation_old" ) )

            end if 

         end if
        
        cDetails += " > " + Alltrim( hb_valtostr( hget( hChange, "new" ) ) )

         if hHasKey( hChange, "relation_new")

            cDetails += " " + Alltrim( hget( hChange, "relation_new" ) )

         end if

      end if

      cDetails += CRLF

   next

RETURN ( cDetails )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence()

   local uuid        := ::getController():getModelBuffer( "uuid" )

   if !empty( uuid )
      ::getModel():setGeneralWhere( "documento_uuid = " + quoted( uuid ) )
   end if 

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
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'usuario_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'usuario_nombre'
      :cHeader             := 'Nombre usuario'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'usuario_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'operacion'
      :cHeader             := 'Operación'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'operacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_hora'
      :cHeader             := 'Fecha y Hora'
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
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS HistoryView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "HISTORY_MEDIUM" ;
      TITLE       ::LblTitle() + "historial"

   REDEFINE BITMAP ::oBitmap ; 
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   ::oController:Activate( 100, ::oDialog )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

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