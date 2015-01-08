#include "FiveWin.Ch"
#include "Factu.ch" 

//--------------------------------*-------------------------------------------//

CLASS TGenMailingDocuments FROM TGenMailing

   METHOD Resource()

   METHOD IniciarProceso()

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

         SetWindowText( ::oBtnSiguiente:hWnd, "&Terminar" )

      ::oDlg:bStart  := {|| ::startResource() }

   ACTIVATE DIALOG ::oDlg CENTER 

   ::freeResources()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD IniciarProceso() CLASS TGenMailingDocuments

   local hashMail := {=>}

   if empty( ::getPara() )
      msgStop( "No hay dirección de correo para mandar." )
      Return ( Self )
   end if 

   hSet( hashMail, "mail", ::getPara() )
   hSet( hashMail, "mailcc", ::getCopia() )
   hSet( hashMail, "subject", ::getAsunto() )
   hSet( hashMail, "attachments", ::getAdjunto() )
   hSet( hashMail, "message", ::getMessageHTML() )

   ::oSendMail:sendList( { hashMail } )

Return ( self )

//--------------------------------------------------------------------------//
