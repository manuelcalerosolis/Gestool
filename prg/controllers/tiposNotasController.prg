#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TiposNotasController FROM SQLNavigatorController

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TiposNotasController

   ::Super:New()

   ::cTitle                := "Tipos de notas"

   ::cName                 := "tipos_impresoras"

   ::hImage                := { "16" => "gc_folder2_16" }

   ::nLevel                := nLevelUsr( "01101" )

   ::oModel                := SQLTiposNotasModel():New( self )

   ::oRepository           := TiposNotasRepository():New( self )

   ::oBrowseView           := TiposNotasBrowseView():New( self )

   ::oDialogView           := TiposNotasView():New( self )

   ::oValidator            := TiposNotasValidator():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TiposNotasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS TiposNotasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
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

CLASS SQLTiposNotasModel FROM SQLBaseModel

   DATA cColumnCode             INIT "nombre"

   DATA cTableName              INIT "tipos_notas"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTiposNotasModel

   hset( ::hColumns, "id",          {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"          ,;
                                       "text"      => "Identificador"                          ,;
                                       "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "nombre",      {  "create"    => "VARCHAR( 50 )"                          ,;
                                       "default"   => {|| space( 50 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


CLASS TiposNotasRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( iif(  !empty( ::getController() ),;
                                                ::getModelTableName(),;
                                                SQLTiposNotasModel():getTableName() ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TiposNotasView FROM SQLBaseView

   DATA oEditControl

   DATA cEditControl 

   METHOD Activate()
   
   METHOD createEditControl( hControl )
      METHOD selectorEditControl()
      METHOD assertEditControl()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TiposNotasView

   local oDlg
   local oBtnOk
   local oGetCodigo
   local oGetNombre

   DEFINE DIALOG oDlg RESOURCE "TIPO_GENERAL" TITLE ::lblTitle() + "tipo de nota"

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

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD createEditControl( hControl, uValue ) CLASS TiposNotasView

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

      msgStop( "Imposible crear el control de tipos de ventas." + CRLF + ErrorMessage( oError ) )

   end

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD selectorEditControl() CLASS TiposNotasView

   local hBuffer     := ::oController:activateSelectorView()

   if !empty( hBuffer )
      ::oEditControl:cText( hget( hBuffer, "id" ) )
      ::oEditControl:oHelpText:cText( hget( hBuffer, "nombre" ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD assertEditControl() CLASS TiposNotasView

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

CLASS TiposNotasValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD getAsserts()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TiposNotasValidator

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la nota es un dato requerido",;
                                       "unique"       => "El nombre de la nota ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD getAsserts() CLASS TiposNotasValidator

   ::hAsserts     := {  "id"     => {  "emptyOrExist" => "El identificador de la nota no existe" },;
                        "nombre" => {  "emptyOrExist" => "El nombre de la nota no existe" } } 

RETURN ( ::hAsserts )

//---------------------------------------------------------------------------//
