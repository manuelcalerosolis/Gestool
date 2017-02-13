#include "FiveWin.ch"  
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"

// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastVentasArticulos FROM TFastReportInfGen

   DATA  nView

   DATA  nSec

   DATA  cType                            INIT "Articulos"

   DATA  aTypeDocs                        INIT { "C", "N", "D", "L", "C" }

   DATA  lUnidadesNegativo                INIT .f.

   DATA  oProCab
   DATA  oProLin
   DATA  oProMat
   DATA  oHisMov
   DATA  oArtAlm
   DATA  oArtPrv
   DATA  oCtrCoste
   DATA  oOperario
   DATA  oObras
   DATA  oTarPreL
   DATA  oAtipicasCliente
   DATA  oFraPub

   DATA  oPrp1
   DATA  oPrp2

   DATA  oStock

   DATA fileHeader                        
   DATA fileLine                          
   DATA dictionaryHeader                  
   DATA dictionaryLine  

   DATA oCamposExtra
   DATA aExtraFields                      INIT {}

   DATA cExpresionHeader
   DATA cExpresionLine

   DATA lApplyFilters                     INIT .t.

   DATA cAlmacenDefecto

   METHOD lResource( cFld )

   METHOD Create()
   METHOD lValidRegister()

   METHOD AddFieldCamposExtra()

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD DataReport()

   METHOD StartDialog()

   METHOD BuildTree()
   METHOD BuildReportCorrespondences()

   METHOD loadPropiedadesArticulos()

   METHOD AddSATClientes()
   METHOD AddPresupuestoClientes()
   METHOD AddPedidoClientes()
      METHOD sqlPedidoClientes()
      METHOD FastReportPedidoCliente()

   METHOD AddAlbaranCliente()
   METHOD AddFacturaCliente()
   METHOD AddFacturaRectificativa()
   METHOD AddTicket()

   METHOD AddArticulo()
      METHOD appendStockArticulo()
      METHOD appendBlankAlmacenes()
      METHOD appendBlankArticulo()   
      METHOD existeArticuloInforme()
      METHOD fillFromArticulo()
   
   METHOD listadoArticulo()

   METHOD AddProducido()
   METHOD AddConsumido()
   METHOD AddMovimientoAlmacen()

   METHOD AddPedidoProveedor()
   METHOD AddAlbaranProveedor()
   METHOD AddFacturaProveedor()
   METHOD AddRectificativaProveedor()
   
   METHOD processAllClients()

   METHOD idDocumento()                   INLINE ( ::oDbf:cClsDoc + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc ) 
   METHOD IdDocumentoLinea()              INLINE ( ::idDocumento() + Str( ::oDbf:nNumLin ) )

   METHOD StockArticulo()                 INLINE ( ::oStock:nStockAlmacen( ::oDbf:cCodArt, ::oDbf:cCodAlm, ::oDbf:cValPr1, ::oDbf:cValPr2, ::oDbf:cLote, ::dIniInf, ::dFinInf ) )

   METHOD nTotalStockArticulo()           INLINE ( ::oStock:nStockArticulo( ::oDbf:cCodArt ) )
   METHOD nBultosStockArticulo()          INLINE ( ::oStock:nBultosArticulo( ::oDbf:cCodArt ) )

   METHOD nCostoMedio()                   INLINE ( ::oStock:nCostoMedio( ::oDbf:cCodArt, ::oDbf:cCodAlm ) )
   METHOD nCostoMedioPropiedades()        INLINE ( ::oStock:nCostoMedio( ::oStock:oDbfStock:cCodigo, ::oStock:oDbfStock:cAlmacen, ::oStock:oDbfStock:cCodPrp1, ::oStock:oDbfStock:cCodPrp2, ::oStock:oDbfStock:cValPrp1, ::oStock:oDbfStock:cValPrp2, ::oStock:oDbfStock:cLote ) )

   METHOD nombrePrimeraPropiedad()        INLINE ( nombrePropiedad( ::oDbf:cCodPr1, ::oDbf:cValPr1, ::nView ) )
   METHOD nombreSegundaPropiedad()        INLINE ( nombrePropiedad( ::oDbf:cCodPr2, ::oDbf:cValPr2, ::nView ) )

   METHOD aStockArticulo()                INLINE ( ::oStock:aStockArticulo( ::oDbf:cCodArt ) )

   METHOD SetUnidadesNegativo( lValue )   INLINE ( ::lUnidadesNegativo := lValue )

   METHOD AddVariableStock() 

   METHOD GetInformacionEntrada( cCodArt, cCodAlm, cLote, cDatoRequerido )
      //METHOD isEntradaAlbaranProveedor( cCodArt, cCodAlm, cLote )
      METHOD GetDatoAlbaranProveedor( cCodArt, cCodAlm, cLote, cDatoRequerido )
      //METHOD isEntradaMovimientoAlmacen( cCodArt, cCodAlm, cLote )
      METHOD GetDatoMovimientosAlamcen( cCodArt, cCodAlm, cLote, cDatoRequerido )

      METHOD getNameFieldLine( cFieldName )     INLINE ( getFieldNameFromDictionary( cFieldName, ::dictionaryLine ) )
      METHOD getNameFieldHeader( cFieldName )   INLINE ( getFieldNameFromDictionary( cFieldName, ::dictionaryHeader ) )

   METHOD getNumeroAlbaranProveedor()
   METHOD getFechaAlbaranProveedor()
   METHOD getUnidadesAlbaranProveedor()
   METHOD getEstadoAlbaranProveedor()
   METHOD geFechaPedidoProveedor()

   METHOD getTarifaArticulo()

   METHOD getUnidadesPedidoProveedor( cNumPed, cCodArt )
   METHOD isClientInReport()

   METHOD loadValuesExtraFields()

   METHOD setFilterClientIdHeader()             INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionHeader   += ' .and. ( Field->cCodCli >= "' + Rtrim( ::oGrupoCliente:Cargo:getDesde() ) + '" .and. Field->cCodCli <= "' + Rtrim( ::oGrupoCliente:Cargo:getHasta() ) + '" )', ) )

   METHOD setFilterProductIdLine()              INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionLine  += ' .and. ( alltrim( Field->cRef ) >= "' + alltrim(::oGrupoArticulo:Cargo:getDesde()) + '" .and. alltrim(Field->cRef) <= "' + alltrim(::oGrupoArticulo:Cargo:getHasta()) + '" )', ) )

   METHOD setFilterTypeLine()                   INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionLine  += ' .and. ( Field->cCodTip >= "' + ::oGrupoTArticulo:Cargo:getDesde() + '" .and. Field->cCodTip <= "' + ::oGrupoTArticulo:Cargo:getHasta() + '" )', ) )               

   METHOD setFilterStoreLine()                  INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionLine  += ' .and. ( Field->cAlmLin >= "' + ::oGrupoAlmacen:Cargo:getDesde() + '" .and. Field->cAlmLin <= "' + ::oGrupoAlmacen:Cargo:getHasta() + '" )', ) )

   METHOD setFilterFamily()                     INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionLine  += ' .and. ( Field->cCodFam >= "' + ::oGrupoFamilia:Cargo:getDesde() + '" .and. Field->cCodFam <= "' + ::oGrupoFamilia:Cargo:getHasta() + '" )', ) )               

   METHOD setFilterGroupFamily()                INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionLine  += ' .and. ( Field->cGrpFam >= "' + ::oGrupoGFamilia:Cargo:getDesde() + '" .and. Field->cGrpFam <= "' + ::oGrupoGFamilia:Cargo:getHasta() + '" )', ) )               

   METHOD setFilterAgent()                      INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionHeader  += ' .and. ( Field->cCodAge >= "' + ::oGrupoAgente:Cargo:getDesde() + '" .and. Field->cCodAge <= "' + ::oGrupoAgente:Cargo:getHasta() + '" )', ) )
   
   METHOD setFilterPaymentId()                  INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionHeader  += ' .and. ( Field->cCodPago >= "' + ::oGrupoFpago:Cargo:getDesde() + '" .and. Field->cCodPago <= "' + ::oGrupoFpago:Cargo:getHasta() + '" )', ) )
   
   METHOD setFilterPaymentInvoiceId()           INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionHeader  += ' .and. ( Field->cCodPgo >= "' + ::oGrupoFpago:Cargo:Desde + '" .and. Field->cCodPgo <= "' + ::oGrupoFpago:Cargo:Hasta + '" )', ) )
   
   METHOD setFilterRouteId()                    INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionHeader  += ' .and. ( Field->cCodRut >= "' + ::oGrupoRuta:Cargo:getDesde() + '" .and. Field->cCodRut <= "' + ::oGrupoRuta:Cargo:getHasta() + '" )', ) )

   METHOD setFilterTransportId()                INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionHeader  += ' .and. ( Field->cCodTrn >= "' + ::oGrupoTransportista:Cargo:getDesde() + '" .and. Field->cCodTrn <= "' + ::oGrupoTransportista:Cargo:getHasta() + '" )', ) )

   METHOD setFilterUserId()                     INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionHeader  += ' .and. ( Field->cCodUsr >= "' + ::oGrupoUsuario:Cargo:getDesde() + '" .and. Field->cCodUsr <= "' + ::oGrupoUsuario:Cargo:getHasta() + '" )', ) )

   METHOD setFilterOperarioId()                 INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionHeader  += ' .and. ( Field->cCodOpe >= "' + ::oGrupoOperario:Cargo:getDesde() + '" .and. Field->cCodOpe <= "' + ::oGrupoOperario:Cargo:getHasta() + '" )', ) )

   METHOD setFilterProveedorIdHeader()          INLINE ( if( ::lApplyFilters,;
                                                         ::cExpresionHeader   += ' .and. ( Field->cCodPrv >= "' + Rtrim( ::oGrupoProveedor:Cargo:getDesde() ) + '" .and. Field->cCodPrv <= "' + Rtrim( ::oGrupoProveedor:Cargo:getHasta() ) + '" )', ) )

   METHOD DesdeHastaGrupoCliente()

   METHOD getTotalUnidadesGrupoCliente( cCodGrp, cCodArt )
   METHOD getTotalCajasGrupoCliente( cCodGrp, cCodArt )
   METHOD ValidGrupoCliente( cCodGrp )
   METHOD getUnidadesVendidas

   METHOD summaryReport()
   METHOD acumulaDbf( nRecnoAcumula )

   METHOD setMeterText( cText )           INLINE ( if ( !empty( ::oMtrInf ), ::oMtrInf:cText := cText, ) )
   METHOD setMeterTotal( nTotal )         INLINE ( if ( !empty( ::oMtrInf ), ::oMtrInf:SetTotal( nTotal ), ) )
   METHOD setMeterAutoIncremental()       INLINE ( if ( !empty( ::oMtrInf ), ::oMtrInf:AutoInc(), ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TFastVentasArticulos

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

   ::cSubTitle       := "Informe de art�culos"

   if !::lTabletVersion
      if !::NewResource()
         return .f.
      end if
   end if

   /*
   Carga controles-------------------------------------------------------------
   */

   if !::lGrupoArticulo( .t. )
      return .f.
   end if

   if !::lGrupoGFamilia( .t. )
      return .f.
   end if

   if !::lGrupoFamilia( .t. )
      return .f.
   end if

   if !::lGrupoIva( .t. )
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

   if !::lGrupoEstadoArticulo( .t. )
      return .f.
   end if

   if !::lGrupoCliente( .t. )
      return .f.
   end if

   if !::lGrupoGrupoCliente( .t. )
      return .f.
   end if

   if !::lGrupoProveedor( .t. )
      return .f.
   end if

   if !::lGrupoAlmacen( .t. )
      return .f.
   end if

   if !::lGrupoFpago( .t. )
      return .f.
   end if

   if !::lGrupoRuta( .t. )
      return .f.
   end if

   if !::lGrupoAgente( .t. )
      return .f.
   end if

   if !::lGrupoTransportista( .t. )
      return .f.
   end if

   if !::lGrupoUsuario( .t. )
      return .f.
   end if

   if !::lGrupoSerie( .t. )
      return .f.
   end if

   if !::lGrupoNumero( .t. )
      return .f.
   end if

   if !::lGrupoSufijo( .t. )
      return .f.
   end if

   if !::lGrupoCentroCoste( .t. )
      return .f.
   end if

   if !::lGrupoOperario( .t. )
      return .t.
   end if

   ::oFilter      := TFilterCreator():Init()
   if !empty( ::oFilter )
      ::oFilter:SetDatabase( ::oDbf )
      ::oFilter:SetFilterType( ART_TBL )
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TFastVentasArticulos

   local lOpen          := .t.
   local oError
   local oBlock   

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      // ::lApplyFilters   := lAIS()
      ::cDriver         := cDriver()

      ::nView           := D():CreateView( ::cDriver )

      D():Clientes( ::nView )

      D():Proveedores( ::nView ) 

      D():Agentes( ::nView )

      D():PedidosClientes( ::nView )

      D():PedidosClientesLineas( ::nView )

      D():ProveedorArticulo( ::nView )

      DATABASE NEW ::oArtImg  PATH ( cPatArt() ) CLASS "ArtImg"      FILE "ArtImg.Dbf"  VIA ( ::cDriver ) SHARED INDEX "ArtImg.Cdx"

      DATABASE NEW ::oArtKit  PATH ( cPatArt() ) CLASS "ArtKit"      FILE "ArtKit.Dbf"  VIA ( ::cDriver ) SHARED INDEX "ArtKit.Cdx"

      DATABASE NEW ::oArtCod  PATH ( cPatArt() ) CLASS "ArtCodebar"  FILE "ArtCodebar.Dbf"  VIA ( ::cDriver ) SHARED INDEX "ArtCodebar.Cdx"

      DATABASE NEW ::oArtCod  PATH ( cPatArt() ) CLASS "ArtCodebar"  FILE "ArtCodebar.Dbf"  VIA ( ::cDriver ) SHARED INDEX "ArtCodebar.Cdx"

      ::oSatCliT  := TDataCenter():oSatCliT()

      DATABASE NEW ::oSatCliL PATH ( cPatEmp() ) CLASS "SatCliL"     FILE "SatCliL.Dbf" VIA ( ::cDriver ) SHARED INDEX "SatCliL.Cdx"

      ::oPreCliT  := TDataCenter():oPreCliT()

      DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) CLASS "PreCliL"     FILE "PreCliL.Dbf" VIA ( ::cDriver ) SHARED INDEX "PreCliL.Cdx"

      DATABASE NEW ::oAlbCliT PATH ( cPatEmp() ) CLASS "AlbCliT"     FILE "AlbCliT.Dbf" VIA ( ::cDriver ) SHARED INDEX "AlbCliT.Cdx"

      DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) CLASS "AlbCliL"     FILE "AlbCliL.Dbf" VIA ( ::cDriver ) SHARED INDEX "AlbCliL.Cdx"

      ::oFacCliT  := TDataCenter():oFacCliT()  

      DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) CLASS "FACCLIL"     FILE "FACCLIL.Dbf"   VIA ( ::cDriver ) SHARED INDEX "FACCLIL.Cdx"

      DATABASE NEW ::oFacCliP PATH ( cPatEmp() ) CLASS "FACCLIP"     FILE "FACCLIP.Dbf"   VIA ( ::cDriver ) SHARED INDEX "FACCLIP.Cdx"

      DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) CLASS "FACRECT"     FILE "FACRECT.Dbf"   VIA ( ::cDriver ) SHARED INDEX "FACRECT.Cdx"

      DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) CLASS "FACRECL"     FILE "FACRECL.Dbf"   VIA ( ::cDriver ) SHARED INDEX "FACRECL.Cdx"

      DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) CLASS "TIKET"       FILE "TIKET.Dbf"     VIA ( ::cDriver ) SHARED INDEX "TIKET.Cdx"

      DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) CLASS "TIKEL"       FILE "TIKEL.Dbf"     VIA ( ::cDriver ) SHARED INDEX "TIKEL.Cdx"

      DATABASE NEW ::oPedPrvT PATH ( cPatEmp() ) CLASS "PedPrvT"     FILE "PedProvT.Dbf"  VIA ( ::cDriver ) SHARED INDEX "PedProvT.Cdx"

      DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) CLASS "PedPrvL"     FILE "PedProvL.Dbf"  VIA ( ::cDriver ) SHARED INDEX "PedProvL.Cdx"

      DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) CLASS "AlbPrvT"     FILE "AlbProvT.Dbf"  VIA ( ::cDriver ) SHARED INDEX "AlbProvT.Cdx"

      DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) CLASS "AlbPrvL"     FILE "AlbProvL.Dbf"  VIA ( ::cDriver ) SHARED INDEX "AlbProvL.Cdx"

      DATABASE NEW ::oFacPrvT PATH ( CPATEMP() ) CLASS "FacPrvT"     FILE "FacPrvT.Dbf"   VIA ( ::cDriver ) SHARED INDEX "FacPrvT.Cdx"

      DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) CLASS "FacPrvL"     FILE "FacPrvL.Dbf"   VIA ( ::cDriver ) SHARED INDEX "FacPrvL.Cdx"

      DATABASE NEW ::oRctPrvT PATH ( cPatEmp() ) CLASS "RctPrvT"     FILE "RctPrvT.Dbf"   VIA ( ::cDriver ) SHARED INDEX "RctPrvT.Cdx"

      DATABASE NEW ::oRctPrvL PATH ( cPatEmp() ) CLASS "RctPrvL"     FILE "RctPrvL.Dbf"   VIA ( ::cDriver ) SHARED INDEX "RctPrvL.Cdx"

      DATABASE NEW ::oProLin  PATH ( cPatEmp() ) CLASS "ProLin"      FILE "ProLin.Dbf"    VIA ( ::cDriver ) SHARED INDEX "ProLin.Cdx"

      DATABASE NEW ::oProMat  PATH ( cPatEmp() ) CLASS "ProMat"      FILE "ProMat.Dbf"    VIA ( ::cDriver ) SHARED INDEX "ProMat.Cdx"

      DATABASE NEW ::oHisMov  PATH ( cPatEmp() ) CLASS "HisMov"      FILE "HisMov.Dbf"    VIA ( ::cDriver ) SHARED INDEX "HisMov.Cdx"

      DATABASE NEW ::oArtPrv  PATH ( cPatEmp() ) CLASS "ArtPrv"      FILE "ProvArt.Dbf"   VIA ( ::cDriver ) SHARED INDEX "ProvArt.Cdx"

      DATABASE NEW ::oArtAlm  PATH ( cPatEmp() ) CLASS "ArtAlm"      FILE "ArtAlm.Dbf"    VIA ( ::cDriver ) SHARED INDEX "ArtAlm.Cdx"

      DATABASE NEW ::oObras   PATH ( cPatCli() ) CLASS "ObrasT"      FILE "ObrasT.Dbf"    VIA ( ::cDriver ) SHARED INDEX "ObrasT.Cdx"

      DATABASE NEW ::oPrp1    PATH ( cPatArt() ) CLASS "TblPro1"     FILE "TblPro.Dbf"    VIA ( ::cDriver ) SHARED INDEX "TblPro.Cdx" 

      DATABASE NEW ::oPrp2    PATH ( cPatArt() ) CLASS "TblPro2"     FILE "TblPro.Dbf"    VIA ( ::cDriver ) SHARED INDEX "TblPro.Cdx"

      DATABASE NEW ::oTarPreL PATH ( cPatEmp() ) CLASS "TARPREL"     FILE "TARPREL.DBF"   VIA ( ::cDriver ) SHARED INDEX "TARPREL.CDX"

      DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      DATABASE NEW ::oAtipicasCliente PATH ( cPatEmp() ) CLASS "CliAtp" FILE "CliAtp.Dbf" VIA ( ::cDriver ) SHARED INDEX "CliAtp.CDX"
      ::oAtipicasCliente:ordsetfocus( "cCliArt" )

      DATABASE NEW ::oDbfFam PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

      DATABASE NEW ::oDbfCat PATH ( cPatArt() ) FILE "CATEGORIAS.DBF" VIA ( cDriver() ) SHARED INDEX "CATEGORIAS.CDX"

      DATABASE NEW ::oDbfTmp PATH ( cPatArt() ) FILE "Temporadas.DBF" VIA ( cDriver() ) SHARED INDEX "Temporadas.Cdx"

      DATABASE NEW ::oDbfEstArt PATH ( cPatEmp() ) FILE "ESTADOSAT.DBF" VIA ( cDriver() ) SHARED INDEX "ESTADOSAT.CDX"

      DATABASE NEW ::oDbfIva PATH ( cPatDat() ) FILE "TIva.Dbf" VIA ( cDriver() ) SHARED INDEX "TIva.Cdx"

      DATABASE NEW ::oDbfPrv PATH ( cPatPrv() ) FILE "PROVEE.DBF" VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"

      DATABASE NEW ::oDbfAlm PATH ( cPatAlm() ) FILE "ALMACEN.DBF" VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

      DATABASE NEW ::oDbfUsr PATH ( cPatDat() ) FILE "USERS.DBF" VIA ( cDriver() ) SHARED INDEX "USERS.CDX"

      DATABASE NEW ::oDbfRut PATH ( cPatCli() ) FILE "RUTA.DBF" VIA ( cDriver() ) SHARED INDEX "RUTA.CDX"

      DATABASE NEW ::oDbfAge PATH ( cPatCli() ) FILE "AGENTES.DBF" VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"

      DATABASE NEW ::oDbfFpg PATH ( cPatEmp() ) FILE "FPago.Dbf" VIA ( cDriver() ) SHARED INDEX "FPago.Cdx"

      DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

      ::oGrpCli               := TGrpCli():Create( cPatCli() )
      ::oGrpCli:OpenService()

      ::oFraPub               := TFrasesPublicitarias():Create( cPatArt(), ::cDriver )
      if !::oFraPub:OpenFiles()
         lOpen                := .f.
      end if

      ::oTipArt               := TTipArt():New( cPatArt(), cDriver() )
      if !::oTipArt:OpenFiles()
         lOpen                := .f.
      end if

      ::oGruFam               := TGrpFam():Create( cPatArt(), "GRPFAM" )
      if !::oGruFam:OpenFiles()
         lOpen                := .f.
      end if

      ::oDbfFab               := TFabricantes():New( cPatEmp() )
      if !::oDbfFab:OpenFiles()
         lOpen                := .f.
      end if

      ::oDbfTrn               := TTrans():Create( cPatCli(), "Transport" )
      if !::oDbfTrn:OpenFiles()
         lOpen                := .f.
      end if

      ::oProCab               := TDataCenter():oProCab( cPatEmp(), ::cDriver )

      ::oCnfFlt               := TDataCenter():oCnfFlt( cPatEmp(), ::cDriver )

      ::oStock    := TStock():Create( cPatEmp(), ::cDriver )
      if !::oStock:lOpenFiles()
         lOpen                := .f.
      else 
         ::oStock:lCalculateUnidadesPendientesRecibir    := .t.
         ::oStock:CreateTemporalFiles()
      end if

      ::oCtrCoste             := TCentroCoste():Create( cPatDat(), ::cDriver )
      if !::oCtrCoste:OpenFiles()
         lOpen                := .f.
      endif

      ::oOperario             := TOperarios():Create( cPatEmp(), ::cDriver )
      if !::oOperario:OpenFiles()
         lOpen                := .f.
      end if

      ::oCamposExtra          := TDetCamposExtra():New( cPatEmp(), ::cDriver )
      if !::oCamposExtra:OpenFiles()
         lOpen                := .f.
      else 
         ::oCamposExtra:setTipoDocumento( "Art�culos" )
         ::aExtraFields       := ::oCamposExtra:aExtraFields()
      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de art�culos" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TFastVentasArticulos

   local oBlock   

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !empty( ::oArtImg ) .and. ( ::oArtImg:Used() )
         ::oArtImg:end()
      end if

      if !empty( ::oArtKit ) .and. ( ::oArtKit:Used() )
         ::oArtKit:end()
      end if

      if !empty( ::oArtCod ) .and. ( ::oArtCod:Used() )
         ::oArtCod:end()
      end if

      if !empty( ::oArtPrv ) .and. ( ::oArtPrv:Used() )
         ::oArtPrv:end()
      end if

      if !empty( ::oSatCliT ) .and. ( ::oSatCliT:Used() )
         ::oSatCliT:end()
      end if

      if !empty( ::oSatCliL ) .and. ( ::oSatCliL:Used() )
         ::oSatCliL:end()
      end if

      if !empty( ::oPreCliL ) .and. ( ::oPreCliL:Used() )
         ::oPreCliL:end()
      end if

      if !empty( ::oPreCliT ) .and. ( ::oPreCliT:Used() )
         ::oPreCliT:end()
      end if

      if !empty( ::oAlbCliL ) .and. ( ::oAlbCliL:Used() )
         ::oAlbCliL:end()
      end if

      if !empty( ::oAlbCliT ) .and. ( ::oAlbCliT:Used() )
         ::oAlbCliT:end()
      end if

      if !empty( ::oFacCliL ) .and. ( ::oFacCliL:Used() )
         ::oFacCliL:end()
      end if

      if !empty( ::oFacCliT ) .and. ( ::oFacCliT:Used() )
         ::oFacCliT:end()
      end if

      if !empty( ::oFacCliP ) .and. ( ::oFacCliP:Used() )
         ::oFacCliP:end()
      end if

      if !empty( ::oFacRecL ) .and. ( ::oFacRecL:Used() )
         ::oFacRecL:end()
      end if

      if !empty( ::oFacRecT ) .and. ( ::oFacRecT:Used() )
         ::oFacRecT:end()
      end if

      if !empty( ::oTikCliT ) .and. ( ::oTikCliT:Used() )
         ::oTikCliT:End()
      end if

      if !empty( ::oTikCliL ) .and. ( ::oTikCliL:Used() )
         ::oTikCliL:End()
      end if

      if !empty( ::oPedPrvL ) .and. ( ::oPedPrvL:Used() )
         ::oPedPrvL:end()
      end if

      if !empty( ::oPedPrvT ) .and. ( ::oPedPrvT:Used() )
         ::oPedPrvT:end()
      end if

      if !empty( ::oAlbPrvL ) .and. ( ::oAlbPrvL:Used() )
         ::oAlbPrvL:end()
      end if

      if !empty( ::oAlbPrvT ) .and. ( ::oAlbPrvT:Used() )
         ::oAlbPrvT:end()
      end if

      if !empty( ::oFacPrvL ) .and. ( ::oFacPrvL:Used() )
         ::oFacPrvL:end()
      end if

      if !empty( ::oFacPrvT ) .and. ( ::oFacPrvT:Used() )
         ::oFacPrvT:end()
      end if

      if !empty( ::oRctPrvL ) .and. ( ::oRctPrvL:Used() )
         ::oRctPrvL:end()
      end if

      if !empty( ::oRctPrvT ) .and. ( ::oRctPrvT:Used() )
         ::oRctPrvT:end()
      end if

      if !empty( ::oProLin ) .and. ( ::oProLin:Used() )
         ::oProLin:end()
      end if

      if !empty( ::oProMat ) .and. ( ::oProMat:Used() )
         ::oProMat:end()
      end if

      if !empty( ::oHisMov ) .and. ( ::oHisMov:Used() )
         ::oHisMov:end()
      end if

      if !empty( ::oArtAlm ) .and. ( ::oArtAlm:Used() )
         ::oArtAlm:end()
      end if

      if !empty( ::oProCab ) .and. ( ::oProCab:Used() )
         ::oProCab:end()
      end if 

      if !empty( ::oCnfFlt ) .and. ( ::oCnfFlt:Used() )
         ::oCnfFlt:end()
      end if

      if !empty( ::oObras ) .and. ( ::oObras:Used() )
         ::oObras:end()
      end if

      if !empty( ::oPrp1 ) .and. ( ::oPrp1:Used() )
         ::oPrp1:end()
      end if 

      if !empty( ::oPrp2 ) .and. ( ::oPrp2:Used() )
         ::oPrp2:end()
      end if

      if !empty( ::oDbfFam ) .and. ( ::oDbfFam:Used() )
         ::oDbfFam:end()
      end if

      if !empty( ::oDbfArt ) .and. ( ::oDbfArt:Used() )
         ::oDbfArt:end()
      end if

      if !empty( ::oDbfCat ) .and. ( ::oDbfCat:Used() )
         ::oDbfCat:end()
      end if

      if !empty( ::oDbfTmp ) .and. ( ::oDbfTmp:Used() )
         ::oDbfTmp:end()
      end if

      if !empty( ::oDbfEstArt ) .and. ( ::oDbfEstArt:Used() )
         ::oDbfEstArt:end()
      end if

      if !empty( ::oDbfIva ) .and. ( ::oDbfIva:Used() )
         ::oDbfIva:end()
      end if

      if !empty( ::oDbfPrv ) .and. ( ::oDbfPrv:Used() )
         ::oDbfPrv:end()
      end if

      if !empty( ::oDbfAlm ) .and. ( ::oDbfAlm:Used() )
         ::oDbfAlm:end()
      end if

      if !empty( ::oDbfUsr ) .and. ( ::oDbfUsr:Used() )
         ::oDbfUsr:end()
      end if

      if !empty( ::oDbfRut ) .and. ( ::oDbfRut:Used() )
         ::oDbfRut:end()
      end if

      if !empty( ::oDbfAge ) .and. ( ::oDbfAge:Used() )
         ::oDbfAge:end()
      end if

      if !empty( ::oDbfFpg ) .and. ( ::oDbfFpg:Used() )
         ::oDbfFpg:end()
      end if

      if !empty( ::oDbfCli ) .and. ( ::oDbfCli:Used() )
         ::oDbfCli:end()
      end if

      if !empty( ::oAtipicasCliente ) .and. ( ::oAtipicasCliente:Used() )
         ::oAtipicasCliente:end()
      end if

      if !empty( ::oFraPub )
         ::oFraPub:end()
      end if

      if !empty( ::oTarPreL ) .and. ( ::oTarPreL:Used() )
         ::oTarPreL:end()
      end if

      if !empty( ::oCtrCoste )
         ::oCtrCoste:end()
      end if

      if !empty( ::oGrpCli )
         ::oGrpCli:end()
      end if

      if !empty( ::oStock )
         ::oStock:DeleteTemporalFiles()
         ::oStock:End()
      end if

      if !empty( ::oOperario )
         ::oOperario:End()
      end if

      if !empty( ::oCamposExtra )
         ::oCamposExtra:CloseFiles()
         ::oCamposExtra:End()
      end if

      if !Empty( ::oTipArt )
         ::oTipArt:End()
      end if

      if !Empty( ::oGruFam )
         ::oGruFam:End()
      end if

      if !Empty( ::oDbfFab )
         ::oDbfFab:End()
      end if

      if !Empty( ::oDbfTrn )
         ::oDbfTrn:End()
      end if

      if !Empty( ::nView )
         D():DeleteView( ::nView )
      end if

      ::nView     := nil

   RECOVER

      msgStop( "Imposible cerrar todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( uParam ) CLASS TFastVentasArticulos

   ::uParam    := uParam

   ::AddField( "cCodArt",     "C", 18, 0, {|| "@!" }, "C�digo art�culo"                         )
   ::AddField( "cNomArt",     "C",100, 0, {|| ""   }, "Nombre art�culo"                         )

   ::AddField( "cCodFam",     "C", 16, 0, {|| "@!" }, "C�digo familia"                          )
   ::AddField( "cGrpFam",     "C",  3, 0, {|| "@!" }, "C�digo grupo de familia"                 )
   ::AddField( "TipoIva",     "C",  1, 0, {|| "@!" }, "C�digo del tipo de " + cImp()            )
   ::AddField( "cCodTip",     "C",  4, 0, {|| "@!" }, "C�digo del tipo de art�culo"             )
   ::AddField( "cCodCate",    "C", 10, 0, {|| "@!" }, "C�digo categor�a"                        )
   ::AddField( "cCodEst",     "C",  3, 0, {|| "@!" }, "C�digo estado art�culo"                  )
   ::AddField( "cCodTemp",    "C", 10, 0, {|| "@!" }, "C�digo temporada"                        )
   ::AddField( "cCodFab",     "C",  3, 0, {|| "@!" }, "C�digo fabricante"                       )
   ::AddField( "cCodGrp",     "C", 12, 0, {|| "@!" }, "C�digo grupo de cliente"                 )
   ::AddField( "cCodAlm",     "C", 16, 0, {|| "@!" }, "C�digo del almac�n"                      )
   ::AddField( "cAlmOrg",     "C", 16, 0, {|| "@!" }, "Almac�n origen"                          )
   ::AddField( "cCodPago",    "C",  2, 0, {|| "@!" }, "C�digo de la forma de pago"              )
   ::AddField( "cCodRut",     "C", 12, 0, {|| "@!" }, "C�digo de la ruta"                       )
   ::AddField( "cCodAge",     "C", 12, 0, {|| "@!" }, "C�digo del agente"                       )
   ::AddField( "cCodTrn",     "C", 12, 0, {|| "@!" }, "C�digo del transportista"                )
   ::AddField( "cCodUsr",     "C",  3, 0, {|| "@!" }, "C�digo usuario"                          )
   ::AddField( "cCodOpe",     "C",  5, 0, {|| "@!" }, "C�digo operario"                         )
   ::AddField( "cCodEnv",     "C",  3, 0, {|| "@!" }, "C�digo tipo de envase"                   )

   ::AddField( "cCodCli",     "C", 12, 0, {|| "@!" }, "C�digo cliente/proveedor"                )
   ::AddField( "cNomCli",     "C", 80, 0, {|| "@!" }, "Nombre cliente/proveedor"                )
   ::AddField( "cPobCli",     "C", 35, 0, {|| "@!" }, "Poblaci�n cliente/proveedor"             )
   ::AddField( "cPrvCli",     "C", 20, 0, {|| "@!" }, "Provincia cliente/proveedor"             )
   ::AddField( "cPosCli",     "C", 15, 0, {|| "@!" }, "C�digo postal cliente/proveedor"         )
   ::AddField( "cCodObr",     "C", 10, 0, {|| "@!" }, "C�digo de la direcci�n"                  )

   ::AddField( "nUniArt",     "N", 16, 6, {|| "" },   "Unidades art�culo"                       )
   ::AddField( "nPreArt",     "N", 16, 6, {|| "" },   "Precio unitario art�culo"                ) 

   ::AddField( "nPdtRec",     "N", 16, 6, {|| "" },   "Unidades pendientes de recibir"          )
   ::AddField( "nPdtEnt",     "N", 16, 6, {|| "" },   "Unidades pendientes de entregar"         )
   ::AddField( "nEntreg",     "N", 16, 6, {|| "" },   "Unidades entregadas"                     )
   ::AddField( "nRecibi",     "N", 16, 6, {|| "" },   "Unidades recibidas"                      )

   ::AddField( "nDtoArt",     "N",  6, 2, {|| "" },   "Descuento porcentual art�culo"           ) 
   ::AddField( "nLinArt",     "N", 16, 6, {|| "" },   "Descuento lineal art�culo"               ) 
   ::AddField( "nPrmArt",     "N",  6, 2, {|| "" },   "Descuento promocional art�culo"          )

   ::AddField( "nTotDto",     "N", 16, 6, {|| "" },   "Total descuento porcentual art�culo"     ) 
   ::AddField( "nTotPrm",     "N", 16, 6, {|| "" },   "Total descuento promocional art�culo"    )

   ::AddField( "nTrnArt",     "N", 16, 6, {|| "" },   "Total transporte art�culo"               ) 
   ::AddField( "nPntArt",     "N", 16, 6, {|| "" },   "Total punto verde art�culo"              ) 
   
   ::AddField( "nBrtArt",     "N", 16, 6, {|| "" },   "Total importe bruto art�culo"            )
   ::AddField( "nImpArt",     "N", 16, 6, {|| "" },   "Total importe art�culo"                  )
   ::AddField( "nIvaArt",     "N", 16, 6, {|| "" },   "Total " + cImp() + " art�culo"           )
   ::AddField( "nImpEsp",     "N", 16, 6, {|| "" },   "Total impuesto especial art�culo"        )
   ::AddField( "nTotArt",     "N", 16, 6, {|| "" },   "Total importe art�culo " + cImp() + " incluido" )
   ::AddField( "nCosArt",     "N", 16, 6, {|| "" },   "Total costo art�culo"                    )
   ::AddField( "nPctAge",     "N",  6, 2, {|| "" },   "Porcentaje agente"                       )
   ::AddField( "nComAge",     "N", 16, 6, {|| "" },   "Comision agente"                         )

   ::AddField( "cCodPr1",     "C", 20, 0, {|| "" },   "C�digo de la primera propiedad"          )
   ::AddField( "cCodPr2",     "C", 20, 0, {|| "" },   "C�digo de la segunda propiedad"          )
   ::AddField( "cValPr1",     "C", 20, 0, {|| "" },   "Valor de la primera propiedad"           )
   ::AddField( "cValPr2",     "C", 20, 0, {|| "" },   "Valor de la segunda propiedad"           )

   ::AddField( "cLote",       "C", 14, 0, {|| "" },   "N�mero de lote"                          )
   ::AddField( "dFecCad",     "D",  8, 0, {|| "" },   "Fecha de caducidad"                      )

   ::AddField( "cNumSer",     "C", 30, 0, {|| "" },   "N�mero de serie"                         )

   ::AddField( "cClsDoc",     "C",  2, 0, {|| "" },   "Clase de documento"                      )
   ::AddField( "cTipDoc",     "C", 30, 0, {|| "" },   "Tipo de documento"                       )
   ::AddField( "cIdeDoc",     "C", 27, 0, {|| "" },   "Identificador del documento"             )
   ::AddField( "nNumLin",     "N",  4, 0, {|| "" },   "N�mero de l�nea"                         )

   ::AddField( "cSerDoc",     "C",  1, 0, {|| "" },   "Serie del documento"                     )
   ::AddField( "cNumDoc",     "C", 10, 0, {|| "" },   "N�mero del documento"                    )
   ::AddField( "cSufDoc",     "C",  2, 0, {|| "" },   "Delegaci�n del documento"                )

   ::AddField( "nAnoDoc",     "N",  4, 0, {|| "" },   "A�o del documento"                       )
   ::AddField( "nMesDoc",     "N",  2, 0, {|| "" },   "Mes del documento"                       )
   ::AddField( "dFecDoc",     "D",  8, 0, {|| "" },   "Fecha del documento"                     )
   ::AddField( "cHorDoc",     "C",  2, 0, {|| "" },   "Hora del documento"                      )
   ::AddField( "cMinDoc",     "C",  2, 0, {|| "" },   "Minutos del documento"                   )

   ::AddField( "cCodPrv",     "C", 12, 0, {|| "@!" }, "C�digo proveedor lineas"                 )
   ::AddField( "cNomPrv",     "C", 80, 0, {|| "@!" }, "Nombre proveedor lineas"                 )

   ::AddField( "nBultos",     "N", 16, 0, {|| "" },   "Numero de bultos en l�neas"              )
   ::AddField( "cFormato",    "C",100, 0, {|| "" },   "Formato de compra/venta en l�neas"       )
   ::AddField( "nCajas",      "N", 16, 6, {|| "" },   "Cajas en l�neas"                         )
   ::AddField( "nPeso",       "N", 16, 6, {|| "" },   "Peso en l�neas"                          )

   ::AddField( "lKitArt",     "L",  1, 0, {|| "" },   "L�nea con escandallos"                   )
   ::AddField( "lKitChl",     "L",  1, 0, {|| "" },   "L�nea perteneciente a escandallo"        )

   ::AddField( "cPrvHab",     "C", 12, 0, {|| "" },   "Proveedor habitual"                      )

   ::AddField( "cCtrCoste",   "C",  9, 0, {|| "" },   "C�digo del centro de coste"              )
   ::AddField( "cTipCtr",     "C", 20, 0, {|| "" },   "Tipo tercero centro de coste"            )
   ::AddField( "cCodTerCtr",  "C", 20, 0, {|| "" },   "C�digo tercero centro de coste"          )
   ::AddField( "cNomTerCtr",  "C",100, 0, {|| "" },   "Nombre tercero centro de coste"          )

   ::AddField( "cDesUbi",     "C",200, 0, {|| "" },   "Unicaci�n del art�culo"                  )
   ::AddField( "cEstado",     "C", 20, 0, {|| "" },   "Estado del documento"                    )

   ::AddField( "nCargo",      "N", 16, 6, {|| "" },   "Cargo numerico"                          )

   ::AddFieldCamposExtra()

   ::AddTmpIndex( "cCodArt",     "cCodArt" )
   ::AddTmpIndex( "cCodCli",     "cCodCli" )
   ::AddTmpIndex( "cPrvHab",     "cPrvHab")
   ::AddTmpIndex( "cCodAlm",     "cCodArt + cCodAlm" )
   ::AddTmpIndex( "cCodPrvArt",  "cCodPrv + cCodArt" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFieldCamposExtra() CLASS TFastVentasArticulos

   local cField
   
   if isArray( ::aExtraFields ) .and. Len( ::aExtraFields ) != 0

      for each cField in ::aExtraFields

         ::AddField( "fld" + cField[ "c�digo" ],;
                     ::aTypeDocs[ cField[ "tipo" ] ] ,;
                     cField[ "longitud" ],;
                     cField[ "decimales" ],;
                     {|| ::oCamposExtra:cPictData( cField ) },;
                     Capitalize( cField[ "descripci�n" ] ) )

      next

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD BuildReportCorrespondences()
   
   ::hReport   := {  "Listado" =>;                     
                        {  "Generate" =>  {||   ::listadoArticulo() } ,;
                           "Variable" =>  {||   nil },;
                           "Data" =>      {||   nil } },; 
                     "SAT de clientes" =>;
                        {  "Generate" =>  {||   ::AddSATClientes(),;
                                                ::processAllClients() },;
                           "Variable" =>  {||   ::AddVariableLineasSATCliente() },;
                           "Data" =>      {||   ::FastReportSATCliente() } },;
                     "Presupuestos de clientes" =>;   
                        {  "Generate" =>  {||   ::AddPresupuestoClientes(),;
                                                ::processAllClients() },;
                           "Variable" =>  {||   ::AddVariableLineasPresupuestoCliente(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportPresupuestoCliente() } },;
                     "Pedidos de clientes" =>;
                        {  "Generate" =>  {||   ::AddPedidoClientes(),;
                                                ::processAllClients() },;
                           "Variable" =>  {||   ::AddVariableLineasPedidoCliente(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportPedidoCliente() } },;
                     "Albaranes de clientes" =>;       
                        {  "Generate" =>  {||   ::AddAlbaranCliente(),;
                                                ::processAllClients() },;
                           "Variable" =>  {||   ::AddVariableLineasAlbaranCliente(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportAlbaranCliente() } },;
                     "Facturas de clientes" =>;
                        {  "Generate" =>  {||   ::AddFacturaCliente(),;
                                                ::AddFacturaRectificativa(),;
                                                ::processAllClients() },;
                           "Variable" =>  {||   ::AddVariableFacturaCliente(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportFacturaCliente(),;
                                                ::FastReportFacturaRectificativa() } },;
                     "Rectificativas de clientes" => ;
                        {  "Generate" =>  {||   ::AddFacturaRectificativa( .t. ),;
                                                ::processAllClients() },;
                           "Variable" =>  {||   ::AddVariableLineasRectificativaCliente(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportFacturaRectificativa() } },;
                     "Tickets de clientes" => ;
                        {  "Generate" =>  {||   ::AddTicket( .t. ),;
                                                ::processAllClients() },;
                           "Variable" =>  {||   ::AddVariableLineasTicketCliente(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportTicket( .t. ) } },;
                     "Ventas" => ;
                        {  "Generate" =>  {||   ::AddAlbaranCliente( .t. ),;
                                                ::AddFacturaCliente(),;
                                                ::AddFacturaRectificativa(),;
                                                ::AddTicket(),;
                                                ::processAllClients() },;
                           "Variable" =>  {||   ::AddVariableLineasAlbaranCliente(),;
                                                ::AddVariableLineasFacturaCliente(),;
                                                ::AddVariableLineasRectificativaCliente(),;
                                                ::AddVariableLineasTicketCliente(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportAlbaranCliente(),;
                                                ::FastReportFacturaCliente(),;
                                                ::FastReportFacturaRectificativa(),;
                                                ::FastReportTicket( .t. ) } },;
                     "Partes de producci�n" => ;
                        {  "Generate" =>  {||   ::AddProducido() },;
                           "Variable" =>  {||   ::AddVariableLineasParteProduccion(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportParteProduccion() } },;
                     "Pedidos de proveedores" => ;
                        {  "Generate" =>  {||   ::AddPedidoProveedor() },;
                           "Variable" =>  {||   ::AddVariableLineasPedidoProveedor(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportPedidoProveedor() } },;
                     "Albaranes de proveedores" => ;
                        {  "Generate" =>  {||   ::AddAlbaranProveedor() },;
                           "Variable" =>  {||   ::AddVariableLineasAlbaranProveedor(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportAlbaranProveedor() } },;
                     "Facturas de proveedores" => ;     
                        {  "Generate" =>  {||   ::AddFacturaProveedor() },;
                           "Variable" =>  {||   ::AddVariableLineasFacturaProveedor(),;
                                                ::AddVariableLineasRectificativaProveedor(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportFacturaProveedor() } },;
                     "Rectificativas de proveedores"=> ;
                        {  "Generate" =>  {||   ::AddRectificativaProveedor() },;
                           "Variable" =>  {||   ::AddVariableLineasRectificativaProveedor(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportRectificativaProveedor() } },;
                     "Compras" => ;                    
                        {  "Generate" =>  {||   ::AddAlbaranProveedor( .t. ),;
                                                ::AddFacturaProveedor(),;
                                                ::AddRectificativaProveedor() },;
                           "Variable" =>  {||   ::AddVariableLineasAlbaranProveedor(),;
                                                ::AddVariableLineasFacturaProveedor(),;
                                                ::AddVariableLineasRectificativaProveedor(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportPedidoProveedor(),;
                                                ::FastReportAlbaranProveedor(),;
                                                ::FastReportFacturaProveedor(),;
                                                ::FastReportRectificativaProveedor() } },;
                     "Movimientosalmacen" => ;
                        {  "Generate" =>  {||   ::AddMovimientoAlmacen() },;
                           "Variable" =>  {||   nil },;
                           "Data" =>      {||   nil } },;
                     "Compras y ventas" => ;           
                        {  "Generate" =>  {||   ::SetUnidadesNegativo( .t. ),;
                                                ::AddAlbaranCliente( .t. ),;
                                                ::AddFacturaCliente(),;
                                                ::AddTicket(),;
                                                ::AddAlbaranProveedor( .t. ),;
                                                ::AddFacturaProveedor(),;
                                                ::SetUnidadesNegativo( .f. ) },;
                           "Variable" =>  {||   ::AddVariableLineasAlbaranCliente(),;
                                                ::AddVariableFacturaCliente(),;
                                                ::AddVariableLineasRectificativaCliente(),;
                                                ::AddVariableLineasTicketCliente(),;
                                                ::AddVariableLineasAlbaranProveedor(),;
                                                ::AddVariableLineasFacturaProveedor(),;
                                                ::AddVariableLineasRectificativaProveedor(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportAlbaranCliente(),;
                                                ::FastReportFacturaCliente(),;
                                                ::FastReportFacturaRectificativa(),;
                                                ::FastReportTicket( .t. ),;
                                                ::FastReportPedidoProveedor(),;
                                                ::FastReportAlbaranProveedor(),;
                                                ::FastReportFacturaProveedor(),;
                                                ::FastReportRectificativaProveedor() } },;
                     "Todos los movimientos" => ;      
                        {  "Generate" =>  {||   ::AddAlbaranCliente(),;
                                                ::AddFacturaCliente(),;
                                                ::AddFacturaRectificativa(),;
                                                ::AddTicket(),;
                                                ::AddAlbaranProveedor(),;
                                                ::AddFacturaProveedor(),;
                                                ::AddRectificativaProveedor(),;
                                                ::AddProducido(),;
                                                ::AddConsumido(),;
                                                ::AddMovimientoAlmacen() },;
                           "Variable" =>  {||   ::AddVariableLineasAlbaranCliente(),;
                                                ::AddVariableFacturaCliente(),;
                                                ::AddVariableLineasRectificativaCliente(),;
                                                ::AddVariableLineasTicketCliente(),;
                                                ::AddVariableLineasAlbaranProveedor(),;
                                                ::AddVariableLineasFacturaProveedor(),;
                                                ::AddVariableLineasRectificativaProveedor(),;
                                                ::AddVariableStock(),;
                                                ::AddVariableLineasParteProduccion() },;
                           "Data" =>      {||   ::FastReportAlbaranCliente(),;
                                                ::FastReportFacturaCliente(),;
                                                ::FastReportFacturaRectificativa(),;
                                                ::FastReportTicket( .t. ),;
                                                ::FastReportPedidoProveedor(),;
                                                ::FastReportAlbaranProveedor(),;
                                                ::FastReportFacturaProveedor(),;
                                                ::FastReportRectificativaProveedor(),;
                                                ::FastReportParteProduccion() } },;
                     "General" => ;                    
                        {  "Generate" =>  {||   ::AddSATClientes(),;
                                                ::AddPresupuestoClientes(),;
                                                ::AddPedidoClientes(),;
                                                ::AddAlbaranCliente( .t. ),;
                                                ::AddFacturaCliente(),;
                                                ::AddFacturaRectificativa(),;
                                                ::AddTicket(),;
                                                ::AddPedidoProveedor(),;
                                                ::AddAlbaranProveedor( .t. ),;
                                                ::AddFacturaProveedor(),;
                                                ::AddRectificativaProveedor(),;
                                                ::AddProducido() },;
                           "Variable" =>  {||   ::AddVariableLineasSATCliente(),;
                                                ::AddVariableLineasPresupuestoCliente(),;
                                                ::AddVariableLineasPedidoCliente(),;
                                                ::AddVariableLineasAlbaranCliente(),;
                                                ::AddVariableFacturaCliente(),;
                                                ::AddVariableLineasRectificativaCliente(),;
                                                ::AddVariableLineasTicketCliente(),;
                                                ::AddVariableLineasPedidoProveedor(),;
                                                ::AddVariableLineasAlbaranProveedor(),;
                                                ::AddVariableLineasFacturaProveedor(),;
                                                ::AddVariableLineasRectificativaProveedor(),;
                                                ::AddVariableLineasParteProduccion(),;
                                                ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportSATCliente(),;
                                                ::FastReportPresupuestoCliente(),;
                                                ::FastReportPedidoCliente(),;
                                                ::FastReportAlbaranCliente(),;
                                                ::FastReportFacturaCliente(),;
                                                ::FastReportFacturaRectificativa(),;
                                                ::FastReportTicket( .t. ),;
                                                ::FastReportPedidoProveedor(),;
                                                ::FastReportAlbaranProveedor(),;
                                                ::FastReportFacturaProveedor(),;
                                                ::FastReportRectificativaProveedor(),;
                                                ::FastReportParteProduccion() } },;   
                     "Stocks" => ;
                        {  "Generate" =>  {||   ::AddArticulo() },;
                           "Variable" =>  {||   ::AddVariableStock() },;
                           "Data" =>      {||   nil } },;
                     "Stocks almacenes" => ;
                        {  "Generate" =>  {||   ::AddArticulo( .t. ) },;
                           "Variable" =>  {||   ::AddVariableStock() },;
                           "Data" =>      {||   nil } } }

Return ( Self )

//---------------------------------------------------------------------------//

Method lValidRegister() CLASS TFastVentasArticulos

   if empty( ::oDbf:cCodArt )
      Return .f.
   end if

   if !::DesdeHastaGrupoCliente()
      Return .f.
   end if

   if !empty( ::oGrupoArticulo ) .and. !( ::oDbf:cCodArt       >= ::oGrupoArticulo:Cargo:getDesde()         .and. ::oDbf:cCodArt    <= ::oGrupoArticulo:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoGFamilia ) .and. !( ::oDbf:cGrpFam       >= ::oGrupoGFamilia:Cargo:getDesde()         .and. ::oDbf:cGrpFam    <= ::oGrupoGFamilia:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoFamilia ) .and. !( ::oDbf:cCodFam        >= ::oGrupoFamilia:Cargo:getDesde()          .and. ::oDbf:cCodFam    <= ::oGrupoFamilia:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoTArticulo ) .and. !( ::oDbf:cCodTip      >= ::oGrupoTArticulo:Cargo:getDesde()        .and. ::oDbf:cCodTip    <= ::oGrupoTArticulo:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoIva ) .and. !( ::oDbf:TipoIva            >= ::oGrupoIva:Cargo:getDesde()              .and. ::oDbf:TipoIva    <= ::oGrupoIva:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoCategoria ) .and. !( ::oDbf:cCodCate     >= ::oGrupoCategoria:Cargo:getDesde()        .and. ::oDbf:cCodCate   <= ::oGrupoCategoria:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoEstadoArticulo ) .and. !( ::oDbf:cCodEst >= ::oGrupoEstadoArticulo:Cargo:getDesde()   .and. ::oDbf:cCodEst    <= ::oGrupoEstadoArticulo:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoTemporada ) .and. !( ::oDbf:cCodTemp     >= ::oGrupoTemporada:Cargo:getDesde()        .and. ::oDbf:cCodTemp   <= ::oGrupoTemporada:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoFabricante ) .and. !( ::oDbf:cCodFab     >= ::oGrupoFabricante:Cargo:getDesde()       .and. ::oDbf:cCodFab    <= ::oGrupoFabricante:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoCliente ) .and. !( ::oDbf:cCodCli        >= ::oGrupoCliente:Cargo:getDesde()          .and. ::oDbf:cCodCli    <= ::oGrupoCliente:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoFpago ) .and. !( ::oDbf:cCodPago         >= ::oGrupoFpago:Cargo:getDesde()            .and. ::oDbf:cCodPago   <= ::oGrupoFpago:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoRuta ) .and. !( ::oDbf:cCodRut           >= ::oGrupoRuta:Cargo:getDesde()             .and. ::oDbf:cCodRut    <= ::oGrupoRuta:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoAgente ) .and. !( ::oDbf:cCodAge         >= ::oGrupoAgente:Cargo:getDesde()           .and. ::oDbf:cCodAge    <= ::oGrupoAgente:Cargo:getHasta() )
      Return .f.
   end if
   
   if !empty( ::oGrupoTransportista ) .and. !( ::oDbf:cCodTrn  >= ::oGrupoTransportista:Cargo:getDesde()    .and. ::oDbf:cCodTrn    <= ::oGrupoTransportista:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoUsuario ) .and. !( ::oDbf:cCodUsr        >= ::oGrupoUsuario:Cargo:getDesde()          .and. ::oDbf:cCodUsr    <= ::oGrupoUsuario:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoProveedor ) .and. !( ::oDbf:cCodCli      >= ::oGrupoProveedor:Cargo:getDesde()        .and. ::oDbf:cCodCli    <= ::oGrupoProveedor:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoAlmacen ) .and. !( ::oDbf:cCodAlm        >= ::oGrupoAlmacen:Cargo:getDesde()          .and. ::oDbf:cCodAlm    <= ::oGrupoAlmacen:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoCentroCoste ) .and. !( ::oDbf:cCtrCoste  >= ::oGrupoCentroCoste:Cargo:getDesde()      .and. ::oDbf:cCtrCoste  <= ::oGrupoCentroCoste:Cargo:getHasta() )
      Return .f.
   end if
   
   if !empty( ::oGrupoOperario ) .and. !( ::oDbf:cCodOpe       >= ::oGrupoOperario:Cargo:getDesde()         .and. ::oDbf:cCodOpe    <= ::oGrupoOperario:Cargo:getHasta() )
      Return .f.
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DesdeHastaGrupoCliente() CLASS TFastVentasArticulos

   if !Empty( ::oGrupoGCliente )

      if !( ::oDbf:cCodGrp >= ::oGrupoGCliente:Cargo:getDesde() .or. ascan( ::aChildDesdeGrupoCliente, {|cChild| ::oDbf:cCodGrp == cChild } ) != 0 )
         Return .f.
      end if 

      if !( ::oDbf:cCodGrp <= ::oGrupoGCliente:Cargo:getHasta() .or. ascan( ::aChildHastaGrupoCliente, {|cChild| ::oDbf:cCodGrp == cChild } ) != 0 )
         Return .f.
      end if
    
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD BuildTree( oTree, lLoadFile ) CLASS TFastVentasArticulos

   local aReports

   DEFAULT oTree           := ::oTreeReporting
   DEFAULT lLoadFile       := .t. 

   aReports := {  {  "Title" => "Listado",                        "Image" => 0,  "Type" => "Listado",                      "Directory" => "Articulos\Listado",                            "File" => "Listado.fr3"  },;
                  {  "Title" => "General",                        "Image" => 24, "Type" => "General",                      "Directory" => "Articulos\General",                            "File" => "Movimientos generales.fr3"  },;
                  {  "Title" => "Compras/Ventas/Producci�n",      "Image" => 24, "Type" => "Todos los movimientos",        "Directory" => "Articulos\Movimientos",                        "File" => "Todos los movimientos.fr3"  },;
                  {  "Title" => "Ventas",                         "Image" => 11, "Subnode" =>;
                  { ;
                     { "Title"      => "SAT de clientes",;
                       "Image"      => 20,;
                       "Type"       => "SAT de clientes",;          
                       "Directory"  => "Articulos\Ventas\SAT de clientes",;  
                       "File"       => "SAT de clientes.fr3" ,;              
                       "Options"    => {  "Incluir clientes sin ventas" => {  "Options"   => .f.,;
                                                                              "Value"     => .f. } } },;  
                     { "Title"      => "Presupuestos de clientes",;     
                       "Image"      => 5,; 
                       "Type"       => "Presupuestos de clientes",;      
                       "Directory"  => "Articulos\Ventas\Presupuestos de clientes",;    
                       "File"       => "Presupuestos de clientes.fr3" ,;     
                       "Options"    => {  "Incluir clientes sin ventas" => {  "Options"   => .f.,;
                                                                              "Value"     => .f. } } },;
                     { "Title"      => "Pedidos de clientes",;          
                       "Image"      => 6,; 
                       "Type"       => "Pedidos de clientes",;           
                       "Directory"  => "Articulos\Ventas\Pedidos de clientes",;         
                       "File"       => "Pedidos de clientes.fr3" ,;          
                       "Options"    => {  "Incluir clientes sin ventas" => {  "Options"   => .f.,;
                                                                              "Value"     => .f. } } },;
                     { "Title"      => "Albaranes de clientes",;        
                       "Image"      => 7,; 
                       "Type"       => "Albaranes de clientes",;         
                       "Directory"  => "Articulos\Ventas\Albaranes de clientes",;       
                       "File"       => "Albaranes de clientes.fr3" ,;        
                       "Options"    => {  "Incluir clientes sin ventas" => {  "Options"   => .f.,;
                                                                              "Value"     => .f. } } },;
                     { "Title"      => "Facturas de clientes",;         
                       "Image"      => 8,; 
                       "Type"       => "Facturas de clientes",;          
                       "Directory"  => "Articulos\Ventas\Facturas de clientes",;        
                       "File"       => "Facturas de clientes.fr3" ,;         
                       "Options"    => {  "Incluir clientes sin ventas" => {  "Options"   => .f.,;
                                                                              "Value"     => .f. } } },;
                     { "Title"      => "Rectificativas de clientes",;   
                       "Image"      => 9,; 
                       "Type"       => "Rectificativas de clientes",;    
                       "Directory"  => "Articulos\Ventas\Rectificativas de clientes",;  
                       "File"       => "Rectificativas de clientes.fr3" ,;   
                       "Options"    => {  "Incluir clientes sin ventas" => {  "Options"   => .f.,;
                                                                              "Value"     => .f. } } },;
                     { "Title"      => "Tickets de clientes",;          
                       "Image"      =>10,; 
                       "Type"       => "Tickets de clientes",;           
                       "Directory"  => "Articulos\Ventas\Tickets de clientes",;         
                       "File"       => "Tickets de clientes.fr3" ,;          
                       "Options"    => {  "Incluir clientes sin ventas" => {  "Options"   => .f.,;
                                                                              "Value"     => .f. } } },;
                     {  "Title"     => "Ventas",;
                        "Image"     => 11,;
                        "Type"      => "Ventas",;
                        "Directory" => "Articulos\Ventas\Ventas",;
                        "File"      => "Ventas.fr3",;
                        "Options"   => {  "Incluir clientes sin ventas" => {  "Options"   => .f.,;
                                                                              "Value"     => .f. } } },;
                  } ;
                  },;
                  {  "Title" => "Producci�n",                     "Image" => 14, "Subnode" =>;
                  { ;
                     { "Title" => "Partes de producci�n",         "Image" => 14, "Type" => "Partes de producci�n",         "Directory" => "Articulos\Producci�n\Partes de producci�n",    "File" => "Partes de producci�n.fr3" },;
                  } ;
                  },; 
                  {  "Title" => "Compras",                        "Image" => 12, "Subnode" =>;
                  { ;
                     { "Title" => "Pedidos de proveedores",       "Image" => 2, "Type" => "Pedidos de proveedores",        "Directory" => "Articulos\Compras\Pedidos de proveedores",        "File" => "Pedidos de proveedores.fr3" },;
                     { "Title" => "Albaranes de proveedores",     "Image" => 3, "Type" => "Albaranes de proveedores",      "Directory" => "Articulos\Compras\Albaranes de proveedores",      "File" => "Albaranes de proveedores.fr3" },;
                     { "Title" => "Facturas de proveedores",      "Image" => 4, "Type" => "Facturas de proveedores",       "Directory" => "Articulos\Compras\Facturas de proveedores",       "File" => "Facturas de proveedores.fr3" },;
                     { "Title" => "Rectificativas de proveedores","Image" =>15, "Type" => "Rectificativas de proveedores", "Directory" => "Articulos\Compras\Rectificativas de proveedores", "File" => "Rectificativas de proveedores.fr3" },;
                     { "Title" => "Compras",                      "Image" =>12, "Type" => "Compras",                       "Directory" => "Articulos\Compras\Compras",                       "File" => "Compras.fr3" },;
                  } ;
                  },;                  
                  { "Title" => "Movimientos almac�n",             "Image" => 25, "Type" => "Movimientosalmacen",           "Directory" => "Articulos\MovimientosAlmacen",                    "File" => "Movimientos.fr3" },;
                  {  "Title" => "Compras/Ventas",                 "Image" => 12, "Subnode" =>;
                  { ;
                     { "Title" => "Compras y ventas",             "Image" => 2, "Type" => "Compras y ventas",              "Directory" => "Articulos\ComprasVentas",                         "File" => "Compras y ventas.fr3" },;
                  } ;
                  },; 
                  {  "Title" => "Existencias",                    "Image" => 16, "Subnode" =>;
                  { ;
                     { "Title" => "Stocks",                       "Image" => 16, "Type" => "Stocks",                       "Directory" => "Articulos\Existencias\Stocks",                    "File" => "Existencias por stock.fr3" },;
                     { "Title" => "Stock de todos los almacenes", "Image" => 16, "Type" => "Stocks almacenes",             "Directory" => "Articulos\Existencias\StocksAlmacenes",           "File" => "Stocks por almacenes.fr3" },;
                  } ;
                  } }

   do case 
      case ( ::uParam == ALB_CLI )
      
         aReports := { { "Title" => "Albaranes de clientes",        "Image" => 7, "Type" => "Albaranes de clientes",       "Directory" => "Articulos\Ventas\Albaranes de clientes",          "File" => "Albaranes de clientes.fr3" } }

   end case

   ::BuildNode( aReports, oTree, lLoadFile )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DataReport() CLASS TFastVentasArticulos

   ::oFastReport:ClearDataSets()

   /*
   Zona de detalle-------------------------------------------------------------
   */

   ::oFastReport:SetWorkArea(       "Informe",                    ::oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Informe",                    cObjectsToReport( ::oDbf ) )

   /*
   Zona de datos---------------------------------------------------------------
   */

   ::oFastReport:SetWorkArea(       "Empresa",                    ::oDbfEmp:nArea )
   ::oFastReport:SetFieldAliases(   "Empresa",                    cItemsToReport( aItmEmp() ) )

   ::oFastReport:SetWorkArea(       "Art�culos.Informe",          ::oDbfArt:nArea )
   ::oFastReport:SetFieldAliases(   "Art�culos.Informe",          cItemsToReport( aItmArt() ) )

   ::oFastReport:SetWorkArea(       "Art�culos.Escandallos",      ::oDbfArt:nArea )
   ::oFastReport:SetFieldAliases(   "Art�culos.Escandallos",      cItemsToReport( aItmArt() ) )

   ::oFastReport:SetWorkArea(       "Imagenes",                   ::oArtImg:nArea )
   ::oFastReport:SetFieldAliases(   "Imagenes",                   cItemsToReport( aItmImg() ) )

   ::oFastReport:SetWorkArea(       "C�digos de barras",          ::oArtCod:nArea )
   ::oFastReport:SetFieldAliases(   "C�digos de barras",          cItemsToReport( aItmBar() ) )

   ::oFastReport:SetWorkArea(       "Escandallos",                ::oArtKit:nArea )
   ::oFastReport:SetFieldAliases(   "Escandallos",                cItemsToReport( aItmKit() ) )

   ::oFastReport:SetWorkArea(       "Familias",                   ::oDbfFam:nArea )
   ::oFastReport:SetFieldAliases(   "Familias",                   cItemsToReport( aItmFam() ) )

   ::oFastReport:SetWorkArea(       "Tipo art�culos",             ::oTipArt:Select() )
   ::oFastReport:SetFieldAliases(   "Tipo art�culos",             cObjectsToReport( ::oTipArt:oDbf ) )

   ::oFastReport:SetWorkArea(       "Grupos familias",            ::oGruFam:Select() )
   ::oFastReport:SetFieldAliases(   "Grupos familias",            cObjectsToReport( ::oGruFam:oDbf ) )

   ::oFastReport:SetWorkArea(       "Categorias",                 ::oDbfCat:nArea )
   ::oFastReport:SetFieldAliases(   "Categorias",                 cItemsToReport( aItmCategoria() ) )

   ::oFastReport:SetWorkArea(       "Temporadas",                 ::oDbfTmp:nArea )
   ::oFastReport:SetFieldAliases(   "Temporadas",                 cItemsToReport( aItmTemporada() ) )

   ::oFastReport:SetWorkArea(       "Fabricantes",                ::oDbfFab:Select() )
   ::oFastReport:SetFieldAliases(   "Fabricantes",                cObjectsToReport( ::oDbfFab:oDbf ) )

   ::oFastReport:SetWorkArea(       "Estado art�culo",            ::oDbfEstArt:nArea )
   ::oFastReport:SetFieldAliases(   "Estado art�culo",            cItemsToReport( aItmEstadoSat() ) )

   ::oFastReport:SetWorkArea(       "Tipos de " + cImp(),         ::oDbfIva:nArea )
   ::oFastReport:SetFieldAliases(   "Tipos de " + cImp(),         cItemsToReport( aItmTIva() ) )

   ::oFastReport:SetWorkArea(       "Clientes",                   ::oDbfCli:nArea )
   ::oFastReport:SetFieldAliases(   "Clientes",                   cItemsToReport( aItmCli() ) )

   ::oFastReport:SetWorkArea(       "Proveedores",                ::oDbfPrv:nArea )
   ::oFastReport:SetFieldAliases(   "Proveedores",                cItemsToReport( aItmPrv() ) )

   ::oFastReport:SetWorkArea(       "Proveedores habituales",     ::oDbfPrv:nArea )
   ::oFastReport:SetFieldAliases(   "Proveedores habituales",     cItemsToReport( aItmPrv() ) )

   ::oFastReport:SetWorkArea(       "Almacenes",                  ::oDbfAlm:nArea )
   ::oFastReport:SetFieldAliases(   "Almacenes",                  cItemsToReport( aItmAlm() ) )

   ::oFastReport:SetWorkArea(       "Usuarios",                   ::oDbfUsr:nArea ) 
   ::oFastReport:SetFieldAliases(   "Usuarios",                   cItemsToReport( aItmUsuario() ) )

   ::oFastReport:SetWorkArea(       "Stock por almac�n",          ::oArtAlm:nArea )
   ::oFastReport:SetFieldAliases(   "Stock por almac�n",          cItemsToReport( aItmStockaAlmacenes() ) )

   ::oFastReport:SetWorkArea(       "Centro de coste",            ::oCtrCoste:Select() )
   ::oFastReport:SetFieldAliases(   "Centro de coste",            cObjectsToReport( ::oCtrCoste:oDbf ) )

   ::oFastReport:SetWorkArea(       "Direcciones",                ::oObras:nArea ) 
   ::oFastReport:SetFieldAliases(   "Direcciones",                cItemsToReport( aItmObr() ) )

   ::oFastReport:SetWorkArea(       "Rutas",                         ::oDbfRut:nArea ) 
   ::oFastReport:SetFieldAliases(   "Rutas",                         cItemsToReport( aItmRut() ) )

   ::oFastReport:SetWorkArea(       "Propiedades 1",                 ::oPrp1:nArea ) 
   ::oFastReport:SetFieldAliases(   "Propiedades 1",                 cItemsToReport( aItmPro() ) )

   ::oFastReport:SetWorkArea(       "Propiedades 2",                 ::oPrp2:nArea ) 
   ::oFastReport:SetFieldAliases(   "Propiedades 2",                 cItemsToReport( aItmPro() ) )

   ::oFastReport:SetWorkArea(       "Codificaci�n de proveedores",   ::oArtPrv:nArea )
   ::oFastReport:SetFieldAliases(   "Codificaci�n de proveedores",   cItemsToReport( aItmArtPrv() ) )

   ::oFastReport:SetWorkArea(       "Operario",                      ::oOperario:Select() )
   ::oFastReport:SetFieldAliases(   "Operario",                      cObjectsToReport( ::oOperario:oDbf ) )

   ::oFastReport:SetWorkArea(       "Grupo clientes",                ::oGrpCli:Select() )
   ::oFastReport:SetFieldAliases(   "Grupo clientes",                cObjectsToReport( ::oGrpCli:oDbf ) )

   ::oFastReport:SetWorkArea(       "Agentes",                       ::oDbfAge:nArea )
   ::oFastReport:SetFieldAliases(   "Agentes",                       cItemsToReport( aItmAge() ) )

   ::oFastReport:SetWorkArea(       "Atipicas de clientes",          ::oAtipicasCliente:nArea )
   ::oFastReport:SetFieldAliases(   "Atipicas de clientes",          cItemsToReport( aItmAtp() ) )

   ::oFastReport:SetWorkArea(       "Tipo envases",                  ::oFraPub:Select() )
   ::oFastReport:SetFieldAliases(   "Tipo envases",                  cObjectsToReport( ::oFraPub:oDbf ) )

   ::oFastReport:SetWorkArea(       "Transportistas",                ::oDbfTrn:Select() )
   ::oFastReport:SetFieldAliases(   "Transportistas",                cObjectsToReport( ::oDbfTrn:oDbf ) )

   ::oFastReport:SetWorkArea(       "Formas de pago",                ::oDbfFpg:nArea )
   ::oFastReport:SetFieldAliases(   "Formas de pago",                cItemsToReport( aItmFPago() ) )

   // Relaciones entre tablas-----------------------------------------------------

   ::oFastReport:SetMasterDetail(   "Art�culos.Informe", "Familias",                {|| ::oDbfArt:Familia } )
   ::oFastReport:SetMasterDetail(   "Art�culos.Informe", "Tipo art�culos",          {|| ::oDbfArt:cCodTip } )
   ::oFastReport:SetMasterDetail(   "Art�culos.Informe", "Categorias",              {|| ::oDbfArt:cCodCate } )
   ::oFastReport:SetMasterDetail(   "Art�culos.Informe", "Temporadas",              {|| ::oDbfArt:cCodTemp } )
   ::oFastReport:SetMasterDetail(   "Art�culos.Informe", "Fabricantes",             {|| ::oDbfArt:cCodFab } )
   ::oFastReport:SetMasterDetail(   "Art�culos.Informe", "Tipos de " + cImp(),      {|| ::oDbfArt:TipoIva } )

   ::oFastReport:SetMasterDetail(   "Escandallos", "Art�culos.Escandallos",         {|| ::oArtKit:cRefKit } )
   
   ::oFastReport:SetMasterDetail(   "Codificaci�n de proveedores", "Proveedores habituales",   {|| ::oArtPrv:cCodPrv } )
   
   ::oFastReport:SetMasterDetail(   "Informe", "Empresa",                           {|| cCodEmp() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Clientes",                          {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Grupo clientes",                    {|| ::oDbf:cCodGrp } )
   ::oFastReport:SetMasterDetail(   "Informe", "Formas de pago",                    {|| ::oDbf:cCodPago } )
   
   ::oFastReport:SetMasterDetail(   "Informe", "Proveedores",                       {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Usuarios",                          {|| ::oDbf:cCodUsr } )
   ::oFastReport:SetMasterDetail(   "Informe", "Almacenes",                         {|| ::oDbf:cCodAlm } )
   ::oFastReport:SetMasterDetail(   "Informe", "Direcciones",                       {|| ::oDbf:cCodCli + ::oDbf:cCodObr } )
   ::oFastReport:SetMasterDetail(   "Informe", "Rutas",                             {|| ::oDbf:cCodRut } )
   ::oFastReport:SetMasterDetail(   "Informe", "Estado art�culo",                   {|| ::oDbf:cCodEst } )
   ::oFastReport:SetMasterDetail(   "Informe", "Operario",                          {|| ::oDbf:cCodOpe } )
   ::oFastReport:SetMasterDetail(   "Informe", "Grupos familias",                   {|| ::oDbf:cGrpFam } )
   ::oFastReport:SetMasterDetail(   "Informe", "Agentes",                           {|| ::oDbf:cCodAge } )
   ::oFastReport:SetMasterDetail(   "Informe", "Tipo envases",                      {|| ::oDbf:cCodEnv } )
   ::oFastReport:SetMasterDetail(   "Informe", "Transportistas",                    {|| ::oDbf:cCodTrn } )

   ::oFastReport:SetMasterDetail(   "Informe", "Atipicas de clientes",              {|| ::oDbf:cCodCli + ::oDbf:cCodArt } )

   ::oFastReport:SetMasterDetail(   "Informe", "Art�culos.Informe",                 {|| ::oDbf:cCodArt } )  
   ::oFastReport:SetMasterDetail(   "Informe", "Imagenes",                          {|| ::oDbf:cCodArt } )
   ::oFastReport:SetMasterDetail(   "Informe", "Escandallos",                       {|| ::oDbf:cCodArt } )
   ::oFastReport:SetMasterDetail(   "Informe", "C�digos de barras",                 {|| ::oDbf:cCodArt } )
   ::oFastReport:SetMasterDetail(   "Informe", "Codificaci�n de proveedores",       {|| ::oDbf:cCodArt } )

   ::oFastReport:SetMasterDetail(   "Informe", "Stock por almac�n",                 {|| ::oDbf:cCodArt + ::oDbf:cCodAlm } )
   ::oFastReport:SetMasterDetail(   "Informe", "Centro de coste",                   {|| ::oDbf:cCtrCoste } )   

   ::oFastReport:SetMasterDetail(   "Informe", "Propiedades 1",                     {|| ::oDbf:cCodPr1 + ::oDbf:cValPr1 } )   
   ::oFastReport:SetMasterDetail(   "Informe", "Propiedades 2",                     {|| ::oDbf:cCodPr2 + ::oDbf:cValPr2 } )   


   // Resincronizar con los movimientos-------------------------------------------

   ::oFastReport:SetResyncPair(     "Art�culos.Informe", "Familias" )
   ::oFastReport:SetResyncPair(     "Art�culos.Informe", "Tipo art�culos" )
   ::oFastReport:SetResyncPair(     "Art�culos.Informe", "Categorias" )
   ::oFastReport:SetResyncPair(     "Art�culos.Informe", "Temporadas" )
   ::oFastReport:SetResyncPair(     "Art�culos.Informe", "Fabricantes" )
   ::oFastReport:SetResyncPair(     "Art�culos.Informe", "Tipos de " + cImp() )
   
   ::oFastReport:SetResyncPair(     "Escandallos", "Art�culos.Escandallos" )
   
   ::oFastReport:SetResyncPair(     "Codificaci�n de proveedores", "Proveedores habituales" )   

   ::oFastReport:SetResyncPair(     "Informe", "Clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Grupo clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Proveedores" )
   ::oFastReport:SetResyncPair(     "Informe", "Formas de pago" )
   ::oFastReport:SetResyncPair(     "Informe", "Empresa" )
   ::oFastReport:SetResyncPair(     "Informe", "Usuarios" )
   ::oFastReport:SetResyncPair(     "Informe", "Almacenes" )
   ::oFastReport:SetResyncPair(     "Informe", "Direcciones" )
   ::oFastReport:SetResyncPair(     "Informe", "Rutas" )
   ::oFastReport:SetResyncPair(     "Informe", "Codificaci�n de proveedores" )
   ::oFastReport:SetResyncPair(     "Informe", "Estado art�culo" )
   ::oFastReport:SetResyncPair(     "Informe", "Operario" )
   ::oFastReport:SetResyncPair(     "Informe", "Grupos familias" )
   ::oFastReport:SetResyncPair(     "Informe", "Agentes" )
   ::oFastReport:SetResyncPair(     "Informe", "Tipo envases" )
   ::oFastReport:SetResyncPair(     "Informe", "Transportistas" )

   ::oFastReport:SetResyncPair(     "Informe", "Art�culos.Informe" )
   ::oFastReport:SetResyncPair(     "Informe", "Imagenes" )
   ::oFastReport:SetResyncPair(     "Informe", "Escandallos" )
   ::oFastReport:SetResyncPair(     "Informe", "C�digos de barras" )
   ::oFastReport:SetResyncPair(     "Informe", "Stock por almac�n" )  
   ::oFastReport:SetResyncPair(     "Informe", "Centro de coste" ) 

   ::oFastReport:SetResyncPair(     "Informe", "Atipicas de clientes" )

   ::oFastReport:SetResyncPair(     "Informe", "Propiedades 1" )   
   ::oFastReport:SetResyncPair(     "Informe", "Propiedades 2" )   


   ::SetDataReport()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD loadPropiedadesArticulos( cCodigoArticulo )

   if ( ::oDbfArt:cAlias )->( dbseek( cCodigoArticulo ) )
      ::oDbf:cCodTip    := ( ::oDbfArt:cAlias )->cCodTip
      ::oDbf:cCodCate   := ( ::oDbfArt:cAlias )->cCodCate
      ::oDbf:cCodEst    := ( ::oDbfArt:cAlias )->cCodEst
      ::oDbf:cCodTemp   := ( ::oDbfArt:cAlias )->cCodTemp
      ::oDbf:cCodFab    := ( ::oDbfArt:cAlias )->cCodFab
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddSATClientes() CLASS TFastVentasArticulos

   ::oSatCliT:OrdSetFocus( "dFecSat" )
   ::oSatCliL:OrdSetFocus( "nNumSat" )

   // filtros para la cabecera------------------------------------------------

   ::cExpresionHeader         := '( Field->dFecSat >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecSat <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader         += ' .and. ( Field->cSerSat >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerSat <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionHeader         += ' .and. ( Field->nNumSat >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )   + '" ) .and. Field->nNumSat <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionHeader         += ' .and. ( Field->cSufSat >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufSat <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'
   
   ::setFilterClientIdHeader()

   ::setFilterPaymentInvoiceId()

   ::setFilterRouteId() 

   ::setFilterTransportId()

   ::setFilterUserId()

   ::setFilterOperarioId()

   ::setFilterAgent()

   // filtros para las l�neas-------------------------------------------------

   ::cExpresionLine           := '!lTotLin .and. !lControl'
   ::cExpresionLine           += ' .and. ( Field->cSerSat >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerSat <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine           += ' .and. ( Field->nNumSat >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )   + '" ) .and. Field->nNumSat <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine           += ' .and. ( Field->cSufSat >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufSat <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterProductIdLine()

   ::setFilterStoreLine()

   ::setFilterFamily() 

   ::setFilterGroupFamily() 

   // Procesando SAT ------------------------------------------------

   ::setMeterText( "Procesando SAT" )

   ::oSatCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oSatCliL:cFile ), ::oSatCliL:OrdKey(), ( ::cExpresionLine ), , , , , , , , .t. )
   ::oSatCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oSatCliT:cFile ), ::oSatCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )
   
   ::setMeterTotal( ::oSatCliT:OrdKeyCount() )

   /*
   Lineas de Sat---------------------------------------------------------------
   */

   ::oSatCliT:GoTop()
   while !::lBreak .and. !::oSatCliT:Eof()

      if lChkSer( ::oSatCliT:cSerSat, ::aSer )

         if ::oSatCliL:Seek( ::oSatCliT:cSerSat + Str( ::oSatCliT:nNumSat ) + ::oSatCliT:cSufSat )

            while !::lBreak .and. ( ::oSatCliT:cSerSat + Str( ::oSatCliT:nNumSat ) + ::oSatCliT:cSufSat == ::oSatCliL:cSerSat + Str( ::oSatCliL:nNumSat ) + ::oSatCliL:cSufSat )

               /*
               Añadimos un nuevo registro-----------------------------------
               */

               ::oDbf:Blank()

               ::oDbf:cCodArt    := ::oSatCliL:cRef
               ::oDbf:cNomArt    := ::oSatCliL:cDetalle

               ::oDbf:cCodPr1    := ::oSatCliL:cCodPr1
               ::oDbf:cCodPr2    := ::oSatCliL:cCodPr2
               ::oDbf:cValPr1    := ::oSatCliL:cValPr1
               ::oDbf:cValPr2    := ::oSatCliL:cValPr2

               ::oDbf:cCodPrv    := ::oSatCliL:cCodPrv
               ::oDbf:cNomPrv    := RetFld( ::oSatCliL:cCodPrv, ::oDbfPrv:cAlias )

               ::oDbf:cCodFam    := ::oSatCliL:cCodFam
               ::oDbf:cGrpFam    := ::oSatCliL:cGrpFam
               ::oDbf:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, ::oSatCliL:nIva )
               ::oDbf:cCodTip    := RetFld( ::oSatCliL:cRef, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
               ::oDbf:cCodCate   := RetFld( ::oSatCliL:cRef, ::oDbfArt:cAlias, "cCodCate", "Codigo" )
               ::oDbf:cCodEst    := ::oSatCliT:cCodEst
               ::oDbf:cCodTemp   := RetFld( ::oSatCliL:cRef, ::oDbfArt:cAlias, "cCodTemp", "Codigo" )
               ::oDbf:cCodFab    := RetFld( ::oSatCliL:cRef, ::oDbfArt:cAlias, "cCodFab", "Codigo" )
               ::oDbf:cDesUbi    := RetFld( ::oSatCliL:cRef, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )

               if ::oAtipicasCliente:Seek( ::oSatCliT:cCodCli + ::oSatCliL:cRef ) .and. !empty( ::oAtipicasCliente:cCodEnv )
                  ::oDbf:cCodEnv    := ::oAtipicasCliente:cCodEnv
               else
                  ::oDbf:cCodEnv    := RetFld( ::oSatCliL:cRef, ::oDbfArt:cAlias, "cCodFra", "Codigo" )                    
               end if
               
               ::oDbf:cCodAlm    := ::oSatCliL:cAlmLin
               ::oDbf:cCodPago   := ::oSatCliT:cCodPgo
               ::oDbf:cCodRut    := ::oSatCliT:cCodRut
               ::oDbf:cCodAge    := ::oSatCliT:cCodAge
               ::oDbf:cCodTrn    := ::oSatCliT:cCodTrn
               ::oDbf:cCodUsr    := ::oSatCliT:cCodUsr
               ::oDbf:cCodOpe    := ::oSatCliT:cCodOpe

               ::oDbf:cCodCli    := ::oSatCliT:cCodCli
               ::oDbf:cNomCli    := ::oSatCliT:cNomCli
               ::oDbf:cPobCli    := ::oSatCliT:cPobCli
               ::oDbf:cPrvCli    := ::oSatCliT:cPrvCli
               ::oDbf:cPosCli    := ::oSatCliT:cPosCli
               ::oDbf:cCodObr    := ::oSatCliL:cObrLin
               ::oDbf:cCodGrp    := cGruCli( ::oSatCliT:cCodCli, ::oDbfCli )

               ::oDbf:nTotDto    := nDtoLSATCli( ::oSatCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotPrm    := nPrmLSATCli( ::oSatCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

               ::oDbf:nUniArt    := nTotNSATCli( ::oSatCliL:cAlias )

               ::oDbf:nDtoArt    := ::oSatCliL:nDto
               ::oDbf:nLinArt    := ::oSatCliL:nDtoDiv 
               ::oDbf:nPrmArt    := ::oSatCliL:nDtoPrm

               ::oDbf:nPreArt    := nImpUSATCli( ::oSatCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nTrnArt    := nTrnUSATCli( ::oSatCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nPntArt    := nPntLSATCli( ::oSatCliL:cAlias, ::nDecOut, ::nValDiv )

               ::oDbf:nBrtArt    := nBrtLSATCli( ::oSatCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nImpArt    := nImpLSATCli( ::oSatCliT:cAlias, ::oSatCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
               ::oDbf:nIvaArt    := nIvaLSATCli( ::oSatCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nImpEsp    := nTotISatCli( ::oSatCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotArt    := nImpLSATCli( ::oSatCliT:cAlias, ::oSatCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
               ::oDbf:nTotArt    += nIvaLSATCli( ::oSatCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

               ::oDbf:nPctAge    := ::oSatCliT:nPctComAge
               ::oDbf:nComAge    := nComLSatCli( ::oSatCliT:cAlias, ::oSatCliL:cAlias, ::nDecOut, ::nDerOut )

               ::oDbf:nCosArt    := nTotCSATCli( ::oSatCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               if empty( ::oDbf:nCosArt )
                  ::oDbf:nCosArt := ::oDbf:nUniArt * pCosto( ::oDbfArt:cAlias )
               end if 

               ::oDbf:cClsDoc    := SAT_CLI
               ::oDbf:cTipDoc    := "SAT cliente"
               ::oDbf:cSerDoc    := ::oSatCliT:cSerSat
               ::oDbf:cNumDoc    := Str( ::oSatCliT:nNumSat )
               ::oDbf:cSufDoc    := ::oSatCliT:cSufSat

               ::oDbf:cIdeDoc    :=  ::idDocumento()
               ::oDbf:nNumLin    :=  ::oSatCliL:nNumLin

               ::oDbf:nAnoDoc    := Year( ::oSatCliT:dFecSat )
               ::oDbf:nMesDoc    := Month( ::oSatCliT:dFecSat )
               ::oDbf:dFecDoc    := ::oSatCliT:dFecSat
               ::oDbf:cHorDoc    := SubStr( ::oSatCliT:cTimCre, 1, 2 )
               ::oDbf:cMinDoc    := SubStr( ::oSatCliT:cTimCre, 4, 2 )

               ::oDbf:nBultos    := ::oSatCliL:nBultos
               ::oDbf:cFormato   := ::osatCliL:cFormato
               ::oDbf:nCajas     := ::oSatCliL:nCanSat
               ::oDbf:nPeso      := nPesLSatCli( ::oSatCliL:cAlias )

               ::oDbf:lKitArt    := ::oSatCliL:lKitArt
               ::oDbf:lKitChl    := ::oSatCliL:lKitChl

               ::oDbf:cCtrCoste  := ::oSatCliL:cCtrCoste
               ::oDbf:cTipCtr    := ::oSatCliL:cTipCtr
               ::oDbf:cCodTerCtr := ::oSatCliL:cTerCtr
               ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ::oSatCliL:cTipCtr, ::oSatCliL:cTerCtr, ::nView )

               if ::oSatCliT:lEstado
                  ::oDbf:cEstado := "Pendiente"
               else
                  ::oDbf:cEstado := "Finalizado"
               end if

               if !empty( ::oSatCliL:cCodPrv ) 
                  ::oDbf:cPrvHab := ::oSatCliL:cCodPrv
               else
                  ::oDbf:cPrvHab := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )
               end if 

               ::InsertIfValid()

               ::loadValuesExtraFields()

               ::oSatCliL:Skip()

            end while

         end if

      end if

      ::oSatCliT:Skip()

      ::setMeterAutoIncremental()

   end while

   ::oSatCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oSatCliT:cFile ) )
   ::oSatCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oSatCliL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddPresupuestoClientes() CLASS TFastVentasArticulos

   ::oPreCliT:OrdSetFocus( "dFecPre" )
   ::oPreCliL:OrdSetFocus( "nNumPre" )

   // filtros para la cabecera------------------------------------------------
   
   ::cExpresionHeader          := '( Field->dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader          += ' .and. ( Field->cSerPre >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerPre <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionHeader          += ' .and. ( Field->nNumPre >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )   + '" ) .and. Field->nNumPre <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionHeader          += ' .and. ( Field->cSufPre >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufPre <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'
   
   ::setFilterClientIdHeader()

   ::setFilterPaymentInvoiceId()

   ::setFilterRouteId() 

   ::setFilterTransportId()
   
   ::setFilterUserId()

   ::setFilterAgent()

   // filtros para las lineas-------------------------------------------------

   ::cExpresionLine           := '!lTotLin .and. !lControl'
   ::cExpresionLine           += ' .and. ( Field->cSerPre >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerPre <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine           += ' .and. ( Field->nNumPre >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumPre <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine           += ' .and. ( Field->cSufPre >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() ) + '" .and. Field->cSufPre <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterProductIdLine()

   ::setFilterStoreLine()

   ::setFilterFamily() 

   ::setFilterGroupFamily()

   // procesamos los presupuestos ---------------------------------------------

   ::setMeterText( "Procesando presupuestos" )
   
   ::oPreCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPreCliT:cFile ), ::oPreCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )
   
   ::oPreCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPreCliL:cFile ), ::oPreCliL:OrdKey(), ( ::cExpresionLine ), , , , , , , , .t. )
  
   ::setMeterTotal( ::oPreCliT:OrdKeyCount() )

   /*
   Lineas de Preidos-----------------------------------------------------------
   */
   
   ::oPreCliT:GoTop()
   while !::lBreak .and. !::oPreCliT:Eof()

      if lChkSer( ::oPreCliT:cSerPre, ::aSer )

         if ::oPreCliL:Seek( ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre )

            while !::lBreak .and. ( ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre == ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre )

               /*
               Añadimos un nuevo registro-----------------------------------
               */

               ::oDbf:Blank()

               ::oDbf:cCodArt    := ::oPreCliL:cRef
               ::oDbf:cNomArt    := ::oPreCliL:cDetalle

               ::oDbf:cCodPr1    := ::oPreCliL:cCodPr1
               ::oDbf:cCodPr2    := ::oPreCliL:cCodPr2
               ::oDbf:cValPr1    := ::oPreCliL:cValPr1
               ::oDbf:cValPr2    := ::oPreCliL:cValPr2

               ::oDbf:cCodPrv    := ::oPreCliL:cCodPrv
               ::oDbf:cNomPrv    := RetFld( ::oPreCliL:cCodPrv, ::oDbfPrv:cAlias )

               ::oDbf:cCodFam    := ::oPreCliL:cCodFam
               ::oDbf:cGrpFam    := ::oPreCliL:cGrpFam
               ::oDbf:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, ::oPreCliL:nIva )
               ::oDbf:cCodTip    := RetFld( ::oPreCliL:cRef, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
               ::oDbf:cCodCate   := RetFld( ::oPreCliL:cRef, ::oDbfArt:cAlias, "cCodCate", "Codigo" )
               ::oDbf:cCodEst    := RetFld( ::oPreCliL:cRef, ::oDbfArt:cAlias, "cCodEst", "Codigo" )
               ::oDbf:cCodTemp   := RetFld( ::oPreCliL:cRef, ::oDbfArt:cAlias, "cCodTemp", "Codigo" )
               ::oDbf:cCodFab    := RetFld( ::oPreCliL:cRef, ::oDbfArt:cAlias, "cCodFab", "Codigo" )
               ::oDbf:cDesUbi    := RetFld( ::oPreCliL:cRef, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )

               if ::oAtipicasCliente:Seek( ::oPreCliT:cCodCli + ::oPreCliL:cRef ) .and. !empty( ::oAtipicasCliente:cCodEnv )
                  ::oDbf:cCodEnv    := ::oAtipicasCliente:cCodEnv
               else
                  ::oDbf:cCodEnv    := RetFld( ::oPreCliL:cRef, ::oDbfArt:cAlias, "cCodFra", "Codigo" )                    
               end if

               ::oDbf:cCodAlm    := ::oPreCliL:cAlmLin
               ::oDbf:cCodPago   := ::oPreCliT:cCodPgo
               ::oDbf:cCodRut    := ::oPreCliT:cCodRut
               ::oDbf:cCodAge    := ::oPreCliT:cCodAge
               ::oDbf:cCodTrn    := ::oPreCliT:cCodTrn
               ::oDbf:cCodUsr    := ::oPreCliT:cCodUsr

               ::oDbf:cCodCli    := ::oPreCliT:cCodCli
               ::oDbf:cNomCli    := ::oPreCliT:cNomCli
               ::oDbf:cPobCli    := ::oPreCliT:cPobCli
               ::oDbf:cPrvCli    := ::oPreCliT:cPrvCli
               ::oDbf:cPosCli    := ::oPreCliT:cPosCli
               ::oDbf:cCodObr    := ::oPreCliL:cObrLin
               ::oDbf:cCodGrp    := cGruCli( ::oPreCliT:cCodCli, ::oDbfCli )

               ::oDbf:nTotDto    := nDtoLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotPrm    := nPrmLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

               ::oDbf:nUniArt    := nTotNPreCli( ::oPreCliL:cAlias )

               ::oDbf:nDtoArt    := ::oPrecliL:nDto
               ::oDbf:nLinArt    := ::oPrecliL:nDtoDiv
               ::oDbf:nPrmArt    := ::oPrecliL:nDtoPrm

               ::oDbf:nPreArt    := nImpUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nTrnArt    := nTrnUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nPntArt    := nPntLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )

               ::oDbf:nBrtArt    := nBrtLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nImpArt    := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
               ::oDbf:nIvaArt    := nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nImpEsp    := nTotIPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotArt    := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
               ::oDbf:nTotArt    += nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

               ::oDbf:nPctAge    := ::oPreCliT:nPctComAge
               ::oDbf:nComAge    := nComLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )

               ::oDbf:nCosArt    := nTotCPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               if empty( ::oDbf:nCosArt )
                  ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, ::oDbfArt:cAlias, ::oArtKit:cAlias )
               end if 

               ::oDbf:cClsDoc    := PRE_CLI
               ::oDbf:cTipDoc    := "Presupuesto cliente"
               ::oDbf:cSerDoc    := ::oPreCliT:cSerPre
               ::oDbf:cNumDoc    := Str( ::oPreCliT:nNumPre )
               ::oDbf:cSufDoc    := ::oPreCliT:cSufPre

               ::oDbf:cIdeDoc    :=  ::idDocumento()
               ::oDbf:nNumLin    :=  ::oPreCliL:nNumLin

               ::oDbf:nAnoDoc    := Year( ::oPreCliT:dFecPre )
               ::oDbf:nMesDoc    := Month( ::oPreCliT:dFecPre )
               ::oDbf:dFecDoc    := ::oPreCliT:dFecPre
               ::oDbf:cHorDoc    := SubStr( ::oPreCliT:cTimCre, 1, 2 )
               ::oDbf:cMinDoc    := SubStr( ::oPreCliT:cTimCre, 4, 2 )

               ::oDbf:nBultos    := ::oPreCliL:nBultos
               ::oDbf:cFormato   := ::oPreCliL:cFormato
               ::oDbf:nCajas     := ::oPreCliL:nCanPre
               ::oDbf:nPeso      := nPesLPreCli( ::oPreCliL:cAlias )

               ::oDbf:lKitArt    := ::oPreCliL:lKitArt
               ::oDbf:lKitChl    := ::oPreCliL:lKitChl

               ::oDbf:cCtrCoste  := ::oPreCliL:cCtrCoste
               ::oDbf:cTipCtr    := ::oPreCliL:cTipCtr
               ::oDbf:cCodTerCtr := ::oPreCliL:cTerCtr
               ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ::oPreCliL:cTipCtr, ::oPreCliL:cTerCtr, ::nView )

               if !empty( ::oPreCliL:cCodPrv ) 
                  ::oDbf:cPrvHab := ::oPreCliL:cCodPrv
               else
                  ::oDbf:cPrvHab := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )
               end if

               if ::oPreCliT:lEstado
                  ::oDbf:cEstado := "Pendiente"
               else
                  ::oDbf:cEstado := "Finalizado"
               end if

               ::InsertIfValid()
               
               ::loadValuesExtraFields()

               ::oPreCliL:Skip()

            end while

         end if

      end if

      ::oPreCliT:Skip()

      ::setMeterAutoIncremental()

   end while

   ::oPreCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPreCliT:cFile ) )
   ::oPreCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oPreCliL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddPedidoClientes() CLASS TFastVentasArticulos

   local nUndRecibidas        := 0

   // filtros para la cabecera------------------------------------------------

   ::cExpresionHeader         := '( Field->dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader         += ' .and. !Field->lCancel '
   ::cExpresionHeader         += ' .and. ( Field->cSerPed >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerPed <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '") '
   ::cExpresionHeader         += ' .and. ( Field->nNumPed >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumPed <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" )) '
   ::cExpresionHeader         += ' .and. ( Field->cSufPed >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufPed <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '") '

   ::setFilterClientIdHeader()

   ::setFilterPaymentInvoiceId()

   ::setFilterRouteId() 

   ::setFilterTransportId()
   
   ::setFilterUserId()

   ::setFilterAgent()

   // filtros para la linea----------------------------------------------------

   ::cExpresionLine           := '!Field->lTotLin .and. !Field->lControl'
   ::cExpresionLine           += ' .and. ( Field->cSerPed >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerPed <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine           += ' .and. ( Field->nNumPed >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumPed <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine           += ' .and. ( Field->cSufPed >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() ) + '" .and. Field->cSufPed <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterProductIdLine()

   ::setFilterStoreLine()

   ::setFilterFamily() 

   ::setFilterGroupFamily()

   ::setFilterTypeLine()

   setPedidosClientesExternalView( ::nView )

   // procesamos los pedidos----------------------------------------------------
   
   ::setMeterText( "Procesando pedidos" )

   ( D():PedidosClientes( ::nView )        )->( ordsetfocus( "nNumPed" ) )
   ( D():PedidosClientesLineas( ::nView )  )->( ordsetfocus( "nNumPed" ) )

   ( D():PedidosClientes( ::nView )        )->( setCustomFilter( ::cExpresionHeader ) )
   ( D():PedidosClientesLineas( ::nView )  )->( setCustomFilter( ::cExpresionLine ) )

   ::setMeterTotal( ( D():PedidosClientesLineas( ::nView ) )->( dbCustomKeyCount() ) )

   // Lineas de pedidos-----------------------------------------------------------

   ( D():PedidosClientesLineas( ::nView ) )->( dbgotop() )
   while !::lBreak .and. !( D():PedidosClientesLineas( ::nView ) )->( eof() )

      // Posicionamiento en las cabeceras--------------------------------------

      if ( D():PedidosClientes( ::nView ) )->( dbseek( D():PedidosClientesLineasId( ::nView ) ) )

         // A�adimos un nuevo registro--------------------------------

         ::oDbf:Blank()

         ::oDbf:cClsDoc    := PED_CLI
         ::oDbf:cTipDoc    := "Pedido cliente"
         ::oDbf:cSerDoc    := ( D():PedidosClientesLineas( ::nView ) )->cSerPed
         ::oDbf:cNumDoc    := str( ( D():PedidosClientesLineas( ::nView ) )->nNumPed )
         ::oDbf:cSufDoc    := ( D():PedidosClientesLineas( ::nView ) )->cSufPed

         ::oDbf:cIdeDoc    := ::idDocumento()

         ::oDbf:nNumLin    := ( D():PedidosClientesLineas( ::nView ) )->nNumLin
         ::oDbf:cCodArt    := ( D():PedidosClientesLineas( ::nView ) )->cRef
         ::oDbf:cNomArt    := ( D():PedidosClientesLineas( ::nView ) )->cDetalle

         ::oDbf:cCodPr1    := ( D():PedidosClientesLineas( ::nView ) )->cCodPr1
         ::oDbf:cCodPr2    := ( D():PedidosClientesLineas( ::nView ) )->cCodPr2
         ::oDbf:cValPr1    := ( D():PedidosClientesLineas( ::nView ) )->cValPr1
         ::oDbf:cValPr2    := ( D():PedidosClientesLineas( ::nView ) )->cValPr2

         ::oDbf:cLote      := ( D():PedidosClientesLineas( ::nView ) )->cLote
         ::oDbf:dFecCad    := ( D():PedidosClientesLineas( ::nView ) )->dFecCad

         ::oDbf:cCodPrv    := ( D():PedidosClientesLineas( ::nView ) )->cCodPrv
         ::oDbf:cNomPrv    := RetFld( ( D():PedidosClientesLineas( ::nView ) )->cCodPrv, ::oDbfPrv:cAlias )

         ::oDbf:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, ( D():PedidosClientesLineas( ::nView ) )->nIva )

         ::oDbf:cCodObr    := ( D():PedidosClientesLineas( ::nView ) )->cObrLin

         ::oDbf:cCodFam    := ( D():PedidosClientesLineas( ::nView ) )->cCodFam
         ::oDbf:cGrpFam    := ( D():PedidosClientesLineas( ::nView ) )->cGrpFam
         ::oDbf:cCodAlm    := ( D():PedidosClientesLineas( ::nView ) )->cAlmLin
         ::oDbf:cDesUbi    := RetFld( ( D():PedidosClientesLineas( ::nView ) )->cRef, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )

         ::oDbf:nDtoArt    := ( D():PedidosClientesLineas( ::nView ) )->nDto
         ::oDbf:nLinArt    := ( D():PedidosClientesLineas( ::nView ) )->nDtoDiv
         ::oDbf:nPrmArt    := ( D():PedidosClientesLineas( ::nView ) )->nDtoPrm

         ::oDbf:cCodTip    := ( D():PedidosClientesLineas( ::nView ) )->cCodTip

         ::oDbf:nCosArt    := nTotCPedCli( D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nUniArt    := nTotNPedCli( D():PedidosClientesLineas( ::nView ) ) 

         ::oDbf:cCtrCoste  := ( D():PedidosClientesLineas( ::nView ) )->cCtrCoste
         ::oDbf:cTipCtr    := ( D():PedidosClientesLineas( ::nView ) )->cTipCtr
         ::oDbf:cCodTerCtr := ( D():PedidosClientesLineas( ::nView ) )->cTerCtr
         ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ( D():PedidosClientesLineas( ::nView ) )->cTipCtr, ( D():PedidosClientesLineas( ::nView ) )->cTerCtr, ::nView )

         ::loadPropiedadesArticulos( ( D():PedidosClientesLineas( ::nView ) )->cRef )

         ::oDbf:nAnoDoc    := Year( ( D():PedidosClientes( ::nView ) )->dFecPed )
         ::oDbf:nMesDoc    := Month( ( D():PedidosClientes( ::nView ) )->dFecPed )
         ::oDbf:dFecDoc    := ( D():PedidosClientes( ::nView ) )->dFecPed
         ::oDbf:cHorDoc    := SubStr( ( D():PedidosClientes( ::nView ) )->cTimCre, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ( D():PedidosClientes( ::nView ) )->cTimCre, 4, 2 )

         ::oDbf:cCodGrp    := cGruCli( ( D():PedidosClientes( ::nView ) )->cCodCli, ::oDbfCli )

         ::oDbf:cCodPago   := ( D():PedidosClientes( ::nView ) )->cCodPgo
         ::oDbf:cCodRut    := ( D():PedidosClientes( ::nView ) )->cCodRut
         ::oDbf:cCodAge    := ( D():PedidosClientes( ::nView ) )->cCodAge
         ::oDbf:cCodTrn    := ( D():PedidosClientes( ::nView ) )->cCodTrn
         ::oDbf:cCodUsr    := ( D():PedidosClientes( ::nView ) )->cCodUsr
         ::oDbf:cCodCli    := ( D():PedidosClientes( ::nView ) )->cCodCli
         ::oDbf:cNomCli    := ( D():PedidosClientes( ::nView ) )->cNomCli
         ::oDbf:cPobCli    := ( D():PedidosClientes( ::nView ) )->cPobCli
         ::oDbf:cPrvCli    := ( D():PedidosClientes( ::nView ) )->cPrvCli
         ::oDbf:cPosCli    := ( D():PedidosClientes( ::nView ) )->cPosCli

         if ::oAtipicasCliente:Seek( ( D():PedidosClientes( ::nView ) )->cCodCli + ( D():PedidosClientesLineas( ::nView ) )->cRef ) .and. !empty( ::oAtipicasCliente:cCodEnv )
            ::oDbf:cCodEnv := ::oAtipicasCliente:cCodEnv
         else
            ::oDbf:cCodEnv := RetFld( ( D():PedidosClientesLineas( ::nView ) )->cRef, ::oDbfArt:cAlias, "cCodFra", "Codigo" )                    
         end if

         ::oDbf:nTotDto    := nDtoLPedCli( D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nTotPrm    := nPrmLPedCli( D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nPreArt    := nImpUPedCli( D():PedidosClientes( ::nView ), D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nValDiv )
         ::oDbf:nTrnArt    := nTrnUPedCli( D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nValDiv )
         ::oDbf:nPntArt    := nPntLPedCli( D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nValDiv )

         ::oDbf:nBrtArt    := nBrtLPedCli( D():PedidosClientes( ::nView ), D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nImpArt    := nImpLPedCli( D():PedidosClientes( ::nView ), D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nIvaArt    := nIvaLPedCli( D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nImpEsp    := nTotIPedCli( D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nTotArt    := nImpLPedCli( D():PedidosClientes( ::nView ), D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLPedCli( D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nPeso      := nPesLPedCli( D():PedidosClientesLineas( ::nView ) ) 

         ::oDbf:nPctAge    := ( D():PedidosClientes( ::nView ) )->nPctComAge
         ::oDbf:nComAge    := nComLPedCli( D():PedidosClientes( ::nView ), D():PedidosClientesLineas( ::nView ), ::nDecOut, ::nDerOut )

         if empty( ::oDbf:nCosArt )
            ::oDbf:nCosArt    := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, ::oDbfArt:cAlias, ::oArtKit:cAlias )
         end if 

         if !empty( ( D():PedidosClientesLineas( ::nView ) )->cCodPrv ) 
            ::oDbf:cPrvHab    := ( D():PedidosClientesLineas( ::nView ) )->cCodPrv
         else
            ::oDbf:cPrvHab    := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )
         end if

         ::oDbf:nCargo        := nUnidadesRecibidasAlbaranesClientes( D():PedidosClientesLineasId( ::nView ), ( D():PedidosClientesLineas( ::nView ) )->cRef, ( D():PedidosClientesLineas( ::nView ) )->cValPr1, ( D():PedidosClientesLineas( ::nView ) )->cValPr2, D():AlbaranesClientesLineas( ::nView ) )
         
         if ::oDbf:nUniArt == ::oDbf:nCargo
            ::oDbf:cEstado    := "Finalizado"
         else
            ::oDbf:cEstado    := "Pendiente"
         end if

         ::insertIfValid()

         ::loadValuesExtraFields()

      end if

      ( D():PedidosClientesLineas( ::nView ) )->( dbSkip() )
      
      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddAlbaranCliente( lFacturados ) CLASS TFastVentasArticulos

   DEFAULT lFacturados     := .f.

   ::InitAlbaranesClientes()

   // filtros para la cabecera-------------------------------------------------

   ::cExpresionHeader      := '( Field->dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSerAlb >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerAlb <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionHeader      += ' .and. ( Field->nNumAlb >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumAlb <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSufAlb >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufAlb <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '")'
   
   if lFacturados
      ::cExpresionHeader   += ' .and. nFacturado < 3'
   end if

   ::setFilterClientIdHeader()

   ::setFilterPaymentId()

   ::setFilterRouteId() 

   ::setFilterTransportId()
   
   ::setFilterUserId()

   ::setFilterAgent()
   
   // filtros para las l�neas-------------------------------------------------

   ::cExpresionLine        := '!Field->lTotLin .and. !Field->lControl'
   ::cExpresionLine        += ' .and. ( Field->dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionLine        += ' .and. ( Field->cSerAlb >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerAlb <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine        += ' .and. ( Field->nNumAlb >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumAlb <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine        += ' .and. ( Field->cSufAlb >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufAlb <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'
   
   ::setFilterProductIdLine()

   ::setFilterStoreLine()

   ::setFilterFamily() 

   ::setFilterGroupFamily()

   // Procesando albaranes-------------------------------------------------

   ::setMeterText( "Procesando albaranes" )

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )
   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( ::cExpresionLine ), , , , , , , , .t. )

   ::setMeterTotal( ::oAlbCliL:OrdKeyCount() )

   // Lineas de albaranes---------------------------------------------------------

   ::oAlbCliL:GoTop()
   while !::lBreak .and. !::oAlbCliL:Eof()

      ::oDbf:Blank()

      ::oDbf:cCodArt    := ::oAlbCliL:cRef
      ::oDbf:cNomArt    := ::oAlbCliL:cDetalle

      ::oDbf:cCodPrv    := ::oAlbCliL:cCodPrv
      ::oDbf:cNomPrv    := RetFld( ::oAlbCliL:cCodPrv, ::oDbfPrv:cAlias )

      ::oDbf:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, ::oAlbCliL:nIva )
      ::oDbf:cCodTip    := RetFld( ::oAlbCliL:cRef, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
      ::oDbf:cCodCate   := RetFld( ::oAlbCliL:cRef, ::oDbfArt:cAlias, "cCodCate", "Codigo" )
      ::oDbf:cCodEst    := RetFld( ::oAlbCliL:cRef, ::oDbfArt:cAlias, "cCodEst", "Codigo" )
      ::oDbf:cCodTemp   := RetFld( ::oAlbCliL:cRef, ::oDbfArt:cAlias, "cCodTemp", "Codigo" )
      ::oDbf:cCodFab    := RetFld( ::oAlbCliL:cRef, ::oDbfArt:cAlias, "cCodFab", "Codigo" )
      ::oDbf:cDesUbi    := RetFld( ::oAlbCliL:cRef, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )
      
      ::oDbf:cCodFam    := ::oAlbCliL:cCodFam
      ::oDbf:cGrpFam    := ::oAlbCliL:cGrpFam
      ::oDbf:cCodAlm    := ::oAlbCliL:cAlmLin
      
      ::oDbf:cCodObr    := ::oAlbCliL:cObrLin

      ::oDbf:nUniArt    := nTotNAlbCli( ::oAlbCliL:cAlias ) * if( ::lUnidadesNegativo, -1, 1 )

      ::oDbf:nDtoArt    := ::oAlbcliL:nDto
      ::oDbf:nLinArt    := ::oAlbcliL:nDtoDiv
      ::oDbf:nPrmArt    := ::oAlbcliL:nDtoPrm

      ::oDbf:nTotDto    := nDtoLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotPrm    := nPrmLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oDbf:nTrnArt    := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntArt    := nPntLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      
      ::oDbf:nIvaArt    := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nImpEsp    := nTotIAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      
      ::oDbf:nCosArt    := nCosLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      if empty( ::oDbf:nCosArt )
         ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, ::oDbfArt:cAlias, ::oArtKit:cAlias )
      end if 

      ::oDbf:cCodPr1    := ::oAlbCliL:cCodPr1
      ::oDbf:cCodPr2    := ::oAlbCliL:cCodPr2
      ::oDbf:cValPr1    := ::oAlbCliL:cValPr1
      ::oDbf:cValPr2    := ::oAlbCliL:cValPr2

      ::oDbf:cLote      := ::oAlbCliL:cLote
      ::oDbf:dFecCad    := ::oAlbCliL:dFecCad

      ::oDbf:cClsDoc    := ALB_CLI
      ::oDbf:cTipDoc    := "Albar�n cliente"
      ::oDbf:cSerDoc    := ::oAlbCliL:cSerAlb
      ::oDbf:cNumDoc    := Str( ::oAlbCliL:nNumAlb )
      ::oDbf:cSufDoc    := ::oAlbCliL:cSufAlb

      ::oDbf:cIdeDoc    :=  ::idDocumento()
      ::oDbf:nNumLin    :=  ::oAlbCliL:nNumLin

      ::oDbf:nBultos    := ::oAlbCliL:nBultos * if( ::lUnidadesNegativo, -1, 1 )
      ::oDbf:cFormato   := ::oAlbCliL:cFormato
      ::oDbf:nCajas     := ::oAlbCliL:nCanEnt * if( ::lUnidadesNegativo, -1, 1 )
      ::oDbf:nPeso      := nPesLAlbCli( ::oAlbCliL:cAlias )

      ::oDbf:lKitArt    := ::oAlbCliL:lKitArt
      ::oDbf:lKitChl    := ::oAlbCliL:lKitChl

      ::oDbf:cCtrCoste  := ::oAlbCliL:cCtrCoste

      ::oDbf:cTipCtr    := ::oAlbCliL:cTipCtr
      ::oDbf:cCodTerCtr := ::oAlbCliL:cTerCtr
      ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ::oAlbCliL:cTipCtr, ::oAlbCliL:cTerCtr, ::nView )

      if !empty( ::oAlbCliL:cRef ) 
         ::oDbf:cPrvHab := ::oAlbCliL:cRef
      else
         ::oDbf:cPrvHab := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )
      end if

      /*
      Datos de cabecera--------------------------------------------------
      */

      if ::oAlbCliT:Seek( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb )

         ::oDbf:cCodGrp    := cGruCli( ::oAlbCliT:cCodCli, ::oDbfCli )

         if ::oAtipicasCliente:Seek( ::oAlbCliT:cCodCli + ::oAlbCliL:cRef ) .and. !empty( ::oAtipicasCliente:cCodEnv )
            ::oDbf:cCodEnv    := ::oAtipicasCliente:cCodEnv
         else
            ::oDbf:cCodEnv    := RetFld( ::oAlbCliL:cRef, ::oDbfArt:cAlias, "cCodFra", "Codigo" )                    
         end if

         ::oDbf:cCodPago   := ::oAlbCliT:cCodPago
         ::oDbf:cCodRut    := ::oAlbCliT:cCodRut
         ::oDbf:cCodAge    := ::oAlbCliT:cCodAge
         ::oDbf:cCodTrn    := ::oAlbCliT:cCodTrn
         ::oDbf:cCodUsr    := ::oAlbCliT:cCodUsr

         ::oDbf:cCodCli    := ::oAlbCliT:cCodCli
         ::oDbf:cNomCli    := ::oAlbCliT:cNomCli
         ::oDbf:cPobCli    := ::oAlbCliT:cPobCli
         ::oDbf:cPrvCli    := ::oAlbCliT:cPrvCli
         ::oDbf:cPosCli    := ::oAlbCliT:cPosCli

         ::oDbf:nPreArt    := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
         ::oDbf:nBrtArt    := nBrtLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nImpArt    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nTotArt    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nPctAge    := ::oAlbCliT:nPctComAge
         ::oDbf:nComAge    := nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

         ::oDbf:nAnoDoc    := Year( ::oAlbCliT:dFecAlb )
         ::oDbf:nMesDoc    := Month( ::oAlbCliT:dFecAlb )
         ::oDbf:dFecDoc    := ::oAlbCliT:dFecAlb
         ::oDbf:cHorDoc    := SubStr( ::oAlbCliT:cTimCre, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ::oAlbCliT:cTimCre, 4, 2 )

         do case
            case ::oAlbCliT:nFacturado <= 1
               ::oDbf:cEstado    := "Pendiente"

            case ::oAlbCliT:nFacturado == 2
               ::oDbf:cEstado    := "Parcialmente"

            case ::oAlbCliT:nFacturado == 3
               ::oDbf:cEstado    := "Finalizado"
         end case

      end if

      ::InsertIfValid()

      ::loadValuesExtraFields()

      ::addAlbaranesClientes()

      ::oAlbCliL:Skip()

      ::setMeterAutoIncremental()

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )
   ::oAlbCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaCliente() CLASS TFastVentasArticulos

   ::InitFacturasClientes()

   // filtros para la cabecera-------------------------------------------------
   
   ::cExpresionHeader      := '( Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )      + '" .and. Field->cSerie <= "'    + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionHeader      += ' .and. ( Field->nNumFac >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )    + '" ) .and. Field->nNumFac <= Val( "'    + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )    + '" .and. Field->cSufFac <= "'    + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'
   
   ::setFilterClientIdHeader()

   ::setFilterPaymentId()

   ::setFilterRouteId() 

   ::setFilterTransportId()
   
   ::setFilterUserId()

   ::setFilterAgent()

   // filtros para las l�neas-------------------------------------------------

   ::cExpresionLine        := '!Field->lTotLin .and. !Field->lControl'
   ::cExpresionLine        += ' .and. ( Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionLine        += ' .and. ( Field->cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )      + '" .and. Field->cSerie <= "'    + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine        += ' .and. ( Field->nNumFac >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )    + '" ) .and. Field->nNumFac <= Val( "'    + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine        += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )    + '" .and. Field->cSufFac <= "'    + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'
   
   ::setFilterProductIdLine()

   ::setFilterStoreLine()

   ::setFilterFamily() 

   ::setFilterGroupFamily()

   // Procesando facturas-------------------------------------------------

   ::setMeterText( "Procesando facturas" )

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )
   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( ::cExpresionLine ), , , , , , , , .t. )

   ::setMeterTotal( ::oFacCliL:OrdKeyCount() )

   /*
   Lineas de facturas----------------------------------------------------------
   */

   ::oFacCliL:GoTop()
   while !::lBreak .and. !::oFacCliL:Eof()

      ::oDbf:Blank()
      ::oDbf:cCodArt    := ::oFacCliL:cRef
      ::oDbf:cNomArt    := ::oFacCliL:cDetalle

      ::oDbf:cCodPrv    := ::oFacCliL:cCodPrv
      ::oDbf:cNomPrv    := RetFld( ::oFacCliL:cCodPrv, ::oDbfPrv:cAlias )

      ::oDbf:cCodFam    := ::oFacCliL:cCodFam
      ::oDbf:cGrpFam    := ::oFacCliL:cGrpFam
      ::oDbf:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, ::oFacCliL:nIva )
      ::oDbf:cCodTip    := RetFld( ::oFacCliL:cRef, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
      ::oDbf:cCodCate   := RetFld( ::oFacCliL:cRef, ::oDbfArt:cAlias, "cCodCate", "Codigo" )
      ::oDbf:cCodEst    := RetFld( ::oFacCliL:cRef, ::oDbfArt:cAlias, "cCodEst", "Codigo" )
      ::oDbf:cCodTemp   := RetFld( ::oFacCliL:cRef, ::oDbfArt:cAlias, "cCodTemp", "Codigo" )
      ::oDbf:cCodFab    := RetFld( ::oFacCliL:cRef, ::oDbfArt:cAlias, "cCodFab", "Codigo" )
      ::oDbf:cDesUbi    := RetFld( ::oFacCliL:cRef, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )
      
      ::oDbf:cCodAlm    := ::oFacCliL:cAlmLin
      ::oDbf:cCodObr    := ::oFacCliL:cCodObr
      
      ::oDbf:nUniArt    := nTotNFacCli( ::oFacCliL:cAlias ) * if( ::lUnidadesNegativo, -1, 1 )

      ::oDbf:nDtoArt    := ::oFaccliL:nDto
      ::oDbf:nLinArt    := ::oFaccliL:nDtoDiv
      ::oDbf:nPrmArt    := ::oFaccliL:nDtoPrm

      ::oDbf:nTotDto    := nDtoLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotPrm    := nPrmLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nPntArt    := nPntLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )

      ::oDbf:nBrtArt    := nBrtLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nIvaArt    := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nImpEsp    := nTotIFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nCosArt    := nCosLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      
      if empty( ::oDbf:nCosArt )
         ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, ::oDbfArt:cAlias, ::oArtKit:cAlias )
      end if 
      
      ::oDbf:cCodPr1    := ::oFacCliL:cCodPr1
      ::oDbf:cCodPr2    := ::oFacCliL:cCodPr2
      ::oDbf:cValPr1    := ::oFacCliL:cValPr1
      ::oDbf:cValPr2    := ::oFacCliL:cValPr2

      ::oDbf:cLote      := ::oFacCliL:cLote
      ::oDbf:dFecCad    := ::oFacCliL:dFecCad

      ::oDbf:cClsDoc    := FAC_CLI
      ::oDbf:cTipDoc    := "Factura cliente"
      ::oDbf:cSerDoc    := ::oFacCliL:cSerie
      ::oDbf:cNumDoc    := Str( ::oFacCliL:nNumFac )
      ::oDbf:cSufDoc    := ::oFacCliL:cSufFac

      ::oDbf:cIdeDoc    :=  ::idDocumento()
      ::oDbf:nNumLin    :=  ::oFacCliL:nNumLin

      ::oDbf:nBultos    := ::oFacCliL:nBultos * if( ::lUnidadesNegativo, -1, 1 )
      ::oDbf:cFormato   := ::oFacCliL:cFormato
      ::oDBf:nCajas     := ::oFacCliL:nCanEnt * if( ::lUnidadesNegativo, -1, 1 )
      ::oDbf:nPeso      := nPesLFacCli( ::oFacCliL:cAlias )

      ::oDbf:lKitArt    := ::oFacCliL:lKitArt
      ::oDbf:lKitChl    := ::oFacCliL:lKitChl

      ::oDbf:cCtrCoste  := ::oFacCliL:cCtrCoste
      ::oDbf:cTipCtr    := ::oFacCliL:cTipCtr
      ::oDbf:cCodTerCtr := ::oFacCliL:cTerCtr
      ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ::oFacCliL:cTipCtr, ::oFacCliL:cTerCtr, ::nView )
   
      if !empty( ::oFacCliL:cCodPrv ) 
         ::oDbf:cPrvHab := ::oFacCliL:cCodPrv
      else
         ::oDbf:cPrvHab := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )
      end if 

      /*
      Vamos a la cabecera por los datos que fdltan-----------------
      */

      if ::oFacCliT:Seek( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac )

         if ::oAtipicasCliente:Seek( ::oFacCliT:cCodCli + ::oFacCliL:cRef ) .and. !empty( ::oAtipicasCliente:cCodEnv )
            ::oDbf:cCodEnv    := ::oAtipicasCliente:cCodEnv
         else
            ::oDbf:cCodEnv    := RetFld( ::oFacCliL:cRef, ::oDbfArt:cAlias, "cCodFra", "Codigo" )                    
         end if
         
         ::oDbf:cCodPago   := ::oFacCliT:cCodPago
         ::oDbf:cCodRut    := ::oFacCliT:cCodRut
         ::oDbf:cCodAge    := ::oFacCliT:cCodAge
         ::oDbf:cCodTrn    := ::oFacCliT:cCodTrn
         ::oDbf:cCodUsr    := ::oFacCliT:cCodUsr

         ::oDbf:cCodCli    := ::oFacCliT:cCodCli
         ::oDbf:cNomCli    := ::oFacCliT:cNomCli
         ::oDbf:cPobCli    := ::oFacCliT:cPobCli
         ::oDbf:cPrvCli    := ::oFacCliT:cPrvCli
         ::oDbf:cPosCli    := ::oFacCliT:cPosCli
         ::oDbf:cCodGrp    := cGruCli( ::oFacCliT:cCodCli, ::oDbfCli )

         ::oDbf:nPreArt    := nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
         ::oDbf:nTrnArt    := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
         ::oDbf:nImpArt    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nTotArt    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nPctAge    := ::oFacCliT:nPctComAge
         ::oDbf:nComAge    := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

         ::oDbf:nAnoDoc    := Year( ::oFacCliT:dFecFac )
         ::oDbf:nMesDoc    := Month( ::oFacCliT:dFecFac )
         ::oDbf:dFecDoc    := ::oFacCliT:dFecFac
         ::oDbf:cHorDoc    := SubStr( ::oFacCliT:cTimCre, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ::oFacCliT:cTimCre, 4, 2 )

         ::oDbf:cEstado    := cChkPagFacCli( ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc, ::oFacCliT:cAlias, ::oFacCliP:cAlias )

      end if

      ::InsertIfValid()
      ::loadValuesExtraFields()

      ::addFacturasClientes()

      ::oFacCliL:Skip()

      ::setMeterAutoIncremental()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaRectificativa() CLASS TFastVentasArticulos

   // filtros para la cabecera-------------------------------------------------

   ::cExpresionHeader          := '( Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader          += ' .and. ( Field->cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerie <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionHeader          += ' .and. ( Field->nNumFac >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumFac <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionHeader          += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufFac <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'
   
   ::setFilterClientIdHeader()

   ::setFilterPaymentId()

   ::setFilterRouteId() 

   ::setFilterTransportId()
   
   ::setFilterUserId()

   ::setFilterAgent()

   // filtros para la linea----------------------------------------------------
   
   ::cExpresionLine            := '!Field->lTotLin .and. !Field->lControl'
   ::cExpresionLine            += ' .and. ( Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionLine            += ' .and. ( Field->cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerie <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine            += ' .and. ( Field->nNumFac >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumFac <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine            += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufFac <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'
   
   ::setFilterProductIdLine()
   
   ::setFilterStoreLine()

   ::setFilterFamily() 

   ::setFilterGroupFamily()

   // Procesando Facturas Rectifictivas----------------------------------------

   ::setMeterText( "Procesando facturas rectificativas" )

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )
   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( ::cExpresionLine ), , , , , , , , .t. )

   ::setMeterTotal( ::oFacRecL:OrdKeyCount() )

   // Lineas de facturas rectificativas----------------------------------------

   ::oFacRecL:GoTop()

   while !::lBreak .and. !::oFacRecL:Eof()

      ::oDbf:Blank()

      ::oDbf:cCodArt    := ::oFacRecL:cRef
      ::oDbf:cNomArt    := ::oFacRecL:cDetalle

      ::oDbf:cCodPrv    := ::oFacRecL:cCodPrv
      ::oDbf:cNomPrv    := RetFld( ::oFacRecL:cCodPrv, ::oDbfPrv:cAlias )

      ::oDbf:cCodFam    := ::oFacRecL:cCodFam
      ::oDbf:cGrpFam    := ::oFacRecL:cGrpFam
      ::oDbf:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, ::oFacRecL:nIva )
      ::oDbf:cCodTip    := RetFld( ::oFacRecL:cRef, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
      ::oDbf:cCodCate   := RetFld( ::oFacRecL:cRef, ::oDbfArt:cAlias, "cCodCate", "Codigo" )
      ::oDbf:cCodEst    := RetFld( ::oFacRecL:cRef, ::oDbfArt:cAlias, "cCodEst", "Codigo" )
      ::oDbf:cCodTemp   := RetFld( ::oFacRecL:cRef, ::oDbfArt:cAlias, "cCodTemp", "Codigo" )
      ::oDbf:cCodFab    := RetFld( ::oFacRecL:cRef, ::oDbfArt:cAlias, "cCodFab", "Codigo" )
      ::oDbf:cDesUbi    := RetFld( ::oFacRecL:cRef, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )

      ::oDbf:cCodAlm    := ::oFacRecL:cAlmLin
      ::oDbf:cCodObr    := ::oFacRecL:cObrLin

      ::oDbf:nUniArt    := nTotNFacRec( ::oFacRecL:cAlias ) * if( ::lUnidadesNegativo, -1, 1 )

      ::oDbf:nDtoArt    := ::oFacRecL:nDto
      ::oDbf:nLinArt    := ::oFacRecL:nDtoDiv
      ::oDbf:nPrmArt    := ::oFacRecL:nDtoPrm

      ::oDbf:nTotDto    := nDtoLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotPrm    := nPrmLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oDbf:nTrnArt    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntArt    := nPntLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )

      ::oDbf:nBrtArt    := nBrtLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nIvaArt    := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nImpEsp    := nTotIFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oDbf:nCosArt    := nCosLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      if empty( ::oDbf:nCosArt )
         ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, ::oDbfArt:cAlias, ::oArtKit:cAlias )
      end if 

      ::oDbf:cCodPr1    := ::oFacRecL:cCodPr1
      ::oDbf:cCodPr2    := ::oFacRecL:cCodPr2
      ::oDbf:cValPr1    := ::oFacRecL:cValPr1
      ::oDbf:cValPr2    := ::oFacRecL:cValPr2

      ::oDbf:cLote      := ::oFacRecL:cLote
      ::oDbf:dFecCad    := ::oFacRecL:dFecCad

      ::oDbf:cClsDoc    := FAC_REC
      ::oDbf:cTipDoc    := "Rectificativa cliente"
      ::oDbf:cSerDoc    := ::oFacRecL:cSerie
      ::oDbf:cNumDoc    := Str( ::oFacRecL:nNumFac )
      ::oDbf:cSufDoc    := ::oFacRecL:cSufFac

      ::oDbf:cIdeDoc    :=  ::idDocumento()
      ::oDbf:nNumLin    :=  ::oFacRecL:nNumLin

      ::oDbf:nBultos    := ::oFacRecL:nBultos * if( ::lUnidadesNegativo, -1, 1)
      ::oDbf:cFormato   := ::oFacRecL:cFormato
      ::oDbf:nCajas     := ::oFacRecL:nCanEnt * if( ::lUnidadesNegativo, -1, 1 )
      ::oDbf:nPeso      := nPesLFacRec( ::oFacRecL:cAlias )

      ::oDbf:lKitArt    := ::oFacRecL:lKitArt
      ::oDbf:lKitChl    := ::oFacRecL:lKitChl

      ::oDbf:cCtrCoste  := ::oFacRecL:cCtrCoste
      ::oDbf:cTipCtr    := ::oFacRecL:cTipCtr
      ::oDbf:cCodTerCtr := ::oFacRecL:cTerCtr
      ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ::oFacRecL:cTipCtr, ::oFacRecL:cTerCtr, ::nView )

      if !empty( ::oFacRecL:cCodPrv ) 
         ::oDbf:cPrvHab := ::oFacRecL:cCodPrv
      else
         ::oDbf:cPrvHab := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )
      end if

      /*
      Tomamos los datos de cabecera--------------------------------
      */

      if ::oFacRecT:Seek( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac )

         if ::oAtipicasCliente:Seek( ::oFacRecT:cCodCli + ::oFacRecL:cRef ) .and. !empty( ::oAtipicasCliente:cCodEnv )
            ::oDbf:cCodEnv    := ::oAtipicasCliente:cCodEnv
         else
            ::oDbf:cCodEnv    := RetFld( ::oFacRecL:cRef, ::oDbfArt:cAlias, "cCodFra", "Codigo" )                    
         end if

         ::oDbf:cCodPago   := ::oFacRecT:cCodPago
         ::oDbf:cCodRut    := ::oFacRecT:cCodRut
         ::oDbf:cCodAge    := ::oFacRecT:cCodAge
         ::oDbf:cCodTrn    := ::oFacRecT:cCodTrn
         ::oDbf:cCodUsr    := ::oFacRecT:cCodUsr

         ::oDbf:cCodCli    := ::oFacRecT:cCodCli
         ::oDbf:cNomCli    := ::oFacRecT:cNomCli
         ::oDbf:cPobCli    := ::oFacRecT:cPobCli
         ::oDbf:cPrvCli    := ::oFacRecT:cPrvCli
         ::oDbf:cPosCli    := ::oFacRecT:cPosCli

         ::oDbf:cCodGrp    := cGruCli( ::oFacRecT:cCodCli, ::oDbfCli )

         ::oDbf:nPreArt    := nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      
         ::oDbf:nImpArt    := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nTotArt    := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nPctAge    := ::oFacRecT:nPctComAge
         ::oDbf:nComAge    := nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )

         ::oDbf:nAnoDoc    := Year( ::oFacRecT:dFecFac )
         ::oDbf:nMesDoc    := Month( ::oFacRecT:dFecFac )
         ::oDbf:dFecDoc    := ::oFacRecT:dFecFac
         ::oDbf:cHorDoc    := SubStr( ::oFacRecT:cTimCre, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ::oFacRecT:cTimCre, 4, 2 )

         ::oDbf:cEstado    := cChkPagFacRec( ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc, ::oFacRecT:cAlias, ::oFacCliP:cAlias )

      end if

      ::InsertIfValid()
      ::loadValuesExtraFields()

      ::oFacRecL:Skip()

      ::setMeterAutoIncremental()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddTicket() CLASS TFastVentasArticulos

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   // Filtros para la cabecera ------------------------------------------------

   ::cExpresionHeader       := '( Field->dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader       += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'
   ::cExpresionHeader       += ' .and. Field->cCliTik >= "' + Rtrim( ::oGrupoCliente:Cargo:getDesde() ) + '" .and. Field->cCliTik <= "' + Rtrim( ::oGrupoCliente:Cargo:getHasta() ) + '"'
   ::cExpresionHeader       += ' .and. Field->cSerTik >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerTik <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '"'
   ::cExpresionHeader       += ' .and. Field->cNumTik >= "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )   + '" .and. Field->cNumTik <= "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '"'
   ::cExpresionHeader       += ' .and. Field->cSufTik >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufTik <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '"'

   ::setFilterAgent()

   // Filtros para las l�neas ------------------------------------------------

   ::cExpresionLine        := '( !Field->lControl .and. !Field->lDelTil )'
   ::cExpresionLine        += ' .and. ( ( Field->cCbaTil >= "' + ::oGrupoArticulo:Cargo:getDesde() + '" .and. Field->cCbaTil <= "' + ::oGrupoArticulo:Cargo:getHasta() + '") .or. '
   ::cExpresionLine        += '( Field->cComTil >= "' + ::oGrupoArticulo:Cargo:getDesde() + '" .and. Field->cComTil <= "' + ::oGrupoArticulo:Cargo:getHasta() + '" ) )'
   ::cExpresionLine        += ' .and. Field->cSerTil >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerTil <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '"'
   ::cExpresionLine        += ' .and. Field->cNumTil >= "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )   + '" .and. Field->cNumTil <= "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '"'
   ::cExpresionLine        += ' .and. Field->cSufTil >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufTil <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '"'

   ::setFilterStoreLine()

   ::setFilterFamily() 

   ::setFilterGroupFamily()

   // Procesando Tickets ------------------------------------------------

   ::setMeterText( "Procesando tikets" )
   
   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )
   ::oTikCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), ( ::cExpresionLine ), , , , , , , , .t. )

   ::setMeterTotal( ::oTikCliT:OrdKeyCount() )

   // Lineas de tickets -------------------------------------------------------

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer ) .and. ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .and. !::oTikCliL:Eof()

            if .t. // !( ::oTikCliL:lControl ) .and. !( ::oTikCliL:lDelTil )

               ::oDbf:Blank()
               
               ::oDbf:cCodArt    := ::oTikCliL:cCbaTil
               ::oDbf:cNomArt    := ::oTikCliL:cNomTil
               ::oDbf:cCodCli    := ::oTikCliT:cCliTik
               ::oDbf:cNomCli    := ::oTikCliT:cNomTik
               ::oDbf:cPobCli    := ::oTikCliT:cPobCli
               ::oDbf:cPrvCli    := ::oTikCliT:cPrvCli
               ::oDbf:cPosCli    := ::oTikCliT:cPosCli
               ::oDbf:cCodGrp    := cGruCli( ::oTikCliT:cCliTik, ::oDbfCli )

               ::oDbf:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, ::oTikCliT:nIvaTil )

               ::oDbf:cCodFam    := ::oTikCliL:cCodFam
               ::oDbf:cGrpFam    := ::oTikCliL:cGrpFam
               ::oDbf:cCodTip    := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
               ::oDbf:cCodCate   := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cCodCate", "Codigo" )
               ::oDbf:cCodEst    := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cCodEst", "Codigo" )
               ::oDbf:cCodTemp   := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cCodTemp", "Codigo" )
               ::oDbf:cCodFab    := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cCodFab", "Codigo" )
               ::oDbf:cDesUbi    := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )

               if ::oAtipicasCliente:Seek( ::oTikCliT:cCliTik + ::oTikCliL:cCbaTil ) .and. !empty( ::oAtipicasCliente:cCodEnv )
                  ::oDbf:cCodEnv    := ::oAtipicasCliente:cCodEnv
               else
                  ::oDbf:cCodEnv    := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cCodFra", "Codigo" )                    
               end if

               ::oDbf:cCodAlm    := ::oTikCliL:cAlmLin
               ::oDbf:cCodPago   := ::oTikCliT:cFpgTik
               ::oDbf:cCodRut    := ::oTikCliT:cCodRut
               ::oDbf:cCodAge    := ::oTikCliT:cCodAge
               ::oDbf:cCodTrn    := ""
               ::oDbf:cCodUsr    := ::oTikCliT:cCcjTik
               ::oDbf:cCodObr    := ::oTikCliT:cCodObr

               if ::oTikCliT:cTipTik == "4"
                  ::oDbf:nUniArt := - ::oTikCliL:nUntTil * if( ::lUnidadesNegativo, -1, 1 )
               else
                  ::oDbf:nUniArt := ::oTikCliL:nUntTil   * if( ::lUnidadesNegativo, -1, 1 )
               end if

               ::oDbf:nPreArt    := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 1 )

               ::oDbf:nBrtArt    := nNetLTpv( ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nImpArt    := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )

               ::oDbf:nDtoArt    := ::oTikCliL:nDtoLin
               ::oDbf:nLinArt    := ::oTikCliL:nDtoDiv
             //::oDbf:nPrmArt    := ::oTikCliL:nDtoPrm

               ::oDbf:nTotDto    := nDtoLTpv( ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotPrm    := 0

               ::oDbf:nIvaArt    := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
               ::oDbf:nImpEsp    := nIvmLTpv( ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotArt    := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
               ::oDbf:nTotArt    += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
               
               ::oDbf:nCosArt    := nCosLTpv( ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
               if empty( ::oDbf:nCosArt )
                  ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, ::oDbfArt:cAlias, ::oArtKit:cAlias )
               end if 

               ::oDbf:cCodPr1    := ::oTikCliL:cCodPr1
               ::oDbf:cCodPr2    := ::oTikCliL:cCodPr2
               ::oDbf:cValPr1    := ::oTikCliL:cValPr1
               ::oDbf:cValPr2    := ::oTikCliL:cValPr2

               ::oDbf:cLote      := ::oTikCliL:cLote

               ::oDbf:cClsDoc    := TIK_CLI
               ::oDbf:cTipDoc    := "Ticket"
               ::oDbf:cSerDoc    := ::oTikCliT:cSerTik
               ::oDbf:cNumDoc    := ::oTikCliT:cNumTik
               ::oDbf:cSufDoc    := ::oTikCliT:cSufTik

               ::oDbf:cIdeDoc    :=  ::idDocumento()
               ::oDbf:nNumLin    :=  ::oTikCliL:nNumLin

               ::oDbf:nAnoDoc    := Year( ::oTikCliT:dFecTik )
               ::oDbf:nMesDoc    := Month( ::oTikCliT:dFecTik )
               ::oDbf:dFecDoc    := ::oTikCliT:dFecTik
               ::oDbf:cHorDoc    := SubStr( ::oTikCliT:cHorTik, 1, 2 )
               ::oDbf:cMinDoc    := SubStr( ::oTikCliT:cHorTik, 4, 2 )

               ::oDbf:lKitArt    := ::oTikCliL:lKitArt
               ::oDbf:lKitChl    := ::oTikCliL:lKitChl

               ::oDbf:cPrvHab    := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )

               // A�adimos un nuevo registro-----------------------------------

               ::InsertIfValid()
               ::loadValuesExtraFields()

            end if

            if !empty( ::oTikCliL:cComTil ) // .and. !( ::oTikCliL:lControl ) .and. !( ::oTikCliL:lDelTil )

               ::oDbf:Blank()
               
               ::oDbf:cCodArt    := ::oTikCliL:cComTil
               ::oDbf:cNomArt    := ::oTikCliL:cNcmTil

               ::oDbf:cCodCli    := ::oTikCliT:cCliTik
               ::oDbf:cNomCli    := ::oTikCliT:cNomTik
               ::oDbf:cPobCli    := ::oTikCliT:cPobCli
               ::oDbf:cPrvCli    := ::oTikCliT:cPrvCli
               ::oDbf:cPosCli    := ::oTikCliT:cPosCli
               ::oDbf:cCodGrp    := cGruCli( ::oTikCliT:cCliTik, ::oDbfCli )
               ::oDbf:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, ::oTikCliT:nIvaTil )

               ::oDbf:cCodFam    := ::oTikCliL:cCodFam
               ::oDbf:cGrpFam    := ::oTikCliL:cGrpFam
               ::oDbf:cCodTip    := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
               ::oDbf:cCodCate   := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cCodCate", "Codigo" )
               ::oDbf:cCodEst    := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cCodEst", "Codigo" )
               ::oDbf:cCodTemp   := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cCodTemp", "Codigo" )
               ::oDbf:cCodFab    := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cCodFab", "Codigo" )
               ::oDbf:cDesUbi    := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )
               
               if ::oAtipicasCliente:Seek( ::oTikCliT:cCliTik + ::oTikCliL:cCbaTil ) .and. !empty( ::oAtipicasCliente:cCodEnv )
                  ::oDbf:cCodEnv    := ::oAtipicasCliente:cCodEnv
               else
                  ::oDbf:cCodEnv    := RetFld( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias, "cCodFra", "Codigo" )                    
               end if

               ::oDbf:cCodAlm    := ::oTikCliL:cAlmLin
               ::oDbf:cCodPago   := ::oTikCliT:cFpgTik
               ::oDbf:cCodRut    := ::oTikCliT:cCodRut
               ::oDbf:cCodAge    := ::oTikCliT:cCodAge
               ::oDbf:cCodTrn    := ""
               ::oDbf:cCodUsr    := ::oTikCliT:cCcjTik
               ::oDbf:cCodObr    := ::oTikCliT:cCodObr

               if ::oTikCliT:cTipTik == "4"
                  ::oDbf:nUniArt := - ::oTikCliL:nUntTil * if( ::lUnidadesNegativo, -1, 1 )
               else
                  ::oDbf:nUniArt := ::oTikCliL:nUntTil   * if( ::lUnidadesNegativo, -1, 1 )
               end if

               ::oDbf:nPreArt    := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 2 )

               ::oDbf:nBrtArt    := nBrtLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 2 )
               ::oDbf:nImpArt    := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
               ::oDbf:nIvaArt    := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
               ::oDbf:nImpEsp    := nIvmLTpv( ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotArt    := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
               ::oDbf:nTotArt    += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )

               ::oDbf:nCosArt    := nCosLTpv( ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
               if empty( ::oDbf:nCosArt )
                  ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ::oTikCliL:cComTil, ::oDbfArt:cAlias, ::oArtKit:cAlias )
               end if 

               ::oDbf:cCodPr1    := ::oTikCliL:cCodPr1
               ::oDbf:cCodPr2    := ::oTikCliL:cCodPr2
               ::oDbf:cValPr1    := ::oTikCliL:cValPr1
               ::oDbf:cValPr2    := ::oTikCliL:cValPr2

               ::oDbf:cClsDoc    := TIK_CLI
               ::oDbf:cTipDoc    := "Ticket"
               ::oDbf:cSerDoc    := ::oTikCliT:cSerTik
               ::oDbf:cNumDoc    := ::oTikCliT:cNumTik
               ::oDbf:cSufDoc    := ::oTikCliT:cSufTik

               ::oDbf:cIdeDoc    :=  ::idDocumento()
               ::oDbf:nNumLin    :=  ::oTikCliL:nNumLin

               ::oDbf:nAnoDoc    := Year( ::oTikCliT:dFecTik )
               ::oDbf:nMesDoc    := Month( ::oTikCliT:dFecTik )
               ::oDbf:dFecDoc    := ::oTikCliT:dFecTik
               ::oDbf:cHorDoc    := SubStr( ::oTikCliT:cHorTik, 1, 2 )
               ::oDbf:cMinDoc    := SubStr( ::oTikCliT:cHorTik, 4, 2 )

               ::oDbf:cPrvHab    := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )

               ::InsertIfValid()
               ::loadValuesExtraFields()

            end if

            ::oTikCliL:Skip()

         end while

      end if

      ::oTikCliT:Skip()

      ::setMeterAutoIncremental()

   end while

   ::setMeterTotal( ::oTikCliT:OrdKeyCount() )

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )
   ::oTikCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD listadoArticulo() CLASS TFastVentasArticulos

   local aStockArticulo

   ::oDbfArt:OrdClearScope()   

   ::setMeterTotal( ::oDbfArt:OrdKeyCount() )
   ::setMeterAutoIncremental()

   ::setMeterText( "Procesando art�culos" )

   /*
   Recorremos art�culos--------------------------------------------------------
   */

   ::oDbfArt:goTop() 
   while !::oDbfArt:eof() .and. !::lBreak

      ::oDbf:Blank()

      ::oDbf:cCodArt  := ::oDbfArt:Codigo
      ::oDbf:cCodCli  := ::oDbfArt:cPrvHab
      ::oDbf:cPrvHab  := ::oDbfArt:cPrvHab
      ::oDbf:cNomArt  := ::oDbfArt:Nombre
      ::oDbf:cCodFam  := ::oDbfArt:Familia
      ::oDbf:TipoIva  := ::oDbfArt:TipoIva
      ::oDbf:cCodTip  := ::oDbfArt:cCodTip
      ::oDbf:cCodCate := ::oDbfArt:cCodCate
      ::oDbf:cCodTemp := ::oDbfArt:cCodTemp
      ::oDbf:cCodFab  := ::oDbfArt:cCodFab
      ::oDbf:cCodEst  := ::oDbfArt:cCodEst
      ::oDbf:cDesUbi  := ::oDbfArt:cDesUbi
      ::oDbf:cCodEnv  := ::oDbfArt:cCodFra
      ::oDbf:nCosArt  := nCosto( nil, ::oDbfArt:cAlias, ::oArtKit:cAlias )

      ::InsertIfValid()
      ::loadValuesExtraFields()

      ::oDbfArt:Skip()

      ::setMeterAutoIncremental()

   end while

   ::setMeterAutoIncremental()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddArticulo( lAppendBlank ) CLASS TFastVentasArticulos

   local aStockArticulo

   DEFAULT lAppendBlank    := .f.

   if !Empty( ::oGrupoAlmacen )
      if ::oGrupoAlmacen:cargo:getDesde() == ::oGrupoAlmacen:cargo:getHasta()
         ::cAlmacenDefecto := ::oGrupoAlmacen:cargo:getDesde()
      end if 
   end if

   ::oDbf:Zap()
   ::oDbfArt:OrdClearScope()   

   ::setMeterTotal(  ::oDbfArt:OrdKeyCount() )
   ::setMeterAutoIncremental()

   ::setMeterText( "Procesando art�culos" )

   // Recorremos art�culos-----------------------------------------------------

   ::oDbfArt:goTop() 
   while !::oDbfArt:eof() .and. !::lBreak

      if ( Empty( ::oGrupoArticulo ) .or. ( ::oDbfArt:Codigo  >= ::oGrupoArticulo:Cargo:getDesde() .and. ::oDbfArt:Codigo  <= ::oGrupoArticulo:Cargo:getHasta() ) ) .and.;
         ( Empty( ::oGrupoFamilia ) .or. ( ::oDbfArt:Familia >= ::oGrupoFamilia:Cargo:getDesde()  .and. ::oDbfArt:Familia <= ::oGrupoFamilia:Cargo:getHasta() ) )           

         aStockArticulo    := ::oStock:aStockArticulo( ::oDbfArt:Codigo, ::cAlmacenDefecto, , , , , ::dFinInf )

         if !empty( aStockArticulo )
            ::appendStockArticulo( aStockArticulo )
         end if 

         /*
         Estaba comentado y lo he vuelto a activar para alvaro pita------------
         */

         if lAppendBlank
            ::appendBlankAlmacenes( ::oDbfArt:Codigo )
         end if

      end if 

      ::oDbfArt:Skip()

      ::setMeterAutoIncremental()

   end while

   ::setMeterAutoIncremental()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD appendStockArticulo( aStockArticulo )
   
   local sStock

   for each sStock in aStockArticulo

      if !empty( sStock:cCodigo )

         ::oDbf:Blank()

         ::oDbf:cCodArt    := sStock:cCodigo
         ::oDbf:cSufDoc    := sStock:cDelegacion
         ::oDbf:dFecDoc    := sStock:dFechaDocumento
         ::oDbf:cCodAlm    := sStock:cCodigoAlmacen
         ::oDbf:cCodPr1    := sStock:cCodigoPropiedad1     
         ::oDbf:cCodPr2    := sStock:cCodigoPropiedad2     
         ::oDbf:cValPr1    := sStock:cValorPropiedad1      
         ::oDbf:cValPr2    := sStock:cValorPropiedad2      
         ::oDbf:cLote      := sStock:cLote
         ::oDbf:dFecCad    := sStock:dFechaCaducidad       
         ::oDbf:cNumSer    := sStock:cNumeroSerie  
         ::oDbf:nUniArt    := sStock:nUnidades
         ::oDbf:nBultos    := sStock:nBultos
         ::oDbf:nCajas     := sStock:nCajas
         ::oDbf:nPdtRec    := sStock:nPendientesRecibir    
         ::oDbf:nPdtEnt    := sStock:nPendientesEntregar 
         ::oDbf:nEntreg    := sStock:nUnidadesEntregadas
         ::oDbf:nRecibi    := sStock:nUnidadesRecibidas
         ::oDbf:cNumDoc    := sStock:cNumeroDocumento      
         ::oDbf:cTipDoc    := sStock:cTipoDocumento

         ::fillFromArticulo()

         ::insertIfValid()
         ::loadValuesExtraFields()

      end if 

   next 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD appendBlankAlmacenes( cCodigoArticulo )

   if ::oDbfAlm:Seek( ::oGrupoAlmacen:Cargo:getDesde() )
      
      while ::oDbfAlm:cCodAlm <= ::oGrupoAlmacen:Cargo:getHasta() .and. !::oDbfAlm:eof()

         if !::existeArticuloInforme( cCodigoArticulo, ::oDbfAlm:cCodAlm )
            ::appendBlankArticulo( cCodigoArticulo, ::oDbfAlm:cCodAlm )
         end if 

         ::oDbfAlm:skip()

      end while
      
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD existeArticuloInforme( cCodigoArticulo, cCodigoAlmacen )

RETURN ( ::oDbf:SeekInOrdBack( cCodigoArticulo + cCodigoAlmacen, "cCodAlm" ) )

//---------------------------------------------------------------------------//

METHOD appendBlankArticulo( cCodigoArticulo, cCodigoAlmacen ) CLASS TFastVentasArticulos

   ::oDbf:Blank()

   ::oDbf:cCodArt  := cCodigoArticulo
   ::oDbf:cCodAlm  := cCodigoAlmacen

   ::fillFromArticulo()

   ::insertIfValid()
   ::loadValuesExtraFields()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD fillFromArticulo() CLASS TFastVentasArticulos

   ::oDbf:cCodCli    := ::oDbfArt:cPrvHab
   ::oDbf:cNomArt    := ::oDbfArt:Nombre
   ::oDbf:cCodFam    := ::oDbfArt:Familia
   ::oDbf:TipoIva    := ::oDbfArt:TipoIva
   ::oDbf:cCodTip    := ::oDbfArt:cCodTip
   ::oDbf:cCodCate   := ::oDbfArt:cCodCate
   ::oDbf:cCodEst    := ::oDbfArt:cCodEst
   ::oDbf:cCodTemp   := ::oDbfArt:cCodTemp
   ::oDbf:cCodFab    := ::oDbfArt:cCodFab
   ::oDbf:nCosArt    := nCosto( nil, ::oDbfArt:cAlias, ::oArtKit:cAlias )
   ::oDbf:cPrvHab    := ::oDbfArt:cPrvHab
   ::oDbf:cDesUbi    := ::oDbfArt:cDesUbi

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddProducido() CLASS TFastVentasArticulos

   ::setMeterText( "Procesando partes de producci�n" )
   
   ::setMeterTotal( ::oProLin:OrdKeyCount() )

   ::cExpresionLine           := '( dFecOrd >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecOrd <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'

   if !::lAllArt
      ::cExpresionLine        += ' .and. ( cCodArt >= "' + ::oGrupoArticulo:Cargo:getDesde() + '" .and. cCodArt <= "' + ::oGrupoArticulo:Cargo:getHasta() + '")'
   end if

   ::oProLin:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oProLin:cFile ), ::oProLin:OrdKey(), cAllTrimer( ::cExpresionLine ), , , , , , , , .t. )

   ::oProLin:GoTop()

   while !::lBreak .and. !::oProLin:Eof()

      if lChkSer( ::oProLin:cSerOrd, ::aSer )

         ::oDbf:Blank()

         ::oDbf:cCodArt    := ::oProLin:cCodArt
         ::oDbf:cNomArt    := ::oProLin:cNomArt

         ::oDbf:cCodFam    := ::oProLin:cCodFam
         ::oDbf:cGrpFam    := ::oProLin:cGrpFam
         ::oDbf:cCodTip    := ::oProLin:cCodTip
         ::oDbf:cCodCate   := ::oProLin:cCodCat
         ::oDbf:cCodTemp   := ::oProLin:cCodTmp
         ::oDbf:cCodFab    := ::oProLin:cCodFab
         ::oDbf:cCodAlm    := ::oProLin:cAlmOrd
         ::oDbf:cDesUbi    := RetFld( ::oProLin:cCodArt, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )
         ::oDbf:cCodEnv    := RetFld( ::oProLin:cCodArt, ::oDbfArt:cAlias, "cCodFra", "Codigo" )                    

         ::oDbf:nBultos    := ::oProLin:nBultos
         ::oDbf:nCajas     := ::oProLin:nCajOrd
         ::oDbf:nUniArt    := ::oProLin:nUndOrd
         ::oDbf:nPreArt    := ::oProLin:nImpOrd

         ::oDbf:nBrtArt    := 0 //::oProLin:TotalImporte()
         ::oDbf:nTotArt    := 0 //::oProLin:TotalImporte()

         ::oDbf:cCodPr1    := ::oProLin:cCodPr1
         ::oDbf:cCodPr2    := ::oProLin:cCodPr2
         ::oDbf:cValPr1    := ::oProLin:cValPr1
         ::oDbf:cValPr2    := ::oProLin:cValPr2

         ::oDbf:cClsDoc    := PRO_LIN
         ::oDbf:cTipDoc    := "Producido"

         ::oDbf:cSerDoc    := ::oProLin:cSerOrd
         ::oDbf:cNumDoc    := Str( ::oProLin:nNumOrd )
         ::oDbf:cSufDoc    := ::oProLin:cSufOrd

         ::oDbf:cIdeDoc    :=  ::oProLin:cSerOrd + Str( ::oProLin:nNumOrd ) + ::oProLin:cSufOrd
         ::oDbf:nNumLin    :=  ::oProLin:nNumLin

         ::oDbf:nAnoDoc    := Year( ::oProLin:dFecOrd )
         ::oDbf:nMesDoc    := Month( ::oProLin:dFecOrd )
         ::oDbf:dFecDoc    := ::oProLin:dFecOrd

         ::InsertIfValid( .t. )
         ::loadValuesExtraFields()

      end if

      ::oProLin:Skip()

      ::setMeterAutoIncremental()

   end while

   ::oProLin:IdxDelete( cCurUsr(), GetFileNoExt( ::oProLin:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddConsumido() CLASS TFastVentasArticulos

   local cExpLine    := ""

   ::setMeterText( "Procesando partes de producci�n" )
   
   ::setMeterTotal( ::oProMat:OrdKeyCount() )

   cExpLine          := '( dFecOrd >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecOrd <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'

   if !::lAllArt
      cExpLine       += ' .and. ( cCodArt >= "' + ::oGrupoArticulo:Cargo:getDesde() + '" .and. cCodArt <= "' + ::oGrupoArticulo:Cargo:getHasta() + '")'
   end if

   ::oProMat:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oProMat:cFile ), ::oProMat:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oProMat:GoTop()

   while !::lBreak .and. !::oProMat:Eof()

      if lChkSer( ::oProMat:cSerOrd, ::aSer )

         ::oDbf:Blank()

         ::oDbf:cCodArt    := ::oProMat:cCodArt
         ::oDbf:cNomArt    := ::oProMat:cNomArt

         ::oDbf:cCodFam    := ::oProMat:cCodFam
         ::oDbf:cGrpFam    := ::oProMat:cGrpFam
         ::oDbf:cCodTip    := ::oProMat:cCodTip
         ::oDbf:cCodCate   := ::oProMat:cCodCat
         ::oDbf:cCodTemp   := ::oProMat:cCodTmp
         ::oDbf:cCodFab    := ::oProMat:cCodFab
         ::oDbf:cCodAlm    := ::oProMat:cAlmOrd
         ::oDbf:cDesUbi    := RetFld( ::oProMat:cCodArt, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )
         ::oDbf:cCodEnv    := RetFld( ::oProMat:cCodArt, ::oDbfArt:cAlias, "cCodFra", "Codigo" )                    

         ::oDbf:nBultos    := ::oProMat:nBultos
         ::oDbf:nCajas     := ::oProMat:nCajOrd
         ::oDbf:nUniArt    := ::oProMat:nUndOrd
         ::oDbf:nPreArt    := ::oProMat:nImpOrd

         ::oDbf:nBrtArt    := 0 //::oProMat:TotalImporte()
         ::oDbf:nTotArt    := 0 //::oProMat:TotalImporte()

         ::oDbf:cCodPr1    := ::oProMat:cCodPr1
         ::oDbf:cCodPr2    := ::oProMat:cCodPr2
         ::oDbf:cValPr1    := ::oProMat:cValPr1
         ::oDbf:cValPr2    := ::oProMat:cValPr2

         ::oDbf:cClsDoc    := PRO_MAT
         ::oDbf:cTipDoc    := "Consumido"

         ::oDbf:cSerDoc    := ::oProMat:cSerOrd
         ::oDbf:cNumDoc    := Str( ::oProMat:nNumOrd )
         ::oDbf:cSufDoc    := ::oProMat:cSufOrd

         ::oDbf:cIdeDoc    :=  ::oProMat:cSerOrd + Str( ::oProMat:nNumOrd ) + ::oProMat:cSufOrd
         ::oDbf:nNumLin    :=  ::oProMat:nNumLin

         ::oDbf:nAnoDoc    := Year( ::oProMat:dFecOrd )
         ::oDbf:nMesDoc    := Month( ::oProMat:dFecOrd )
         ::oDbf:dFecDoc    := ::oProMat:dFecOrd

         ::InsertIfValid( .t. )
         ::loadValuesExtraFields()

      end if

      ::oProMat:Skip()

      ::setMeterAutoIncremental()

   end while

   ::oProMat:IdxDelete( cCurUsr(), GetFileNoExt( ::oProMat:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddMovimientoAlmacen() CLASS TFastVentasArticulos

   ::setMeterText( "Procesando movimientos de almac�n" )
   
   ::setMeterTotal( ::oHisMov:OrdKeyCount() )

   ::cExpresionLine           := '( dFecMov >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecMov <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'

   if !::lAllArt
      ::cExpresionLine        += ' .and. ( cRefMov >= "' + ::oGrupoArticulo:Cargo:getDesde() + '" .and. cRefMov <= "' + ::oGrupoArticulo:Cargo:getHasta() + '")'
   end if

   if !::lAllAlm
      ::cExpresionLine        += ' .and. ( cAliMov >= "' + ::oGrupoAlmacen:Cargo:getDesde() + '" .and. cAliMov <= "' + ::oGrupoAlmacen:Cargo:getHasta() + '")'
   end if

   ::oHisMov:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oHisMov:cFile ), ::oHisMov:OrdKey(), cAllTrimer( ::cExpresionLine ), , , , , , , , .t. )

   ::oHisMov:GoTop()

   while !::lBreak .and. !::oHisMov:Eof()

      ::oDbf:Blank()

      ::oDbf:cCodArt    := ::oHisMov:cRefMov
      ::oDbf:cNomArt    := ::oHisMov:cNomMov

      ::oDbf:cCodFam    := RetFld( ::oHisMov:cRefMov, ::oDbfArt:cAlias, "Familia", "Codigo" )
      ::oDbf:cCodTip    := RetFld( ::oHisMov:cRefMov, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
      ::oDbf:cCodCate   := RetFld( ::oHisMov:cRefMov, ::oDbfArt:cAlias, "cCodCate", "Codigo" )
      ::oDbf:cCodTemp   := RetFld( ::oHisMov:cRefMov, ::oDbfArt:cAlias, "cCodTemp", "Codigo" )
      ::oDbf:cCodFab    := RetFld( ::oHisMov:cRefMov, ::oDbfArt:cAlias, "cCodFab", "Codigo" )
      ::oDbf:cCodAlm    := ::oHismov:cAliMov
      ::oDbf:cAlmOrg    := ::oHismov:cAloMov
      ::oDbf:cDesUbi    := RetFld( ::oHisMov:cRefMov, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )
      ::oDbf:cCodEnv    := RetFld( ::oHisMov:cRefMov, ::oDbfArt:cAlias, "cCodFra", "Codigo" )                    

      ::oDbf:nBultos    := ::oHisMov:nBultos
      ::oDbf:nCajas     := ::oHisMov:nCajMov
      ::oDbf:nUniArt    := ::oHisMov:nUndMov
      ::oDbf:nPreArt    := ::oHisMov:nPreDiv

      ::oDbf:nBrtArt    := 0
      ::oDbf:nTotArt    := 0

      ::oDbf:cCodPr1    := ::oHisMov:cCodPr1
      ::oDbf:cCodPr2    := ::oHisMov:cCodPr2
      ::oDbf:cValPr1    := ::oHisMov:cValPr1
      ::oDbf:cValPr2    := ::oHisMov:cValPr2

      ::oDbf:cClsDoc    := MOV_ALM
      
      do case
         case ::oHisMov:nTipMov <= 1
            ::oDbf:cTipDoc    := "Movimiento entre almacenes"

         case ::oHisMov:nTipMov == 2
            ::oDbf:cTipDoc    := "Movimiento regularizaci�n"

         case ::oHisMov:nTipMov == 3
            ::oDbf:cTipDoc    := "Movimiento por objetivo"

         case ::oHismov:nTipMov == 4
            ::oDbf:cTipDoc    := "Movimiento consolidaci�n"

      end case

      ::oDbf:cSerDoc    := ""
      ::oDbf:cNumDoc    := Str( ::oHisMov:nNumRem )
      ::oDbf:cSufDoc    := ::oHisMov:cSufRem

      ::oDbf:cIdeDoc    := Str( ::oHisMov:nNumRem ) + ::oHisMov:cSufRem
      ::oDbf:nNumLin    := ::oHisMov:nNumLin

      ::oDbf:nAnoDoc    := Year( ::oHisMov:dFecMov )
      ::oDbf:nMesDoc    := Month( ::oHisMov:dFecMov )
      ::oDbf:dFecDoc    := ::oHisMov:dFecMov

      //::InsertIfValid( .t. )

      ::oDbf:Insert()

      ::oHisMov:Skip()
      
      ::setMeterAutoIncremental()

   end while

   ::oHisMov:IdxDelete( cCurUsr(), GetFileNoExt( ::oHisMov:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddPedidoProveedor() CLASS TFastVentasArticulos

   local cExpHead
   local cExpLine

   ::oPedPrvT:OrdSetFocus( "dFecPed" )
   ::oPedPrvL:OrdSetFocus( "nNumPed" )

   cExpHead          := '( dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   cExpHead          += ' .and. cCodPrv >= "' + Rtrim( ::oGrupoProveedor:Cargo:getDesde() )    + '" .and. cCodPrv <= "'   + Rtrim( ::oGrupoProveedor:Cargo:getHasta() ) + '"'
   cExpHead          += ' .and. cSerPed >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )        + '" .and. cSerPed <= "'   + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '"'
   cExpHead          += ' .and. nNumPed >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )  + '" ) .and. nNumPed <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" )'
   cExpHead          += ' .and. cSufPed >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )       + '" .and. cSufPed <= "'   + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '"'

   ::oPedPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ), ::oPedPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::setMeterText( "Procesando pedidos a proveedor" )
   ::setMeterTotal( ::oPedPrvT:OrdKeyCount() )

   /*
   Lineas de Pedturas----------------------------------------------------------
   */

   cExpLine          := '!lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::oGrupoArticulo:Cargo:getDesde() + '" .and. cRef <= "' + ::oGrupoArticulo:Cargo:getHasta() + '"'
   end if

   ::oPedPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedPrvL:cFile ), ::oPedPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oPedPrvT:GoTop()

   while !::lBreak .and. !::oPedPrvT:Eof()

      if lChkSer( ::oPedPrvT:cSerPed, ::aSer )

         if ::oPedPrvL:Seek( ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed )

            while !::lBreak .and. ( ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed == ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed ) .and. !::oPedPrvL:Eof()

               //if !( ::lExcCero  .and. nTotNPedPrv( ::oPedPrvL:cAlias ) == 0 )  .and.;
               //   !( ::lExcImp   .and. nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                     ::oDbf:Blank()

                     ::oDbf:cCodArt    := ::oPedPrvL:cRef
                     ::oDbf:cNomArt    := ::oPedPrvL:cDetalle

                     ::oDbf:cCodFam    := ::oPedPrvL:cCodFam
                     ::oDbf:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, ::oPedPrvL:nIva )
                     ::oDbf:cCodTip    := RetFld( ::oPedPrvL:cRef, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
                     ::oDbf:cCodCate   := RetFld( ::oPedPrvL:cRef, ::oDbfArt:cAlias, "cCodCate", "Codigo" )
                     ::oDbf:cCodEst    := RetFld( ::oPedPrvL:cRef, ::oDbfArt:cAlias, "cCodEst", "Codigo" )
                     ::oDbf:cCodTemp   := RetFld( ::oPedPrvL:cRef, ::oDbfArt:cAlias, "cCodTemp", "Codigo" )
                     ::oDbf:cCodFab    := RetFld( ::oPedPrvL:cRef, ::oDbfArt:cAlias, "cCodFab", "Codigo" )
                     ::oDbf:cCodGrp    := RetFld( ::oPedPrvL:cRef, ::oDbfArt:cAlias, "GrpVent", "Codigo" )
                     ::oDbf:cDesUbi    := RetFld( ::oPedPrvL:cRef, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )
                     ::oDbf:cCodEnv    := RetFld( ::oPedPrvL:cRef, ::oDbfArt:cAlias, "cCodFra", "Codigo" )
                     ::oDbf:cCodCli    := ::oPedPrvT:cCodPrv
                     ::oDbf:cNomCli    := ::oPedPrvT:cNomPrv
                     ::oDbf:cPobCli    := ::oPedPrvT:cPobPrv
                     ::oDbf:cPrvCli    := ::oPedPrvT:cProPrv
                     ::oDbf:cPosCli    := ::oPedPrvT:cPosPrv
                     ::oDbf:cCodAlm    := ::oPedPrvL:cAlmLin
                     ::oDbf:cCodPago   := ::oPedPrvT:cCodPgo
                     ::oDbf:cCodRut    := ""
                     ::oDbf:cCodAge    := ""
                     ::oDbf:cCodTrn    := ""
                     ::oDbf:cCodUsr    := ::oPedPrvT:cCodUsr

                     ::oDbf:nUniArt    := nTotNPedPrv( ::oPedPrvL:cAlias )
                     ::oDbf:nPreArt    := nImpUPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDerOut, ::nValDiv )

                     ::oDbf:nDtoArt    := ::oPedPrvL:nDtoLin                     
                     ::oDbf:nPrmArt    := ::oPedPrvL:nDtoPrm

                     ::oDbf:nTotDto    := nDtoLPedPrv( ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotPrm    := nPrmLPedPrv( ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                     ::oDbf:nBrtArt    := nBrtLPedPrv( ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nImpArt    := nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
                     ::oDbf:nIvaArt    := nIvaLPedPrv(::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     //::oDbf:nImpEsp    := nImpEspLPedPrv(::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotArt    := nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
                     ::oDbf:nTotArt    += nIvaLPedPrv(::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nCosArt    := nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )

                     ::oDbf:cCodPr1    := ::oPedPrvL:cCodPr1
                     ::oDbf:cCodPr2    := ::oPedPrvL:cCodPr2
                     ::oDbf:cValPr1    := ::oPedPrvL:cValPr1
                     ::oDbf:cValPr2    := ::oPedPrvL:cValPr2

                     ::oDbf:cClsDoc    := PED_PRV
                     ::oDbf:cTipDoc    := "Pedido proveedor"
                     ::oDbf:cSerDoc    := ::oPedPrvT:cSerPed
                     ::oDbf:cNumDoc    := Str( ::oPedPrvT:nNumPed )
                     ::oDbf:cSufDoc    := ::oPedPrvT:cSufPed

                     ::oDbf:cIdeDoc    :=  ::idDocumento()
                     ::oDbf:nNumLin    :=  ::oPedPrvL:nNumLin

                     ::oDbf:nAnoDoc    := Year( ::oPedPrvT:dFecPed )
                     ::oDbf:nMesDoc    := Month( ::oPedPrvT:dFecPed )
                     ::oDbf:dFecDoc    := ::oPedPrvT:dFecPed
                     ::oDbf:cHorDoc    := SubStr( ::oPedPrvT:cTimChg, 1, 2 )
                     ::oDbf:cMinDoc    := SubStr( ::oPedPrvT:cTimChg, 4, 2 )

                     ::oDbf:nBultos    := ::oPedPrvL:nBultos   
                     ::oDbf:cFormaTo   := ::oPedPrvL:cFormato
                     ::oDbf:nCajas     := ::oPedPrvL:nCanPed

                     ::oDbf:cCtrCoste  := ::oPedPrvL:cCtrCoste
                     ::oDbf:cTipCtr    := ::oPedPrvL:cTipCtr
                     ::oDbf:cCodTerCtr := ::oPedPrvL:cTerCtr
                     ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ::oPedPrvL:cTipCtr, ::oPedPrvL:cTerCtr, ::nView )

                  ::InsertIfValid()
                  ::loadValuesExtraFields()

               //end if

               ::oPedPrvL:Skip()

            end while

         end if

      end if

      ::oPedPrvT:Skip()

      ::setMeterAutoIncremental()

   end while

   ::oPedPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ) )
   ::oPedPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedPrvL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddAlbaranProveedor( lFacturados ) CLASS TFastVentasArticulos

   DEFAULT lFacturados  := .f.

   ::cExpresionHeader      := '( Field->dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSerAlb >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerAlb <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionHeader      += ' .and. ( Field->nNumAlb >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumAlb <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSufAlb >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufAlb <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '")'

   if lFacturados
      ::cExpresionHeader   += ' .and. nFacturado < 3'
   end if

   ::setFilterProveedorIdHeader()

   ::oAlbPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

   ::cExpresionLine        := '!Field->lControl'

   ::setFilterProductIdLine()

   ::oAlbPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvL:cFile ), ::oAlbPrvL:OrdKey(), cAllTrimer( ::cExpresionLine ), , , , , , , , .t. )

   ::setMeterText( "Procesando albaranes a proveedor" )
   ::setMeterTotal( ::oAlbPrvL:OrdKeyCount() )

   ::oAlbPrvL:GoTop()

   while !::lBreak .and. !::oAlbPrvL:Eof()

      ::oDbf:Blank()

      ::oDbf:cCodArt    := ::oAlbPrvL:cRef
      ::oDbf:cNomArt    := ::oAlbPrvL:cDetalle

      ::oDbf:cCodFam    := ::oAlbPrvL:cCodFam
      ::oDbf:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, ::oAlbPrvL:nIva )
      ::oDbf:cCodTip    := RetFld( ::oAlbPrvL:cRef, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
      ::oDbf:cCodCate   := RetFld( ::oAlbPrvL:cRef, ::oDbfArt:cAlias, "cCodCate", "Codigo" )
      ::oDbf:cCodEst    := RetFld( ::oAlbPrvL:cRef, ::oDbfArt:cAlias, "cCodEst", "Codigo" )
      ::oDbf:cCodTemp   := RetFld( ::oAlbPrvL:cRef, ::oDbfArt:cAlias, "cCodTemp", "Codigo" )
      ::oDbf:cCodFab    := RetFld( ::oAlbPrvL:cRef, ::oDbfArt:cAlias, "cCodFab", "Codigo" )
      ::oDbf:cCodGrp    := RetFld( ::oAlbPrvL:cRef, ::oDbfArt:cAlias, "GrpVent", "Codigo" )
      ::oDbf:cDesUbi    := RetFld( ::oAlbPrvL:cRef, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )
      ::oDbf:cCodEnv    := RetFld( ::oAlbPrvL:cRef, ::oDbfArt:cAlias, "cCodFra", "Codigo" )
      ::oDbf:cCodAlm    := ::oAlbPrvL:cAlmLin

      ::oDbf:nUniArt    := nTotNAlbPrv( ::oAlbPrvL:cAlias )
      ::oDbf:nBrtArt    := nBrtLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oDbf:nDtoArt    := ::oAlbPrvL:nDtoLin                     
      ::oDbf:nPrmArt    := ::oAlbPrvL:nDtoPrm

      ::oDbf:nTotDto    := nDtoLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotPrm    := nPrmLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oDbf:nIvaArt    := nIvaLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oDbf:cCodPr1    := ::oAlbPrvL:cCodPr1
      ::oDbf:cCodPr2    := ::oAlbPrvL:cCodPr2
      ::oDbf:cValPr1    := ::oAlbPrvL:cValPr1
      ::oDbf:cValPr2    := ::oAlbPrvL:cValPr2

      ::oDbf:cLote      := ::oAlbPrvL:cLote
      ::oDbf:dFecCad    := ::oAlbPrvL:dFecCad

      ::oDbf:cClsDoc    := ALB_PRV
      ::oDbf:cTipDoc    := "Albar�n proveedor"
      ::oDbf:cSerDoc    := ::oAlbPrvL:cSerAlb
      ::oDbf:cNumDoc    := Str( ::oAlbPrvL:nNumAlb )
      ::oDbf:cSufDoc    := ::oAlbPrvL:cSufAlb 

      ::oDbf:cIdeDoc    :=  ::idDocumento()
      ::oDbf:nNumLin    :=  ::oAlbPrvL:nNumLin

      ::oDbf:nBultos    := ::oAlbPrvL:nBultos
      ::oDbf:cFormato   := ::oAlbPrvL:cFormato
      ::oDBf:nCajas     := ::oAlbPrvL:nCanEnt

      ::oDBf:cCtrCoste  := ::oAlbPrvL:cCtrCoste
      ::oDbf:cTipCtr    := ::oAlbPrvL:cTipCtr
      ::oDbf:cCodTerCtr := ::oAlbPrvL:cTerCtr
      ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ::oAlbPrvL:cTipCtr, ::oAlbPrvL:cTerCtr, ::nView )

      if ::oAlbPrvT:Seek( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb, 9 ) + ::oAlbPrvL:cSufAlb )

         ::oDbf:cCodCli    := ::oAlbPrvT:cCodPrv
         ::oDbf:cNomCli    := ::oAlbPrvT:cNomPrv
         ::oDbf:cPobCli    := ::oAlbPrvT:cPobPrv
         ::oDbf:cPrvCli    := ::oAlbPrvT:cProPrv
         ::oDbf:cPosCli    := ::oAlbPrvT:cPosPrv
         ::oDbf:cCodPago   := ::oAlbPrvT:cCodPgo
         ::oDbf:cCodRut    := ""
         ::oDbf:cCodAge    := ""
         ::oDbf:cCodAge    := ""
         ::oDbf:cCodTrn    := ""
         ::oDbf:cCodUsr    := ::oAlbPrvT:cCodUsr
   
         ::oDbf:cPrvHab    := ::oAlbPrvT:cCodPrv

         ::oDbf:nPreArt    := nImpUAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDerOut, ::nValDiv )

         ::oDbf:nImpArt    := nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nTotArt    := nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nCosArt    := nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )

         ::oDbf:nAnoDoc    := Year( ::oAlbPrvT:dFecAlb )
         ::oDbf:nMesDoc    := Month( ::oAlbPrvT:dFecAlb )
         ::oDbf:dFecDoc    := ::oAlbPrvT:dFecAlb
         ::oDbf:cHorDoc    := SubStr( ::oAlbPrvT:cTimChg, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ::oAlbPrvT:cTimChg, 4, 2 )

      end if

      ::InsertIfValid()
      ::loadValuesExtraFields()

      ::oAlbPrvL:Skip()

      ::setMeterAutoIncremental()

   end while

   ::oAlbPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ) )
   ::oAlbPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbPrvL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaProveedor( cCodigoArticulo ) CLASS TFastVentasArticulos

   ::cExpresionHeader      := '( Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSerFac >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() ) + '" .and. Field->cSerFac <= "'    + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionHeader      += ' .and. ( Field->nNumFac >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumFac <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() ) + '" .and. Field->cSufFac <= "'    + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterProveedorIdHeader()

   ::oFacPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

   ::setMeterText( "Procesando facturas proveedor" )
   
   ::setMeterTotal( ::oFacPrvL:OrdKeyCount() )

   /*
   Lineas de facturas----------------------------------------------------------
   */

   ::cExpresionLine        := '!Field->lControl'

   ::setFilterProductIdLine()

   ::oFacPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ), ::oFacPrvL:OrdKey(), cAllTrimer( ::cExpresionLine ), , , , , , , , .t. )

   ::oFacPrvL:GoTop()

   while !::lBreak .and. !::oFacPrvL:Eof()

      ::oDbf:Blank()

      ::oDbf:cCodArt    := ::oFacPrvL:cRef
      ::oDbf:cNomArt    := ::oFacPrvL:cDetalle

      ::oDbf:cCodFam    := ::oFacPrvL:cCodFam
      ::oDbf:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, ::oFacPrvL:nIva )
      ::oDbf:cCodTip    := RetFld( ::oFacPrvL:cRef, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
      ::oDbf:cCodCate   := RetFld( ::oFacPrvL:cRef, ::oDbfArt:cAlias, "cCodCate", "Codigo" )
      ::oDbf:cCodEst    := RetFld( ::oFacPrvL:cRef, ::oDbfArt:cAlias, "cCodEst", "Codigo" )
      ::oDbf:cCodTemp   := RetFld( ::oFacPrvL:cRef, ::oDbfArt:cAlias, "cCodTemp", "Codigo" )
      ::oDbf:cCodFab    := RetFld( ::oFacPrvL:cRef, ::oDbfArt:cAlias, "cCodFab", "Codigo" )
      ::oDbf:cCodGrp    := RetFld( ::oFacPrvL:cRef, ::oDbfArt:cAlias, "GrpVent", "Codigo" )
      ::oDbf:cDesUbi    := RetFld( ::oFacPrvL:cRef, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )
      ::oDbf:cCodEnv    := RetFld( ::oFacPrvL:cRef, ::oDbfArt:cAlias, "cCodFra", "Codigo" )
      ::oDbf:cCodAlm    := ::oFacPrvL:cAlmLin

      ::oDbf:nUniArt    := nTotNFacPrv( ::oFacPrvL:cAlias )

      ::oDbf:nDtoArt    := ::oFacPrvL:nDtoLin                     
      ::oDbf:nPrmArt    := ::oFacPrvL:nDtoPrm

      ::oDbf:nTotDto    := nDtoLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotPrm    := nPrmLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oDbf:nBrtArt    := nBrtLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nIvaArt    := nIvaLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oDbf:cCodPr1    := ::oFacPrvL:cCodPr1
      ::oDbf:cCodPr2    := ::oFacPrvL:cCodPr2
      ::oDbf:cValPr1    := ::oFacPrvL:cValPr1
      ::oDbf:cValPr2    := ::oFacPrvL:cValPr2

      ::oDbf:cLote      := ::oFacPrvL:cLote
      ::oDbf:dFecCad    := ::oFacPrvL:dFecCad

      ::oDbf:cClsDoc    := FAC_PRV
      ::oDbf:cTipDoc    := "Factura proveedor"
      ::oDbf:cSerDoc    := ::oFacPrvL:cSerFac
      ::oDbf:cNumDoc    := Str( ::oFacPrvL:nNumFac )
      ::oDbf:cSufDoc    := ::oFacPrvL:cSufFac

      ::oDbf:cIdeDoc    :=  ::idDocumento()
      ::oDbf:nNumLin    :=  ::oFacPrvL:nNumLin

      ::oDbf:nBultos    := ::oFacPrvL:nBultos
      ::oDbf:cFormato   := ::oFacPrvL:cFormato
      ::oDbf:nCajas     := ::oFacPrvL:nCanEnt

      ::oDbf:cCtrCoste  := ::oFacPrvL:cCtrCoste
      ::oDbf:cTipCtr    := ::oFacPrvL:cTipCtr
      ::oDbf:cCodTerCtr := ::oFacPrvL:cTerCtr
      ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ::oFacPrvL:cTipCtr, ::oFacPrvL:cTerCtr, ::nView )

      if ::oFacPrvT:Seek( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac, 9 ) + ::oFacPrvL:cSufFac )

         ::oDbf:cCodCli    := ::oFacPrvT:cCodPrv
         ::oDbf:cNomCli    := ::oFacPrvT:cNomPrv
         ::oDbf:cPobCli    := ::oFacPrvT:cPobPrv
         ::oDbf:cPrvCli    := ::oFacPrvT:cProvProv
         ::oDbf:cPosCli    := ::oFacPrvT:cPosPrv
         ::oDbf:cCodPago   := ::oFacPrvT:cCodPago
         ::oDbf:cCodRut    := ""
         ::oDbf:cCodAge    := ::oFacPrvT:cCodAge
         ::oDbf:cCodTrn    := ""
         ::oDbf:cCodUsr    := ::oFacPrvT:cCodUsr
         ::oDbf:cPrvHab    := ::oFacPrvT:cCodPrv

         ::oDbf:nPreArt    := nImpUFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDerOut, ::nValDiv )

         ::oDbf:nImpArt    := nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nTotArt    := nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nCosArt    := nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )

         ::oDbf:nAnoDoc    := Year( ::oFacPrvT:dFecFac )
         ::oDbf:nMesDoc    := Month( ::oFacPrvT:dFecFac )
         ::oDbf:dFecDoc    := ::oFacPrvT:dFecFac
         ::oDbf:cHorDoc    := SubStr( ::oFacPrvT:cTimChg, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ::oFacPrvT:cTimChg, 4, 2 )

      end if

      ::InsertIfValid()
      ::loadValuesExtraFields()

      ::oFacPrvL:Skip()

      ::setMeterAutoIncremental()

   end while

   ::oFacPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ) )
   ::oFacPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddRectificativaProveedor( cCodigoArticulo ) CLASS TFastVentasArticulos

   ::cExpresionHeader      := '( Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSerFac >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() ) + '" .and. Field->cSerFac <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionHeader      += ' .and. ( Field->nNumFac >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumFac <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() ) + '" .and. Field->cSufFac <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterProveedorIdHeader()

   ::oRctPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oRctPrvT:cFile ), ::oRctPrvT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

   ::setMeterText( "Procesando rectificativas" )
   ::setMeterTotal( ::oRctPrvL:OrdKeyCount() )

   /*
   Lineas de facturas----------------------------------------------------------
   */

   ::cExpresionLine        := '!Field->lControl'

   ::setFilterProductIdLine()

   ::oRctPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oRctPrvL:cFile ), ::oRctPrvL:OrdKey(), cAllTrimer( ::cExpresionLine ), , , , , , , , .t. )

   ::oRctPrvL:GoTop()

   while !::lBreak .and. !::oRctPrvL:Eof()

      ::oDbf:Blank()

      ::oDbf:cCodArt    := ::oRctPrvL:cRef
      ::oDbf:cNomArt    := ::oRctPrvL:cDetalle

      ::oDbf:cCodFam    := ::oRctPrvL:cCodFam
      ::oDbf:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, ::oRctPrvL:nIva )
      ::oDbf:cCodTip    := RetFld( ::oRctPrvL:cRef, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
      ::oDbf:cCodCate   := RetFld( ::oRctPrvL:cRef, ::oDbfArt:cAlias, "cCodCate", "Codigo" )
      ::oDbf:cCodEst    := RetFld( ::oRctPrvL:cRef, ::oDbfArt:cAlias, "cCodEst", "Codigo" )
      ::oDbf:cCodTemp   := RetFld( ::oRctPrvL:cRef, ::oDbfArt:cAlias, "cCodTemp", "Codigo" )
      ::oDbf:cCodFab    := RetFld( ::oRctPrvL:cRef, ::oDbfArt:cAlias, "cCodFab", "Codigo" )
      ::oDbf:cCodGrp    := RetFld( ::oRctPrvL:cRef, ::oDbfArt:cAlias, "GrpVent", "Codigo" )
      ::oDbf:cDesUbi    := RetFld( ::oRctPrvL:cRef, ::oDbfArt:cAlias, "cDesUbi", "Codigo" )
      ::oDbf:cCodEnv    := RetFld( ::oRctPrvL:cRef, ::oDbfArt:cAlias, "cCodFra", "Codigo" )
      ::oDbf:cCodAlm    := ::oRctPrvL:cAlmLin

      ::oDbf:nUniArt    := nTotNRctPrv( ::oRctPrvL:cAlias )
      ::oDbf:nDtoArt    := ::oRctPrvL:nDtoLin                     
      ::oDbf:nPrmArt    := ::oRctPrvL:nDtoPrm
      ::oDbf:nTotDto    := nDtoLRctPrv( ::oRctPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotPrm    := nPrmLRctPrv( ::oRctPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nBrtArt    := nBrtLRctPrv( ::oRctPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nIvaArt    := nIvaLRctPrv( ::oRctPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oDbf:cCodPr1    := ::oRctPrvL:cCodPr1
      ::oDbf:cCodPr2    := ::oRctPrvL:cCodPr2
      ::oDbf:cValPr1    := ::oRctPrvL:cValPr1
      ::oDbf:cValPr2    := ::oRctPrvL:cValPr2

      ::oDbf:cLote      := ::oRctPrvL:cLote
      ::oDbf:dFecCad    := ::oRctPrvL:dFecCad

      ::oDbf:cClsDoc    := RCT_PRV
      ::oDbf:cTipDoc    := "Rectificativa proveedor"
      ::oDbf:cSerDoc    := ::oRctPrvL:cSerFac
      ::oDbf:cNumDoc    := Str( ::oRctPrvL:nNumFac )
      ::oDbf:cSufDoc    := ::oRctPrvL:cSufFac

      ::oDbf:cIdeDoc    :=  ::idDocumento()
      ::oDbf:nNumLin    :=  ::oRctPrvL:nNumLin

      ::oDbf:nBultos    := ::oRctPrvL:nBultos
      ::oDbf:cFormato   := ::oRctPrvL:cFormato
      ::oDbf:nCajas     := ::oRctPrvL:nCanEnt

      ::oDbf:cCtrCoste  := ::oRctPrvL:cCtrCoste
      ::oDbf:cTipCtr    := ::oRctPrvL:cTipCtr
      ::oDbf:cCodTerCtr := ::oRctPrvL:cTerCtr
      ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ::oRctPrvL:cTipCtr, ::oRctPrvL:cTerCtr, ::nView )

      /*
      Metemos los datos de cabecera--------------------------------
      */

      if ::oRctPrvL:Seek( ::oRctPrvL:cSerFac + Str( ::oRctPrvL:nNumFac ) + ::oRctPrvL:cSufFac )

         ::oDbf:cCodCli    := ::oRctPrvT:cCodPrv
         ::oDbf:cNomCli    := ::oRctPrvT:cNomPrv
         ::oDbf:cPobCli    := ::oRctPrvT:cPobPrv
         ::oDbf:cPrvCli    := ::oRctPrvT:cProvProv
         ::oDbf:cPosCli    := ::oRctPrvT:cPosPrv
         ::oDbf:cCodPago   := ::oRctPrvT:cCodPago
         ::oDbf:cCodRut    := ""
         ::oDbf:cCodAge    := ::oRctPrvT:cCodAge
         ::oDbf:cCodTrn    := ""
         ::oDbf:cCodUsr    := ::oRctPrvT:cCodUsr
         ::oDbf:cPrvHab    := ::oRctPrvT:cCodPrv

         ::oDbf:nPreArt    := nImpURctPrv( ::oRctPrvT:cAlias, ::oRctPrvL:cAlias, ::nDerOut, ::nValDiv )

         ::oDbf:nImpArt    := nImpLRctPrv( ::oRctPrvT:cAlias, ::oRctPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nTotArt    := nImpLRctPrv( ::oRctPrvT:cAlias, ::oRctPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLRctPrv( ::oRctPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nCosArt    := nImpLRctPrv( ::oRctPrvT:cAlias, ::oRctPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )

         ::oDbf:nAnoDoc    := Year( ::oRctPrvT:dFecFac )
         ::oDbf:nMesDoc    := Month( ::oRctPrvT:dFecFac )
         ::oDbf:dFecDoc    := ::oRctPrvT:dFecFac
         ::oDbf:cHorDoc    := SubStr( ::oRctPrvT:cTimChg, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ::oRctPrvT:cTimChg, 4, 2 )

      end if

      ::InsertIfValid()
      ::loadValuesExtraFields()

      ::oRctPrvL:Skip()

      ::setMeterAutoIncremental()

   end while

   ::oRctPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oRctPrvT:cFile ) )
   ::oRctPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oRctPrvL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GetInformacionEntrada( cCodArt, cLote, cDatoRequerido ) 

   local cDato := ::GetDatoMovimientosAlamcen( cCodArt, cLote, cDatoRequerido )

RETURN if ( !empty( cDato ), cDato, ::GetDatoAlbaranProveedor( cCodArt, cLote, cDatoRequerido ) )

//---------------------------------------------------------------------------//

METHOD GetDatoAlbaranProveedor( cCodArt, cLote, cCampoRequerido )

   local Resultado

   DEFAULT cCampoRequerido    := "dFecAlb"

   ::oAlbPrvL:getStatus()

   ::oAlbPrvL:OrdSetFocus( "cRefFec" )

   if ::oAlbPrvL:Seek( Padr( cCodArt, 18 ) + Padr( cLote, 12 ) )

      if ::oAlbPrvL:fieldpos( cCampoRequerido ) != 0
         Resultado   := ::oAlbPrvL:fieldgetbyname( cCampoRequerido )
      end if 
               
   end if  

   ::oAlbPrvL:setStatus()

RETURN ( Resultado )

//---------------------------------------------------------------------------//

METHOD GetDatoMovimientosAlamcen( cCodArt, cLote, cCampoRequerido )

   local Resultado            := ""

   DEFAULT cCampoRequerido    := "dFecMov"

   ::oHisMov:getStatus()

   ::oHisMov:OrdSetFocus( "cRefFec" )

   if ::oHisMov:Seek( Padr( cCodArt, 18 ) + Padr( cLote, 12 ) )

      if ::oHisMov:fieldpos( cCampoRequerido ) != 0
         Resultado   := ::oHisMov:fieldgetbyname( cCampoRequerido )
      end if
                
   end if

   ::oHisMov:setStatus()

RETURN ( resultado )

//--------------------------------------------------------------------------//

METHOD getNumeroAlbaranProveedor() CLASS TFastVentasArticulos

   local nRec
   local nOrdAnt
   local cClave
   local cNumero  := ""

   cClave         := ::oDbf:cSerDoc
   cClave         += Padr( ::oDbf:cNumDoc, 9 )
   cClave         += ::oDbf:cSufDoc
   cClave         += ::oDbf:cCodArt
   cClave         += ::oDbf:cValPr1
   cClave         += ::oDbf:cValPr2
   cClave         += ::oDbf:cLote

   nRec           := ::oAlbPrvL:Recno()
   nOrdAnt        := ::oAlbPrvL:OrdSetFocus( "cPedPrvRef" )

   if ::oAlbPrvL:Seek( cClave )
      cNumero     := ::oAlbPrvL:cSerAlb + "/" + AllTrim( Str( ::oAlbPrvL:nNumAlb ) ) + "/" + ::oAlbPrvL:cSufAlb
   end if

   ::oAlbPrvL:OrdSetFocus( nOrdAnt )
   ::oAlbPrvL:GoTo( nRec )

Return ( cNumero )

//---------------------------------------------------------------------------//

METHOD getFechaAlbaranProveedor() CLASS TFastVentasArticulos

   local nRec
   local nOrdAnt
   local cClave
   local dFecha   := ctod( "" )

   cClave         := ::oDbf:cSerDoc
   cClave         += Padr( ::oDbf:cNumDoc, 9 )
   cClave         += ::oDbf:cSufDoc
   cClave         += ::oDbf:cCodArt
   cClave         += ::oDbf:cValPr1
   cClave         += ::oDbf:cValPr2
   cClave         += ::oDbf:cLote

   nRec           := ::oAlbPrvL:Recno()
   nOrdAnt        := ::oAlbPrvL:OrdSetFocus( "cPedPrvRef" )

   if ::oAlbPrvL:Seek( cClave )
      dFecha     := ::oAlbPrvL:dFecAlb
   end if

   ::oAlbPrvL:OrdSetFocus( nOrdAnt )
   ::oAlbPrvL:GoTo( nRec )

Return ( dFecha )

//---------------------------------------------------------------------------//

METHOD getUnidadesAlbaranProveedor() CLASS TFastVentasArticulos

   local nRec
   local nOrdAnt
   local cClave
   local nUnidades   := 0

   cClave            := ::oDbf:cSerDoc
   cClave            += Padr( ::oDbf:cNumDoc, 9 )
   cClave            += ::oDbf:cSufDoc
   cClave            += ::oDbf:cCodArt
   cClave            += ::oDbf:cValPr1
   cClave            += ::oDbf:cValPr2
   cClave            += ::oDbf:cLote

   nRec              := ::oAlbPrvL:Recno()
   nOrdAnt           := ::oAlbPrvL:OrdSetFocus( "cPedPrvRef" )

   if ::oAlbPrvL:Seek( cClave )
      nUnidades      := nTotNAlbPrv( ::oAlbPrvL )
   end if

   ::oAlbPrvL:OrdSetFocus( nOrdAnt )
   ::oAlbPrvL:GoTo( nRec )

Return ( nUnidades )

//---------------------------------------------------------------------------//

METHOD getEstadoAlbaranProveedor() CLASS TFastVentasArticulos

   local nRec
   local nOrdAnt
   local cClave
   local cEstado  := "No"

   cClave         := ::oDbf:cSerDoc
   cClave         += Padr( ::oDbf:cNumDoc, 9 )
   cClave         += ::oDbf:cSufDoc
   cClave         += ::oDbf:cCodArt 
   cClave         += ::oDbf:cValPr1
   cClave         += ::oDbf:cValPr2
   cClave         += ::oDbf:cLote

   nRec           := ::oAlbPrvL:Recno()
   nOrdAnt        := ::oAlbPrvL:OrdSetFocus( "cPedPrvRef" )

   if ::oAlbPrvL:Seek( cClave )
      if ::oAlbPrvL:lFacturado
         cEstado  := "Si"
      end if
   end if

   ::oAlbPrvL:OrdSetFocus( nOrdAnt )
   ::oAlbPrvL:GoTo( nRec )

Return ( cEstado )

//---------------------------------------------------------------------------//

METHOD geFechaPedidoProveedor() CLASS TFastVentasArticulos

   local nRec
   local nOrdAnt
   local cClave   := ""
   local dFecha   := ctod( "" )

   cClave         += ::oDbf:cCodArt
   cClave         += ::oDbf:cCodPr1
   cClave         += ::oDbf:cCodPr2
   cClave         += ::oDbf:cValPr1
   cClave         += ::oDbf:cValPr2
   cClave         += ::oDbf:cLote

   nRec           := ::oPedPrvL:Recno()
   nOrdAnt        := ::oPedPrvL:OrdSetFocus( "cPedRef" )

   if ::oPedPrvL:Seek( cClave )
      dFecha     := dFecPedPrv( ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed, ::oPedPrvT:cAlias )
   end if

   ::oPedPrvL:OrdSetFocus( nOrdAnt )
   ::oPedPrvL:GoTo( nRec )

Return ( dFecha )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS TFastVentasArticulos

   ::CreateTreeImageList()

   ::BuildTree()

   ::BuildReportCorrespondences()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariableStock()
   
   ::oFastReport:AddVariable( "Stock", "Costo medio",                "CallHbFunc( 'oTInfGen', ['nCostoMedio', ''])" )
   ::oFastReport:AddVariable( "Stock", "Costo medio propiedades",    "CallHbFunc( 'oTInfGen', ['nCostoMedioPropiedades', ''])" )
   ::oFastReport:AddVariable( "Stock", "Total stock",                "CallHbFunc( 'oTInfGen', ['nTotalStockArticulo', ''])" )
   ::oFastReport:AddVariable( "Stock", "Nombre primera propiedad",   "CallHbFunc( 'oTInfGen', ['nombrePrimeraPropiedad', ''])" )
   ::oFastReport:AddVariable( "Stock", "Nombre segunda propiedad",   "CallHbFunc( 'oTInfGen', ['nombreSegundaPropiedad', ''])" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FastReportPedidoCliente()
      
   ( D():PedidosClientes( ::nView ) )->( ordsetfocus( "iNumPed" ) )
   ( D():PedidosClientesLineas( ::nView ) )->( ordsetfocus( "iNumPed" ) )

   ::oFastReport:SetWorkArea(       "Pedidos de clientes", ( D():PedidosClientes( ::nView ) )->( Select() ) )
   ::oFastReport:SetFieldAliases(   "Pedidos de clientes", cItemsToReport( aItmPedCli() ) )

   ::oFastReport:SetWorkArea(       "Lineas pedidos de clientes", ( D():PedidosClientesLineas( ::nView ) )->( Select() ) )
   ::oFastReport:SetFieldAliases(   "Lineas pedidos de clientes", cItemsToReport( aColPedCli() ) )

   ::oFastReport:SetMasterDetail(   "Informe", "Pedidos de clientes",         {|| ::idDocumento() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Lineas pedidos de clientes",  {|| ::IdDocumentoLinea() } )

   ::oFastReport:SetResyncPair(     "Informe", "Pedidos de clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Lineas pedidos de clientes" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD sqlPedidoClientes() CLASS TFastVentasArticulos

   local cStm 

   local cArticuloDesde       := ""                // ::oGrupoArticulo:Cargo:getDesde()
   local cArticuloHasta       := "ZZZZZZZZZZZZZZ"  // ::oGrupoArticulo:Cargo:getHasta()

   ::fileHeader               := cPatEmp() + "PedCliT"
   ::fileLine                 := cPatEmp() + "PedCliL"   
   ::dictionaryHeader         := TDataCenter():getDictionary( "PedCliT" )
   ::dictionaryLine           := TDataCenter():getDictionary( "PedCliL" )

   cStm           := "SELECT  lineasDocumento." + ::getNameFieldLine( "Articulo" )     +  " AS Articulo, "           
   cStm           +=          "lineasDocumento." + ::getNameFieldLine( "Serie" )       +  " AS Serie, "
   cStm           +=          "lineasDocumento." + ::getNameFieldLine( "Numero" )      +  " AS Numero, "
   cStm           +=          "lineasDocumento." + ::getNameFieldLine( "Sufijo" )      +  " AS Sufijo, "
   cStm           +=          "lineasDocumento." + ::getNameFieldLine( "Proveedor" )   +  " AS CodigoProveedor, "

   cStm           +=          "cabeceraDocumento." + ::getNameFieldHeader( "Fecha" )   +  " AS Fecha , "

   cStm           +=          "articulos.cCodTip" +                                       " AS TipoArticulo ,"
   cStm           +=          "articulos.cCodCate" +                                      " AS CategoriaArticulo ,"
   cStm           +=          "articulos.cCodEst" +                                       " AS EstadoArticulo ,"
   cStm           +=          "articulos.cCodTemp" +                                      " AS TemporadaArticulo ,"
   cStm           +=          "articulos.cCodFab" +                                       " AS FabricanteArticulo ,"

   cStm           +=          "tiposIva.Tipo" +                                           " AS CodigoIva ,"

   cStm           +=          "clientes.cCodGrp" +                                        " AS GrupoCliente ,"

   cStm           +=          "proveedores.Titulo" +                                      " AS NombreProveedor "

   cStm           += "FROM " + ::fileLine + " lineasDocumento "
   
   cStm           += "INNER JOIN " + ::fileHeader + " cabeceraDocumento ON " 
   cStm           +=          "lineasDocumento." + ::getNameFieldLine( "Serie" )       + " = cabeceraDocumento." + ::getNameFieldHeader( "Serie" )   + " AND "
   cStm           +=          "lineasDocumento." + ::getNameFieldLine( "Numero" )      + " = cabeceraDocumento." + ::getNameFieldHeader( "Numero" )  + " AND "
   cStm           +=          "lineasDocumento." + ::getNameFieldLine( "Sufijo" )      + " = cabeceraDocumento." + ::getNameFieldHeader( "Sufijo" )  + " "
   
   cStm           += "LEFT JOIN " + cPatCli() + "Client      clientes ON cabeceraDocumento." + ::getNameFieldHeader( "Cliente" )  + " = clientes.Cod "
   cStm           += "LEFT JOIN " + cPatPrv() + "Provee      proveedores ON lineasDocumento." + ::getNameFieldLine( "Proveedor" ) + " = proveedores.Cod "
   cStm           += "LEFT JOIN " + cPatDat() + "Tiva        tiposIva ON lineasDocumento." + ::getNameFieldLine( "PorcentajeImpuesto" ) + " = tiposIva.tpIva "
   cStm           += "LEFT JOIN " + cPatArt() + "Articulo    articulos ON lineasDocumento." + ::getNameFieldLine( "Articulo" )  + " = articulos.Codigo "

   cStm           += "WHERE   lineasDocumento." + ::getNameFieldLine( "Articulo" )     + " >= '" + cArticuloDesde + "' AND " 
   cStm           +=          "lineasDocumento." + ::getNameFieldLine( "Articulo" )    + " <= '" + cArticuloHasta + "' "

   cStm           += "ORDER BY lineasDocumento." + ::getNameFieldLine( "Articulo" )    

   logWrite( cStm )

   TDataCenter():ExecuteSqlStatement( cStm, "lineasDocumento" ) 

   ( "lineasDocumento" )->( browse() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadValuesExtraFields() CLASS TFastVentasArticulos

   local cField
   local uValor

   if isArray( ::aExtraFields ) .and. len( ::aExtraFields ) != 0

      for each cField in ::aExtraFields
         
         uValor             := ::oCamposExtra:valueExtraField( cField[ "c�digo" ], ::oDbf:cCodArt, cField )

         ::oDbf:fieldPutByName( "fld" + cField[ "c�digo" ], uValor )

      next

   end if

Return ( self )

//--------------------------------------------------------------------------//

METHOD getTarifaArticulo( cCodTar, cCodArt, nPrc ) CLASS TFastVentasArticulos

   local nPrecio := 0
   local nOrdAnt := ::oTarPreL:OrdSetFocus( "cCodArt" )

   if empty( cCodTar )
      Return nPrecio
   end if

   if empty( cCodArt )
      Return nPrecio
   end if

   if ::oTarPreL:Seek( cCodTar + cCodArt )
      do case
         case nPrc == "1"
            nPrecio     := ::oTarPreL:nPrcTar1

         case nPrc == "2"
            nPrecio     := ::oTarPreL:nPrcTar2

         case nPrc == "3"
            nPrecio     := ::oTarPreL:nPrcTar3

         case nPrc == "4"
            nPrecio     := ::oTarPreL:nPrcTar4

         case nPrc == "5"
            nPrecio     := ::oTarPreL:nPrcTar5

         case nPrc == "6"
            nPrecio     := ::oTarPreL:nPrcTar6

      end case

   end if

   ::oTarPreL:OrdSetFocus( nOrdAnt )

Return nPrecio

//---------------------------------------------------------------------------//

METHOD getUnidadesPedidoProveedor( cNumPed, cCodArt ) CLASS TFastVentasArticulos

   local nUnidades   := 0
   local nOrdAnt

   if empty( cNumPed )
      Return nUnidades
   end if

   if empty( cCodArt )
      Return nUnidades
   end if

   nOrdAnt           := ::oPedPrvL:OrdSetFocus( "nNumPedRef" )

   if ::oPedPrvL:Seek( cNumPed + cCodArt )
      
      nUnidades      := nTotNPedPrv( ::oPedPrvL )

   end if

   ::oPedPrvL:OrdSetFocus( nOrdAnt )

Return nUnidades

//---------------------------------------------------------------------------//

METHOD summaryReport()

   local cCodArt
   local nOrdenAnterior
   local nRecnoAcumula

   ::setMeterText( "Resumiendo informe" )
   ::setMeterTotal(  ::oDbf:ordkeyCount() )

   nOrdenAnterior       := ::oDbf:ordsetfocus( "cCodArt" )

   ::oDbf:goTop()
   while !::oDbf:eof()

      if empty( cCodArt ) .or. ( cCodArt != ::oDbf:cCodArt )
         cCodArt        := ::oDbf:cCodArt
         nRecnoAcumula  := ::oDbf:Recno()
      else
         ::acumulaDbf( nRecnoAcumula )
      end if 

      ::oDbf:skip()

      ::setMeterAutoIncremental()

   end while

   ::oDbf:ordsetfocus( nOrdenAnterior )

   ::oDbf:goTop()

   ::setMeterText( "" )
   ::setMeterTotal( 0 )

Return ( self )

//----------------------------------------------------------------------------//

METHOD acumulaDbf( nRecnoAcumula )

   local nRecnoActual   := ::oDbf:Recno()
   local nUniArt        := ::oDbf:nUniArt
   local nPreArt        := ::oDbf:nPreArt
   local nPdtRec        := ::oDbf:nPdtRec
   local nPdtEnt        := ::oDbf:nPdtEnt
   local nDtoArt        := ::oDbf:nDtoArt
   local nLinArt        := ::oDbf:nLinArt
   local nPrmArt        := ::oDbf:nPrmArt
   local nTotDto        := ::oDbf:nTotDto
   local nTotPrm        := ::oDbf:nTotPrm
   local nTrnArt        := ::oDbf:nTrnArt
   local nPntArt        := ::oDbf:nPntArt
   local nBrtArt        := ::oDbf:nBrtArt
   local nImpArt        := ::oDbf:nImpArt
   local nIvaArt        := ::oDbf:nIvaArt
   local nImpEsp        := ::oDbf:nImpEsp
   local nTotArt        := ::oDbf:nTotArt
   local nCosArt        := ::oDbf:nCosArt
   local nComAge        := ::oDbf:nComAge
   local nBultos        := ::oDbf:nBultos
   local nCajas         := ::oDbf:nCajas 
   local nPeso          := ::oDbf:nPeso  

   ::oDbf:goto( nRecnoAcumula )  

   ::oDbf:nUniArt       += nUniArt  
   ::oDbf:nPreArt       += nPreArt       
   ::oDbf:nPdtRec       += nPdtRec       
   ::oDbf:nPdtEnt       += nPdtEnt       
   ::oDbf:nDtoArt       += nDtoArt       
   ::oDbf:nLinArt       += nLinArt       
   ::oDbf:nPrmArt       += nPrmArt       
   ::oDbf:nTotDto       += nTotDto       
   ::oDbf:nTotPrm       += nTotPrm       
   ::oDbf:nTrnArt       += nTrnArt       
   ::oDbf:nPntArt       += nPntArt       
   ::oDbf:nBrtArt       += nBrtArt       
   ::oDbf:nImpArt       += nImpArt       
   ::oDbf:nIvaArt       += nIvaArt       
   ::oDbf:nImpEsp       += nImpEsp       
   ::oDbf:nTotArt       += nTotArt       
   ::oDbf:nCosArt       += nCosArt       
   ::oDbf:nComAge       += nComAge       
   ::oDbf:nBultos       += nBultos       
   ::oDbf:nCajas        += nCajas        
   ::oDbf:nPeso         += nPeso         
   
   ::oDbf:goto( nRecnoActual )  
   ::oDbf:delete()  

Return ( self )

//----------------------------------------------------------------------------//

METHOD processAllClients() CLASS TFastVentasArticulos

   if !( ::oTFastReportOptions:getOptionValue( "Incluir clientes sin ventas", .f. ) )
      Return ( self )
   end if 

   ::oDbfCli:getStatus()
   
   ::oDbfCli:OrdSetFocus( "Cod" )

   ::oDbfCli:goTop() 
   while !::oDbfCli:Eof() .and. !::lBreak

      if !( ::isClientInReport( ::oDbfCli:Cod ) )
      
      ::oDbf:Blank()
      ::oDbf:cCodCli       := ::oDbfCli:Cod
      ::oDbf:cNomCli       := ::oDbfCli:Titulo
      ::oDbf:cCodRut       := ::oDbfCli:cCodRut
      ::oDbf:cCodPago      := ::oDbfCli:CodPago
      ::oDbf:cCodAge       := ::oDbfCli:cCodAge
      ::oDbf:cCodTrn       := ::oDbfCli:cCodTrn
      ::oDbf:cCodUsr       := ::oDbfCli:cCodUsr

      ::oDbf:Insert()

      end if 

      ::oDbfCli:Skip()

   end while

   ::oDbfCli:setStatus()

Return ( self )

//---------------------------------------------------------------------------//

METHOD isClientInReport( cCodCli ) CLASS TFastVentasArticulos

RETURN ( ::oDbf:SeekInOrd( cCodCli, "cCodCli" ) )

//---------------------------------------------------------------------------//

METHOD getTotalUnidadesGrupoCliente( cCodGrp, cCodArt ) CLASS TFastVentasArticulos
   
   local nRec     := ::oDbf:Recno()
   local nOrdAnt  := ::oDbf:OrdSetFocus( "cCodArt" )
   local nTotal   := 0

   if ::oDbf:Seek( Padr( cCodArt, 18 ) ) 

      while ::oDbf:cCodArt == Padr( cCodArt, 18 ) .and. !::oDbf:Eof()

         if ::ValidGrupoCliente( cCodGrp )
            nTotal   += ::oDbf:nUniArt
         end if

         ::oDbf:Skip()

      end while

   end if

   ::oDbf:OrdSetFocus( nOrdAnt )
   ::oDbf:GoTo( nRec )

Return nTotal

//---------------------------------------------------------------------------//

METHOD getTotalCajasGrupoCliente( cCodGrp, cCodArt ) CLASS TFastVentasArticulos
   
   local nRec     := ::oDbf:Recno()
   local nOrdAnt  := ::oDbf:OrdSetFocus( "cCodArt" )
   local nTotal   := 0

   if ::oDbf:Seek( Padr( cCodArt, 18 ) ) 

      while ::oDbf:cCodArt == Padr( cCodArt, 18 ) .and. !::oDbf:Eof()

         if ::ValidGrupoCliente( cCodGrp )
            nTotal   += ::oDbf:nCajas
         end if

         ::oDbf:Skip()

      end while

   end if

   ::oDbf:OrdSetFocus( nOrdAnt )
   ::oDbf:GoTo( nRec )

Return nTotal

//---------------------------------------------------------------------------//

METHOD getUnidadesVendidas( cCodArt, cCodAlm ) CLASS TFastVentasArticulos
   
   local nRecAlb     := ::oAlbCliL:Recno()
   local nOrdAlb     := ::oAlbCliL:OrdSetFocus( "cVtaFast" )
   local nRecFac     := ::oFacCliL:Recno()
   local nOrdFac     := ::oFacCliL:OrdSetFocus( "cVtaFast" )
   local nTotal      := 0

   if ::oAlbCliL:Seek( Padr( cCodArt, 18 ) + Padr( cCodAlm, 16 ) + dtos( GetSysDate() ) )

      while ::oAlbCliL:cRef + ::oAlbCliL:cAlmLin + dtos( ::oAlbCliL:dFecAlb ) == Padr( cCodArt, 18 ) + Padr( cCodAlm, 16 ) + dtos( GetSysDate() ) .and.;
            !::oAlbCliL:Eof()

         nTotal += nTotNAlbCli( ::oAlbCliL )

         ::oAlbCliL:Skip()

      end while

   end if


   if ::oFacCliL:Seek( Padr( cCodArt, 18 ) + Padr( cCodAlm, 16 ) + dtos( GetSysDate() ) )

      while ::oFacCliL:cRef + ::oFacCliL:cAlmLin + dtos( ::oFacCliL:dFecFac ) == Padr( cCodArt, 18 ) + Padr( cCodAlm, 16 ) + dtos( GetSysDate() ) .and.;
            !::oFacCliL:Eof()

         nTotal += nTotNFacCli( ::oFacCliL )

         ::oFacCliL:Skip()

      end while

   end if

   ::oAlbCliL:GoTo( nRecAlb )
   ::oAlbCliL:OrdSetFocus( nOrdAlb )
   ::oFacCliL:GoTo( nRecFac )
   ::oFacCliL:OrdSetFocus( nOrdFac )

Return nTotal

//---------------------------------------------------------------------------//

METHOD ValidGrupoCliente( cCodGrp ) CLASS TFastVentasArticulos

   local lValid   := .f.
   local aChild   := ::oGrpCli:aChild( cCodGrp )

   aAdd( aChild, cCodGrp )

   if aScan( aChild, ::oDbf:cCodGrp ) != 0
      lValid   := .t.
   end if

Return lValid 

//---------------------------------------------------------------------------//

Function NombreTerceroCentroCoste( cTipCtr, cTerCtr, nView )

   local cNombre  := ""

   do case
      case AllTrim( cTipCtr ) == "Proveedor"
         cNombre  := RetFld( Padr( cTerCtr, 12 ), D():Proveedores( nView ) )

      case AllTrim( cTipCtr ) == "Agente"
         cNombre  := cNbrAgent( Padr( cTerCtr, 3 ), D():Agentes( nView ) )

      case AllTrim( cTipCtr ) == "Cliente"
         cNombre  := RetFld( Padr( cTerCtr, 12 ), D():Clientes( nView ) )

   end case

Return cNombre

//---------------------------------------------------------------------------//
