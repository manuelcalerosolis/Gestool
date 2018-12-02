#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS FacturasClientesFacturaeController

   DATA oController

   METHOD New( oController ) CONSTRUCTOR

   METHOD End()                        VIRTUAL

   METHOD Run( aSelectedRecno )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasClientesFacturaeController

   ::oController                       := oController

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Run( aSelectedRecno )

   msgalert( hb_valtoexp( ::getUuidFromRecno( aSelectedRecno ) ) )
   
RETURN ( self )

//---------------------------------------------------------------------------//
