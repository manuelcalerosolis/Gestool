#include "FiveWin.Ch"
#include "Factu.ch" 

#define  __encryption_key__ "snorlax"

//---------------------------------------------------------------------------//

CLASS RolesController FROM SQLNavigatorController

   DATA oAjustableController 

   DATA oPermisosController

   DATA cUuidRol

   DATA lMostrarRentabilidad        AS LOGIC INIT .t.
   DATA lCambiarPrecios             AS LOGIC INIT .t.
   DATA lVerPreciosCosto            AS LOGIC INIT .t.
   DATA lConfirmacionEliminacion    AS LOGIC INIT .t.
   DATA lFiltrarVentas              AS LOGIC INIT .t.
   DATA lAbrirCajonPortamonedas     AS LOGIC INIT .t.
   DATA lAlbaranEntregado           AS LOGIC INIT .t.
   DATA lAsistenteGenerarFacturas   AS LOGIC INIT .t.
   DATA lCambiarEstado              AS LOGIC INIT .t.
   DATA lCambiarCampos              AS LOGIC INIT .t.

   METHOD New()

   METHOD End()

   METHOD setConfig()

   METHOD loadConfig()

   METHOD saveConfig()

   METHOD startingActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS RolesController

   ::Super:New()

   ::cTitle                := "Roles"

   ::setName( "Roles" )

   ::lTransactional        := .t.

   ::lConfig               := .t.

   ::hImage                := { "16" => "GC_ID_CARDS_16" }

   ::oModel                := SQLRolesModel():New( self )

   ::oRepository           := RolesRepository():New( self )

   ::oBrowseView           := RolesBrowseView():New( self )

   ::oDialogView           := RolesView():New( self )

   ::oValidator            := RolesValidator():New( self )

   ::oPermisosController   := PermisosController():New( self )

   ::oAjustableController  := AjustableController():New( self )

   ::oFilterController:setTableToFilter( ::getName() )

   ::setEvent( 'openingDialog',  {|| ::oDialogView:openingDialog() } )  
   ::setEvent( 'closedDialog',   {|| ::oDialogView:closedDialog() } )  

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oModel )
      ::oModel:End()
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

   ::Super:End()

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

   ::cUuidRol                    := ::getRowSet():fieldGet( 'uuid' )

   if empty( ::cUuidRol )
      RETURN ( .f. )
   end if 

   ::lMostrarRentabilidad        := ::oAjustableController:oModel:getRolMostrarRentabilidad( ::cUuidRol )

   ::lCambiarPrecios             := ::oAjustableController:oModel:getRolCambiarPrecios( ::cUuidRol )

   ::lVerPreciosCosto            := ::oAjustableController:oModel:getRolVerPreciosCosto( ::cUuidRol )

   ::lConfirmacionEliminacion    := ::oAjustableController:oModel:getRolConfirmacionEliminacion( ::cUuidRol )

   ::lFiltrarVentas              := ::oAjustableController:oModel:getRolFiltrarVentas( ::cUuidRol )

   ::lAbrirCajonPortamonedas     := ::oAjustableController:oModel:getRolAbrirCajonPortamonedas( ::cUuidRol )

   ::lAlbaranEntregado           := ::oAjustableController:oModel:getRolAlbaranEntregado( ::cUuidRol )

   ::lAsistenteGenerarFacturas   := ::oAjustableController:oModel:GetRolAsistenteGenerarFacturas( ::cUuidRol )

   ::lCambiarEstado              := ::oAjustableController:oModel:GetRolCambiarEstado( ::cUuidRol )

   ::lCambiarCampos              := ::oAjustableController:oModel:GetRolCambiarCampos( ::cUuidRol )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD saveConfig()

   ::oAjustableController:oModel:setRolMostrarRentabilidad( ::lMostrarRentabilidad, ::cUuidRol )

   ::oAjustableController:oModel:setRolCambiarPrecios( ::lCambiarPrecios, ::cUuidRol )

   ::oAjustableController:oModel:setRolVerPreciosCosto( ::lVerPreciosCosto, ::cUuidRol )

   ::oAjustableController:oModel:setRolConfirmacionEliminacion( ::lConfirmacionEliminacion, ::cUuidRol )

   ::oAjustableController:oModel:setRolFiltrarVentas( ::lFiltrarVentas, ::cUuidRol )

   ::oAjustableController:oModel:setRolAbrirCajonPortamonedas( ::lAbrirCajonPortamonedas, ::cUuidRol )

   ::oAjustableController:oModel:setRolAlbaranEntregado( ::lAlbaranEntregado, ::cUuidRol )

   ::oAjustableController:oModel:SetRolAsistenteGenerarFacturas( ::lAsistenteGenerarFacturas, ::cUuidRol )

   ::oAjustableController:oModel:SetRolCambiarEstado( ::lCambiarEstado, ::cUuidRol )

   ::oAjustableController:oModel:SetRolCambiarCampos( ::lCambiarCampos, ::cUuidRol )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD startingActivate()

   local oPanel            := ::oAjustableController:oDialogView:oExplorerBar:AddPanel( "Propiedades roles", nil, 1 ) 
   
   oPanel:addCheckBox( "Mostrar rentabilidad", @::lMostrarRentabilidad )

   oPanel:addCheckBox( "Cambiar precios", @::lCambiarPrecios )

   oPanel:addCheckBox( "Ver precios de costo", @::lVerPreciosCosto )

   oPanel:addCheckBox( "Confirmar eliminación", @::lConfirmacionEliminacion )

   oPanel:addCheckBox( "Filtrar ventas por usuario", @::lFiltrarVentas )

   oPanel:addCheckBox( "Abrir cajón portamonedas", @::lAbrirCajonPortamonedas )

   oPanel:addCheckBox( "Estado albarán entregado", @::lAlbaranEntregado )

   oPanel:addCheckBox( "Asistente generar facturas", @::lAsistenteGenerarFacturas )

   oPanel:addCheckBox( "Cambiar estado", @::lCambiarEstado )
   
   oPanel:addCheckBox( "Cambiar campos", @::lCambiarCampos )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRolesModel FROM SQLBaseModel

   DATA cTableName               INIT "Roles"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

   METHOD getInsertRolesSentence()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLRolesModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR ( 100 ) NOT NULL UNIQUE"         ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "permiso_uuid",   {  "create"    => "VARCHAR( 40 )"                           ,;
                                          "default"   => {|| space( 40 ) } }                       )

   ::getTimeStampColumns()   

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInsertRolesSentence()

   local cStatement 

   cStatement  := "INSERT IGNORE INTO " + ::cTableName + " "
   cStatement  +=    "( uuid, nombre ) "
   cStatement  += "VALUES "
   cStatement  +=    "( UUID(), 'Super administrador' ), "
   cStatement  +=    "( UUID(), 'Administrador' ), "
   cStatement  +=    "( UUID(), 'Usuario' )"

RETURN ( cStatement )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RolesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS RolesBrowseView

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
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
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

CLASS RolesView FROM SQLBaseView

   DATA cComboPermiso      
   DATA aComboPermisos     

   METHOD openingDialog() 

   METHOD closedDialog() 

   METHOD Activate()
   
   METHOD Save( oDlg )

END CLASS

//---------------------------------------------------------------------------//

METHOD openingDialog() CLASS RolesView

   ::cComboPermiso      := ::oController:oPermisosController:oRepository:getNombre( ::getModel():getBuffer( "permiso_uuid" ) )
   ::aComboPermisos     := ::oController:oPermisosController:oRepository:getNombres()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD closedDialog() CLASS RolesView

   ::getModel():setBuffer( "permiso_uuid", ::oController:oPermisosController:oRepository:getUuid( ::cComboPermiso ) )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS RolesView

   local oDlg
   local oBmpGeneral

   DEFINE DIALOG  oDlg ;
      RESOURCE    "ROL" ;
      TITLE       ::lblTitle() + "Rol" 

   REDEFINE BITMAP oBmpGeneral ;
      ID          900 ;
      RESOURCE    "GC_ID_CARDS_48" ;
      TRANSPARENT ;
      OF          oDlg

   REDEFINE GET   ::getModel():hBuffer[ "id" ] ;
      ID          100 ;
      WHEN        ( .f. ) ;
      OF          oDlg

   REDEFINE GET   ::getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDlg

   REDEFINE COMBOBOX ::cComboPermiso ;
      ID          120 ;
      ITEMS       ::aComboPermisos ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          oDlg

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( ::Save( oDlg ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ::Save( oDlg ) } )

   oDlg:Activate( , , , .t. )

   oBmpGeneral:end()

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//

METHOD Save( oDlg )

   if !( validateDialog( oDlg ) )
      RETURN ( .f. )
   end if 

   oDlg:end( IDOK )

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RolesValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS RolesValidator

   ::hValidators  := {  "nombre" => {  "required"  => "El nombre es un dato requerido",;
                                       "unique"    => "El nombre ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RolesRepository FROM SQLBaseRepository

   METHOD getTableName()               INLINE ( SQLRolesModel():getTableName() ) 

   METHOD getNombres() 

   METHOD getNombre( uuid )            INLINE ( SQLRolesModel():getColumnWhereUuid( uuid, 'nombre' ) ) 

   METHOD getUuid( nombre )
   METHOD getUuidWhereNombre( nombre ) INLINE ( ::getUuid( nombre ) ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS RolesRepository

   local cSentence            := "SELECT nombre FROM " + ::getTableName()

RETURN ( ::getDatabase():selectFetchArrayOneColumn( cSentence ) )

//---------------------------------------------------------------------------//

METHOD getUuid( cNombre ) CLASS RolesRepository

   local cSentence            := "SELECT uuid FROM " + ::getTableName() + " " + ;
                                    "WHERE nombre = " + quoted( cNombre )

RETURN ( ::getDatabase():getValue( cSentence ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
