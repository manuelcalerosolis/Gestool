#include "FiveWin.ch"  
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"

// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastVentasArticulos FROM TFastReportInfGen 

   DATA  nSec

   DATA  cType                            INIT "Articulos"

   DATA  aTypeDocs                        INIT { "C", "N", "D", "L", "C" }

   DATA  lUnidadesNegativo                INIT .f.
   DATA  oProCab
   DATA  oProLin
   DATA  oProMat
   DATA  oHisMov
   DATA  oCtrCoste
   DATA  oOperario
   DATA  oFraPub

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

   METHOD AddSqlArticulo()
   
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
   METHOD idDocumentoLinea()              INLINE ( ::idDocumento() + Str( ::oDbf:nNumLin ) )
   METHOD idArticuloAlmacen()             INLINE ( ::oDbf:cCodArt + ::oDbf:cCodAlm )

   METHOD StockArticulo()                 INLINE ( ::oStock:nStockAlmacen( ::oDbf:cCodArt, ::oDbf:cCodAlm, ::oDbf:cValPr1, ::oDbf:cValPr2, ::oDbf:cLote, ::dIniInf, ::dFinInf ) )

   METHOD SaldoAnterior()                 INLINE ( ::oStock:nStockAlmacen( ::oDbf:cCodArt, ::oDbf:cCodAlm, ::oDbf:cValPr1, ::oDbf:cValPr2, ::oDbf:cLote, cToD( "01/01/2000" ), ::dIniInf - 1 ) )

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
                                                         ::cExpresionHeader   += ' .and. ( Field->cCodCli >= "' + ::oGrupoCliente:Cargo:getDesde() + '" .and. Field->cCodCli <= "' + ::oGrupoCliente:Cargo:getHasta() + '" )', ) )

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

   METHOD getFilterArticulo()                   INLINE ( '( alltrim( Field->Codigo ) >= "' + alltrim(::oGrupoArticulo:Cargo:getDesde()) + '" .and. alltrim( Field->Codigo ) <= "' + alltrim( ::oGrupoArticulo:Cargo:getHasta() ) + '" )' + ;
                                                         ' .and. ( alltrim( Field->Familia ) >= "' + alltrim( ::oGrupoFamilia:Cargo:getDesde() ) + '" .and.  alltrim( Field->Familia ) <= "' + alltrim( ::oGrupoFamilia:Cargo:getHasta() ) + '" )' + ;
                                                         ' .and. ( alltrim( Field->cPrvHab ) >= "' + alltrim( ::oGrupoProveedor:Cargo:getDesde() ) + '" .and.  alltrim( Field->cPrvHab ) <= "' + alltrim( ::oGrupoProveedor:Cargo:getHasta() ) + '" )' )

   METHOD getTotalUnidadesGrupoCliente( cCodGrp, cCodArt )
   METHOD getTotalCajasGrupoCliente( cCodGrp, cCodArt )
   METHOD ValidGrupoCliente( cCodGrp )
   METHOD getUnidadesVendidas

   METHOD summaryReport()
   METHOD acumulaDbf( nRecnoAcumula )

   METHOD StockActualArticulo( cCodArt )              INLINE ( ::oStock:nStockAlmacen( Padr( cCodArt, 18 ) ) )
   METHOD StockAlmacenArticulo( cCodArt, cCodAlm )    INLINE ( ::oStock:nStockAlmacen( Padr( cCodArt, 18 ), Padr( cCodAlm, 16 ) ) )

   METHOD getFieldMovimientoAlmacen( cField )

   METHOD getClave()

   METHOD getSerialiceValoresPropiedades( cCodigoPropiedad )

   METHOD getPrimerValorPropiedad( cCodigoPropiedad )

   METHOD getTotalUnidadesVendidas( cCodArt )

   METHOD getCampoExtraAlbaranCliente( cField )

END CLASS

//----------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TFastVentasArticulos

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

   ::cSubTitle       := "Informe de artículos"

   ::cTipoInforme    := "Artículos"
   ::cBmpInforme     := "gc_object_cube_64"

   if !::lTabletVersion .and. !::NewResource()
      return .f.
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

      ::cDriver         := cDriver()

      ::nView           := D():CreateView( ::cDriver )

      D():Clientes( ::nView )

      D():PresupuestosClientes( ::nView )

      D():PresupuestosClientesLineas( ::nView )

      D():PedidosClientes( ::nView )

      D():PedidosClientesLineas( ::nView )

      D():SATClientes( ::nView )

      D():SATClientesLineas( ::nView )

      D():AlbaranesClientes( ::nView )
      
      D():AlbaranesClientesLineas( ::nView )

      D():FacturasClientes( ::nView )

      D():FacturasClientesLineas( ::nView )

      D():FacturasClientesCobros( ::nView )

      D():FacturasRectificativas( ::nView )

      D():FacturasRectificativasLineas( ::nView )

      D():Tikets( ::nView )

      D():TiketsLineas( ::nView )

      D():Articulos( ::nView )

      D():PartesProduccionMaterial( ::nView )

      D():PartesProduccionMateriaPrima( ::nView )

      D():MovimientosAlmacenLineas( ::nView )

      D():PedidosProveedores( ::nView )

      D():PedidosProveedoresLineas( ::nView )

      D():AlbaranesProveedores( ::nView )

      D():AlbaranesProveedoresLineas( ::nView )

      D():FacturasProveedores( ::nView )

      D():FacturasProveedoresLineas( ::nView )

      D():FacturasRectificativasProveedores( ::nView )

      D():FacturasRectificativasProveedoresLineas( ::nView )      

      D():ArticuloImagenes( ::nView )

      D():Kit( ::nView )

      D():ArticulosCodigosBarras( ::nView )

      D():ProveedorArticulo( ::nView )

      D():ArticuloStockAlmacenes( ::nView )

      D():ClientesDirecciones( ::nView )

      D():PropiedadesLineas( ::nView )

      D():PropiedadesLineasDos( ::nView )

      D():TarifaPreciosLineas( ::nView )

      D():Atipicas( ::nView )

      ( D():Atipicas( ::nView ) )->( ordsetfocus( "cCliArt" ) )

      D():Familias( ::nView )

      D():Temporadas( ::nView )

      D():EstadoArticulo( ::nView )

      D():TiposIva( ::nView )

      D():Proveedores( ::nView )

      D():Almacen( ::nView )

      D():Usuarios( ::nView )

      D():Ruta( ::nView )

      D():Agentes( ::nView )

      D():FormasPago( ::nView )

      D():Clientes( ::nView )

      D():TiposEnvases( ::nView )

      D():objectGruposClientes( ::nView )

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
         ::oCamposExtra:setTipoDocumento( "Artículos" )
         ::aExtraFields       := ::oCamposExtra:aExtraFields()
      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de artículos" )

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

      if !empty( ::oCtrCoste )
         ::oCtrCoste:end()
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

   ::AddField( "cCodArt",     "C", 18, 0, {|| "@!" }, "Código artículo"                         )
   ::AddField( "cNomArt",     "C",100, 0, {|| ""   }, "Nombre artículo"                         )

   ::AddField( "cCodFam",     "C", 16, 0, {|| "@!" }, "Código familia"                          )
   ::AddField( "cNomFam",     "C", 40, 0, {|| "@!" }, "Nombre familia"                          )
   ::AddField( "cGrpFam",     "C",  3, 0, {|| "@!" }, "Código grupo de familia"                 )
   ::AddField( "TipoIva",     "C",  1, 0, {|| "@!" }, "Código del tipo de " + cImp()            )
   ::AddField( "cCodTip",     "C",  4, 0, {|| "@!" }, "Código del tipo de artículo"             )
   ::AddField( "cCodEst",     "C",  3, 0, {|| "@!" }, "Código estado artículo"                  )
   ::AddField( "cCodTemp",    "C", 10, 0, {|| "@!" }, "Código temporada"                        )
   ::AddField( "cCodFab",     "C",  3, 0, {|| "@!" }, "Código fabricante"                       )
   ::AddField( "cCodGrp",     "C", 12, 0, {|| "@!" }, "Código grupo de cliente"                 )
   ::AddField( "cCodAlm",     "C", 16, 0, {|| "@!" }, "Código del almacén"                      )
   ::AddField( "cAlmOrg",     "C", 16, 0, {|| "@!" }, "Almacén origen"                          )
   ::AddField( "cCodPago",    "C",  2, 0, {|| "@!" }, "Código de la forma de pago"              )
   ::AddField( "cCodRut",     "C", 12, 0, {|| "@!" }, "Código de la ruta"                       )
   ::AddField( "cCodAge",     "C", 12, 0, {|| "@!" }, "Código del agente"                       )
   ::AddField( "cCodTrn",     "C", 12, 0, {|| "@!" }, "Código del transportista"                )
   ::AddField( "cCodUsr",     "C",  3, 0, {|| "@!" }, "Código usuario"                          )
   ::AddField( "cCodOpe",     "C",  5, 0, {|| "@!" }, "Código operario"                         )
   ::AddField( "cCodEnv",     "C",  3, 0, {|| "@!" }, "Código tipo de envase"                   )
   ::AddField( "cCodCaj",     "C",  3, 0, {|| "@!" }, "Código caja"                             )
   ::AddField( "cCodCate",    "C", 10, 0, {|| "@!" }, "Código categoría"                        )

   ::AddField( "cCodCli",     "C", 12, 0, {|| "@!" }, "Código cliente/proveedor"                )
   ::AddField( "cNomCli",     "C", 80, 0, {|| "@!" }, "Nombre cliente/proveedor"                )
   ::AddField( "cPobCli",     "C", 35, 0, {|| "@!" }, "Población cliente/proveedor"             )
   ::AddField( "cPrvCli",     "C", 20, 0, {|| "@!" }, "Provincia cliente/proveedor"             )
   ::AddField( "cPosCli",     "C", 15, 0, {|| "@!" }, "Código postal cliente/proveedor"         )
   ::AddField( "cCodObr",     "C", 10, 0, {|| "@!" }, "Código de la dirección"                  )

   ::AddField( "nUniArt",     "N", 16, 6, {|| "" },   "Unidades artículo"                       )
   ::AddField( "nPreArt",     "N", 16, 6, {|| "" },   "Precio unitario artículo"                ) 

   ::AddField( "nPdtRec",     "N", 16, 6, {|| "" },   "Unidades pendientes de recibir"          )
   ::AddField( "nPdtEnt",     "N", 16, 6, {|| "" },   "Unidades pendientes de entregar"         )
   ::AddField( "nEntreg",     "N", 16, 6, {|| "" },   "Unidades entregadas"                     )
   ::AddField( "nRecibi",     "N", 16, 6, {|| "" },   "Unidades recibidas"                      )

   ::AddField( "nDtoArt",     "N",  6, 2, {|| "" },   "Descuento porcentual artículo"           ) 
   ::AddField( "nLinArt",     "N", 16, 6, {|| "" },   "Descuento lineal artículo"               ) 
   ::AddField( "nPrmArt",     "N",  6, 2, {|| "" },   "Descuento promocional artículo"          )

   ::AddField( "nTotDto",     "N", 16, 6, {|| "" },   "Total descuento porcentual artículo"     ) 
   ::AddField( "nTotPrm",     "N", 16, 6, {|| "" },   "Total descuento promocional artículo"    )

   ::AddField( "nTrnArt",     "N", 16, 6, {|| "" },   "Total transporte artículo"               ) 
   ::AddField( "nPntArt",     "N", 16, 6, {|| "" },   "Total punto verde artículo"              ) 
   
   ::AddField( "nBrtArt",     "N", 16, 6, {|| "" },   "Total importe bruto artículo"            )
   ::AddField( "nImpArt",     "N", 16, 6, {|| "" },   "Total importe artículo"                  )
   ::AddField( "nIvaArt",     "N", 16, 6, {|| "" },   "Total " + cImp() + " artículo"           )
   ::AddField( "nImpEsp",     "N", 16, 6, {|| "" },   "Total impuesto especial artículo"        )
   ::AddField( "nTotArt",     "N", 16, 6, {|| "" },   "Total importe artículo " + cImp() + " incluido" )
   ::AddField( "nCosArt",     "N", 16, 6, {|| "" },   "Total costo artículo"                    )
   ::AddField( "nPctAge",     "N",  6, 2, {|| "" },   "Porcentaje agente"                       )
   ::AddField( "nComAge",     "N", 16, 6, {|| "" },   "Comision agente"                         )
   ::AddField( "nIva",        "N",  6, 2, {|| "" },   "Porcentaje " + cImp()                    )

   ::AddField( "cCodPr1",     "C", 20, 0, {|| "" },   "Código de la primera propiedad"          )
   ::AddField( "cCodPr2",     "C", 20, 0, {|| "" },   "Código de la segunda propiedad"          )
   ::AddField( "cValPr1",     "C", 20, 0, {|| "" },   "Valor de la primera propiedad"           )
   ::AddField( "cValPr2",     "C", 20, 0, {|| "" },   "Valor de la segunda propiedad"           )

   ::AddField( "cLote",       "C", 14, 0, {|| "" },   "Número de lote"                          )
   ::AddField( "dFecCad",     "D",  8, 0, {|| "" },   "Fecha de caducidad"                      )

   ::AddField( "cNumSer",     "C", 30, 0, {|| "" },   "Número de serie"                         )

   ::AddField( "cClsDoc",     "C",  2, 0, {|| "" },   "Clase de documento"                      )
   ::AddField( "cTipDoc",     "C", 30, 0, {|| "" },   "Tipo de documento"                       )
   ::AddField( "cIdeDoc",     "C", 27, 0, {|| "" },   "Identificador del documento"             )
   ::AddField( "nNumLin",     "N",  4, 0, {|| "" },   "Número de línea"                         )

   ::AddField( "cSerDoc",     "C",  1, 0, {|| "" },   "Serie del documento"                     )
   ::AddField( "cNumDoc",     "C", 10, 0, {|| "" },   "Número del documento"                    )
   ::AddField( "cSufDoc",     "C",  2, 0, {|| "" },   "Delegación del documento"                )

   ::AddField( "nAnoDoc",     "N",  4, 0, {|| "" },   "Año del documento"                       )
   ::AddField( "nMesDoc",     "N",  2, 0, {|| "" },   "Mes del documento"                       )
   ::AddField( "dFecDoc",     "D",  8, 0, {|| "" },   "Fecha del documento"                     )
   ::AddField( "cHorDoc",     "C",  2, 0, {|| "" },   "Hora del documento"                      )
   ::AddField( "cMinDoc",     "C",  2, 0, {|| "" },   "Minutos del documento"                   )

   ::AddField( "cCodPrv",     "C", 12, 0, {|| "@!" }, "Código proveedor lineas"                 )
   ::AddField( "cNomPrv",     "C", 80, 0, {|| "@!" }, "Nombre proveedor lineas"                 )

   ::AddField( "nBultos",     "N", 16, 0, {|| "" },   "Numero de bultos en líneas"              )
   ::AddField( "cFormato",    "C",100, 0, {|| "" },   "Formato de compra/venta en líneas"       )
   ::AddField( "nCajas",      "N", 16, 6, {|| "" },   "Cajas en líneas"                         )
   ::AddField( "nPeso",       "N", 16, 6, {|| "" },   "Peso en líneas"                          )

   ::AddField( "lKitArt",     "L",  1, 0, {|| "" },   "Línea con escandallos"                   )
   ::AddField( "lKitChl",     "L",  1, 0, {|| "" },   "Línea perteneciente a escandallo"        )

   ::AddField( "cPrvHab",     "C", 12, 0, {|| "" },   "Proveedor habitual"                      )

   ::AddField( "cCtrCoste",   "C",  9, 0, {|| "" },   "Código del centro de coste"              )
   ::AddField( "cTipCtr",     "C", 20, 0, {|| "" },   "Tipo tercero centro de coste"            )
   ::AddField( "cCodTerCtr",  "C", 20, 0, {|| "" },   "Código tercero centro de coste"          )
   ::AddField( "cNomTerCtr",  "C",100, 0, {|| "" },   "Nombre tercero centro de coste"          )

   ::AddField( "cDesUbi",     "C",200, 0, {|| "" },   "Unicación del artículo"                  )
   ::AddField( "cEstado",     "C", 20, 0, {|| "" },   "Estado del documento"                    )

   ::AddField( "cSituacion",  "C",200, 0, {|| "" },   "Situación del documento"                 )

   ::AddField( "nCargo",      "N", 16, 6, {|| "" },   "Cargo numerico"                          )
   ::AddField( "cCargo",      "C",200, 0, {|| "" },   "Cargo texto"                             )

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

         ::AddField( "fld" + cField[ "código" ],;
                     ::aTypeDocs[ cField[ "tipo" ] ] ,;
                     cField[ "longitud" ],;
                     cField[ "decimales" ],;
                     {|| ::oCamposExtra:cPictData( cField ) },;
                     Capitalize( cField[ "descripción" ] ) )

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
                     "Partes de producción" => ;
                        {  "Generate" =>  {||   ::AddProducido(),;
                                                ::AddConsumido() },;
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
                                                ::AddProducido(),;
                                                ::AddMovimientoAlmacen() },;
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
                           "Data" =>      {||   ::FastReportStock() } },;
                     "Stocks por articulo y almacén" => ;
                        {  "Generate" =>  {||   ::AddSqlArticulo() },;
                           "Variable" =>  {||   ::AddVariableStock() },;
                           "Data" =>      {||   ::FastReportStock() } } }

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

   if !empty( ::oGrupoEstadoArticulo ) .and. !( ::oDbf:cCodEst >= ::oGrupoEstadoArticulo:Cargo:getDesde()   .and. ::oDbf:cCodEst    <= ::oGrupoEstadoArticulo:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoTemporada ) .and. !( ::oDbf:cCodTemp     >= ::oGrupoTemporada:Cargo:getDesde()        .and. ::oDbf:cCodTemp   <= ::oGrupoTemporada:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoCategoria ) .and. !( ::oDbf:cCodCate     >= ::oGrupoCategoria:Cargo:getDesde()        .and. ::oDbf:cCodCate   <= ::oGrupoCategoria:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoFabricante ) .and. !( ::oDbf:cCodFab     >= ::oGrupoFabricante:Cargo:getDesde()       .and. ::oDbf:cCodFab    <= ::oGrupoFabricante:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoCliente ) .and. !( ::oDbf:cCodCli        >= rTrim( ::oGrupoCliente:Cargo:getDesde() ) .and. ::oDbf:cCodCli    <= rTrim( ::oGrupoCliente:Cargo:getHasta() ) )
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

   if !empty( ::oGrupoProveedor ) .and. !( ::oDbf:cPrvHab      >= ::oGrupoProveedor:Cargo:getDesde()        .and. ::oDbf:cPrvHab    <= ::oGrupoProveedor:Cargo:getHasta() )
      Return .f.
   end if

   if !empty( ::oGrupoAlmacen ) .and. !( ( ::oDbf:cCodAlm >= ::oGrupoAlmacen:Cargo:getDesde() .and. ::oDbf:cCodAlm <= ::oGrupoAlmacen:Cargo:getHasta() ) .or. ( ::oDbf:cAlmOrg >= ::oGrupoAlmacen:Cargo:getDesde() .and. ::oDbf:cAlmOrg <= ::oGrupoAlmacen:Cargo:getHasta() ) )
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
                  {  "Title" => "Compras/Ventas/Producción",      "Image" => 24, "Type" => "Todos los movimientos",        "Directory" => "Articulos\Movimientos",                        "File" => "Todos los movimientos.fr3"  },;
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
                  { "Title" => "Producción",                      "Image" => 14, "Type" => "Partes de producción",         "Directory" => "Articulos\Producción",     "File" => "Partes de producción.fr3" },;
                  {  "Title" => "Compras",                        "Image" => 12, "Subnode" =>;
                  { ;
                     { "Title" => "Pedidos de proveedores",       "Image" => 2, "Type" => "Pedidos de proveedores",        "Directory" => "Articulos\Compras\Pedidos de proveedores",        "File" => "Pedidos de proveedores.fr3" },;
                     { "Title" => "Albaranes de proveedores",     "Image" => 3, "Type" => "Albaranes de proveedores",      "Directory" => "Articulos\Compras\Albaranes de proveedores",      "File" => "Albaranes de proveedores.fr3" },;
                     { "Title" => "Facturas de proveedores",      "Image" => 4, "Type" => "Facturas de proveedores",       "Directory" => "Articulos\Compras\Facturas de proveedores",       "File" => "Facturas de proveedores.fr3" },;
                     { "Title" => "Rectificativas de proveedores","Image" =>15, "Type" => "Rectificativas de proveedores", "Directory" => "Articulos\Compras\Rectificativas de proveedores", "File" => "Rectificativas de proveedores.fr3" },;
                     { "Title" => "Compras",                      "Image" =>12, "Type" => "Compras",                       "Directory" => "Articulos\Compras\Compras",                       "File" => "Compras.fr3" },;
                  } ;
                  },;                  
                  { "Title" => "Movimientos almacén",             "Image" => 25, "Type" => "Movimientosalmacen",           "Directory" => "Articulos\MovimientosAlmacen",                    "File" => "Movimientos.fr3" },;
                  {  "Title" => "Existencias",                    "Image" => 16, "Subnode" =>;
                  { ;
                     { "Title"      => "Stocks",                  "Image" => 16, "Type" => "Stocks",                       "Directory" => "Articulos\Existencias\Stocks",                    "File" => "Existencias por stock.fr3" },;
                     { "Title"      => "Stocks por articulo y almacén",;
                       "Image"      => 16,;
                       "Type"       => "Stocks por articulo y almacén",;
                       "Directory"  => "Articulos\Existencias\StocksLotes",;
                       "File"       => "Existencias por stock.fr3",;
                       "Options"    => {  "Excluir unidades a cero"      => { "Options"   => .t.,;
                                                                              "Value"     => .t. },;
                                          "Excluir artículos obsoletos"  => { "Options"   => .t.,;
                                                                              "Value"     => .t. } } },;
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

   ::oFastReport:SetWorkArea(       "Empresa",                       ::oDbfEmp:nArea )
   ::oFastReport:SetFieldAliases(   "Empresa",                       cItemsToReport( aItmEmp() ) )

   ::oFastReport:SetWorkArea(       "Artículos.Informe",             ( D():Articulos( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Artículos.Informe",             cItemsToReport( aItmArt() ) )

   ::oFastReport:SetWorkArea(       "Artículos.Escandallos",         ( D():Articulos( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Artículos.Escandallos",         cItemsToReport( aItmArt() ) )

   ::oFastReport:SetWorkArea(       "Imagenes",                      ( D():ArticuloImagenes( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Imagenes",                      cItemsToReport( aItmImg() ) )

   ::oFastReport:SetWorkArea(       "Códigos de barras",             ( D():ArticulosCodigosBarras( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Códigos de barras",             cItemsToReport( aItmBar() ) )

   ::oFastReport:SetWorkArea(       "Escandallos",                   ( D():Kit( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Escandallos",                   cItemsToReport( aItmKit() ) )

   ::oFastReport:SetWorkArea(       "Familias",                      ( D():Familias( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Familias",                      cItemsToReport( aItmFam() ) )

   ::oFastReport:SetWorkArea(       "Tipo artículos",                ( D():ArticuloTipos( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Tipo artículos",                cObjectsToReport( TTipArt():DefineFiles( cPatArt(), cDriver() ) ) )

   ::oFastReport:SetWorkArea(       "Grupos familias",               ::oGruFam:Select() )
   ::oFastReport:SetFieldAliases(   "Grupos familias",               cObjectsToReport( ::oGruFam:oDbf ) )

   ::oFastReport:SetWorkArea(       "Temporadas",                    ( D():Temporadas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Temporadas",                    cItemsToReport( aItmTemporada() ) )

   ::oFastReport:SetWorkArea(       "Categorías",                    ( D():Categorias( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Categorías",                    cItemsToReport( aItmCategoria() ) )

   ::oFastReport:SetWorkArea(       "Fabricantes",                   ::oDbfFab:Select() )
   ::oFastReport:SetFieldAliases(   "Fabricantes",                   cObjectsToReport( ::oDbfFab:oDbf ) )

   ::oFastReport:SetWorkArea(       "Estado artículo",               ( D():EstadoArticulo( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Estado artículo",               cItemsToReport( aItmEstadoSat() ) )

   ::oFastReport:SetWorkArea(       "Tipos de " + cImp(),            ( D():TiposIva( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Tipos de " + cImp(),            cItemsToReport( aItmTIva() ) )

   ::oFastReport:SetWorkArea(       "Clientes",                      ( D(): Clientes( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Clientes",                      cItemsToReport( aItmCli() ) )

   ::oFastReport:SetWorkArea(       "Proveedores",                   ( D():Proveedores( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Proveedores",                   cItemsToReport( aItmPrv() ) )

   ::oFastReport:SetWorkArea(       "Proveedores habituales",        ( D():Proveedores( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Proveedores habituales",        cItemsToReport( aItmPrv() ) )

   ::oFastReport:SetWorkArea(       "Almacenes",                     ( D():Almacen( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Almacenes",                     cItemsToReport( aItmAlm() ) )

   ::oFastReport:SetWorkArea(       "Usuarios",                      ( D():Usuarios( ::nView ) )->( select() ) ) 
   ::oFastReport:SetFieldAliases(   "Usuarios",                      cItemsToReport( aItmUsuario() ) )

   ::oFastReport:SetWorkArea(       "Stock por almacén",             ( D():ArticuloStockAlmacenes( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Stock por almacén",             cItemsToReport( aItmStockaAlmacenes() ) )

   ::oFastReport:SetWorkArea(       "Centro de coste",               ::oCtrCoste:Select() )
   ::oFastReport:SetFieldAliases(   "Centro de coste",               cObjectsToReport( ::oCtrCoste:oDbf ) )

   ::oFastReport:SetWorkArea(       "Direcciones",                   ( D():ClientesDirecciones( ::nView ) )->( select() ) ) 
   ::oFastReport:SetFieldAliases(   "Direcciones",                   cItemsToReport( aItmObr() ) )

   ::oFastReport:SetWorkArea(       "Rutas",                         ( D():Ruta( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Rutas",                         cItemsToReport( aItmRut() ) )

   ::oFastReport:SetWorkArea(       "Propiedades 1",                 ( D():PropiedadesLineas( ::nView ) )->( select() ) ) 
   ::oFastReport:SetFieldAliases(   "Propiedades 1",                 cItemsToReport( aItmPro() ) )

   ::oFastReport:SetWorkArea(       "Propiedades 2",                 ( D():PropiedadesLineasDos( ::nView ) )->( select() ) ) 
   ::oFastReport:SetFieldAliases(   "Propiedades 2",                 cItemsToReport( aItmPro() ) )

   ::oFastReport:SetWorkArea(       "Codificación de proveedores",   ( D():ProveedorArticulo( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Codificación de proveedores",   cItemsToReport( aItmArtPrv() ) )

   ::oFastReport:SetWorkArea(       "Operario",                      ::oOperario:Select() )
   ::oFastReport:SetFieldAliases(   "Operario",                      cObjectsToReport( ::oOperario:oDbf ) )

   ::oFastReport:SetWorkArea(       "Grupo clientes",                D():objectGruposClientes( ::nView ):Select() )
   ::oFastReport:SetFieldAliases(   "Grupo clientes",                cObjectsToReport( D():objectGruposClientes( ::nView ):oDbf ) )

   ::oFastReport:SetWorkArea(       "Agentes",                       ( D():Agentes( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Agentes",                       cItemsToReport( aItmAge() ) )

   ::oFastReport:SetWorkArea(       "Atipicas de clientes",          ( D():Atipicas( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Atipicas de clientes",          cItemsToReport( aItmAtp() ) )

   ::oFastReport:SetWorkArea(       "Tipo envases",                  ( D():TiposEnvases( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Tipo envases",                  cObjectsToReport( TFrasesPublicitarias():DefineFiles( cPatArt(), cDriver() ) ) )

   ::oFastReport:SetWorkArea(       "Transportistas",                ::oDbfTrn:Select() )
   ::oFastReport:SetFieldAliases(   "Transportistas",                cObjectsToReport( ::oDbfTrn:oDbf ) )

   ::oFastReport:SetWorkArea(       "Formas de pago",                ( D():FormasPago( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Formas de pago",                cItemsToReport( aItmFPago() ) )

   // Relaciones entre tablas-----------------------------------------------------

   ::oFastReport:SetMasterDetail(   "Artículos.Informe", "Familias",                {|| ( D():Articulos( ::nView ) )->Familia } )
   ::oFastReport:SetMasterDetail(   "Artículos.Informe", "Tipo artículos",          {|| ( D():Articulos( ::nView ) )->cCodTip } )
   ::oFastReport:SetMasterDetail(   "Artículos.Informe", "Temporadas",              {|| ( D():Articulos( ::nView ) )->cCodTemp } )
   ::oFastReport:SetMasterDetail(   "Artículos.Informe", "Categorías",              {|| ( D():Articulos( ::nView ) )->cCodCate } )
   ::oFastReport:SetMasterDetail(   "Artículos.Informe", "Fabricantes",             {|| ( D():Articulos( ::nView ) )->cCodFab } )
   ::oFastReport:SetMasterDetail(   "Artículos.Informe", "Tipos de " + cImp(),      {|| ( D():Articulos( ::nView ) )->TipoIva } )

   ::oFastReport:SetMasterDetail(   "Escandallos", "Artículos.Escandallos",         {|| ( D():Kit( ::nView ) )->cRefKit } )
   
   ::oFastReport:SetMasterDetail(   "Codificación de proveedores", "Proveedores habituales",   {|| ( D():ProveedorArticulo( ::nView ) )->cCodPrv } )
   
   ::oFastReport:SetMasterDetail(   "Informe", "Empresa",                           {|| cCodEmp() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Clientes",                          {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Grupo clientes",                    {|| ::oDbf:cCodGrp } )
   ::oFastReport:SetMasterDetail(   "Informe", "Formas de pago",                    {|| ::oDbf:cCodPago } )
   
   ::oFastReport:SetMasterDetail(   "Informe", "Proveedores",                       {|| ::oDbf:cPrvHab } )
   ::oFastReport:SetMasterDetail(   "Informe", "Usuarios",                          {|| ::oDbf:cCodUsr } )
   ::oFastReport:SetMasterDetail(   "Informe", "Almacenes",                         {|| ::oDbf:cCodAlm } )
   ::oFastReport:SetMasterDetail(   "Informe", "Direcciones",                       {|| ::oDbf:cCodCli + ::oDbf:cCodObr } )
   ::oFastReport:SetMasterDetail(   "Informe", "Rutas",                             {|| ::oDbf:cCodRut } )
   ::oFastReport:SetMasterDetail(   "Informe", "Estado artículo",                   {|| ::oDbf:cCodEst } )
   ::oFastReport:SetMasterDetail(   "Informe", "Operario",                          {|| ::oDbf:cCodOpe } )
   ::oFastReport:SetMasterDetail(   "Informe", "Grupos familias",                   {|| ::oDbf:cGrpFam } )
   ::oFastReport:SetMasterDetail(   "Informe", "Agentes",                           {|| ::oDbf:cCodAge } )
   ::oFastReport:SetMasterDetail(   "Informe", "Tipo envases",                      {|| ::oDbf:cCodEnv } )
   ::oFastReport:SetMasterDetail(   "Informe", "Transportistas",                    {|| ::oDbf:cCodTrn } )

   ::oFastReport:SetMasterDetail(   "Informe", "Atipicas de clientes",              {|| ::oDbf:cCodCli + ::oDbf:cCodArt } )

   ::oFastReport:SetMasterDetail(   "Informe", "Artículos.Informe",                 {|| ::oDbf:cCodArt } )  
   ::oFastReport:SetMasterDetail(   "Informe", "Imagenes",                          {|| ::oDbf:cCodArt } )
   ::oFastReport:SetMasterDetail(   "Informe", "Escandallos",                       {|| ::oDbf:cCodArt } )
   ::oFastReport:SetMasterDetail(   "Informe", "Códigos de barras",                 {|| ::oDbf:cCodArt } )
   ::oFastReport:SetMasterDetail(   "Informe", "Codificación de proveedores",       {|| ::oDbf:cCodArt } )

   ::oFastReport:SetMasterDetail(   "Informe", "Stock por almacén",                 {|| ::oDbf:cCodArt + ::oDbf:cCodAlm } )
   ::oFastReport:SetMasterDetail(   "Informe", "Centro de coste",                   {|| ::oDbf:cCtrCoste } )   

   ::oFastReport:SetMasterDetail(   "Informe", "Propiedades 1",                     {|| ::oDbf:cCodPr1 + ::oDbf:cValPr1 } )   
   ::oFastReport:SetMasterDetail(   "Informe", "Propiedades 2",                     {|| ::oDbf:cCodPr2 + ::oDbf:cValPr2 } )   


   // Resincronizar con los movimientos-------------------------------------------

   ::oFastReport:SetResyncPair(     "Artículos.Informe", "Familias" )
   ::oFastReport:SetResyncPair(     "Artículos.Informe", "Tipo artículos" )
   ::oFastReport:SetResyncPair(     "Artículos.Informe", "Temporadas" )
   ::oFastReport:SetResyncPair(     "Artículos.Informe", "Categorías" )
   ::oFastReport:SetResyncPair(     "Artículos.Informe", "Fabricantes" )
   ::oFastReport:SetResyncPair(     "Artículos.Informe", "Tipos de " + cImp() )
   
   ::oFastReport:SetResyncPair(     "Escandallos", "Artículos.Escandallos" )
   
   ::oFastReport:SetResyncPair(     "Codificación de proveedores", "Proveedores habituales" )   

   ::oFastReport:SetResyncPair(     "Informe", "Clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Grupo clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Proveedores" )
   ::oFastReport:SetResyncPair(     "Informe", "Formas de pago" )
   ::oFastReport:SetResyncPair(     "Informe", "Empresa" )
   ::oFastReport:SetResyncPair(     "Informe", "Usuarios" )
   ::oFastReport:SetResyncPair(     "Informe", "Almacenes" )
   ::oFastReport:SetResyncPair(     "Informe", "Direcciones" )
   ::oFastReport:SetResyncPair(     "Informe", "Rutas" )
   ::oFastReport:SetResyncPair(     "Informe", "Codificación de proveedores" )
   ::oFastReport:SetResyncPair(     "Informe", "Estado artículo" )
   ::oFastReport:SetResyncPair(     "Informe", "Operario" )
   ::oFastReport:SetResyncPair(     "Informe", "Grupos familias" )
   ::oFastReport:SetResyncPair(     "Informe", "Agentes" )
   ::oFastReport:SetResyncPair(     "Informe", "Tipo envases" )
   ::oFastReport:SetResyncPair(     "Informe", "Transportistas" )

   ::oFastReport:SetResyncPair(     "Informe", "Artículos.Informe" )
   ::oFastReport:SetResyncPair(     "Informe", "Imagenes" )
   ::oFastReport:SetResyncPair(     "Informe", "Escandallos" )
   ::oFastReport:SetResyncPair(     "Informe", "Códigos de barras" )
   ::oFastReport:SetResyncPair(     "Informe", "Stock por almacén" )  
   ::oFastReport:SetResyncPair(     "Informe", "Centro de coste" ) 

   ::oFastReport:SetResyncPair(     "Informe", "Atipicas de clientes" )

   ::oFastReport:SetResyncPair(     "Informe", "Propiedades 1" )   
   ::oFastReport:SetResyncPair(     "Informe", "Propiedades 2" )   

   ::SetDataReport()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD loadPropiedadesArticulos( cCodigoArticulo )

   if ( ( D():Articulos( ::nView ) ) )->( dbseek( cCodigoArticulo ) )
      ::oDbf:cCodTip    := ( ( D():Articulos( ::nView ) ) )->cCodTip
      ::oDbf:cCodEst    := ( ( D():Articulos( ::nView ) ) )->cCodEst
      ::oDbf:cCodTemp   := ( ( D():Articulos( ::nView ) ) )->cCodTemp
      ::oDbf:cCodFab    := ( ( D():Articulos( ::nView ) ) )->cCodFab
      ::oDbf:cCodCate   := ( ( D():Articulos( ::nView ) ) )->cCodCate
      ::oDbf:cDesUbi    := ( ( D():Articulos( ::nView ) ) )->cDesUbi
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddSATClientes() CLASS TFastVentasArticulos

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

   // filtros para las líneas-------------------------------------------------

   ::cExpresionLine           := '!lTotLin .and. !lControl'
   ::cExpresionLine           += ' .and. ( Field->cSerSat >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerSat <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine           += ' .and. ( Field->nNumSat >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )   + '" ) .and. Field->nNumSat <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine           += ' .and. ( Field->cSufSat >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufSat <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterProductIdLine()

   ::setFilterStoreLine()

   ::setFilterFamily() 

   ::setFilterGroupFamily() 

   // procesamos los SAT ---------------------------------------------

   ::setMeterText( "Procesando SAT" )

   ( D():SATClientes( ::nView )        )->( ordsetfocus( "nNumSat" ) )
   ( D():SATClientesLineas( ::nView )  )->( ordsetfocus( "nNumSat" ) )

   ( D():SATClientes( ::nView )        )->( setCustomFilter( ::cExpresionHeader ) )
   ( D():SATClientesLineas( ::nView )  )->( setCustomFilter( ::cExpresionLine ) )

   ::setMeterTotal( ( D():SATClientes( ::nView ) )->( dbcustomkeycount() ) )

   // Lineas de Sat---------------------------------------------------------------

   ( D():SATClientesLineas( ::nView ) )->( dbgotop() )
   while !::lBreak .and. !( D():SATClientesLineas( ::nView ) )->( eof() )

      if ( D():SATClientes( ::nView ) )->( dbseek( D():SATClientesLineasId( ::nView ) ) )

         ::oDbf:Blank()

         ::oDbf:cClsDoc    := SAT_CLI
         ::oDbf:cTipDoc    := "SAT cliente"
         ::oDbf:cSerDoc    := ( D():SATClientesLineas( ::nView ) )->cSerSat
         ::oDbf:cNumDoc    := str( ( D():SATClientesLineas( ::nView ) )->nNumSat )
         ::oDbf:cSufDoc    := ( D():SATClientesLineas( ::nView ) )->cSufSat

         ::oDbf:cIdeDoc    := ::idDocumento()

         ::oDbf:nNumLin    := ( D():SATClientesLineas( ::nView ) )->nNumLin
         ::oDbf:cCodArt    := ( D():SATClientesLineas( ::nView ) )->cRef
         ::oDbf:cNomArt    := ( D():SATClientesLineas( ::nView ) )->cDetalle

         ::oDbf:cCodPr1    := ( D():SATClientesLineas( ::nView ) )->cCodPr1
         ::oDbf:cCodPr2    := ( D():SATClientesLineas( ::nView ) )->cCodPr2
         ::oDbf:cValPr1    := ( D():SATClientesLineas( ::nView ) )->cValPr1
         ::oDbf:cValPr2    := ( D():SATClientesLineas( ::nView ) )->cValPr2

         ::oDbf:cLote      := ( D():SATClientesLineas( ::nView ) )->cLote

         ::oDbf:nIva       := ( D():SATClientesLineas( ::nView ) )->nIva

         ::oDbf:cCodPrv    := ( D():SATClientesLineas( ::nView ) )->cCodPrv
         ::oDbf:cNomPrv    := RetFld( ( D():SATClientesLineas( ::nView ) )->cCodPrv, D():Proveedores( ::nView ) )

         ::oDbf:TipoIva    := cCodigoIva( D():TiposIva( ::nView ), ( D():SATClientesLineas( ::nView ) )->nIva )

         ::oDbf:cCodObr    := ( D():SATClientesLineas( ::nView ) )->cObrLin

         ::oDbf:cCodFam    := ( D():SATClientesLineas( ::nView ) )->cCodFam
         ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )

         ::oDbf:cGrpFam    := ( D():SATClientesLineas( ::nView ) )->cGrpFam
         ::oDbf:cCodAlm    := ( D():SATClientesLineas( ::nView ) )->cAlmLin
         ::oDbf:cDesUbi    := RetFld( ( D():SATClientesLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cDesUbi", "Codigo" )

         ::oDbf:nDtoArt    := ( D():SATClientesLineas( ::nView ) )->nDto
         ::oDbf:nLinArt    := ( D():SATClientesLineas( ::nView ) )->nDtoDiv
         ::oDbf:nPrmArt    := ( D():SATClientesLineas( ::nView ) )->nDtoPrm

         ::oDbf:cCodTip    := ( D():SATClientesLineas( ::nView ) )->cCodTip

         ::oDbf:nCosArt    := nTotCSATCli( D():SATClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nUniArt    := nTotNSATCli( D():SATClientesLineas( ::nView ) ) 

         ::oDbf:cCtrCoste  := ( D():SATClientesLineas( ::nView ) )->cCtrCoste
         ::oDbf:cTipCtr    := ( D():SATClientesLineas( ::nView ) )->cTipCtr
         ::oDbf:cCodTerCtr := ( D():SATClientesLineas( ::nView ) )->cTerCtr
         ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ( D():SATClientesLineas( ::nView ) )->cTipCtr, ( D():SATClientesLineas( ::nView ) )->cTerCtr, ::nView )

         ::loadPropiedadesArticulos( ( D():SATClientesLineas( ::nView ) )->cRef )

         ::oDbf:nAnoDoc    := Year( ( D():SATClientes( ::nView ) )->dFecSat )
         ::oDbf:nMesDoc    := Month( ( D():SATClientes( ::nView ) )->dFecSat )
         ::oDbf:dFecDoc    := ( D():SATClientes( ::nView ) )->dFecSat
         
         ::oDbf:cHorDoc    := SubStr( ( D():SATClientes( ::nView ) )->cTimCre, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ( D():SATClientes( ::nView ) )->cTimCre, 4, 2 )

         ::oDbf:cCodGrp    := RetFld( ( D():SATClientes( ::nView ) )->cCodCli, ( D():Clientes( ::nView ) ), "cCodGrp", "Cod" ) 

         ::oDbf:cCodPago   := ( D():SATClientes( ::nView ) )->cCodPgo
         ::oDbf:cCodRut    := ( D():SATClientes( ::nView ) )->cCodRut
         ::oDbf:cCodAge    := ( D():SATClientes( ::nView ) )->cCodAge
         ::oDbf:cCodTrn    := ( D():SATClientes( ::nView ) )->cCodTrn
         ::oDbf:cCodUsr    := ( D():SATClientes( ::nView ) )->cCodUsr
         ::oDbf:cCodCli    := ( D():SATClientes( ::nView ) )->cCodCli
         ::oDbf:cNomCli    := ( D():SATClientes( ::nView ) )->cNomCli
         ::oDbf:cPobCli    := ( D():SATClientes( ::nView ) )->cPobCli
         ::oDbf:cPrvCli    := ( D():SATClientes( ::nView ) )->cPrvCli
         ::oDbf:cPosCli    := ( D():SATClientes( ::nView ) )->cPosCli

         if ( D():Atipicas( ::nView ) )->( dbseek( ( D():SATClientes( ::nView ) )->cCodCli + ( D():SATClientesLineas( ::nView ) )->cRef ) ) .and. !empty( ( D():Atipicas( ::nView ) )->cCodEnv )
            ::oDbf:cCodEnv := ( D():Atipicas( ::nView ) )->cCodEnv
         else
            ::oDbf:cCodEnv := RetFld( ( D():SATClientesLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )                    
         end if

         ::oDbf:nTotDto    := nDtoLSATCli( D():SATClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nTotPrm    := nPrmLSATCli( D():SATClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nPreArt    := nImpUSATCli( D():SATClientesLineas( ::nView ), ::nDecOut, ::nValDiv )
         ::oDbf:nTrnArt    := nTrnUSATCli( D():SATClientesLineas( ::nView ), ::nDecOut, ::nValDiv )
         ::oDbf:nPntArt    := nPntLSATCli( D():SATClientesLineas( ::nView ), ::nDecOut, ::nValDiv )

         ::oDbf:nBrtArt    := nBrtLSATCli( D():SATClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nImpArt    := nImpLSATCli( D():SATClientes( ::nView ), D():SATClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nIvaArt    := nIvaLSATCli( D():SATClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nImpEsp    := nTotISATCli( D():SATClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nTotArt    := nImpLSATCli( D():SATClientes( ::nView ), D():SATClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLSATCli( D():SATClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nPeso      := nPesLSATCli( D():SATClientesLineas( ::nView ) ) 

         ::oDbf:nPctAge    := ( D():SATClientes( ::nView ) )->nPctComAge
         ::oDbf:nComAge    := nComLSATCli( D():SATClientes( ::nView ), D():SATClientesLineas( ::nView ), ::nDecOut, ::nDerOut )

         if empty( ::oDbf:nCosArt )
            ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, ( D():Articulos( ::nView ) ), D():Kit( ::nView ) )
         end if 

         if !empty( ( D():SATClientesLineas( ::nView ) )->cCodPrv ) 
            ::oDbf:cPrvHab := ( D():SATClientesLineas( ::nView ) )->cCodPrv
         else
            ::oDbf:cPrvHab := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )
         end if

         if ( D():SATClientes( ::nView ) )->lEstado
            ::oDbf:cEstado := "Aprovado"
         else
            ::oDbf:cEstado := ""
         end if

         ::oDbf:cSituacion := ( D():SATClientes( ::nView ) )->cSituac

         ::insertIfValid()

         ::loadValuesExtraFields()

      end if

      ( D():SATClientesLineas( ::nView ) )->( dbSkip() )
      
      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddPresupuestoClientes() CLASS TFastVentasArticulos

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

   ( D():PresupuestosClientes( ::nView )        )->( ordsetfocus( "nNumPre" ) )
   ( D():PresupuestosClientesLineas( ::nView )  )->( ordsetfocus( "nNumPre" ) )

   ( D():PresupuestosClientes( ::nView )        )->( setCustomFilter( ::cExpresionHeader ) )
   ( D():PresupuestosClientesLineas( ::nView )  )->( setCustomFilter( ::cExpresionLine ) )

   ::setMeterTotal( ( D():PresupuestosClientes( ::nView ) )->( dbcustomkeycount() ) )

   // Lineas de Preidos--------------------------------------------------------

   ( D():PresupuestosClientesLineas( ::nView ) )->( dbgotop() )
   while !::lBreak .and. !( D():PresupuestosClientesLineas( ::nView ) )->( eof() )

      // Posicionamiento en las cabeceras--------------------------------------

      if ( D():PresupuestosClientes( ::nView ) )->( dbseek( D():PresupuestosClientesLineasId( ::nView ) ) )

         // Añadimos un nuevo registro--------------------------------

         ::oDbf:Blank()

         ::oDbf:cClsDoc    := PRE_CLI
         ::oDbf:cTipDoc    := "Presupuesto cliente"
         ::oDbf:cSerDoc    := ( D():PresupuestosClientesLineas( ::nView ) )->cSerPre
         ::oDbf:cNumDoc    := str( ( D():PresupuestosClientesLineas( ::nView ) )->nNumPre )
         ::oDbf:cSufDoc    := ( D():PresupuestosClientesLineas( ::nView ) )->cSufPre

         ::oDbf:cIdeDoc    := ::idDocumento()

         ::oDbf:nNumLin    := ( D():PresupuestosClientesLineas( ::nView ) )->nNumLin
         ::oDbf:cCodArt    := ( D():PresupuestosClientesLineas( ::nView ) )->cRef
         ::oDbf:cNomArt    := ( D():PresupuestosClientesLineas( ::nView ) )->cDetalle

         ::oDbf:cCodPr1    := ( D():PresupuestosClientesLineas( ::nView ) )->cCodPr1
         ::oDbf:cCodPr2    := ( D():PresupuestosClientesLineas( ::nView ) )->cCodPr2
         ::oDbf:cValPr1    := ( D():PresupuestosClientesLineas( ::nView ) )->cValPr1
         ::oDbf:cValPr2    := ( D():PresupuestosClientesLineas( ::nView ) )->cValPr2

         ::oDbf:cLote      := ( D():PresupuestosClientesLineas( ::nView ) )->cLote
         ::oDbf:dFecCad    := ( D():PresupuestosClientesLineas( ::nView ) )->dFecCad

         ::oDbf:cCodPrv    := ( D():PresupuestosClientesLineas( ::nView ) )->cCodPrv
         ::oDbf:cNomPrv    := RetFld( ( D():PresupuestosClientesLineas( ::nView ) )->cCodPrv, D():Proveedores( ::nView ) )

         ::oDbf:TipoIva    := cCodigoIva( D():TiposIva( ::nView ), ( D():PresupuestosClientesLineas( ::nView ) )->nIva )

         ::oDbf:cCodObr    := ( D():PresupuestosClientesLineas( ::nView ) )->cObrLin

         ::oDbf:cCodFam    := ( D():PresupuestosClientesLineas( ::nView ) )->cCodFam
         ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
         ::oDbf:cGrpFam    := ( D():PresupuestosClientesLineas( ::nView ) )->cGrpFam
         ::oDbf:cCodAlm    := ( D():PresupuestosClientesLineas( ::nView ) )->cAlmLin
         ::oDbf:cDesUbi    := RetFld( ( D():PresupuestosClientesLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cDesUbi", "Codigo" )

         ::oDbf:nDtoArt    := ( D():PresupuestosClientesLineas( ::nView ) )->nDto
         ::oDbf:nLinArt    := ( D():PresupuestosClientesLineas( ::nView ) )->nDtoDiv
         ::oDbf:nPrmArt    := ( D():PresupuestosClientesLineas( ::nView ) )->nDtoPrm
         ::oDbf:nIva       := ( D():PresupuestosClientesLineas( ::nView ) )->nIva

         ::oDbf:cCodTip    := ( D():PresupuestosClientesLineas( ::nView ) )->cCodTip

         ::oDbf:nCosArt    := nTotCPreCli( D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         if empty( ::oDbf:nCosArt )
            ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, D():Articulos( ::nView ), D():Kit( ::nView ) )
         end if 

         ::oDbf:nUniArt    := nTotNPreCli( D():PresupuestosClientesLineas( ::nView ) ) 

         ::oDbf:cCtrCoste  := ( D():PresupuestosClientesLineas( ::nView ) )->cCtrCoste
         ::oDbf:cTipCtr    := ( D():PresupuestosClientesLineas( ::nView ) )->cTipCtr
         ::oDbf:cCodTerCtr := ( D():PresupuestosClientesLineas( ::nView ) )->cTerCtr
         ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ( D():PresupuestosClientesLineas( ::nView ) )->cTipCtr, ( D():PresupuestosClientesLineas( ::nView ) )->cTerCtr, ::nView )

         ::loadPropiedadesArticulos( ( D():PresupuestosClientesLineas( ::nView ) )->cRef )

         ::oDbf:nAnoDoc    := Year( ( D():PresupuestosClientes( ::nView ) )->dFecPre )
         ::oDbf:nMesDoc    := Month( ( D():PresupuestosClientes( ::nView ) )->dFecPre )
         ::oDbf:dFecDoc    := ( D():PresupuestosClientes( ::nView ) )->dFecPre
         ::oDbf:cHorDoc    := SubStr( ( D():PresupuestosClientes( ::nView ) )->cTimCre, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ( D():PresupuestosClientes( ::nView ) )->cTimCre, 4, 2 )

         ::oDbf:cCodGrp    := RetFld( ( D():PresupuestosClientes( ::nView ) )->cCodCli, ( D():Clientes( ::nView ) ), "cCodGrp", "Cod" )

         ::oDbf:cCodPago   := ( D():PresupuestosClientes( ::nView ) )->cCodPgo
         ::oDbf:cCodRut    := ( D():PresupuestosClientes( ::nView ) )->cCodRut
         ::oDbf:cCodAge    := ( D():PresupuestosClientes( ::nView ) )->cCodAge
         ::oDbf:cCodTrn    := ( D():PresupuestosClientes( ::nView ) )->cCodTrn
         ::oDbf:cCodUsr    := ( D():PresupuestosClientes( ::nView ) )->cCodUsr
         ::oDbf:cCodCli    := ( D():PresupuestosClientes( ::nView ) )->cCodCli
         ::oDbf:cNomCli    := ( D():PresupuestosClientes( ::nView ) )->cNomCli
         ::oDbf:cPobCli    := ( D():PresupuestosClientes( ::nView ) )->cPobCli
         ::oDbf:cPrvCli    := ( D():PresupuestosClientes( ::nView ) )->cPrvCli
         ::oDbf:cPosCli    := ( D():PresupuestosClientes( ::nView ) )->cPosCli

         if ( D():Atipicas( ::nView ) )->( dbseek( ( D():PresupuestosClientes( ::nView ) )->cCodCli + ( D():PresupuestosClientesLineas( ::nView ) )->cRef ) ) .and. !empty( ( D():Atipicas( ::nView ) )->cCodEnv )
            ::oDbf:cCodEnv := ( D():Atipicas( ::nView ) )->cCodEnv
         else
            ::oDbf:cCodEnv := RetFld( ( D():PresupuestosClientesLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )                    
         end if

         ::oDbf:nTotDto    := nDtoLPreCli( D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nTotPrm    := nPrmLPreCli( D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nPreArt    := nImpUPreCli( D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nValDiv )
         ::oDbf:nTrnArt    := nTrnUPreCli( D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nValDiv )
         ::oDbf:nPntArt    := nPntLPreCli( D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nValDiv )

         ::oDbf:nBrtArt    := nBrtLPreCli( D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nImpArt    := nImpLPreCli( D():PresupuestosClientes( ::nView ), D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nIvaArt    := nIvaLPreCli( D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nImpEsp    := nTotIPreCli( D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nTotArt    := nImpLPreCli( D():PresupuestosClientes( ::nView ), D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLPreCli( D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nPeso      := nPesLPreCli( D():PresupuestosClientesLineas( ::nView ) ) 

         ::oDbf:nPctAge    := ( D():PresupuestosClientes( ::nView ) )->nPctComAge
         ::oDbf:nComAge    := nComLPreCli( D():PresupuestosClientes( ::nView ), D():PresupuestosClientesLineas( ::nView ), ::nDecOut, ::nDerOut )


         if !empty( ( D():PresupuestosClientesLineas( ::nView ) )->cCodPrv ) 
            ::oDbf:cPrvHab := ( D():PresupuestosClientesLineas( ::nView ) )->cCodPrv
         else
            ::oDbf:cPrvHab := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )
         end if

         if ( D():PresupuestosClientes( ::nView ) )->lEstado
            ::oDbf:cEstado := "Pendiente"
         else
            ::oDbf:cEstado := "Finalizado"
         end if

         ::insertIfValid()

         ::loadValuesExtraFields()

      end if

      ( D():PresupuestosClientesLineas( ::nView ) )->( dbSkip() )
      
      ::setMeterAutoIncremental()

   end while

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

         // Añadimos un nuevo registro--------------------------------

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
         ::oDbf:cNomPrv    := RetFld( ( D():PedidosClientesLineas( ::nView ) )->cCodPrv, D():Proveedores( ::nView ) )

         ::oDbf:TipoIva    := cCodigoIva( D():TiposIva( ::nView ), ( D():PedidosClientesLineas( ::nView ) )->nIva )

         ::oDbf:cCodObr    := ( D():PedidosClientesLineas( ::nView ) )->cObrLin
         ::oDbf:nIva       := ( D():PedidosClientesLineas( ::nView ) )->nIva

         ::oDbf:lKitArt    := ( D():PedidosClientesLineas( ::nView )  )->lKitArt
         ::oDbf:lKitChl    := ( D():PedidosClientesLineas( ::nView )  )->lKitChl

         ::oDbf:cCodFam    := ( D():PedidosClientesLineas( ::nView ) )->cCodFam
         ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
         ::oDbf:cGrpFam    := ( D():PedidosClientesLineas( ::nView ) )->cGrpFam
         ::oDbf:cCodAlm    := ( D():PedidosClientesLineas( ::nView ) )->cAlmLin
         ::oDbf:cDesUbi    := RetFld( ( D():PedidosClientesLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cDesUbi", "Codigo" )

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

         ::oDbf:cFormato   := ( D():PedidosClientesLineas( ::nView )  )->cFormato

         ::oDbf:cCodGrp    := RetFld( ( D():PedidosClientes( ::nView ) )->cCodCli, ( D():Clientes( ::nView ) ), "cCodGrp", "Cod" )

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

         if ( D():Atipicas( ::nView ) )->( dbseek( ( D():PedidosClientes( ::nView ) )->cCodCli + ( D():PedidosClientesLineas( ::nView ) )->cRef ) ) .and. !empty( ( D():Atipicas( ::nView ) )->cCodEnv )
            ::oDbf:cCodEnv := ( D():Atipicas( ::nView ) )->cCodEnv
         else
            ::oDbf:cCodEnv := RetFld( ( D():PedidosClientesLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )                    
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
            ::oDbf:nCosArt    := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, ( D():Articulos( ::nView ) ), D():Kit( ::nView ) )
         end if 

         if !empty( ( D():PedidosClientesLineas( ::nView ) )->cCodPrv ) 
            ::oDbf:cPrvHab    := ( D():PedidosClientesLineas( ::nView ) )->cCodPrv
         else
            ::oDbf:cPrvHab    := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )
         end if

         ::oDbf:nCargo        := nUnidadesRecibidasAlbaranesClientes( D():PedidosClientesLineasId( ::nView ), ( D():PedidosClientesLineas( ::nView ) )->cRef, ( D():PedidosClientesLineas( ::nView ) )->cValPr1, ( D():PedidosClientesLineas( ::nView ) )->cValPr2, D():AlbaranesClientesLineas( ::nView ) )

         ::oDbf:nPdtEnt       := nTotNPedCli( D():PedidosClientesLineas( ::nView ) ) - nUnidadesRecibidasAlbaranesClientes( D():PedidosClientesLineasId( ::nView ), ( D():PedidosClientesLineas( ::nView ) )->cRef, ( D():PedidosClientesLineas( ::nView ) )->cValPr1, ( D():PedidosClientesLineas( ::nView ) )->cValPr2, D():AlbaranesClientesLineas( ::nView ) ) 
         ::oDbf:nEntreg       := nUnidadesRecibidasAlbaranesClientes( D():PedidosClientesLineasId( ::nView ), ( D():PedidosClientesLineas( ::nView ) )->cRef, ( D():PedidosClientesLineas( ::nView ) )->cValPr1, ( D():PedidosClientesLineas( ::nView ) )->cValPr2, D():AlbaranesClientesLineas( ::nView ) ) 
         
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
   
   // filtros para las líneas-------------------------------------------------

   ::cExpresionLine        := '!Field->lTotLin .and. !Field->lControl'
   ::cExpresionLine        += ' .and. ( Field->dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionLine        += ' .and. ( Field->cSerAlb >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerAlb <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine        += ' .and. ( Field->nNumAlb >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumAlb <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine        += ' .and. ( Field->cSufAlb >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufAlb <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'
   
   ::setFilterProductIdLine()

   ::setFilterStoreLine()

   ::setFilterFamily() 

   ::setFilterGroupFamily()

   // Procesando albaranes-----------------------------------------------------

   ::setMeterText( "Procesando albaranes" )

   ( D():AlbaranesClientes( ::nView )        )->( ordsetfocus( "nNumAlb" ) )
   ( D():AlbaranesClientesLineas( ::nView )  )->( ordsetfocus( "nNumAlb" ) )

   ( D():AlbaranesClientes( ::nView )        )->( setCustomFilter( ::cExpresionHeader ) )
   ( D():AlbaranesClientesLineas( ::nView )  )->( setCustomFilter( ::cExpresionLine ) )

   ::setMeterTotal( ( D():AlbaranesClientesLineas( ::nView ) )->( dbCustomKeyCount() ) )

   // Lineas de albaranes---------------------------------------------------------

   ( D():AlbaranesClientesLineas( ::nView ) )->( dbgotop() )
   while !::lBreak .and. !( D():AlbaranesClientesLineas( ::nView ) )->( eof() )

      if D():gotoIdAlbaranesClientes( D():AlbaranesClientesLineasId( ::nView ), ::nView )

         ::oDbf:Blank()

         ::oDbf:cCodArt    := ( D():AlbaranesClientesLineas( ::nView )  )->cRef
         ::oDbf:cNomArt    := ( D():AlbaranesClientesLineas( ::nView )  )->cDetalle

         ::oDbf:cCodPrv    := ( D():AlbaranesClientesLineas( ::nView )  )->cCodPrv
         ::oDbf:cNomPrv    := RetFld( ( D():AlbaranesClientesLineas( ::nView )  )->cCodPrv, D():Proveedores( ::nView ) )

         ::oDbf:TipoIva    := cCodigoIva( D():TiposIva( ::nView ), ( D():AlbaranesClientesLineas( ::nView )  )->nIva )
         
         ::loadPropiedadesArticulos( ( D():AlbaranesClientesLineas( ::nView )  )->cRef )
         
         ::oDbf:cCodFam    := ( D():AlbaranesClientesLineas( ::nView )  )->cCodFam
         ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
         ::oDbf:cGrpFam    := ( D():AlbaranesClientesLineas( ::nView )  )->cGrpFam
         ::oDbf:cCodAlm    := ( D():AlbaranesClientesLineas( ::nView )  )->cAlmLin
         ::oDbf:nIva       := ( D():AlbaranesClientesLineas( ::nView ) )->nIva
         
         ::oDbf:cCodObr    := ( D():AlbaranesClientesLineas( ::nView )  )->cObrLin

         ::oDbf:nUniArt    := nTotNAlbCli( ( D():AlbaranesClientesLineas( ::nView ) ) ) * if( ::lUnidadesNegativo, -1, 1 )

         ::oDbf:nDtoArt    := ( D():AlbaranesClientesLineas( ::nView )  )->nDto
         ::oDbf:nLinArt    := ( D():AlbaranesClientesLineas( ::nView )  )->nDtoDiv
         ::oDbf:nPrmArt    := ( D():AlbaranesClientesLineas( ::nView )  )->nDtoPrm

         ::oDbf:nTotDto    := nDtoLAlbCli( ( D():AlbaranesClientesLineas( ::nView )  ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nTotPrm    := nPrmLAlbCli( ( D():AlbaranesClientesLineas( ::nView )  ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nTrnArt    := nTrnUAlbCli( ( D():AlbaranesClientesLineas( ::nView )  ), ::nDecOut, ::nValDiv )
         ::oDbf:nPntArt    := nPntLAlbCli( ( D():AlbaranesClientesLineas( ::nView )  ), ::nDecOut, ::nValDiv )
         
         ::oDbf:nIvaArt    := nIvaLAlbCli( ( D():AlbaranesClientesLineas( ::nView )  ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nImpEsp    := nTotIAlbCli( ( D():AlbaranesClientesLineas( ::nView )  ), ::nDecOut, ::nDerOut, ::nValDiv )
         
         ::oDbf:nCosArt    := nCosLAlbCli( ( D():AlbaranesClientesLineas( ::nView )  ), ::nDecOut, ::nDerOut, ::nValDiv )

         if empty( ::oDbf:nCosArt )
            ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, ( D():Articulos( ::nView ) ), D():Kit( ::nView ) )
         end if 

         ::oDbf:cCodPr1       := ( D():AlbaranesClientesLineas( ::nView )  )->cCodPr1
         ::oDbf:cCodPr2       := ( D():AlbaranesClientesLineas( ::nView )  )->cCodPr2
         ::oDbf:cValPr1       := ( D():AlbaranesClientesLineas( ::nView )  )->cValPr1
         ::oDbf:cValPr2       := ( D():AlbaranesClientesLineas( ::nView )  )->cValPr2

         ::oDbf:cLote         := ( D():AlbaranesClientesLineas( ::nView )  )->cLote
         ::oDbf:dFecCad       := ( D():AlbaranesClientesLineas( ::nView )  )->dFecCad

         ::oDbf:cClsDoc       := ALB_CLI
         ::oDbf:cTipDoc       := "Albarán cliente"
         ::oDbf:cSerDoc       := ( D():AlbaranesClientesLineas( ::nView )  )->cSerAlb
         ::oDbf:cNumDoc       := Str( ( D():AlbaranesClientesLineas( ::nView )  )->nNumAlb )
         ::oDbf:cSufDoc       := ( D():AlbaranesClientesLineas( ::nView )  )->cSufAlb

         ::oDbf:cIdeDoc       :=  ::idDocumento()
         ::oDbf:nNumLin       :=  ( D():AlbaranesClientesLineas( ::nView )  )->nNumLin

         ::oDbf:nBultos       := ( D():AlbaranesClientesLineas( ::nView )  )->nBultos * if( ::lUnidadesNegativo, -1, 1 )
         ::oDbf:cFormato      := ( D():AlbaranesClientesLineas( ::nView )  )->cFormato
         ::oDbf:nCajas        := ( D():AlbaranesClientesLineas( ::nView )  )->nCanEnt * if( ::lUnidadesNegativo, -1, 1 )
         ::oDbf:nPeso         := nPesLAlbCli( ( D():AlbaranesClientesLineas( ::nView )  ) )

         ::oDbf:lKitArt       := ( D():AlbaranesClientesLineas( ::nView )  )->lKitArt
         ::oDbf:lKitChl       := ( D():AlbaranesClientesLineas( ::nView )  )->lKitChl

         ::oDbf:cCtrCoste     := ( D():AlbaranesClientesLineas( ::nView )  )->cCtrCoste

         ::oDbf:cTipCtr       := ( D():AlbaranesClientesLineas( ::nView )  )->cTipCtr
         ::oDbf:cCodTerCtr    := ( D():AlbaranesClientesLineas( ::nView )  )->cTerCtr
         ::oDbf:cNomTerCtr    := NombreTerceroCentroCoste( ( D():AlbaranesClientesLineas( ::nView )  )->cTipCtr, ( D():AlbaranesClientesLineas( ::nView )  )->cTerCtr, ::nView )

         if !empty( ( D():AlbaranesClientesLineas( ::nView )  )->cRef ) 
            ::oDbf:cPrvHab    := ( D():AlbaranesClientesLineas( ::nView )  )->cRef
         else
            ::oDbf:cPrvHab    := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )
         end if

         ::oDbf:cCodGrp    := RetFld( ( D():AlbaranesClientes( ::nView ) )->cCodCli, ( D():Clientes( ::nView ) ), "cCodGrp", "Cod" )

         if ( D():Atipicas( ::nView ) )->( dbseek( ( D():AlbaranesClientes( ::nView ) )->cCodCli + ( D():AlbaranesClientesLineas( ::nView )  )->cRef ) ) .and. !empty( ( D():Atipicas( ::nView ) )->cCodEnv )
            ::oDbf:cCodEnv := ( D():Atipicas( ::nView ) )->cCodEnv
         else
            ::oDbf:cCodEnv := RetFld( ( D():AlbaranesClientesLineas( ::nView )  )->cRef, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )                    
         end if

         ::oDbf:cCodPago   := ( D():AlbaranesClientes( ::nView ) )->cCodPago
         ::oDbf:cCodRut    := ( D():AlbaranesClientes( ::nView ) )->cCodRut
         ::oDbf:cCodAge    := ( D():AlbaranesClientes( ::nView ) )->cCodAge
         ::oDbf:cCodTrn    := ( D():AlbaranesClientes( ::nView ) )->cCodTrn
         ::oDbf:cCodUsr    := ( D():AlbaranesClientes( ::nView ) )->cCodUsr

         ::oDbf:cCodCli    := ( D():AlbaranesClientes( ::nView ) )->cCodCli
         ::oDbf:cNomCli    := ( D():AlbaranesClientes( ::nView ) )->cNomCli
         ::oDbf:cPobCli    := ( D():AlbaranesClientes( ::nView ) )->cPobCli
         ::oDbf:cPrvCli    := ( D():AlbaranesClientes( ::nView ) )->cPrvCli
         ::oDbf:cPosCli    := ( D():AlbaranesClientes( ::nView ) )->cPosCli

         ::oDbf:nPreArt    := nTotUAlbCli( ( D():AlbaranesClientesLineas( ::nView ) ), ::nDecOut, ::nValDiv )
         ::oDbf:nBrtArt    := nBrtLAlbCli( ( D():AlbaranesClientes( ::nView ) ), ( D():AlbaranesClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nImpArt    := nImpLAlbCli( ( D():AlbaranesClientes( ::nView ) ), ( D():AlbaranesClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nTotArt    := nImpLAlbCli( ( D():AlbaranesClientes( ::nView ) ), ( D():AlbaranesClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLAlbCli( ( D():AlbaranesClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nPctAge    := ( D():AlbaranesClientes( ::nView ) )->nPctComAge
         ::oDbf:nComAge    := nComLAlbCli( ( D():AlbaranesClientes( ::nView ) ), ( D():AlbaranesClientesLineas( ::nView )  ), ::nDecOut, ::nDerOut )

         ::oDbf:nAnoDoc    := Year( ( D():AlbaranesClientes( ::nView ) )->dFecAlb )
         ::oDbf:nMesDoc    := Month( ( D():AlbaranesClientes( ::nView ) )->dFecAlb )
         ::oDbf:dFecDoc    := ( D():AlbaranesClientes( ::nView ) )->dFecAlb
         ::oDbf:cHorDoc    := SubStr( ( D():AlbaranesClientes( ::nView ) )->cTimCre, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ( D():AlbaranesClientes( ::nView ) )->cTimCre, 4, 2 )

         do case
            case ( D():AlbaranesClientes( ::nView ) )->nFacturado <= 1
               ::oDbf:cEstado    := "Pendiente"

            case ( D():AlbaranesClientes( ::nView ) )->nFacturado == 2
               ::oDbf:cEstado    := "Parcialmente"

            case ( D():AlbaranesClientes( ::nView ) )->nFacturado == 3
               ::oDbf:cEstado    := "Finalizado"
         end case

         ::insertIfValid()

         ::loadValuesExtraFields()

      end if

      ( D():AlbaranesClientesLineas( ::nView ) )->( dbSkip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaCliente() CLASS TFastVentasArticulos

   // filtros para la cabecera-------------------------------------------------
   
   ::cExpresionHeader      := '( Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )      + '" .and. Field->cSerie <= "'    + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionHeader      += ' .and. ( Field->nNumFac >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )    + '" ) .and. Field->nNumFac <= Val( "'    + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )    + '" .and. Field->cSufFac <= "'    + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'
   
   ::setFilterPaymentId()

   ::setFilterRouteId() 

   ::setFilterTransportId()
   
   ::setFilterUserId()

   ::setFilterAgent()

   // filtros para las líneas-------------------------------------------------

   ::cExpresionLine        := '!Field->lTotLin .and. !Field->lControl'
   ::cExpresionLine        += ' .and. ( Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionLine        += ' .and. ( Field->cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )      + '" .and. Field->cSerie <= "'    + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine        += ' .and. ( Field->nNumFac >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )    + '" ) .and. Field->nNumFac <= Val( "'    + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine        += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )    + '" .and. Field->cSufFac <= "'    + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'
   
   ::setFilterProductIdLine()

   ::setFilterStoreLine()

   ::setFilterFamily() 

   ::setFilterGroupFamily()

   ::setFilterClientIdHeader()

   // Procesando facturas------------------------------------------------------

   ::setMeterText( "Procesando facturas" )

   ( D():FacturasClientes( ::nView )         )->( ordsetfocus( "nNumFac" ) )
   ( D():FacturasClientesLineas( ::nView )   )->( ordsetfocus( "nNumFac" ) )

   ( D():FacturasClientes( ::nView )         )->( setCustomFilter( ::cExpresionHeader ) )
   ( D():FacturasClientesLineas( ::nView )   )->( setCustomFilter( ::cExpresionLine ) )

   ::setMeterTotal( ( D():FacturasClientesLineas( ::nView ) )->( dbCustomKeyCount() ) )

   // Lineas de facturas-------------------------------------------------------

   ( D():FacturasClientesLineas( ::nView ) )->( dbgotop() )

   while !::lBreak .and. !( D():FacturasClientesLineas( ::nView ) )->( eof() )

      if D():gotoIdFacturasClientes( D():FacturasClientesLineasId( ::nView ), ::nView ) 

         ::oDbf:Blank()
         ::oDbf:cCodArt    :=( D():FacturasClientesLineas( ::nView ) )->cRef
         ::oDbf:cNomArt    :=( D():FacturasClientesLineas( ::nView ) )->cDetalle

         ::oDbf:cCodPrv    :=( D():FacturasClientesLineas( ::nView ) )->cCodPrv
         ::oDbf:cNomPrv    := RetFld(( D():FacturasClientesLineas( ::nView ) )->cCodPrv, D():Proveedores( ::nView ) )

         ::oDbf:cCodFam    :=( D():FacturasClientesLineas( ::nView ) )->cCodFam
         ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
         ::oDbf:cGrpFam    :=( D():FacturasClientesLineas( ::nView ) )->cGrpFam
         ::oDbf:TipoIva    := cCodigoIva( D():TiposIva( ::nView ),( D():FacturasClientesLineas( ::nView ) )->nIva )
         
         ::loadPropiedadesArticulos( ( D():FacturasClientesLineas( ::nView )  )->cRef )
         
         ::oDbf:cCodAlm    :=( D():FacturasClientesLineas( ::nView ) )->cAlmLin
         ::oDbf:cCodObr    :=( D():FacturasClientesLineas( ::nView ) )->cCodObr
         
         ::oDbf:nUniArt    := nTotNFacCli( D():FacturasClientesLineas( ::nView ) ) * if( ::lUnidadesNegativo, -1, 1 )

         ::oDbf:nDtoArt    := ( D():FacturasClientesLineas( ::nView ) )->nDto
         ::oDbf:nLinArt    := ( D():FacturasClientesLineas( ::nView ) )->nDtoDiv
         ::oDbf:nPrmArt    := ( D():FacturasClientesLineas( ::nView ) )->nDtoPrm

         ::oDbf:nIva       := ( D():FacturasClientesLineas( ::nView ) )->nIva

         ::oDbf:nTotDto    := nDtoLFacCli( ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nTotPrm    := nPrmLFacCli( ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nPntArt    := nPntLFacCli( ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nValDiv )

         ::oDbf:nBrtArt    := nBrtLFacCli( ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nIvaArt    := nIvaLFacCli( ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nImpEsp    := nTotIFacCli( ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nCosArt    := nCosLFacCli( ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
         
         if empty( ::oDbf:nCosArt )
            ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, ( D():Articulos( ::nView ) ), D():Kit( ::nView ) )
         end if 

         ::oDbf:cCodPr1    := ( D():FacturasClientesLineas( ::nView ) )->cCodPr1
         ::oDbf:cCodPr2    := ( D():FacturasClientesLineas( ::nView ) )->cCodPr2
         ::oDbf:cValPr1    := ( D():FacturasClientesLineas( ::nView ) )->cValPr1
         ::oDbf:cValPr2    := ( D():FacturasClientesLineas( ::nView ) )->cValPr2

         ::oDbf:cLote      := ( D():FacturasClientesLineas( ::nView ) )->cLote
         ::oDbf:dFecCad    := ( D():FacturasClientesLineas( ::nView ) )->dFecCad

         ::oDbf:cClsDoc    := FAC_CLI
         ::oDbf:cTipDoc    := "Factura cliente"
         ::oDbf:cSerDoc    := ( D():FacturasClientesLineas( ::nView ) )->cSerie
         ::oDbf:cNumDoc    := Str( ( D():FacturasClientesLineas( ::nView ) )->nNumFac )
         ::oDbf:cSufDoc    := ( D():FacturasClientesLineas( ::nView ) )->cSufFac

         ::oDbf:cIdeDoc    :=  ::idDocumento()
         ::oDbf:nNumLin    :=  ( D():FacturasClientesLineas( ::nView ) )->nNumLin

         ::oDbf:nBultos    := ( D():FacturasClientesLineas( ::nView ) )->nBultos * if( ::lUnidadesNegativo, -1, 1 )
         ::oDbf:cFormato   := ( D():FacturasClientesLineas( ::nView ) )->cFormato
         ::oDBf:nCajas     := ( D():FacturasClientesLineas( ::nView ) )->nCanEnt * if( ::lUnidadesNegativo, -1, 1 )
         ::oDbf:nPeso      := nPesLFacCli( ( D():FacturasClientesLineas( ::nView ) ) )

         ::oDbf:lKitArt    := ( D():FacturasClientesLineas( ::nView ) )->lKitArt
         ::oDbf:lKitChl    := ( D():FacturasClientesLineas( ::nView ) )->lKitChl

         ::oDbf:cCtrCoste  := ( D():FacturasClientesLineas( ::nView ) )->cCtrCoste
         ::oDbf:cTipCtr    := ( D():FacturasClientesLineas( ::nView ) )->cTipCtr
         ::oDbf:cCodTerCtr := ( D():FacturasClientesLineas( ::nView ) )->cTerCtr
         ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ( D():FacturasClientesLineas( ::nView ) )->cTipCtr, ( D():FacturasClientesLineas( ::nView ) )->cTerCtr, ::nView )

         if !empty( ( D():FacturasClientesLineas( ::nView ) )->cCodPrv ) 
            ::oDbf:cPrvHab := ( D():FacturasClientesLineas( ::nView ) )->cCodPrv
         else
            ::oDbf:cPrvHab := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )
         end if 

         if ( D():Atipicas( ::nView ) )->( dbseek( ( D():FacturasClientes( ::nView ) )->cCodCli + ( D():FacturasClientesLineas( ::nView ) )->cRef ) ) .and. !empty( ( D():Atipicas( ::nView ) )->cCodEnv )
            ::oDbf:cCodEnv    := ( D():Atipicas( ::nView ) )->cCodEnv
         else
            ::oDbf:cCodEnv    := RetFld( ( D():FacturasClientesLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )                    
         end if
         
         ::oDbf:cCodPago   := ( D():FacturasClientes( ::nView ) )->cCodPago
         ::oDbf:cCodRut    := ( D():FacturasClientes( ::nView ) )->cCodRut
         ::oDbf:cCodAge    := ( D():FacturasClientes( ::nView ) )->cCodAge
         ::oDbf:cCodTrn    := ( D():FacturasClientes( ::nView ) )->cCodTrn
         ::oDbf:cCodUsr    := ( D():FacturasClientes( ::nView ) )->cCodUsr

         ::oDbf:cCodCli    := ( D():FacturasClientes( ::nView ) )->cCodCli
         ::oDbf:cNomCli    := ( D():FacturasClientes( ::nView ) )->cNomCli
         ::oDbf:cPobCli    := ( D():FacturasClientes( ::nView ) )->cPobCli
         ::oDbf:cPrvCli    := ( D():FacturasClientes( ::nView ) )->cPrvCli
         ::oDbf:cPosCli    := ( D():FacturasClientes( ::nView ) )->cPosCli
         ::oDbf:cCodGrp    := RetFld( ( D():FacturasClientes( ::nView ) )->cCodCli, ( D():Clientes( ::nView ) ), "cCodGrp", "Cod" )

         ::oDbf:nPreArt    := nImpUFacCli( ( D():FacturasClientes( ::nView ) ), ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nValDiv )
         ::oDbf:nTrnArt    := nTrnUFacCli( ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nValDiv )
         ::oDbf:nImpArt    := nImpLFacCli( ( D():FacturasClientes( ::nView ) ), ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nTotArt    := nImpLFacCli( ( D():FacturasClientes( ::nView ) ), ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLFacCli( ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nPctAge    := ( D():FacturasClientes( ::nView ) )->nPctComAge
         ::oDbf:nComAge    := nComLFacCli( ( D():FacturasClientes( ::nView ) ), ( D():FacturasClientesLineas( ::nView ) ), ::nDecOut, ::nDerOut )

         ::oDbf:nAnoDoc    := Year( ( D():FacturasClientes( ::nView ) )->dFecFac )
         ::oDbf:nMesDoc    := Month( ( D():FacturasClientes( ::nView ) )->dFecFac )
         ::oDbf:dFecDoc    := ( D():FacturasClientes( ::nView ) )->dFecFac
         ::oDbf:cHorDoc    := SubStr( ( D():FacturasClientes( ::nView ) )->cTimCre, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ( D():FacturasClientes( ::nView ) )->cTimCre, 4, 2 )

         ::oDbf:cEstado    := cChkPagFacCli( ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc, ( D():FacturasClientes( ::nView ) ), D():FacturasClientesCobros( ::nView ) )

         ::loadValuesExtraFields()

         ::InsertIfValid()

      end if

      ( D():FacturasClientesLineas( ::nView ) )->( dbskip() )

      ::setMeterAutoIncremental()

   end while


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

   ( D():FacturasRectificativas( ::nView )         )->( ordsetfocus( "nNumFac" ) )
   ( D():FacturasRectificativasLineas( ::nView )   )->( ordsetfocus( "nNumFac" ) )

   ( D():FacturasRectificativas( ::nView )         )->( setCustomFilter( ::cExpresionHeader ) )
   ( D():FacturasRectificativasLineas( ::nView )   )->( setCustomFilter( ::cExpresionLine ) )

   ::setMeterTotal( ( D():FacturasRectificativasLineas( ::nView ) )->( dbCustomKeyCount() ) )

   // Lineas de facturas rectificativas----------------------------------------

   ( D():FacturasRectificativasLineas( ::nView ) )->( dbgotop() )

   while !::lBreak .and. !( D():FacturasRectificativasLineas( ::nView ) )->( eof() )

      if D():gotoIdFacturasRectificativas( D():FacturasRectificativasLineasId( ::nView ), ::nView )

         ::oDbf:Blank()

         ::oDbf:cCodArt    := ( D():FacturasRectificativasLineas( ::nView ) )->cRef
         ::oDbf:cNomArt    := ( D():FacturasRectificativasLineas( ::nView ) )->cDetalle

         ::oDbf:cCodPrv    := ( D():FacturasRectificativasLineas( ::nView ) )->cCodPrv
         ::oDbf:cNomPrv    := RetFld( ( D():FacturasRectificativasLineas( ::nView ) )->cCodPrv, D():Proveedores( ::nView ) )

         ::oDbf:cCodFam    := ( D():FacturasRectificativasLineas( ::nView ) )->cCodFam
         ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
         ::oDbf:cGrpFam    := ( D():FacturasRectificativasLineas( ::nView ) )->cGrpFam
         ::oDbf:TipoIva    := cCodigoIva( D():TiposIva( ::nView ), ( D():FacturasRectificativasLineas( ::nView ) )->nIva )
         
         ::loadPropiedadesArticulos( ( D():FacturasRectificativasLineas( ::nView )  )->cRef )

         ::oDbf:cCodAlm    := ( D():FacturasRectificativasLineas( ::nView ) )->cAlmLin
         ::oDbf:cCodObr    := ( D():FacturasRectificativasLineas( ::nView ) )->cObrLin

         ::oDbf:nIva       := ( D():FacturasRectificativasLineas( ::nView ) )->nIva

         ::oDbf:nUniArt    := nTotNFacRec( ( D():FacturasRectificativasLineas( ::nView ) ) ) * if( ::lUnidadesNegativo, -1, 1 )

         ::oDbf:nDtoArt    := ( D():FacturasRectificativasLineas( ::nView ) )->nDto
         ::oDbf:nLinArt    := ( D():FacturasRectificativasLineas( ::nView ) )->nDtoDiv
         ::oDbf:nPrmArt    := ( D():FacturasRectificativasLineas( ::nView ) )->nDtoPrm

         ::oDbf:nTotDto    := nDtoLFacRec( ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nTotPrm    := nPrmLFacRec( ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nTrnArt    := nTrnUFacRec( ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nValDiv )
         ::oDbf:nPntArt    := nPntLFacRec( ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nValDiv )

         ::oDbf:nBrtArt    := nBrtLFacRec( ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nIvaArt    := nIvaLFacRec( ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nImpEsp    := nTotIFacRec( ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nCosArt    := nCosLFacRec( ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
         if empty( ::oDbf:nCosArt )
            ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, ( D():Articulos( ::nView ) ), D():Kit( ::nView ) )
         end if 

         ::oDbf:cCodPr1    := ( D():FacturasRectificativasLineas( ::nView ) )->cCodPr1
         ::oDbf:cCodPr2    := ( D():FacturasRectificativasLineas( ::nView ) )->cCodPr2
         ::oDbf:cValPr1    := ( D():FacturasRectificativasLineas( ::nView ) )->cValPr1
         ::oDbf:cValPr2    := ( D():FacturasRectificativasLineas( ::nView ) )->cValPr2

         ::oDbf:cLote      := ( D():FacturasRectificativasLineas( ::nView ) )->cLote
         ::oDbf:dFecCad    := ( D():FacturasRectificativasLineas( ::nView ) )->dFecCad

         ::oDbf:cClsDoc    := FAC_REC
         ::oDbf:cTipDoc    := "Rectificativa cliente"
         ::oDbf:cSerDoc    := ( D():FacturasRectificativasLineas( ::nView ) )->cSerie
         ::oDbf:cNumDoc    := Str( ( D():FacturasRectificativasLineas( ::nView ) )->nNumFac )
         ::oDbf:cSufDoc    := ( D():FacturasRectificativasLineas( ::nView ) )->cSufFac

         ::oDbf:cIdeDoc    :=  ::idDocumento()
         ::oDbf:nNumLin    :=  ( D():FacturasRectificativasLineas( ::nView ) )->nNumLin

         ::oDbf:nBultos    := ( D():FacturasRectificativasLineas( ::nView ) )->nBultos * if( ::lUnidadesNegativo, -1, 1)
         ::oDbf:cFormato   := ( D():FacturasRectificativasLineas( ::nView ) )->cFormato
         ::oDbf:nCajas     := ( D():FacturasRectificativasLineas( ::nView ) )->nCanEnt * if( ::lUnidadesNegativo, -1, 1 )
         ::oDbf:nPeso      := nPesLFacRec( D():FacturasRectificativasLineas( ::nView ) )

         ::oDbf:lKitArt    := ( D():FacturasRectificativasLineas( ::nView ) )->lKitArt
         ::oDbf:lKitChl    := ( D():FacturasRectificativasLineas( ::nView ) )->lKitChl

         ::oDbf:cCtrCoste  := ( D():FacturasRectificativasLineas( ::nView ) )->cCtrCoste
         ::oDbf:cTipCtr    := ( D():FacturasRectificativasLineas( ::nView ) )->cTipCtr
         ::oDbf:cCodTerCtr := ( D():FacturasRectificativasLineas( ::nView ) )->cTerCtr
         ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ( D():FacturasRectificativasLineas( ::nView ) )->cTipCtr, ( D():FacturasRectificativasLineas( ::nView ) )->cTerCtr, ::nView )

         if !empty( ( D():FacturasRectificativasLineas( ::nView ) )->cCodPrv ) 
            ::oDbf:cPrvHab := ( D():FacturasRectificativasLineas( ::nView ) )->cCodPrv
         else
            ::oDbf:cPrvHab := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )
         end if

         if ( D():Atipicas( ::nView ) )->( dbseek( ( D():FacturasRectificativas( ::nView ) )->cCodCli + ( D():FacturasRectificativasLineas( ::nView ) )->cRef ) ) .and. !empty( ( D():Atipicas( ::nView ) )->cCodEnv )
            ::oDbf:cCodEnv    := ( D():Atipicas( ::nView ) )->cCodEnv
         else
            ::oDbf:cCodEnv    := RetFld( ( D():FacturasRectificativasLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )                    
         end if

         ::oDbf:cCodPago   := ( D():FacturasRectificativas( ::nView ) )->cCodPago
         ::oDbf:cCodRut    := ( D():FacturasRectificativas( ::nView ) )->cCodRut
         ::oDbf:cCodAge    := ( D():FacturasRectificativas( ::nView ) )->cCodAge
         ::oDbf:cCodTrn    := ( D():FacturasRectificativas( ::nView ) )->cCodTrn
         ::oDbf:cCodUsr    := ( D():FacturasRectificativas( ::nView ) )->cCodUsr

         ::oDbf:cCodCli    := ( D():FacturasRectificativas( ::nView ) )->cCodCli
         ::oDbf:cNomCli    := ( D():FacturasRectificativas( ::nView ) )->cNomCli
         ::oDbf:cPobCli    := ( D():FacturasRectificativas( ::nView ) )->cPobCli
         ::oDbf:cPrvCli    := ( D():FacturasRectificativas( ::nView ) )->cPrvCli
         ::oDbf:cPosCli    := ( D():FacturasRectificativas( ::nView ) )->cPosCli

         ::oDbf:cCodGrp    := RetFld( ( D():FacturasRectificativas( ::nView ) )->cCodCli, ( D():Clientes( ::nView ) ), "cCodGrp", "Cod" )

         ::oDbf:nPreArt    := nImpUFacRec( ( D():FacturasRectificativas( ::nView ) ), ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nValDiv )
      
         ::oDbf:nImpArt    := nImpLFacRec( ( D():FacturasRectificativas( ::nView ) ), ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nTotArt    := nImpLFacRec( ( D():FacturasRectificativas( ::nView ) ), ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLFacRec( ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nPctAge    := ( D():FacturasRectificativas( ::nView ) )->nPctComAge
         ::oDbf:nComAge    := nComLFacRec( ( D():FacturasRectificativas( ::nView ) ), ( D():FacturasRectificativasLineas( ::nView ) ), ::nDecOut, ::nDerOut )

         ::oDbf:nAnoDoc    := Year( ( D():FacturasRectificativas( ::nView ) )->dFecFac )
         ::oDbf:nMesDoc    := Month( ( D():FacturasRectificativas( ::nView ) )->dFecFac )
         ::oDbf:dFecDoc    := ( D():FacturasRectificativas( ::nView ) )->dFecFac
         ::oDbf:cHorDoc    := SubStr( ( D():FacturasRectificativas( ::nView ) )->cTimCre, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ( D():FacturasRectificativas( ::nView ) )->cTimCre, 4, 2 )

         ::oDbf:cEstado    := cChkPagFacRec( ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc, ( D():FacturasRectificativas( ::nView ) ), D():FacturasClientesCobros( ::nView ) )

         ::InsertIfValid()

         ::loadValuesExtraFields()

      end if

      ( D():FacturasRectificativasLineas( ::nView ) )->( dbSkip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddTicket() CLASS TFastVentasArticulos

   // Filtros para la cabecera ------------------------------------------------

   ::cExpresionHeader       := '( Field->dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader       += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'
   ::cExpresionHeader       += ' .and. Field->cCliTik >= "' + Rtrim( ::oGrupoCliente:Cargo:getDesde() ) + '" .and. Field->cCliTik <= "' + Rtrim( ::oGrupoCliente:Cargo:getHasta() ) + '"'
   ::cExpresionHeader       += ' .and. Field->cSerTik >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerTik <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '"'
   ::cExpresionHeader       += ' .and. Field->cNumTik >= "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )   + '" .and. Field->cNumTik <= "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '"'
   ::cExpresionHeader       += ' .and. Field->cSufTik >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )   + '" .and. Field->cSufTik <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '"'

   ::setFilterAgent()

   // Filtros para las líneas ------------------------------------------------

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

   ( D():Tikets( ::nView )           )->( ordsetfocus( "cNumTik" ) )
   ( D():TiketsLineas( ::nView )     )->( ordsetfocus( "cNumTil" ) )

   ( D():Tikets( ::nView )           )->( setCustomFilter( ::cExpresionHeader ) )
   ( D():TiketsLineas( ::nView )     )->( setCustomFilter( ::cExpresionLine ) )

   ::setMeterTotal( ( D():Tikets( ::nView ) )->( dbCustomKeyCount() ) )

   // Cabecera de tickets -------------------------------------------------------

   ( D():Tikets( ::nView ) )->( dbgotop() )
   while !::lBreak .and. !( D():Tikets( ::nView ) )->( eof() )

      if D():gotoIdTiketsLineas( D():TiketsId( ::nView ), ::nView ) 

         while ( D():TiketsId( ::nView ) ) == ( D():TiketsLineasId( ::nView ) ) .and. !( D():TiketsLineas( ::nView ) )->( eof() )

            if ( !empty( ( D():TiketsLineas( ::nView ) )->cCbaTil ) )

               ::oDbf:Blank()
               
               ::oDbf:cCodArt    := ( D():TiketsLineas( ::nView ) )->cCbaTil
               ::oDbf:cNomArt    := ( D():TiketsLineas( ::nView ) )->cNomTil

               ::oDbf:cCodCli    := ( D():Tikets( ::nView ) )->cCliTik
               ::oDbf:cNomCli    := ( D():Tikets( ::nView ) )->cNomTik
               ::oDbf:cPobCli    := ( D():Tikets( ::nView ) )->cPobCli
               ::oDbf:cPrvCli    := ( D():Tikets( ::nView ) )->cPrvCli
               ::oDbf:cPosCli    := ( D():Tikets( ::nView ) )->cPosCli
               ::oDbf:cCodCaj    := ( D():Tikets( ::nView ) )->cNcjTik
               ::oDbf:cCodGrp    := RetFld( ( D():Tikets( ::nView ) )->cCliTik, ( D():Clientes( ::nView ) ), "cCodGrp", "Cod" )

               ::oDbf:TipoIva    := cCodigoIva( D():TiposIva( ::nView ), ( D():TiketsLineas( ::nView ) )->nIvaTil )

               ::oDbf:cCodFam    := ( D():TiketsLineas( ::nView ) )->cCodFam
               ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
               ::oDbf:cGrpFam    := ( D():TiketsLineas( ::nView ) )->cGrpFam

               ::loadPropiedadesArticulos( ( D():TiketsLineas( ::nView ) )->cCbaTil )

               if ( D():Atipicas( ::nView ) )->( dbseek( ( D():Tikets( ::nView ) )->cCliTik + ( D():TiketsLineas( ::nView ) )->cCbaTil ) ) .and. !empty( ( D():Atipicas( ::nView ) )->cCodEnv )
                  ::oDbf:cCodEnv := ( D():Atipicas( ::nView ) )->cCodEnv
               else
                  ::oDbf:cCodEnv := RetFld( ( D():TiketsLineas( ::nView ) )->cCbaTil, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )                    
               end if

               ::oDbf:cCodAlm    := ( D():TiketsLineas( ::nView ) )->cAlmLin
               ::oDbf:cCodPago   := ( D():Tikets( ::nView ) )->cFpgTik
               ::oDbf:cCodRut    := ( D():Tikets( ::nView ) )->cCodRut
               ::oDbf:cCodAge    := ( D():Tikets( ::nView ) )->cCodAge
               ::oDbf:cCodTrn    := ""
               ::oDbf:cCodUsr    := ( D():Tikets( ::nView ) )->cCcjTik
               ::oDbf:cCodObr    := ( D():Tikets( ::nView ) )->cCodObr

               if ( D():Tikets( ::nView ) )->cTipTik == "4"
                  ::oDbf:nUniArt := - ( D():TiketsLineas( ::nView ) )->nUntTil * if( ::lUnidadesNegativo, -1, 1 )
               else
                  ::oDbf:nUniArt := ( D():TiketsLineas( ::nView ) )->nUntTil   * if( ::lUnidadesNegativo, -1, 1 )
               end if

               ::oDbf:nPreArt    := nImpUTpv( ( D():Tikets( ::nView ) ), ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nValDiv, nil, 1 )

               ::oDbf:nBrtArt    := nNetLTpv( ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nImpArt    := nImpLTpv( ( D():Tikets( ::nView ) ), ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )

               ::oDbf:nDtoArt    := ( D():TiketsLineas( ::nView ) )->nDtoLin
               ::oDbf:nLinArt    := ( D():TiketsLineas( ::nView ) )->nDtoDiv

               ::oDbf:nTotDto    := nDtoLTpv( ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotPrm    := 0

               ::oDbf:nIvaArt    := nIvaLTpv( ( D():Tikets( ::nView ) ), ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, 1 )
               ::oDbf:nImpEsp    := nIvmLTpv( ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotArt    := nImpLTpv( ( D():Tikets( ::nView ) ), ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
               ::oDbf:nTotArt    += nIvaLTpv( ( D():Tikets( ::nView ) ), ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, 1 )
               
               ::oDbf:nCosArt    := nCosLTpv( ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, 1 )
               
               if empty( ::oDbf:nCosArt )
                  ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ::oDbf:cCodArt, ( D():Articulos( ::nView ) ), D():Kit( ::nView ) )
               end if 

               ::oDbf:cCodPr1    := ( D():TiketsLineas( ::nView ) )->cCodPr1
               ::oDbf:cCodPr2    := ( D():TiketsLineas( ::nView ) )->cCodPr2
               ::oDbf:cValPr1    := ( D():TiketsLineas( ::nView ) )->cValPr1
               ::oDbf:cValPr2    := ( D():TiketsLineas( ::nView ) )->cValPr2

               ::oDbf:cLote      := ( D():TiketsLineas( ::nView ) )->cLote

               ::oDbf:cClsDoc    := TIK_CLI
               ::oDbf:cTipDoc    := "Ticket"
               ::oDbf:cSerDoc    := ( D():Tikets( ::nView ) )->cSerTik
               ::oDbf:cNumDoc    := ( D():Tikets( ::nView ) )->cNumTik
               ::oDbf:cSufDoc    := ( D():Tikets( ::nView ) )->cSufTik

               ::oDbf:cIdeDoc    :=  ::idDocumento()
               ::oDbf:nNumLin    :=  ( D():TiketsLineas( ::nView ) )->nNumLin

               ::oDbf:nAnoDoc    := Year( ( D():Tikets( ::nView ) )->dFecTik )
               ::oDbf:nMesDoc    := Month( ( D():Tikets( ::nView ) )->dFecTik )
               ::oDbf:dFecDoc    := ( D():Tikets( ::nView ) )->dFecTik
               ::oDbf:cHorDoc    := SubStr( ( D():Tikets( ::nView ) )->cHorTik, 1, 2 )
               ::oDbf:cMinDoc    := SubStr( ( D():Tikets( ::nView ) )->cHorTik, 4, 2 )

               ::oDbf:lKitArt    := ( D():TiketsLineas( ::nView ) )->lKitArt
               ::oDbf:lKitChl    := ( D():TiketsLineas( ::nView ) )->lKitChl

               ::oDbf:cPrvHab    := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )

               // Añadimos un nuevo registro-----------------------------------

               ::InsertIfValid()

               ::loadValuesExtraFields()

            end if

            if !empty( ( D():TiketsLineas( ::nView ) )->cComTil ) // .and. !( ::oTikCliL:lControl ) .and. !( ::oTikCliL:lDelTil )

               ::oDbf:Blank()
               
               ::oDbf:cCodArt    := ( D():TiketsLineas( ::nView ) )->cComTil
               ::oDbf:cNomArt    := ( D():TiketsLineas( ::nView ) )->cNcmTil

               ::oDbf:cCodCli    := ( D():Tikets( ::nView ) )->cCliTik
               ::oDbf:cNomCli    := ( D():Tikets( ::nView ) )->cNomTik
               ::oDbf:cPobCli    := ( D():Tikets( ::nView ) )->cPobCli
               ::oDbf:cPrvCli    := ( D():Tikets( ::nView ) )->cPrvCli
               ::oDbf:cPosCli    := ( D():Tikets( ::nView ) )->cPosCli
               ::oDbf:cCodGrp    := RetFld( ( D():Tikets( ::nView ) )->cCliTik, ( D():Clientes( ::nView ) ), "cCodGrp", "Cod" )
               ::oDbf:TipoIva    := cCodigoIva( D():TiposIva( ::nView ), ( D():TiketsLineas( ::nView ) )->nIvaTil )

               ::oDbf:cCodFam    := ( D():TiketsLineas( ::nView ) )->cCodFam
               ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
               ::oDbf:cGrpFam    := ( D():TiketsLineas( ::nView ) )->cGrpFam

               ::loadPropiedadesArticulos( ( D():TiketsLineas( ::nView ) )->cCbaTil )
               
               if ( D():Atipicas( ::nView ) )->( dbseek( ( D():Tikets( ::nView ) )->cCliTik + ( D():TiketsLineas( ::nView ) )->cCbaTil ) ) .and. !empty( ( D():Atipicas( ::nView ) )->cCodEnv )
                  ::oDbf:cCodEnv    := ( D():Atipicas( ::nView ) )->cCodEnv
               else
                  ::oDbf:cCodEnv    := RetFld( ( D():TiketsLineas( ::nView ) )->cCbaTil, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )                    
               end if

               ::oDbf:cCodAlm    := ( D():TiketsLineas( ::nView ) )->cAlmLin
               ::oDbf:cCodPago   := ( D():Tikets( ::nView ) )->cFpgTik
               ::oDbf:cCodRut    := ( D():Tikets( ::nView ) )->cCodRut
               ::oDbf:cCodAge    := ( D():Tikets( ::nView ) )->cCodAge
               ::oDbf:cCodTrn    := ""
               ::oDbf:cCodUsr    := ( D():Tikets( ::nView ) )->cCcjTik
               ::oDbf:cCodObr    := ( D():Tikets( ::nView ) )->cCodObr

               if ( D():Tikets( ::nView ) )->cTipTik == "4"
                  ::oDbf:nUniArt := - ( D():TiketsLineas( ::nView ) )->nUntTil * if( ::lUnidadesNegativo, -1, 1 )
               else
                  ::oDbf:nUniArt := ( D():TiketsLineas( ::nView ) )->nUntTil   * if( ::lUnidadesNegativo, -1, 1 )
               end if

               ::oDbf:nPreArt    := nImpUTpv( ( D():Tikets( ::nView ) ), ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nValDiv, nil, 2 )

               ::oDbf:nBrtArt    := nBrtLTpv( ( D():Tikets( ::nView ) ), ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nValDiv, nil, 2 )
               ::oDbf:nImpArt    := nImpLTpv( ( D():Tikets( ::nView ) ), ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
               ::oDbf:nIvaArt    := nIvaLTpv( ( D():Tikets( ::nView ) ), ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, 2 )
               ::oDbf:nImpEsp    := nIvmLTpv( ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotArt    := nImpLTpv( ( D():Tikets( ::nView ) ), ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
               ::oDbf:nTotArt    += nIvaLTpv( ( D():Tikets( ::nView ) ), ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, 2 )

               ::oDbf:nCosArt    := nCosLTpv( ( D():TiketsLineas( ::nView ) ), ::nDecOut, ::nDerOut, ::nValDiv, 2 )
               if empty( ::oDbf:nCosArt )
                  ::oDbf:nCosArt := ::oDbf:nUniArt * nCosto( ( D():TiketsLineas( ::nView ) )->cComTil, ( D():Articulos( ::nView ) ), D():Kit( ::nView ) )
               end if 

               ::oDbf:cCodPr1    := ( D():TiketsLineas( ::nView ) )->cCodPr1
               ::oDbf:cCodPr2    := ( D():TiketsLineas( ::nView ) )->cCodPr2
               ::oDbf:cValPr1    := ( D():TiketsLineas( ::nView ) )->cValPr1
               ::oDbf:cValPr2    := ( D():TiketsLineas( ::nView ) )->cValPr2

               ::oDbf:cClsDoc    := TIK_CLI
               ::oDbf:cTipDoc    := "Ticket"
               ::oDbf:cSerDoc    := ( D():Tikets( ::nView ) )->cSerTik
               ::oDbf:cNumDoc    := ( D():Tikets( ::nView ) )->cNumTik
               ::oDbf:cSufDoc    := ( D():Tikets( ::nView ) )->cSufTik

               ::oDbf:cIdeDoc    :=  ::idDocumento()
               ::oDbf:nNumLin    :=  ( D():TiketsLineas( ::nView ) )->nNumLin

               ::oDbf:nAnoDoc    := Year( ( D():Tikets( ::nView ) )->dFecTik )
               ::oDbf:nMesDoc    := Month( ( D():Tikets( ::nView ) )->dFecTik )
               ::oDbf:dFecDoc    := ( D():Tikets( ::nView ) )->dFecTik
               ::oDbf:cHorDoc    := SubStr( ( D():Tikets( ::nView ) )->cHorTik, 1, 2 )
               ::oDbf:cMinDoc    := SubStr( ( D():Tikets( ::nView ) )->cHorTik, 4, 2 )

               ::oDbf:cPrvHab    := getProveedorPorDefectoArticulo( ::oDbf:cCodArt, D():ProveedorArticulo( ::nView ) )

               ::InsertIfValid()

               ::loadValuesExtraFields()

            end if

            ( D():TiketsLineas( ::nView ) )->( dbSkip() )

         end while

      end if

      ( D():Tikets( ::nView ) )->( dbskip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD listadoArticulo() CLASS TFastVentasArticulos

   local aStockArticulo

   ( D():Articulos( ::nView ) )->( ordsetfocus( "Codigo" ) )

   ( D():Articulos( ::nView ) )->( setCustomFilter( ::getFilterArticulo() ) )

   ::setMeterTotal( ( D():Articulos( ::nView ) )->( dbCustomKeyCount() ) )

   ::setMeterText( "Procesando artículos" )

   /*
   Recorremos artículos--------------------------------------------------------
   */

   ( D():Articulos( ::nView ) )->( dbgoTop() ) 
   while !( D():Articulos( ::nView ) )->( eof() ) .and. !::lBreak

      ::oDbf:Blank()

      ::oDbf:cCodArt  := ( D():Articulos( ::nView ) )->Codigo
      ::oDbf:cPrvHab  := ( D():Articulos( ::nView ) )->cPrvHab
      ::oDbf:cNomArt  := ( D():Articulos( ::nView ) )->Nombre
      ::oDbf:cCodFam  := ( D():Articulos( ::nView ) )->Familia
      ::oDbf:cNomFam  := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
      ::oDbf:TipoIva  := ( D():Articulos( ::nView ) )->TipoIva
      ::oDbf:cCodTip  := ( D():Articulos( ::nView ) )->cCodTip
      ::oDbf:cCodTemp := ( D():Articulos( ::nView ) )->cCodTemp
      ::oDbf:cCodFab  := ( D():Articulos( ::nView ) )->cCodFab
      ::oDbf:cCodCate := ( D():Articulos( ::nView ) )->cCodCate
      ::oDbf:cCodEst  := ( D():Articulos( ::nView ) )->cCodEst
      ::oDbf:cDesUbi  := ( D():Articulos( ::nView ) )->cDesUbi
      ::oDbf:cCodEnv  := ( D():Articulos( ::nView ) )->cCodFra
      ::oDbf:nCosArt  := nCosto( nil, ( D():Articulos( ::nView ) ), D():Kit( ::nView ) )

      ::InsertIfValid()

      ::loadValuesExtraFields()

      ( D():Articulos( ::nView ) )->( dbSkip() )

      ::setMeterAutoIncremental()

   end while

   ::setMeterAutoIncremental()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddArticulo( lAppendBlank ) CLASS TFastVentasArticulos

   local aStockArticulo

   DEFAULT lAppendBlank    := .f.

   if !empty( ::oGrupoAlmacen ) .and. ( ::oGrupoAlmacen:cargo:getDesde() == ::oGrupoAlmacen:cargo:getHasta() )
      ::cAlmacenDefecto    := ::oGrupoAlmacen:cargo:getDesde()
   end if

   ( D():Articulos( ::nView ) )->( ordsetfocus( "Codigo" ) )

   ( D():Articulos( ::nView ) )->( setCustomFilter( ::getFilterArticulo() ) )

   ::setMeterTotal( ( D():Articulos( ::nView ) )->( dbCustomKeyCount() ) )

   ::setMeterText( "Procesando artículos" )

   // Recorremos artículos-----------------------------------------------------

   ( D():Articulos( ::nView ) )->( dbgoTop() ) 
   while !( D():Articulos( ::nView ) )->( eof() ) .and. !::lBreak

      aStockArticulo    := ::oStock:aStockArticulo( ( D():Articulos( ::nView ) )->Codigo, ::cAlmacenDefecto, , , , , ::dFinInf )

      if !empty( aStockArticulo )
         ::appendStockArticulo( aStockArticulo )
      end if 

      if lAppendBlank
         ::appendBlankAlmacenes( ( D():Articulos( ::nView ) )->Codigo )
      end if

      ( D():Articulos( ::nView ) )->( dbSkip() )

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

METHOD AddSqlArticulo( lAppendBlank ) CLASS TFastVentasArticulos

   local cSelArticulo

   DEFAULT lAppendBlank    := .f.

   //Excluir artículos obsoletos




   ( D():Articulos( ::nView ) )->( ordsetfocus( "Codigo" ) )

   ( D():Articulos( ::nView ) )->( setCustomFilter( ::getFilterArticulo() ) )

   ::setMeterTotal( ( D():Articulos( ::nView ) )->( dbCustomKeyCount() ) )

   ::setMeterText( "Procesando artículos" )

   // Recorremos artículos-----------------------------------------------------

   ( D():Articulos( ::nView ) )->( dbgoTop() ) 
   while !( D():Articulos( ::nView ) )->( eof() ) .and. !::lBreak

      if ( !::oTFastReportOptions:getOptionValue( "Excluir artículos obsoletos", .t. ) .or. !( D():Articulos( ::nView ) )->lObs )

         cSelArticulo   := StocksModel():getSqlAdsStockArticulo( ( D():Articulos( ::nView ) )->Codigo, ::dIniInf, ::dFinInf )
         //cSelArticulo   := StocksModel():getSqlAdsStockLote( ( D():Articulos( ::nView ) )->Codigo, ::dIniInf, ::dFinInf )

         ( cSelArticulo )->( dbGoTop() )

         while !( cSelArticulo )->( Eof() )

            if !( ::oTFastReportOptions:getOptionValue( "Excluir unidades a cero", .t. ) .AND. ( cSelArticulo )->totalUnidadesStock == 0 )

               ::oDbf:Blank()

               ::oDbf:cCodArt    := ( cSelArticulo )->Articulo
               //::oDbf:cLote      := ( cSelArticulo )->Lote
               ::oDbf:cCodAlm    := ( cSelArticulo )->Almacen
               ::oDbf:nUniArt    := ( cSelArticulo )->totalUnidadesStock
               ::oDbf:nBultos    := ( cSelArticulo )->totalBultosStock
               ::oDbf:nCajas     := ( cSelArticulo )->totalCajasStock
               //::oDbf:cCodPr1    := ( cSelArticulo )->cCodigoPropiedad1
               //::oDbf:cCodPr2    := ( cSelArticulo )->cCodigoPropiedad2
               //::oDbf:cValPr1    := ( cSelArticulo )->cValorPropiedad1
               //::oDbf:cValPr2    := ( cSelArticulo )->cValorPropiedad2
               //::oDbf:dFecCad    := ( cSelArticulo )->dFechaCaducidad

               ::fillFromArticulo()

               ::insertIfValid()
                  
               ::loadValuesExtraFields()

            end if

            ( cSelArticulo )->( dbskip() )

         end while

      end if

      ( D():Articulos( ::nView ) )->( dbSkip() )

      ::setMeterAutoIncremental()

  end while

  ::setMeterAutoIncremental()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD appendBlankAlmacenes( cCodigoArticulo )

   if ( D():Almacen( ::nView ) )->( dbseek( ::oGrupoAlmacen:Cargo:getDesde() ) )
      
      while ( D():Almacen( ::nView ) )->cCodAlm <= ::oGrupoAlmacen:Cargo:getHasta() .and. !( D():Almacen( ::nView ) )->( eof() )

         if !::existeArticuloInforme( cCodigoArticulo, ( D():Almacen( ::nView ) )->cCodAlm )
            ::appendBlankArticulo( cCodigoArticulo, ( D():Almacen( ::nView ) )->cCodAlm )
         end if 

         ( D():Almacen( ::nView ) )->( dbskip() )

      end while
      
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD existeArticuloInforme( cCodigoArticulo, cCodigoAlmacen )

RETURN ( ::oDbf:SeekInOrdBack( cCodigoArticulo + cCodigoAlmacen, "cCodAlm" ) )

//---------------------------------------------------------------------------//

METHOD appendBlankArticulo( cCodigoArticulo, cCodigoAlmacen ) CLASS TFastVentasArticulos

   DEFAULT cCodigoAlmacen  := ""

   ::oDbf:Blank()

   ::oDbf:cCodArt          := cCodigoArticulo
   ::oDbf:cCodAlm          := cCodigoAlmacen

   ::fillFromArticulo()

   ::insertIfValid()

   ::loadValuesExtraFields()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD fillFromArticulo() CLASS TFastVentasArticulos

   ::oDbf:cCodCli    := ( D():Articulos( ::nView ) )->cPrvHab
   ::oDbf:cNomArt    := ( D():Articulos( ::nView ) )->Nombre
   ::oDbf:cCodFam    := ( D():Articulos( ::nView ) )->Familia
   ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
   ::oDbf:TipoIva    := ( D():Articulos( ::nView ) )->TipoIva
   ::oDbf:cCodTip    := ( D():Articulos( ::nView ) )->cCodTip
   ::oDbf:cCodEst    := ( D():Articulos( ::nView ) )->cCodEst
   ::oDbf:cCodTemp   := ( D():Articulos( ::nView ) )->cCodTemp
   ::oDbf:cCodFab    := ( D():Articulos( ::nView ) )->cCodFab
   ::oDbf:cCodCate   := ( D():Articulos( ::nView ) )->cCodCate
   ::oDbf:nCosArt    := nCosto( nil, ( D():Articulos( ::nView ) ), D():Kit( ::nView ) )
   ::oDbf:cPrvHab    := ( D():Articulos( ::nView ) )->cPrvHab
   ::oDbf:cDesUbi    := ( D():Articulos( ::nView ) )->cDesUbi

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddProducido() CLASS TFastVentasArticulos

   ::setMeterText( "Procesando partes de producción" )
   
   ::cExpresionLine           := '( dFecOrd >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecOrd <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'

   if !::lAllArt
      ::cExpresionLine        += ' .and. ( cCodArt >= "' + ::oGrupoArticulo:Cargo:getDesde() + '" .and. cCodArt <= "' + ::oGrupoArticulo:Cargo:getHasta() + '")'
   end if

   ( D():PartesProduccionMaterial( ::nView ) )->( setCustomFilter( ::cExpresionLine ) )

   ::setMeterTotal( ( D():PartesProduccionMaterial( ::nView ) )->( OrdKeyCount() ) ) 

   ( D():PartesProduccionMaterial( ::nView ) )->( dbGoTop() )

   while !::lBreak .and. !( D():PartesProduccionMaterial( ::nView ) )->( Eof() )

      if lChkSer( ( D():PartesProduccionMaterial( ::nView ) )->cSerOrd, ::aSer )

         ::oDbf:Blank()

         ::oDbf:cCodArt    := ( D():PartesProduccionMaterial( ::nView ) )->cCodArt
         ::oDbf:cNomArt    := ( D():PartesProduccionMaterial( ::nView ) )->cNomArt

         ::oDbf:cCodFam    := ( D():PartesProduccionMaterial( ::nView ) )->cCodFam
         ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
         ::oDbf:cGrpFam    := ( D():PartesProduccionMaterial( ::nView ) )->cGrpFam
         ::oDbf:cCodTip    := ( D():PartesProduccionMaterial( ::nView ) )->cCodTip
         ::oDbf:cCodTemp   := ( D():PartesProduccionMaterial( ::nView ) )->cCodTmp
         ::oDbf:cCodFab    := ( D():PartesProduccionMaterial( ::nView ) )->cCodFab
         ::oDbf:cCodCate   := ( D():PartesProduccionMaterial( ::nView ) )->cCodCat

         ::oDbf:cCodAlm    := ( D():PartesProduccionMaterial( ::nView ) )->cAlmOrd
         ::oDbf:cDesUbi    := RetFld( ( D():PartesProduccionMaterial( ::nView ) )->cCodArt, ( D():Articulos( ::nView ) ), "cDesUbi", "Codigo" )
         ::oDbf:cCodEnv    := RetFld( ( D():PartesProduccionMaterial( ::nView ) )->cCodArt, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )                    

         ::oDbf:nBultos    := ( D():PartesProduccionMaterial( ::nView ) )->nBultos
         ::oDbf:nCajas     := ( D():PartesProduccionMaterial( ::nView ) )->nCajOrd
         ::oDbf:nUniArt    := ( D():PartesProduccionMaterial( ::nView ) )->nUndOrd
         ::oDbf:nPreArt    := ( D():PartesProduccionMaterial( ::nView ) )->nImpOrd

         ::oDbf:nBrtArt    := 0 //( D():PartesProduccionMaterial( ::nView ) )->TotalImporte()
         ::oDbf:nTotArt    := 0 //( D():PartesProduccionMaterial( ::nView ) )->TotalImporte()

         ::oDbf:cCodPr1    := ( D():PartesProduccionMaterial( ::nView ) )->cCodPr1
         ::oDbf:cCodPr2    := ( D():PartesProduccionMaterial( ::nView ) )->cCodPr2
         ::oDbf:cValPr1    := ( D():PartesProduccionMaterial( ::nView ) )->cValPr1
         ::oDbf:cValPr2    := ( D():PartesProduccionMaterial( ::nView ) )->cValPr2

         ::oDbf:cClsDoc    := PAR_PRO
         ::oDbf:cTipDoc    := "Producido"

         ::oDbf:cSerDoc    := ( D():PartesProduccionMaterial( ::nView ) )->cSerOrd
         ::oDbf:cNumDoc    := Str( ( D():PartesProduccionMaterial( ::nView ) )->nNumOrd )
         ::oDbf:cSufDoc    := ( D():PartesProduccionMaterial( ::nView ) )->cSufOrd

         ::oDbf:cIdeDoc    :=  ::idDocumento()
         ::oDbf:nNumLin    := ( D():PartesProduccionMaterial( ::nView ) )->nNumLin

         ::oDbf:nAnoDoc    := Year( ( D():PartesProduccionMaterial( ::nView ) )->dFecOrd )
         ::oDbf:nMesDoc    := Month( ( D():PartesProduccionMaterial( ::nView ) )->dFecOrd )
         ::oDbf:dFecDoc    := ( D():PartesProduccionMaterial( ::nView ) )->dFecOrd

         ::InsertIfValid( .t. )
         
         ::loadValuesExtraFields()

      end if

      ( D():PartesProduccionMaterial( ::nView ) )->( dbSkip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddConsumido() CLASS TFastVentasArticulos

   ::setMeterText( "Procesando partes de producción" )

   ::cExpresionLine        := '( dFecOrd >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecOrd <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'

   if !::lAllArt
      ::cExpresionLine     += ' .and. ( cCodArt >= "' + ::oGrupoArticulo:Cargo:getDesde() + '" .and. cCodArt <= "' + ::oGrupoArticulo:Cargo:getHasta() + '")'
   end if

   ( D():PartesProduccionMateriaPrima( ::nView ) )->( setCustomFilter( ::cExpresionLine ) )
   
   ::setMeterTotal( ( D():PartesProduccionMateriaPrima( ::nView ) )->( dbCustomKeyCount() ) )
   
   ( D():PartesProduccionMateriaPrima( ::nView ) )->( dbGoTop() )

   while !::lBreak .and. !( D():PartesProduccionMateriaPrima( ::nView ) )->( Eof() )

      if lChkSer( ( D():PartesProduccionMateriaPrima( ::nView ) )->cSerOrd, ::aSer )

         ::oDbf:Blank()

         ::oDbf:cCodArt    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cCodArt
         ::oDbf:cNomArt    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cNomArt

         ::oDbf:cCodFam    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cCodFam
         ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
         ::oDbf:cGrpFam    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cGrpFam
         ::oDbf:cCodTip    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cCodTip
         ::oDbf:cCodTemp   := ( D():PartesProduccionMateriaPrima( ::nView ) )->cCodTmp
         ::oDbf:cCodFab    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cCodFab
         ::oDbf:cCodCate   := ( D():PartesProduccionMateriaPrima( ::nView ) )->cCodCat
         ::oDbf:cCodAlm    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cAlmOrd
         ::oDbf:cDesUbi    := RetFld( ( D():PartesProduccionMateriaPrima( ::nView ) )->cCodArt, ( D():Articulos( ::nView ) ), "cDesUbi", "Codigo" )
         ::oDbf:cCodEnv    := RetFld( ( D():PartesProduccionMateriaPrima( ::nView ) )->cCodArt, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )                    

         ::oDbf:nBultos    := ( D():PartesProduccionMateriaPrima( ::nView ) )->nBultos * -1
         ::oDbf:nCajas     := ( D():PartesProduccionMateriaPrima( ::nView ) )->nCajOrd * -1
         ::oDbf:nUniArt    := ( D():PartesProduccionMateriaPrima( ::nView ) )->nUndOrd * -1
         ::oDbf:nPreArt    := ( D():PartesProduccionMateriaPrima( ::nView ) )->nImpOrd

         ::oDbf:nBrtArt    := 0 //( D():PartesProduccionMateriaPrima( ::nView ) )->TotalImporte()
         ::oDbf:nTotArt    := 0 //( D():PartesProduccionMateriaPrima( ::nView ) )->TotalImporte()

         ::oDbf:cCodPr1    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cCodPr1
         ::oDbf:cCodPr2    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cCodPr2
         ::oDbf:cValPr1    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cValPr1
         ::oDbf:cValPr2    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cValPr2

         ::oDbf:cClsDoc    := PAR_PRO
         ::oDbf:cTipDoc    := "Consumido"

         ::oDbf:cSerDoc    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cSerOrd
         ::oDbf:cNumDoc    := Str( ( D():PartesProduccionMateriaPrima( ::nView ) )->nNumOrd )
         ::oDbf:cSufDoc    := ( D():PartesProduccionMateriaPrima( ::nView ) )->cSufOrd

         ::oDbf:cIdeDoc    :=  ( D():PartesProduccionMateriaPrima( ::nView ) )->cSerOrd + Str( ( D():PartesProduccionMateriaPrima( ::nView ) )->nNumOrd ) + ( D():PartesProduccionMateriaPrima( ::nView ) )->cSufOrd
         ::oDbf:nNumLin    :=  ( D():PartesProduccionMateriaPrima( ::nView ) )->nNumLin

         ::oDbf:nAnoDoc    := Year( ( D():PartesProduccionMateriaPrima( ::nView ) )->dFecOrd )
         ::oDbf:nMesDoc    := Month( ( D():PartesProduccionMateriaPrima( ::nView ) )->dFecOrd )
         ::oDbf:dFecDoc    := ( D():PartesProduccionMateriaPrima( ::nView ) )->dFecOrd

         ::InsertIfValid( .t. )

         ::loadValuesExtraFields()

      end if

      ( D():PartesProduccionMateriaPrima( ::nView ) )->( dbSkip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddMovimientoAlmacen() CLASS TFastVentasArticulos

   ::setMeterText( "Procesando movimientos de almacén" )

   // creamos la expresion del filtro------------------------------------------
   
   ::cExpresionLine           := '( dFecMov >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecMov <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'

   if !::lAllArt
      ::cExpresionLine        += ' .and. ( cRefMov >= "' + ::oGrupoArticulo:Cargo:getDesde() + '" .and. cRefMov <= "' + ::oGrupoArticulo:Cargo:getHasta() + '")'
   end if

   // aplicamos el filtro------------------------------------------------------

   ( D():MovimientosAlmacenLineas( ::nView ) )->( setCustomFilter( ::cExpresionLine ) )
   
   // inicializamos el meter---------------------------------------------------

   ::setMeterTotal( ( D():MovimientosAlmacenLineas( ::nView ) )->( dbCustomKeyCount() ) )

   // procesamos los movimientos de almacen------------------------------------

   ( D():MovimientosAlmacenLineas( ::nView ) )->( dbgotop() )

   while !(::lBreak ) .and. !( D():MovimientosAlmacenLineas( ::nView ) )->( eof() )

      ::oDbf:Blank()

      ::oDbf:cCodArt    := ( D():MovimientosAlmacenLineas( ::nView ) )->cRefMov
      ::oDbf:cNomArt    := ( D():MovimientosAlmacenLineas( ::nView ) )->cNomMov

      ::oDbf:cCodFam    := RetFld( ( D():MovimientosAlmacenLineas( ::nView ) )->cRefMov, ( D():Articulos( ::nView ) ), "Familia", "Codigo" )
      ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
      ::oDbf:cCodTip    := RetFld( ( D():MovimientosAlmacenLineas( ::nView ) )->cRefMov, ( D():Articulos( ::nView ) ), "cCodTip", "Codigo" )
      ::oDbf:cCodTemp   := RetFld( ( D():MovimientosAlmacenLineas( ::nView ) )->cRefMov, ( D():Articulos( ::nView ) ), "cCodTemp", "Codigo" )
      ::oDbf:cCodFab    := RetFld( ( D():MovimientosAlmacenLineas( ::nView ) )->cRefMov, ( D():Articulos( ::nView ) ), "cCodFab", "Codigo" )
      ::oDbf:cCodCate   := RetFld( ( D():MovimientosAlmacenLineas( ::nView ) )->cRefMov, ( D():Articulos( ::nView ) ), "cCodCate", "Codigo" )
      ::oDbf:cCodAlm    := ( D():MovimientosAlmacenLineas( ::nView ) )->cAliMov
      ::oDbf:cAlmOrg    := ( D():MovimientosAlmacenLineas( ::nView ) )->cAloMov
      ::oDbf:cDesUbi    := RetFld( ( D():MovimientosAlmacenLineas( ::nView ) )->cRefMov, ( D():Articulos( ::nView ) ), "cDesUbi", "Codigo" )
      ::oDbf:cCodEnv    := RetFld( ( D():MovimientosAlmacenLineas( ::nView ) )->cRefMov, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )                    

      ::oDbf:nBultos    := ( D():MovimientosAlmacenLineas( ::nView ) )->nBultos
      ::oDbf:nCajas     := ( D():MovimientosAlmacenLineas( ::nView ) )->nCajMov
      if lCalCaj()
         ::oDbf:nUniArt := NotCaja( ( D():MovimientosAlmacenLineas( ::nView ) )->nCajMov ) * ( D():MovimientosAlmacenLineas( ::nView ) )->nUndMov
      else
         ::oDbf:nUniArt := ( D():MovimientosAlmacenLineas( ::nView ) )->nUndMov
      end if
      ::oDbf:nPreArt    := ( D():MovimientosAlmacenLineas( ::nView ) )->nPreDiv

      ::oDbf:nBrtArt    := 0
      ::oDbf:nTotArt    := 0

      ::oDbf:cCodPr1    := ( D():MovimientosAlmacenLineas( ::nView ) )->cCodPr1
      ::oDbf:cCodPr2    := ( D():MovimientosAlmacenLineas( ::nView ) )->cCodPr2
      ::oDbf:cValPr1    := ( D():MovimientosAlmacenLineas( ::nView ) )->cValPr1
      ::oDbf:cValPr2    := ( D():MovimientosAlmacenLineas( ::nView ) )->cValPr2

      ::oDbf:cClsDoc    := MOV_ALM
      
      do case
         case ( D():MovimientosAlmacenLineas( ::nView ) )->nTipMov <= 1
            ::oDbf:cTipDoc    := "Movimiento entre almacenes"

         case ( D():MovimientosAlmacenLineas( ::nView ) )->nTipMov == 2
            ::oDbf:cTipDoc    := "Movimiento regularización"

         case ( D():MovimientosAlmacenLineas( ::nView ) )->nTipMov == 3
            ::oDbf:cTipDoc    := "Movimiento por objetivo"

         case ( D():MovimientosAlmacenLineas( ::nView ) )->nTipMov == 4
            ::oDbf:cTipDoc    := "Movimiento consolidación"

      end case

      ::oDbf:cSerDoc    := ""
      ::oDbf:cNumDoc    := Str( ( D():MovimientosAlmacenLineas( ::nView ) )->nNumRem )
      ::oDbf:cSufDoc    := ( D():MovimientosAlmacenLineas( ::nView ) )->cSufRem

      ::oDbf:cIdeDoc    := Str( ( D():MovimientosAlmacenLineas( ::nView ) )->nNumRem ) + ( D():MovimientosAlmacenLineas( ::nView ) )->cSufRem
      ::oDbf:nNumLin    := ( D():MovimientosAlmacenLineas( ::nView ) )->nNumLin

      ::oDbf:nAnoDoc    := Year( ( D():MovimientosAlmacenLineas( ::nView ) )->dFecMov )
      ::oDbf:nMesDoc    := Month( ( D():MovimientosAlmacenLineas( ::nView ) )->dFecMov )
      ::oDbf:dFecDoc    := ( D():MovimientosAlmacenLineas( ::nView ) )->dFecMov

      ::oDbf:Insert()

      ( D():MovimientosAlmacenLineas( ::nView ) )->( dbskip() )
      
      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddPedidoProveedor() CLASS TFastVentasArticulos

   ::cExpresionHeader          := '( dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader          += ' .and. ( cSerPed >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )        + '" .and. cSerPed <= "'   + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionHeader          += ' .and. ( nNumPed >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() )  + '" ) .and. nNumPed <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionHeader          += ' .and. ( cSufPed >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() )       + '" .and. cSufPed <= "'   + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterProveedorIdHeader()

   // filtros para la linea----------------------------------------------------

   ::cExpresionLine           := '!Field->lControl'
   ::cExpresionLine           += ' .and. ( Field->cSerPed >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerPed <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine           += ' .and. ( Field->nNumPed >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumPed <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine           += ' .and. ( Field->cSufPed >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() ) + '" .and. Field->cSufPed <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterProductIdLine()

   ::setFilterTypeLine()

   ::setMeterText( "Procesando pedidos a proveedor" )

   // Establecer ordenes y filtros---------------------------------------------

   ( D():PedidosProveedores( ::nView ) )->( ordsetfocus( "nNumPed" ) )
   ( D():PedidosProveedores( ::nView ) )->( setCustomFilter( ::cExpresionHeader ) )

   ( D():PedidosProveedoresLineas( ::nView ) )->( ordsetfocus( "nNumPed" ) )
   ( D():PedidosProveedoresLineas( ::nView ) )->( setCustomFilter( ::cExpresionLine ) )

   ::setMeterTotal( ( D():PedidosProveedoresLineas( ::nView ) )->( dbcustomkeycount() ) )

   // empezamos a procesar pedidos---------------------------------------------

   ( D():PedidosProveedoresLineas( ::nView ) )->( dbgotop() )
   while !::lBreak .and. !( D():PedidosProveedoresLineas( ::nView ) )->( eof() )

      if ( D():PedidosProveedores( ::nView ) )->( dbseek( D():PedidosProveedoresLineasId( ::nView ) ) )

         ::oDbf:Blank()

         ::oDbf:cClsDoc    := PED_PRV
         ::oDbf:cTipDoc    := "Pedido proveedor"
         ::oDbf:cSerDoc    := ( D():PedidosProveedoresLineas( ::nView ) )->cSerPed
         ::oDbf:cNumDoc    := Str( ( D():PedidosProveedoresLineas( ::nView ) )->nNumPed )
         ::oDbf:cSufDoc    := ( D():PedidosProveedoresLineas( ::nView ) )->cSufPed

         ::oDbf:cIdeDoc    :=  ::idDocumento()

         ::oDbf:nNumLin    := ( D():PedidosProveedoresLineas( ::nView ) )->nNumLin
         ::oDbf:cCodArt    := ( D():PedidosProveedoresLineas( ::nView ) )->cRef
         ::oDbf:cNomArt    := ( D():PedidosProveedoresLineas( ::nView ) )->cDetalle

         ::oDbf:cCodPr1    := ( D():PedidosProveedoresLineas( ::nView ) )->cCodPr1
         ::oDbf:cCodPr2    := ( D():PedidosProveedoresLineas( ::nView ) )->cCodPr2
         ::oDbf:cValPr1    := ( D():PedidosProveedoresLineas( ::nView ) )->cValPr1
         ::oDbf:cValPr2    := ( D():PedidosProveedoresLineas( ::nView ) )->cValPr2

         ::oDbf:cCodFam    := ( D():PedidosProveedoresLineas( ::nView ) )->cCodFam
         ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
         ::oDbf:TipoIva    := cCodigoIva( D():TiposIva( ::nView ), ( D():PedidosProveedoresLineas( ::nView ) )->nIva )
         ::oDbf:cCodTip    := RetFld( ( D():PedidosProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodTip", "Codigo" )
         ::oDbf:cCodEst    := RetFld( ( D():PedidosProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodEst", "Codigo" )
         ::oDbf:cCodTemp   := RetFld( ( D():PedidosProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodTemp", "Codigo" )
         ::oDbf:cCodFab    := RetFld( ( D():PedidosProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFab", "Codigo" )
         ::oDbf:cCodCate   := RetFld( ( D():PedidosProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodCate", "Codigo" )
         ::oDbf:cCodGrp    := RetFld( ( D():PedidosProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "GrpVent", "Codigo" )
         ::oDbf:cDesUbi    := RetFld( ( D():PedidosProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cDesUbi", "Codigo" )
         ::oDbf:cCodEnv    := RetFld( ( D():PedidosProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )

         ::oDbf:cCtrCoste  := ( D():PedidosProveedoresLineas( ::nView ) )->cCtrCoste
         ::oDbf:cTipCtr    := ( D():PedidosProveedoresLineas( ::nView ) )->cTipCtr
         ::oDbf:cCodTerCtr := ( D():PedidosProveedoresLineas( ::nView ) )->cTerCtr
         ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ( D():PedidosProveedoresLineas( ::nView ) )->cTipCtr, ( D():PedidosProveedoresLineas( ::nView ) )->cTerCtr, ::nView )

         ::oDbf:nUniArt    := nTotNPedPrv( D():PedidosProveedoresLineas( ::nView ) )
         ::oDbf:nPreArt    := nImpUPedPrv( D():PedidosProveedores( ::nView ), D():PedidosProveedoresLineas( ::nView ), ::nDerOut, ::nValDiv )

         ::oDbf:nDtoArt    := ( D():PedidosProveedoresLineas( ::nView ) )->nDtoLin                     
         ::oDbf:nPrmArt    := ( D():PedidosProveedoresLineas( ::nView ) )->nDtoPrm

         ::oDbf:nTotDto    := nDtoLPedPrv( D():PedidosProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nTotPrm    := nPrmLPedPrv( D():PedidosProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nBrtArt    := nBrtLPedPrv( D():PedidosProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nImpArt    := nImpLPedPrv( D():PedidosProveedores( ::nView ), D():PedidosProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nIvaArt    := nIvaLPedPrv( D():PedidosProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         
         ::oDbf:nTotArt    := nImpLPedPrv( D():PedidosProveedores( ::nView ), D():PedidosProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLPedPrv( D():PedidosProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nCosArt    := nImpLPedPrv( D():PedidosProveedores( ::nView ), D():PedidosProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )

         ::oDbf:nBultos    := ( D():PedidosProveedoresLineas( ::nView ) )->nBultos   
         ::oDbf:cFormato   := ( D():PedidosProveedoresLineas( ::nView ) )->cFormato
         ::oDbf:nCajas     := ( D():PedidosProveedoresLineas( ::nView ) )->nCanPed
         ::oDbf:cCodAlm    := ( D():PedidosProveedoresLineas( ::nView ) )->cAlmLin

         // Datos de la cabecera-----------------------------------------------

         ::oDbf:nAnoDoc    := Year( ( D():PedidosProveedores( ::nView ) )->dFecPed )
         ::oDbf:nMesDoc    := Month( ( D():PedidosProveedores( ::nView ) )->dFecPed )
         ::oDbf:dFecDoc    := ( D():PedidosProveedores( ::nView ) )->dFecPed
         ::oDbf:cHorDoc    := SubStr( ( D():PedidosProveedores( ::nView ) )->cTimChg, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ( D():PedidosProveedores( ::nView ) )->cTimChg, 4, 2 )

         ::oDbf:cCodCli    := ( D():PedidosProveedores( ::nView ) )->cCodPrv
         ::oDbf:cNomCli    := ( D():PedidosProveedores( ::nView ) )->cNomPrv
         ::oDbf:cPobCli    := ( D():PedidosProveedores( ::nView ) )->cPobPrv
         ::oDbf:cPrvCli    := ( D():PedidosProveedores( ::nView ) )->cProPrv
         ::oDbf:cPosCli    := ( D():PedidosProveedores( ::nView ) )->cPosPrv
         ::oDbf:cCodPago   := ( D():PedidosProveedores( ::nView ) )->cCodPgo
         ::oDbf:cCodUsr    := ( D():PedidosProveedores( ::nView ) )->cCodUsr

         ::insertIfValid()
                  
         ::loadValuesExtraFields()

      endif

      ( D():PedidosProveedoresLineas( ::nView ) )->( dbskip() )

      ::setMeterAutoIncremental()

   end while

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

    // filtros para la linea----------------------------------------------------

   ::cExpresionLine           := '!Field->lControl'
   ::cExpresionLine           += ' .and. ( Field->cSerAlb >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerAlb <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine           += ' .and. ( Field->nNumAlb >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumAlb <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine           += ' .and. ( Field->cSufAlb >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() ) + '" .and. Field->cSufAlb <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterTypeLine()

   ::setFilterProductIdLine()

   ( D():AlbaranesProveedores( ::nView ) )->( ordsetfocus( "nNumAlb" ) )
   ( D():AlbaranesProveedores( ::nView ) )->( setCustomFilter( ::cExpresionHeader ) )

   ( D():AlbaranesProveedoresLineas( ::nView ) )->( ordsetfocus( "nNumAlb" ) )
   ( D():AlbaranesProveedoresLineas( ::nView ) )->( setCustomFilter( ::cExpresionLine ) )

   ::setMeterText( "Procesando albaranes a proveedor" )
   ::setMeterTotal( ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbcustomkeycount() ) )

   ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbgotop() )
   while !::lBreak .and. !( D():AlbaranesProveedoresLineas( ::nView ) )->( eof() )

      if ( D():AlbaranesProveedores( ::nView ) )->( dbseek( D():AlbaranesProveedoresLineasId( ::nView ) ) )

         ::oDbf:Blank()

         ::oDbf:cClsDoc    := ALB_PRV
         ::oDbf:cTipDoc    := "Albarán proveedor"
         ::oDbf:cSerDoc    := ( D():AlbaranesProveedoresLineas( ::nView ) )->cSerAlb
         ::oDbf:cNumDoc    := Str( ( D():AlbaranesProveedoresLineas( ::nView ) )->nNumAlb )
         ::oDbf:cSufDoc    := ( D():AlbaranesProveedoresLineas( ::nView ) )->cSufAlb

         ::oDbf:cIdeDoc    :=  ::idDocumento()

         ::oDbf:nNumLin    := ( D():AlbaranesProveedoresLineas( ::nView ) )->nNumLin
         ::oDbf:cCodArt    := ( D():AlbaranesProveedoresLineas( ::nView ) )->cRef
         ::oDbf:cNomArt    := ( D():AlbaranesProveedoresLineas( ::nView ) )->cDetalle

         ::oDbf:cCodPr1    := ( D():AlbaranesProveedoresLineas( ::nView ) )->cCodPr1
         ::oDbf:cCodPr2    := ( D():AlbaranesProveedoresLineas( ::nView ) )->cCodPr2
         ::oDbf:cValPr1    := ( D():AlbaranesProveedoresLineas( ::nView ) )->cValPr1
         ::oDbf:cValPr2    := ( D():AlbaranesProveedoresLineas( ::nView ) )->cValPr2

         ::oDbf:cCodFam    := ( D():AlbaranesProveedoresLineas( ::nView ) )->cCodFam
         ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
         ::oDbf:TipoIva    := cCodigoIva( D():TiposIva( ::nView ), ( D():AlbaranesProveedoresLineas( ::nView ) )->nIva )
         ::oDbf:cCodTip    := RetFld( ( D():AlbaranesProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodTip", "Codigo" )
         ::oDbf:cCodEst    := RetFld( ( D():AlbaranesProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodEst", "Codigo" )
         ::oDbf:cCodTemp   := RetFld( ( D():AlbaranesProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodTemp", "Codigo" )
         ::oDbf:cCodFab    := RetFld( ( D():AlbaranesProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFab", "Codigo" )
         ::oDbf:cCodCate   := RetFld( ( D():AlbaranesProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodCate", "Codigo" )
         ::oDbf:cCodGrp    := RetFld( ( D():AlbaranesProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "GrpVent", "Codigo" )
         ::oDbf:cDesUbi    := RetFld( ( D():AlbaranesProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cDesUbi", "Codigo" )
         ::oDbf:cCodEnv    := RetFld( ( D():AlbaranesProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )

         ::oDBf:cCtrCoste  := ( D():AlbaranesProveedoresLineas( ::nView ) )->cCtrCoste
         ::oDbf:cTipCtr    := ( D():AlbaranesProveedoresLineas( ::nView ) )->cTipCtr
         ::oDbf:cCodTerCtr := ( D():AlbaranesProveedoresLineas( ::nView ) )->cTerCtr
         ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ( D():AlbaranesProveedoresLineas( ::nView ) )->cTipCtr, ( D():AlbaranesProveedoresLineas( ::nView ) )->cTerCtr, ::nView )

         ::oDbf:nUniArt    := nTotNAlbPrv( D():AlbaranesProveedoresLineas( ::nView ) )
         ::oDbf:nDtoArt    := ( D():AlbaranesProveedoresLineas( ::nView ) )->nDtoLin                     
         ::oDbf:nPrmArt    := ( D():AlbaranesProveedoresLineas( ::nView ) )->nDtoPrm

         ::oDbf:nBrtArt    := nBrtLAlbPrv( D():AlbaranesProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nIvaArt    := nIvaLAlbPrv( D():AlbaranesProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nTotDto    := nDtoLAlbPrv( D():AlbaranesProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nTotPrm    := nPrmLAlbPrv( D():AlbaranesProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:cLote      := ( D():AlbaranesProveedoresLineas( ::nView ) )->cLote
         ::oDbf:dFecCad    := ( D():AlbaranesProveedoresLineas( ::nView ) )->dFecCad

         ::oDbf:nBultos    := ( D():AlbaranesProveedoresLineas( ::nView ) )->nBultos
         ::oDbf:cFormato   := ( D():AlbaranesProveedoresLineas( ::nView ) )->cFormato
         ::oDBf:nCajas     := ( D():AlbaranesProveedoresLineas( ::nView ) )->nCanEnt
         ::oDbf:cCodAlm    := ( D():AlbaranesProveedoresLineas( ::nView ) )->cAlmLin

         ::oDbf:nPreArt    := nImpUAlbPrv( D():AlbaranesProveedores( ::nView ), D():AlbaranesProveedoresLineas( ::nView ), ::nDerOut, ::nValDiv )

         ::oDbf:nImpArt    := nImpLAlbPrv( D():AlbaranesProveedores( ::nView ), D():AlbaranesProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nTotArt    := nImpLAlbPrv( D():AlbaranesProveedores( ::nView ), D():AlbaranesProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLAlbPrv( D():AlbaranesProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nCosArt    := nImpLAlbPrv( D():AlbaranesProveedores( ::nView ), D():AlbaranesProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )

         ::oDbf:nAnoDoc    := Year( ( D():AlbaranesProveedores( ::nView ) )->dFecAlb )
         ::oDbf:nMesDoc    := Month( ( D():AlbaranesProveedores( ::nView ) )->dFecAlb )
         ::oDbf:dFecDoc    := ( D():AlbaranesProveedores( ::nView ) )->dFecAlb
         ::oDbf:cHorDoc    := SubStr( ( D():AlbaranesProveedores( ::nView ) )->cTimChg, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ( D():AlbaranesProveedores( ::nView ) )->cTimChg, 4, 2 )

         ::oDbf:cCodCli    := ( D():AlbaranesProveedores( ::nView ) )->cCodPrv
         ::oDbf:cNomCli    := ( D():AlbaranesProveedores( ::nView ) )->cNomPrv
         ::oDbf:cPobCli    := ( D():AlbaranesProveedores( ::nView ) )->cPobPrv
         ::oDbf:cPrvCli    := ( D():AlbaranesProveedores( ::nView ) )->cProPrv
         ::oDbf:cPosCli    := ( D():AlbaranesProveedores( ::nView ) )->cPosPrv
         ::oDbf:cCodPago   := ( D():AlbaranesProveedores( ::nView ) )->cCodPgo
         ::oDbf:cCodUsr    := ( D():AlbaranesProveedores( ::nView ) )->cCodUsr
         ::oDbf:cPrvHab    := ( D():AlbaranesProveedores( ::nView ) )->cCodPrv


         ::InsertIfValid()

         ::loadValuesExtraFields()
      
      end if

      ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbskip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaProveedor( cCodigoArticulo ) CLASS TFastVentasArticulos

   ::cExpresionHeader      := '( Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSerFac >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() ) + '" .and. Field->cSerFac <= "'    + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionHeader      += ' .and. ( Field->nNumFac >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumFac <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() ) + '" .and. Field->cSufFac <= "'    + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterProveedorIdHeader()

   /*
   Lineas de facturas----------------------------------------------------------
   */

   ::cExpresionLine           := '!Field->lControl'
   ::cExpresionLine           += ' .and. ( Field->cSerFac >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerFac <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine           += ' .and. ( Field->nNumFac >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumFac <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine           += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() ) + '" .and. Field->cSufFac <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterProductIdLine()

   ( D():FacturasProveedores( ::nView ) )->( ordsetfocus( "nNumFac" ) )
   ( D():FacturasProveedores( ::nView ) )->( setCustomFilter( ::cExpresionHeader ) )

   ( D():FacturasProveedoresLineas( ::nView ) )->( ordsetfocus( "nNumFac" ) )
   ( D():FacturasProveedoresLineas( ::nView ) )->( setCustomFilter( ::cExpresionLine ) )

   ::setMeterText( "Procesando facturas proveedor" )
   
   ::setMeterTotal( ( D():FacturasProveedoresLineas( ::nView ) )->( dbcustomkeycount() ) )

   ( D():FacturasProveedoresLineas( ::nView ) )->( dbgotop() )

   while !::lBreak .and. !( D():FacturasProveedoresLineas( ::nView ) )->( eof() )

      if ( D():FacturasProveedores( ::nView ) )->( dbseek( D():FacturasProveedoresLineasId( ::nView ) ) )

         ::oDbf:Blank()

         ::oDbf:cClsDoc    := FAC_PRV
         ::oDbf:cTipDoc    := "Factura proveedor"
         ::oDbf:cSerDoc    := ( D():FacturasProveedoresLineas( ::nView ) )->cSerFac
         ::oDbf:cNumDoc    := Str( ( D():FacturasProveedoresLineas( ::nView ) )->nNumFac )
         ::oDbf:cSufDoc    := ( D():FacturasProveedoresLineas( ::nView ) )->cSufFac

         ::oDbf:cIdeDoc    := ::idDocumento()

         ::oDbf:nNumLin    := ( D():FacturasProveedoresLineas( ::nView ) )->nNumLin
         ::oDbf:cCodArt    := ( D():FacturasProveedoresLineas( ::nView ) )->cRef
         ::oDbf:cNomArt    := ( D():FacturasProveedoresLineas( ::nView ) )->cDetalle

         ::oDbf:cCodPr1    := ( D():FacturasProveedoresLineas( ::nView ) )->cCodPr1
         ::oDbf:cCodPr2    := ( D():FacturasProveedoresLineas( ::nView ) )->cCodPr2
         ::oDbf:cValPr1    := ( D():FacturasProveedoresLineas( ::nView ) )->cValPr1
         ::oDbf:cValPr2    := ( D():FacturasProveedoresLineas( ::nView ) )->cValPr2

         ::oDbf:cCodFam    := ( D():FacturasProveedoresLineas( ::nView ) )->cCodFam
         ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
         ::oDbf:TipoIva    := cCodigoIva( D():TiposIva( ::nView ), ( D():FacturasProveedoresLineas( ::nView ) )->nIva )
         ::oDbf:cCodTip    := RetFld( ( D():FacturasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodTip", "Codigo" )
         ::oDbf:cCodEst    := RetFld( ( D():FacturasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodEst", "Codigo" )
         ::oDbf:cCodTemp   := RetFld( ( D():FacturasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodTemp", "Codigo" )
         ::oDbf:cCodFab    := RetFld( ( D():FacturasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFab", "Codigo" )
         ::oDbf:cCodCate   := RetFld( ( D():FacturasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodCate", "Codigo" )
         ::oDbf:cCodGrp    := RetFld( ( D():FacturasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "GrpVent", "Codigo" )
         ::oDbf:cDesUbi    := RetFld( ( D():FacturasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cDesUbi", "Codigo" )
         ::oDbf:cCodEnv    := RetFld( ( D():FacturasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )
      
         ::oDbf:cCtrCoste  := ( D():FacturasProveedoresLineas( ::nView ) )->cCtrCoste
         ::oDbf:cTipCtr    := ( D():FacturasProveedoresLineas( ::nView ) )->cTipCtr
         ::oDbf:cCodTerCtr := ( D():FacturasProveedoresLineas( ::nView ) )->cTerCtr
         ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ( D():FacturasProveedoresLineas( ::nView ) )->cTipCtr, ( D():FacturasProveedoresLineas( ::nView ) )->cTerCtr, ::nView )
      
         ::oDbf:nUniArt    := nTotNFacPrv( D():FacturasProveedoresLineas( ::nView ) )
         ::oDbf:nDtoArt    := ( D():FacturasProveedoresLineas( ::nView ) )->nDtoLin                     
         ::oDbf:nPrmArt    := ( D():FacturasProveedoresLineas( ::nView ) )->nDtoPrm

         ::oDbf:nBrtArt    := nBrtLFacPrv( D():FacturasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nIvaArt    := nIvaLFacPrv( D():FacturasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nTotDto    := nDtoLFacPrv( D():FacturasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nTotPrm    := nPrmLFacPrv( D():FacturasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:cLote      := ( D():FacturasProveedoresLineas( ::nView ) )->cLote
         ::oDbf:dFecCad    := ( D():FacturasProveedoresLineas( ::nView ) )->dFecCad

         ::oDbf:nBultos    := ( D():FacturasProveedoresLineas( ::nView ) )->nBultos
         ::oDbf:cFormato   := ( D():FacturasProveedoresLineas( ::nView ) )->cFormato
         ::oDbf:nCajas     := ( D():FacturasProveedoresLineas( ::nView ) )->nCanEnt
         ::oDbf:cCodAlm    := ( D():FacturasProveedoresLineas( ::nView ) )->cAlmLin

         ::oDbf:nPreArt    := nImpUFacPrv( D():FacturasProveedores( ::nView ), D():FacturasProveedoresLineas( ::nView ), ::nDerOut, ::nValDiv )

         ::oDbf:nImpArt    := nImpLFacPrv( D():FacturasProveedores( ::nView ), D():FacturasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nTotArt    := nImpLFacPrv( D():FacturasProveedores( ::nView ), D():FacturasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLFacPrv( D():FacturasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nCosArt    := nImpLFacPrv( D():FacturasProveedores( ::nView ), D():FacturasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )

         ::oDbf:nAnoDoc    := Year( ( D():FacturasProveedores( ::nView ) )->dFecFac )
         ::oDbf:nMesDoc    := Month( ( D():FacturasProveedores( ::nView ) )->dFecFac )
         ::oDbf:dFecDoc    := ( D():FacturasProveedores( ::nView ) )->dFecFac
         ::oDbf:cHorDoc    := SubStr( ( D():FacturasProveedores( ::nView ) )->cTimChg, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ( D():FacturasProveedores( ::nView ) )->cTimChg, 4, 2 )

         ::oDbf:cCodCli    := ( D():FacturasProveedores( ::nView ) )->cCodPrv
         ::oDbf:cNomCli    := ( D():FacturasProveedores( ::nView ) )->cNomPrv
         ::oDbf:cPobCli    := ( D():FacturasProveedores( ::nView ) )->cPobPrv
         ::oDbf:cPrvCli    := ( D():FacturasProveedores( ::nView ) )->cProvProv
         ::oDbf:cPosCli    := ( D():FacturasProveedores( ::nView ) )->cPosPrv
         ::oDbf:cCodPago   := ( D():FacturasProveedores( ::nView ) )->cCodPago
         ::oDbf:cCodAge    := ( D():FacturasProveedores( ::nView ) )->cCodAge
         ::oDbf:cCodUsr    := ( D():FacturasProveedores( ::nView ) )->cCodUsr
         ::oDbf:cPrvHab    := ( D():FacturasProveedores( ::nView ) )->cCodPrv

         ::InsertIfValid()

         ::loadValuesExtraFields()

      end if

      ( D():FacturasProveedoresLineas( ::nView ) )->( dbskip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddRectificativaProveedor( cCodigoArticulo ) CLASS TFastVentasArticulos

   ::cExpresionHeader      := '( Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSerFac >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() ) + '" .and. Field->cSerFac <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionHeader      += ' .and. ( Field->nNumFac >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumFac <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionHeader      += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() ) + '" .and. Field->cSufFac <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterProveedorIdHeader()

   /*
   Lineas de facturas----------------------------------------------------------
   */

   ::cExpresionLine           := '!Field->lControl'
   ::cExpresionLine           += ' .and. ( Field->cSerFac >= "' + Rtrim( ::oGrupoSerie:Cargo:getDesde() )   + '" .and. Field->cSerFac <= "' + Rtrim( ::oGrupoSerie:Cargo:getHasta() ) + '" )'
   ::cExpresionLine           += ' .and. ( Field->nNumFac >= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getDesde() ) + '" ) .and. Field->nNumFac <= Val( "' + Rtrim( ::oGrupoNumero:Cargo:getHasta() ) + '" ) )'
   ::cExpresionLine           += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:getDesde() ) + '" .and. Field->cSufFac <= "' + Rtrim( ::oGrupoSufijo:Cargo:getHasta() ) + '" )'

   ::setFilterProductIdLine()

   ( D():FacturasRectificativasProveedores( ::nView ) )->( ordsetfocus( "nNumFac" ) )
   ( D():FacturasRectificativasProveedores( ::nView ) )->( setCustomFilter( ::cExpresionHeader ) )

   ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->( ordsetfocus( "nNumFac" ) )
   ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->( setCustomFilter( ::cExpresionLine ) )

   ::setMeterText( "Procesando rectificativas" )
   ::setMeterTotal( ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->( dbcustomkeycount() ) )

   ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->( dbgotop() )

   while !::lBreak .and. !( D():FacturasRectificativasProveedoresLineas( ::nView ) )->( eof() )

      if ( D():FacturasRectificativasProveedores( ::nView ) )->( dbseek( D():FacturasRectificativasProveedoresLineasId( ::nView ) ) )

         ::oDbf:Blank()

         ::oDbf:cClsDoc    := RCT_PRV
         ::oDbf:cTipDoc    := "Rectificativa proveedor"
         ::oDbf:cSerDoc    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cSerFac
         ::oDbf:cNumDoc    := Str( ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->nNumFac )
         ::oDbf:cSufDoc    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cSufFac

         ::oDbf:cIdeDoc    := ::idDocumento()

         ::oDbf:nNumLin    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->nNumLin
         ::oDbf:cCodArt    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cRef
         ::oDbf:cNomArt    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cDetalle

         ::oDbf:cCodPr1    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cCodPr1
         ::oDbf:cCodPr2    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cCodPr2
         ::oDbf:cValPr1    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cValPr1
         ::oDbf:cValPr2    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cValPr2

         ::oDbf:cCodFam    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cCodFam
         ::oDbf:cNomFam    := RetFld( ::oDbf:cCodFam, D():Familias( ::nView ) )
         ::oDbf:TipoIva    := cCodigoIva( D():TiposIva( ::nView ), ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->nIva )
         ::oDbf:cCodTip    := RetFld( ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodTip", "Codigo" )
         ::oDbf:cCodEst    := RetFld( ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodEst", "Codigo" )
         ::oDbf:cCodTemp   := RetFld( ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodTemp", "Codigo" )
         ::oDbf:cCodFab    := RetFld( ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFab", "Codigo" )
         ::oDbf:cCodCate   := RetFld( ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodCate", "Codigo" )
         ::oDbf:cCodGrp    := RetFld( ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "GrpVent", "Codigo" )
         ::oDbf:cDesUbi    := RetFld( ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cDesUbi", "Codigo" )
         ::oDbf:cCodEnv    := RetFld( ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cRef, ( D():Articulos( ::nView ) ), "cCodFra", "Codigo" )
         
         ::oDbf:cCtrCoste  := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cCtrCoste
         ::oDbf:cTipCtr    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cTipCtr
         ::oDbf:cCodTerCtr := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cTerCtr
         ::oDbf:cNomTerCtr := NombreTerceroCentroCoste( ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cTipCtr, ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cTerCtr, ::nView )
      
         ::oDbf:nUniArt    := nTotNFacPrv( D():FacturasRectificativasProveedoresLineas( ::nView ) )
         ::oDbf:nDtoArt    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->nDtoLin                     
         ::oDbf:nPrmArt    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->nDtoPrm

         ::oDbf:nBrtArt    := nBrtLFacPrv( D():FacturasRectificativasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nIvaArt    := nIvaLFacPrv( D():FacturasRectificativasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:nTotDto    := nDtoLFacPrv( D():FacturasRectificativasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nTotPrm    := nPrmLFacPrv( D():FacturasRectificativasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )

         ::oDbf:cLote      := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cLote
         ::oDbf:dFecCad    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->dFecCad

         ::oDbf:nBultos    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->nBultos
         ::oDbf:cFormato   := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cFormato
         ::oDbf:nCajas     := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->nCanEnt
         ::oDbf:cCodAlm    := ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->cAlmLin

         ::oDbf:nPreArt    := nImpUFacPrv( D():FacturasRectificativasProveedores( ::nView ), D():FacturasRectificativasProveedoresLineas( ::nView ), ::nDerOut, ::nValDiv )

         ::oDbf:nImpArt    := nImpLFacPrv( D():FacturasRectificativasProveedores( ::nView ), D():FacturasRectificativasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
         ::oDbf:nTotArt    := nImpLFacPrv( D():FacturasRectificativasProveedores( ::nView ), D():FacturasRectificativasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
         ::oDbf:nTotArt    += nIvaLFacPrv( D():FacturasRectificativasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv )
         ::oDbf:nCosArt    := nImpLFacPrv( D():FacturasRectificativasProveedores( ::nView ), D():FacturasRectificativasProveedoresLineas( ::nView ), ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )

         ::oDbf:nAnoDoc    := Year( ( D():FacturasRectificativasProveedores( ::nView ) )->dFecFac )
         ::oDbf:nMesDoc    := Month( ( D():FacturasRectificativasProveedores( ::nView ) )->dFecFac )
         ::oDbf:dFecDoc    := ( D():FacturasRectificativasProveedores( ::nView ) )->dFecFac
         ::oDbf:cHorDoc    := SubStr( ( D():FacturasRectificativasProveedores( ::nView ) )->cTimChg, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ( D():FacturasRectificativasProveedores( ::nView ) )->cTimChg, 4, 2 )

         ::oDbf:cCodCli    := ( D():FacturasRectificativasProveedores( ::nView ) )->cCodPrv
         ::oDbf:cNomCli    := ( D():FacturasRectificativasProveedores( ::nView ) )->cNomPrv
         ::oDbf:cPobCli    := ( D():FacturasRectificativasProveedores( ::nView ) )->cPobPrv
         ::oDbf:cPrvCli    := ( D():FacturasRectificativasProveedores( ::nView ) )->cProvProv
         ::oDbf:cPosCli    := ( D():FacturasRectificativasProveedores( ::nView ) )->cPosPrv
         ::oDbf:cCodPago   := ( D():FacturasRectificativasProveedores( ::nView ) )->cCodPago
         ::oDbf:cCodAge    := ( D():FacturasRectificativasProveedores( ::nView ) )->cCodAge
         ::oDbf:cCodUsr    := ( D():FacturasRectificativasProveedores( ::nView ) )->cCodUsr
         ::oDbf:cPrvHab    := ( D():FacturasRectificativasProveedores( ::nView ) )->cCodPrv

         ::InsertIfValid()

         ::loadValuesExtraFields()

      end if

      ( D():FacturasRectificativasProveedoresLineas( ::nView ) )->( dbskip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GetInformacionEntrada( cCodArt, cLote, cDatoRequerido ) 

   local cDato := ::GetDatoMovimientosAlamcen( cCodArt, cLote, cDatoRequerido )

RETURN if ( !empty( cDato ), cDato, ::GetDatoAlbaranProveedor( cCodArt, cLote, cDatoRequerido ) )

//---------------------------------------------------------------------------//

METHOD GetDatoAlbaranProveedor( idArticulo, cLote, cCampoRequerido )

   local Resultado
   local nFieldPosition

   DEFAULT cCampoRequerido    := "dFecAlb"

   D():getStatusAlbaranesProveedoresLineas( ::nView )

   ( D():AlbaranesProveedoresLineas( ::nView ) )->( ordsetfocus( "cRefFec" ) )

   if ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbseek( Padr( idArticulo, 18 ) + Padr( cLote, 12 ) ) )

      nFieldPosition          := ( D():AlbaranesProveedoresLineas( ::nView ) )->( fieldpos( cCampoRequerido ) )

      if ( nFieldPosition != 0 )
         Resultado            := ( D():AlbaranesProveedoresLineas( ::nView ) )->( fieldget( nFieldPosition ) )
      end if 
               
   end if  

   D():setStatusAlbaranesProveedoresLineas( ::nView )

RETURN ( Resultado )

//---------------------------------------------------------------------------//

METHOD GetDatoMovimientosAlamcen( cCodArt, cLote, cCampoRequerido )

   local nFieldPosition
   local Resultado            := ""

   DEFAULT cCampoRequerido    := "dFecMov"

   D():getStatusMovimientosAlmacenLineas( ::nView )

   ( D():MovimientosAlmacenLineas( ::nView ) )->( ordsetfocus( "cRefFec" ) )

   if ( D():MovimientosAlmacenLineas( ::nView ) )->( dbseek( Padr( cCodArt, 18 ) + Padr( cLote, 12 ) ) )

      nFieldPosition          := ( D():MovimientosAlmacenLineas( ::nView ) )->( fieldpos( cCampoRequerido ) )

      if ( nFieldPosition != 0 )
         Resultado            := ( D():MovimientosAlmacenLineas( ::nView ) )->( fieldget( nFieldPosition ) )
      end if
                
   end if

   D():setStatusMovimientosAlmacenLineas( ::nView )

RETURN ( Resultado )

//--------------------------------------------------------------------------//

METHOD getNumeroAlbaranProveedor() CLASS TFastVentasArticulos

   local cNumero  := ""

   D():getStatusAlbaranesProveedoresLineas( ::nView )

   ( D():AlbaranesProveedoresLineas( ::nView ) )->( ordsetfocus( "cPedPrvRef" ) )

   if ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbseek( ::getClave() ) )
      cNumero     := ( D():AlbaranesProveedoresLineas( ::nView ) )->cSerAlb + "/" + AllTrim( Str( ( D():AlbaranesProveedoresLineas( ::nView ) )->nNumAlb ) ) + "/" + ( D():AlbaranesProveedoresLineas( ::nView ) )->cSufAlb
   end if

   D():setStatusAlbaranesProveedoresLineas( ::nView )

Return ( cNumero )

//---------------------------------------------------------------------------//

METHOD getFechaAlbaranProveedor() CLASS TFastVentasArticulos

   local dFecha   := ctod( "" )

   D():getStatusAlbaranesProveedoresLineas( ::nView )
   ( D():AlbaranesProveedoresLineas( ::nView ) )->( OrdSetFocus( "cPedPrvRef" ) )

   if ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbseek( ::getClave() ) )
      dFecha     := ( D():AlbaranesProveedoresLineas( ::nView ) )->dFecAlb
   end if

   D():setStatusAlbaranesProveedoresLineas( ::nView )

Return ( dFecha )

//---------------------------------------------------------------------------//

METHOD getUnidadesAlbaranProveedor() CLASS TFastVentasArticulos

   local nUnidades   := 0

   D():getStatusAlbaranesProveedoresLineas( ::nView )
   ( D():AlbaranesProveedoresLineas( ::nView ) )->( OrdSetFocus( "cPedPrvRef" ) )

   if ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbseek( ::getClave() ) )
      nUnidades      := nTotNAlbPrv( D():AlbaranesProveedoresLineas( ::nView ) )
   end if

   D():setStatusAlbaranesProveedoresLineas( ::nView )

Return ( nUnidades )

//---------------------------------------------------------------------------//

METHOD getEstadoAlbaranProveedor() CLASS TFastVentasArticulos

   local cEstado  := "No"

   D():getStatusAlbaranesProveedoresLineas( ::nView )
   ( D():AlbaranesProveedoresLineas( ::nView ) )->( OrdSetFocus( "cPedPrvRef" ) )

   if ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbseek( ::getClave() ) )
      if ( D():AlbaranesProveedoresLineas( ::nView ) )->lFacturado
         cEstado  := "Si"
      end if
   end if

   D():setStatusAlbaranesProveedoresLineas( ::nView )

Return ( cEstado )

//---------------------------------------------------------------------------//

METHOD geFechaPedidoProveedor() CLASS TFastVentasArticulos

   local cClave   := ""
   local dFecha   := ctod( "" )

   cClave         += ::oDbf:cCodArt
   cClave         += ::oDbf:cCodPr1
   cClave         += ::oDbf:cCodPr2
   cClave         += ::oDbf:cValPr1
   cClave         += ::oDbf:cValPr2
   cClave         += ::oDbf:cLote

   D():getStatusPedidosProveedoresLineas( ::nView )
   ( D():PedidosProveedoresLineas( ::nView ) )->( OrdSetFocus( "cPedRef" ) )

   if ( D():PedidosProveedoresLineas( ::nView ) )->( dbseek( cClave ) )
      dFecha     := dFecPedPrv( ( D():PedidosProveedoresLineas( ::nView ) )->cSerPed + Str( ( D():PedidosProveedoresLineas( ::nView ) )->nNumPed ) + ( D():PedidosProveedoresLineas( ::nView ) )->cSufPed, D():PedidosProveedores( ::nView ) )
   end if

   D():setStatusPedidosProveedoresLineas( ::nView )

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

   TDataCenter():ExecuteSqlStatement( cStm, "lineasDocumento" ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadValuesExtraFields() CLASS TFastVentasArticulos

   local cField
   local uValor

   if isArray( ::aExtraFields ) .and. len( ::aExtraFields ) != 0

      for each cField in ::aExtraFields
         
         uValor             := ::oCamposExtra:valueExtraField( cField[ "código" ], ::oDbf:cCodArt, cField )

         ::oDbf:fieldPutByName( "fld" + cField[ "código" ], uValor )

      next

   end if

Return ( self )

//--------------------------------------------------------------------------//

METHOD getTarifaArticulo( cCodTar, cCodArt, nPrc ) CLASS TFastVentasArticulos

   local nPrecio := 0
   ( D():TarifaPreciosLineas( ::nView ) )->( OrdSetFocus( "cCodArt" ) )

   if empty( cCodTar )
      Return nPrecio
   end if

   if empty( cCodArt )
      Return nPrecio
   end if

   if ( D():TarifaPreciosLineas( ::nView ) )->( dbseek( cCodTar + cCodArt ) )
      do case
         case nPrc == "1"
            nPrecio     := ( D():TarifaPreciosLineas( ::nView ) )->nPrcTar1

         case nPrc == "2"
            nPrecio     := ( D():TarifaPreciosLineas( ::nView ) )->nPrcTar2

         case nPrc == "3"
            nPrecio     := ( D():TarifaPreciosLineas( ::nView ) )->nPrcTar3

         case nPrc == "4"
            nPrecio     := ( D():TarifaPreciosLineas( ::nView ) )->nPrcTar4

         case nPrc == "5"
            nPrecio     := ( D():TarifaPreciosLineas( ::nView ) )->nPrcTar5

         case nPrc == "6"
            nPrecio     := ( D():TarifaPreciosLineas( ::nView ) )->nPrcTar6

      end case

   end if

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

   nOrdAnt           := ( D():PedidosProveedoresLineas( ::nView ) )->( OrdSetFocus( "nNumPedRef" ) )

   if ( D():PedidosProveedoresLineas( ::nView ) )->( dbSeek( cNumPed + cCodArt ) )
      
      nUnidades      := nTotNPedPrv( D():PedidosProveedoresLineas( ::nView ) )

   end if

   ( D():PedidosProveedoresLineas( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

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

   D():getStatusClientes( ::nView )
   
   ( D():Clientes( ::nView ) )->( OrdSetFocus( "Cod" ) )

   ( D():Clientes( ::nView ) )->( dbgotop() )
   while !( D():Clientes( ::nView ) )->( Eof() ) .and. !::lBreak

      if !( ::isClientInReport( ( D():Clientes( ::nView ) )->Cod ) )
      
         ::oDbf:Blank()
         ::oDbf:cCodCli       := ( D():Clientes( ::nView ) )->Cod
         ::oDbf:cNomCli       := ( D():Clientes( ::nView ) )->Titulo
         ::oDbf:cCodRut       := ( D():Clientes( ::nView ) )->cCodRut
         ::oDbf:cCodPago      := ( D():Clientes( ::nView ) )->CodPago
         ::oDbf:cCodAge       := ( D():Clientes( ::nView ) )->cCodAge
         ::oDbf:cCodTrn       := ( D():Clientes( ::nView ) )->cCodTrn
         ::oDbf:cCodUsr       := ( D():Clientes( ::nView ) )->cCodUsr

         ::oDbf:Insert()

      end if 

      ( D():Clientes( ::nView ) )->( dbskip() )

   end while

   D():setStatusClientes( ::nView )

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
   
   local nTotal      := 0
   local nRecAlb     := ( D():AlbaranesClientesLineas( ::nView ) )->( Recno() )
   local nOrdAlb     := ( D():AlbaranesClientesLineas( ::nView ) )->( OrdSetFocus( "cVtaFast" ) )
   local nRecFac     := ( D():FacturasClientesLineas( ::nView ) )->( Recno() )
   local nOrdFac     := ( D():FacturasClientesLineas( ::nView ) )->( OrdSetFocus( "cVtaFast" ) )
   local idLine      := padr( cCodArt, 18 ) + padr( cCodAlm, 16 ) + dtos( GetSysDate() )

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbseek( idLine ) )

      while ( D():AlbaranesClientesLineas( ::nView ) )->cRef + ( D():AlbaranesClientesLineas( ::nView ) )->cAlmLin + dtos( ( D():AlbaranesClientesLineas( ::nView ) )->dFecAlb ) == idLine .and. ;
            !( D():AlbaranesClientesLineas( ::nView ) )->( eof() )

         nTotal      += nTotNAlbCli( D():AlbaranesClientesLineas( ::nView ) ) 

         ( D():AlbaranesClientesLineas( ::nView ) )->( dbSkip() )

      end while

   end if

   if ( D():FacturasClientesLineas( ::nView ) )->( dbseek( idLine ) )

      while ( D():FacturasClientesLineas( ::nView ) )->cRef + ( D():FacturasClientesLineas( ::nView ) )->cAlmLin + dtos( ( D():FacturasClientesLineas( ::nView ) )->dFecFac ) == idLine .and. ;
            !( D():FacturasClientesLineas( ::nView ) )->( eof() )

         nTotal      += nTotNFacCli( ( D():FacturasClientesLineas( ::nView ) ) )

         ( D():FacturasClientesLineas( ::nView ) )->( dbskip() )

      end while

   end if

   ( D():AlbaranesClientesLineas( ::nView ) )->( ordsetfocus( nOrdAlb ) )
   ( D():AlbaranesClientesLineas( ::nView ) )->( dbgoto( nRecAlb ) )
   ( D():FacturasClientesLineas( ::nView ) )->( ordsetfocus( nOrdFac ) )
   ( D():FacturasClientesLineas( ::nView ) )->( dbgoto( nRecFac ) )

Return nTotal

//---------------------------------------------------------------------------//

METHOD getTotalUnidadesVendidas( cCodArt ) CLASS TFastVentasArticulos
   
   local nTotal      := 0
   local idLine      := Padr( cCodArt, 18 )
   local nRecAlb     := ( D():AlbaranesClientesLineas( ::nView ) )->( Recno() )
   local nOrdAlb     := ( D():AlbaranesClientesLineas( ::nView ) )->( OrdSetFocus( "cRef" ) )
   local nRecFac     := ( D():FacturasClientesLineas( ::nView ) )->( Recno() )
   local nOrdFac     := ( D():FacturasClientesLineas( ::nView ) )->( OrdSetFocus( "cRef" ) )
   local nRecFacRec  := ( D():FacturasRectificativasLineas( ::nView ) )->( Recno() )
   local nOrdFacRec  := ( D():FacturasRectificativasLineas( ::nView ) )->( OrdSetFocus( "cRef" ) )
   local nRecTik     := ( D():TiketsLineas( ::nView ) )->( Recno() )
   local nOrdTik     := ( D():TiketsLineas( ::nView ) )->( OrdSetFocus( "cCbaTil" ) )

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbseek( idLine ) )

      while ( D():AlbaranesClientesLineas( ::nView ) )->cRef == idLine .and. ;
            !( D():AlbaranesClientesLineas( ::nView ) )->( eof() )

         if !( D():AlbaranesClientesLineas( ::nView ) )->lFacturado
            nTotal   += nTotNAlbCli( D():AlbaranesClientesLineas( ::nView ) ) 
         end if

         ( D():AlbaranesClientesLineas( ::nView ) )->( dbSkip() )

      end while

   end if

   if ( D():FacturasClientesLineas( ::nView ) )->( dbseek( idLine ) )

      while ( D():FacturasClientesLineas( ::nView ) )->cRef == idLine .and. ;
            !( D():FacturasClientesLineas( ::nView ) )->( eof() )

         nTotal      += nTotNFacCli( ( D():FacturasClientesLineas( ::nView ) ) )

         ( D():FacturasClientesLineas( ::nView ) )->( dbskip() )

      end while

   end if

   if ( D():FacturasRectificativasLineas( ::nView ) )->( dbseek( idLine ) )

      while ( D():FacturasRectificativasLineas( ::nView ) )->cRef == idLine .and. ;
            !( D():FacturasRectificativasLineas( ::nView ) )->( eof() )

         nTotal      += nTotNFacRec( ( D():FacturasRectificativasLineas( ::nView ) ) )

         ( D():FacturasRectificativasLineas( ::nView ) )->( dbskip() )

      end while

   end if

   if ( D():TiketsLineas( ::nView ) )->( dbseek( idLine ) )

      while ( D():TiketsLineas( ::nView ) )->cCbaTil == idLine .and. ;
            !( D():TiketsLineas( ::nView ) )->( eof() )

         nTotal      += nTotNTpv( ( D():TiketsLineas( ::nView ) ) )

         ( D():TiketsLineas( ::nView ) )->( dbskip() )

      end while

   end if

   ( D():AlbaranesClientesLineas( ::nView ) )->( ordsetfocus( nOrdAlb ) )
   ( D():AlbaranesClientesLineas( ::nView ) )->( dbgoto( nRecAlb ) )
   ( D():FacturasClientesLineas( ::nView ) )->( ordsetfocus( nOrdFac ) )
   ( D():FacturasClientesLineas( ::nView ) )->( dbgoto( nRecFac ) )
   ( D():FacturasRectificativasLineas( ::nView ) )->( ordsetfocus( nOrdFacRec ) )
   ( D():FacturasRectificativasLineas( ::nView ) )->( dbgoto( nRecFacRec ) )
   ( D():TiketsLineas( ::nView ) )->( ordsetfocus( nOrdTik ) )
   ( D():TiketsLineas( ::nView ) )->( dbgoto( nRecTik ) )

Return nTotal

//---------------------------------------------------------------------------//

METHOD ValidGrupoCliente( cCodGrp ) CLASS TFastVentasArticulos

   local lValid   := .f.
   local aChild   := D():objectGruposClientes( ::nView ):aChild( cCodGrp )

   aAdd( aChild, cCodGrp )

   if aScan( aChild, ::oDbf:cCodGrp ) != 0
      lValid   := .t.
   end if

Return lValid 

//---------------------------------------------------------------------------//

METHOD getFieldMovimientoAlmacen( cField )

   local cResultField   := ""

   cResultField         := RetFld( Padr( ::oDbf:cNumDoc, 9 ) + Padr( ::oDbf:cSufDoc, 2 ), D():MovimientosAlmacen( ::nView ), cField )

Return cResultField

//---------------------------------------------------------------------------//

METHOD getSerialiceValoresPropiedades( cCodigoPropiedad ) CLASS TFastVentasArticulos

   local cSql        := "Propiedades"
   local aResult     := {}

   ArticulosModel():getValoresPropiedades( cCodigoPropiedad, @cSql )

   while !( cSql )->( Eof() )
      aAdd( aResult, AllTrim( ( cSql )->cCodTbl ) + " - " + AllTrim( ( cSql )->cDesTbl ) )
      ( cSql )->( dbSkip() )
   end while

Return ( aResult )

//---------------------------------------------------------------------------//

METHOD getPrimerValorPropiedad( cCodigoPropiedad ) CLASS TFastVentasArticulos

   local cSql        := "PrimeraPropiedades"

   ArticulosModel():getPrimerValorPropiedad( cCodigoPropiedad, @cSql )

Return ( AllTrim( ( cSql )->cCodTbl ) + " - " + AllTrim( ( cSql )->cDesTbl ) )

//---------------------------------------------------------------------------//

METHOD getClave()

   local cClave

   cClave            := ::oDbf:cSerDoc
   cClave            += padr( ::oDbf:cNumDoc, 9 )
   cClave            += ::oDbf:cSufDoc
   cClave            += ::oDbf:cCodArt
   cClave            += ::oDbf:cValPr1
   cClave            += ::oDbf:cValPr2
   cClave            += ::oDbf:cLote

Return ( cClave )

//---------------------------------------------------------------------------//

METHOD getCampoExtraAlbaranCliente( cField ) CLASS TFastVentasArticulos

Return ( getCustomExtraField( cField, "Albaranes a clientes", D():AlbaranesClientesId( ::nView ) ) )

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
