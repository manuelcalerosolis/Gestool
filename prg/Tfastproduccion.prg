#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"
// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastProduccion FROM TFastReportInfGen
   
   DATA cType                             INIT "PRODUCCION"

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

   METHOD AddParteProducccion()

//   METHOD cIdeDocumento()                 INLINE ( ::oDbf:cClsDoc + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc )

//----------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TFastProduccion

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

   ::cSubTitle       := "Informe de produccion"

   if !::NewResource()
      return .f.
   end if

   /*
   Carga controles-------------------------------------------------------------
   */

   if !::lGrupoOperacion( .t. )
      return .f.
   end if
   
   if !::lGrupoTOperacion( .t. )
      return .f.
   end if

   if !::lGrupoSeccion( .t. )
      return .f.
   end if

   if !::lGrupoAlmacen( .t. )
      return .f.
   end if

   if !::lGrupoArticulo( .t. )
      return .f.
   end if

   if !::lGrupoFamilia( .t. )
      return .f.
   end if

   if !::lGrupoGFamilia( .t. )
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

   if !::lGrupoOperario( .t. )
      return .t.
   end if

   if !::lGrupoMaquina( .t. )
      return .f.
   end if

   ::oFilter      := TFilterCreator():Init()
   if !Empty( ::oFilter )
      ::oFilter:SetDatabase( ::oDbf )
      ::oFilter:SetFilterType( FST_PRO )
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TFastProduccion

   local lOpen    := .t.
   local oBlock
   local oError

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DATABASE NEW ::oProCab     PATH ( cPatEmp() ) CLASS "PROCAB"      FILE "PROCAB.DBF"    VIA ( cDriver() ) SHARED INDEX "PROCAB.CDX"
      DATABASE NEW ::oProLin     PATH ( cPatEmp() ) CLASS "PROLIN"      FILE "PROLIN.DBF"    VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"
      DATABASE NEW ::oOperacion  PATH ( cPatEmp() ) CLASS "OPERACION"   FILE "OPERACIO.DBF"  VIA ( cDriver() ) SHARED INDEX "OPERACIO.CDX"
      DATABASE NEW ::oTipOpera   PATH ( cPatEmp() ) CLASS "TIPOPERA"    FILE "TIPOPERA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIPOPERA.CDX"
      DATABASE NEW ::oSeccion    PATH ( cPatEmp() ) CLASS "SECCION"     FILE "SECCION.DBF"   VIA ( cDriver() ) SHARED INDEX "SECCION.CDX"
      DATABASE NEW ::oProMat     PATH ( cPatEmp() ) CLASS "PROMAT"      FILE "PROMAT.DBF"    VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"
      DATABASE NEW ::oPersonal   PATH ( cPatEmp() ) CLASS "PERSONAL"    FILE "PERSONAL.DBF"  VIA ( cDriver() ) SHARED INDEX "PERSONAL.CDX"
      DATABASE NEW ::oHorasPers  PATH ( cPatEmp() ) CLASS "HORASPERS"   FILE "PROHPER.BDF"   VIA ( cDriver() ) SHARED INDEX "PROHPER.CDX"
      DATABASE NEW ::oMaquina    PATH ( cPatEmp() ) CLASS "MAQUINA"     FILE "MAQCOST.DBF"   VIA ( cDriver() ) SHARED INDEX "MAQCOST.CDX"
      DATABASE NEW ::oMaqLin     PATH ( cPatEmp() ) CLASS "MAQLIN"      FILE "MAQCOSL.CBF"   VIA ( cDriver() ) SHARED INDEX "MAQCOSL.CDX"
      DATABASE NEW ::oProMaq     PATH ( cPatEmp() ) CLASS "PROMAQ"      FILE "PROMAQ.DBF"    VIA ( cDriver() ) SHARED INDEX "PROMAQ.CDX"
      DATABASE NEW ::oArticulos  PATH ( cPatEmp() ) CLASS "ARTICULOS"   FILE "ARTICULO.DBF"  VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"
      DATABASE NEW ::oFamArt     PATH ( cPatEmp() ) CLASS "FAMART"      FILE "FAMILIAS.DBF"  VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"
      DATABASE NEW ::oAlmacen    PATH ( cPatEmp() ) CLASS "ALMACEN"     FILE "ALMACEN.DBF"   VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

      ::oCnfFlt   := TDataCenter():oCnfFlt()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de producción" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TFastProduccion

   if !Empty( ::oProCab ) .and. ( ::oProCab:Used() )
      ::oProCab:end()
   end if

   if !Empty( ::oProLin ) .and. ( ::oProLin:Used() )
      ::oProLin:end()
   end if

   if !Empty( ::oOperacion ) .and. ( ::oOperacion:Used() )
      ::oOperacion:end()
   end if

   if !Empty( ::oTipOpera ) .and. ( ::oTipOpera:Used() )
      ::oTipOpera:end()
   end if

   if !Empty( ::oSeccion ) .and. ( ::oSeccion:Used() )
      ::oSeccion:end()
   end if

   if !Empty( ::oProMat ) .and. ( ::oProMat:Used() )
      ::oProMat:end()
   end if

   if !Empty( ::oPersonal ) .and. ( ::oPersonal:Used() )
      ::oPersonal:end()
   end if

   if !Empty( ::oHorasPers ) .and. ( ::oHorasPers:Used() )
      ::oHorasPers:end()
   end if

   if !Empty( ::oMaquina ) .and. ( ::oMaquina:Used() )
      ::oMaquina:end()
   end if

   if !Empty( ::oMaqLin ) .and. ( ::oMaqLin:Used() )
      ::oMaqLin:end()
   end if

   if !Empty( ::oProMaq ) .and. ( ::oProMaq:Used() )
      ::oProMaq:end()
   end if

   if !Empty( ::oArticulos ) .and. ( ::oArticulos:Used() )
      ::oArticulos:end()
   end if

   if !Empty( ::oFamArt ) .and. ( ::oFamArt:Used() )
      ::oFamArt:end()
   end if

   if !Empty( ::oAlmacen ) .and. ( ::oAlmacen:Used() )
      ::oAlmacen:end()
   end if

   if !Empty( ::oCnfFlt ) .and. ( ::oCnfFlt:Used() )
      ::oCnfFlt:end()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( uParam ) CLASS TFastVentasProveedores

   ::AddField( "cClsDoc",     "C",  2, 0, {|| "" },   "Clase de documento"                      )
   ::AddField( "cSerDoc",     "C",  1, 0, {|| "" },   "Serie del documento"                     )
   ::AddField( "cNumDoc",     "C",  9, 0, {|| "" },   "Número del documento"                    )
   ::AddField( "cSufDoc",     "C",  2, 0, {|| "" },   "Delegación del documento"                )
   ::AddField( "cTipDoc",     "C", 30, 0, {|| "" },   "Tipo de documento"                       )
   ::AddField( "cIdeDoc",     "C", 27, 0, {|| "" },   "Identificador del documento"             )

   ::AddField( "nAnoDoc",     "N",  4, 0, {|| "" },   "Año del documento"                       )
   ::AddField( "nMesDoc",     "N",  2, 0, {|| "" },   "Mes del documento"                       )
   ::AddField( "dFecDoc",     "D",  8, 0, {|| "" },   "Fecha del documento"                     )
   ::AddField( "cHorDoc",     "C",  2, 0, {|| "" },   "Hora del documento"                      )
   ::AddField( "cMinDoc",     "C",  2, 0, {|| "" },   "Minutos del documento"                   )

   ::AddField( "nTotDoc",     "N", 16, 6, {|| "" },   "Total documento"                         )
   ::AddField( "nTotProd",    "N", 16, 6, {|| "" },   "Total producido"                         )
   ::AddField( "nTotMat",     "N", 16, 6, {|| "" },   "Total materias primas"                   )
   ::AddField( "nTotPers",    "N", 16, 6, {|| "" },   "Total horas personal"                    )
   ::AddField( "nTotMaq",     "N", 16, 6, {|| "" },   "Total maquinara"                         )

   ::AddTmpIndex( "cNumDoc", "cSerDoc+Str(cNumDoc)+cSufDoc" )

RETURN ( self )

//---------------------------------------------------------------------------//

Method lValidRegister( cCodigoProveedor ) CLASS TFastVentasProveedores

   if ( ::oDbf:cCodPrv >= ::oGrupoProveedor:Cargo:Desde     .and. ::oDbf:cCodPrv <= ::oGrupoProveedor:Cargo:Hasta )  .and.;
      ( ::oDbf:cCodGrp >= ::oGrupoGProveedor:Cargo:Desde    .and. ::oDbf:cCodGrp <= ::oGrupoGProveedor:Cargo:Hasta ) .and.;
      ( ::oDbf:cCodPgo >= ::oGrupoFpago:Cargo:Desde         .and. ::oDbf:cCodPgo <= ::oGrupoFpago:Cargo:Hasta )

      Return .t.

   end if

/*
lGrupoOperacion
lGrupoTOperacion
lGrupoSeccion
lGrupoAlmacen
lGrupoArticulo
lGrupoFamilia
lGrupoGFamilia
lGrupoTipoArticulo
lGrupoCategoria
lGrupoTemporada
lGrupoOperario
lGrupoMaquina
*/

RETURN ( .f. )



//---------------------------------------------------------------------------//

METHOD AddPedidoProveedor( cCodigoProveedor ) CLASS TFastVentasProveedores

   local sTot
   local cExpHead
   local cExpLine

   ::InitPedidosProveedores()

   ::oPedPrvT:OrdSetFocus( "dFecPed" )

   cExpHead                := 'dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead                += ' .and. cCodPrv >= "' + Rtrim( ::oGrupoProveedor:Cargo:Desde ) + '" .and. cCodPrv <= "' + Rtrim( ::oGrupoProveedor:Cargo:Hasta ) + '"'

   ::oPedPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ), ::oPedPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText         := "Procesando pedidos"
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

         ::oDbf:cIdeDoc    := ::cIdeDocumento()            

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

   local cExpHead
   local cExpLine
   local sTot

   DEFAULT lFacturados  := .f.

   ::InitAlbaranesProveedores()

   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )   

   if lFacturados
      cExpHead          := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   else
      cExpHead          := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end if

   cExpHead             += ' .and. cCodPrv >= "' + ::oGrupoProveedor:Cargo:Desde + '" .and. cCodPrv <= "' + ::oGrupoProveedor:Cargo:Hasta + '"'

   ::oAlbPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText      := "Procesando albaranes" 
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

         ::oDbf:cIdeDoc := ::cIdeDocumento()            

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
   local cExpHead
   local cExpLine

   ::InitFacturasProveedores()

   ::oFacPrvT:OrdSetFocus( "dFecFac" )

   cExpHead             := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead             += ' .and. cCodPrv >= "' + Rtrim( ::oGrupoProveedor:Cargo:Desde ) + '" .and. cCodPrv <= "' + Rtrim( ::oGrupoProveedor:Cargo:Hasta ) + '"'

   ::oFacPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText      := "Procesando facturas"
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

         ::oDbf:cIdeDoc := ::cIdeDocumento()                                

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
   local cExpHead
   local cExpLine

   ::InitFacturasRectificativasProveedores()

   ::oRctPrvT:OrdSetFocus( "dFecFac" )

   cExpHead             := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead             += ' .and. cCodPrv >= "' + Rtrim( ::oGrupoProveedor:Cargo:Desde ) + '" .and. cCodPrv <= "' + Rtrim( ::oGrupoProveedor:Cargo:Hasta ) + '"'

   ::oRctPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oRctPrvT:cFile ), ::oRctPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText      := "Procesando facturas rectificativas"
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

         ::oDbf:cIdeDoc := ::cIdeDocumento()                                

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

METHOD AddParteProducccion() CLASS TFastProduccion

   ::oMtrInf:SetTotal( ::oDbf:OrdKeyCount() )

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

METHOD StartDialog() CLASS TFastProduccion

   ::CreateTreeImageList()

   ::BuildTree()

 RETURN ( Self )


//---------------------------------------------------------------------------//

METHOD BuildTree( oTree, lLoadFile ) CLASS TFastProduccion

   local aReports

   DEFAULT oTree     := ::oTreeReporting
   DEFAULT lLoadFile := .t.

   aReports := {  "Title" => "Partes de produccion", "Image" => 14, "Type" => "Partes de produccion", "Directory" => "Partes de produccion", "File" => "Partes de produccion.fr3"  }
               

   ::BuildNode( aReports, oTree, lLoadFile )

   //oTree:ExpandAll()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DataReport( oFr ) CLASS TFastProduccion

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

   oFr:SetWorkArea(     "Lineas de material producido", ::oDetProduccion:oDbf:nArea )
   oFr:SetFieldAliases( "Lineas de material producido", cObjectsToReport( ::oDetProduccion:oDbf ) )

    /*
   Relaciones------------------------------------------------------------------
   */

   ::oFastReport:SetMasterDetail(   "Informe", "Lineas de material producido",   {|| ::oDbf:cSerDoc + Str( ::oDbf:cNumDoc ) + ::oDbf:cSufDoc } )
   ::oFastReport:SetMasterDetail(   "Informe", "Empresa",         {|| cCodEmp() } )

   ::oFastReport:SetResyncPair(     "Informe", "Lineas de material producido" )
   ::oFastReport:SetResyncPair(     "Informe", "Empresa" )


   //----------------------------------------------------------

/*

   oFr:SetWorkArea(     "Lineas de materias primas", ::oDetMaterial:oDbf:nArea )
   oFr:SetFieldAliases( "Lineas de materias primas", cObjectsToReport( ::oDetMaterial:oDbf ) )

   oFr:SetWorkArea(     "Lineas de personal", ::oDetPersonal:oDbf:nArea )
   oFr:SetFieldAliases( "Lineas de personal", cObjectsToReport( ::oDetPersonal:oDbf ) )

   oFr:SetWorkArea(     "Lineas de horas de personal", ::oDetHorasPersonal:oDbf:nArea )
   oFr:SetFieldAliases( "Lineas de horas de personal", cObjectsToReport( ::oDetHorasPersonal:oDbf ) )

   oFr:SetWorkArea(     "Lineas de maquinaria", ::oDetMaquina:oDbf:nArea )
   oFr:SetFieldAliases( "Lineas de maquinaria", cObjectsToReport( ::oDetMaquina:oDbf ) )

   oFr:SetWorkArea(     "Empresa", ::oDbfEmp:nArea )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Almacenes", ::oAlm:nArea )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Sección", ::oSeccion:oDbf:nArea )
   oFr:SetFieldAliases( "Sección", cObjectsToReport( ::oSeccion:oDbf ) )

   oFr:SetWorkArea(     "Operación", ::oOperacion:oDbf:nArea )
   oFr:SetFieldAliases( "Operación", cObjectsToReport( ::oOperacion:oDbf ) )

   oFr:SetWorkArea(     "Operarios", ::oOperario:oDbf:nArea )
   oFr:SetFieldAliases( "Operarios", cObjectsToReport( ::oOperario:oDbf ) )

   oFr:SetWorkArea(     "Tipos.Lineas de material producido", ::oTipoArticulo:oDbf:nArea )
   oFr:SetFieldAliases( "Tipos.Lineas de material producido", cObjectsToReport( ::oTipoArticulo:oDbf ) )

   oFr:SetWorkArea(     "Tipos.Lineas de materias primas", ::oTipoArticulo:oDbf:nArea )
   oFr:SetFieldAliases( "Tipos.Lineas de materias primas", cObjectsToReport( ::oTipoArticulo:oDbf ) )

   oFr:SetWorkArea(     "Artículos.Lineas de material producido", ::oArt:nArea )
   oFr:SetFieldAliases( "Artículos.Lineas de material producido", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Artículos.Lineas de materias primas", ::oArt:nArea )
   oFr:SetFieldAliases( "Artículos.Lineas de materias primas", cItemsToReport( aItmArt() ) )
*/
   /*
   Relaciones------------------------------------------------------------------
   */
/*
   oFr:SetMasterDetail( "Producción", "Lineas de material producido",      {|| ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd } )
   oFr:SetMasterDetail( "Producción", "Lineas de materias primas",         {|| ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd } )
   oFr:SetMasterDetail( "Producción", "Lineas de personal",                {|| ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd } )
   oFr:SetMasterDetail( "Producción", "Lineas de maquinaria",              {|| ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd } )
   oFr:SetMasterDetail( "Producción", "Lineas de producción",              {|| ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd } )

   oFr:SetMasterDetail( "Producción", "Empresa",                              {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Producción", "Almacenes",                            {|| ::oDbf:cAlmOrd } )
   oFr:SetMasterDetail( "Producción", "Sección",                              {|| ::oDbf:cCodSec } )
   oFr:SetMasterDetail( "Producción", "Operación",                            {|| ::oDbf:cCodOpe } )
   
   oFr:SetMasterDetail( "Lineas de material producido", "Artículos.Lineas de material producido",  {|| ::oDetProduccion:oDbf:cCodArt } )  
   oFr:SetMasterDetail( "Lineas de material producido", "Tipos.Lineas de material producido",      {|| ::oDetProduccion:oDbf:cCodTip } )  

   oFr:SetMasterDetail( "Lineas de materias primas", "Artículos.Lineas de materias primas",        {|| ::oDetMaterial:oDbf:cCodArt } )
   oFr:SetMasterDetail( "Lineas de materias primas", "Tipos.Lineas de materias primas",            {|| ::oDetMaterial:oDbf:cCodTip } )

   oFr:SetMasterDetail( "Lineas de personal", "Operarios",                    {|| ::oDetPersonal:oDbf:cCodTra } )

   oFr:SetMasterDetail( "Lineas de personal", "Lineas de horas de personal",  {|| ::oDetPersonal:oDbf:cSerOrd + Str( ::oDetPersonal:oDbf:nNumOrd ) + ::oDetPersonal:oDbf:cSufOrd + ::oDetPersonal:oDbf:cCodTra } )
*/
   /*
   Sincronizaciones------------------------------------------------------------
   */
/*
   oFr:SetResyncPair(   "Producción", "Lineas de material producido" )
   oFr:SetResyncPair(   "Producción", "Lineas de materias primas" )
   oFr:SetResyncPair(   "Producción", "Lineas de personal" )
   oFr:SetResyncPair(   "Producción", "Lineas de maquinaria" )
   oFr:SetResyncPair(   "Producción", "Lineas de producción" )
   oFr:SetResyncPair(   "Producción", "Empresa" )
   oFr:SetResyncPair(   "Producción", "Almacenes" )
   oFr:SetResyncPair(   "Producción", "Sección" )
   oFr:SetResyncPair(   "Producción", "Operación" )

   oFr:SetResyncPair(   "Lineas de material producido", "Artículos.Lineas de material producido" )  
   oFr:SetResyncPair(   "Lineas de material producido", "Tipos.Lineas de material producido" )  

   oFr:SetResyncPair(   "Lineas de materias primas", "Artículos.Lineas de materias primas" )
   oFr:SetResyncPair(   "Lineas de materias primas", "Tipos.Lineas de material producido" )

   oFr:SetResyncPair(   "Lineas de personal", "Operarios" )

   oFr:SetResyncPair(   "Lineas de personal", "Lineas de horas de personal" )

*/
   //-----------------------------------------------------------

   //al tener solo un  tipo de informe no necesitamos el case
   ::FastReportParteProduccion()

   ::AddVariable()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariable() CLASS TFastProduccion 

   /*
   Tablas en funcion del tipo de informe---------------------------------------
   */
   // al tener solo un tipo de de informe no necesitamos el case
   
   ::AddVariableLineasParteProduccion
   

Return ( Super:AddVariable() )

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TFastProduccion

   ::oDbf:Zap()

   /*
   Recorremos los partes de produccion------------------------------------------------------
   */

   ::AddParteProducccion()

   ::oDbf:SetFilter( ::oFilter:cExpresionFilter )

   ::oDbf:GoTop()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//
