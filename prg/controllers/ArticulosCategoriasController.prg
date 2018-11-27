#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosCategoriasController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := ArticulosCategoriasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := ArticulosCategoriasView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := ArticulosCategoriasValidator():New( self ), ), ::oValidator )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := ArticulosCategoriasRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLArticulosCategoriasModel():New( self ), ), ::oModel )
   
   METHOD getName()                    INLINE ( "articulos_categorias" )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosCategoriasController

   ::Super:New( oController )

   ::cTitle                         := "Articulos categorias"

   ::hImage                         := {  "16" => "gc_photographic_filters_16",;
                                          "32" => "gc_photographic_filters_32",;
                                          "48" => "gc_photographic_filters_48" }

   ::nLevel                         := Auth():Level( ::getName() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosCategoriasController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
   ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
   ::oDialogView:End()
   end if

   if !empty( ::oValidator )
   ::oValidator:End()
   end if

   if !empty( ::oRepository )
   ::oRepository:End()
   end if

RETURN ( ::Super:End() )

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

   ::getColumnIdAndUuid()

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

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'icono'
      :cHeader             := 'Icono'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'icono' ) }
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
      FONT        oFontBold() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:getModel():hBuffer[ "icono" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ITEMS       ( hgetkeys( ::hTipos ) ) ;
      BITMAPS     ( hgetvalues( ::hTipos ) ) ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          130 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
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

CLASS ArticulosCategoriasValidator FROM SQLBaseValidator

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

   DATA cConstraints             INIT "PRIMARY KEY ( codigo, deleted_at )"

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

   ::getDeletedStampColumn()

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
