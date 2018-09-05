#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DireccionTipoDocumentoController FROM SQLNavigatorController

   DATA oDireccionesController

   DATA oDireccionTiposController

   METHOD New()

   METHOD End()

   METHOD getUuid()

   METHOD setDireccionesUuid()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS DireccionTipoDocumentoController

   ::Super:New( oSenderController )

   ::cTitle                         := "Tipos de direcciones por factura"

   ::cName                          := "direcciones_tipo_factura"

   ::hImage                         := {  "16" => "gc_map_route_16",;
                                          "32" => "gc_map_route_32",;
                                          "48" => "gc_map_route_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLDireccionTipoDocumentoModel():New( self )

   ::oBrowseView                    := DireccionTipoDocumentoBrowseView():New( self )

   ::oDialogView                    := DireccionTipoDocumentoView():New( self )

   ::oValidator                     := DireccionTipoDocumentoValidator():New( self, ::oDialogView )

   ::oRepository                    := DireccionTipoDocumentoRepository():New( self )
   
   ::oGetSelector                   := GetSelector():New( self )

   ::oDireccionesController         := DireccionesController():New( self )

   ::oDireccionTiposController      := DireccionTiposController():New( self )

   ::oDireccionesController:setEvent( 'gettingSelectSentence', {|| ::getParentUuid() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS DireccionTipoDocumentoController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oGetSelector:End()

   ::oDireccionesController:End()

   ::oDireccionTiposController:End()

   ::oModel                      := nil

   ::oBrowseView                 := nil

   ::oDialogView                 := nil

   ::oValidator                  := nil

   ::oRepository                 := nil

   ::oGetSelector                := nil

   ::oDireccionesController      := nil

   ::oDireccionTiposController   := nil

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getUuid() CLASS DireccionTipoDocumentoController

RETURN ( ::oSenderController:getClientUuid() )

//---------------------------------------------------------------------------//

METHOD setDireccionesUuid() CLASS DireccionTipoDocumentoController

   local uuidDireccion

   uuidDireccion  := ::oDireccionesController:oModel:getFieldWhere( 'uuid', { 'codigo' => ::oModel:getBuffer( 'direccion_uuid' ), 'parent_uuid' => ::oSenderController:getClientUuid() } )

   if !empty( uuidDireccion )
      ::oModel:setBuffer( 'direccion_uuid', uuidDireccion )
   end if 

   msgalert( hb_valtoexp( ::oModel:hBuffer ), "setDireccionesUuid" )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionTipoDocumentoBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS DireccionTipoDocumentoBrowseView

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
      :cSortOrder          := 'parent_uuid'
      :cHeader             := 'Parent uuid'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'parent_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tipo'
      :cHeader             := 'Tipo de direcci�n'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tipo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'C�digo'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion'
      :cHeader             := 'Direcci�n'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

      with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'poblacion'
      :cHeader             := 'Poblaci�n'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'poblacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'provincia'
      :cHeader             := 'Provincia'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'provincia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_postal'
      :cHeader             := 'C�digo postal'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_postal' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'pais'
      :cHeader             := 'Pa�s'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'pais' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionTipoDocumentoView FROM SQLBaseView

   METHOD Activate()

   METHOD StartActivate()

   METHOD Activated()            INLINE ( ::oController:setDireccionesUuid() )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS DireccionTipoDocumentoView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DIRECCION_TIPO_DOCUMENTO" ;
      TITLE       ::LblTitle() + " tipo de direcci�n"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   // Tipo-------------------------------------------------------------------

   ::oController:oDireccionTiposController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "tipo_uuid" ] ) )
   ::oController:oDireccionTiposController:oGetSelector:Build( { "idGet" => 100, "idText" => 101, "idLink" => 102, "oDialog" => ::oDialog } )

   // Direccion--------------------------------------------------------------

   ::oController:oDireccionesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "direccion_uuid" ] ) )
   ::oController:oDireccionesController:oGetSelector:Build( { "idGet" => 110, "idText" => 112, "idCodigoPostal" => 113, "idPoblacion" => 114, "idProvincia" => 115, "idPais" => 116, "oDialog" => ::oDialog } )

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

METHOD StartActivate() CLASS DireccionTipoDocumentoView

   ::oController:oDireccionesController:oGetSelector:Start()

   ::oController:oDireccionTiposController:oGetSelector:Start()

RETURN ( self )

//---------------------------------------------------------------------------//

CLASS DireccionTipoDocumentoValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DireccionTipoDocumentoValidator

   ::hValidators  := {  "nombre" =>       {  "required"           => "La descripci�n es un dato requerido",;
                                             "unique"             => "La descripci�n introducida ya existe" },;
                        "codigo" =>       {  "required"           => "El c�digo es un dato requerido" ,;
                                             "unique"             => "EL c�digo introducido ya existe"  } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDireccionTipoDocumentoModel FROM SQLCompanyModel

   DATA cTableName                        INIT "direccion_tipo_documento"

   DATA cConstraints                      INIT "PRIMARY KEY (parent_uuid, tipo_uuid)"

   METHOD getColumns()

   METHOD getTipoUuidAttribute( uValue ) ; 
                                          INLINE ( if( empty( uValue ), space( 3 ), SQLDireccionTiposModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setTipoUuidAttribute( uValue ) ;
                                          INLINE ( if( empty( uValue ), "", SQLDireccionTiposModel():getUuidWhereCodigo( uValue ) ) )
                       
   METHOD getDireccionUuidAttribute( uValue ) ; 
                                          INLINE ( if( empty( uValue ), space( 20 ), SQLDireccionesModel():getCodigoWhereUuid( uValue ) ) )

   METHOD getInitialSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDireccionTipoDocumentoModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                                         "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",                   {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| ::getSenderControllerParentUuid() } }  )

   hset( ::hColumns, "tipo_uuid",                     {  "create"    => "VARCHAR( 40 ) NOT NULL"                           ,;
                                                         "default"   => {|| space( 40 ) } }                        )

   hset( ::hColumns, "direccion_uuid",                {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| space( 40 ) } }                        )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLDireccionTipoDocumentoModel                                                               

   local cSql

   TEXT INTO cSql

   SELECT direccion_tipo_documento.id AS id,
      direccion_tipo_documento.uuid AS uuid,
      direccion_tipo_documento.parent_uuid AS parent_uuid,
      direccion_tipo.nombre AS tipo,
      direcciones.codigo AS codigo,
      direcciones.direccion AS direccion,
      direcciones.poblacion AS poblacion,
      direcciones.codigo_provincia AS codigo_provincia,
      direcciones.provincia AS provincia,
      direcciones.codigo_postal AS codigo_postal,
      direcciones.codigo_pais AS codigo_pais,
      paises.nombre AS pais

   FROM %1$s AS direccion_tipo_documento

   INNER JOIN %2$s AS direccion_tipo
      ON direccion_tipo_documento.tipo_uuid = direccion_tipo.uuid

   INNER JOIN %3$s AS direcciones
      ON direccion_tipo_documento.direccion_uuid = direcciones.uuid 

   INNER JOIN %4$s AS paises
      ON direcciones.codigo_pais = paises.codigo

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLDireccionTiposModel():getTableName(), SQLDireccionesModel():getTableName(), SQLPaisesModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionTipoDocumentoRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLDireccionTipoDocumentoModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//