
#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentHeader FROM DocumentBase

   METHOD newBuildDictionary( oSender )

   METHOD getDate()                                            INLINE ( ::getValue( "Fecha" ) )
   METHOD setDate( value )                                     INLINE ( ::setValue( "Fecha", value ) )

   METHOD getClient()                                          INLINE ( ::getValue( "Cliente" ) )
   METHOD setClient( value )                                   INLINE ( ::setValue( "Cliente", value ) )

   METHOD getClientName()                                      INLINE ( ::getValue( "NombreCliente" ) )
   METHOD setClientName( value )                               INLINE ( ::setValue( "NombreCliente", value ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD newBuildDictionary( oSender ) CLASS DocumentHeader

   ::new( oSender )

   if !empty( oSender ) .and. __objHasMethod( oSender, "getHeaderAlias" ) .and. __objHasMethod( oSender, "getHeaderDictionary" )
      ::setDictionary( D():getHashFromAlias( oSender:getHeaderAlias(), oSender:getHeaderDictionary() ) )
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

CLASS AliasDocumentHeader FROM DocumentHeader

   METHOD getAlias()                                           INLINE ( if( empty( ::oSender ), "", ::oSender:getHeaderAlias() ) )
   METHOD getDictionary()                                      INLINE ( if( empty( ::oSender ), "", ::oSender:getHeaderDictionary() ) )

   METHOD getValue( key, uDefault )                            INLINE ( D():getFieldFromAliasDictionary( key, ::getAlias(), ::getDictionary(), uDefault ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ClientDeliveryNoteDocumentHeader FROM DocumentHeader

   METHOD newBuildDictionary( oSender )

   METHOD newBlankDictionary( oSender )   

   METHOD newRecordDictionary( oSender )  

END CLASS

//---------------------------------------------------------------------------//

METHOD newBuildDictionary( oSender ) CLASS ClientDeliveryNoteDocumentHeader

   ::setDictionary( D():getHashRecordAlbaranesClientes() )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD newBlankDictionary( oSender )

   ::new( oSender )

   if !empty(oSender)
      ::setDictionary( D():getHashBlankAlbaranesClientes( oSender:nView ) ) 
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD newRecordDictionary( oSender )

  ::new( oSender )

   if !empty(oSender)
      ::setDictionary( D():getHashRecordAlbaranesClientes( oSender:nView ) ) 
   end if 

Return ( Self )

//---------------------------------------------------------------------------//
