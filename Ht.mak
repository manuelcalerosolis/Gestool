#http://www.gnu.org/software/make/manual/make.html#Complex-Makefile

HB                   = 	\harbour_bcc582\

HBINCLUDE            = 	\harbour_bcc582\Include
FWINCLUDE            = 	\Fwh1701\Include
GTINCLUDE            = 	.\Include

HBLIB                = 	\harbour_bcc582\Lib
FWLIB                = 	\Fwh1701\lib

RESOURCE             = 	.\Resource

BORLAND              = 	\Bcc582
BORLANDLIB           = 	\Bcc582\lib

IMG2PDFLIB           = 	\Img2Pdf

TARGET 					?=	Gestool 
OBJDIR               ?= Obj1701
PPODIR				   ?= Ppo1701

SOURCEPRG            = 	.\PRG;.\PRG\MAIL;.\PRG\COMERCIO;.\PRG\MODELS;.\PRG\VIEWS;.\PRG\CONTROLLERS;.\PRG\SERVICES;.\PRG\TABLET;.\PRG\TABLET\VIEW;.\PRG\TABLET\VIEW\DOCUMENTOS;.\PRG\TABLET\VIEW\TERCEROS;.\PRG\TABLET\VIEW\DOCUMENTOS\VENTAS;.\PRG\TABLET\VIEW\DOCUMENTOS\TERCEROS;.\PRG\TABLET\UTILS;.\PRG\TABLET\PRESENTER;.\PRG\TABLET\PRESENTER\TERCEROS;.\PRG\TABLET\PRESENTER\DOCUMENTOS;.\PRG\TABLET\PRESENTER\DOCUMENTOS\VENTAS;
SOURCEC 				   =	C

EXE 					   = 	BIN\$(TARGET).exe

TARGETPRG 				= 	$(TARGET).PRG
TARGETOBJ 				= 	$(TARGET).OBJ

.path.PRG      		=	.\$(SOURCEPRG)
.path.C       			=	.\$(SOURCEC)
.path.OBJ      		=	.\$(OBJDIR)

PRG            		=    										\
Gestool.PRG              										\
SQLDatabase.PRG 													\
DialogExtend.PRG           									\
Dialog.PRG 															\
C5Lib.PRG               										\
RpreviewC3.PRG 													\
ReportC3.PRG            										\
RocolumnC3.PRG          										\
Treeitem.PRG            										\
TViewImg.PRG            										\
Printer.PRG             										\
Webbar.PRG              										\
Webmap.PRG              										\
Timaglst.PRG            										\
Tinitshell.PRG          										\
TTagEver.PRG 														\
WebBrow.PRG             										\
TMySql.PRG              										\
TComercio.PRG           										\
TComercioCustomer.PRG 											\
TComercioBudget.PRG 												\
TComercioProduct.PRG 											\
TComercioConector.PRG 											\
TComercioCategory.PRG 											\
TComercioConfig.PRG 												\
TComercioId.PRG 													\
TComercioStock.PRG 												\
TComercioTax.PRG 													\
TComercioManufacturer.PRG 										\
TComercioProperty.PRG 											\
TFTPLinux.PRG 														\
Comun.PRG               										\
AccessCode.PRG          										\
Tgraph.PRG              										\
Toleexcel.PRG           										\
Toleword.PRG            										\
Empresa.PRG             										\
Empcnf.PRG              										\
Reindexa.PRG            										\
TDataCenter.PRG         										\
D.PRG                      									\
Articulo.PRG            										\
ArtCodeBar.PRG          										\
Brwvta.PRG              										\
Client.PRG              										\
ClienteRutaNavigator.PRG   									\
TGenMail.PRG            										\
TGenMailDatabase.PRG       									\
TGenMailClientes.PRG       									\
TGenMailDatabaseFacturasClientes.PRG               	\
TGenMailDatabaseAlbaranesClientes.PRG              	\
TGenMailDatabasePedidosClientes.PRG                	\
TGenMailDatabasePresupuestosClientes.PRG           	\
TGenMailDatabaseSATClientes.PRG                    	\
TGenMailDatabasePedidosProveedor.PRG               	\
TGenMailDatabaseAlbaranesProveedor.PRG             	\
TGenMailDatabaseFacturaProveedor.PRG               	\
TGenMailDatabaseFacturaRectificativaCliente.PRG    	\
TGenMailDatabaseFacturaRectificativaProveedor.PRG  	\
TGenmailDatabaseRecibosClientes.PRG                	\
TSendMail.PRG                                      	\
TSendMailOutlook.PRG                               	\
TSendMailCDO.PRG                                   	\
TTemplatesHTML.PRG                                 	\
Tiva.PRG                                           	\
Fpago.PRG                                          	\
Pedprov.PRG                                        	\
Pedcli.PRG                                         	\
Precli.PRG                                         	\
Satcli.PRG                                         	\
Factcli.PRG                                        	\
Facant.PRG                                         	\
Facrec.PRG                                         	\
RectificativaProveedores.PRG                       	\
Cfaccli.PRG             										\
Factprv.PRG             										\
Albprov.PRG             										\
Albcli.PRG              										\
Familia.PRG             										\
Agentes.PRG             										\
Genfcli.PRG             										\
Ruta.PRG                										\
Contaplu.PRG            										\
Ritems.PRG              										\
Tdet.PRG                										\
TDetailGuid.PRG 													\
Grpvent.PRG             										\
Count.PRG               										\
Almacen.PRG             										\
Agenda.PRG              										\
Tmov.PRG                										\
Tipart.PRG              										\
Tproyecto.PRG 														\
TpvMenu.PRG 														\
TpvMenuArticulo.PRG												\
TpvMenuOrdenes.PRG 												\
TFraPub.PRG             										\
SalaVta.PRG             										\
Tvta.PRG                										\
Notas.PRG               										\
Infart.PRG              										\
Infcli.PRG              										\
Infprv.PRG              										\
Tarifa.PRG              										\
Promo.PRG               										\
Obras.PRG               										\
Contactos.PRG           										\
Avifile.PRG             										\
Tpv.PRG                 										\
Tactil.PRG              										\
Cajero.PRG              										\
Cajas.PRG               										\
Entsal.PRG              										\
Usuario.PRG             										\
Tuser.PRG               										\
Oferta.PRG              										\
Internet.PRG            										\
Intitem.PRG             										\
Backup.PRG              										\
Divisas.PRG             										\
Tips.PRG                										\
Movalm.PRG              										\
Edm.PRG                 										\
Pro.PRG                 										\
Reccli.PRG              										\
Turno.PRG               										\
Ttotturno.PRG           										\
Tblconv.PRG             										\
Regalm.PRG              										\
Rhtml.PRG               										\
Tshell.PRG              										\
SQLTshell.PRG 														\
Rfile.PRG               										\
TdprnC3.PRG             										\
Animat.PRG              										\
Tdelobs.PRG             										\
Tdeltarifasclientes.PRG 										\
Grpcli.PRG              										\
Atipicas.PRG 														\
Grpfacauto.PRG 													\
Recprv.PRG              										\
Tinfgen.PRG             										\
TNewInfGen.PRG          										\
TFastReportInfGen.PRG   										\
TFastVentasArticulos.PRG										\
TFastVentasClientes.PRG 										\
TFastComprasProveedores.PRG 									\
TFastProduccion.PRG 												\
TFastreportOptions.PRG 											\
Titemgroup.PRG          										\
Ttikstka.PRG            										\
TStockMinimoFamilia.PRG 										\
Xvalalmg.PRG            										\
Tcobage.PRG             										\
Remcli.PRG              										\
Label.PRG               										\
Litem.PRG               										\
Tloitem.PRG             										\
Pdlabel.PRG             										\
Tinfcols.PRG            										\
Tbuscar.PRG             										\
Tmant.PRG               										\
TFiltercreator.PRG 												\
Tarray.PRG              										\
Webbtn.PRG              										\
Errorsys.PRG            										\
Tmessage.PRG            										\
Taccesos.PRG            										\
TItemacceso.PRG         										\
Tdbfserv.PRG            										\
Tpanelex.PRG              										\
Pais.PRG                										\
Provincias.PRG             									\
CodigosPostales.PRG        									\
Bandera.PRG             										\
Tvisor.PRG              										\
Tgrpfam.PRG             										\
Tdiacli.PRG             										\
Tdiprvfa.PRG            										\
Tcomvta.PRG             										\
Ctarem.PRG              										\
Tmasdet.PRG             										\
TMasterDetailGuid.PRG 											\
Newimp.PRG              										\
Tcajon.PRG              										\
Impfactu.PRG            										\
Impfaccom.PRG           										\
InfoArticulo.PRG        										\
TAuditor.PRG            										\
Ttvitem.PRG             										\
Tur2ses.PRG             										\
Ordcar.PRG              										\
Ttrans.PRG              										\
TCaptura.PRG            										\
TDetCaptura.PRG         										\
Tiordcar.PRG            													\
TICobAge.PRG            													\
TiRemMov.PRG            													\
Tchgtar.PRG             													\
Tchgdia.PRG             													\
Tdbf.PRG                													\
Tfilter.PRG             													\
Tdbarray.PRG            													\
Tfield.PRG              													\
Tutil.PRG               													\
Tidxutil.PRG            													\
Tindex.PRG              													\
Stock.PRG               													\
Xbrowse.PRG                												\
IXbrowse.PRG            													\
SQLXbrowse.PRG            													\
Autoseek.PRG            													\
Cccheck.PRG             													\
Digit.PRG               													\
Dlgtools.PRG            													\
Toolbar.PRG             													\
Medicon.PRG             													\
Utildbf.PRG             													\
Remmov.PRG              													\
TDetMovimientosAlmacen.PRG								   				\
TDetSeriesMovimientos.PRG 													\
Dummy.PRG               													\
Rccs.PRG                													\
Ttarage.PRG             													\
Tdbaux.PRG              													\
Tiremage.PRG            													\
Tchgcode.PRG            													\
Tgethlp.PRG             													\
Tget.PRG                   												\
Ean.PRG                 													\
TInfseanum.PRG          													\
TInftrazarlote.PRG      													\
Tseanum.PRG             													\
Siges.PRG               													\
Trazalote.PRG           													\
Trazadocumento.PRG      													\
Pdreport.PRG            													\
RcolumnC3.PRG           													\
TInfAlm.PRG             													\
TInfGrp.PRG             													\
TInfFam.PRG             													\
TLstFam.PRG             													\
TInfTip.PRG             													\
TRenAAlb.PRG            													\
TRenFPre.PRG            													\
TInfPArt.PRG            													\
TInfCli.PRG             													\
TInfPAge.PRG            													\
TPrvAlm.PRG             													\
TPrvGrp.PRG             													\
TPrvFam.PRG             													\
TPrvTip.PRG             													\
TPrvArt.PRG             													\
TInfPrv.PRG             													\
OAnuBCom.PRG            													\
OAnuBPed.PRG            													\
OAnuBAlb.PRG            													\
OAnuBFac.PRG            													\
TPrvPgo.PRG             													\
TInfPgo.PRG             													\
TInfRut.PRG             													\
TInfGCli.PRG            													\
TdAgeAlb.PRG            													\
TInfTrn.PRG             													\
TInfUsr.PRG             													\
TInfLArt.PRG            													\
BrwCli.PRG              													\
TInfLCli.PRG            													\
BrwPrv.PRG              													\
TInfLPrv.PRG            													\
Tinfofr.PRG             													\
Catalogo.PRG            													\
Ubicacion.PRG           													\
TInfListInci.PRG        													\
TTarCli.PRG             													\
InfAge.PRG              													\
InfAlm.PRG              													\
InfMovAlm.PRG           													\
InfUbi.PRG              													\
InfRut.PRG              													\
InfPro.PRG              													\
InfTar.PRG              													\
InfCnv.PRG              													\
InfTipIva.PRG           													\
InfDiv.PRG              													\
InfFpg.PRG              													\
InfCaj.PRG              													\
TInfChgCBr.PRG          													\
InfPrePrv.PRG           													\
IMovAlm.PRG             													\
ListUsr.PRG             													\
IEntSal.PRG             													\
ListRem.PRG             													\
IGrpVen.PRG             													\
InfPreCli.PRG           													\
TInfAtp.PRG             													\
ConfVisor.PRG           													\
ConfCajPorta.PRG        													\
ConfImpTiket.PRG        													\
Situaciones.PRG         													\
SituacionesModel.PRG       												\
SituacionesController.PRG       											\
MovimientosAlmacenView.PRG													\
MovimientosAlmacenController.PRG 										\
MovimientosAlmacenModel.PRG 												\
AlmacenesModel.PRG 															\
GruposMovimientosModel.PRG 												\
ControllerContainer.PRG 													\
GrpPrv.PRG              													\
InfCategoria.PRG        													\
Temporada.PRG           													\
InfTemporada.PRG        													\
InfNotas.PRG            													\
ImpEstudioes.PRG        													\
Seccion.PRG             													\
Horas.PRG               													\
Operarios.PRG           													\
TDetHoras.PRG           													\
Operaci.PRG             													\
TipOpera.PRG            													\
Costes.PRG              													\
Maquina.PRG             													\
TDetCostes.PRG          													\
Producc.PRG             													\
Expediente.PRG          													\
EInfDiaExpediente.PRG   													\
TipoExpediente.PRG      													\
TDetTipoExpediente.PRG  													\
TDetHorasPersonal.PRG   													\
TDetProduccion.PRG      													\
TDetMaterial.PRG        													\
TDetPersonal.PRG        													\
TDetMaquina.PRG         													\
ReportGallery.PRG       													\
PInfMateriales.PRG      													\
UnidadMedicion.PRG      													\
ActualizaCosto.PRG      													\
ImpBellerin.PRG         													\
TSalon.PRG              													\
FastRepH.PRG            													\
Bancos.PRG              													\
TInvitacion.PRG         													\
Entidades.PRG           													\
Colaboradores.PRG       													\
Actuaciones.PRG         													\
TDetActuacion.PRG       													\
TDetOrdCar.PRG          													\
Fabricantes.PRG         													\
ExportaTarifas.PRG      													\
TComentarios.PRG        													\
TDetComentarios.PRG     													\
OrdenComanda.PRG 																\
Fideliza.PRG            													\
TDetFideliza.PRG        													\
PlantillaXML.PRG        													\
EInfDiaTActuaciones.PRG 													\
FacAuto.PRG             													\
TDetFacAutomatica.PRG   													\
TComandas.PRG           													\
THisFacAutomatica.PRG   													\
ConversionDocumentos.PRG            									\
BrowseLineConversionDocumentos.PRG     								\
ConversionPedidosProveedores.PRG    									\
ConversionPedidosClientes.PRG    										\
GeneracionAlbaranesClientes.PRG     									\
TFacturaElectronica.PRG 													\
CobAge.PRG              													\
Carpeta.PRG             													\
Dotnetba.PRG            													\
Dotnetbu.PRG            													\
Dotnetco.PRG            													\
Dotnetgr.PRG            													\
ExportaCompras.PRG      													\
SincronizaPreventa.PRG  													\
MsTable.PRG             													\
MsError.PRG 																	\
SQLBaseView.PRG 																\
TiposImpresoras.PRG       													\
TiposNotas.PRG       														\
Etiquetas.PRG       															\
TiposVentas.PRG       														\
Propiedades.PRG       														\
PropiedadesLineas.PRG       												\
PageIni.PRG             													\
TpvTactil.PRG           													\
TpvUtilidadesMesa.PRG 														\
TpvCobros.PRG           													\
TpvListaTicket.PRG      													\
TpvRestaurante.PRG      													\
TpvPunto.PRG            													\
TpvMesa.PRG             													\
TpvSalon.PRG            													\
TScripts.PRG            													\
Cuaderno.PRG 																	\
SepaXml.PRG                            								\
FacturarLineasAlbaranes.PRG 												\
Components.PRG 				            								\
TLabelGenerator.PRG                    								\
TTreevie.PRG            	            								\
ApoloMeter.PRG 				            								\
TGridSay.PRG 					            								\
FacturarLineasAlbaranesProveedor.PRG   								\
Editable.PRG                           								\
ViewNavigator.PRG                      								\
Documents.PRG                          								\
DocumentLines.PRG                      								\
DocumentBase.PRG                       								\
DocumentHeader.PRG                     								\
DocumentLine.PRG                       								\
Customer.PRG                           								\
OrderCustomer.PRG                      								\
Iva.PRG                                								\
TotalDocument.PRG                      								\
DeliveryNoteCustomer.PRG               								\
InvoiceCustomer.PRG                    								\
DocumentsSales.PRG                     								\
DailySummarySales.PRG                  								\
DailySummarySalesView.PRG              								\
ViewBase.PRG                           								\
ViewEdit.PRG                           								\
CustomerView.PRG                       								\
ViewEditDetail.PRG                     								\
ViewEditResumen.PRG                    								\
LinesDocumentsSales.PRG                								\
LinesOrderCustomer.PRG                 								\
LinesDeliveryNoteCustomer.PRG          								\
LinesInvoiceCustomer.PRG               								\
ViewSearchNavigator.PRG                								\
Product.PRG                            								\
Payment.PRG                            								\
Store.PRG                              								\
DocumentSalesViewSearchNavigator.PRG   								\
ReceiptDocumentSalesViewSearchNavigator.PRG  						\
CustomerSalesViewSearchNavigator.PRG   								\
CustomerViewSearchNavigator.PRG        								\
ProductViewSearchNavigator.PRG         								\
PaymentViewSearchNavigator.PRG         								\
CustomerIncidenceViewNavigator.PRG     								\
StoreViewSearchNavigator.PRG           								\
DocumentSalesViewEdit.PRG              								\
ReceiptDocumentSalesViewEdit.PRG       								\
InvoiceDocumentSalesViewEdit.PRG                   				\
GeneraFacturasClientes.PRG             								\
CamposExtra.PRG                        								\
DetCamposExtra.PRG                     								\
Lenguajes.PRG                          								\
CentroCoste.PRG                        								\
Autoget.PRG                            								\
EstadoSat.PRG                          								\
TSpecialSearchArticulo.PRG             								\
TSpecialInfoArticulo.PRG               								\
TSpecialInfoCliente.PRG                								\
PedCli2PedPrv.PRG                      								\
Directions.PRG                         								\
DirectionsViewSearchNavigator.PRG      								\
ReceiptInvoiceCustomer.PRG             								\
liquidateReceiptView.PRG                           				\
liquidateReceipt.PRG                               				\
TTraslations.PRG 																\
ProductStock.PRG                                   				\
StockViewNavigator.PRG                             				\
Reporting.PRG                                      				\
ViewReporting.PRG                                  				\
backupPresenter.PRG                                				\
backupView.PRG                                     				\
ReindexaPresenter.PRG                                 			\
ReindexaView.PRG                                      			\
BaseModel.PRG 																	\
SQLBaseModel.PRG 																\
SQLBaseEmpresasModel.PRG 													\
SQLBaseController.PRG 														\
SQLBaseController.PRG 														\
SQLHeaderController.PRG 													\
SQLBaseLineasModel.PRG 														\
ClientesModel.PRG 															\
AlbaranesClientesModel.PRG 												\
FacturasClientesModel.PRG 													\
RecibosClientesModel.PRG 													\
TicketsClientesModel.PRG 													\
PedidosProveedoresModel.PRG												\
TiposImpresorasModel.PRG 													\
TiposImpresorasController.PRG 											\
TiposNotasModel.PRG 															\
TiposNotasController.PRG 													\
EtiquetasModel.PRG 															\
EtiquetasController.PRG 													\
TiposVentasModel.PRG 														\
TiposVentasController.PRG 													\
RelacionesEtiquetasModel.PRG 												\
ArticulosModel.PRG                                    			\
ColumnasUsuariosModel.PRG 													\
HistoricosUsuariosModel.PRG                           			\
PedidosClientesLineasModel.PRG 											\
EmpresasModel.PRG 															\
ClientesModel.PRG 															\
AlbaranesClientesModel.PRG 												\
FacturasClientesModel.PRG 													\
RecibosClientesModel.PRG 													\
TicketsClientesModel.PRG 													\
PedidosProveedoresModel.PRG												\
TiposImpresorasModel.PRG 													\
TiposImpresorasController.PRG 											\
TiposNotasModel.PRG 															\
TiposNotasController.PRG 													\
EtiquetasModel.PRG 															\
EtiquetasController.PRG 													\
ConfiguracionEmpresasModel.PRG 											\
TiposVentasModel.PRG 														\
TiposVentasController.PRG 													\
PropiedadesModel.PRG       								   			\
PropiedadesController.PRG       											\
PropiedadesLineasModel.PRG       										\
PropiedadesLineasController.PRG       									\
RelacionesEtiquetasModel.PRG 												\
HistoricosUsuariosModel.PRG                           			\
PedidosClientesLineasModel.PRG 											\

C               =       	            								\
Img2pdf.C              	            									\
Treeview.C 					               								\

OBJ				= $(PRG:.PRG=.OBJ)
OBJS				= $(OBJ:.\=.\$(OBJDIR)\)

.PRG.OBJ:
  	$(HB)\Bin\Harbour $? /n /p$(PPODIR)\$&.ppo /w /es2 /i$(FWINCLUDE) /gc0 /i$(HBINCLUDE) /i$(GTINCLUDE) /o$(OBJDIR)\$&.c
  	$(BORLAND)\Bin\Bcc32 -c -tWM -I$(HBINCLUDE) -o$(OBJDIR)\$& $(OBJDIR)\$&.c

$(EXE)                  : $( PRG:.PRG=.OBJ )

.C.OBJ:
  	$(BORLAND)\Bin\Bcc32 -c -tWM -DHB_API_MACROS -I$(HBINCLUDE);$(FWINCLUDE) -o$(OBJDIR)\$& $<

$(EXE)                  : $( C:.C=.OBJ )

$(EXE) : $(RESOURCE)\GstDialog.Res $(OBJS)
   echo off
   echo $(BORLANDLIB)\c0w32.obj + > b32.bc
	echo $(OBJS), + >> b32.bc
   echo $<, + >> b32.bc
   echo $*, + >> b32.bc


