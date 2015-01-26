#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDocuments FROM TGenMailing

   METHOD Resource()

   METHOD getSelectedList()
      METHOD addSelectedList()      INLINE ( aAdd( ::aMailingList, ::hashDatabaseList() ) )

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

METHOD getSelectedList() CLASS TGenMailingDocuments

   local nSelect

   CursorWait()

   ::aMailingList    := {}
   
   for each nSelect in ::aSelected 
      ::gotoRecno( nSelect )
      ::addSelectedList()
   next 

   CursorArrow()

Return ( ::aMailingList )

//--------------------------------------------------------------------------//

