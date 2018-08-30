#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DireccionesTipoDocumentoController FROM SQLNavigatorController

   DATA oDireccionesController

   DATA oDireccionesTiposController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS DireccionesTipoDocumentoController

   ::Super:New( oSenderController )

   ::cTitle                         := "Tipos de direcciones por factura"

   ::cName                          := "direcciones_tipo_factura"

   ::hImage                         := {  "16" => "gc_map_route_16",;
                                          "32" => "gc_map_route_32",;
                                          "48" => "gc_map_route_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLDireccionesTipoDocumentoModel():New( self )

   ::oBrowseView                    := DireccionesTipoDocumentoBrowseView():New( self )

   ::oDialogView                    := DireccionesTipoDocumentoView():New( self )

   ::oValidator                     := DireccionesTipoDocumentoValidator():New( self, ::oDialogView )

   ::oRepository                    := DireccionesTipoDocumentoRepository():New( self )

   ::oDireccionesController         := DireccionesController():New( self )

   ::oDireccionesTiposController    := DireccionesTiposController():New( self )

   ::oGetSelector                   := GetSelector():New( self )

   RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS DireccionesTipoDocumentoController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oDireccionesController:End()

   ::oDireccionesTiposController:End()

   ::oGetSelector:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesTipoDocumentoBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS DireccionesTipoDocumentoBrowseView

   /*with object ( ::oBrowse:AddCol() )
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

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'sistema'
      :cHeader             := 'Sistema'
      :nWidth              := 60
      :bEditValue          := {|| if( ::getRowSet():fieldGet( 'sistema' ) == 1, 'Sistema', '' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with*/

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesTipoDocumentoView FROM SQLBaseView

   METHOD Activate()

   METHOD StartActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS DireccionesTipoDocumentoView

   local oDialog
   local oBmpGeneral

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DIRECCION_TIPO_DOCUMENTO" ;
      TITLE       ::LblTitle() + "incidencia"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   //Tipo-------------------------------------------------------------------

   ::oController:oDireccionesTiposController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "tipo_uuid" ] ) )
   ::oController:oDireccionesTiposController:oGetSelector:Build( { "idGet" => 100, "idText" => 101, "idLink" => 102, "oDialog" => ::oDialog } )

   //Direccion--------------------------------------------------------------

   ::oController:oDireccionesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "direccion_uuid" ] ) )
   


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

   ::oDialog:bStart  := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS DireccionesTipoDocumentoView

   ::oController:oDireccionesController:oGetSelector:Start()

   ::oController:oDireccionesTiposController:oGetSelector:Start()

RETURN ( self )

//---------------------------------------------------------------------------//

CLASS DireccionesTipoDocumentoValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DireccionesTipoDocumentoValidator

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

CLASS SQLDireccionesTipoDocumentoModel FROM SQLCompanyModel

   DATA cTableName                                 INIT "direcciones_tipo_documento"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDireccionesTipoDocumentoModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                                         "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",                   {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| ::getSenderControllerParentUuid() } }  )

   hset( ::hColumns, "direccion_uuid",                {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| space( 40 ) } }                        )

   hset( ::hColumns, "tipo_uuid",                     {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| space( 40 ) } }                        )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesTipoDocumentoRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLDireccionesTipoDocumentoModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//