#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConfiguracionesController FROM SQLBaseController

   DATA cSerie                      INIT space( 1 )

   DATA cTabla                      INIT space( 1 )

   METHOD New()

   METHOD End()

   METHOD setTabla( cTabla )        INLINE ( ::cTabla := cTabla )

   METHOD setSerie( cSerie )        INLINE ( ::cSerie := cSerie )

   METHOD Edit()

   METHOD loadedBlankBuffer()

   METHOD getConfiguracionesView()  INLINE ( if( empty( ::oDialogView ), ::oDialogView := ConfiguracionesView():New( self ), ), ::oDialogView )

   METHOD getConfiguracionesRepository() ;
                                    INLINE ( if( empty( ::oRepository ), ::oRepository := ConfiguracionesRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::oModel                      := SQLConfiguracionesModel():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oModel:End()

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 
   
   if !empty( ::oRepository )
      ::oRepository:End()
   end if    

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Edit() 

   ::getConfiguracionesView():setItems( ::oModel:getItemsMovimientosAlmacen() )

   if ::getConfiguracionesView():Activate()

      ::oModel:setItemsMovimientosAlmacen()
      
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD loadedBlankBuffer()

   hset( ::oModel:hBuffer, "tabla", ::cTabla )

   hset( ::oModel:hBuffer, "serie", ::cSerie )

RETURN ( nil )

//---------------------------------------------------------------------------//
