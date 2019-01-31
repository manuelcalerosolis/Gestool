#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionesView FROM SQLBaseView
  
   DATA oPanel

   DATA oExplorerBar

   DATA oLinkStockGlobal
   DATA oLinkStockAlmacen
   DATA oLinkStockUbicacion
   DATA oLinkStockLote
   DATA oLinkStockCombinaciones

   METHOD addLinksElementToExplorerBar()

   METHOD setTextLinkStockGlobal( nStock ) ;
                                       INLINE ( ::oLinkStockGlobal:Cargo:setText( nStock ) )   
   
   METHOD cleanTextLinkStockGlobal()   INLINE ( if( !empty( ::oLinkStockGlobal ), ::oLinkStockGlobal:Cargo:setText( "" ), ) )   

   METHOD setTextLinkStockAlmacen( nStock ) ;
                                       INLINE ( ::oLinkStockAlmacen:Cargo:setText( nStock ) )   

   METHOD cleanTextLinkStockAlmacen()  INLINE ( if( !empty( ::oLinkStockAlmacen ), ::oLinkStockAlmacen:Cargo:setText( "" ), ) )   

   METHOD setTextLinkStockUbicacion( nStock ) ;
                                       INLINE ( if( !empty( ::oLinkStockUbicacion ), ::oLinkStockUbicacion:Cargo:setText( nStock ), ) )   

   METHOD cleanTextLinkStockUbicacion() ;
                                       INLINE ( if( !empty( ::oLinkStockUbicacion ), ::oLinkStockUbicacion:Cargo:setText( "" ), ) )   

   METHOD setTextLinkStockLote( nStock ) ;
                                       INLINE ( if( !empty( ::oLinkStockLote ), ::oLinkStockLote:Cargo:setText( nStock ), ) )   

   METHOD cleanTextLinkStockLote( nStock ) ;
                                       INLINE ( if( !empty( ::oLinkStockLote ), ::oLinkStockLote:Cargo:setText( "" ), ) )   

   METHOD setTextLinkStockCombinaciones( nStock ) ;
                                       INLINE ( if( !empty( ::oLinkStockCombinaciones ), ::oLinkStockCombinaciones:Cargo:setText( nStock ), ) )   

   METHOD cleanTextLinkStockCombinaciones( nStock ) ;
                                       INLINE ( if( !empty( ::oLinkStockCombinaciones ), ::oLinkStockCombinaciones:Cargo:setText( "" ), ) )   

   METHOD hideTextLinkStockCombinaciones() ;
                                       INLINE ( if( !empty( ::oLinkStockCombinaciones ), ::oPanel:hideLinkAndData( ::oLinkStockCombinaciones ), ) )   

END CLASS

//---------------------------------------------------------------------------//

METHOD addLinksElementToExplorerBar() CLASS OperacionesView

   local cBitmap              := nil // ::getController():getRecibosController():getImage( "16" )

   ::oPanel                   := ::oExplorerBar:AddPanel( "Stocks", nil, 1 ) 

   ::oLinkStockGlobal         := ::oPanel:AddLinkAndData( "Global:", "", {|| nil }, cBitmap )

   ::oLinkStockAlmacen        := ::oPanel:AddLinkAndData( "Almacén:", "", {|| nil }, cBitmap )
   
   if ( Company():getDefaultUsarUbicaciones() )
      ::oLinkStockUbicacion   := ::oPanel:AddLinkAndData( "Ubicación:", "", {|| nil }, cBitmap )
   end if 

   ::oLinkStockLote           := ::oPanel:AddLinkAndData( "Lote:", "", {|| nil }, cBitmap )

   ::oLinkStockCombinaciones  := ::oPanel:AddLinkAndData( "Propiedades:", "", {|| nil }, cBitmap )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//