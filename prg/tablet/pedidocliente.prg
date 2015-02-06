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

   METHOD ResourceDetail( nMode )

   METHOD GetAppendDocumento()

   METHOD GetEditDocumento()

   METHOD GetAppendDetail()
   
   METHOD GetEditDetail()

   METHOD StartResourceDetail()

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

METHOD ResourceDetail( nMode ) CLASS PedidoCliente

   local lResult     := .f.

   ::nMode           := nMode

   ::oViewEditDetail := ViewDetail():New( self )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:setTextoTipoDocuento( LblTitle( nMode ) + " linea de pedido" )
      
      lResult        := ::oViewEditDetail:ResourceViewEditDetail( nMode )

   end if

Return ( lResult )   

//---------------------------------------------------------------------------//

METHOD StartResourceDetail() CLASS PedidoCliente

   ::CargaArticulo()

   ::RecalculaLinea()

Return ( self )

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

   ::oViewEdit:oBrowse:cName  := "Grid pedidos lineas"

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Número"
      :bEditValue             := {|| ::getDataBrowse( "NumeroLinea" ) }
      :cEditPicture           := "9999"
      :nWidth                 := 55
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.   
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Cód"
      :bEditValue             := {|| ::getDataBrowse( "Articulo" ) }
      :nWidth                 := 80
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Descripción"
      :bEditValue             := {|| ::getDataBrowse( "DescripcionArticulo" ) }
      :bFooter                := {|| "Total..." }
      :nWidth                 := 310
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := cNombreCajas()
      :bEditValue             := {|| ::getDataBrowse( "Cajas" ) }
      :cEditPicture           := MasUnd()
      :nWidth                 := 60
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := cNombreUnidades()
      :bEditValue             := {|| ::getDataBrowse( "Unidades" ) }
      :cEditPicture           := MasUnd()
      :nWidth                 := 60
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Und"
      :bEditValue             := {|| nTotNPedCli( ::hDictionaryDetail[ ::oViewEdit:oBrowse:nArrayAt ] ) }
      :cEditPicture           := MasUnd()
      :nWidth                 := 90
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Precio"
      :bEditValue             := {|| nTotUPedCli( ::hDictionaryDetail[ ::oViewEdit:oBrowse:nArrayAt ] ) }
      :cEditPicture           := cPouDiv( hGet( ::hDictionaryMaster, "Divisa" ), D():Divisas( ::nView ) )
      :nWidth                 := 90
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "% Dto."
      :bEditValue             := {|| ::getDataBrowse( "Descuento" ) }
      :cEditPicture           := "@E 999.99"
      :nWidth                 := 55
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "% " + cImp()
      :bEditValue             := {|| ::getDataBrowse( "PorcentajeImpuesto" ) }
      :cEditPicture           := "@E 999.99"
      :nWidth                 := 45
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Total"
      :bEditValue             := {|| nTotalLineaPedidoCliente( ::hDictionaryDetail[ ::oViewEdit:oBrowse:nArrayAt ], , , , .t., hGet( ::hDictionaryMaster, "OperarPuntoVerde" ), .t. ) }
      :cEditPicture           := cPouDiv( hGet( ::hDictionaryMaster, "Divisa" ), D():Divisas( ::nView ) )
      :nWidth                 := 94
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :nFooterType            := AGGR_SUM
   end with

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDetail() CLASS PedidoCliente

   ::hDictionaryDetailTemporal      := D():GetPedidoClienteLineaBlank( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDetail() CLASS PedidoCliente

   if !Empty( ::nPosDetail )
      ::hDictionaryDetailTemporal      := ::hDictionaryDetail[ ::nPosDetail ]
   end if

Return ( self )

//---------------------------------------------------------------------------//