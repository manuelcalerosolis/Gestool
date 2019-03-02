#include "FiveWin.Ch"
#include "Factu.ch" 

#define __admin_name__  "Super administrador"

//---------------------------------------------------------------------------//

CLASS RolesController FROM SQLNavigatorGestoolController

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

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD editConfig()

   METHOD loadConfig()

   METHOD saveConfig()

   METHOD startingActivate()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()        INLINE( if( empty( ::oBrowseView ), ::oBrowseView := RolesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()        INLINE( if( empty( ::oDialogView ), ::oDialogView := RolesView():New( self ), ), ::oDialogView )

   METHOD getValidator()         INLINE( if( empty( ::oValidator ), ::oValidator := RolesValidator():New( self  ), ), ::oValidator ) 

   METHOD getRepository()        INLINE( if( empty( ::oRepository ), ::oRepository := RolesRepository():New( self  ), ), ::oRepository ) 
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLRolesModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS RolesController

   ::Super:New()

   ::cTitle                := "Roles"

   ::cName                 := "roles" 

   ::lTransactional        := .t.

   ::lConfig               := .t.

   ::hImage                := {  "16" => "gc_id_cards_16",;
                                 "48" => "gc_id_cards_48" }

   ::setEvent( 'openingDialog',  {|| ::getDialogView():openingDialog() } )  

   ::setEvent( 'closedDialog',   {|| ::getDialogView():closedDialog() } )  

   ::setEvents( { 'editing', 'deleting' }, {|| if( ::isRowSetSystemRegister(), ( msgStop( "Este registro pertenece al sistema, no se puede alterar." ), .f. ), .t. ) } )

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

   if !empty( ::oRepository )
      ::oRepository:End()
   endif

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD editConfig()

   if !( ::loadConfig() ) 
      RETURN ( nil )
   end if 

   if ::getAjustableGestoolController():DialogViewActivate()
      ::saveConfig()
   end if 
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadConfig()

   ::cUuidRol                    := ::getRowSet():fieldGet( 'uuid' )

   if empty( ::cUuidRol )
      RETURN ( .f. )
   end if 

   ::lMostrarRentabilidad        := ::getAjustableGestoolController():getModel():getRolMostrarRentabilidad( ::cUuidRol )

   ::lCambiarPrecios             := ::getAjustableGestoolController():getModel():getRolCambiarPrecios( ::cUuidRol )

   ::lVerPreciosCosto            := ::getAjustableGestoolController():getModel():getRolVerPreciosCosto( ::cUuidRol )

   ::lConfirmacionEliminacion    := ::getAjustableGestoolController():getModel():getRolConfirmacionEliminacion( ::cUuidRol )

   ::lFiltrarVentas              := ::getAjustableGestoolController():getModel():getRolFiltrarVentas( ::cUuidRol )

   ::lAbrirCajonPortamonedas     := ::getAjustableGestoolController():getModel():getRolAbrirCajonPortamonedas( ::cUuidRol )

   ::lAlbaranEntregado           := ::getAjustableGestoolController():getModel():getRolAlbaranEntregado( ::cUuidRol )

   ::lAsistenteGenerarFacturas   := ::getAjustableGestoolController():getModel():GetRolAsistenteGenerarFacturas( ::cUuidRol )

   ::lCambiarEstado              := ::getAjustableGestoolController():getModel():GetRolCambiarEstado( ::cUuidRol )

   ::lCambiarCampos              := ::getAjustableGestoolController():getModel():GetRolCambiarCampos( ::cUuidRol )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD saveConfig()

   with object ( ::getAjustableGestoolController():getModel() )

      :setRolMostrarRentabilidad( ::lMostrarRentabilidad, ::cUuidRol )

      :setRolCambiarPrecios( ::lCambiarPrecios, ::cUuidRol )

      :setRolVerPreciosCosto( ::lVerPreciosCosto, ::cUuidRol )

      :setRolConfirmacionEliminacion( ::lConfirmacionEliminacion, ::cUuidRol )

      :setRolFiltrarVentas( ::lFiltrarVentas, ::cUuidRol )

      :setRolAbrirCajonPortamonedas( ::lAbrirCajonPortamonedas, ::cUuidRol )

      :setRolAlbaranEntregado( ::lAlbaranEntregado, ::cUuidRol )

      :SetRolAsistenteGenerarFacturas( ::lAsistenteGenerarFacturas, ::cUuidRol )

      :SetRolCambiarEstado( ::lCambiarEstado, ::cUuidRol )

      :SetRolCambiarCampos( ::lCambiarCampos, ::cUuidRol )

   end with

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startingActivate()

   local oPanel            := ::getAjustableGestoolController():getDialogView():oExplorerBar:AddPanel( "Propiedades roles", nil, 1 ) 
   
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

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRolesModel FROM SQLBaseModel

   DATA cTableName               INIT "Roles"

   DATA cConstraints             INIT "PRIMARY KEY (nombre, deleted_at), KEY (id), KEY (uuid)"

   METHOD getColumns()

   METHOD insertIgnoreRoles()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLRolesModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"          ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR ( 100 ) NOT NULL UNIQUE"         ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "permiso_uuid",   {  "create"    => "VARCHAR ( 40 )"                          ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "sistema",        {  "create"    => "TINYINT ( 1 )"                           ,;
                                          "default"   => {|| "0" } }                               )

   ::getTimeStampColumns() 

   ::getDeletedStampColumn()  

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD insertIgnoreRoles() CLASS SQLRolesModel

   ::insertIgnoreBlankBuffer( {  "nombre"    => __admin_name__,;
                                 "sistema"   => '1' } )

   ::insertIgnoreBlankBuffer( {  "nombre"    => 'Administrador',;
                                 "sistema"   => '0' } )

   ::insertIgnoreBlankBuffer( {  "nombre"    => 'Usuario',;
                                 "sistema"   => '0' } )

RETURN ( nil )

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

   ::getColumnIdAndUuid()

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

   ::getColumnsCreatedUpdatedAt()

   ::getColumnDeletedAt()

RETURN ( nil )

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
   
END CLASS

//---------------------------------------------------------------------------//

METHOD openingDialog() CLASS RolesView

   ::cComboPermiso      := ::oController:getPermisosController():getRepository():getNombre( ::getModel():getBuffer( "permiso_uuid" ) )
   
   ::aComboPermisos     := ::oController:getPermisosController():getRepository():getNombres()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD closedDialog() CLASS RolesView

   ::getModel():setBuffer( "permiso_uuid", ::oController:getPermisosController():getRepository():getUuid( ::cComboPermiso ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS RolesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ROL" ;
      TITLE       ::lblTitle() + "Rol" 

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::getModel():hBuffer[ "id" ] ;
      ID          100 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog

   REDEFINE GET   ::getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::cComboPermiso ;
      ID          120 ;
      ITEMS       ::aComboPermisos ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

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

RETURN ( getSQLDatabase():selectFetchArrayOneColumn( cSentence ) )

//---------------------------------------------------------------------------//

METHOD getUuid( cNombre ) CLASS RolesRepository

   local cSentence            := "SELECT uuid FROM " + ::getTableName() + " " + ;
                                    "WHERE nombre = " + quoted( cNombre )

RETURN ( getSQLDatabase():getValue( cSentence ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
