#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImagenesController FROM SQLBrowseController

   METHOD New()

   METHOD End()

   METHOD loadedBlankBuffer()

   METHOD gettingSelectSentence()

   METHOD loadPrincipalBlankBuffer()   INLINE ( ::oModel:loadPrincipalBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::oModel:insertBuffer() )

   METHOD LoadedCurrentBuffer( uuidEntidad )
   METHOD UpdateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS ImagenesController

   ::Super:New( oSenderController )

   ::lTransactional        := .t.

   ::cTitle                := "Imagenes"

   ::cName                 := "imagenes"

   ::oModel                := SQLImagenesModel():New( self )

   ::oBrowseView           := ImagenesBrowseView():New( self )

   ::oDialogView           := ImagenesView():New( self )

   ::oValidator            := ImagenesValidator():New( self, ::oDialogView )

   ::setEvent( 'appended',                      {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',                        {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::oBrowseView:Refresh() } )

   ::oModel:setEvent( 'loadedBlankBuffer',      {|| ::loadedBlankBuffer() } ) 
   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS ImagenesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   /*::oRepository:End()*/

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS ImagenesController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      hset( ::oModel:hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS ImagenesController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuidEntidad ) CLASS ImagenesController

   local idImagen     

   if empty( uuidEntidad )
      ::oModel:insertBuffer()
   end if 

   idImagen          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idImagen )
      idImagen       := ::oModel:insertPrincipalBlankBuffer()
   end if 

   ::oModel:loadCurrentBuffer( idImagen )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS ImagenesController

   local idImagen     

   idImagen          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idImagen )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) CLASS ImagenesController

   local idImagen     

   idImagen          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idImagen )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:loadDuplicateBuffer( idImagen )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS ImagenesController

   hset( ::oModel:hBuffer, "parent_uuid", uuidEntidad )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS ImagenesController

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

CLASS ImagenesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ImagenesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
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
      :cSortOrder          := 'parent_uuid'
      :cHeader             := 'Uuid entidad'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'parent_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'imagen'
      :cHeader             := 'Imagen'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'imagen' ) }
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

CLASS ImagenesView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ImagenesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "IMAGEN" ;
      TITLE       ::LblTitle() + "imagenes"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_signpost3_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "imagen" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ImagenesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ImagenesValidator

   ::hValidators  := {  "nombre" =>          {  "required"        => "El nombre es un dato requerido" },; 
                        "direccion" =>       {  "required"        => "La direcci�n es un dato requerido" },; 
                        "email" =>           {  "mail"            => "El email no es valido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLImagenesModel FROM SQLBaseModel

   DATA cTableName                                 INIT "imagenes"

   METHOD getColumns()

   METHOD loadPrincipalBlankBuffer()   INLINE ( ::loadBlankBuffer(), hset( ::hBuffer, "principal", .t. ) )

   METHOD insertPrincipalBlankBuffer() INLINE ( ::loadPrincipalBlankBuffer(), ::insertBuffer() ) 

   METHOD getIdWhereParentUuid( uuid )             INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD updateImagenWhereUuid( uValue, uuid )    INLINE ( ::updateFieldWhereUuid( uuid, 'imagen', uValue ) )
   
   METHOD SetImagenAttribute( uValue )             

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLImagenesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR(40) NOT NULL "                   ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "imagen",            {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "principal",         {  "create"    => "TINYINT ( 1 )"                           ,;
                                             "default"   => {|| "0" } }                               )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD SetImagenAttribute( uValue )

   local cNombreImagen

   if empty( uValue ) .or. isImageInApplicationStorage( uValue )
      RETURN ( uValue )
   end if       

   if empty( ::oController ) .or. empty( ::oController:oSenderController )
      RETURN ( uValue )
   end if       

   cNombreImagen           := alltrim( ::oController:oSenderController:oModel:hBuffer[ "nombre" ] ) 
   cNombreImagen           += '(' + alltrim( ::hBuffer[ "uuid" ] ) + ')' + '.' 
   cNombreImagen           += lower( getFileExt( uValue ) ) 

   if !( copyfile( uValue, cPathImageApplicationStorage() + cNombreImagen ) )
      RETURN ( uValue )
   end if      

RETURN ( cRelativeImageApplicationStorage() + cNombreImagen )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ImagenesRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLDireccionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//