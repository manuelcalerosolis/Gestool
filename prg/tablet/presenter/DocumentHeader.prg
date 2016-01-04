
#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentHeader FROM DocumentBase

   METHOD getDate()                                            INLINE ( ::getValue( "Fecha" ) )
   METHOD setDate( value )                                     INLINE ( ::setValue( "Fecha", value ) )

   METHOD getClient()                                          INLINE ( ::getValue( "Cliente" ) )
   METHOD setClient( value )                                   INLINE ( ::setValue( "Cliente", value ) )

   METHOD getClientName()                                      INLINE ( ::getValue( "NombreCliente" ) )
   METHOD setClientName( value )                               INLINE ( ::setValue( "NombreCliente", value ) )

END CLASS

//---------------------------------------------------------------------------//

CLASS AliasDocumentHeader FROM DocumentHeader

   METHOD getAlias()                                           INLINE ( ::oSender:getHeaderAlias() )
   METHOD getDictionary()                                      INLINE ( ::oSender:getHeaderDictionary() )

END CLASS

//---------------------------------------------------------------------------//

