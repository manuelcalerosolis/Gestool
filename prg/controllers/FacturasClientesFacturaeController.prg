#include "FiveWin.Ch"
#include "Factu.ch"

#xcommand TEST CLASS <className> FROM <classParent> => ;
#ifdef __TEST__;; CLASS <className> FROM <classParent>

#xcommand TEST END CLASS => ;
#endif ;; END CLASS  

//---------------------------------------------------------------------------//

CLASS FacturasClientesFacturaeController

   DATA oModel

   DATA oController 

   DATA hTotal   
   DATA hClient
   DATA hTotales
   DATA hDocument
   DATA hClientDirection
   DATA hCompanyDirection

   DATA cError

   METHOD New( oController )           CONSTRUCTOR

   METHOD End()                       

   METHOD Run( aSelectedRecno )

   METHOD Generate( uuid ) 

   METHOD getController()              INLINE ( ::oController )

   METHOD getDocumentModel()           INLINE ( ::oController:getModel() )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := FacturaeModel():New( self ), ), ::oModel )

   METHOD isInformationLoaded( uuid ) 

   METHOD setDocumentsAndTotals()

   METHOD setSellerParty()

   METHOD setBuyerParty()

   METHOD setTax()

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

RETURN ( aeval( ::oController:getUuidFromRecno( aSelectedRecno ), {| uuid| ::Generate( uuid ) } ) )

//---------------------------------------------------------------------------//

METHOD Generate( uuid ) CLASS FacturasClientesFacturaeController
   
   if ::isInformationLoaded( uuid )

      ::getModel():Default()

      ::setDocumentsAndTotals()

      ::setSellerParty()

      ::setBuyerParty()

      ::setTax()

      ::getModel():Generate()

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isInformationLoaded( uuid ) CLASS FacturasClientesFacturaeController

   ::cError          := ""

   ::hDocument       := ::getDocumentModel():getHashWhere( 'uuid', uuid )
   if empty( ::hDocument )
      ::cError       += "No se encuentra el documento"
   end if 

   ::hCompanyDirection    := SQLDireccionesGestoolModel():getHashWhere( 'parent_uuid', Company():getUuid() )
   if empty( ::hCompanyDirection )
      ::cError       += "No se encontraron datos de la dirección del vendedor"
   end if 

   ::hTotal          := ::getController():getTotalesDocument( uuid )
   if empty( ::hTotal )
      ::cError       += "No se puede calcular el total"
   end if 

   ::hTotales        := ::getController():getTotalesDocumentGroupByIVA( uuid )
   if empty( ::hTotales )
      ::cError       += "No se puede calcular el total por tipos de IVA"
   end if 

   msgalert( hb_valtoexp( ::hTotales ) )

   ::hClient         := SQLClientesModel():getHashWhere( 'codigo', hget( ::hDocument, "cliente_codigo" ) )
   if empty( ::hClient )
      ::cError       += "No se encontraron datos del cliente"
   end if 

   ::hClientDirection   := SQLDireccionesModel():getHashWhere( 'parent_uuid', hget( ::hClient, "uuid" ) )
   if empty( ::hClientDirection )
      ::cError       += "No se encontraron datos de la dirección del cliente"
   end if 

RETURN ( empty( ::cError ) )

//---------------------------------------------------------------------------//

METHOD setDocumentsAndTotals() CLASS FacturasClientesFacturaeController

   ::getModel():setInvoiceNumber( hget( ::hDocument, "serie" ) + hb_ntos( hget( ::hDocument, "numero" ) ) )
   
   ::getModel():setInvoiceTotalAmount( hget( ::hTotal, "totalDocumento" ) ) 
   ::getModel():setTotalOutstandingAmount( hget( ::hTotal, "totalDocumento" ) ) 
   ::getModel():setTotalExecutableAmount( hget( ::hTotal, "totalDocumento" ) ) 

   ::getModel():dOperationDate                  := hget( ::hDocument, "fecha" )
   ::getModel():dIssueDate                      := hget( ::hDocument, "fecha" )

   ::getModel():nInvoiceTotal                   := hget( ::hTotal, "totalDocumento" )
   ::getModel():nTotalGrossAmount               := hget( ::hTotal, "totalBruto" )
   ::getModel():nTotalGrossAmountBeforeTaxes    := hget( ::hTotal, "totalNeto" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setSellerParty() CLASS FacturasClientesFacturaeController

   ::getModel():oSellerParty:setTaxIdentificationNumber( 'ES' + hget( ::hClient, "dni" ) )

   ::getModel():cPlaceOfIssuePostCode           := hget( ::hCompanyDirection, "codigo_postal" ) 
   ::getModel():cPlaceOfIssueDescription        := hget( ::hCompanyDirection, "poblacion" )

   if Company():isPersonType()
      ::getModel():oSellerParty:setPersonTypeCode( 'F' )
      ::getModel():oSellerParty:setName( Company():getNombre() )
      ::getModel():oSellerParty:setFirstSurname( Company():getNombre() )
   else
      ::getModel():oSellerParty:setPersonTypeCode( 'J' )
      ::getModel():oSellerParty:setCorporateName( Company():getNombre() )
      ::getModel():oSellerParty:setTradeName( Company():getNombre() )
      ::getModel():oSellerParty:setRegisterOfCompaniesLocation( Company():getRegistroMercantil() )
   end if

   ::getModel():oSellerParty:cAddress           := hget( ::hCompanyDirection, "direccion" )
   ::getModel():oSellerParty:cPostCode          := hget( ::hCompanyDirection, "codigo_postal" )
   ::getModel():oSellerParty:cTown              := hget( ::hCompanyDirection, "poblacion" )
   ::getModel():oSellerParty:cProvince          := hget( ::hCompanyDirection, "provincia" )
   ::getModel():oSellerParty:cTelephone         := hget( ::hCompanyDirection, "telefono" )
   ::getModel():oSellerParty:cElectronicMail    := hget( ::hCompanyDirection, "email" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setBuyerParty() CLASS FacturasClientesFacturaeController

   ::getModel():oBuyerParty:cTaxIdentificationNumber  := 'ES' + hget( ::hClient, "dni" )

   if val( left( hget( ::hClient, "dni" ), 1 ) ) != 0
      ::getModel():oBuyerParty:cPersonTypeCode        := 'F'
      ::getModel():oBuyerParty:cName                  := hget( ::hClient, "nombre" )
      ::getModel():oBuyerParty:cFirstSurname          := hget( ::hClient, "nombre" )
   else
      ::getModel():oBuyerParty:cPersonTypeCode        := 'J'
      ::getModel():oBuyerParty:cCorporateName         := hget( ::hClient, "nombre" )
      ::getModel():oBuyerParty:cTradeName             := hget( ::hClient, "nombre" )
   end if

   ::getModel():oBuyerParty:cWebAddress               := hget( ::hClient, "web" )

   ::getModel():oBuyerParty:cAddress                  := hget( ::hClientDirection, "direccion" )
   ::getModel():oBuyerParty:cPostCode                 := hget( ::hClientDirection, "codigo_postal" )
   ::getModel():oBuyerParty:cTown                     := hget( ::hClientDirection, "poblacion" )
   ::getModel():oBuyerParty:cProvince                 := hget( ::hClientDirection, "provincia" )
   ::getModel():oBuyerParty:cTelephone                := hget( ::hClientDirection, "telefono" )
   ::getModel():oBuyerParty:cElectronicMail           := hget( ::hClientDirection, "email" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setTax()  CLASS FacturasClientesFacturaeController

   local oTax
   local hTotal

   for each hTotal in ::hTotales

      oTax                                      := Tax()
      oTax:nTaxBase                             := hget( hTotal, "totalBruto" )
      oTax:nTaxRate                             := hget( hTotal, "porcentajeIVA" )
      oTax:nTaxAmount                           := hget( hTotal, "totalIVA" )
      oTax:nEquivalenceSurcharge                := hget( hTotal, "recargoEquivalencia" )
      oTax:nEquivalenceSurchargeAmount          := hget( hTotal, "totalRecargo" )

      ::getModel():addTax( oTax )

   next

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestFacturasClientesFacturaeController FROM TestCase

   METHOD testGenerateXml()
   
END CLASS

//---------------------------------------------------------------------------//

METHOD testGenerateXml() CLASS TestFacturasClientesFacturaeController

   local uuid  
   local oController

   uuid        := win_uuidcreatestring()

   SQLClientesModel():truncateTable()
   SQLFacturasClientesModel():truncateTable() 
   SQLFacturasClientesLineasModel():truncateTable() 

   SQLFacturasClientesModel():testCreateFactura( uuid ) 

   SQLFacturasClientesLineasModel():testCreateFacturaLineaIVAal0( uuid ) 
   SQLFacturasClientesLineasModel():testCreateFacturaLineaIVAal10( uuid ) 
   SQLFacturasClientesLineasModel():testCreateFacturaLineaIVAal21( uuid ) 

   SQLClientesModel():testCreateContado()

   oController := FacturasClientesController():New()

   oController:getFacturasClientesFacturaeController():Generate( uuid )   

   ::assert:true( file( cPatXml() + "TEST1.xml" ), "test creacion de XML" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif
