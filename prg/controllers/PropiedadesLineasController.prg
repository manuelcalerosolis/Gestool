#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PropiedadesLineasController FROM SQLBrowseController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD isNotColorProperty()   INLINE ( !::oController:isColorProperty() )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := PropiedadesLineasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := PropiedadesLineasView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := PropiedadesLineasValidator():New( self ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := PropiedadesLineasRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel := SQLPropiedadesLineasModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PropiedadesLineasController

   ::Super:New( oController )

   ::cTitle                      := "Propiedades lineas"

   ::cName                       := "articulos_propiedades_lineas"

   ::getModel()

   //::getModel():setEvent( 'gettingSelectSentence',  {|| ::getModel():gettingSelectSentence() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS PropiedadesLineasController
   
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

   ::getColumnIdAndUuid()

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
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "orden" ] ;
      ID          120 ;
      SPINNER     ;
      MIN         0 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo_barras" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oColorRGB ;
      VAR         ::oController:getModel():hBuffer[ "color_rgb" ] ;
      ID          140 ;
      IDSAY       141 ;
      BITMAP      "gc_photographic_filters_16" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog 

   ::oColorRGB:setColor( ::oController:getModel():hBuffer[ "color_rgb" ], ::oController:getModel():hBuffer[ "color_rgb" ] )
   ::oColorRGB:bHelp := {|| ::changeColorRGB() }

   // Botones PropiedadesLineas -------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
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
                                          "unique"    => "El nombre introducido ya existe" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPropiedadesLineasModel FROM SQLCompanyModel

   DATA cTableName               INIT "articulos_propiedades_lineas"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPropiedadesLineasModel
   
   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"           ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",    {  "create"    => "VARCHAR ( 40 )"                           ,;
                                          "default"   => {|| ::getControllerParentUuid() } } )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR ( 200 )"                          ,;
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

