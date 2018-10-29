#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DocumentosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()            INLINE ( ::getModel():loadBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::getModel():insertBuffer() )

   METHOD loadedBlankBuffer()

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   METHOD getBrowseView()           INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := DocumentosBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()           INLINE ( if( empty( ::oDialogView ), ::oDialogView := DocumentosView():New( self ), ), ::oDialogView )

   METHOD getValidator()            INLINE ( if( empty( ::oValidator ), ::oValidator  := DocumentosValidator():New( self ), ), ::oValidator )

   METHOD getRepository()           INLINE ( if( empty( ::oRepository ), ::oRepository := DocumentosRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                INLINE ( if( empty( ::oModel ), ::oModel := SQLDocumentosModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS DocumentosController

   ::Super:New( oController )

   ::cTitle                         := "Documentos"

   ::cName                          := "documentos"

   ::hImage                         := {  "16" => "gc_document_text_gear_16",;
                                          "32" => "gc_document_text_gear_32",;
                                          "48" => "gc_document_text_gear_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS DocumentosController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oValidator )
      ::oValidator:End()
   end if 

   if !empty( ::oRepository )
      ::oRepository:End()
   end if 

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS DocumentosController

   local uuid        := ::getController():getUuid() 

   if !empty( uuid )
      hset( ::getModel():hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS DocumentosController

   local uuid        := ::getController():getUuid()  
   if !empty( uuid )
      ::getModel():setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuidEntidad ) CLASS DocumentosController

   local idDocumento     

   if empty( uuidEntidad )
      ::getModel():insertBuffer()
   end if 

   idDocumento          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idDocumento )
      idDocumento      := ::getModel():insertBlankBuffer()
   end if 

   ::getModel():loadCurrentBuffer( idDocumento )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS DocumentosController

   local idDocumento     

   idDocumento          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idDocumento )
      ::getModel():insertBuffer()
      RETURN ( nil )
   end if 

   ::getModel():updateBuffer()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) CLASS DocumentosController

   local idDocumento     

   idDocumento          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idDocumento )
      ::getModel():insertBuffer()
      RETURN ( nil )
   end if 

   ::getModel():loadDuplicateBuffer( idDocumento )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS DocumentosController

   hset( ::getModel():hBuffer, "parent_uuid", uuidEntidad )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS DocumentosController

   if empty( aUuidEntidades )
      RETURN ( nil )
   end if

   ::getModel():deleteWhereParentUuid( aUuidEntidades )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DocumentosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS DocumentosBrowseView

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
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 130
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'documento'
      :cHeader             := 'Documento'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'documento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'observacion'
      :cHeader             := 'Observación'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'observacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DocumentosView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS DocumentosView

   local oDocumento
   local oGetDocumento

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DOCUMENTO" ;
      TITLE       ::LblTitle() + "documento"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog 

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog 

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog 

   REDEFINE GET   oGetDocumento ;
      VAR         ::oController:getModel():hBuffer[ "documento" ] ;
      ID          110 ;
      BITMAP      "Folder" ;
      ON HELP     ( GetDocumento( oGetDocumento, oDocumento ) ) ;
      ON CHANGE   ( ChgDoc( oGetDocumento, oDocumento ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "observacion" ] ;
      ID          120 ;
      MEMO ;
      WHEN        (::oController:isNotZoomMode() ) ;
      OF          ::oDialog 

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

CLASS DocumentosValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DocumentosValidator

   ::hValidators  := {  "nombre" =>    {  "required"  => "El nombre es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDocumentosModel FROM SQLCompanyModel

   DATA cTableName               INIT "documentos"

   DATA cConstraints             INIT "PRIMARY KEY ( parent_uuid, nombre, deleted_at )"

   METHOD getColumns()

   METHOD getIdWhereParentUuid( uuid ) ;           
                                 INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD updateDocumentoWhereUuid( uValue, uuid ) ;
                                 INLINE ( ::updateFieldWhereUuid( uuid, 'ruta_documento', uValue ) )

   METHOD setDocumentoAttribute( uValue )             

   METHOD getParentUuidAttribute( value )

   METHOD getSentenceOthersWhereParentUuid ( uuidParent )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDocumentosModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"             ,;                          
                                                   "default"   => {|| 0 } }                                   )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"               ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }              )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                    ,;
                                                   "default"   => {|| space( 40 ) } }                         )

   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR( 200 ) NOT NULL"                            ,;
                                                   "default"   => {|| space( 200 ) } }                        )

   hset( ::hColumns, "documento",               {  "create"    => "VARCHAR ( 200 )"                           ,;
                                                   "default"   => {|| space( 200 ) } }                        )

   hset( ::hColumns, "observacion",             {  "create"    => "TEXT"                                      ,;
                                                   "default"   => {|| "" } }                                  )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getParentUuidAttribute( value ) CLASS SQLDocumentosModel

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oController )
      RETURN ( value )
   end if

RETURN ( ::oController:oController:getUuid() )

//---------------------------------------------------------------------------//

METHOD SetDocumentoAttribute( uValue )

   local cNombreDocumento

   if empty( uValue ) .or. isDocumentInApplicationStorage( uValue )
      RETURN ( uValue )
   end if      
   if empty( ::oController ) .or. empty( ::oController:oController )
      RETURN ( uValue )
   end if       

   cNombreDocumento           := alltrim( ::oController:oController:getModel():hBuffer[ "nombre" ] ) 
   cNombreDocumento           += '(' + alltrim( ::hBuffer[ "uuid" ] ) + ')' + '.' 
   cNombreDocumento           += lower( getFileExt( uValue ) ) 

   if !( copyfile( uValue, cPathDocumentApplicationStorage() + cNombreDocumento ) )
   
      RETURN ( uValue )
   end if      

RETURN ( cRelativeDocumentApplicationStorage() + cNombreDocumento )

//---------------------------------------------------------------------------//

METHOD getSentenceOthersWhereParentUuid ( uuidParent ) CLASS SQLDocumentosModel

   local cSql

   TEXT INTO cSql

   SELECT *

      FROM %1$s

      WHERE parent_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidParent ) )


RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DocumentosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLDocumentosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//