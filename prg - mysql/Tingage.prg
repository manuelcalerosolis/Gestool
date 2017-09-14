#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfAge FROM TInfGen

   METHOD CreateFields()

  /* METHOD RentCreateFields()

   METHOD AddTik( cCodArt )

   METHOD AddAlb()

   METHOD AddFac()

   METHOD AddRTik( cCodArt )

   METHOD AddRAlb()

   METHOD AddRFac()*/

END CLASS

//---------------------------------------------------------------------------//

METHOD CreateFields()

   ::AddField ( "CCODAGE", "C",  3, 0,  {|| "@!" },         "Cod. age.",                 .f., "Código agente",             3 )
   ::AddField ( "CNOMAGE", "C", 50, 0,  {|| "@!" },         "Agente",                    .f., "Agente",                   25 )
   ::FldCliente()
   ::AddField ( "CREFART", "C", 18, 0,  {|| "@!" },         "Código artículo",                 .t., "Código artículo",          10 )
   ::AddField ( "CDESART", "C", 50, 0,  {|| "@!" },         "Artículo",                  .t., "Artículo",                 25 )
   ::AddField ( "NUNDCAJ", "N", 13, 6,  {|| MasUnd () },    "Cajas",                     .f., "Cajas",                     8 )
   ::AddField ( "NUNDART", "N", 13, 6,  {|| MasUnd () },    "Und.",                      .t., "Unidades",                  8 )
   ::AddField ( "NCAJUND", "N", 13, 6,  {|| MasUnd () },    "Caj x Und",                 .f., "Cajas x unidades",         10 )
   ::AddField ( "NBASCOM", "N", 13, 6,  {|| ::cPicOut },    "Base",                      .t., "Base comisión",            10 )
   ::AddField ( "NCOMAGE", "N",  4, 1,  {|| ::cPicOut },    "%Com",                      .f., "Porcentaje de comisión",   10 )
   ::AddField ( "NTOTCOM", "N", 13, 6,  {|| ::cPicOut },    "Importe",                   .t., "Importe comisión",         10 )
   ::AddField ( "CDOCMOV", "C", 14, 0,  {|| "@!" },         "Preido",                    .t., "Preido",                   14 )
   ::AddField ( "DFECMOV", "D",  8, 0,  {|| "@!" },         "Fecha",                     .t., "Fecha",                     8 )
   ::AddField ( "CTIPVEN", "C", 20, 0,  {|| "@!" },         "Venta",                     .f., "Tipo de venta",            20 )


RETURN ( self )

//---------------------------------------------------------------------------//

/*METHOD RentCreateFields()

   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },           "Código artículo",         .f., "Codigo artículo", 14, .f. )
   ::AddField( "cNomArt", "C", 50, 0, {|| "@!" },           "Descripción",       .f., "Descripción",     35, .f. )
   ::FldCliente()
   ::AddField( "nTotCaj", "N", 16, 6, {|| MasUnd() },       "Cajas",             .f., "Cajas",           12, .t. )
   ::AddField( "nTotUni", "N", 16, 6, {|| MasUnd() },       "Unds.",             .t., "Unidades",        12, .t. )
   ::AddField( "nTotImp", "N", 16, 6, {|| ::cPicOut },      "Tot. importe",      .t., "Tot. importe",    12, .t. )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicOut },      "Tot. costo",        .t., "Total costo",     12, .t. )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut },      "Margen",            .t., "Margen",          12, .t. )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },      "%Rent.",            .t., "Rentabilidad",    12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Precio medio",      .f., "Precio medio",    12, .f. )
   ::AddField( "nCosMed", "N", 16, 6, {|| ::cPicOut },      "Costo medio",       .t., "Costo medio",     12, .f. )
   ::AddField( "cNumDoc", "C", 14, 0, {|| "@!" },           "Documento",         .t., "Documento",       12, .f. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddTik( cCodArt )

   ::oDbf:Append()

   ::AddCliente      ( ::oTikCliT:cCliTik )

   ::oDbf:cCodArt    := cCodArt
   ::oDbf:cNomArt    := RetArticulo( cCodArt, ::oArt )
   ::oDbf:nImpArt    := nTotUTpv( ::oTikCliL:cAlias, ::nDecOut, ::nValDiv )
   ::oDbf:nImpTot    := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

   if ::oTikCliT:cTipTik == "4"
   ::oDbf:nNumUni := - ::oTikCliL:nUntTil
   ::oDbf:nIvaArt := - ::oTikCliL:nIvaTil
   else
   ::oDbf:nNumUni := ::oTikCliL:nUntTil
   ::oDbf:nIvaArt := ::oTikCliL:nIvaTil
   end if

   ::oDbf:cDocMov    := lTrim( ::oTikCliL:CSERTIL ) + "/" + lTrim ( ::oTikCliL:CNUMTIL ) + "/" + lTrim ( ::oTikCliL:CSUFTIL )
   ::oDbf:dFecMov    := ::oTikCliT:DFECTIK

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddAlb()

   ::oDbf:Append()

   ::AddCliente      ( ::oAlbCliT:cCodCli )

   ::oDbf:cCodArt    := ::oAlbCliL:cRef
   ::oDbf:cNomArt    := ::oAlbCliL:cDetalle
   ::oDbf:nNumCaj    := ::oAlbCliL:nCanEnt
   ::oDbf:nUniDad    := ::oAlbCliL:NUNICAJA
   ::oDbf:nNumUni    := nTotNAlbCli( ::oAlbCliL )
   ::oDbf:nImpArt    := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
   ::oDbf:nImpTrn    := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
   ::oDbf:nPntVer    := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
   ::oDbf:nImpTot    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

   ::oDbf:nIvaArt    := Round( ::oDbf:nImpArt * ::oAlbCliL:nIva / 100, ::nDerOut )

   ::oDbf:cDocMov    := lTrim( ::oAlbCliL:CSERALB ) + "/" + lTrim ( Str( ::oAlbCliL:NNUMALB ) ) + "/" + lTrim ( ::oAlbCliL:CSUFALB )
   ::oDbf:dFecMov    := ::oAlbCliT:DFECALB

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFac()

   ::oDbf:Append()

   ::AddCliente      ( ::oFacCliT:cCodCli )

   ::oDbf:cCodArt    := ::oFacCliL:cRef
   ::oDbf:cNomArt    := ::oFacCliL:cDetalle
   ::oDbf:nNumCaj    := ::oFacCliL:nCanEnt
   ::oDbf:nUniDad    := ::oFacCliL:NUNICAJA
   ::oDbf:nNumUni    := nTotNFacCli( ::oFacCliL )
   ::oDbf:nImpArt    := nImpUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
   ::oDbf:nImpTrn    := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
   ::oDbf:nPntVer    := nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
   ::oDbf:nImpTot    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

   ::oDbf:nIvaArt    := Round( ::oDbf:nImpArt * ::oFacCliL:nIva / 100, ::nDerOut )

   ::oDbf:cDocMov    := lTrim( ::oFacCliL:CSERIE ) + "/" + lTrim ( Str( ::oFacCliL:NNUMFAC ) ) + "/" + lTrim ( ::oFacCliL:CSUFFAC )
   ::oDbf:dFecMov    := ::oFacCliT:DFECFAC
   
   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddRTik( cCodArt )

   nTotUni              := ::oTikCliL:nUntTil
   nTotImpUni           := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

   if ::oTikCliL:nCosDiv != 0
      nTotCosUni        := ::oTikCliL:nCosDiv * nTotUni
   else
      nTotCosUni        := nRetPreCosto( ::oArt:cAlias, cCodArt ) * nTotUni
   end if

   ::oDbf:Append()

   ::oDbf:cCodArt    := cCodArt
   ::oDbf:cNomArt    := RetArticulo( cCodArt, ::oArt )

   ::AddCliente( ::oTikCliT:cCliTik )

   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nTotCos    := nTotCosUni
   ::oDbf:nMargen    := nTotImpUni - nTotCosUni

   if nTotUni != 0 .and. nTotCosUni != 0
      ::oDbf:nRentab := ( ( nTotImpUni / nTotCosUni ) - 1 ) * 100
      ::oDbf:nPreMed := nTotImpUni / nTotUni
      ::oDbf:nCosMed := nTotCosUni / nTotUni
   else
      ::oDbf:nRentab := 0
      ::oDbf:nPreMed := 0
      ::oDbf:nCosMed := 0
   end if

   ::oDbf:cNumDoc    := ::oTikCliL:cSerTiL + "/" + Alltrim( ::oTikCliL:cNumTiL ) + "/" + ::oTikCliL:cSufTiL

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddRAlb()


   nTotUni              := nTotNAlbCli( ::oAlbCliL:cAlias )
   nTotImpUni           := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

   if ::lCosAct .or. ::oAlbCliL:nCosDiv == 0
      nTotCosUni        := nRetPreCosto( ::oArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
   else
      nTotCosUni        := ::oAlbCliL:nCosDiv * nTotUni
   end if

   ::oDbf:Append()

   ::oDbf:cCodArt    := ::oAlbCliL:cRef

   ::oDbf:cNomArt    := ::oAlbCliL:cDetalle

   ::AddCliente( ::oAlbCliT:cCodCli )

   ::oDbf:nTotCaj    := ::oAlbCliL:nCanEnt
   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nTotCos    := nTotCosUni
   ::oDbf:nMargen    := ( nTotImpUni ) - ( nTotCosUni )

   if nTotUni != 0 .and. nTotCosUni != 0
      ::oDbf:nRentab := ( ( nTotImpUni / nTotCosUni ) - 1 ) * 100
      ::oDbf:nPreMed := nTotImpUni / nTotUni
      ::oDbf:nCosMed := nTotCosUni / nTotUni
   else
      ::oDbf:nRentab := 0
      ::oDbf:nPreMed := 0
      ::oDbf:nCosMed := 0
   end if

   ::oDbf:cNumDoc    := ::oAlbCliL:cSerAlb + "/" + Alltrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + ::oAlbCliL:cSufAlb

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddRFac()


   nTotUni              := nTotNFacCli( ::oFacCliL:cAlias )
   nTotImpUni           := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

   if ::lCosAct .or. ::oFacCliL:nCosDiv == 0
      nTotCosUni        := nRetPreCosto( ::oArt:cAlias, ::oFacCliL:cRef ) * nTotUni
   else
      nTotCosUni        := ::oFacCliL:nCosDiv * nTotUni
   end if

   ::oDbf:Append()

   ::oDbf:cCodArt    := ::oFacCliL:cRef
   ::oDbf:cNomArt    := ::oFacCliL:cDetalle

   ::AddCliente( ::oFacCliT:cCodCli )

   ::oDbf:nTotCaj    := ::oFacCliL:nCanEnt
   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nTotCos    := nTotCosUni
   ::oDbf:nMargen    := ( nTotImpUni ) - ( nTotCosUni )

   if nTotUni != 0 .and. nTotCosUni != 0
      ::oDbf:nRentab := ( ( nTotImpUni / nTotCosUni ) - 1 ) * 100
      ::oDbf:nPreMed := nTotImpUni / nTotUni
      ::oDbf:nCosMed := nTotCosUni / nTotUni
   else
      ::oDbf:nRentab := 0
      ::oDbf:nPreMed := 0
      ::oDbf:nCosMed := 0
   end if

   ::oDbf:cNumDoc    := ::oFacCliL:cSerie + "/" + Alltrim( Str( ::oFacCliL:nNumFac ) ) + "/" + ::oFacCliL:cSufFac

   ::oDbf:Save()

RETURN ( self )*/

//---------------------------------------------------------------------------//