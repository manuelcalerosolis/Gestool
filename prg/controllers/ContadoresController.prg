#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ContadoresController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getTableName()               INLINE ( ::oController:getModel():cTableName )

   METHOD gettingSelectSentence()

   // Construcciones tardias---------------------------------------------------

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := ContadoresBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLContadoresModel():New( self ), ), ::oModel )

   METHOD getRange()                   INLINE ( iif( empty( ::oRange ), ::oRange := ContadoresItemRange():New( self ), ), ::oRange )

   METHOD getDialogView                INLINE ( iif( empty( ::oDialogView ), ::oDialogView := ContadoresView():New( self ), ), ::oDialogView )

   METHOD getSelector()                INLINE ( iif( empty( ::oGetSelector ), ::oGetSelector := SeriesGetSelector():New( self ), ), ::oGetSelector )

   METHOD getValidator()               INLINE ( iif( empty( ::oValidator ), ::oValidator  := ContadoresValidator():New( self ), ), ::oValidator )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController) CLASS ContadoresController

   ::Super:New( oController )

   ::lTransactional                    := .f.

   ::cTitle                            := "Series"

   ::cName                             := "contadores"

   ::hImage                            := {  "16" => "gc_sort_az_descending_16",;
                                             "32" => "gc_sort_az_descending_32",;
                                             "48" => "gc_sort_az_descending_48" }

   /*::getSelectorView():getMenuTreeView():setEvents( { 'addingDuplicateButton',;
                                                      'addingAppendButton',;
                                                      'addingEditButton',;
                                                      'addingZoomButton',;
                                                      'addingShowDeleteButton',;
                                                      'addingDeleteButton' }, {|| .f. } )*/

   //::getModel():setGeneralWhere( "documento = '" + ::cScope + "'" )      

   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ContadoresController

    if !empty( ::oModel )
      ::oModel:End()
   end if 

    if !empty( ::oRange )
      ::oRange:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS ContadoresController

RETURN ( ::getModel():setGeneralWhere( "documento = " + quoted( ::getTableName() ) ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ContadoresAlbaranesVentasController FROM ContadoresController 

   METHOD getTableName()               INLINE ( SQLAlbaranesVentasModel():cTableName )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ContadoresBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ContadoresBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "serie"
      :cHeader             := "Serie"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "serie" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "contador"
      :cHeader             := "Contador"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "contador" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ContadoresView FROM SQLBaseView

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ContadoresView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "NUEVA_SERIE" ;
      TITLE       ::LblTitle() + "serie"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "serie" ] ;
      ID          100 ;
      VALID       ( ::oController:validate( "serie" ) ) ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "contador" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "contador" ) ) ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      OF          ::oDialog

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::okActivate(), ) }

   ::oDialog:bStart     := {|| ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ContadoresItemRange FROM ItemRange

   DATA cKey                           INIT 'serie'
   
   METHOD showNombre( cCode )          INLINE ( '' )
      
   METHOD extractCode( uValue )        INLINE ( if( hb_ishash( uValue ), hget( uValue, "serie" ), uValue ) )
         
   METHOD ValidCode( uValue ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD ValidCode( uValue ) CLASS ContadoresItemRange

   if hb_isobject( uValue )
      RETURN ( ::oController:getModel():isWhereSerie( uValue:varGet(), ::oController:cScope ) )
   end if 

RETURN ( ::oController:getModel():isWhereSerie( uValue, ::oController:cScope ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ContadoresValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD getUniqueSentence( uValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ContadoresValidator

   ::hValidators  := {  "serie"        => {  "required"        => "La serie es un dato requerido",;
                                             "unique"          => "La serie ya existe" } ,;
                        "contador"     => {  "required"        => "El contador es un dato requerido",;
                                             "positive"        => "El contador debe ser un número positivo" }  }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD getUniqueSentence( uValue ) CLASS ContadoresValidator

   local cSQLSentence

   TEXT INTO cSQLSentence

   SELECT
      COUNT(*)

   FROM %1$s

      WHERE %2$s = %3$s AND documento = %4$s

   ENDTEXT

   cSQLSentence     := hb_strformat(   cSQLSentence,;
                                       ::oController:getModel():getTableName(),;
                                       ::cColumnToProced,;
                                       quoted( uValue ),;
                                       quoted( ::oController:oController:getModel():cTableName ) )

RETURN ( cSQLSentence )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
#ifdef __TEST__

CLASS TestContadoresController FROM TestCase

   DATA oController

   METHOD beforeClass()

   METHOD afterClass()

   METHOD Before() 
   
END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestContadoresController

   ::oController                       := ContadoresController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestContadoresController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestContadoresController

   SQLContadoresModel():truncateTable()

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif
