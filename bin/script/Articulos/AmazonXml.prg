#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 

#define SchemaVersion            '3.2'
#define Modality                 'I'   // "individual" (I)
#define InvoiceIssuerType        'EM'
#define InvoicesCount            '1'
#define EquivalentInEuros        '0.00'
#define InvoiceDocumentType      'FC'
#define InvoiceClass             'OO'
#define TaxTypeCode              '01'

#define DoubleTwoDecimalPicture  "999999999.99"
#define DoubleFourDecimalPicture "999999999.9999"
#define DoubleSixDecimalPicture  "999999999.999999"

//---------------------------------------------------------------------------//

Function AmazonXml( nView )

   TAmazonXml():New( nView ):Controller()

Return nil

//---------------------------------------------------------------------------//

CLASS TAmazonXml

   DATA  nView

   DATA  oXml
   DATA  oNodeAmazonEnvelope
   DATA  oNodeHeader

   DATA  hDC
   DATA  cXmlFile

   METHOD New( nView )

   METHOD Controller()

   METHOD createRootNode()             INLINE   (  ::oXml                  := TXmlDocument():new( '<?xml version="1.0" encoding="ISO-8859-1"?>' ) )
   METHOD createAmazonEnvelopeNode()   INLINE   (  ::oNodeAmazonEnvelope   := TXmlNode():new( , "AmazonEnvelope",;
                                                   {  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",;
                                                      "xsi:noNamespaceSchemaLocation" => "amzn-envelope.xsd" } ) )

   METHOD createHeaderNode()
   METHOD createMessageTypeNode()      INLINE   (  ::oNodeAmazonEnvelope:addBelow( TXmlNode():new( , 'MessageType', , 'Product' ) ) )
   METHOD createPurgeAndReplace()      INLINE   (  ::oNodeAmazonEnvelope:addBelow( TXmlNode():new( , 'PurgeAndReplace', , 'false' ) ) )

   METHOD addBelowAmazonEnvelopeNode() INLINE   ( ::oXml:oRoot:addBelow( ::oNodeAmazonEnvelope ) )

   METHOD writeFile()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView )

   ::nView        := nView
   
   ::cXmlFile     := "amazon.xml"

Return ( self )

//---------------------------------------------------------------------------//

METHOD Controller()

   ::createRootNode()

   ::createAmazonEnvelopeNode() 

   ::createHeaderNode()

   ::createMessageTypeNode()

   ::createPurgeAndReplace()

   


   // Nodo final---------------------------------------------------------------

   ::addBelowAmazonEnvelopeNode()  

   ::writeFile()

Return ( self )

//---------------------------------------------------------------------------//

METHOD createHeaderNode()

   ::oNodeHeader     := TXmlNode():new( , 'Header' )
      ::oNodeHeader:addBelow( TXmlNode():new( , 'DocumentVersion', , '1.01' ) )
      ::oNodeHeader:addBelow( TXmlNode():new( , 'MerchantIdentifier', , 'Merchant' ) )

   ::oNodeAmazonEnvelope:addBelow( ::oNodeHeader )

Return ( self )

//---------------------------------------------------------------------------//

/*
Generar fisicamente el fichero----------------------------------------------
*/

METHOD writeFile()

   local oError
   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ferase( ::cXmlFile )

      ::hDC       := fCreate( ::cXmlFile )

      if ::hDC < 0
         ::hDC    := 0
      endif

      ::oXml:Write( ::hDC, HBXML_STYLE_INDENT )

      fClose( ::hDC )

      ::hDC       := 0

      msgInfo( "Fichero generado " + Lower( ::cXmlFile ) + " satisfactoriamente.", 1 )

   RECOVER USING oError

      ::lError    := .t.

      msgStop( "Error el generar el fichero " + Lower( ::cXmlFile ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( self )

//---------------------------------------------------------------------------//

