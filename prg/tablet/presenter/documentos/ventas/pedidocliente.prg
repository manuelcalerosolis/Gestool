#include "FiveWin.Ch"
#include "Factu.ch"

CLASS PedidoCliente FROM DocumentosVentas  

   DATA oViewEdit

   DATA oCliente

   METHOD New()

   METHOD setEnviroment()              INLINE ( ::setDataTable( "PedCliT" ), ( ::getWorkArea() )->( OrdSetFocus( "dFecDes" ) ) )

   METHOD setNavigator()

   METHOD PropiedadesBrowseDetail()

   METHOD Resource( nMode )

   METHOD ResourceDetail( nMode )

   METHOD GetAppendDocumento()

   METHOD GetEditDocumento()

   METHOD GetAppendDetail()
   
   METHOD GetEditDetail()

   METHOD StartResourceDetail()

   METHOD evalRotor()                  INLINE ( ::oCliente:edit() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS PedidoCliente

   if !::OpenFiles()
      Return ( self )
   end if 

   ::oViewSearchNavigator  := PedidoClienteViewSearchNavigator():New( self )

   ::oViewEdit             := PedidoClienteViewEdit():New( self )

   ::oCliente              := Cliente():Init( self )   

   ::setEnviroment()

   ::setNavigator()

   ::CloseFiles()


return ( self )

//---------------------------------------------------------------------------//

METHOD setNavigator() CLASS PedidoCliente

   if !Empty( ::oViewSearchNavigator )
      ::oViewSearchNavigator:Resource()
   end if

return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS PedidoCliente

   local lResource   := .f.

   if !Empty( ::oViewEdit )

      ::oViewEdit:SetTextoTipoDocumento( LblTitle( nMode ) + "pedido" )
      
      lResource      := ::oViewEdit:Resource( nMode )

   end if

Return ( lResource )   

//---------------------------------------------------------------------------//

METHOD ResourceDetail( nMode ) CLASS PedidoCliente

   local lResult     := .f.

   ::nMode           := nMode

   ::oViewEditDetail := ViewDetail():New( self )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:SetTextoTipoDocumento( LblTitle( nMode ) + "linea de pedido" )

      lResult        := ::oViewEditDetail:Resource( nMode )

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
      ::hDictionaryDetailTemporal   := ::hDictionaryDetail[ ::nPosDetail ]
   end if

Return ( self )

//---------------------------------------------------------------------------//