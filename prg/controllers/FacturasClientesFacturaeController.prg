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
   local hTotales
   local hDocument
   local hClient

   ::getModel():Default()

   hDocument         := ::getDocumentModel():getHashWhere( 'uuid', uuid )
   if empty( hDocument )
      RETURN ( nil )
   end if 

   hTotal            := ::getController():getTotalesDocument( uuid )
   if empty( hTotal )
      RETURN ( nil )
   end if 

   hTotales          := ::getController():getTotalesDocumentGroupByIVA( uuid )

   hClient           := ::getController():getClientesController():getModel():getHashWhere( 'codigo', hget( hDocument, "cliente_codigo" ) )
   if empty( hClient )
      RETURN ( nil )
   end if 

   ::getModel():setInvoiceNumber( hget( hDocument, "serie" ) + hb_ntos( hget( hDocument, "numero" ) ) )
   
   ::getModel():setInvoiceTotalAmount( hget( hTotal, "totalDocumento" ) ) 
   ::getModel():setTotalOutstandingAmount( hget( hTotal, "totalDocumento" ) ) 
   ::getModel():setTotalExecutableAmount( hget( hTotal, "totalDocumento" ) ) 

   ::getModel():oSellerParty:cTaxIdentificationNumber := 'ES' + hget( hClient, "dni" )

   if Company():isPersonType()
      ::getModel():oSellerParty:cPersonTypeCode       := 'F'
      ::getModel():oSellerParty:cName                 := Company():getNombre()
      ::getModel():oSellerParty:cFirstSurname         := Company():getNombre()
   else
      ::getModel():oSellerParty:cPersonTypeCode                := 'J'
      ::getModel():oSellerParty:cCorporateName                 := Company():getNombre()
      ::getModel():oSellerParty:cTradeName                     := Company():getNombre()
      ::getModel():oSellerParty:cRegisterOfCompaniesLocation   := Company():getRegistroMercantil()
   end if

   //    :oSellerParty:cAddress                          := uFieldEmpresa( "cDomicilio" )
   //    :oSellerParty:cPostCode                         := uFieldEmpresa( "cCodPos" )
   //    :oSellerParty:cTown                             := uFieldEmpresa( "cPoblacion" )
   //    :oSellerParty:cProvince                         := uFieldEmpresa( "cProvincia" )
   //    :oSellerParty:cTelephone                        := uFieldEmpresa( "cTlf" )
   //    :oSellerParty:cTelFax                           := uFieldEmpresa( "cFax" )
   //    :oSellerParty:cWebAddress                       := uFieldEmpresa( "Web" )
   //    :oSellerParty:cElectronicMail                   := uFieldEmpresa( "EMail" )


   ::getModel():Generate()

RETURN ( nil )

//---------------------------------------------------------------------------//
