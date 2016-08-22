#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS TImagesAmazonXml

   DATA  nView

   DATA  MessageID
   DATA  Skuparent
   DATA  ImageType
   DATA  ImageLocation

   DATA  oXml
   DATA  oNodeAmazonEnvelope
   DATA  oNodeHeader
   DATA  oNodeMessage
   DATA  oNodeProductImage

   DATA  hDC
   DATA  cXmlFileProductImage

   METHOD New( nView )

   METHOD Controller()

   METHOD createRootNode()             INLINE   (  ::oXml                  := TXmlDocument():new( '<?xml version="1.0" encoding="UTF-8"?>' ) )
   METHOD createAmazonEnvelopeNode()   INLINE   (  ::oNodeAmazonEnvelope   := TXmlNode():new( , "AmazonEnvelope",;
                                                   {  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",;
                                                      "xsi:noNamespaceSchemaLocation" => "amzn-envelope.xsd" } ) )

   METHOD createHeaderNode()
   METHOD createMessageTypeNode()      INLINE   (  ::oNodeAmazonEnvelope:addBelow( TXmlNode():new( , 'MessageType', , 'ProductImage' ) ) )
  
   METHOD createMessageNode()
   METHOD createProductImageNode()

   METHOD addBelowAmazonEnvelopeNode() INLINE   ( ::oXml:oRoot:addBelow( ::oNodeAmazonEnvelope ) )

   METHOD writeFileProduct()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

   ::cXmlFileProductImage     := alltrim( ( D():Articulos( ::nView ) )->Codigo ) + "_image.xml"

   ::MessageID                := alltrim( ( D():Articulos( ::nView ) )->Codigo )
   ::Skuparent                := alltrim( ( D():Articulos( ::nView ) )->Codigo )
   ::ImageType                := "Main"
   ::ImageLocation            := alltrim( ( D():ArticuloImagenes( ::nView ) )->cRmtArt )

  // "http://" + ::TComercioConfig():getMySqlServer() + "/" + ::cDirectoryProduct() + "/" + ::getRecursiveFolderPrestashop( hget( hProductImage, "cCarpeta" ) ) + cNoPath( cTypeImage ) 

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
      ::oNodeMessage:addBelow( TXmlNode():new( , 'OperationType', , 'Update' ) )

      ::createProductImageNode()

   ::oNodeAmazonEnvelope:addBelow( ::oNodeMessage )

Return ( self )

//---------------------------------------------------------------------------//
   
METHOD createProductImageNode()

   ::oNodeProductImage     := TXmlNode():new( , 'ProductImage' )
      ::oNodeProductImage:addBelow( TXmlNode():new( , 'SKU', , ::Skuparent ) )
      ::oNodeProductImage:addBelow( TXmlNode():new( , 'ImageType', , ::ImageType ) )
      ::oNodeProductImage:addBelow( TXmlNode():new( , 'ImageLocation', , ::ImageLocation ) )


   ::oNodeMessage:addBelow( ::oNodeProductImage )

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

      ferase( ::cXmlFileProductImage )

      ::hDC       := fCreate( ::cXmlFileProductImage )

      if ::hDC < 0
         ::hDC    := 0
      endif

      ::oXml:Write( ::hDC, HBXML_STYLE_INDENT )

      fClose( ::hDC )

      ::hDC       := 0

      msgInfo( "Fichero generado " + Lower( ::cXmlFileProductImage ) + " satisfactoriamente.", 1 )

   RECOVER USING oError

      ::lError    := .t.

      msgStop( "Error el generar el fichero " + Lower( ::cXmlFileProductImage ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( self )

//---------------------------------------------------------------------------//