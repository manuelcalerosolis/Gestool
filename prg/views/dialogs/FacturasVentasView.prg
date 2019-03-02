#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasVentasView FROM OperacionesComercialesView  
  
   METHOD addLinksToExplorerBar() 
   
ENDCLASS

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS FacturasVentasView

   ::Super:addLinksToExplorerBar()

   ::oPanel:AddLink( "Recibos...",;
                     {||   ::getController():getRecibosController():activateDialogView() },;
                           ::getController():getRecibosController():getImage( "16" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

