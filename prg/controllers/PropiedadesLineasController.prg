#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PropiedadesLineasController FROM SQLBrowseController

   METHOD New()

   METHOD End()

   METHOD isNotColorProperty()   INLINE ( !::oSenderController:isColorProperty() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PropiedadesLineasController

   ::Super:New( oController )

   ::cTitle                      := "Propiedades lineas"

   ::cName                       := "articulos_propiedades_lineas"

   ::oModel                      := SQLPropiedadesLineasModel():New( self )

   ::oBrowseView                 := PropiedadesLineasBrowseView():New( self )

   ::oDialogView                 := PropiedadesLineasView():New( self )

   ::oValidator                  := PropiedadesLineasValidator():New( self, ::oDialogView )

   ::oRepository                 := PropiedadesLineasRepository():New( self )

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::oModel:gettingSelectSentence() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS PropiedadesLineasController

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

CLASS PropiedadesLineasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS PropiedadesLineasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 60
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
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
      :cSortOrder          := 'orden'
      :cHeader             := 'Orden'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'orden' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :cEditPicture        := "9999"
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PropiedadesLineasView FROM SQLBaseView

   DATA oColorRGB
  
   METHOD Activate()

   METHOD startActivate()

   METHOD changeColorRGB() 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS PropiedadesLineasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "PROPIEDADES_LINEAS" ;
      TITLE       ::LblTitle() + "lineas de propiedades"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_coathanger_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Lineas de propiedades" ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNN" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "orden" ] ;
      ID          120 ;
      SPINNER     ;
      MIN         0 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo_barras" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oColorRGB ;
      VAR         ::oController:oModel:hBuffer[ "color_rgb" ] ;
      ID          140 ;
      IDSAY       141 ;
      BITMAP      "gc_photographic_filters_16" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog 

   ::oColorRGB:setColor( ::oController:oModel:hBuffer[ "color_rgb" ], ::oController:oModel:hBuffer[ "color_rgb" ] )
   ::oColorRGB:bHelp := {|| ::changeColorRGB() }

   // Botones PropiedadesLineas -------------------------------------------------------

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD changeColorRGB() CLASS PropiedadesLineasView

   local nColorRGB   := ChooseColor()

   if !empty( nColorRGB )
      ::oColorRGB:setColor( nColorRGB, nColorRGB )
      ::oColorRGB:cText( nColorRGB )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS PropiedadesLineasView

   if ::oController:isNotColorProperty()
      ::oColorRGB:Hide()
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PropiedadesLineasValidator FROM SQLParentValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS PropiedadesLineasValidator

   ::hValidators  := {  "nombre" =>    {  "required"  => "El nombre es un dato requerido",;
                                          "unique"    => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"  => "El código es un dato requerido" ,;
                                          "unique"    => "El código introducido ya existe" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPropiedadesLineasModel FROM SQLBaseModel

   DATA cTableName               INIT "articulos_propiedades_lineas"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPropiedadesLineasModel
   
   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",    {  "create"    => "VARCHAR( 40 )"                           ,;
                                          "default"   => {|| ::getSenderControllerParentUuid() } } )

   hset( ::hColumns, "codigo",         {  "create"    => "VARCHAR( 4 )"                            ,;
                                          "default"   => {|| space( 4 ) } }                        )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR( 200 )"                          ,;
                                          "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "orden",          {  "create"    => "SMALLINT UNSIGNED"                       ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "codigo_barras",  {  "create"    => "VARCHAR( 4 )"                            ,;
                                          "default"   => {|| space( 4 ) } }                        )

   hset( ::hColumns, "color_rgb",      {  "create"    => "INT UNSIGNED"                            ,;
                                          "default"   => {|| rgb( 255, 255, 255 ) } }              )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PropiedadesLineasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLPropiedadesLineasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

