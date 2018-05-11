#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS IncidenciasController FROM SQLNavigatorController

   METHOD New()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()            INLINE ( ::oModel:loadBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::oModel:insertBuffer() )

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS IncidenciasController

   ::Super:New()

   ::cTitle                      := "Incidencias"

   ::cName                       := "incidencias"

   ::hImage                      := {  "16" => "gc_hint_16",;
                                       "32" => "gc_hint_32",;
                                       "48" => "gc_hint_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLIncidenciasModel():New( self )

   ::oBrowseView                    := IncidenciasBrowseView():New( self )

   ::oDialogView                    := IncidenciasView():New( self )

   ::oValidator                     := IncidenciasValidator():New( self, ::oDialogView )

   ::oRepository                    := IncidenciasRepository():New( self )


RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS IncidenciasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS IncidenciasController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( Self )

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

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS IncidenciasController

   local idIncidencia     

   idIncidencia          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idIncidencia )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) CLASS IncidenciasController

   local idIncidencia     

   idIncidencia          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idIncidencia )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:loadDuplicateBuffer( idIncidencia )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS IncidenciasController

   hset( ::oModel:hBuffer, "parent_uuid", uuidEntidad )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS IncidenciasController

   if empty( aUuidEntidades )
      RETURN ( self )
   end if

   ::oModel:deleteWhereParentUuid( aUuidEntidades )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
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
      :cSortOrder          := 'fecha_hora'
      :cHeader             := 'Fecha y hora'
      :nWidth              := 130
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_hora' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'mostrar'
      :cHeader             := 'Mostrar'
      :SetCheck( { "Sel16", "Nil16" } )
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'mostrar' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'descripcion'
      :cHeader             := 'Descripcion'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descripcion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'resuelta'
      :cHeader             := 'Resuelta'
      :SetCheck( { "Sel16", "Nil16" } )
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'resuelta' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_hora_resolucion'
      :cHeader             := 'Fecha y hora de resolución'
      :nWidth              := 130
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_hora_resolucion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

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
      RESOURCE    "gc_hint_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
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

RETURN ( self )

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

Return ( self )

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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLIncidenciasModel FROM SQLBaseModel

   DATA cTableName               INIT "incidencias"

   METHOD getColumns()

   METHOD getIdWhereParentUuid( uuid ) INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD getParentUuidAttribute( value )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLIncidenciasModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                   ,;
                                                   "default"   => {|| space( 40 ) } }                        )

   hset( ::hColumns, "descripcion",             {  "create"    => "TEXT"                                    ,;
                                                   "default"   => {|| "" } }                                  )

   hset( ::hColumns, "fecha_hora",              {  "create"    => "TIMESTAMP"                               ,;
                                                   "default"   => {|| hb_datetime() } }                     )
   
   hset( ::hColumns, "mostrar",                {  "create"    => "BIT"                                      ,;
                                                   "default"   => {|| .f. } }                                )

   hset( ::hColumns, "resuelta",                {  "create"    => "BIT"                                      ,;
                                                   "default"   => {|| .f. } }                                )

   hset( ::hColumns, "fecha_hora_resolucion",   {  "create"    => "TIMESTAMP"                                ,;
                                                   "default"   => {|| hb_StrToTS( "" ) } }                   )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getParentUuidAttribute( value ) CLASS SQLIncidenciasModel

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oSenderController )
      RETURN ( value )
   end if

RETURN ( ::oController:oSenderController:getUuid() )
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
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