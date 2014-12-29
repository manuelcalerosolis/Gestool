#include "FiveWin.Ch"
#include "Factu.ch"

CLASS AlbaranCliente FROM Ventas  

   DATA oViewNavigator

   METHOD New()
   
   METHOD setAeras()

   METHOD setNavigator()

   METHOD PropiedadesBrowse()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS AlbaranCliente

   if ::OpenFiles()

      ::setAeras()

      ::setNavigator()

      ::CloseFiles()

   end if   

return ( self )

//---------------------------------------------------------------------------//

METHOD setAeras() CLASS AlbaranCliente

   ::setWorkArea( D():AlbaranesClientes( ::nView ) )  
   ::setDetailArea( D():AlbaranesClientesLineas( ::nView ) )

   ( ::getWorkArea() )->( OrdSetFocus( "dFecDes" ) )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setNavigator() CLASS AlbaranCliente

   ::oViewNavigator       := ViewNavigator():New( self )

   if !Empty( ::oViewNavigator )

      ::oViewNavigator:SetTextoTipoDocuento( "Albaranes de cliente" )
      ::oViewNavigator:SetItemsBusqueda( { "Número", "Fecha", "Código", "Nombre" } )
      ::oViewNavigator:setWorkArea( ::getWorkArea() )

      ::oViewNavigator:ResourceViewNavigator()

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD PropiedadesBrowse() CLASS AlbaranCliente

   ::oViewNavigator:oBrowse:cName       := "Grid albaranes"

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Albarán"
      :bEditValue        := {|| D():AlbaranesClientesIdText( ::nView ) + CRLF + Dtoc( ( D():AlbaranesClientes( ::nView ) )->dFecAlb ) }
      :nWidth            := 160
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| AllTrim( ( D():AlbaranesClientes( ::nView ) )->cCodCli ) + CRLF + AllTrim( ( D():AlbaranesClientes( ::nView ) )->cNomCli )  }
      :nWidth            := 320
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Base"
      :bEditValue        := {|| ( D():AlbaranesClientes( ::nView ) )->nTotNet  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := cImp()
      :bEditValue        := {|| ( D():AlbaranesClientes( ::nView ) )->nTotIva  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "R.E."
      :bEditValue        := {|| ( D():AlbaranesClientes( ::nView ) )->nTotReq  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Total"
      :bEditValue        := {|| ( D():AlbaranesClientes( ::nView ) )->nTotAlb }
      :cEditPicture      := cPorDiv()
      :nWidth            := 190
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//