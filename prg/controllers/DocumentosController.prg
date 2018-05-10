#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DocumentosController FROM SQLBrowseController

   METHOD New()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()            INLINE ( ::oModel:loadBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::oModel:insertBuffer() )

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS DocumentosController

   ::Super:New( oSenderController )

   ::cTitle                      := "Documentos"

   ::cName                       := "documentos"

   ::hImage                      := {  "16" => "gc_document_text_gear_16",;
                                       "32" => "gc_document_text_gear_32",;
                                       "48" => "gc_document_text_gear_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLDocumentosModel():New( self )

   ::oBrowseView                    := DocumentosBrowseView():New( self )

   ::oDialogView                    := DocumentosView():New( self )

   ::oValidator                     := DocumentosValidator():New( self, ::oDialogView )

   ::oRepository                    := DocumentosRepository():New( self )

   ::setEvent( 'appended',                      {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',                        {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::oBrowseView:Refresh() } )

   ::oModel:setEvent( 'loadedBlankBuffer',      {|| ::loadedBlankBuffer() } ) 
   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )


RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS DocumentosController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS DocumentosController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuidEntidad ) CLASS DocumentosController

   local idDocumento     

   if empty( uuidEntidad )
      ::oModel:insertBuffer()
   end if 

   idDocumento          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDocumento )
      idDocumento      := ::oModel:insertBlankBuffer()
   end if 

   ::oModel:loadCurrentBuffer( idDocumento )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS DocumentosController

   local idDocumento     

   idDocumento          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDocumento )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) CLASS DocumentosController

   local idDocumento     

   idDocumento          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDocumento )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:loadDuplicateBuffer( idDocumento )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS DocumentosController

   hset( ::oModel:hBuffer, "parent_uuid", uuidEntidad )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS DocumentosController

   if empty( aUuidEntidades )
      RETURN ( self )
   end if

   ::oModel:deleteWhereParentUuid( aUuidEntidades )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
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
      :cSortOrder          := 'ruta_documento'
      :cHeader             := 'Documento'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'ruta_documento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'observacion'
      :cHeader             := 'Observación'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'observacion' ) }
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

CLASS DocumentosView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS DocumentosView

   local oDialog
   local oGetDocumento
   local oDocumento
   local oBmpGeneral

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DOCUMENTO" ;
      TITLE       ::LblTitle() + "documento"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_document_text_gear_48" ;
      TRANSPARENT ;
      OF          ::oDialog 

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog 

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog 

   REDEFINE GET   oGetDocumento ;
      VAR         ::oController:oModel:hBuffer[ "ruta" ] ;
      ID          110 ;
      BITMAP      "Folder" ;
      ON HELP     ( GetBmp( oGetDocumento, oDocumento ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "observacion" ] ;
      ID          120 ;
      MEMO ;
      WHEN        (::oController:isNotZoomMode() ) ;
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
      ACTION     ( ::oDialog:end() )

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

CLASS DocumentosValidator FROM SQLBaseValidator

   METHOD getValidators()

 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DocumentosValidator

   ::hValidators  := {  "nombre" =>           {  "required"              => "El nombre es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDocumentosModel FROM SQLBaseModel

   DATA cTableName               INIT "documentos"

   METHOD getColumns()

   /*METHOD getIdWhereParentUuid( uuid ) INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )*/

   METHOD updateDocumentoWhereUuid( uValue, uuid )    INLINE ( ::updateFieldWhereUuid( uuid, 'ruta_documento', uValue ) )

   METHOD SetDocumentoAttribute( uValue )             

   METHOD getParentUuidAttribute( value )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDocumentosModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"             ,;                          
                                                   "default"   => {|| 0 } }                                   )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"               ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }              )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                    ,;
                                                   "default"   => {|| space( 40 ) } }                         )

   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR( 200 )"                            ,;
                                                   "default"   => {|| space( 200 ) } }                        )

   hset( ::hColumns, "ruta_documento",          {  "create"    => "VARCHAR ( 200 )"                           ,;
                                                   "default"   => {|| space( 200 ) } }                        )

   hset( ::hColumns, "observacion",             {  "create"    => "TEXT"                                      ,;
                                                   "default"   => {|| "" } }                                  )
RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
METHOD getParentUuidAttribute( value ) CLASS SQLDocumentosModel

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oSenderController )
      RETURN ( value )
   end if

RETURN ( ::oController:oSenderController:getUuid() )

//---------------------------------------------------------------------------//

METHOD SetDocumentoAttribute( uValue )

   local cNombreDocumento

   if empty( uValue ) .or. isImageInApplicationStorage( uValue )
      RETURN ( uValue )
   end if       

   if empty( ::oController ) .or. empty( ::oController:oSenderController )
      RETURN ( uValue )
   end if       

   cNombreDocumento           := alltrim( ::oController:oSenderController:oModel:hBuffer[ "nombre" ] ) 
   cNombreDocumento           += '(' + alltrim( ::hBuffer[ "uuid" ] ) + ')' + '.' 
   cNombreDocumento           += lower( getFileExt( uValue ) ) 

   if !( copyfile( uValue, cPathImageApplicationStorage() + cNombreDocumento ) )
      RETURN ( uValue )
   end if      

RETURN ( cRelativeImageApplicationStorage() + cNombreDocumento )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DocumentosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLDocumentosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//