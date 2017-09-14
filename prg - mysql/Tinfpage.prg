#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfPAge FROM TInfGen

   METHOD Fields()

   METHOD RentFields()

   METHOD AcuCreate()

   METHOD AddPre( lAcumula )

   METHOD AddPed( lAcumula )

   METHOD AddAlb( lAcumula )

   METHOD AppAlb( lAcumula )

   METHOD AcuAlb()

   METHOD AddFac( lAcumula )

   METHOD AddFacRec( lAcumula )

   METHOD AddFacRecVta( lAcumula )

   METHOD AddTik( cCodArt, nPrecio, lAcumula )

   METHOD AddRAlb()

   METHOD AddRFac()

   METHOD AddRFacRec()

   METHOD AddRTik( cCodArt, nPrecio )

   METHOD IncluyeCero()

   METHOD IncluyeCeroArt()

   METHOD NewGroup( lDesPrp )

   METHOD QuiGroup( lDesPrp )

END CLASS

//---------------------------------------------------------------------------//

METHOD Fields()

   ::AddField( "cCodAge", "C",  3, 0, {|| "@!" },       "Cod. Age. ",                  .f., "Código agente",                3, .f. )
   ::AddField( "cNomAge", "C", 50, 0, {|| "@!" },       "Agente",                      .f., "Nombre agente",               28, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },       "Art.",                        .f., "Código artículo",             14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },       "Descripción",                 .f., "Descripción",                 35, .f. )
   ::FldPropiedades()
   ::AddField( "cLote",   "C", 14, 0, ,                 "Lote",                        .f., "Número de lote",              10, .f. )
   ::FldCliente()
   ::AddField( "nNumCaj", "N", 16, 6, {|| MasUnd() },   cNombreCajas(),                .f., cNombreCajas(),                12, .t. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },   cNombreUnidades(),             .f., cNombreUnidades(),             12, .t. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },   "Tot. " + cNombreUnidades(),   .t., "Total " + cNombreUnidades(),  12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },  "Precio",                      .t., "Precio",                      12, .f. )
   ::AddField( "nPntVer", "N", 16, 6, {|| ::cPicPnt },  "Pnt. ver.",                   .f., "Punto verde",                 10, .f. )
   ::AddField( "nImpTrn", "N", 16, 6, {|| ::cPicImp },  "Portes",                      .f., "Portes",                      10, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },  "Base",                        .t., "Base",                        12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },   "Tot. peso",                   .f., "Total peso",                  12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },  "Pre. Kg.",                    .f., "Precio kilo",                 12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },   "Tot. volumen",                .f., "Total volumen",               12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },  "Pre. vol.",                   .f., "Precio volumen",              12, .f. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },  cImp(),                      .t., cImp(),                      12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },  "Total",                       .t., "Total",                       12, .t. )
   ::AddField( "nComAge", "N", 16, 6, {|| ::cPicOut },  "% Com.",                      .f., "Comisión agente",             12, .f. )
   ::AddField( "nTotCom", "N", 16, 6, {|| ::cPicOut },  "Total Com.",                  .f., "Total comisión",              12, .t. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },       "Doc.",                        .t., "Documento",                    8, .f. )
   ::AddField( "cTipDoc", "C", 20, 0, {|| "@!" },       "Tipo",                        .f., "Tipo de documento",           10, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },       "Fecha",                       .t., "Fecha",                       10, .f. )
   ::AddField( "cTipVen", "C", 20, 0, {|| "@!" },       "Venta",                       .f., "Tipo de venta",               10, .f. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD RentFields()

   ::AddField( "cCodAge", "C",  3, 0, {|| "@!" },           "Cod. Age. ",        .f., "Código agente",          3, .f. )
   ::AddField( "cNomAge", "C", 50, 0, {|| "@!" },           "Agente",            .f., "Nombre agente",         28, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },           "Código artículo",         .f., "Codigo artículo",       14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },           "Descripción",       .f., "Descripción",           35, .f. )
   ::FldPropiedades()
   ::AddField( "cLote",   "C", 14, 0,  ,    "Lote",              .f., "Número de lote",        10, .f. )
   ::FldCliente()
   ::AddField( "nTotCaj", "N", 16, 6, {|| MasUnd() },       cNombreCajas(),      .f., cNombreCajas(),          12, .t. )
   ::AddField( "nTotUni", "N", 16, 6, {|| MasUnd() },       cNombreUnidades(),   .t., cNombreUnidades(),       12, .t. )
   ::AddField( "nTotImp", "N", 16, 6, {|| ::cPicOut },      "Tot. importe",      .t., "Tot. importe",          12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },       "Tot. peso",         .f., "Total peso",            12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },      "Pre. Kg.",          .f., "Precio kilo",           12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },       "Tot. volumen",      .f., "Total volumen",         12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },      "Pre. vol.",         .f., "Precio volumen",        12, .f. )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicOut },      "Tot. costo",        .t., "Total costo",           12, .f. )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut },      "Margen",            .t., "Margen",                12, .f. )
   ::AddField( "nDtoAtp", "N", 16, 6, {|| ::cPicOut },      "Dto. Atipico",      .f., "Importe dto. atipico",  12, .t. )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },      "%Rent.",            .t., "Rentabilidad",          12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Precio medio",      .f., "Precio medio",          12, .f. )
   ::AddField( "nCosMed", "N", 16, 6, {|| ::cPicOut },      "Costo medio",       .t., "Costo medio",           12, .f. )
   ::AddField( "cNumDoc", "C", 14, 0, {|| "@!" },           "Documento",         .t., "Documento",             12, .f. )
   ::AddField( "cTipDoc", "C", 20, 0, {|| "@!" },           "Tip. Doc.",         .f., "Tipo de documento",     15, .f. )
   ::AddField( "nComAge", "N", 16, 6, {|| ::cPicOut },      "% Com.",            .f., "Comisión agente",       12, .f. )
   ::AddField( "nTotCom", "N", 16, 6, {|| ::cPicOut },      "Total Com.",        .f., "Total comisión",        12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AcuCreate()

   ::AddField( "cCodAge", "C",  3, 0, {|| "@!" },           "Cod. Age. ",                 .t., "Código agente"             ,  3, .f. )
   ::AddField( "cNomAge", "C", 50, 0, {|| "@!" },           "Agente",                     .t., "Nombre agente"             , 28, .f. )
   ::AddField( "nNumCaj", "N", 16, 6, {|| MasUnd() },       cNombreCajas(),               .f., cNombreCajas()              , 12, .t. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },       cNombreUnidades(),            .f., cNombreUnidades()           , 12, .t. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },       "Tot. " + cNombreUnidades(),  .t., "Total " + cNombreUnidades(), 12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },      "Precio",                     .f., "Precio"                    , 12, .f. )
   ::AddField( "nPntVer", "N", 16, 6, {|| ::cPicImp },      "Pnt. ver.",                  .f., "Punto verde"               , 10, .f. )
   ::AddField( "nImpTrn", "N", 16, 6, {|| ::cPicImp },      "Portes",                     .f., "Portes"                    , 10, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },      "Base",                       .t., "Base"                      , 12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },       "Tot. peso",                  .f., "Total peso"                , 12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },      "Pre. Kg.",                   .f., "Precio kilo"               , 12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },       "Tot. volumen",               .f., "Total volumen"             , 12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },      "Pre. vol.",                  .f., "Precio volumen"            , 12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Pre. Med.",                  .t., "Precio medio"              , 12, .f. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },      cImp(),                     .t., cImp()                    , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },      "Total",                      .t., "Total"                     , 12, .t. )
   ::AddField( "nTotCom", "N", 16, 6, {|| ::cPicOut },      "Total Com.",                 .f., "Total comisión"            , 12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddPre( lAcumula )

   DEFAULT lAcumula     := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oPreCliT:cCodAge )

      ::oDbf:Append()

      ::oDbf:cCodAge    := ::oPreCliT:cCodAge
      if ( ::oDbfAge:Seek (::oPreCliT:cCodAge) )
         ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
      end if

      ::oDbf:nNumUni    := nTotNPreCli( ::oPreCliL )
      ::oDbf:nTotCom    := nComLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )
      ::oDbf:nImpTot    := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nImpArt    := nTotUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUPreCli( ::oPreCliL:cAlias, ::nDecPnt, ::nValDiv )
      ::oDbf:nIvaTot    := nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oPreCliL:cRef, nTotNPreCli( ::oPreCliL ), ::oDbf:nImpTot, .f. )

      if !lAcumula

         ::AddCliente( ::oPreCliT:cCodCli, ::oPreCliT, .f. )
         ::oDbf:nComAge := ::oPreCliL:nComAge
         ::oDbf:cCodArt := ::oPreCliL:cRef
         ::oDbf:cNomArt := ::oPreCliL:cDetalle
         ::oDbf:cCodPr1 := ::oPreCliL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oPreCliL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oPreCliL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oPreCliL:cCodPr2 )
         ::oDbf:cValPr1 := ::oPreCliL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oPreCliL:cCodPr1 + ::oPreCliL:cValPr1 )
         ::oDbf:cValPr2 := ::oPreCliL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oPreCliL:cCodPr2 + ::oPreCliL:cValPr2 )
         ::oDbf:cLote   := ::oPreCliL:cLote
         ::oDbf:nUniDad := ::oPreCliL:nUniCaja
         ::oDbf:nNumCaj := ::oPreCliL:nCanEnt
         ::oDbf:cDocMov := ::oPreCliL:cSerPre + "/" + lTrim( Str( ::oPreCliL:nNumPre ) ) + "/" + lTrim( ::oPreCliL:cSufPre )
         ::oDbf:cTipDoc := "Presupuesto"
         ::oDbf:dFecMov := ::oPreCliT:dFecPre

      end if

      ::oDbf:Save()

   else

      ::oDbf:Load()

      ::oDbf:nTotCom    += nComLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )
      ::oDbf:nNumUni    += nTotNPreCli( ::oPreCliL )
      ::oDbf:nImpArt    += nTotUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nTotFin    += nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oPreCliL:cRef, nTotNPreCli( ::oPreCliL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddPed( lAcumula )

   DEFAULT lAcumula     := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oPedCliT:cCodAge )

      ::oDbf:Append()

      ::oDbf:cCodAge    := ::oPedCliT:cCodAge
      if ( ::oDbfAge:Seek (::oPedCliT:cCodAge) )
         ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
      end if

      ::oDbf:nNumUni    := nTotNPedCli( ::oPedCliL )
      ::oDbf:nTotCom    := nComLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
      ::oDbf:nImpTot    := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nImpArt    := nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUPedCli( ::oPedCliL:cAlias, ::nDecPnt, ::nValDiv )
      ::oDbf:nIvaTot    := nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDecOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oPedCliL:cRef, nTotNPedCli( ::oPedCliL ), ::oDbf:nImpTot, .f. )

      if !lAcumula

         ::AddCliente( ::oPedCliT:cCodCli, ::oPedCliT, .f. )
         ::oDbf:nComAge := ::oPedCliL:nComAge
         ::oDbf:cCodArt := ::oPedCliL:cRef
         ::oDbf:cNomArt := ::oPedCliL:cDetalle
         ::oDbf:cCodPr1 := ::oPedCliL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oPedCliL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oPedCliL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oPedCliL:cCodPr2 )
         ::oDbf:cValPr1 := ::oPedCliL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oPedCliL:cCodPr1 + ::oPedCliL:cValPr1 )
         ::oDbf:cValPr2 := ::oPedCliL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oPedCliL:cCodPr2 + ::oPedCliL:cValPr2 )
         ::oDbf:cLote   := ::oPedCliL:cLote
         ::oDbf:nUniDad := ::oPedCliL:nUniCaja
         ::oDbf:nNumCaj := ::oPedCliL:nCanEnt
         ::oDbf:cDocMov := ::oPedCliL:cSerPed + "/" + lTrim( Str( ::oPedCliL:nNumPed ) ) + "/" + lTrim( ::oPedCliL:cSufPed )
         ::oDbf:cTipDoc := "Pedido"
         ::oDbf:dFecMov := ::oPedCliT:dFecPed

      end if

      ::oDbf:Save()

   else

      ::oDbf:Load()

      ::oDbf:nTotCom    += nComLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
      ::oDbf:nNumUni    += nTotNPedCli( ::oPedCliL )
      ::oDbf:nImpArt    += nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDecOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDecOut, ::nValDiv )

      ::AcuPesVol( ::oPedCliL:cRef, nTotNPedCli( ::oPedCliL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFac( lAcumula )

   DEFAULT lAcumula     := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oFacCliT:cCodAge )

      ::oDbf:Append()

      ::oDbf:cCodAge    := ::oFacCliT:cCodAge
      if ( ::oDbfAge:Seek (::oFacCliT:cCodAge) )
         ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
      end if

      ::oDbf:nNumUni    := nTotNFacCli( ::oFacCliL )
      ::oDbf:nTotCom    := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
      ::oDbf:nImpTot    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nImpArt    := nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUFacCli( ::oFacCliL:cAlias, ::nDecPnt, ::nValDiv )
      ::oDbf:nIvaTot    := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .f. )

      if !lAcumula

         ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )
         ::oDbf:nComAge := ::oFacCliL:nComAge
         ::oDbf:cCodArt := ::oFacCliL:cRef
         ::oDbf:cNomArt := ::oFacCliL:cDetalle
         ::oDbf:cCodPr1 := ::oFacCliL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oFacCliL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oFacCliL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oFacCliL:cCodPr2 )
         ::oDbf:cValPr1 := ::oFacCliL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oFacCliL:cCodPr1 + ::oFacCliL:cValPr1 )
         ::oDbf:cValPr2 := ::oFacCliL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oFacCliL:cCodPr2 + ::oFacCliL:cValPr2 )
         ::oDbf:cLote   := ::oFacCliL:cLote
         ::oDbf:nUniDad := ::oFacCliL:nUniCaja
         ::oDbf:nNumCaj := ::oFacCliL:nCanEnt
         ::oDbf:cDocMov := ::oFacCliL:cSerie + "/" + lTrim( Str( ::oFacCliL:nNumFac ) ) + "/" + lTrim( ::oFacCliL:cSufFac )
         ::oDbf:cTipDoc := "Factura"
         ::oDbf:dFecMov := ::oFacCliT:dFecFac

      end if

      ::oDbf:Save()

   else

      ::oDbf:Load()

      ::oDbf:nTotCom    += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
      ::oDbf:nNumUni    += nTotNFacCli( ::oFacCliL )
      ::oDbf:nImpArt    += nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFacRec( lAcumula )

   DEFAULT lAcumula     := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oFacRecT:cCodAge )

      ::oDbf:Append()

      ::oDbf:cCodAge    := ::oFacRecT:cCodAge
      if ( ::oDbfAge:Seek (::oFacRecT:cCodAge) )
         ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
      end if

      ::oDbf:nNumUni    := nTotNFacRec( ::oFacRecL )
      ::oDbf:nTotCom    := nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
      ::oDbf:nImpTot    := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nImpArt    := nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUFacRec( ::oFacRecL:cAlias, ::nDecPnt, ::nValDiv )
      ::oDbf:nIvaTot    := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .f. )

      if !lAcumula

         ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )
         ::oDbf:nComAge := ::oFacRecL:nComAge
         ::oDbf:cCodArt := ::oFacRecL:cRef
         ::oDbf:cNomArt := ::oFacRecL:cDetalle
         ::oDbf:cCodPr1 := ::oFacRecL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oFacRecL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oFacRecL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oFacRecL:cCodPr2 )
         ::oDbf:cValPr1 := ::oFacRecL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
         ::oDbf:cValPr2 := ::oFacRecL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oFacRecL:cCodPr2 + ::oFacRecL:cValPr2 )
         ::oDbf:cLote   := ::oFacRecL:cLote
         ::oDbf:nUniDad := ::oFacRecL:nUniCaja
         ::oDbf:nNumCaj := ::oFacRecL:nCanEnt
         ::oDbf:cDocMov := ::oFacRecL:cSerie + "/" + lTrim( Str( ::oFacRecL:nNumFac ) ) + "/" + lTrim( ::oFacRecL:cSufFac )
         ::oDbf:cTipDoc := "Factura"
         ::oDbf:dFecMov := ::oFacRecT:dFecFac

      end if

      ::oDbf:Save()

   else

      ::oDbf:Load()

      ::oDbf:nTotCom    += nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
      ::oDbf:nNumUni    += nTotNFacRec( ::oFacRecL )
      ::oDbf:nImpArt    += nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nTotFin    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFacRecVta( lAcumula )

   DEFAULT lAcumula     := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oFacRecT:cCodAge )

      ::oDbf:Append()

      ::oDbf:cCodAge    := ::oFacRecT:cCodAge
      if ( ::oDbfAge:Seek (::oFacRecT:cCodAge) )
         ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
      end if

      ::oDbf:nNumUni    := nTotNFacRec( ::oFacRecL )
      ::oDbf:nTotCom    := nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
      ::oDbf:nImpTot    := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nImpArt    := nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUFacRec( ::oFacRecL:cAlias, ::nDecPnt, ::nValDiv )
      ::oDbf:nIvaTot    := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .f. )

      if !lAcumula

         ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )
         ::oDbf:nComAge := ::oFacRecL:nComAge
         ::oDbf:cCodArt := ::oFacRecL:cRef
         ::oDbf:cNomArt := ::oFacRecL:cDetalle
         ::oDbf:cCodPr1 := ::oFacRecL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oFacRecL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oFacRecL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oFacRecL:cCodPr2 )
         ::oDbf:cValPr1 := ::oFacRecL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
         ::oDbf:cValPr2 := ::oFacRecL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oFacRecL:cCodPr2 + ::oFacRecL:cValPr2 )
         ::oDbf:cLote   := ::oFacRecL:cLote
         ::oDbf:nUniDad := ::oFacRecL:nUniCaja
         ::oDbf:nNumCaj := ::oFacRecL:nCanEnt
         ::oDbf:cDocMov := ::oFacRecL:cSerie + "/" + lTrim( Str( ::oFacRecL:nNumFac ) ) + "/" + lTrim( ::oFacRecL:cSufFac )
         ::oDbf:cTipDoc := "Factura"
         ::oDbf:dFecMov := ::oFacRecT:dFecFac

      end if

      ::oDbf:Save()

   else

      ::oDbf:Load()

      ::oDbf:nTotCom    += nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
      ::oDbf:nNumUni    += nTotNFacRec( ::oFacRecL )
      ::oDbf:nImpArt    += nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nTotFin    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddAlb( lAcumula )

   DEFAULT lAcumula     := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oAlbCliT:cCodAge )

      ::oDbf:Append()

      ::oDbf:cCodAge    := ::oAlbCliT:cCodAge
      if ( ::oDbfAge:Seek (::oAlbCliT:cCodAge) )
         ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
      end if

      ::oDbf:nNumUni    := nTotNAlbCli( ::oAlbCliL )
      ::oDbf:nTotCom    := nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
      ::oDbf:nImpTot    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nImpArt    := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecPnt, ::nValDiv )
      ::oDbf:nIvaTot    := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .f. )

      if !lAcumula

         ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
         ::oDbf:nComAge := ::oAlbCliL:nComAge
         ::oDbf:cCodArt := ::oAlbCliL:cRef
         ::oDbf:cNomArt := ::oAlbCliL:cDetalle
         ::oDbf:cCodPr1 := ::oAlbCliL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oAlbCliL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oAlbCliL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oAlbCliL:cCodPr2 )
         ::oDbf:cValPr1 := ::oAlbCliL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oAlbCliL:cCodPr1 + ::oAlbCliL:cValPr1 )
         ::oDbf:cValPr2 := ::oAlbCliL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oAlbCliL:cCodPr2 + ::oAlbCliL:cValPr2 )
         ::oDbf:cLote   := ::oAlbCliL:cLote
         ::oDbf:nUniDad := ::oAlbCliL:nUniCaja
         ::oDbf:nNumCaj := ::oAlbCliL:nCanEnt
         ::oDbf:cDocMov := ::oAlbCliL:cSerAlb + "/" + lTrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + lTrim( ::oAlbCliL:cSufAlb )
         ::oDbf:cTipDoc := "Albarán"
         ::oDbf:dFecMov := ::oAlbCliT:dFecAlb

      end if

      ::oDbf:Save()

   else

      ::oDbf:Load()

      ::oDbf:nTotCom    += nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
      ::oDbf:nNumUni    += nTotNAlbCli( ::oAlbCliL )
      ::oDbf:nImpArt    += nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AppAlb( lAcumula )

   DEFAULT  lAcumula := .f.

   ::oDbf:Append()

   ::oDbf:cCodAge    := ::oAlbCliT:cCodAge
   if ( ::oDbfAge:Seek (::oAlbCliT:cCodAge) )
      ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
   end if

   ::oDbf:nNumCaj    := ::oAlbCliL:nCanEnt
   ::oDbf:nUniDad    := ::oAlbCliL:nUniCaja
   ::oDbf:nNumUni    := nTotNAlbCli( ::oAlbCliL )
   ::oDbf:nImpArt    := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
   ::oDbf:nPntVer    := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
   ::oDbf:nImpTrn    := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
   ::oDbf:nImpTot    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
   ::oDbf:nIvaTot    := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
   ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

   ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .f. )

   ::oDbf:nTotCom    := nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

   /*Añadimos los campos que no utilizamos cuando acumulamos*/

   if !lAcumula

      ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )

      ::oDbf:cCodArt    := ::oAlbCliL:cRef
      ::oDbf:cNomArt    := ::oAlbCliL:cDetalle
      ::oDbf:cCodPr1    := ::oAlbCliL:cCodPr1
      ::oDbf:cNomPr1    := retProp( ::oAlbCliL:cCodPr1 )
      ::oDbf:cCodPr2    := ::oAlbCliL:cCodPr2
      ::oDbf:cNomPr2    := retProp( ::oAlbCliL:cCodPr2 )
      ::oDbf:cValPr1    := ::oAlbCliL:cValPr1
      ::oDbf:cNomVl1    := retValProp( ::oAlbCliL:cCodPr1 + ::oAlbCliL:cValPr1 )
      ::oDbf:cValPr2    := ::oAlbCliL:cValPr2
      ::oDbf:cNomVl2    := retValProp( ::oAlbCliL:cCodPr2 + ::oAlbCliL:cValPr2 )
      ::oDbf:cDocMov    := ::oAlbCliL:cSerAlb + "/" + lTrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + lTrim( ::oAlbCliL:cSufAlb )
      ::oDbf:cTipDoc    := "Albarán"
      ::oDbf:dFecMov    := ::oAlbCliT:dFecAlb
      ::oDbf:nComAge    := ::oAlbCliL:nComAge

   else

      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AcuAlb()

   if ::oDbf:Seek( ::oAlbCliT:cCodAge + ::oAlbCliL:cRef )

      /*Acumulamos*/

      ::oDbf:Load()

      ::oDbf:nNumCaj    += ::oAlbCliL:nCanEnt
      ::oDbf:nUniDad    += ::oAlbCliL:nUniCaja
      ::oDbf:nNumUni    += nTotNAlbCli( ::oAlbCliL )
      ::oDbf:nImpArt    += nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nIvaTot    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

      ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .t. )

      ::oDbf:nTotCom    += nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

      ::oDbf:Save()

   else

      /*Añadimos*/

      ::AppAlb( .t. )

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddTik( cCodArt, nPrecio, lAcumula )

   DEFAULT nPrecio         := 1
   DEFAULT lAcumula        := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oTikCliT:cCodAge )

      ::oDbf:Append()

      ::oDbf:cCodAge    := ::oTikCliT:cCodAge
      if ( ::oDbfAge:Seek (::oTikCliT:cCodAge) )
         ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
      end if

      if ::oTikCliT:cTipTik == "4"
         ::oDbf:nNumUni := - ::oTikCliL:nUntTil
      else
        ::oDbf:nNumUni  := ::oTikCliL:nUntTil
      end if

      ::oDbf:nImpArt    := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, nPrecio )
      ::oDbf:nImpTot    := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, nPrecio )
      ::oDbf:nIvaTot    := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nPrecio )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( cCodArt, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .f. )

      if !lAcumula
         ::oDbf:dFecMov    := ::oTikCliT:dFecTik
         ::oDbf:cCodArt    := cCodArt
         ::oDbf:cNomArt    := RetArticulo( cCodArt, ::oDbfArt )
         ::oDbf:cCodPr1    := ::oTikCliL:cCodPr1
         ::oDbf:cNomPr1    := retProp( ::oTikCliL:cCodPr1 )
         ::oDbf:cCodPr2    := ::oTikCliL:cCodPr2
         ::oDbf:cNomPr2    := retProp( ::oTikCliL:cCodPr2 )
         ::oDbf:cValPr1    := ::oTikCliL:cValPr1
         ::oDbf:cNomVl1    := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
         ::oDbf:cValPr2    := ::oTikCliL:cValPr2
         ::oDbf:cLote      := ::oTikCliL:cLote
         ::oDbf:cNomVl2    := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )
         ::oDbf:cTipDoc    := "Tiket"
         ::oDbf:cDocMov    := ::oTikCliL:cSerTil + "/" + lTrim ( ::oTikCliL:cNumTil ) + "/" + lTrim ( ::oTikCliL:cSufTil )

         ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )
      end if

      ::oDbf:Save()

   else

      ::oDbf:Load()

      if ::oTikCliT:cTipTik == "4"
        ::oDbf:nNumUni  -= ::oTikCliL:nUntTil
      else
        ::oDbf:nNumUni  += ::oTikCliL:nUntTil
      end if

      ::oDbf:nImpArt    += nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, nPrecio )
      ::oDbf:nImpTot    += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, nPrecio )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nPrecio )
      ::oDbf:nTotFin    += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, nPrecio )
      ::oDbf:nTotFin    += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nPrecio )

      ::AcuPesVol( cCodArt, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddRTik( cCodArt, nPrecio )

   local nTotUni
   local nTotImpUni
   local nTotCosUni
   local nImpDtoAtp

   /*
   Calculamos las cajas en vendidas entre dos fechas
   */

   nTotUni              := ::oTikCliL:nUntTil
   nTotImpUni           := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, nPrecio )
   nImpDtoAtp           := 0

   if ::oTikCliL:nCosDiv != 0
      nTotCosUni        := ::oTikCliL:nCosDiv * nTotUni
   else
      nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, cCodArt ) * nTotUni
   end if

   ::oDbf:Append()

   ::oDbf:cCodArt    := cCodArt
   ::oDbf:cNomArt    := RetArticulo( cCodArt, ::oDbfArt )
   ::oDbf:cCodPr1    := ::oTikCliL:cCodPr1
   ::oDbf:cNomPr1    := retProp( ::oTikCliL:cCodPr1 )
   ::oDbf:cCodPr2    := ::oTikCliL:cCodPr2
   ::oDbf:cNomPr2    := retProp( ::oTikCliL:cCodPr2 )
   ::oDbf:cValPr1    := ::oTikCliL:cValPr1
   ::oDbf:cNomVl1    := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
   ::oDbf:cValPr2    := ::oTikCliL:cValPr2
   ::oDbf:cNomVl2    := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )
   ::oDbf:cLote      := ::oTikCliL:cLote
   ::oDbf:cCodAge    := ::oTikCliT:cCodAge
   if ( ::oDbfAge:Seek (::oTikCliT:cCodAge) )
      ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
   end if
   ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )
   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( cCodArt, ::oDbfArt, "nPesoKg" )
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
   ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( cCodArt, ::oDbfArt, "nVolumen" )
   ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
   ::oDbf:nTotCos    := nTotCosUni
   ::oDbf:nMargen    := nTotImpUni - nTotCosUni
   ::oDbf:nDtoAtp    := nImpDtoAtp

   if nTotUni != 0 .and. nTotCosUni != 0
      ::oDbf:nRentab := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
      ::oDbf:nPreMed := nTotImpUni / nTotUni
      ::oDbf:nCosMed := nTotCosUni / nTotUni
   else
      ::oDbf:nRentab := 0
      ::oDbf:nPreMed := 0
      ::oDbf:nCosMed := 0
   end if
   ::oDbf:cNumDoc    := ::oTikCliL:cSerTiL + "/" + Alltrim( ::oTikCliL:cNumTiL ) + "/" + ::oTikCliL:cSufTiL
   ::oDbf:cTipDoc    := "Ticket"

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddRAlb()

   local nTotUni
   local nTotImpUni
   local nTotCosUni
   local nImpDtoAtp
   local nTotalComision

   /*
   Calculamos las cajas en vendidas entre dos fechas
   */

   nTotUni              := nTotNAlbCli( ::oAlbCliL:cAlias )
   nTotImpUni           := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
   nImpDtoAtp           := nDtoAtpAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
   nTotalComision       := nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

   if ::lCosAct .or. ::oAlbCliL:nCosDiv == 0
      nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
   else
      nTotCosUni        := ::oAlbCliL:nCosDiv * nTotUni
   end if

   ::oDbf:Append()

   ::oDbf:cCodArt    := ::oAlbCliL:cRef
   ::oDbf:cNomArt    := ::oAlbCliL:cDetalle
   ::oDbf:cCodPr1    := ::oAlbCliL:cCodPr1
   ::oDbf:cNomPr1    := retProp( ::oAlbCliL:cCodPr1 )
   ::oDbf:cCodPr2    := ::oAlbCliL:cCodPr2
   ::oDbf:cNomPr2    := retProp( ::oAlbCliL:cCodPr2 )
   ::oDbf:cValPr1    := ::oAlbCliL:cValPr1
   ::oDbf:cNomVl1    := retValProp( ::oAlbCliL:cCodPr1 + ::oAlbCliL:cValPr1 )
   ::oDbf:cValPr2    := ::oAlbCliL:cValPr2
   ::oDbf:cNomVl2    := retValProp( ::oAlbCliL:cCodPr2 + ::oAlbCliL:cValPr2 )
   ::oDbf:cLote      := ::oAlbCliL:cLote
   ::oDbf:cCodAge    := ::oAlbCliT:cCodAge
   if ( ::oDbfAge:Seek (::oAlbCliT:cCodAge) )
      ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
   end if
   ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
   ::oDbf:nTotCaj    := ::oAlbCliL:nCanEnt
   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
   ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nVolumen" )
   ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
   ::oDbf:nTotCos    := nTotCosUni
   ::oDbf:nMargen    := nTotImpUni - nTotCosUni - nTotalComision
   ::oDbf:nDtoAtp    := nImpDtoAtp
   ::oDbf:nComAge    := ::oAlbCliL:nComAge
   ::oDbf:nTotCom    := nTotalComision

   if nTotUni != 0 .and. nTotCosUni != 0
      ::oDbf:nRentab := nRentabilidad( nTotImpUni - nTotalComision, nImpDtoAtp, nTotCosUni )
      ::oDbf:nPreMed := nTotImpUni / nTotUni
      ::oDbf:nCosMed := nTotCosUni / nTotUni
   else
      ::oDbf:nRentab := 0
      ::oDbf:nPreMed := 0
      ::oDbf:nCosMed := 0
   end if

   ::oDbf:cNumDoc    := ::oAlbCliL:cSerAlb + "/" + Alltrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + ::oAlbCliL:cSufAlb
   ::oDbf:cTipDoc    := "Albarán"

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddRFac()

   local nTotUni
   local nTotImpUni
   local nTotCosUni
   local nImpDtoAtp
   local nTotalComision

   /*
   Calculamos las cajas en vendidas entre dos fechas
   */

   nTotUni              := nTotNFacCli( ::oFacCliL:cAlias )
   nTotImpUni           := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
   nImpDtoAtp           := nDtoAtpFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
   nTotalComision       := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

   if ::lCosAct .or. ::oFacCliL:nCosDiv == 0
      nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
   else
      nTotCosUni        := ::oFacCliL:nCosDiv * nTotUni
   end if

   ::oDbf:Append()

   ::oDbf:cCodArt    := ::oFacCliL:cRef
   ::oDbf:cNomArt    := ::oFacCliL:cDetalle
   ::oDbf:cCodPr1    := ::oFacCliL:cCodPr1
   ::oDbf:cNomPr1    := retProp( ::oFacCliL:cCodPr1 )
   ::oDbf:cCodPr2    := ::oFacCliL:cCodPr2
   ::oDbf:cNomPr2    := retProp( ::oFacCliL:cCodPr2 )
   ::oDbf:cValPr1    := ::oFacCliL:cValPr1
   ::oDbf:cNomVl1    := retValProp( ::oFacCliL:cCodPr1 + ::oFacCliL:cValPr1 )
   ::oDbf:cValPr2    := ::oFacCliL:cValPr2
   ::oDbf:cNomVl2    := retValProp( ::oFacCliL:cCodPr2 + ::oFacCliL:cValPr2 )
   ::oDbf:cLote      := ::oFacCliL:cLote
   ::oDbf:cCodAge    := ::oFacCliT:cCodAge
   if ( ::oDbfAge:Seek (::oFacCliT:cCodAge) )
      ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
   end if
   ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )
   ::oDbf:nTotCaj    := ::oFacCliL:nCanEnt
   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
   ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nVolumen" )
   ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
   ::oDbf:nTotCos    := nTotCosUni
   ::oDbf:nMargen    := nTotImpUni - nTotCosUni - nTotalComision
   ::oDbf:nDtoAtp    := nImpDtoAtp
   ::oDbf:nComAge    := ::oFacCliL:nComAge
   ::oDbf:nTotCom    := nTotalComision

   if nTotUni != 0 .and. nTotCosUni != 0
      ::oDbf:nRentab := nRentabilidad( nTotImpUni - nTotalComision, nImpDtoAtp, nTotCosUni )
      ::oDbf:nPreMed := nTotImpUni / nTotUni
      ::oDbf:nCosMed := nTotCosUni / nTotUni
   else
      ::oDbf:nRentab := 0
      ::oDbf:nPreMed := 0
      ::oDbf:nCosMed := 0
   end if

   ::oDbf:cNumDoc    := ::oFacCliL:cSerie + "/" + Alltrim( Str( ::oFacCliL:nNumFac ) ) + "/" + ::oFacCliL:cSufFac
   ::oDbf:cTipDoc    := "Factura"

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddRFacRec()

   local nTotUni
   local nTotImpUni
   local nTotCosUni
   local nImpDtoAtp
   local nTotalComision

   /*
   Calculamos las cajas en vendidas entre dos fechas
   */

   nTotUni              := ( nTotNFacRec( ::oFacRecL:cAlias ) )
   nTotImpUni           := ( nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut ) )
   nImpDtoAtp           := 0
   nTotalComision       := nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )

   if ::lCosAct .or. ::oFacRecL:nCosDiv == 0
      nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
   else
      nTotCosUni        := ::oFacRecL:nCosDiv * nTotUni
   end if

   ::oDbf:Append()

   ::oDbf:cCodArt    := ::oFacRecL:cRef
   ::oDbf:cNomArt    := ::oFacRecL:cDetalle
   ::oDbf:cCodPr1    := ::oFacRecL:cCodPr1
   ::oDbf:cNomPr1    := retProp( ::oFacRecL:cCodPr1 )
   ::oDbf:cCodPr2    := ::oFacRecL:cCodPr2
   ::oDbf:cNomPr2    := retProp( ::oFacRecL:cCodPr2 )
   ::oDbf:cValPr1    := ::oFacRecL:cValPr1
   ::oDbf:cNomVl1    := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
   ::oDbf:cValPr2    := ::oFacRecL:cValPr2
   ::oDbf:cNomVl2    := retValProp( ::oFacRecL:cCodPr2 + ::oFacRecL:cValPr2 )
   ::oDbf:cLote      := ::oFacRecL:cLote
   ::oDbf:cCodAge    := ::oFacRecT:cCodAge
   if ( ::oDbfAge:Seek (::oFacRecT:cCodAge) )
      ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
   end if
   ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )
   ::oDbf:nTotCaj    := ::oFacRecL:nCanEnt
   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nPesoKg" )
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
   ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nVolumen" )
   ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
   ::oDbf:nTotCos    := nTotCosUni
   ::oDbf:nMargen    := nTotImpUni - nTotCosUni - nTotalComision
   ::oDbf:nDtoAtp    := nImpDtoAtp
   ::oDbf:nComAge    := ::oFacRecL:nComAge
   ::oDbf:nTotCom    := nTotalComision

   if nTotUni != 0 .and. nTotCosUni != 0
      ::oDbf:nRentab := nRentabilidad( nTotImpUni - nTotalComision, nImpDtoAtp, nTotCosUni )
      ::oDbf:nPreMed := nTotImpUni / nTotUni
      ::oDbf:nCosMed := nTotCosUni / nTotUni
   else
      ::oDbf:nRentab := 0
      ::oDbf:nPreMed := 0
      ::oDbf:nCosMed := 0
   end if

   ::oDbf:cNumDoc    := ::oFacRecL:cSerie + "/" + Alltrim( Str( ::oFacRecL:nNumFac ) ) + "/" + ::oFacRecL:cSufFac
   ::oDbf:cTipDoc    := "Fac. rec."

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD IncluyeCero()

   /*
   Repaso de todas los grupos de familias--------------------------------------
   */

   ::oDbfAge:GoTop()
   while !::oDbfAge:Eof()

      if ( ::lAgeAll .or. ( ::oDbfAge:cCodAge >= ::cAgeOrg .AND. ::oDbfAge:cCodAge <= ::cAgeDes ) ) .AND.;
         !::oDbf:Seek( ::oDbfAge:cCodAge )

         ::oDbf:Append()
         ::oDbf:Blank()
         ::oDbf:cCodAge    := ::oDbfAge:cCodAge
         ::oDbf:cNomAge    := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
         ::oDbf:Save()

      end if

      ::oDbfAge:Skip()

   end while

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD IncluyeCeroArt()

   ::oDbfAge:GoTop()
   ::oDbfArt:GoTop()

   ::oMtrInf:cText   := "Artículos sin movimiento"
   ::oMtrInf:SetTotal( ::oDbfAge:OrdKeyCount() )

   while !::oDbfAge:Eof()

      if ( ::lAgeAll .or. ( ::oDbfAge:cCodAge >= ::cAgeOrg .AND. ::oDbfAge:cCodAge <= ::cAgeDes ) )

         while !::oDbfArt:Eof()

            if ( ::lAllArt .or. ( ::oDbfArt:Codigo >= ::cArtOrg .AND. ::oDbfArt:Codigo <= ::cArtDes ) ) .and.;
               !::oDbf:Seek( ::oDbfAge:cCodAge + ::oDbfArt:Codigo )

               ::oDbf:Append()
               ::oDbf:Blank()
               ::oDbf:cCodAge    := ::oDbfAge:cCodAge
               ::oDbf:cNomAge    := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
               ::oDbf:cCodArt    := ::oDbfArt:Codigo
               ::oDbf:cNomArt    := ::oDbfArt:Nombre
               ::oDbf:Save()

            end if

         ::oDbfArt:Skip()

         end while

      end if

      ::oDbfAge:Skip()

      ::oMtrInf:AutoInc( ::oDbfAge:OrdKeyNo() )

      ::oDbfArt:GoTop()

   end while

   ::oMtrInf:AutoInc( ::oDbfAge:LastRec() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD NewGroup( lDesPrp )

   if lDesPrp
      ::AddGroup( {|| ::oDbf:cCodAge + ::oDbf:cCodArt + ::oDbf:cCodPr1 + ::oDbf:cCodPr2 + ::oDbf:cValPr1 + ::oDbf:cValPr2 + ::oDbf:cLote },;
      {||   if( !Empty( ::oDbf:cValPr1 ), AllTrim( ::oDbf:cNomPr1 ) + ": " + AllTrim( ::oDbf:cNomVl1 ) + " - ", "" ) + ;
            if( !Empty( ::oDbf:cValPr2 ), AllTrim( ::oDbf:cNomPr2 ) + ": " + AllTrim( ::oDbf:cNomVl2 ) + " - ", "" ) + ;
            if( !Empty( ::oDbf:cLote ), "Lote:" + AllTrim( ::oDbf:cLote ), Space(1) ) },;
      {|| Space(1) } )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD QuiGroup( lDesPrp )

   if lDesPrp
      ::DelGroup()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//