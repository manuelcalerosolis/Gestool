#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ZonasController FROM SQLBrowseController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD gettingSelectSentence()

   // Construcciones tardias---------------------------------------------------

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := AlmacenesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := ZonasView():New( self ), ), ::oDialogView )

   METHOD getRepository()              INLINE ( iif( empty( ::oRepository ), ::oRepository := AlmacenesRepository():New( self ), ), ::oRepository )

   METHOD getValidator()               INLINE ( iif( empty( ::oValidator ), ::oValidator := AlmacenesValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLZonasModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ZonasController

   ::Super:New( oController )

   ::cTitle                            := "Zonas"

   ::cName                             := "zonas"

   ::hImage                            := {  "16" => "gc_shelf_full_16",;
                                             "32" => "gc_shelf_full_32",;
                                             "48" => "gc_shelf_full_48" }

   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oRepository )
      ::oRepository:End()
   end if   

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

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS ZonasController

   local uuid        := ::getController():getUuid() 

   if !empty( uuid )
      ::getModel():setGeneralWhere( "almacen_uuid = " + quoted( uuid ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ZonasView FROM SQLBaseView
  
   METHOD Activate()

   METHOD Activating()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS ZonasView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:getModel():hBuffer()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS ZonasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ZONAS" ;
      TITLE       ::LblTitle() + "zonas"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNN" ;
      ID          100 ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   // Ubicaciones--------------------------------------------------------------------
   
   TBtnBmp():ReDefine( 501, "new16",,,,, {|| ::oController:getUbicacionesController():Append() }, ::oDialog, .f., {|| ::getController():isNotZoomMode() }, .f., "Añadir ubicaciones" )

   TBtnBmp():ReDefine( 502, "edit16",,,,, {|| ::oController:getUbicacionesController():Edit() }, ::oDialog, .f., {|| ::getController():isNotZoomMode() }, .f., "Modificar ubicaciones" )

   TBtnBmp():ReDefine( 503, "del16",,,,, {|| ::oController:getUbicacionesController():Delete() }, ::oDialog, .f., {|| ::getController():isNotZoomMode() }, .f., "Eliminar ubicaciones" )

   ::oController:getUbicacionesController():Activate( 150, ::oDialog )

   // Botones zonas -------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::closeActivate(), ) }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLZonasModel FROM SQLAlmacenesModel

   METHOD getAlmacenUuidAttribute( value )

END CLASS

//---------------------------------------------------------------------------//

METHOD getAlmacenUuidAttribute( value ) CLASS SQLZonasModel
   
   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:getController() )
      RETURN ( value )
   end if

RETURN ( ::oController:getController():getUuid() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
