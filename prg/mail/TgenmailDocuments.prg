#include "FiveWin.Ch"
#include "Factu.ch" 

//--------------------------------*-------------------------------------------//

CLASS TGenMailingDocuments FROM TGenMailing

   METHOD Resource()

END CLASS

//---------------------------------------------------------------------------//

METHOD Resource( aItems, nView ) CLASS TGenMailingDocuments

   ::Init()

   ::lCancel         := .f.
   ::aItems          := aItems
   ::aFields         := getSubArray( aItems, 5 )
   ::nView           := nView

   DEFINE DIALOG     ::oDlg ;
      RESOURCE       "Select_Mail_Container";
       OF            oWnd()

      REDEFINE PAGES ::oFld ;
         ID          10;
         OF          ::oDlg ;
         DIALOGS     "Select_Mail_Redactar",;
                     "Select_Mail_Proceso"

         ::buildPageRedactar( ::oFld:aDialogs[ 1 ] )

         ::buildPageProceso( ::oFld:aDialogs[ 2 ] )

         ::buildButtonsGeneral()

      ::oDlg:bStart  := {|| ::startResource() }

   ACTIVATE DIALOG ::oDlg CENTER 

   ::freeResources()

Return ( Self )

//--------------------------------------------------------------------------//

