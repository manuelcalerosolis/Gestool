#include "FiveWin.Ch"
#include "Factu.ch"  
#include "Report.ch"
#include "MesDbf.ch"
// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastVentasProveedores FROM TFastReportInfGen

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

   METHOD idDocumento()                 INLINE ( ::oDbf:cClsDoc + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc )
   METHOD idDocumentoLinea()            INLINE ( ::idDocumento() )

   METHOD setFilterPaymentId()          INLINE ( if( ::lApplyFilters,;
                                                 ::cExpresionHeader  += ' .and. ( Field->cCodPgo >= "' + ::oGrupoFpago:Cargo:Desde + '" .and. Field->cCodPgo <= "' + ::oGrupoFpago:Cargo:Hasta + '" )', ) )
   
   METHOD setFilterPaymentInvoiceId()   INLINE ( if( ::lApplyFilters,;
                                                 ::cExpresionHeader  += ' .and. ( Field->cCodPago >= "' + ::oGrupoFpago:Cargo:Desde + '" .and. Field->cCodPago <= "' + ::oGrupoFpago:Cargo:Hasta + '" )', ) )
   
   METHOD setFilterProviderId()         INLINE ( if( ::lApplyFilters,;
                                                 ::cExpresionHeader  += ' .and. ( Field->cCodPrv >= "' + ::oGrupoProveedor:Cargo:Desde + '" .and. Field->cCodPrv <= "' + ::oGrupoProveedor:Cargo:Hasta + '" )', ) )
   
END CLASS

//----------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TFastVentasProveedores

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

   ::cSubTitle       := "Informe de compras"

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

METHOD OpenFiles() CLASS TFastVentasProveedores

   local lOpen    := .t.
   local oBlock
   local oError

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
   ::lApplyFilters   := lAIS()
   
      DATABASE NEW ::oPedPrvT PATH ( cPatEmp() ) CLASS "PEDPRVT"  FILE "PEDPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVT.CDX"

      DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) CLASS "PEDPRVL"  FILE "PEDPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"

      DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) CLASS "AlbPRVT"  FILE "AlbPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "AlbPROVT.CDX"

      DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) CLASS "AlbPRVL"  FILE "AlbPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "AlbPROVL.CDX"

      DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) CLASS "FACPRVT"  FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

      DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) CLASS "FACPRVL"  FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

      DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) CLASS "FACPRVP"  FILE "FACPRVP.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

      DATABASE NEW ::oRctPrvT PATH ( cPatEmp() ) CLASS "FacRecT"  FILE "RctPrvT.DBF" VIA ( cDriver() ) SHARED INDEX "RctPrvT.CDX"

      DATABASE NEW ::oRctPrvL PATH ( cPatEmp() ) CLASS "FacRecL"  FILE "RctPrvL.DBF" VIA ( cDriver() ) SHARED INDEX "RctPrvL.CDX"

      ::oCnfFlt   := TDataCenter():oCnfFlt()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de artículos" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TFastVentasProveedores

   if !Empty( ::oPedPrvL ) .and. ( ::oPedPrvL:Used() )
      ::oPedPrvL:end()
   end if

   if !Empty( ::oPedPrvT ) .and. ( ::oPedPrvT:Used() )
      ::oPedPrvT:end()
   end if

   if !Empty( ::oAlbPrvL ) .and. ( ::oAlbPrvL:Used() )
      ::oAlbPrvL:end()
   end if

   if !Empty( ::oAlbPrvT ) .and. ( ::oAlbPrvT:Used() )
      ::oAlbPrvT:end()
   end if

   if !Empty( ::oFacPrvL ) .and. ( ::oFacPrvL:Used() )
      ::oFacPrvL:end()
   end if

   if !Empty( ::oFacPrvT ) .and. ( ::oFacPrvT:Used() )
      ::oFacPrvT:end()
   end if

   if !Empty( ::oFacPrvP ) .and. ( ::oFacPrvP:Used() )
      ::oFacPrvP:end()
   end if

   if !Empty( ::oRctPrvL ) .and. ( ::oRctPrvL:Used() )
      ::oRctPrvL:end()
   end if

   if !Empty( ::oRctPrvT ) .and. ( ::oRctPrvT:Used() )
      ::oRctPrvT:end()
   end if

   if !Empty( ::oCnfFlt ) .and. ( ::oCnfFlt:Used() )
      ::oCnfFlt:end()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( uParam ) CLASS TFastVentasProveedores

   ::AddField( "cCodPrv",     "C", 18, 0, {|| "@!" }, "Código proveedor"                        )
   ::AddField( "cNomPrv",     "C",100, 0, {|| ""   }, "Nombre proveedor"                        )

   ::AddField( "cCodGrp",     "C", 12, 0, {|| "@!" }, "Código grupo de proveedor"               )

   ::AddField( "cClsDoc",     "C",  2, 0, {|| "" },   "Clase de documento"                      )
   ::AddField( "cSerDoc",     "C",  1, 0, {|| "" },   "Serie del documento"                     )
   ::AddField( "cNumDoc",     "C",  9, 0, {|| "" },   "Número del documento"                    )
   ::AddField( "cSufDoc",     "C",  2, 0, {|| "" },   "Delegación del documento"                )
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

   ::AddField( "uCargo",      "C", 20, 0, {|| "" },   "Cargo"                                   )

   ::AddTmpIndex( "cCodPrv", "cCodPrv" )

RETURN ( self )

//---------------------------------------------------------------------------//

Method lValidRegister( cCodigoProveedor ) CLASS TFastVentasProveedores

   if ( ::oDbf:cCodPrv >= ::oGrupoProveedor:Cargo:Desde     .and. ::oDbf:cCodPrv <= ::oGrupoProveedor:Cargo:Hasta )  .and.;
      ( ::oDbf:cCodGrp >= ::oGrupoGProveedor:Cargo:Desde    .and. ::oDbf:cCodGrp <= ::oGrupoGProveedor:Cargo:Hasta ) .and.;
      ( ::oDbf:cCodPgo >= ::oGrupoFpago:Cargo:Desde         .and. ::oDbf:cCodPgo <= ::oGrupoFpago:Cargo:Hasta )

      Return .t.

   end if

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD AddPedidoProveedor( cCodigoProveedor ) CLASS TFastVentasProveedores

   local sTot

      ::InitPedidosProveedores()

      ::oPedPrvT:OrdSetFocus( "dFecPed" )

   // filtros para la cabecera------------------------------------------------

      ::cExpresionHeader                := 'Field->dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      
      ::setFilterPaymentId()
      
      ::setFilterProviderId()

   // Procesando pedidos------------------------------------------------------

      ::oMtrInf:cText         := "Procesando pedidos"
      
      ::oPedPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ), ::oPedPrvT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::oMtrInf:SetTotal( ::oPedPrvT:OrdKeyCount() )

      ::oPedPrvT:GoTop()
      while !::lBreak .and. !::oPedPrvT:Eof()

         if lChkSer( ::oPedPrvT:cSerPed, ::aSer )

            sTot              := sTotPedPrv( ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed, ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

            ::oDbf:Blank()

            ::oDbf:cTipDoc    := "Pedido proveedor"
            ::oDbf:cClsDoc    := PED_PRV

            ::oDbf:cSerDoc    := ::oPedPrvT:cSerPed
            ::oDbf:cNumDoc    := Str( ::oPedPrvT:nNumPed )
            ::oDbf:cSufDoc    := ::oPedPrvT:cSufPed

            ::oDbf:cIdeDoc    := ::idDocumento()            

            ::oDbf:cCodPrv    := ::oPedPrvT:cCodPrv
            ::oDbf:cNomPrv    := ::oPedPrvT:cNomPrv
            ::oDbf:cCodGrp    := oRetFld( ::oPedPrvT:cCodPrv, ::oDbfPrv, "cCodGrp" )
            ::oDbf:cCodPgo    := ::oPedPrvT:cCodPgo

            ::oDbf:nAnoDoc    := Year( ::oPedPrvT:dFecPed )
            ::oDbf:nMesDoc    := Month( ::oPedPrvT:dFecPed )
            ::oDbf:dFecDoc    := ::oPedPrvT:dFecPed
            ::oDbf:cHorDoc    := SubStr( ::oPedPrvT:cTimChg, 1, 2 )
            ::oDbf:cMinDoc    := SubStr( ::oPedPrvT:cTimChg, 3, 2 )

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

         end if 

         ::oPedPrvT:Skip()

         ::oMtrInf:AutoInc()

      end while

   ::oPedPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddAlbaranProveedor( lFacturados ) CLASS TFastVentasProveedores

   local sTot

   DEFAULT lFacturados  := .f.

      ::InitAlbaranesProveedores()

      ::oAlbPrvT:OrdSetFocus( "dFecAlb" )   

   // filtros para la cabecera------------------------------------------------

      if lFacturados
         ::cExpresionHeader          := '!lFacturado .and. Field->dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      else
         ::cExpresionHeader          := 'Field->dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      end if

      ::setFilterPaymentId()
      
      ::setFilterProviderId()

   // Procesando albaranes----------------------------------------------------

      ::oMtrInf:cText      := "Procesando albaranes" 
      
      ::oAlbPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::oMtrInf:SetTotal( ::oAlbPrvT:OrdKeyCount() )

      ::oAlbPrvT:GoTop()

      while !::lBreak .and. !::oAlbPrvT:Eof()

         if lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

            sTot           := sTotAlbPrv( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )
           
            ::oDbf:Blank()

            ::oDbf:cTipDoc := "Albaran proveedor"
            ::oDbf:cClsDoc := ALB_PRV

            ::oDbf:cSerDoc := ::oAlbPrvT:cSerAlb
            ::oDbf:cNumDoc := Str( ::oAlbPrvT:nNumAlb )
            ::oDbf:cSufDoc := ::oAlbPrvT:cSufAlb

            ::oDbf:cIdeDoc := ::idDocumento()            

            ::oDbf:cCodPrv := ::oAlbPrvT:cCodPrv
            ::oDbf:cNomPrv := ::oAlbPrvT:cNomPrv
            ::oDbf:cCodGrp := oRetFld( ::oAlbPrvT:cCodPrv, ::oDbfPrv, "cCodGrp" )
            ::oDbf:cCodPgo := ::oAlbPrvT:cCodPgo

            ::oDbf:nAnoDoc := Year( ::oAlbPrvT:dFecAlb )
            ::oDbf:nMesDoc := Month( ::oAlbPrvT:dFecAlb )
            ::oDbf:dFecDoc := ::oAlbPrvT:dFecAlb
            ::oDbf:cHorDoc := SubStr( ::oAlbPrvT:cTimChg, 1, 2 )
            ::oDbf:cMinDoc := SubStr( ::oAlbPrvT:cTimChg, 3, 2 )

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

         end if

         ::oAlbPrvT:Skip()

         ::oMtrInf:AutoInc()

      end while

      ::oAlbPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ) )   

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaProveedor( cCodigoProveedor ) CLASS TFastVentasProveedores

   local sTot

      ::InitFacturasProveedores()

      ::oFacPrvT:OrdSetFocus( "dFecFac" )

   // filtros para la cabecera------------------------------------------------

      ::cExpresionHeader             := 'Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      
      ::setFilterPaymentInvoiceId()
      
      ::setFilterProviderId()

   // Procesando facturas-----------------------------------------------------

      ::oMtrInf:cText      := "Procesando facturas"
      
      ::oFacPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

      ::oFacPrvT:GoTop()
      while !::lBreak .and. !::oFacPrvT:Eof()

         if lChkSer( ::oFacPrvT:cSerFac, ::aSer )

            sTot           := sTotFacPrv( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias )
           
            ::oDbf:Blank()

            ::oDbf:cTipDoc := "Factura proveedor"
            ::oDbf:cClsDoc := FAC_PRV

            ::oDbf:cSerDoc := ::oFacPrvT:cSerFac
            ::oDbf:cNumDoc := Str( ::oFacPrvT:nNumFac )
            ::oDbf:cSufDoc := ::oFacPrvT:cSufFac

            ::oDbf:cIdeDoc := ::idDocumento()                                

            ::oDbf:cCodPrv := ::oFacPrvT:cCodPrv
            ::oDbf:cNomPrv := ::oFacPrvT:cNomPrv
            ::oDbf:cCodGrp := oRetFld( ::oFacPrvT:cCodPrv, ::oDbfPrv, "cCodGrp" )
            ::oDbf:cCodPgo := ::oFacPrvT:cCodPago

            ::oDbf:nAnoDoc := Year( ::oFacPrvT:dFecFac )
            ::oDbf:nMesDoc := Month( ::oFacPrvT:dFecFac )
            ::oDbf:dFecDoc := ::oFacPrvT:dFecFac
            ::oDbf:cHorDoc := SubStr( ::oFacPrvT:cTimChg, 1, 2 )
            ::oDbf:cMinDoc := SubStr( ::oFacPrvT:cTimChg, 3, 2 )

            ::oDbf:nTotNet := sTot:nTotalNeto
            ::oDbf:nTotIva := sTot:nTotalIva
            ::oDbf:nTotReq := sTot:nTotalRecargoEquivalencia
            ::oDbf:nTotDoc := sTot:nTotalDocumento

            if ::lValidRegister()
               ::oDbf:Insert()
            else
               ::oDbf:Cancel()
            end if                

            ::AddFacturasProveedores()

         end if

         ::oFacPrvT:Skip()

         ::oMtrInf:AutoInc()

      end while

      ::oFacPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaRectificativa() CLASS TFastVentasProveedores

   local sTot

      ::InitFacturasRectificativasProveedores()

      ::oRctPrvT:OrdSetFocus( "dFecFac" )

   // filtros para la cabecera------------------------------------------------

      ::cExpresionHeader             := 'Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      
      ::setFilterPaymentInvoiceId()
      
      ::setFilterProviderId()

   // Procesando facturas rectificativas--------------------------------------

      ::oMtrInf:cText      := "Procesando facturas rectificativas"
      
      ::oRctPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oRctPrvT:cFile ), ::oRctPrvT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::oMtrInf:SetTotal( ::oRctPrvT:OrdKeyCount() )

      ::oRctPrvT:GoTop()
      while !::lBreak .and. !::oRctPrvT:Eof()

         if lChkSer( ::oRctPrvT:cSerFac, ::aSer )

            sTot           := sTotRctPrv( ::oRctPrvT:cSerFac + Str( ::oRctPrvT:nNumFac ) + ::oRctPrvT:cSufFac, ::oRctPrvT:cAlias, ::oRctPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias )
           
            ::oDbf:Blank()

            ::oDbf:cTipDoc := "Factura rectificativa"
            ::oDbf:cClsDoc := RCT_PRV

            ::oDbf:cSerDoc := ::oRctPrvT:cSerFac
            ::oDbf:cNumDoc := Str( ::oRctPrvT:nNumFac )
            ::oDbf:cSufDoc := ::oRctPrvT:cSufFac

            ::oDbf:cIdeDoc := ::idDocumento()                                

            ::oDbf:cCodPrv := ::oRctPrvT:cCodPrv
            ::oDbf:cNomPrv := ::oRctPrvT:cNomPrv
            ::oDbf:cCodGrp := oRetFld( ::oRctPrvT:cCodPrv, ::oDbfPrv, "cCodGrp" )
            ::oDbf:cCodPgo := ::oRctPrvT:cCodPago

            ::oDbf:nAnoDoc := Year( ::oRctPrvT:dFecFac )
            ::oDbf:nMesDoc := Month( ::oRctPrvT:dFecFac )
            ::oDbf:dFecDoc := ::oRctPrvT:dFecFac
            ::oDbf:cHorDoc := SubStr( ::oRctPrvT:cTimChg, 1, 2 )
            ::oDbf:cMinDoc := SubStr( ::oRctPrvT:cTimChg, 3, 2 )

            ::oDbf:nTotNet := sTot:nTotalNeto
            ::oDbf:nTotIva := sTot:nTotalIva
            ::oDbf:nTotReq := sTot:nTotalRecargoEquivalencia
            ::oDbf:nTotDoc := sTot:nTotalDocumento

            if ::lValidRegister()
               ::oDbf:Insert()
            else
               ::oDbf:Cancel()
            end if                

            ::AddFacturasRectificativasProveedores()

         end if

         ::oRctPrvT:Skip()

         ::oMtrInf:AutoInc()

      end while

      ::oRctPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oRctPrvT:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddProveedor() CLASS TFastVentasProveedores

   ::oMtrInf:SetTotal( ::oDbfPrv:OrdKeyCount() )

   ::oMtrInf:cText         := "Procesando proveedores"

   /*
   Recorremos proveedores
   */

   ::oMtrInf:AutoInc( ::oDbfPrv:LastRec() )

   ::oDbfPrv:GoTop()
     while !::oDbfPrv:Eof() .and. !::lBreak

      if ::lValidRegister()

         ::oDbf:Append()

         ::oDbf:cCodPrv  := ::oDbfPrv:Cod
         ::oDbf:cNomPrv  := ::oDbfPrv:Titulo
         ::oDbf:cCodGrp  := ::oDbfPrv:cCodGrp

         ::oDbf:Save()

      end if

      ::oDbfPrv:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oDbfPrv:OrdKeyCount() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS TFastVentasProveedores

   ::CreateTreeImageList()

   ::BuildTree()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildTree( oTree, lLoadFile ) CLASS TFastVentasProveedores

   local aReports

   DEFAULT oTree     := ::oTreeReporting
   DEFAULT lLoadFile := .t.

   aReports := {  {  "Title" => "Listado",                           "Image" => 0, "Type" => "Listado",                       "Directory" => "Proveedores\Listado",                                "File" => "Listado.fr3"  },;
                  {  "Title" => "Compras",                           "Image" => 12, "Subnode" =>;
                  { ;
                     { "Title" => "Pedidos de proveedores",          "Image" => 2, "Type" => "Pedidos de proveedores",        "Directory" => "Proveedores\Compras\Pedidos de proveedores",         "File" => "Pedidos de proveedores.fr3" },;
                     { "Title" => "Albaranes de proveedores",        "Image" => 3, "Type" => "Albaranes de proveedores",      "Directory" => "Proveedores\Compras\Albaranes de proveedores",       "File" => "Albaranes de proveedores.fr3" },;
                     { "Title" => "Facturas de proveedores",         "Image" => 4, "Type" => "Facturas de proveedores",       "Directory" => "Proveedores\Compras\Facturas de proveedores",        "File" => "Facturas de proveedores.fr3" },;
                     { "Title" => "Rectificativas de proveedores",   "Image" =>15, "Type" => "Rectificativas de proveedores", "Directory" => "Proveedores\Compras\Rectificativas de proveedores",  "File" => "Rectificativas de proveedores.fr3" },;
                     { "Title" => "Compras",                         "Image" =>12, "Type" => "Compras",                       "Directory" => "Proveedores\Compras\Compras",                        "File" => "Compras.fr3" },;                 
                  } ;
                  } }

   ::BuildNode( aReports, oTree, lLoadFile )

   //oTree:ExpandAll()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DataReport( oFr ) CLASS TFastVentasProveedores

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

   ::oFastReport:SetWorkArea(       "Proveedores", ::oDbfPrv:nArea )
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

   end case

   ::AddVariable()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariable() CLASS TFastVentasProveedores

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
           
   end case

Return ( ::Super:AddVariable() )

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TFastVentasProveedores
   
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

   end case

   ::oDbf:SetFilter( ::oFilter:cExpresionFilter )

   ::oDbf:GoTop()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//
