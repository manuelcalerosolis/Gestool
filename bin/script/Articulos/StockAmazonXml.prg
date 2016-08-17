#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS TStockAmazonXml

   DATA  nView

   DATA  MessageID
   DATA  Skuparent
   DATA  Quantity
   DATA  FulfillmentLatency

   DATA  oXml
   DATA  oNodeAmazonEnvelope
   DATA  oNodeHeader
   DATA  oNodeMessage
   DATA  oNodeInventory

   DATA  hDC
   DATA  cXmlFileStock

   METHOD New( nView )

   METHOD Controller()

   METHOD createRootNode()             INLINE   (  ::oXml                  := TXmlDocument():new( '<?xml version="1.0" encoding="UTF-8"?>' ) )
   METHOD createAmazonEnvelopeNode()   INLINE   (  ::oNodeAmazonEnvelope   := TXmlNode():new( , "AmazonEnvelope",;
                                                   {  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",;
                                                      "xsi:noNamespaceSchemaLocation" => "amzn-envelope.xsd" } ) )

   METHOD createHeaderNode()
   METHOD createMessageTypeNode()      INLINE   (  ::oNodeAmazonEnvelope:addBelow( TXmlNode():new( , 'MessageType', , 'Inventory' ) ) )

   METHOD createMessageNode()
   METHOD createInventoryNode()

   METHOD addBelowAmazonEnvelopeNode() INLINE   ( ::oXml:oRoot:addBelow( ::oNodeAmazonEnvelope ) )

   METHOD writeFileProduct()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView
               
   ::cXmlFileStock          := alltrim( ( D():Articulos( ::nView ) )->Codigo ) + "_stock.xml"
            
   ::MessageID                := alltrim( ( D():Articulos( ::nView ) )->Codigo )
   ::Skuparent                := alltrim( ( D():Articulos( ::nView ) )->Codigo )
   ::Quantity                 := ""
   ::FulfillmentLatency       := ""   

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
      ::oNodeHeader:addBelow( TXmlNode():new( , 'DocumentVersion', , '1.00' ) )
      ::oNodeHeader:addBelow( TXmlNode():new( , 'MerchantIdentifier', , 'MRCHARNT' ) )

   ::oNodeAmazonEnvelope:addBelow( ::oNodeHeader )

Return ( self )

//---------------------------------------------------------------------------//

METHOD createMessageNode()

   ::oNodeMessage     := TXmlNode():new( , 'Message' )
      ::oNodeMessage:addBelow( TXmlNode():new( , 'MessageID', , ::MessageID ) )
      ::oNodeMessage:addBelow( TXmlNode():new( , 'OperationType', , 'Update' ) )

      ::createInventoryNode()

   ::oNodeAmazonEnvelope:addBelow( ::oNodeMessage )

Return ( self )

//---------------------------------------------------------------------------//

METHOD createInventoryNode()

   ::oNodeInventory     := TXmlNode():new( , 'Inventory' )
      ::oNodeInventory:addBelow( TXmlNode():new( , 'SKU', , ::Skuparent ) )
      ::oNodeInventory:addBelow( TXmlNode():new( , 'Quantity', , ::Quantity ) )
      ::oNodeInventory:addBelow( TXmlNode():new( , 'FulfillmentLatency', , ::FulfillmentLatency ) )


   ::oNodeMessage:addBelow( ::oNodeInventory )

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

      ferase( ::cXmlFileStock )

      ::hDC       := fCreate( ::cXmlFileStock )

      if ::hDC < 0
         ::hDC    := 0
      endif

      ::oXml:Write( ::hDC, HBXML_STYLE_INDENT )

      fClose( ::hDC )

      ::hDC       := 0

      msgInfo( "Fichero generado " + Lower( ::cXmlFileStock ) + " satisfactoriamente.", 1 )

   RECOVER USING oError

      ::lError    := .t.

      msgStop( "Error el generar el fichero " + Lower( ::cXmlFileStock ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( self )

//---------------------------------------------------------------------------//

