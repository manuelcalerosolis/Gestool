#include "FiveWin.Ch"
#include "Factu.ch" 

#define  __encryption_key__   "snorlax"
#define  __admin_name__       "Super administrador"
#define  __admin_password__   "superusuario"

//---------------------------------------------------------------------------//

CLASS UsuariosController FROM SQLNavigatorGestoolController
   
   DATA cUuidUsuario

   DATA oAjustableController 

   DATA oEmpresasController

   DATA oRolesController

   DATA oCamposExtraValoresController

   DATA aCajas
   DATA oComboCaja
   DATA cUuidCajaExclusiva
   DATA cNombreCajaExclusiva

   DATA aEmpresas
   DATA oComboEmpresa
   DATA cCodigoEmpresaExclusiva
   DATA cNombreEmpresaExclusiva

   DATA aAlmacenes
   DATA oComboAlmacen
   DATA cUuidAlmacenExclusivo
   DATA cNombreAlmacenExclusivo

   DATA aDelegaciones
   DATA oComboDelegacion
   DATA cUuidDelegacionExclusiva
   DATA cNombreDelegacionExclusiva

   DATA cValidError                    INIT "" 

   DATA oAuth  

   METHOD New() CONSTRUCTOR

   METHOD End()
   
   METHOD getName()                    INLINE ( "usuarios" )

   METHOD editConfig()

   METHOD loadConfig()

   METHOD saveConfig()

   METHOD startingActivate()

   METHOD changeComboEmpresa()

   METHOD checkSuperUser()

   //Construcciones tardias----------------------------------------------------

   METHOD getRolesController()         INLINE ( iif( empty( ::oRolesController), ::oRolesController := RolesController():New( self ), ), ::oRolesController )

   METHOD getCamposExtraValoresController() ;
                                       INLINE ( iif( empty( ::oCamposExtraValoresController ), ::oCamposExtraValoresController := CamposExtraValoresGestoolController():New( self ), ), ::oCamposExtraValoresController )
   
   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := UsuariosView():New( self ), ), ::oDialogView )
   
   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := UsuariosBrowseView():New( self ), ), ::oBrowseView )

   METHOD getValidator()               INLINE ( iif( empty( ::oValidator ), ::oValidator := UsuariosValidator():New( self, ::getDialogView() ), ), ::oValidator )

   METHOD getRepository()              INLINE ( iif( empty( ::oRepository ), ::oRepository := UsuariosRepository():New( self ), ), ::oRepository )

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLUsuariosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS UsuariosController

   ::Super:New( oController )

   ::cTitle                            := "Usuarios"

   ::lTransactional                    := .t.

   ::lConfig                           := .t.

   ::hImage                            := {  "16" => "gc_businesspeople_16",;
                                             "48" => "gc_businesspeople_48" }

   ::oAuth                             := AuthManager():New( self )

   ::setEvents( { 'editing', 'deleting' }, {|| if( ::isRowSetSystemRegister(), ( msgStop( "Este registro pertenece al sistema, no se puede alterar." ), .f. ), .t. ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS UsuariosController

   if !empty( ::oModel )
      ::oModel:End()
   endif

   if !empty( ::oRepository )
      ::oRepository:End()
   endif

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   endif

   if !empty( ::oDialogView )
      ::oDialogView:End()
   endif

   if !empty( ::oValidator )
      ::oValidator:End()
   endif

   if !empty( ::oAjustableController )
      ::oAjustableController:End()
   end if 

   if !empty( ::oRolesController )
      ::oRolesController:End()
   end if 

   if !empty( ::oCamposExtraValoresController )
      ::oCamposExtraValoresController:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD editConfig() CLASS UsuariosController

   if !( ::loadConfig() )
      RETURN ( nil )
   end if 

   if ::getAjustableGestoolController():DialogViewActivate()
      ::saveConfig()
   end if 
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadConfig() CLASS UsuariosController

   ::cUuidUsuario                := ::getRowSet():fieldGet( 'uuid' )

   if empty( ::cUuidUsuario )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD saveConfig() CLASS UsuariosController

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startingActivate() CLASS UsuariosController

   local oPanel               := ::getAjustableGestoolController():getDialogView():oExplorerBar:AddPanel( "Propiedades usuario", nil, 1 ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changeComboEmpresa() CLASS UsuariosController

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD checkSuperUser() CLASS UsuariosController

   local hUsuario

   hUsuario       := ::getModel():getWhere( "super_user", "=", 1 )

   if !hb_ishash( hUsuario )
      msgStop( "No se ha definido super usuario" )
      RETURN ( .f. )
   end if 

   if !empty( hget( hUsuario, "password" ) )
      RETURN ( .f. )
   end if 

   ::Edit( hget( hUsuario, "id" ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLUsuariosModel FROM SQLBaseModel

   DATA cTableName                        INIT "usuarios"

   DATA cConstraints                      INIT "PRIMARY KEY ( codigo, deleted_at ), KEY ( id ), KEY ( uuid )"

   METHOD getColumns()

   METHOD insertIgnoreSuperAdmin()

   METHOD Crypt( cPassword )              INLINE ( hb_crypt( alltrim( cPassword ), __encryption_key__ ) )
   METHOD Decrypt( cPassword )            INLINE ( hb_decrypt( alltrim( cPassword ), __encryption_key__ ) )

   METHOD getNombreWhereCodigo( cCodigo ) INLINE ( ::getField( 'nombre', 'codigo', cCodigo ) )
   METHOD getNombreWhereUuid( uuid )      INLINE ( ::getField( 'nombre', 'uuid', uuid ) )

   METHOD validUserPassword( cNombre, cPassword )
   METHOD validSuperUserPassword( cPassword )

   METHOD fetchDirect() 

   METHOD getNombreUsuarioWhereNetName( cNetName ) 

   METHOD isPasswordExclude( cPassword )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUsuariosModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"          ,;
                                                   "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",                  {  "create"    => "VARCHAR ( 20 )"                          ,;
                                                   "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR ( 100 ) NOT NULL UNIQUE"         ,;
                                                   "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "password",                {  "create"    => "VARCHAR ( 100 )"                         ,;
                                                   "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "remember_token",          {  "create"    => "VARCHAR ( 100 )"                         ,;
                                                   "default"   => {|| "" } }                                )

   hset( ::hColumns, "super_user",              {  "create"    => "TINYINT ( 1 )"                           ,;
                                                   "default"   => {|| "0" } }                               )

   hset( ::hColumns, "rol_uuid",                {  "create"    => "VARCHAR ( 40 )"                           ,;
                                                   "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "email",                   {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                                   "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "email_password",          {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                                   "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "email_servidor",          {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                                   "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "email_puerto",            {  "create"    => "INT ( 5 ) NOT NULL"                      ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "autenticacion_smtp",      {  "create"    => "TINYINT ( 1 )"                           ,;
                                                   "default"   => {|| "0" } }                               )

   hset( ::hColumns, "requiere_ssl",            {  "create"    => "TINYINT ( 1 )"                           ,;
                                                   "default"   => {|| "0" } }                               )

   hset( ::hColumns, "email_enviar_copia",      {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                                   "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "email_copia_oculta",      {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                                   "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "sistema",                 {  "create"    => "TINYINT ( 1 )"                           ,;
                                                   "default"   => {|| "0" } }                               )

   ::getTimeStampColumns() 

   ::getDeletedStampColumn()  

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD insertIgnoreSuperAdmin() CLASS SQLUsuariosModel
                                 
   ::insertIgnoreBlankBuffer( {  "codigo"       => '999',;
                                 "nombre"       => __admin_name__,;
                                 "password"     => ::Crypt( __admin_password__ ),;
                                 "super_user"   => '1',;
                                 "rol_uuid"     => SQLRolesModel():getFieldWhere( "uuid", { "nombre" => __admin_name__ } ),;
                                 "sistema"      => '1' } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validUserPassword( cNombre, cPassword ) CLASS SQLUsuariosModel

   local cSQL  

   cSQL        := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE nombre = " + quoted( cNombre )                    + " "    

   if !( ::isPasswordExclude( cPassword ) )
      cSQL     +=     "AND password = " + quoted( ::Crypt( cPassword ) )      + " " 
   end if

   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD validSuperUserPassword( cPassword ) CLASS SQLUsuariosModel

   local cSQL  := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE super_user = 1"                                   + " "

   if !( ::isPasswordExclude( cPassword ) )
      cSQL     +=     "AND password = " + quoted( ::Crypt( cPassword ) )      + " " 
   end if

   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD fetchDirect() CLASS SQLUsuariosModel

   local cSQL  := "SELECT * FROM " + ::getTableName()

RETURN ( ::getDatabase():Query( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getNombreUsuarioWhereNetName( cNetName ) CLASS SQLUsuariosModel

   local cSQL  := "SELECT usuarios.nombre FROM " + ::getTableName() + " AS usuarios"         + " "   
   cSQL        +=    "INNER JOIN " + SQLAjustableModel():getTableName() + " AS ajustables"   + " "
   cSQL        +=       "ON usuarios.uuid = ajustables.ajustable_uuid"                       + " "
   cSQL        +=    "WHERE ajustables.ajuste_valor = " + quoted( cNetName )                 + " "    
   cSQL        +=       "AND ajustables.ajustable_tipo = 'usuarios'"

RETURN ( ::getDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//

METHOD isPasswordExclude( cPassword ) CLASS SQLUsuariosModel

   if ( "NOPASSWORD" $ appParamsMain() .or. "NOPASSWORD" $ appParamsSecond() )
      RETURN ( .t. )
   end if 
                                    
RETURN ( alltrim( cPassword ) == __encryption_key__ )

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

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Estado'
      :nWidth              := 180
      :bStrData            := {|| if( isUserActive( ::getRowSet():fieldGet( 'uuid' ) ), "En uso", "" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :Cargo               := .t.
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
      :cHeader             := 'Rol Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'rol_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'email'
      :cHeader             := 'Email'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'email' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'email_servidor'
      :cHeader             := 'Servidor de correo'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'email_servidor' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'email_puerto'
      :cHeader             := 'Puerto'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'email_puerto' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'autenticacion_smtp'
      :cHeader             := 'Autencitación SMTP'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'autenticacion_smtp' ) == 1 }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'requiere_ssl'
      :cHeader             := 'Requiere SSL'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'requiere_ssl' ) == 1 }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'email_enviar_copia'
      :cHeader             := 'Enviar copia a'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'email_enviar_copia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'email_copia_oculta'
      :cHeader             := 'Enviar copia oculta a'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'email_copia_oculta' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnsCreatedUpdatedAt()

   ::getColumnDeletedAt()

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
   DATA oGetEmailPassword
   DATA cGetEmailPassword     INIT space( 100 )

   DATA oSayCamposExtra  

   DATA oComboRol 
   DATA cComboRol   
   DATA aComboRoles           

   METHOD Activating()

   METHOD Activate()

   METHOD Activated()
   
END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS UsuariosView

   ::cGetPassword          := space( 100 )

   ::cGetRepeatPassword    := space( 100 )

   ::cGetEmailPassword     := space( 100 )

   ::cComboRol             := ::oController:getRolesController():getModel():getFieldWhere( "nombre", { "uuid" => ::getModelBuffer( "rol_uuid" ) }, , "" )
   ::cComboRol             := alltrim( ::cComboRol )
   
   ::aComboRoles           := ::oController:getRolesController():getModel():getColumn( "nombre" ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activated() CLASS UsuariosView

   ::setModelBuffer( "rol_uuid", ::oController:getRolesController():getModel():getFieldWhere( "uuid", { "nombre" => alltrim( ::cComboRol ) } ) )

   if !empty( ::cGetPassword )
      ::setModelBuffer( "password", ::getModel():Crypt( ::cGetPassword ) )
   end if 

   if !empty( ::cGetEmailPassword )
      ::setModelBuffer( "email_password", ::getModel():Crypt( ::cGetEmailPassword ) )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UsuariosView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "USUARIO" ;
      TITLE       ::lblTitle() + "usuario" 

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oGetPassword ;
      VAR         ::cGetPassword ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog
   
   ::oGetPassword:bValid         := {|| ::oController:validate( "password", ::cGetPassword ) }

   REDEFINE GET   ::oGetRepeatPassword ;
      VAR         ::cGetRepeatPassword ;
      ID          121 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   ::oGetRepeatPassword:bValid   := {|| ::oController:validate( "repeatPassword", ::cGetRepeatPassword ) }

   REDEFINE COMBOBOX ::oComboRol ;
      VAR         ::cComboRol ;
      ID          130 ;
      ITEMS       ::aComboRoles ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   //Email---------------------------------------------------------------------

   REDEFINE GET   ::getModel():hBuffer[ "email" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "email" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oGetEmailPassword ;
      VAR         ::cGetEmailPassword ; 
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getModel():hBuffer[ "email_servidor" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "email_puerto" ] ;
      ID          170;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE SAYCHECKBOX ::oController:getModel():hBuffer[ "autenticacion_smtp" ] ;
      ID          180 ;
      IDSAY       182 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE SAYCHECKBOX ::oController:getModel():hBuffer[ "requiere_ssl" ] ;
      ID          190 ;
      IDSAY       192 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getModel():hBuffer[ "email_enviar_copia" ] ;
      ID          200 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "email_enviar_copia" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::getModel():hBuffer[ "email_copia_oculta" ] ;
      ID          210 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "email_copia_oculta" ) ) ;
      OF          ::oDialog

   // Campos extra-------------------------------------------------------------

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          220 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:onClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }      

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::closeActivate(), ) }

   ::oDialog:Activate( , , , .t. )

RETURN ( ::oDialog:nResult )

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

   ::hValidators  := {  "codigo" =>             {  "required"        => "El código es un dato requerido",;
                                                   "unique"          => "El código ya existe" },; 
                        "nombre" =>             {  "required"        => "El nombre es un dato requerido",;
                                                   "unique"          => "El nombre ya existe" },; 
                        "email" =>              {  "mail"            => "El email no es valido" },;
                        "email_enviar_copia" => {  "mail"            => "El email para enviar la copia no es valido" },;
                        "email_copia_oculta" => {  "mail"            => "El email para enviar la copia oculta no es valido" },;
                        "password" =>           {  "password"        => "- Contraseña debe de tener al menos ocho caracteres y un máximo de dieciseis" + CRLF + ;
                                                                        "- No puede contener espacios"  },;
                        "repeatPassword" =>     {  "repeatPassword"  => "Las contraseñas no coinciden" } }

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

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

