#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConfiguracionesController FROM SQLBaseController

   DATA cSerie                   INIT space( 1 )

   DATA cTabla                   INIT space( 1 )

   DATA aItems                   INIT {}

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD setTabla( cTabla )     INLINE ( ::cTabla := cTabla )

   METHOD setSerie( cSerie )     INLINE ( ::cSerie := cSerie )

   METHOD Edit()

   METHOD loadedBlankBuffer()

   METHOD getModel()             INLINE ( if( empty( ::oModel ), ::oModel := SQLConfiguracionesModel():New( self ), ), ::oModel )

   METHOD getDialogView()        INLINE ( if( empty( ::oDialogView ), ::oDialogView := ConfiguracionesView():New( self ), ), ::oDialogView )

   METHOD getRepository()        INLINE ( if( empty( ::oRepository ), ::oRepository := ConfiguracionesRepository():New( self ), ), ::oRepository )

   METHOD setItems( aItems )     INLINE ( ::aItems := aItems )

   METHOD getItems()             INLINE ( ::aItems )

   METHOD getModelValue( cDocumento, cClave, uDefault ) ;
                                 INLINE ( ::getModel():getValue( cDocumento, cClave, uDefault ) )

   METHOD getModelNumeric( cDocumento, cClave, uDefault ) ;
                                 INLINE ( ::getModel():getNumeric( cDocumento, cClave, uDefault ) )
   
   METHOD setModelItems()      

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ConfiguracionesController

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConfiguracionesController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oRepository )
      ::oRepository:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS ConfiguracionesController 

   ::setItems( ::oController:getConfigItems() )

   if ::getDialogView():Activate()
      ::setModelItems() // ::getModel():setItemsMovimientosAlmacen()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS ConfiguracionesController

   hset( ::getModel():hBuffer, "tabla", ::cTabla )

   hset( ::getModel():hBuffer, "serie", ::cSerie )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD setModelItems() CLASS ConfiguracionesController

   local hItem

   for each hItem in ::aItems

      ::getModel():insertOnDuplicateTransactional(  { "documento" => ::oController:cName,;
                                                      "clave" => hget( hItem, "clave" ),;
                                                      "valor" => hget( hItem, "valor" ) } )

   next

RETURN ( nil )

//----------------------------------------------------------------------------//
