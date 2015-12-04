#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS DocumentSalesViewEdit FROM ViewEdit  
  
   METHOD New()

   METHOD insertControls()

   METHOD onclickClientEdit()          INLINE ( ::oSender:onclickClientEdit() )
   METHOD onclickClientSales()         INLINE ( ::oSender:onclickClientSales() )

   METHOD columnsBrowseLineas()

   METHOD getDocumentLine()            INLINE ( ::oSender:oDocumentLines:aLines[ ::oBrowse:nArrayAt ] )

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

   ::defineDireccion()

   ::defineBrowseLineas()

   ::columnsBrowseLineas()

   ::gotopBrowseLineas()

Return ( self )

//---------------------------------------------------------------------------//

METHOD columnsBrowseLineas() CLASS DocumentSalesViewEdit

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Código"
      :bEditValue             := {|| ::getDocumentLine():getArticulo() }
      :nWidth                 := 100
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Descripción"
      :bEditValue             := {|| ::getDocumentLine():getDescription() }
      :bFooter                := {|| "Total..." }
      :nWidth                 := 310
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := cNombreCajas()
      :bEditValue             := {|| ::getDocumentLine():getCajas() }
      :cEditPicture           := MasUnd()
      :nWidth                 := 75
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := cNombreUnidades()
      :bEditValue             := {|| ::getDocumentLine():getUnidades() }
      :cEditPicture           := MasUnd()
      :nWidth                 := 130
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Und"
      :bEditValue             := {|| ::getDocumentLine():getTotalUnits() }
      :cEditPicture           := MasUnd()
      :nWidth                 := 90
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Precio"
      :bEditValue             := {|| ::getDocumentLine():getPrecioVenta() }
      :cEditPicture           := cPouDiv()
      :nWidth                 := 90
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "% Dto."
      :bEditValue             := {|| ::getDocumentLine():getDescuento() }
      :cEditPicture           := "@E 999.99"
      :nWidth                 := 105
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "% " + cImp()
      :bEditValue             := {|| ::getDocumentLine():getPorcentajeImpuesto() }
      :cEditPicture           := "@E 999.99"
      :nWidth                 := 95
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader                := "Total"
      :bEditValue             := {|| ::getDocumentLine():Total() }
      :cEditPicture           := cPouDiv()
      :nWidth                 := 120
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :nFooterType            := AGGR_SUM
   end with

Return ( self ) 

//---------------------------------------------------------------------------//

