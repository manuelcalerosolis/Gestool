#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

CLASS CustomerSalesViewSearchNavigator FROM DocumentSalesViewSearchNavigator

   METHOD getDataTable()                  INLINE ( "FacCliT" )
   METHOD getWorkArea()                   INLINE ( D():FacturasClientes( ::getView() ) )

   METHOD botonesAcciones()               INLINE ( nil )

   METHOD getTitleDocumento()             INLINE ( "Facturas cliente" )

END CLASS

//---------------------------------------------------------------------------//



