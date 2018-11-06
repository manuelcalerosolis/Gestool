#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLApplicationController FROM SQLBaseController

   DATA oGetSelector

   DATA oCodigosPostalesController

   DATA oDireccionesController
   
   DATA oDireccionesTiposController

   DATA oPaisesController

   DATA oProvinciasController

   DATA oCamposExtraValoresController

   DATA oConfiguracionVistasController

   DATA oAgentesController

   DATA oArticulosTarifasController

   DATA oArticulosPreciosController

   DATA oArticulosPreciosDescuentosController

   DATA oCuentasBancariasController

   DATA oDocumentosController

   DATA oFormasPagosController

   DATA oMetodosPagosController

   DATA oMediosPagoController

   DATA oCuentasRemesaController

   DATA oRutasController

   DATA oClientesController

   DATA oClientesGruposController

   DATA oContactosController

   DATA oIncidenciasController

   DATA oDescuentosController

   DATA oClientesEntidadesController

   DATA oEntidadesController

   DATA oClientesTarifasController

   DATA oCamposExtraController

   DATA oCamposExtraEntidadesController

   DATA oUnidadesMedicionOperacionesController

   DATA oTagsController

   DATA oImagenesController

   DATA oComentariosController

   DATA oComentariosLineasController

   DATA oLenguajesController

   DATA oTraduccionesController

   DATA oArticulosController

   DATA oArticulosFamiliasController

   DATA oArticulosTipoController

   DATA oArticulosCategoriasController

   DATA oArticulosFabricantesController

   DATA oTipoIvaController

   DATA oImpuestosEspecialesController

   DATA oUnidadesMedicionController

   DATA oArticulosUnidadesMedicionController

   DATA oUnidadesMedicionGruposLineasController

   DATA oUnidadesMedicionGruposController

   DATA oArticulosTemporadasController

   DATA oPropiedadesLineasController

   DATA oPropiedadesController

   DATA oCombinacionesPropiedadesController

   DATA oCombinacionesController

   DATA oFacturasClientesDescuentosController

   DATA oDireccionTipoDocumentoController

   DATA oRelacionesEntidadesController

   DATA oFacturasClientesLineasController

   DATA oFacturasClientesController

   DATA oAlmacenesController
   
   DATA oZonasController
   
   DATA oUbicacionesController

   DATA oDireccionTipoDocumentoController

   DATA oMailController

   DATA oConfiguracionesController

   DATA oImprimirSeriesController

   DATA oUsuariosController

   DATA oEmpresasController

   DATA oAjustableController

   DATA oAjustableGestoolController

   DATA oDelegacionesController 
   
   DATA oArticulosEnvasadoController 
   
   DATA oDivisasMonetariasController 
   
   DATA oCajasController 

   DATA oImpresorasController 
   
   DATA oSesionesController 
   
   DATA oTiposImpresorasController 
   
   DATA oDelegacionesController 

   DATA oSituacionesController 
   
   DATA oRecibosController 
   
   DATA oPermisosController 
   
   DATA oRolesController 

   METHOD getSelector()             INLINE ( if( empty( ::oGetSelector ), ::oGetSelector := GetSelector():New( self ), ), ::oGetSelector )

   METHOD getCodigosPostalesController();
                                    INLINE ( if( empty( ::oCodigosPostalesController ), ::oCodigosPostalesController := CodigosPostalesController():New( self ), ), ::oCodigosPostalesController )

   METHOD getDireccionesController();
                                    INLINE ( if( empty( ::oDireccionesController ), ::oDireccionesController := DireccionesController():New( self ), ), ::oDireccionesController )

   METHOD getDireccionesTiposController();
                                    INLINE ( if( empty( ::oDireccionesTiposController ), ::oDireccionesTiposController := DireccionesTiposController():New( self ), ), ::oDireccionesTiposController )

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

   METHOD getArticulosPreciosController();
                                    INLINE ( if( empty( ::oArticulosPreciosController ), ::oArticulosPreciosController := ArticulosPreciosController():New( self ), ), ::oArticulosPreciosController )

   METHOD getCuentasBancariasController();
                                    INLINE ( if( empty( ::oCuentasBancariasController ), ::oCuentasBancariasController := CuentasBancariasController():New( self ), ), ::oCuentasBancariasController )

   METHOD getDocumentosController();
                                    INLINE ( if( empty( ::oDocumentosController ), ::oDocumentosController := DocumentosController():New( self ), ), ::oDocumentosController )

   METHOD getFormasPagosController();
                                    INLINE ( if( empty( ::oFormasPagosController ), ::oFormasPagosController := FormasPagosController():New( self ), ), ::oFormasPagosController )

   METHOD getMediosPagoController();
                                    INLINE ( if( empty( ::oMediosPagoController ), ::oMediosPagoController := MediosPagoController():New( self ), ), ::oMediosPagoController )

   METHOD getMetodosPagosController();
                                    INLINE ( if( empty( ::oMetodosPagosController ), ::oMetodosPagosController := MetodosPagosController():New( self ), ), ::oMetodosPagosController )

   METHOD getCuentasRemesaController();
                                    INLINE ( if( empty( ::oCuentasRemesaController ), ::oCuentasRemesaController := CuentasRemesaController():New( self ), ), ::oCuentasRemesaController )

   METHOD getRutasController();
                                    INLINE ( if( empty( ::oRutasController ), ::oRutasController := RutasController():New( self ), ), ::oRutasController )

   METHOD getClientesController();
                                    INLINE ( if( empty( ::oClientesController ), ::oClientesController := ClientesController():New( self ), ), ::oClientesController )

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
                                    
   METHOD getLenguajesController()  INLINE ( if( empty( ::oLenguajesController ), ::oLenguajesController := LenguajesController():New( self ), ), ::oLenguajesController )

   METHOD getTraduccionesController();
                                    INLINE ( if( empty( ::oTraduccionesController ), ::oTraduccionesController := TraduccionesController():New( self ), ), ::oTraduccionesController )

   METHOD getArticulosController();
                                    INLINE ( if( empty( ::oArticulosController ), ::oArticulosController := ArticulosController():New( self ), ), ::oArticulosController )

   METHOD getArticulosFamiliasController();
                                    INLINE ( if( empty( ::oArticulosFamiliasController ), ::oArticulosFamiliasController := ArticulosFamiliasController():New( self ), ), ::oArticulosFamiliasController )

   METHOD getArticulosTipoController();
                                    INLINE ( if( empty( ::oArticulosTipoController ), ::oArticulosTipoController := ArticulosTipoController():New( self ), ), ::oArticulosTipoController )

   METHOD getArticulosCategoriasController();
                                    INLINE ( if( empty( ::oArticulosCategoriasController ), ::oArticulosCategoriasController := ArticulosCategoriasController():New( self ), ), ::oArticulosCategoriasController )

   METHOD getArticulosFabricantesController();
                                    INLINE ( if( empty( ::oArticulosFabricantesController ), ::oArticulosFabricantesController := ArticulosFabricantesController():New( self ), ), ::oArticulosFabricantesController )

   METHOD getTipoIvaController()    INLINE ( if( empty( ::oTipoIvaController ), ::oTipoIvaController := TipoIvaController():New( self ), ), ::oTipoIvaController )

   METHOD getImpuestosEspecialesController();
                                    INLINE ( if( empty( ::oImpuestosEspecialesController ), ::oImpuestosEspecialesController := ImpuestosEspecialesController():New( self ), ), ::oImpuestosEspecialesController )

   METHOD getUnidadesMedicionController();
                                    INLINE ( if( empty( ::oUnidadesMedicionController ), ::oUnidadesMedicionController := UnidadesMedicionController():New( self ), ), ::oUnidadesMedicionController )

   METHOD getArticulosUnidadesMedicionController();
                                    INLINE ( if( empty( ::oArticulosUnidadesMedicionController ), ::oArticulosUnidadesMedicionController := ArticulosUnidadesMedicionController():New( self ), ), ::oArticulosUnidadesMedicionController )

   METHOD getUnidadesMedicionGruposLineasController();
                                    INLINE ( if( empty( ::oUnidadesMedicionGruposLineasController ), ::oUnidadesMedicionGruposLineasController := UnidadesMedicionGruposLineasController():New( self ), ), ::oUnidadesMedicionGruposLineasController )

   METHOD getUnidadesMedicionGruposController();
                                    INLINE ( if( empty( ::oUnidadesMedicionGruposController ), ::oUnidadesMedicionGruposController := UnidadesMedicionGruposController():New( self ), ), ::oUnidadesMedicionGruposController )

   METHOD getArticulosTemporadasController();
                                    INLINE ( if( empty( ::oArticulosTemporadasController ), ::oArticulosTemporadasController := ArticulosTemporadasController():New( self ), ), ::oArticulosTemporadasController )

   METHOD getPropiedadesLineasController();
                                    INLINE ( if( empty( ::oPropiedadesLineasController ), ::oPropiedadesLineasController := PropiedadesLineasController():New( self ), ), ::oPropiedadesLineasController )

   METHOD getPropiedadesController();
                                    INLINE ( if( empty( ::oPropiedadesController ), ::oPropiedadesController := PropiedadesController():New( self ), ), ::oPropiedadesController )

   METHOD getCombinacionesPropiedadesController();
                                    INLINE ( if( empty( ::oCombinacionesPropiedadesController ), ::oCombinacionesPropiedadesController := CombinacionesPropiedadesController():New( self ), ), ::oCombinacionesPropiedadesController )

   METHOD getCombinacionesController();
                                    INLINE ( if( empty( ::oCombinacionesController ), ::oCombinacionesController := CombinacionesController():New( self ), ), ::oCombinacionesController )

   METHOD getFacturasClientesDescuentosController();
                                    INLINE ( if( empty( ::oFacturasClientesDescuentosController ), ::oFacturasClientesDescuentosController := FacturasClientesDescuentosController():New( self ), ), ::oFacturasClientesDescuentosController )

   METHOD getDireccionTipoDocumentoController();
                                    INLINE ( if( empty( ::oDireccionTipoDocumentoController ), ::oDireccionTipoDocumentoController := DireccionTipoDocumentoController():New( self ), ), ::oDireccionTipoDocumentoController )

   METHOD getRelacionesEntidadesController();
                                    INLINE ( if( empty( ::oRelacionesEntidadesController ), ::oRelacionesEntidadesController := RelacionesEntidadesController():New( self ), ), ::oRelacionesEntidadesController )

   METHOD getFacturasClientesLineasController();
                                    INLINE ( if( empty( ::oFacturasClientesLineasController ), ::oFacturasClientesLineasController := FacturasClientesLineasController():New( self ), ), ::oFacturasClientesLineasController )

   METHOD getFacturasClientesController();
                                    INLINE ( if( empty( ::oFacturasClientesController ), ::oFacturasClientesController := FacturasClientesController():New( self ), ), ::oFacturasClientesController )

   METHOD getAlmacenesController()  INLINE ( if( empty( ::oAlmacenesController ), ::oAlmacenesController := AlmacenesController():New( self ), ), ::oAlmacenesController )

   METHOD getZonasController()      INLINE ( if( empty( ::oZonasController ), ::oZonasController := ZonasController():New( self ), ), ::oZonasController )

   METHOD getUbicacionesController();
                                    INLINE ( if( empty( ::oUbicacionesController ), ::oUbicacionesController := UbicacionesController():New( self ), ), ::oUbicacionesController )

   METHOD getConfiguracionesController();
                                    INLINE ( if( empty( ::oConfiguracionesController ), ::oConfiguracionesController := ConfiguracionesController():New( self ), ), ::oConfiguracionesController )

   METHOD getImprimirSeriesController();
                                    INLINE ( if( empty( ::oImprimirSeriesController ), ::oImprimirSeriesController := ImprimirSeriesController():New( self ), ), ::oImprimirSeriesController )

   METHOD getUsuariosController()   INLINE ( if( empty( ::oUsuariosController ), ::oUsuariosController := UsuariosController():New( self ), ), ::oUsuariosController )

   METHOD getEmpresasController()   INLINE ( if( empty( ::oEmpresasController ), ::oEmpresasController := EmpresasController():New( self ), ), ::oEmpresasController )

   METHOD getAjustableController()  INLINE ( if( empty( ::oAjustableController ), ::oAjustableController := AjustableController():New( self ), ), ::oAjustableController )

   METHOD getAjustableGestoolController();
                                    INLINE ( if( empty( ::oAjustableGestoolController ), ::oAjustableGestoolController := AjustableGestoolController():New( self ), ), ::oAjustableGestoolController )

   METHOD getDelegacionesController();
                                    INLINE ( if( empty( ::oDelegacionesController ), ::oDelegacionesController := DelegacionesController():New( self ), ), ::oDelegacionesController )

   METHOD getMailController()       INLINE ( if( empty( ::oMailController ), ::oMailController := MailController():New( self ), ), ::oMailController ) 

   METHOD getArticulosEnvasadoController();
                                    INLINE ( if( empty( ::oArticulosEnvasadoController ), ::oArticulosEnvasadoController := ArticulosEnvasadoController():New( self ), ), ::oArticulosEnvasadoController )

   METHOD getDivisasMonetariasController();
                                    INLINE ( if( empty( ::oDivisasMonetariasController ), ::oDivisasMonetariasController := DivisasMonetariasController():New( self ), ), ::oDivisasMonetariasController )

   METHOD getCajasController()      INLINE ( if( empty( ::oCajasController ), ::oCajasController := CajasController():New( self ), ), ::oCajasController )

   METHOD getImpresorasController() INLINE ( if( empty( ::oImpresorasController ), ::oImpresorasController := ImpresorasController():New( self ), ), ::oImpresorasController )

   METHOD getSesionesController()   INLINE ( if( empty( ::oSesionesController ), ::oSesionesController := SesionesController():New( self ), ), ::oSesionesController )

   METHOD getTiposImpresorasController();
                                    INLINE ( if( empty( ::oTiposImpresorasController ), ::oTiposImpresorasController := TiposImpresorasController():New( self ), ), ::oTiposImpresorasController )

   METHOD getDelegacionesController();
                                    INLINE ( if( empty( ::oDelegacionesController ), ::oDelegacionesController := DelegacionesController():New( self ), ), ::oDelegacionesController )

   METHOD getSituacionesController();
                                    INLINE ( if( empty( ::oSituacionesController ), ::oSituacionesController := SituacionesController():New( self ), ), ::oSituacionesController )

   METHOD getRecibosController()    INLINE ( if( empty( ::oRecibosController ), ::oRecibosController := RecibosController():New( self ), ), ::oRecibosController )

   METHOD getPermisosController()   INLINE ( if( empty( ::oPermisosController ), ::oPermisosController := PermisosController():New( self ), ), ::oPermisosController )

   METHOD getRolesController()      INLINE ( if( empty( ::oRolesController ), ::oRolesController := RolesController():New( self ), ), ::oRolesController )

   METHOD loadDocuments()

   METHOD loadTemplatesHTML()

   METHOD getDirectory()            INLINE ( Company():getPathDocuments( ::cName ) )

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD End() CLASS SQLApplicationController

   if !empty( ::oGetSelector )
      ::oGetSelector:End()
   end if 
   
   if !empty( ::oCodigosPostalesController )
      ::oCodigosPostalesController:End()
   end if 

   if !empty( ::oDireccionesController )
      ::oDireccionesController:End()
   end if    

   if !empty( ::oDireccionesTiposController )
      ::oDireccionesTiposController:End()
   end if 
   
   if !empty( ::oPaisesController )
      ::oPaisesController:End()
   end if 
   
   if !empty( ::oProvinciasController )
      ::oProvinciasController:End()
   end if 
   
   if !empty( ::oCamposExtraValoresController )
      ::oCamposExtraValoresController:End()
   end if 

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

   if !empty( ::oArticulosPreciosController )   
      ::oArticulosPreciosController:End()
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

   if !empty( ::oMetodosPagosController )   
      ::oMetodosPagosController:End()
   end if

   if !empty( ::oMediosPagoController )   
      ::oMediosPagoController:End()
   end if

   if !empty( ::oCuentasRemesaController )   
      ::oCuentasRemesaController:End()
   end if 

   if !empty( ::oRutasController )   
      ::oRutasController:End()
   end if    

   if !empty( ::oClientesController )   
      ::oClientesController:End()
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

   if !empty( ::oLenguajesController )   
      ::oLenguajesController:End()
   end if 

   if !empty( ::oTraduccionesController )   
      ::oTraduccionesController:End()
   end if 

   if !empty( ::oArticulosController )   
      ::oArticulosController:End()
   end if    

   if !empty( ::oArticulosFamiliasController )   
      ::oArticulosFamiliasController:End()
   end if 

   if !empty( ::oArticulosTipoController )   
      ::oArticulosTipoController:End()
   end if 

   if !empty( ::oArticulosCategoriasController )   
      ::oArticulosCategoriasController:End()
   end if 

   if !empty( ::oArticulosFabricantesController )   
      ::oArticulosFabricantesController:End()
   end if  

   if !empty( ::oTipoIvaController )   
      ::oTipoIvaController:End()
   end if 

   if !empty( ::oImpuestosEspecialesController )   
      ::oImpuestosEspecialesController:End()
   end if    

   if !empty( ::oUnidadesMedicionController )   
      ::oUnidadesMedicionController:End()
   end if    

   if !empty( ::oArticulosUnidadesMedicionController )   
      ::oArticulosUnidadesMedicionController:End()
   end if    

   if !empty( ::oUnidadesMedicionGruposLineasController )   
      ::oUnidadesMedicionGruposLineasController:End()
   end if    

   if !empty( ::oUnidadesMedicionGruposController )   
      ::oUnidadesMedicionGruposController:End()
   end if    

   if !empty( ::oArticulosTemporadasController )   
      ::oArticulosTemporadasController:End()
   end if    

   if !empty( ::oPropiedadesLineasController )   
      ::oPropiedadesLineasController:End()
   end if    

   if !empty( ::oPropiedadesController )   
      ::oPropiedadesController:End()
   end if    

   if !empty( ::oCombinacionesPropiedadesController )   
      ::oCombinacionesPropiedadesController:End()
   end if    

   if !empty( ::oCombinacionesController )   
      ::oCombinacionesController:End()
   end if    

   if !empty( ::oFacturasClientesDescuentosController )   
      ::oFacturasClientesDescuentosController:End()
   end if    

   if !empty( ::oDireccionTipoDocumentoController )   
      ::oDireccionTipoDocumentoController:End()
   end if    

   if !empty( ::oRelacionesEntidadesController )   
      ::oRelacionesEntidadesController:End()
   end if    

   if !empty( ::oFacturasClientesLineasController )   
      ::oFacturasClientesLineasController:End()
   end if   

   if !empty( ::oFacturasClientesController )   
      ::oFacturasClientesController:End()
   end if 

   if !empty( ::oAlmacenesController )   
      ::oAlmacenesController:End()
   end if    

   if !empty( ::oZonasController )   
      ::oZonasController:End()
   end if   

   if !empty( ::oUbicacionesController )   
      ::oUbicacionesController:End()
   end if    

   if !empty( ::oConfiguracionesController )
      ::oConfiguracionesController:End()
   end if 

   if !empty( ::oMailController )   
      ::oMailController:End()
   end if 

   if !empty( ::oImprimirSeriesController )
      ::oImprimirSeriesController:End()
   end if 

   if !empty( ::oUsuariosController )
      ::oUsuariosController:End()
   end if 

   if !empty( ::oEmpresasController )
      ::oEmpresasController:End()
   end if 

   if !empty( ::oAjustableController )
      ::oAjustableController:End()
   end if 

   if !empty( ::oAjustableGestoolController )
      ::oAjustableGestoolController:End()
   end if 

   if !empty( ::oArticulosEnvasadoController )
      ::oArticulosEnvasadoController:End()
   end if 

   if !empty( ::oDivisasMonetariasController )
      ::oDivisasMonetariasController:End()
   end if 

   if !empty( ::oCajasController )
      ::oCajasController:End()
   end if

   if !empty( ::oImpresorasController )
      ::oImpresorasController:End()
   end if 

   if !empty( ::oSesionesController )
      ::oSesionesController:End()
   end if    

   if !empty( ::oTiposImpresorasController )
      ::oTiposImpresorasController:End()
   end if   

   if !empty( ::oDelegacionesController )
      ::oDelegacionesController:End()
   end if 

   if !empty( ::oRecibosController )
      ::oRecibosController:End()
   end if   

   if !empty( ::oPermisosController )
      ::oPermisosController:End()
   end if   

   if !empty( ::oRolesController )
      ::oRolesController:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD loadDocuments() CLASS SQLApplicationController

RETURN ( Company():getDocuments( ::cName ) )

//---------------------------------------------------------------------------//

METHOD loadTemplatesHTML() CLASS SQLApplicationController

RETURN ( Company():getTemplatesHTML() )

//---------------------------------------------------------------------------//

