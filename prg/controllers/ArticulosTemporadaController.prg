#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosTemporadaController FROM SQLNavigatorController

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ArticulosTemporadaController

   ::Super:New()

   ::cTitle                      := "Articulos temporadas"

   ::cName                       := "articulos_temporadas"

   ::hImage                      := {  "16" => "gc_cloud_sun_16",;
                                       "32" => "gc_cloud_sun_32",;
                                       "48" => "gc_cloud_sun_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLArticulosTemporadaModel():New( self )

   ::oBrowseView                 := ArticulosTemporadaBrowseView():New( self )

   ::oDialogView                 := ArticulosTemporadaView():New( self )

   ::oValidator                  := ArticulosTemporadaValidator():New( self, ::oDialogView )

   ::oRepository                 := ArticulosTemporadaRepository():New( self )

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

CLASS ArticulosTemporadaBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosTemporadaBrowseView

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
      :cSortOrder          := 'imagen'
      :cHeader             := 'Imagen'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'imagen' ) }
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

CLASS ArticulosTemporadaView FROM SQLBaseView
  
   DATA oTipo

   DATA hTipos

   METHOD New()

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosTemporadaView

   ::Super:New( oController )

   ::hTipos          := {  "Sol"          => "gc_sun_16",;
                           "Sol y nubes"  => "gc_cloud_sun_16",;
                           "Nubes"        => "gc_cloud_16",;
                           "Lluvia"       => "gc_cloud_rain_16",;
                           "Nieve"        => "gc_snowflake_16" }

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosTemporadaView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ARTICULO_TEMPORADA" ;
      TITLE       ::LblTitle() + "temporada de articulos"

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

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:oModel:hBuffer[ "imagen" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ITEMS       ( hgetkeys( ::hTipos ) ) ;
      BITMAPS     ( hgetvalues( ::hTipos ) ) ;
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

CLASS ArticulosTemporadaValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosTemporadaValidator

   ::hValidators  := {  "nombre " =>               {  "required"     => "El nombre es un dato requerido",;
                                                      "unique"       => "El nombre introducido ya existe" },;
                        "codigo" =>                {  "required"     => "El código es un dato requerido" ,;
                                                      "unique"       => "EL código introducido ya existe"  } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosTemporadaModel FROM SQLBaseModel

   DATA cTableName               INIT "articulos_temporada"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosTemporadaModel

   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                    "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",     {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                    "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",   {  "create"    => "VARCHAR( 3 )"                            ,;
                                    "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "nombre",   {  "create"    => "VARCHAR( 200 )"                          ,;
                                    "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "imagen",   {  "create"    => "VARCHAR( 40 )"                           ,;
                                    "default"   => {|| space( 40 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTemporadaRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLComentariosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
