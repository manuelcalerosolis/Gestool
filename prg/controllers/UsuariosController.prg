#include "FiveWin.Ch"
#include "Factu.ch" 

#define  __encryption_key__ "snorlax"

//---------------------------------------------------------------------------//

CLASS UsuariosController FROM SQLNavigatorController
   
   DATA oAjustableController 

   DATA oRolesController

   DATA cUuidUsuario

   DATA aCajas
   DATA cUuidCajaExclusiva
   DATA cNombreCajaExclusiva

   DATA aEmpresas
   DATA cCodigoEmpresaExclusiva
   DATA cNombreEmpresaExclusiva

   DATA oLoginView

   METHOD New()
   METHOD End()

   METHOD isLogin()

   METHOD setConfig()

   METHOD loadConfig()

   METHOD saveConfig()

   METHOD startingActivate()

   METHOD validUserPassword()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS UsuariosController

   ::Super:New()

   ::cTitle                := "Usuarios"

   ::setName( "usuarios" )

   ::lTransactional        := .t.

   ::lConfig               := .t.

   ::hImage                := { "16" => "gc_businesspeople_16" }

   ::nLevel                := nLevelUsr( "01052" )

   ::oModel                := SQLUsuariosModel():New( self )

   ::oRepository           := UsuariosRepository():New( self )

   ::oBrowseView           := UsuariosBrowseView():New( self )

   ::oDialogView           := UsuariosView():New( self )

   ::oLoginView            := UsuariosLoginView():New( self )

   ::oValidator            := UsuariosValidator():New( self )

   ::oAjustableController  := AjustableController():New( self )

   ::oRolesController      := RolesController():New( self )

   ::oFilterController:setTableToFilter( ::getName() )

   ::setEvent( 'openingDialog',  {|| ::oDialogView:openingDialog() } )  
   ::setEvent( 'closedDialog',   {|| ::oDialogView:closedDialog() } )  

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oModel )
      ::oModel:End()
      ::oModel                := nil
   endif

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
      ::oBrowseView           := nil
   endif

   if !empty( ::oDialogView )
      ::oDialogView:End()
      ::oDialogView           := nil
   endif

   if !empty( ::oValidator )
      ::oValidator:End()
      ::oValidator            := nil
   endif

   if !empty( ::oAjustableController )
      ::oAjustableController:End()
      ::oAjustableController  := nil
   end if 

   if !empty( ::oRolesController )
      ::oRolesController:End()
      ::oRolesController      := nil
   end if 

   ::Super:End()

   Self                       := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setConfig()

   if ::loadConfig() .and. ;
      ::oAjustableController:DialogViewActivate()

      ::saveConfig()

   end if 
   
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadConfig()

   ::cUuidUsuario             := ::getRowSet():fieldGet( 'uuid' )

   if empty( ::cUuidUsuario )
      RETURN ( .f. )
   end if 

   ::aEmpresas                := EmpresasModel():aNombresSeleccionables()
   ::cCodigoEmpresaExclusiva  := ::oAjustableController:oModel:getUsuarioEmpresaExclusiva( ::cUuidUsuario )
   ::cNombreEmpresaExclusiva  := EmpresasModel():getNombreFromCodigo( ::cCodigoEmpresaExclusiva )

   ::aCajas                   := CajasModel():aNombresSeleccionables()
   ::cUuidCajaExclusiva       := ::oAjustableController:oModel:getUsuarioCajaExclusiva( ::cUuidUsuario )
   ::cNombreCajaExclusiva     := CajasModel():getNombreFromUuid( ::cUuidCajaExclusiva )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD saveConfig()

   ::cCodigoEmpresaExclusiva  := EmpresasModel():getCodigoFromNombre( ::cNombreEmpresaExclusiva )
   ::cUuidCajaExclusiva       := CajasModel():getUuidFromNombre( ::cNombreCajaExclusiva )

   ::oAjustableController:oModel:setUsuarioEmpresaExclusiva( ::cCodigoEmpresaExclusiva, ::cUuidUsuario )
   ::oAjustableController:oModel:setUsuarioCajaExclusiva( ::cUuidCajaExclusiva, ::cUuidUsuario )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD startingActivate()

   local oPanel               := ::oAjustableController:oDialogView:oExplorerBar:AddPanel( "Propiedades usuario", nil, 1 ) 

   oPanel:addComboBox( "Empresa exclusiva", @::cNombreEmpresaExclusiva, ::aEmpresas )

   oPanel:addComboBox( "Caja exclusiva", @::cNombreCajaExclusiva, ::aCajas )
   
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD validUserPassword()

   local hUsuario

   hUsuario                   := ::oRepository:validUserPassword( ::oLoginView:cComboUsuario, ::oLoginView:cGetPassword )

   if empty( hUsuario )
      ::oLoginView:sayError( "Usuario y contraseña con coinciden" )            
      ::oLoginView:sayNo()
      RETURN ( .f. )
   end if 

   if !( setUserActive( hget( hUsuario, "nombre" ) ) )
      ::oLoginView:sayError( "Usuario actualmente en uso" )            
      ::oLoginView:sayNo()
      RETURN ( .f. )
   end if 

   Auth( hUsuario )

   ::oLoginView:oDlg:end( IDOK )      

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isLogin()

   if ( ::oLoginView:Activate() != IDOK )
      RETURN ( .f. )
   end if 

   ::oAjustableController:oModel:setUsuarioPcEnUso( rtrim( netname() ), Auth():uuid() )

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLUsuariosModel FROM SQLBaseModel

   DATA cTableName               INIT "usuarios"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

   METHOD getInsertUsuariosSentence()

   METHOD Crypt( cPassword )     INLINE ( hb_crypt( alltrim( cPassword ), __encryption_key__ ) )
   METHOD Decrypt( cPassword )   INLINE ( hb_decrypt( alltrim( cPassword ), __encryption_key__ ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUsuariosModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR ( 100 ) NOT NULL UNIQUE"         ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "email",          {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "password",       {  "create"    => "VARCHAR ( 100 )"                         ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "remember_token", {  "create"    => "VARCHAR ( 100 )"                         ,;
                                          "default"   => {|| "" } }                                )

   hset( ::hColumns, "codigo",         {  "create"    => "VARCHAR( 3 )"                            ,;
                                          "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "rol_uuid",       {  "create"    => "VARCHAR(40)"                             ,;
                                          "default"   => {|| space( 40 ) } }                       )

   ::getTimeStampColumns()   

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInsertUsuariosSentence()

   local cSQL  := "INSERT IGNORE INTO " + ::cTableName + " "
   cSQL        +=    "( uuid, nombre, email, password ) "
   cSQL        += "VALUES "
   cSQL        +=    "( UUID(), 'Administrador', 'admin@admin.com', " + quoted( ::Crypt( '12345678' ) ) + " )"

RETURN ( cSQL )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UsuariosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS UsuariosBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
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
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
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

CLASS UsuariosView FROM SQLBaseView

   DATA oGetPassword
   DATA cGetPassword          INIT space( 100 )
   DATA oGetRepeatPassword
   DATA cGetRepeatPassword    INIT space( 100 )   

   DATA oComboRol 
   DATA cComboRol   
   DATA aComboRoles           

   METHOD openingDialog()

   METHOD closedDialog()

   METHOD Activate()
   
   METHOD saveView( oDlg )

END CLASS

//---------------------------------------------------------------------------//

METHOD openingDialog() CLASS UsuariosView

   ::cGetPassword          := space( 100 )

   ::cGetRepeatPassword    := space( 100 )

   ::cComboRol             := ::oController:oRolesController:oRepository:getNombre( ::getModel():getBuffer( "rol_uuid" ) )
   ::aComboRoles           := ::oController:oRolesController:oRepository:getNombres()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD closedDialog() CLASS UsuariosView

   ::getModel():setBuffer( "rol_uuid", ::oController:oRolesController:oRepository:getUuid( ::cComboRol ) )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UsuariosView

   local oDlg
   local oBtnOk
   local oBmpGeneral

   DEFINE DIALOG  oDlg ;
      RESOURCE    "USUARIO" ;
      TITLE       ::lblTitle() + "usuario" 

   REDEFINE BITMAP oBmpGeneral ;
      ID          900 ;
      RESOURCE    "gc_businessman_48" ;
      TRANSPARENT ;
      OF          oDlg

   REDEFINE GET   ::getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          oDlg

   REDEFINE GET   ::getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDlg

   REDEFINE GET   ::getModel():hBuffer[ "email" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "email" ) ) ;
      OF          oDlg

   REDEFINE GET   ::oGetPassword ;
      VAR         ::cGetPassword ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          oDlg
   
   ::oGetPassword:bValid         := {|| ::oController:validate( "password", ::cGetPassword ) }

   REDEFINE GET   ::oGetRepeatPassword ;
      VAR         ::cGetRepeatPassword ;
      ID          131 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          oDlg

   ::oGetRepeatPassword:bValid   := {|| ::oController:validate( "repeatPassword", ::cGetRepeatPassword ) }

   REDEFINE COMBOBOX ::oComboRol ;
      VAR         ::cComboRol ;
      ID          140 ;
      ITEMS       ::aComboRoles ;
      OF          oDlg

   REDEFINE BUTTON oBtnOk ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( ::saveView( oDlg ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )

   oDlg:Activate( , , , .t. )

   oBmpGeneral:end()

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//

METHOD saveView( oDlg )

   if !( validateDialog( oDlg ) )
      RETURN ( .f. )
   end if 

   if !empty( ::cGetPassword )
      ::getModel():setBuffer( "password", ::getModel():Crypt( ::cGetPassword ) )
   end if 

   oDlg:end( IDOK )

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UsuariosValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD Password()

   METHOD RepeatPassword()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS UsuariosValidator

   ::hValidators  := {  "codigo" =>          {  "required"        => "El código es un dato requerido",;
                                                "unique"          => "El código ya existe" },; 
                        "nombre" =>          {  "required"        => "El nombre es un dato requerido",;
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

CLASS UsuariosRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLUsuariosModel():getTableName() ) 

   METHOD validUserPassword() 

   METHOD getWhereUuid( uuid ) 

   METHOD Crypt( cPassword )     INLINE ( hb_crypt( alltrim( cPassword ), __encryption_key__ ) )

   METHOD getNombreUsuarioWhereNetName( cNetName )

END CLASS

//---------------------------------------------------------------------------//

METHOD validUserPassword( cNombre, cPassword ) CLASS UsuariosRepository

   local cSQL  := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE nombre = " + quoted( cNombre )                    + " "    

   if ( alltrim( cPassword ) != __encryption_key__ ) .and. !( "NOPASSWORD" $ appParamsMain() )
      cSQL     +=     "AND password = " + quoted( ::Crypt( cPassword ) )      + " " 
   end if 

   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getWhereUuid( Uuid ) CLASS UsuariosRepository

   local cSQL  := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE uuid = " + quoted( uuid )                         + " "    
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getNombreUsuarioWhereNetName( cNetName )

   local cSQL  := "SELECT usuarios.nombre FROM " + ::getTableName() + " "   
   cSQL        +=    "INNER JOIN ajustables "
   cSQL        +=       "ON usuarios.uuid = ajustables.ajustable_uuid "
   cSQL        +=    "WHERE ajustables.ajuste_valor = " + quoted( cNetName ) + " "    
   cSQL        +=       "AND ajustables.ajustable_tipo = 'usuarios'"

RETURN ( ::getDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UsuariosLoginView FROM SQLBaseView

   DATA oDlg

   DATA oSayError
   DATA cSayError

   DATA oGetPassword
   DATA cGetPassword

   DATA oComboUsuario
   DATA cComboUsuario   
   DATA aComboUsuarios           

   METHOD Activate()
      METHOD onActivate()

   METHOD sayNo()
   METHOD sayError( cError )  INLINE ( ::oSayError:setText( cError ), ::oSayError:Show() )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD onActivate() CLASS UsuariosLoginView

   ::cGetPassword          := space( 100 )
   ::aComboUsuarios        := ::oController:oRepository:getNombres()
   ::cComboUsuario         := ::oController:oRepository:getNombreUsuarioWhereNetName( netname() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UsuariosLoginView

   local oBmpGeneral

   ::onActivate()

   DEFINE DIALOG  ::oDlg ;
      RESOURCE    "LOGIN" 

   REDEFINE BITMAP oBmpGeneral ;
      ID          900 ;
      RESOURCE    "gestool_logo" ;
      TRANSPARENT ;
      OF          ::oDlg

   REDEFINE COMBOBOX ::oComboUsuario ;
      VAR         ::cComboUsuario ;
      ID          100 ;
      ITEMS       ::aComboUsuarios ;
      OF          ::oDlg

   REDEFINE GET   ::oGetPassword ;
      VAR         ::cGetPassword ;
      ID          110 ;
      OF          ::oDlg

   REDEFINE SAY   ::oSayError ;
      ID          120 ;
      COLOR       Rgb( 183, 28, 28 ) ;
      OF          ::oDlg

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::oController:validUserPassword() )

   ::oDlg:AddFastKey( VK_F5, {|| ::oController:validUserPassword() } )

   ::oDlg:Activate( , , , .t. )

   oBmpGeneral:end()

RETURN ( ::oDlg:nResult )

//---------------------------------------------------------------------------//

METHOD sayNo()

   ::oDlg:coorsUpdate()
   ::oDlg:Move( ::oDlg:nTop, ::oDlg:nLeft - 100 )  ; SysWait(.05)
   ::oDlg:Move( ::oDlg:nTop, ::oDlg:nLeft )        ; SysWait(.05)
   ::oDlg:Move( ::oDlg:nTop, ::oDlg:nLeft + 100 )  ; SysWait(.05)
   ::oDlg:Move( ::oDlg:nTop, ::oDlg:nLeft )        ; SysWait(.05)
   ::oDlg:Move( ::oDlg:nTop, ::oDlg:nLeft - 50 )   ; SysWait(.1)
   ::oDlg:Move( ::oDlg:nTop, ::oDlg:nLeft  )       ; SysWait(.1)
   ::oDlg:Move( ::oDlg:nTop, ::oDlg:nLeft + 50 )   ; SysWait(.1)
   ::oDlg:Move( ::oDlg:nTop, ::oDlg:nLeft )

RETURN ( .f. )

//---------------------------------------------------------------------------//
