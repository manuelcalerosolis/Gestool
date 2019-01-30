#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionesView FROM SQLBaseView
  
   DATA oExplorerBar

   DATA oLinkStockGlobal
   DATA oLinkStockAlmacen
   DATA oLinkStockUbicacion
   DATA oLinkStockLote
   DATA oLinkStockCombinaciones

   METHOD addLinksElementToExplorerBar()

   METHOD setTextLinkStockGlobal( nStock ) ;
                                       INLINE ( ::oLinkStockGlobal:Cargo:setText( nStock ) )   

   METHOD setTextLinkStockAlmacen( nStock ) ;
                                       INLINE ( ::oLinkStockAlmacen:Cargo:setText( nStock ) )   

   METHOD setTextLinkStockUbicacion( nStock ) ;
                                       INLINE ( if( !empty( ::oLinkStockUbicacion ), ::oLinkStockUbicacion:Cargo:setText( nStock ), ) )   

   METHOD setTextLinkStockLote( nStock ) ;
                                       INLINE ( if( !empty( ::oLinkStockLote ), ::oLinkStockLote:Cargo:setText( nStock ), ) )   

   METHOD cleanTextLinkStockLote( nStock ) ;
                                       INLINE ( if( !empty( ::oLinkStockLote ), ::oLinkStockLote:Cargo:setText( "" ), ) )   

   METHOD setTextLinkStockCombinaciones( nStock ) ;
                                       INLINE ( if( !empty( ::oLinkStockCombinaciones ), ::oLinkStockCombinaciones:Cargo:setText( nStock ), ) )   

   METHOD cleanTextLinkStockCombinaciones( nStock ) ;
                                       INLINE ( if( !empty( ::oLinkStockCombinaciones ), ::oLinkStockCombinaciones:Cargo:setText( "" ), ) )   

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

   ::oLinkStockLote           := oPanel:AddLinkAndData( "Stock lote:", "", {|| nil }, ::getController():getRecibosController():getImage( "16" ) )

   ::oLinkStockCombinaciones  := oPanel:AddLinkAndData( "Stock comb.:", "", {|| nil }, ::getController():getRecibosController():getImage( "16" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//