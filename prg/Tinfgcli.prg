#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfGCli FROM TInfGen

   METHOD DetCreateFields()

   METHOD RentCreateFields()

   METHOD AnuGCliFields()

   METHOD AcuCreate()

   METHOD AddPre( lAcumula )

   METHOD AddPed( lAcumula )

   METHOD AddAlb( lAcumula )

   METHOD AddFac( lAcumula )

   METHOD AddFacRec( lAcumula )

   METHOD AddFacRecVta( lAcumula )

   METHOD AddTik( cCodArt, nPrecio, lAcumula )

   METHOD AddRAlb()

   METHOD AddRFac()

   METHOD AddRFacRec()

   METHOD AddRTik( cCodArt, nPrecio )

   METHOD IncluyeCero()

   METHOD NewGroup( lDesPrp )

   METHOD NewGroupR( lDesPrp )

   METHOD QuiGroup( lDesPrp )

END CLASS

//---------------------------------------------------------------------------//

METHOD DetCreateFields()

   ::AddField( "cCodGrc", "C",  5, 0, {|| "@!" },        "Cod.",                       .f., "Código grupo cliente"      ,  5, .f. )
   ::AddField( "cNomGrc", "C", 50, 0, {|| "@!" },        "Grupo",                      .f., "Nombre grupo cliente"      , 20, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },        "Cod. articulo",              .f., "Cod. artículo"             , 10, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },        "Descripción",                .f., "Descripción"               , 15, .f. )
   ::FldPropiedades()
   ::AddField( "cLote",   "C", 14, 0, ,                  "Lote",                       .f., "Número de lote"            , 10, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },        "Cód. cli.",                  .f., "Cod. Cliente"              ,  8, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },        "Cliente",                    .f., "Nom. Cliente"              , 30, .f. )
   ::AddField( "cNifCli", "C", 15, 0, {|| "@!" },        "Nif",                        .f., "Nif"                       , 12, .f. )
   ::AddField( "cDomCli", "C", 35, 0, {|| "@!" },        "Domicilio",                  .f., "Domicilio"                 , 20, .f. )
   ::AddField( "cPobCli", "C", 25, 0, {|| "@!" },        "Población",                  .f., "Población"                 , 25, .f. )
   ::AddField( "cProCli", "C", 20, 0, {|| "@!" },        "Provincia",                  .f., "Provincia"                 , 20, .f. )
   ::AddField( "cCdpCli", "C",  7, 0, {|| "@!" },        "Cod. Postal",                .f., "Cod. Postal"               ,  7, .f. )
   ::AddField( "cTlfCli", "C", 12, 0, {|| "@!" },        "Teléfono",                   .f., "Teléfono"                  , 12, .f. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },        "Doc.",                       .t., "Documento"                 ,  8, .f. )
   ::AddField( "cTipDoc", "C", 20, 0, {|| "@!" },        "Tipo",                       .f., "Tipo de documento"         , 10, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },        "Fecha",                      .t., "Fecha"                     , 10, .f. )
   ::AddField( "cTipVen", "C", 20, 0, {|| "@!" },        "Venta",                      .f., "Tipo de venta"             , 10, .f. )
   ::AddField( "nNumCaj", "N", 16, 6, {|| MasUnd() },    cNombreCajas(),               .f., cNombreCajas()              , 12, .t. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },    cNombreUnidades(),            .f., cNombreUnidades()           , 12, .t. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },    "Tot. " + cNombreUnidades(),  .t., "Total " + cNombreUnidades(), 12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },   "Precio",                     .t., "Precio"                    , 12, .f. )
   ::AddField( "nPntVer", "N", 16, 6, {|| ::cPicImp },   "Pnt. ver.",                  .f., "Punto verde"               , 10, .f. )
   ::AddField( "nImpTrn", "N", 16, 6, {|| ::cPicImp },   "Portes",                     .f., "Portes"                    , 10, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },   "Base",                       .t., "Base"                      , 12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },    "Tot. peso",                  .f., "Total peso"                , 12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },   "Pre. Kg.",                   .f., "Precio kilo"               , 12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },    "Tot. volumen",               .f., "Total volumen"             , 12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },   "Pre. vol.",                  .f., "Precio volumen"            , 12, .f. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },   cImp(),                     .t., cImp()                    , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },   "Total",                      .t., "Total"                     , 12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AnuGCliFields()


   ::AddField ( "cCodGrc", "C",  5, 0, {|| "@!" },         "Cod.",            .t., "Código grupo cliente",    5 )
   ::AddField ( "cNomGrc", "C", 50, 0, {|| "@!" },         "Grupo",           .t., "Nombre grupo cliente",   20 )
   ::AddField ( "nImpEne", "N", 16, 6, {|| ::cPicOut },    "Ene",             .t., "Enero",                  12 )
   ::AddField ( "nImpFeb", "N", 16, 6, {|| ::cPicOut },    "Feb",             .t., "Febrero",                12 )
   ::AddField ( "nImpMar", "N", 16, 6, {|| ::cPicOut },    "Mar",             .t., "Marzo",                  12 )
   ::AddField ( "nImpAbr", "N", 16, 6, {|| ::cPicOut },    "Abr",             .t., "Abril",                  12 )
   ::AddField ( "nImpMay", "N", 16, 6, {|| ::cPicOut },    "May",             .t., "Mayo",                   12 )
   ::AddField ( "nImpJun", "N", 16, 6, {|| ::cPicOut },    "Jun",             .t., "Junio",                  12 )
   ::AddField ( "nImpJul", "N", 16, 6, {|| ::cPicOut },    "Jul",             .t., "Julio",                  12 )
   ::AddField ( "nImpAgo", "N", 16, 6, {|| ::cPicOut },    "Ago",             .t., "Agosto",                 12 )
   ::AddField ( "nImpSep", "N", 16, 6, {|| ::cPicOut },    "Sep",             .t., "Septiembre",             12 )
   ::AddField ( "nImpOct", "N", 16, 6, {|| ::cPicOut },    "Oct",             .t., "Octubre",                12 )
   ::AddField ( "nImpNov", "N", 16, 6, {|| ::cPicOut },    "Nov",             .t., "Noviembre",              12 )
   ::AddField ( "nImpDic", "N", 16, 6, {|| ::cPicOut },    "Dic",             .t., "Diciembre",              12 )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },    "Tot",             .t., "Total",                  12 )
   ::AddField ( "nMedia",  "N", 16, 6, {|| ::cPicOut },    "Media",           .t., "Media",                  12 )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD RentCreateFields()

   ::AddField( "cCodGrc", "C",  5, 0, {|| "@!" },           "Cod.",              .f., "Código grupo cliente",    5, .f. )
   ::AddField( "cNomGrc", "C", 50, 0, {|| "@!" },           "Grupo",             .f., "Nombre grupo cliente",   20, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },           "Código artículo",         .f., "Codigo artículo",        14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },           "Descripción",       .f., "Descripción",            35, .f. )
   ::FldPropiedades()
   ::AddField( "cLote",   "C", 14, 0,  ,    "Lote",              .f., "Número de lote",         10, .f. )
   ::FldCliente()
   ::AddField( "nTotCaj", "N", 16, 6, {|| MasUnd() },       cNombreCajas(),      .f., cNombreCajas(),           12, .t. )
   ::AddField( "nTotUni", "N", 16, 6, {|| MasUnd() },       cNombreUnidades(),   .t., cNombreUnidades(),        12, .t. )
   ::AddField( "nTotImp", "N", 16, 6, {|| ::cPicOut },      "Tot. importe",      .t., "Tot. importe",           12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },       "Tot. peso",         .f., "Total peso",             12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },      "Pre. Kg.",          .f., "Precio kilo",            12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },       "Tot. volumen",      .f., "Total volumen",          12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },      "Pre. vol.",         .f., "Precio volumen",         12, .f. )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicOut },      "Tot. costo",        .t., "Total costo",            12, .f. )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut },      "Margen",            .t., "Margen",                 12, .f. )
   ::AddField( "nDtoAtp", "N", 16, 6, {|| ::cPicOut },      "Dto. Atipico",      .f., "Importe dto. atipico",   12, .t. )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },      "%Rent.",            .t., "Rentabilidad",           12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Precio medio",      .f., "Precio medio",           12, .f. )
   ::AddField( "nCosMed", "N", 16, 6, {|| ::cPicOut },      "Costo medio",       .t., "Costo medio",            12, .f. )
   ::AddField( "cNumDoc", "C", 14, 0, {|| "@!" },           "Documento",         .t., "Documento",              12, .f. )
   ::AddField( "cTipDoc", "C", 20, 0, {|| "@!" },           "Tip. Doc.",         .f., "Tipo de documento",      15, .f. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AcuCreate()

   ::AddField( "cCodGrc", "C",  5, 0, {|| "@!" },           "Cod.",           .t., "Código grupo cliente"  ,  5, .f. )
   ::AddField( "cNomGrc", "C", 50, 0, {|| "@!" },           "Grupo",          .t., "Nombre grupo cliente"  , 20, .f. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },       cNombreUnidades(),.t., cNombreUnidades()       , 12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },      "Precio",         .f., "Precio"                , 12, .f. )
   ::AddField( "nPntVer", "N", 16, 6, {|| ::cPicImp },      "Pnt. ver.",      .f., "Punto verde"           , 10, .f. )
   ::AddField( "nImpTrn", "N", 16, 6, {|| ::cPicImp },      "Portes",         .f., "Portes"                , 10, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },      "Base",           .t., "Base"                  , 12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },       "Tot. peso",      .f., "Total peso"            , 12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },      "Pre. Kg.",       .f., "Precio kilo"           , 12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },       "Tot. volumen",   .f., "Total volumen"         , 12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },      "Pre. vol.",      .f., "Precio volumen"        , 12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Pre. Med.",      .t., "Precio medio"          , 12, .f. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },      "Tot. " + cImp(), .t., "Total " + cImp()          , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },      "Total",          .t., "Total"                 , 12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddPre( lAcumula )

   DEFAULT lAcumula     := .f.

   if !lAcumula .or. !::oDbf:Seek( cGruCli( ::oPreCliT:cCodCli, ::oDbfCli ) )

      ::oDbf:Append()

      ::oDbf:cCodGrc    := cGruCli( ::oPreCliT:cCodCli, ::oDbfCli )
      ::oDbf:cNomGrc    := oRetFld( cGruCli( ::oPreCliT:cCodCli, ::oDbfCli ), ::oGrpCli:oDbf)
      ::oDbf:nNumUni    := nTotNPreCli( ::oPreCliL )
      ::oDbf:nImpArt    := nTotUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nIvaTot    := nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oPreCliL:cRef, nTotNPreCli( ::oPreCliL ), ::oDbf:nImpTot, .f. )

      if !lAcumula

         ::AddCliente( ::oPreCliT:cCodCli, ::oPreCliT, .f. )
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
         ::oDbf:nNumCaj := ::oPreCliL:nCanPre
         ::oDbf:nUniDad := ::oPreCliL:nUniCaja
         ::oDbf:cDocMov := ::oPreCliL:cSerPre + "/" + lTrim( Str( ::oPreCliL:nNumPre ) ) + "/" + lTrim( ::oPreCliL:cSufPre )
         ::oDbf:cTipDoc := "Presupuesto"
         ::oDbf:dFecMov := ::oPreCliT:dFecPre

      end if

      ::oDbf:Save()

   else

      ::oDbf:Load()
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

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( cGruCli( ::oPedCliT:cCodCli, ::oDbfCli ) )

      ::oDbf:Append()

      ::oDbf:cCodGrc    := cGruCli( ::oPedCliT:cCodCli, ::oDbfCli )
      ::oDbf:cNomGrc    := oRetFld( cGruCli( ::oPedCliT:cCodCli, ::oDbfCli ), ::oGrpCli:oDbf)
      ::oDbf:nNumUni    := nTotNPedCli( ::oPedCliL )
      ::oDbf:nImpArt    := nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nIvaTot    := nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDecOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oPedCliL:cRef, nTotNPedCli( ::oPedCliL ), ::oDbf:nImpTot, .f. )

      if !lAcumula
         ::AddCliente( ::oPedCliT:cCodCli, ::oPedCliT, .f. )
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
         ::oDbf:nNumCaj := ::oPedCliL:nCanPed
         ::oDbf:nUniDad := ::oPedCliL:nUniCaja
         ::oDbf:cDocMov := lTrim( ::oPedCliL:cSerPed ) + "/" + lTrim ( Str( ::oPedCliL:nNumPed ) ) + "/" + lTrim ( ::oPedCliL:cSufPed )
         ::oDbf:cTipDoc := "Pedido"
         ::oDbf:dFecMov := ::oPedCliT:dFecPed

      end if

   else

      ::oDbf:Load()
      ::oDbf:nNumUni    += nTotNPedCli( ::oPedCliL )
      ::oDbf:nImpArt    += nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nIvaTot    += nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDecOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDecOut, ::nValDiv )

      ::AcuPesVol( ::oPedCliL:cRef, nTotNPedCli( ::oPedCliL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddAlb( lAcumula )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( cGruCli( ::oAlbCliT:cCodCli, ::oDbfCli ) )

      ::oDbf:Append()

      ::oDbf:cCodGrc    := cGruCli( ::oAlbCliT:cCodCli, ::oDbfCli )
      ::oDbf:cNomGrc    := oRetFld( cGruCli( ::oAlbCliT:cCodCli, ::oDbfCli ), ::oGrpCli:oDbf)
      ::oDbf:nNumUni    := nTotNAlbCli( ::oAlbCliL )
      ::oDbf:nImpArt    := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nIvaTot    := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .f. )

      if !lAcumula
         ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
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
         ::oDbf:nNumCaj := ::oAlbCliL:nCanEnt
         ::oDbf:nUniDad := ::oAlbCliL:nUniCaja
         ::oDbf:cDocMov := ::oAlbCliL:cSerAlb + "/" + lTrim ( Str( ::oAlbCliL:nNumAlb ) ) + "/" + lTrim ( ::oAlbCliL:cSufAlb )
         ::oDbf:cTipDoc := "Albaranes"
         ::oDbf:dFecMov := ::oAlbCliT:dFecAlb

      end if

   else

      ::oDbf:Load()
      ::oDbf:nNumUni    += nTotNAlbCli( ::oAlbCliL )
      ::oDbf:nImpArt    += nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nTotFin    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFac( lAcumula )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( cGruCli( ::oFacCliT:cCodCli, ::oDbfCli ) )

      ::oDbf:Append()

      ::oDbf:cCodGrc    := cGruCli( ::oFacCliT:cCodCli, ::oDbfCli )
      ::oDbf:cNomGrc    := oRetFld( cGruCli( ::oFacCliT:cCodCli, ::oDbfCli ), ::oGrpCli:oDbf)
      ::oDbf:nNumUni    := nTotNFacCli( ::oFacCliL )
      ::oDbf:nImpArt    := nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nIvaTot    := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .f. )

      if !lAcumula
         ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )
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
         ::oDbf:nNumCaj := ::oFacCliL:nCanEnt
         ::oDbf:nUniDad := ::oFacCliL:nUniCaja
         ::oDbf:cDocMov := ::oFacCliL:cSerie + "/" + lTrim ( Str( ::oFacCliL:nNumFac ) ) + "/" + lTrim ( ::oFacCliL:cSufFac )
         ::oDbf:cTipDoc := "Factura"
         ::oDbf:dFecMov := ::oFacCliT:dFecFac

      end if

   else

      ::oDbf:Load()
      ::oDbf:nNumUni    += nTotNFacCli( ::oFacCliL )
      ::oDbf:nImpArt    += nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nTotFin    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFacRec( lAcumula )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( cGruCli( ::oFacRecT:cCodCli, ::oDbfCli ) )

      ::oDbf:Append()

      ::oDbf:cCodGrc    := cGruCli( ::oFacRecT:cCodCli, ::oDbfCli )
      ::oDbf:cNomGrc    := oRetFld( cGruCli( ::oFacRecT:cCodCli, ::oDbfCli ), ::oGrpCli:oDbf)
      ::oDbf:nNumUni    := nTotNFacRec( ::oFacRecL )
      ::oDbf:nImpArt    := nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nIvaTot    := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .f. )

      if !lAcumula
         ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )
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
         ::oDbf:nNumCaj := ::oFacRecL:nCanEnt
         ::oDbf:nUniDad := ::oFacRecL:nUniCaja
         ::oDbf:cDocMov := ::oFacRecL:cSerie + "/" + lTrim ( Str( ::oFacRecL:nNumFac ) ) + "/" + lTrim ( ::oFacRecL:cSufFac )
         ::oDbf:cTipDoc := "Factura"
         ::oDbf:dFecMov := ::oFacRecT:dFecFac

      end if

   else

      ::oDbf:Load()
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

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFacRecVta( lAcumula )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( cGruCli( ::oFacRecT:cCodCli, ::oDbfCli ) )

      ::oDbf:Append()

      ::oDbf:cCodGrc    := cGruCli( ::oFacRecT:cCodCli, ::oDbfCli )
      ::oDbf:cNomGrc    := oRetFld( cGruCli( ::oFacRecT:cCodCli, ::oDbfCli ), ::oGrpCli:oDbf)
      ::oDbf:nNumUni    := nTotNFacRec( ::oFacRecL )
      ::oDbf:nImpArt    := nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nIvaTot    := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .f. )

      if !lAcumula
         ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )
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
         ::oDbf:nNumCaj := ::oFacRecL:nCanEnt
         ::oDbf:nUnidad := ::oFacRecL:nUnicaja
         ::oDbf:cDocMov := ::oFacRecL:cSerie + "/" + lTrim ( Str( ::oFacRecL:nNumFac ) ) + "/" + lTrim ( ::oFacRecL:cSufFac )
         ::oDbf:cTipDoc := "Fac. rec."
         ::oDbf:dFecMov := ::oFacRecT:dFecFac

      end if

   else

      ::oDbf:Load()
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

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddTik( cCodArt, nPrecio, lAcumula )

   DEFAULT nPrecio         := 1
   DEFAULT lAcumula        := .f.

   if !lAcumula .or. !::oDbf:Seek( cGruCli( ::oTikCliT:cCliTik, ::oDbfCli ) )

      ::oDbf:Append()

      ::oDbf:cCodGrc       := cGruCli( ::oTikCliT:cCliTik, ::oDbfCli )
      ::oDbf:cNomGrc       := oRetFld( cGruCli( ::oTikCliT:cCliTik, ::oDbfCli ), ::oGrpCli:oDbf)

      if ::oTikCliT:cTipTik == "4"
         ::oDbf:nNumUni    := - ::oTikCliL:nUntTil
      else
        ::oDbf:nNumUni     := ::oTikCliL:nUntTil
      end if

      ::oDbf:nImpArt       := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, nPrecio )
      ::oDbf:nImpTot       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, nPrecio )
      ::oDbf:nIvaTot       := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nPrecio )
      ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot

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
         ::oDbf:cNomVl2    := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )
         ::oDbf:cLote      := ::oTikCliL:cLote
         ::oDbf:cTipDoc    := "Tiket"
         ::oDbf:cDocMov    := ::oTikCliL:cSerTil + "/" + lTrim ( ::oTikCliL:cNumTil ) + "/" + lTrim ( ::oTikCliL:cSufTil )

         ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )
      end if

      ::oDbf:Save()

   else

      ::oDbf:Load()

      if ::oTikCliT:cTipTik == "4"
        ::oDbf:nNumUni     -= ::oTikCliL:nUntTil
      else
        ::oDbf:nNumUni     += ::oTikCliL:nUntTil
      end if

      ::oDbf:nImpArt       += nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, nPrecio )
      ::oDbf:nImpTot       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, nPrecio )
      ::oDbf:nPreMed       := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nPrecio )
      ::oDbf:nTotFin       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, nPrecio )
      ::oDbf:nTotFin       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nPrecio )

      ::AcuPesVol( cCodArt, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddRAlb()

   local nTotUni
   local nTotImpUni
   local nTotCosUni
   local nImpDtoAtp

   /*
   Calculamos las cajas en vendidas entre dos fechas
   */

   nTotUni              := nTotNAlbCli( ::oAlbCliL:cAlias )
   nTotImpUni           := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
   nImpDtoAtp           := nDtoAtpAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

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
   ::oDbf:cCodGrc    := cGruCli( ::oAlbCliT:cCodCli, ::oDbfCli )
   ::oDbf:cNomGrc    := oRetFld( cGruCli( ::oAlbCliT:cCodCli, ::oDbfCli ), ::oGrpCli:oDbf)

   ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )

   ::oDbf:nTotCaj    := ::oAlbCliL:nCanEnt
   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
   ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nVolumen" )
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

   /*
   Calculamos las cajas en vendidas entre dos fechas
   */

   nTotUni              := nTotNFacCli( ::oFacCliL:cAlias )
   nTotImpUni           := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
   nImpDtoAtp           := nDtoAtpFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

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
   ::oDbf:cCodGrc    := cGruCli( ::oFacCliT:cCodCli, ::oDbfCli )
   ::oDbf:cNomGrc    := oRetFld( cGruCli( ::oFacCliT:cCodCli, ::oDbfCli ), ::oGrpCli:oDbf)

   ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

   ::oDbf:nTotCaj    := ::oFacCliL:nCanEnt
   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
   ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nVolumen" )
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

   /*
   Calculamos las cajas en vendidas entre dos fechas
   */

   nTotUni              := -( nTotNFacRec( ::oFacRecL:cAlias ) )
   nTotImpUni           := -( nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut ) )
   nImpDtoAtp           := 0

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
   ::oDbf:cCodGrc    := cGruCli( ::oFacRecT:cCodCli, ::oDbfCli )
   ::oDbf:cNomGrc    := oRetFld( cGruCli( ::oFacRecT:cCodCli, ::oDbfCli ), ::oGrpCli:oDbf)

   ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )

   ::oDbf:nTotCaj    := ::oFacRecL:nCanEnt
   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nPesoKg" )
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
   ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nVolumen" )
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

   ::oDbf:cNumDoc    := ::oFacRecL:cSerie + "/" + Alltrim( Str( ::oFacRecL:nNumFac ) ) + "/" + ::oFacRecL:cSufFac
   ::oDbf:cTipDoc    := "Fac. rec."

   ::oDbf:Save()

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

   nTotUni           := ::oTikCliL:nUntTil
   nTotImpUni        := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, nPrecio )
   nImpDtoAtp        := 0

   if ::oTikCliL:nCosDiv != 0
      nTotCosUni     := ::oTikCliL:nCosDiv * nTotUni
   else
      nTotCosUni     := nRetPreCosto( ::oDbfArt:cAlias, cCodArt ) * nTotUni
   end if

   ::oDbf:Append()

   ::oDbf:cCodGrc    := cGruCli( ::oTikCliT:cCliTik, ::oDbfCli )
   ::oDbf:cNomGrc    := oRetFld( cGruCli( ::oTikCliT:cCliTik, ::oDbfCli ), ::oGrpCli:oDbf)
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

METHOD IncluyeCero()

   /*
   Repaso de todas los grupos de clientes--------------------------------------
   */

   ::oGrpCli:oDbf:GoTop()
   while !::oGrpCli:oDbf:Eof()

      if ( ::lGrpAll .or. ( ::oGrpCli:oDbf:cCodGrp >= ::cGrpOrg .AND. ::oGrpCli:oDbf:cCodGrp <= ::cGrpDes ) ) .AND.;
         !::oDbf:Seek( ::oGrpCli:oDbf:cCodGrp )

         ::oDbf:Append()
         ::oDbf:Blank()
         ::oDbf:cCodGrc    := ::oGrpCli:oDbf:cCodGrp
         ::oDbf:cNomGrc    := ::oGrpCli:oDbf:cNomGrp
         ::oDbf:Save()

      end if

      ::oGrpCli:oDbf:Skip()

   end while

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD NewGroup( lDesPrp )

   if lDesPrp
      ::AddGroup( {|| ::oDbf:cCodGrC + ::oDbf:cCodCli + ::oDbf:cCodArt + ::oDbf:cCodPr1 + ::oDbf:cCodPr2 + ::oDbf:cValPr1 + ::oDbf:cValPr2 + ::oDbf:cLote },;
      {||   if( !Empty( ::oDbf:cValPr1 ), AllTrim( ::oDbf:cNomPr1 ) + ": " + AllTrim( ::oDbf:cNomVl1 ) + " - ", "" ) + ;
            if( !Empty( ::oDbf:cValPr2 ), AllTrim( ::oDbf:cNomPr2 ) + ": " + AllTrim( ::oDbf:cNomVl2 ) + " - ", "" ) + ;
            if( !Empty( ::oDbf:cLote ), "Lote:" + AllTrim( ::oDbf:cLote ), Space( 1 ) ) },;
      {|| Space(1) } )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD NewGroupR( lDesPrp )

   if lDesPrp
      ::AddGroup( {|| ::oDbf:cCodGrC + ::oDbf:cCodArt + ::oDbf:cCodPr1 + ::oDbf:cCodPr2 + ::oDbf:cValPr1 + ::oDbf:cValPr2 + ::oDbf:cLote },;
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