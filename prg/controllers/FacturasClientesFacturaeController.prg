#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS FacturasClientesFacturaeController

   DATA oModel

   DATA oController 

   METHOD New( oController )           CONSTRUCTOR

   METHOD End()                       

   METHOD Run( aSelectedRecno )

   METHOD Generate( uuid ) 

   METHOD getController()              INLINE ( ::oController )

   METHOD getDocumentModel()           INLINE ( ::oController:getModel() )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := FacturaeModel():New( self ), ), ::oModel )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FacturasClientesFacturaeController

   ::oController                       := oController

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FacturasClientesFacturaeController

   if !empty(::oModel)
      ::oModel:end()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Run( aSelectedRecno ) CLASS FacturasClientesFacturaeController

   aeval( ::oController:getUuidFromRecno( aSelectedRecno ), {| uuid| ::Generate( uuid ) } )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Generate( uuid ) CLASS FacturasClientesFacturaeController
   
   local hTotal
   local hDocument   

   ::getModel():Default()

   hDocument         := ::getDocumentModel():getHashWhere( 'uuid', uuid )
   if empty( hDocument )
      RETURN ( nil )
   end if 

   hTotal            := ::getController():getTotalesDocument( uuid )
   if empty( hTotal )
      RETURN ( nil )
   end if 

   msgalert( hb_valtoexp( hTotal ), "hTotal" )

   ::getModel():setInvoiceNumber( hget( hDocument, "serie" ) + hb_ntos( hget( hDocument, "numero" ) ) )

   ::getModel():Generate()

RETURN ( nil )

//---------------------------------------------------------------------------//
