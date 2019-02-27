#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PermisosController FROM SQLNavigatorGestoolController
   
   DATA cUuidRoles

   DATA oOpcionesModel

   DATA oTree

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD loadOption()

   METHOD createTreeItems( aAccesos )

   METHOD createTreeNode()

   METHOD openingDialog()

   METHOD closedDialog()   

   METHOD saveDialog()

   METHOD saveOption()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := PermisosBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := PermisosView():New( self ), ), ::oDialogView )

   METHOD getRepository()              INLINE( if( empty( ::oRepository ), ::oRepository := PermisosRepository():New( self ), ), ::oRepository )

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := PermisosValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()                   INLINE( if( empty( ::oModel ), ::oModel := SQLPermisosModel():New( self ), ), ::oModel ) 

   METHOD getOpcionesModel()           INLINE( if( empty( ::oOpcionesModel ), ::oOpcionesModel := SQLPermisosOpcionesModel():New( self ), ), ::oOpcionesModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS PermisosController

   ::Super:New()

   ::cTitle                            := "Permisos"

   ::cName                             := "permisos"

   ::lTransactional                    := .t.

   ::hImage                            := {  "16" => "gc_id_badge_16",;
                                             "48" => "gc_id_badge_48" }

   ::setEvent( 'openingDialog', {|| ::openingDialog() } )

   ::setEvent( 'endDialog',  {|| ::closedDialog() } )

   ::setEvents( { 'appended', 'edited' }, {|| ::saveDialog() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS PermisosController

   if !empty( ::oModel )
      ::oModel:End()
   endif

   if !empty( ::oOpcionesModel )
      ::oOpcionesModel:End()
   endif

   if !empty( ::oDialogView )
      ::oDialogView:End()
   endif

   if !empty(::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oRepository )
      ::oRepository:End()
   end if 

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD openingDialog() CLASS PermisosController

   ::createTreeItems( ::getModelBuffer( "uuid" ) ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD closedDialog() CLASS PermisosController

   ::oTree:End()
   
   ::oTree        := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD saveDialog() CLASS PermisosController

RETURN ( ::oTree:eval( {|oItem| ::saveOption( ::getModelBuffer( "uuid" ), oItem ) } ) )

//---------------------------------------------------------------------------//

METHOD saveOption( cUuid, oItem ) CLASS PermisosController

   if empty( hget( oItem:Cargo, "Id" ) )
      RETURN ( nil )
   end if 

   ::getOpcionesModel():insertOnDuplicate( { "uuid"         => win_uuidcreatestring(),;
                                             "permiso_uuid" => cUuid,;
                                             "nombre"       => hget( oItem:Cargo, "Id" ),;
                                             "nivel"        => nPermiso( oItem:Cargo ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadOption( cUuid, cNombre ) CLASS PermisosController

RETURN ( ::getOpcionesModel():getFieldWhere( "nivel", { "permiso_uuid" => cUuid, "nombre" => cNombre }, nil, __permission_full__ ) )

//---------------------------------------------------------------------------//

METHOD createTreeItems( cUuid, aAccesos ) CLASS PermisosController 

   local oAcceso


   DEFAULT aAccesos  := CreateMainSQLAcceso():aAccesos

   if empty( ::oTree )
      ::oTree        := TreeBegin()
   else
      TreeBegin()
   end if 

   for each oAcceso in aAccesos

      ::createTreeNode( cUuid, oAcceso )

      if !empty( oAcceso ) .and. len( oAcceso:aAccesos ) > 0
         ::createTreeItems( cUuid, oAcceso:aAccesos )
      end if 

   next 

   TreeEnd()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createTreeNode( cUuid, oAcceso ) CLASS PermisosController 

   local hPermiso  

   if empty( oAcceso )
      RETURN ( nil )
   end if 

   if empty( oAcceso:cId )
      
      hPermiso    := hPermiso()

   else

      hPermiso    := hPermiso( oAcceso:cId, ::loadOption( cUuid, oAcceso:cId ) )
      
   end if 

   _TreeItem( oAcceso:cPrompt, , , , , .f., , hPermiso )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PermisosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS PermisosBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
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

CLASS PermisosView FROM SQLBaseView

   DATA oBrowse

   METHOD Activate()

   METHOD getTreeItem( cKey )   
   METHOD getTreeItemAccess()             INLINE ( ::getTreeItem( "Access" ) )
   METHOD getTreeItemAppend()             INLINE ( ::getTreeItem( "Append" ) )
   METHOD getTreeItemEdit()               INLINE ( ::getTreeItem( "Edit" ) )
   METHOD getTreeItemZoom()               INLINE ( ::getTreeItem( "Zoom" ) )
   METHOD getTreeItemDelete()             INLINE ( ::getTreeItem( "Delete" ) )
   METHOD getTreeItemPrint()              INLINE ( ::getTreeItem( "Print" ) )

   METHOD setTreeItem( cKey, uValue )
   METHOD setTreeItemAccess( uValue )     INLINE ( ::setTreeItem( "Access", uValue ) )
   METHOD setTreeItemAppend( uValue )     INLINE ( ::setTreeItem( "Append", uValue ) )
   METHOD setTreeItemEdit( uValue )       INLINE ( ::setTreeItem( "Edit", uValue ) )
   METHOD setTreeItemZoom( uValue )       INLINE ( ::setTreeItem( "Zoom", uValue ) )
   METHOD setTreeItemDelete( uValue )     INLINE ( ::setTreeItem( "Delete", uValue ) )
   METHOD setTreeItemPrint( uValue )      INLINE ( ::setTreeItem( "Print", uValue ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getTreeItem( cKey ) CLASS PermisosView 

   if !empty( ::oBrowse:oTreeItem )
      RETURN ( hget( ::oBrowse:oTreeItem:Cargo, cKey ) )
   endif 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD setTreeItem( cKey, uValue ) CLASS PermisosView 

   if empty( ::oBrowse:oTreeItem )
      RETURN ( uValue )
   end if 

   hset( ::oBrowse:oTreeItem:Cargo, cKey, uValue ) 
   
   if empty( ::oBrowse:oTreeItem:oTree )
      RETURN ( uValue )
   end if 

   if msgyesno( "¿Desea cambiar los valores de los nodos inferiores?", "Seleccione una opción" )
      ::oBrowse:oTreeItem:oTree:eval( {|oItem| hset( oItem:Cargo, cKey, uValue ) } )
   end if 

RETURN ( uValue )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS PermisosView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "PERMISOS" ;
      TITLE       ::lblTitle() + "permisos" 

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

   ::oBrowse                  := IXBrowse():New( ::oDialog )
   ::oBrowse:bWhen            := {|| ::oController:isNotZoomMode() }

   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrowse:lVScroll         := .t.
   ::oBrowse:lHScroll         := .f.
   ::oBrowse:nMarqueeStyle    := 5
   ::oBrowse:lRecordSelector  := .f.

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Acceso"
      :bStrData               := {|| "" }
      :bEditValue             := {|| ::getTreeItemAccess() }
      :nWidth                 := 60
      :SetCheck( { "Sel16", "Nil16" }, {|o, v| ::setTreeItemAccess( v ) } )
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Añadir"
      :bStrData               := {|| "" }
      :bEditValue             := {|| ::getTreeItemAppend() }
      :nWidth                 := 60
      :SetCheck( { "Sel16", "Nil16" }, {|o, v| ::setTreeItemAppend( v ) } )
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Modificar"
      :bStrData               := {|| "" }
      :bEditValue             := {|| ::getTreeItemEdit() }
      :nWidth                 := 60
      :SetCheck( { "Sel16", "Nil16" }, {|o, v| ::setTreeItemEdit( v ) } )
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Zoom"
      :bStrData               := {|| "" }
      :bEditValue             := {|| ::getTreeItemZoom() }
      :nWidth                 := 60
      :SetCheck( { "Sel16", "Nil16" }, {|o, v| ::setTreeItemZoom( v ) } )
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Eliminar"
      :bStrData               := {|| "" }
      :bEditValue             := {|| ::getTreeItemDelete() }
      :nWidth                 := 60
      :SetCheck( { "Sel16", "Nil16" }, {|o, v| ::setTreeItemDelete( v ) } )
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Imprimir"
      :bStrData               := {|| "" }
      :bEditValue             := {|| ::getTreeItemPrint() }
      :nWidth                 := 60
      :SetCheck( { "Sel16", "Nil16" }, {|o, v| ::setTreeItemPrint( v ) } )
   end with

   ::oBrowse:CreateFromResource( 120 )

   ::oBrowse:SetTree( ::oController:oTree, { "gc_navigate_minus_16", "gc_navigate_plus_16", "nil16" } ) 
   
   if len( ::oBrowse:aCols ) > 1
      ::oBrowse:aCols[ 1 ]:cHeader  := ""
      ::oBrowse:aCols[ 1 ]:nWidth   := 200
   end if 

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::closeActivate(), ) }

   ::oDialog:Activate( , , , .t. )

   ::oBrowse:End()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PermisosValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS PermisosValidator

   ::hValidators  := {  "nombre" => {  "required"  => "El nombre es un dato requerido",;
                                       "unique"    => "El nombre ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPermisosModel FROM SQLBaseModel

   DATA cTableName               INIT "Permisos"

   DATA cConstraints             INIT "PRIMARY KEY ( nombre, , KEY (uuid) ), KEY (id), KEY (uuid)"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPermisosModel

   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                    "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",     {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"          ,;
                                    "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",   {  "create"    => "VARCHAR ( 100 ) NOT NULL UNIQUE"         ,;
                                    "default"   => {|| space( 100 ) } }                      )

   ::getTimeStampColumns()

   ::getDeletedStampColumn()   

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PermisosRepository FROM SQLBaseRepository

   METHOD getTableName()               INLINE ( SQLPermisosModel():getTableName() ) 

   METHOD getNombres() 

   METHOD getNombre( uuid )            INLINE ( SQLPermisosModel():getColumnWhereUuid( uuid, 'nombre' ) ) 

   METHOD getUuid()

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS PermisosRepository

   local cSQL  := "SELECT nombre FROM " + ::getTableName()

RETURN ( ::getDatabase():selectFetchArrayOneColumn( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getUuid( cNombre ) CLASS PermisosRepository

   local cSQL  := "SELECT uuid FROM " + ::getTableName() + " " + ;
                     "WHERE nombre = " + quoted( cNombre )

RETURN ( ::getDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION nPermiso( hPermisos )

   local nPermiso    := 0

   if hget( hPermisos, "Access" )   ; nPermiso := nOr( nPermiso, __permission_access__ )  ; endif
   if hget( hPermisos, "Append" )   ; nPermiso := nOr( nPermiso, __permission_append__ )  ; endif
   if hget( hPermisos, "Edit" )     ; nPermiso := nOr( nPermiso, __permission_edit__ )    ; endif
   if hget( hPermisos, "Zoom" )     ; nPermiso := nOr( nPermiso, __permission_zoom__ )    ; endif
   if hget( hPermisos, "Delete" )   ; nPermiso := nOr( nPermiso, __permission_delete__ )  ; endif
   if hget( hPermisos, "Print" )    ; nPermiso := nOr( nPermiso, __permission_print__ )   ; endif

RETURN ( nPermiso )

//---------------------------------------------------------------------------//

FUNCTION hPermiso( cId, nPermiso )

   local hPermiso    := {=>}

   DEFAULT cId       := ""
   DEFAULT nPermiso  := __permission_full__ 

   hset( hPermiso, "Id",      cId )
   hset( hPermiso, "Access",  nAnd( nPermiso, __permission_access__  ) != 0 )
   hset( hPermiso, "Append",  nAnd( nPermiso, __permission_append__  ) != 0 )
   hset( hPermiso, "Edit",    nAnd( nPermiso, __permission_edit__    ) != 0 )
   hset( hPermiso, "Zoom",    nAnd( nPermiso, __permission_zoom__    ) != 0 )
   hset( hPermiso, "Delete",  nAnd( nPermiso, __permission_delete__  ) != 0 )
   hset( hPermiso, "Print",   nAnd( nPermiso, __permission_print__   ) != 0 )

RETURN ( hPermiso )

//---------------------------------------------------------------------------//
