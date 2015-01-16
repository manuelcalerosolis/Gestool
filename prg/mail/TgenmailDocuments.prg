#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDocuments FROM TGenMailing

   METHOD Resource()

   METHOD addDatabaseList()
      METHOD getDatabaseList()

END CLASS

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TGenMailingDocuments

   ::lCancel         := .f.

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

         ::oBtnSiguiente:setText( "&Enviar" )

      ::oDlg:bStart  := {|| ::startResource() }

   ACTIVATE DIALOG ::oDlg CENTER 

   ::freeResources()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD addDatabaseList() CLASS TGenMailingDocuments

   aAdd( ::aMailingList, ::hashDatabaseList() )

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD getDatabaseList() CLASS TGenMailingDocuments

   CursorWait()

   ::aMailingList    := {}
   
   ::addDatabaseList()

   CursorArrow()

Return ( ::aMailingList )

//--------------------------------------------------------------------------//

