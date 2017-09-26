#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TPrvInf FROM TInfGen

   METHOD CreateFields()

   METHOD AnuPrvFields()

   METHOD AcuCreate()

   METHOD DiaFields()

   METHOD AddPed( lAcumula )

   METHOD AddAlb( lAcumula )

   METHOD AddFac( lAcumula )

   METHOD IncluyeCero()

END CLASS

//---------------------------------------------------------------------------//

METHOD CreateFields()


   ::FldProveedor()
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },       "Art.",          .f., "Cod. artículo",      14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },       "Artículo",      .f., "Artículo",           40, .f. )
   ::FldPropiedades()
   ::AddField( "nNumCaj", "N", 16, 6, {|| MasUnd() },   cNombreCajas(),  .f., cNombreCajas(),       12, .t. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },   cNombreUnidades(), .f., cNombreUnidades(),  12, .t. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },   "Tot. " + cNombreUnidades(),     .t., "Total " + cNombreUnidades(),     12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },  "Precio",        .t., "Precio",             12, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },  "Base",          .t., "Base",               12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },   "Tot. peso",     .f., "Total peso",         12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },  "Pre. Kg.",      .f., "Precio kilo",        12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },   "Tot. volumen",  .f., "Total volumen",      12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },  "Pre. vol.",     .f., "Precio volumen",     12, .f. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },  cImp(),        .t., cImp(),             12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },  "Total",         .t., "Total",              12, .t. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },       "Doc.",          .f., "Documento",           8, .f. )
   ::AddField( "cDocPrv", "C", 14, 0, {|| "@!" },       "Numero",        .t., "Documento proveedor",10, .f. )
   ::AddField( "cTipDoc", "C", 20, 0, {|| "@!" },       "Tipo",          .f., "Tipo de documento",  10, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },       "Fecha",         .t., "Fecha",              10, .f. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AnuPrvFields()

   ::AddField ( "cCodPrv", "C", 12, 0, {|| "@!" },         "Cod. Prv.",     .t., "Cod. Proveedor",              9 )
   ::AddField ( "cNomPrv", "C", 50, 0, {|| "@!" },         "Proveedor",     .t., "Nombre Proveedor",           35 )
   ::AddField ( "nImpEne", "N", 16, 6, {|| ::cPicOut },    "Ene",           .t., "Enero",                      12 )
   ::AddField ( "nImpFeb", "N", 16, 6, {|| ::cPicOut },    "Feb",           .t., "Febrero",                    12 )
   ::AddField ( "nImpMar", "N", 16, 6, {|| ::cPicOut },    "Mar",           .t., "Marzo",                      12 )
   ::AddField ( "nImpAbr", "N", 16, 6, {|| ::cPicOut },    "Abr",           .t., "Abril",                      12 )
   ::AddField ( "nImpMay", "N", 16, 6, {|| ::cPicOut },    "May",           .t., "Mayo",                       12 )
   ::AddField ( "nImpJun", "N", 16, 6, {|| ::cPicOut },    "Jun",           .t., "Junio",                      12 )
   ::AddField ( "nImpJul", "N", 16, 6, {|| ::cPicOut },    "Jul",           .t., "Julio",                      12 )
   ::AddField ( "nImpAgo", "N", 16, 6, {|| ::cPicOut },    "Ago",           .t., "Agosto",                     12 )
   ::AddField ( "nImpSep", "N", 16, 6, {|| ::cPicOut },    "Sep",           .t., "Septiembre",                 12 )
   ::AddField ( "nImpOct", "N", 16, 6, {|| ::cPicOut },    "Oct",           .t., "Octubre",                    12 )
   ::AddField ( "nImpNov", "N", 16, 6, {|| ::cPicOut },    "Nov",           .t., "Noviembre",                  12 )
   ::AddField ( "nImpDic", "N", 16, 6, {|| ::cPicOut },    "Dic",           .t., "Diciembre",                  12 )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },    "Tot",           .t., "Total",                      12 )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AcuCreate()

   ::FldProveedor()
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },   cNombreUnidades(), .t., cNombreUnidades()    , 12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },  "Precio",          .f., "Precio"             , 12, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },  "Base",            .t., "Base"               , 12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },   "Tot. peso",       .f., "Total peso"         , 12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicOut },  "Pre. Kg.",        .f., "Precio kilo"        , 12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },   "Tot. volumen",    .f., "Total volumen"      , 12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },  "Pre. vol.",       .f., "Precio volumen"     , 12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },  "Pre. Med.",       .t., "Precio medio"       , 12, .f. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },  "Tot. " + cImp(),  .t., "Total " + cImp()       , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },  "Total",           .t., "Total"              , 12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD DiaFields()

   ::AddField ( "cDocMov", "C", 14, 0, {|| "@!" },         "Documento",            .t., "Documento",             14 )
   ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                .t., "Fecha",                 14 )
   ::AddField ( "cNifPrv", "C", 15, 0, {|| "@!" },         "Nif",                  .f., "Nif",                    8 )
   ::AddField ( "cDomPrv", "C", 35, 0, {|| "@!" },         "Domicilio",            .f., "Domicilio",             10 )
   ::AddField ( "cPobPrv", "C", 25, 0, {|| "@!" },         "Población",            .f., "Población",             25 )
   ::AddField ( "cProPrv", "C", 20, 0, {|| "@!" },         "Provincia",            .f., "Provincia",             20 )
   ::AddField ( "cCdpPrv", "C",  7, 0, {|| "@!" },         "CP",                   .f., "Cod. Postal",           20 )
   ::AddField ( "cTlfPrv", "C", 12, 0, {|| "@!" },         "Tlf",                  .f., "Teléfono",               7 )
   ::AddField ( "nTotNet", "N", 16, 6, {|| ::cPicOut },    "Neto",                 .t., "Neto",                  10 )
   ::AddField ( "nTotIva", "N", 16, 6, {|| ::cPicOut },    cImp(),                  .t., cImp(),                   10 )
   ::AddField ( "nTotReq", "N", 16, 3, {|| ::cPicOut },    "Rec",                  .f., "Rec",                   10 )
   ::AddField ( "nTotDoc", "N", 16, 6, {|| ::cPicOut },    "Total",                .t., "Total",                 10 )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddPed( lAcumula )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oPedPrvT:cCodPrv )

      ::oDbf:Append()

      ::AddProveedor( ::oPedPrvT:cCodPrv )
      ::oDbf:nNumUni    := nTotNPedPrv( ::oPedPrvL )
      ::oDbf:nImpArt    := nTotUPedPrv( ::oPedPrvL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nIvaTot    := nIvaLPedPrv( ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oPedPrvL:cRef, nTotNPedPrv( ::oPedPrvL ), ::oDbf:nImpTot, .f. )

      if !lAcumula

         ::oDbf:cCodArt    := ::oPedPrvL:cRef
         ::oDbf:cNomArt    := ::oPedPrvL:cDetalle
         ::oDbf:cCodPr1    := ::oPedPrvL:cCodPr1
         ::oDbf:cNomPr1    := retProp( ::oPedPrvL:cCodPr1 )
         ::oDbf:cCodPr2    := ::oPedPrvL:cCodPr2
         ::oDbf:cNomPr2    := retProp( ::oPedPrvL:cCodPr2 )
         ::oDbf:cValPr1    := ::oPedPrvL:cValPr1
         ::oDbf:cNomVl1    := retValProp( ::oPedPrvL:cCodPr1 + ::oPedPrvL:cValPr1 )
         ::oDbf:cValPr2    := ::oPedPrvL:cValPr2
         ::oDbf:cNomVl2    := retValProp( ::oPedPrvL:cCodPr2 + ::oPedPrvL:cValPr2 )
         ::oDbf:nNumCaj    := ::oPedPrvL:nCanPed
         ::oDbf:nUniDad    := ::oPedPrvL:nUniCaja
         ::oDbf:cDocMov    := lTrim( ::oPedPrvL:cSerPed ) + "/" + lTrim ( Str( ::oPedPrvL:nNumPed ) ) + "/" + lTrim ( ::oPedPrvL:cSufPed )
         ::oDbf:cDocPrv    := ::oPedPrvT:cSuPed
         ::oDbf:dFecMov    := ::oPedPrvT:dFecPed

      end if

   else

      ::oDbf:Load()
      ::oDbf:nNumUni    += nTotNPedPrv( ::oPedPrvL )
      ::oDbf:nImpArt    += nTotUPedPrv( ::oPedPrvL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLPedPrv( ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nIvaLPedPrv( ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oPedPrvL:cRef, nTotNPedPrv( ::oPedPrvL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddAlb( lAcumula )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oAlbPrvT:cCodPrv )

      ::oDbf:Append()

      ::AddProveedor( ::oAlbPrvT:cCodPrv )
      ::oDbf:nNumUni    := nTotNAlbPrv( ::oAlbPrvL )
      ::oDbf:nImpArt    := nTotUAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nIvaTot    := nIvaLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oAlbPrvL:cRef, nTotNAlbPrv( ::oAlbPrvL ), ::oDbf:nImpTot, .f. )

      if !lAcumula

         ::oDbf:cCodArt := ::oAlbPrvL:cRef
         ::oDbf:cNomArt := ::oAlbPrvL:cDetalle
         ::oDbf:cCodPr1 := ::oAlbPrvL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oAlbPrvL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oAlbPrvL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oAlbPrvL:cCodPr2 )
         ::oDbf:cValPr1 := ::oAlbPrvL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oAlbPrvL:cCodPr1 + ::oAlbPrvL:cValPr1 )
         ::oDbf:cValPr2 := ::oAlbPrvL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oAlbPrvL:cCodPr2 + ::oAlbPrvL:cValPr2 )
         ::oDbf:nNumCaj := ::oAlbPrvL:nCanEnt
         ::oDbf:nUniDad := ::oAlbPrvL:nUniCaja
         ::oDbf:cDocMov := ::oAlbPrvL:cSerAlb + "/" + lTrim ( Str( ::oAlbPrvL:nNumAlb ) ) + "/" + lTrim ( ::oAlbPrvL:cSufAlb )
         ::oDbf:cDocPrv := ::oAlbPrvT:cSuAlb
         ::oDbf:dFecMov := ::oAlbPrvT:dFecAlb

      end if

   else

      ::oDbf:Load()
      ::oDbf:nNumUni    += nTotNAlbPrv( ::oAlbPrvL )
      ::oDbf:nImpArt    += nTotUAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nIvaLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oAlbPrvL:cRef, nTotNAlbPrv( ::oAlbPrvL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFac( lAcumula )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oFacPrvT:cCodPrv )

      ::oDbf:Append()

      ::AddProveedor( ::oFacPrvT:cCodPrv )
      ::oDbf:nNumUni    := nTotNFacPrv( ::oFacPrvL )
      ::oDbf:nImpArt    := nTotUFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nIvaTot    := nIvaLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oFacPrvL:cRef, nTotNFacPrv( ::oFacPrvL ), ::oDbf:nImpTot, .f. )

      if !lAcumula

         ::oDbf:cCodArt := ::oFacPrvL:cRef
         ::oDbf:cNomArt := ::oFacPrvL:cDetalle
         ::oDbf:cCodPr1 := ::oFacPrvL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oFacPrvL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oFacPrvL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oFacPrvL:cCodPr2 )
         ::oDbf:cValPr1 := ::oFacPrvL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oFacPrvL:cCodPr1 + ::oFacPrvL:cValPr1 )
         ::oDbf:cValPr2 := ::oFacPrvL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oFacPrvL:cCodPr2 + ::oFacPrvL:cValPr2 )
         ::oDbf:nNumCaj := ::oFacPrvL:nCanEnt
         ::oDbf:nUniDad := ::oFacPrvL:nUniCaja
         ::oDbf:cDocMov := ::oFacPrvL:cSerFac + "/" + lTrim ( Str( ::oFacPrvL:nNumFac ) ) + "/" + lTrim ( ::oFacPrvL:cSufFac )
         ::oDbf:cDocPrv := ::oFacPrvT:cNumDoc
         ::oDbf:dFecMov := ::oFacPrvT:dFecFac

      end if

   else

      ::oDbf:Load()
      ::oDbf:nNumUni    += nTotNFacPrv( ::oFacPrvL )
      ::oDbf:nImpArt    += nTotUFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nIvaLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oFacPrvL:cRef, nTotNFacPrv( ::oFacPrvL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD IncluyeCero()

   /*
   Repaso de todos los Proveedores---------------------------------------------
   */

   ::oDbfPrv:GoTop()
   while !::oDbfPrv:Eof()

      if ( ::lAllPrv .or. ( ::oDbfPrv:Cod >= ::cPrvOrg .AND. ::oDbfPrv:Cod <= ::cPrvDes ) ) .AND.;
         !::oDbf:Seek( ::oDbfPrv:Cod )

         ::oDbf:Append()
         ::oDbf:Blank()
         ::oDbf:cCodPrv    := ::oDbfPrv:Cod
         ::oDbf:cNomPrv    := ::oDbfPrv:Titulo
         ::oDbf:Save()

      end if

      ::oDbfPrv:Skip()

   end while

RETURN ( self )

//---------------------------------------------------------------------------//