#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosTipoController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ArticulosTipoController

   ::Super:New()

   ::cTitle                         := "Tipos de artículo"

   ::cName                          := "articulos_tipo"

   ::hImage                         := {  "16" => "gc_objects_16",;
                                          "32" => "gc_objects_32",;
                                          "48" => "gc_objects_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLArticulosTipoModel():New( self )

   ::oBrowseView                    := ArticulosTipoBrowseView():New( self )

   ::oDialogView                    := ArticulosTipoView():New( self )

   ::oValidator                     := ArticulosTipoValidator():New( self, ::oDialogView )

   ::oRepository                    := ArticulosTipoRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS ArticulosTipoController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTipoBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosTipoBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .f.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
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
//---------------------------------------------------------------------------//

CLASS ArticulosTipoView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosTipoView

   local oDialog
   local oBtnEdit
   local oBtnAppend
   local oBtnDelete
   local oBmpGeneral

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ARTICULO_TIPO" ;
      TITLE       ::LblTitle() + "tipo de artículo"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_objects_48" ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION     ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTipoValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosTipoValidator


   ::hValidators  := {  "nombre" =>                {  "required"           => "La descripción es un dato requerido",;
                                                      "unique"             => "La descripción introducida ya existe" },;
                        "codigo" =>                {  "required"           => "El código es un dato requerido" ,;
                                                      "unique"             => "EL código introducido ya existe"  ,;
                                                      "onlyAlphanumeric"   => "EL código no puede contener caracteres especiales" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosTipoModel FROM SQLBaseModel

   DATA cTableName               INIT "articulos_tipo"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosTipoModel

   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                    "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",     {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                    "default"   => {|| win_uuidcreatestring() } }            )
   ::getEmpresaColumns()

   hset( ::hColumns, "codigo",   {  "create"    => "VARCHAR( 3 )"                            ,;
                                    "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "nombre",   {  "create"    => "VARCHAR( 200 )"                          ,;
                                    "default"   => {|| space( 200 ) } }                       )
   
   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTipoRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosTipoModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
