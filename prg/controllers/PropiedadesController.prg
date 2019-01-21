#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PropiedadesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD isColorProperty()            INLINE ( iif( !empty(::getModel()) .and. !empty(::getModel():hBuffer), ::getModel():hBuffer[ "color" ], .f. ) )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := PropiedadesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := PropiedadesView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := PropiedadesValidator():New( self ), ), ::oValidator )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := PropiedadesRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLPropiedadesModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PropiedadesController

   ::Super:New( oController )

   ::cTitle                            := "Propiedades"

   ::cName                             := "articulos_propiedades"

   ::hImage                            := {  "16" => "gc_coathanger_16",;
                                             "32" => "gc_coathanger_32",;
                                             "48" => "gc_coathanger_48" }

   ::nLevel                            := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS PropiedadesController

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
//---------------------------------------------------------------------------//

CLASS PropiedadesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS PropiedadesBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 100
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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PropiedadesView FROM SQLBaseView

   DATA oSayCamposExtra

   DATA oGetTipo

   DATA oBtnLinesDeleted

   METHOD Activate()

   METHOD startActivate()

   METHOD setLinesShowDeleted()       INLINE ( ::getController():getPropiedadesLineasController():setShowDeleted(),;
                                                ::oBtnLinesDeleted:Toggle(),;
                                                ::oBtnLinesDeleted:cTooltip := if( ::oBtnLinesDeleted:lPressed, "Ocultar borrados", "Mostrar borrados" ) ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS PropiedadesView

   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "PROPIEDADES_MEDIUM" ;
      TITLE       ::LblTitle() + "propiedad"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_coathanger_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Propiedad" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE SAYCHECKBOX ::oController:getModel():hBuffer[ "color" ] ;
      ID          120 ;
      IDSAY       122 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   // Lineas de propiedades ---------------------------------------------------

   TBtnBmp():ReDefine( 601, "new16",,,,, {|| ::getController():getPropiedadesLineasController():Append() }, ::oDialog, .f., {|| ::getController():isNotZoomMode() }, .f., "Añadir línea" )

   TBtnBmp():ReDefine( 602, "edit16",,,,, {|| ::getController():getPropiedadesLineasController():Edit() }, ::oDialog, .f., {|| ::getController():isNotZoomMode() }, .f., "Modificar línea" )

   TBtnBmp():ReDefine( 603, "del16",,,,, {|| ::getController():getPropiedadesLineasController():Delete() }, ::oDialog, .f., , .f., "Eliminar línea" )
   
   // Browse de lineas --------------------------------------------------------

   ::oController:getPropiedadesLineasController():Activate( 160, ::oDialog )

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          170 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown            := <| nKey |  
      do case         
         case nKey == VK_F2 .and. ::oController:isNotZoomMode() 
            ::oController:getPropiedadesLineasController():Append()

         case nKey == VK_F3 .and. ::oController:isNotZoomMode() 
            ::oController:getPropiedadesLineasController():Edit()

         case nKey == VK_F4 .and. ::oController:isNotZoomMode() 
            ::oController:getPropiedadesLineasController():Delete()

         case nKey == VK_F5
            if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), )
      end 
      RETURN ( 0 )
      >

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PropiedadesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS PropiedadesValidator

   ::hValidators  := {  "nombre" =>    {  "required"           => "El nombre es un dato requerido",;
                                          "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"           => "El código es un dato requerido" ,;
                                          "unique"             => "El código introducido ya existe" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPropiedadesModel FROM SQLCompanyModel

   DATA cTableName               INIT "articulos_propiedades"

   DATA cConstraints             INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD getPropertyList()

#ifdef __TEST__   

   METHOD test_create_tallas() 

   METHOD test_create_colores()

   METHOD test_create_texturas()

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPropiedadesModel
   
   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                    "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",     {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                    "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",   {  "create"    => "VARCHAR( 20 )"                           ,;
                                    "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",   {  "create"    => "VARCHAR( 200 )"                          ,;
                                    "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "color",    {  "create"    => "TINYINT( 1 )"                            ,;
                                    "default"   => {|| 0 } }                                 )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getPropertyList() CLASS SQLPropiedadesModel

  local cSql

   TEXT INTO cSql

   SELECT 
      grupos.id AS grupo_id,
      grupos.uuid AS grupo_uuid,
      grupos.nombre AS grupo_nombre,                  
      grupos.color AS grupo_color,                   
      lineas.uuid AS propiedad_uuid,
      lineas.parent_uuid AS parent_uuid,
      lineas.nombre AS propiedad_nombre,
      lineas.color_rgb AS propiedad_color_rgb,
      lineas.orden AS orden
      
   FROM %1$s AS grupos  

      INNER JOIN %2$s AS lineas
         ON grupos.uuid = lineas.parent_uuid

   ORDER by grupo_id, orden      

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLPropiedadesLineasModel():getTableName() )                                      

RETURN ( cSql )

//---------------------------------------------------------------------------//

#ifdef __TEST__   

METHOD test_create_tallas() CLASS SQLPropiedadesModel

   ::insertBlankBuffer( {  "codigo" => "TALLA",;
                           "nombre" => "Talla",;
                           "color"  => 0 } )

   SQLPropiedadesLineasModel():insertBlankBuffer(  {  "parent_uuid"  => hget( ::hBuffer, "uuid" ),;
                                                      "nombre"       => "XS" } )

   SQLPropiedadesLineasModel():insertBlankBuffer(  {  "parent_uuid"  => hget( ::hBuffer, "uuid" ),;
                                                      "nombre"       => "S" } )

   SQLPropiedadesLineasModel():insertBlankBuffer(  {  "parent_uuid"  => hget( ::hBuffer, "uuid" ),;
                                                      "nombre"       => "M" } )

   SQLPropiedadesLineasModel():insertBlankBuffer(  {  "parent_uuid"  => hget( ::hBuffer, "uuid" ),;
                                                      "nombre"       => "L" } )

   SQLPropiedadesLineasModel():insertBlankBuffer(  {  "parent_uuid"  => hget( ::hBuffer, "uuid" ),;
                                                      "nombre"       => "XL" } )

   SQLPropiedadesLineasModel():insertBlankBuffer(  {  "parent_uuid"  => hget( ::hBuffer, "uuid" ),;
                                                      "nombre"       => "XXL" } )
 
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_colores() CLASS SQLPropiedadesModel

   ::insertBlankBuffer( {  "codigo" => "COLOR",;
                           "nombre" => "Color",;
                           "color"  => 1 } )

   SQLPropiedadesLineasModel():insertBlankBuffer(  {  "parent_uuid"  => hget( ::hBuffer, "uuid" ),;
                                                      "nombre"       => "Rojo",;
                                                      "color_rgb"    => 255 } )

   SQLPropiedadesLineasModel():insertBlankBuffer(  {  "parent_uuid"  => hget( ::hBuffer, "uuid" ),;
                                                      "nombre"       => "Azul",;
                                                      "color_rgb"    => 16711680 } )

   SQLPropiedadesLineasModel():insertBlankBuffer(  {  "parent_uuid"  => hget( ::hBuffer, "uuid" ),;
                                                      "nombre"       => "Verde",;
                                                      "color_rgb"    => 65280 } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create_texturas() CLASS SQLPropiedadesModel

   ::insertBlankBuffer( {  "codigo" => "TEXTURAS",;
                           "nombre" => "Texturas",;
                           "color"  => 0 } )

   SQLPropiedadesLineasModel():insertBlankBuffer(  {  "parent_uuid"  => hget( ::hBuffer, "uuid" ),;
                                                      "nombre"       => "Denim" } )

   SQLPropiedadesLineasModel():insertBlankBuffer(  {  "parent_uuid"  => hget( ::hBuffer, "uuid" ),;
                                                      "nombre"       => "Chino" } )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PropiedadesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLPropiedadesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

