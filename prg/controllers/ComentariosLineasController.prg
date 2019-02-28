#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ComentariosLineasController FROM SQLBrowseController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD loadedBlankBuffer()

   METHOD gettingSelectSentence()

   //Contrucciones tardias-----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := ComentariosLineasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := ComentariosLineasView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := ComentariosLineasValidator():New( self ), ), ::oValidator )
   
   METHOD getModel()                      INLINE( if( empty( ::oModel ), ::oModel := SQLComentariosLineasModel():New( self ), ), ::oModel )

   
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ComentariosLineasController

   ::Super:New( oController )

   ::lTransactional              := .t.

   ::cTitle                      := "Lineas de comentarios"

   ::cName                       := "lineas de comentarios"

   ::setEvent( 'appended',                      {|| ::getBrowseView():Refresh() } )
   ::setEvent( 'edited',                        {|| ::getBrowseView():Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::getBrowseView():Refresh() } )

   ::getModel():setEvent( 'loadedBlankBuffer',      {|| ::loadedBlankBuffer() } ) 
   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS ComentariosLineasController
   
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

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS ComentariosLineasController

   local uuid        := ::oController():getUuid() 

   if !empty( uuid )
      hset( ::getModel():hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS ComentariosLineasController

   local uuid        := ::oController():getUuid() 

   if !empty( uuid )
      ::getModel():setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ComentariosLineasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ComentariosLineasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
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
      :cHeader             := 'Parent_Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'parent_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'descripcion'
      :cHeader             := 'Descripcion'
      :nWidth              := 480
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descripcion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ComentariosLineasView FROM SQLBaseView

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ComentariosLineasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "COMENTARIO_LINEA" ;
      TITLE       ::LblTitle() + "lineas de comentarios"

   REDEFINE GET   ::oController:getModel():hBuffer[ "descripcion" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog


   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ACTIVATE DIALOG ::oDialog CENTER

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
//---------------------------------------------------------------------------//

CLASS ComentariosLineasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ComentariosLineasValidator

   ::hValidators  := {  "descripcion" =>          {  "required"        => "La descripción es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLComentariosLineasModel FROM SQLCompanyModel

   DATA cTableName                     INIT "articulos_familias_comentarios_lineas"

   METHOD getColumns()

   METHOD getIdWhereParentUuid( uuid ) INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLComentariosLineasModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"             ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR ( 40 ) NOT NULL"                    ,;
                                             "default"   => {|| ::getControllerParentUuid() } } )

   hset( ::hColumns, "descripcion",       {  "create"    => "VARCHAR ( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ComentariosLineasRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLComentariosLineasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//