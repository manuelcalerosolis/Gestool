#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ZonasController FROM SQLBrowseController

   METHOD New()

   METHOD End()

   METHOD gettingSelectSentence()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ZonasController

   ::Super:New( oController )

   ::cTitle                      := "Zonas"

   ::cName                       := "zonas"

   ::oModel                      := SQLAlmacenesModel():New( self )

   ::oRepository                 := AlmacenesRepository():New( self )

   ::oBrowseView                 := AlmacenesBrowseView():New( self )

   ::oDialogView                 := ZonasView():New( self )

   ::oValidator                  := AlmacenesValidator():New( self, ::oDialogView )

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oRepository:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS ZonasController

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

CLASS ZonasView FROM SQLBaseView
  
   METHOD Activate()

   METHOD Activating()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS ZonasView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )

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
      RESOURCE    "gc_package_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
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

