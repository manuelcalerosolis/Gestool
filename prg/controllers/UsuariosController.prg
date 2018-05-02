#include "FiveWin.Ch"
#include "Factu.ch" 

#define  __encryption_key__ "snorlax"
#define  __admin_password__ "superusuario"

//---------------------------------------------------------------------------//

CLASS UsuariosController FROM SQLNavigatorController
   
   DATA oAjustableController 

   DATA oRolesController

   DATA cUuidUsuario

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

   DATA oLoginView
   DATA oLoginTactilView

   DATA cValidError        INIT ""  

   METHOD New()
   METHOD End()

   METHOD isLogin()

   METHOD isTactilLogin()

   METHOD setConfig()

   METHOD loadConfig()

   METHOD saveConfig()

   METHOD startingActivate()

   METHOD changeComboEmpresa()

   METHOD validUserPassword()

   METHOD checkSuperUser()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS UsuariosController

   ::Super:New()

   ::cTitle                := "Usuarios"

   ::setName( "usuarios" )

   ::lTransactional        := .t.

   ::lConfig               := .t.

   ::hImage                := { "16" => "gc_businesspeople_16" }

   ::oModel                := SQLUsuariosModel():New( self )

   ::oRepository           := UsuariosRepository():New( self )

   ::oBrowseView           := UsuariosBrowseView():New( self )

   ::oDialogView           := UsuariosView():New( self )

   ::oValidator            := UsuariosValidator():New( self, ::oDialogView )

   ::oLoginView            := UsuariosLoginView():New( self )

   ::oLoginTactilView      := UsuariosLoginTactilView():New( self )

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

   ::cUuidUsuario                := ::getRowSet():fieldGet( 'uuid' )

   if empty( ::cUuidUsuario )
      RETURN ( .f. )
   end if 

   ::aEmpresas                   := EmpresasModel():aNombresSeleccionables()
   ::cCodigoEmpresaExclusiva     := ::oAjustableController:oModel:getUsuarioEmpresaExclusiva( ::cUuidUsuario )
   ::cNombreEmpresaExclusiva     := EmpresasModel():getNombreFromCodigo( ::cCodigoEmpresaExclusiva )

   ::aCajas                      := CajasModel():aNombresSeleccionables()
   ::cUuidCajaExclusiva          := ::oAjustableController:oModel:getUsuarioCajaExclusiva( ::cUuidUsuario )
   ::cNombreCajaExclusiva        := CajasModel():getNombreFromUuid( ::cUuidCajaExclusiva )

   ::aAlmacenes                  := AlmacenesModel():aNombresSeleccionables()
   ::cUuidAlmacenExclusivo       := ::oAjustableController:oModel:getUsuarioAlmacenExclusivo( ::cUuidUsuario )
   ::cNombreAlmacenExclusivo     := AlmacenesModel():getNombreFromUuid( ::cUuidAlmacenExclusivo )

   ::aDelegaciones               := DelegacionesModel():aNombresSeleccionables()
   ::cUuidDelegacionExclusiva    := ::oAjustableController:oModel:getUsuarioDelegacionExclusiva( ::cUuidUsuario )
   ::cNombreDelegacionExclusiva  := DelegacionesModel():getNombreFromUuid( ::cUuidDelegacionExclusiva )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD saveConfig()

   ::cCodigoEmpresaExclusiva     := EmpresasModel():getCodigoFromNombre( ::cNombreEmpresaExclusiva )
   ::cUuidCajaExclusiva          := CajasModel():getUuidFromNombre( ::cNombreCajaExclusiva )
   ::cUuidAlmacenExclusivo       := AlmacenesModel():getUuidFromNombre( ::cNombreAlmacenExclusivo )
   ::cUuidDelegacionExclusiva    := DelegacionesModel():getUuidFromNombre( ::cNombreDelegacionExclusiva )

   ::oAjustableController:oModel:setUsuarioEmpresaExclusiva( ::cCodigoEmpresaExclusiva, ::cUuidUsuario )
   ::oAjustableController:oModel:setUsuarioCajaExclusiva( ::cUuidCajaExclusiva, ::cUuidUsuario )
   ::oAjustableController:oModel:setUsuarioAlmacenExclusivo( ::cUuidAlmacenExclusivo, ::cUuidUsuario )
   ::oAjustableController:oModel:setUsuarioDelegacionExclusiva( ::cUuidDelegacionExclusiva, ::cUuidUsuario )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD startingActivate()

   local oPanel               := ::oAjustableController:oDialogView:oExplorerBar:AddPanel( "Propiedades usuario", nil, 1 ) 

   ::oComboEmpresa            := oPanel:addComboBox( "Empresa exclusiva", @::cNombreEmpresaExclusiva, ::aEmpresas )
   ::oComboEmpresa:bChange    := {|| ::changeComboEmpresa() }

   ::oComboDelegacion         := oPanel:addComboBox( "Delegación exclusiva", @::cNombreDelegacionExclusiva, ::aDelegaciones )

   ::oComboCaja               := oPanel:addComboBox( "Caja exclusiva", @::cNombreCajaExclusiva, ::aCajas )

   ::oComboAlmacen            := oPanel:addComboBox( "Almacén exclusivo", @::cNombreAlmacenExclusivo, ::aAlmacenes )

   ::changeComboEmpresa()
      
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD changeComboEmpresa()

   iif(  empty( ::cNombreEmpresaExclusiva ),;
         ( ::oComboDelegacion:Disable(), ::oComboDelegacion:Set( "" ) ),;
         ::oComboDelegacion:Enable() )
   
   iif(  empty( ::cNombreEmpresaExclusiva ),;
         ( ::oComboCaja:Disable(), ::oComboCaja:Set( "" ) ),;
         ::oComboCaja:Enable() )
   
   iif(  empty( ::cNombreEmpresaExclusiva ),;
         ( ::oComboAlmacen:Disable(), ::oComboAlmacen:Set( "" ) ),;
         ::oComboAlmacen:Enable() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD validUserPassword( cUsuario, cPassword )

   local hUsuario

   hUsuario                   := ::oRepository:validUserPassword( cUsuario, cPassword )

   if empty( hUsuario )
      ::cValidError           := "Usuario y contraseña con coinciden" 
      RETURN ( .f. )
   end if 

   if setUserActive( hget( hUsuario, "uuid" ) )
      ::cValidError           := "Usuario actualmente en uso"
      RETURN ( .f. )
   end if 

   Auth( hUsuario )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isLogin()

   if ( ::oLoginView:Activate() != IDOK )
      RETURN ( .f. )
   end if 

   ::oAjustableController:oModel:setUsuarioPcEnUso( rtrim( netname() ), Auth():uuid() )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isTactilLogin()

   if ( ::oLoginTactilView:Activate() != IDOK )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD checkSuperUser()

   local hUsuario

   hUsuario       := ::oModel:getWhere( "super_user = 1" )
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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLUsuariosModel FROM SQLBaseModel

   DATA cTableName                        INIT "usuarios"

   DATA cConstraints                      INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

   METHOD getInsertUsuariosSentence()

   METHOD Crypt( cPassword )              INLINE ( hb_crypt( alltrim( cPassword ), __encryption_key__ ) )
   METHOD Decrypt( cPassword )            INLINE ( hb_decrypt( alltrim( cPassword ), __encryption_key__ ) )

   METHOD getNombreWhereCodigo( cCodigo ) INLINE ( ::getField( 'nombre', 'codigo', cCodigo ) )
   METHOD getNombreWhereUuid( uuid )      INLINE ( ::getField( 'nombre', 'uuid', uuid ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUsuariosModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",         {  "create"    => "VARCHAR( 3 )"                            ,;
                                          "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR ( 100 ) NOT NULL UNIQUE"         ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "email",          {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "password",       {  "create"    => "VARCHAR ( 100 )"                         ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "remember_token", {  "create"    => "VARCHAR ( 100 )"                         ,;
                                          "default"   => {|| "" } }                                )

   hset( ::hColumns, "super_user",     {  "create"    => "TINYINT ( 1 )"                          ,;
                                          "default"   => {|| "0" } }                               )

   hset( ::hColumns, "rol_uuid",       {  "create"    => "VARCHAR( 40 )"                           ,;
                                          "default"   => {|| space( 40 ) } }                       )

   ::getTimeStampColumns()   

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInsertUsuariosSentence()

   local cSQL  
   local cUuidRol

   cUuidRol    := RolesRepository():getUuidWhereNombre( "Super administrador" )

   cSQL        := "INSERT IGNORE INTO " + ::cTableName + " "
   cSQL        += "( uuid, "
   cSQL        +=    "codigo, "
   cSQL        +=    "nombre, "
   cSQL        +=    "email, "
   cSQL        +=    "password, "
   cSQL        +=    "super_user, "
   cSQL        +=    "rol_uuid ) "
   cSQL        += "VALUES "
   cSQL        +=    "( UUID(), "
   cSQL        +=    "'999', "
   cSQL        +=    "'Super administrador', "
   cSQL        +=    "'', "
   cSQL        +=    "'', "
   cSQL        +=    "'1', "
   cSQL        +=    quoted( cUuidRol ) + " )"

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
      :cSortOrder          := 'email'
      :cHeader             := 'Email'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'email' ) }
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

   DATA lSuperUser            

   METHOD openingDialog()

   METHOD closedDialog()

   METHOD Activate()
   
   METHOD saveView( oDialog )

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

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "USUARIO" ;
      TITLE       ::lblTitle() + "usuario" 

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_businesspeople_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
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

   REDEFINE GET   ::getModel():hBuffer[ "email" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "email" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oGetPassword ;
      VAR         ::cGetPassword ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog
   
   ::oGetPassword:bValid         := {|| ::oController:validate( "password", ::cGetPassword ) }

   REDEFINE GET   ::oGetRepeatPassword ;
      VAR         ::cGetRepeatPassword ;
      ID          131 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   ::oGetRepeatPassword:bValid   := {|| ::oController:validate( "repeatPassword", ::cGetRepeatPassword ) }

   REDEFINE COMBOBOX ::oComboRol ;
      VAR         ::cComboRol ;
      ID          140 ;
      ITEMS       ::aComboRoles ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( ::saveView( ::oDialog ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   ::oDialog:AddFastKey( VK_F5, {|| ::saveView() } )

   ::oDialog:Activate( , , , .t. )

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD saveView()

   if !( validateDialog( ::oDialog ) )
      RETURN ( .f. )
   end if 

   if !empty( ::cGetPassword )
      ::getModel():setBuffer( "password", ::getModel():Crypt( ::cGetPassword ) )
   end if 

   ::oDialog:end( IDOK )

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

   if ::oController:isAppendMode() .or. empty( ::oController:getModel():hBuffer[ "password" ] )
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

   METHOD validSuperUserPassword( cPassword )

   METHOD fetchDirect()

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

METHOD validSuperUserPassword( cPassword ) CLASS UsuariosRepository

   local cSQL  := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE super_user = 1"                                   + " "    
   if ( alltrim( cPassword ) != __encryption_key__ ) 
      cSQL     +=       "AND password = " + quoted( ::Crypt( cPassword ) )    + " " 
   end if 
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

METHOD fetchDirect() CLASS UsuariosRepository

   local cSQL  := "SELECT * FROM " + ::getTableName()

RETURN ( ::getDatabase():Query( cSQL ) )

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

   DATA oSayError

   DATA oGetPassword
   DATA cGetPassword

   DATA oComboUsuario
   DATA cComboUsuario   
   DATA aComboUsuarios           

   METHOD Activate()
      METHOD onActivate()
      METHOD Validate()

   METHOD sayError( cError )  INLINE ( ::oSayError:setText( cError ), ::oSayError:Show(), dialogSayNo( ::oDialog ) )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD onActivate() CLASS UsuariosLoginView

   ::cGetPassword          := space( 100 )
   ::aComboUsuarios        := ::oController:oRepository:getNombres()
   ::cComboUsuario         := ::oController:oRepository:getNombreUsuarioWhereNetName( netname() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UsuariosLoginView 

   ::onActivate()

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "LOGIN" 

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gestool_logo" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oComboUsuario ;
      VAR         ::cComboUsuario ;
      ID          100 ;
      ITEMS       ::aComboUsuarios ;
      OF          ::oDialog

   REDEFINE GET   ::oGetPassword ;
      VAR         ::cGetPassword ;
      ID          110 ;
      OF          ::oDialog

   REDEFINE SAY   ::oSayError ;
      ID          120 ;
      COLOR       Rgb( 183, 28, 28 ) ;
      OF          ::oDialog

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      ACTION      ( ::Validate() )

   ::oDialog:AddFastKey( VK_F5, {|| ::Validate() } )

   ::oDialog:Activate( , , , .t. )

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD Validate()

   if ::oController:validUserPassword( ::cComboUsuario, ::cGetPassword )
      ::oDialog:end( IDOK ) 
   else     
      ::sayError( ::oController:cValidError )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UsuariosLoginTactilView FROM SQLBaseView

   DATA oSayError

   DATA oImageList

   DATA oListView

   METHOD Activate()
      METHOD startActivate()
      METHOD initActivate() 

   METHOD sayError( cError )  INLINE ( ::oSayError:setText( cError ), ::oSayError:Show(), dialogSayNo( ::oDialog ) )
   
   METHOD Validate( nOpt )

END CLASS

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS UsuariosLoginTactilView

   local oStatement

   oStatement  := UsuariosRepository():fetchDirect()
   if !empty( oStatement )
      while oStatement:fetchDirect()
         with object ( TListViewItem():New() )
            :Cargo   := oStatement:fieldget( "nombre" )
            :cText   := Capitalize( oStatement:fieldget( "nombre" ) )
            :nImage  := 0
            :nGroup  := 1
            :Create( ::oListView )
         end with
      end while
      oStatement:free()
   end if 

   ::oListView:Refresh()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD initActivate() CLASS UsuariosLoginTactilView

   ::oListView:SetImageList( ::oImageList )
   ::oListView:EnableGroupView()
   ::oListView:SetIconSpacing( 120, 140 )

   with object ( TListViewGroup():New() )
      :cHeader := "Usuarios"
      :Create( ::oListView )
   end with

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UsuariosLoginTactilView 

   ::oImageList   := TImageList():New( 50, 50 ) 

   ::oImageList:AddMasked( TBitmap():Define( "gc_businessman2_50" ),   Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "gc_user2_50" ),          Rgb( 255, 0, 255 ) )

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "LOGIN_TACTIL" 

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gestool_logo" ;
      TRANSPARENT ;
      OF          ::oDialog

   ::oListView          := TListView():Redefine( 100, ::oDialog )
   ::oListView:nOption  := 0
   ::oListView:bClick   := {| nOpt | ::Validate( nOpt ) }

   REDEFINE SAY   ::oSayError ;
      ID          120 ;
      COLOR       Rgb( 183, 28, 28 ) ;
      OF          ::oDialog

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      ACTION      ( ::oDialog:End( IDCANCEL ) )

   ::oDialog:bStart := {|| ::startActivate() }

   ::oDialog:Activate( , , , .t., , , {|| ::initActivate() } )

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD Validate( nOpt ) CLASS UsuariosLoginTactilView 

   local cUsuario    := ::oListView:GetItem( nOpt ):Cargo
   local cPassword   := VirtualKey( .t., , "Introduzca contraseña" )

   if ::oController:validUserPassword( cUsuario, cPassword )
      ::oDialog:End( IDOK )
   else
      ::sayError( ::oController:cValidError )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
