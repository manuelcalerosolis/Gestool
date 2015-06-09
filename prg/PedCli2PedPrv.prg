#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "FastRepH.ch"

//---------------------------------------------------------------------------//
    
CLASS PedCliente2PedProveedor

   DATA oDlg
   DATA oPag
   DATA oBmp 

   DATA oBtnPrev
   DATA oBtnNext

   DATA nView

   Method New( nView )   CONSTRUCTOR

   Method Resource()

   Method Prev()

   Method Next()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS PedCliente2PedProveedor

   ::nView     := nView

   ::Resource()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS PedCliente2PedProveedor

   DEFINE DIALOG ::oDlg RESOURCE "PEDCLI2PEDPROV"

      REDEFINE BITMAP ::oBmp ;
         RESOURCE "GenerarPedidoProveedor" ;
         ID       600 ;
         OF       ::oDlg

      REDEFINE PAGES ::oPag ;
         ID       100 ;
         OF       ::oDlg ;
         DIALOGS  "PEDCLI2PEDPROV_1",;
                  "PEDCLI2PEDPROV_2",;
                  "PEDCLI2PEDPROV_3"

      REDEFINE BUTTON ::oBtnPrev ;
         ID       500 ;
         OF       ::oDlg;
         ACTION   ( ::Prev() )

      REDEFINE BUTTON ::oBtnNext ;
         ID       501 ;
         OF       ::oDlg;
         ACTION   ( ::Next() )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:End() )

      ::oDlg:bStart  := {|| ::oBtnPrev:Hide() }

   ACTIVATE DIALOG ::oDlg CENTER

   if !Empty( ::oBmp )
      ::oBmp:End()
   end if

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Method Prev() CLASS PedCliente2PedProveedor

   do case
   case ::oPag:nOption == 2

      ::oPag:GoPrev()

      SetWindowText( ::oBtnNext:hWnd, "Siguien&te >" )

      ::oBtnPrev:Hide()

   case ::oPag:nOption == 3

      ::oPag:GoPrev()

   end case

Return ( .t. )

//---------------------------------------------------------------------------//

Method Next() CLASS PedCliente2PedProveedor

   do case
      case ::oPag:nOption == 1

         ::oPag:GoNext()

         ::oBtnPrev:Show()

         SetWindowText( ::oBtnNext:hWnd, "&Procesar" )

      case ::oPag:nOption == 2

         ::oPag:GoNext()

         SetWindowText( ::oBtnNext:hWnd, "&Terminar" )

      case ::oPag:nOption == 3

   end case

Return .t.

//---------------------------------------------------------------------------//