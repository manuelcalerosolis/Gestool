#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS IncidenciasController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()            INLINE ( ::getModel():loadBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::getModel():insertBuffer() )

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   //Construcciones tardias----------------------------------------------------
   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := IncidenciasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := IncidenciasView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := IncidenciasValidator():New( self  ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := IncidenciasRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel := SQLIncidenciasModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS IncidenciasController

   ::Super:New( oController )

   ::cTitle                         := "Incidencias"

   ::cName                          := "incidencias_sql"

   ::hImage                         := {  "16" => "gc_hint_16",;
                                          "32" => "gc_hint_32",;
                                          "48" => "gc_hint_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::setEvent( 'appended',                      {|| ::getBrowseView():Refresh() } )
   ::setEvent( 'edited',                        {|| ::getBrowseView():Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::getBrowseView():Refresh() } )

   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS IncidenciasController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if
   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if
   if !empty( ::oValidator )
      ::oValidator:End()
   end if
   if !empty( ::oRepository )
      ::oRepository:End()
   end if
   
   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS IncidenciasController

   local uuid        := ::getController():getUuid() 

   if !empty( uuid )
      ::getModel():setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuidEntidad ) CLASS IncidenciasController

   local idIncidencia     

   if empty( uuidEntidad )
      ::getModel():insertBuffer()
   end if 

   idIncidencia          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idIncidencia )
      idIncidencia       := ::getModel():insertBlankBuffer()
   end if 

   ::getModel():loadCurrentBuffer( idIncidencia )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS IncidenciasController

   local idIncidencia     

   idIncidencia          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idIncidencia )
      ::getModel():insertBuffer()
      RETURN ( nil )
   end if 

   ::getModel():updateBuffer()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) CLASS IncidenciasController

   local idIncidencia     

   idIncidencia          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idIncidencia )
      ::getModel():insertBuffer()
      RETURN ( nil )
   end if 

   ::getModel():loadDuplicateBuffer( idIncidencia )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS IncidenciasController

   hset( ::getModel():hBuffer, "parent_uuid", uuidEntidad )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS IncidenciasController

   if empty( aUuidEntidades )
      RETURN ( nil )
   end if

   ::getModel():deleteWhereParentUuid( aUuidEntidades )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS IncidenciasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS IncidenciasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'mostrar'
      :cHeader             := 'Mostrar'
      :nWidth              := 60
      :bEditValue          := {|| if( ::getRowSet():fieldGet( 'mostrar' ), "Mostrar", ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'descripcion'
      :cHeader             := 'Descripcion'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descripcion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_hora'
      :cHeader             := 'Fecha y hora'
      :nWidth              := 130
      :bEditValue          := {|| hb_TSToStr( ::getRowSet():fieldGet( 'fecha_hora' ) ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'resuelta'
      :cHeader             := 'Resuelta'
      :nWidth              := 60
      :bEditValue          := {|| if( ::getRowSet():fieldGet( 'resuelta' ), "Resuelta", ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_hora_resolucion'
      :cHeader             := 'Fecha y hora de resolución'
      :nWidth              := 130
      :bEditValue          := {|| hb_TSToStr( ::getRowSet():fieldGet( 'fecha_hora_resolucion' ) ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS IncidenciasView FROM SQLBaseView
  
   DATA oGetFechaResolucion

   METHOD Activate()

   METHOD startDialog()

   METHOD changeFechaResolucion()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS IncidenciasView

   local oDialog
   local oBmpGeneral

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "INCIDENCIA_SQL" ;
      TITLE       ::LblTitle() + "incidencia"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "fecha_hora" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE SAYCHECKBOX ::oController:getModel():hBuffer[ "mostrar" ] ;
      ID          110 ;
      IDSAY       112 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "descripcion" ] ;
      ID          120 ;
      MEMO ;
      VALID       ( ::oController:validate( "descripcion" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE SAYCHECKBOX ::oController:getModel():hBuffer[ "resuelta" ] ;
      ID          130 ;
      IDSAY       132 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ON CHANGE   ( ::changeFechaResolucion() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oGetFechaResolucion ;
      VAR         ::oController:getModel():hBuffer[ "fecha_hora_resolucion" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startDialog() CLASS IncidenciasView

   if !::oController:getModel():hBuffer[ "resuelta" ]
      ::oGetFechaResolucion:Hide()
      ::oGetFechaResolucion:Refresh()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changeFechaResolucion() CLASS IncidenciasView

   if ::oController:getModel():hBuffer[ "resuelta" ]

      hSet( ::oController:getModel():hBuffer, "fecha_hora_resolucion", hb_datetime() )
      ::oGetFechaResolucion:Show()

   else

      hSet( ::oController:getModel():hBuffer, "fecha_hora_resolucion", hb_StrToTS( "" ) )
      ::oGetFechaResolucion:Hide()

   end if

   ::oGetFechaResolucion:Refresh()

Return ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS IncidenciasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS IncidenciasValidator

   ::hValidators  := {  "descripcion" =>           {  "required"              => "La descripción es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLIncidenciasModel FROM SQLCompanyModel

   DATA cTableName               INIT "incidencias"

   DATA cConstraints             INIT "PRIMARY KEY ( parent_uuid, descripcion, deleted_at )"

   METHOD getColumns()

   METHOD getIdWhereParentUuid( uuid ) INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLIncidenciasModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                   "default"   => {|| ::getControllerParentUuid() } } )

   hset( ::hColumns, "descripcion",             {  "create"    => "VARCHAR( 200 ) NOT NULL"                                    ,;
                                                   "default"   => {|| space( 200 ) } }                                )

   hset( ::hColumns, "fecha_hora",              {  "create"    => "TIMESTAMP"                               ,;
                                                   "default"   => {|| hb_datetime() } }                     )
   
   hset( ::hColumns, "mostrar",                {  "create"    => "TINYINT( 1 )"                             ,;
                                                   "default"   => {|| .f. } }                               )

   hset( ::hColumns, "resuelta",                {  "create"    => "TINYINT( 1 )"                            ,;
                                                   "default"   => {|| .f. } }                               )

   hset( ::hColumns, "fecha_hora_resolucion",   {  "create"    => "TIMESTAMP"                               ,;
                                                   "default"   => {|| hb_StrToTS( "" ) } }                  )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS IncidenciasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLIncidenciasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//