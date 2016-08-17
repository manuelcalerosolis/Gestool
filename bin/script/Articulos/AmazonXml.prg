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

   DATA  MessageID
   DATA  Skuparent
   DATA  Title
   DATA  Brand
   DATA  Description
   DATA  Manufacturer
   DATA  SearchTerms
   DATA  RecommendedBrowseNode
   DATA  ClothingType
   DATA  Parentage
   DATA  Size
   DATA  CountryOfOrigin

   DATA  oXml
   DATA  oNodeAmazonEnvelope
   DATA  oNodeHeader
   DATA  oNodeMessage
   DATA  oNodeProduct
   DATA  oNodeDescriptionData
   DATA  oNodeProductData
   DATA  oNodeShoes
   DATA  oNodeVariationData
   DATA  oNodeClassificationData

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

   METHOD createMessageNode()
   METHOD createProductNode()
   METHOD createDescriptionDataNode()
   METHOD createProductDataNode()
   METHOD createShoesNode()
   METHOD createVariationDataNode()
   METHOD createClassificationDataNode()

   METHOD addBelowAmazonEnvelopeNode() INLINE   ( ::oXml:oRoot:addBelow( ::oNodeAmazonEnvelope ) )

   METHOD writeFile()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView
               
   ::cXmlFile                 := "amazon.xml"
            
   ::MessageID                := alltrim( ( D():Articulos( ::nView ) ) ->Codigo )
   ::Skuparent                := alltrim( ( D():Articulos( ::nView ) ) ->Codigo )
   ::Title                    := alltrim( ( D():Articulos( ::nView ) ) ->Nombre )
   ::Brand                    := alltrim( retFamilia( ( D():Articulos( ::nView ) )->Familia, D():Familias( ::nView ) ) )
   ::Description              := alltrim( ( D():Articulos( ::nView ) ) ->Nombre )
   ::Manufacturer             := alltrim( retFamilia( ( D():Articulos( ::nView ) )->Familia, D():Familias( ::nView ) ) )
   ::SearchTerms              := "..."
   ::RecommendedBrowseNode    := "..."
   ::ClothingType             := allTrim( retFld( ( D():Articulos( ::nView ) )->cCodTip, D():ArticuloTipos( ::nView ) ) )
   ::Parentage                := "..."                   
   ::Size                     := "..."
   ::CountryOfOrigin          := "..."      

Return ( self )

//---------------------------------------------------------------------------//

METHOD Controller()

   ::createRootNode()

   ::createAmazonEnvelopeNode() 

   ::createHeaderNode()

   ::createMessageTypeNode()

   ::createPurgeAndReplace()

<<<<<<< HEAD
   
=======
   ::createMessageNode()
>>>>>>> f656fe5eb48ca8b30c99a18f6d850e824c2982bb

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

METHOD createMessageNode()

   ::oNodeMessage     := TXmlNode():new( , 'Message' )
      ::oNodeMessage:addBelow( TXmlNode():new( , 'MessageID', , ::MessageID ) )
      ::oNodeMessage:addBelow( TXmlNode():new( , 'OperationType', , 'Update' ) )

      ::createProductNode()

   ::oNodeAmazonEnvelope:addBelow( ::oNodeMessage )

Return ( self )

//---------------------------------------------------------------------------//

METHOD createProductNode()

   ::oNodeProduct     := TXmlNode():new( , 'Product' )
      ::oNodeProduct:addBelow( TXmlNode():new( , 'SKU', , ::Skuparent ) )

      ::createDescriptionDataNode()

      ::createProductDataNode()

   ::oNodeMessage:addBelow( ::oNodeProduct )

Return ( self )

//---------------------------------------------------------------------------//

METHOD createDescriptionDataNode()

   ::oNodeDescriptionData     := TXmlNode():new( , 'DescriptionData' )
      ::oNodeDescriptionData:addBelow( TXmlNode():new( , 'Title', , ::Title ) )
      ::oNodeDescriptionData:addBelow( TXmlNode():new( , 'Brand', , ::Brand ) )
      ::oNodeDescriptionData:addBelow( TXmlNode():new( , 'Description', , ::Description ) )
      ::oNodeDescriptionData:addBelow( TXmlNode():new( , 'Manufacturer', , ::Manufacturer ) )
      ::oNodeDescriptionData:addBelow( TXmlNode():new( , 'SearchTerms', , ::SearchTerms ) )
      ::oNodeDescriptionData:addBelow( TXmlNode():new( , 'RecommendedBrowseNode', , ::RecommendedBrowseNode ) )

   ::oNodeProduct:addBelow( ::oNodeDescriptionData )

Return ( self )

//---------------------------------------------------------------------------//

METHOD createProductDataNode()

   ::oNodeProductData     := TXmlNode():new( , 'ProductData' )
      
      ::createShoesNode()

   ::oNodeProduct:addBelow( ::oNodeProductData )

Return ( self )

//---------------------------------------------------------------------------//

METHOD createShoesNode()

   ::oNodeShoes     := TXmlNode():new( , 'Shoes' )
      ::oNodeShoes:addBelow( TXmlNode():new( , 'ClothingType', , ::ClothingType ) )
      
      ::createVariationDataNode()
      
      ::createClassificationDataNode()

   ::oNodeProductData:addBelow( ::oNodeShoes )

Return ( self )

//---------------------------------------------------------------------------//

METHOD createVariationDataNode()

   ::oNodeVariationData     := TXmlNode():new( , 'VariationData' )
      ::oNodeVariationData:addBelow( TXmlNode():new( , 'Parentage', , ::Parentage ) )
      ::oNodeVariationData:addBelow( TXmlNode():new( , 'VariationTheme', , ::Size ) )

   ::oNodeShoes:addBelow( ::oNodeVariationData )

Return ( self )

//---------------------------------------------------------------------------//

METHOD createClassificationDataNode()

   ::oNodeClassificationData     := TXmlNode():new( , 'ClassificationData' )
      ::oNodeClassificationData:addBelow( TXmlNode():new( , 'CountryOfOrigin', , ::CountryOfOrigin ) )

   ::oNodeShoes:addBelow( ::oNodeClassificationData )

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

