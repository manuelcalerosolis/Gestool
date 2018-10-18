#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PropiedadesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD isColorProperty()         INLINE ( iif( !empty(::getModel()) .and. !empty(::getModel():hBuffer), ::getModel():hBuffer[ "color" ], .f. ) )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := PropiedadesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := PropiedadesView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := PropiedadesValidator():New( self ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := PropiedadesRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel := SQLPropiedadesModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PropiedadesController

   ::Super:New( oController )

   ::cTitle                         := "Propiedades"

   ::cName                          := "articulos_propiedades"

   ::hImage                         := {  "16" => "gc_coathanger_16",;
                                          "32" => "gc_coathanger_32",;
                                          "48" => "gc_coathanger_48" }

   ::nLevel                         := Auth():Level( ::cName )

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

   ::Super:End()

RETURN ( nil )

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

   METHOD Activate()

   METHOD startActivate()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS PropiedadesView

   local oBtnEdit
   local oBtnAppend
   local oBtnDelete
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

   // Lineas de propiedades -------------------------------------------------------

   REDEFINE BUTTON oBtnAppend ;
      ID          130 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnAppend:bAction   := {|| ::oController:getPropiedadesLineasController():Append() }

   REDEFINE BUTTON oBtnEdit ;
      ID          140 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnEdit:bAction   := {|| ::oController:getPropiedadesLineasController():Edit() }

   REDEFINE BUTTON oBtnDelete ;
      ID          150 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnDelete:bAction   := {|| ::oController:getPropiedadesLineasController():Delete() }

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

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   if ::oController:isNotZoomMode() 
   
      ::oDialog:bKeyDown   := <| nKey |  
         do case         
            case nKey == VK_F5
               if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), )
            case nKey == VK_F2
               ::oController:getPropiedadesLineasController():Append()
            case nKey == VK_F3
               ::oController:getPropiedadesLineasController():Edit()
            case nKey == VK_F4
               ::oController:getPropiedadesLineasController():Delete()
         end 
         RETURN ( 0 )
         >

   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

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

   METHOD getColumns()

   METHOD getPropertyList()

   METHOD getPropertyListWhereArticuloCodigo( cCodigoArticulo )

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
                                    "default"   => {|| 0 } }                               )


RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getPropertyList() CLASS SQLPropiedadesModel

   local cSelect  := "SELECT grupos.id AS grupo_id,"                                            + " " + ; 
                           "grupos.uuid AS grupo_uuid,"                                         + " " + ;
                           "grupos.nombre AS grupo_nombre,"                                     + " " + ;                     
                           "grupos.color AS grupo_color,"                                       + " " + ;                     
                           "lineas.uuid AS propiedad_uuid,"                                     + " " + ;
                           "lineas.parent_uuid AS parent_uuid,"                                 + " " + ;
                           "lineas.nombre AS propiedad_nombre,"                                 + " " + ;
                           "lineas.color_rgb AS propiedad_color_rgb,"                           + " " + ;
                           "lineas.orden AS orden"                                              + " " + ;
                     "FROM " + ::getTableName() + " AS grupos "                                 + " " + ; 
                     "INNER JOIN " + SQLPropiedadesLineasModel():getTableName() + " AS lineas"  + " " + ;
                        "ON grupos.uuid = lineas.parent_uuid"                                   + " " + ;
                     "ORDER by grupo_id, orden"                                               

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getPropertyListWhereArticuloCodigo( cCodigoArticulo ) CLASS SQLPropiedadesModel


local cSql

   TEXT INTO cSql

   SELECT  
         combinaciones.*,
         GROUP_CONCAT( CONCAT( " ", articulos_propiedades_lineas.nombre, " " ) ORDER BY combinaciones_propiedades.id ) AS articulos_propiedades_nombre

   FROM %1$s as combinaciones_propiedades
   INNER JOIN articulos as articulos
      ON articulos.codigo= %4$s
   
   INNER JOIN %2$s as combinaciones
      ON combinaciones.parent_uuid = articulos.uuid
   
   INNER JOIN %3$s AS articulos_propiedades_lineas
      ON articulos_propiedades_lineas.uuid = combinaciones_propiedades.propiedad_uuid

   WHERE combinaciones_propiedades.parent_uuid = combinaciones.uuid
   GROUP BY combinaciones.uuid

   ENDTEXT

   cSql  := hb_strformat( cSql, SQLCombinacionesPropiedadesModel():getTableName(), SQLCombinacionesModel():getTableName(),SQLPropiedadesLineasModel():getTableName(), quoted( cCodigoArticulo ) )

RETURN ( cSql )
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

