#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS TProductAmazonXml

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
   DATA  VariationTheme
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
   DATA  cXmlFileProduct

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

   METHOD writeFileProduct()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView
               
   ::cXmlFileProduct          := alltrim( ( D():Articulos( ::nView ) )->Codigo ) + "_product.xml"
            
   ::MessageID                := alltrim( ( D():Articulos( ::nView ) )->Codigo )
   ::Skuparent                := alltrim( ( D():Articulos( ::nView ) )->Codigo )
   ::Title                    := alltrim( ( D():Articulos( ::nView ) )->Nombre )
   ::Brand                    := alltrim( retFamilia( ( D():Articulos( ::nView ) )->Familia, D():Familias( ::nView ) ) )
   ::Description              := alltrim( ( D():Articulos( ::nView ) )->mDesTec )
   ::Manufacturer             := alltrim( retFamilia( ( D():Articulos( ::nView ) )->Familia, D():Familias( ::nView ) ) )
   ::SearchTerms              := alltrim( ( D():Articulos( ::nView ) )->cKeySeo )
   ::RecommendedBrowseNode    := getCustomExtraField( '000', 'Artículos', ( D():Articulos( ::nView ) )->Codigo )
   ::ClothingType             := allTrim( retFld( ( D():Articulos( ::nView ) )->cCodTip, D():ArticuloTipos( ::nView ) ) )
   ::Parentage                := "Parent/Child"                   
   ::VariationTheme           := "Size/Color"
   ::CountryOfOrigin          := "ES"      

Return ( self )

//---------------------------------------------------------------------------//

METHOD Controller()

   ::createRootNode()

   ::createAmazonEnvelopeNode() 

   ::createHeaderNode()

   ::createMessageTypeNode()

   ::createPurgeAndReplace()

   ::createMessageNode()

   // Nodo final---------------------------------------------------------------

   ::addBelowAmazonEnvelopeNode()  



   ::writeFileProduct()

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
      ::oNodeVariationData:addBelow( TXmlNode():new( , 'VariationTheme', , ::VariationTheme ) )

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

METHOD writeFileProduct()

   local oError
   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ferase( ::cXmlFileProduct )

      ::hDC       := fCreate( ::cXmlFileProduct )

      if ::hDC < 0
         ::hDC    := 0
      endif

      ::oXml:Write( ::hDC, HBXML_STYLE_INDENT )

      fClose( ::hDC )

      ::hDC       := 0

      msgInfo( "Fichero generado " + Lower( ::cXmlFileProduct ) + " satisfactoriamente.", 1 )

   RECOVER USING oError

      ::lError    := .t.

      msgStop( "Error el generar el fichero " + Lower( ::cXmlFileProduct ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( self )

//---------------------------------------------------------------------------//

