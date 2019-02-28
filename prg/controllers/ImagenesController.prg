#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImagenesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD loadedBlankBuffer()

   METHOD loadMainBlankBuffer()        INLINE ( ::getModel():loadMainBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::getModel():insertBuffer() )

   METHOD LoadedCurrentBuffer( uuidEntidad )
   METHOD UpdateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := ImagenesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := ImagenesView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := ImagenesValidator():New( self ), ), ::oValidator )

   METHOD getModel()                      INLINE( if( empty( ::oModel ), ::oModel := SQLImagenesModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ImagenesController

   ::Super:New( oController )

   ::lTransactional        := .t.

   ::cTitle                := "Imagenes"

   ::cName                 := "imagenes"

   ::hImage                := {  "16" => "gc_photo_landscape_16",;
                                 "32" => "gc_photo_landscape_32",;
                                 "48" => "gc_photo_landscape_48" }

   // ::setEvent( 'appended',                      {|| ::oBrowseView:Refresh() } )
   // ::setEvent( 'edited',                        {|| ::oBrowseView:Refresh() } )
   // ::setEvent( 'deletedSelection',              {|| ::oBrowseView:Refresh() } )

   // ::getModel():setEvent( 'loadedBlankBuffer',      {|| ::loadedBlankBuffer() } ) 
   // ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ImagenesController
   
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

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS ImagenesController

   local uuid        := ::oController:getUuid() 

   if !empty( uuid )
      hset( ::getModel():hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuidEntidad ) CLASS ImagenesController

   local idImagen     

   if empty( uuidEntidad )
      ::getModel():insertBuffer()
   end if 

   idImagen          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idImagen )
      idImagen       := ::getModel():insertPrincipalBlankBuffer()
   end if 

   ::getModel():loadCurrentBuffer( idImagen )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS ImagenesController

   local idImagen     

   idImagen          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idImagen )
      ::getModel():insertBuffer()
      RETURN ( self )
   end if 

   ::getModel():updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) CLASS ImagenesController

   local idImagen     

   idImagen          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idImagen )
      ::getModel():insertBuffer()
      RETURN ( self )
   end if 

   ::getModel():loadDuplicateBuffer( idImagen )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS ImagenesController

   hset( ::getModel():hBuffer, "parent_uuid", uuidEntidad )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS ImagenesController

   if empty( aUuidEntidades )
      RETURN ( self )
   end if

   ::getModel():deleteWhereParentUuid( aUuidEntidades )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ImagenesBrowseView FROM SQLBrowseView

   METHOD Create( oWindow ) 

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Create( oWindow ) CLASS ImagenesBrowseView

   ::Super:Create( oWindow )

   ::oBrowse:nRowHeight       := 100
   ::oBrowse:nDataLines       := 2

RETURN ( ::oBrowse )

//---------------------------------------------------------------------------//

METHOD addColumns() CLASS ImagenesBrowseView

   ::getColumnIdAndUuid()

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
      :nWidth              := 400
      :bEditValue          := {|| ::getRowSet():fieldGet( 'imagen' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := ""
      :nEditType           := TYPE_IMAGE
      :lBmpStretch         := .f.
      :lBmpTransparent     := .t.
      :bStrImage           := {|| cFileBmpName( ::getRowSet():fieldGet( 'imagen' ) ) }
      :nDataBmpAlign       := AL_CENTER
      :nWidth              := 100
   end with

   ::getColumnDeletedAt()

RETURN ( self )

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

   local oGetImagen
   local oBmpImagen

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "IMAGEN" ;
      TITLE       ::LblTitle() + "imagenes"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   oGetImagen ;
      VAR         ::oController:getModel():hBuffer[ "imagen" ] ;
      ID          100 ;
      BITMAP      "Folder" ;
      ON HELP     ( GetBmp( oGetImagen, oBmpImagen ) ) ;
      ON CHANGE   ( ChgBmp( oGetImagen, oBmpImagen ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "imagen" ) ) ;
      OF          ::oDialog

   REDEFINE IMAGE oBmpImagen ;
      ID          110 ;
      FILE        cFileBmpName( ::oController:getModel():hBuffer[ "imagen" ] ) ;
      OF          ::oDialog

   oBmpImagen:setColor( , getsyscolor( 15 ) )
   oBmpImagen:bLClicked   := {|| ShowImage( oBmpImagen ) }
   oBmpImagen:bRClicked   := {|| ShowImage( oBmpImagen ) }

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

CLASS ImagenesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ImagenesValidator

   ::hValidators  := {  "imagen" => {  "required"  => "La imagen es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLImagenesModel FROM SQLCompanyModel

   DATA cTableName                                 INIT "imagenes"

   DATA cConstraints                               INIT "PRIMARY KEY ( parent_uuid, imagen, deleted_at )"

   METHOD getColumns()

   METHOD loadMainBlankBuffer()               INLINE ( ::loadBlankBuffer(), hset( ::hBuffer, "principal", .t. ) )

   METHOD insertPrincipalBlankBuffer()             INLINE ( ::loadMainBlankBuffer(), ::insertBuffer() ) 

   METHOD getIdWhereParentUuid( uuid )             INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD updateImagenWhereUuid( uValue, uuid )    INLINE ( ::updateFieldWhereUuid( uuid, 'imagen', uValue ) )
   
   METHOD setImagenAttribute( uValue )             

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLImagenesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR ( 40 ) NOT NULL "                 ,;
                                             "default"   => {|| ::getControllerParentUuid() } } )

   hset( ::hColumns, "imagen",            {  "create"    => "VARCHAR ( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "principal",         {  "create"    => "TINYINT( 1 )"                            ,;
                                             "default"   => {|| .f. } }                               )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD SetImagenAttribute( uValue )

   local cNombreImagen

   if empty( uValue ) .or. isImageInApplicationStorage( uValue )
      RETURN ( uValue )
   end if       

   if empty( ::oController ) .or. empty( ::oController:oController )
      RETURN ( uValue )
   end if       

   cNombreImagen           := alltrim( ::oController:oController:getModel():hBuffer[ "nombre" ] ) 
   cNombreImagen           += '(' + alltrim( ::oController:oController:getModel():hBuffer[ "uuid" ] ) + ')' + '.' 
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

   METHOD getTableName()         INLINE ( SQLImagenesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//