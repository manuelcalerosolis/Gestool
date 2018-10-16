#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosUnidadesMedicionController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := ArticulosUnidadesMedicionBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := ArticulosUnidadesMedicionView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := ArticulosUnidadesMedicionValidator():New( self ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := ArticulosUnidadesMedicionRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosUnidadesMedicionController

   ::Super:New( oController )

   ::lTransactional                 := .t.

   ::cTitle                         := "Unidades de medicion de artículos"

   ::cName                          := "articulos_unidades_medicion"

   ::hImage                         := {  "16" => "gc_tape_measure2_16",;
                                          "32" => "gc_tape_measure2_32",;
                                          "48" => "gc_tape_measure2_48" }

   ::oModel                         := SQLArticulosUnidadesMedicionModel():New( self )


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosUnidadesMedicionController

   ::oModel:End()

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
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

CLASS ArticulosUnidadesMedicionBrowseView FROM SQLBrowseView

   METHOD addColumns()                    

ENDCLASS

//---------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosUnidadesMedicionBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidades_medicion_codigo'
      :cHeader             := 'Código'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidades_medicion_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'unidades_medicion_nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidades_medicion_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cantidad'
      :cHeader             := 'Cantidad'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cantidad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'operar'
      :cHeader             := 'Operar'
      :nWidth              := 60
      :bEditValue          := {|| ::getRowSet():fieldGet( 'operar' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :SetCheck( { "Sel16", "Nil16" } )
      :AddResource( "Tactil16" )
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosUnidadesMedicionView FROM SQLBaseView

   DATA oGetCantidad
  
   METHOD Activate()

   METHOD StartDialog()
   
END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosUnidadesMedicionView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ARTICULOS_UNIDADES_MEDICION" ;
      TITLE       ::LblTitle() + "unidades de medición"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::oController:getUnidadesMedicionController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "unidad_medicion_codigo" ] ) )
   ::oController:getUnidadesMedicionController():getSelector():Activate( 100, 101, ::oDialog )

   REDEFINE GET   ::oGetCantidad ;
      VAR         ::oController:oModel:hBuffer[ "cantidad" ] ;
      ID          110 ;
      PICTURE     "@E 99999999.999999" ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "operar" ] ;
      ID          120 ;
      IDSAY       121 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart     := {|| ::StartDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartDialog()

   ::oController:getUnidadesMedicionController():getSelector():Start()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosUnidadesMedicionValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosUnidadesMedicionValidator

   ::hValidators  := {  "unidad_medicion_codigo" =>  {  "required"   => "El código es un dato requerido",;
                                                         "unique"    => "El código introducido ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosUnidadesMedicionModel FROM SQLCompanyModel

   DATA cTableName               INIT "articulos_unidades_medicion"

   DATA cConstraints             INIT "PRIMARY KEY ( id )"

   METHOD getInitialSelect()

   METHOD getColumns()

   /*METHOD getUnidadMedicionUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 8 ), SQLUnidadesMedicionModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setUnidadMedicionUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLUnidadesMedicionModel():getUuidWhereCodigo( uValue ) ) )*/

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLArticulosUnidadesMedicionModel

   local cSelect  := "SELECT articulos_unidades_medicion.id,"                                                     + " " + ;
                        "articulos_unidades_medicion.uuid,"                                                       + " " + ;
                        "articulos_unidades_medicion.operar,"                                                     + " " + ;
                        "articulos_unidades_medicion.cantidad,"                                                   + " " + ;
                        "unidades_medicion.codigo as unidades_medicion_codigo,"                                   + " " + ;
                        "unidades_medicion.nombre as unidades_medicion_nombre,"                                   + " " + ;
                        "unidades_medicion.uuid as unidades_medicion_uuid"                                        + " " + ;
                     "FROM " +::getTableName() + " AS articulos_unidades_medicion"                                + " " + ;
                        "INNER JOIN " + SQLUnidadesMedicionModel():getTableName() + " AS unidades_medicion"       + " " + ;
                        "ON articulos_unidades_medicion.unidad_medicion_codigo = unidades_medicion.codigo"

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosUnidadesMedicionModel
   
   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",                {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                      "default"   => {|| ::getControllerParentUuid() } } )

   hset( ::hColumns, "unidad_medicion_codigo",       {  "create"    => "VARCHAR( 20 ) NOT NULL"                  ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "operar",                     {  "create"    => "TINYINT( 1 )"                            ,;
                                                      "default"   => {|| 0 } }                               )

   hset( ::hColumns, "cantidad",                   {  "create"    => "FLOAT( 16, 6 )"                          ,;
                                                      "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosUnidadesMedicionRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosUnidadesMedicionModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

