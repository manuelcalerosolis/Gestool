#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UsuariosController FROM SQLNavigatorController
   
   DATA oAjustableController 

   DATA oRolesController

   DATA cUuidUsuario

   DATA aCajas
   DATA cUuidCajaExclusiva
   DATA cNombreCajaExclusiva

   DATA aEmpresas
   DATA cUuidEmpresaExclusiva
   DATA cNombreEmpresaExclusiva

   METHOD New()

   METHOD End()

   METHOD setConfig()

   METHOD loadConfig()

   METHOD saveConfig()

   METHOD startingActivate()

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

   ::oValidator            := UsuariosValidator():New( self )

   ::oAjustableController  := AjustableController():New( self )

   ::oRolesController      := RolesController():New( self )

   ::oFilterController:setTableToFilter( ::getName() )

   ::setEvent( 'openingDialog', {|| ::oDialogView:openingDialog() } )  
   ::setEvent( 'closedDialog', {|| ::oDialogView:closedDialog() } )  

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

   if !empty( ::oAjustableController )
      ::oAjustableController:End()
   end if 

   if !empty( ::oRolesController )
      ::oRolesController:End()
   end if 

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

   ::cUuidUsuario             := ::getRowSet():fieldGet( 'uuid' )

   if empty( ::cUuidUsuario )
      RETURN ( .f. )
   end if 

   ::aEmpresas                := EmpresasModel():aNombresSeleccionables()
   ::cUuidEmpresaExclusiva    := ::oAjustableController:oModel:getUsuarioEmpresaExclusiva( ::cUuidUsuario )
   ::cNombreEmpresaExclusiva  := EmpresasModel():getNombreFromUuid( ::cUuidEmpresaExclusiva )
   
   ::aCajas                   := CajasModel():aNombresSeleccionables()
   ::cUuidCajaExclusiva       := ::oAjustableController:oModel:getUsuarioCajaExclusiva( ::cUuidUsuario )
   ::cNombreCajaExclusiva     := CajasModel():getNombreFromUuid( ::cUuidCajaExclusiva )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD saveConfig()

   ::cUuidEmpresaExclusiva    := EmpresasModel():getUuidFromNombre( ::cNombreEmpresaExclusiva )
   ::cUuidCajaExclusiva       := CajasModel():getUuidFromNombre( ::cNombreCajaExclusiva )
 
   ::oAjustableController:oModel:setUsuarioEmpresaExclusiva( ::cUuidEmpresaExclusiva, ::cUuidUsuario )
   ::oAjustableController:oModel:setUsuarioCajaExclusiva( ::cUuidCajaExclusiva, ::cUuidUsuario )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD startingActivate()

   local oPanel               := ::oAjustableController:oDialogView:oExplorerBar:AddPanel( "Propiedades usuario", nil, 1 ) 

   oPanel:addComboBox( "Empresa exclusiva", @::cNombreEmpresaExclusiva, ::aEmpresas )

   oPanel:addComboBox( "Caja exclusiva", @::cNombreCajaExclusiva, ::aCajas )
   
RETURN ( self )

//---------------------------------------------------------------------------//

CLASS SQLPermisosModel FROM SQLBaseModel

   DATA cTableName               INIT "Permisos"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPermisosModel

   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                    "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",     {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                    "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "rol_uuid", {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                    "default"   => {|| space( 40 ) } }            )

   hset( ::hColumns, "nombre",   {  "create"    => "VARCHAR ( 100 ) NOT NULL UNIQUE"         ,;
                                    "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "nivel",    {  "create"    => "TINYINT UNSIGNED"                        ,;
                                    "default"   => {|| 0 } }                                 )

   ::getTimeStampColumns()   

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PermisosRepository FROM SQLBaseRepository

   METHOD getTableName()      INLINE ( SQLPermisosModel():getTableName() ) 

   METHOD getNombres() 

   METHOD getNombre( uuid )   INLINE ( ::getColumnWhereUuid( uuid, 'nombre' ) ) 

   METHOD getUuid()

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS PermisosRepository

   local cSentence            := "SELECT nombre FROM " + ::getTableName()

RETURN ( ::getDatabase():selectFetchArrayOneColumn( cSentence ) )

//---------------------------------------------------------------------------//

METHOD getUuid( cNombre ) CLASS PermisosRepository

   local cSentence            := "SELECT uuid FROM " + ::getTableName() + " " + ;
                                    "WHERE nombre = " + quoted( cNombre )

RETURN ( ::getDatabase():getValue( cSentence ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
