#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasView FROM SQLBaseView

   METHOD   New()

   METHOD   Dialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

   ::cImageName      := "gc_bookmarks_16"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oBtn
   local oGetCodigoArticulo

   DEFINE DIALOG oDlg RESOURCE "LMovAlm" TITLE ::lblTitle() + "lineas de movimientos de almacén"

      REDEFINE GET   oGetCodigoArticulo ;
         VAR         ::oController:oModel:hBuffer[ "codigo_articulo" ] ;
         ID          100 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          oDlg

      REDEFINE BUTTON oBtn;
         ID          510 ;
         OF          oDlg ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID          520 ;
         OF          oDlg ;
         ACTION      ( oDlg:end() )

      if ::oController:isNotZoomMode()
         oDlg:AddFastKey( VK_F5, {|| oBtn:Click() } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

