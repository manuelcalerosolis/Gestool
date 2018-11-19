#include "fiveWin.ch"

//----------------------------------------------------------------------------//

FUNCTION testWebService()

   local oXml
   local cXml  
   local oXmlId
   local oXmlIdData
   local oWebService 

   cXml           := getXML()

   oWebService    := WebService():New()
   oWebService:setUrl( "http://ps.local/api/product_features" )
   oWebService:setParams( "ws_key", "449K7Y8PZTPPVBIFCSMCPDVYLZNK9J9B" )
   oWebService:setMethod( "POST" )
   oWebService:Open()
   oWebService:SetRequestHeader( "Content-Type", "application/x-www-form-urlencoded" )
   oWebService:SetRequestHeader( "Content-Length", len( cXml ) )
   oWebService:Send( cXml ) 

   ? oWebService:getResponseId()

   oWebService:End()

RETURN ( nil )

//----------------------------------------------------------------------------// 

STATIC FUNCTION getXML()

   local cXml

TEXT INTO cXml
<?xml version="1.0" encoding="UTF-8"?>
<prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
<product_feature>
<name>
<language id="1">
%1%s <![CDATA[Test feature value SQL]]>
</language>
<language id="2">
<![CDATA[Test feature value SQL]]>
</language>
<language id="3">
<![CDATA[Test feature value SQL]]>
</language>
<language id="4">
<![CDATA[Test feature value SQL]]>
</language>
</name>
</product_feature>
</prestashop>
ENDTEXT

RETURN ( cXml )

//--------------------------------------------------------------------------//

CLASS WebService

   DATA oService

   DATA cKey   

   DATA cMethod       

   DATA cUrl    

   DATA cPost     

   DATA lErrors  

   DATA hParams  

   DATA cUser

   DATA cPassword

   METHOD New()                        CONSTRUCTOR

   METHOD End() 

   METHOD createService()

   METHOD Open()

   METHOD hasErrors()                  INLINE ( ::lErrors )

   METHOD setKey( cKey )               INLINE ( ::cKey := cKey )
   METHOD getKey()                     INLINE ( ::cKey )

   METHOD setService( cService )       INLINE ( ::cService := cService )
   METHOD getService()                 INLINE ( ::cService )

   METHOD setMethod( cMethod )         INLINE ( ::cMethod := cMethod )
   METHOD getMethod()                  INLINE ( ::cMethod )

   METHOD setUrl( cUrl )               INLINE ( ::cUrl := cUrl )
   METHOD getUrl()                     

   METHOD setUser( cUser )             INLINE ( ::cUser := cUser )
   METHOD getUser()                    INLINE ( ::cUser )

   METHOD setPassword( cPassword )     INLINE ( ::cPassword := cPassword )
   METHOD getPassword()                INLINE ( ::cPassword )

   METHOD SetRequestHeader( cHeader, uValue )  

   METHOD Send( uBody )   

   METHOD getStatus()                  INLINE ( ::oService:Status )

   METHOD getResponseText()            INLINE ( ::oService:ResponseText )
   METHOD getResponseTextAsXml()       INLINE ( TXmlDocument():new( ::oService:ResponseText ) )
   METHOD getResponseId()

   METHOD setParams( cKey, uValue )

END CLASS

//--------------------------------------------------------------------------//

METHOD New()

   ::lErrors      := .f.

   ::hParams      := {=>}

   ::createService()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oService  := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createService()

   local oError

   try
     ::oService   := CreateObject( "MSXML2.ServerXMLHTTP.6.0" )
   catch oError
     ::lErrors    := .t.
   end

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Open( cMethod, cUrl, lAsync, cUser, cPassword )   

   DEFAULT cMethod   := ::getMethod()
   DEFAULT cUrl      := ::getUrl()
   DEFAULT lAsync    := .f.
   DEFAULT cUser     := ::getUser()
   DEFAULT cPassword := ::getPassword()

RETURN ( ::oService:Open( cMethod, cUrl, lAsync, cUser, cPassword ) )

//---------------------------------------------------------------------------//

METHOD getUrl()

   hEval( ::hParams, {| k, v | ::cUrl  += "?" + k + "=" + v } )

RETURN ( ::cUrl )

//---------------------------------------------------------------------------//

METHOD SetRequestHeader( cHeader, uValue )     

RETURN ( ::oService:SetRequestHeader( cHeader, uValue ) )

//---------------------------------------------------------------------------//

METHOD Send( uBody )   

RETURN ( ::oService:Send( uBody ) )

//---------------------------------------------------------------------------//

METHOD setParams( cKey, uValue )

RETURN ( hset( ::hParams, cKey, uValue ) )

//---------------------------------------------------------------------------//

METHOD getResponseId()

   local oXml
   local oNodeId
   local oNodeData

   if ::getStatus() != 201
      RETURN ( nil )
   end if 

   oNodeId     := ::getResponseTextAsXml():findFirst( 'id' ) 
   if empty( oNodeId )
      RETURN ( nil )
   end if 

   oNodeData   :=  oNodeId:NextInTree()
   if !empty( oNodeData )
      RETURN ( oNodeData:cData ) 
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
