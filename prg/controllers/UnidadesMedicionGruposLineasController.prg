#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposLineasController FROM SQLNavigatorController

   DATA oUnidadesMedicionController

   DATA oUnidadesMedicionController2

   METHOD New()

   METHOD End()

   /*METHOD isSystemRegister()     INLINE ( iif( ::getRowSet():fieldGet( 'sistema' ),;
                                             ( msgStop( "Este registro pertenece al sistema, no se puede alterar." ), .f. ),;
                                             .t. ) )*/

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS UnidadesMedicionGruposLineasController

   ::Super:New( oSenderController )

   ::cTitle                         := "Grupos de unidades de medición"

   ::cName                          := "unidades_medicion_grupos"

   ::hImage                         := {  "16" => "gc_tape_measure2_16",;
                                          "32" => "gc_tape_measure2_32",;
                                          "48" => "gc_tape_measure2_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLUnidadesMedicionGruposLineasModel():New( self )

   ::oBrowseView                    := UnidadesMedicionGruposLineasBrowseView():New( self )

   ::oDialogView                    := UnidadesMedicionGruposLineasView():New( self )

   ::oValidator                     := UnidadesMedicionGruposLineasValidator():New( self, ::oDialogView )

   ::oRepository                    := UnidadesMedicionGruposLineasRepository():New( self )

   ::oUnidadesMedicionController    := UnidadesMedicionController():New( self )

   ::oUnidadesMedicionController2    := UnidadesMedicionController():New( self )

   ::oGetSelector                   := GetSelector():New( self )

   ::setEvents( { 'editing', 'deleting' }, {|| ::isSystemRegister() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS UnidadesMedicionGruposLineasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oUnidadesMedicionController:End()

   ::oUnidadesMedicionController2:End()

   ::oGetSelector:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposLineasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS UnidadesMedicionGruposLineasBrowseView
/*
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
      :cSortOrder          := 'codigo_iso'
      :cHeader             := 'Código ISO'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_iso' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with
*/
RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposLineasView FROM SQLBaseView

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UnidadesMedicionGruposLineasView

   local oDialog


   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "LINEA_GRUPO_UNIDAD_MEDICION" ;
      TITLE       ::LblTitle() + " grupo de unidades de medición"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;

// unidad alternativa-------------------------------------------------------------------------------------------------------//

   ::oController:oUnidadesMedicioncontroller:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "unidad_alternativa_codigo" ] ) )
   
   ::oController:oUnidadesMedicioncontroller:oGetSelector:setEvent( 'validated', {|| ::UnidadesMedicionControllerValidated() } )

   ::oController:oUnidadesMedicioncontroller:oGetSelector:Activate( 120, 122, ::oDialog )

   REDEFINE GET   ::oController:oModel:hBuffer[ "cantidad_alternativa" ] ;
      ID          130 ;
      SPINNER ;
      MIN 1;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;


// unidad base--------------------------------------------------------------------------------------------------------------//

   ::oController:oUnidadesMedicioncontroller2:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "unidad_base_codigo" ] ) )
   
   ::oController:oUnidadesMedicioncontroller2:oGetSelector:setEvent( 'validated', {|| ::UnidadesMedicionControllerValidated() } )

   ::oController:oUnidadesMedicioncontroller2:oGetSelector:Activate( 140, 142, ::oDialog )

   REDEFINE GET   ::oController:oModel:hBuffer[ "cantidad_base" ] ;
      ID          150 ;
      SPINNER ;
      MIN 1;
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
      ACTION      ( ::oDialog:end() )

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

CLASS UnidadesMedicionGruposLineasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS UnidadesMedicionGruposLineasValidator

   ::hValidators  := {  "nombre" =>       {  "required"           => "La descripción es un dato requerido",;
                                             "unique"             => "La descripción introducida ya existe" },;
                        "codigo" =>       {  "required"           => "El código es un dato requerido" ,;
                                             "unique"             => "EL código introducido ya existe"  } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLUnidadesMedicionGruposLineasModel FROM SQLBaseModel

   DATA cTableName               INIT "unidades_medicion_grupos_lineas"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUnidadesMedicionGruposLineasModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                                         "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",                   {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| space( 40 ) } }                        )

   hset( ::hColumns, "unidad_alternativa_codigo",     {  "create"    => "VARCHAR( 20 )"                           ,;
                                                         "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "cantidad_alternativa",          {  "create"    => "INTEGER"                                 ,;
                                                         "default"   => {|| 1 } }                                 )

   hset( ::hColumns, "unidad_base_codigo",            {  "create"    => "VARCHAR( 20 )"                          ,;
                                                         "default"   => {|| space( 20 ) } }                      )

   hset( ::hColumns, "cantidad_base",                 {  "create"    => "INTEGER"                                 ,;
                                                         "default"   => {|| 1 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposLineasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLUnidadesMedicionGruposLineasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
