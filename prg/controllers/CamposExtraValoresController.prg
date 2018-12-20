#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CamposExtraValoresGestoolController FROM CamposExtraValoresController

   METHOD getConfiguracionVistasController() ;
                                       INLINE ( if( empty( ::oConfiguracionVistasController ), ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ), ), ::oConfiguracionVistasController )

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLCamposExtraValoresGestoolModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

CLASS CamposExtraValoresController FROM SQLBrowseController

   DATA cEntidad

   DATA uuidEntidad

   DATA oCamposExtraValoresController

   METHOD New( oController, cEntidad ) CONSTRUCTOR

   METHOD End()

   METHOD setEntidad( cEntidad )       INLINE ( ::cEntidad := cEntidad )

   METHOD setUuidEntidad( uuidEntidad ) ;
                                       INLINE ( ::uuidEntidad := uuidEntidad )

   METHOD Edit( uuidEntidad ) 

   METHOD assertCamposExtraValores()

   METHOD insertIgnoreCamposExtraValores( hValor )

   METHOD gettingSelectSentence()

   METHOD deleteBuffer( aUuidEntidades )

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLCamposExtraValoresModel():New( self ), ), ::oModel )

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := CamposExtraValoresBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := CamposExtraValoresView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator  ), ::oValidator  := CamposExtraValoresValidator():New( self ), ), ::oValidator )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CamposExtraValoresController

   ::Super:New( oController )

   ::setEntidad( oController:getModel():cTableName ) 

   ::cTitle                            := "Campos extra valores"

   ::cName                             := "campos_extra_valores" 

   ::lTransactional                    := .t.

   ::hImage                            := {  "16" => "gc_form_plus2_16",;
                                             "32" => "gc_form_plus2_32",;
                                             "48" => "gc_form_plus2_48" }

   ::getModel()

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )   

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CamposExtraValoresController

   ::oModel:End()

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oValidator )
      ::oValidator:End()
   end if 

   ::Super:End()

RETURN ( nil )

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

   ::getRowSet():buildPad( ::getModel():getSelectSentence() )

   ::beginTransactionalMode()

   if ::DialogViewActivate()
      
      ::commitTransactionalMode()

   else

      ::rollbackTransactionalMode()

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD assertCamposExtraValores() CLASS CamposExtraValoresController

   local aValores  

   aValores          := ::oModel:getHashCampoExtraValoresWhereEntidad( ::cEntidad )

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
   
   ::oModel:insertIgnore( hBuffer )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS CamposExtraValoresController

   if !empty( ::uuidEntidad  )
      ::oModel:setGeneralWhere( "entidad_uuid = " + quoted( ::uuidEntidad ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS CamposExtraValoresController

   if empty( aUuidEntidades )
      RETURN ( nil )
   end if

   ::getModel():deleteWhereParentUuid( aUuidEntidades )

RETURN ( nil )
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

   ::oBrowse:nColSel          := 3

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
         ::setColPicture( "@!" )

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
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::oController:getBrowseView():ActivateDialog( ::oDialog, 100 )

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
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
                        "uuid_registro"               => {  "required"     => "El registro es un dato requerido",;
                                                            "unique"       => "El registro introducido ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCamposExtraValoresGestoolModel FROM SQLCamposExtraValoresModel

   METHOD getTableName()                              INLINE ( "gestool." + ::cTableName )

   METHOD getSQLCamposExtraModelTableName()           INLINE ( SQLCamposExtraGestoolModel():getTableName() )

   METHOD getSQLCamposExtraEntidadesModelTableName()  INLINE ( SQLCamposExtraEntidadesGestoolModel():getTableName() )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCamposExtraValoresModel FROM SQLCompanyModel

   DATA cTableName                                    INIT "campos_extra_valores"

   DATA cConstraints                                  INIT "PRIMARY KEY ( campo_extra_entidad_uuid, entidad_uuid, deleted_at )"

   DATA cColumnOrder                                  INIT "nombre"                  

   METHOD getInitialSelect()

   METHOD getColumns()

   METHOD getListaAttribute( value )                  INLINE ( if( empty( value ), {}, hb_deserialize( value ) ) )

   METHOD setListaAttribute( value )                  INLINE ( hb_serialize( value ) )

   METHOD updateValorWhereUuid( uuid, uValue )        INLINE ( ::updateFieldWhereUuid( uuid, 'valor', uValue ) )

   METHOD getSQLCamposExtraModelTableName()           INLINE ( SQLCamposExtraModel():getTableName() )

   METHOD getSQLCamposExtraEntidadesModelTableName()  INLINE ( SQLCamposExtraEntidadesModel():getTableName() )

   METHOD getSentenceCampoExtraValoresWhereEntidad( cEntidad )

   METHOD getHashCampoExtraValoresWhereEntidad( cEntidad )

   METHOD duplicateOthers( uuidEntidad )

   METHOD getSentenceOthersWhereParentUuid ( uuidParent ) 

   METHOD SQLUpdateDeletedAtSentenceWhereParentUuid( uUuid )

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLCamposExtraValoresModel

local cSql

   TEXT INTO cSql

   SELECT 
      campos.nombre as nombre,
      campos.tipo as tipo, 
      campos.longitud as longitud,
      campos.decimales as decimales,
      campos.lista as lista, 
      %1$s.valor as valor, 
      %1$s.uuid as valor_uuid, 
      entidad.parent_uuid 

   FROM %1$s 

   INNER JOIN %2$s AS entidad 
      ON entidad.uuid = %1$s.campo_extra_entidad_uuid 

   INNER JOIN %3$s AS campos 
      ON campos.uuid = entidad.parent_uuid

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLCamposExtraEntidadesModel():getTableName(), SQLCamposExtraModel():getTableName(), quoted( ::oController:cEntidad ) )

   if !empty( ::oController )
      cSQL     += " WHERE entidad.entidad = " + quoted( ::oController:cEntidad )
   end if 

RETURN ( cSQL)

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCamposExtraValoresModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "campo_extra_entidad_uuid",   {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "entidad_uuid",               {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "valor",                      {  "create"    => "VARCHAR( 200 )"                          ,;
                                                      "default"   => {|| space( 200 ) } }                      )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getSentenceCampoExtraValoresWhereEntidad( cEntidad ) CLASS SQLCamposExtraValoresModel

local cSql

   TEXT INTO cSql

   SELECT entidad.id, 
      entidad.uuid,
      entidad.parent_uuid, 
      entidad.entidad,
      campos.nombre,
      valores.valor 

   FROM %1$s AS entidad 

   INNER JOIN %2$s AS campos 
      ON entidad.parent_uuid = campos.uuid 

   LEFT JOIN %3$s AS valores 
      ON valores.campo_extra_entidad_uuid = entidad.uuid 

   WHERE entidad =  %4$s

   ENDTEXT

   cSql  := hb_strformat( cSql, SQLCamposExtraEntidadesModel():getTableName(), SQLCamposExtraModel():getTableName(), ::getTableName(), quoted( cEntidad ) )

RETURN ( cSQL )

//---------------------------------------------------------------------------//

METHOD getHashCampoExtraValoresWhereEntidad( cEntidad ) CLASS SQLCamposExtraValoresModel

RETURN ( getSQLDataBase():selectFetchHash( ::getSentenceCampoExtraValoresWhereEntidad( cEntidad ) ) )

//---------------------------------------------------------------------------//

METHOD duplicateOthers( uuidEntidad )

   local hOthers
   local aOthers 

   aOthers         := ::getHashOthersWhereParentUuid( ::getUuidOlderParent() )

   if empty( aOthers )
      RETURN ( nil )
   end if 

   for each hOthers in aOthers

      hset( hOthers, "id",          0 )

      hset( hOthers, "uuid",        win_uuidcreatestring() )
      
      hset( hOthers, "entidad_uuid", uuidEntidad )
      
      hset( hOthers, "deleted_at",  hb_datetime( nil, nil, nil, nil, nil, nil, nil ) )

      ::insertBuffer( hOthers )

   next 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getSentenceOthersWhereParentUuid ( uuidParent ) CLASS SQLCamposExtraValoresModel

   local cSql

   TEXT INTO cSql

   SELECT *

      FROM %1$s

      WHERE entidad_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidParent ) )

RETURN ( cSql )

//----------------------------------------------------------------------------//

METHOD SQLUpdateDeletedAtSentenceWhereParentUuid( uUuid ) CLASS SQLCamposExtraValoresModel

   local cSentence

      cSentence   := "UPDATE " + ::getTableName() + " " + ;
                        "SET deleted_at = NOW() " + ; 
                        "WHERE entidad_uuid IN ( "
   
      aeval( uUuid, {| v | cSentence += if( hb_isarray( v ), toSQLString( atail( v ) ), toSQLString( v ) ) + ", " } )

      cSentence         := chgAtEnd( cSentence, ' )', 2 )

RETURN ( cSentence )

//---------------------------------------------------------------------------//
