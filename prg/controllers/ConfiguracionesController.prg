#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConfiguracionesController FROM SQLBaseController

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

   ::oModel                := SQLConfiguracionesModel():New( self )

   ::oDialogView           := ConfiguracionesView():New( self )

   ::oRepository           := ConfiguracionesRepository():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Edit() 

   local lResult

   ::oModel:getItemsMovimientosAlmacen()

   if ::oDialogView:Activate()
      ::oModel:setItemsMovimientosAlmacen()
   end if 

   // if !empty( nId )
   //    RETURN ( ::Super:Edit( nId ) )
   // end if 

// RETURN ( ::Super:Append() )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD loadedBlankBuffer()

   hset( ::oModel:hBuffer, "tabla", ::cTabla )

   hset( ::oModel:hBuffer, "serie", ::cSerie )

RETURN ( Self )

//---------------------------------------------------------------------------//
