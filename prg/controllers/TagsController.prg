#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TagsController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TagsController

   ::Super:New()

   ::cTitle                := "Marcadores"

   ::cName                 := "tags"

   ::lTransactional        := .t.

   ::hImage                := { "16" => "gc_bookmarks_16" }

   ::nLevel                := nLevelUsr( "01101" )

   ::oModel                := SQLTagsModel():New( self )

   ::oRepository           := TagsRepository():New( self )

   ::oBrowseView           := TagsBrowseView():New( self )

   ::oDialogView           := TagsView():New( self )

   ::oValidator            := TagsValidator():New( self )

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

CLASS TagsBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS TagsBrowseView

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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLTagsModel FROM SQLBaseModel

   DATA cTableName               INIT "Tags"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTagsModel

   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                    "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",     {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                    "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "empresa",  {  "create"    => "CHAR ( 4 ) NOT NULL"                     ,;
                                    "default"   => {|| cCodEmp() } }                         )

   hset( ::hColumns, "nombre",   {  "create"    => "VARCHAR( 50 )"                          ,;
                                    "default"   => {|| space( 50 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TagsView FROM SQLBaseView

   DATA oEditControl

   DATA cEditControl 

   METHOD Activate()
   
   METHOD createEditControl( hControl )
      METHOD selectorEditControl()
      METHOD assertEditControl()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TagsView

   local oDlg
   local oBtnOk
   local oGetNombre

   DEFINE DIALOG oDlg RESOURCE "MARCADOR" TITLE ::lblTitle() + "marcador"

   REDEFINE GET   oGetNombre ;
      VAR         ::getModel():hBuffer[ "nombre" ] ;
      ID          100 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDlg

   REDEFINE BUTTON oBtnOk ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( !::oController:isZoomMode() ) ;   
      ACTION      ( if( validateDialog( oDlg ), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//

METHOD createEditControl( hControl, uValue ) CLASS TagsView

   local oError

   if !hhaskey( hControl, "idGet" )    .or.  ;
      !hhaskey( hControl, "idSay" )    .or.  ;
      !hhaskey( hControl, "idText" )   .or.  ;
      !hhaskey( hControl, "dialog" )   .or.  ;
      !hhaskey( hControl, "when" )
      RETURN ( Self )
   end if 

   if hb_isnil( uValue )
      RETURN ( Self )
   end if 

   try 

      REDEFINE GET   ::oEditControl ;
         VAR         uValue ;
         BITMAP      "Lupa" ;
         ID          ( hGet( hControl, "idGet" ) ) ;
         IDSAY       ( hGet( hControl, "idSay" ) ) ;
         IDTEXT      ( hGet( hControl, "idText" ) ) ;
         OF          ( hGet( hControl, "dialog" ) )

      ::oEditControl:bWhen    := hGet( hControl, "when" ) 
      ::oEditControl:bHelp    := {|| ::selectorEditControl() }
      ::oEditControl:bValid   := {|| ::assertEditControl() }

      ::oEditControl:oHelpText:cText( ::getController():getRepository():getColumnWhereId( uValue ) )

   catch oError

      msgStop( "Imposible crear el control de marcadores." + CRLF + ErrorMessage( oError ) )

   end

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD selectorEditControl() CLASS TagsView

   local hBuffer     := ::oController:activateSelectorView()

   if !empty( hBuffer )
      ::oEditControl:cText( hget( hBuffer, "id" ) )
      ::oEditControl:oHelpText:cText( hget( hBuffer, "nombre" ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD assertEditControl() CLASS TagsView

   local uValue      := ::oEditControl:VarGet()
   local lAssert     := ::oController:assert( "id", uValue )

   if lAssert 
      ::oEditControl:oHelpText:cText( ::getController():getRepository():getColumnWhereId( uValue ) )
   end if 

RETURN ( lAssert )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TagsValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD getAsserts()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TagsValidator

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre es un dato requerido",;
                                       "unique"       => "El nombre ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD getAsserts() CLASS TagsValidator

   ::hAsserts     := {  "id"     => {  "emptyOrExist" => "El identificador no existe" },;
                        "nombre" => {  "emptyOrExist" => "El nombre no existe" } } 

RETURN ( ::hAsserts )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TagsRepository FROM SQLBaseRepository

   METHOD getTableName()      INLINE ( SQLTagsModel():getTableName() ) 

   METHOD getUuidWhereName( cTag )

END CLASS

//---------------------------------------------------------------------------//

METHOD getUuidWhereName( cTag ) CLASS TagsRepository 

   local cSql     := "SELECT uuid FROM " + ::getTableName()          + " " + ;
                        "WHERE nombre = " + quoted( cTag )           + " " + ;
                        "LIMIT 1"

RETURN ( ::getDatabase():getValue( cSql ) ) 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
