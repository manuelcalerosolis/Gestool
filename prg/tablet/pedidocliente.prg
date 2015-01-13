#include "FiveWin.Ch"
#include "Factu.ch"

CLASS PedidoCliente FROM Ventas  

   DATA oViewNavigator

   METHOD New()

   METHOD setAeras()

   METHOD setNavigator()

   METHOD PropiedadesBrowse()

   METHOD PropiedadesBrowseDetail()

   METHOD Resource( nMode )

   METHOD GetAppendDocumento()

   METHOD GetEditDocumento()

   METHOD GuardaDocumento()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS PedidoCliente

   if ::OpenFiles()
      
      ::setAeras()

      ::setNavigator()

      ::CloseFiles()

   end if   

return ( self )

//---------------------------------------------------------------------------//

METHOD setAeras() CLASS PedidoCliente
   
   ::setWorkArea( D():PedidosClientes( ::nView ) )
   ::setDetailArea( D():PedidosClientesLineas( ::nView ) )

   ( ::getWorkArea() )->( OrdSetFocus( "dFecDes" ) )

return ( self )

//---------------------------------------------------------------------------//

METHOD setNavigator() CLASS PedidoCliente

   ::oViewNavigator       := ViewNavigator():New( self )

   if !Empty( ::oViewNavigator )

      ::oViewNavigator:setTextoTipoDocuento( "Pedidos de cliente" )
      ::oViewNavigator:setItemsBusqueda( { "Número", "Fecha", "Código", "Nombre" } )
      
      ::oViewNavigator:setWorkArea( ::getWorkArea() )

      ::oViewNavigator:ResourceViewNavigator()

   end if

return ( self )

//---------------------------------------------------------------------------//

METHOD PropiedadesBrowse() CLASS PedidoCliente

   ::oViewNavigator:oBrowse:cName            := "Grid pedidos"

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Pedido"
      :bEditValue        := {|| D():PedidosClientesIdText( ::nView ) + CRLF + Dtoc( ( D():PedidosClientes( ::nView ) )->dFecPed ) }
      :nWidth            := 160
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| AllTrim( ( D():PedidosClientes( ::nView ) )->cCodCli ) + CRLF + AllTrim( ( D():PedidosClientes( ::nView ) )->cNomCli )  }
      :nWidth            := 320
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Base"
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotNet  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := cImp()
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotIva  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "R.E."
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotReq  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Total"
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotPed }
      :cEditPicture      := cPorDiv()
      :nWidth            := 190
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS PedidoCliente

   ::oViewEdit       := ViewEdit():New( self )

   if !Empty( ::oViewEdit )

      ::oViewEdit:setTextoTipoDocuento( LblTitle( nMode ) + "pedido" )
      
      ::oViewEdit:ResourceViewEdit( nMode )

   end if

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS PedidoCliente

   ::hDictionaryMaster      := D():GetPedidoClienteDefaultValue( ::nView )
   ::hDictionaryDetail      := {}

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDocumento() CLASS PedidoCliente

   ::hDictionaryMaster      := D():GetPedidoClienteById( D():PedidosClientesId( ::nView ), ::nView ) 
   ::hDictionaryDetail      := D():GetPedidoClienteLineas( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD PropiedadesBrowseDetail() CLASS PedidoCliente

   ::oViewEdit:oBrowse:cName            := "Grid pedidos lineas"

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader             := "Cód"
      :bEditValue          := {|| ::getDataBrowse( "Articulo" ) }
      :nWidth              := 80
   end with

Return ( self )

//---------------------------------------------------------------------------//

METHOD GuardaDocumento() CLASS PedidoCliente

   MsgInfo( "Guardamos el documento" )

Return ( self )

//---------------------------------------------------------------------------//
