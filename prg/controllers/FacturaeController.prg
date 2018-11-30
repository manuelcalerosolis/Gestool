#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 

#define SCHEMAVERSION            '3.2'
#define MODALITY                 'I'   // "individual" (I)
#define INVOICEISSUERTYPE        'EM'
#define INVOICESCOUNT            '1'
#define EQUIVALENTINEUROS        '0.00'
#define INVOICEDOCUMENTTYPE      'FC'
#define INVOICECLASS             'OO'
#define TAXTYPECODE              '01'

#define DoubleTwoDecimalPicture  "999999999.99"
#define DoubleFourDecimalPicture "999999999.9999"
#define DoubleSixDecimalPicture  "999999999.999999"

CLASS FacturaeController 

   DATA oController

   DATA oModel

   DATA  oXml
   DATA  oXmlNode
   DATA  oXmlHeader
   DATA  oXmlBatch
   DATA  oXmlTotalInvoicesAmount
   DATA  oXmlTotalOutstandingAmount
   DATA  oXmlTotalExecutableAmount
   DATA  oXmlParties
   DATA  oXmlSellerParty
   DATA  oXmlTaxIdentification
   DATA  oXmlLegalEntity
   DATA  oXmlRegistrationData
   DATA  oXmlAddressInSpain
   DATA  oXmlLegalEntity
   DATA  oXmlContactDetails
   DATA  oXmlBuyerParty
   DATA  oXmlTaxIdentification
   DATA  oXmlLegalEntity
   DATA  oXmlInvoices
   DATA  oXmlInvoice
   DATA  oXmlInvoiceHeader
   DATA  oXmlCorrective
   DATA  oXmlTaxPeriod
   DATA  oXmlInvoiceIssueData
   DATA  oXmlPlaceOfIssue
   DATA  oXmlInvoiceCurrencyCode
   DATA  oXmlTaxesOutputs
   DATA  oXmlTax
   DATA  oXmlTaxableBase
   DATA  oXmlTaxAmount
   DATA  oXmlEquivalenceSurcharge
   DATA  oXmlInvoiceTotals
   DATA  oXmlGeneralDiscounts
   DATA  oXmlDiscount
   DATA  oXmlInvoiceLine
   DATA  oXmlItems
   DATA  oXmlDiscountsAndRebates
   DATA  oXmlPaymentDetails
   DATA  oXmlInstallment
   DATA  oXmlAccountToBeCredited
   DATA  oXmlAccountToBeDebited

   DATA  oXmlAdministrativeCentres
   DATA  oXmlAdministrativeCentre

   DATA  hDC

   DATA  cFicheroOrigen
   DATA  cFicheroDestino
   DATA  cFicheroOriginal
   DATA  cNif
   DATA  oFirma

   DATA     oTree

   DATA     cInvoiceNumber
   DATA     cInvoiceSeriesCode
   DATA     cInvoiceCurrencyCode
   DATA     nInvoiceTotalAmount           INIT  0

   DATA     nTotalGrossAmount             INIT  0
   DATA     nTotalGrossAmountBeforeTaxes  INIT  0
   DATA     nTotalGeneralDiscounts        INIT  0
   DATA     nTotalGeneralSurcharges       INIT  0
   DATA     nTotalTaxOutputs              INIT  0
   DATA     nTotalTaxesWithheld           INIT  0
   DATA     nInvoiceTotal                 INIT  0
   DATA     nTotalOutstandingAmount       INIT  0
   DATA     nTotalExecutableAmount        INIT  0
   DATA     nTotalReimbursableExpenses    INIT  0

   ACCESS   TotalGrossAmount              INLINE ( Alltrim( Trans( ::nTotalGrossAmount,            DoubleTwoDecimalPicture ) ) )
   ACCESS   InvoiceTotalAmount            INLINE ( Alltrim( Trans( ::nInvoiceTotalAmount,          DoubleTwoDecimalPicture ) ) )
   ACCESS   TotalOutstandingAmount        INLINE ( Alltrim( Trans( ::nTotalOutstandingAmount,      DoubleTwoDecimalPicture ) ) )
   ACCESS   TotalExecutableAmount         INLINE ( Alltrim( Trans( ::nTotalExecutableAmount,       DoubleTwoDecimalPicture ) ) )
   ACCESS   TotalGeneralSurcharges        INLINE ( Alltrim( Trans( ::nTotalGeneralSurcharges,      DoubleTwoDecimalPicture ) ) )

   ACCESS   TotalTaxOutputs               INLINE ( Alltrim( Trans( ::nTotalTaxOutputs,             DoubleTwoDecimalPicture ) ) )

   ACCESS   TotalGrossAmountBeforeTaxes   INLINE ( Alltrim( Trans( ::nTotalGrossAmountBeforeTaxes, DoubleTwoDecimalPicture ) ) )

   ACCESS   TotalGeneralDiscounts         INLINE ( Alltrim( Trans( ::nTotalGeneralDiscounts,       DoubleTwoDecimalPicture ) ) )

   ACCESS   TotalTaxesWithheld            INLINE ( Alltrim( Trans( ::nTotalTaxesWithheld,          DoubleTwoDecimalPicture ) ) )
   ACCESS   InvoiceTotal                  INLINE ( Alltrim( Trans( ::nInvoiceTotal,                DoubleTwoDecimalPicture ) ) )
   ACCESS   TotalOutstandingAmount        INLINE ( Alltrim( Trans( ::nTotalOutstandingAmount,      DoubleTwoDecimalPicture ) ) )
   ACCESS   TotalExecutableAmount         INLINE ( Alltrim( Trans( ::nTotalExecutableAmount,       DoubleTwoDecimalPicture ) ) )
   ACCESS   TotalReimbursableExpenses     INLINE ( Alltrim( Trans( ::nTotalReimbursableExpenses,   DoubleTwoDecimalPicture ) ) )

   DATA     cCorrectiveInvoiceNumber
   DATA     cCorrectiveReasonCode
   DATA     cCorrectiveReasonDescription
   DATA     cCorrectiveCorrectionMethod
   DATA     cCorrectiveCorrectionMethodDescription

   DATA     dCorrectiveStartDate
   DATA     dCorrectiveEndDate
   DATA     dIssueDate
   DATA     dOperationDate

   ACCESS   IssueDate                  INLINE ( dToIso( ::dIssueDate ) )
   ACCESS   OperationDate              INLINE ( dToIso( ::dOperationDate ) )
   ACCESS   CorrectiveStartDate        INLINE ( dToIso( ::dCorrectiveStartDate ) )
   ACCESS   CorrectiveEndDate          INLINE ( dToIso( ::dCorrectiveEndDate ) )

   DATA     cPlaceOfIssuePostCode
   DATA     cPlaceOfIssueDescription

   ACCESS   PlaceOfIssuePostCode       INLINE ( Rtrim( Left( ::cPlaceOfIssuePostCode, 9 ) ) )
   ACCESS   PlaceOfIssueDescription    INLINE ( Rtrim( Left( ::cPlaceOfIssueDescription, 20 ) ) )

   DATA     cTaxCurrencyCode
   DATA     cLanguageName

   DATA     oSellerParty
   DATA     oBuyerParty

   DATA     aTax
   DATA     aDiscount
   DATA     aItemLine
   DATA     aInstallment
   DATA     aAdministrativeCentres

   DATA     lError

   DATA     oMail
   DATA     cMailServer
   DATA     cMailServerPort
   DATA     cMailServerUserName
   DATA     cMailServerPassword
   DATA     cMailSubject
   DATA     cMailBody
   DATA     cMailRecipient

   METHOD New() CONSTRUCTOR

   METHOD Run()

   METHOD CreateDocument()
   METHOD DestroyDocument()            INLINE ( ::oXml   := nil )

   METHOD GenerateXml()
      METHOD HeaderXml()
      METHOD PartiesXml()
      METHOD InvoiceXml()
      METHOD TaxesXml()
      METHOD TotalXml()
      METHOD DiscountXml()
      METHOD ItemsXml()
      METHOD InstallmentXml()
      METHOD AdministrativeCentresXml( oAdministrativeCentre )

   METHOD ShowInWeb()
      METHOD startInWeb( oActiveX, oDlg )

   METHOD Firma()
   METHOD VerificaFirma()

   METHOD FirmaJava()

   METHOD Enviar()

   METHOD addItemLine( oItemLine )        INLINE ( aAdd( ::aItemLine, oItemLine ) )
   METHOD addInstallment( oInstallment )  INLINE ( aAdd( ::aInstallment, oInstallment ) )
   METHOD addAdministrativeCentres( aAdministrativeCentres ) ;
                                          INLINE ( aAdd( ::aAdministrativeCentres, aAdministrativeCentres ) )
   METHOD addTax( oTax )                  INLINE ( ::nTotalTaxOutputs += oTax:nTaxAmount, aAdd( ::aTax, oTax ), ::aTax )
   METHOD addDiscount( oDiscount )        INLINE ( ::nTotalGeneralDiscounts += oDiscount:nDiscountAmount, aAdd( ::aDiscount, oDiscount ), ::aDiscount )

   METHOD MailServerSend()                INLINE ( ::cMailServer + if( !Empty( ::cMailServerPort ), ":" + Alltrim( Str( ::cMailServerPort ) ), "" ) )

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := FacturaeModel():New( self ), ), ::oModel )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                    := oController

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD CreateDocument()

   local oError

   TRY
      ::oXml      := CreateObject( "MSXML2.DOMDocument.6.0" )   
   CATCH
      TRY
         ::oXml   := CreateObject( "MSXML2.DOMDocument" )
      CATCH oError
         msgstop( oError:SubSystem + ";" + padl( oError:SubCode, 4 ) + ";" + oError:Operation + ";" + oError:Description, "Error en la creacion de objeto" )  
      END
   END

RETURN ( hb_isobject( ::oXml ) )

//---------------------------------------------------------------------------//

METHOD Run()

   if !::CreateDocument()
      RETURN ( nil )
   end if 

   ::oXml:loadXML( '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' 
   // '<fe:Facturae xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:fe="http://www.facturae.es/Facturae/2009/v3.2/Facturae">'

   ::oXml:appendChild( ::oXml:createElement( "Familia" ) )

   ::oXml:Save( "c:\temp\andrew.xml" )

   // ::GenerateXml()

   ::DestroyDocument()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD GenerateXml()

   ::oXml         := TXmlDocument():new( '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' )

   /*
   Comienza el nodo principal--------------------------------------------------
   */

   ::oXmlNode     := TXmlNode():new( , "fe:Facturae",;
                                       {  "xmlns:ds" => "http://www.w3.org/2000/09/xmldsig#",;
                                          "xmlns:fe" => "http://www.facturae.es/Facturae/2009/v3.2/Facturae" } )

   ::HeaderXml()

   ::PartiesXml()

   ::InvoiceXml()

   ::oXml:oRoot:addBelow( ::oXmlNode )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD HeaderXml()

   /*
   Comienza el nodo header--------------------------------------------------
   */

   ::oXmlHeader   := TXmlNode():new( , 'FileHeader' )
      ::oXmlHeader:addBelow( TXmlNode():new( , 'SchemaVersion', ,       SCHEMAVERSION ) )
      ::oXmlHeader:addBelow( TXmlNode():new( , 'Modality', ,            MODALITY ) )
      ::oXmlHeader:addBelow( TXmlNode():new( , 'InvoiceIssuerType', ,   INVOICEISSUERTYPE ) )

      /*
      Comienza el nodo batch------------------------------------------------
      */

      ::oXmlBatch    := TXmlNode():new( , 'Batch' )
         ::oXmlBatch:addBelow( TXmlNode():new( , 'BatchIdentifier', ,   ::cInvoiceNumber ) )
         ::oXmlBatch:addBelow( TXmlNode():new( , 'InvoicesCount', ,     INVOICESCOUNT  ) )

         /*
         Comienza el nodo TotalInvoicesAmount-------------------------------
         */

         ::oXmlTotalInvoicesAmount  := TXmlNode():new( , 'TotalInvoicesAmount' )
            ::oXmlTotalInvoicesAmount:addBelow( TXmlNode():new( , 'TotalAmount', ,        ::InvoiceTotalAmount() ) )
            ::oXmlTotalInvoicesAmount:addBelow( TXmlNode():new( , 'EquivalentInEuros', ,  EQUIVALENTINEUROS ) )

         ::oXmlBatch:addBelow( ::oXmlTotalInvoicesAmount )

         /*
         Comienza el nodo TotalOutstandingAmount----------------------------
         */

         ::oXmlTotalOutstandingAmount  := TXmlNode():new( , 'TotalOutstandingAmount' )
            ::oXmlTotalOutstandingAmount:addBelow( TXmlNode():new( , 'TotalAmount', ,        ::TotalOutstandingAmount() ) )
            ::oXmlTotalOutstandingAmount:addBelow( TXmlNode():new( , 'EquivalentInEuros', ,  EQUIVALENTINEUROS ) )

         ::oXmlBatch:addBelow( ::oXmlTotalOutstandingAmount )

         /*
         Comienza el nodo TotalExecutableAmount----------------------------
         */

         ::oXmlTotalExecutableAmount  := TXmlNode():new( , 'TotalExecutableAmount' )
            ::oXmlTotalExecutableAmount:addBelow( TXmlNode():new( , 'TotalAmount', ,         ::TotalExecutableAmount() ) )
            ::oXmlTotalExecutableAmount:addBelow( TXmlNode():new( , 'EquivalentInEuros', ,   EQUIVALENTINEUROS ) )

         ::oXmlBatch:addBelow( ::oXmlTotalExecutableAmount )

         /*
         Comienza el nodo InvoiceCurrencyCode----------------------------
         */

         ::oXmlBatch:addBelow( TXmlNode():new( , 'InvoiceCurrencyCode', , ::cInvoiceCurrencyCode ) )

      ::oXmlHeader:addBelow( ::oXmlBatch )

   ::oXmlNode:addBelow( ::oXmlHeader )

Return ( self )

//---------------------------------------------------------------------------//

METHOD PartiesXml()

   local oAdministrativeCentre

   /*
   Comienza el nodo parties----------------------------------------------------
   */

   ::oXmlParties   := TXmlNode():new( , 'Parties' )

      /*
      Comienza el nodo SellerParty---------------------------------------------
      */

      ::oXmlSellerParty    := TXmlNode():new( , 'SellerParty' )

         /*
         Comienza el nodo TotalInvoicesAmount-------------------------------
         */

         ::oXmlTaxIdentification  := TXmlNode():new( , 'TaxIdentification' )
            ::oXmlTaxIdentification:addBelow( TXmlNode():new( , 'PersonTypeCode', ,          ::oSellerParty:cPersonTypeCode ) )
            ::oXmlTaxIdentification:addBelow( TXmlNode():new( , 'ResidenceTypeCode', ,       ::oSellerParty:cResidenceTypeCode ) )
            ::oXmlTaxIdentification:addBelow( TXmlNode():new( , 'TaxIdentificationNumber', , ::oSellerParty:TaxIdentificationNumber() ) )

         ::oXmlSellerParty:addBelow( ::oXmlTaxIdentification )

         /*
         Comienza el nodo LegalEntity------------------------------------------
         */

         if !Empty( ::oSellerParty:cCorporateName )

            ::oXmlLegalEntity  := TXmlNode():new( , 'LegalEntity' )

               if !Empty( ::oSellerParty:CorporateName() )
                  ::oXmlLegalEntity:addBelow( TXmlNode():new( , 'CorporateName', ,  ::oSellerParty:CorporateName() ) )
               end if

               if !Empty( ::oSellerParty:TradeName() )
                  ::oXmlLegalEntity:addBelow( TXmlNode():new( , 'TradeName', ,      ::oSellerParty:TradeName() ) )
               end if

               ::oXmlRegistrationData  := TXmlNode():new( , 'RegistrationData' )

                  if !Empty( ::oSellerParty:nBook )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'Book', ,                        ::oSellerParty:nBook ) )
                  end if

                  if !Empty( ::oSellerParty:cRegisterOfCompaniesLocation )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'RegisterOfCompaniesLocation', , ::oSellerParty:cRegisterOfCompaniesLocation ) )
                  end if

                  if !Empty( ::oSellerParty:nSheet )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'Sheet', ,                       ::oSellerParty:nSheet ) )
                  end if

                  if !Empty( ::oSellerParty:nFolio )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'Folio', ,                       ::oSellerParty:nFolio ) )
                  end if

                  if !Empty( ::oSellerParty:cSection )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'Section', ,                     ::oSellerParty:cSection ) )
                  end if

                  if !Empty( ::oSellerParty:nVolume )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'Volume', ,                      ::oSellerParty:nVolume ) )
                  end if

                  if !Empty( ::oSellerParty:AditionalRegistrationData() )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'AditionalRegistrationData', ,   ::oSellerParty:AditionalRegistrationData() ) )
                  end if

               ::oXmlLegalEntity:addBelow( ::oXmlRegistrationData )

               /*
               Comienza el nodo de direcciones------------------------------------
               */

               ::oXmlAddressInSpain  := TXmlNode():new( , 'AddressInSpain' )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Address', ,     ::oSellerParty:Address() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'PostCode', ,    ::oSellerParty:PostCode() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Town', ,        ::oSellerParty:Town() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Province', ,    ::oSellerParty:Province() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'CountryCode', , ::oSellerParty:CountryCode() ) )

               ::oXmlLegalEntity:addBelow( ::oXmlAddressInSpain )

               ::oXmlContactDetails := TXmlNode():new( , 'ContactDetails' )

                  if !Empty( ::oSellerParty:Telephone() )
                     ::oXmlContactDetails:addBelow( TXmlNode():new( , 'Telephone', ,      ::oSellerParty:Telephone() ) )
                  end if

                  if !Empty( ::oSellerParty:cTelFax )
                     ::oXmlContactDetails:addBelow( TXmlNode():new( , 'TeleFax', ,        ::oSellerParty:cTelFax ) )
                  end if

                  if !Empty( ::oSellerParty:cWebAddress )
                     ::oXmlContactDetails:addBelow( TXmlNode():new( , 'WebAddress', ,     ::oSellerParty:cWebAddress ) )
                  end if

                  if !Empty( ::oSellerParty:cElectronicMail )
                     ::oXmlContactDetails:addBelow( TXmlNode():new( , 'ElectronicMail', , ::oSellerParty:cElectronicMail ) )
                  end if

                  ::oXmlLegalEntity:addBelow( ::oXmlContactDetails )

               ::oXmlSellerParty:addBelow( ::oXmlLegalEntity )

            ::oXmlParties:addBelow( ::oXmlSellerParty )

         end if

         /*
         Comienza el nodo Individual------------------------------------------
         */

         if !Empty( ::oSellerParty:cName )

            ::oXmlLegalEntity  := TXmlNode():new( , 'Individual' )

               if !Empty( ::oSellerParty:cName )
                  ::oXmlLegalEntity:addBelow( TXmlNode():new( , 'Name', ,  ::oSellerParty:Name() ) )
               end if

               if !Empty( ::oSellerParty:cName ) .or. !Empty( ::oSellerParty:cFirstSurname )
                  ::oXmlLegalEntity:addBelow( TXmlNode():new( , 'FirstSurname', , ::oSellerParty:FirstSurname() ) )
               end if

               if !Empty( ::oSellerParty:cSecondSurname )
                  ::oXmlLegalEntity:addBelow( TXmlNode():new( , 'SecondSurname', , ::oSellerParty:SecondSurname() ) )
               end if

               /*
               Comienza el nodo de direcciones------------------------------------
               */

               ::oXmlAddressInSpain  := TXmlNode():new( , 'AddressInSpain' )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Address', ,     ::oSellerParty:Address() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'PostCode', ,    ::oSellerParty:PostCode() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Town', ,        ::oSellerParty:Town() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Province', ,    ::oSellerParty:Province() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'CountryCode', , ::oSellerParty:CountryCode() ) )

               ::oXmlLegalEntity:addBelow( ::oXmlAddressInSpain )

               ::oXmlContactDetails := TXmlNode():new( , 'ContactDetails' )

                  if !Empty( ::oSellerParty:Telephone() )
                     ::oXmlContactDetails:addBelow( TXmlNode():new( , 'Telephone', ,      ::oSellerParty:Telephone() ) )
                  end if

                  if !Empty( ::oSellerParty:cTelFax )
                     ::oXmlContactDetails:addBelow( TXmlNode():new( , 'TeleFax', ,        ::oSellerParty:cTelFax ) )
                  end if

                  if !Empty( ::oSellerParty:cWebAddress )
                     ::oXmlContactDetails:addBelow( TXmlNode():new( , 'WebAddress', ,     ::oSellerParty:cWebAddress ) )
                  end if

                  if !Empty( ::oSellerParty:cElectronicMail )
                     ::oXmlContactDetails:addBelow( TXmlNode():new( , 'ElectronicMail', , ::oSellerParty:cElectronicMail ) )
                  end if

                  ::oXmlLegalEntity:addBelow( ::oXmlContactDetails )

               ::oXmlSellerParty:addBelow( ::oXmlLegalEntity )

            ::oXmlParties:addBelow( ::oXmlSellerParty )

         end if

      /*
      Comienza el nodo BuyerParty---------------------------------------------
      */

      ::oXmlBuyerParty    := TXmlNode():new( , 'BuyerParty' )

         /*
         Comienza el nodo TaxIdentification-------------------------------
         */

         ::oXmlTaxIdentification  := TXmlNode():new( , 'TaxIdentification' )
            ::oXmlTaxIdentification:addBelow( TXmlNode():new( , 'PersonTypeCode', ,          ::oBuyerParty:cPersonTypeCode ) )
            ::oXmlTaxIdentification:addBelow( TXmlNode():new( , 'ResidenceTypeCode', ,       ::oBuyerParty:cResidenceTypeCode ) )
            ::oXmlTaxIdentification:addBelow( TXmlNode():new( , 'TaxIdentificationNumber', , ::oBuyerParty:TaxIdentificationNumber() ) )

         ::oXmlBuyerParty:addBelow( ::oXmlTaxIdentification )

         /*
         Comienza el nodo AdministrativeCentres-------------------------------
         */

         if !empty( ::aAdministrativeCentres )

            ::oXmlAdministrativeCentres      := TXmlNode():new( , 'AdministrativeCentres' )

            for each oAdministrativeCentre in ::aAdministrativeCentres
               ::AdministrativeCentresXml( oAdministrativeCentre )
            next 

            ::oXmlBuyerParty:addBelow( ::oXmlAdministrativeCentres )

         end if

         /*
         Comienza el nodo LegalEntity------------------------------------------
         */

         if !Empty( ::oBuyerParty:cCorporateName )

            ::oXmlLegalEntity  := TXmlNode():new( , 'LegalEntity' )

               if !Empty( ::oBuyerParty:CorporateName() )
                  ::oXmlLegalEntity:addBelow( TXmlNode():new( , 'CorporateName', ,  ::oBuyerParty:CorporateName() ) )
               end if

               if !Empty( ::oBuyerParty:TradeName() )
                  ::oXmlLegalEntity:addBelow( TXmlNode():new( , 'TradeName', ,      ::oBuyerParty:TradeName() ) )
               end if

               ::oXmlRegistrationData  := TXmlNode():new( , 'RegistrationData' )

                  if !Empty( ::oBuyerParty:nBook )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'Book', ,                        ::oBuyerParty:nBook ) )
                  end if

                  if !Empty( ::oBuyerParty:cRegisterOfCompaniesLocation )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'RegisterOfCompaniesLocation', , ::oBuyerParty:cRegisterOfCompaniesLocation ) )
                  end if

                  if !Empty( ::oBuyerParty:nSheet )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'Sheet', ,                       ::oBuyerParty:nSheet ) )
                  end if

                  if !Empty( ::oBuyerParty:nFolio )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'Folio', ,                       ::oBuyerParty:nFolio ) )
                  end if

                  if !Empty( ::oBuyerParty:cSection )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'Section', ,                     ::oBuyerParty:cSection ) )
                  end if

                  if !Empty( ::oBuyerParty:nVolume )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'Volume', ,                      ::oBuyerParty:nVolume ) )
                  end if

                  if !Empty( ::oBuyerParty:cAditionalRegistrationData )
                     ::oXmlRegistrationData:addBelow( TXmlNode():new( , 'AditionalRegistrationData', ,   ::oBuyerParty:cAditionalRegistrationData ) )
                  end if

               ::oXmlLegalEntity:addBelow( ::oXmlRegistrationData )

               /*
               Comienza el nodo de direcciones------------------------------------
               */

               ::oXmlAddressInSpain  := TXmlNode():new( , 'AddressInSpain' )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Address', ,     ::oBuyerParty:Address() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'PostCode', ,    ::oBuyerParty:PostCode() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Town', ,        ::oBuyerParty:Town() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Province', ,    ::oBuyerParty:Province() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'CountryCode', , ::oBuyerParty:CountryCode() ) )

               ::oXmlLegalEntity:addBelow( ::oXmlAddressInSpain )

               ::oXmlContactDetails := TXmlNode():new( , 'ContactDetails' )

                  if !Empty( ::oBuyerParty:Telephone )
                     ::oXmlContactDetails:addBelow( TXmlNode():new( , 'Telephone', ,   ::oBuyerParty:Telephone() ) )
                  end if

                  if !Empty( ::oBuyerParty:TelFax() )
                     ::oXmlContactDetails:addBelow( TXmlNode():new( , 'TeleFax', ,     ::oBuyerParty:TelFax() ) )
               end if

               if !Empty( ::oBuyerParty:WebAddress() )
                  ::oXmlContactDetails:addBelow( TXmlNode():new( , 'WebAddress', ,     ::oBuyerParty:WebAddress() ) )
               end if

               if !Empty( ::oBuyerParty:ElectronicMail() )
                  ::oXmlContactDetails:addBelow( TXmlNode():new( , 'ElectronicMail', , ::oBuyerParty:ElectronicMail() ) )
               end if

               ::oXmlLegalEntity:addBelow( ::oXmlContactDetails )

            ::oXmlBuyerParty:addBelow( ::oXmlLegalEntity )

         end if

         /*
         Comienza el nodo Individual------------------------------------------
         */

         if !Empty( ::oBuyerParty:cName )

            ::oXmlLegalEntity  := TXmlNode():new( , 'Individual' )

               if !Empty( ::oBuyerParty:cName )
                  ::oXmlLegalEntity:addBelow( TXmlNode():new( , 'Name', ,  ::oBuyerParty:Name() ) )
               end if

               if !Empty( ::oBuyerParty:cFirstSurname )
                  ::oXmlLegalEntity:addBelow( TXmlNode():new( , 'FirstSurname', ,  ::oBuyerParty:FirstSurname() ) )
               end if

               if !Empty( ::oBuyerParty:cSecondSurname() )
                  ::oXmlLegalEntity:addBelow( TXmlNode():new( , 'SecondSurname', ,  ::oBuyerParty:SecondSurname() ) )
               end if

               /*
               Comienza el nodo de direcciones------------------------------------
               */

               ::oXmlAddressInSpain  := TXmlNode():new( , 'AddressInSpain' )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Address', ,     ::oBuyerParty:Address() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'PostCode', ,    ::oBuyerParty:PostCode() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Town', ,        ::oBuyerParty:Town() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Province', ,    ::oBuyerParty:Province() ) )
                  ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'CountryCode', , ::oBuyerParty:CountryCode() ) )

               ::oXmlLegalEntity:addBelow( ::oXmlAddressInSpain )

               ::oXmlContactDetails := TXmlNode():new( , 'ContactDetails' )

               if !Empty( ::oBuyerParty:Telephone() )
                  ::oXmlContactDetails:addBelow( TXmlNode():new( , 'Telephone', ,      ::oBuyerParty:Telephone() ) )
               end if

               if !Empty( ::oBuyerParty:TelFax() )
                  ::oXmlContactDetails:addBelow( TXmlNode():new( , 'TeleFax', ,        ::oBuyerParty:TelFax() ) )
               end if

               if !Empty( ::oBuyerParty:WebAddress() )
                  ::oXmlContactDetails:addBelow( TXmlNode():new( , 'WebAddress', ,     ::oBuyerParty:WebAddress() ) )
               end if

               if !Empty( ::oBuyerParty:ElectronicMail() )
                  ::oXmlContactDetails:addBelow( TXmlNode():new( , 'ElectronicMail', , ::oBuyerParty:ElectronicMail() ) )
               end if

               ::oXmlLegalEntity:addBelow( ::oXmlContactDetails )

            ::oXmlBuyerParty:addBelow( ::oXmlLegalEntity )

         end if

         ::oXmlParties:addBelow( ::oXmlBuyerParty )

      ::oXmlNode:addBelow( ::oXmlParties )

Return ( self )

//---------------------------------------------------------------------------//

METHOD InvoiceXml()

   local oTax
   local oItem
   local oInstallment

   /*
   Comienza el nodo header--------------------------------------------------
   */

   ::oXmlInvoices    := TXmlNode():new( , 'Invoices' )

      ::oXmlInvoice  := TXmlNode():new( , 'Invoice' )

         /*
         Inicio de InvoiceHeader-----------------------------------------------
         */

         ::oXmlInvoiceHeader  := TXmlNode():new( , 'InvoiceHeader' )
            ::oXmlInvoiceHeader:addBelow( TXmlNode():new( , 'InvoiceNumber', ,         ::cInvoiceNumber ) )
            ::oXmlInvoiceHeader:addBelow( TXmlNode():new( , 'InvoiceSeriesCode', ,     ::cInvoiceSeriesCode ) )
            ::oXmlInvoiceHeader:addBelow( TXmlNode():new( , 'InvoiceDocumentType', ,   INVOICEDOCUMENTTYPE ) )
            ::oXmlInvoiceHeader:addBelow( TXmlNode():new( , 'InvoiceClass', ,          INVOICECLASS ) )

            /*
            Inicio de factura rectificativa rellenar solo si es el caso--------
            */

            if !Empty( ::cCorrectiveInvoiceNumber )

               ::oXmlCorrective  := TXmlNode():new( , 'Corrective' )
                  ::oXmlCorrective:addBelow( TXmlNode():new( , 'InvoiceNumber', ,      ::cCorrectiveInvoiceNumber ) )
                  ::oXmlCorrective:addBelow( TXmlNode():new( , 'ReasonCode', ,         ::cCorrectiveReasonCode ) )
                  ::oXmlCorrective:addBelow( TXmlNode():new( , 'ReasonDescription', ,  ::cCorrectiveReasonDescription ) )

                  ::oXmlTaxPeriod   := TXmlNode():new( , 'TaxPeriod' )
                     ::oXmlTaxPeriod:addBelow( TXmlNode():new( , 'StartDate', ,  ::CorrectiveStartDate() ) )
                     ::oXmlTaxPeriod:addBelow( TXmlNode():new( , 'EndDate', ,    ::CorrectiveEndDate() ) )

                  ::oXmlCorrective:addBelow( ::oXmlTaxPeriod )

                  ::oXmlCorrective:addBelow( TXmlNode():new( , 'CorrectionMethod', ,            ::cCorrectiveCorrectionMethod ) )
                  ::oXmlCorrective:addBelow( TXmlNode():new( , 'CorrectionMethodDescription', , ::cCorrectiveCorrectionMethodDescription ) )

               ::oXmlInvoiceHeader:addBelow( ::oXmlCorrective )

            end if

         ::oXmlInvoice:addBelow( ::oXmlInvoiceHeader )

         /*
         Fin de InvoiceHeader--------------------------------------------------
         */

         /*
         Inicio de IssueData---------------------------------------------------
         */

         if !Empty( ::dIssueDate )

            ::oXmlInvoiceIssueData  := TXmlNode():new( , 'InvoiceIssueData' )

               ::oXmlInvoiceIssueData:addBelow( TXmlNode():new( , 'IssueDate', ,      ::IssueDate() ) )
               ::oXmlInvoiceIssueData:addBelow( TXmlNode():new( , 'OperationDate', ,  ::OperationDate() ) )

               ::oXmlPlaceOfIssue  := TXmlNode():new( , 'PlaceOfIssue' )

                  ::oXmlPlaceOfIssue:addBelow( TXmlNode():new( , 'PostCode', ,                 ::PlaceOfIssuePostCode() ) )
                  ::oXmlPlaceOfIssue:addBelow( TXmlNode():new( , 'PlaceOfIssueDescription', ,  ::PlaceOfIssueDescription() ) )

               ::oXmlInvoiceIssueData:addBelow( ::oXmlPlaceOfIssue )

               ::oXmlInvoiceIssueData:addBelow( TXmlNode():new( , 'InvoiceCurrencyCode', ,   ::cInvoiceCurrencyCode ) )
               ::oXmlInvoiceIssueData:addBelow( TXmlNode():new( , 'TaxCurrencyCode', ,       ::cTaxCurrencyCode ) )
               ::oXmlInvoiceIssueData:addBelow( TXmlNode():new( , 'LanguageName', ,          ::cLanguageName ) )

            ::oXmlInvoice:addBelow( ::oXmlInvoiceIssueData )

         end if

         /*
         Comenzamos los Taxes--------------------------------------------------
         */

         ::oXmlTaxesOutputs   := TXmlNode():new( , 'TaxesOutputs' )

            for each oTax in ::aTax

               ::TaxesXml( oTax )

               ::oXmlTaxesOutputs:addBelow( ::oXmlTax )

            next

         ::oXmlInvoice:addBelow( ::oXmlTaxesOutputs )

         /*
         Comenzamos los Totals-------------------------------------------------
         */

         ::TotalXml()

         /*
         Comenzamos las lineas-------------------------------------------------
         */

         if !Empty( ::aItemLine )

            ::oXmlItems := TXmlNode():new( , 'Items' )

               for each oItem in ::aItemLine

                  ::ItemsXml( oItem )

                  ::oXmlItems:addBelow( ::oXmlInvoiceLine )

               next

            ::oXmlInvoice:addBelow( ::oXmlItems )

         end if

         /*
         Comenzamos los pagos--------------------------------------------------
         */

         if !Empty( ::aInstallment )

            ::oXmlPaymentDetails := TXmlNode():new( , 'PaymentDetails' )

            for each oInstallment in ::aInstallment

               ::InstallmentXml( oInstallment )

               ::oXmlPaymentDetails:addBelow( ::oXmlInstallment )

            next

            ::oXmlInvoice:addBelow( ::oXmlPaymentDetails )

         end if

         /*
         Fin de los pagos--------------------------------------------------
         */

      ::oXmlInvoices:addBelow( ::oXmlInvoice )

   ::oXmlNode:addBelow( ::oXmlInvoices )

Return ( self )

//---------------------------------------------------------------------------//

METHOD TaxesXml( oTax )

   if Empty( oTax )
      Return ( nil )
   end if
/*
   if oTax:nTaxBase == 0
      Return ( nil )
   end if
*/
   /*
   Inicio de InvoiceHeader-----------------------------------------------------
   */

   ::oXmlTax         := TXmlNode():new( , 'Tax' )

   /*
   Tipo de impuestos--------------------------------------------------------------
   */

   ::oXmlTax:addBelow( TXmlNode():new( , 'TaxTypeCode', ,   oTax:cTaxTypeCode ) )
   ::oXmlTax:addBelow( TXmlNode():new( , 'TaxRate', ,       oTax:TaxRate() ) )

   ::oXmlTaxableBase := TXmlNode():new( , 'TaxableBase' )

      ::oXmlTaxableBase:addBelow( TXmlNode():new( , 'TotalAmount', ,       oTax:TaxBase() ) )
      ::oXmlTaxableBase:addBelow( TXmlNode():new( , 'EquivalentInEuros', , EQUIVALENTINEUROS ) )

   ::oXmlTax:addBelow( ::oXmlTaxableBase )

   ::oXmlTaxAmount   := TXmlNode():new( , 'TaxAmount' )

      ::oXmlTaxAmount:addBelow( TXmlNode():new( , 'TotalAmount', ,         oTax:TaxAmount() ) )
      ::oXmlTaxAmount:addBelow( TXmlNode():new( , 'EquivalentInEuros', ,   EQUIVALENTINEUROS ) )

   ::oXmlTax:addBelow( ::oXmlTaxAmount )

   /*
   Recargo de equivalencia--------------------------------------------------
   */

   if oTax:nEquivalenceSurchargeAmount != 0

      ::oXmlTax:addBelow( TXmlNode():new( , 'EquivalenceSurcharge', ,   oTax:EquivalenceSurcharge() ) )

      ::oXmlEquivalenceSurcharge := TXmlNode():new( , 'EquivalenceSurchargeAmount' )

         ::oXmlEquivalenceSurcharge:addBelow( TXmlNode():new( , 'TotalAmount', ,         oTax:EquivalenceSurchargeAmount() ) )
         ::oXmlEquivalenceSurcharge:addBelow( TXmlNode():new( , 'EquivalentInEuros', ,   EQUIVALENTINEUROS ) )

      ::oXmlTax:addBelow( ::oXmlEquivalenceSurcharge )

   end if

Return ( ::oXmlTax )

//---------------------------------------------------------------------------//

METHOD AdministrativeCentresXml( oAdministrativeCentre )

   local oXmlCentreDescription

   ::oXmlAdministrativeCentre    := TXmlNode():new( , 'AdministrativeCentre' )

      ::oXmlAdministrativeCentre:addBelow( TXmlNode():new( , 'CentreCode', ,     oAdministrativeCentre:CentreCode() ) )
      ::oXmlAdministrativeCentre:addBelow( TXmlNode():new( , 'RoleTypeCode', ,   oAdministrativeCentre:RoleTypeCode() ) )

      ::oXmlAddressInSpain       := TXmlNode():new( , 'AddressInSpain' )
         ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Address', ,     oAdministrativeCentre:Address() ) )
         ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'PostCode', ,    oAdministrativeCentre:PostCode() ) )
         ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Town', ,        oAdministrativeCentre:Town() ) )
         ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Province', ,    oAdministrativeCentre:Province() ) )
         ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'CountryCode', , oAdministrativeCentre:CountryCode() ) )

      ::oXmlAdministrativeCentre:addBelow( ::oXmlAddressInSpain )

      oXmlCentreDescription      := TXmlNode():new( , 'CentreDescription', , oAdministrativeCentre:CentreDescription() )
      ::oXmlAdministrativeCentre:addBelow( oXmlCentreDescription )

   ::oXmlAdministrativeCentres:addBelow( ::oXmlAdministrativeCentre )

Return ( self )

//---------------------------------------------------------------------------//

METHOD TotalXml()

   local oDiscount

   ::oXmlInvoiceTotals   := TXmlNode():new( , 'InvoiceTotals' )

      if !Empty( ::TotalGrossAmount() )
         ::oXmlInvoiceTotals:addBelow( TXmlNode():new( , 'TotalGrossAmount', ,   ::TotalGrossAmount() ) )
      end if

      /*
      Descuentos generales-----------------------------------------------------
      */

      if !Empty( ::aDiscount )

         ::oXmlGeneralDiscounts  := TXmlNode():new( , 'GeneralDiscounts' )

            for each oDiscount in ::aDiscount

               ::DiscountXml( oDiscount )

               ::oXmlGeneralDiscounts:addBelow( ::oXmlDiscount )

            next

         ::oXmlInvoiceTotals:addBelow( ::oXmlGeneralDiscounts )

      end if

      /*
      Fin de descuentos generales----------------------------------------------
      */

      if !Empty( ::TotalGeneralDiscounts() )
         ::oXmlInvoiceTotals:addBelow( TXmlNode():new( , 'TotalGeneralDiscounts', ,       ::TotalGeneralDiscounts() ) )
      end if

      if !Empty( ::TotalGeneralSurcharges() )
         ::oXmlInvoiceTotals:addBelow( TXmlNode():new( , 'TotalGeneralSurcharges', ,      ::TotalGeneralSurcharges() ) )
      end if

      if !Empty( ::TotalGrossAmountBeforeTaxes() )
         ::oXmlInvoiceTotals:addBelow( TXmlNode():new( , 'TotalGrossAmountBeforeTaxes', , ::TotalGrossAmountBeforeTaxes() ) )
      end if

      if !Empty( ::TotalTaxOutputs() )
         ::oXmlInvoiceTotals:addBelow( TXmlNode():new( , 'TotalTaxOutputs', ,             ::TotalTaxOutputs() ) )
      end if

      if !Empty( ::TotalTaxesWithheld() )
         ::oXmlInvoiceTotals:addBelow( TXmlNode():new( , 'TotalTaxesWithheld', ,          ::TotalTaxesWithheld() ) )
      end if

      if !Empty( ::InvoiceTotal() )
         ::oXmlInvoiceTotals:addBelow( TXmlNode():new( , 'InvoiceTotal', ,                ::InvoiceTotal() ) )
      end if

      if !Empty( ::TotalOutstandingAmount() )
         ::oXmlInvoiceTotals:addBelow( TXmlNode():new( , 'TotalOutstandingAmount', ,      ::TotalOutstandingAmount() ) )
      end if

      if !Empty( ::TotalExecutableAmount() )
         ::oXmlInvoiceTotals:addBelow( TXmlNode():new( , 'TotalExecutableAmount', ,       ::TotalExecutableAmount() ) )
      end if

      if !Empty( ::TotalReimbursableExpenses() )
         ::oXmlInvoiceTotals:addBelow( TXmlNode():new( , 'TotalReimbursableExpenses', ,   ::TotalReimbursableExpenses() ) )
      end if

   ::oXmlInvoice:addBelow( ::oXmlInvoiceTotals )

Return ( self )

//---------------------------------------------------------------------------//

METHOD DiscountXml( oDiscount )

   ::oXmlDiscount   := TXmlNode():new( , 'Discount' )

      ::oXmlDiscount:addBelow( TXmlNode():new( , 'DiscountReason', , oDiscount:DiscountReason() ) )

      if ( oDiscount:nDiscountRate != 0 )
         ::oXmlDiscount:addBelow( TXmlNode():new( , 'DiscountRate', ,   oDiscount:DiscountRate() ) )
      end if 

      ::oXmlDiscount:addBelow( TXmlNode():new( , 'DiscountAmount', , oDiscount:DiscountAmount() ) )

Return ( ::oXmlDiscount )

//---------------------------------------------------------------------------//

METHOD ItemsXml( oItemLine )

   local oTax
   local oDiscount

   ::oXmlInvoiceLine := TXmlNode():new( , 'InvoiceLine' )

   ::oXmlInvoiceLine:addBelow( TXmlNode():new( , 'ItemDescription', ,      oItemLine:ItemDescription() ) )
   ::oXmlInvoiceLine:addBelow( TXmlNode():new( , 'Quantity', ,             oItemLine:Quantity() ) )
   ::oXmlInvoiceLine:addBelow( TXmlNode():new( , 'UnitOfMeasure', ,        oItemLine:UnitOfMeasure() ) )
   ::oXmlInvoiceLine:addBelow( TXmlNode():new( , 'UnitPriceWithoutTax', ,  oItemLine:UnitPriceWithoutTax() ) )
   ::oXmlInvoiceLine:addBelow( TXmlNode():new( , 'TotalCost', ,            oItemLine:TotalCost() ) )

   /*
   Descuentos---------------------------------------------------------------
   */

   if !Empty( oItemLine:aDiscount )

      ::oXmlDiscountsAndRebates := TXmlNode():new( , 'DiscountsAndRebates' )

      for each oDiscount in oItemLine:aDiscount

         ::DiscountXml( oDiscount )

         ::oXmlDiscountsAndRebates:addBelow( ::oXmlDiscount )

      next

      ::oXmlInvoiceLine:addBelow( ::oXmlDiscountsAndRebates )

   end if

   ::oXmlInvoiceLine:addBelow( TXmlNode():new( , 'GrossAmount', , oItemLine:GrossAmount() ) )

   /*
   Comenzamos los Taxes--------------------------------------------------
   */

   if !Empty( oItemLine:aTax )

      ::oXmlTaxesOutputs   := TXmlNode():new( , 'TaxesOutputs' )

      for each oTax in oItemLine:aTax

         ::TaxesXml( oTax )

         ::oXmlTaxesOutputs:addBelow( ::oXmlTax )

      next

      ::oXmlInvoiceLine:addBelow( ::oXmlTaxesOutputs )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD InstallmentXml( oInstallment )

   ::oXmlInstallment := TXmlNode():new( , 'Installment' )

   ::oXmlInstallment:addBelow( TXmlNode():new( , 'InstallmentDueDate', ,   oInstallment:InstallmentDueDate() ) )
   ::oXmlInstallment:addBelow( TXmlNode():new( , 'InstallmentAmount', ,    oInstallment:InstallmentAmount() ) )
   ::oXmlInstallment:addBelow( TXmlNode():new( , 'PaymentMeans', ,         oInstallment:cPaymentMeans ) )

   if !Empty( oInstallment:oAccountToBeDebited )

      ::oXmlAccountToBeDebited  := TXmlNode():new( , 'AccountToBeDebited' )

         ::oXmlAccountToBeDebited:addBelow( TXmlNode():new( , 'IBAN', ,       oInstallment:oAccountToBeDebited:IBAN() ) )
         ::oXmlAccountToBeDebited:addBelow( TXmlNode():new( , 'BankCode', ,   oInstallment:oAccountToBeDebited:BankCode() ) )
         ::oXmlAccountToBeDebited:addBelow( TXmlNode():new( , 'BranchCode', , oInstallment:oAccountToBeDebited:BranchCode() ) )

         ::oXmlAddressInSpain  := TXmlNode():new( , 'AddressInSpain' )
            ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Address', ,     oInstallment:oAccountToBeDebited:Address() ) )
            ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'PostCode', ,    oInstallment:oAccountToBeDebited:PostCode() ) )
            ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Town', ,        oInstallment:oAccountToBeDebited:Town() ) )
            ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Province', ,    oInstallment:oAccountToBeDebited:Province() ) )
            ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'CountryCode', , oInstallment:oAccountToBeDebited:CountryCode() ) )

         ::oXmlAccountToBeDebited:addBelow( ::oXmlAddressInSpain )

      ::oXmlInstallment:addBelow( ::oXmlAccountToBeDebited )

   end if

   if !Empty( oInstallment:oAccountToBeCredited )

      ::oXmlAccountToBeCredited  := TXmlNode():new( , 'AccountToBeCredited' )

         ::oXmlAccountToBeCredited:addBelow( TXmlNode():new( , 'IBAN', ,         oInstallment:oAccountToBeCredited:IBAN() ) )
         ::oXmlAccountToBeCredited:addBelow( TXmlNode():new( , 'BankCode', ,     oInstallment:oAccountToBeCredited:BankCode() ) )
         ::oXmlAccountToBeCredited:addBelow( TXmlNode():new( , 'BranchCode', ,   oInstallment:oAccountToBeCredited:BranchCode() ) )

         ::oXmlAddressInSpain  := TXmlNode():new( , 'BranchInSpainAddress' )
            ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Address', ,        oInstallment:oAccountToBeCredited:Address() ) )
            ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'PostCode', ,       oInstallment:oAccountToBeCredited:PostCode() ) )
            ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Town', ,           oInstallment:oAccountToBeCredited:Town() ) )
            ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'Province', ,       oInstallment:oAccountToBeCredited:Province() ) )
            ::oXmlAddressInSpain:addBelow( TXmlNode():new( , 'CountryCode', ,    oInstallment:oAccountToBeCredited:CountryCode() ) )

         ::oXmlAccountToBeCredited:addBelow( ::oXmlAddressInSpain )

      ::oXmlInstallment:addBelow( ::oXmlAccountToBeCredited )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD Firma()

   local xRet
   local hLib
   local oNode
   local oError
   local oBlock

   if !File( FullCurDir() + "\aeatfact.dll")
      ::oTree:Add( "No existe el componente AeatFact.Dll" )
      Return ( Self )
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oFirma    := CreateObject( "AEATFACT.AeatFactCtl" )

   RECOVER USING oError

      WaitRun( "regsvr32 /s " + FullcurDir() + "AeatFact.Dll" )

      ::oFirma    := CreateObject( "AEATFACT.AeatFactCtl" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( ::oFirma )

      xRet        := ::oFirma:FIRMA( ::cFicheroOrigen, ::cNif, ::cFicheroDestino )
      xRet        := ::oFirma:VERIFICA( ::cFicheroOrigen, ::cFicheroDestino )

      if Left( xRet, 2 ) == "00"

         oNode := ::oTree:Add( "Firma digital realizada satisfactoriamente.", 1 )

         oNode:Add( xRet, 1 )
         oNode:Expand()

      else

         oNode := ::oTree:Add( "Error al realizar la firma digital." )

         oNode:Add( xRet )
         oNode:Expand()

      end if

   else

      ::oTree:Add( "No se ha podido crear el objeto para la firma digital." )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD VerificaFirma()

   local xRet
   local oError
   local oBlock

   if !File( FullCurDir() + "\aeatfact.dll")
      ::oTree:Add( "No existe el componente AeatFact.Dll" )
      Return ( Self )
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oFirma    := CreateObject( "AEATFACT.AeatFactCtl" )

   RECOVER USING oError

      WaitRun( "regsvr32 /s " + FullcurDir() + "AeatFact.Dll" )

      ::oFirma    := CreateObject( "AEATFACT.AeatFactCtl" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( ::oFirma )

      xRet        := ::oFirma:VERIFICA( ::cFicheroOrigen, ::cFicheroDestino )

      ::oTree:Add( xRet, if( Left( xRet, 2 ) == "00", 1, 0 ) )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD FirmaJava()

   local oError
   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      logwrite(   "java -jar " + fullcurdir() + "firma\firma.jar " + ::cFicheroOrigen + space(1) + ::cFicheroDestino + space( 1 ) + "Explorer 0" )
      waitRun(    "java -jar " + fullcurdir() + "firma\firma.jar " + ::cFicheroOrigen + space(1) + ::cFicheroDestino + space( 1 ) + "Explorer 0", 6 )

      ::oTree:Add( "Proceso de firma digital iniciado.", 1 )

   RECOVER USING oError

      ::oTree:Add( "No se ha podido realizar la firma digital." )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( self )

//---------------------------------------------------------------------------//

METHOD Enviar()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD ShowInWeb()

   local oDlg
   local oActiveX

   DEFINE DIALOG oDlg         RESOURCE "ShowFacturae"

   REDEFINE ACTIVEX oActiveX  ID 100      OF oDlg  PROGID "Shell.Explorer"

   REDEFINE BUTTON            ID IDCANCEL OF oDlg  ACTION ( oDlg:End() )

   oDlg:bStart                := {|| ::startInWeb( oActiveX, oDlg ) }

   ACTIVATE DIALOG oDlg CENTERED

Return ( self )

//---------------------------------------------------------------------------//

METHOD startInWeb( oActiveX, oDlg )

   if file( ::cFicheroDestino )
      oActiveX:Do( "Navigate", ::cFicheroDestino )
   else
      oActiveX:Do( "Navigate", ::cFicheroOrigen )
   end if 

   sysRefresh()

Return ( self )

//---------------------------------------------------------------------------//

