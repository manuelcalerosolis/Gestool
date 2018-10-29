#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS AjustableView FROM SQLBaseView

   METHOD Activate()

   METHOD startActivate()

   METHOD endActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG        ::oDialog ;
      TITLE             "Configuraciones" ;
      RESOURCE          "AJUSTES"

      REDEFINE BITMAP   ;
         ID             500 ;
         RESOURCE       "gc_wrench_48" ;
         TRANSPARENT    ;
         OF             ::oDialog

      ::redefineExplorerBar()

      ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

      ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

      if ::oController:isNotZoomMode() 
         ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
      end if

      ::oDialog:bStart        := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD StartActivate()

   ::fireEvent( 'startingActivate' )     

   if !empty( ::oExplorerBar )
      ::oExplorerBar:checkScroll()
   end if 

   ::fireEvent( 'startedActivate' )     

RETURN ( self )

//--------------------------------------------------------------------------//

METHOD EndActivate()

   if !empty( ::oDialog )
      ::oDialog:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//


