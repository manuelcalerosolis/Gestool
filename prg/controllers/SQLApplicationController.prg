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

   DATA oArticulosPreciosTarifasController

   DATA oArticulosPreciosDescuentosController

   DATA oCuentasBancariasController
   DATA oCuentasBancariasGestoolController

   DATA oDocumentosController

   DATA oFormasPagosController

   DATA oMetodosPagosController

   DATA oMediosPagoController

   DATA oCuentasRemesaController

   DATA oRutasController

   DATA oTercerosController

   DATA oTercerosGruposController

   DATA oContactosController

   DATA oIncidenciasController

   DATA oDescuentosController

   DATA oTercerosEntidadesController

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

   DATA oFacturasVentasDescuentosController

   DATA oPresupuestosVentasDescuentosController

   DATA oPedidosVentasDescuentosController

   DATA oFacturasComprasDescuentosController

   DATA oPedidosComprasDescuentosController

   DATA oPresupuestosComprasDescuentosController

   DATA oDireccionTipoDocumentoController

   DATA oRelacionesEntidadesController

   DATA oFacturasVentasLineasController

   DATA oPedidosVentasLineasController

   DATA oFacturasVentasRectificativasLineasController

   DATA oFacturasVentasRectificativasDescuentosController

   DATA oFacturasComprasLineasController

   DATA oPedidosComprasLineasController

   DATA oPresupuestosComprasLineasController

   DATA oPresupuestosVentasLineasController

   DATA oFacturasComprasRectificativasLineasController

   DATA oFacturasComprasRectificativasDescuentosController

   DATA oFacturasVentasController

   DATA oPresupuestosVentasController

   DATA oFacturasComprasController

   DATA oPresupuestosComprasController

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

   DATA oRecibosGeneratorController

   DATA oPagosController

   DATA oPagosAssistantController 

   DATA oRecibosPagosController 

   DATA oRecibosPagosTemporalController 
   
   DATA oPermisosController 
   
   DATA oRolesController 

   DATA oCaracteristicasController

   DATA oCaracteristicasLineasController

   DATA oCaracteristicasValoresArticulosController

   DATA oConsolidacionAlmacenLineasController

   DATA oMovimientoAlmacenLineasController

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

   METHOD getArticulosPreciosTarifasController();
                                    INLINE ( if( empty( ::oArticulosPreciosTarifasController ), ::oArticulosPreciosTarifasController := ArticulosPreciosTarifasController():New( self ), ), ::oArticulosPreciosTarifasController )

   METHOD getCuentasBancariasController();
                                    INLINE ( if( empty( ::oCuentasBancariasController ), ::oCuentasBancariasController := CuentasBancariasController():New( self ), ), ::oCuentasBancariasController )

   METHOD getCuentasBancariasGestoolController();
                                    INLINE ( if( empty( ::oCuentasBancariasGestoolController ), ::oCuentasBancariasGestoolController := CuentasBancariasGestoolController():New( self ), ), ::oCuentasBancariasGestoolController )

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

   METHOD getTercerosController();
                                    INLINE ( if( empty( ::oTercerosController ), ::oTercerosController := TercerosController():New( self ), ), ::oTercerosController )

   METHOD getTercerosGruposController();
                                    INLINE ( if( empty( ::oTercerosGruposController ), ::oTercerosGruposController := TercerosGruposController():New( self ), ), ::oTercerosGruposController )

   METHOD getContactosController();
                                    INLINE ( if( empty( ::oContactosController ), ::oContactosController := ContactosController():New( self ), ), ::oContactosController )

   METHOD getIncidenciasController();
                                    INLINE ( if( empty( ::oIncidenciasController ), ::oIncidenciasController := IncidenciasController():New( self ), ), ::oIncidenciasController )

   METHOD getDescuentosController();
                                    INLINE ( if( empty( ::oDescuentosController ), ::oDescuentosController := DescuentosController():New( self ), ), ::oDescuentosController )

   METHOD getTercerosEntidadesController();
                                    INLINE ( if( empty( ::oTercerosEntidadesController ), ::oTercerosEntidadesController := TercerosEntidadesController():New( self ), ), ::oTercerosEntidadesController )

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

   METHOD getFacturasVentasDescuentosController();
                                    INLINE ( if( empty( ::oFacturasVentasDescuentosController ), ::oFacturasVentasDescuentosController := FacturasVentasDescuentosController():New( self ), ), ::oFacturasVentasDescuentosController )

   METHOD getPresupuestosVentasDescuentosController();
                                    INLINE ( if( empty( ::oPresupuestosVentasDescuentosController ), ::oPresupuestosVentasDescuentosController := PresupuestosVentasDescuentosController():New( self ), ), ::oPresupuestosVentasDescuentosController )

   METHOD getPedidosVentasDescuentosController();
                                    INLINE ( if( empty( ::oPedidosVentasDescuentosController ), ::oPedidosVentasDescuentosController := PedidosVentasDescuentosController():New( self ), ), ::oPedidosVentasDescuentosController )

   METHOD getFacturasComprasDescuentosController();
                                    INLINE ( if( empty( ::oFacturasComprasDescuentosController ), ::oFacturasComprasDescuentosController := FacturasComprasDescuentosController():New( self ), ), ::oFacturasComprasDescuentosController )

   METHOD getPedidosComprasDescuentosController();
                                    INLINE ( if( empty( ::oPedidosComprasDescuentosController ), ::oPedidosComprasDescuentosController := PedidosComprasDescuentosController():New( self ), ), ::oPedidosComprasDescuentosController )

   METHOD getPresupuestosComprasDescuentosController();
                                    INLINE ( if( empty( ::oPresupuestosComprasDescuentosController ), ::oPresupuestosComprasDescuentosController := PresupuestosComprasDescuentosController():New( self ), ), ::oPresupuestosComprasDescuentosController )

   METHOD getDireccionTipoDocumentoController();
                                    INLINE ( if( empty( ::oDireccionTipoDocumentoController ), ::oDireccionTipoDocumentoController := DireccionTipoDocumentoController():New( self ), ), ::oDireccionTipoDocumentoController )

   METHOD getRelacionesEntidadesController();
                                    INLINE ( if( empty( ::oRelacionesEntidadesController ), ::oRelacionesEntidadesController := RelacionesEntidadesController():New( self ), ), ::oRelacionesEntidadesController )

   METHOD getFacturasVentasLineasController();
                                    INLINE ( if( empty( ::oFacturasVentasLineasController ), ::oFacturasVentasLineasController := FacturasVentasLineasController():New( self ), ), ::oFacturasVentasLineasController )

   METHOD getPedidosVentasLineasController();
                                    INLINE ( if( empty( ::oPedidosVentasLineasController ), ::oPedidosVentasLineasController := PedidosVentasLineasController():New( self ), ), ::oPedidosVentasLineasController )

   METHOD getConsolidacionAlmacenLineasController();
                                    INLINE ( if( empty( ::oConsolidacionAlmacenLineasController ), ::oConsolidacionAlmacenLineasController := ConsolidacionAlmacenLineasController():New( self ), ), ::oConsolidacionAlmacenLineasController )
   
   METHOD getMovimientoAlmacenLineasController();
                                    INLINE ( if( empty( ::oMovimientoAlmacenLineasController ), ::oMovimientoAlmacenLineasController := MovimientoAlmacenLineasController():New( self ), ), ::oMovimientoAlmacenLineasController )

   METHOD getFacturasVentasRectificativasLineasController(); 
                                    INLINE ( if( empty( ::oFacturasVentasRectificativasLineasController ), ::oFacturasVentasRectificativasLineasController := FacturasVentasRectificativasLineasController():New( self ), ), ::oFacturasVentasRectificativasLineasController )

   METHOD getFacturasVentasRectificativasDescuentosController();
                                    INLINE ( if( empty( ::oFacturasVentasRectificativasDescuentosController ), ::oFacturasVentasRectificativasDescuentosController := FacturasVentasRectificativasDescuentosController():New( self ), ), ::oFacturasVentasRectificativasDescuentosController )

   METHOD getFacturasComprasLineasController();
                                    INLINE ( if( empty( ::oFacturasComprasLineasController ), ::oFacturasComprasLineasController := FacturasComprasLineasController():New( self ), ), ::oFacturasComprasLineasController )

   METHOD getPedidosComprasLineasController();
                                    INLINE ( if( empty( ::oPedidosComprasLineasController ), ::oPedidosComprasLineasController := PedidosComprasLineasController():New( self ), ), ::oPedidosComprasLineasController )

   METHOD getPresupuestosComprasLineasController();
                                    INLINE ( if( empty( ::oPresupuestosComprasLineasController ), ::oPresupuestosComprasLineasController := PresupuestosComprasLineasController():New( self ), ), ::oPresupuestosComprasLineasController )

   METHOD getPresupuestosVentasLineasController();
                                    INLINE ( if( empty( ::oPresupuestosVentasLineasController ), ::oPresupuestosVentasLineasController := PresupuestosVentasLineasController():New( self ), ), ::oPresupuestosVentasLineasController )

   METHOD getFacturasComprasRectificativasLineasController();
                                    INLINE ( if( empty( ::oFacturasComprasRectificativasLineasController ), ::oFacturasComprasRectificativasLineasController := FacturasComprasRectificativasLineasController():New( self ), ), ::oFacturasComprasRectificativasLineasController )

   METHOD getFacturasComprasRectificativasDescuentosController();
                                    INLINE ( if( empty( ::oFacturasComprasRectificativasDescuentosController ), ::oFacturasComprasRectificativasDescuentosController := FacturasComprasRectificativasDescuentosController():New( self ), ), ::oFacturasComprasRectificativasDescuentosController )

   METHOD getFacturasVentasController();
                                    INLINE ( if( empty( ::oFacturasVentasController ), ::oFacturasVentasController := FacturasVentasController():New( self ), ), ::oFacturasVentasController ) 

   METHOD getPresupuestosVentasController();
                                    INLINE ( if( empty( ::oPresupuestosVentasController ), ::oPresupuestosVentasController := PresupuestosVentasController():New( self ), ), ::oPresupuestosVentasController ) 

   METHOD getFacturasComprasController();
                                    INLINE ( if( empty( ::oFacturasComprasController ), ::oFacturasComprasController := FacturasComprasController():New( self ), ), ::oFacturasComprasController )

   METHOD getFacturasComprasController();
                                    INLINE ( if( empty( ::oPresupuestosComprasController ), ::oPresupuestosComprasController := PresupuestosComprasController():New( self ), ), ::oPresupuestosComprasController )

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

   METHOD getSituacionesController();
                                    INLINE ( if( empty( ::oSituacionesController ), ::oSituacionesController := SituacionesController():New( self ), ), ::oSituacionesController )

   METHOD getRecibosController()    INLINE ( if( empty( ::oRecibosController ), ::oRecibosController := RecibosController():New( self ), ), ::oRecibosController ) 

   METHOD getRecibosGeneratorController() ;
                                    INLINE ( if( empty( ::oRecibosGeneratorController ), ::oRecibosGeneratorController := RecibosGeneratorController():New( self ), ), ::oRecibosGeneratorController )

   METHOD getPagosController()      INLINE ( if( empty( ::oPagosController ), ::oPagosController := PagosController():New( self ), ), ::oPagosController )
   
   METHOD getPagosAssistantController() ;
                                    INLINE ( if( empty( ::oPagosAssistantController ), ::oPagosAssistantController := PagosAssistantController():New( self ), ), ::oPagosAssistantController )
   
   METHOD getRecibosPagosController() ;
                                    INLINE ( if( empty( ::oRecibosPagosController ), ::oRecibosPagosController := RecibosPagosController():New( self ), ), ::oRecibosPagosController )

   METHOD getRecibosPagosTemporalController() ;
                                    INLINE ( if( empty( ::oRecibosPagosTemporalController ), ::oRecibosPagosTemporalController := RecibosPagosTemporalController():New( self ), ), ::oRecibosPagosTemporalController )

   METHOD getPermisosController()   INLINE ( if( empty( ::oPermisosController ), ::oPermisosController := PermisosController():New( self ), ), ::oPermisosController )

   METHOD getRolesController()      INLINE ( if( empty( ::oRolesController ), ::oRolesController := RolesController():New( self ), ), ::oRolesController )

   METHOD getCaracteristicasController();
                                    INLINE ( if( empty( ::oCaracteristicasController ), ::oCaracteristicasController := CaracteristicasController():New( self ), ), ::oCaracteristicasController ) 
   METHOD getCaracteristicasLineasController();
                                    INLINE ( if( empty( ::oCaracteristicasLineasController ), ::oCaracteristicasLineasController := CaracteristicasLineasController():New( self ), ), ::oCaracteristicasLineasController )

   METHOD getCaracteristicasValoresArticulosController();
                                    INLINE ( if( empty( ::oCaracteristicasValoresArticulosController ), ::oCaracteristicasValoresArticulosController := CaracteristicasValoresArticulosController():New( self ), ), ::oCaracteristicasValoresArticulosController )

   METHOD getDelegacionesController();
                                    INLINE ( if( empty( ::oDelegacionesController ), ::oDelegacionesController := DelegacionesController():New( self ), ), ::oDelegacionesController )

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

   if !empty( ::oArticulosPreciosTarifasController )   
      ::oArticulosPreciosTarifasController:End()
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

   if !empty( ::oTercerosController )   
      ::oTercerosController:End()
   end if

  if !empty( ::oTercerosGruposController )   
      ::oTercerosGruposController:End()
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

   if !empty( ::oTercerosEntidadesController )   
      ::oTercerosEntidadesController:End()
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

   if !empty( ::oFacturasVentasDescuentosController )   
      ::oFacturasVentasDescuentosController:End()
   end if  

   if !empty( ::oPresupuestosVentasDescuentosController )   
      ::oPresupuestosVentasDescuentosController:End()
   end if  

   if !empty( ::oPedidosVentasDescuentosController )   
      ::oPedidosVentasDescuentosController:End()
   end if  

   if !empty( ::oFacturasComprasDescuentosController )   
      ::oFacturasComprasDescuentosController:End()
   end if 

   if !empty( ::oPedidosComprasDescuentosController )   
      ::oPedidosComprasDescuentosController:End()
   end if    

   if !empty( ::oPresupuestosComprasDescuentosController )   
      ::oPresupuestosComprasDescuentosController:End()
   end if    

   if !empty( ::oDireccionTipoDocumentoController )   
      ::oDireccionTipoDocumentoController:End()
   end if    

   if !empty( ::oRelacionesEntidadesController )   
      ::oRelacionesEntidadesController:End()
   end if    

   if !empty( ::oConsolidacionAlmacenLineasController )   
      ::oConsolidacionAlmacenLineasController:End()
   end if

   if !empty( ::oMovimientoAlmacenLineasController )   
      ::oMovimientoAlmacenLineasController:End()
   end if

   if !empty( ::oFacturasVentasLineasController )   
      ::oFacturasVentasLineasController:End()
   end if

   if !empty( ::oPedidosVentasLineasController )   
      ::oPedidosVentasLineasController:End()
   end if

   if !empty( ::oFacturasVentasRectificativasLineasController )   
      ::oFacturasVentasRectificativasLineasController:End()
   end if

   if !empty( ::oFacturasVentasRectificativasDescuentosController )   
      ::oFacturasVentasRectificativasDescuentosController:End()
   end if

   if !empty( ::oFacturasComprasLineasController )   
      ::oFacturasComprasLineasController:End()
   end if

   if !empty( ::oPedidosComprasLineasController )   
      ::oPedidosComprasLineasController:End()
   end if

   if !empty( ::oPresupuestosComprasLineasController )   
      ::oPresupuestosComprasLineasController:End()
   end if

   if !empty( ::oPresupuestosVentasLineasController )   
      ::oPresupuestosVentasLineasController:End()
   end if

   if !empty( ::oFacturasComprasRectificativasLineasController )   
      ::oFacturasComprasRectificativasLineasController:End()
   end if   

   if !empty( ::oFacturasComprasRectificativasDescuentosController )   
      ::oFacturasComprasRectificativasDescuentosController:End()
   end if   

   if !empty( ::oFacturasVentasController )   
      ::oFacturasVentasController:End()
   end if

   if !empty( ::oPresupuestosVentasController )   
      ::oPresupuestosVentasController:End()
   end if

   if !empty( ::oFacturasComprasController )   
      ::oFacturasComprasController:End()
   end if 

   if !empty( ::oPresupuestosComprasController )   
      ::oPresupuestosComprasController:End()
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

   if !empty( ::oRecibosPagosController )
      ::oRecibosPagosController:End()
   end if 
   if !empty( ::oRecibosPagosTemporalController )
      ::oRecibosPagosTemporalController:End()
   end if  

   if !empty( ::oRecibosGeneratorController )
      ::oRecibosGeneratorController:End()
   end if

   if !empty( ::oPagosController )
      ::oPagosController:End()
   end if    

   if !empty( ::oPagosAssistantController )
      ::oPagosAssistantController:End()
   end if   

   if !empty( ::oPermisosController )
      ::oPermisosController:End()
   end if   

   if !empty( ::oRolesController )
      ::oRolesController:End()
   end if

   if !empty( ::oCaracteristicasController )
      ::oCaracteristicasController:End()
   end if

   if !empty( ::oCaracteristicasLineasController )
      ::oCaracteristicasLineasController:End()
   end if

   if !empty( ::oCaracteristicasValoresArticulosController )
      ::oCaracteristicasValoresArticulosController:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD loadDocuments() CLASS SQLApplicationController

RETURN ( Company():getDocuments( ::cName ) )

//---------------------------------------------------------------------------//

METHOD loadTemplatesHTML() CLASS SQLApplicationController

RETURN ( Company():getTemplatesHTML() )

//---------------------------------------------------------------------------//

