#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS AjustableView FROM SQLBaseView

   DATA oExplorerBar

   DATA oDialog

   METHOD Activate()

   METHOD startActivate()

   METHOD endActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   local oBmp
   local oBtnAceptar

   DEFINE DIALOG        ::oDialog ;
      TITLE             "Configuraciones" ;
      RESOURCE          "AJUSTES"

      REDEFINE BITMAP   oBmp ;
         ID             500 ;
         RESOURCE       "gc_wrench_48" ;
         TRANSPARENT ;
         OF             ::oDialog

      REDEFINE EXPLORERBAR ::oExplorerBar ;
         ID             100 ;
         OF             ::oDialog

      ::oExplorerBar:nBottomColor  := RGB( 255, 255, 255 )
      ::oExplorerBar:nTopColor     := RGB( 255, 255, 255 )

      REDEFINE BUTTON   oBtnAceptar ;
         ID             IDOK ;
         OF             ::oDialog ;
         ACTION         ( ::oDialog:End( IDOK ) )

      REDEFINE BUTTON  ;
         ID             IDCANCEL ;
         OF             ::oDialog ;
         CANCEL ;
         ACTION         ( ::oDialog:End( IDCANCEL ) )

      ::oDialog:AddFastKey( VK_F5, {|| oBtnAceptar:Click() } )

      ::oDialog:bStart  := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   oBmp:End()

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

   ::oDialog   := nil

RETURN ( nil )

//---------------------------------------------------------------------------//


