#include "FiveWin.Ch"
#include "Factu.ch"
#include "Xbrowse.ch"

CLASS AlbaranCliente FROM Ventas  

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

   METHOD GuardaDocumento()

   METHOD GetAppendDetail()
   METHOD GetEditDetail()

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

METHOD Resource( nMode ) CLASS AlbaranCliente

   ::oViewEdit       := ViewEdit():New( self )

   if !Empty( ::oViewEdit )

      ::oViewEdit:setTextoTipoDocuento( LblTitle( nMode ) + "albarán" )
      
      ::oViewEdit:ResourceViewEdit( nMode )

   end if

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD ResourceDetail( nMode ) CLASS AlbaranCliente

   local lResult     := .f.

   ::oViewEditDetail := ViewDetail():New( self )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:setTextoTipoDocuento( LblTitle( nMode ) + " linea de albarán" )
      
      lResult        := ::oViewEditDetail:ResourceViewEditDetail( nMode )

   end if

Return ( lResult )   

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS AlbaranCliente

   ::hDictionaryMaster      := D():GetAlbaranClienteDefaultValue( ::nView )
   ::hDictionaryDetail      := {}

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDocumento() CLASS AlbaranCliente

   ::hDictionaryMaster      := D():GetAlbaranClienteById( D():AlbaranesClientesId( ::nView ), ::nView ) 
   ::hDictionaryDetail      := D():GetAlbaranClienteLineas( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD PropiedadesBrowseDetail() CLASS AlbaranCliente

   ::oViewEdit:oBrowse:cName            := "Grid albaranes lineas"

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
      :bEditValue             := {|| nTotNAlbCli( ::hDictionaryDetail[ ::oViewEdit:oBrowse:nArrayAt ] ) }
      :cEditPicture           := MasUnd()
      :nWidth                 := 90
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Precio"
      :bEditValue             := {|| nTotUAlbCli( ::hDictionaryDetail[ ::oViewEdit:oBrowse:nArrayAt ] ) }
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
      :bEditValue             := {|| nTotalLineaAlbaranCliente( ::hDictionaryDetail[ ::oViewEdit:oBrowse:nArrayAt ], , , , .t., hGet( ::hDictionaryMaster, "OperarPuntoVerde" ), .t. ) }
      :cEditPicture           := cPouDiv( hGet( ::hDictionaryMaster, "Divisa" ), D():Divisas( ::nView ) )
      :nWidth                 := 94
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :nFooterType            := AGGR_SUM
   end with

Return ( self )

//---------------------------------------------------------------------------//

METHOD GuardaDocumento( oCbxRuta ) CLASS AlbaranCliente

   MsgInfo( "Guardamos el documento Albaranes" )

   ::setUltimoCliente( oCbxRuta )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDetail() CLASS AlbaranCliente

   ::hDictionaryDetailTemporal      := D():GetAlbaranClienteLineaBlank( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDetail() CLASS AlbaranCliente

   ::hDictionaryDetailTemporal      := ::hDictionaryDetail[ ::nPosDetail ]

Return ( self )

//---------------------------------------------------------------------------//