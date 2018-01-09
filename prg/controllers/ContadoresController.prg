#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ContadoresController FROM SQLBaseController

   DATA cSerie                   INIT space( 1 )

   DATA cTabla                   INIT space( 1 )

   METHOD New()

   METHOD setTabla( cTabla )     INLINE ( ::cTabla := cTabla )

   METHOD setSerie( cSerie )     INLINE ( ::cSerie := cSerie )

   METHOD Edit()

   METHOD loadedBlankBuffer()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cTitle                := "Contadores"

   ::oModel                := SQLContadoresModel():New( self )

   ::oDialogView           := ContadoresView():New( self )

   ::oModel:setEvent( 'loadedBlankBuffer', {|| ::loadedBlankBuffer() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Edit() 

   local nId               := ContadoresRepository():getId( ::cTabla, ::cSerie )

   if !empty( nId )
      RETURN ( ::Super:Edit( nId ) )
   end if 

RETURN ( ::Super:Append() )

//----------------------------------------------------------------------------//

METHOD loadedBlankBuffer()

   hset( ::oModel:hBuffer, "tabla", ::cTabla )

   hset( ::oModel:hBuffer, "serie", ::cSerie )

RETURN ( Self )

//---------------------------------------------------------------------------//
