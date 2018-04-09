#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CamposExtraValoresController FROM SQLBrowseController

   DATA cEntidad

   DATA uuidEntidad

   DATA oCamposExtraValoresController

   METHOD New( cEntidad, uuidEntidad )

   METHOD Edit() 

   METHOD assertCamposExtraValores()

   METHOD insertIgnoreCamposExtraValores( hValor )

   METHOD gettingSelectSentence()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cEntidad, uuidEntidad ) CLASS CamposExtraValoresController

   ::Super:New()

   ::cEntidad                          := cEntidad

   ::uuidEntidad                       := uuidEntidad

   ::cTitle                            := "Campos extra valores"

   ::setName( "campos_extra_valores" )

   ::lTransactional                    := .t.

   ::hImage                            := {  "16" => "gc_user_message_16",;
                                             "32" => "gc_user_message_32",;
                                             "48" => "gc_user_message_48" }

   ::oModel                            := SQLCamposExtraValoresModel():New( self )

   ::oBrowseView                       := CamposExtraValoresBrowseView():New( self )

   ::oRepository                       := CamposExtraValoresRepository():New( self )

   ::oDialogView                       := CamposExtraValoresView():New( self )

   ::oValidator                        := CamposExtraValoresValidator():New( self, ::oDialogView )

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )   

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS CamposExtraValoresController

   ::setEditMode()

   if !( ::assertCamposExtraValores() )
      RETURN .f.
   end if 

   ::oRowSet:build( ::oModel:getSelectSentence() )

   ::beginTransactionalMode()

   if ::DialogViewActivate()
      
      ::commitTransactionalMode()

   else

      ::rollbackTransactionalMode()

   end if 

   // Validar el dialogo

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD assertCamposExtraValores() CLASS CamposExtraValoresController

   local aValores  

   aValores          := ::oRepository:getHashCampoExtraValoresWhereEntidad( ::cEntidad )

   if empty( aValores )
      RETURN .f.
   end if 

   aeval( aValores, {|hValor| ::insertIgnoreCamposExtraValores( hValor ) } )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD insertIgnoreCamposExtraValores( hValor ) CLASS CamposExtraValoresController
   
   local hBuffer  

   hBuffer        := ::oModel:loadBlankBuffer()

   hset( hBuffer, "campo_extra_entidad_uuid", hget( hValor, "uuid" ) ) 
   hset( hBuffer, "entidad_uuid", ::uuidEntidad )
   
   ::oModel:insertIgnoreBuffer( hBuffer )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence()

   if !empty( ::uuidEntidad  )
      ::oModel:setGeneralWhere( "entidad_uuid = " + quoted( ::uuidEntidad ) )
   end if 

RETURN ( Self )

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
      :lHide               := .t.
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

   METHOD New( oSender )

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender )

   ::oController  := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CamposExtraValoresView

   msgalert( "ACctivate")

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

   ::oController:oBrowseView:ActivateDialog( ::oDialog, 100 )

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

   DATA cTableName                           INIT "campos_extra_valores"

   DATA cConstraints                         INIT "PRIMARY KEY ( id ), UNIQUE KEY ( campo_extra_entidad_uuid, entidad_uuid )"

   METHOD getColumns()

   METHOD getListaAttribute( value )         INLINE ( if( empty( value ), {}, hb_deserialize( value ) ) )

   METHOD setListaAttribute( value )         INLINE ( hb_serialize( value ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCamposExtraValoresModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "campo_extra_entidad_uuid",   {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "entidad_uuid",               {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "valor",                      {  "create"    => "VARCHAR( 200 )"                          ,;
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

   METHOD getSentenceCampoExtraValoresWhereEntidad( cEntidad )

   METHOD getHashCampoExtraValoresWhereEntidad( cEntidad )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceCampoExtraValoresWhereEntidad( cEntidad ) CLASS CamposExtraValoresRepository

   local cSQL  

   DEFAULT cEntidad  := 'clientes'

   cSQL              := "SELECT entidad.id, entidad.uuid, entidad.parent_uuid, entidad.entidad, campos.nombre, valores.valor " 
   cSQL              +=    "FROM campos_extra_entidad entidad "
   cSQL              +=    "INNER JOIN campos_extra campos ON entidad.parent_uuid = campos.uuid "
   cSQL              +=    "LEFT JOIN campos_extra_valores valores ON valores.campo_extra_entidad_uuid = entidad.uuid "
   cSQL              +=    "WHERE entidad = " + quoted( cEntidad )

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD getHashCampoExtraValoresWhereEntidad( cEntidad ) CLASS CamposExtraValoresRepository

   local cSQL        := ::getSentenceCampoExtraValoresWhereEntidad( cEntidad ) 

RETURN ( getSQLDataBase():selectFetchHash( cSQL ) )

//---------------------------------------------------------------------------//

