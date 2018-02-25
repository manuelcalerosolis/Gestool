#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SettingsController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS SettingsController

   ::Super:New()

   ::cTitle                := "Settings"

   ::setName( "Settings" )

   ::lTransactional        := .t.

   ::hImage                := { "16" => "gc_businesspeople_16" }

   ::nLevel                := nLevelUsr( "01052" )

   ::oModel                := SQLSettingsModel():New( self )

   ::oRepository           := SettingsRepository():New( self )

   ::oBrowseView           := SettingsBrowseView():New( self )

   ::oDialogView           := SettingsView():New( self )

   ::oValidator            := SettingsValidator():New( self )

   ::oFilterController:setTableToFilter( ::getName() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty(::oModel)
      ::oModel:End()
   endif

   if !empty(::oBrowseView)
      ::oBrowseView:End()
   endif

   if !empty(::oDialogView)
      ::oDialogView:End()
   endif

   if !empty(::oValidator)
      ::oValidator:End()
   endif

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLSettingsModel FROM SQLBaseModel

   DATA cTableName               INIT "Settings"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (setting)"

   METHOD getColumns()

   METHOD getInsertSettingsSentence()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLSettingsModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "setting",        {  "create"    => "VARCHAR ( 100 ) NOT NULL UNIQUE"         ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "caption",        {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "constrained",    {  "create"    => "TINYINT"                                 ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "data_type",      {  "create"    => "VARCHAR ( 12 )"                          ,;
                                          "default"   => {|| "alphanumeric" } }                    )

   hset( ::hColumns, "min_value",      {  "create"    => "INT"                                     ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "max_value",      {  "create"    => "INT"                                     ,;
                                          "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInsertSettingsSentence()

   local cStatement 

   cStatement  := "INSERT IGNORE INTO " + ::cTableName + " "
   cStatement  +=    "( uuid, setting, caption, constrained, data_type, min_value, max_value ) "
   cStatement  += "VALUES "
   cStatement  +=    "( UUID(), 'empresa_en_uso',              'Empresa en uso',              1, 'alphanumeric', NULL, NULL ), "
   cStatement  +=    "( UUID(), 'caja_en_uso',                 'Caja en uso',                 1, 'alphanumeric', NULL, NULL ), "
   cStatement  +=    "( UUID(), 'almacen_en_uso',              'Almacén en uso',              1, 'alphanumeric', NULL, NULL ), "
   cStatement  +=    "( UUID(), 'mostrar_rentabilidad',        'Mostrar rentabilidad',        1, 'boolean',      NULL, NULL ), "
   cStatement  +=    "( UUID(), 'cambiar_precios',             'Cambiar precios',             1, 'boolean',      NULL, NULL ), "
   cStatement  +=    "( UUID(), 'ver_precios_costo',           'Ver precios costo',           1, 'boolean',      NULL, NULL ), "
   cStatement  +=    "( UUID(), 'confirmacion_eliminacion',    'Confirmación eliminación',    1, 'boolean',      NULL, NULL ), "
   cStatement  +=    "( UUID(), 'fitrar_ventas_por_usuario',   'Fitrar ventas por usuario',   1, 'boolean',      NULL, NULL )"

RETURN ( cStatement )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SettingsBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS SettingsBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'name'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'name' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'email'
      :cHeader             := 'Email'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'email' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'password'
      :cHeader             := 'Contraseña'
      :nWidth              := 180
      :bEditValue          := {|| ::getRowSet():fieldGet( 'password' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'creado'
      :cHeader             := 'Creado'
      :cEditPicture        := '@DT'
      :nWidth              := 140
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :lHide               := .t.
      :bEditValue          := {|| ::getRowSet():fieldGet( 'created_at' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'modificado'
      :cHeader             := 'Modificado'
      :cEditPicture        := '@DT'
      :nWidth              := 140
      :nHeadStrAlign       := AL_LEFT
      :nDataStrAlign       := AL_LEFT
      :lHide               := .t.
      :bEditValue          := {|| ::getRowSet():fieldGet( 'updated_at' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SettingsView FROM SQLBaseView

   DATA oGetPassword
   DATA cGetPassword          INIT space( 100 )
   DATA oGetRepeatPassword
   DATA cGetRepeatPassword    INIT space( 100 )   

   METHOD Activate()
   
   METHOD saveView( oDlg )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS SettingsView

   local oDlg
   local oBtnOk
   local oBmpGeneral

   ::cGetPassword          := space( 100 )
   ::cGetRepeatPassword    := space( 100 )

   DEFINE DIALOG oDlg ;
      RESOURCE    "USUARIO" ;
      TITLE       ::lblTitle() + "usuario" 

   REDEFINE BITMAP oBmpGeneral ;
      ID          900 ;
      RESOURCE    "gc_businessman_48" ;
      TRANSPARENT ;
      OF          oDlg

   REDEFINE GET   ::getModel():hBuffer[ "id" ] ;
      ID          100 ;
      WHEN        ( .f. ) ;
      OF          oDlg

   REDEFINE GET   ::getModel():hBuffer[ "name" ] ;
      ID          110 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validate( "name" ) ) ;
      OF          oDlg

   REDEFINE GET   ::getModel():hBuffer[ "email" ] ;
      ID          120 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validate( "email" ) ) ;
      OF          oDlg

   REDEFINE GET   ::oGetPassword ;
      VAR         ::cGetPassword ;
      ID          130 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      OF          oDlg
   
   ::oGetPassword:bValid         := {|| ::oController:validate( "password", ::cGetPassword ) }

   REDEFINE GET   ::oGetRepeatPassword ;
      VAR         ::cGetRepeatPassword ;
      ID          131 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      OF          oDlg

   ::oGetRepeatPassword:bValid   := {|| ::oController:validate( "repeatPassword", ::cGetRepeatPassword ) }

   REDEFINE BUTTON oBtnOk ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( !::oController:isZoomMode() ) ;   
      ACTION      ( ::saveView( oDlg ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )

   ACTIVATE DIALOG oDlg CENTER

   oBmpGeneral:end()

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//

METHOD saveView( oDlg )

   if !( validateDialog( oDlg ) )
      RETURN ( .f. )
   end if 

   if !empty( ::cGetPassword )
      ::getModel():setBuffer( "password", hb_crypt( alltrim( ::cGetPassword ), "snorlax" ) )
   end if 

   oDlg:end( IDOK )

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SettingsValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD Password()

   METHOD RepeatPassword()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS SettingsValidator

   ::hValidators  := {  "name" =>            {  "required"        => "El nombre es un dato requerido",;
                                                "unique"          => "El nombre ya existe" },; 
                        "email" =>           {  "required"        => "El email es un dato requerido",;
                                                "mail"            => "El email no es valido" },;
                        "password" =>        {  "password"        => "- Contraseña debe de tener al menos ocho caracteres y un máximo de dieciseis" + CRLF + ;
                                                                     "- No puede contener espacios"  },;
                        "repeatPassword" =>  {  "repeatPassword"  => "Las contraseñas no coinciden" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD Password( uValue )

   uValue         := alltrim( uValue )

   if ::oController:isAppendMode()
      RETURN ( ::Super:Password( uValue ) )
   end if 

   if ::oController:isEditMode() .and. !empty( uValue )
      RETURN ( ::Super:Password( uValue ) )
   end if       

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD RepeatPassword( uValue )

   if empty( ::oController:oDialogView:cGetPassword ) 
      RETURN ( .t. )
   end if 
      
RETURN ( alltrim( ::oController:oDialogView:cGetPassword ) == alltrim( uValue ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SettingsRepository FROM SQLBaseRepository

   METHOD getTableName()      INLINE ( SQLSettingsModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
