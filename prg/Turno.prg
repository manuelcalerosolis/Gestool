#include "FiveWin.Ch"
#include "Factu.ch" 
#include "XBrowse.ch"
#include "MesDbf.ch"
#include "FastRepH.ch"

#define CLR_BAR                   Rgb( 192, 192, 192 )

#define _ASIEN                    1     //   N      6     0
#define _FECHA                    2     //   D      8     0
#define _SUBCTA                   3     //   C     12     0
#define _CONTRA                   4     //   C     12     0
#define _PTADEBE                  5     //   N     12     0
#define _CONCEPTO                 6     //   C     25     0
#define _PTAHABER                 7     //   N     12     0
#define _FACTURA                  8     //   N      7     0
#define _BASEIMPO                 9     //   N     11     0
#define _IVA                     10     //   N      5     2
#define _RECEQUIV                11     //   N      5     2
#define _DOCUMENTO               12     //   C      6     0
#define _DEPARTA                 13     //   C      3     0
#define _CLAVE                   14     //   C      6     0
#define _ESTADO                  15     //   C      1     0
#define _NCASADO                 16     //   N      6     0
#define _TCASADO                 17     //   N      1     0
#define _TRANS                   18     //   N      6     0
#define _CAMBIO                  19     //   N     16     6
#define _DEBEME                  20     //   N     16     6
#define _HABERME                 21     //   N     16     6
#define _AUXILIAR                22     //   C      1     0
#define _SERIE                   23     //   C      1     0
#define _SUCURSAL                24     //   C      4     0
#define _CODDIVISA               25     //   C      1     0
#define _IMPAUXME                26     //   N     16     6
#define _MONEDAUSO               27     //   C      1     0
#define _EURODEBE                28     //   N     16     2
#define _EUROHABER               29     //   N     16     2
#define _BASEEURO                30     //   N     16     2
#define _NOCONV                  31     //   L      1     0
#define _NUMEROINV               32     //   C     10     0

#define ubiGeneral               0
#define ubiLlevar                1
#define ubiSala                  2
#define ubiRecoger               3
#define ubiEncargar              4

#define cajCerrrada              0
#define cajParcialmente          1
#define cajAbierta               2

memvar nTotAlbCliContadores
memvar nTotAlbCliVentas
memvar nTotPedCliEntregas
memvar nTotAlbCliEntregas

memvar nTotEntregas

memvar nTotFacCliContadores
memvar nTotFacCliVentas
memvar nTotRctCliVentas

memvar nTotTikCliContadores
memvar nTotTikCliVentas

memvar nTotChkCliVentas
memvar nTotChkCliContadores

memvar nTotDevCliContadores
memvar nTotDevCliVentas
memvar nTotValCliContadores
memvar nTotValCliVentas
memvar nTotValCliLiquidados
memvar nTotAlbPrvCompras
memvar nTotFacPrvCompras
memvar nTotRctPrvCompras
memvar nTotAntCliVentas
memvar nTotAntCliLiquidados
memvar nTotEntradas
memvar nTotVentas
memvar nTotContadores
memvar nTotVentaCredito
memvar nTotVentaContado
memvar nTotCompras

memvar nTotTikCliCobros
memvar nTotFacCliCobros
memvar nTotValCliCobros
memvar nTotChkCliCobros

memvar nTotFacPrvPagos
memvar nTotRctPrvPagos

memvar nTotCobroEfectivo
memvar nTotCobroNoEfectivo
memvar nTotCobroTarjeta
memvar nTotCobroMedios

memvar nTotPagoEfectivo
memvar nTotPagoNoEfectivo
memvar nTotPagoTarjeta
memvar nTotPagoMedios

memvar nTotCajaEfectivo
memvar nTotCajaNoEfectivo
memvar nTotCajaTarjeta
memvar nTotCajaObjetivo

memvar nTotCaja

memvar nTotCobros
memvar nDifCobros
memvar nDifTotal
memvar nTotVentaSesion
memvar nTotCobroSesion

memvar nTotNumeroAlbaranes
memvar nTotNumeroFacturas
memvar nTotNumeroTikets
memvar nTotNumeroVales
memvar nTotNumeroCheques
memvar nTotNumeroDevoluciones
memvar nTotNumeroAptCajon

memvar nTicketMedio

memvar aMonedasEfe
memvar aMonedasRet
memvar nTarjetaEnCaja
memvar nEfectivoEnCaja
memvar nRetiradoEnCaja

memvar nTotSaldoEfectivo
memvar nTotSaldoNoEfectivo
memvar nTotSaldoTarjeta

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

CLASS TTurno FROM TMasDet

   DATA  oDbfCaj
   DATA  oContador
   DATA  oDbfEmp
   DATA  oDbfDoc
   DATA  oDbfUsr
   DATA  oDbfTemporal

   DATA  cFileTemporal

   DATA  oUser
   DATA  oTikT
   DATA  oTikP
   DATA  oTikL
   DATA  oPreCliL
   DATA  oPreCliT
   DATA  oFacCliT
   DATA  oFacCliL
   DATA  oFacCliP
   DATA  oRctCliT
   DATA  oRctCliL
   DATA  oAntCliT
   DATA  oAlbCliT
   DATA  oAlbCliL
   DATA  oAlbCliP
   DATA  oFacPrvT
   DATA  oFacPrvL
   DATA  oFacPrvP
   DATA  oRctPrvT
   DATA  oRctPrvL
   DATA  oAlbPrvT
   DATA  oAlbPrvL
   DATA  oPedCliT
   DATA  oPedCliL
   DATA  oPedCliP
   DATA  oPedPrvT
   DATA  oDbfCount
   DATA  oIvaImp
   DATA  oImpTik
   DATA  oArticulo
   DATA  oClient
   DATA  oProvee
   DATA  oCaja
   DATA  oFPago
   DATA  oFamilia
   DATA  oTemporada
   DATA  oFabricante
   DATA  oCuentasBancarias
   DATA  oTipArt
   DATA  oTipInv
   DATA  oEntSal
   DATA  oEmpBnc
   DATA  oLogPorta
   DATA  oTpvRestaurante

   CLASSDATA  cCurTurno                            INIT ""
   CLASSDATA  cCurCaja                             INIT ""

   DATA  lZoom
   DATA  dFecTur
   DATA  cHorTur
   DATA  oCodCaj
   DATA  cCodCaj
   DATA  cOldCaj
   DATA  cCajTur

   DATA  oFechaInicio
   DATA  dFechaInicio                              INIT CtoD( "01/01/" + Str( Year( Date() ) ) )
   DATA  oFechaFin
   DATA  dFechaFin                                 INIT Date();

   DATA  oGrpDiferencias
   DATA  oDiferenciaEfectivo
   DATA  oSayDiferenciaEfectivo
   DATA  oDiferenciaTarjeta
   DATA  oSayDiferenciaTarjeta
   DATA  oDiferenciaTotal
   DATA  oSayDiferenciaTotal

   DATA  oBtnSelectAllCajas
   DATA  oBtnUnSelectAllCajas

   DATA  cComentario

   DATA  oTreeImpresion
   DATA  oTreeGeneral

   DATA  aOpcionImp                                AS ARRAY    INIT  ( aFill( Array( 19 ), .t. ) )
   DATA  oIniArqueo                                AS OBJECT

   DATA  oNoImprimirArqueo
   DATA  lNoImprimirArqueo                         AS LOGIC    INIT .f.
   DATA  lCerrado                                  AS LOGIC    INIT .f.

   DATA  oBtnPrv
   DATA  oBtnNxt
   DATA  oBtnRecalcular

   DATA  oBtnCancelContabilizacion

   DATA  oAni
   DATA  oTxt
   DATA  aSimula                                   
   DATA  nAsiento                                  AS NUMERIC  INIT 0
   DATA  aFac                                      AS ARRAY    INIT {}
   DATA  aMsg
   DATA  oMeter                                    AS OBJECT
   DATA  nMeter                                    AS NUMERIC  INIT 0
   DATA  oPrnTiket
   DATA  oNewImp                                   AS OBJECT

   DATA  oTotales                                  AS OBJECT

   DATA  oPrnArq
   DATA  cPrnArq
   DATA  cWinArq

   DATA  oCmbReport
   DATA  cCmbReport                                INIT "Visualizar"
   DATA  aCmbReport                                INIT { "Visualizar", "Imprimir",    "Adobe PDF",   "Excel",    "HTML" }
   DATA  aBmpReport                                INIT { "Prev116",    "gc_printer2_16",   "DocLock",     "Table",    "gc_earth_16" }
   DATA  aBmpReportTactil                          INIT { "Prev124",    "ImpButton24", "DocLock24",   "Table24",  "SndInt24" }
   DATA  nCmbReport                                INIT 1

   DATA  cText
   DATA  oSender
   DATA  lSelectSend
   DATA  lSelectRecive
   DATA  cIniFile

   DATA  lSuccesfullSend

   DATA  lTikAbiertos                              AS LOGIC    INIT .f.
   DATA  cTikAbiertos                              INIT ""

   DATA  nNumberSend                               INIT 0
   DATA  nNumberRecive                             INIT 0

   DATA  dOpenTurno
   DATA  cHoraTurno
   DATA  cCajeroTurno
   DATA  cDescripcionTurno

   DATA  nImporteTurno                             INIT 0
   DATA  nObjetivoTurno                            INIT 0

   DATA  oGrpCobros
   DATA  oTotalEfectivo
   DATA  oSayTotalEfectivo
   DATA  oSayTotalNoEfectivo
   DATA  oTotalNoEfectivo
   DATA  oSayTotalTarjeta
   DATA  oTotalTarjeta
   DATA  oTotalCobros
   DATA  oSayTotalCobros
   DATA  oTotalCaja

   DATA  oImporteEfectivo
   DATA  oImporteNoEfectivo
   DATA  oImporteTarjeta
   DATA  oImporteRetirado
   DATA  oImporteCambio

   DATA  nImporteEfectivo                          INIT 0
   DATA  nImporteNoEfectivo                        INIT 0
   DATA  nImporteTarjeta                           INIT 0
   DATA  nImporteRetirado                          INIT 0
   DATA  nImporteCambio                            INIT 0
   DATA  nImportePresupuesto                       INIT 0

   DATA  aFilesProcessed                           AS ARRAY    INIT {}

   DATA  oSaySalidaImpresion
   DATA  oBtnOpcionesImpresion
   DATA  oGrpOpcionesImpresion

   DATA  lEnvioInformacion                         AS LOGIC    INIT .t.
   DATA  lImprimirEnvio                            AS LOGIC    INIT .t.

   DATA  oEnvioInformacion                         AS OBJECT
   DATA  oImprimirEnvio                            AS OBJECT
   DATA  oChkEnviarMail                            AS OBJECT
   DATA  oChkActualizaStockWeb                     AS OBJECT
   DATA  lChkActualizaStockWeb                     AS LOGIC    INIT .f.

   DATA  oGetEnviarMail
   DATA  oGrpNotificacion
   DATA  oGrpOpcionesEnvioInformacion

   DATA  lEnviarMail                               AS LOGIC    INIT .f.
   DATA  cEnviarMail                               INIT Space( 200 )
   DATA  cMensajeMail                              INIT ""

   DATA  lDefaultPrinter                           AS LOGIC    INIT .t.
   DATA  cPrinter

   DATA  lPdfShowDialog                            AS LOGIC    INIT .t.
   DATA  cPdfDefaultPath                           INIT ""
   DATA  cPdfFileName                              INIT ""
   DATA  cHtmlFileName                             INIT ""

   DATA  cGrupoEnUso                               INIT ""
   DATA  nGrupoPeso                                INIT 0

   DATA  lCreated                                  AS LOGIC    INIT .f.
   DATA  oBandera

   DATA  aTipIva                                   AS ARRAY    INIT {}

   DATA  oBrwTotales
   DATA  oTreeTotales

   DATA  oGrpArqueo

   DATA  oMoneyEfectivo
   DATA  oMoneyRetirado

   DATA  oChkSimula
   DATA  lChkSimula                                INIT .f.

   DATA  lAllSesions                               INIT .f.

   DATA  lChkContabilizarFacturasProveedores       INIT .t.
   DATA  lChkContabilizarRectificativasProveedores INIT .t.
   DATA  lChkContabilizarPagosProveedores          INIT .t.

   DATA  lChkContabilizarContadores                INIT .t.
   DATA  lChkContabilizarTicket                    INIT .t.
   DATA  lChkContabilizarFactura                   INIT .t.
   DATA  lChkContabilizarRectificativa             INIT .t.
   DATA  lChkContabilizarCobros                    INIT .t.
   DATA  lChkContabilizarAnticipos                 INIT .t.

   DATA  lBreak                                    INIT .f.

   DATA  cGetProjectoContaplus
   DATA  cGetEmpresaContaplus

   DATA oSer                                       INIT Array( 26 )
   DATA aSer                                       INIT Afill( Array( 26 ), .t. )

   DATA  lArqueoParcial                            INIT .f.
   
   DATA  OpenTurno                                 INIT .f.
   DATA  OpenCaja                                  INIT .f.

   DATA  oMtrProcess

   DATA nScreenHorzRes
   DATA nScreenVertRes

   DATA oFastReport

   DATA lDestroyFastReport                         INIT .f.

   DATA aEstadoSesion                              INIT { "Cerrado", "Parcial", "Abierto" }

   DATA aCajaSelect                                INIT {}

   DATA lArqueoCiego                               INIT .f.

   METHOD New( cPath, oWndParent, oMenuItem )
   METHOD Initiate( cText, oSender )               CONSTRUCTOR
   METHOD Build( cPath, oWndParent, oMenuItem )    CONSTRUCTOR

   METHOD lArqueoTactil()                          INLINE lTactilMode()

   // Ficheros ----------------------------------------------------------------

   METHOD OpenFiles( lExclusive )
   METHOD OpenService( lExclusive )
   METHOD CloseFiles()
   METHOD CloseService()
   METHOD DefineFiles()
   METHOD CheckFiles()

   METHOD Resource( nMode )
      METHOD Activate()

   METHOD lOpenTurno()
   METHOD lOpenCaja()
   METHOD lAnyOpenCaja()

   METHOD lCloseCaja()
   
   METHOD lAllCloseTurno()
   METHOD lOneCloseTurno()

   METHOD lCloseCajaSeleccionada( oDlg )

   METHOD DialogCreateTurno()
      METHOD StartCreateTurno( oImporte, oDivisa, oBmpDiv, oCodUsr )
      METHOD CreateTurno( oDlg )
         METHOD CreateCabeceraTruno()
         METHOD CreateCajaTurno()
         METHOD CreateEntradaTurno()

   METHOD cNombreUser()

   METHOD SetCurrentTurno()                        INLINE   ( ::cCurTurno  := ::oDbf:cNumTur + ::oDbf:cSufTur )
   METHOD GetCurrentTurno()                        INLINE   ( ::GetLastOpen() )
   METHOD GoCurrentTurno()

   METHOD GetCurrentCaja()                         INLINE   ( ::cCurCaja   := oUser():cCaja() )

   METHOD GetFullTurno()                           INLINE   ( ::cCurTurno + ::cCurCaja )

   METHOD cValidTurno()

   METHOD lSelectTurno( lSel )
   METHOD lSelectAll( lSel )
   METHOD MarkTurno( lMark )

   METHOD lInvCierre()
   METHOD InvCierre( oAni, oMsg )

   // Dialogo de cierre de turno-----------------------------------------------

   DATA  oDlgTurno
   DATA  oFldTurno

   METHOD lArqueoTurno( lZoom, lParcial )
      METHOD InitArqueoTurno()
      METHOD StartArqueoTurno()
      METHOD GoPrev( oBrwCnt, oBrwCaj )
      METHOD GoNext()

   METHOD lIsContadores()
   METHOD LoadContadores()
   METHOD TotContadores()

   METHOD SelCajas()
   METHOD SelAllCajas()
   METHOD lValidCajas()
   METHOD lChangeCajas()
   METHOD lAnyCajaSelect()
   METHOD lOneCajaSelect()

   METHOD TotVenta( cTurno, cCaja )
   METHOD TotEntrada( cTurno, cCaja )
   METHOD TotCompra( cTurno, cCaja )
   METHOD TotCobro( cTurno, cCaja )
   METHOD TotPago( cTurno, cCaja )
   METHOD TotTipoIva( cTurno, cCaja  )

   METHOD lCalTurno()
   METHOD ClickBrwTotales()

   METHOD GetLastOpen()
   METHOD GetLastClose()
   METHOD GetLastEfectivo()

   METHOD EdtCol( oLbx )
   METHOD EdtAnt( oLbx )

   METHOD EdtLine( oLbx )

   METHOD SyncAllDbf()
   METHOD Reindexa( oMeter )

   METHOD MixApunte( aApunte )

   METHOD Asiento()

   METHOD DlgImprimir()
      METHOD StartDlgImprimir()
      METHOD ExecuteDlgImprimir()

   METHOD PrintArqueo( cCodCaj, nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   METHOD DefineTemporal()
   METHOD DestroyTemporal()
   METHOD AppendInTemporal( cGrupo, cKey, cNaturaleza, nImporte )
   METHOD FillTemporal( cCodCaj )

   METHOD lNowOpen()
   METHOD RellenaIva()
   METHOD RollBack()             VIRTUAL

   METHOD lCloTiket( lClose )
   METHOD lCloEntSal( lClose )
   METHOD lCloPgoTik( lClose )
   METHOD lCloPedPrv( lClose )
   METHOD lCloAlbPrv( lClose )
   METHOD lCloFacPrv( lClose )
   METHOD lCloRctPrv( lClose )
   METHOD lCloPreCli( lClose )
   METHOD lCloPedCli( lClose )
   METHOD lCloAlbCli( lClose )
   METHOD lCloFacCli( lClose )

   METHOD ActTactil()

   // Envios-------------------------------------------------------------------

   METHOD CreateData()
   METHOD RestoreData()
   METHOD SendData()
   METHOD ReciveData()
   METHOD nGetNumberToSend()
   METHOD SetNumberToSend()      INLINE   WritePProString( "Numero", ::cText, cValToChar( ::nNumberSend ), ::cIniFile )
   METHOD IncNumberToSend()      INLINE   WritePProString( "Numero", ::cText, cValToChar( ++::nNumberSend ), ::cIniFile )
   METHOD lContaTiket()          VIRTUAL
   METHOD Process()

   METHOD Save()
   METHOD Load()

   METHOD ChangedTreeImpresion() VIRTUAL

   // Impresion----------------------------------------------------------------

   METHOD InitDlgImprimir()
   METHOD PrintReport( cTurno, cCaja, nDevice, nCopies, cPrinter, dbfDoc )
   METHOD DataReport( oFastReport )
   METHOD VariableReport( oFastReport )
   METHOD DesignReport( dbfDoc )

   METHOD cTxtAlbaranCliente()  INLINE ( ::oAlbCliT:cSerAlb + "/" + Alltrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + Alltrim( ::oAlbCliT:cSufAlb ) + Space( 1 ) + Dtoc( ::oAlbCliT:dFecAlb ) + Space( 1 ) + ( ::oAlbCliT:cTimCre ) + Space( 1 ) + ::oAlbCliT:cCodCaj + Space( 1 ) + Rtrim( ::oAlbCliT:cCodCli ) + Space( 1 ) + Rtrim( ::oAlbCliT:cNomCli ) )
   METHOD nTotAlbaranCliente()  INLINE ( ::oAlbCliT:nTotAlb )
   METHOD nCntAlbaranCliente()  INLINE ( nTotAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oIvaImp:cAlias, ::oDbfDiv:cAlias(), nil, cDivEmp(), .f., .f. ) )
   METHOD bEdtAlbaranCliente()

   METHOD cTxtFacturaCliente()  INLINE ( ::oFacCliT:cSerie + "/" + Alltrim( Str( ::oFacCliT:nNumFac ) ) + "/" + Alltrim( ::oFacCliT:cSufFac ) + Space( 1 ) + Dtoc( ::oFacCliT:dFecFac ) + Space( 1 ) + ( ::oFacCliT:cTimCre ) + Space( 1 ) + ::oFacCliT:cCodCaj + Space( 1 ) + Rtrim( ::oFacCliT:cCodCli ) + Space( 1 ) + Rtrim( ::oFacCliT:cNomCli ) )
   METHOD nTotFacturaCliente()  INLINE ( ::oFacCliT:nTotFac )
   METHOD nCntFacturaCliente()  INLINE ( nTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oIvaImp:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, nil, cDivEmp(), .f., .f. ) )
   METHOD bEdtFacturaCliente()

   METHOD cTxtFacturaRectificativaCliente()  INLINE ( ::oRctCliT:cSerie + "/" + Alltrim( Str( ::oRctCliT:nNumFac ) ) + "/" + Alltrim( ::oRctCliT:cSufFac ) + Space( 1 ) + Dtoc( ::oRctCliT:dFecFac ) + Space( 1 ) + ( ::oRctCliT:cTimCre ) + Space( 1 ) + ::oRctCliT:cCodCaj + Space( 1 ) + Rtrim( ::oRctCliT:cCodCli ) + Space( 1 ) + Rtrim( ::oRctCliT:cNomCli ) )
   METHOD nTotFacturaRectificativaCliente()  INLINE ( ::oRctCliT:nTotFac )
   METHOD nCntFacturaRectificativaCliente()  INLINE ( nTotFacRec( ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac, ::oRctCliT:cAlias, ::oRctCliL:cAlias, ::oIvaImp:cAlias, ::oDbfDiv:cAlias, nil, cDivEmp(), .f., .f. ) )
   METHOD bEdtFacturaRectificativaCliente()

   METHOD cTxtTiketCliente()    INLINE ( ::oTikT:cSerTik + "/" + Alltrim( ::oTikT:cNumTik ) + "/" + Alltrim( ::oTikT:cSufTik ) + Space( 1 ) + Dtoc( ::oTikT:dFecTik ) + Space( 1 ) + ( ::oTikT:cHorTik ) + Space( 1 ) + ::oTikT:cNcjTik + Space( 1 ) + Rtrim( ::oTikT:cCliTik ) + Space( 1 ) + Rtrim( ::oTikT:cNomTik ) )
   METHOD nTotTiketCliente()    INLINE ( ::oTikT:nTotTik )
   METHOD nCntTiketCliente()    INLINE ( nTotTik( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik, ::oTikT:cAlias, ::oTikL:cAlias, ::oDbfDiv:cAlias, nil, cDivEmp(), .f., .f. ) )

   METHOD bEdtTiketCliente()
   METHOD bZooTiketCliente()

   METHOD cTxtAnticipoCliente() INLINE ( ::oAntCliT:cSerAnt + "/" + Alltrim( Str( ::oAntCliT:nNumAnt ) ) + "/" + Alltrim( ::oAntCliT:cSufAnt ) + Space( 1 ) + Dtoc( ::oAntCliT:dFecAnt ) + Space( 1 ) + ( ::oAntCliT:cTimCre ) + Space( 1 ) + ::oAntCliT:cCodCaj + Space( 1 ) +  Rtrim( ::oAntCliT:cCodCli ) + Space( 1 ) + Rtrim( ::oAntCliT:cNomCli ) )
   METHOD nTotAnticipoCliente() INLINE ( nTotAntCli( ::oAntCliT:cAlias, ::oIvaImp:cAlias, ::oDbfDiv:cAlias ) )
   METHOD bEdtAnticipoCliente()

   METHOD cTxtAlbaranProveedor() INLINE ( ::oAlbPrvT:cSerAlb + "/" + Alltrim( Str( ::oAlbPrvT:nNumAlb ) ) + "/" + Alltrim( ::oAlbPrvT:cSufAlb ) + Space( 1 ) + Dtoc( ::oAlbPrvT:dFecAlb ) + Space( 1 ) + ( ::oAlbPrvT:cTimChg ) + Space( 1 ) + ::oAlbPrvT:cCodCaj + Space( 1 ) + Rtrim( ::oAlbPrvT:cCodPrv ) + Space( 1 ) + Rtrim( ::oAlbPrvT:cNomPrv ) )
   METHOD nTotAlbaranProveedor() INLINE ( ::oAlbPrvT:nTotAlb )
   METHOD bEdtAlbaranProveedor()

   METHOD cTxtFacturaProveedor() INLINE ( ::oFacPrvT:cSerFac + "/" + Alltrim( Str( ::oFacPrvT:nNumFac ) ) + "/" + Alltrim( ::oFacPrvT:cSufFac ) + Space( 1 ) + Dtoc( ::oFacPrvT:dFecFac ) + Space( 1 ) + ( ::oFacPrvT:cTimChg ) + Space( 1 ) + ::oFacPrvT:cCodCaj + Space( 1 ) + Rtrim( ::oFacPrvT:cCodPrv ) + Space( 1 ) + Rtrim( ::oFacPrvT:cNomPrv ) )
   METHOD nTotFacturaProveedor() INLINE ( ::oFacPrvT:nTotFac )
   METHOD bEdtFacturaProveedor()

   METHOD cTxtFacturaRectificativaProveedor() INLINE ( ::oRctPrvT:cSerFac + "/" + Alltrim( Str( ::oRctPrvT:nNumFac ) ) + "/" + Alltrim( ::oRctPrvT:cSufFac ) + Space( 1 ) + Dtoc( ::oRctPrvT:dFecFac ) + Space( 1 ) + ( ::oRctPrvT:cTimChg ) + Space( 1 ) + ::oRctPrvT:cCodCaj + Space( 1 ) +Rtrim( ::oRctPrvT:cCodPrv ) + Space( 1 ) + Rtrim( ::oRctPrvT:cNomPrv ) )
   METHOD nTotFacturaRectificativaProveedor() INLINE ( nTotRctPrv( ::oRctPrvT:cSerFac + Str( ::oRctPrvT:nNumFac ) + ::oRctPrvT:cSufFac, ::oRctPrvT:cAlias, ::oRctPrvL:cAlias, ::oIvaImp:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias ) )
   METHOD bEdtFacturaRectificativaProveedor()

   METHOD nTotTiketCobro()       INLINE ( nTotLCobTik( ::oTikP, ::oDbfDiv, cDivEmp() ) )
   METHOD nTotValTikCobro()      INLINE ( nTotValTik( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik, ::oTikT:cAlias, ::oTikL:cAlias, ::oDbfDiv, cDivEmp() ) )
   METHOD cTxtTiketCobro()       INLINE ( ::oTikP:cSerTik + "/" + Alltrim( ::oTikP:cNumTik ) + "/" + Rtrim( ::oTikP:cSufTik ) + Space( 1 ) + Dtoc( ::oTikP:dPgoTik ) + Space( 1 ) + ( ::oTikP:cTimTik ) + Space( 1 ) + ::oTikP:cCodCaj + Space( 1 ) + ::oTikP:cFpgPgo + Space( 1 ) + Rtrim( oRetfld( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik, ::oTikT, "cCliTik", 1 ) ) + Space( 1 ) + Rtrim( oRetfld( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik, ::oTikT, "cNomTik", 1 ) ) )
   METHOD bEdtTiketCobro()
   METHOD bZooTiketCobro()

   METHOD nTotFacturaCobro()     INLINE ( nTotCobCli( ::oFacCliP, ::oDbfDiv, cDivEmp(), .f. ) )
   METHOD cTxtFacturaCobro()     INLINE ( ::oFacCliP:cSerie + "/" + Alltrim( Str( ::oFacCliP:nNumFac ) ) + "/" + Rtrim( ::oFacCliP:cSufFac ) + Space( 1 ) + Dtoc( ::oFacCliP:dEntrada ) + Space( 1 ) + ::oFacCliP:cCodCaj + Space( 1 ) + ::oFacCliP:cCodPgo + Space( 1 ) + Rtrim( oRetfld( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT, "cCodCli", 1 ) ) + Space( 1 ) + Rtrim( oRetfld( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT, "cNomCli", 1 ) ) )
   METHOD bEdtFacturaCobro()

   METHOD nTotPedidoEntrega()    INLINE ( nEntPedCli( ::oPedCliP, ::oDbfDiv, cDivEmp(), .f. ) )
   METHOD cTxtPedidoEntrega()    INLINE ( ::oPedCliT:cSerPed + "/" + Alltrim( Str( ::oPedCliP:nNumPed ) ) + "/" + Rtrim( ::oPedCliP:cSufPed ) + Space( 1 ) + Dtoc( ::oPedCliP:dEntrega ) + Space( 1 ) + ::oPedCliP:cCodCaj + Space( 1 ) + ::oPedCliP:cCodPgo + Space( 1 ) + Rtrim( ::oPedCliP:cCodCli ) + Space( 1 ) + oRetFld( ::oPedCliP:cCodCli, ::oClient, "Titulo" ) )
   METHOD bEdtPedidoEntrega()

   METHOD nTotAlbaranEntrega()   INLINE ( nEntAlbCli( ::oAlbCliP, ::oDbfDiv, cDivEmp(), .f. ) )
   METHOD cTxtAlbaranEntrega()   INLINE ( ::oAlbCliP:cSerAlb + "/" + Alltrim( Str( ::oAlbCliP:nNumAlb ) ) + "/" + Rtrim( ::oAlbCliP:cSufAlb ) + Space( 1 ) + Dtoc( ::oAlbCliP:dEntrega ) + Space( 1 ) + ::oAlbCliP:cCodCaj + Space( 1 ) + ::oAlbCliP:cCodPgo + Space( 1 ) + Rtrim( ::oAlbCliP:cCodCli ) + Space( 1 ) + oRetFld( ::oAlbCliP:cCodCli, ::oClient, "Titulo" ) )
   METHOD bEdtAlbaranEntrega()

   METHOD nTotEntradasSalidas()  INLINE ( if( ::oEntSal:nTipEnt == 1, nTotES( nil, ::oEntSal:cAlias, ::oDbfDiv, cDivEmp(), .f. ), - nTotES( nil, ::oEntSal:cAlias, ::oDbfDiv, cDivEmp(), .f. ) ) )
   METHOD cTxtEntradasSalidas()  INLINE ( Dtoc( ::oEntSal:dFecEnt ) + Space( 1 ) + Space( 1 ) + Rtrim( ::oEntSal:cDesEnt ) )
   METHOD bEdtEntradasSalidas()

   METHOD nTotFacturaPago()      INLINE ( nTotRecPrv( ::oFacPrvP, ::oDbfDiv, cDivEmp(), .f. ) )
   METHOD cTxtFacturaPago()      INLINE ( ::oFacPrvP:cSerFac + "/" + Alltrim( Str( ::oFacPrvP:nNumFac ) ) + "/" + Rtrim( ::oFacPrvP:cSufFac ) + Space( 1 ) + Dtoc( ::oFacPrvP:dEntrada ) + Space( 1 ) + ::oFacPrvP:cCodCaj + Space( 1 ) + ::oFacPrvP:cCodPgo + Space( 1 ) + Rtrim( oRetfld( ::oFacPrvP:cSerFac + Str( ::oFacPrvP:nNumFac ) + ::oFacPrvP:cSufFac, ::oFacPrvT, "cCodPrv", 1 ) ) + Space( 1 ) + Rtrim( oRetfld( ::oFacPrvP:cSerFac + Str( ::oFacPrvP:nNumFac ) + ::oFacPrvP:cSufFac, ::oFacPrvT, "cNomPrv", 1 ) ) )
   METHOD bEdtFacturaPago()

   METHOD Contabiliza()
   METHOD ContabilizaContadores()

   METHOD ContabilizaSesiones()
   METHOD StartContabilizaSesiones( oImageList )
   METHOD EvalContabilizaSesiones()

   METHOD CambiaEstado()

   METHOD MailArqueo()

   METHOD ActualizaStockWeb()

   METHOD SetFastReport( oFastReport )          INLINE ( if( !empty( oFastReport ), ::oFastReport := oFastReport, ) )

   METHOD lInCajaSelect( cCodigoCaja )          INLINE ( aScan( ::aCajaSelect, cCodigoCaja ) != 0 )
   METHOD nInCajaSelect( cCodigoCaja )          INLINE ( aScan( ::aCajaSelect, cCodigoCaja ) )

   METHOD End()

   METHOD TotSesion( cTurno, cCaja )

   METHOD GetTreeState( aItems )
   METHOD SetTreeState( aItems )

   METHOD SaveImporte( cCodCaj )
   METHOD LoadImporte( cCodCaj )

   METHOD GetItemCheckState( cPrompt )

   METHOD RefreshTurno()

   METHOD cBancoCuenta( uRctCli )

   METHOD cEstadoSesion()

   METHOD cInfoAperturaCierreCaja()

   METHOD idTruno()                             INLINE ( ::oDbf:cNumTur + ::oDbf:cSufTur + ::oDbf:cCodCaj )

   METHOD cNumeroCurrentTurno()                 INLINE ( SubStr( ::cCurTurno, 1, 6 ) )
   METHOD cSufijoCurrentTurno()                 INLINE ( SubStr( ::cCurTurno, 7, 2 ) )
   METHOD cNumeroSufijoCurrentTurno()           INLINE ( SubStr( ::cCurTurno, 1, 8 ) )

   METHOD cCajaCurrentTurno()                   INLINE ( SubStr( ::cCurTurno, 9, 3 ) )
   
   METHOD GetItemTree()
   METHOD GetImporteTree()
   METHOD GetColorTree()               

   METHOD setTpvRestaurante( oTpvRestaurante )  INLINE ( ::oTpvRestaurante := oTpvRestaurante )
   METHOD getTpvRestaurante()                   INLINE ( ::oTpvRestaurante )

   METHOD getTitle()                            INLINE ( ::cText )

   METHOD setSelectSend( lSelect )              INLINE ( ::lSelectSend := lSelect )
   METHOD getSelectSend()                       INLINE ( ::lSelectSend )

   METHOD setSelectRecive( lSelect )            INLINE ( ::lSelectRecive := lSelect )
   METHOD getSelectRecive()                     INLINE ( ::lSelectRecive )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem )

   DEFAULT cPath              := cPatEmp()
   DEFAULT cDriver            := cDriver()
   DEFAULT oWndParent         := GetWndFrame()

   if oMenuItem != nil
      ::nLevel                := nLevelUsr( oMenuItem )
   end if

   if IsNum( ::nLevel ) .and. nAnd( ::nLevel, 1 ) != 0
      ::lAccess               := .f.
      msgStop( "Acceso no permitido." )
      Return ( nil )
   end if

   ::cPath                    := cPath
   ::cDriver                  := cDriver
   ::oWndParent               := oWndParent

   ::oDbf                     := nil

   ::cCurCaja                 := Space( 3 )
   ::cOldCaj                  := Space( 3 )

   ::lAutoButtons             := .t.
   ::lCreateShell             := .f.
   ::lChkSimula               := .f.
   ::lNoImprimirArqueo        := .f.
   ::lEnviarMail              := .f.
   ::lChkActualizaStockWeb    := .f.
   ::lAllSesions              := .f.

   ::aTipIva                  := {}

   ::cMru                     := "gc_clock_16"

   if !empty( cFullPathEmpresa() )
      ::cIniFile              := cFullPathEmpresa() + "Empresa.Ini"
      ::oIniArqueo            := TIni():New( cFullPathEmpresa() + "Empresa.Ini" )
   end if 

   ::oTotales                 := TTotalTurno():New( Self )

   ::nScreenHorzRes           := GetSysMetrics( 0 )
   ::nScreenVertRes           := GetSysMetrics( 1 )

   // Chequa la concordancia entre estructuras------------------------------------

   ::cNumDocKey               := "cNumTur"
   ::cSufDocKey               := "cSufTur"

   ::lCreated                 := .t.

   ::cBitmap                  := clrTopArchivos

   ::lDefaultPrinter          := .t.
   ::cPrinter                 := PrnGetName()

   ::lArqueoCiego             := oUser():lArqueoCiego() 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Initiate( cText, oSender )

   ::cText              := cText
   ::oSender            := oSender
   ::lSuccesfullSend    := .f.

   ::oIniArqueo         := TIni():New( cIniEmpresa() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Build( cPath, cDriver, oWnd, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()
   DEFAULT oWnd         := GetWndFrame()

   if !empty( oWnd )
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if oMenuItem != nil
      ::nLevel          := nLevelUsr( oMenuItem )
   else
      ::nLevel          := 0
   end if

   if nAnd( ::nLevel, 1 ) != 0
      ::lAccess         := .f.
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   ::cPath              := cPath
   ::cDriver            := cDriver
   ::oWndParent         := oWnd
   ::oDbf               := nil

   ::lChkSimula         := .f.
   ::lAllSesions        := .t.

   /*
   Chequa la concordancia entre estructuras------------------------------------
   */

   ::cNumDocKey         := "cNumTur"
   ::cSufDocKey         := "cSufTur"

   ::lCreated           := .t.

   if ::OpenFiles()
      ::ContabilizaSesiones()
      ::CloseFiles()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .f.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpen             := .t.

      ::DefineFiles()

      ::oDbf:Activate(        .f., !( lExclusive ) )

      ::oDbfCaj:Activate(     .f., !( lExclusive ) )

      ::oDbfDet:Activate(     .f., !( lExclusive ) )

      DATABASE NEW ::oDbfDiv     PATH ( cPatDat() ) FILE "DIVISAS.DBF"        VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

      DATABASE NEW ::oDbfCount   PATH ( cPatEmp() ) FILE "NCOUNT.DBF"         VIA ( cDriver() ) SHARED INDEX "NCOUNT.CDX"

      DATABASE NEW ::oUser       PATH ( cPatDat() ) FILE "USERS.DBF"          VIA ( cDriver() ) SHARED INDEX "USERS.CDX"

      DATABASE NEW ::oIvaImp     PATH ( cPatDat() ) FILE "TIVA.DBF"           VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      DATABASE NEW ::oImpTik     PATH ( cPatDat() ) FILE "ImpTik.Dbf"         VIA ( cDriver() ) SHARED INDEX "ImpTik.Cdx"

      DATABASE NEW ::oCaja       PATH ( cPatDat() ) FILE "Cajas.Dbf"          VIA ( cDriver() ) SHARED INDEX "Cajas.Cdx"

      DATABASE NEW ::oDbfUsr     PATH ( cPatDat() ) FILE "Users.Dbf"          VIA ( cDriver() ) SHARED INDEX "Users.Cdx"

      DATABASE NEW ::oEntSal     PATH ( cPatEmp() ) FILE "EntSal.Dbf"         VIA ( cDriver() ) SHARED INDEX "EntSal.Cdx"
      ::oEntSal:OrdSetFocus( "cTurEnt" )

      DATABASE NEW ::oTikT       PATH ( cPatEmp() ) FILE "TIKET.DBF"          VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"
      ::oTikT:OrdSetFocus( "cTurTik" )

      DATABASE NEW ::oTikL       PATH ( cPatEmp() ) FILE "TIKEL.DBF"          VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

      DATABASE NEW ::oTikP       PATH ( cPatEmp() ) FILE "TIKEP.DBF"          VIA ( cDriver() ) SHARED INDEX "TIKEP.CDX"
      ::oTikP:OrdSetFocus( "cTurPgo" )

      ::oPreCliT  := TDataCenter():oPreCliT()
      ::oPreCliT:OrdSetFocus( "CTURPRE" )

      DATABASE NEW ::oPreCliL    PATH ( cPatEmp() ) FILE "PRECLIL.DBF"        VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

      ::oPedCliT := TDataCenter():oPedCliT()
      ::oPedCliT:OrdSetFocus( "CTURPED" )

      DATABASE NEW ::oPedCliL    PATH ( cPatEmp() ) FILE "PEDCLIL.DBF"        VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

      DATABASE NEW ::oPedCliP    PATH ( cPatEmp() ) FILE "PEDCLIP.DBF"        VIA ( cDriver() ) SHARED INDEX "PEDCLIP.CDX"
      ::oPedCliP:OrdSetFocus( "cTurRec" )

      ::oFacCliT := TDataCenter():oFacCliT()
      ::oFacCliT:OrdSetFocus( "CTURFAC" )

      DATABASE NEW ::oFacCliL    PATH ( cPatEmp() ) FILE "FACCLIL.DBF"     VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      ::oFacCliP := TDataCenter():oFacCliP()
      ::oFacCliP:OrdSetFocus( "cTurRec" )

      DATABASE NEW ::oRctCliT    PATH ( cPatEmp() ) FILE "FacRecT.DBF"     VIA ( cDriver() ) SHARED INDEX "FacRecT.CDX"
      ::oRctCliT:OrdSetFocus( "cTurFac" )

      DATABASE NEW ::oRctCliL    PATH ( cPatEmp() ) FILE "FacRecL.DBF"     VIA ( cDriver() ) SHARED INDEX "FacRecL.CDX"

      ::oAlbCliT := TDataCenter():oAlbCliT()
      ::oAlbCliT:OrdSetFocus( "cTurAlb" )

      DATABASE NEW ::oAlbCliL    PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"     VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

      DATABASE NEW ::oAlbCliP    PATH ( cPatEmp() ) FILE "ALBCLIP.DBF"     VIA ( cDriver() ) SHARED INDEX "ALBCLIP.CDX"
      ::oAlbCliP:OrdSetFocus( "cTurRec" )

      DATABASE NEW ::oArticulo   PATH ( cPatArt() ) FILE "ARTICULO.DBF"    VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      DATABASE NEW ::oClient     PATH ( cPatCli() ) FILE "CLIENT.DBF"      VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

      DATABASE NEW ::oProvee     PATH ( cPatPrv() ) FILE "Provee.Dbf"      VIA ( cDriver() ) SHARED INDEX "Provee.Cdx"

      DATABASE NEW ::oFPago      PATH ( cPatEmp() ) FILE "FPAGO.DBF"       VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

      DATABASE NEW ::oFacPrvT    PATH ( cPatEmp() ) FILE "FACPRVT.DBF"     VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"
      ::oFacPrvT:OrdSetFocus( "CTURFAC" )

      DATABASE NEW ::oFacPrvL    PATH ( cPatEmp() ) FILE "FACPRVL.DBF"     VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

      DATABASE NEW ::oFacPrvP    PATH ( cPatEmp() ) FILE "FACPRVP.DBF"     VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

      DATABASE NEW ::oAlbPrvT    PATH ( cPatEmp() ) FILE "ALBPROVT.DBF"    VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"
      ::oAlbPrvT:OrdSetFocus( "CTURALB" )

      DATABASE NEW ::oAlbPrvL    PATH ( cPatEmp() ) FILE "ALBPROVL.DBF"    VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

      DATABASE NEW ::oPedPrvT    PATH ( cPatEmp() ) FILE "PEDPROVT.DBF"    VIA ( cDriver() ) SHARED INDEX "PEDPROVT.CDX"
      ::oPedPrvT:OrdSetFocus( "CTURPED" )

      DATABASE NEW ::oRctPrvT    PATH ( cPatEmp() ) FILE "RctPrvT.Dbf"     VIA ( cDriver() ) SHARED INDEX "RctPrvT.Cdx"
      ::oRctPrvT:OrdSetFocus( "cTurFac" )

      DATABASE NEW ::oRctPrvL    PATH ( cPatEmp() ) FILE "RctPrvL.Dbf"     VIA ( cDriver() ) SHARED INDEX "RctPrvL.Cdx"

      DATABASE NEW ::oAntCliT    PATH ( cPatEmp() ) FILE "AntCliT.Dbf"     VIA ( cDriver() ) SHARED INDEX "AntCliT.Cdx"

      DATABASE NEW ::oFamilia    PATH ( cPatArt() ) FILE "Familias.Dbf"    VIA ( cDriver() ) SHARED INDEX "Familias.Cdx"

      DATABASE NEW ::oTemporada  PATH ( cPatArt() ) FILE "Temporadas.Dbf"  VIA ( cDriver() ) SHARED INDEX "Temporadas.Cdx"

      DATABASE NEW ::oContador   PATH ( cPatEmp() ) FILE "nCount.Dbf"      VIA ( cDriver() ) SHARED INDEX "nCount.Cdx"

      DATABASE NEW ::oDbfEmp     PATH ( cPatDat() ) FILE "Empresa.Dbf"     VIA ( cDriver() ) SHARED INDEX "Empresa.Cdx"

      DATABASE NEW ::oDbfDoc     PATH ( cPatEmp() ) FILE "RDocumen.Dbf"    VIA ( cDriver() ) SHARED INDEX "RDocumen.Cdx"
      ::oDbfDoc:OrdSetFocus( "cTipo" )

      DATABASE NEW ::oEmpBnc     PATH ( cPatEmp() ) FILE "EmpBnc.Dbf"      VIA ( cDriver() ) SHARED INDEX "EmpBnc.Cdx"

      DATABASE NEW ::oLogPorta   PATH ( cPatEmp() ) FILE "LogPorta.Dbf"    VIA ( cDriver() ) SHARED INDEX "LogPorta.Cdx"

      ::oTipInv                  := TInvitacion():Create( cPatEmp() )
      if !::oTipInv:OpenFiles( .f. )
         lOpen                   := .f.
      end if

      if empty( ::oBandera )
         ::oBandera              := TBandera():New()
      end if 
      
      ::oNewImp                  := TNewImp():Create( cPatEmp() )
      if !::oNewImp:OpenFiles( .f. )
         lOpen                   := .f.
      end if

      ::oTipArt                  := TTipArt():Create( cPatArt() )
      if !::oTipArt:OpenFiles()
         lOpen                   := .f.
      end if

      ::oFabricante              := TFabricantes():Create( cPatArt() )
      if !::oFabricante:OpenFiles()
         lOpen                   := .f.
      end if

      ::oCuentasBancarias        := TCuentasBancarias():Create( cPatEmp() )
      if !::oCuentasBancarias:OpenFiles()
         lOpen                   := .f.
      end if

      ::lLoadDivisa()

   RECOVER USING oError

      lOpen             := .f.
      msgStop( "Imposible abrir todas las bases de datos de sesiones" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::DefineFiles()

      ::oDbf:Activate( .f., !( lExclusive ) )
      ::oDbfCaj:Activate( .f., !( lExclusive ) )
      ::oDbfDet:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseService()

      msgStop( "Imposible abrir todas las bases de datos de turnos." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver

   DEFINE DATABASE ::oDbf FILE "TURNO.DBF" CLASS "TurnoT" ALIAS "TurnoT" PATH ( cPath ) VIA ( cDriver ) COMMENT  "Sesiones"

      FIELD NAME "lSndTur" TYPE "L"  LEN  1  DEC 0 COMMENT ""                                                                    HIDE                     OF ::oDbf
      FIELD CALCULATE NAME "bSndTur" LEN 14  DEC 0 COMMENT { "Envio", "gc_mail2_16" , 3 }   VAL {|| ::oDbf:lSndTur } BITMAPS "gc_mail2_12", "Nil16"       COLSIZE 20  OF ::oDbf
      FIELD NAME "lCloTur" TYPE "L"  LEN  1  DEC 0 COMMENT ""                                                                    HIDE                     OF ::oDbf
      FIELD NAME "lConTur" TYPE "L"  LEN  1  DEC 0 COMMENT "Cn"                                                                  HIDE                     OF ::oDbf
      FIELD CALCULATE NAME "bCloTur" LEN 14  DEC 0 COMMENT { "Contabilizado", "gc_folder2_16" , 3 } ;
                                                   VAL {|| ::oDbf:lConTur } BITMAPS "gc_folder2_12", "Nil16"                             COLSIZE 20               OF ::oDbf
      FIELD CALCULATE NAME "cStaTur" LEN 20  DEC 0 COMMENT "Estado" VAL {|| ::cEstadoSesion() }                                  COLSIZE 60               OF ::oDbf

      FIELD NAME "cNumTur" TYPE "C"  LEN  6  DEC 0 COMMENT "Número"                                                              COLSIZE 60 ALIGN RIGHT   OF ::oDbf
      FIELD NAME "cSufTur" TYPE "C"  LEN  2  DEC 0 COMMENT "Delegación"                                                          COLSIZE 40               OF ::oDbf
      FIELD NAME "cCodCaj" TYPE "C"  LEN  3  DEC 0 COMMENT "Caja"                                                                COLSIZE 50               OF ::oDbf

      FIELD NAME "dOpnTur" TYPE "D"  LEN  8  DEC 0 COMMENT "Fecha inicio"                                                        COLSIZE 80               OF ::oDbf
      FIELD NAME "cHorOpn" TYPE "C"  LEN  5  DEC 0 COMMENT "Hora inicio"                                                         COLSIZE 60               OF ::oDbf
      FIELD NAME "dCloTur" TYPE "D"  LEN  8  DEC 0 COMMENT "Fecha fin"                                                           COLSIZE 80               OF ::oDbf
      FIELD NAME "cHorClo" TYPE "C"  LEN  5  DEC 0 COMMENT "Hora fin"                                                            COLSIZE 60               OF ::oDbf
      FIELD NAME "cCajTur" TYPE "C"  LEN  3  DEC 0 COMMENT "Usuario"                                                             COLSIZE 50               OF ::oDbf
      FIELD CALCULATE NAME "cNcjTur" LEN 150 DEC 0 COMMENT "Nombre" VAL {|| ::cNombreUser() }                                    COLSIZE 180              OF ::oDbf
      FIELD NAME "lBefClo" TYPE "L"  LEN  1  DEC 0 COMMENT ""                                                                    HIDE                     OF ::oDbf
      FIELD NAME "mComTur" TYPE "M"  LEN 10  DEC 0 COMMENT "Comentarios"                                                         COLSIZE 300              OF ::oDbf
      FIELD NAME "nStaTur" TYPE "N"  LEN  1  DEC 0 COMMENT ""                                                                    HIDE                     OF ::oDbf

      INDEX TO "Turno.Cdx" TAG "cNumTur" ON "cNumTur + cSufTur + cCodCaj"  COMMENT "Número"        FOR "!Deleted()"                       OF ::oDbf
      INDEX TO "Turno.Cdx" TAG "dOpnTur" ON "dOpnTur"                      COMMENT "Fecha inicio"  FOR "!Deleted()"                       OF ::oDbf
      INDEX TO "Turno.Cdx" TAG "lSndTur" ON "lSndTur"                                              FOR "!Deleted()"                       OF ::oDbf
      INDEX TO "Turno.Cdx" TAG "nStaTur" ON "nStaTur"                                              FOR "!Deleted() .and. nStaTur != 0"    OF ::oDbf
      INDEX TO "Turno.Cdx" TAG "nStaCaj" ON "cCodCaj + str( nStaTur, 1 )"                          FOR "!Deleted() .and. nStaTur != 0"    OF ::oDbf
                  
   END DATABASE ::oDbf

   DEFINE DATABASE ::oDbfCaj FILE "TURNOC.DBF" CLASS "TurnoC" ALIAS "TurnoC" PATH ( cPath ) VIA ( cDriver ) COMMENT "Cajas por sesiones"

      FIELD NAME "cNumTur" TYPE "C"  LEN  6  DEC 0 COMMENT ""                                                  OF ::oDbfCaj
      FIELD NAME "cSufTur" TYPE "C"  LEN  2  DEC 0 COMMENT ""                                                  OF ::oDbfCaj
      FIELD NAME "cCodCaj" TYPE "C"  LEN  3  DEC 0 COMMENT "Caja"                                              OF ::oDbfCaj
      
      FIELD NAME "lCajClo" TYPE "L"  LEN  1  DEC 0 COMMENT "Caja cerrada"                                      OF ::oDbfCaj
      FIELD NAME "lCajSel" TYPE "L"  LEN  1  DEC 0 COMMENT "Caja seleccionada"                                 OF ::oDbfCaj
      FIELD NAME "cCajTur" TYPE "C"  LEN  3  DEC 0 COMMENT "Usuario cierre"                                    OF ::oDbfCaj
      FIELD CALCULATE NAME "cNcjTur" LEN 150 DEC 0 COMMENT "Nombre"      VAL {|| ::cNombreUser() }             OF ::oDbfCaj
      FIELD NAME "dFecClo" TYPE "D"  LEN  8  DEC 0 COMMENT "Fecha Fin"                                         OF ::oDbfCaj
      FIELD NAME "cHorClo" TYPE "C"  LEN  5  DEC 0 COMMENT "Hora Fin"                                          OF ::oDbfCaj
      FIELD NAME "cDivEfe" TYPE "C"  LEN  3  DEC 0 COMMENT "Divisa de efectivo"                                OF ::oDbfCaj
      FIELD NAME "nCanEfe" TYPE "N"  LEN 16  DEC 6 COMMENT "Importe de efectivo"                               OF ::oDbfCaj
      FIELD NAME "cMonEfe" TYPE "C"  LEN 200 DEC 0 COMMENT ""                                                  OF ::oDbfCaj
      FIELD NAME "cDivTar" TYPE "C"  LEN  3  DEC 0 COMMENT "Divisa de tarjeta"                                 OF ::oDbfCaj
      FIELD NAME "nCanTar" TYPE "N"  LEN 16  DEC 6 COMMENT "Importe de tarjeta"                                OF ::oDbfCaj
      FIELD NAME "nCanRet" TYPE "N"  LEN 16  DEC 6 COMMENT "Importe retirado"                                  OF ::oDbfCaj
      FIELD NAME "cMonRet" TYPE "C"  LEN 200 DEC 0 COMMENT ""                                                  OF ::oDbfCaj
      FIELD NAME "nCanPre" TYPE "N"  LEN 16  DEC 6 COMMENT "Objetivo de la sesión"                             OF ::oDbfCaj
      FIELD NAME "cDivPre" TYPE "C"  LEN  3  DEC 0 COMMENT "Divisa del objetivo de la sesión"                  OF ::oDbfCaj
      FIELD NAME "cCajOpe" TYPE "C"  LEN  3  DEC 0 COMMENT "Usuario inicio"                                    OF ::oDbfCaj
      FIELD NAME "dFecOpe" TYPE "D"  LEN  8  DEC 0 COMMENT "Fecha inicio"                                      OF ::oDbfCaj
      FIELD NAME "cHorOpe" TYPE "C"  LEN  5  DEC 0 COMMENT "Hora inicio"                                       OF ::oDbfCaj

      INDEX TO "TURNOC.CDX" TAG "cNumTur" ON "cNumTur + cSufTur + cCodCaj"    FOR "!Deleted()"                 OF ::oDbfCaj
      INDEX TO "TURNOC.CDX" TAG "cCodCaj" ON "cCodCaj"                        FOR "!Deleted()"                 OF ::oDbfCaj
      INDEX TO "TURNOC.CDX" TAG "lCajClo" ON "lCajClo"                        FOR "!Deleted()"                 OF ::oDbfCaj
      INDEX TO "TURNOC.CDX" TAG "dFecClo" ON "dFecClo"                        FOR "!Deleted()"                 OF ::oDbfCaj
      INDEX TO "TURNOC.CDX" TAG "cCajClo" ON "cCodCaj"                        FOR "!Deleted() .and. !lCajClo"  OF ::oDbfCaj

   END DATABASE ::oDbfCaj

   /*
   Chequa la concordancia entre estructuras------------------------------------
   */

   DEFINE DATABASE ::oDbfDet FILE "TURNOL.DBF" CLASS "TurnoL" ALIAS "TurnoL" PATH ( cPath ) VIA ( cDriver ) COMMENT  "Lineas de contadores en turnos de venta"

      FIELD NAME "cNumTur" TYPE "C" LEN  6   DEC 0 COMMENT "Número"                          PICTURE "######"  OF ::oDbfDet
      FIELD NAME "cSufTur" TYPE "C" LEN  2   DEC 0 COMMENT "Sufijo"                                            OF ::oDbfDet
      FIELD NAME "cCodCaj" TYPE "C" LEN  3   DEC 0 COMMENT "Caja"                                              OF ::oDbfDet
      FIELD NAME "cCodArt" TYPE "C" LEN 18   DEC 0 COMMENT "Código del artículo"                               OF ::oDbfDet
      FIELD NAME "cNomArt" TYPE "C" LEN 50   DEC 0 COMMENT "Nombre del artículo"                               OF ::oDbfDet
      FIELD NAME "nCanAnt" TYPE "N" LEN 16   DEC 6 COMMENT "Cantidad anterior del artículo"                    OF ::oDbfDet
      FIELD NAME "nCanAct" TYPE "N" LEN 16   DEC 6 COMMENT "Cantidad posterior del artículo"                   OF ::oDbfDet
      FIELD NAME "nPvpArt" TYPE "N" LEN 16   DEC 6 COMMENT "Importe de venta del artículo"                     OF ::oDbfDet
      FIELD NAME "nIvaArt" TYPE "N" LEN  5   DEC 2 COMMENT "Porcentaje de " + cImp() + " del artículo"         OF ::oDbfDet
      FIELD NAME "nValImp" TYPE "N" LEN 16   DEC 6 COMMENT "Importe de impuesto especial"    PICTURE ::cPouDiv OF ::oDbfDet

      INDEX TO "Turnol.Cdx" TAG "cNumTur" ON "cNumTur + cSufTur + cCodCaj + cCodArt" FOR "!Deleted()"          OF ::oDbfDet

   END DATABASE ::oDbfDet

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD CloseService()

   if ::oDbf:Used()
      ::oDbf:end()
   end if

   if ::oDbfCaj:Used()
      ::oDbfCaj:end()
   end if

   if ::oDbfDet:Used()
      ::oDbfDet:end()
   end if

   ::oDbf         := nil
   ::oDbfCaj      := nil
   ::oDbfDet      := nil

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   local oSnd

   ::CreateShell()

   DEFINE BTNSHELL RESOURCE "BUS" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
      HOTKEY   "B";

      ::oWndBrw:AddSeaBar()

   DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:SetOnProcess(), if( ::oDbf:nStaTur == cajCerrrada, ::lArqueoTurno( .t. ), MsgStop( "Sesión " + Alltrim( ::oDbf:cNumTur ) + " no cerrada." ) ), ::oWndBrw:QuitOnProcess(), ::oWndBrw:SetFocus() );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "STOPWATCH_REFRESH_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:SetOnProcess(), ::lArqueoTurno( .f., .t. ), ::oWndBrw:QuitOnProcess() );
      TOOLTIP  "(A)rqueo parcial";
      HOTKEY   "A";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "STOPWATCH_STOP_" OF ::oWndBrw ; 
      NOBORDER ;
      ACTION   ( ::oWndBrw:SetOnProcess(), ::lArqueoTurno( .f. ), ::oWndBrw:QuitOnProcess(), ::oWndBrw:SetFocus() );
      TOOLTIP  "(C)errar sesión";
      HOTKEY   "C";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "STOPWATCH_RESET_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:SetOnProcess(), ::lInvCierre(), ::oWndBrw:QuitOnProcess(), ::oWndBrw:SetFocus() );
      TOOLTIP  "I(n)vertir cierre";
      HOTKEY   "N";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "IMP" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::DlgImprimir( IS_PRINTER ), ::oWndBrw:SetFocus() );
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "Prev1" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::DlgImprimir( IS_SCREEN ), ::oWndBrw:SetFocus() );
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "BmpConta" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:SetOnProcess(), ::ContabilizaSesiones(), ::oWndBrw:QuitOnProcess(),::oWndBrw:Refresh() );
      TOOLTIP  "C(o)ntabilizar";
      HOTKEY   "O";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "CHGSTATE" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::SelectRec( {|| ::CambiaEstado() }, "Cambiar estado", "Contabilizado" ), ::oWndBrw:Refresh() );
      TOOLTIP  "Cambiar es(t)ado";
      HOTKEY   "T";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oSnd RESOURCE "Lbl" OF ::oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( ::SelectRec( {| lSel | ::lSelectTurno( lSel ) }, "Seleccionar sesiones para enviar", "Enviar" ), ::oWndBrw:Refresh() );
      TOOLTIP  "En(v)iar" ;
      HOTKEY   "V";

   DEFINE BTNSHELL RESOURCE "BFILTER" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::Filter() ) ;
      TOOLTIP  "(F)iltrar" ;
      HOTKEY   "F";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "END" GROUP OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::End() ) ;
      TOOLTIP  "(S)alir" ;
      HOTKEY   "S"

   ::oWndBrw:cHtmlHelp  := "Sesión"
   ::oWndBrw:bEdit      := {|| ::oWndBrw:SetOnProcess(), if( ::oDbf:nStaTur == cajCerrrada, ::lArqueoTurno( .t. ), MsgStop( "Sesión " + Alltrim( ::oDbf:cNumTur ) + " no cerrada." ) ), ::oWndBrw:QuitOnProcess(), ::oWndBrw:SetFocus() }

   ::oWndBrw:Activate( , , , , , , , , , , , , , , , , {|| ::CloseFiles() } )

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "TURNOS" TITLE "Sesión"

      REDEFINE GET ::oDbf:cNumTur UPDATE;
         ID       100 ;
         WHEN     ( .f. ) ;
         PICTURE  "######" ;
         OF       oDlg

      REDEFINE GET ::oDbf:cCloTur UPDATE;
         ID       110 ;
         SPINNER ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cCajTur UPDATE ;
         ID       120 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cNcjTur UPDATE ;
         ID       121 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:dOpnTur UPDATE ;
         ID       130 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cHorOpn UPDATE ;
         ID       140 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:dCloTur UPDATE ;
         ID       150 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cHorClo UPDATE ;
         ID       160 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD CloseFiles()

   if !empty( ::oDbf ) .and.::oDbf:Used()
      ::oDbf:end()
   end if

   if !empty( ::oDbfCaj ) .and.::oDbfCaj:Used()
      ::oDbfCaj:end()
   end if

   if !empty( ::oDbfDet ) .and.::oDbfDet:Used()
      ::oDbfDet:end()
   end if

   if !empty( ::oEntSal ) .and. ::oEntSal:Used()
      ::oEntSal:end()
   end if

   if !empty( ::oTikT ) .and. ::oTikT:Used()
      ::oTikT:end()
   end if

   if !empty( ::oTikL ) .and. ::oTikL:Used()
      ::oTikL:end()
   end if

   if !empty( ::oTikP ) .and. ::oTikP:Used()
      ::oTikP:end()
   end if

   if !empty( ::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:end()
   end if

   if !empty( ::oPreCliL ) .and. ::oPreCliL:Used()
      ::oPreCliL:end()
   end if

   if !empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:end()
   end if

   if !empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:end()
   end if

   if !empty( ::oPedCliP ) .and. ::oPedCliP:Used()
      ::oPedCliP:end()
   end if

   if !empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:end()
   end if

   if !empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:end()
   end if

   if !empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:end()
   end if

   if !empty( ::oRctCliT ) .and. ::oRctCliT:Used()
      ::oRctCliT:end()
   end if

   if !empty( ::oRctCliL ) .and. ::oRctCliL:Used()
      ::oRctCliL:end()
   end if

   if !empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:end()
   end if

   if !empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:end()
   end if

   if !empty( ::oAlbCliP ) .and. ::oAlbCliP:Used()
      ::oAlbCliP:end()
   end if

   if !empty( ::oArticulo ) .and. ::oArticulo:Used()
      ::oArticulo:end()
   end if

   if !empty( ::oUser ) .and. ::oUser:Used()
      ::oUser:end()
   end if

   if !empty( ::oContador ) .and. ::oContador:Used()
      ::oContador:end()
   end if

   if !empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:end()
   end if

   if !empty( ::oDbfCaj ) .and. ::oDbfCaj:Used()
      ::oDbfCaj:end()
   end if

   if !empty( ::oDbfDet ) .and. ::oDbfDet:Used()
      ::oDbfDet:end()
   end if

   if !empty( ::oDbfDiv ) .and. ::oDbfDiv:Used()
      ::oDbfDiv:end()
   end if

   if !empty( ::oIvaImp ) .and. ::oIvaImp:Used()
      ::oIvaImp:end()
   end if

   if !empty( ::oClient ) .and. ::oClient:Used()
      ::oClient:end()
   end if

   if !empty( ::oProvee ) .and. ::oProvee:Used()
      ::oProvee:end()
   end if

   if !empty( ::oFPago ) .and. ::oFPago:Used()
      ::oFPago:end()
   end if

   if !empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:end()
   end if

   if !empty( ::oRctPrvT ) .and. ::oRctPrvT:Used()
      ::oRctPrvT:end()
   end if

   if !empty( ::oPedPrvT ) .and. ::oPedPrvT:Used()
      ::oPedPrvT:end()
   end if

   if !empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:end()
   end if

   if !empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:end()
   end if

   if !empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:end()
   end if

   if !empty( ::oRctPrvL ) .and. ::oRctPrvL:Used()
      ::oRctPrvL:end()
   end if

   if !empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:end()
   end if

   if !empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:end()
   end if

   if !empty( ::oCaja ) .and. ::oCaja:Used()
      ::oCaja:end()
   end if

   if !empty( ::oImpTik ) .and. ::oImpTik:Used()
      ::oImpTik:end()
   end if

   if !empty( ::oEmpBnc ) .and. ::oEmpBnc:Used()
      ::oEmpBnc:end()
   end if

   if !empty( ::oFamilia ) .and. ::oFamilia:Used()
      ::oFamilia:end()
   end if

   if !empty( ::oTemporada ) .and. ::oTemporada:Used()
      ::oTemporada:end()
   end if

   if !empty( ::oDbfEmp ) .and. ::oDbfEmp:Used()
      ::oDbfEmp:end()
   end if

   if !empty( ::oDbfDoc ) .and. ::oDbfDoc:Used()
      ::oDbfDoc:End()
   end if

   if !empty( ::oDbfUsr ) .and. ::oDbfUsr:Used()
      ::oDbfUsr:End()
   end if

   if !empty( ::oLogPorta ) .and. ::oLogPorta:Used()
      ::oLogPorta:End()
   end if

   if !empty( ::oDbfCount ) .and. ::oDbfCount:Used()
      ::oDbfCount:End()
   end if

   if !empty( ::oDbfTemporal )
      ::DestroyTemporal()
   end if

   if !empty( ::oBandera )
      ::oBandera:end()
   end if

   if !empty( ::oTipArt )
      ::oTipArt:end()
   end if

   if !empty( ::oFabricante )
      ::oFabricante:end()
   end if

   if !empty( ::oCuentasBancarias )
      ::oCuentasBancarias:End()
   end if

   if !empty( ::oNewImp )
      ::oNewImp:end()
   end if

   if !empty( ::oTipInv )
      ::oTipInv:end()
   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//
/*
Devuelve si el turno esta abierto
*/

METHOD lOpenTurno()

   ::OpenTurno    := .f.

   /*
   Caso de q el fichero este vacio---------------------------------------------
   */

   if empty( ::oDbf ) 
      Return( ::OpenTurno )
   end if

   if !::oDbf:Used()
      Return( ::OpenTurno )
   end if

   if ::oDbf:RecCount() == 0
      Return( ::OpenTurno )
   end if

   ::oDbf:GetStatus()
   ::oDbf:OrdSetFocus( "nStaTur" )
   
   ::OpenTurno    := ::oDbf:OrdKeyCount() > 0
   
   ::oDbf:SetStatus()

RETURN ( ::OpenTurno )

//--------------------------------------------------------------------------//
/*
Devuelve si quedan cajas abiertas
*/

METHOD lAnyOpenCaja()

   ::OpenCaja           := .f.

   if ::oDbfCaj:SeekInOrd( ::oDbf:cNumTur + ::oDbf:cSufTur, "cNumTur" )
      
      while ::oDbfCaj:cNumTur + ::oDbfCaj:cSufTur == ::oDbf:cNumTur + ::oDbf:cSufTur .and. !::oDbfCaj:Eof()

         ::OpenCaja     := !::oDbfCaj:lCajClo

         if ::OpenCaja
            exit 
         end if 

         ::oDbfCaj:Skip()

      end while 

   end if 

RETURN ( ::OpenCaja )

//---------------------------------------------------------------------------//
/*
Devuelve si la caja pasada esta abiertas
*/

METHOD lOpenCaja( cCodCaj )

   local aStatus
   local lOpenCaja         := .f.

   DEFAULT cCodCaj         := ::GetCurrentCaja()

   aStatus                 := ::oDbf:GetStatus()

   if .t. // uFieldEmpresa( "lDesCajas" )

      // Vamos a ver q turno esta abiertos-------------------------------------

      lOpenCaja            := ::oDbf:SeekInOrd( cCodCaj, "nStaCaj" )
      if lOpenCaja
         ::cCurTurno       := ::oDbf:cNumTur + ::oDbf:cSufTur + ::oDbf:cCodCaj
      end if 

   else 

      // Vamos a ver q cajas estan abiertas---------------------------------------
   
      if ::oDbfCaj:SeekInOrd( cCodCaj, "cCajClo" )
   
         while ::oDbfCaj:cCodCaj == cCodCaj .and. !::oDbfCaj:Eof()
   
            lOpenCaja      := oRetFld( ::oDbfCaj:cNumTur + ::oDbfCaj:cSufTur, ::oDbf, "nStaTur", "cNumTur" ) != 0
   
            if lOpenCaja 
               ::cCurTurno := ::oDbfCaj:cNumTur + ::oDbfCaj:cSufTur
               exit
            end if   
   
            ::oDbfCaj:Skip()
   
         end while         
   
      end if 
   
   end if 

   ::oDbf:SetStatus( aStatus )

RETURN ( lOpenCaja )

//---------------------------------------------------------------------------//
/*
Cierra el turno
*/

METHOD lCloseCajaSeleccionada()

   local oError
   local oBlock
   local cTurno
   local cCurrentTurno 

   // oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   // BEGIN SEQUENCE
 
   // Que nadie toque-------------------------------------------------------------

   CursorWait()

   // ::oDlgTurno:Disable()

   // Cajas deseincronizadas---------------------------------------------------

   cTurno               := ::cCurTurno
   cCurrentTurno        := ::GetFullTurno() 

   // Guardamos los comentarios---------------------------------------------------

   if !::lArqueoParcial 

      if ::oDbf:seekInOrd( cCurrentTurno, "cNumTur" )
         ::oDbf:fieldPutByName( "mComTur", ::cComentario )
      end if

      // Cerramos las cajas una a una------------------------------------------------

      if ::oDbfCaj:seekInOrd( cCurrentTurno, "cNumTur" )
         ::lCloseCaja( .t., ::oDbfCaj:cCodCaj )
      end if

      // Si hemos cerrado todas las cajas, cerramos el turno-------------------------

      ::lAllCloseTurno( cCurrentTurno )

   end if 

   // Envío de l mail--------------------------------------------------------------

   if ::lEnviarMail .and. !empty( ::cEnviarMail )

      if !empty( ::oTxt )
         ::oTxt:SetText( "Enviando mail..." )
      end if

      ::MailArqueo( cTurno ) 

   end if 

   // Envío de l mail--------------------------------------------------------------

   if ::lChkActualizaStockWeb

      if !empty( ::oTxt )
         ::oTxt:SetText( "Actualizando stocks en web..." )
      end if

      ::ActualizaStockWeb()

   end if

   // Impresion----------------------------------------------------------------

   if !::lNoImprimirArqueo

      if !empty( ::oTxt )
         ::oTxt:SetText( "Imprimiendo..." )
      end if

      ::PrintArqueo( cTurno, ::oDbfCaj:cCodCaj, ::cCmbReport, "", ::cPrnArq, ::cWinArq )

   end if 

   // Envío de  información por internet----------------------------------------

   if !::lArqueoParcial .and. ::lEnvioInformacion

      if !empty( ::oTxt )
         ::oTxt:SetText( "Enviando información..." )
      end if

      TSndRecInf():Init():AutoExecute()

   end if

   // Habilitamos el dialogo---------------------------------------------------

   // RECOVER USING oError
   //    msgStop( "Error en el proceso de cierre." + CRLF + ErrorMessage( oError ) )
   // END SEQUENCE
   // ErrorBlock( oBlock )

   CursorWe()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lCloseCaja( lClose, cCodCaja )

   local nProcc         := 0

   DEFAULT lClose       := .t.

   /*
   Ponemos todos los Pedidos de proveedor como cerrados
   */

   if !empty( ::oMeter )
      ::oMeter:Show()
      ::oMeter:nTotal   := 8
      ::oMeter:Refresh()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( "Cerrando pedidos de proveedor" )
   end if

   ::lCloPedPrv( lClose, cCodCaja )

   /*
   Ponemos todos loS albaranes de proveedor como cerrados
   */

   if !empty( ::oMeter )
      ::oMeter:Set( ++nProcc )
      ::oMeter:Refresh()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( "Cerrando albaranes de proveedor" )
   end if

   ::lCloAlbPrv( lClose, cCodCaja )

   /*
   Ponemos todos las facturas de proveedor como cerradas
   */

   if !empty( ::oMeter )
      ::oMeter:Set( ++nProcc )
      ::oMeter:Refresh()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( "Cerrando facturas de proveedor" )
   end if

   ::lCloFacPrv( lClose, cCodCaja )

   /*
   Ponemos todos los presupuestos de clientes como cerrados
   */

   if !empty( ::oMeter )
      ::oMeter:Set( ++nProcc )
      ::oMeter:Refresh()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( "Cerrando presupuestos de proveedor" )
   end if

   ::lCloPreCli( lClose, cCodCaja )

   /*
   Ponemos todos los presupuestos de clientes como cerrados
   */

   if !empty( ::oMeter )
      ::oMeter:Set( ++nProcc )
      ::oMeter:Refresh()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( "Cerrando pedidos de clientes" )
   end if

   ::lCloPedCli( lClose, cCodCaja )

   /*
   Ponemos todos loS albaranes de clientes como cerrados
   */

   if !empty( ::oMeter )
      ::oMeter:Set( ++nProcc )
      ::oMeter:Refresh()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( "Cerrando albaranes de clientes" )
   end if

   ::lCloAlbCli( lClose, cCodCaja )

   /*
   Ponemos todos las facturas de proveedor como cerradas
   */

   if !empty( ::oMeter )
      ::oMeter:Set( ++nProcc )
      ::oMeter:Refresh()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( "Cerrando facturas de clientes" )
   end if

   ::lCloFacCli( lClose, cCodCaja )

   /*
   Ponemos todos lso tikets como cerrados
   */

   if !empty( ::oMeter )
      ::oMeter:Set( ++nProcc )
      ::oMeter:Refresh()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( "Cerrando tikets" )
   end if

   ::lCloTiket( lClose, cCodCaja )

   /*
   Cerrar los pagos____________________________________________________________
   */

   if !empty( ::oMeter )
      ::oMeter:Set( ++nProcc )
      ::oMeter:Refresh()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( "Cerrando pagos" )
   end if

   ::lCloPgoTik( lClose, cCodCaja )

   /*
   Entradas y salidas----------------------------------------------------------
   */

   if !empty( ::oMeter )
      ::oMeter:Set( ++nProcc )
      ::oMeter:Refresh()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( "Cerrando entradas y salidas" )
   end if

   ::lCloEntSal( lClose, cCodCaja )

   /*
   Ponemos el estado de la caja------------------------------------------------
   */

   if !empty( ::oMeter )
      ::oMeter:Set( ++nProcc )
      ::oMeter:Refresh()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( "Cerrando cajas" )
   end if

   ::oDbfCaj:Load()
   ::oDbfCaj:lCajClo    := lClose
   ::oDbfCaj:cCajTur    := ::cCajTur
   ::oDbfCaj:dFecClo    := ::dFecTur
   ::oDbfCaj:cHorClo    := ::cHorTur
   ::oDbfCaj:Save()

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD lOneCloseTurno( cCurrentTurno )

   DEFAULT cCurrentTurno   := ::cCurTurno

   ::oDbf:GetStatus()
   ::oDbf:OrdSetFocus( "cNumTur" )

   if ::oDbf:Seek( cCurrentTurno )
      ::oDbf:Load()
         ::oDbf:nStaTur    := cajParcialmente 
         ::oDbf:dCloTur    := GetSysDate() 
         ::oDbf:cHorClo    := Substr( Time(), 1, 5 ) 
      ::oDbf:Save()
   end if 

   ::oDbf:SetStatus()

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD lAllCloseTurno( cCurrentTurno )

   local aStatus

   DEFAULT cCurrentTurno   := ::cCurTurno

   aStatus                 := ::oDbf:getStatus()   

   if ::oDbf:SeekInOrd( cCurrentTurno, "cNumTur" )

      ::oDbf:Load()
         ::oDbf:cCajTur    := ::cCajTur
         ::oDbf:lSndTur    := .t.
         ::oDbf:nStaTur    := cajCerrrada
         ::oDbf:lBefClo    := !::oDbf:lBefClo
         ::oDbf:dCloTur    := GetSysDate() 
         ::oDbf:cHorClo    := Substr( Time(), 1, 5 ) 
      ::oDbf:Save()

      // Turnos cerrados----------------------------------------------------------

      if !empty( ::oTxt )
         ::oTxt:SetText( "Cerrando la sesión" )
      end if

      CloSesion()

   else

      MsgStop( "La sesión " + Trans( cCurrentTurno, "@R ######/##" ) + " no existe", "Imposible cerrar" )

   end if

   ::oDbf:setStatus( aStatus )   

Return ( .t. )

//--------------------------------------------------------------------------//

METHOD DialogCreateTurno()

   local oDlg
   local oBmp
   local oCaja
   local cCaja
   local cNombreCaja    
   local oCodUsr
   local oNomUsr
   local cNomUsr
   local nNumTur        
   local oImporte
   local oObjetivo
   local oDescripcion
   local cPicImp        
   local oDivisa
   local cDivisa        
   local oBmpDiv
   local oSayUsr
   local cSayUsr        
   local oBtnUser
   local oDivObjetivo
   local cDivObjetivo   
   local oBmpObjetivo
   local cResource      

   if ( oRetFld( ::GetCurrentCaja(), ::oCaja, "lNoArq" ) )
      return .t.
   end if

   nNumTur              := 0
   cCaja                := ::GetCurrentCaja()
   cPicImp              := cPorDiv( cDivEmp(), ::oDbfDiv )
   cDivisa              := cDivEmp()
   cSayUsr              := Capitalize( oRetFld( Auth():Codigo(), ::oUser ) )
   cDivObjetivo         := cDivEmp()
   cNombreCaja          := Alltrim( oRetFld( ::GetCurrentCaja(), ::oCaja ) )
   cResource            := "ApTurnoTCT"

   /*
   Valores iniciales para la edicion-------------------------------------------
   */

   ::dOpenTurno         := GetSysDate()
   ::cHoraTurno         := SubStr( Time(), 1, 5 )
   ::cCajeroTurno       := Auth():Codigo()
   ::nObjetivoTurno     := 0
   ::nImporteTurno      := ::GetLastEfectivo()
   ::cDescripcionTurno  := "Apertura de sesión " + cNombreCaja

   /*
   Comienza el dialogo---------------------------------------------------------
   */

   if ::lArqueoTactil()
      cResource         := "ApTurnoTCT"
   else
      cResource         := "ApTurno"
   end if

   DEFINE DIALOG oDlg RESOURCE cResource

      REDEFINE BITMAP oBmp ;
        ID        600 ;
        RESOURCE  "gc_clock_play_48" ;
        TRANSPARENT ;
        OF        oDlg

      REDEFINE GET nNumTur UPDATE;
         ID       100 ;
         WHEN     ( .f. ) ;
         PICTURE  "######" ;
         OF       oDlg

      REDEFINE GET ::dOpenTurno UPDATE;
         ID       110 ;
         WHEN     ( .f. ) ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET ::cHoraTurno UPDATE;
         ID       120 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET oCaja VAR cCaja UPDATE ;
         ID       170 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET cNombreCaja UPDATE ;
         ID       171 ;
         WHEN     ( .f. ) ;
         OF       oDlg

    if ::lArqueoTactil()

      REDEFINE GET oCodUsr VAR ::cCajeroTurno UPDATE ;
         ID       130 ;
         VALID    cUser( oCodUsr, , oNomUsr ) ;
         BITMAP   "LUPA_24" ;
         ON HELP  ( BrwUserTactil( oCodUsr, , oNomUsr ) ) ;
         OF       oDlg

      oCodusr:nMargin   := 25

    else

      REDEFINE GET oCodUsr VAR ::cCajeroTurno UPDATE ;
         ID       130 ;
         VALID    cUser( oCodUsr, , oNomUsr ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwUser( oCodUsr, , oNomUsr ) ) ;
         OF       oDlg

    end if

      REDEFINE GET oNomUsr VAR cNomUsr UPDATE ;
         ID       131 ;
         WHEN     ( .f. ) ;
         OF       oDlg

   if ::lArqueoTactil()

      REDEFINE BUTTONBMP ;
         ID       210 ;
         OF       oDlg ;
         BITMAP   "gc_calculator_32" ;
         ACTION   ( Calculadora( 0, oImporte ) )

   end if      

      REDEFINE GET oImporte VAR ::nImporteTurno ;
         ID       140 ;
         PICTURE  ( cPicImp ) ;
         OF       oDlg

      REDEFINE GET oDivisa VAR cDivisa ;
         ID       141 ;
         VALID    ( cDiv( oDivisa, oBmpDiv, , , , ::oDbfDiv:cAlias, ::oBandera ) ) ;
         WHEN     ( .f. ) ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET oDescripcion VAR ::cDescripcionTurno;
         ID       150 ;
         PICTURE  "@!" ;
         OF       oDlg

   if ::lArqueoTactil()

      REDEFINE BUTTONBMP ;
         ID       220 ;
         OF       oDlg ;
         BITMAP   "gc_calculator_32" ;
         ACTION   ( Calculadora( 0, oObjetivo ) )

   end if

      REDEFINE GET oObjetivo VAR ::nObjetivoTurno ;
         ID       160 ;
         PICTURE  ( cPicImp ) ;
         OF       oDlg

      REDEFINE GET oDivObjetivo VAR cDivObjetivo ;
         ID       161 ;
         VALID    ( cDiv( oDivObjetivo, oBmpObjetivo, , , , ::oDbfDiv:cAlias, ::oBandera ) ) ;
         WHEN     ( .f. ) ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( ::CreateTurno( oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ::CreateTurno( oDlg ) } )

   oDlg:bStart    := {|| ::StartCreateTurno( oDivisa, oImporte, oCodUsr ) }

   ACTIVATE DIALOG oDlg CENTER

   if !empty( oBmp )
      oBmp:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD StartCreateTurno( oDivisa, oImporte, oCodUsr )

   oDivisa:lValid()

   oCodUsr:lValid()

   oImporte:lValid()   
   oImporte:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreateTurno( oDlg )

   if empty( ::cCajeroTurno )
      MsgStop( "Debe de cumplimentar el usuario", "Imposible realizar apertura" )
      Return .f.
   end if

   // Creamos el registros para el turno---------------------------------------

   if empty( ::GetCurrentTurno() )

      ::CreateCabeceraTruno()

      ::SetCurrentTurno()

   end if 

   // Cargamos las cajas-------------------------------------------------------

   ::CreateCajaTurno()

   // Creamos el apunte de caja---------------------------------------------------

   ::CreateEntradaTurno()

   oDlg:end( IDOK )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD CreateCabeceraTruno()

   ::oDbf:Blank()
   ::oDbf:cNumTur    := ::cValidTurno()
   ::oDbf:cSufTur    := RetSufEmp()
   ::oDbf:cCodCaj    := ::GetCurrentCaja()
   ::oDbf:dOpnTur    := ::dOpenTurno
   ::oDbf:cHorOpn    := ::cHoraTurno
   ::oDbf:cCajTur    := ::cCajeroTurno
   ::oDbf:nStaTur    := cajAbierta
   ::oDbf:Insert()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateEntradaTurno()

   if !empty( ::nImporteTurno )

      ::oEntSal:Blank()
      ::oEntSal:nNumEnt := nNewDoc( , ::oEntSal:cAlias, "NENTSAL", , ::oDbfCount:cAlias )
      ::oEntSal:cTurEnt := ::cNumeroCurrentTurno()
      ::oEntSal:cSufEnt := ::cSufijoCurrentTurno()
      ::oEntSal:cCodCaj := ::GetCurrentCaja()
      ::oEntSal:dFecEnt := ::dOpenTurno
      ::oEntSal:dFecCre := GetSysDate()
      ::oEntSal:cTimCre := ::cHoraTurno
      ::oEntSal:cCodUsr := ::cCajeroTurno
      ::oEntSal:cDesEnt := ::cDescripcionTurno
      ::oEntSal:nImpEnt := ::nImporteTurno
      ::oEntSal:nTipEnt := 1
      ::oEntSal:lCloEnt := .f.
      ::oEntSal:lSndEnt := .t.
      ::oEntSal:cCodDiv := cDivEmp()
      ::oEntSal:nVdvDiv := nValDiv( cDivEmp(), ::oDbfDiv:cAlias  )
      ::oEntSal:Insert() 

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD cNombreUser()

   local cRet  := ""

   if ::oUser != nil .and. ::oUser:Seek( ::oDbf:cCajTur )
      cRet     := Rtrim( ::oUser:cNbrUse )
   end if

RETURN ( cRet )

//---------------------------------------------------------------------------//
/*
Tomamos el turno de los contadores---------------------------------------------
*/

METHOD cValidTurno()

   local nCurTur  

   if .t. // uFieldEmpresa( "lDesCajas" )
      nCurTur     := cNumeroSesionCaja( ::GetCurrentCaja(), ::oCaja:cAlias, ::oDbf:cAlias )
   else 
      nCurTur     := nNewDoc( nil, ::oDbf:cAlias, "nSesion", 6, ::oContador:cAlias ) 
      nCurTur     := Str( nCurTur, 6 ) 
   end if 

RETURN ( nCurTur )

//--------------------------------------------------------------------------//

METHOD MarkTurno( lMark )

   local cCurTur  := ::oDbf:cNumTur

   DEFAULT lMark  := .t.

   CursorWait()

   /*
   Seleccon de turnos----------------------------------------------------------
   */

   if ::oTikT:Seek( cCurTur )

      while ::oTikT:cTurTik == cCurTur .and. !::oTikT:eof()

         SndTikCli( lMark, ::oTikT:cAlias, ::oFacCliT:cAlias, ::oAlbCliT:cAlias )

         ::oTikT:Skip()

         SysRefresh()

      end do

   end if

   /*
   Pagos de cajas por turnos---------------------------------------------------
   */

   if ::oTikP:Seek( cCurTur )

      while ::oTikP:cTurPgo == cCurTur .and. !::oTikP:eof()

         ::oTikP:FieldPutByName( "lSndPgo", lMark )

         ::oTikP:Skip()

         SysRefresh()

      end do

   end if

   /*
   Entradas y salidas de cajas por turnos--------------------------------------
   */

   if ::oEntSal:Seek( cCurTur )

      while ::oEntSal:cTurEnt == cCurTur .and. !::oEntSal:eof()

         ::oEntSal:FieldPutByName( "lSndEnt", lMark )

         ::oEntSal:Skip()

         SysRefresh()

      end do

   end if

   /*
   Seleccion de albaranes---------------------------------------------------------
   */

   if ::oAlbCliT:Seek( cCurTur )

      while ::oAlbCliT:cTurAlb == cCurTur .and. !::oAlbCliT:eof()

         ::oAlbCliT:FieldPutByName( "lSndDoc", lMark )

         ::oAlbCliT:Skip()

         SysRefresh()

      end do

   end if

   /*
   Seleccion de facturas---------------------------------------------------------
   */

   if ::oFacCliT:Seek( cCurTur )

      while ::oFacCliT:cTurFac == cCurTur .and. !::oFacCliT:eof()

         ::oFacCliT:FieldPutByName( "lSndDoc", lMark )

         ::oFacCliT:Skip()

         SysRefresh()

      end do

   end if
   
   CursorWe()

return ( Self )

//--------------------------------------------------------------------------//

METHOD End()

   if ::oWndBrw != nil
      ::oWndBrw:end()
      ::oWndBrw  := nil
   end if

   if !empty( ::oTotales )
      ::oTotales:end()
   end if

RETURN NIL

//--------------------------------------------------------------------------//

METHOD lInvCierre()

   local oBmp
   local oBtn
   local oDlgWat
   local lVal     := .f.
   local oMsg

   if !lUsrMaster()
      MsgStop( "Solo puede invertir el cierre el usuario Administrador." )
      Return .f.
   end if

   if nUserCaja( oUser():cCaja() ) > 1
      msgStop( "Hay más de un usuario conectado a la caja", "Atención" )
      return .f.
   end if

   ::cCurTurno    := ::GetLastClose()

   if empty( ::cCurTurno )
      MsgStop( "No hay sesiones para invertir el cierre" )
      return .f.
   end if

   if ::oWndBrw != nil
      ::oWndBrw:Refresh()
   end if

   DEFINE DIALOG  oDlgWat ;
      RESOURCE    "INVTURNO" ;
      TITLE       "Invirtiendo sesión " + alltrim( trans( ::cNumeroCurrentTurno(), "@R ######" ) ) + ;
                  " delegación " + ::cSufijoCurrentTurno() + ;
                  " caja " + ::cCajaCurrentTurno()

      REDEFINE BITMAP oBmp ;
         RESOURCE "gc_clock_refresh_48" ;
         TRANSPARENT ;
         ID       500 ;
         OF       oDlgWat

      ::oAni      := TAnimat():Redefine( oDlgWat, 100, { "BAR_01" }, 1 )

      REDEFINE SAY oMsg PROMPT "" ;
         ID       110 ;
         OF       oDlgWat

      REDEFINE BUTTON oBtn;
         ID       IDOK ;
         OF       oDlgWat ;
         ACTION   ( ::InvCierre( oDlgWat, oMsg ), oDlgWat:bValid := {|| .t. }, oDlgWat:End() )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlgWat ;
         ACTION   ( oDlgWat:bValid := {|| .t. }, oDlgWat:End() ) ;

      oDlgWat:AddFastKey( VK_F5, {|| oBtn:Click() } )
      oDlgWat:AddFastKey( VK_F1, {|| ChmHelp( "Invertir_Cierre" ) } )

      oDlgWat:bStart := {|| if( !empty( ::oAni ), ::oAni:Hide(), ) }

   ACTIVATE DIALOG oDlgWat CENTER VALID ( lVal )

   if !empty( ::oAni )
      ::oAni:End()
   end if

   oBmp:End()

   ::oWndBrw:Refresh()

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD InvCierre( oDlg, oMsg )

   local bWhileCaja
   local bWhileContadores

   CursorWait()

   oDlg:Disable()

   if !empty( ::oAni )
      ::oAni:Show()
   end if

   /*
   Cerramos las cajas una a una------------------------------------------------
   */

   oMsg:SetText( 'Abriendo cajas...' )

   ::oDbfCaj:getStatusInit()
   if ::oDbfCaj:Seek( ::cCurTurno )

      while ( ::oDbfCaj:cNumTur + ::oDbfCaj:cSufTur + ::oDbfCaj:cCodCaj == ::cCurTurno ) .and. !( ::oDbfCaj:eof() )

         ::lCloseCaja( .f., ::oDbfCaj:cCodCaj )

         ::oDbfCaj:Skip()

         SysRefresh()

      end while

   end if
   ::oDbfCaj:setStatus()

   /*
   Metemos los valores anteriores en el articulo----------------------------
   */

   oMsg:SetText( 'Reestableciendo contadores' )

   ::oDbfDet:getStatusInit()
   if ::oDbfDet:Seek( ::cCurTurno )

      while eval( ::oDbfDet:cNumTur + ::oDbfDet:cSufTur + ::oDbfDet:cCodCaj == ::cCurTurno ) .and. !( ::oDbfDet:eof() )

         if ::oArticulo:Seek( ::oDbfDet:cCodArt )
            ::oArticulo:FieldPutByName( "nCntAct", ::oDbfDet:nCanAnt )
         end if

         ::oDbfDet:Skip()

         SysRefresh()

      end while

   end if
   ::oDbfDet:setStatus()

   oMsg:SetText( 'Reestableciendo turnos' )

   ::oDbf:getStatusInit()
   if ::oDbf:Seek( ::cCurTurno )
      ::oDbf:FieldPutByName( "lSndTur", .f. )
      ::oDbf:FieldPutByName( "nStaTur", cajAbierta )
   end if
   ::oDbf:setStatus()

   // El turno actual es el turno abierto--------------------------------------

   oMsg:SetText( 'Escribiendo contadores' )

   setNumeroSesionCaja( ::cNumeroSufijoCurrentTurno(), ::cCajaCurrentTurno(), ::oCaja:cAlias )

   // Cual es el turno abierto ahora-------------------------------------------

   oMsg:SetText( 'Chequeando el estado de las sesiones' )

   ::lNowOpen()

   // Ponemos el cursor--------------------------------------------------------

   if !empty( ::oAni )
      ::oAni:Hide()
   end if

   oDlg:Enable()

   CursorWe()

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD lCloEntSal( lClose, cCodCaj )

   DEFAULT lClose := .t.

   /*
   Entradas y salidas de cajas por turnos___________________________________
   */

   if ::oEntSal:Seek( ::cCurTurno + cCodCaj )

      while ::oEntSal:cTurEnt + ::oEntSal:cSufEnt + ::oEntSal:cCodCaj == ::cCurTurno + cCodCaj .and. !::oEntSal:eof()

         ::oEntSal:FieldPutByName( "lCloEnt", lClose )

         ::oEntSal:Skip()

         SysRefresh()

      end do

   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD lCloTiket( lClose, cCodCaj )

   DEFAULT lClose := .t.

   if ::oTikT:Seek( ::cCurTurno + cCodCaj )

      while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == Substr( ::cCurTurno, 1, 8 ) + cCodCaj .and. !::oTikT:eof()

         ::ActTactil()

         //if ::oTikT:nUbiTik == ubiEncargar .and. ::oTikT:lAbierto
         if ::oTikT:lAbierto
            ::oTikT:FieldPutByName( "lCloTik", .f. )
         else
            ::oTikT:FieldPutByName( "lCloTik", lClose )
         end if

         ::oTikT:Skip()

         SysRefresh()

      end do

   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD lCloPgoTik( lClose, cCodCaj )

   DEFAULT lClose := .t.

   if ::oTikP:Seek( ::cCurTurno + cCodCaj )

      while ::oTikP:cTurPgo + ::oTikP:cSufTik + ::oTikP:cCodCaj == SubStr( ::cCurTurno, 1, 8 ) + cCodCaj .and. !::oTikP:eof()

         ::oTikP:FieldPutByName( "lCloPgo", lClose )

         ::oTikP:Skip()

         SysRefresh()

      end do

   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD lCloPedPrv( lClose, cCodCaj )

   DEFAULT lClose := .t.

   if ::oPedPrvT:Seek( ::cCurTurno + cCodCaj )

      while ::oPedPrvT:cTurPed + ::oPedPrvT:cSufPed + ::oPedPrvT:cCodCaj == ::cCurTurno + cCodCaj .and. ! ::oPedPrvT:eof()

         ::oPedPrvT:FieldPutByName( "lCloPed", lClose )

         ::oPedPrvT:Skip()

         SysRefresh()

      end do

   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD lCloAlbPrv( lClose, cCodCaj )

   DEFAULT lClose := .t.

   if ::oAlbPrvT:Seek( ::cCurTurno + cCodCaj )

      while ::oAlbPrvT:cTurAlb + ::oAlbPrvT:cSufAlb + ::oAlbPrvT:cCodCaj == ::cCurTurno + cCodCaj .and. ! ::oAlbPrvT:eof()

         ::oAlbPrvT:FieldPutByName( "lCloAlb", lClose )

         ::oAlbPrvT:Skip()

         SysRefresh()

      end do

   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD lCloFacPrv( lClose, cCodCaj )

   DEFAULT lClose := .t.

   if ::oFacPrvT:Seek( ::cCurTurno + cCodCaj )

      while ::oFacPrvT:cTurFac + ::oFacPrvT:cSufFac + ::oFacPrvT:cCodCaj == ::cCurTurno + cCodCaj .and. ! ::oFacPrvT:eof()

         ::oFacPrvT:FieldPutByName( "lCloFac", lClose )

         ::oFacPrvT:Skip()

         SysRefresh()

      end do

   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD lCloRctPrv( lClose, cCodCaj )

   DEFAULT lClose := .t.

   if ::oRctPrvT:Seek( ::cCurTurno + cCodCaj )

      while ::oRctPrvT:cTurRct + ::oRctPrvT:cSufRct + ::oRctPrvT:cCodCaj == ::cCurTurno + cCodCaj .and. ! ::oRctPrvT:eof()

         ::oRctPrvT:FieldPutByName( "lCloFac", lClose )

         ::oRctPrvT:Skip()

         SysRefresh()

      end do

   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD lCloPreCli( lClose, cCodCaj )

   DEFAULT lClose := .t.

   if ::oPreCliT:Seek( ::cCurTurno + cCodCaj )

      while ::oPreCliT:cTurPre + ::oPreCliT:cSufPre + ::oPreCliT:cCodCaj == ::cCurTurno + cCodCaj .and. ! ::oPreCliT:eof()

         ::oPreCliT:FieldPutByName( "lCloPre", lClose )

         ::oPreCliT:Skip()

         SysRefresh()

      end do

   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD lCloPedCli( lClose, cCodCaj )

   DEFAULT lClose := .t.

   if ::oPedCliP:Seek( ::cCurTurno + cCodCaj )

      while ::oPedCliP:cTurRec + ::oPedCliP:cSufPed + ::oPedCliP:cCodCaj == ::cCurTurno + cCodCaj .and. !::oPedCliP:eof()

         ::oPedCliP:FieldPutByName( "lCloPgo", lClose )

         ::oPedCliP:Skip()

         SysRefresh()

      end do

   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD lCloAlbCli( lClose, cCodCaj )

   DEFAULT lClose := .t.

   if ::oAlbCliT:Seek( ::cCurTurno + cCodCaj )

      while ::oAlbCliT:cTurAlb + ::oAlbCliT:cSufAlb + ::oAlbCliT:cCodCaj == ::cCurTurno + cCodCaj .and. ! ::oAlbCliT:eof()

         ::oAlbCliT:FieldPutByName( "lCloAlb", lClose )

         ::oAlbCliT:Skip()

         SysRefresh()

      end do

   end if

   if ::oAlbCliP:Seek( ::cCurTurno + cCodCaj )

      while ::oAlbCliP:cTurRec + ::oAlbCliP:cSufAlb + ::oAlbCliP:cCodCaj == ::cCurTurno + cCodCaj .and. !::oAlbCliP:eof()

         ::oAlbCliP:FieldPutByName( "lCloPgo", lClose )

         ::oAlbCliP:Skip()

         SysRefresh()

      end do

   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD lCloFacCli( lClose, cCodCaj )

   local nRec     := ::oFacCliP:Recno()
   local nOrdAnt  := ::oFacCliP:OrdSetFocus( "CTURREC" )

   DEFAULT lClose := .t.

   if ::oFacCliT:Seek( ::cCurTurno + cCodCaj )

      while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac + ::oFacCliT:cCodCaj == ::cCurTurno + cCodCaj .and. !::oFacCliT:eof()

         ::oFacCliT:FieldPutByName( "lCloFac", lClose )

         ::oFacCliT:Skip()

         SysRefresh()

      end do

   end if

   if ::oFacCliP:Seek( ::cCurTurno + cCodCaj )

      while ::oFacCliP:cTurRec + ::oFacCliP:cSufFac + ::oFacCliP:cCodCaj == ::cCurTurno + cCodCaj .and. !::oFacCliP:eof()

         if ::oFacCliP:lCobrado
            ::oFacCliP:FieldPutByName( "lCloPgo", lClose )
         end if

         ::oFacCliP:Skip()

         SysRefresh()

      end do

   end if

   ::oFacCliP:OrdSetFocus( nOrdAnt )
   ::oFacCliP:GoTo( nRec )

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD GetLastClose()

   local cLasTur  := ""

   ::oDbf:GetRecno()

   ::oDbf:GoBottom()

   while !::oDbf:bof()

      if ::oDbf:nStaTur == cajCerrrada .and. ::oDbf:cCodCaj == ::GetCurrentCaja()
         cLasTur  := ::idTruno()
         exit
      else
         ::oDbf:Skip( -1 )
      end if

   end while

   ::oDbf:SetRecno()

RETURN ( cLasTur )

//--------------------------------------------------------------------------//

METHOD GetLastEfectivo()

   local cNumeroCaja 
   local nEfectivo   := 0

   cNumeroCaja    := ::GetLastClose()

   if ::oDbfCaj:SeekInOrd( cNumeroCaja, "cNumTur" )
      nEfectivo      := ( ::oDbfCaj:nCanEfe - ::oDbfCaj:nCanRet )
   end if

RETURN ( nEfectivo )

//--------------------------------------------------------------------------//

METHOD lArqueoTurno( lZoom, lParcial ) CLASS TTurno

   local oFnt
   local oCol
   local oError
   local oBlock
   local oFntSay
   local oFntBrw
   local oBrwCnt
   local oBrwCaj
   local oBtnMod
   local oCajTur
   local oNomCaj
   local cNomCaj
   local oCajNbr
   local cCajNbr         := "Todas"
   local aPrnCaj
   local oPrinter
   local oComentario
   local oSayGeneral
   local oBmpGeneral
   local oSayGeneral2
   local oBtnRetirado
   local oBtnCalculadora
   local oBtnEfectivo
   local nOrdAnt

   DEFAULT lZoom        := .f.
   DEFAULT lParcial     := .f.

   ::lZoom              := lZoom
   ::lArqueoParcial     := lParcial
   ::nMeter             := 0
   ::aCajaSelect        := {}

   aPrnCaj              := GetPrinters()

   // Compruebo si hay turnos abiertos--------------------------------------------

   if ::lZoom

      ::cCurTurno       := ::oDbf:cNumTur + ::oDbf:cSufTur
      ::cCajTur         := ::oDbf:cCajTur
      ::dFecTur         := ::oDbf:dOpnTur
      ::cHorTur         := ::oDbf:cHorOpn

   else

      if !::GoCurrentTurno()
         msgStop( "No puedo posicionarme en la sesión actual.")
         return .f.
      end if

      if empty( ::dFecTur )
         ::dFecTur      := GetSysDate()
      end if

      if empty( ::cHorTur )
         ::cHorTur      := Substr( Time(), 1, 5 )
      end if

      if empty( ::cCajTur )
         ::cCajTur      := Auth():Codigo()
      end if

   end if

   if empty( ::cCurCaja ) 
      ::GetCurrentCaja()
   end if

   if !::lZoom .and. empty( ::cCurTurno )
      MsgStop( "No hay sesiones para cerrar" )
      return .f.
   end if

   ::CreateCajaTurno()

   // Si estamos con las cajas desincorizadas el scope es por caja-------------

   ::oDbf:GetStatus()
   if !( ::oDbf:SeekInOrd( ::GetFullTurno(), "cNumTur" ) )
      msgStop( "Turno " + ::GetFullTurno() + " no encontrado" )
      return .f.
   end if 

   ::oDbfDet:OrdScope( ::GetFullTurno() )
   ::oDbfDet:GoTop()

   ::oDbfCaj:OrdScope( ::GetFullTurno() )
   ::oDbfCaj:GoTop()

   // Cominenza el proceso de calculo---------------------------------------------

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   // Valores para su posterior edición----------------------------------------

   ::lCerrado        := ( ::oDbf:nStaTur == cajCerrrada )
   ::cComentario     := ( ::oDbf:mComTur )

   // Seleccionamos las cajas q se van a cerrar-----------------------------------

   ::SelCajas( .t. )

   // Valores de la impresión-----------------------------------------------------

   do case
      case ::lArqueoCiego
         ::cWinArq         := cPrinterArqueoCiego(          ::cCurCaja, ::oCaja:cAlias )
         ::cPrnArq         := cFormatoArqueoCiegoEnCaja(    ::cCurCaja, ::oCaja:cAlias )
      
      case !::lArqueoCiego .and. !::lArqueoParcial
         ::cWinArq         := cPrinterArqueo(               ::cCurCaja, ::oCaja:cAlias )
         ::cPrnArq         := cFormatoArqueoEnCaja(         ::cCurCaja, ::oCaja:cAlias )
      
      case !::lArqueoCiego .and. ::lArqueoParcial
         ::cWinArq         := cPrinterArqueoParcial(        ::cCurCaja, ::oCaja:cAlias )
         ::cPrnArq         := cFormatoArqueoParcialEnCaja(  ::cCurCaja, ::oCaja:cAlias )
   end case 

   // Opciones de empresa------------------------------------------------------

   ::lEnvioInformacion     := ::oIniArqueo:Get( "Arqueo", "EnvioInformacion", .t.,           ::lEnvioInformacion )

   ::lNoImprimirArqueo     := ::oIniArqueo:Get( "Arqueo", "ImprimirArqueo",   .t.,           ::lNoImprimirArqueo )
   ::cCmbReport            := ::oIniArqueo:Get( "Arqueo", "SalidaArqueo",     "Visualizar",  ::cCmbReport )

   ::lImprimirEnvio        := ::oIniArqueo:Get( "Arqueo", "ImprimirEnvio",    .t.,           ::lImprimirEnvio )

   ::lChkActualizaStockWeb := ::oIniArqueo:Get( "Arqueo", "ActualizaStock",   .t.,           ::lChkActualizaStockWeb )

   ::lEnviarMail           := uFieldEmpresa( "lMailTrno" )
   ::cEnviarMail           := uFieldEmpresa( "cMailTrno" )
   ::cEnviarMail           := Padr( ::cEnviarMail, 200 )

   ::oMoneyEfectivo        := TVirtualMoney():New()
   ::oMoneyRetirado        := TVirtualMoney():New()

   // Refresh------------------------------------------------------------------

   if ::oWndBrw != nil
      ::oWndBrw:Refresh()
   end if

   if ::lArqueoTactil()

      oFnt              := TFont():New( "Segoe UI", 0, 22, .f., .f. )
      oFntSay           := TFont():New( "Segoe UI", 0, 30, .f., .t. )
      oFntBrw           := TFont():New( "Segoe UI", 0, 17, .f., .f. )

      DEFINE DIALOG ::oDlgTurno ;
         RESOURCE       "ARQUEO_TCT";
         TITLE          "Arqueo " + if( ::lArqueoParcial, "parcial ", " " ) + "de caja, sesión : " + Trans( ::cCurTurno, "@R ######" )

         REDEFINE PAGES ::oFldTurno ;
            ID          200 ;
            FONT        oFnt ;
            OF          ::oDlgTurno ;
            DIALOGS     "ARQUEO_1_TCT",;
                        "ARQUEO_2_TCT",;
                        "ARQUEO_3_TCT",;
                        "ARQUEO_4_TCT"

   else

      DEFINE DIALOG ::oDlgTurno ;
         RESOURCE       "ARQUEO";
         TITLE          "Arqueo " + if( ::lArqueoParcial, "parcial ", " " ) + "de caja, sesión : " + Trans( ::cCurTurno, "@R ######" )

      REDEFINE PAGES    ::oFldTurno ;
         ID             200 ;
         OF             ::oDlgTurno ;
         DIALOGS        "ARQUEO_1",;
                        "ARQUEO_2",;
                        "ARQUEO_3",;
                        "ARQUEO_4"

   end if

      // Primera caja de dialogo_______________________________________________

      REDEFINE GET ::oDbf:dOpnTur ;
         ID       80 ;
         WHEN     .f. ;
         UPDATE ;
         OF       ::oFldTurno:aDialogs[1]

      REDEFINE GET ::oDbf:cHorOpn ;
         ID       90 ;
         WHEN     .f. ;
         UPDATE ;
         OF       ::oFldTurno:aDialogs[1]

      REDEFINE GET ::oDbf:dCloTur ;
         ID       100 ;
         WHEN     .f. ;
         OF       ::oFldTurno:aDialogs[1]

      REDEFINE GET ::oDbf:cHorClo ;
         ID       110 ;
         WHEN     .f. ;
         OF       ::oFldTurno:aDialogs[1]

      if !::lArqueoTactil() .and. ::lArqueoParcial

      REDEFINE BITMAP oBmpGeneral ;
         ID       990 ;
         RESOURCE "gc_clock_refresh_48" ;
         TRANSPARENT ;
         OF       ::oFldTurno:aDialogs[1]

      end if
  
      if !::lArqueoTactil()

      REDEFINE GET oCajTur VAR ::cCajTur;
         ID       120 ;
         WHEN     ( !lZoom ) ;
         VALID    ( !empty( ::cCajTur ) .and. cUser( oCajTur, nil, oNomCaj ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwUser( oCajTur, nil, oNomCaj ) ) ;
         OF       ::oFldTurno:aDialogs[1]

      else

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE if ( lParcial, "gc_clock_refresh_48", "gc_clock_refresh_48" ) ;
         TRANSPARENT ;
         OF       ::oDlgTurno

      REDEFINE GET oCajTur VAR ::cCajTur;
         ID       120 ;
         WHEN     ( !lZoom ) ;
         VALID    ( !empty( ::cCajTur ) .and. cUser( oCajTur, nil, oNomCaj ) ) ;
         BITMAP   "LUPA_24" ;
         ON HELP  ( BrwUserTactil( oCajTur, nil, oNomCaj ) ) ;
         OF       ::oFldTurno:aDialogs[1]

      oCajTur:nMargin   := 25

      end if

      REDEFINE GET oNomCaj VAR cNomCaj ;
         ID       130 ;
         WHEN     ( .f. ) ;
         OF       ::oFldTurno:aDialogs[1]

      REDEFINE BUTTON ;
         ID       501;
         OF       ::oFldTurno:aDialogs[1] ;
         WHEN     ( oUser():lAdministrador() );
         ACTION   ( ::SelCajas( .t., oBrwCaj, .t. ) )

      REDEFINE BUTTON ;
         ID       502;
         OF       ::oFldTurno:aDialogs[1] ;
         WHEN     ( oUser():lAdministrador() );
         ACTION   ( ::SelCajas( .f., oBrwCaj, .t. ) )

      REDEFINE BUTTON ::oBtnSelectAllCajas ;
         ID       503;
         OF       ::oFldTurno:aDialogs[1] ;
         WHEN     ( oUser():lMaster() );
         ACTION   ( ::SelAllCajas( .t., oBrwCaj ) )

      REDEFINE BUTTON ::oBtnUnSelectAllCajas ;
         ID       504;
         OF       ::oFldTurno:aDialogs[1] ;
         WHEN     ( oUser():lMaster() );
         ACTION   ( ::SelAllCajas( .f., oBrwCaj ) )

      if !::lArqueoTactil()

      REDEFINE BUTTON ;
         ID       505;
         OF       ::oFldTurno:aDialogs[ 1 ] ;
         WHEN     ( oUser():lMaster() );
         ACTION   ( oBrwCaj:GoUp() )

      REDEFINE BUTTON ;
         ID       506;
         OF       ::oFldTurno:aDialogs[ 1 ] ;
         WHEN     ( oUser():lAdministrador() );
         ACTION   ( oBrwCaj:GoDown() )

      end if

      // Cajas--------------------------------------------------------------------

      oBrwCaj                 := IXBrowse():New( ::oFldTurno:aDialogs[1] )

      oBrwCaj:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwCaj:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwCaj:lHScroll        := .f.
      oBrwCaj:lVScroll        := .f.
      oBrwCaj:nMarqueeStyle   := 6
      oBrwCaj:cName           := "Turno.Cajas"

      ::oDbfCaj:SetBrowse( oBrwCaj )

      with object ( oBrwCaj:AddCol() )
         :cHeader          := ""
         :bEditValue       := {|| ::oDbfCaj:FieldGetByName( "lCajClo" ) }
         :nWidth           := 20
         :SetCheck( { "Cnt16", "Nil16" } )
      end with

      with object ( oBrwCaj:AddCol() )
         :cHeader          := "Estado"
         :bStrData         := {|| if( ::oDbfCaj:FieldGetByName( "lCajClo" ), "Cerrada", "Abierta" ) }
         :nWidth           := 80
      end with

      with object ( oBrwCaj:AddCol() )
         :cHeader          := "Seleccionada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ::lInCajaSelect( ::oDbfCaj:FieldGetByName( "cCodCaj" ) ) } // ::oDbfCaj:FieldGetByName( "lCajSel" ) }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_cash_register_16" )
      end with

      with object ( oBrwCaj:AddCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ::oDbfCaj:FieldGetByName( "cCodCaj" ) + CRLF + oRetFld( ::oDbfCaj:FieldGetByName( "cCodCaj" ), ::oCaja ) }
         :nWidth           := 200
      end with

      with object ( oBrwCaj:AddCol() )
         :cHeader          := "Ojetivo"
         :bEditValue       := {|| ::oDbfCaj:FieldGetByName( "nCanPre" ) }
         :nWidth           := 100
         :cEditPicture     := cPorDiv( cDivEmp(), ::oDbfDiv )
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :nEditType        := 1
         :bOnPostEdit      := {|o,x| ::oDbfCaj:FieldPutByName( "nCanPre", x ) }
      end with

      with object ( oBrwCaj:AddCol() )
         :cHeader          := "Nº usuarios"
         :bEditValue       := {|| nUserCaja( ::oDbfCaj:FieldGetByName( "cCodCaj" ) ) }
         :cEditPicture     := "9999"
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwCaj:AddCol() )
         :cHeader          := "Apertura y cierre"
         :bEditValue       := {|| ::cInfoAperturaCierreCaja() }
         :nWidth           := 260
      end with

      oBrwCaj:nDataLines   := 2
      oBrwCaj:nRowHeight   := 36

      oBrwCaj:bRClicked    := {| nRow, nCol, nFlags | oBrwCaj:RButtonDown( nRow, nCol, nFlags ) }

      oBrwCaj:CreateFromResource( 160 )

      // Contadores---------------------------------------------------------------

      REDEFINE BUTTON oBtnMod ;
         ID       501;
         OF       ::oFldTurno:aDialogs[2] ;
         WHEN     !::lArqueoParcial ;
         ACTION   ( oCol:Edit() )

      ::oDbfDet:lCount        := .t.

      oBrwCnt                 := IXBrowse():New( ::oFldTurno:aDialogs[2] )

      oBrwCnt:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwCnt:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwCnt:nMarqueeStyle   := 5
      oBrwCnt:lFooter         := .t.
      oBrwCnt:cName           := "Turno.Contadores"

      ::oDbfDet:SetBrowse( oBrwCnt )

      with object ( oBrwCnt:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ::oDbfDet:cCodArt }
         :nWidth           := 50
      end with

      with object ( oBrwCnt:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| ::oDbfDet:cNomArt }
         :nWidth           := 120
      end with

      with object ( oBrwCnt:AddCol() )
         :cHeader          := "Nº anterior"
         :bEditValue       := {|| ::oDbfDet:nCanAnt }
         :cEditPicture     := ::cPicUnd
         :bOnPostEdit      := {|o,u,n| ::EdtAnt( o, u, n ), ::TotContadores(), oCol:RefreshFooter(), .t. }
         :nWidth           := 75
         :nEditType        := if( !::lCerrado, EDIT_GET, EDIT_NONE )
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oCol   := oBrwCnt:AddCol() )
         :cHeader          := "Nº actual"
         :bEditValue       := {|| ::oDbfDet:nCanAct }
         :cEditPicture     := ::cPicUnd
         :bOnPostEdit      := {|o,u,n| ::EdtCol( o, u, n ), ::TotContadores(), oCol:RefreshFooter(), .t. }
         :nWidth           := 75
         :nEditType        := if( !::lCerrado, EDIT_GET, EDIT_NONE )
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwCnt:AddCol() )
         :cHeader          := "Und. venta"
         :bEditValue       := {|| ( ::oDbfDet:nCanAct - ::oDbfDet:nCanAnt ) }
         :cEditPicture     := ::cPicUnd
         :nWidth           := 75
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwCnt:AddCol() )
         :cHeader          := "Precio"
         :bEditValue       := {|| ::oDbfDet:nPvpArt }
         :cEditPicture     := ::cPouDiv
         :nWidth           := 75
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwCnt:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( ::oDbfDet:nPvpArt * ( ::oDbfDet:nCanAct - ::oDbfDet:nCanAnt ) ) }
         :bFooter          := {|| ( ::oTotales:nTotContadores( ::cCurCaja ) ) }
         :cEditPicture     := ::cPorDiv
         :nWidth           := 75
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :nFootStrAlign    := AL_RIGHT
      end with

      if ::lArqueoTactil()
         oBrwCnt:nRowHeight   := 36
      end if

      oBrwCnt:bRClicked       := {| nRow, nCol, nFlags | oBrwCnt:RButtonDown( nRow, nCol, nFlags ) }

      oBrwCnt:CreateFromResource( 140 )

      // Tree de resultados-------------------------------------------------------

      ::oBrwTotales                 := IXBrowse():New( ::oFldTurno:aDialogs[ 3 ] )

      ::oBrwTotales:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwTotales:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwTotales:lVScroll        := .t.
      ::oBrwTotales:lHScroll        := .t.
      ::oBrwTotales:nMarqueeStyle   := 5
      // ::oBrwTotales:bClrStd         := {|| ::GetColorTree() }

      with object ( ::oBrwTotales:AddCol() )
         :cHeader                   := ""
         :nWidth                    := 600
         :bStrData                  := {|| ::GetItemTree() }
         :lHide                     := .f.
      end with

      with object ( ::oBrwTotales:AddCol() )
         :cHeader                   := "Importes"
         :nWidth                    := 140
         :bStrData                  := {|| ::GetImporteTree() }
         :lHide                     := .f.
         :nDataStrAlign             := 1
         :nHeadStrAlign             := 1
         :nFootStrAlign             := 1
      end with
   
      ::oBrwTotales:CreateFromResource( 800 )

      // Cajas____________________________________________________________________

      if ::lArqueoTactil()

      REDEFINE GET ::oCodCaj ;
         VAR      ::cCurCaja ;
         ID       140 ;
         OF       ::oFldTurno:aDialogs[ 3 ]

         ::oCodCaj:bHelp   := {|| BrwCajaTactil( ::oCodCaj, oCajNbr ) }
         ::oCodCaj:bValid  := {|| ::lChangeCajas( oCajNbr ) }

      REDEFINE GET oCajNbr VAR cCajNbr ;
         ID       141 ;
         WHEN     .f. ;
         OF       ::oFldTurno:aDialogs[ 3 ]

      else

      REDEFINE GET ::oCodCaj ;
         VAR      ::cCurCaja ;
         ID       140 ;
         BITMAP   "LUPA" ;
         OF       ::oFldTurno:aDialogs[ 3 ]

         ::oCodCaj:bWhen   := {|| .f. }  
         ::oCodCaj:bHelp   := {|| BrwCajas( ::oCodCaj, oCajNbr ) }
         ::oCodCaj:bValid  := {|| ::lChangeCajas( oCajNbr ) }

      REDEFINE GET oCajNbr VAR cCajNbr ;
         ID       141 ;
         WHEN     .f. ;
         OF       ::oFldTurno:aDialogs[ 3 ]

      end if

      // Formas de pago-----------------------------------------------------------

      REDEFINE SAY   ::oSayTotalEfectivo ;
         ID          401 ;
         OF          ::oFldTurno:aDialogs[3]

      REDEFINE SAY   ::oSayTotalTarjeta ;
         ID          402 ;
         OF          ::oFldTurno:aDialogs[3]  
            
      REDEFINE SAY   ::oSayTotalNoEfectivo ;
         ID          403 ;
         OF          ::oFldTurno:aDialogs[3]     

      REDEFINE SAY   ::oSayTotalCobros ;
         ID          404 ;
         OF          ::oFldTurno:aDialogs[3] 
            
      REDEFINE GROUP ::oGrpCobros ;
         ID          500;
         OF          ::oFldTurno:aDialogs[3]    

      if ::lArqueoTactil()

      REDEFINE SAY   ::oTotalEfectivo ;
         VAR         ::oTotales:nTotSaldoEfectivo( ::cCurCaja ) ;
         ID          400 ;
         FONT        oFntSay ;
         PICTURE     ::cPorDiv ;
         OF          ::oFldTurno:aDialogs[3]

      REDEFINE SAY   ::oTotalTarjeta ;
         VAR         ::oTotales:nTotSaldoTarjeta( ::cCurCaja ) ;
         ID          410 ;
         FONT        oFntSay ;
         PICTURE     ::cPorDiv ;
         OF          ::oFldTurno:aDialogs[3]

      REDEFINE SAY   ::oTotalNoEfectivo ;
         VAR         ::oTotales:nTotSaldoNoEfectivo( ::cCurCaja ) ;
         ID          411 ;
         FONT        oFntSay ;
         PICTURE     ::cPorDiv ;
         OF          ::oFldTurno:aDialogs[3]

      REDEFINE SAY   ::oTotalCobros ;
         VAR         ( ::oTotales:nTotSaldoEfectivo( ::cCurCaja ) + ::oTotales:nTotSaldoTarjeta( ::cCurCaja ) ) ;
         ID          415 ;
         FONT        oFntSay ;
         PICTURE     ::cPorDiv ;
         OF          ::oFldTurno:aDialogs[3]

      REDEFINE BUTTONBMP oBtnEfectivo;
         ID          220 ;
         OF          ::oFldTurno:aDialogs[ 3 ] ;
         WHEN        !::lCerrado ;
         BITMAP      "gc_money2_32" ;
         ACTION      ( ::oMoneyEfectivo:Dialog( ::oImporteEfectivo ), ::RefreshTurno() )

      else

      REDEFINE SAY   ::oTotalEfectivo ;
         VAR         ::oTotales:nTotSaldoEfectivo( ::cCurCaja ) ;
         ID          400 ;
         PICTURE     ::cPorDiv ;
         OF          ::oFldTurno:aDialogs[3]

      REDEFINE SAY   ::oTotalTarjeta ;
         VAR         ::oTotales:nTotSaldoTarjeta( ::cCurCaja ) ;
         ID          410 ;
         PICTURE     ::cPorDiv ;
         OF          ::oFldTurno:aDialogs[3]

      REDEFINE SAY   ::oTotalNoEfectivo ;
         VAR         ::oTotales:nTotSaldoNoEfectivo( ::cCurCaja ) ;
         ID          411 ;
         PICTURE     ::cPorDiv ;
         OF          ::oFldTurno:aDialogs[3]

      REDEFINE SAY   ::oTotalCobros ;
         VAR         ( ::oTotales:nTotSaldoEfectivo( ::cCurCaja ) + ::oTotales:nTotSaldoTarjeta( ::cCurCaja ) ) ;
         ID          415 ;
         PICTURE     ::cPorDiv ;
         OF          ::oFldTurno:aDialogs[3]

         oBtnEfectivo               := TBtnBmp():ReDefine( 220, "gc_money2_16",,,,,{|| ::oMoneyEfectivo:Dialog( ::oImporteEfectivo ), ::RefreshTurno() }, ::oFldTurno:aDialogs[ 3 ], .f., {|| !::lCerrado }, .f., "Conteo de efectivo" )
         oBtnEfectivo:lTransparent  := .t.
         oBtnEfectivo:lBoxSelect    := .f.

      end if

      REDEFINE GET ::oImporteEfectivo ;
         VAR      ::nImporteEfectivo ;
         ID       420 ;
         FONT     oFntSay ;
         WHEN     !::lCerrado ;
         PICTURE  ::cPorDiv ;
         OF       ::oFldTurno:aDialogs[ 3 ]

      ::oImporteEfectivo:bChange    := {|| ::RefreshTurno() }

      if ::lArqueoTactil()

      REDEFINE BUTTONBMP oBtnCalculadora ;
         ID       230 ;
         OF       ::oFldTurno:aDialogs[ 3 ] ;
         WHEN     !::lCerrado ;
         BITMAP   "gc_calculator_32" ;
         ACTION   ( Calculadora( 0, ::oImporteTarjeta ), ::RefreshTurno() )

      else

         oBtnCalculadora            := TBtnBmp():ReDefine( 230, "gc_calculator_16" ,,,,, {|| Calculadora( 0, ::oImporteTarjeta ), ::RefreshTurno() }, ::oFldTurno:aDialogs[ 3 ], .f., {|| !::lCerrado }, .f., "Calculo de tarjetas" )
         oBtnCalculadora:lTransparent  := .t.
         oBtnCalculadora:lBoxSelect    := .f.

      end if

      // Importe retirado-------------------------------------------------------

      if ::lArqueoTactil()

      REDEFINE BUTTONBMP oBtnRetirado ;
         ID       235 ;
         OF       ::oFldTurno:aDialogs[ 3 ] ;
         WHEN     !::lCerrado ;
         BITMAP   "gc_money2_32" ;
         ACTION   ( ::oMoneyRetirado:Dialog( ::oImporteRetirado ), ::RefreshTurno() )

      else

         oBtnRetirado               := TBtnBmp():ReDefine( 235, "gc_money2_16",,,,,{|| ::oMoneyRetirado:Dialog( ::oImporteRetirado ), ::RefreshTurno() }, ::oFldTurno:aDialogs[ 3 ], .f., {|| !::lCerrado }, .f., "Conteo de retirado" )
         oBtnRetirado:lTransparent  := .t.
         oBtnRetirado:lBoxSelect    := .f.

      end if

      REDEFINE GET ::oImporteRetirado ;
         VAR      ::nImporteRetirado ;
         ID       460 ;
         FONT     oFntSay ;
         WHEN     !::lCerrado ;
         PICTURE  ::cPorDiv ;
         OF       ::oFldTurno:aDialogs[3]

      ::oImporteRetirado:bChange    := {|| ::RefreshTurno() }

      REDEFINE SAY ::oImporteCambio ;
         PROMPT   ::nImporteCambio ;
         ID       465 ;
         FONT     oFntSay ;
         PICTURE  ::cPorDiv ;
         OF       ::oFldTurno:aDialogs[3]

      // Diferencias------------------------------------------------------------

      REDEFINE GET ::oImporteTarjeta ;
         VAR      ::nImporteTarjeta ;
         ID       430 ;
         FONT     oFntSay ;
         WHEN     !::lCerrado ;
         PICTURE  ::cPorDiv ;
         OF       ::oFldTurno:aDialogs[ 3 ]

      ::oImporteTarjeta:bChange     := {|| ::oDiferenciaTarjeta:Refresh(), ::RefreshTurno() }

      REDEFINE GROUP ::oGrpDiferencias ;
         ID          480;
         OF          ::oFldTurno:aDialogs[ 3 ]

      REDEFINE SAY   ::oSayDiferenciaEfectivo ;
         ID          441 ;
         OF          ::oFldTurno:aDialogs[ 3 ]

      REDEFINE SAY   ::oDiferenciaEfectivo VAR ( ::nImporteEfectivo - ::oTotales:nTotSaldoEfectivo( ::cCurCaja )  ) ;
         ID          440 ;
         PICTURE     ::cPorDiv ;
         FONT        oFntSay ;
         COLOR       CLR_BLUE, GetSysColor( COLOR_BTNFACE ) ;
         OF          ::oFldTurno:aDialogs[ 3 ]

      REDEFINE SAY   ::oSayDiferenciaTarjeta ;
         ID          451 ;
         OF          ::oFldTurno:aDialogs[ 3 ]      

      REDEFINE SAY   ::oDiferenciaTarjeta VAR ( ::nImporteTarjeta - ::oTotales:nTotCobroTarjeta( ::cCurCaja ) );
         ID          450 ;
         PICTURE     ::cPorDiv ;
         FONT        oFntSay ;
         COLOR       CLR_BLUE, GetSysColor( COLOR_BTNFACE ) ;
         OF          ::oFldTurno:aDialogs[ 3 ]

      REDEFINE SAY   ::oSayDiferenciaTotal ;
         ID          471 ;
         OF          ::oFldTurno:aDialogs[ 3 ]

      REDEFINE SAY   ::oDiferenciaTotal VAR ( ::oDiferenciaEfectivo:VarGet() + ::oDiferenciaTarjeta:VarGet() ) ;
         ID          470 ;
         PICTURE     ::cPorDiv ;
         FONT        oFntSay ;
         COLOR       CLR_BLUE, GetSysColor( COLOR_BTNFACE ) ;
         OF          ::oFldTurno:aDialogs[3]

      // Comentarios--------------------------------------------------------------

      REDEFINE GET oComentario ;
         VAR      ::cComentario ;
         WHEN     !::lArqueoParcial ;
         MEMO ;
         ID       200 ;
         OF       ::oFldTurno:aDialogs[4]

      // Impresión----------------------------------------------------------------

      REDEFINE CHECKBOX ::oNoImprimirArqueo ;
         VAR      ::lNoImprimirArqueo ;
         ID       600 ;
         OF       ::oFldTurno:aDialogs[ 4 ]

      if ::lArqueoTactil()

      REDEFINE COMBOBOX ::oCmbReport ;
         VAR      ::cCmbReport ;
         ID       620 ;
         WHEN     ( !::lNoImprimirArqueo ) ;
         OF       ::oFldTurno:aDialogs[ 4 ] ;
         ITEMS    ::aCmbReport ;
         BITMAPS  ::aBmpReportTactil

      else

      REDEFINE COMBOBOX ::oCmbReport ;
         VAR      ::cCmbReport ;
         ID       620 ;
         WHEN     ( !::lNoImprimirArqueo ) ;
         OF       ::oFldTurno:aDialogs[ 4 ] ;
         ITEMS    ::aCmbReport ;
         BITMAPS  ::aBmpReport

      REDEFINE SAY  ::oSaySalidaImpresion ;
         ID        621 ;
         OF        ::oFldTurno:aDialogs[4]

      end if

      REDEFINE SAY  ::oGrpOpcionesImpresion ;
         ID        601 ;
         OF        ::oFldTurno:aDialogs[4]

      REDEFINE BUTTON ::oBtnOpcionesImpresion;
         ID       610 ;
         OF       ::oFldTurno:aDialogs[ 4 ] ;
         WHEN     ( !::lNoImprimirArqueo ) ;
         ACTION   ( ::DlgImprimir( , ::lArqueoTactil() ) )

      REDEFINE GROUP ::oGrpOpcionesEnvioInformacion ;
         ID       701;
         OF       ::oFldTurno:aDialogs[ 4 ]

      REDEFINE CHECKBOX ::oEnvioInformacion VAR ::lEnvioInformacion ;
         ID       700 ;
         WHEN     !::lArqueoParcial ;
         OF       ::oFldTurno:aDialogs[ 4 ]

      REDEFINE CHECKBOX ::oImprimirEnvio VAR ::lImprimirEnvio ;
         ID       710 ;
         WHEN     ::lEnvioInformacion ;
         OF       ::oFldTurno:aDialogs[ 4 ]

      REDEFINE GROUP ::oGrpNotificacion ;
         ID       721;
         OF       ::oFldTurno:aDialogs[ 4 ]

      REDEFINE CHECKBOX ::oChkEnviarMail ;
         VAR      ::lEnviarMail ;
         WHEN     lUsrMaster() .and. !::lArqueoParcial ;
         ID       720 ;
         OF       ::oFldTurno:aDialogs[ 4 ]

      REDEFINE GET ::oGetEnviarMail ;
         VAR      ::cEnviarMail ;
         WHEN     ( .f. ) ;
         ID       730 ;
         OF       ::oFldTurno:aDialogs[ 4 ]

      REDEFINE CHECKBOX ::oChkActualizaStockWeb ;
         VAR      ::lChkActualizaStockWeb ;
         WHEN     lUsrMaster() .and. !::lArqueoParcial ;
         ID       740 ;
         OF       ::oFldTurno:aDialogs[ 4 ]   

      // Botones generales--------------------------------------------------------

      ::oMeter    := TApoloMeter():ReDefine( 130, { | u | if( pCount() == 0, ::nMeter, ::nMeter := u ) }, 10, ::oDlgTurno, .f., , , .t., Rgb( 255,255,255 ), , Rgb( 128,255,0 ) )

      REDEFINE SAY ::oTxt ;
         PROMPT   "" ;
         ID       140 ;
         OF       ::oDlgTurno

      REDEFINE BUTTON ::oBtnRecalcular ;
         ID       300 ;
         OF       ::oDlgTurno ;
         ACTION   ( ::lCalTurno() )

      REDEFINE BUTTON ::oBtnPrv ;
         ID       100 ;
         OF       ::oDlgTurno ;
         ACTION   ::GoPrev( oBrwCnt, oBrwCaj )

      REDEFINE BUTTON ::oBtnNxt ;
         ID       110 ;
         OF       ::oDlgTurno ;
         ACTION   ::GoNext( oCajTur, oBrwCnt )

      REDEFINE BUTTON ;
         ID       120 ;
         OF       ::oDlgTurno ;
         ACTION   ::oDlgTurno:End()

      ::oDlgTurno:bStart := {|| ::StartArqueoTurno( oBtnMod, oCajTur, oBrwCaj, oBrwCnt, oComentario ) }

      ::oFldTurno:aDialogs[ 2 ]:AddFastKey( VK_F2, {|| ::EdtAnt( oBrwCnt ) } )
      ::oFldTurno:aDialogs[ 2 ]:AddFastKey( VK_F3, {|| ::EdtCol( oBrwCnt ) } )

   ::oDlgTurno:Activate( , , , .t., {|| .t. }, , {|| ::InitArqueoTurno() } )

   /*
   Repos de las bases de datos-------------------------------------------------
   */

   if !empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:SetStatus()
   end if

   if !empty( ::oDbfDet ) .and. ::oDbfDet:Used()
      ::oDbfDet:OrdClearScope()
   end if

   if !empty( ::oDbfCaj ) .and. ::oDbfCaj:Used()
      ::oDbfCaj:OrdClearScope()
   end if

   /*
   Comprobamos si hay nuevos turnos abiertos-----------------------------------
   */

   if ::oDlgTurno:nResult == IDOK

      /*
      Guardamos las opciones---------------------------------------------------
      */

      ::oIniArqueo:Set( "Arqueo", "EnvioInformacion", ::lEnvioInformacion     )
      ::oIniArqueo:Set( "Arqueo", "ImprimirArqueo",   ::lNoImprimirArqueo     )
      ::oIniArqueo:Set( "Arqueo", "SalidaArqueo",     ::cCmbReport            )
      ::oIniArqueo:Set( "Arqueo", "ImprimirEnvio",    ::lImprimirEnvio        )
      ::oIniArqueo:Set( "Arqueo", "ActualizaStock",   ::lChkActualizaStockWeb )

      /*
      Lanzamos los scripts de cierre de sesion---------------------------------
      */

      runEventScript( "CerrarSesion" )

      /*
      Comprueba si hay sesiones para trabajar----------------------------------
      */

      ::lNowOpen()

   end if

   RECOVER USING oError

      if !empty( ::oDlgTurno )
         ::oDlgTurno:End()
      end if

      msgStop( "Error al iniciar el proceso de cierre." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Limpiamos las estáticas-----------------------------------------------------
   */

   ::lArqueoParcial     := .f.
   ::nImporteEfectivo   := 0
   ::nImporteTarjeta    := 0
   ::nImporteRetirado   := 0
   ::cComentario        := ""

   /*
   Guardamos los datos del browse----------------------------------------------
   */

   if !empty( oBrwCaj )
      oBrwCaj:CloseData()
   end if

   if !empty( oBrwCnt )
      oBrwCnt:CloseData()
   end if

   /*
   Refrescos por pantalla------------------------------------------------------
   */

   if !empty( oFnt )
      oFnt:End()
   end if

   if !empty( oFntSay )
      oFntSay:End()
   end if

   if !empty( oFntBrw )
      oFntBrw:End()
   end if

   if !empty( ::oWndBrw )
      ::oWndBrw:Refresh()
   end if

Return ( if( !empty( ::oDlgTurno ), ::oDlgTurno:nResult == IDOK, .f. ) )

//---------------------------------------------------------------------------//

METHOD InitArqueoTurno()

   if .t. // uFieldEmpresa( "lDesCajas") 
      ::oBtnSelectAllCajas:Hide()
      ::oBtnUnSelectAllCajas:Hide()
   end if

   if ::lArqueoCiego    

      ::oBrwTotales:Hide()

      if !empty( ::oGrpArqueo )
         ::oGrpArqueo:Hide()
      end if 
      
      ::oTotalEfectivo:Hide()

      if !empty( ::oSayTotalEfectivo )
         ::oSayTotalEfectivo:Hide()
      end if 

      ::oTotalTarjeta:Hide()

      if !empty( ::oSayTotalTarjeta )
         ::oSayTotalTarjeta:Hide()
      end if 

      ::oTotalNoEfectivo:Hide()

      if !empty( ::oSayTotalNoEfectivo )
         ::oSayTotalNoEfectivo:Hide()
      end if

      ::oTotalCobros:Hide()

      if !empty( ::oSayTotalCobros )
         ::oSayTotalCobros:Hide()
      end if

      ::oGrpCobros:Hide()

      ::oDiferenciaEfectivo:Hide()

      if !empty( ::oSayDiferenciaEfectivo )
         ::oSayDiferenciaEfectivo:Hide()
      end if

      ::oDiferenciaTarjeta:Hide()

      if !empty( ::oSayDiferenciaTarjeta )
         ::oSayDiferenciaTarjeta:Hide()
      end if

      ::oDiferenciaTotal:Hide()

      if !empty( ::oSayDiferenciaTotal )
         ::oSayDiferenciaTotal:Hide()
      end if

      ::oGrpDiferencias:Hide()

      ::oBtnOpcionesImpresion:Hide()

      if !empty( ::oChkEnviarMail )
         ::oChkEnviarMail:Hide()
      end if

      if !empty( ::oGetEnviarMail )
         ::oGetEnviarMail:Hide()
      end if

      ::oGrpNotificacion:Hide()

      if !empty( ::oEnvioInformacion )
         ::oEnvioInformacion:Hide()
      end if

      if !empty( ::oImprimirEnvio )
         ::oImprimirEnvio:Hide()
      end if

      if !empty( ::oGrpOpcionesEnvioInformacion )
         ::oGrpOpcionesEnvioInformacion:Hide()
      end if

   end if    

Return ( nil )

//---------------------------------------------------------------------------//

METHOD InitDlgImprimir()

   local oSubTree

   /*
   Rellenamos el arbol de impresion--------------------------------------------
   */

   ::oTreeGeneral := ::oTreeImpresion:Add( "General" )
                     ::oTreeGeneral:Add( "Entradas y salidas de cajas" )

   oSubTree       := ::oTreeImpresion:Add( "Ventas" )
                     oSubTree:Add( "Albaranes de clientes" )
                     oSubTree:Add( "Facturas de clientes" )
                     oSubTree:Add( "Facturas rectificativas de clientes" )
                     oSubTree:Add( "Anticipos de clientes" )
                     oSubTree:Add( "Tickets" )
                     oSubTree:Add( "Contadores" )
                     oSubTree:Add( "Devoluciones de clientes" )
                     oSubTree:Add( "Vales a clientes" )

   oSubTree       := ::oTreeImpresion:Add( "Compras" )
                     oSubTree:Add( "Albaranes de proveedores" )
                     oSubTree:Add( "Facturas de proveedores" )
                     oSubTree:Add( "Facturas rectificativas de proveedores" )

   oSubTree       := ::oTreeImpresion:Add( "Incidencias" )
                     oSubTree:Add( "Tickets lineas borradas" )
                     oSubTree:Add( "Cobros de ventas anteriores" )

   oSubTree       := ::oTreeImpresion:Add( "Liquidaciones" )
                     oSubTree:Add( "Vales liquidados de clientes" )
                     oSubTree:Add( "Anticipos liquidados de clientes" )

   oSubTree       := ::oTreeImpresion:Add( "Cobros" )
                     oSubTree:Add( "Entregas a cuenta en pedidos de clientes" )
                     oSubTree:Add( "Entregas a cuenta en albaranes de clientes" )
                     oSubTree:Add( "Cobros en facturas de clientes" )
                     oSubTree:Add( "Cobros efectivo en facturas a proveedores" )
                     oSubTree:Add( "Cobros no efectivo en facturas a proveedores" )
                     oSubTree:Add( "Cobros tarjeta en facturas a proveedores" )
                     oSubTree:Add( "Cobros en tickets de clientes" )
                     oSubTree:Add( "Cobros por formas de pago" )

   oSubTree       := ::oTreeImpresion:Add( "Pagos" )
                     oSubTree:Add( "Pagos en facturas a proveedores" )
                     oSubTree:Add( "Pagos efectivo en facturas a proveedores" )
                     oSubTree:Add( "Pagos no efectivo en facturas a proveedores" )
                     oSubTree:Add( "Pagos tarjeta en facturas a proveedores" )
                     oSubTree:Add( "Pagos por formas de pago" )

   oSubTree       := ::oTreeImpresion:Add( "Bancos" )
                     oSubTree:Add( "Operaciones bancarias en cuentas de empresa" )
                     oSubTree:Add( "Saldos bancarios en cuentas de empresa" )

   oSubTree       := ::oTreeImpresion:Add( "Estadisticas" )
                     oSubTree:Add( "Compras por artículos" )
                     oSubTree:Add( "Ventas por artículos" )
                     oSubTree:Add( "Ventas por salas" )
                     oSubTree:Add( "Ventas por tipo de artículos" )
                     oSubTree:Add( "Ventas por familias" )
                     oSubTree:Add( "Ventas por " + getConfigTraslation( "categoría" ) )
                     oSubTree:Add( "Ventas por fabricante" )
                     oSubTree:Add( "Ventas por " + getConfigTraslation( "temporada" ) )
                     oSubTree:Add( "Ventas por usuarios" )
                     oSubTree:Add( "Ventas por tipos de " + cImp() )
                     oSubTree:Add( "Ventas por tipo de invitaciones" )

   ::oTreeImpresion:ExpandAll()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD StartArqueoTurno( oBtnMod, oCajTur, oBrwCaj, oBrwCnt, oComentario )

   ::oBtnPrv:Hide()

   ::oMeter:Hide()

   ::oBtnRecalcular:Hide()

   ::oCodCaj:lValid()

   oCajTur:lValid()

   if ::lZoom
      ::oFldTurno:SetOption( 1 )
      oBtnMod:Hide()
   end if

   oBrwCaj:Load()
   oBrwCaj:Refresh()

   oBrwCnt:Load()
   oBrwCnt:Refresh()

   if ::lArqueoParcial
      ::lEnvioInformacion     := .f.
      ::lImprimirEnvio        := .f.
      ::lEnviarMail           := .f.
      ::lChkActualizaStockWeb := .f.
   end if

   SysRefresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GoPrev( oBrwCnt, oBrwCaj )

   do case
      case ::oFldTurno:nOption == 2

         ::oBtnPrv:Hide()

         ::oBtnRecalcular:Hide()

         oBrwCaj:Refresh()

      case ::oFldTurno:nOption == 3

         if !::lIsContadores()
            ::oFldTurno:GoPrev()
            ::oBtnPrv:Hide()
         end if

         ::oBtnRecalcular:Hide()

      case ::oFldTurno:nOption == 4

         SetWindowText( ::oBtnNxt:hWnd, "S&iguiente >" )

         ::oBtnRecalcular:Show()

   end case

   ::oFldTurno:GoPrev()

return nil

//----------------------------------------------------------------------------//

METHOD GoNext( oCajTur, oBrwCnt )

   local oItem
   local cCodCaj  := ""

   do case
      case ::oFldTurno:nOption == 1

         ::oBtnPrv:Show()

         if !::lZoom .and. empty( ::cCajTur )
            MsgStop( "Es necesario codificar un usuario." )
            oCajTur:SetFocus()
            return nil
         end if

         if !::lZoom .and. !::lAnyCajaSelect()
            MsgStop( "Es necesario seleccionar una caja." )
            return nil
         end if

         if !::lZoom .and. !::lValidCajas()
            return nil
         end if

         if ::lZoom .and. !::lOneCajaSelect()
            MsgStop( "Seleccione solo una caja." )
            return nil
         end if

         if ::lIsContadores()

            ::oFldTurno:GoNext()

            ::LoadContadores()

            oBrwCnt:GoTop()
            oBrwCnt:Refresh()

         else

            ::lCalTurno()

            ::LoadImporte( ::cCurCaja )

            ::oBtnRecalcular:Show()

            if !uFieldEmpresa( "lOpenTik" ) .and. ::lTikAbiertos .and. !::lArqueoParcial
               MsgStop( "Existen tickets abiertos: " + CRLF + ::cTikAbiertos )
            else
               ::oFldTurno:GoNext(); ::oFldTurno:GoNext()
            end if

         end if

         /*
         Seleccionamos la primera caja seleccionada----------------------------
         */

         ::oDbfCaj:GetRecno()

         ::oDbfCaj:GoTop()
         while !( ::oDbfCaj:Eof() )
            if ( ::lInCajaSelect( ::oDbfCaj:FieldGetByName( "cCodCaj" ) ) .and. !::oDbfCaj:FieldGetByName( "lCajClo" ) )
               cCodCaj  := ::oDbfCaj:FieldGetByName( "cCodCaj" )
            end if
            ::oDbfCaj:Skip()
         end while

         ::oDbfCaj:SetRecno()

         /*
         Si hay mas de una caja seleccionada-----------------------------------
         */

         if !empty( cCodCaj )
            ::oCodCaj:cText( cCodCaj )
	         ::oCodCaj:lValid()
         end if 

         /*
         Refresco del turno----------------------------------------------------
         */

         ::RefreshTurno()

      case ::oFldTurno:nOption == 2

         ::lCalTurno()

         ::oBtnRecalcular:Show()

         if !uFieldEmpresa( "lOpenTik" ) .and. ::lTikAbiertos .and. !::lArqueoParcial
            MsgStop( "Existen tickets abiertos: " + CRLF + ::cTikAbiertos )
         else
            ::oFldTurno:GoNext()
         end if

         ::RefreshTurno()

      case ::oFldTurno:nOption == 3

         ::oBtnRecalcular:Hide()

         ::SaveImporte( ::cCurCaja )

         ::oFldTurno:GoNext()

         SetWindowText( ::oBtnNxt:hWnd, "&Terminar" )

         ::oBrwTotales:SetFocus()
         ::oBrwTotales:Refresh()

      case ::oFldTurno:nOption == 4

         if !::lZoom

            if ::lCloseCajaSeleccionada()
               ::oDlgTurno:end( IDOK )
            end if

         else

            ::oDlgTurno:end()

         end if

   end case

return nil

//--------------------------------------------------------------------------//

METHOD lIsContadores()

   local lIsContadores  := .f.

   ::oArticulo:GetStatus()
   ::oArticulo:OrdSetFocus( "nCtlStock" )

   lIsContadores        := ::oArticulo:Seek( 2 )

   ::oArticulo:SetStatus()

Return ( lIsContadores )

//---------------------------------------------------------------------------//

METHOD LoadContadores( lReLoad )

   local nIva

   DEFAULT  lReload  := .f.

   /*
   Creamos el temporal---------------------------------------------------------
   */

   if !::lZoom

      ::oArticulo:GetStatus()
      ::oArticulo:OrdSetFocus( "nCtlStock" )

      if ::oArticulo:Seek( 2 )
         while ::oArticulo:nCtlStock == 2 .and. !::oArticulo:Eof()

            nIva                    := nIva( ::oIvaImp:cAlias, ::oArticulo:TipoIva )

            if ::oDbfDet:Seek( ::cCurTurno + ::oArticulo:Codigo )

               ::oDbfDet:Load()

               if empty( ::oDbfDet:nCanAnt )
                  ::oDbfDet:nCanAnt := ::oArticulo:nCntAct
               end if

               // Solo ponemos los precios si es la primera vez-------------------

               if !::oDbf:lBefClo 
                  ::oDbfDet:nPvpArt := ::oArticulo:PvtaIva1
               end if

               ::oDbfDet:nIvaArt    := nIva
               ::oDbfDet:nValImp    := ::oNewImp:nValImp( ::oArticulo:cCodImp, ::oArticulo:lIvaInc, nIva )

               ::oDbfDet:Save()

            else

               ::oDbfDet:Blank()
               ::oDbfDet:cNumTur    := ::cNumeroCurrentTurno()
               ::oDbfDet:cSufTur    := ::cSufijoCurrentTurno()
               ::oDbfDet:cCodArt    := ::oArticulo:Codigo
               ::oDbfDet:cNomArt    := ::oArticulo:Nombre
               ::oDbfDet:nCanAnt    := ::oArticulo:nCntAct
               ::oDbfDet:nCanAct    := ::oArticulo:nCntAct
               ::oDbfDet:nPvpArt    := ::oArticulo:PvtaIva1
               ::oDbfDet:nIvaArt    := nIva
               ::oDbfDet:nValImp    := ::oNewImp:nValImp( ::oArticulo:cCodImp, ::oArticulo:lIvaInc, nIva )
               ::oDbfDet:Save()

            end if

            ::oArticulo:Skip()

            SysRefresh()

         end while
      end if

      ::oArticulo:SetStatus()

      ::oDbfDet:GoTop()

   end if

Return Nil

//--------------------------------------------------------------------------//

METHOD CreateCajaTurno()

   local oError
   local oBlock
   local cUserCaja
   local lOpenCaja         := .f.

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oDbfCaj:GetStatus()
   ::oDbfCaj:OrdSetFocus( "cNumTur" )

   if !::oDbfCaj:Seek( ::cCurTurno + ::GetCurrentCaja() ) .and. !oRetFld( ::GetCurrentCaja(), ::oCaja, "lNoArq" )

      ::oDbfCaj:Blank()
      ::oDbfCaj:lCajSel    := .f.
      ::oDbfCaj:cNumTur    := ::cNumeroCurrentTurno()
      ::oDbfCaj:cSufTur    := ::cSufijoCurrentTurno()
      ::oDbfCaj:cCodCaj    := ::GetCurrentCaja()
      ::oDbfCaj:nCanPre    := ::nObjetivoTurno
      ::oDbfCaj:cDivEfe    := cDivEmp()
      ::oDbfCaj:cDivTar    := cDivEmp()
      ::oDbfCaj:cDivPre    := cDivEmp()
      ::oDbfCaj:cCajOpe    := ::cCajeroTurno
      ::oDbfCaj:dFecOpe    := GetSysDate()
      ::oDbfCaj:cHorOpe    := SubStr( Time(), 1, 5 )
      ::oDbfCaj:Insert()

   end if

   ::oDbfCaj:SetStatus()

   RECOVER USING oError

      msgStop( "Imposible crear la sesión para la caja actual." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return Nil

//---------------------------------------------------------------------------//

METHOD SelCajas( lSelect, oBrw, lMessage )

   local nPos

   DEFAULT lMessage := .t.

   if lSelect

      if .f. // ::oDbfCaj:lCajClo // .and. !oUser():lMaster()

         if lMessage 
            MsgStop( "La caja " + ::oDbfCaj:FieldGetByName( "cCodCaj" ) + " ya está cerrada." )
         end if 
      
      else 

         if !::lInCajaSelect( ::oDbfCaj:FieldGetByName( "cCodCaj" ) )
            aAdd( ::aCajaSelect, ::oDbfCaj:FieldGetByName( "cCodCaj" ) )
         end if 
          
      endif

   else 

      nPos           := ::nInCajaSelect( ::oDbfCaj:FieldGetByName( "cCodCaj" ) )
      if nPos != 0
         aDel( ::aCajaSelect, nPos, .t. )
      end if 

   end if 

   if oBrw != nil
      oBrw:Refresh()
   end if

Return Nil

//--------------------------------------------------------------------------//

METHOD SelAllCajas( lSelect, oBrw )

   ::oDbfCaj:GetRecno()

   ::oDbfCaj:GoTop()
   while !::oDbfCaj:Eof()

      ::SelCajas( lSelect )

      ::oDbfCaj:Skip()

      SysRefresh()

   end while

   ::oDbfCaj:SetRecno()

   if oBrw != nil
      oBrw:Refresh()
   end if

Return Nil

//---------------------------------------------------------------------------//
//
// Devuelve si hay alguna caja seleccionada
//

METHOD lAnyCajaSelect()

   local lAny  := .f. 

   ::oDbfCaj:GetRecno()

   ::oDbfCaj:GoTop()
   while !::oDbfCaj:Eof()

      /*
      Si la caja esta seleccionada y no esta cerrada tenemos cosas q cerrar----
      */

      if ::lInCajaSelect( ::oDbfCaj:FieldGetByName( "cCodCaj" ) )
         lAny  := .t.
      end if

      ::oDbfCaj:Skip()

      SysRefresh()

   end while

   ::oDbfCaj:SetRecno()

Return ( lAny )

//---------------------------------------------------------------------------//
//
// Devuelve si solo hay una caja seleccionada
//

METHOD lOneCajaSelect()

   local nOne  := 0

   ::oDbfCaj:GetRecno()

   ::oDbfCaj:GoTop()
   while !::oDbfCaj:Eof()

      if ::lInCajaSelect( ::oDbfCaj:cCodCaj )
         nOne++
      end if

      ::oDbfCaj:Skip()

      SysRefresh()

   end while

   ::oDbfCaj:SetRecno()

Return ( nOne == 1 )

//---------------------------------------------------------------------------//

METHOD lValidCajas()

   local nUsrCaj
   local lValidCajas    := .t.

   if ::lArqueoParcial
      Return .t.
   end if

   ::oDbfCaj:GetRecno()

   ::oDbfCaj:GoTop()
   while !::oDbfCaj:Eof()

      if ::lInCajaSelect( ::oDbfCaj:cCodCaj )

         nUsrCaj        := nUserCaja( ::oDbfCaj:cCodCaj )

         if !( nUsrCaj == 0 .or. ( nUsrCaj == 1 .and. ::oDbfCaj:cCodCaj == ::GetCurrentCaja() ) )

            if !ApoloMsgNoYes( "Hay usuarios trabajando en la caja " + ::oDbfCaj:cCodCaj, "¿ Desea continuar con el cierre ?" )
               lValidCajas := .f.
               exit
            end if
         end if
      
      end if
      
      ::oDbfCaj:Skip()
      
      SysRefresh()
   
   end while

   ::oDbfCaj:SetRecno()

Return ( lValidCajas )

//--------------------------------------------------------------------------//

METHOD lChangeCajas( oNomCaj )

   local cCodCaj     := ::oCodCaj:VarGet()

   /*
   Primero la caja tiene q existir---------------------------------------------
   */

   if !cCajas( ::oCodCaj, ::oCaja:cAlias, oNomCaj )
      Return .f.
   end if

   /*
   Texto para cajas vacias-----------------------------------------------------
   */

   if empty( cCodCaj )

      oNomCaj:cText( "Todas" )

   else

      if ( ::cOldCaj != cCodCaj )

         ::SaveImporte( ::cOldCaj )

         ::cOldCaj   := cCodCaj

         ::LoadImporte( ::cOldCaj )

      end if

   end if

   /*
   Reclculamos con la caja seleccionada----------------------------------------
   */

   ::lCalTurno()

   /*
   Refrescos en pantalla-------------------------------------------------------
   */

   ::RefreshTurno()

Return ( .t. )

//---------------------------------------------------------------------------//
/*
Calcula el turno
*/

METHOD lCalTurno( cTurno, cCaja )

   local oError
   local oBlock
   local aCajas                  := {}
   local aStream                 := {}

   DEFAULT cTurno                := ::cCurTurno
   DEFAULT cCaja                 := ::cCurCaja

   CursorWait()

   oBlock                        := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !empty( ::oDlgTurno )
         ::oDlgTurno:Disable()
      end if

      if !empty( ::oMeter )
         ::oMeter:Show()
      end if

      ::oDbfCaj:GetRecno()

      /*
      Iniciamos los totales-------------------------------------------------------
      */

      if empty( ::oTotales )
         ::oTotales              := TTotalTurno():New( Self )
      end if
      ::oTotales:Initiate()

      /*
      Tickets abiertos-----------------------------------------------------------
      */

      ::lTikAbiertos             := .f.
      ::cTikAbiertos             := ""

      /*
      Calculo de contadores------------------------------------------------------
      */

      ::TotContadores( cTurno )

      /*
      Calculo en todas las cajas--------------------------------------------------
      */

      ::TotSesion( cTurno, cCaja )

      /*
      Refrescos en pantalla-------------------------------------------------------
      */

      ::RefreshTurno()

      /*
      Rama de totales------------------------------------------------------------
      */

      if !empty( ::oBrwTotales )

         ::oTreeTotales             := ::oTotales:CreateTree( cCaja, cTurno )   

         if empty( ::oBrwTotales:oTree )

            ::oBrwTotales:SetTree( ::oTreeTotales, { "gc_navigate_minus_16", "gc_navigate_plus_16", "Nil16" }, ,  ) 
            
            if len( ::oBrwTotales:aCols ) > 1
               ::oBrwTotales:aCols[ 1 ]:cHeader    := ""
               ::oBrwTotales:aCols[ 1 ]:nWidth     := 20
            end if 

         else 

            ::oBrwTotales:oTree     := ::oTreeTotales
            ::oBrwTotales:oTreeItem := ::oTreeTotales:oFirst

         end if 

         ::oBrwTotales:Refresh()

      end if

      /*
      Variables publicas para el informe------------------------------------------
      */

      public nTotAlbCliContadores   := ::oTotales:nTotAlbCliContadores(   cCaja  )
      public nTotAlbCliVentas       := ::oTotales:nTotAlbCliVentas(       cCaja  )
      public nTotPedCliEntregas     := ::oTotales:nTotPedCliEntregas(     cCaja  )
      public nTotAlbCliEntregas     := ::oTotales:nTotAlbCliEntregas(     cCaja  )
      public nTotEntregas           := ::oTotales:nTotEntregas(           cCaja  )
      public nTotFacCliContadores   := ::oTotales:nTotFacCliContadores(   cCaja  )
      public nTotFacCliVentas       := ::oTotales:nTotFacCliVentas(       cCaja  )
      public nTotRctCliVentas       := ::oTotales:nTotRctCliVentas(       cCaja  )
      public nTotTikCliContadores   := ::oTotales:nTotTikCliContadores(   cCaja  )
      public nTotChkCliContadores   := ::oTotales:nTotChkCliContadores(   cCaja  )
      public nTotTikCliVentas       := ::oTotales:nTotTikCliVentas(       cCaja  )
      public nTotChkCliVentas       := ::oTotales:nTotChkCliVentas(       cCaja  )
      public nTotDevCliContadores   := ::oTotales:nTotDevCliContadores(   cCaja  )
      public nTotDevCliVentas       := ::oTotales:nTotDevCliVentas(       cCaja  )
      public nTotValCliContadores   := ::oTotales:nTotValCliContadores(   cCaja  )
      public nTotValCliVentas       := ::oTotales:nTotValCliVentas(       cCaja  )
      public nTotValCliLiquidados   := ::oTotales:nTotValCliLiquidados(   cCaja  )
      public nTotAlbPrvCompras      := ::oTotales:nTotAlbPrvCompras(      cCaja  )
      public nTotFacPrvCompras      := ::oTotales:nTotFacPrvCompras(      cCaja  )
      public nTotRctPrvCompras      := ::oTotales:nTotRctPrvCompras(      cCaja  )
      public nTotAntCliVentas       := ::oTotales:nTotAntCliVentas(       cCaja  )
      public nTotAntCliLiquidados   := ::oTotales:nTotAntCliLiquidados(   cCaja  )
      public nTotEntradas           := ::oTotales:nTotEntradas(           cCaja  )
      public nTotVentas             := ::oTotales:nTotVentas(             cCaja  )
      public nTotContadores         := ::oTotales:nTotContadores(         cCaja  )
      public nTotVentaCredito       := ::oTotales:nTotVentaCredito(       cCaja  )
      public nTotVentaContado       := ::oTotales:nTotVentaContado(       cCaja  )
      public nTotCompras            := ::oTotales:nTotCompras(            cCaja  )
      public nTotTikCliCobros       := ::oTotales:nTotTikCliCobros(       cCaja  )
      public nTotFacCliCobros       := ::oTotales:nTotFacCliCobros(       cCaja  )
      public nTotValCliCobros       := ::oTotales:nTotValCliCobros(       cCaja  )
      public nTotChkCliCobros       := ::oTotales:nTotChkCliCobros(       cCaja  )
      public nTotFacPrvPagos        := ::oTotales:nTotFacPrvPagos(        cCaja  )

      public nTotCobroEfectivo      := ::oTotales:nTotCobroEfectivo(      cCaja  )
      public nTotCobroNoEfectivo    := ::oTotales:nTotCobroNoEfectivo(    cCaja  )
      public nTotCobroTarjeta       := ::oTotales:nTotCobroTarjeta(       cCaja  )
      public nTotCobroMedios        := ::oTotales:nTotCobroMedios(        cCaja  )

      public nTotPagoEfectivo       := ::oTotales:nTotPagoEfectivo(       cCaja  )
      public nTotPagoNoEfectivo     := ::oTotales:nTotPagoNoEfectivo(     cCaja  )
      public nTotPagoTarjeta        := ::oTotales:nTotPagoTarjeta(        cCaja  )
      public nTotPagoMedios         := ::oTotales:nTotPagoMedios(         cCaja  )

      public nTotCobros             := ::oTotales:nTotCobros(             cCaja  )
      public nDifCobros             := ::oTotales:nDifCobros(             cCaja  )
      public nDifTotal              := ::oTotales:nDifTotal(              cCaja  )
      public nTotVentaSesion        := ::oTotales:nTotVentaSesion(        cCaja  )
      public nTotCobroSesion        := ::oTotales:nTotCobroSesion(        cCaja  )
      public nTotNumeroAlbaranes    := ::oTotales:nTotNumeroAlbaranes(    cCaja  )
      public nTotNumeroFacturas     := ::oTotales:nTotNumeroFacturas(     cCaja  )
      public nTotNumeroTikets       := ::oTotales:nTotNumeroTikets(       cCaja  )
      public nTotNumeroVales        := ::oTotales:nTotNumeroVales(        cCaja  )
      public nTotNumeroCheques      := ::oTotales:nTotNumeroCheques(      cCaja  )
      public nTotNumeroDevoluciones := ::oTotales:nTotNumeroDevoluciones( cCaja  )
      public nTotCaja               := ::oTotales:nTotCaja(               cCaja  )
      public nTotCajaEfectivo       := ::oTotales:nTotCajaEfectivo(       cCaja  )
      public nTotCajaNoEfectivo     := ::oTotales:nTotCajaNoEfectivo(     cCaja  )
      public nTotCajaTarjeta        := ::oTotales:nTotCajaTarjeta(        cCaja  )
      public nTotCajaObjetivo       := ::oTotales:nTotCajaObjetivo(       cCaja  )
      public nTicketMedio           := ::oTotales:nTiketMedio(            cCaja  )

      public nTotSaldoEfectivo      := ::oTotales:nTotSaldoEfectivo(      cCaja  )
      public nTotSaldoNoEfectivo    := ::oTotales:nTotSaldoNoEfectivo(    cCaja  )
      public nTotSaldoTarjeta       := ::oTotales:nTotSaldoTarjeta(       cCaja  )

      public nTotNumeroAptCajon     := ::oTotales:nTotNumeroAptCajon(     cTurno, cCaja )

      /*
      Calculo Monedas-------------------------------------------------------------
      */

      if !empty( cCaja )

         if ::oDbfCaj:SeekInOrd( cTurno + cCaja, "cNumTur" )

            /*
            Monedas efectivo------------------------------------------------------
            */

            aStream                 := hb_aTokens( ::oDbfCaj:cMonEfe, ";" )

            if len( aStream ) >= 15

               aStream[ 1]          := Val( aStream[ 1] )
               aStream[ 2]          := Val( aStream[ 2] )
               aStream[ 3]          := Val( aStream[ 3] )
               aStream[ 4]          := Val( aStream[ 4] )
               aStream[ 5]          := Val( aStream[ 5] )
               aStream[ 6]          := Val( aStream[ 6] )
               aStream[ 7]          := Val( aStream[ 7] )
               aStream[ 8]          := Val( aStream[ 8] )
               aStream[ 9]          := Val( aStream[ 9] )
               aStream[10]          := Val( aStream[10] )
               aStream[11]          := Val( aStream[11] )
               aStream[12]          := Val( aStream[12] )
               aStream[13]          := Val( aStream[13] )
               aStream[14]          := Val( aStream[14] )
               aStream[15]          := Val( aStream[15] )

            end if

            public aMonedasEfe      := aStream
            public nEfectivoEnCaja  := ::oDbfCaj:nCanEfe

            /*
            Tarjeta---------------------------------------------------------------
            */

            public nTarjetaEnCaja   := ::oDbfCaj:nCanTar

            /*
            Efectivo retirado-----------------------------------------------------
            */

            aStream                 := hb_aTokens( ::oDbfCaj:cMonRet, ";" )

            if len( aStream ) >= 15

               aStream[1]           := Val( aStream[1] )
               aStream[2]           := Val( aStream[2] )
               aStream[3]           := Val( aStream[3] )
               aStream[4]           := Val( aStream[4] )
               aStream[5]           := Val( aStream[5] )
               aStream[6]           := Val( aStream[6] )
               aStream[7]           := Val( aStream[7] )
               aStream[8]           := Val( aStream[8] )
               aStream[9]           := Val( aStream[9] )
               aStream[10]          := Val( aStream[10] )
               aStream[11]          := Val( aStream[11] )
               aStream[12]          := Val( aStream[12] )
               aStream[13]          := Val( aStream[13] )
               aStream[14]          := Val( aStream[14] )
               aStream[15]          := Val( aStream[15] )

            end if

            public aMonedasRet      := aStream
            public nRetiradoEnCaja  := ::oDbfCaj:nCanRet

         else

            public aMonedasEfe      := { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
            public aMonedasRet      := { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
            public nTarjetaEnCaja   := 0
            public nEfectivoEnCaja  := 0
            public nRetiradoEnCaja  := 0

         end if

      else

         public aMonedasEfe         := { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
         public aMonedasRet         := { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
         public nTarjetaEnCaja      := 0
         public nEfectivoEnCaja     := 0
         public nRetiradoEnCaja     := 0

      end if

   RECOVER USING oError

      msgStop( "Error al calcular caja." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWE()

   if !empty( ::oDbfCaj )
      ::oDbfCaj:SetRecno()
   end if

   if !empty( ::oMeter )
      ::oMeter:Hide()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( '' )
   end if

   /*
   Habilitamos el dialogo------------------------------------------------------
   */

   if !empty( ::oDlgTurno )
      ::oDlgTurno:Enable()
   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD ClickBrwTotales()

   if len( ::oBrwTotales:Cargo:Cargo ) >= 3 .and. !empty( ::oBrwTotales:Cargo:Cargo[ 3 ] )
      Eval( ::oBrwTotales:Cargo:Cargo[ 3 ] )
   else
      if ::oBrwTotales:Cargo:oTree != nil
         ::oBrwTotales:Cargo:Toggle()
         ::oBrwTotales:Refresh()
      end if
   end if

Return ( Self )

//--------------------------------------------------------------------------//
/*
Total por contadores
*/

METHOD TotContadores( cTurno )

   DEFAULT cTurno       := ::cCurTurno

   if !empty( ::oMeter )
      ::oMeter:Refresh()
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando contadores' )
   end if

   ::oDbfDet:GetStatus()

   ::oTotales:InitContadores()

   if ::oDbfDet:Seek( cTurno )
      while ::oDbfDet:cNumTur + ::oDbfDet:cSufTur == cTurno .and. !::oDbfDet:Eof()
         ::oTotales:addContadores( Round( ::oDbfDet:nPvpArt * ( ::oDbfDet:nCanAct - ::oDbfDet:nCanAnt ), ::nDorDiv ) )
         ::oDbfDet:Skip()
         SysRefresh()
      end do
   end if

   ::oDbfDet:SetStatus()

return ( ::oTotales:nContadores )

//---------------------------------------------------------------------------//

METHOD TotVenta( cTurno, cCaja )

   DEFAULT cTurno       := ::cCurTurno
   DEFAULT cCaja        := ::cCurCaja

   /*
   Cerrar por turnos-----------------------------------------------------------
   */

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oTikT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando tikets' )
   end if

   if ::oTikT:Seek( cTurno + cCaja )

      while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurno + cCaja .and.  !::oTikT:eof()

         /*
         Marca para detectar si hay tikets abiertos
         */

         if ::oTikT:cTipTik == SAVTIK .and. ( ::oTikT:lAbierto .or. !::oTikT:lPgdTik ) .and. ::oTikT:nUbiTik != ubiEncargar
            ::lTikAbiertos    := .t.
            if !empty( ::cTikAbiertos )
               ::cTikAbiertos += ", "
            else
               ::cTikAbiertos += ::oTikT:cSerTik + "/" + Alltrim( ::oTikT:cNumTik ) + "/" + Rtrim( ::oTikT:cSufTik )
            end if
         end if

         do case
            case ::oTikT:cTipTik == SAVTIK .or. ::oTikT:cTipTik == SAVPDA // Como tiket

               ::oTotales:addTotTikCliContadores(  cCaja, ::oTikT:cSerTik, ::nCntTiketCliente(), ::cTxtTiketCliente(), ::bEdtTiketCliente() )
               ::oTotales:addTotTikCliVentas(      cCaja, ::oTikT:cSerTik, ::nTotTiketCliente(), ::cTxtTiketCliente(), ::bEdtTiketCliente() )
               ::oTotales:addNumeroTikets(         cCaja )

            case ::oTikT:cTipTik == SAVDEV // Como devolucion

               ::oTotales:addTotDevCliContadores(  cCaja, ::oTikT:cSerTik, ::nCntTiketCliente(), ::cTxtTiketCliente(), ::bEdtTiketCliente() )
               ::oTotales:addTotDevCliVentas(      cCaja, ::oTikT:cSerTik, ::nTotTiketCliente(), ::cTxtTiketCliente(), ::bEdtTiketCliente() )
               ::oTotales:addNumeroDevoluciones(   cCaja )

            case ::oTikT:cTipTik == SAVVAL .and. !::oTikT:lFreTik // Como vale

               ::oTotales:addTotValCliContadores(  cCaja, ::oTikT:cSerTik, ::nCntTiketCliente(), ::cTxtTiketCliente(), ::bEdtTiketCliente() )
               ::oTotales:addTotValCliVentas(      cCaja, ::oTikT:cSerTik, ::nTotTiketCliente(), ::cTxtTiketCliente(), ::bEdtTiketCliente() )
               ::oTotales:addNumeroVales(          cCaja )

            case ::oTikT:cTipTik == SAVVAL .and. ::oTikT:lFreTik // Como cheque regalo

               ::oTotales:addTotChkCliContadores(  cCaja, ::oTikT:cSerTik, ::nCntTiketCliente(), ::cTxtTiketCliente(), ::bZooTiketCliente() )
               ::oTotales:addTotChkCliVentas(      cCaja, ::oTikT:cSerTik, ::nTotTiketCliente(), ::cTxtTiketCliente(), ::bZooTiketCliente() )
               ::oTotales:addNumeroCheques(        cCaja )

         end case

         ::oTikT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   /*
   Vales liquidados------------------------------------------------------------
   */

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oTikT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando vales' )
   end if

   ::oTikT:OrdSetFocus( "cTurVal" )

   if ::oTikT:Seek( cTurno + cCaja )

      while ::oTikT:cTurVal + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurno + cCaja .and. !::oTikT:eof()

         ::oTotales:addTotValCliLiquidados( cCaja, ::oTikT:cSerTik, nTotValLiq( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik, ::oTikT:cAlias, ::oTikL:cAlias, ::oDbfDiv:cAlias, nil, cDivEmp(), .f., .t. ) )
         ::oTotales:addTotValCliLiquidados( cCaja, ::oTikT:cSerTik, nTotValLiq( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik, ::oTikT:cAlias, ::oTikL:cAlias, ::oDbfDiv:cAlias, nil, cDivEmp(), .f., .f. ) )

         ::oTikT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end while

   end if

   ::oTikT:OrdSetFocus( "cTurTik" )

   // Ventas por albaranes no facturados------------------------------------------

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oAlbCliT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando albaranes' )
   end if

   if ::oAlbCliT:Seek( cTurno + cCaja )

      while ::oAlbCliT:cTurAlb + ::oAlbCliT:cSufAlb + ::oAlbCliT:cCodCaj == cTurno + cCaja  .and. !::oAlbCliT:eof()

         if !lFacturado( ::oAlbCliT )

            ::oTotales:addTotAlbCliContadores(  cCaja, ::oAlbCliT:cSerAlb, ::nCntAlbaranCliente(), ::cTxtAlbaranCliente(), ::bEdtAlbaranCliente() )
            ::oTotales:addTotAlbCliVentas(      cCaja, ::oAlbCliT:cSerAlb, ::nTotAlbaranCliente(), ::cTxtAlbaranCliente(), ::bEdtAlbaranCliente() )
            ::oTotales:addNumeroAlbaranes(      cCaja )

         end if 

         ::oAlbCliT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   /*
   Entregas a cuenta en albaranes----------------------------------------------
   */

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oPedCliP:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando entregas a cuenta' )
   end if

   if ::oPedCliP:Seek( cTurno + cCaja )

      while ::oPedCliP:cTurRec + ::oPedCliP:cSufPed + ::oPedCliP:cCodCaj == cTurno + cCaja  .and. !::oPedCliP:Eof()

         if !::oPedCliP:lPasado
            ::oTotales:addTotPedCliEntregas( cCaja, ::oPedCliP:cSerPed, ::nTotPedidoEntrega(), ::cTxtPedidoEntrega(), ::bEdtPedidoEntrega() )
         end if

         ::oPedCliP:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oAlbCliP:LastRec() )
   end if

   if ::oAlbCliP:Seek( cTurno + cCaja )

      while ::oAlbCliP:cTurRec + ::oAlbCliP:cSufAlb + ::oAlbCliP:cCodCaj == cTurno + cCaja  .and. !::oAlbCliP:Eof()

         if !::oAlbCliP:lPasado
            ::oTotales:addTotAlbCliEntregas( cCaja, ::oAlbCliP:cSerAlb, ::nTotAlbaranEntrega(), ::cTxtAlbaranEntrega(), ::bEdtAlbaranEntrega() )
         end if

         ::oAlbCliP:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   /*
   Ventas por facturas---------------------------------------------------------
   */

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oFacCliT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando facturas' )
   end if

   if ::oFacCliT:Seek( cTurno + cCaja )

      while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac + ::oFacCliT:cCodCaj == cTurno + cCaja .and. !::oFacCliT:eof()

         ::oTotales:addTotFacCliContadores(  cCaja, ::oFacCliT:cSerie, ::nCntFacturaCliente(), ::cTxtFacturaCliente(), ::bEdtFacturaCliente() )
         ::oTotales:addTotFacCliVentas(      cCaja, ::oFacCliT:cSerie, ::nTotFacturaCliente(), ::cTxtFacturaCliente(), ::bEdtFacturaCliente() )
         ::oTotales:addNumeroFacturas(       cCaja )

         ::oFacCliT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   /*
   Ventas por facturas rectificativas -----------------------------------------
   */

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oRctCliT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando rectificativas' )
   end if

   if ::oRctCliT:Seek( cTurno + cCaja )
      while ::oRctCliT:cTurFac + ::oRctCliT:cSufFac + ::oRctCliT:cCodCaj == cTurno + cCaja .and. !::oRctCliT:eof()

         ::oTotales:addTotRctCliContadores(  cCaja, ::oRctCliT:cSerie, ::nCntFacturaRectificativaCliente(), ::cTxtFacturaRectificativaCliente(), ::bEdtFacturaRectificativaCliente() )
         ::oTotales:addTotRctCliVentas(      cCaja, ::oRctCliT:cSerie, ::nTotFacturaRectificativaCliente(), ::cTxtFacturaRectificativaCliente(), ::bEdtFacturaRectificativaCliente() )
         ::oTotales:addNumeroFacturas(       cCaja )

         ::oRctCliT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   /*
   Ventas por anticipos--------------------------------------------------------
   */

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oAntCliT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando anticipos' )
   end if

   ::oAntCliT:OrdSetFocus( "cTurAnt" )
   if ::oAntCliT:Seek( cTurno + cCaja )

      while ::oAntCliT:cTurAnt + ::oAntCliT:cSufAnt + ::oAntCliT:cCodCaj == cTurno + cCaja .and. !::oAntCliT:eof()

         ::oTotales:AddTotAntCliVentas( cCaja, ::oAntCliT:cSerAnt, ::nTotAnticipoCliente(), ::cTxtAnticipoCliente(), ::bEdtAnticipoCliente() )

         ::oAntCliT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   /*
   Ventas por anticipos--------------------------------------------------------
   */

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oAntCliT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando anticipos liquidados' )
   end if

   ::oAntCliT:OrdSetFocus( "cTurLiq" )
   if ::oAntCliT:Seek( cTurno + cCaja )

      while ::oAntCliT:cTurLiq + ::oAntCliT:cSufAnt + ::oAntCliT:cCajLiq == cTurno + cCaja .and. !::oAntCliT:eof()

         ::oTotales:AddTotAntCliLiquidados( cCaja, ::oAntCliT:cSerAnt, ::nTotAnticipoCliente(), ::cTxtAnticipoCliente(), ::bEdtAnticipoCliente() )

         ::oAntCliT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   ::oAntCliT:OrdSetFocus( "nNumAnt" )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD TotEntrada( cTurno, cCaja )

   DEFAULT cTurno       := ::cCurTurno
   DEFAULT cCaja        := ::cCurCaja

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oEntSal:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando entradas' )
   end if

   /*
   Entradas y salidas_________________________________________________________
   */

   if ::oEntSal:Seek( cTurno + cCaja )

      while ::oEntSal:cTurEnt + ::oEntSal:cSufEnt + ::oEntSal:cCodCaj == cTurno + cCaja .and. !::oEntSal:Eof()

         ::oTotales:addTotEntradas( ::oEntSal:cCodCaj, ::nTotEntradasSalidas(), ::cTxtEntradasSalidas(), ::bEdtEntradasSalidas() )

         ::oEntSal:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD TotCompra( cTurno, cCaja )

   DEFAULT cTurno       := ::cCurTurno
   DEFAULT cCaja        := ::cCurCaja

   // Albaranes de proveedores_________________________________________________

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oAlbPrvT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando albaran de proveedores' )
   end if

   if ::oAlbPrvT:Seek( cTurno + cCaja )

      while ::oAlbPrvT:cTurAlb + ::oAlbPrvT:cSufAlb + ::oAlbPrvT:cCodCaj == cTurno + cCaja .and. !::oAlbPrvT:Eof()

         if !::oAlbPrvT:lFacturado
            ::oTotales:addTotAlbPrvCompras( cCaja, ::oAlbPrvT:cSerAlb, ::nTotAlbaranProveedor(), ::cTxtAlbaranProveedor(), ::bEdtAlbaranProveedor() )
         end if

         ::oAlbPrvT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   // Facturas de proveedores__________________________________________________

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oFacPrvT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando facturas de proveedores' )
   end if

   if ::oFacPrvT:Seek( cTurno + cCaja )

      while ::oFacPrvT:cTurFac + ::oFacPrvT:cSufFac + ::oFacPrvT:cCodCaj == cTurno + cCaja .and. !::oFacPrvT:Eof()

         ::oTotales:addTotFacPrvCompras( cCaja, ::oFacPrvT:cSerFac, ::nTotFacturaProveedor(), ::cTxtFacturaProveedor(), ::bEdtFacturaProveedor() )

         ::oFacPrvT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   // Facturas rectificativa de proveedores____________________________________

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oRctPrvT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando facturas rectificativas de proveedores' )
   end if

   if ::oRctPrvT:Seek( cTurno + cCaja )

      while ::oRctPrvT:cTurFac + ::oRctPrvT:cSufFac + ::oRctPrvT:cCodCaj == cTurno + cCaja .and. !::oRctPrvT:Eof()

         ::oTotales:addTotRctPrvCompras( cCaja, ::oRctPrvT:cSerFac, ::nTotFacturaRectificativaProveedor(), ::cTxtFacturaRectificativaProveedor(), ::bEdtFacturaRectificativaProveedor() )

         ::oRctPrvT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD TotCobro( cTurno, cCaja )

   local cTipTik
   local nTotPgo
   local cFpgPgo
   local nTipoPgo
   local cTxtPgo
   local lFreTik

   DEFAULT cTurno       := ::cCurTurno
   DEFAULT cCaja        := ::cCurCaja

   /*
   Total cobrado __________________________________________________________________
   */

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oTikP:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando cobros' )
   end if

   ::oTikP:GetStatus()
   ::oTikP:OrdSetFocus( "cTurPgo" )

   if ::oTikP:Seek( cTurno + cCaja )

      while ::oTikP:cTurPgo + ::oTikP:cSufTik + ::oTikP:cCodCaj == cTurno + cCaja .and. !::oTikP:eof()

         cTipTik        := oRetFld( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik, ::oTikT, "cTipTik", 1 )
         nTipoPgo       := nTipoPago( ::oTikP:cFpgPgo, ::oFPago )

         do case
            case ( cTipTik == SAVTIK ) .or. ( cTipTik == SAVPDA ) // Como tiket

               ::oTotales:addTotTikCliCobros( cCaja, ::oTikP:cSerTik, ::nTotTiketCobro(), ::cTxtTiketCobro(), ::bEdtTiketCobro(), ::oTotales:hBmpDoc[ "TiketCliente" ] )

               do case
                  case nTipoPgo < 2
                     ::oTotales:addTotCobroEfectivo( cCaja, ::oTikP:cSerTik, ::nTotTiketCobro(), ::cTxtTiketCobro(), ::bEdtTiketCobro(), ::oTotales:hBmpDoc[ "TiketCliente" ] )
                  case nTipoPgo == 2
                     ::oTotales:addTotCobroNoEfectivo( cCaja, ::oTikP:cSerTik, ::nTotTiketCobro(), ::cTxtTiketCobro(), ::bEdtTiketCobro(), ::oTotales:hBmpDoc[ "TiketCliente" ] )
                  case nTipoPgo == 3
                     ::oTotales:addTotCobroTarjeta( cCaja, ::oTikP:cSerTik, ::nTotTiketCobro(), ::cTxtTiketCobro(), ::bEdtTiketCobro(), ::oTotales:hBmpDoc[ "TiketCliente" ] )
               end case

            case ( cTiptik == SAVVAL ) .and. oRetFld( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik, ::oTikT, "lFreTik", 1 ) // Como cheque regalo

               ::oTotales:addTotTikCliCobros( cCaja, ::oTikP:cSerTik, ::nTotTiketCobro(), ::cTxtTiketCobro(), ::bZooTiketCobro(), ::oTotales:hBmpDoc[ "TiketCliente" ] )

               do case
                  case nTipoPgo < 2
                     ::oTotales:addTotCobroEfectivo( cCaja, ::oTikP:cSerTik, ::nTotTiketCobro(), ::cTxtTiketCobro(), ::bZooTiketCobro(), ::oTotales:hBmpDoc[ "TiketCliente" ] )
                  case nTipoPgo == 2
                     ::oTotales:addTotCobroNoEfectivo( cCaja, ::oTikP:cSerTik, ::nTotTiketCobro(), ::cTxtTiketCobro(), ::bZooTiketCobro(), ::oTotales:hBmpDoc[ "TiketCliente" ] )
                  case nTipoPgo == 3
                     ::oTotales:addTotCobroTarjeta( cCaja, ::oTikP:cSerTik, ::nTotTiketCobro(), ::cTxtTiketCobro(), ::bZooTiketCobro(), ::oTotales:hBmpDoc[ "TiketCliente" ] )
               end case

            case ( cTipTik == SAVDEV ) // Como devolucion

               ::oTotales:addTotTikCliCobros( cCaja, ::oTikP:cSerTik, - ::nTotTiketCobro(), ::cTxtTiketCobro(), ::bEdtTiketCobro(), ::oTotales:hBmpDoc[ "TiketCliente" ] )

               do case
                  case nTipoPgo < 2
                     ::oTotales:addTotCobroEfectivo( cCaja, ::oTikP:cSerTik, - ::nTotTiketCobro(), ::cTxtTiketCobro(), ::bEdtTiketCobro(), ::oTotales:hBmpDoc[ "TiketCliente" ] )
                  case nTipoPgo == 2
                     ::oTotales:addTotCobroNoEfectivo( cCaja, ::oTikP:cSerTik, - ::nTotTiketCobro(), ::cTxtTiketCobro(), ::bEdtTiketCobro(), ::oTotales:hBmpDoc[ "TiketCliente" ] )
                  case nTipoPgo == 3
                     ::oTotales:addTotCobroTarjeta( cCaja, ::oTikP:cSerTik, - ::nTotTiketCobro(), ::cTxtTiketCobro(), ::bEdtTiketCobro(), ::oTotales:hBmpDoc[ "TiketCliente" ] )
               end case

         end case

         ::oTikP:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   ::oTikP:SetStatus()

   /*
   Total cobrado con facturas-----------------------------------------------------
   */

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oFacCliP:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando cobros' )
   end if

   ::oFacCliP:GetStatus()
   ::oFacCliP:OrdSetFocus( "cTurRec" )

   if ::oFacCliP:Seek( cTurno + cCaja )

      while ::oFacCliP:cTurRec + ::oFacCliP:cSufFac + ::oFacCliP:cCodCaj == cTurno + cCaja .and. !::oFacCliP:eof()

         if ::oFacCliP:lCobrado .and. !::oFacCliP:lPasado .and. !::oFacCliP:lNotArqueo

            ::oTotales:addTotRctCliCobros( cCaja, ::oFacCliP:cSerie, ::nTotFacturaCobro(), ::cTxtFacturaCobro(), ::bEdtFacturaCobro() )

            nTipoPgo    := nTipoPago( ::oFacCliP:cCodPgo, ::oFPago )

            do case
               case nTipoPgo < 2
                  ::oTotales:addTotCobroEfectivo(     cCaja, ::oFacCliP:cSerie, ::nTotFacturaCobro(), ::cTxtFacturaCobro(), ::bEdtFacturaCobro(), ::oTotales:hBmpDoc[ "ReciboClientes" ] )
               case nTipoPgo == 2
                  ::oTotales:addTotCobroNoEfectivo(   cCaja, ::oFacCliP:cSerie, ::nTotFacturaCobro(), ::cTxtFacturaCobro(), ::bEdtFacturaCobro(), ::oTotales:hBmpDoc[ "ReciboClientes" ] )
               case nTipoPgo == 3
                  ::oTotales:addTotCobroTarjeta(      cCaja, ::oFacCliP:cSerie, ::nTotFacturaCobro(), ::cTxtFacturaCobro(), ::bEdtFacturaCobro(), ::oTotales:hBmpDoc[ "ReciboClientes" ] )
            end case

            if !empty( cCuentaEmpresaRecibo( ::oFacCliP ) )
               ::oTotales:addTotBancos( cCaja, ::cBancoCuenta( ::oFacCliP ), ::nTotFacturaCobro(), ::cTxtFacturaCobro(), ::bEdtFacturaCobro(), ::oTotales:hBmpDoc[ "ReciboClientes" ] )
            end if

         end if

         ::oFacCliP:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   ::oFacCliP:SetStatus()

   /*
   Total entregas a cuenta-----------------------------------------------------
   */

   if ::oPedCliP:Seek( cTurno + cCaja )

      while ::oPedCliP:cTurRec + ::oPedCliP:cSufPed + ::oPedCliP:cCodCaj == cTurno + cCaja  .and. !::oPedCliP:Eof()

         if !::oPedCliP:lPasado

            nTipoPgo    := nTipoPago( ::oPedCliP:cCodPgo, ::oFPago )

            do case
               case nTipoPgo < 2
                  ::oTotales:addTotCobroEfectivo( cCaja, ::oPedCliP:cSerPed, ::nTotPedidoEntrega(), ::cTxtPedidoEntrega(), ::bEdtPedidoEntrega(), ::oTotales:hBmpDoc[ "PedidoCliente" ] )
               case nTipoPgo == 2
                  ::oTotales:addTotCobroNoEfectivo( cCaja, ::oPedCliP:cSerPed, ::nTotPedidoEntrega(), ::cTxtPedidoEntrega(), ::bEdtPedidoEntrega(), ::oTotales:hBmpDoc[ "PedidoCliente" ] )
               case nTipoPgo == 3
                  ::oTotales:addTotCobroTarjeta(  cCaja, ::oPedCliP:cSerPed, ::nTotPedidoEntrega(), ::cTxtPedidoEntrega(), ::bEdtPedidoEntrega(), ::oTotales:hBmpDoc[ "PedidoCliente" ] )
            end case

         end if

         ::oPedCliP:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   if ::oAlbCliP:Seek( cTurno + cCaja )

      while ::oAlbCliP:cTurRec + ::oAlbCliP:cSufAlb + ::oAlbCliP:cCodCaj == cTurno + cCaja  .and. !::oAlbCliP:Eof()

         if !::oAlbCliP:lPasado

            nTipoPgo    := nTipoPago( ::oAlbCliP:cCodPgo, ::oFPago )

            do case
               case nTipoPgo < 2
                  ::oTotales:addTotCobroEfectivo( cCaja, ::oAlbCliP:cSerAlb, ::nTotAlbaranEntrega(), ::cTxtAlbaranEntrega(), ::bEdtAlbaranEntrega(), ::oTotales:hBmpDoc[ "AlbaranCliente" ] )
               case nTipoPgo == 2
                  ::oTotales:addTotCobroNoEfectivo( cCaja, ::oAlbCliP:cSerAlb, ::nTotAlbaranEntrega(), ::cTxtAlbaranEntrega(), ::bEdtAlbaranEntrega(), ::oTotales:hBmpDoc[ "AlbaranCliente" ] )
               case nTipoPgo == 3
                  ::oTotales:addTotCobroTarjeta(  cCaja, ::oAlbCliP:cSerAlb, ::nTotAlbaranEntrega(), ::cTxtAlbaranEntrega(), ::bEdtAlbaranEntrega(), ::oTotales:hBmpDoc[ "AlbaranCliente" ] )
            end case

         end if

         ::oAlbCliP:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   /*
   Total cobrado en vales------------------------------------------------------
   */

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oTikT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando cobros' )
   end if

   ::oTikT:GetStatus()
   ::oTikT:OrdSetFocus( "cTurVal" )

   if ::oTikT:Seek( cTurno + cCaja )

      while ::oTikT:cTurVal + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurno + cCaja .and. !::oTikT:eof()

         if ::oTikT:cTipTik == SAVVAL .and. ::oTikT:lLiqTik
            ::oTotales:addTotValCliCobros( cCaja, ::oTikT:cSerTik, nTotTik( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik, ::oTikT:cAlias, ::oTikL:cAlias, ::oDbfDiv:cAlias, nil, cDivEmp(), .f., nil ) )
         end if

         ::oTikT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   ::oTikT:SetStatus()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD TotPago( cTurno, cCaja )

   local nTipoPgo

   DEFAULT cTurno       := ::cCurTurno
   DEFAULT cCaja        := ::cCurCaja

   /*
   Total cobrado con facturas-----------------------------------------------------
   */

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oFacPrvP:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando pagos' )
   end if

   ::oFacPrvP:GetStatus()
   ::oFacPrvP:OrdSetFocus( "cTurRec" )

   if ::oFacPrvP:Seek( cTurno + cCaja )

      while ::oFacPrvP:cTurRec + ::oFacPrvP:cSufFac + ::oFacPrvP:cCodCaj == cTurno + cCaja .and. !::oFacPrvP:eof()

         if ::oFacPrvP:lCobrado .and. !::oFacPrvP:lNotArqueo 

            nTipoPgo    := nTipoPago( ::oFacPrvP:cCodPgo, ::oFPago )

            ::oTotales:addTotFacPrvPagos( cCaja, ::oFacPrvP:cSerFac, ::nTotFacturaPago(), ::cTxtFacturaPago(), ::bEdtFacturaPago() )

            do case
               case nTipoPgo < 2
                  ::oTotales:addTotPagoEfectivo( cCaja, ::oFacPrvP:cSerFac, ::nTotFacturaPago(), ::cTxtFacturaPago() )
               case nTipoPgo == 2
                  ::oTotales:addTotPagoNoEfectivo( cCaja, ::oFacPrvP:cSerFac, ::nTotFacturaPago(), ::cTxtFacturaPago() )
               case nTipoPgo == 3
                  ::oTotales:addTotPagoTarjeta( cCaja, ::oFacPrvP:cSerFac, ::nTotFacturaPago(), ::cTxtFacturaPago() )
            end case

            if !empty( cCuentaEmpresaRecibo( ::oFacPrvP ) )
               ::oTotales:addTotBancos( cCaja, ::cBancoCuenta( ::oFacPrvP ), - ::nTotFacturaPago(), ::cTxtFacturaPago(), ::bEdtFacturaPago(), ::oTotales:hBmpDoc[ "PagoProveedor" ] )
            end if

         end if

         ::oFacPrvP:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

   ::oFacPrvP:SetStatus()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD TotTipoIva( cTurno, cCaja )

   local nPos           := 0
   local nBasLin        := 0
   local nIvaLin        := 0
   local nTotLin        := 0

   DEFAULT cTurno       := ::cCurTurno
   DEFAULT cCaja        := ::cCurCaja

   ::aTipIva            := {}

   /*

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oAlbCliT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando albaranes' )
   end if

   if ::oAlbCliT:Seek( cTurno + cCaja )

      while ::oAlbCliT:cTurAlb + ::oAlbCliT:cSufAlb + ::oAlbCliT:cCodCaj == cTurno + cCaja .and. !::oAlbCliT:eof()

         if !::oAlbCliT:lFacturado        .and.;
            ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .and. !::oAlbCliL:Eof()

            nBasLin     := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDouDiv, ::nDorDiv, ::nVdvDiv )
            nIvaLin     := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDouDiv, ::nDorDiv, ::nVdvDiv )
            nTotLin     := nBasLin + nIvaLin

            nPos        := aScan( ::aTipIva, {|x| x[1] == ::oAlbCliL:nIva } )
            if nPos != 0
               ::aTipIva[ nPos, 2 ] += nBasLin
               ::aTipIva[ nPos, 3 ] += nIvaLin
               ::aTipIva[ nPos, 4 ] += nTotLin
            else
               aAdd( ::aTipIva, { ::oAlbCliL:nIva, nBasLin, nIvaLin, nTotLin } )
            end if

            ::oAlbCliL:Skip()

            end while

         end if

         ::oAlbCliT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end while

   end if

   */

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oFacCliT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando facturas' )
   end if

   if ::oFacCliT:Seek( cTurno + cCaja )

      while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac + ::oFacCliT:cCodCaj == cTurno + cCaja .and. !::oFacCliT:eof()

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .and. !::oFacCliL:Eof()

            nBasLin     := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDouDiv, ::nDorDiv, ::nVdvDiv )
            nIvaLin     := nIvaLFacCli( ::oFacCliL:cAlias, ::nDouDiv, ::nDorDiv, ::nVdvDiv )
            nTotLin     := nBasLin + nIvaLin

            nPos        := aScan( ::aTipIva, {|x| x[1] == ::oFacCliL:nIva } )
            if nPos != 0
               ::aTipIva[ nPos, 2 ] += nBasLin
               ::aTipIva[ nPos, 3 ] += nIvaLin
               ::aTipIva[ nPos, 4 ] += nTotLin
            else
               aAdd( ::aTipIva, { ::oFacCliL:nIva, nBasLin, nIvaLin, nTotLin } )
            end if

            ::oFacCliL:Skip()

            end while

         end if

         ::oFacCliT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end while

   end if

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oRctCliT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando rectificativas' )
   end if

   if ::oRctCliT:Seek( cTurno + cCaja )

      while ::oRctCliT:cTurFac + ::oRctCliT:cSufFac + ::oRctCliT:cCodCaj == cTurno + cCaja .and. !::oRctCliT:eof()

         if ::oRctCliL:Seek( ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac )

            while ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac == ::oRctCliL:cSerie + Str( ::oRctCliL:nNumFac ) + ::oRctCliL:cSufFac .and. !::oRctCliL:Eof()

            nBasLin     := nImpLFacRec( ::oRctCliT:cAlias, ::oRctCliL:cAlias, ::nDouDiv, ::nDorDiv, ::nVdvDiv )
            nIvaLin     := nIvaLFacRec( ::oRctCliL:cAlias, ::nDouDiv, ::nDorDiv, ::nVdvDiv ) 
            nTotLin     := nBasLin + nIvaLin

            nPos        := aScan( ::aTipIva, {|x| x[1] == ::oRctCliL:nIva } )
            if nPos != 0
               ::aTipIva[ nPos, 2 ] += nBasLin
               ::aTipIva[ nPos, 3 ] += nIvaLin
               ::aTipIva[ nPos, 4 ] += nTotLin
            else
               aAdd( ::aTipIva, { ::oRctCliL:nIva, nBasLin, nIvaLin, nTotLin } )
            end if

            ::oRctCliL:Skip()

            end while

         end if

         ::oRctCliT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end while

   end if

   if !empty( ::oMeter )
      ::oMeter:SetTotal( ::oTikT:LastRec() )
   end if

   if !empty( ::oTxt )
      ::oTxt:SetText( 'Calculando tickets' )
   end if

   if ::oTikT:Seek( cTurno + cCaja )

      while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurno + cCaja .and. !::oTikT:eof()

         if ( ::oTikT:cTipTik == SAVTIK .or. ::oTikT:cTipTik == SAVDEV )

            if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

               while ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik == ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil .and. !::oTikL:Eof()

                  if !::oTikL:lDelTil

                     nBasLin     := nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv, ::nVdvDiv )
                     nIvaLin     := nIvaLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv, ::nVdvDiv )
                     nTotLin     := nBasLin + nIvaLin

                     nPos        := aScan( ::aTipIva, {|x| x[1] == ::oTikL:nIvaTil } )
                     if nPos != 0
                        ::aTipIva[ nPos, 2 ] += nBasLin
                        ::aTipIva[ nPos, 3 ] += nIvaLin
                        ::aTipIva[ nPos, 4 ] += nTotLin
                     else
                        aAdd( ::aTipIva, { ::oTikL:nIvaTil, nBasLin, nIvaLin, nTotLin } )
                     end if

                  end if

               ::oTikL:Skip()

               end while

            end if

         end if

         ::oTikT:Skip()

         if !empty( ::oMeter )
            ::oMeter:AutoInc()
         end if

         SysRefresh()

      end do

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD EdtCol( oCol, xValue, nLastKey )

   if nLastKey == 13
      ::oDbfDet:FieldPutByName( "nCanAct", xValue )
   endif

return ( .t. )

//--------------------------------------------------------------------------//

METHOD EdtAnt( oCol, xValue, nLastKey )

   if nLastKey == 13
      ::oDbfDet:FieldPutByName( "nCanAnt", xValue )
   endif

return ( .t. )

//--------------------------------------------------------------------------//

METHOD DlgImprimir( nDevice, lTactil )

   local oDlg
   local oCodCaj
   local oCajNbr
   local cCodCaj     
   local cCajNbr     
   local cBtnPrompt
   local bBtnAction
   local oPrinter

   DEFAULT lTactil   := .f.

   if ::lArqueoCiego
      MsgStop( "No tiene privilegios para imprimir el arqueo." )
      Return ( Self )
   end if 

   cCodCaj           := ::GetCurrentCaja()
   cCajNbr           := oRetFld( cCodCaj, ::oCaja, "cNomCaj" )

   ::cWinArq         := cPrinterArqueo( cCodCaj, ::oCaja:cAlias )
   ::cPrnArq         := cFormatoArqueoEnCaja( ::oDbfCaj:cCodCaj, ::oCaja:cAlias )

   do case
      case nDevice == nil
         cBtnPrompt  := "&Aceptar"
         bBtnAction  := {|| ::SetTreeState( ::oTreeImpresion:aItems ), oDlg:End( IDOK ) }
      case nDevice == IS_SCREEN
         cBtnPrompt  := "&Previsualizar"
         bBtnAction  := {|| ::ExecuteDlgImprimir( cCodCaj, nDevice, oDlg ) }
      case nDevice == IS_PRINTER
         cBtnPrompt  := "&Imprimir"
         bBtnAction  := {|| ::ExecuteDlgImprimir( cCodCaj, nDevice, oDlg ) }
   end case

   if lTactil

      do case

         case ::nScreenVertRes == 560
            DEFINE DIALOG oDlg RESOURCE "ARQUEOIMP_1024x576" TITLE "Sesión : " + ::oDbf:cNumTur

         case ::nScreenVertRes != 560
            DEFINE DIALOG oDlg RESOURCE "ARQUEOIMPBIG" TITLE "Sesión : " + ::oDbf:cNumTur

      end case

   else

      DEFINE DIALOG oDlg RESOURCE "ARQUEOIMP" TITLE "Sesión : " + ::oDbf:cNumTur

   end if

   ::SetCurrentTurno()

   /*
   Cajas____________________________________________________________________
   */

   if lTactil

      REDEFINE GET oCodCaj VAR cCodCaj;
         ID       140 ;
         BITMAP   "LUPA_24" ;
         OF       oDlg

      oCodCaj:nMargin   := 25
      oCodCaj:bWhen     := {|| oUser():lAdministrador() }
      oCodCaj:bValid    := {|| cCajas( oCodCaj, ::oCaja:cAlias, oCajNbr )  }
      oCodCaj:bHelp     := {|| BrwCajaTactil( oCodCaj, ::oCaja:cAlias, oCajNbr ) }

      REDEFINE GET oCajNbr VAR cCajNbr ;
         ID       141 ;
         WHEN     .f. ;
         OF       oDlg

   else

      REDEFINE GET oCodCaj VAR cCodCaj;
         ID       140 ;
         BITMAP   "LUPA" ;
         OF       oDlg

      oCodCaj:bWhen  := {|| oUser():lAdministrador() }
      oCodCaj:bValid := {|| cCajas( oCodCaj, ::oCaja:cAlias, oCajNbr )  }
      oCodCaj:bHelp  := {|| BrwCajas( oCodCaj, oCajNbr ) }

      REDEFINE GET oCajNbr VAR cCajNbr ;
         ID       141 ;
         WHEN     .f. ;
         OF       oDlg

   end if

   ::oTreeImpresion           := TTreeView():Redefine( 400, oDlg )
   ::oTreeImpresion:bChanged  := {|| ::ChangedTreeImpresion() }

   /*
   Formato de arqueo--------------------------------------------------------
   */

   if lTactil

      REDEFINE GET ::oPrnArq ;
         VAR      ::cPrnArq ;
         ID       230 ;
         IDTEXT   231 ;
         BITMAP   "LUPA_24" ;
         OF       oDlg

      ::oPrnArq:nMargin := 25
      ::oPrnArq:bValid  := {|| cDocumento( ::oPrnArq, ::oPrnArq:oHelpText ) }
      ::oPrnArq:bHelp   := {|| BrwDocumento( ::oPrnArq, ::oPrnArq:oHelpText, "AQ" ) }

      REDEFINE BUTTONBMP ;
         ID       232 ;
         OF       oDlg ;
         BITMAP   "gc_document_text_pencil_12" ;
         ACTION   ( EdtDocumento( ::cPrnArq ) )

   else

      REDEFINE GET ::oPrnArq ;
         VAR      ::cPrnArq ;
         ID       230 ;
         IDTEXT   231 ;
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oPrnArq:bValid  := {|| cDocumento( ::oPrnArq, ::oPrnArq:oHelpText ) }
      ::oPrnArq:bHelp   := {|| BrwDocumento( ::oPrnArq, ::oPrnArq:oHelpText, "AQ" ) }

      TBtnBmp():ReDefine( 232, "gc_document_text_pencil_12",,,,,{|| EdtDocumento( ::cPrnArq ) }, oDlg, .f., , .f.,  )

   end if

      /*
      Impresora de arqueo------------------------------------------------------
      */

      REDEFINE GET oPrinter VAR ::cWinArq ;
         WHEN     ( .f. ) ;
         ID       370 ;
         OF       oDlg

   if lTactil

      REDEFINE BUTTONBMP ;
         ID       371 ;
         OF       oDlg ;
         BITMAP   "gc_printer2_check_16" ;
         ACTION   ( PrinterPreferences( oPrinter ) )

   else

      TBtnBmp():ReDefine( 371, "gc_printer2_check_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

   end if

      /*
      Botones------------------------------------------------------------------
      */

      TButton():ReDefine( 560, bBtnAction, oDlg,,, .f.,,, cBtnPrompt, .f. )

      TButton():ReDefine( 570, {|| oDlg:End( 1 ) }, oDlg,,, .f.,,,, .f. )

      oDlg:bStart := {|| ::StartDlgImprimir() }

   oDlg:Activate( , , , .t., {|| .t. }, , {|| ::InitDlgImprimir() } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD StartDlgImprimir()

   ::oPrnArq:oHelpText:cText( oRetFld( ::cPrnArq, ::oDbfDoc, "cDescrip", 1 ) )

   /*
   Opciones de impresion-------------------------------------------------------
   */

   ::GetTreeState( ::oTreeImpresion:aItems )

   ::oTreeImpresion:Select( ::oTreeGeneral )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ExecuteDlgImprimir( cCodCaj, nDevice, oDlg )

   oDlg:Disable()

   ::SetTreeState( ::oTreeImpresion:aItems )

   ::PrintArqueo( ::oDbf:cNumTur + ::oDbf:cSufTur, cCodCaj, nDevice, "Imprimiendo arqueo", ::cPrnArq, ::cWinArq )

   oDlg:Enable()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD PrintArqueo( cTurno, cCaja, nDevice, cCaption, cDocumento, cPrinter, nCopies )

   DEFAULT cTurno       := ::cCurTurno
   DEFAULT cCaja        := ::cCurCaja
   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo arqueo"
   DEFAULT cDocumento   := cFormatoArqueoEnCaja( ::GetCurrentCaja(), ::oCaja:cAlias )
   DEFAULT nCopies      := nCopiasArqueosEnCaja( ::GetCurrentCaja(), ::oCaja:cAlias )
   DEFAULT cPrinter     := cPrinterArqueo( ::GetCurrentCaja(), ::oCaja:cAlias )

   if ::oDbf:Lastrec() == 0
      return nil
   end if

   if !lExisteDocumento( cDocumento, ::oDbfDoc:cAlias )
      return nil
   end if

   if lVisualDocumento( cDocumento, ::oDbfDoc:cAlias )

      ::lCalTurno( cTurno, cCaja )

      ::FillTemporal( cCaja )

      ::PrintReport( cTurno, cCaja, nDevice, nCopies, cPrinter, ::oDbfDoc:cAlias )

      ::DestroyTemporal()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Reindexa( oMeter )

   ::DefineFiles()

   if !empty( ::oDbf )
      ::oDbf:IdxFDel()
      ::oDbf:Activate( .f., .t., .f. )
      ::oDbf:Pack()
      ::oDbf:End()
   end if

   if !empty( ::oDbfCaj )
      ::oDbfCaj:IdxFDel()
      ::oDbfCaj:Activate( .f., .t., .f. )
      ::oDbfCaj:Pack()
      ::oDbfCaj:End()
   end if

   if !empty( ::oDbfDet )
      ::oDbfDet:IdxFDel()
      ::oDbfDet:Activate( .f., .t., .f. )
      ::oDbfDet:Pack()
      ::oDbfDet:End()
   end if

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Contabiliza()

   /*
   Cerrar por turnos___________________________________________________________
   */

   if ::oDbf:nStaTur != cajCerrrada .and. !::lAllSesions
      ::oTreeSelect:Add( "Sesión : " + Alltrim( ::oDbf:cNumTur ) + "/" + Rtrim( ::oDbf:cSufTur ) + " no cerrada", 0 )
      Return ( Self )
   end if

   if ::oDbf:lConTur .and. !::lAllSesions
      ::oTreeSelect:Add( "Sesión : " + Alltrim( ::oDbf:cNumTur ) + "/" + Rtrim( ::oDbf:cSufTur ) + " ya contabilizada", 0 )
      Return ( Self )
   end if

   ::oMtrSelect:SetTotal( 8 )

   /*
   Realización de Asientos
   -------------------------------------------------------------------------
   */

   if OpenDiario( cRutCnt(), ::cGetEmpresaContaplus )
      ::nAsiento     := contaplusUltimoAsiento()
      CloseDiario()
   else
      ::oTreeSelect:Add( "Sesión : " + Alltrim( ::oDbf:cNumTur ) + "/" + Rtrim( ::oDbf:cSufTur ) + " imposible abrir ficheros de contaplus", 0 )
      return .f.
   end if

   /*
   Inicializamos
   ----------------------------------------------------------------------------
   */

   ::oDbf:GetStatus()

   if ::lChkSimula
      ::aSimula      := {}
   else
      ::aSimula      := nil
   end if

   /*
   Contabilizar facturas a proveedores
   ----------------------------------------------------------------------------
   */

   ::oMtrSelect:Set( 1 )

   if ::lChkContabilizarFacturasProveedores

      ::oTreeSelect:Add( "Contabilizando factura de proveedores", 1 )

      ::oMtrProcess:SetTotal( ::oFacPrvT:OrdKeyCount() )

      ::oFacPrvT:GoTop()

      if ::lAllSesions .or. ::oFacPrvT:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

         while ( ::lAllSesions .or. ::oFacPrvT:cTurFac + ::oFacPrvT:cSufFac == ::oDbf:cNumTur + ::oDbf:cSufTur ) .and. !::lBreak .and. !::oFacPrvT:eof()

            if ::oFacPrvT:dFecFac >= ::dFechaInicio .and. ::oFacPrvT:dFecFac <= ::dFechaFin .and. lChkSer( ::oFacPrvT:cSerFac, ::aSer )

               CntFacPrv( ::lChkSimula, ::lChkContabilizarPagosProveedores, .f., ::oTreeSelect, nil, ::aSimula, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oFacPrvP:cAlias, ::oProvee:cAlias, ::oDbfDiv:cAlias, ::oArticulo:cAlias, ::oFPago:cAlias, ::oIvaImp:cAlias )

            end if

            ::oFacPrvT:Skip()

            ::oMtrProcess:Set( ::oFacPrvT:OrdKeyNo() )

         end while

      end if

   end if

   ::oMtrProcess:Set( ::oFacPrvT:OrdKeyNo() )

   /*
   Contabilizar facturas rectificativas a proveedores
   ----------------------------------------------------------------------------
   */

   ::oMtrSelect:Set( 2 )

   if ::lChkContabilizarRectificativasProveedores

      ::oTreeSelect:Add( "Contabilizando factura rectificativa de proveedores", 1 )

      ::oMtrProcess:SetTotal( ::oRctPrvT:OrdKeyCount() )

      ::oRctPrvT:GoTop()

      if ::lAllSesions .or. ::oRctPrvT:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

         while ( ::lAllSesions .or. ::oRctPrvT:cTurFac + ::oRctPrvT:cSufFac == ::oDbf:cNumTur + ::oDbf:cSufTur ) .and. !::lBreak .and. !::oRctPrvT:eof()

            if ::oRctPrvT:dFecFac >= ::dFechaInicio .and. ::oRctPrvT:dFecFac <= ::dFechaFin .and. lChkSer( ::oRctPrvT:cSerFac, ::aSer )

               CntRctPrv( ::lChkSimula, ::lChkContabilizarPagosProveedores, .f., ::oTreeSelect, nil, ::aSimula, ::oRctPrvT:cAlias, ::oRctPrvL:cAlias, ::oFacPrvP:cAlias, ::oProvee:cAlias, ::oDbfDiv:cAlias, ::oArticulo:cAlias, ::oFPago:cAlias, ::oIvaImp:cAlias )

            end if

            ::oRctPrvT:Skip()

            ::oMtrProcess:Set( ::oRctPrvT:OrdKeyNo() )

         end while

      end if

   end if

   ::oMtrProcess:Set( ::oRctPrvT:OrdKeyNo() )

   /*
   Contabilizar pagos a proveedores
   ----------------------------------------------------------------------------
   */

   ::oMtrSelect:Set( 3 )

   if ::lChkContabilizarPagosProveedores .and. !::lChkContabilizarFacturasProveedores

      ::oTreeSelect:Add( "Contabilizando pagos a proveedores", 1 )

      ::oMtrProcess:SetTotal( ::oFacPrvP:OrdKeyCount() )

      ::oFacPrvP:GoTop()

      if ::lAllSesions .or. ::oFacPrvP:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

         while ( ::lAllSesions .or. ::oFacPrvP:cTurFac + ::oFacPrvP:cSufFac == ::oDbf:cNumTur + ::oDbf:cSufTur ) .and. !::lBreak  .and. !::oFacPrvP:eof()

            if ::oFacPrvP:dPreCob >= ::dFechaInicio .and. ::oFacPrvP:dPreCob <= ::dFechaFin .and. lChkSer( ::oFacPrvP:cSerFac, ::aSer )

               CntRecPrv( ::lChkSimula, ::oTreeSelect, nil, ::aSimula, .f., ::oFacPrvT:cAlias, ::oFacPrvP:cAlias, ::oProvee:cAlias, ::oFPago:cAlias, ::oDbfDiv:cAlias )

            end if

            ::oFacPrvP:Skip()

            ::oMtrProcess:Set( ::oFacPrvP:OrdKeyNo() )

         end while

      end if

   end if

   ::oMtrProcess:Set( ::oFacPrvP:OrdKeyCount() )

   /*
   Contabilizar contadores
   ----------------------------------------------------------------------------
   */

   ::oMtrSelect:Set( 4 )

   if !::lAllSesions .and. ::lChkContabilizarContadores

      ::oTreeSelect:Add( "Contabilizando contadores", 1 )

      if ::oDbfDet:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

         while ::oDbfDet:cNumTur + ::oDbfDet:cSufTur == ::oDbf:cNumTur + ::oDbf:cSufTur .and. !::lBreak  .and. !::oDbfDet:eof()

            ::ContabilizaContadores()

            ::oDbfDet:Skip()

         end while

      end if

   end if

   /*
   Contabilizar tikets
   ----------------------------------------------------------------------------
   */

   ::oMtrSelect:Set( 5 )

   if ::lChkContabilizarTicket

      ::oTreeSelect:Add( "Contabilizando tickets", 1 )

      ::oMtrProcess:SetTotal( ::oTikT:OrdKeyCount() )

      ::oTikT:GoTop()

      if ::lAllSesions .or. ::oTikT:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

         while ( ::lAllSesions .or. ::oTikT:cTurTik + ::oTikT:cSufTik == ::oDbf:cNumTur + ::oDbf:cSufTur ) .and. !::lBreak .and. !::oTikT:eof()

            if ::oTikT:dFecTik >= ::dFechaInicio .and. ::oTikT:dFecTik <= ::dFechaFin .and. lChkSer( ::oTikT:cSerTik, ::aSer )

               do case
               case ::oTikT:cTipTik == SAVTIK // Como tiket

                  CntTiket( ::lChkSimula, .t., .f., .f., ::oTreeSelect, nil, ::aSimula, ::oTikT:cAlias, ::oTikL:cAlias, ::oTikP:cAlias, ::oClient:cAlias, ::oArticulo:cAlias, ::oFPago:cAlias, ::oDbfDiv:cAlias )

               case ::oTikT:cTipTik == SAVDEV // Como devolucion

                  CntTiket( ::lChkSimula, .t., .f., .f., ::oTreeSelect, nil, ::aSimula, ::oTikT:cAlias, ::oTikL:cAlias, ::oTikP:cAlias, ::oClient:cAlias, ::oArticulo:cAlias, ::oFPago:cAlias, ::oDbfDiv:cAlias )

               end case

            end if

            ::oTikT:Skip()

            ::oMtrProcess:Set( ::oTikT:OrdKeyNo() )

         end while

      end if

      ::oMtrProcess:Set( ::oTikT:OrdKeyCount() )

   end if

   /*
   Contabilizar facturas
   ----------------------------------------------------------------------------
   */

   ::oMtrSelect:Set( 6 )

   if ::lChkContabilizarFactura

      ::oTreeSelect:Add( "Contabilizando facturas de clientes", 1 )

      ::oMtrProcess:SetTotal( ::oFacCliT:OrdKeyCount() )

      ::oFacCliT:GoTop()

      if ::lAllSesions .or. ::oFacCliT:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

         while ( ::lAllSesions .or. ::oFacCliT:cTurFac + ::oFacCliT:cSufFac == ::oDbf:cNumTur + ::oDbf:cSufTur ) .and. !::lBreak .and. !::oFacCliT:eof()

            if ::oFacCliT:dFecFac >= ::dFechaInicio .and. ::oFacCliT:dFecFac <= ::dFechaFin .and. lChkSer( ::oFacCliT:cSerie, ::aSer )

               CntFacCli( ::lChkSimula, .f., nil, .f., ::oTreeSelect, nil, ::aSimula, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, ::oAlbCliT:cAlias, ::oClient:cAlias, ::oDbfDiv:cAlias, ::oArticulo:cAlias, ::oFPago:cAlias, ::oIvaImp:cAlias, ::oNewImp )

            end if 

            ::oFacCliT:Skip()

            ::oMtrProcess:Set( ::oFacCliT:OrdKeyNo() )

         end while

      end if

      ::oMtrProcess:Set( ::oFacCliT:OrdKeyCount() )

   end if

   /*
   Contabilizar pagos
   ----------------------------------------------------------------------------
   */

   if ::lChkContabilizarFactura

      ::oTreeSelect:Add( "Contabilizando pagos de clientes", 1 )

      ::oMtrProcess:SetTotal( ::oFacCliP:OrdKeyCount() )

      ::oFacCliP:GoTop()

      if ::lAllSesions .or. ::oFacCliP:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

         while ( ::lAllSesions .or. ::oFacCliP:cTurFac + ::oFacCliP:cSufFac == ::oDbf:cNumTur + ::oDbf:cSufTur ) .and. !::lBreak .and. !::oFacCliP:eof()

            if ::oFacCliP:dFecFac >= ::dFechaInicio .and. ::oFacCliP:dFecFac <= ::dFechaFin .and. lChkSer( ::oFacCliP:cSerie, ::aSer )

               ContabilizaReciboCliente( nil, ::oTreeSelect, ::lChkSimula, ::aSimula, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oFPago:cAlias, ::oClient:cAlias, ::oDbfDiv:cAlias, .f. )

               // ContabilizaReciboCliente( oBrw, oTree, lSimula, aSimula, dbfFacCliT, dbfFacCliP, dbfFPago, dbfCli, dbfDiv, lFromFactura, nAsiento )

            end if 

            ::oFacCliP:Skip()

            ::oMtrProcess:Set( ::oFacCliP:OrdKeyNo() )

         end while

      end if

      ::oMtrProcess:Set( ::oFacCliP:OrdKeyCount() )

   end if 

   /*
   Contabilizar facturas rectificativas
   ----------------------------------------------------------------------------
   */

   ::oMtrSelect:Set( 7 )

   if ::lChkContabilizarRectificativa

      ::oTreeSelect:Add( "Contabilizando facturas rectificativas de clientes", 1 )

      ::oMtrProcess:SetTotal( ::oRctCliT:OrdKeyCount() )

      ::oRctCliT:GoTop()

      if ::lAllSesions .or. ::oRctCliT:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

         while ( ::lAllSesions .or. ::oRctCliT:cTurFac + ::oRctCliT:cSufFac == ::oDbf:cNumTur + ::oDbf:cSufTur ) .and. !::lBreak .and. !::oRctCliT:eof()

            if ::oRctCliT:dFecFac >= ::dFechaInicio .and. ::oRctCliT:dFecFac <= ::dFechaFin .and. lChkSer( ::oRctCliT:cSerie, ::aSer )

               CntFacRec( ::lChkSimula, .t., nil, .f., ::oTreeSelect, nil, ::aSimula, ::oRctCliT:cAlias, ::oRctCliL:cAlias, ::oFacCliP:cAlias, ::oClient:cAlias, ::oDbfDiv:cAlias, ::oArticulo:cAlias, ::oFPago:cAlias, ::oIvaImp:cAlias, ::oNewImp )

            end if 

            ::oRctCliT:Skip()

            ::oMtrProcess:Set( ::oRctCliT:OrdKeyNo() )

         end while

      end if

      ::oMtrProcess:Set( ::oRctCliT:OrdKeyCount() )

   end if

   ::oMtrSelect:Set( 8 )

   // ::MixApunte()

   if !::lChkSimula

      ::Asiento( .t. )

   else

      if !empty( ::aSimula )
         if OpenDiario( cRutCnt(), ::cGetEmpresaContaplus )
            msgTblCon( ::aSimula, cDivEmp(), ::oDbfDiv:cAlias )
            CloseDiario()
         end if
      else
         MsgStop( "El asiento está vacío" )
      end if

   end if

   ::oTreeSelect:Add( "Proceso finalizado", 1 )

   ::oDbf:SetStatus()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD MixApunte()

   local n
   local nLen
   local nScan
   local cApunte
   local aApunte  := aClone( ::aSimula )

   nLen           := len( aApunte )
   ::aSimula      := {}

   for n := 1 to nLen

      cApunte     := aApunte[ n ]

      if cApunte[ _PTADEBE  ] != 0 .or. ;
         cApunte[ _PTAHABER ] != 0 .or. ;
         cApunte[ _EURODEBE ] != 0 .or. ;
         cApunte[ _EUROHABER] != 0 .or. ;
         cApunte[ _BASEEURO ] != 0 .or. ;
         cApunte[ _BASEIMPO ] != 0

         nScan    := aScan( ::aSimula, {| cSimula |cApunte[ _SUBCTA   ] == cSimula[ _SUBCTA   ] .and. ;
                                                   cApunte[ _CONTRA   ] == cSimula[ _CONTRA   ] .and. ;
                                                   cApunte[ _IVA      ] == cSimula[ _IVA      ] .and. ;
                                                   cApunte[ _RECEQUIV ] == cSimula[ _RECEQUIV ] .and. ;
                                                   cApunte[ _CONCEPTO ] == cSimula[ _CONCEPTO ] } )
         if nScan != 0
            ::aSimula[ nScan, _PTADEBE  ]     += cApunte[ _PTADEBE  ]
            ::aSimula[ nScan, _PTAHABER ]     += cApunte[ _PTAHABER ]
            ::aSimula[ nScan, _EURODEBE ]     += cApunte[ _EURODEBE ]
            ::aSimula[ nScan, _EUROHABER]     += cApunte[ _EUROHABER]
            ::aSimula[ nScan, _BASEEURO ]     += cApunte[ _BASEEURO ]
            ::aSimula[ nScan, _BASEIMPO ]     += cApunte[ _BASEIMPO ]
         else
            aAdd( ::aSimula, cApunte )
         end if

      end if

   next

Return nil

//---------------------------------------------------------------------------//

METHOD ContabilizaContadores()

   local m
   local aCli        := {}
   local aVta        := {}
   local aIva        := {}
   local aIvm        := {}
   local aPgo        := {}
   local nPos        := 0
   local nTotCon     := 0
   local nImpDet     := 0
   local nImpIvm     := 0
   local nIvaDet     := 0
   local nDouDiv     := 0
   local nRouDiv     := 0
   local cCtaIva     := ""
   local cOrdAnt     := ""
   local cCtaPgo     := cCtaCob()
   local cCtaCli     := cCtaSin()
   local cRutCnt     := cRutCnt()
   local cCodDiv     := cDivEmp()
   local cCtaIvm     := cCtaVta() + RetGrpVta( ::oDbfDet:cCodArt, cRutCnt, ::cGetEmpresaContaplus, ::oArticulo:cAlias )
   local cCtaVen     := RetCtaVta( ::oDbfDet:cCodArt, .f., ::oArticulo:cAlias )
   local cDesAsi     := "N/Sesión " + lTrim( ::oDbf:cNumTur ) + "/" + ::oDbf:cSufTur
   local cPgoAsi     := "C/Sesión " + lTrim( ::oDbf:cNumTur ) + "/" + ::oDbf:cSufTur
   local dFecha      := ::oDbf:dCloTur
   local cTerNif     := Space(1)
   local cTerNom     := Space(1)

   nTotCon           := Round( ::oDbfDet:nPvpArt * ( ::oDbfDet:nCanAct - ::oDbfDet:nCanAnt ), ::nDorDiv )

   /*
   Quitamos los contadores vendidos a credito
   ----------------------------------------------------------------------------
   */

   cOrdAnt           := ::oAlbCliL:ordSetFocus( "cNumRef" )

   if ::oAlbCliT:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

      while ::oAlbCliT:cTurAlb + ::oAlbCliT:cSufAlb == ::oDbf:cNumTur + ::oDbf:cSufTur .and. !::oAlbCliT:eof()

         nDouDiv     := nDouDiv( ::oAlbCliT:cDivAlb, ::oDbfDiv:cAlias )
         nRouDiv     := nRouDiv( ::oAlbCliT:cDivAlb, ::oDbfDiv:cAlias )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb + ::oDbfDet:cCodArt )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb + ::oDbfDet:cCodArt == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb + ::oAlbCliL:cRef .and. !::oAlbCliL:eof()

               nTotCon  -= nTotLAlbCli( ::oAlbCliL:cAlias, nDouDiv, nRouDiv, nil, .t., .f., .f. )

               ::oAlbCliL:Skip()

            end while

         end if

         ::oAlbCliT:Skip()

      end while

   end if

   ::oAlbCliL:ordSetFocus( cOrdAnt )

   /*
   Quitamos los contadores vendidos en facturas
   ----------------------------------------------------------------------------
   */

   cOrdAnt           := ::oFacCliL:ordSetFocus( "cNumRef" )

   if ::oFacCliT:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

      while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac == ::oDbf:cNumTur + ::oDbf:cSufTur .and. !::oFacCliT:eof()

         nDouDiv     := nDouDiv( ::oFacCliT:cDivFac, ::oDbfDiv:cAlias )
         nRouDiv     := nRouDiv( ::oFacCliT:cDivFac, ::oDbfDiv:cAlias )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac + ::oDbfDet:cCodArt )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac + ::oDbfDet:cCodArt == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac + ::oFacCliL:cRef .and. !::oFacCliL:eof()

               nTotCon  -= nTotLFacCli( ::oFacCliL:cAlias, nDouDiv, nRouDiv, nil, .t., .f., .f. )

               ::oFacCliL:Skip()

            end while

         end if

         ::oFacCliT:Skip()

      end while

   end if

   ::oFacCliL:ordSetFocus( cOrdAnt )

   /*
   Salida por importe
   ----------------------------------------------------------------------------
   */

   if nTotCon == 0
      Return ( ::aSimula )
   end if

   /*
   Calculos y redondeos
   ----------------------------------------------------------------------------
   */

   nImpDet           := Round( nTotCon / ( ( ::oDbfDet:nIvaArt / 100 ) + 1 ), ::nDorDiv )
   nImpIvm           := Round( ::oDbfDet:nValImp * ( ::oDbfDet:nCanAct - ::oDbfDet:nCanAnt ), ::nDorDiv )
   nIvaDet           := nTotCon - nImpDet - nImpIvm

   /*
   Cuenta de venta
   ----------------------------------------------------------------------------
   */

   if empty( cCtaVen )
      cCtaVen        := cCtaCli() + RetGrpVta( ::oDbfDet:cCodArt, cRutCnt, ::cGetEmpresaContaplus, ::oArticulo:cAlias )
   end if

   /*
   Realizamos el apunte al cliente
   ----------------------------------------------------------------------------
   */

   if nTotCon != 0

      nPos           := aScan( aCli, {|x| x[ 1 ] + x[ 2 ] + x[ 3 ] == ::cGetEmpresaContaplus + ::cGetProjectoContaplus + cCtaCli } )
      if nPos == 0
         aAdd( aCli, { ::cGetEmpresaContaplus, ::cGetProjectoContaplus, cCtaCli, nTotCon } )
      else
         aCli[ nPos, 4 ] += nTotCon
      end if

   end if

   /*
   Realizamos el apunte de la venta
   ----------------------------------------------------------------------------
   */

   if nImpDet != 0

      if !::lChkSimula .AND. !ChkSubcuenta( cRutCnt, ::cGetEmpresaContaplus, cCtaVen, , .f. )
         ::oTreeSelect:Add( "Contadores : " + ::oDbf:cNumTur + "subcuenta de venta " + RTrim( cCtaVen ) + " no encontada, en empresa" + ::cGetEmpresaContaplus, 0 )
         return .f.
      end if

      nPos           := aScan( aVta, {|x| x[ 1 ] + x[ 2 ] + x[ 3 ] == ::cGetEmpresaContaplus + ::cGetProjectoContaplus + cCtaVen } )
      if nPos == 0
         aAdd( aVta, { ::cGetEmpresaContaplus, ::cGetProjectoContaplus, cCtaVen, nImpDet } )
      else
         aVta[ nPos, 4 ] += nImpDet
      end if

   end if

   /*
   Construimos el apunte del IVM
   ----------------------------------------------------------------------------
   */

   if nImpIvm != 0

      if !::lChkSimula .AND. !ChkSubcuenta( cRutCnt, ::cGetEmpresaContaplus, cCtaIvm, , .f. )
         ::oTreeSelect:Add( "Contadores : " + ::oDbf:cNumTur + " subcuenta de impuestos especiales " + RTrim( cCtaIvm ) + " no encontada, en empresa" + ::cGetEmpresaContaplus, 0 )
         return .f.
      end if

      nPos           := aScan( aIvm, {|x| x[ 1 ] + x[ 2 ] + x[ 3 ] == ::cGetEmpresaContaplus + ::cGetProjectoContaplus + cCtaIvm } )
      if nPos == 0
         aAdd( aIvm, { ::cGetEmpresaContaplus, ::cGetProjectoContaplus, cCtaIvm, nImpIvm } )
      else
         aIvm[ nPos, 4 ] += nImpIvm
      end if

   end if

   /*
   Construimos las bases de los impuestosS
   ----------------------------------------------------------------------------
   */

   cCtaIva           := cSubCuentaIva( ::oDbfDet:nIvaArt, .f., cRutCnt, ::cGetEmpresaContaplus, ::oIvaImp )

   if nIvaDet != 0

      if !::lChkSimula .AND. !ChkSubcuenta( cRutCnt, ::cGetEmpresaContaplus, cCtaIva, , .f. )
         ::oTreeSelect:Add( "Contadores : " + ::oDbf:cNumTur + "subcuenta de " + cImp() + " " + RTrim( cCtaIva ) + " no encontada, en empresa" + ::cGetEmpresaContaplus, 0 )
         return .f.
      end if

      nPos  := aScan( aIva, {|x| x[ 1 ] + x[ 2 ] + x[ 3 ] == ::cGetEmpresaContaplus + ::cGetProjectoContaplus + cCtaIva } )
      if nPos == 0
         aAdd( aIva, { ::cGetEmpresaContaplus, ::cGetProjectoContaplus, cCtaIva, nImpDet, nIvaDet, ::oDbfDet:nIvaArt } )
      else
         aIva[ nPos, 4 ] += nImpDet
         aIva[ nPos, 5 ] += nIvaDet
         aIva[ nPos, 6 ] := ::oDbfDet:nIvaArt
      end if

   end if

   /*
   Pagos de los contadores-----------------------------------------------------
   */

   if !::lChkSimula .AND. !ChkSubcuenta( cRutCnt, ::cGetEmpresaContaplus, cCtaPgo, , .f. )
      ::oTreeSelect:Add( "Contadores : " + ::oDbf:cNumTur + " subcuenta de pago " + RTrim( cCtaPgo ) + " no encontada, en empresa" + ::cGetEmpresaContaplus, 0 )
      return .f.
   end if

   nPos  := aScan( aPgo, {|x| x[ 1 ] + x[ 2 ] + x[ 3 ] + x[ 4 ] == ::cGetEmpresaContaplus + ::cGetProjectoContaplus + cCtaPgo + cCtaCli } )
   if nPos == 0
      aAdd( aPgo, { ::cGetEmpresaContaplus, ::cGetProjectoContaplus, cCtaPgo, cCtaCli, nTotCon } )
   else
      aPgo[ nPos, 5 ] += nTotCon
   end if

   /*
   Apunte de contabilidad------------------------------------------------------
   */

   for m := 1 to len( aCli )

      aadd( ::aSimula, MkAsiento(   ::nAsiento, ;
                                    cCodDiv,;
                                    dFecha,;
                                    aCli[ m, 3 ],;
                                    ,;
                                    aCli[ m, 4 ],;
                                    cDesAsi,;
                                    ,;
                                    Val( ::oDbf:cNumTur ),;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ::cGetProjectoContaplus,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ::lChkSimula,;
                                    cTerNif,;
                                    cTerNom ) )

   next

   /*
   Asientos de venta--------------------------------------------------------
   */

   for m := 1 to len( aVta )

      aadd( ::aSimula, MkAsiento(   ::nAsiento, ;
                                    cCodDiv,;
                                    dFecha,;
                                    aVta[ m, 3 ],;
                                    ,;
                                    ,;
                                    cDesAsi,;
                                    aVta[ m, 4 ],;
                                    Val( ::oDbf:cNumTur ),;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ::cGetProjectoContaplus,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ::lChkSimula,;
                                    cTerNif,;
                                    cTerNom ) )

   next

   /*
   Asientos de IVM----------------------------------------------------------
   */

   for m := 1 to len( aIvm )

      aadd( ::aSimula, MkAsiento(   ::nAsiento, ;
                                    cCodDiv,;
                                    dFecha,;
                                    aIvm[ m, 3 ],;
                                    ,;
                                    ,;
                                    cDesAsi,;
                                    aIvm[ m, 4 ],;
                                    Val( ::oDbf:cNumTur ),;
                                    ,;    // Base Imponible
                                    ,;
                                    ,;
                                    ,;
                                    ::cGetProjectoContaplus,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ::lChkSimula,;
                                    cTerNif,;
                                    cTerNom ) )

   next

   /*
   Asientos de impuestos----------------------------------------------------------
   */

   for m := 1 to len( aIva )

      aadd( ::aSimula, MkAsiento(   ::nAsiento, ;
                                    cCodDiv,;
                                    dFecha,;
                                    aIva[ m, 3 ],;
                                    cCtaCli,;
                                    ,;
                                    cDesAsi,;
                                    aIva[ m, 5 ],;
                                    Val( ::oDbf:cNumTur ),;
                                    aIva[ m, 4 ],;    // Base Imponible
                                    aIva[ m, 6 ],;    // impuestos
                                    ,;
                                    ,;
                                    ::cGetProjectoContaplus,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ::lChkSimula,;
                                    cTerNif,;
                                    cTerNom ) )

   next

   /*
   Asiento de pagos---------------------------------------------------------
   */

   for m := 1 to len( aPgo )

      aadd( ::aSimula, MkAsiento(   ::nAsiento, ;
                                    cCodDiv,;
                                    dFecha,;
                                    aPgo[ m, 3 ],;
                                    ,;
                                    aPgo[ m, 5 ],;
                                    cPgoAsi,;
                                    ,;
                                    ::oDbf:cNumTur,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ::cGetProjectoContaplus,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ::lChkSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      aadd( ::aSimula, MkAsiento(   ::nAsiento, ;
                                    cCodDiv,;
                                    dFecha,;
                                    aPgo[ m, 4 ],;
                                    ,;
                                    ,;
                                    cPgoAsi,;
                                    aPgo[ m, 5 ],;
                                    ::oDbf:cNumTur,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ::cGetProjectoContaplus,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ::lChkSimula,;
                                    cTerNif,;
                                    cTerNom ) )

   next

RETURN ( ::aSimula )

//---------------------------------------------------------------------------//

METHOD Asiento()

   local n
   local nLen
   local cSubCta     := ""
   local lErrors     := .f.

   if empty( ::aSimula )
      Return .f.
   end if

   nLen              := len( ::aSimula )

   /*
   Chequeamos las subcuentas
   ----------------------------------------------------------------------------
   */

   for n := 1 to nLen

      if ( dbfDiario() )->( FieldPos( "SubCta" ) ) != 0 .and. ( dbfDiario() )->( FieldPos( "SubCta" ) ) <= len( ::aSimula[ n ] )

         cSubCta     := ::aSimula[ n, ( dbfDiario() )->( FieldPos( "SubCta" ) ) ]

         if !( DbfSubcuenta() )->( dbSeek( cSubCta ) )
            ::oTreeSelect:Add( "Sesión : " + Alltrim( ::oDbf:cNumTur ) + "/" + Rtrim( ::oDbf:cSufTur ) + " subcuenta " + Rtrim( cSubCta ) + " no encontrada, en empresa" + ::cGetEmpresaContaplus, 0 )
            lErrors  := .t.
         end if

      else

            lErrors  := .t.

      end if

   next

   if lErrors
      Return .f.
   end if

   /*
   Contabilización de las lineas del apunte
   ----------------------------------------------------------------------------
   */

   ::oMtrSelect:SetTotal( nLen )

   for n := 1 to nLen

      ::oMtrSelect:Set( n )

      WriteAsiento( ::aSimula[ n ] )

      SysRefresh()

   next

   /*
   Contabilizar turno
   ----------------------------------------------------------------------------
   */

   ::oDbf:FieldPutByName( "lConTur", .t. )

   /*
   Contabilizar tickets
   ----------------------------------------------------------------------------
   */

   if ::oTikT:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

      while ::oTikT:cTurTik + ::oTikT:cSufTik == ::oDbf:cNumTur + ::oDbf:cSufTur .and. !::oDbf:eof()

         ::oTikT:FieldPutByName( "lConTik", .t. )

         ::oTikT:Skip()

      end while

   end if

   /*
   Contabilizar facturas
   ----------------------------------------------------------------------------
   */

   if ::oFacCliT:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

      while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac == ::oDbf:cNumTur + ::oDbf:cSufTur .and. !::oFacCliT:eof()

         ::oFacCliT:FieldPutByName( "lContab", .t. )

         ::oFacCliT:Skip()

      end while

   end if

   /*
   Información por pantalla
   -------------------------------------------------------------------------
   */

   ::oTreeSelect:Add( "Sesión : " + Alltrim( ::oDbf:cNumTur ) + "/" + Rtrim( ::oDbf:cSufTur ) + " asiento generado num. " + Ltrim( Str( ::nAsiento ) ), 1 )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CambiaEstado()

   ::oDbf:FieldPutByName( "lConTur", ::lChkSimula )

   /*
   Contabilizar tickets
   ----------------------------------------------------------------------------
   */

   if ::oTikT:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

      while ::oTikT:cTurTik + ::oTikT:cSufTik == ::oDbf:cNumTur + ::oDbf:cSufTur .and. !::oDbf:eof()

         ::oTikT:Load()
         ::oTikT:lConTik      := ::lChkSimula
         ::oTikT:Save()

         ::oTikT:Skip()

      end while

   end if

   /*
   Contabilizar facturas
   ----------------------------------------------------------------------------
   */

   if ::oFacCliT:Seek( ::oDbf:cNumTur + ::oDbf:cSufTur )

      while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac == ::oDbf:cNumTur + ::oDbf:cSufTur .and. !::oFacCliT:eof()

         ::oFacCliT:Load()
         ::oFacCliT:lContab   := ::lChkSimula
         ::oFacCliT:Save()

         ::oFacCliT:Skip()

      end while

   end if

   ::oWndBrw:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lSelectTurno( lSel )

   DEFAULT lSel         := ::lChkSimula

   if ( ::oDbf:nStaTur == cajCerrrada )

      ::oDbf:FieldPutByName( "lSndTur", lSel )

      ::MarkTurno( lSel )

      if !empty( ::oTreeSelect )
         ::oTreeSelect:Select( ::oTreeSelect:Add( "Sesión : " + ::oDbf:cNumTur + "/" + ::oDbf:cSufTur + " procesada.", 1 ) )
      end if

   end if

return ( Self )

//--------------------------------------------------------------------------//

METHOD lSelectAll( lSel )

   CursorWait()

   if !empty( ::oWndBrw )
      ::oWndBrw:Disable()
   end if

   ::oDbf:GetStatus()

   ::oDbf:GoTop()
   while !::oDbf:eof()
      ::lSelectTurno( lSel )
      ::oDbf:Skip()
   end while

   ::oDbf:SetStatus()

   if !empty( ::oWndBrw )
      ::oWndBrw:Enable()
      ::oWndBrw:Refresh()
   end if

   CursorWE()

return ( Self )

//--------------------------------------------------------------------------//

METHOD EdtLine( oLbx )

   local uVar1    := ::oDbfDet:nCanAnt
   local uVar2    := ::oDbfDet:nCanAct
   local uVar3    := ::oDbfDet:nPvpArt
   local bValid   := { || .t. }

   if !::oDbfDet:eof()

      if oLbx:lEditCol( 3, @uVar1, ::cPicUnd, bValid )

         if uVar1 >= 0

            ::oDbfDet:FieldPutByName( "nCanAnt", uVar1 )

            if oLbx:lEditCol( 4, @uVar2, ::cPicUnd, bValid )

               if uVar2 >= 0

                  ::oDbfDet:FieldPutByName( "nCanAct", uVar2 )

                  if oLbx:lEditCol( 6, @uVar3, ::cPouDiv, bValid )

                     if uVar3 > 0

                        ::oDbfDet:FieldPutByName( "nPvpArt", uVar3 )

                     end if

                  end if

               end if

            end if

         end if

      end if

      oLbx:Refresh()

   end if

RETURN NIL

//--------------------------------------------------------------------------//

METHOD RellenaIva()

   while !::oDbfDet:eof()

      if ::oArticulo:Seek( ::oDbfDet:cCodArt )
         ::oDbfDet:FieldPutByName( "nIvaArt", nIva( ::oIvaImp:cAlias, ::oArticulo:TipoIva ) )
      end if

      ::oDbfDet:Skip()

      SysRefresh()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//
//
// Comprueba si hay trunos abiertos
//

METHOD lNowOpen()

   ::GetCurrentTurno()

   if !::lOpenCaja() .and. !::DialogCreateTurno()
      MsgStop( "Es necesario iniciar una sesión para trabajar." ) 
   end if

   if oMsgSesion() != nil
      oMsgSesion():SetText( "Sesión : " + Transform( ::cNumeroCurrentTurno(), "######" ) )
   end if

   if ::oWndBrw != nil
      ::oWndBrw:Refresh()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SyncAllDbf()

   if empty( ::oDbf ) .or. empty( ::oDbfCaj ) .or. empty( ::oDbfDet )
      ::DefineFiles()
   end if

   lCheckDbf( ::oDbf    )

   ::oDbf:Activate( .f., .f. )
   while !::oDbf:Eof()

      if empty( ::oDbf:cSufTur )
         ::oDbf:FieldPutByName( "cSufTur", "00" )
      end if 
   
      if empty( ::oDbf:cCodCaj )
         ::oDbf:FieldPutByName( "cCodCaj", "000" )
      end if 
   
      ::oDbf:Skip()
   
   end while
   ::oDbf:End()

   lCheckDbf( ::oDbfCaj )

   ::oDbfCaj:Activate( .f., .f. )
   while !::oDbfCaj:Eof()

      if empty( ::oDbfCaj:cSufTur )
         ::oDbfCaj:FieldPutByName( "cSufTur", "00" )
      end if 

      ::oDbfCaj:Skip()

   end while
   ::oDbfCaj:End()

   lCheckDbf( ::oDbfDet )

   ::oDbfDet:Activate( .f., .f. )
   while !::oDbfDet:Eof()
      if empty( ::oDbfDet:cSufTur )
         ::oDbfDet:FieldPutByName( "cSufTur", "00" )
      end if 
      ::oDbfDet:Skip()
   end while
   ::oDbfDet:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActTactil()

   ::oTikT:GetStatus( .t. )

   if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

      do case
         case ::oTikT:cTipTik == SAVTIK

            while ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik == ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil .and. !::oTikL:Eof()

               AddImpTactil( nTotNTpv( ::oTikL:cAlias ), ::oTikL:cCbaTil, ::oArticulo )
               AddImpTactil( nTotNTpv( ::oTikL:cAlias ), ::oTikL:cComTil, ::oArticulo )

               ::oTikL:Skip()

               SysRefresh()

            end while

         case ::oTikT:cTipTik == SAVDEV

            while ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik == ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil .and. !::oTikL:Eof()

               AddImpTactil( - nTotNTpv( ::oTikL:cAlias ), ::oTikL:cCbaTil, ::oArticulo )
               AddImpTactil( - nTotNTpv( ::oTikL:cAlias ), ::oTikL:cComTil, ::oArticulo )

               ::oTikL:Skip()

               SysRefresh()

            end while

      end case

   end if

   ::oTikT:SetStatus()

RETURN NIL

//-------------------------------------------------------------------------//

METHOD CreateData()

   local lSnd        := .f.
   local oTurno
   local oTurnoTmp
   local cFileName   := "Tur" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

   oTurno            := TTurno():Create( cPatEmp(), cDriver() )
   oTurno:OpenService()

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   oTurnoTmp         := TTurno():Create( cPatSnd(), cLocalDriver() )
   oTurnoTmp:OpenService( .t. )

   /*
   Traspaso de turnos----------------------------------------------------------
   */

   ::oSender:SetText( "Enviando sesiones" )

   oTurno:oDbf:GoTop()
   while !oTurno:oDbf:eof()
      
      if oTurno:oDbf:lSndTur
      
         lSnd  := .t.
      
         dbPass( oTurno:oDbf:cAlias, oTurnoTmp:oDbf:cAlias, .t. )

         ::oSender:SetText( oTurno:oDbf:cNumTur + "; " + Dtoc( oTurno:oDbf:dOpnTur ) + "; " + oTurno:oDbf:cHorOpn + "; " + Dtoc( oTurno:oDbf:dCloTur ) + "; " + oTurno:oDbf:cHorClo + "; " + oTurno:oDbf:cCajTur )

         if oTurno:oDbfDet:Seek( oTurno:oDbf:cNumTur + oTurno:oDbf:cSufTur )
            while oTurno:oDbfDet:cNumTur + oTurno:oDbfDet:cSufTur == oTurno:oDbf:cNumTur + oTurno:oDbf:cSufTur
               dbPass( oTurno:oDbfDet:cAlias, oTurnoTmp:oDbfDet:cAlias, .t. )
               oTurno:oDbfDet:Skip()
               SysRefresh()
            end while
         end if

         if oTurno:oDbfCaj:Seek( oTurno:oDbf:cNumTur + oTurno:oDbf:cSufTur )
            while oTurno:oDbfCaj:cNumTur + oTurno:oDbfCaj:cSufTur == oTurno:oDbf:cNumTur + oTurno:oDbf:cSufTur
               dbPass( oTurno:oDbfCaj:cAlias, oTurnoTmp:oDbfCaj:cAlias, .t. )
               oTurno:oDbfCaj:Skip()
               SysRefresh()
            end while
         end if

      end if
      
      oTurno:oDbf:Skip()
      
      SysRefresh()
   
   end while

   /*
   Cerrar ficheros temporales--------------------------------------------------
   */

   oTurno:CloseService()
   oTurno:End()

   oTurnoTmp:CloseService()
   oTurnoTmp:End()

   if lSnd

      /*
      Comprimir los archivos---------------------------------------------------
      */

      ::oSender:SetText( "Comprimiendo sesiones" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay sesiones para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD RestoreData()

   ::cPath     := cPatEmp()

   if ::OpenService()

      while !::oDbf:eof()

         if ::oDbf:lSndTur
            ::oDbf:FieldPutByName( "lSndTur", .f. )
         end if

         ::oDbf:Skip()

      end while

      ::CloseService()

   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD SendData()

   local cFileName         := "Tur" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

   if file( cPatOut() + cFileName )

      if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
         ::lSuccesfullSend := .t.
         ::IncNumberToSend()
         ::oSender:SetText( "Fichero enviado" )
      else
         ::oSender:SetText( "ERROR fichero no enviado" )
      end if

   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD ReciveData()

   local n
   local aExt        := aRetDlgEmp()

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo sesiones" )

   for n := 1 to len( aExt )
      ::oSender:GetFiles( "Tur*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Sesiones recibidas" )

Return Self

//----------------------------------------------------------------------------//

METHOD Process()

   local m
   local oBlock
   local oError
   local oTurno
   local oTurnoTmp
   local aFiles      := Directory( cPatIn() )

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      /*
      descomprimimos el fichero
      */

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         /*
         Ficheros temporales
         */

         if file( cPatSnd() + "Turno.Dbf" )

            oTurnoTmp   := TTurno():Create( cPatSnd(), cLocalDriver() )
            oTurnoTmp:OpenService( .f. )

            oTurno      := TTurno():Create( cPatEmp(), cDriver() )
            oTurno:OpenService()

            /*
            Trasbase de turnos-------------------------------------------------------
            */

            oTurnoTmp:oDbf:GoTop()
            while !oTurnoTmp:oDbf:eof()

               if oTurno:oDbf:Seek( oTurnoTmp:oDbf:cNumTur + oTurnoTmp:oDbf:cSufTur )
                  dbPass( oTurnoTmp:oDbf:cAlias, oTurno:oDbf:cAlias, .f. )
                  ::oSender:SetText( "Reemplazado : " + oTurno:oDbf:cNumTur + "; " + Dtoc( oTurno:oDbf:dOpnTur ) + "; " + oTurno:oDbf:cHorOpn + "; " + Dtoc( oTurno:oDbf:dCloTur ) + "; " + oTurno:oDbf:cHorClo + "; " + oTurno:oDbf:cCajTur )
               else
                  dbPass( oTurnoTmp:oDbf:cAlias, oTurno:oDbf:cAlias, .t. )
                  ::oSender:SetText( "Añadido     : " + oTurno:oDbf:cNumTur + "; " + Dtoc( oTurno:oDbf:dOpnTur ) + "; " + oTurno:oDbf:cHorOpn + "; " + Dtoc( oTurno:oDbf:dCloTur ) + "; " + oTurno:oDbf:cHorClo + "; " + oTurno:oDbf:cCajTur )
               end if

               /*
               Vaciamos las lineas de contadores
               */

               while oTurno:oDbfDet:Seek( oTurnoTmp:oDbf:cNumTur + oTurnoTmp:oDbf:cSufTur )
                  oTurno:oDbfDet:Delete(.f.)
                  SysRefresh()
               end while

               /*
               Trasbase de lineas de turnos---------------------------------------------
               */

               if oTurnoTmp:oDbfDet:Seek( oTurnoTmp:oDbf:cNumTur + oTurnoTmp:oDbf:cSufTur )
                  while oTurnoTmp:oDbfDet:cNumTur + oTurnoTmp:oDbf:cSufTur == oTurnoTmp:oDbf:cNumTur + oTurnoTmp:oDbf:cSufTur .and. !oTurno:oDbfDet:eof()
                     dbPass( oTurnoTmp:oDbfDet:cAlias, oTurno:oDbfDet:cAlias, .t. )
                     oTurnoTmp:oDbfDet:Skip()
                     SysRefresh()
                  end while
               end if

               /*
               Vaciamos las lineas de contadores-------------------------------
               */

               while oTurno:oDbfCaj:Seek( oTurnoTmp:oDbf:cNumTur + oTurnoTmp:oDbf:cSufTur )
                  oTurno:oDbfCaj:Delete(.f.)
                  SysRefresh()
               end while

               /*
               Trasbase de lineas de turnos---------------------------------------------
               */

               if oTurnoTmp:oDbfCaj:Seek( oTurnoTmp:oDbf:cNumTur + oTurnoTmp:oDbf:cSufTur )
                  while oTurnoTmp:oDbfCaj:cNumTur + oTurnoTmp:oDbf:cSufTur == oTurnoTmp:oDbf:cNumTur + oTurnoTmp:oDbf:cSufTur .and. !oTurno:oDbfCaj:eof()
                     dbPass( oTurnoTmp:oDbfCaj:cAlias, oTurno:oDbfCaj:cAlias, .t. )
                     oTurnoTmp:oDbfCaj:Skip()
                     SysRefresh()
                  end while
               end if

               /*
               Siguiente linea
               */

               oTurnoTmp:oDbf:Skip()
               SysRefresh()

            end while

            /*
            Finalizando--------------------------------------------------------------
            */

            oTurno:CloseService()
            oTurno:End()

            oTurnoTmp:CloseService()
            oTurnoTmp:End()

         end if

      end if

      ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

      RECOVER USING oError

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//----------------------------------------------------------------------------//

METHOD Save()

   WritePProString( "Envio",     ::cText, cValToChar( ::lSelectSend ), ::cIniFile )
   WritePProString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Load()

   ::lSelectSend     := ( Upper( GetPvProfString( "Envio",     ::cText, cValToChar( ::lSelectSend ),   ::cIniFile ) ) == ".T." )
   ::lSelectRecive   := ( Upper( GetPvProfString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile ) ) == ".T." )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD nGetNumberToSend()

   ::nNumberSend     := GetPvProfInt( "Numero", ::cText, ::nNumberSend, ::cIniFile )

Return ( ::nNumberSend )

//----------------------------------------------------------------------------//

METHOD CheckFiles( cFileAppendFrom )

   if ::OpenService()
      ::CloseService()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PrintReport( cTurno, cCaja, nDevice, nCopies, cPrinter, dbfDoc )

   DEFAULT cTurno       := ::cCurTurno
   DEFAULT cCaja        := ::cCurCaja
   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()

   if !empty( ::oTxt )
      ::oTxt:SetText( "Imprimiendo informe" )
   end if

   SysRefresh()

   /*
   Guarda las tablas-----------------------------------------------------------
   */

   ::oDbf:GetRecno()
   ::oDbfCaj:GetRecno()
   ::oDbfDet:GetRecno()

   if !empty( cCaja )
      ::oDbfCaj:Seek( cCaja )
   end if 

   /*
   Creamos el documento--------------------------------------------------------
   */

   if empty( ::oFastReport )
      ::oFastReport              := frReportManager():New()
      ::oFastReport:LoadLangRes( "Spanish.Xml" )
      ::lDestroyFastreport       := .t.
   end if

   ::oFastReport:SetIcon( 1 )

   ::oFastReport:SetTitle(       "Diseñador de documentos" )

   /*
   Manejador de eventos--------------------------------------------------------
   */

   ::oFastReport:SetEventHandler( "Designer", "OnSaveReport", {|| ::oFastReport:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos---------------------------------------------------------------
   */

   ::DataReport( cTurno, cCaja, ::oFastReport )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !empty( ( dbfDoc )->mReport )

      ::oFastReport:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Zona de variables--------------------------------------------------------
      */

      ::VariableReport( ::oFastReport )

      /*

      Preparar el report-------------------------------------------------------
      */

      ::oFastReport:PrepareReport()

      /*
      Imprimir el informe------------------------------------------------------
      */

      do case
         case ( Valtype( nDevice ) == "N" .and. nDevice == IS_SCREEN ) .or. ( Valtype( nDevice ) == "C" .and. nDevice == "Visualizar" )
            ::oFastReport:ShowPreparedReport()

         case ( Valtype( nDevice ) == "N" .and. nDevice == IS_PRINTER ) .or. ( Valtype( nDevice ) == "C" .and. nDevice == "Imprimir" )
            ::oFastReport:PrintOptions:SetPrinter( cPrinter )
            ::oFastReport:PrintOptions:SetCopies( nCopies )
            ::oFastReport:PrintOptions:SetShowDialog( .f. )
            ::oFastReport:Print()

         case ( Valtype( nDevice ) == "N" .and. nDevice == IS_PDF ) .or. ( Valtype( nDevice ) == "C" .and. nDevice == "Adobe PDF" )
            ::oFastReport:PrintOptions:SetShowDialog( .f. )
            ::oFastReport:SetProperty( "PDFExport", "ShowDialog",  ::lPdfShowDialog )
            ::oFastReport:SetProperty( "PDFExport", "DefaultPath", ::cPdfDefaultPath )
            ::oFastReport:SetProperty( "PDFExport", "FileName",    ::cPdfFileName )
            ::oFastReport:DoExport( "PDFExport" )

         case ( Valtype( nDevice ) == "N" .and. nDevice == IS_HTML ) .or. ( Valtype( nDevice ) == "C" .and. nDevice == "HTML" )
            ::oFastReport:SetProperty( "HTMLExport", "ShowDialog", ::lPdfShowDialog )
            ::oFastReport:SetProperty( "HTMLExport", "DefaultPath",::cPdfDefaultPath )
            ::oFastReport:SetProperty( "HTMLExport", "FileName",   ::cHtmlFileName )
            ::oFastReport:DoExport( "HTMLExport" )

         case ( Valtype( nDevice ) == "N" .and. nDevice == IS_EXCEL ) .or. ( Valtype( nDevice ) == "C" .and. nDevice == "Excel" )
            ::oFastReport:SetProperty( "XLSExport", "FileName", "ArqueoCaja" + Alltrim( ::cCurTurno ) + ".xls" )
            ::oFastReport:DoExport( "XLSExport" )

      end case

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   if ::lDestroyFastReport
      ::oFastReport:DestroyFr()
      ::oFastReport  := nil
   end if

   /*
   Reposiciona las tablas------------------------------------------------------
   */

   ::oDbf:SetRecno()
   ::oDbfCaj:SetRecno()
   ::oDbfDet:SetRecno()

Return .t.

//---------------------------------------------------------------------------//

METHOD DataReport( cTurno, cCaja, oFastReport )

   DEFAULT cTurno       := ::cCurTurno
   DEFAULT cCaja        := ::cCurCaja

   /*
   Zona de datos------------------------------------------------------------
   */

   oFastReport:ClearDataSets()

   oFastReport:SetWorkArea(     "Sesión", ::oDbf:nArea, .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFastReport:SetFieldAliases( "Sesión", cObjectsToReport( ::oDbf ) )

   oFastReport:SetWorkArea(     "Cajas", ::oDbfCaj:nArea )
   oFastReport:SetFieldAliases( "Cajas", cObjectsToReport( ::oDbfCaj ) )
 
   oFastReport:SetWorkArea(     "Contadores", ::oDbfDet:nArea )
   oFastReport:SetFieldAliases( "Contadores", cObjectsToReport( ::oDbfDet ) )

   oFastReport:SetWorkArea(     "Lineas de informes", ::oDbfTemporal:nArea )
   oFastReport:SetFieldAliases( "Lineas de informes", cObjectsToReport( ::oDbfTemporal ) )

   oFastReport:SetWorkArea(     "Usuarios", ::oDbfUsr:nArea )
   oFastReport:SetFieldAliases( "Usuarios", cItemsToReport( aItmUsuario() ) )

   oFastReport:SetWorkArea(     "Empresa", ::oDbfEmp:nArea )
   oFastReport:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFastReport:SetMasterDetail( "Sesión",   "Cajas",                {|| cTurno + cCaja } )
   oFastReport:SetMasterDetail( "Sesión",   "Contadores",           {|| cTurno + cCaja } )
   oFastReport:SetMasterDetail( "Sesión",   "Usuarios",             {|| ::oDbfCaj:cCajTur } )
   oFastReport:SetMasterDetail( "Sesión",   "Empresa",              {|| cCodigoEmpresaEnUso() } )

   oFastReport:SetResyncPair(   "Sesión",   "Cajas" )
   oFastReport:SetResyncPair(   "Sesión",   "Contadores" )
   oFastReport:SetResyncPair(   "Sesión",   "Usuarios" )
   oFastReport:SetResyncPair(   "Sesión",   "Empresa" )

Return nil

//---------------------------------------------------------------------------//

METHOD VariableReport( oFastReport )

   oFastReport:DeleteCategory(  "Compras sesión" )
   oFastReport:DeleteCategory(  "Ventas sesión" )
   oFastReport:DeleteCategory(  "Entradas y salidas sesión" )
   oFastReport:DeleteCategory(  "Cobros sesión" )
   oFastReport:DeleteCategory(  "Pagos sesión" )
   oFastReport:DeleteCategory(  "Diferencias sesión" )
   oFastReport:DeleteCategory(  "Saldo sesión" )
   oFastReport:DeleteCategory(  "Cajas sesión" )
   oFastReport:DeleteCategory(  "Numeros sesión" )
   oFastReport:DeleteCategory(  "Monedas en caja" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFastReport:AddVariable(     "Compras sesión",   "Total alabranes de proveedores",                "GetHbVar('nTotAlbPrvCompras')"     )
   oFastReport:AddVariable(     "Compras sesión",   "Total facturas de proveedores",                 "GetHbVar('nTotFacPrvCompras')"     )
   oFastReport:AddVariable(     "Compras sesión",   "Total facturas rectificativas de proveedores",  "GetHbVar('nTotRctPrvCompras')"     )
   oFastReport:AddVariable(     "Compras sesión",   "Total compras",                                 "GetHbVar('nTotCompras')"           )

   oFastReport:AddVariable(     "Ventas sesión",   "Total contadores en albaranes de clientes",      "GetHbVar('nTotAlbCliContadores')"  )
   oFastReport:AddVariable(     "Ventas sesión",   "Total albaranes de clientes",                    "GetHbVar('nTotAlbCliVentas')"      )
   oFastReport:AddVariable(     "Ventas sesión",   "Total contadores en facturas de clientes",       "GetHbVar('nTotFacCliContadores')"  )
   oFastReport:AddVariable(     "Ventas sesión",   "Total facturas de clientes",                     "GetHbVar('nTotFacCliVentas')"      )
   oFastReport:AddVariable(     "Ventas sesión",   "Total facturas rectificativas de clientes",      "GetHbVar('nTotRctCliVentas')"      )
   oFastReport:AddVariable(     "Ventas sesión",   "Total contadores en tickets de clientes",        "GetHbVar('nTotTikCliContadores')"  )
   oFastReport:AddVariable(     "Ventas sesión",   "Total tickets de clientes",                      "GetHbVar('nTotTikCliVentas')"      )
   oFastReport:AddVariable(     "Ventas sesión",   "Total contadores en cheques regalo de clientes", "GetHbVar('nTotTikCliContadores')"  )
   oFastReport:AddVariable(     "Ventas sesión",   "Total cheques regalo de clientes",               "GetHbVar('nTotChkCliVentas')"      )
   oFastReport:AddVariable(     "Ventas sesión",   "Total contadores en devoluciones de clientes",   "GetHbVar('nTotDevCliContadores')"  )
   oFastReport:AddVariable(     "Ventas sesión",   "Total devoluciones de clientes",                 "GetHbVar('nTotDevCliVentas')"      )
   oFastReport:AddVariable(     "Ventas sesión",   "Total contadores en vales de clientes",          "GetHbVar('nTotValCliContadores')"  )
   oFastReport:AddVariable(     "Ventas sesión",   "Total vales de clientes",                        "GetHbVar('nTotValCliVentas')"      )
   oFastReport:AddVariable(     "Ventas sesión",   "Total liquidado en vales de clientes",           "GetHbVar('nTotValCliLiquidados')"  )
   oFastReport:AddVariable(     "Ventas sesión",   "Total anticipos de clientes",                    "GetHbVar('nTotAntCliVentas')"      )
   oFastReport:AddVariable(     "Ventas sesión",   "Total liquidado en anticipos de clientes",       "GetHbVar('nTotAntCliLiquidados')"  )
   oFastReport:AddVariable(     "Ventas sesión",   "Total contadores",                               "GetHbVar('nTotContadores')"        )
   oFastReport:AddVariable(     "Ventas sesión",   "Total ventas",                                   "GetHbVar('nTotVentas')"            )
   oFastReport:AddVariable(     "Ventas sesión",   "Total venta de credito",                         "GetHbVar('nTotVentaCredito')"      )
   oFastReport:AddVariable(     "Ventas sesión",   "Total venta contado",                            "GetHbVar('nTotVentaContado')"      )
   oFastReport:AddVariable(     "Ventas sesión",   "Total ventas sesión",                            "GetHbVar('nTotVentaSesion')"       )

   oFastReport:AddVariable(     "Ventas sesión",   "Importe de ticket medio",                        "GetHbVar('nTicketMedio')"          )

   oFastReport:AddVariable(     "Entradas y salidas sesión", "Total entradas y salidas",             "GetHbVar('nTotEntradas')"          )

   oFastReport:AddVariable(     "Cobros sesión",   "Total entregas en pedido de clientes",           "GetHbVar('nTotPedCliEntregas')"    )
   oFastReport:AddVariable(     "Cobros sesión",   "Total entregas en albaranes de clientes",        "GetHbVar('nTotAlbCliEntregas')"    )
   oFastReport:AddVariable(     "Cobros sesión",   "Total entregas a cuenta",                        "GetHbVar('nTotEntregas')"          )

   oFastReport:AddVariable(     "Cobros sesión",   "Total cobros en tickets de clientes",            "GetHbVar('nTotTikCliCobros')"      )
   oFastReport:AddVariable(     "Cobros sesión",   "Total cobros en facturas de clientes",           "GetHbVar('nTotFacCliCobros')"      )
   oFastReport:AddVariable(     "Cobros sesión",   "Total cobros en vales de clientes",              "GetHbVar('nTotValCliCobros')"      )
   oFastReport:AddVariable(     "Cobros sesión",   "Total cobros en cheques regalo",                 "GetHbVar('nTotChkCliCobros')"      )
   oFastReport:AddVariable(     "Cobros sesión",   "Total cobros en efectivo",                       "GetHbVar('nTotCobroEfectivo')"     )
   oFastReport:AddVariable(     "Cobros sesión",   "Total cobros no efectivo",                       "GetHbVar('nTotCobroNoEfectivo')"   )
   oFastReport:AddVariable(     "Cobros sesión",   "Total cobros en tarjeta",                        "GetHbVar('nTotCobroTarjeta')"      )
   oFastReport:AddVariable(     "Cobros sesión",   "Total cobros en sesión",                         "GetHbVar('nTotCobroMedios')"       )

   oFastReport:AddVariable(     "Pagos sesión",   "Total pagos en facturas de proveedores",          "GetHbVar('nTotFacPrvPagos')"       )
   oFastReport:AddVariable(     "Pagos sesión",   "Total pagos en efectivo",                         "GetHbVar('nTotPagoEfectivo')"      )
   oFastReport:AddVariable(     "Pagos sesión",   "Total pagos no efectivo",                         "GetHbVar('nTotPagoNoEfectivo')"    )
   oFastReport:AddVariable(     "Pagos sesión",   "Total pagos en tarjeta",                          "GetHbVar('nTotPagoTarjeta')"       )
   oFastReport:AddVariable(     "Pagos sesión",   "Total pagos en sesion",                           "GetHbVar('nTotPagoMedios')"        )

   oFastReport:AddVariable(     "Diferencias sesión",   "Diferencias cobros",                        "GetHbVar('nDifCobros')"            )
   oFastReport:AddVariable(     "Diferencias sesión",   "Diferencias totales",                       "GetHbVar('nDifTotal')"             )

   oFastReport:AddVariable(     "Saldo sesión",     "Total saldo efectivo",                           "GetHbVar('nTotSaldoEfectivo')"    )
   oFastReport:AddVariable(     "Saldo sesión",     "Total saldo no efectivo",                        "GetHbVar('nTotSaldoNoEfectivo')"  )
   oFastReport:AddVariable(     "Saldo sesión",     "Total saldo tarjeta",                            "GetHbVar('nTotSaldoTarjeta')"     )

   oFastReport:AddVariable(     "Cajas sesión",     "Total caja efectivo",                           "GetHbVar('nTotCajaEfectivo')"      )
   oFastReport:AddVariable(     "Cajas sesión",     "Total caja tarjeta",                            "GetHbVar('nTotCajaTarjeta')"       )
   oFastReport:AddVariable(     "Cajas sesión",     "Total caja objetivo",                           "GetHbVar('nTotCajaObjetivo')"      )
   oFastReport:AddVariable(     "Cajas sesión",     "Total caja",                                    "GetHbVar('nTotCaja')"              )

   oFastReport:AddVariable(     "Numeros sesión",   "Número de albaranes en sesión",                 "GetHbVar('nTotNumeroAlbaranes')"   )
   oFastReport:AddVariable(     "Numeros sesión",   "Número de facturas en sesión",                  "GetHbVar('nTotNumeroFacturas')"    )
   oFastReport:AddVariable(     "Numeros sesión",   "Número de tickets en sesión",                   "GetHbVar('nTotNumeroTikets')"      )
   oFastReport:AddVariable(     "Numeros sesión",   "Número de vales en sesión",                     "GetHbVar('nTotNumeroVales')"       )
   oFastReport:AddVariable(     "Numeros sesión",   "Número de cheques en sesión",                   "GetHbVar('nTotNumeroCheques')"     )
   oFastReport:AddVariable(     "Numeros sesión",   "Número de devoluciones",                        "GetHbVar('nTotNumeroDevoluciones')")
   oFastReport:AddVariable(     "Numeros sesión",   "Número de aperturas de cajón",                  "GetHbVar('nTotNumeroAptCajon')"    )

   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en billetes de 500 €",                 "GetHbArrayVar('aMonedasEfe',1)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en billetes de 200 €",                 "GetHbArrayVar('aMonedasEfe',2)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en billetes de 100 €",                 "GetHbArrayVar('aMonedasEfe',3)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en billetes de 50 €",                  "GetHbArrayVar('aMonedasEfe',4)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en billetes de 20 €",                  "GetHbArrayVar('aMonedasEfe',5)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en billetes de 10 €",                  "GetHbArrayVar('aMonedasEfe',6)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en billetes de 5 €",                   "GetHbArrayVar('aMonedasEfe',7)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en monedas de 2 €",                    "GetHbArrayVar('aMonedasEfe',8)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en monedas de 1 €",                    "GetHbArrayVar('aMonedasEfe',9)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en monedas de 0.50 €",                 "GetHbArrayVar('aMonedasEfe',10)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en monedas de 0.20 €",                 "GetHbArrayVar('aMonedasEfe',11)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en monedas de 0.10 €",                 "GetHbArrayVar('aMonedasEfe',12)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en monedas de 0.05 €",                 "GetHbArrayVar('aMonedasEfe',13)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en monedas de 0.02 €",                 "GetHbArrayVar('aMonedasEfe',14)")
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en monedas de 0.01 €",                 "GetHbArrayVar('aMonedasEfe',15)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en billetes de 500 €",                 "GetHbArrayVar('aMonedasRet',1)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en billetes de 200 €",                 "GetHbArrayVar('aMonedasRet',2)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en billetes de 100 €",                 "GetHbArrayVar('aMonedasRet',3)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en billetes de 50 €",                  "GetHbArrayVar('aMonedasRet',4)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en billetes de 20 €",                  "GetHbArrayVar('aMonedasRet',5)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en billetes de 10 €",                  "GetHbArrayVar('aMonedasRet',6)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en billetes de 5 €",                   "GetHbArrayVar('aMonedasRet',7)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en monedas de 2 €",                    "GetHbArrayVar('aMonedasRet',8)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en monedas de 1 €",                    "GetHbArrayVar('aMonedasRet',9)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en monedas de 0.50 €",                 "GetHbArrayVar('aMonedasRet',10)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en monedas de 0.20 €",                 "GetHbArrayVar('aMonedasRet',11)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en monedas de 0.10 €",                 "GetHbArrayVar('aMonedasRet',12)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en monedas de 0.05 €",                 "GetHbArrayVar('aMonedasRet',13)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en monedas de 0.02 €",                 "GetHbArrayVar('aMonedasRet',14)")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en monedas de 0.01 €",                 "GetHbArrayVar('aMonedasRet',15)")
  
   oFastReport:AddVariable(     "Monedas en caja",  "Efectivo en caja",                              "GetHbVar('nEfectivoEnCaja')")
   oFastReport:AddVariable(     "Monedas en caja",  "Retirado en caja",                              "GetHbVar('nRetiradoEnCaja')")
   oFastReport:AddVariable(     "Monedas en caja",  "Tarjeta en caja",                               "GetHbVar('nTarjetaEnCaja')")

Return nil

//---------------------------------------------------------------------------//

METHOD DesignReport( oFastReport, dbfDoc )

   if ::OpenFiles()

      /*
      Ficheros temporales------------------------------------------------------
      */

      if empty( ::oDbfTemporal )
         ::DefineTemporal()
      end if
      ::oDbfTemporal:Activate( .f., .f. )

      /*
      Datos de prueba----------------------------------------------------------
      */

      ::oDbfTemporal:Blank()
         ::oDbfTemporal:cGrpTur  := "GRUPO 1"
         ::oDbfTemporal:cKeyTur  := "CO"
         ::oDbfTemporal:cNatTur  := "Contado"
         ::oDbfTemporal:nImpTur  := 1
      ::oDbfTemporal:Insert()

      ::oDbfTemporal:Blank()
         ::oDbfTemporal:cGrpTur  := "GRUPO 1"
         ::oDbfTemporal:cKeyTur  := "TR"
         ::oDbfTemporal:cNatTur  := "Tarjeta"
         ::oDbfTemporal:nImpTur  := 2
      ::oDbfTemporal:Insert()

      ::oDbfTemporal:Blank()
         ::oDbfTemporal:cGrpTur  := "GRUPO 2"
         ::oDbfTemporal:cKeyTur  := "CO"
         ::oDbfTemporal:cNatTur  := "Contado"
         ::oDbfTemporal:nImpTur  := 3
      ::oDbfTemporal:Insert()

      ::oDbfTemporal:Blank()
         ::oDbfTemporal:cGrpTur  := "GRUPO 2"
         ::oDbfTemporal:cKeyTur  := "TR"
         ::oDbfTemporal:cNatTur  := "Tarjeta"
         ::oDbfTemporal:nImpTur  := 4
      ::oDbfTemporal:Insert()

      /*
      Calculo del turno--------------------------------------------------------
      */

      ::lCalTurno()

      /*
      Zona de datos------------------------------------------------------------
      */

      ::DataReport( nil, nil, oFastReport )

      /*
      Paginas y bandas---------------------------------------------------------
      */

      if !empty( ( dbfDoc )->mReport )

         oFastReport:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      else

         oFastReport:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )

         oFastReport:AddPage(         "MainPage" )

         oFastReport:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
         oFastReport:SetProperty(     "CabeceraDocumento", "Top", 0 )
         oFastReport:SetProperty(     "CabeceraDocumento", "Height", 199 )

         oFastReport:AddBand(         "MasterData",  "MainPage", frxGroupHeader )
         oFastReport:SetProperty(     "MasterData",  "Top", 200 )
         oFastReport:SetProperty(     "MasterData",  "Height", 29 )

         oFastReport:AddBand(         "DetalleColumnas",   "MainPage", frxMasterData )
         oFastReport:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFastReport:SetProperty(     "DetalleColumnas",   "Height", 29 )
         oFastReport:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de informes" )

         oFastReport:AddBand(         "PieColumnas",       "MainPage", frxGroupFooter )
         oFastReport:SetProperty(     "PieColumnas",       "Top", 260 )
         oFastReport:SetProperty(     "PieColumnas",       "Height", 29 )

         oFastReport:AddBand(         "PieDocumento",      "MainPage", frxPageFooter )
         oFastReport:SetProperty(     "PieDocumento",      "Top", 290 )
         oFastReport:SetProperty(     "PieDocumento",      "Height", 99 )

      end if

      /*
      Zona de variables--------------------------------------------------------
      */

      ::VariableReport( oFastReport )

      /*
      Diseño de report---------------------------------------------------------
      */

      oFastReport:DesignReport()

      oFastReport:DestroyFr()

      /*
      Cierra ficheros----------------------------------------------------------
      */

      ::CloseFiles()

   else

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD DefineTemporal()

   ::cFileTemporal   := cGetNewFileName( cPatTmp() + "TTur" )

   DEFINE DATABASE ::oDbfTemporal FILE ( ::cFileTemporal ) CLASS "TTur" ALIAS "TTur" PATH ( cPatTmp() ) VIA ( cLocalDriver() ) COMMENT "líneas de informe"

      FIELD NAME "cGrpTur" TYPE "C"  LEN  60 DEC 0 COMMENT "Grupo"                                                            OF ::oDbfTemporal
      FIELD NAME "nGrpPes" TYPE "N"  LEN   3 DEC 0 COMMENT "Peso"                                                             OF ::oDbfTemporal
      FIELD NAME "cKeyTur" TYPE "C"  LEN  14 DEC 0 COMMENT "Clave"                                                            OF ::oDbfTemporal
      FIELD NAME "cNatTur" TYPE "C"  LEN 200 DEC 0 COMMENT "Naturaleza"                                                       OF ::oDbfTemporal
      FIELD NAME "nImpTur" TYPE "N"  LEN  16 DEC 6 COMMENT "Importe"                                                          OF ::oDbfTemporal

      INDEX TO ( ::cFileTemporal ) TAG "cGruTur" ON "Str( nGrpPes, 3 ) + cGrpTur + cKeyTur" COMMENT "Número" NODELETED        OF ::oDbfTemporal

   END DATABASE ::oDbfTemporal

RETURN ( ::oDbfTemporal )

//---------------------------------------------------------------------------//

METHOD DestroyTemporal()

   if !empty( ::oDbfTemporal ) .and. ::oDbfTemporal:Used()
      ::oDbfTemporal:End()
   end if

   dbfErase( ::cFileTemporal )

   ::oDbfTemporal    := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AppendInTemporal( cKey, cNaturaleza, nImporte )

   local oError
   local oBlock

   if !( hb_ischar( cNaturaleza ) )
      Return ( Self )
   end if 

   if !( hb_isnumeric( nImporte ) )
      Return ( Self )
   end if 

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      if ( cKey == nil )

         ::oDbfTemporal:Blank()
         ::oDbfTemporal:cGrpTur     := ::cGrupoEnUso
         ::oDbfTemporal:nGrpPes     := ::nGrupoPeso
         ::oDbfTemporal:cNatTur     := cNaturaleza
         ::oDbfTemporal:nImpTur     := nImporte
         ::oDbfTemporal:Insert()

      else

         cKey                       := padr( cKey, 14, space( 1 ) )

         if ::oDbfTemporal:Seek( str( ::nGrupoPeso, 3 ) + ::cGrupoEnUso + cKey )

            ::oDbfTemporal:Load()
            ::oDbfTemporal:nImpTur  += nImporte
            ::oDbfTemporal:Save()

         else

            ::oDbfTemporal:Blank()
            ::oDbfTemporal:cGrpTur  := ::cGrupoEnUso
            ::oDbfTemporal:nGrpPes  := ::nGrupoPeso
            ::oDbfTemporal:cKeyTur  := cKey
            ::oDbfTemporal:cNatTur  := cNaturaleza
            ::oDbfTemporal:nImpTur  := nImporte
            ::oDbfTemporal:Insert()

         end if

      end if

   RECOVER USING oError
      msgStop( "Error en añadiendo datos temporales" + CRLF + ErrorMessage( oError ) )
   END SEQUENCE
   
   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FillTemporal( cCodCaj )

   local n
   local cTurno
   local cBancos
   local aBancos
   local cTipTik
   local nTotLin
   local cNomBnc
   local cTurnoCaja
   local oDbvBancos
   local oDbvArticulos
   local oDbcArticulos

   DEFAULT cCodCaj      := ::GetCurrentCaja()

   aBancos              := {}
   cTurno               := ::oDbf:cNumTur + ::oDbf:cSufTur
   cTurnoCaja           := cTurno + cCodCaj

   /*
   Creacion del temporal-------------------------------------------------------
   */

   if empty( ::oDbfTemporal )
      ::DefineTemporal()
      ::oDbfTemporal:Activate( .f., .f. )
   end if

   ::oDbfTemporal:Zap()

   /*
   Entradas y salidas de caja--------------------------------------------------
   */

   if ::GetItemCheckState( "Entradas y salidas de cajas" )

      if ::oEntSal:Seek( cTurnoCaja )

         while ::oEntSal:cTurEnt + ::oEntSal:cSufEnt + ::oEntSal:cCodCaj == cTurnoCaja .and. !::oEntSal:eof()

            ::AppendInTemporal( nil, ::cTxtEntradasSalidas(), ::nTotEntradasSalidas() )

            ::oEntSal:Skip()

            SysRefresh()

         end do

      end if

   end if

   /*
   Ventas por albaranes-------------------------------------------------------
   */

   if ::GetItemCheckState( "Albaranes de clientes" )

      if ::oAlbCliT:Seek( cTurnoCaja )

         while ::oAlbCliT:cTurAlb + ::oAlbCliT:cSufAlb + ::oAlbCliT:cCodCaj == cTurnoCaja .and. !::oAlbCliT:eof()

            ::AppendInTemporal( nil, ::cTxtAlbaranCliente(), nTotAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oIvaImp:cAlias, ::oDbfDiv:cAlias(), nil, cDivEmp(), .f. ) )

            ::oAlbCliT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Ventas por facturas---------------------------------------------------------
   */

   if ::GetItemCheckState( "Facturas de clientes" )

      if ::oFacCliT:Seek( cTurnoCaja )

         while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac + ::oFacCliT:cCodCaj == cTurnoCaja .and. !::oFacCliT:eof()

            ::AppendInTemporal( nil, ::cTxtFacturaCliente(), nTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oIvaImp:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, nil, cDivEmp(), .f. ) )

            ::oFacCliT:Skip()

         end while

      end if

   end if

   /*
   Ventas por facturas rectificativas---------------------------------------------------------
   */

   if ::GetItemCheckState( "Facturas rectificativas de clientes" )

      if ::oRctCliT:Seek( cTurnoCaja )

         while ::oRctCliT:cTurFac + ::oRctCliT:cSufFac + ::oRctCliT:cCodCaj == cTurnoCaja .and. !::oRctCliT:eof()

            ::AppendInTemporal( nil, ::cTxtFacturaRectificativaCliente(), nTotFacRec( ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac, ::oRctCliT:cAlias, ::oRctCliL:cAlias, ::oIvaImp:cAlias, ::oDbfDiv:cAlias, nil, cDivEmp(), .f. ) )

            ::oRctCliT:Skip()

         end while

      end if

   end if

   /*
   Anticipos de clientes-------------------------------------------------------
   */

   if ::GetItemCheckState( "Anticipos de clientes" )

      ::oAntCliT:OrdSetFocus( "cTurAnt" )
      if ::oAntCliT:Seek( cTurnoCaja )

         while ::oAntCliT:cTurAnt + ::oAntCliT:cSufAnt + ::oAntCliT:cCodCaj == cTurnoCaja .and. !::oAntCliT:eof()

            ::AppendInTemporal(  nil, ::cTxtAnticipoCliente(), ::nTotAnticipoCliente() )

            ::oAntCliT:Skip()

            SysRefresh()

         end do

      end if

   end if

   /*
   Tickets de clientes-------------------------------------------------------
   */

   if ::GetItemCheckState( "Tickets" )

      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            if ::oTikT:cTipTik == SAVTIK

               ::AppendInTemporal( nil, ::cTxtTiketCliente(), ::nTotTiketCliente() )

            end if

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Devoluciones de clientes-------------------------------------------------------
   */

   if ::GetItemCheckState( "Devoluciones de clientes" )

      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            if ::oTikT:cTipTik == SAVDEV

               ::AppendInTemporal( nil, ::cTxtTiketCliente(), ::nTotTiketCliente() )

            end if

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Devoluciones de clientes-------------------------------------------------------
   */

   if ::GetItemCheckState( "Vales a clientes" )

      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            if ::oTikT:cTipTik == SAVVAL

               ::AppendInTemporal( nil, ::cTxtTiketCliente(), ::nTotTiketCliente() )

            end if

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Ventas por contadores-------------------------------------------------------
   */

   if ::GetItemCheckState( "Contadores" ) .and. ::oTotales:nTotContadores() != 0

      if ::oDbfDet:Seek( cTurno )

         while ::oDbfDet:cNumTur + ::oDbfDet:cSufTur == ::oDbf:cNumTur + ::oDbf:cSufTur .and. !::oDbfDet:Eof()

            nTotLin     := Round( ( ::oDbfDet:nCanAct - ::oDbfDet:nCanAnt ) * ::oDbfDet:nPvpArt, ::nDorDiv )

            if nTotLin != 0
               ::AppendInTemporal(  ::oDbfDet:cCodArt,;
                                    Padr( Rtrim( ::oDbfDet:cCodArt ) + Space( 1 ) + Rtrim( ::oDbfDet:cNomArt ), 32 )       + ;
                                    "[Ant.: " + Trans( ::oDbfDet:nCanAnt, "9999999" )                                + "]" + ;
                                    "[Act.: " + Trans( ::oDbfDet:nCanAct, "9999999" )                                + "]" + ;
                                    "[Und.: " + Trans( ::oDbfDet:nCanAct - ::oDbfDet:nCanAnt, "9999999" )            + "]" + ;
                                    "[Pvp : " + Padl( LTrans( ::oDbfDet:nPvpArt, ::cPouDiv ), 7 )                    + "]",;
                                    nTotLin )
            end if

            ::oDbfDet:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Compras por albaranes---------------------------------------------------------
   */

   if ::GetItemCheckState( "Albaranes de proveedores" )

      if ::oAlbPrvT:Seek( cTurnoCaja )

         while ::oAlbPrvT:cTurAlb + ::oAlbPrvT:cSufAlb + ::oAlbPrvT:cCodCaj == cTurnoCaja .and. !::oAlbPrvT:eof()

            ::AppendInTemporal(  nil, ::cTxtAlbaranProveedor(), ::nTotAlbaranProveedor() )

            ::oAlbPrvT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Compras por facturas---------------------------------------------------------
   */

   if ::GetItemCheckState( "Facturas de proveedores" )

      if ::oFacPrvT:Seek( cTurnoCaja )

         while ::oFacPrvT:cTurFac + ::oFacPrvT:cSufFac + ::oFacPrvT:cCodCaj == cTurnoCaja .and. !::oFacPrvT:eof()

            ::AppendInTemporal( nil, ::cTxtFacturaProveedor(), ::nTotFacturaProveedor() )

            ::oFacPrvT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Compras rectificativas ---------------------------------------------------------
   */

   if ::GetItemCheckState( "Facturas rectificativas de proveedores" )

      if ::oRctPrvT:Seek( cTurnoCaja )

         while ::oRctPrvT:cTurFac + ::oRctPrvT:cSufFac + ::oRctPrvT:cCodCaj == cTurnoCaja .and. !::oRctPrvT:eof()

            ::AppendInTemporal( nil, ::cTxtFacturaRectificativaProveedor(), ::nTotFacturaRectificativaProveedor() )

            ::oRctPrvT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Vales liquidados de clientes------------------------------------------------
   */

   if ::GetItemCheckState( "Vales liquidados de clientes" )

      ::oTikT:OrdSetFocus( "cTurVal" )
      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            if ::oTikT:cTipTik == SAVVAL .and. ::oTikT:lLiqTik

               ::AppendInTemporal( nil, ::cTxtTiketCliente(), ::nTotTiketCliente() )

            end if

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

      ::oTikT:OrdSetFocus( "cTurTik" )

   end if

   /*
   Tickets de clientes lineas borradas-----------------------------------------
   */

   if ::GetItemCheckState( "Tickets lineas borradas" )

      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            if ::oTikT:cTipTik == SAVTIK

               if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                  while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                     if ::oTikL:lDelTil 

                        ::AppendInTemporal( nil, ::oTikT:cSerTik + "/"+ alltrim( ::oTikT:cNumTik ) + "/" + alltrim( ::oTikT:cSufTik ) + space( 1 ) + rtrim( ::oTikL:cCbaTil ) + space( 1 ) + rtrim( ::oTikL:cNomTil ), nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv ) )

                     end if 

                     ::oTikL:Skip()

                     SysRefresh()

                  end while

               end if

            end if

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Cobros de ventas anteriores-------------------------------------------------
   */

   if ::GetItemCheckState( "Cobros de ventas anteriores" )

      ::oTikP:GetStatus()
      ::oTikP:OrdSetFocus( "cTurPgo" )

      if ::oTikP:Seek( cTurnoCaja )

         while ::oTikP:cTurPgo + ::oTikP:cSufTik + ::oTikP:cCodCaj == cTurnoCaja .and. !::oTikP:eof()

            /*cTipTik        := oRetFld( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik, ::oTikT, "cTipTik", 1 )

            do case
               case cTipTik == SAVTIK // Como devolucion
                  nTotLin  := nTotLCobTik( ::oTikP, ::oDbfDiv, cDivEmp() )

               case cTipTik == SAVDEV // Como devolucion
                  nTotLin  := - nTotLCobTik( ::oTikP, ::oDbfDiv, cDivEmp() )

               case cTipTik == SAVVAL // Como vale
                  nTotLin  := 0

            end case

            if nTotLin != 0

               ::AppendInTemporal(  nil,;
                                    ::oTikP:cSerTik + "/" + Alltrim( ::oTikP:cNumTik ) + "/" + Rtrim( ::oTikP:cSufTik )            + Space( 1 ) + ;
                                    ::oTikP:cFpgPgo                                                                                + Space( 1 ) + ;
                                    Rtrim( oRetfld( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik, ::oTikT, "cCliTik", 1 ) ) + Space( 1 ) + ;
                                    Rtrim( oRetfld( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik, ::oTikT, "cNomTik", 1 ) ) ,;
                                    nTotLin )*/

               ::AppendInTemporal(  nil, "Recibo de pruebas", 98 )

            //end if

            ::oTikP:Skip()

            SysRefresh()

         end while

      end if

      ::oTikP:SetStatus()

   end if

   /*
   Anticipos liquidados de clientes--------------------------------------------
   */

   if ::GetItemCheckState( "Anticipos liquidados de clientes" )

      ::oAntCliT:OrdSetFocus( "cTurLiq" )
      if ::oAntCliT:Seek( cTurnoCaja )

         while ::oAntCliT:cTurAnt + ::oAntCliT:cSufAnt + ::oAntCliT:cCodCaj == cTurnoCaja .and. !::oAntCliT:eof()

            nTotLin     := nTotAntCli( ::oAntCliT:cAlias, ::oIvaImp:cAlias, ::oDbfDiv:cAlias )

            if nTotLin != 0
               ::AppendInTemporal(  nil,;
                                    Alltrim( ::oAntCliT:cSerAnt + "/" + Alltrim( Str( ::oAntCliT:nNumAnt ) ) + "/" + ::oAntCliT:cSufAnt ) + Space( 1 ) + ;
                                    Rtrim( ::oAntCliT:cCodCli ) + Space( 1 ) + ;
                                    ::oAntCliT:cNomCli,;
                                    nTotLin )

            end if

            ::oAntCliT:Skip()

            SysRefresh()

         end do

      end if

      ::oAntCliT:OrdSetFocus( "cTurAnt" )

   end if

   /*
   Entregas a cuenta en pedidos -----------------------------------------------
   */

   if ::GetItemCheckState( "Entregas a cuenta en pedidos de clientes" )

      if ::oPedCliP:Seek( cTurnoCaja )

         while ::oPedCliP:cTurRec + ::oPedCliP:cSufPed + ::oPedCliP:cCodCaj == cTurnoCaja .and. !::oPedCliP:eof()

            if !::oPedCliP:lPasado

               ::AppendInTemporal(  nil, ::cTxtPedidoEntrega(), ::nTotPedidoEntrega() )

            end if

            ::oPedCliP:Skip()

            SysRefresh()

         end do

      end if

   end if

   /*
   Entregas a cuenta en albaranes ---------------------------------------------
   */

   if ::GetItemCheckState( "Entregas a cuenta en albaranes de clientes" )

      if ::oAlbCliP:Seek( cTurnoCaja )

         while ::oAlbCliP:cTurRec + ::oAlbCliP:cSufAlb + ::oAlbCliP:cCodCaj == cTurnoCaja .and. !::oAlbCliP:eof()

            if !::oAlbCliP:lPasado

               ::AppendInTemporal(  nil, ::cTxtAlbaranEntrega(), ::nTotAlbaranEntrega() )

            end if

            ::oAlbCliP:Skip()

            SysRefresh()

         end do

      end if

   end if

   /*
   Cobros en facturas de clientes----------------------------------------------
   */

   if ::GetItemCheckState( "Cobros en facturas de clientes" )

      ::oFacCliP:GetStatus()
      ::oFacCliP:OrdSetFocus( "cTurRec" )

      if ::oFacCliP:Seek( cTurnoCaja )

         while ::oFacCliP:cTurRec + ::oFacCliP:cSufFac + ::oFacCliP:cCodCaj == cTurnoCaja .and. !::oFacCliP:eof()

            if ::oFacCliP:lCobrado .and. !::oFacCliP:lPasado .and. !::oFacCliP:lNotArqueo

               ::AppendInTemporal(  nil, ::cTxtFacturaCobro(), ::nTotFacturaCobro() )

            end if

            ::oFacCliP:Skip()

            SysRefresh()

         end do

      end if

      ::oFacCliP:SetStatus()

   end if

   /*
   Cobros en facturas de clientes----------------------------------------------
   */

   if ::GetItemCheckState( "Cobros efectivo en facturas de clientes" )

      ::oFacCliP:GetStatus()
      ::oFacCliP:OrdSetFocus( "cTurRec" )

      if ::oFacCliP:Seek( cTurnoCaja )

         while ::oFacCliP:cTurRec + ::oFacCliP:cSufFac + ::oFacCliP:cCodCaj == cTurnoCaja .and. !::oFacCliP:eof()

            if ::oFacCliP:lCobrado .and. !::oFacCliP:lPasado .and. !::oFacCliP:lNotArqueo .and. ( nTipoPago( ::oFacCliP:cCodPgo, ::oFPago ) < 2 )

               ::AppendInTemporal(  nil, ::cTxtFacturaCobro(), ::nTotFacturaCobro() )

            end if

            ::oFacCliP:Skip()

            SysRefresh()

         end do

      end if

      ::oFacCliP:SetStatus()

   end if

   /*
   Cobros en facturas de clientes----------------------------------------------
   */

   if ::GetItemCheckState( "Cobros no efectivo en facturas de clientes" )

      ::oFacCliP:GetStatus()
      ::oFacCliP:OrdSetFocus( "cTurRec" )

      if ::oFacCliP:Seek( cTurnoCaja )

         while ::oFacCliP:cTurRec + ::oFacCliP:cSufFac + ::oFacCliP:cCodCaj == cTurnoCaja .and. !::oFacCliP:eof()

            if ::oFacCliP:lCobrado .and. !::oFacCliP:lPasado .and. !::oFacCliP:lNotArqueo .and. ( nTipoPago( ::oFacCliP:cCodPgo, ::oFPago ) == 2 )

               ::AppendInTemporal(  nil, ::cTxtFacturaCobro(), ::nTotFacturaCobro() )

            end if

            ::oFacCliP:Skip()

            SysRefresh()

         end do

      end if

      ::oFacCliP:SetStatus()

   end if

   /*
   Cobros en facturas de clientes----------------------------------------------
   */

   if ::GetItemCheckState( "Cobros tarjeta en facturas de clientes" )

      ::oFacCliP:GetStatus()
      ::oFacCliP:OrdSetFocus( "cTurRec" )

      if ::oFacCliP:Seek( cTurnoCaja )

         while ::oFacCliP:cTurRec + ::oFacCliP:cSufFac + ::oFacCliP:cCodCaj == cTurnoCaja .and. !::oFacCliP:eof()

            if ::oFacCliP:lCobrado .and. !::oFacCliP:lPasado .and. !::oFacCliP:lNotArqueo .and. ( nTipoPago( ::oFacCliP:cCodPgo, ::oFPago ) == 3 )

               ::AppendInTemporal(  nil, ::cTxtFacturaCobro(), ::nTotFacturaCobro() )

            end if

            ::oFacCliP:Skip()

            SysRefresh()

         end do

      end if

      ::oFacCliP:SetStatus()

   end if

   /*
   Cobros en tickets de clientes----------------------------------------------
   */

   if ::GetItemCheckState( "Cobros en tickets de clientes" )

      ::oTikP:GetStatus()
      ::oTikP:OrdSetFocus( "cTurPgo" )

      if ::oTikP:Seek( cTurnoCaja )

         while ::oTikP:cTurPgo + ::oTikP:cSufTik + ::oTikP:cCodCaj == cTurnoCaja .and. !::oTikP:eof()

            cTipTik        := oRetFld( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik, ::oTikT, "cTipTik", 1 )

            do case
               case cTipTik == SAVTIK // Como devolucion
                  nTotLin  := nTotLCobTik( ::oTikP, ::oDbfDiv, cDivEmp() )

               case cTipTik == SAVDEV // Como devolucion
                  nTotLin  := - nTotLCobTik( ::oTikP, ::oDbfDiv, cDivEmp() )

               case cTipTik == SAVVAL // Como vale
                  nTotLin  := 0

            end case

            if nTotLin != 0

               ::AppendInTemporal(  nil,;
                                    ::oTikP:cSerTik + "/" + Alltrim( ::oTikP:cNumTik ) + "/" + Rtrim( ::oTikP:cSufTik )            + Space( 1 ) + ;
                                    ::oTikP:cFpgPgo                                                                                + Space( 1 ) + ;
                                    Rtrim( oRetfld( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik, ::oTikT, "cCliTik", 1 ) ) + Space( 1 ) + ;
                                    Rtrim( oRetfld( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik, ::oTikT, "cNomTik", 1 ) ) ,;
                                    nTotLin )

            end if

            ::oTikP:Skip()

            SysRefresh()

         end do

      end if

      ::oTikP:SetStatus()

   end if

   /*
   Cobros por formas de pago---------------------------------------------------
   */

   if ::GetItemCheckState( "Cobros por formas de pago" ) // ::aOpcionImp[15]

      /*
      Tickets---------------------------------------------------------------------
      */

      ::oTikP:GetStatus()
      ::oTikP:OrdSetFocus( "cTurPgo" )

      if ::oTikP:Seek( cTurnoCaja )

         while ::oTikP:cTurPgo + ::oTikP:cSufTik + ::oTikP:cCodCaj == cTurnoCaja .and. !::oTikP:eof()

            cTipTik        := oRetFld( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik, ::oTikT, "cTipTik", 1 )

            do case
               case cTipTik == SAVTIK  // Como ticket
                  nTotLin  := nTotLCobTik( ::oTikP, ::oDbfDiv, cDivEmp() )

               case cTipTik == SAVDEV  // Como devolucion
                  nTotLin  := - nTotLCobTik( ::oTikP, ::oDbfDiv, cDivEmp() )

               otherwise               // Como vale
                  nTotLin  := 0

            end case

            if nTotLin != 0
               ::AppendInTemporal( ::oTikP:cFpgPgo, ::oTikP:cFpgPgo + Space( 1 ) + oRetFld( ::oTikP:cFpgPgo, ::oFPago ), nTotLin )
            end if

            ::oTikP:Skip()

            SysRefresh()

         end do

      end if

      ::oTikP:SetStatus()

      /*
      Facturas--------------------------------------------------------------------
      */

      ::oFacCliP:GetStatus()
      ::oFacCliP:OrdSetFocus( "cTurRec" )

      if ::oFacCliP:Seek( cTurnoCaja )

         while ::oFacCliP:cTurRec + ::oFacCliP:cSufFac + ::oFacCliP:cCodCaj == cTurnoCaja .and. !::oFacCliP:eof()

            if ::oFacCliP:lCobrado .and. !::oFacCliP:lPasado .and. !::oFacCliP:lNotArqueo
               ::AppendInTemporal( ::oFacCliP:cCodPgo, ::oFacCliP:cCodPgo + Space( 1 ) + oRetFld( ::oFacCliP:cCodPgo, ::oFPago ), ::nTotFacturaCobro() )
            end if

            ::oFacCliP:Skip()

            SysRefresh()

         end do

      end if

      ::oFacCliP:SetStatus()

      /*
      Entregas a cuenta de pedidos de clientes----------------------------------
      */

      ::oPedCliP:GetStatus()
      ::oPedCliP:OrdSetFocus( "cTurRec" )

      if ::oPedCliP:Seek( cTurnoCaja )

         while ::oPedCliP:cTurRec + ::oPedCliP:cSufPed + ::oPedCliP:cCodCaj == cTurnoCaja .and. !::oPedCliP:eof()

            if !::oPedCliP:lPasado
               ::AppendInTemporal( ::oPedCliP:cCodPgo, ::oPedCliP:cCodPgo + Space( 1 ) + oRetFld( ::oPedCliP:cCodPgo, ::oFPago ), ::nTotPedidoEntrega() )
            end if

            ::oPedCliP:Skip()

            SysRefresh()

         end do

      end if

      ::oPedCliP:SetStatus()

      /*
      Entregas a cuenta de albaranes de clientes----------------------------------
      */

      ::oAlbCliP:GetStatus()
      ::oAlbCliP:OrdSetFocus( "cTurRec" )

      if ::oAlbCliP:Seek( cTurnoCaja )

         while ::oAlbCliP:cTurRec + ::oAlbCliP:cSufAlb + ::oAlbCliP:cCodCaj == cTurnoCaja .and. !::oAlbCliP:eof()

            if !::oAlbCliP:lPasado
               ::AppendInTemporal( ::oAlbCliP:cCodPgo, ::oAlbCliP:cCodPgo + Space( 1 ) + oRetFld( ::oAlbCliP:cCodPgo, ::oFPago ), ::nTotAlbaranEntrega() )
            end if

            ::oAlbCliP:Skip()

            SysRefresh()

         end do

      end if

      ::oAlbCliP:SetStatus()

   end if

   /*
   Cobros en facturas de proveedores-------------------------------------------
   */

   if ::GetItemCheckState( "Pagos en facturas a proveedores" )

      ::oFacPrvP:GetStatus()
      ::oFacPrvP:OrdSetFocus( "cTurRec" )

      if ::oFacPrvP:Seek( cTurnoCaja )

         while ::oFacPrvP:cTurRec + ::oFacPrvP:cSufFac + ::oFacPrvP:cCodCaj == cTurnoCaja .and. !::oFacPrvP:eof()

            if ::oFacPrvP:lCobrado .and. !::oFacPrvP:lNotArqueo
               ::AppendInTemporal(  nil, ::cTxtFacturaPago(), ::nTotFacturaPago() )
            end if

            ::oFacPrvP:Skip()

            SysRefresh()

         end do

      end if

      ::oFacPrvP:SetStatus()

      SysRefresh()

   end if

   /*
   Cobros en facturas de proveedores-------------------------------------------
   */

   if ::GetItemCheckState( "Pagos efectivo en facturas a proveedores" )

      ::oFacPrvP:GetStatus()
      ::oFacPrvP:OrdSetFocus( "cTurRec" )

      if ::oFacPrvP:Seek( cTurnoCaja )

         while ::oFacPrvP:cTurRec + ::oFacPrvP:cSufFac + ::oFacPrvP:cCodCaj == cTurnoCaja .and. !::oFacPrvP:eof()

            if ::oFacPrvP:lCobrado .and. !::oFacPrvP:lNotArqueo .and. ( nTipoPago( ::oFacPrvP:cCodPgo, ::oFPago ) < 2 )
               ::AppendInTemporal(  nil, ::cTxtFacturaPago(), ::nTotFacturaPago() )
            end if

            ::oFacPrvP:Skip()

            SysRefresh()

         end do

      end if

      ::oFacPrvP:SetStatus()

      SysRefresh()

   end if

   if ::GetItemCheckState( "Pagos no efectivo en facturas a proveedores" )

      ::oFacPrvP:GetStatus()
      ::oFacPrvP:OrdSetFocus( "cTurRec" )

      if ::oFacPrvP:Seek( cTurnoCaja )

         while ::oFacPrvP:cTurRec + ::oFacPrvP:cSufFac + ::oFacPrvP:cCodCaj == cTurnoCaja .and. !::oFacPrvP:eof()

            if ::oFacPrvP:lCobrado .and. !::oFacPrvP:lNotArqueo .and. ( nTipoPago( ::oFacPrvP:cCodPgo, ::oFPago ) == 2 )
               ::AppendInTemporal( nil, ::cTxtFacturaPago(), ::nTotFacturaPago() )
            end if

            ::oFacPrvP:Skip()

            SysRefresh()

         end do

      end if

      ::oFacPrvP:SetStatus()

      SysRefresh()

   end if

   if ::GetItemCheckState( "Pagos tarjeta en facturas a proveedores" )

      ::oFacPrvP:GetStatus()
      ::oFacPrvP:OrdSetFocus( "cTurRec" )

      if ::oFacPrvP:Seek( cTurnoCaja )

         while ::oFacPrvP:cTurRec + ::oFacPrvP:cSufFac + ::oFacPrvP:cCodCaj == cTurnoCaja .and. !::oFacPrvP:eof()

            if ::oFacPrvP:lCobrado .and. !::oFacPrvP:lNotArqueo .and. ( nTipoPago( ::oFacPrvP:cCodPgo, ::oFPago ) == 3 )
               ::AppendInTemporal( nil, ::cTxtFacturaPago(), ::nTotFacturaPago() )
            end if

            ::oFacPrvP:Skip()

            SysRefresh()

         end do

      end if

      ::oFacPrvP:SetStatus()

      SysRefresh()

   end if

   /*
   Cobros en facturas de proveedores por formas de pago------------------------
   */

   if ::GetItemCheckState( "Pagos por formas de pago" )

      ::oFacPrvP:GetStatus()
      ::oFacPrvP:OrdSetFocus( "cTurRec" )

      if ::oFacPrvP:Seek( cTurnoCaja )

         while ::oFacPrvP:cTurRec + ::oFacPrvP:cSufFac + ::oFacPrvP:cCodCaj == cTurnoCaja .and. !::oFacPrvP:eof()

            if ::oFacPrvP:lCobrado .and. !::oFacPrvP:lNotArqueo
               ::AppendInTemporal( ::oFacPrvP:cCodPgo, ::oFacPrvP:cCodPgo + Space( 1 ) + oRetFld( ::oFacPrvP:cCodPgo, ::oFPago ), ::nTotFacturaPago() )
            end if

            ::oFacPrvP:Skip()

            SysRefresh()

         end do

      end if

      ::oFacPrvP:SetStatus()

      SysRefresh()

   end if

   /*
   Bancos de empresa-----------------------------------------------------------
   */

   if ::GetItemCheckState( "Operaciones bancarias en cuentas de empresa" )

      oDbvBancos        := TDbVirtual( , "Bco" ):DefNew()
         oDbvBancos:AddField( "cNomBnc", "C", 50, 0 )
         oDbvBancos:AddField( "cCtaBnc", "C", 20, 0 )
         oDbvBancos:AddField( "cNumOpe", "C", 14, 0 )
         oDbvBancos:AddField( "dFecOpe", "D",  8, 0 )
         oDbvBancos:AddField( "cFpgOpe", "C",  2, 0 )
         oDbvBancos:AddField( "cCliOpe", "C",  2, 0 )
         oDbvBancos:AddField( "cNomOpe", "C",  2, 0 )
         oDbvBancos:AddField( "nImpOpe", "N", 19, 6 )
      oDbvBancos:Activate()

      /*
      Recibos de clientes------------------------------------------------------
      */

      ::oFacCliP:GetStatus()

      ::oFacCliP:OrdSetFocus( "cTurRec" )

      if ::oFacCliP:Seek( cTurnoCaja )

         while ::oFacCliP:cTurRec + ::oFacCliP:cSufFac + ::oFacCliP:cCodCaj == cTurnoCaja .and. !::oFacCliP:eof()

            if ::oFacCliP:lCobrado .and. !::oFacCliP:lPasado .and. !::oFacCliP:lNotArqueo .and. !empty( cCuentaEmpresaRecibo( ::oFacCliP ) )

               oDbvBancos:Append()
               oDbvBancos:cNomBnc   := oRetFld( cCuentaEmpresaRecibo( ::oFacCliP ), ::oEmpBnc, "cNomBnc", "cCtaBnc" )
               oDbvBancos:cCtaBnc   := cCuentaEmpresaRecibo( ::oFacCliP )
               oDbvBancos:cNumOpe   := ::oFacCliP:cSerie + "/" + Alltrim( Str( ::oFacCliP:nNumFac ) ) + "/" + Rtrim( ::oFacCliP:cSufFac )
               oDbvBancos:dFecOpe   := ::oFacCliP:dEntrada
               oDbvBancos:cFpgOpe   := ::oFacCliP:cCodPgo
               oDbvBancos:cCliOpe   := ::oFacCliP:cCodCli
               oDbvBancos:cNomOpe   := ::oFacCliP:cNomCli
               oDbvBancos:nImpOpe   := ::nTotFacturaCobro()

            end if

            ::oFacCliP:Skip()

            SysRefresh()

         end do

      end if

      ::oFacCliP:SetStatus()

      /*
      Recibos de proveedores---------------------------------------------------
      */

      ::oFacPrvP:GetStatus()

      ::oFacPrvP:OrdSetFocus( "cTurRec" )

      if ::oFacPrvP:Seek( cTurnoCaja )

         while ::oFacPrvP:cTurRec + ::oFacPrvP:cSufFac + ::oFacPrvP:cCodCaj == cTurnoCaja .and. !::oFacPrvP:eof()

            if ::oFacPrvP:lCobrado .and. !::oFacPrvP:lNotArqueo .and. !empty( cCuentaEmpresaRecibo( ::oFacPrvP ) )

               oDbvBancos:Append()
               oDbvBancos:cNomBnc   := oRetFld( cCuentaEmpresaRecibo( ::oFacPrvP ), ::oEmpBnc, "cNomBnc", "cCtaBnc" )
               oDbvBancos:cCtaBnc   := cCuentaEmpresaRecibo( ::oFacPrvP )
               oDbvBancos:cNumOpe   := ::oFacPrvP:cSerFac + "/" + Alltrim( Str( ::oFacPrvP:nNumFac ) ) + "/" + Rtrim( ::oFacPrvP:cSufFac )
               oDbvBancos:dFecOpe   := ::oFacPrvP:dEntrada
               oDbvBancos:cFpgOpe   := ::oFacPrvP:cCodPgo
               oDbvBancos:cCliOpe   := ::oFacPrvP:cCodPrv
               oDbvBancos:cNomOpe   := ::oFacPrvP:cNomPrv
               oDbvBancos:nImpOpe   := - ::nTotFacturaPago()

            end if

            ::oFacPrvP:Skip()

            SysRefresh()

         end do

      end if

      ::oFacPrvP:SetStatus()

      /*
      Impresion----------------------------------------------------------------
      */

      cNomBnc              := nil

      oDbvBancos:GoTop()
      while !oDbvBancos:eof()

         if ( cNomBnc != oDbvBancos:cNomBnc )

            cNomBnc        := "Cuenta bancaria : " + Rtrim( oDbvBancos:cNomBnc ) + Space( 1 ) + Alltrim( Trans( oDbvBancos:cCtaBnc, "@R ####################" ) )
            ::cGrupoEnUso  := Padr( cNomBnc, 60 )
            ::nGrupoPeso++

            aAdd( aBancos, oDbvBancos:cCtaBnc )

         end if

         ::AppendInTemporal( nil, oDbvBancos:cNumOpe + Space( 1 ) +  Dtoc( oDbvBancos:dFecOpe ) + Space( 1 ) + oDbvBancos:cFpgOpe + Space( 1 ) + Rtrim( oDbvBancos:cCliOpe ) + Space( 1 ) + oDbvBancos:cNomOpe, oDbvBancos:nImpOpe )

         oDbvBancos:Skip()

         SysRefresh()

      end while

      /*
      Resumen bancario---------------------------------------------------------

      if !empty( aBancos )

         ::cGrupoEnUso     := "Saldos cuentas bancarias"
         ::nGrupoPeso++

         for each cBancos in aBancos
            ::AppendInTemporal( nil, Alltrim( cBancos ), ::oCuentasBancarias:nSaldoActual( cBancos ) )
         next

      end if
      */

   end if

   if ::GetItemCheckState( "Operaciones bancarias en cuentas de empresa" )

      ::cGrupoEnUso     := "Saldos cuentas bancarias"
      ::nGrupoPeso++

      ::oCuentasBancarias:oDbf:GoTop()
      while !::oCuentasBancarias:oDbf:Eof()

         ::AppendInTemporal( nil, Alltrim( ::oCuentasBancarias:oDbf:cNomBnc ) + " : " + Alltrim( ::oCuentasBancarias:oDbf:cEntBnc + ::oCuentasBancarias:oDbf:cSucBnc + ::oCuentasBancarias:oDbf:cDigBnc + ::oCuentasBancarias:oDbf:cCtaBnc ), ::oCuentasBancarias:nSaldoActual() )

         ::oCuentasBancarias:oDbf:Skip()

      end while

   end if

   /*
   Estadisticas----------------------------------------------------------------
   */

   if ::GetItemCheckState( "Compras por artículos" )

      oDbcArticulos     := TDbVirtual( , "Imp" ):DefNew()
         oDbcArticulos:AddField( "cCodArt", "C", 14, 0 )
         oDbcArticulos:AddField( "cNomArt", "C", 50, 0 )
         oDbcArticulos:AddField( "nUndArt", "N", 19, 6 )
         oDbcArticulos:AddField( "nPvpArt", "N", 19, 6 )
         oDbcArticulos:AddField( "nImpArt", "N", 19, 6 )
      oDbcArticulos:Activate()

      /*
      Albaranes de proveedor --------------------------------------------------
      */

      if ::oAlbPrvT:Seek( cTurnoCaja )

         while ::oAlbPrvT:cTurAlb + ::oAlbPrvT:cSufAlb + ::oAlbPrvT:cCodCaj == cTurnoCaja .and. !::oAlbPrvT:eof()

            if !::oAlbPrvT:lFacturado .and. ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

               while ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb == ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb .and. !::oAlbPrvL:eof()

                  if oDbcArticulos:Seek( ::oAlbPrvL:cRef )
                     oDbcArticulos:nUndArt += nTotNAlbPrv( ::oAlbPrvL:cAlias )
                     oDbcArticulos:nImpArt += nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDouDiv, ::nDorDiv )
                  else
                     oDbcArticulos:Append()
                     oDbcArticulos:cCodArt := ::oAlbPrvL:cRef
                     oDbcArticulos:cNomArt := ::oAlbPrvL:cDetalle
                     oDbcArticulos:nUndArt := nTotNAlbPrv( ::oAlbPrvL:cAlias )
                     oDbcArticulos:nPvpArt := nImpUAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDouDiv, , .t. )
                     oDbcArticulos:nImpArt := nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDouDiv, ::nDorDiv )
                  end if

                  ::oAlbPrvL:Skip()

                  SysRefresh()

               end while

            end if

            ::oAlbPrvT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas de proveedor ---------------------------------------------------
      */

      if ::oFacPrvT:Seek( cTurnoCaja )

         while ::oFacPrvT:cTurFac + ::oFacPrvT:cSufFac + ::oFacPrvT:cCodCaj == cTurnoCaja .and. !::oFacPrvT:eof()

            if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

               while ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac == ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac .and. !::oFacPrvL:eof()

                  if oDbcArticulos:Seek(  ::oFacPrvL:cRef )
                     oDbcArticulos:nUndArt += nTotNFacPrv( ::oFacPrvL:cAlias, ::nDouDiv )
                     oDbcArticulos:nImpArt += nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDorDiv, ::nDorDiv )
                  else
                     oDbcArticulos:Append()
                     oDbcArticulos:cCodArt := ::oFacPrvL:cRef
                     oDbcArticulos:cNomArt := ::oFacPrvL:cDetalle
                     oDbcArticulos:nUndArt := nTotNFacPrv( ::oFacPrvL:cAlias )
                     oDbcArticulos:nPvpArt := nImpUFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDouDiv, , .t. )
                     oDbcArticulos:nImpArt := nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDouDiv, ::nDorDiv )
                  end if

                  ::oFacPrvL:Skip()

                  SysRefresh()

               end while

            end if

            ::oFacPrvT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Rectificativas de proveedor ---------------------------------------------
      */

      if ::oRctPrvT:Seek( cTurnoCaja )

         while ::oRctPrvT:cTurFac + ::oRctPrvT:cSufFac + ::oRctPrvT:cCodCaj == cTurnoCaja .and. !::oRctPrvT:eof()

            if ::oRctPrvL:Seek( ::oRctPrvT:cSerFac + Str( ::oRctPrvT:nNumFac ) + ::oRctPrvT:cSufFac )

               while ::oRctPrvL:cSerFac + Str( ::oRctPrvL:nNumFac ) + ::oRctPrvL:cSufFac == ::oRctPrvT:cSerFac + Str( ::oRctPrvT:nNumFac ) + ::oRctPrvT:cSufFac .and. !::oRctPrvL:eof()

                  if oDbcArticulos:Seek(  ::oRctPrvL:cRef )
                     oDbcArticulos:nUndArt += nTotNRctPrv( ::oRctPrvL:cAlias, ::nDouDiv )
                     oDbcArticulos:nImpArt += nImpLRctPrv( ::oRctPrvT:cAlias, ::oRctPrvL:cAlias, ::nDorDiv, ::nDorDiv )
                  else
                     oDbcArticulos:Append()
                     oDbcArticulos:cCodArt := ::oRctPrvL:cRef
                     oDbcArticulos:cNomArt := ::oRctPrvL:cDetalle
                     oDbcArticulos:nUndArt := nTotNRctPrv( ::oRctPrvL:cAlias )
                     oDbcArticulos:nPvpArt := nImpURctPrv( ::oRctPrvT:cAlias, ::oRctPrvL:cAlias, ::nDouDiv, , .t. )
                     oDbcArticulos:nImpArt := nImpLRctPrv( ::oRctPrvT:cAlias, ::oRctPrvL:cAlias, ::nDouDiv, ::nDorDiv )
                  end if

                  ::oRctPrvL:Skip()

                  SysRefresh()

               end while

            end if

            ::oRctPrvT:Skip()

            SysRefresh()

         end while

      end if


      oDbcArticulos:GoTop()

      while !oDbcArticulos:eof()

         ::AppendInTemporal(  nil, Rtrim( oDbcArticulos:cCodArt ) + Space( 1 ) + Rtrim( oDbcArticulos:cNomArt ) + Space( 1 ) + "[Und.:" + Ltrim( Trans( oDbcArticulos:nUndArt, ::cPicUnd ) ) + "]", oDbcArticulos:nImpArt )

         oDbcArticulos:Skip()

         SysRefresh()

      end while

   end if

   /*
   Ventas por articulos--------------------------------------------------------
   */

   if ::GetItemCheckState( "Ventas por artículos" )

      oDbvArticulos     := TDbVirtual( , "Imp" ):DefNew()
         oDbvArticulos:AddField( "cCodArt", "C", 14, 0 )
         oDbvArticulos:AddField( "cNomArt", "C", 50, 0 )
         oDbvArticulos:AddField( "nUndArt", "N", 19, 6 )
         oDbvArticulos:AddField( "nPvpArt", "N", 19, 6 )
         oDbvArticulos:AddField( "nImpArt", "N", 19, 6 )
      oDbvArticulos:Activate()

      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            do case
               case ::oTikT:cTipTik == SAVTIK

                  if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                     while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                        if ::oTikL:nCtlStk != 2

                           if oDbvArticulos:Seek( ::oTikL:cCbaTil )
                              oDbvArticulos:nUndArt += ::oTikL:nUntTil
                              oDbvArticulos:nImpArt += nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv )
                           else
                              oDbvArticulos:Append()
                              oDbvArticulos:cCodArt := ::oTikL:cCbaTil
                              oDbvArticulos:cNomArt := ::oTikL:cNomTil
                              oDbvArticulos:nUndArt := ::oTikL:nUntTil
                              oDbvArticulos:nPvpArt := nImpUTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv )
                              oDbvArticulos:nImpArt := nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv )
                           end if

                        end if

                        ::oTikL:Skip()

                        SysRefresh()

                     end while

                  end if

               case ::oTikT:cTipTik == SAVTIK

                  if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                     while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                        if ::oTikL:nCtlStk != 2

                           if oDbvArticulos:Seek( ::oTikL:cCbaTil )
                              oDbvArticulos:nUndArt -= ::oTikL:nUntTil
                              oDbvArticulos:nImpArt -= nTotLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv )
                           else
                              oDbvArticulos:Append()
                              oDbvArticulos:cCodArt := ::oTikL:cCbaTil
                              oDbvArticulos:cNomArt := ::oTikL:cNomTil
                              oDbvArticulos:nUndArt := - ::oTikL:nUntTil
                              oDbvArticulos:nPvpArt := - nTotUTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv )
                              oDbvArticulos:nImpArt := - nTotLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv )
                           end if

                        end if

                        ::oTikL:Skip()

                        SysRefresh()

                     end while

                  end if

            end case

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Albaranes ------------------------------------------------------------------
      */

      if ::oAlbCliT:Seek( cTurnoCaja )

         while ::oAlbCliT:cTurAlb + ::oAlbCliT:cSufAlb + ::oAlbCliT:cCodCaj == cTurnoCaja .and. !::oAlbCliT:eof()

            if !lFacturado( ::oAlbCliT ) .and. ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

               while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb .and. !::oAlbCliL:eof()

                  if ::oAlbCliL:nCtlStk != 2

                     if oDbvArticulos:Seek( ::oAlbCliL:cRef )
                        oDbvArticulos:nUndArt += nTotNAlbCli( ::oAlbCliL:cAlias )
                        oDbvArticulos:nImpArt += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDouDiv, ::nDorDiv )
                     else
                        oDbvArticulos:Append()
                        oDbvArticulos:cCodArt := ::oAlbCliL:cRef
                        oDbvArticulos:cNomArt := ::oAlbCliL:cDetalle
                        oDbvArticulos:nUndArt := nTotNAlbCli( ::oAlbCliL:cAlias )
                        oDbvArticulos:nPvpArt := nImpUAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDouDiv )
                        oDbvArticulos:nImpArt := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDouDiv, ::nDorDiv )
                     end if

                  end if

                  ::oAlbCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oAlbCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas--------------------------------------------------------------------
      */

      if ::oFacCliT:Seek( cTurnoCaja )

         while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac + ::oFacCliT:cCodCaj == cTurnoCaja .and. !::oFacCliT:eof()

            if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

               while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and. !::oFacCliL:eof()

                  if ::oFacCliL:nCtlStk != 2

                     if oDbvArticulos:Seek(  ::oFacCliL:cRef )
                        oDbvArticulos:nUndArt += nTotNFacCli( ::oFacCliL:cAlias, ::nDouDiv )
                        oDbvArticulos:nImpArt += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDouDiv, ::nDorDiv )
                     else
                        oDbvArticulos:Append()
                        oDbvArticulos:cCodArt := ::oFacCliL:cRef
                        oDbvArticulos:cNomArt := ::oFacCliL:cDetalle
                        oDbvArticulos:nUndArt := nTotNFacCli( ::oFacCliL:cAlias )
                        oDbvArticulos:nPvpArt := nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDouDiv )
                        oDbvArticulos:nImpArt := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDouDiv, ::nDorDiv )
                     end if

                  end if

                  ::oFacCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oFacCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas--------------------------------------------------------------------
      */

      if ::oRctCliT:Seek( cTurnoCaja )

         while ::oRctCliT:cTurFac + ::oRctCliT:cSufFac + ::oRctCliT:cCodCaj == cTurnoCaja .and. !::oRctCliT:eof()

            if ::oRctCliL:Seek( ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac )

               while ::oRctCliL:cSerie + Str( ::oRctCliL:nNumFac ) + ::oRctCliL:cSufFac == ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac .and. !::oRctCliL:eof()

                  if ::oRctCliL:nCtlStk != 2

                     if oDbvArticulos:Seek(  ::oRctCliL:cRef )
                        oDbvArticulos:nUndArt += nTotNFacRec( ::oRctCliL:cAlias, ::nDouDiv )
                        oDbvArticulos:nImpArt += nImpLFacRec( ::oRctCliT:cAlias, ::oRctCliL:cAlias, ::nDouDiv, ::nDorDiv )
                     else
                        oDbvArticulos:Append()
                        oDbvArticulos:cCodArt := ::oRctCliL:cRef
                        oDbvArticulos:cNomArt := ::oRctCliL:cDetalle
                        oDbvArticulos:nUndArt := nTotNFacRec( ::oRctCliL:cAlias )
                        oDbvArticulos:nPvpArt := nImpUFacRec( ::oRctCliT:cAlias, ::oRctCliL:cAlias, ::nDouDiv )
                        oDbvArticulos:nImpArt := nImpLFacRec( ::oRctCliT:cAlias, ::oRctCliL:cAlias, ::nDouDiv, ::nDorDiv )
                     end if

                  end if

                  ::oRctCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oRctCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Los colocamos en el temporal
      */

      oDbvArticulos:GoTop()
      while !oDbvArticulos:eof()

         ::AppendInTemporal( nil, Rtrim( oDbvArticulos:cCodArt ) + Space( 1 ) + Rtrim( oDbvArticulos:cNomArt ) + Space( 1 ) + "[Und.:" + Ltrim( Trans( oDbvArticulos:nUndArt, ::cPicUnd ) ) + "]", oDbvArticulos:nImpArt )

         oDbvArticulos:Skip()

         SysRefresh()

      end while

   end if

   /*
   Ventas por salas---------------------------------------------------------
   */

   if ::GetItemCheckState( "Ventas por salas" ) .and. !empty( ::getTpvRestaurante() )

      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            do case
               case ::oTikT:cTipTik == SAVTIK

                  if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                     while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                        ::AppendInTemporal( ::oTikT:cCodSala, Rtrim( ::oTikT:cCodSala ) + Space( 1 ) + Rtrim( oRetFld( ::oTikT:cCodSala, ::getTpvRestaurante():oDbf ) ), nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv ) )

                        ::oTikL:Skip()

                        SysRefresh()

                     end while

                  end if

               case ::oTikT:cTipTik == SAVDEV

                  if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                     while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                        ::AppendInTemporal( ::oTikT:cCodSala, Rtrim( ::oTikT:cCodSala ) + Space( 1 ) + Rtrim( oRetFld( ::oTikT:cCodSala, ::getTpvRestaurante():oDbf ) ), - nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv ) )

                        ::oTikL:Skip()

                        SysRefresh()

                     end while

                  end if

            end case

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Ventas por familias---------------------------------------------------------
   */

   if ::GetItemCheckState( "Ventas por familias" )

      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            do case
               case ::oTikT:cTipTik == SAVTIK

                  if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                     while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                        ::AppendInTemporal( ::oTikL:cCodFam, Rtrim( ::oTikL:cCodFam ) + Space( 1 ) + Rtrim( oRetFld( ::oTikL:cCodFam, ::oFamilia ) ), nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv ) )

                        ::oTikL:Skip()

                        SysRefresh()

                     end while

                  end if

               case ::oTikT:cTipTik == SAVDEV

                  if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                     while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                        ::AppendInTemporal( ::oTikL:cCodFam, Rtrim( ::oTikL:cCodFam ) + Space( 1 ) + Rtrim( oRetFld( ::oTikL:cCodFam, ::oFamilia ) ), - nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv ) )

                        ::oTikL:Skip()

                        SysRefresh()

                     end while

                  end if

            end case

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Albaranes ------------------------------------------------------------------
      */

      if ::oAlbCliT:Seek( cTurnoCaja )

         while ::oAlbCliT:cTurAlb + ::oAlbCliT:cSufAlb + ::oAlbCliT:cCodCaj == cTurnoCaja .and. !::oAlbCliT:eof()

            if !lFacturado( ::oAlbCliT ) .and. ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

               while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb .and. !::oAlbCliL:eof()

                  ::AppendInTemporal( ::oAlbCliL:cCodFam, Rtrim( ::oAlbCliL:cCodFam ) + Space( 1 ) + Rtrim( oRetFld( ::oAlbCliL:cCodFam, ::oFamilia ) ), nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDouDiv, ::nRouDiv ) )

                  ::oAlbCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oAlbCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas--------------------------------------------------------------------
      */

      if ::oFacCliT:Seek( cTurnoCaja )

         while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac + ::oFacCliT:cCodCaj == cTurnoCaja .and. !::oFacCliT:eof()

            if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

               while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and. !::oFacCliL:eof()

                  ::AppendInTemporal( ::oFacCliL:cCodFam, Rtrim( ::oFacCliL:cCodFam ) + Space( 1 ) + Rtrim( oRetFld( ::oFacCliL:cCodFam, ::oFamilia ) ), nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDouDiv, ::nDorDiv ) )

                  ::oFacCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oFacCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas rectificativas--------------------------------------------------
      */

      if ::oRctCliT:Seek( cTurnoCaja )

         while ::oRctCliT:cTurFac + ::oRctCliT:cSufFac + ::oRctCliT:cCodCaj == cTurnoCaja .and. !::oRctCliT:eof()

            if ::oRctCliL:Seek( ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac )

               while ::oRctCliL:cSerie + Str( ::oRctCliL:nNumFac ) + ::oRctCliL:cSufFac == ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac .and. !::oRctCliL:eof()

                  ::AppendInTemporal( ::oRctCliL:cCodFam, Rtrim( ::oRctCliL:cCodFam ) + Space( 1 ) + Rtrim( oRetFld( ::oRctCliL:cCodFam, ::oFamilia ) ), nImpLFacRec( ::oRctCliT:cAlias, ::oRctCliL:cAlias, ::nDouDiv, ::nDorDiv ) )

                  ::oRctCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oRctCliT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Ventas por fabricante-------------------------------------------------------
   */

   if ::GetItemCheckState( "Ventas por fabricante" )

      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            do case
               case ::oTikT:cTipTik == SAVTIK

                  if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                     while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                        ::AppendInTemporal( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodFab" ), Rtrim( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodFab" ) ) + Space( 1 ) + Rtrim( oRetFld( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodFab" ), ::oFabricante:oDbf, "cCodFab" ) ), nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv ) )

                        ::oTikL:Skip()

                        SysRefresh()

                     end while

                  end if

               case ::oTikT:cTipTik == SAVDEV

                  if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                     while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                        ::AppendInTemporal( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodFab" ), Rtrim( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodFab" ) ) + Space( 1 ) + Rtrim( oRetFld( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodFab" ), ::oFabricante:oDbf, "cCodFab" ) ), - nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv ) )

                        ::oTikL:Skip()

                        SysRefresh()

                     end while

                  end if

            end case

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Albaranes ------------------------------------------------------------------
      */

      if ::oAlbCliT:Seek( cTurnoCaja )

         while ::oAlbCliT:cTurAlb + ::oAlbCliT:cSufAlb + ::oAlbCliT:cCodCaj == cTurnoCaja .and. !::oAlbCliT:eof()

            if !lFacturado( ::oAlbCliT ) .and. ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

               while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb .and. !::oAlbCliL:eof()

                  ::AppendInTemporal( oRetFld( ::oAlbCliL:cRef, ::oArticulo, "cCodFab" ), Rtrim( oRetFld( ::oAlbCliL:cRef, ::oArticulo, "cCodFab" ) ) + Space( 1 ) + Rtrim( oRetFld( oRetFld( ::oAlbCliL:cRef, ::oArticulo, "cCodFab" ), ::oFabricante:oDbf ) ), nImpLAlbCli( ::oAlbCliT:cAlias,  ::oAlbCliL:cAlias, ::nDouDiv, ::nDorDiv ) )

                  ::oAlbCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oAlbCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas--------------------------------------------------------------------
      */

      if ::oFacCliT:Seek( cTurnoCaja )

         while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac + ::oFacCliT:cCodCaj == cTurnoCaja .and. !::oFacCliT:eof()

            if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

               while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and. !::oFacCliL:eof()

                  ::AppendInTemporal( oRetFld( ::oFacCliL:cRef, ::oArticulo, "cCodFab" ), Rtrim( oRetFld( ::oFacCliL:cRef, ::oArticulo, "cCodFab" ) ) + Space( 1 ) + Rtrim( oRetFld( oRetFld( ::oFacCliL:cRef, ::oArticulo, "cCodFab" ), ::oFabricante:oDbf ) ), nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDouDiv, ::nDorDiv ) )

                  ::oFacCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oFacCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas--------------------------------------------------------------------
      */

      if ::oRctCliT:Seek( cTurnoCaja )

         while ::oRctCliT:cTurFac + ::oRctCliT:cSufFac + ::oRctCliT:cCodCaj == cTurnoCaja .and. !::oRctCliT:eof()

            if ::oRctCliL:Seek( ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac )

               while ::oRctCliL:cSerie + Str( ::oRctCliL:nNumFac ) + ::oRctCliL:cSufFac == ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac .and. !::oRctCliL:eof()

                  ::AppendInTemporal( oRetFld( ::oRctCliL:cRef, ::oArticulo, "cCodFab" ), Rtrim( oRetFld( ::oRctCliL:cRef, ::oArticulo, "cCodFab" ) ) + Space( 1 ) + Rtrim( oRetFld( oRetFld( ::oRctCliL:cRef, ::oArticulo, "cCodFab" ), ::oFabricante:oDbf ) ), nImpLFacRec( ::oRctCliT:cAlias, ::oRctCliL:cAlias, ::nDouDiv, ::nDorDiv ) )

                  ::oRctCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oRctCliT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Ventas por temporada--------------------------------------------------------
   */

   if ::GetItemCheckState( "Ventas por " + getConfigTraslation( "temporada" ) )

      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            do case
               case ::oTikT:cTipTik == SAVTIK

                  if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                     while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                        ::AppendInTemporal( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodTemp" ), Rtrim( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodTemp" ) ) + Space( 1 ) + Rtrim( oRetFld( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodTemp" ), ::oTemporada ) ), nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv ) )

                        ::oTikL:Skip()

                        SysRefresh()

                     end while

                  end if

               case ::oTikT:cTipTik == SAVDEV

                  if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                     while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                        ::AppendInTemporal( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodTemp" ), Rtrim( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodTemp" ) ) + Space( 1 ) + Rtrim( oRetFld( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodTemp" ), ::oTemporada ) ), - nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv ) )

                        ::oTikL:Skip()

                        SysRefresh()

                     end while

                  end if

            end case

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Albaranes ------------------------------------------------------------------
      */

      if ::oAlbCliT:Seek( cTurnoCaja )

         while ::oAlbCliT:cTurAlb + ::oAlbCliT:cSufAlb + ::oAlbCliT:cCodCaj == cTurnoCaja .and. !::oAlbCliT:eof()

            if !lFacturado( ::oAlbCliT ) .and. ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

               while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb .and. !::oAlbCliL:eof()

                  ::AppendInTemporal( oRetFld( ::oAlbCliL:cRef, ::oArticulo, "cCodTemp" ), Rtrim( oRetFld( ::oAlbCliL:cRef, ::oArticulo, "cCodTemp" ) ) + Space( 1 ) + Rtrim( oRetFld( oRetFld( ::oAlbCliL:cRef, ::oArticulo, "cCodTemp" ), ::oTemporada ) ), nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDouDiv, ::nDorDiv ) )

                  ::oAlbCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oAlbCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas--------------------------------------------------------------------
      */

      if ::oFacCliT:Seek( cTurnoCaja )

         while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac + ::oFacCliT:cCodCaj == cTurnoCaja .and. !::oFacCliT:eof()

            if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

               while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and. !::oFacCliL:eof()

                  ::AppendInTemporal( oRetFld( ::oFacCliL:cRef, ::oArticulo, "cCodTemp" ), Rtrim( oRetFld( ::oFacCliL:cRef, ::oArticulo, "cCodTemp" ) ) + Space( 1 ) + Rtrim( oRetFld( oRetFld( ::oFacCliL:cRef, ::oArticulo, "cCodTemp" ), ::oTemporada ) ), nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDouDiv, ::nDorDiv ) )

                  ::oFacCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oFacCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas--------------------------------------------------------------------
      */

      if ::oRctCliT:Seek( cTurnoCaja )

         while ::oRctCliT:cTurFac + ::oRctCliT:cSufFac + ::oRctCliT:cCodCaj == cTurnoCaja .and. !::oRctCliT:eof()

            if ::oRctCliL:Seek( ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac )

               while ::oRctCliL:cSerie + Str( ::oRctCliL:nNumFac ) + ::oRctCliL:cSufFac == ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac .and. !::oRctCliL:eof()

                  ::AppendInTemporal( oRetFld( ::oRctCliL:cRef, ::oArticulo, "cCodTemp" ), Rtrim( oRetFld( ::oRctCliL:cRef, ::oArticulo, "cCodTemp" ) ) + Space( 1 ) + Rtrim( oRetFld( oRetFld( ::oRctCliL:cRef, ::oArticulo, "cCodTemp" ), ::oTemporada ) ), nImpLFacRec( ::oRctCliT:cAlias, ::oRctCliL:cAlias, ::nDouDiv, ::nDorDiv ) )

                  ::oRctCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oRctCliT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Ventas por tipo de articulos------------------------------------------------
   */

   if ::GetItemCheckState( "Ventas por tipo de artículos" )

      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            do case
               case ::oTikT:cTipTik == SAVTIK

                  if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                     while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                        ::AppendInTemporal( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodTip" ), oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodTip" ) + Space( 1 ) + oRetFld( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodTip" ), ::oTipArt:oDbf, "cNomTip" ), nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv ) )

                        ::oTikL:Skip()

                        SysRefresh()

                     end while

                  end if

               case ::oTikT:cTipTik == SAVDEV

                  if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

                     while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                        ::AppendInTemporal( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodTip" ), oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodTip" ) + Space( 1 ) + oRetFld( oRetFld( ::oTikL:cCbaTil, ::oArticulo, "cCodTip" ), ::oTipArt:oDbf, "cNomTip" ), - nImpLTpv( ::oTikT:cAlias, ::oTikL:cAlias, ::nDouDiv, ::nDorDiv ) )

                        ::oTikL:Skip()

                        SysRefresh()

                     end while

                  end if

            end case

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Albaranes ------------------------------------------------------------------
      */

      if ::oAlbCliT:Seek( cTurnoCaja )

         while ::oAlbCliT:cTurAlb + ::oAlbCliT:cSufAlb + ::oAlbCliT:cCodCaj == cTurnoCaja .and. !::oAlbCliT:eof()

            if !lFacturado( ::oAlbCliT ) .and. ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

               while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb .and. !::oAlbCliL:eof()

                  ::AppendInTemporal( ::oAlbCliL:cCodTip, Rtrim( ::oAlbCliL:cCodTip ) + Space( 1 ) + Rtrim( oRetFld( ::oAlbCliL:cCodTip, ::oTipArt:oDbf ) ), nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDouDiv, ::nDorDiv ) )

                  ::oAlbCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oAlbCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas--------------------------------------------------------------------
      */

      if ::oFacCliT:Seek( cTurnoCaja )

         while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac + ::oFacCliT:cCodCaj == cTurnoCaja .and. !::oFacCliT:eof()

            if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

               while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and. !::oFacCliL:eof()

                  ::AppendInTemporal( ::oFacCliL:cCodTip, Rtrim( ::oFacCliL:cCodTip ) + Space( 1 ) + Rtrim( oRetFld( ::oFacCliL:cCodTip, ::oTipArt:oDbf ) ), nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDouDiv, ::nDorDiv ) )

                  ::oFacCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oFacCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas--------------------------------------------------------------------
      */

      if ::oRctCliT:Seek( cTurnoCaja )

         while ::oRctCliT:cTurFac + ::oRctCliT:cSufFac + ::oRctCliT:cCodCaj == cTurnoCaja .and. !::oRctCliT:eof()

            if ::oRctCliL:Seek( ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac )

               while ::oRctCliL:cSerie + Str( ::oRctCliL:nNumFac ) + ::oRctCliL:cSufFac == ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac .and. !::oRctCliL:eof()

                  ::AppendInTemporal( ::oRctCliL:cCodTip, Rtrim( ::oRctCliL:cCodTip ) + Space( 1 ) + Rtrim( oRetFld( ::oRctCliL:cCodTip, ::oTipArt:oDbf ) ), nImpLFacRec( ::oRctCliT:cAlias, ::oRctCliL:cAlias, ::nDouDiv, ::nDorDiv ) )

                  ::oRctCliL:Skip()

                  SysRefresh()

               end while

            end if

            ::oRctCliT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Ventas por usuarios---------------------------------------------------------
   */

   if ::GetItemCheckState( "Ventas por usuarios" )

      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            do case
               case ::oTikT:cTipTik == SAVTIK

                   ::AppendInTemporal( ::oTikT:cCcjTik, Rtrim( ::oTikT:cCcjTik ) + Space( 1 ) + Rtrim( RetUser( ::oTikT:cCcjTik, ::oUser:cAlias ) ), nTotTik( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik, ::oTikT:cAlias, ::oTikL:cAlias, ::oDbfDiv:cAlias, nil, cDivEmp(), .f., .t. ) )

               case ::oTikT:cTipTik == SAVDEV

                   ::AppendInTemporal( ::oTikT:cCcjTik, Rtrim( ::oTikT:cCcjTik ) + Space( 1 ) + Rtrim( RetUser( ::oTikT:cCcjTik, ::oUser:cAlias ) ), - nTotTik( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik, ::oTikT:cAlias, ::oTikL:cAlias, ::oDbfDiv:cAlias, nil, cDivEmp(), .f., .t. ) )

            end case

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Albaranes ------------------------------------------------------------------
      */

      if ::oAlbCliT:Seek( cTurnoCaja )

         while ::oAlbCliT:cTurAlb + ::oAlbCliT:cSufAlb + ::oAlbCliT:cCodCaj == cTurnoCaja .and. !::oAlbCliT:eof()

            if !lFacturado( ::oAlbCliT )
               ::AppendInTemporal( ::oAlbCliT:cCodUsr, Rtrim( ::oAlbCliT:cCodUsr ) + Space( 1 ) + Rtrim( RetUser( ::oAlbCliT:cCodUsr, ::oUser:cAlias ) ), nTotAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oIvaImp:cAlias, ::oDbfDiv:cAlias, nil, cDivEmp(), .f., .t. ) )
            end if

            ::oAlbCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas--------------------------------------------------------------------
      */

      if ::oFacCliT:Seek( cTurnoCaja )

         while ::oFacCliT:cTurFac + ::oFacCliT:cSufFac + ::oFacCliT:cCodCaj == cTurnoCaja .and. !::oFacCliT:eof()

            ::AppendInTemporal( ::oFacCliT:cCodUsr, Rtrim( ::oFacCliT:cCodUsr ) + Space( 1 ) + Rtrim( RetUser( ::oFacCliT:cCodUsr, ::oUser:cAlias ) ), nTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oIvaImp:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, nil, cDivEmp(), .f., .t. ) )

            ::oFacCliT:Skip()

            SysRefresh()

         end while

      end if

      /*
      Facturas rectificativas--------------------------------------------------
      */

      if ::oRctCliT:Seek( cTurnoCaja )

         while ::oRctCliT:cTurFac + ::oRctCliT:cSufFac + ::oRctCliT:cCodCaj == cTurnoCaja .and. !::oRctCliT:eof()

            ::AppendInTemporal( ::oRctCliT:cCodUsr, Rtrim( ::oRctCliT:cCodUsr ) + Space( 1 ) + Rtrim( RetUser( ::oRctCliT:cCodUsr, ::oUser:cAlias ) ), nTotFacRec( ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac, ::oRctCliT:cAlias, ::oRctCliL:cAlias, ::oIvaImp:cAlias, ::oDbfDiv:cAlias, nil, cDivEmp(), .f., .t. ) )

            ::oRctCliT:Skip()

            SysRefresh()

         end while

      end if

   end if

   /*
   Ventas por familias---------------------------------------------------------
   */

   if ::GetItemCheckState( "Ventas por tipos de " + cImp() )

      for n := 1 to len( ::aTipIva )

      ::AppendInTemporal(  nil,;
                           "Base " + lTrim( Trans( ::aTipIva[ n, 2 ], ::cPorDiv ) )    + Space( 1 ) + ;
                           "al " + Trans( ::aTipIva[ n, 1 ], "@E 99.9%" )              + Space( 1 ) + ;
                           "cuota " + lTrim( Trans( ::aTipIva[ n, 3 ], ::cPorDiv ) ),;
                           ::aTipIva[ n, 4 ] )

      next

   end if

   /*
   Ventas por tipos de invitaciones--------------------------------------------
   */

   ::oTikL:GoTop()

   if ::GetItemCheckState( "Ventas por tipo de invitaciones" )

      if ::oTikT:Seek( cTurnoCaja )

         while ::oTikT:cTurTik + ::oTikT:cSufTik + ::oTikT:cNcjTik == cTurnoCaja .and. !::oTikT:eof()

            if ::oTikL:Seek( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

               while ::oTikL:cSerTil + ::oTikL:cNumTil + ::oTikL:cSufTil == ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik .and. !::oTikL:eof()

                  if !empty( ::oTikL:cCodInv )

                     ::AppendInTemporal(  ::oTikL:cCodInv, Rtrim( ::oTikL:cCodInv ) + Space( 1 ) + AllTrim( oRetFld( ::oTikL:cCodInv, ::oTipInv:oDbf ) ), ::oTikL:nUntTil )

                  end if

                  ::oTikL:Skip()

                  SysRefresh()

               end while

            end if

            ::oTikT:Skip()

            SysRefresh()

         end while

      end if

   end if

   ::oDbfTemporal:GoTop()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD bEdtAlbaranCliente()

   local cNumeroDocumento  := by( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

Return ( {|| EdtAlbCli( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtFacturaCliente()

   local cNumeroDocumento  := by( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

Return ( {|| EdtFacCli( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtFacturaRectificativaCliente()

   local cNumeroDocumento  := by( ::oRctCliT:cSerie + Str( ::oRctCliT:nNumFac ) + ::oRctCliT:cSufFac )

Return ( {|| EdtFacRec( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtTiketCliente()

   local cNumeroDocumento  := by( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

   if ( "TPV" $ appParamsMain() )
      Return ( {|| InitTikCli( cNumeroDocumento ) } )
   end if

Return ( { || EdtTikCli( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bZooTiketCliente()

   local cNumeroDocumento  := by( ::oTikT:cSerTik + ::oTikT:cNumTik + ::oTikT:cSufTik )

Return ( { || ZooTikCli( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtAnticipoCliente()

   local cNumeroDocumento  := by( ::oAntCliT:cSerAnt + Str( ::oAntCliT:nNumAnt ) + ::oAntCliT:cSufAnt )

Return ( {|| EdtAntCli( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtAlbaranProveedor()

   local cNumeroDocumento  := by( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

Return ( {|| EdtAlbPrv( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtFacturaProveedor()

   local cNumeroDocumento  := by( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

Return ( {|| EdtFacPrv( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtFacturaRectificativaProveedor()

   local cNumeroDocumento  := by( ::oRctPrvT:cSerFac + Str( ::oRctPrvT:nNumFac ) + ::oRctPrvT:cSufFac )

Return ( {|| EdtRctPrv( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtTiketCobro()

   local cNumeroDocumento  := by( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik )

Return ( {|| EdtTikCli( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bZooTiketCobro()

   local cNumeroDocumento  := by( ::oTikP:cSerTik + ::oTikP:cNumTik + ::oTikP:cSufTik )

Return ( {|| ZooTikCli( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtFacturaCobro()

   local cNumeroDocumento  := ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac

   if !empty( ::oFacCliP:cTipRec )
      Return ( {|| EdtFacRec( cNumeroDocumento ) } )
   end if

Return ( {|| EdtFacCli( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtPedidoEntrega()

   local cNumeroDocumento  := ::oPedCliT:cSerPed + Str( ::oPedCliP:nNumPed ) + ::oPedCliP:cSufPed

Return ( {|| EdtPedCli( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtAlbaranEntrega()

   local cNumeroDocumento  := ::oAlbCliP:cSerAlb + Str( ::oAlbCliP:nNumAlb ) +::oAlbCliP:cSufAlb

Return ( {|| EdtAlbCli( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtEntradasSalidas()

   local cNumeroDocumento  := ::oEntSal:Recno()

Return ( {|| EdtEntSal( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD bEdtFacturaPago()

   local cNumeroDocumento  := ::oFacPrvP:cSerFac + Str( ::oFacPrvP:nNumFac ) + ::oFacPrvP:cSufFac

   if !empty( ::oFacPrvP:cTipRec )
      Return ( {|| EdtRctPrv( cNumeroDocumento ) } )
   end if

Return ( {|| EdtFacPrv( cNumeroDocumento ) } )

//---------------------------------------------------------------------------//

METHOD ContabilizaSesiones()

   local oSerDocIni
   local oNumDocIni
   local oSufDocIni
   local oSerDocFin
   local oNumDocFin
   local oSufDocFin
   local cPicture                := "999999999"
   local oImageList
   local oGetEmpresaContaplus
   local oGetProjectoContaplus
   local oSayEmpresaContaplus
   local cSayEmpresaContaplus
   local oSayProjecto
   local cSayProjecto            := ""
   local oBmpContabilidad
   local nMtrProcess             := 0
   local nMtrSelect              := 0

   oImageList                    := TImageList():New( 16, 16 )
   oImageList:AddMasked( TBitmap():Define( "bRed" ), Rgb( 255, 0, 255 ) )
   oImageList:AddMasked( TBitmap():Define( "bGreen" ), Rgb( 255, 0, 255 ) )

   ::nNumDocIni                  := ::oDbf:FieldGetName( ::cNumDocKey )
   ::nNumDocFin                  := ::oDbf:FieldGetName( ::cNumDocKey )
   ::cSufDocIni                  := ::oDbf:FieldGetName( ::cSufDocKey )
   ::cSufDocFin                  := ::oDbf:FieldGetName( ::cSufDocKey )

   ::cGetEmpresaContaplus        := cEmpCnt()
   cSayEmpresaContaplus          := ChkEmpresaContaplus( cRutCnt(), cEmpCnt() )

   ::cGetProjectoContaplus       := cProCnt()
   cSayProjecto                  := ChkProyecto( cProCnt(), nil, cRutCnt(), cEmpCnt() )

   if ValType( ::nNumDocIni ) == "C"
      ::lNumDocChr               := .t.
      ::nLenDocIni               := Len( ::nNumDocIni )
      ::nNumDocIni               := Val( Trans( ::nNumDocIni, cPicture ) )
      ::nNumDocFin               := Val( Trans( ::nNumDocFin, cPicture ) )
   else
      ::nLenDocIni               := Len( Str( ::nNumDocIni ) )
   end if

   cPicture                      := Replicate( "9", ::nLenDocIni )

   DEFINE DIALOG ::oDlgSelect RESOURCE "ContabilizaSesion"

   REDEFINE BITMAP oBmpContabilidad ;
      ID       500 ;
      RESOURCE "gc_folders2_48" ;
      TRANSPARENT ;
      OF       ::oDlgSelect

   REDEFINE CHECKBOX ::lAllSesions ;
      ID       90 ;
      OF       ::oDlgSelect

   REDEFINE GET oNumDocIni ;
      VAR      ::nNumDocIni ;
      ID       100 ;
      WHEN     !::lAllSesions ;
      PICTURE  cPicture ;
      SPINNER ;
      OF       ::oDlgSelect

   REDEFINE GET oSufDocIni ;
      VAR      ::cSufDocIni ;
      ID       101 ;
      WHEN     !::lAllSesions ;
      OF       ::oDlgSelect

   REDEFINE GET oNumDocFin ;
      VAR      ::nNumDocFin ;
      ID       110 ;
      WHEN     !::lAllSesions ;
      PICTURE  cPicture ;
      SPINNER ;
      OF       ::oDlgSelect

   REDEFINE GET oSufDocFin ;
      VAR      ::cSufDocFin ;
      ID       111 ;
      WHEN     !::lAllSesions ;
      OF       ::oDlgSelect

   /*
   Fechas----------------------------------------------------------------------
   */

   REDEFINE GET ::oFechaInicio ;
      VAR      ::dFechaInicio ;
      SPINNER ;
      ID       120 ;
      OF       ::oDlgSelect

   REDEFINE GET ::oFechaFin ;
      VAR      ::dFechaFin ;
      SPINNER ;
      ID       130 ;
      OF       ::oDlgSelect

   /*
   Empresa contaplus para contadores-------------------------------------------
   */

   REDEFINE GET oGetEmpresaContaplus ;
      VAR      ::cGetEmpresaContaplus ;
      ID       140 ;
      PICTURE  "@!" ;
      BITMAP   "LUPA" ;
      OF       ::oDlgSelect

      oGetEmpresaContaplus:bValid   := {|| ChkEmpresaContaplus( cRutCnt(), ::cGetEmpresaContaplus, oSayEmpresaContaplus ), .t. }
      oGetEmpresaContaplus:bHelp    := {|| BrwEmpresaContaplus( cRutCnt(), oGetEmpresaContaplus ) }

   REDEFINE GET oSayEmpresaContaplus ;
      VAR      cSayEmpresaContaplus ;
      ID       141 ;
      WHEN     .f. ;
      PICTURE  "@!" ;
      OF       ::oDlgSelect

   REDEFINE GET oGetProjectoContaplus ;
      VAR      ::cGetProjectoContaplus ;
      ID       150 ;
      PICTURE  "@R ###.######" ;
      BITMAP   "LUPA" ;
      OF       ::oDlgSelect

      oGetProjectoContaplus:bValid  := {|| ChkProyecto( ::cGetProjectoContaplus, oSayProjecto, cRutCnt(), ::cGetEmpresaContaplus ), .t. }
      oGetProjectoContaplus:bHelp   := {|| BrwProyecto( oGetProjectoContaplus, oSayProjecto, cRutCnt(), ::cGetEmpresaContaplus ) }

   REDEFINE GET oSayProjecto ;
      VAR      cSayProjecto ;
      ID       151 ;
      WHEN     .f.;
      OF       ::oDlgSelect

   /*
   Elementos q vamos a contabiliazar-------------------------------------------
   */

   REDEFINE CHECKBOX ::oChkSimula ;
      VAR      ::lChkSimula ;
      ID       160 ;
      OF       ::oDlgSelect

   REDEFINE CHECKBOX ::lChkContabilizarFacturasProveedores ;
      ID       170 ;
      OF       ::oDlgSelect

   REDEFINE CHECKBOX ::lChkContabilizarRectificativasProveedores ;
      ID       171 ;
      OF       ::oDlgSelect

   REDEFINE CHECKBOX ::lChkContabilizarPagosProveedores ;
      ID       172 ;
      OF       ::oDlgSelect

   REDEFINE CHECKBOX ::lChkContabilizarFactura ;
      ID       173 ;
      OF       ::oDlgSelect

   REDEFINE CHECKBOX ::lChkContabilizarRectificativa ;
      ID       174 ;
      OF       ::oDlgSelect

   REDEFINE CHECKBOX ::lChkContabilizarAnticipos ;
      ID       175 ;
      OF       ::oDlgSelect

   REDEFINE CHECKBOX ::lChkContabilizarTicket ;
      ID       176 ;
      OF       ::oDlgSelect

   REDEFINE CHECKBOX ::lChkContabilizarCobros ;
      ID       177 ;
      OF       ::oDlgSelect

   REDEFINE CHECKBOX ::lChkContabilizarContadores ;
      ID       178 ;
      OF       ::oDlgSelect

   /*
   Series de facturas----------------------------------------------------------
   */

   TWebBtn():Redefine(1170,,,,, {|This| ( aEval( ::oSer, {|o| Eval( o:bSetGet, .t. ), o:refresh() } ) ) }, ::oDlgSelect,,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ) ):SetTransparent()

   TWebBtn():Redefine(1180,,,,, {|This| ( aEval( ::oSer, {|o| Eval( o:bSetGet, .f. ), o:refresh() } ) ) }, ::oDlgSelect,,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ) ):SetTransparent()

   REDEFINE CHECKBOX ::oSer[  1 ] VAR ::aSer[  1 ] ID 1190 OF ::oDlgSelect //A
   REDEFINE CHECKBOX ::oSer[  2 ] VAR ::aSer[  2 ] ID 1200 OF ::oDlgSelect //B
   REDEFINE CHECKBOX ::oSer[  3 ] VAR ::aSer[  3 ] ID 1210 OF ::oDlgSelect //C
   REDEFINE CHECKBOX ::oSer[  4 ] VAR ::aSer[  4 ] ID 1220 OF ::oDlgSelect //D
   REDEFINE CHECKBOX ::oSer[  5 ] VAR ::aSer[  5 ] ID 1230 OF ::oDlgSelect //E
   REDEFINE CHECKBOX ::oSer[  6 ] VAR ::aSer[  6 ] ID 1240 OF ::oDlgSelect //F
   REDEFINE CHECKBOX ::oSer[  7 ] VAR ::aSer[  7 ] ID 1250 OF ::oDlgSelect //G
   REDEFINE CHECKBOX ::oSer[  8 ] VAR ::aSer[  8 ] ID 1260 OF ::oDlgSelect //H
   REDEFINE CHECKBOX ::oSer[  9 ] VAR ::aSer[  9 ] ID 1270 OF ::oDlgSelect //I
   REDEFINE CHECKBOX ::oSer[ 10 ] VAR ::aSer[ 10 ] ID 1280 OF ::oDlgSelect //J
   REDEFINE CHECKBOX ::oSer[ 11 ] VAR ::aSer[ 11 ] ID 1290 OF ::oDlgSelect //K
   REDEFINE CHECKBOX ::oSer[ 12 ] VAR ::aSer[ 12 ] ID 1300 OF ::oDlgSelect //L
   REDEFINE CHECKBOX ::oSer[ 13 ] VAR ::aSer[ 13 ] ID 1310 OF ::oDlgSelect //M
   REDEFINE CHECKBOX ::oSer[ 14 ] VAR ::aSer[ 14 ] ID 1320 OF ::oDlgSelect //N
   REDEFINE CHECKBOX ::oSer[ 15 ] VAR ::aSer[ 15 ] ID 1330 OF ::oDlgSelect //O
   REDEFINE CHECKBOX ::oSer[ 16 ] VAR ::aSer[ 16 ] ID 1340 OF ::oDlgSelect //P
   REDEFINE CHECKBOX ::oSer[ 17 ] VAR ::aSer[ 17 ] ID 1350 OF ::oDlgSelect //Q
   REDEFINE CHECKBOX ::oSer[ 18 ] VAR ::aSer[ 18 ] ID 1360 OF ::oDlgSelect //R
   REDEFINE CHECKBOX ::oSer[ 19 ] VAR ::aSer[ 19 ] ID 1370 OF ::oDlgSelect //S
   REDEFINE CHECKBOX ::oSer[ 20 ] VAR ::aSer[ 20 ] ID 1380 OF ::oDlgSelect //T
   REDEFINE CHECKBOX ::oSer[ 21 ] VAR ::aSer[ 21 ] ID 1390 OF ::oDlgSelect //U
   REDEFINE CHECKBOX ::oSer[ 22 ] VAR ::aSer[ 22 ] ID 1400 OF ::oDlgSelect //V
   REDEFINE CHECKBOX ::oSer[ 23 ] VAR ::aSer[ 23 ] ID 1410 OF ::oDlgSelect //W
   REDEFINE CHECKBOX ::oSer[ 24 ] VAR ::aSer[ 24 ] ID 1420 OF ::oDlgSelect //X
   REDEFINE CHECKBOX ::oSer[ 25 ] VAR ::aSer[ 25 ] ID 1430 OF ::oDlgSelect //Y
   REDEFINE CHECKBOX ::oSer[ 26 ] VAR ::aSer[ 26 ] ID 1440 OF ::oDlgSelect //Z

   /*
   Meter-----------------------------------------------------------------------
   */

 REDEFINE APOLOMETER ::oMtrSelect ;
      VAR      nMtrSelect ;
      NOPERCENTAGE ;
      ID       200;
      OF       ::oDlgSelect

 REDEFINE APOLOMETER ::oMtrProcess ;
      VAR      nMtrProcess ;
      NOPERCENTAGE ;
      ID       210;
      OF       ::oDlgSelect

   /*
   Tree------------------------------------------------------------------------
   */

   ::oTreeSelect  := TTreeView():Redefine( 400, ::oDlgSelect )

   /*
   Botones---------------------------------------------------------------------
   */

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       ::oDlgSelect ;
      ACTION   ( ::EvalContabilizaSesiones() )

   REDEFINE BUTTON ::oBtnCancelContabilizacion ;
      ID       IDCANCEL ;
      OF       ::oDlgSelect ;
      ACTION   ( ::oDlgSelect:end() )

   ::oDlgSelect:AddFastKey( VK_F5, {|| ::EvalContabilizaSesiones() } )

   ::oDlgSelect:bStart := {|| ::StartContabilizaSesiones( oImageList ) }

   ACTIVATE DIALOG ::oDlgSelect CENTER

   if !empty( oBmpContabilidad )
      oBmpContabilidad:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD StartContabilizaSesiones( oImageList )

   ::oTreeSelect:SetImageList( oImageList )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD EvalContabilizaSesiones()

   local bOldAction

   ::lBreak                            := .f.

   ::oDbf:GetStatus()

   ::oDlgSelect:Disable()

   // Acciones del boton cancelar----------------------------------------------

   bOldAction                          := ::oBtnCancelContabilizacion:bAction
   ::oBtnCancelContabilizacion:bAction := {|| ::lBreak := .t. }
   ::oBtnCancelContabilizacion:Enable()

   ::oTreeSelect:Enable()

   // Iniciamos el proceso-----------------------------------------------------

   ::oTreeSelect:DeleteAll()

   if ::lAllSesions

      ::Contabiliza( ::lChkSimula )

   else

      if ::oDbf:Seek( Str( ::nNumDocIni, ::nLenDocIni ) + ::cSufDocIni, .t. )

         ::oMtrProcess:SetTotal( ::oDbf:OrdKeyCount() )

         while ::oDbf:FieldGetName( ::cNumDocKey ) + ::oDbf:FieldGetName( ::cSufDocKey ) >= Str( ::nNumDocIni, ::nLenDocIni ) + ::cSufDocIni .and.;
               ::oDbf:FieldGetName( ::cNumDocKey ) + ::oDbf:FieldGetName( ::cSufDocKey ) <= Str( ::nNumDocFin, ::nLenDocIni ) + ::cSufDocFin .and.;
               !::oDbf:eof()

            ::Contabiliza( ::lChkSimula )

            ::oDbf:Skip()

            SysRefresh()

            ::oMtrProcess:Set( ::oDbf:OrdKeyNo() )

         end while

         ::oMtrProcess:Set( ::oDbf:OrdKeyCount() )

      end if

      ::oDbf:SetStatus()

   end if

   // Restauramos las acciones-------------------------------------------------

   ::oBtnCancelContabilizacion:bAction := bOldAction

   ::oDlgSelect:Enable()

RETURN NIL

//---------------------------------------------------------------------------//
/*
Vamos a buscar si la caja esta abierta para este turno-------------------------
*/

METHOD GetLastOpen()

   local cLasTur        := ""

   if empty( ::oDbf )
      Return ( cLasTur )
   end if

   if !( ::oDbf:Used() )
      Return ( cLasTur )
   end if

   CursorWait()

   ::oDbf:GetStatus()

   // Cajas independientes-----------------------------------------------------

   if .t. // uFieldEmpresa( "lDesCajas" )

      ::oDbf:OrdSetFocus( "nStaCaj" )

      if ::oDbf:Seek( ::GetCurrentCaja() )
         ::cCurTurno       := ::oDbf:cNumTur + ::oDbf:cSufTur // + ::oDbf:cCodCaj
      else
         ::cCurTurno       := ""
      end if 

   else

   // Cajas asociadas----------------------------------------------------------

      ::oDbf:OrdSetFocus( "nStaTur" )

      ::oDbf:GoTop()
      while !::oDbf:Eof()

         cLasTur           := ::oDbf:cNumTur + ::oDbf:cSufTur

         if !empty( cLasTur )

            if ::oDbfCaj:Seek( cLasTur + ::GetCurrentCaja() )

               if ::oDbfCaj:lCajClo
                  cLasTur  := ""
               end if 

            end if

         end if 

         if empty( cLasTur )
            ::oDbf:Skip()
         else
            exit 
         end if 

      end while      

   end if 

   ::oDbf:SetStatus()

   CursorWE()

RETURN ( ::cCurTurno )

//--------------------------------------------------------------------------//

METHOD GoCurrentTurno()

   ::GetCurrentTurno()

   ::GetCurrentCaja()

RETURN ( ::oDbf:SeekInOrd( ::cCurTurno, "cNumTur" ) )

//---------------------------------------------------------------------------//

METHOD MailArqueo( cCurrentTurno )

   local cMensajeMail   := ""
   local hMail          := {=>}

   ::cPdfFileName       := "Arqueo" + Alltrim( cCurrentTurno ) + "Caja" + Alltrim( ::oDbfCaj:cCodCaj ) + ".pdf"
   ::cHtmlFileName      := "Arqueo" + Alltrim( cCurrentTurno ) + "Caja" + Alltrim( ::oDbfCaj:cCodCaj ) + ".html"
   ::cPdfDefaultPath    := cPatEmpTmp()

   ::lPdfShowDialog     := .f.

   ::PrintArqueo( cCurrentTurno, ::oDbfCaj:cCodCaj, IS_PDF )

   cMensajeMail         := "Caja [" + ::oDbfCaj:cCodCaj + Space( 1 ) + Rtrim( oRetFld( ::oDbfCaj:cCodCaj, ::oCaja ) ) + "], "
   cMensajeMail         += "cerrada a las " + Left( Time(), 5 ) + Space( 1 )
   cMensajeMail         += "del día " + Dtoc( Date() ) + "." + CRLF

   if ::oTotales:nTotCompras( ::oDbfCaj:cCodCaj ) != 0
      cMensajeMail      += "Compras en albaranes "                + Alltrim( Str( ::oTotales:nTotAlbPrvCompras( ::oDbfCaj:cCodCaj ) ) )   + cSimDiv( cDivEmp(), ::oDbfDiv ) + "." + CRLF
      cMensajeMail      += "Compras en facturas "                 + Alltrim( Str( ::oTotales:nTotFacPrvCompras( ::oDbfCaj:cCodCaj ) ) )   + cSimDiv( cDivEmp(), ::oDbfDiv ) + "." + CRLF
      cMensajeMail      += "Compras en facturas rectificativas "  + Alltrim( Str( ::oTotales:nTotRctPrvCompras( ::oDbfCaj:cCodCaj ) ) )   + cSimDiv( cDivEmp(), ::oDbfDiv ) + "." + CRLF
      cMensajeMail      += "Total compras "                       + Alltrim( Str( ::oTotales:nTotCompras( ::oDbfCaj:cCodCaj ) ) )         + cSimDiv( cDivEmp(), ::oDbfDiv ) + "." + CRLF
   end if

   if ::oTotales:nTotVentas( ::oDbfCaj:cCodCaj ) != 0
      cMensajeMail      += "Ventas en albaranes "                 + Alltrim( Str( ::oTotales:nTotAlbCliVentas( ::oDbfCaj:cCodCaj ) ) ) + cSimDiv( cDivEmp(), ::oDbfDiv ) + "." + CRLF
      cMensajeMail      += "Ventas en facturas "                  + Alltrim( Str( ::oTotales:nTotFacCliVentas( ::oDbfCaj:cCodCaj ) ) ) + cSimDiv( cDivEmp(), ::oDbfDiv ) + "." + CRLF
      cMensajeMail      += "Ventas en facturas rectificativas "   + Alltrim( Str( ::oTotales:nTotRctCliVentas( ::oDbfCaj:cCodCaj ) ) ) + cSimDiv( cDivEmp(), ::oDbfDiv ) + "." + CRLF
      cMensajeMail      += "Ventas en tickets "                   + Alltrim( Str( ::oTotales:nTotTikCliVentas( ::oDbfCaj:cCodCaj ) ) ) + cSimDiv( cDivEmp(), ::oDbfDiv ) + "." + CRLF
      cMensajeMail      += "Ventas en cheques regalo "            + Alltrim( Str( ::oTotales:nTotChkCliVentas( ::oDbfCaj:cCodCaj ) ) ) + cSimDiv( cDivEmp(), ::oDbfDiv ) + "." + CRLF
      cMensajeMail      += "Devoluciones "                        + Alltrim( Str( ::oTotales:nTotDevCliVentas( ::oDbfCaj:cCodCaj ) ) ) + cSimDiv( cDivEmp(), ::oDbfDiv ) + "." + CRLF
      cMensajeMail      += "Total ventas "                        + Alltrim( Str( ::oTotales:nTotVentas( ::oDbfCaj:cCodCaj ) ) )       + cSimDiv( cDivEmp(), ::oDbfDiv ) + "." + CRLF
   end if

   cMensajeMail         += CRLF
   cMensajeMail         += "Total venta sesión " + Alltrim( Str( ::oTotales:nTotVentaSesion( ::oDbfCaj:cCodCaj ) ) ) + cSimDiv( cDivEmp(), ::oDbfDiv ) + "."
   cMensajeMail         += CRLF + CRLF

   ::lPdfShowDialog     := .t.

   // Envío de  mail al usuario----------------------------------------------

   hSet( hMail, "mail", rtrim( ::cEnviarMail ) )
   hSet( hMail, "subject", "Arqueo de caja " + alltrim( ::oDbfCaj:cCodCaj ) + " sesión " + alltrim( cCurrentTurno ) )
   hSet( hMail, "message", rtrim( cMensajeMail ) )

   if file( ::cPdfDefaultPath + ::cPdfFileName ) // ::cHtmlFileName )
      hSet( hMail, "attachments", ::cPdfDefaultPath + ::cPdfFileName ) //::cHtmlFileName )
   end if 

   with object TSendMail():New()
      if :buildMailerObject()
         :sendMail( hMail )
      end if 
   end with

   // Borramos los temporales--------------------------------------------------

   if File( ::cPdfDefaultPath + ::cPdfFileName )
      fErase( ::cPdfDefaultPath + ::cPdfFileName )
   end if

   if File( ::cPdfDefaultPath + ::cHtmlFileName )
      fErase( ::cPdfDefaultPath + ::cHtmlFileName )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ActualizaStockWeb()

//   with object ( TComercio():New() )
//      :buildActualizaStockProductPrestashop()        
//   end with

Return ( self )

//---------------------------------------------------------------------------//

METHOD TotSesion( cTurno, cCaja )

   DEFAULT cTurno    := ::cCurTurno
   DEFAULT cCaja     := ::cCurCaja

   ::TotVenta(    cTurno, cCaja )

   ::TotEntrada(  cTurno, cCaja )

   ::TotCompra(   cTurno, cCaja )

   ::TotCobro(    cTurno, cCaja )

   ::TotPago(     cTurno, cCaja )

   ::TotTipoIva(  cTurno, cCaja )

   if ::oDbfCaj:SeekInOrd(    cTurno + cCaja, "cNumTur" )
      ::oTotales:addTotCajaEfectivo(   cCaja, ::oDbfCaj:nCanEfe )
      ::oTotales:addTotCajaNoEfectivo( cCaja, ::oDbfCaj:nCanEfe )
      ::oTotales:addTotCajaTarjeta(    cCaja, ::oDbfCaj:nCanTar )
      ::oTotales:addTotCajaObjetivo(   cCaja, ::oDbfCaj:nCanPre )
   end if

Return ( nil ) 

//------------------------------------------------------------------------//

METHOD GetTreeState( aItems )

   local oItem

   for each oItem in aItems

      sysrefresh()

      // tvSetCheckState( ::oTreeImpresion:hWnd, oItem:hItem, ::oIniArqueo:Get( "Arqueo.Impresion", oItem:cPrompt, .t. ) )

      ::oTreeImpresion:SetCheck( oItem, ::oIniArqueo:Get( "Arqueo.Impresion", oItem:cPrompt, .t. ) )

      if len( oItem:aItems ) > 0
         ::GetTreeState( oItem:aItems )
      end if

   next

Return ( nil ) 

//------------------------------------------------------------------------//

METHOD SetTreeState( aItems )

   local oItem

   for each oItem in aItems

      sysrefresh()

      // ::oIniArqueo:Set( "Arqueo.Impresion", oItem:cPrompt, tvGetCheckState( ::oTreeImpresion:hWnd, oItem:hItem ) )

      ::oIniArqueo:Set( "Arqueo.Impresion", oItem:cPrompt, ::oTreeImpresion:GetCheck( oItem ) ) 

      if len( oItem:aItems ) > 0
         ::SetTreeState( oItem:aItems )
      end if

   next

Return ( nil ) 

//------------------------------------------------------------------------//

METHOD SaveImporte( cCodCaj )

   ::oDbfCaj:GetRecno()

   if ::oDbfCaj:SeekInOrd( ::cCurTurno + cCodCaj, "cNumTur" )
      ::oDbfCaj:Load()
      ::oDbfCaj:nCanEfe := ::nImporteEfectivo
      ::oDbfCaj:nCanTar := ::nImporteTarjeta
      ::oDbfCaj:nCanRet := ::nImporteRetirado
      ::oDbfCaj:cMonEfe := ::oMoneyEfectivo:GetStream()
      ::oDbfCaj:cMonRet := ::oMoneyRetirado:GetStream()
      ::oDbfCaj:Save()
   end if

   ::oDbfCaj:SetRecno()

Return ( nil ) 

//------------------------------------------------------------------------//

METHOD LoadImporte( cCodCaj )

   ::oDbfCaj:GetRecno()

   if ::oDbfCaj:SeekInOrd( ::cCurTurno + cCodCaj, "cNumTur" )
      ::oImporteTarjeta:cText(      ::oDbfCaj:nCanTar )
      ::oImporteEfectivo:cText(     ::oDbfCaj:nCanEfe )
      ::oImporteRetirado:cText(     ::oDbfCaj:nCanRet )
      ::oMoneyEfectivo:SetStream(   ::oDbfCaj:cMonEfe )
      ::oMoneyRetirado:SetStream(   ::oDbfCaj:cMonRet )
   else
      ::oImporteTarjeta:cText(      0 )
      ::oImporteEfectivo:cText(     0 )
      ::oImporteRetirado:cText(     0 )
      ::oMoneyEfectivo:SetStream(   "" )
      ::oMoneyRetirado:SetStream(   "" )
   end if

   ::oDbfCaj:SetRecno()

Return ( nil ) 

//------------------------------------------------------------------------//

METHOD GetItemCheckState( cPrompt )

   local lState      := .t.

   lState            := ::oIniArqueo:Get( "Arqueo.Impresion", cPrompt, .t. )

   if lState

      if !empty( ::oTxt )
         ::oTxt:SetText( "Añadiendo a temporal " + Lower( cPrompt ) )
      end if

      ::cGrupoEnUso  := Padr( cPrompt, 60 )
      ::nGrupoPeso++

   end if

Return ( lState )

//------------------------------------------------------------------------//

METHOD RefreshTurno()

   if !empty( ::oTotalEfectivo )
      ::oTotalEfectivo:Refresh()
   end if

   if !empty( ::oTotalNoEfectivo )
      ::oTotalNoEfectivo:Refresh()
   end if

   if !empty( ::oTotalTarjeta )
      ::oTotalTarjeta:Refresh()
   end if

   if !empty( ::oTotalCobros )
      ::oTotalCobros:Refresh()
   end if

   if !empty( ::oTotalCaja )
      ::oTotalCaja:Refresh()
   end if

   if !empty( ::oDiferenciaEfectivo )

      if Eval( ::oDiferenciaEfectivo:bSetGet ) > 0
         ::oDiferenciaEfectivo:SetColor( CLR_BLUE, GetSysColor( COLOR_BTNFACE ) )
      else
         ::oDiferenciaEfectivo:SetColor( CLR_RED, GetSysColor( COLOR_BTNFACE ) )
      end if

      ::oDiferenciaEfectivo:Refresh()

   end if

   if !empty( ::oDiferenciaTarjeta )

      if Eval( ::oDiferenciaTarjeta:bSetGet ) > 0
         ::oDiferenciaTarjeta:SetColor( CLR_BLUE, GetSysColor( COLOR_BTNFACE ) )
      else
         ::oDiferenciaTarjeta:SetColor( CLR_RED, GetSysColor( COLOR_BTNFACE ) )
      end if

      ::oDiferenciaTarjeta:Refresh()

   end if

   if !empty( ::oDiferenciaTotal )

      if Eval( ::oDiferenciaTotal:bSetGet ) > 0
         ::oDiferenciaTotal:SetColor( CLR_BLUE, GetSysColor( COLOR_BTNFACE ) )
      else
         ::oDiferenciaTotal:SetColor( CLR_RED, GetSysColor( COLOR_BTNFACE ) )
      end if

      ::oDiferenciaTotal:Refresh()

   end if

   if !empty( ::oImporteCambio )
      ::oImporteCambio:SetText( ::nImporteEfectivo - ::nImporteRetirado )
   end if

Return ( .t. )

//------------------------------------------------------------------------//

METHOD cBancoCuenta( uRctCli ) 

   local cBanco      := ""
   local cCuenta     := ""

   DEFAULT uRctCli   := ::oFacCliP

   cCuenta           := cCuentaEmpresaRecibo( uRctCli )

   if !empty( cCuenta )
      cBanco         := oRetFld( cCodEmp() + cCuenta, ::oEmpBnc, "cCodBnc", "cCtaBnc" )
      if !empty( cBanco )
         cCuenta     := Rtrim( cBanco ) + Space( 1 ) + Trans( cCuenta, "@R ####-####-##-##########" )
      end if
   end if

Return ( cCuenta )

//------------------------------------------------------------------------//

METHOD cEstadoSesion()

Return( ::aEstadoSesion[ MinMax( ::oDbf:nStaTur + 1, 1, 3 ) ] )

//------------------------------------------------------------------------//

METHOD cInfoAperturaCierreCaja()

   local cInfoAperturaCierreCaja := ""
   cInfoAperturaCierreCaja       += Dtoc( ::oDbfCaj:FieldGetByName( "dFecOpe" ) ) + Space(1)
   cInfoAperturaCierreCaja       += ::oDbfCaj:FieldGetByName( "cHorOpe" ) + Space(1)
   cInfoAperturaCierreCaja       += ::oDbfCaj:FieldGetByName( "cCajOpe" ) + Space(1)
   cInfoAperturaCierreCaja       += Capitalize( oRetFld( ::oDbfCaj:FieldGetByName( "cCajOpe" ), ::oUser ) ) 
   cInfoAperturaCierreCaja       += CRLF

   if ::oDbfCaj:FieldGetByName( "lCajClo" )
      cInfoAperturaCierreCaja    += Dtoc( ::oDbfCaj:FieldGetByName( "dFecClo" ) ) + Space(1)
      cInfoAperturaCierreCaja    += ::oDbfCaj:FieldGetByName( "cHorClo" ) + Space(1)
      cInfoAperturaCierreCaja    += ::oDbfCaj:FieldGetByName( "cCajTur" ) + Space(1)
      cInfoAperturaCierreCaja    += Capitalize( oRetFld( ::oDbfCaj:FieldGetByName( "cCajTur" ), ::oUser ) ) 
   end if  
   
Return ( cInfoAperturaCierreCaja )

//---------------------------------------------------------------------------//

METHOD GetItemTree()

   local cItem    := ""

   if !empty( ::oBrwTotales:oTreeItem ) 
      cItem       := ::oBrwTotales:oTreeItem:Cargo[ 1 ]
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetImporteTree()

   local cItem    := ""

   if !empty( ::oBrwTotales:oTreeItem ) 
      if ::oBrwTotales:oTreeItem:cPrompt != "Espacio"
         cItem    := Trans( ::oBrwTotales:oTreeItem:Cargo[ 2 ], ::cPorDiv )
      end if 
   end if

Return ( cItem )

//---------------------------------------------------------------------------//

METHOD GetColorTree()

   local cColor   := { CLR_BLACK, CLR_WHITE }

   if !empty( ::oBrwTotales:oTreeItem ) .and. empty( ::oBrwTotales:oTreeItem:cPrompt )
      cColor      := { CLR_BLACK, CLR_BAR }
   end if 

Return ( cColor )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION Turnos( oMenuItem, oWnd )

   local oTurno

   DEFAULT  oMenuItem   := "turnos"
   DEFAULT  oWnd        := oWnd()

   // Cerramos todas las ventanas----------------------------------------------

   if !empty( oWnd )
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
      oWnd:Disable()
   end if

   oTurno               := TTurno():New( cPatEmp(), cDriver(), oWnd, oMenuItem )
   if !empty( oTurno ) .and. oTurno:lAccess
      if oTurno:OpenFiles()
         oTurno:Activate()
      else
         oTurno:CloseFiles()
      end if
   end if

   if !empty( oWnd )
      oWnd:Enable()
   end if

   if oTurno != nil
      oTurno:SetFocus()
   end if

RETURN NIL

//---------------------------------------------------------------------------//
//
// Cierra el turno en curso
//

FUNCTION CloseTurno( oMenuItem, oWnd, lParcial )

   local oTurno

   DEFAULT  oMenuItem   := "01001"
   DEFAULT  oWnd        := oWnd()
   DEFAULT  lParcial    := .f.

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if !lTactilMode() .and. !lTpvMode() .and. !empty( oWnd )
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !lParcial .and. nUserCaja( oUser():cCaja() ) > 1
      msgStop( "Hay más de un usuario conectado a la caja", "Atención" )
      return .f.
   end if

   DisableMainWnd( oWnd )

   oTurno               := TTurno():New( cPatEmp(), cDriver(), oWnd, oMenuItem )

   if !empty( oTurno ) .and. oTurno:lCreated

      if oTurno:OpenFiles()

         if !lTactilMode() .and. !lTpvMode()
            oTurno:Activate()
         end if

         oTurno:lArqueoTurno( .f., lParcial )

      else

         oTurno:CloseFiles()

      end if

   end if

   EnableMainWnd( oWnd )

   if !empty( oTurno ) .and. oTurno:lCreated
      oTurno:SetFocus()
   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

FUNCTION Arqueos( oMenuItem, oWnd )

   local oTurno

   DEFAULT  oMenuItem   := "01040"
   DEFAULT  oWnd        := oWnd()

   /*
   Cerramos todas las ventanas
   */

   if !empty( oWnd )
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
      oWnd:Disable()
   end if

   oTurno               := TTurno():New( cPatEmp(), cDriver(), oWnd, oMenuItem )

   if !empty( oTurno ) .and. oTurno:lCreated
      if oTurno:OpenFiles()
         oTurno:lArqueoTurno( .f. )
      end if
      oTurno:End()
   end if

   oWnd:Enable()

   if !empty( oTurno ) .and. oTurno:lCreated
      oTurno:SetFocus()
   end if

RETURN NIL

//--------------------------------------------------------------------------//

Function lCajaOpen( cCodCaj )

   local oTurno         := TTurno():New( cPatEmp() )
   local lCajaOpen      := .t.

   if !empty( oTurno )

      if oTurno:OpenService()

         if oTurno:oDbfCaj:SeekInOrd( oTurno:GetCurrentTurno() + cCodCaj, "cNumTur" )
            lCajaOpen   := !oTurno:oDbfCaj:lCajClo
         end if

         oTurno:CloseService()

      end if

      oTurno:End()

   end if

Return ( lCajaOpen )

//-------------------------------------------------------------------------//
//
// Chequea q haya turnos abiertos
//

Function chkTurno( oMenuItem )

   local oTurno

   oTurno         := TTurno():New( cPatEmp(), cDriver(), oWnd(), oMenuItem )   

   if !empty( oTurno )

      if oTurno:OpenFiles()

         oTurno:lNowOpen()

         oTurno:CloseFiles()

      else

         msgStop( "No se han abierto las tablas de turnos.")

      end if

      oTurno:End()

   end if

Return ( .t. )

//---------------------------------------------------------------------------//
//
// Hay turnos abiertos
//

Function lCurSesion( cDbfCaj )

   local lCurSesion  := .f.
   local lOpen       := .f.

   if empty( cDbfCaj )
      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @cDbfCaj ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE
      lOpen          := .t.
   end if

   lCurSesion        := !empty( TTurno():cCurTurno ) .or. RetFld( oUser():cCaja(), cDbfCaj, "lNoArq" )

   if lOpen

      if !empty( cDbfCaj )
         ( cDbfCaj )->( dbCloseArea() )
      end if

      cDbfCaj        := nil

   end if

Return ( lCurSesion )

//---------------------------------------------------------------------------//
//
// No hay turnos activos
//

Function CloSesion()

   TTurno():cCurTurno   := nil

Return ( nil )

//---------------------------------------------------------------------------//

Function AddImpTactil( nImpVta, cCodArt, uArt )

   local aArtStatus

   do case
      case ValType( uArt ) == "C"

         aArtStatus  := aGetStatus( uArt, .t. )

         if ( uArt )->( dbSeek( cCodArt ) ) .and. ( uArt )->( dbRLock() )
            ( uArt )->nPosTcl  += nImpVta
            ( uArt )->( dbRUnlock() )
         end if

         SetStatus( uArt, aArtStatus )

      case ValType( uArt ) == "O"

         uArt:GetStatus()

         if uArt:Seek( cCodArt )
            uArt:FieldPutByName( "nPosTcl", uArt:nPosTcl + nImpVta )
         end if

         uArt:SetStatus()

   end case

return ( nil )

//---------------------------------------------------------------------------//

//
// Turno en curso
//

Function cCurSesion( cCurSes, lDelega )

   local oTurno
   local cSesion

   DEFAULT lDelega      := .t.

   oTurno               := TTurno()

   if cCurSes != nil
      oTurno:cCurTurno  := cCurSes
   end if

   if lDelega
      cSesion           := oTurno:cCurTurno
   else
      cSesion           := SubStr( oTurno:cCurTurno, 1, 6 )
   end if 

Return ( cSesion )

//---------------------------------------------------------------------------//

Function cShortSesion()

RETURN ( cCurSesion( , .f. ) )

//---------------------------------------------------------------------------//
//
// Indica si el turno existe
//

Function lExisteTurno( cNumTur, dbfTurno )

   local nRec
   local lExiste     := .f.
   local lOpen       := .f.

   if empty( dbfTurno )
      USE ( cPatEmp() + "Turno.DBF" ) NEW VIA ( cDriver() ) SHARED   ALIAS ( cCheckArea( "Turno", @dbfTurno ) )
      SET ADSINDEX TO ( cPatEmp() + "Turno.CDX" ) ADDITIVE
      lOpen          := .t.
   else
      nRec           := ( dbfTurno )->( Recno() )
   end if

   lExiste           := dbSeekInOrd( Padl( AllTrim( cNumTur ), 6 ), "cNumTur", dbfTurno )

   if lOpen
      CLOSE ( dbfTurno )
   else
      ( dbfTurno )->( dbGoTo( nRec ) )
   end if

Return ( lExiste )

//---------------------------------------------------------------------------//
