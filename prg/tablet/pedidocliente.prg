#include "FiveWin.Ch"
#include "Factu.ch"

CLASS PedidoCliente FROM Ventas  

   METHOD New()

   METHOD cTextoTipoDocumento()  INLINE ( "Pedidos de cliente" )

   METHOD PropiedadesBrowse()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS PedidoCliente

   if ::OpenFiles()

      ::setWorkArea( D():PedidosClientes( ::nView ) )
      ::setDetailArea( D():PedidosClientesLineas( ::nView ) )

      ( ::getWorkArea() )->( OrdSetFocus( "dFecDes" ) )

      ::ResourceBrowse()

      ::CloseFiles()

   end if   

return ( self )

//---------------------------------------------------------------------------//

METHOD PropiedadesBrowse() CLASS PedidoCliente

   ::oBrowse:cName            := "Grid pedidos"

   ::oBrowse:bLDblClick       := {|| ::Edit() }

   with object ( ::oBrowse:AddCol() )
      :cHeader           := "Pedido"
      :bEditValue        := {|| D():PedidosClientesIdText( ::nView ) + CRLF + Dtoc( ( D():PedidosClientes( ::nView ) )->dFecPed ) }
      :nWidth            := 160
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| AllTrim( ( D():PedidosClientes( ::nView ) )->cCodCli ) + CRLF + AllTrim( ( D():PedidosClientes( ::nView ) )->cNomCli )  }
      :nWidth            := 320
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader           := "Base"
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotNet  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader           := cImp()
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotIva  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader           := "R.E."
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotReq  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader           := "Total"
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotPed }
      :cEditPicture      := cPorDiv()
      :nWidth            := 190
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//