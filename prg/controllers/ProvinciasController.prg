#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ProvinciasController FROM SQLNavigatorController


   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ProvinciasController

   ::Super:New()

   ::cTitle                   := "Provincias"

   ::cName                    := "provincias"

   ::hImage                   := {  "16" => "gc_flag_spain_16",;
                                    "32" => "gc_flag_spain_32",;
                                    "48" => "gc_flag_spain_48" }

   ::nLevel                   := Auth():Level( ::cName )

   ::oModel                   := SQLProvinciasModel():New( self )

   ::oBrowseView              := ProvinciasBrowseView():New( self )

   ::oDialogView              := ProvinciasView():New( self )

   ::oValidator               := ProvinciasValidator():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ProvinciasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ProvinciasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'provincia'
      :cHeader             := 'Provincia'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'provincia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ProvinciasView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ProvinciasView

   local oDlg
   local oBmpGeneral
   local oBtnEdit
   local oBtnAppend
   local oBtnDelete

   DEFINE DIALOG  oDlg ;
      RESOURCE    "PROVINCIA" ;
      TITLE       ::LblTitle() + "provincia"

   REDEFINE BITMAP oBmpGeneral ;
      ID          900 ;
      RESOURCE    "gc_flag_spain_48" ;
      TRANSPARENT ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "provincia" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "provincia" ) ) ;
      OF          oDlg

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( oDlg ), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   if ::oController:isNotZoomMode() 
      oDlg:AddFastKey( VK_F5, {|| if( validateDialog( oDlg ), oDlg:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

   oBmpGeneral:end()

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ProvinciasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ProvinciasValidator

   ::hValidators  := {     "codigo"    =>       {  "required"     => "El código es un dato requerido",;
                                                   "unique"       => "El código introducido ya existe" },;
                           "provincia" =>       {  "required"     => "La provincia es un datos requerido",;
                                                   "unique"       => "La provincia introducida ya existe" } }                      


RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLProvinciasModel FROM SQLBaseModel

   DATA cTableName               INIT "provincias"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLProvinciasModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "text"      => "Identificador"                           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 10 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| space( 10 ) } }                       )

   hset( ::hColumns, "provincia",         {  "create"    => "VARCHAR( 50 )"                          ,;
                                             "default"   => {|| space( 50 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ProvinciasRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLProvinciasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//