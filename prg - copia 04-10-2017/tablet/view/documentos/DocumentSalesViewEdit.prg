#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS DocumentSalesViewEdit FROM ViewEdit  
  
   METHOD New()

   METHOD insertControls()

   METHOD onclickClientEdit()          INLINE ( ::oSender:onclickClientEdit() )
   METHOD onclickClientSales()         INLINE ( ::oSender:onclickClientSales() )

   METHOD columnsBrowseLineas()

   METHOD getDocumentLines()           INLINE ( ::oSender:oDocumentLines:aLines[ ::oBrowse:nArrayAt ] )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS DocumentSalesViewEdit

   ::oSender   := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertControls() CLASS DocumentSalesViewEdit

   ::defineSerie()

   ::defineRuta()

   ::defineCliente()

   //::defineDireccion()

   ::defineEstablecimiento()
 
   ::defineBrowseLineas()

   ::columnsBrowseLineas()

   ::gotopBrowseLineas()

Return ( self )

//---------------------------------------------------------------------------//

METHOD columnsBrowseLineas() CLASS DocumentSalesViewEdit

   ::setBrowseConfigurationName( "grid_browselineas" )

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Código"
      :bEditValue             := {|| ::getDocumentLines():getProductId() }
      :nWidth                 := 100
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Descripción"
      :bEditValue             := {|| ::getDocumentLines():getDescription() }
      :bFooter                := {|| "Total..." }
      :nWidth                 := 310
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Caj"
      :bEditValue             := {|| ::getDocumentLines():getCajas() }
      :cEditPicture           := MasUnd()
      :nWidth                 := 60
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Und"
      :bEditValue             := {|| ::getDocumentLines():getUnidades() }
      :cEditPicture           := MasUnd()
      :nWidth                 := 60
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "T.Und"
      :bEditValue             := {|| ::getDocumentLines():getTotalUnits() }
      :cEditPicture           := MasUnd()
      :nWidth                 := 90
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Precio"
      :bEditValue             := {|| ::getDocumentLines():getPrecioVenta() }
      :cEditPicture           := cPouDiv()
      :nWidth                 := 90
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "% Dto."
      :bEditValue             := {|| ::getDocumentLines():getDescuento() }
      :cEditPicture           := "@E 999.99"
      :nWidth                 := 105
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "% " + cImp()
      :bEditValue             := {|| ::getDocumentLines():getPorcentajeImpuesto() }
      :cEditPicture           := "@E 999.99"
      :nWidth                 := 95
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Total"
      :bEditValue             := {|| ::getDocumentLines():getBase() }
      :cEditPicture           := cPouDiv()
      :nWidth                 := 120
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :nFooterType            := AGGR_SUM
   end with

Return ( self ) 

//---------------------------------------------------------------------------//

