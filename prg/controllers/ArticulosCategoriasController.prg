#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosCategoriasController FROM SQLNavigatorController

   DATA oCamposExtraValoresController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS ArticulosCategoriasController

   ::Super:New( oSenderController )

   ::cTitle                      := "Articulos categorias"

   ::cName                       := "articulos_categorias"

   ::hImage                      := {  "16" => "gc_photographic_filters_16",;
                                       "32" => "gc_photographic_filters_32",;
                                       "48" => "gc_photographic_filters_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLArticulosCategoriasModel():New( self )

   ::oBrowseView                 := ArticulosCategoriasBrowseView():New( self )

   ::oDialogView                 := ArticulosCategoriasView():New( self )

   ::oValidator                  := ArticulosCategoriasValidator():New( self, ::oDialogView )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, ::oModel:cTableName )

   ::oRepository                 := ArticulosCategoriasRepository():New( self )

   ::oGetSelector                := GetSelector():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS ArticulosCategoriasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oCamposExtraValoresController:End()

   ::oGetSelector:End()

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

CLASS ArticulosCategoriasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosCategoriasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
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
      :nWidth              := 50
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

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'icono'
      :cHeader             := 'Icono'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'icono' ) }
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

CLASS ArticulosCategoriasView FROM SQLBaseView

   DATA oSayCamposExtra
  
   DATA oTipo

   DATA hTipos

   METHOD New()

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosCategoriasView

   ::Super:New( oController )

   ::hTipos          := {  "Círculo azul"          => "bullet_ball_glass_blue_16",;
                           "Círculo verde"         => "bullet_ball_glass_green_16",;
                           "Cículo rojo"           => "bullet_ball_glass_red_16",;
                           "Cículo amarillo"       => "bullet_ball_glass_yellow_16",;
                           "Cuadrado azul"         => "bullet_square_blue_16",;
                           "Cuadrado verde"        => "bullet_square_green_16",;
                           "Cuadrado rojo"         => "bullet_square_red_16",;
                           "Cuadrado amarillo"     => "bullet_square_yellow_16",;
                           "Triángulo azul"        => "bullet_triangle_blue_16",;
                           "Triángulo verde"       => "bullet_triangle_green_16",;
                           "Triángulo rojo"        => "bullet_triangle_red_16",;
                           "Triángulo amarillo"    => "bullet_triangle_yellow_16" }

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosCategoriasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ARTICULO_CATEGORIA" ;
      TITLE       ::LblTitle() + "categoria de articulos"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:oModel:hBuffer[ "icono" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ITEMS       ( hgetkeys( ::hTipos ) ) ;
      BITMAPS     ( hgetvalues( ::hTipos ) ) ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        getBoldFont() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          130 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }

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

CLASS ArticulosCategoriasValidator FROM SQLCompanyValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosCategoriasValidator

   ::hValidators  := {  "nombre " =>               {  "required"           => "El nombre es un dato requerido",;
                                                      "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>                {  "required"           => "El código es un dato requerido" ,;
                                                      "unique"             => "EL código introducido ya existe"  ,;
                                                      "onlyAlphanumeric"   => "EL código no puede contener caracteres especiales" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosCategoriasModel FROM SQLCompanyModel

   DATA cTableName               INIT "articulos_categorias"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosCategoriasModel

   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                    "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",     {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                    "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",   {  "create"    => "VARCHAR( 20 )"                            ,;
                                    "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "nombre",   {  "create"    => "VARCHAR( 200 )"                          ,;
                                    "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "icono",    {  "create"    => "VARCHAR( 40 )"                           ,;
                                    "default"   => {|| space( 40 ) } }                       )
   
   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosCategoriasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosCategoriasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
