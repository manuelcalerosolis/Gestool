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

   DATA oCuentasRemesaController

   DATA oRutasController

   DATA oClientesGruposController

   DATA oContactosController

   DATA oIncidenciasController

   DATA oDescuentosController

   DATA oClientesEntidadesController

   DATA oEntidadesController

   DATA oClientesTarifasController

   DATA oCamposExtraController

   DATA oCamposExtraEntidadesController

   DATA oCamposExtraValoresController

   DATA oUnidadesMedicionOperacionesController

   DATA oTagsController

   DATA oImagenesController

   DATA oComentariosController

   DATA oComentariosLineasController

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

   METHOD getCuentasRemesaController();
                                    INLINE ( if( empty( ::oCuentasRemesaController ), ::oCuentasRemesaController := CuentasRemesaController():New( self ), ), ::oCuentasRemesaController )

   METHOD getRutasController();
                                    INLINE ( if( empty( ::oRutasController ), ::oRutasController := RutasController():New( self ), ), ::oRutasController )

   METHOD getClientesGruposController();
                                    INLINE ( if( empty( ::oClientesGruposController ), ::oClientesGruposController := ClientesGruposController():New( self ), ), ::oClientesGruposController )

   METHOD getContactosController();
                                    INLINE ( if( empty( ::oContactosController ), ::oContactosController := ContactosController():New( self ), ), ::oContactosController )

   METHOD getIncidenciasController();
                                    INLINE ( if( empty( ::oIncidenciasController ), ::oIncidenciasController := IncidenciasController():New( self ), ), ::oIncidenciasController )

   METHOD getDescuentosController();
                                    INLINE ( if( empty( ::oDescuentosController ), ::oDescuentosController := DescuentosController():New( self ), ), ::oDescuentosController )

   METHOD getClientesEntidadesController();
                                    INLINE ( if( empty( ::oClientesEntidadesController ), ::oClientesEntidadesController := ClientesEntidadesController():New( self ), ), ::oClientesEntidadesController )

   METHOD getEntidadesController();
                                    INLINE ( if( empty( ::oEntidadesController ), ::oEntidadesController := EntidadesController():New( self ), ), ::oEntidadesController )

   METHOD getClientesTarifasController();
                                    INLINE ( if( empty( ::oClientesTarifasController ), ::oClientesTarifasController := ClientesTarifasController():New( self ), ), ::oClientesTarifasController )

   METHOD getCamposExtraController();
                                    INLINE ( if( empty( ::oCamposExtraController ), ::oCamposExtraController := CamposExtraController():New( self ), ), ::oCamposExtraController )

   METHOD getCamposExtraEntidadesController();
                                    INLINE ( if( empty( ::oCamposExtraEntidadesController ), ::oCamposExtraEntidadesController := CamposExtraEntidadesController():New( self ), ), ::oCamposExtraEntidadesController )

   METHOD getCamposExtraValoresController();
                                    INLINE ( if( empty( ::oCamposExtraValoresController ), ::oCamposExtraValoresController := CamposExtraValoresController():New( self ), ), ::oCamposExtraValoresController )

   METHOD getUnidadesMedicionOperacionesController();
                                    INLINE ( if( empty( ::oUnidadesMedicionOperacionesController ), ::oUnidadesMedicionOperacionesController := UnidadesMedicionOperacionesController():New( self ), ), ::oUnidadesMedicionOperacionesController )

   METHOD getTagsController();
                                    INLINE ( if( empty( ::oTagsController ), ::oTagsController := TagsController():New( self ), ), ::oTagsController )

   METHOD getImagenesController();
                                    INLINE ( if( empty( ::oImagenesController ), ::oImagenesController := ImagenesController():New( self ), ), ::oImagenesController )

   METHOD getComentariosController();
                                    INLINE ( if( empty( ::oComentariosController ), ::oComentariosController := ComentariosController():New( self ), ), ::oComentariosController )

   METHOD getComentariosLineasController();
                                    INLINE ( if( empty( ::oComentariosLineasController ), ::oComentariosLineasController := ComentariosLineasController():New( self ), ), ::oComentariosLineasController )

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

   if !empty( ::oCuentasRemesaController )   
      ::oCuentasRemesaController:End()
   end if 

   if !empty( ::oRutasController )   
      ::oRutasController:End()
   end if  

  if !empty( ::oClientesGruposController )   
      ::oClientesGruposController:End()
   end if 

   if !empty( ::oContactosController )   
      ::oContactosController:End()
   end if 

   if !empty( ::oIncidenciasController )   
      ::oIncidenciasController:End()
   end if 

   if !empty( ::oDescuentosController )   
      ::oDescuentosController:End()
   end if 

   if !empty( ::oClientesEntidadesController )   
      ::oClientesEntidadesController:End()
   end if 

   if !empty( ::oEntidadesController )   
      ::oEntidadesController:End()
   end if 

   if !empty( ::oClientesTarifasController )   
      ::oClientesTarifasController:End()
   end if 

   if !empty( ::oCamposExtraController )   
      ::oCamposExtraController:End()
   end if 

   if !empty( ::oCamposExtraEntidadesController )   
      ::oCamposExtraEntidadesController:End()
   end if 

   if !empty( ::oCamposExtraValoresController )   
      ::oCamposExtraValoresController:End()
   end if 

   if !empty( ::oUnidadesMedicionOperacionesController )   
      ::oUnidadesMedicionOperacionesController:End()
   end if 

   if !empty( ::oTagsController )   
      ::oTagsController:End()
   end if 

   if !empty( ::oImagenesController )   
      ::oImagenesController:End()
   end if  

   if !empty( ::oComentariosController )   
      ::oComentariosController:End()
   end if  

   if !empty( ::oComentariosLineasController )   
      ::oComentariosLineasController:End()
   end if 

   ::Super:End()

   logwriteSeconds( "sqlApplicationController ::Super:End()" )

RETURN ( nil )

//---------------------------------------------------------------------------//