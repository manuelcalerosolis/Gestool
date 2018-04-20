#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS LineasComentariosController FROM SQLBrowseController

   METHOD New()

   METHOD loadedBlankBuffer()

   METHOD gettingSelectSentence()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS LineasComentariosController

   ::Super:New( oSenderController )

   ::lTransactional              := .t.

   ::cTitle                      := "Lineas de comentarios"

   ::cName                       := "lineas de comentarios"

   ::oModel                      := SQLLineasComentariosModel():New( self )

   ::oBrowseView                 := LineasComentariosBrowseView():New( self )

   ::oDialogView                 := LineasComentariosView():New( self )

   ::oValidator                  := LineasComentariosValidator():New( self, ::oDialogView )

   ::setEvent( 'appended',                      {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',                        {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::oBrowseView:Refresh() } )

   ::oModel:setEvent( 'loadedBlankBuffer',      {|| ::loadedBlankBuffer() } ) 
   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS LineasComentariosController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      hset( ::oModel:hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS LineasComentariosController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
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
//---------------------------------------------------------------------------//

CLASS LineasComentariosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS LineasComentariosBrowseView

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
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descripcion' ) }
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

CLASS LineasComentariosView FROM SQLBaseView

   METHOD Activate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS LineasComentariosView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "LINEACOMENTARIO" ;
      TITLE       ::LblTitle() + "lineas de comentarios"

   REDEFINE GET   ::oController:oModel:hBuffer[ "descripcion" ] ;
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

CLASS LineasComentariosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS LineasComentariosValidator

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

CLASS SQLLineasComentariosModel FROM SQLBaseModel

   DATA cTableName                     INIT "lineas_comentarios"

   METHOD getColumns()

   METHOD getIdWhereParentUuid( uuid ) INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLLineasComentariosModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR(40) NOT NULL "                   ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "descripcion",       {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )
 

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS LineasComentariosRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLLineasComentariosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//