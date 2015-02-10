#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS PedidoClienteViewSearchNavigator FROM ViewSearchNavigator

   METHOD setTextoTipoDocumento()      INLINE ( ::cTextoTipoDocumento := "Pedidos de cliente" ) 

   METHOD setItemsBusqueda( aItems )   INLINE ( ::aItemsBusqueda := { "Número", "Fecha", "Código", "Nombre" } )   

   METHOD setColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS PedidoClienteViewSearchNavigator

   ::setBrowseConfigurationName( "Grid pedidos" )

   with object ( ::addColumn() )
      :cHeader           := "Pedido"
      :bEditValue        := {|| D():PedidosClientesIdText( ::nView ) + CRLF + Dtoc( ( D():PedidosClientes( ::nView ) )->dFecPed ) }
      :nWidth            := 160
   end with

   with object ( ::addColumn() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| AllTrim( ( D():PedidosClientes( ::nView ) )->cCodCli ) + CRLF + AllTrim( ( D():PedidosClientes( ::nView ) )->cNomCli )  }
      :nWidth            := 320
   end with

   with object ( ::addColumn() )
      :cHeader           := "Base"
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotNet  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := cImp()
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotIva  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := "R.E."
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotReq  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := "Total"
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotPed }
      :cEditPicture      := cPorDiv()
      :nWidth            := 190
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//