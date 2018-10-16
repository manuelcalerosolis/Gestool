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

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
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
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
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

CLASS SituacionesView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS SituacionesView

   local oDlg
   local oGetNombre

   DEFINE DIALOG oDlg RESOURCE "SITUACION" TITLE ::LblTitle() + "situaci�n"

   REDEFINE GET   oGetNombre ;
      VAR         ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          100 ;
      MEMO ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDlg

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( oDlg ), oDlg:end( IDOK ), ) }, oDlg, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| oDlg:end() }, oDlg, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   oDlg:bKeyDown   := {| nKey | if( nKey == VK_F5, oDlg:end( IDOK ), ) }

   if ::oController:isNotZoomMode() 
      oDlg:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( oDlg ), oDlg:end( IDOK ), ) }
   end if

   // evento bstart-----------------------------------------------------------

   oDlg:bStart    := {|| oGetNombre:setFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult )

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

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la situaci�n es un dato requerido",;
                                       "unique"       => "El nombre de la situaci�n ya existe" } } 

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

   hset( ::hColumns, "nombre",      {  "create"    => "VARCHAR( 140 )"                          ,;
                                       "default"   => {|| space( 140 ) } }                       )

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

   METHOD getNombres() 

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS SituacionesRepository

   local cSentence               := "SELECT nombre FROM " + ::getTableName()
   local aNombres                := ::getDatabase():selectFetchArrayOneColumn( cSentence )

RETURN ( aNombres )

//---------------------------------------------------------------------------//