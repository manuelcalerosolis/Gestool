#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CamposExtraValoresController FROM SQLNavigatorController

   DATA oCamposExtraValoresController

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS CamposExtraValoresController

   ::Super:New()

   ::cTitle                            := "Campos extra relacion"

   ::setName( "campos_extra_relacion" )

   ::lTransactional                    := .t.

   ::nLevel                            := Auth():Level( ::getName() )

   ::hImage                            := {  "16" => "gc_user_message_16",;
                                             "32" => "gc_user_message_32",;
                                             "48" => "gc_user_message_48" }

   ::oModel                            := SQLCamposExtraValoresModel():New( self )

   ::oBrowseView                       := CamposExtraValoresBrowseView():New( self )

   ::oDialogView                       := CamposExtraValoresView():New( self )

   ::oValidator                        := CamposExtraValoresValidator():New( self, ::oDialogView )

   ::oCamposExtraValoresController   := CamposExtraValoresController():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )


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

CLASS CamposExtraValoresBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CamposExtraValoresBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'campos_extra_relacion_uuid'
      :cHeader             := 'Campo extra entidad'
      :nWidth              := 300
      :bEditValue          := {|| ::oController:getCampoExtraRelacion() }
      :nEditType           := EDIT_LISTBOX
      :cEditPicture        := ""
      :bEditValue          := {|| ::getRowSet():fieldGet( 'campo_extra_relacion_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'uuid_registro'
      :cHeader             := 'Registro'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid_registro' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'valor'
      :cHeader             := 'Valor'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'valor' ) }
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

CLASS CamposExtraValoresView FROM SQLBaseView

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS CamposExtraValoresView

   local oBtnAppend
   local oBtnDelete

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CAMPOS_EXTRA_VALORES" ;
      TITLE       ::LblTitle() + "valor"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_signpost3_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "campo_extra_relacion_uuid" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "campo_extra_relacion_uuid" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "registro_uuid" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "registro_uuid" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "valor" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "valor" ) ) ;
      OF          ::oDialog

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

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CamposExtraValoresValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CamposExtraValoresValidator

   ::hValidators  := {     "campo_extra_relacion_uuid"   =>          {  "required"     => "El lugar donde se encuentra el campo extra es un dato requerido"},; 
                           "uuid_registro"               =>          {  "required"     => "El Registro es un dato requerido",;
                                                                        "unique"       => "El Registro introducido ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCamposExtraValoresModel FROM SQLBaseModel

   DATA cTableName                           INIT "campos_extra_entidad_valor"

   METHOD getColumns()

   METHOD getListaAttribute( value )         INLINE ( if( empty( value ), {}, hb_deserialize( value ) ) )

   METHOD setListaAttribute( value )         INLINE ( hb_serialize( value ) )

          
END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCamposExtraValoresModel

   hset( ::hColumns, "id",                                  {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                               "text"      => "Identificador"                           ,;
                                                               "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                                {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                               "text"      => "Uuid"                                    ,;
                                                               "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "campo_extra_entidades_uuid",          {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                               "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "entidad_uuid",                        {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                               "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "valor",                               {  "create"    => "VARCHAR( 200 )"                          ,;
                                                               "default"   => {|| space( 200 ) } }                      )


RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CamposExtraValoresRepository FROM SQLBaseRepository

   METHOD getTableName()                              INLINE ( SQLCamposExtraValoresModel():getTableName() ) 
   METHOD getTableNameCamposExtra()                   INLINE ( SQLCamposExtraModel():getTableName() ) 
   METHOD getCampoExtraEntidades()

END CLASS

//---------------------------------------------------------------------------//


METHOD getCampoExtraEntidades() CLASS CamposExtraValoresRepository

   local cSQL  

   cSQL              := "SELECT uuid FROM " + ::getTableNameCamposExtra() + " "

RETURN ( getSQLDataBase():Exec( cSQL ) )
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//