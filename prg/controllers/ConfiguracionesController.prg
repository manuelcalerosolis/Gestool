#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConfiguracionesController FROM SQLBaseController

   DATA aItems                   INIT {}

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD setItems( aItems )     INLINE ( ::aItems := aItems )
   METHOD getItems()             INLINE ( ::aItems )

   METHOD Edit()

   METHOD getModelValue( cDocumento, cClave, uDefault ) ;
                                 INLINE ( ::getModel():getValue( cDocumento, cClave, uDefault ) )

   METHOD getModelNumeric( cDocumento, cClave, uDefault ) ;
                                 INLINE ( ::getModel():getNumeric( cDocumento, cClave, uDefault ) )
   
   METHOD setModelItems()      

   // Construcciones tardias---------------------------------------------------

   METHOD getModel()             INLINE ( if( empty( ::oModel ), ::oModel := SQLConfiguracionesModel():New( self ), ), ::oModel )

   METHOD getDialogView()        INLINE ( if( empty( ::oDialogView ), ::oDialogView := ConfiguracionesView():New( self ), ), ::oDialogView )

   METHOD getRepository()        INLINE ( if( empty( ::oRepository ), ::oRepository := ConfiguracionesRepository():New( self ), ), ::oRepository )

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
      ::setModelItems() 
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD setModelItems() CLASS ConfiguracionesController

   local hItem

   for each hItem in ::aItems
      ::getModel():insertOnDuplicateTransactional( {  "documento" => ::oController:cName,;
                                                      "clave" => hget( hItem, "clave" ),;
                                                      "valor" => hget( hItem, "valor" ) } )
   next

RETURN ( nil )

//----------------------------------------------------------------------------//
