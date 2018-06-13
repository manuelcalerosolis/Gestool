#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposLineasController FROM SQLBrowseController

   DATA oUnidadesMedicionController


   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS UnidadesMedicionGruposLineasController

   ::Super:New( oSenderController )

   ::cTitle                         := "Equivalencia de unidades de medición"

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

   ::oGetSelector                   := GetSelector():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS UnidadesMedicionGruposLineasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oUnidadesMedicionController:End()

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
      :cSortOrder          := 'cantidad_alternativa'
      :cHeader             := 'Cantidad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cantidad_alternativa' ) }
      :cEditPicture        := "@E 999999999.999999"
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_alternativa_codigo'
      :cHeader             := 'Código de unidad alternativa'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_alternativa_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_alternativa_nombre'
      :cHeader             := 'Nombre de unidad alternativa'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_alternativa_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cantidad_base'
      :cHeader             := 'Cantidad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cantidad_base' ) }
      :cEditPicture        := "@E 999999999.999999"
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

      with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_base_codigo'
      :cHeader             := 'Código de unidad base'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_base_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

  with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidad_base_nombre'
      :cHeader             := 'Nombre de unidad base'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_base_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposLineasView FROM SQLBaseView

   METHOD Activate()

    METHOD StartActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UnidadesMedicionGruposLineasView

   local oDialog
   local cUnidadBaseCodigo := ::oController:oSenderController:getModelBuffer( 'unidad_base_codigo' )
   local cUnidadBaseNombre := SQLUnidadesMedicionModel():getField( 'nombre', 'codigo', cUnidadBaseCodigo )

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
      WHEN        ( .f. ) ;
      OF          ::oDialog ;


// unidad base--------------------------------------------------------------------------------------------------------------//

   REDEFINE GET   cUnidadBaseCodigo ;
      ID          140 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;

   REDEFINE GET   cUnidadBaseNombre ;
      ID          142 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "cantidad_base" ] ;
      ID          150 ;
      SPINNER ;
      MIN 1.000;
      PICTURE     "@E 999999999.999" ;
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

   ::oDialog:bStart  := {|| ::StartActivate() }
   
   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()
  

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS UnidadesMedicionGruposLineasView

   ::oController:oUnidadesMedicioncontroller:oGetSelector:Start()

RETURN ( self )

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

CLASS SQLUnidadesMedicionGruposLineasModel FROM SQLCompanyModel

   DATA cTableName                                 INIT "unidades_medicion_grupos_lineas"

   METHOD getColumns()

   METHOD getGeneralSelect()

   METHOD getUnidadesMedicionTableName()           INLINE ( SQLUnidadesMedicionModel():getTableName() )

   METHOD getUnidadesMedicionGruposTableName()     INLINE ( SQLUnidadesMedicionGruposModel():getTableName() )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUnidadesMedicionGruposLineasModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                                         "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",                   {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| ::getSenderControllerParentUuid() } }  )

   hset( ::hColumns, "unidad_alternativa_codigo",     {  "create"    => "VARCHAR( 20 )"                           ,;
                                                         "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "cantidad_alternativa",          {  "create"    => "INTEGER"                                 ,;
                                                         "default"   => {|| 1 } }                                 )

   hset( ::hColumns, "cantidad_base",                 {  "create"    => "FLOAT (10,3)"                              ,;
                                                         "default"   => {|| 1    } }                               )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getGeneralSelect() CLASS SQLUnidadesMedicionGruposLineasModel

   local cSelect  := "SELECT lineas.id,"                                                                          + " " + ;                                                                                                                     
                        "lineas.uuid,"                                                                            + " " + ;                                                                                                                                    
                        "lineas.parent_uuid,"                                                                     + " " + ;
                        "lineas.unidad_alternativa_codigo,"                                                       + " " + ;
                        "alternativa.nombre as unidad_alternativa_nombre,"                                        + " " + ;
                        "lineas.cantidad_alternativa,"                                                            + " " + ;                                               
                        "lineas.cantidad_base,"                                                                   + " " + ;
                        "grupos.unidad_base_codigo as unidad_base_codigo,"                                        + " " + ;
                        "base.nombre as unidad_base_nombre"                                                       + " " + ;
                     "FROM "+ ::getTableName() + " AS lineas"                                                     + " " + ;                                                    
                        "INNER JOIN " + ::getUnidadesMedicionGruposTableName() + " AS grupos"                     + " " + ;         
                           "ON lineas.parent_uuid = grupos.uuid"                                                  + " " + ;         
                        "INNER JOIN " + ::getUnidadesMedicionTableName() + " AS alternativa"                      + " " + ;         
                           "ON lineas.unidad_alternativa_codigo = alternativa.codigo"                             + " " + ;
                        "INNER JOIN " + ::getUnidadesMedicionTableName() + " AS base"                             + " " + ;         
                           " ON grupos.unidad_base_codigo = base.codigo"                                          + " " + ;         
                     "WHERE parent_uuid = " + quoted( ::getSenderControllerParentUuid() )

RETURN ( cSelect )

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
