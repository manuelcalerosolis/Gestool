#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CamposExtraValoresController FROM SQLBrowseController

   DATA cEntidad

   DATA uuidEntidad

   DATA oCamposExtraValoresController

   METHOD New( self )

   METHOD End()

   METHOD setEntidad( cEntidad )                            INLINE ( ::cEntidad := cEntidad )

   METHOD setUuidEntidad( uuidEntidad )                     INLINE ( ::uuidEntidad := uuidEntidad )

   METHOD NewArticulo( cEntidad, uuidEntidad )              INLINE ( ::New( 'articulos', uuidEntidad ) )

   METHOD Edit( uuidEntidad ) 

   METHOD assertCamposExtraValores()

   METHOD insertIgnoreCamposExtraValores( hValor )

   METHOD gettingSelectSentence()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS CamposExtraValoresController

   ::Super:New( oSenderController )

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

METHOD End() CLASS CamposExtraValoresController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Edit( uuidEntidad ) CLASS CamposExtraValoresController

   if empty( uuidEntidad )
      RETURN .f.
   end if 

   ::setUuidEntidad( uuidEntidad )

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

   DATA oColumnValor

   METHOD Create( oDialog )

   METHOD addColumns() 

   METHOD changeBrowse()

   METHOD setColType( uValue )                  INLINE ( ::oColumnValor:nEditType := uValue )

   METHOD setColPicture( uValue )               INLINE ( ::oColumnValor:cEditPicture := uValue )

   METHOD setColListTxt( aValue )               INLINE ( ::oColumnValor:aEditListTxt := aValue )

   METHOD fieldGetPicture()                     INLINE ( NumPict( ::getRowSet():fieldget( "longitud" ) + ::getRowSet():fieldget( "decimales" ) - 1, ::getRowSet():fieldget( "decimales" ) ) )
   
   METHOD fieldGetTipo()                        INLINE ( alltrim( ::getRowSet():fieldGet( 'tipo' ) ) )

   METHOD fieldGetTipoNumerico()                INLINE ( ::fieldGetTipo() == "Número" )
   METHOD fieldGetTipoTexto()                   INLINE ( ::fieldGetTipo() == "Texto" )
   METHOD fieldGetTipoFecha()                   INLINE ( ::fieldGetTipo() == "Fecha" )
   METHOD fieldGetTipoLogico()                  INLINE ( ::fieldGetTipo() == "Lógico" )
   METHOD fieldGetTipoLista()                   INLINE ( ::fieldGetTipo() == "Lista" )

   METHOD fieldGetValor()

   METHOD fieldGetValorPicture()                INLINE ( ::fieldGetValor( .t. ) )
   
   METHOD fieldPutValor( uValue )               

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Create( oDialog ) CLASS CamposExtraValoresBrowseView

   ::oBrowse                  := SQLXBrowse():New( self, oDialog )
   ::oBrowse:l2007            := .f.

   ::oBrowse:lRecordSelector  := .f.
   ::oBrowse:lSortDescend     := .f.  
   ::oBrowse:lFooter          := .f.
   ::oBrowse:lFastEdit        := .t.
   ::oBrowse:nMarqueeStyle    := MARQSTYLE_HIGHLCELL

   // Propiedades del control--------------------------------------------------

   ::oBrowse:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrowse:bChange          := {|| ::ChangeBrowse() }

   ::oBrowse:setRowSet( ::getRowSet() )

   ::oBrowse:nColSel          := 2

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CamposExtraValoresBrowseView

   with object ( ::oBrowse:AddCol() )
      :cHeader                   := 'Nombre'
      :nWidth                    := 200
      :bEditValue                := {|| ::getRowSet():fieldGet( 'nombre' ) }
   end with 

   ::oColumnValor                := ::oBrowse:AddCol() 
   ::oColumnValor:cHeader        := 'Valor'
   ::oColumnValor:nWidth         := 300
   ::oColumnValor:bEditValue     := {|| ::fieldGetValor() }
   ::oColumnValor:bStrData       := {|| ::fieldGetValorPicture() }
   ::oColumnValor:bOnPostEdit    := {|o,x| ::fieldPutValor( x ) }
   ::oColumnValor:nEditType      := 1
   ::oColumnValor:nDataStrAlign  := 3
   ::oColumnValor:nHeadStrAlign  := 3
   ::oColumnValor:nFootStrAlign  := 3

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ChangeBrowse() CLASS CamposExtraValoresBrowseView

   do case
      case ( ::fieldGetTipoTexto() )

         ::setColType( EDIT_GET )
         ::setColPicture( "" )

      case ( ::fieldGetTipoNumerico() )

         ::setColType( EDIT_GET )
         ::setColPicture( ::fieldGetPicture(), , .t. ) 

      case ( ::fieldGetTipoFecha() )
         
         ::setColType( EDIT_GET )
         ::setColPicture( "" ) 
                           
      case ( ::fieldGetTipoLogico() )

         ::setColType( EDIT_LISTBOX )
         ::setColListTxt( { "Si", "No" } )
         ::setColPicture( "" )

      case ( ::fieldGetTipoLista() )

         ::setColType( EDIT_LISTBOX )
         ::setColListTxt( hb_deserialize( ::getRowSet():fieldget( "lista" ) ) )
         ::setColPicture( "" ) 

   end case

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD fieldPutValor( uValue ) CLASS CamposExtraValoresBrowseView              

   local uuidValor   := ::getRowSet():fieldget( "valor_uuid" )

   if empty( uuidValor )
      RETURN ( Self )
   end if 

   uValue            := alltrim( cValToStr( uValue ) )

   if ( ::fieldGetTipoNumerico() )
      uValue         := strtran( uValue, ",", "." )
   end if 
   
   ::oController:oModel:updateValorWhereUuid( uuidValor, uValue )

   ::getRowSet():Refresh()

   ::oBrowse:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD fieldGetValor( lPicture ) CLASS CamposExtraValoresBrowseView              

   local uValor      := ::getRowSet():fieldget( "valor" )

   DEFAULT lPicture  := .f.

   do case
      case ( ::fieldGetTipoNumerico() )

         uValor      := val( alltrim( uValor ) )

         if lPicture 
            uValor   := trans( uValor, ::fieldGetPicture() )
         end if 

      case ( ::fieldGetTipoFecha() )
         
         uValor      := ctod( alltrim( uValor ) )

   end case

RETURN ( uValor )

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

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CAMPOS_EXTRA_VALORES" ;
      TITLE       ::LblTitle() + "valor"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_form_plus2_48" ;
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

   ::hValidators  := {  "campo_extra_relacion_uuid"   => {  "required"     => "El lugar donde se encuentra el campo extra es un dato requerido"},; 
                        "uuid_registro"               => {  "required"     => "El Registro es un dato requerido",;
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

   DATA cTableName                              INIT "campos_extra_valores"

   DATA cConstraints                            INIT "PRIMARY KEY ( id ), UNIQUE KEY ( campo_extra_entidad_uuid, entidad_uuid )"

   DATA cColumnOrder                            INIT "nombre"                  

   METHOD getInitialSelect()

   METHOD getColumns()

   METHOD getListaAttribute( value )            INLINE ( if( empty( value ), {}, hb_deserialize( value ) ) )

   METHOD setListaAttribute( value )            INLINE ( hb_serialize( value ) )

   METHOD updateValorWhereUuid( uuid, uValue )  INLINE ( ::updateFieldWhereUuid( uuid, 'valor', uValue ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLCamposExtraValoresModel

   local cSQL  

   cSQL        := "SELECT "
   cSQL        +=       "campos.nombre as nombre, "
   cSQL        +=       "campos.tipo as tipo, "
   cSQL        +=       "campos.longitud as longitud, "
   cSQL        +=       "campos.decimales as decimales, "
   cSQL        +=       "campos.lista as lista, "
   cSQL        +=       "valores.valor as valor, "
   cSQL        +=       "valores.uuid as valor_uuid, "
   cSQL        +=       "entidad.parent_uuid "
   cSQL        +=    "FROM " + ::cTableName + " valores "
   cSQL        +=    "INNER JOIN " + SQLCamposExtraEntidadesModel():cTableName + " entidad ON entidad.uuid = valores.campo_extra_entidad_uuid "
   cSQL        +=    "INNER JOIN " + SQLCamposExtraModel():cTableName + " campos ON campos.uuid = entidad.parent_uuid "

   if !empty( ::oController )
      cSQL     += "WHERE entidad.entidad = " + quoted( ::oController:cEntidad )
   end if 

RETURN ( cSQL)

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

