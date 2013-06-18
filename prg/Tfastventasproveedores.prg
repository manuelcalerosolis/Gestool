#include "FiveWin.Ch"
#include "Factu.ch"
#include "Report.ch"
#include "MesDbf.ch"
// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastVentasProveedores FROM TFastReportInfGen

   DATA  cType           INIT "Proveedores"
   DATA  cResource       INIT "FastReportArticulos"

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

   METHOD AddAlbaranProveedor()
   METHOD AddFacturaProveedor()
   METHOD AddFacturaRectificativa()

   METHOD AddPedidosProveedor()

   METHOD AddProveedor()

   METHOD TreeReportingChanged()

   METHOD cIdeDocumento()  INLINE (  ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc )


END CLASS

//----------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TFastVentasProveedores

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

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

   ::CreateFilter( aItmPrv(), ::oDbfPrv )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TFastVentasProveedores

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) CLASS "ALBPROVT" FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

      DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) CLASS "ALBPROVL" FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

      DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) CLASS "FACPRVT" FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

      DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) CLASS "FACPRVL" FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

      DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) CLASS "RCTPRVT" FILE "RCTPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "RCTPRVT.CDX"

      DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) CLASS "RCTPRVL" FILE "RCTPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "RCTPRVL.CDX"

      DATABASE NEW ::oPedPrvT PATH ( cPatEmp() ) CLASS "PEDPRVT" FILE "PEDPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVT.CDX"

      DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) CLASS "PEDPRVL" FILE "PEDPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TFastVentasProveedores

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

   if !Empty( ::oFacRecL ) .and. ( ::oFacRecL:Used() )
      ::oFacRecL:end()
   end if

   if !Empty( ::oFacRecT ) .and. ( ::oFacRecT:Used() )
      ::oFacRecT:end()
   end if

   if !Empty( ::oPedPrvL ) .and. ( ::oPedPrvL:Used() )
      ::oPedPrvL:end()
   end if

   if !Empty( ::oPedPrvT ) .and. ( ::oPedPrvT:Used() )
      ::oPedPrvT:end()
   end if


RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( uParam ) CLASS TFastVentasProveedores

   ::AddField( "cCodPrv",     "C", 18, 0, {|| "@!" }, "Código proveedor"                        )
   ::AddField( "cNomPrv",     "C",100, 0, {|| ""   }, "Nombre proveedor"                        )

   ::AddField( "cCodGrp",     "C", 12, 0, {|| "@!" }, "Código grupo de proveedor"               )

   ::AddField( "cCodArt",     "C", 18, 0, {|| "@!" }, "Código artículo"                         )
   ::AddField( "cNomArt",     "C",100, 0, {|| "" },   "Nombre artículo"                         )
   ::AddField( "nUniArt",     "N", 16, 6, {|| "" },   "Unidades artículo"                       )
   ::AddField( "nTrnArt",     "N", 16, 6, {|| "" },   "Transporte artículo"                     )
   ::AddField( "nPntArt",     "N", 16, 6, {|| "" },   "Punto verde artículo"                    )
   ::AddField( "nImpArt",     "N", 16, 6, {|| "" },   "Importe artículo"                        )
   ::AddField( "nIvaArt",     "N", 16, 6, {|| "" },   cImp() + " artículo"                            )
   ::AddField( "nTotArt",     "N", 16, 6, {|| "" },   "Total artículo"                          )
   ::AddField( "cCodPr1",     "C", 10, 0, {|| "" },   "Código de la primera propiedad"          )
   ::AddField( "cCodPr2",     "C", 10, 0, {|| "" },   "Código de la segunda propiedad"          )
   ::AddField( "cValPr1",     "C", 10, 0, {|| "" },   "Valor de la primera propiedad"           )
   ::AddField( "cValPr2",     "C", 10, 0, {|| "" },   "Valor de la segunda propiedad"           )

   ::AddField( "cSerDoc",     "C",  1, 0, {|| "" },   "Serie del documento"                     )
   ::AddField( "cNumDoc",     "C",  9, 0, {|| "" },   "Número del documento"                    )
   ::AddField( "cSufDoc",     "C",  2, 0, {|| "" },   "Delegación del documento"                )
   ::AddField( "cTipDoc",     "C", 14, 0, {|| "" },   "Tipo de documento"                       )
   ::AddField( "cIdeDoc",     "C", 27, 0, {|| "" },   "Identificador del documento"             )

   ::AddField( "dFecDoc",     "D",  8, 0, {|| "" },   "Fecha del documento"                     )
   ::AddField( "cCodPago",    "C",  2, 0, {|| "@!" }, "Código de la forma de pago"              )

   ::AddTmpIndex( "cCodPrv", "cCodPrv" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TFastVentasProveedores

   ::oDbf:Zap()

   /*
   Recorremos proveedores------------------------------------------------------
   */

   do case
      case ::cReportType == "Pedidos de proveedores"

         ::AddPedidosProveedor()

      case ::cReportType == "Albaranes de proveedores"

         ::AddAlbaranProveedor( .t. )

      case ::cReportType == "Facturas de proveedores"

         ::AddFacturaProveedor()

         ::AddFacturaRectificativa( .t. )

      case ::cReportType == "Rectificativas de proveedores"
      
         ::AddFacturaRectificativa( .t. )

      case ::cReportType == "Compras"

         ::AddAlbaranProveedor( .t. )

         ::AddFacturaProveedor()

         ::AddFacturaRectificativa( .t. )

      case ::cReportType == "Listado"

         ::AddProveedor( .t. )


   end case

   ::oDbf:GoTop()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

Method lValidRegister( cCodigoProveedor ) CLASS TFastVentasProveedores

   if Empty( cCodigoProveedor ) .or. ::oDbfPrv:Seek( cCodigoProveedor )

      if ( ::oDbfPrv:Cod      >= ::oGrupoProveedor:Cargo:Desde    .and. ::oDbfPrv:Cod      <= ::oGrupoProveedor:Cargo:Hasta )  .and.;
         ( ::oDbfPrv:cCodGrp  >= ::oGrupoGProveedor:Cargo:Desde   .and. ::oDbfPrv:cCodGrp  <= ::oGrupoGProveedor:Cargo:Hasta ) .and.;
         ( ::oDbfFpg:cCodPago >= ::oGrupoFpago:Cargo:Desde        .and. ::oDbfFpg:cCodPago <= ::oGrupoFpago:Cargo:Hasta )

         return .t.

      end if

   end if

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD AddAlbaranProveedor( lFacturados ) CLASS TFastVentasProveedores

   local cExpHead
   local cExpLine

   DEFAULT lFacturados  := .f.

   ::InitAlbaranesProveedores()

   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )
   ::oAlbPrvL:OrdSetFocus( "nNumAlb" )

   if lFacturados
      cExpHead          := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   else
      cExpHead          := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end if

   if !::lAllPrv
      cExpHead          += ' .and. cCodPrv >= "' + ::oGrupoProveedor:Cargo:Desde + '" .and. cCodPrv <= "' + ::oGrupoProveedor:Cargo:Hasta + '"'
   end if

   ::oAlbPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbPrvT:OrdKeyCount() )

   ::oAlbPrvT:GoTop()

   while !::lBreak .and. !::oAlbPrvT:Eof()

      if lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

            while !::lBreak .and. ( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb == ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb )

               if !( ::lExcCero  .and. nTotNAlbPrv( ::oAlbPrvL:cAlias ) == 0 )  .and.;
                  !( ::lExcImp   .and. nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  /*
                  Añadimos un nuevo registro
                  */

                  if ::lValidRegister( ::oAlbPrvT:cCodPrv )

                  ::oDbf:Append()

                  ::oDbf:cTipDoc := "Albaranes"
                  ::oDbf:cSerDoc := ::oAlbPrvT:cSerAlb
                  ::oDbf:cNumDoc := Str( ::oAlbPrvT:nNumAlb )
                  ::oDbf:cSufDoc := ::oAlbPrvT:cSufAlb
                  ::oDbf:cIdeDoc := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

                  ::oDbf:dFecDoc := ::oAlbPrvT:dFecAlb
                  ::oDbf:cCodPago:= ::oAlbPrvT:cCodPgo

                  ::oDbf:cCodPrv := ::oAlbPrvT:cCodPrv
                  ::oDbf:cNomPrv := ::oAlbPrvT:cNomPrv
                  ::oDbf:cCodGrp := oRetFld( ::oAlbPrvT:cCodPrv, ::oDbfPrv, "cCodGrp" )

                  ::oDbf:cCodArt := ::oAlbPrvL:cRef
                  ::oDbf:cNomArt := ::oAlbPrvL:cDetalle
                  ::oDbf:nUniArt := nTotNAlbPrv( ::oAlbPrvL:cAlias )
                  ::oDbf:nImpArt := nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
                  ::oDbf:nIvaArt := nIvaLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotArt := nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
                  ::oDbf:nTotArt += nIvaLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::oDbf:cCodPr1 := ::oAlbPrvL:cCodPr1
                  ::oDbf:cCodPr2 := ::oAlbPrvL:cCodPr2
                  ::oDbf:cValPr1 := ::oAlbPrvL:cValPr1
                  ::oDbf:cValPr2 := ::oAlbPrvL:cValPr2

                  ::oDbf:Save()

                  end if

               end if

               ::oAlbPrvL:Skip()

            end while

         end if

            ::addAlbaranesProveedores()

      end if

      ::oAlbPrvT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ) )
   ::oAlbPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbPrvL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaProveedor( cCodigoProveedor ) CLASS TFastVentasProveedores

   local cExpHead
   local cExpLine

   ::InitFacturasProveedores()

   ::oFacPrvT:OrdSetFocus( "dFecFac" )
   ::oFacPrvL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead          += ' .and. cCodPrv >= "' + Rtrim( ::oGrupoProveedor:Cargo:Desde ) + '" .and. cCodPrv <= "' + Rtrim( ::oGrupoProveedor:Cargo:Hasta ) + '"'


   if !::lAllPrv
      cExpHead          += ' .and. cCodPrv >= "' + ::oGrupoProveedor:Cargo:Desde + '" .and. cCodPrv <= "' + ::oGrupoProveedor:Cargo:Hasta + '"'
   end if

   ::oFacPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas"
   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   ::oFacPrvT:GoTop()

   while !::lBreak .and. !::oFacPrvT:Eof()

      if lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

               while !::lBreak .and. ( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac )

                  if !( ::lExcCero  .and. nTotNFacPrv( ::oFacPrvL:cAlias ) == 0 )  .and.;
                  !( ::lExcImp   .and. nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )
                  /*
                  Añadimos un nuevo registro
                  */

                  if ::lValidRegister( ::oFacPrvT:cCodPrv )

                  ::oDbf:Append()

                  ::oDbf:cTipDoc := "Facturas"
                  ::oDbf:cSerDoc := ::oFacPrvT:cSerFac
                  ::oDbf:cNumDoc := Str( ::oFacPrvT:nNumFac )
                  ::oDbf:cSufDoc := ::oFacPrvT:cSufFac
                  ::oDbf:cIdeDoc := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

                  ::oDbf:dFecDoc := ::oFacPrvT:dFecFac
                  ::oDbf:cCodPago:= ::oFacPrvT:cCodPago

                  ::oDbf:cCodPrv := ::oFacPrvT:cCodPrv
                  ::oDbf:cNomPrv := ::oFacPrvT:cNomPrv
                  ::oDbf:cCodGrp := oRetFld( ::oFacPrvT:cCodPrv, ::oDbfPrv, "cCodGrp" )

                  ::oDbf:cCodArt := ::oFacPrvL:cRef
                  ::oDbf:cNomArt := ::oFacPrvL:cDetalle
                  ::oDbf:nUniArt := nTotNFacPrv( ::oFacPrvL:cAlias )
                  ::oDbf:nImpArt := nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
                  ::oDbf:nIvaArt := nIvaLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotArt := nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
                  ::oDbf:nTotArt += nIvaLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::oDbf:cCodPr1 := ::oFacPrvL:cCodPr1
                  ::oDbf:cCodPr2 := ::oFacPrvL:cCodPr2
                  ::oDbf:cValPr1 := ::oFacPrvL:cValPr1
                  ::oDbf:cValPr2 := ::oFacPrvL:cValPr2

                  ::oDbf:Save()

                  end if

               end if

               ::oFacPrvL:Skip()

            end while

         end if

            ::AddFacturasProveedores()

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ) )
   ::oFacPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaRectificativa( cCodigoProveedor ) CLASS TFastVentasProveedores

   local cExpHead
   local cExpLine

   ::InitFacturasRectificativasProveedores()

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead          += ' .and. cCodPrv >= "' + Rtrim( ::oGrupoProveedor:Cargo:Desde ) + '" .and. cCodPrv <= "' + Rtrim( ::oGrupoProveedor:Cargo:Hasta ) + '"'

  // ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas rectificativas"
   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

        if lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while !::lBreak .and. ( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac )

                  if !( ::lExcCero  .and. nTotNFacRec( ::oFacRecL:cAlias ) == 0 )  .and.;
                  !( ::lExcImp   .and. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )
                  /*
                  Añadimos un nuevo registro
                  */

                  if ::lValidRegister( ::oFacPrvT:cCodPrv )

                  ::oDbf:Append()

                  ::oDbf:cTipDoc := "Facturas Rectificativas"
                  ::oDbf:cSerDoc := ::oFacRecT:cSerie
                  ::oDbf:cNumDoc := Str( ::oFacRecT:nNumFac )
                  ::oDbf:cSufDoc := ::oFacRecT:cSufFac
                  ::oDbf:cIdeDoc := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

                  ::oDbf:dFecDoc := ::oFacRecT:dFecFac
                  ::oDbf:cCodPago:= ::oFacRecT:cCodPago

                  ::oDbf:cCodPrv := ::oFacRecL:cCodPrv
                  ::oDbf:cNomPrv := ::oFacRecL:cNomPrv
                  ::oDbf:cCodArt := ::oFacRecL:cRef
                  ::oDbf:cNomArt := ::oFacRecL:cDetalle

                  ::oDbf:nUniArt := nTotNFacRec( ::oFacRecL:cAlias )
                  ::oDbf:nImpArt := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
                  ::oDbf:nIvaArt := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotArt := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
                  ::oDbf:nTotArt += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::oDbf:cCodPr1 := ::oFacRecL:cCodPr1
                  ::oDbf:cCodPr2 := ::oFacRecL:cCodPr2
                  ::oDbf:cValPr1 := ::oFacRecL:cValPr1
                  ::oDbf:cValPr2 := ::oFacRecL:cValPr2

                  ::oDbf:Save()

                  end if

               end if

               ::oFacRecL:Skip()

            end while

         end if

            ::AddFacturasRectificativasProveedores()

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

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


METHOD AddPedidosProveedor( cCodigoProveedor ) CLASS TFastVentasProveedores

   local cExpHead
   local cExpLine

   ::InitPedidosProveedores()

   ::oPedPrvT:OrdSetFocus( "dFecPed" )
   ::oPedPrvL:OrdSetFocus( "nNumPed" )

   cExpHead          := 'dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead          += ' .and. cCodPrv >= "' + Rtrim( ::oGrupoProveedor:Cargo:Desde ) + '" .and. cCodPrv <= "' + Rtrim( ::oGrupoProveedor:Cargo:Hasta ) + '"'

   ::oPedPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ), ::oPedPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando pedidos"
   ::oMtrInf:SetTotal( ::oPedPrvT:OrdKeyCount() )

   ::oPedPrvT:GoTop()
   while !::lBreak .and. !::oPedPrvT:Eof()

         if lChkSer( ::oPedPrvT:cSerPed, ::aSer )

         if ::oPedPrvL:Seek( ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed )

            while !::lBreak .and. ( ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed == ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed )

               /*
               Añadimos un nuevo registro
               */

               if ::lValidRegister( ::oPedPrvT:cCodPrv )

                  ::oDbf:Append()

                  ::oDbf:cTipDoc := "Pedido"
                  ::oDbf:cSerDoc := ::oPedPrvT:cSerPed
                  ::oDbf:cNumDoc := Str( ::oPedPrvT:nNumPed )
                  ::oDbf:cSufDoc := ::oPedPrvT:cSufPed
                  ::oDbf:cIdeDoc := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

                  ::oDbf:dFecDoc := ::oPedPrvT:dFecPed
                  ::oDbf:cCodPago:= ::oPedPrvT:cCodPgo

                  ::oDbf:cCodPrv := ::oPedPrvT:cCodPrv
                  ::oDbf:cNomPrv := ::oPedPrvT:cNomPrv
                  ::oDbf:cCodGrp := oRetFld( ::oPedPrvT:cCodPrv, ::oDbfPrv, "cCodGrp" )

                  ::oDbf:cCodArt := ::oPedPrvL:cRef
                  ::oDbf:cNomArt := ::oPedPrvL:cDetalle

                  ::oDbf:nUniArt := nTotNPedPrv( ::oPedPrvL:cAlias )
                  ::oDbf:nImpArt := nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t. )
                  ::oDbf:nIvaArt := nIvaLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotArt := nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
                  ::oDbf:nTotArt += nIvaLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:cCodPr1 := ::oPedPrvL:cCodPr1
                  ::oDbf:cCodPr2 := ::oPedPrvL:cCodPr2
                  ::oDbf:cValPr1 := ::oPedPrvL:cValPr1
                  ::oDbf:cValPr2 := ::oPedPrvL:cValPr2

                  ::oDbf:Save()

               end if

               ::oPedPrvL:Skip()


            end while

         end if

         ::addPedidosProveedores()

      end if

      ::oPedPrvT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oPedPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ) )
   ::oPedPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedPrvL:cFile ) )

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

   aReports := {  {  "Title" => "Listado",                           "Image" => 0, "Type" => "Listado",                      "Directory" => "Proveedores",                      "File" => "Listado.fr3"  },;
                  {  "Title" => "Compras",                           "Image" => 12, "Subnode" =>;
                  { ;
                     { "Title" => "Pedidos de proveedores",          "Image" => 2, "Type" => "Pedidos de proveedores",        "Directory" => "Proveedores\Compras",  "File" => "Pedidos de proveedores.fr3" },;
                     { "Title" => "Albaranes de proveedores",        "Image" => 3, "Type" => "Albaranes de proveedores",      "Directory" => "Proveedores\Compras",  "File" => "Albaranes de proveedores.fr3" },;
                     { "Title" => "Facturas de proveedores",         "Image" => 4, "Type" => "Facturas de proveedores",       "Directory" => "Proveedores\Compras",  "File" => "Facturas de proveedores.fr3" },;
                     { "Title" => "Rectificativas de proveedores",   "Image" =>15, "Type" => "Rectificativas de proveedores", "Directory" => "Proveedores\Compras",  "File" => "Rectificativas de proveedores.fr3" },;
                     { "Title" => "Compras",                         "Image" =>12, "Type" => "Compras",                       "Directory" => "Proveedores\Compras",  "File" => "Compras.fr3" },;                 
                  } ;
                  } }

   ::BuildNode( aReports, oTree, lLoadFile )

   oTree:ExpandAll()

   /*DEFAULT lSubNode  := .t.

   oTree:Select(  oTree:Add( "Listado de proveedores",                              0, "Listado de proveedores" ) )
                  oTree:Add( "Informe de pedidos a proveedores",                    2, "Informe de pedidos a proveedores" )
                  oTree:Add( "Informe de albaranes de proveedores",                 3, "Informe de albaranes de proveedores" )
                  oTree:Add( "Informe de facturas de proveedores",                  4, "Informe de facturas de proveedores" )
                  oTree:Add( "Informe de facturas rectificativas de proveedores",  18, "Informe de facturas rectificativas de proveedores" )
*/

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

         ::AddVariableRectificativaProveedor()

         ::AddVariableLineasRectificativaProveedor()

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

Return ( Super:AddVariable() )

//---------------------------------------------------------------------------//

METHOD TreeReportingChanged() CLASS TFastVentasProveedores

   if ::oTreeReporting:GetSelText() == "Listado"
      ::lHideFecha()
   else
      ::lShowFecha()
   end if

Return ( Self )

//---------------------------------------------------------------------------//