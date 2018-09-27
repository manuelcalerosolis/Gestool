#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS IncidenciasController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()            INLINE ( ::oModel:loadBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::oModel:insertBuffer() )

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

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS IncidenciasController

   ::Super:New( oSenderController )

   ::cTitle                         := "Incidencias"

   ::cName                          := "incidencias_sql"

   ::hImage                         := {  "16" => "gc_hint_16",;
                                          "32" => "gc_hint_32",;
                                          "48" => "gc_hint_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLIncidenciasModel():New( self )

   ::setEvent( 'appended',                      {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',                        {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::oBrowseView:Refresh() } )

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS IncidenciasController

   ::oModel:End()

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

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuidEntidad ) CLASS IncidenciasController

   local idIncidencia     

   if empty( uuidEntidad )
      ::oModel:insertBuffer()
   end if 

   idIncidencia          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idIncidencia )
      idIncidencia       := ::oModel:insertBlankBuffer()
   end if 

   ::oModel:loadCurrentBuffer( idIncidencia )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS IncidenciasController

   local idIncidencia     

   idIncidencia          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idIncidencia )
      ::oModel:insertBuffer()
      RETURN ( nil )
   end if 

   ::oModel:updateBuffer()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) CLASS IncidenciasController

   local idIncidencia     

   idIncidencia          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idIncidencia )
      ::oModel:insertBuffer()
      RETURN ( nil )
   end if 

   ::oModel:loadDuplicateBuffer( idIncidencia )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS IncidenciasController

   hset( ::oModel:hBuffer, "parent_uuid", uuidEntidad )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS IncidenciasController

   if empty( aUuidEntidades )
      RETURN ( nil )
   end if

   ::oModel:deleteWhereParentUuid( aUuidEntidades )

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

   REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_hora" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "mostrar" ] ;
      ID          110 ;
      IDSAY       112 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "descripcion" ] ;
      ID          120 ;
      MEMO ;
      VALID       ( ::oController:validate( "descripcion" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "resuelta" ] ;
      ID          130 ;
      IDSAY       132 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ON CHANGE   ( ::changeFechaResolucion() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oGetFechaResolucion ;
      VAR         ::oController:oModel:hBuffer[ "fecha_hora_resolucion" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION     ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ::oDialog:bStart := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startDialog() CLASS IncidenciasView

   if !::oController:oModel:hBuffer[ "resuelta" ]
      ::oGetFechaResolucion:Hide()
      ::oGetFechaResolucion:Refresh()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changeFechaResolucion() CLASS IncidenciasView

   if ::oController:oModel:hBuffer[ "resuelta" ]

      hSet( ::oController:oModel:hBuffer, "fecha_hora_resolucion", hb_datetime() )
      ::oGetFechaResolucion:Show()

   else

      hSet( ::oController:oModel:hBuffer, "fecha_hora_resolucion", hb_StrToTS( "" ) )
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
                                                   "default"   => {|| ::getSenderControllerParentUuid() } } )

   hset( ::hColumns, "descripcion",             {  "create"    => "TEXT"                                    ,;
                                                   "default"   => {|| "" } }                                )

   hset( ::hColumns, "fecha_hora",              {  "create"    => "TIMESTAMP"                               ,;
                                                   "default"   => {|| hb_datetime() } }                     )
   
   hset( ::hColumns, "mostrar",                {  "create"    => "TINYINT( 1 )"                             ,;
                                                   "default"   => {|| .f. } }                               )

   hset( ::hColumns, "resuelta",                {  "create"    => "TINYINT( 1 )"                            ,;
                                                   "default"   => {|| .f. } }                               )

   hset( ::hColumns, "fecha_hora_resolucion",   {  "create"    => "TIMESTAMP"                               ,;
                                                   "default"   => {|| hb_StrToTS( "" ) } }                  )

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