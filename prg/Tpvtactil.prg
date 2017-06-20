#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"
#include "Xbrowse.ch"
#include "FastRepH.ch"

#define DT_TOP                      0x00000000
#define DT_LEFT                     0x00000000
#define DT_CENTER                   0x00000001
#define DT_RIGHT                    0x00000002
#define DT_VCENTER                  0x00000004
#define DT_BOTTOM                   0x00000008
#define DT_WORDBREAK                0x00000010
#define DT_SINGLELINE               0x00000020
#define DT_EXPANDTABS               0x00000040
#define DT_TABSTOP                  0x00000080
#define DT_NOCLIP                   0x00000100
#define DT_EXTERNALLEADING          0x00000200
#define DT_CALCRECT                 0x00000400
#define DT_NOPREFIX                 0x00000800
#define DT_INTERNAL                 0x00001000

#define EM_SETMARGINS               211
#define EC_LEFTMARGIN               1
#define EC_RIGHTMARGIN              2
#define EM_LIMITTEXT                197
#define EM_SETLIMITTEXT             EM_LIMITTEXT   // win40 Name change

#define ubiGeneral                  0
#define ubiLlevar                   1
#define ubiSala                     2
#define ubiRecoger                  3
#define ubiEncargar                 4
   
#define exitAceptarRegalo           1
#define exitAceptarImprimir         2
#define exitAceptar                 3
#define exitCancelar                4
#define exitAceptarDesglosado       5

#define documentoTicket             1
#define documentoAlbaran            2 
#define documentoFactura            3 

#define nParcial                    1
#define nPagado                     2

#define calcDistance                240

#define __bottomNumber__            9999

static aResources                   := {}   

static oThis

//---------------------------------------------------------------------------//

Function StartTpvTactil()

   local oTpvTactil

   oTpvTactil  := TpvTactil():New()

   if !Empty( oTpvTactil )
      oTpvTactil:Activate()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

CLASS TpvTactil

   DATA oWnd
   DATA oDlg

   DATA nView

   DATA nScreenHorzRes
   DATA nScreenVertRes

   DATA nResizeSmall

   DATA lOpenfiles

   DATA nLevel

   DATA lAlone

   DATA oTiketCabecera
   DATA oTiketLinea
   DATA oTiketCobro
   DATA oTiketNumeroSerie
   DATA oCliente
   DATA oCajaCabecera
   DATA oCajaLinea
   DATA oUsuario
   DATA oArticulo
   DATA oCodigoBarraArticulo
   DATA oArticulosEscandallos
   DATA oArticulosLenguajes
   DATA oArticulosOfertas
   DATA oFormaPago
   DATA oPropiedadesLinea
   DATA oFamilias
   DATA oAlbaranClienteCabecera
   DATA oAlbaranClienteLinea
   DATA oAlbaranClienteSerie
   DATA oAlbaranClientePago
   DATA oAlbaranClienteIncidencia
   DATA oAlbaranClienteDocumento
   DATA oFacturaClienteCabecera
   DATA oFacturaClienteLinea
   DATA oFacturaClienteSerie
   DATA oFacturaClientePago
   DATA oAnticipoCliente
   DATA oObras
   DATA oAgentes
   DATA oRuta
   DATA oAlmacen
   DATA oArticuloPropiedades
   DATA oTarifaPrecioLinea
   DATA oTarifaPrecioLineaAgente
   DATA oDocument
   DATA oAtipicasCliente
   DATA oContadores
   DATA oTipoIVA
   DATA oDivisas
   DATA oFiltroPorUsuario
   DATA oComisionesAgentes
   DATA oEmpresa
   DATA oFactoresConversion
   DATA oPedidoClienteCabecera
   DATA oPedidoClienteLinea
   DATA oPedidoClienteEntregaCuenta
   DATA oPresupuestoClienteCabecera
   DATA oPresupuestoClienteLinea
   DATA oFacturaRectificativaCabecera
   DATA oFacturaRectificativaLinea
   DATA oFacturaRectificativaNumeroSerie
   DATA oAlbaranProveedorCabecera
   DATA oAlbaranProveedorLinea
   DATA oAlbaranProveedorNumeroSerie
   DATA oFacturaProveedorCabecera
   DATA oFacturaProveedorLinea
   DATA oFacturaProveedorNumeroSerie
   DATA oRectificativaProveedorCabecera
   DATA oRectificativaProveedorLinea
   DATA oRectificativaProveedorNumeroSerie
   DATA oMovimientosAlmacen
   DATA oMovimientosAlmacenNumeroSerie
   DATA oComentariosCabecera
   DATA oComentariosLinea
   DATA oTemporadas
   DATA oParteProducionLinea
   DATA oMaterialesProducion
   DATA oMaterialesProducionSeries
   DATA oMaterialesNumeroSeries
   DATA oTipoVenta
   DATA oTransportista
   DATA oCaptura
   DATA oBandera
   DATA oStock
   DATA oNewImp
   DATA oVisor
   DATA cVisor

   DATA cImpresora
   DATA oUndMedicion
   DATA oRestaurante
   DATA oInvitacion
   DATA oFideliza
   DATA oTipArt
   DATA oFabricante
   
   DATA oOrdenComanda
   DATA cOrdenComanda
   DATA oTpvMenu
   DATA oTpvMenuOrdenes
   DATA oTpvMenuArticulo

   DATA oVisor

   DATA oBrwFamilias
   DATA oBrwLineas

   DATA oDragCursor

   DATA oLstArticulos
   DATA oLstOrden

   DATA lImagenArticulos

   DATA cResource

   DATA nImageViewWItem
   DATA nImageViewHItem
   DATA nImageViewVSep
   DATA nImageViewHSep
   DATA nImageViewTitle
   DATA aImageViewTextMargin

   DATA oLstFavoritos

   DATA aFamilias
   DATA aLineas

   DATA oBtnNum

   DATA oFntNum
   DATA oFntEur
   DATA oFntFld 
   DATA oFntBrw
   DATA oFntDlg
   DATA oFntDto

   DATA oTurno

   DATA oBrwComentarios
   DATA oBrwLineasComentarios

   DATA oBrwOriginal
   DATA oBrwNuevoTicket

   DATA oGetUnidades
   DATA cGetUnidades

   DATA oProgressBar
   DATA nProgressBar

   DATA oBtnLineasTop
   DATA oBtnLineasBottom
   DATA oBtnLineasDelete
   DATA oBtnLineasComentarios
   DATA oBtnLineasEscandallos

   DATA oBtnSCobrar
   DATA oBtnSSalon
   DATA oBtnSEntregar
   DATA oBtnSSalir

   DATA oBtnPreviewDocumento
   DATA oBtnPrintDocumento  

   DATA oOfficeBar
   DATA oOfficeBarDividirMesas

   DATA oTpvUtilidadesMesa

   DATA oBtnPrecioUnidades

   DATA cTemporalLinea
   DATA oTemporalLinea
   DATA cTemporalComanda
   DATA oTemporalComanda

   DATA oTemporalImpresionLinea
   DATA cTemporalImpresionLinea

   DATA cTemporalCobro
   DATA oTemporalCobro
   DATA cTemporalDivisionOriginal
   DATA oTemporalDivisionOriginal
   DATA cTemporalDivisionNuevoTicket
   DATA oTemporalDivisionNuevoTicket

   DATA oSayImporte
   DATA oSayPrecioPersona
   DATA cSayPrecioPersona
   DATA oSayZona
   DATA cSayZona
   DATA cSayInfo
   DATA oSayInfo

   DATA oTotalTicket
   DATA oTotalPrecioPersona
   DATA nTotalTicket
   DATA nTotalPrecioPersona

   DATA cPictureImporte
   DATA cPictureTotal

   DATA nDecimalesImporte
   DATA nDecimalesTotal

   DATA cPictureUnidades

   DATA oFormatosImpresion

   DATA cDescripcionLibre
   DATA nUnidadesLibre
   DATA nImporteLibre
   DATA cImpresoraLibre
   DATA nIvaLibre
   DATA cOrdenComandaLibre

   DATA oBtnUnaLinea
   DATA oBtnTodasLineas

   DATA oBtnArticulosPageUp
   DATA oBtnArticulosPageDown

   DATA oBtnOrdenComandaActual
   DATA oGetCambiarOrden

   DATA oBtnAgregarLibre
   DATA oBtnCombinado
   DATA oBtnCalculadora
   DATA oBtnBalanza

   DATA oCarpetaLineas
   DATA oCarpetaInicio

   DATA oGrpSalones
   DATA oGrpSeries

   DATA oBtnSala
   DATA oBtnGeneral
   DATA oBtnLlevar
   DATA oBtnRecoger
   DATA oBtnEncargar
   DATA oBtnImportesExactos

   DATA oBtnUsuario
   DATA lGetUsuario

   DATA oBtnRenombrar

   DATA oBtnCliente
   DATA oBtnDireccion
   DATA oBtnTelefono

   DATA sTotal

   DATA lGuardaNuevoTiket

   DATA oTpvCobros
   DATA oTpvListaTicket

   DATA oFastReport

   DATA cFormato
   DATA cImpresora
   DATA nDispositivo
   DATA nCopias
   DATA lComanda

   DATA lCombinando
   DATA lCombinandoDos
   DATA lShowCombinado

   DATA oTimer

   DATA cCodigoFamilia

   DATA nTarifaSolo
   DATA nTarifaCombinado

   DATA oBtnTarifaSolo
   DATA oBtnTarifaCombinado

   DATA lKillResource

   DATA lHideCalculadora

   DATA lEmptyOrdenComanda

   DATA oBtnFamiliasTop
   DATA oBtnFamiliasUp
   DATA oBtnFamiliasDown
   DATA oBtnFamiliasEnd

   DATA oHorizontalSplitterTop
   DATA oVerticalSplitterRight
   DATA oVerticalSplitterCenter

   DATA nDialogWidth
   DATA nDialogHeight

   DATA nNumeroLinea
   DATA nPosPrint

   DATA nUnidades
   METHOD setUnidades( nUnidades )  INLINE ( ::nUnidades := nUnidades )
   METHOD getUnidades()             INLINE ( ::nUnidades )

   DATA aTemporalOriginal
   DATA aTemporalNuevoTicket

   DATA cCodigoInvitacion

   DATA oTextoInvitacion
   DATA cTextoInvitacion

   DATA oListViewInvitacion
   DATA oImageListInvitacion

   DATA lValidResource     

   DATA lCopiaComanda

   DATA nLineaMenu

   DATA nComensalesMenu          

   DATA cCodigoPropiedadArticulo1   
   DATA cCodigoPropiedadArticulo2
   DATA cValorPropiedadArticulo1   
   DATA cValorPropiedadArticulo2

   DATA nArticulos                  INIT 0

   DATA lGetPrecio                  INIT .f.

   DATA nTipoDocumento     			INIT documentoTicket 

   DATA cNumeroAlbaran              INIT ""

   DATA cCodigoOrdenComandaActual   INIT ""

   DATA numeroLineaDragBegin
   DATA numeroLineaDropOver

   //------------------------------------------------------------------------//

   METHOD New( oMenuItem, oWnd )    CONSTRUCTOR

   METHOD Activate( lAlone )

   METHOD End()

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD Resource()
      METHOD ResizedResource()
      METHOD StartResource()
      METHOD EndResource()
      METHOD PaintResource()

   METHOD DisableDialog()           INLINE ( CursorWait(),;
                                             ::lValidResource := .f.,;
                                             aEval( ::oDlg:aControls, { |o| if( o:ClassName != "TSAY" .and. o:ClassName != "TBITMAP", o:Disable(), ) } ),;
                                             SysRefresh() )

   METHOD EnableDialog()            INLINE ( ::lValidResource := .t.,;
                                             aEval( ::oDlg:aControls, { |o| if( o:ClassName != "TSAY" .and. o:ClassName != "TBITMAP", o:Enable(), ) } ),;
                                             CursorWE(),;
                                             SysRefresh() )

   METHOD l1024()                   INLINE ( ::nScreenHorzRes >= 1024 )
   METHOD l1280()                   INLINE ( ::nScreenHorzRes >= 1280 )

   METHOD CargaBrowseFamilias()

   METHOD ChangeFamilias()
      METHOD SetFamilia()
      METHOD GoFamilia()

   METHOD KeyChar( cKey )
   METHOD oDlgKeyDown( o, nKey, nFlag )

   METHOD CreateTemporal()
   METHOD DestroyTemporal()

   METHOD CargaValoresDefecto( nUbicacion )
   METHOD initValoresDefecto()

   METHOD CargaContador()

   METHOD SeleccionaArticulos()
   METHOD SeleccionaOrden()
   METHOD ActionListArticulo()

   METHOD cFileBmpName( cFile, lEmptyImage )
   METHOD lFileBmpName( cFile )        INLINE ( File( ::cFileBmpName( cFile ) ) )

   METHOD CargaArticulosFamilia( cCodFam )
   METHOD CargaArticulosOrden()             
   METHOD CargaFavoritos()
      METHOD CreateItemArticulo( aItems )

   METHOD AgregarLineas()
      METHOD AgregarPrincipal()
      METHOD AgregarCombinado()
      METHOD AgregarKit()
      METHOD AgregarPLU()
      METHOD AgregarFavoritos( cNombreArticulo )
      METHOD AgregarArticulosInicio( cCodigoArticulo, nUnidades )

      METHOD AgregarAcompannamiento()

      METHOD AgregarOrdenComanda()

      METHOD nLineaMenuActivo()
      METHOD nNumeroArticulosOrden()
      METHOD nNumeroUnidadesMenu()

      METHOD AgregarLibre()
         METHOD ValidarAgregarLibre( oGetDescripcion, oDlg )
         METHOD GuardarAgregarLibre()

   // Agregar lote-----------------------------------------------------------//

   METHOD AgregarLote() 
      METHOD ValidarAgregarLote( cLote, oDlg )

   // Metodos para los menus-------------------------------------------------//

   METHOD CargaMenus() 
   METHOD AgregarMenu()
      METHOD CargaFamiliaMenu()
      METHOD AgregarArticuloMenu()

   METHOD AgregarMenuAcompannamiento()

   METHOD AgregarLineaMenu()

   METHOD DialogoPropiedadArticulo()

   METHOD nArticulosOrdenesIntercambiables()

   //------------------------------------------------------------------------//

   METHOD ResetPropiedadArticulos()                                  INLINE ( ::SetCodigoPropiedadArticulo1() ,;
                                                                              ::SetCodigoPropiedadArticulo2() ,;
                                                                              ::SetValorPropiedadArticulo1() ,; 
                                                                              ::SetValorPropiedadArticulo2() )

   METHOD SetCodigoPropiedadArticulo1( cCodigoPropiedadArticulo )    INLINE ( ::cCodigoPropiedadArticulo1   := cCodigoPropiedadArticulo )
   METHOD SetCodigoPropiedadArticulo2( cCodigoPropiedadArticulo )    INLINE ( ::cCodigoPropiedadArticulo2   := cCodigoPropiedadArticulo )
   METHOD SetValorPropiedadArticulo1( cValorPropiedadArticulo )      INLINE ( ::cValorPropiedadArticulo1    := cValorPropiedadArticulo )
   METHOD SetValorPropiedadArticulo2( cValorPropiedadArticulo )      INLINE ( ::cValorPropiedadArticulo2    := cValorPropiedadArticulo )

   METHOD GetCodigoPropiedadArticulo1()                              INLINE ( if( empty( ::cCodigoPropiedadArticulo1 ), space( 20 ), ::cCodigoPropiedadArticulo1 ) )
   METHOD GetCodigoPropiedadArticulo2()                              INLINE ( if( empty( ::cCodigoPropiedadArticulo2 ), space( 20 ), ::cCodigoPropiedadArticulo2 ) )
   METHOD GetValorPropiedadArticulo1()                               INLINE ( if( empty( ::cValorPropiedadArticulo1 ),  space( 20 ), ::cValorPropiedadArticulo1 ) )
   METHOD GetValorPropiedadArticulo2()                               INLINE ( if( empty( ::cValorPropiedadArticulo2 ),  space( 20 ), ::cValorPropiedadArticulo2 ) )

   //------------------------------------------------------------------------//

   METHOD SetLineaMenu( nLineaMenu )                                 INLINE ( ::nLineaMenu := nLineaMenu )
   METHOD GetLineaMenu()                                             INLINE ( if( empty( ::nLineaMenu ), __bottomNumber__, ::nLineaMenu ) )

   //------------------------------------------------------------------------//

   METHOD nPrecioArticulo()

   METHOD lAcumulaArticulo()

   METHOD SumarUnidades( nUnidades )
  
   METHOD IncrementarUnidades()

   METHOD cNombreArticulo()            INLINE ( Capitalize( alltrim( if( !empty( ::oArticulo:cDesTcl ), ::oArticulo:cDesTcl, ::oArticulo:Nombre ) ) ) )

   METHOD SeleccionarDefecto( cDefCom, oBrwLineasComentarios, oBrwComentarios )

   METHOD lBlankTicket()               INLINE ( alltrim( ::oTiketCabecera:cNumTik ) == "" )

   METHOD cNumeroTicket()              INLINE ( ::oTiketCabecera:cSerTik + ::oTiketCabecera:cNumTik + ::oTiketCabecera:cSufTik )
   
   METHOD cNumeroTicketLinea()         INLINE ( ::oTiketLinea:cSerTil + ::oTiketLinea:cNumTil + ::oTiketLinea:cSufTil )
   METHOD cTextoTicketLinea()          INLINE ( ::oTiketLinea:cSerTil + "/" + alltrim( ::oTiketLinea:cNumTil ) + "/" + alltrim( ::oTiketLinea:cSufTil ) )

   METHOD cNumeroTicketByName()        INLINE ( ::oTiketCabecera:FieldGetByName( "cSerTik" ) + ::oTiketCabecera:FieldGetByName( "cNumTik" ) + ::oTiketCabecera:FieldGetByName( "cSufTik" ) )
   METHOD cNumeroTicketFormato( cNumeroTicket ) ;
                                       INLINE ( if(   Empty( cNumeroTicket ),;
                                                      cNumeroTicket := ::oTiketCabecera:cSerTik + ::oTiketCabecera:cNumTik, ),;
                                                      left( cNumeroTicket, 1 ) + "/" + alltrim( substr( cNumeroTicket, 2, 10 ) ) )

   METHOD cNumeroTicketByNameFormato() INLINE ( ::oTiketCabecera:FieldGetByName( "cSerTik" ) + "/" + AllTrim( ::oTiketCabecera:FieldGetByName( "cNumTik" ) ) )

   METHOD lEmptyNumeroTicket()         INLINE Empty( ::oTiketCabecera:cNumTik )

   METHOD EditFamilia()                INLINE ( if( EdtFamilia( ::aFamilias[ ::oBrwFamilias:nArrayAt, 2 ] ), ( ::CargaBrowseFamilias(), ::ChangeFamilias(), ::oBrwFamilias:Refresh() ), ) )

   //------------------------------------------------------------------------//

   METHOD SelectUnaLineaInvitacion()
   METHOD SelectTodasLineasInvitacion()

   METHOD SelecionaCliente()

   METHOD SetCliente()
   METHOD SetSerie()
   METHOD CambiaSerie( lSubir )
   METHOD SetUbicacion()               INLINE ( if( !Empty( ::oSayZona ), ::oSayZona:SetText( ::cUbicacion() ), ) )
   METHOD SetInfo()                    INLINE ( if( !Empty( ::oSayInfo ), ::oSayInfo:SetText( ::cInfo() ), ) )

   METHOD SetOptionGeneral()           VIRTUAL // INLINE ( if( !Empty( ::oOfficeBar ) .and. ::oOfficeBar:nOption != 1, ( ::oOfficeBar:SetOption( 1 ), ::oOfficeBar:Refresh() ), ), .t. )
   METHOD SetOptionLineas()            VIRTUAL // INLINE ( if( !Empty( ::oOfficeBar ) .and. ::oOfficeBar:nOption != 2, ( ::oOfficeBar:SetOption( 2 ), ::oOfficeBar:Refresh() ), ), .t. )

   METHOD nNuevoNumeroTicket()         INLINE ( Str( nNewDoc( ::oTiketCabecera:cSerTik, ::oTiketCabecera:cAlias, "nTikCli", 10, ::oContadores:cAlias ), 10 ) )

   METHOD cTextoTarifa( nPrecio )      INLINE ( uFieldEmpresa( "cTxtTar" + alltrim( str( nPrecio ) ), "Precio" + space( 1 ) + alltrim( str( nPrecio ) ) ) )
   METHOD SetTarifaSolo( nPrecio ) 
   METHOD SetTarifaCombinado() 

   /*
   Eventos---------------------------------------------------------------------
   */

   METHOD OnClickCobro()
   METHOD OnClickAlbaran()
   METHOD OnClickSalaVenta()
   METHOD OnClickCambiaUbicacion()
   METHOD OnClickGeneral()
   METHOD OnClickParaLlevar()
   METHOD OnClickParaRecoger()
   METHOD OnClickEncargar()

   METHOD OnClickDividirMesa()

   METHOD OnClickEntregaNota()

   METHOD OnClickLista( nOption )
   METHOD OnClickPendientes()

   METHOD OnClickUsuarios()

   METHOD OnclickEntrdaSalida          INLINE ( AppEntSal() )
   METHOD OnClickSeleccionarCajas()    INLINE ( SelCajTactil() )

   METHOD OnClickInvitacion()
      METHOD EndInvitacion( nOpt, oLstInv, oDlg )
      METHOD InitInvitacion( oDlg, oImgInv, oLstInv )
      METHOD SelectInvitacion( nOpt, oLstInv, oTxtInv ) 

   METHOD OnClickDescuento()

   METHOD OnClickCopiaComanda()
   METHOD OnClickGuardar()
   METHOD OnClickCloseTurno( lParcial )

   METHOD gotoUbicacionGeneral()

   METHOD EditArticulo( nRow, nCol )

   //------------------------------------------------------------------------//

   METHOD InstanceFastReport()
   METHOD DestroyFastReport()
   
   METHOD EliminaLineaTemporal()          INLINE ( ::oTemporalLinea:lDelTil   := .t. )
   METHOD SaltaLineaTemporal()            INLINE ( ::oTemporalLinea:Skip() )

   METHOD CambiarPrecio()
   METHOD nGetUnidades( lUnaUnidad )

   METHOD valUnidades()                   INLINE ( val( ::cGetUnidades ) )                                     
   METHOD valUnidadesPrecios()            INLINE ( val( ::cGetUnidades ) )
   METHOD cTipoDocumento()

   METHOD OnClickIniciarSesion()

   METHOD OnClickComensales()

   METHOD OnClickComensalesMenus()

   METHOD ShowUsuario()

   METHOD GetUsuario( lForced )

   METHOD GetUbicacion()

   // Comentarios--------------------------------------------------------------

   METHOD InitComentarios( lForced )
      METHOD EndComentarios( oDlg, oGetComentario )
      METHOD ChangeComentarios( oBrwLineasComentarios )
      METHOD ChangeLineasComentarios( oGetComentario, cComentariosL )

   //------------------------------------------------------------------------//

   METHOD OnClickEliminarTicket()

   METHOD OnClickEliminarLinea()
      METHOD eliminarLinea()
      METHOD eliminaMenu( nLineaMenu )
      METHOD eliminaEscandallo( nNumeroLinea )
      METHOD mailEliminarLinea()

   // Colores-----------------------------------------------------------------

   METHOD ColorLinea( oDbf )
   METHOD ColorLineaSeleccionada( oDbf )
   METHOD ColorLineaFocus( oDbf )

   METHOD CargaMenuSeleccionado()

   METHOD lEmptyAlias()

   /*
   Calculos--------------------------------------------------------------------
   */

   METHOD lLineaValida( lExcluirContadores )

   METHOD lLineaImpresa()                    INLINE ( ::oTiketLinea:FieldGetByName( "lImpCom" ) )
      METHOD SetLineaImpresa( lImpresa)      INLINE ( ::oTiketLinea:FieldPutByName( "lImpCom", lImpresa ) )

   METHOD nUnidadesLinea( uTmpL, lPicture )
   METHOD nUnidadesLineaTemp( uTmpL, lPicture )
   METHOD nUnidadesImpresas( uTmpL, lPicture )

   METHOD nPrecioLinea()                     INLINE ( Round( ::oTiketLinea:nPvpTil, ::nDecimalesImporte ) + Round( ::oTiketLinea:nPcmTil, ::nDecimalesImporte ) )  // Precio
   METHOD nPrecioLineaTemp()                 INLINE ( Round( ::oTemporalImpresionLinea:nPvpTil, ::nDecimalesImporte ) + Round( ::oTemporalImpresionLinea:nPcmTil, ::nDecimalesImporte ) )  // Precio

   METHOD nTotalLinea( uTmpL, lPic )
   METHOD nTotalLineaTemp( uTmpL, lPic )
   METHOD nTotalLineaUno( uTmpL, nVdv )
   METHOD nTotalLineaDos( uTmpL, nVdv )

   METHOD nTotalDescuento( uTmpL, nVdv )
   METHOD nTotalDescuentoUno( uTmpL, nVdv )
   METHOD nTotalDescuentoDos( uTmpL, nVdv )

   METHOD nTotalImpuestosEspeciales( uTmpL, nVdv )

   METHOD nTotalCobrosTemporales()
   METHOD sTotalCobros( cNumero )

   METHOD sTotalTiket()

   METHOD nUnidadesLineaComanda()      INLINE ( ::nUnidadesLinea( ::oTemporalComanda ) )
   METHOD nUnidadesImpresasComanda()   INLINE ( ::nUnidadesImpresas( ::oTemporalComanda ) )

   METHOD cDetalleComanda( uTmpL )
   METHOD cComentarioComanda( uTmpL )
   METHOD cDescripcionComanda( uTmpL )

   //-----------------------------------------------------------------------//

   METHOD lEmptyDocumento()            INLINE ( Empty( ::oTiketCabecera:cNumTik ) .and. Empty( ::oTemporalLinea:OrdKeyCount() ) )
   METHOD lEditableDocumento()         INLINE ( !::oTiketCabecera:lCloTik )
   METHOD lEmptyLineas()               INLINE ( !Empty( ::oTiketCabecera:cNumTik ) .and. Empty( ::oTemporalLinea:OrdKeyCount() ) )

   METHOD lValidatePreSave()

   METHOD lValidTurno()

   METHOD GuardaCobros()               INLINE ( ::oTpvCobros:ArchivaCobros() )

   // Documentos---------------------------------------------------------------

   METHOD GuardaDocumento( lZap )

   METHOD GuardaDocumentoAlbaran()

   //-----------------------------------------------------------------------//

   METHOD GuardaDocumentoPendiente()

   METHOD GuardaDocumentoCerrado()

   METHOD SetDocumentoPagado()

   //-----------------------------------------------------------------------//

   METHOD CargaDocumento()

   METHOD EliminarDocumento()

   METHOD GetTotalDocumento( uValue )  INLINE ( oSend( ::sTotal, uValue ) )

   METHOD GetLineaAlbaranes( uValue )  INLINE ( Eval( &( uValue ), ::oAlbaranClienteLinea:cAlias ) )

   METHOD ProcesaComandas()

   METHOD ProcesaAnulacion()

   METHOD ProcesaLineas()

   //-----------------------------------------------------------------------//

   METHOD ProcesaDocumentosInternos()  INLINE ( ::ProcesaComandas(), ::ProcesaAnulacion(), ::ProcesaLineas() )

   //-----------------------------------------------------------------------//

   METHOD ImprimeDocumento()

   //-----------------------------------------------------------------------//

   METHOD ImprimePago()
   METHOD ImprimeComanda( cImpresora )

   METHOD ImprimeAnulacion( cImpresora )

   METHOD ImprimeTicket()

   METHOD PrevisualizaTicket()

   METHOD ImprimeEntrega()

   METHOD ImprimeRegalo()

   METHOD ImprimeDesglosado()

   METHOD SonidoComanda( cImpresora )

   //------------------------------------------------------------------------//

   METHOD setAliasDocumento()
   METHOD validateAliasDocumento( cNombreUbicacion ) 

   METHOD BuildReport( nDevice, nCopies, cPrinter, lComanda, lAnulacion )

   METHOD DataReport()
   METHOD VariableReport()

   METHOD BuildRelationReport()
   METHOD ClearRelationReport()

   METHOD nPrecioPorPersona()          INLINE ( ::sTotal:nTotalDocumento / NotCero( ::oTiketCabecera:nNumCom ) )

   METHOD InitDocumento( nUbicacion )

   METHOD UltimoCambio()

   METHOD EscribeVisor()

   //------------------------------------------------------------------------//

   METHOD OpenCajon()               	INLINE ( oUser():OpenCajon( ::nView ) )
   METHOD OpenCajonDirect()            INLINE ( oUser():OpenCajonDirect( ::nView ) )

   //------------------------------------------------------------------------//

   METHOD AgregaLineaVisor( aTextoLinea, nLinea )

   METHOD SetTotal()

   METHOD nTotalTemporalDivision( oDbfTemporal )

   METHOD cTxtUbicacion()

   METHOD cUbicacion()

   METHOD cInfo()
   METHOD cInfoPendiente()

   METHOD cEstado()

   METHOD SetCombinando( lCombinando )

   METHOD ShowCombinado( lShowCombinando )

   METHOD SelectorOrdenComanda( lCombinando )
   METHOD initOrdenComanda( cOrden )

   METHOD SetCalculadora()

   METHOD GetPesoBalanza()

   METHOD KillResource()               INLINE ( ::lKillResource   := .t., ::EnableDialog(), ::oDlg:End() )

   METHOD GeneraVale()
   METHOD lLiquidaVale( sCobro )

   METHOD cValeTicket( cNumeroTicket )

   METHOD cTextoLineaTicket()          INLINE ( ::cTextoLinea( ::oTiketLinea ) )

   METHOD cTextoLineaTicketLeng()      INLINE ( ::cTextoLineaLeng( ::oTiketLinea, ::oArticulosLenguajes ) )

   METHOD cTextoLineaTicketTemp()      INLINE ( ::cTextoLinea( ::oTemporalImpresionLinea ) )

   METHOD cTextoLineaTicketLengTemp()  INLINE ( ::cTextoLineaLeng( ::oTemporalImpresionLinea, ::oArticulosLenguajes ) )

   METHOD cTextoLinea( oDbf )

   METHOD cTextoLineaLeng( oDbf, oArticulosLenguajes )

   METHOD cTextoLineaDivision( oDbf )

   METHOD lShowEscandallos()

   METHOD OnClickImportesExactos()

   METHOD TreeReportingChanged() 

   METHOD ResizedCol( nSize )

   METHOD ResizedFont( nSize )

   METHOD ActualizaTarifaCliente()      

   METHOD CambiarUnidadesPrecio( lGetPrecio )

   METHOD isArticulosSinPeso()

   METHOD LoadTemporalImpresionlinea()

   METHOD OnClickReabrirTicket()

   METHOD getComensales()                    

   METHOD setTicketParcial()
   METHOD setTicketPagado()

   METHOD setCodigoOrdenComandaActual( idOrdenComanda )        INLINE ( ::cCodigoOrdenComandaActual := idOrdenComanda )
   METHOD getCodigoOrdenComandaActual()                        INLINE ( ::cCodigoOrdenComandaActual )

   METHOD setTextButtonOrdenComandaActual( textoOrdenComanda ) INLINE ( if (  !empty( ::oBtnOrdenComandaActual ) .and. ::l1280(),;
                                                                              ::oBtnOrdenComandaActual:setText( textoOrdenComanda ), ) )

   METHOD browseLineasDragBegin()                              
   METHOD browseLineasDropOver()
      
   METHOD moveLineUp()
   METHOD moveLineDown()

   METHOD isLineaValidaComanda( lCopia )

END CLASS

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

METHOD New( oMenuItem, oWnd ) CLASS TpvTactil

   DEFAULT oMenuItem          := "01064"
   DEFAULT oWnd               := oWnd()

   FWCleanResource()

   ::oWnd                     := oWnd

   if oMenuItem != nil
      ::nLevel                := nLevelUsr( oMenuItem )
   else
      ::nLevel                := 0
   end if

   ::nScreenHorzRes           := GetSysMetrics( 0 )
   ::nScreenVertRes           := GetSysMetrics( 1 )

   ::lOpenFiles               := .f. 
   ::lKillResource            := .f.
   ::lHideCalculadora         := .t.
   ::lCopiaComanda            := .f.

   DEFINE CURSOR ::oDragCursor DRAG

   if ::l1024()
      ::cResource             := "TpvTactil"
      ::lImagenArticulos      := !uFieldEmpresa( "lImgArt" )
   else
      ::cResource             := "TpvTactilSmall"
      ::lImagenArticulos      := .f.
   end if   

   if ::lImagenArticulos

      do case
         case ::nScreenVertRes == 560

            ::nImageViewWItem := 71 + 4
            ::nImageViewHItem := 67 + 38

         case ::nScreenVertRes == 752

            ::nImageViewWItem := 95 + 4
            ::nImageViewHItem := 81 + 38

         otherwise

            ::nImageViewWItem := 86 + 4
            ::nImageViewHItem := 97 + 38 

      end case

      ::nImageViewVSep        := 0
      ::nImageViewHSep        := 4
      ::nImageViewTitle       := 38
      ::aImageViewTextMargin  := { 2, 2, 0, 2 }

   else

      do case
         case ::nScreenVertRes == 560

            ::nImageViewWItem := 96 + 6
            ::nImageViewHItem := 50 + 28

         case ::nScreenVertRes == 752

            ::nImageViewWItem := 140 + 6
            ::nImageViewHItem := 56 + 28

         otherwise

            ::nImageViewWItem := 122 + 6
            ::nImageViewHItem := 60 + 28

      end case

      ::nImageViewVSep        := 5
      ::nImageViewHSep        := 4
      ::nImageViewTitle       := 38
      ::aImageViewTextMargin  := { 2, 2, 32, 2 }

   end if

   ::aFamilias                := {}
   ::aLineas                  := {}

   ::oBtnNum                  := Array( 15 )

   ::oFntBrw                  := TFont():New( "Segoe UI",  0, ::ResizedFont( 20 ), .f., .t. )
   ::oFntFld                  := TFont():New( "Segoe UI",  0, ::ResizedFont( 26 ), .f., .t. )
   ::oFntEur                  := TFont():New( "Segoe UI",  0, ::ResizedFont( 30 ), .f., .f. )
   ::oFntDlg                  := TFont():New( "Segoe UI", 12, ::ResizedFont( 32 ), .f., .f. )
   ::oFntDto                  := TFont():New( "Segoe UI",  0, ::ResizedFont( 40 ), .f., .f. ) 
   ::oFntNum                  := TFont():New( "Segoe UI",  0, ::ResizedFont( 46 ), .f., .f. )

   ::cSayZona                 := "Zona"  
   ::cSayInfo                 := ""

   ::nTotalTicket             := 0
   ::nTotalPrecioPersona      := 0

   ::cGetUnidades             := Space( 100 )

   ::nTarifaSolo              := Max( uFieldEmpresa( "nPreTPro" ), 1 )
   ::nTarifaCombinado         := Max( uFieldEmpresa( "nPreTCmb" ), 1 )

   ::lCombinando              := .f.
   ::lCombinandoDos           := .f.
   ::lShowCombinado           := .f.

   oThis                      := Self

Return Self

//---------------------------------------------------------------------------//

METHOD End() CLASS TpvTactil

   if !Empty( ::oFntNum )
      ::oFntNum:End()
   end if

   if !Empty( ::oFntFld )
      ::oFntFld:End()
   end if

   if !Empty( ::oFntEur )
      ::oFntEur:End()
   end if

   if !Empty( ::oFntBrw )
      ::oFntBrw:End()
   end if

   if !Empty( ::oFntDlg )
      ::oFntDlg:End()
   end if

   if !Empty( ::oFntDto )
      ::oFntDto:End()
   end if

   if !Empty( ::oLstArticulos )
      ::oLstArticulos:End()
   end if

   if !Empty( ::oLstFavoritos )
      ::oLstFavoritos:End()
   end if

   if !Empty( ::oLstOrden )
      ::oLstOrden:End()
   end if 

   if !Empty( ::oTpvCobros )
      ::oTpvCobros:End()
   end if

   if !Empty( ::oTpvUtilidadesMesa )
      ::oTpvUtilidadesMesa:End()
   end if

   if !Empty( ::oTpvListaTicket )
      ::oTpvListaTicket:End()
   end if

   if !Empty( ::oTurno )
      ::oTurno:End()
   end if

   if !Empty( ::oOfficeBar )
      ::oOfficeBar:End()
   end if

   if !Empty( ::oBrwFamilias )
      ::oBrwFamilias:End()
   end if

   if !Empty( ::oBrwLineas )
      ::oBrwLineas:End()
   end if

   ::DestroyFastReport()

   if ::lOpenFiles
      ::CloseFiles()
   end if

   if !empty(::oTimer)
      ::oTimer:End()
   end if 

   ::oTpvCobros      := nil
   ::oTpvListaTicket := nil

   ::oTurno          := nil

   ::oOfficeBar      := nil

   ::oLstArticulos   := nil
   ::oLstFavoritos   := nil
   ::oLstOrden       := nil

   ::oFntNum         := nil
   ::oFntEur         := nil
   ::oFntFld         := nil
   ::oFntBrw         := nil
   ::oFntDlg         := nil
   ::oFntDto         := nil

   if !empty( ::oDragCursor )
      ::oDragCursor:end()
   end if

   Self              := nil

   CheckRes()

Return .t.

//---------------------------------------------------------------------------//

METHOD Activate( lAlone ) CLASS TpvTactil

   DEFAULT lAlone    := .f.

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return .f.
   end if

   if oWnd() != nil
      SysRefresh(); oWnd():CloseAll(); SysRefresh()
   end if

   if !lCurSesion()
      MsgStop( "No hay sesiones activas, imposible añadir documentos." )
      Return .f.
   end if

   if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lMaster()
      msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
      Return .f.
   end if

   /*
   Abrimos los ficheros necesarios---------------------------------------------
   */

   if !::OpenFiles()
      Return .f.
   end if

   /*
   Objetos necesarios----------------------------------------------------------
   */

   ::oTpvCobros               := TpvCobros():New( Self )

   ::oTpvListaTicket          := TpvListaTicket():New( Self )

   ::oTpvUtilidadesMesa       := TpvUtilidadesMesa():New( Self )

   ::oTurno                   := TTurno():New( cPatEmp(), cDriver(), oWnd(), "01001" )

   if lFamInTpv( ::oFamilias:cAlias )

      ::lAlone       := lAlone
      ::lGetUsuario  := !lAlone

      // Creamos las base de datos temporales-------------------------------------

      ::CreateTemporal()

      // Cargamos el Array de Familias--------------------------------------------

      ::CargaBrowseFamilias()

      // Inicializa los valores para el documento---------------------------------

      ::InitDocumento( ubiGeneral )

      // Creamos el objeto FastReport---------------------------------------------

      ::InstanceFastReport()

      // Cargamos los valores por defecto-----------------------------------------

      ::Resource()

   else

      MsgStop( "No hay familias de artículos seleccionadas para trabajar con el TPV táctil", uFieldEmpresa( "CodEmp" ) + " - " + Rtrim( uFieldEmpresa( "cNombre" ) ) )

   end if

   /*
   Eliminamos las tablas temporales--------------------------------------------
   */

   ::DestroyTemporal()

   /*
   Cerramos todo---------------------------------------------------------------
   */

   ::End()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TpvTactil

   local oBlock
   local oError
   local cVisor

   if ::lOpenFiles
      MsgStop( 'Imposible abrir ficheros de tickets de clientes' )
      Return ( .f. )
   end if

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::lOpenFiles               := .t.

   ::nView                    := D():CreateView()
   
   D():Get( "LogPorta", ::nView )

   DATABASE NEW ::oTiketCabecera                            PATH ( cPatEmp() )   FILE "TIKET.DBF"           VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTiketLinea                               PATH ( cPatEmp() )   FILE "TIKEL.DBF"           VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"
   ::oTiketLinea:ordsetfocus( "nOrdLin" )

   DATABASE NEW ::oTiketCobro                               PATH ( cPatEmp() )   FILE "TIKEP.DBF"           VIA ( cDriver() ) SHARED INDEX "TIKEP.CDX"

   DATABASE NEW ::oTiketNumeroSerie                         PATH ( cPatEmp() )   FILE "TIKES.DBF"           VIA ( cDriver() ) SHARED INDEX "TIKES.CDX"

   DATABASE NEW ::oCliente                                  PATH ( cPatCli() )   FILE "CLIENT.DBF"          VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oCajaCabecera                             PATH ( cPatDat() )   FILE "Cajas.DBF"           VIA ( cDriver() ) SHARED INDEX "Cajas.CDX"

   DATABASE NEW ::oCajaLinea                                PATH ( cPatDat() )   FILE "CajasL.DBF"          VIA ( cDriver() ) SHARED INDEX "CAJASL.CDX"

   DATABASE NEW ::oUsuario                                  PATH ( cPatDat() )   FILE "USERS.DBF"           VIA ( cDriver() ) SHARED INDEX "USERS.CDX"

   DATABASE NEW ::oArticulo                                 PATH ( cPatArt() )   FILE "ARTICULO.DBF"        VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oCodigoBarraArticulo                      PATH ( cPatArt() )   FILE "ArtCodebar.DBF"      VIA ( cDriver() ) SHARED INDEX "ArtCodebar.CDX"

   DATABASE NEW ::oArticulosEscandallos                     PATH ( cPatArt() )   FILE "ARTKIT.DBF"          VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   DATABASE NEW ::oArticulosLenguajes                       PATH ( cPatArt() )   FILE "ARTLENG"             VIA ( cDriver() ) SHARED INDEX "ARTLENG"

   DATABASE NEW ::oArticulosOfertas                         PATH ( cPatArt() )   FILE "OFERTA.DBF"          VIA ( cDriver() ) SHARED INDEX "OFERTA.CDX"

   DATABASE NEW ::oFormaPago                                PATH ( cPatEmp() )   FILE "FPAGO.DBF"           VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

   DATABASE NEW ::oPropiedadesLinea                         PATH ( cPatEmp() )   FILE "TBLPRO.DBF"          VIA ( cDriver() ) SHARED INDEX "TBLPRO.CDX"

   DATABASE NEW ::oFamilias                                 PATH ( cPatArt() )   FILE "FAMILIAS.DBF"        VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oAlbaranClienteCabecera                   PATH ( cPatEmp() )   FILE "ALBCLIT.DBF"         VIA ( cDriver() ) SHARED INDEX "ALBCLIT.CDX"

   DATABASE NEW ::oAlbaranClienteLinea                      PATH ( cPatEmp() )   FILE "ALBCLIL.DBF"         VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oAlbaranClienteSerie                      PATH ( cPatEmp() )   FILE "ALBCLIS.DBF"         VIA ( cDriver() ) SHARED INDEX "ALBCLIS.CDX"

   DATABASE NEW ::oAlbaranClientePago                       PATH ( cPatEmp() )   FILE "ALBCLIP.DBF"         VIA ( cDriver() ) SHARED INDEX "ALBCLIP.CDX"

   DATABASE NEW ::oAlbaranClienteIncidencia                 PATH ( cPatEmp() )   FILE "ALBCLII.DBF"         VIA ( cDriver() ) SHARED INDEX "ALBCLII.CDX"

   DATABASE NEW ::oAlbaranClienteDocumento                  PATH ( cPatEmp() )   FILE "ALBCLID.DBF"         VIA ( cDriver() ) SHARED INDEX "ALBCLID.CDX"

   DATABASE NEW ::oFacturaClienteCabecera                   PATH ( cPatEmp() )   FILE "FACCLIT.DBF"         VIA ( cDriver() ) SHARED INDEX "FACCLIT.CDX"

   DATABASE NEW ::oFacturaClienteLinea                      PATH ( cPatEmp() )   FILE "FACCLIL.DBF"         VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacturaClienteSerie                      PATH ( cPatEmp() )   FILE "FACCLIS.DBF"         VIA ( cDriver() ) SHARED INDEX "FACCLIS.CDX"

   DATABASE NEW ::oFacturaClientePago                       PATH ( cPatEmp() )   FILE "FACCLIP.DBF"         VIA ( cDriver() ) SHARED INDEX "FACCLIP.CDX"

   DATABASE NEW ::oAnticipoCliente                          PATH ( cPatEmp() )   FILE "AntCliT.DBF"         VIA ( cDriver() ) SHARED INDEX "AntCliT.CDX"

   DATABASE NEW ::oObras                                    PATH ( cPatEmp() )   FILE "ObrasT.DBF"          VIA ( cDriver() ) SHARED INDEX "ObrasT.CDX"

   DATABASE NEW ::oAgentes                                  PATH ( cPatCli() )   FILE "AGENTES.DBF"         VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"

   DATABASE NEW ::oRuta                                     PATH ( cPatEmp() )   FILE "RUTA.DBF"            VIA ( cDriver() ) SHARED INDEX "RUTA.CDX"

   DATABASE NEW ::oAlmacen                                  PATH ( cPatAlm() )   FILE "ALMACEN.DBF"         VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

   DATABASE NEW ::oArticuloPropiedades                      PATH ( cPatArt() )   FILE "ARTDIV.DBF"          VIA ( cDriver() ) SHARED INDEX "ARTDIV.CDX"

   DATABASE NEW ::oTarifaPrecioLinea                        PATH ( cPatArt() )   FILE "TARPREL.DBF"         VIA ( cDriver() ) SHARED INDEX "TARPREL.CDX"

   DATABASE NEW ::oTarifaPrecioLineaAgente                  PATH ( cPatArt() )   FILE "TARPRES.DBF"         VIA ( cDriver() ) SHARED INDEX "TARPRES.CDX"

   DATABASE NEW ::oDocument                                 PATH ( cPatEmp() )   FILE "RDOCUMEN.DBF"        VIA ( cDriver() ) SHARED INDEX "RDOCUMEN.CDX"

   DATABASE NEW ::oAtipicasCliente                          PATH ( cPatCli() )   FILE "CliAtp.DBF"          VIA ( cDriver() ) SHARED INDEX "CliAtp.CDX"

   DATABASE NEW ::oContadores                               PATH ( cPatEmp() )   FILE "NCOUNT.DBF"          VIA ( cDriver() ) SHARED INDEX "NCOUNT.CDX"

   DATABASE NEW ::oTipoIVA                                  PATH ( cPatDat() )   FILE "TIVA.DBF"            VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDivisas                                  PATH ( cPatDat() )   FILE "DIVISAS.DBF"         VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   DATABASE NEW ::oFiltroPorUsuario                         PATH ( cPatDat() )   FILE "CNFFLT.DBF"          VIA ( cDriver() ) SHARED INDEX "CNFFLT.CDX"

   DATABASE NEW ::oComisionesAgentes                        PATH ( cPatEmp() )   FILE "AGECOM.DBF"          VIA ( cDriver() ) SHARED INDEX "AGECOM.CDX"

   DATABASE NEW ::oEmpresa                                  PATH ( cPatDat() )   FILE "EMPRESA.DBF"         VIA ( cDriver() ) SHARED INDEX "EMPRESA.CDX"

   DATABASE NEW ::oFactoresConversion                       PATH ( cPatDat() )   FILE "TBLCNV.DBF"          VIA ( cDriver() ) SHARED INDEX "TBLCNV.CDX"

   DATABASE NEW ::oPedidoClienteCabecera                    PATH ( cPatEmp() )   FILE "PEDCLIT.DBF"         VIA ( cDriver() ) SHARED INDEX "PEDCLIT.CDX"

   DATABASE NEW ::oPedidoClienteLinea                       PATH ( cPatEmp() )   FILE "PEDCLIL.DBF"         VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oPedidoClienteEntregaCuenta               PATH ( cPatEmp() )   FILE "PEDCLIP.DBF"         VIA ( cDriver() ) SHARED INDEX "PEDCLIP.CDX"

   DATABASE NEW ::oPresupuestoClienteCabecera               PATH ( cPatEmp() )   FILE "PRECLIT.DBF"         VIA ( cDriver() ) SHARED INDEX "PRECLIT.CDX"

   DATABASE NEW ::oPresupuestoClienteLinea                  PATH ( cPatEmp() )   FILE "PRECLIL.DBF"         VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   DATABASE NEW ::oFacturaRectificativaCabecera             PATH ( cPatEmp() )   FILE "FACRECT.DBF"         VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacturaRectificativaLinea                PATH ( cPatEmp() )   FILE "FACRECL.DBF"         VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oFacturaRectificativaNumeroSerie          PATH ( cPatEmp() )   FILE "FACRECS.DBF"         VIA ( cDriver() ) SHARED INDEX "FACRECS.CDX"

   DATABASE NEW ::oAlbaranProveedorCabecera                 PATH ( cPatEmp() )   FILE "ALBPROVT.DBF"        VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbaranProveedorLinea                    PATH ( cPatEmp() )   FILE "ALBPROVL.DBF"        VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oAlbaranProveedorNumeroSerie              PATH ( cPatEmp() )   FILE "AlbPrvS.DBF"         VIA ( cDriver() ) SHARED INDEX "AlbPrvS.CDX"

   DATABASE NEW ::oFacturaProveedorCabecera                 PATH ( cPatEmp() )   FILE "FACPRVT.DBF"         VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacturaProveedorLinea                    PATH ( cPatEmp() )   FILE "FACPRVL.DBF"         VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oFacturaProveedorNumeroSerie              PATH ( cPatEmp() )   FILE "FACPRVS.DBF"         VIA ( cDriver() ) SHARED INDEX "FACPRVS.CDX"

   DATABASE NEW ::oRectificativaProveedorCabecera           PATH ( cPatEmp() )   FILE "RctPrvT.DBF"         VIA ( cDriver() ) SHARED INDEX "RctPrvT.CDX"

   DATABASE NEW ::oRectificativaProveedorLinea              PATH ( cPatEmp() )   FILE "RctPrvL.DBF"         VIA ( cDriver() ) SHARED INDEX "RctPrvL.CDX"

   DATABASE NEW ::oRectificativaProveedorNumeroSerie        PATH ( cPatEmp() )   FILE "RctPrvS.DBF"         VIA ( cDriver() ) SHARED INDEX "RctPrvS.CDX"

   DATABASE NEW ::oMovimientosAlmacen                       PATH ( cPatEmp() )   FILE "HISMOV.DBF"          VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"

   DATABASE NEW ::oMovimientosAlmacenNumeroSerie            PATH ( cPatEmp() )   FILE "MOVSER.DBF"          VIA ( cDriver() ) SHARED INDEX "MOVSER.CDX"

   DATABASE NEW ::oComentariosCabecera                      PATH ( cPatArt() )   FILE "COMENTARIOST.DBF"    VIA ( cDriver() ) SHARED INDEX "COMENTARIOST.CDX"

   DATABASE NEW ::oComentariosLinea                         PATH ( cPatArt() )   FILE "COMENTARIOSL.DBF"    VIA ( cDriver() ) SHARED INDEX "COMENTARIOSL.CDX"

   DATABASE NEW ::oTemporadas                               PATH ( cPatArt() )   FILE "Temporadas.DBF"      VIA ( cDriver() ) SHARED INDEX "Temporadas.CDX"

   DATABASE NEW ::oParteProducionLinea                      PATH ( cPatEmp() )   FILE "PROLIN.DBF"          VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"

   DATABASE NEW ::oMaterialesProducion                      PATH ( cPatEmp() )   FILE "PROMAT.DBF"          VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"

   DATABASE NEW ::oMaterialesProducionSeries                PATH ( cPatEmp() )   FILE "PROSER.DBF"          VIA ( cDriver() ) SHARED INDEX "PROSER.CDX"

   DATABASE NEW ::oMaterialesNumeroSeries                   PATH ( cPatEmp() )   FILE "MatSer.DBF"          VIA ( cDriver() ) SHARED INDEX "MatSer.CDX"

   if uFieldEmpresa( "lOrdNomTpv" )

      ::oComentariosCabecera:OrdSetFocus( "cDescri" )
      ::oComentariosCabecera:GoTop()

      ::oComentariosLinea:OrdSetFocus( "cCodDes" )
      ::oComentariosLinea:GoTop()

   end if

   ::oCaptura                 := TCaptura():New( cPatDat() )
   ::oCaptura:OpenFiles()

   ::oBandera                 := TBandera():New()

   ::oStock                   := TStock():Create( cPatEmp() )
   if !::oStock:lOpenFiles()
      ::lOpenFiles            := .f.
   end if

   ::oNewImp                  := TNewImp():New( cPatEmp() )
   if !::oNewImp:OpenFiles()
         ::lOpenFiles         := .f.
   end if

   ::cVisor                   := cVisorEnCaja( oUser():cCaja(), ::oCajaCabecera )
   if !Empty( ::cVisor )
   ::oVisor                   := TVisor():Create( ::cVisor )
      if !Empty( ::oVisor )
      ::oVisor:Wellcome()
      end if
   end if

   ::cImpresora               := cImpresoraTicketEnCaja( oUser():cCaja(), ::oCajaCabecera )

   ::oUndMedicion             := UniMedicion():Create( cPatEmp() )
   if !::oUndMedicion:OpenFiles()
      ::lOpenFiles            := .f.
   end if

   ::oRestaurante             := TTpvRestaurante():New( cPatEmp() )
   if !::oRestaurante:OpenFiles()
      ::lOpenFiles            := .f.
   else
      ::oRestaurante:SetSender( Self )
      ::oRestaurante:BuildSalas()
   end if

   ::oInvitacion              := TInvitacion():Create( cPatEmp() )
   if !::oInvitacion:OpenFiles()
      ::lOpenFiles            := .f.
   end if

   ::oFideliza                := TFideliza():CreateInit( cPatArt() )
   if !::oFideliza:OpenFiles()
      ::lOpenFiles            := .f.
   end if

   ::oTipArt                  := TTipArt():Create( cPatArt() )
   if !::oTipArt:OpenFiles()
      ::lOpenFiles            := .f.
   end if

   ::oFabricante              := TFabricantes():Create( cPatArt() )
   if !::oFabricante:OpenFiles()
      ::lOpenFiles            := .f.
   end if

   ::oTransportista           := TTrans():Create( cPatCli() )
   if !::oTransportista:OpenFiles()
      ::lOpenFiles            := .f.
   end if

   ::oOrdenComanda            := TOrdenComanda():Create( cPatArt() )
   if !::oOrdenComanda:OpenFiles()
      ::lOpenfiles            := .f.
   end if 

   ::oTpvMenu                 := TpvMenu():Create( cPatArt(), Self )
   if !::oTpvMenu:OpenService()
      ::lOpenfiles            := .f.
   end if 

   ::oTpvMenuOrdenes          := TpvMenuOrdenes():Create( cPatArt() )
   if !::oTpvMenuOrdenes:OpenService()
      ::lOpenfiles            := .f.
   end if 

   ::oTpvMenuArticulo         := TpvMenuArticulo():Create( cPatArt() )
   if !::oTpvMenuArticulo:OpenService()
      ::lOpenfiles            := .f.
   end if 

   ::cPictureImporte          := cPouDiv( cDivEmp(), ::oDivisas:cAlias )        // Picture de la divisa
   ::cPictureTotal            := cPorDiv( cDivEmp(), ::oDivisas:cAlias )        // Picture de la divisa redondeada
   ::nDecimalesImporte        := nDouDiv( cDivEmp(), ::oDivisas:cAlias )        // Decimales
   ::nDecimalesTotal          := nRouDiv( cDivEmp(), ::oDivisas:cAlias )        // Decimales redondeados
   ::cPictureUnidades         := MasUnd()

   /*
   Si no tiene ordenes para comandas-------------------------------------------
   */

   ::lEmptyOrdenComanda       := ::oOrdenComanda:EmptyOrdenComanda()

   /*
   Impresion del documento-----------------------------------------------------
   */

   ::oFormatosImpresion       := TFormatosImpresion():Load( ::oCajaCabecera:cAlias )

   ::cFormato                 := ::oFormatosImpresion:cFormatoEntrega
   ::cImpresora               := ::oFormatosImpresion:cPrinterEntrega
   ::nDispositivo             := IS_PRINTER
   ::nCopias                  := 1

   /*
   Visor-----------------------------------------------------------------------
   */

   cVisor                     := cVisorEnCaja( oUser():cCaja(), ::oCajaCabecera:cAlias )
   if !Empty( cVisor )
      ::oVisor                := TVisor():Create( cVisor )
      if !Empty( ::oVisor )
         ::oVisor:Wellcome()
      end if
   end if

   RECOVER USING oError

      ::lOpenFiles            := .f.

      EnableAcceso()

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de terminal punto de venta" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !::lOpenFiles
      ::CloseFiles()
   end if

Return ( ::lOpenfiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TpvTactil

   if ::oTiketCabecera != nil .and. ::oTiketCabecera:Used()
      ::oTiketCabecera:End()
   end if

   if ::oTiketLinea != nil .and. ::oTiketLinea:Used()
      ::oTiketLinea:End()
   end if

   if ::oTiketCobro != nil .and. ::oTiketCobro:Used()
      ::oTiketCobro:End()
   end if

   if ::oTiketNumeroSerie != nil .and. ::oTiketNumeroSerie:Used()
      ::oTiketNumeroSerie:End()
   end if

   if ::oCliente != nil .and. ::oCliente:Used()
      ::oCliente:End()
   end if

   if ::oCajaCabecera != nil .and. ::oCajaCabecera:Used()
      ::oCajaCabecera:End()
   end if

   if ::oCajaLinea != nil .and. ::oCajaLinea:Used()
      ::oCajaLinea:End()
   end if

   if ::oUsuario != nil .and. ::oUsuario:Used()
      ::oUsuario:End()
   end if

   if ::oArticulo != nil .and. ::oArticulo:Used()
      ::oArticulo:End()
   end if

   if ::oCodigoBarraArticulo != nil .and. ::oCodigoBarraArticulo:Used()
      ::oCodigoBarraArticulo:End()
   end if

   if ::oArticulosEscandallos != nil .and. ::oArticulosEscandallos:Used()
      ::oArticulosEscandallos:End()
   end if

   if ::oArticulosLenguajes != nil .and. ::oArticulosLenguajes:Used()
      ::oArticulosLenguajes:End()
   end if

   if ::oArticulosOfertas != nil .and. ::oArticulosOfertas:Used()
      ::oArticulosOfertas:End()
   end if

   if ::oFormaPago != nil .and. ::oFormaPago:Used()
      ::oFormaPago:End()
   end if

   if ::oPropiedadesLinea != nil .and. ::oPropiedadesLinea:Used()
      ::oPropiedadesLinea:End()
   end if

   if ::oFamilias != nil .and. ::oFamilias:Used()
      ::oFamilias:End()
   end if

   if ::oAlbaranClienteCabecera != nil .and. ::oAlbaranClienteCabecera:Used()
      ::oAlbaranClienteCabecera:End()
   end if

   if ::oAlbaranClienteLinea != nil .and. ::oAlbaranClienteLinea:Used()
      ::oAlbaranClienteLinea:End()
   end if

   if ::oAlbaranClienteSerie != nil .and. ::oAlbaranClienteSerie:Used()
      ::oAlbaranClienteSerie:End()
   end if

   if ::oAlbaranClientePago != nil .and. ::oAlbaranClientePago:Used()
      ::oAlbaranClientePago:End()
   end if

   if ::oAlbaranClienteIncidencia != nil .and. ::oAlbaranClienteIncidencia:Used()
      ::oAlbaranClienteIncidencia:End()
   end if

   if ::oAlbaranClienteDocumento != nil .and. ::oAlbaranClienteDocumento:Used()
      ::oAlbaranClienteDocumento:End()
   end if

   if ::oFacturaClienteCabecera != nil .and. ::oFacturaClienteCabecera:Used()
      ::oFacturaClienteCabecera:End()
   end if

   if ::oFacturaClienteLinea != nil .and. ::oFacturaClienteLinea:Used()
      ::oFacturaClienteLinea:End()
   end if

   if ::oFacturaClienteSerie != nil .and. ::oFacturaClienteSerie:Used()
      ::oFacturaClienteSerie:End()
   end if

   if ::oFacturaClientePago != nil .and. ::oFacturaClientePago:Used()
      ::oFacturaClientePago:End()
   end if

   if ::oAnticipoCliente != nil .and. ::oAnticipoCliente:Used()
      ::oAnticipoCliente:End()
   end if

   if ::oObras != nil .and. ::oObras:Used()
      ::oObras:End()
   end if

   if ::oAgentes != nil .and. ::oAgentes:Used()
      ::oAgentes:End()
   end if

   if ::oRuta != nil .and. ::oRuta:Used()
      ::oRuta:End()
   end if

   if ::oAlmacen != nil .and. ::oAlmacen:Used()
      ::oAlmacen:End()
   end if

   if ::oArticuloPropiedades != nil .and. ::oArticuloPropiedades:Used()
      ::oArticuloPropiedades:End()
   end if

   if ::oTarifaPrecioLinea != nil .and. ::oTarifaPrecioLinea:Used()
      ::oTarifaPrecioLinea:End()
   end if

   if ::oTarifaPrecioLineaAgente != nil .and. ::oTarifaPrecioLineaAgente:Used()
      ::oTarifaPrecioLineaAgente:End()
   end if

   if ::oDocument != nil .and. ::oDocument:Used()
      ::oDocument:End()
   end if

   if ::oAtipicasCliente != nil .and. ::oAtipicasCliente:Used()
      ::oAtipicasCliente:End()
   end if

   if ::oContadores != nil .and. ::oContadores:Used()
      ::oContadores:End()
   end if

   if ::oTipoIVA != nil .and. ::oTipoIVA:Used()
      ::oTipoIVA:End()
   end if

   if ::oDivisas != nil .and. ::oDivisas:Used()
      ::oDivisas:End()
   end if

   if ::oFiltroPorUsuario != nil .and. ::oFiltroPorUsuario:Used()
      ::oFiltroPorUsuario:End()
   end if

   if ::oComisionesAgentes != nil .and. ::oComisionesAgentes:Used()
      ::oComisionesAgentes:End()
   end if

   if ::oEmpresa != nil .and. ::oEmpresa:Used()
      ::oEmpresa:End()
   end if

   if ::oFactoresConversion != nil .and. ::oFactoresConversion:Used()
      ::oFactoresConversion:End()
   end if

   if ::oPedidoClienteCabecera != nil .and. ::oPedidoClienteCabecera:Used()
      ::oPedidoClienteCabecera:End()
   end if

   if ::oPedidoClienteLinea != nil .and. ::oPedidoClienteLinea:Used()
      ::oPedidoClienteLinea:End()
   end if

   if ::oPedidoClienteEntregaCuenta != nil .and. ::oPedidoClienteEntregaCuenta:Used()
      ::oPedidoClienteEntregaCuenta:End()
   end if

   if ::oPresupuestoClienteCabecera != nil .and. ::oPresupuestoClienteCabecera:Used()
      ::oPresupuestoClienteCabecera:End()
   end if

   if ::oPresupuestoClienteLinea != nil .and. ::oPresupuestoClienteLinea:Used()
      ::oPresupuestoClienteLinea:End()
   end if

   if ::oFacturaRectificativaCabecera != nil .and. ::oFacturaRectificativaCabecera:Used()
      ::oFacturaRectificativaCabecera:End()
   end if

   if ::oFacturaRectificativaLinea != nil .and. ::oFacturaRectificativaLinea:Used()
      ::oFacturaRectificativaLinea:End()
   end if

   if ::oFacturaRectificativaNumeroSerie != nil .and. ::oFacturaRectificativaNumeroSerie:Used()
      ::oFacturaRectificativaNumeroSerie:End()
   end if

   if ::oAlbaranProveedorCabecera != nil .and. ::oAlbaranProveedorCabecera:Used()
      ::oAlbaranProveedorCabecera:End()
   end if

   if ::oAlbaranProveedorLinea != nil .and. ::oAlbaranProveedorLinea:Used()
      ::oAlbaranProveedorLinea:End()
   end if

   if ::oAlbaranProveedorNumeroSerie != nil .and. ::oAlbaranProveedorNumeroSerie:Used()
      ::oAlbaranProveedorNumeroSerie:End()
   end if

   if ::oFacturaProveedorCabecera != nil .and. ::oFacturaProveedorCabecera:Used()
      ::oFacturaProveedorCabecera:End()
   end if

   if ::oFacturaProveedorLinea != nil .and. ::oFacturaProveedorLinea:Used()
      ::oFacturaProveedorLinea:End()
   end if

   if ::oFacturaProveedorNumeroSerie != nil .and. ::oFacturaProveedorNumeroSerie:Used()
      ::oFacturaProveedorNumeroSerie:End()
   end if

   if ::oRectificativaProveedorCabecera != nil .and. ::oRectificativaProveedorCabecera:Used()
      ::oRectificativaProveedorCabecera:End()
   end if

   if ::oRectificativaProveedorLinea != nil .and. ::oRectificativaProveedorLinea:Used()
      ::oRectificativaProveedorLinea:End()
   end if

   if ::oRectificativaProveedorNumeroSerie != nil .and. ::oRectificativaProveedorNumeroSerie:Used()
      ::oRectificativaProveedorNumeroSerie:End()
   end if

   if ::oMovimientosAlmacen != nil .and. ::oMovimientosAlmacen:Used()
      ::oMovimientosAlmacen:End()
   end if

   if ::oMovimientosAlmacenNumeroSerie != nil .and. ::oMovimientosAlmacenNumeroSerie:Used()
      ::oMovimientosAlmacenNumeroSerie:End()
   end if

   if ::oComentariosCabecera != nil .and. ::oComentariosCabecera:Used()
      ::oComentariosCabecera:End()
   end if

   if ::oComentariosLinea != nil .and. ::oComentariosLinea:Used()
      ::oComentariosLinea:End()
   end if

   if ::oTemporadas != nil .and. ::oTemporadas:Used()
      ::oTemporadas:End()
   end if

   if ::oParteProducionLinea != nil .and. ::oParteProducionLinea:Used()
      ::oParteProducionLinea:End()
   end if

   if ::oMaterialesProducion != nil .and. ::oMaterialesProducion:Used()
      ::oMaterialesProducion:End()
   end if

   if ::oMaterialesProducionSeries != nil .and. ::oMaterialesProducionSeries:Used()
      ::oMaterialesProducionSeries:End()
   end if

   if ::oMaterialesNumeroSeries != nil .and. ::oMaterialesNumeroSeries:Used()
      ::oMaterialesNumeroSeries:End()
   end if

   if !Empty( ::oCaptura )
      ::oCaptura:End()
   end if

   if !Empty( ::oBandera )
      ::oBandera:End()
   end if

   if !Empty( ::oStock )
      ::oStock:end()
   end if

   if !Empty( ::oNewImp )
      ::oNewImp:End()
   end if

   if !Empty( ::oVisor )
      ::oVisor:End()
   end if

   if !Empty( ::oUndMedicion )
      ::oUndMedicion:end()
   end if

   if !Empty( ::oRestaurante )
      ::oRestaurante:End()
   end if

   if !Empty( ::oInvitacion )
      ::oInvitacion:End()
   end if

   if !Empty( ::oFideliza )
      ::oFideliza:End()
   end if

   if !Empty( ::oTipArt )
      ::oTipArt:End()
   end if

   if !Empty( ::oFabricante )
      ::oFabricante:End()
   end if

   if !Empty( ::oTransportista )
      ::oTransportista:End()
   end if

   if !Empty( ::oOrdenComanda )
      ::oOrdenComanda:End()
   end if

   if !Empty( ::oVisor )
      ::oVisor:End()
   end if

   if !empty( ::oTpvMenu )
      ::oTpvMenu:CloseService()
   end if 
   
   if !empty( ::oTpvMenuOrdenes )
      ::oTpvMenuOrdenes:End()
   end if 

   if !empty( ::oTpvMenuArticulo )
      ::oTpvMenuArticulo:End()
   end if 

   D():DeleteView( ::nView )

   ::oTiketCabecera                          := nil
   ::oTiketLinea                             := nil
   ::oTiketCobro                             := nil
   ::oTiketNumeroSerie                       := nil
   ::oCliente                                := nil
   ::oCajaCabecera                           := nil
   ::oCajaLinea                              := nil
   ::oUsuario                                := nil
   ::oArticulo                               := nil
   ::oCodigoBarraArticulo                    := nil
   ::oArticulosEscandallos                   := nil
   ::oArticulosLenguajes                     := nil
   ::oArticulosOfertas                       := nil
   ::oFormaPago                              := nil
   ::oPropiedadesLinea                       := nil
   ::oFamilias                               := nil
   ::oAlbaranClienteCabecera                 := nil
   ::oAlbaranClienteLinea                    := nil
   ::oAlbaranClienteSerie                    := nil
   ::oAlbaranClientePago                     := nil
   ::oAlbaranClienteIncidencia               := nil
   ::oAlbaranClienteDocumento                := nil
   ::oFacturaClienteCabecera                 := nil
   ::oFacturaClienteLinea                    := nil
   ::oFacturaClienteSerie                    := nil
   ::oFacturaClientePago                     := nil
   ::oAnticipoCliente                        := nil
   ::oObras                                  := nil
   ::oAgentes                                := nil
   ::oRuta                                   := nil
   ::oAlmacen                                := nil
   ::oArticuloPropiedades                    := nil
   ::oTarifaPrecioLinea                      := nil
   ::oTarifaPrecioLineaAgente                := nil
   ::oDocument                               := nil
   ::oAtipicasCliente                        := nil
   ::oContadores                             := nil
   ::oTipoIVA                                := nil
   ::oDivisas                                := nil
   ::oFiltroPorUsuario                       := nil
   ::oComisionesAgentes                      := nil
   ::oEmpresa                                := nil
   ::oFactoresConversion                     := nil
   ::oPedidoClienteCabecera                  := nil
   ::oPedidoClienteLinea                     := nil
   ::oPedidoClienteEntregaCuenta             := nil
   ::oPresupuestoClienteCabecera             := nil
   ::oPresupuestoClienteLinea                := nil
   ::oFacturaRectificativaCabecera           := nil
   ::oFacturaRectificativaLinea              := nil
   ::oFacturaRectificativaNumeroSerie        := nil
   ::oAlbaranProveedorCabecera               := nil
   ::oAlbaranProveedorLinea                  := nil
   ::oAlbaranProveedorNumeroSerie            := nil
   ::oFacturaProveedorCabecera               := nil
   ::oFacturaProveedorLinea                  := nil
   ::oFacturaProveedorNumeroSerie            := nil
   ::oRectificativaProveedorCabecera         := nil
   ::oRectificativaProveedorLinea            := nil
   ::oRectificativaProveedorNumeroSerie      := nil
   ::oMovimientosAlmacen                     := nil
   ::oMovimientosAlmacenNumeroSerie          := nil
   ::oComentariosCabecera                    := nil
   ::oComentariosLinea                       := nil
   ::oTemporadas                             := nil
   ::oParteProducionLinea                    := nil
   ::oMaterialesProducion                    := nil
   ::oMaterialesProducionSeries              := nil
   ::oMaterialesNumeroSeries                 := nil
   ::oCaptura                                := nil
   ::oBandera                                := nil
   ::oStock                                  := nil
   ::oNewImp                                 := nil
   ::oVisor                                  := nil
   ::oUndMedicion                            := nil
   ::oRestaurante                            := nil
   ::oInvitacion                             := nil
   ::oFideliza                               := nil
   ::oTipArt                                 := nil
   ::oFabricante                             := nil
   ::oTransportista                          := nil
   ::oOrdenComanda                           := nil 
   ::oOfficeBar                              := nil
   ::oVisor                                  := nil

Return .t.

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TpvTactil

   /*
   Definimos el diálogo-----------------------------------------------------
   */

   DEFINE DIALOG ::oDlg RESOURCE ( ::cResource )

   /*
   Browse de familias-------------------------------------------------------
   */

   ::oBrwFamilias                         := IXBrowse():New( ::oDlg )  

   ::oBrwFamilias:lRecordSelector         := .f.
   ::oBrwFamilias:lHScroll                := .f. 
   ::oBrwFamilias:lVScroll                := .t.
   ::oBrwFamilias:lHeader                 := .f.
   ::oBrwFamilias:lTransparent            := .f.
   ::oBrwFamilias:lAutoSort               := .f.
   ::oBrwFamilias:lKinetic                := .t.
   ::oBrwFamilias:nDataLines              := 1
   ::oBrwFamilias:nRowHeight              := 48

   ::oBrwFamilias:nMarqueeStyle           := MARQSTYLE_HIGHLROW

   ::oBrwFamilias:bClrSel                 := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }
   ::oBrwFamilias:bClrSelFocus            := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }

   ::oBrwFamilias:bLClicked               := {|| ::oBrwFamilias:Refresh() }

   ::oBrwFamilias:bChange                 := {|| ::ChangeFamilias() }
   ::oBrwFamilias:bRClicked               := {|| ::EditFamilia() } 

   ::oBrwFamilias:SetFont( ::oFntBrw ) // SetFont( ::oFntBrw )

   ::oBrwFamilias:CreateFromResource( 300 )

   ::oBrwFamilias:SetArray( ::aFamilias, , , .f. ) 

   with object ( ::oBrwFamilias:AddCol() )
      :nEditType        := TYPE_IMAGE
      :lBmpStretch      := .t.
      :nDataBmpAlign    := AL_LEFT
      :nWidth           := 51
      :bStrImage        := {|| ::aFamilias[ ::oBrwFamilias:nArrayAt, 4 ] }
   end with

   with object ( ::oBrwFamilias:AddCol() )
      :bStrData         := {|| ::aFamilias[ ::oBrwFamilias:nArrayAt, 1 ] }
      :nWidth           := 260
      :nDataStrAlign    := AL_LEFT
   end with

   /*
   Botones para acciones de las familias------------------------------------
   */

   ::oBtnFamiliasUp              := TButtonBmp():ReDefine( 302, {|| if( !Empty( ::oBrwFamilias ), ::oBrwFamilias:PageUp(), ) },     ::oDlg, , , .f., , , , .f., "gc_navigate_up2a_32" )
   ::oBtnFamiliasDown            := TButtonBmp():ReDefine( 303, {|| if( !Empty( ::oBrwFamilias ), ::oBrwFamilias:PageDown(), ) },   ::oDlg, , , .f., , , , .f., "gc_navigate_down2a_32" )
   
   ::oBtnPreviewDocumento        := TButtonBmp():ReDefine( 304, {|| ::PrevisualizaTicket() }, ::oDlg, , , .f., , , , .f., "gc_monitor_32" )
   ::oBtnPrintDocumento          := TButtonBmp():ReDefine( 305, {|| ::ImprimeTicket() }, ::oDlg, , , .f., , , , .f., "gc_printer2_32" )

   /*
   TViewImage de Articulos-----------------------------------------------------
   */

   ::oLstArticulos               := C5ImageView():Redefine( 200, ::oDlg )
   ::oLstArticulos:nWItem        := ::nImageViewWItem
   ::oLstArticulos:nHItem        := ::nImageViewHItem
   ::oLstArticulos:nVSep         := ::nImageViewVSep
   ::oLstArticulos:nHSep         := ::nImageViewHSep
   ::oLstArticulos:aTextMargin   := ::aImageViewTextMargin
   ::oLstArticulos:lTitle        := ::lImagenArticulos
   ::oLstArticulos:nHTitle       := ::nImageViewTitle
   ::oLstArticulos:lShowOption   := .f.
   ::oLstArticulos:lxVScroll     := .f.
   ::oLstArticulos:lxHScroll     := .f.
   ::oLstArticulos:lAdjust       := .f.
   ::oLstArticulos:nClrTextSel   := CLR_BLACK
   ::oLstArticulos:nClrPane      := CLR_WHITE
   ::oLstArticulos:nClrPaneSel   := CLR_WHITE
   ::oLstArticulos:nAlignText    := nOr( DT_TOP, DT_CENTER, DT_WORDBREAK )

   ::oLstArticulos:nOption       := 0
   ::oLstArticulos:bAction       := {|| ::ActionListArticulo() }
   ::oLstArticulos:bRClicked     := {|nRow, nCol| ::EditArticulo( nRow, nCol ) }

   ::oLstArticulos:SetFont( ::oFntBrw )

   if ::lImagenArticulos
      ::oLstArticulos:cAlphaBmp     := "Alpha"
      ::oLstArticulos:nAlphaLevel   := 150
   end if

   // Botones para acciones de los articulos-----------------------------------

   ::oBtnArticulosPageUp         := TButtonBmp():ReDefine( 500, {|| if( !Empty( ::oLstArticulos ), ::oLstArticulos:PageUp(), ) },    ::oDlg, , , .f., , , , .f., "gc_navigate_up2a_32" )
   ::oBtnArticulosPageDown       := TButtonBmp():ReDefine( 501, {|| if( !Empty( ::oLstArticulos ), ::oLstArticulos:PageDown(), ) },  ::oDlg, , , .f., , , , .f., "gc_navigate_down2a_32" )

   // Boton de orden de comanda------------------------------------------------

   if ::l1280()
      ::oBtnOrdenComandaActual   := TButton():ReDefine( 511, {|| ::SelectorOrdenComanda() }, ::oDlg, , , .f., , , "Orden comanda" )
      ::oBtnOrdenComandaActual:setFont( ::oFntNum )
   else
      ::oBtnOrdenComandaActual   := TButtonBmp():ReDefine( 505, {|| ::SelectorOrdenComanda() }, ::oDlg, , , .f., , , "", .f., "gc_sort_az_descending_32" ) //
   end if 
   
   ::oGetCambiarOrden            := TGetHlp():ReDefine( 506, {|u| if( pcount () == 0, ::cOrdenComanda, ::cOrdenComanda := u ) }, ::oDlg )
   ::oGetCambiarOrden:bWhen      := {|| .f. }
   ::oGetCambiarOrden:setColor( GetSysColor( COLOR_WINDOWTEXT ), GetSysColor( COLOR_WINDOW ) )
   ::oGetCambiarOrden:setFont( ::oFntNum )

   ::oBtnAgregarLibre            := TButtonBmp():ReDefine( 502, {|| ::AgregarLibre() }, ::oDlg, , , .f., , , , .f., "gc_more_32" ) //
   ::oBtnCombinado               := TButtonBmp():ReDefine( 503, {|| ::SetCombinando() }, ::oDlg, , , .f., , , , .f., "gc_pin_blue_32" )
   ::oBtnCalculadora             := TButtonBmp():ReDefine( 504, {|| ::SetCalculadora() }, ::oDlg, , , .f., , , , .f., "gc_calculator_32" )

   ::oBtnBalanza                 := TButtonBmp():ReDefine( 510, {|| ::GetPesoBalanza() }, ::oDlg, , , .f., , , , .f., "gc_scales_32" )

   /*
   Datos de la sala y del Usuario-------------------------------------------
   */

   REDEFINE SAY ::oSayImporte ; 
      PROMPT   "Total";
      FONT     ::oFntDlg ;
      ID       210 ;
      OF       ::oDlg

   ::oSayImporte:lWantClick      := .t.
   ::oSayImporte:OnClick         := {|| ::OnClickCobro() }

   REDEFINE SAY ::oTotalTicket ;
      PROMPT   ::nTotalTicket ;
      PICTURE  ::cPictureTotal ;
      FONT     ::oFntDlg ;
      ID       240 ;
      OF       ::oDlg

   ::oTotalTicket:lWantClick     := .t.
   ::oTotalTicket:OnClick        := {|| ::OnClickCobro() }

   REDEFINE SAY ::oSayPrecioPersona ;
      PROMPT   ::cSayPrecioPersona ;
      FONT     ::oFntBrw ;
      ID       260 ;
      OF       ::oDlg

   REDEFINE SAY ::oSayZona ;
      PROMPT   ::cSayZona;
      FONT     ::oFntBrw ;
      ID       270 ;
      OF       ::oDlg

   ::oSayZona:lWantClick         := .t.
   ::oSayZona:OnClick            := {|| ::OnClickCambiaUbicacion() }

   REDEFINE SAY ::oSayInfo ;
      PROMPT   ::cSayInfo;
      FONT     ::oFntBrw ;
      ID       280 ;
      OF       ::oDlg

   ::oSayInfo:lWantClick         := .t.
   ::oSayInfo:OnClick            := {|| ::OnClickCambiaUbicacion() }

   /*
   Browse de Lineas---------------------------------------------------------
   */

   ::oBrwLineas                  := IXBrowse():New( ::oDlg )

   ::oBrwLineas:bClrStd          := {|| ::ColorLinea() }
   ::oBrwLineas:bClrSel          := {|| ::ColorLineaSeleccionada() } 
   ::oBrwLineas:bClrSelFocus     := {|| ::ColorLineaFocus() }

   ::oBrwLineas:nClrText         := {|| if( ::oTemporalLinea:lKitChl, CLR_GRAY, CLR_BLACK ) } 

   ::oBrwLineas:lRecordSelector  := .f.
   ::oBrwLineas:lHScroll         := .f. 
   ::oBrwLineas:lVScroll         := .f.

   ::oBrwLineas:nMarqueeStyle    := MARQSTYLE_HIGHLROW
   ::oBrwLineas:nRowHeight       := 36
   ::oBrwLineas:cName            := "Tactil.Lineas"

   ::oBrwLineas:bChange          := {|| ::CargaMenuSeleccionado() }

   ::oBrwLineas:SetFont( ::oFntBrw )

   ::oBrwLineas:oDragCursor      := ::oDragCursor
   ::oBrwLineas:bDragBegin       := { |r,c,f,o| ::browseLineasDragBegin( r, c, f, o ) }
   ::oBrwLineas:bDropOver        := { |u,r,c,f| ::browseLineasDropOver( u, r, c, f ) }

   ::oTemporalLinea:SetBrowse( ::oBrwLineas )

   ::oBrwLineas:CreateFromResource( 100 )

   with object ( ::oBrwLineas:AddCol() )
      :cHeader                := "Nº"
      :bEditValue             := {|| ::oTemporalLinea:nNumLin }
      :lHide                  := ::lEmptyOrdenComanda
      :nWidth                 := ::ResizedCol( 20 )
      :nDataStrAlign          := AL_RIGHT
      :nHeadStrAlign          := AL_RIGHT
   end with

   with object ( ::oBrwLineas:AddCol() )
      :cHeader                := "Nº Linea menú"
      :bEditValue             := {|| ::oTemporalLinea:nLinMnu }
      :lHide                  := .t.
      :nWidth                 := ::ResizedCol( 20 )
      :nDataStrAlign          := AL_RIGHT
      :nHeadStrAlign          := AL_RIGHT
   end with

   with object ( ::oBrwLineas:AddCol() )
      :cHeader                := "Propiedades"
      :bEditValue             := {|| cNombrePropiedad( ::oTemporalLinea:cCodPr1, ::oTemporalLinea:cValPr1, ::oPropiedadesLinea ) }
      :lHide                  := .t.
      :nWidth                 := ::ResizedCol( 20 )
   end with

   with object ( ::oBrwLineas:AddCol() )
      :cHeader                := "Or. comanda"
      :lHide                  := .t.
      :bEditValue             := {|| ::oOrdenComanda:cNombre( ::oTemporalLinea:cOrdOrd ) }
      :nWidth                 := ::ResizedCol( 30 )
   end with

   with object ( ::oBrwLineas:AddCol() )
      :cHeader                := "Inv."
      :bStrData               := {|| "" }
      :lHide                  := .t.
      :bEditValue             := {|| !Empty( ::oTemporalLinea:cCodInv ) }
      :nWidth                 := ::ResizedCol( 16 )
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwLineas:AddCol() )
      :cHeader                := "Prm."
      :bStrData               := {|| "" }
      :lHide                  := .t.
      :bEditValue             := {|| ::oTemporalLinea:lInPromo }
      :nWidth                 := ::ResizedCol( 16 )
      :SetCheck( { "gc_star2_blue_16", "Nil16" } )
   end with

   with object ( ::oBrwLineas:AddCol() )
      :cHeader                := "Und"
      :bEditValue             := {|| ::nUnidadesLinea( ::oTemporalLinea, .t. ) }
      :nWidth                 := ::ResizedCol( 60 )
      :nDataStrAlign          := AL_RIGHT
      :nHeadStrAlign          := AL_RIGHT
   end with

   with object ( ::oBrwLineas:AddCol() )
      :cHeader                := "Factor"
      :bEditValue             := {|| Trans( ::oTemporalLinea:nFacCnv, "@EZ 999,999.999999" ) }
      :nWidth                 := ::ResizedCol( 50 )
      :nDataStrAlign          := AL_RIGHT
      :nHeadStrAlign          := AL_RIGHT
      :lHide                  := .t.
   end with

   with object ( ::oBrwLineas:AddCol() )
      :cHeader                := "Detalle"
      :bEditValue             := {|| ::cTextoLinea() }
      :nWidth                 := if( ::lEmptyOrdenComanda, ::ResizedCol( 130 ), ::ResizedCol( 110 ) )
   end with

   with object ( ::oBrwLineas:AddCol() )
      :cHeader                := "%Dto"
      :bEditValue             := {|| Trans( ::oTemporalLinea:nDtoLin, "@EZ 999.99" ) }
      :lHide                  := .t.
      :nWidth                 := ::ResizedCol( 45 )
   end with

   with object ( ::oBrwLineas:AddCol() )
      :cHeader                := "Total"
      :bEditValue             := {|| ::nTotalLinea( ::oTemporalLinea, .t. ) }
      :nWidth                 := ::ResizedCol( 70 )
      :nDataStrAlign          := AL_RIGHT
      :nHeadStrAlign          := AL_RIGHT 
   end with

   /*
   Botones para acciones de las lineas--------------------------------------
   */

   ::oBtnLineasTop            := TButtonBmp():ReDefine( 120, {|| ::oBrwLineas:GoUp() },      ::oDlg, , , .f., , , , .f., "gc_arrow_up_32" )
   ::oBtnLineasBottom         := TButtonBmp():ReDefine( 121, {|| ::oBrwLineas:GoDown() },    ::oDlg, , , .f., , , , .f., "gc_arrow_down_32" )
   ::oBtnLineasDelete         := TButtonBmp():ReDefine( 122, {|| ::OnClickEliminarLinea() }, ::oDlg, , , .f., , , , .f., "Delete_32" )
   ::oBtnLineasComentarios    := TButtonBmp():ReDefine( 123, {|| ::InitComentarios(.t.) },   ::oDlg, , , .f., , , , .f., "gc_message_32" )
   ::oBtnLineasEscandallos    := TButtonBmp():ReDefine( 124, {|| ::lShowEscandallos() },     ::oDlg, , , .f., , , , .f., "gc_text_tree_32" ) 

   /*
   Get para las busquedas de códigos de barras------------------------------
   */

   if ::l1024()
      ::oBtnPrecioUnidades       := TButtonBmp():ReDefine( 601, {|| ::CambiarUnidadesPrecio() }, ::oDlg, , , .f., , , , .f., "Paginator_32" )
   end if

   REDEFINE GET ::oGetUnidades VAR ::cGetUnidades;
      ID       600 ;
      WHEN     .f. ;
      FONT     ::oFntEur ;
      OF       ::oDlg

   ::oGetUnidades:OnKeyDown   := {|| 0 } // {| o, nKey, nFlag | ::oDlgKeyDown( o, nKey, nFlag ) }

   /*
   Teclado para el tpv-------------------------------------------------------
   */

   REDEFINE BUTTON ::oBtnNum[ 1 ] ;
      ID       101 ;
      OF       ::oDlg ;
      ACTION   ( ::KeyChar( "1" ) ) ;
      PROMPT   "1" ;

   ::oBtnNum[ 1 ]:SetFont( ::oFntNum )

   REDEFINE BUTTON ::oBtnNum[ 2 ] ;
      ID       102 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "2" ) );
      PROMPT   "2" ;

   ::oBtnNum[ 2 ]:SetFont( ::oFntNum )

   REDEFINE BUTTON ::oBtnNum[ 3 ] ;
      ID       103 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "3" ) );
      PROMPT   "3" ;

   ::oBtnNum[ 3 ]:SetFont( ::oFntNum )

   REDEFINE BUTTON ::oBtnNum[ 4 ] ;
      ID       104 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "4" ) );
      PROMPT   "4" ;

   ::oBtnNum[ 4 ]:SetFont( ::oFntNum )

   REDEFINE BUTTON ::oBtnNum[ 5 ] ;
      ID       105 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "5" ) );
      PROMPT   "5" ;

   ::oBtnNum[ 5 ]:SetFont( ::oFntNum )

   REDEFINE BUTTON ::oBtnNum[ 6 ] ;
      ID       106 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "6" ) );
      PROMPT   "6" ;

   ::oBtnNum[ 6 ]:SetFont( ::oFntNum )

   REDEFINE BUTTON ::oBtnNum[ 7 ] ;
      ID       107 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "7" ) );
      PROMPT   "7" ;

   ::oBtnNum[ 7 ]:SetFont( ::oFntNum )

   REDEFINE BUTTON ::oBtnNum[ 8 ] ;
      ID       108 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "8" ) );
      PROMPT   "8" ;

   ::oBtnNum[ 8 ]:SetFont( ::oFntNum )

   REDEFINE BUTTON ::oBtnNum[ 9 ] ;
      ID       109 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "9" ) );
      PROMPT   "9" ;

   ::oBtnNum[ 9 ]:SetFont( ::oFntNum )

   REDEFINE BUTTON ::oBtnNum[ 10 ] ;
      ID       110 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "0" ) );
      PROMPT   "0" ;

   ::oBtnNum[ 10 ]:SetFont( ::oFntNum )

   /*
   Boton de puesta a cero___________________________________________________
   */

   REDEFINE BUTTON ::oBtnNum[ 11 ] ;
      ID       111 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "." ) );
      PROMPT   "," ;

   ::oBtnNum[ 11 ]:SetFont( ::oFntNum )

   /*
   Boton de punto decimal___________________________________________________
   */

   REDEFINE BUTTON ::oBtnNum[ 12 ] ;
      ID       112 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "C" ) );
      PROMPT   "C" ;

   ::oBtnNum[ 12 ]:SetFont( ::oFntNum )

   /*
   Boton de +_______________________________________________________________
   */
 
   REDEFINE BUTTON ::oBtnNum[ 13 ] ;
      ID       113 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "=" ) );
      PROMPT   "=" ;

   ::oBtnNum[ 13 ]:SetFont( ::oFntNum ) 

   /*
   Boton de -_______________________________________________________________
   */

   REDEFINE BUTTON ::oBtnNum[ 14 ] ;
      ID       114 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "-" ) );
      PROMPT   "-" ;

   ::oBtnNum[ 14 ]:SetFont( ::oFntNum )

   /*
   Boton de *_______________________________________________________________
   */

   REDEFINE BUTTON ::oBtnNum[ 15 ] ;
      ID       115 ;
      OF       ::oDlg;
      ACTION   ( ::KeyChar( "*" ) );
      PROMPT   "x" ;

   ::oBtnNum[ 15 ]:SetFont( ::oFntNum )

   /*
   Redefinimos botones especiales para las resoluciones pequeñas---------------

   if !::l1024()
      ::oBtnSEntregar         := TButtonBmp():ReDefine( 507, {|| ::OnClickEntregaNota() }, ::oDlg, , , .f., , , , .f., "gc_printer2_32" )
      ::oBtnSCobrar           := TButtonBmp():ReDefine( 508, {|| ::OnClickCobro() }, ::oDlg, , , .f., , , , .f., "gc_money2_32" )
   end if
   */

   /*
   Definimos el meter--------------------------------------------------------
   */

   ::oProgressBar             := TApoloMeter():ReDefine( 400, { | u | If( pCount() == 0, ::nProgressBar, ::nProgressBar := u ) },, ::oDlg, .f.,,, .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

   /*
   Definimos los Splitters-----------------------------------------------------
   */

   ::oDlg:bStart              := {|| ::StartResource() }

   //::oDlg:AddFastKey( VK_F11, {|| ::GetPesoBalanza() } )

   ::oDlg:bResized            := {|| ::ResizedResource() } // lTop, lBottom, lLeft, lRight )() }

   ::oDlg:OnKeyDown           := {| o, nKey, nFlag | ::oDlgKeyDown( o, nKey, nFlag ) } // {|| msgStop( "OnKeyDown" ), ::oGetUnidades:SetFocus(), 1 }

   /*
   Activamos el diálogo------------------------------------------------------
   */

   ::oDlg:Activate( , , , .t., {|| ::EndResource() } )

   // ::End()

Return .t.

//---------------------------------------------------------------------------//

METHOD StartResource() CLASS TpvTactil

   local oBoton
   local oGrupo
   local oCarpeta
   local nLen                 := 126
   local nPos                 := 3

   CursorWait()

   if ::l1024()

      if Empty( ::oOfficeBar )

         /*
         Calculo la longitud para oGrpSalones
         */

         if uFieldEmpresa( "lLlevar" )
            nLen                 += 60
         end if

         if uFieldEmpresa( "lRecoger" )
            nLen                 += 60
         end if

         if uFieldEmpresa( "lEncargar" )
            nLen                 += 60
         end if

         ::oOfficeBar            := TDotNetBar():New( 0, 0, 2020, 120, ::oDlg, 1 )

         ::oOfficeBar:lPaintAll  := .f.
         ::oOfficeBar:lDisenio   := .f.

         ::oOfficeBar:SetStyle( 1 ) 

         ::oDlg:oTop             := ::oOfficeBar

         oCarpeta                := TCarpeta():New( ::oOfficeBar, "TPV táctil" )

         /*
         Hacemos un case para contemplar todas pas opciones que existen con las opciones de llevar, recoger y encargo
         */

         ::oGrpSalones           := TDotNetGroup():New( oCarpeta, nLen, "Salones", .f., , "gc_cup_32" )
            ::oBtnSala           := TDotNetButton():New( 60, ::oGrpSalones, "gc_cup_32",              "Mesas",             1, {|| ::OnClickSalaVenta() }, , , .f., .f., .f. )
            ::oBtnGeneral        := TDotNetButton():New( 60, ::oGrpSalones, "gc_cash_register_32",    "General",           2, {|| ::OnClickGeneral() }, , , .f., .f., .f. )

            if uFieldEmpresa( "lRecoger" )
               ::oBtnRecoger     := TDotNetButton():New( 60, ::oGrpSalones, "gc_shopping_basket_32",  "Para recoger", nPos++, {|| ::OnClickParaRecoger() }, , , .f., .f., .f. )
            end if

            if uFieldEmpresa( "lLlevar" )
               ::oBtnLlevar      := TDotNetButton():New( 60, ::oGrpSalones, "gc_motor_scooter_32",    "Para llevar",  nPos++, {|| ::OnClickParaLlevar() }, , , .f., .f., .f. )
            end if

            if uFieldEmpresa( "lEncargar" )
               ::oBtnEncargar    := TDotNetButton():New( 60, ::oGrpSalones, "gc_notebook2_32",       "Encargar",     nPos++, {|| ::OnClickEncargar() }, , , .f., .f., .f. )
            end if

         oGrupo                  := TDotNetGroup():New( oCarpeta, 226, "Datos de cliente", .f., , "gc_user_32" )
            ::oBtnCliente        := TDotNetButton():New( 220, oGrupo, "gc_user_16",                   "...",               1, {|| ::SelecionaCliente() }, , , .f., .f., .f. )
            ::oBtnDireccion      := TDotNetButton():New( 220, oGrupo, "gc_home_16",                   "...",               1, {|| ::SelecionaCliente() }, , , .f., .f., .f. )
            ::oBtnTelefono       := TDotNetButton():New( 220, oGrupo, "gc_mobile_phone_16",           "...",               1, {|| ::SelecionaCliente() }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 66, "Guardar", .f., , "gc_floppy_disk_32" )
            TDotNetButton():New( 60, oGrupo, "gc_floppy_disk_32", "Guardar y procesar", 1, {|| ::OnClickGuardar() }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 66, "Nota", .f., , "gc_printer2_32" )
            TDotNetButton():New( 60, oGrupo, "gc_printer2_32", "Entregar nota", 1, {|| ::OnClickEntregaNota() }, , , .f., .f., .f. )

         if uFieldEmpresa( "lAlbTct" )

            oGrupo               := TDotNetGroup():New( oCarpeta, 126, "Cobrar", .f., , "gc_money2_32" )
               TDotNetButton():New( 60, oGrupo, "gc_document_empty_32", "Albarán", 1, {|| ::OnClickAlbaran() }, , , .f., .f., .f. )
               TDotNetButton():New( 60, oGrupo, "gc_money2_32", "Cobrar", 2, {|| ::OnClickCobro() }, , , .f., .f., .f. )

         else

            oGrupo               := TDotNetGroup():New( oCarpeta, 66, "Cobrar", .f., , "gc_money2_32" )
               TDotNetButton():New( 60, oGrupo, "gc_money2_32",                     "Cobrar",            1, {|| ::OnClickCobro() }, , , .f., .f., .f. )

         end if         

         oGrupo                  := TDotNetGroup():New( oCarpeta, 66, "Comanda", .f., , "gc_printer2_scroll_32" )
            TDotNetButton():New( 60, oGrupo, "gc_printer2_scroll_32",            "Copia comanda",     1, {|| ::OnClickCopiaComanda( .t. ) }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 66, "Cajón", .f., , "gc_cashdrawer_32" )
            TDotNetButton():New( 60, oGrupo, "gc_cashdrawer_32",                  "Abrir cajón",       1, {|| ::OpenCajon() }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 186, "Mesas", .f., , "gc_users_family_32" )
            TDotNetButton():New( 60, oGrupo, "gc_users_family_32", "Comensales", 1, {|| ::OnClickComensales() }, , , .f., .f., .f. )
            TDotNetButton():New( 60, oGrupo, "gc_beer_garden_table_32", "Cambiar ubicación", 2, {|| ::OnClickCambiaUbicacion() }, , , .f., .f., .f. )
            TDotNetButton():New( 60, oGrupo, "gc_beer_garden_table_cut_32", "Dividir o unir mesa",3,{|| ::OnClickDividirMesa() }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 66, "Tickets", .f., , "gc_note_block_32" )
            TDotNetButton():New( 60, oGrupo, "gc_note_block_32", "Lista", 1, {|| ::OnClickLista() }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 126, "Invitaciones", .f., , "gc_masks_32" )
            TDotNetButton():New( 60, oGrupo, "gc_symbol_percent_32",           "Descuentos",        1, {|| ::OnClickDescuento() }, , , .f., .f., .f. )
            TDotNetButton():New( 60, oGrupo, "gc_masks_32",                      "Invitaciones",      2, {|| ::OnClickInvitacion() }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 66, "Usuario", .f., , "gc_businessman2_32" )
            ::oBtnUsuario        := TDotNetButton():New( 60, oGrupo, "gc_businessman2_32", Capitalize( Rtrim( oUser():cNombre() ) ), 1, {|| ::OnClickUsuarios() }, , , .f., .f., .f. )

         oGrupo                     := TDotNetGroup():New( oCarpeta, 66, "Otros", .f., , "gc_cash_register_32" )
            ::oBtnImportesExactos   := TDotNetButton():New( 60, oGrupo, "gc_gauge_32",                   "Cobros rapidos",    1, {|| ::OnClickImportesExactos() }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 186, "Arqueos/Sesiones", .f., , "Stopwatch_stop_32" )
            TDotNetButton():New( 60, oGrupo, "Stopwatch_refresh_32",          "Arqueo parcial [X]",1, {|| ::OnClickCloseTurno( .t. ) }, , , .f., .f., .f. )
            TDotNetButton():New( 60, oGrupo, "Stopwatch_stop_32",             "Arqueo total [Z]",  2, {|| ::OnClickCloseTurno( .f. ) }, , , .f., .f., .f. )
            TDotNetButton():New( 60, oGrupo, "gc_clock_play_32",              "Iniciar sesión",    3, {|| ::OnClickIniciarSesion() }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 66, "Salida", .f. )
            TDotNetButton():New( 60, oGrupo, "End32",                         "Salida",            1, {|| ::oDlg:End() }, , , .f., .f., .f. )
    
         // Segunda pestaña de tpv tactil--------------------------------------------
         
         oCarpeta                := TCarpeta():New( ::oOfficeBar, "Más..." )

         ::oGrpSeries            := TDotNetGroup():New( oCarpeta, 126, "Serie: ", .f. )
            TDotNetButton():New( 60, ::oGrpSeries, "Up32",                    "Subir",             1, {|| ::CambiaSerie( .t. ) }, , , .f., .f., .f. )
            TDotNetButton():New( 60, ::oGrpSeries, "Down32",                  "Bajar",             2, {|| ::CambiaSerie( .f. ) }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 66, "Lote", .f. )
            TDotNetButton():New( 60, oGrupo, "gc_barcode_32",                    "Lote",              1, {|| ::AgregarLote() }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 126, "Tickets", .f. )
            TDotNetButton():New( 60, oGrupo, "Delete_32",                     "Eliminar",          1, {|| ::OnClickEliminarTicket() }, , , .f., .f., .f. )
            TDotNetButton():New( 60, oGrupo, "gc_recycle_32",                    "Reabrir",           2, {|| ::OnClickReabrirTicket() }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 126, "Cajas", .f. )
            TDotNetButton():New( 60, oGrupo, "gc_cash_register_32",                    "Seleccionar",       1, {|| ::OnClickSeleccionarCajas() }, , , .f., .f., .f. )
            TDotNetButton():New( 60, oGrupo, "gc_cash_register_32",                    "Propiedades",       2, {|| EdtCajas() }, , , .f., .f., .f. )

         oGrupo                  := TDotNetGroup():New( oCarpeta, 66, "Entradas", .f. )
            TDotNetButton():New( 60, oGrupo, "gc_cash_register_refresh_32",            "Entrada y salida",  1, {|| ::OnclickEntrdaSalida() }, , , .f., .f., .f. )

         oGrupo                     := TDotNetGroup():New( oCarpeta, 226, "Tarifas", .f., , "gc_user_32" )
            ::oBtnTarifaSolo        := TDotNetButton():New( 220, oGrupo, "gc_money2_16", "", 1, {|| nil }, , , .f., .f., .f. )
            ::oBtnTarifaCombinado   := TDotNetButton():New( 220, oGrupo, "gc_money2_16", "", 1, {|| nil }, , , .f., .f., .f. )
                                       TDotNetButton():New( 220, oGrupo, "", "",  1, {|| nil }, , , .f., .f., .f. )

      end if 

      /*
      Le damos al acciones al boon derecho de los botones
      */

      if !Empty( ::oBtnGeneral )
         ::oBtnGeneral:bRAction  := {|| ::OnClickSalaVenta( ubiGeneral ) }
      end if

      if !Empty( ::oBtnLlevar )
         ::oBtnLlevar:bRAction   := {|| ::OnClickSalaVenta( ubiLlevar ) }
      end if

      if !Empty( ::oBtnSala )
         ::oBtnSala:bRAction     := {|| ::OnClickSalaVenta( ubiSala ) }
      end if

      if !Empty( ::oBtnRecoger )
         ::oBtnRecoger:bRAction  := {|| ::OnClickSalaVenta( ubiRecoger ) }
      end if

      if !Empty( ::oBtnEncargar )
         ::oBtnEncargar:bRAction := {|| ::OnClickSalaVenta( ubiEncargar ) }
      end if

   end if

   // Creamos el timer --------------------------------------------------------

   ::oTimer                   := TTimer():New( 500, {|| ::ShowCombinado() }, ::oDlg )

   /*
   Si no tienen orden de comandas no mostramos el botón-----------------------
   */

   if ::oOrdenComanda:EmptyOrdenComanda()
      ::oBtnOrdenComandaActual:Hide()
      ::oGetCambiarOrden:Hide()
   else 
      ::oBtnOrdenComandaActual:Show()
      ::oGetCambiarOrden:Show()
   end if  

   /*
   Estado del boton de cobro rapido
   */
 
   if uFieldEmpresa( "lImpExa")
      ::oBtnImportesExactos:Selected()
   end if

   /*
   Guardamos las dimensiones del dialogo---------------------------------------
   */

   ::nDialogWidth          := ::oDlg:nWidth()
   ::nDialogHeight         := ::oDlg:nHeight()
 
   // Cargamos las columnas del browse--------------------------------------------

   ::oBrwLineas:Load()

   /*
   Montamos lo necesario para el ListView de Favoritos-------------------------
   */

   ::CargaFavoritos()

   // Datos del cliente-----------------------------------------------------------

   ::SetCliente()

   // Tarifas de ventas--------------------------------------------------------

   ::SetTarifaSolo()
   ::SetTarifaCombinado()

   /*
   Datos de la serie-----------------------------------------------------------
   */

   ::SetSerie()

   /*
   Datos de la ubicacion-------------------------------------------------------
   */

   ::SetUbicacion()

   /*
   Datos del documento---------------------------------------------------------
   */

   ::SetInfo()

   /*
   Familia inicial-------------------------------------------------------------
   */

   ::ChangeFamilias()

   /*
   Maximizamos el dialogo------------------------------------------------------
   */

   ::oDlg:Maximize()

   CursorWE()

   /*
   Recoger usuario----------------------------------------------------------
   */

   ::GetUsuario()

   /*
   Recoger ubicacion--------------------------------------------------------
   */

   ::GetUbicacion()

   /*
   Foco a unidades-------------------------------------------------------------
   */

   CheckRes()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD ResizedResource() CLASS TpvTactil

   local nDialogWidth
   local nDialogHeight

   /*
   Actualizamos coordenadas----------------------------------------------------
   */

   ::oDlg:CoorsUpdate()

   SysRefresh()

   nDialogWidth            := ( ::oDlg:nWidth() - ::nDialogWidth )
   nDialogHeight           := ( ::oDlg:nHeight() - ::nDialogHeight )

   /*
   Movemos los objetos---------------------------------------------------------
   */

   ::oBrwLineas:Move( , , , ::oBrwLineas:nHeight() + nDialogHeight, .f. ) 

   ::oSayImporte:Move( ::oSayImporte:nTop + nDialogHeight, , , , .f. )
   ::oTotalTicket:Move( ::oTotalTicket:nTop + nDialogHeight, , , , .f. )
   ::oSayPrecioPersona:Move( ::oSayPrecioPersona:nTop + nDialogHeight, , , , .f. )

   ::oSayInfo:Move( ::oSayInfo:nTop + nDialogHeight, , , , .f. )
   ::oSayZona:Move( ::oSayZona:nTop + nDialogHeight, , , , .f. )

   ::oBtnLineasTop:Move( ::oBtnLineasTop:nTop + nDialogHeight, , , , .f. )
   ::oBtnLineasBottom:Move( ::oBtnLineasBottom:nTop + nDialogHeight, , , , .f. )
   ::oBtnLineasDelete:Move( ::oBtnLineasDelete:nTop + nDialogHeight, , , , .f. )
   ::oBtnLineasComentarios:Move( ::oBtnLineasComentarios:nTop + nDialogHeight, , , , .f. )
   ::oBtnLineasEscandallos:Move( ::oBtnLineasEscandallos:nTop + nDialogHeight, , , , .f. )

   ::oBtnArticulosPageUp:Move( ::oBtnArticulosPageUp:nTop + nDialogHeight, , , , .f. )
   ::oBtnArticulosPageDown:Move( ::oBtnArticulosPageDown:nTop + nDialogHeight, , , , .f. )


/*
   if ::l1280()
      ::oBtnOrdenComandaActual:Move( ::oBtnOrdenComandaActual:nTop + nDialogHeight, ::oBtnOrdenComandaActual:nLeft + nDialogWidth -100, 262, , .f. )
   else     
      ::oBtnOrdenComandaActual:Move( ::oBtnOrdenComandaActual:nTop + nDialogHeight, ::oBtnOrdenComandaActual:nLeft + nDialogWidth, , , .f. )
   end if 

   msgalert( ::l1280(), "::l1280()" )
   msgalert( ::oBtnOrdenComandaActual:nTop + nDialogHeight, "::oBtnOrdenComandaActual:nTop + nDialogHeight" )
   msgalert( ::oBtnOrdenComandaActual:nLeft + nDialogWidth -100, "::oBtnOrdenComandaActual:nLeft + nDialogWidth -100" )
*/
   // ::oGetCambiarOrden:Move( ::oGetCambiarOrden:nTop + nDialogHeight, ::oGetCambiarOrden:nLeft + nDialogWidth - 100, 200, , .f. )

   ::oGetCambiarOrden:Hide() 

   ::oBtnOrdenComandaActual:Move( ::oBtnOrdenComandaActual:nTop + nDialogHeight, ::oBtnOrdenComandaActual:nLeft + nDialogWidth, , , .f. )

   ::oBtnAgregarLibre:Move( ::oBtnAgregarLibre:nTop + nDialogHeight, ::oBtnAgregarLibre:nLeft + nDialogWidth, , , .f. )

   if !Empty( ::oBtnSCobrar )
      ::oBtnSCobrar:Move( ::oBtnSCobrar:nTop + nDialogHeight, ::oBtnSCobrar:nLeft + nDialogWidth, , , .f. )
   end if

   if !Empty( ::oBtnSSalon )
      ::oBtnSSalon:Move( ::oBtnSSalon:nTop + nDialogHeight, ::oBtnSSalon:nLeft + nDialogWidth, , , .f. )
   end if
   
   if !Empty( ::oBtnSEntregar )
      ::oBtnSEntregar:Move( ::oBtnSEntregar:nTop + nDialogHeight, ::oBtnSEntregar:nLeft + nDialogWidth, , , .f. )
   end if

   ::oBtnCombinado:Move( ::oBtnCombinado:nTop + nDialogHeight, ::oBtnCombinado:nLeft + nDialogWidth, , , .f. )
   
   /*
   Ocupa todo el area cliente--------------------------------------------------
   */

   ::oLstArticulos:Move( , , ::oLstArticulos:nWidth() + nDialogWidth, ::oLstArticulos:nHeight() + nDialogHeight, .f. )

   /*
   Lo movemos hacia la derecha-------------------------------------------------
   */

   ::oBrwFamilias:Move( , ::oBrwFamilias:nLeft + nDialogWidth, , ::oBrwFamilias:nHeight() + nDialogHeight, .f. )

   ::oBtnFamiliasUp:Move( ::oBtnFamiliasUp:nTop + nDialogHeight, ::oBtnFamiliasUp:nLeft + nDialogWidth, , , .f. )

   ::oBtnFamiliasDown:Move( ::oBtnFamiliasDown:nTop + nDialogHeight, ::oBtnFamiliasDown:nLeft + nDialogWidth, , , .f. )

   ::oBtnPreviewDocumento:Move( ::oBtnPreviewDocumento:nTop + nDialogHeight, ::oBtnPreviewDocumento:nLeft + nDialogWidth, , , .f. )

   ::oBtnPrintDocumento:Move( ::oBtnPrintDocumento:nTop + nDialogHeight, ::oBtnPrintDocumento:nLeft + nDialogWidth, , , .f. )

   ::oBtnCalculadora:Move( ::oBtnCalculadora:nTop + nDialogHeight, ::oBtnCalculadora:nLeft + nDialogWidth, , , .f.)
   
   if !Empty( ::oBtnBalanza )
      ::oBtnBalanza:Move( ::oBtnBalanza:nTop + nDialogHeight, ::oBtnBalanza:nLeft + nDialogWidth, , , .f.)
   end if
   
   if !Empty( ::oBtnSSalir )
      ::oBtnSSalir:Move( ::oBtnSSalir:nTop + nDialogHeight, ::oBtnSSalir:nLeft + nDialogWidth, , , .f.)
   end if   

   if !Empty( ::oBtnPrecioUnidades )
      ::oBtnPrecioUnidades:Move( ::oBtnPrecioUnidades:nTop + nDialogHeight, ::oBtnPrecioUnidades:nLeft + nDialogWidth, , , .f. )
   end if

   ::oGetUnidades:Move( ::oGetUnidades:nTop + nDialogHeight, ::oGetUnidades:nLeft + nDialogWidth, , , .f. )

   aEval( ::oBtnNum, {|o| o:Move( o:nTop + nDialogHeight, o:nLeft + nDialogWidth, , , .f. ) } )

   ::oProgressBar:Move( ::oProgressBar:nTop + nDialogHeight, , ::oProgressBar:nWidth() + nDialogWidth, , .f. )

   ::oDlg:Refresh()

   /*
   Gaurdamos las dimensiones del dialogo---------------------------------------
   */

   ::nDialogWidth          := ::oDlg:nWidth()
   ::nDialogHeight         := ::oDlg:nHeight()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD EndResource() CLASS TpvTactil

   local lEnd           := .t.

   /*
   No lo dejamos salir si esta puesto este flag--------------------------------
   */

   if IsFalse( ::lValidResource )
      return .f.
   end if

   if !::lKillResource
      if ( !::lValidatePreSave() .or. ::lAlone )
         lEnd           := ApoloMsgNoYes( "¿ Desea salir del TPV táctil ?", "Atención", .t. )
      end if
   end if

Return ( lEnd )

//---------------------------------------------------------------------------//

METHOD PaintResource() CLASS TpvTactil

   ArtBeep()

   // ::oGetUnidades:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD EditArticulo( nRow, nCol )

  local nOpt

  if !Empty( ::oLstArticulos )

     ::oLstArticulos:nOption       := ::oLstArticulos:GetOption( nRow, nCol )
     ::oLstArticulos:Refresh()

     nOpt                          := ::oLstArticulos:nOption

     if Empty( nOpt )
        RETURN ( .f. )
     end if

     if !Empty( ::oLstArticulos:oVScroll )
        ::oLstArticulos:oVScroll:SetPos( ::oLstArticulos:nCurLine() )
     end if

     nOpt                          := Max( Min( nOpt, len( ::oLstArticulos:aItems ) ), 1 )

     if nOpt > 0 .and. nOpt <= len( ::oLstArticulos:aItems )

        if EdtArticulo( ::oLstArticulos:aItems[ nOpt ]:Cargo )

           ::CargaBrowseFamilias()

           ::ChangeFamilias()

        end if

     end if

  end if

  RETURN ( .t. )

//------------------------------------------------------------------------//

METHOD InstanceFastReport()

  /*
  Creamos el objeto FastReport---------------------------------------------
  */

  ::oFastReport     := frReportManager():New()
  ::oFastReport:LoadLangRes( "Spanish.Xml" )

  ::DataReport()

  RETURN ( Self )

//------------------------------------------------------------------------//

METHOD DestroyFastReport()

  if !Empty( ::oFastReport )
     ::oFastReport:DestroyFr()
  end if

  ::oFastReport     := nil

  RETURN ( Self )

//------------------------------------------------------------------------//

METHOD CambiarPrecio()

   if ( ::oTemporalLinea:ordKeyCount() == 0 )
      Return ( Self )
   end if 

   if ( ::valUnidadesPrecios() != 0 )

      if ( ::oTemporalLinea:nPvpTil == 0 ) .or. ( ApoloMsgNoYes( "¿Desea cambiar el precio del artículo seleccionado?", "Confirme", .t. ) )

         ::oTemporalLinea:nPvpTil   := ::nGetUnidades()

         ::oBrwLineas:Refresh()

      end if

   end if

RETURN ( Self ) 

//------------------------------------------------------------------------//

METHOD nGetUnidades( lUnaUnidad )

   local nUnidades      := 1

   DEFAULT lUnaUnidad   := .f.

   nUnidades            := ::valUnidadesPrecios()

   if ( ( lUnaUnidad .and. nUnidades == 0 ) .or. ::lGetPrecio )
      nUnidades         := 1 // Max( nUnidades, 1 )
   end if

   if !::lGetPrecio
      ::oGetUnidades:cText( "" )
   end if 

RETURN ( nUnidades )

//------------------------------------------------------------------------//

METHOD cTipoDocumento()

  local cTipo := "Ticket"

  do case
     case ::nTipoDocumento == documentoAlbaran
        cTipo := "Albarán de cliente"

     case ::nTipoDocumento == documentoFactura
        cTipo := "Factura de cliente"

     otherwise
        cTipo := "Ticket de cliente"

  end case

RETURN cTipo

//------------------------------------------------------------------------//

METHOD GuardaDocumentoPendiente()

  ::oTiketCabecera:cTipTik      := SAVTIK

  ::GuardaDocumento()

  ::ProcesaDocumentosInternos()

  ::gotoUbicacionGeneral()

RETURN ( .t. )

//-----------------------------------------------------------------------//

METHOD SetDocumentoPagado()

   ::oTiketCabecera:cTipTik         := SAVTIK

   do case
      case ::oTpvCobros:nEstado == nParcial
         ::setTicketParcial()

      case ::oTpvCobros:nEstado == nPagado
         ::setTicketPagado()
   end case

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD setTicketParcial()

   ::oTiketCabecera:lPgdTik   := .f.
   ::oTiketCabecera:lAbierto  := .t.

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD setTicketPagado()

   ::oTiketCabecera:lPgdTik   := .t.
   ::oTiketCabecera:lAbierto  := .f.

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD GuardaDocumentoCerrado()

   ::oTiketCabecera:lAbierto  := ( ::oTiketCabecera:nUbiTik == ubiLlevar )

   ::guardaDocumento( .f. )

   ::procesaDocumentosInternos()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD OnClickIniciarSesion()

  ::DisableDialog()

  if ::oTurno:OpenFiles()
     ::oTurno:lNowOpen()
     ::oTurno:CloseFiles()
  end if

  ::SetInfo()

  ::EnableDialog()

  RETURN ( Self )

//------------------------------------------------------------------------//

METHOD OnClickComensales()

  ::DisableDialog()

  ::oTiketCabecera:nNumCom         := nVirtualNumKey( "gc_users_family_32", "Número comensales", ::oTiketCabecera:nNumCom )

  ::SetTotal()

  ::EnableDialog()

  RETURN ( .t. )

//------------------------------------------------------------------------//

METHOD OnClickComensalesMenus()

   ::nComensalesMenu    := 0

   ::DisableDialog()

   ::nComensalesMenu    := nVirtualNumKey( "gc_users_family_32", "Número de menús", 0 )

   ::EnableDialog()

RETURN ( ::nComensalesMenu )

//------------------------------------------------------------------------//

/*
Si pulsamos sobre el boton de usuario nos crea el dialogo para cambiar de usuario
*/

METHOD ShowUsuario()

   if BrwBigUser()

      ::oBtnUsuario:cBmp( if( oUser():lAdministrador(), "gc_businessman2_32", "gc_user2_32" ) )

      ::oBtnUsuario:cCaption( Capitalize( oUser():cNombre() ) )

   else

      RETURN ( .f. )

   end if

RETURN ( .t. )

//------------------------------------------------------------------------//

METHOD GetUsuario( lForced )

  local lShow

  DEFAULT lForced                  := .f.

  if ( lForced ) .or. ( ::lGetUsuario .and. lRecogerUsuario() )

     lShow                         := ::ShowUsuario()

     if !lShow

        ::KillResource()

        RETURN ( .f. )

     else

        ::lGetUsuario              := .f.

     end if

  end if

  RETURN ( .t. )

//------------------------------------------------------------------------//

METHOD GetUbicacion()

   if ( uFieldEmpresa( "lShowSala" ) )
      ::OnClickSalaVenta()
   end if

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD CambiaSerie( lSubir ) CLASS TpvTactil

   if lSubir

      ::oTiketCabecera:cSerTik   := cUpSerie( ::oTiketCabecera:cSerTik )

   else

      ::oTiketCabecera:cSerTik   := cDwSerie( ::oTiketCabecera:cSerTik )

   end if

   if !Empty( ::oGrpSeries )
      ::oGrpSeries:cPrompt       := "Serie: " + ::oTiketCabecera:cSerTik
   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD ActionListArticulo()

   local oOpt

   if !::lEditableDocumento()
      MsgStop( "El documento ya está cerrado" )
      Return ( Self )
   end if

   if Empty( ::oLstArticulos )   
      Return ( Self )
   end if

   oOpt     := ::oLstArticulos:GetSelection()

   if Empty( oOpt )
      MsgStop( "Seleccione una opción valida." )
      Return ( Self )
   end if

   if !empty( ::oLstArticulos:GetSelection():bAction )
      eval( ::oLstArticulos:GetSelection():bAction, ::oLstArticulos:GetSelection():Cargo )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AgregarMenu( cMenu )

   // Pide el número de comensales---------------------------------------------

   ::OnClickComensalesMenus()

   // Agrego linea de menú-----------------------------------------------------

   if ::nComensalesMenu != 0

      if !::CargaFamiliaMenu( cMenu )
         RETURN ( .f. )
      end if

      ::AgregarLineaMenu( cMenu )

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD AgregarMenuAcompannamiento( cMenu )

   local lAcompannamiento  := .f.

   if Empty( cMenu )
      Return ( lAcompannamiento )
   end if

   ::oTpvMenu:Acompannamiento( cMenu )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CargaFamiliaMenu( cMenu )

   local cOrden
   local aOrdenes

   if !empty( cMenu )
      aOrdenes          := ::oTpvMenuOrdenes:aOrdenes( cMenu ) 
   end if

   if empty( aOrdenes )
      Return ( .f.)
   end if

   ::aFamilias          := {}

   for each cOrden in aOrdenes
      aAdd( ::aFamilias, { ::oOrdenComanda:cNombre( cOrden ), cOrden, {|| ::CargaArticulosOrden( cMenu, cOrden ) }, "" } )
   next

   aAdd( ::aFamilias, { "Salir", nil, {|| ::CargaBrowseFamilias(), ::CargaFavoritos() }, } )

   ::oBrwFamilias:SetArray( ::aFamilias, , , .f. )   

   // Carga la familia actual--------------------------------------------------

   ::ChangeFamilias()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD SeleccionaArticulos( nOpt ) CLASS TpvTactil

   ::AgregarLineas( ::oLstArticulos:aItems[ nOpt ]:Cargo )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AgregarLineaMenu( cCodigoMenu )

   ::nNumeroLinea                := nLastNum( ::oTemporalLinea )

   ::oTemporalLinea:Append()
   ::oTemporalLinea:Blank()

   ::oTemporalLinea:nNumLin      := ::nNumeroLinea
   ::oTemporalLinea:nLinMnu      := ::nNumeroLinea
   ::oTemporalLinea:nUntTil      := ::nComensalesMenu
   ::oTemporalLinea:cNomTil      := ::oTpvMenu:cNombre(cCodigoMenu)
         
   ::oTemporalLinea:nPvpTil      := ::oTpvMenu:nPrecio(cCodigoMenu)
   ::oTemporalLinea:nIvaTil      := nIva( ::oTipoIva, ::oArticulo:TipoIva )

   if !empty(cCodigoMenu)
      ::oTemporalLinea:lMnuTil   := .t.
      ::oTemporalLinea:cCodMnu   := cCodigoMenu
   end if

   ::oTemporalLinea:Save()

   ::oBrwLineas:Refresh()

   ::SetTotal()

   ::AgregaLineaVisor( { "Total", Trans( ::sTotal:nTotalDocumento, ::cPictureTotal ) }, 2 )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD SeleccionaOrden() CLASS TpvTactil

   local n

   for n := 1 to len( ::oLstOrden:aItems ) 
      if ( n == ::oLstOrden:nOption )
         ::oLstOrden:aItems[ n ]:nClrPane := Rgb( 45, 137, 239 )
      else
         ::oLstOrden:aItems[ n ]:nClrPane := Rgb( 255, 255, 255 )
      end if 
   next

   ::oLstOrden:Refresh()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AgregarLibre() CLASS TpvTactil

   local oDlg
   local oDescripcionLibre
   local oUnidadesLibre
   local oImporteLibre
   local oImpresoraLibre
   local oIvaLibre
   local oNombreOrdenComanda

   ::cOrdenComandaLibre    := ""
   ::cDescripcionLibre     := Space( 100 )
   ::cImpresoraLibre       := Space( 254 )
   ::nUnidadesLibre        := 1
   ::nImporteLibre         := 0
   ::nIvaLibre             := nIva( ::oTipoIVA, cDefIva() )

   if !::lEditableDocumento()
      MsgStop( "El documento ya está cerrado" )
      Return ( .t. )
   end if

   DEFINE DIALOG oDlg RESOURCE "Libre" // FONT ::oFntDlg 

      REDEFINE GET oDescripcionLibre ;
         VAR      ::cDescripcionLibre ;
         ID       100 ;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         ID       110 ;
         OF       oDlg ;
         BITMAP   "gc_keyboard_32" ;
         ACTION   ( VirtualKey( .f., oDescripcionLibre ) )

      REDEFINE GET oIvaLibre ;
         VAR      ::nIvaLibre ; 
         PICTURE  "@E 999.99" ;
         WHEN     ( .f. );
         ID       200 ;
         OF       oDlg

      REDEFINE BUTTONBMP ; 
         ID       210 ;
         OF       oDlg ;
         BITMAP   "Lupa_32" ;
         ACTION   ( BigBrwIva( oIvaLibre, ::oTipoIVA:cAlias ) )

      REDEFINE GET oUnidadesLibre ;
         VAR      ::nUnidadesLibre ;
         PICTURE  ::cPictureUnidades ;
         ID       120 ;
         OF       oDlg

      REDEFINE BUTTONBMP ; 
         ID       130 ;
         OF       oDlg ;
         BITMAP   "gc_calculator_32" ;
         ACTION   ( Calculadora( 0, oUnidadesLibre ) ) 

      REDEFINE GET oImporteLibre ;
         VAR      ::nImporteLibre ;
         PICTURE  ::cPictureTotal ;
         ID       140 ;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         ID       150 ;
         OF       oDlg ; 
         BITMAP   "gc_calculator_32" ;
         ACTION   ( Calculadora( 0, oImporteLibre ) )

      REDEFINE GET oImpresoraLibre ;
         VAR      ::cImpresoraLibre ;
         ID       160 ;
         OF       oDlg

      REDEFINE COMBOBOX oNombreOrdenComanda ;
         VAR      ::cOrdenComandaLibre ;
         ITEMS    ::oOrdenComanda:aNombreOrdenComanda() ;
         ID       180 ;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         ID       170 ;
         OF       oDlg ;
         BITMAP   "Lupa_32" ;
         ACTION   ( browseTipoImpresora( oImpresoraLibre ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "gc_check_32" ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( ::ValidarAgregarLibre( oDescripcionLibre, oUnidadesLibre, oDlg ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

   ACTIVATE DIALOG oDlg CENTER

   ::oGetUnidades:SetFocus()

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION browseTipoImpresora( oGet )

   local cTipoImpresora    := TiposImpresorasController():New():activateBrowse() 

   if !empty( cTipoImpresora )
      oGet:cText( padr( cTipoImpresora, 50 ) )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD ValidarAgregarLibre( oDescripcionLibre, oUnidadesLibre, oDlg ) CLASS TpvTactil

   if Empty( ::cDescripcionLibre )
      MsgStop( "Descripción no puede estar vacia" )
      oDescripcionLibre:SetFocus()
      Return .f.
   end if

   if Empty( ::nUnidadesLibre )
      MsgStop( "Unidades tiene que ser distinta de cero" )
      oUnidadesLibre:SetFocus()
      Return .f.
   end if

   ::GuardarAgregarLibre()

   oDlg:End( IDOK )

Return .t.

//---------------------------------------------------------------------------//

METHOD GuardarAgregarLibre() CLASS TpvTactil

   CursorWait()

   ::oTemporalLinea:Blank()
   ::oTemporalLinea:nLinMnu      := __bottomNumber__
   ::oTemporalLinea:nNumLin      := nLastNum( ::oTemporalLinea )
   ::oTemporalLinea:cNomTil      := ::cDescripcionLibre
   ::oTemporalLinea:nUntTil      := ::nUnidadesLibre
   ::oTemporalLinea:nPvpTil      := ::nImporteLibre
   ::oTemporalLinea:nIvaTil      := ::nIvaLibre
   ::oTemporalLinea:cAlmLin      := oUser():cAlmacen()
   ::oTemporalLinea:cImpCom1     := ::cImpresoraLibre
   ::oTemporalLinea:cOrdOrd      := ::oOrdenComanda:cOrden( ::cOrdenComandaLibre ) 
   ::oTemporalLinea:Insert()
 
   if !Empty( ::oBrwLineas )
      ::oBrwLineas:Refresh()
   end if

   ::SetTotal()

   CursorWE()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AgregarLote() CLASS TpvTactil

   local oDlg
   local oLote
   local cLote    

   if (::oTemporalLinea:OrdKeyCount() == 0)
      Return ( .t. )
   end if

   if (!::lEditableDocumento())
      MsgStop( "El documento ya está cerrado" )
      Return ( .t. )
   end if

   cLote          := ::oTemporalLinea:cLote

   DEFINE DIALOG oDlg RESOURCE "Lote_Tct" // FONT ::oFntDlg 

      REDEFINE GET oLote ;
         VAR      cLote ;
         ID       100 ;
         OF       oDlg

      REDEFINE BUTTONBMP ;
         BITMAP   "gc_check_32" ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( ::ValidarAgregarLote( cLote, oDlg ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

   ACTIVATE DIALOG oDlg CENTER

   ::oGetUnidades:SetFocus()

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD ValidarAgregarLote( cLote, oDlg ) CLASS TpvTactil

   if !empty( cLote )
      ::oTemporalLinea:FieldPutByName( "cLote", cLote )
   end if 

   oDlg:End( IDOK )

Return .t.

//---------------------------------------------------------------------------//

METHOD CargaBrowseFamilias() CLASS TpvTactil

   if Empty( ::oFamilias )
      Return .t.
   end if 

   // Inicializamos el array de familias------------------------------------------

   ::aFamilias          := {}

   // Caso especial de favoritos--------------------------------------------------

   aAdd( ::aFamilias, { "Favoritos", nil, {|| ::CargaFavoritos() }, "gc_star2_transp_48" } ) 

   // Preguntamos si hay menus activos y es no es de acompañamiento---------------

   if ::oTpvMenu:lIsMenuActive()
      aAdd( ::aFamilias, { "Menús", nil, {|| ::CargaMenus() }, "gc_clipboard_pencil_48" } ) 
   end if 

   // Recorremos la tabla y rellenamos el array de familias-----------------------

   ::oFamilias:GetStatus()
   ::oFamilias:OrdSetFocus( "nPosTpv" )

   ::oFamilias:GoTop()
   while !::oFamilias:Eof()

      aAdd( ::aFamilias, { Capitalize( AllTrim( ::oFamilias:cNomFam ) ), ::oFamilias:cCodFam, {|cCodFam| ::CargaArticulosFamilia( cCodFam ) }, cFileBmpName( ::oFamilias:cImgBtn ) } )

      ::oFamilias:Skip()

   end while

   ::oFamilias:SetStatus()

   if !empty( ::oBrwFamilias )
      ::oBrwFamilias:SetArray( ::aFamilias, , , .f. ) 
   end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD CargaArticulosFamilia( cCodFam ) CLASS TpvTactil

   local aItems                     := {}

   ::oArticulo:GetStatus()

   // Si queremos los botones ordenados por nombre o por posicion--------------

   if uFieldEmpresa( "lOrdNomTpv" )
      ::oArticulo:OrdSetFocus( "nNomTpv" )
   else
      ::oArticulo:OrdSetFocus( "nPosTpv" )
   end if

   if ::oArticulo:Seek( cCodFam )

      while ( ::oArticulo:Familia == cCodFam ) .and. !::oArticulo:Eof()

         ::CreateItemArticulo( aItems )

         ::oArticulo:Skip()

      end while

   end if

   ::oArticulo:SetStatus()

Return ( aItems )

//---------------------------------------------------------------------------//

METHOD CargaFavoritos() CLASS TpvTactil

   local aItems               := {}
   local nCount               := 1

   if Empty( ::oArticulo )
      Return ( aItems )
   end if

   ::oArticulo:GetStatus()
   ::oArticulo:OrdSetFocus( "nPosTcl" )

   ::oArticulo:GoTop()

   /*
   Insertamos los cuatro primeros favoritos------------------------------------
   */

   ::oArticulo:GoTop()
   while nCount < 50 .and. !::oArticulo:Eof()

      ::CreateItemArticulo( aItems )

      ::oArticulo:Skip()

      nCount ++

   end while

   ::oArticulo:SetStatus()

Return ( aItems )

//---------------------------------------------------------------------------//

METHOD CargaMenus()

   local aItems      := {}
   local nCount      := 0

   if !::oTpvMenu:lIsMenuActive()
      Return ( aItems )
   end if
       
   if ::oTpvMenu:nMenuActive() > 1 

      ::oTpvMenu:oDbf:GoTop()
      while !::oTpvMenu:oDbf:Eof() 
      
         if !::oTpvMenu:oDbf:lObsMnu .and. !::oTpvMenu:oDbf:lAcomp

            with object ( C5ImageViewItem() )

               :Cargo      := ::oTpvMenu:oDbf:cCodMnu
               :bAction    := {|cMenu| ::AgregarMenu( cMenu ) }
               :cText      := alltrim( ::oTpvMenu:oDbf:cNomMnu )
               :nClrPane   := rgb( 255,255,0 )

               :Add( aItems )

            end with

         end if

         ::oTpvMenu:oDbf:Skip()

      end while

   else 

      ::AgregarMenu( ::oTpvMenu:cMenuActive() )

   end if

Return ( aItems )

//---------------------------------------------------------------------------//

METHOD CargaArticulosOrden( cCodMnu, cCodOrd )
   
   local cArticulo
   local aItems      := {}
   local aArticulos  := ::oTpvMenuArticulo:aArticulos( cCodMnu, cCodOrd )

   ::oArticulo:GetStatus()

   ::oArticulo:OrdSetFocus( "Codigo" )

   for each cArticulo in aArticulos

      if ::oArticulo:Seek( cArticulo )

         ::CreateItemArticulo( aItems, cCodMnu, cCodOrd )

      end if 

   next

   ::oArticulo:SetStatus()

RETURN ( aItems )

//---------------------------------------------------------------------------//

METHOD ChangeFamilias() CLASS TpvTactil

   local nAt
   local aRow
   local uEval

   if !Empty( ::oBrwFamilias ) .and. !Empty( ::oLstArticulos )

      aRow     := ::oBrwFamilias:aRow

      if !Empty( aRow ) .and. isBlock( aRow[ 3 ] )

         uEval := Eval( aRow[ 3 ], aRow[ 2 ] )
      
         if isArray( uEval )            
            ::oLstArticulos:SetItems( uEval )
         end if 
      
      end if

      /*
      nAt      := ::oBrwFamilias:nArrayAt

      if nAt > 0 .and. nAt <= len( ::aFamilias )
         ::oLstArticulos:SetItems( ::aFamilias[ nAt, 3 ] )
      end if
      */

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD SetFamilia( cCodigoFamilia ) CLASS TpvTactil

   local nAt

   CursorWait()

   if !Empty( ::oBrwFamilias ) .and. !Empty( ::oLstArticulos )

      nAt                        := aScan( ::aFamilias, {|a| a[ 2 ] == cCodigoFamilia } )

      if nAt > 0 .and. nAt <= len( ::aFamilias )

         ::oBrwFamilias:nArrayAt := nAt
         ::oBrwFamilias:Refresh()

         ::ChangeFamilias()

         // ::oLstArticulos:SetItems( ::aFamilias[ nAt, 3 ] )

      end if

   end if

   CursorWE()

Return .t.

//---------------------------------------------------------------------------//

METHOD GoFamilia() CLASS TpvTactil

   local cCodigoFamilia
   local cCodigoCombinada

   cCodigoFamilia          := ::oTemporalLinea:cCodFam

   if Empty( cCodigoFamilia )
      cCodigoFamilia       := ::oTemporalLinea:cFamTil
   end if

   if !Empty( cCodigoFamilia )

      ::cCodigoFamilia     := cCodigoFamilia

      if ::oFamilias:SeekInOrd( cCodigoFamilia, "cCodFam" )
         cCodigoCombinada  := ::oFamilias:cFamCmb
      end if

      if !Empty( cCodigoCombinada )
         ::SetFamilia( cCodigoCombinada )
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD KeyChar( cKey ) CLASS TpvTactil

   if !::lEditableDocumento()
      MsgStop( "El documento ya está cerrado" )
      RETURN ( .t. )
   end if

   do case
      case At( cKey, "0123456789" ) > 0
         ::cGetUnidades     += cKey

      case cKey == "." .and. !( At( ".", ::cGetUnidades ) > 0 )
         ::cGetUnidades     += cKey

      case cKey == "-"

         if !( At( "-", ::cGetUnidades ) > 0 )
            ::cGetUnidades  := cKey + ::cGetUnidades
         else
            ::cGetUnidades  := StrTran( ::cGetUnidades, "-", "" )
         end if

      case cKey == "C"
         ::cGetUnidades     := ""

      /*
      Multiplicamos por el numero de unidades q nos marquen--------------------
      */

      case cKey == "*"

         ::IncrementarUnidades()

      /*
      Asignamos el nuevo precio------------------------------------------------
      */

      case cKey == "="

         ::CambiarPrecio()

   end case

   ::oGetUnidades:cText( AllTrim ( ::cGetUnidades ) )

   ::SetTotal()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD oDlgKeyDown( o, nKey, nFlag )

   do case
      case ( nKey == 96 )  // Teclado numérico 0
         ::KeyChar( Chr( 48 ) )

      case ( nKey == 97 )  // Teclado numérico 1
         ::KeyChar( Chr( 49 ) )

      case ( nKey == 98 )  // Teclado numérico 2
         ::KeyChar( Chr( 50 ) )

      case ( nKey == 99 )  // Teclado numérico 3
         ::KeyChar( Chr( 51 ) )

      case ( nKey == 100 ) // Teclado numérico 4
         ::KeyChar( Chr( 52 ) )

      case ( nKey == 101 ) // Teclado numérico 5
         ::KeyChar( Chr( 53 ) )

      case ( nKey == 102 ) // Teclado numérico 6
         ::KeyChar( Chr( 54 ) )

      case ( nKey == 103 ) // Teclado numérico 7
         ::KeyChar( Chr( 55 ) )

      case ( nKey == 104 ) // Teclado numérico 8
         ::KeyChar( Chr( 56 ) )

      case ( nKey == 105 ) // Teclado numérico 9
         ::KeyChar( Chr( 57 ) )

      case ( nKey == 106 ) // Teclado numérico Multiplicar
         ::KeyChar( Chr( 42 ) )

      case ( nKey == 13 )  // Teclado INTRO
         ::AgregarPLU()

      case ( nKey == 16 )
         ::CambiarPrecio()

      case ( nKey == 67 )  // Teclado poner a cero
         ::KeyChar( "C" )

      case ( nKey == 109 .or. nKey == 189 )  // Teclado poner a cero
         ::SumarUnidades( -1 )

      case ( nKey == 107 .or. nKey == 187 )
         ::SumarUnidades( 1 )

      case ( nKey == 110 .or. nKey == 190 )  // Teclado poner a cero
         ::KeyChar( "." )

      otherwise
         ::KeyChar( Chr( nKey ) )

   end case

Return ( 0 )

//---------------------------------------------------------------------------//

METHOD CreateTemporal() CLASS TpvTactil

   local aFieldCol

   /*
   Definimos las bases de datos temporal linea---------------------------------
   */

   ::cTemporalLinea        := cGetNewFileName( cPatTmp() + "TikL" )

   DEFINE DATABASE ::oTemporalLinea FILE ( ::cTemporalLinea ) CLASS "TikL" ALIAS "TikL" PATH ( cPatTmp() ) VIA ( cLocalDriver() ) COMMENT "Lineas ticket cliente"

      for each aFieldCol in aColTik()
         ::oTemporalLinea:AddField( aFieldCol[ 1 ], aFieldCol[ 2 ], aFieldCol[ 3 ], aFieldCol[ 4 ], aFieldCol[ 6 ], , , , aFieldCol[ 5 ] )
      next

      INDEX TO ( ::cTemporalLinea ) TAG "nRecNum"  ON Str( Field->nLinMnu ) + Str( Field->nNumLin );
                                                                              COMMENT "Recno"            FOR "!Deleted() .and. !Field->lKitChl" OF ::oTemporalLinea
      INDEX TO ( ::cTemporalLinea ) TAG "lRecNum"  ON Str( Field->nLinMnu ) + Str( Field->nNumLin );
                                                                              COMMENT "Recno"            NODELETED                              OF ::oTemporalLinea
      INDEX TO ( ::cTemporalLinea ) TAG "nNumLin"  ON Str( Field->nNumLin )   COMMENT "Linea"            NODELETED                              OF ::oTemporalLinea
      INDEX TO ( ::cTemporalLinea ) TAG "cCbaTil"  ON Field->cCbaTil          COMMENT "Código"           NODELETED                              OF ::oTemporalLinea
      INDEX TO ( ::cTemporalLinea ) TAG "cCodMnu"  ON Field->cCodMnu          COMMENT "Codigo menú"      FOR "!Deleted() .and. !Field->lDelTil" OF ::oTemporalLinea

   END DATABASE ::oTemporalLinea

   ::oTemporalLinea:Activate( .f., .f. )

   /*
   Definimos las bases de datos temporal para el original al dividir-----------
   */

   ::cTemporalDivisionOriginal        := cGetNewFileName( cPatTmp() + "TikDO" )

   DEFINE DATABASE ::oTemporalDivisionOriginal FILE ( ::cTemporalDivisionOriginal ) CLASS "TikDO" ALIAS "TikDO" PATH ( cPatTmp() ) VIA ( cLocalDriver() ) COMMENT "Lineas de tickets para division original"

      for each aFieldCol in aColTik()
         ::oTemporalDivisionOriginal:AddField( aFieldCol[ 1 ], aFieldCol[ 2 ], aFieldCol[ 3 ], aFieldCol[ 4 ], aFieldCol[ 6 ], , , , aFieldCol[ 5 ] )
      next

      INDEX TO ( ::cTemporalDivisionOriginal )  TAG "nOrdLin"  ON Str( Field->nLinMnu ) + Str( Field->nNumLin );
                                                                                          COMMENT "Orden lineas"     NODELETED                              OF ::oTemporalDivisionOriginal
      INDEX TO ( ::cTemporalDivisionOriginal )  TAG "lRecNum"  ON Str( Recno() )          COMMENT "Recno"            NODELETED                              OF ::oTemporalDivisionOriginal
      INDEX TO ( ::cTemporalDivisionOriginal )  TAG "nRecNum"  ON Str( Recno() )          COMMENT "Recno"            FOR "!Deleted() .and. !Field->lKitChl" OF ::oTemporalDivisionOriginal
      INDEX TO ( ::cTemporalDivisionOriginal )  TAG "cCbaTil"  ON Field->cCbaTil          COMMENT "Código"           NODELETED                              OF ::oTemporalDivisionOriginal
      INDEX TO ( ::cTemporalDivisionOriginal )  TAG "nNumLin"  ON Str( Field->nNumLin )   COMMENT "Linea"            NODELETED                              OF ::oTemporalDivisionOriginal
      INDEX TO ( ::cTemporalDivisionOriginal )  TAG "cLinCba"  ON Str( Field->nNumLin ) + Field->cCbaTil;             
                                                                                          COMMENT "Linea y código"   NODELETED                              OF ::oTemporalDivisionOriginal

   END DATABASE ::oTemporalDivisionOriginal

   ::oTemporalDivisionOriginal:Activate( .f., .f. )

   /*
   Definimos las bases de datos temporal para el nuevo ticket al dividir-------
   */

   ::cTemporalDivisionNuevoTicket        := cGetNewFileName( cPatTmp() + "TikNew" )

   DEFINE DATABASE ::oTemporalDivisionNuevoTicket FILE ( ::cTemporalDivisionNuevoTicket ) CLASS "TikNew" ALIAS "TikNew" PATH ( cPatTmp() ) VIA ( cLocalDriver() ) COMMENT "Lineas de tickets para division nuevo ticket"

      for each aFieldCol in aColTik()
         ::oTemporalDivisionNuevoTicket:AddField( aFieldCol[ 1 ], aFieldCol[ 2 ], aFieldCol[ 3 ], aFieldCol[ 4 ], aFieldCol[ 6 ], , , , aFieldCol[ 5 ] )
      next

      INDEX TO ( ::cTemporalDivisionNuevoTicket ) TAG "nOrdLin"  ON Str( Field->nLinMnu ) + Str( Field->nNumLin );
                                                                                             COMMENT "Orden lineas"     NODELETED                              OF ::oTemporalDivisionNuevoTicket
      INDEX TO ( ::cTemporalDivisionNuevoTicket ) TAG "lRecNum"  ON Str( Recno() )           COMMENT "Recno"            NODELETED                              OF ::oTemporalDivisionNuevoTicket
      INDEX TO ( ::cTemporalDivisionNuevoTicket ) TAG "nRecNum"  ON Str( Recno() )           COMMENT "Recno"            FOR "!Deleted() .and. !Field->lKitChl" OF ::oTemporalDivisionNuevoTicket
      INDEX TO ( ::cTemporalDivisionNuevoTicket ) TAG "cCbaTil"  ON Field->cCbaTil           COMMENT "Código"           NODELETED                              OF ::oTemporalDivisionNuevoTicket
      INDEX TO ( ::cTemporalDivisionNuevoTicket ) TAG "nNumLin"  ON Str( Field->nNumLin )    COMMENT "Linea"            NODELETED                              OF ::oTemporalDivisionNuevoTicket
      INDEX TO ( ::cTemporalDivisionNuevoTicket ) TAG "cLinCba"  ON Str( Field->nNumLin ) + Field->cCbaTil ;   
                                                                                             COMMENT "Linea y código"   NODELETED                              OF ::oTemporalDivisionNuevoTicket

   END DATABASE ::oTemporalDivisionNuevoTicket

   ::oTemporalDivisionNuevoTicket:Activate( .f., .f. )   

   /*
   Definimos las bases de datos temporal comanda-------------------------------
   */

   ::cTemporalComanda      := cGetNewFileName( cPatTmp() + "TikC" )

   DEFINE DATABASE ::oTemporalComanda FILE ( ::cTemporalComanda ) CLASS "TikC" ALIAS "TikC" PATH ( cPatTmp() ) VIA ( cLocalDriver() ) COMMENT "Comandas ticket cliente"

      for each aFieldCol in aColTik()
         ::oTemporalComanda:addField( aFieldCol[ 1 ], aFieldCol[ 2 ], aFieldCol[ 3 ], aFieldCol[ 4 ], aFieldCol[ 6 ], , , , aFieldCol[ 5 ] )
      next

      INDEX TO       ( ::cTemporalComanda ) ;
         TAG         "TikC" ;
         ON          field->cSerTil + field->cNumTil + field->cSufTil + field->cOrdOrd + str( field->nNumLin ) ;
         COMMENT     "Orden" ;
         NODELETED ;
         OF          ::oTemporalComanda

   END DATABASE ::oTemporalComanda

   ::oTemporalComanda:Activate( .f., .f. ) 

   /*
   Definimos las bases de datos temporal impresión líneas-------------------------------
   */

   ::cTemporalImpresionLinea      := cGetNewFileName( cPatTmp() + "TikImpL" )

   DEFINE DATABASE ::oTemporalImpresionLinea FILE ( ::cTemporalImpresionLinea ) CLASS "TikImpL" ALIAS "TikImpL" PATH ( cPatTmp() ) VIA ( cLocalDriver() ) COMMENT "Temporal lineas ticket cliente"

      for each aFieldCol in aColTik()
         ::oTemporalImpresionLinea:AddField( aFieldCol[ 1 ], aFieldCol[ 2 ], aFieldCol[ 3 ], aFieldCol[ 4 ], aFieldCol[ 6 ], , , , aFieldCol[ 5 ] )
      next

      INDEX TO ( ::cTemporalImpresionLinea ) TAG "NumTik" ON Field->cSerTil + Field->cNumTil + Field->cSufTil + Str( Recno() )    COMMENT "Orden"   NODELETED OF ::oTemporalImpresionLinea
      INDEX TO ( ::cTemporalImpresionLinea ) TAG "Codigo" ON Field->cCbaTil COMMENT "Codigo"   NODELETED OF ::oTemporalImpresionLinea

   END DATABASE ::oTemporalImpresionLinea

   ::oTemporalImpresionLinea:Activate( .f., .f. ) 

   /*
   Definimos las bases de datos temporal linea---------------------------------
   */

   ::cTemporalCobro         := cGetNewFileName( cPatTmp() + "TikP" )

   DEFINE DATABASE ::oTemporalCobro FILE ( ::cTemporalCobro ) CLASS "TikP" ALIAS "TikP" PATH ( cPatTmp() ) VIA ( cLocalDriver() ) COMMENT "Pagos de ticket cliente"

      for each aFieldCol in aPgoTik()
         ::oTemporalCobro:AddField( aFieldCol[ 1 ], aFieldCol[ 2 ], aFieldCol[ 3 ], aFieldCol[ 4 ], "", , , , aFieldCol[ 5 ] )
      next

      INDEX TO ( ::cTemporalCobro ) TAG "TikP" ON Str( Recno() ) COMMENT "Orden" NODELETED OF ::oTemporalCobro

   END DATABASE ::oTemporalCobro

   // ::oTemporalCobro:Create()
   ::oTemporalCobro:Activate( .f., .f. )

 RETURN .t.

//---------------------------------------------------------------------------//

METHOD DestroyTemporal() CLASS TpvTactil

   if ::oTemporalLinea != nil .and. ::oTemporalLinea:Used()
      ::oTemporalLinea:End()
   end if

   ::oTemporalLinea                       := nil

   dbfErase( ::cTemporalLinea )

   if ::oTemporalDivisionOriginal != nil .and. ::oTemporalDivisionOriginal:Used()
      ::oTemporalDivisionOriginal:End()
   end if

   ::oTemporalDivisionOriginal            := nil

   dbfErase( ::cTemporalDivisionOriginal )

   if ::oTemporalDivisionNuevoTicket != nil .and. ::oTemporalDivisionNuevoTicket:Used()
      ::oTemporalDivisionNuevoTicket:End()
   end if

   ::oTemporalDivisionNuevoTicket         := nil

   dbfErase( ::cTemporalDivisionNuevoTicket )

   if ::oTemporalComanda != nil .and. ::oTemporalComanda:Used()
      ::oTemporalComanda:End()
   end if

   ::oTemporalComanda                     := nil

   dbfErase( ::cTemporalComanda )

   if ::oTemporalImpresionLinea != nil .and. ::oTemporalImpresionLinea:Used()
      ::oTemporalImpresionLinea:End()
   end if

   ::oTemporalImpresionLinea              := nil

   dbfErase( ::cTemporalImpresionLinea )

   if ::oTemporalCobro != nil .and. ::oTemporalCobro:Used()
      ::oTemporalCobro:End()
   end if

   ::oTemporalCobro                       := nil

   dbfErase( ::cTemporalCobro )

 Return .t.

//--------------------------------------------------------------------------//

METHOD cFileBmpName( cFile, lEmptyImage ) CLASS TpvTactil

   DEFAULT lEmptyImage  := .f.

   if at( ":", cFile ) == 0 .and. !empty( cPatImg() )
      cFile             := rtrim( cPatImg() ) + rtrim( cFile )
   else
      cFile             := rtrim( cFile )
   end if

   if file( cFile )
      return ( cFile )
   end if 

   cFile                := fullCurDir() + cFile

RETURN ( cFile )

//---------------------------------------------------------------------------//

METHOD AgregarLineas( cCodigoArticulo, cCodigoMenu, cCodigoOrden ) CLASS TpvTactil

   // Buscamos dentro la tablas articulos por nombre de articulo---------------

   if !::oArticulo:Seek( cCodigoArticulo )
      Return ( .f. )
   end if 

   // Tomamos las unidades del teclado-----------------------------------------

   if ( ::oArticulo:lPeso )
      ::nUnidades             := Calculadora( 0, , , "Peso: " + ::cNombreArticulo() )
   else
      ::nUnidades             := ::nGetUnidades( .t. )
   end if

   if empty( cCodigoOrden ) .and. !( ::lEmptyOrdenComanda )
      cCodigoOrden            := ::getCodigoOrdenComandaActual()
   end if 

   // Preguntamos si estamos combinando----------------------------------------

   if ::lCombinandoDos
   
      ::AgregarCombinado( cCodigoArticulo )
          
   else 

      // Preguntamos si el articulo tiene propiedades--------------------------

      if !empty( ::oArticulo:cCodPrp1 ) .and. !::DialogoPropiedadArticulo( ::oArticulo:Codigo )
         Return ( .f. )
      end if

      // Vemos si este atículo es acumulable-----------------------------------

      if !::lAcumulaArticulo( cCodigoMenu, cCodigoOrden )

         // Agregamos el articulo----------------------------------------------

         ::AgregarPrincipal( cCodigoArticulo, cCodigoMenu, cCodigoOrden )

         // Vemos si este artículo tiene un menú de acompañamiento-------------

         ::AgregarMenuAcompannamiento( ::oArticulo:cMenu, cCodigoMenu )

         // Iniciamos los comentarios------------------------------------------

         ::InitComentarios( .f. )

         // Reseteamos las propiedades-----------------------------------------

         ::ResetPropiedadArticulos()

         // Combinados---------------------------------------------------------

         if ::lCombinando
            ::lCombinandoDos  := .t.
            ::GoFamilia()
         end if

      end if

      // Limpiamos el texto de la calculadora y ponemos la calculadora en unidades
         
      ::oGetUnidades:cText( "" )
      ::CambiarUnidadesPrecio( .f. )

   end if 

   // Preguntamos si el articulo tiene lote------------------------------------

   if ( ::oArticulo:lLote )
      ::AgregarLote()
   end if 

   // refrescos de pantalla-------------------------------------------------

   ::oBrwLineas:Refresh()

   ::SetTotal()

   // Informamos en el visor------------------------------------------------
   
   ::AgregaLineaVisor( { ::oTemporalLinea:cNomTil, Trans( ::oTemporalLinea:nPvpTil, ::cPictureImporte ) }, 1 )
   ::AgregaLineaVisor( { "Total", Trans( ::sTotal:nTotalDocumento, ::cPictureTotal ) }, 2 )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AgregarArticuloMenu( cCodigoArticulo, cCodigoMenu, cCodigoOrden )
   
   local lDegustacion   := ::oTpvMenuOrdenes:lDegustacion( cCodigoMenu, cCodigoOrden )

   ::SetLineaMenu( ::nLineaMenuActivo() )

   if !::oTpvMenuOrdenes:lIntercambiable( cCodigoOrden )

      if ( lDegustacion .or. ::nNumeroArticulosOrden( cCodigoOrden ) < ::nNumeroUnidadesMenu() )
         
         ::AgregarLineas( cCodigoArticulo, cCodigoMenu, cCodigoOrden )
         
         if ( ::nNumeroArticulosOrden( cCodigoOrden ) == ::nNumeroUnidadesMenu() .and. !lDegustacion )
            ::oBrwFamilias:GoDown()
         end if

      else

         msgStop( "Ya has añadido todos los artículos para este orden." )
      
         ::oBrwFamilias:GoDown()

      endif

   else

      if ( lDegustacion .or. ::nArticulosOrdenesIntercambiables() < ( ::oTpvMenuOrdenes:nIntercambiables( cCodigoMenu, ::oTpvMenuOrdenes:oDbf ) * ::nNumeroUnidadesMenu() ) )

         ::AgregarLineas( cCodigoArticulo, cCodigoMenu, cCodigoOrden )
         
         if ( ::nNumeroArticulosOrden( cCodigoOrden ) == ::nNumeroUnidadesMenu() .and. !lDegustacion )
            ::oBrwFamilias:GoDown()
         end if

      else

         msgStop( "Ya has añadido todos los artículos para los ordenes intercambiables." )
      
         ::oBrwFamilias:GoDown()

      endif

   end if

   ::SetLineaMenu()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD nNumeroUnidadesMenu()
   
   local nUnidades      := 0

   ::oTemporalLinea:GetStatus()

   if ::oTemporalLinea:SeekInOrd( str( ::GetLineaMenu(), 4 ), "nNumLin" )
      nUnidades      := ::nUnidadesLinea( ::oTemporalLinea )
   end if

   ::oTemporalLinea:SetStatus()

RETURN ( nUnidades )

//---------------------------------------------------------------------------//

METHOD nArticulosOrdenesIntercambiables()

   local nTotal   := 0

   ::oTemporalLinea:GetStatus()

   ::oTemporalLinea:GoTop()

   while !::oTemporalLinea:eof()

      if ::oTpvMenuOrdenes:lIntercambiable( ::oTemporalLinea:cOrdOrd )
         nTotal     += ::nUnidadesLinea( ::oTemporalLinea )
      end if

      ::oTemporalLinea:Skip()

   end while

   ::oTemporalLinea:SetStatus()

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nNumeroArticulosOrden( cCodigoOrden )

   local nArticulos     := 0

   ::oTemporalLinea:GetStatus()

   ::oTemporalLinea:GoTop()

   while !::oTemporalLinea:eof()

      if cCodigoOrden == ::oTemporalLinea:cOrdOrd .and. ::GetLineaMenu() == ::oTemporalLinea:nLinMnu .and. !::oTemporalLinea:lDelTil
         nArticulos     += ::nUnidadesLinea( ::oTemporalLinea )
      end if

      ::oTemporalLinea:Skip()

   end while

   ::oTemporalLinea:SetStatus()

RETURN ( nArticulos )

//---------------------------------------------------------------------------//

METHOD nLineaMenuActivo()

   local nLinea   := 0

   if ::oTemporalLinea:lMnuTil
      nLinea      := ::oTemporalLinea:nNumLin
   endif

   if empty( nLinea )
      if ::oTemporalLinea:nLinMnu != 0
         nLinea   := ::oTemporalLinea:nLinMnu
      end if
   end if 

RETURN ( nLinea )

//---------------------------------------------------------------------------//

METHOD AgregarPrincipal( cCodigoArticulo, cCodigoMenu, cCodigoOrden )

   CursorWait()

   SysRefresh()

   ::nNumeroLinea                := nLastNum( ::oTemporalLinea )
   ::nPosPrint                   := nLastNum( ::oTemporalLinea, "nPosPrint" )

   ::oTemporalLinea:Append()
   ::oTemporalLinea:Blank()
       
   ::oTemporalLinea:nNumLin      := ::nNumeroLinea
   ::oTemporalLinea:nPosPrint    := ::nPosPrint
   ::oTemporalLinea:nLinMnu      := __bottomNumber__

   ::oTemporalLinea:nUntTil      := ::nUnidades
   ::oTemporalLinea:cCbaTil      := ::oArticulo:Codigo
   ::oTemporalLinea:cNomTil      := ::cNombreArticulo()
   ::oTemporalLinea:nCosDiv      := nCosto( ::oArticulo:Codigo, ::oArticulo:cAlias, ::oArticulosEscandallos:cAlias )
   ::oTemporalLinea:cLote        := ::oArticulo:cLote
   ::oTemporalLinea:cCodFam      := ::oArticulo:Familia
   ::oTemporalLinea:cFamTil      := ::oArticulo:Familia
   ::oTemporalLinea:nCtlStk      := ::oArticulo:nCtlStock
   ::oTemporalLinea:lPeso        := ::oArticulo:lPeso

   if ( ::oArticulo:lFacCnv )
      ::oTemporalLinea:nFacCnv   := NotCero( ::oArticulo:nFacCnv )
   end if 
         
   ::oTemporalLinea:nIvaTil      := nIva( ::oTipoIva, ::oArticulo:TipoIva )
   ::oTemporalLinea:cAlmLin      := oUser():cAlmacen()
   ::oTemporalLinea:cImpCom1     := ::oArticulo:cTipImp1
   ::oTemporalLinea:cImpCom2     := ::oArticulo:cTipImp2
   ::oTemporalLinea:cComent      := ""

   ::oTemporalLinea:lKitArt      := ::oArticulo:lKitArt
   ::oTemporalLinea:lKitPrc      := lPreciosCompuestos( ::oArticulo:Codigo, ::oArticulo:cAlias )

   ::oTemporalLinea:lInPromo     := ::oFideliza:InPrograma( ::oArticulo:Codigo, ::oTiketCabecera:dFecTik, ::oArticulo )

   // El producto pertenece a un menu------------------------------------------

   if !empty( cCodigoMenu )
      ::oTemporalLinea:cCodMnu   := cCodigoMenu
      ::oTemporalLinea:nLinMnu   := ::GetLineaMenu()
   end if

   // Orden de la comanda------------------------------------------------------

   if !empty( cCodigoOrden )
      ::oTemporalLinea:cOrdOrd   := cCodigoOrden
   else
      ::oTemporalLinea:cOrdOrd   := ::oArticulo:cOrdOrd
   end if

   // Guardamos las propiedades del articulo-----------------------------------

   if !Empty( ::oArticulo:cCodPrp1 )
      ::oTemporalLinea:cCodPr1   := ::GetCodigoPropiedadArticulo1()
      ::oTemporalLinea:cValPr1   := ::GetValorPropiedadArticulo1()
   end if

   // Obtenemos el precio del articulo-----------------------------------------

   ::oTemporalLinea:nPvpTil      := ::nPrecioArticulo( cCodigoArticulo, cCodigoMenu, cCodigoOrden )

   // guardar linea

   ::oTemporalLinea:Save()

   // Agregamos los kits si es el caso-----------------------------------------

   if !Empty( cCodigoMenu )
      ::AgregarKit( cCodigoArticulo, ::nUnidades, ::oArticulo:cTipImp1, ::oArticulo:cTipImp2, ::GetLineaMenu() )
   else
      ::AgregarKit( cCodigoArticulo, ::nUnidades, ::oArticulo:cTipImp1, ::oArticulo:cTipImp2 )
   end if

   ::oBrwLineas:Refresh()

   CursorWE()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AgregarAcompannamiento( cCodigoArticulo, nUnidadesMenu, cCodigoMenu, cCodigoOrden )

   // Localizamos el articulo--------------------------------------------------

   if !::oArticulo:Seek( cCodigoArticulo )
      Return ( .f. )
   end if

   CursorWait()

   SysRefresh()

   if Empty( ::nNumeroLinea )
      ::nNumeroLinea                := nLastNum( ::oTemporalLinea )
   end if

   ::oTemporalLinea:Append()
   ::oTemporalLinea:Blank()
       
   ::oTemporalLinea:nNumLin      := ::nNumeroLinea

   // Comprobamos si este acompañamiento pertenece a un artículo de un menú
   if Empty( ::GetLineaMenu() )
      ::oTemporalLinea:nLinMnu      := __bottomNumber__
   else
      ::oTemporalLinea:nLinMnu      := ::GetLineaMenu()
   end if

   ::oTemporalLinea:nPvpTil      := ::nPrecioArticulo( cCodigoArticulo, cCodigoMenu, cCodigoOrden )
   ::oTemporalLinea:nUntTil      := nUnidadesMenu
   ::oTemporalLinea:cCbaTil      := ::oArticulo:Codigo
   ::oTemporalLinea:cNomTil      := ::cNombreArticulo()
   ::oTemporalLinea:nCosDiv      := nCosto( ::oArticulo:Codigo, ::oArticulo:cAlias, ::oArticulosEscandallos:cAlias )
   ::oTemporalLinea:cLote        := ::oArticulo:cLote
   ::oTemporalLinea:cCodFam      := ::oArticulo:Familia
   ::oTemporalLinea:cFamTil      := ::oArticulo:Familia
   ::oTemporalLinea:nCtlStk      := ::oArticulo:nCtlStock

   if ( ::oArticulo:lFacCnv )
      ::oTemporalLinea:nFacCnv   := NotCero( ::oArticulo:nFacCnv )
   end if 
         
   ::oTemporalLinea:nIvaTil      := nIva( ::oTipoIva, ::oArticulo:TipoIva )
   ::oTemporalLinea:cAlmLin      := oUser():cAlmacen()
   ::oTemporalLinea:cImpCom1     := ::oArticulo:cTipImp1
   ::oTemporalLinea:cImpCom2     := ::oArticulo:cTipImp2
   ::oTemporalLinea:cComent      := ""

   ::oTemporalLinea:lKitArt      := ::oArticulo:lKitArt
   ::oTemporalLinea:lKitPrc      := lPreciosCompuestos( ::oArticulo:Codigo, ::oArticulo:cAlias )

   ::oTemporalLinea:lInPromo     := ::oFideliza:InPrograma( ::oArticulo:Codigo, ::oTiketCabecera:dFecTik, ::oArticulo )

   ::oTemporalLinea:lMnuAco      := .t.

   // Orden de la comanda------------------------------------------------------

   ::oTemporalLinea:cOrdOrd      := ::oArticulo:cOrdOrd

   ::oTemporalLinea:Save()

   // Agregamos los kits si es el caso-----------------------------------------

   ::AgregarKit( cCodigoArticulo, nUnidadesMenu, ::oArticulo:cTipImp1, ::oArticulo:cTipImp2, ::GetLineaMenu() )

   CursorWE()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AgregarCombinado()

   CursorWait()

   ::oTemporalLinea:Load()

   ::oTemporalLinea:cComTil      := ::oArticulo:Codigo
   ::oTemporalLinea:cNcmTil      := ::cNombreArticulo()
   ::oTemporalLinea:cFcmTil      := ::oArticulo:Familia
   ::oTemporalLinea:nPcmTil      := cRetPreArt( ::oArticulo:Codigo,        ::nTarifaCombinado, cDivEmp(), .t., ::oArticulo:cAlias, ::oDivisas:cAlias, ::oArticulosEscandallos:cAlias, ::oTipoIVA:cAlias )
   ::oTemporalLinea:nPvpTil      := cRetPreArt( ::oTemporalLinea:cCbaTil,  ::nTarifaCombinado, cDivEmp(), .t., ::oArticulo:cAlias, ::oDivisas:cAlias, ::oArticulosEscandallos:cAlias, ::oTipoIVA:cAlias )
   ::oTemporalLinea:nCosTil      := ::oArticulo:pCosto
   ::oTemporalLinea:nComStk      := ::oArticulo:nCtlStock

   if ( ::oArticulo:lFacCnv )
      ::oTemporalLinea:nFcmCnv   := NotCero( ::oArticulo:nFacCnv )
   end if

   ::oTemporalLinea:Save()

   // Agregamos kits si los tiene----------------------------------------------

   ::agregarKit( ::oArticulo:Codigo, ::nUnidades, ::oArticulo:cTipImp1, ::oArticulo:cTipImp2 )
   
   ::setCombinando( .f. )

   CursorWE()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AgregarOrdenComanda( cOrdenComanda )

   CursorWait()

   SysRefresh()

   ::nNumeroLinea                := nLastNum( ::oTemporalLinea )
   ::nPosPrint                   := nLastNum( ::oTemporalLinea, "nPosPrint" )

   ::oTemporalLinea:Append()
   ::oTemporalLinea:Blank()
       
   ::oTemporalLinea:nLinMnu      := __bottomNumber__
   ::oTemporalLinea:nNumLin      := ::nNumeroLinea
   ::oTemporalLinea:nPosPrint    := ::nPosPrint
   ::oTemporalLinea:cNomTil      := "* * " + alltrim( cOrdenComanda ) + " * *"
   ::oTemporalLinea:lControl     := .t.

   ::oTemporalLinea:Save()

   ::oBrwLineas:Refresh()

   CursorWE()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD DialogoPropiedadArticulo( cCodigoArticulo ) CLASS TpvTactil

   local nOrdAnt
   local oBrwPropiedades
   local oDlgPropiedadArticulo

   // Filtramos la tabla para que solo nos salgan las propiedades nuestras--------

   ::oArticuloPropiedades:GetStatus()

   nOrdAnt        := ::oArticuloPropiedades:OrdSetFocus( "cCodigo" )

   ::oArticuloPropiedades:OrdScope( cCodigoArticulo )
   ::oArticuloPropiedades:GoTop()

   DEFINE DIALOG oDlgPropiedadArticulo RESOURCE "TPV_Propiedad_Articulo"

     REDEFINE BUTTONBMP ;
         ID       101 ;
         OF       oDlgPropiedadArticulo ;
         BITMAP   "gc_arrow_up_32" ;
         ACTION   ( oBrwPropiedades:Select( 0 ), oBrwPropiedades:GoUp(), oBrwPropiedades:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         ID       102 ;
         OF       oDlgPropiedadArticulo ;
         BITMAP   "gc_arrow_down_32" ;
         ACTION   ( oBrwPropiedades:Select( 0 ), oBrwPropiedades:GoDown(), oBrwPropiedades:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "gc_check_32" ;
         ID       IDOK ;
         OF       oDlgPropiedadArticulo ;
         ACTION   ( oDlgPropiedadArticulo:End( IDOK ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       oDlgPropiedadArticulo ;
         ACTION   ( oDlgPropiedadArticulo:End() )


      // Montamos el browse de propiedades-------------------------------------

      oBrwPropiedades                  := IXBrowse():New( oDlgPropiedadArticulo )

      oBrwPropiedades:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPropiedades:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      oBrwPropiedades:nMarqueeStyle    := MARQSTYLE_HIGHLROW
      oBrwPropiedades:cName            := "Propiedades de artículos"
      oBrwPropiedades:lHeader          := .f.
      oBrwPropiedades:lHScroll         := .f.
      oBrwPropiedades:nRowHeight       := 60
      
      oBrwPropiedades:SetFont( ::oFntBrw )

      oBrwPropiedades:CreateFromResource( 100 )

      ::oArticuloPropiedades:SetBrowse( oBrwPropiedades )
      
      oBrwPropiedades:bLDblClick     := {|| oDlgPropiedadArticulo:End( IDOK ) }

      with object ( oBrwPropiedades:AddCol() )
         :bEditValue                   := {|| cNombrePropiedad( ::oArticuloPropiedades:cCodPr1, ::oArticuloPropiedades:cValPr1, ::oPropiedadesLinea )  }
      end with

   ACTIVATE DIALOG oDlgPropiedadArticulo CENTER

   if oDlgPropiedadArticulo:nResult == IDOK
      ::SetCodigoPropiedadArticulo1(   ::oArticuloPropiedades:cCodPr1 )
      ::SetValorPropiedadArticulo1(    ::oArticuloPropiedades:cValPr1 )
   end if

   // Dejamos la tabla como estaba------------------------------------------------

   ::oArticuloPropiedades:ClearScope()
   ::oArticuloPropiedades:OrdSetFocus( nOrdAnt )
   ::oArticuloPropiedades:SetStatus()

RETURN ( oDlgPropiedadArticulo:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD nPrecioArticulo( cCodigoArticulo, cCodigoMenu, cCodigoOrden ) CLASS TpvTactil

   local sOferta
   local cCodGrp
   local nPrecio        := 0
   local nTotalLinea    := 0

   // si el artículo pertenece a un menú comprobamos si tiene incremento, y si no el precio es 0 //

   if !Empty(cCodigoMenu) 

      if ::oTpvMenuArticulo:IncrementoPrecio( cCodigoArticulo, cCodigoMenu, cCodigoOrden ) != 0

         nPrecio        := ::oTpvMenuArticulo:IncrementoPrecio( cCodigoArticulo, cCodigoMenu, cCodigoOrden )

      end if

      Return ( nPrecio )

   end if 

   // si estamos capturando el precio por pantalla-----------------------------

   if ::lGetPrecio
      
      nPrecio           := ::valUnidadesPrecios()

      if !Empty( nPrecio ) 
         Return ( nPrecio )
      end if

   end if 

   // Propiedad del articulo------------------------------------------------------

   if !empty( ::GetCodigoPropiedadArticulo1() )

      nPrecio           := nPrecioPorPorpiedades( cCodigoArticulo, ::GetCodigoPropiedadArticulo1(), ::GetValorPropiedadArticulo1(), ::GetCodigoPropiedadArticulo2(), ::GetValorPropiedadArticulo2(), ::oArticuloPropiedades:cAlias )

      if nPrecio != 0
         Return ( nPrecio )
      end if 

   end if 

   // Obtenemos el precio normal del artículo-------------------------------------

   nPrecio              := cRetPreArt( cCodigoArticulo, ::nTarifaSolo, cDivEmp(), .t., ::oArticulo:cAlias, ::oDivisas:cAlias, ::oArticulosEscandallos:cAlias, ::oTipoIVA:cAlias )

   // Si el artículo está de oferta cambiamos el precio hasta la oferta-----------

   cCodGrp              := RetGrpCli( ::oTiketCabecera:cCliTik, ::oCliente:cAlias )

   sOferta              := sOfertaArticulo( cCodigoArticulo, ::oTiketCabecera:cCliTik, cCodGrp, 1, GetSysDate(), ::oArticulosOfertas:cAlias, ::nTarifaSolo, .t., Space( 20 ), Space( 20 ), Space( 20 ), Space( 20 ), ::oTiketCabecera:cDivTik, 1, nPrecio )
   if !Empty( sOferta ) 
      nPrecio           := sOferta:nPrecio
   end if

   // Si el cliente tiene una tarifa atípica la buscamos tb-----------------------

   /*if lBuscarAtipicaArticulo( ::oTiketCabecera:cCliTik, cCodGrp, GetSysDate(), cCodigoArticulo, ::GetCodigoPropiedadArticulo1(), ::GetValorPropiedadArticulo1(), ::GetCodigoPropiedadArticulo2(), ::GetValorPropiedadArticulo2(), ::oAtipicasCliente:cAlias )
      nPrecio           := nImpAtp( ::nTarifaSolo, ::oAtipicasCliente:cAlias, , nIva( ::oTipoIva, ::oArticulo:TipoIva ) )
   end if   */

Return ( nPrecio )

//---------------------------------------------------------------------------//

METHOD lAcumulaArticulo( cCodigoMenu, cCodigoOrden ) CLASS TpvTactil

   local lReturn        := .f.
   local nPrecioLinea
   local aStatus

   if ( ::oTemporalLinea:ordKeyCount() == 0 )
      Return .f.
   end if

   // si esta marcada la casilla de no acumular en tactil----------------------

   if uFieldEmpresa( "lAddCut" )
      Return .f.
   end if

   // si no estamos combinando-------------------------------------------------

   if ::lCombinando
      Return .f.
   end if

   // Comprobamos que el artículo sea acumulable-------------------------------

   if oRetFld( ::oArticulo:Familia, ::oFamilias, "lAcum", "cCodFam" )
      Return .f.
   end if

   // Comprobamos que el artículo sea por peso----------------------------------

   if ::oArticulo:lPeso
      Return .f.
   end if

   // Comprobamos que el artículo tenga acompañamiento-------------------------

   if !Empty( ::oArticulo:cMenu )
      Return .f.
   end if

   CursorWait()

   aStatus              := ::oTemporalLinea:GetStatus()

   // Buscamos codigos iguales--------------------------------------------------

   ::oTemporalLinea:OrdSetFocus( "cCbaTil" )
   if ::oTemporalLinea:Seek( ::oArticulo:Codigo )

      while ( ::oTemporalLinea:cCbaTil == ::oArticulo:Codigo ) .and. !( ::oTemporalLinea:Eof() )
         
         nPrecioLinea      := ::nPrecioArticulo( ::oArticulo:Codigo, cCodigoMenu, cCodigoOrden )

         // Obtenemos el codigo de orden si no nos lo pasan--------------------

         if empty( cCodigoOrden )
            cCodigoOrden   := ::oArticulo:cOrdOrd
         end if 

         // Comprobamos que el codigo y el precio sean iguales y que no sean ofertas-

         // msgstop( empty( ::oTemporalLinea:cComTil )                           , "empty( ::oTemporalLinea:cComTil )                          "  )
         // msgstop( empty( ::oTemporalLinea:cComent )                           , "empty( ::oTemporalLinea:cComent )                          "  )
         // msgstop( rtrim( ::oTemporalLinea:cNomTil ) == ::cNombreArticulo()    , "rtrim( ::oTemporalLinea:cNomTil ) == ::cNombreArticulo()   "  )
         // msgstop( !::oTemporalLinea:lKitChl                                   , "!::oTemporalLinea:lKitChl                                  "  )
         // msgstop( !::oTemporalLinea:lDelTil                                   , "!::oTemporalLinea:lDelTil                                  "  )
         // msgstop( ::oTemporalLinea:nPvpTil == nPrecioLinea                    , "::oTemporalLinea:nPvpTil == nPrecioLinea                   "  )
         // msgstop( ::oTemporalLinea:nDtoLin == 0                               , "::oTemporalLinea:nDtoLin == 0                              "  )
         // msgstop( ::oTemporalLinea:cOrdOrd == cCodigoOrden                    , "::oTemporalLinea:cOrdOrd == cCodigoOrden                   "  )
         // msgstop( ::oTemporalLinea:nUntTil > 0                                , "::oTemporalLinea:nUntTil > 0                               "  )
         // msgstop( ::oTemporalLinea:nLinMnu == ::GetLineaMenu()                , "::oTemporalLinea:nLinMnu == ::GetLineaMenu()               "  )
         // msgstop( ::oTemporalLinea:cCodPr1 == ::GetCodigoPropiedadArticulo1() , "::oTemporalLinea:cCodPr1 == ::GetCodigoPropiedadArticulo1()"  )
         // msgstop( ::oTemporalLinea:cValPr1 == ::GetValorPropiedadArticulo1()  , "::oTemporalLinea:cValPr1 == ::GetValorPropiedadArticulo1() "  )
         // msgstop( ::oTemporalLinea:cCodPr2 == ::GetCodigoPropiedadArticulo2() , "::oTemporalLinea:cCodPr2 == ::GetCodigoPropiedadArticulo2()"  )
         // msgstop( ::oTemporalLinea:cValPr2 == ::GetValorPropiedadArticulo2()  , "::oTemporalLinea:cValPr2 == ::GetValorPropiedadArticulo2() "  )
         // msgstop( ::nUnidades > 0, "nUnidades > 0" )
         // msgstop( !::oTemporalLinea:lSave                                     , "!::oTemporalLinea:lSave                                    "  )

         if empty( ::oTemporalLinea:cComTil )                              .and. ;
            empty( ::oTemporalLinea:cComent )                              .and. ;
            rtrim( ::oTemporalLinea:cNomTil ) == ::cNombreArticulo()       .and. ;
            !::oTemporalLinea:lKitChl                                      .and. ;
            !::oTemporalLinea:lDelTil                                      .and. ;
            !::oTemporalLinea:lSave                                        .and. ;
            ::oTemporalLinea:nPvpTil == nPrecioLinea                       .and. ;
            ::oTemporalLinea:nDtoLin == 0                                  .and. ;
            ::oTemporalLinea:cOrdOrd == cCodigoOrden                       .and. ;
            ::oTemporalLinea:nUntTil > 0                                   .and. ;
            ::oTemporalLinea:nLinMnu == ::GetLineaMenu()                   .and. ;
            ::oTemporalLinea:cCodPr1 == ::GetCodigoPropiedadArticulo1()    .and. ;
            ::oTemporalLinea:cValPr1 == ::GetValorPropiedadArticulo1()     .and. ;
            ::oTemporalLinea:cCodPr2 == ::GetCodigoPropiedadArticulo2()    .and. ;
            ::oTemporalLinea:cValPr2 == ::GetValorPropiedadArticulo2()     .and. ;
            ::nUnidades > 0


            /*
            Sumamos------------------------------------------------------------
            */

            ::SumarUnidades( ::nUnidades )

            /*
            Tomamos el valor de retorno y saliendo-----------------------------
            */

            lReturn     := .t.

            exit

         end if

         ::oTemporalLinea:Skip()

      end while

   end if

   ::oTemporalLinea:SetStatus( aStatus )

   CursorWE()

   ::oBrwLineas:Refresh()

Return ( lReturn )

//-------------------------------------------------------------------------//

METHOD AgregarKit( cCodigoArticulo, nUnidades, cTipoImpresora1, cTipoImpresora2, nLineaMenu ) CLASS TpvTactil

   local lKitHijo
   local lImprimirLinea
   local lKitPrecio
   local nTotalUnidades    := 0
   local aStatusLinea      := ::oTemporalLinea:GetStatus()
   local aStatusArticulo   := ::oArticulo:GetStatus()
   local aStatusEscandallo := ::oArticulosEscandallos:GetStatus()

   DEFAULT nLineaMenu      := __bottomNumber__
   
   lKitHijo                := !lKitAsociado( cCodigoArticulo, ::oArticulo )
   lKitPrecio              := lPreciosComponentes( cCodigoArticulo, ::oArticulo:cAlias )   // 1 Todos, 2 Compuesto, 3 Componentes
   lImprimirLinea          := lImprimirComponente( cCodigoArticulo, ::oArticulo:cAlias )   // 1 Todos, 2 Compuesto, 3 Componentes

   if ::oArticulosEscandallos:Seek( cCodigoArticulo )

      while ( ::oArticulosEscandallos:cCodKit == cCodigoArticulo ) .and. !( ::oArticulosEscandallos:eof() )

         if ::oArticulo:Seek( ::oArticulosEscandallos:cRefKit )

            nTotalUnidades                := ::oArticulosEscandallos:nUndKit * nUnidades

            ::oTemporalLinea:Append()
            ::oTemporalLinea:Blank()

            ::oTemporalLinea:nLinMnu      := nLineaMenu

            // Total unidades--------------------------------------------------

            ::oTemporalLinea:nUntTil      := nTotalUnidades

            ::oTemporalLinea:cCbaTil      := ::oArticulo:Codigo
            ::oTemporalLinea:cNomTil      := ::cNombreArticulo()
            ::oTemporalLinea:nCosDiv      := nCosto( ::oArticulo:Codigo, ::oArticulo:cAlias, ::oArticulosEscandallos:cAlias )
            ::oTemporalLinea:cLote        := ::oArticulo:cLote
            ::oTemporalLinea:cCodFam      := ::oArticulo:Familia
            ::oTemporalLinea:cFamTil      := ::oArticulo:Familia
            ::oTemporalLinea:nCtlStk      := ::oArticulo:nCtlStock

            // Impresoras del compuesto----------------------------------------

            ::oTemporalLinea:cImpCom1     := cTipoImpresora1
            ::oTemporalLinea:cImpCom2     := cTipoImpresora2

            if ( ::oArticulo:lFacCnv )
               ::oTemporalLinea:nFacCnv   := NotCero( ::oArticulo:nFacCnv )
            end if

            ::oTemporalLinea:nIvaTil      := nIva( ::oTipoIva, ::oArticulo:TipoIva )
            ::oTemporalLinea:cAlmLin      := oUser():cAlmacen()
            ::oTemporalLinea:cComent      := ""

            ::oTemporalLinea:lInPromo     := ::oFideliza:InPrograma( ::oArticulo:Codigo, ::oTiketCabecera:dFecTik, ::oArticulo )

            /*
            Propiedades de los kits-----------------------------------------
            */

            ::oTemporalLinea:lKitChl      := lKitHijo
            ::oTemporalLinea:lImpLin      := lImprimirLinea
            ::oTemporalLinea:lKitPrc      := lKitPrecio

            /*
            Podemos sacar productos asociados----------------------------------
            */

            if ::oTemporalLinea:lKitChl
               ::oTemporalLinea:nNumLin   := ::nNumeroLinea
            else
               ::nNumeroLinea             := nLastNum( ::oTemporalLinea )
            end if

            /*
            Precio del producto asociado---------------------------------------
            */

            if lKitPrecio
               ::oTemporalLinea:nPvpTil   := cRetPreArt( ::oArticulo:Codigo, ::nTarifaSolo, cDivEmp(), .t., ::oArticulo:cAlias, ::oDivisas:cAlias, ::oArticulosEscandallos:cAlias, ::oTipoIVA:cAlias )
            end if

            /*
            Control de stock---------------------------------------------------
            */

            ::oTemporalLinea:nCtlStk      := ::oArticulo:nCtlStock

            ::oTemporalLinea:Save()

         end if

         // Tiene nuevos escandallos-------------------------------------------

         ::AgregarKit( ::oArticulosEscandallos:cRefKit, nTotalUnidades, cTipoImpresora1, cTipoImpresora2, nLineaMenu )

         // Siguiente articulo del kit-----------------------------------------

         ::oArticulosEscandallos:Skip()

      end while

   end if

   ::oTemporalLinea:SetStatus( aStatusLinea )
   ::oArticulosEscandallos:SetStatus( aStatusEscandallo )
   ::oArticulo:SetStatus( aStatusArticulo )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD SumarUnidades( nNuevasUnidades ) CLASS TpvTactil

   local nNumeroLinea
   local nUnidadesAnterior
   local nUnidadesActuales

   if ( ::oTemporalLinea:ordKeyCount() == 0 )
      Return ( .t. )
   end if

   if Empty( nNuevasUnidades )
      nNuevasUnidades                  := ::nGetUnidades( .t. )
   end if

   nUnidadesActuales                   := ::oTemporalLinea:nUntTil + nNuevasUnidades

   if !Empty( nUnidadesActuales )

      nNumeroLinea                     := ::oTemporalLinea:nNumLin
      nUnidadesAnterior                := ::oTemporalLinea:nUntTil

      ::oTemporalLinea:GetStatus()
      ::oTemporalLinea:OrdSetFocus( "nNumLin" )

      if ::oTemporalLinea:Seek( Str( nNumeroLinea ) )
         while ( ::oTemporalLinea:nNumLin == nNumeroLinea ) .and. !( ::oTemporalLinea:eof() )

            ::oTemporalLinea:nUntTil   := ( ::oTemporalLinea:nUntTil / nUnidadesAnterior ) * ( nUnidadesActuales ) 

            ::oTemporalLinea:Skip()

         end while
      end if

      ::oTemporalLinea:SetStatus()

      ::SetTotal()

      ::oBrwLineas:Refresh()

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD IncrementarUnidades() CLASS TpvTactil

   local nNumeroLinea
   local nUnidadesAnterior
   local nUnidadesActuales

   if ( ::oTemporalLinea:ordKeyCount() == 0 )
      Return ( .t. )
   end if

   nUnidadesActuales                      := ::valUnidadesPrecios()

   if !Empty( nUnidadesActuales )

      nNumeroLinea                        := ::oTemporalLinea:nNumLin
      nUnidadesAnterior                   := ::oTemporalLinea:nUntTil

      ::oTemporalLinea:GetStatus()
      ::oTemporalLinea:OrdSetFocus( "nNumLin" )

      if ::oTemporalLinea:Seek( Str( nNumeroLinea ) )
         while ( ::oTemporalLinea:nNumLin == nNumeroLinea ) .and. !( ::oTemporalLinea:eof() )

            ::oTemporalLinea:nUntTil      := ( ::oTemporalLinea:nUntTil / nUnidadesAnterior ) * ( nUnidadesActuales ) 

            // if !uFieldEmpresa( "lAddCut")
            //    ::oTemporalLinea:nUntTil   += nUnidadesAnterior 
            // end if 

            ::oTemporalLinea:Skip()

         end while
      end if

      ::oTemporalLinea:SetStatus()

      ::cGetUnidades                      := ""

      ::SetTotal()

      ::oBrwLineas:Refresh()

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AgregarFavoritos( cNombreArticulo ) CLASS TpvTactil

   ::oArticulo:GetStatus()
   ::oArticulo:OrdSetFocus( "Nombre" )

   CursorWait()

   /*
   Buscamos dentro la tablas articulos por nombre de articulo------------------
   */

   if ::oArticulo:Seek( Upper( Padr( cNombreArticulo, 100 ) ) )

      ::oTemporalLinea:Append()
      ::oTemporalLinea:cCbaTil   := ::oArticulo:Codigo
      ::oTemporalLinea:cNomTil   := ::cNombreArticulo()
      ::oTemporalLinea:nCosDiv   := nCosto( ::oArticulo:Codigo, ::oArticulo:cAlias, ::oArticulosEscandallos:cAlias )
      ::oTemporalLinea:cLote     := ::oArticulo:cLote
      ::oTemporalLinea:cCodFam   := ::oArticulo:Familia
      ::oTemporalLinea:nCtlStk   := ::oArticulo:nCtlStock
      ::oTemporalLinea:nUntTil   := 1
      ::oTemporalLinea:nPvpTil   := cRetPreArt( ::oArticulo:Codigo, Max( ::oTiketCabecera:nTarifa, 1 ), cDivEmp(), .t., ::oArticulo:cAlias, ::oDivisas:cAlias, ::oArticulosEscandallos:cAlias, ::oTipoIVA:cAlias )
      ::oTemporalLinea:nIvaTil   := nIva( ::oTipoIVA, ::oArticulo:TipoIVA )
      ::oTemporalLinea:cAlmLin   := oUser():cAlmacen()
      ::oTemporalLinea:cImpCom1  := ::oArticulo:cTipImp1
      ::oTemporalLinea:cImpCom2  := ::oArticulo:cTipImp2
      ::oTemporalLinea:cComent   := ""
      ::oTemporalLinea:Save()

   end if

   if !Empty( ::oBrwLineas )
      ::oBrwLineas:Refresh()
   end if

   ::oArticulo:SetStatus()

   ::SetTotal()

   CursorWE()

Return .t.

//---------------------------------------------------------------------------//

METHOD AgregarPLU() CLASS TpvTactil

   local cCodigoArticulo

   /*
   Primero buscamos por codigos de barra---------------------------------------
   */

   cCodigoArticulo               := cSeekCodebar( ::cGetUnidades, ::oCodigoBarraArticulo, ::oArticulo )

   ::oGetUnidades:cText( "" )

   if !::AgregarLineas( cCodigoArticulo )
      MsgBeepStop( "Artículo " + Alltrim( cCodigoArticulo ) + " no encontrado." )
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD InitComentarios( lForced ) CLASS TpvTactil

   local oCbxOrd
   local cNumPed
   local oGetComentario
   local cGetComentario
   local cComentarioFamilia
   local oBrwComentarios
   local oBrwLineasComentarios
   local oDlgComentarios

   DEFAULT lForced   := .f.

   // Si no tenemos ningun articulo en las lineas nos aparece este comentario-----

   if ::oTemporalLinea:ordKeyCount() == 0
      MsgStop( "No hay líneas para introducir comentarios." )
      RETURN ( nil )
   end if

   // si ls familia tiene la marca de comentarios los mostramos o si nos fuerzan

   if !lForced .and. !oRetFld( ::oTemporalLinea:cCodFam, ::oFamilias, "lMostrar", "cCodFam" )
      RETURN ( nil )
   end if 

   // Si el domumento es editable----------------------------------------------

   if !::lEditableDocumento()
      MsgStop( "El documento ya está cerrado" )
      RETURN ( nil )
   end if

   /*
   Vamos a ver si la familia tiene comentario----------------------------------
   */

   cComentarioFamilia         := oRetFld( ::oTemporalLinea:cCodFam, ::oFamilias, "cComFam", "cCodFam" )

   /*
   Guardamos el valor del comentario anterior----------------------------------
   */

   cGetComentario             := ::oTemporalLinea:cComent

   /*
   Definimos el dialogo para los comentarios-----------------------------------
   */

   DEFINE DIALOG oDlgComentarios RESOURCE "TPVComentarios"

      REDEFINE GET oGetComentario VAR cGetComentario;
         ID       150;
         FONT     ::oFntDlg ;
         OF       oDlgComentarios

      REDEFINE BUTTONBMP ;
         ID       160 ;
         OF       oDlgComentarios ;
         BITMAP   "gc_keyboard_32" ; 
         ACTION   ( VirtualKey( .f., oGetComentario ) ) 

      REDEFINE BUTTONBMP ;
         ID       161 ;
         OF       oDlgComentarios ;
         BITMAP   "gc_garbage_full_32" ;
         ACTION   ( oGetComentario:cText( Space( 254 ) ) )
  
      REDEFINE BUTTONBMP ;
         ID       170 ; 
         OF       oDlgComentarios ;
         BITMAP   "gc_arrow_up_32" ;
         ACTION   ( oBrwComentarios:Select( 0 ), oBrwComentarios:GoUp(), oBrwComentarios:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         ID       171 ;
         OF       oDlgComentarios ;
         BITMAP   "gc_arrow_down_32" ;
         ACTION   ( oBrwComentarios:Select( 0 ), oBrwComentarios:GoDown(), oBrwComentarios:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         ID       180 ;
         OF       oDlgComentarios ;
         BITMAP   "gc_arrow_up_32" ;
         ACTION   ( oBrwLineasComentarios:Select( 0 ), oBrwLineasComentarios:GoUp(), oBrwLineasComentarios:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         ID       181 ;
         OF       oDlgComentarios ;
         BITMAP   "gc_arrow_down_32" ;
         ACTION   ( oBrwLineasComentarios:Select( 0 ), oBrwLineasComentarios:GoDown(), oBrwLineasComentarios:Select( 1 ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "gc_check_32" ;
         ID       IDOK ;
         OF       oDlgComentarios ;
         ACTION   ( ::EndComentarios( oDlgComentarios, oGetComentario ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       oDlgComentarios ;
         ACTION   ( oDlgComentarios:End() )

      oBrwComentarios                        := IXBrowse():New( oDlgComentarios )

      oBrwComentarios:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwComentarios:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      oBrwComentarios:nMarqueeStyle          := MARQSTYLE_HIGHLROW
      oBrwComentarios:cName                  := "Comentarios de artículos"
      oBrwComentarios:nRowHeight             := 45
      oBrwComentarios:lHeader                := .f.
      oBrwComentarios:lHScroll               := .f.

      oBrwComentarios:SetFont( ::oFntBrw )

      oBrwComentarios:CreateFromResource( 100 )

      ::oComentariosCabecera:SetBrowse( oBrwComentarios )

      oBrwComentarios:bChange                := {|| ::ChangeComentarios( oBrwLineasComentarios ) }

      with object ( oBrwComentarios:AddCol() )
         :bEditValue                         := {|| ::oComentariosCabecera:cDescri }
      end with

      oBrwLineasComentarios                  := IXBrowse():New( oDlgComentarios )

      oBrwLineasComentarios:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLineasComentarios:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      oBrwLineasComentarios:nMarqueeStyle    := MARQSTYLE_HIGHLROW
      oBrwLineasComentarios:cName            := "Lineas comentarios de artículos"
      oBrwLineasComentarios:lHeader          := .f.
      oBrwLineasComentarios:lHScroll         := .f.
      oBrwLineasComentarios:nRowHeight       := 45
      
      oBrwLineasComentarios:SetFont( ::oFntBrw )

      oBrwLineasComentarios:CreateFromResource( 110 )

      ::oComentariosLinea:SetBrowse( oBrwLineasComentarios )

      with object ( oBrwLineasComentarios:AddCol() )
         :bEditValue                         := {|| ::oComentariosLinea:cDescri }
      end with

      oBrwLineasComentarios:bLClicked        := {|| ::ChangeLineasComentarios( oGetComentario ) }

      oDlgComentarios:bStart                 := {|| ::SeleccionarDefecto( cComentarioFamilia, oBrwLineasComentarios, oBrwComentarios ) }

   ACTIVATE DIALOG oDlgComentarios CENTER

   ::oBrwLineas:Refresh()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD EndComentarios( oDlg, oGetComentario ) CLASS TpvTactil

   local cText                := Alltrim( oGetComentario:VarGet() )

   ::oTemporalLinea:FieldPutByName( "cComent", cText )

   oDlg:End( IDOK )

Return ( nil )

//---------------------------------------------------------------------------//

/*METHOD EndPropiedadArticulo( oDlg ) CLASS TpvTactil

   local nPrecio                := Alltrim( oGetComentario:VarGet() )

   ::oTemporalLinea:FieldPutByName( "nPvpTil", nPrecio )

   oDlg:End( IDOK )

Return ( nil )*/

//---------------------------------------------------------------------------//

METHOD ChangeComentarios( oBrwLineasComentarios ) CLASS TpvTactil

   ::oComentariosLinea:OrdScope( ::oComentariosCabecera:cCodigo )

   oBrwLineasComentarios:GoTop()
   oBrwLineasComentarios:Refresh( .t. )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD ChangeLineasComentarios( oGetComentario ) CLASS TpvTactil

   local cText    := AllTrim( oGetComentario:VarGet() )

   /*
   Si hay un comentario añadido el siguiente se inserta despues de una ,-------
   */

   if Empty( cText )
      cText       := AllTrim( ::oComentariosLinea:cDescri )
   else
      cText       += ", " + AllTrim( ::oComentariosLinea:cDescri )
   end if

   oGetComentario:cText( Padr( cText, 250 ) )

   oGetComentario:Refresh()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD SeleccionarDefecto( cComentarioFamilia, oBrwLineasComentarios, oBrwComentarios ) CLASS TpvTactil

   if !Empty( cComentarioFamilia )

      if ::oComentariosCabecera:SeekinOrd( cComentarioFamilia, "cCodigo" )

         oBrwComentarios:Select( 0 )
         oBrwComentarios:Select( 1 )

         ::ChangeComentarios( oBrwLineasComentarios )

      end if

   end if

return .t.

//---------------------------------------------------------------------------//

METHOD OnClickInvitacion() CLASS TpvTactil

   local oDlg

   if !::lEditableDocumento()
      MsgStop( "El documento ya está cerrado" )
      RETURN ( .t. )
   end if

   /*
   Definimos el dialogo para las invitaciones----------------------------------
   */

   ::cCodigoInvitacion              := ""
   ::cTextoInvitacion               := Space( 30 )

   DEFINE DIALOG oDlg RESOURCE "INV_TCT"

      ::oBtnTodasLineas             := ApoloBtnBmp():ReDefine( 100, "gc_table_selection_all_32", , , , , {|| ::SelectTodasLineasInvitacion() }, oDlg, .f., , .f., .f., "", , , , .t., "TOP", .t., , , .f. )
      ::oBtnUnaLinea                := ApoloBtnBmp():ReDefine( 110, "gc_table_selection_row_32", , , , ,     {|| ::SelectUnaLineaInvitacion() },    oDlg, .f., , .f., .f., "", , , , .t., "TOP", .t., , , .f. )

      ::oImageListInvitacion        := TImageList():New( 48, 48 )

      ::oListViewInvitacion         := TListView():Redefine( 120, oDlg )
      ::oListViewInvitacion:nOption := 0
      ::oListViewInvitacion:bClick  := {| nOpt | ::SelectInvitacion( nOpt ) }

      REDEFINE GET      ::oTextoInvitacion ;
         VAR            ::cTextoInvitacion ;
         ID             130 ;
         OF             oDlg

      REDEFINE BUTTONBMP ;
         ID             131 ;
         OF             oDlg ;
         BITMAP         "gc_keyboard_32" ;
         ACTION         ( VirtualKey( .f., ::oTextoInvitacion ) )

      REDEFINE BUTTONBMP ;
         ID             540 ;
         OF             oDlg ;
         BITMAP         "gc_check_32" ;
         ACTION         ( ::EndInvitacion( oDlg ) )

      REDEFINE BUTTONBMP ;
         ID             550 ;
         OF             oDlg ;
         BITMAP         "Delete_32" ;
         ACTION         ( oDlg:End() )

      oDlg:bStart       := {|| ::InitInvitacion( oDlg ) }

   ACTIVATE DIALOG oDlg CENTER

   if !Empty( ::oImageListInvitacion )
      ::oImageListInvitacion:end()
   end if

   if !Empty( ::oListViewInvitacion )
      ::oListViewInvitacion:end()
   end if

   if !Empty( ::oBrwLineas )
      ::oBrwLineas:Refresh()
   end if

   ::SetTotal()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD InitInvitacion( oDlg ) CLASS TpvTactil

   local nInvi := 0
   local oItem

   if !Empty( ::oImageListInvitacion ) .and. !Empty( ::oListViewInvitacion ) .and. !Empty( ::oInvitacion )

      ::oListViewInvitacion:SetImageList( ::oImageListInvitacion )
      ::oListViewInvitacion:EnableGroupView()
      ::oListViewInvitacion:InsertGroup( "Invitaciones" )

      ::oInvitacion:oDbf:GoTop()

      while !::oInvitacion:oDbf:Eof()

         ::oImageListInvitacion:AddMasked( TBitmap():Define( ::oInvitacion:cBigResource() ), Rgb( 255, 0, 255 ) )

         oItem                := TListViewItem():New( ::oListViewInvitacion )
         oItem:cText          := Capitalize( ::oInvitacion:oDbf:cNomInv )
         oItem:nGroup         := 0
         oItem:nImage         := nInvi
         oItem:Cargo          := ::oInvitacion:oDbf:cCodInv
         oItem:Create()

         ::oInvitacion:oDbf:Skip()

         nInvi++

      end while

   end if

   ::oListViewInvitacion:Refresh()

   ::oBtnUnaLinea:GoDown()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD SelectUnaLineaInvitacion() CLASS TpvTactil

   ::oBtnTodasLineas:GoUp()
   ::oBtnUnaLinea:GoDown()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD SelectTodasLineasInvitacion() CLASS TpvTactil

   ::oBtnUnaLinea:GoUp()
   ::oBtnTodasLineas:GoDown()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD SelectInvitacion( nOpt ) CLASS TpvTactil

   if !Empty( nOpt ) .and. ::oInvitacion:oDbf:OrdKeyGoTo( nOpt )

      ::cCodigoInvitacion           := ::oInvitacion:oDbf:cCodInv

      ::oTextoInvitacion:cText( ::oInvitacion:oDbf:cNomInv )

   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD EndInvitacion( oDlg ) CLASS TpvTactil

   /*
   Si no selecionamos la invitacion aparece este mensaje, si lo hacemos vamos al else
   */

   if Empty( ::cCodigoInvitacion )
      msgStop( "Debe seleccionar un código de invitación." )
      return nil
   end if 


   if Empty( ::cTextoInvitacion )
      msgStop( "Debe seleccionar un motivo o texto valido." )
      return nil
   end if 

   if ::oBtnUnaLinea:lBtnDown

      ::oTemporalLinea:nPvpTil         := ::oInvitacion:nPrecioInvitacion( ::cCodigoInvitacion )
      ::oTemporalLinea:nPcmTil         := 0
      ::oTemporalLinea:cCodInv         := ::cCodigoInvitacion
      ::oTemporalLinea:cTxtInv         := ::cTextoInvitacion
     
   end if 

   if ::oBtnTodasLineas:lBtnDown
     
      CursorWait()
     
      ::oTemporalLinea:GetStatus()

      ::oTemporalLinea:GoTop()
      while !::oTemporalLinea:Eof()

         ::oTemporalLinea:nPvpTil      := ::oInvitacion:nPrecioInvitacion( ::cCodigoInvitacion )
         ::oTemporalLinea:nPcmTil      := 0
         ::oTemporalLinea:cCodInv      := ::cCodigoInvitacion
         ::oTemporalLinea:cTxtInv      := ::cTextoInvitacion

         ::oTemporalLinea:Skip()

      end while
        
      ::oTemporalLinea:SetStatus()
        
      CursorWE()

   end if

   oDlg:End( IDOK )

return ( .t. )

//---------------------------------------------------------------------------//

METHOD OnClickDescuento() CLASS TpvTactil

   local oDlg
   local nRec
   local oGetPorcentaje
   local nGetPorcentaje := 10

   if !::lEditableDocumento()
      MsgStop( "El documento ya está cerrado" )
      RETURN ( .t. )
   end if

   /*
   Definimos el dialogo para el descuento--------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "DTO_TCT"

      ::oBtnUnaLinea      := ApoloBtnBmp():ReDefine( 100, "gc_table_selection_row_32",,,,,    {|| ::oBtnUnaLinea:GoDown(), ::oBtnTodasLineas:GoUp() }, oDlg, .f., , .f., .f., "", , , , .t., "TOP", .t., , , .f. )
      ::oBtnTodasLineas   := ApoloBtnBmp():ReDefine( 110, "gc_table_selection_all_32",,,,,{|| ::oBtnUnaLinea:GoUp(), ::oBtnTodasLineas:GoDown() }, oDlg, .f., , .f., .f., "", , , , .t., "TOP", .t., , , .f. )

      REDEFINE BUTTON ;
         ID       200 ;
         OF       oDlg ;
         ACTION   ( oGetPorcentaje:cText( 10 ) )

      REDEFINE BUTTON ;
         ID       210 ;
         OF       oDlg ;
         ACTION   ( oGetPorcentaje:cText( 20 ) )

      REDEFINE BUTTON ;
         ID       220 ;
         OF       oDlg ;
         ACTION   ( oGetPorcentaje:cText( 30 ) )

      REDEFINE BUTTON ;
         ID       230 ;
         OF       oDlg ;
         ACTION   ( oGetPorcentaje:cText( 40 ) )

      REDEFINE BUTTON ;
         ID       240 ;
         OF       oDlg ;
         ACTION   ( oGetPorcentaje:cText( 50 ) )

      REDEFINE BUTTONBMP ;
         ID       300 ;
         OF       oDlg ;
         BITMAP   "gc_navigate_plus_32" ;
         ACTION   ( oGetPorcentaje++ )

      REDEFINE BUTTONBMP ;
         ID       310 ;
         OF       oDlg ;
         BITMAP   "gc_navigate_minus_32" ;
         ACTION   ( oGetPorcentaje-- )

      REDEFINE GET oGetPorcentaje ;
         VAR      nGetPorcentaje ;
         ID       320 ;
         SPINNER ;
         MIN      0 ;
         MAX      100 ;
         PICTURE  "@E 999.99";
         OF       oDlg ;

      oGetPorcentaje:SetFont( ::oFntDto )

      REDEFINE BUTTONBMP ;
         BITMAP   "gc_check_32" ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:End( IDOK ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      oDlg:bStart := {|| ::oBtnUnaLinea:GoDown() }

   ACTIVATE DIALOG oDlg CENTER

   /*
   Si pulsamos el boton de Ok nos calcula el descuento
   */

   if oDlg:nResult == IDOK

      CursorWait()

      if ::oBtnUnaLinea:lPressed

         ::oTemporalLinea:nDtoLin := nGetPorcentaje

      else

         nRec     := ::oTemporalLinea:Recno()

         ::oTemporalLinea:GoTop()
         while !::oTemporalLinea:Eof()
            ::oTemporalLinea:nDtoLin := nGetPorcentaje
            ::oTemporalLinea:Skip()
         end while

         ::oTemporalLinea:GoTo( nRec )

      end if

      CursorWE()

   end if

   ::SetTotal()   

   if !Empty( ::oBrwLineas )
      ::oBrwLineas:Refresh()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

METHOD SelecionaCliente() CLASS TpvTactil

   local cCliente
   local nTarifaSolo
   local nTarifaCombinado

   do case
      case ::oTiketCabecera:nUbiTik == ubiLlevar
         cCliente    := BrwCliTactil( nil, nil, nil, .t., "Selecione un cliente para llevar", "gc_motor_scooter_48" )
      case ::oTiketCabecera:nUbiTik == ubiEncargar
         cCliente    := BrwCliTactil( nil, nil, nil, .t., "Selecione un cliente para encargar", "gc_address_book_48" )
      otherwise
         cCliente    := BrwCliTactil( nil, nil, nil, .t. )
   end case

   // Si selecionamos un cliente que no este vacio nos inserta sus datos en el TPV

   if !Empty( cCliente )

      ::oTiketCabecera:cCliTik      := cCliente
      ::oTiketCabecera:cNomTik      := oRetFld( cCliente, ::oCliente, "Titulo" )
      ::oTiketCabecera:cDirCli      := oRetFld( cCliente, ::oCliente, "Domicilio" )
      ::oTiketCabecera:cPobCli      := oRetFld( cCliente, ::oCliente, "Poblacion" )
      ::oTiketCabecera:cPrvCli      := oRetFld( cCliente, ::oCliente, "Provincia" )
      ::oTiketCabecera:cPosCli      := oRetFld( cCliente, ::oCliente, "CodPostal" )
      ::oTiketCabecera:cDniCli      := oRetFld( cCliente, ::oCliente, "Nif" )
      ::oTiketCabecera:nTarifa      := Max( oRetFld( cCliente, ::oCliente, "nTarifa" ), 1 )

      //Serie del cliente------------------------------------------------------

      if !Empty( oRetFld( cCliente, ::oCliente, "Serie" ) ) 
         ::oTiketCabecera:cSerTik   := oRetFld( cCliente, ::oCliente, "Serie" )
      end if

      // Formas de pago--------------------------------------------------------

      if Empty( oRetFld( cCliente, ::oCliente, "CodPago" ) )
         ::oTiketCabecera:cFpgTik   := cDefFpg()
      else
         ::oTiketCabecera:cFpgTik   := oRetFld( cCliente, ::oCliente, "CodPago" )
      end if

      ::SetCliente()

      // Datos de la serie-----------------------------------------------------

      ::SetSerie()

      // Situamos las tarifas--------------------------------------------------
      /*
      nTarifaSolo                   := Max( oRetFld( cCliente, ::oCliente, "nTarifa" ), 1 ) // ::nTarifaSolo
      nTarifaCombinado              := Max( oRetFld( cCliente, ::oCliente, "nTarCmb" ), 1 ) // ::nTarifaCombinado

      if ( nTarifaSolo != ::nTarifaSolo .or. nTarifaCombinado != ::nTarifaCombinado )

         ::SetTarifaSolo( nTarifaSolo )      

         ::SetTarifaCombinado( nTarifaCombinado )

         // Comprobamos que han cambiado la tarifa del cliente-----------------
      
         if ( ::oTemporalLinea:RecCount() != 0 ) .and. ;
            ApoloMsgNoYes( "La tarifa del cliente ha cambiado, ¿desea actualizar los precios de todas las líneas?",;
                           "Confirmación", .t. )

            ::ActualizaTarifaCliente()

         end if
      end if   
      */

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD ActualizaTarifaCliente() CLASS TpvTactil

   ::oTemporalLinea:GetStatus()

   ::oTemporalLinea:GoTop()

   while !::oTemporalLinea:Eof()

      if !Empty( ::oTemporalLinea:cComTil )

         ::oTemporalLinea:Load()

         ::oTemporalLinea:nPvpTil   := cRetPreArt( ::oTemporalLinea:cCbaTil, ::nTarifaCombinado, cDivEmp(), .t., ::oArticulo:cAlias, ::oDivisas:cAlias, ::oArticulosEscandallos:cAlias, ::oTipoIVA:cAlias )
         ::oTemporalLinea:nPcmTil   := cRetPreArt( ::oTemporalLinea:cComTil, ::nTarifaCombinado, cDivEmp(), .t., ::oArticulo:cAlias, ::oDivisas:cAlias, ::oArticulosEscandallos:cAlias, ::oTipoIVA:cAlias )

         ::oTemporalLinea:Save()

      else

         ::oTemporalLinea:Load()
         ::oTemporalLinea:nPvpTil   := cRetPreArt( ::oTemporalLinea:cCbaTil, ::nTarifaSolo, cDivEmp(), .t., ::oArticulo:cAlias, ::oDivisas:cAlias, ::oArticulosEscandallos:cAlias, ::oTipoIVA:cAlias )
         ::oTemporalLinea:Save()

      end if

      ::oTemporalLinea:Skip()
      
   end while

   ::oTemporalLinea:SetStatus()

   ::SetTotal()

   ::oBrwLineas:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetCliente() CLASS TpvTactil

   local uValor

   if !Empty( ::oBtnCliente )

      uValor         := AllTrim( oRetFld( ::oTiketCabecera:cCliTik, ::oCliente, "Titulo" ) )

      ::oBtnCliente:cCaption( if( !Empty( uValor ), uValor, "..." ) )
      ::oBtnCliente:Refresh()

   end if

   if !Empty( ::oBtnDireccion )

      uValor         := AllTrim( oRetFld( ::oTiketCabecera:cCliTik, ::oCliente, "Domicilio" ) )

      ::oBtnDireccion:cCaption( if( !Empty( uValor ), uValor, "..." ) )

   end if

   if !Empty( ::oBtnTelefono )

      uValor         := AllTrim( oRetFld( ::oTiketCabecera:cCliTik, ::oCliente, "Telefono" ) ) + Space( 1 ) + AllTrim( oRetFld( ::oTiketCabecera:cCliTik, ::oCliente, "cMeiInt" ) )

      ::oBtnTelefono:cCaption( if( !Empty( uValor ), uValor, "..." ) )

   end if

Return nil

//---------------------------------------------------------------------------//

METHOD SetSerie() Class TpvTactil

   if !Empty( ::oGrpSeries )
      ::oGrpSeries:cPrompt  := "Serie: " + ::oTiketCabecera:cSerTik
   end if   

Return nil

//---------------------------------------------------------------------------//

METHOD SetTarifaSolo( nPrecio ) CLASS TpvTactil

   DEFAULT nPrecio   := ::nTarifaSolo

   ::nTarifaSolo     := nPrecio

   if !empty( ::oBtnTarifaSolo )
      ::oBtnTarifaSolo:cCaption( "Precio solo : " + ::cTextoTarifa( nPrecio ) )
      ::oBtnTarifaSolo:Refresh()
   end if

Return nil

//---------------------------------------------------------------------------//

METHOD SetTarifaCombinado( nPrecio ) CLASS TpvTactil

   DEFAULT nPrecio      := ::nTarifaCombinado

   ::nTarifaCombinado   := nPrecio

   if !empty( ::oBtnTarifaCombinado )
      ::oBtnTarifaCombinado:cCaption( "Precio combinado : " +::cTextoTarifa( nPrecio ) )
      ::oBtnTarifaCombinado:Refresh()
   end if

Return nil 

//---------------------------------------------------------------------------//

METHOD OnClickUsuarios() CLASS TpvTactil

   local oError
   local oBlock
   local lReturn           := .t.
   local lGuardaDocumento  := .t.

   // Si el documento es nuevo y no tiene lineas no lo guardo---------------------

   if !::lValidatePreSave()
      lGuardaDocumento     := .f.
   end if

   // Vamos a detectar si estoy en un General------------------------------------

   if ::lEmptyAlias()
      if ::SetAliasDocumento()
         lGuardaDocumento  := .t.
      else
         Return ( .t. )
      end if
   end if

   /*
   Si el docmuento no es nuevo y no tiene lineas lo tengo q borrar-------------

   if ::lEmptyLineas()
      ::EliminarDocumento( ::cNumeroTicket() )
      lGuardaDocumento     := .f.
   end if
   */

   ::DisableDialog()

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   // Guarda la venta actual------------------------------------------------------

   if ( !lGuardaDocumento .or. ::GuardaDocumentoPendiente() )

      // Recoger usuario----------------------------------------------------------

      if ::GetUsuario( .t. )

         // Inicializa los valores para un nuevo documento General---------------

         ::InitDocumento( ubiGeneral )

      end if

   end if

   RECOVER USING oError

      msgStop( "Error al montar la salas de venta" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::EnableDialog()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD sTotalTiket() CLASS TpvTactil

   local uTotal
   local nTotal            := 0

   local bCond
   local nRecLin
   local cCodDiv
   local nVdvDiv
   local cTipTik
   local nTotLin           := 0
   local nBasLin           := 0
   local nBrtLin           := 0
   local nIvmLin           := 0
   local nComensales       := 0
   local nDtoEsp           := 0
   local nDpp              := 0
   local nDescuento        := 0

   ::sTotal                := sTotal()

   cCodDiv                 := ::oTiketCabecera:cDivTik
   nVdvDiv                 := ::oTiketCabecera:nVdvTik
   cTipTik                 := ::oTiketCabecera:cTipTik
   nComensales             := ::oTiketCabecera:nNumCom
   nDtoEsp                 := ::oTiketCabecera:nDtoEsp
   nDpp                    := ::oTiketCabecera:nDpp

   nRecLin                 := ::oTemporalLinea:Recno()

   ::oTemporalLinea:GoTop()
   while !( ::oTemporalLinea:eof() )

      if ::lLineaValida( ::oTemporalLinea )

         nTotLin           := ::nTotalLinea( ::oTemporalLinea )
         nDescuento        := ::nTotalDescuento( ::oTemporalLinea )

         nBasLin           := nTotLin

         nIvmLin           := ::nTotalImpuestosEspeciales( ::oTemporalLinea )

         if ::oTemporalLinea:nIvaTil != 0
            nBasLin        := nTotLin / ( 1 + ( ::oTemporalLinea:nIvaTil / 100 ) )
         else
            nBasLin        := nTotLin
         end if
         
         ::sTotal:nTotalCosto                            += ::oTemporalLinea:nCosDiv

         do case
            case ::sTotal:aPorcentajeIva[ 1 ] == nil .or. ::sTotal:aPorcentajeIva[ 1 ] == ::oTemporalLinea:nIvaTil

               ::sTotal:aPorcentajeIva[ 1 ]              := ::oTemporalLinea:nIvaTil
               ::sTotal:aTotalBruto[ 1 ]                 += nTotLin
               ::sTotal:aTotalBase[ 1 ]                  += nBasLin
               ::sTotal:aIvaTik[ 1 ]                     += ( nTotLin - nBasLin )
               ::sTotal:aTotalImpuestoHidrocarburos[ 1 ] += nIvmLin

            case ::sTotal:aPorcentajeIva[ 2 ] == nil .or. ::sTotal:aPorcentajeIva[ 2 ] == ::oTemporalLinea:nIvaTil

               ::sTotal:aPorcentajeIva[ 2 ]              := ::oTemporalLinea:nIvaTil
               ::sTotal:aTotalBruto[ 2 ]                 += nTotLin
               ::sTotal:aTotalBase[ 2 ]                  += nBasLin
               ::sTotal:aIvaTik[ 2 ]                     += ( nTotLin - nBasLin )
               ::sTotal:aTotalImpuestoHidrocarburos[ 2 ] += nIvmLin

            case ::sTotal:aPorcentajeIva[ 3 ] == nil .or. ::sTotal:aPorcentajeIva[ 3 ] == ::oTemporalLinea:nIvaTil

               ::sTotal:aPorcentajeIva[ 3 ]              := ::oTemporalLinea:nIvaTil
               ::sTotal:aTotalBruto[ 3 ]                 += nTotLin
               ::sTotal:aTotalBase[ 3 ]                  += nBasLin
               ::sTotal:aIvaTik[ 3 ]                     += ( nTotLin - nBasLin )
               ::sTotal:aTotalImpuestoHidrocarburos[ 3 ] += nIvmLin

         end case

         ::sTotal:nTotalDocumento                        += nTotLin
         ::sTotal:nTotalDescuentoGeneral                 += nDescuento

         if ::oTemporalLinea:lInPromo
            ::sTotal:nPromocion                          += nTotLin - nDescuento
         end if

      end if

      ::oTemporalLinea:Skip()

   end while

   /*
   Total por persona-----------------------------------------------------------
   */

   if !Empty( nComensales )
      ::sTotal:nTotalPersona                             := ::sTotal:nTotalDocumento / NotCero( nComensales )
   else
      ::sTotal:nTotalPersona                             := 0
   end if

   /*
   Reposicionamiento-----------------------------------------------------------
   */

   ::oTemporalLinea:GoTo( nRecLin )

   /*
   Calculo de pagos------------------------------------------------------------
   */

   // ::sTotal:nCobrado    := ::oTpvCobros:nTotalCobro()
   // ::sTotal:nCambio     := ::oTpvCobros:nTotalCambio()

Return ( ::sTotal )

//---------------------------------------------------------------------------//

Method lLineaValida( uTmpL, lExcluirContadores ) CLASS TpvTactil

   local lLineaValida   := .t.

   DEFAULT uTmpL        := ::oTiketLinea

   /*
   Si es una linea de control o la hemos marcado-------------------------------
   */

   if uTmpL:lControl .or. uTmpL:lDelTil
      Return .f.
   end if

   if uTmpL:lKitArt .or. uTmpL:lKitChl
      lLineaValida      := uTmpL:lKitPrc
   end if

   if !IsNil( lExcluirContadores )
      lLineaValida      := lLineaValida .and. ( ( lExcluirContadores .and. uTmpL:nCtlStk != 2 ) .or. ( !lExcluirContadores .and. uTmpL:nCtlStk == 2 ) )
   end if 

Return ( lLineaValida )

//---------------------------------------------------------------------------//

/*
Devuelve las unidades de una linea
*/

METHOD nUnidadesLinea( uTmpL, lPicture ) CLASS TpvTactil

   local nUnidadesLinea    := 0

   DEFAULT uTmpL           := ::oTiketLinea
   DEFAULT lPicture        := .f.

   if Empty( uTmpL )
      Return ( nUnidadesLinea )
   end if

   nUnidadesLinea          := uTmpL:nUntTil
   nUnidadesLinea          *= NotCero( uTmpL:nUndKit )

RETURN ( if( lPicture, Trans( nUnidadesLinea, ::cPictureUnidades ), nUnidadesLinea ) )

//---------------------------------------------------------------------------//

METHOD nUnidadesLineaTemp( uTmpL, lPicture ) CLASS TpvTactil

   local nUnidadesLinea    := 0

   DEFAULT uTmpL           := ::oTemporalImpresionLinea
   DEFAULT lPicture        := .f.

   if Empty( uTmpL )
      Return ( nUnidadesLinea )
   end if

   nUnidadesLinea          := uTmpL:nUntTil
   nUnidadesLinea          *= NotCero( uTmpL:nUndKit )

RETURN ( if( lPicture, Trans( nUnidadesLinea, ::cPictureUnidades ), nUnidadesLinea ) )

//---------------------------------------------------------------------------//

METHOD nUnidadesImpresas( uTmpL, lPicture ) CLASS TpvTactil

   local nUnidadesLinea

   DEFAULT uTmpL     := ::oTiketLinea
   DEFAULT lPicture  := .f.

   nUnidadesLinea    := uTmpL:nImpCom

RETURN ( if( lPicture, Trans( nUnidadesLinea, ::cPictureUnidades ), nUnidadesLinea ) )

//---------------------------------------------------------------------------//

METHOD nTotalLinea( uTmpL, lPicture ) CLASS TpvTactil

   local nTotalLinea

   DEFAULT uTmpL     := ::oTiketLinea
   DEFAULT lPicture  := .f.

   nTotalLinea       := ::nTotalLineaUno( uTmpL )
   nTotalLinea       += ::nTotalLineaDos( uTmpL )

RETURN ( if( lPicture, Trans( nTotalLinea, ::cPictureTotal ), nTotalLinea ) )

//---------------------------------------------------------------------------//

METHOD nTotalLineaTemp( uTmpL, lPicture ) CLASS TpvTactil

   local nTotalLinea

   DEFAULT uTmpL     := ::oTemporalImpresionLinea
   DEFAULT lPicture  := .f.

   nTotalLinea       := ::nTotalLineaUno( uTmpL )
   nTotalLinea       += ::nTotalLineaDos( uTmpL )

RETURN ( if( lPicture, Trans( nTotalLinea, ::cPictureTotal ), nTotalLinea ) )

//---------------------------------------------------------------------------//

METHOD nTotalLineaUno( uTmpL, nVdv ) CLASS TpvTactil

   local nCalculo    := 0

   DEFAULT uTmpL     := ::oTemporalLinea
   DEFAULT nVdv      := 0

   if !uTmpL:lFreTil
      
      nCalculo       := Round( uTmpL:nPvpTil, ::nDecimalesImporte )   // Precio

      if uTmpL:nDtoLin != 0
         nCalculo    -= uTmpL:nDtoLin * nCalculo / 100      // Dto porcentual
      end if

      nCalculo       *= ::nUnidadesLinea( uTmpL )           // Unidades

   end if

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, ::nDecimalesTotal ) )

//---------------------------------------------------------------------------//

METHOD nTotalLineaDos( uTmpL, nVdv ) CLASS TpvTactil

   local nCalculo    := 0

   DEFAULT uTmpL     := ::oTemporalLinea
   DEFAULT nVdv      := 0

   if !uTmpL:lFreTil

      nCalculo       := Round( uTmpL:nPcmTil, ::nDecimalesImporte )   // Precio

      if uTmpL:nDtoLin != 0
         nCalculo    -= uTmpL:nDtoLin * nCalculo / 100      // Dto porcentual
      end if

      nCalculo       *= ::nUnidadesLinea( uTmpL )           // Unidades
   
   end if

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, ::nDecimalesTotal ) )

//---------------------------------------------------------------------------//

METHOD nTotalDescuento( uTmpL, lPicture ) CLASS TpvTactil

   local nTotalDescuento

   DEFAULT uTmpL     := ::oTiketLinea
   DEFAULT lPicture  := .f.

   nTotalDescuento   := ::nTotalDescuentoUno( uTmpL )
   nTotalDescuento   += ::nTotalDescuentoDos( uTmpL )

RETURN ( if( lPicture, Trans( nTotalDescuento, ::cPictureTotal ), nTotalDescuento ) )

//---------------------------------------------------------------------------//

METHOD nTotalDescuentoUno( uTmpL, nVdv ) CLASS TpvTactil

   local nCalculo    := 0

   DEFAULT uTmpL     := ::oTemporalLinea
   DEFAULT nVdv      := 0

   if !uTmpL:lFreTil .and. uTmpL:nDtoLin != 0
      nCalculo       := uTmpL:nDtoLin * Round( uTmpL:nPvpTil, ::nDecimalesImporte ) / 100      // Dto porcentual
      nCalculo       *= ::nUnidadesLinea( uTmpL )           // Unidades
   end if

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, ::nDecimalesTotal ) )

//---------------------------------------------------------------------------//

METHOD nTotalDescuentoDos( uTmpL, nVdv ) CLASS TpvTactil

   local nCalculo    := 0

   DEFAULT uTmpL     := ::oTemporalLinea
   DEFAULT nVdv      := 0

   if !uTmpL:lFreTil .and. uTmpL:nDtoLin != 0
      nCalculo       := uTmpL:nDtoLin * Round( uTmpL:nPcmTil, ::nDecimalesImporte ) / 100      // Dto porcentual
      nCalculo       *= ::nUnidadesLinea( uTmpL )           // Unidades
   end if

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, ::nDecimalesTotal ) )

//---------------------------------------------------------------------------//

METHOD nTotalImpuestosEspeciales( uTmpL, nVdv ) CLASS TpvTactil

   local nCalculo    := 0

   DEFAULT uTmpL     := ::oTemporalLinea
   DEFAULT nVdv      := 0

   /*
   Siempre q el ticket no sea gratis-------------------------------------------
   */

   if !uTmpL:lFreTil
      nCalculo       := uTmpL:nValImp                       // Importe del nuevo impuesto
      nCalculo       *= ::nUnidadesLinea( uTmpL )           // Unidades
   end if

   if nVdv != 0
      nCalculo       := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, ::nDecimalesTotal ) )

//---------------------------------------------------------------------------//

METHOD cDetalleComanda() CLASS TpvTactil

Return ( ::cDescripcionComanda() + ::cComentarioComanda() )

//---------------------------------------------------------------------------//

METHOD cDescripcionComanda() CLASS TpvTactil

   local cReturn     := ""

   if Empty( ::oTemporalComanda )
      Return ( cReturn )
   end if

   if !Empty( ::oTemporalComanda:cNomCmd )
      cReturn        := alltrim( ::oTemporalComanda:cNomCmd )
   else
      cReturn        := alltrim( ::oTemporalComanda:cNomTil )
   end if

   if !Empty( ::oTemporalComanda:cNcmTil )
      cReturn        += " con " + alltrim( ::oTemporalComanda:cNcmTil )
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//

METHOD cComentarioComanda() CLASS TpvTactil

   local cReturn     := ""

   if !Empty( ::oTemporalComanda:cComent )
      cReturn        += "[*]" + space( 1 ) + alltrim( ::oTemporalComanda:cComent )
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//

METHOD nTotalCobrosTemporales()

   local nTotalCobrosTemporales  := 0

   ::oTemporalCobro:GetStatus()

   ::oTemporalCobro:GoTop()
   while !::oTemporalCobro:Eof()
      nTotalCobrosTemporales     += ::oTemporalCobro:nImpTik
      ::oTemporalCobro:Skip()
   end while

   ::oTemporalCobro:SetStatus()

RETURN ( nTotalCobrosTemporales )

//---------------------------------------------------------------------------//

METHOD sTotalCobros( cNumero )

   local sTotalCobros            := sTotalCobros()

   DEFAULT cNumero               := ::oTiketCabacera:cSerTik + ::oTiketCabacera:cNumTik + ::oTiketCabacera:cSufTik

   ::oTiketCobro:Seek( cNumero )
   while ::oTiketCobro:cSerTik + ::oTiketCobro:cNumTik + ::oTiketCobro:cSufTik .and. !::oTiketCobro:Eof()
      sTotalCobros:Load( ::oTiketCobro )
      ::oTiketCobro:Skip()
   end while

RETURN ( sTotalCobros )

//---------------------------------------------------------------------------//

METHOD OnClickCobro() CLASS TpvTactil

   if Empty( ::oTemporalLinea ) .or. Empty( ::oTemporalLinea:RecCount() )
      MsgStop( "No puede almacenar un documento sin línea." )
      Return .f.
   end if

   if oUser():lNotCobrarTPV()
      MsgStop( "El usuario no esta autorizado para cobrar tickes." )
      Return .f.
   end if

   if ::isArticulosSinPeso()
      msgStop( "Existen artículos por peso sin valor." )
      Return .f.
   end if 

   ::SetTotal()   

   if !Empty( ::oBrwLineas )
      ::oBrwLineas:Refresh()
   end if

   ::DisableDialog()

   ::nTipoDocumento := documentoTicket

   if ::oTpvCobros:lCobro()

      // set documento---------------------------------------------------------

      ::SetDocumentoPagado()

      // Guarda documento------------------------------------------------------

      ::GuardaDocumento()

      // Guardamos los cobros--------------------------------------------------

      ::GuardaCobros()

      // Envia las comandas a impresoras---------------------------------------

      ::ProcesaDocumentosInternos()

      // Generar vale----------------------------------------------------------

      ::GeneraVale()

      // Pintamos en la pizarra el ultimo cambio-------------------------------

      ::UltimoCambio()

      // Imprimimos en el visor------------------------------------------------

      ::EscribeVisor()

      // Abrimos el cajón portamonedas antes de imprimir-----------------------

      ::OpenCajon()

      // Imprimimos el documento-----------------------------------------------

      ::ImprimePago()

      // Inicializa los valores para el documento------------------------------

      ::InitDocumento( ubiGeneral )

      // Datos de la ubicacion-------------------------------------------------

      ::SetUbicacion()

      // Datos del documento---------------------------------------------------

      ::SetInfo()
      
      ::SetCliente()
      
      ::SetSerie()

      // Recoger usuario-------------------------------------------------------

      ::GetUsuario()

      // Volver a la sala de venta---------------------------------------------

      ::GetUbicacion()

   end if

   ::EnableDialog()

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickAlbaran() CLASS TpvTactil

   if Empty( ::oTemporalLinea ) .or. Empty( ::oTemporalLinea:RecCount() )
      MsgStop( "No puede almacenar un documento sin línea" )
      Return .f.
   end if 

   if Empty( ::oTiketCabecera:cCliTik )
      MsgStop( "Para generar un albarán necesita seleccionar un cliente.", "Información" )
      Return .f.
   end if

   ::nTipoDocumento := documentoAlbaran

   ::DisableDialog()

   if ::oTpvCobros:lCobro()

      /*
      Guarda documento--------------------------------------------------------
      */

      ::GuardaDocumentoAlbaran()

      /*
      Abrimos el cajón portamonedas antes de imprimir-----------------------
      */

      if ( ::oTpvCobros:Entregado() != 0 )
         ::OpenCajon()
      end if

      /*
      Vaciamos las lineas------------------------------------------------------
      */

      ::oTemporalLinea:Zap()

      /*
      Refrescamos las lineas---------------------------------------------------
      */

      ::oBrwLineas:Refresh()

      /*
      Barra de progreso vuelve a su estado----------------------------------------
      */

      ::oProgressBar:Set( 0 )
      ::oProgressBar:Refresh()

      /*
      Encendemos el flag para cargar de nuevo el usuario--------------------------
      */

      ::lGetUsuario                 := .t.

      /*
      Imprimimos el documento--------------------------------------------
      */

      if ::oTpvCobros:nExit == exitAceptarImprimir
         ::ImprimeTicket()
      end if   

      /*
      Inicializa los valores para el documento---------------------------
      */

      ::InitDocumento( ubiGeneral )

      /*
      Datos de la ubicacion----------------------------------------------
      */

      ::SetUbicacion()

      /*
      Datos del documento------------------------------------------------
      */

      ::SetInfo()

      /*
      Datos del cliente--------------------------------------------------
      */

      ::SetCliente()

      /*
      Datos de la serie--------------------------------------------------
      */

      ::SetSerie()

      /*
      Recoger usuario----------------------------------------------------
      */

      ::GetUsuario()

   end if   

   ::EnableDialog()

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickPendientes() CLASS TpvTactil

   local oError
   local oBlock
   local lReturn           := .t.
   local lGuardaDocumento  := .t.

   /*
   Si el documento es nuevo y no tiene lineas no lo guardo---------------------
   */

   if !::lValidatePreSave()
      lGuardaDocumento     := .f.
   end if

   /*
   Vamos a detectar si estoy en un General------------------------------------
   */

   if ::lEmptyAlias()
      if ::SetAliasDocumento()
         lGuardaDocumento  := .t.
      else
         Return ( .t. )
      end if
   end if

   /*
   Si el docmuento no es nuevo y no tiene lineas lo tengo q borrar-------------

   if ::lEmptyLineas()
      ::EliminarDocumento( ::cNumeroTicket() )
      lGuardaDocumento     := .f.
   end if
   */

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::DisableDialog()

   /*
   Guarda la venta actual------------------------------------------------------
   */

   if ( !lGuardaDocumento .or. ::GuardaDocumentoPendiente() )

      ::oTiketCabecera:Cancel()

      if ::oTpvListaTicket:lPendientes() .and. !Empty( ::oTpvListaTicket:cSelectedTicket() )

         ::CargaDocumento( ::oTpvListaTicket:cSelectedTicket() )

      else

         ::InitDocumento()

      end if

   end if

   RECOVER USING oError

      msgStop( "Error al montar la lista de tickets pendientes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::EnableDialog()

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickLista() CLASS TpvTactil

   local oError
   local oBlock
   local lReturn           := .t.
   local lGuardaDocumento  := .t.

   /*
   Si el documento es nuevo y no tiene lineas no lo guardo---------------------
   */

   if !::lValidatePreSave()
      lGuardaDocumento     := .f.
   end if

   /*
   Vamos a detectar si estoy en un General------------------------------------
   */

   if ::lEmptyAlias()
      if ::SetAliasDocumento()
         lGuardaDocumento  := .t.
      else
         Return ( .t. )
      end if
   end if

   /*
   Si el docmuento no es nuevo y no tiene lineas lo tengo q borrar-------------
   */

   /*if ::lEmptyLineas()
      ::EliminarDocumento( ::cNumeroTicket() )
      lGuardaDocumento     := .f.
   end if*/

   ::DisableDialog()

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Guarda la venta actual------------------------------------------------------
   */

   if ( !lGuardaDocumento .or. ::GuardaDocumentoPendiente() )

      ::oTiketCabecera:Cancel()

      if ::oTpvListaTicket:lResource() .and. !Empty( ::oTpvListaTicket:cSelectedTicket() )
         ::CargaDocumento( ::oTpvListaTicket:cSelectedTicket() )
      else
         ::InitDocumento()
      end if

   end if

   RECOVER USING oError

      msgStop( "Error al montar la lista de tickets" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::EnableDialog()

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickEntregaNota() CLASS TpvTactil

   // Si el documento es nuevo y no tiene lineas no lo guardo------------------

   if !::lValidatePreSave()
      Return ( .f. )
   end if

   // Permiso de usuario para entregar nota-------------------------------------

   if oUser():lNotNotasTPV()
      MsgStop( "El usuario no esta autorizado para entregar notas." )
      Return ( .f. )
   end if

   // Vamos a detectar si estoy en un General----------------------------------

   if ::lEmptyAlias() .and. !::SetAliasDocumento()
      Return ( .f. )
   end if

   // Articulos sin peso-------------------------------------------------------

   if ::isArticulosSinPeso()
      msgStop( "Existen artículos por peso sin valor." )
      Return ( .f. )
   end if 

   ::SetTotal()

   ::DisableDialog()

   // Guarda documento---------------------------------------------------------

   ::GuardaDocumentoCerrado()

   // Imprimimos el documento--------------------------------------------------

   ::ImprimeEntrega()

   // Recoger usuario----------------------------------------------------------

   ::GetUsuario()

   // Volver a la sala de venta------------------------------------------------

   ::GetUbicacion()

   ::EnableDialog()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OnClickCloseTurno( lParcial ) CLASS TpvTactil

   local oError
   local oBlock
   local lReturn           := .t.
   local lGuardaDocumento  := .t.

   DEFAULT lParcial        := .t.

   /*
   Si el documento es nuevo y no tiene lineas no lo guardo---------------------
   */

   if !::lValidatePreSave()
      lGuardaDocumento     := .f.
   end if

   /*
   Vamos a detectar si estoy en un General------------------------------------
   */

   if ::lEmptyAlias()
      if ::SetAliasDocumento()
         lGuardaDocumento  := .t.
      else
         Return ( .t. )
      end if
   end if

   /*
   Si el docmuento no es nuevo y no tiene lineas lo tengo q borrar-------------

   if ::lEmptyLineas()
      ::EliminarDocumento( ::cNumeroTicket() )
      lGuardaDocumento     := .f.
   end if
   */

   ::DisableDialog()

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Guarda la venta actual------------------------------------------------------
   */

   if ( !lGuardaDocumento .or. ::GuardaDocumentoPendiente() )

      ::InitDocumento( ubiGeneral )

      ::DestroyFastReport()

      if ::oTurno:OpenFiles()
         ::oTurno:lArqueoTurno( .f., lParcial )
         ::oTurno:CloseFiles()
      end if

      ::InstanceFastReport()

      ::SetInfo()

   end if

   RECOVER USING oError

      msgStop( "Error al cerrar sesión" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::EnableDialog()

Return .t.

//---------------------------------------------------------------------------//

METHOD GuardaDocumento( lZap ) CLASS TpvTactil

   local oError
   local oBlock
   local sCobro

   // ::DisableDialog()

   DEFAULT lZap                     := .t.

   ::CargaValoresDefecto()

   oBlock                           := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      BeginTransaction()

      // Si el numero de ticket esta vacio debemos tomar un nuevo numero-------

      if ::lBlankTicket()

         ::oTiketCabecera:cNumTik   := ::nNuevoNumeroTicket()

         ::oTiketCabecera:Insert()

      else
         
         if lZap
            
            // Salvar y desbloquear pq finalizao la edición--------------------
            
            ::oTiketCabecera:SaveUnLock()

         else 
            
            // Solo salvar pq continuo editando--------------------------------
            
            ::oTiketCabecera:SaveFields()
            
         end if

      end if

      // Si este ticket ya tiene numero debemos quitar las lineas anteriores------

      if !( ::lBlankTicket() ) // .and. !Empty( ::oTemporalLinea:OrdKeyCount() )
         while ::oTiketLinea:Seek( ::cNumeroTicket() ) .and. !::oTiketLinea:eof()
            ::oTiketLinea:Delete(.f.)
         end while
      end if

      // Guarda las lineas del ticket------------------------------------------

      ::oTemporalLinea:GetStatus()
      ::oTemporalLinea:OrdSetFocus( "lRecNum" )

      ::oProgressBar:SetTotal( ::oTemporalLinea:RecCount() )

      ::oTemporalLinea:GoTop()
      while !::oTemporalLinea:eof()

         ::oTemporalLinea:cSerTil   := ::oTiketCabecera:cSerTik
         ::oTemporalLinea:cNumTil   := ::oTiketCabecera:cNumTik
         ::oTemporalLinea:cSufTil   := ::oTiketCabecera:cSufTik
         ::oTemporalLinea:cTipTil   := ::oTiketCabecera:cTipTik
         ::oTemporalLinea:dFecTik   := ::oTiketCabecera:dFecTik
         ::oTemporalLinea:lSave     := .t.

         ::oTiketLinea:AppendFromObject( ::oTemporalLinea )

         ::oProgressBar:Set( ::oTemporalLinea:RecNo() )

         ::oTemporalLinea:Skip()

      end while

      ::oTemporalLinea:SetStatus()

      // Vaciamos las lineas si estamos en un nuevo ticket---------------------

      if lZap

         ::oTemporalLinea:Zap()

         ::oBrwLineas:Refresh()
      
      else
   
         ::oTiketCabecera:Load()
      
      end if

      CommitTransaction()

      // Barra de progreso vuelve a su estado----------------------------------

      ::oProgressBar:Set( 0 )
      ::oProgressBar:Refresh()

      // Encendemos el flag para cargar de nuevo el usuario--------------------

      ::lGetUsuario                 := .t.

   RECOVER USING oError

      RollBackTransaction()

      msgStop( "Error al grabar el ticket" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Dialogo se vuelve a habilitar para volcer al trabajo------------------------
   */

   // ::EnableDialog()

Return .t.

//---------------------------------------------------------------------------//

METHOD GuardaDocumentoAlbaran() CLASS TpvTactil

   local n           
   local oError
   local oBlock
   local sCobro
   local nOrdAnt
   local cSerAlb     
   local nNumAlb     
   local cSufAlb     
   local nNewAlbCli

   ::DisableDialog()

   n                                      := 1
   cSerAlb                                := ::oTiketCabecera:cSerTik //cNewSer( "NALBCLI", ::oContadores:cAlias )
   nNumAlb                                := nNewDoc( cSerAlb, ::oAlbaranClienteCabecera:cAlias, "nAlbCli", , ::oContadores:cAlias )
   cSufAlb                                := RetSufEmp()

   ::cNumeroAlbaran                       := cSerAlb + Str( nNumAlb ) + cSufAlb

   oBlock                                 := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   BeginTransaction()

   /*
   Creamos la cabecera del albarán---------------------------------------------
   */

   ::oAlbaranClienteCabecera:Append()

   ::oAlbaranClienteCabecera:cSerAlb      := cSerAlb
   ::oAlbaranClienteCabecera:nNumAlb      := nNumAlb
   ::oAlbaranClienteCabecera:cSufAlb      := cSufAlb
   ::oAlbaranClienteCabecera:dFecCre      := GetSysDate()
   ::oAlbaranClienteCabecera:cTimCre      := Time()
   ::oAlbaranClienteCabecera:dFecAlb      := GetSysDate()
   ::oAlbaranClienteCabecera:cCodUsr      := oUser():cCodigo()
   ::oAlbaranClienteCabecera:cTurAlb      := cCurSesion()
   ::oAlbaranClienteCabecera:lFacturado   := .f.
   ::oAlbaranClienteCabecera:nFacturado   := 1
   ::oAlbaranClienteCabecera:lSndDoc      := .t.
   ::oAlbaranClienteCabecera:lIvaInc      := .t.
   ::oAlbaranClienteCabecera:cCodCaj      := oUser():cCaja()
   ::oAlbaranClienteCabecera:cCodPago     := cDefFpg()
   ::oAlbaranClienteCabecera:cCodAlm      := oUser():cAlmacen()
   ::oAlbaranClienteCabecera:nTarifa      := Max( uFieldEmpresa( "nPreVta" ), 1 )
   ::oAlbaranClienteCabecera:cCodCli      := ::oTiketCabecera:cCliTik
   ::oAlbaranClienteCabecera:cNomCli      := ::oTiketCabecera:cNomTik
   ::oAlbaranClienteCabecera:cDirCli      := ::oTiketCabecera:cDirCli
   ::oAlbaranClienteCabecera:cPobCli      := ::oTiketCabecera:cPobCli
   ::oAlbaranClienteCabecera:cPrvCli      := ::oTiketCabecera:cPrvCli
   ::oAlbaranClienteCabecera:cPosCli      := ::oTiketCabecera:cPosCli
   ::oAlbaranClienteCabecera:cDniCli      := ::oTiketCabecera:cDniCli
   ::oAlbaranClienteCabecera:cDtoEsp      := ::oTiketCabecera:cDtoEsp
   ::oAlbaranClienteCabecera:nDtoEsp      := ::oTiketCabecera:nDtoEsp
   ::oAlbaranClienteCabecera:cDpp         := ::oTiketCabecera:cDpp
   ::oAlbaranClienteCabecera:nDpp         := ::oTiketCabecera:nDpp
   ::oAlbaranClienteCabecera:cDivAlb      := cDivEmp()
   ::oAlbaranClienteCabecera:nVdvAlb      := nChgDiv( cDivEmp(), ::oDivisas:cAlias )
   ::oAlbaranClienteCabecera:cRetMat      := ::oTiketCabecera:cRetMat
   ::oAlbaranClienteCabecera:cCodAge      := ::oTiketCabecera:cCodAge
   ::oAlbaranClienteCabecera:cCodRut      := ::oTiketCabecera:cCodRut
   ::oAlbaranClienteCabecera:cCodTar      := ::oTiketCabecera:cCodTar
   ::oAlbaranClienteCabecera:cCodObr      := ::oTiketCabecera:cCodObr
   ::oAlbaranClienteCabecera:nTotNet      := ::sTotal:TotalBase()
   ::oAlbaranClienteCabecera:nTotIva      := ::sTotal:TotalIva() 
   ::oAlbaranClienteCabecera:nTotAlb      := ::sTotal:TotalDocumento()

   ::oAlbaranClienteCabecera:Save()

   /*
   Creamos las Lineas del albarán----------------------------------------------
   */   

   ::oTemporalLinea:GoTop()

   while !::oTemporalLinea:Eof()

      ::oAlbaranClienteLinea:Append()
      ::oAlbaranClienteLinea:cSerAlb      := cSerAlb
      ::oAlbaranClienteLinea:nNumAlb      := nNumAlb
      ::oAlbaranClienteLinea:cSufAlb      := cSufAlb
      ::oAlbaranClienteLinea:cRef         := ::oTemporalLinea:cCbaTil
      ::oAlbaranClienteLinea:cDetalle     := ::oTemporalLinea:cNomTil
      ::oAlbaranClienteLinea:nPreUnit     := ::oTemporalLinea:nPvpTil
      ::oAlbaranClienteLinea:nDto         := ::oTemporalLinea:nDtoLin
      ::oAlbaranClienteLinea:nIva         := ::oTemporalLinea:nIvaTil
      ::oAlbaranClienteLinea:nUniCaja     := ::oTemporalLinea:nUntTil
      ::oAlbaranClienteLinea:cCodPr1      := ::oTemporalLinea:cCodPr1
      ::oAlbaranClienteLinea:cCodPr2      := ::oTemporalLinea:cCodPr2
      ::oAlbaranClienteLinea:cValPr1      := ::oTemporalLinea:cValPr1
      ::oAlbaranClienteLinea:cValPr2      := ::oTemporalLinea:cValPr2
      ::oAlbaranClienteLinea:nFacCnv      := ::oTemporalLinea:nFacCnv
      ::oAlbaranClienteLinea:nDtoDiv      := ::oTemporalLinea:nDtoDiv
      ::oAlbaranClienteLinea:nCtlStk      := ::oTemporalLinea:nCtlStk
      ::oAlbaranClienteLinea:nValImp      := ::oTemporalLinea:nValImp
      ::oAlbaranClienteLinea:cCodImp      := ::oTemporalLinea:cCodImp
      ::oAlbaranClienteLinea:lKitChl      := ::oTemporalLinea:lKitChl
      ::oAlbaranClienteLinea:lKitArt      := ::oTemporalLinea:lKitArt
      ::oAlbaranClienteLinea:lKitPrc      := ::oTemporalLinea:lKitPrc
      ::oAlbaranClienteLinea:dFecAlb      := GetSysDate()
      ::oAlbaranClienteLinea:cAlmLin      := oUser():cAlmacen()
      ::oAlbaranClienteLinea:lIvaLin      := .t.
      ::oAlbaranClienteLinea:nNumLin      := ::oTemporalLinea:nNumLin
      ::oAlbaranClienteLinea:nPosPrint    := ::oTemporalLinea:nPosPrint
      
      if !Empty( ::oTemporalLinea:cLote )
         ::oAlbaranClienteLinea:cLote     := ::oTemporalLinea:cLote
         ::oAlbaranClienteLinea:lLote     := .t.
      end if

      ::oAlbaranClienteLinea:Save()

      ::oTemporalLinea:Skip()

   end while

   /*
   Guardamos los cobros--------------------------------------------------------

   */

   if Len( ::oTpvCobros:aCobros ) != 0

      for each sCobro in ::oTpvCobros:aCobros

         ::oAlbaranClientePago:Append()

         ::oAlbaranClientePago:cSerAlb    := cSerAlb
         ::oAlbaranClientePago:nNumAlb    := nNumAlb
         ::oAlbaranClientePago:cSufAlb    := cSufAlb
         ::oAlbaranClientePago:nNumRec    := n
         ::oAlbaranClientePago:cCodCaj    := oUser():cCaja()
         ::oAlbaranClientePago:cTurRec    := cCurSesion()
         ::oAlbaranClientePago:cCodCli    := ::oTiketCabecera:cCliTik
         ::oAlbaranClientePago:dEntrega   := GetSysDate()
         ::oAlbaranClientePago:nImporte   := sCobro:nImporte
         ::oAlbaranClientePago:cDescrip   := "Entrega a cuenta del albarán: " + cSerAlb + "/" + AllTrim( Str( nNumAlb ) )
         ::oAlbaranClientePago:cDivPgo    := cDivEmp()
         ::oAlbaranClientePago:nVdvPgo    := nChgDiv( cDivEmp(), ::oDivisas:cAlias )
         ::oAlbaranClientePago:cCodPgo    := sCobro:cCodigo
         ::oAlbaranClientePago:lCloPgo    := .f.

         ::oAlbaranClientePago:Save()

         n++

      next

   end if

   CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()

      msgStop( "Error al grabar el albarán" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Dialogo se vuelve a habilitar para volcer al trabajo------------------------
   */

   ::EnableDialog()

Return .t.

//---------------------------------------------------------------------------//

METHOD CargaDocumento( cNumeroTicket ) CLASS TpvTactil

   local oError
   local oBlock

   if empty( cNumeroTicket )
      return .f.
   end if

   oBlock                                 := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ::oTiketCabecera:Seek( cNumeroTicket ) .and. ::oTiketCabecera:RecLock()

      // Cargo el registro sin bloquear pq ya esta bloqueado-------------------

      ::oTiketCabecera:Load()  

      // Cargamos las lineas------------------------------------------------------

      if ::oTiketLinea:Seek( cNumeroTicket )

         ::oTemporalLinea:Zap()

         while ( ::cNumeroTicketLinea() == cNumeroTicket ) .and. !( ::oTiketLinea:Eof() )

            if !( uFieldEmpresa( "lShowLin" ) .and. ::oTiketLinea:lDelTil )

               ::oTemporalLinea:AppendFromObject( ::oTiketLinea )

            end if

            ::oTiketLinea:Skip()

         end while

         ::oTemporalLinea:GoTop()

      end if

      // Refrescamos el browse-------------------------------------------------------

      ::oBrwLineas:Refresh()
   
      // Calculamos el total---------------------------------------------------------

      ::SetTotal()
   
      // Pintamos la información de la zona donde nos encontramos--------------------
   
      ::SetUbicacion()

      // Cliente---------------------------------------------------------------

      ::SetCliente()
   
      // Datos del documento---------------------------------------------------------
   
      ::SetInfo()

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error al cargar el documento." )

   END SEQUENCE

   ErrorBlock( oBlock )

Return .t.

//---------------------------------------------------------------------------//

METHOD EliminarDocumento( cNumeroTicket ) CLASS TpvTactil

   local lElimina          := .f.

   DEFAULT cNumeroTicket   := ::cNumeroTicket()

   if ApoloMsgNoYes( "¿ Desea realmente eliminar el ticket " + ::cNumeroTicketFormato( cNumeroTicket ) + " ?", "Atención", .t. )

      ::DisableDialog()

      ::oTiketCabecera:GetStatus()
      ::oTiketLinea:GetStatus()

      if ::oTiketCabecera:Seek( cNumeroTicket )
         ::oTiketCabecera:Delete()
      end if

      while ( ::oTiketLinea:Seek( cNumeroTicket ) )
         ::oTiketLinea:Delete(.f.)
      end while

      ::oTiketCabecera:SetStatus()
      ::oTiketLinea:SetStatus()

      logwrite( "Ticket eliminado " + cNumeroTicket, "Eliminados.txt" )

      lElimina             := .t.

      ::EnableDialog()

   end if

Return ( lElimina )

//---------------------------------------------------------------------------//

METHOD CargaValoresDefecto( nUbicacion ) CLASS TpvTactil

   /*
   Tipo del ticket-------------------------------------------------------------
   */

   if Empty( ::oTiketCabecera:cTipTik )
      ::oTiketCabecera:cTipTik   := SAVTIK
   end if

   /*
   Serie del ticket------------------------------------------------------------
   */

   if Empty( ::oTiketCabecera:cSerTik )
      ::oTiketCabecera:cSerTik   := cNewSer( "NTIKCLI", ::oContadores:cAlias )
   end if

   /*
   Forma de pago---------------------------------------------------------------
   */

   if Empty( ::oTiketCabecera:cFpgTik )
      ::oTiketCabecera:cFpgTik   := cDefFpg()
   end if

   /*
   Turno del ticket------------------------------------------------------------
   */

   if Empty( ::oTiketCabecera:cTurTik )
      ::oTiketCabecera:cTurTik   := cCurSesion()
   else
      if ::oTiketCabecera:cTurTik != cCurSesion()
         ::oTiketCabecera:cTurTik   := cCurSesion()  
      end if
   end if

   /*
   Usuario del ticket----------------------------------------------------------
   */

   if Empty( ::oTiketCabecera:cCcjTik )
      ::oTiketCabecera:cCcjTik   := oUser():cCodigo()
   end if

   /*
   Caja del ticket-------------------------------------------------------------
   */

   if Empty( ::oTiketCabecera:cNcjTik )
      ::oTiketCabecera:cNcjTik   := oUser():cCaja()
   end if

   /*
   Tarifa de venta del ticket--------------------------------------------------
   */

   if Empty( ::oTiketCabecera:nTarifa )
      ::oTiketCabecera:nTarifa   := Max( uFieldEmpresa( "nPreVta" ), 1 )
   end if

   /*
   Tarifa de venta del ticket--------------------------------------------------
   */

   if Empty( ::oTiketCabecera:cSufTik )
      ::oTiketCabecera:cSufTik   := RetSufEmp()
   end if

   /*
   Fecha del ticket------------------------------------------------------------
   */

   if Empty( ::oTiketCabecera:dFecTik )
      ::oTiketCabecera:dFecTik   := GetSysDate()
   end if

   /*
   Almacen del ticket----------------------------------------------------------
   */

   if Empty( ::oTiketCabecera:cAlmTik )
      ::oTiketCabecera:cAlmTik   := oUser():cAlmacen()
   end if

   /*
   Cliente del ticket----------------------------------------------------------
   */

   if Empty( ::oTiketCabecera:cCliTik )
      ::oTiketCabecera:cCliTik   := cDefCli()
   end if

   if Empty( ::oTiketCabecera:cNomTik )
      ::oTiketCabecera:cNomTik   := RetFld( cDefCli(), ::oCliente:cAlias, "Titulo" )
   end if

   if Empty( ::oTiketCabecera:cDirCli )
      ::oTiketCabecera:cDirCli   := RetFld( cDefCli(), ::oCliente:cAlias, "Domicilio" )
   end if

   if Empty( ::oTiketCabecera:cPobCli )
      ::oTiketCabecera:cPobCli   := RetFld( cDefCli(), ::oCliente:cAlias, "Poblacion" )
   end if

   if Empty( ::oTiketCabecera:cPrvCli )
      ::oTiketCabecera:cPrvCli   := RetFld( cDefCli(), ::oCliente:cAlias, "Provincia" )
   end if

   if Empty( ::oTiketCabecera:cPosCli )
      ::oTiketCabecera:cPosCli   := RetFld( cDefCli(), ::oCliente:cAlias, "CodPostal" )
   end if

   if Empty( ::oTiketCabecera:cPosCli )
      ::oTiketCabecera:cPosCli   := RetFld( cDefCli(), ::oCliente:cAlias, "CodPostal" )
   end if

   if Empty( ::oTiketCabecera:cDniCli )
      ::oTiketCabecera:cDniCli   := RetFld( cDefCli(), ::oCliente:cAlias, "Nif" )
   end if

   if Empty( ::oTiketCabecera:dFecCre )
      ::oTiketCabecera:dFecCre   := Date()
   end if

   if Empty( ::oTiketCabecera:cTimCre )
      ::oTiketCabecera:cTimCre   := SubStr( Time(), 1, 5 )
   end if

   if Empty( ::oTiketCabecera:cHorTik )
      ::oTiketCabecera:cHorTik   := Substr( Time(), 1, 5 )
   end if

   if IsNum( nUbicacion )
      ::oTiketCabecera:nUbiTik   := nUbicacion
   end if

   if !Empty( ::sTotal )
      ::oTiketCabecera:nTotNet   := ::sTotal:TotalBase()
      ::oTiketCabecera:nTotIva   := ::sTotal:TotalIva()
      ::oTiketCabecera:nTotTik   := ::sTotal:TotalDocumento()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD initValoresDefecto() CLASS TpvTactil

   ::oTiketCabecera:lAbierto  := .t.
   ::oTiketCabecera:lCloTik   := .f.
   ::oTiketCabecera:lSndDoc   := .t.

   if !empty( cDefCli() )
      ::SetTarifaSolo(        Max( oRetFld( cDefCli(), ::oCliente, "nTarifa" ), 1 ) )
      ::SetTarifaCombinado(   Max( oRetFld( cDefCli(), ::oCliente, "nTarCmb" ), 1 ) )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD OnClickSalaVenta( nSelectOption ) CLASS TpvTactil

   local oError
   local oBlock
   local lReturn           := .t.
   local lGuardaDocumento  := .t.

   DEFAULT nSelectOption   := ubiSala

   /*
   Si el documento es nuevo y no tiene lineas no lo guardo---------------------
   */

   if ::lEmptyDocumento()
      lGuardaDocumento     := .f.
   end if

   /*
   Vamos a detectar si estoy en un General------------------------------------
   */

   if ::lEmptyAlias()
      if ::SetAliasDocumento()
         lGuardaDocumento  := .t.
      else
         Return ( .t. )
      end if
   end if

   /*
   Si el docmuento no es nuevo y no tiene lineas lo tengo q borrar-------------

   if ::lEmptyLineas()
      ::EliminarDocumento( ::cNumeroTicket() )
      lGuardaDocumento     := .f.
   end if
   */

   ::DisableDialog()

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Guarda la venta actual------------------------------------------------------
   */

   if ( !lGuardaDocumento .or. ::GuardaDocumentoPendiente() )

      /*
      Recoger usuario----------------------------------------------------------
      */

      if ::GetUsuario()

         /*
         Muestra la sala-------------------------------------------------------
         */

         if ::oRestaurante:Sala( nil, .t., nSelectOption ) //  nil, .f. )

            if !( ::CargaDocumento( ::oRestaurante:cSelectedTicket() ) )

               if !Empty( ::oRestaurante:cSelectedSala )

                  // Inicializa los valores para el documento---------------------

                  ::InitDocumento()

                  // Asignando valores--------------------------------------------

                  ::SetTarifaSolo(        ::oRestaurante:nSelectedPrecio )
                  ::SetTarifaCombinado(   ::oRestaurante:nSelectedCombinado )

                  ::oTiketCabecera:nUbiTik   := nSelectOption

                  ::oTiketCabecera:nTarifa   := ::oRestaurante:nSelectedPrecio
                  ::oTiketCabecera:cCodSala  := ::oRestaurante:cSelectedSala
                  ::oTiketCabecera:cPntVenta := ::oRestaurante:cSelectedPunto

               else 

                  ::InitDocumento()

               end if

            end if

            // Pintamos la información de la zona donde nos encontramos-----

            ::SetUbicacion()

            // Datos del documento---------------------------------------------

            ::SetInfo()

            // Cliente--------------------------------------------------------

            ::SetCliente()

            // Serie ----------------------------------------------------------

            ::SetSerie()

            // Total documento-------------------------------------------------

            ::SetTotal()

         else

            // Inicializa los valores para un nuevo documento General----------

            ::InitDocumento( ubiGeneral )

         end if

      end if

   end if

   RECOVER USING oError

      msgStop( "Error al montar la salas de venta" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::EnableDialog()

Return ( lReturn )

//---------------------------------------------------------------------------//

METHOD OnClickGeneral() CLASS TpvTactil

   local oError
   local oBlock
   local lReturn           := .t.
   local lGuardaDocumento  := .t.

   /*
   Si el documento es nuevo y no tiene lineas no lo guardo---------------------
   */

   if !::lValidatePreSave()
      lGuardaDocumento     := .f.
   end if

   /*
   Vamos a detectar si estoy en un General-------------------------------------
   */

   if ::lEmptyAlias()
      if ::SetAliasDocumento()
         lGuardaDocumento  := .t.
      else
         Return ( .t. )
      end if
   end if

   /*
   Si el docmuento no es nuevo y no tiene lineas lo tengo q borrar-------------

   if ::lEmptyLineas()
      ::EliminarDocumento( ::cNumeroTicket() )
      lGuardaDocumento     := .f.
   end if
   */

   ::DisableDialog()

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   // Guarda la venta actual---------------------------------------------------

   if ( !lGuardaDocumento .or. ::GuardaDocumentoPendiente() )

      // Recoger usuario-------------------------------------------------------

      if ::GetUsuario()

         ::gotoUbicacionGeneral()

      end if

   end if

   RECOVER USING oError

      msgStop( "Error al montar abrir la ubicación general" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::EnableDialog()

Return ( lReturn )

//---------------------------------------------------------------------------//

METHOD gotoUbicacionGeneral() CLASS TpvTactil

   // Inicializa los valores para el documento---------------------------

   ::InitDocumento( ubiGeneral )

   // Cargamos las tarifas-----------------------------------------------

   ::SetTarifaSolo(        Max( uFieldEmpresa( "nPreTPro" ), 1 ) )
   ::SetTarifaCombinado(   Max( uFieldEmpresa( "nPreTCmb" ), 1 ) )
   
   // Pintamos la información de la zona donde nos encontramos-----------

   ::SetUbicacion()

   // Datos del documento------------------------------------------------

   ::SetInfo()

   // Ponemos el total---------------------------------------------------

   ::SetTotal()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD OnClickParaRecoger() CLASS TpvTactil

   local oError
   local oBlock
   local lReturn           := .t.
   local lGuardaDocumento  := .t.

   /*
   Si el documento es nuevo y no tiene lineas no lo guardo---------------------
   */

   if !::lValidatePreSave()
      lGuardaDocumento     := .f.
   end if

   /*
   Vamos a detectar si estoy en un General-------------------------------------
   */

   if ::lEmptyAlias()
      if ::SetAliasDocumento()
         lGuardaDocumento  := .t.
      else
         Return ( .t. )
      end if
   end if

   /*
   Si el docmuento no es nuevo y no tiene lineas lo tengo q borrar-------------

   if ::lEmptyLineas()
      ::EliminarDocumento( ::cNumeroTicket() )
      lGuardaDocumento     := .f.
   end if
   */

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::DisableDialog()

   /*
   Guarda la venta actual------------------------------------------------------
   */

   if ( !lGuardaDocumento .or. ::GuardaDocumentoPendiente() )

      /*
      Recoger usuario-------------------------------------------------------------
      */

      if ::GetUsuario()

         /*
         Inicializa los valores para el documento---------------------------------
         */

         ::InitDocumento( ubiRecoger )

         // Cargamos las tarifas-----------------------------------------------------

         ::SetTarifaSolo(        Max( uFieldEmpresa( "nPreTPro" ), 1 ) )
         ::SetTarifaCombinado(   Max( uFieldEmpresa( "nPreTCmb" ), 1 ) )

         // Pintamos la información de la zona donde nos encontramos-----------------

         ::SetUbicacion()

         /*
         Datos del documento------------------------------------------------------
         */

         ::SetInfo()

      end if

   end if

   ::EnableDialog()

   RECOVER USING oError

      msgStop( "Error al montar abrir la ubicación general" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lReturn )

//---------------------------------------------------------------------------//

METHOD OnClickParaLlevar() CLASS TpvTactil

   local oError
   local oBlock
   local lReturn           := .t.
   local lGuardaDocumento  := .t.

   /*
   Si el documento es nuevo y no tiene lineas no lo guardo---------------------
   */

   if !::lValidatePreSave()
      lGuardaDocumento     := .f.
   end if

   /*
   Vamos a detectar si estoy en un General------------------------------------
   */

   if ::lEmptyAlias()
      if ::SetAliasDocumento()
         lGuardaDocumento  := .t.
      else
         Return ( .t. )
      end if
   end if

   /*
   Si el docmuento no es nuevo y no tiene lineas lo tengo q borrar-------------

   if ::lEmptyLineas()
      ::EliminarDocumento( ::cNumeroTicket() )
      lGuardaDocumento     := .f.
   end if
   */

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::DisableDialog()

   /*
   Guarda la venta actual------------------------------------------------------
   */

   if ( !lGuardaDocumento .or. ::GuardaDocumentoPendiente() )

      /*
      Recoger usuario-------------------------------------------------------------
      */

      if ::GetUsuario()

         /*
         Inicializa los valores para un nuevo documento para llevar---------------
         */

         ::InitDocumento( ubiLlevar )

         // Cargamos las tarifas-----------------------------------------------------

         ::SetTarifaSolo(        Max( uFieldEmpresa( "nPreTPro" ), 1 ) )
         ::SetTarifaCombinado(   Max( uFieldEmpresa( "nPreTCmb" ), 1 ) )

         // Muestro el dialogo de clientes-------------------------------------------

         ::SelecionaCliente()

      end if

   end if

   /*
   Pintamos la información de la zona donde nos encontramos--------------------
   */

   ::SetUbicacion()

   /*
   Datos del documento---------------------------------------------------------
   */

   ::SetInfo()

   ::EnableDialog()

   RECOVER USING oError

      msgStop( "Error al montar la salas de venta" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lReturn )

//---------------------------------------------------------------------------//

METHOD OnClickEncargar() CLASS TpvTactil

   local oError
   local oBlock
   local lReturn           := .t.
   local lGuardaDocumento  := .t.

   /*
   Si el documento es nuevo y no tiene lineas no lo guardo---------------------
   */

   if !::lValidatePreSave()
      lGuardaDocumento     := .f.
   end if

   /*
   Vamos a detectar si estoy en un General------------------------------------
   */

   if ::lEmptyAlias()
      if ::SetAliasDocumento()
         lGuardaDocumento  := .t.
      else
         Return ( .t. )
      end if
   end if

   /*
   Si el docmuento no es nuevo y no tiene lineas lo tengo q borrar-------------

   if ::lEmptyLineas()
      ::EliminarDocumento( ::cNumeroTicket() )
      lGuardaDocumento     := .f.
   end if
   */

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::DisableDialog()

   /*
   Guarda la venta actual------------------------------------------------------
   */

   if ( !lGuardaDocumento .or. ::GuardaDocumentoPendiente() )

      /*
      Recoger usuario-------------------------------------------------------------
      */

      if ::GetUsuario()

         /*
         Inicializa los valores para un nuevo documento para encargar---------------
         */

         ::InitDocumento( ubiEncargar )

         // Cargamos las tarifas-----------------------------------------------------

         ::SetTarifaSolo(        Max( uFieldEmpresa( "nPreTPro" ), 1 ) )
         ::SetTarifaCombinado(   Max( uFieldEmpresa( "nPreTCmb" ), 1 ) )

         // Muestro el dialogo de clientes-------------------------------------------

         ::SelecionaCliente()

      end if

   end if

   /*
   Pintamos la información de la zona donde nos encontramos--------------------
   */

   ::SetUbicacion()

   /*
   Datos del documento---------------------------------------------------------
   */

   ::SetInfo()

   ::EnableDialog()

   RECOVER USING oError

      msgStop( "Error al montar la salas de venta" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lReturn )

//---------------------------------------------------------------------------//

METHOD OnClickCambiaUbicacion() CLASS TpvTactil

   local oError
   local oBlock
   local lReturn           := .t.
   local cNumeroDocumento

   /*
   Si el documento es nuevo y no tiene lineas no lo guardo---------------------
   */

   if !::lValidatePreSave() .or. ::lEmptyLineas()
      MsgStop( "El documento esta vacio" )
      Return ( .t. )
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::DisableDialog()

   if ::lEmptyNumeroTicket()

      if ::oRestaurante:Sala( .f., .f. )

         ::oTiketCabecera:nUbiTik   := ubiSala
         ::oTiketCabecera:cCodSala  := ::oRestaurante:cSelectedSala
         ::oTiketCabecera:cPntVenta := ::oRestaurante:cSelectedPunto

         // Pintamos la información de la zona donde nos encontramos--------------

         ::SetUbicacion()

         // Datos del documento---------------------------------------------------

         ::SetInfo()

         // Informamos del cambio de ubicación------------------------------------

         MsgInfo( "El ticket ha sido movido a la ubicación " + ::cUbicacion() )

      end if

   else

      cNumeroDocumento     := ::cNumeroTicket()

      // Esto era el codigo original-------------------------------------------

      if ( ::GuardaDocumentoPendiente() )

         if ::oRestaurante:Sala( .f., .f. )

            if ::oTiketCabecera:Seek( cNumeroDocumento )
               ::oTiketCabecera:FieldPutByName( "nUbiTik",     ubiSala )
               ::oTiketCabecera:FieldPutByName( "cCodSala",    ::oRestaurante:cSelectedSala )
               ::oTiketCabecera:FieldPutByName( "cPntVenta",   ::oRestaurante:cSelectedPunto )
            end if

            ::CargaDocumento( cNumeroDocumento )

            // Pintamos la información de la zona donde nos encontramos--------------

            ::SetUbicacion()

            // Datos del documento---------------------------------------------------

            ::SetInfo()

            // Informamos del cambio de ubicación------------------------------------

            MsgInfo( "El ticket ha sido movido a la ubicación " + ::cUbicacion() )

         end if

      end if

   end if

   ::EnableDialog()

   RECOVER USING oError

      msgStop( "Error al montar la salas de venta" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lReturn )

//---------------------------------------------------------------------------//

METHOD CargaContador() CLASS TpvTactil

   ::oTiketCabecera:cNumTik      := ::nNuevoNumeroTicket()
   ::oTiketCabecera:cSufTik      := RetSufEmp()
   ::oTiketCabecera:dFecCre      := Date()
   ::oTiketCabecera:cTimCre      := SubStr( Time(), 1, 5 )
   ::oTiketCabecera:cHorTik      := Substr( Time(), 1, 5 )
   ::oTiketCabecera:lAbierto     := .f.
   ::oTiketCabecera:lCloTik      := .f.

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetCalculadora() CLASS TpvTactil

   local nGetUnidadesTop         := ::oGetUnidades:nTop
   local nBtnFamiliasTop         := ::oBtnFamiliasUp:nTop
   local nBrwFamiliasHeight      := ::oBrwFamilias:nHeight
   local nBtnPrecioUnidadesTop   := ::oBtnPrecioUnidades:nTop

   ::lHideCalculadora            := !::lHideCalculadora

   if ::lHideCalculadora

      aEval( ::oBtnNum, {|o| o:Hide() } )

      ::oBrwFamilias:Move( , , , nBrwFamiliasHeight + calcDistance, .t. )

      ::oBtnPrecioUnidades:Move(    nBtnPrecioUnidadesTop + calcDistance, , , , .t. )

      ::oGetUnidades:Move(          nGetUnidadesTop + calcDistance, , , , .t. )

      ::oBtnFamiliasUp:Move(        nBtnFamiliasTop + calcDistance, , , , .t. )
      ::oBtnFamiliasDown:Move(      nBtnFamiliasTop + calcDistance, , , , .t. )

      ::oBtnCalculadora:Move(       nBtnFamiliasTop + calcDistance, , , , .t. )
      ::oBtnBalanza:Move(           nBtnFamiliasTop + calcDistance, , , , .t. )

      if !Empty( ::oBtnSSalir )
         ::oBtnSSalir:Move(         nBtnFamiliasTop + calcDistance, , , , .t. )
      end if   

   else

      aEval( ::oBtnNum, {|o| o:Show() } )

      ::oBrwFamilias:Move( , , , nBrwFamiliasHeight - calcDistance, .t. )

      ::oGetUnidades:Move(          nGetUnidadesTop - calcDistance, , , , .t. )

      ::oBtnPrecioUnidades:Move(    nBtnPrecioUnidadesTop - calcDistance, , , , .t. )

      ::oBtnFamiliasUp:Move(        nBtnFamiliasTop - calcDistance, , , , .t. )
      ::oBtnFamiliasDown:Move(      nBtnFamiliasTop - calcDistance, , , , .t. )

      ::oBtnCalculadora:Move(       nBtnFamiliasTop - calcDistance, , , , .t. )
      ::oBtnBalanza:Move(           nBtnFamiliasTop - calcDistance, , , , .t. )

      if !Empty( ::oBtnSSalir )
         ::oBtnSSalir:Move(         nBtnFamiliasTop - calcDistance, , , , .t. )
      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetAliasDocumento( cTexto ) CLASS TpvTactil

   local cNombreUbicacion           

   DEFAULT cTexto                   := "Asignar nombre"

   cNombreUbicacion                 := VirtualKey( .f., ::oTiketCabecera:cAliasTik, cTexto )

   if ::validateAliasDocumento( cNombreUbicacion )

      ::oTiketCabecera:cAliasTik    := cNombreUbicacion

      ::SetUbicacion()

      // Datos del documento---------------------------------------------------------

      ::SetInfo()

      Return ( .t. )

   else 

      apoloMsgStop( "El nombre elegido ya esta siendo utilizado en otra ubicación", "Elija uno diferente" )      

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD validateAliasDocumento( cNombreUbicacion ) 

   local aStatus
   local lValidate         := .t.

   if empty( cNombreUbicacion )
      Return .t.
   end if 

   if alltrim( cNombreUbicacion ) == alltrim( ::oTiketCabecera:cAliasTik )
      Return .t.
   end if 

   aStatus                 := ::oTiketCabecera:GetStatus()

   ::oTiketCabecera:OrdSetFocus( "lCloTik" )

   ::oTiketCabecera:goTop()
   while !::oTiketCabecera:eof()

      if alltrim( ::oTiketCabecera:fieldGetByName( "cAliasTik" ) ) == alltrim( cNombreUbicacion )
         lValidate         := .f.
         exit
      end if 

      ::oTiketCabecera:skip()

   end while

   ::oTiketCabecera:SetStatus( aStatus )

Return ( lValidate )

//---------------------------------------------------------------------------//

METHOD ImprimePago()

	do case
	 case ::oTpvCobros:nExit == exitAceptarRegalo
	    ::ImprimeRegalo()

	 case ::oTpvCobros:nExit == exitAceptarDesglosado
	    ::ImprimeDesglosado()   

	 case ::oTpvCobros:nExit == exitAceptarImprimir
	    ::ImprimeTicket()

	end case

RETURN ( Self )  

//-----------------------------------------------------------------------//

METHOD ImprimeComanda( cImpresora )

   ::cFormato        := cFormatoComandaEnCaja( oUser():cCaja(), cImpresora, ::oCajaCabecera:cAlias, ::oCajaLinea:cAlias )
   ::cImpresora      := alltrim( cNombreImpresoraComanda( oUser():cCaja(), cImpresora, ::oCajaLinea:cAlias ) )
   ::nDispositivo    := IS_PRINTER
   ::nCopias         := max( nCopiasComandasEnCaja( oUser():cCaja(), ::oCajaCabecera:cAlias ), 1 )
   ::lComanda        := .t.

   ::ImprimeDocumento()

RETURN ( Self )  

//-----------------------------------------------------------------------//

METHOD ImprimeAnulacion( cImpresora )

  ::cFormato        := cFormatoAnulacionEnCaja( oUser():cCaja(), cImpresora, ::oCajaCabecera:cAlias, ::oCajaLinea:cAlias )
  ::cImpresora      := AllTrim( cNombreImpresoraComanda( oUser():cCaja(), cImpresora, ::oCajaLinea:cAlias ) )
  ::nDispositivo    := IS_PRINTER
  ::nCopias         := Max( nCopiasComandasEnCaja( oUser():cCaja(), ::oCajaCabecera:cAlias ), 1 )
  ::lComanda        := .t.

  ::ImprimeDocumento()

RETURN ( Self )  

//-----------------------------------------------------------------------//

METHOD ImprimeTicket()

   do case
      case ::nTipoDocumento == documentoAlbaran

         ::cFormato     := ::oFormatosImpresion:cFmtAlb
         ::cImpresora   := ::oFormatosImpresion:cPrinterAlb
         ::nCopias      := Max( ::oFormatosImpresion:nCopiasAlb, 1 )

   otherwise
     
         if !::lValidatePreSave()
            MsgStop( "El documento no contiene líneas." )
            Return ( .t. )
         end if

         ::cFormato     := ::oFormatosImpresion:cFormatoTiket
         ::cImpresora   := ::oFormatosImpresion:cPrinterTik
         ::nCopias      := Max( ::oFormatosImpresion:nCopiasTik, 1 )

   end case

   ::nDispositivo    := IS_PRINTER
   ::lComanda        := .f.

   ::ImprimeDocumento()

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD PrevisualizaTicket()

  if !::lValidatePreSave()
     MsgStop( "El documento no contiene líneas." )
     Return ( Self )
  end if

  ::cFormato        := ::oFormatosImpresion:cFormatoTiket
  ::cImpresora      := ::oFormatosImpresion:cPrinterTik
  ::nDispositivo    := IS_SCREEN
  ::nCopias         := 1
  ::lComanda        := .f.

  ::ImprimeDocumento()

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD ImprimeEntrega()

  ::cFormato        := ::oFormatosImpresion:cFormatoEntrega
  ::cImpresora      := ::oFormatosImpresion:cPrinterEntrega
  ::nDispositivo    := IS_PRINTER
  ::nCopias         := Max( ::oFormatosImpresion:nCopiasEntrega, 1 )
  ::lComanda        := .f.

  ::ImprimeDocumento()

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD ImprimeRegalo()

  ::cFormato        := ::oFormatosImpresion:cFormatoRegalo
  ::cImpresora      := ::oFormatosImpresion:cPrinterRegalo
  ::nDispositivo    := IS_PRINTER
  ::nCopias         := Max( ::oFormatosImpresion:nCopiasRegalo, 1 )
  ::lComanda        := .f.

  ::ImprimeDocumento()

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD ImprimeDesglosado()

  ::cFormato        := ::oFormatosImpresion:cFmtFacCaj
  ::cImpresora      := ::oFormatosImpresion:cPrinterFacCaj
  ::nDispositivo    := IS_PRINTER
  ::nCopias         := 1
  ::lComanda        := .f.

  ::ImprimeDocumento()

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD SonidoComanda( cImpresora )

  local cWav        := AllTrim( cWavImpresoraComanda( oUser():cCaja(), cImpresora, ::oCajaLinea:cAlias ) )

  if !Empty( cWav ) .and. File( cWav )
     SndPlaySound( cWav )
  end if

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD ImprimeDocumento() CLASS TpvTactil

   CursorWait()

   if !::lComanda
      ::LoadTemporalImpresionlinea()
   end if

   if ::nTipoDocumento == documentoAlbaran

      ::DestroyFastReport()

      PrnAlbCli( ::cNumeroAlbaran, .f., "Imprimiendo albaranes", ::cFormato, ::cImpresora )

      ::InstanceFastReport()

   else

      if !empty( ::cImpresora )
         ::BuildReport()   
      end if 

   end if

   CursorWE()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ProcesaComandas( lCopia )

   local cImp
   local aImp           := {}
   local cWav           := ""
   local cOrden         := ""
   local lAppend        := .f.

   DEFAULT lCopia       := .f.

   if oUser():lNotImprimirComandas()
      Return ( Self )
   end if 

   // Matamos la temporal------------------------------------------------------

   ::oTemporalComanda:Zap()

   // Guaradamos la posicion del orden-----------------------------------------

   if ::oTiketLinea:Seek( ::cNumeroTicket() )

      while ( ::cNumeroTicketLinea() == ::cNumeroTicket() ) .and. !( ::oTiketLinea:Eof() )

         lAppend        := .f.

         if ( ::oTiketLinea:lControl )
            cOrden      := ::oTiketLinea:cNomTil
         end if 

         if ::isLineaValidaComanda( lCopia )

            // Impresora Uno---------------------------------------------------

            if ( !empty( ::oTiketLinea:cImpCom1 ) .and. alltrim( ::oTiketLinea:cImpCom1 ) != "No imprimir" )

               if aScan( aImp, ::oTiketLinea:cImpCom1 ) == 0
                  aAdd( aImp, ::oTiketLinea:cImpCom1 )
               end if

               lAppend  := .t.

            end if

            // Impresora Dos---------------------------------------------------

            if ( !empty( ::oTiketLinea:cImpCom2 ) .and. AllTrim( ::oTiketLinea:cImpCom2 ) != "No imprimir" )

               if aScan( aImp, ::oTiketLinea:cImpCom2 ) == 0
                  aAdd( aImp, ::oTiketLinea:cImpCom2 )
               end if

               lAppend  := .t.

            end if

            // Añadimos esta linea al temporal de comandas---------------------

            if lAppend

               ::oTemporalComanda:AppendFromObject( ::oTiketLinea )

               if !empty( cOrden )
                  ::oTemporalComanda:FieldPutByName( "cNomOrd", cOrden )
               end if 

               if !lCopia
                  ::oTemporalComanda:FieldPutByName( "nUntTil", ( ::nUnidadesLinea() - ::nUnidadesImpresas() ) )
               end if

               // Marcamos la linea como ya impresa en anulacion---------------

               ::SetLineaImpresa( .t. )

            end if

         end if

         // Siguiente linea----------------------------------------------------

         ::oTiketLinea:Skip()

      end while

   end if

   // Impimimos la comanda por las impresoras deseadas-------------------------

   for each cImp in aImp

      // Filtramos para que solo entren las comandas no impresas---------------

      ::oTemporalComanda:SetFilter( "rtrim( Field->cImpCom1 ) == '" + Rtrim( cImp ) + "' .or. rtrim( Field->cImpCom2 ) == '" + Rtrim( cImp ) + "'" )
      ::oTemporalComanda:GoTop()

      // Imprimimos la comanda por la impresora correspondiente-------------------

      ::ImprimeComanda( cImp )

      // Reproducimos el archivo Wav-------------------------------------------

      ::SonidoComanda( cImp )

      // Destruimos el filtro--------------------------------------------------

      ::oTemporalComanda:SetFilter()

   next

   // Matamos la temporal------------------------------------------------------

   ::oTemporalComanda:Zap()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ProcesaLineas()

   // Ponemos la marca para saber que el producto está imprimido---------------

   if ::oTiketLinea:Seek( ::cNumeroTicket() )
      while ( ::cNumeroTicketLinea() == ::cNumeroTicket() ) .and. !( ::oTiketLinea:Eof() )

         if ::oTiketLinea:lPeso
            ::oTiketLinea:fieldPutByName( "nImpCom", -1 )
         else 
            ::oTiketLinea:fieldPutByName( "nImpCom", ::nUnidadesLinea() )
         end if 
      
         ::oTiketLinea:Skip()
      
      end while
   end if

   // Lineas temporales-----------------------------------------------------
   // Esto hay q hacerlo para cuando se guarda sin salir del doc -----------

   ::oTemporalLinea:GetStatus()

   ::oTemporalLinea:goTop()
   while !::oTemporalLinea:eof()
      
      if ::oTemporalLinea:lPeso
         ::oTemporalLinea:fieldPutByName( "nImpCom", -1 )
      else 
         ::oTemporalLinea:fieldPutByName( "nImpCom", ::nUnidadesLinea( ::oTemporalLinea ) )
      end if 

      ::oTemporalLinea:Skip()

   end while

   ::oTemporalLinea:SetStatus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD OnClickCopiaComanda() CLASS TpvTactil

   if !( apoloMsgNoYes( "¿Desea enviar de nuevo la comanda completa?", "Confirme envio", .t. ) )
      Return ( Self )
   end if 

   ::DisableDialog()

   // Comprobamos si tenemos que imprimir la comanda---------------------------

   if !::lEmptyNumeroTicket()
      ::lCopiaComanda      := .t.
      ::ProcesaComandas( .t. )
      ::lCopiaComanda      := .f.
   end if 

   ::EnableDialog()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ProcesaAnulacion()

   local cImp
   local aImp           := {}
   local cWav           := ""
   local lAppend        := .f.

   // Matamos la temporal------------------------------------------------------

   ::oTemporalComanda:Zap()

   // Guaradamos la posicion del orden-----------------------------------------

   if ::oTiketLinea:Seek( ::cNumeroTicket() )

      while ( ::cNumeroTicketLinea() == ::cNumeroTicket() ) .and. !( ::oTiketLinea:Eof() )

         lAppend        := .f.

         if ( ( ::oTiketLinea:lDelTil ) .or. ( ::nUnidadesLinea() < 0 ) ) .and. ( ::lLineaImpresa() )

            // Impresora Uno---------------------------------------------------

            if !Empty( ::oTiketLinea:cImpCom1 ) .and. AllTrim( ::oTiketLinea:cImpCom1 ) != "No imprimir"

               if aScan( aImp, ::oTiketLinea:cImpCom1 ) == 0
                  aAdd( aImp, ::oTiketLinea:cImpCom1 )
               end if

               lAppend  := .t.

            end if

            // Impresora Dos---------------------------------------------------

            if !Empty( ::oTiketLinea:cImpCom2 ) .and. AllTrim( ::oTiketLinea:cImpCom2 ) != "No imprimir"

               if aScan( aImp, ::oTiketLinea:cImpCom2 ) == 0
                  aAdd( aImp, ::oTiketLinea:cImpCom2 )
               end if

               lAppend  := .t.

            end if

            // Añadimos esta linea al temporal de comandas---------------------

            if lAppend

               ::oTemporalComanda:AppendFromObject( ::oTiketLinea )

               // Quitamos la marca de impresa para que no se vuelva a imprimir-

               ::SetLineaImpresa( .f. )

            end if

         end if

         // Siguiente linea----------------------------------------------------

         ::oTiketLinea:Skip()

      end while

   end if

   // Impimimos la comanda por las impresoras deseadas-------------------------

   for each cImp in aImp

      // Filtramos para que solo entren las comandas no impresas---------------

      ::oTemporalComanda:SetFilter( "Rtrim( Field->cImpCom1 ) == '" + Rtrim( cImp ) + "' .or. Rtrim( Field->cImpCom2 ) == '" + Rtrim( cImp ) + "'" )
      ::oTemporalComanda:GoTop()

      // Imprimimos la comanda por la impresora correspondiente----------------

      ::ImprimeAnulacion( cImp )

      // Reproducimos el archivo Wav-------------------------------------------

      ::SonidoComanda( cImp )

      // Destruimos el filtro--------------------------------------------------

      ::oTemporalComanda:SetFilter()

   next

   // Matamos la temporal------------------------------------------------------

   ::oTemporalComanda:Zap()

   
Return ( Self )

//---------------------------------------------------------------------------//

METHOD OnClickGuardar() CLASS TpvTactil

   // Si el documento es nuevo y no tiene lineas no lo guardo------------------

   if !::lValidatePreSave()
      Return ( .f. )
   end if

   // Vamos a detectar si estoy en un General----------------------------------

   if ::lEmptyAlias() .and. !::SetAliasDocumento()
      Return ( .f. )
   end if

   ::DisableDialog()

   ::GuardaDocumento( .f. )

   // Mandamos las comandas a imprimir--------------------------------------------

   ::ProcesaDocumentosInternos()

   // Refrescamos las lineas para los elementos borrados-----------------------

   ::CargaDocumento( ::cNumeroTicket() )

   ::EnableDialog()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD BuildReport() CLASS TpvTactil

   SysRefresh()

   /*
   Zona de datos---------------------------------------------------------------
   */

   ::BuildRelationReport()

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if lExisteDocumento( ::cFormato, ::oDocument ) .and. !Empty( ::oDocument:mReport )

      ::oFastReport:LoadFromBlob( ::oDocument:nArea, "mReport")

      /*
      Zona de variables--------------------------------------------------------
      */

      ::VariableReport()

      /*
      Preparar el report-------------------------------------------------------
      */

      ::oFastReport:PrepareReport()

      /*
      Imprimir el informe------------------------------------------------------
      */

      // ::nDispositivo := IS_SCREEN

      do case
         case ::nDispositivo == IS_SCREEN

            ::oFastReport:ShowPreparedReport()

         case ::nDispositivo == IS_PRINTER

            ::oFastReport:PrintOptions:SetPrinter( ::cImpresora )
            ::oFastReport:PrintOptions:SetCopies( ::nCopias )
            ::oFastReport:PrintOptions:SetShowDialog( .f. )
            ::oFastReport:Print()

         case ::nDispositivo == IS_PDF

            ::oFastReport:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            ::oFastReport:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            ::oFastReport:SetProperty(  "PDFExport", "Outline",          .t. )
            ::oFastReport:DoExport(     "PDFExport" )

      end case

   end if

   ::ClearRelationReport()

Return .t.

//---------------------------------------------------------------------------//

METHOD DataReport() CLASS TpvTactil

   /*
   Zona de datos------------------------------------------------------------
   */

   ::oFastReport:ClearDataSets()

   ::oFastReport:SetWorkArea(       "Tickets", ::oTiketCabecera:nArea )
   ::oFastReport:SetFieldAliases(   "Tickets", cItemsToReport( aItmTik() ) )

   ::oFastReport:SetWorkArea(       "Albaranes", ::oAlbaranClienteCabecera:nArea )
   ::oFastReport:SetFieldAliases(   "Albaranes", cItemsToReport( aItmAlbCli() ) )

   ::oFastReport:SetWorkArea(       "Lineas de tickets", ::oTemporalImpresionLinea:nArea )
   ::oFastReport:SetFieldAliases(   "Lineas de tickets", cItemsToReport( aColTik() ) )

   ::oFastReport:SetWorkArea(       "Lineas de comandas", ::oTemporalComanda:nArea )
   ::oFastReport:SetFieldAliases(   "Lineas de comandas", cItemsToReport( aColTik() ) )

   ::oFastReport:SetWorkArea(       "Lineas de albaranes", ::oAlbaranClienteLinea:nArea )
   ::oFastReport:SetFieldAliases(   "Lineas de albaranes", cItemsToReport( aColAlbCli() ) )

   ::oFastReport:SetWorkArea(       "Lineas de facturas", ::oFacturaClienteLinea:nArea )
   ::oFastReport:SetFieldAliases(   "Lineas de facturas", cItemsToReport( aColFacCli() ) )

   ::oFastReport:SetWorkArea(       "Pagos de facturas", ::oFacturaClientePago:nArea )
   ::oFastReport:SetFieldAliases(   "Pagos de facturas", cItemsToReport( aItmRecCli() ) )

   ::oFastReport:SetWorkArea(       "Pagos de tickets", ::oTiketCobro:nArea )
   ::oFastReport:SetFieldAliases(   "Pagos de tickets", cItemsToReport( aPgoTik() ) )

   ::oFastReport:SetWorkArea(       "Empresa", ::oEmpresa:nArea )
   ::oFastReport:SetFieldAliases(   "Empresa", cItemsToReport( aItmEmp() ) )

   ::oFastReport:SetWorkArea(       "Clientes", ::oCliente:nArea )
   ::oFastReport:SetFieldAliases(   "Clientes", cItemsToReport( aItmCli() ) )

   ::oFastReport:SetWorkArea(       "Obras", ::oObras:nArea )
   ::oFastReport:SetFieldAliases(   "Obras",  cItemsToReport( aItmObr() ) )

   ::oFastReport:SetWorkArea(       "Almacenes", ::oAlmacen:nArea )
   ::oFastReport:SetFieldAliases(   "Almacenes", cItemsToReport( aItmAlm() ) )

   ::oFastReport:SetWorkArea(       "Rutas", ::oRuta:nArea )
   ::oFastReport:SetFieldAliases(   "Rutas", cItemsToReport( aItmRut() ) )

   ::oFastReport:SetWorkArea(       "Agentes", ::oAgentes:nArea )
   ::oFastReport:SetFieldAliases(   "Agentes", cItemsToReport( aItmAge() ) )

   ::oFastReport:SetWorkArea(       "Formas de pago", ::oFormaPago:nArea )
   ::oFastReport:SetFieldAliases(   "Formas de pago", cItemsToReport( aItmFPago() ) )

   ::oFastReport:SetWorkArea(       "Usuarios", ::oUsuario:nArea )
   ::oFastReport:SetFieldAliases(   "Usuarios", cItemsToReport( aItmUsuario() ) )

   ::oFastReport:SetWorkArea(       "Artículos", ::oArticulo:nArea )
   ::oFastReport:SetFieldAliases(   "Artículos", cItemsToReport( aItmArt() ) )

   ::oFastReport:SetWorkArea(       "Familias", ::oFamilias:nArea )
   ::oFastReport:SetFieldAliases(   "Familias", cItemsToReport( aItmFam() ) )

   ::oFastReport:SetWorkArea(       "Salaventa", ::oRestaurante:oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Salaventa", cObjectsToReport( ::oRestaurante:oDbf ) )

   ::oFastReport:SetWorkArea(       "Orden comanda", ::oOrdenComanda:oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Orden comanda", cObjectsToReport( ::oOrdenComanda:oDbf ) )

   ::oFastReport:SetWorkArea(       "Unidades de medición",  ::oUndMedicion:oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Unidades de medición",  cObjectsToReport( ::oUndMedicion:oDbf ) )

   ::oFastReport:SetWorkArea(       "Tipos de artículos",  ::oTipArt:oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Tipos de artículos",  cObjectsToReport( ::oTipArt:oDbf ) )

   ::oFastReport:SetWorkArea(       "Fabricantes",  ::oFabricante:oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Fabricantes",  cObjectsToReport( ::oFabricante:oDbf ) )

   ::oFastReport:SetWorkArea(       "Temporadas", ::oTemporadas:nArea )
   ::oFastReport:SetFieldAliases(   "Temporadas", cItemsToReport( aItmTemporada() ) )

   ::oFastReport:SetWorkArea(       "Entregas de albaranes", ::oAlbaranClientePago:nArea )
   ::oFastReport:SetFieldAliases(   "Entregas de albaranes", cItemsToReport( aItmAlbPgo() ) )

   ::oFastReport:SetWorkArea(       "Incidencias de albaranes", ::oAlbaranClienteIncidencia:nArea )
   ::oFastReport:SetFieldAliases(   "Incidencias de albaranes", cItemsToReport( aIncAlbCli() ) )

   ::oFastReport:SetWorkArea(       "Documentos de albaranes", ::oAlbaranClienteDocumento:nArea )
   ::oFastReport:SetFieldAliases(   "Documentos de albaranes", cItemsToReport( aAlbCliDoc() ) )

   ::oFastReport:SetWorkArea(       "Transportistas", ::oTransportista:Select() )
   ::oFastReport:SetFieldAliases(   "Transportistas", cObjectsToReport( ::oTransportista:oDbf ) )

   ::oFastReport:SetWorkArea(       "Ofertas", ::oArticulosOfertas:nArea )
   ::oFastReport:SetFieldAliases(   "Ofertas", cItemsToReport( aItmOfe() ) )

   ::oFastReport:SetWorkArea(       "Series de lineas de albaranes", ::oAlbaranClienteSerie:nArea )
   ::oFastReport:SetFieldAliases(   "Series de lineas de albaranes", cItemsToReport( aSerAlbCli() ) )

   ::oFastReport:SetWorkArea(       "Propiedades", ::oPropiedadesLinea:nArea )
   ::oFastReport:SetFieldAliases(   "Propiedades", cItemsToReport( aItmPro() ) )

   ::oFastReport:SetWorkArea(       "Impuestos especiales",  ::oNewImp:Select() )
   ::oFastReport:SetFieldAliases(   "Impuestos especiales",  cObjectsToReport( ::oNewImp:oDbf ) )

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD BuildRelationReport() CLASS TpvTactil

   do case
      case ::nTipoDocumento == documentoAlbaran    //Creamos las relaciones para los tikets como albaranes

         ::oFastReport:SetWorkArea( "Albaranes", ::oAlbaranClienteCabecera:nArea, .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )

         ::oFastReport:SetMasterDetail( "Albaranes", "Lineas de albaranes",              {|| ::oAlbaranClienteCabecera:cSerAlb + Str( ::oAlbaranClienteCabecera:nNumAlb ) + ::oAlbaranClienteCabecera:cSufAlb } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Entregas de albaranes",            {|| ::oAlbaranClienteCabecera:cSerAlb + Str( ::oAlbaranClienteCabecera:nNumAlb ) + ::oAlbaranClienteCabecera:cSufAlb } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Incidencias de albaranes",         {|| ::oAlbaranClienteCabecera:cSerAlb + Str( ::oAlbaranClienteCabecera:nNumAlb ) + ::oAlbaranClienteCabecera:cSufAlb } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Documentos de albaranes",          {|| ::oAlbaranClienteCabecera:cSerAlb + Str( ::oAlbaranClienteCabecera:nNumAlb ) + ::oAlbaranClienteCabecera:cSufAlb } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Series de lineas de albaranes",    {|| ::oAlbaranClienteCabecera:cSerAlb + Str( ::oAlbaranClienteCabecera:nNumAlb ) + ::oAlbaranClienteCabecera:cSufAlb } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Clientes",                         {|| ::oAlbaranClienteCabecera:cCodCli } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Obras",                            {|| ::oAlbaranClienteCabecera:cCodCli + ::oAlbaranClienteCabecera:cCodObr } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Almacenes",                        {|| ::oAlbaranClienteCabecera:cCodAlm } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Rutas",                            {|| ::oAlbaranClienteCabecera:cCodRut } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Agentes",                          {|| ::oAlbaranClienteCabecera:cCodAge } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Formas de pago",                   {|| ::oAlbaranClienteCabecera:cCodPago } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Transportistas",                   {|| ::oAlbaranClienteCabecera:cCodTrn } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Empresa",                          {|| cCodigoEmpresaEnUso() } )
         ::oFastReport:SetMasterDetail( "Albaranes", "Usuarios",                         {|| ::oAlbaranClienteCabecera:cCodUsr } )

         ::oFastReport:SetMasterDetail( "Lineas de albaranes", "Artículos",              {|| ::oAlbaranClienteLinea:cRef } )
         ::oFastReport:SetMasterDetail( "Lineas de albaranes", "Tipo de venta",          {|| ::oAlbaranClienteLinea:cTipMov } )
         ::oFastReport:SetMasterDetail( "Lineas de albaranes", "Ofertas",                {|| ::oAlbaranClienteLinea:cRef } )
         ::oFastReport:SetMasterDetail( "Lineas de albaranes", "Unidades de medición",   {|| ::oAlbaranClienteLinea:cUnidad } )
         // ::oFastReport:SetMasterDetail( "Lineas de albaranes", "Propiedades",            {|| ::oAlbaranClienteLinea:cCodPr1 + ::oAlbaranClienteLinea:cValPr1 } )
         // ::oFastReport:SetMasterDetail( "Lineas de albaranes", "Impuestos especiales",   {|| ::oAlbaranClienteLinea:cCodImp } )

         //------------------------------------------------------------------------//

         ::oFastReport:SetResyncPair( "Albaranes", "Lineas de albaranes" )
         ::oFastReport:SetResyncPair( "Albaranes", "Entregas de albaranes" )
         ::oFastReport:SetResyncPair( "Albaranes", "Incidencias de albaranes" )
         ::oFastReport:SetResyncPair( "Albaranes", "Documentos de albaranes" )
         ::oFastReport:SetResyncPair( "Albaranes", "Series de lineas de albaranes" )
         ::oFastReport:SetResyncPair( "Albaranes", "Clientes" )
         ::oFastReport:SetResyncPair( "Albaranes", "Obras" )
         ::oFastReport:SetResyncPair( "Albaranes", "Almacenes" )
         ::oFastReport:SetResyncPair( "Albaranes", "Rutas" )
         ::oFastReport:SetResyncPair( "Albaranes", "Agentes" )
         ::oFastReport:SetResyncPair( "Albaranes", "Formas de pago" )
         ::oFastReport:SetResyncPair( "Albaranes", "Transportistas" )
         ::oFastReport:SetResyncPair( "Albaranes", "Empresa" )
         ::oFastReport:SetResyncPair( "Albaranes", "Usuarios" )

         ::oFastReport:SetResyncPair( "Lineas de albaranes", "Artículos" )
         ::oFastReport:SetResyncPair( "Lineas de albaranes", "Tipo de venta" )
         ::oFastReport:SetResyncPair( "Lineas de albaranes", "Ofertas" )
         ::oFastReport:SetResyncPair( "Lineas de albaranes", "Unidades de medición" )
         // ::oFastReport:SetResyncPair( "Lineas de albaranes", "Propiedades" )
         // ::oFastReport:SetResyncPair( "Lineas de albaranes", "Impuestos especiales" )

      otherwise

         ::oFastReport:SetWorkArea( "Tickets", ::oTiketCabecera:nArea, .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )

         ::oFastReport:SetMasterDetail( "Tickets", "Empresa",            {|| cCodigoEmpresaEnUso() } )
         ::oFastReport:SetMasterDetail( "Tickets", "Lineas de tickets",  {|| ::oTiketCabecera:cSerTik + ::oTiketCabecera:cNumTik + ::oTiketCabecera:cSufTik } )
         ::oFastReport:SetMasterDetail( "Tickets", "Lineas de albaranes",{|| ::oTiketCabecera:cNumDoc } )
         ::oFastReport:SetMasterDetail( "Tickets", "Lineas de facturas", {|| ::oTiketCabecera:cNumDoc } )
         ::oFastReport:SetMasterDetail( "Tickets", "Lineas de comandas", {|| ::oTiketCabecera:cSerTik + ::oTiketCabecera:cNumTik + ::oTiketCabecera:cSufTik } )
         ::oFastReport:SetMasterDetail( "Tickets", "Pagos de tickets",   {|| ::oTiketCabecera:cSerTik + ::oTiketCabecera:cNumTik + ::oTiketCabecera:cSufTik } )
         ::oFastReport:SetMasterDetail( "Tickets", "Clientes",           {|| ::oTiketCabecera:cCliTik } )
         ::oFastReport:SetMasterDetail( "Tickets", "Obras",              {|| ::oTiketCabecera:cCliTik + ::oTiketCabecera:cCodObr } )
         ::oFastReport:SetMasterDetail( "Tickets", "Almacen",            {|| ::oTiketCabecera:cAlmTik } )
         ::oFastReport:SetMasterDetail( "Tickets", "Rutas",              {|| ::oTiketCabecera:cCodRut } )
         ::oFastReport:SetMasterDetail( "Tickets", "Agentes",            {|| ::oTiketCabecera:cCodAge } )
         ::oFastReport:SetMasterDetail( "Tickets", "Usuarios",           {|| ::oTiketCabecera:cCcjTik } )
         ::oFastReport:SetMasterDetail( "Tickets", "SalaVenta",          {|| ::oTiketCabecera:cCodSala } )

         if ::lComanda

         ::oFastReport:SetMasterDetail( "Lineas de comandas", "Artículos",             {|| ::oTemporalComanda:cCbaTil } )
         ::oFastReport:SetMasterDetail( "Lineas de comandas", "Familia",               {|| ::oTemporalComanda:cFamTil } )
         ::oFastReport:SetMasterDetail( "Lineas de comandas", "Unidades de medición",  {|| ::oTemporalComanda:cUnidad } )
         ::oFastReport:SetMasterDetail( "Lineas de comandas", "Categorías",            {|| RetFld( ::oTemporalComanda:cCbaTil, ::oArticulo:cAlias, "cCodCate" ) } )
         ::oFastReport:SetMasterDetail( "Lineas de comandas", "Tipos de artículos",    {|| RetFld( ::oTemporalComanda:cCbaTil, ::oArticulo:cAlias, "cCodTip" ) } )
         ::oFastReport:SetMasterDetail( "Lineas de comandas", "Fabricantes",           {|| RetFld( ::oTemporalComanda:cCbaTil, ::oArticulo:cAlias, "cCodFab" ) } )
         ::oFastReport:SetMasterDetail( "Lineas de comandas", "Temporadas",            {|| RetFld( ::oTemporalComanda:cCbaTil, ::oArticulo:cAlias, "cCodTemp" ) } )
         ::oFastReport:SetMasterDetail( "Lineas de comandas", "Orden comanda",         {|| ::oTemporalComanda:cOrdOrd } )
         // ::oFastReport:SetMasterDetail( "Lineas de comandas", "Propiedades",           {|| ::oTemporalComanda:cCodPr1 } )
         //:oFastReport:SetMasterDetail( "Lineas de comandas", "Impuestos especiales",  {|| ::oTemporalComanda:cCodImp } )

         else

         ::oFastReport:SetMasterDetail( "Lineas de tickets", "Artículos",              {|| ::oTemporalImpresionLinea:cCbaTil } )
         ::oFastReport:SetMasterDetail( "Lineas de tickets", "Familia",                {|| ::oTemporalImpresionLinea:cFamTil } )
         ::oFastReport:SetMasterDetail( "Lineas de tickets", "Unidades de medición",   {|| ::oTemporalImpresionLinea:cUnidad } )
         ::oFastReport:SetMasterDetail( "Lineas de tickets", "Categorías",             {|| RetFld( ::oTemporalImpresionLinea:cCbaTil, ::oArticulo:cAlias, "cCodCate" ) } )
         ::oFastReport:SetMasterDetail( "Lineas de tickets", "Tipos de artículos",     {|| RetFld( ::oTemporalImpresionLinea:cCbaTil, ::oArticulo:cAlias, "cCodTip" ) } )
         ::oFastReport:SetMasterDetail( "Lineas de tickets", "Fabricantes",            {|| RetFld( ::oTemporalImpresionLinea:cCbaTil, ::oArticulo:cAlias, "cCodFab" ) } )
         ::oFastReport:SetMasterDetail( "Lineas de tickets", "Temporadas",             {|| RetFld( ::oTemporalImpresionLinea:cCbaTil, ::oArticulo:cAlias, "cCodTemp" ) } )
         // ::oFastReport:SetMasterDetail( "Lineas de tickets", "Propiedades",            {|| ::oTiketLinea:cCodPr1 + ::oTiketLinea:cValPr1 } )
         // ::oFastReport:SetMasterDetail( "Lineas de tickets", "Impuestos especiales",   {|| ::oTiketLinea:cCodImp } )

         end if 

         ::oFastReport:SetMasterDetail( "Pagos de tickets", "Formas de pago",          {|| ::oTiketCobro:cFpgPgo } )

         //------------------------------------------------------------------------//

         ::oFastReport:SetResyncPair(  "Tickets", "Lineas de tickets" )
         ::oFastReport:SetResyncPair(  "Tickets", "Lineas de comandas" )
         ::oFastReport:SetResyncPair(  "Tickets", "Lineas de albaranes" )
         ::oFastReport:SetResyncPair(  "Tickets", "Lineas de facturas" )
         ::oFastReport:SetResyncPair(  "Tickets", "Pagos de tickets" )
         ::oFastReport:SetResyncPair(  "Tickets", "Empresa" )
         ::oFastReport:SetResyncPair(  "Tickets", "Clientes" )
         ::oFastReport:SetResyncPair(  "Tickets", "Obras" )
         ::oFastReport:SetResyncPair(  "Tickets", "Almacenes" )
         ::oFastReport:SetResyncPair(  "Tickets", "Rutas" )
         ::oFastReport:SetResyncPair(  "Tickets", "Agentes" )
         ::oFastReport:SetResyncPair(  "Tickets", "Usuarios" )
         ::oFastReport:SetResyncPair(  "Tickets", "SalaVenta" )

         if ::lComanda

         ::oFastReport:SetResyncPair(  "Lineas de comandas", "Artículos" )
         ::oFastReport:SetResyncPair(  "Lineas de comandas", "Familias" )
         ::oFastReport:SetResyncPair(  "Lineas de comandas", "Orden comanda" )
         ::oFastReport:SetResyncPair(  "Lineas de comandas", "Unidades de medición" )
         ::oFastReport:SetResyncPair(  "Lineas de comandas", "Categorías" )
         ::oFastReport:SetResyncPair(  "Lineas de comandas", "Tipos de artículos" )
         ::oFastReport:SetResyncPair(  "Lineas de comandas", "Fabricantes" )
         ::oFastReport:SetResyncPair(  "Lineas de comandas", "Temporadas" )
         // ::oFastReport:SetResyncPair(  "Lineas de comandas", "Propiedades" )
         // ::oFastReport:SetResyncPair(  "Lineas de comandas", "Impuestos especiales" )

         else 

         ::oFastReport:SetResyncPair(  "Lineas de tickets", "Artículos" )
         ::oFastReport:SetResyncPair(  "Lineas de tickets", "Familias" )
         ::oFastReport:SetResyncPair(  "Lineas de tickets", "Orden comanda" )
         ::oFastReport:SetResyncPair(  "Lineas de tickets", "Unidades de medición" )
         ::oFastReport:SetResyncPair(  "Lineas de tickets", "Categorías" )
         ::oFastReport:SetResyncPair(  "Lineas de tickets", "Tipos de artículos" )
         ::oFastReport:SetResyncPair(  "Lineas de tickets", "Fabricantes" )
         ::oFastReport:SetResyncPair(  "Lineas de tickets", "Temporadas" )
         // ::oFastReport:SetResyncPair(  "Lineas de tickets", "Propiedades" )
         // ::oFastReport:SetResyncPair(  "Lineas de tickets", "Impuestos especiales" )

         end if 

         ::oFastReport:SetResyncPair(  "Pagos de tickets", "Formas de pago" )

   end case

Return nil

//---------------------------------------------------------------------------//

METHOD ClearRelationReport() CLASS TpvTactil

   do case
      case ::nTipoDocumento == documentoAlbaran    //Creamos las relaciones para los tikets como albaranes
   
         ::oFastReport:ClearMasterDetail( "Lineas de albaranes" )
         ::oFastReport:ClearMasterDetail( "Entregas de albaranes" )
         ::oFastReport:ClearMasterDetail( "Incidencias de albaranes" )
         ::oFastReport:ClearMasterDetail( "Documentos de albaranes" )
         ::oFastReport:ClearMasterDetail( "Series de lineas de albaranes" )
         ::oFastReport:ClearMasterDetail( "Clientes" )
         ::oFastReport:ClearMasterDetail( "Obras" )
         ::oFastReport:ClearMasterDetail( "Almacenes" )
         ::oFastReport:ClearMasterDetail( "Rutas" )
         ::oFastReport:ClearMasterDetail( "Agentes" )
         ::oFastReport:ClearMasterDetail( "Formas de pago" )
         ::oFastReport:ClearMasterDetail( "Transportistas" )
         ::oFastReport:ClearMasterDetail( "Empresa" )
         ::oFastReport:ClearMasterDetail( "Usuarios" )
         ::oFastReport:ClearMasterDetail( "Artículos" )
         ::oFastReport:ClearMasterDetail( "Tipo de venta" )
         ::oFastReport:ClearMasterDetail( "Ofertas" )
         ::oFastReport:ClearMasterDetail( "Unidades de medición" )
   
         ::oFastReport:ClearResyncPair( "Albaranes", "Lineas de albaranes" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Entregas de albaranes" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Incidencias de albaranes" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Documentos de albaranes" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Series de lineas de albaranes" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Clientes" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Obras" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Almacenes" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Rutas" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Agentes" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Formas de pago" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Transportistas" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Empresa" )
         ::oFastReport:ClearResyncPair( "Albaranes", "Usuarios" )
         ::oFastReport:ClearResyncPair( "Lineas de albaranes", "Artículos" )
         ::oFastReport:ClearResyncPair( "Lineas de albaranes", "Tipo de venta" )
         ::oFastReport:ClearResyncPair( "Lineas de albaranes", "Ofertas" )
         ::oFastReport:ClearResyncPair( "Lineas de albaranes", "Unidades de medición" )
         // ::oFastReport:ClearResyncPair( "Lineas de albaranes", "Propiedades" )
         // ::oFastReport:ClearResyncPair( "Lineas de albaranes", "Impuestos especiales" )
   
      otherwise
   
         ::oFastReport:ClearMasterDetail( "Empresa" )
         ::oFastReport:ClearMasterDetail( "Lineas de tickets" )
         ::oFastReport:ClearMasterDetail( "Lineas de comandas" )
         ::oFastReport:ClearMasterDetail( "Lineas de albaranes" )
         ::oFastReport:ClearMasterDetail( "Lineas de facturas" )
         ::oFastReport:ClearMasterDetail( "Pagos de tickets" )
         ::oFastReport:ClearMasterDetail( "Clientes" )
         ::oFastReport:ClearMasterDetail( "Obras" )
         ::oFastReport:ClearMasterDetail( "Almacen" )
         ::oFastReport:ClearMasterDetail( "Rutas" )
         ::oFastReport:ClearMasterDetail( "Agentes" )
         ::oFastReport:ClearMasterDetail( "Usuarios" )
         ::oFastReport:ClearMasterDetail( "SalaVenta" )
   
         ::oFastReport:ClearMasterDetail( "Artículos" )
         ::oFastReport:ClearMasterDetail( "Familia" )
         ::oFastReport:ClearMasterDetail( "Unidades de medición" )
         ::oFastReport:ClearMasterDetail( "Categorías" )
         ::oFastReport:ClearMasterDetail( "Tipos de artículos" )
         ::oFastReport:ClearMasterDetail( "Fabricantes" )
         ::oFastReport:ClearMasterDetail( "Temporadas" )
         ::oFastReport:ClearMasterDetail( "Orden comanda" )
   
         ::oFastReport:ClearMasterDetail( "Formas de pago" )
   
         //------------------------------------------------------------------------//
   
         ::oFastReport:ClearResyncPair(  "Tickets", "Lineas de tickets" )
         ::oFastReport:ClearResyncPair(  "Tickets", "Lineas de comandas" )
         ::oFastReport:ClearResyncPair(  "Tickets", "Lineas de albaranes" )
         ::oFastReport:ClearResyncPair(  "Tickets", "Lineas de facturas" )
         ::oFastReport:ClearResyncPair(  "Tickets", "Empresa" )
         ::oFastReport:ClearResyncPair(  "Tickets", "Clientes" )
         ::oFastReport:ClearResyncPair(  "Tickets", "Obras" )
         ::oFastReport:ClearResyncPair(  "Tickets", "Almacenes" )
         ::oFastReport:ClearResyncPair(  "Tickets", "Rutas" )
         ::oFastReport:ClearResyncPair(  "Tickets", "Agentes" )
         ::oFastReport:ClearResyncPair(  "Tickets", "Usuarios" )
         ::oFastReport:ClearResyncPair(  "Tickets", "SalaVenta" )
   
         ::oFastReport:ClearResyncPair(  "Pagos de tickets", "Formas de pago" )
   
         if ::lComanda
   
            ::oFastReport:ClearResyncPair(  "Lineas de comandas", "Artículos" )
            ::oFastReport:ClearResyncPair(  "Lineas de comandas", "Familias" )
            ::oFastReport:ClearResyncPair(  "Lineas de comandas", "Orden comanda" )
            ::oFastReport:ClearResyncPair(  "Lineas de comandas", "Unidades de medición" )
            ::oFastReport:ClearResyncPair(  "Lineas de comandas", "Categorías" )
            ::oFastReport:ClearResyncPair(  "Lineas de comandas", "Tipos de artículos" )
            ::oFastReport:ClearResyncPair(  "Lineas de comandas", "Fabricantes" )
            ::oFastReport:ClearResyncPair(  "Lineas de comandas", "Temporadas" )
            // ::oFastReport:ClearResyncPair(  "Lineas de comandas", "Propiedades" )
            // ::oFastReport:ClearResyncPair(  "Lineas de comandas", "Impuestos especiales" )
   
         else 
   
            ::oFastReport:ClearResyncPair(  "Lineas de tickets", "Artículos" )
            ::oFastReport:ClearResyncPair(  "Lineas de tickets", "Familias" )
            ::oFastReport:ClearResyncPair(  "Lineas de tickets", "Orden comanda" )
            ::oFastReport:ClearResyncPair(  "Lineas de tickets", "Unidades de medición" )
            ::oFastReport:ClearResyncPair(  "Lineas de tickets", "Categorías" )
            ::oFastReport:ClearResyncPair(  "Lineas de tickets", "Tipos de artículos" )
            ::oFastReport:ClearResyncPair(  "Lineas de tickets", "Fabricantes" )
            ::oFastReport:ClearResyncPair(  "Lineas de tickets", "Temporadas" )
            // ::oFastReport:ClearResyncPair(  "Lineas de tickets", "Propiedades" )
            // ::oFastReport:ClearResyncPair(  "Lineas de tickets", "Impuestos especiales" )
   
         end if

   end case    

Return nil

//---------------------------------------------------------------------------//


METHOD VariableReport() CLASS TpvTactil

   do case
      case ::nTipoDocumento == documentoAlbaran    //Creamos las relaciones para los tikets como albaranes

         ::oFastReport:DeleteCategory(  "Albaranes" )
         ::oFastReport:DeleteCategory(  "Lineas de albaranes" )

         /*
         Creación de variables----------------------------------------------------
         */

         ::oFastReport:AddVariable(     "Albaranes",             "Total albarán",                     "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalDocumento' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Total descuento general",           "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalDescuentoGeneral' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Total descuento pronto pago",       "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalDescuentoProntoPago' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Total descuento",                   "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalDescuento()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Bruto primer tipo de " + cImp(),    "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalPrimerBruto()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Bruto segundo tipo de " + cImp(),   "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalSegundoBruto()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Bruto tercer tipo de " + cImp(),    "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalTercerBruto()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Total bruto",                       "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'TotalBruto()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Base primer tipo de " + cImp(),     "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalPrimeraBase()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Base segundo tipo de " + cImp(),    "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalSegundaBase()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Base tercer tipo de " + cImp(),     "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalTerceraBase()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Total neto",                        "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'TotalBase()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Porcentaje primer tipo " + cImp(),  "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nPorcentajePrimerIva()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Porcentaje segundo tipo " + cImp(), "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nPorcentajeSegundoIva()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Porcentaje tercer tipo " + cImp(),  "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nPorcentajeTercerIva()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Importe primer tipo " + cImp(),     "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalPrimerIva()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Importe segundo tipo " + cImp(),    "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalSegundoIva()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Importe tercer tipo " + cImp(),     "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalTercerIva()' ] )" )
         ::oFastReport:AddVariable(     "Albaranes",             "Total " + cImp(),                   "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'TotalIVA()' ] )" )

         ::oFastReport:AddVariable(     "Lineas de albaranes",   "Detalle del artículo",              "CallHbFunc( 'oTpvTactil', [ 'GetLineaAlbaranes' ,'{|u|cDesAlbCli(u)}'  ])" )
         ::oFastReport:AddVariable(     "Lineas de albaranes",   "Total unidades artículo",           "CallHbFunc( 'oTpvTactil', [ 'GetLineaAlbaranes' ,'{|u|nTotNAlbCli(u)}' ])" )
         ::oFastReport:AddVariable(     "Lineas de albaranes",   "Precio unitario del artículo",      "CallHbFunc( 'oTpvTactil', [ 'GetLineaAlbaranes' ,'{|u|nTotUAlbCli(u)}' ])" )
         ::oFastReport:AddVariable(     "Lineas de albaranes",   "Total línea de albaran",            "CallHbFunc( 'oTpvTactil', [ 'GetLineaAlbaranes' ,'{|u|nTotLAlbCli(u)}' ])" )
         ::oFastReport:AddVariable(     "Lineas de albaranes",   "Total línea sin " + cImp(),         "CallHbFunc( 'oTpvTactil', [ 'GetLineaAlbaranes' ,'{|u|nNetLAlbCli(u)}' ])" )
         ::oFastReport:AddVariable(     "Lineas de albaranes",   "Total peso por línea",              "CallHbFunc( 'oTpvTactil', [ 'GetLineaAlbaranes' ,'{|u|nPesLAlbCli(u)}' ])" )

      otherwise

         ::oFastReport:DeleteCategory(  "Tickets" )
         ::oFastReport:DeleteCategory(  "Lineas de tickets" )
         ::oFastReport:DeleteCategory(  "Lineas de comandas" )
         ::oFastReport:DeleteCategory(  "Lineas de albaranes" )
         ::oFastReport:DeleteCategory(  "Lineas de facturas" )

         /*
         Creación de variables----------------------------------------------------
         */

         ::oFastReport:AddVariable(     "Tickets",             "Ubicación del ticket",              "CallHbFunc( 'oTpvTactil', [ 'cTxtUbicacion()' ] )" )

         ::oFastReport:AddVariable(     "Tickets",             "Copia comanda",                     "CallHbFunc( 'oTpvTactil', [ 'lCopiaComanda()' ] )" )

         ::oFastReport:AddVariable(     "Tickets",             "Total ticket",                      "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalDocumento' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Precio por pax.",                   "CallHbFunc( 'oTpvTactil', [ 'nPrecioPorPersona()' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Total descuento general",           "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalDescuentoGeneral' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Total descuento pronto pago",       "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalDescuentoProntoPago' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Total descuento",                   "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalDescuento()' ] )" )

         ::oFastReport:AddVariable(     "Tickets",             "Bruto primer tipo de " + cImp(),    "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalPrimerBruto()' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Bruto segundo tipo de " + cImp(),   "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalSegundoBruto()' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Bruto tercer tipo de " + cImp(),    "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalTercerBruto()' ] )" )

         ::oFastReport:AddVariable(     "Tickets",             "Total bruto",                       "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'TotalBruto()' ] )" )

         ::oFastReport:AddVariable(     "Tickets",             "Base primer tipo de " + cImp(),     "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalPrimeraBase()' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Base segundo tipo de " + cImp(),    "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalSegundaBase()' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Base tercer tipo de " + cImp(),     "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalTerceraBase()' ] )" )

         ::oFastReport:AddVariable(     "Tickets",             "Total neto",                        "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'TotalBase()' ] )" )

         ::oFastReport:AddVariable(     "Tickets",             "Porcentaje primer tipo " + cImp(),  "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nPorcentajePrimerIva()' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Porcentaje segundo tipo " + cImp(), "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nPorcentajeSegundoIva()' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Porcentaje tercer tipo " + cImp(),  "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nPorcentajeTercerIva()' ] )" )

         ::oFastReport:AddVariable(     "Tickets",             "Importe primer tipo " + cImp(),     "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalPrimerIva()' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Importe segundo tipo " + cImp(),    "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalSegundoIva()' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Importe tercer tipo " + cImp(),     "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalTercerIva()' ] )" )

         ::oFastReport:AddVariable(     "Tickets",             "Total " + cImp(),                   "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'TotalIVA()' ] )" )

         ::oFastReport:AddVariable(     "Tickets",             "Importe primer tipo IVMH",          "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalPrimerImpuestoHidrocarburos()' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Importe segundo tipo IVMH",         "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalSegundoImpuestoHidrocarburos()' ] )" )
         ::oFastReport:AddVariable(     "Tickets",             "Importe tercer tipo IVMH",          "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'nTotalTercerImpuestoHidrocarburos()' ] )" )

         ::oFastReport:AddVariable(     "Tickets",             "Total IVMH",                        "CallHbFunc( 'oTpvTactil', [ 'GetTotalDocumento', 'TotalImpuestoHidrocarburos()' ] )" )

         ::oFastReport:AddVariable(     "Lineas de tickets",   "Detalle del artículo en ticket",               "CallHbFunc( 'oTpvTactil', [ 'cTextoLineaTicketTemp()' ] )" )
         ::oFastReport:AddVariable(     "Lineas de tickets",   "Detalle del ticket en distinto idioma",        "CallHbFunc( 'oTpvTactil', [ 'cTextoLineaTicketLengTemp()' ] )" ) 
         ::oFastReport:AddVariable(     "Lineas de tickets",   "Total unidades artículo",                      "CallHbFunc( 'oTpvTactil', [ 'nUnidadesLineaTemp()' ] )" )
         ::oFastReport:AddVariable(     "Lineas de tickets",   "Precio unitario del artículo",                 "CallHbFunc( 'oTpvTactil', [ 'nPrecioLineaTemp()' ] )" )
         ::oFastReport:AddVariable(     "Lineas de tickets",   "Total línea de factura",                       "CallHbFunc( 'oTpvTactil', [ 'nTotalLineaTemp()' ] )" )

         ::oFastReport:AddVariable(     "Lineas de tickets",   "Precio unitario con descuentos",               "CallHbFunc('nNetLTpv')" )
         ::oFastReport:AddVariable(     "Lineas de tickets",   "Importe descuento línea del factura",          "CallHbFunc('nDtoUTpv')" )
         ::oFastReport:AddVariable(     "Lineas de tickets",   "Total " + cImp() + " línea de factura",        "CallHbFunc('nIvaLTpv')" )
         ::oFastReport:AddVariable(     "Lineas de tickets",   "Total IVMH línea de factura",                  "CallHbFunc('nIvmLTpv')" )

         ::oFastReport:AddVariable(     "Lineas de comandas",  "Total unidades en comanda",                    "CallHbFunc( 'oTpvTactil', [ 'nUnidadesLineaComanda()' ] )" )
         ::oFastReport:AddVariable(     "Lineas de comandas",  "Total unidades impresas en comanda",           "CallHbFunc( 'oTpvTactil', [ 'nUnidadesImpresasComanda()' ] )" )

         ::oFastReport:AddVariable(     "Lineas de comandas",  "Detalle del artículo en comanda",              "CallHbFunc( 'oTpvTactil', [ 'cDetalleComanda()' ] )" )
         ::oFastReport:AddVariable(     "Lineas de comandas",  "Descripción del artículo en comanda",          "CallHbFunc( 'oTpvTactil', [ 'cDescripcionComanda()' ] )" )
         ::oFastReport:AddVariable(     "Lineas de comandas",  "Comentario del artículo en comanda",           "CallHbFunc( 'oTpvTactil', [ 'cComentarioComanda()' ] )" )

         ::oFastReport:AddVariable(     "Lineas de albaranes", "Detalle del artículo del albarán",             "CallHbFunc('cTpvDesAlbCli')"  )
         ::oFastReport:AddVariable(     "Lineas de albaranes", "Detalle del albarán en distinto idioma",       "CallHbFunc('cTpvDesAlbCliLeng')"  )
         ::oFastReport:AddVariable(     "Lineas de albaranes", "Total unidades artículo del albarán",          "CallHbFunc('nTpvTotNAlbCli')" )
         ::oFastReport:AddVariable(     "Lineas de albaranes", "Precio unitario del artículo del albarán",     "CallHbFunc('nTpvTotUAlbCli')" )
         ::oFastReport:AddVariable(     "Lineas de albaranes", "Total línea de albarán",                       "CallHbFunc('nTpvTotLAlbCli')" )

         ::oFastReport:AddVariable(     "Lineas de facturas",  "Detalle del artículo de la factura",           "CallHbFunc('cTpvDesFacCli')" )
         ::oFastReport:AddVariable(     "Lineas de facturas",  "Detalle de la factura en distinto idioma",     "CallHbFunc('cTpvDesFacCliLeng')" )
         ::oFastReport:AddVariable(     "Lineas de facturas",  "Total unidades artículo de la factura",        "CallHbFunc('nTpvTotNFacCli')" )
         ::oFastReport:AddVariable(     "Lineas de facturas",  "Precio unitario del artículo de la factura",   "CallHbFunc('nTpvTotUFacCli')" )
         ::oFastReport:AddVariable(     "Lineas de facturas",  "Total línea de factura.",                      "CallHbFunc('nTpvTotLFacCli')" )

   end case

   Return nil

//---------------------------------------------------------------------------//

Function oTpvTactil( cMsg, u1, u2, u3, u4, u5, u6, u7, u8, u9, u10 )

   local uReturn  := ""

   if !Empty( oThis ) .and. !Empty( cMsg )
      uReturn     := oSend( oThis, cMsg, u1, u2, u3, u4, u5, u6, u7, u8, u9, u10 )
   end if

Return ( uReturn )   

//---------------------------------------------------------------------------//

METHOD GeneraVale() CLASS TpvTactil

   local oError
   local oBlock
   local cNumeroTicket
   local cValeTicket
   local lValePromocion
   local nValePromocion             := 0
   local nPorcentajePromocion       := 0

   if lImporteExacto()
      Return ( .f. ) 
   end if   

   if Empty( ::oTiketCabecera:cCliTik )
      Return ( .f. )
   end if

   /*
   Capturanmos el porcentaje de promoción--------------------------------------
   */

   nPorcentajePromocion             := ::oFideliza:nPorcentajePrograma( ::sTotal:nPromocion )

   if ( nPorcentajePromocion == 0 )
      Return ( .f. )
   end if

   if ( ::sTotal:nPromocion == 0 )
      Return ( .f. )
   end if

   ::DisableDialog()
   
   oBlock                           := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      cNumeroTicket                 := ::cNumeroTicket()

      lValePromocion                := !oRetFld( ::oTiketCabecera:cCliTik, ::oCliente, "lExcFid" )
      if lValePromocion
         nValePromocion             := Round( ::sTotal:nPromocion * nPorcentajePromocion / 100, ::nDecimalesTotal )
      end if

      cValeTicket                   := ::cValeTicket( cNumeroTicket )

      /*
      Si el numero de ticket esta vacio debemos tomar un nuevo numero-------------
      */

      if !Empty( cValeTicket ) .and. ::oTiketCabecera:Seek( cValeTicket )

         ::oTiketCabecera:Load()
         ::oTiketCabecera:nTotNet   := nValePromocion
         ::oTiketCabecera:nTotTik   := nValePromocion
         ::oTiketCabecera:Save()

      else

         ::oTiketCabecera:Load()
         ::oTiketCabecera:cNumTik   := ::nNuevoNumeroTicket()
         ::oTiketCabecera:cTipTik   := SAVVAL
         ::oTiketCabecera:lCloTik   := .f.
         ::oTiketCabecera:nTotNet   := nValePromocion
         ::oTiketCabecera:nTotTik   := nValePromocion
         ::oTiketCabecera:cTikVal   := cNumeroTicket
         ::oTiketCabecera:Insert()

      end if

      /*
      Ahora metemos una linea-----------------------------------------------------
      */

      while ::oTiketLinea:Seek( ::cNumeroTicket() ) .and. !::oTiketLinea:eof() 
         ::oTiketLinea:Delete(.f.)
      end while

      ::oTiketLinea:Blank()
      ::oTiketLinea:cSerTil         := ::oTiketCabecera:cSerTik
      ::oTiketLinea:cNumTil         := ::oTiketCabecera:cNumTik
      ::oTiketLinea:cSufTil         := ::oTiketCabecera:cSufTik
      ::oTiketLinea:cTipTil         := ::oTiketCabecera:cTipTik
      ::oTiketLinea:dFecTik         := ::oTiketCabecera:dFecTik
      ::oTiketLinea:nUntTil         := 1
      ::oTiketLinea:nNumLin         := 1
      ::oTiketLinea:cNomTil         := "Vale por promoción"
      ::oTiketLinea:nPvpTil         := nValePromocion
      ::oTiketLinea:Insert()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error al generar vale" )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::EnableDialog()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD lLiquidaVale( sCobro ) CLASS TpvTactil

   ? sCobro:nImporte

Return ( Self )

//---------------------------------------------------------------------------//

METHOD OnClickDividirMesa() Class TpvTactil

   if ::OnClickGuardar()

      //Comprobaciones iniciales----------------------------------------------------

      ::DisableDialog()

      ::oTpvUtilidadesMesa:DividirMesas()

      ::EnableDialog()

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GetPesoBalanza() CLASS TpvTactil

   local oBalanza
   local cBalanza 

   cBalanza                :=  cBalanzaEnCaja( oUser():cCaja(), ::oCajaCabecera:cAlias )

   if empty( cBalanza )
      return ( Self )
   end if 

   if ::oTemporalLinea:ordKeyCount() != 0 .and.;
      !::oTemporalLinea:lDelTil           .and.;
      !::oTemporalLinea:lKitArt

      oBalanza             := TCommPort():Create( cBalanza )

      if oBalanza:OpenPort()

         ::oTemporalLinea:GetStatus()

         ::oTemporalLinea:nUntTil   := oBalanza:nPeso() 

         ::oTemporalLinea:SetStatus()

         ::SetTotal()

         ::oBrwLineas:Refresh()

         oBalanza:ClosePort()
         oBalanza:End()
         
      else  
         
         msgStop( "El puerto de la balanza no se ha creado correctamente" )

      end if 

   end if   

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreateItemArticulo( aItems, cCodigoMenu, cCodigoOrden )

   if ::oArticulo:lIncTcl .and. !::oArticulo:lObs

      with object ( C5ImageViewItem() )

         :Cargo            := ::oArticulo:Codigo
         :cText            := ::cNombreArticulo()

         if empty( cCodigoMenu )
            :bAction       := {|cCodigoArticulo| ::AgregarLineas( cCodigoArticulo ) }
         else
            :bAction       := {|cCodigoArticulo| ::AgregarArticuloMenu( cCodigoArticulo, cCodigoMenu, cCodigoOrden ) }
         end if

         if ( ::lImagenArticulos ) .and. ( ::lFileBmpName( ::oArticulo:cImagen ) )

            :cImage        := ::cFileBmpName( ::oArticulo:cImagen )
         
         else
            
            if ( ::oArticulo:nColBtn == 0 .or. ::oArticulo:nColBtn == rgb(255,255,255) )
               :nClrPane   := oRetFld( ::oArticulo:Familia, ::oFamilias, "nColBtn", "cCodFam" )
            else
               :nClrPane   := ::oArticulo:nColBtn
            end if
               
         end if

         :add( aItems )

      end with

   end if

Return ( Self )

//------------------------------------------------------------------------//

METHOD OnClickEliminarLinea()

   local nLineaMenu 

   if !::lEditableDocumento()
      msgStop( "El documento ya está cerrado" )
      Return ( .t. )
   end if

   // Si es una línea hija de un escandallo no permitimos borrarla.----------

   if ::oTemporalLinea:lKitChl
      msgStop( "No se puede borrar un componente de un escandallo" )
      Return ( .t. )
   end if

   if oUser():lNotConfirmDelete() .or. ApoloMsgNoYes( "¿Desea eliminar el registro en curso?", "Confirme supresión", .t. )
      ::disableDialog()
      ::eliminarLinea()
      ::enableDialog()
   end if

   // Nuevo total-----------------------------------------------------------

   ::SetTotal()

Return ( .t. )

//------------------------------------------------------------------------//

METHOD eliminarLinea()

   if ::oTemporalLinea:lMnuTil

      ::EliminaMenu( ::oTemporalLinea:nNumLin )

      ::CargaBrowseFamilias()

      ::ChangeFamilias()

   else

      // Si la línea es un escandallo eliminamos el escandallo completo

      if ( ::oTemporalLinea:lKitArt )
         ::EliminaEscandallo( ::oTemporalLinea:nNumLin )
      else
         ::EliminaLineaTemporal()
      end if

   end if

   ::mailEliminarLinea()

   ::oBrwLineas:Refresh()

Return ( .t. )

//------------------------------------------------------------------------//
//
// Envío de  mail al usuario----------------------------------------------
//

METHOD mailEliminarLinea()

   local hMail          := {=>}
   local cMensajeMail   := ""
   local cDireccionMail := ConfiguracionEmpresasModel():getValue( 'mail_notificaciones' )

   if empty( cDireccionMail )
      Return ( Self )
   end if 

   cMensajeMail         := "<p>" + "Linea eliminada en el ticket " + ::cTextoTicketLinea()      + "</p>" + CRLF  
   cMensajeMail         += "<p>" + "Descripción : " +  alltrim( ::oTemporalLinea:cNomTil )      + "</p>" + CRLF  
   cMensajeMail         += "<p>" + "Unidades : " + ::nUnidadesLinea( ::oTemporalLinea, .t. )    + "</p>" + CRLF  
   cMensajeMail         += "<p>" + "Importe : " + ::nTotalLinea( ::oTemporalLinea, .t. )        + "</p>" + CRLF  
   cMensajeMail         += "<p>" + "Cajero : " + oUser():cCodigo() + " - " + oUser():cNombre()  + "</p>" + CRLF  
   cMensajeMail         += "<p>" + "Fecha y hora : " + dtoc( date() ) + " - " + time()          + "</p>" + CRLF  

   hSet( hMail, "mail", cDireccionMail ) 
   hSet( hMail, "subject", "Línea eliminada en T.P.V." )
   hSet( hMail, "message", cMensajeMail )

   with object TSendMail():New()
      if :buildMailerObject()
         :sendMail( hMail )
      end if 
   end with

Return ( Self )

//------------------------------------------------------------------------//

METHOD EliminaMenu( nLineaMenu )

   ::oTemporalLinea:GetStatus()

   ::oTemporalLinea:OrdSetFocus( "cCodMnu" )
   ::oTemporalLinea:GoTop()

   while !( ::oTemporalLinea:eof() )
     
      if ( nLineaMenu == ::oTemporalLinea:nLinMnu )
         ::EliminaLineaTemporal()
      end if

      ::SaltaLineaTemporal()

   end while

   ::oTemporalLinea:SetStatus()

Return( Self )

//------------------------------------------------------------------------//

METHOD EliminaEscandallo( nNumeroLinea )

  ::oTemporalLinea:GetStatus()

  ::oTemporalLinea:OrdSetFocus( "nNumLin" )
  ::oTemporalLinea:GoTop()

  while !( ::oTemporalLinea:eof() )

     if ( nNumeroLinea == ::oTemporalLinea:nNumLin ) 

        ::EliminaLineaTemporal()

     end if

     ::SaltaLineaTemporal()

  end while

  ::oTemporalLinea:SetStatus()

Return( Self )

//------------------------------------------------------------------------//
// Colores-----------------------------------------------------------------

METHOD ColorLinea( oDbf )
  
   local aColor

   DEFAULT oDbf   := ::oTemporalLinea

   do case 
      case oDbf:FieldGetByName( "lDelTil" )
         aColor   := { CLR_BLACK, Rgb( 255, 0, 0 ) }
      case oDbf:FieldGetByName( "lControl" )
         aColor   := { CLR_BLACK, Rgb( 248, 243, 53 ) }
      case oDbf:FieldGetByName( "lMnuTil" )
         aColor   := { CLR_BLACK, Rgb( 34, 177, 76 ) }
      otherwise
         aColor   := { CLR_BLACK, Rgb( 255, 255, 255 ) }
  end case 

RETURN ( aColor )

//------------------------------------------------------------------------//

METHOD ColorLineaSeleccionada( oDbf )
  
   local aColor

   DEFAULT oDbf   := ::oTemporalLinea

   do case 
      case oDbf:FieldGetByName( "lDelTil" )
         aColor   := { CLR_BLACK, Rgb( 255, 0, 0 ) }
      case oDbf:FieldGetByName( "lControl" )
         aColor   := { CLR_BLACK, Rgb( 248, 243, 53 ) }
      case oDbf:FieldGetByName( "lMnuTil" )
        aColor    := { CLR_BLACK, Rgb( 124, 231, 156 ) }
      otherwise
        aColor    := { CLR_BLACK, Rgb( 229, 229, 229 ) }
   end case 

RETURN ( aColor )

//------------------------------------------------------------------------//

METHOD ColorLineaFocus( oDbf )
  
  local aColor

  DEFAULT oDbf   := ::oTemporalLinea

  do case 
     case oDbf:FieldGetByName( "lDelTil" )
        aColor   := { CLR_BLACK, Rgb( 255, 128, 128 ) }
     case oDbf:FieldGetByName( "lMnuTil" )
        aColor   := { CLR_BLACK, Rgb( 124, 231, 156 ) }
     otherwise
        aColor   := { CLR_BLACK, Rgb( 167, 205, 240 ) }
  end case 

RETURN ( aColor )

//--------------------------------------------------------------------------

// Cargar menú si es una linea de menú o un articulo del menú---------------

METHOD CargaMenuSeleccionado()

  if ::nLineaMenuActivo() != 0 .and. !::oTemporalLinea:lDelTil
     ::CargaFamiliaMenu( ::oTemporalLinea:cCodMnu )
  end if

RETURN ( Self )

//--------------------------------------------------------------------------

METHOD lEmptyAlias()

	if !Empty( ::oTiketCabecera:cNumTik )
		Return ( .f. )
	end if

	if ( ::oTiketCabecera:nUbiTik == ubiGeneral .or. ::oTiketCabecera:nUbiTik == ubiRecoger ) .and. Empty( ::oTiketCabecera:cPntVenta ) .and. Empty( ::oTiketCabecera:cAliasTik ) .and. !Empty( ::oTemporalLinea:OrdKeyCount() )
      Return ( .t. )
	end if

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD InitDocumento( nUbicacion )

	// Carga los valores del registro actual---------------------------------

	CursorWait()

	::oTiketCabecera:Blank()
	::oTiketCabecera:SetDefault()

   // Cargamos los valores por defecto--------------------------------------

   ::cargaValoresDefecto( nUbicacion )

   ::initValoresDefecto()

   CursorWE()

   ::getComensales( nUbicacion )

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD UltimoCambio()

	if !Empty( ::oSayImporte )
	 	::oSayImporte:SetText( "Último cambio" )
	end if

	if !Empty( ::oTotalTicket )
	 	::oTotalTicket:SetText( abs( ::oTpvCobros:Total() - ::oTpvCobros:Entregado ) )
	end if

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD EscribeVisor()

	if ::oVisor != nil
		::oVisor:SetBufferLine( { "Total: ",  Trans( ::sTotal:nTotalDocumento, ::cPictureTotal ) }, 1 )
		::oVisor:SetBufferLine( { "Cambio: ", Trans( ::oTpvCobros:Cambio(), ::cPictureTotal ) }, 2 )
		::oVisor:WriteBufferLine()
	end if

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD AgregaLineaVisor( aTextoLinea, nLinea )

  if ::oVisor != nil
     
     ::oVisor:SetBufferLine( aTextoLinea, nLinea )
     
     if nLinea == 2
        ::oVisor:WriteBufferLine()
     end if
        
  end if

RETURN ( Self )
  
//------------------------------------------------------------------------//

METHOD SetTotal()

  ::sTotal    := ::sTotalTiket()

  if !Empty( ::oSayImporte )
     ::oSayImporte:SetText( "Total" )
  end if

  if !Empty( ::oTotalTicket )
     ::oTotalTicket:SetText( ::sTotal:nTotalDocumento )
  end if

  if !Empty( ::oSayPrecioPersona )
     if !Empty( ::oTiketCabecera:nNumCom )
        ::oSayPrecioPersona:SetText( Alltrim( Trans( ::oTiketCabecera:nNumCom, "999" ) ) + " pax. x " + Alltrim( Trans( ::sTotal:nTotalPersona, ::cPictureTotal ) ) )
     else
        ::oSayPrecioPersona:SetText( "" )
     end if
  end if

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD nTotalTemporalDivision( oDbfTemporal )

  local nTotal   := 0

  oDbfTemporal:GetStatus()

  oDbfTemporal:Gotop()

  while !oDbfTemporal:Eof()

     nTotal += oDbfTemporal:nUntTil * oDbfTemporal:nPvpTil

     oDbfTemporal:Skip()

  end while   

  oDbfTemporal:SetStatus()

RETURN ( nTotal )

//-----------------------------------------------------------------------//

METHOD cTxtUbicacion()

  local cUbicacion  := ""

  if Empty( ::oTiketCabecera )
     Return ( cUbicacion )
  end if

  do case
     case ::oTiketCabecera:nUbiTik == ubiSala

        cUbicacion  := ::oRestaurante:cTextoSala( ::oTiketCabecera:cCodSala ) + Space( 1 ) + ":" + Space( 1 ) + Rtrim( ::oTiketCabecera:cPntVenta )

     case ::oTiketCabecera:nUbiTik == ubiGeneral

        cUbicacion  := "General " + Space( 1 ) + ":" + Space( 1 ) + Rtrim( ::oTiketCabecera:cAliasTik )

     case ::oTiketCabecera:nUbiTik == ubiRecoger

        cUbicacion  := "Para recoger " + Space( 1 ) + ":" + Space( 1 ) + Rtrim( ::oTiketCabecera:cAliasTik )

     case ::oTiketCabecera:nUbiTik == ubiLlevar

        cUbicacion  := "Para llevar " + Space( 1 ) + ":" + Space( 1 ) + Rtrim( ::oTiketCabecera:cNomTik )

     case ::oTiketCabecera:nUbiTik == ubiEncargar

        cUbicacion  := "Encargo " + Space( 1 ) + ":" + Space( 1 ) + Rtrim( ::oTiketCabecera:cNomTik )

  end case

  RETURN ( cUbicacion )

//------------------------------------------------------------------------//

METHOD cUbicacion()

  local cUbicacion  := ::cTxtUbicacion()

  if !Empty( ::oGrpSalones )
     aSend( ::oGrpSalones:aItems, "UnSelected" )
  end if

  do case
     case ::oTiketCabecera:nUbiTik == ubiSala

        if !Empty( ::oBtnSala )
           ::oBtnSala:Selected()
        end if

        if !Empty( ::oBtnGeneral )
           ::oBtnGeneral:UnSelected()
        end if

        if !Empty( ::oBtnLlevar )
           ::oBtnLlevar:UnSelected()
        end if

        if !Empty( ::oBtnRecoger )
           ::oBtnRecoger:UnSelected()
        end if

        if !Empty( ::oBtnEncargar )
           ::oBtnEncargar:UnSelected()
        end if

     case ::oTiketCabecera:nUbiTik == ubiGeneral

        if !Empty( ::oBtnSala )
           ::oBtnSala:UnSelected()
        end if

        if !Empty( ::oBtnGeneral )
           ::oBtnGeneral:Selected()
        end if

        if !Empty( ::oBtnLlevar )
           ::oBtnLlevar:UnSelected()
        end if

        if !Empty( ::oBtnRecoger )
           ::oBtnRecoger:UnSelected()
        end if

        if !Empty( ::oBtnEncargar )
           ::oBtnEncargar:UnSelected()
        end if

     case ::oTiketCabecera:nUbiTik == ubiRecoger

        if !Empty( ::oBtnSala )
           ::oBtnSala:UnSelected()
        end if

        if !Empty( ::oBtnGeneral )
           ::oBtnGeneral:UnSelected()
        end if

        if !Empty( ::oBtnLlevar )
           ::oBtnLlevar:UnSelected()
        end if

        if !Empty( ::oBtnRecoger )
           ::oBtnRecoger:UnSelected()
        end if

        if !Empty( ::oBtnEncargar )
           ::oBtnEncargar:UnSelected()
        end if

     case ::oTiketCabecera:nUbiTik == ubiLlevar

        if !Empty( ::oBtnSala )
           ::oBtnSala:UnSelected()
        end if

        if !Empty( ::oBtnGeneral )
           ::oBtnGeneral:UnSelected()
        end if

        if !Empty( ::oBtnLlevar )
           ::oBtnLlevar:Selected()
        end if

        if !Empty( ::oBtnRecoger )
           ::oBtnRecoger:UnSelected()
        end if

        if !Empty( ::oBtnEncargar )
           ::oBtnEncargar:UnSelected()
        end if

     case ::oTiketCabecera:nUbiTik == ubiEncargar

        if !Empty( ::oBtnSala )
           ::oBtnSala:UnSelected()
        end if

        if !Empty( ::oBtnGeneral )
           ::oBtnGeneral:UnSelected()
        end if

        if !Empty( ::oBtnLlevar )
           ::oBtnLlevar:UnSelected()
        end if

        if !Empty( ::oBtnRecoger )
           ::oBtnRecoger:UnSelected()
        end if

        if !Empty( ::oBtnEncargar )
           ::oBtnEncargar:Selected()
        end if

  end case

  if !Empty( ::oGrpSalones )
     ::oGrpSalones:Refresh()
  end if

RETURN ( cUbicacion )

//-----------------------------------------------------------------------//

METHOD cInfo()

  local cInfo       := ""

  cInfo             += "Sesión : " + Alltrim( Transform( cCurSesion(), "######" ) ) + Space( 1 )

  if ::lEmptyNumeroTicket()
     cInfo          += "*Nuevo*"
  else
     cInfo          += "Ticket : " + ::oTiketCabecera:cSerTik + "/" + Alltrim( ::oTiketCabecera:cNumTik ) + Space( 1 )
  end if

  if !Empty( ::oTiketCabecera:dFecCre )
     cInfo          += Dtoc( ::oTiketCabecera:dFecCre ) + Space( 1 )
  end if

  if !Empty( ::oTiketCabecera:cTimCre )
     cInfo          += ( ::oTiketCabecera:cTimCre ) + Space( 1 )
  end if

RETURN ( cInfo )

//-----------------------------------------------------------------------//

METHOD cInfoPendiente()

  local cInfo       := ""

  do case
     case ::oTiketCabecera:nUbiTik == ubiSala
        cInfo       := ::oRestaurante:cTextoSala( ::oTiketCabecera:cCodSala ) + Space( 1 ) + ":" + Space( 1 ) + Rtrim( ::oTiketCabecera:cPntVenta ) + CRLF + Space( 1 )

     case ::oTiketCabecera:nUbiTik == ubiGeneral
        cInfo       := Rtrim( ::oTiketCabecera:cAliasTik ) + CRLF + Space( 1 )

     case ::oTiketCabecera:nUbiTik == ubiRecoger
        cInfo       := Rtrim( ::oTiketCabecera:cAliasTik ) + CRLF + Space( 1 )

     case ::oTiketCabecera:nUbiTik == ubiLlevar
        cInfo       := Rtrim( ::oTiketCabecera:cNomTik )   + CRLF + Space( 1 )

     case ::oTiketCabecera:nUbiTik == ubiEncargar
        cInfo       := Rtrim( ::oTiketCabecera:cNomTik )   + CRLF + Space( 1 )

  end case

  if !Empty( ::oTiketCabecera:nTotTik )
     cInfo          += Alltrim( Trans( ::oTiketCabecera:nTotTik, ::cPictureTotal ) )
  end if

RETURN ( cInfo )

//-----------------------------------------------------------------------//

METHOD cEstado()

  local cEstado     := ""

  if ::oTiketCabecera:lAbierto
     cEstado        := "Abierto"
  else
     cEstado        := "Cerrado"
  end if

RETURN ( cEstado )

//-----------------------------------------------------------------------//

METHOD SetCombinando( lCombinando )

  DEFAULT lCombinando        := !::lCombinando

  ::lCombinando              := lCombinando
  ::lCombinandoDos           := .f.

  if ::lCombinando
     ::oTimer:Activate()
  else
     ::oTimer:Deactivate()
     ::ShowCombinado( .f. )
  end if 

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD ShowCombinado( lShowCombinando )

  DEFAULT lShowCombinando := !::lShowCombinado

  ::lShowCombinado        := lShowCombinando

   if empty( ::oBtnCombinado )
      Return ( Self )
   end if 

   if lShowCombinando
      ::oBtnCombinado:LoadBitmap( "gc_pin_32" ) 
      ::oSayImporte:SetText( "Combinando..." )
   else
      ::oBtnCombinado:LoadBitmap( "gc_pin_blue_32" )
      ::oSayImporte:SetText( "Total" )
   end if 
   
   ::oBtnCombinado:Refresh() 

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD SelectorOrdenComanda()

   local idOrdenComanda          := ::oOrdenComanda:Selector()
   local textoOrdenComanda       := ""

   if !empty( idOrdenComanda ) .and. ( idOrdenComanda != ::getCodigoOrdenComandaActual() )

      ::setCodigoOrdenComandaActual( idOrdenComanda ) 

      textoOrdenComanda          := ::oOrdenComanda:cNombre( idOrdenComanda )   
      
      ::setTextButtonOrdenComandaActual( textoOrdenComanda )

      ::agregarOrdenComanda( textoOrdenComanda )

   end if 

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD initOrdenComanda()

   local idOrdenComanda           := ::oOrdenComanda:getFirstOrderId()

   if !empty( idOrdenComanda ) 
      
      ::setCodigoOrdenComandaActual( idOrdenComanda ) 

      ::setTextButtonOrdenComandaActual( idOrdenComanda )

   end if 

RETURN ( "" )

//-----------------------------------------------------------------------//

METHOD cValeTicket( cNumeroTicket )

   local cValeTicket := ""

   ::oTiketCabecera:GetStatus()

   if ::oTiketCabecera:SeekInOrd( cNumeroTicket, "cTikVal" )
      cValeTicket    := ::cNumeroTicket()
   end if

   ::oTiketCabecera:SetStatus()

RETURN ( cValeTicket )

//---------------------------------------------------------------------------//

METHOD cTextoLinea( oDbf )

   local cTexto   := ""

   DEFAULT oDbf   := ::oTemporalLinea

   cTexto         += Rtrim( oDbf:cNomTil )

   if !Empty( oDbf:cComent )
      cTexto      := "[*] " + cTexto
   end if

   if !Empty( oDbf:cNcmTil )
      cTexto      += " con " + alltrim( oDbf:cNcmTil )
   end if

   if !Empty( oDbf:lKitChl )
      cTexto      := Space( 3 ) + "<" + cTexto + ">"
   end if

   if ( oDbf:nLinMnu != __bottomNumber__ ) .and. !( oDbf:lMnuTil )
      cTexto      := Space( 3 ) + "<" + cTexto + ">"
   end if

RETURN ( alltrim( cTexto ) )

//---------------------------------------------------------------------------//

METHOD cTextoLineaLeng( oDbf, oArticulosLenguajes )

   local cTexto
   local nOrdAnt

   DEFAULT oDbf                  := ::oTemporalLinea
   DEFAULT oArticulosLenguajes   := ::oArticulosLenguajes

   oArticulosLenguajes:OrdSetFocus( "CARTLEN" )

   if !oArticulosLenguajes:Seek( oDbf:cCbaTil + getLenguajeSegundario() )
      cTexto                     := Rtrim( oDbf:cNomTil )
   else
      if !Empty( oArticulosLenguajes:cDesArt ) 
         cTexto                   := AllTrim( oArticulosLenguajes:cDesArt )
      else
         cTexto                   := AllTrim( oArticulosLenguajes:cDesTik )
      end if
   end if

   if !Empty( oDbf:cComent )
      cTexto      := "[*] " + cTexto
   end if

   if !Empty( oDbf:cNcmTil )
      cTexto      += " con " + alltrim( oDbf:cNcmTil )
   end if

   if !Empty( oDbf:lKitChl )
      cTexto      := Space( 3 ) + "<" + cTexto + ">"
   end if

   if ( oDbf:nLinMnu != __bottomNumber__ ) .and. !( oDbf:lMnuTil )
      cTexto      := Space( 3 ) + "<" + cTexto + ">"
   end if

   oArticulosLenguajes:OrdSetFocus( nOrdAnt )

RETURN ( alltrim( cTexto ) )

//------------------------------------------------------------------------//

METHOD cTextoLineaDivision( oDbf )

   local cTexto

   cTexto         := Rtrim( oDbf:cNomTil )

   if !Empty( oDbf:cComent )
      cTexto      := "[*] " + cTexto
   end if

   if !Empty( oDbf:cNcmTil )
      cTexto      += " con " + alltrim( oDbf:cNcmTil )
   end if

   if !Empty( oDbf:lKitChl ) 
      cTexto      := Space( 3 ) + "<" + cTexto + ">"
   end if

   if ( oDbf:nLinMnu != __bottomNumber__ ) .and. !( oDbf:lMnuTil )
      cTexto      := Space( 3 ) + "<" + cTexto + ">"
   end if

RETURN ( cTexto )

//------------------------------------------------------------------------//

METHOD lShowEscandallos()

   local cFocus

   cFocus         := Upper( ::oTemporalLinea:OrdSetFocus() )

   if ( cFocus == Upper( "nRecNum" ) )
      ::oTemporalLinea:OrdSetFocus( "lRecNum" )
   else
      ::oTemporalLinea:OrdSetFocus( "nRecNum" )
   end if

   ::oBrwLineas:GoTop()
   ::oBrwLineas:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OnClickImportesExactos()

   setFieldEmpresa( !uFieldEmpresa( "lImpExa" ), "lImpExa" )

   if uFieldEmpresa( "lImpExa" )
      ::oBtnImportesExactos:Selected()
   else 
      ::oBtnImportesExactos:UnSelected()
   end if 

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD lValidatePreSave()

   if ::lEmptyDocumento()
      Return .f.
   end if

   if !::lValidTurno()
      Return .f.
   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD lValidTurno()

   if !lCurSesion()
      MsgStop( "No hay sesiones activas, imposible añadir documentos." )
      Return .f.
   end if

   if !lCajaOpen( oUser():cCaja() )
      msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
      Return .f.
   end if

Return .t.

//--------------------------------------------------------------------------//

METHOD TreeReportingChanged() 

   local cTitle   := ::oTreeReporting:GetSelText()

   if cTitle == "Listado"
      ::lHideFecha()
   else
      ::lShowFecha()
   end if

   ::oDlg:cTitle( ::cSubTitle + " : [" + cTitle + "]" )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ResizedCol( nSize )

   local nResize := 24

   if !::l1024() .and. nSize > nResize

      nSize -= nResize

   end if

Return ( nSize )

//--------------------------------------------------------------------------//

METHOD ResizedFont( nSize )

   local nResize := 25 //es un porcentaje

   if !::l1024()

      nSize -= ( nSize * nResize ) / 100

   end if

Return ( nSize )

//--------------------------------------------------------------------------//

METHOD CambiarUnidadesPrecio( lGetPrecio )

   DEFAULT lGetPrecio        := !::lGetPrecio

   ::lGetPrecio              := lGetPrecio

   if empty( ::oBtnPrecioUnidades )
      RETURN ( Self )
   end if 

   if ::lGetPrecio
      ::oBtnPrecioUnidades:LoadBitmap( "gc_currency_euro_32" ) 
   else
      ::oBtnPrecioUnidades:LoadBitmap( "Paginator_32" )
   end if 

   ::oBtnPrecioUnidades:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD isArticulosSinPeso()

   local nPeso
   local lValid                        := .f.

   ::oTemporalLinea:GetStatus()

   ::oTemporalLinea:GoTop()
   while !::oTemporalLinea:eof()

      if ::oTemporalLinea:lPeso .and. ::nUnidadesLinea( ::oTemporalLinea ) == 0 .and. !::oTemporalLinea:lDelTil

         nPeso                         := Calculadora( 0, , , "Peso: " + alltrim( ::oTemporalLinea:cNomTil ) )
         if nPeso != 0
            ::oTemporalLinea:nUntTil   := nPeso
         else 
            lValid                     := .t.
         end if

      end if

      ::oTemporalLinea:Skip()

   end while

   ::oTemporalLinea:SetStatus()

RETURN ( lValid )

//---------------------------------------------------------------------------//

METHOD LoadTemporalImpresionLinea()

   local nOrdAnt

   ::oTemporalImpresionLinea:Zap()

   nOrdAnt        := ::oTemporalImpresionLinea:OrdSetFocus( "Codigo" )

   if ::oTiketLinea:Seek( ::cNumeroTicket() )

      while ::cNumeroTicketLinea() == ::cNumeroTicket() .and. !::oTiketLinea:eof()

         if !::oTiketLinea:lDelTil

            if ::oTemporalImpresionLinea:Seek( ::oTiketLinea:cCbaTil )

               if ::oTiketLinea:nPvpTil == ::oTemporalImpresionLinea:nPvpTil  .and.;
                  ::oTiketLinea:cComTil == ::oTemporalImpresionLinea:cComTil  .and.;
                  ::oTiketLinea:cCodPr1 == ::oTemporalImpresionLinea:cCodPr1  .and.;
                  ::oTiketLinea:cValPr1 == ::oTemporalImpresionLinea:cValPr1  .and.;
                  ::oTiketLinea:nDtoDiv == ::oTemporalImpresionLinea:nDtoDiv  .and.;
                  ::oTiketLinea:cComent == ::oTemporalImpresionLinea:cComent  .and.;
                  !::oTiketLinea:lControl

                  ::oTemporalImpresionLinea:nUntTil   += ::oTiketLinea:nUntTil 

               else

                  dbPass( ::oTiketLinea:cAlias, ::oTemporalImpresionLinea:cAlias, .t. )

               end if

            else

               dbPass( ::oTiketLinea:cAlias, ::oTemporalImpresionLinea:cAlias, .t. )

            end if

         end if   

         ::oTiketLinea:Skip()

      end while

   end if

   ::oTemporalImpresionLinea:OrdSetFocus( nOrdAnt )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD OnClickEliminarTicket()

   if !oUser():lAdministrador()
      apoloMsgStop( "Eliminar tickets solo esta permitido a adeministradores" )
      Return .f.
   end if 

   if ::lEmptyNumeroTicket()
      apoloMsgStop( "El ticket aún no ha sido guardado." )
      Return .f.
   end if 

   if !apoloMsgNoYes( "¿ Desea realmente eliminar el ticket " + ::cNumeroTicketFormato() + " ?", "Atención", .t. )
      Return .f.
   end if 

   ::disableDialog()

   ::oTemporalLinea:GetStatus()

   ::oTemporalLinea:GoTop()
   while !( ::oTemporalLinea:eof() )
      ::eliminarLinea()
      ::oTemporalLinea:Skip()
   end while

   ::oTemporalLinea:SetStatus()

   ::setTicketPagado()

   // nos vamos a una ubicacion general

   ::OnClickGeneral()

   // habilitamos el dialogo---------------------------------------------------

   ::enableDialog()

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickReabrirTicket()

   local cTextoTicket   := ::cNumeroTicketByNameFormato()

   if ::oTiketCabecera:lCloTik
      apoloMsgStop( "El ticket " + cTextoTicket + " pertenece a una sesión cerrada.", "Atención" )
      Return ( .f. )
   end if 

   if !::oTiketCabecera:lPgdTik
      apoloMsgStop( "El ticket " + cTextoTicket + " no esta pagado.", "Atención" )
      Return ( .f. )
   end if 

   if apoloMsgNoYes( "¿ Desea realmente reabir el ticket " + cTextoTicket + "?" + ;
                     CRLF + ;
                     "Se eliminaran los pagos de este ticket y podrá ser modificado",;
                     "Confirme", .t. )

      CursorWait()

      ::oTpvCobros:EliminaCobros() 
      
      ::oTiketCabecera:lPgdTik   := .f. 
      ::oTiketCabecera:lAbierto  := .t. 

      ::GuardaDocumento( .f. )

      CursorWE()

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD getComensales( nUbicacion )

   if !isNil( nUbicacion )
      Return .t.
   end if 

   ::setUnidades( 1 )

   if ::oRestaurante:lComensal

      ::OnClickComensales()

      // unidades 

      if ( ::oRestaurante:lMultiplicar .and. ::oTiketCabecera:nNumCom > 0 )
         ::setUnidades( ::oTiketCabecera:nNumCom )
      end if 

   end if

   // Articulos al inicio

   if !empty( ::oRestaurante:cArticulo ) 
      ::AgregarArticulosInicio( ::oRestaurante:cArticulo )         
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AgregarArticulosInicio( cCodigoArticulo )

   if !::oArticulo:Seek( cCodigoArticulo )
      Return ( .f. )
   end if 

   // Agregamos el articulo----------------------------------------------

   ::AgregarPrincipal( cCodigoArticulo )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD browseLineasDragBegin( r, c, f, o )                              

   ::numeroLineaDragBegin  := ::oTemporalLinea:nNumLin

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD browseLineasDropOver( u, r, c, f )

   ::oBrwLineas:LButtonDown( r, c )
   ::oBrwLineas:LButtonUp()

   ::numeroLineaDropOver   := ::oTemporalLinea:nNumLin

   do case
      case ::numeroLineaDragBegin > ::numeroLineaDropOver
         ::moveLineUp()
      case ::numeroLineaDragBegin < ::numeroLineaDropOver
         ::moveLineDown()
   end if 

   ::oBrwLineas:Refresh()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD moveLineUp()

   ::oTemporalLinea:getStatus()

   ::oTemporalLinea:ordsetfocus( 0 )

   ::oTemporalLinea:goTop()
   while ( ! ::oTemporalLinea:eof() )
      
      if ::oTemporalLinea:nNumLin >= ::numeroLineaDropOver .and. ::oTemporalLinea:nNumLin < ::numeroLineaDragBegin
         ::oTemporalLinea:nNumLin++
      elseif ::oTemporalLinea:nNumLin == ::numeroLineaDragBegin
         ::oTemporalLinea:nNumLin := ::numeroLineaDropOver
      end if 

      ::oTemporalLinea:skip()

   end while

   ::oTemporalLinea:setStatus()

   ::oBrwLineas:GoUp()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD moveLineDown()

   ::oTemporalLinea:getStatus()

   ::oTemporalLinea:ordsetfocus( 0 )

   ::oTemporalLinea:goTop()
   while ( ! ::oTemporalLinea:eof() )
      
      if ::oTemporalLinea:nNumLin == ::numeroLineaDragBegin
         ::oTemporalLinea:nNumLin := ::numeroLineaDropOver
      elseif ::oTemporalLinea:nNumLin > ::numeroLineaDragBegin .and. ::oTemporalLinea:nNumLin <= ::numeroLineaDropOver
         ::oTemporalLinea:nNumLin--
      end if 

      ::oTemporalLinea:skip()

   end while

   ::oTemporalLinea:setStatus()

   ::oBrwLineas:GoDown()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD isLineaValidaComanda( lCopia ) 

   if ( ::oTiketLinea:lDelTil )
      Return .f.
   end if

   if ( lCopia )
      Return .t.
   end if 

   if ( ::oTiketLinea:lPeso .and. ::nUnidadesImpresas() == -1 )
      Return .f.
   end if

   if ( ::oTiketLinea:lPeso .and. ::nUnidadesLinea() == 0 )
      Return .t.
   end if 

Return ( ::nUnidadesImpresas() < ::nUnidadesLinea() ) 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS STotalCobros

   DATA  oTotal
   DATA  oEntregado
   DATA  oCobrado
   DATA  oCobradoDivisa
   DATA  oCambio

   DATA  nTotal               INIT  0
   DATA  nEntregado           INIT  0
   DATA  nCobrado             INIT  0
   DATA  nVale                INIT  0
   DATA  nAnticipo            INIT  0
   DATA  nCambio              INIT  0

   METHOD lValeMayorTotal()   INLINE ( ( ::nVale <= ::nTotal ) .or. ( ::nTotal < 0 ) )

   METHOD Recalcula()         INLINE ( ::nCambio   := - ( ::nTotal - ::nEntregado - ::nCobrado ) )

   METHOD SetCobrado()        INLINE ( ::nCobrado  := ( ::nTotal - ::nEntregado ) )

   METHOD GetTotal( sTotal )

   METHOD Refresh()

END CLASS

//---------------------------------------------------------------------------//

METHOD GetTotal( sTotal ) CLASS STotalCobros

   ::nVale                    := 0
   ::nAnticipo                := 0
   ::nCambio                  := 0
   ::nTotal                   := sTotal:nTotalDocumento
   ::nEntregado               := sTotal:nTotalCobro()

   ::nCobrado                 := ::nTotal - ::nEntregado

   ::Recalcula()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Refresh() CLASS STotalCobros

   ::Recalcula()

   if !Empty( ::oTotal )
      ::oTotal:Refresh()
   end if

   if !Empty( ::oEntregado )
      ::oEntregado:Refresh()
   end if

   if !Empty( ::oCobrado )
      ::oCobrado:Refresh()
   end if

   if !Empty( ::oCobradoDivisa )
      ::oCobradoDivisa:Refresh()
   end if

   if !Empty( ::oCambio )
      ::oCambio:Refresh()
   end if

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

function SetResDebug( lOnOff ) // for backwards compatibility

return nil

//----------------------------------------------------------------------------//

function FWCleanResource()

   aResources := {}

return nil

//----------------------------------------------------------------------------//

function FWAddResource( nHResource, cType )

   local n := 3, cInfo := ""

   while ! Empty( ProcName( n ) )
      cInfo += ProcName( n ) + "(" + Alltrim( Str( ProcLine( n ) ) ) + ")->"
      n++
   end

   if ! Empty( cInfo )
      cInfo = SubStr( cInfo, 1, Len( cInfo ) - 2 )
   endif

   AAdd( aResources, { cType, nHResource, cInfo } )

return nil

//----------------------------------------------------------------------------//

function FWDelResource( nHResource )

   local nAt

   if ( nAt := AScan( aResources, { | aRes | aRes[ 2 ] == nHResource } ) ) != 0
      ADel( aResources, nAt )
      ASize( aResources, Len( aResources ) - 1 )
   endif

return nil

//----------------------------------------------------------------------------//

function CheckRes()

   local cInfo := "", n

   ferase( "checkres.txt" )

   for n = 1 to Len( aResources )
      if aResources[ n, 2 ] != 0
         cInfo = aResources[ n, 1 ] + "," + AllTrim( Str( aResources[ n, 2 ] ) ) + "," + aResources[ n, 3 ] + CRLF
         LogFile( "checkres.txt", { cInfo } )
      endif
   next

   LogFile( "checkres.txt", { Replicate( "=", 100 ) } )

return nil

//---------------------------------------------------------------------------//

#pragma BEGINDUMP

#include <windows.h>
#include <hbapiitm.h>
#include <hbvm.h>

void RegisterResource( HANDLE hRes, LPSTR szType )
{
   PHB_ITEM pRet = hb_itemNew( hb_param( -1, HB_IT_ANY ) );

   hb_vmPushSymbol( hb_dynsymGetSymbol( "FWADDRESOURCE" ) );
   hb_vmPushNil();
   hb_vmPushLong( ( LONG ) hRes );
   hb_vmPushString( szType, strlen( szType ) );
   hb_vmFunction( 2 );

   hb_itemReturnRelease( pRet );
}

void pascal DelResource( HANDLE hResource )
{
   PHB_ITEM pRet = hb_itemNew( hb_param( -1, HB_IT_ANY ) );

   hb_vmPushSymbol( hb_dynsymGetSymbol( "FWDELRESOURCE" ) );
   hb_vmPushNil();
   hb_vmPushLong( ( LONG ) hResource );
   hb_vmFunction( 1 );

   hb_itemReturnRelease( pRet );
}

#pragma ENDDUMP

//----------------------------------------------------------------------------//
