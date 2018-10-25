#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SituacionesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()        INLINE( if( empty( ::oBrowseView ), ::oBrowseView := SituacionesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()        INLINE( if( empty( ::oDialogView ), ::oDialogView := SituacionesView():New( self ), ), ::oDialogView )

   METHOD getValidator()         INLINE( if( empty( ::oValidator ), ::oValidator := SituacionesValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLSituacionesModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS SituacionesController

   ::Super:New()

   ::cTitle                := "Situaciones"

   ::cName                 := "situaciones"

   ::hImage                := { "16" => "gc_document_attachment_16" }

   ::nLevel                := Auth():Level( ::cName )


RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS SituacionesController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oDialogView)
      ::oDialogView:End()
   end if 

   if !empty( ::oValidator )
      ::oValidator:End()
   end if 

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SituacionesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS SituacionesBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'descripcion'
      :cHeader             := 'Descripción'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descripcion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnDeletedAt()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SituacionesView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS SituacionesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "SITUACION" ;
      TITLE       ::LblTitle() + "sutiaciones"

   REDEFINE GET   ::oController:getModel():hBuffer[ "descripcion" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "descripcion" ) ) ;
      OF          ::oDialog

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//--------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SituacionesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS SituacionesValidator

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la situación es un dato requerido",;
                                       "unique"       => "El nombre de la situación ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLSituacionesModel FROM SQLCompanyModel

   DATA cColumnCode              INIT "nombre"

   DATA cTableName               INIT "situaciones"

   DATA cConstraints             INIT "PRIMARY KEY ( descripcion, deleted_at )"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLSituacionesModel

   hset( ::hColumns, "id",          {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                       "text"      => "Identificador"                           ,;
                                       "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",        {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                       "text"      => "Uuid"                                    ,;
                                       "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "descripcion", {  "create"    => "VARCHAR( 140 )"                          ,;
                                       "default"   => {|| space( 140 ) } }                       )

   ::getDeletedStampColumn()

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

CLASS SituacionesRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( if( !empty( ::getController() ), ::getModelTableName(), SQLSituacionesModel():getTableName() ) )

   //METHOD getNombres() 

END CLASS

//---------------------------------------------------------------------------//

/*METHOD getNombres() CLASS SituacionesRepository

   local cSentence               := "SELECT nombre FROM " + ::getTableName()
   local aNombres                := ::getDatabase():selectFetchArrayOneColumn( cSentence )

RETURN ( aNombres )*/

//---------------------------------------------------------------------------//