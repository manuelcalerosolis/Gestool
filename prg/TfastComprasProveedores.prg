#include "FiveWin.Ch"
#include "Factu.ch"  
#include "Report.ch"
#include "MesDbf.ch"
// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastComprasProveedores FROM TFastReportInfGen

   DATA  cType                            INIT "Proveedores"

   DATA cExpresionHeader

   DATA lApplyFilters                     INIT .t.

   METHOD lResource( cFld )

   METHOD Create()
   METHOD lGenerate()
   METHOD lValidRegister()

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD DataReport( oFr )
   METHOD AddVariable()

   METHOD StartDialog()
   METHOD BuildTree()

   METHOD AddPedidoProveedor()
   METHOD AddAlbaranProveedor()
   METHOD AddFacturaProveedor()
   METHOD AddFacturaRectificativa()
   METHOD AddProveedor()

   METHOD AddRecibosProveedor( cFieldOrder )
   METHOD AddRecibosProveedorCobro()        INLINE ( ::AddRecibosProveedor( 'dEntrada' ) )
   METHOD AddRecibosProveedorVencimiento()  INLINE ( ::AddRecibosProveedor( 'dFecVto' ) )

   METHOD idDocumento()                 INLINE ( ::oDbf:cClsDoc + ::oDbf:cSerDoc + ::oDbf:cNumDoc + space(1) + ::oDbf:cSufDoc )
   METHOD idDocumentoLinea()            INLINE ( ::idDocumento() )

   METHOD setFilterPaymentId()          INLINE ( if( ::lApplyFilters,;
                                                 ::cExpresionHeader  += ' .and. ( alltrim( Field->cCodPgo ) >= "' + alltrim( ::oGrupoFpago:Cargo:Desde ) + '" .and. alltrim( Field->cCodPgo ) <= "' + alltrim(::oGrupoFpago:Cargo:Hasta ) + '" )', ) )
   
   METHOD setFilterPaymentInvoiceId()   INLINE ( if( ::lApplyFilters,;
                                                 ::cExpresionHeader  += ' .and. ( alltrim( Field->cCodPago ) >= "' + alltrim( ::oGrupoFpago:Cargo:Desde ) + '" .and. alltrim( Field->cCodPago ) <= "' + alltrim(::oGrupoFpago:Cargo:Hasta ) + '" )', ) )
   
   METHOD setFilterProviderId()         INLINE ( if( ::lApplyFilters,;
                                                 ::cExpresionHeader  += ' .and. ( alltrim( Field->cCodPrv ) >= "' + alltrim( ::oGrupoProveedor:Cargo:Desde ) + '" .and. alltrim( Field->cCodPrv ) <= "' + alltrim( ::oGrupoProveedor:Cargo:Hasta ) + '" )', ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TFastComprasProveedores

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

   ::cSubTitle       := "Informe de compras"

   ::cTipoInforme    := "Proveedores"
   ::cBmpInforme     := "gc_businessman_64"

   if !::NewResource()
      return .f.
   end if

   /*
   Carga controles-------------------------------------------------------------
   */

   if !::lGrupoProveedor( .t. )
      return .f.
   end if

   if !::lGrupoGProveedor( .t. )
      return .f.
   end if

   if !::lGrupoFpago( .t. )
      return .f.
   end if

   if !::lGrupoIva( .t. )
      return .t.
   end if

   ::oFilter      := TFilterCreator():Init()
   if !empty( ::oFilter )
      ::oFilter:SetDatabase( ::oDbf )
      ::oFilter:SetFilterType( PRV_TBL )
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TFastComprasProveedores
   
   local oBlock
   local oError
   local lOpen          := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::cDriver         := cDriver()

      ::nView           := D():CreateView( ::cDriver )
   
      ::lApplyFilters   := lAIS()

      D():Proveedores( ::nView )

      D():PedidosProveedores( ::nView )

      D():PedidosProveedoresLineas( ::nView )

      D():AlbaranesProveedores( ::nView )

      D():AlbaranesProveedoresLineas( ::nView )

      D():FacturasProveedores( ::nView )

      D():FacturasProveedoresLineas( ::nView )

      D():FacturasProveedoresPagos( ::nView )

      D():FacturasRectificativasProveedores( ::nView )

      D():FacturasRectificativasProveedoresLineas( ::nView )

      D():TiposIva( ::nView )

      D():Divisas( ::nView )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de artículos" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TFastComprasProveedores

   if !Empty( ::nView )
      D():DeleteView( ::nView )
   end if

   ::nView     := nil

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( uParam ) CLASS TFastComprasProveedores

   ::AddField( "cCodPrv",     "C", 18, 0, {|| "@!" }, "Código proveedor"                        )
   ::AddField( "cNomPrv",     "C",100, 0, {|| ""   }, "Nombre proveedor"                        )

   ::AddField( "cCodGrp",     "C", 12, 0, {|| "@!" }, "Código grupo de proveedor"               )

   ::AddField( "cClsDoc",     "C",  2, 0, {|| "" },   "Clase de documento"                      )
   ::AddField( "cSerDoc",     "C",  1, 0, {|| "" },   "Serie del documento"                     )
   ::AddField( "cNumDoc",     "C",  9, 0, {|| "" },   "Número del documento"                    )
   ::AddField( "cSufDoc",     "C",  2, 0, {|| "" },   "Delegación del documento"                )
   ::AddField( "cNumRec",     "C",  2, 0, {|| "" },   "Número del recibo"                       )
   ::AddField( "cTipDoc",     "C", 30, 0, {|| "" },   "Tipo de documento"                       )
   ::AddField( "cIdeDoc",     "C", 27, 0, {|| "" },   "Identificador del documento"             )

   ::AddField( "cCodPgo",     "C",  2, 0, {|| "@!" }, "Código de la forma de pago"              )

   ::AddField( "nAnoDoc",     "N",  4, 0, {|| "" },   "Año del documento"                       )
   ::AddField( "nMesDoc",     "N",  2, 0, {|| "" },   "Mes del documento"                       )
   ::AddField( "dFecDoc",     "D",  8, 0, {|| "" },   "Fecha del documento"                     )
   ::AddField( "cHorDoc",     "C",  2, 0, {|| "" },   "Hora del documento"                      )
   ::AddField( "cMinDoc",     "C",  2, 0, {|| "" },   "Minutos del documento"                   )

   ::AddField( "nTotNet",     "N", 16, 6, {|| "" },   "Total neto"                              )
   ::AddField( "nTotIva",     "N", 16, 6, {|| "" },   "Total " + cImp()                         )
   ::AddField( "nTotReq",     "N", 16, 6, {|| "" },   "Total RE"                                )
   ::AddField( "nTotDoc",     "N", 16, 6, {|| "" },   "Total documento"                         )
   ::AddField( "nTotRet",     "N", 16, 6, {|| "" },   "Total retenciones"                       )
   ::AddField( "nTotPag",     "N", 16, 6, {|| "" },   "Total pagos"                             )

   ::AddField( "dEntrada",    "D",  8, 0, {|| "" },   "Fecha previsión cobro"                   )
   ::AddField( "dFecVto",     "D",  8, 0, {|| "" },   "Fecha vencimiento"                       )

   ::AddField( "lFacGas",     "L",  1, 0, {|| "" },   "Lógico factura gastos"                   )

   ::AddField( "cSrlTot",     "M", 10, 0, {|| "" },   "Total serializado"                       )

   ::AddField( "uCargo",      "C", 20, 0, {|| "" },   "Cargo"                                   )

   ::AddTmpIndex( "cCodPrv", "cCodPrv" )

RETURN ( self )

//---------------------------------------------------------------------------//

Method lValidRegister( cCodigoProveedor ) CLASS TFastComprasProveedores

   if ( ::oDbf:cCodPrv >= ::oGrupoProveedor:Cargo:Desde     .and. ::oDbf:cCodPrv <= ::oGrupoProveedor:Cargo:Hasta )  .and.;
      ( ::oDbf:cCodGrp >= ::oGrupoGProveedor:Cargo:Desde    .and. ::oDbf:cCodGrp <= ::oGrupoGProveedor:Cargo:Hasta ) .and.;
      ( ::oDbf:cCodPgo >= ::oGrupoFpago:Cargo:Desde         .and. ::oDbf:cCodPgo <= ::oGrupoFpago:Cargo:Hasta )

      Return .t.

   end if

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD AddPedidoProveedor( cCodigoProveedor ) CLASS TFastComprasProveedores

   local sTot

   ( D():PedidosProveedores( ::nView ) )->( OrdSetFocus( "dFecPed" ) )
   ( D():PedidosProveedoresLineas( ::nView ) )->( OrdSetFocus( "nNumPed" ) )

   // filtros para la cabecera------------------------------------------------

   ::cExpresionHeader                := 'Field->dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   
   ::setFilterPaymentId()
   
   ::setFilterProviderId()

   // Procesando pedidos------------------------------------------------------

   ::setMeterText( "Procesando pedidos" )

   ( D():PedidosProveedores( ::nView ) )->( setCustomFilter( ::cExpresionHeader ) )

   ::setMeterTotal( ( D():PedidosProveedores( ::nView ) )->( dbcustomkeycount() ) )

   ( D():PedidosProveedores( ::nView ) )->( dbgotop() )
   while !::lBreak .and. !( D():PedidosProveedores( ::nView ) )->( Eof() )

      sTot              := sTotPedPrv( ( D():PedidosProveedores( ::nView ) )->cSerPed + Str( ( D():PedidosProveedores( ::nView ) )->nNumPed ) + ( D():PedidosProveedores( ::nView ) )->cSufPed, D():PedidosProveedores( ::nView ), D():PedidosProveedoresLineas( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ) )

      ::oDbf:Blank()

      ::oDbf:cTipDoc    := "Pedido proveedor"
      ::oDbf:cClsDoc    := PED_PRV

      ::oDbf:cSerDoc    := ( D():PedidosProveedores( ::nView ) )->cSerPed
      ::oDbf:cNumDoc    := Str( ( D():PedidosProveedores( ::nView ) )->nNumPed )
      ::oDbf:cSufDoc    := ( D():PedidosProveedores( ::nView ) )->cSufPed

      ::oDbf:cIdeDoc    := ::idDocumento()            

      ::oDbf:cCodPrv    := ( D():PedidosProveedores( ::nView ) )->cCodPrv
      ::oDbf:cNomPrv    := ( D():PedidosProveedores( ::nView ) )->cNomPrv
      ::oDbf:cCodGrp    := RetFld( ( D():PedidosProveedores( ::nView ) )->cCodPrv, D():Proveedores( ::nView ), "cCodGrp" )
      ::oDbf:cCodPgo    := ( D():PedidosProveedores( ::nView ) )->cCodPgo

      ::oDbf:nAnoDoc    := Year( ( D():PedidosProveedores( ::nView ) )->dFecPed )
      ::oDbf:nMesDoc    := Month( ( D():PedidosProveedores( ::nView ) )->dFecPed )
      ::oDbf:dFecDoc    := ( D():PedidosProveedores( ::nView ) )->dFecPed
      ::oDbf:cHorDoc    := SubStr( ( D():PedidosProveedores( ::nView ) )->cTimChg, 1, 2 )
      ::oDbf:cMinDoc    := SubStr( ( D():PedidosProveedores( ::nView ) )->cTimChg, 3, 2 )

      ::oDbf:nTotNet    := sTot:nTotalNeto
      ::oDbf:nTotIva    := sTot:nTotalIva
      ::oDbf:nTotReq    := sTot:nTotalRecargoEquivalencia
      ::oDbf:nTotDoc    := sTot:nTotalDocumento

      if ::lValidRegister()
         ::oDbf:Insert()
      else
         ::oDbf:Cancel()
      end if

      ::addPedidosProveedores()

      ( D():PedidosProveedores( ::nView ) )->( dbskip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddAlbaranProveedor( lFacturados ) CLASS TFastComprasProveedores

   local sTot

   DEFAULT lFacturados           := .f.

   ( D():AlbaranesProveedores( ::nView ) )->( OrdSetFocus( "dFecAlb" ) )
   ( D():AlbaranesProveedoresLineas( ::nView ) )->( OrdSetFocus( "nNumAlb" ) )

   // filtros para la cabecera------------------------------------------------

   if lFacturados
      ::cExpresionHeader          := '!lFacturado .and. Field->dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   else
      ::cExpresionHeader          := 'Field->dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end if

   ::setFilterPaymentId()
   
   ::setFilterProviderId()

   // Procesando albaranes----------------------------------------------------

   ::setMeterText( "Procesando albaranes" )
   
   ( D():AlbaranesProveedores( ::nView ) )->( setCustomFilter( ::cExpresionHeader ) )

   ::setMeterTotal( ( D():AlbaranesProveedores( ::nView ) )->( dbcustomkeycount() ) )

   ( D():AlbaranesProveedores( ::nView ) )->( dbgotop() )

   while !::lBreak .and. !( D():AlbaranesProveedores( ::nView ) )->( eof() )

      sTot           := sTotAlbPrv( D():AlbaranesProveedoresId( ::nView ), D():AlbaranesProveedores( ::nView ), D():AlbaranesProveedoresLineas( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ) )
     
      ::oDbf:Blank()

      ::oDbf:cTipDoc := "Albaran proveedor"
      ::oDbf:cClsDoc := ALB_PRV

      ::oDbf:cSerDoc := ( D():AlbaranesProveedores( ::nView ) )->cSerAlb
      ::oDbf:cNumDoc := Str( ( D():AlbaranesProveedores( ::nView ) )->nNumAlb )
      ::oDbf:cSufDoc := ( D():AlbaranesProveedores( ::nView ) )->cSufAlb

      ::oDbf:cIdeDoc := ::idDocumento()            

      ::oDbf:cCodPrv := ( D():AlbaranesProveedores( ::nView ) )->cCodPrv
      ::oDbf:cNomPrv := ( D():AlbaranesProveedores( ::nView ) )->cNomPrv
      ::oDbf:cCodGrp := RetFld( ( D():AlbaranesProveedores( ::nView ) )->cCodPrv, D():Proveedores( ::nView ), "cCodGrp" )
      ::oDbf:cCodPgo := ( D():AlbaranesProveedores( ::nView ) )->cCodPgo

      ::oDbf:nAnoDoc := Year( ( D():AlbaranesProveedores( ::nView ) )->dFecAlb )
      ::oDbf:nMesDoc := Month( ( D():AlbaranesProveedores( ::nView ) )->dFecAlb )
      ::oDbf:dFecDoc := ( D():AlbaranesProveedores( ::nView ) )->dFecAlb
      ::oDbf:cHorDoc := SubStr( ( D():AlbaranesProveedores( ::nView ) )->cTimChg, 1, 2 )
      ::oDbf:cMinDoc := SubStr( ( D():AlbaranesProveedores( ::nView ) )->cTimChg, 3, 2 )

      ::oDbf:nTotNet := sTot:nTotalNeto
      ::oDbf:nTotIva := sTot:nTotalIva
      ::oDbf:nTotReq := sTot:nTotalRecargoEquivalencia
      ::oDbf:nTotDoc := sTot:nTotalDocumento

      if ::lValidRegister()
         ::oDbf:Insert()
      else
         ::oDbf:Cancel()
      end if                

      ::AddAlbaranesProveedores()

      ( D():AlbaranesProveedores( ::nView ) )->( dbskip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaProveedor( cCodigoProveedor ) CLASS TFastComprasProveedores

   local sTot
   local aTotIva

   ( D():FacturasProveedores( ::nView ) )->( OrdSetFocus( "dFecFac" ) )
   ( D():FacturasProveedoresLineas( ::nView ) )->( OrdSetFocus( "nNumFac" ) )

   // filtros para la cabecera------------------------------------------------

   ::cExpresionHeader             := 'Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   
   ::setFilterPaymentInvoiceId()
   
   ::setFilterProviderId()

   // Procesando facturas-----------------------------------------------------

   ::setMeterText( "Procesando facturas" )
   
   ( D():FacturasProveedores( ::nView ) )->( setCustomFilter( ::cExpresionHeader ) )

   ::setMeterTotal( ( D():FacturasProveedores( ::nView ) )->(dbcustomkeycount() ) )

   ( D():FacturasProveedores( ::nView ) )->( dbgotop() )
   while !::lBreak .and. !( D():FacturasProveedores( ::nView ) )->( eof() )

      sTot           := sTotFacPrv( ( D():FacturasProveedores( ::nView ) )->cSerFac + Str( ( D():FacturasProveedores( ::nView ) )->nNumFac ) + ( D():FacturasProveedores( ::nView ) )->cSufFac, D():FacturasProveedores( ::nView ), D():FacturasProveedoresLineas( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ), D():FacturasProveedoresPagos( ::nView ) )
     
      ::oDbf:Blank()

      ::oDbf:cTipDoc := "Factura proveedor"
      ::oDbf:cClsDoc := FAC_PRV

      ::oDbf:cSerDoc := ( D():FacturasProveedores( ::nView ) )->cSerFac
      ::oDbf:cNumDoc := Str( ( D():FacturasProveedores( ::nView ) )->nNumFac )
      ::oDbf:cSufDoc := ( D():FacturasProveedores( ::nView ) )->cSufFac

      ::oDbf:cIdeDoc := ::idDocumento()                                

      ::oDbf:cCodPrv := ( D():FacturasProveedores( ::nView ) )->cCodPrv
      ::oDbf:cNomPrv := ( D():FacturasProveedores( ::nView ) )->cNomPrv
      ::oDbf:cCodGrp := RetFld( ( D():FacturasProveedores( ::nView ) )->cCodPrv, D():Proveedores( ::nView ), "cCodGrp" )
      ::oDbf:cCodPgo := ( D():FacturasProveedores( ::nView ) )->cCodPago

      ::oDbf:nAnoDoc := Year( ( D():FacturasProveedores( ::nView ) )->dFecFac )
      ::oDbf:nMesDoc := Month( ( D():FacturasProveedores( ::nView ) )->dFecFac )
      ::oDbf:dFecDoc := ( D():FacturasProveedores( ::nView ) )->dFecFac
      ::oDbf:cHorDoc := SubStr( ( D():FacturasProveedores( ::nView ) )->cTimChg, 1, 2 )
      ::oDbf:cMinDoc := SubStr( ( D():FacturasProveedores( ::nView ) )->cTimChg, 3, 2 )

      ::oDbf:nTotNet := sTot:nTotalNeto
      ::oDbf:nTotIva := sTot:nTotalIva
      ::oDbf:nTotReq := sTot:nTotalRecargoEquivalencia
      ::oDbf:nTotDoc := sTot:nTotalDocumento

      ::oDbf:cSrlTot := sTot:saveToText()

      if ::lValidRegister()
         ::oDbf:Insert()
      else
         ::oDbf:Cancel()
      end if                

      ( D():FacturasProveedores( ::nView ) )->( dbskip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//


METHOD AddRecibosProveedor( cFieldOrder ) CLASS TFastComprasProveedores

   local sTot
   local oError
   local oBlock

   DEFAULT cFieldOrder  := 'dPreCob'

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ( D():FacturasProveedoresPagos( ::nView ) )->( OrdSetFocus( cFieldOrder ) )

      // filtros para la cabecera------------------------------------------------

      ::cExpresionHeader          := 'Field->' + cFieldOrder + ' >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->' + cFieldOrder + ' <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      
      ::setFilterPaymentId()

      ::setFilterProviderId()

      // Procesando recibos------------------------------------------------------

      ::setMeterText( "Procesando recibos" )

      ( D():FacturasProveedoresPagos( ::nView ) )->( setCustomFilter( ::cExpresionHeader ) )

      ::setMeterTotal( ( D():FacturasProveedoresPagos( ::nView ) )->( dbCustomkeyCount() ) )

      ( D():FacturasProveedoresPagos( ::nView ) )->( dbgotop() )

      while !::lBreak .and. !( D():FacturasProveedoresPagos( ::nView ) )->( eof() )

         ::oDbf:Blank()

         ::oDbf:cCodPrv    := ( D():FacturasProveedoresPagos( ::nView ) )->cCodPrv
         ::oDbf:cNomPrv    := ( D():FacturasProveedoresPagos( ::nView ) )->cNomPrv
         ::oDbf:cCodGrp    := RetFld( ( D():FacturasProveedoresPagos( ::nView ) )->cCodPrv, D():Proveedores( ::nView ), "cCodGrp" )
         ::oDbf:cCodPgo    := ( D():FacturasProveedoresPagos( ::nView ) )->cCodPgo

         ::oDbf:cTipDoc    := "Recibo proveedor"
         ::oDbf:cClsDoc    := REC_PRV

         ::oDbf:cSerDoc    := ( D():FacturasProveedoresPagos( ::nView ) )->cSerFac
         ::oDbf:cNumDoc    := Str( ( D():FacturasProveedoresPagos( ::nView ) )->nNumFac )
         ::oDbf:cSufDoc    := ( D():FacturasProveedoresPagos( ::nView ) )->cSufFac
         ::oDbf:cNumRec    := Str( ( D():FacturasProveedoresPagos( ::nView ) )->nNumRec )

         ::oDbf:cIdeDoc    := ::idDocumento()

         ::oDbf:dFecDoc    := ( D():FacturasProveedoresPagos( ::nView ) )->dPreCob
         ::oDbf:dEntrada   := ( D():FacturasProveedoresPagos( ::nView ) )->dEntrada
         ::oDbf:dFecVto    := ( D():FacturasProveedoresPagos( ::nView ) )->dFecVto

         ::oDbf:nTotNet    := ( D():FacturasProveedoresPagos( ::nView ) )->nImporte

         ::oDbf:lFacGas    := RetFld( ( D():FacturasProveedoresPagos( ::nView ) )->cSerFac + Str( ( D():FacturasProveedoresPagos( ::nView ) )->nNumFac ) + ( D():FacturasProveedoresPagos( ::nView ) )->cSufFac, D():FacturasProveedores( ::nView ), "lFacGas" )

         // Añadimos un nuevo registro--------------------------------------------

         if ::lValidRegister()
            ::oDbf:Insert()
         else
            ::oDbf:Cancel()
         end if

         ( D():FacturasProveedoresPagos( ::nView ) )->( dbskip() )

         ::setMeterAutoIncremental()

      end while

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir recibos de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaRectificativa() CLASS TFastComprasProveedores

   local sTot

   ( D():FacturasRectificativasProveedores( ::nView ) )->( OrdSetFocus( "dFecFac" ) )

   // filtros para la cabecera------------------------------------------------

   ::cExpresionHeader             := 'Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   
   ::setFilterPaymentInvoiceId()
   
   ::setFilterProviderId()

   // Procesando facturas rectificativas--------------------------------------

   ::setMeterText( "Procesando facturas rectificativas")
   
   ( D():FacturasRectificativasProveedores( ::nView ) )->( setCustomFilter ( ::cExpresionHeader ) )

   ::setMeterTotal( ( D():FacturasRectificativasProveedores( ::nView ) )->( dbcustomkeycount() ) )

   ( D():FacturasRectificativasProveedores( ::nView ) )->( dbgotop() )

   while !::lBreak .and. !( D():FacturasRectificativasProveedores( ::nView ) )->( eof() )

      sTot           := sTotRctPrv( ( D():FacturasRectificativasProveedores( ::nView ) )->cSerFac + Str( ( D():FacturasRectificativasProveedores( ::nView ) )->nNumFac ) + ( D():FacturasRectificativasProveedores( ::nView ) )->cSufFac, D():FacturasRectificativasProveedores( ::nView ), D():FacturasRectificativasProveedoresLineas( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ), D():FacturasProveedoresPagos( ::nView ) )
     
      ::oDbf:Blank()

      ::oDbf:cTipDoc := "Factura rectificativa"
      ::oDbf:cClsDoc := RCT_PRV

      ::oDbf:cSerDoc := ( D():FacturasRectificativasProveedores( ::nView ) )->cSerFac
      ::oDbf:cNumDoc := Str( ( D():FacturasRectificativasProveedores( ::nView ) )->nNumFac )
      ::oDbf:cSufDoc := ( D():FacturasRectificativasProveedores( ::nView ) )->cSufFac

      ::oDbf:cIdeDoc := ::idDocumento()                                

      ::oDbf:cCodPrv := ( D():FacturasRectificativasProveedores( ::nView ) )->cCodPrv
      ::oDbf:cNomPrv := ( D():FacturasRectificativasProveedores( ::nView ) )->cNomPrv
      ::oDbf:cCodGrp := RetFld( ( D():FacturasRectificativasProveedores( ::nView ) )->cCodPrv, D():Proveedores( ::nView ), "cCodGrp" )
      ::oDbf:cCodPgo := ( D():FacturasRectificativasProveedores( ::nView ) )->cCodPago

      ::oDbf:nAnoDoc := Year( ( D():FacturasRectificativasProveedores( ::nView ) )->dFecFac )
      ::oDbf:nMesDoc := Month( ( D():FacturasRectificativasProveedores( ::nView ) )->dFecFac )
      ::oDbf:dFecDoc := ( D():FacturasRectificativasProveedores( ::nView ) )->dFecFac
      ::oDbf:cHorDoc := SubStr( ( D():FacturasRectificativasProveedores( ::nView ) )->cTimChg, 1, 2 )
      ::oDbf:cMinDoc := SubStr( ( D():FacturasRectificativasProveedores( ::nView ) )->cTimChg, 3, 2 )

      ::oDbf:nTotNet := sTot:nTotalNeto
      ::oDbf:nTotIva := sTot:nTotalIva
      ::oDbf:nTotReq := sTot:nTotalRecargoEquivalencia
      ::oDbf:nTotDoc := sTot:nTotalDocumento

      ::oDbf:cSrlTot := sTot:saveToText()

      if ::lValidRegister()
         ::oDbf:Insert()
      else
         ::oDbf:Cancel()
      end if                

      ::AddFacturasRectificativasProveedores()

      ( D():FacturasRectificativasProveedores( ::nView ) )->( dbskip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddProveedor() CLASS TFastComprasProveedores

   ::setMeterText( "Procesando proveedores" )

   /*
   Recorremos proveedores
   */

   ::setMeterTotal( ( D():Proveedores( ::nView ) )->( ordkeycount() ) )

   ( D():Proveedores( ::nView ) )->( dbgotop() )
   while !( D():Proveedores( ::nView ) )->( eof() ) .and. !::lBreak

      if ::lValidRegister()

         ::oDbf:Append()

         ::oDbf:cCodPrv  := ( D():Proveedores( ::nView ) )->Cod
         ::oDbf:cNomPrv  := ( D():Proveedores( ::nView ) )->Titulo
         ::oDbf:cCodGrp  := ( D():Proveedores( ::nView ) )->cCodGrp

         ::oDbf:Save()

      end if

      ( D():Proveedores( ::nView ) )->( dbskip() )

      ::setMeterAutoIncremental()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS TFastComprasProveedores

   ::CreateTreeImageList()

   ::BuildTree()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildTree( oTree, lLoadFile ) CLASS TFastComprasProveedores

   local aReports

   DEFAULT oTree     := ::oTreeReporting
   DEFAULT lLoadFile := .t.

   aReports := {  {  "Title" => "Listado",                                 "Image" => 0, "Type" => "Listado",                       "Directory" => "Proveedores\Listado",                                "File" => "Listado.fr3"  },;
                  {  "Title" => "Compras",                                 "Image" => 12, "Subnode" =>;
                  { ;
                     { "Title" => "Pedidos de proveedores",                "Image" => 2, "Type" => "Pedidos de proveedores",        "Directory" => "Proveedores\Compras\Pedidos de proveedores",         "File" => "Pedidos de proveedores.fr3" },;
                     { "Title" => "Albaranes de proveedores",              "Image" => 3, "Type" => "Albaranes de proveedores",      "Directory" => "Proveedores\Compras\Albaranes de proveedores",       "File" => "Albaranes de proveedores.fr3" },;
                     { "Title" => "Facturas de proveedores",               "Image" => 4, "Type" => "Facturas de proveedores",       "Directory" => "Proveedores\Compras\Facturas de proveedores",        "File" => "Facturas de proveedores.fr3" },;
                     { "Title" => "Rectificativas de proveedores",         "Image" =>15, "Type" => "Rectificativas de proveedores", "Directory" => "Proveedores\Compras\Rectificativas de proveedores",  "File" => "Rectificativas de proveedores.fr3" },;
                     { "Title" => "Albaranes, facturas y rectificativas",  "Image" =>12, "Type" => "Compras",                       "Directory" => "Proveedores\Compras\Compras",                        "File" => "Compras.fr3" },;                 
                     { "Title" => "Recibos fecha de emisión",              "Image" =>21, "Type" => "Recibos emisión",               "Directory" => "Proveedores\Compras\Recibos",                        "File" => "Recibos de clientes.fr3" },;
                     { "Title" => "Recibos fecha de cobro",                "Image" =>21, "Type" => "Recibos cobro",                 "Directory" => "Proveedores\Compras\RecibosCobro",                   "File" => "Recibos de clientes fecha de cobro.fr3" },;
                     { "Title" => "Recibos fecha de vencimiento",          "Image" =>21, "Type" => "Recibos vencimiento",           "Directory" => "Proveedores\Compras\RecibosVencimiento",             "File" => "Recibos de clientes fecha de vencimiento.fr3" },;
                  } ;
                  } }

   ::BuildNode( aReports, oTree, lLoadFile )

   //oTree:ExpandAll()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DataReport( oFr ) CLASS TFastComprasProveedores

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

   ::oFastReport:SetWorkArea(       "Proveedores", ( D():Proveedores( ::nView ) )->( select() ) )
   ::oFastReport:SetFieldAliases(   "Proveedores", cItemsToReport( aItmPrv() ) )

    /*
   Relaciones------------------------------------------------------------------
   */

   ::oFastReport:SetMasterDetail(   "Informe", "Proveedores",     {|| ::oDbf:cCodPrv } )
   ::oFastReport:SetMasterDetail(   "Informe", "Empresa",         {|| cCodEmp() } )

   ::oFastReport:SetResyncPair(     "Informe", "Proveedores" )
   ::oFastReport:SetResyncPair(     "Informe", "Empresa" )

    /*
   Tablas en funcion del tipo de informe---------------------------------------
   */

   do case
      case ::cReportType == "Pedidos de proveedores"
         
         ::FastReportPedidoProveedor()

       case ::cReportType == "Albaranes de proveedores"

         ::FastReportAlbaranProveedor()

      case ::cReportType == "Facturas de proveedores"

         ::FastReportFacturaProveedor()

      case ::cReportType == "Rectificativas de proveedores"

         ::FastReportRectificativaProveedor()

      case ::cReportType == "Compras"

         ::FastReportAlbaranProveedor()

         ::FastReportFacturaProveedor()

         ::FastReportRectificativaProveedor()

      case ( "Recibos" $ ::cReportType )

         ::FastReportRecibosProveedor() 

   end case

   ::AddVariable()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariable() CLASS TFastComprasProveedores

   /*
   Tablas en funcion del tipo de informe---------------------------------------
   */

   do case
      case ::cReportType == "Pedidos de proveedores"
      
         ::AddVariablePedidoProveedor()      

         ::AddVariableLineasPedidoProveedor()

      case ::cReportType == "Albaranes de proveedores"   

         ::AddVariableAlbaranProveedor()
         
         ::AddVariableLineasAlbaranProveedor()

      case ::cReportType == "Facturas de proveedores"

         ::AddVariableFacturaProveedor()

         ::AddVariableLineasFacturaProveedor()

      case ::cReportType == "Rectificativas de proveedores"

         ::AddVariableRectificativaProveedor()

         ::AddVariableLineasRectificativaProveedor()

      case ::cReportType == "Compras"

         ::AddVariableAlbaranProveedor()

         ::AddVariableLineasAlbaranProveedor()

         ::AddVariableFacturaProveedor()

         ::AddVariableLineasFacturaProveedor()

         ::AddVariableRectificativaProveedor()

         ::AddVariableLineasRectificativaProveedor()   

      case ( "Recibos" $ ::cReportType )

         ::AddVariableRecibosProveedor()
           
   end case

Return ( ::Super:AddVariable() )

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TFastComprasProveedores
   
   ::oDbf:Zap()

   /*
   Recorremos proveedores------------------------------------------------------
   */

   do case
      case ::cReportType == "Pedidos de proveedores"

         ::AddPedidoProveedor()

      case ::cReportType == "Albaranes de proveedores"

         ::AddAlbaranProveedor()

      case ::cReportType == "Facturas de proveedores"

         ::AddFacturaProveedor()

      case ::cReportType == "Rectificativas de proveedores"
      
         ::AddFacturaRectificativa()

      case ::cReportType == "Compras"

         ::AddAlbaranProveedor( .t. )

         ::AddFacturaProveedor()

         ::AddFacturaRectificativa()

      case ::cReportType == "Listado"

         ::AddProveedor( .t. )

      case ::cReportType == "Recibos emisión"

         ::AddRecibosProveedor()   

      case ::cReportType == "Recibos cobro"

         ::AddRecibosProveedorCobro()   

      case ::cReportType == "Recibos vencimiento"

         ::AddRecibosProveedorVencimiento()   

   end case

   ::oDbf:SetFilter( ::oFilter:cExpresionFilter )

   ::oDbf:GoTop()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//
