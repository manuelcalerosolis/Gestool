#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TPrvGrpPrv FROM TInfGen

   METHOD CreateFields()

   METHOD AnuFields()

   METHOD AcuCreate()

   METHOD AddAlb( cCodGrp )

   METHOD AddFac( cCodGrp )

END CLASS

//---------------------------------------------------------------------------//

METHOD CreateFields()


   ::AddField ( "cCodGrp", "C",  4, 0, {|| "@!" },          "Grupo",                      .f., "Grupo",                        4, .f. )
   ::AddField ( "cNomGrp", "C", 30, 0, {|| "@!" },          "Nom. Grp ",                  .f., "Nombre del grupo",            30, .f. )
   ::AddField ( "cCodPrv", "C", 12, 0, {|| "@!" },          "Prv.",                       .f., "Cod. Proveedor",               9, .f. )
   ::AddField ( "cNomPrv", "C", 50, 0, {|| "@!" },          "Proveedor",                  .f., "Nombre Proveedor",            35, .f. )
   ::AddField ( "cDocMov", "C", 14, 0, {|| "@!" },          "Doc.",                       .t., "Documento",                   15, .f. )
   ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },          "Fecha",                      .t., "Fecha",                       10, .f. )
   ::AddField ( "cTipDoc", "C", 20, 0, {|| "@!" },          "Tipo",                       .f., "Tipo de documento",           10, .f. )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },     "Base",                       .t., "Base",                        12, .t. )
   ::AddField ( "nIvaTot", "N", 16, 6, {|| ::cPicOut },     cImp(),                       .t., cImp(),                        12, .t. )
   ::AddField ( "nTotFin", "N", 16, 6, {|| ::cPicOut },     "Total",                      .t., "Total",                       12, .t. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AnuFields()


   ::AddField ( "cCodGrp", "C",  4, 0, {|| "" },           "Grupo",           .t., "Grupo",                       4, .f. )
   ::AddField ( "cNomGrp", "C", 30, 0, {|| "@!" },         "Nom. Grp ",       .t., "Nombre del grupo",           30, .f. )
   ::AddField ( "nImpEne", "N", 16, 6, {|| ::cPicOut },    "Ene",             .t., "Enero",                      12, .t. )
   ::AddField ( "nImpFeb", "N", 16, 6, {|| ::cPicOut },    "Feb",             .t., "Febrero",                    12, .t. )
   ::AddField ( "nImpMar", "N", 16, 6, {|| ::cPicOut },    "Mar",             .t., "Marzo",                      12, .t. )
   ::AddField ( "nImpAbr", "N", 16, 6, {|| ::cPicOut },    "Abr",             .t., "Abril",                      12, .t. )
   ::AddField ( "nImpMay", "N", 16, 6, {|| ::cPicOut },    "May",             .t., "Mayo",                       12, .t. )
   ::AddField ( "nImpJun", "N", 16, 6, {|| ::cPicOut },    "Jun",             .t., "Junio",                      12, .t. )
   ::AddField ( "nImpJul", "N", 16, 6, {|| ::cPicOut },    "Jul",             .t., "Julio",                      12, .t. )
   ::AddField ( "nImpAgo", "N", 16, 6, {|| ::cPicOut },    "Ago",             .t., "Agosto",                     12, .t. )
   ::AddField ( "nImpSep", "N", 16, 6, {|| ::cPicOut },    "Sep",             .t., "Septiembre",                 12, .t. )
   ::AddField ( "nImpOct", "N", 16, 6, {|| ::cPicOut },    "Oct",             .t., "Octubre",                    12, .t. )
   ::AddField ( "nImpNov", "N", 16, 6, {|| ::cPicOut },    "Nov",             .t., "Noviembre",                  12, .t. )
   ::AddField ( "nImpDic", "N", 16, 6, {|| ::cPicOut },    "Dic",             .t., "Diciembre",                  12, .t. )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },    "Tot",             .t., "Total",                      12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AcuCreate()

   ::AddField( "cCodGrp", "C",  4, 0, {|| "" },             "Grupo",          .t., "Grupo"                , 10, .f. )
   ::AddField( "cNomGrp", "C", 30, 0, {|| "@!" },           "Nom. Grp ",      .t., "Nombre del grupo"     , 30, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },      "Base",           .t., "Base"                 , 12, .t. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },      "Tot. " + cImp(),    .t., "Total " + cImp()         , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },      "Total",          .t., "Total"                , 12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddAlb( lAcumula, cCodGrp )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( cCodGrp )

      ::oDbf:Append()

      ::oDbf:cCodGrp    := cCodGrp
      ::oDbf:cNomGrp    := cNomGrp( cCodGrp, ::oGrpPrv:oDbf )
      ::oDbf:nImpTot    := nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nIvaTot    := nIvaLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      if !lAcumula

         ::oDbf:cCodPrv := ::oAlbPrvT:cCodPrv
         ::oDbf:cNomPrv := ::oAlbPrvT:cNomPrv
         ::oDbf:cDocMov := AllTrim( ::oAlbPrvT:cSerAlb ) + "/" + AllTrim ( Str( ::oAlbPrvT:nNumAlb ) ) + "/" + AllTrim ( ::oAlbPrvT:cSufAlb )
         ::oDbf:dFecMov := ::oAlbPrvT:dFecAlb

      end if

   else

      ::oDbf:Load()
      ::oDbf:nImpTot    += nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nIvaLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFac( lAcumula, cCodGrp )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( cCodGrp )

      ::oDbf:Append()

      ::oDbf:cCodGrp    := cCodGrp
      ::oDbf:cNomGrp    := cNomGrp( cCodGrp, ::oGrpPrv:oDbf )
      ::oDbf:nImpTot    := nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nIvaTot    := nIvaLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      if !lAcumula

         ::oDbf:cCodPrv := ::oAlbPrvT:cCodPrv
         ::oDbf:cNomPrv := ::oAlbPrvT:cNomPrv
         ::oDbf:cDocMov := AllTrim( ::oFacPrvT:cSerFac ) + "/" + AllTrim ( Str( ::oFacPrvT:nNumFac ) ) + "/" + AllTrim ( ::oFacPrvT:cSufFac )
         ::oDbf:dFecMov := ::oFacPrvT:dFecFac

      end if

   else

      ::oDbf:Load()
      ::oDbf:nImpTot    += nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nIvaLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//