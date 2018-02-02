#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasController FROM SQLNavigatorController

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TiposImpresorasController

   ::Super:New()

   ::cTitle                := "Tipos de impresoras"

   ::cName                 := "tipos_impresoras"

   ::hImage                := { "16" => "gc_printer2_16" }

   ::nLevel                := nLevelUsr( "01115" )

   ::oModel                := SQLTiposImpresorasModel():New( self )

   ::oBrowseView           := TiposImpresorasBrowseView():New( self )

   ::oDialogView           := TiposImpresorasView():New( self )

   ::oValidator            := TiposImpresorasValidator():New( self )

   ::oFilterController:setTableToFilter( ::oModel:getTableName() )

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TiposImpresorasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS TiposImpresorasBrowseView

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
//---------------------------------------------------------------------------//

CLASS SQLTiposImpresorasModel FROM SQLBaseModel

   DATA cColumnCode              INIT "nombre"

   DATA cTableName               INIT "tipos_impresoras"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTiposImpresorasModel

   hset( ::hColumns, "id",          {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                       "text"      => "Identificador"                           ,;
                                       "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "nombre",      {  "create"    => "VCHAR ( 50 )"                            ,;
                                       "default"   => {|| space( 50 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TiposImpresorasView FROM SQLBaseView

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TiposImpresorasView

   local oDlg
   local oBtnOk
   local oGetNombre

   DEFINE DIALOG oDlg RESOURCE "TIPO_GENERAL" TITLE ::lblTitle() + "tipo de impresora"

   REDEFINE GET   oGetNombre ;
      VAR         ::oController:oModel:hBuffer[ "nombre" ] ; 
      ID          100 ;
      MEMO ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDlg

   REDEFINE BUTTON oBtnOk ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   // Teclas rpidas-----------------------------------------------------------

   if ::oController:isNotZoomMode() 
      oDlg:AddFastKey( VK_F5, {|| if( validateDialog( oDlg ), oBtnOk:Click(), ) } )
   end if 

   // evento bstart-----------------------------------------------------------

   oDlg:bStart    := {|| oGetNombre:setFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TiposImpresorasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TiposImpresorasValidator

   ::hValidators  := { "nombre" =>  {  "required"  => "El nombre de la impresora es un dato requerido",;
                                       "unique"    => "El nombre de la impresora ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TiposImpresorasRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( if( !empty( ::getController() ), ::getModelTableName(), SQLTiposImpresorasModel():getTableName() ) )

   METHOD getNombres()

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS TiposImpresorasRepository 

   local cSentence               := "SELECT nombre FROM " + ::getTableName()
   local aNombresImpresoras      := ::getDatabase():selectFetchArrayOneColumn( cSentence )

   ains( aNombresImpresoras, 1, "", .t. )

RETURN ( aNombresImpresoras )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
