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

CLASS FacturaeModel

   DATA oController

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

   DATA  cXmlFile
   DATA  cSignedXmlFile
   DATA  cNif

   DATA cInvoiceNumber
   DATA cInvoiceSeriesCode
   DATA cInvoiceCurrencyCode

   DATA nInvoiceTotalAmount
   METHOD setInvoiceTotalAmount( nInvoiceTotalAmount ) ;
                                       INLINE ( ::nInvoiceTotalAmount := nInvoiceTotalAmount )
   ACCESS InvoiceTotalAmount           INLINE ( alltrim( Trans( ::nInvoiceTotalAmount, DoubleTwoDecimalPicture ) ) )
   
   DATA nTotalOutstandingAmount    
   METHOD setTotalOutstandingAmount( nTotalOutstandingAmount ) ;
                                       INLINE ( ::nTotalOutstandingAmount := nTotalOutstandingAmount )
   ACCESS TotalOutstandingAmount       INLINE ( alltrim( Trans( ::nTotalOutstandingAmount, DoubleTwoDecimalPicture ) ) )
   
   DATA nTotalExecutableAmount         
   METHOD setTotalExecutableAmount( nTotalExecutableAmount ) ;
                                       INLINE ( ::nTotalExecutableAmount := nTotalExecutableAmount )
   ACCESS TotalExecutableAmount        INLINE ( alltrim( Trans( ::nTotalExecutableAmount, DoubleTwoDecimalPicture ) ) )

   DATA     nTotalGrossAmount             INIT  0
   DATA     nTotalGrossAmountBeforeTaxes  INIT  0
   DATA     nTotalGeneralDiscounts        INIT  0
   DATA     nTotalGeneralSurcharges       INIT  0
   DATA     nTotalTaxOutputs              INIT  0
   DATA     nTotalTaxesWithheld           INIT  0
   DATA     nInvoiceTotal                 INIT  0
   DATA     nTotalReimbursableExpenses    INIT  0

   ACCESS   TotalGrossAmount              INLINE ( alltrim( Trans( ::nTotalGrossAmount,            DoubleTwoDecimalPicture ) ) )
   ACCESS   TotalGeneralSurcharges        INLINE ( alltrim( Trans( ::nTotalGeneralSurcharges,      DoubleTwoDecimalPicture ) ) )

   ACCESS   TotalTaxOutputs               INLINE ( alltrim( Trans( ::nTotalTaxOutputs,             DoubleTwoDecimalPicture ) ) )

   ACCESS   TotalGrossAmountBeforeTaxes   INLINE ( alltrim( Trans( ::nTotalGrossAmountBeforeTaxes, DoubleTwoDecimalPicture ) ) )

   ACCESS   TotalGeneralDiscounts      INLINE ( alltrim( Trans( ::nTotalGeneralDiscounts,       DoubleTwoDecimalPicture ) ) )

   ACCESS   TotalTaxesWithheld         INLINE ( alltrim( Trans( ::nTotalTaxesWithheld,          DoubleTwoDecimalPicture ) ) )
   ACCESS   InvoiceTotal               INLINE ( alltrim( Trans( ::nInvoiceTotal,                DoubleTwoDecimalPicture ) ) )
   ACCESS   TotalReimbursableExpenses  INLINE ( alltrim( Trans( ::nTotalReimbursableExpenses,   DoubleTwoDecimalPicture ) ) )

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

   ACCESS   PlaceOfIssuePostCode       INLINE ( Rtrim( left( ::cPlaceOfIssuePostCode, 9 ) ) )
   ACCESS   PlaceOfIssueDescription    INLINE ( Rtrim( left( ::cPlaceOfIssueDescription, 20 ) ) )

   DATA     cTaxCurrencyCode
   DATA     cLanguageName

   DATA     oSellerParty
   DATA     oBuyerParty

   DATA     aTax
   DATA     aDiscount
   DATA     aItemLines
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

   METHOD End() VIRTUAL

   METHOD Default()

   METHOD Generate()

   METHOD CreateDocument()
   METHOD DestroyDocument()            INLINE ( ::oXml := nil )
   METHOD saveDocument()               INLINE ( ::oXml:Save( ::cXmlFile ) )

   METHOD createXmlNode( cName, cText ) 
   METHOD createCDataXmlNode( cName, cData )

   METHOD setInvoiceNumber( cInvoiceNumber )

   METHOD initialXML()
   METHOD headerXml()
   METHOD partiesXml()
   METHOD invoiceXml()
   METHOD taxesXml()
   METHOD totalXml()
   METHOD discountXml()
   METHOD itemsXml()
   METHOD installmentXml()
   METHOD administrativeCentresXml( oAdministrativeCentre )

   METHOD ShowInWeb()
      METHOD startInWeb( oActiveX, oDlg )

   METHOD Firma()
   METHOD VerificaFirma()

   METHOD FirmaJava()

   METHOD Enviar()

   METHOD addItemLine( oItemLine )     INLINE ( aadd( ::aItemLines, oItemLine ) )

   METHOD addInstallment( oInstallment );
                                       INLINE ( aadd( ::aInstallment, oInstallment ) )

   METHOD addAdministrativeCentres( aAdministrativeCentres ) ;
                                       INLINE ( aadd( ::aAdministrativeCentres, aAdministrativeCentres ) )
   
   METHOD addTax( oTax )               INLINE ( ::nTotalTaxOutputs += oTax:nTaxAmount,;
                                                aadd( ::aTax, oTax ), ::aTax )
   
   METHOD addDiscount( oDiscount )     INLINE ( ::nTotalGeneralDiscounts += oDiscount:nDiscountAmount,;
                                                aadd( ::aDiscount, oDiscount ), ::aDiscount )

   METHOD MailServerSend()             INLINE ( ::cMailServer + if( !empty( ::cMailServerPort ), ":" + alltrim( Str( ::cMailServerPort ) ), "" ) )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                       := oController

   ::Default()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Default()

   ::cInvoiceCurrencyCode              := 'EUR'
   ::cLanguageName                     := 'es'

   ::nTotalGrossAmount                 := 0
   ::nTotalGeneralDiscounts            := 0
   ::nTotalGeneralSurcharges           := 0
   ::nTotalGrossAmountBeforeTaxes      := 0
   ::nTotalTaxOutputs                  := 0
   ::nTotalTaxesWithheld               := 0
   ::nInvoiceTotal                     := 0
   ::nTotalOutstandingAmount           := 0
   ::nTotalExecutableAmount            := 0
   ::nTotalReimbursableExpenses        := 0
   ::nInvoiceTotalAmount               := 0

   ::oSellerParty                      := Party()
   ::oSellerParty:cCorporateName       := "Mºª/&%<div1>"

   ::oBuyerParty                       := Party()

   ::aTax                              := {}
   ::aDiscount                         := {}
   ::aItemLines                        := {}
   ::aInstallment                      := {}
   ::aAdministrativeCentres            := {}

RETURN ( nil )

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

METHOD initialXML()

   ::oXml:loadXML(   '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' + ;
                     '<fe:Facturae xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:fe="http://www.facturae.es/Facturae/2009/v3.2/Facturae">' + ;
                     '</fe:Facturae>' )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Generate()

   if !::CreateDocument()
      RETURN ( nil )
   end if

   ::initialXML()

   ::headerXml()

   ::partiesXml()

   ::invoiceXml()

   ::saveDocument()

   ::destroyDocument()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setInvoiceNumber( cInvoiceNumber )

   ::cInvoiceNumber  := cInvoiceNumber

   ::cXmlFile        := cPatXml() + ::cInvoiceNumber + ".xml"
   ::cSignedXmlFile  := cPatXml() + ::cInvoiceNumber + "-signed.xml"

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createXmlNode( cName, cText)

   local oNode    := ::oXml:createNode( 1, cName, '' )

   if !empty( cText )
      oNode:Text  := cText
   end if

RETURN ( oNode )

//---------------------------------------------------------------------------//

METHOD createCDataXmlNode( cName, cData )

   local oNode    := ::oXml:createNode( 1, cName, '' )

   if !empty( cData )
      oNode:appendChild( ::oXml:createCDATASection( cData ) )
   end if

RETURN ( oNode )

//---------------------------------------------------------------------------//

METHOD HeaderXml()

   ::oXmlHeader   := ::createXmlNode( 'FileHeader' )

      ::oXmlHeader:appendChild( ::createXmlNode( 'SchemaVersion', SCHEMAVERSION ) )
      ::oXmlHeader:appendChild( ::createXmlNode( 'Modality', MODALITY ) )
      ::oXmlHeader:appendChild( ::createXmlNode( 'InvoiceIssuerType', INVOICEISSUERTYPE ) )

      ::oXmlBatch    := ::createXmlNode( 'Batch' )

         ::oXmlBatch:appendChild( ::createXmlNode( 'BatchIdentifier', ::cInvoiceNumber ) )
         ::oXmlBatch:appendChild( ::createXmlNode( 'InvoicesCount', INVOICESCOUNT ) )

         ::oXmlTotalInvoicesAmount  := ::createXmlNode( 'TotalInvoicesAmount' )
            ::oXmlTotalInvoicesAmount:appendChild( ::createXmlNode( 'TotalAmount', ::InvoiceTotalAmount() ) )
            ::oXmlTotalInvoicesAmount:appendChild( ::createXmlNode( 'EquivalentInEuros', EQUIVALENTINEUROS ) )

         ::oXmlBatch:appendChild( ::oXmlTotalInvoicesAmount )

         ::oXmlTotalOutstandingAmount  := ::createXmlNode( 'TotalOutstandingAmount' )
            ::oXmlTotalOutstandingAmount:appendChild( ::createXmlNode( 'TotalAmount', ::TotalOutstandingAmount() ) )
            ::oXmlTotalOutstandingAmount:appendChild( ::createXmlNode( 'EquivalentInEuros', EQUIVALENTINEUROS ) )

         ::oXmlBatch:appendChild( ::oXmlTotalOutstandingAmount )

         ::oXmlTotalExecutableAmount  := ::createXmlNode( 'TotalExecutableAmount' )
            ::oXmlTotalExecutableAmount:appendChild( ::createXmlNode( 'TotalAmount', ::TotalExecutableAmount() ) )
            ::oXmlTotalExecutableAmount:appendChild( ::createXmlNode( 'EquivalentInEuros', EQUIVALENTINEUROS ) )

         ::oXmlBatch:appendChild( ::oXmlTotalExecutableAmount )

         ::oXmlBatch:appendChild( ::createXmlNode( 'InvoiceCurrencyCode', ::cInvoiceCurrencyCode ) )

      ::oXmlHeader:appendChild( ::oXmlBatch )

   ::oXml:documentElement():appendChild( ::oXmlHeader )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD PartiesXml()

   local oAdministrativeCentre

   ::oXmlParties   := ::createXmlNode( 'Parties' )

      ::oXmlSellerParty    := ::createXmlNode( 'SellerParty' )

         /*
         Comienza el nodo TotalInvoicesAmount-------------------------------
         */

         ::oXmlTaxIdentification  := ::createXmlNode( 'TaxIdentification' )
            ::oXmlTaxIdentification:appendChild( ::createXmlNode( 'PersonTypeCode', ::oSellerParty:cPersonTypeCode ) )
            ::oXmlTaxIdentification:appendChild( ::createXmlNode( 'ResidenceTypeCode', ::oSellerParty:cResidenceTypeCode ) )
            ::oXmlTaxIdentification:appendChild( ::createXmlNode( 'TaxIdentificationNumber', ::oSellerParty:TaxIdentificationNumber() ) )

      ::oXmlSellerParty:appendChild( ::oXmlTaxIdentification )

      /*
      Comienza el nodo LegalEntity------------------------------------------
      */

      if !empty( ::oSellerParty:cCorporateName )

         ::oXmlLegalEntity  := ::createXmlNode( 'LegalEntity' )

            if !empty( ::oSellerParty:CorporateName() )
               ::oXmlLegalEntity:appendChild( ::createCDataXmlNode( 'CorporateName', ::oSellerParty:CorporateName() ) )
            end if

            if !empty( ::oSellerParty:TradeName() )
               ::oXmlLegalEntity:appendChild( ::createXmlNode( 'TradeName', ::oSellerParty:TradeName() ) )
            end if

            ::oXmlRegistrationData  := ::createXmlNode( 'RegistrationData' )

               if !empty( ::oSellerParty:nBook )
                  ::oXmlRegistrationData:appendChild( ::createXmlNode( 'Book', ::oSellerParty:nBook ) )
               end if

               if !empty( ::oSellerParty:cRegisterOfCompaniesLocation )
                  ::oXmlRegistrationData:appendChild( ::createXmlNode( 'RegisterOfCompaniesLocation', ::oSellerParty:cRegisterOfCompaniesLocation ) )
               end if

               if !empty( ::oSellerParty:nSheet )
                  ::oXmlRegistrationData:appendChild( ::createXmlNode( 'Sheet', ::oSellerParty:nSheet ) )
               end if

               if !empty( ::oSellerParty:nFolio )
                  ::oXmlRegistrationData:appendChild( ::createXmlNode( 'Folio', ::oSellerParty:nFolio ) )
               end if

               if !empty( ::oSellerParty:cSection )
                  ::oXmlRegistrationData:appendChild( ::createXmlNode( 'Section', ::oSellerParty:cSection ) )
               end if

               if !empty( ::oSellerParty:nVolume )
                  ::oXmlRegistrationData:appendChild( ::createXmlNode( 'Volume', ::oSellerParty:nVolume ) )
               end if

               if !empty( ::oSellerParty:AditionalRegistrationData() )
                  ::oXmlRegistrationData:appendChild( ::createXmlNode( 'AditionalRegistrationData', ::oSellerParty:AditionalRegistrationData() ) )
               end if

            ::oXmlLegalEntity:appendChild( ::oXmlRegistrationData )

            /*
            Comienza el nodo de direcciones------------------------------------
            */

            ::oXmlAddressInSpain  := ::createXmlNode( 'AddressInSpain' )
               ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Address', ::oSellerParty:Address() ) )
               ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'PostCode', ::oSellerParty:PostCode() ) )
               ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Town', ::oSellerParty:Town() ) )
               ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Province', ::oSellerParty:Province() ) )
               ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'CountryCode', ::oSellerParty:CountryCode() ) )

            ::oXmlLegalEntity:appendChild( ::oXmlAddressInSpain )

            ::oXmlContactDetails := ::createXmlNode( 'ContactDetails' )

               if !empty( ::oSellerParty:Telephone() )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'Telephone',     ::oSellerParty:Telephone() ) )
               end if

               if !empty( ::oSellerParty:cTelFax )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'TeleFax',       ::oSellerParty:cTelFax ) )
               end if

               if !empty( ::oSellerParty:cWebAddress )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'WebAddress',    ::oSellerParty:cWebAddress ) )
               end if

               if !empty( ::oSellerParty:cElectronicMail )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'ElectronicMail',::oSellerParty:cElectronicMail ) )
               end if

               ::oXmlLegalEntity:appendChild( ::oXmlContactDetails )

            ::oXmlSellerParty:appendChild( ::oXmlLegalEntity )

         ::oXmlParties:appendChild( ::oXmlSellerParty )

      end if

      /*
      Comienza el nodo Individual------------------------------------------
      */

      if !empty( ::oSellerParty:cName )

         ::oXmlLegalEntity  := ::createXmlNode( 'Individual' )

            if !empty( ::oSellerParty:cName )
               ::oXmlLegalEntity:appendChild( ::createXmlNode( 'Name', ::oSellerParty:Name() ) )
            end if

            if !empty( ::oSellerParty:cName ) .or. !empty( ::oSellerParty:cFirstSurname )
               ::oXmlLegalEntity:appendChild( ::createXmlNode( 'FirstSurname', ::oSellerParty:FirstSurname() ) )
            end if

            if !empty( ::oSellerParty:cSecondSurname )
               ::oXmlLegalEntity:appendChild( ::createXmlNode( 'SecondSurname', ::oSellerParty:SecondSurname() ) )
            end if

            /*
            Comienza el nodo de direcciones------------------------------------
            */

            ::oXmlAddressInSpain  := ::createXmlNode( 'AddressInSpain' )
               ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Address',    ::oSellerParty:Address() ) )
               ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'PostCode',   ::oSellerParty:PostCode() ) )
               ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Town',       ::oSellerParty:Town() ) )
               ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Province',   ::oSellerParty:Province() ) )
               ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'CountryCode',::oSellerParty:CountryCode() ) )

            ::oXmlLegalEntity:appendChild( ::oXmlAddressInSpain )

            ::oXmlContactDetails := ::createXmlNode( 'ContactDetails' )

               if !empty( ::oSellerParty:Telephone() )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'Telephone',     ::oSellerParty:Telephone() ) )
               end if

               if !empty( ::oSellerParty:cTelFax )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'TeleFax',       ::oSellerParty:cTelFax ) )
               end if

               if !empty( ::oSellerParty:cWebAddress )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'WebAddress',    ::oSellerParty:cWebAddress ) )
               end if

               if !empty( ::oSellerParty:cElectronicMail )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'ElectronicMail',::oSellerParty:cElectronicMail ) )
               end if

               ::oXmlLegalEntity:appendChild( ::oXmlContactDetails )

            ::oXmlSellerParty:appendChild( ::oXmlLegalEntity )

         ::oXmlParties:appendChild( ::oXmlSellerParty )

      end if

      /*
      Comienza el nodo BuyerParty---------------------------------------------
      */

      ::oXmlBuyerParty    := ::createXmlNode( 'BuyerParty' )

         /*
         Comienza el nodo TaxIdentification-------------------------------
         */

         ::oXmlTaxIdentification  := ::createXmlNode( 'TaxIdentification' )
            ::oXmlTaxIdentification:appendChild( ::createXmlNode( 'PersonTypeCode',         ::oBuyerParty:cPersonTypeCode ) )
            ::oXmlTaxIdentification:appendChild( ::createXmlNode( 'ResidenceTypeCode',      ::oBuyerParty:cResidenceTypeCode ) )
            ::oXmlTaxIdentification:appendChild( ::createXmlNode( 'TaxIdentificationNumber',::oBuyerParty:TaxIdentificationNumber() ) )

      ::oXmlBuyerParty:appendChild( ::oXmlTaxIdentification )

         /*
         Comienza el nodo AdministrativeCentres-------------------------------
         */

         if !empty( ::aAdministrativeCentres )

            ::oXmlAdministrativeCentres      := ::createXmlNode( 'AdministrativeCentres' )

            for each oAdministrativeCentre in ::aAdministrativeCentres
               ::AdministrativeCentresXml( oAdministrativeCentre )
            next

            ::oXmlBuyerParty:appendChild( ::oXmlAdministrativeCentres )

         end if

         /*
         Comienza el nodo LegalEntity------------------------------------------
         */

         if !empty( ::oBuyerParty:cCorporateName )

            ::oXmlLegalEntity  := ::createXmlNode( 'LegalEntity' )

               if !empty( ::oBuyerParty:CorporateName() )
                  ::oXmlLegalEntity:appendChild( ::createXmlNode( 'CorporateName', ::oBuyerParty:CorporateName() ) )
               end if

               if !empty( ::oBuyerParty:TradeName() )
                  ::oXmlLegalEntity:appendChild( ::createXmlNode( 'TradeName',     ::oBuyerParty:TradeName() ) )
               end if

               ::oXmlRegistrationData  := ::createXmlNode( 'RegistrationData' )

                  if !empty( ::oBuyerParty:nBook )
                     ::oXmlRegistrationData:appendChild( ::createXmlNode( 'Book',                       ::oBuyerParty:nBook ) )
                  end if

                  if !empty( ::oBuyerParty:cRegisterOfCompaniesLocation )
                     ::oXmlRegistrationData:appendChild( ::createXmlNode( 'RegisterOfCompaniesLocation',::oBuyerParty:cRegisterOfCompaniesLocation ) )
                  end if

                  if !empty( ::oBuyerParty:nSheet )
                     ::oXmlRegistrationData:appendChild( ::createXmlNode( 'Sheet',                      ::oBuyerParty:nSheet ) )
                  end if

                  if !empty( ::oBuyerParty:nFolio )
                     ::oXmlRegistrationData:appendChild( ::createXmlNode( 'Folio',                      ::oBuyerParty:nFolio ) )
                  end if

                  if !empty( ::oBuyerParty:cSection )
                     ::oXmlRegistrationData:appendChild( ::createXmlNode( 'Section',                    ::oBuyerParty:cSection ) )
                  end if

                  if !empty( ::oBuyerParty:nVolume )
                     ::oXmlRegistrationData:appendChild( ::createXmlNode( 'Volume',                     ::oBuyerParty:nVolume ) )
                  end if

                  if !empty( ::oBuyerParty:cAditionalRegistrationData )
                     ::oXmlRegistrationData:appendChild( ::createXmlNode( 'AditionalRegistrationData',  ::oBuyerParty:cAditionalRegistrationData ) )
                  end if

               ::oXmlLegalEntity:appendChild( ::oXmlRegistrationData )

               /*
               Comienza el nodo de direcciones------------------------------------
               */

               ::oXmlAddressInSpain  := ::createXmlNode( 'AddressInSpain' )
                  ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Address',    ::oBuyerParty:Address() ) )
                  ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'PostCode',   ::oBuyerParty:PostCode() ) )
                  ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Town',       ::oBuyerParty:Town() ) )
                  ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Province',   ::oBuyerParty:Province() ) )
                  ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'CountryCode',::oBuyerParty:CountryCode() ) )

               ::oXmlLegalEntity:appendChild( ::oXmlAddressInSpain )

               ::oXmlContactDetails := ::createXmlNode( 'ContactDetails' )

                  if !empty( ::oBuyerParty:Telephone )
                     ::oXmlContactDetails:appendChild( ::createXmlNode( 'Telephone',  ::oBuyerParty:Telephone() ) )
                  end if

                  if !empty( ::oBuyerParty:TelFax() )
                     ::oXmlContactDetails:appendChild( ::createXmlNode( 'TeleFax',    ::oBuyerParty:TelFax() ) )
               end if

               if !empty( ::oBuyerParty:WebAddress() )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'WebAddress',    ::oBuyerParty:WebAddress() ) )
               end if

               if !empty( ::oBuyerParty:ElectronicMail() )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'ElectronicMail',::oBuyerParty:ElectronicMail() ) )
               end if

               ::oXmlLegalEntity:appendChild( ::oXmlContactDetails )

            ::oXmlBuyerParty:appendChild( ::oXmlLegalEntity )

         end if

         /*
         Comienza el nodo Individual------------------------------------------
         */

         if !empty( ::oBuyerParty:cName )

            ::oXmlLegalEntity  := ::createXmlNode( 'Individual' )

               if !empty( ::oBuyerParty:cName )
                  ::oXmlLegalEntity:appendChild( ::createXmlNode( 'Name', ::oBuyerParty:Name() ) )
               end if

               if !empty( ::oBuyerParty:cFirstSurname )
                  ::oXmlLegalEntity:appendChild( ::createXmlNode( 'FirstSurname', ::oBuyerParty:FirstSurname() ) )
               end if

               if !empty( ::oBuyerParty:cSecondSurname() )
                  ::oXmlLegalEntity:appendChild( ::createXmlNode( 'SecondSurname', ::oBuyerParty:SecondSurname() ) )
               end if

               /*
               Comienza el nodo de direcciones------------------------------------
               */

               ::oXmlAddressInSpain  := ::createXmlNode( 'AddressInSpain' )
                  ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Address',    ::oBuyerParty:Address() ) )
                  ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'PostCode',   ::oBuyerParty:PostCode() ) )
                  ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Town',       ::oBuyerParty:Town() ) )
                  ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Province',   ::oBuyerParty:Province() ) )
                  ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'CountryCode',::oBuyerParty:CountryCode() ) )

               ::oXmlLegalEntity:appendChild( ::oXmlAddressInSpain )

               ::oXmlContactDetails := ::createXmlNode( 'ContactDetails' )

               if !empty( ::oBuyerParty:Telephone() )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'Telephone',     ::oBuyerParty:Telephone() ) )
               end if

               if !empty( ::oBuyerParty:TelFax() )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'TeleFax',       ::oBuyerParty:TelFax() ) )
               end if

               if !empty( ::oBuyerParty:WebAddress() )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'WebAddress',    ::oBuyerParty:WebAddress() ) )
               end if

               if !empty( ::oBuyerParty:ElectronicMail() )
                  ::oXmlContactDetails:appendChild( ::createXmlNode( 'ElectronicMail',::oBuyerParty:ElectronicMail() ) )
               end if

               ::oXmlLegalEntity:appendChild( ::oXmlContactDetails )

            ::oXmlBuyerParty:appendChild( ::oXmlLegalEntity )

         end if

      ::oXmlParties:appendChild( ::oXmlBuyerParty )

   ::oXml:documentElement():appendChild( ::oXmlParties )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD InvoiceXml()

   local oTax
   local oItem
   local oInstallment

   ::oXmlInvoices    := ::createXmlNode( 'Invoices' )

      ::oXmlInvoice  := ::createXmlNode( 'Invoice' )

         /*
         Inicio de InvoiceHeader-----------------------------------------------
         */

         ::oXmlInvoiceHeader  := ::createXmlNode( 'InvoiceHeader' )
            ::oXmlInvoiceHeader:appendChild( ::createXmlNode( 'InvoiceNumber',        ::cInvoiceNumber ) )
            ::oXmlInvoiceHeader:appendChild( ::createXmlNode( 'InvoiceSeriesCode',    ::cInvoiceSeriesCode ) )
            ::oXmlInvoiceHeader:appendChild( ::createXmlNode( 'InvoiceDocumentType',  INVOICEDOCUMENTTYPE ) )
            ::oXmlInvoiceHeader:appendChild( ::createXmlNode( 'InvoiceClass',         INVOICECLASS ) )

            /*
            Inicio de factura rectificativa rellenar solo si es el caso--------
            */

            if !empty( ::cCorrectiveInvoiceNumber )

               ::oXmlCorrective  := ::createXmlNode( 'Corrective' )
                  ::oXmlCorrective:appendChild( ::createXmlNode( 'InvoiceNumber',     ::cCorrectiveInvoiceNumber ) )
                  ::oXmlCorrective:appendChild( ::createXmlNode( 'ReasonCode',        ::cCorrectiveReasonCode ) )
                  ::oXmlCorrective:appendChild( ::createXmlNode( 'ReasonDescription', ::cCorrectiveReasonDescription ) )

                  ::oXmlTaxPeriod   := ::createXmlNode( 'TaxPeriod' )
                     ::oXmlTaxPeriod:appendChild( ::createXmlNode( 'StartDate', ::CorrectiveStartDate() ) )
                     ::oXmlTaxPeriod:appendChild( ::createXmlNode( 'EndDate',   ::CorrectiveEndDate() ) )

                  ::oXmlCorrective:appendChild( ::oXmlTaxPeriod )

                  ::oXmlCorrective:appendChild( ::createXmlNode( 'CorrectionMethod',           ::cCorrectiveCorrectionMethod ) )
                  ::oXmlCorrective:appendChild( ::createXmlNode( 'CorrectionMethodDescription',::cCorrectiveCorrectionMethodDescription ) )

               ::oXmlInvoiceHeader:appendChild( ::oXmlCorrective )

            end if

         ::oXmlInvoice:appendChild( ::oXmlInvoiceHeader )

         /*
         Inicio de IssueData---------------------------------------------------
         */

         if !empty( ::dIssueDate )

            ::oXmlInvoiceIssueData  := ::createXmlNode( 'InvoiceIssueData' )

               ::oXmlInvoiceIssueData:appendChild( ::createXmlNode( 'IssueDate', ::IssueDate() ) )
               ::oXmlInvoiceIssueData:appendChild( ::createXmlNode( 'OperationDate', ::OperationDate() ) )

               ::oXmlPlaceOfIssue  := ::createXmlNode( 'PlaceOfIssue' )

                  ::oXmlPlaceOfIssue:appendChild( ::createXmlNode( 'PostCode', ::PlaceOfIssuePostCode() ) )
                  ::oXmlPlaceOfIssue:appendChild( ::createXmlNode( 'PlaceOfIssueDescription', ::PlaceOfIssueDescription() ) )

               ::oXmlInvoiceIssueData:appendChild( ::oXmlPlaceOfIssue )

               ::oXmlInvoiceIssueData:appendChild( ::createXmlNode( 'InvoiceCurrencyCode', ::cInvoiceCurrencyCode ) )
               ::oXmlInvoiceIssueData:appendChild( ::createXmlNode( 'TaxCurrencyCode', ::cTaxCurrencyCode ) )
               ::oXmlInvoiceIssueData:appendChild( ::createXmlNode( 'LanguageName', ::cLanguageName ) )

            ::oXmlInvoice:appendChild( ::oXmlInvoiceIssueData )

         end if

         /*
         Comenzamos los Taxes--------------------------------------------------
         */

         ::oXmlTaxesOutputs   := ::createXmlNode( 'TaxesOutputs' )

            for each oTax in ::aTax

               ::TaxesXml( oTax )

               ::oXmlTaxesOutputs:appendChild( ::oXmlTax )

            next

         ::oXmlInvoice:appendChild( ::oXmlTaxesOutputs )

         /*
         Comenzamos los Totals-------------------------------------------------
         */

         ::TotalXml()

         /*
         Comenzamos las lineas-------------------------------------------------
         */

         msgalert( hb_valtoexp( ::aItemLines ), "aItemLines" )

         if !empty( ::aItemLines )

            ::oXmlItems := ::createXmlNode( 'Items' )

               for each oItem in ::aItemLines

                  ::ItemsXml( oItem )

                  ::oXmlItems:appendChild( ::oXmlInvoiceLine )

               next

            ::oXmlInvoice:appendChild( ::oXmlItems )

         end if

         /*
         Comenzamos los pagos--------------------------------------------------
         */

         if !empty( ::aInstallment )

            ::oXmlPaymentDetails := ::createXmlNode( 'PaymentDetails' )

            for each oInstallment in ::aInstallment

               ::InstallmentXml( oInstallment )

               ::oXmlPaymentDetails:appendChild( ::oXmlInstallment )

            next

            ::oXmlInvoice:appendChild( ::oXmlPaymentDetails )

         end if

      ::oXmlInvoices:appendChild( ::oXmlInvoice )

   ::oXml:documentElement():appendChild( ::oXmlInvoices )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD TaxesXml( oTax )

   if Empty( oTax )
      RETURN ( nil )
   end if

   ::oXmlTax         := ::createXmlNode( 'Tax' )

   /*
   Tipo de impuestos--------------------------------------------------------------
   */

   ::oXmlTax:appendChild( ::createXmlNode( 'TaxTypeCode', oTax:cTaxTypeCode ) )
   ::oXmlTax:appendChild( ::createXmlNode( 'TaxRate', oTax:TaxRate() ) )

   ::oXmlTaxableBase := ::createXmlNode( 'TaxableBase' )

      ::oXmlTaxableBase:appendChild( ::createXmlNode( 'TotalAmount', oTax:TaxBase() ) )
      ::oXmlTaxableBase:appendChild( ::createXmlNode( 'EquivalentInEuros', EQUIVALENTINEUROS ) )

   ::oXmlTax:appendChild( ::oXmlTaxableBase )

   ::oXmlTaxAmount   := ::createXmlNode( 'TaxAmount' )

      ::oXmlTaxAmount:appendChild( ::createXmlNode( 'TotalAmount', oTax:TaxAmount() ) )
      ::oXmlTaxAmount:appendChild( ::createXmlNode( 'EquivalentInEuros', EQUIVALENTINEUROS ) )

   ::oXmlTax:appendChild( ::oXmlTaxAmount )

   /*
   Recargo de equivalencia--------------------------------------------------
   */

   if oTax:nEquivalenceSurchargeAmount != 0

      ::oXmlTax:appendChild( ::createXmlNode( 'EquivalenceSurcharge', oTax:EquivalenceSurcharge() ) )

      ::oXmlEquivalenceSurcharge := ::createXmlNode( 'EquivalenceSurchargeAmount' )

         ::oXmlEquivalenceSurcharge:appendChild( ::createXmlNode( 'TotalAmount', oTax:EquivalenceSurchargeAmount() ) )
         ::oXmlEquivalenceSurcharge:appendChild( ::createXmlNode( 'EquivalentInEuros', EQUIVALENTINEUROS ) )

      ::oXmlTax:appendChild( ::oXmlEquivalenceSurcharge )

   end if

RETURN ( ::oXmlTax )

//---------------------------------------------------------------------------//

METHOD AdministrativeCentresXml( oAdministrativeCentre )

   local oXmlCentreDescription

   ::oXmlAdministrativeCentre    := ::createXmlNode( 'AdministrativeCentre' )

      ::oXmlAdministrativeCentre:appendChild( ::createXmlNode( 'CentreCode', oAdministrativeCentre:CentreCode() ) )
      ::oXmlAdministrativeCentre:appendChild( ::createXmlNode( 'RoleTypeCode', oAdministrativeCentre:RoleTypeCode() ) )

      ::oXmlAddressInSpain       := ::createXmlNode( 'AddressInSpain' )
         ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Address', oAdministrativeCentre:Address() ) )
         ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'PostCode', oAdministrativeCentre:PostCode() ) )
         ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Town', oAdministrativeCentre:Town() ) )
         ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Province', oAdministrativeCentre:Province() ) )
         ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'CountryCode', oAdministrativeCentre:CountryCode() ) )

      ::oXmlAdministrativeCentre:appendChild( ::oXmlAddressInSpain )

      oXmlCentreDescription      := ::createXmlNode( 'CentreDescription', oAdministrativeCentre:CentreDescription() )
      ::oXmlAdministrativeCentre:appendChild( oXmlCentreDescription )

   ::oXmlAdministrativeCentres:appendChild( ::oXmlAdministrativeCentre )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD TotalXml()

   local oDiscount

   ::oXmlInvoiceTotals   := ::createXmlNode( 'InvoiceTotals' )

      if !empty( ::TotalGrossAmount() )
         ::oXmlInvoiceTotals:appendChild( ::createXmlNode( 'TotalGrossAmount',  ::TotalGrossAmount() ) )
      end if

      /*
      Descuentos generales-----------------------------------------------------
      */

      if !empty( ::aDiscount )

         ::oXmlGeneralDiscounts  := ::createXmlNode( 'GeneralDiscounts' )

            for each oDiscount in ::aDiscount

               ::DiscountXml( oDiscount )

               ::oXmlGeneralDiscounts:appendChild( ::oXmlDiscount )

            next

         ::oXmlInvoiceTotals:appendChild( ::oXmlGeneralDiscounts )

      end if

      /*
      Fin de descuentos generales----------------------------------------------
      */

      if !empty( ::TotalGeneralDiscounts() )
         ::oXmlInvoiceTotals:appendChild( ::createXmlNode( 'TotalGeneralDiscounts',      ::TotalGeneralDiscounts() ) )
      end if

      if !empty( ::TotalGeneralSurcharges() )
         ::oXmlInvoiceTotals:appendChild( ::createXmlNode( 'TotalGeneralSurcharges',     ::TotalGeneralSurcharges() ) )
      end if

      if !empty( ::TotalGrossAmountBeforeTaxes() )
         ::oXmlInvoiceTotals:appendChild( ::createXmlNode( 'TotalGrossAmountBeforeTaxes',::TotalGrossAmountBeforeTaxes() ) )
      end if

      if !empty( ::TotalTaxOutputs() )
         ::oXmlInvoiceTotals:appendChild( ::createXmlNode( 'TotalTaxOutputs',            ::TotalTaxOutputs() ) )
      end if

      if !empty( ::TotalTaxesWithheld() )
         ::oXmlInvoiceTotals:appendChild( ::createXmlNode( 'TotalTaxesWithheld',         ::TotalTaxesWithheld() ) )
      end if

      if !empty( ::InvoiceTotal() )
         ::oXmlInvoiceTotals:appendChild( ::createXmlNode( 'InvoiceTotal',               ::InvoiceTotal() ) )
      end if

      if !empty( ::TotalOutstandingAmount() )
         ::oXmlInvoiceTotals:appendChild( ::createXmlNode( 'TotalOutstandingAmount',     ::TotalOutstandingAmount() ) )
      end if

      if !empty( ::TotalExecutableAmount() )
         ::oXmlInvoiceTotals:appendChild( ::createXmlNode( 'TotalExecutableAmount',      ::TotalExecutableAmount() ) )
      end if

      if !empty( ::TotalReimbursableExpenses() )
         ::oXmlInvoiceTotals:appendChild( ::createXmlNode( 'TotalReimbursableExpenses',  ::TotalReimbursableExpenses() ) )
      end if

   ::oXmlInvoice:appendChild( ::oXmlInvoiceTotals )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD DiscountXml( oDiscount )

   ::oXmlDiscount   := ::createXmlNode( 'Discount' )

      ::oXmlDiscount:appendChild( ::createXmlNode( 'DiscountReason',oDiscount:DiscountReason() ) )

      if ( oDiscount:nDiscountRate != 0 )
         ::oXmlDiscount:appendChild( ::createXmlNode( 'DiscountRate',  oDiscount:DiscountRate() ) )
      end if

      ::oXmlDiscount:appendChild( ::createXmlNode( 'DiscountAmount',oDiscount:DiscountAmount() ) )

RETURN ( ::oXmlDiscount )

//---------------------------------------------------------------------------//

METHOD ItemsXml( oItemLine )

   local oTax
   local oDiscount

   ::oXmlInvoiceLine := ::createXmlNode( 'InvoiceLine' )

   ::oXmlInvoiceLine:appendChild( ::createXmlNode( 'ItemDescription',     oItemLine:ItemDescription() ) )
   ::oXmlInvoiceLine:appendChild( ::createXmlNode( 'Quantity',            oItemLine:Quantity() ) )
   ::oXmlInvoiceLine:appendChild( ::createXmlNode( 'UnitOfMeasure',       oItemLine:UnitOfMeasure() ) )
   ::oXmlInvoiceLine:appendChild( ::createXmlNode( 'UnitPriceWithoutTax', oItemLine:UnitPriceWithoutTax() ) )
   ::oXmlInvoiceLine:appendChild( ::createXmlNode( 'TotalCost',           oItemLine:TotalCost() ) )

   /*
   Descuentos---------------------------------------------------------------
   */

   if !empty( oItemLine:aDiscount )

      ::oXmlDiscountsAndRebates := ::createXmlNode( 'DiscountsAndRebates' )

      for each oDiscount in oItemLine:aDiscount

         ::DiscountXml( oDiscount )

         ::oXmlDiscountsAndRebates:appendChild( ::oXmlDiscount )

      next

      ::oXmlInvoiceLine:appendChild( ::oXmlDiscountsAndRebates )

   end if

   ::oXmlInvoiceLine:appendChild( ::createXmlNode( 'GrossAmount', oItemLine:GrossAmount() ) )

   /*
   Comenzamos los Taxes--------------------------------------------------
   */

   if !empty( oItemLine:aTax )

      ::oXmlTaxesOutputs   := ::createXmlNode( 'TaxesOutputs' )

      for each oTax in oItemLine:aTax

         ::TaxesXml( oTax )

         ::oXmlTaxesOutputs:appendChild( ::oXmlTax )

      next

      ::oXmlInvoiceLine:appendChild( ::oXmlTaxesOutputs )

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD InstallmentXml( oInstallment )

   ::oXmlInstallment := ::createXmlNode( 'Installment' )

   ::oXmlInstallment:appendChild( ::createXmlNode( 'InstallmentDueDate',  oInstallment:InstallmentDueDate() ) )
   ::oXmlInstallment:appendChild( ::createXmlNode( 'InstallmentAmount',   oInstallment:InstallmentAmount() ) )
   ::oXmlInstallment:appendChild( ::createXmlNode( 'PaymentMeans',        oInstallment:cPaymentMeans ) )

   if !empty( oInstallment:oAccountToBeDebited )

      ::oXmlAccountToBeDebited  := ::createXmlNode( 'AccountToBeDebited' )

         ::oXmlAccountToBeDebited:appendChild( ::createXmlNode( 'IBAN',      oInstallment:oAccountToBeDebited:IBAN() ) )
         ::oXmlAccountToBeDebited:appendChild( ::createXmlNode( 'BankCode',  oInstallment:oAccountToBeDebited:BankCode() ) )
         ::oXmlAccountToBeDebited:appendChild( ::createXmlNode( 'BranchCode',oInstallment:oAccountToBeDebited:BranchCode() ) )

         ::oXmlAddressInSpain  := ::createXmlNode( 'AddressInSpain' )
            ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Address',    oInstallment:oAccountToBeDebited:Address() ) )
            ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'PostCode',   oInstallment:oAccountToBeDebited:PostCode() ) )
            ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Town',       oInstallment:oAccountToBeDebited:Town() ) )
            ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Province',   oInstallment:oAccountToBeDebited:Province() ) )
            ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'CountryCode',oInstallment:oAccountToBeDebited:CountryCode() ) )

         ::oXmlAccountToBeDebited:appendChild( ::oXmlAddressInSpain )

      ::oXmlInstallment:appendChild( ::oXmlAccountToBeDebited )

   end if

   if !empty( oInstallment:oAccountToBeCredited )

      ::oXmlAccountToBeCredited  := ::createXmlNode( 'AccountToBeCredited' )

         ::oXmlAccountToBeCredited:appendChild( ::createXmlNode( 'IBAN',        oInstallment:oAccountToBeCredited:IBAN() ) )
         ::oXmlAccountToBeCredited:appendChild( ::createXmlNode( 'BankCode',    oInstallment:oAccountToBeCredited:BankCode() ) )
         ::oXmlAccountToBeCredited:appendChild( ::createXmlNode( 'BranchCode',  oInstallment:oAccountToBeCredited:BranchCode() ) )

         ::oXmlAddressInSpain  := ::createXmlNode( 'BranchInSpainAddress' )
            ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Address',       oInstallment:oAccountToBeCredited:Address() ) )
            ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'PostCode',      oInstallment:oAccountToBeCredited:PostCode() ) )
            ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Town',          oInstallment:oAccountToBeCredited:Town() ) )
            ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'Province',      oInstallment:oAccountToBeCredited:Province() ) )
            ::oXmlAddressInSpain:appendChild( ::createXmlNode( 'CountryCode',   oInstallment:oAccountToBeCredited:CountryCode() ) )

         ::oXmlAccountToBeCredited:appendChild( ::oXmlAddressInSpain )

      ::oXmlInstallment:appendChild( ::oXmlAccountToBeCredited )

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Firma()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD VerificaFirma()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD FirmaJava()

RETURN ( nil )

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

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD startInWeb( oActiveX, oDlg )

   if file( ::cSignedXmlFile )
      oActiveX:Do( "Navigate", ::cSignedXmlFile )
   else
      oActiveX:Do( "Navigate", ::cXmlFile )
   end if

   sysRefresh()

RETURN ( self )

// Estructuras y clases auxiliares-------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS Party FROM Address

   DATA cPersonTypeCode                INIT 'F'
   METHOD setPersonTypeCode( cPersonTypeCode ) ;
                                       INLINE ( ::cPersonTypeCode := cPersonTypeCode )
   ACCESS PersonTypeCode               INLINE ( hb_strtoutf8( Rtrim( ::cPersonTypeCode ) ) )

   DATA cTaxIdentificationNumber       INIT ''
   METHOD setTaxIdentificationNumber( cTaxIdentificationNumber ) ;
                                       INLINE ( ::cTaxIdentificationNumber := cTaxIdentificationNumber )
   ACCESS TaxIdentificationNumber      INLINE ( hb_strtoutf8( Rtrim( left( ::cTaxIdentificationNumber, 30 ) ) ) )

   DATA cCorporateName                 INIT ''
   METHOD setCorporateName( cCorporateName ) ;
                                       INLINE ( ::cCorporateName := cCorporateName )
   ACCESS CorporateName                INLINE ( hb_strtoutf8( Rtrim( left( ::cCorporateName, 80 ) ) ) )
   
   DATA cTradeName                     INIT ''
   METHOD setTradeName( cTradeName )   INLINE ( ::cTradeName := cTradeName )
   ACCESS TradeName                    INLINE ( hb_strtoutf8( Rtrim( left( ::cTradeName, 40 ) ) ) )
   
   DATA cRegisterOfCompaniesLocation   INIT ''
   METHOD setRegisterOfCompaniesLocation( cRegisterOfCompaniesLocation ) ;
                                       INLINE ( ::cRegisterOfCompaniesLocation := cRegisterOfCompaniesLocation )
   ACCESS RegisterOfCompaniesLocation  INLINE ( hb_strtoutf8( Rtrim( left( ::cRegisterOfCompaniesLocation, 40 ) ) ) )

   DATA     cRegistrationData             INIT ''
   DATA     nBook                         INIT ''
   DATA     nSheet                        INIT '-'
   DATA     nFolio                        INIT ''
   DATA     cSection                      INIT ''
   DATA     nVolume                       INIT ''
   DATA     cAditionalRegistrationData    INIT ''
   DATA     cTelephone                    INIT ''
   DATA     cTelFax                       INIT ''
   DATA     cWebAddress                   INIT ''
   DATA     cElectronicMail               INIT ''
   DATA     cResidenceTypeCode            INIT 'R'

   DATA cName                          INIT ''
   METHOD setName( cName )             INLINE ( ::cName := cName )
   ACCESS Name                         INLINE ( hb_strtoutf8( Rtrim( left( ::cName, 40 ) ) ) )

   DATA cFirstSurname                  INIT ''
   METHOD setFirstSurname( cFirstSurname ) ;
                                       INLINE ( ::cFirstSurname := cFirstSurname )
   ACCESS FirstSurname                 INLINE ( hb_strtoutf8( Rtrim( left( ::cFirstSurname, 40 ) ) ) )

   DATA cSecondSurname                 INIT ''
   METHOD setSecondSurname( cSecondSurname ) ;
                                       INLINE ( ::cSecondSurname := cSecondSurname )
   ACCESS SecondSurname                INLINE ( hb_strtoutf8( Rtrim( left( ::cSecondSurname, 40 ) ) ) )


   ACCESS   AditionalRegistrationData     INLINE ( hb_strtoutf8( Rtrim( ::cAditionalRegistrationData ) ) )
   ACCESS   Telephone                     INLINE ( hb_strtoutf8( Rtrim( ::cTelephone ) ) )
   ACCESS   TelFax                        INLINE ( hb_strtoutf8( Rtrim( ::cTelFax ) ) )
   ACCESS   WebAddress                    INLINE ( hb_strtoutf8( Rtrim( ::cWebAddress ) ) )
   ACCESS   ElectronicMail                INLINE ( hb_strtoutf8( Rtrim( ::cElectronicMail ) ) )
   ACCESS   ResidenceTypeCode             INLINE ( hb_strtoutf8( Rtrim( ::cResidenceTypeCode ) ) )



ENDCLASS

//---------------------------------------------------------------------------//

CLASS Tax

   DATA     cTaxTypeCode                  INIT '01'
   DATA     nTaxRate                      INIT 0.00
   DATA     nTaxBase                      INIT 0.00
   DATA     nTaxAmount                    INIT 0.00
   DATA     nEquivalenceSurcharge         INIT 0.00
   DATA     nEquivalenceSurchargeAmount   INIT 0.00

   ACCESS   TaxRate                       INLINE ( alltrim( Trans( ::nTaxRate, DoubleTwoDecimalPicture ) ) )
   ACCESS   TaxBase                       INLINE ( alltrim( Trans( ::nTaxBase, DoubleTwoDecimalPicture ) ) )
   ACCESS   TaxAmount                     INLINE ( alltrim( Trans( ::nTaxAmount, DoubleTwoDecimalPicture ) ) )
   ACCESS   EquivalenceSurcharge          INLINE ( alltrim( Trans( ::nEquivalenceSurcharge, DoubleTwoDecimalPicture ) ) )
   ACCESS   EquivalenceSurchargeAmount    INLINE ( alltrim( Trans( ::nEquivalenceSurchargeAmount, DoubleTwoDecimalPicture ) ) )

ENDCLASS

//---------------------------------------------------------------------------//

CLASS Discount

   DATA     cDiscountReason               INIT ''
   DATA     nDiscountRate                 INIT 0.00
   DATA     nDiscountAmount               INIT 0.000000

   ACCESS   DiscountReason                INLINE ( ::cDiscountReason )
   ACCESS   DiscountRate                  INLINE ( alltrim( Trans( ::nDiscountRate, DoubleFourDecimalPicture ) ) )
   ACCESS   DiscountAmount                INLINE ( alltrim( Trans( ::nDiscountAmount, DoubleSixDecimalPicture  ) ) )

ENDCLASS

//---------------------------------------------------------------------------//

CLASS ItemLine

   DATA     cItemDescription           INIT ''
   DATA     nQuantity                  INIT 0.00
   DATA     cUnitOfMeasure             INIT '01'
   DATA     nUnitPriceWithTax          INIT 0.000000
   DATA     nUnitPriceWithOutTax       INIT 0.000000
   DATA     nTotalCost                 INIT 0.00
   DATA     nIva                       INIT 0
   DATA     aDiscount                  INIT {}
   DATA     nGrossAmount               INIT 0.00
   DATA     aTax                       INIT {}

   ACCESS   ItemDescription            INLINE ( hb_strtoutf8( rtrim( ::cItemDescription ) ) )
   ACCESS   UnitOfMeasure              INLINE ( ::cUnitOfMeasure )
   ACCESS   Quantity                   INLINE ( alltrim( Trans( ::nQuantity, DoubleTwoDecimalPicture ) ) )
   ACCESS   UnitPriceWithoutTax        INLINE ( alltrim( Trans( ::nUnitPriceWithOutTax, DoubleSixDecimalPicture ) ) )

   METHOD addDiscount( oDiscount )
   METHOD GrossAmount()

   METHOD TotalCost()

   METHOD addTax( oTax )               INLINE aadd( ::aTax, oTax )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD addDiscount( oDiscount ) CLASS ItemLine

   ::nTotalCost                  := ::nQuantity * ::nUnitPriceWithOutTax

   if oDiscount:nDiscountRate != 0
      oDiscount:nDiscountAmount  := Round( ::nTotalCost * oDiscount:nDiscountRate / 100, 2 )
   end if

   aAdd( ::aDiscount, oDiscount )

RETURN ( oDiscount )

//------------------------------------------------------------------------//

METHOD GrossAmount() CLASS ItemLine

   local oDiscount

   ::nGrossAmount       := ::nQuantity * ::nUnitPriceWithOutTax

   for each oDiscount in ::aDiscount
      ::nGrossAmount    -= oDiscount:nDiscountAmount
   next

   ::nGrossAmount       := Round( ::nGrossAmount, 6 )

RETURN ( alltrim( Trans( ::nGrossAmount, DoubleSixDecimalPicture ) ) )

//---------------------------------------------------------------------------//

METHOD TotalCost() CLASS ItemLine

RETURN ( alltrim( trans( round( ::nQuantity * ::nUnitPriceWithOutTax, 6 ), DoubleSixDecimalPicture ) ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS Installment

   DATA     dInstallmentDueDate
   DATA     nInstallmentAmount      INIT 0.00
   DATA     cPaymentMeans           INIT '02'

   DATA     oAccountToBeCredited
   DATA     oAccountToBeDebited

   ACCESS   InstallmentDueDate      INLINE ( dtoiso( ::dInstallmentDueDate ) )
   ACCESS   InstallmentAmount       INLINE ( alltrim( Trans( ::nInstallmentAmount,  DoubleTwoDecimalPicture ) ) )

ENDCLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS Address

   DATA     cAddress                INIT ''
   DATA     cPostCode               INIT ''
   DATA     cTown                   INIT ''
   DATA     cProvince               INIT ''
   DATA     cCountryCode            INIT 'ESP'

   ACCESS   Address                 INLINE ( hb_strtoutf8( alltrim( left( ::cAddress, 80 ) ) ) )
   ACCESS   PostCode                INLINE ( hb_strtoutf8( alltrim( left( ::cPostCode, 9 ) ) ) )
   ACCESS   Town                    INLINE ( hb_strtoutf8( alltrim( left( ::cTown, 50 ) ) ) )
   ACCESS   Province                INLINE ( hb_strtoutf8( alltrim( left( ::cProvince, 20 ) ) ) )
   ACCESS   CountryCode             INLINE ( hb_strtoutf8( alltrim( left( ::cCountryCode, 3 ) ) ) )

ENDCLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS Account FROM Address

   DATA     cIBAN                   INIT ''
   DATA     cBankCode               INIT ''
   DATA     cBranchCode             INIT ''

   ACCESS   IBAN                    INLINE ( alltrim( left( ::cIBAN, 30 ) ) )
   ACCESS   BankCode                INLINE ( alltrim( left( ::cBankCode, 60 ) ) )
   ACCESS   BranchCode              INLINE ( alltrim( left( ::cBranchCode, 60 ) ) )

ENDCLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AdministrativeCentres FROM Address

   DATA     cCentreCode             INIT ''
   DATA     cRoleTypeCode           INIT ''
   DATA     cCentreDescription      INIT ''

   ACCESS   CentreCode              INLINE ( hb_strtoutf8( alltrim( ::cCentreCode   ) ) )
   ACCESS   RoleTypeCode            INLINE ( hb_strtoutf8( alltrim( ::cRoleTypeCode ) ) )
   ACCESS   CentreDescription       INLINE ( hb_strtoutf8( alltrim( ::cCentreDescription ) ) )

ENDCLASS

//---------------------------------------------------------------------------//

