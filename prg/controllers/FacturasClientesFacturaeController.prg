#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS FacturasClientesFacturaeController

   DATA oModel

   DATA oController 

   DATA hTotal 
   DATA hLines  
   DATA hClient
   DATA hTotales
   DATA hDocument
   DATA hDiscounts
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

   METHOD setDocuments()

   METHOD setTotals()

   METHOD setSellerParty()

   METHOD setBuyerParty()

   METHOD setItems()

   METHOD setTax()

   METHOD setDiscount()

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
   
   if !( ::isInformationLoaded( uuid ) )
      msgStop( ::cError, "Error al cargar los datos" )
      RETURN ( nil )
   end if 

   ::getModel():Default()

   ::setDocuments()

   ::setTotals()

   ::setSellerParty()

   ::setBuyerParty()

   ::setItems()

   ::setTax()

   ::setDiscount()

   ::getModel():Generate()

   ::getModel():Sign()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isInformationLoaded( uuid ) CLASS FacturasClientesFacturaeController

   local nTotalBrutoLineas := 0

   ::cError                := ""

   ::hDocument             := ::getDocumentModel():getHashWhere( 'uuid', uuid )
   if empty( ::hDocument )
      ::cError             += "No se encuentra el documento"
   end if 

   ::hCompanyDirection    := SQLDireccionesGestoolModel():getHashWhere( 'parent_uuid', Company():getUuid() )
   if empty( ::hCompanyDirection )
      ::cError             += "No se encontraron datos de la dirección del vendedor"
   end if 

   ::hLines                := ::getController():getHashSentenceLineas( uuid )
   if empty( ::hLines )
      ::cError             += "No se encontraron líneas en la factura"
   end if 

   ::hTotal                := ::getController():getTotalesDocument( uuid )
   if empty( ::hTotal )
      ::cError             += "No se puede calcular el total"
   end if 

   ::hTotales              := ::getController():getTotalesDocumentGroupByIVA( uuid )
   if empty( ::hTotales )
      ::cError             += "No se puede calcular el total por tipos de IVA"
   end if 

   aeval( ::hTotales, {|hTotal| nTotalBrutoLineas += hget( hTotal, "total_bruto_lineas" ) } )

   ::hDiscounts            := SQLFacturasVentasDescuentosModel():selectDescuentosWhereUuid( uuid, nTotalBrutoLineas )

   ::hClient               := SQLTercerosModel():getHashWhere( 'codigo', hget( ::hDocument, "tercero_codigo" ) )
   if empty( ::hClient )
      ::cError             += "No se encontraron datos del cliente"
   end if 

   ::hClientDirection      := SQLDireccionesModel():getHashWhere( 'parent_uuid', hget( ::hClient, "uuid" ) )
   if empty( ::hClientDirection )
      ::cError             += "No se encontraron datos de la dirección del cliente"
   end if 

RETURN ( empty( ::cError ) )

//---------------------------------------------------------------------------//

METHOD setDocuments() CLASS FacturasClientesFacturaeController

   ::getModel():setInvoiceNumber( hget( ::hDocument, "serie" ) + hb_ntos( hget( ::hDocument, "numero" ) ) )
   
   ::getModel():dOperationDate                  := hget( ::hDocument, "fecha" )
   ::getModel():dIssueDate                      := hget( ::hDocument, "fecha" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setTotals() CLASS FacturasClientesFacturaeController

   ::getModel():setInvoiceTotalAmount( hget( ::hTotal, "total_documento" ) ) 
   ::getModel():setTotalOutstandingAmount( hget( ::hTotal, "total_documento" ) ) 
   ::getModel():setTotalExecutableAmount( hget( ::hTotal, "total_documento" ) ) 

   ::getModel():nInvoiceTotal                   := hget( ::hTotal, "total_documento" )
   ::getModel():nTotalGrossAmount               := hget( ::hTotal, "total_bruto" )
   ::getModel():nTotalGrossAmountBeforeTaxes    := hget( ::hTotal, "total_neto" )

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

METHOD setItems() CLASS FacturasClientesFacturaeController

   local oTax
   local hLine
   local oDiscount
   local oItemLine

   for each hLine in ::hLines

      oItemLine                        := ItemLine()
      oItemLine:nQuantity              := hget( hLine, "total_unidades" )
      oItemLine:cItemDescription       := hget( hLine, "articulo_nombre" )
      oItemLine:nUnitPriceWithoutTax   := hget( hLine, "importe_bruto" )
      oItemLine:nIva                   := hget( hLine, "iva" )

      // Descuento lineal------------------------------------------------------

      if hget( hLine, "descuento" ) != 0

         oDiscount                     := Discount()
         oDiscount:cDiscountReason     := 'Descuento'
         oDiscount:nDiscountRate       := hget( hLine, "descuento" )
         oDiscount:nDiscountAmount     := hget( hLine, "importe_descuento" )

         oItemLine:addDiscount( oDiscount )

      end if

      // Impuestos-------------------------------------------------------------
      
      oTax                                := Tax()
      oTax:nTaxRate                       := hget( hLine, "iva" )
      oTax:nTaxBase                       := hget( hLine, "importe_neto" )
      oTax:nTaxAmount                     := round( hget( hLine, "importe_neto" ) * hget( hLine, "iva" ) / 100, 2 )

      if hget( ::hDocument, "recargo_equivalencia" )
         oTax:nEquivalenceSurcharge       := hget( hLine, "recargo_equivalencia" )
         oTax:nEquivalenceSurchargeAmount := round( hget( hLine, "importe_neto" ) * hget( hLine, "recargo_equivalencia" ) / 100, 2 )
      end if

      oItemLine:addTax( oTax )

      ::getModel():addItemLine( oItemLine )

   next 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setTax()  CLASS FacturasClientesFacturaeController

   local oTax
   local hTotal

   for each hTotal in ::hTotales
      oTax                                      := Tax()
      oTax:nTaxBase                             := hget( hTotal, "total_bruto" )
      oTax:nTaxRate                             := hget( hTotal, "porcentaje_iva" )
      oTax:nTaxAmount                           := hget( hTotal, "total_iva" )
      oTax:nEquivalenceSurcharge                := hget( hTotal, "recargo_equivalencia" )
      oTax:nEquivalenceSurchargeAmount          := hget( hTotal, "total_recargo" )

      ::getModel():addTax( oTax )
   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setDiscount() CLASS FacturasClientesFacturaeController

   local oDiscount
   local hDiscount

   for each hDiscount in ::hDiscounts
      oDiscount                                 := Discount()
      oDiscount:cDiscountReason                 := hget( hDiscount, "nombre_descuento" )
      oDiscount:nDiscountRate                   := hget( hDiscount, "porcentaje_descuento" )
      oDiscount:nDiscountAmount                 := hget( hDiscount, "importe_descuento" )

      ::getModel():addDiscount( oDiscount )
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

   SQLTercerosModel():truncateTable()
   SQLFacturasVentasModel():truncateTable() 
   SQLFacturasVentasLineasModel():truncateTable() 
   SQLFacturasVentasDescuentosModel():truncateTable()

   SQLTercerosModel():test_create_contado()

   SQLFacturasVentasModel():test_create_facturaConRecargoDeEqivalencia( uuid ) 

   SQLFacturasVentasLineasModel():test_create_IVA_al_0_con_10_descuento( uuid ) 
   SQLFacturasVentasLineasModel():test_create_IVA_al_10_con_recargo_equivalencia( uuid ) 
   SQLFacturasVentasLineasModel():test_create_IVA_al_21_con_recargo_equivalencia( uuid ) 

   SQLFacturasVentasDescuentosModel():test_create_l0_por_ciento( uuid )   
   SQLFacturasVentasDescuentosModel():test_create_20_por_ciento( uuid )   
   SQLFacturasVentasDescuentosModel():test_create_30_por_ciento( uuid )   

   oController := FacturasVentasController():New()

   oController:getFacturasClientesFacturaeController():Generate( uuid )   

   ::assert:true( file( cPatXml() + "TEST1.xml" ), "test creacion de XML" )

   ::assert:true( file( cPatXml() + "TEST1-signed.xml" ), "test creacion de XML firmado" )

   oController:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif
