#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PermisosController FROM SQLNavigatorController
   
   DATA cUuidRoles

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS PermisosController

   ::Super:New()

   ::cTitle                := "Permisos"

   ::setName( "Permisos" )

   ::lTransactional        := .t.

   ::lConfig               := .t.

   ::hImage                := { "16" => "gc_businesspeople_16" }

   ::nLevel                := nLevelUsr( "01052" )

   ::oModel                := SQLPermisosModel():New( self )

   ::oRepository           := PermisosRepository():New( self )

   ::oBrowseView           := PermisosBrowseView():New( self )

   ::oDialogView           := PermisosView():New( self )

   ::oValidator            := PermisosValidator():New( self )

   ::setEvent( 'openingDialog', {|| ::oDialogView:openingDialog() } )  
   ::setEvent( 'closedDialog', {|| ::oDialogView:closedDialog() } )  

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oModel )
      ::oModel:End()
   endif

   if !empty( ::oDialogView )
      ::oDialogView:End()
   endif

   ::Super:End()

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

   ::addTreeItems( oWndBar():aAccesos )
   
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addTreeItems( aAccesos )

   if empty( ::oTree )
      ::oTree  := TreeBegin()
   else
      TreeBegin()
   end if 

   aeval( aAccesos,;
      {|oAcceso|  ::addTreeItem( oAcceso ),;
                  iif(  len( oAcceso:aAccesos ) > 0,;
                        ::addTreeItems( oAcceso:aAccesos ), ) } )

   TreeEnd()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addTreeItem( oAcceso )

   local oItem    

   oItem          := TreeAddItem( oAcceso:cPrompt )
   oItem:Cargo    := { "Access" => .t., "Append" => .t., "Edit" => .t., "Zoom" => .t., "Delete" => .t., "Print" => .t.  }

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getTreeItem( cKey )

   default cKey := "Access"

   if !empty( ::oBrowse:oTreeItem )
      RETURN ( hget( ::oBrowse:oTreeItem:Cargo, cKey ) )
   endif 

RETURN ( "" )

//---------------------------------------------------------------------------//

METHOD setTreeItem( cKey, uValue )

   default cKey := "Access"

   if !empty( ::oBrowse:oTreeItem )

      if !empty( ::oBrowse:oTreeItem:oTree )
         msgalert( hb_valtoexp( ::oBrowse:oTreeItem:oTree ), "tiene nodos")
      end if 

      hset( ::oBrowse:oTreeItem:Cargo, cKey, uValue ) 
   endif 

RETURN ( uValue )

//---------------------------------------------------------------------------//

METHOD closedDialog() CLASS PermisosView

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS PermisosView

   local oDlg
   local oBtnOk
   local oBmpGeneral

   DEFINE DIALOG  oDlg ;
      RESOURCE    "PERMISOS" ;
      TITLE       ::lblTitle() + "permisos" 

   REDEFINE BITMAP oBmpGeneral ;
      ID          900 ;
      RESOURCE    "gc_businessman_48" ;
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

   ::oBrowse                  := IXBrowse():New( oDlg )

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
      ::oBrowse:aCols[ 1 ]:cHeader    := ""
      ::oBrowse:aCols[ 1 ]:nWidth     := 200
   end if 

   REDEFINE BUTTON oBtnOk ;
      ID          IDOK ;
      OF          oDlg ;
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

   oDlg:end( IDOK )

RETURN ( oDlg:nResult )

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

   ::hValidators  := {  "nombre" =>          {  "required"        => "El nombre es un dato requerido",;
                                                "unique"          => "El nombre ya existe" } }

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

   /*
   hset( ::hColumns, "nivel",    {  "create"    => "TINYINT UNSIGNED"                        ,;
                                    "default"   => {|| 0 } }                                 )
   */

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
