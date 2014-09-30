#include "FiveWin.Ch"
#include "Folder.ch" 
#include "Label.ch"
#include "Image.ch"
#include "Xbrowse.ch"
#include "FastRepH.ch"
#include "Factu.ch" 

#define GWL_STYLE                   -16
#define TVS_TRACKSELECT             512 //   0x0200

#define DT_TOP                      0x00000000
#define DT_LEFT                     0x00000000
#define DT_CENTER                   0x00000001
#define DT_RIGHT                    0x00000002
#define DT_VCENTER                  0x00000004
#define DT_BOTTOM                   0x00000008
#define DT_WORDBREAK                0x00000010
#define DT_SINGLELINE               0x00000020
#define DT_EXPANDTABS               0x00000040
#define DT_TABSTOP                  0x00000080
#define DT_NOCLIP                   0x00000100
#define DT_EXTERNALLEADING          0x00000200
#define DT_CALCRECT                 0x000004
#define DT_NOPREFIX                 0x00000800
#define DT_INTERNAL                 0x00001000


#define fldGeneral                  oFld:aDialogs[1]
#define fldPrecios                  oFld:aDialogs[2]
#define fldTactil                   oFld:aDialogs[3]
#define fldDescripciones            oFld:aDialogs[4]
#define fldPropiedades              oFld:aDialogs[5]
#define fldImagenes                 oFld:aDialogs[6]
#define fldLogistica                oFld:aDialogs[7]
#define fldStocks                   oFld:aDialogs[8]
#define fldContabilidad             oFld:aDialogs[9]
#define fldOfertas                  oFld:aDialogs[10]
#define fldEscandallos              oFld:aDialogs[11]
#define fldWeb                      oFld:aDialogs[12]

memvar cDbfArt
memvar cDbfDiv
memvar cDbfOfe
memvar cDbfBar

static pThread

static oWndBrw
static dbfProv
static dbfCatalogo
static dbfCategoria
static dbfTemporada
static dbfFamPrv
static dbfTMov
static dbfTarPreT 
static dbfTarPreL
static dbfTarPreS
static dbfOfe
static dbfAlmT
static dbfPro
static dbfTblPro
static dbfDoc

static filTmpPrv
static dbfTmpPrv
static filTmpVta
static dbfTmpVta
static filTmpKit
static dbfTmpKit
static filTmpOfe
static dbfTmpOfe
static filTmpImg
static dbfTmpImg
static filTmpCodebar
static dbfTmpCodebar
static filTmpSubCta
static dbfTmpSubCta
static filTmpSubCom
static dbfTmpSubCom

static oStock
static oTankes
static oTipArt
static oGrpFam
static oCatalogo
static oNewImp
static oBandera
static oCosto
static oUndMedicion
static oFraPub
static oFabricante
static oOrdenComanda
static oTpvMenu

static oActiveX

static cCatOld
static cPrvOld
static oMenu
static aBmpTipCat

static aBenefSobre         := { "Costo", "Venta" }

static cCodigoFamilia

static lOpenFiles          := .f.
static lExternal           := .f.

static nLabels             := 1

static lEuro               := .f.

static lChangeImage        := .f.
static cImageOld           := ""

static bEdit               := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode          | EdtRec( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }
static bEdit2              := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode          | EdtRec2( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }
static bEdtDet             := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt | EdtDet( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt ) }
static bEdtVta             := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt | EdtVta( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt ) }
static bEdtKit             := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt | EdtKit( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt ) }
static bEdtImg             := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode          | EdtImg( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }
static bEdtCod             := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt | EdtCodebar( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt ) }

static oCbxPrecio 

static dbfArticulo
static dbfFam

static filArticulo
static tmpArticulo

static dbfCodebar
static dbfArtPrv
static dbfArtVta
static dbfArtKit
static dbfArtLbl
static dbfDiv
static dbfIva
static dbfImg

static dbfAlbPrvT
static dbfAlbPrvL
static dbfFacPrvT
static dbfFacPrvL
static dbfRctPrvL

static dbfAlbCliT
static dbfAlbCliL
static dbfFacCliL
static dbfFacRecL
static dbfTikCliL
static dbfProLin
static dbfProMat
static dbfHisMov
static dbfPedPrvL
static dbfPedCliL
static dbfUbicaT
static dbfUbicaL

static oSeccion

static dbfTImp

static cPouDiv
static cPorDiv
static cPouChg
static cPinDiv
static cPirDiv
static nDecDiv
static cPpvDiv
static nDpvDiv
static nDwbDiv
static cPicEsc
static cPicUnd
static cPwbDiv
static cPwrDiv

static oTimerBrw

static cOldCodeBar   := ""
static aOldCodeBar   := {}

static oBtnAceptarActualizarWeb

//---------------------------------------------------------------------------//

#ifndef __PDA__

//---------------------------------------------------------------------------//
//Parte para el programa normal
//---------------------------------------------------------------------------//

Static Function aItmCom()

   local aBase := {}

   aAdd( aBase, { "cCodArt",   "C", 18, 0, "Código de artículo"            , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodDiv",   "C",  3, 0, "Código de divisa"              , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPr1",   "C", 20, 0, "Código de primera propiedad"   , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPr2",   "C", 20, 0, "Código de segunda propiedad"   , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr1",   "C", 40, 0, "Valor de primera propiedad"    , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr2",   "C", 40, 0, "Valor de segunda propiedad"    , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreCom",   "N", 16, 6, "Precio de compras"             , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nValPnt",   "N", 16, 6, "Valor del punto"               , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoPnt",   "N",  6, 2, "Descuento del punto"           , "",                  "", "( cDbfArt )", nil } )

Return ( aBase )

//---------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt, cPath )

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de artículos' )
      Return ( .f. )
   end if

   CursorWait()

   DEFAULT  lExt  := .f.
   DEFAULT  cPath := cPatEmp()

   lExternal      := lExt

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      oMsgText( 'Abriendo ficheros artículos' )

      lOpenFiles  := .t.

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      CacheRecords( dbfArticulo )

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "ProvArt.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProv ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE

      USE ( cPatGrp() + "CATALOGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CATALOGO", @dbfCatalogo ) )
      SET ADSINDEX TO ( cPatGrp() + "CATALOGO.CDX" ) ADDITIVE

      USE ( cPatArt() + "CATEGORIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CATEGORIA", @dbfCategoria ) )
      SET ADSINDEX TO ( cPatArt() + "CATEGORIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "Temporadas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TEMPORADA", @dbfTemporada ) )
      SET ADSINDEX TO ( cPatArt() + "Temporadas.Cdx" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFam ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "FamPrv.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMPRV", @dbfFamPrv ) )
      SET ADSINDEX TO ( cPatArt() + "FamPrv.Cdx" ) ADDITIVE

      USE ( cPatDat() + "TMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TMOV", @dbfTMov ) )
      SET ADSINDEX TO ( cPatDat() + "TMOV.CDX" ) ADDITIVE

      USE ( cPatArt() + "TARPRET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRET", @dbfTarPreT ) )
      SET ADSINDEX TO ( cPatArt() + "TARPRET.CDX" ) ADDITIVE

      USE ( cPatArt() + "TARPREL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) )
      SET ADSINDEX TO ( cPatArt() + "TARPREL.CDX" ) ADDITIVE
      SET TAG TO "CCODART"

      USE ( cPatArt() + "TARPRES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRES", @dbfTarPreS ) )
      SET ADSINDEX TO ( cPatArt() + "TARPRES.CDX" ) ADDITIVE

      USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOfe ) )
      SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtVta ) )
      SET ADSINDEX TO ( cPatArt() + "ARTDIV.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtLbl.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ArtLbl", @dbfArtLbl ) )
      SET ADSINDEX TO ( cPatArt() + "ArtLbl.Cdx" ) ADDITIVE

      USE ( cPatArt() + "ArtImg.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ArtImg", @dbfImg ) )
      SET ADSINDEX TO ( cPatArt() + "ArtImg.Cdx" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
      SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfArtKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      SET TAG TO "CTIPO"

      USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE
      SET TAG TO "cStkFast"

      USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "RctPrvL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE
      SET TAG TO "cStkFast"

      USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "FacRecL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecL", @dbfFacRecL ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE
      SET TAG TO "CSTKFAST"

      USE ( cPatEmp() + "PROLIN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROLIN", @dbfProLin ) )
      SET ADSINDEX TO ( cPatEmp() + "PROLIN.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatEmp() + "PROMAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMAT", @dbfProMat ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMAT.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatEmp() + "HISMOV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
      SET ADSINDEX TO ( cPatEmp() + "HISMOV.CDX" ) ADDITIVE
      SET TAG TO "cRefMov"

      USE ( cPatEmp() + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbPrvT", @dbfAlbPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVT.CDX" ) ADDITIVE

      if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
         lOpenFiles     := .f.
      end if

      USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedPrvL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliL", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatAlm() + "UBICAT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "UBICAT", @dbfUbicaT ) )
      SET ADSINDEX TO ( cPatAlm() + "UBICAT.CDX" ) ADDITIVE

      USE ( cPatAlm() + "UBICAL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "UBICAL", @dbfUbicaL ) )
      SET ADSINDEX TO ( cPatAlm() + "UBICAL.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIPIMP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPIMP", @dbfTImp ) )
      SET ADSINDEX TO ( cPatDat() + "TIPIMP.CDX" ) ADDITIVE

      oBandera             := TBandera():New()

      oStock               := TStock():Create( cPatGrp() )

      if !oStock:lOpenFiles()
         lOpenFiles        := .f.
      end if

      oTankes              := TTankes():Create( cPatArt() )
      if !oTankes:OpenFiles()
         lOpenFiles        := .f.
      end if

      oTipArt              := TTipArt():Create( cPatArt() )
      if !oTipArt:OpenFiles()
         lOpenFiles        := .f.
      end if

      oGrpFam              := TGrpFam():Create( cPatArt() )
      if !oGrpFam:OpenFiles()
         lOpenFiles        := .f.
      end if

      oFabricante          := TFabricantes():Create( cPatArt() )
      if !oFabricante:OpenFiles()
         lOpenFiles        := .f.
      end if

      oCatalogo            := TCatalogo():Create()
      if !oCatalogo:OpenFiles()
         lOpenFiles        := .f.
      end if

      oNewImp              := TNewImp():Create( cPath )
      if !oNewImp:OpenFiles()
         lOpenFiles        := .f.
      end if

      oUndMedicion         := UniMedicion():Create( cPatGrp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles        := .f.
      end if

      oFraPub              := TFrasesPublicitarias():Create( cPatArt() )
      if !oFraPub:OpenFiles()
         lOpenFiles        := .f.
      end if

      oSeccion             := TSeccion():Create( cPath )
      if !oSeccion:OpenFiles()
         lOpenFiles        := .f.
      end if

      oOrdenComanda        := TOrdenComanda():Create( cPatArt() )
      if !oOrdenComanda:OpenFiles()
         lOpenfiles        := .f.
      end if 

      oTpvMenu             := TpvMenu():Create( cPath )
      oTpvMenu:OpenService( .f., cPath )
      oTpvMenu:SetFilter( 'Field->lAcomp == .t.' )
      oTpvMenu:lAppendBuscar     := .f.
      oTpvMenu:lModificarBuscar  := .f.

      /*
      Cargamos el valor del Euro y de la Peseta-----------------------------------
      */

      cPouDiv              := cPouDiv( cDivEmp(), dbfDiv )
      cPorDiv              := cPorDiv( cDivEmp(), dbfDiv )
      cPwbDiv              := cPwbDiv( cDivEmp(), dbfDiv )
      cPwrDiv              := cPwrDiv( cDivEmp(), dbfDiv )
      cPouChg              := cPouDiv( cDivChg(), dbfDiv )
      cPinDiv              := cPinDiv( cDivEmp(), dbfDiv )
      cPirDiv              := cPirDiv( cDivEmp(), dbfDiv )
      nDecDiv              := nDouDiv( cDivEmp(), dbfDiv )
      nDwbDiv              := nDwbDiv( cDivEmp(), dbfDiv )
      cPpvDiv              := cPpvDiv( cDivEmp(), dbfDiv )
      nDpvDiv              := nDpvDiv( cDivEmp(), dbfDiv )
      cPicEsc              := MasEsc()
      cPicUnd              := MasUnd()                               // Picture de las unidades

      /*
      Inicializa el editor de HTML---------------------------------------------
      */

      oMsgText( 'Ficheros de artículos abiertos' )

   RECOVER USING oError

      lOpenFiles           := .f.

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de artículos' )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

   CursorWE()

RETURN ( lOpenFiles )

//--------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles( lDestroy )

	DEFAULT lDestroy	:= .f.

   if oWndBrw != nil

      if !Empty( oWndBrw:oBrw )
         oWndBrw:oBrw:End()
      end if

      if lDestroy
         oWndBrw     := nil
      end if

   end if

   if dbfArticulo != nil
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if dbfProv != nil
      ( dbfProv )->( dbCloseArea() )
   end if

   if dbfCatalogo != nil
      ( dbfCatalogo )->( dbCloseArea() )
   end if

   if dbfCategoria != nil
      ( dbfCategoria )->( dbCloseArea() )
   end if

   if dbfTemporada != nil
      ( dbfTemporada )->( dbCloseArea() )
   end if

   if dbfIva != nil
      ( dbfIva )->( dbCloseArea() )
   end if

   if dbfFam != nil
      ( dbfFam )->( dbCloseArea() )
   end if

   if dbfFamPrv != nil
      ( dbfFamPrv )->( dbCloseArea() )
   end if

   if dbfTMov != nil
      ( dbfTMov )->( dbCloseArea() )
   end if

   if dbfArtPrv != nil
      ( dbfArtPrv )->( dbCloseArea() )
   end if

   if dbfArtLbl != nil
      ( dbfArtLbl )->( dbCloseArea() )
   end if

   if dbfTarPreT != nil
      ( dbfTarPreT )->( dbCloseArea() )
   end if

   if dbfTarPreL != nil
      ( dbfTarPreL )->( dbCloseArea() )
   end if

   if dbfTarPreS != nil
      ( dbfTarPreS )->( dbCloseArea() )
   end if

   if dbfOfe != nil
      ( dbfOfe )->( dbCloseArea() )
   end if

   if dbfImg != nil
      ( dbfImg )->( dbCloseArea() )
   end if

   if dbfDiv != nil
      ( dbfDiv )->( dbCloseArea() )
   end if

   if dbfArtVta != nil
      ( dbfArtVta )->( dbCloseArea() )
   end if

   if dbfAlmT != nil
      ( dbfAlmT )->( dbCloseArea() )
   end if

   if dbfArtKit != nil
      ( dbfArtKit )->( dbCloseArea() )
   end if

   if dbfTblPro != nil
      ( dbfTblPro )->( dbCloseArea() )
   end if

   if dbfPro != nil
      ( dbfPro )->( dbCloseArea() )
   end if

   if dbfCodebar != nil
      ( dbfCodebar )->( dbCloseArea() )
   end if

   if dbfAlbPrvL != nil
      ( dbfAlbPrvL )->( dbCloseArea() )
   end if

   if dbfFacPrvL != nil
      ( dbfFacPrvL )->( dbCloseArea() )
   end if

   if dbfRctPrvL != nil
      ( dbfRctPrvL )->( dbCloseArea() )
   end if

   if dbfAlbCliL != nil
      ( dbfAlbCliL )->( dbCloseArea() )
   end if

   if dbfFacCliL != nil
      ( dbfFacCliL )->( dbCloseArea() )
   end if

   if dbfFacRecL != nil
      ( dbfFacRecL )->( dbCloseArea() )
   end if

   if dbfTikCliL != nil
      ( dbfTikCliL )->( dbCloseArea() )
   end if

   if dbfProLin != nil
      ( dbfProLin )->( dbCloseArea() )
   end if

   if dbfProMat != nil
      ( dbfProMat )->( dbCloseArea() )
   end if

   if dbfHisMov != nil
      ( dbfHisMov )->( dbCloseArea() )
   end if

   if dbfAlbPrvT != nil
      ( dbfAlbPrvT )->( dbCloseArea() )
   end if

   if dbfAlbCliT != nil
      ( dbfAlbCliT )->( dbCloseArea() )
   end if

   if dbfPedPrvL != nil
      ( dbfPedPrvL )->( dbCloseArea() )
   end if

   if dbfPedCliL != nil
      ( dbfPedCliL )->( dbCloseArea() )
   end if

   if dbfUbicaT != nil
      ( dbfUbicaT )->( dbCloseArea() )
   end if

   if dbfUbicaL != nil
      ( dbfUbicaL )->( dbCloseArea() )
   end if

   if dbfTImp != nil
      ( dbfTImp )->( dbCloseArea() )
   end if

   if !Empty( dbfDoc )
      ( dbfDoc )->( dbCloseArea() )
   end if

   if !Empty( oStock )
      oStock:end()
   end if

   if !Empty( oTankes )
      oTankes:end()
   end if

   if !Empty( oGrpFam )
      oGrpFam:end()
   end if

   if !Empty( oTipArt )
      oTipArt:end()
   end if

   if !Empty( oFabricante )
      oFabricante:end()
   end if

   if !Empty( oCatalogo )
      oCatalogo:end()
   end if

   if !Empty( oNewImp )
      oNewImp:end()
   end if

   if !Empty( oUndMedicion )
      oUndMedicion:end()
   end if

   if !Empty( oFraPub )
      oFraPub:end()
   end if

   if !Empty( oSeccion )
      oSeccion:End()
   end if

   if !Empty( oOrdenComanda )
      oOrdenComanda:End()
   end if 

   if !Empty( oTpvMenu )
      oTpvMenu:CloseService()
   end if

   dbfArticulo    := nil
   dbfProv        := nil
   dbfCatalogo    := nil
   dbfIva         := nil
   dbfFam         := nil
   dbfFamPrv      := nil
   dbfArtPrv      := nil
   oStock         := nil
   dbfTMov        := nil
   dbfTarPreT     := nil
   dbfTarPreL     := nil
   dbfTarPreS     := nil
   dbfOfe         := nil
   dbfImg         := nil
   dbfDiv         := nil
   dbfArtVta      := nil
   oBandera       := nil
   dbfAlmT        := nil
   dbfArtKit      := nil
   dbfArtLbl      := nil
   dbfTblPro      := nil
   dbfPro         := nil
   dbfCodebar     := nil
   oTankes        := nil
   oTipArt        := nil
   oCatalogo      := nil
   oOrdenComanda  := nil 
   oNewImp        := nil
   oFraPub        := nil
   dbfDoc         := nil
   dbfCategoria   := nil
   dbfTemporada   := nil
   dbfAlbPrvL     := nil
   dbfFacPrvL     := nil
   dbfAlbCliL     := nil
   dbfFacCliL     := nil
   dbfFacRecL     := nil
   dbfTikCliL     := nil
   dbfProLin      := nil
   dbfProMat      := nil
   dbfHisMov      := nil
   dbfAlbPrvT     := nil
   dbfAlbCliT     := nil
   dbfPedPrvL     := nil
   dbfPedCliL     := nil
   dbfUbicaT      := nil
   dbfUbicaL      := nil
   dbfTImp        := nil
   oTpvMenu       := nil

   lOpenFiles     := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

Function Articulo( oMenuItem, oWnd, bOnInit )

   local oSnd
   local oRpl
   local oTct
   local oDel
   local nLevel
   local oBtnEur
   local oRotor
   local oScript

   DEFAULT  oMenuItem   := "01014"
   DEFAULT  oWnd        := oWnd()
   DEFAULT  bOnInit     := nil

   if oWndBrw == nil

      /*
      Obtenemos el nivel de acceso---------------------------------------------
      */

      nLevel            := nLevelUsr( oMenuItem )
      if nAnd( nLevel, 1 ) != 0
         msgStop( "Acceso no permitido." )
         return .f.
      end if

      /*
      Cerramos todas las ventanas----------------------------------------------
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
      end if

      /*
      Apertura de ficheros-----------------------------------------------------
      */

      if !OpenFiles( .f. )
         return .f.
      end if

      CursorWait()

      /*
      Anotamos el movimiento para el navegador---------------------------------
      */

      AddMnuNext( "Artículos", ProcName() )

      DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
         XBROWSE ;
         TITLE    "Artículos" ;
         PROMPT   "Código",;
						"Nombre",;
                  "Familia",;
                  "Proveedor" ,;
                  "No obsoletos + Código",;
                  "No obsoletos + Nombre",;
                  "Tipo" ,;
                  "Categoría" ,;
                  "Temporada" ,;
                  "Fabricante" ,;
                  "Posición táctil" ,;
                  "Publicar" ,;
                  "Código web" ;
         MRU      "Cube_Yellow_16";
         BITMAP   clrTopArchivos ;
         ALIAS    ( dbfArticulo ) ;
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfArticulo ) ) ;
			EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, dbfArticulo ) ) ;
         DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfArticulo ) ) ;
         DELETE   ( WinDelRec( oWndBrw:oBrw, dbfArticulo, {|| DelDetalle( ( dbfArticulo )->Codigo ) } ) ) ;
         LEVEL    nLevel ;
         OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Escandallos"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfArticulo )->lKitArt }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "BmpKit" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfArticulo )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Lbl16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código de barras"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| dbSeekInOrd( ( dbfArticulo )->Codigo, "cCodArt", dbfCodebar ) }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Remotecontrol_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Táctil"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfArticulo )->lIncTcl }
         :nWidth           := 18
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Tactil16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Posición táctil"
         :cSortOrder       := "nPosTpv"
         :bEditValue       := {|| if( ( dbfArticulo )->lIncTcl, Trans( ( dbfArticulo )->nPosTpv, "999" ), "" ) }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Publicar"
         :cSortOrder       := "lPubInt"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfArticulo )->lPubInt }
         :nWidth           := 20
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "SndInt16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Codigo"
         :bEditValue       := {|| ( dbfArticulo )->Codigo }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Nombre"
         :bEditValue       := {|| ( dbfArticulo )->Nombre }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Familia"
         :cSortOrder       := "cFamCod"
         :bEditValue       := {|| ( dbfArticulo )->Familia }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre familia"
         :bEditValue       := {|| RetFamilia( (dbfArticulo)->Familia, dbfFam ) }
         :nWidth           := 140
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :cSortOrder       := "cCodTip"
         :bStrData         := {|| AllTrim( ( dbfArticulo )->cCodTip ) + if( !Empty( ( dbfArticulo )->cCodTip ), " - ", "" ) + oRetFld( ( dbfArticulo )->cCodTip, oTipArt:oDbf, "cNomTip" ) }
         :nWidth           := 140
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t. 
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Categoría"
         :cSortOrder       := "cCodCate"
         :bStrData         := {|| AllTrim( ( dbfArticulo )->cCodCate ) + if( !Empty( ( dbfArticulo )->cCodCate ), " - ", "" ) + RetFld( ( dbfArticulo )->cCodCate, dbfCategoria, "cNombre" ) }
         :bBmpData         := {|| nBitmapTipoCategoria( RetFld( ( dbfArticulo )->cCodCate, dbfCategoria, "cTipo" ) ) }
         :nWidth           := 140
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t. 
         AddResourceTipoCategoria( hb_QWith() )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Temporada"
         :cSortOrder       := "cCodTemp"
         :bStrData         := {|| AllTrim( ( dbfArticulo )->cCodTemp ) + if( !Empty( ( dbfArticulo )->cCodTemp ), " - ", "" ) + RetFld( ( dbfArticulo )->cCodTemp, dbfTemporada, "cNombre" ) }
         :bBmpData         := {|| nBitmapTipoTemporada( RetFld( ( dbfArticulo )->cCodTemp, dbfTemporada, "cTipo" ) ) }
         :nWidth           := 140
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t. 
         AddResourceTipoTemporada( hb_QWith() ) 
         :lHide            := .t. 
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fabricante"
         :cSortOrder       := "cCodFab"
         :bStrData         := {|| AllTrim( ( dbfArticulo )->cCodFab ) + if( !Empty( ( dbfArticulo )->cCodFab ), " - ", "" ) + RetFld( ( dbfArticulo )->cCodFab, oFabricante:GetAlias() ) }
         :nWidth           := 140
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t. 
      end with

/*    with object ( oWndBrw:AddXCol() )
         :cHeader          := "Stocks"
         :bStrData         := {|| Trans( oStock:nTotStockAct( ( dbfArticulo )->Codigo, , , , , lEscandallo( dbfArticulo ), ( dbfArticulo )->nKitStk, ( dbfArticulo )->nCtlStock ), cPicUnd ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 100
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" ) + Space( 1 ) +  cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 100
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with
*/

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" ) 
         :bEditValue       := {|| ( dbfArticulo )->pVenta1 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
         :bOnPostEdit      := {|o,x,n| lValidImporteBase( o, x, n, { "Base" => "pVenta1", "Iva" => "pVtaIva1", "Beneficio" => "Benef1", "BeneficioSobre" => "nBnfSbr1" } ) }
      end with


      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" ) + Space( 1 ) +  cImp()
         :bEditValue       := {|| ( dbfArticulo )->pVtaIva1 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
         :bOnPostEdit      := {|o,x,n| lValidImporteIva( o, x, n, { "Base" => "pVenta1", "Iva" => "pVtaIva1", "Beneficio" => "Benef1", "BeneficioSobre" => "nBnfSbr1" } ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" ) 
         :bEditValue       := {|| ( dbfArticulo )->pVenta2 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :lHide            := .t.
         :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
         :bOnPostEdit      := {|o,x,n| lValidImporteBase( o, x, n, { "Base" => "pVenta2", "Iva" => "pVtaIva2", "Beneficio" => "Benef2", "BeneficioSobre" => "nBnfSbr2" } ) }
      end with


      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" ) + Space( 1 ) +  cImp()
         :bEditValue       := {|| ( dbfArticulo )->pVtaIva2 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :lHide            := .t.
         :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
         :bOnPostEdit      := {|o,x,n| lValidImporteIva( o, x, n, { "Base" => "pVenta2", "Iva" => "pVtaIva2", "Beneficio" => "Benef2", "BeneficioSobre" => "nBnfSbr2" } ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" ) 
         :bEditValue       := {|| ( dbfArticulo )->pVenta3 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :lHide            := .t.
         :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
         :bOnPostEdit      := {|o,x,n| lValidImporteBase( o, x, n, { "Base" => "pVenta3", "Iva" => "pVtaIva3", "Beneficio" => "Benef3", "BeneficioSobre" => "nBnfSbr3" } ) }
      end with


      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" ) + Space( 1 ) +  cImp()
         :bEditValue       := {|| ( dbfArticulo )->pVtaIva3 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :lHide            := .t.
         :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
         :bOnPostEdit      := {|o,x,n| lValidImporteIva( o, x, n, { "Base" => "pVenta3", "Iva" => "pVtaIva3", "Beneficio" => "Benef3", "BeneficioSobre" => "nBnfSbr3" } ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" ) 
         :bEditValue       := {|| ( dbfArticulo )->pVenta4 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :lHide            := .t.
         :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
         :bOnPostEdit      := {|o,x,n| lValidImporteBase( o, x, n, { "Base" => "pVenta4", "Iva" => "pVtaIva4", "Beneficio" => "Benef4", "BeneficioSobre" => "nBnfSbr4" } ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" ) + Space( 1 ) +  cImp()
         :bEditValue       := {|| ( dbfArticulo )->pVtaIva4 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :lHide            := .t.
         :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
         :bOnPostEdit      := {|o,x,n| lValidImporteIva( o, x, n, { "Base" => "pVenta4", "Iva" => "pVtaIva4", "Beneficio" => "Benef4", "BeneficioSobre" => "nBnfSbr4" } ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" ) 
         :bEditValue       := {|| ( dbfArticulo )->pVenta5 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :lHide            := .t.
         :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
         :bOnPostEdit      := {|o,x,n| lValidImporteBase( o, x, n, { "Base" => "pVenta5", "Iva" => "pVtaIva5", "Beneficio" => "Benef5", "BeneficioSobre" => "nBnfSbr5" } ) }
      end with


      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" ) + Space( 1 ) +  cImp()
         :bEditValue       := {|| ( dbfArticulo )->pVtaIva5 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :lHide            := .t.
         :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
         :bOnPostEdit      := {|o,x,n| lValidImporteIva( o, x, n, { "Base" => "pVenta5", "Iva" => "pVtaIva5", "Beneficio" => "Benef5", "BeneficioSobre" => "nBnfSbr5" } ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" ) 
         :bEditValue       := {|| ( dbfArticulo )->pVenta6 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :lHide            := .t.
         :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
         :bOnPostEdit      := {|o,x,n| lValidImporteBase( o, x, n, { "Base" => "pVenta6", "Iva" => "pVtaIva6", "Beneficio" => "Benef6", "BeneficioSobre" => "nBnfSbr6" } ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" ) + Space( 1 ) +  cImp()
         :bEditValue       := {|| ( dbfArticulo )->pVtaIva6 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :lHide            := .t.
         :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
         :bOnPostEdit      := {|o,x,n| lValidImporteIva( o, x, n, { "Base" => "pVenta6", "Iva" => "pVtaIva6", "Beneficio" => "Benef6", "BeneficioSobre" => "nBnfSbr6" } ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Proveedor"
         :cSortOrder       := "cPrvHab"
         :bStrData         := {|| if( !Empty( ( dbfArticulo )->cPrvHab ), AllTrim( ( dbfArticulo )->cPrvHab ) + " - " + RetProvee( ( dbfArticulo )->cPrvHab, dbfProv ), "" ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Referencia de proveedor"
         :bStrData         := {|| cRefArtPrv( ( dbfArticulo )->Codigo, ( dbfArticulo )->cPrvHab, dbfArtPrv ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código web"
         :cSortOrder       := "cCodWeb"
         :bStrData         := {|| ( dbfArticulo )->cCodWeb }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      if ( oUser():lCostos() )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Costo"
         :bStrData         := {|| if( oUser():lNotCostos(), "", nCosto( nil, dbfArticulo, dbfArtKit, .t., if( lEuro, cDivChg(), cDivEmp() ), dbfDiv ) ) }
         :nWidth           := 100
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      end if

      /*
      with object ( oWndBrw:AddXCol() )
         :cHeader          := "btn"
         :nEdittype        := EDIT_BUTTON
         :nWidth           := 20
         :bEditBlock       := { || MsgYesNo( "Please select" ) }
      end with
      */
      
      oWndBrw:cHtmlHelp    := "Articulos"
      oWndBrw:bToolTip     := {|| dlgTooltip( ( dbfArticulo )->Codigo, oWndBrw:oBrw ) }

      if uFieldEmpresa( "lShwPop" )
         oWndBrw:oBrw:bChange    := {|| if( !Empty( oWndBrw ), oWndBrw:CheckExtendInfo(), ) }
      else
         oWndBrw:oBrw:bChange    := {|| oWndBrw:DestroyTooltip() }
         aAdd( oWndBrw:aFastKey, { VK_SPACE, {|| if( !Empty( oWndBrw ), oWndBrw:ShowExtendInfo(), ) } } )
      end if

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar" ;
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( SearchProveedor() ) ;
         TOOLTIP  "Buscar e(x)tendido" ;
         HOTKEY   "X"

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecAdd() );
         TOOLTIP  "(A)ñadir";
         BEGIN GROUP;
         HOTKEY   "A" ;
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
         HOTKEY   "D";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, dbfArticulo ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z" ;
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL oDel RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
         MENU     This:Toggle() ;
         TOOLTIP  "(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

         DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( TDeleleteObsoletos():New(), oWndBrw:Refresh() );
            TOOLTIP  "Sin movimientos" ;
            FROM     oDel ;
            CLOSED ;
            LEVEL    ACC_DELE

		DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( SetPtsEur( oWndBrw, oBtnEur ) ) ;
         TOOLTIP  "Mo(n)eda";
         HOTKEY   "N"

      DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( BrwVtaComArt( ( dbfArticulo )->Codigo, ( dbfArticulo )->Nombre, dbfDiv, dbfIva, dbfAlmT, dbfArticulo ) ) ;
         TOOLTIP  "(I)nforme artículo" ;
         HOTKEY   "I" ;
         LEVEL    ACC_ZOOM


      DEFINE BTNSHELL RESOURCE "IMP" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TInfArtFam():New( "Listado de artículos" ):Play( .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva, dbfFam, oStock, oWndBrw ) );
         TOOLTIP  "Lis(t)ado";
         HOTKEY   "T" ;
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL RESOURCE "Document_Chart_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TFastVentasArticulos():New():Play() ) ;
         TOOLTIP  "Rep(o)rting";
         HOTKEY   "O" ;
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL RESOURCE "RemoteControl_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TArticuloLabelGenerator():Create() ) ;
         TOOLTIP  "Eti(q)uetas" ;
         HOTKEY   "Q";
         LEVEL    ACC_IMPR

      if oUser():lAdministrador()

         DEFINE BTNSHELL RESOURCE "CHGPRE" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( ChgPrc( dbfArticulo, oWndBrw ) ) ;
            TOOLTIP  "(C)ambiar precios" ;
            HOTKEY   "C";
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" OF oWndBrw ;
            NOBORDER ;
            MENU     This:Toggle() ;
            ACTION   ( ReplaceCreator( oWndBrw, dbfArticulo, aItmArt(), ART_TBL ) ) ;
            TOOLTIP  "Cambiar campos" ;
            LEVEL    ACC_EDIT

            DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
               NOBORDER ;
               ACTION   ( ReplaceCreator( oWndBrw, dbfArtKit, aItmKit() ) ) ;
               TOOLTIP  "Lineas escandallos" ;
               FROM     oRpl ;
               CLOSED ;
               LEVEL    ACC_EDIT

            DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
               NOBORDER ;
               ACTION   ( ReplaceCreator( oWndBrw, dbfArtVta, aItmVta() ) ) ;
               TOOLTIP  "Ventas por propiedades" ;
               FROM     oRpl ;
               CLOSED ;
               LEVEL    ACC_EDIT

      end if

      DEFINE BTNSHELL oSnd RESOURCE "Lbl" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         TOOLTIP  "En(v)iar" ;
         MESSAGE  "Seleccionar registros para ser enviados" ;
         ACTION   ChangelSndDoc() ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Lbl" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( lSelectAll( oWndBrw, dbfArticulo, dbfFam ) );
            TOOLTIP  "Todos" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Lbl" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( lSelectAll( oWndBrw, dbfArticulo, dbfFam, .f. ) );
            TOOLTIP  "Ninguno" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "SNDINT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ChangePublicar() );
         TOOLTIP  "P(u)blicar" ;
         HOTKEY   "U";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL oTct RESOURCE "TACTIL" OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( ChangeField( dbfArticulo, "lIncTcl", !( dbfArticulo )->lIncTcl, oWndBrw ) ) ;
         TOOLTIP  "Táctil" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Up" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( ChangePosition( .f. ), oWndBrw:Select() ) ;
            TOOLTIP  "S(u)bir posición" ;
            FROM     oTct ;
            CLOSED ;
            LEVEL    ACC_IMPR

         DEFINE BTNSHELL RESOURCE "Down" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( ChangePosition( .t. ), oWndBrw:Select() ) ;
            TOOLTIP  "Ba(j)ar posición" ;
            FROM     oTct ;
            LEVEL    ACC_IMPR

      if ( "VI" $ cParamsMain() )

      DEFINE BTNSHELL RESOURCE "BMPEXPTAR" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( GetDisk() ) ;
         TOOLTIP  "Infortisa" ;
         LEVEL    ACC_EDIT

      end if
      
      DEFINE BTNSHELL oScript RESOURCE "Folder_document_" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oScript:Expand() ) ;
         TOOLTIP  "Scripts" ;

         ImportScript( oWndBrw, oScript, "Articulos" )  

      DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oRotor:Expand() ) ;
         TOOLTIP  "Rotor" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Clipboard_empty_businessman_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( PedPrv( nil, oWnd, nil, ( dbfArticulo )->Codigo ) );
            TOOLTIP  "Añadir pedido a proveedor" ;
            FROM     oRotor ;
            ALLOW    EXIT ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Document_plain_businessman_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( AlbPrv( nil, oWnd, nil, ( dbfArticulo )->Codigo ) );
            TOOLTIP  "Añadir albarán de proveedor" ;
            FROM     oRotor ;
            ALLOW    EXIT ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Document_businessman_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( FacPrv( nil, oWnd, nil, ( dbfArticulo )->Codigo ) );
            TOOLTIP  "Añadir factura de proveedor" ;
            FROM     oRotor ;
            ALLOW    EXIT ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Notebook_user1_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( PreCli( nil, oWnd, nil, ( dbfArticulo )->Codigo ) );
            TOOLTIP  "Añadir presupuesto de cliente" ;
            FROM     oRotor ;
            ALLOW    EXIT ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Clipboard_empty_user1_" OF oWndBrw ;
            ACTION   ( PedCli( nil, oWnd, nil, ( dbfArticulo )->Codigo ) );
            TOOLTIP  "Añadir pedido de cliente" ;
            FROM     oRotor ;
            ALLOW    EXIT ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Document_plain_user1_" OF oWndBrw ;
            ACTION   ( AlbCli( nil, oWnd, { "Artículo" => ( dbfArticulo )->Codigo } ) );
            TOOLTIP  "Añadir albarán de cliente" ;
            FROM     oRotor ;
            ALLOW    EXIT ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Document_user1_" OF oWndBrw ;
            ACTION   ( FactCli( nil, oWnd, { "Artículo" => ( dbfArticulo )->Codigo } ) );
            TOOLTIP  "Añadir factura de cliente" ;
            FROM     oRotor ;
            ALLOW    EXIT ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Cashier_user1_" OF oWndBrw ;
            ACTION   ( FrontTpv( nil, oWnd, nil, ( dbfArticulo )->Codigo ) );
            TOOLTIP  "Añadir tiket de cliente" ;
            FROM     oRotor ;
            ALLOW    EXIT ;
            LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			ACTION 	( oWndBrw:End() ) ;
			TOOLTIP 	"(S)alir" ;
         ALLOW    EXIT ;
         HOTKEY   "S"

      oWndBrw:oActiveFilter:SetFields( aItmArt() )
      oWndBrw:oActiveFilter:SetFilterType( ART_TBL )

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles( .t. ) )

      if !Empty( bOnInit )
         Eval( bOnInit )
      end if

      bOnInit     := nil

      CursorWE()

   else

      oWndBrw:SetFocus()

   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfArticulo, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oFld
   local oBlock
   local oError
   local oBrwDiv
   local oBrwCtaCom
   local oBrwCodebar
   local aBtnDiv        := Array( 8 )
   local oBrwOfe
   local oBrwImg
   local oBrwStk
   local oBrwPrv
   local oBrwKit
   local bmpImage
   local oSayWeb        := Array(  6 )
   local oSay           := Array( 23 )
   local cSay           := Array( 23 )
   local oFnt
   local aBar           := { "Ean13", "Code39", "Code128" }
   local aBnfSobre      := { "Costo", "Venta" }
   local cDivUse        := cDivEmp()
   local oGetSubCta
   local cGetSubCta     := ""
   local oGetSaldo
   local nGetSaldo      := 0
   local oBrwCtaVta
   local nGetDebe       := 0
   local nGetHaber      := 0
   local oGetCtaCom
   local cGetCtaCom     := ""
   local nDebCom        := 0
   local nHabCom        := 0
   local oGetSalCom
   local nGetSalCom     := 0
   local oGetCtaTrn
   local cGetCtaTrn     := ""
   local oGetSalTrn
   local nGetSalTrn     := 0
   local cSubCtaAnt
   local cSubCtaAntCom
   local oNombre
   local oBtnMoneda
   local oValorPunto
   local oValorTot
   local oValorDto
   local oNom1
   local oNom2
   local oNom3
   local aBtn                 := Array( 14 )
   local oBmpCategoria
   local oBmpTemporada
   local cCbxPrecio           := "Ventas"
   local nTotStkAct           := 0
   local nTotStkPdr           := 0
   local nTotStkPde           := 0
   local oBmpGeneral
   local oBmpPrecios
   local oBmpDescripciones
   local oBmpPropiedades
   local oBmpLogistica
   local oBmpStocks
   local oBmpContabilidad
   local oBmpOfertas
   local oBmpEscandallos
   local oBmpWeb
   local oBmpUbicaciones
   local oBmpImagenes
   local aImpComanda          := aTiposImpresoras( dbfTImp )
   local oImpComanda1
   local oImpComanda2
   local cImpComanda1
   local cImpComanda2

   CursorWait()

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   do case
   case nMode == APPD_MODE

      aTmp[ ( dbfArticulo )->( fieldpos( "nLabel"    ) ) ]  := 1
      aTmp[ ( dbfArticulo )->( fieldpos( "nCtlStock" ) ) ]  := 1
      aTmp[ ( dbfArticulo )->( fieldpos( "lLote"     ) ) ]  := .f.
      aTmp[ ( dbfArticulo )->( fieldpos( "Codigo"    ) ) ]  := Space( 18 )
      aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc"   ) ) ]  := uFieldEmpresa( "lIvaInc" )
      aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva"   ) ) ]  := cDefIva()
      aTmp[ ( dbfArticulo )->( fieldpos( "cCodTemp"  ) ) ]  := uFieldEmpresa( "cDefTem" )

      aTmp[ ( dbfArticulo )->( fieldpos( "nImpCom1"  ) ) ]  := 1
      aTmp[ ( dbfArticulo )->( fieldpos( "nImpCom2"  ) ) ]  := 1

      aTmp[ ( dbfArticulo )->( fieldpos( "nFacCnv"   ) ) ]  := 1

      if nDefBnf( 1 ) != 0
      aTmp[ ( dbfArticulo )->( fieldpos( "Benef1"    ) ) ]  := nDefBnf( 1 )
      aTmp[ ( dbfArticulo )->( fieldpos( "lBnf1"     ) ) ]  := .t.
      aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr1"  ) ) ]  := nDefSbr( 1 )
      end if

      if nDefBnf( 2 ) != 0
      aTmp[ ( dbfArticulo )->( fieldpos( "Benef2"    ) ) ]  := nDefBnf( 2 )
      aTmp[ ( dbfArticulo )->( fieldpos( "lBnf2"     ) ) ]  := .t.
      aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr2"  ) ) ]  := nDefSbr( 2 )
      end if

      if nDefBnf( 3 ) != 0
      aTmp[ ( dbfArticulo )->( fieldpos( "Benef3"    ) ) ]  := nDefBnf( 3 )
      aTmp[ ( dbfArticulo )->( fieldpos( "lBnf3"     ) ) ]  := .t.
      aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr3"  ) ) ]  := nDefSbr( 3 )
      end if

      if nDefBnf( 4 ) != 0
      aTmp[ ( dbfArticulo )->( fieldpos( "Benef4"    ) ) ]  := nDefBnf( 4 )
      aTmp[ ( dbfArticulo )->( fieldpos( "lBnf4"     ) ) ]  := .t.
      aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr4"  ) ) ]  := nDefSbr( 4 )
      end if

      if nDefBnf( 5 ) != 0
      aTmp[ ( dbfArticulo )->( fieldpos( "Benef5"    ) ) ]  := nDefBnf( 5 )
      aTmp[ ( dbfArticulo )->( fieldpos( "lBnf5"     ) ) ]  := .t.
      aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr5"  ) ) ]  := nDefSbr( 5 )
      end if

      if nDefBnf( 6 ) != 0
      aTmp[ ( dbfArticulo )->( fieldpos( "Benef6"    ) ) ]  := nDefBnf( 6 )
      aTmp[ ( dbfArticulo )->( fieldpos( "lBnf6"     ) ) ]  := .t.
      aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr6"  ) ) ]  := nDefSbr( 6 )
      end if

      aTmp[ ( dbfArticulo )->( fieldpos( "nDuracion" ) ) ]  := 0
      aTmp[ ( dbfArticulo )->( fieldpos( "nTipDur" ) ) ]    := 1

   case nMode == DUPL_MODE

      aTmp[ ( dbfArticulo )->( fieldpos( "Codigo"   ) ) ]   := NextKey( aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], dbfArticulo )
      aTmp[ ( dbfArticulo )->( fieldpos( "CodeBar"  ) ) ]   := ""

   end case

   cCatOld                    := aTmp[ ( dbfArticulo )->( fieldpos( "cCodCat" ) ) ]
   cPrvOld                    := aTmp[ ( dbfArticulo )->( fieldpos( "cPrvHab" ) ) ]
   cImageOld                  := aTmp[ ( dbfArticulo )->( fieldpos( "cImagen" ) ) ]

   if Empty( aTmp[ ( dbfArticulo )->( fieldpos( "nColBtn" ) ) ] )
      aTmp[ ( dbfArticulo )->( fieldpos( "nColBtn" ) ) ]    := GetSysColor( COLOR_BTNFACE )
   end if

   if Empty( aTmp[ ( dbfArticulo )->( fieldpos( "nTipBar" ) ) ] )
      aTmp[ ( dbfArticulo )->( fieldpos( "nTipBar" ) ) ]    := 1
   else
      if aTmp[ ( dbfArticulo )->( fieldpos( "nTipBar" ) ) ] > 3
         aTmp[ ( dbfArticulo )->( fieldpos( "nTipBar" ) ) ] := 3
      end if
   end if

   cImpComanda1    := if( Empty( aTmp[ ( dbfArticulo )->( fieldpos( "cTipImp1" ) ) ] ), "No imprimir", AllTrim( aTmp[ ( dbfArticulo )->( fieldpos( "cTipImp1" ) ) ] ) )
   cImpComanda2    := if( Empty( aTmp[ ( dbfArticulo )->( fieldpos( "cTipImp2" ) ) ] ), "No imprimir", AllTrim( aTmp[ ( dbfArticulo )->( fieldpos( "cTipImp2" ) ) ] ) )

   cSay[7]         := aBar[ aTmp[ ( dbfArticulo )->( fieldpos( "nTipBar" ) ) ] ]
   cSay[6]         := ""

   cSay[11]        := aBnfSobre[ Max( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr1" ) ) ], 1 ) ]
   cSay[12]        := aBnfSobre[ Max( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr2" ) ) ], 1 ) ]
   cSay[13]        := aBnfSobre[ Max( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr3" ) ) ], 1 ) ]
   cSay[14]        := aBnfSobre[ Max( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr4" ) ) ], 1 ) ]
   cSay[15]        := aBnfSobre[ Max( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr5" ) ) ], 1 ) ]
   cSay[16]        := aBnfSobre[ Max( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr6" ) ) ], 1 ) ]

   cSubCtaAnt      := aTmp[ ( dbfArticulo )->( fieldpos( "cCtaVta" ) ) ]
   cSubCtaAntCom   := aTmp[ ( dbfArticulo )->( fieldpos( "cCtaCom" ) ) ]
   cCodigoFamilia  := aTmp[ ( dbfArticulo )->( fieldpos( "Familia" ) ) ]

   /*
   Filtros para los stocks-----------------------------------------------------
   */

   CursorWE()

   /*
   Cargamos los precios en sus variables---------------------------------------
	*/

   DEFINE DIALOG oDlg RESOURCE "Articulo" TITLE LblTitle( nMode ) + "artículo : " + Rtrim( aTmp[ ( dbfArticulo )->( fieldpos( "Nombre" ) ) ] )

      REDEFINE FOLDER oFld;
         ID       300 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "&Precios",;
                  "&Táctil",;
                  "&Descripciones",;
                  "P&ropiedades",;
                  "Imagenes",;
                  "&Logística",;
                  "&Stocks",;
                  "Co&ntabilidad",;
                  "&Ofertas",;
                  "&Escandallos",;
                  "&Web";
         DIALOGS  "ART_1",;
                  "ART_5",;
                  "ART_Tactil",;
                  "ART_2",;
                  "ART_20",;
                  "ART_12",;
                  "ART_Logistica",;
                  "ART_3",;
                  "ART_15",;
                  "ART_4",;
                  "ART_6",;
                  "ART_Web"

	/*
	Primera Caja de Dialog del Folder
	------------------------------------------------------------------------
	*/

   REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "Cube_Yellow_Alpha_48" ;
         TRANSPARENT ;
         OF       fldGeneral

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ];
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ];
			ID 		110 ;
         PICTURE  "@!" ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( CheckValid( aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], dbfArticulo, 1, nMode ) ) ;
         BITMAP   "Bot" ;
         ON HELP  ( aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]:cText( NextKey( aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], dbfArticulo ) ) ) ;
         OF       fldGeneral

   REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "Nombre" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "Nombre" ) ) ];
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ON CHANGE( ActTitle( nKey, nFlags, Self, nMode, oDlg ) );
         OF       fldGeneral

   /*
   Codigos de barras___________________________________________________________
	*/

   oBrwCodebar                   := IXBrowse():New( fldGeneral )

   oBrwCodebar:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwCodebar:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   oBrwCodebar:lRecordSelector   := .f.
   oBrwCodebar:cAlias            := dbfTmpCodebar
   oBrwCodebar:nMarqueeStyle     := 6

   oBrwCodebar:CreateFromResource( 330 )
   oBrwCodebar:lHScroll          := .f.

      with object ( oBrwCodebar:AddCol() )
         :cHeader                := "Df. Defecto"
         :bStrData               := {|| "" }
         :bEditValue             := {|| ( dbfTmpCodebar )->lDefBar }
         :nWidth                 := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwCodebar:AddCol() )
         :cHeader                := "Código"
         :bEditValue             := {|| ( dbfTmpCodebar )->cCodBar }
         :nWidth                 := 120
      end with

      if nMode != ZOOM_MODE
         oBrwCodebar:bLDblClick  := {|| WinEdtRec( oBrwCodebar, bEdtCod, dbfTmpCodebar, , , aTmp ) }
      end if

   REDEFINE BUTTON aBtn[2] ;
         ID       300 ;
         OF       fldGeneral;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwCodebar, bEdtCod, dbfTmpCodebar, , , aTmp ) )

   REDEFINE BUTTON aBtn[3] ;
         ID       310 ;
         OF       fldGeneral;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwCodebar, bEdtCod, dbfTmpCodebar, , , aTmp ) )

   REDEFINE BUTTON aBtn[4];
         ID       320 ;
         OF       fldGeneral;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinDelRec( oBrwCodebar, dbfTmpCodebar ) )

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "FAMILIA" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "FAMILIA" ) ) ] ;
			ID 		160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( ExpFamilia( aTmp[ ( dbfArticulo )->( fieldpos( "FAMILIA" ) ) ], oSay[ 3 ], aGet ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFamilia( aGet[ ( dbfArticulo )->( fieldpos( "FAMILIA" ) ) ], oSay[ 3 ] ) );
         OF       fldGeneral

   REDEFINE GET   oSay[3];
         VAR      cSay[3];
			WHEN 		( .F. );
			ID 		161 ;
         OF       fldGeneral

   REDEFINE SAY oNombre VAR "Tipo artículo";
         ID       888 ;
         OF       fldGeneral

   REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "CCODTIP" ) ) ] VAR aTmp[( dbfArticulo )->( fieldpos( "CCODTIP" ) ) ] ;
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oTipArt:Existe( aGet[ ( dbfArticulo )->( fieldpos( "CCODTIP" ) ) ], oSay[9] ) );
         ON HELP  ( oTipArt:Buscar( aGet[ ( dbfArticulo )->( fieldpos( "CCODTIP" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
         OF       fldGeneral

   REDEFINE GET oSay[9] VAR cSay[9] ;
         ID       271 ;
         SPINNER ;
         WHEN     ( .f. ) ;
         OF       fldGeneral

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "cCodFab" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "cCodFab" ) ) ] ;
         ID       390 ;
         IDTEXT   391 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       fldGeneral

   aGet[ ( dbfArticulo )->( fieldpos( "cCodFab" ) ) ]:bValid := {|| ( aGet[ ( dbfArticulo )->( fieldpos( "cCodFab" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfArticulo )->( fieldpos( "cCodFab" ) ) ], oFabricante:GetAlias() ) ), .t. ) }
   aGet[ ( dbfArticulo )->( fieldpos( "cCodFab" ) ) ]:bHelp  := {|| oFabricante:Buscar( aGet[ ( dbfArticulo )->( fieldpos( "cCodFab" ) ) ] ) }

   /*
   Categoría de artículo-------------------------------------------------------
   */

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "CCODCATE" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "CCODCATE" ) ) ] ;
         ID       350 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cCategoria( aGet[ ( dbfArticulo )->( fieldpos( "CCODCATE" ) ) ], dbfCategoria, oSay[ 17 ], oBmpCategoria ) ) ;
         ON HELP  ( BrwCategoria( aGet[ ( dbfArticulo )->( fieldpos( "CCODCATE" ) ) ], oSay[ 17 ], oBmpCategoria ) ) ;
         BITMAP   "LUPA" ;
         OF       fldGeneral

   REDEFINE GET   oSay[ 17 ] VAR cSay[ 17 ] ;
         ID       351 ;
         SPINNER ;
         WHEN     ( .f. ) ;
         OF       fldGeneral

   REDEFINE BITMAP oBmpCategoria ;
         ID       352 ;
         TRANSPARENT ;
         OF       fldGeneral

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "cCodTemp" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "cCodTemp" ) ) ] ;
         ID       355 ;
         IDTEXT   356 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cTemporada( aGet[ ( dbfArticulo )->( fieldpos( "cCodTemp" ) ) ], dbfTemporada, aGet[ ( dbfArticulo )->( fieldpos( "cCodTemp" ) ) ]:oHelpText, oBmpTemporada ) ) ;
         ON HELP  ( BrwTemporada( aGet[ ( dbfArticulo )->( fieldpos( "cCodTemp" ) ) ], aGet[ ( dbfArticulo )->( fieldpos( "cCodTemp" ) ) ]:oHelpText, oBmpTemporada ) ) ;
         BITMAP   "LUPA" ;
         OF       fldGeneral

   REDEFINE BITMAP oBmpTemporada ;
         ID       357 ;
         TRANSPARENT ;
         OF       fldGeneral

   /*
   Lote------------------------------------------------------------------------
   */

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "lLote" ) ) ] ;
         ID       600 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

   REDEFINE GET aTmp[ ( dbfArticulo )->( fieldpos( "cLote" ) ) ] ;
         ID       610 ;
         WHEN     ( nMode != ZOOM_MODE .AND. aTmp[ ( dbfArticulo )->( fieldpos( "lLote" ) ) ] );
         OF       fldGeneral

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "lTipAcc" ) ) ] ;
         ID       280 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "lAutSer" ) ) ];
         ID       138 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

   REDEFINE CHECKBOX aGet[ ( dbfArticulo )->( fieldpos( "lObs" ) )] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "lObs" ) )];
         ID       139 ;
         OF       fldGeneral

   REDEFINE CHECKBOX aGet[ ( dbfArticulo )->( fieldpos( "lNumSer" ) ) ];
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "lNumSer" ) ) ];
         ID       136 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

   bmpImage             := TImage():ReDefine( 500,, cFileBmpName( cImgArticulo ( aTmp ) ), oDlg,,, .F., .T.,,, .F.,, )

   bmpImage:SetColor( , GetSysColor( 15 ) )
   bmpImage:bLClicked   := {|| ShowImage( bmpImage ) }
   bmpImage:bRClicked   := {|| ShowImage( bmpImage ) }

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "lFacCnv" ) ) ] ;
      ID       200 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ON CHANGE( ChangeFactorConversion( aTmp, aGet ) ) ;
      OF       fldGeneral

   REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "nFacCnv" ) ) ] ;
      VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nFacCnv" ) ) ] ;
      ID       210 ;
      WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( dbfArticulo )->( fieldpos( "lFacCnv" ) ) ] );
      PICTURE  "@E 999,999.999999" ;
      OF       fldGeneral

   REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "nDuracion" ) ) ] ;
      VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nDuracion" ) ) ] ;
      ID       250 ;
      SPINNER ;
      MIN      0 ;
      MAX      100 ;
      WHEN     ( nMode != ZOOM_MODE );
      OF       fldGeneral

   REDEFINE COMBOBOX aGet[ ( dbfArticulo )->( fieldpos( "nTipDur" ) ) ];
      VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nTipDur" ) ) ];
      ITEMS    { "Dia (s)", "Mes (es)", "Año (s)" };
      ID       251 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldGeneral


   /*
   REDEFINE CHECKBOX aGet[ ( dbfArticulo )->( fieldpos( "lTerminado" ) ) ];
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "lTerminado" ) ) ];
         ID       620 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral
   */

   /*
   Tactil----------------------------------------------------------------------
   */

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "LINCTCL" ) ) ] ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldTactil

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "nPosTpv" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nPosTpv" ) ) ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( aTmp[ ( dbfArticulo )->( fieldpos( "nPosTpv" ) ) ] >= 0 .and. aTmp[ ( dbfArticulo )->( fieldpos( "nPosTpv" ) ) ] <= 999 ) ;
         PICTURE  "999" ;
         SPINNER ;
         MIN      ( 0 ) ;
         MAX      ( 99 ) ;
         ID       225 ;
         OF       fldTactil

   REDEFINE GET   aTmp[ ( dbfArticulo )->( fieldpos( "CDESTCL" ) ) ] ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldTactil

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "nColBtn" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nColBtn" ) ) ] ;
         ID       290 ;
         COLOR    aTmp[ ( dbfArticulo )->( fieldpos( "nColBtn" ) ) ], aTmp[ ( dbfArticulo )->( fieldpos( "nColBtn" ) ) ] ;
         BITMAP   "COLORS_16" ;
         ON HELP  ( ColorFam( aGet[ ( dbfArticulo )->( fieldpos( "nColBtn" ) ) ] ) ) ;
         OF       fldTactil

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "cImagen" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "cImagen" ) ) ] ;
         BITMAP   "Lupa" ;
         ON HELP  ( GetBmp( aGet[ ( dbfArticulo )->( fieldpos( "cImagen" ) ) ], bmpImage ) ) ;
         ON CHANGE( ChgBmp( cImgArticulo ( aTmp ), bmpImage ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( ChgBmp( cImgArticulo ( aTmp ), bmpImage ) ) ;
         ID       220 ;
         OF       fldTactil

   REDEFINE COMBOBOX oImpComanda1 VAR cImpComanda1 ;
      ITEMS       aImpComanda ;
      ID          450 ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          fldTactil

   REDEFINE COMBOBOX oImpComanda2 VAR cImpComanda2 ;
      ITEMS       aImpComanda ;
      ID          460 ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          fldTactil

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldPos( "cOrdOrd" ) ) ] ;
      VAR         aTmp[ ( dbfArticulo )->( fieldPos( "cOrdOrd" ) ) ] ;
      BITMAP      "Lupa" ;
      ID          470 ;
      IDTEXT      471 ;
      VALID       ( oOrdenComanda:Existe( aGet[ ( dbfArticulo )->( fieldpos( "cOrdOrd" ) ) ], aGet[ ( dbfArticulo )->( fieldPos( "cOrdOrd" ) ) ]:oHelpText ) );
      ON HELP     ( oOrdenComanda:Buscar( aGet[ ( dbfArticulo )->( fieldpos( "cOrdOrd" ) ) ] ) ) ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          fldTactil

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "lPeso" ) ) ] ;
      ID          480 ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          fldTactil

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldPos( "cMenu" ) ) ] ;
      VAR         aTmp[ ( dbfArticulo )->( fieldPos( "cMenu" ) ) ] ;
      BITMAP      "Lupa" ;
      ID          490 ;
      IDTEXT      491 ;
      VALID       ( oTpvMenu:Existe( aGet[ ( dbfArticulo )->( fieldpos( "cMenu" ) ) ], aGet[ ( dbfArticulo )->( fieldPos( "cMenu" ) ) ]:oHelpText ) );
      ON HELP     ( oTpvMenu:Buscar( aGet[ ( dbfArticulo )->( fieldpos( "cMenu" ) ) ] ) ) ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          fldTactil

   /*
	Segunda Caja de Dialogo del Folder
	---------------------------------------------------------------------------
   */

   REDEFINE BITMAP oBmpPrecios ;
         ID       500 ;
         RESOURCE "Symbol_euro_Alpha_48" ;
         TRANSPARENT ;
         OF       fldPrecios

      REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ] ;
         ID       820 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldPrecios

      REDEFINE GET aGet[( dbfArticulo )->( fieldpos( "TipoIva" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ] ;
         ID       800;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  cTiva(   aGet[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ], dbfIva, oSay[2] ),;
                              aGet[ ( dbfArticulo )->( fieldpos( "pVenta1" ) ) ]:lValid(),;
                              aGet[ ( dbfArticulo )->( fieldpos( "pVenta2" ) ) ]:lValid(),;
                              aGet[ ( dbfArticulo )->( fieldpos( "pVenta3" ) ) ]:lValid(),;
                              aGet[ ( dbfArticulo )->( fieldpos( "pVenta4" ) ) ]:lValid(),;
                              aGet[ ( dbfArticulo )->( fieldpos( "pVenta5" ) ) ]:lValid(),;
                              aGet[ ( dbfArticulo )->( fieldpos( "pVenta6" ) ) ]:lValid(), .t. ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[( dbfArticulo )->( fieldpos( "TipoIva" ) ) ], nil , oSay[2] ) ) ;
         OF       fldPrecios

      REDEFINE GET oSay[2] VAR cSay[2] ;
         WHEN     ( .F. );
         ID       801 ;
         OF       fldPrecios

      REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "CCODIMP" ) ) ] VAR aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP" ) ) ] ;
         ID       810;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oNewImp:Existe( aGet[ ( dbfArticulo )->( fieldpos( "CCODIMP" ) ) ], oSay[ 10 ], "cNomImp", .t., .t., "0" ) );
         ON HELP  ( oNewImp:Buscar( aGet[ ( dbfArticulo )->( fieldpos( "CCODIMP" ) ) ], "cCodImp" ) ) ;
         BITMAP   "LUPA" ;
         OF       fldPrecios

      REDEFINE GET oSay[10] VAR cSay[10] ;
         WHEN     ( .F. );
         ID       811 ;
         OF       fldPrecios

      REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "pCosto" ) ) ] ;
         VAR         aTmp[ ( dbfArticulo )->( fieldpos( "pCosto" ) ) ] ;
         ID          110 ;
         WHEN        ( !lEscandallo( aTmp ) .and. nMode != ZOOM_MODE ) ;
         VALID       ( ValidPrecioCosto( aGet, oSayWeb ) ) ;
         SPINNER ;
         PICTURE     cPinDiv ;
         OF          fldPrecios ;

      REDEFINE SAY oCosto ;
         PROMPT   nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ;
         ID       111 ;
         PICTURE  cPinDiv ;
         OF       fldPrecios

      /*
      Codificacion de proveedores----------------------------------------------
      */

      REDEFINE BUTTON aBtnDiv[ 5 ]; 
         ID       510 ;
         OF       fldPrecios;
         ACTION   ( CodificacionProveedor( aTmp, aGet, nMode ) )

      REDEFINE COMBOBOX oCbxPrecio VAR cCbxPrecio ;
         ITEMS    { "Ventas", "Alquiler" } ;
         ID       610 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldPrecios

         // ON CHANGE( StartDlg( aGet, aTmp, nMode, oSay, oDlg, oCosto, aBtnDiv, oFnt, oBtnMoneda, aBtn, bmpImage ) ) ;
   /*
   Etiquetas de tarifas--------------------------------------------------------
   */

   REDEFINE SAY oSay[ 18 ] VAR cSay[ 18 ] ;
       ID       171 ;
       OF       fldPrecios ;

   REDEFINE SAY oSay[ 19 ] VAR cSay[ 19 ] ;
       ID       211 ;
       OF       fldPrecios ;

   REDEFINE SAY oSay[ 20 ] VAR cSay[ 20 ];
       ID       251 ;
       OF       fldPrecios ;

   REDEFINE SAY oSay[ 21 ] VAR cSay[ 21 ] ;
       ID       291 ;
       OF       fldPrecios ;

   REDEFINE SAY oSay[ 22 ] VAR cSay[ 22 ] ;
       ID       331 ;
       OF       fldPrecios ;

   REDEFINE SAY oSay[ 23 ] VAR cSay[ 23 ] ;
       ID       371 ;
       OF       fldPrecios ;

   /*
   Tarifa1 ______________________________________________________________________________
   */

      REDEFINE CHECKBOX aGet[ ( dbfArticulo )->( fieldpos( "lBnf1" ) ) ] ;
         VAR            aTmp[ ( dbfArticulo )->( fieldpos( "lBnf1" ) ) ] ;
         ID       150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       fldPrecios

      REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "Benef1" ) ) ] ;
         VAR         aTmp[ ( dbfArticulo )->( fieldpos( "Benef1" ) ) ] ;
         ID       160 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "lBnf1" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 11 ]:nAt <= 1,;
                              if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                              aTmp[ ( dbfArticulo )->( fieldpos( "lBnf1"   ) ) ],;
                              aTmp[ ( dbfArticulo )->( fieldpos( "Benef1"  ) ) ],;
                              aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "pVenta1" ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva1") ) ],;
                              nDecDiv,;
                              aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                              oSayWeb[ 1 ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

      REDEFINE COMBOBOX oSay[ 11 ] VAR cSay[ 11 ] ;
         ITEMS    aBnfSobre ;
         ID       165 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE(  if (  aTmp[ ( dbfArticulo )->( fieldpos( "lBnf1"  ) ) ],;
                           aGet[ ( dbfArticulo )->( fieldpos( "Benef1" ) ) ]:lValid(),;
                        ),;
                     if (  aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                           aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva1") ) ]:lValid(),;
                           aGet[ ( dbfArticulo )->( fieldpos( "pVenta1" ) ) ]:lValid() ) );
         OF       fldPrecios

      REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "PVENTA1" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA1" ) ) ] ;
         ID       170 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 11 ]:nAt <= 1,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA1" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "BENEF1"  ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA1") ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP" ) ) ],;
                                 oSayWeb[ 1 ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lMarAju" ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cMarAju" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

      REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA1" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVTAIVA1" ) ) ] ;
         ID       180 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 11 ]:nAt <= 1,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA1") ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "BENEF1"  ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVENTA1" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP" ) ) ],;
                                 oSayWeb[ 1 ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lMarAju" ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cMarAju" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   /*
   TARIFA2 ______________________________________________________________________________
	*/

      REDEFINE CHECKBOX aGet[ ( dbfArticulo )->( fieldpos( "LBNF2" ) ) ] ;
         VAR            aTmp[ ( dbfArticulo )->( fieldpos( "LBNF2" ) ) ] ;
         ID       190 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       fldPrecios

   REDEFINE COMBOBOX oSay[ 12 ] VAR cSay[ 12 ] ;
         ITEMS    aBnfSobre ;
         ID       205 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE(  if (  aTmp[ ( dbfArticulo )->( fieldpos( "lBnf2"  ) ) ],;
                           aGet[ ( dbfArticulo )->( fieldpos( "Benef2" ) ) ]:lValid(),;
                        ),;
                     if (  aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                           aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva2") ) ]:lValid(),;
                           aGet[ ( dbfArticulo )->( fieldpos( "pVenta2" ) ) ]:lValid() ) );
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "BENEF2" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "BENEF2" ) ) ] ;
         ID       200 ;
         SPINNER ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "LBNF2" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 12 ]:nAt <= 1,;
                              if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                              aTmp[ ( dbfArticulo )->( fieldpos( "LBNF2"    ) ) ],;
                              aTmp[ ( dbfArticulo )->( fieldpos( "BENEF2"   ) ) ],;
                              aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "PVENTA2"  ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA2" ) ) ],;
                              nDecDiv,;
                              aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                              oSayWeb[ 2 ] ) );
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "PVENTA2" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA2" ) ) ] ;
         ID       210 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 12 ]:nAt <= 1,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA2"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "BENEF2"   ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA2" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 2 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA2" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVTAIVA2" ) ) ] ;
			ID 		220 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 12 ]:nAt <= 1,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA2" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "BENEF2"   ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVENTA2"  ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 2 ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lMarAju" ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cMarAju" ) ) ] ) );
			PICTURE 	cPouDiv ;
         OF       fldPrecios

   /*
   TARIFA3 ______________________________________________________________________________
	*/

      REDEFINE CHECKBOX aGet[ ( dbfArticulo )->( fieldpos( "LBNF3" ) ) ] ;
         VAR            aTmp[ ( dbfArticulo )->( fieldpos( "LBNF3" ) ) ] ;
         ID       230 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       fldPrecios

   REDEFINE COMBOBOX oSay[ 13 ] VAR cSay[ 13 ] ;
         ITEMS    aBnfSobre ;
         ID       245 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE(  if (  aTmp[ ( dbfArticulo )->( fieldpos( "lBnf3"  ) ) ],;
                           aGet[ ( dbfArticulo )->( fieldpos( "Benef3" ) ) ]:lValid(),;
                        ),;
                     if (  aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                           aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva3") ) ]:lValid(),;
                           aGet[ ( dbfArticulo )->( fieldpos( "pVenta3" ) ) ]:lValid() ) );
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "BENEF3" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "BENEF3" ) ) ] ;
         ID       240 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "LBNF3" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 13 ]:nAt <= 1,;
                              if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                              aTmp[ ( dbfArticulo )->( fieldpos( "LBNF3"    ) ) ],;
                              aTmp[ ( dbfArticulo )->( fieldpos( "BENEF3"   ) ) ],;
                              aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "PVENTA3"  ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA3" ) ) ],;
                              nDecDiv,;
                              aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                              oSayWeb[ 3 ] ) );
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "PVENTA3" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA3" ) ) ] ;
         ID       250 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 13 ]:nAt <= 1,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA3"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "BENEF3"   ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA3" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 3 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA3" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVTAIVA3" ) ) ] ;
         ID       260 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 13 ]:nAt <= 1,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA3" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "BENEF3"   ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVENTA3"  ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 3 ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lMarAju" ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cMarAju" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   /*
   TARIFA4 ______________________________________________________________________________
	*/

   REDEFINE CHECKBOX aGet[ ( dbfArticulo )->( fieldpos( "LBNF4" ) ) ] ;
         VAR         aTmp[ ( dbfArticulo )->( fieldpos( "LBNF4" ) ) ] ;
         ID       270 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       fldPrecios

   REDEFINE COMBOBOX oSay[ 14 ] VAR cSay[ 14 ] ;
         ITEMS    aBnfSobre ;
         ID       285 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE(  if (  aTmp[ ( dbfArticulo )->( fieldpos( "lBnf4"  ) ) ],;
                           aGet[ ( dbfArticulo )->( fieldpos( "Benef4" ) ) ]:lValid(),;
                        ),;
                     if (  aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                           aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva4") ) ]:lValid(),;
                           aGet[ ( dbfArticulo )->( fieldpos( "pVenta4" ) ) ]:lValid() ) );
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "BENEF4" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "BENEF4" ) ) ] ;
         ID       280 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "LBNF4" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 14 ]:nAt <= 1,;
                              if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                              aTmp[ ( dbfArticulo )->( fieldpos( "LBNF4"    ) ) ],;
                              aTmp[ ( dbfArticulo )->( fieldpos( "BENEF4"   ) ) ],;
                              aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "PVENTA4"  ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA4" ) ) ],;
                              nDecDiv,;
                              aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                              oSayWeb[ 4 ] ) );
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "PVENTA4" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA4" ) ) ] ;
         ID       290 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 14 ]:nAt <= 1,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA4"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "BENEF4"   ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA4" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 4 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA4" ) ) ];
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVTAIVA4" ) ) ] ;
         ID       300 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 14 ]:nAt <= 1,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA4" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "BENEF4"   ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVENTA4"  ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 4 ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lMarAju" ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cMarAju" ) ) ] ) );
			PICTURE 	cPouDiv ;
         OF       fldPrecios

   /*
   TARIFA5 ______________________________________________________________________________
	*/

   REDEFINE CHECKBOX aGet[ ( dbfArticulo )->( fieldpos( "LBNF5" ) ) ] ;
         VAR         aTmp[ ( dbfArticulo )->( fieldpos( "LBNF5" ) ) ] ;
         ID       310 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       fldPrecios

   REDEFINE COMBOBOX oSay[ 15 ] VAR cSay[ 15 ] ;
         ITEMS    aBnfSobre ;
         ID       325 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE(  if (  aTmp[ ( dbfArticulo )->( fieldpos( "lBnf5"  ) ) ],;
                           aGet[ ( dbfArticulo )->( fieldpos( "Benef5" ) ) ]:lValid(),;
                        ),;
                     if (  aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                           aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva5") ) ]:lValid(),;
                           aGet[ ( dbfArticulo )->( fieldpos( "pVenta5" ) ) ]:lValid() ) );
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "BENEF5" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "BENEF5" ) ) ] ;
         ID       320 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "LBNF5" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 15 ]:nAt <= 1,;
                              if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                              aTmp[ ( dbfArticulo )->( fieldpos( "LBNF5"    ) ) ],;
                              aTmp[ ( dbfArticulo )->( fieldpos( "BENEF5"   ) ) ],;
                              aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "PVENTA5"  ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA5" ) ) ],;
                              nDecDiv,;
                              aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                              oSayWeb[ 5 ] ) );
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "PVENTA5" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA5" ) ) ] ;
         ID       330 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 15 ]:nAt <= 1,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA5"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "BENEF5"   ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA5" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 5 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA5" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVTAIVA5" ) ) ] ;
         ID       340 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 15 ]:nAt <= 1,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA5" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "BENEF5" ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVENTA5" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP" ) ) ],;
                                 oSayWeb[ 5 ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lMarAju" ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cMarAju" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios


   /*
   TARIFA6 ______________________________________________________________________________
	*/

   REDEFINE CHECKBOX aGet[ ( dbfArticulo )->( fieldpos( "LBNF6" ) ) ] ;
         VAR         aTmp[ ( dbfArticulo )->( fieldpos( "LBNF6" ) ) ] ;
         ID          350 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          fldPrecios

   REDEFINE COMBOBOX oSay[ 16 ] VAR cSay[ 16 ] ;
         ITEMS       aBnfSobre ;
         ID          365 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         ON CHANGE   (  if (  aTmp[ ( dbfArticulo )->( fieldpos( "lBnf6"  ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "Benef6" ) ) ]:lValid(),;
                           ),;
                        if (  aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva6") ) ]:lValid(),;
                              aGet[ ( dbfArticulo )->( fieldpos( "pVenta6" ) ) ]:lValid() ) );
         OF          fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "Benef6" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "Benef6" ) ) ] ;
         ID       360 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "LBNF6" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 16 ]:nAt <= 1,;
                              if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                              aTmp[ ( dbfArticulo )->( fieldpos( "LBNF6"    ) ) ],;
                              aTmp[ ( dbfArticulo )->( fieldpos( "BENEF6"   ) ) ],;
                              aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "PVENTA6"  ) ) ],;
                              aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA6" ) ) ],;
                              nDecDiv,;
                              aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                              oSayWeb[ 6 ] ) );
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "PVENTA6" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA6" ) ) ] ;
         ID       370 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 16 ]:nAt <= 1,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA6"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "BENEF6"   ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA6" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 6 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA6" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVTAIVA6" ) ) ] ;
         ID       380 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 16 ]:nAt <= 1,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit ) ) ,;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA6" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "BENEF6"   ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "PVENTA6"  ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 6 ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lMarAju" ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cMarAju" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   /*
   Punto Verde_______________________________________________________________
	*/

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "NPNTVER1" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "NPNTVER1" ) ) ] ;
         ID       390 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( aGet[ ( dbfArticulo )->( fieldpos( "NPNVIVA1" ) ) ]:cText( ( aTmp[ ( dbfArticulo )->( fieldpos( "NPNTVER1" ) ) ] * nIva( dbfIva, aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA" ) )] ) / 100 ) + aTmp[ ( dbfArticulo )->( fieldpos( "NPNTVER1" ) ) ] ), .t. ) ;
         PICTURE  cPpvDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "NPNVIVA1" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "NPNVIVA1" ) ) ] ;
         ID       400 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
         VALID    ( aGet[ ( dbfArticulo )->( fieldpos( "NPNTVER1" ) ) ]:cText( aTmp[ ( dbfArticulo )->( fieldpos( "NPNVIVA1" ) ) ] / ( 1 + nIva( dbfIva, aTmp[ ( dbfArticulo )->( fieldpos( "TIPOIVA" ) )] ) / 100 ) ), .t. ) ;
         PICTURE  cPpvDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "PVPREC" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "PVPREC" ) ) ] ;
         ID       120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "NRENMIN" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "NRENMIN" ) ) ] ;
         ID       600 ;
         SPINNER  MIN 0 MAX 100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

      /*
      Precios de alquileres____________________________________________________
      */

      REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pAlq1" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pAlq1" ) ) ] ;
         ID       620 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "pAlq1"   ) ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva1") ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

      REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva1" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pAlqIva1" ) ) ] ;
         ID       680 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "pAlqIva1") ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "pAlq1"   ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

         REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pAlq2" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pAlq2" ) ) ] ;
         ID       630 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "pAlq2"   ) ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva2") ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

      REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva2" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pAlqIva2" ) ) ] ;
         ID       690 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "pAlqIva2") ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "pAlq2"   ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

         REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pAlq3" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pAlq3" ) ) ] ;
         ID       640 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "pAlq3"   ) ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva3") ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

      REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva3" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pAlqIva3" ) ) ] ;
         ID       700 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "pAlqIva3") ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "pAlq3"   ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

         REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pAlq4" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pAlq4" ) ) ] ;
         ID       650 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "pAlq4"   ) ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva4") ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

      REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva4" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pAlqIva4" ) ) ] ;
         ID       710 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "pAlqIva4") ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "pAlq4"   ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

         REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pAlq5" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pAlq5" ) ) ] ;
         ID       660 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "pAlq5"   ) ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva5") ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

      REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva5" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pAlqIva5" ) ) ] ;
         ID       720 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "pAlqIva5") ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "pAlq5"   ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

         REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pAlq6" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pAlq6" ) ) ] ;
         ID       670 ;
         WHEN     ( stdCol( !aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "pAlq6"   ) ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva6") ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

      REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva6" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pAlqIva6" ) ) ] ;
         ID       730 ;
         WHEN     ( stdCol( aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "pAlqIva6") ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "pAlq6"   ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

      /*
      Primer descuento---------------------------------------------------------
      */

      REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "nDtoArt1" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nDtoArt1" ) ) ] ;
         ID       410 ;
			SPINNER ;
         MIN      0 ;
         MAX      100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

      /*
      Segundo descuento--------------------------------------------------------
      */

      REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "nDtoArt2" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nDtoArt2" ) ) ] ;
         ID       420 ;
			SPINNER ;
         MIN      0 ;
         MAX      100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

      /*
      Tercer descuento---------------------------------------------------------
      */

      REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "nDtoArt3" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nDtoArt3" ) ) ] ;
         ID       430 ;
			SPINNER ;
         MIN      0 ;
         MAX      100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

      /*
      Cuarto descuento---------------------------------------------------------
      */

      REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "nDtoArt4" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nDtoArt4" ) ) ] ;
         ID       440 ;
			SPINNER ;
         MIN      0 ;
         MAX      100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

      /*
      Quinto descuento---------------------------------------------------------
      */

      REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "nDtoArt5" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nDtoArt5" ) ) ] ;
         ID       450 ;
			SPINNER ;
         MIN      0 ;
         MAX      100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

      /*
      Sexto descuento----------------------------------------------------------
      */

      REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "nDtoArt6" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nDtoArt6" ) ) ] ;
         ID       460 ;
			SPINNER ;
         MIN      0 ;
         MAX      100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

      REDEFINE CHECKBOX aGet[ ( dbfArticulo )->( fieldpos( "lMarAju" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "lMarAju" ) ) ] ;
         ID       470 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( dbfArticulo)->( FieldPos( "lIvaInc" ) ) ] );
         OF       fldPrecios

      REDEFINE COMBOBOX aGet[ ( dbfArticulo )->( fieldpos( "cMarAju" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "cMarAju" ) ) ] ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( dbfArticulo)->( FieldPos( "lIvaInc" ) ) ] .and. aTmp[ ( dbfArticulo )->( fieldpos( "lMarAju" ) ) ] );
         ID       480 ;
         ITEMS    {  "#,#0",;
                     "#,#5",;
                     "#,#9",;
                     "#,#5|#,#9",;
                     "#,#5|#,#0",;
                     "#,10",;
                     "#,20",;
                     "#,50",;
                     "#,50|#,90",;
                     "#,90",;
                     "#,95",;
                     "#,99",;
                     "#,95|#,99",;
                     "#,99",;
                     "#,00",;
                     "1,00",;
                     "5,00",;
                     "9,00",;
                     "10,00",;
                     "20,00",;
                     "50,00",;
                     "100,00" } ;
         OF       fldPrecios

         aGet[ ( dbfArticulo )->( fieldpos( "cMarAju" ) ) ]:bChange  := {||   aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva1" ) ) ]:lValid(),;
                                                                              aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva2" ) ) ]:lValid(),;
                                                                              aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva3" ) ) ]:lValid(),;
                                                                              aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva4" ) ) ]:lValid(),;
                                                                              aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva5" ) ) ]:lValid(),;
                                                                              aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva6" ) ) ]:lValid() }

      /*
      Tercera ventana----------------------------------------------------------
      */

      REDEFINE BITMAP oBmpDescripciones ;
         ID       500 ;
         RESOURCE "Document_Text_Alpha_48" ;
         TRANSPARENT ;
         OF       fldDescripciones

      REDEFINE GET aTmp[ ( dbfArticulo )->( fieldpos( "Descrip" ) ) ] MEMO;
			ID 		210 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       fldDescripciones

      REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "mComent" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "mComent" ) ) ];
         ID       370 ;
			MEMO ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldDescripciones

      REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "lMosCom" ) ) ] ;
         ID       380 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldDescripciones

      /*
      Fechas-------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "LastChg" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "LastChg" ) ) ] ;
         ID       195 ;
         WHEN     ( .f. ) ;
         OF       fldLogistica

      REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "dFecChg" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "dFecChg" ) ) ] ;
         ID       196 ;
         WHEN     ( .f. ) ;
         OF       fldLogistica

      /*
      Precios por propiedades--------------------------------------------------
      */

      REDEFINE BITMAP oBmpPropiedades ;
         ID       510 ;
         RESOURCE "Bookmark_Silver_Alpha_48" ;
         TRANSPARENT ;
         OF       fldPropiedades

      /*
      Propiedades del articulo----------------------------------------------------
      */

      REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ] ;
         VAR         aTmp[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ] ;
         ID          360 ;
         IDTEXT      361 ;
         PICTURE     "@!" ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         BITMAP      "Lupa" ;
         OF          fldPropiedades

      aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ]:bValid  := {|| cProp( aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ], aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ]:oHelpText ) }
      aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ]:bHelp   := {|| brwProp( aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ], aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ]:oHelpText ) }

      TBtnBmp():ReDefine( 362, "Printer_pencil_16",,,,,{|| brwSelectPropiedad( aTmp[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ], @aTmp[ ( dbfArticulo )->( fieldpos( "mValPrp1" ) ) ] ) }, fldPropiedades, .f., , .f., "Seleccionar propiedades" )

      REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ] ;
         VAR         aTmp[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ] ;
         ID          370 ;
         IDTEXT      371 ;
         PICTURE     "@!" ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         BITMAP      "Lupa" ;
         OF          fldPropiedades

      aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ]:bValid  := {|| cProp( aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ], aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ]:oHelpText ) }
      aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ]:bHelp   := {|| brwProp( aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ], aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ]:oHelpText ) }

      TBtnBmp():ReDefine( 372, "Printer_pencil_16",,,,,{|| brwSelectPropiedad( aTmp[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ], @aTmp[ ( dbfArticulo )->( fieldpos( "mValPrp2" ) ) ] ) }, fldPropiedades, .f., , .f., "Seleccionar propiedades" )


      oBrwDiv                 := IXBrowse():New( fldPropiedades )

      oBrwDiv:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDiv:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDiv:cAlias          := dbfTmpVta
      oBrwDiv:nMarqueeStyle   := 5
      oBrwDiv:cName           := "Articulos.Propiedades"

         with object ( oBrwDiv:AddCol() )
            :cHeader          := "Prop. 1"
            :bEditValue       := {|| ( dbfTmpVta )->cValPr1 }
            :nWidth           := 160
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := "Prop. 2"
            :bEditValue       := {|| ( dbfTmpVta )->cValPr2 }
            :nWidth           := 160
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := "Costo"
            :bEditValue       := {|| ( dbfTmpVta )->nPreCom }
            :nWidth           := 100
            :cEditPicture     := cPinDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
            :lHide            := .t.
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" )
            :bEditValue       := {|| ( dbfTmpVta )->nPreVta1 }
            :nWidth           := 100
            :cEditPicture     := cPouDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" ) + Space( 1 ) + cImp()
            :bEditValue       := {|| ( dbfTmpVta )->nPreIva1 }
            :nWidth           := 100
            :cEditPicture     := cPouDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" )
            :bEditValue       := {|| ( dbfTmpVta )->nPreVta2 }
            :nWidth           := 100
            :cEditPicture     := cPouDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
            :lHide            := .t.
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" ) + Space( 1 ) + cImp()
            :bEditValue       := {|| ( dbfTmpVta )->nPreIva2 }
            :nWidth           := 100
            :cEditPicture     := cPouDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
            :lHide            := .t.
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" )
            :bEditValue       := {|| ( dbfTmpVta )->nPreVta3 }
            :nWidth           := 100
            :cEditPicture     := cPouDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
            :lHide            := .t.
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" ) + Space( 1 ) + cImp()
            :bEditValue       := {|| ( dbfTmpVta )->nPreIva3 }
            :nWidth           := 100
            :cEditPicture     := cPouDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
            :lHide            := .t.
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" )
            :bEditValue       := {|| ( dbfTmpVta )->nPreVta4 }
            :nWidth           := 100
            :cEditPicture     := cPouDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
            :lHide            := .t.
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" ) + Space( 1 ) + cImp()
            :bEditValue       := {|| ( dbfTmpVta )->nPreIva4 }
            :nWidth           := 100
            :cEditPicture     := cPouDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
            :lHide            := .t.
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" )
            :bEditValue       := {|| ( dbfTmpVta )->nPreVta5 }
            :nWidth           := 100
            :cEditPicture     := cPouDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
            :lHide            := .t.
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" ) + Space( 1 ) + cImp()
            :bEditValue       := {|| ( dbfTmpVta )->nPreIva5 }
            :nWidth           := 100
            :cEditPicture     := cPouDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
            :lHide            := .t.
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" )
            :bEditValue       := {|| ( dbfTmpVta )->nPreVta6 }
            :nWidth           := 100
            :cEditPicture     := cPouDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
            :lHide            := .t.
         end with

         with object ( oBrwDiv:AddCol() )
            :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" ) + Space( 1 ) + cImp()
            :bEditValue       := {|| ( dbfTmpVta )->nPreIva6 }
            :nWidth           := 100
            :cEditPicture     := cPouDiv
            :nDataStrAlign    := AL_RIGHT
            :nHeadStrAlign    := AL_RIGHT
            :lHide            := .t.
         end with

         if nMode != ZOOM_MODE
            oBrwDiv:bLDblClick   := {|| WinEdtRec( oBrwDiv, bEdtVta, dbfTmpVta, , , aTmp ) }
         end if

         oBrwDiv:CreateFromResource( 430 )

   REDEFINE BUTTON aBtnDiv[ 1 ];
			ID 		500 ;
         OF       fldPropiedades;
         WHEN     ( !Empty( aTmp[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ] ) .and. nMode != ZOOM_MODE );
         ACTION   ( WinAppRec( oBrwDiv, bEdtVta, dbfTmpVta, , , aTmp ) )

   REDEFINE BUTTON aBtnDiv[ 2 ];
			ID 		501 ;
         OF       fldPropiedades;
         WHEN     ( !Empty( aTmp[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ] ) .and. nMode != ZOOM_MODE );
         ACTION   ( WinEdtRec( oBrwDiv, bEdtVta, dbfTmpVta, , , aTmp ) )

   REDEFINE BUTTON aBtnDiv[ 3 ];
			ID 		502 ;
         OF       fldPropiedades;
         WHEN     ( !Empty( aTmp[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ] ) .and. nMode != ZOOM_MODE );
         ACTION   ( dbDelRec( oBrwDiv, dbfTmpVta ) )

   /*
   Quinta caja de dialogo______________________________________________________
   */

   REDEFINE BITMAP oBmpLogistica ;
         ID       500 ;
         RESOURCE "Truck_Red_Alpha_48" ;
         TRANSPARENT ;
         OF       fldLogistica

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "cCodFra" ) ) ] ;
      VAR      aTmp[ ( dbfArticulo )->( fieldpos( "cCodFra" ) ) ] ;
      ID       420 ;
      IDTEXT   425 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      BITMAP   "LUPA" ;
      OF       fldLogistica

      aGet[ ( dbfArticulo )->( fieldpos( "cCodFra" ) ) ]:bValid := {|| ( aGet[ ( dbfArticulo )->( fieldpos( "cCodFra" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfArticulo )->( fieldpos( "cCodFra" ) ) ], oFraPub:GetAlias() ) ), .t. ) }
      aGet[ ( dbfArticulo )->( fieldpos( "cCodFra" ) ) ]:bHelp  := {|| oFraPub:Buscar( aGet[ ( dbfArticulo )->( fieldpos( "cCodFra" ) ) ] ) }

   /*
   Código de la sección-----------------------------------------------------
   */

   REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "cCodSec" ) ) ] ;
      VAR      aTmp[ ( dbfArticulo )->( fieldpos( "cCodSec" ) ) ] ;
      ID       430 ;
      IDTEXT   431 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      BITMAP   "LUPA" ;
      OF       fldLogistica

      aGet[ ( dbfArticulo )->( fieldpos( "cCodSec" ) ) ]:bValid   := {|| oSeccion:Existe( aGet[ ( dbfArticulo )->( fieldpos( "cCodSec" ) ) ], aGet[ ( dbfArticulo )->( fieldpos( "cCodSec" ) ) ]:oHelpText, "cDesSec", .t., .t., "0" ) }
      aGet[ ( dbfArticulo )->( fieldpos( "cCodSec" ) ) ]:bHelp    := {|| oSeccion:Buscar( aGet[ ( dbfArticulo )->( fieldpos( "cCodSec" ) ) ] ) }

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "NCAJENT" ) ) ] ;
      ID       180 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aTmp[ ( dbfArticulo )->( fieldpos( "NUNICAJA" ) ) ] ;
      ID       190 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "CUNIDAD" ) ) ] ;
      VAR      aTmp[ ( dbfArticulo )->( fieldpos( "CUNIDAD" ) ) ] ;
      ID       110 ;
      IDTEXT   254 ;
      PICTURE  "@!" ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      VALID    ( oUndMedicion:Existe( aGet[ ( dbfArticulo )->( fieldpos( "CUNIDAD" ) ) ], aGet[ ( dbfArticulo )->( fieldpos( "CUNIDAD" ) ) ]:oHelpText, "cNombre" ), lValidUndMedicion( aTmp, aGet ) ) ;
      ON HELP  ( oUndMedicion:Buscar( aGet[ ( dbfArticulo )->( fieldpos( "CUNIDAD" ) ) ] ) ) ;
      BITMAP   "LUPA" ;
      OF       fldLogistica

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "NLNGART" ) ) ] ;
      VAR      aTmp[ ( dbfArticulo )->( fieldpos( "NLNGART" ) ) ] ;
      ID       140 ;
      IDSAY    141 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  MasUnd() ;
      OF       fldLogistica

   REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "NALTART" ) ) ] ;
      VAR      aTmp[( dbfArticulo )->( fieldpos( "NALTART" ) ) ] ;
      ID       150 ;
      IDSAY    151 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  MasUnd() ;
      OF       fldLogistica

   REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "NANCART" ) ) ] ;
      VAR      aTmp[( dbfArticulo )->( fieldpos( "NANCART" ) ) ] ;
      ID       160 ;
      IDSAY    161 ;
      SPINNER ;
      WHEN    ( nMode != ZOOM_MODE ) ;
      PICTURE  MasUnd() ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "NPESOKG" ) ) ] ;
      ID       100 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  "@E 999,999.999999";
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "CUNDDIM" ) ) ] ;
      ID       170 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "NVOLUMEN" ) ) ] ;
      ID       120 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  "@E 999,999.999999";
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "CVOLUMEN" ) ) ] ;
      ID       130 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldLogistica

   /*
   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "NIMPPES" ) ) ] ;
      ID       290 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPouDiv ;
      COLOR    CLR_GET ;
      OF       fldLogistica */

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "NLNGCAJ" ) ) ] ;
      ID       300 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "CUNDCAJ" ) ) ] ;
      ID       310 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "NALTCAJ" ) ) ] ;
      ID       320 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "NANCCAJ" ) ) ] ;
      ID       330 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "NPESCAJ" ) ) ] ;
      ID       340 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "CCAJPES" ) ) ] ;
      ID       350 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "NVOLCAJ" ) ) ] ;
      ID       360 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "CCAJVOL" ) ) ] ;
      ID       370 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "NCAJPLT" ) ) ] ;
      ID       380 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      COLOR    CLR_GET ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "NBASPLT" ) ) ] ;
      ID       390 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      COLOR    CLR_GET ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "NALTPLT" ) ) ] ;
      ID       400 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      COLOR    CLR_GET ;
      OF       fldLogistica

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "CUNDPLT" ) ) ] ;
      ID       410 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldLogistica

   /*
	Tercera Caja de Dialogo del Folder
	---------------------------------------------------------------------------
	*/

   REDEFINE BITMAP oBmpStocks ;
         ID       500 ;
         RESOURCE "Package_Alpha_48" ;
         TRANSPARENT ;
         OF       fldStocks

   REDEFINE RADIO aTmp[ ( dbfArticulo )->( fieldpos( "NCTLSTOCK" ) ) ] ;
         ID       101, 102, 103 ;
         ON CHANGE( if( aTmp[ ( dbfArticulo )->( fieldpos( "NCTLSTOCK" ) ) ] != 1, oBrwStk:Hide(), oBrwStk:Show() ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldStocks

   REDEFINE GET aTmp[ ( dbfArticulo )->( fieldpos( "NMINIMO" ) ) ] ;
         ID       110 ;
         SPINNER  MIN 0 ;
         WHEN     ( aTmp[( dbfArticulo )->( fieldpos( "NCTLSTOCK" ) ) ] <= 1 .AND. nMode != ZOOM_MODE ) ;
         VALID    aTmp[( dbfArticulo )->( fieldpos( "NMINIMO" ) ) ] >= 0 ;
         PICTURE  cPicUnd ;
			COLOR 	CLR_GET ;
         OF       fldStocks

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "nMaximo" ) ) ] ;
         ID       115 ;
         SPINNER  MIN 0 ;
         WHEN     ( aTmp[( dbfArticulo )->( fieldpos( "NCTLSTOCK" ) ) ] <= 1 .AND. nMode != ZOOM_MODE ) ;
         VALID    aTmp[( dbfArticulo )->( fieldpos( "nMaximo" ) ) ] >= 0 ;
         PICTURE  cPicUnd ;
			COLOR 	CLR_GET ;
         OF       fldStocks

   REDEFINE GET aTmp[ ( dbfArticulo )->( fieldpos( "NCNTACT" ) ) ] ;
         ID       120 ;
			SPINNER 	MIN 1 ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "NCTLSTOCK" ) ) ] == 2 .AND. nMode != ZOOM_MODE ) ;
         VALID    aTmp[ ( dbfArticulo )->( fieldpos( "NCNTACT" ) ) ] >= 0 ;
         PICTURE  "@E 999,999,999,999" ;
			COLOR 	CLR_GET ;
         OF       fldStocks

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "LMSGMOV" ) ) ] ;
         ID       127 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldStocks

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "LMSGVTA" ) ) ] ;
         ID       126 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldStocks

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "LMSGSER" ) ) ] ;
         ID       128 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldStocks

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "LNOTVTA" ) ) ] ;
         ID       125 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldStocks

   /*
   Stock-----------------------------------------------------------------------
   */

   oBrwStk                 := IXBrowse():New( fldStocks )

   oBrwStk:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwStk:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwStk:lFooter         := .t.
   oBrwStk:lHScroll        := .f.
   oBrwStk:lRecordSelector := .f.
   oBrwStk:nMarqueeStyle   := 5
   oBrwStk:cName           := "Artículo.Stocks"

   oBrwStk:bRClicked       := {| nRow, nCol, nFlags | oBrwStk:RButtonDown( nRow, nCol, nFlags ) }

   oBrwStk:SetArray( oStock:aStocks, , , .f. )

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Código"
         :nWidth              := 40
         :bStrData            := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cCodigoAlmacen, "" ) }
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Almacén"
         :nWidth              := 120
         :bStrData            := {|| if( !Empty( oBrwStk:aArrayData ), RetAlmacen( oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cCodigoAlmacen, dbfAlmT ), "" ) }
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Prop. 1"
         :nWidth              := 120
         :bStrData            := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cValorPropiedad1, "" ) }
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Prop. 2"
         :nWidth              := 120
         :bStrData            := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cValorPropiedad2, "" ) }
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Lote"
         :nWidth              := 60
         :bStrData            := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cLote, "" ) }
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Num. serie"
         :nWidth              := 60
         :bStrData            := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cNumeroSerie, "" ) }
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Unidades"
         :nWidth              := 80
         :bEditValue          := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:nUnidades, 0 ) }
         :bFooter             := {|| nStockUnidades( oBrwStk ) }
         :cEditPicture        := MasUnd()
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Pdt. recibir"
         :bEditValue          := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:nPendientesRecibir, 0 ) }
         :bFooter             := {|| nStockPendiente( oBrwStk ) }
         :nWidth              := 70
         :cEditPicture        := cPicUnd
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
         :lHide               := .t.
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Pdt. entregar"
         :bEditValue          := {|| if( !Empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:nPendientesEntregar, 0 ) }
         :bFooter             := {|| nStockEntregar( oBrwStk ) }
         :nWidth              := 70
         :cEditPicture        := cPicUnd
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
         :lHide               := .t.
      end with

   oBrwStk:CreateFromResource( 130 )

   REDEFINE GET aGet[( dbfArticulo )->( fieldpos( "CCODTNK" ) ) ] VAR aTmp[( dbfArticulo )->( fieldpos( "CCODTNK" ) ) ] ;
         ID       150 ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "NCTLSTOCK" ) ) ] == 2 .AND. nMode != ZOOM_MODE ) ;
         VALID    ( oTankes:Existe( aGet[ ( dbfArticulo )->( fieldpos( "CCODTNK" ) ) ], oSay[ 8 ], "cNomTnk", .t., .t., "0" ) );
         ON HELP  ( oTankes:Buscar( aGet[ ( dbfArticulo )->( fieldpos( "CCODTNK" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
         OF       fldStocks

   REDEFINE GET oSay[8] VAR cSay[8] ;
         ID       160 ;
			SPINNER ;
         WHEN     ( .f. ) ;
         COLOR    CLR_GET ;
         OF       fldStocks

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "LCOMBUS" ) ) ] ;
         ID       170 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       fldStocks

   /*
   Caja de dialogo para contabilidad-------------------------------------------
   */

   REDEFINE BITMAP oBmpContabilidad ;
         ID       500 ;
         RESOURCE "Folder2_red_Alpha_48" ;
         TRANSPARENT ;
         OF       fldContabilidad

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "GRPVENT" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "GRPVENT" ) ) ] ;
         ID       100 ;
			COLOR 	CLR_GET ;
         PICTURE  ( Replicate( "9", 9 ) )  ;
         WHEN     ( !empty( cRutCnt() ) .and. nMode != ZOOM_MODE ) ;
         VALID    ( cGrpVenta( aGet[ ( dbfArticulo )->( fieldpos( "GRPVENT" ) ) ], , oSay[1] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwGrpVenta( aGet[ ( dbfArticulo )->( fieldpos( "GRPVENT" ) ) ], , oSay[1] ) );
         OF       fldContabilidad

   REDEFINE GET   oSay[1] ;
         VAR      cSay[1] ;
			WHEN 		.F. ;
         ID       101 ;
			COLOR 	CLR_GET ;
         OF       fldContabilidad

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "CCTAVTA" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "CCTAVTA" ) ) ] ;
         ID       110 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .and. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ ( dbfArticulo )->( fieldpos( "CCTAVTA" ) ) ], oGetSubCta ) ) ;
         VALID    ( lValidaSubcuenta( aGet, aTmp, @nGetDebe, @nGetHaber, oGetSaldo, oGetSubCta, cSubCtaAnt, oBrwCtaVta, dbfTmpSubCta ) );
         OF       fldContabilidad

   REDEFINE GET   oGetSubCta ;
         VAR      cGetSubCta ;
         ID       111 ;
         WHEN     .f. ;
         OF       fldContabilidad

   REDEFINE GET oGetSaldo VAR nGetSaldo ;
         ID       112 ;
         PICTURE  cPorDiv ;
         WHEN     .f. ;
         OF       fldContabilidad

   /*
   Subcuenta de venta----------------------------------------------------------
   */

   oBrwCtaVta                 := IXBrowse():New( fldContabilidad )

   oBrwCtaVta:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwCtaVta:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwCtaVta:lFooter         := .t.

   oBrwCtaVta:cAlias          := dbfTmpSubCta

   oBrwCtaVta:nMarqueeStyle   := 5
   oBrwCtaVta:cName           := "Artículo.Contabilidad cuenta de ventas"

   with object ( oBrwCtaVta:AddCol() )
      :cHeader          := "Asiento"
      :bEditValue       := {|| Trans( ( dbfTmpSubCta )->nAsiento, "9999999" ) }
      :nWidth           := 40
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :nFootStrAlign    := AL_RIGHT
   end with

   with object ( oBrwCtaVta:AddCol() )
      :cHeader          := "Fecha"
      :bEditValue       := {|| Dtoc( ( dbfTmpSubCta )->dFecha ) }
      :nWidth           := 80
   end with

   with object ( oBrwCtaVta:AddCol() )
      :cHeader          := "Concepto"
      :bEditValue       := {|| ( dbfTmpSubCta )->cConcepto }
      :nWidth           := 180
   end with

   with object ( oBrwCtaVta:AddCol() )
      :cHeader          := "Debe"
      :bEditValue       := {|| ( dbfTmpSubCta )->nDebe }
      :bFooter          := {|| nGetDebe }
      :nWidth           := 80
      :cEditPicture     := cPorDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :nFootStrAlign    := AL_RIGHT
   end with

   with object ( oBrwCtaVta:AddCol() )
      :cHeader          := "Haber"
      :bEditValue       := {|| ( dbfTmpSubCta )->nHaber }
      :bFooter          := {|| nGetHaber }
      :nWidth           := 80
      :cEditPicture     := cPorDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :nFootStrAlign    := AL_RIGHT
   end with

   with object ( oBrwCtaVta:AddCol() )
      :cHeader          := "Concepto"
      :bEditValue       := {|| ( dbfTmpSubCta )->cDeparta }
      :nWidth           := 80
   end with

   with object ( oBrwCtaVta:AddCol() )
      :cHeader          := "Factura"
      :bEditValue       := {|| Trans( ( dbfTmpSubCta )->nFactura, "9999999" ) }
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :nFootStrAlign    := AL_RIGHT
   end with

   with object ( oBrwCtaVta:AddCol() )
      :cHeader          := "Base"
      :bEditValue       := {|| ( dbfTmpSubCta )->nBase }
      :nWidth           := 80
      :cEditPicture     := cPorDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :nFootStrAlign    := AL_RIGHT
   end with

   with object ( oBrwCtaVta:AddCol() )
      :cHeader          := cImp()
      :bEditValue       := {|| ( dbfTmpSubCta )->nIva }
      :nWidth           := 80
      :cEditPicture     := cPorDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :nFootStrAlign    := AL_RIGHT
   end with

   oBrwCtaVta:bRClicked    := {| nRow, nCol, nFlags | oBrwCtaVta:RButtonDown( nRow, nCol, nFlags ) }

   oBrwCtaVta:CreateFromResource( 120 )

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "CCTACOM" ) ) ];
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "CCTACOM" ) ) ] ;
         ID       130 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ ( dbfArticulo )->( fieldpos( "CCTACOM" ) ) ], oGetCtaCom ) ) ;
         VALID    ( lValidaSubcuentaCompras( aGet, aTmp, @nDebCom, @nHabCom, oGetSalCom, oGetCtaCom, cSubCtaAntCom, oBrwCtaCom, dbfTmpSubCom ) );
         OF       fldContabilidad

   REDEFINE GET oGetCtaCom VAR cGetCtaCom ;
         ID       131 ;
         WHEN     .f. ;
         OF       fldContabilidad

   REDEFINE GET oGetSalCom VAR nGetSalCom ;
         ID       132 ;
         PICTURE  cPorDiv ;
         WHEN     .f. ;
         OF       fldContabilidad

   oBrwCtaCom                 := IXBrowse():New( fldContabilidad )

   oBrwCtaCom:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwCtaCom:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwCtaCom:lFooter         := .t.
   oBrwCtaCom:cAlias          := dbfTmpSubCom
   oBrwCtaCom:nMarqueeStyle   := 5
   oBrwCtaCom:cName           := "Artículo.Contabilidad cuenta de compras"

   with object ( oBrwCtaCom:AddCol() )
      :cHeader          := "Asiento"
      :bEditValue       := {|| Trans( ( dbfTmpSubCom )->nAsiento, "9999999" ) }
      :nWidth           := 40
   end with

   with object ( oBrwCtaCom:AddCol() )
      :cHeader          := "Fecha"
      :bEditValue       := {|| Dtoc( ( dbfTmpSubCom )->dFecha ) }
      :nWidth           := 80
   end with

   with object ( oBrwCtaCom:AddCol() )
      :cHeader          := "Concepto"
      :bEditValue       := {|| ( dbfTmpSubCom )->cConcepto }
      :nWidth           := 180
   end with

   with object ( oBrwCtaCom:AddCol() )
      :cHeader          := "Debe"
      :bEditValue       := {|| ( dbfTmpSubCom )->nDebe }
      :bFooter          := {|| nDebCom }
      :nWidth           := 80
      :cEditPicture     := cPorDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :nFootStrAlign    := AL_RIGHT
   end with

   with object ( oBrwCtaCom:AddCol() )
      :cHeader          := "Haber"
      :bEditValue       := {|| ( dbfTmpSubCom )->nHaber }
      :bFooter          := {|| nHabCom }
      :nWidth           := 80
      :cEditPicture     := cPorDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :nFootStrAlign    := AL_RIGHT
   end with

   with object ( oBrwCtaCom:AddCol() )
      :cHeader          := "Concepto"
      :bEditValue       := {|| ( dbfTmpSubCom )->cDeparta }
      :nWidth           := 80
   end with

   with object ( oBrwCtaCom:AddCol() )
      :cHeader          := "Factura"
      :bEditValue       := {|| Trans( ( dbfTmpSubCom )->nFactura, "9999999" ) }
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwCtaCom:AddCol() )
      :cHeader          := "Base"
      :bEditValue       := {|| ( dbfTmpSubCom )->nBase }
      :nWidth           := 80
      :cEditPicture     := cPorDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :nFootStrAlign    := AL_RIGHT
   end with

   with object ( oBrwCtaCom:AddCol() )
      :cHeader          := cImp()
      :bEditValue       := {|| ( dbfTmpSubCom )->nIva }
      :nWidth           := 80
      :cEditPicture     := cPorDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :nFootStrAlign    := AL_RIGHT
   end with

   oBrwCtaCom:bRClicked    := {| nRow, nCol, nFlags | oBrwCtaCom:RButtonDown( nRow, nCol, nFlags ) }

   oBrwCtaCom:CreateFromResource( 140 )

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "CCTATRN" ) ) ];
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "CCTATRN" ) ) ] ;
         ID       150 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ ( dbfArticulo )->( fieldpos( "CCTATRN" ) ) ], oGetCtaTrn ) ) ;
         VALID    ( MkSubcuenta( aGet[ ( dbfArticulo )->( fieldpos( "CCTATRN" ) ) ],;
                              {  aTmp[ ( dbfArticulo )->( fieldpos( "CCTATRN" ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "NOMBRE"  ) ) ] },;
                              oGetCtaTrn,;
                              nil,;
                              nil,;
                              nil,;
                              nil,;
                              oGetSalTrn ) );
         OF       fldContabilidad

   REDEFINE GET oGetCtaTrn VAR cGetCtaTrn ;
         ID       151 ;
         WHEN     .f. ;
         OF       fldContabilidad

   REDEFINE GET oGetSalTrn VAR nGetSalTrn ;
         ID       152 ;
         PICTURE  cPorDiv ;
         WHEN     .f. ;
         OF       fldContabilidad

	/*
	Cuarta Caja de Dialogo del Folder
	---------------------------------------------------------------------------
   */

   REDEFINE BITMAP oBmpOfertas ;
         ID       510 ;
         RESOURCE "Star2_Red_Alpha_48" ;
         TRANSPARENT ;
         OF       fldOfertas

   oBrwOfe                 := IXBrowse():New( fldOfertas )

   oBrwOfe:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwOfe:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwOfe:cAlias          := dbfTmpOfe
   oBrwOfe:nMarqueeStyle   := 5
   oBrwOfe:cName           := "Artículo.Ofertas"

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Oferta"
      :bEditValue       := {|| ( dbfTmpOfe )->cDesOfe }
      :nWidth           := 140
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Inicio"
      :bEditValue       := {|| Dtoc( ( dbfTmpOfe )->dIniOfe ) }
      :nWidth           := 80
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Fin"
      :bEditValue       := {|| Dtoc( ( dbfTmpOfe )->dFinOfe ) }
      :nWidth           := 80
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Precio 1"
      :bEditValue       := {|| ( dbfTmpOfe )->nPreOfe1 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Precio 1 " + cImp()
      :bEditValue       := {|| ( dbfTmpOfe )->nPreIva1 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Precio 2"
      :bEditValue       := {|| ( dbfTmpOfe )->nPreOfe2 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Precio 2 " + cImp()
      :bEditValue       := {|| ( dbfTmpOfe )->nPreIva2 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Precio 3"
      :bEditValue       := {|| ( dbfTmpOfe )->nPreOfe3 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Precio 3 " + cImp()
      :bEditValue       := {|| ( dbfTmpOfe )->nPreIva3 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Precio 4"
      :bEditValue       := {|| ( dbfTmpOfe )->nPreOfe4 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Precio 4 " + cImp()
      :bEditValue       := {|| ( dbfTmpOfe )->nPreIva4 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Precio 5"
      :bEditValue       := {|| ( dbfTmpOfe )->nPreOfe5 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Precio 5 " + cImp()
      :bEditValue       := {|| ( dbfTmpOfe )->nPreIva5 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Precio 6"
      :bEditValue       := {|| ( dbfTmpOfe )->nPreOfe6 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Precio 6 " + cImp()
      :bEditValue       := {|| ( dbfTmpOfe )->nPreIva6 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Unidades"
      :bEditValue       := {|| ( dbfTmpOfe )->nMaxOfe }
      :nWidth           := 60
      :cEditPicture     := "@E 999,999"
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := "Tipo"
      :bEditValue       := {|| Trans( ( dbfTmpOfe )->nUnvOfe, "@E 999" ) + " x " + Trans( ( dbfTmpOfe )->nUncOfe, "@E 999" ) }
      :nWidth           := 40
   end with

   if nMode != ZOOM_MODE
      oBrwOfe:bLDblClick  := {|| EdtOfeArt( aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ], oBrwOfe, dbfTmpOfe ) }
   end if

   oBrwOfe:bRClicked    := {| nRow, nCol, nFlags | oBrwOfe:RButtonDown( nRow, nCol, nFlags ) }

   oBrwOfe:CreateFromResource( 100 )

   REDEFINE BUTTON aBtn[8] ;
			ID 		500 ;
         OF       fldOfertas;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( AppOfeArt( aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ], oBrwOfe, dbfTmpOfe ) )

   REDEFINE BUTTON aBtn[9] ;
			ID 		501 ;
         OF       fldOfertas;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EdtOfeArt( aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ], oBrwOfe, dbfTmpOfe ) )

   REDEFINE BUTTON aBtn[10] ;
			ID 		502 ;
         OF       fldOfertas;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DelOfeArt( aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ], oBrwOfe, dbfTmpOfe ) )

	/*
	Sexta Caja de Dialogo del Folder
	---------------------------------------------------------------------------
   */

   REDEFINE BITMAP oBmpEscandallos ;
         ID       510 ;
         RESOURCE "Components_Alpha_48" ;
         TRANSPARENT ;
         OF       fldEscandallos

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "lKitArt" ) ) ];
			ID 		136 ;
         ON CHANGE( ChgKit( aTmp, aGet, oCosto ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldEscandallos

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "lKitAsc" ) ) ];
         ID       135 ;
         ON CHANGE(  ChgKit( aTmp, aGet, oCosto ),;
                     if( aTmp[ ( dbfArticulo )->( fieldpos( "lKitAsc" ) ) ],;
                        (  aGet[ ( dbfArticulo )->( fieldpos( "nKitImp" ) ) ]:Set( 1 ),;
                           aGet[ ( dbfArticulo )->( fieldpos( "nKitStk" ) ) ]:Set( 1 ),;
                           aGet[ ( dbfArticulo )->( fieldpos( "nKitPrc" ) ) ]:Set( 1 ) ), ) ) ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "lKitArt" ) ) ] .and. nMode != ZOOM_MODE ) ;
         OF       fldEscandallos

   REDEFINE COMBOBOX aGet[ ( dbfArticulo )->( fieldpos( "nKitImp" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nKitImp" ) ) ] ;
         ITEMS    { "Todos", "Compuesto", "Componentes" };
         ID       137 ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "lKitArt" ) ) ] .and. !aTmp[ ( dbfArticulo )->( fieldpos( "lKitAsc" ) ) ] .and. nMode != ZOOM_MODE ) ;
         OF       fldEscandallos

   REDEFINE COMBOBOX aGet[ ( dbfArticulo )->( fieldpos( "nKitStk" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nKitStk" ) ) ] ;
         ITEMS    { "Todos", "Compuesto", "Componentes" };
         ID       138 ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "lKitArt" ) ) ] .and. !aTmp[ ( dbfArticulo )->( fieldpos( "lKitAsc" ) ) ] .and. nMode != ZOOM_MODE ) ;
         OF       fldEscandallos

   REDEFINE COMBOBOX aGet[ ( dbfArticulo )->( fieldpos( "nKitPrc" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nKitPrc" ) ) ] ;
         ITEMS    { "Todos", "Compuesto", "Componentes" };
         ID       139 ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "lKitArt" ) ) ] .and. !aTmp[ ( dbfArticulo )->( fieldpos( "lKitAsc" ) ) ].and. nMode != ZOOM_MODE ) ;
         OF       fldEscandallos

   REDEFINE BUTTON aBtn[11] ;
			ID 		500 ;
         OF       fldEscandallos;
         WHEN     ( nMode != ZOOM_MODE .AND. aTmp[ ( dbfArticulo )->( fieldpos( "LKITART" ) ) ] ) ;
         ACTION   ( WinAppRec( oBrwKit, bEdtKit, dbfTmpKit, , , aTmp ),  Eval( oBrwKit:bValid ) )

   REDEFINE BUTTON aBtn[12] ;
			ID 		501 ;
         OF       fldEscandallos;
         WHEN     ( nMode != ZOOM_MODE .AND. aTmp[ ( dbfArticulo )->( fieldpos( "LKITART" ) ) ] ) ;
         ACTION   ( WinEdtRec( oBrwKit, bEdtKit, dbfTmpKit, , , aTmp ),  Eval( oBrwKit:bValid ) )

   REDEFINE BUTTON aBtn[13] ;
			ID 		502 ;
         OF       fldEscandallos;
         WHEN     ( nMode != ZOOM_MODE .AND. aTmp[ ( dbfArticulo )->( fieldpos( "LKITART" ) ) ] ) ;
         ACTION   ( dbDelRec( oBrwKit, dbfTmpKit ), Eval( oBrwKit:bValid ) )

   REDEFINE BUTTON oBtnMoneda;
         ID       503 ;
         OF       fldEscandallos;
         WHEN     ( nMode != ZOOM_MODE .AND. aTmp[ ( dbfArticulo )->( fieldpos( "LKITART" ) ) ] ) ;
         ACTION   (  if( cDivUse == cDivEmp(), cDivUse := cDivChg(), cDivUse := cDivEmp() ), oBrwKit:Refresh() )

   REDEFINE BUTTON ;
         ID       504 ;
         OF       fldEscandallos;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( dbfArticulo )->( fieldpos( "LKITART" ) ) ] ) ;
         ACTION   ( dbSwapUp( dbfTmpKit, oBrwKit ) )

   REDEFINE BUTTON ;
         ID       505 ;
         OF       fldEscandallos;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( dbfArticulo )->( fieldpos( "LKITART" ) ) ] ) ;
         ACTION   ( dbSwapDown( dbfTmpKit, oBrwKit ) )

   oBrwKit                 := IXBrowse():New( fldEscandallos )

   oBrwKit:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwKit:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwKit:lFooter         := .t.
   oBrwKit:cAlias          := dbfTmpKit
   oBrwKit:nMarqueeStyle   := 5
   oBrwKit:cName           := "Artículo.Kits"

   with object ( oBrwKit:AddCol() )
      :cHeader          := "Código"
      :bEditValue       := {|| ( dbfTmpKit )->cRefKit }
      :nWidth           := 80
   end with

   with object ( oBrwKit:AddCol() )
      :cHeader          := "Artículo"
      :bEditValue       := {|| ( dbfTmpKit )->cDesKit }
      :nWidth           := 160
   end with

   with object ( oBrwKit:AddCol() )
      :cHeader          := "Unidades"
      :bEditValue       := {|| ( dbfTmpKit )->nUndKit }
      :nWidth           := 70
      :cEditPicture     := "@E 999,999.999999"
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwKit:AddCol() )
      :cHeader          := "Ud"
      :bEditValue       := {|| Upper( ( dbfTmpKit )->cUnidad ) }
      :nWidth           := 30
   end with

   with object ( oBrwKit:AddCol() )
      :cHeader          := "Factor"
      :bEditValue       := {|| nFactorConversion( ( dbfTmpKit )->cRefKit, dbfArticulo ) }
      :nWidth           := 70
      :cEditPicture     := "@E 999,999.999999"
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwKit:AddCol() )
      :cHeader          := "Costo"
      :bEditValue       := {|| nCosto( ( dbfTmpKit )->cRefKit, dbfArticulo, dbfArtKit, .f., cDivUse, dbfDiv ) }
      :cEditPicture     := cPinDiv( cDivEmp(), dbfDiv )
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwKit:AddCol() )
      :cHeader          := "Total"
      :bEditValue       := {|| nCosto( ( dbfTmpKit )->cRefKit, dbfArticulo, dbfArtKit, .f., cDivUse, dbfDiv ) * ( dbfTmpKit )->nUndKit * nFactorConversion( ( dbfTmpKit )->cRefKit, dbfArticulo ) } // 
      :bFooter          := {|| nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit, .t., cDivUse, dbfDiv ) }
      :cEditPicture     := cPinDiv( cDivEmp(), dbfDiv )
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :nFootStrAlign    := AL_RIGHT
   end with

   with object ( oBrwKit:AddCol() )
      :cHeader          := "Div"
      :bEditValue       := {|| cSimDiv( cDivUse, dbfDiv ) }
      :nWidth           := 30
   end with

   if nMode != ZOOM_MODE
      oBrwKit:bLDblClick  := {|| WinEdtRec( oBrwKit, bEdtKit, dbfTmpKit, , , aTmp ),  Eval( oBrwKit:bValid ) }
   end if

      oBrwKit:bValid      := {|| oCosto:Refresh(),;
                                 aGet[ ( dbfArticulo )->( fieldpos( "Benef1" ) ) ]:lValid(),;
                                 aGet[ ( dbfArticulo )->( fieldpos( "Benef2" ) ) ]:lValid(),;
                                 aGet[ ( dbfArticulo )->( fieldpos( "Benef3" ) ) ]:lValid(),;
                                 aGet[ ( dbfArticulo )->( fieldpos( "Benef4" ) ) ]:lValid(),;
                                 aGet[ ( dbfArticulo )->( fieldpos( "Benef5" ) ) ]:lValid(),;
                                 aGet[ ( dbfArticulo )->( fieldpos( "Benef6" ) ) ]:lValid() }

   oBrwKit:bRClicked       := {| nRow, nCol, nFlags | oBrwKit:RButtonDown( nRow, nCol, nFlags ) }

   oBrwKit:CreateFromResource( 180 )

   /*
   Septima caja de dialogo del folder  "Caja web"
   ----------------------------------------------------------------------------
   */

   REDEFINE BITMAP oBmpWeb ;
         ID       500 ;
         RESOURCE "Earth2_Alpha_48" ;
         TRANSPARENT ;
         OF       fldWeb

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "LPUBINT" ) ) ] ;
         ID       100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( ChangePublicar( aTmp ) ) ;
         OF       fldWeb

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "pVtaWeb" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pVtaWeb" ) ) ] ;
         ID       120 ;
         WHEN     ( .f. );
         PICTURE  cPouDiv ;
         OF       fldWeb

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "nDtoInt1" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nDtoInt1" ) ) ] ;
         ID       121 ;
         PICTURE  "@E 999.99" ;
         SPINNER  MIN 0 MAX 100;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "lPubInt" ) ) ] .and. aTmp[ ( dbfArticulo )->( fieldpos( "lSbrInt" ) ) ] .and. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalDtoWeb(   aTmp[ ( dbfArticulo )->( fieldpos( "pVtaWeb"  ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva"  ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "nDtoInt1" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "nImpInt1" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "nImpIva1" ) ) ],;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lSbrInt" ) ) ] ) );
         OF       fldWeb

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "nImpInt1" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nImpInt1" ) ) ] ;
         ID       122 ;
         WHEN     ( !aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ] .and. aTmp[ ( dbfArticulo )->( fieldpos( "lPubInt" ) ) ] .and. nMode != ZOOM_MODE ) ;
         VALID    ( CalBnfPts(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "nImpInt1") ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "nImpIva1") ) ],;
                                 nDwbDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPwbDiv ;
         OF       fldWeb

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "nImpIva1" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nImpIva1" ) ) ] ;
         ID       123 ;
         WHEN     ( aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ] .and. aTmp[ ( dbfArticulo )->( fieldpos( "lPubInt" ) ) ] .and. nMode != ZOOM_MODE ) ;
         VALID    ( CalBnfIva(   .f.,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ],;
                                 0,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "nImpIva1") ) ],;
                                 nil,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfArticulo )->( fieldpos( "nImpInt1") ) ],;
                                 nDwbDiv,;
                                 aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPwbDiv ;
         OF       fldWeb


   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "LSBRINT" ) ) ] ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldWeb

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "nTarWeb" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "nTarWeb" ) ) ] ;
         ID       150 ;
         PICTURE  "9" ;
         SPINNER ;
         MIN      1 ;
         MAX      6 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( dbfArticulo )->( fieldpos( "LSBRINT" ) ) ] );
         VALID    ( ( aTmp[ ( dbfArticulo )->( fieldpos( "nTarWeb" ) ) ] >= 1 .and. aTmp[ ( dbfArticulo )->( fieldpos( "nTarWeb" ) ) ] <= 6 ), ChangeTarWeb( aGet, aTmp ) );
         OF       fldWeb

   aGet[ ( dbfArticulo )->( fieldpos( "nTarWeb" ) ) ]:bChange  := {|| ChangeTarWeb( aGet, aTmp ) }

   REDEFINE GET aTmp[( dbfArticulo )->( fieldpos( "cCodWeb" ) ) ] ;
         ID       210 ;
         WHEN     ( .F. );
         OF       fldWeb

   REDEFINE CHECKBOX aTmp[ ( dbfArticulo )->( fieldpos( "lPubPor" ) ) ] ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldWeb

   REDEFINE GET   aTmp[ ( dbfArticulo )->( fieldpos( "MDESTEC" ) ) ] ;
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         MEMO ;
         OF       fldWeb


   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "cTitSeo" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "cTitSeo" ) ) ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       fldWeb     

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "cDesSeo" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "cDesSeo" ) ) ] ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       fldWeb       

   REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "cKeySeo" ) ) ] ;
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "cKeySeo" ) ) ] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       fldWeb      

   /*
   Cuarta Caja de Dialogo del Folder
   ----------------------------------------------------------------------------
   */

   REDEFINE BITMAP oBmpImagenes ;
         ID       510 ;
         RESOURCE "Photo_landscape2_48_alpha" ;
         TRANSPARENT ;
         OF       fldImagenes

   REDEFINE BUTTON ;
         ID       500 ;
         OF       fldImagenes;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwImg, bEdtImg, dbfTmpImg, aTmp ) )

   REDEFINE BUTTON ;
         ID       501 ;
         OF       fldImagenes;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwImg, bEdtImg, dbfTmpImg, aTmp ) )

   REDEFINE BUTTON ;
         ID       502 ;
         OF       fldImagenes;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinDelRec( oBrwImg, dbfTmpImg ), lChangeImage := .t. )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldImagenes;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbSwapUp( dbfTmpImg, oBrwImg ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       fldImagenes;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbSwapDown( dbfTmpImg, oBrwImg ) )

      REDEFINE BUTTON ;
         ID       505 ;
         OF       fldImagenes;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ImportaImagenes( aTmp, oBrwImg ) )   

   oBrwImg                 := IXBrowse():New( fldImagenes )

   oBrwImg:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwImg:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwImg:cAlias          := dbfTmpImg
   oBrwImg:nMarqueeStyle   := 6
   oBrwImg:cName           := "Artículo.Imagenes"

   with object ( oBrwImg:AddCol() )
      :cHeader             := "Seleccionada"
      :bStrData            := {|| "" }
      :bEditValue          := {|| ( dbfTmpImg )->lDefImg }
      :nWidth              := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( oBrwImg:AddCol() )
      :cHeader             := "Imagen"
      :bEditValue          := {|| ( dbfTmpImg )->cImgArt }
      :nWidth              := 400
   end with

   with object ( oBrwImg:AddCol() )
      :cHeader             := "Nombre"
      :bEditValue          := {|| ( dbfTmpImg )->cNbrArt }
      :nWidth              := 400
   end with

   if nMode != ZOOM_MODE
      oBrwImg:bLDblClick   := {|| WinEdtRec( oBrwImg, bEdtImg, dbfTmpImg, aTmp ) }
   end if

   oBrwImg:bRClicked       := {| nRow, nCol, nFlags | oBrwImg:RButtonDown( nRow, nCol, nFlags ) }

   oBrwImg:CreateFromResource( 100 )

   /*
	Botones de la Caja de Dialogo
   ----------------------------------------------------------------------------
   */

   REDEFINE BUTTON ;
         ID       3 ;
         OF       oDlg ;
         ACTION   ( if( oFld:nOption > 1, oFld:SetOption( oFld:nOption - 1 ), ) )

   REDEFINE BUTTON ;
         ID       4 ;
         OF       oDlg ;
         ACTION   ( if( oFld:nOption < Len( oFld:aDialogs ), oFld:SetOption( oFld:nOption + 1 ), ) )

   REDEFINE BUTTON oBtnAceptarActualizarWeb;
         ID       5 ;
         OF       oDlg ;
         ACTION   ( EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode, oImpComanda1, oImpComanda2, aImpComanda, .t. ) )

   REDEFINE BUTTON aBtn[ 1 ] ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode, oImpComanda1, oImpComanda2, aImpComanda ) )

	REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE

      fldGeneral:AddFastKey( VK_F2, {|| aBtn[ 2 ]:Click() } )
      fldGeneral:AddFastKey( VK_F3, {|| aBtn[ 3 ]:Click() } )
      fldGeneral:AddFastKey( VK_F4, {|| aBtn[ 4 ]:Click() } )

      fldOfertas:AddFastKey( VK_F2, {|| aBtn[ 8 ]:Click() } )
      fldOfertas:AddFastKey( VK_F3, {|| aBtn[ 9 ]:Click() } )
      fldOfertas:AddFastKey( VK_F4, {|| aBtn[ 10]:Click() } )

      fldEscandallos:AddFastKey( VK_F2, {|| if( aTmp[ ( dbfArticulo )->( fieldpos( "lKitArt" ) ) ], aBtn[ 11 ]:Click(), ) } )
      fldEscandallos:AddFastKey( VK_F3, {|| if( aTmp[ ( dbfArticulo )->( fieldpos( "lKitArt" ) ) ], aBtn[ 12 ]:Click(), ) } )
      fldEscandallos:AddFastKey( VK_F4, {|| if( aTmp[ ( dbfArticulo )->( fieldpos( "lKitArt" ) ) ], aBtn[ 13 ]:Click(), ) } )

      fldImagenes:AddFastKey( VK_F2, {|| WinAppRec( oBrwImg, bEdtImg, dbfTmpImg, aTmp ) } )
      fldImagenes:AddFastKey( VK_F3, {|| WinEdtRec( oBrwImg, bEdtImg, dbfTmpImg, aTmp ) } )
      fldImagenes:AddFastKey( VK_F4, {|| WinDelRec( oBrwImg, dbfTmpImg ) } )

      oDlg:AddFastKey(  VK_F7, {|| if( oFld:nOption > 1, oFld:SetOption( oFld:nOption - 1 ), ) } )
      oDlg:AddFastKey(  VK_F8, {|| if( oFld:nOption < Len( oFld:aDialogs ), oFld:SetOption( oFld:nOption + 1 ), ) } )

      oDlg:AddFastKey(  VK_F5, {|| EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode, oImpComanda1, oImpComanda2, aImpComanda ) } )

      if uFieldEmpresa( "lRealWeb" )
         oDlg:AddFastKey( VK_F6, {|| EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode, oImpComanda1, oImpComanda2, aImpComanda, .t. ) } )
      end if

   end if

   oDlg:bStart    := {|| StartDlg( aGet, aTmp, nMode, oSay, oDlg, oCosto, aBtnDiv, oFnt, oBtnMoneda, aBtn, bmpImage, oBrwPrv, oBrwDiv, oBrwStk, oBrwKit, oBrwOfe, oBrwCtaVta, oBrwCtaCom, oBrwCodeBar, oBrwImg ) }

   ACTIVATE DIALOG oDlg CENTER ;
         ON INIT  (  EdtRecMenu( aTmp, aGet, oSay, oDlg, oFld, aBar, cSay, nMode ) ) ;
         VALID    (  KillTrans( oBrwPrv, oBrwDiv, oBrwStk, oBrwCtaVta, oBrwCtaCom, oBrwOfe, oBrwKit ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir el dialogo de artículos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWait()

   if !Empty( oMenu )
      oMenu:End()
   end if

   if !Empty( oBmpCategoria )
      oBmpCategoria:End()
   end if

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

   if !Empty( oBmpPrecios )
      oBmpPrecios:End()
   end if

   if !Empty( oBmpDescripciones )
      oBmpDescripciones:End()
   end if

   if !Empty( oBmpPropiedades )
      oBmpPropiedades:End()
   end if

   if !Empty( oBmpLogistica )
      oBmpLogistica:End()
   end if

   if !Empty( oBmpStocks )
      oBmpStocks:End()
   end if

   if !Empty( oBmpContabilidad )
      oBmpContabilidad:End()
   end if

   if !Empty( oBmpOfertas )
      oBmpOfertas:End()
   end if

   if !Empty( oBmpEscandallos )
      oBmpEscandallos:End()
   end if

   if !Empty( oBmpWeb )
      oBmpWeb:End()
   end if

   if !Empty( oBmpUbicaciones )
      oBmpUbicaciones:End()
   end if

   if !Empty( oBmpImagenes )
      oBmpImagenes:End()
   end if

   CursorWE()

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

static function CodificacionProveedor( aTmp, aGet, nMode )

   local oDlg
   local oBrwPrv

   DEFINE DIALOG oDlg RESOURCE "ART_PROVEEDOR"

   oBrwPrv                 := IXBrowse():New( oDlg )

   oBrwPrv:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwPrv:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwPrv:cAlias          := dbfTmpPrv

   oBrwPrv:nMarqueeStyle   := 5
   oBrwPrv:cName           := "Precios de compras de articulos"

      with object ( oBrwPrv:AddCol() )
         :cHeader          := "Df. Defecto"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTmpPrv )->lDefPrv }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwPrv:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( dbfTmpPrv )->cCodPrv }
         :nWidth           := 60
      end with

      with object ( oBrwPrv:AddCol() )
         :cHeader          := "Proveedor"
         :bEditValue       := {|| RetProvee( ( dbfTmpPrv )->cCodPrv, dbfProv ) }
         :nWidth           := 145
      end with

      with object ( oBrwPrv:AddCol() )
         :cHeader          := "Referencia"
         :bEditValue       := {|| ( dbfTmpPrv )->cRefPrv }
         :nWidth           := 80
      end with

      with object ( oBrwPrv:AddCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( ( dbfTmpPrv )->cDivPrv, dbfDiv ) }
         :nWidth           := 30
      end with

      if !oUser():lNotCostos()

      with object ( oBrwPrv:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| ( dbfTmpPrv )->nImpPrv }
         :nWidth           := 80
         :cEditPicture     := cPirDiv( cDivEmp(), dbfDiv )
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      end if

      with object ( oBrwPrv:AddCol() )
         :cHeader          := "% Dto."
         :bEditValue       := {|| ( dbfTmpPrv )->nDtoPrv }
         :nWidth           := 40
         :cEditPicture     := "@E 999.99"
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwPrv:AddCol() )
         :cHeader          := "% Prm."
         :bEditValue       := {|| ( dbfTmpPrv )->nDtoPrm }
         :nWidth           := 40
         :cEditPicture     := "@E 999.99"
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      if !oUser():lNotCostos()

      with object ( oBrwPrv:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| nTotImpPrv( dbfTmpPrv, dbfDiv, .t. )}
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      end if

      if nMode != ZOOM_MODE
         oBrwPrv:bLDblClick   := {|| if( !oUser():lNotCostos(), WinEdtRec( oBrwPrv, bEdtDet, dbfTmpPrv, aTmp ), ) }
      end if

      oBrwPrv:CreateFromResource( 100 )

      REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( !oUser():lNotCostos(), WinAppRec( oBrwPrv, bEdtDet, dbfTmpPrv, aTmp ), ) )

      REDEFINE BUTTON ;
			ID 		501 ;
         OF       oDlg;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( !oUser():lNotCostos(), WinEdtRec( oBrwPrv, bEdtDet, dbfTmpPrv, aTmp ), ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oDlg;
         ACTION   ( if( !oUser():lNotCostos(), WinZooRec( oBrwPrv, bEdtDet, dbfTmpPrv, aTmp ), ) )

      REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( DelPrv( aTmp, oBrwPrv, dbfTmpPrv ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oDlg;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ActualizaCostoProveedor( aTmp, aGet, dbfTmpPrv ) )

   REDEFINE BUTTON ;
         ID       550 ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( oDlg:End( IDOK ) )

	REDEFINE BUTTON ;
         ID       560 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F2, {|| if( !oUser():lNotCostos(), WinAppRec( oBrwPrv, bEdtDet, dbfTmpPrv, aTmp ), ) } )
      oDlg:AddFastKey( VK_F3, {|| if( !oUser():lNotCostos(), WinEdtRec( oBrwPrv, bEdtDet, dbfTmpPrv, aTmp ), ) } )
      oDlg:AddFastKey( VK_F4, {|| DelPrv( aTmp, oBrwPrv, dbfTmpPrv ) } )

      oDlg:AddFastKey(  VK_F5, {|| oDlg:End( IDOK ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

return ( nil )

//--------------------------------------------------------------------------//

Static Function ActualizaCostoProveedor( aTmp, aGet, dbfTmpPrv )

   if ApoloMsgNoYes( "¿Desea actualizar el costo del producto?", "Seleccione una opción" )

      aTmp[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ]   := nTotImpPrv( dbfTmpPrv, dbfDiv )

      if !Empty( aGet[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ] )
         aGet[ ( dbfArticulo )->( fieldpos( "pCosto"  ) ) ]:Refresh()
      end if   

   end if    

return ( .t. )

//---------------------------------------------------------------------------//

static function ImportaImagenes( aTmp, oBrwImg ) 

   local aImg
   local aImagenes
   local cImage
   local lDefault       := .f.
   local cDirectorio    := cDirectorioImagenes()
   local cPrefix        := cDirectorio + AllTrim( aTmp[ ( dbfArticulo )->( fieldpos( "codigo" ) ) ] )
   local nOrdAnt        := ( dbfTmpImg )->( OrdSetFocus( "cImgArt" ) )

   /*
   Cogemos las imágenes que hayan en el directorio para este artículo----------
   */

   aImagenes            := Directory( cPrefix + "*.*" )
   
   for each aImg in aImagenes
      
      cImage := Upper( Padr( cDirectorio + aImg[ 1 ], 230 ) )

      /*
      Buscamos para ver si ya está introducida ésta imagen, para que no se repitan
      */

      if !( dbfTmpImg )->( dbSeek( cImage ) )

         ( dbfTmpImg )->( dbAppend() )
         
         ( dbfTmpImg )->cCodArt  := AllTrim( aTmp[ ( dbfArticulo )->( fieldpos( "codigo" ) ) ] )
         ( dbfTmpImg )->cImgArt  := cImage
         ( dbfTmpImg )->cNbrArt  := AllTrim( aTmp[ ( dbfArticulo )->( fieldpos( "nombre" ) ) ] )

         ( dbfTmpImg )->( dbUnLock() )

      end if   

   next

   /*
   Comprobamos si hay alguna imagen por defecto, si no es así marcamos la primera
   */

   lDefault       := .f.

   ( dbfTmpImg )->( dbGoTop() )

   while !( dbfTmpImg )->( Eof() )

      if ( dbfTmpImg )->lDefImg
         lDefault := .t.
      end if

      ( dbfTmpImg )->( dbSkip() )

   end while

   if !lDefault

      ( dbfTmpImg )->( dbGoTop() )         

      if dbLock( dbfTmpImg )
         ( dbfTmpImg )->lDefImg  := .t.
         ( dbfTmpImg )->( dbUnLock() )
      end if 

   end if

   /*
   Volvemos al orden que traiamos----------------------------------------------
   */

   ( dbfTmpImg )->( OrdSetFocus( nOrdAnt ) )

   ( dbfTmpImg )->( dbGoTop() )

   /*
   Refrescamos el browse antes de salir----------------------------------------
   */
   
   if !Empty( oBrwImg )
      oBrwImg:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtRec2( aTmp, aGet, dbfArticulo, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oBtn
   local oSay  := Array( 4 )
   local cSay  := Array( 4 )
   local oValorPunto
   local oValorDto
   local oValorTot

   do case
      case nMode == APPD_MODE
         aTmp[ ( dbfArticulo )->( fieldpos( "Codigo"    ) ) ]  := Space( 18 )
         aTmp[ ( dbfArticulo )->( fieldpos( "nLabel"    ) ) ]  := 1
         aTmp[ ( dbfArticulo )->( fieldpos( "nCtlStock" ) ) ]  := 1
         aTmp[ ( dbfArticulo )->( fieldpos( "lLote"     ) ) ]  := .f.
         aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva"   ) ) ]  := cDefIva()
         aTmp[ ( dbfArticulo )->( fieldpos( "lBnf1"     ) ) ]  := .t.
         aTmp[ ( dbfArticulo )->( fieldpos( "lBnf2"     ) ) ]  := .t.
         aTmp[ ( dbfArticulo )->( fieldpos( "lBnf3"     ) ) ]  := .t.
         aTmp[ ( dbfArticulo )->( fieldpos( "lBnf4"     ) ) ]  := .t.
         aTmp[ ( dbfArticulo )->( fieldpos( "lBnf5"     ) ) ]  := .t.
         aTmp[ ( dbfArticulo )->( fieldpos( "lBnf6"     ) ) ]  := .t.

      case nMode == DUPL_MODE
         aTmp[ ( dbfArticulo )->( fieldpos( "Codigo"    ) ) ]  := NextKey( aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], dbfArticulo )

   end case

   cCatOld     := aTmp[ ( dbfArticulo )->( fieldpos( "cCodCat" ) ) ]
   cPrvOld     := aTmp[ ( dbfArticulo )->( fieldpos( "cPrvHab" ) ) ]

   //Definicion del diálogo

   DEFINE DIALOG oDlg RESOURCE "FASTART" TITLE LblTitle( nMode ) + "artículo : " + Rtrim( aTmp[( dbfArticulo )->( fieldpos( "NOMBRE" ) ) ] )

   //Definición del código y nombre del nuevo artículo

   REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ];
      VAR      aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ];
      ID       100 ;
      PICTURE  "@!" ;
      WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
      VALID    ( CheckValid( aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], dbfArticulo, 1, nMode ) ) ;
      BITMAP   "Bot" ;
      ON HELP  ( aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]:cText( NextKey( aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], dbfArticulo ) ) );
      OF       oDlg

   REDEFINE GET aGet[( dbfArticulo )->( fieldpos( "Nombre" ) ) ] ;
      VAR      aTmp[( dbfArticulo )->( fieldpos( "Nombre" ) ) ];
      ID       110 ;
      ON CHANGE( ActTitle( nKey, nFlags, Self, nMode, oDlg ) );
      OF       oDlg

   //Definición de la familia del nuevo artículo

   REDEFINE GET aGet[( dbfArticulo )->( fieldpos( "Familia" ) ) ] ;
      VAR      aTmp[( dbfArticulo )->( fieldpos( "Familia" ) ) ] ;
      ID       120 ;
      VALID    ( cFamilia( aGet[( dbfArticulo )->( fieldpos( "Familia" ) ) ], dbfFam, oSay[1] ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFamilia( aGet[( dbfArticulo )->( fieldpos( "Familia" ) ) ], oSay[1] ) );
      OF       oDlg

   REDEFINE GET oSay[1] VAR cSay[1] ;
      WHEN     ( .F. );
      ID       121 ;
      OF       oDlg

   //Definición del catálogo del artículo

   REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "cCodCat" ) ) ] ;
      VAR      aTmp[ ( dbfArticulo )->( fieldpos( "cCodCat" ) ) ] ;
      ID       130 ;
      VALID    ( CargaValorCat( aTmp, aGet, oSay, oValorPunto, oValorDto, oValorTot, nMode, .t. ),;
                 oCatalogo:lValid( aGet[ ( dbfArticulo )->( fieldpos( "CCODCAT" ) ) ], oSay[2] ) );
      ON HELP  ( oCatalogo:Buscar( aGet[ ( dbfArticulo )->( fieldpos( "CCODCAT" ) ) ], oSay[2], "cCodCata" ) ) ;
      ON CHANGE( CargaValorCat( aTmp, aGet, oSay, oValorPunto, oValorDto, oValorTot, nMode, .t. ) );
      BITMAP   "LUPA" ;
      OF       oDlg

   REDEFINE GET oSay[2] VAR cSay[2] ;
      ID       131 ;
      WHEN     ( .f. ) ;
      OF       oDlg

   //Definición del proveedor del artículo

   REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "CPRVHAB" ) ) ] ;
      VAR      aTmp[ ( dbfArticulo )->( fieldpos( "CPRVHAB" ) ) ] ;
      ID       140 ;
      PICTURE  ( RetPicCodPrvEmp() ) ;
      WHEN     ( Empty( aTmp[( dbfArticulo )->( fieldpos( "CCODCAT" ) ) ] ) );
      VALID    ( CargaProveedor( aGet[ ( dbfArticulo )->( fieldpos( "CPRVHAB" ) ) ], oSay[ 4 ], oValorPunto, dbfProv ) );
      ON HELP  ( BrwProvee( aGet[ ( dbfArticulo )->( fieldpos( "CPRVHAB" ) ) ] ) ) ;
      BITMAP   "LUPA" ;
      OF       oDlg

   REDEFINE GET oSay[4] VAR cSay[4] ;
      ID       141 ;
      WHEN     ( .f. ) ;
      OF       oDlg

   REDEFINE GET oSay[3] VAR cSay[3] ;
      ID       150 ;
      OF       oDlg

   //Define la cantidad de puntos que cuesta un artículo

   REDEFINE GET aGet[ ( dbfArticulo )->( fieldpos( "pCosto" ) ) ] ;
      VAR      aTmp[ ( dbfArticulo )->( fieldpos( "pCosto" ) ) ] ;
      ID       160 ;
      VALID    ( oValorTot:Refresh(), .t. );
      PICTURE  cPinDiv ;
      OF       oDlg

   //Carga el valor del punto

   REDEFINE GET oValorPunto VAR aTmp[ ( dbfArticulo )->( fieldpos( "NPUNTOS" ) ) ] ;
      ID       170 ;
      ON CHANGE( oValorTot:Refresh() );
      PICTURE  cPinDiv ;
      OF       oDlg

   //Carga el descuento del punto

   REDEFINE GET oValorDto ;
      VAR      aTmp[ ( dbfArticulo )->( fieldpos( "NDTOPNT" ) ) ] ;
      ID       180 ;
      SPINNER ;
      ON CHANGE( oValorTot:Refresh() );
      PICTURE  "@E 999.99" ;
      OF       oDlg

   //Define el total de la divisa el descuento del punto

   REDEFINE SAY oValorTot ;
      PROMPT   nPunt2Euro( aTmp, dbfArticulo ) ;
      ID       190 ;
      PICTURE  cPinDiv ;
      COLOR    CLR_GET ;
      OF       oDlg

   //Definición de los botones de la caja de diálogo

   REDEFINE BUTTON oBtn ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( EndTrans2( aTmp, aGet, oSay, oDlg, nMode ) )

	REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| EndTrans2( aTmp, aGet, oSay, oDlg, nMode ) } )

   oDlg:bStart := {|| aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]:SetFocus() }

   ACTIVATE DIALOG oDlg ;
      ON INIT  ( aGet[( dbfArticulo )->( fieldpos( "FAMILIA" ) ) ]:lValid(), aGet[ ( dbfArticulo )->( fieldpos( "CCODCAT" ) ) ]:lValid(), aGet[ ( dbfArticulo )->( fieldpos( "CPRVHAB" ) ) ]:lValid() );
      CENTER

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static function lValidaSubcuenta( aGet, aTmp, nGetDebe, nGetHaber, oGetSaldo, oGetSubCta, cSubCtaAnt, oBrwCta, dbfTmpSubCta )

   if MkSubcuenta( aGet[ ( dbfArticulo )->( fieldpos( "CCTAVTA" ) ) ],;
                { aTmp[ ( dbfArticulo )->( fieldpos( "CCTAVTA" ) ) ], aTmp[ ( dbfArticulo )->( fieldpos( "NOMBRE"  ) ) ] },;
                oGetSubCta,;
                nil,;
                nil,;
                @nGetDebe,;
                @nGetHaber,;
                oGetSaldo )

      if aTmp[ ( dbfArticulo )->( fieldpos( "CCTAVTA" ) ) ] != cSubCtaAnt
         LoadSubcuenta( aTmp[ ( dbfArticulo )->( fieldpos( "CCTAVTA" ) ) ], cRutCnt(), dbfTmpSubCta )
         oBrwCta:Refresh()
      end if

      Return .t.

   end if

Return .f.

//---------------------------------------------------------------------------//

Static function lValidaSubcuentaCompras( aGet, aTmp, nGetDebe, nGetHaber, oGetSaldo, oGetSubCom, cSubCtaAntCom, oBrwCom, dbfTmpSubCom )

   if MkSubcuenta( aGet[ ( dbfArticulo )->( fieldpos( "CCTACOM" ) ) ],;
                { aTmp[ ( dbfArticulo )->( fieldpos( "CCTACOM" ) ) ], aTmp[ ( dbfArticulo )->( fieldpos( "NOMBRE"  ) ) ] },;
                oGetSubCom,;
                nil,;
                nil,;
                @nGetDebe,;
                @nGetHaber,;
                oGetSaldo )

      if aTmp[ ( dbfArticulo )->( fieldpos( "CCTACOM" ) ) ] != cSubCtaAntCom
         LoadSubcuenta( aTmp[ ( dbfArticulo )->( fieldpos( "CCTACOM" ) ) ], cRutCnt(), dbfTmpSubCom )
         oBrwCom:Refresh()
      end if

      Return .t.

   end if

Return .f.

//---------------------------------------------------------------------------//

Static Function StartDlg( aGet, aTmp, nMode, oSay, oDlg, oCosto, aBtnDiv, oFnt, oBtnMoneda, aBtn, bmpImage, oBrwPrv, oBrwDiv, oBrwStk, oBrwKit, oBrwOfe, oBrwCtaVta, oBrwCtaCom, oBrwCodeBar, oBrwImg )

   CursorWait()

   oDlg:Disable()

   EvalGet( aGet, nMode )

   ChgKit( aTmp, aGet, oCosto )

   oSay[ 18 ]:SetText( uFieldEmpresa( "cTxtTar1", "Precio 1" ) )

   if uFieldEmpresa( "lShwTar2" )
      oSay[ 19 ]:SetText( uFieldEmpresa( "cTxtTar2", "Precio 2" ) )
   else
      oSay[ 12 ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "lBnf2" ) )    ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "Benef2" ) )   ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVenta2" ) )  ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva2" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlq2" ) )    ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva2" ) ) ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar3" )
      oSay[ 20 ]:SetText( uFieldEmpresa( "cTxtTar3", "Precio 3" ) )
   else
      oSay[ 13 ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "lBnf3" ) )    ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "Benef3" ) )   ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVenta3" ) )  ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva3" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlq3" ) )    ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva3" ) ) ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar4" )
      oSay[ 21 ]:SetText( uFieldEmpresa( "cTxtTar4", "Precio 4" ) )
   else
      oSay[ 14 ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "lBnf4" ) )    ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "Benef4" ) )   ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVenta4" ) )  ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva4" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlq4" ) )    ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva4" ) ) ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar5" )
      oSay[ 22 ]:SetText( uFieldEmpresa( "cTxtTar5", "Precio 5" ) )
   else
      oSay[ 15 ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "lBnf5" ) )    ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "Benef5" ) )   ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVenta5" ) )  ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva5" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlq5" ) )    ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva5" ) ) ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar6" )
      oSay[ 23 ]:SetText( uFieldEmpresa( "cTxtTar6", "Precio 6" ) )
   else
      oSay[ 16 ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "lBnf6" ) )    ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "Benef6" ) )   ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVenta6" ) )  ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva6" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlq6" ) )    ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva6" ) ) ]:Hide()
   end if

   aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]:SetFocus()

   oBtnMoneda:Show()

   IXBrowse():OpenData()

   if !Empty( oBrwPrv )
      oBrwPrv:LoadData()
   end if

   if !Empty( oBrwDiv )
      oBrwDiv:LoadData()
   end if

   if !Empty( oBrwStk )
      oBrwStk:LoadData()
   end if

   if !Empty( oBrwKit )
      oBrwKit:LoadData()
   end if

   if !Empty( oBrwOfe )
      oBrwOfe:LoadData()
   end if

   if !Empty( oBrwCtaVta )
      oBrwCtaVta:LoadData()
   end if

   if !Empty( oBrwCtaCom )
      oBrwCtaCom:LoadData()
   end if

   if !Empty( oBrwImg )
      oBrwImg:LoadData()
   end if

   IXBrowse():CloseData()

   /*
   Mostamos la imagen del articulo---------------------------------------------
   */

   //ChgBmp( cFirstImage( aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ] ), bmpImage )
   //cFirstImage( aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], dbfImg )

   /*ChgBmp( if( !Empty( aGet[ ( dbfArticulo )->( fieldpos( "cImagenWeb" ) ) ] ),;
                                    cNoPath( cFirstImage( aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], aGet[ ( dbfArticulo )->( fieldpos( "cAlias" ) ) ] ) ),;
                                    aGet[ ( dbfArticulo )->( fieldpos( "cImagen" ) ) ] ), bmpImage )    */
   //ChgBmp(  aGet[ ( dbfArticulo )->( fieldpos( "CIMAGENWEB" ) ) ] , bmpImage )

   /*
   Mostramos y ocultamos los precios de venta y alquiler dependiendo de en cual estemos
   */

   if oCbxPrecio:nAt == 1

      oSay[ 11 ]:Show()
      aGet[ ( dbfArticulo )->( fieldpos( "pVenta1" ) )  ]:Show()
      aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva1" ) ) ]:Show()
      aGet[ ( dbfArticulo )->( fieldpos( "lBnf1" ) )    ]:Show()
      aGet[ ( dbfArticulo )->( fieldpos( "Benef1" ) )   ]:Show()

      if uFieldEmpresa( "lShwTar2" )
         oSay[ 12 ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pVenta2" ) )  ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva2" ) ) ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "lBnf2" ) )    ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "Benef2" ) )   ]:Show()
      end if

      if uFieldEmpresa( "lShwTar3" )
         oSay[ 13 ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pVenta3" ) )  ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva3" ) ) ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "lBnf3" ) )    ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "Benef3" ) )   ]:Show()
      end if

      if uFieldEmpresa( "lShwTar4" )
         oSay[ 14 ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pVenta4" ) )  ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva4" ) ) ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "lBnf4" ) )    ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "Benef4" ) )   ]:Show()
      end if

      if uFieldEmpresa( "lShwTar5" )
         oSay[ 15 ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pVenta5" ) )  ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva5" ) ) ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "lBnf5" ) )    ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "Benef5" ) )   ]:Show()
      end if

      if uFieldEmpresa( "lShwTar6" )
         oSay[ 16 ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pVenta6" ) )  ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva6" ) ) ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "lBnf6" ) )    ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "Benef6" ) )   ]:Show()
      end if

      aGet[ ( dbfArticulo )->( fieldpos( "pAlq1" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlq2" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlq3" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlq4" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlq5" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlq6" ) ) ]:Hide()

      aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva1" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva2" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva3" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva4" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva5" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva6" ) ) ]:Hide()

   else

      aGet[ ( dbfArticulo )->( fieldpos( "pAlq1" ) )    ]:Show()
      aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva1" ) ) ]:Show()

      if uFieldEmpresa( "lShwTar2" )
         aGet[ ( dbfArticulo )->( fieldpos( "pAlq2" ) )    ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva2" ) ) ]:Show()
      end if

      if uFieldEmpresa( "lShwTar3" )
         aGet[ ( dbfArticulo )->( fieldpos( "pAlq3" ) )    ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva3" ) ) ]:Show()
      end if

      if uFieldEmpresa( "lShwTar4" )
         aGet[ ( dbfArticulo )->( fieldpos( "pAlq4" ) )    ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva4" ) ) ]:Show()
      end if

      if uFieldEmpresa( "lShwTar5" )
         aGet[ ( dbfArticulo )->( fieldpos( "pAlq5" ) )    ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva5" ) ) ]:Show()
      end if

      if uFieldEmpresa( "lShwTar6" )
         aGet[ ( dbfArticulo )->( fieldpos( "pAlq6" ) )    ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "pAlqIva6" ) ) ]:Show()
      end if

      aGet[ ( dbfArticulo )->( fieldpos( "pVenta1" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVenta2" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "PVenta3" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVenta4" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVenta5" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVenta6" ) ) ]:Hide()

      aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva1" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva2" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva3" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva4" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva5" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "pVtaIva6" ) ) ]:Hide()

      aGet[ ( dbfArticulo )->( fieldpos( "lBnf1" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "lBnf2" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "lBnf3" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "lBnf4" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "lBnf5" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "lBnf6" ) ) ]:Hide()

      aGet[ ( dbfArticulo )->( fieldpos( "Benef1" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "Benef2" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "Benef3" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "Benef4" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "Benef5" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "Benef6" ) ) ]:Hide()

      oSay[ 11 ]:Hide()
      oSay[ 12 ]:Hide()
      oSay[ 13 ]:Hide()
      oSay[ 14 ]:Hide()
      oSay[ 15 ]:Hide()
      oSay[ 16 ]:Hide()

   end if

   // Stock de almacen---------------------------------------------------------

   if nMode != APPD_MODE

      if aTmp[ ( dbfArticulo )->( fieldpos( "nCtlStock" ) ) ] <= 1
         oStock:aStockArticulo( aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], nil, oBrwStk )
      end if

      if nMode != ZOOM_MODE

         // Comportamiento del dialogo-----------------------------------------------

         if !oUser():lCambiarPrecio()

            aGet[ ( dbfArticulo )->( FieldPos( "pVenta1" ) ) ]:HardDisable()
            aGet[ ( dbfArticulo )->( FieldPos( "pVtaIva1") ) ]:HardDisable()
            aGet[ ( dbfArticulo )->( FieldPos( "pVenta2" ) ) ]:HardDisable()
            aGet[ ( dbfArticulo )->( FieldPos( "pVtaIva2") ) ]:HardDisable()
            aGet[ ( dbfArticulo )->( FieldPos( "pVenta3" ) ) ]:HardDisable()
            aGet[ ( dbfArticulo )->( FieldPos( "pVtaIva3") ) ]:HardDisable()
            aGet[ ( dbfArticulo )->( FieldPos( "pVenta4" ) ) ]:HardDisable()
            aGet[ ( dbfArticulo )->( FieldPos( "pVtaIva4") ) ]:HardDisable()
            aGet[ ( dbfArticulo )->( FieldPos( "pVenta5" ) ) ]:HardDisable()
            aGet[ ( dbfArticulo )->( FieldPos( "pVtaIva5") ) ]:HardDisable()
            aGet[ ( dbfArticulo )->( FieldPos( "pVenta6" ) ) ]:HardDisable()
            aGet[ ( dbfArticulo )->( FieldPos( "pVtaIva6") ) ]:HardDisable()

            aGet[ ( dbfArticulo )->( fieldpos( "nPntVer1") ) ]:HardDisable()
            aGet[ ( dbfArticulo )->( fieldpos( "nPnvIva1") ) ]:HardDisable()

            aGet[ ( dbfArticulo )->( fieldpos( "PvpRec"  ) ) ]:HardDisable()

         end if

         if oUser():lNotRentabilidad()

            aGet[ ( dbfArticulo )->( fieldpos( "Benef1"  ) ) ]:Hide()
            aGet[ ( dbfArticulo )->( fieldpos( "Benef2"  ) ) ]:Hide()
            aGet[ ( dbfArticulo )->( fieldpos( "Benef3"  ) ) ]:Hide()
            aGet[ ( dbfArticulo )->( fieldpos( "Benef4"  ) ) ]:Hide()
            aGet[ ( dbfArticulo )->( fieldpos( "Benef5"  ) ) ]:Hide()
            aGet[ ( dbfArticulo )->( fieldpos( "Benef6"  ) ) ]:Hide()

            aGet[ ( dbfArticulo )->( fieldpos( "lBnf1"   ) ) ]:Hide()
            aGet[ ( dbfArticulo )->( fieldpos( "lBnf2"   ) ) ]:Hide()
            aGet[ ( dbfArticulo )->( fieldpos( "lBnf3"   ) ) ]:Hide()
            aGet[ ( dbfArticulo )->( fieldpos( "lBnf4"   ) ) ]:Hide()
            aGet[ ( dbfArticulo )->( fieldpos( "lBnf5"   ) ) ]:Hide()
            aGet[ ( dbfArticulo )->( fieldpos( "lBnf6"   ) ) ]:Hide()

            oSay[ 11 ]:Hide()
            oSay[ 12 ]:Hide()
            oSay[ 13 ]:Hide()
            oSay[ 14 ]:Hide()
            oSay[ 15 ]:Hide()
            oSay[ 16 ]:Hide()

         end if

      end if

   end if

   if oUser():lNotCostos()
      aGet[ ( dbfArticulo )->( fieldpos( "pCosto" ) ) ]:Hide()
      oCosto:Hide()
   end if

   if aTmp[ ( dbfArticulo )->( fieldpos( "nCtlStock" ) ) ] != 1
      oBrwStk:Hide()
   else
      oBrwStk:Show()
   end if

   if uFieldEmpresa( "lRealWeb" )
      oBtnAceptarActualizarWeb:Show()
   else   
      oBtnAceptarActualizarWeb:Hide()
   end if

   oDlg:Enable()

   CursorWE()

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function BeginTrans( aTmp, nMode )

   local lErrors     := .f.
   local cCodArt
   local cCodSubCta
   local cCodSubCom
   local aItmSubCta
   local oError
   local oBlock

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   aItmSubCta        := {}

   cCodArt           := aTmp[ ( dbfArticulo )->( fieldpos( "Codigo"  ) ) ]
   cCodSubCta        := aTmp[ ( dbfArticulo )->( fieldpos( "cCtaVta" ) ) ]
   cCodSubCom        := aTmp[ ( dbfArticulo )->( fieldpos( "cCtaCom" ) ) ]

   aAdd( aItmSubCta, { "nAsiento",  "N",  6, 0, "Asiento"    } )
   aAdd( aItmSubCta, { "dFecha",    "D",  8, 0, "Fecha"      } )
   aAdd( aItmSubCta, { "cConcepto", "C", 25, 0, "Concepto"   } )
   aAdd( aItmSubCta, { "nDebe",     "N", 16, 2, "Debe"       } )
   aAdd( aItmSubCta, { "nHaber",    "N", 16, 2, "Haber"      } )
   aAdd( aItmSubCta, { "cDeparta",  "C",  6, 0, "Departa"    } )
   aAdd( aItmSubCta, { "nFactura",  "N",  8, 0, "Factura"    } )
   aAdd( aItmSubCta, { "nBase",     "N", 16, 2, "Base"       } )
   aAdd( aItmSubCta, { "nIva",      "N",  5, 2, "I.V.A"      } )

   filTmpPrv         := cGetNewFileName( cPatTmp() + "PrvArt" )
   filTmpVta         := cGetNewFileName( cPatTmp() + "VtaArt" )
   filTmpKit         := cGetNewFileName( cPatTmp() + "KitArt" )
   filTmpOfe         := cGetNewFileName( cPatTmp() + "OfeArt" )
   filTmpImg         := cGetNewFileName( cPatTmp() + "ArtImg" )
   filTmpCodebar     := cGetNewFileName( cPatTmp() + "ArtCodebar" )
   filTmpSubCta      := cGetNewFileName( cPatTmp() + "TmpSubCta" )
   filTmpSubCom      := cGetNewFileName( cPatTmp() + "TmpSubCom" )

	/*
   Primero Crear la base de datos local----------------------------------------
	*/

   dbCreate( filTmpPrv, aSqlStruct( aItmArtPrv() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpPrv, cCheckArea( "PrvArt", @dbfTmpPrv ), .f. )

   if !NetErr()

      ( dbfTmpPrv )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( dbfTmpPrv )->( OrdCreate( filTmpPrv, "cCodArt", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfTmpPrv )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( dbfTmpPrv )->( OrdCreate( filTmpPrv, "cRefPrv", "cCodPrv + cRefPrv", {|| Field->cCodPrv + Field->cRefPrv } ) )

      if nMode != APPD_MODE .and. ( dbfArtPrv )->( dbSeek( cCodArt ) )
         while ( dbfArtPrv )->cCodArt == cCodArt .and. !( dbfArtPrv )->( eof() )
            dbPass( dbfArtPrv, dbfTmpPrv, .t. )
            ( dbfArtPrv )->( dbSkip() )
         end while
         ( dbfTmpPrv )->( dbGoTop() )
      end if

   end if

   dbCreate( filTmpVta, aSqlStruct( aItmVta() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpVta, cCheckArea( "VtaArt", @dbfTmpVta ), .f. )
   ( dbfTmpVta )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
   ( dbfTmpVta )->( OrdCreate( filTmpVta, "cCodArt", "cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2", {|| Field->cCodArt + Field->cCodPr1 + Field->cCodPr2 + Field->cValPr1 + Field->cValPr2 } ) )

   if nMode != APPD_MODE .and. ( dbfArtVta )->( dbSeek( cCodArt ) )
      while ( dbfArtVta )->cCodArt == cCodArt .and. !( dbfArtVta )->( eof() )
         dbPass( dbfArtVta, dbfTmpVta, .t. )
         ( dbfArtVta )->( dbSkip() )
      end while
      ( dbfTmpVta )->( dbGoTop() )
   end if

   dbCreate( filTmpKit, aSqlStruct( aItmKit() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpKit, cCheckArea( "KitArt", @dbfTmpKit ), .f. )

   ( dbfTmpKit )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpKit )->( OrdCreate( filTmpKit, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

   ( dbfTmpKit )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
   ( dbfTmpKit )->( OrdCreate( filTmpKit, "cCodKit", "cCodKit", {|| Field->cCodKit } ) )

   ( dbfTmpKit )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
   ( dbfTmpKit )->( OrdCreate( filTmpKit, "cRefKit", "cRefKit", {|| Field->cRefKit } ) )

   ( dbfTmpKit )->( OrdSetFocus( "Recno" ) )

   if nMode != APPD_MODE .and. ( dbfArtKit )->( dbSeek( cCodArt ) )
      while ( dbfArtKit )->cCodKit == cCodArt .and. !( dbfArtKit )->( eof() )
         dbPass( dbfArtKit, dbfTmpKit, .t. )
         ( dbfArtKit )->( dbSkip() )
      end while
      ( dbfTmpKit )->( dbGoTop() )
   end if

   /*
   Ofertas---------------------------------------------------------------------
   */

   dbCreate( filTmpOfe, aSqlStruct( aItmOfe() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpOfe, cCheckArea( "OfeArt", @dbfTmpOfe ), .f. )

   ( dbfTmpOfe )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
   ( dbfTmpOfe )->( OrdCreate( filTmpOfe, "cArtOfe", "cArtOfe", {|| Field->cArtOfe } ) )

   if nMode != APPD_MODE .and. ( dbfOfe )->( dbSeek( cCodArt ) )
      while ( dbfOfe )->cArtOfe == cCodArt .and. ( dbfOfe )->nTblOfe < 2 .and. !( dbfOfe )->( eof() )
         dbPass( dbfOfe, dbfTmpOfe, .t. )
         ( dbfOfe )->( dbSkip() )
      end while
      ( dbfTmpOfe )->( dbGoTop() )
   end if

   /*
   Imagenes--------------------------------------------------------------------
   */

   dbCreate( filTmpImg, aSqlStruct( aItmImg() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpImg, cCheckArea( "ImgArt", @dbfTmpImg ), .f. )

   ( dbfTmpImg )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
   ( dbfTmpImg )->( OrdCreate( filTmpImg, "cCodArt", "cCodArt", {|| Field->cCodArt } ) )

   ( dbfTmpImg )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
   ( dbfTmpImg )->( OrdCreate( filTmpImg, "cImgArt", "cImgArt", {|| Field->cImgArt } ) )

   if nMode != APPD_MODE .and. ( dbfImg )->( dbSeek( cCodArt ) )
      while ( dbfImg )->cCodArt == cCodArt .and. !( dbfImg )->( eof() )
         dbPass( dbfImg, dbfTmpImg, .t. )
         ( dbfImg )->( dbSkip() )
      end while
      ( dbfTmpImg )->( dbGoTop() )
   end if

   /*
   Codigos de barras-----------------------------------------------------------
   */

   dbCreate( filTmpCodebar, aSqlStruct( aItmBar() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpCodebar, cCheckArea( "CodBar", @dbfTmpCodebar ), .f. )

   ( dbfTmpCodebar )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
   ( dbfTmpCodebar )->( OrdCreate( filTmpCodebar, "cCodBar", "cCodBar", {|| Field->cCodBar } ) )

   if nMode != APPD_MODE .and. ( dbfCodebar )->( dbSeek( cCodArt ) )
      while ( dbfCodebar )->cCodArt == cCodArt .and. !( dbfCodebar )->( eof() )
         dbPass( dbfCodebar, dbfTmpCodebar, .t. )
         ( dbfCodebar )->( dbSkip() )
      end while
      ( dbfTmpCodebar )->( dbGoTop() )
   end if

   /*
   Subcuentas------------------------------------------------------------------
   */

   dbCreate( filTmpSubCta, aSqlStruct( aItmSubCta ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpSubCta, cCheckArea( "TmpSubCta", @dbfTmpSubCta ), .f. )

   ( dbfTmpSubCta )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
   ( dbfTmpSubCta )->( OrdCreate( filTmpSubCta, "dFecha", "dFecha", {|| Field->dFecha } ) )

   dbCreate( filTmpSubCom, aSqlStruct( aItmSubCta ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpSubCom, cCheckArea( "TmpSubCom", @dbfTmpSubCom ), .f. )

   ( dbfTmpSubCom )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
   ( dbfTmpSubCom )->( OrdCreate( filTmpSubCom, "dFecha", "dFecha", {|| Field->dFecha } ) )

   if nMode != APPD_MODE
      LoadSubcuenta( cCodSubCta, cRutCnt(), dbfTmpSubCta )
      LoadSubcuenta( cCodSubCom, cRutCnt(), dbfTmpSubCom )
   end if

   /*
   Guardamos el-los códigos de barras para saber si han habido cambios---------
   */

   aOldCodeBar    := aDbfToArr( dbfTmpCodebar, 2 )

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales " + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lErrors )

//--------------------------------------------------------------------------//

Static Function EndTrans( aTmp, aGet, oSay, oDlg, aTipBar, cTipBar, nMode, oImpComanda1, oImpComanda2, aImpComanda, lActualizaWeb )

   local i
   local cCod
   local oError
   local oBlock
   local cCodArt
   local nTipBar
   local aCodeBar          := {}
   local lChange           := .f.
   local nRec
   local lDefault          := .f.

   DEFAULT lActualizaWeb   := .f.

   /*
   Tomamos los valores de los códigos de barra---------------------------------
   */

   cCod              := aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]

   if Empty( cCod ) .and. ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      MsgStop( "Código no puede estar vacio" )
      return nil
   end if

   if dbSeekInOrd( cCod, "Codigo", dbfArticulo ) .and. ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      msgStop( "Código ya existe" )
      return nil
   end if

   DisableAcceso()

   oDlg:Disable()

   oMsgText( "Archivando" )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      BeginTransaction()

      aTmp[ ( dbfArticulo )->( fieldpos( "LastChg" ) ) ] := GetSysDate()

      /*
      -------------------------------------------------------------------------
      Añadimos la imágen del táctil a la tabla de imágenes---------------------
      -------------------------------------------------------------------------
      */

      if !Empty( aTmp[ ( dbfArticulo )->( fieldpos( "cImagen" ) ) ] )

         if !dbSeekInOrd( aTmp[ ( dbfArticulo )->( fieldpos( "cImagen" ) ) ], "cImgArt", dbfTmpImg )

            lDefault                 := ( dbfTmpImg )->( LastRec() ) == 0

            ( dbfTmpImg )->( dbAppend() )
            ( dbfTmpImg )->cCodArt  := aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]
            ( dbfTmpImg )->cImgArt  := aTmp[ ( dbfArticulo )->( fieldpos( "cImagen" ) ) ]
            ( dbfTmpImg )->lDefImg  := lDefault

            ( dbfTmpImg )->( dbUnLock() )            

         end if
             
      end if

      /*
      -------------------------------------------------------------------------
      Añadimos las imágenes de las propiedades---------------------------------
      -------------------------------------------------------------------------
      */

      nRec  := ( dbfTmpVta )->( Recno() )

      ( dbfTmpVta )->( dbGoTop() )

      while !( dbfTmpVta )->( Eof() )

         if !Empty( ( dbfTmpVta )->cImgWeb )                      .and.;
            !dbSeekInOrd( AllTrim( Upper( ( dbfTmpVta )->cImgWeb ) ), "cImgArt", dbfTmpImg )

            lDefault                 := ( dbfTmpImg )->( LastRec() ) == 0

            ( dbfTmpImg )->( dbAppend() )
            ( dbfTmpImg )->cCodArt   := aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]
            ( dbfTmpImg )->cImgArt   := AllTrim( Upper( ( dbfTmpVta )->cImgWeb ) )
            ( dbfTmpImg )->lDefImg   := lDefault

            ( dbfTmpImg )->( dbUnLock() )            

         end if   

         ( dbfTmpVta )->( dbSkip() )
             
      end while

      ( dbfTmpVta )->( dbGoTo( nRec ) )

      /*
      -------------------------------------------------------------------------
      Dejamos almenos una imágen por defecto-----------------------------------
      -------------------------------------------------------------------------
      */

      lDefault       := .f.

      ( dbfTmpImg )->( dbGoTop() )

      while !( dbfTmpImg )->( Eof() )

         if ( dbfTmpImg )->lDefImg
            lDefault := .t.
         end if

         ( dbfTmpImg )->( dbSkip() )

      end while

      if !lDefault

         ( dbfTmpImg )->( dbGoTop() )         

         if dbLock( dbfTmpImg )
            ( dbfTmpImg )->lDefImg  := .t.
            ( dbfTmpImg )->( dbUnLock() )
         end if 

      end if

      /*
      Eliminar datos-----------------------------------------------------------
      */

      if nMode == EDIT_MODE

         while ( dbfArtPrv )->( dbSeek( cCod ) ) .and. !( dbfArtPrv )->( eof() )
            if dbLock( dbfArtPrv )
               ( dbfArtPrv )->( dbDelete() )
               ( dbfArtPrv )->( dbUnLock() )
            end if
         end while

         while ( dbfArtVta )->( dbSeek( cCod ) ) .and. !( dbfArtVta )->( eof() )
            if dbLock( dbfArtVta )
               ( dbfArtVta )->( dbDelete() )
               ( dbfArtVta )->( dbUnLock() )
            end if
         end while

         while ( dbfArtKit )->( dbSeek( cCod ) ) .and. !( dbfArtKit )->( eof() )
            if dbLock( dbfArtKit )
               ( dbfArtKit )->( dbDelete() )
               ( dbfArtKit )->( dbUnLock() )
            end if
         end while

         while ( dbfOfe )->( dbSeek( cCod ) ) .and. !( dbfOfe )->( eof() )
            if dbLock( dbfOfe )
               ( dbfOfe )->( dbDelete() )
               ( dbfOfe )->( dbUnLock() )
            end if
         end while

         while ( dbfImg )->( dbSeek( cCod ) ) .and. !( dbfImg )->( eof() )
            if dbLock( dbfImg )
               ( dbfImg )->( dbDelete() )
               ( dbfImg )->( dbUnLock() )
            end if
         end while

         /*
         Codigos de barras--------------------------------------------------------
         */

         ( dbfTmpCodebar )->( dbGoTop() )

         aCodeBar       := aDbfToArr( dbfTmpCodebar, 2 )

         while ( dbfCodebar )->( dbSeek( cCod ) ) .and. !( dbfCodebar )->( eof() )
            if dbLock( dbfCodebar )
               ( dbfCodebar )->( dbDelete() )
               ( dbfCodebar )->( dbUnLock() )
            end if
         end while

      end if

      /*
      Pasamos los temporales a los ficheros definitivos---------------------------
      */

      ( dbfTmpPrv )->( OrdSetFocus( 0 ) )
      ( dbfTmpPrv )->( dbGoTop() )
      while !( dbfTmpPrv )->( eof() )
         ( dbfTmpPrv )->cCodArt  := cCod
          dbPass( dbfTmpPrv, dbfArtPrv, .t. )
         ( dbfTmpPrv )->( dbSkip() )
      end while

      ( dbfTmpVta )->( OrdSetFocus( 0 ) )
      ( dbfTmpVta )->( dbGoTop() )
      while !( dbfTmpVta )->( eof() )
         ( dbfTmpVta )->cCodArt  := cCod
          dbPass( dbfTmpVta, dbfArtVta, .t. )
         ( dbfTmpVta )->( dbSkip() )
      end while

      ( dbfTmpKit )->( OrdSetFocus( 0 ) )
      ( dbfTmpKit )->( dbGoTop() )
      while !( dbfTmpKit )->( eof() )
         ( dbfTmpKit )->cCodKit := cCod
          dbPass( dbfTmpKit, dbfArtKit, .t. )
         ( dbfTmpKit )->( dbSkip() )
      end while

      ( dbfTmpOfe )->( OrdSetFocus( 0 ) )
      ( dbfTmpOfe )->( dbGoTop() )
      while !( dbfTmpOfe )->( eof() )
         ( dbfTmpOfe )->cArtOfe := cCod
          dbPass( dbfTmpOfe, dbfOfe, .t. )
         ( dbfTmpOfe )->( dbSkip() )
      end while

      ( dbfTmpImg )->( OrdSetFocus( 0 ) )
      ( dbfTmpImg )->( dbGoTop() )
      while !( dbfTmpImg )->( eof() )
         ( dbfTmpImg )->cCodArt := cCod
          dbPass( dbfTmpImg, dbfImg, .t. )
         ( dbfTmpImg )->( dbSkip() )
      end while

      ( dbfTmpCodebar )->( OrdSetFocus( 0 ) )
      ( dbfTmpCodebar )->( dbGoTop() )

      while !( dbfTmpCodebar )->( eof() )

         ( dbfTmpCodebar )->cCodArt := cCod

         if ( dbfTmpCodebar )->lDefBar
            cCodArt                                               := ( dbfTmpCodebar )->cCodBar
            nTipBar                                               := ( dbfTmpCodebar )->nTipBar
            aTmp[ ( dbfArticulo )->( fieldpos( "CodeBar"  ) ) ]   := ( dbfTmpCodebar )->cCodBar
         end if

         if !Empty( ( dbfTmpCodebar )->cValPr1 ) .and. At( Alltrim( aTmp[ ( dbfArticulo )->( FieldPos( "mValPrp1" ) ) ] ), Alltrim( ( dbfTmpCodebar )->cValPr1 ) ) == 0
            aTmp[ ( dbfArticulo )->( FieldPos( "mValPrp1" ) ) ]   := Alltrim( aTmp[ ( dbfArticulo )->( FieldPos( "mValPrp1" ) ) ] ) + Alltrim( ( dbfTmpCodebar )->cValPr1 ) + ","
         end if

         if !Empty( ( dbfTmpCodebar )->cValPr2 ) .and. At( Alltrim( aTmp[ ( dbfArticulo )->( FieldPos( "mValPrp2" ) ) ] ), Alltrim( ( dbfTmpCodebar )->cValPr2 ) ) == 0
            aTmp[ ( dbfArticulo )->( FieldPos( "mValPrp2" ) ) ]   := Alltrim( aTmp[ ( dbfArticulo )->( FieldPos( "mValPrp2" ) ) ] ) + Alltrim( ( dbfTmpCodebar )->cValPr2 ) + ","
         end if

         dbPass( dbfTmpCodebar, dbfCodebar, .t. )

         ( dbfTmpCodebar )->( dbSkip() )

      end while

      /*
      Tomamos algunos valores-----------------------------------------------------
      */

      aTmp[ ( dbfArticulo )->( fieldpos( "lLabel"  ) ) ]       := .t.
      aTmp[ ( dbfArticulo )->( fieldpos( "lSndDoc" ) ) ]       := .t.
      aTmp[ ( dbfArticulo )->( fieldpos( "cCodUsr" ) ) ]       := cCurUsr()
      aTmp[ ( dbfArticulo )->( fieldpos( "dFecChg" ) ) ]       := GetSysDate()
      aTmp[ ( dbfArticulo )->( fieldpos( "cTimChg" ) ) ]       := Time()
      aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr1") ) ]       := oSay[ 11 ]:nAt
      aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr2") ) ]       := oSay[ 12 ]:nAt
      aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr3") ) ]       := oSay[ 13 ]:nAt
      aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr4") ) ]       := oSay[ 14 ]:nAt
      aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr5") ) ]       := oSay[ 15 ]:nAt
      aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr6") ) ]       := oSay[ 16 ]:nAt
      aTmp[ ( dbfArticulo )->( fieldpos( "nPosTpv" ) ) ]       -= 0.5

      aTmp[ ( dbfArticulo )->( fieldpos( "cTipImp1" ) ) ]      := aImpComanda[ oImpComanda1:nAt ]
      aTmp[ ( dbfArticulo )->( fieldpos( "cTipImp2" ) ) ]      := aImpComanda[ oImpComanda2:nAt ]

      if !Empty( oActiveX )
         aTmp[ ( dbfArticulo )->( fieldpos( "mDesTec" ) ) ]    := oActiveX:DocumentHTML
      end if

      /*
      Ponemos la fecha de cambio por código de barras-----------------------------
      */

      if Len( aCodeBar ) != Len( aOldCodeBar )  // Hemos añadido y eliminado algñun código de barras
         lChange     := .t.
      end if

      for i := 1 to Len( aCodeBar )             // Comprobamos para el caso en el que sólo modifiquemos
         if aScan( aOldCodeBar, aCodeBar[ i ] ) == 0
            lChange  := .t.
         end if
      next

      if lChange
         aTmp[ ( dbfArticulo )->( fieldpos( "dChgBar" ) ) ] := GetSysDate()
      end if

      /*
      Cambios para publicar en internet----------------------------------------
      */

      ChangePublicar( aTmp )

      ChangeTarWeb( aGet, aTmp )

      /*
      Grabamos el registro a disco---------------------------------------------
      */

      WinGather( aTmp, aGet, dbfArticulo, nil, nMode )

      /*
      Actualizamos los datos de la web para tiempo real------------------------
      */

      if ( dbfTmpImg )->( Lastrec() ) == 0
         lChangeImage  := ( cImageOld == aTmp[ ( dbfArticulo )->( fieldpos( "cImagen" ) ) ] )
      end if   

      Actualizaweb( cCod, lChangeImage, lActualizaWeb )

      /*
      Terminamos la transación-------------------------------------------------
      */

      CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()

      msgStop( "Imposible actualizar bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   
   ErrorBlock( oBlock )

   /*
   Cerramos el dialogo---------------------------------------------------------
   */

   oMsgText()

   oDlg:Enable()
   oDlg:End( IDOK )

   EnableAcceso()

Return ( .t. )

//-----------------------------------------------------------------------//

Static Function KillTrans( oBrwPrv, oBrwDiv, oBrwStk, oBrwCta, oBrwCom, oBrw2, oBrw5 )

   /*
   Quitamos los filtros de stock-----------------------------------------------
   */

   if !Empty( dbfTmpPrv ) .and. ( dbfTmpPrv )->( Used() )
      ( dbfTmpPrv )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpVta ) .and. ( dbfTmpVta )->( Used() )
      ( dbfTmpVta )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpKit ) .and. ( dbfTmpKit )->( Used() )
      ( dbfTmpKit )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpOfe ) .and. ( dbfTmpOfe )->( Used() )
      ( dbfTmpOfe )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpImg ) .and. ( dbfTmpImg )->( Used() )
      ( dbfTmpImg )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpCodebar ) .and. ( dbfTmpCodebar )->( Used() )
      ( dbfTmpCodebar )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpSubCta ) .and. ( dbfTmpSubCta )->( Used() )
      ( dbfTmpSubCta )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpSubCom ) .and. ( dbfTmpSubCom )->( Used() )
      ( dbfTmpSubCom )->( dbCloseArea() )
   end if

   dbfTmpCodebar  := nil
   dbfTmpSubCta   := nil
   dbfTmpSubCom   := nil
   dbfTmpPrv      := nil
   dbfTmpVta      := nil
   dbfTmpKit      := nil
   dbfTmpOfe      := nil
   dbfTmpImg      := nil

   dbfErase( filTmpPrv     )
   dbfErase( filTmpVta     )
   dbfErase( filTmpKit     )
   dbfErase( filTmpOfe     )
   dbfErase( filTmpImg     )
   dbfErase( filTmpCodebar )
   dbfErase( filTmpSubCta  )
   dbfErase( filTmpSubCom  )

Return .t.

//------------------------------------------------------------------------//

static function ChgKit( aTmp, aGet, oCosto )

   if aTmp[ ( dbfArticulo )->( fieldpos( "lKitArt") ) ] .and. !aTmp[ ( dbfArticulo )->( fieldpos( "lKitAsc") ) ]
      aGet[ ( dbfArticulo )->( fieldpos( "pCosto" ) ) ]:Hide()
      oCosto:Show()
      oCosto:Disable()
   else
      aGet[ ( dbfArticulo )->( fieldpos( "pCosto" ) ) ]:Show()
      oCosto:Hide()
   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

STATIC FUNCTION StdCol( lIvaInc, nMode )

RETURN ( lIvaInc .and. nMode != ZOOM_MODE )

//--------------------------------------------------------------------------//

STATIC FUNCTION ActTitle( nKey, nFlags, aGet, nMode, oDlg )

	aGet:assign()
   oDlg:cTitle( LblTitle( nMode ) + " artículo : " + Rtrim( aGet:varGet() ) + Chr( nKey ) )

RETURN NIL

//--------------------------------------------------------------------------//

/*
Edita las asociaciones con los codigos de proveedores
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfArtPrv, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oSay1
   local cSay1
   local oBmpDiv
   local oTotal
   local lOldPrvDef                                      := aTmp[ ( dbfTmpPrv )->( fieldPos( "lDefPrv" ) ) ]
   local lOldRefPrv                                      := aTmp[ ( dbfTmpPrv )->( fieldPos( "cRefPrv" ) ) ]

   if nMode == APPD_MODE

      /*
      Control para que el primer proveedor que metamos se ponga por defecto
      */

      ( dbfTmpPrv )->( dbGoTop() )

      if ( dbfTmpPrv )->( Eof() )
         aTmp[ ( dbfTmpPrv )->( FieldPos( "lDefPrv" ) ) ]   := .t.
      end if

      aTmp[ ( dbfTmpPrv )->( fieldpos( "cDivPrv" ) ) ]      := cDivEmp()

   end if

	DEFINE DIALOG oDlg RESOURCE "ARTPRV" TITLE LblTitle( nMode ) + "codificaciones de proveedores"

   REDEFINE GET aGet[ ( dbfTmpPrv )->( fieldPos( "CCODPRV" ) ) ] ;
      VAR      aTmp[ ( dbfTmpPrv )->( fieldPos( "CCODPRV" ) ) ] ;
		ID 		110 ;
      PICTURE  ( Replicate( "X", RetNumCodPrvEmp() ) );
      WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
      VALID    ( cProvee( aGet[ ( dbfTmpPrv )->( fieldpos( "CCODPRV" ) ) ], dbfProv, oSay1 ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwProvee( aGet[ ( dbfTmpPrv )->( fieldpos( "CCODPRV" ) ) ], oSay1 ) ) ;
		OF 		oDlg

	REDEFINE GET oSay1 VAR cSay1 ;
		ID 		120 ;
		WHEN 		.F. ;
		OF 		oDlg

   REDEFINE GET aGet[ ( dbfTmpPrv )->( fieldPos( "CREFPRV" ) ) ];
      VAR      aTmp[ ( dbfTmpPrv )->( fieldPos( "CREFPRV" ) ) ];
		ID 		130 ;
      WHEN     ( nMode != ZOOM_MODE );
		OF 		oDlg

   REDEFINE GET aGet[ ( dbfTmpPrv )->( fieldPos( "NDTOPRV" ) ) ];
      VAR      aTmp[ ( dbfTmpPrv )->( fieldPos( "NDTOPRV" ) ) ];
      SPINNER ;
      ON CHANGE( oTotal:Refresh() );
      ID       140 ;
      PICTURE  "@E 999.99" ;
      WHEN     ( nMode != ZOOM_MODE );
		OF 		oDlg

   REDEFINE GET aGet[ ( dbfTmpPrv )->( fieldPos( "NDTOPRM" ) ) ];
      VAR      aTmp[ ( dbfTmpPrv )->( fieldPos( "NDTOPRM" ) ) ];
      SPINNER ;
      ON CHANGE( oTotal:Refresh() );
      ID       145 ;
      PICTURE  "@E 999.99" ;
      WHEN     ( nMode != ZOOM_MODE );
		OF 		oDlg

	/*
	Moneda__________________________________________________________________
	*/

   REDEFINE GET aGet[ ( dbfTmpPrv )->( fieldPos( "CDIVPRV" ) ) ] ;
      VAR      aTmp[ ( dbfTmpPrv )->( fieldPos( "CDIVPRV" ) ) ] ;
      VALID    cDiv( aGet[ ( dbfTmpPrv )->( fieldPos( "CDIVPRV" ) ) ], oBmpDiv, nil, nil, nil, dbfDiv, oBandera ) ;
		PICTURE	"@!";
		ID 		150 ;
      BITMAP   "LUPA" ;
      ON HELP  BrwDiv( aGet[ ( dbfTmpPrv )->( fieldPos( "CDIVPRV" ) ) ], oBmpDiv, nil, dbfDiv, oBandera ) ;
      WHEN     ( nMode != ZOOM_MODE );
		OF 		oDlg

	REDEFINE BITMAP oBmpDiv ;
      RESOURCE ( cBmpDiv( aTmp[ ( dbfTmpPrv )->( fieldPos( "CDIVPRV" ) ) ], dbfDiv ) );
		ID 		151;
      WHEN     ( nMode != ZOOM_MODE );
		OF 		oDlg

   REDEFINE GET aGet[ ( dbfTmpPrv )->( fieldPos( "NIMPPRV" ) ) ];
      VAR      aTmp[ ( dbfTmpPrv )->( fieldPos( "NIMPPRV" ) ) ];
      SPINNER ;
      ON CHANGE( oTotal:Refresh() );
      ID       160 ;
      PICTURE  cPinDiv ;
      WHEN     ( nMode != ZOOM_MODE );
		OF 		oDlg

   REDEFINE SAY oTotal PROMPT nTmpImpPrv( aTmp, dbfTmpPrv, dbfDiv, .t. ) ;
      ID       170 ;
      COLOR    CLR_GET ;
      OF       oDlg

   REDEFINE CHECKBOX aGet[ ( dbfTmpPrv )->( fieldPos( "lDefPrv" ) ) ] ;
      VAR      aTmp[ ( dbfTmpPrv )->( fieldPos( "lDefPrv" ) ) ] ;
      ID       180 ;
      WHEN     ( nMode != ZOOM_MODE );
      OF       oDlg

	REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      WHEN     ( nMode != ZOOM_MODE );
      ACTION   ( EndDetalle( aTmp, aGet, dbfTmpPrv, oBrw, nMode, oDlg, lOldPrvDef, bWhen, lOldRefPrv ) )

	REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| EndDetalle( aTmp, aGet, dbfTmpPrv, oBrw, nMode, oDlg, lOldPrvDef, bWhen, lOldRefPrv ) } )

   oDlg:bStart := {|| if( aTmp[ ( dbfTmpPrv )->( fieldPos( "lDefPrv" ) ) ], aGet[ ( dbfTmpPrv )->( fieldPos( "lDefPrv" ) ) ]:Disable(), aGet[ ( dbfTmpPrv )->( fieldPos( "lDefPrv" ) ) ]:Enable() ) }

   ACTIVATE DIALOG oDlg ON PAINT ( EvalGet( aGet ) ) CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtVta( aTmp, aGet, dbfTmpVta, oBrw, bWhen, bValid, nMode, aArt )

	local oDlg
   local oBtnOk
   local oBtnCancel
   local oSayPr1
   local oSayPr2
   local oSayVp1
   local oSayVp2
   local cSayPr1           := ""
   local cSayPr2           := ""
   local cSayVp1           := ""
   local cSayVp2           := ""
   local cSay              := Array( 6 )
   local oSay              := Array( 6 )
   local aBnfSobre         := aBenefSobre
   local oTotPnt
   local oImgArt
   local oBrwPrp1
   local oBrwPrp2
   local aValPrp1          := {}
   local aValPrp2          := {}
   local lColorPrp1        := .f.
   local lColorPrp2        := .f.
   local oTodasPrp1
   local oNingunaPrp1
   local oTodasPrp2
   local oNingunaPrp2

   if nMode == APPD_MODE
      aTmp[ ( dbfTmpVta )->( FieldPos( "CCODART" ) ) ]   := aArt[ ( dbfArticulo )->( fieldpos( "Codigo") ) ]
      aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ]   := aArt[ ( dbfArticulo )->( fieldpos( "cCodPrp1") ) ]
      aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ]   := aArt[ ( dbfArticulo )->( fieldpos( "cCodPrp2") ) ]
   end if

   /*
   Llenamos los arrays con las posibles propiedades----------------------------
   */

   aValPrp1                := aLlenaPropiedades( aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ], aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ], nMode )
   aValPrp2                := aLlenaPropiedades( aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ], aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR2" ) ) ], nMode )

   /*
   Preguntamos si la propiedad es de tipo color o no---------------------------
   */

   lColorPrp1              := retFld( aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ], dbfPro, "lColor" )
   lColorPrp2              := retFld( aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ], dbfPro, "lColor" )

   /*
   Tomamos algunos valores por defecto-----------------------------------------
   */

   cSay[1]                 := aBnfSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr1" ) ) ], 1 ) ]
   cSay[2]                 := aBnfSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr2" ) ) ], 1 ) ]
   cSay[3]                 := aBnfSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr3" ) ) ], 1 ) ]
   cSay[4]                 := aBnfSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr4" ) ) ], 1 ) ]
   cSay[5]                 := aBnfSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr5" ) ) ], 1 ) ]
   cSay[6]                 := aBnfSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr6" ) ) ], 1 ) ]

   DEFINE DIALOG oDlg RESOURCE "PREDIV" TITLE LblTitle( nMode ) + "precios por propiedades"

      /*
      Primer Browse de propiedades--------------------------------------------
      */

      oBrwPrp1                        := IXBrowse():New( oDlg ) 

      oBrwPrp1:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPrp1:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPrp1:SetArray( aValPrp1, , , .f. )

      oBrwPrp1:nMarqueeStyle          := 5
      oBrwPrp1:lRecordSelector        := .f.
      oBrwPrp1:lHScroll               := .f.

      oBrwPrp1:CreateFromResource( 100 )

      oBrwPrp1:bLDblClick  := {|| SeleccionPropiedad( aValPrp1, oBrwPrp1, oBrwPrp1:nArrayAt ) }

      with object ( oBrwPrp1:AddCol() )
         :cHeader          := "S"
         :bStrData         := {|| "" }
         :bEditValue       := {|| if( Len( aValPrp1 ) != 0, aValPrp1[ oBrwPrp1:nArrayAt ]:lSel, .f. ) }
         :nWidth           := 16
         :SetCheck( { "BSEL", "Nil16" } )
      end with

      with object ( oBrwPrp1:AddCol() )
         :cHeader          := retFld( aValPrp1[ oBrwPrp1:nArrayAt ]:cCodPrp, dbfPro )
         :bStrData         := {|| aValPrp1[ oBrwPrp1:nArrayAt ]:cDesPrp }
         :nWidth           := if( lColorPrp1, 103, 119 )
      end with

      if lColorPrp1

      with object ( oBrwPrp1:AddCol() )
         :cHeader          := "C"
         :bStrData         := {|| "" }
         :nWidth           := 16
         :bClrStd          := {|| { nRGB( 0, 0, 0), aValPrp1[ oBrwPrp1:nArrayAt ]:nColor } }
         :bClrSel          := {|| { nRGB( 0, 0, 0), aValPrp1[ oBrwPrp1:nArrayAt ]:nColor } }
         :bClrSelFocus     := {|| { nRGB( 0, 0, 0), aValPrp1[ oBrwPrp1:nArrayAt ]:nColor } }
      end with

      end if

      REDEFINE BUTTON oTodasPrp1 ;
         ID       111 ;
			OF 		oDlg ;
         ACTION   ( lSelAllPrp( aValPrp1, oBrwPrp1, .t. ) )

      REDEFINE BUTTON oNingunaPrp1 ;
         ID       112 ;
			OF 		oDlg ;
         ACTION   ( lSelAllPrp( aValPrp1, oBrwPrp1, .f. ) )

      /*
      Segundo Browse de propiedades----------------------                                                                                                                                             ---------------------
      */

      oBrwPrp2                        := IXBrowse():New( oDlg )

      oBrwPrp2:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPrp2:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPrp2:SetArray( aValPrp2, , , .f. )

      oBrwPrp2:nMarqueeStyle          := 5
      oBrwPrp2:lRecordSelector        := .f.
      oBrwPrp2:lHScroll               := .f.

      oBrwPrp2:CreateFromResource( 110 )

      oBrwPrp2:bLDblClick  := {|| SeleccionPropiedad( aValPrp2, oBrwPrp2, oBrwPrp2:nArrayAt ) }

      with object ( oBrwPrp2:AddCol() )
         :cHeader          := "S"
         :bStrData         := {|| "" }
         :bEditValue       := {|| if( Len( aValPrp2 ) != 0, aValPrp2[ oBrwPrp2:nArrayAt ]:lSel, .f. ) }
         :nWidth           := 16
         :SetCheck( { "BSEL", "Nil16" } )
      end with

      with object ( oBrwPrp2:AddCol() )
         :cHeader          := if( Len( aValPrp2 ) != 0, retFld( aValPrp2[ oBrwPrp2:nArrayAt ]:cCodPrp, dbfPro ), "" )
         :bStrData         := {|| if( Len( aValPrp2 ) != 0, aValPrp2[ oBrwPrp2:nArrayAt ]:cDesPrp, "" ) }
         :nWidth           := if( lColorPrp2, 103, 119 )
      end with

      if lColorPrp2

      with object ( oBrwPrp2:AddCol() )
         :cHeader          := "C"
         :bStrData         := {|| "" }
         :nWidth           := 16
         :bClrStd          := {|| { nRGB( 0, 0, 0), aValPrp2[ oBrwPrp2:nArrayAt ]:nColor } }
         :bClrSel          := {|| { nRGB( 0, 0, 0), aValPrp2[ oBrwPrp2:nArrayAt ]:nColor } }
         :bClrSelFocus     := {|| { nRGB( 0, 0, 0), aValPrp2[ oBrwPrp2:nArrayAt ]:nColor } }
      end with

      end if

      REDEFINE BUTTON oTodasPrp2 ;
         ID       113 ;
			OF 		oDlg ;
         ACTION   ( lSelAllPrp( aValPrp2, oBrwPrp2, .t. ) )

      REDEFINE BUTTON oNingunaPrp2 ;
         ID       114 ;
			OF 		oDlg ;
         ACTION   ( lSelAllPrp( aValPrp2, oBrwPrp2, .f. ) )

      /*
      Montamos los controles para precios por propiedades----------------------
      */

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ] ;
         ID       600 ;
         WHEN     ( !aArt[ ( dbfArticulo )->( fieldPos( "lKitArt") ) ] .and. nMode != ZOOM_MODE ) ;
         VALID    (  aGet[ ( dbfTmpVta )->( fieldpos( "Benef1" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpVta )->( fieldpos( "Benef2" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpVta )->( fieldpos( "Benef3" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpVta )->( fieldpos( "Benef4" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpVta )->( fieldpos( "Benef5" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpVta )->( fieldpos( "Benef6" ) ) ]:lValid(),;
                     .t. );
			PICTURE 	cPinDiv ;
         SPINNER ;
         OF       oDlg ;
         IDSAY    401 ;

   /*
   Tarifa1 ______________________________________________________________________________
   */

      REDEFINE CHECKBOX aGet[ ( dbfTmpVta )->( fieldpos( "lBnf1" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf1" ) ) ] ;
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "Benef1" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "Benef1" ) ) ] ;
         ID       310 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf1" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    (  lCalPre( oSay[ 1 ]:nAt <= 1,;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf1"   ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "Benef1"  ) ) ],;
                              aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta1") ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva1") ) ],;
                              nDecDiv,;
                              aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       oDlg

      REDEFINE COMBOBOX oSay[ 1 ] VAR cSay[ 1 ] ;
         ITEMS    aBnfSobre ;
         ID       320 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf1"  ) ) ],;
                        aGet[ ( dbfTmpVta )->( fieldpos( "Benef1" ) ) ]:lValid(),;
                        aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta1") )]:lValid() ) );
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta1" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta1" ) ) ] ;
         ID       330 ;
         SPINNER ;
         WHEN     ( stdCol( !aArt[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 1 ]:nAt <= 1,;
                                 aArt[ (dbfArticulo)->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta1") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef1"  ) ) ],;
                                 aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva1") ) ],;
                                 nDecDiv,;
                                 aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva1" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva1" ) ) ] ;
         ID       340 ;
         SPINNER ;
         WHEN     ( stdCol( aArt[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 1 ]:nAt <= 1,;
                                 aArt[ (dbfArticulo)->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva1") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef1"  ) ) ],;
                                 aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta1") ) ],;
                                 nDecDiv,;
                                 aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oDlg

   /*
   Tarifa2 ______________________________________________________________________________
   */

      REDEFINE CHECKBOX aGet[ ( dbfTmpVta )->( fieldpos( "lBnf2" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf2" ) ) ] ;
         ID       350 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "Benef2" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "Benef2" ) ) ] ;
         ID       360 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf2" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 2 ]:nAt <= 2,;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf2"   ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "Benef2"  ) ) ],;
                              aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta2") ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva2") ) ],;
                              nDecDiv,;
                              aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       oDlg

      REDEFINE COMBOBOX oSay[ 2 ] VAR cSay[ 2 ] ;
         ITEMS    aBnfSobre ;
         ID       370 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf2"  ) ) ],;
                        aGet[ ( dbfTmpVta )->( fieldpos( "Benef2" ) ) ]:lValid(),;
                        aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta2")) ]:lValid() ) );
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta2" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta2" ) ) ] ;
         ID       380 ;
         SPINNER ;
         WHEN     ( stdCol( !aArt[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 2 ]:nAt <= 2,;
                                 aArt[ (dbfArticulo)->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta2") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef2"  ) ) ],;
                                 aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva2") ) ],;
                                 nDecDiv,;
                                 aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva2" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva2" ) ) ] ;
         ID       390 ;
         SPINNER ;
         WHEN     ( stdCol( aArt[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 2 ]:nAt <= 2,;
                                 aArt[ (dbfArticulo)->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva2") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef2"  ) ) ],;
                                 aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta2") ) ],;
                                 nDecDiv,;
                                 aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oDlg

   /*
   Tarifa3 ______________________________________________________________________________
   */

      REDEFINE CHECKBOX aGet[ ( dbfTmpVta )->( fieldpos( "lBnf3" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf3" ) ) ] ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "Benef3" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "Benef3" ) ) ] ;
         ID       410 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf3" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(  oSay[ 3 ]:nAt <= 3,;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf3"   ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "Benef3"  ) ) ],;
                              aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta3") ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva3") ) ],;
                              nDecDiv,;
                              aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       oDlg

      REDEFINE COMBOBOX oSay[ 3 ] VAR cSay[ 3 ] ;
         ITEMS    aBnfSobre ;
         ID       420 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf3"  ) ) ],;
                        aGet[ ( dbfTmpVta )->( fieldpos( "Benef3" ) ) ]:lValid(),;
                        aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta3")) ]:lValid() ) );
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta3" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta3" ) ) ] ;
         ID       430 ;
         SPINNER ;
         WHEN     ( stdCol( !aArt[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 3 ]:nAt <= 3,;
                                 aArt[ (dbfArticulo)->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta3") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef3"  ) ) ],;
                                 aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva3") ) ],;
                                 nDecDiv,;
                                 aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva3" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva3" ) ) ] ;
         ID       440 ;
         SPINNER ;
         WHEN     ( stdCol( aArt[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 3 ]:nAt <= 3,;
                                 aArt[ (dbfArticulo)->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva3") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef3"  ) ) ],;
                                 aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta3") ) ],;
                                 nDecDiv,;
                                 aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oDlg

   /*
   Tarifa4 ______________________________________________________________________________
   */

      REDEFINE CHECKBOX aGet[ ( dbfTmpVta )->( fieldpos( "lBnf4" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf4" ) ) ] ;
         ID       450 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "Benef4" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "Benef4" ) ) ] ;
         ID       460 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf4" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 4 ]:nAt <= 4,;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf4"   ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "Benef4"  ) ) ],;
                              aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta4") ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva4") ) ],;
                              nDecDiv,;
                              aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       oDlg

      REDEFINE COMBOBOX oSay[ 4 ] VAR cSay[ 4 ] ;
         ITEMS    aBnfSobre ;
         ID       470 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf4"  ) ) ],;
                        aGet[ ( dbfTmpVta )->( fieldpos( "Benef4" ) ) ]:lValid(),;
                        aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta4")) ]:lValid() ) );
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta4" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta4" ) ) ] ;
         ID       480 ;
         SPINNER ;
         WHEN     ( stdCol( !aArt[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 4 ]:nAt <= 4,;
                                 aArt[ (dbfArticulo)->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta4") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef4"  ) ) ],;
                                 aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva4") ) ],;
                                 nDecDiv,;
                                 aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva4" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva4" ) ) ] ;
         ID       490 ;
         SPINNER ;
         WHEN     ( stdCol( aArt[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 4 ]:nAt <= 4,;
                                 aArt[ (dbfArticulo)->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva4") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef4"  ) ) ],;
                                 aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta4") ) ],;
                                 nDecDiv,;
                                 aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oDlg

   /*
   Tarifa5 ______________________________________________________________________________
   */

      REDEFINE CHECKBOX aGet[ ( dbfTmpVta )->( fieldpos( "lBnf5" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf5" ) ) ] ;
         ID       500 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "Benef5" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "Benef5" ) ) ] ;
         ID       510 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf5" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 5 ]:nAt <= 5,;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf5"   ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "Benef5"  ) ) ],;
                              aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta5") ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva5") ) ],;
                              nDecDiv,;
                              aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       oDlg

      REDEFINE COMBOBOX oSay[ 5 ] VAR cSay[ 5 ] ;
         ITEMS    aBnfSobre ;
         ID       520 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf5"  ) ) ],;
                        aGet[ ( dbfTmpVta )->( fieldpos( "Benef5" ) ) ]:lValid(),;
                        aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta5") )]:lValid() ) );
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta5" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta5" ) ) ] ;
         ID       530 ;
         SPINNER ;
         WHEN     ( stdCol( !aArt[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 5 ]:nAt <= 5,;
                                 aArt[ (dbfArticulo)->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta5") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef5"  ) ) ],;
                                 aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva5") ) ],;
                                 nDecDiv,;
                                 aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva5" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva5" ) ) ] ;
         ID       540 ;
         SPINNER ;
         WHEN     ( stdCol( aArt[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 5 ]:nAt <= 5,;
                                 aArt[ (dbfArticulo)->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva5") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef5"  ) ) ],;
                                 aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta5") ) ],;
                                 nDecDiv,;
                                 aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oDlg

   /*
   Tarifa6 ______________________________________________________________________________
   */

      REDEFINE CHECKBOX aGet[ ( dbfTmpVta )->( fieldpos( "lBnf6" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf6" ) ) ] ;
         ID       550 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "Benef6" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "Benef6" ) ) ] ;
         ID       560 ;
         SPINNER ;
         WHEN     ( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf6" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 6 ]:nAt <= 6,;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf6"   ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "Benef6"  ) ) ],;
                              aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta6") ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva6") ) ],;
                              nDecDiv,;
                              aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       oDlg

      REDEFINE COMBOBOX oSay[ 6 ] VAR cSay[ 6 ] ;
         ITEMS    aBnfSobre ;
         ID       570 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf6"  ) ) ],;
                        aGet[ ( dbfTmpVta )->( fieldpos( "Benef6" ) ) ]:lValid(),;
                        aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta6") )]:lValid() ) );
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta6" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta6" ) ) ] ;
         ID       580 ;
         SPINNER ;
         WHEN     ( stdCol( !aArt[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 6 ]:nAt <= 6,;
                                 aArt[ (dbfArticulo)->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta6") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef6"  ) ) ],;
                                 aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva6") ) ],;
                                 nDecDiv,;
                                 aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva6" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva6" ) ) ] ;
         ID       590 ;
         SPINNER ;
         WHEN     ( stdCol( aArt[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 6 ]:nAt <= 6,;
                                 aArt[ (dbfArticulo)->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva6") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef6"  ) ) ],;
                                 aArt[ (dbfArticulo)->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta6") ) ],;
                                 nDecDiv,;
                                 aArt[ (dbfArticulo)->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oDlg

      /*
      Propiedades para la web--------------------------------------------------
      */

      REDEFINE GET oImgArt ;
         VAR      aTmp[ ( dbfTmpVta )->( FieldPos( "cImgWeb" ) ) ] ;
         ID       210 ;
         BITMAP   "Lupa" ;
         ON HELP  ( GetBmp( oImgArt ) ) ;
         ON CHANGE( ChgBmp( oImgArt ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      TBtnBmp():ReDefine( 211, "photo_scenery_16",,,,,{|| ShowImageFile( aTmp[ ( dbfTmpVta )->( FieldPos( "cImgWeb" ) ) ] ) }, oDlg, .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldPos( "cToolTip" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldPos( "cToolTip" ) ) ] ;
         ID       220 ;
         OF       oDlg

      /*
      fin de propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE BUTTON oBtnOk ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( EndEdtVta( aValPrp1, aValPrp2, aTmp, aGet, oSay, cSay, oBrw, oDlg, dbfTmpVta, nMode, oBrwPrp1, oBrwPrp2 ) )

      REDEFINE BUTTON oBtnCancel ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      oDlg:bStart := {|| StartEdtVta( aTmp, aGet, nMode, oBrwPrp1, oBrwPrp2, oTodasPrp1, oNingunaPrp1, oTodasPrp2, oNingunaPrp2, oBtnOk, oBtnCancel )  }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function aLlenaPropiedades( cCodigoPropiedad, nValPrp, nMode )

   local aValores    := {}
   local nRec        := ( dbfTblPro )->( Recno() )
   local nOrdAnt     := ( dbfTblPro )->( OrdSetFocus( "cPro" ) )
   local oTemporal

   if ( dbfTblPro )->( dbSeek( cCodigoPropiedad ) )

      while ( dbfTblPro )->cCodPro == cCodigoPropiedad .and. !( dbfTblPro )->( Eof() )

         if ( nMode != EDIT_MODE ) .or. ( ( nMode == EDIT_MODE ) .and. ( ( dbfTblPro )->cCodTbl == nValPrp ) )

            oTemporal                     := SValorPropiedades()
            oTemporal:cCodPrp             := cCodigoPropiedad
            oTemporal:cValPrp             := ( dbfTblPro )->cCodTbl
            oTemporal:cDesPrp             := ( dbfTblPro )->cDesTbl
            oTemporal:nColor              := ( dbfTblPro )->nColor
            oTemporal:lSel                := ( ( dbfTblPro )->cCodTbl == nValPrp )

            aAdd( aValores, oTemporal )

         end if

         ( dbfTblPro )->( dbSkip() )

      end while

   end if

   ( dbfTblPro )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTblPro )->( dbGoTo( nRec ) )

return aValores

//--------------------------------------------------------------------------//

static function SeleccionPropiedad( aValPrp, oBrwPrp, nPos )

   aValPrp[ nPos ]:lSel   := !aValPrp[ nPos ]:lSel

   if !Empty( oBrwPrp )
      oBrwPrp:Refresh()
   end if

Return .t.

//--------------------------------------------------------------------------//

static function lSelAllPrp( aValPrp, oBrwPrp, lVal )

   local n := 0

   for n:= 1 to Len( aValPrp )
      aValPrp[ n ]:lSel    := lVal
   next

   if !Empty( oBrwPrp )
      oBrwPrp:Refresh()
   end if

return .t.

//-----------------------------------------------------------------------------

Static Function EndEdtVta( aValPrp1, aValPrp2, aTmp, aGet, oSay, cSay, oBrw, oDlg, dbfTmpVta, nMode, oBrwPrp1, oBrwPrp2 )

   local aVal1
   local aVal2
   local nContAdd    := 0
   local nContEdt    := 0
   local lSelPr1     := .f.
   local lSelPr2     := .f.

   if nMode == APPD_MODE

      do case
         case Len( aValPrp1 ) != 0 .and. Len( aValPrp2 ) == 0

            /*
            Compruebo si tengo alguna seleccionada-----------------------------
            */

            for each aVal1 in aValPrp1
               if aVal1:lsel
                  lSelPr1     := .t.
               end if   
            next

            if lSelPr1

               for each aVal1 in aValPrp1

                  if aVal1:lsel

                     if ( dbfTmpVta )->( dbSeek( aTmp[ ( dbfTmpVta )->( FieldPos( "CCODART" ) ) ] + aVal1:cCodPrp + Space( 40 ) + aVal1:cValPrp + Space( 40 ) ) )

                        aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ] := aVal1:cCodPrp
                        aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ] := aVal1:cValPrp

                        WinGather( aTmp, , dbfTmpVta, oBrw, EDIT_MODE, , .f. )

                        nContEdt++

                     else

                        aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ] := aVal1:cCodPrp
                        aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ] := aVal1:cValPrp

                        WinGather( aTmp, , dbfTmpVta, oBrw, APPD_MODE, , .f. )

                        nContAdd++

                     end if

                  end if

               next

            else

               if ( dbfTmpVta )->( dbSeek( aTmp[ ( dbfTmpVta )->( FieldPos( "CCODART" ) ) ] + aValPrp1[ oBrwPrp1:nArrayAt ]:cCodPrp + Space( 20 ) + aValPrp1[oBrwPrp1:nArrayAt]:cValPrp + Space( 20 ) ) )

                  aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp
                  aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cValPrp

                  WinGather( aTmp, , dbfTmpVta, oBrw, EDIT_MODE, , .f. )

                  nContEdt++

               else

                  aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp
                  aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cValPrp

                  WinGather( aTmp, , dbfTmpVta, oBrw, APPD_MODE, , .f. )

                  nContAdd++

               end if
            
            end if   

            msgWait( "He añadido " + AllTrim( Str( nContAdd ) ) + " registros y he modificado " + AllTrim( Str( nContEdt ) ) + " registros", "Proceso terminado con éxito", 2 )

            lLimpiarPantalla( aValPrp1, aValPrp2, aTmp, aGet, oBrwPrp1, oBrwPrp2, oSay, cSay, dbfTmpVta )

         case Len( aValPrp1 ) != 0 .and. Len( aValPrp2 ) != 0

            /*
            Compruebo si tengo alguna seleccionada-----------------------------
            */

            for each aVal1 in aValPrp1
               if aVal1:lsel
                  lSelPr1     := .t.
               end if   
            next

            for each aVal2 in aValPrp2
               if aVal2:lsel
                  lSelPr2     := .t.
               end if   
            next

            do case
               case lSelPr1 .and. lSelPr2

                  for each aVal1 in aValPrp1

                     for each aVal2 in aValPrp2

                        if aVal1:lSel .and. aVal2:lSel

                           if ( dbfTmpVta )->( dbSeek( aTmp[ ( dbfTmpVta )->( FieldPos( "CCODART" ) ) ] + aVal1:cCodPrp + aVal2:cCodPrp + aVal1:cValPrp + aVal2:cValPrp ) )

                              aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ] := aVal1:cCodPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ] := aVal1:cValPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ] := aVal2:cCodPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR2" ) ) ] := aVal2:cValPrp

                              WinGather( aTmp, , dbfTmpVta, oBrw, EDIT_MODE, , .f. )

                              nContEdt++

                           else

                              aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ] := aVal1:cCodPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ] := aVal1:cValPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ] := aVal2:cCodPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR2" ) ) ] := aVal2:cValPrp

                              WinGather( aTmp, , dbfTmpVta, oBrw, APPD_MODE, , .f. )

                              nContAdd++

                           end if

                        end if

                     next

                  next

                  msgWait( "He añadido " + AllTrim( Str( nContAdd ) ) + " registros y he modificado " + AllTrim( Str( nContEdt ) ) + " registros", "Proceso terminado con éxito", 2 )

                  lLimpiarPantalla( aValPrp1, aValPrp2, aTmp, aGet, oBrwPrp1, oBrwPrp2, oSay, cSay, dbfTmpVta )

               case !lSelPr1 .and. lSelPr2

                  for each aVal2 in aValPrp2

                     if aVal2:lSel

                        if ( dbfTmpVta )->( dbSeek( aTmp[ ( dbfTmpVta )->( FieldPos( "CCODART" ) ) ] + aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp + aVal2:cCodPrp + aValPrp1[oBrwPrp1:nArrayAt]:cValPrp + aVal2:cValPrp ) )

                           aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cValPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ] := aVal2:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR2" ) ) ] := aVal2:cValPrp

                           WinGather( aTmp, , dbfTmpVta, oBrw, EDIT_MODE, , .f. )

                           nContEdt++

                        else

                           aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cValPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ] := aVal2:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR2" ) ) ] := aVal2:cValPrp

                           WinGather( aTmp, , dbfTmpVta, oBrw, APPD_MODE, , .f. )

                           nContAdd++

                        end if

                     end if

                  next

                  msgWait( "He añadido " + AllTrim( Str( nContAdd ) ) + " registros y he modificado " + AllTrim( Str( nContEdt ) ) + " registros", "Proceso terminado con éxito", 2 )

                  lLimpiarPantalla( aValPrp1, aValPrp2, aTmp, aGet, oBrwPrp1, oBrwPrp2, oSay, cSay, dbfTmpVta )

               case lSelPr1 .and. !lSelPr2

                  for each aVal1 in aValPrp1

                     if aVal1:lSel

                        if ( dbfTmpVta )->( dbSeek( aTmp[ ( dbfTmpVta )->( FieldPos( "CCODART" ) ) ] + aVal1:cCodPrp + aValPrp2[oBrwPrp2:nArrayAt]:cCodPrp + aVal1:cValPrp + aValPrp2[oBrwPrp2:nArrayAt]:cValPrp ) )

                           aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ] := aVal1:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ] := aVal1:cValPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cValPrp

                           WinGather( aTmp, , dbfTmpVta, oBrw, EDIT_MODE, , .f. )

                           nContEdt++

                        else

                           aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ] := aVal1:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ] := aVal1:cValPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cValPrp

                           WinGather( aTmp, , dbfTmpVta, oBrw, APPD_MODE, , .f. )

                           nContAdd++

                        end if

                     end if

                  next

                  msgWait( "He añadido " + AllTrim( Str( nContAdd ) ) + " registros y he modificado " + AllTrim( Str( nContEdt ) ) + " registros", "Proceso terminado con éxito", 2 )

                  lLimpiarPantalla( aValPrp1, aValPrp2, aTmp, aGet, oBrwPrp1, oBrwPrp2, oSay, cSay, dbfTmpVta )

               case !lSelPr1 .and. !lSelPr2

                  if ( dbfTmpVta )->( dbSeek( aTmp[ ( dbfTmpVta )->( FieldPos( "CCODART" ) ) ] + aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp + aValPrp2[oBrwPrp2:nArrayAt]:cCodPrp + aValPrp1[oBrwPrp1:nArrayAt]:cValPrp + aValPrp2[oBrwPrp2:nArrayAt]:cValPrp ) )

                     aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cValPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cCodPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cValPrp

                     WinGather( aTmp, , dbfTmpVta, oBrw, EDIT_MODE, , .f. )

                     nContEdt++

                  else

                     aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cValPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cCodPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "CVALPR2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cValPrp

                     WinGather( aTmp, , dbfTmpVta, oBrw, APPD_MODE, , .f. )

                     nContAdd++

                  end if

                  msgWait( "He añadido " + AllTrim( Str( nContAdd ) ) + " registros y he modificado " + AllTrim( Str( nContEdt ) ) + " registros", "Proceso terminado con éxito", 2 )

                  lLimpiarPantalla( aValPrp1, aValPrp2, aTmp, aGet, oBrwPrp1, oBrwPrp2, oSay, cSay, dbfTmpVta )   

            end case   

      end case

   else

      aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr1") ) ]   := oSay[ 1 ]:nAt
      aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr2") ) ]   := oSay[ 2 ]:nAt
      aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr3") ) ]   := oSay[ 3 ]:nAt
      aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr4") ) ]   := oSay[ 4 ]:nAt
      aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr5") ) ]   := oSay[ 5 ]:nAt
      aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr6") ) ]   := oSay[ 6 ]:nAt

      WinGather( aTmp, aGet, dbfTmpVta, oBrw, nMode )

      oDlg:End( IDOK )

   end if

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

static function lLimpiarPantalla( aValPrp1, aValPrp2, aTmp, aGet, oBrwPrp1, oBrwPrp2, oSay, cSay, dbfTmpVta )

   local aValPrp
   local cCodArt           := aTmp[ ( dbfTmpVta )->( FieldPos( "CCODART" ) ) ]
   local cCodPrp1          := aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ]
   local cCodPrp2          := aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ]

   /*
   Desmarcamos todas las opciones en los arrays de propiedades-----------------
   */

   for each aValPrp in aValPrp1
      aValPrp:lSel         := .f.
   next

   if !Empty( oBrwPrp1 )
      oBrwPrp1:Refresh()
   end if

   for each aValPrp in aValPrp2
      aValPrp:lSel         := .f.
   next

   if !Empty( oBrwPrp2 )
      oBrwPrp2:Refresh()
   end if

   /*
   Vaciamos el array temporal y le damos los valores por defecto---------------
   */

   aCopy( dbBlankRec( dbfTmpVta ), aTmp )

   aTmp[ ( dbfTmpVta )->( FieldPos( "CCODART" ) ) ]   := cCodArt
   aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR1" ) ) ]   := cCodPrp1
   aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ]   := cCodPrp2

   cSay[1]                 := aBenefSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr1" ) ) ], 1 ) ]
   cSay[2]                 := aBenefSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr2" ) ) ], 1 ) ]
   cSay[3]                 := aBenefSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr3" ) ) ], 1 ) ]
   cSay[4]                 := aBenefSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr4" ) ) ], 1 ) ]
   cSay[5]                 := aBenefSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr5" ) ) ], 1 ) ]
   cSay[6]                 := aBenefSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr6" ) ) ], 1 ) ]

   if !Empty( aGet )
      aEval( aGet, {| o | if( !Empty( o ), o:Refresh(), ) } )
   end if

   if !Empty( oSay )
      aEval( oSay, {| o | if( !Empty( o ), o:Refresh(), ) } )
   end if

return ( .t. )

//---------------------------------------------------------------------------//
/*
Edita las asociaciones con los codigos de barras
*/

STATIC FUNCTION EdtCodebar( aTmp, aGet, dbfTmpCodebar, oBrw, bWhen, bValid, nMode, aArt )

	local oDlg
   local cOldCodebar                                     := aTmp[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ]

   aTmp[ ( dbfTmpCodebar )->( FieldPos( "cCodPr1" ) ) ]  := aArt[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ]
   aTmp[ ( dbfTmpCodebar )->( FieldPos( "cCodPr2" ) ) ]  := aArt[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ]

   DEFINE DIALOG oDlg RESOURCE "ArtCode" TITLE LblTitle( nMode ) + "codigos de barras"

      REDEFINE GET   aGet[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ] ;
            VAR      aTmp[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ] ;
            BITMAP   "Calc_16" ;
            ID       100 ;
            ON HELP  ( lCalEan13( aGet[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ] ) );
            OF       oDlg

      REDEFINE CHECKBOX aGet[ ( dbfTmpCodebar )->( fieldpos( "lDefBar" ) ) ] ;
            VAR      aTmp[ ( dbfTmpCodebar )->( fieldpos( "lDefBar" ) ) ] ;
            ID       110 ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oDlg

      /*
      Propiedades--------------------------------------------------------------
      */

      REDEFINE GET   aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr1" ) ) ] ;
            VAR      aTmp[ ( dbfTmpCodebar )->( FieldPos( "cValPr1" ) ) ] ;
            ID       120 ;
            IDSAY    122 ;
            IDTEXT   121 ;
            PICTURE  "@!" ;
            BITMAP   "LUPA" ;
            VALID    ( lPrpAct(   aTmp[ ( dbfTmpCodebar )->( FieldPos( "cValPr1" ) ) ], aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr1" ) ) ]:oHelpText, aTmp[ ( dbfTmpCodebar )->( FieldPos( "cCodPr1" ) ) ], dbfTblPro ) ) ;
            ON HELP  ( brwPrpAct( aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr1" ) ) ], aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr1" ) ) ]:oHelpText, aTmp[ ( dbfTmpCodebar )->( FieldPos( "cCodPr1" ) ) ] ) ) ;
            OF       oDlg

      REDEFINE GET   aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ] ;
            VAR      aTmp[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ] ;
            ID       130 ;
            IDSAY    132 ;
            IDTEXT   131 ;
            PICTURE  "@!" ;
            BITMAP   "LUPA" ;
            VALID    ( lPrpAct(   aTmp[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ], aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ]:oHelpText, aTmp[ ( dbfTmpCodebar )->( FieldPos( "cCodPr2" ) ) ], dbfTblPro ) ) ;
            ON HELP  ( brwPrpAct( aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ], aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ]:oHelpText, aTmp[ ( dbfTmpCodebar )->( FieldPos( "cCodPr2" ) ) ] ) ) ;
            OF       oDlg

      REDEFINE BUTTON ;
            ID       IDOK ;
            OF       oDlg ;
            ACTION   ( SaveCodebar( aTmp, aGet, cOldCodebar, oBrw, oDlg, dbfTmpCodebar, nMode ) )

      REDEFINE BUTTON ;
            ID       IDCANCEL ;
            OF       oDlg ;
            CANCEL ;
            ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| SaveCodebar( aTmp, aGet, cOldCodebar, oBrw, oDlg, dbfTmpCodebar, nMode ) } )

      oDlg:bStart          := {||   aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr1" ) ) ]:lValid(),;
                                    aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ]:lValid() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function SaveCodebar( aTmp, aGet, cOldCodebar, oBrw, oDlg, dbfTmpCodebar, nMode )

   local nRec
   local lDef  := .f.

   /*
   Búsqueda por códigos de barras en la temporal-------------------------------
   */

   if dbSeekCodebar( aTmp[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ], dbfTmpCodebar, cOldCodebar, .t. )
      aGet[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ]:SetFocus()
      aGet[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ]:SelectAll()
      return .f.
   end if

   /*
   Búsqueda por códigos de barras en la temporal-------------------------------
   */

   if dbSeekInOrd( aTmp[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ], "cCodBar", dbfCodebar )

      if ( dbfCodebar )->cCodArt != aTmp[ ( dbfTmpCodebar )->( fieldPos( "cCodArt" ) ) ] .and.;
         !ApoloMsgNoYes( "El código de barras se ha introducido para el artículo: " ;
                    + AllTrim( ( dbfCodebar )->cCodArt ) + " - " + AllTrim( RetFld( ( dbfCodebar )->cCodArt, dbfArticulo ) ) ,"¿Desea introducirlo en éste artículo?" )

         aGet[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ]:SetFocus()
         aGet[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ]:SelectAll()

         return .f.

      end if

   end if

   if aTmp[ ( dbfTmpCodebar )->( fieldpos( "lDefBar" ) ) ]

      nRec     := ( dbfTmpCodebar )->( Recno() )

      ( dbfTmpCodebar )->( dbGoTop() )
      while !( dbfTmpCodebar )->( eof() )
         ( dbfTmpCodebar )->lDefBar  := .f.
         ( dbfTmpCodebar )->( dbSkip() )
      end while

      ( dbfTmpCodebar )->( dbGoTo( nRec ) )

      lDef     := .t.

   end if

   WinGather( aTmp, aGet, dbfTmpCodebar, oBrw, nMode )

   if lEntCon() .and. nMode == APPD_MODE
      MsgWait( "Código de barras aceptado", , 0.1 )

      if lDef
         aTmp[ ( dbfTmpCodebar )->( fieldpos( "lDefBar" ) ) ] := .f.
         aGet[ ( dbfTmpCodebar )->( fieldpos( "lDefBar" ) ) ]:Refresh()
      end if

      aGet[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ]:SetFocus()
      aGet[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ]:SelectAll()
   else
      oDlg:end( IDOK )
   end if

Return .t.

//---------------------------------------------------------------------------//

Function dbSeekCodebar( cCodBar, dbfCodebar, cCodExc, lMessage )

   local lSeek
   local nOrdenAnterior
   local nRegistroAnterior

   DEFAULT cCodExc         := ""
   DEFAULT lMessage        := .t.

   if Empty( cCodBar )
      if lMessage
         MsgBeepWait( "Código de barras no puede estar vacío", "Atención", 1 )
      end if
      return .t.
   end if

   nRegistroAnterior       := ( dbfCodebar )->( Recno() )
   nOrdenAnterior          := ( dbfCodebar )->( OrdSetFocus( "cCodBar" ) )

   lSeek                   := !( dbfCodebar )->( dbSeek( cCodBar ) ) .or. cCodBar == cCodExc
   lSeek                   := !lSeek

   ( dbfCodebar )->( OrdSetFocus( nOrdenAnterior ) )
   ( dbfCodebar )->( dbGoTo( nRegistroAnterior ) )

   if lMessage .and. lSeek
      MsgBeepWait( "Código de barras ya existe", "Atención", 1 )
   end if

Return ( lSeek )

//---------------------------------------------------------------------------//

Static Function StartEdtVta( aTmp, aGet, nMode, oBrwPrp1, oBrwPrp2, oTodasPrp1, oNingunaPrp1, oTodasPrp2, oNingunaPrp2, oBtnOk, oBtnCancel )

   if nMode == APPD_MODE

      if !Empty( oBtnOk )
         SetWindowText( oBtnOk:hWnd, "Añadir" )
      end if

      if !Empty( oBtnCancel )
         SetWindowText( oBtnCancel:hWnd, "Salir" )
      end if

   else

      if !Empty( oBtnOk )
         SetWindowText( oBtnOk:hWnd, "Aceptar" )
      end if

      if !Empty( oBtnCancel )
         SetWindowText( oBtnCancel:hWnd, "Cancelar" )
      end if

   end if

   if !Empty( oBrwPrp1 ) .and. !Empty( oTodasPrp1 ) .and. !Empty( oNingunaPrp1 )

      if nMode == EDIT_MODE

         oBrwPrp1:Disable()
         oTodasPrp1:Disable()
         oNingunaPrp1:Disable()

      end if

   end if

   if !Empty( oBrwPrp2 ) .and. !Empty( oTodasPrp2 ) .and. !Empty( oNingunaPrp2 )

      if !Empty( aTmp[ ( dbfTmpVta )->( FieldPos( "CCODPR2" ) ) ] )

         oBrwPrp2:Show()
         oTodasPrp2:Show()
         oNingunaPrp2:Show()

         if nMode == EDIT_MODE

            oBrwPrp2:Disable()
            oTodasPrp2:Disable()
            oNingunaPrp2:Disable()

         end if

      else

         oBrwPrp2:Hide()
         oTodasPrp2:Hide()
         oNingunaPrp2:Hide()

      end if

   end if

Return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtKit( aTmp, aGet, dbfTmpKit, oBrw, bWhen, bValid, nMode, aTmpArt )

	local oDlg
   local oCos
   local nCos     := 0
   local oValorTot
   local oBtnOk

   if nMode != APPD_MODE
      nCos        := nCosto( aTmp[ ( dbfTmpKit )->( fieldpos( "CREFKIT" ) ) ], dbfArticulo, dbfArtKit, )
   end if

   DEFINE DIALOG oDlg RESOURCE "ARTKIT" TITLE LblTitle( nMode ) + "escandallos"

      REDEFINE GET aGet[ ( dbfTmpKit )->( fieldpos( "CREFKIT" ) ) ] ;
         VAR      aTmp[ ( dbfTmpKit )->( fieldpos( "CREFKIT" ) ) ];
			PICTURE	"@!" ;
			WHEN 		( nMode == APPD_MODE ) ;
         VALID    ( ChkCodKit( aGet, oCos, dbfTmpKit ) ) ;
			ID 		100 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwSelArticulo( aGet[ ( dbfTmpKit )->( fieldpos( "CREFKIT" ) ) ], nil, .f., .f., .f. );
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpKit )->( fieldpos( "CDESKIT" ) ) ];
         VAR      aTmp[ ( dbfTmpKit )->( fieldpos( "CDESKIT" ) ) ];
			PICTURE	"@!" ;
			WHEN 		( .F. ) ;
			ID 		110 ;
			OF 		oDlg

      REDEFINE GET aGet[ ( dbfTmpKit )->( fieldpos( "NUNDKIT" ) ) ] ;
         VAR      aTmp[ ( dbfTmpKit )->( fieldpos( "NUNDKIT" ) ) ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         SPINNER ;
         PICTURE  "@E 999,999.999999" ;
         ID       120 ;
			OF 		oDlg

      aGet[ ( dbfTmpKit )->( fieldpos( "nUndKit" ) ) ]:bHelp   := {|| Calculadora( 0, aGet[ ( dbfTmpKit )->( fieldpos( "nUndKit" ) ) ], .f. ) }

      REDEFINE GET aGet[ ( dbfTmpKit )->( fieldpos( "CUNIDAD" ) ) ] ;
         VAR      aTmp[ ( dbfTmpKit )->( fieldpos( "CUNIDAD" ) ) ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@!" ;
         ID       130 ;
         OF       oDlg

      REDEFINE GET oCos VAR nCos ;
         WHEN     ( .f. ) ;
         PICTURE  cPinDiv ;
         ID       140 ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfTmpKit )->( fieldpos( "lAplDto" ) ) ] ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfTmpKit )->( fieldpos( "lExcPro" ) ) ] ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON oBtnOk ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( lPreSaveKit( aGet, aTmp, dbfTmpKit, dbfArticulo, oBrw, nMode, oDlg, aTmpArt ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )


   oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Function lPreSaveKit( aGet, aTmp, dbfTmpKit, dbfArticulo, oBrw, nMode, oDlg, aTmpArt, nCos )

   if Empty( aTmp[ ( dbfTmpKit )->( fieldpos( "CREFKIT" ) ) ] )
      msgstop( "El código no puede estar vacío" )
      aGet[ ( dbfTmpKit )->( fieldpos( "CREFKIT" ) ) ]:SetFocus()
      Return .f.
   end if

   if aTmp[ ( dbfTmpKit )->( fieldpos( "CREFKIT" ) ) ] == aTmpArt[ ( dbfArticulo )->( FieldPos( "Codigo" ) ) ]
      MsgStop( "El código es el mismo que el del escandallo", "No se puede introducir" )
      aGet[ ( dbfTmpKit )->( fieldpos( "CREFKIT" ) ) ]:SetFocus()
      Return .f.
   end if

   if IsMuebles() .and. nCos != nil
      aTmp[ ( dbfTmpKit )->( fieldpos( "nPreKit" ) ) ] := nCos
   end if

   WinGather( aTmp, aGet, dbfTmpKit, oBrw, nMode )

return ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

Static Function ChkCodKit( aGet, oCos, dbfTmpKit )

	local lRet		:= .f.
   local cRefKit  := aGet[ ( dbfTmpKit )->( fieldpos( "cRefKit" ) ) ]:varGet()
   local nRecKit  := ( dbfTmpKit   )->( recno() )
	local nRecArt	:= ( dbfArticulo )->( recno() )

   cRefKit        := cSeekCodebar( cRefKit, dbfCodebar, dbfArticulo )

   if dbSeekInOrd( cRefKit, "Codigo", dbfArticulo )

      if dbSeekInOrd( cRefKit, "cRefKit", dbfTmpKit )

         msgStop( "Código duplicado" )

      else

         aGet[ ( dbfTmpKit )->( fieldpos( "cRefKit" ) ) ]:cText( ( dbfArticulo )->Codigo  )
         aGet[ ( dbfTmpKit )->( fieldpos( "cDesKit" ) ) ]:cText( ( dbfArticulo )->Nombre  )
         aGet[ ( dbfTmpKit )->( fieldpos( "cUnidad" ) ) ]:cText( ( dbfArticulo )->cUnidad )

         oCos:cText( ( dbfArticulo )->pCosto )

         lRet     := .t.

      end if

   else

      msgStop( "Código no existe" )

   end if

	( dbfArticulo )->( dbGoTo( nRecArt ) )
   ( dbfTmpKit   )->( dbGoTo( nRecKit ) )

Return ( lRet )

//--------------------------------------------------------------------------//

STATIC FUNCTION GetDisk()

	local oDlg
	local oFileName
	local cFileName
	local oProvee
   local cProvee     := Space( 12 )
	local oProvName
   local cProvName   := ""
	local oTipIva
	local cTipIva
	local oIvaName
	local cIvaName
   local nPrc        := 0
	local oPrc
   local oPctBnf1
   local oPctBnf2
   local oPctBnf3
   local oPctBnf4
   local oPctBnf5
   local oPctBnf6
   local nPctBnf1    := 0
	local nPctBnf2		:= 0
   local nPctBnf3    := 0
   local nPctBnf4    := 0
   local nPctBnf5    := 0
   local nPctBnf6    := 0
   local lEnd        := .t.

   DEFINE DIALOG oDlg RESOURCE "Infortisa"

      REDEFINE GET oFileName VAR cFileName;
			ID 		100 ;
         BITMAP   "FOLDER" ;
         ON HELP  ( oFileName:cText( cGetFile( "*.dbf", "Selección de fichero" ) ) ) ;
			OF 		oDlg

      REDEFINE GET oPctBnf1 VAR nPctBnf1 ;
         PICTURE  "@E 999.99" ;
			ID 		110 ;
			OF 		oDlg

		REDEFINE GET oPctBnf2 VAR nPctBnf2 ;
         PICTURE  "@E 999.99" ;
         ID       111 ;
			OF 		oDlg

      REDEFINE GET oPctBnf3 VAR nPctBnf3 ;
         PICTURE  "@E 999.99" ;
         ID       112 ;
			OF 		oDlg

      REDEFINE GET oPctBnf4 VAR nPctBnf4 ;
         PICTURE  "@E 999.99" ;
         ID       113 ;
			OF 		oDlg

      REDEFINE GET oPctBnf5 VAR nPctBnf5 ;
         PICTURE  "@E 999.99" ;
         ID       114 ;
			OF 		oDlg

      REDEFINE GET oPctBnf6 VAR nPctBnf6 ;
         PICTURE  "@E 999.99" ;
         ID       115 ;
         OF       oDlg

      REDEFINE GET oTipIva VAR cTipIva ;
			ID 		120 ;
			PICTURE	"@!" ;
         VALID    ( cTiva( oTipIva, dbfIva, oIvaName ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( oTipIva, nil , oIvaName ) ) ;
			OF 		oDlg

		REDEFINE GET oIvaName VAR cIvaName ;
			WHEN 		.F. ;
			ID 		121 ;
			OF 		oDlg

      REDEFINE GET oProvee VAR cProvee ;
			ID 		130 ;
         PICTURE  ( Replicate( "X", RetNumCodPrvEmp() ) );
         VALID    ( cProvee( oProvee, , oProvName ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwProvee( oProvee, oProvName, .f. ) ) ;
			OF 		oDlg

		REDEFINE GET oProvName VAR cProvName ;
			WHEN 		.F. ;
			ID 		131 ;
			OF 		oDlg

      REDEFINE METER oPrc;
         VAR      nPrc ;
         PROMPT   "Procesando" ;
         ID       140 ;
         OF       oDlg ;
         TOTAL    ( dbfArticulo )->( lastrec() )

		REDEFINE BUTTON ;
         ID       500 ;
			OF 		oDlg ;
         ACTION   (If( ImpTarifa( cFileName, nPctBnf1, nPctBnf2, nPctBnf3, nPctBnf4, nPctBnf5, nPctBnf6, cTipIva, cProvee, oPrc, @lEnd  ),;
                     ( oDlg:end( IDOK ) ), ) )

		REDEFINE BUTTON ;
         ID       510 ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER VALID lEnd

   oWndBrw:Refresh()

RETURN NIL
*/
//-------------------------------------------------------------------------//

Static Function ImpTarifa( cFileName, nPctBnf1, nPctBnf2, nPctBnf3, nPctBnf4, nPctBnf5, nPctBnf6, cTipIva, cProvee, oPrc, lEnd )

   local oBlock
   local oError
   local dbfExt
   local nPctIva  := 0
   local cCodFam  := ""
   local cCodArt  := ""
   local cNomArt  := ""
   local aStaArt  := aGetStatus( dbfArticulo, .t. )
   local aStaPrv  := aGetStatus( dbfArtPrv )

   ( dbfArtPrv )->( OrdSetFocus( "cRefPrv" ) )

	CursorWait()

   lEnd              := .f.

   if File ( cFileName )

      oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cFileName ) NEW VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "EXTFIL", @dbfExt ) )

      nPctIva        := nIva( dbfIva, cTipIva )
      oPrc:nTotal    := ( dbfExt )->( LastRec() + 1 )

      while !( dbfExt )->( Eof() )

         /*
         Comprobamos si existe la familia--------------------------------------
         */

         cCodFam     := cCodFamPrv( cProvee, ( dbfExt )->CodSubFami, dbfFamPrv )
         cCodArt     := Rtrim( cCodFam ) + "." + ( dbfExt )->Codigo

         if !( dbfArticulo )->( dbSeek( cCodArt ) )
            ( dbfArticulo  )->( dbAppend() )
            cNomArt  := OemToAnsi( ( dbfExt )->Titulo )
         else
            ( dbfArticulo )->( dbRLock() )
            cNomArt  := ( dbfArticulo )->Nombre
         end if

         /*
         Si ya existe el Articulo ten solo modificamos precios y sobreescribimos el proveedor por si acaso
         */

         ( dbfArticulo )->Codigo  := cCodArt
         ( dbfArticulo )->Nombre  := cNomArt
         ( dbfArticulo )->Familia := cCodFam
         ( dbfArticulo )->pCosto  := ( dbfExt )->Precio

         ( dbfArticulo )->Benef1  := nPctBnf1
         ( dbfArticulo )->Benef2  := nPctBnf2
         ( dbfArticulo )->Benef3  := nPctBnf3
         ( dbfArticulo )->Benef4  := nPctBnf4
         ( dbfArticulo )->Benef5  := nPctBnf5
         ( dbfArticulo )->Benef6  := nPctBnf6

         ( dbfArticulo )->pVenta1 := ( ( dbfArticulo )->PCOSTO * nPctBnf1 / 100 ) + ( dbfArticulo )->PCOSTO
         ( dbfArticulo )->pVenta2 := ( ( dbfArticulo )->PCOSTO * nPctBnf2 / 100 ) + ( dbfArticulo )->PCOSTO
         ( dbfArticulo )->pVenta3 := ( ( dbfArticulo )->PCOSTO * nPctBnf3 / 100 ) + ( dbfArticulo )->PCOSTO
         ( dbfArticulo )->pVenta4 := ( ( dbfArticulo )->PCOSTO * nPctBnf4 / 100 ) + ( dbfArticulo )->PCOSTO
         ( dbfArticulo )->pVenta5 := ( ( dbfArticulo )->PCOSTO * nPctBnf5 / 100 ) + ( dbfArticulo )->PCOSTO
         ( dbfArticulo )->pVenta6 := ( ( dbfArticulo )->PCOSTO * nPctBnf6 / 100 ) + ( dbfArticulo )->PCOSTO

         ( dbfArticulo )->pVtaIva1:= Round( ( ( dbfArticulo )->PVENTA1 * nPctIva / 100 ) + ( dbfArticulo )->PVENTA1, nDecDiv )
         ( dbfArticulo )->pVtaIva2:= Round( ( ( dbfArticulo )->PVENTA2 * nPctIva / 100 ) + ( dbfArticulo )->PVENTA2, nDecDiv )
         ( dbfArticulo )->pVtaIva3:= Round( ( ( dbfArticulo )->PVENTA3 * nPctIva / 100 ) + ( dbfArticulo )->PVENTA3, nDecDiv )
         ( dbfArticulo )->pVtaIva4:= Round( ( ( dbfArticulo )->PVENTA4 * nPctIva / 100 ) + ( dbfArticulo )->PVENTA4, nDecDiv )
         ( dbfArticulo )->pVtaIva5:= Round( ( ( dbfArticulo )->PVENTA5 * nPctIva / 100 ) + ( dbfArticulo )->PVENTA5, nDecDiv )
         ( dbfArticulo )->pVtaIva6:= Round( ( ( dbfArticulo )->PVENTA6 * nPctIva / 100 ) + ( dbfArticulo )->PVENTA6, nDecDiv )

         ( dbfArticulo )->TipoIva := cTipIva
         ( dbfArticulo )->lObs    := .f.

         ( dbfArticulo )->( dbUnLock() )

         oPrc:Set( ( dbfExt )->( RecNo() ) )

         /*
         Referencia de los proveedores--------------------------------------
         */

         if !( dbfArtPrv )->( dbSeek( cProvee + ( dbfExt )->Codigo ) )
            ( dbfArtPrv )->( dbAppend() )
         else
            ( dbfArtPrv )->( dbRLock() )
         end if

         ( dbfArtPrv )->cCodArt  := cCodArt
         ( dbfArtPrv )->cCodPrv  := cProvee
         ( dbfArtPrv )->cRefPrv  := ( dbfExt )->Codigo
         ( dbfArtPrv )->cDivPrv  := cDivEmp()

         ( dbfArtPrv )->( dbUnLock() )

         ( dbfExt )->( dbSkip() )

         oPrc:Set( ( dbfExt )->( RecNo() ) )

         SysRefresh()

      end while

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos de articulos" + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

      ( dbfExt )->( dbClosearea() )

   else

      MsgStop( "El fichero no existe" )

   end if

   SetStatus( dbfArticulo, aStaArt )
   SetStatus( dbfArtPrv,   aStaPrv )

   CursorWE()

   lEnd           := .t.

Return .t.

//----------------------------------------------------------------------------//

/*
Calcula el precio de venta segun el precio de costo y el porcentaje de beneficio
*/

Function CalPre( lSobreCoste, nCosto, lBnf, nBnf, uTipIva, oGetPrePts, oGetIvaPts, nDecDiv, cCodImp, oSay )

	local nIvaPct
   local nNewPre  := 0
   local nNewIva  := 0

   /*
   El beneficio sobre la venta no puede ser major que el 100%----------------------
   */

   if !lSobreCoste .and. nBnf >= 100
      Return nNewPre
   end if

   if lBnf .and. nCosto != 0

      if ValType( uTipIva ) == "C"
         nIvaPct  := nIva( dbfIva, uTipIva )
      else
         nIvaPct  := uTipIva
      end if

      if lSobreCoste
         nNewPre  := Round( ( nCosto * nBnf / 100 ) + nCosto, nDecDiv )
      else
         nNewPre  := Round( Div( nCosto, ( 1 - ( nBnf / 100 ) ) ), nDecDiv )
      end if

      if oGetPrePts != nil
         oGetPrePts:cText( nNewPre )
      end if

      /*
      Calculo del impuestos
      */

      nNewIva     := nNewPre

      /*
      Si tiene impuesto especial añadirlo
      */

      if !Empty( cCodImp ) .and. !Empty( oNewImp )
         nNewIva  += oNewImp:nValImp( cCodImp, .t., nIvaPct )
      end if

      nNewIva     += Round( ( nNewIva * nIvaPct / 100 ), nDecDiv )

      if oGetIvaPts != nil
         oGetIvaPts:cText( nNewIva )
      end if

   end if

   if oSay != nil
      oSay:Refresh()
   end if

Return nNewPre

//----------------------------------------------------------------------------//

Function lCalPre( lSobreCoste, nCosto, lBnf, nBnf, uTipIva, oGetPrePts, oGetIvaPts, nDecDiv, cCodImp, oSay )

   CalPre( lSobreCoste, nCosto, lBnf, nBnf, uTipIva, oGetPrePts, oGetIvaPts, nDecDiv, cCodImp, oSay )

return .t.

//---------------------------------------------------------------------------//

Function cImgArticulo( aTmp )

   local cImagenArt

   if !Empty ( aTmp[ ( dbfArticulo )->( fieldpos( "cImagen" ) ) ] )
      cImagenArt  := aTmp[ ( dbfArticulo )->( fieldpos( "cImagen" ) ) ]
   else
      cImagenArt  := cFirstImage( aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ], dbfImg )
   end if

   if Empty( GetPath( cImagenArt ) )
      cImagenArt  := uFieldEmpresa( "cDirImg" ) + "\" + cImagenArt
   end if

return cImagenArt

//---------------------------------------------------------------------------//

/*
Esta funci¢n calcula el beneficio que se esta aplicando a un articulo sin impuestos
*/

Function CalBnfPts( lSobreCoste, lIvaInc, nCosto, nPrePts, oBnf, uTipIva, oGetIvaPts, nDecDiv, cCodImp, oSay, lMargenAjuste, cMargenAjuste )

	local nNewBnf
   local nIvaPct
   local nNewIva  := nPrePts

   if lIvaInc
      return .t.
   end if

   if nCosto != 0

      nPrePts     := Round( nPrePts, nDecDiv )

      nNewBnf     := nPorcentajeBeneficio( lSobreCoste, nPrePts, nCosto )

		/*
		Solo procedemos si el % de beneficio es != 0

      if lSobreCoste
         nNewBnf  := ( Div( nPrePts, nCosto ) - 1 ) * 100
      else
         nNewBnf  := ( 1 - Div( nCosto, nPrePts ) ) * 100
      end if
      */

      /*
		Proteccion contra limites
		*/

      if nNewBnf > 0 .and. nNewBnf < 999
			oBnf:cText( nNewBnf )
      else
			oBnf:cText( 0 )
      end

   end if

   /*
   Tipos de impuestos
   */

   if ValType( uTipIva ) == "C"
      nIvaPct     := nIva( dbfIva, uTipIva )
   else
      nIvaPct     := uTipIva
   end if

   /*
   Despues si tiene impuesto especial
   */

   if !Empty( cCodImp ) .and. !Empty( oNewImp )
      nNewIva     += oNewImp:nValImp( cCodImp, .t., nIvaPct )
   end if

	/*
   Calculo del impuestos
	*/

   nNewIva        += ( nNewIva * nIvaPct / 100 )

   /*
   if IsLogic( lMargenAjuste )
      nNewIva     := nAjuste( nNewIva, cMargenAjuste )
   end if
   */

   if oGetIvaPts != nil
		oGetIvaPts:cText( nNewIva )
   end if

   if oSay != nil
      oSay:Refresh()
   end if

Return .t.

//----------------------------------------------------------------------------//

/*
Esta funci¢n calcula el beneficio que se esta aplicando a un articulo con impuestos
*/

Function CalBnfIva( lSobreCoste, lIvaInc, nCosto, uPrecioIva, oBnf, uTipIva, oGetBas, nDecDiv, cCodImp, oSay, lMargenAjuste, cMargenAjuste )

	local nNewBnf
	local nNewPre
	local nIvaPct
   local nPreIva

   if !lIvaInc
      Return .t.
   end if

   if IsChar( uTipIva )
      nIvaPct     := nIva( dbfIva, uTipIva )
   else
      nIvaPct     := uTipIva
   end if

   if IsObject( uPrecioIva )
      nPreIva     := Round( uPrecioIva:VarGet(), nDecDiv )
   else
      nPreIva     := Round( uPrecioIva, nDecDiv )
   end if

   /*
   Margen de ajuste
   */

   if IsTrue( lMargenAjuste )
      
      nPreIva     := nAjuste( nPreIva, cMargenAjuste )

      if IsObject( uPrecioIva )
         uPrecioIva:cText( Round( nPreIva, nDecDiv ) )
      end if 

   end if

	/*
   Primero es quitar el impuestos
	*/

   nNewPre        := Round( nPreIva / ( 1 + nIvaPct / 100 ), nDecDiv )

   /*
   Despues si tiene impuesto especial qitarlo
   */

   if !Empty( cCodImp ) .and. !Empty( oNewImp )
      nNewPre     -= oNewImp:nValImp( cCodImp, lIvaInc , nIvaPct )
   end if

	/*
	Actualizamos la base
	*/

   oGetBas:cText( nNewPre )

	/*
	Solo procedemos si el % de beneficio es != 0
	*/

   if nCosto != 0

      nNewBnf     := nPorcentajeBeneficio( lSobreCoste, nNewPre, nCosto )

      /*
      if lSobreCoste
         nNewBnf  := ( Div( nNewPre, nCosto ) - 1 ) * 100
      else
         nNewBnf  := ( 1 - Div( nCosto, nNewPre ) ) * 100
      end if
      */

      if nNewBnf > 0 .and. nNewBnf < 999
			oBnf:cText( nNewBnf )
      else
			oBnf:cText( 0 )
      end if

   end if

   if oSay != nil
      oSay:Refresh()
   end if

Return .t.

//----------------------------------------------------------------------------//

Static Function nPorcentajeBeneficio( lSobreCoste, nPrecioVenta, nPrecioCosto )

   local nPorcentajeBeneficio := 0

   if lSobreCoste
      nPorcentajeBeneficio    := ( Div( nPrecioVenta, nPrecioCosto ) - 1 ) * 100
   else
      nPorcentajeBeneficio    := ( 1 - Div( nPrecioCosto, nPrecioVenta ) ) * 100
   end if

Return ( nPorcentajeBeneficio )

//----------------------------------------------------------------------------//

Static Function CalDtoWeb( nImpVta, cTipIva, nDtoInt, oImpInt, oImpIva, lSbrInt )

   local nImpWeb

   if lSbrInt

      nImpWeb     := nImpVta - ( nImpVta * nDtoInt / 100 )

      oImpInt:cText( nImpWeb )
      oImpIva:cText( ( nImpWeb * nIva( dbfIva, cTipIva ) / 100 ) + nImpWeb )

   end if

return .t.

//----------------------------------------------------------------------------//

//
// Devuelve si tenemos los precios en los componentes
//
/*
FUNCTION lPrcKit( cCodArt, dbfArticulo )

   local lTmp     := .f.
   local aSta     := aGetStatus( dbfArticulo, .t. )

   if ( dbfArticulo )->( DbSeek( cCodArt ) )
      lTmp        := ( dbfArticulo )->lKitArt .and. !( dbfArticulo )->lKitPrc
   end if

   SetStatus( dbfArticulo, aSta )

RETURN ( !lTmp )
*/
//---------------------------------------------------------------------------//

/*FUNCTION BrwArt( oGet, dbfArticulo, dbfDiv, dbfArtKit, dbfIva )

	local oDlg
   local oFld
	local oBrw
   local oBtnAdd
   local oBtnEdt
	local oGet1
	local cGet1
	local oCbxOrd
   local cCbxOrd     := 'Nombre'
   local aCbxOrd     := { 'Código', 'Nombre' }
   local nRecAnt     := ( dbfArticulo )->( Recno() )
   local nOrdAnt     := ( dbfArticulo )->( OrdSetFocus( 'Nombre' ) )

#ifndef __PDA__
   if !OpenFiles( .t. )
      return nil
   end if
#else
   if !pdaOpenFiles( .t. )
      return nil
   end if
#endif

   ( dbfArticulo )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar artículos"

      REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfArticulo, .t. ) );
         VALID    ( OrdClearScope( oBrw, dbfArticulo ) );
			PICTURE	"@!" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfArticulo )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )
      oBrw:lAutoSort       := .t.

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfArticulo
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Artículos"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Codigo"
         :bEditValue       := {|| ( dbfArticulo )->Codigo }
         :nWidth           := 90
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Nombre"
         :bEditValue       := {|| ( dbfArticulo )->Nombre }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Stocks"
         :bStrData         := {|| Trans( oStock:nTotStockAct( ( dbfArticulo )->Codigo, , , , , lEscandallo( dbfArticulo ), ( dbfArticulo )->nKitStk, ( dbfArticulo )->nCtlStock ), cPicUnd ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" ) + " impuestos inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 2, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" ) + " impuestos inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 2, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 3, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" ) + " impuestos inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 3, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 4, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" ) + " impuestos inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 4, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 5, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" ) + " impuestos inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 5, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 6, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" ) + " impuestos inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 6, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      if ( oUser():lCostos() )

      with object ( oBrw:AddCol() )
         :cHeader          := "Costo"
         :bStrData         := {|| if( oUser():lNotCostos(), "", nCosto( nil, dbfArticulo, dbfArtKit, .t., if( lEuro, cDivChg(), cDivEmp() ), dbfDiv ) ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      end if

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      REDEFINE BUTTON oBtnAdd ;
			ID 		500 ;
			OF 		oDlg ;
         ACTION   ( nil )

      REDEFINE BUTTON oBtnEdt;
			ID 		501 ;
			OF 		oDlg ;
         ACTION   ( nil )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )

      oDlg:bStart := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBtnAdd:Hide(), oBtnEdt:Hide() )

   if oDlg:nResult == IDOK
      oGet:cText( ( dbfArticulo )->Codigo )
      oGet:lValid()
   end if

	( dbfArticulo )->( OrdSetFocus( nOrdAnt ) )
	( dbfArticulo )->( dbGoTo( nRecAnt ) )

Return ( oDlg:nResult == IDOK )*/

//---------------------------------------------------------------------------//

FUNCTION BrwFamiliaArticulo( oGet, oGet2, lCodeBar, lAppend )

   local oDlg
   local oBrw
   local oBrwFam
   local cPouDiv
   local oGetArticulo
   local cGetArticulo:= Space( 100 )
   local oGetFamilia
   local cGetFamilia := Space( 100 )
   local oCbxFamilia
   local cCbxFamilia := 'Nombre'
   local aCbxFamilia := { 'Código', 'Nombre' }
   local oCbxOrd
   local cCbxOrd     := 'Familia + Código'
   local aCbxOrd     := { 'Código', 'Nombre', 'Familia + Código', 'Familia + Nombre' }
   local nLevel      := nLevelUsr( "01014" )

   DEFAULT lCodeBar  := .f.

   if !OpenFiles( .t. )
      return nil
   end if

   ( dbfFam      )->( OrdSetFocus( "cNomFam" ) )
   ( dbfArticulo )->( OrdSetFocus( "cFamCod" ) )

   cPouDiv           := cPouDiv( cDivEmp(), dbfDiv )

   DEFINE DIALOG oDlg RESOURCE "HELPARTFAM" TITLE "Artículos"

      REDEFINE GET oGetFamilia VAR cGetFamilia;
         ID       106 ;
         PICTURE  "@!" ;
         ON CHANGE( if( AutoSeek( nKey, nFlags, Self, oBrwFam, dbfFam, .t. ), SeekFamilia( dbfFam, dbfArticulo, oCbxOrd, oBrw ), ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxFamilia ;
         VAR      cCbxFamilia ;
         ID       107 ;
         ITEMS    aCbxFamilia ;
         ON CHANGE( ( dbfFam )->( ordSetFocus( oCbxFamilia:nAt ) ), ( dbfFam )->( dbGoTop() ), oBrwFam:Refresh() );
         OF       oDlg

      oBrwFam                 := IXBrowse():New( oDlg )

      oBrwFam:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwFam:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwFam:cAlias          := dbfFam
      oBrwFam:nMarqueeStyle   := 5
      oBrwFam:cName           := "Browse.Familias en artículos"

      with object ( oBrwFam:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodFam"
         :bEditValue       := {|| ( dbfFam )->cCodFam }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxFamilia:Set( oCol:cHeader ) }
      end with

      with object ( oBrwFam:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomFam"
         :bEditValue       := {|| ( dbfFam )->cNomFam }
         :nWidth           := 120
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxFamilia:Set( oCol:cHeader ) }
      end with

      oBrwFam:bChange      := {|| SeekFamilia( dbfFam, dbfArticulo, oCbxOrd, oBrw ) }

      oBrwFam:CreateFromResource( 103 )

      REDEFINE GET oGetArticulo VAR cGetArticulo;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfArticulo, .t., if( ( dbfArticulo )->( OrdSetFocus() ) $ "CFAMCOD CFAMNOM", ( dbfFam )->cCodFam, ) ) );
         PICTURE  "@!" ;
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfArticulo )->( ordSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGetArticulo:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfArticulo
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Artículos"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Codigo"
         :bEditValue       := {|| ( dbfArticulo )->Codigo }
         :nWidth           := 90
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Nombre"
         :bEditValue       := {|| ( dbfArticulo )->Nombre }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      /*with object ( oBrw:AddCol() )
         :cHeader          := "Stocks"
         :bStrData         := {|| Trans( oStock:nTotStockAct( ( dbfArticulo )->Codigo, , , , , lEscandallo( dbfArticulo ), ( dbfArticulo )->nKitStk, ( dbfArticulo )->nCtlStock ), cPicUnd ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with*/

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" ) + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 2, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" ) + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 2, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 3, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" ) + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 3, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 4, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" ) + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 4, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 5, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" ) + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 5, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 6, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" ) + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 6, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      if oUser():lCostos()

      with object ( oBrw:AddCol() )
         :cHeader          := "Costo"
         :bStrData         := {|| nCosto( nil, dbfArticulo, dbfArtKit, .t., if( lEuro, cDivChg(), cDivEmp() ), dbfDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      end if

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 );
         ACTION   ( WinAppRec( oBrw, bEdit, dbfArticulo ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 );
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfArticulo ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F2,       {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfArticulo ), ) } )
      oDlg:AddFastKey( VK_F3,       {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfArticulo ), ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )

      oDlg:bStart := {|| oBrwFam:Load(), oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      if lCodeBar
         oGet:cText( ( dbfArticulo )->CodeBar )
      else
         oGet:cText( ( dbfArticulo )->Codigo )
      end if

      if oGet2 != nil
         oGet2:cText( ( dbfArticulo )->Nombre )
      end if

   end if

   CloseFiles()

   /*
   Guardamos los datos del browse
   */

   oBrw:CloseData()

RETURN oDlg:nResult == IDOK

//---------------------------------------------------------------------------//

Static Function SeekFamilia( dbfFam, dbfArticulo, oCbxOrd, oBrw )

   ( dbfArticulo )->( OrdScope( 0, nil ) )
   ( dbfArticulo )->( OrdScope( 1, nil ) )

   if !Empty( ( dbfFam )->cCodFam ) .and. ( dbfArticulo )->( dbSeek( ( dbfFam )->cCodFam ) )

      ( dbfArticulo )->( OrdScope( 0, ( dbfFam )->cCodFam ) )
      ( dbfArticulo )->( OrdScope( 1, ( dbfFam )->cCodFam ) )

   end if

   ( dbfArticulo )->( dbGoTop() )

   oCbxOrd:Set( 'Familia + Código' )

   oBrw:Refresh()

Return .t.

//---------------------------------------------------------------------------//

FUNCTION cArticulo( aGet, dbfArticulo, aGet2, lCodeBar )

   local oBlock
   local oError
	local nOrdAnt
	local lClose 		:= .F.
	local lValid		:= .F.
	local cCodArt		:= aGet:varGet()

	DEFAULT lCodeBar	:= .F.

	IF Empty( cCodArt ) .or. ( cCodArt == Replicate( "Z", 18 ) )
		RETURN .T.
	END IF

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

	IF dbfArticulo == NIL
      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE
		lClose := .T.
	END IF

	IF lCodeBar
		nOrdAnt	:= ( dbfArticulo )->( ordSetFocus( "CODEBAR" ) )
   ELSE
      nOrdAnt  := ( dbfArticulo )->( ordSetFocus( "CODIGO" ) ) 
	END IF

	IF (dbfArticulo)->( DbSeek( cCodArt ) )

		IF lCodeBar
			aGet:cText( (dbfArticulo)->CODEBAR )
		ELSE
			aGet:cText( (dbfArticulo)->CODIGO )
		END IF

      IF aGet2 != nil
			aGet2:cText( (dbfArticulo)->NOMBRE )
		END IF

      lValid   := .t.

	ELSE

      msgStop( "Artículo no encontrado", "Cadena buscada : " + cCodArt )

	END IF

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   IF lClose
		CLOSE( dbfArticulo )
	END IF

	IF lCodeBar
		( dbfArticulo )->( ordSetFocus( nOrdAnt ) )
	END IF

RETURN lValid

//---------------------------------------------------------------------------//

STATIC FUNCTION CheckValid( aGet, dbf, nTag, nMode )

	Local nOldTag
   Local xClave   := aGet:VarGet()
   Local lReturn  := .t.

	DEFAULT nTag   := 1
   DEFAULT dbf    := Alias()

   if ( nMode == APPD_MODE ) .or. ( nMode == DUPL_MODE )

      if Empty( xClave )
         Return .f.
      end if

      /*
      Cambiamos el tag y guardamos el anterior
      */

      nOldTag     := ( dbf )->( OrdSetFocus( nTag ) )

      if Existe( xClave, dbf )
         MsgStop( "Clave existente" )
         lReturn  := .f.
      else
         aGet:cText( xClave )
      end if

      ( dbf )->( OrdSetFocus( nOldTag ) )

   end if

RETURN lReturn

//-------------------------------------------------------------------------//

STATIC FUNCTION DelDetalle( cCodArt )

   local nOrdAnt  := ( dbfArtPrv )->( OrdSetFocus( 1 ) )

   InitWait()

   /*
   Referencia artículo proveedor
   */

   if ( dbfArtPrv )->( dbSeek( cCodArt ) )

      while ( ( dbfArtPrv )->cCodArt == cCodArt )

         if dbLock( dbfArtPrv )
            ( dbfArtPrv )->( dbDelete() )
            ( dbfArtPrv )->( dbUnLock() )
         end if

         ( dbfArtPrv )->( dbSkip( 1 ) )

      end while

   end if

   ( dbfArtPrv )->( OrdSetFocus( nOrdAnt ) )


   /*
   Codigos de barras
   */

   if ( dbfCodebar )->( dbSeek( cCodArt ) )

      while ( dbfCodebar )->cCodArt == cCodArt .and. !( dbfCodebar )->( eof() )

         if dbLock( dbfCodebar )
            ( dbfCodebar )->( dbDelete() )
            ( dbfCodebar )->( dbUnLock() )
         end if

         ( dbfCodebar )->( dbSkip() )

      end while

   end if

   /*
   Ofertas
   */

   /*if ( dbfOfe )->( dbSeek( cCodArt ) )

      while ( dbfOfe )->cArtOfe == cCodArt .and. !( dbfOfe )->( eof() )

         if dbLock( dbfOfe )
            ( dbfOfe )->( dbDelete() )
            ( dbfOfe )->( dbUnLock() )
         end if

         ( dbfOfe )->( dbSkip() )

      end while

   end if*/

   while ( dbfOfe )->( dbSeek( cCodArt ) )
      if dbLock( dbfOfe )
         ( dbfOfe )->( dbDelete() )
         ( dbfOfe )->( dbUnLock() )
      end if
   end while

   /*
   Eliminamos las imágenes-----------------------------------------------------
   */

   while ( dbfImg )->( dbSeek( cCodArt ) )
      if dbLock( dbfImg )
         ( dbfImg )->( dbDelete() )
         ( dbfImg )->( dbUnLock() )
      end if
   end while

   /*
   Artículos kit
   */

   if ( dbfArtKit )->( dbSeek( cCodArt ) )

      while ( dbfArtKit )->cCodKit == cCodArt .and. !( dbfArtKit )->( eof() )

         if dbLock( dbfArtKit )
            ( dbfArtKit )->( dbDelete() )
            ( dbfArtKit )->( dbUnLock() )
         end if

         ( dbfArtKit )->( dbSkip() )

      end while

   end if

   /*
   Base de datos DbfArtVta
   */

   if ( dbfArtVta )->( dbSeek( cCodArt ) )

      while ( dbfArtVta )->cCodArt == cCodArt .and. !( dbfArtVta )->( eof() )

         if dbLock( dbfArtVta )
            ( dbfArtVta )->( dbDelete() )
            ( dbfArtVta )->( dbUnLock() )
         end if

         ( dbfArtVta )->( dbSkip() )

      end while

   end if

   EndWait()

RETURN NIL

//--------------------------------------------------------------------------//
/*
FUNCTION ExsArt(  dbfArticulo, dbfIva, dbfTmp )

   local cRefArt  := (dbfTmp)->CREF
   local cDetArt  := (dbfTmp)->CDETALLE
   local nUndArt  := (dbfTmp)->NUNICAJA
   local nCajArt  := (dbfTmp)->NCANENT
   local cUndArt  := (dbfTmp)->CUNIDAD
   local nIvaArt  := (dbfTmp)->NIVA
   local lIvaInc  := (dbfTmp)->LIVALIN
   local nPreArt  := (dbfTmp)->NPREUNIT

   //Comprobamos si existe el articulo en la base de datos

	IF !empty( cRefArt ) .AND. !( dbfArticulo )->( dbSeek( cRefArt ) )

      //Nos piden autorizaci¢n para a¤adirlo

      IF ApoloMsgNoYes(   "Articulo : " + rtrim( cDetArt ) + " no existe en su fichero." + CRLF +;
							CRLF +;
							"¿ Desea realizar el alta automática ?" + CRLF +;
							CRLF + ;
                     "( Recuerde que, debe de completar la ficha de este artículo )",;
                     "Nuevo artículo" )

			( dbfArticulo )->( dbAppend() )
			( dbfArticulo )->CODIGO		:= cRefArt
			( dbfArticulo )->NOMBRE		:= cDetArt
			( dbfArticulo )->PCOSTO		:= nPreArt
			( dbfArticulo )->NUNICAJA	:= nCajArt
			( dbfArticulo )->NACTUAL	:= nUndArt
			( dbfArticulo )->TIPOIVA	:= cCodigoIva( dbfIva, nIvaArt )
			( dbfArticulo )->CUNIDAD	:= cUndArt
			( dbfArticulo )->LIVAINC	:= lIvaInc

		END IF

	END IF

RETURN NIL
*/

//--------------------------------------------------------------------------//

FUNCTION AppendReferenciaProveedor( cRefPrv, cCodPrv, cCodArt, nDtoPrv, nDtoPrm, cDivPrv, nImpPrv, dbfArtPrv, nMode )

   local nOrdAnt
   local lSetDefault

   if nImpPrv <= 0
      Return nil
   end if

   if Empty( cCodPrv )
      Return nil 
   end if    

   if Empty( cCodArt )
      Return nil 
   end if    

   // Ponemos el apunte como por defecto---------------------------------------

   if !IsNil( nMode ) 
      lSetDefault       := ( nMode == APPD_MODE .or. nMode == DUPL_MODE )   
   end if 

   nOrdAnt              := ( dbfArtPrv )->( OrdSetFocus( "cRefArt" ) )

   /*
	Ahora pasamos las refrencias de los proveedores-----------------------------
	*/

   if !( dbfArtPrv )->( dbSeek( cCodArt + cCodPrv + cRefPrv ) )

      if dbAppe( dbfArtPrv )
         ( dbfArtPrv )->cCodArt  := cCodArt
         ( dbfArtPrv )->cCodPrv  := cCodPrv
         ( dbfArtPrv )->cRefPrv  := cRefPrv
         ( dbfArtPrv )->nDtoPrv  := nDtoPrv
         ( dbfArtPrv )->nDtoPrm  := nDtoPrm
         ( dbfArtPrv )->cDivPrv  := cDivPrv
         ( dbfArtPrv )->nImpPrv  := nImpPrv
         ( dbfArtPrv )->( dbUnLock() )
      end if
   
   else

      if dbLock( dbfArtPrv )
         ( dbfArtPrv )->nDtoPrv  := nDtoPrv
         ( dbfArtPrv )->nDtoPrm  := nDtoPrm
         ( dbfArtPrv )->cDivPrv  := cDivPrv
         ( dbfArtPrv )->nImpPrv  := nImpPrv
         ( dbfArtPrv )->( dbUnLock() )
      end if
   
   end if

   // Ponemos el proveedor por defecto-----------------------------------------

   if isTrue( lSetDefault )
      if ( dbfArtPrv )->( dbSeek( cCodArt ) )
         while ( dbfArtPrv )->cCodArt == cCodArt .and. !( dbfArtPrv )->( eof() )
            if dbLock( dbfArtPrv )
               ( dbfArtPrv )->lDefPrv  := ( rtrim( ( dbfArtPrv )->cCodArt ) == rtrim( cCodArt ) .and. rtrim( ( dbfArtPrv )->cCodPrv ) == rtrim( cCodPrv ) .and. rtrim( ( dbfArtPrv )->cRefPrv ) == rtrim( cRefPrv ) )
               ( dbfArtPrv )->( dbUnLock() )
            end if 
            ( dbfArtPrv )->( dbSkip() )
         end while
      end if
   end if

   ( dbfArtPrv )->( OrdSetFocus( nOrdAnt ) )

Return nil

//---------------------------------------------------------------------------//

 Function nPrecioReferenciaProveedor( cCodPrv, cCodArt, dbfPrvArt )

   local nPreCom  := 0
   local nRec     := ( dbfPrvArt )->( Recno() )

   if dbSeekInOrd( cCodPrv + cCodArt, "cCodPrv", dbfPrvArt )
      nPreCom     := ( dbfPrvArt )->nImpPrv
   end if

   ( dbfPrvArt )->( dbGoTo( nRec ) )

Return nPreCom

//---------------------------------------------------------------------------//

Function nDescuentoReferenciaProveedor( cCodPrv, cCodArt, dbfPrvArt )

   local nPreCom  := 0
   local nRec     := ( dbfPrvArt )->( Recno() )

   if dbSeekInOrd( cCodPrv + cCodArt, "cCodPrv", dbfPrvArt )
      nPreCom     := ( dbfPrvArt )->nDtoPrv
   end if

   ( dbfPrvArt )->( dbGoTo( nRec ) )

Return nPreCom

//---------------------------------------------------------------------------//

Function nPromocionReferenciaProveedor( cCodPrv, cCodArt, dbfPrvArt )

   local nPreCom  := 0
   local nRec     := ( dbfPrvArt )->( Recno() )

   if dbSeekInOrd( cCodPrv + cCodArt, "cCodPrv", dbfPrvArt )
      nPreCom     := ( dbfPrvArt )->nDtoPrm
   end if

   ( dbfPrvArt )->( dbGoTo( nRec ) )

Return nPreCom

//--------------------------------------------------------------------------//

Function nRetPreCosto( dbfArticulo, cCodArt )

	local nPreCos 	:= 0
	local nOrdAnt 	:= ( dbfArticulo )->( OrdSetFocus( 1 ) )
	local nRecno 	:= ( dbfArticulo )->( RecNo() )

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      nPreCos     := ( dbfArticulo )->pCosto
   end if

	( dbfArticulo )->( dbGoTo( nRecno ) )
	( dbfArticulo )->( OrdSetFocus( nOrdAnt ) )

Return nPreCos

//---------------------------------------------------------------------------//

FUNCTION nUnitEnt( dbfLine )

	local nUnits
   local nCajas   := ( dbfLine )->nCanEnt

   if nCajas == 0
      nCajas      := 1
   end if

   if lCalCaj()
      nUnits      := nCajas * ( dbfLine )->nUniCaja
   else
      nUnits      := ( dbfLine )->nUniCaja
   end if

RETURN ( nUnits )

//--------------------------------------------------------------------------//
/*
Cambia de pesetas a Euros
*/

Static Function SetPtsEur( oWndBrw, oBtnEur )

   lEuro          := !lEuro

   oWndBrw:Refresh()
   oWndBrw:SetFocus()

Return nil

//--------------------------------------------------------------------------//

/*
Devuelve el precio de distribución de un articulo
*/

FUNCTION retPvd( cCodArt, cCodDiv, nChgDiv, dbfArt, dbfDiv )

	local nPvp			:= 0

	DEFAULT nChgDiv	:= 0

	if ( dbfArt )->( dbSeek( cCodArt ) )

      nPvp           := ( dbfArt )->pVtaIva1

		/*
		Buscamos la divisa pasada------------------------------------------------
		*/

		if ( dbfDiv )->( dbSeek( ( dbfArt )->Codigo + cCodDiv ) )

         nPvp        := ( dbfDiv )->nPvdDiv

		else

			/*
			Aplicamos el cambio---------------------------------------------------
			*/

			if nChgDiv != 0
            nPvp     := Div( nPvp, nChgDiv )
         end if

      end if

   end if

RETURN ( nPvp )

//---------------------------------------------------------------------------//

FUNCTION RetImg( cCodArt, dbfArt )

   local cImg        := ""
   local nOrd        := ( dbfArt )->( OrdSetFocus( 1 ) )

   if ( dbfArt )->( dbSeek( cCodArt ) )
      cImg           := ( dbfArt )->cImagen
   end if

   ( dbfArt )->( OrdSetFocus( nOrd ) )

RETURN ( cImg )

//---------------------------------------------------------------------------//

STATIC FUNCTION ChgPrc( dbfArticulo, oWndBrw )

	local oDlg
   local nOrd           := ( dbfArticulo )->( OrdSetFocus( "Codigo" ) )
   local nRec           := ( dbfArticulo )->( Recno() )
   local oMtr
   local nMtr           := 0
   local cFam           := Space( 8 )
	local oFam
   local cTxtFam        := "Todas"
	local oTxtFam
   local cTipIva        := Space( 1 )
	local oTipIva
   local cTxtIva        := "Todos"
	local oTxtIva
   local lCosto         := .f.
   local lTarifa1       := .f.
   local lTarifa2       := .f.
   local lTarifa3       := .f.
   local lTarifa4       := .f.
   local lTarifa5       := .f.
   local lTarifa6       := .f.
   local lPesVol        := .f.
   local oRad
   local nRad           := 1
   local nPctInc        := 0
   local nUndInc        := 0
   local lRnd           := .f.
   local oMargenAjuste
   local lMargenAjuste  := .f.
   local cMargenAjuste  := ''
   local nDec           := nRouDiv( cDivEmp(), dbfDiv )
   local aComBox        :=  { "Precio actual", "Precio costo", "Precio 1", "Precio 2", "Precio 3", "Precio 4", "Precio 5", "Precio 6" }
   local oComBox
   local cComBox        := "Precio actual"
   local cArtOrg
   local cArtDes
   local oArtOrg
   local oArtDes
   local oSayArtOrg
   local oSayArtDes
   local cSayArtOrg
   local cSayArtDes
   local oGetTip
   local cGetTip        := Space( 3 )
   local oTxtTip
   local cTxtTip        := "Todos"

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

	DEFINE DIALOG oDlg RESOURCE "CHGPRE"

   cArtOrg              := dbFirst( dbfArticulo, 1 )
   cArtDes              := dbLast ( dbfArticulo, 1 )
   cSayArtOrg           := dbFirst( dbfArticulo, 2 )
   cSayArtDes           := dbLast ( dbfArticulo, 2 )

   REDEFINE GET oArtOrg VAR cArtOrg;
      ID       60 ;
      VALID    cArticulo( oArtOrg, dbfArticulo, oSayArtOrg );
      BITMAP   "LUPA" ;
      ON HELP  BrwSelArticulo( oArtOrg, oSayArtOrg, .f., .f., .f. );
      OF       oDlg

   REDEFINE GET oSayArtOrg VAR cSayArtOrg ;
      WHEN     .f.;
      ID       70 ;
      OF       oDlg

   REDEFINE GET oArtDes VAR cArtDes;
      ID       80 ;
      VALID    cArticulo( oArtDes, dbfArticulo, oSayArtDes );
      BITMAP   "LUPA" ;
      ON HELP  BrwSelArticulo( oArtDes, oSayArtDes, .f., .f., .f. );
      OF       oDlg

   REDEFINE GET oSayArtDes VAR cSayArtDes ;
      WHEN     .f.;
      ID       90 ;
      OF       oDlg

   REDEFINE GET oFam VAR cFam ;
		ID 		100 ;
		VALID 	( cFamilia( oFam, , oTxtFam ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFamilia( oFam, oTxtFam ) );
		OF 		oDlg

	REDEFINE GET oTxtFam VAR cTxtFam ;
		ID 		110 ;
      WHEN     .f. ;
		OF 		oDlg

   REDEFINE GET oGetTip VAR cGetTip ;
      ID       300 ;
      VALID    ( oTipArt:Existe( oGetTip, oTxtTip, "cNomTip", .t., .t., "0" ) );
      BITMAP   "LUPA" ;
      ON HELP  ( oTipArt:Buscar( oGetTip, oTxtTip ) );
		OF 		oDlg

   REDEFINE GET oTxtTip VAR cTxtTip ;
      ID       301 ;
		WHEN		.F. ;
		COLOR 	CLR_GET ;
      OF       oDlg

	REDEFINE GET oTipIva VAR cTipIva ;
		ID 		120 ;
      PICTURE  "@!" ;
      VALID    ( cTiva( oTipIva, dbfIva, oTxtIva ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwIva( oTipIva, nil, oTxtIva ) );
		OF 		oDlg

	REDEFINE GET oTxtIva VAR cTxtIva ;
		ID 		130 ;
		WHEN		.F. ;
		COLOR 	CLR_GET ;
		OF 		oDlg

   REDEFINE CHECKBOX lCosto ;
      ID       160 ;
      OF       oDlg

   REDEFINE CHECKBOX lTarifa1 ;
		ID 		161 ;
		OF 		oDlg

   REDEFINE CHECKBOX lTarifa2 ;
		ID 		162 ;
		OF 		oDlg

   REDEFINE CHECKBOX lTarifa3 ;
      ID       163 ;
		OF 		oDlg

   REDEFINE CHECKBOX lTarifa4 ;
      ID       164 ;
		OF 		oDlg

   REDEFINE CHECKBOX lTarifa5 ;
      ID       165 ;
		OF 		oDlg

   REDEFINE CHECKBOX lTarifa6 ;
      ID       166 ;
		OF 		oDlg

   REDEFINE CHECKBOX lPesVol ;
      ID       168 ;
		OF 		oDlg

   REDEFINE RADIO oRad VAR nRad ;
		ID 		170, 172 ;
		OF 		oDlg

	REDEFINE GET nPctInc ;
		WHEN		( nRad == 1 ) ;
		PICTURE	"@E 999.99" ;
		SPINNER ;
		ID 		171 ;
		OF 		oDlg

	REDEFINE GET nUndInc ;
		WHEN		( nRad == 2 ) ;
      PICTURE  cPouDiv ;
		ID 		173 ;
		OF 		oDlg

	REDEFINE CHECKBOX lRnd ;
		ID 		180 ;
		OF 		oDlg

	REDEFINE GET nDec ;
      WHEN     lRnd ;
      PICTURE  "@E 9" ;
		SPINNER ;
		ID 		190 ;
		OF 		oDlg

   REDEFINE CHECKBOX lMargenAjuste ;
      ID       200 ;
		OF 		oDlg

   REDEFINE COMBOBOX oMargenAjuste ;
      VAR      cMargenAjuste ;
      WHEN     lMargenAjuste ;
      ID       210 ;
      ITEMS    {  "#,#0",;
                  "#,#5",;
                  "#,10",;
                  "#,20",;
                  "#,50",;
                  "#,90",;
                  "#,95",;
                  "#,99",;
                  "#,00",;
                  "1,00",;
                  "5,00",;
                  "9,00",;
                  "10,00",;
                  "20,00",;
                  "50,00",;
                  "100,00" } ; 
      OF       oDlg

   REDEFINE COMBOBOX oComBox ;
      VAR      cComBox ;
      ID       218 ;
      ITEMS    aComBox ;
      OF       oDlg

   oMtr        := TApoloMeter():ReDefine( 220, { | u | if( pCount() == 0, nMtr, nMtr := u ) }, ( dbfArticulo )->( lastrec() ), oDlg, .f., , "Procesando", .f., Rgb( 255,255,255 ), , Rgb( 128,255,0 ) )

   REDEFINE BUTTON ;
      ID       IDOK;
		OF 		oDlg ;
      ACTION   ( mkChgPrc( cFam, cGetTip, cTipIva, lCosto, lTarifa1, lTarifa2, lTarifa3, lTarifa4, lTarifa5, lTarifa6, lPesVol, nRad, nPctInc, nUndInc, lRnd, nDec, lMargenAjuste, cMargenAjuste, oComBox, cArtOrg, cArtDes, oMtr, oDlg, oWndBrw ))

	REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| mkChgPrc( cFam, cGetTip, cTipIva, lCosto, lTarifa1, lTarifa2, lTarifa3, lTarifa4, lTarifa5, lTarifa6, lPesVol, nRad, nPctInc, nUndInc, lRnd, nDec, lMargenAjuste, cMargenAjuste, oComBox, cArtOrg, cArtDes, oMtr, oDlg, oWndBrw ) } )

	ACTIVATE DIALOG oDlg CENTER

   ( dbfArticulo )->( OrdSetFocus( nOrd ) )
   ( dbfArticulo )->( dbGoTo( nRec ) )

   oWndBrw:Refresh()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION mkChgPrc( cFam, cGetTip, cIva, lCosto, lTarifa1, lTarifa2, lTarifa3, lTarifa4, lTarifa5, lTarifa6, lPesVol, nRad, nPctInc, nUndInc, lRnd, nDec, lMargenAjuste, cMargenAjuste, oComBox, cArtOrg, cArtDes, oMtr, oDlg, oWndBrw )

   local nIva
   local cExpFlt
   local nCounter := 0
   local nPrecio  := oComBox:nAt
   local nRecAct  := ( dbfArticulo )->( RecNo() )

   if !lCosto .and. !lTarifa1 .and. !lTarifa2 .and. !lTarifa3 .and. !lTarifa4 .and. !lTarifa5 .and. !lTarifa6 .and. !lPesVol
      msgStop( "No ha elegido ningúna tarifa a cambiar." )
      Return .f.
   end if

   oDlg:Disable()

   cExpFlt        := '!Deleted() '
   cExpFlt        += '.and. Codigo >= "' + cArtOrg + '"'
   cExpFlt        += '.and. Codigo <= "' + cArtDes + '"'

   if !Empty( cFam )
      cExpFlt     += '.and. Familia == "' + cFam + '"'
   end if

   if !Empty( cGetTip )
      cExpFlt     += '.and. cCodTip == "' + cGetTip + '"'
   end if

   if !Empty( cIva )
      cExpFlt     += '.and. TipoIva == "' + cIva + '"'
   end if

   if CreateFastFilter( cExpFlt, dbfArticulo, .f., oMtr )

      if ApoloMsgNoYes( "Se van a reemplazar " + Alltrim( Trans( ( dbfArticulo )->( OrdKeyCount() ), "9999999" ) ) + " registros.", "¿Desea continuar?" )

         oMtr:SetTotal( ( dbfArticulo )->( OrdKeyCount() ) )

         ( dbfArticulo )->( dbGoTop() )
         while !( dbfArticulo )->( eof() )

            /*
            Valores para los calculos en todo el proceso-----------------------
            */

            nIva                                      := nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100

            /*
            Vemos si cumplimos las condiciones de familia y tipo de impuestos--------
            */

            if dbLock( dbfArticulo )

               if lCosto

                  /*
                  Cambio de precios de costo-----------------------------------
                  */

                  if nRad == 1   //Incremento porcentual

                     ( dbfArticulo )->pCosto          := nVal2Change( nPrecio, ( dbfArticulo )->pCosto )
                     ( dbfArticulo )->pCosto          += ( dbfArticulo )->pCosto * nPctInc / 100

                  else           //Incremento lineal

                     ( dbfArticulo )->pCosto          := nVal2Change( nPrecio, ( dbfArticulo )->pCosto )
                     ( dbfArticulo )->pCosto          += nUndInc

                  end if

                  /*
                  Redondeamos
                  */

                  if lRnd
                     ( dbfArticulo )->pCosto          := Round( ( dbfArticulo )->pCosto, nDec )
                  end if

                  /*
                  Ajustamos
                  */

                  if ( dbfArticulo )->lMarAju .and. !empty( ( dbfArticulo )->cMarAju )
                     ( dbfArticulo )->pCosto          := nAjuste( ( dbfArticulo )->pCosto, ( dbfArticulo )->cMarAju )
                  elseif lMargenAjuste
                     ( dbfArticulo )->pCosto          := nAjuste( ( dbfArticulo )->pCosto, cMargenAjuste )
                  end if

                  if ( dbfArticulo )->lBnf1
                     ( dbfArticulo )->pVenta1         := CalPre( ( dbfArticulo )->nBnfSbr1 <= 1, ( dbfArticulo )->pCosto, .t., ( dbfArticulo )->Benef1, ( dbfArticulo )->TipoIva, nil, nil, nDecDiv, ( dbfArticulo )->cCodImp )
                     ( dbfArticulo )->pVtaIva1        := ( ( dbfArticulo )->pVenta1 * nIva ) + ( dbfArticulo )->pVenta1
                  end if

                  if ( dbfArticulo )->lBnf2
                     ( dbfArticulo )->pVenta2         := CalPre( ( dbfArticulo )->nBnfSbr2 <= 1, ( dbfArticulo )->pCosto, .t., ( dbfArticulo )->Benef2, ( dbfArticulo )->TipoIva, nil, nil, nDecDiv, ( dbfArticulo )->cCodImp )
                     ( dbfArticulo )->pVtaIva2        := ( ( dbfArticulo )->pVenta2 * nIva ) + ( dbfArticulo )->pVenta2
                  end if

                  if ( dbfArticulo )->lBnf3
                     ( dbfArticulo )->pVenta3         := CalPre( ( dbfArticulo )->nBnfSbr3 <= 1, ( dbfArticulo )->pCosto, .t., ( dbfArticulo )->Benef3, ( dbfArticulo )->TipoIva, nil, nil, nDecDiv, ( dbfArticulo )->cCodImp )
                     ( dbfArticulo )->pVtaIva3        := ( ( dbfArticulo )->pVenta3 * nIva ) + ( dbfArticulo )->pVenta3
                  end if

                  if ( dbfArticulo )->lBnf4
                     ( dbfArticulo )->pVenta4         := CalPre( ( dbfArticulo )->nBnfSbr4 <= 1, ( dbfArticulo )->pCosto, .t., ( dbfArticulo )->Benef4, ( dbfArticulo )->TipoIva, nil, nil, nDecDiv, ( dbfArticulo )->cCodImp )
                     ( dbfArticulo )->pVtaIva4        := ( ( dbfArticulo )->pVenta4 * nIva ) + ( dbfArticulo )->pVenta4
                  end if

                  if ( dbfArticulo )->lBnf5
                     ( dbfArticulo )->pVenta5         := CalPre( ( dbfArticulo )->nBnfSbr5 <= 1, ( dbfArticulo )->pCosto, .t., ( dbfArticulo )->Benef5, ( dbfArticulo )->TipoIva, nil, nil, nDecDiv, ( dbfArticulo )->cCodImp )
                     ( dbfArticulo )->pVtaIva5        := ( ( dbfArticulo )->pVenta5 * nIva ) + ( dbfArticulo )->pVenta5
                  end if

                  if ( dbfArticulo )->lBnf6
                     ( dbfArticulo )->pVenta6         := CalPre( ( dbfArticulo )->nBnfSbr6 <= 1, ( dbfArticulo )->pCosto, .t., ( dbfArticulo )->Benef6, ( dbfArticulo )->TipoIva, nil, nil, nDecDiv, ( dbfArticulo )->cCodImp )
                     ( dbfArticulo )->pVtaIva6        := ( ( dbfArticulo )->pVenta6 * nIva ) + ( dbfArticulo )->pVenta6
                  end if

               end if

               /*
               Estudio de precios de Tarifa 1----------------------------------
               */

               if lTarifa1 //.and. !( dbfArticulo )->lBnf5

                  if nRad == 1

                     /*
                     Los calculos se haran sobre el precio de costo
                     */

                     if nPrecio == 2

                        if !lMargenAjuste
                           ( dbfArticulo )->lBnf1     := .t.
                           ( dbfArticulo )->Benef1    := nPctInc
                        end if

                        /*
                        Si el pocentaje de beneficio es sobre el costo
                        */

                        ( dbfArticulo )->nBnfSbr1     := 1
                        ( dbfArticulo )->pVenta1      := ( dbfArticulo )->pCosto + ( ( dbfArticulo )->pCosto * nPctInc / 100 )
                        ( dbfArticulo )->pVtaIva1     := ( dbfArticulo )->pVenta1 + ( ( dbfArticulo )->pVenta1 * nIva )

                     else

                        /*
                        Los calculos se hacen en funcion de otras tarifas
                        */

                        ( dbfArticulo )->pVenta1      := nVal2Change( nPrecio, ( dbfArticulo )->pVenta1 )

                        if !( dbfArticulo )->lIvaInc

                           /*
                           Si el pocentaje de beneficio es sobre el costo
                           */

                           ( dbfArticulo )->nBnfSbr1  := 1
                           ( dbfArticulo )->pVenta1   += ( dbfArticulo )->pVenta1 * nPctInc / 100

                        else

                           /*
                           Si el pocentaje de beneficio es sobre la venta
                           */

                           ( dbfArticulo )->nBnfSbr1  := 2
                           ( dbfArticulo )->pVenta1   += ( dbfArticulo )->pVenta1 * nPctInc / 100

                        end if

                     end if

                  else

                     ( dbfArticulo )->lBnf1           := .f.
                     ( dbfArticulo )->pVenta1         := nVal2Change( nPrecio, ( dbfArticulo )->pVenta1 ) + nUndInc

                  end if

                  /*
                  Redondeos y precios finales producto sin impuestos incluido--------
                  */

                  if !( dbfArticulo )->lIvaInc

                     if lRnd
                        ( dbfArticulo )->pVenta1      := Round( ( dbfArticulo )->pVenta1, nDec )
                     end if

                     if ( dbfArticulo )->lMarAju .and. !Empty( ( dbfArticulo )->cMarAju )
                        ( dbfArticulo )->pVenta1      := nAjuste( ( dbfArticulo )->pVenta1, ( dbfArticulo )->cMarAju )
                     elseif lMargenAjuste
                        ( dbfArticulo )->pVenta1      := nAjuste( ( dbfArticulo )->pVenta1, cMargenAjuste )
                     end if

                     ( dbfArticulo )->pVtaIva1        := ( ( dbfArticulo )->pVenta1 * nIva ) + ( dbfArticulo )->pVenta1

                  end if

                  /*
                  Redondeos y precios finales producto impuestos incluido------------
                  */

                  if ( dbfArticulo )->lIvaInc

                     ( dbfArticulo )->pVtaIva1        := ( ( dbfArticulo )->pVenta1 * nIva ) + ( dbfArticulo )->pVenta1

                     if lRnd
                        ( dbfArticulo )->pVtaIva1     := Round( ( dbfArticulo )->pVtaIva1, nDec )
                     end if

                     if ( dbfArticulo )->lMarAju .and. !Empty( ( dbfArticulo )->cMarAju )
                        ( dbfArticulo )->pVtaIva1     := nAjuste( ( dbfArticulo )->pVtaIva1, ( dbfArticulo )->cMarAju )
                     elseif lMargenAjuste
                        ( dbfArticulo )->pVtaIva1     := nAjuste( ( dbfArticulo )->pVtaIva1, cMargenAjuste )
                     end if

                     ( dbfArticulo )->pVenta1         := Round( ( dbfArticulo )->pVtaIva1 / ( 1 + nIva ), nDecDiv )

                  end if

                  /*
                  Recalculo de precios para cambios sobre porcentajes----------
                  */

                  if ( dbfArticulo )->lBnf1 .and. nPctInc == 0

                     if ( dbfArticulo )->nBnfSbr1 <= 1
                        ( dbfArticulo )->pVenta1      := Round( ( ( dbfArticulo )->pCosto * ( dbfArticulo )->Benef1 / 100 ) + ( dbfArticulo )->pCosto, nDec )
                     else
                        ( dbfArticulo )->pVenta1      := Round( ( ( dbfArticulo )->pCosto / ( 1 - ( ( dbfArticulo )->Benef1 / 100 ) ) ), nDec )
                     end if

                     ( dbfArticulo )->pVtaIva1        := ( ( dbfArticulo )->pVenta1 * nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100 ) + ( dbfArticulo )->pVenta1

                  end if

               end if

               /*
               Estudio de precios de Tarifa 2----------------------------------
               */

               if lTarifa2 //.and. !( dbfArticulo )->lBnf2

                  if nRad == 1

                     /*
                     Los calculos se haran sobre el precio de costo
                     */

                     if nPrecio == 2

                        if !lMargenAjuste
                           ( dbfArticulo )->lBnf2  := .t.
                           ( dbfArticulo )->Benef2 := nPctInc
                        end if

                        /*
                        Si el pocentaje de beneficio es sobre el costo
                        */

                        ( dbfArticulo )->nBnfSbr2  := 1
                        ( dbfArticulo )->pVenta2   := ( dbfArticulo )->pCosto + ( ( dbfArticulo )->pCosto * nPctInc / 100 )
                        ( dbfArticulo )->pVtaIva2  := ( dbfArticulo )->pVenta2 + ( ( dbfArticulo )->pVenta2 * nIva )

                     else

                        /*
                        Los calculos se hacen en funcion de otras tarifas
                        */

                        ( dbfArticulo )->pVenta2      := nVal2Change( nPrecio, ( dbfArticulo )->pVenta2 )

                        if !( dbfArticulo )->lIvaInc

                           /*
                           Si el pocentaje de beneficio es sobre el costo
                           */

                           ( dbfArticulo )->nBnfSbr2  := 1
                           ( dbfArticulo )->pVenta2   += ( dbfArticulo )->pVenta2 * nPctInc / 100

                        else

                           /*
                           Si el pocentaje de beneficio es sobre la venta
                           */

                           ( dbfArticulo )->nBnfSbr2  := 2
                           ( dbfArticulo )->pVenta2   += ( dbfArticulo )->pVenta2 * nPctInc / 100

                        end if

                     end if

                  else

                     ( dbfArticulo )->lBnf2           := .f.
                     ( dbfArticulo )->pVenta2         := nVal2Change( nPrecio, ( dbfArticulo )->pVenta2 ) + nUndInc

                  end if

                  /*
                  Redondeos y precios finales producto sin impuestos incluido--------
                  */

                  if !( dbfArticulo )->lIvaInc

                     if lRnd
                        ( dbfArticulo )->pVenta2      := Round( ( dbfArticulo )->pVenta2, nDec )
                     end if

                     if ( dbfArticulo )->lMarAju .and. !Empty( ( dbfArticulo )->cMarAju )
                        ( dbfArticulo )->pVenta2      := nAjuste( ( dbfArticulo )->pVenta2, ( dbfArticulo )->cMarAju )
                     elseif lMargenAjuste
                        ( dbfArticulo )->pVenta2      := nAjuste( ( dbfArticulo )->pVenta2, cMargenAjuste )
                     end if

                     ( dbfArticulo )->pVtaIva2        := ( ( dbfArticulo )->pVenta2 * nIva ) + ( dbfArticulo )->pVenta2

                  end if

                  /*
                  Redondeos y precios finales producto impuestos incluido------------
                  */

                  if ( dbfArticulo )->lIvaInc

                     ( dbfArticulo )->pVtaIva2        := ( ( dbfArticulo )->pVenta2 * nIva ) + ( dbfArticulo )->pVenta2

                     if lRnd
                        ( dbfArticulo )->pVtaIva2     := Round( ( dbfArticulo )->pVtaIva2, nDec )
                     end if

                     if ( dbfArticulo )->lMarAju .and. !Empty( ( dbfArticulo )->cMarAju )
                        ( dbfArticulo )->pVtaIva2     := nAjuste( ( dbfArticulo )->pVtaIva2, ( dbfArticulo )->cMarAju )
                     elseif lMargenAjuste
                        ( dbfArticulo )->pVtaIva2     := nAjuste( ( dbfArticulo )->pVtaIva2, cMargenAjuste )
                     end if

                     ( dbfArticulo )->pVenta2         := Round( ( dbfArticulo )->pVtaIva2 / ( 1 + nIva ), nDecDiv )

                  end if

                  /*
                  Recalculo de precios para cambios sobre porcentajes----------
                  */

                  if ( dbfArticulo )->lBnf2 .and. nPctInc == 0

                     if ( dbfArticulo )->nBnfSbr2 <= 1
                        ( dbfArticulo )->pVenta2      := Round( ( ( dbfArticulo )->pCosto * ( dbfArticulo )->Benef2 / 100 ) + ( dbfArticulo )->pCosto, nDec )
                     else
                        ( dbfArticulo )->pVenta2      := Round( ( ( dbfArticulo )->pCosto / ( 1 - ( ( dbfArticulo )->Benef2 / 100 ) ) ), nDec )
                     end if

                     ( dbfArticulo )->pVtaIva2        := ( ( dbfArticulo )->pVenta2 * nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100 ) + ( dbfArticulo )->pVenta2

                  end if

               end if

               /*
               Estudio de precios de Tarifa 3----------------------------------
               */

               if lTarifa3 //.and. !( dbfArticulo )->lBnf3

                  if nRad == 1

                     /*
                     Los calculos se haran sobre el precio de costo
                     */

                     if nPrecio == 2

                        if !lMargenAjuste
                           ( dbfArticulo )->lBnf3  := .t.
                           ( dbfArticulo )->Benef3 := nPctInc
                        end if

                        /*
                        Si el pocentaje de beneficio es sobre el costo
                        */

                        ( dbfArticulo )->nBnfSbr3  := 1
                        ( dbfArticulo )->pVenta3   := ( dbfArticulo )->pCosto + ( ( dbfArticulo )->pCosto * nPctInc / 100 )
                        ( dbfArticulo )->pVtaIva3  := ( dbfArticulo )->pVenta3 + ( ( dbfArticulo )->pVenta3 * nIva )

                     else

                        /*
                        Los calculos se hacen en funcion de otras tarifas
                        */

                        ( dbfArticulo )->pVenta3      := nVal2Change( nPrecio, ( dbfArticulo )->pVenta3 )

                        if !( dbfArticulo )->lIvaInc

                           /*
                           Si el pocentaje de beneficio es sobre el costo
                           */

                           ( dbfArticulo )->nBnfSbr3  := 1
                           ( dbfArticulo )->pVenta3   += ( dbfArticulo )->pVenta3 * nPctInc / 100

                        else

                           /*
                           Si el pocentaje de beneficio es sobre la venta
                           */

                           ( dbfArticulo )->nBnfSbr3  := 2
                           ( dbfArticulo )->pVenta3   += ( dbfArticulo )->pVenta3 * nPctInc / 100

                        end if

                     end if

                  else

                     ( dbfArticulo )->lBnf3           := .f.
                     ( dbfArticulo )->pVenta3         := nVal2Change( nPrecio, ( dbfArticulo )->pVenta3 ) + nUndInc

                  end if

                  /*
                  Redondeos y precios finales producto sin impuestos incluido--------
                  */

                  if !( dbfArticulo )->lIvaInc

                     if lRnd
                        ( dbfArticulo )->pVenta3      := Round( ( dbfArticulo )->pVenta3, nDec )
                     end if

                     if ( dbfArticulo )->lMarAju .and. !Empty( ( dbfArticulo )->cMarAju )
                        ( dbfArticulo )->pVenta3      := nAjuste( ( dbfArticulo )->pVenta3, ( dbfArticulo )->cMarAju )
                     elseif lMargenAjuste
                        ( dbfArticulo )->pVenta3      := nAjuste( ( dbfArticulo )->pVenta3, cMargenAjuste )
                     end if

                     ( dbfArticulo )->pVtaIva3        := ( ( dbfArticulo )->pVenta3 * nIva ) + ( dbfArticulo )->pVenta3

                  end if

                  /*
                  Redondeos y precios finales producto impuestos incluido------------
                  */

                  if ( dbfArticulo )->lIvaInc

                     ( dbfArticulo )->pVtaIva3        := ( ( dbfArticulo )->pVenta3 * nIva ) + ( dbfArticulo )->pVenta3

                     if lRnd
                        ( dbfArticulo )->pVtaIva3     := Round( ( dbfArticulo )->pVtaIva3, nDec )
                     end if

                     if ( dbfArticulo )->lMarAju .and. !Empty( ( dbfArticulo )->cMarAju )
                        ( dbfArticulo )->pVtaIva3     := nAjuste( ( dbfArticulo )->pVtaIva3, ( dbfArticulo )->cMarAju )
                     elseif lMargenAjuste
                        ( dbfArticulo )->pVtaIva3     := nAjuste( ( dbfArticulo )->pVtaIva3, cMargenAjuste )
                     end if

                     ( dbfArticulo )->pVenta3         := Round( ( dbfArticulo )->pVtaIva3 / ( 1 + nIva ), nDecDiv )

                  end if

                  /*
                  Recalculo de precios para cambios sobre porcentajes----------
                  */

                  if ( dbfArticulo )->lBnf3 .and. nPctInc == 0

                     if ( dbfArticulo )->nBnfSbr3 <= 1
                        ( dbfArticulo )->pVenta3      := Round( ( ( dbfArticulo )->pCosto * ( dbfArticulo )->Benef3 / 100 ) + ( dbfArticulo )->pCosto, nDec )
                     else
                        ( dbfArticulo )->pVenta3      := Round( ( ( dbfArticulo )->pCosto / ( 1 - ( ( dbfArticulo )->Benef3 / 100 ) ) ), nDec )
                     end if

                     ( dbfArticulo )->pVtaIva3        := ( ( dbfArticulo )->pVenta3 * nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100 ) + ( dbfArticulo )->pVenta3

                  end if

               end if

               if lTarifa4 //.and. !( dbfArticulo )->lBnf4

                  if nRad == 1

                     /*
                     Los calculos se haran sobre el precio de costo
                     */

                     if nPrecio == 2

                        if !lMargenAjuste
                           ( dbfArticulo )->lBnf4  := .t.
                           ( dbfArticulo )->Benef4 := nPctInc
                        end if

                        /*
                        Si el pocentaje de beneficio es sobre el costo
                        */

                        ( dbfArticulo )->nBnfSbr4  := 1
                        ( dbfArticulo )->pVenta4   := ( dbfArticulo )->pCosto + ( ( dbfArticulo )->pCosto * nPctInc / 100 )
                        ( dbfArticulo )->pVtaIva4  := ( dbfArticulo )->pVenta4 + ( ( dbfArticulo )->pVenta4 * nIva )

                     else

                        /*
                        Los calculos se hacen en funcion de otras tarifas
                        */

                        ( dbfArticulo )->pVenta4      := nVal2Change( nPrecio, ( dbfArticulo )->pVenta4 )

                        if !( dbfArticulo )->lIvaInc

                           /*
                           Si el pocentaje de beneficio es sobre el costo
                           */

                           ( dbfArticulo )->nBnfSbr4  := 1
                           ( dbfArticulo )->pVenta4   += ( dbfArticulo )->pVenta4 * nPctInc / 100

                        else

                           /*
                           Si el pocentaje de beneficio es sobre la venta
                           */

                           ( dbfArticulo )->nBnfSbr4  := 2
                           ( dbfArticulo )->pVenta4   += ( dbfArticulo )->pVenta4 * nPctInc / 100

                        end if

                     end if

                  else

                     ( dbfArticulo )->lBnf4           := .f.
                     ( dbfArticulo )->pVenta4         := nVal2Change( nPrecio, ( dbfArticulo )->pVenta4 ) + nUndInc

                  end if

                  /*
                  Redondeos y precios finales producto sin impuestos incluido--------
                  */

                  if !( dbfArticulo )->lIvaInc

                     if lRnd
                        ( dbfArticulo )->pVenta4      := Round( ( dbfArticulo )->pVenta4, nDec )
                     end if

                     if ( dbfArticulo )->lMarAju .and. !Empty( ( dbfArticulo )->cMarAju )
                        ( dbfArticulo )->pVenta4      := nAjuste( ( dbfArticulo )->pVenta4, ( dbfArticulo )->cMarAju )
                     elseif lMargenAjuste
                        ( dbfArticulo )->pVenta4      := nAjuste( ( dbfArticulo )->pVenta4, cMargenAjuste )
                     end if

                     ( dbfArticulo )->pVtaIva4        := ( ( dbfArticulo )->pVenta4 * nIva ) + ( dbfArticulo )->pVenta4

                  end if

                  /*
                  Redondeos y precios finales producto impuestos incluido------------
                  */

                  if ( dbfArticulo )->lIvaInc

                     ( dbfArticulo )->pVtaIva4        := ( ( dbfArticulo )->pVenta4 * nIva ) + ( dbfArticulo )->pVenta4

                     if lRnd
                        ( dbfArticulo )->pVtaIva4     := Round( ( dbfArticulo )->pVtaIva4, nDec )
                     end if

                     if ( dbfArticulo )->lMarAju .and. !Empty( ( dbfArticulo )->cMarAju )
                        ( dbfArticulo )->pVtaIva4     := nAjuste( ( dbfArticulo )->pVtaIva4, ( dbfArticulo )->cMarAju )
                     elseif lMargenAjuste
                        ( dbfArticulo )->pVtaIva4     := nAjuste( ( dbfArticulo )->pVtaIva4, cMargenAjuste )
                     end if

                     ( dbfArticulo )->pVenta4         := Round( ( dbfArticulo )->pVtaIva4 / ( 1 + nIva ), nDecDiv )

                  end if

                  /*
                  Recalculo de precios para cambios sobre porcentajes----------
                  */

                  if ( dbfArticulo )->lBnf4 .and. nPctInc == 0

                     if ( dbfArticulo )->nBnfSbr4 <= 1
                        ( dbfArticulo )->pVenta4      := Round( ( ( dbfArticulo )->pCosto * ( dbfArticulo )->Benef4 / 100 ) + ( dbfArticulo )->pCosto, nDec )
                     else
                        ( dbfArticulo )->pVenta4      := Round( ( ( dbfArticulo )->pCosto / ( 1 - ( ( dbfArticulo )->Benef4 / 100 ) ) ), nDec )
                     end if

                     ( dbfArticulo )->pVtaIva4        := ( ( dbfArticulo )->pVenta4 * nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100 ) + ( dbfArticulo )->pVenta4

                  end if

               end if

               /*
               Tarifa 5--------------------------------------------------------
               */

               if lTarifa5 //.and. !( dbfArticulo )->lBnf5

                  if nRad == 1

                     /*
                     Los calculos se haran sobre el precio de costo
                     */

                     if nPrecio == 2

                        if !lMargenAjuste
                           ( dbfArticulo )->lBnf5  := .t.
                           ( dbfArticulo )->Benef5 := nPctInc
                        end if

                        /*
                        Si el pocentaje de beneficio es sobre el costo
                        */

                        ( dbfArticulo )->nBnfSbr5  := 1
                        ( dbfArticulo )->pVenta5   := ( dbfArticulo )->pCosto + ( ( dbfArticulo )->pCosto * nPctInc / 100 )
                        ( dbfArticulo )->pVtaIva5  := ( dbfArticulo )->pVenta5 + ( ( dbfArticulo )->pVenta5 * nIva )

                     else

                        /*
                        Los calculos se hacen en funcion de otras tarifas
                        */

                        ( dbfArticulo )->pVenta5      := nVal2Change( nPrecio, ( dbfArticulo )->pVenta5 )

                        if !( dbfArticulo )->lIvaInc

                           /*
                           Si el pocentaje de beneficio es sobre el costo
                           */

                           ( dbfArticulo )->nBnfSbr5  := 1
                           ( dbfArticulo )->pVenta5   += ( dbfArticulo )->pVenta5 * nPctInc / 100

                        else

                           /*
                           Si el pocentaje de beneficio es sobre la venta
                           */

                           ( dbfArticulo )->nBnfSbr5  := 2
                           ( dbfArticulo )->pVenta5   += ( dbfArticulo )->pVenta5 * nPctInc / 100

                        end if

                     end if

                  else

                     ( dbfArticulo )->lBnf5           := .f.
                     ( dbfArticulo )->pVenta5         := nVal2Change( nPrecio, ( dbfArticulo )->pVenta5 ) + nUndInc

                  end if

                  /*
                  Redondeos y precios finales producto sin impuestos incluido--------
                  */

                  if !( dbfArticulo )->lIvaInc

                     if lRnd
                        ( dbfArticulo )->pVenta5      := Round( ( dbfArticulo )->pVenta5, nDec )
                     end if

                     if ( dbfArticulo )->lMarAju .and. !Empty( ( dbfArticulo )->cMarAju )
                        ( dbfArticulo )->pVenta5      := nAjuste( ( dbfArticulo )->pVenta5, ( dbfArticulo )->cMarAju )
                     elseif lMargenAjuste
                        ( dbfArticulo )->pVenta5      := nAjuste( ( dbfArticulo )->pVenta5, cMargenAjuste )
                     end if

                     ( dbfArticulo )->pVtaIva5        := ( ( dbfArticulo )->pVenta5 * nIva ) + ( dbfArticulo )->pVenta5

                  end if

                  /*
                  Redondeos y precios finales producto impuestos incluido------------
                  */

                  if ( dbfArticulo )->lIvaInc

                     ( dbfArticulo )->pVtaIva5        := ( ( dbfArticulo )->pVenta5 * nIva ) + ( dbfArticulo )->pVenta5

                     if lRnd
                        ( dbfArticulo )->pVtaIva5     := Round( ( dbfArticulo )->pVtaIva5, nDec )
                     end if

                     if ( dbfArticulo )->lMarAju .and. !Empty( ( dbfArticulo )->cMarAju )
                        ( dbfArticulo )->pVtaIva5     := nAjuste( ( dbfArticulo )->pVtaIva5, ( dbfArticulo )->cMarAju )
                     elseif lMargenAjuste
                        ( dbfArticulo )->pVtaIva5     := nAjuste( ( dbfArticulo )->pVtaIva5, cMargenAjuste )
                     end if

                     ( dbfArticulo )->pVenta5         := Round( ( dbfArticulo )->pVtaIva5 / ( 1 + nIva ), nDecDiv )

                  end if

                  /*
                  Recalculo de precios para cambios sobre porcentajes----------
                  */

                  if ( dbfArticulo )->lBnf5 .and. nPctInc == 0

                     if ( dbfArticulo )->nBnfSbr5 <= 1
                        ( dbfArticulo )->pVenta5      := Round( ( ( dbfArticulo )->pCosto * ( dbfArticulo )->Benef5 / 100 ) + ( dbfArticulo )->pCosto, nDec )
                     else
                        ( dbfArticulo )->pVenta5      := Round( ( ( dbfArticulo )->pCosto / ( 1 - ( ( dbfArticulo )->Benef5 / 100 ) ) ), nDec )
                     end if

                     ( dbfArticulo )->pVtaIva5        := ( ( dbfArticulo )->pVenta5 * nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100 ) + ( dbfArticulo )->pVenta5

                  end if

               end if

               /*
               Tarifa 6--------------------------------------------------------
               */

               if lTarifa6 //.and. !( dbfArticulo )->lBnf6

                  if nRad == 1

                     /*
                     Los calculos se haran sobre el precio de costo
                     */

                     if nPrecio == 2

                        if !lMargenAjuste
                           ( dbfArticulo )->lBnf6  := .t.
                           ( dbfArticulo )->Benef6 := nPctInc
                        end if

                        /*
                        Si el pocentaje de beneficio es sobre el costo
                        */

                        ( dbfArticulo )->nBnfSbr6  := 1
                        ( dbfArticulo )->pVenta6   := ( dbfArticulo )->pCosto + ( ( dbfArticulo )->pCosto * nPctInc / 100 )
                        ( dbfArticulo )->pVtaIva6  := ( dbfArticulo )->pVenta6 + ( ( dbfArticulo )->pVenta6 * nIva )

                     else

                        /*
                        Los calculos se hacen en funcion de otras tarifas
                        */

                        ( dbfArticulo )->pVenta6      := nVal2Change( nPrecio, ( dbfArticulo )->pVenta6 )

                        if !( dbfArticulo )->lIvaInc

                           /*
                           Si el pocentaje de beneficio es sobre el costo
                           */

                           ( dbfArticulo )->nBnfSbr6  := 1
                           ( dbfArticulo )->pVenta6   += ( dbfArticulo )->pVenta6 * nPctInc / 100

                        else

                           /*
                           Si el pocentaje de beneficio es sobre la venta
                           */

                           ( dbfArticulo )->nBnfSbr6  := 2
                           ( dbfArticulo )->pVenta6   += ( dbfArticulo )->pVenta6 * nPctInc / 100

                        end if

                     end if

                  else

                     ( dbfArticulo )->lBnf6           := .f.
                     ( dbfArticulo )->pVenta6         := nVal2Change( nPrecio, ( dbfArticulo )->pVenta6 ) + nUndInc

                  end if

                  /*
                  Redondeos y precios finales producto sin impuestos incluido--------
                  */

                  if !( dbfArticulo )->lIvaInc

                     if lRnd
                        ( dbfArticulo )->pVenta6      := Round( ( dbfArticulo )->pVenta6, nDec )
                     end if

                     if ( dbfArticulo )->lMarAju .and. !Empty( ( dbfArticulo )->cMarAju )
                        ( dbfArticulo )->pVenta6      := nAjuste( ( dbfArticulo )->pVenta6, ( dbfArticulo )->cMarAju )
                     elseif lMargenAjuste
                        ( dbfArticulo )->pVenta6      := nAjuste( ( dbfArticulo )->pVenta6, cMargenAjuste )
                     end if

                     ( dbfArticulo )->pVtaIva6        := ( ( dbfArticulo )->pVenta6 * nIva ) + ( dbfArticulo )->pVenta6

                  end if

                  /*
                  Redondeos y precios finales producto impuestos incluido------------
                  */

                  if ( dbfArticulo )->lIvaInc

                     ( dbfArticulo )->pVtaIva6        := ( ( dbfArticulo )->pVenta6 * nIva ) + ( dbfArticulo )->pVenta6

                     if lRnd
                        ( dbfArticulo )->pVtaIva6     := Round( ( dbfArticulo )->pVtaIva6, nDec )
                     end if

                     if ( dbfArticulo )->lMarAju .and. !Empty( ( dbfArticulo )->cMarAju )
                        ( dbfArticulo )->pVtaIva6     := nAjuste( ( dbfArticulo )->pVtaIva6, ( dbfArticulo )->cMarAju )
                     elseif lMargenAjuste
                        ( dbfArticulo )->pVtaIva6     := nAjuste( ( dbfArticulo )->pVtaIva6, cMargenAjuste )
                     end if

                     ( dbfArticulo )->pVenta6         := Round( ( dbfArticulo )->pVtaIva6 / ( 1 + nIva ), nDecDiv )

                  end if

                  /*
                  Recalculo de precios para cambios sobre porcentajes----------
                  */

                  if ( dbfArticulo )->lBnf6 .and. nPctInc == 0

                     if ( dbfArticulo )->nBnfSbr6 <= 1
                        ( dbfArticulo )->pVenta6      := Round( ( ( dbfArticulo )->pCosto * ( dbfArticulo )->Benef6 / 100 ) + ( dbfArticulo )->pCosto, nDec )
                     else
                        ( dbfArticulo )->pVenta6      := Round( ( ( dbfArticulo )->pCosto / ( 1 - ( ( dbfArticulo )->Benef6 / 100 ) ) ), nDec )
                     end if

                     ( dbfArticulo )->pVtaIva6        := ( ( dbfArticulo )->pVenta6 * nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100 ) + ( dbfArticulo )->pVenta6

                  end if

               end if

               /*
               Cambio de peso volumen------------------------------------------
               */

               if lPesVol

                  if nRad == 1
                     ( dbfArticulo )->nImpPes      += nVal2Change( nPrecio, ( dbfArticulo )->nImpPes ) * nPctInc / 100
                  else
                     ( dbfArticulo )->nImpPes      += nVal2Change( nPrecio, ( dbfArticulo )->nImpPes ) + nUndInc
                  end if

                  if lRnd
                     ( dbfArticulo )->nImpPes      := Round( ( dbfArticulo )->nImpPes, nDec )
                  end if

               end if

               ( dbfArticulo )->lSndDoc            := .t.

               nCounter++

               ( dbfArticulo )->( dbUnLock() )

            end if

            ( dbfArticulo )->( dbSkip() )

            oMtr:Set( ( dbfArticulo )->( OrdKeyNo() ) )

         end do

         oMtr:Set( ( dbfArticulo )->( LastRec() ) )

      end if

      DestroyFastFilter( dbfArticulo )

      MsgInfo( "Total de registros cambiados " + Trans( nCounter, "999999999" ) )

   end if

	( dbfArticulo )->( dbGoto( nRecAct ) )

   oWndBrw:Refresh()

   oDlg:Enable()

Return .t.

//---------------------------------------------------------------------------//

Static Function nVal2Change( nPrecio, nImporte )

   local nVal2Change := 0

   do case
      case nPrecio == 1
         nVal2Change := nImporte
      case nPrecio == 2
         nVal2Change := ( dbfArticulo )->pCosto
      case nPrecio == 3
         nVal2Change := ( dbfArticulo )->pVenta1
      case nPrecio == 4
         nVal2Change := ( dbfArticulo )->pVenta2
      case nPrecio == 5
         nVal2Change := ( dbfArticulo )->pVenta3
      case nPrecio == 6
         nVal2Change := ( dbfArticulo )->pVenta4
      case nPrecio == 7
         nVal2Change := ( dbfArticulo )->pVenta5
      case nPrecio == 8
         nVal2Change := ( dbfArticulo )->pVenta6
   end case

RETURN nVal2Change

//---------------------------------------------------------------------------//

FUNCTION retCode( cCbaArt, dbfArticulo )

   local lFound
   local cRet  := ""
   local nOrd  := ( dbfArticulo )->( ordSetFocus( "Codigo" ) )

   lFound      := ( dbfArticulo )->( dbSeek( cCbaArt ) )
   if lFound
      cRet     := ( dbfArticulo )->CODIGO
   end if

   ( dbfArticulo )->( OrdSetFocus( nOrd ) )

   /*
   Si no encontramos el codigo lo buscamos por codigo de barras
   */

   if !lFound
      nOrd     := ( dbfArticulo )->( ordSetFocus( "CodeBar" ) )

      if ( dbfArticulo )->( dbSeek( cCbaArt ) )
         cRet  := ( dbfArticulo )->CODIGO
      end if

      ( dbfArticulo )->( OrdSetFocus( nOrd ) )
   end if

RETURN ( cRet )

//--------------------------------------------------------------------------//

STATIC FUNCTION lSelArt( lSel, oBrw, dbf, dbfFam )

   DEFAULT lSel         := !( dbf )->lSndDoc

   if dbLock( dbf )
      ( dbf )->lSndDoc  := lSel
      ( dbf )->( dbUnlock() )
   end if

   if lSel .and. ( dbfFam )->( dbSeek( ( dbf )->Familia ) )
      if dbLock( dbfFam )
         ( dbfFam )->lSelDoc := lSel
         ( dbf )->( dbUnlock() )
      end if
   end if

   if oBrw != nil
      oBrw:Refresh()
      oBrw:SetFocus()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

/*
Selecciona todos los registros
*/

STATIC FUNCTION lSelectAll( oBrw, dbf, dbfFam, lSel, lTop )

   local nRecAct  := ( dbf )->( Recno() )

   DEFAULT lSel   := .t.
   DEFAULT lTop   := .t.

   CreateWaitMeter( nil, nil, ( dbf )->( OrdKeyCount() ) )

   if lTop
      ( dbf )->( dbGoTop() )
   end if

   while !( dbf )->( eof() )
      lSelArt( lSel, nil, dbf, dbfFam )
      RefreshWaitMeter( ( dbf )->( OrdKeyNo() ) )
      ( dbf )->( dbSkip() )
   end do

   ( dbf )->( dbGoTo( nRecAct ) )

   EndWaitMeter()

   if oBrw != nil
      oBrw:Refresh()
      oBrw:SetFocus()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//
// Actualiza las unidades pendientes de recibir
//

function nPdtRecibir( cRef, nUnd, lInc, dbfArticulo )

   local nOrd     := ( dbfArticulo )->( ordSetFocus( 1 ) )

   DEFAULT lInc   := .t.

   if ( dbfArticulo )->( dbSeek( cRef ) ) .and. dbLock( dbfArticulo )
      ( dbfArticulo )->nPdtRec   += if( lInc, nUnd, - nUnd )
      ( dbfArticulo )->( dbUnlock() )
   end if

   ( dbfArticulo )->( ordSetFocus( nOrd ) )

return nil

//---------------------------------------------------------------------------//
//
// Controla el cambio en tablas de conversion
//

static function lTstFacCnv( aGet, aTmp, oSay )

   if aTmp[( dbfArticulo )->( fieldpos( "LFACCNV" ) ) ]
      return .t.
   else
      aGet[( dbfArticulo )->( fieldpos( "CFACCNV" ) ) ]:cText( Space( 2 ) )
      aGet[( dbfArticulo )->( fieldpos( "CFACCNV" ) ) ]:lValid()
      oSay[5]:cText( "" )
   end if

return .f.

//---------------------------------------------------------------------------//

FUNCTION EdmArt( cCodRut, cPathTo, oStru, oTipArt )

   local oBlock
   local oError
   local n           := 0
   local cChr
   local fTar
   local cFilEdm
   local cFilOdb
   local nWrote
   local nRead
   local dbf
   local dbfTIva

   DEFAULT cCodRut   := "001"
   DEFAULT cPathTo   := "C:\INTERS~1\"

   cCodRut           := SubStr( cCodRut, -3 )

   cFilEdm           := cPathTo + "EARTI" + cCodRut + ".TXT"
   cFilOdb           := cPathTo + "EARTI" + cCodRut + ".ODB"

   /*
   Creamos el fichero destino
   */

   IF file( cFilEdm )
      fErase( cFilEdm )
   END IF

   fTar              := fCreate( cFilEdm )

   /*
   Abrimos las bases de datos
   */

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbf ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfTIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   oStru:oMetUno:cText   := "Artículos"
   oStru:oMetUno:SetTotal( ( dbf )->( LastRec() ) )

   while !( dbf )->( eof() )

      if oTipArt:oDbf:Seek( ( dbf )->cCodTip ) .and. oTipArt:oDbf:lSelect

         cChr  := "+"
         cChr  += EdmRjust( (dbf)->CODIGO, Space( 1 ), 13 )                      // Codigo de cliente
         cChr  += EdmSubStr( (dbf)->NOMBRE, 1, 30 )                              // Nombre del estblecimiento
         cChr  += EdmSubStr( Trans( (dbf)->PVENTA1, "@ 9999.99" ), 1, 7 )        // Tarifa 1
         cChr  += EdmSubStr( Trans( (dbf)->PVENTA2, "@ 9999.99" ), 1, 7 )        // Tarifa 2
         cChr  += EdmSubStr( Trans( (dbf)->PVENTA3, "@ 9999.99" ), 1, 7 )        // Tarifa 3
         cChr  += EdmSubStr( Trans( (dbf)->PVENTA4, "@ 9999.99" ), 1, 7 )        // Tarifa 4
         cChr  += cCodTerIva( (dbf)->TipoIva, dbfTIva ) + ","                    // Codigo del tipo de impuestos
         cChr  += EdmSubStr( Trans( (dbf)->NUNICAJA, "@ 99999" ), 1, 5 )         // Lote unidades por caja
         cChr  += EdmSubStr( Trans( (dbf)->NPNTVER1, "@ 9999.99" ), 1, 7, .f. )  // Importe de punto verde
         cChr  += CRLF

         nWrote:= fwrite( fTar, cChr, nRead )

         oStru:oMetUno:Set( ( dbf )->( ++n ) )

         /*
         IF fError() != 0
            msginfo( "Hay errores" )
         END IF
         */

      end if

      (dbf)->( dbSkip() )

   END DO

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbf     )
   CLOSE ( dbfTIva )

   fClose( fTar    )

   if file( FullCurDir() + "CONVER.EXE" )
      WinExec( FullCurDir() + "CONVER.EXE " + cFilEdm + " " + cFilOdb + " 44 -x", 6 ) // Minimized
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Function cRetPreArt( cCodArt, nTarifa, cCodDiv, lIvaInc, dbfArticulo, dbfDiv, dbfArtKit, dbfIva, lBuscaImportes )

   local nPreArt           := 0
   local aDbfSta           := aGetStatus( dbfArticulo )

   DEFAULT lBuscaImportes  := uFieldEmpresa( "lBusImp" )

   /*
   Primero buscamos por codigos de barra---------------------------------------
   */

   ( dbfArticulo )->( ordSetFocus( "CodeBar" ) )

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      cCodArt              := ( dbfArticulo )->Codigo
   end if

   ( dbfArticulo )->( ordSetFocus( "Codigo" ) )

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      nPreArt              := nRetPreArt( nTarifa, cCodDiv, lIvaInc, dbfArticulo, dbfDiv, dbfArtKit, dbfIva, lBuscaImportes )
   end if

   SetStatus( dbfArticulo, aDbfSta )

Return ( nPreArt )

//---------------------------------------------------------------------------//

FUNCTION nRetPreIva( nTarifa, cCodDiv, dbfArticulo, dbfDiv )

   local nPre        := 0

   DEFAULT nTarifa   := 1

   while .t.

      do case
         case nTarifa == 1
            nPre  := ( dbfArticulo )->pVtaIva1
         case nTarifa == 2
            nPre  := ( dbfArticulo )->pVtaIva2
         case nTarifa == 3
            nPre  := ( dbfArticulo )->pVtaIva3
         case nTarifa == 4
            nPre  := ( dbfArticulo )->pVtaIva4
         case nTarifa == 5
            nPre  := ( dbfArticulo )->pVtaIva5
         case nTarifa == 6
            nPre  := ( dbfArticulo )->pVtaIva6
      end do

      if nPre == 0 .and. nTarifa > 1 .and. lBuscaImportes()
         nTarifa--
         loop
      else
         exit
      end if

   end while

return ( nPre )

//---------------------------------------------------------------------------//

FUNCTION nPreMedCom( cCodArt, cCodAlm, dbfAlbPrvT, dbfAlbPrvL, dbfFacPrvT, dbfFacPrvL, nDiv, nDecOut, nDerOut, dbfHisMov )

   local nPreMed  := 0
   local nTotUni  := 0
   local nTotPre  := 0
   local nOrdAlb  := ( dbfAlbPrvL )->( ordSetFocus( "cRef" ) )
   local nOrdFac  := ( dbfFacPrvL )->( ordSetFocus( "cRef" ) )
   local nOrdMov  := ( dbfHisMov )->( ordSetFocus( "cRefMov" ) )

   if nDiv == 0
      nDiv        := 1
   end if

   if ( dbfAlbPrvL )->( dbSeek( cCodArt ) )

      while ( dbfAlbPrvL )->cRef == cCodArt .and. !( dbfAlbPrvL )->( Eof() )

         if !lFacAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT ) .and. ;
            ( dbfAlbPrvL )->cAlmLin == cCodAlm .or. Empty( cCodAlm )

            nTotUni += nTotNAlbPrv( dbfAlbPrvL )
            nTotPre += nImpLAlbPrv( dbfAlbPrvT, dbfAlbPrvL, nDecOut, nDerOut, nDiv )

         end if

         ( dbfAlbPrvL )->( dbSkip() )

      end while

   end if

   if ( dbfFacPrvL )->( dbSeek( cCodArt ) )

      while ( dbfFacPrvL )->cRef == cCodArt .AND. !( dbfFacPrvL )->( Eof() )

         if ( dbfFacPrvL )->cAlmLin == cCodAlm .or. Empty( cCodAlm )

            nTotUni += nTotNFacPrv( dbfFacPrvL )
            nTotPre += nImpLFacPrv( dbfFacPrvT, dbfFacPrvL, nDecOut, nDerOut, nDiv )

         end if

         ( dbfFacPrvL )->( dbSkip() )

      end while

   end if

   if ( dbfHisMov )->( dbSeek( cCodArt ) )

      while ( dbfHisMov )->cRefMov == cCodArt .AND. !( dbfHisMov )->( Eof() )

         if ( dbfHisMov )->cAliMov == cCodAlm .or. Empty( cCodAlm )

            nTotUni += nTotNMovAlm( dbfHisMov )
            nTotPre += ( dbfHisMov )->nPreDiv

         end if

         ( dbfHisMov )->( dbSkip() )

      end while

   end if

   if nTotUni != 0
      nPreMed     := Round( Div( Div( nTotPre, nTotUni ), nDiv ), nDecOut )
   end if

   ( dbfAlbPrvL )->( ordSetFocus( nOrdAlb ) )
   ( dbfFacPrvL )->( ordSetFocus( nOrdFac ) )
   ( dbfHisMov )->( ordSetFocus( nOrdMov ) )

return ( nPreMed )

//---------------------------------------------------------------------------//

Function nCostoEscandallo( aTmp, dbfTmpKit, dbfArticulo, dbfArtKit, lPic, cDivRet, dbfDiv )

   local nCosto   := 0
   local nOrdArt  := ( dbfArticulo )->( OrdSetFocus( 1 ) )
   local nRecArt  := ( dbfArticulo )->( Recno() )
   local nRecKit  := ( dbfTmpKit )->( Recno() )

   DEFAULT lPic   := .f.

   if aTmp[ ( dbfArticulo )->( fieldpos( "lKitArt" ) ) ]

      ( dbfTmpKit )->( dbGoTop() )
      while !( dbfTmpKit )->( eof() )
         nCosto   += nCosto( ( dbfTmpKit )->cRefKit, dbfArticulo, dbfArtKit ) * ( dbfTmpKit )->nUndKit * nFactorConversion( ( dbfTmpKit )->cRefKit, dbfArticulo )
         ( dbfTmpKit )->( dbSkip() )
      end while

   end if

   ( dbfArticulo )->( OrdSetFocus( nOrdArt ) )
   ( dbfArticulo )->( dbGoTo( nRecArt ) )
   ( dbfTmpKit   )->( dbGoTo( nRecKit ) )

   if dbfDiv != nil
      if cDivRet != nil .and. cDivRet != cDivEmp()
         nCosto   := nCnv2Div( nCosto, cDivEmp(), cDivRet )
         if lPic
            nCosto:= Trans( nCosto, cPinDiv( cDivRet, dbfDiv ) )
         end if
      else
         if lPic
            nCosto:= Trans( nCosto, cPinDiv( cDivEmp(), dbfDiv ) )
         end if
      end if
   end if

Return ( nCosto )

//---------------------------------------------------------------------------//

Function nCostoLin( cCodArt, dbfArticulo, dbfArtKit, lPic, cDivRet, dbfDiv )

   local nCosto

   DEFAULT lPic   := .f.

   nCosto         := nCosto( cCodArt, dbfArticulo, dbfArtKit, .f., cDivRet, dbfDiv, lPic )
   nCosto         *= ( dbfArtKit )->nUndKit

   if dbfDiv != nil

      if cDivRet != nil .and. cDivRet != cDivEmp()

         nCosto   := nCnv2Div( nCosto, cDivEmp(), cDivRet )
         if lPic
            nCosto:= Trans( nCosto, cPinDiv( cDivRet, dbfDiv ) )
         end if

      else

         if lPic
            nCosto:= Trans( nCosto, cPinDiv( cDivEmp(), dbfDiv ) )
         end if

      end if

   end if

return ( nCosto )

//---------------------------------------------------------------------------//

function CalPosTactil( oMeter, lMessage )

   local oBlock
   local oError
   local nDouDiv
   local nRouDiv
   local dbfArticulo
   local dbfTikL
   local dbfDiv

   DEFAULT lMessage  := .t.

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatEmp() + "TIKEL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   if oMeter != nil .and. lMessage
      oMeter:nTotal  := ( dbfTikL )->( LastRec() )
   end if

   nDouDiv           := nDouDiv( cDivEmp(), dbfDiv ) // Decimales de la divisa
   nRouDiv           := nRouDiv( cDivEmp(), dbfDiv ) // Decimales de la divisa redondeada

   ( dbfArticulo )->( dbGoTop() )
   while !( dbfArticulo )->( eof() )

      if dbLock( dbfArticulo )
         ( dbfArticulo )->nPosTcl   := 0
         ( dbfArticulo )->( dbUnLock() )
      end if

      ( dbfArticulo )->( dbSkip() )
   end while

   ( dbfTikL )->( dbGoTop() )
   while !( dbfTikL )->( eof() )

      if ( dbfArticulo )->( dbSeek( ( dbfTikL )->cCbaTil ) )
         if dbLock( dbfArticulo )
            ( dbfArticulo )->nPosTcl   +=  nTotNTpv( dbfTikL )
            ( dbfArticulo )->( dbUnLock() )
         end if
      end if

      /*
      Ponemos el meter
      */

      if oMeter != nil .and. lMessage
         oMeter:Set( ( dbfTikL )->( OrdKeyNo() ) )
      end if

      sysrefresh()

      ( dbfTikL )->( dbSkip() )

   end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfArticulo)
   CLOSE ( dbfTikL    )
   CLOSE ( dbfDiv     )

   dbfDiv      := NIL
   dbfTikL     := NIL
   dbfArticulo := NIL

return nil

//---------------------------------------------------------------------------//

Function SearchProveedor()

   local nSea     := 1
	local oDlg
   local nOrd     := ( dbfArtPrv )->( OrdSetFocus( "cRefPrv" ) )
   local oGetPrv
   local cGetPrv  := dbFirst( dbfProv )
   local oSayPrv
   local cSayPrv  := dbFirst( dbfProv, 2 )
   local oGetArt
   local cGetArt  := Space( 18 )
   local oGetBar
   local cGetBar  := Space( 18 )

   DEFINE DIALOG oDlg RESOURCE "Search"

      REDEFINE RADIO nSea ;
         ID       120, 121 ;
         OF       oDlg

      REDEFINE GET oGetBar VAR cGetBar ;
         ID       130 ;
         WHEN     ( nSea == 1 ) ;
         OF       oDlg

      REDEFINE GET oGetPrv VAR cGetPrv;
         ID       100 ;
         WHEN     ( nSea == 2 ) ;
         VALID    ( cProvee( oGetPrv, dbfProv, oSayPrv ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwProvee( oGetPrv, oSayPrv ) ) ;
         OF       oDlg

      REDEFINE GET oSayPrv VAR cSayPrv ;
         WHEN     .f. ;
         ID       101 ;
         OF       oDlg

      REDEFINE GET oGetArt VAR cGetArt ;
         ID       110 ;
         WHEN     ( nSea == 2 ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( PosProveedor( nSea, cGetPrv, cGetArt, cGetBar ) )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:bStart    := {|| oGetBar:SetFocus() }
   
   oDlg:AddFastKey( VK_F5, {|| PosProveedor( nSea, cGetPrv, cGetArt, cGetBar ) } )   

   ACTIVATE DIALOG oDlg CENTER

   ( dbfArtPrv )->( OrdSetFocus( nOrd ) )

RETURN NIL

//---------------------------------------------------------------------------//

Static Function PosProveedor( nSea, cGetPrv, cGetArt, cGetBar )

   local nCod
   local nOrd

   if nSea == 1

      if dbSeekInOrd( cGetBar, "cCodBar", dbfCodeBar )
         if dbSeekInOrd( ( dbfCodeBar )->cCodArt, "Codigo", dbfArticulo )
            oWndBrw:SetFocus()
         else
            msgStop( "Artículo " + Rtrim( ( dbfCodeBar )->cCodArt ) + " no encontrado." )
         end if
      else
         if dbSeekInOrd( cGetBar, "CodeBar", dbfArticulo )
            oWndBrw:Refresh()
         else
            msgStop( "Código de barras " + Rtrim( cGetBar ) + " no encontrado." )
         end if
      end if

   else

      if ( dbfArtPrv )->( dbSeek( cGetPrv + cGetArt ) )
         if dbSeekInOrd( ( dbfArtPrv )->cCodArt, "Codigo", dbfArticulo ) 
            oWndBrw:SetFocus()
         else
            msgStop( "Artículo " + Rtrim( ( dbfArtPrv )->cCodArt ) + " no encontrado." )
         end if
      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//

//
// Devuelve el de barras pasandole el codigo interno
//

Function cCodeBar( cCodArticulo, dbfCodebar )

   local cCodeBar          := ""
   local nOrdenAnterior    := ( dbfCodebar )->( OrdSetFocus( "cCodArt" ) )

   if ( dbfCodebar )->( dbSeek( cCodArticulo ) )
      cCodeBar             := ( dbfCodebar )->cCodBar
   end if

   ( dbfCodebar )->( OrdSetFocus( nOrdenAnterior ) )

Return ( cCodeBar )

//-------------------------------------------------------------------------//

Function bGenEdtArticulo( cCodArt )

   local bGen
   local cDoc           := by( cCodArt )

   bGen                 := {|| EdtArticulo( cDoc ) }

return ( bGen )

//---------------------------------------------------------------------------//

Function EdtArticulo( cCodArt, lOpenBrowse )

   local oBlock
   local oError
   local nLevel         := nLevelUsr( "01014" )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if lOpenBrowse

      if Articulo()
         if dbSeekInOrd( cCodArt, "Codigo", dbfArticulo )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra artículo" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( cCodArt, "Codigo", dbfArticulo )
            WinEdtRec( oWndBrw, bEdit, dbfArticulo )
         else
            MsgStop( "No se encuentra artículo con código " + Rtrim( cCodArt ) )
         end if
         CloseFiles()
      end if

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error editando artículo" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN .t.

//--------------------------------------------------------------------------//

Function AppArticulo( lOpenBrowse )

   local oBlock
   local oError
   local nLevel         := nLevelUsr( "01014" )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if lOpenBrowse

         if Articulo()
            oWndBrw:RecAdd()
         end if

      else

         if OpenFiles( .t. )
            WinAppRec( oWndBrw, bEdit, dbfArticulo )
            CloseFiles()
         end if

      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error añadiendo artículo" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION InfArticulo( cCodArt, oBrw )

   local nLevel   := nLevelUsr( "01014" )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if !OpenFiles( .t. )
      CloseFiles()
      return nil
   end if

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      BrwVtaComArt( ( dbfArticulo )->Codigo, ( dbfArticulo )->Nombre, dbfDiv, dbfIva, dbfAlmT, dbfArticulo )
   else
      MsgStop( "No se encuentra artículo" )
   end if

   if oBrw != nil
      oBrw:Refresh()
   end if

   CloseFiles()

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION CargaValorCat( aTmp, aGet, oSay, oValorPunto, oValorDto, oValorTot, nMode, lFastMode )

   local nOrdAnt

   DEFAULT lFastMode := .f.

   if !lFastMode

      if cCatOld != aTmp[ ( dbfArticulo )->( fieldpos( "CCODCAT" ) ) ]                       .and.;
         ( dbfCatalogo )->( dbSeek( aTmp[ ( dbfArticulo )->( fieldpos( "CCODCAT" ) ) ] ) )   .and.;
         !( dbfCatalogo )->lObsCat

         if ApoloMsgNoYes(  "¿ Desea actualizar los datos del artículo con los datos del catálogo ?", "Elija una opción" )

            nOrdAnt     := ( dbfTmpPrv )->( OrdSetFocus( "CREFPRV" ) )

            aTmp[ ( dbfArticulo )->( fieldpos( "NPUNTOS" ) ) ]  := ( dbfCatalogo )->nValPunt
            aTmp[ ( dbfArticulo )->( fieldpos( "NDTOPNT" ) ) ]  := ( dbfCatalogo )->nDtoPunt

            if ( dbfTmpPrv )->( dbSeek( ( dbfCatalogo )->cCodProv + Space( 18 ) ) )

               ( dbfTmpPrv )->( dbGoTop() )
               while !( dbfTmpPrv )->( eof () )
                  ( dbfTmpPrv )->lDefPrv     := ( dbfTmpPrv )->cCodPrv + ( dbfTmpPrv )->cRefPrv == ( dbfCatalogo )->cCodProv + Space( 18 )
               ( dbfTmpPrv )->( dbSkip() )
               end while

            else

               ( dbfTmpPrv )->( dbGoTop() )
               while !( dbfTmpPrv )->( eof () )
                  ( dbfTmpPrv )->lDefPrv     := .f.
               ( dbfTmpPrv )->( dbSkip() )
               end while

               ( dbfTmpPrv )->( dbAppend() )
               ( dbfTmpPrv )->cCodPrv        := ( dbfCatalogo )->cCodProv
               ( dbfTmpPrv )->lDefPrv        := .t.

            end if

            aTmp[ ( dbfArticulo )->( fieldpos( "CPRVHAB" ) ) ]  := ( dbfCatalogo )->cCodProv

            //-------Tarifa 1---------------------------------------------------//

            if aTmp[ ( dbfArticulo )->( fieldpos( "LBNF1"    ) ) ]
               aTmp[ ( dbfArticulo )->( fieldpos( "BENEF1"   ) ) ] := ( dbfCatalogo )->Benef1
               aTmp[ ( dbfArticulo )->( fieldpos( "NBNFSBR1" ) ) ] := ( dbfCatalogo )->nBnfSbr1
               oSay[ 11 ]:Select( Max( ( dbfCatalogo )->nBnfSbr1, 1 ) )
               aGet[ ( dbfArticulo )->( fieldpos( "BENEF1" ) ) ]:lValid()
            end if

            //-------Tarifa 2---------------------------------------------------//

            if aTmp[ ( dbfArticulo )->( fieldpos( "LBNF2" ) ) ]
               aTmp[ ( dbfArticulo )->( fieldpos( "BENEF2" ) ) ]   := ( dbfCatalogo )->Benef2
               aTmp[ ( dbfArticulo )->( fieldpos( "NBNFSBR2" ) ) ] := ( dbfCatalogo )->nBnfSbr2
               oSay[ 12 ]:Select( Max( ( dbfCatalogo )->nBnfSbr2, 1 ) )
               aGet[ ( dbfArticulo )->( fieldpos( "BENEF2" ) ) ]:lValid()
            end if

            //-------Tarifa 3---------------------------------------------------//

            if aTmp[ ( dbfArticulo )->( fieldpos( "LBNF3" ) ) ]
               aTmp[ ( dbfArticulo )->( fieldpos( "BENEF3" ) ) ]   := ( dbfCatalogo)->Benef3
               aTmp[ ( dbfArticulo )->( fieldpos( "NBNFSBR3" ) ) ] := ( dbfCatalogo )->nBnfSbr3
               oSay[ 13 ]:Select( Max( ( dbfCatalogo )->nBnfSbr3, 1 ) )
               aGet[ ( dbfArticulo )->( fieldpos( "BENEF3" ) ) ]:lValid()
            end if

            //-------Tarifa 4---------------------------------------------------//

            if aTmp[ ( dbfArticulo )->( fieldpos( "LBNF4" ) ) ]
               aTmp[ ( dbfArticulo )->( fieldpos( "BENEF4" ) ) ]   := ( dbfCatalogo )->Benef4
               aTmp[ ( dbfArticulo )->( fieldpos( "NBNFSBR4" ) ) ] := ( dbfCatalogo )->nBnfSbr4
               oSay[ 14 ]:Select( Max( ( dbfCatalogo )->nBnfSbr4, 1 ) )
               aGet[ ( dbfArticulo )->( fieldpos( "BENEF4" ) ) ]:lValid()
            end if

            //-------Tarifa 5---------------------------------------------------//

            if aTmp[ ( dbfArticulo )->( fieldpos( "LBNF5" ) ) ]
               aTmp[ ( dbfArticulo )->( fieldpos( "BENEF5" ) ) ]   := ( dbfCatalogo )->Benef5
               aTmp[ ( dbfArticulo )->( fieldpos( "NBNFSBR5" ) ) ] := ( dbfCatalogo )->nBnfSbr5
               oSay[ 15 ]:Select( Max( ( dbfCatalogo )->nBnfSbr5, 1 ) )
               aGet[ ( dbfArticulo )->( fieldpos( "BENEF5" ) ) ]:lValid()
            end if

            //-------Tarifa 6---------------------------------------------------//

            if aTmp[ ( dbfArticulo )->( fieldpos( "LBNF6" ) ) ]
               aTmp[ ( dbfArticulo )->( fieldpos( "BENEF6" ) ) ]   := ( dbfCatalogo )->Benef6
               aTmp[ ( dbfArticulo )->( fieldpos( "NBNFSBR6" ) ) ] := ( dbfCatalogo )->nBnfSbr6
               oSay[ 16 ]:Select( Max( ( dbfCatalogo )->nBnfSbr6, 1 ) )
               aGet[ ( dbfArticulo )->( fieldpos( "BENEF6" ) ) ]:lValid()
            end if

         end if

      end if

      //--------Refresca los objetos para que muestren los valores--------//

      oValorPunto:Refresh()

      oValorDto:Refresh()

      oValorTot:Refresh()

      aGet[ ( dbfArticulo )->( fieldpos( "BENEF1" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "BENEF2" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "BENEF3" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "BENEF4" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "BENEF5" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "BENEF6" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "PVENTA1" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "PVENTA2" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "PVENTA3" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "PVENTA4" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "PVENTA5" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "PVENTA6" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA1" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA2" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA3" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA4" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA5" ) ) ]:Refresh()
      aGet[ ( dbfArticulo )->( fieldpos( "PVTAIVA6" ) ) ]:Refresh()

      ( dbfTmpPrv )->( OrdSetFocus( nOrdAnt ) )

   else

      if cCatOld != aTmp[ ( dbfArticulo )->( fieldpos( "CCODCAT" ) ) ]                     .and.;
         ( dbfCatalogo )->( dbSeek( aTmp[ ( dbfArticulo )->( fieldpos( "CCODCAT" ) ) ] ) )

         aTmp[ ( dbfArticulo )->( fieldpos( "NPUNTOS" ) ) ]  := ( dbfCatalogo )->nValPunt
         aTmp[ ( dbfArticulo )->( fieldpos( "NDTOPNT" ) ) ]  := ( dbfCatalogo )->nDtoPunt
         aTmp[ ( dbfArticulo )->( fieldpos( "CPRVHAB" ) ) ]  := ( dbfCatalogo )->cCodProv
         oSay[4]:cText( RetProvee( ( dbfCatalogo )->cCodProv ) )

         //-------Tarifa 1---------------------------------------------------//

         if aTmp[ ( dbfArticulo )->( fieldpos( "LBNF1" ) ) ]
            aTmp[ ( dbfArticulo )->( fieldpos( "BENEF1" ) ) ]   := ( dbfCatalogo )->Benef1
            aTmp[ ( dbfArticulo )->( fieldpos( "NBNFSBR1" ) ) ] := ( dbfCatalogo )->nBnfSbr1
         end if

         //-------Tarifa 2---------------------------------------------------//

         if aTmp[ ( dbfArticulo )->( fieldpos( "LBNF2" ) ) ]
            aTmp[ ( dbfArticulo )->( fieldpos( "BENEF2" ) ) ]   := ( dbfCatalogo )->Benef2
            aTmp[ ( dbfArticulo )->( fieldpos( "NBNFSBR2" ) ) ] := ( dbfCatalogo )->nBnfSbr2
         end if

         //-------Tarifa 3---------------------------------------------------//

         if aTmp[ ( dbfArticulo )->( fieldpos( "LBNF3" ) ) ]
            aTmp[ ( dbfArticulo )->( fieldpos( "BENEF3" ) ) ]   := ( dbfCatalogo)->Benef3
            aTmp[ ( dbfArticulo )->( fieldpos( "NBNFSBR3" ) ) ] := ( dbfCatalogo )->nBnfSbr3
         end if

         //-------Tarifa 4---------------------------------------------------//

         if aTmp[ ( dbfArticulo )->( fieldpos( "LBNF4" ) ) ]
            aTmp[ ( dbfArticulo )->( fieldpos( "BENEF4" ) ) ]   := ( dbfCatalogo )->Benef4
            aTmp[ ( dbfArticulo )->( fieldpos( "NBNFSBR4" ) ) ] := ( dbfCatalogo )->nBnfSbr4
         end if

         //-------Tarifa 5---------------------------------------------------//

         if aTmp[ ( dbfArticulo )->( fieldpos( "LBNF5" ) ) ]
            aTmp[ ( dbfArticulo )->( fieldpos( "BENEF5" ) ) ]   := ( dbfCatalogo )->Benef5
            aTmp[ ( dbfArticulo )->( fieldpos( "NBNFSBR5" ) ) ] := ( dbfCatalogo )->nBnfSbr5
         end if

         //-------Tarifa 6---------------------------------------------------//

         if aTmp[ ( dbfArticulo )->( fieldpos( "LBNF6" ) ) ]
            aTmp[ ( dbfArticulo )->( fieldpos( "BENEF6" ) ) ]   := ( dbfCatalogo )->Benef6
            aTmp[ ( dbfArticulo )->( fieldpos( "NBNFSBR6" ) ) ] := ( dbfCatalogo )->nBnfSbr6
         end if

      end if

      oValorPunto:Refresh()

      oValorDto:Refresh()

      oValorTot:Refresh()

      aGet[ ( dbfArticulo )->( fieldpos( "CPRVHAB" ) )]:Refresh()

      oSay[4]:Refresh()

   end if

   cCatOld  := aTmp[ ( dbfArticulo )->( fieldpos( "CCODCAT" ) ) ]

RETURN .t.

//---------------------------------------------------------------------------//

function SynArt( cPath )

   local cCod     := ""
   local nCosto   := 0
   local nOrdAnt

   DEFAULT cPath  := cPatArt()

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() )    EXCLUSIVE ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() )      EXCLUSIVE ALIAS ( cCheckArea( "ARTTIK", @dbfArtKit ) )
   SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() )     EXCLUSIVE ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
   SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

   USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() )    EXCLUSIVE ALIAS ( cCheckArea( "FAMILIAS", @dbfFam ) )
   SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() )  EXCLUSIVE ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
   SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

   USE ( cPatArt() + "ArtImg.Dbf" ) NEW VIA ( cDriver() )      EXCLUSIVE ALIAS ( cCheckArea( "ArtImg", @dbfImg ) )
   SET ADSINDEX TO ( cPatArt() + "ArtImg.Cdx" ) ADDITIVE

   USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() )      SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOfe ) )
   SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() )    SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE
   SET TAG TO "cRefFec"

   USE ( cPatEmp() + "FACPRVL.DBF" ) NEW VIA ( cDriver() )     SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
   SET TAG TO "cRefFec"

   oNewImp              := TNewImp():Create( cPatEmp() )
   if oNewImp:OpenFiles()

      ( dbfArticulo )->( dbGoTop() )

      while !( dbfArticulo )->( eof() )

         if !( dbfArticulo )->lKitArt

            while ( dbfArtKit )->( dbSeek( ( dbfArticulo )->Codigo ) )
               ( dbfArtKit )->( dbDelete() )
            end while

         end if

         /*
         Marca para proveedor habitual
         */

         if !Empty( ( dbfArticulo )->cPrvHab )

            if !( dbfArtPrv )->( dbSeek( ( dbfArticulo )->Codigo + ( dbfArticulo )->cPrvHab ) )

               if ( dbfArtPrv )->( dbSeek( ( dbfArticulo )->Codigo ) )

                  while ( dbfArtPrv )->cCodArt == ( dbfArticulo )->Codigo .and. !( dbfArtPrv )->( eof() )
                     ( dbfArtPrv )->lDefPrv   := .f.
                     ( dbfArtPrv )->( dbSkip() )
                  end while

                  ( dbfArtPrv )->( dbAppend() )
                  ( dbfArtPrv )->cCodArt         := ( dbfArticulo )->Codigo
                  ( dbfArtPrv )->cCodPrv         := ( dbfArticulo )->cPrvHab
                  ( dbfArtPrv )->cDivPrv         := cDivEmp()
                  ( dbfArtPrv )->lDefPrv         := .t.
                  ( dbfArtPrv )->( dbUnLock() )

               end if

            end if

         end if

         /*
         Sincronizamos las fechas de LASTCHGcreación y de cambio---------------
         */

         do case
            case Empty( ( dbfArticulo )->LastChg ) .and. Empty( ( dbfArticulo )->dFecChg )

               ( dbfArticulo )->LastChg := GetSysDate()
               ( dbfArticulo )->dFecChg := GetSysDate()
               ( dbfArticulo )->( dbUnLock() )

            case Empty( ( dbfArticulo )->LastChg )

               ( dbfArticulo )->LastChg := ( dbfArticulo )->dFecChg

            case Empty( ( dbfArticulo )->dFecChg )

               ( dbfArticulo )->dFecChg := ( dbfArticulo )->LastChg

         end case

         /*
         Si tenemos marcada la opción de "Cambiar precios de costo automáticamente"
         ponemos en la ficha del artículo el precio de la última compra.
         */

         if uFieldEmpresa( "lActCos" )

            nCosto                     := nCostoUltimaCompra( ( dbfArticulo )->Codigo, dbfAlbPrvL, dbfFacPrvL )
            if nCosto != 0
               ( dbfArticulo )->pCosto := nCosto
            end if

         end if

         /*
         Recalculamos precios de artículos-------------------------------------
         */

         nCosto                        := ( dbfArticulo )->pCosto

         if ( dbfArticulo )->lBnf1 .and. nCosto != 0
            ( dbfArticulo )->pVenta1   := CalPre( if( ( dbfArticulo )->nBnfSbr1 <= 1, .t., .f. ), nCosto, .t., ( dbfArticulo )->Benef1, ( dbfArticulo )->TipoIva, nil, nil, nDouDiv( cDivEmp(), dbfDiv ), ( dbfArticulo )->cCodImp, nil )
            ( dbfArticulo )->pVtaIva1  := ( dbfArticulo )->pVenta1 + Round( ( ( dbfArticulo )->pVenta1 * nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100 ), nDouDiv( cDivEmp(), dbfDiv ) )
         end if

         if ( dbfArticulo )->lBnf2 .and. nCosto != 0
            ( dbfArticulo )->pVenta2   := CalPre( if( ( dbfArticulo )->nBnfSbr2 <= 1, .t., .f. ), nCosto, .t., ( dbfArticulo )->Benef2, ( dbfArticulo )->TipoIva, nil, nil, nDouDiv( cDivEmp(), dbfDiv ), ( dbfArticulo )->cCodImp, nil )
            ( dbfArticulo )->pVtaIva2  := ( dbfArticulo )->pVenta2 + Round( ( ( dbfArticulo )->pVenta2 * nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100 ), nDouDiv( cDivEmp(), dbfDiv ) )
         end if

         if ( dbfArticulo )->lBnf3 .and. nCosto != 0
            ( dbfArticulo )->pVenta3   := CalPre( if( ( dbfArticulo )->nBnfSbr3 <= 1, .t., .f. ), nCosto, .t., ( dbfArticulo )->Benef3, ( dbfArticulo )->TipoIva, nil, nil, nDouDiv( cDivEmp(), dbfDiv ), ( dbfArticulo )->cCodImp, nil )
            ( dbfArticulo )->pVtaIva3  := ( dbfArticulo )->pVenta3 + Round( ( ( dbfArticulo )->pVenta3 * nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100 ), nDouDiv( cDivEmp(), dbfDiv ) )
         end if

         if ( dbfArticulo )->lBnf4 .and. nCosto != 0
            ( dbfArticulo )->pVenta4   := CalPre( if( ( dbfArticulo )->nBnfSbr4 <= 1, .t., .f. ), nCosto, .t., ( dbfArticulo )->Benef4, ( dbfArticulo )->TipoIva, nil, nil, nDouDiv( cDivEmp(), dbfDiv ), ( dbfArticulo )->cCodImp, nil )
            ( dbfArticulo )->pVtaIva4  := ( dbfArticulo )->pVenta4 + Round( ( ( dbfArticulo )->pVenta4 * nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100 ), nDouDiv( cDivEmp(), dbfDiv ) )
         end if

         if ( dbfArticulo )->lBnf5 .and. nCosto != 0
            ( dbfArticulo )->pVenta5   := CalPre( if( ( dbfArticulo )->nBnfSbr5 <= 1, .t., .f. ), nCosto, .t., ( dbfArticulo )->Benef5, ( dbfArticulo )->TipoIva, nil, nil, nDouDiv( cDivEmp(), dbfDiv ), ( dbfArticulo )->cCodImp, nil )
            ( dbfArticulo )->pVtaIva5  := ( dbfArticulo )->pVenta5 + Round( ( ( dbfArticulo )->pVenta5 * nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100 ), nDouDiv( cDivEmp(), dbfDiv ) )
         end if

         if ( dbfArticulo )->lBnf6 .and. nCosto != 0
            ( dbfArticulo )->pVenta6   := CalPre( if( ( dbfArticulo )->nBnfSbr6 <= 1, .t., .f. ), nCosto, .t., ( dbfArticulo )->Benef6, ( dbfArticulo )->TipoIva, nil, nil, nDouDiv( cDivEmp(), dbfDiv ), ( dbfArticulo )->cCodImp, nil )
            ( dbfArticulo )->pVtaIva6  := ( dbfArticulo )->pVenta6 + Round( ( ( dbfArticulo )->pVenta6 * nIva( dbfIva, ( dbfArticulo )->TipoIva ) / 100 ), nDouDiv( cDivEmp(), dbfDiv ) )
         end if

         /*
         Propiedades de los articulos------------------------------------------
         */

         if !( dbfArticulo )->lCodPrp

            if ( dbfFam )->( dbSeek( ( dbfArticulo )->Familia ) )

               if Empty( ( dbfArticulo )->cCodPrp1 ) .and. !Empty( ( dbfFam )->cCodPrp1 )
                  ( dbfArticulo )->cCodPrp1  := ( dbfFam )->cCodPrp1
               end if

               if Empty( ( dbfArticulo )->cCodPrp2 ) .and. !Empty( ( dbfFam )->cCodPrp2 )
                  ( dbfArticulo )->cCodPrp2  := ( dbfFam )->cCodPrp2
               end if

            end if

            ( dbfArticulo )->lCodPrp         := .t.

         end if

         /*
         Buscamos si exite un codigo de barras por defecto---------------------
         */

         if Empty( ( dbfArticulo )->Codebar )

            nOrdAnt                           := ( dbfCodebar )->( OrdSetFocus( "cCodArt" ) )

            if ( dbfCodebar )->( dbSeek( ( dbfArticulo )->Codigo ) )
               ( dbfArticulo )->CodeBar      := ( dbfCodebar )->cCodBar
            end if

             ( dbfCodebar )->( OrdSetFocus( nOrdAnt ) )

         end if

         /*
         Factores de conversión de articulos-----------------------------------
         */

         if ( dbfArticulo )->nFacCnv == 0
            ( dbfArticulo )->nFacCnv := 1
         end if

         /*
         Imagenes--------------------------------------------------------------
         */

         if !Empty( ( dbfArticulo )->cImagenWeb )

            ( dbfImg )->( __dbLocate( { || Rtrim( ( dbfImg )->cImgArt ) == Rtrim( ( dbfArticulo )->cImagenWeb ) } ) )
            if !( dbfImg )->( Found() )

               ( dbfImg )->( dbAppend() )
               ( dbfImg )->cCodArt   := ( dbfArticulo )->Codigo
               ( dbfImg )->cImgArt   := ( dbfArticulo )->cImagenWeb
               ( dbfImg )->( dbUnLock() )

            end if

         end if

         /*
         Nos aseguramos de que haya una imagen por defecto del artículo--------
         */

         if !dbSeekInOrd( ( dbfArticulo )->Codigo, "lDefImg", dbfImg )

            if dbSeekInOrd( ( dbfArticulo )->Codigo, "cCodArt", dbfImg )
               ( dbfImg )->lDefImg     := .t.
            end if

         end if

         /*
         Tarifas de la Web-----------------------------------------------------
         */

         if ( dbfArticulo )->nTarWeb   < 1
            ( dbfArticulo )->nTarWeb   := 1
         end if

         ( dbfArticulo )->( dbSkip() )

         SysRefresh()

      end while

      /*
      Codigos de barras sin codigos de articulos
      -------------------------------------------------------------------------
      */

      ( dbfCodebar )->( dbGoTop() )
      while !( dbfCodebar )->( eof() )

         if !( dbfArticulo )->( dbSeek( ( dbfCodebar )->cCodArt ) )
            ( dbfCodebar )->( dbDelete() )
         end if

         ( dbfCodebar )->( dbSkip() )

         SysRefresh()

      end while

      /*
      Codigos de barras en blanco
      -------------------------------------------------------------------------
      */

      ( dbfCodebar )->( dbGoTop() )
      while !( dbfCodebar )->( eof() )

         if Empty( ( dbfCodebar )->cCodBar )
            ( dbfCodebar )->( dbDelete() )
         end if

         ( dbfCodebar )->( dbSkip() )

         SysRefresh()

      end while

      /*
      Codigos de barras duplicados
      -------------------------------------------------------------------------
      */

      ( dbfCodebar )->( OrdSetFocus( "cArtBar" ) )

      ( dbfCodebar )->( dbGoTop() )
      while !( dbfCodebar )->( eof() )

         cCod  := ( dbfCodebar )->cCodArt + ( dbfCodebar )->cCodBar

         ( dbfCodebar )->( dbSkip() )

         if ( dbfCodebar )->cCodArt + ( dbfCodebar )->cCodBar == cCod
            ( dbfCodebar )->( dbDelete() )
         end if

         SysRefresh()

      end while

      /*
      Ofertas sin tipo de oferta
      -------------------------------------------------------------------------
      */

      ( dbfOfe )->( dbGoTop() )

      while !( dbfOfe )->( eof() )

         if ( dbfOfe )->nTblOfe < 1

            if dbLock( dbfOfe )
               ( dbfOfe )->nTblOfe     := 1
               ( dbfOfe )->( dbUnLock() )
            end if

         end if

         ( dbfOfe )->( dbSkip() )

         SysRefresh()

      end while

   end if

   /*
   Cerramos todas las tablas---------------------------------------------------
   */

   CLOSE ( dbfArticulo )
   CLOSE ( dbfArtKit   )
   CLOSE ( dbfArtPrv   )
   CLOSE ( dbfFam      )
   CLOSE ( dbfCodebar  )
   CLOSE ( dbfImg      )
   CLOSE ( dbfOfe      )
   CLOSE ( dbfAlbPrvL  )
   CLOSE ( dbfFacPrvL  )

   if !Empty( oNewImp )
      oNewImp:End()
   end if

return nil

//---------------------------------------------------------------------------//

Static Function EndTrans2( aTmp, aGet, oSay, oDlg, nMode )

   local cCod     := aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]

   /*
   Valores que tienen que estar rellenos---------------------------------------
   */

   if Empty( cCod )
      MsgStop( "Código no puede estar vacío" )
      return nil
   end if

   if Empty( aTmp[( dbfArticulo )->( fieldpos( "Nombre" ) ) ] )
      MsgStop( "Descripción no puede estar vacío" )
      return nil
   end if

   if Empty( oSay[3]:varGet() )
      MsgStop( "Referencia artículo-proveedor no puede estar vacía" )
      return nil
   end if

   if ( dbfArticulo )->( dbSeek( cCod ) )
      msgStop( "Código ya existe" )
      return nil
   end if

   /*
   Tomamos valores por defecto-------------------------------------------------
   */

   aTmp[ ( dbfArticulo )->( fieldpos( "Codebar" ) ) ] := cCod
   aTmp[ ( dbfArticulo )->( fieldpos( "lSndDoc" ) ) ] := .t.
   aTmp[ ( dbfArticulo )->( fieldpos( "dFecChg" ) ) ] := GetSysDate()
   aTmp[ ( dbfArticulo )->( fieldpos( "LastChg" ) ) ] := GetSysDate()
   aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ] := cDefIva()
   aTmp[ ( dbfArticulo )->( fieldpos( "lIvaInc" ) ) ] := .f.

   /*
   Calculamos e informamos los 6 precios de venta
   */

   aTmp[ ( dbfArticulo )->( fieldpos( "pVenta1" ) ) ] := aCalPrePnt( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr1" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, dbfArticulo ),;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "lBnf1" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "Benef1" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     dbfIva )[1]

   aTmp[ ( dbfArticulo )->( fieldpos( "pVtaIva1") ) ] := aCalPrePnt( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr1" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, dbfArticulo ),;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "lBnf1" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "Benef1" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     dbfIva )[2]

   aTmp[ ( dbfArticulo )->( fieldpos( "pVenta2" ) ) ] := aCalPrePnt( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr2" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, dbfArticulo ),;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "lBnf2" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "Benef2" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     dbfIva )[1]

   aTmp[ ( dbfArticulo )->( fieldpos( "pVtaIva2") ) ] := aCalPrePnt( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr2" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, dbfArticulo ),;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "lBnf2" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "Benef2" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     dbfIva )[2]

   aTmp[ ( dbfArticulo )->( fieldpos( "pVenta3" ) ) ] := aCalPrePnt( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr3" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, dbfArticulo ),;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "lBnf3" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "Benef3" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     dbfIva )[1]

   aTmp[ ( dbfArticulo )->( fieldpos( "pVtaIva3") ) ] := aCalPrePnt( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr3" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, dbfArticulo ),;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "lBnf3" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "Benef3" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     dbfIva )[2]

   aTmp[ ( dbfArticulo )->( fieldpos( "pVenta4" ) ) ] := aCalPrePnt( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr4" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, dbfArticulo ),;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "lBnf4" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "Benef4" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     dbfIva )[1]

   aTmp[ ( dbfArticulo )->( fieldpos( "pVtaIva4") ) ] := aCalPrePnt( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr4" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, dbfArticulo ),;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "lBnf4" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "Benef4" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     dbfIva )[2]

   aTmp[ ( dbfArticulo )->( fieldpos( "pVenta5" ) ) ] := aCalPrePnt( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr5" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, dbfArticulo ),;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "lBnf5" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "Benef5" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     dbfIva )[1]

   aTmp[ ( dbfArticulo )->( fieldpos( "pVtaIva5") ) ] := aCalPrePnt( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr5" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, dbfArticulo ),;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "lBnf5" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "Benef5" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     dbfIva )[2]

   aTmp[ ( dbfArticulo )->( fieldpos( "pVenta6" ) ) ] := aCalPrePnt( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr6" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, dbfArticulo ),;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "lBnf6" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "Benef6" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     dbfIva )[1]

   aTmp[ ( dbfArticulo )->( fieldpos( "pVtaIva6") ) ] := aCalPrePnt( aTmp[ ( dbfArticulo )->( fieldpos( "nBnfSbr6" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, dbfArticulo ),;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "lBnf6" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "Benef6" ) ) ],;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( dbfArticulo )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     dbfIva )[2]

   if !Empty( aTmp[ ( dbfArticulo )->( fieldpos( "cPrvHab" ) ) ] )

      ( dbfArtPrv )->( dbAppend() )
      ( dbfArtPrv )->cCodArt        := cCod
      ( dbfArtPrv )->cCodPrv        := aTmp[ ( dbfArticulo )->( fieldpos( "cPrvHab" ) ) ]
      ( dbfArtPrv )->cRefPrv        := oSay[3]:varGet()
      ( dbfArtPrv )->lDefPrv        := .t.
      ( dbfArtPrv )->( dbUnlock() )

   end if

   //guarda el artículo

   WinGather( aTmp, aGet, dbfArticulo, nil, nMode )

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

Static Function EndDetalle( aTmp, aGet, dbfTmpPrv, oBrw, nMode, oDlg, lOldPrvDef, aTmpArt, lOldRefPrv )

   if Empty( aTmp[ ( dbfTmpPrv )->( fieldPos( "CCODPRV" ) ) ] )
      msgStop( "El código de proveedor no puede estar vacío" )
      return nil
   end if

   if lExixteDetalle( aTmp, dbfTmpPrv, lOldRefPrv )
      msgStop( "La referencia de proveedor ya existe" )
      aGet[ ( dbfTmpPrv )->( fieldPos( "CREFPRV" ) ) ]:SetFocus()
      return nil
   end if

   /*
   Cambiamos el proveedor por defecto para controlar cuando cancela
   */

   if lOldPrvDef != aTmp[ ( dbfTmpPrv )->( FieldPos( "lDefPrv" ) ) ]
      lSelPrvDef( aTmp, dbfTmpPrv, oBrw, aTmpArt )
   end if

   WinGather( aTmp, aGet, dbfTmpPrv, oBrw, nMode )

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

Static Function lExixteDetalle( aTmp, dbfTmpPrv, lOldRefPrv )

   local nRecno   := ( dbfTmpPrv )->( RecNo() )
   local nOrdTmp  := ( dbfTmpPrv )->( ordSetFocus( "CREFPRV" ) )
   local lExiste  := .f.

   if lOldRefPrv != aTmp[ ( dbfTmpPrv )->( fieldPos( "CREFPRV" ) ) ]

      ( dbfTmpPrv )->( dbGoTop() )

      if !( dbfTmpPrv )->( dbSeek( aTmp[ ( dbfTmpPrv )->( fieldPos( "CCODPRV" ) ) ] + aTmp[ ( dbfTmpPrv )->( fieldPos( "CREFPRV" ) ) ] ) )
         lExiste := .f.
      else
         lExiste := .t.
      end if

   end if

   ( dbfTmpPrv )->( ordSetFocus( nOrdTmp ) )
   ( dbfTmpPrv )->( dbGoto( nRecno ) )

Return ( lExiste )

//---------------------------------------------------------------------------//

CLASS TArticuloSenderReciver FROM TSenderReciverItem

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

   Method CleanRelation( cCodArt )

END CLASS

//----------------------------------------------------------------------------//

Method CreateData()

   local oBlock
   local oError
   local tmpKit
   local tmpOfe
   local tmpImg
   local tmpArtVta
   local tmpArtPrv
   local tmpArticulo
   local tmpCodebar
   local lSnd        := .f.
   local cFileName

   if ::oSender:lServer
      cFileName      := "Art" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "Art" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   If !OpenFiles( .f. )
      Return Nil
   End If

   ::oSender:SetText( 'Seleccionando artículos' )

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   mkArticulo( cPatSnd() )
   mkOferta(   cPatSnd() )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatSnd() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @tmpArticulo ) )
   SET ADSINDEX TO ( cPatSnd() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatSnd() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @tmpArtPrv ) )
   SET ADSINDEX TO ( cPatSnd() + "PROVART.CDX" ) ADDITIVE

   USE ( cPatSnd() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @tmpArtVta ) )
   SET ADSINDEX TO ( cPatSnd() + "ARTDIV.CDX" ) ADDITIVE

   USE ( cPatSnd() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @tmpKit ) )
   SET ADSINDEX TO ( cPatSnd() + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "ArtImg.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ArtImg", @tmpImg ) )
   SET ADSINDEX TO ( cPatSnd() + "ArtImg.Cdx" ) ADDITIVE

   USE ( cPatSnd() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @tmpOfe ) )
   SET ADSINDEX TO ( cPatSnd() + "OFERTA.CDX" ) ADDITIVE

   USE ( cPatSnd() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @tmpCodebar ) )
   SET ADSINDEX TO ( cPatSnd() + "ArtCodebar.Cdx" ) ADDITIVE

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfArticulo )->( lastrec() )
   end if

   ( dbfArticulo )->( OrdSetFocus( "SndCod" ) )
   ( dbfArticulo )->( dbGoTop() )

   while !( dbfArticulo )->( eof() )

      if ( dbfArticulo )->lSndDoc

         ::oSender:SetText( AllTrim( ( dbfArticulo )->Codigo ) + "; " + AllTrim( ( dbfArticulo )->Nombre ) + "; " + AllTrim( Trans( ( dbfArticulo )->pVenta1, PicOut() ) ) + "; " + AllTrim( Trans( ( dbfArticulo )->pVtaIva1, PicOut() ) ) )

         lSnd     := .t.

         dbPass( dbfArticulo, tmpArticulo, .t. )

         /*
         referencias de proveedores
         */

         if ( dbfCodebar )->( dbSeek( ( dbfArticulo )->Codigo ) )

            while ( dbfCodebar )->cCodArt == ( dbfArticulo )->Codigo .and. !( dbfCodebar )->( eof() )

               dbPass( dbfCodebar, tmpCodebar, .t. )
               ( dbfCodebar )->( dbSkip( 1 ) )

            end while

         end if

         /*
         referencias de proveedores
         */

         if ( dbfArtPrv )->( dbSeek( ( dbfArticulo )->Codigo ) )

            while ( dbfArtPrv )->cCodArt == ( dbfArticulo )->Codigo .and. !( dbfArtPrv )->( eof() )

               dbPass( dbfArtPrv, tmpArtPrv, .t. )
               ( dbfArtPrv )->( dbSkip( 1 ) )

            end while

         end if

         /*
         precios en distintas divisas
         */

         if ( dbfArtVta )->( dbSeek( ( dbfArticulo )->CODIGO ) )

            while ( dbfArtVta )->cCodArt == ( dbfArticulo )->Codigo .AND. !( dbfArtVta )->( eof() )

               dbPass( dbfArtVta, tmpArtVta, .t. )
               ( dbfArtVta )->( dbSkip( 1 ) )

            end while

         end if

         /*
         kits asociados
         */

         if ( dbfArtKit )->( dbSeek( ( dbfArticulo )->CODIGO ) )

            while ( dbfArtKit )->cCodKit == ( dbfArticulo )->Codigo .AND. !( dbfArtKit )->( eof() )

               dbPass( dbfArtKit, tmpKit, .t. )
               ( dbfArtKit )->( dbSkip( 1 ) )

            end while

         end if

         /*
         Ofertas de articulos
         */

         if ( dbfOfe )->( dbSeek( ( dbfArticulo )->Codigo ) )

            while ( dbfOfe )->cArtOfe == ( dbfArticulo )->Codigo .AND. !( dbfOfe )->( eof() )

               dbPass( dbfOfe, tmpOfe, .t. )
               ( dbfOfe )->( dbSkip( 1 ) )

            end while

         end if

         /*
         Imagenes de articulos
         */

         if ( dbfImg )->( dbSeek( ( dbfArticulo )->Codigo ) )
            while ( dbfImg )->cCodArt == ( dbfArticulo )->Codigo .AND. !( dbfImg )->( eof() )
               dbPass( dbfImg, tmpImg, .t. )
               ( dbfImg )->( dbSkip( 1 ) )
            end while
         end if

      end if

      ( dbfArticulo )->( dbSkip() )

      if !Empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( dbfArticulo )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( tmpArticulo )
   CLOSE ( tmpArtPrv   )
   CLOSE ( tmpArtVta   )
   CLOSE ( tmpKit      )
   CLOSE ( tmpOfe      )
   CLOSE ( tmpImg      )
   CLOSE ( tmpCodebar  )

   CloseFiles()

   /*
   Comprimir los archivos------------------------------------------------------
   */

   if lSnd

      ::oSender:SetText( "Comprimiendo artículos" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay artículos para enviar" )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method RestoreData()

   local oBlock
   local oError
   local dbfArticulo

   if ::lSuccesfullSend

      /*
      Sintuacion despues del envio---------------------------------------------
      */

      oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         USE ( cPatArt() + "Articulo.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
         SET ADSINDEX TO ( cPatArt() + "Articulo.Cdx" ) ADDITIVE
         ( dbfArticulo )->( ordSetFocus( "SndCod" ) )

         while !( dbfArticulo )->( Eof() )

            if ( dbfArticulo )->( dbRLock() )
               ( dbfArticulo )->lSndDoc   := .f.
               ( dbfArticulo )->( dbRUnlock() )
            end if

            ( dbfArticulo )->( dbSkip() )

         end while

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

      CLOSE ( dbfArticulo )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method SendData()

   local cFileName

   if ::oSender:lServer
      cFileName         := "Art" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName         := "Art" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   if File( cPatOut() + cFileName )

      if ftpSndFile( cPatOut() + cFileName, cFileName, 2000, ::oSender )
         ::IncNumberToSend()
         ::lSuccesfullSend := .t.
         ::oSender:SetText( "Ficheros de artículos enviados " + cFileName )
      else
         ::oSender:SetText( "ERROR fichero de artículos no enviado" )
      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method ReciveData()

   local n
   local aExt

   if ::oSender:lServer
      aExt              := aRetDlgEmp()
   else
      aExt              := { "All" }
   end if

   ::oSender:SetText( "Recibiendo artículos" )

   for n := 1 to len( aExt )
      FtpGetFiles( "Art*." + aExt[ n ], cPatIn(), 2000, ::oSender )
   next

   ::oSender:SetText( "Artículos recibidos" )

Return ( Self )

//---------------------------------------------------------------------------//

Method Process()

   local m
   local aFiles
   local tmpMov
   local tmpKit
   local tmpOfe
   local tmpCodebar
   local tmpArtPrv
   local tmpArtDiv
   local tmpArticulo
   local oBlock
   local oError

   /*
   Procesamos los ficheros recibidos-------------------------------------------
   */

   aFiles                     := Directory( cPatIn() + "Art*.*" )

   for m := 1 to len( aFiles )

      oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE

      /*
      Descomprimimos el fichero recibido------------------------------------
      */

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         if lExistTable( cPatSnd() + "Articulo.Dbf" )     .and.;
            lExistTable( cPatSnd() + "ProvArt.Dbf"  )     .and.;
            lExistTable( cPatSnd() + "ArtDiv.Dbf"   )     .and.;
            lExistTable( cPatSnd() + "ArtKit.Dbf"   )     .and.;
            lExistTable( cPatSnd() + "Oferta.Dbf"   )     .and.;
            lExistTable( cPatSnd() + "ArtCodebar.Dbf" )   .and.;
            OpenFiles( .f. )

            USE ( cPatSnd() + "ARTICULO.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "ARTICULO", @tmpArticulo ) )
            SET ADSINDEX TO ( cPatSnd() + "ARTICULO.CDX" ) ADDITIVE

            USE ( cPatSnd() + "PROVART.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "PROVART", @tmpArtPrv ) )
            SET ADSINDEX TO ( cPatSnd() + "PROVART.CDX" ) ADDITIVE

            USE ( cPatSnd() + "ARTDIV.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "ARTDIV", @tmpArtDiv ) )
            SET ADSINDEX TO ( cPatSnd() + "ARTDIV.CDX" ) ADDITIVE

            USE ( cPatSnd() + "ARTKIT.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "ARTTIK", @tmpKit ) )
            SET ADSINDEX TO ( cPatSnd() + "ARTKIT.CDX" ) ADDITIVE

            USE ( cPatSnd() + "OFERTA.DBF" ) NEW VIA ( cDriver() )READONLY ALIAS ( cCheckArea( "OFERTA", @tmpOfe ) )
            SET ADSINDEX TO ( cPatSnd() + "OFERTA.CDX" ) ADDITIVE

            USE ( cPatSnd() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @tmpCodebar ) )
            SET ADSINDEX TO ( cPatSnd() + "ArtCodebar.Cdx" ) ADDITIVE

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpArticulo )->( lastrec() )
            end if

            while !( tmpArticulo )->( eof() )

               if ( dbfArticulo )->( dbSeek( ( tmpArticulo )->Codigo ) )
                  if !::oSender:lServer
                     ::CleanRelation( ( tmpArticulo )->Codigo )
                     dbPass( tmpArticulo, dbfArticulo )
                     ::oSender:SetText( "Reemplazado : " + AllTrim( ( dbfArticulo )->Codigo ) + "; " + AllTrim( ( dbfArticulo )->Nombre ) + "; " + AllTrim( Trans( ( dbfArticulo )->pVenta1, PicOut() ) ) + "; " + AllTrim( Trans( ( dbfArticulo )->pVtaIva1, PicOut() ) ) )
                  else
                     ::oSender:SetText( "Desestimado : " + AllTrim( ( dbfArticulo )->Codigo ) + "; " + AllTrim( ( dbfArticulo )->Nombre ) + "; " + AllTrim( Trans( ( dbfArticulo )->pVenta1, PicOut() ) ) + "; " + AllTrim( Trans( ( dbfArticulo )->pVtaIva1, PicOut() ) ) )
                  end if
               else
                     ::CleanRelation( ( tmpArticulo )->Codigo )
                     dbPass( tmpArticulo, dbfArticulo, .t. )
                     ::oSender:SetText( "Añadido     : " + AllTrim( ( dbfArticulo )->Codigo ) + "; " + AllTrim( ( dbfArticulo )->Nombre ) + "; " + AllTrim( Trans( ( dbfArticulo )->pVenta1, PicOut() ) ) + "; " + AllTrim( Trans( ( dbfArticulo )->pVtaIva1, PicOut() ) ) )
               end if

               ( tmpArticulo )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpArticulo )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpArtPrv )->( LastRec() )
            end if

            while !( tmpArtPrv )->( eof() )

               if ( dbfArtPrv )->( dbSeek( ( tmpArtPrv )->cCodArt ) )
                  if !::oSender:lServer
                     dbPass( tmpArtPrv, dbfArtPrv )
                  end if
               else
                  dbPass( tmpArtPrv, dbfArtPrv, .t. )
               end if

               ( tmpArtPrv )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( (tmpArtPrv)->( recno() ) )
               end if

               SysRefresh()

            end while

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpArtDiv )->( lastrec() )
            end if

            while !( tmpArtDiv )->( eof() )

               if ( dbfArtVta )->( dbSeek( ( tmpArtDiv )->CCODART ) )
                  if !::oSender:lServer
                     dbPass( tmpArtDiv, dbfArtVta )
                  end if
               else
                  dbPass( tmpArtDiv, dbfArtVta, .t. )
               end if

               ( tmpArtDiv )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpArtDiv )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:Set( ( tmpArtDiv )->( lastrec() ) )
            end if

            /*
            Kits Asociados
            */

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := (tmpKit)->( lastrec() )
            end if

            while !( tmpKit )->( eof() )

               if ( dbfArtKit )->( dbSeek( ( tmpKit )->CCODKIT ) )
                  if !::oSender:lServer
                     dbPass( tmpKit, dbfArtKit )
                  end if
               else
                  dbPass( tmpKit, dbfArtKit, .t. )
               end if

               ( tmpKit )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpKit )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            /*
            ofertas de articulos
            */

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpOfe )->( lastrec() )
            end if

            while !( tmpOfe )->( eof() )

               if ( dbfOfe )->( dbSeek( ( tmpOfe )->cArtOfe ) )
                  if !::oSender:lServer
                     dbPass( tmpOfe, dbfOfe )
                  end if
               else
                  dbPass( tmpOfe, dbfOfe, .t. )
               end if

               ( tmpOfe )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpOfe )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:Set( ( tmpOfe )->( lastrec() ) )
            end if

            /*
            Codigos de barras-----------------------------------------------
            */

            ( dbfCodebar )->( OrdSetFocus( "cArtBar" ) )

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpCodebar )->( lastrec() )
            end if

            while !( tmpCodebar )->( eof() )

               if ( dbfCodebar )->( dbSeek( ( tmpCodebar )->cCodArt + ( tmpCodebar )->cCodBar ) ) .and. !::oSender:lServer
                  dbPass( tmpCodebar, dbfCodebar )
               else
                  dbPass( tmpCodebar, dbfCodebar, .t. )
               end if

               ( tmpCodebar )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpCodebar )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            ( dbfCodebar )->( OrdSetFocus( "cCodArt" ) )

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:Set( ( tmpCodebar )->( lastrec() ) )
            end if

            CLOSE ( tmpArticulo )
            CLOSE ( tmpCodebar  )
            CLOSE ( tmpArtPrv   )
            CLOSE ( tmpMov      )
            CLOSE ( tmpArtDiv   )
            CLOSE ( tmpKit      )
            CLOSE ( tmpOfe      )

            CloseFiles()

            ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

         else

            ::oSender:SetText( "Faltan ficheros" )

            if !lExistTable( cPatSnd() + "Articulo.Dbf"   )
               ::oSender:SetText( "Falta" + cPatSnd() + "Articulo.Dbf" )
            end if

            if !lExistTable( cPatSnd() + "ProvArt.Dbf"    )
               ::oSender:SetText( "Falta" + cPatSnd() + "ProvArt.Dbf" )
            end if

            if !lExistTable( cPatSnd() + "ArtDiv.Dbf"     )
               ::oSender:SetText( "Falta" + cPatSnd() + "ArtDiv.Dbf" )
            end if

            if !lExistTable( cPatSnd() + "ArtKit.Dbf"     )
               ::oSender:SetText( "Falta" + cPatSnd() + "ArtKit.Dbf" )
            end if

            if !lExistTable( cPatSnd() + "Oferta.Dbf"     )
               ::oSender:SetText( "Falta" + cPatSnd() + "Oferta.Dbf" )
            end if

            if !lExistTable( cPatSnd() + "ArtCodebar.Dbf" )
               ::oSender:SetText( "Falta" + cPatSnd() + "ArtCodebar.Dbf" )
            end if

         end if

      else

         ::oSender:SetText( "Error en el fichero comprimido" )

      end if

      RECOVER USING oError

         CLOSE ( tmpArticulo )
         CLOSE ( tmpCodebar  )
         CLOSE ( tmpArtPrv   )
         CLOSE ( tmpMov      )
         CLOSE ( tmpArtDiv   )
         CLOSE ( tmpKit      )
         CLOSE ( tmpOfe      )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return ( Self )

//---------------------------------------------------------------------------//

Method CleanRelation( cCodArt )

   while ( dbfArtPrv )->( dbSeek( cCodArt ) )
      dbDel( dbfArtPrv )
   end while

   SysRefresh()

   while ( dbfArtVta )->( dbSeek( cCodArt ) )
      dbDel( dbfArtVta )
   end while

   SysRefresh()

   while ( dbfArtKit )->( dbSeek( cCodArt ) )
      dbDel( dbfArtKit )
   end while

   SysRefresh()

   while ( dbfOfe )->( dbSeek( cCodArt ) )
      dbDel( dbfOfe )
   end while

   SysRefresh()

   while ( dbfCodeBar )->( dbSeek( cCodArt ) )
      dbDel( dbfCodeBar )
   end while

   SysRefresh()

Return ( Self )

//---------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, aGet, oSay, oDlg, oFld, aBar, cSay, nMode )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM "&1. Informe del artículo";
            MESSAGE  "Muestra el informe del artículo" ;
            RESOURCE "info16" ;
            ACTION   ( BrwVtaComArt( ( dbfArticulo )->Codigo, ( dbfArticulo )->Nombre, dbfDiv, dbfIva, dbfAlmT, dbfArticulo ) )

            MENUITEM "&2. Informe de artículo en escandallo";
            MESSAGE  "Muestra el informe del artículo en escandallo" ;
            RESOURCE "info16" ;
            ACTION   ( BrwVtaComArt( ( dbfTmpKit )->cRefKit, ( dbfTmpKit )->cDesKit, dbfDiv, dbfIva, dbfAlmT, dbfArticulo ) )

            if !lExternal

            SEPARATOR

            MENUITEM "&3. Añadir pedido a proveedor";
            MESSAGE  "Añade un pedido a proveedor" ;
            RESOURCE "Clipboard_empty_businessman_16";
            ACTION   ( if( !Empty( EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode ) ), PedPrv( nil, nil, nil, ( dbfArticulo )->Codigo ), ) )

            MENUITEM "&4. Añadir albarán de proveedor";
            MESSAGE  "Añade un albarán de proveedor" ;
            RESOURCE "Document_plain_businessman_16";
            ACTION   ( if( !Empty( EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode ) ), AlbPrv( nil , nil, nil, ( dbfArticulo )->Codigo ), ) )

            MENUITEM "&5. Añadir factura de proveedor";
            MESSAGE  "Añade una factura de proveedor" ;
            RESOURCE "Document_businessman_16";
            ACTION   ( if( !Empty( EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode ) ), FacPrv( nil, nil, nil, ( dbfArticulo )->Codigo ), ) )

            MENUITEM "&6. Añadir presupuesto de cliente";
            MESSAGE  "Añade un presupuesto de cliente" ;
            RESOURCE "Notebook_user1_16";
            ACTION   ( if( !Empty( EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode ) ), PreCli( nil, nil, nil, ( dbfArticulo )->Codigo ), ) )

            MENUITEM "&7. Añadir pedido de cliente";
            MESSAGE  "Añade un pedido de cliente" ;
            RESOURCE "Clipboard_empty_user1_16";
            ACTION   ( if( !Empty( EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode ) ), PedCli( nil, nil, nil, ( dbfArticulo )->Codigo ), ) )

            MENUITEM "&8. Añadir albarán de cliente";
            MESSAGE  "Añade un albarán de cliente" ;
            RESOURCE "Document_plain_user1_16";
            ACTION   ( if( !Empty( EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode ) ), AlbCli( nil, nil, { "Artículo" => ( dbfArticulo )->Codigo } ), ) )

            MENUITEM "&9. Añadir factura de cliente";
            MESSAGE  "Añade una factura de cliente" ;
            RESOURCE "Document_user1_16";
            ACTION   ( if( !Empty( EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode ) ), FactCli( nil, nil, { "Artículo" => ( dbfArticulo )->Codigo } ), ) )

            MENUITEM "&A. Añadir tiket de cliente";
            MESSAGE  "Añade un tiket de cliente" ;
            RESOURCE "Cashier_user1_16";
            ACTION   ( if( !Empty( EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode ) ), FrontTpv( nil, nil, nil, ( dbfArticulo )->Codigo ), ) )

            end if

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

   if !Empty( oActiveX )
      oActiveX:DocumentHTML      := aTmp[ ( dbfArticulo )->( fieldpos( "MDESTEC" ) ) ]
      oActivex:LocalizationFile  := FullCurDir() + "Spanish.xml"
      oActivex:BorderStyle       := 0
   end if

Return ( oMenu )

//---------------------------------------------------------------------------//
/*
Cambia el proveedor por defecto y lo refleja en la tabla de artículo (CPRVHAB)
*/

Static Function lSelPrvDef( aTmp, dbfTmpPrv, oBrw, aTmpArt )

   local nRec                 := ( dbfTmpPrv )->( RecNo() )

   ( dbfTmpPrv )->( dbGoTop() )

   while !( dbfTmpPrv )->( eof() )
      ( dbfTmpPrv )->lDefPrv  := .f.
      ( dbfTmpPrv )->( dbSkip() )
   end while

   ( dbfTmpPrv )->( dbGoto( nRec ) )

   aTmpArt[ ( dbfArticulo )->( fieldPos( "CPRVHAB" ) ) ]  := aTmp[ ( dbfTmpPrv )->( fieldPos( "CCODPRV" ) ) ]

   oBrw:Refresh()

Return .t.

//---------------------------------------------------------------------------//
/*Funcion de borrado proveedores*/

Static Function DelPrv( aTmp, oBrwPrv, dbfTmpPrv )

   /*Si no es el de por defecto lo borramos sin mas*/

   if !( dbfTmpPrv )->lDefPrv

      dbDelRec( oBrwPrv, dbfTmpPrv )

   else

      if dbDelRec( oBrwPrv, dbfTmpPrv )

         /*Si mandamos borrar el de por defecto, pondremos el primero de la lista
         en defecto y cambiamos la tabla de clientes*/

         ( dbfTmpPrv )->( dbGoTop() )

         if !( dbfTmpPrv )->( Eof() )

            ( dbfTmpPrv )->lDefPrv  := .t.

            aTmp[ ( dbfArticulo )->( fieldpos( "cPrvHab" ) ) ]       := ( dbfTmpPrv )->cCodPrv

         else

            aTmp[ ( dbfArticulo )->( fieldpos( "cPrvHab" ) ) ]       := Space( 12 )

         end if

      end if

   end if

   oBrwPrv:Refresh()

Return ( .t. )

//---------------------------------------------------------------------------//

Function lEscandallo( uTmpArticulo )

   if Valtype( uTmpArticulo ) == "C"
      Return ( ( uTmpArticulo )->lKitArt .and. !( uTmpArticulo )->lKitAsc )
   else
      Return ( uTmpArticulo[ ( dbfArticulo )->( Fieldpos( "lKitArt" ) ) ] .and. !uTmpArticulo[ ( dbfArticulo )->( Fieldpos( "lKitAsc" ) ) ] )
   end if

Return ( .f. )

//---------------------------------------------------------------------------//

Static Function lValidUndMedicion( aTmp, aGet )

   //si el campo unidad de medición esta vacio oculto las tres dimensiones

   if Empty( aTmp[ ( dbfArticulo )->( fieldpos( "CUNIDAD" ) ) ] )

      aGet[ ( dbfArticulo )->( fieldpos( "NLNGART" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "NALTART" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "NANCART" ) ) ]:Hide()

   end if

   if oUndMedicion:oDbf:SeekInOrd( aTmp[ ( dbfArticulo )->( fieldpos( "CUNIDAD" ) ) ], "CCODMED" )

      aGet[ ( dbfArticulo )->( fieldpos( "CUNIDAD" ) ) ]:oHelpText:cText( oUndMedicion:oDbf:cNombre )

      //por defecto ocultamos las tres descripciones

      aGet[ ( dbfArticulo )->( fieldpos( "NLNGART" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "NALTART" ) ) ]:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "NANCART" ) ) ]:Hide()

      //si nDimension es igual a 1 muestra la primera descrpción

      if oUndMedicion:oDbf:nDimension >= 1

         aGet[ ( dbfArticulo )->( fieldpos( "NLNGART" ) ) ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "NLNGART" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )

      end if

      //si nDimension es igual a 2 muestra las dos primeras descripciones

      if oUndMedicion:oDbf:nDimension >= 2

         aGet[ ( dbfArticulo )->( fieldpos( "NALTART" ) ) ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "NALTART" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )

      end if

      //si nDimension es igual a 3 muestra las tres descripciones

      if oUndMedicion:oDbf:nDimension >= 3

         aGet[ ( dbfArticulo )->( fieldpos( "NANCART" ) ) ]:Show()
         aGet[ ( dbfArticulo )->( fieldpos( "NANCART" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function CargaProveedor( oGet, oSay, oValorPunto, dbfPrv )

   local lCarga   := .t.

   if cProvee( oGet, dbfProv, oSay[ 4 ] )
      oValorPunto:cText( ( dbfPrv )->nValPunt )
   else
      lCarga      := .f.
   end if

Return ( lCarga )

//---------------------------------------------------------------------------//

Function ExpFamilia( cCodFam, oSayFamilia, aGet )

   if Empty( cCodFam )
      Return .t.
   end if

   if dbSeekInOrd( cCodFam, "cCodFam", dbfFam )

      oSayFamilia:cText( ( dbfFam )->cNomFam )

      if cCodFam != cCodigoFamilia

         if ( !Empty( ( dbfFam )->cCodPrp1 ) .and. aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ]:VarGet() != ( dbfFam )->cCodPrp1 ) .or.;
            ( !Empty( ( dbfFam )->cCodPrp2 ) .and. aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ]:VarGet() != ( dbfFam )->cCodPrp2 ) .or.;
            ( !Empty( ( dbfFam )->cCodFra  ) .and. aGet[ ( dbfArticulo )->( fieldpos( "cCodFra"  ) ) ]:VarGet() != ( dbfFam )->cCodFra  )

            if ApoloMsgNoYes( "¿ Desea importar las propiedades y frases publicitarias de la familia ?" )

               aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ]:cText( ( dbfFam )->cCodPrp1 )
               aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ]:lValid()

               aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ]:cText( ( dbfFam )->cCodPrp2 )
               aGet[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ]:lValid()

               aGet[ ( dbfArticulo )->( fieldpos( "cCodFra" ) ) ]:cText( ( dbfFam )->cCodFra )
               aGet[ ( dbfArticulo )->( fieldpos( "cCodFra" ) ) ]:lValid()

            end if

         end if

      else

         cCodigoFamilia := cCodFam

      end if

   else

      msgStop( "Familia no encontrada" )

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TArticuloLabelGenerator

   Data oDlg
   Data oFld

   Data oCriterio
   Data cCriterio
   Data aCriterio

   Data oFamiliaInicio
   Data cFamiliaInicio

   Data oFamiliaFin
   Data cFamiliaFin

   Data oFechaInicio
   Data dFechaInicio

   Data oFechaFin
   Data dFechaFin

   Data oInicio
   Data oFin

   Data oFormatoLabel
   Data cFormatoLabel

   Data nFilaInicio
   Data nColumnaInicio

   Data cFileTmpLabel
   Data cAreaTmpLabel

   Data oBrwLabel

   Data nCantidadLabels
   Data nUnidadesLabels

   Data oMtrLabel
   Data nMtrLabel

   Data oFilter

   Data hBmp

   Data oBtnListado
   Data oBtnFilter
   Data oBtnSiguiente
   Data oBtnAnterior
   Data oBtnCancel

   Data aSearch

   Method Create()
   Method End()

   Method lDefault()

   Method BotonAnterior()

   Method BotonSiguiente()

   Method PutLabel()

   Method SelectAllLabels()

   Method SelectPropertiesLabels()

   Method SavePropertiesLabels()

   Method LoadPropertiesLabels()

   Method SelectCriterioLabels()

   Method PutStockLabels()

   Method AddLabel()

   Method DelLabel()

   Method EditLabel()

   Method ChangeCriterio()

   Method lPrintLabels()

   Method InitLabel( oLabel )

   Method lCreateTemporal()

   Method PrepareTemporal()

   Method DestroyTemporal()

   Method SelectColumn( oCombo )

END CLASS

//----------------------------------------------------------------------------//

Method lDefault() CLASS TArticuloLabelGenerator

   local oError
   local oBlock
   local lError         := .f.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::cCriterio          := "Ningún criterio"
   ::aCriterio          := { "Ningún criterio", "Todos los registros", "Familia", "Fecha modificación" }

   ::cFamiliaInicio    := ( dbfArticulo )->Familia
   ::cFamiliaFin       := ( dbfArticulo )->Familia

   ::dFechaInicio       := Ctod( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ), 4 ) )
   ::dFechaFin          := GetSysDate()

   ::cFormatoLabel      := GetPvProfString( "Etiquetas", "Articulo", Space( 3 ), cPatEmp() + "Empresa.Ini" )
   if len( ::cFormatoLabel ) < 3
      ::cFormatoLabel   := Space( 3 )
   end if

   ::nMtrLabel          := 0

   ::nFilaInicio        := 1
   ::nColumnaInicio     := 1

   ::nCantidadLabels    := 1
   ::nUnidadesLabels    := 1

   ::aSearch            := { "Código", "Nombre" }

   RECOVER USING oError

      lError            := .t.

      msgStop( "Error en la creación de generador de etiquetas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

Return ( !lError )

//--------------------------------------------------------------------------//

Method Create() CLASS TArticuloLabelGenerator

   local oGetOrd
   local cGetOrd     := Space( 100 )
	local oCbxOrd
   local cCbxOrd     := "Código"
   local aCbxOrd     := { "Código", "Nombre" }

   if ::lDefault()

      DEFINE DIALOG ::oDlg RESOURCE "SelectLabels_0"

         REDEFINE PAGES ::oFld ;
            ID       10;
            OF       ::oDlg ;
            DIALOGS  "SelectLabels_3",;
                     "SelectLabels_2"

         /*
         Bitmap-------------------------------------------------------------------
         */

         REDEFINE BITMAP ;
            RESOURCE "EnvioEtiquetas" ;
            ID       500 ;
            OF       ::oDlg ;

         REDEFINE COMBOBOX ::oCriterio VAR ::cCriterio ;
            ITEMS    ::aCriterio ;
            ID       90 ;
            OF       ::fldGeneral

         ::oCriterio:bChange        := {|| ::ChangeCriterio() }

         REDEFINE GET ::oFamiliaInicio VAR ::cFamiliaInicio ;
            ID       100 ;
            IDTEXT   101 ;
            BITMAP   "LUPA" ;
            OF       ::fldGeneral

         ::oFamiliaInicio:bValid    := {|| cFamilia( ::oFamiliaInicio, dbfFam, ::oFamiliaInicio:oHelpText ), .t. }
         ::oFamiliaInicio:bHelp     := {|| BrwFamilia( ::oFamiliaInicio, ::oFamiliaInicio:oHelpText ) }

         REDEFINE SAY ::oInicio ;
            ID       102 ;
            OF       ::fldGeneral

         REDEFINE GET ::oFamiliaFin VAR ::cFamiliaFin ;
            ID       110 ;
            IDTEXT   111 ;
            BITMAP   "LUPA" ;
            OF       ::fldGeneral

         ::oFamiliaFin:bValid       := {|| cFamilia( ::oFamiliaFin, dbfFam, ::oFamiliaFin:oHelpText ), .t. }
         ::oFamiliaFin:bHelp        := {|| BrwFamilia( ::oFamiliaFin, ::oFamiliaFin:oHelpText ) }

         REDEFINE SAY ::oFin ;
            ID       112 ;
            OF       ::fldGeneral

         REDEFINE GET ::oFechaInicio VAR ::dFechaInicio ;
            SPINNER ;
            ID       120 ;
            OF       ::fldGeneral

         REDEFINE GET ::oFechaFin VAR ::dFechaFin ;
            SPINNER ;
            ID       130 ;
            OF       ::fldGeneral

         REDEFINE GET ::oFormatoLabel VAR ::cFormatoLabel ;
            ID       160 ;
            IDTEXT   161 ;
            BITMAP   "LUPA" ;
            OF       ::fldGeneral

            ::oFormatoLabel:bValid  := {|| cDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, dbfDoc, "AR" ) }
            ::oFormatoLabel:bHelp   := {|| BrwDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, "AR" ) }

         TBtnBmp():ReDefine( 220, "Printer_pencil_16",,,,,{|| EdtDocumento( ::cFormatoLabel ) }, ::fldGeneral, .f., , .f., "Modificar formato de etiquetas" )

         REDEFINE GET ::nFilaInicio ;
            ID       180 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::fldGeneral

         REDEFINE GET ::nColumnaInicio ;
            ID       190 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::fldGeneral

         REDEFINE RADIO ::nCantidadLabels ;
            ID       200, 201 ;
            OF       ::fldGeneral

         REDEFINE GET ::nUnidadesLabels ;
            ID       210 ;
            PICTURE  "99999" ;
            SPINNER ;
            MIN      1 ;
            MAX      99999 ;
            WHEN     ( ::nCantidadLabels == 1 ) ;
            OF       ::fldGeneral

         /*
         Segunda caja de dialogo--------------------------------------------------
         */

         REDEFINE GET oGetOrd ;
            VAR      cGetOrd;
            ID       200 ;
            BITMAP   "FIND" ;
            OF       ::fldPrecios

         oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwLabel, dbfArticulo ) }
         oGetOrd:bValid    := {|| ( dbfArticulo )->( OrdScope( 0, nil ) ), ( dbfArticulo )->( OrdScope( 1, nil ) ), ::oBrwLabel:Refresh(), .t. }

         REDEFINE COMBOBOX oCbxOrd ;
            VAR      cCbxOrd ;
            ID       210 ;
            ITEMS    aCbxOrd ;
            OF       ::fldPrecios

         oCbxOrd:bChange   := {|| ::SelectColumn( oCbxOrd ) }

         REDEFINE BUTTON ;
            ID       100 ;
            OF       ::fldPrecios ;
            ACTION   ( ::PutLabel() )

         REDEFINE BUTTON ;
            ID       110 ;
            OF       ::fldPrecios ;
            ACTION   ( ::SelectAllLabels( .t. ) )

         REDEFINE BUTTON ;
            ID       120 ;
            OF       ::fldPrecios ;
            ACTION   ( ::SelectAllLabels( .f. ) )

         REDEFINE BUTTON ;
            ID       220 ;
            OF       ::fldPrecios ;
            ACTION   ( ::SelectPropertiesLabels( .f. ) )

         REDEFINE BUTTON ;
            ID       130 ;
            OF       ::fldPrecios ;
            ACTION   ( ::AddLabel() )

         REDEFINE BUTTON ;
            ID       140 ;
            OF       ::fldPrecios ;
            ACTION   ( ::DelLabel() )

         REDEFINE BUTTON ;
            ID       150 ;
            OF       ::fldPrecios ;
            ACTION   ( ::EditLabel() )

         REDEFINE BUTTON ;
            ID       160 ;
            OF       ::fldPrecios ;
            ACTION   ( WinEdtRec( ::oBrwLabel, bEdit, dbfArticulo ) )

         REDEFINE BUTTON ;
            ID       165 ;
            OF       ::fldPrecios ;
            ACTION   ( WinZooRec( ::oBrwLabel, bEdit, dbfArticulo ) )

         ::oBrwLabel                 := IXBrowse():New( ::fldPrecios )

         ::oBrwLabel:nMarqueeStyle   := 5
         ::oBrwLabel:nColSel         := 2

         ::oBrwLabel:lHScroll        := .f.
         ::oBrwLabel:cAlias          := dbfArticulo

         ::oBrwLabel:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         ::oBrwLabel:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
         ::oBrwLabel:bLDblClick      := {|| ::PutLabel() }

         ::oBrwLabel:CreateFromResource( 180 )

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Sl. Seleccionada"
            :bEditValue       := {|| ( dbfArticulo )->lLabel }
            :nWidth           := 20
            :SetCheck( { "Sel16", "Nil16" } )
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Código"
            :bEditValue       := {|| ( dbfArticulo )->Codigo }
            :nWidth           := 80
            :cSortOrder       := "Codigo"
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Nombre"
            :bEditValue       := {|| ( dbfArticulo )->Nombre }
            :nWidth           := 280
            :cSortOrder       := "Nombre"
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "N. etiquetas"
            :bEditValue       := {|| ( dbfArticulo )->nLabel }
            :cEditPicture     := "@E 99,999"
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nEditType        := 1
            :bOnPostEdit      := {|o,x| if( dbDialogLock( dbfArticulo ), ( ( dbfArticulo )->nLabel := x, ( dbfArticulo )->( dbUnlock() ) ), ) }
         end with

         REDEFINE METER ::oMtrLabel ;
            VAR      ::nMtrLabel ;
            PROMPT   "" ;
            ID       190 ;
            OF       ::fldPrecios ;
            TOTAL    ( dbfArticulo )->( lastrec() )

         ::oMtrLabel:nClrText   := rgb( 128,255,0 )
         ::oMtrLabel:nClrBar    := rgb( 128,255,0 )
         ::oMtrLabel:nClrBText  := rgb( 128,255,0 )

         /*
         Botones generales--------------------------------------------------------
         */

         REDEFINE BUTTON ::oBtnListado ;          // Boton listado
            ID       40 ;
            OF       ::oDlg ;
            ACTION   ( TInfArtFam():New( "Listado de artículos seleccionados para etiquetas" ):Play( .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva, dbfFam, oStock, oWndBrw ) )

         REDEFINE BUTTON ::oBtnAnterior ;          // Boton anterior
            ID       20 ;
            OF       ::oDlg ;
            ACTION   ( ::BotonAnterior() )

         REDEFINE BUTTON ::oBtnSiguiente ;         // Boton de Siguiente
            ID       30 ;
            OF       ::oDlg ;
            ACTION   ( ::BotonSiguiente() )

         REDEFINE BUTTON ::oBtnCancel ;            // Boton de Siguiente
            ID       IDCANCEL ;
            OF       ::oDlg ;
            ACTION   ( ::oDlg:End() )

      ::oDlg:bStart  := {|| ::oBtnAnterior:Hide(), ::ChangeCriterio(), ::oFormatoLabel:lValid() }

      ACTIVATE DIALOG ::oDlg CENTER

      ::End()

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonAnterior() CLASS TArticuloLabelGenerator

   ::oFld:GoPrev()

   ::oBtnAnterior:Hide()

   SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonSiguiente() CLASS TArticuloLabelGenerator

   do case
      case ::oFld:nOption == 1

         if Empty( ::cFormatoLabel )

            MsgStop( "Debe cumplimentar un formato de etiquetas" )

         else

            ::oFld:GoNext()
            ::oBtnAnterior:Show()

            if ::oCriterio:nAt != 1
               ::SelectCriterioLabels()
            end if

            SetWindowText( ::oBtnSiguiente:hWnd, "&Terminar" )

         end if

      case ::oFld:nOption == 2

         if ::lPrintLabels()

            SetWindowText( ::oBtnCancel:hWnd, "&Cerrar" )

         end if

   end case

Return ( Self )

//--------------------------------------------------------------------------//

Method End() CLASS TArticuloLabelGenerator

   WritePProString( "Etiquetas", "Articulo", ::cFormatoLabel, cPatEmp() + "Empresa.Ini" )

Return ( Self )

//--------------------------------------------------------------------------//

Method PutLabel() CLASS TArticuloLabelGenerator

   if dbLock( dbfArticulo )
      ( dbfArticulo )->lLabel := !( dbfArticulo )->lLabel
      ( dbfArticulo )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectAllLabels( lSelect ) CLASS TArticuloLabelGenerator

	local n			:= 0
   local nRecno   := ( dbfArticulo )->( Recno() )

	CursorWait()

   ::oDlg:Disable()

   ( dbfArticulo )->( dbGoTop() )
   while !( dbfArticulo )->( eof() )

      if ( dbfArticulo )->lLabel != lSelect

         if dbLock( dbfArticulo )
            ( dbfArticulo )->lLabel := lSelect
            ( dbfArticulo )->( dbUnLock() )
         end if

      end if

      ( dbfArticulo )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ( dbfArticulo )->( dbGoTo( nRecno ) )

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

   ::oDlg:Enable()

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectCriterioLabels() CLASS TArticuloLabelGenerator

	local n			:= 0
   local nRecno   := ( dbfArticulo )->( Recno() )

	CursorWait()

   ( dbfArticulo )->( dbGoTop() )
   while !( dbfArticulo )->( eof() )

      if dbLock( dbfArticulo )

         do case
            case ::oCriterio:nAt == 2

               ::PutStockLabels()

            case ::oCriterio:nAt == 3 .and. ( dbfArticulo )->Familia >= ::cFamiliaInicio .and. ( dbfArticulo )->Familia <= ::cFamiliaFin

               ::PutStockLabels()

            case ::oCriterio:nAt == 4 .and. ( dbfArticulo )->LastChg >= ::dFechaInicio .and. ( dbfArticulo )->LastChg <= ::dFechaFin

               ::PutStockLabels()

            otherwise

               ( dbfArticulo )->lLabel    := .f.
               ( dbfArticulo )->nLabel    := 1

         end case

         ( dbfArticulo )->( dbUnLock() )

      end if

      ( dbfArticulo )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

   ( dbfArticulo )->( dbGoTo( nRecno ) )

	CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

Method PutStockLabels() CLASS TArticuloLabelGenerator

   local o
   local aStock
   local nStock                        := 0

   ( dbfArticulo )->lLabel             := .t.

   if ::nCantidadLabels == 1

      ( dbfArticulo )->nLabel          := ::nUnidadesLabels

   else

      if !Empty( ( dbfArticulo )->cCodPrp1 ) .or. !Empty( ( dbfArticulo )->cCodPrp2 )

         /*
         Limpiamos las etiquetas por propiedades-------------------------------
         */

         while ( dbfArtLbl )->( dbSeek( ( dbfArticulo )->Codigo ) ) .and. !( dbfArtLbl )->( eof() )
            if dbLock( dbfArtLbl )
               ( dbfArtLbl )->( dbDelete() )
               ( dbfArtLbl )->( dbUnLock() )
            end if
         end while

         /*
         Calculo de stock------------------------------------------------------
         */

         aStock                        := oStock:aStockArticulo( ( dbfArticulo )->Codigo, , , .f., .f. )

         for each o in aStock

            if dbAppe( dbfArtLbl )
               ( dbfArtLbl )->cCodArt  := o:cCodigo
               ( dbfArtLbl )->cCodPr1  := o:cCodigoPropiedad1
               ( dbfArtLbl )->cCodPr2  := o:cCodigoPropiedad2
               ( dbfArtLbl )->cValPr1  := o:cValorPropiedad1
               ( dbfArtLbl )->cValPr2  := o:cValorPropiedad2
               ( dbfArtLbl )->nUndLbl  := o:nUnidades
               ( dbfArtLbl )->( dbUnLock() )
            end if

            nStock                     += o:nUnidades

         next

         ( dbfArticulo )->nLabel       := Max( nStock, 0 )

      else

         nStock                        := oStock:nStockArticulo( ( dbfArticulo )->Codigo, , , .f., .f. )

         ( dbfArticulo )->nLabel       := Max( nStock, 0 )

      end if

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectPropertiesLabels() CLASS TArticuloLabelGenerator

   local n
   local oDlg
   local aTblPrp
   local oBrwPrp

   if !Empty( ( dbfArticulo )->cCodPrp1 ) .or. !Empty( ( dbfArticulo )->cCodPrp2 )

      aTblPrp                       := LoadPropertiesTable( ( dbfArticulo )->Codigo, nCosto( ( dbfArticulo )->Codigo, dbfArticulo, dbfArtKit ), ( dbfArticulo )->cCodPrp1, ( dbfArticulo )->cCodPrp2, dbfPro, dbfTblPro, dbfArtVta )

      ::LoadPropertiesLabels( aTblPrp )

      DEFINE DIALOG oDlg RESOURCE "Propiedades"

      oBrwPrp                       := IXBrowse():New( oDlg )

      oBrwPrp:nDataType             := DATATYPE_ARRAY

      oBrwPrp:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPrp:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPrp:lHScroll              := .t.
      oBrwPrp:lVScroll              := .t.

      oBrwPrp:nMarqueeStyle         := 3
      oBrwPrp:lRecordSelector       := .f.
      oBrwPrp:lFastEdit             := .t.
      oBrwPrp:nFreeze               := 1
      oBrwPrp:lFooter               := .t.

      oBrwPrp:SetArray( aTblPrp )

      for n := 1 to len( aTblPrp[ 1 ] )

         with object ( oBrwPrp:aCols[ n ] )

            :cHeader          := aTblPrp[ oBrwPrp:nArrayAt, n ]:cHead

            if IsNil( aTblPrp[ oBrwPrp:nArrayAt, n ]:Value )
               :bEditValue    := bGenEditText( aTblPrp, oBrwPrp, n )
               :nWidth        := 80
               :bFooter       := {|| "Total" }
            else
               :bEditValue    := bGenEditValue( aTblPrp, oBrwPrp, n )
               :cEditPicture  := MasUnd()
               :nWidth        := 60
               :nEditType     := 1 // EDIT_GET
               :nTotal        := 0
               :bOnPostEdit   := {| oCol, xVal, nKey | aTblPrp[ oBrwPrp:nArrayAt, oBrwPrp:nColSel + oBrwPrp:nColOffset - 1 ]:Value := xVal } // , oBrwPrp:MakeTotals()
            end if

         end with

      next

      oBrwPrp:MakeTotals()

      oBrwPrp:CreateFromResource( 100 )

      REDEFINE BUTTON;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( ::SavePropertiesLabels( aTblPrp, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| ::SavePropertiesLabels( aTblPrp, oDlg ) } )

      ACTIVATE DIALOG oDlg CENTER

   else

      MsgStop( "Este artículo no tiene propiedades." )

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method SavePropertiesLabels( aTblPrp, oDlg ) CLASS TArticuloLabelGenerator

   local o
   local a
   local n  := 0
   local c  := ""

   while ( dbfArtLbl )->( dbSeek( ( dbfArticulo )->Codigo ) ) .and. !( dbfArtLbl )->( eof() )
      if dbLock( dbfArtLbl )
         ( dbfArtLbl )->( dbDelete() )
         ( dbfArtLbl )->( dbUnLock() )
      end if
   end while

   for each a in ( aTblPrp )

      for each o in ( a )

         if IsNum( o:Value ) .and. ( o:Value != 0 )

            if dbAppe( dbfArtLbl )
               ( dbfArtLbl )->cCodArt  := o:cCodigo
               ( dbfArtLbl )->cCodPr1  := o:cCodigoPropiedad1
               ( dbfArtLbl )->cCodPr2  := o:cCodigoPropiedad2
               ( dbfArtLbl )->cValPr1  := o:cValorPropiedad1
               ( dbfArtLbl )->cValPr2  := o:cValorPropiedad2
               ( dbfArtLbl )->nUndLbl  := o:Value
               ( dbfArtLbl )->( dbUnLock() )
            end if

            n  += o:Value

         end if

      next

   next

   if dbLock( dbfArticulo )
      ( dbfArticulo )->nLabel := n
      ( dbfArticulo )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

   oDlg:end( IDOK )

Return ( .t. )

//--------------------------------------------------------------------------//

Method LoadPropertiesLabels( aTblPrp ) CLASS TArticuloLabelGenerator

   local o
   local a

   if ( dbfArtLbl )->( dbSeek( ( dbfArticulo )->Codigo ) )

      while ( dbfArtLbl )->cCodArt == ( dbfArticulo )->Codigo .and. !( dbfArtLbl )->( eof() )

         for each a in ( aTblPrp )

            for each o in ( a )

               if Rtrim( o:cCodigo )            == Rtrim( ( dbfArtLbl )->cCodArt )  .and. ;
                  Rtrim( o:cCodigoPropiedad1 )  == Rtrim( ( dbfArtLbl )->cCodPr1 )  .and. ;
                  Rtrim( o:cCodigoPropiedad2 )  == Rtrim( ( dbfArtLbl )->cCodPr2 )  .and. ;
                  Rtrim( o:cValorPropiedad1 )   == Rtrim( ( dbfArtLbl )->cValPr1 )  .and. ;
                  Rtrim( o:cValorPropiedad2 )   == Rtrim( ( dbfArtLbl )->cValPr2 )

                  o:Value  := ( dbfArtLbl )->nUndLbl

               end if

            next

         next

         ( dbfArtLbl )->( dbSkip() )

      end while

   end if

Return ( aTblPrp )

//--------------------------------------------------------------------------//

Static Function bGenEditText( aTblPrp, oBrwPrp, n )

Return ( {|| aTblPrp[ oBrwPrp:nArrayAt, n ]:cText } )

//--------------------------------------------------------------------------//

Static Function bGenEditValue( aTblPrp, oBrwPrp, n )

Return ( {|| aTblPrp[ oBrwPrp:nArrayAt, n ]:Value } )

//--------------------------------------------------------------------------//

Method AddLabel() CLASS TArticuloLabelGenerator

   if dbLock( dbfArticulo )
      ( dbfArticulo )->nLabel++
      ( dbfArticulo )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method DelLabel() CLASS TArticuloLabelGenerator

   if ( dbfArticulo )->nLabel > 1
      if dbLock( dbfArticulo )
         ( dbfArticulo )->nLabel--
         ( dbfArticulo )->( dbUnLock() )
      end if
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

Method EditLabel() CLASS TArticuloLabelGenerator

   ::oBrwLabel:aCols[ 4 ]:Edit()

Return ( Self )

//---------------------------------------------------------------------------//

Method ChangeCriterio() CLASS TArticuloLabelGenerator

   ::oFamiliaInicio:Hide()
   ::oFamiliaFin:Hide()

   ::oInicio:Hide()
   ::oFin:Hide()

   ::oFechaInicio:Hide()
   ::oFechaFin:Hide()

   do case
      case ::oCriterio:nAt == 3

         ::oFamiliaInicio:Show()
         ::oFamiliaFin:Show()
         ::oInicio:Show()
         ::oFin:Show()

      case ::oCriterio:nAt == 4

         ::oFechaInicio:Show()
         ::oFechaFin:Show()
         ::oInicio:Show()
         ::oFin:Show()

   end case

Return ( Self )

//---------------------------------------------------------------------------//

Method lCreateTemporal() CLASS TArticuloLabelGenerator

   local n
   local nRec
   local oBlock
   local oError
   local nBlancos
   local lCreateTemporal   := .t.
   local lCloseArticulo    := .f.
   local lCloseLabel       := .f.

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      tmpArticulo          := "LblArt"
      filArticulo          := cGetNewFileName( cPatTmp() + "LblAlb" )

      dbCreate( filArticulo, aSqlStruct( aItmArt() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), filArticulo, tmpArticulo, .f. )

      ( tmpArticulo )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( tmpArticulo )->( OrdCreate( filArticulo, "Codigo", "Codigo", {|| Field->Codigo } ) )

      if Empty( dbfArticulo )
         USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
         SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE
         lCloseArticulo    := .t.
      end if

      if Empty( dbfArtLbl )
         USE ( cPatArt() + "ArtLbl.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ArtLbl", @dbfArtLbl ) )
         SET ADSINDEX TO ( cPatArt() + "ArtLbl.Cdx" ) ADDITIVE
         lCloseLabel       := .t.
      end if

      /*
      Proceso de paso a temporales---------------------------------------------
      */

      nRec                 := ( dbfArticulo )->( Recno() )

      ( dbfArticulo )->( dbGoTop() )
      while !( dbfArticulo )->( eof() )

         if ( dbfArticulo )->lLabel

            if ( dbfArtLbl )->( dbSeek( ( dbfArticulo )->Codigo ) )

               while ( dbfArtLbl )->cCodArt == ( dbfArticulo )->Codigo .and. !( dbfArtLbl )->( eof() )

                  for n := 1 to ( ( dbfArtLbl )->nUndLbl )

                     dbPass( dbfArticulo, tmpArticulo, .t. )

                     ( tmpArticulo )->cCodPrp1  := ( dbfArtLbl )->cCodPr1
                     ( tmpArticulo )->cCodPrp2  := ( dbfArtLbl )->cCodPr2
                     ( tmpArticulo )->cValPrp1  := ( dbfArtLbl )->cValPr1
                     ( tmpArticulo )->cValPrp2  := ( dbfArtLbl )->cValPr2

                  next

                  ( dbfArtLbl )->( dbSkip() )

               end while

            else

               for n := 1 to ( dbfArticulo )->nLabel
                  dbPass( dbfArticulo, tmpArticulo, .t. )
               next

            end if

         end if

         ( dbfArticulo )->( dbSkip() )

      end while

      ( dbfArticulo )->( dbGoTo( nRec ) )

      ( tmpArticulo )->( dbGoTop() )

      /*
      Cerramos las tablas------------------------------------------------------
      */

      if lCloseArticulo
         ( dbfArticulo )->( dbCloseArea() )
         dbfArticulo       := nil
      end if

      if lCloseLabel
         ( dbfArtLbl )->( dbCloseArea() )
         dbfArtLbl         := nil
      end if

   RECOVER USING oError

      lCreateTemporal      := .f.

      MsgStop( 'Imposible abrir ficheros de artículos' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateTemporal )

//---------------------------------------------------------------------------//

Method PrepareTemporal( oFr ) CLASS TArticuloLabelGenerator

   local n
   local nBlancos       := 0
   local nPaperHeight   := oFr:GetProperty( "MainPage", "PaperHeight" ) * fr01cm
   local nHeight        := oFr:GetProperty( "CabeceraColumnas", "Height" )
   local nColumns       := oFr:GetProperty( "MainPage", "Columns" )
   local nItemsInColumn := 0

   if !Empty( nPaperHeight ) .and. !Empty( nHeight ) .and. !Empty( nColumns )

      nItemsInColumn    := int( nPaperHeight / nHeight )

      nBlancos          := ( ::nColumnaInicio - 1 ) * nItemsInColumn
      nBlancos          += ( ::nFilaInicio - 1 )

      for n := 1 to nBlancos
         dbPass( dbBlankRec( dbfArticulo ), tmpArticulo, .t. )
      next

   end if 

   ( tmpArticulo )->( dbGoTop() )

Return ( .t. )

//---------------------------------------------------------------------------//

Method DestroyTemporal() CLASS TArticuloLabelGenerator

   if ( tmpArticulo )->( Used() )
      ( tmpArticulo )->( dbCloseArea() )
   end if

   dbfErase( filArticulo )

Return ( .t. )

//---------------------------------------------------------------------------//

Method lPrintLabels() CLASS TArticuloLabelGenerator

   local oFr

   if !::lCreateTemporal()
      Return .f.
   end if

   SysRefresh()

   oFr                  := frReportManager():New()

   oFr:LoadLangRes(     "Spanish.Xml" )

   oFr:SetIcon( 1 )

   oFr:SetTitle(        "Diseñador de documentos" )


   /*
   Manejador de eventos--------------------------------------------------------
   */

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos---------------------------------------------------------------
   */

   DataReport( oFr, .t. )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Necesidad de incluir espacion en blancos---------------------------------
      */

      ::PrepareTemporal( oFr )

      /*
      Preparar el report-------------------------------------------------------
      */

      oFr:PrepareReport()


      /*
      Imprimir el informe------------------------------------------------------
      */

      oFr:ShowPreparedReport()

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

   /*
   Destruye el fichero temporal------------------------------------------------
   */

   ::DestroyTemporal()

Return .t.

//---------------------------------------------------------------------------//

Method InitLabel( oLabel ) CLASS TArticuloLabelGenerator

   local nStartRow

   if ::nFilaInicio > 1
      nStartRow            := oLabel:nStartRow
      nStartRow            += ( ::nFilaInicio - 1 ) * ( oLabel:nLblHeight + oLabel:nVSeparator )

      if nStartRow < oLabel:nBottomRow
         oLabel:nStartRow  := nStartRow
      end if
   end if

   if ::nColumnaInicio > 1 .and. ::nColumnaInicio <= oLabel:nLblOnLine
      oLabel:nLblCurrent   := ::nColumnaInicio
   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method SelectColumn( oCombo ) CLASS TArticuloLabelGenerator

   local oCol
   local cOrd                    := oCombo:VarGet()

   if ::oBrwLabel != nil

      with object ::oBrwLabel

         for each oCol in :aCols

            if Equal( cOrd, oCol:cHeader )
               oCol:cOrder       := "A"
               oCol:SetOrder()
            else
               oCol:cOrder       := " "
            end if

         next

      end with

      ::oBrwLabel:Refresh()

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Static Function lLabel( dbfTmpLbl )

   oMsgProgress():Deltapos( 1 )

Return ( ( dbfTmpLbl )->lLabel )

//---------------------------------------------------------------------------//

Static Function SkipLabel( dbfArticulo, oMtr )

   if ( dbfArticulo )->lLabel .and. ( dbfArticulo )->nLabel > nLabels
      ++nLabels
   else
      nLabels  := 1
      ( dbfArticulo )->( dbSkip() )
   end if

   if !Empty( oMtr )
      oMtr:Set( ( dbfArticulo )->( ordKeyNo() ) )
   end if

Return ( ( dbfArticulo )->( Recno() ) )

//----------------------------------------------------------------------------//


#else

//---------------------------------------------------------------------------//
//Parte para el PDA
//---------------------------------------------------------------------------//

STATIC FUNCTION pdaOpenFiles()

   local oError
   local oBlock
   local lOpen := .t.

   BEGIN SEQUENCE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFam ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtVta ) )
      SET ADSINDEX TO ( cPatArt() + "ARTDIV.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfArtKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPO", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE


      cPouDiv           := cPouDiv( cDivEmp(), dbfDiv )
      cPorDiv           := cPorDiv( cDivEmp(), dbfDiv )
      cPouChg           := cPouDiv( cDivChg(), dbfDiv )
      cPinDiv           := cPinDiv( cDivEmp(), dbfDiv )
      cPirDiv           := cPirDiv( cDivEmp(), dbfDiv )
      nDecDiv           := nDouDiv( cDivEmp(), dbfDiv )
      cPpvDiv           := cPpvDiv( cDivEmp(), dbfDiv )
      nDpvDiv           := nDpvDiv( cDivEmp(), dbfDiv )
      cPicEsc           := MasEsc()
      cPicUnd           := MasUnd()

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )
      pdaCloseFiles()

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

STATIC FUNCTION pdaCloseFiles()

   CLOSE ( dbfArticulo )
   CLOSE ( dbfCodebar  )
   CLOSE ( dbfArtPrv   )
   CLOSE ( dbfArtVta   )
   CLOSE ( dbfArtKit   )
   CLOSE ( dbfDiv      )
   CLOSE ( dbfIva      )
   CLOSE ( dbfFam  )

   dbfArticulo := nil
   dbfFam      := nil
   dbfCodebar  := nil
   dbfArtPrv   := nil
   dbfArtVta   := nil
   dbfArtKit   := nil
   dbfDiv      := nil
   dbfIva      := nil

return .t.

//---------------------------------------------------------------------------//

FUNCTION pdaArticulo( oMenuItem )

   local oSnd
   local nLevel
   local oBlock
   local oDlg
   local oBrwArticulo
   local oGetBuscar
   local cGetBuscar     := Space( 100 )
   local oCbxOrden
   local cCbxOrden      := "Código"
   local oSayTit
   local oFont
   local oBtn

   DEFAULT  oMenuItem   := "01014"

   /*
   Obtenemos el nivel de acceso
   */

   nLevel               := nLevelUsr( oMenuItem )

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   if !pdaOpenFiles()
      return nil
   end if

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

      DEFINE DIALOG oDlg RESOURCE "Dlg_info"

      REDEFINE SAY oSayTit ;
         VAR      "Artículos" ;
         ID       140 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       130 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "Cube_yellow_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE GET oGetBuscar ;
         VAR      cGetBuscar;
         ID       110 ;
         BITMAP   "FIND" ;
         OF       oDlg

      oGetBuscar:bChange   := {| nKey, nFlags | AutoSeek( nKey, nFlags, oGetBuscar, oBrwArticulo, dbfArticulo ) }

      REDEFINE COMBOBOX oCbxOrden ;
         VAR      cCbxOrden ;
         ID       120 ;
         ITEMS    { "Código", "Nombre" } ;
			OF 		oDlg

      oCbxOrden:bChange    := {|| ( dbfArticulo )->( OrdSetFocus( oCbxOrden:nAt ) ), ( dbfArticulo )->( dbGoTop() ), oBrwArticulo:Refresh(), oGetBuscar:SetFocus(), oCbxOrden:Refresh() }

      REDEFINE LISTBOX oBrwArticulo ;
         FIELDS ;
               ( dbfArticulo )->Codigo + CRLF + ( dbfArticulo )->Nombre ;
         SIZES ;
               180 ;
         HEADER ;
               "Código" + CRLF + "Nombre" ;
         ALIAS ( dbfArticulo );
         ID    100 ;
         OF    oDlg

      ACTIVATE DIALOG oDlg ;
         ON INIT ( oDlg:SetMenu( pdaBuildMenu( oDlg, oBrwArticulo ) ) )

      pdaCloseFiles()

   RECOVER

      msgStop( "Imposible abrir articulos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   oFont:End()

   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

RETURN NIL

//----------------------------------------------------------------------------//

static function pdaBuildMenu( oDlg, oBrwArticulo )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 300 ;
      BITMAPS  40 ; // bitmaps resoruces ID
      IMAGES   5     // number of images in the bitmap

      REDEFINE MENUITEM ID 310 OF oMenu ACTION ( WinAppRec( oBrwArticulo, bEdtPda, dbfArticulo, oDlg ) )

      REDEFINE MENUITEM ID 320 OF oMenu ACTION ( WinEdtRec( oBrwArticulo, bEdtPda, dbfArticulo, oDlg ) )

      REDEFINE MENUITEM ID 330 OF oMenu ACTION ( DBDelRec( oBrwArticulo, dbfArticulo) )

      REDEFINE MENUITEM ID 340 OF oMenu ACTION ( WinZooRec( oBrwArticulo, bEdtPda, dbfArticulo, oDlg ) )

      REDEFINE MENUITEM ID 350 OF oMenu ACTION ( oDlg:End() )

Return oMenu

//---------------------------------------------------------------------------//

Static Function PdaEdtRec( aTmp, aGet, dbfArticulo, oBrw, oDlgAnt, bValid, nMode )

	local oDlg
   local oSayTit
   local oFont
   local oBtn
   local oSay
   local cSay

   if nMode == EDIT_MODE .or. nMode == ZOOM_MODE
      cSay     := RetFld( aTmp[( dbfArticulo )->( fieldpos( "FAMILIA" ) ) ], dbfFam, "CNOMFAM" )
   end if

   DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

   DEFINE DIALOG oDlg RESOURCE "ARTICULO_PDA"  //TITLE LblTitle( nMode ) + "familias de artículos"

      REDEFINE SAY oSayTit ;
         VAR      "Añadiendo artículos" ;
         ID       110 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       100 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "Cube_yellow_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE GET   aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ];
         VAR      aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ];
         ID       120 ;
         WHEN     ( nMode == APPD_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "Nombre" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "Nombre" ) ) ];
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "FAMILIA" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "FAMILIA" ) ) ];
         ID       140 ;
         BITMAP   "LUPA" ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON HELP  ( pdaBrwFamilia( aGet[ ( dbfArticulo )->( fieldpos( "FAMILIA" ) ) ], oSay ) ) ;
         OF       oDlg

      REDEFINE GET oSay;
         VAR      cSay;
			WHEN 		( .F. );
         ID       150 ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "LIVAINC" ) ) ];
         ID       160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "pCosto" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "pCosto" ) ) ];
         ID       170 ;
         PICTURE  ( cPinDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "PVENTA1" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "PVENTA1" ) ) ];
         ID       180 ;
         PICTURE  ( cPouDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "PVTAIVA1" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "PVTAIVA1" ) ) ];
         ID       190 ;
         PICTURE  ( cPouDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "PVENTA2" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "PVENTA2" ) ) ];
         ID       200 ;
         PICTURE  ( cPouDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "PVTAIVA2" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "PVTAIVA2" ) ) ];
         ID       210 ;
         PICTURE  ( cPouDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "PVENTA3" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "PVENTA3" ) ) ];
         ID       220 ;
         PICTURE  ( cPouDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "PVTAIVA3" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "PVTAIVA3" ) ) ];
         ID       230 ;
         PICTURE  ( cPouDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "PVENTA4" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "PVENTA4" ) ) ];
         ID       240 ;
         PICTURE  ( cPouDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "PVTAIVA4" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "PVTAIVA4" ) ) ];
         ID       250 ;
         PICTURE  ( cPouDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "PVENTA5" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "PVENTA5" ) ) ];
         ID       260 ;
         PICTURE  ( cPouDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "PVTAIVA5" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "PVTAIVA5" ) ) ];
         ID       270 ;
         PICTURE  ( cPouDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "PVENTA6" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "PVENTA6" ) ) ];
         ID       280 ;
         PICTURE  ( cPouDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET   aGet[( dbfArticulo )->( fieldpos( "PVTAIVA6" ) ) ] ;
         VAR      aTmp[( dbfArticulo )->( fieldpos( "PVTAIVA6" ) ) ];
         ID       290 ;
         PICTURE  ( cPouDiv );
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

   ACTIVATE DIALOG oDlg ;
      ON INIT ( oDlg:SetMenu( pdaMenuEdtRec( aTmp, aGet, nMode, oBrw, oDlg ) ) )

   oFont:End()

   oDlgAnt:Show()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function pdaMenuEdtRec( aTmp, aGet, nMode, oBrw, oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( PdaEndTrans( aTmp, aGet, nMode, oBrw, oDlg ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

Return oMenu

//---------------------------------------------------------------------------//

static function pdaMenuBuscar( oDlg, oBrw )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( oDlg:End( IDOK ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )

   oBrw:GoTop()

Return oMenu

//---------------------------------------------------------------------------//


STATIC FUNCTION PdaEndTrans( aTmp, aGet, nMode, oBrw, oDlg )

   local aTabla
   local cCodArt  := aTmp[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]

   //Controlamos que no se cree una familia con el código o el nombre en blanco

   if nMode == APPD_MODE

      if Empty( cCodArt )
         MsgStop( "Código no puede estar vacío" )
         aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]:SetFocus()
         return nil
      end if

      if dbSeekInOrd( cCodArt, "Codigo", dbfArticulo )
         MsgStop( "Código ya existe " + Rtrim( cCodArt ) )
         aGet[ ( dbfArticulo )->( fieldpos( "Codigo" ) ) ]:SetFocus()
         return nil
      end if

   end if

   if Empty( aTmp[( dbfArticulo )->( fieldpos( "Nombre" ) ) ] )
      MsgStop( "Nombre no puede estar vacío" )
      aGet[( dbfArticulo )->( fieldpos( "Nombre" ) ) ]:SetFocus()
      return nil
   end if

   WinGather( aTmp, aGet, dbfArticulo, oBrw, nMode )

   oDlg:end( IDOK )

   dbCommitAll()

Return NIL

//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//

CLASS pdaArticuloSenderReciver

   Method CreateData()

   Method CleanRelation()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus, cPatPreVenta ) CLASS pdaArticuloSenderReciver

   local tmpKit
   local tmpOfe
   local tmpArtVta
   local tmpArtPrv
   local tmpArticulo
   local tmpCodebar
   local tmpImg
   local dbfKit
   local dbfOfe
   local dbfArtVta
   local dbfArtPrv
   local dbfArticulo
   local dbfCodebar
   local dbfImg
   local lExist         := .f.
   local cFileName
   local cPatPc         := if( Empty( cPatPreVenta ), cPatPc(), cPatPreVenta )

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
   SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtVta ) )
   SET ADSINDEX TO ( cPatArt() + "ARTDIV.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTKIT", @dbfKit ) )
   SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOfe ) )
   SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

   USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
   SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

   USE ( cPatArt() + "ArtImg.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ArtImg", @dbfImg ) )
   SET ADSINDEX TO ( cPatArt() + "ArtImg.Cdx" ) ADDITIVE

   dbUseArea( .t., cDriver(), cPatPc + "ARTICULO.Dbf", cCheckArea( "ARTICULO", @tmpArticulo ), .t. )
   ( tmpArticulo )->( ordListAdd( cPatPc + "ARTICULO.Cdx" ) )
   ( tmpArticulo )->( OrdSetFocus( "lSndDoc" ) )

   dbUseArea( .t., cDriver(), cPatPc + "PROVART.Dbf", cCheckArea( "PROVART", @tmpArtPrv ), .t. )
   ( tmpArtPrv )->( ordListAdd( cPatPc + "PROVART.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatPc + "ARTDIV.Dbf", cCheckArea( "ARTDIV", @tmpArtVta ), .t. )
   ( tmpArtVta )->( ordListAdd( cPatPc + "ARTDIV.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatPc + "ARTKIT.Dbf", cCheckArea( "ARTKIT", @tmpKit ), .t. )
   ( tmpKit )->( ordListAdd( cPatPc + "ARTKIT.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatPc + "OFERTA.Dbf", cCheckArea( "OFERTA", @tmpOfe ), .t. )
   ( tmpOfe )->( ordListAdd( cPatPc + "OFERTA.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatPc + "ARTCODEBAR.Dbf", cCheckArea( "CODEBAR", @tmpCodebar ), .t. )
   ( tmpCodebar )->( ordListAdd( cPatPc + "ARTCODEBAR.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatPc + "ArtImg.Dbf", cCheckArea( "ArtImg", @tmpImg ), .t. )
   ( tmpImg )->( ordListAdd( cPatPc + "ArtImg.Cdx" ) )

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( tmpArticulo )->( OrdKeyCount() ) )
   end if

   ( tmpArticulo )->( dbGoTop() )
   while !( tmpArticulo )->( eof() )

      if ( tmpArticulo )->lSndDoc

         ::CleanRelation( ( tmpArticulo )->Codigo, dbfArtPrv, dbfArtVta, dbfKit, dbfOfe, dbfCodeBar )

         if dbLock( tmpArticulo )
            ( tmpArticulo )->lSndDoc       := .f.
            ( tmpArticulo )->( dbUnlock() )
         end if

         if ( dbfArticulo )->( dbSeek( ( tmpArticulo )->Codigo ) )
            dbPass( tmpArticulo, dbfArticulo, .f. )
         else
            dbPass( tmpArticulo, dbfArticulo, .t. )
         end if

         /*
         Referencias de proveedores
         */

         if ( tmpCodebar )->( dbSeek( ( tmpArticulo )->Codigo ) )
            while ( tmpCodebar )->cCodArt == ( tmpArticulo )->Codigo .and. !( tmpCodebar )->( eof() )
               dbPass( tmpCodebar, dbfCodebar, .f. )
               ( tmpCodebar )->( dbSkip() )
            end while
         end if

         /*
         referencias de proveedores --> posible fallo
         */

         if ( tmpArtPrv )->( dbSeek( ( tmpArticulo )->Codigo ) )
            while ( tmpArtPrv )->cCodArt == ( tmpArticulo )->Codigo .and. !( tmpArtPrv )->( eof() )
               dbPass( tmpArtPrv, dbfArtPrv, .f. )
               ( tmpArtPrv )->( dbSkip() )
            end while
         end if

         /*
         precios en distintas divisas
         */

         if ( tmpArtVta )->( dbSeek( ( tmpArticulo )->CODIGO ) )
            while ( tmpArtVta )->cCodArt == ( tmpArticulo )->Codigo .AND. !( tmpArtVta )->( eof() )
               dbPass( tmpArtVta, dbfArtVta, .f. )
               ( tmpArtVta )->( dbSkip() )
            end while
         end if

         /*
         kits asociados
         */

         if ( tmpKit )->( dbSeek( ( tmpArticulo )->CODIGO ) )
            while ( tmpKit )->cCodKit == ( tmpArticulo )->Codigo .AND. !( tmpKit )->( eof() )
               dbPass( tmpKit, dbfKit, .f. )
               ( tmpKit )->( dbSkip() )
            end while
         end if

         /*
         Ofertas de articulos
         */

         if ( tmpOfe )->( dbSeek( ( tmpArticulo )->Codigo ) )
            while ( tmpOfe )->cArtOfe == ( tmpArticulo )->Codigo .AND. !( tmpOfe )->( eof() )
               dbPass( tmpOfe, dbfOfe, .f. )
               ( tmpOfe )->( dbSkip() )
            end while
         end if

         /*
         Ofertas de articulos
         */

         if ( tmpImg )->( dbSeek( ( tmpArticulo )->Codigo ) )
            while ( tmpImg )->cArtOfe == ( tmpArticulo )->Codigo .AND. !( tmpImg )->( eof() )
               dbPass( tmpImg, dbfOfe, .f. )
               ( tmpImg )->( dbSkip() )
            end while
         end if

      end if

      ( tmpArticulo )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando Artículos " + Alltrim( Str( ( tmpArticulo )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( tmpArticulo )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( tmpArticulo )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( tmpArticulo )
   CLOSE ( tmpArtPrv   )
   CLOSE ( tmpArtVta   )
   CLOSE ( tmpKit      )
   CLOSE ( tmpOfe      )
   CLOSE ( tmpImg      )
   CLOSE ( tmpCodebar  )
   CLOSE ( dbfArticulo )
   CLOSE ( dbfArtPrv   )
   CLOSE ( dbfArtVta   )
   CLOSE ( dbfKit      )
   CLOSE ( dbfOfe      )
   CLOSE ( dbfCodebar  )

Return ( Self )

//---------------------------------------------------------------------------//

Method CleanRelation( CodArt, dbfArtPrv, dbfArtVta, dbfKit, dbfOfe, dbfCodeBar )

   if !Empty( dbfArtPrv ) .and. ( dbfArtPrv )->( Used() )
      while ( dbfArtPrv )->( dbSeek( CodArt ) )
         dbDel( dbfArtPrv )
      end while
   end if

   if !Empty( dbfArtVta ) .and. ( dbfArtVta )->( Used() )
      while ( dbfArtVta )->( dbSeek( CodArt ) )
         dbDel( dbfArtVta )
      end while
   end if

   if !Empty( dbfKit ) .and. ( dbfKit )->( Used() )
      while ( dbfKit )->( dbSeek( CodArt ) )
         dbDel( dbfKit )
      end while
   end if

   if !Empty( dbfOfe ) .and. ( dbfOfe )->( Used() )
      while ( dbfOfe )->( dbSeek( CodArt ) )
         dbDel( dbfOfe )
      end while
   end if

   if !Empty( dbfImg ) .and. ( dbfImg )->( Used() )
      while ( dbfImg )->( dbSeek( CodArt ) )
         dbDel( dbfImg )
      end while
   end if

   if !Empty( dbfCodeBar ) .and. ( dbfCodeBar )->( Used() )
      while ( dbfCodeBar )->( dbSeek( CodArt ) )
         dbDel( dbfCodeBar )
      end while
   end if

Return ( Self )
//----------------------------------------------------------------------------//

CLASS pdaPCArtSenderReciver

   Method CreateData()

   Method CleanRelation()

END CLASS

//---------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus, cPatPreVenta ) CLASS pdaPCArtSenderReciver

   local lExist         := .f.
   local pcKit
   local pcOfe
   local pcArtVta
   local pcArtPrv
   local pcArticulo
   local pcCodebar
   local pdaKit
   local pdaOfe
   local pdaArtVta
   local pdaArtPrv
   local pdaArticulo
   local pdaCodebar
   local cPatPc         := if( Empty( cPatPreVenta ), cPatPc(), cPatPreVenta )

   USE ( cPatPc + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @pcArticulo ) )
   SET ADSINDEX TO ( cPatPc + "ARTICULO.CDX" ) ADDITIVE
   ( pcArticulo )->( OrdSetFocus( "lSndDoc" ) )

   USE ( cPatPc + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @pcArtPrv ) )
   SET ADSINDEX TO ( cPatPc + "PROVART.CDX" ) ADDITIVE

   USE ( cPatPc + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @pcArtVta ) )
   SET ADSINDEX TO ( cPatPc + "ARTDIV.CDX" ) ADDITIVE

   USE ( cPatPc + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTKIT", @pcKit ) )
   SET ADSINDEX TO ( cPatPc + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatPc + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @pcOfe ) )
   SET ADSINDEX TO ( cPatPc + "OFERTA.CDX" ) ADDITIVE

   USE ( cPatPc + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @pcCodebar ) )
   SET ADSINDEX TO ( cPatPc + "ArtCodebar.Cdx" ) ADDITIVE

   /*
   Usamos las bases de datos del PC--------------------------------------------
   */

   dbUseArea( .t., cDriver(), cPatPc + "ARTICULO.Dbf", cCheckArea( "ARTICULO", @pdaArticulo ), .t. )
   ( pdaArticulo )->( ordListAdd( cPatPc + "ARTICULO.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatPc + "PROVART.Dbf", cCheckArea( "PROVART", @pdaArtPrv ), .t. )
   ( pdaArtPrv )->( ordListAdd( cPatPc + "PROVART.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatPc + "ARTDIV.Dbf", cCheckArea( "ARTDIV", @pdaArtVta ), .t. )
   ( pdaArtVta )->( ordListAdd( cPatPc + "ARTDIV.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatPc + "ARTKIT.Dbf", cCheckArea( "ARTKIT", @pdaKit ), .t. )
   ( pdaKit )->( ordListAdd( cPatPc + "ARTKIT.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatPc + "OFERTA.Dbf", cCheckArea( "OFERTA", @pdaOfe ), .t. )
   ( pdaOfe )->( ordListAdd( cPatPc + "OFERTA.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatPc + "ARTCODEBAR.Dbf", cCheckArea( "CODEBAR", @pdaCodebar ), .t. )
   ( pdaCodebar )->( ordListAdd( cPatPc + "ARTCODEBAR.Cdx" ) )


   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( pdaArticulo )->( OrdKeyCount() ) )
   end if

   ( pdaArticulo )->( dbGoTop() )

   while !( pdaArticulo )->( eof() )

      if ( pdaArticulo )->lSndDoc

         ::CleanRelation( ( pcArticulo )->Codigo, pdaArtPrv, pdaArtVta, pdaKit, pdaOfe, pdaCodeBar )

         if !( pcArticulo )->( dbSeek( ( pdaArticulo )->Codigo ) )

            if dbLock( pdaArticulo )
               ( pdaArticulo )->lSndDoc  := .f.
               ( pdaArticulo )->( dbUnLock() )
            end if

            dbPass( pdaArticulo, pcArticulo, .t. )

            if ( pdaArtPrv )->( dbSeek( ( pdaArticulo )->Codigo ) )
               while ( pdaArtPrv )->cCodArt == ( pdaArticulo )->Codigo .and. !( pdaArtPrv )->( eof() )
                  dbPass( pdaArtPrv, pcArtPrv, .t. )
                  ( pdaArtPrv )->( dbSkip() )
               end while
            end if

            if ( pdaArtVta )->( dbSeek( ( pdaArticulo )->Codigo ) )
               while ( pdaArtVta )->cCodArt == ( pdaArticulo )->Codigo .and. !( pdaArtVta )->( eof() )
                  dbPass( pdaArtVta, pcArtVta, .t. )
                  ( pdaArtVta )->( dbSkip() )
               end while
            end if

            if ( pdaKit )->( dbSeek( ( pdaArticulo )->Codigo ) )
               while ( pdaKit )->cCodKit == ( pdaArticulo )->Codigo .and. !( pdaKit )->( eof() )
                  dbPass( pdaKit, pcKit, .t. )
                  ( pdaKit )->( dbSkip() )
               end while
            end if

            if ( pdaOfe )->( dbSeek( ( pdaArticulo )->Codigo ) )
               while ( pdaOfe )->cArtOfe == ( pdaArticulo )->Codigo .and. !( pdaOfe )->( eof() )
                  dbPass( pdaOfe, pcOfe, .t. )
                  ( pdaOfe )->( dbSkip() )
               end while
            end if

            if ( pdaCodebar )->( dbSeek( ( pdaArticulo )->Codigo ) )
               while ( pdaCodebar )->cCodArt == ( pdaArticulo )->Codigo .and. !( pdaCodebar )->( eof() )
                  dbPass( pdaCodebar, pcCodebar, .t. )
                  ( pdaCodebar )->( dbSkip() )
               end while
            end if

         end if

      end if

      ( pdaArticulo )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando Artículos " + Alltrim( Str( ( pdaArticulo )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( pdaArticulo )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( pdaArticulo )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( pcKit       )
   CLOSE ( pcOfe       )
   CLOSE ( pcArtVta    )
   CLOSE ( pcArtPrv    )
   CLOSE ( pcArticulo  )
   CLOSE ( pcCodebar   )
   CLOSE ( pdaKit      )
   CLOSE ( pdaOfe      )
   CLOSE ( pdaArtVta   )
   CLOSE ( pdaArtPrv   )
   CLOSE ( pdaArticulo )
   CLOSE ( pdaCodebar  )

Return ( Self )

//----------------------------------------------------------------------------//

Method CleanRelation( CodArt, pdaArtPrv, pdaArtVta, pdaKit, pdaOfe, pdaCodeBar )

   while ( pdaArtPrv )->( dbSeek( CodArt ) )
      dbDel( pdaArtPrv )
   end while

   while ( pdaArtVta )->( dbSeek( CodArt ) )
      dbDel( pdaArtVta )
   end while

   while ( pdaKit )->( dbSeek( CodArt ) )
      dbDel( pdaKit )
   end while

   while ( pdaOfe )->( dbSeek( CodArt ) )
      dbDel( pdaOfe )
   end while

   while ( pdaCodeBar )->( dbSeek( CodArt ) )
      dbDel( pdaCodeBar )
   end while

   SysRefresh()

Return Self

//----------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//Parte para el programa normal y el PDA
//---------------------------------------------------------------------------//

Function IsArticulo( cPath )

   DEFAULT cPath  := cPatArt()

   if !lExistTable( cPath + "Articulo.Dbf" )
      dbCreate( cPath + "Articulo.Dbf",   aSqlStruct( aItmArt() ), cDriver() )
   end if

   if !lExistTable( cPath + "ArtDiv.Dbf" )
      dbCreate( cPath + "ArtDiv.Dbf",     aSqlStruct( aItmVta() ), cDriver() )
   end if

   if !lExistTable( cPath + "ArtKit.Dbf" )
      dbCreate( cPath + "ArtKit.Dbf",     aSqlStruct( aItmKit() ), cDriver() )
   end if

   if !lExistTable( cPath + "ArtCodebar.Dbf" )
      dbCreate( cPath + "ArtCodebar.Dbf", aSqlStruct( aItmBar() ), cDriver() )
   end if

   if !lExistTable( cPath + "ProvArt.Dbf" )
      dbCreate( cPath + "ProvArt.Dbf",    aSqlStruct( aItmArtPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "ArtLbl.Dbf" )
      dbCreate( cPath + "ArtLbl.Dbf",     aSqlStruct( aItmLbl() ), cDriver() )
   end if

   if !lExistTable( cPath + "ArtImg.Dbf" )
      dbCreate( cPath + "ArtImg.Dbf",     aSqlStruct( aItmImg() ), cDriver() )
   end if

   if !lExistIndex( cPath + "Articulo.Cdx"   )  .or. ;
      !lExistIndex( cPath + "ArtDiv.Cdx"     )  .or. ;
      !lExistIndex( cPath + "ArtKit.Cdx"     )  .or. ;
      !lExistIndex( cPath + "ArtCodebar.Cdx" )  .or. ;
      !lExistIndex( cPath + "ProvArt.Cdx"    )  .or. ;
      !lExistIndex( cPath + "ArtLbl.Cdx"     )  .or. ;
      !lExistIndex( cPath + "ArtImg.Cdx"     )

      rxArticulo( cPath )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

FUNCTION mkArticulo( cPath, lAppend, cPathOld, oMeter, lMovAlm )

	DEFAULT lAppend	:= .f.
	DEFAULT lMovAlm	:= .t.
   DEFAULT cPath     := cPatArt()

   if !Empty( oMeter )
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
   end if

   if !lExistTable( cPath + "Articulo.Dbf" )
      dbCreate( cPath + "Articulo.Dbf",   aSqlStruct( aItmArt() ),      cDriver() )
   end if

   if !lExistTable( cPath + "ArtDiv.Dbf" )
      dbCreate( cPath + "ArtDiv.Dbf",     aSqlStruct( aItmVta() ),      cDriver() )
   end if

   if !lExistTable( cPath + "ArtKit.Dbf" )
      dbCreate( cPath + "ArtKit.Dbf",     aSqlStruct( aItmKit() ),      cDriver() )
   end if

   if !lExistTable( cPath + "ArtCodebar.Dbf" )
      dbCreate( cPath + "ArtCodebar.Dbf", aSqlStruct( aItmBar() ),      cDriver() )
   end if

   if !lExistTable( cPath + "ProvArt.Dbf" )
      dbCreate( cPath + "ProvArt.Dbf",    aSqlStruct( aItmArtPrv() ),   cDriver() )
   end if

   if !lExistTable( cPath + "ArtLbl.Dbf" )
      dbCreate( cPath + "ArtLbl.Dbf",     aSqlStruct( aItmLbl() ),      cDriver() )
   end if

   if !lExistTable( cPath + "ArtImg.Dbf" )
      dbCreate( cPath + "ArtImg.Dbf",     aSqlStruct( aItmImg() ),      cDriver() )
   end if

   /*
   Regeneramos indices---------------------------------------------------------
   */

   if lAppend .and. lIsDir( cPathOld )

      AppDbf( cPathOld, cPath, "Articulo"    )
      AppDbf( cPathOld, cPath, "ArtDiv"      )
      AppDbf( cPathOld, cPath, "ProvArt"     )
      AppDbf( cPathOld, cPath, "ArtCodebar"  )
      AppDbf( cPathOld, cPath, "ArtKit"      )
      AppDbf( cPathOld, cPath, "ArtLbl"      )
      AppDbf( cPathOld, cPath, "ArtImg"      )

      if lMovAlm
         AppDbf( cPathOld, cPath, "MovAlm"   )
      end if

   end if

   rxArticulo( cPath, oMeter )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxArticulo( cPath, oMeter, lRecPrc )

   local dbfCodebar
   local dbfArticulo

   DEFAULT cPath     := cPatArt()
   DEFAULT lRecPrc   := .f.

   if !lExistTable( cPath + "Articulo.Dbf"   ) .or. ;
      !lExistTable( cPath + "ProvArt.Dbf"    ) .or. ;
      !lExistTable( cPath + "ArtDiv.Dbf"     ) .or. ;
      !lExistTable( cPath + "ArtKit.Dbf"     ) .or. ;
      !lExistTable( cPath + "ArtCodebar.Dbf" ) .or. ;
      !lExistTable( cPath + "ArtLbl.Dbf"     ) .or. ;
      !lExistTable( cPath + "ArtImg.Dbf"     )

      mkArticulo( cPath )

   end if

   fErase( cPath + "Articulo.Cdx"   )
   fErase( cPath + "ProvArt.Cdx"    )
   fErase( cPath + "ArtDiv.Cdx"     )
   fErase( cPath + "ArtKit.Cdx"     )
   fErase( cPath + "ArtCodebar.Cdx" )
   fErase( cPath + "ArtLbl.Cdx"     )
   fErase( cPath + "ArtImg.Cdx"     )

   dbUseArea( .t., cDriver(), cPath + "ARTICULO.DBF", cCheckArea( "ARTICULO", @dbfArticulo ), .f. )

   if !( dbfArticulo )->( neterr() )

      ( dbfArticulo )->( __dbPack() )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "Articulo.Cdx", "Codigo", "Codigo", {|| Field->Codigo } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "Nombre", "UPPER( NOMBRE )", {|| UPPER( Field->NOMBRE ) } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "CFAMCOD", "FAMILIA + CODIGO", {|| Field->FAMILIA + Field->CODIGO }, ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "cPrvHab", "cPrvHab", {|| Field->cPrvHab }, ) )

      ( dbfArticulo )->( ordCondSet("!Deleted() .and. !lObs", {|| !Deleted() .and. !Field->lObs }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "CodObs", "Codigo", {|| Field->Codigo } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted() .and. !lObs", {|| !Deleted() .and. !Field->lObs }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "NOMOBS", "UPPER( NOMBRE )", {|| UPPER( Field->NOMBRE ) } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "CCODTIP", "CCODTIP", {|| Field->CCODTIP }, ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "CCODCATE", "CCODCATE", {|| Field->CCODCATE }, ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "CCODTEMP", "CCODTEMP", {|| Field->CCODTEMP }, ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "CCODFAB", "CCODFAB", {|| Field->CCODFAB }, ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "CFAMNOM", "FAMILIA + NOMBRE", {|| Field->FAMILIA + Field->NOMBRE }, ) )

      ( dbfArticulo )->( ordCondSet("!Deleted() .and. lIncTcl", {|| !Deleted() .and. Field->lIncTcl }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "Articulo.Cdx", "nPosTpv", "Field->Familia + Str( Field->nPosTpv )", {|| Field->Familia + Str( Field->nPosTpv ) } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted() .and. lIncTcl", {|| !Deleted() .and. Field->lIncTcl }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "Articulo.Cdx", "nNomTpv", "Field->Familia + Field->NOMBRE ", {|| Field->Familia + Field->NOMBRE } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "FAMILIA", "FAMILIA", {|| Field->FAMILIA }, ) )

      ( dbfArticulo )->( ordCondSet("!Deleted() .and. lIncTcl .and. nPosTpv != 0", {|| !Deleted() .and. Field->lIncTcl .and. Field->nPosTpv != 0 }, , , , , , , , , .t. ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "NPOSTCL", "NPOSTCL", {|| Field->nPosTcl }, ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "NCTLSTOCK", "NCTLSTOCK", {|| Field->NCTLSTOCK }, ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "Articulo.Cdx", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted() .and. lSndDoc", {|| !Deleted() .and. Field->lSndDoc }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "SNDCOD", "CODIGO", {|| Field->Codigo } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "MOVART", "Padl( RTrim( Field->CODIGO ), 18 )", {|| Padl( RTrim( Field->CODIGO ), 18 ) } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "cCodTnk", "Field->cCodTnk", {|| Field->cCodTnk } ) )

      ( dbfArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTICULO.CDX", "CodeBar", "Field->CodeBar", {|| Field->CodeBar } ) )

      ( dbfArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "Articulo.Cdx", "cCodUsr", "Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg", {|| Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg } ) )

      ( dbfArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "Articulo.Cdx", "cCodWeb", "Str( Field->cCodWeb, 11 )", {|| Str( Field->cCodWeb, 11 ) } ) )

      ( dbfArticulo )->( ordCondSet( "!Deleted() .and. lPubInt", {|| !Deleted() .and. Field->lPubInt }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "Articulo.Cdx", "lPubInt", "lPubInt", {|| Field->lPubInt } ) )

      ( dbfArticulo )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )

   end if

   /*
   Articulos proveedores-------------------------------------------------------
   */

   dbUseArea( .t., cDriver(), cPath + "PROVART.DBF", cCheckArea( "PROVART", @dbfArticulo ), .f. )

   if !( dbfArticulo )->( neterr() )

      ( dbfArticulo )->( __dbPack() )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArticulo )->( ordCreate( cPath + "PROVART.CDX", "CCODART", "CCODART", {|| Field->CCODART } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArticulo )->( ordCreate( cPath + "PROVART.CDX", "CCODPRV", "CCODPRV + CCODART", {|| Field->CCODPRV + Field->CCODART } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArticulo )->( ordCreate( cPath + "PROVART.CDX", "cRefPrv", "cCodPrv + cRefPrv", {|| Field->CCODPRV + Field->CREFPRV } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArticulo )->( ordCreate( cPath + "PROVART.CDX", "cRefArt", "cCodArt + cCodPrv + cRefPrv", {|| Field->cCodArt + Field->cCodPrv + Field->cRefPrv } ) )

      ( dbfArticulo )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )

   end if

	/*
	Indice de precios en divisas_______________________________________________
	*/

   dbUseArea( .t., cDriver(), cPath + "ARTDIV.DBF", cCheckArea( "ARTDIV", @dbfArticulo ), .f. )

   if !( dbfArticulo )->( neterr() )
      ( dbfArticulo )->( __dbPack() )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArticulo )->( ordCreate( cPath + "ArtDiv.Cdx", "cCodArt", "CCODART + CCODPR1 + CCODPR2 + CVALPR1 + CVALPR2", {|| Field->CCODART + Field->CCODPR1 + Field->CCODPR2 + Field->CVALPR1 + Field->CVALPR2 } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArticulo )->( ordCreate( cPath + "ArtDiv.Cdx", "cValPrp", "CCODART + CVALPR1 + CVALPR2", {|| Field->CCODART + Field->CVALPR1 + Field->CVALPR2 } ) )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArticulo )->( ordCreate( cPath + "ArtDiv.Cdx", "cCodigo", "CCODART", {|| Field->CCODART } ) )

      ( dbfArticulo )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )
   end if

	/*
   Articulos Kit______________________________________________________________________________________________
   */

   dbUseArea( .t., cDriver(), cPath + "ARTKIT.DBF", cCheckArea( "ARTKIT", @dbfArticulo ), .f. )
   if !( dbfArticulo )->( neterr() )
      ( dbfArticulo )->( __dbPack() )

      ( dbfArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTKIT.CDX", "CCODKIT", "CCODKIT", {|| Field->CCODKIT } ) )

      ( dbfArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTKIT.CDX", "CCODREF", "CCODKIT + CREFKIT", {|| Field->CCODKIT + Field->CREFKIT } ) )

      ( dbfArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfArticulo )->( ordCreate( cPath + "ARTKIT.CDX", "CREFKIT", "CREFKIT", {|| Field->CREFKIT } ) )

      ( dbfArticulo )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )
   end if

   /*
   Codigos de barras___________________________________________________________
	*/

   dbUseArea( .t., cDriver(), cPath + "ArtCodebar.Dbf", cCheckArea( "ARTICULO", @dbfArticulo ), .f. )

   if !( dbfArticulo )->( neterr() )

      ( dbfArticulo )->( __dbPack() )

      ( dbfArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ArtCodebar.Cdx", "cCodArt", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ArtCodebar.Cdx", "cCodBar", "cCodBar", {|| Field->cCodBar } ) )

      ( dbfArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ArtCodebar.Cdx", "cArtBar", "cCodArt + cCodBar", {|| Field->cCodArt + Field->cCodBar } ) )

      ( dbfArticulo )->( ordCondSet( "!Deleted() .and. lDefBar", {|| !Deleted() .and. Field->lDefBar }  ) )
      ( dbfArticulo )->( ordCreate( cPath + "ArtCodebar.Cdx", "cDefArt", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfArticulo )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de codigos de barras" )

   end if

   /*
   Indice de unidades para etiquetas___________________________________________
	*/

   dbUseArea( .t., cDriver(), cPath + "ArtLbl.Dbf", cCheckArea( "ArtLbl", @dbfArticulo ), .f. )

   if !( dbfArticulo )->( neterr() )
      ( dbfArticulo )->( __dbPack() )

      ( dbfArticulo )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArticulo )->( ordCreate( cPath + "ArtLbl.Cdx", "cCodArt", "cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2", {|| Field->cCodArt + Field->cCodPr1 + Field->cCodPr2 + Field->cValPr1 + Field->cValPr2 } ) )

      ( dbfArticulo )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )
   end if

   /*
   Indice de unidades para imagenes___________________________________________
	*/

   dbUseArea( .t., cDriver(), cPath + "ArtImg.Dbf", cCheckArea( "ArtImg", @dbfArticulo ), .f. )

   if !( dbfArticulo )->( neterr() )
      ( dbfArticulo )->( __dbPack() )

      ( dbfArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfArticulo )->( ordCreate( cPath + "ArtImg.Cdx", "cCodArt", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfArticulo )->( ordCondSet( "!Deleted() .and. lDefImg", {|| !Deleted() .and. Field->lDefImg } ) )
      ( dbfArticulo )->( ordCreate( cPath + "ArtImg.Cdx", "lDefImg", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfArticulo )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfArticulo )->( ordCreate( cPath + "ArtImg.Cdx", "cImgArt", "cImgArt", {|| Field->cImgArt } ) )

      ( dbfArticulo )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )
   end if

   /*
   Recalculo de precios--------------------------------------------------------
   */

   /*
   if lRecPrc

      dbUseArea( .t., cDriver(), cPath + "Articulo.Dbf", cCheckArea( "Articulo", @dbfArticulo ), .f. )

      if !( dbfArticulo )->( neterr() )

         ( dbfArticulo )->( ordListAdd( cPath + "Articulo.Cdx" ) )

         dbUseArea( .t., cDriver(), cPath + "ArtCodebar.Dbf", cCheckArea( "CODEBAR", @dbfCodebar ), .f. )

         if !( dbfCodebar )->( neterr() )

            ( dbfCodebar )->( ordListAdd( cPath + "ArtCodebar.Cdx" ) )
            ( dbfCodebar )->( ordSetFocus( "cArtBar" ) )

            while !( dbfArticulo )->( Eof() )

               if !Empty( ( dbfArticulo )->CodeBar )                                                  .and. ;
                  !( dbfCodebar )->( dbSeek( ( dbfArticulo )->Codigo + ( dbfArticulo )->CodeBar ) )

                  ( dbfCodebar )->( dbAppend() )
                  ( dbfCodebar )->cCodArt    := ( dbfArticulo )->Codigo
                  ( dbfCodebar )->cCodBar    := ( dbfArticulo )->CodeBar
                  ( dbfCodebar )->nTipBar    := ( dbfArticulo )->nTipBar

               end if

               ( dbfArticulo )->( dbSkip() )

            end while

            if ( dbfCodebar ) != nil
               ( dbfCodebar )->( dbCloseArea() )
            end if

         end if

         if ( dbfArticulo ) != nil
            ( dbfArticulo )->( dbCloseArea() )
         end if

      end if

   end if*/

RETURN NIL

//--------------------------------------------------------------------------//
/*
Estructura de articulos
*/

function aItmArt()

   local aBase  := {}

   aAdd( aBase, { "Codigo",    "C", 18, 0, "Código del artículo" ,                    "'@!'",               "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Nombre",    "C",100, 0, "Nombre del artículo",                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesTik",   "C", 20, 0, "Descripción para el tiket" ,              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pCosto",    "N", 15, 6, "Precio de costo" ,                        "PicIn()",            "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PvpRec",    "N", 15, 6, "Precio venta recomendado" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf1",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 1","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF2",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 2","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF3",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 3","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF4",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 4","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF5",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 5","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF6",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 6","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF1",    "N",  6, 2, "Porcentaje de beneficio precio 1" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF2",    "N",  6, 2, "Porcentaje de beneficio precio 2" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF3",    "N",  6, 2, "Porcentaje de beneficio precio 3" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF4",    "N",  6, 2, "Porcentaje de beneficio precio 4" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF5",    "N",  6, 2, "Porcentaje de beneficio precio 5" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF6",    "N",  6, 2, "Porcentaje de beneficio precio 6" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR1",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 1","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR2",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 2","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR3",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 3","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR4",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 4","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR5",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 5","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR6",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 6","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA1",   "N", 15, 6, "Precio de venta precio 1" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA2",   "N", 15, 6, "Precio de venta precio 2" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA3",   "N", 15, 6, "Precio de venta precio 3" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA4",   "N", 15, 6, "Precio de venta precio 4" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA5",   "N", 15, 6, "Precio de venta precio 5" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA6",   "N", 15, 6, "Precio de venta precio 6" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA1",  "N", 15, 6, "Precio de venta precio 1 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA2",  "N", 15, 6, "Precio de venta precio 2 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA3",  "N", 15, 6, "Precio de venta precio 3 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA4",  "N", 15, 6, "Precio de venta precio 4 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA5",  "N", 15, 6, "Precio de venta precio 5 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA6",  "N", 15, 6, "Precio de venta precio 6 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ1",     "N", 15, 6, "Precio de alquiler precio 1" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ2",     "N", 15, 6, "Precio de alquiler precio 2" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ3",     "N", 15, 6, "Precio de alquiler precio 3" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ4",     "N", 15, 6, "Precio de alquiler precio 4" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ5",     "N", 15, 6, "Precio de alquiler precio 5" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ6",     "N", 15, 6, "Precio de alquiler precio 6" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA1",  "N", 15, 6, "Precio de alquiler precio 1 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA2",  "N", 15, 6, "Precio de alquiler precio 2 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA3",  "N", 15, 6, "Precio de alquiler precio 3 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA4",  "N", 15, 6, "Precio de alquiler precio 4 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA5",  "N", 15, 6, "Precio de alquiler precio 5 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA6",  "N", 15, 6, "Precio de alquiler precio 6 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPNTVER1",  "N", 15, 6, "Contribución punto verde" ,                               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPNVIVA1",  "N", 15, 6, "Contribución punto verde " + cImp() + " inc.",            "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NACTUAL",   "N", 15, 6, "Número de artículos" ,                    "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCAJENT",   "N", 15, 6, "Número de cajas por defecto" ,            "MasUnd()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NUNICAJA",  "N", 15, 6, "Número de unidades por defecto" ,         "MasUnd()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NMINIMO",   "N", 15, 6, "Número de stock mínimo" ,                 "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NMAXIMO",   "N", 15, 6, "Número de stock maximo" ,                 "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCNTACT",   "N", 15, 6, "Número del contador" ,                    "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LASTIN",    "D",  8, 0, "Fecha ultima entrada" ,                   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LASTCHG",   "D",  8, 0, "Fecha de creación" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LASTOUT",   "D",  8, 0, "Fecha ultima salida" ,                    "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "TIPOIVA",   "C",  1, 0, "Código tipo de " + cImp(),                "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LIVAINC",   "L",  1, 0, "Lógico " + cImp() + " incluido (S/N)" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "FAMILIA",   "C", 16, 0, "Código de la familia del artículo" ,      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CSUBFAM",   "C",  8, 0, "Código de la subfamilia del artículo" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "GRPVENT",   "C",  9, 0, "Código del grupo de ventas" ,             "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTAVTA",   "C", 12, 0, "Código de la cuenta de ventas" ,          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTACOM",   "C", 12, 0, "Código de la cuenta de compras" ,         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTATRN",   "C", 12, 0, "Código de la cuenta de portes" ,          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CODEBAR",   "C", 20, 0, "Código de barras" ,                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NTIPBAR",   "N",  2, 0, "Tipo de código de barras" ,               "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "DESCRIP",   "M", 10, 0, "Descripción larga" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LLABEL",    "L",  1, 0, "Lógico de selección de etiqueta",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLABEL",    "N",  5, 0, "Número de etiquetas a imprimir",          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCTLSTOCK", "N",  1, 0, "Control de stock (1/2/3)",                "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LSELPRE",   "L",  1, 0, "",                                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NSELPRE",   "N",  5, 0, "",                                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NTIPPRE",   "N",  1, 0, "",                                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPESOKG",   "N", 16, 6, "Peso del artículo" ,                      "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNIDAD",   "C",  2, 0, "Unidad de medición del peso" ,            "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NVOLUMEN",  "N", 16, 6, "Volumen del artículo" ,                   "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CVOLUMEN",  "C",  2, 0, "Unidad de medición del volumen" ,         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLNGART",   "N", 16, 6, "Largo del artículo" ,                     "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NALTART",   "N", 16, 6, "Alto del artículo" ,                      "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NANCART",   "N", 16, 6, "Ancho del artículo" ,                     "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNDDIM",   "C",  2, 0, "Unidad de medición de las longitudes" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPPES",   "N", 15, 6, "Importe de peso/volumen del articulo" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CIMAGEN",   "C",250, 0, "Fichero de imagen" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lSndDoc",   "L",  1, 0, "Lógico para envios" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUsr",   "C",  3, 0, "Código de usuario que realiza el cambio" ,"",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFecChg",   "D",  8, 0, "Fecha de cambio" ,                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTimChg",   "C",  5, 0, "Hora de cambio" ,                         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lKitArt",   "L",  1, 0, "Lógico de escandallos" ,                  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lKitAsc",   "L",  1, 0, "Lógico de asociado" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitImp",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitStk",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitPrc",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lAutSer",   "L",  1, 0, "Lógico de autoserializar" ,               "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LOBS",      "L",  1, 0, "Lógico de obsoleto" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LNUMSER",   "L",  1, 0, "Lógico solicitar numero de serie" ,       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CPRVHAB",   "C", 12, 0, "Proveedor habitual" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LFACCNV",   "L",  1, 0, "Usar factor de conversión" ,              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CFACCNV",   "C",  2, 0, "Código del factor de conversión" ,        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTNK",   "C",  3, 0, "Código del tanque de combustible" ,       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTIP",   "C",  3, 0, "Código del tipo de artículo" ,            "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LTIPACC",   "L",  1, 0, "Lógico de acceso por unidades o importe", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LCOMBUS",   "L",  1, 0, "Lógico si el artículo es del tipo combustible", "",             "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODIMP",   "C",  3, 0, "Código del impuesto especiales",          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LMSGVTA",   "L",  1, 0, "Lógico para avisar en venta sin stock",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LNOTVTA",   "L",  1, 0, "Lógico para no permitir venta sin stock", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLOTE",     "N",  9, 0, "",                                        "'999999999'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CLOTE",     "C", 12, 0, "Número de lote",                          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LLOTE",     "L",  1, 0, "Lote (S/N)",                              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBINT",   "L",  1, 0, "Lógico para publicar en internet (S/N)",  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBOFE",   "L",  1, 0, "Lógico para publicar como oferta (S/N)",  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBPOR",   "L",  1, 0, "Lógico para publicar como artículo destacado (S/N)",  "",       "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT1",  "N",  6, 2, "Descuento de oferta para tienda web 1",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT1",  "N", 15, 6, "Precio del producto en oferta 1",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA1",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 1", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT2",  "N",  6, 2, "Descuento de oferta para tienda web 2",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT2",  "N", 15, 6, "Precio del producto en oferta 2",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA2",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 2", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT3",  "N",  6, 2, "Descuento de oferta para tienda web 3",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT3",  "N", 15, 6, "Precio del producto en oferta 3",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA3",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 3", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT4",  "N",  6, 2, "Descuento de oferta para tienda web 4",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT4",  "N", 15, 6, "Precio del producto en oferta 4",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA4",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 4", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT5",  "N",  6, 2, "Descuento de oferta para tienda web 5",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT5",  "N", 15, 6, "Precio del producto en oferta 5",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA5",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 5", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT6",  "N",  6, 2, "Descuento de oferta para tienda web 6",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT6",  "N", 15, 6, "Precio del producto en oferta 6",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA6",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 6", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "MDESTEC",   "M", 10, 0, "Descripción técnica del artículo",        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLNGCAJ",   "N", 16, 6, "Largo de la caja" ,                       "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NALTCAJ",   "N", 16, 6, "Alto de la caja" ,                        "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NANCCAJ",   "N", 16, 6, "Ancho de la caja" ,                       "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNDCAJ",   "C",  2, 0, "Unidad de medición de la caja" ,          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPESCAJ",   "N", 16, 6, "Peso de la caja" ,                        "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCAJPES",   "C",  2, 0, "Unidad de medición del peso de la caja" , "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NVOLCAJ",   "N", 16, 6, "Volumen de la caja" ,                     "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCAJVOL",   "C",  2, 0, "Unidad de medición del volumen de la caja","",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCAJPLT",   "N", 16, 6, "Número de cajas por palets" ,             "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBASPLT",   "N", 16, 6, "Base del palet" ,                         "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NALTPLT",   "N", 16, 6, "Altura del palet" ,                       "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNDPLT",   "C",  2, 0, "Unidad de medición de la altura del palet","",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LINCTCL",   "L",  1, 0, "Incluir en pantalla táctil",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CDESTCL",   "C", 20, 0, "Descripción en pantalla táctil",           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CDESCMD",   "M", 10, 0, "Descripción para comanda",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPOSTCL",   "N", 16, 6, "Posición en pantalla táctil",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODCAT",   "C",  4, 0, "Código del catálogo del artículo" ,        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPUNTOS",   "N", 16, 6, "Puntos del catalogo" ,                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOPNT",   "N",  6, 2, "Dto. del catalogo" ,                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NRENMIN",   "N",  6, 2, "Rentabilidad mínima" ,                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODCATE",  "C",  3, 0, "Código de categoría",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTEMP",  "C",  3, 0, "Código de la temporada",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LECOTASA",  "L",  1, 0, "Lógico para usar ECOTASA",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LMOSCOM",   "L",  1, 0, "Lógico mostrar comentario" ,               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "MCOMENT",   "M", 10, 0, "Comentario a mostrar" ,                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUNTO",    "L",  1, 0, "Lógico para trabajar con puntos" ,         "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODPRP1",  "C", 20, 0, "Código de la primera propiedad" ,          "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODPRP2",  "C", 20, 0, "Código de la segunda propiedad" ,          "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lCodPrp",   "L",  1, 0, "" ,                                        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodFra",   "C",  3, 0, "Código de frases publiciarias",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodWeb",   "N", 11, 0, "Código del producto en la web",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPosTpv",   "N", 10, 2, "Posición para mostrar en TPV táctil",      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDuracion", "N",  3, 0, "Duración del producto",                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nTipDur",   "N",  1, 0, "Tipo duración (dia, mes, año)",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodFab",   "C",  3, 0, "Código del fabricante",                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nImpCom1",  "N",  1, 0, "Impresora de comanda 1",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nImpCom2",  "N",  1, 0, "Impresora de comanda 2",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMsgMov",   "L",  1, 0, "Lógico para avisar en movimientos sin stock","",                "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cImagenWeb","C",250, 0, "Imagen para la web",                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cChgBar",   "D",  8, 0, "Fecha de cambio de código de barras",      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUbi1",  "C",  5, 0, "Código primera ubicación",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUbi2",  "C",  5, 0, "Código segunda ubicación",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUbi3",  "C",  5, 0, "Código tercera ubicación",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValUbi1",  "C",  5, 0, "Valor primera ubicación",                  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValUbi2",  "C",  5, 0, "Valor segunda ubicación",                  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValUbi3",  "C",  5, 0, "Valor tercera ubicación",                  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFecVta",   "D",  8, 0, "Fecha de puesta a la venta",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFinVta",   "D",  8, 0, "Fecha de fin de la venta",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMsgSer",   "L",  1, 0, "Avisar en ventas por series sin stock",    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPrp1",  "C", 40, 0, "Valor de la primera propiedad",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPrp2",  "C", 40, 0, "Valor de la segunda propiedad",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "mValPrp1",  "M", 10, 0, "Valores seleccionables de la primera propiedad", "",            "", "( cDbfArt )", nil } )
   aAdd( aBase, { "mValPrp2",  "M", 10, 0, "Valores seleccionables de la segunda propiedad", "",            "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dChgBar",   "D",  8, 0, "Fecha de cambio de codigos de barras",     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodSus",   "C", 18, 0, "Código del artículo al que se sustituye" , "'@!'",              "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPor",   "C", 18, 0, "Código del artículo por el que es sustituido" , "'@!'",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt1",  "N",  6, 2, "Primer descuento de artículo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt2",  "N",  6, 2, "Segundo descuento de artículo",            "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt3",  "N",  6, 2, "Tercer descuento de artículo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt4",  "N",  6, 2, "Cuarto descuento de artículo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt5",  "N",  6, 2, "Quinto descuento de artículo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt6",  "N",  6, 2, "Sexto descuento de artículo",              "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMarAju",   "L",  1, 0, "Lógico para utilizar el margen de ajuste", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cMarAju",   "C",  5, 0, "Cadena descriptiva del margen de ajuste",  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nTarWeb",   "N",  1, 0, "Tarifa a aplicar en la Web" ,              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pVtaWeb",   "N", 16, 6, "Precio venta en la Web",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTipImp1",  "C", 50, 0, "Tipo impresora comanda 1",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTipImp2",  "C", 50, 0, "Tipo impresora comanda 2",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefPrv",   "C", 18, 0, "Referencia del proveedor al artículo" ,    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodSec",   "C",  3, 0, "Código de la sección para producción" ,    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nFacCnv",   "N", 16, 6, "Factor de conversión" ,                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lSbrInt",   "L",  1, 0, "Lógico precio libre internet" ,            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nColBtn",   "N", 10, 0, "Color para táctil" ,                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cOrdOrd",   "C",  2, 0, "Orden de comanda" ,                        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lTerminado","L",  1, 0, "Lógico de producto terminado (producción)" , "",                "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lPeso",     "L",  1, 0, "Lógico de producto por peso",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cMenu",     "C",  3, 0, "Código del menú de acompañamiento",        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTitSeo",   "C", 70, 0, "Meta-título",                              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesSeo",   "C",160, 0, "Meta-descripcion",                         "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cKeySeo",   "C",160, 0, "Meta-keywords",                            "",                  "", "( cDbfArt )", nil } )

return ( aBase )

//----------------------------------------------------------------------------//
/*
Estructura de escandallos
*/
Function aItmKit()

   local aBase := {}

   aAdd( aBase, { "cCodKit",   "C", 18, 0, "Código del contenedor"               , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefKit",   "C", 18, 0, "Código de artículo escandallo"       , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nUndKit",   "N", 16, 6, "Unidades de escandallo"              , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreKit",   "N", 16, 6, "Precio de escandallo"                , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesKit",   "C", 50, 0, "Descripción del escandallo"          , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cUniDad",   "C",  2, 0, "Unidad de medición"                  , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nValPnt",   "N", 16, 6, ""                                    , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoPnt",   "N",  6, 2, "Descuento del punto"                 , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lAplDto",   "L",  1, 0, "Lógico aplicar descuentos"           , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lExcPro",   "L",  1, 0, "Lógico para excluir de producción"   , "",                  "", "( cDbfArt )", nil } )

return ( aBase )

//----------------------------------------------------------------------------//
/*
Estructura de ventas por propiedades
*/

Function aItmVta()

   local aBase := {}

   aAdd( aBase, { "cCodArt",   "C", 18, 0, "Código de artículo",                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodDiv",   "C",  3, 0, "Código de divisa",                         "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPr1",   "C", 20, 0, "Código de primera propiedad",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPr2",   "C", 20, 0, "Código de segunda propiedad",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr1",   "C", 40, 0, "Valor de primera propiedad",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr2",   "C", 40, 0, "Valor de segunda propiedad",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreCom",   "N", 16, 6, "Precio de compras",                        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nValPnt",   "N", 16, 6, "Valor del punto",                          "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoPnt",   "N",  6, 2, "Descuento del punto",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf1",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 1", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf2",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 2", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf3",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 3", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf4",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 4", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf5",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 5", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf6",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 6", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Benef1",    "N",  6, 2, "Porcentaje de beneficio precio 1" ,        "'@EZ 99.99'",       "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Benef2",    "N",  6, 2, "Porcentaje de beneficio precio 2" ,        "'@EZ 99.99'",       "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Benef3",    "N",  6, 2, "Porcentaje de beneficio precio 3" ,        "'@EZ 99.99'",       "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Benef4",    "N",  6, 2, "Porcentaje de beneficio precio 4" ,        "'@EZ 99.99'",       "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Benef5",    "N",  6, 2, "Porcentaje de beneficio precio 5" ,        "'@EZ 99.99'",       "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Benef6",    "N",  6, 2, "Porcentaje de beneficio precio 6" ,        "'@EZ 99.99'",       "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nBnfSbr1",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 1", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nBnfSbr2",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 2", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nBnfSbr3",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 3", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nBnfSbr4",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 4", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nBnfSbr5",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 5", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nBnfSbr6",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 6", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreVta1",  "N", 16, 6, "Precio de venta 1"                       , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreVta2",  "N", 16, 6, "Precio de venta 2"                       , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreVta3",  "N", 16, 6, "Precio de venta 3"                       , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreVta4",  "N", 16, 6, "Precio de venta 4"                       , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreVta5",  "N", 16, 6, "Precio de venta 5"                       , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreVta6",  "N", 16, 6, "Precio de venta 6"                       , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreIva1",  "N", 16, 6, "Precio de venta " + cImp() + " incl. 1"  , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreIva2",  "N", 16, 6, "Precio de venta " + cImp() + " incl. 2"  , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreIva3",  "N", 16, 6, "Precio de venta " + cImp() + " incl. 3"  , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreIva4",  "N", 16, 6, "Precio de venta " + cImp() + " incl. 4"  , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreIva5",  "N", 16, 6, "Precio de venta " + cImp() + " incl. 5"  , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreIva6",  "N", 16, 6, "Precio de venta " + cImp() + " incl. 6"  , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cImgWeb",   "C",250, 0, "Imagen para la web de estas propiedades" , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cToolTip",  "C",250, 0, "Tooltip para las imagenes de la web"     , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodImgWeb","N", 11, 0, "Código de la imagen para la web"         , "",                  "", "( cDbfArt )", 0 } )

Return ( aBase )

//---------------------------------------------------------------------------//

Function aItmArtPrv()

   local aBase := {}

   aAdd( aBase, { "cCodArt",   "C", 18, 0, "Código del artículo referenciado"  , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPrv",   "C", 12, 0, "Código del proveedor"              , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefPrv",   "C", 18, 0, "Referencia del proveedor al artículo" , "",               "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoPrv",   "N",  6, 2, "Descuento del proveedor"           , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoPrm",   "N",  6, 2, "Descuento por promoción"           , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDivPrv",   "C",  3, 0, "Código de la divisa"               , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nImpPrv",   "N", 19, 6, "Importe de compra"                 , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lDefPrv",   "L",  1, 0, "Lógico de proveedor por defecto"   , "",                  "", "( cDbfArt )", nil } )

Return ( aBase )

//---------------------------------------------------------------------------//

Function aItmLbl()

   local aBase := {}

   aAdd( aBase, { "cCodArt",   "C", 18, 0, "Código de artículo",                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPr1",   "C", 20, 0, "Código de primera propiedad",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPr2",   "C", 20, 0, "Código de segunda propiedad",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr1",   "C", 40, 0, "Valor de primera propiedad",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr2",   "C", 40, 0, "Valor de segunda propiedad",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nUndLbl",   "N", 16, 6, "Precio de compras",                        "",                  "", "( cDbfArt )", nil } )

Return ( aBase )

//---------------------------------------------------------------------------//

Function aItmImg()

   local aBase := {}

   aAdd( aBase, { "cCodArt",   "C",  18, 0, "Código del artículo",                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cImgArt",   "C", 230, 0, "Imagen del artículo",                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cNbrArt",   "C", 230, 0, "Nombre de la imagen",                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cHtmArt",   "M",  10, 0, "HTML de la imagen",                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodWeb",   "N",  11, 0, "Código de artículo para la web",          "",                  "", "( cDbfArt )", 0 } )
   aAdd( aBase, { "lDefImg",   "L",   1, 0, "Lógico para imágen por defecto",          "",                  "", "( cDbfArt )", .f. } )

Return ( aBase )

//---------------------------------------------------------------------------//

//
// Devuelve si se contempla stock en componentes
//

FUNCTION lStockComponentes( cCodArt, uArticulo )

   local aSta
   local lTmp     := .f.

   do case
   case IsChar( uArticulo )

      aSta        := aGetStatus( uArticulo, .t. )

      if ( uArticulo )->( dbSeek( cCodArt ) )
         lTmp     := ( uArticulo )->lKitArt .and. ( ( uArticulo )->nKitStk <= KIT_TODOS .or. ( uArticulo )->nKitStk == KIT_COMPONENTE )
      end if

      SetStatus( uArticulo, aSta )

   case IsObject( uArticulo )

      uArticulo:GetStatus( .t. )

      if uArticulo:Seek( cCodArt )
         lTmp     := uArticulo:lKitArt .and. ( uArticulo:nKitStk <= KIT_TODOS .or. uArticulo:nKitStk == KIT_COMPONENTE )
      end if

      uArticulo:SetStatus()

   end case

RETURN ( lTmp )

//---------------------------------------------------------------------------//

//
// Devuelve si tenemos los precios en los componentes
//

FUNCTION lPreciosComponentes( cCodArt, uArticulo )

   local aSta
   local lTmp     := .f.

   do case
   case IsChar( uArticulo )

      aSta        := aGetStatus( uArticulo, .t. )

      if ( uArticulo )->( dbSeek( cCodArt ) )
         lTmp     := ( ( uArticulo )->nKitPrc <= KIT_TODOS .or. ( uArticulo )->nKitPrc == KIT_COMPONENTE )
      end if

      SetStatus( uArticulo, aSta )

   case IsObject( uArticulo )

      uArticulo:GetStatus( .t. )

      if uArticulo:Seek( cCodArt )
         lTmp     := ( uArticulo:nKitPrc <= KIT_TODOS .or. uArticulo:nKitPrc == KIT_COMPONENTE )
      end if

      uArticulo:SetStatus()

   end case

RETURN ( lTmp )

//---------------------------------------------------------------------------//

//
// Devuelve si componente se debe imprimir
//

FUNCTION lImprimirComponente( cCodArt, uArticulo )

   local aSta
   local lTmp     := .f.

   do case
   case IsChar( uArticulo )

      aSta        := aGetStatus( uArticulo, .t. )

      if ( uArticulo )->( dbSeek( cCodArt ) )
         lTmp     := !( ( uArticulo )->lKitArt .and. ( ( uArticulo )->nKitImp <= KIT_TODOS .or. ( uArticulo )->nKitImp == KIT_COMPONENTE ) )
      end if

      SetStatus( uArticulo, aSta )

   case IsObject( uArticulo )

      uArticulo:GetStatus( .t. )

      if uArticulo:Seek( cCodArt )
         lTmp     := !( uArticulo:lKitArt .and. ( uArticulo:nKitImp <= KIT_TODOS .or. uArticulo:nKitImp == KIT_COMPONENTE ) )
      end if

      uArticulo:SetStatus()

   end case

RETURN ( lTmp )

//--------------------------------------------------------------------------//

Function nRetPreArt( nTarifa, cCodDiv, lIvaInc, dbfArticulo, dbfDiv, dbfArtKit, dbfIva, lBuscaImportes, oTarifa )

   local nIva
   local nPre              := 0
   local nPreIva           := 0
   local nPreCos           := nil
   local oError
   local oBlock

   DEFAULT nTarifa         := 1
   DEFAULT lIvaInc         := .f.
   DEFAULT lBuscaImportes  := lBuscaImportes()

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if nTarifa == 0
      nTarifa        := 1
   end if

   while .t.

      if ( dbfArticulo )->lKitArt

         nIva              := nIva( dbfIva, ( dbfArticulo )->TipoIva )

         do case
            case nTarifa == 1
               if ( dbfArticulo )->lBnf1
                  if Empty( nPreCos )
                  nPreCos  := nCosto( nil, dbfArticulo, dbfArtKit )
                  end if
                  nPre     := ( nPreCos * ( dbfArticulo )->Benef1 / 100 ) + nPreCos
                  nPreIva  := ( nPre * nIva / 100 ) + nPre
               else
                  nPreIva  := ( dbfArticulo )->pVtaIva1
                  nPre     := ( dbfArticulo )->pVenta1
               end if

            case nTarifa == 2
               if ( dbfArticulo )->lBnf2
                  if Empty( nPreCos )
                  nPreCos  := nCosto( nil, dbfArticulo, dbfArtKit )
                  end if
                  nPre     := ( nPreCos * ( dbfArticulo )->Benef2 / 100 ) + nPreCos
                  nPreIva  := ( nPre * nIva / 100 ) + nPre
               else
                  nPreIva  := ( dbfArticulo )->pVtaIva2
                  nPre     := ( dbfArticulo )->Pventa2
               end if

            case nTarifa == 3
               if ( dbfArticulo )->lBnf3
                  if Empty( nPreCos )
                  nPreCos  := nCosto( nil, dbfArticulo, dbfArtKit )
                  end if
                  nPre     := ( nPreCos * ( dbfArticulo )->Benef3 / 100 ) + nPreCos
                  nPreIva  := ( nPre * nIva / 100 ) + nPre
               else
                  nPreIva  := ( dbfArticulo )->pVtaIva3
                  nPre     := ( dbfArticulo )->Pventa3
               end if

            case nTarifa == 4
               if ( dbfArticulo )->lBnf4
                  if Empty( nPreCos )
                  nPreCos  := nCosto( nil, dbfArticulo, dbfArtKit )
                  end if
                  nPre     := ( nPreCos * ( dbfArticulo )->Benef4 / 100 ) + nPreCos
                  nPreIva  := ( nPre * nIva / 100 ) + nPre
               else
                  nPreIva  := ( dbfArticulo )->pVtaIva4
                  nPre     := ( dbfArticulo )->Pventa4
               end if

            case nTarifa == 5
               if ( dbfArticulo )->lBnf5
                  if Empty( nPreCos )
                  nPreCos  := nCosto( nil, dbfArticulo, dbfArtKit )
                  end if
                  nPre     := ( nPreCos * ( dbfArticulo )->Benef5 / 100 ) + nPreCos
                  nPreIva  := ( nPre * nIva / 100 ) + nPre
               else
                  nPreIva  := ( dbfArticulo )->pVtaIva5
                  nPre     := ( dbfArticulo )->Pventa5
               end if

            case nTarifa == 6
               if ( dbfArticulo )->lBnf6
                  if Empty( nPreCos )
                  nPreCos  := nCosto( nil, dbfArticulo, dbfArtKit )
                  end if
                  nPre     := ( nPreCos * ( dbfArticulo )->Benef6 / 100 ) + nPreCos
                  nPreIva  := ( nPre * nIva / 100 ) + nPre
               else
                  nPreIva  := ( dbfArticulo )->pVtaIva6
                  nPre     := ( dbfArticulo )->Pventa6
               end if

         end do

      else

         do case
            case nTarifa == 1
               nPre     := ( dbfArticulo )->pVenta1
               nPreIva  := ( dbfArticulo )->pVtaIva1
            case nTarifa == 2
               nPre     := ( dbfArticulo )->pVenta2
               nPreIva  := ( dbfArticulo )->pVtaIva2
            case nTarifa == 3
               nPre     := ( dbfArticulo )->pVenta3
               nPreIva  := ( dbfArticulo )->pVtaIva3
            case nTarifa == 4
               nPre     := ( dbfArticulo )->pVenta4
               nPreIva  := ( dbfArticulo )->pVtaIva4
            case nTarifa == 5
               nPre     := ( dbfArticulo )->pVenta5
               nPreIva  := ( dbfArticulo )->pVtaIva5
            case nTarifa == 6
               nPre     := ( dbfArticulo )->pVenta6
               nPreIva  := ( dbfArticulo )->pVtaIva6
         end do

      end if

      if ( nPre == 0 .or. nPreIva == 0 ) .and. nTarifa > 1 .and. lBuscaImportes
         nTarifa--
         loop
      else
         exit
      end if

   end while

   if oTarifa != nil
      oTarifa:cText( nTarifa )
   end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( if( lIvaInc, nPreIva, nPre ) )

//---------------------------------------------------------------------------//

Function nCosto( uTmp, dbfArticulo, dbfArtKit, lPic, cDivRet, dbfDiv )

   local oError
   local oBlock
   local nCosto      := 0
   local cCodArt     := ""
   local lKitArt     := .f.
   local nOrdArt
   local nOrdKit
   local nRecArt
   local nRecKit

   DEFAULT lPic      := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nOrdArt           := ( dbfArticulo )->( OrdSetFocus( "Codigo" ) )
   nRecArt           := ( dbfArticulo )->( Recno() )
   nOrdKit           := ( dbfArtKit   )->( OrdSetFocus( "cCodKit" ) )
   nRecKit           := ( dbfArtKit   )->( Recno() )

   do case
      case IsArray( uTmp )
         cCodArt     := uTmp[ ( dbfArticulo )->( fieldpos( "Codigo"  ) ) ]
         lKitArt     := uTmp[ ( dbfArticulo )->( fieldpos( "lKitArt" ) ) ] .and. !uTmp[ ( dbfArticulo )->( fieldpos( "lKitAsc" ) ) ]
      case IsChar( uTmp ) .and. ( dbfArticulo )->( dbSeek( uTmp ) )
         cCodArt     := ( dbfArticulo )->Codigo
         lKitArt     := ( dbfArticulo )->lKitArt .and. !( dbfArticulo )->lKitAsc
      case Empty( uTmp )
         cCodArt     := ( dbfArticulo )->Codigo
         lKitArt     := ( dbfArticulo )->lKitArt .and. !( dbfArticulo )->lKitAsc
   end case

   if lKitArt

      if ( dbfArtKit )->( dbSeek( cCodArt ) )
         while ( dbfArtKit )->cCodKit == cCodArt .and. !( dbfArtKit )->( eof() )
            nCosto   += nCosto( ( dbfArtKit )->cRefKit, dbfArticulo, dbfArtKit ) * ( dbfArtKit )->nUndKit // * nFactorConversion( ( dbfArtKit )->cRefKit, dbfArticulo ) 
            ( dbfArtKit )->( dbSkip() )
         end while
      end if

   else

      nCosto         += pCosto( dbfArticulo )

   end if

   ( dbfArticulo )->( OrdSetFocus( nOrdArt ) )
   ( dbfArticulo )->( dbGoTo( nRecArt ) )
   ( dbfArtKit   )->( OrdSetFocus( nOrdKit ) )
   ( dbfArtKit   )->( dbGoTo( nRecKit ) )

   if dbfDiv != nil

      if cDivRet != nil .and. cDivRet != cDivEmp()
         nCosto      := nCnv2Div( nCosto, cDivEmp(), cDivRet, dbfDiv )
         if lPic
            nCosto   := Trans( nCosto, cPinDiv( cDivRet, dbfDiv ) )
         end if
      else
         if lPic
            nCosto   := Trans( nCosto, cPinDiv( cDivEmp(), dbfDiv ) )
         end if
      end if

   end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

return ( nCosto )

//---------------------------------------------------------------------------//

Function pCosto( dbfArticulo, lPic, cDivRet, dbfDiv, lFacCnv )

   local nCosto      := 0

   DEFAULT lPic      := .f.
   DEFAULT lFacCnv   := .t.

   nCosto            := ( dbfArticulo )->pCosto
/*
   if ( dbfArticulo )->lFacCnv .and. ( dbfArticulo )->nFacCnv != 0
      nCosto         *= ( dbfArticulo )->nFacCnv
   end if
*/
   if dbfDiv != nil
      if cDivRet != nil .and. cDivRet != cDivEmp()
         nCosto      := nCnv2Div( nCosto, cDivEmp(), cDivRet )
         if lPic
            nCosto   := Trans( nCosto, cPinDiv( cDivRet, dbfDiv ) )
         end if
      else
         if lPic
            nCosto   := Trans( nCosto, cPinDiv( cDivEmp(), dbfDiv ) )
         end if
      end if
   end if

return ( nCosto )

//---------------------------------------------------------------------------//

Static Function nFactorConversion( cCodArt, dbfArticulo )

Return ( NotCero( RetFld( cCodArt, dbfArticulo, "nFacCnv" ) ) )

//---------------------------------------------------------------------------//
//
// Devuelve si el articulo kit es asociado
//

FUNCTION lKitAsociado( cCodArt, uArticulo )

   local aSta
   local lTmp     := .f.

   do case
   case IsChar( uArticulo )

      aSta        := aGetStatus( uArticulo, .t. )

      if ( uArticulo )->( dbSeek( cCodArt ) )
         lTmp     := ( uArticulo )->lKitArt .and. ( uArticulo )->lKitAsc
      end if

      SetStatus( uArticulo, aSta )

   case IsObject( uArticulo )

      uArticulo:GetStatus( .t. )

      if uArticulo:Seek( cCodArt )
         lTmp     := uArticulo:lKitArt .and. uArticulo:lKitAsc
      end if

      uArticulo:SetStatus()

   end case

RETURN ( lTmp )

//---------------------------------------------------------------------------//

function GraLotArt( cCodArt, dbfArticulo, cLote )

   local nOrdSetFocus   := ( dbfArticulo )->( ordSetFocus( "Codigo" ) )

   /*
   Actualizar NLOTE en el Fichero de artículos
   ----------------------------------------------------------------------------
   */

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      if ( dbfArticulo )->( dbRLock() )
         ( dbfArticulo )->cLote  := cLote
         ( dbfArticulo )->( dbRUnLock() )
      end if
   end if

   ( dbfArticulo )->( ordSetFocus( nOrdSetFocus ) )

RETURN NIL
//---------------------------------------------------------------------------//

function lAccArticulo()

return ( nAnd( nLevelUsr( "01014" ), 1 ) == 0 )

//---------------------------------------------------------------------------//

Function BrwArticulo( oGetCodigo, oGetNombre, lCodeBar, lAppend, oBtn, oGetLote, oGetCodPrp1, oGetCodPrp2, oGetValPrp1, oGetValPrp2, oGetFecCad )

   if !IsPda() .and. !IsReport()
      if IsObject( oUser() ) .and. oUser():lSelectorFamilia()
         Return ( BrwFamiliaArticulo( oGetCodigo, oGetNombre, lCodeBar, lAppend ) )
      end if
   end if

Return ( BrwSelArticulo( oGetCodigo, oGetNombre, lCodeBar, lAppend, nil, oBtn, oGetLote, oGetCodPrp1, oGetCodPrp2, oGetValPrp1, oGetValPrp2, oGetFecCad ) )

//---------------------------------------------------------------------------//

Function BrwSelArticulo( oGetCodigo, oGetNombre, lCodeBar, lAppend, lEdit, oBtnSaveLine, oGetLote, oGetCodPrp1, oGetCodPrp2, oGetValPrp1, oGetValPrp2, oGetFecCad )

	local oDlg
   local oBtn
	local oBrw
   local oFont
	local aGet1
	local cGet1
   local nOrd           := GetBrwOpt( "BrwArticulo" )
   local nLevel         := nLevelUsr( "01014" )
   local oCbxOrd
   local cCbxOrd
   local aCbxOrd        := { "Código", "Nombre", "Proveedor" }
   local Ordenes        := { "CODOBS", "NOMOBS", "CPRVHAB" }
   local oSayText
   local cSayText       := "Listado de artículos"
   local oBmpImage
   local oBrwStock
   local cTxtOrigen     := ""
   local lCloseFiles    := .f.
   local oTreeInfo
   local oImageListInfo
   local nRecAnt
   local cReturn        := Space( 18 )
   local lPropiedades   := .f.
   local oBtnAceptarPropiedades

   nOrd                 := Min( Max( nOrd, 1 ), len( aCbxOrd ) )

   cCbxOrd              := aCbxOrd[ nOrd ]

   DEFAULT lCodeBar     := .f.
   DEFAULT lAppend      := .t.
   DEFAULT lEdit        := .t.

   if !lOpenFiles

      lCloseFiles       := .t.

      if !OpenFiles( .t. )
         return nil
      end if

   else

      nRecAnt           := ( dbfArticulo )->( Recno() )

   end if

   if !Empty( oGetCodigo )
      cTxtOrigen        := oGetCodigo:VarGet()
   end if

   /*
   Origen de busqueda----------------------------------------------------------
   */

   if !Empty( cTxtOrigen ) .and. !( dbfArticulo )->( dbSeek( cTxtOrigen ) )
      ( dbfArticulo )->( OrdSetFocus( Ordenes[ nOrd ] ) )
      ( dbfArticulo )->( dbGoTop() )
   else
      ( dbfArticulo )->( OrdSetFocus( Ordenes[ nOrd ] ) )
   end if

   /*
   Distintas cajas de dialogo--------------------------------------------------
   */

   if IsReport()
      DEFINE DIALOG oDlg RESOURCE "HELPENTRY"            TITLE "Seleccionar artículos"
   else
      if !uFieldEmpresa( "lNStkAct" )
         DEFINE DIALOG oDlg RESOURCE "HELPENTRYDUPSTK"   TITLE "Seleccionar artículos"
      else
         DEFINE DIALOG oDlg RESOURCE "HELPENTRYDUP"      TITLE "Seleccionar artículos"
      end if
   end if

		REDEFINE GET aGet1 VAR cGet1;
			ID 		   104 ;
			PICTURE	   "@!" ;
         ON CHANGE   ( SpecialSeek( nKey, nFlags, aGet1, oBrw, oCbxOrd, dbfArticulo, dbfCodebar ) );
         VALID       ( OrdClearScope( oBrw, dbfArticulo ) );
			OF 		   oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		   cCbxOrd ;
			ID 		   102 ;
         ITEMS       aCbxOrd ;
         ON CHANGE   ( ( dbfArticulo)->( OrdSetFocus( Ordenes[ oCbxOrd:nAt ] ) ), ( dbfArticulo )->( dbGoTop() ), oBrw:refresh(), aGet1:SetFocus(), oCbxOrd:refresh() ) ;
         OF          oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfArticulo
      oBrw:nMarqueeStyle   := 6
      oBrw:cName           := "Browse.Artículos selección"
      oBrw:Cargo           := {}

      with object ( oBrw:AddCol() )
         :cHeader          := "Seleccionando"
         :bEditValue       := {|| aScan( oBrw:Cargo, Eval( oBrw:bBookMark ) ) > 0 }
         :nWidth           := 20
         :SetCheck( { "Send", "Nil16" }, {|| SelectArticulo( oBrw ) } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "CodObs"
         :bEditValue       := {|| if( lCodeBar, ( dbfArticulo )->CodeBar, ( dbfArticulo )->Codigo ) }
         :nWidth           := 90
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "NomObs"
         :bEditValue       := {|| ( dbfArticulo )->Nombre }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| AllTrim( oRetFld( ( dbfArticulo )->cCodTip, oTipart:oDbf ) ) }
         :nWidth           := 150
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Proveedor"
         :bEditValue       := {|| if( !Empty( ( dbfArticulo )->cPrvHab ), AllTrim( ( dbfArticulo )->cPrvHab ) + " - " + RetProvee( ( dbfArticulo )->cPrvHab, dbfProv ), "" ) }
         :nWidth           := 220
         :lHide            := .t.
         :cSortOrder       := "cPrvHab"
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" ) + " " + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 2, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" ) + " " + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 2, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 3, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" ) + " " + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 3, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 4, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" ) + " " + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 4, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 5, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" ) + " " + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 5, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 6, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" ) + " " + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 6, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      if ( oUser():lCostos() )

      with object ( oBrw:AddCol() )
         :cHeader          := "Costo"
         :bStrData         := {|| nCosto( nil, dbfArticulo, dbfArtKit, .t., if( lEuro, cDivChg(), cDivEmp() ), dbfDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      end if

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      if !IsReport() .and. !uFieldEmpresa( "lNStkAct" )
         oBrw:bChange      := {|| ChangeBrwArt( oBrwStock, oBmpImage, oBrw ) }
      end if

      if !IsReport()

         /*
         Imagen-------------------------------------------------------------------
         */

         REDEFINE IMAGE oBmpImage ;
            ID       300 ;
            OF       oDlg

         oBmpImage:SetColor( , GetSysColor( 15 ) )

         oBmpImage:bLClicked  := {|| ShowImage( oBmpImage ) }
         oBmpImage:bRClicked  := {|| ShowImage( oBmpImage ) }

         /*
         Stock--------------------------------------------------------------------
         */

         if !uFieldEmpresa( "lNStkAct" )

            oBrwStock                        := IXBrowse():New( oDlg )

            oBrwStock:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
            oBrwStock:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

            oBrwStock:lFooter                := .t.
            oBrwStock:lHScroll               := .f.
            oBrwStock:nMarqueeStyle          := 5
            oBrwStock:cName                  := "Browse.Artículos.Stock"
            oBrwStock:lRecordSelector        := .f.

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Código"
               :cOrder              := "Código"
               :nWidth              := 40
               :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cCodigoAlmacen, "" ) }
               :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | cOrdenColumnaBrw( oCol, oBrwStock ) }
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Almacén"
               :nWidth              := 120
               :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), RetAlmacen( oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cCodigoAlmacen, dbfAlmT ), "" ) }
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Prop. 1"
               :nWidth              := 40
               :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cValorPropiedad1, "" ) }
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Prop. 2"
               :nWidth              := 40
               :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cValorPropiedad2, "" ) }
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Lote"
               :nWidth              := 60
               :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cLote, "" ) }
               :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | cOrdenColumnaBrw( oCol, oBrwStock ) }
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Caducidad"
               :nWidth              := 60
               :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:dFechaCaducidad, "" ) }
               :lHide               := .t.
               :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | cOrdenColumnaBrw( oCol, oBrwStock ) }
            end with

            /*with object ( oBrwStock:AddCol() )
               :cHeader             := "Num. serie"
               :nWidth              := 60
               :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cNumeroSerie, "" ) }
               :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | cOrdenColumnaBrw( oCol, oBrwStock ) }
            end with*/

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Unidades"
               :nWidth              := 80
               :bEditValue          := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nUnidades, 0 ) }
               :bFooter             := {|| nStockUnidades( oBrwStock ) }
               :cEditPicture        := MasUnd()
               :nDataStrAlign       := AL_RIGHT
               :nHeadStrAlign       := AL_RIGHT
               :nFootStrAlign       := AL_RIGHT
               :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | cOrdenColumnaBrw( oCol, oBrwStock ) }
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Pdt. recibir"
               :bEditValue          := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nPendientesRecibir, 0 ) }
               :bFooter             := {|| nStockPendiente( oBrwStock ) }
               :nWidth              := 70
               :cEditPicture        := cPicUnd
               :nDataStrAlign       := AL_RIGHT
               :nHeadStrAlign       := AL_RIGHT
               :nFootStrAlign       := AL_RIGHT
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Pdt. entregar"
               :bEditValue          := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nPendientesEntregar, 0 ) }
               :bFooter             := {|| nStockEntregar( oBrwStock ) }
               :nWidth              := 70
               :cEditPicture        := cPicUnd
               :nDataStrAlign       := AL_RIGHT
               :nHeadStrAlign       := AL_RIGHT
               :nFootStrAlign       := AL_RIGHT
            end with

            oBrwStock:SetArray( oStock:aStocks, .t., , .f. )
            oBrwStock:CreateFromResource( 320 )

         end if

      end if

   if !IsReport() .and. !uFieldEmpresa( "lNStkAct" )
   
      REDEFINE BUTTON oBtnAceptarpropiedades ;
         ID       550 ;
			OF 		oDlg ;
         ACTION   ( lPropiedades   := .t., if( lPresaveBrwSelArticulo( oBrwStock, ( dbfArticulo )->lMsgVta ), oDlg:end( IDOK ), ) )

   end if

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. lAppend .and. !IsReport() );
         ACTION   ( WinAppRec( oBrw, bEdit, dbfArticulo ) )

   if !IsReport()

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. lAppend .and. !IsReport() );
         ACTION   ( WinDupRec( oBrw, bEdit, dbfArticulo ) )

         if lAppend
            oDlg:AddFastKey( VK_F2, {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfArticulo ), ) } )
         end if

   end if

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. lEdit .and. !IsReport() );
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfArticulo ) )

         if lEdit .and. !IsReport()
            oDlg:AddFastKey( VK_F3, {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfArticulo ), ) } )
         end if

      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F6,       {|| lPropiedades   := .t., if( lPresaveBrwSelArticulo( oBrwStock, ( dbfArticulo )->lMsgVta ), oDlg:end( IDOK ), ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

      oDlg:bStart       := {|| StartBrwSelArticulo( oGetLote, oBrw, oBrwStock, oBtnAceptarpropiedades, oBmpImage ) }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      if lCodeBar
         cReturn        := ( dbfArticulo )->CodeBar
      else
         cReturn        := ( dbfArticulo )->Codigo
      end if

      if !Empty( oGetCodigo )
         oGetCodigo:cText( Padr( cReturn, 200 ) )
      end if

      if !Empty( oGetNombre )
         oGetNombre:cText( ( dbfArticulo )->Nombre )
      end if

      if !Empty( oBrwStock )              .and.;
         lPropiedades                     .and.;
         Len(oBrwStock:aArrayData) != 0

         if !Empty( oGetLote )
            oGetLote:cText( oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cLote )
            oGetLote:lValid()
            oGetLote:Refresh()
         end if

         if !Empty( oGetCodPrp1 )
            oGetCodPrp1 := oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cCodigoPropiedad1
         end if

         if !Empty( oGetCodPrp2 )
            oGetCodPrp2 := oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cCodigoPropiedad2
         end if

         if !Empty( oGetValPrp1 )
            oGetValPrp1:cText( oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cValorPropiedad1 )
            oGetValPrp1:lValid()
            oGetValPrp1:SetFocus()
         end if

         if !Empty( oGetValPrp2 )
            oGetValPrp2:cText( oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cValorPropiedad2 )
            oGetValPrp2:lValid()
            oGetValPrp2:SetFocus()
         end if

         if !Empty( oGetFecCad )
            oGetFecCad:cText( oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:dFechaCaducidad )
         end if

      end if

   end if

   DestroyFastFilter( dbfArticulo )

   SetBrwOpt( "BrwArticulo", if( ( dbfArticulo )->( OrdSetFocus() ) == "CODOBS", 1, 2 ) )

   if !Empty( oBrw )
      oBrw:CloseData()
   end if

   if !Empty( oBrwStock )
      oBrwStock:CloseData()
   end if

   if lCloseFiles
      CloseFiles()
   else
      ( dbfArticulo )->( dbGoTo( nRecAnt ) )
   end if

   if oBmpImage != nil
      oBmpImage:End()
   end if

   if !Empty( oGetCodigo )
      oGetCodigo:SetFocus()
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//

static function lPresaveBrwSelArticulo( oBrwStock, lMsgVta )

   if lMsgVta .and. oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nUnidades < 0
      msginfo( "No hay stock suficiente para realizar la venta" )
      return .f.
   end if

return .t.

//---------------------------------------------------------------------------//

Static Function StartBrwSelArticulo( oGetLote, oBrw, oBrwStock, oBtnAceptarpropiedades, oBmpImage )

   if !Empty( oBrw )
      oBrw:Load()
   end if

   if !Empty( oBrwStock )
      oBrwStock:Load() 
   end if

   if !IsReport()
      LoadBrwArt( oBrwStock, oBmpImage )
   end if

   if !Empty( oBtnAceptarpropiedades )
      if Empty( oGetLote )
         oBtnAceptarpropiedades:Hide()
      else
         oBtnAceptarpropiedades:Show()
      end if
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

static function cOrdenColumnaBrw( oCol, oBrwStock )

   local oColumn

   if !Empty( oBrwStock )

      do case
         case AllTrim( oCol:cHeader ) == "Código"

            aSort( oBrwStock:aArrayData, , , {|x,y| x:cCodigoAlmacen < y:cCodigoAlmacen } )

            for each oColumn in oBrwStock:aCols
               oColumn:cOrder := ""
            next

            oCol:cOrder := "Código"

         case AllTrim( oCol:cHeader ) == "Lote"

            aSort( oBrwStock:aArrayData, , , {|x,y| x:cLote < y:cLote } )

            for each oColumn in oBrwStock:aCols
               oColumn:cOrder := ""
            next

            oCol:cOrder := "Lote"

         case AllTrim( oCol:cHeader ) == "Caducidad"

            aSort( oBrwStock:aArrayData, , , {|x,y| x:dFechaCaducidad < y:dFechaCaducidad } )

            for each oColumn in oBrwStock:aCols
               oColumn:cOrder := ""
            next

            oCol:cOrder := "Caducidad"

         case AllTrim( oCol:cHeader ) == "Num. serie"

            aSort( oBrwStock:aArrayData, , , {|x,y| x:cNumeroSerie < y:cNumeroSerie } )

            for each oColumn in oBrwStock:aCols
               oColumn:cOrder := ""
            next

            oCol:cOrder := "Num. serie"

         case AllTrim( oCol:cHeader ) == "Unidades"

            aSort( oBrwStock:aArrayData, , , {|x,y| x:nUnidades < y:nUnidades } )

            for each oColumn in oBrwStock:aCols
               oColumn:cOrder := ""
            next

            oCol:cOrder := "Unidades"

      end case

      oBrwStock:Refresh()

   end if

return .t.

//---------------------------------------------------------------------------//

Static Function InsertBrwSelArticulo( oGet, lCodeBar, oBtn )

   local lOk
   local cReturn

   lOk            := .t.

   if lCodeBar
      cReturn     := ( dbfArticulo )->CodeBar
   else
      cReturn     := ( dbfArticulo )->Codigo
   end if

   if !Empty( oGet )
      oGet:cText( cReturn )
      lOk         := oGet:lOldValid()
   end if

   if lOk .and. !Empty( oBtn )
      oBtn:Click()
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//


#ifndef __PDA__

Static Function ChangeBrwArt( oBrwStock, oBmpImage, oBrw )

   if !Empty( oTimerBrw )
      oTimerBrw:End()
      oTimerBrw    := nil
   endif

   oTimerBrw             := TTimer():New( 900, {|| LoadBrwArt( oBrwStock, oBmpImage ) }, )
   oTimerBrw:hWndOwner   := oBrw:hWnd
   oTimerBrw:Activate()

Return .t.

//---------------------------------------------------------------------------//

Static Function LoadBrwArt( oBrwStock, oBmpImage )

   local oBlock
   local oError

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !uFieldEmpresa( "lNStkAct" )
         if !Empty( oTimerBrw )
            oTimerBrw:End()
            oTimerBrw    := nil
         endif
      end if

      CursorWait()

      /*
      Cargamos la imagen del producto---------------------------------------------
      */

      if oBmpImage != nil
         oBmpImage:LoadBMP( cFileBmpName( ( dbfArticulo )->cImagen, .t. ) )
         oBmpImage:Refresh()
      end if

      /*
      Calculos de stocks----------------------------------------------------------
      */

      if !uFieldEmpresa( "lNStkAct" ) .and. ( ( dbfArticulo )->nCtlStock <= 1 )
         oStock:aStockArticulo( ( dbfArticulo )->Codigo, , oBrwStock )
      end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWE()

Return .t.

#endif

//---------------------------------------------------------------------------//

STATIC FUNCTION TransPrecio( nImporte, lChg )

   DEFAULT lChg   := .f.

   IF lChg
      nImporte    := nCnv2Div( nImporte, cDivEmp(), cDivChg() )
	END IF

RETURN ( Trans( nImporte, if( lChg, cPouChg, cPouDiv ) ) )

//--------------------------------------------------------------------------//

Static Function SpecialSeek( nKey, nFlags, oGet, oBrw, oCbx, dbfArticulo, dbfCodebar )

   local nRecno
   local xCadena     := ""
   local lResult     := AutoSeek( nKey, nFlags, oGet, oBrw, dbfArticulo, .t. )

   if !lResult

      nRecno         := ( dbfArticulo )->( Recno() )

#ifndef __HARBOUR__
      xCadena        := Rtrim( SubStr( oGet:varGet(), 0, oGet:nPos - 1 ) + Chr( nKey ) )
#else
      xCadena        := Rtrim( oGet:cText() )
#endif

      if dbSeekInOrd( xCadena, "CodeBar", dbfArticulo )

         lResult     := .t.

      else

         if dbSeekInOrd( xCadena, "cCodBar", dbfCodeBar )                  .and.;
            dbSeekInOrd( ( dbfCodeBar )->cCodArt, "Codigo", dbfArticulo )

            lResult  := .t.

         end if

      end if

      if !lResult
         nRecno      := ( dbfArticulo )->( dbGoTo( nRecno ) )
      end if

   end if

   if lResult
      if !Empty( oBrw:bChange )
         Eval( oBrw:bChange )
      end if
   end if

   oBrw:Refresh()

Return ( lResult )

//---------------------------------------------------------------------------//

FUNCTION RetFamArt( cCodArt, uArt )

   local oBlock
   local oError
   local lClose   := .f.
   local cTemp    := Space( 8 )

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ( uArt ) == NIL
      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @uArt ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if Valtype( uArt ) == "O"
      if uArt:Seek( cCodArt )
         cTemp    := uArt:Familia
      end if
   else
      if ( uArt )->( DbSeek( cCodArt ) )
         cTemp    := ( uArt )->Familia
      end if
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( uArt )
   end if

RETURN cTemp

//---------------------------------------------------------------------------//

//
// Devuelve si se resta stock del compuesto
//

FUNCTION lStockCompuestos( cCodArt, dbfArticulo )

   local lTmp     := .f.
   local aSta     := aGetStatus( dbfArticulo, .t. )

   if ( dbfArticulo )->( DbSeek( cCodArt ) )
      lTmp        := ( dbfArticulo )->lKitArt .and. ( dbfArticulo )->nKitStk <= KIT_COMPUESTO
   end if

   SetStatus( dbfArticulo, aSta )

RETURN ( lTmp )

//---------------------------------------------------------------------------//

//
// Devuelve si tenemos precios en el compuesto
//

FUNCTION lPreciosCompuestos( cCodArt, dbfArticulo )

   local lTmp     := .f.
   local aSta     := aGetStatus( dbfArticulo, .t. )

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      lTmp        := ( dbfArticulo )->lKitArt .and. ( dbfArticulo )->nKitPrc <= KIT_COMPUESTO
   end if

   SetStatus( dbfArticulo, aSta )

RETURN ( lTmp )

//---------------------------------------------------------------------------//
//
// Devuelve si se imprime el compuesto
//

FUNCTION lImprimirCompuesto( cCodArt, dbfArticulo )

   local lTmp     := .f.
   local aSta     := aGetStatus( dbfArticulo, .t. )

   if ( dbfArticulo )->( DbSeek( cCodArt ) )
      lTmp        := !( ( dbfArticulo )->lKitArt .and. ( dbfArticulo )->nKitImp <= KIT_COMPUESTO )
   end if

   SetStatus( dbfArticulo, aSta )

RETURN ( lTmp )

//---------------------------------------------------------------------------//
//
// Devuelve el codigo interno pasandole el codigo de barras
//

Function cSeekCodebar( cCodBar, dbfCodebar, dbfArticulo )

   local n
   local cCodigo
   local cPropiedades         := ""
   local nOrdenAnterior

   if IsObject( dbfCodebar )
      dbfCodebar              := dbfCodebar:cAlias
   end if

   if IsObject( dbfArticulo )
      dbfArticulo             := dbfArticulo:cAlias
   end if

   // Buscamos los puntos dentro del codigo------------------------------------

   n                          := At( ".", cCodBar )
   if n != 0
      cCodigo                 := SubStr( cCodBar, 1, n - 1 )
      cPropiedades            := SubStr( cCodBar, n )
   else
      cCodigo                 := cCodBar
   end if

   // Si el codigo existe como tal incluidos los puntos nos vamos--------------

   cCodigo                    := Alltrim( cCodigo )

   if dbSeekInOrd( cCodigo, "Codigo", dbfArticulo ) .or. dbSeekInOrd( Upper( cCodigo ), "Codigo", dbfArticulo )
      Return ( cCodBar )
   end if

   // Ahora buscamos en los codigos de barras----------------------------------

   nOrdenAnterior          := ( dbfCodebar )->( OrdSetFocus( "cCodBar" ) )

   if ( dbfCodebar )->( dbSeek( cCodigo ) ) .or. ( dbfCodebar )->( dbSeek( Upper( cCodigo ) ) )

      cCodigo              := ( dbfCodebar )->cCodArt

      if Empty( cPropiedades )

         if !Empty( ( dbfCodebar )->cValPr1 )
            cPropiedades   += "." + Rtrim( ( dbfCodebar )->cValPr1 )
         end if

         if !Empty( ( dbfCodebar )->cValPr2 )
            cPropiedades   += "." + Rtrim( ( dbfCodebar )->cValPr2 )
         end if

      end if

   end if

   ( dbfCodebar )->( OrdSetFocus( nOrdenAnterior ) )

   if !Empty( cPropiedades )
      cCodBar                 := Rtrim( cCodigo ) + cPropiedades
   else
      cCodBar                 := cCodigo
   end if

Return ( cCodBar )

//---------------------------------------------------------------------------//

Static Function SeekPrvArt( nKey, nFlags, oGet, oBrw, dbfArtPrv, dbfArticulo, oGetPrv )

   local nRecno      := ( dbfArticulo )->( Recno() )
   local cProvee     := oGetPrv:VarGet()
   local nOrdAnt     := ( dbfArtPrv )->( OrdSetFocus( "CREFPRV" ) )
   local lResult     := AutoSeek( nKey, nFlags, oGet, nil, dbfArtPrv, .t., cProvee )

   if lResult
      if dbSeekInOrd( ( dbfArtPrv )->cCodArt, "Codigo", dbfArticulo )
         lResult  := .t.
         oBrw:Refresh()
      end if
   else
      nRecno      := ( dbfArticulo )->( dbGoTo( nRecno ) )
   end if

   if oBrw != nil
      oBrw:Refresh()
   end if

   ( dbfArtPrv )->( OrdSetFocus( nOrdAnt ) )

Return ( lResult )

//---------------------------------------------------------------------------//

Static Function lChgOrdDbf( nOption, dbfArticulo, aCbxOrd, oCbxOrd, oBrw, oBrwPrv )

   local nOrd

   do case
      case nOption == 1

         SetBrwOpt( "BrwArticulo", ( dbfArticulo )->( OrdNumber() ) )
         ( dbfArticulo )->( OrdSetFocus( "Codigo" ) )
         ( dbfArticulo )->( dbGoTop() )

         oBrwPrv:Refresh()

      case nOption == 2

         nOrd        := Min( Max( GetBrwOpt( "BrwArticulo" ), 1 ), len( aCbxOrd ) )
         oCbxOrd:nAt := nOrd

         ( dbfArticulo )->( OrdSetFocus( nOrd ) )
         ( dbfArticulo )->( dbGoTop() )

         oBrw:Refresh()

   end case

Return ( .t. )

//---------------------------------------------------------------------------//

FUNCTION retArticulo( cCodArt, dbfArticulo )

   local oBlock
   local oError
   local nRecno
   local lClose   := .f.
	local cTemp		:= Space( 30 )

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if empty( dbfArticulo ) 
      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if IsObject( dbfArticulo )
      nRecno      := dbfArticulo:Recno()
      if dbfArticulo:Seek( cCodArt )
         cTemp    := Rtrim( dbfArticulo:Nombre )
      end if
      dbfArticulo:GoTo( nRecno )
   else
      nRecno      := ( dbfArticulo )->( Recno() )
      if ( dbfArticulo )->( dbSeek( cCodArt ) )
         cTemp    := Rtrim( ( dbfArticulo )->Nombre )
      end if 
      ( dbfArticulo )->( dbGoTo( nRecno ) )
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de articulos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfArticulo )
   end if

RETURN ( cTemp )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifndef __PDA__

//---------------------------------------------------------------------------//

#include "FastRepH.ch"

Static Function DataReport( oFr, lTemporal )

   local oError
   local oBlock

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   if lTemporal
      oFr:SetWorkArea(  "Artículos", ( tmpArticulo )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   else
      oFr:SetWorkArea(  "Artículos", ( dbfArticulo )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   end if
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Familias", ( dbfFam )->( Select() ) )
   oFr:SetFieldAliases( "Familias", cItemsToReport( aItmFam() ) )

   oFr:SetWorkArea(     "Categoria", ( dbfCategoria )->( Select() ) )
   oFr:SetFieldAliases( "Categoria", cItemsToReport( aItmCategoria() ) )

   oFr:SetWorkArea(     "Ofertas", ( dbfOfe )->( Select() ) )
   oFr:SetFieldAliases( "Ofertas", cItemsToReport( aItmOfe() ) )

   oFr:SetWorkArea(     "Temporada", ( dbfTemporada )->( Select() ) )
   oFr:SetFieldAliases( "Temporada", cItemsToReport( aItmTemporada() ) )

   oFr:SetWorkArea(     "Códigos de barras", ( dbfCodebar )->( Select() ) )
   oFr:SetFieldAliases( "Códigos de barras", cItemsToReport( aItmBar() ) )

   oFr:SetWorkArea(     "Tipo artículo",  oTipArt:Select() )
   oFr:SetFieldAliases( "Tipo artículo",  cObjectsToReport( oTipArt:oDbf ) )

   oFr:SetWorkArea(     "Fabricante",  oFabricante:Select() )
   oFr:SetFieldAliases( "Fabricante",  cObjectsToReport( oFabricante:oDbf ) )

   oFr:SetWorkArea(     "Unidad de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidad de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( dbfArtVta )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   if lTemporal
      oFr:SetMasterDetail( "Artículos",   "Precios por propiedades", {|| ( tmpArticulo )->Codigo + ( tmpArticulo )->cCodPrp1 + ( tmpArticulo )->cCodPrp2 + ( tmpArticulo )->cValPrp1 + ( tmpArticulo )->cValPrp2 } )
      oFr:SetMasterDetail( "Artículos",   "Ofertas",                 {|| ( tmpArticulo )->Codigo + ( tmpArticulo )->cCodPrp1 + ( tmpArticulo )->cCodPrp2 + ( tmpArticulo )->cValPrp1 + ( tmpArticulo )->cValPrp2 } )
      oFr:SetMasterDetail( "Artículos",   "Familias",                {|| ( tmpArticulo )->Familia } )
      oFr:SetMasterDetail( "Artículos",   "Categoria",               {|| ( tmpArticulo )->cCodCate } )
      oFr:SetMasterDetail( "Artículos",   "Temporada",               {|| ( tmpArticulo )->cCodTemp } )
      oFr:SetMasterDetail( "Artículos",   "Tipo artículo",           {|| ( tmpArticulo )->cCodTip } )
      oFr:SetMasterDetail( "Artículos",   "Fabricante",              {|| ( tmpArticulo )->cCodFab } )
      oFr:SetMasterDetail( "Artículos",   "Unidad de medición",      {|| ( tmpArticulo )->cUnidad } )
      oFr:SetMasterDetail( "Artículos",   "Códigos de barras",       {|| ( tmpArticulo )->Codigo } )
   else
      oFr:SetMasterDetail( "Artículos",   "Precios por propiedades", {|| ( dbfArticulo )->Codigo + ( dbfArticulo )->cCodPrp1 + ( dbfArticulo )->cCodPrp2 + ( dbfArticulo )->cValPrp1 + ( dbfArticulo )->cValPrp2 } )
      oFr:SetMasterDetail( "Artículos",   "Ofertas",                 {|| ( dbfArticulo )->Codigo + ( dbfArticulo )->cCodPrp1 + ( dbfArticulo )->cCodPrp2 + ( dbfArticulo )->cValPrp1 + ( dbfArticulo )->cValPrp2 } )
      oFr:SetMasterDetail( "Artículos",   "Familias",                {|| ( dbfArticulo )->Familia } )
      oFr:SetMasterDetail( "Artículos",   "Categoria",               {|| ( dbfArticulo )->cCodCate } )
      oFr:SetMasterDetail( "Artículos",   "Temporada",               {|| ( dbfArticulo )->cCodTemp } )
      oFr:SetMasterDetail( "Artículos",   "Tipo artículo",           {|| ( dbfArticulo )->cCodTip } )
      oFr:SetMasterDetail( "Artículos",   "Fabricante",              {|| ( dbfArticulo )->cCodFab } )
      oFr:SetMasterDetail( "Artículos",   "Unidad de medición",      {|| ( dbfArticulo )->cUnidad } )
      oFr:SetMasterDetail( "Artículos",   "Códigos de barras",       {|| ( dbfArticulo )->Codigo } )
   end if

   oFr:SetResyncPair(      "Artículos",   "Precios por propiedades" )
   oFr:SetResyncPair(      "Artículos",   "Ofertas" )
   oFr:SetResyncPair(      "Artículos",   "Familias" )
   oFr:SetResyncPair(      "Artículos",   "Categoria" )
   oFr:SetResyncPair(      "Artículos",   "Temporada" )
   oFr:SetResyncPair(      "Artículos",   "Tipo artículo" )
   oFr:SetResyncPair(      "Artículos",   "Fabricante" )
   oFr:SetResyncPair(      "Artículos",   "Unidad de medición" )
   oFr:SetResyncPair(      "Artículos",   "Códigos de barras" )

   RECOVER USING oError

      msgStop( "Imposible crear data report" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Artículos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Artículos",            "Código de barras para primera propiedad",   "CallHbFunc('cArtBarPrp1')" )
   oFr:AddVariable(     "Artículos",            "Código de barras para segunda propiedad",   "CallHbFunc('cArtBarPrp2')" )
   oFr:AddVariable(     "Artículos",            "Nombre primera propiedad",                  "CallHbFunc('cNomValPrp1Art')" )
   oFr:AddVariable(     "Artículos",            "Nombre segunda propiedad",                  "CallHbFunc('cNomValPrp2Art')" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportArticulo( oFr, dbfDoc )

   local oLabel
   local nOrdAnt
   local lOpen    := .f.
   local lFlag    := .f.

   /*
   Tratamiento para no hacer dos veces el openfiles al editar el documento en imprimir series
   */

   if lOpenFiles
      lFlag       := .t.
   else
      if Openfiles()
         lFlag    := .t.
         lOpen    := .t.
      else
         lFlag    := .f.
      end if
   end if

   nOrdAnt        := ( dbfArticulo )->( OrdSetFocus( "Cod" ) )

   if lFlag

      oLabel      := TArticuloLabelGenerator()

      if oLabel:lCreateTemporal()

         /*
         Zona de datos------------------------------------------------------------
         */

         DataReport( oFr, .t. )

         /*
         Paginas y bandas---------------------------------------------------------
         */

         if !Empty( ( dbfDoc )->mReport )

            oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

         else

            oFr:AddPage(         "MainPage" )

            oFr:AddBand(         "CabeceraColumnas",  "MainPage",       frxMasterData )
            oFr:SetProperty(     "CabeceraColumnas",  "Top",            200 )
            oFr:SetProperty(     "CabeceraColumnas",  "Height",         100 )
            oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet",        "Artículos" )

         end if

         /*
         Zona de variables--------------------------------------------------------
         */

         VariableReport( oFr )

         /*
         Diseño de report---------------------------------------------------------
         */

         oFr:DesignReport()

         /*
         Destruye el diseñador----------------------------------------------------
         */

         oFr:DestroyFr()

         /*
         Cierra ficheros----------------------------------------------------------
         */

         oLabel:DestroyTemporal()

      else

         lFlag    := .f.

      end if

   end if

   if lOpen
      CloseFiles()
   end if

Return ( lFlag )

//---------------------------------------------------------------------------//

Function PrintReportArticulo( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()

   SysRefresh()

   oFr                  := frReportManager():New()

   oFr:LoadLangRes(     "Spanish.Xml" )

   oFr:SetIcon( 1 )

   oFr:SetTitle(        "Diseñador de documentos" )

   /*
   Manejador de eventos--------------------------------------------------------
   */

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos------------------------------------------------------------
   */

   DataReport( oFr, .t. )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Preparar el report-------------------------------------------------------
      */

      oFr:PrepareReport()

      /*
      Imprimir el informe------------------------------------------------------
      */

      do case
         case nDevice == IS_SCREEN

            oFr:ShowPreparedReport()

         case nDevice == IS_PRINTER

            oFr:PrintOptions:SetPrinter( cPrinter )
            oFr:PrintOptions:SetCopies( nCopies )
            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:Print()

         case nDevice == IS_PDF

            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:DoExport(     "PDFExport" )

      end case

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

Return .t.

//---------------------------------------------------------------------------//

#ifndef __PDA__

Static Function dlgToolTip( cCodArt, oBrw )

   local oBmpImage
   local oBrwStock
   local oTreeInfo
   local oImageListInfo
   local oDlgToolTip

   /*
   Dialogo---------------------------------------------------------------------
   */

   DEFINE DIALOG oDlgToolTip RESOURCE "ArtToolTip" OF oBrw

      /*
      Imagen del producto------------------------------------------------------
      */

      REDEFINE IMAGE oBmpImage ;
         ID       110 ;
         OF       oDlgToolTip ;
         FILE     cFileBmpName( ( dbfArticulo )->cImagen, .t. )

      oBmpImage:SetColor( , GetSysColor( 15 ) )

      oBmpImage:bLClicked              := {|| ShowImage( oBmpImage ) }
      oBmpImage:bRClicked              := {|| ShowImage( oBmpImage ) }

      /*
      Arbol con información del producto---------------------------------------
      */

      oTreeInfo                        := TTreeView():Redefine( 120, oDlgToolTip )

      oImageListInfo                   := TImageList():New( 16, 16 )

      oImageListInfo:AddMasked( TBitmap():Define( "Cube_yellow_16" ),   Rgb( 255, 0, 255 ) )
      oImageListInfo:AddMasked( TBitmap():Define( "Star_Red_16" ),      Rgb( 255, 0, 255 ) )
      oImageListInfo:AddMasked( TBitmap():Define( "Calendar_16" ),      Rgb( 255, 0, 255 ) )

      /*
      Stock--------------------------------------------------------------------
      */

      oBrwStock                        := IXBrowse():New( oDlgToolTip )

      oBrwStock:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwStock:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwStock:SetArray( oStock:aStocks, , , .f. )

      oBrwStock:lFooter                := .t.
      oBrwStock:lHScroll               := .f.
      oBrwStock:nMarqueeStyle          := 5
      oBrwStock:cName                  := "Tooltip artículos"
      oBrwStock:lRecordSelector        := .f.

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Código"
         :nWidth              := 40
         :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cCodigoAlmacen, "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Almacén"
         :nWidth              := 120
         :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), RetAlmacen( oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cCodigoAlmacen, dbfAlmT ), "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Prop. 1"
         :nWidth              := 40
         :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cValorPropiedad1, "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Prop. 2"
         :nWidth              := 40
         :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cValorPropiedad2, "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Lote"
         :nWidth              := 60
         :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cLote, "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Num. serie"
         :nWidth              := 60
         :bStrData            := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cNumeroSerie, "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Unidades"
         :nWidth              := 80
         :bEditValue          := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nUnidades, 0 ) }
         :bFooter             := {|| nStockUnidades( oBrwStock ) }
         :cEditPicture        := MasUnd()
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Pdt. recibir"
         :bEditValue          := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nPendientesRecibir, 0 ) }
         :bFooter             := {|| nStockPendiente( oBrwStock ) }
         :nWidth              := 70
         :cEditPicture        := cPicUnd
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Pdt. entregar"
         :bEditValue          := {|| if( !Empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nPendientesEntregar, 0 ) }
         :bFooter             := {|| nStockEntregar( oBrwStock ) }
         :nWidth              := 70
         :cEditPicture        := cPicUnd
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
      end with

      oBrwStock:CreateFromResource( 100 )

   oDlgToolTip:bStart   := {|| startToolTip( cCodArt, oBrwStock, oTreeInfo, oImageListInfo ) }

Return ( oDlgToolTip )

//---------------------------------------------------------------------------//

Static Function startToolTip( cCodArt, oBrwStock, oTreeInfo, oImageListInfo )

   CursorWait()

   oTreeInfo:SetImageList( oImageListInfo )

   switch ( nTipoOferta() )
      case 1
         oTreeInfo:Add( "Artículo actualmente en oferta por importes.", 1 )
      case 2
         oTreeInfo:Add( "Artículo actualmente en oferta de tipo X*Y.", 1 )
   end

   oTreeInfo:Add( "Fecha de creación " + Dtoc( ( dbfArticulo )->LastChg ), 2 )

   if !Empty( ( dbfArticulo )->dFecChg )
      oTreeInfo:Add( "Última modificación " + Dtoc( ( dbfArticulo )->dFecChg ), 2 )
   end if

   /*
   Calculos de stocks----------------------------------------------------------
   */

   if ( ( dbfArticulo )->nCtlStock <= 1 )

      oStock:aStockArticulo( cCodArt, , oBrwStock )

      /*
      Aviso de stock bajo minimo--------------------------------------------------
      */

      if ( dbfArticulo )->nMinimo > nStockUnidades( oBrwStock )
         oTreeInfo:Add( "Stock bajo minimos, stock actual " + Alltrim( Trans( nStockUnidades( oBrwStock ), MasUnd() ) ) + "; minimo " + Alltrim( Trans( ( dbfArticulo )->nMinimo, MasUnd() ) ) + "." , 0 )
      end if

   end if

   CursorWE()

Return nil

//---------------------------------------------------------------------------//

Static Function nTipoOferta()

   local nOferta     := 0

   if ( dbfOfe )->( dbSeek( ( dbfArticulo )->Codigo ) )

      while ( dbfOfe )->cArtOfe == ( dbfArticulo )->Codigo .and. !( dbfOfe )->( eof() )

			/*
         Comprobamos si esta entre las fechas----------------------------------
			*/

         if ( GetSysDate() >= ( dbfOfe )->dIniOfe .or. Empty( ( dbfOfe )->dIniOfe ) ) .and. ;
            ( GetSysDate() <= ( dbfOfe )->dFinOfe .or. Empty( ( dbfOfe )->dFinOfe ) )

            nOferta  := ( dbfOfe )->nTipOfe

            exit

         end if

         ( dbfOfe )->( dbSkip() )

      end do

   end if

Return ( nOferta )

//---------------------------------------------------------------------------//

Static Function ChangePosition( lInc )

   local aPos
   local nPos     := 1
   local aRec     := {}
   local nRec     := ( dbfArticulo )->( Recno() )
   local nOrd     := ( dbfArticulo )->( OrdSetFocus( "nPosTpv" ) )
   local cFam     := ( dbfArticulo )->Familia

   CursorWait()

   do case
      case IsTrue( lInc )

         if ( dbfArticulo )->( dbRLock() )
            ( dbfArticulo )->nPosTpv   := ( dbfArticulo )->nPosTpv + 1.5
         end if
         ( dbfArticulo )->( dbUnLock() )

      case IsFalse( lInc )

         if ( dbfArticulo )->( dbRLock() )
            ( dbfArticulo )->nPosTpv   := ( dbfArticulo )->nPosTpv - 1.5
         end if
         ( dbfArticulo )->( dbUnLock() )

   end case

   //--------------------------------------------------------------------------

   ( dbfArticulo )->( dbGoTop() )
   while !( dbfArticulo )->( eof() )

      if cFam == ( dbfArticulo )->Familia .and. ( dbfArticulo )->lIncTcl
         aAdd( aRec, { ( dbfArticulo )->( Recno() ), nPos++ } )
      end if

      ( dbfArticulo )->( dbSkip() )

   end while

   //--------------------------------------------------------------------------

   for each aPos in aRec

      ( dbfArticulo )->( dbGoTo( aPos[ 1 ] ) )

      if ( dbfArticulo )->( dbRLock() )
         ( dbfArticulo )->nPosTpv      := aPos[ 2 ]
         ( dbfArticulo )->( dbUnLock() )
      end if

   next

   //--------------------------------------------------------------------------

   CursorWE()

   ( dbfArticulo )->( dbGoTo( nRec ) )
   ( dbfArticulo )->( OrdSetFocus( nOrd ) )

Return ( nil )

//---------------------------------------------------------------------------//

Function ChangePublicar( aTmp )

   local nRec

   if Empty( aTmp )

      for each nRec in ( oWndBrw:oBrw:aSelected )

         ( dbfArticulo )->( dbGoTo( nRec ) )

         if ( dbfArticulo )->( dbRLock() )
            ( dbfArticulo )->lPubInt   := !( dbfArticulo )->lPubInt
            ( dbfArticulo )->lSndDoc   := ( dbfArticulo )->lPubInt
            ( dbfArticulo )->( dbCommit() )
            ( dbfArticulo )->( dbUnLock() )
         end if

         if ( dbfArticulo )->lPubInt
            ChangeFamiliaInt(       ( dbfArticulo )->Familia   )
            ChangePropiedadesInt(   ( dbfArticulo )->cCodPrp1  )
            ChangePropiedadesInt(   ( dbfArticulo )->cCodPrp2  )
            ChangeFabricantesInt(   ( dbfArticulo )->cCodFab   )
            ChangeTipArtInt(        ( dbfArticulo )->cCodTip   )
         end if

      next

   else

      if aTmp[ ( dbfArticulo )->( fieldpos( "lPubInt" ) ) ]
         ChangeFamiliaInt(       aTmp[ ( dbfArticulo )->( fieldpos( "Familia"  ) ) ] )
         ChangePropiedadesInt(   aTmp[ ( dbfArticulo )->( fieldpos( "cCodPrp1" ) ) ] )
         ChangePropiedadesInt(   aTmp[ ( dbfArticulo )->( fieldpos( "cCodPrp2" ) ) ] )
         ChangeFabricantesInt(   aTmp[ ( dbfArticulo )->( fieldpos( "cCodFab"  ) ) ] )
         ChangeTipArtInt(        aTmp[ ( dbfArticulo )->( fieldpos( "cCodTip"  ) ) ] )
      end if

   end if

   if !Empty( oWndBrw )
      oWndBrw:Refresh( .t. )
   end if

Return nil

//---------------------------------------------------------------------------//

static function ChangeFamiliaInt( cCodFam )

   local nRec

   if !Empty( cCodFam )

      nRec  := ( dbfFam )->( Recno() )

      if dbSeekInOrd( cCodFam, "CCODFAM", dbfFam )

         if ( dbfFam )->( dbRLock() )
            ( dbfFam )->lPubInt   := .t.
            ( dbfFam )->lSelDoc   := .t.
            ( dbfFam )->( dbCommit() )
            ( dbfFam )->( dbUnLock() )
         end if

         if !Empty( ( dbfFam )->cCodGrp )
            ChangeGrpFamInt( ( dbfFam )->cCodGrp )
         end if

      end if

      ( dbfFam )->( dbGoto( nRec ) )

   end if

return nil

//---------------------------------------------------------------------------//
static function ChangePropiedadesInt( cCodPro )

   local nRec

   if !Empty( cCodPro )

      nRec  := ( dbfPro )->( Recno() )

      if dbSeekInOrd( cCodPro, "CCODPRO", dbfPro )

         if ( dbfPro )->( dbRLock() )
            ( dbfPro )->lPubInt   := .t.
            ( dbfPro )->lSndDoc   := .t.
            ( dbfPro )->( dbCommit() )
            ( dbfPro )->( dbUnLock() )
         end if

      end if

      ( dbfPro )->( dbGoto( nRec ) )

   end if

return nil

//---------------------------------------------------------------------------//
static function ChangeFabricantesInt( cCodFab )

   local nRec

   if !Empty( cCodFab )

      nRec  := oFabricante:oDbf:Recno()

      if oFabricante:oDbf:SeekInOrd( cCodFab, "CCODFAB" )

         oFabricante:oDbf:Load()
         oFabricante:oDbf:lPubInt   := .t.
         oFabricante:oDbf:lSndDoc   := .t.
         oFabricante:oDbf:Save()

      end if

      oFabricante:oDbf:GoTo( nRec )

   end if

return nil

//---------------------------------------------------------------------------//
static function ChangeTipArtInt( cCodTip )

   local nRec

   if !Empty( cCodTip )

      nRec  := oTipart:oDbf:Recno()

      if oTipart:oDbf:SeekInOrd( cCodTip, "CCODTIP" )

         oTipart:oDbf:Load()
         oTipart:oDbf:lPubInt   := .t.
         oTipart:oDbf:lSelect   := .t.
         oTipart:oDbf:Save()

      end if

      oTipart:oDbf:GoTo( nRec )

   end if

return nil

//---------------------------------------------------------------------------//
static function ChangeGrpFamInt( cCodGrp )

   local nRec

   if !Empty( cCodGrp )

      nRec  := oGrpFam:oDbf:Recno()

      if oGrpFam:oDbf:SeekInOrd( cCodGrp, "CCODGRP" )

         oGrpFam:oDbf:Load()
         oGrpFam:oDbf:lPubInt   := .t.
         oGrpFam:oDbf:lSndDoc   := .t.
         oGrpFam:oDbf:Save()

      end if

      oGrpFam:oDbf:GoTo( nRec )

   end if

return nil

//---------------------------------------------------------------------------//

Function ChangelSndDoc( aTmp )

   local nRec

   for each nRec in ( oWndBrw:oBrw:aSelected )

      ( dbfArticulo )->( dbGoTo( nRec ) )

      if ( dbfArticulo )->( dbRLock() )
         ( dbfArticulo )->lSndDoc   := !( dbfArticulo )->lSndDoc
         ( dbfArticulo )->( dbCommit() )
         ( dbfArticulo )->( dbUnLock() )
      end if

   next

   oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

#endif

function dFechaCaducidad( dFechaDocumento, nDiasCaducidad, nTipoPeriodo )

   local dFecCad

   do case

      case  nTipoPeriodo <= 1

         dFecCad  := dFechaDocumento + nDiasCaducidad

      case  nTipoPeriodo == 2

         dFecCad  := dFechaDocumento + ( nDiasCaducidad * 30 )

      case  nTipoPeriodo == 3

         dFecCad  := dFechaDocumento + ( nDiasCaducidad * 365 )

   end case

return ( dFecCad )

//---------------------------------------------------------------------------//

Function nStockBrowse( oBrwStock, nPos )

   local nStock   := 0

   DEFAULT nPos   := 6

   if !Empty( oBrwStock ) .and. !Empty( oBrwStock:aArrayData )
      aEval( oBrwStock:aArrayData, {|a| nStock += a[ nPos ] } )
   end if

Return ( nStock )

//---------------------------------------------------------------------------//

Function nStockUnidades( oBrwStock )

   local nStock   := 0

   if !Empty( oBrwStock ) .and. !Empty( oBrwStock:aArrayData )
      aEval( oBrwStock:aArrayData, {|a| nStock += a:nUnidades } )
   end if

Return ( nStock )

//---------------------------------------------------------------------------//

Function nStockPendiente( oBrwStock )

   local nStock   := 0

   if !Empty( oBrwStock ) .and. !Empty( oBrwStock:aArrayData )
      aEval( oBrwStock:aArrayData, {|a| nStock += a:nPendientesRecibir } )
   end if

Return ( nStock )

//---------------------------------------------------------------------------//

Function nStockEntregar( oBrwStock )

   local nStock   := 0

   if !Empty( oBrwStock ) .and. !Empty( oBrwStock:aArrayData )
      aEval( oBrwStock:aArrayData, {|a| nStock += a:nPendientesEntregar } )
   end if

Return ( nStock )

//---------------------------------------------------------------------------//

FUNCTION cArtBarPrp1( uArt, uTblPro )

   local cBarPrp1    := ""

   DEFAULT uArt      := if( !Empty( tmpArticulo ), tmpArticulo, dbfArticulo )
   DEFAULT uTblPro   := dbfTblPro

   if dbSeekInOrd( ( uArt )->cCodPrp1 + ( uArt )->cValPrp1, "cCodPro", uTblPro )
      cBarPrp1       := ( uTblPro )->nBarTbl
   end if

RETURN ( cBarPrp1 )

//---------------------------------------------------------------------------//

FUNCTION cArtBarPrp2( uArt, uTblPro )

   local cBarPrp2    := ""

   DEFAULT uArt      := if( !Empty( tmpArticulo ), tmpArticulo, dbfArticulo )
   DEFAULT uTblPro   := dbfTblPro

   if dbSeekInOrd( ( uArt )->cCodPrp2 + ( uArt )->cValPrp2, "cCodPro", uTblPro )
      cBarPrp2       := ( uTblPro )->nBarTbl
   end if

RETURN ( cBarPrp2 )

//---------------------------------------------------------------------------//

Static Function SelectArticulo( oBrw )

   local nScan
   local uBook := Eval( oBrw:bBookMark )

   nScan       := aScan( oBrw:Cargo, uBook )
   if nScan == 0
      aAdd( oBrw:Cargo, uBook )
   else
      aDel( oBrw:Cargo, nScan, .t. )
   end if

Return nil

//---------------------------------------------------------------------------//

Static Function EdtImg( aTmp, aGet, dbfTmpImg, oBrw, aArt, bValid, nMode )

   local oDlg
   local oFld
   local oImgArt
   local oImgBmp

   /*
   Control para que la primera imagen que metamos se ponga por defecto---------
   */

   if nMode == APPD_MODE

      ( dbfTmpImg )->( dbGoTop() )
      if ( dbfTmpImg )->( Eof() )
         aTmp[ ( dbfTmpImg )->( FieldPos( "lDefImg" ) ) ]   := .t.
      end if

   end if

   DEFINE DIALOG oDlg RESOURCE "Imagenes" TITLE LblTitle( nMode ) + "imagenes de artículos"

      REDEFINE FOLDER oFld;
         ID       100 ;
         OF       oDlg ;
         PROMPT   "&Principal",;
                  "&HTML" ;
         DIALOGS  "Imagenes_1",;
                  "Imagenes_2"

      REDEFINE GET oImgArt ;
         VAR      aTmp[ ( dbfTmpImg )->( FieldPos( "cImgArt" ) ) ] ;
         ID       100 ;
         BITMAP   "Lupa" ;
         ON HELP  ( GetBmp( oImgArt, oImgBmp ) ) ;
         ON CHANGE( ChgBmp( oImgArt, oImgBmp ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aTmp[ ( dbfTmpImg )->( FieldPos( "cNbrArt" ) ) ] ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE CHECKBOX aTmp[ ( dbfTmpImg )->( fieldpos( "lDefImg" ) ) ] ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE .and. !aTmp[ ( dbfTmpImg )->( FieldPos( "lDefImg" ) ) ] ) ;
         OF       fldGeneral

      REDEFINE IMAGE oImgBmp ADJUST ;
         ID       110 ;
         OF       fldGeneral ;
         FILE     cFileBmpName( aTmp[ ( dbfTmpImg )->( FieldPos( "cImgArt" ) ) ] )

      oImgBmp:SetColor( , GetSysColor( 15 ) )
      oImgBmp:bLClicked := {|| ShowImage( oImgBmp ) }
      oImgBmp:bRClicked := {|| ShowImage( oImgBmp ) }

      REDEFINE BUTTON ;
         ID       3 ;
         OF       fldGeneral ;
         ACTION   ( ShowImage( oImgBmp ) )

      REDEFINE GET aTmp[ ( dbfTmpImg )->( FieldPos( "cHtmArt" ) ) ] ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldPrecios

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndEdtImg( aTmp, dbfTmpImg, oBrw, nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:bStart := {|| oImgArt:SetFocus() }

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndEdtImg( aTmp, dbfTmpImg, oBrw, nMode, oDlg ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function EndEdtImg( aTmp, dbfTmpImg, oBrw, nMode, oDlg )

   local nRec
   local aTemporal   := aTmp[ ( dbfTmpImg )->( FieldPos( "cImgArt" ) ) ]
   local lTemporal   := aTmp[ ( dbfTmpImg )->( FieldPos( "lDefImg" ) ) ]

   WinGather( aTmp, nil, dbfTmpImg, oBrw, nMode )

   if lTemporal

      nRec              := ( dbfTmpImg )->( RecNo() )

      ( dbfTmpImg )->( dbGoTop() )
      while !( dbfTmpImg )->( Eof() )

         if AllTrim( ( dbfTmpImg )->cImgArt ) != AllTrim( aTemporal )
            ( dbfTmpImg )->lDefImg := .f.
         else
            ( dbfTmpImg )->lDefImg := .t.
      end if

         ( dbfTmpImg )->( dbSkip() )

      end while

      ( dbfTmpImg )->( dbGoto( nRec ) )

   end if

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

   oDlg:end( IDOK )

   lChangeImage   := .t.

Return ( .t. )

//---------------------------------------------------------------------------//

Function cFirstImage( cCodigoArticulo, dbfImage )

   local cFirstImage   := ""

   if dbSeekInOrd( cCodigoArticulo, "cCodArt", dbfImage )
      cFirstImage      := ( dbfImage )->cImgArt
   end if

Return ( cFirstImage )

//---------------------------------------------------------------------------//

Function ChangeTarWeb( aGet, aTmp )

   if aTmp[ ( dbfArticulo )->( fieldpos( "LSBRINT" ) ) ]

      do case
         case aTmp[ ( dbfArticulo )->( fieldpos( "nTarWeb" ) ) ] == 1
            aGet[ ( dbfArticulo )->( fieldpos( "pVtaWeb" ) ) ]:cText( aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA1" ) ) ] )

         case aTmp[ ( dbfArticulo )->( fieldpos( "nTarWeb" ) ) ] == 2
            aGet[ ( dbfArticulo )->( fieldpos( "pVtaWeb" ) ) ]:cText( aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA2" ) ) ] )

         case aTmp[ ( dbfArticulo )->( fieldpos( "nTarWeb" ) ) ] == 3
            aGet[ ( dbfArticulo )->( fieldpos( "pVtaWeb" ) ) ]:cText( aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA3" ) ) ] )

         case aTmp[ ( dbfArticulo )->( fieldpos( "nTarWeb" ) ) ] == 4
            aGet[ ( dbfArticulo )->( fieldpos( "pVtaWeb" ) ) ]:cText( aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA4" ) ) ] )

         case aTmp[ ( dbfArticulo )->( fieldpos( "nTarWeb" ) ) ] == 5
            aGet[ ( dbfArticulo )->( fieldpos( "pVtaWeb" ) ) ]:cText( aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA5" ) ) ] )

         case aTmp[ ( dbfArticulo )->( fieldpos( "nTarWeb" ) ) ] == 6
            aGet[ ( dbfArticulo )->( fieldpos( "pVtaWeb" ) ) ]:cText( aTmp[ ( dbfArticulo )->( fieldpos( "PVENTA6" ) ) ] )

      end case

      Eval( aGet[ ( dbfArticulo )->( fieldpos( "nDtoInt1" ) ) ]:bChange )

   end if   

Return ( .t. )

//---------------------------------------------------------------------------//

Function nCostoUltimaCompra( cCodArt, dbfAlbPrvL, dbfFacPrvL )

   local nCosto   := 0

/* 
   do case //Lo cambiamos para que coge el costo con los descuentos
      case  ( dbfAlbPrvL )->( dbSeek( cCodArt ) ) .and. ( dbfFacPrvL )->( dbSeek( cCodArt ) )

         if ( dbfAlbPrvL )->dFecAlb > ( dbfFacPrvL )->dFecFac
            nCosto   := ( dbfAlbPrvL )->nPreDiv
         else
            nCosto   := ( dbfFacPrvL )->nPreUnit
         end if

      case  !( dbfAlbPrvL )->( dbSeek( cCodArt ) ) .and. ( dbfFacPrvL )->( dbSeek( cCodArt ) )

         nCosto   := ( dbfFacPrvL )->nPreUnit

      case  ( dbfAlbPrvL )->( dbSeek( cCodArt ) ) .and. !( dbfFacPrvL )->( dbSeek( cCodArt ) )

         nCosto   := ( dbfAlbPrvL )->nPreDiv

   end case
*/

   do case
      case  ( dbfAlbPrvL )->( dbSeek( cCodArt ) ) .and. ( dbfFacPrvL )->( dbSeek( cCodArt ) )

         if ( dbfAlbPrvL )->dFecAlb > ( dbfFacPrvL )->dFecFac
            nCosto   := ( dbfAlbPrvL )->nPreCom
         else
            nCosto   := ( dbfFacPrvL )->nPreCom
         end if

      case  !( dbfAlbPrvL )->( dbSeek( cCodArt ) ) .and. ( dbfFacPrvL )->( dbSeek( cCodArt ) )

         nCosto   := ( dbfFacPrvL )->nPreCom

      case  ( dbfAlbPrvL )->( dbSeek( cCodArt ) ) .and. !( dbfFacPrvL )->( dbSeek( cCodArt ) )

         nCosto   := ( dbfAlbPrvL )->nPreCom

   end case

return( nCosto )

//---------------------------------------------------------------------------//

CLASS SValorPropiedades

   DATA cCodPrp   INIT Space( 20 )
   DATA cValPrp   INIT Space( 40 )
   DATA cDesPrp
   DATA nColor
   DATA lSel      INIT .f.

END CLASS

//---------------------------------------------------------------------------//

Static Function ChangeFactorConversion( aTmp, aGet )

   if aTmp[ ( dbfArticulo )->( fieldpos( "lFacCnv" ) ) ]

      if aTmp[ ( dbfArticulo )->( fieldpos( "nPesoKg" ) ) ] != 0

         aGet[ ( dbfArticulo )->( fieldpos( "nFacCnv" ) ) ]:cText( 1 / aTmp[ ( dbfArticulo )->( fieldpos( "nPesoKg" ) ) ] )

      else

         if aTmp[ ( dbfArticulo )->( fieldpos( "nVolumen" ) ) ] != 0
            aGet[ ( dbfArticulo )->( fieldpos( "nFacCnv" ) ) ]:cText( 1 / aTmp[ ( dbfArticulo )->( fieldpos( "nVolumen" ) ) ] )
         end if

      end if

   else

      aGet[ ( dbfArticulo )->( fieldpos( "nFacCnv" ) ) ]:cText( 1 )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function Actualizaweb( cCodArt, lChangeImage, lActualizaWeb )

   if lActualizaWeb .and. uFieldEmpresa( "lRealWeb" )

      if lPubArt()

         with object ( TComercio():GetInstance() )  
            :ActualizaProductsPrestashop( cCodArt, lChangeImage )
         end with

      end if   

   end if   

Return .t.

//---------------------------------------------------------------------------//

Static Function lPubArt()

   local lPub  := .f.

   if ( dbfArticulo )->lPubInt

      lPub     := .t.

   else

      if ( dbfArticulo )->cCodWeb != 0

         lPub  := .t.

      end if

   end if

Return lPub

//---------------------------------------------------------------------------//

Static Function lValidImporteBase( oGet, uValue, nKey, hFields )

   local nPrecioBase             := 0
   local nPrecioIva              := 0
   local nPorcentajeIva          := 0
   local nPorcentajeBeneficio    := 0
   local lBeneficioSobreCosto    := .t.

   if nKey == VK_ESCAPE
      Return .f.
   end if 

   nPorcentajeIva                := nIva( dbfIva, ( dbfArticulo )->TipoIva )

   nPrecioBase                   := uValue

   /*
   Primero es quitar el IVA----------------------------------------------------
   */

   nPrecioIva                    := nPrecioBase + Round( ( nPrecioBase * nPorcentajeIva / 100 ), nDecDiv )

   /*
   Calculo de porcentajes de beneficio-----------------------------------------
   */

   if ( dbfArticulo )->pCosto != 0

      lBeneficioSobreCosto       := ( dbfArticulo )->( fieldget( fieldpos( hFields[ "BeneficioSobre" ] ) ) ) <= 1

      nPorcentajeBeneficio       := nPorcentajeBeneficio( lBeneficioSobreCosto, nPrecioBase, ( dbfArticulo )->pCosto )

      if !( nPorcentajeBeneficio > 0 .and. nPorcentajeBeneficio < 999 )
         nPorcentajeBeneficio    := 0
      end if

   end if

   /*
   Escribimos el registro------------------------------------------------------
   */

   if dbDialogLock( dbfArticulo )
      ( dbfArticulo )->( fieldput( fieldpos( hFields[ "Iva"       ] ), nPrecioIva ) )
      ( dbfArticulo )->( fieldput( fieldpos( hFields[ "Base"      ] ), nPrecioBase ) )
      ( dbfArticulo )->( fieldput( fieldpos( hFields[ "Beneficio" ] ), nPorcentajeBeneficio ) )
      ( dbfArticulo )->( dbUnlock() )
   end if 

Return .t.

//---------------------------------------------------------------------------//

Static Function lValidImporteIva( oGet, uValue, nKey, hFields ) // { "Base" => "pVenta1", "Iva" => "pVtaIva1", "Beneficio" => "Benef1", "BeneficioSobre" => "nBnfSbr1" }

   local nPrecioBase             := 0
   local nPrecioIva              := 0
   local nPorcentajeIva          := 0
   local nPorcentajeBeneficio    := 0
   local lBeneficioSobreCosto    := .t.

   if nKey == VK_ESCAPE
      Return .f.
   end if 

   nPorcentajeIva                := nIva( dbfIva, ( dbfArticulo )->TipoIva )

   /*
   Margen de ajuste------------------------------------------------------------ 
   */

   if IsTrue( ( dbfArticulo )->lMarAju )
      nPrecioIva                 := nAjuste( uValue, ( dbfArticulo )->cMarAju )
   else 
      nPrecioIva                 := uValue
   end if

   /*
   Primero es quitar el IVA----------------------------------------------------
   */

   nPrecioBase                   := Round( nPrecioIva / ( 1 + nPorcentajeIva / 100 ), nDecDiv )

   /*
   Calculo de porcentajes de beneficio-----------------------------------------
   */

   if ( dbfArticulo )->pCosto != 0

      lBeneficioSobreCosto       := ( dbfArticulo )->( fieldget( fieldpos( hFields[ "BeneficioSobre" ] ) ) ) <= 1

      nPorcentajeBeneficio       := nPorcentajeBeneficio( lBeneficioSobreCosto, nPrecioBase, ( dbfArticulo )->pCosto )

      if !( nPorcentajeBeneficio > 0 .and. nPorcentajeBeneficio < 999 )
         nPorcentajeBeneficio    := 0
      end if

   end if

   /*
   Escibimos el registro-------------------------------------------------------
   */

   if dbDialogLock( dbfArticulo )
      ( dbfArticulo )->( fieldput( fieldpos( hFields[ "Iva"       ] ), nPrecioIva ) )
      ( dbfArticulo )->( fieldput( fieldpos( hFields[ "Base"      ] ), nPrecioBase ) )
      ( dbfArticulo )->( fieldput( fieldpos( hFields[ "Beneficio" ] ), nPorcentajeBeneficio ) )
      ( dbfArticulo )->( dbUnlock() )
   end if 

Return .t.

//---------------------------------------------------------------------------//

Static Function ValidPrecioCosto( aGet, oSayWeb )

   aGet[ ( dbfArticulo )->( fieldpos( "Benef1" ) ) ]:lValid()
   aGet[ ( dbfArticulo )->( fieldpos( "Benef2" ) ) ]:lValid()
   aGet[ ( dbfArticulo )->( fieldpos( "Benef3" ) ) ]:lValid()
   aGet[ ( dbfArticulo )->( fieldpos( "Benef4" ) ) ]:lValid()
   aGet[ ( dbfArticulo )->( fieldpos( "Benef5" ) ) ]:lValid()
   aGet[ ( dbfArticulo )->( fieldpos( "Benef6" ) ) ]:lValid()

   aeval( oSayWeb, {|o| if( !empty(o), o:refresh(), ) } )

Return ( .t. )

//---------------------------------------------------------------------------//

FUNCTION cNomValPrp1Art( uArticulo, uTblPro )

   local cBarPrp1     := ""

   DEFAULT uArticulo  := if( !Empty( tmpArticulo ), tmpArticulo, dbfArticulo )
   DEFAULT uTblPro    := dbfTblPro

   if dbSeekInOrd( ( uArticulo )->cCodPrp1 + ( uArticulo )->cValPrp1, "cCodPro", uTblPro )
      cBarPrp1        := ( uTblPro )->cDesTbl
   end if

RETURN ( cBarPrp1 )

//---------------------------------------------------------------------------//

FUNCTION cNomValPrp2Art( uArticulo, uTblPro )

   local cBarPrp2     := ""

   DEFAULT uArticulo  := if( !Empty( tmpArticulo ), tmpArticulo, dbfArticulo )
   DEFAULT uTblPro    := dbfTblPro

   if dbSeekInOrd( ( uArticulo )->cCodPrp2 + ( uArticulo )->cValPrp2, "cCodPro", uTblPro )
      cBarPrp2        := ( uTblPro )->cDesTbl
   end if

RETURN ( cBarPrp2 )

//---------------------------------------------------------------------------//

FUNCTION GridBrwArticulo( uGet, uGetName, lBigStyle )

   local oDlg
   local oBrw
   local oSayGeneral
   local oBtnAceptar
   local oBtnCancelar
   local oGetSearch
   local cGetSearch  := Space( 100 )
   local cTxtOrigen  := if( !empty( uGet ), uGet:VarGet(), )
   local nOrdAnt     := GetBrwOpt( "BrwGridArticulo" )
   local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre", "Proveedor" }
   local cCbxOrd
   local nLevel      := nLevelUsr( "01032" )

   nOrdAnt           := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrdAnt ]

   if !OpenFiles( .t. )
      Return nil
   end if

   /*
   Origen de busqueda----------------------------------------------------------
   */

   if !Empty( cTxtOrigen ) .and. !( dbfArticulo )->( dbSeek( cTxtOrigen ) )
      ( dbfArticulo )->( OrdSetFocus( nOrdAnt ) )
      ( dbfArticulo )->( dbGoTop() )
   else
      ( dbfArticulo )->( OrdSetFocus( nOrdAnt ) )
   end if

   oDlg           := TDialog():New( 1, 5, 40, 100, "Buscar artículos",,, .f., nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ),, rgb(255,255,255),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   oSayGeneral    := TGridSay():Build(    {  "nRow"      => 0,;
                                             "nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                                             "bText"     => {|| "Buscar artículos" },;
                                             "oWnd"      => oDlg,;
                                             "oFont"     => oGridFontBold(),;
                                             "lPixels"   => .t.,;
                                             "nClrText"  => Rgb( 0, 0, 0 ),;
                                             "nClrBack"  => Rgb( 255, 255, 255 ),;
                                             "nWidth"    => {|| GridWidth( 10, oDlg ) },;
                                             "nHeight"   => 32,;
                                             "lDesign"   => .f. } )

   oBtnAceptar    := TGridImage():Build(  {  "nTop"      => 5,;
                                             "nLeft"     => {|| GridWidth( 11, oDlg ) },;
                                             "nWidth"    => 32,;
                                             "nHeight"   => 32,;
                                             "cResName"  => "CheckFlat_32",;
                                             "bLClicked" => {|| oDlg:End( IDOK ) },;
                                             "oWnd"      => oDlg } )

   oBtnCancelar   := TGridImage():Build(  {  "nTop"      => 5,;
                                             "nLeft"     => {|| GridWidth( 11.5, oDlg ) },;
                                             "nWidth"    => 32,;
                                             "nHeight"   => 32,;
                                             "cResName"  => "CancelFlat_32",;
                                             "bLClicked" => {|| oDlg:End() },;
                                             "oWnd"      => oDlg } )

   // Texto de busqueda--------------------------------------------------------

   oGetSearch     := TGridGet():Build(    {  "nRow"      => 38,;
                                             "nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, cGetSearch, cGetSearch := u ) },;
                                             "oWnd"      => oDlg,;
                                             "nWidth"    => {|| GridWidth( 9, oDlg ) },;
                                             "nHeight"   => 25,;
                                             "bValid"    => {|| OrdClearScope( oBrw, dbfArticulo ) },;
                                             "bChanged"  => {| nKey, nFlags, Self | SpecialSeek( nKey, nFlags, Self, oBrw, oCbxOrd, dbfArticulo, dbfCodebar )  } } )

   oCbxOrd     := TGridComboBox():Build(  {  "nRow"      => 38,;
                                             "nCol"      => {|| GridWidth( 9.5, oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, cCbxOrd, cCbxOrd := u ) },;
                                             "oWnd"      => oDlg,;
                                             "nWidth"    => {|| GridWidth( 2, oDlg ) },;
                                             "nHeight"   => 25,;
                                             "aItems"    => aCbxOrd,;
                                             "bChanged"  => {| nKey, nFlags, Self | ( dbfArticulo )->( OrdSetFocus( oCbxOrd:nAt ) ), oGetSearch:SetFocus() } } )

   // Browse de articulos ------------------------------------------------------

   oBrw                 := TGridIXBrowse():New( oDlg )

   oBrw:nTop            := oBrw:EvalRow( 64 )
   oBrw:nLeft           := oBrw:EvalCol( {|| GridWidth( 0.5, oDlg ) } )
   oBrw:nWidth          := oBrw:EvalWidth( {|| GridWidth( 11, oDlg ) } )
   oBrw:nHeight         := oBrw:EvalHeight( {|| GridHeigth( oDlg ) - oBrw:nTop - 10 } )

   oBrw:cAlias          := dbfArticulo
   oBrw:nMarqueeStyle   := 5
   oBrw:cName           := "BrwGridArticulo"

   with object ( oBrw:AddCol() )
      :cHeader          := "Código"
      :cSortOrder       := "CodObs"
      :bEditValue       := {|| ( dbfArticulo )->Codigo }
      :nWidth           := 180
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), oGetSearch:SetFocus() }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Nombre"
      :cSortOrder       := "NomObs"
      :bEditValue       := {|| ( dbfArticulo )->Nombre }
      :nWidth           := 560
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), oGetSearch:SetFocus() }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Tipo"
      :bEditValue       := {|| AllTrim( oRetFld( ( dbfArticulo )->cCodTip, oTipart:oDbf ) ) }
      :nWidth           := 250
      :lHide            := .t.
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Proveedor"
      :bEditValue       := {|| if( !Empty( ( dbfArticulo )->cPrvHab ), AllTrim( ( dbfArticulo )->cPrvHab ) + " - " + RetProvee( ( dbfArticulo )->cPrvHab, dbfProv ), "" ) }
      :nWidth           := 420
      :lHide            := .t.
      :cSortOrder       := "cPrvHab"
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), oGetSearch:SetFocus() }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" )
      :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" ) + " " + cImp() + " inc."
      :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" )
      :bStrData         := {|| TransPrecio( nRetPreArt( 2, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :lHide            := .t.
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" ) + " " + cImp() + " inc."
      :bStrData         := {|| TransPrecio( nRetPreArt( 2, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :lHide            := .t.
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" )
      :bStrData         := {|| TransPrecio( nRetPreArt( 3, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :lHide            := .t.
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" ) + " " + cImp() + " inc."
      :bStrData         := {|| TransPrecio( nRetPreArt( 3, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :lHide            := .t.
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" )
      :bStrData         := {|| TransPrecio( nRetPreArt( 4, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :lHide            := .t.
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" ) + " " + cImp() + " inc."
      :bStrData         := {|| TransPrecio( nRetPreArt( 4, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :lHide            := .t.
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" )
      :bStrData         := {|| TransPrecio( nRetPreArt( 5, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :lHide            := .t.
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" ) + " " + cImp() + " inc."
      :bStrData         := {|| TransPrecio( nRetPreArt( 5, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :lHide            := .t.
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" )
      :bStrData         := {|| TransPrecio( nRetPreArt( 6, nil, .f., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :lHide            := .t.
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" ) + " " + cImp() + " inc."
      :bStrData         := {|| TransPrecio( nRetPreArt( 6, nil, .t., dbfArticulo, dbfDiv, dbfArtKit, dbfIva ), lEuro ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :lHide            := .t.
   end with

   if ( oUser():lCostos() )

   with object ( oBrw:AddCol() )
      :cHeader          := "Costo"
      :bStrData         := {|| nCosto( nil, dbfArticulo, dbfArtKit, .t., if( lEuro, cDivChg(), cDivEmp() ), dbfDiv ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :lHide            := .t.
   end with

   end if 

   oBrw:nHeaderHeight   := 40
   oBrw:nFooterHeight   := 40
   oBrw:nRowHeight      := 40

   oBrw:CreateFromCode( 105 )

   // Dialogo------------------------------------------------------------------

   oDlg:bResized        := {|| GridResize( oDlg ) }
   oDlg:bStart          := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER ON INIT ( GridMaximize( oDlg ) ) 

   if oDlg:nResult == IDOK

      if isObject( uGet )
         uGet:cText( ( dbfArticulo )->Codigo )
         uGet:lValid()
      else
         uGet           := ( dbfArticulo )->Codigo
      end if

      if isObject( uGetName ) 
         uGetName:cText( ( dbfArticulo )->Nombre )
      end if

   end if

   DestroyFastFilter( dbfArticulo )

   SetBrwOpt( "BrwGridArticulo", ( dbfArticulo )->( OrdNumber() ) )

   CloseFiles()

   if IsObject( uGet ) 
      uGet:setFocus()
   end if

   oBtnAceptar:end()
   oBtnCancelar:end()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
