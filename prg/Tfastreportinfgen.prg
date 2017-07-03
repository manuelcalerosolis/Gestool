#include "FiveWin.Ch" 
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"
#include "FastRepH.ch"
#include "HbXml.ch"

//---------------------------------------------------------------------------// 

CLASS TFastReportInfGen FROM TNewInfGen

   DATA  cDriver

   DATA  nView

   DATA  aInitGroup

   DATA  oPages

   DATA  oBrwRango

   DATA  oOfficeBar

   DATA  nDias

   DATA  hReport 
   DATA  hOptions

   DATA  aliasPedidosClientes
   DATA  aliasPedidosClientesLineas

   DATA  nUnidadesTiempo                        INIT 1
   DATA  oUnidadesTiempo
   DATA  cUnidadesTiempo                        INIT "Semana(s)"
   DATA  aUnidadesTiempo                        INIT { "Dia(s)", "Semana(s)", "Mes(es)", "Año(s)" }

   DATA  oTreeReporting
   DATA  oTreeImageList

   DATA  oColDesde
   DATA  oColHasta

   DATA  lPersonalizado                         INIT .f.
   DATA  lSummary                               INIT .f.

   DATA  oDbfPersonalizado

   DATA  oReportTree
   DATA  cReportType                            INIT ""
   DATA  cReportName                            INIT ""
   DATA  cReportFile                            INIT ""
   DATA  cReportDirectory                       INIT ""
   DATA  hReportOptions 

   DATA  lUserDefine                            INIT .f.

   DATA  oBtnPrevisualizar
   DATA  oBtnImprimir
   DATA  oBtnExcel
   DATA  oBtnPdf
   DATA  oBtnHTML

   DATA  oBtnDiseno
   DATA  oBtnEliminar
   DATA  oBtnFiltrar

   DATA  cInformeFastReport

   DATA  oExt

   DATA  nTotalRemesasAgentes                   INIT 0

   DATA  nBaseSatClientes                       INIT 0
   DATA  nIVASatClientes                        INIT 0
   DATA  nRecargoSatClientes                    INIT 0
   DATA  nTotalSatClientes                      INIT 0

   DATA  nBasePresupuestosClientes              INIT 0
   DATA  nIVAPresupuestosClientes               INIT 0
   DATA  nRecargoPresupuestosClientes           INIT 0
   DATA  nTotalPresupuestosClientes             INIT 0

   DATA  nBasePedidosClientes                   INIT 0
   DATA  nIVAPedidosClientes                    INIT 0
   DATA  nRecargoPedidosClientes                INIT 0
   DATA  nTotalPedidosClientes                  INIT 0

   DATA  nBaseAlbaranesClientes                 INIT 0
   DATA  nIVAAlbaranesClientes                  INIT 0
   DATA  nRecargoAlbaranesClientes              INIT 0
   DATA  nTotalAlbaranesClientes                INIT 0

   DATA  nBaseFacturasClientes                  INIT 0
   DATA  nIVAFacturasClientes                   INIT 0
   DATA  nRecargoFacturasClientes               INIT 0
   DATA  nTotalFacturasClientes                 INIT 0

   DATA  nBaseFacturasRectificativasClientes    INIT 0
   DATA  nIVAFacturasRectificativasClientes     INIT 0
   DATA  nRecargoFacturasRectificativasClientes INIT 0
   DATA  nTotalFacturasRectificativasClientes   INIT 0

   DATA  nBaseTicketsClientes                   INIT 0
   DATA  nIVATicketsClientes                    INIT 0
   DATA  nRecargoTicketsClientes                INIT 0
   DATA  nTotalTicketsClientes                  INIT 0

   DATA  nTotalPagosClientes                    INIT 0
   DATA  nTotalPendientesClientes               INIT 0

   DATA  nBasePedidosProveedores                INIT 0
   DATA  nIVAPedidosProveedores                 INIT 0
   DATA  nRecargoPedidosProveedores             INIT 0
   DATA  nTotalPedidosProveedores               INIT 0

   DATA  nBaseAlbaranesProveedores              INIT 0
   DATA  nIVAAlbaranesProveedores               INIT 0
   DATA  nRecargoAlbaranesProveedores           INIT 0
   DATA  nTotalAlbaranesProveedores             INIT 0

   DATA  nBaseFacturasProveedores               INIT 0
   DATA  nIVAFacturasProveedores                INIT 0
   DATA  nRecargoFacturasProveedores            INIT 0
   DATA  nTotalFacturasProveedores              INIT 0
         
   DATA  nBaseFacturasRectificativasProveedores    INIT 0
   DATA  nIVAFacturasRectificativasProveedores     INIT 0
   DATA  nRecargoFacturasRectificativasProveedores INIT 0
   DATA  nTotalFacturasRectificativasProveedores   INIT 0

   DATA  aChildDesdeGrupoCliente                   INIT {}
   DATA  aChildHastaGrupoCliente                   INIT {}

   DATA lTabletVersion                           INIT .f.

   //------------------------------------------------------------------------//

   METHOD Create()

   METHOD Default()                    VIRTUAL

   METHOD NewResource( cFldRes )

   METHOD lResource( cFld )

   METHOD initVariables()              

   METHOD InitDialog()
   METHOD SetDialog()

   METHOD StartDialog()                VIRTUAL

   METHOD summaryReport()              VIRTUAL

   METHOD LoadPersonalizado()

   METHOD Activate()

   METHOD Play( uParam )
   METHOD PlayTablet( uParam )

   METHOD EditValueTextDesde()         INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:HelpDesde ) )
   METHOD EditValueTextHasta()         INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:HelpHasta ) )
   METHOD EditTextDesde()              INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:TextDesde ) )
   METHOD EditTextHasta()              INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:TextHasta ) )

   METHOD ValidValueTextDesde( oGet )  INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:ValidDesde, oGet ) )
   METHOD ValidValueTextHasta( oGet )  INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:ValidHasta, oGet ) )

   METHOD cReportKey()                 INLINE ( Padr( ::ClassName(), 50 ) + Padr( Upper( ::cReportType ), 50 ) + Padr( Upper( ::cReportName ), 50 ) )

   METHOD ExtractOrder()

   METHOD End()

   METHOD OpenData( cPath, lExclusive )
   METHOD CloseData()

   METHOD OpenService( lExclusive, cPath )
   METHOD CloseService()

   Method BuildFiles( cPath )          INLINE ( ::DefineReport( cPath ), ::oDbfInf:Create() )

   METHOD lGenerate()
   
   METHOD SetDataReport()

   METHOD GenReport( nOption )
   
   METHOD GenReportTablet( nOption )

   METHOD lValidRegister()

   METHOD DataReport()

   METHOD SyncAllDbf()

   METHOD DefineReport( cPath )

   METHOD Reindexa( cPath )

   METHOD FastReport( nDevice )

   METHOD DesignReport( cNombre )

   METHOD TreePersonalizadosChanged()  VIRTUAL

   METHOD TreeReportingClick()         INLINE ( ::GenReport( IS_SCREEN ), 0 )
   METHOD TreePersonalizadosClick()    INLINE ( ::GenReport( IS_SCREEN ) )

   METHOD lLoadInfo()

   METHOD lLoadReport()
   METHOD MoveReport()

   METHOD OpenTemporal()
   METHOD CloseTemporal()

   METHOD SaveReport()
      METHOD SaveReportAs()
         METHOD EndSaveReportAs( cNombre, oDlg )

   METHOD Eliminar()

   METHOD GetFieldByDescription( cDescription )

   METHOD DlgExportDocument()
      METHOD ExportDocument( cGetFile )

   METHOD DlgImportDocument()
      METHOD ImportDocument()

   METHOD BuildNode( aReports, oTree, lLoadFile )
   METHOD AddNode()
   METHOD ReBuildTree()                                           INLINE ( ::oTreeReporting:DeleteAll(), ::BuildTree() )

   METHOD nRemesaAgentes()
   METHOD nFacturaClientes()
   METHOD nPagosClientes()

   METHOD GetReportType()                                         INLINE ( if( !empty( ::hReport ) .and. hHasKey( ::hReport, ::cReportType ), hGet( ::hReport, ::cReportType ), ) )

   METHOD FastReportSATCliente()
   METHOD FastReportPresupuestoCliente()
   METHOD FastReportPedidoCliente()
   METHOD FastReportAlbaranCliente()
   METHOD FastReportFacturaCliente()
   METHOD FastReportFacturaRectificativa()
   METHOD FastReportTicket()
   METHOD FastReportParteProduccion()   
   METHOD FastReportRecibosCliente()

   METHOD FastReportPedidoProveedor()
   METHOD FastReportAlbaranProveedor()
   METHOD FastReportFacturaProveedor()
   METHOD FastReportRectificativaProveedor()

   METHOD FastReportStock()

   METHOD AddVariableSATCliente()
   METHOD AddVariableLineasSATCliente()
   METHOD cDetalleSATClientes()                                   INLINE ( cDesSatCli ( D():SATClientesLineas( ::nView )  ) )
   METHOD nTotalUnidadesSATClientes()                             INLINE ( nTotNSatCli( D():SATClientesLineas( ::nView )  ) )
   METHOD nPrecioUnitarioSATClientes()                            INLINE ( nTotUSatCli( D():SATClientesLineas( ::nView )  ) ) 
   METHOD nTotalLineaSATClientes()                                INLINE ( nTotLSatCli( D():SATClientesLineas( ::nView )  ) )
   METHOD nTotalPesoLineaSATClientes()                            INLINE ( nPesLSatCli( D():SATClientesLineas( ::nView )  ) )  
   METHOD nTotalImpuestosIncluidosLineaSATClientes()              INLINE ( nTotFSatCli( D():SATClientesLineas( ::nView )  ) )
   METHOD nTotalIVALineaSATClientes()                             INLINE ( nIvaLSatCli( D():SATClientesLineas( ::nView )  ) )

   METHOD nTotalDescuentoPorcentualLineaSATClientes()             INLINE ( nDtoLSatCli( D():SATClientesLineas( ::nView )  ) )
   METHOD nTotalDescuentoPromocionalLineaSATClientes()            INLINE ( nPrmLSatCli( D():SATClientesLineas( ::nView )  ) )
   
   METHOD AddVariablePresupuestoCliente()
   METHOD AddVariableLineasPresupuestoCliente()
   METHOD cDetallePresupuestoClientes()                           INLINE ( cDesPreCli ( D():PresupuestosClientesLineas( ::nView ) ) )
   METHOD nTotalUnidadesPresupuestosClientes()                    INLINE ( nTotNPreCli( D():PresupuestosClientesLineas( ::nView ) ) )
   METHOD nPrecioUnitarioPresupuestosClientes()                   INLINE ( nTotUPreCli( D():PresupuestosClientesLineas( ::nView ) ) ) 
   METHOD nTotalLineaPresupuestosClientes()                       INLINE ( nTotLPreCli( D():PresupuestosClientesLineas( ::nView ) ) )
   METHOD nTotalPesoLineaPresupuestosClientes()                   INLINE ( nPesLPreCli( D():PresupuestosClientesLineas( ::nView ) ) )
   METHOD nTotalImpuestosIncluidosLineaPresupuestosClientes()     INLINE ( nTotFPreCli( D():PresupuestosClientesLineas( ::nView ) ) )
   METHOD nTotalIVALineaPresupuestosClientes()                    INLINE ( nIvaLPreCli( D():PresupuestosClientesLineas( ::nView ) ) )

   METHOD nTotalDescuentoPorcentualLineaPresupuestosClientes()    INLINE ( nDtoLPreCli( D():PresupuestosClientesLineas( ::nView ) ) )
   METHOD nTotalDescuentoPromocionalLineaPresupuestosClientes()   INLINE ( nPrmLPreCli( D():PresupuestosClientesLineas( ::nView ) ) )

   METHOD AddVariablePedidoCliente()
   METHOD AddVariableLineasPedidoCliente()
   METHOD cDetallePedidosClientes()                               INLINE ( cDesPedCli ( D():PedidosClientesLineas( ::nView ) ) )
   METHOD nTotalUnidadesPedidosClientes()                         INLINE ( nTotNPedCli( D():PedidosClientesLineas( ::nView ) ) )
   METHOD nPrecioUnitarioPedidosClientes()                        INLINE ( nTotUPedCli( D():PedidosClientesLineas( ::nView ) ) ) 
   METHOD nTotalLineaPedidosClientes()                            INLINE ( nTotLPedCli( D():PedidosClientesLineas( ::nView ) ) )
   METHOD nTotalPesoLineaPedidosClientes()                        INLINE ( nPesLPedCli( D():PedidosClientesLineas( ::nView ) ) )
   METHOD nTotalImpuestosIncluidosLineaPedidosClientes()          INLINE ( nTotFPedCli( D():PedidosClientesLineas( ::nView ) ) )
   METHOD nTotalIVALineaPedidosClientes()                         INLINE ( nIvaLPedCli( D():PedidosClientesLineas( ::nView ) ) )

   METHOD nTotalDescuentoPorcentualLineaPedidosClientes()         INLINE ( nDtoLPedCli( D():PedidosClientesLineas( ::nView ) ) )
   METHOD nTotalDescuentoPromocionalLineaPedidosClientes()        INLINE ( nPrmLPedCli( D():PedidosClientesLineas( ::nView ) ) )
   METHOD nTotalComisionAgentes()                                 INLINE ( nComLPedCli( D():PedidosClientesLineas( ::nView ), D():PedidosClientesLineas( ::nView ) ) )

   METHOD AddVariableAlbaranCliente()
   METHOD AddVariableLineasAlbaranCliente()
   METHOD cDetalleAlbaranesClientes()                             INLINE ( cDesAlbCli ( D():AlbaranesClientesLineas( ::nView ) ) )
   METHOD nTotalUnidadesAlbaranesClientes()                       INLINE ( nTotNAlbCli( D():AlbaranesClientesLineas( ::nView ) ) )
   METHOD nPrecioUnitarioAlbaranesClientes()                      INLINE ( nTotUAlbCli( D():AlbaranesClientesLineas( ::nView ) ) ) 
   METHOD nTotalLineaAlbaranesClientes()                          INLINE ( nTotLAlbCli( D():AlbaranesClientesLineas( ::nView ) ) )
   METHOD nTotalPesoLineaAlbaranesClientes()                      INLINE ( nPesLAlbCli( D():AlbaranesClientesLineas( ::nView ) ) )
   METHOD nTotalImpuestosIncluidosLineaAlbaranesClientes()        INLINE ( nTotFAlbCli( D():AlbaranesClientesLineas( ::nView ) ) )
   METHOD nTotalIVALineaAlbaranesClientes()                       INLINE ( nIvaLAlbCli( D():AlbaranesClientesLineas( ::nView ) ) )

   METHOD nTotalDescuentoPorcentualLineaAlbaranesClientes()       INLINE ( nDtoLAlbCli( D():AlbaranesClientesLineas( ::nView ) ) )
   METHOD nTotalDescuentoPromocionalLineaAlbaranesClientes()      INLINE ( nPrmLAlbCli( D():AlbaranesClientesLineas( ::nView ) ) )

   METHOD AddVariableArticulos()

   METHOD AddVariableFacturaCliente()
   METHOD AddVariableLineasFacturaCliente()
   METHOD AddVariableRecibosCliente()

   METHOD cDetalleFacturasClientes()                              INLINE ( cDesFacCli  ( D():FacturasClientesLineas( ::nView ) ) ) 
   METHOD nTotalUnidadesFacturasClientes()                        INLINE ( nTotNFacCli ( D():FacturasClientesLineas( ::nView ) ) )
   METHOD nPrecioUnitarioFacturasClientes()                       INLINE ( nNoIncUFacCli( D():FacturasClientesLineas( ::nView ) ) ) 
   METHOD nTotalLineaFacturasClientes()                           INLINE ( nNoIncLFacCli( D():FacturasClientesLineas( ::nView ) ) )

   METHOD nTotalPesoLineaFacturasClientes()                       INLINE ( nPesLFacCli( D():FacturasClientesLineas( ::nView ) ) )
   METHOD nTotalImpuestosIncluidosLineaFacturasClientes()         INLINE ( nTotFFacCli( D():FacturasClientesLineas( ::nView ) ) )
   METHOD nTotalIVALineaFacturasClientes()                        INLINE ( nIvaLFacCli( D():FacturasClientesLineas( ::nView ) ) )

   METHOD nTotalDescuentoPorcentualLineaFacturasClientes()        INLINE ( nDtoLFacCli( D():FacturasClientesLineas( ::nView ) ) )
   METHOD nTotalDescuentoPromocionalLineaFacturasClientes()       INLINE ( nPrmLFacCli( D():FacturasClientesLineas( ::nView ) ) )

   METHOD AddVariableRectificativaCliente()
   METHOD AddVariableLineasRectificativaCliente()

   METHOD AddVariableLineasParteProduccion()                      VIRTUAL
   
   METHOD cDetalleRectificativasClientes()                           INLINE ( cDesFacRec ( D():FacturasRectificativasLineas( ::nView ) ) )
   METHOD nTotalUnidadesRectificativasClientes()                     INLINE ( nTotNFacRec( D():FacturasRectificativasLineas( ::nView ) ) )
   METHOD nPrecioUnitarioRectificativasClientes()                    INLINE ( nTotUFacRec( D():FacturasRectificativasLineas( ::nView ) ) ) 
   METHOD nTotalLineaRectificativasClientes()                        INLINE ( nTotLFacRec( D():FacturasRectificativasLineas( ::nView ) ) )
   METHOD nTotalPesoLineaRectificativasClientes()                    INLINE ( nPesLFacRec( D():FacturasRectificativasLineas( ::nView ) ) )
   METHOD nTotalImpuestosIncluidosLineaRectificativasClientes()      INLINE ( nTotFFacRec( D():FacturasRectificativasLineas( ::nView ) ) )
   METHOD nTotalIVALineaRectificativasClientes()                     INLINE ( nIvaLFacRec( D():FacturasRectificativasLineas( ::nView ) ) )

   METHOD nTotalDescuentoPorcentualLineaRectificativasClientes()     INLINE ( nDtoLFacRec( D():FacturasRectificativasLineas( ::nView ) ) )
   METHOD nTotalDescuentoPromocionalLineaRectificativasClientes()    INLINE ( nPrmLFacRec( D():FacturasRectificativasLineas( ::nView ) ) )

   METHOD AddVariableTicketCliente()                              
   METHOD AddVariableLineasTicketCliente()

   METHOD cDetalleTicketsClientes()                               INLINE ( ( D():TiketsLineas( ::nView ) )->cNomTil )
   METHOD nTotalUnidadesTicketsClientes()                         INLINE ( nTotNTpv( D():TiketsLineas( ::nView ) ) ) 
   METHOD nPrecioUnitarioTicketsClientes()                        INLINE ( nBasUTpv( D():TiketsLineas( ::nView ) ) ) 
   METHOD nTotalLineaTicketsClientes()                            INLINE ( nBasLTpv( D():TiketsLineas( ::nView ) ) )
   METHOD nTotalPesoLineaTicketsClientes()                        INLINE ( 0 )
   METHOD nTotalImpuestosIncluidosLineaTicketsClientes()          INLINE ( nTotLTpv( D():TiketsLineas( ::nView ) ) )
   METHOD nTotalIVALineaTicketsClientes()                         INLINE ( nIvaLTpv( D():Tikets( ::nView ) ), ( D():TiketsLineas( ::nView ) ) )

   METHOD nTotalDescuentoPorcentualLineaTicketsClientes()         INLINE ( nDtoLTpv( D():TiketsLineas( ::nView ) ) )

   METHOD AddVariableLiquidacionAgentes()

   METHOD AddVariablePedidoProveedor()
   METHOD AddVariableLineasPedidoProveedor()

   METHOD cDetallePedidosProveedores()                                  INLINE ( cDesPedPrv ( D():PedidosProveedoresLineas( ::nView ) ) )
   METHOD nTotalUnidadesPedidosProveedores()                            INLINE ( nTotNPedPrv( D():PedidosProveedoresLineas( ::nView ) ) )
   METHOD nPrecioUnitarioPedidosProveedores()                           INLINE ( nTotUPedPrv( D():PedidosProveedoresLineas( ::nView ) ) ) 
   METHOD nTotalLineaPedidosProveedores()                               INLINE ( nTotLPedPrv( D():PedidosProveedoresLineas( ::nView ) ) )   
   METHOD nTotalImpuestosIncluidosLineaPedidosProveedores()             INLINE ( nTotFPedPrv( D():PedidosProveedoresLineas( ::nView ) ) )
   METHOD nTotalIVALineaPedidosProveedores()                            INLINE ( nIvaLPedPrv( D():PedidosProveedoresLineas( ::nView ) ) )
   METHOD nTotalDescuentoPorcentualLineaPedidosProveedores()            INLINE ( nDtoLPedPrv( D():PedidosProveedoresLineas( ::nView ) ) )
   METHOD nTotalDescuentoPromocionalLineaPedidosProveedores()           INLINE ( nPrmLPedPrv( D():PedidosProveedoresLineas( ::nView ) ) )

   METHOD AddVariableAlbaranProveedor()
   METHOD AddVariableLineasAlbaranProveedor()

   METHOD cDetalleAlbaranesProveedores()                                INLINE ( cDesAlbPrv ( D():AlbaranesProveedoresLineas( ::nView ) ) )
   METHOD nTotalUnidadesAlbaranesProveedores()                          INLINE ( nTotNAlbPrv( D():AlbaranesProveedoresLineas( ::nView ) ) )
   METHOD nPrecioUnitarioAlbaranesProveedores()                         INLINE ( nTotUAlbPrv( D():AlbaranesProveedoresLineas( ::nView ) ) ) 
   METHOD nTotalLineaAlbaranesProveedores()                             INLINE ( nTotLAlbPrv( D():AlbaranesProveedoresLineas( ::nView ) ) )   
   METHOD nTotalImpuestosIncluidosLineaAlbaranesProveedores()           INLINE ( nTotFAlbPrv( D():AlbaranesProveedoresLineas( ::nView ) ) )
   METHOD nTotalIVALineaAlbaranesProveedores()                          INLINE ( nIvaLAlbPrv( D():AlbaranesProveedoresLineas( ::nView ) ) )
   METHOD nTotalDescuentoPorcentualLineaAlbaranesProveedores()          INLINE ( nDtoLAlbPrv( D():AlbaranesProveedoresLineas( ::nView ) ) )
   METHOD nTotalDescuentoPromocionalLineaAlbaranesProveedores()         INLINE ( nPrmLAlbPrv( D():AlbaranesProveedoresLineas( ::nView ) ) )

   METHOD AddVariableFacturaProveedor()
   METHOD AddVariableLineasFacturaProveedor()

   METHOD cDetalleFacturasProveedores()                                 INLINE ( cDesFacPrv ( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias ) )
   METHOD nTotalUnidadesFacturasProveedores()                           INLINE ( nTotNFacPrv( ::oFacPrvL:cAlias ) )
   METHOD nPrecioUnitarioFacturasProveedores()                          INLINE ( nTotUFacPrv( ::oFacPrvL:cAlias ) ) 
   METHOD nTotalLineaFacturasProveedores()                              INLINE ( nTotLFacPrv( ::oFacPrvL:cAlias ) )   
   METHOD nTotalImpuestosIncluidosLineaFacturasProveedores()            INLINE ( nTotFFacPrv( ::oFacPrvL:cAlias ) )
   METHOD nTotalIVALineaFacturasProveedores()                           INLINE ( nIvaLFacPrv( ::oFacPrvL:cAlias ) )
   METHOD nTotalDescuentoPorcentualLineaFacturasProveedores()           INLINE ( nDtoLFacPrv( ::oFacPrvL:cAlias ) )
   METHOD nTotalDescuentoPromocionalLineaFacturasProveedores()          INLINE ( nPrmLFacPrv( ::oFacPrvL:cAlias ) )

   METHOD AddVariableRectificativaProveedor()
   METHOD AddVariableLineasRectificativaProveedor()

   METHOD cDetalleRectificativasProveedores()                            INLINE ( cDesRctPrv ( ::oRctPrvL:cAlias ) )
   METHOD nTotalUnidadesRectificativasProveedores()                      INLINE ( nTotNRctPrv( ::oRctPrvL:cAlias ) )
   METHOD nPrecioUnitarioRectificativasProveedores()                     INLINE ( nTotURctPrv( ::oRctPrvL:cAlias ) ) 
   METHOD nTotalLineaRectificativasProveedores()                         INLINE ( nTotLRctPrv( ::oRctPrvL:cAlias ) )   
   METHOD nTotalImpuestosIncluidosLineaRectificativasProveedores()       INLINE ( nTotFRctPrv( ::oRctPrvL:cAlias ) )
   METHOD nTotalIVALineaRectificativasProveedores()                      INLINE ( nIvaLRctPrv( ::oRctPrvL:cAlias ) )
   METHOD nTotalDescuentoPorcentualLineaRectificativasProveedores()      INLINE ( nDtoLRctPrv( ::oRctPrvL:cAlias ) )
   METHOD nTotalDescuentoPromocionalLineaRectificativasProveedores()     INLINE ( nPrmLRctPrv( ::oRctPrvL:cAlias ) )

   METHOD ValorCampoExtra( cTipoDoccumento, cCodCampoExtra )

   //------------------------------------------------------------------------//

   METHOD ActiveClients()
   METHOD TotalCodigoClientes( cCliDesde, cCliHasta, cDescription )
   METHOD TotalFechaClientes( dDesde, dHasta, cDescription )

   METHOD TotalPreimerTrimestreClientes( cDescription )
   METHOD TotalSegundoTrimestreClientes( cDescription )
   METHOD TotalCodigoArticulos( cArtDesde, cArtHasta, cDescription )

   METHOD BrwRangoKeyDown( o, nKey )

   METHOD Count( cDescription, lUnique )

   METHOD InitSatClientes()
   METHOD AddSATClientes()

   METHOD InitPresupuestosClientes()
   METHOD AddPresupuestosClientes()

   METHOD InitPedidosClientes()
   METHOD AddPedidosClientes()

   METHOD AddAlbaranesClientes()

   METHOD InitFacturasRectificativasClientes()
   METHOD AddFacturasRectificativasClientes()

   METHOD InitTicketsClientes()
   METHOD AddTicketsClientes()

   METHOD InitPedidosProveedores()
   METHOD AddPedidosProveedores()

   METHOD InitAlbaranesProveedores()
   METHOD AddAlbaranesProveedores()

   METHOD InitFacturasProveedores()
   METHOD AddFacturasProveedores()

   METHOD InitFacturasRectificativasProveedores()
   METHOD AddFacturasRectificativasProveedores()

   METHOD AddVariable()

   METHOD CreateTreeImageList()
      METHOD TreeReportingChanged() 

   METHOD XmlDocument()

   METHOD DlgFilter()
   METHOD SetFilterInforme( cExpresionFilter )           INLINE ( ::oDbf:SetFilter( cExpresionFilter ), sysrefresh() )

   METHOD InsertIfValid()

   METHOD lHideOptions()                                 INLINE ( if( !empty(::oBtnOptions), ::oBtnOptions:Hide(), ) )
   METHOD lShowOptions()                                 INLINE ( if( !empty(::oBtnOptions), ::oBtnOptions:Show(), ) )
   
   METHOD selectReportTree( cReportName )

   METHOD setMeterText( cText )                          INLINE ( if ( !empty( ::oMtrInf ), ::oMtrInf:cText := cText, ) )
   METHOD setMeterTotal( nTotal )                        INLINE ( if ( !empty( ::oMtrInf ), ::oMtrInf:SetTotal( nTotal ), ) )
   METHOD setMeterAutoIncremental()                      INLINE ( if ( !empty( ::oMtrInf ), ::oMtrInf:AutoInc(), ) )
   
END CLASS

//----------------------------------------------------------------------------//

METHOD NewResource( cFldRes ) CLASS TFastReportInfGen

   local n
   local o

   // Montamos el array con los periodos para los informes------------------------

   ::lCreaArrayPeriodos()
   
   //Aplicamos los valores segun se han archivado--------------------------------
   
   ::Default()

   ::lLoadDivisa()

   ::lDefDivInf                     := .f.
   ::lDefSerInf                     := .f.
   
   //Caja de dialogo-------------------------------------------------------------
   
   DEFINE DIALOG ::oDlg RESOURCE "REPORTINGDIALOG" TITLE ::cSubTitle

//   ::oDlg:Activate( , , , .t. )

//   Return ( .t. )

   ::oTreeReporting                 := TTreeView():Redefine( 100, ::oDlg ) 
   ::oTreeReporting:bChanged        := {|| ::TreeReportingChanged() }
   ::oTreeReporting:bLDblClick      := {|| ::TreeReportingClick() } // OnClick
   
   //Fechas----------------------------------------------------------------------
   
   if ::lDefFecInf
      ::oDefIniInf( 1110, ::oDlg, 1111 )
      ::oDefFinInf( 1120, ::oDlg, 1121 )
      ::lPeriodoInforme( 220, ::oDlg )
   end if

   // Opciones
   
   REDEFINE BUTTON ::oBtnOptions ;
      ID       1130 ;
      OF       ::oDlg ;
      ACTION   ( ::oTFastReportOptions:Dialog() )
   
   //Browse de los rangos----------------------------------------------------------
   
   ::oBrwRango                      := IXBrowse():New( ::oDlg )

   ::oBrwRango:bClrSel              := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwRango:bClrSelFocus         := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwRango:SetArray( ::aInitGroup, , , .f. )

   ::oBrwRango:lHScroll             := .f.
   ::oBrwRango:lVScroll             := .f.
   ::oBrwRango:lRecordSelector      := .t.
   ::oBrwRango:lFastEdit            := .t.

   ::oBrwRango:nFreeze              := 1
   ::oBrwRango:nMarqueeStyle        := 3

   ::oBrwRango:nColSel              := 2

   ::oBrwRango:CreateFromResource( 310 )

   ::oColNombre                     := ::oBrwRango:AddCol()
   ::oColNombre:cHeader             := ""
   ::oColNombre:bStrData            := {|| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Nombre }
   ::oColNombre:bBmpData            := {|| ::oBrwRango:nArrayAt }
   ::oColNombre:nWidth              := 90

   for each o in ::aInitGroup
      ::oColNombre:AddResource( o:Cargo:cBitmap )
   next

   with object ( ::oColDesde := ::oBrwRango:AddCol() )
      :cHeader       := "Desde"
      :bEditValue    := {|| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Desde }
      :bOnPostEdit   := {|o,x| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Desde := x }
      :bEditValid    := {|oGet| ::ValidValueTextDesde( oGet ) }
      :bEditBlock    := {|| ::EditValueTextDesde() }
      :cEditPicture  := "@!"
      :nEditType     := 5
      :nWidth        := 120
      :nBtnBmp       := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bEditValue    := {|| ::EditTextDesde() } 
      :nEditType     := 0
      :nWidth        := 160
   end with

   with object ( ::oColHasta := ::oBrwRango:AddCol() )
      :cHeader       := "Hasta"
      :bEditValue    := {|| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Hasta }
      :bOnPostEdit   := {|o,x| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Hasta := x }
      :bEditValid    := {|oGet| ::ValidValueTextHasta( oGet ) }
      :bEditBlock    := {|| ::EditValueTextHasta() }
      :cEditPicture  := "@!"
      :nEditType     := 5
      :nWidth        := 120
      :nBtnBmp       := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bEditValue    := {|| ::EditTextHasta() }
      :nEditType     := 0
      :nWidth        := 160
   end with

   ::oBrwRango:OnKeyDown            := {| o, nKey | ::BrwRangoKeyDown( o, nKey ) }

   // Divisas---------------------------------------------------------------------

   if ::lDefDivInf
      ::oDefDivInf( 1130, 1131, ::oDlg )
   end if

   // Series----------------------------------------------------------------------

   if ::lDefSerInf
      ::oDefSerInf( ::oDlg )
   end if

   // Progreso--------------------------------------------------------------------

   if ::lDefMetInf
      ::oDefMetInf( 1160, ::oDlg )
   end if

RETURN .t.

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TFastReportInfGen

   local lActivate      := .f.

   if !empty( ::oDlg )

      ::oDlg:AddFastKey( VK_F5,  {|| ::GenReport( IS_SCREEN ) } )
      ::oDlg:AddFastKey( VK_F9,  {|| ::MoveReport() } )

      ::oDlg:bStart     := {|| ::StartDialog(), ::LoadPersonalizado() }

      ::oDlg:Activate( , , , .t., , , {|| ::InitDialog() } )

      lActivate         := ( ::oDlg:nResult == IDOK )

   end if

RETURN ( lActivate )

//----------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TFastReportInfGen

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

   if !::NewResource()
      return .f.
   end if

   /*
   Carga controles-------------------------------------------------------------
   */

   if !::lGrupoArticulo( .t. )
      return .f.
   end if

   if !::lGrupoFamilia( .t. )
      return .f.
   end if

   if !::lGrupoTipoArticulo( .t. )
      return .f.
   end if

   if !::lGrupoCategoria( .t. )
      return .f.
   end if

   if !::lGrupoTemporada( .t. )
      return .f.
   end if

   if !::lGrupoFabricante( .t. )
      return .f.
   end if

   /*
   Definimos el tree de condiciones--------------------------------------------
   */

   REDEFINE GROUP ::oGrupoCondiciones ID 131 OF ::oDlg TRANSPARENT

   REDEFINE GET ::nUnidadesTiempo ;
      SPINNER  MIN 0 MAX 999 ;
      PICTURE  "@E 999" ;
      ID       320 ;
      OF       ::oDlg

   REDEFINE COMBOBOX ::oUnidadesTiempo ;
      VAR      ::cUnidadesTiempo ;
      ID       330 ;
      ITEMS    ::aUnidadesTiempo ;
      OF       ::oDlg

RETURN .t.

//---------------------------------------------------------------------------//

METHOD InitDialog() CLASS TFastReportInfGen

   local oGrupo
   local oCarpeta

   ::oOfficeBar            := TDotNetBar():New( 0, 0, 1100, 115, ::oDlg, 1 )
   ::oOfficeBar:lPaintAll  := .f.
   ::oOfficeBar:lDisenio   := .f.

   ::oOfficeBar:SetStyle( 1 )

   oCarpeta                := TCarpeta():New( ::oOfficeBar, "Informe" )

   oGrupo                  := TDotNetGroup():New( oCarpeta, 306, "Impresión", .f. )
      ::oBtnPrevisualizar  := TDotNetButton():New( 60, oGrupo, "gc_monitor_32",              "Visualizar [F5]",   1, {|| ::GenReport( IS_SCREEN ) }, , , .f., .f., .f. )
      ::oBtnImprimir       := TDotNetButton():New( 60, oGrupo, "gc_printer2_32",             "Imprimir",          2, {|| ::GenReport( IS_PRINTER ) }, , , .f., .f., .f. )
      ::oBtnExcel          := TDotNetButton():New( 60, oGrupo, "gc_spreadsheet_cell_32",     "Excel",             3, {|| ::GenReport( IS_EXCEL ) }, , , .f., .f., .f. )
      ::oBtnPdf            := TDotNetButton():New( 60, oGrupo, "gc_document_text_lock_32",   "Pdf",               4, {|| ::GenReport( IS_PDF ) }, , , .f., .f., .f. )
      ::oBtnHTML           := TDotNetButton():New( 60, oGrupo, "gc_earth_32",                "HTML",              5, {|| ::GenReport( IS_HTML ) }, , , .f., .f., .f. )

   oGrupo                  := TDotNetGroup():New( oCarpeta, 246, "Útiles", .f. )
      ::oBtnDiseno         := TDotNetButton():New( 60, oGrupo, "gc_set_square_pencil_32",    "Diseñar",           1, {|| ::DesignReport() }, , , .f., .f., .f. )
      ::oBtnEliminar       := TDotNetButton():New( 60, oGrupo, "gc_document_text_delete_32", "Eliminar",          2, {|| ::Eliminar() }, , , .f., .f., .f. )
      ::oBtnFiltrar        := TDotNetButton():New( 60, oGrupo, "gc_funnel_32",               "Filtrar",           3, {|| ::DlgFilter() }, , , .f., .f., .f. )
      ::oBtnXml            := TDotNetButton():New( 60, oGrupo, "gc_folder_document_32",      "Ver",               4, {|| ::XmlDocument() }, , , .f., .f., .f. )

   oGrupo                  := TDotNetGroup():New( oCarpeta, 66, "Salida", .f. )

      ::oBtnCancel         := TDotNetButton():New( 60, oGrupo, "gc_door_open2_32",     "Salir",             1, {|| ::lBreak := .t., ::End() }, , , .f., .f., .f. )

      ::oDlg:oTop          := ::oOfficeBar

   ::HideCondiciones()

   /*
   Cargamos las condiciones en oTreeCondiciones--------------------------------
   */

   SysRefresh()

   if ::lDesglosar
      ::oDefDesglosar()
   end if

   if ::lLinImporteCero
      ::oDefLinImporteCero()
   end if

   if ::lDocImporteCero
      ::oDefDocImporteCero()
   end if

   /*
   Nos posicionamos en el informe----------------------------------------------
   */

   ::lRecargaFecha()

   /*
   Cambios---------------------------------------------------------------------
   */

   ::oTreeReporting:SetFocus()

   ::TreeReportingChanged()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetDialog( lEnabled ) CLASS TFastReportInfGen

   DEFAULT lEnabled              := .f.

   ::oBtnPrevisualizar:lEnabled  := lEnabled
   ::oBtnImprimir:lEnabled       := lEnabled
   ::oBtnExcel:lEnabled          := lEnabled
   ::oBtnPdf:lEnabled            := lEnabled
   ::oBtnHTML:lEnabled           := lEnabled
   ::oBtnDiseno:lEnabled         := lEnabled
   ::oBtnFiltrar:lEnabled        := lEnabled
   ::oBtnEliminar:lEnabled       := lEnabled
   ::oBtnXml:lEnabled            := lEnabled

   if lEnabled
      ::oTreeReporting:Enable()
      ::oBrwRango:Enable()
   else
      ::oTreeReporting:Disable()
      ::oBrwRango:Disable()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create() CLASS TFastReportInfGen

   ::AddField( "cCodArt",     "C", 18, 0, {|| "@!" }, "Codigo artículo", .f., "Código artículo", 14, .f. )

   ::AddTmpIndex( "cCodArt", "cCodArt" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Play( uParam ) CLASS TFastReportInfGen

   ::Create( uParam )

   if ::lOpenFiles

      if ::OpenData()

         if ::OpenTemporal()

            if ::lResource()

               ::Activate()

            end if

            ::CloseTemporal()

         end if

         ::CloseData()

      end if

   end if

   ::End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD PlayTablet( uParam, oDevice ) CLASS TFastReportInfGen

   DEFAULT oDevice   := IS_PRINTER

   ::Create( uParam )

   if ::lOpenFiles

      if ::OpenData()

         if ::OpenTemporal()

            ::lResource()

            ::GenReportTablet( oDevice )

            ::CloseTemporal()

         end if

         ::CloseData()

      end if

   end if

   ::End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TFastReportInfGen

   CursorWait()

   if ::lSave2Exit .and. ::lOpenFiles
      ::Save()
   end if

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:end()
   end if

   if ::oBmpDiv != nil
      ::oBmpDiv:end()
   end if

   if ::oBandera != nil
      ::oBandera:end()
   end if

   ::CloseData()

   /*
   LLamamos al metodo virtual--------------------------------------------------
   */

   ::CloseFiles()

   if ::oDbfArt != nil .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if ::oDbfAlm != nil .and. ::oDbfAlm:Used()
      ::oDbfAlm:End()
   end if

   if ::oDbfAge != nil .and. ::oDbfAge:Used()
      ::oDbfAge:End()
   end if

   if ::oDbfFam != nil .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   if ::oDbfCat != nil .and. ::oDbfCat:Used()
      ::oDbfCat:End()
   end if

   if ::oDbfEstArt != nil .and. ::oDbfEstArt:Used()
      ::oDbfEstArt:End()
   end if

   if ::oDbfPrv != nil .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
   end if

   if ::oDbfCli != nil .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if ::oDbfTmp != nil .and. ::oDbfTmp:Used()
      ::oDbfTmp:End()
   end if

   if ::oDbfEmp != nil .and. ::oDbfEmp:Used()
      ::oDbfEmp:End()
   end if

   if ::oGruFam != nil
      ::oGruFam:End()
   end if

   if ::oDbfFpg != nil .and. ::oDbfFpg:Used()
      ::oDbfFpg:End()
   end if

   if ::oDbfTur != nil .and. ::oDbfTur:Used()
      ::oDbfTur:End()
   end if

   if ::oTipArt != nil
      ::oTipArt:End()
   end if

   if ::oDbfFab != nil
      ::oDbfFab:End()
   end if

   if ::oGrpPrv != nil
      ::oGrpPrv:End()
   end if

   if ::oDbfTrn != nil
      ::oDbfTrn:End()
   end if

   if ::oSeccion != nil
      ::oSeccion:End()
   end if

   if ::oOperacion != nil
      ::oOperacion:End()
   end if

   if ::oDbfIva != nil .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   if ::oDbfRut != nil .and. ::oDbfRut:Used()
      ::oDbfRut:End()
   end if

   if ::oDbfUsr != nil .and. ::oDbfUsr:Used()
      ::oDbfUsr:End()
   end if

   if !Empty( ::oRemAgeT ) .and. ( ::oRemAgeT:Used() )
      ::oRemAgeT:end()
   end if

   /*
   Eliminamos los temporales---------------------------------------------------
   */

   ::CloseTemporal()

   if !Empty( ::nBmp )
      DeleteObject( ::nBmp )
   end if

   if !Empty( ::oBmpImagen )
      ::oBmpImagen:End()
   end if

   if !::lTabletVersion .and. !Empty( ::oDlg )
      ::oDlg:End()
   end if

   Self        := nil

   CursorWE()

Return .t.

//----------------------------------------------------------------------------//

METHOD GenReport( nOption ) CLASS TFastReportInfGen

   local oDlg

   /*
   Obtenemos los datos necesarios para el informe------------------------------
   */

   if !::lLoadInfo()
      msgStop( "No se ha podido cargar el nombre del informe." )
      Return ( Self )
   end if

   /*
   Obtenemos el informe -------------------------------------------------------
   */

   if !::lLoadReport()
      MsgStop( "No se ha podido cargar un diseño de informe valido." + CRLF + ::cReportFile )
      Return ( Self )
   end if 

   /*
   Ponemos el dialogo a disable------------------------------------------------
   */

   ::SetDialog( .f. )

   ::lBreak             := .f.
   ::oBtnCancel:bAction := {|| ::lBreak := .t. }

   ::initVariables()

   /*
   Extraer el orden------------------------------------------------------------
   */

   ::ExtractOrder()

   /*
   Comienza la generacion del informe------------------------------------------
   */

   if hb_isBlock( ::bPreGenerate )
      Eval( ::bPreGenerate )
   end if

   if ::lGenerate()

      if !::lBreak

         DEFINE DIALOG  oDlg ;
               FROM     0, 0 ;
               TO       4, 30 ;
               TITLE    "Generando informe" ;
               STYLE    DS_MODALFRAME

         oDlg:bStart    := { || ::FastReport( nOption ), oDlg:End(), SysRefresh() }
         oDlg:cMsg      := "Por favor espere..."

         ACTIVATE DIALOG oDlg ;
            CENTER ;
            ON PAINT oDlg:Say( 11, 0, xPadC( oDlg:cMsg, ( oDlg:nRight - oDlg:nLeft ) ), , , , .t. )

      end if

   else

      if !::lBreak
         msgStop( "No hay registros en las condiciones solictadas" )
      end if

   end if

   if hb_isBlock( ::bPostGenerate )
      Eval( ::bPostGenerate )
   end if

   ::oMtrInf:cText         := ""
   ::oMtrInf:Set( 0 )

   ::oBtnCancel:bAction    := {|| ::lBreak := .t., ::End() }

   ::SetDialog( .t. )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD GenReportTablet( nOption ) CLASS TFastReportInfGen

   local oDlg

   /*
   Obtenemos el informe -------------------------------------------------------
   */

   if !::lLoadReport()
      MsgStop( "No se ha podido cargar un diseño de informe valido." + CRLF + ::cReportFile )
      Return ( Self )
   end if 

   /*
   Ponemos el dialogo a disable------------------------------------------------
   */

   ::initVariables()

   /*
   Extraer el orden------------------------------------------------------------
   */

   ::ExtractOrder()

   /*
   Comienza la generacion del informe------------------------------------------
   */

   if hb_isBlock( ::bPreGenerate )
      Eval( ::bPreGenerate )
   end if

   if ::lGenerate()

      if !::lBreak

         DEFINE DIALOG  oDlg ;
               FROM     0, 0 ;
               TO       4, 30 ;
               TITLE    "Generando informe" ;
               STYLE    DS_MODALFRAME

         oDlg:bStart    := { || ::FastReport( nOption ), oDlg:End(), SysRefresh() }
         oDlg:cMsg      := "Por favor espere..."

         ACTIVATE DIALOG oDlg ;
            CENTER ;
            ON PAINT oDlg:Say( 11, 0, xPadC( oDlg:cMsg, ( oDlg:nRight - oDlg:nLeft ) ), , , , .t. )

      end if

   else

      if !::lBreak
         msgStop( "No hay registros en las condiciones solictadas" )
      end if

   end if

   if hb_isBlock( ::bPostGenerate )
      Eval( ::bPostGenerate )
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD lGenerate() CLASS TFastReportInfGen

   local aGenerate

   ::oDbf:Zap()

   // Generamos el informe-----------------------------------------------------

   aGenerate         := ::GetReportType()

   if !Empty( aGenerate )
      Eval( hGet( aGenerate, "Generate" ) )
   end if 

   if ::lSummary
      ::summaryReport()   
   end if 

   // Colocamos el filtro -----------------------------------------------------

   if !Empty( ::oFilter )
      ::SetFilterInforme( ::oFilter:cExpresionFilter )
   end if

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD SetDataReport() CLASS TFastReportInfGen

   local aData

   aData       := ::GetReportType()

   if !Empty( aData )
      Eval( hGet( aData, "Data" ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariable() CLASS TFastReportInfGen

   local aVariable

   ::Super:AddVariable()

   aVariable   := ::GetReportType()

   if !Empty( aVariable )
      Eval( hGet( aVariable, "Variable" ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

Method lValidRegister() CLASS TFastReportInfGen

   if ( ::oDbfArt:Codigo >= ::oGrupoArticulo:Cargo:Desde    .and. ::oDbfArt:Codigo <= ::oGrupoArticulo:Cargo:Hasta      ) .and.;
      ( ::oDbfArt:Familia >= ::oGrupoFamilia:Cargo:Desde    .and. ::oDbfArt:Familia <= ::oGrupoFamilia:Cargo:Hasta      ) .and.;
      ( ::oDbfArt:cCodTip >= ::oGrupoTArticulo:Cargo:Desde  .and. ::oDbfArt:cCodTip <= ::oGrupoTArticulo:Cargo:Hasta    ) .and.;
      ( ::oDbfArt:cCodCate >= ::oGrupoCategoria:Cargo:Desde .and. ::oDbfArt:cCodCate <= ::oGrupoCategoria:Cargo:Hasta   ) .and.;
      ( ::oDbfArt:cCodTemp >= ::oGrupoTemporada:Cargo:Desde .and. ::oDbfArt:cCodTemp <= ::oGrupoTemporada:Cargo:Hasta   ) .and.;
      ( ::oDbfArt:cCodFab >= ::oGrupoFabricante:Cargo:Desde .and. ::oDbfArt:cCodFab <= ::oGrupoFabricante:Cargo:Hasta   ) .and.;
      ( !Empty( ::oDbfArt:dFecVta ) .and. Empty( ::oDbfArt:dFinVta ) .and. ( ::oDbfArt:dFecVta + ::nDias < Date() ) )

      return .t.

   end if

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD DataReport( oFr ) CLASS TFastReportInfGen

   /*
   Zona de detalle-------------------------------------------------------------
   */

   ::oFastReport:SetWorkArea(       "Informe", ::oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Informe", cObjectsToReport( ::oDbf ) )

   /*
   Zona de datos---------------------------------------------------------------
   */

   ::oFastReport:SetWorkArea(       "Empresa", ::oDbfEmp:nArea )
   ::oFastReport:SetFieldAliases(   "Empresa", cItemsToReport( aItmEmp() ) )

   ::oFastReport:SetWorkArea(       "Artículos", ::oDbfArt:nArea )
   ::oFastReport:SetFieldAliases(   "Artículos", cItemsToReport( aItmArt() ) )

   ::oFastReport:SetWorkArea(       "Familias", ::oDbfFam:nArea )
   ::oFastReport:SetFieldAliases(   "Familias", cItemsToReport( aItmFam() ) )

   ::oFastReport:SetWorkArea(       "Tipo artículos", ::oTipArt:Select() )
   ::oFastReport:SetFieldAliases(   "Tipo artículos", cObjectsToReport( ::oTipArt:oDbf ) )

   ::oFastReport:SetWorkArea(       "Temporadas", ::oDbfTmp:nArea )
   ::oFastReport:SetFieldAliases(   "Temporadas", cItemsToReport( aItmTemporada() ) )

   ::oFastReport:SetWorkArea(       "Fabricantes", ::oDbfFab:Select() )
   ::oFastReport:SetFieldAliases(   "Fabricantes", cObjectsToReport( ::oDbfFab:oDbf ) )

   ::oFastReport:SetMasterDetail(   "Informe", "Artículos",       {|| ::oDbf:cCodArt } )
   ::oFastReport:SetMasterDetail(   "Informe", "Empresa",         {|| cCodEmp() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Familias",        {|| ::oDbfArt:Familia } )
   ::oFastReport:SetMasterDetail(   "Informe", "Tipo artículos",  {|| ::oDbfArt:cCodTip } )
   ::oFastReport:SetMasterDetail(   "Informe", "Categorias",      {|| ::oDbfArt:cCodCat } )
   ::oFastReport:SetMasterDetail(   "Informe", "Temporadas",      {|| ::oDbfArt:cCodTemp } )
   ::oFastReport:SetMasterDetail(   "Informe", "Fabricantes",     {|| ::oDbfArt:cCodFab } )

   ::oFastReport:SetResyncPair(     "Informe", "Artículos" )
   ::oFastReport:SetResyncPair(     "Informe", "Empresa" )
   ::oFastReport:SetResyncPair(     "Informe", "Familias" )
   ::oFastReport:SetResyncPair(     "Informe", "Tipo artículos" )
   ::oFastReport:SetResyncPair(     "Informe", "Categorias" )
   ::oFastReport:SetResyncPair(     "Informe", "Temporadas" )
   ::oFastReport:SetResyncPair(     "Informe", "Fabricantes" )

Return ( Self )

//----------------------------------------------------------------------------//

METHOD OpenData( cPath, lExclusive ) CLASS TFastReportInfGen

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT cPath        := cPatEmp()
   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DATABASE NEW ::oDbfEmp PATH ( cPatDat() ) FILE "Empresa.Dbf" VIA ( cDriver() ) SHARED INDEX "Empresa.Cdx"

      DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "Divisas.Dbf" VIA ( cDriver() ) SHARED INDEX "Divisas.Cdx"

      /*
      Definicion y apertura de los fiche de configuración----------------------
      */

      if Empty( ::oDbfInf )
         ::oDbfInf      := ::DefineReport( cPath )
      end if

      ::oDbfInf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseTemporal() CLASS TFastReportInfGen

   /*
   Eliminamos los temporales---------------------------------------------------
   */

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf      := nil

   dbDrop( ::cFileName, ::cFileIndx, cLocalDriver() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseData() CLASS TFastReportInfGen

   if ::oDbfEmp != nil .and. ::oDbfEmp:Used()
      ::oDbfEmp:end()
   end if

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:end()
   end if

   if ::oDbfInf != nil .and. ::oDbfInf:Used()
      ::oDbfInf:end()
   end if

   if ::oDbfPersonalizado != nil .and. ::oDbfPersonalizado:Used()
      ::oDbfPersonalizado:end()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath ) CLASS TFastReportInfGen

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT cPath        := cPatEmp()
   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      /*
      Definicion y apertura de los fiche de configuración----------------------
      */

      if Empty( ::oDbfInf )
         ::oDbfInf      := ::DefineReport( cPath )
      end if

      ::oDbfInf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService() CLASS TFastReportInfGen

   if ::oDbfInf != nil .and. ::oDbfInf:Used()
      ::oDbfInf:end()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method DefineReport( cPath ) CLASS TFastReportInfGen

   DEFAULT cPath        := cPatEmp()

   DEFINE DATABASE ::oDbfInf FILE "FstInf.Dbf" CLASS "FstInf" PATH ( cPath ) VIA ( cDriver() ) COMMENT "Informes de la apliacación"

      FIELD NAME "cCodUse" TYPE "C" LEN   3  DEC 0 COMMENT "Código usuario"            OF ::oDbfInf
      FIELD NAME "cClsInf" TYPE "C" LEN  50  DEC 0 COMMENT "Clase del informe"         OF ::oDbfInf
      FIELD NAME "cTypInf" TYPE "C" LEN  50  DEC 0 COMMENT "Tipo del informe"          OF ::oDbfInf
      FIELD NAME "cNomInf" TYPE "C" LEN  50  DEC 0 COMMENT "Nombre del informe"        OF ::oDbfInf
      FIELD NAME "mOrgInf" TYPE "M" LEN  10  DEC 0 COMMENT "Configuración original"    OF ::oDbfInf
      FIELD NAME "mModInf" TYPE "M" LEN  10  DEC 0 COMMENT "Configuración modificada"  OF ::oDbfInf

      INDEX TO "FstInf.Cdx" TAG "cClsInf" ON "Upper( cClsInf ) + Upper( cTypInf ) + Upper( cNomInf )" NODELETED COMMENT "Código"  OF ::oDbfInf
      INDEX TO "FstInf.Cdx" TAG "cCodUse" ON "cCodUse + Upper( cNomInf )"                             NODELETED COMMENT "Usuario" OF ::oDbfInf

   END DATABASE ::oDbfInf

Return ( ::oDbfInf )

//--------------------------------------------------------------------------//

Method Reindexa( cPath )

   if file( cPath + "FstInf.Cdx" )
      ferase( cPath + "FstInf.Cdx" )
   end if

   ::DefineReport( cPath )

   ::oDbfInf:Activate( .f., .f. )
   ::oDbfInf:Pack()
   ::oDbfInf:End()

Return ( Self )

//--------------------------------------------------------------------------//

Method FastReport( nDevice ) CLASS TFastReportInfGen

   CursorWait()

   ::oFastReport                    := frReportManager():new()

   if !Empty( ::oFastReport )

      ::oFastReport:LoadLangRes(       "Spanish.Xml" )
      ::oFastReport:SetIcon( 1 )

      ::oFastReport:SetEventHandler(   "Designer", "OnSaveReport", {|lSaveAs| ::SaveReport( lSaveAs ) } )

      ::oFastReport:ClearDataSets()
   
      ::DataReport()

      ::oFastReport:LoadFromString( ::cInformeFastReport )

      ::AddVariable()

      ::oFastReport:SetTitle(                "Visualizando : " + ::cReportType )
      ::oFastReport:ReportOptions:SetName(   "Visualizando : " + ::cReportType )

      /*
      Imprimir el informe------------------------------------------------------
      */

      do case
         case nDevice == IS_SCREEN
            ::oFastReport:ShowReport()

         case nDevice == IS_PRINTER
            ::oFastReport:PrepareReport()
            ::oFastReport:PrintOptions:SetCopies( 1 )
            ::oFastReport:PrintOptions:SetShowDialog( .f. )
            ::oFastReport:Print()

         case nDevice == IS_PDF
            ::oFastReport:PrepareReport()
            ::oFastReport:SetProperty( "PDFExport", "ShowDialog",       .t. )
            ::oFastReport:SetProperty( "PDFExport", "DefaultPath",      cPatTmp() )
            ::oFastReport:SetProperty( "PDFExport", "FileName",         "Informe" + cCurUsr() + ".pdf" )
            ::oFastReport:SetProperty( "PDFExport", "EmbeddedFonts",    .t. )
            ::oFastReport:SetProperty( "PDFExport", "PrintOptimized",   .t. )
            ::oFastReport:SetProperty( "PDFExport", "Outline",          .t. )
            ::oFastReport:SetProperty( "PDFExport", "OpenAfterExport",  .t. )
            ::oFastReport:DoExport(    "PDFExport" )

         case nDevice == IS_HTML
            ::oFastReport:PrepareReport()
            ::oFastReport:SetProperty( "HTMLExport", "ShowDialog",      .t. )
            ::oFastReport:SetProperty( "HTMLExport", "DefaultPath",     cPatTmp() )
            ::oFastReport:SetProperty( "HTMLExport", "FileName",        "Informe" + cCurUsr() + ".html" )
            ::oFastReport:DoExport(    "HTMLExport" )

         case nDevice == IS_EXCEL
            ::oFastReport:PrepareReport()
            ::oFastReport:SetProperty( "XLSExport", "ShowDialog",       .t. )
            ::oFastReport:SetProperty( "XLSExport", "DefaultPath",      cPatTmp() )
            ::oFastReport:SetProperty( "XLSExport", "FileName",         "Informe" + cCurUsr() + ".xls" )
            ::oFastReport:DoExport(    "XLSExport" )

      end case

      ::oFastReport:DestroyFR()

   end if

   CursorWE()

RETURN ( Self )

//---------------------------------------------------------------------------//

Method DesignReport( cNombre ) CLASS TFastReportInfGen

   /*
   Obtenemos los datos necesarios para el informe------------------------------
   */

   if !::lLoadInfo()
      msgStop( "No se ha podido cargar el informe." )
      Return ( Self )
   end if

   /*
   Obtenemos el informe personalizado------------------------------------------
   */

   if !::lLoadReport()
      MsgStop( "No se ha podido cargar un diseño de informe valido." + CRLF + ::cReportFile )
      Return ( Self )
   end if 

   if !Empty( cNombre )
      ::lPersonalizado  := .t.
      ::cReportName     := cNombre
   end if

   /*
   Creacion del objeto---------------------------------------------------------
   */

   ::oFastReport                    := frReportManager():new()

   ::oFastReport:LoadLangRes(       "Spanish.Xml" )
   ::oFastReport:SetIcon( 1 )

   ::oFastReport:SetEventHandler(   "Designer", "OnSaveReport", {|lSaveAs| ::SaveReport( lSaveAs ) } )

   ::oFastReport:ClearDataSets()

   ::DataReport()

   if !Empty( ::cInformeFastReport )

      ::oFastReport:LoadFromString( ::cInformeFastReport )

   else

      ::oFastReport:AddPage(        "MainPage" )

      ::oFastReport:AddBand(        "CabeceraDocumento", "MainPage", frxPageHeader )
      ::oFastReport:SetProperty(    "CabeceraDocumento", "Top", 0 )
      ::oFastReport:SetProperty(    "CabeceraDocumento", "Height", 200 )

      ::oFastReport:AddBand(        "MasterData",  "MainPage", frxMasterData )
      ::oFastReport:SetProperty(    "MasterData",  "Top", 200 )
      ::oFastReport:SetProperty(    "MasterData",  "Height", 100 )
      ::oFastReport:SetProperty(    "MasterData",  "StartNewPage", .t. )
      ::oFastReport:SetObjProperty( "MasterData",  "DataSet", "Informe" )

      ::oFastReport:AddBand(        "DetalleColumnas",   "MainPage", frxDetailData  )
      ::oFastReport:SetProperty(    "DetalleColumnas",   "Top", 230 )
      ::oFastReport:SetProperty(    "DetalleColumnas",   "Height", 28 )
      ::oFastReport:SetObjProperty( "DetalleColumnas",   "DataSet", "Informe" )

   end if

   ::AddVariable()

   ::oFastReport:SetTitle(                "Diseñando : " + ::cReportType )
   ::oFastReport:ReportOptions:SetName(   "Diseñando : " + ::cReportType )

   ::oFastReport:PreviewOptions:SetMaximized( .t. )

   ::oFastReport:SetTabTreeExpanded( FR_tvAll, .f. )

   ::oFastReport:DesignReport()

   if !Empty( ::oFastReport )
      ::oFastReport:DestroyFR()
   end if

   if !Empty( cNombre )
      ::LoadPersonalizado()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method SaveReport( lSaveAs ) CLASS TFastReportInfGen

   local cFile    

   if lSaveAs // !::lUserDefine .or. 

      // Nuevo informe --------------------------------------------------------

      if !::SaveReportAs()
         Return ( .f. )
      end if 
      
      cFile       := ::cReportDirectory //  StrTran( ::cReportDirectory, cPatReporting(), cPatUserReporting() )
      cFile       += "\" + alltrim( ::cReportName ) + ".fr3"

   else

      cFile       := ::cReportFile
   
   end if 

   // Creamos todos los directorios necesarios---------------------------------

   recursiveMakeDir( cOnlyPath( cFile ) )

   // Salvamos el fichero------------------------------------------------------

   ::oFastReport:SaveToFile( cFile )

   // Recontruye el arbol------------------------------------------------------

   if lSaveAs
      ::ReBuildTree()
      ::selectReportTree( ::cReportName )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

Method MoveReport() CLASS TFastReportInfGen

   if ::oDbfInf:Seek( Padr( ::ClassName(), 50 ) + Upper( ::cReportName ) )

      if ApoloMsgNoYes( ::oDbfInf:mModInf, "¿Desea mover este diseño al original?" )

         ::oDbfInf:FieldPutByName( "mOrgInf", ::oDbfInf:mModInf )

         msgInfo( "El informe ha sido movido al original." )

      end if

   else

      msgStop( cCurUsr() + Upper( ::cReportName ), "No encontrado" )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenTemporal() CLASS TFastReportInfGen

   local o
   local lOpen
   local oError
   local oBlock

   lOpen                := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      /*
      Apertura del fichero temporal-----------------------------------------------
      */

      ::oDbf:Create()

      ::oDbf:Activate( .f., .f. )

      for each o in ::aIndex
         ::oDbf:AddTmpIndex( o[ 1 ], ::cFileIndx, o[ 2 ], o[ 3 ], o[ 4 ], o[ 5 ], o[ 6 ], , , , , .t. )
      next

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD ExtractOrder() CLASS TFastReportInfGen

   local n
   local a
   local c
   local cExpresion
   local cText
   local cField         := ""
   local cIndex         := ""
   local lDescendente   := .f.

   if !Empty( ::cInformeFastReport )

      cText             := ::cInformeFastReport
      cText             := aTextString( '<TfrxGroupHeader', '>', ::cInformeFastReport ) //CutString( '<TfrxGroupHeader', '>', cText )

      if !Empty( cText )

         cText          := CutString( 'Condition="', '"', cText )

         a              := HB_ATokens( cText, ";" )

         if isArray( a )

            for each cText in a

               if !Empty( cText )

                  cField      := StrTran( cText, "&#34", "" ) // CutString( '&#34;', '&#34;', cText, .t. )

                  if !Empty( cField )

                     n        := aScan( ::aFields, {|a| a[ 6 ] == cField } )
                     if n != 0

                        do case
                           case ::aFields[ n, 2 ] == "C"
                              cExpresion     := ::aFields[ n, 1 ]

                           case ::aFields[ n, 2 ] == "N"
                              cExpresion     := "Str( " +  ::aFields[ n, 1 ] + " )"
                              lDescendente   := .t.

                           case ::aFields[ n, 2 ] == "D"
                              cExpresion     := "Dtos( " +  ::aFields[ n, 1 ] + " )"

                        end case

                        if Empty( cIndex )
                           cIndex   := cExpresion
                        else
                           cIndex   += " + " + cExpresion
                        end if

                     end if

                  end if

               end if

            next

         end if

      end if

      if !empty( cIndex )
         ::oDbf:AddTmpIndex( "Grupos", ( ::cFileIndx ), ( cIndex ), , , , ( lDescendente ), , , , , .t. )
      end if

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SaveReportAs() CLASS TFastReportInfGen

   local oDlg
   local oNombre
   local cNombre        := Padr( QuitBrackets( ::cReportName ), 200 )
   local oBmpGeneral

   DEFINE DIALOG oDlg RESOURCE "ADD_FAVORITOS" TITLE "Nuevo " + Alltrim( Lower( ::cReportType ) )

      REDEFINE BITMAP   oBmpGeneral ;
         ID             500 ;
         RESOURCE       "gc_form_plus2_48" ;
         TRANSPARENT ;
         OF             oDlg

      REDEFINE GET      oNombre ;
         VAR            cNombre ;
         ID             100 ;
         OF             oDlg

      REDEFINE BUTTON ;
         ID             IDOK ;
         OF             oDlg ;
         ACTION         ( ::EndSaveReportAs( cNombre, oDlg ) )

      REDEFINE BUTTON ;
         ID             IDCANCEL ;
         OF             oDlg ;
         ACTION         ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| ::EndSaveReportAs( cNombre, oDlg ) } )

   ACTIVATE DIALOG oDlg CENTER

   oBmpGeneral:End()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD EndSaveReportAs( cNombre, oDlg ) CLASS TFastReportInfGen

   if Empty( cNombre )

      MsgStop( "Nombre del informe no puede estar vacio" )

   else

      ::cReportName  := cNombre

      oDlg:End( IDOK )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoadPersonalizado() CLASS TFastReportInfGen
/*
   local oItem

   if !Empty( ::oTreePersonalizados )

      ::oTreePersonalizados:DeleteAll()

      ::BuildTree( ::oTreePersonalizados, .f. )

      if ::oDbfPersonalizado:Seek( ::ClassName() )

         while ( Rtrim( ::oDbfPersonalizado:cClsInf ) == ::ClassName() ) .and. !( ::oDbfPersonalizado:Eof() )

            oItem    := ::oTreePersonalizados:GetText( Alltrim( ::oDbfPersonalizado:cTypInf ) )

            if IsObject( oItem )
               oItem:Add( Alltrim( ::oDbfPersonalizado:cNomInf ), oItem:nImage, Alltrim( ::oDbfPersonalizado:cTypInf ) )
               oItem:Expand()
            end if

            ::oDbfPersonalizado:Skip()

         end while

      end if

      ::oTreePersonalizados:Expand()

   end if
*/
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Eliminar() CLASS TFastReportInfGen

   if !::lLoadInfo()
      msgStop( "No se ha podido cargar el nombre del informe." )
      Return ( .f. )
   end if

   if ApoloMsgNoYes( "¿Desea eliminar el informe " + ::cReportName + "?", "Confirme supresión" )

      // Elimina el fichero----------------------------------------------------

      fErase( ::cReportFile )

      // Elimina rama del arbol------------------------------------------------

      ::oReportTree:End()

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lLoadInfo() CLASS TFastReportInfGen

   local oTreeInforme      := ::oTreeReporting:GetSelected()

   if empty( oTreeInforme ) 
      Return ( .f. )
   end if

   /*
   Obtenemos los datos necesarios para el informe------------------------------
   */

   if !hb_isHash( oTreeInforme:bAction ) 
      Return ( .f. )
   end if 


   if hHasKey( oTreeInforme:bAction, "Title" ) .and. hHasKey( oTreeInforme:bAction, "Type" ) .and. hHasKey( oTreeInforme:bAction, "File" )

      ::oReportTree        := oTreeInforme

      ::cReportType        := oTreeInforme:bAction[ "Type" ]
      ::cReportDirectory   := oTreeInforme:bAction[ "Directory" ]
      ::cReportName        := oTreeInforme:bAction[ "Title" ] 
      ::cReportFile        := oTreeInforme:bAction[ "Directory" ] + "\" + oTreeInforme:bAction[ "File" ]

      if hhaskey( oTreeInforme:bAction, "Options" )
         ::hReportOptions  := oTreeInforme:bAction[ "Options" ]
      else
         ::hReportOptions  := nil
      end if 

      ::lUserDefine        := ( left( oTreeInforme:bAction[ "File" ], 1 ) == "[" )
      ::lSummary           := ( upper( "\Estadisticas" ) $ upper( oTreeInforme:bAction[ "Directory" ] ) )

   else 
      
      Return ( .f. )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD lLoadReport() CLASS TFastReportInfGen

   ::cInformeFastReport          := ""

   // Report por nombre del fichero ----------------------------------------------

   if File( ::cReportFile )
      ::cInformeFastReport       := memoread( ::cReportFile )
   end if

RETURN ( !Empty( ::cInformeFastReport ) )

//---------------------------------------------------------------------------//

METHOD GetFieldByDescription( cDescription )

   local nPos
   local cField

   nPos                 := aScan( ::oDbf:aTField, { | oFld | oFld:cComment == cDescription } )
   if ( nPos != 0 )
      cField            := ::oDbf:aTField[ nPos ]:cName
   end if

RETURN ( cField )

//---------------------------------------------------------------------------//

METHOD DlgExportDocument( oWndBrw )

   local oDlg
   local oGetFile
   local cGetFile
   local oTreeInforme

   /*
   Vamos a obtener el nombre del informe---------------------------------------
   */

   oTreeInforme         := ::oTreePersonalizados:GetSelected()

   if IsArray( oTreeInforme:aItems ) .and. !Empty( oTreeInforme:aItems )
      msgStop( "Seleccione el nodo inferior." )
      Return ( Self )
   end if

   if IsChar( oTreeInforme:cPrompt ) .and. !Empty( oTreeInforme:cPrompt )
      ::cReportName     := Rtrim( oTreeInforme:cPrompt )
   else
      msgStop( "No se ha podido cargar el nombre del informe." )
      Return ( Self )
   end if

   if IsChar( oTreeInforme:bAction ) .and. !Empty( oTreeInforme:bAction )
      ::cReportType       := Rtrim( oTreeInforme:bAction )
   else
      Return ( Self )
   end if

   if ::oDbfPersonalizado:Seek( ::cReportKey() )
      if Empty( ::oDbfPersonalizado:mModInf )
         msgStop( "El informe esta vacio." )
         Return ( Self )
      end if
   else
      msgStop( "No se ha encontrado el informe." )
      Return ( Self )
   end if

   /*
   Ahora mostramos el dialogo si obtuvimos bien el informe---------------------
   */

   cGetFile             := Padr( FullCurDir() + "Informe.Dat", 100 )
 
   DEFINE DIALOG oDlg RESOURCE "ExpDocs" TITLE "Exportar documento"

      REDEFINE SAY PROMPT ::cReportType ;
         ID       100 ;
         OF       oDlg

      REDEFINE GET oGetFile VAR cGetFile ;
         ID       110 ;
         BITMAP   "Folder" ;
         ON HELP  ( oGetFile:cText( Padr( cGetFile( "*.Dat", "Seleccion de fichero" ), 100 ) ) ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:Disable(), ::ExportDocument( cGetFile ), oDlg:Enable() )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:Disable(), if( ::ExportDocument( cGetFile ), oDlg:Enable():End(), oDlg:Enable() ) } )

	ACTIVATE DIALOG oDlg CENTER

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ExportDocument( cGetFile )

   local nHandle
   local lErrors  := .f.

   ( ::oDbfPersonalizado:nArea )->( __dbCopy( cPatTmp() + "Exp.Dbf", , {|| Upper( ( ::oDbfPersonalizado:nArea )->cClsInf ) + Upper( Rtrim( ( ::oDbfPersonalizado:nArea )->cNomInf ) ) == Padr( ::ClassName(), 50 ) + Upper( Rtrim( ::cReportName ) ) }, , , , , cLocalDriver() ) )

   nHandle        := fCreate( cGetFile )
   if nHandle != -1

      if fClose( nHandle ) .and. ( fErase( cGetFile ) == 0 )

         hb_ZipFile( cGetFile, cPatTmp() + "Exp.Dbf", 9 )
         hb_ZipFile( cGetFile, cPatTmp() + "Exp.Fpt", 9 )

      else

         lErrors  := .t.

      end if

   end if

   fErase( cPatTmp() + "Exp.Dbf" )
   fErase( cPatTmp() + "Exp.Fpt" )

   if !lErrors
      msgInfo( "Documento " + Rtrim( cGetFile ) + " exportado satisfactoriamente." )
   else
      msgStop( "Error en la creación de fichero." )
   end if

Return ( !lErrors )

//---------------------------------------------------------------------------//

METHOD DlgImportDocument()

   local oDlg
   local oGetFile
   local cGetFile := Padr( FullCurDir() + "Exp.Dat", 100 )
   local oSayProc
   local cSayProc := ""

   DEFINE DIALOG oDlg RESOURCE "ImpDocs"

      REDEFINE GET oGetFile VAR cGetFile ;
         ID       100 ;
         BITMAP   "Folder" ;
         ON HELP  ( oGetFile:cText( Padr( cGetFile( "*.Dat", "Selección de fichero" ), 100 ) ) ) ;
			OF 		oDlg

      REDEFINE SAY oSayProc PROMPT cSayProc ;
         ID       110 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:Disable(), ::ImportDocument( cGetFile, oSayProc ), oDlg:Enable() )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:Disable(), ::ImportDocument( cGetFile, oSayProc ), oDlg:Enable() } )

	ACTIVATE DIALOG oDlg CENTER

Return ( nil  )

//---------------------------------------------------------------------------//

METHOD ImportDocument( cGetFile, oSayProc )

   local aFiles
   local oBlock
   local oError

   cGetFile       := Rtrim( cGetFile )

   if !File( cGetFile )
      MsgStop( "El fichero " + cGetFile + " no existe." )
      Return .f.
   end if

   aFiles         := Hb_GetFilesInZip( cGetFile )

   if !hb_UnZipFile( cGetFile, , , , cPatTmp(), aFiles )
      MsgStop( "No se ha descomprimido el fichero " + cGetFile + ".", "Error" )
      Return .f.
   end if
   hb_gcAll()

   if !File( cPatTmp() + "Exp.Dbf" ) .or. !File( cPatTmp() + "Exp.Fpt"   )
      MsgStop( "Faltan ficheros para importar el documento." )
      Return .f.
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      oSayProc:SetText( "Importando documento" )

      DATABASE NEW ::oExt PATH ( cPatTmp() ) FILE "Exp.Dbf" VIA ( cLocalDriver() )

      while !( ::oExt:Eof() )

         if Rtrim( ::oExt:cClsInf ) == Rtrim( ::ClassName() )

            if ::oDbfPersonalizado:Seek( Upper( ::oExt:cClsInf ) + Upper( ::oExt:cNomInf ) )
               ::oDbfPersonalizado:Delete()
            end if

            ::oDbfPersonalizado:AppendFromObject( ::oExt )

         else

            MsgStop( "El documento a importar no es del mismo tipo." )

         end if

         ::oExt:Skip()

      end while

      oSayProc:SetText( "Documento importado satisfactoriamente." )

   RECOVER USING oError

      msgStop( "Error importando documento." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( ::oExt )
      ::oExt:End()
   end if

   fErase( cPatTmp() + "Exp.Dbf" )
   fErase( cPatTmp() + "Exp.Fpt" )

   ::LoadPersonalizado()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD BuildNode( aReports, oTree, lLoadFile )

   local hHash
   local oNode
   local aFile 
   local cType
   local aDirectory

   for each hHash in aReports
      
      if !Empty( hHash )

         oNode          := oTree:Add( hHash[ "Title" ], hHash[ "Image" ], hHash ) 

         if lLoadFile .and. hHasKey( hHash, "Directory" ) 

            // Directorio de la aplicacion-------------------------------------

            ::AddNode( cPatReporting() + hHash[ "Directory" ], hHash, oNode )

            // Directorio de el usuario----------------------------------------

            ::AddNode( cPatUserReporting() + hHash[ "Directory" ], hHash, oNode, .t. )

         end if 

         if hHasKey( hHash, "Subnode" )
            ::BuildNode( hHash[ "Subnode" ], oNode, lLoadFile )
            oNode:Expand() 
         end if 

      end if 

   next 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nRemesaAgentes()

   local cExpHead

   if Empty( ::oRemAgeT )
      DATABASE NEW ::oRemAgeT PATH ( cPatEmp() ) CLASS "RemAgeT" FILE "RemAgeT.DBF" VIA ( cDriver() ) SHARED INDEX "RemAgeT.CDX"
   end if

   ::oRemAgeT:OrdSetFocus( "dFecCob" )

   cExpHead          := 'dFecCob >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecCob <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   ::oRemAgeT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oRemAgeT:cFile ), ::oRemAgeT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando liquidaciones de agentes"
   ::oMtrInf:SetTotal( ::oRemAgeT:OrdKeyCount() )

   ::oRemAgeT:GoTop()

   while !::lBreak .and. !::oRemAgeT:Eof()

      if ( ::oRemAgeT:cCodAge >= ::oGrupoAgente:Cargo:Desde .and. ::oRemAgeT:cCodAge <= ::oGrupoAgente:Cargo:Hasta )
         ::nTotalRemesasAgentes  += ::oRemAgeT:nTotCob
      end if

      ::oRemAgeT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oRemAgeT:IdxDelete( cCurUsr(), GetFileNoExt( ::oRemAgeT:cFile ) )

RETURN ( ::nTotalRemesasAgentes )

//---------------------------------------------------------------------------//

METHOD nFacturaClientes()

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD nPagosClientes()

RETURN ( 0 )

//---------------------------------------------------------------------------//

METHOD SyncAllDbf()

   if Empty( ::oDbfInf )
      ::DefineReport()
   end if

   lCheckDbf( ::oDbfInf )

RETURN ( Self )

//---------------------------------------------------------------------------//

/*
SAT----------------------------------------------------------------------------
*/

METHOD FastReportSATCliente()
      
   ( D():SATClientes( ::nView ) )->( ordsetfocus( "iNumSat" ) )
      
   ::oFastReport:SetWorkArea(       "SAT de clientes", ( D():SATClientes( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "SAT de clientes", cItemsToReport( aItmSatCli() ) )
      
   ( D():SATClientesLineas( ::nView ) )->( ordsetfocus( "iNumSat" ) )
      
   ::oFastReport:SetWorkArea(       "Lineas SAT de clientes", ( D():SATClientesLineas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Lineas SAT de clientes", cItemsToReport( aColSatCli() ) )
   
   ::oFastReport:SetMasterDetail(   "Informe", "SAT de clientes",          {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas SAT de clientes",   {|| ::IdDocumentoLinea() } )
   
   ::oFastReport:SetResyncPair(     "Informe", "SAT de clientes" )

   ::oFastReport:SetResyncPair(     "Informe", "Lineas SAT de clientes" )

RETURN ( Self )

/*
Presupuestos----------------------------------------------------------------
*/

METHOD FastReportPresupuestoCliente()
      
   ( D():PresupuestosClientes( ::nView ) )->( ordsetfocus( "iNumPre" ) )

   ::oFastReport:SetWorkArea(       "Presupuestos de clientes", ( D():PresupuestosClientes( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Presupuestos de clientes", cItemsToReport( aItmPreCli() ) )

   ( D():PresupuestosClientesLineas( ::nView ) )->( ordsetfocus( "iNumPre" ) )
   ::oFastReport:SetWorkArea(       "Lineas presupuestos de clientes", ( D():PresupuestosClientesLineas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Lineas presupuestos de clientes", cItemsToReport( aColPreCli() ) )

   ::oFastReport:SetMasterDetail(   "Informe", "Presupuestos de clientes",          {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas presupuestos de clientes",   {|| ::IdDocumentoLinea() } )

   ::oFastReport:SetResyncPair(     "Informe", "Presupuestos de clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Lineas presupuestos de clientes" )

RETURN ( Self )

/*
Pedidos---------------------------------------------------------------------
*/

METHOD FastReportPedidoCliente()
      
   ( D():PedidosClientes( ::nView ) )->( ordsetfocus( "iNumPed" ) )
      
   ::oFastReport:SetWorkArea(       "Pedidos de clientes", ( D():PedidosClientes( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Pedidos de clientes", cItemsToReport( aItmPedCli() ) )
      
   ( D():PedidosClientesLineas( ::nView ) )->( ordsetfocus( "iNumPed" ) )
      
   ::oFastReport:SetWorkArea(       "Lineas pedidos de clientes", ( D():PedidosClientesLineas( ::nView ) )->( select() ) ) 
   ::oFastReport:SetFieldAliases(   "Lineas pedidos de clientes", cItemsToReport( aColPedCli() ) )

   ::oFastReport:SetMasterDetail(   "Informe", "Pedidos de clientes",         {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas pedidos de clientes",  {|| ::IdDocumentoLinea() } )

   ::oFastReport:SetResyncPair(     "Informe", "Pedidos de clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Lineas pedidos de clientes" )

RETURN ( Self )

/*
Albaranes-------------------------------------------------------------------
*/

METHOD FastReportAlbaranCliente()

   ( D():AlbaranesClientes( ::nView ) )->( ordsetfocus( "iNumAlb" ) )
   
   ::oFastReport:SetWorkArea(       "Albaranes de clientes", ( D():AlbaranesClientes( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Albaranes de clientes", cItemsToReport( aItmAlbCli() ) )
   
   ( D():AlbaranesClientesLineas( ::nView ) )->( ordSetFocus( "iNumAlb" ) )
   
   ::oFastReport:SetWorkArea(       "Lineas albaranes de clientes", ( D():AlbaranesClientesLineas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Lineas albaranes de clientes", cItemsToReport( aColAlbCli() ) )
   
   ::oFastReport:SetMasterDetail(   "Informe", "Albaranes de clientes",          {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas albaranes de clientes",   {|| ::IdDocumentoLinea() } )
   
   ::oFastReport:SetResyncPair(     "Informe", "Albaranes de clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Lineas albaranes de clientes" )

RETURN ( Self )

/*
Facturas--------------------------------------------------------------------
*/

METHOD FastReportFacturaCliente()

   ( D():FacturasClientes( ::nView ) )->( ordsetfocus( "iNumFac" ) )
   
   ::oFastReport:SetWorkArea(       "Facturas de clientes", ( D():FacturasClientes( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Facturas de clientes", cItemsToReport( aItmFacCli() ) )
   
   ( D():FacturasClientesLineas( ::nView ) )->( ordsetfocus( "iNumFac" ) )
   
   ::oFastReport:SetWorkArea(       "Lineas facturas de clientes", ( D():FacturasClientesLineas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Lineas facturas de clientes", cItemsToReport( aColFacCli() ) )
   
   ::oFastReport:SetMasterDetail(   "Informe", "Facturas de clientes",        {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas facturas de clientes", {|| ::IdDocumentoLinea() } )
   
   ::oFastReport:SetResyncPair(     "Informe", "Facturas de clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Lineas facturas de clientes" )

RETURN ( Self )

/*
Rectificativas--------------------------------------------------------------
*/

METHOD FastReportFacturaRectificativa()

   ( D():FacturasRectificativas( ::nView ) )->( ordsetfocus( "iNumFac" ) )
   
   ::oFastReport:SetWorkArea(       "Facturas rectificativas de clientes", ( D():FacturasRectificativas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Facturas rectificativas de clientes", cItemsToReport( aItmFacRec() ) )
   
   ( D():FacturasRectificativasLineas( ::nView ) )->( ordsetfocus( "iNumFac" ) )
   
   ::oFastReport:SetWorkArea(       "Lineas facturas rectificativas de clientes", ( D():FacturasRectificativasLineas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Lineas facturas rectificativas de clientes", cItemsToReport( aColFacRec() ) )
   
   ::oFastReport:SetMasterDetail(   "Informe", "Facturas rectificativas de clientes",        {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas facturas rectificativas de clientes", {|| ::IdDocumentoLinea() } )
   
   ::oFastReport:SetResyncPair(     "Informe", "Facturas rectificativas de clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Lineas facturas rectificativas de clientes" )

RETURN ( Self )

/*
Tiket--------------------------------------------------------------------------
*/

METHOD FastReportTicket()

   ( D():Tikets( ::nView ) )->( ordsetfocus( "iNumTik" ) )
   
   ::oFastReport:SetWorkArea(       "Tickets de clientes", ( D():Tikets( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Tickets de clientes", cItemsToReport( aItmTik() ) )
   
   ( D():TiketsLineas( ::nView ) )->( ordsetfocus( "iNumTik" ) )
   
   ::oFastReport:SetWorkArea(       "Lineas tickets de clientes", ( D():TiketsLineas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Lineas tickets de clientes", cItemsToReport( aColTik() ) )
   
   ::oFastReport:SetMasterDetail(   "Informe", "Tickets de clientes",         {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas tickets de clientes",  {|| ::IdDocumentoLinea() } )
   
   ::oFastReport:SetResyncPair(     "Informe", "Tickets de clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Lineas tickets de clientes" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FastReportRecibosCliente()

   ( D():FacturasClientesCobros( ::nView ) )->( ordsetfocus( "iNumFac" ) )
   
   ::oFastReport:SetWorkArea(       "Recibos de clientes", ( D():FacturasClientesCobros( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Recibos de clientes", cItemsToReport( aItmRecCli() ) )

   ::oFastReport:SetMasterDetail(   "Informe", "Recibos de clientes",   {|| ::idDocumento() + ::oDbf:cNumRec } )
   ::oFastReport:SetResyncPair(     "Informe", "Recibos de clientes" )

RETURN ( Self )

/*
Produccion--------------------------------------------------------------------------
*/

METHOD FastReportParteProduccion()

   ::oProCab:OrdSetFocus( "iNumOrd" )
   
   ::oFastReport:SetWorkArea(       "Partes de producción", ::oProCab:nArea )
   ::oFastReport:SetFieldAliases(   "Partes de producción", cObjectsToReport( TProduccion():DefineFiles() ) )
    
   ( D():PartesProduccionMaterial( ::nView ) )->( OrdSetFocus( "iNumOrd" ) )
   
   ::oFastReport:SetWorkArea(       "Lineas partes de producción", ( D():PartesProduccionMaterial( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Lineas partes de producción", cObjectsToReport( TDetProduccion():DefineFiles() ) )
  
   ( D():PartesProduccionMateriaPrima( ::nView ) )->( OrdSetFocus( "iNumOrd" ) )

   ::oFastReport:SetWorkArea(       "Materia prima", ( D():PartesProduccionMateriaPrima( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Materia prima", cObjectsToReport( TDetMaterial():DefineFiles() ) )
   
   ::oFastReport:SetMasterDetail(   "Informe", "Partes de producción",              {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas partes de producción",       {|| ::IdDocumentoLinea() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Materia prima",                     {|| ::IdDocumentoLinea() } )
   
   ::oFastReport:SetResyncPair(     "Informe", "Partes de producción" )
   ::oFastReport:SetResyncPair(     "Informe", "Lineas partes de producción" )
   ::oFastReport:SetResyncPair(     "Informe", "Materia prima" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FastReportPedidoProveedor()
      
   ( D():PedidosProveedores( ::nView ) )->( ordsetfocus( "iNumPed" ) )
      
   ::oFastReport:SetWorkArea(       "Pedidos de proveedor", ( D():PedidosProveedores( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Pedidos de proveedor", cItemsToReport( aItmPedPrv() ) )
      
   ( D():PedidosProveedoresLineas( ::nView ) )->( ordsetfocus( "iNumPed" ) )

   ::oFastReport:SetWorkArea(       "Lineas pedidos de proveedor", ( D():PedidosProveedoresLineas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Lineas pedidos de proveedor", cItemsToReport( aColPedPrv() ) )

   ::oFastReport:SetMasterDetail(   "Informe", "Pedidos de proveedor",               {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas pedidos de proveedor",        {|| ::IdDocumentoLinea() } )

   ::oFastReport:SetResyncPair(     "Informe", "Pedidos de proveedor" )
   ::oFastReport:SetResyncPair(     "Informe", "Lineas pedidos de proveedor" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FastReportAlbaranProveedor()
      
   ( D():AlbaranesProveedores( ::nView ) )->( ordsetfocus( "iNumAlb" ) )
      
   ::oFastReport:SetWorkArea(       "Albaranes de proveedor", ( D():AlbaranesProveedores( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Albaranes de proveedor", cItemsToReport( aItmAlbPrv() ) )
      
   ( D():AlbaranesProveedoresLineas( ::nView ) )->( ordsetfocus( "iNumAlb" ) )
      
   ::oFastReport:SetWorkArea(       "Lineas albaranes de proveedor", ( D():AlbaranesProveedoresLineas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Lineas albaranes de proveedor", cItemsToReport( aColAlbPrv() ) )

   ::oFastReport:SetMasterDetail(   "Informe", "Albaranes de proveedor",               {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas albaranes de proveedor",        {|| ::IdDocumentoLinea() } )

   ::oFastReport:SetResyncPair(     "Informe", "Albaranes de proveedor" )
   ::oFastReport:SetResyncPair(     "Informe", "Lineas albaranes de proveedor" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FastReportFacturaProveedor()
      
   ( D():FacturasProveedores( ::nView ) )->( OrdSetFocus( "iNumFac" ) )
      
   ::oFastReport:SetWorkArea(       "Facturas de proveedor", ( D():FacturasProveedores( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Facturas de proveedor", cItemsToReport( aItmFacPrv() ) )
      
   ( D():FacturasProveedoresLineas( ::nView ) )->( OrdSetFocus( "iNumFac" ) )
      
   ::oFastReport:SetWorkArea(       "Lineas facturas de proveedor", ( D():FacturasProveedoresLineas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Lineas facturas de proveedor", cItemsToReport( aColFacPrv() ) )

   ::oFastReport:SetMasterDetail(   "Informe", "Facturas de proveedor",               {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas facturas de proveedor",        {|| ::IdDocumentoLinea() } )

   ::oFastReport:SetResyncPair(     "Informe", "Facturas de proveedor" )
   ::oFastReport:SetResyncPair(     "Informe", "Lineas facturas de proveedor" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FastReportRectificativaProveedor()
   
   ( D():FacturasRectificativasProveedores( ::nView ) )->( OrdSetFocus( "iNumRct" ) )
      
   ::oFastReport:SetWorkArea(       "Rectificativas de proveedor", ( D():FacturasRectificativasProveedores( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Rectificativas de proveedor", cItemsToReport( aItmRctPrv() ) )
   
   ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->( OrdSetFocus( "iNumRct" ) )
      
   ::oFastReport:SetWorkArea(       "Lineas rectificativas de proveedor", ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Lineas rectificativas de proveedor", cItemsToReport( aColRctPrv() ) )

   ::oFastReport:SetMasterDetail(   "Informe", "Rectificativas de proveedor",               {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas rectificativas de proveedor",        {|| ::IdDocumentoLinea() } )

   ::oFastReport:SetResyncPair(     "Informe", "Rectificativas de proveedor" )
   ::oFastReport:SetResyncPair(     "Informe", "Lineas rectificativas de proveedor" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FastReportStock()
   
   ::oFastReport:SetWorkArea(       "Artículos almacenes", ( D():ArticuloStockAlmacenes( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Artículos almacenes", cItemsToReport( aItmStockaAlmacenes() ) )
   
   ::oFastReport:SetMasterDetail(   "Informe", "Artículos almacenes",   {|| ::idArticuloAlmacen() } )

   ::oFastReport:SetResyncPair(     "Informe", "Artículos almacenes" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableArticulos()

   ::oFastReport:AddVariable(    "Campos extra",       "Primer campo extra",           "CallHbFunc( 'oTinfGen', ['ValorCampoExtra', 'Artículos', '001'])" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableSATCliente()

   ::oFastReport:AddVariable(    "SAT clientes",            "Total base SAT clientes",            "CallHbFunc( 'oTinfGen', ['nBaseSATClientes'])"    )
   ::oFastReport:AddVariable(    "SAT clientes",            "Total " + cImp() + " SAT clientes",  "CallHbFunc( 'oTinfGen', ['nIVASATClientes'])"     )
   ::oFastReport:AddVariable(    "SAT clientes",            "Total recargo SAT clientes",         "CallHbFunc( 'oTinfGen', ['nRecargoSATClientes'])" )
   ::oFastReport:AddVariable(    "SAT clientes",            "Total SAT clientes",                 "CallHbFunc( 'oTinfGen', ['nTotalSATClientes'])"   )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableLineasSATCliente()

   ::oFastReport:AddVariable(    "Lineas de SAT",    "Detalle del artículo",                        "CallHbFunc( 'oTinfGen', ['cDetalleSATClientes'])"                       )
   ::oFastReport:AddVariable(    "Lineas de SAT",    "Total unidades artículo",                     "CallHbFunc( 'oTinfGen', ['nTotalUnidadesSATClientes'])"                 )
   ::oFastReport:AddVariable(    "Lineas de SAT",    "Precio unitario del artículo",                "CallHbFunc( 'oTinfGen', ['nPrecioUnitarioSATClientes'])"                )
   ::oFastReport:AddVariable(    "Lineas de SAT",    "Total línea de SAT",                          "CallHbFunc( 'oTinfGen', ['nTotalLineaSATClientes'])"                    )
   ::oFastReport:AddVariable(    "Lineas de SAT",    "Total peso por línea",                        "CallHbFunc( 'oTinfGen', ['nTotalPesoLineaSATClientes'])"                )
   ::oFastReport:AddVariable(    "Lineas de SAT",    "Total impuestos incluidos línea del SAT",     "CallHbFunc( 'oTinfGen', ['nTotalImpuestosIncluidosLineaSATClientes'])"  )
   ::oFastReport:AddVariable(    "Lineas de SAT",    "Total  IVA línea del SAT",                    "CallHbFunc( 'oTinfGen', ['nTotalIVALineaSATClientes'])"                 )

   ::oFastReport:AddVariable(    "Lineas de SAT",    "Total descuento porcentual artículo",         "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPorcentualLineaSATClientes'])" )
   ::oFastReport:AddVariable(    "Lineas de SAT",    "Total descuento promocional artículo",        "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPromocionalLineaSATClientes'])")

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariablePresupuestoCliente()

   ::oFastReport:AddVariable(    "Presupuestos clientes",   "Total base presupuestos clientes",             "CallHbFunc( 'oTinfGen', ['nBasePresupuestosClientes'])"    )
   ::oFastReport:AddVariable(    "Presupuestos clientes",   "Total " + cImp() + " presupuestos clientes",   "CallHbFunc( 'oTinfGen', ['nIVAPresupuestosClientes'])"     )
   ::oFastReport:AddVariable(    "Presupuestos clientes",   "Total recargo presupuestos clientes",          "CallHbFunc( 'oTinfGen', ['nRecargoPresupuestosClientes'])" )
   ::oFastReport:AddVariable(    "Presupuestos clientes",   "Total presupuestos clientes",                  "CallHbFunc( 'oTinfGen', ['nTotalPresupuestosClientes'])"   )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableLineasPresupuestoCliente()

   ::oFastReport:AddVariable(     "Lineas de presupuestos",   "Detalle del artículo",                              "CallHbFunc( 'oTInfGen', ['cDetallePresupuestoClientes'])"                       )
   ::oFastReport:AddVariable(     "Lineas de presupuestos",   "Total unidades artículo",                           "CallHbFunc( 'oTInfGen', ['nTotalUnidadesPresupuestosClientes'])"                )
   ::oFastReport:AddVariable(     "Lineas de presupuestos",   "Precio unitario del artículo",                      "CallHbFunc( 'oTInfGen', ['nPrecioUnitarioPresupuestosClientes'])"               )
   ::oFastReport:AddVariable(     "Lineas de presupuestos",   "Total línea de presupuesto",                        "CallHbFunc( 'oTInfGen', ['nTotalLineaPresupuestosClientes'])"                   )
   ::oFastReport:AddVariable(     "Lineas de presupuestos",   "Total peso por línea",                              "CallHbFunc( 'oTInfGen', ['nTotalPesoLineaPresupuestosClientes'])"               )
   ::oFastReport:AddVariable(     "Lineas de presupuestos",   "Total impuestos incluidos línea del presupuesto",   "CallHbFunc( 'oTInfGen', ['nTotalImpuestosIncluidosLineaPresupuestosClientes'])" )
   ::oFastReport:AddVariable(     "Lineas de presupuestos",   "Total IVA línea del presupuesto",                   "CallHbFunc( 'oTInfGen', ['nTotalIVALineaPresupuestosClientes'])"                )

   ::oFastReport:AddVariable(     "Lineas de presupuestos",   "Total descuento porcentual artículo",               "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPorcentualLineaPresupuestosClientes'])" )
   ::oFastReport:AddVariable(     "Lineas de presupuestos",   "Total descuento promocional artículo",              "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPromocionalLineaPresupuestosClientes'])")

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariablePedidoCliente()

   ::oFastReport:AddVariable(    "Pedidos clientes",        "Total base pedidos clientes",            "CallHbFunc( 'oTinfGen', ['nBasePedidosClientes'])"    )
   ::oFastReport:AddVariable(    "Pedidos clientes",        "Total " + cImp() + " pedidos clientes",  "CallHbFunc( 'oTinfGen', ['nIVAPedidosClientes'])"     )
   ::oFastReport:AddVariable(    "Pedidos clientes",        "Total recargo pedidos clientes",         "CallHbFunc( 'oTinfGen', ['nRecargoPedidosClientes'])" )
   ::oFastReport:AddVariable(    "Pedidos clientes",        "Total pedidos clientes",                 "CallHbFunc( 'oTinfGen', ['nTotalPedidosClientes'])"   )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableLineasPedidoCliente()
   ::oFastReport:AddVariable(     "Lineas de pedidos",   "Detalle del artículo",                         "CallHbFunc( 'oTInfGen', ['cDetallePedidosClientes'])"                      )
   ::oFastReport:AddVariable(     "Lineas de pedidos",   "Total unidades artículo",                      "CallHbFunc( 'oTInfGen', ['nTotalUnidadesPedidosClientes'])"                )
   ::oFastReport:AddVariable(     "Lineas de pedidos",   "Precio unitario del artículo",                 "CallHbFunc( 'oTInfGen', ['nPrecioUnitarioPedidosClientes'])"               )
   ::oFastReport:AddVariable(     "Lineas de pedidos",   "Total línea de pedido",                        "CallHbFunc( 'oTInfGen', ['nTotalLineaPedidosClientes'])"                   )
   ::oFastReport:AddVariable(     "Lineas de pedidos",   "Total peso por línea",                         "CallHbFunc( 'oTInfGen', ['nTotalPesoLineaPedidosClientes'])"               )
   ::oFastReport:AddVariable(     "Lineas de pedidos",   "Total impuestos incluidos línea del pedido",   "CallHbFunc( 'oTInfGen', ['nTotalImpuestosIncluidosLineaPedidosClientes'])" )
   ::oFastReport:AddVariable(     "Lineas de pedidos",   "Total IVA línea del pedido",                   "CallHbFunc( 'oTInfGen', ['nTotalIVALineaPedidosClientes'])"                )      

   ::oFastReport:AddVariable(     "Lineas de pedidos",   "Total descuento porcentual artículo",          "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPorcentualLineaPedidosClientes'])" )
   ::oFastReport:AddVariable(     "Lineas de pedidos",   "Total descuento promocional artículo",         "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPromocionalLineaPedidosClientes'])")
   ::oFastReport:AddVariable(     "Lineas de pedidos",   "Total comision agente",                        "CallHbFunc( 'oTinfGen', ['nTotalComisionAgentes'])")


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableAlbaranCliente()

   ::oFastReport:AddVariable(    "Albaranes clientes",      "Total base albaranes clientes",          "CallHbFunc( 'oTinfGen', ['nBaseAlbaranesClientes'])"    )
   ::oFastReport:AddVariable(    "Albaranes clientes",      "Total " + cImp() + " albaranes clientes","CallHbFunc( 'oTinfGen', ['nIVAAlbaranesClientes'])"     )
   ::oFastReport:AddVariable(    "Albaranes clientes",      "Total recargo albaranes clientes",       "CallHbFunc( 'oTinfGen', ['nRecargoAlbaranesClientes'])" )
   ::oFastReport:AddVariable(    "Albaranes clientes",      "Total albaranes clientes",               "CallHbFunc( 'oTinfGen', ['nTotalAlbaranesClientes'])"   )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableLineasAlbaranCliente()

   ::oFastReport:AddVariable(     "Lineas de albaranes",   "Detalle del artículo",                         "CallHbFunc( 'oTInfGen', ['cDetalleAlbaranesClientes'])"                      )
   ::oFastReport:AddVariable(     "Lineas de albaranes",   "Total unidades artículo",                      "CallHbFunc( 'oTInfGen', ['nTotalUnidadesAlbaranesClientes'])"                )
   ::oFastReport:AddVariable(     "Lineas de albaranes",   "Precio unitario del artículo",                 "CallHbFunc( 'oTInfGen', ['nPrecioUnitarioAlbaranesClientes'])"               )
   ::oFastReport:AddVariable(     "Lineas de albaranes",   "Total línea de albaran",                       "CallHbFunc( 'oTInfGen', ['nTotalLineaAlbaranesClientes'])"                   )
   ::oFastReport:AddVariable(     "Lineas de albaranes",   "Total peso por línea",                         "CallHbFunc( 'oTInfGen', ['nTotalPesoLineaAlbaranesClientes'])"               )
   ::oFastReport:AddVariable(     "Lineas de albaranes",   "Total impuestos incluidos línea del albaran",  "CallHbFunc( 'oTInfGen', ['nTotalImpuestosIncluidosLineaAlbaranesClientes'])" )
   ::oFastReport:AddVariable(     "Lineas de albaranes",   "Total IVA línea del albaran",                  "CallHbFunc( 'oTInfGen', ['nTotalIVALineaAlbaranesClientes'])"                )      

   ::oFastReport:AddVariable(     "Lineas de albaranes",   "Total descuento porcentual artículo",          "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPorcentualLineaAlbaranesClientes'])" )
   ::oFastReport:AddVariable(     "Lineas de albaranes",   "Total descuento promocional artículo",         "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPromocionalLineaAlbaranesClientes'])")

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableFacturaCliente()

   ::oFastReport:AddVariable(    "Facturas clientes",       "Total base facturas clientes",           "CallHbFunc( 'oTinfGen', ['nBaseFacturasClientes'])"     )
   ::oFastReport:AddVariable(    "Facturas clientes",       "Total " + cImp() + " facturas clientes", "CallHbFunc( 'oTinfGen', ['nIVAFacturasClientes'])"      )
   ::oFastReport:AddVariable(    "Facturas clientes",       "Total recargo facturas clientes",        "CallHbFunc( 'oTinfGen', ['nRecargoFacturasClientes'])"  )
   ::oFastReport:AddVariable(    "Facturas clientes",       "Total facturas clientes",                "CallHbFunc( 'oTinfGen', ['nTotalFacturasClientes'])"    )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableRecibosCliente()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableLineasFacturaCliente()

   ::oFastReport:AddVariable(     "Lineas de facturas",   "Detalle del artículo línea de factura",                      "CallHbFunc( 'oTInfGen', ['cDetalleFacturasClientes'])"                       )
   ::oFastReport:AddVariable(     "Lineas de facturas",   "Total unidades artículo línea de factura",                   "CallHbFunc( 'oTInfGen', ['nTotalUnidadesFacturasClientes'])"                 )
   ::oFastReport:AddVariable(     "Lineas de facturas",   "Precio unitario del artículo línea de factura",              "CallHbFunc( 'oTInfGen', ['nPrecioUnitarioFacturasClientes'])"                )
   ::oFastReport:AddVariable(     "Lineas de facturas",   "Total línea de factura",                                     "CallHbFunc( 'oTInfGen', ['nTotalLineaFacturasClientes'])"                    )
   ::oFastReport:AddVariable(     "Lineas de facturas",   "Total peso por línea de factura",                            "CallHbFunc( 'oTInfGen', ['nTotalPesoLineaFacturasClientes'])"                )
   ::oFastReport:AddVariable(     "Lineas de facturas",   "Total impuestos incluidos línea de factura",                 "CallHbFunc( 'oTInfGen', ['nTotalImpuestosIncluidosLineaFacturasClientes'])"  )
   ::oFastReport:AddVariable(     "Lineas de facturas",   "Total IVA línea de factura",                                 "CallHbFunc( 'oTInfGen', ['nTotalIVALineaFacturasClientes'])"                 )      

   ::oFastReport:AddVariable(     "Lineas de facturas",   "Total descuento porcentual artículo línea de factura",      "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPorcentualLineaFacturasClientes'])" )
   ::oFastReport:AddVariable(     "Lineas de facturas",   "Total descuento promocional artículo línea de factura",     "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPromocionalLineaFacturasClientes'])")

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableRectificativaCliente()

   ::oFastReport:AddVariable(    "Rectificativas clientes",       "Total base rectificativas clientes",           "CallHbFunc( 'oTinfGen', ['nBaseFacturasRectificativasClientes'])"     )
   ::oFastReport:AddVariable(    "Rectificativas clientes",       "Total " + cImp() + " rectificativas clientes", "CallHbFunc( 'oTinfGen', ['nIVAFacturasRectificativasClientes'])"      )
   ::oFastReport:AddVariable(    "Rectificativas clientes",       "Total recargo rectificativas clientes",        "CallHbFunc( 'oTinfGen', ['nRecargoFacturasRectificativasClientes'])"  )
   ::oFastReport:AddVariable(    "Rectificativas clientes",       "Total rectificativas clientes",                "CallHbFunc( 'oTinfGen', ['nTotalFacturasRectificativasClientes'])"    )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableLineasRectificativaCliente()

   ::oFastReport:AddVariable(     "Lineas de rectificativas",   "Detalle del artículo línea de rectificativa",                   "CallHbFunc( 'oTInfGen', ['cDetalleRectificativasClientes'])"                       )
   ::oFastReport:AddVariable(     "Lineas de rectificativas",   "Total unidades artículo línea de rectificativa",                "CallHbFunc( 'oTInfGen', ['nTotalUnidadesRectificativasClientes'])"                 )
   ::oFastReport:AddVariable(     "Lineas de rectificativas",   "Precio unitario del artículo línea de rectificativa",           "CallHbFunc( 'oTInfGen', ['nPrecioUnitarioRectificativasClientes'])"                )
   ::oFastReport:AddVariable(     "Lineas de rectificativas",   "Total línea de rectificativa",                                  "CallHbFunc( 'oTInfGen', ['nTotalLineaRectificativasClientes'])"                    )
   ::oFastReport:AddVariable(     "Lineas de rectificativas",   "Total peso por línea de rectificativa",                         "CallHbFunc( 'oTInfGen', ['nTotalPesoLineaRectificativasClientes'])"                )
   ::oFastReport:AddVariable(     "Lineas de rectificativas",   "Total impuestos incluidos línea de rectificativa",              "CallHbFunc( 'oTInfGen', ['nTotalImpuestosIncluidosLineaRectificativasClientes'])"  )
   ::oFastReport:AddVariable(     "Lineas de rectificativas",   "Total IVA línea de rectificativa",                              "CallHbFunc( 'oTInfGen', ['nTotalIVALineaRectificativasClientes'])"                 )      

   ::oFastReport:AddVariable(     "Lineas de rectificativas",   "Total descuento porcentual artículo línea de rectificativa",    "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPorcentualLineaRectificativasClientes'])" )
   ::oFastReport:AddVariable(     "Lineas de rectificativas",   "Total descuento promocional artículo línea de rectificativa",   "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPromocionalLineaRectificativasClientes'])")


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableTicketCliente()

   ::oFastReport:AddVariable(    "Tickets clientes",       "Total base tickets clientes",           "CallHbFunc( 'oTinfGen', ['nBaseTicketsClientes'])"     )
   ::oFastReport:AddVariable(    "Tickets clientes",       "Total " + cImp() + " tickets clientes", "CallHbFunc( 'oTinfGen', ['nIVATicketsClientes'])"      )
   ::oFastReport:AddVariable(    "Tickets clientes",       "Total recargo tickets clientes",        "CallHbFunc( 'oTinfGen', ['nRecargoTicketsClientes'])"  )
   ::oFastReport:AddVariable(    "Tickets clientes",       "Total tickets clientes",                "CallHbFunc( 'oTinfGen', ['nTotalTicketsClientes'])"    )

RETURN ( Self )

//---------------------------------------------------------------------------//


METHOD AddVariableLineasTicketCliente()

   ::oFastReport:AddVariable(     "Lineas de tickets",   "Detalle del artículo línea de ticket",                    "CallHbFunc( 'oTInfGen', ['cDetalleTicketsClientes'])"                         )
   ::oFastReport:AddVariable(     "Lineas de tickets",   "Total unidades artículo línea de ticket",                 "CallHbFunc( 'oTInfGen', ['nTotalUnidadesTicketsClientes'])"                   )
   ::oFastReport:AddVariable(     "Lineas de tickets",   "Precio unitario del artículo línea de ticket",            "CallHbFunc( 'oTInfGen', ['nPrecioUnitarioTicketsClientes'])"                  )
   ::oFastReport:AddVariable(     "Lineas de tickets",   "Total línea de ticket",                                   "CallHbFunc( 'oTInfGen', ['nTotalLineaTicketsClientes'])"                      )
   ::oFastReport:AddVariable(     "Lineas de tickets",   "Total peso por línea de ticket",                          "CallHbFunc( 'oTInfGen', ['nTotalPesoLineaTicketsClientes'])"                  )
   ::oFastReport:AddVariable(     "Lineas de tickets",   "Total impuestos incluidos línea de ticket",               "CallHbFunc( 'oTInfGen', ['nTotalImpuestosIncluidosLineaTicketsClientes'])"    )
   ::oFastReport:AddVariable(     "Lineas de tickets",   "Total IVA línea de ticket",                               "CallHbFunc( 'oTInfGen', ['nTotalIVALineaTicketsClientes'])"                   )      

   ::oFastReport:AddVariable(     "Lineas de tickets",   "Total descuento porcentual artículo línea de ticket",     "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPorcentualLineaTicketsClientes'])"   )   


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableLiquidacionAgentes()

      ::oFastReport:AddVariable(    "Liquidación de agentes",  "Total liquidación de agentes",           "GetHbVar('nTotalRemesasAgentes')"                       )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariablePedidoProveedor()

   ::oFastReport:AddVariable(    "Pedidos proveedores",        "Total base pedidos proveedores",            "CallHbFunc( 'oTinfGen', ['nBasePedidosProveedores'])"    )
   ::oFastReport:AddVariable(    "Pedidos proveedores",        "Total " + cImp() + " pedidos proveedores",  "CallHbFunc( 'oTinfGen', ['nIVAPedidosProveedores'])"     )
   ::oFastReport:AddVariable(    "Pedidos proveedores",        "Total recargo pedidos proveedores",         "CallHbFunc( 'oTinfGen', ['nRecargoPedidosProveedores'])" )
   ::oFastReport:AddVariable(    "Pedidos proveedores",        "Total pedidos proveedores",                 "CallHbFunc( 'oTinfGen', ['nTotalPedidosProveedores'])"   )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableLineasPedidoProveedor()

   ::oFastReport:AddVariable(     "Lineas de pedidos proveedores",   "Detalle del artículo línea del pedido de proveedor",                   "CallHbFunc( 'oTInfGen', ['cDetallePedidosProveedores'])"                         )
   ::oFastReport:AddVariable(     "Lineas de pedidos proveedores",   "Total unidades artículo línea del pedido de proveedor",                "CallHbFunc( 'oTInfGen', ['nTotalUnidadesPedidosProveedores'])"                   )
   ::oFastReport:AddVariable(     "Lineas de pedidos proveedores",   "Precio unitario del artículo línea del pedido de proveedor",           "CallHbFunc( 'oTInfGen', ['nPrecioUnitarioPedidosProveedores'])"                  )
   ::oFastReport:AddVariable(     "Lineas de pedidos proveedores",   "Total línea de pedido de proveedor",                                   "CallHbFunc( 'oTInfGen', ['nTotalLineaPedidosProveedores'])"                      )   
   ::oFastReport:AddVariable(     "Lineas de pedidos proveedores",   "Total impuestos incluidos línea del pedido de proveedor",              "CallHbFunc( 'oTInfGen', ['nTotalImpuestosIncluidosLineaPedidosProveedores'])"    )
   ::oFastReport:AddVariable(     "Lineas de pedidos proveedores",   "Total IVA línea del pedido de proveedor",                              "CallHbFunc( 'oTInfGen', ['nTotalIVALineaPedidosProveedores'])"                   )      
   ::oFastReport:AddVariable(     "Lineas de pedidos proveedores",   "Total descuento porcentual artículo línea del pedido de proveedor",    "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPorcentualLineaPedidosProveedores'])"   )
   ::oFastReport:AddVariable(     "Lineas de pedidos proveedores",   "Total descuento promocional artículo línea del pedido de proveedor",   "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPromocionalLineaPedidosProveedores'])"  )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableAlbaranProveedor()

   ::oFastReport:AddVariable(    "Albaranes proveedores",        "Total base albaranes proveedores",            "CallHbFunc( 'oTinfGen', ['nBaseAlbaranesProveedores'])"    )
   ::oFastReport:AddVariable(    "Albaranes proveedores",        "Total " + cImp() + " albaranes proveedores",  "CallHbFunc( 'oTinfGen', ['nIVAAlbaranesProveedores'])"     )
   ::oFastReport:AddVariable(    "Albaranes proveedores",        "Total recargo albaranes proveedores",         "CallHbFunc( 'oTinfGen', ['nRecargoAlbaranesProveedores'])" )
   ::oFastReport:AddVariable(    "Albaranes proveedores",        "Total albaranes proveedores",                 "CallHbFunc( 'oTinfGen', ['nTotalAlbaranesProveedores'])"   )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableLineasAlbaranProveedor()

   ::oFastReport:AddVariable(     "Lineas de albaranes de proveedores",   "Detalle del artículo línea del albaran de proveedor",                   "CallHbFunc( 'oTInfGen', ['cDetalleAlbaranesProveedores'])"                         )
   ::oFastReport:AddVariable(     "Lineas de albaranes de proveedores",   "Total unidades artículo línea del albaran de proveedor",                "CallHbFunc( 'oTInfGen', ['nTotalUnidadesAlbaranesProveedores'])"                   )
   ::oFastReport:AddVariable(     "Lineas de albaranes de proveedores",   "Precio unitario del artículo línea del albaran de proveedor",           "CallHbFunc( 'oTInfGen', ['nPrecioUnitarioAlbaranesProveedores'])"                  )
   ::oFastReport:AddVariable(     "Lineas de albaranes de proveedores",   "Total línea de albaran de proveedor",                                   "CallHbFunc( 'oTInfGen', ['nTotalLineaAlbaranesProveedores'])"                      )   
   ::oFastReport:AddVariable(     "Lineas de albaranes de proveedores",   "Total impuestos incluidos línea del albaran de proveedor",              "CallHbFunc( 'oTInfGen', ['nTotalImpuestosIncluidosLineaAlbaranesProveedores'])"    )
   ::oFastReport:AddVariable(     "Lineas de albaranes de proveedores",   "Total IVA línea del albaran de proveedor",                              "CallHbFunc( 'oTInfGen', ['nTotalIVALineaAlbaranesProveedores'])"                   )      
   ::oFastReport:AddVariable(     "Lineas de albaranes de proveedores",   "Total descuento porcentual artículo línea del albaran de proveedor",    "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPorcentualLineaAlbaranesProveedores'])"   )
   ::oFastReport:AddVariable(     "Lineas de albaranes de proveedores",   "Total descuento promocional artículo línea del albaran de proveedor",   "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPromocionalLineaAlbaranesProveedores'])"  )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableFacturaProveedor()

   ::oFastReport:AddVariable(    "Facturas proveedores",        "Total base facturas proveedores",            "CallHbFunc( 'oTinfGen', ['nBaseFacturasProveedores'])"    )
   ::oFastReport:AddVariable(    "Facturas proveedores",        "Total " + cImp() + " facturas proveedores",  "CallHbFunc( 'oTinfGen', ['nIVAFacturasProveedores'])"     )
   ::oFastReport:AddVariable(    "Facturas proveedores",        "Total recargo facturas proveedores",         "CallHbFunc( 'oTinfGen', ['nRecargoFacturasProveedores'])" )
   ::oFastReport:AddVariable(    "Facturas proveedores",        "Total facturas proveedores",                 "CallHbFunc( 'oTinfGen', ['nTotalFacturasProveedores'])"   )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableLineasFacturaProveedor()

   ::oFastReport:AddVariable(     "Lineas de facturas de proveedores",   "Detalle del artículo línea del factura de proveedor",                   "CallHbFunc( 'oTInfGen', ['cDetalleFacturasProveedores'])"                         )
   ::oFastReport:AddVariable(     "Lineas de facturas de proveedores",   "Total unidades artículo línea del factura de proveedor",                "CallHbFunc( 'oTInfGen', ['nTotalUnidadesFacturasProveedores'])"                   )
   ::oFastReport:AddVariable(     "Lineas de facturas de proveedores",   "Precio unitario del artículo línea del factura de proveedor",           "CallHbFunc( 'oTInfGen', ['nPrecioUnitarioFacturasProveedores'])"                  )
   ::oFastReport:AddVariable(     "Lineas de facturas de proveedores",   "Total línea de factura de proveedor",                                   "CallHbFunc( 'oTInfGen', ['nTotalLineaFacturasProveedores'])"                      )   
   ::oFastReport:AddVariable(     "Lineas de facturas de proveedores",   "Total impuestos incluidos línea del factura de proveedor",              "CallHbFunc( 'oTInfGen', ['nTotalImpuestosIncluidosLineaFacturasProveedores'])"    )
   ::oFastReport:AddVariable(     "Lineas de facturas de proveedores",   "Total IVA línea del factura de proveedor",                              "CallHbFunc( 'oTInfGen', ['nTotalIVALineaFacturasProveedores'])"                   )      
   ::oFastReport:AddVariable(     "Lineas de facturas de proveedores",   "Total descuento porcentual artículo línea del factura de proveedor",    "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPorcentualLineaFacturasProveedores'])"   )
   ::oFastReport:AddVariable(     "Lineas de facturas de proveedores",   "Total descuento promocional artículo línea del factura de proveedor",   "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPromocionalLineaFacturasProveedores'])"  )

RETURN ( Self )

//---------------------------------------------------------------------------//


METHOD AddVariableRectificativaProveedor()

   ::oFastReport:AddVariable(    "Rectificativas proveedores",       "Total base rectificativas proveedores",           "CallHbFunc( 'oTinfGen', ['nBaseFacturasRectificativasproveedores'])"     )
   ::oFastReport:AddVariable(    "Rectificativas proveedores",       "Total " + cImp() + " rectificativas proveedores", "CallHbFunc( 'oTinfGen', ['nIVAFacturasRectificativasproveedores'])"      )
   ::oFastReport:AddVariable(    "Rectificativas proveedores",       "Total recargo rectificativas proveedores",        "CallHbFunc( 'oTinfGen', ['nRecargoFacturasRectificativasproveedores'])"  )
   ::oFastReport:AddVariable(    "Rectificativas proveedores",       "Total rectificativas proveedores",                "CallHbFunc( 'oTinfGen', ['nTotalFacturasRectificativasproveedores'])"    )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableLineasRectificativaProveedor()

   ::oFastReport:AddVariable(     "Lineas de rectificativas de proveedores",   "Detalle del artículo línea de rectificativa de proveedor",                  "CallHbFunc( 'oTInfGen', ['cDetalleRectificativasProveedores'])"                         )
   ::oFastReport:AddVariable(     "Lineas de rectificativas de proveedores",   "Total unidades artículo línea de rectificativa de proveedor",               "CallHbFunc( 'oTInfGen', ['nTotalUnidadesRectificativasProveedores'])"                   )
   ::oFastReport:AddVariable(     "Lineas de rectificativas de proveedores",   "Precio unitario del artículo línea de rectificativa de proveedor",          "CallHbFunc( 'oTInfGen', ['nPrecioUnitarioRectificativasProveedores'])"                  )
   ::oFastReport:AddVariable(     "Lineas de rectificativas de proveedores",   "Total línea de rectificativa de proveedor",                                 "CallHbFunc( 'oTInfGen', ['nTotalLineaRectificativasProveedores'])"                      )   
   ::oFastReport:AddVariable(     "Lineas de rectificativas de proveedores",   "Total impuestos incluidos línea de rectificativa de proveedor",             "CallHbFunc( 'oTInfGen', ['nTotalImpuestosIncluidosLineaRectificativasProveedores'])"    )
   ::oFastReport:AddVariable(     "Lineas de rectificativas de proveedores",   "Total IVA línea de rectificativa de proveedor",                             "CallHbFunc( 'oTInfGen', ['nTotalIVALineaRectificativasProveedores'])"                   )      
   ::oFastReport:AddVariable(     "Lineas de rectificativas de proveedores",   "Total descuento porcentual artículo línea de rectificativa de proveedor",   "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPorcentualLineaRectificativasProveedores'])"   )
   ::oFastReport:AddVariable(     "Lineas de rectificativas de proveedores",   "Total descuento promocional artículo línea de rectificativa de proveedor",  "CallHbFunc( 'oTinfGen', ['nTotalDescuentoPromocionalLineaRectificativasProveedores'])"  )

RETURN ( Self )

//---------------------------------------------------------------------------//

Static Function CutString( cStart, cEnd, cText, lExclude )

   local nStart
   local nEnd
   local cString        := ""

   DEFAULT lExclude     := .f.

   nStart               := At( cStart, cText )
   if nStart != 0

      cText             := SubStr( cText, nStart )

      nEnd              := Rat( cEnd, cText )
      if nEnd != 0

         cString        := SubStr( cText, 1, nEnd ) 

         if lExclude
            cString     := StrTran( cString, cStart, "" )
            cString     := StrTran( cString, cEnd, "" )
         end if

      end if

   end if

RETURN ( cString )

//---------------------------------------------------------------------------//

Static Function aTextString( cStart, cEnd, cText )

   local n
   local nEnd
   local nStart
   local cString        := ""
   local nStartPos      := 1
   local aExp           := {}
   local nTop
   local nTopOld        := 0
   local nPosicion      := 0

   // Recojo en un array todas las expresiones completas--------------------------
   /*
   do while ( ( nStart := At( cStart, cText, nStartPos ) ) != 0 )

      nEnd              := At( cEnd, cText, nStart + len( cStart ) )

      if nEnd != 0
         cString        := SubStr( cText, nStart, ( nEnd - nStart + len( cEnd ) ) )
      end if

      aAdd( aExp, cString )

      nStartPos         := nEnd + 1
   
   enddo
   */

   // Recojo en un array todas las expresiones completas--------------------------

   do while ( ( nStart := At( cStart, cText ) ) != 0 )

      cText             := SubStr( cText, nStart )

      nEnd              := At( cEnd, cText )

      if nEnd != 0
         cString        := SubStr( cText, 1, nEnd )
      end if

      aAdd( aExp, cString )

      cText             := SubStr( cText, nEnd + 1 )

   enddo

   /*
   Comprobamos los datos que hemos recibido y localizamos el mayor-------------
   */

   do case
      case len( aExp ) == 0
         cString           := ""

      case len( aExp ) == 1
         cString           := aExp[1]

      otherwise

         for n := 1 to Len( aExp )

            nTop           := Val( CutString( 'Top="', '"', aExp[n], .t. ) )

            if nTop > nTopOld

               nTopOld     := nTop
               nPosicion   := n

            end if

         next 

         cString           := aExp[ nPosicion ]

   end case

RETURN ( cString )
      
//---------------------------------------------------------------------------//

METHOD AddNode( cDirectory, hHash, oNode, lBrackets )

   local aFile
   local cFile
   local oNewNode
   local aDirectory
   local hProperties

   DEFAULT lBrackets       := .f.

   aDirectory              := Directory( cDirectory + "\*.*", "D" )
   if !Empty( aDirectory )

      for each aFile in aDirectory

         if !( aFile[ 1 ] == '.' .or. aFile[ 1 ] == '..' )      

            // Los personalizados le ponemos brackets--------------------------

            cFile          := getFileNoExt( aFile[ 1 ] )
            if lBrackets
               cFile       := putBrackets( cFile )
            end if 

            // Propiedades q se pasan al nodo----------------------------------

            hProperties       := {=>}
            hset( hProperties, "Title", cFile )
            hset( hProperties, "Directory", cDirectory )
            hset( hProperties, "File", aFile[ 1 ] )
            hset( hProperties, "Type", hHash[ "Type" ] )

            if hhaskey( hHash, "Options" )
               hset( hProperties, "Options", hHash[ "Options" ] )
            end if 

            // Si es un directorio----------------------------------------------

            if ( aFile[ 5 ] == 'D' )
               oNewNode    := oNode:Add( cFile, 22, hProperties )
               ::AddNode( cDirectory + "\" + aFile[ 1 ], hHash, oNewNode )
            else 
               if ( '.fr3' $ aFile[ 1 ] ) 
                  oNode:Add( cFile, hHash[ "Image" ], hProperties )
               end if 
            end if            
         
         end if 

      next 

   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActiveClients()

   local nActiveClients := 0

   ::oDbfCli:GetStatus()
   ::oDbfCli:OrdSetFocus( "lBlqCli" )

   nActiveClients       := ::oDbfCli:OrdKeyCount()

   ::oDbfCli:SetStatus()

RETURN ( nActiveClients )

//------------------------------------------------------------------------//

METHOD TotalCodigoClientes( cCliDesde, cCliHasta, cDescription )

   local uValue
   local cField
   local nTotalClients        := 0

   DEFAULT cDescription       := "Total"

   cField                     := ::GetFieldByDescription( cDescription )

   if !Empty( cField ) .and. IsChar( cCliDesde ) .and. IsChar( cCliHasta )

      ::oDbf:GetStatus()

      ::oDbf:GoTop()
      while !( ::oDbf:Eof() )

         if ( Rtrim( ::oDbf:cCodCli ) >= Rtrim( cCliDesde ) .and. Rtrim( ::oDbf:cCodCli ) <= Rtrim( cCliHasta ) )

            uValue            := ::oDbf:FieldGetByName( cField )

            if IsNum( uValue )
               nTotalClients  += uValue
            end if

         end if

         ::oDbf:Skip()

      end while

      ::oDbf:SetStatus()

   end if

RETURN ( nTotalClients )

//------------------------------------------------------------------------//

METHOD TotalFechaClientes( dDesde, dHasta, cDescription )

   local uValue
   local cField
   local nTotalClients        := 0

   DEFAULT cDescription       := "Total"

   cField                     := ::GetFieldByDescription( cDescription )

   if !Empty( cField ) .and. IsDate( dDesde ) .and. IsDate( dHasta )

      ::oDbf:GetStatus()

      ::oDbf:GoTop()
      while !( ::oDbf:Eof() )

         if ( ::oDbf:dFecDoc >= dDesde ) .and. ( ::oDbf:dFecDoc <= dHasta )

            uValue            := ::oDbf:FieldGetByName( cField )

            if IsNum( uValue )
               nTotalClients  += uValue
            end if

         end if

         ::oDbf:Skip()

      end while

      ::oDbf:SetStatus()

   end if

RETURN ( nTotalClients )

//------------------------------------------------------------------------//

METHOD TotalPreimerTrimestreClientes( cDescription )

   local dFechaInicio   := Ctod( "01/01/" + Str( Year( ::dIniInf ) ) )
   local dFechaFin      := Ctod( "01/04/" + Str( Year( ::dIniInf ) ) ) - 1

RETURN ( ::TotalFechaClientes( dFechaInicio, dFechaFin, cDescription ) )

//------------------------------------------------------------------------//

METHOD TotalSegundoTrimestreClientes( cDescription )

   local dFechaInicio   := Ctod( "01/04/" + Str( Year( ::dIniInf ) ) )
   local dFechaFin      := Ctod( "01/08/" + Str( Year( ::dIniInf ) ) ) - 1

RETURN ( ::TotalFechaClientes( dFechaInicio, dFechaFin, cDescription ) )

//------------------------------------------------------------------------//

METHOD TotalCodigoArticulos( cArtDesde, cArtHasta, cDescription )

   local uValue
   local cField
   local nTotalArticulos         := 0

   DEFAULT cDescription          := "Total"

   cField                        := ::GetFieldByDescription( cDescription )

   if !Empty( cField ) .and. IsChar( cArtDesde ) .and. IsChar( cArtHasta )

      ::oDbf:GetStatus()

      ::oDbf:GoTop()
      while !( ::oDbf:Eof() )

         if ( Rtrim( ::oDbf:cCodArt ) >= Rtrim( cArtDesde ) .and. Rtrim( ::oDbf:cCodArt ) <= Rtrim( cArtHasta ) )

            uValue               := ::oDbf:FieldGetByName( cField )

            if IsNum( uValue )
               nTotalArticulos   += uValue
            end if

         end if

         ::oDbf:Skip()

      end while

      ::oDbf:SetStatus()

   end if

RETURN ( nTotalArticulos )

//------------------------------------------------------------------------//

METHOD BrwRangoKeyDown( o, nKey )

   local oColumn  := o:SelectedCol()

   if ( nKey == 107 .or. nKey == 187 )

      if !Empty( oColumn ) .and. !Empty( oColumn:bEditBlock )

         oColumn:RunBtnAction()

      end if

   end if

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD Count( cDescription, lUnique )

   local cField
   local uValue
   local aValue               := {}
   local nTotal               := 0

   DEFAULT cDescription       := "Código cliente"
   DEFAULT lUnique            := ".f."

   cField                     := ::GetFieldByDescription( cDescription )
   lUnique                    := Lower( lUnique ) == ".t."

   if !Empty( cField )

      ::oDbf:GetStatus()

      ::oDbf:GoTop()
      while !( ::oDbf:Eof() )

         uValue               := ::oDbf:FieldGetByName( cField )

         if !Empty( uValue )

            if lUnique

               if aScan( aValue, uValue ) == 0
                  aAdd( aValue, uValue )
                  nTotal++
               end if

            else

               nTotal++

            end if

         end if

         ::oDbf:Skip()

      end while

      ::oDbf:SetStatus()

   end if

RETURN ( nTotal )

//------------------------------------------------------------------------//

METHOD InitSatClientes()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD AddSATClientes()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD InitPresupuestosClientes()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD AddPresupuestosClientes()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD InitPedidosClientes()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD AddPedidosClientes()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD AddAlbaranesClientes()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD InitFacturasRectificativasClientes()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD AddFacturasRectificativasClientes()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD InitTicketsClientes()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD AddTicketsClientes()

RETURN ( Self )

//------------------------------------------------------------------------//  

METHOD InitPedidosProveedores()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD AddPedidosProveedores()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD InitAlbaranesProveedores()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD AddAlbaranesProveedores()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD InitFacturasProveedores()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD AddFacturasProveedores()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD InitFacturasRectificativasProveedores()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD AddFacturasRectificativasProveedores()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD CreateTreeImageList()

   ::oTreeImageList        := TImageList():New( 16, 16 )
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_16" ),              Rgb( 255, 0, 255 ) ) // 0 Listados
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_16" ),              Rgb( 255, 0, 255 ) ) // 1 No usado
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_clipboard_empty_businessman_16" ),Rgb( 255, 0, 255 ) ) // 2 Pedido proveedor
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_document_empty_businessman_16" ), Rgb( 255, 0, 255 ) ) // 3 Albaran proveedor
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_businessman_16" ),  Rgb( 255, 0, 255 ) ) // 4 Factura proveedor
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_notebook_user_16" ),              Rgb( 255, 0, 255 ) ) // 5 Presupuestos
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_clipboard_empty_user_16" ),       Rgb( 255, 0, 255 ) ) // 6 Pedidos clientes
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_document_empty_16" ),             Rgb( 255, 0, 255 ) ) // 7 Albaranes clientes
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_user_16" ),         Rgb( 255, 0, 255 ) ) // 8 Facturas cliente
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_delete_16" ),       Rgb( 255, 0, 255 ) ) // 9 Rectificativas
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_cash_register_user_16" ),         Rgb( 255, 0, 255 ) ) // 10 TPV
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_money2_16" ),                     Rgb( 255, 0, 255 ) ) // 11 Ventas
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_small_truck_16" ),                Rgb( 255, 0, 255 ) ) // 12 Compras
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_package_16" ),                    Rgb( 255, 0, 255 ) ) // 13 Almacen
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_worker_16" ),       Rgb( 255, 0, 255 ) ) // 14 Produccion
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_delete2_16" ),      Rgb( 255, 0, 255 ) ) // 15 Rectifiactivas proveedores
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_package_16" ),                    Rgb( 255, 0, 255 ) ) // 16 Existencias
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_office_building2_16" ),           Rgb( 255, 0, 255 ) ) // 17 NO USADO
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_document_text_delete2_16" ),      Rgb( 255, 0, 255 ) ) // 18 NO USADO
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_user_16" ),                       Rgb( 255, 0, 255 ) ) // 19 Clientes ( NO USADO )
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_power_drill_sat_user_16" ),       Rgb( 255, 0, 255 ) ) // 20 SAT
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_briefcase2_user_16" ),            Rgb( 255, 0, 255 ) ) // 21 Recibos
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_folder_document_16" ),            Rgb( 255, 0, 255 ) ) // 22 Folder
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_moneybag_16" ),                   Rgb( 255, 0, 255 ) ) // 23 Iva
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_object_cube_16"),                 Rgb( 255, 0, 255 ) ) // 24 Articulo
   ::oTreeImageList:AddMasked( TBitmap():Define( "gc_pencil_package_16"),              Rgb( 255, 0, 255 ) ) // 25 Movimiento de almacén

   if !Empty( ::oTreeReporting )
      ::oTreeReporting:SetImageList( ::oTreeImageList )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD TreeReportingChanged() 

   local cTitle   := ::oTreeReporting:getSelText()

   if !empty( ::oTreeReporting:getSelected() )

      if !empty( ::oTreeReporting:getSelected():bAction ) .and. hhaskey( ::oTreeReporting:getSelected():bAction, "Options" )

         ::oTFastReportOptions:setOptions( hget( ::oTreeReporting:getSelected():bAction, "Options" ) )

         ::lShowOptions()
      
      else
         
         ::lHideOptions()

      end if 

   end if 


   if ( "Listado" $ cTitle )
      ::lHideFecha()
   else
      ::lShowFecha()
   end if

   ::oDlg:cTitle( ::cSubTitle + " : " + cTitle )
   
Return ( Self )

//---------------------------------------------------------------------------//

METHOD XmlDocument()

   local cFile    := cPatTmp() + "Report.txt"

   if !::lLoadReport()
      MsgStop( "No se ha podido cargar un diseño de informe valido." + CRLF + ::cReportFile )
      Return ( Self )
   end if 

   CursorWait()

   if File( cFile )
      fErase( cFile )
   end if

   MemoWrit( cFile, ::cInformeFastReport )

   CursorWE()    

   if File( cFile )
      WinExec( "notepad.exe " + cFile )
   end if 

Return ( Self )

//----------------------------------------------------------------------------//

METHOD DlgFilter()

   if !Empty( ::oFilter )

      ::oFilter:Dialog()

      if !Empty( ::oBtnFiltrar )

         if !Empty( ::oFilter:bExpresionFilter )
            ::oBtnFiltrar:cCaption( "Filtro activo" )
         else 
            ::oBtnFiltrar:cCaption( "Filtrar" )
         end if

      end if 

   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD insertIfValid()

   local lValidRegister    := ::lValidRegister()

   if lValidRegister
      ::oDbf:Insert()
   else
      ::oDbf:Cancel()
   end if

Return ( lValidRegister )

//----------------------------------------------------------------------------//

METHOD ValorCampoExtra( cTipoDoccumento, cCodCampoExtra )

   local cValorCampoExtra  := cTipoDoccumento + cCodCampoExtra

Return ( cValorCampoExtra )

//----------------------------------------------------------------------------//

METHOD initVariables()

   ::aChildDesdeGrupoCliente              := {}
   ::aChildHastaGrupoCliente              := {}

   if !empty( ::oGrpCli ) .and. !empty(::oGrupoGCliente)
      ::aChildDesdeGrupoCliente            := ::oGrpCli:aChild( ::oGrupoGCliente:Cargo:getDesde() )
      aadd( ::aChildDesdeGrupoCliente, ::oGrupoGCliente:Cargo:getDesde() )
   end if 

   if !empty( ::oGrpCli ) .and. !empty(::oGrupoGCliente)
      ::aChildHastaGrupoCliente            := ::oGrpCli:aChild( ::oGrupoGCliente:Cargo:getHasta() )
      aadd( ::aChildHastaGrupoCliente, ::oGrupoGCliente:Cargo:getHasta() )
   end if 

Return ( self )

//----------------------------------------------------------------------------//

METHOD selectReportTree( cReportName )

   local oItem

   if empty( cReportName )
      Return ( self )
   end if 

   oItem       := ScanItemsBlock( ::oTreeReporting:aItems, {|o| alltrim( o:cPrompt ) == alltrim( cReportName ) } )

   if !empty( oItem )
      ::oTreeReporting:select( oItem )
   end if 

Return ( self )

//----------------------------------------------------------------------------//

static function ScanItemsBlock( aItems, bAction ) 

   local oItem, n := 1, oItemFound

   while n <= Len( aItems ) .and. oItemFound == nil
      oItem = aItems[ n ]
      if Eval( bAction, oItem )
         return oItem
      else
         if Len( oItem:aItems ) > 0
            oItemFound = ScanItemsBlock( oItem:aItems, bAction )
         endif      
      endif
      n++
   end      

return oItemFound

//----------------------------------------------------------------------------//


