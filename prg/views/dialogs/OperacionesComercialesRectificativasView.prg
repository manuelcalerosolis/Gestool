#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionesComercialesRectificativasView FROM OperacionesComercialesView
   
   METHOD addLinksToExplorerBar()

END CLASS

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS OperacionesComercialesRectificativasView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   oPanel:AddLink(   "Rectificar...",;
                     {|| ::getController:getRectificativaDialogView():Activate() },;
                         ::getController():getFacturasController():getImage( "16" ) )


   oPanel:AddLink(   "Incidencias...",;
                     {|| ::getController():getIncidenciasController():activateDialogView() },;
                         ::getController():getIncidenciasController():getImage( "16" ) )

   oPanel:AddLink(   "Tipo de direcciones...",;
                     {|| ::getController():getDireccionTipoDocumentoController():activateDialogView() },;
                         ::getController():getDireccionTipoDocumentoController():getImage( "16" ) )

   oPanel:AddLink(   "Recibos...",;
                     {|| ::getController():getRecibosController():activateDialogView() },;
                         ::getController():getRecibosController():getImage( "16" ) )

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::getController():isNotZoomMode()

      oPanel:AddLink(   "Campos extra...",;
                        {||   ::getController():getCamposExtraValoresController():Edit( ::getController():getUuid() ) },;
                              ::getController():getCamposExtraValoresController():getImage( "16" ) )
   end if

   oPanel:AddLink(   "Detalle IVA...",;
                     {||   ::getController():getIvaDetalleView():Show()  },;
                           ::getController():getTipoIvaController():getImage( "16" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//