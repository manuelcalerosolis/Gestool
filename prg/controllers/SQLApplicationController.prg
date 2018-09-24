#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLApplicationController FROM SQLBaseController

   DATA oGetSelector

   DATA oCodigosPostalesController

   DATA oDireccionesController

   DATA oPaisesController

   DATA oProvinciasController

   DATA oCamposExtraValoresController

   DATA oConfiguracionVistasController

   METHOD getSelector()             INLINE ( if( empty( ::oGetSelector ), ::oGetSelector := GetSelector():New( self ), ), ::oGetSelector )

   METHOD getCodigosPostalesController();
                                    INLINE ( if( empty( ::oCodigosPostalesController ), ::oCodigosPostalesController := CodigosPostalesController():New( self ), ), ::oCodigosPostalesController )

   METHOD getDireccionesController();
                                    INLINE ( if( empty( ::oDireccionesController ), ::oDireccionesController := DireccionesController():New( self ), ), ::oDireccionesController )

   METHOD getPaisesController()     INLINE ( if( empty( ::oPaisesController ), ::oPaisesController := PaisesController():New( self ), ), ::oPaisesController )

   METHOD getProvinciasController() INLINE ( if( empty( ::oProvinciasController ), ::oProvinciasController := ProvinciasController():New( self ), ), ::oProvinciasController )

   METHOD getCamposExtraValoresController();
                                    INLINE ( if( empty( ::oCamposExtraValoresController ), ::oCamposExtraValoresController := CamposExtraValoresController():New( self, 'agentes' ), ), ::oCamposExtraValoresController )

   METHOD getConfiguracionVistasController();
                                    INLINE ( if( empty( ::oConfiguracionVistasController ), ::oConfiguracionVistasController := SQLConfiguracionVistasController():New( self ), ), ::oConfiguracionVistasController )

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD End() CLASS SQLApplicationController

   logwriteSeconds( "sqlApplicationController oValidator" )
   
   if !empty( ::oGetSelector )
      ::oGetSelector:End()
   end if 
   
   if !empty( ::oCodigosPostalesController )
      ::oCodigosPostalesController:End()
   end if 

   logwriteSeconds( "sqlApplicationController oGetSelector" )

   if !empty( ::oDireccionesController )
      ::oDireccionesController:End()
   end if 
   
   logwriteSeconds( "sqlApplicationController oDireccionesController" )

   if !empty( ::oPaisesController )
      ::oPaisesController:End()
   end if 
   
   logwriteSeconds( "sqlApplicationController oPaisesController" )

   if !empty( ::oProvinciasController )
      ::oProvinciasController:End()
   end if 
   
   logwriteSeconds( "sqlApplicationController oProvinciasController" )

   if !empty( ::oCamposExtraValoresController )
      ::oCamposExtraValoresController:End()
   end if 

   logwriteSeconds( "sqlApplicationController oCamposExtraValoresController" )
  
   if !empty( ::oConfiguracionVistasController )
      ::oConfiguracionVistasController:End()
   end if 

   ::Super:End()

   logwriteSeconds( "sqlApplicationController ::Super:End()" )

RETURN ( nil )

//---------------------------------------------------------------------------//