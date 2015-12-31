
#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentHeader FROM DocumentBase

   METHOD getClient()                                          INLINE ( ::getValue( "Client" ) )
   METHOD setClient( value )                                   INLINE ( ::setValue( "Client", value ) )

END CLASS

//---------------------------------------------------------------------------//

CLASS AliasDocumentHeader FROM DocumentHeader

   METHOD getAlias()                                           INLINE ( ::oSender:getHeaderAlias() )
   METHOD getDictionary()                                      INLINE ( ::oSender:getHeaderDictionary() )

END CLASS

//---------------------------------------------------------------------------//

