#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS OrderCustomerViewSearchNavigator FROM ViewSearchNavigator

   METHOD setTextoTipoDocumento()      INLINE ( ::cTextoTipoDocumento := "Pedidos de cliente" ) 

   METHOD setItemsBusqueda( aItems )   INLINE ( ::aItemsBusqueda := { "Número", "Fecha", "Código", "Nombre" } )   

   METHOD setColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS OrderCustomerViewSearchNavigator

   ::setBrowseConfigurationName( "Grid pedidos cliente" )

   with object ( ::addColumn() )
      :cHeader           := "Pedido"
      :bEditValue        := {|| D():PedidosClientesIdText( ::getView() ) + CRLF + Dtoc( ( D():PedidosClientes( ::getView() ) )->dFecPed ) }
      :nWidth            := 160
   end with

   with object ( ::addColumn() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| AllTrim( ( D():PedidosClientes( ::getView() ) )->cCodCli ) + CRLF + AllTrim( ( D():PedidosClientes( ::getView() ) )->cNomCli )  }
      :nWidth            := 320
   end with

   with object ( ::addColumn() )
      :cHeader           := "Base"
      :bEditValue        := {|| ( D():PedidosClientes( ::getView() ) )->nTotNet  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := cImp()
      :bEditValue        := {|| ( D():PedidosClientes( ::getView() ) )->nTotIva  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := "R.E."
      :bEditValue        := {|| ( D():PedidosClientes( ::getView() ) )->nTotReq  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := "Total"
      :bEditValue        := {|| ( D():PedidosClientes( ::getView() ) )->nTotPed }
      :cEditPicture      := cPorDiv()
      :nWidth            := 190
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//