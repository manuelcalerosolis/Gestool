#include "FiveWin.Ch"
#include "Factu.ch"

CLASS AlbaranCliente FROM Ventas  

   METHOD New()

   METHOD cTextoTipoDocumento() INLINE ( "Albaranes de cliente" )

   METHOD PropiedadesBrowse()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS AlbaranCliente

   if ::OpenFiles()

      ::setWorkArea( D():AlbaranesClientes( ::nView ) )
      ::setDetailArea( D():AlbaranesClientesLineas( ::nView ) )

      ( ::getWorkArea() )->( OrdSetFocus( "dFecDes" ) )

      ::ResourceBrowse()

      ::CloseFiles()

   end if   

return ( self )

//---------------------------------------------------------------------------//

METHOD PropiedadesBrowse() CLASS AlbaranCliente

   ::oBrowse:cName       := "Grid albaranes"

   ::oBrowse:bLDblClick  := {|| ::Edit() }

   with object ( ::oBrowse:AddCol() )
      :cHeader           := "Albarán"
      :bEditValue        := {|| D():AlbaranesClientesIdText( ::nView ) + CRLF + Dtoc( ( D():AlbaranesClientes( ::nView ) )->dFecAlb ) }
      :nWidth            := 160
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| AllTrim( ( D():AlbaranesClientes( ::nView ) )->cCodCli ) + CRLF + AllTrim( ( D():AlbaranesClientes( ::nView ) )->cNomCli )  }
      :nWidth            := 320
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader           := "Base"
      :bEditValue        := {|| ( D():AlbaranesClientes( ::nView ) )->nTotNet  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader           := cImp()
      :bEditValue        := {|| ( D():AlbaranesClientes( ::nView ) )->nTotIva  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader           := "R.E."
      :bEditValue        := {|| ( D():AlbaranesClientes( ::nView ) )->nTotReq  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader           := "Total"
      :bEditValue        := {|| ( D():AlbaranesClientes( ::nView ) )->nTotAlb }
      :cEditPicture      := cPorDiv()
      :nWidth            := 190
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//