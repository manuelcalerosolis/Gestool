#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS PaymentViewSearchNavigator FROM ViewSearchNavigator

   METHOD setItemsBusqueda()           INLINE ( ::aItemsBusqueda := { "Código", "Nombre" } )

   METHOD setColumns()

   METHOD botonesAcciones()            INLINE ( self )

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS PaymentViewSearchNavigator

   ::setBrowseConfigurationName( "Grid forma de pago" )

   with object ( ::addColumn() )
      :cHeader          := "Forma de pago"
      :bEditValue       := {|| ( ( D():FormasPago( ::getView() ) )->cCodPago + CRLF + ( D():FormasPago( ::getView() ) )->cDesPago )  }
      :nWidth           := 900
   end with

Return ( self )

//---------------------------------------------------------------------------//