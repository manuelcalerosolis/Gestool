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

   DATA oAgentesController

   DATA oArticulosTarifasController

   DATA oArticulosPreciosDescuentosController

   DATA oCuentasBancariasController

   DATA oDocumentosController

   DATA oFormasPagosController

   METHOD getSelector()             INLINE ( if( empty( ::oGetSelector ), ::oGetSelector := GetSelector():New( self ), ), ::oGetSelector )

   METHOD getCodigosPostalesController();
                                    INLINE ( if( empty( ::oCodigosPostalesController ), ::oCodigosPostalesController := CodigosPostalesController():New( self ), ), ::oCodigosPostalesController )

   METHOD getDireccionesController();
                                    INLINE ( if( empty( ::oDireccionesController ), ::oDireccionesController := DireccionesController():New( self ), ), ::oDireccionesController )

   METHOD getPaisesController()     INLINE ( if( empty( ::oPaisesController ), ::oPaisesController := PaisesController():New( self ), ), ::oPaisesController )

   METHOD getProvinciasController() INLINE ( if( empty( ::oProvinciasController ), ::oProvinciasController := ProvinciasController():New( self ), ), ::oProvinciasController )

   METHOD getCamposExtraValoresController();
                                    INLINE ( if( empty( ::oCamposExtraValoresController ), ::oCamposExtraValoresController := CamposExtraValoresController():New( self ), ), ::oCamposExtraValoresController )

   METHOD getConfiguracionVistasController();
                                    INLINE ( if( empty( ::oConfiguracionVistasController ), ::oConfiguracionVistasController := SQLConfiguracionVistasController():New( self ), ), ::oConfiguracionVistasController )

   METHOD getAgentesController()    INLINE ( if( empty( ::oAgentesController ), ::oAgentesController := AgentesController():New( self ), ), ::oAgentesController )
   
   METHOD getArticulosTarifasController();
                                    INLINE ( if( empty( ::oArticulosTarifasController ), ::oArticulosTarifasController := ArticulosTarifasController():New( self ), ), ::oArticulosTarifasController )

   METHOD getArticulosPreciosDescuentosController();
                                    INLINE ( if( empty( ::oArticulosPreciosDescuentosController ), ::oArticulosPreciosDescuentosController := ArticulosPreciosDescuentosController():New( self ), ), ::oArticulosPreciosDescuentosController )

   METHOD getCuentasBancariasController();
                                    INLINE ( if( empty( ::oCuentasBancariasController ), ::oCuentasBancariasController := CuentasBancariasController():New( self ), ), ::oCuentasBancariasController )

   METHOD getDocumentosController();
                                    INLINE ( if( empty( ::oDocumentosController ), ::oDocumentosController := DocumentosController():New( self ), ), ::oCuentasBancariasController )

   METHOD getFormasPagosController();
                                    INLINE ( if( empty( ::oFormasPagosController ), ::oFormasPagosController := FormasPagosController():New( self ), ), ::oFormasPagosController )


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

   if !empty( ::oAgentesController )
      ::oAgentesController:End()
   end if 

   if !empty( ::oArticulosTarifasController )
      ::oArticulosTarifasController:End()
   end if 

   if !empty( ::oArticulosPreciosDescuentosController )   
      ::oArticulosPreciosDescuentosController:End()
   end if 

   if !empty( ::oCuentasBancariasController )   
      ::oCuentasBancariasController:End()
   end if 

   if !empty( ::oDocumentosController )   
      ::oDocumentosController:End()
   end if 

   if !empty( ::oFormasPagosController )   
      ::oFormasPagosController:End()
   end if 

   ::Super:End()

   logwriteSeconds( "sqlApplicationController ::Super:End()" )

RETURN ( nil )

//---------------------------------------------------------------------------//