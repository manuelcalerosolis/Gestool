#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PermisosController FROM SQLNavigatorGestoolController
   
   DATA cUuidRoles

   DATA oOpcionesModel

   METHOD New()

   METHOD End()

   METHOD saveOptions()
      METHOD saveOption()

   METHOD loadOption()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS PermisosController

   ::Super:New()

   ::cTitle                := "Permisos"

   ::cName                 := "permisos"

   ::lTransactional        := .t.

   ::hImage                := {  "16" => "gc_id_badge_16",;
                                 "48" => "gc_id_badge_48" }

   ::oModel                := SQLPermisosModel():New( self )
   
   ::oOpcionesModel        := SQLPermisosOpcionesModel():New( self )

   ::oRepository           := PermisosRepository():New( self )

   ::oBrowseView           := PermisosBrowseView():New( self )

   ::oDialogView           := PermisosView():New( self )

   ::oValidator            := PermisosValidator():New( self )

   ::setEvent( 'openingDialog',  {|| ::oDialogView:openingDialog() } ) 
    
   ::setEvent( 'closedDialog',   {|| ::oDialogView:closedDialog() } )  

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

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD saveOptions( cUuid, oTree ) CLASS PermisosController

   oTree:eval( {|oItem| iif( !empty( hget( oItem:Cargo, "Id" ) ), ::saveOption( cUuid, oItem ), ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD saveOption( cUuid, oTree ) CLASS PermisosController

   local hBuffer  := {=>}

   hset( hBuffer, "uuid",           win_uuidcreatestring() )
   hset( hBuffer, "permiso_uuid",   cUuid )
   hset( hBuffer, "nombre",         hget( oTree:Cargo, "Id" ) )
   hset( hBuffer, "nivel",          nPermiso( oTree:Cargo ) )

   ::oOpcionesModel:insertOnDuplicate( hBuffer )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadOption( cPermisoUuid, cNombre ) CLASS PermisosController

   local nPermiso

   nPermiso       := PermisosOpcionesRepository():getNivel( cPermisoUuid, cNombre )

   if hb_isnil( nPermiso )
      RETURN ( __permission_full__ )
   end if 

RETURN ( nPermiso )

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

CLASS PermisosView FROM SQLBaseView

   DATA oTree

   DATA oBrowse

   METHOD openingDialog()

   METHOD addTreeItems( aAccesos )
      METHOD addTreeItem( oAcceso )

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

   METHOD closedDialog()

   METHOD Activate()
   
   METHOD saveView( oDlg )

END CLASS

//---------------------------------------------------------------------------//

METHOD openingDialog() CLASS PermisosView

   local oAcceso  := CreateMainSQLAcceso()

   ::addTreeItems( oAcceso:aAccesos )
   
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addTreeItems( aAccesos ) CLASS PermisosView 

   if empty( ::oTree )
      ::oTree  := TreeBegin()
   else
      TreeBegin()
   end if 

   aeval( aAccesos,;
      {|oAcceso|  ::addTreeItem( oAcceso ),;
                  iif(  !empty( oAcceso ) .and. len( oAcceso:aAccesos ) > 0,;
                        ::addTreeItems( oAcceso:aAccesos ), ) } )

   TreeEnd()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addTreeItem( oAcceso ) CLASS PermisosView 

   local cUuid     
   local oItem  

   if empty( oAcceso )
      RETURN ( self )
   end if 

   cUuid          := ::getModel():hBuffer[ "uuid" ]  
   oItem          := treeAddItem( oAcceso:cPrompt )

   if empty( oAcceso:cId )
      oItem:Cargo := hPermiso()
   else
      oItem:Cargo := hPermiso( oAcceso:cId, ::oController:loadOption( cUuid, oAcceso:cId ) )
   end if 

RETURN ( self )

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
   
   if empty( ::oBrowse:oTreeItem:oTree )
      hset( ::oBrowse:oTreeItem:Cargo, cKey, uValue ) 
      RETURN ( uValue )
   end if 

   if msgyesno( "¿Desea cambiar los valores de los nodos inferiores?", "Seleccione una opción" )
      hset( ::oBrowse:oTreeItem:Cargo, cKey, uValue ) 
      ::oBrowse:oTreeItem:oTree:eval( {|oItem| hset( oItem:Cargo, cKey, uValue ) } )
   end if 

RETURN ( uValue )

//---------------------------------------------------------------------------//

METHOD closedDialog() CLASS PermisosView

   ::oController:saveOptions( ::getModel():hBuffer[ "uuid" ], ::oBrowse:oTree )

RETURN ( self )

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

   ::oBrowse:SetTree( ::oTree, { "gc_navigate_minus_16", "gc_navigate_plus_16", "nil16" } ) 
   
   if len( ::oBrowse:aCols ) > 1
      ::oBrowse:aCols[ 1 ]:cHeader  := ""
      ::oBrowse:aCols[ 1 ]:nWidth   := 200
   end if 

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( ::saveView() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   ::oDialog:AddFastKey( VK_F5, {|| ::saveView() } )

   ::oDialog:Activate( , , , .t. )

   ::oBrowse:End()

   ::oTree:End()

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD saveView() CLASS PermisosView 

   if !( validateDialog( ::oDialog ) )
      RETURN ( .f. )
   end if 

   ::oDialog:end( IDOK )

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

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPermisosModel

   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                    "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",     {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                    "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",   {  "create"    => "VARCHAR ( 100 ) NOT NULL UNIQUE"         ,;
                                    "default"   => {|| space( 100 ) } }                      )

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

   METHOD getNombre( uuid )   INLINE ( SQLPermisosModel():getColumnWhereUuid( uuid, 'nombre' ) ) 

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

