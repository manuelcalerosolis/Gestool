#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RutasController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construccion tardia-------------------------------------------------------

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := RutasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := RutasView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( iif( empty( ::oValidator ), ::oValidator := RutasValidator():New( self ), ), ::oValidator )

   METHOD getRepository()              INLINE ( iif( empty( ::oRepository ), ::oRepository := RutasRepository():New( self ), ), ::oRepository )

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLRutasModel():New( self ), ), ::oModel )

   METHOD getRange()                   INLINE ( iif( empty( ::oRange ), ::oRange := RutasItemRange():New( self ), ), ::oRange )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS RutasController

   ::Super:New( oController )

   ::cTitle                         := "Rutas"

   ::cName                          := "rutas"

   ::hImage                         := {  "16" => "gc_map_route_16",;
                                          "32" => "gc_map_route_32",;
                                          "48" => "gc_map_route_48" }

   ::nLevel                         := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS RutasController
   
   iif( !empty( ::oModel ), ::oModel:End(), )

   iif( !empty( ::oBrowseView ), ::oBrowseView:End(), )

   iif( !empty( ::oDialogView ), ::oDialogView:End(), )

   iif( !empty( ::oValidator ), ::oValidator:End(), )

   iif( !empty( ::oRepository ), ::oRepository:End(), )
   
   iif( !empty( ::oRange ), ::oRange:End(), )

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RutasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS RutasBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 120
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

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RutasView FROM SQLBaseView

   DATA oSayCamposExtra
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS RutasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "RUTAS" ;
      TITLE       ::LblTitle() + "ruta"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:GetImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          120 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::closeActivate(), ) }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RutasValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS RutasValidator

   ::hValidators  := {  "nombre" =>    {  "required"  => "La ruta es un dato requerido",;
                                          "unique"    => "La ruta introducida ya existe" },;
                        "codigo" =>    {  "required"  => "El código es un dato requerido" ,;
                                          "unique"    => "EL código introducido ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRutasModel FROM SQLCompanyModel

   DATA cTableName                     INIT "rutas"

   DATA cConstraints                   INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   #ifdef __TEST__

   METHOD test_create_ruta_principal()

   METHOD test_create_ruta_alternativa()

   #endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLRutasModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                          "text"      => "Identificador"                           ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"          ,;                                 
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",         {  "create"    => "VARCHAR ( 20 )"                          ,;
                                          "text"      => "Código"                                  ,;
                                          "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR ( 200 )"                         ,;
                                          "text"      => "Nombre"                                  ,;
                                          "default"   => {|| space( 200 ) } }                      )

   ::getDeletedStampColumn()
   
RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RutasItemRange FROM ItemRange

   DATA cKey                           INIT 'ruta_codigo'

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RutasRepository FROM SQLBaseRepository

   METHOD getTableName()               INLINE ( SQLRutasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//

#ifdef __TEST__

//---------------------------------------------------------------------------//

METHOD test_create_ruta_principal( cCodigo ) CLASS SQLRutasModel

RETURN   (  ::insertBuffer( ;
               ::loadBlankBuffer( { "codigo"       => '0',;
                                    "nombre"       => 'Ruta principal' } ) ) )

//---------------------------------------------------------------------------//

METHOD test_create_ruta_alternativa( cCodigo ) CLASS SQLRutasModel

RETURN   (  ::insertBuffer( ;
               ::loadBlankBuffer( { "codigo"       => '1',;
                                    "nombre"       => 'Ruta alternativa' } ) ) )

//---------------------------------------------------------------------------//

#endif

