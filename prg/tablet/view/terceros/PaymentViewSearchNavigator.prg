#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS PaymentViewSearchNavigator FROM ViewSearchNavigator

   METHOD setItemsBusqueda()           INLINE ( ::hashItemsSearch := { "Nombre" => "cDesPago", "Código" => "cCodPago" } )

   METHOD setColumns()

   METHOD botonesAcciones()            INLINE ( self )

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS PaymentViewSearchNavigator

   ::setBrowseConfigurationName( "grid_forma_de_pago" )

   with object ( ::addColumn() )
      :cHeader          := "Forma de pago"
      :bEditValue       := {|| ( ( D():FormasPago( ::getView() ) )->cCodPago + CRLF + ( D():FormasPago( ::getView() ) )->cDesPago )  }
      :nWidth           := 900
   end with

Return ( self )

//---------------------------------------------------------------------------//