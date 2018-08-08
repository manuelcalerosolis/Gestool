#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UnidadesMedicionOperacionesController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS UnidadesMedicionOperacionesController

   ::Super:New( oSenderController )

   ::cTitle                         := "Unidades operacion"

   ::cName                          := "unidades_medicion_operacion"

   ::hImage                         := {  "16" => "gc_tape_measure2_16",;
                                          "32" => "gc_tape_measure2_32",;
                                          "48" => "gc_tape_measure2_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLUnidadesMedicionOperacionesModel():New( self )

   ::oBrowseView                    := UnidadesMedicionOperacionesBrowseView():New( self )

   ::oDialogView                    := UnidadesMedicionOperacionesView():New( self )

   ::oValidator                     := UnidadesMedicionOperacionesValidator():New( self, ::oDialogView )

   ::oRepository                    := UnidadesMedicionOperacionesRepository():New( self )

   /*::oGetSelector                   := GetSelector():New( self )*/

RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS UnidadesMedicionOperacionesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   /*::oGetSelector:End()*/

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

CLASS UnidadesMedicionOperacionesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS UnidadesMedicionOperacionesBrowseView

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
      :cSortOrder          := 'unidad'
      :cHeader             := 'Unidad'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'operacion'
      :cHeader             := 'Operacion'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'operacion' ) }
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

CLASS UnidadesMedicionOperacionesView FROM SQLBaseView

   DATA oUnidad

   DATA oTipo

   DATA hTipos

   METHOD New()

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS UnidadesMedicionOperacionesView

   ::Super:New( oController )

   ::hTipos          := {  "Compra"                         => "bullet_ball_glass_blue_16",;
                           "Venta"                          => "bullet_ball_glass_green_16",;
                           "Movimiento entre almacenes"     => "bullet_ball_glass_red_16",;
                           "TPV"                            => "bullet_triangle_yellow_16" }

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UnidadesMedicionOperacionesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "UNIDAD_MEDICION_OPERACION" ;
      TITLE       ::LblTitle() + "unidad de operaciones"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;
   

   REDEFINE COMBOBOX ::oUnidad ;
      VAR         ::oController:oModel:hBuffer[ "unidad_codigo" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ITEMS       ( hgetkeys( ::hTipos ) ) ;
      BITMAPS     ( hgetvalues( ::hTipos ) ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:oModel:hBuffer[ "operacion" ] ;
      ID          110 ;
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

CLASS UnidadesMedicionOperacionesValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS UnidadesMedicionOperacionesValidator

   /*::hValidators  := {  "nombre " =>               {  "required"           => "El nombre es un dato requerido",;
                                                      "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>                {  "required"           => "El código es un dato requerido" ,;
                                                      "unique"             => "EL código introducido ya existe"  ,;
                                                      "onlyAlphanumeric"   => "EL código no puede contener caracteres especiales" } }*/
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLUnidadesMedicionOperacionesModel FROM SQLCompanyModel

   DATA cTableName               INIT "unidades_medicion_operacion"

   METHOD getUnidadesWhereArticulo()

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUnidadesMedicionOperacionesModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",    {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| space( 40 ) } }                        )

   hset( ::hColumns, "unidad_codigo",  {  "create"    => "VARCHAR( 200 )"                          ,;
                                          "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "operacion",      {  "create"    => "VARCHAR( 200 )"                          ,;
                                          "default"   => {|| space( 200 ) } }                       )
   
   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getUnidadesWhereArticulo( uuidArticulo ) CLASS SQLUnidadesMedicionOperacionesModel

   local cSelect
         cSelect     :="SELECT articulos.unidades_medicion_grupos_codigo, "
         cSelect     +="unidades_medicion_grupos.codigo, "
         cSelect     +="unidades_medicion_grupos.uuid, "
         cSelect     +="unidades_medicion_grupo_lineas.parent_uuid "
         cSelect     +="unidades_medicion_grupo_lineas.unidad_alternativa_codigo "
         cSelect     +="unidades_medicion.codigo "
         cSelect     +="unidades_medicion.nombre "
         cSelect     +="FROM " + SQLArticulosModel:getTableName() + "AS articulos"
         cSelect     +="WHERE articulos.uuid= " + toSqlString ( uuidArticulo ) + " "
         cSelect     +="INNER JOIN " + SQLUnidadesMedicionGruposModel:getTableName() + "AS unidades_medicion_grupos "
         cSelect     +="ON articulos.unidades_medicion_grupos_codigo = unidades_medicion_grupos.codigo "
         cSelect     +="INNER JOIN " + SQLUnidadesMedicionGruposLineasModel:getTableName() + " AS unidades_medicion_grupos_lineas "
         cSelect     +="ON unidades_medicion_grupos.uuid = unidades_medicion_grupo_lineas.parent_uuid "
         cSelect     +="INNER JOIN " + SQLUnidadesMedicionModel:getTableName() + " AS unidades_medicion "
         cSelect     +="ON unidades_medicion_grupo_lineas.unidad_alternativa_codigo = unidades_medicion.codigo "

logwrite( cSelect )

RETURN ( cSelect )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionOperacionesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLUnidadesMedicionOperacionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
