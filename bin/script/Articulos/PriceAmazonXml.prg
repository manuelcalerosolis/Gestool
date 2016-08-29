#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS TPriceAmazonXml

   DATA  nView

   DATA  MessageID
   DATA  Skuparent
   DATA  StartDate
   DATA  StandardPrice
   DATA  EndDate
   DATA  SalePrice

   DATA  oXml
   DATA  oNodeAmazonEnvelope
   DATA  oNodeHeader
   DATA  oNodeMessage
   DATA  oNodeSale
   DATA  oNodePrice

   DATA  hDC
   DATA  cXmlFilePrice

   METHOD New( nView )

   METHOD Controller()

   METHOD createRootNode()             INLINE   (  ::oXml                  := TXmlDocument():new( '<?xml version="1.0" encoding="ISO-8859-1"?>' ) )
   METHOD createAmazonEnvelopeNode()   INLINE   (  ::oNodeAmazonEnvelope   := TXmlNode():new( , "AmazonEnvelope",;
                                                   {  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",;
                                                      "xsi:noNamespaceSchemaLocation" => "amzn-envelope.xsd" } ) )

   METHOD createHeaderNode()
   METHOD createMessageTypeNode()      INLINE   (  ::oNodeAmazonEnvelope:addBelow( TXmlNode():new( , 'MessageType', , 'Price' ) ) )

   METHOD createMessageNode()
   METHOD createSaleNode()
   METHOD createPriceNode()

   METHOD addBelowAmazonEnvelopeNode() INLINE   ( ::oXml:oRoot:addBelow( ::oNodeAmazonEnvelope ) )

   METHOD writeFileProduct()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView
               
   ::cXmlFilePrice            := alltrim( ( D():Articulos( ::nView ) )->Codigo ) + "_price.xml"
            
   ::MessageID                := alltrim( ( D():Articulos( ::nView ) )->Codigo )
   ::Skuparent                := alltrim( ( D():Articulos( ::nView ) )->Codigo )
   ::StandardPrice            := alltrim( str( ( D():Articulos( ::nView ) )->nImpIva1 ) )
   ::StartDate                := ""  
   ::EndDate                  := "" 
   ::SalePrice                := "" 

Return ( self )

//---------------------------------------------------------------------------//

METHOD Controller()

   ::createRootNode()

   ::createAmazonEnvelopeNode() 

   ::createHeaderNode()

   ::createMessageTypeNode()

   ::createMessageNode()

   // Nodo final---------------------------------------------------------------

   ::addBelowAmazonEnvelopeNode()  

   ::writeFileProduct()

Return ( self )

//---------------------------------------------------------------------------//

METHOD createHeaderNode()

   ::oNodeHeader     := TXmlNode():new( , 'Header' )
      ::oNodeHeader:addBelow( TXmlNode():new( , 'DocumentVersion', , '1.01' ) )
      ::oNodeHeader:addBelow( TXmlNode():new( , 'MerchantIdentifier', , 'M_MECHANT_ID' ) )

   ::oNodeAmazonEnvelope:addBelow( ::oNodeHeader )

Return ( self )

//---------------------------------------------------------------------------//

METHOD createMessageNode()

   ::oNodeMessage     := TXmlNode():new( , 'Message' )
      ::oNodeMessage:addBelow( TXmlNode():new( , 'MessageID', , ::MessageID ) )

      ::createPriceNode()

      ::createSaleNode()

   ::oNodeAmazonEnvelope:addBelow( ::oNodeMessage )

Return ( self )

//---------------------------------------------------------------------------//

METHOD createPriceNode()

   ::oNodePrice     := TXmlNode():new( , 'Price' )
      ::oNodePrice:addBelow( TXmlNode():new( , 'SKU', , ::Skuparent ) )
      ::oNodePrice:addBelow( TXmlNode():new( , 'StandardPrice currency="EUR"', , ::StandardPrice ) )


   ::oNodeMessage:addBelow( ::oNodePrice )

Return ( self )

//---------------------------------------------------------------------------//

METHOD createSaleNode()

   ::oNodeSale     := TXmlNode():new( , 'Sale' )
      ::oNodeSale:addBelow( TXmlNode():new( , 'StartDate', , ::StartDate ) )
      ::oNodeSale:addBelow( TXmlNode():new( , 'EndDate', , ::EndDate ) )
      ::oNodeSale:addBelow( TXmlNode():new( , 'SalePrice currency="EUR"', , ::SalePrice ) )

   ::oNodeMessage:addBelow( ::oNodeSale )

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

      ferase( ::cXmlFilePrice )

      ::hDC       := fCreate( ::cXmlFilePrice )

      if ::hDC < 0
         ::hDC    := 0
      endif

      ::oXml:Write( ::hDC, HBXML_STYLE_INDENT )

      fClose( ::hDC )

      ::hDC       := 0

      msgInfo( "Fichero generado " + Lower( ::cXmlFilePrice ) + " satisfactoriamente.", 1 )

   RECOVER USING oError

      ::lError    := .t.

      msgStop( "Error el generar el fichero " + Lower( ::cXmlFilePrice ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( self )

//---------------------------------------------------------------------------//
