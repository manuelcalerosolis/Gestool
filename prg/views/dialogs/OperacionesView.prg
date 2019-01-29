#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionesView FROM SQLBaseView
  
   DATA oExplorerBar

   DATA oLinkStockGlobal
   DATA oLinkStockAlmacen
   DATA oLinkStockUbicacion

   METHOD addLinksElementToExplorerBar()

   METHOD setTextLinkStockGlobal( nStock ) ;
                                       INLINE ( ::oLinkStockGlobal:Cargo:setText( nStock ) )   

   METHOD setTextLinkStockAlmacen( nStock ) ;
                                       INLINE ( ::oLinkStockAlmacen:Cargo:setText( nStock ) )   

   METHOD setTextLinkStockUbicacion( nStock ) ;
                                       INLINE ( if( !empty( ::oLinkStockUbicacion ), ::oLinkStockUbicacion:Cargo:setText( nStock ), ) )   

END CLASS

//---------------------------------------------------------------------------//

METHOD addLinksElementToExplorerBar() CLASS OperacionesView

   local oPanel

   oPanel                     := ::oExplorerBar:AddPanel( "Datos del elemento", nil, 1 ) 

   ::oLinkStockGlobal         := oPanel:AddLinkAndData( "Stock global:", "", {|| nil }, ::getController():getRecibosController():getImage( "16" ) )

   ::oLinkStockAlmacen        := oPanel:AddLinkAndData( "Stock almacén:", "", {|| nil }, ::getController():getRecibosController():getImage( "16" ) )
   
   if ( Company():getDefaultUsarUbicaciones() )
      ::oLinkStockUbicacion   := oPanel:AddLinkAndData( "Stock ubicación:", "", {|| nil }, ::getController():getRecibosController():getImage( "16" ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//