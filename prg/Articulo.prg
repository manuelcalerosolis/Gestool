#include "FiveWin.Ch"
#include "Folder.ch" 
#include "Label.ch"
#include "Image.ch"
#include "Xbrowse.ch"
#include "FastRepH.ch"
#include "Factu.ch" 
#include "Autoget.ch"

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
#define DT_CALCRECT                 0x00000004
#define DT_NOPREFIX                 0x00000800
#define DT_INTERNAL                 0x00001000

#define __lenCodigoMatriz__         6

#define fldGeneral                  oFld:aDialogs[1]
#define fldPrecios                  oFld:aDialogs[2]
#define fldAdicionales              oFld:aDialogs[3] 
#define fldTactil                   oFld:aDialogs[4] 
#define fldDescripciones            oFld:aDialogs[5]
#define fldImagenes                 oFld:aDialogs[6]
#define fldPropiedades              oFld:aDialogs[7]
#define fldLogistica                oFld:aDialogs[8]
#define fldStocks                   oFld:aDialogs[9] 
#define fldContabilidad             oFld:aDialogs[10]
#define fldOfertas                  oFld:aDialogs[11]
#define fldEscandallos              oFld:aDialogs[12]
#define fldWeb                      oFld:aDialogs[13]

memvar cDbfArt
memvar cDbfDiv
memvar cDbfOfe
memvar cDbfBar

static pThread

static oWndBrw

static oTagsEver

static dbfProv
static dbfCatalogo
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
static filTmpLeng
static dbfTmpLeng
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
static filTmpAlm
static dbfTmpAlm

static oStock
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
static oLenguajes
static oTpvMenu

static oDetCamposExtra
static oGetTarWeb

static oActiveX

static cCatOld
static cPrvOld
static oMenu

static aBenefSobre         := { "Costo", "Venta" }
static aImgsArticulo       := {}

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
static bEdtAlm             := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt | EdtAlm( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt ) }
static bEdtVta             := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt | EdtVta( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt ) }
static bEdtLeng            := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpArt | EdtLeng( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpArt ) }
static bEdtKit             := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt | EdtKit( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt ) }
static bEdtImg             := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode          | EdtImg( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }
static bEdtCod             := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt | EdtCodebar( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt ) }

static nView

static filArticulo
static tmpArticulo

static dbfCodebar
static dbfArtVta
static dbfArtKit
static dbfArtLbl
static dbfDiv

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
static dbfPedPrvL
static dbfPedCliL
static dbfUbicaT
static dbfUbicaL

static oSeccion

static aTiposImpresoras

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

static cOldCodeBar      := ""
static aOldCodeBar      := {}

static oBtnStockAlmacenes

static oBtnAceptarActualizarWeb

static hStockArticulo   := {=>}

//---------------------------------------------------------------------------//

#ifndef __PDA__

/*
Cargamos los stocks bajo demanda-----------------------------------------------
*/

Function SetStockArticulos()

   local nStock   := 0

   if OpenFiles()

      ( D():Articulos( nView ) )->( dbGoTop() )

      while ( D():Articulos( nView ) )->( !Eof() )

         if !( D():Articulos( nView ) )->lObs
            nStock   := oStock:nStockArticulo( ( D():Articulos( nView ) )->Codigo )
         else
            nStock   := 0
         end if

         if ( D():Articulos( nView ) )->nStkCal != nStock

            if dbLock( D():Articulos( nView ) )
               ( D():Articulos( nView ) )->nStkCal    := nStock
               ( D():Articulos( nView ) )->( dbUnlock() )
            end if

         end if

         ( D():Articulos( nView ) )->( dbSkip() )

      end while

      CloseFiles()

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt, cPath )

   local oError
   local oBlock
   local nSeconds
   local nStockArticulo

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

      lOpenFiles  := .t.
      
      oMsgText( 'Abriendo ficheros artículos' )

      nView       := D():CreateView()

      D():Articulos( nView )

      D():ArticuloLenguaje( nView )
      
      D():Lenguajes( nView )
      
      D():EstadoArticulo( nView )

      D():Familias( nView )

      D():ArticuloImagenes( nView )

      D():MovimientosAlmacenLineas( nView )
      ( D():MovimientosAlmacenLineas( nView ) )->( OrdSetFocus( "cRefMov" ) )

      D():TiposIva( nView )

      D():ProveedorArticulo( nView )

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatPrv() + "PROVEE.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProv ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE

      USE ( cPatEmp() + "CATALOGO.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CATALOGO", @dbfCatalogo ) )
      SET ADSINDEX TO ( cPatEmp() + "CATALOGO.CDX" ) ADDITIVE

      USE ( cPatArt() + "Temporadas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TEMPORADA", @dbfTemporada ) )
      SET ADSINDEX TO ( cPatArt() + "Temporadas.Cdx" ) ADDITIVE

      USE ( cPatArt() + "FamPrv.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMPRV", @dbfFamPrv ) )
      SET ADSINDEX TO ( cPatArt() + "FamPrv.Cdx" ) ADDITIVE

      USE ( cPatDat() + "TMOV.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TMOV", @dbfTMov ) )
      SET ADSINDEX TO ( cPatDat() + "TMOV.CDX" ) ADDITIVE

      USE ( cPatArt() + "TARPRET.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRET", @dbfTarPreT ) )
      SET ADSINDEX TO ( cPatArt() + "TARPRET.CDX" ) ADDITIVE

      USE ( cPatArt() + "TARPREL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPREL", @dbfTarPreL ) )
      SET ADSINDEX TO ( cPatArt() + "TARPREL.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatArt() + "TARPRES.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TARPRES", @dbfTarPreS ) )
      SET ADSINDEX TO ( cPatArt() + "TARPRES.CDX" ) ADDITIVE

      USE ( cPatArt() + "OFERTA.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOfe ) )
      SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTDIV.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtVta ) )
      SET ADSINDEX TO ( cPatArt() + "ARTDIV.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtLbl.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ArtLbl", @dbfArtLbl ) )
      SET ADSINDEX TO ( cPatArt() + "ArtLbl.Cdx" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatAlm() + "ALMACEN.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
      SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfArtKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatArt() + "PRO.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RDOCUMEN.Dbf" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      SET TAG TO "CTIPO"

      USE ( cPatEmp() + "ALBPROVL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE
      SET TAG TO "cStkFast"

      USE ( cPatEmp() + "FACPRVL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "RctPrvL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RctPrvL", @dbfRctPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "RctPrvL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "ALBCLIL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE
      SET TAG TO "cStkFast"

      USE ( cPatEmp() + "FACCLIL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "FacRecL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecL", @dbfFacRecL ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "TIKEL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE
      SET TAG TO "CSTKFAST"

      USE ( cPatEmp() + "PROLIN.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROLIN", @dbfProLin ) )
      SET ADSINDEX TO ( cPatEmp() + "PROLIN.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatEmp() + "PROMAT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROMAT", @dbfProMat ) )
      SET ADSINDEX TO ( cPatEmp() + "PROMAT.CDX" ) ADDITIVE
      SET TAG TO "cCodArt"

      USE ( cPatEmp() + "ALBPROVT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbPrvT", @dbfAlbPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVT.CDX" ) ADDITIVE

      if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
         lOpenFiles     := .f.
      end if

      USE ( cPatEmp() + "PEDPROVL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedPrvL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatEmp() + "PEDCLIL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliL", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE
      SET TAG TO "cRef"

      USE ( cPatAlm() + "UBICAT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "UBICAT", @dbfUbicaT ) )
      SET ADSINDEX TO ( cPatAlm() + "UBICAT.CDX" ) ADDITIVE

      USE ( cPatAlm() + "UBICAL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "UBICAL", @dbfUbicaL ) )
      SET ADSINDEX TO ( cPatAlm() + "UBICAL.CDX" ) ADDITIVE

      D():ArticuloStockAlmacenes( nView )

      oBandera             := TBandera():New()

      oStock               := TStock():Create( cPatEmp() )
      if !oStock:lOpenFiles()
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

      oFabricante          := TFabricantes():Create( cPatEmp() )
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

      oUndMedicion         := UniMedicion():Create( cPatEmp() )
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

      oLenguajes           := TLenguaje():Create( cPatDat() )
      if !oLenguajes:OpenFiles()
         lOpenFiles        := .f.
      end if

      oTpvMenu             := TpvMenu():Create( cPath )
      oTpvMenu:OpenService( .f., cPath )
      oTpvMenu:SetFilter( 'Field->lAcomp == .t.' )
      oTpvMenu:lAppendBuscar     := .f.
      oTpvMenu:lModificarBuscar  := .f.

      oDetCamposExtra      := TDetCamposExtra():New()
      if !oDetCamposExtra:OpenFiles()
         lOpenFiles        := .f.
      end if
      
      oDetCamposExtra:setTipoDocumento( "Artículos" )
      oDetCamposExtra:setbId( {|| D():ArticulosId( nView ) } )

      if !IsReport()
         TComercioConfig():getInstance():loadJSON()
      end if

      aTiposImpresoras     := TiposImpresorasModel():New():arrayTiposImpresoras()

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

      if !empty( oWndBrw:oBrw )
         oWndBrw:oBrw:End()
      end if

      if lDestroy
         oWndBrw     := nil
      end if

   end if

   D():DeleteView( nView )

   if dbfProv != nil
      ( dbfProv )->( dbCloseArea() )
   end if

   if dbfCatalogo != nil
      ( dbfCatalogo )->( dbCloseArea() )
   end if

   if dbfTemporada != nil
      ( dbfTemporada )->( dbCloseArea() )
   end if

   if dbfFamPrv != nil
      ( dbfFamPrv )->( dbCloseArea() )
   end if

   if dbfTMov != nil
      ( dbfTMov )->( dbCloseArea() )
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

   if !empty( dbfDoc )
      ( dbfDoc )->( dbCloseArea() )
   end if

   if !empty( oStock )
      oStock:end()
   end if

   if !empty( oGrpFam )
      oGrpFam:end()
   end if

   if !empty( oTipArt )
      oTipArt:end()
   end if

   if !empty( oFabricante )
      oFabricante:end()
   end if

   if !empty( oCatalogo )
      oCatalogo:end()
   end if

   if !empty( oNewImp )
      oNewImp:end()
   end if

   if !empty( oUndMedicion )
      oUndMedicion:end()
   end if

   if !empty( oFraPub )
      oFraPub:end()
   end if

   if !empty( oSeccion )
      oSeccion:End()
   end if

   if !empty( oOrdenComanda )
      oOrdenComanda:End()
   end if 

   if !empty( oTpvMenu )
      oTpvMenu:CloseService()
   end if

   if !empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   if !empty( oLenguajes )
      oLenguajes:End()
   end if

   if !IsReport()
      TComercioConfig():DestroyInstance()
   end if

   dbfProv           := nil
   dbfCatalogo       := nil
   dbfFamPrv         := nil
   oStock            := nil
   dbfTMov           := nil
   dbfTarPreT        := nil
   dbfTarPreL        := nil
   dbfTarPreS        := nil
   dbfOfe            := nil
   dbfDiv            := nil
   dbfArtVta         := nil
   oBandera          := nil
   dbfAlmT           := nil
   dbfArtKit         := nil
   dbfArtLbl         := nil
   dbfTblPro         := nil
   dbfPro            := nil
   dbfCodebar        := nil
   oTipArt           := nil
   oCatalogo         := nil
   oOrdenComanda     := nil 
   oNewImp           := nil
   oFraPub           := nil
   dbfDoc            := nil
   dbfTemporada      := nil
   dbfAlbPrvL        := nil
   dbfFacPrvL        := nil
   dbfAlbCliL        := nil
   dbfFacCliL        := nil
   dbfFacRecL        := nil
   dbfTikCliL        := nil
   dbfProLin         := nil
   dbfProMat         := nil
   dbfAlbPrvT        := nil
   dbfAlbCliT        := nil
   dbfPedPrvL        := nil
   dbfPedCliL        := nil
   dbfUbicaT         := nil
   dbfUbicaL         := nil
   oTpvMenu          := nil
   oDetCamposExtra   := nil
   oLenguajes        := nil

   lOpenFiles        := .f.

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

   if !empty( oWndBrw )
      oWndBrw:putFocus()
      Return .t.
   end if

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
               getConfigTraslation( "Familia" ),;
               "Proveedor" ,;
               "No obsoletos + Código",;
               "No obsoletos + Nombre",;
               "Tipo" ,;
               "Temporada" ,;
               "Fabricante" ,;
               "Estado" ,;
               "Posición táctil" ,;
               "Publicar" ,;
               "Web",;
               getConfigTraslation( "Ubicación" ) ;
      MRU      "gc_object_cube_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( D():Articulos( nView ) ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, D():Articulos( nView ) ) ) ;
		EDIT 		( WinEdtRec( oWndBrw:oBrw, bEdit, D():Articulos( nView ) ) ) ;
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, D():Articulos( nView ) ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, D():Articulos( nView ), {|| DelDetalle( ( D():Articulos( nView ) )->Codigo ) } ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Escandallos"
      :nHeadBmpNo       := 3
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( D():Articulos( nView ) )->lKitArt }
      :nWidth           := 20
      :SetCheck( { "gc_piece_12", "Nil16" } )
      :AddResource( "BMPKIT" )
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Envio"
      :nHeadBmpNo       := 3
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( D():Articulos( nView ) )->lSndDoc }
      :nWidth           := 20
      :SetCheck( { "gc_mail2_12", "Nil16" } )
      :AddResource( "gc_mail2_16" )
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Código de barras"
      :nHeadBmpNo       := 3
      :bStrData         := {|| "" }
      :bEditValue       := {|| dbSeekInOrd( ( D():Articulos( nView ) )->Codigo, "cCodArt", dbfCodebar ) }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
      :AddResource( "gc_portable_barcode_scanner_16" )
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Táctil"
      :nHeadBmpNo       := 3
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( D():Articulos( nView ) )->lIncTcl }
      :nWidth           := 18
      :lHide            := .t.
      :SetCheck( { "Sel16", "Nil16" } )
      :AddResource( "Tactil16" )
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Posición táctil"
      :cSortOrder       := "nPosTpv"
      :bEditValue       := {|| if( ( D():Articulos( nView ) )->lIncTcl, Trans( ( D():Articulos( nView ) )->nPosTpv, "999" ), "" ) }
      :nWidth           := 80
      :lHide            := .t.
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Obsoleto"
      :nHeadBmpNo       := 3
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( D():Articulos( nView ) )->lObs }
      :nWidth           := 18
      :lHide            := .t.
      :SetCheck( { "Cnt16", "Nil16" } )
      :AddResource( "DEL16" )
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Publicar"
      :cSortOrder       := "lPubInt"
      :nHeadBmpNo       := 3
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( D():Articulos( nView ) )->lPubInt }
      :nWidth           := 20
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :SetCheck( { "gc_earth_12", "Nil16" } )
      :AddResource( "gc_earth_16" )
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Código"
      :cSortOrder       := "Codigo"
      :bEditValue       := {|| ( D():Articulos( nView ) )->Codigo }
      :nWidth           := 100
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Nombre"
      :cSortOrder       := "Nombre"
      :bEditValue       := {|| ( D():Articulos( nView ) )->Nombre }
      :nWidth           := 300
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := getConfigTraslation( "Familia" )
      :cSortOrder       := "cFamCod"
      :bEditValue       := {|| ( D():Articulos( nView ) )->Familia }
      :nWidth           := 80
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Nombre familia"
      :bEditValue       := {|| RetFamilia( ( D():Articulos( nView ) )->Familia, D():Familias( nView ) ) }
      :nWidth           := 140
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Tipo"
      :cSortOrder       := "cCodTip"
      :bStrData         := {|| AllTrim( ( D():Articulos( nView ) )->cCodTip ) + if( !empty( ( D():Articulos( nView ) )->cCodTip ), " - ", "" ) + oRetFld( ( D():Articulos( nView ) )->cCodTip, oTipArt:oDbf, "cNomTip" ) }
      :nWidth           := 140
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :lHide            := .t. 
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := getConfigTraslation( "Temporada" )
      :cSortOrder       := "cCodTemp"
      :bStrData         := {|| AllTrim( ( D():Articulos( nView ) )->cCodTemp ) + if( !empty( ( D():Articulos( nView ) )->cCodTemp ), " - ", "" ) + RetFld( ( D():Articulos( nView ) )->cCodTemp, dbfTemporada, "cNombre" ) }
      :bBmpData         := {|| nBitmapTipoTemporada( RetFld( ( D():Articulos( nView ) )->cCodTemp, dbfTemporada, "cTipo" ) ) }
      :nWidth           := 140
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :lHide            := .t. 
      AddResourceTipoTemporada( hb_QWith() ) 
      :lHide            := .t. 
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Fabricante"
      :cSortOrder       := "cCodFab"
      :bStrData         := {|| AllTrim( ( D():Articulos( nView ) )->cCodFab ) + if( !empty( ( D():Articulos( nView ) )->cCodFab ), " - ", "" ) + RetFld( ( D():Articulos( nView ) )->cCodFab, oFabricante:GetAlias() ) }
      :nWidth           := 140
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :lHide            := .t. 
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Estado"
      :cSortOrder       := "cCodEst"
      :bStrData         := {|| AllTrim( ( D():Articulos( nView ) )->cCodEst ) + if( !empty( ( D():Articulos( nView ) )->cCodEst ), " - ", "" ) + RetFld( ( D():Articulos( nView ) )->cCodEst, D():EstadoArticulo( nView ), "cNombre" ) }
      :nWidth           := 140
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :lHide            := .t. 
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Web"
      :cSortOrder       := "cWebShop"
      :bEditValue       := {|| ( D():Articulos( nView ) )->cWebShop }
      :nWidth           := 140
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Stock"
      :bEditValue       := {|| ( D():Articulos( nView ) )->nStkCal }
      :cEditPicture     := MasUnd()
      :nWidth           := 80
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :cEditPicture     := MasUnd()      
      :lHide            := .t.
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" ) 
      :bEditValue       := {|| ( D():Articulos( nView ) )->pVenta1 }
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
      :bEditValue       := {|| ( D():Articulos( nView ) )->pVtaIva1 }
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
      :bEditValue       := {|| ( D():Articulos( nView ) )->pVenta2 }
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
      :bEditValue       := {|| ( D():Articulos( nView ) )->pVtaIva2 }
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
      :bEditValue       := {|| ( D():Articulos( nView ) )->pVenta3 }
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
      :bEditValue       := {|| ( D():Articulos( nView ) )->pVtaIva3 }
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
      :bEditValue       := {|| ( D():Articulos( nView ) )->pVenta4 }
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
      :bEditValue       := {|| ( D():Articulos( nView ) )->pVtaIva4 }
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
      :bEditValue       := {|| ( D():Articulos( nView ) )->pVenta5 }
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
      :bEditValue       := {|| ( D():Articulos( nView ) )->pVtaIva5 }
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
      :bEditValue       := {|| ( D():Articulos( nView ) )->pVenta6 }
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
      :bEditValue       := {|| ( D():Articulos( nView ) )->pVtaIva6 }
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
      :cHeader          := "Impuesto especial"
      :bEditValue       := {|| oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp ) }
      :cEditPicture     := cPouDiv
      :nWidth           := 90
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :lHide            := .t.
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar7", "Precio IVA con Imp. Esp. 1" ) + Space( 1 ) +  cImp()
      :bEditValue       := {|| totalArticuloConImpuestoEspecialUno( nView ) }
      :cEditPicture     := cPouDiv
      :nWidth           := 80
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :nEditType        := 1
      :lHide            := .t.
      :bEditWhen        := {|| nAnd( nLevel, ACC_EDIT ) != 0 }
      :bOnPostEdit      := {|o,x,n| lValidImporteIva( o, x, n, { "Base" => "pVenta1", "Iva" => "pVtaIva1", "Beneficio" => "Benef1", "BeneficioSobre" => "nBnfSbr1" } ) }
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar8", "Precio IVA con Imp. Esp. 2" ) + Space( 1 ) +  cImp()
      :bEditValue       := {|| totalArticuloConImpuestoEspecialDos( nView ) }
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
      :cHeader          := uFieldEmpresa( "cTxtTar9", "Precio IVA con Imp. Esp. 3" ) + Space( 1 ) +  cImp()
      :bEditValue       := {|| totalArticuloConImpuestoEspecialTres( nView ) }
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
      :cHeader          := uFieldEmpresa( "cTxtTar10", "Precio IVA con Imp. Esp. 4" ) + Space( 1 ) +  cImp()
      :bEditValue       := {|| totalArticuloConImpuestoEspecialCuatro( nView ) }
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
      :cHeader          := uFieldEmpresa( "cTxtTar11", "Precio IVA con Imp. Esp. 5" ) + Space( 1 ) +  cImp()
      :bEditValue       := {|| totalArticuloConImpuestoEspecialCinco( nView ) }
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
      :cHeader          := uFieldEmpresa( "cTxtTar12", "Precio IVA con Imp. Esp. 6" ) + Space( 1 ) +  cImp()
      :bEditValue       := {|| totalArticuloConImpuestoEspecialSeis( nView ) }
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
      :bStrData         := {|| if( !empty( ( D():Articulos( nView ) )->cPrvHab ), AllTrim( ( D():Articulos( nView ) )->cPrvHab ) + " - " + RetProvee( ( D():Articulos( nView ) )->cPrvHab, dbfProv ), "" ) }
      :nWidth           := 200
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :lHide            := .t.
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Referencia de proveedor"
      :bStrData         := {|| cRefArtPrv( ( D():Articulos( nView ) )->Codigo, ( D():Articulos( nView ) )->cPrvHab, D():ProveedorArticulo( nView ) ) }
      :nWidth           := 100
      :lHide            := .t.
   end with

   if ( oUser():lCostos() )

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Costo"
      :bStrData         := {|| if( oUser():lNotCostos(), "", nCosto( nil, D():Articulos( nView ), dbfArtKit, .t., if( lEuro, cDivChg(), cDivEmp() ), dbfDiv ) ) }
      :nWidth           := 100
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
      :lHide            := .t.
   end with

   end if

   with object ( oWndBrw:AddXCol() )
      :cHeader          := "Precio mínimo"
      :bEditValue       := {|| ( D():Articulos( nView ) )->PvpRec }
      :cEditPicture     := cPouDiv
      :nWidth           := 80
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :nEditType        := 1
      :lHide            := .t.
   end with

   with object ( oWndBrw:AddXCol() )
      :cHeader          := getConfigTraslation( "Ubicación" )
      :cSortOrder       := "cDesUbi"
      :bEditValue       := {|| ( D():Articulos( nView ) )->cDesUbi }
      :nWidth           := 150
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      :lHide            := .t.
      :nEditType        := 1
      :bOnPostEdit      := {|oCol, uNewValue, nKey| if( dbDialogLock( D():Articulos( nView ) ), ( ( D():Articulos( nView ) )->cDesUbi := uNewValue, ( D():Articulos( nView ) )->( dbUnlock() ) ), ) }
   end with

   oDetCamposExtra:addCamposExtra( oWndBrw )

   oWndBrw:cHtmlHelp    := "Articulos"
   oWndBrw:bToolTip     := {|| dlgTooltip( ( D():Articulos( nView ) )->Codigo, oWndBrw:oBrw ) }

   if uFieldEmpresa( "lShwPop" )
      oWndBrw:oBrw:bChange    := {|| if( !empty( oWndBrw ), oWndBrw:CheckExtendInfo(), ) }
   else
      oWndBrw:oBrw:bChange    := {|| oWndBrw:DestroyTooltip() }
      aAdd( oWndBrw:aFastKey, { VK_SPACE, {|| if( !empty( oWndBrw ), oWndBrw:ShowExtendInfo(), ) } } )
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
      ACTION   ( buscarExtendido() ) ; //buscarTipologias()
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
		ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, D():Articulos( nView ) ) );
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

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
		NOBORDER ;
      ACTION   ( BrwVtaComArt( ( D():Articulos( nView ) )->Codigo, ( D():Articulos( nView ) )->Nombre ) ) ;
      TOOLTIP  "(I)nforme artículo" ;
      HOTKEY   "I" ;
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "IMP" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TInfArtFam():New( "Listado de artículos" ):Play( .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ), D():Familias( nView ), oStock, oWndBrw ) );
      TOOLTIP  "Lis(t)ado";
      HOTKEY   "T" ;
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_document_empty_chart_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( runFastGallery( "Articulos" ) ) ; //  TFastVentasArticulos():New():Play() ) ;
      TOOLTIP  "Rep(o)rting";
      HOTKEY   "O" ;
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TArticuloLabelGenerator():New():Dialog() ) ;
      TOOLTIP  "Eti(q)uetas" ;
      HOTKEY   "Q";
      LEVEL    ACC_IMPR

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "gc_money2_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ChgPrc( oWndBrw ) ) ;
         TOOLTIP  "(C)ambiar precios" ;
         HOTKEY   "C";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( ReplaceCreator( oWndBrw, D():Articulos( nView ), aItmArt(), ART_TBL ) ) ;
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
         ACTION   ( lSelectAll( oWndBrw ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "Lbl" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, .f. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "SNDINT" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( changePublicar() );
      TOOLTIP  "P(u)blicar" ;
      HOTKEY   "U";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oTct RESOURCE "TACTIL" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( changeTactil() ) ;
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

   if ( "VI" $ appParamsMain() )

   DEFINE BTNSHELL RESOURCE "BMPEXPTAR" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( GetDisk() ) ;
      TOOLTIP  "Infortisa" ;
      LEVEL    ACC_EDIT

   end if
   
   DEFINE BTNSHELL oScript RESOURCE "gc_folder_document_" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oScript:Expand() ) ;
      TOOLTIP  "Scripts" ;

      ImportScript( oWndBrw, oScript, "Articulos", nView, oStock )  

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;
      LEVEL    ACC_EDIT

      /*DEFINE BTNSHELL RESOURCE "gc_form_plus2_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oDetCamposExtra:Play( ( D():Articulos( nView ) )->Codigo ) );
         TOOLTIP  "Campos extra" ;
         FROM     oRotor ;
         ALLOW    EXIT ;
         LEVEL    ACC_EDIT*/

      DEFINE BTNSHELL RESOURCE "gc_clipboard_empty_businessman_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( PedPrv( nil, oWnd, nil, ( D():Articulos( nView ) )->Codigo ) );
         TOOLTIP  "Añadir pedido a proveedor" ;
         FROM     oRotor ;
         ALLOW    EXIT ;
         LEVEL    ACC_EDIT
 
      DEFINE BTNSHELL RESOURCE "gc_document_empty_businessman_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( AlbPrv( nil, oWnd, nil, ( D():Articulos( nView ) )->Codigo ) );
         TOOLTIP  "Añadir albarán de proveedor" ;
         FROM     oRotor ;
         ALLOW    EXIT ;
         LEVEL    ACC_EDIT
 
      DEFINE BTNSHELL RESOURCE "gc_document_text_businessman_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( FacPrv( nil, oWnd, nil, ( D():Articulos( nView ) )->Codigo ) );
         TOOLTIP  "Añadir factura de proveedor" ;
         FROM     oRotor ;
         ALLOW    EXIT ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_power_drill_sat_user_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( SatCli( nil, oWnd, nil, ( D():Articulos( nView ) )->Codigo ) );
         TOOLTIP  "Añadir SAT de cliente" ;
         FROM     oRotor ;
         ALLOW    EXIT ;
         LEVEL    ACC_EDIT         

      DEFINE BTNSHELL RESOURCE "gc_notebook_user_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( PreCli( nil, oWnd, nil, ( D():Articulos( nView ) )->Codigo ) );
         TOOLTIP  "Añadir presupuesto de cliente" ;
         FROM     oRotor ;
         ALLOW    EXIT ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "GC_CLIPBOARD_EMPTY_USER_" OF oWndBrw ;
         ACTION   ( PedCli( nil, oWnd, nil, ( D():Articulos( nView ) )->Codigo ) );
         TOOLTIP  "Añadir pedido de cliente" ;
         FROM     oRotor ;
         ALLOW    EXIT ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_EMPTY_" OF oWndBrw ;
         ACTION   ( AlbCli( nil, oWnd, { "Artículo" => ( D():Articulos( nView ) )->Codigo } ) );
         TOOLTIP  "Añadir albarán de cliente" ;
         FROM     oRotor ;
         ALLOW    EXIT ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_USER_" OF oWndBrw ;
         ACTION   ( FactCli( nil, oWnd, { "Artículo" => ( D():Articulos( nView ) )->Codigo } ) );
         TOOLTIP  "Añadir factura de cliente" ;
         FROM     oRotor ;
         ALLOW    EXIT ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "GC_CASH_REGISTER_USER_" OF oWndBrw ;
         ACTION   ( FrontTpv( nil, oWnd, nil, ( D():Articulos( nView ) )->Codigo ) );
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

   if !empty( bOnInit )
      Eval( bOnInit )
   end if

   bOnInit     := nil

   CursorWE()

RETURN ( .t. )

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, cArticulo, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oFld
   local oBlock
   local oError
   local oBrwDiv
   local oBrwLeng
   local oBrwCodebar
   local aBtnDiv              := Array( 8 )
   local oBrwOfe
   local oBrwImg
   local oBrwStk
   local oBrwPrv
   local oBrwKit
   local bmpImage
   local oSayWeb              := Array(  6 )
   local oSay                 := Array( 23 )
   local cSay                 := Array( 23 )
   local oFnt
   local aBar                 := { "Ean13", "Code39", "Code128" }
   local aBnfSobre            := { "Costo", "Venta" }
   local cDivUse              := cDivEmp()
   local oGetSubCta
   local cGetSubCta           := ""
   local oGetSaldo
   local nGetSaldo            := 0
   local nGetDebe             := 0
   local nGetHaber            := 0
   local oGetCtaCom
   local cGetCtaCom           := ""
   local nDebCom              := 0
   local nHabCom              := 0
   local oGetSalCom
   local nGetSalCom           := 0
   local oGetCtaTrn
   local cGetCtaTrn           := ""
   local oGetSalTrn
   local nGetSalTrn           := 0
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
   local oBmpTemporada
   local oBmpEstado
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
   local oBmpTactil
   local oBmpAdicionales
   local aIdEtiquetas
   local aNombreEtiquetas
   local oImpComanda1
   local oImpComanda2
   local cImpComanda1
   local cImpComanda2
   local aNombreTarifas                      := aNombreTarifas()
   local cNombreTarifaWeb                    := aNombreTarifas[1]
   local oGetValNewImp
   local nGetValNewImp                       := 0
   local oGetSubcuentaVentaDevolucion
   local cGetSubcuentaVentaDevolucion
   local oGetSaldoSubcuentaVentaDevolucion
   local nGetSaldoSubcuentaVentaDevolucion   := 0
   local oGetSubcuentaCompraDevolucion
   local cGetSubcuentaCompraDevolucion
   local oGetSaldoSubcuentaCompraDevolucion
   local nGetSaldoSubcuentaCompraDevolucion  := 0

   CursorWait()

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if
/*
   oBlock                     := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
*/
   do case
   case nMode == APPD_MODE

      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nLabel"    ) ) ]     := 1
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nCtlStock" ) ) ]     := 1
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lLote"     ) ) ]     := .f.
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo"    ) ) ]     := Space( 18 )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva"   ) ) ]     := cDefIva()

      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc"   ) ) ]     := uFieldEmpresa( "lIvaInc" )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc2"  ) ) ]     := uFieldEmpresa( "lIvaInc" )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc3"  ) ) ]     := uFieldEmpresa( "lIvaInc" )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc4"  ) ) ]     := uFieldEmpresa( "lIvaInc" )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc5"  ) ) ]     := uFieldEmpresa( "lIvaInc" )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc6"  ) ) ]     := uFieldEmpresa( "lIvaInc" )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaPVer"  ) ) ]     := uFieldEmpresa( "lIvaInc" )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaWeb"   ) ) ]     := uFieldEmpresa( "lIvaInc" )

      if !empty( uFieldEmpresa( "cDefTem" ) )
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodTemp"  ) ) ]  := uFieldEmpresa( "cDefTem" )
      end if 

      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nImpCom1"  ) ) ]     := 1
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nImpCom2"  ) ) ]     := 1

      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nFacCnv"   ) ) ]     := 1

      if nDefBnf( 1 ) != 0
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef1"    ) ) ]  := nDefBnf( 1 )
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf1"     ) ) ]  := .t.
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr1"  ) ) ]  := nDefSbr( 1 )
      end if

      if nDefBnf( 2 ) != 0
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef2"    ) ) ]  := nDefBnf( 2 )
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf2"     ) ) ]  := .t.
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr2"  ) ) ]  := nDefSbr( 2 )
      end if

      if nDefBnf( 3 ) != 0
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef3"    ) ) ]  := nDefBnf( 3 )
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf3"     ) ) ]  := .t.
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr3"  ) ) ]  := nDefSbr( 3 )
      end if

      if nDefBnf( 4 ) != 0
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef4"    ) ) ]  := nDefBnf( 4 )
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf4"     ) ) ]  := .t.
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr4"  ) ) ]  := nDefSbr( 4 )
      end if

      if nDefBnf( 5 ) != 0
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef5"    ) ) ]  := nDefBnf( 5 )
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf5"     ) ) ]  := .t.
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr5"  ) ) ]  := nDefSbr( 5 )
      end if

      if nDefBnf( 6 ) != 0
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef6"    ) ) ]  := nDefBnf( 6 )
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf6"     ) ) ]  := .t.
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr6"  ) ) ]  := nDefSbr( 6 )
      end if

      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nDuracion" ) ) ]     := 0
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nTipDur" ) ) ]       := 1


      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ]      := Padr( GetPvProfString( "PROPIEDADES", "Propiedad1", "", cIniAplication() ), 20 )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ]      := Padr( GetPvProfString( "PROPIEDADES", "Propiedad2", "", cIniAplication() ), 20 )

   case nMode == DUPL_MODE

      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo"   ) ) ]      := NextKey( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], D():Articulos( nView ) )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CodeBar"  ) ) ]      := ""

   end case

   cCatOld                                                     := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodCat" ) ) ]
   cPrvOld                                                     := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cPrvHab" ) ) ]
   cImageOld                                                   := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cImagen" ) ) ]
   nGetValNewImp                                               := oNewImp:nValImp( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP" ) ) ] )

   if empty( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nColBtn" ) ) ] )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nColBtn" ) ) ]       := rgb( 255,255,255 )
   end if

   if empty( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nTipBar" ) ) ] )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nTipBar" ) ) ]       := 1
   else
      if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nTipBar" ) ) ] > 3
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nTipBar" ) ) ]    := 3
      end if
   end if

   cImpComanda1    := if( empty( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cTipImp1" ) ) ] ), "No imprimir", AllTrim( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cTipImp1" ) ) ] ) )
   cImpComanda2    := if( empty( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cTipImp2" ) ) ] ), "No imprimir", AllTrim( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cTipImp2" ) ) ] ) )

   cSay[7]         := aBar[ aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nTipBar" ) ) ] ]
   cSay[6]         := ""

   cSay[11]        := aBnfSobre[ Max( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr1" ) ) ], 1 ) ]
   cSay[12]        := aBnfSobre[ Max( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr2" ) ) ], 1 ) ]
   cSay[13]        := aBnfSobre[ Max( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr3" ) ) ], 1 ) ]
   cSay[14]        := aBnfSobre[ Max( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr4" ) ) ], 1 ) ]
   cSay[15]        := aBnfSobre[ Max( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr5" ) ) ], 1 ) ]
   cSay[16]        := aBnfSobre[ Max( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr6" ) ) ], 1 ) ]

   cSubCtaAnt        := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCtaVta" ) ) ]
   cSubCtaAntCom     := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCtaCom" ) ) ]
   cCodigoFamilia    := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ]

   aIdEtiquetas      := RelacionesEtiquetasModel():getRelationsOfEtiquetas( "EMP" + cCodEmp() + "Articulo", aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ] )

   aNombreEtiquetas  := EtiquetasModel():translateIdsToNames( aIdEtiquetas )

   /*
   Filtros para los stocks-----------------------------------------------------
   */

   CursorWE()

   /*
   Cargamos los precios en sus variables---------------------------------------
	*/

   DEFINE DIALOG oDlg ;
      RESOURCE    "Articulo" ;
      TITLE       LblTitle( nMode ) + "artículo : " + Rtrim( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Nombre" ) ) ] )

      REDEFINE FOLDER oFld;
         ID       300 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "&Precios",;
                  "&Adicionales",;
                  "&Táctil",;
                  "&Idiomas",;
                  "Imagenes",;
                  "P&ropiedades",;
                  "&Logística",;
                  "&Stocks",;
                  "Co&ntabilidad",;
                  "&Ofertas",;
                  "&Escandallos",;
                  "&Web";
         DIALOGS  "ART_1",;
                  "ART_5",;
                  "ART_Adicional",;
                  "ART_Tactil",;
                  "ART_2",;
                  "ART_12",;
                  "ART_20",;
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
         RESOURCE "gc_object_cube_48" ;
         TRANSPARENT ;
         OF       fldGeneral

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ];
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ];
			ID 		110 ;
         PICTURE  "@!" ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( CheckValid( aGet[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], D():Articulos( nView ), 1, nMode ) ) ;
         BITMAP   "Bot" ;
         ON HELP  ( aGet[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ]:cText( NextKey( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], D():Articulos( nView ) ) ) ) ;
         OF       fldGeneral

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "Nombre" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Nombre" ) ) ];
			MEMO ;
         ID       130 ;
         ON CHANGE( ActTitle( nKey, nFlags, Self, nMode, oDlg ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

   /*
   Codigos de barras___________________________________________________________
	*/

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "Matriz" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Matriz" ) ) ] ;
         ID       340 ;
         BITMAP   "gc_recycle_16" ;
         ON HELP  ( generateMatrizCodigoBarras( aGet[ ( D():Articulos( nView ) )->( fieldpos( "Matriz" ) ) ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( validMatrizCodigoBarras( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Matriz" ) ) ] ) );
         OF       fldGeneral

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

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "FAMILIA" ) ) ] ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "FAMILIA" ) ) ] ;
	   ID 		160 ;
      VALID    ( ExpFamilia( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "FAMILIA" ) ) ], oSay[ 3 ], aGet ) );
      BITMAP   "LUPA" ;
      OF       fldGeneral

   if uFieldEmpresa( "lBRFAMTRE" )
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "FAMILIA" ) ) ]:bHelp  := {|| browseHashFamilia( aGet[ ( D():Articulos( nView ) )->( fieldpos( "FAMILIA" ) ) ] ) }
   else
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "FAMILIA" ) ) ]:bHelp  := {|| BrwFamilia( aGet[ ( D():Articulos( nView ) )->( fieldpos( "FAMILIA" ) ) ], oSay[ 3 ] ) }
   end if

   if ( "RISI" $ appParamsMain() )
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "FAMILIA" ) ) ]:bWhen    := {|| nMode == APPD_MODE .or. nMode == DUPL_MODE }
   else
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "FAMILIA" ) ) ]:bWhen    := {|| nMode != ZOOM_MODE }
   end if      

   REDEFINE GET   oSay[3];
      VAR      cSay[3];
		WHEN 		( .F. );
		ID 		161 ;
      OF       fldGeneral

   REDEFINE SAY oNombre VAR "Tipo artículo";
      ID       888 ;
      OF       fldGeneral

   REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCODTIP" ) ) ] ;
      VAR      aTmp[( D():Articulos( nView ) )->( fieldpos( "CCODTIP" ) ) ] ;
      ID       270 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      VALID    ( oTipArt:Existe( aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCODTIP" ) ) ], oSay[9] ) );
      ON HELP  ( oTipArt:Buscar( aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCODTIP" ) ) ] ) ) ;
      BITMAP   "LUPA" ;
      OF       fldGeneral

   oTagsEver            := TTagEver():Redefine( 100, fldGeneral, nil, aNombreEtiquetas ) 
   oTagsEver:lOverClose := .t.

   TBtnBmp():ReDefine( 101, "Lupa",,,,,{|| getEtiquetasBrowse( oTagsEver:getItems() ) }, fldGeneral, .f., , .f.,  )

   REDEFINE GET oSay[9] VAR cSay[9] ;
      ID       271 ;
      SPINNER ;
      WHEN     ( .f. ) ;
      OF       fldGeneral

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFab" ) ) ] ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodFab" ) ) ] ;
      ID       390 ;
      IDTEXT   391 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      BITMAP   "LUPA" ;
      OF       fldGeneral

   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFab" ) ) ]:bValid := {|| ( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFab" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodFab" ) ) ], oFabricante:GetAlias() ) ), .t. ) }
   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFab" ) ) ]:bHelp  := {|| oFabricante:Buscar( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFab" ) ) ] ) }
  
   REDEFINE SAY ;
         PROMPT   getConfigTraslation( "Familia" );
         ID       900 ;
         OF       fldGeneral

   REDEFINE SAY ;
         PROMPT   getConfigTraslation( "Temporada" );
         ID       800 ;
         OF       fldGeneral

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodTemp" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodTemp" ) ) ] ;
         ID       355 ;
         IDTEXT   356 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cTemporada( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodTemp" ) ) ], dbfTemporada, aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodTemp" ) ) ]:oHelpText, oBmpTemporada ) ) ;
         ON HELP  ( brwTemporada( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodTemp" ) ) ], aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodTemp" ) ) ]:oHelpText, oBmpTemporada ) ) ;
         BITMAP   "LUPA" ;
         OF       fldGeneral

   REDEFINE BITMAP oBmpTemporada ;
         ID       357 ;
         TRANSPARENT ;
         OF       fldGeneral

   REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodEst" ) ) ] VAR aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodEst" ) ) ] ;
         ID       400 ;
         IDTEXT   401 ;         
         WHEN     ( nMode == APPD_MODE .or. oUser():lAdministrador() ) ;
         VALID    ( cEstadoArticulo( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodEst" ) ) ], D():EstadoArticulo( nView ), aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodEst" ) ) ]:oHelpText, oBmpEstado ) ) ;
         ON HELP  ( BrwEstadoArticulo( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodEst" ) ) ], aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodEst" ) ) ]:oHelpText, oBmpEstado ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

   REDEFINE BITMAP oBmpEstado ;
         ID       402 ;
         TRANSPARENT ;
         OF       oFld:aDialogs[1]

   REDEFINE SAY ;
         PROMPT   getConfigTraslation( "Ubicación" );
         ID       221 ;
         OF       fldGeneral

   REDEFINE GET aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cDesUbi" ) ) ] ;
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       fldGeneral

   bmpImage             := TImage():ReDefine( 500,, cFileBmpName( cImgArticulo( aTmp ) ), oDlg, , , .f., .t., , , .f. )

   bmpImage:SetColor( , GetSysColor( 15 ) )
   bmpImage:bLClicked   := {|| ShowImage( bmpImage ) }
   bmpImage:bRClicked   := {|| ShowImage( bmpImage ) }

   /*
   REDEFINE CHECKBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "lTerminado" ) ) ];
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lTerminado" ) ) ];
         ID       620 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral
   */

   /*
   Adicional------------------------------------------------------------------------
   */

   REDEFINE BITMAP oBmpAdicionales ;
         ID       500 ;
         RESOURCE "gc_information_48" ;
         TRANSPARENT ;
         OF       fldAdicionales

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lLote" ) ) ] ;
         ID       600 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldAdicionales

   REDEFINE GET   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cLote" ) ) ] ;
         ID       610 ;
         WHEN     ( nMode != ZOOM_MODE .AND. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lLote" ) ) ] );
         OF       fldAdicionales

   REDEFINE CHECKBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "lObs" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lObs" ) ) ];
         ID       139 ;
         OF       fldAdicionales

   REDEFINE CHECKBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "lNumSer" ) ) ];
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lNumSer" ) ) ];
         ID       136 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldAdicionales

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lAutSer" ) ) ];
         ID       138 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldAdicionales

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nDuracion" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nDuracion" ) ) ] ;
         ID       250 ;
         SPINNER ;
         MIN      0 ;
         MAX      100 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       fldAdicionales

   REDEFINE COMBOBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "nTipDur" ) ) ];
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nTipDur" ) ) ];
         ITEMS    { "Dia (s)", "Mes (es)", "Año (s)" };
         ID       251 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldAdicionales

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lTipAcc" ) ) ] ;
         ID       280 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldAdicionales

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lFacCnv" ) ) ] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( ChangeFactorConversion( aTmp, aGet ) ) ;
         OF       fldAdicionales

   REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "nFacCnv" ) ) ] ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nFacCnv" ) ) ] ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lFacCnv" ) ) ] );
         PICTURE  "@E 999,999.999999" ;
         OF       fldAdicionales

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodEdi" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodEdi" ) ) ] ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       fldAdicionales

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cRefAux" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cRefAux" ) ) ] ;
         ID       290 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       fldAdicionales

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cRefAux2" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cRefAux2" ) ) ] ;
         ID       291 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       fldAdicionales

   /*
   Tactil----------------------------------------------------------------------
   */

   REDEFINE BITMAP oBmpImagenes ;
         ID       500 ;
         RESOURCE "gc_hand_touch_48" ;
         TRANSPARENT ;
         OF       fldTactil

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LINCTCL" ) ) ] ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldTactil

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nPosTpv" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nPosTpv" ) ) ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nPosTpv" ) ) ] >= 0 .and. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nPosTpv" ) ) ] <= 999 ) ;
         PICTURE  "999" ;
         SPINNER ;
         MIN      ( 0 ) ;
         MAX      ( 99 ) ;
         ID       225 ;
         OF       fldTactil

   REDEFINE GET   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CDESTCL" ) ) ] ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldTactil

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nColBtn" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nColBtn" ) ) ] ;
         ID       290 ;
         COLOR    aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nColBtn" ) ) ], aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nColBtn" ) ) ] ;
         BITMAP   "gc_photographic_filters_16" ;
         ON HELP  ( ColorFam( aGet[ ( D():Articulos( nView ) )->( fieldpos( "nColBtn" ) ) ] ) ) ;
         OF       fldTactil

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cImagen" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cImagen" ) ) ] ;
         BITMAP   "Lupa" ;
         ON HELP  ( GetBmp( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cImagen" ) ) ], bmpImage ) ) ;
         ON CHANGE( ChgBmp( cImgArticulo ( aTmp ), bmpImage ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( ChgBmp( cImgArticulo ( aTmp ), bmpImage ) ) ;
         ID       220 ;
         OF       fldTactil

   REDEFINE COMBOBOX oImpComanda1 VAR cImpComanda1 ;
      ITEMS       aTiposImpresoras ;
      ID          450 ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          fldTactil

   REDEFINE COMBOBOX oImpComanda2 VAR cImpComanda2 ;
      ITEMS       aTiposImpresoras ;
      ID          460 ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          fldTactil

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldPos( "cOrdOrd" ) ) ] ;
      VAR         aTmp[ ( D():Articulos( nView ) )->( fieldPos( "cOrdOrd" ) ) ] ;
      BITMAP      "Lupa" ;
      ID          470 ;
      IDTEXT      471 ;
      VALID       ( oOrdenComanda:Existe( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cOrdOrd" ) ) ], aGet[ ( D():Articulos( nView ) )->( fieldPos( "cOrdOrd" ) ) ]:oHelpText ) );
      ON HELP     ( oOrdenComanda:Buscar( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cOrdOrd" ) ) ] ) ) ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          fldTactil

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lPeso" ) ) ] ;
      ID          480 ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          fldTactil

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldPos( "cMenu" ) ) ] ;
      VAR         aTmp[ ( D():Articulos( nView ) )->( fieldPos( "cMenu" ) ) ] ;
      BITMAP      "Lupa" ;
      ID          490 ;
      IDTEXT      491 ;
      VALID       ( oTpvMenu:Existe( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cMenu" ) ) ], aGet[ ( D():Articulos( nView ) )->( fieldPos( "cMenu" ) ) ]:oHelpText ) );
      ON HELP     ( oTpvMenu:Buscar( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cMenu" ) ) ] ) ) ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          fldTactil

   /*
	Segunda Caja de Dialogo del Folder
	---------------------------------------------------------------------------
   */

   REDEFINE BITMAP oBmpPrecios ;
         ID       500 ;
         RESOURCE "gc_symbol_euro_48" ;
         TRANSPARENT ;
         OF       fldPrecios

   REDEFINE GET aGet[( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ] ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ] ;
      ID       800;
      PICTURE  "@!" ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      VALID    (  cTiva(   aGet[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ], D():TiposIva( nView ), oSay[2] ),;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta1" ) ) ]:lValid(),;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta2" ) ) ]:lValid(),;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta3" ) ) ]:lValid(),;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta4" ) ) ]:lValid(),;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta5" ) ) ]:lValid(),;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta6" ) ) ]:lValid(), .t. ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwIva( aGet[( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ], nil , oSay[2] ) ) ;
      OF       fldPrecios

   REDEFINE GET oSay[2] VAR cSay[2] ;
      WHEN     ( .F. );
      ID       801 ;
      OF       fldPrecios

   REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP" ) ) ] VAR aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP" ) ) ] ;
      ID       810;
      PICTURE  "@!" ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ON CHANGE( changeImpuestoEspecial( oGetValNewImp, aTmp ) );
      VALID    ( oNewImp:Existe( aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP" ) ) ], oSay[ 10 ], "cNomImp", .t., .t., "0" ), changeImpuestoEspecial( oGetValNewImp, aTmp ) );
      ON HELP  ( oNewImp:Buscar( aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP" ) ) ], "cCodImp" ) ) ;
      BITMAP   "LUPA" ;
      OF       fldPrecios

   REDEFINE GET oSay[10] VAR cSay[10] ;
      WHEN     ( .F. );
      ID       811 ;
      OF       fldPrecios

   REDEFINE GET oGetValNewImp VAR nGetValNewImp ;
      ID       812 ;
      PICTURE  cPouDiv ;
      WHEN     ( .f. ) ;
      OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "pCosto" ) ) ] ;
      VAR         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto" ) ) ] ;
      ID          110 ;
      WHEN        ( !lEscandallo( aTmp ) .and. nMode != ZOOM_MODE ) ;
      VALID       ( ValidPrecioCosto( aGet, oSayWeb ) ) ;
      SPINNER ;
      PICTURE     cPinDiv ;
      OF          fldPrecios ;

   REDEFINE SAY oCosto ;
      PROMPT   nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ;
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
   
   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC" ) ) ] ;
      ID       821 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldPrecios

   REDEFINE CHECKBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "lBnf1" ) ) ] ;
      VAR            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf1" ) ) ] ;
      ID       150 ;
		WHEN 		( nMode != ZOOM_MODE ) ;
      OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef1" ) ) ] ;
      VAR         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef1" ) ) ] ;
      ID       160 ;
		SPINNER ;
      WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf1" ) ) ] .AND. nMode != ZOOM_MODE ) ;
      VALID    ( lCalPre(   oSay[ 11 ]:nAt <= 1,;
                           if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                           aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf1"   ) ) ],;
                           aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef1"  ) ) ],;
                           aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta1" ) ) ],;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva1") ) ],;
                           nDecDiv,;
                           aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                           oSayWeb[ 1 ] ) ) ;
      PICTURE  "@E 999.99" ;
      OF       fldPrecios

   REDEFINE COMBOBOX oSay[ 11 ] VAR cSay[ 11 ] ;
      ITEMS    aBnfSobre ;
      ID       165 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ON CHANGE(  if (  aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf1"  ) ) ],;
                        aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef1" ) ) ]:lValid(),;
                     ),;
                  if (  aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ],;
                        aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva1") ) ]:lValid(),;
                        aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta1" ) ) ]:lValid() ) );
      OF       fldPrecios

   REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA1" ) ) ] ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA1" ) ) ] ;
      ID       170 ;
      WHEN     ( stdCol( !aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC" ) ) ], nMode ) ) ;
      VALID    ( CalBnfPts(   oSay[ 11 ]:nAt <= 1,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC" ) ) ],;
                              if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA1" ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF1"  ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA" ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA1") ) ],;
                              nDecDiv,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP" ) ) ],;
                              oSayWeb[ 1 ] ) );
      PICTURE  cPouDiv ;
      OF       fldPrecios

   REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA1" ) ) ] ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA1" ) ) ] ;
      ID       180 ;
      WHEN     ( stdCol( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
      VALID    ( CalBnfIva(   oSay[ 11 ]:nAt <= 1,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ],;
                              if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA1") ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF1"  ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA" ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA1" ) ) ],;
                              nDecDiv,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP" ) ) ],;
                              oSayWeb[ 1 ] ) );
      PICTURE  cPouDiv ;
      OF       fldPrecios

   /*
   TARIFA2 ______________________________________________________________________________
	*/

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC2" ) ) ] ;
      ID       822 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldPrecios

   REDEFINE CHECKBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "LBNF2" ) ) ] ;
      VAR            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF2" ) ) ] ;
      ID       190 ;
		WHEN 		( nMode != ZOOM_MODE ) ;
      OF       fldPrecios

   REDEFINE COMBOBOX oSay[ 12 ] VAR cSay[ 12 ] ;
         ITEMS    aBnfSobre ;
         ID       205 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE(  if (  aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf2"  ) ) ],;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef2" ) ) ]:lValid(),;
                        ),;
                     if (  aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc2" ) ) ],;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva2") ) ]:lValid(),;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta2" ) ) ]:lValid() ) );
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF2" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF2" ) ) ] ;
         ID       200 ;
         SPINNER ;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF2" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 12 ]:nAt <= 1,;
                              if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF2"    ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF2"   ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA2"  ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA2" ) ) ],;
                              nDecDiv,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                              oSayWeb[ 2 ] ) );
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA2" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA2" ) ) ] ;
         ID       210 ;
         WHEN     ( stdCol( !aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC2" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 12 ]:nAt <= 1,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC2"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA2"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF2"   ) ) ],;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA2" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 2 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA2" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA2" ) ) ] ;
			ID 		220 ;
         WHEN     ( stdCol( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC2" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 12 ]:nAt <= 1,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC2"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA2" ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF2"   ) ) ],;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA2"  ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 2 ] ) );
			PICTURE 	cPouDiv ;
         OF       fldPrecios

   /*
   TARIFA3 ______________________________________________________________________________
	*/

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC3" ) ) ] ;
      ID       823 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldPrecios

   REDEFINE CHECKBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "LBNF3" ) ) ] ;
      VAR            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF3" ) ) ] ;
      ID       230 ;
		WHEN 		( nMode != ZOOM_MODE ) ;
      OF       fldPrecios

   REDEFINE COMBOBOX oSay[ 13 ] VAR cSay[ 13 ] ;
         ITEMS    aBnfSobre ;
         ID       245 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE(  if (  aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf3"  ) ) ],;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef3" ) ) ]:lValid(),;
                        ),;
                     if (  aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc3" ) ) ],;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva3") ) ]:lValid(),;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta3" ) ) ]:lValid() ) );
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF3" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF3" ) ) ] ;
         ID       240 ;
			SPINNER ;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF3" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 13 ]:nAt <= 1,;
                              if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF3"    ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF3"   ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA3"  ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA3" ) ) ],;
                              nDecDiv,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                              oSayWeb[ 3 ] ) );
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA3" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA3" ) ) ] ;
         ID       250 ;
         WHEN     ( stdCol( !aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC3" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 13 ]:nAt <= 1,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC3"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA3"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF3"   ) ) ],;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA3" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 3 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA3" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA3" ) ) ] ;
         ID       260 ;
         WHEN     ( stdCol( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC3" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 13 ]:nAt <= 1,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC3"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA3" ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF3"   ) ) ],;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA3"  ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 3 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   /*
   TARIFA4 ______________________________________________________________________________
	*/

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC4" ) ) ] ;
      ID       824 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldPrecios

   REDEFINE CHECKBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "LBNF4" ) ) ] ;
         VAR         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF4" ) ) ] ;
         ID       270 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       fldPrecios

   REDEFINE COMBOBOX oSay[ 14 ] VAR cSay[ 14 ] ;
         ITEMS    aBnfSobre ;
         ID       285 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE(  if (  aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf4"  ) ) ],;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef4" ) ) ]:lValid(),;
                        ),;
                     if (  aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc4" ) ) ],;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva4") ) ]:lValid(),;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta4" ) ) ]:lValid() ) );
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF4" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF4" ) ) ] ;
         ID       280 ;
			SPINNER ;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF4" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 14 ]:nAt <= 1,;
                              if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF4"    ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF4"   ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA4"  ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA4" ) ) ],;
                              nDecDiv,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                              oSayWeb[ 4 ] ) );
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA4" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA4" ) ) ] ;
         ID       290 ;
         WHEN     ( stdCol( !aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC4" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 14 ]:nAt <= 1,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC4"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA4"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF4"   ) ) ],;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA4" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 4 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA4" ) ) ];
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA4" ) ) ] ;
         ID       300 ;
         WHEN     ( stdCol( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC4" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 14 ]:nAt <= 1,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC4"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA4" ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF4"   ) ) ],;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA4"  ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 4 ] ) );
			PICTURE 	cPouDiv ;
         OF       fldPrecios

   /*
   TARIFA5 ______________________________________________________________________________
	*/

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC5" ) ) ] ;
      ID       825 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldPrecios

   REDEFINE CHECKBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "LBNF5" ) ) ] ;
         VAR         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF5" ) ) ] ;
         ID       310 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       fldPrecios

   REDEFINE COMBOBOX oSay[ 15 ] VAR cSay[ 15 ] ;
         ITEMS    aBnfSobre ;
         ID       325 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE(  if (  aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf5"  ) ) ],;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef5" ) ) ]:lValid(),;
                        ),;
                     if (  aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc5" ) ) ],;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva5") ) ]:lValid(),;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta5" ) ) ]:lValid() ) );
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF5" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF5" ) ) ] ;
         ID       320 ;
			SPINNER ;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF5" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 15 ]:nAt <= 1,;
                              if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF5"    ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF5"   ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA5"  ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA5" ) ) ],;
                              nDecDiv,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                              oSayWeb[ 5 ] ) );
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA5" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA5" ) ) ] ;
         ID       330 ;
         WHEN     ( stdCol( !aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC5" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 15 ]:nAt <= 1,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC5"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA5"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF5"   ) ) ],;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA5" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 5 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA5" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA5" ) ) ] ;
         ID       340 ;
         WHEN     ( stdCol( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC5" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 15 ]:nAt <= 1,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC5"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA5" ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF5" ) ) ],;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA" ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA5" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP" ) ) ],;
                                 oSayWeb[ 5 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios


   /*
   TARIFA6 ______________________________________________________________________________
	*/

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC6" ) ) ] ;
      ID       826 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldPrecios

   REDEFINE CHECKBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "LBNF6" ) ) ] ;
         VAR         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF6" ) ) ] ;
         ID          350 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          fldPrecios

   REDEFINE COMBOBOX oSay[ 16 ] VAR cSay[ 16 ] ;
         ITEMS       aBnfSobre ;
         ID          365 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         ON CHANGE   (  if (  aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf6"  ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef6" ) ) ]:lValid(),;
                           ),;
                        if (  aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc6" ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva6") ) ]:lValid(),;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta6" ) ) ]:lValid() ) );
         OF          fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef6" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef6" ) ) ] ;
         ID       360 ;
			SPINNER ;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF6" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 16 ]:nAt <= 1,;
                              if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF6"    ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF6"   ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA6"  ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA6" ) ) ],;
                              nDecDiv,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                              oSayWeb[ 6 ] ) );
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA6" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA6" ) ) ] ;
         ID       370 ;
         WHEN     ( stdCol( !aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC6" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 16 ]:nAt <= 1,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC6"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA6"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF6"   ) ) ],;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA6" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 6 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA6" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA6" ) ) ] ;
         ID       380 ;
         WHEN     ( stdCol( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC6" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 16 ]:nAt <= 1,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAINC6"  ) ) ],;
                                 if( !lEscandallo( aTmp ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ], nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit ) ) ,;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA6" ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF6"   ) ) ],;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA6"  ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP"  ) ) ],;
                                 oSayWeb[ 6 ] ) );
         PICTURE  cPouDiv ;
         OF       fldPrecios

   /*
   Punto Verde_______________________________________________________________
	*/

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAPVER" ) ) ] ;
      ID       827 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "NPNTVER1" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NPNTVER1" ) ) ] ;
         ID       390 ;
         WHEN     ( stdCol( !aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAPVER" ) ) ], nMode ) ) ;
         VALID    ( aGet[ ( D():Articulos( nView ) )->( fieldpos( "NPNVIVA1" ) ) ]:cText( ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NPNTVER1" ) ) ] * nIva( D():TiposIva( nView ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA" ) )] ) / 100 ) + aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NPNTVER1" ) ) ] ), .t. ) ;
         PICTURE  cPpvDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "NPNVIVA1" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NPNVIVA1" ) ) ] ;
         ID       400 ;
         WHEN     ( stdCol( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LIVAPVER" ) ) ], nMode ) ) ;
         VALID    ( aGet[ ( D():Articulos( nView ) )->( fieldpos( "NPNTVER1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NPNVIVA1" ) ) ] / ( 1 + nIva( D():TiposIva( nView ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TIPOIVA" ) )] ) / 100 ) ), .t. ) ;
         PICTURE  cPpvDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVPREC" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVPREC" ) ) ] ;
         ID       120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  cPouDiv ;
         OF       fldPrecios

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "NRENMIN" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NRENMIN" ) ) ] ;
         ID       600 ;
         SPINNER  MIN 0 MAX 100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

      /*
      Primer descuento---------------------------------------------------------
      */

      REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nDtoArt1" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nDtoArt1" ) ) ] ;
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

      REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nDtoArt2" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nDtoArt2" ) ) ] ;
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

      REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nDtoArt3" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nDtoArt3" ) ) ] ;
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

      REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nDtoArt4" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nDtoArt4" ) ) ] ;
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

      REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nDtoArt5" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nDtoArt5" ) ) ] ;
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

      REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nDtoArt6" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nDtoArt6" ) ) ] ;
         ID       460 ;
			SPINNER ;
         MIN      0 ;
         MAX      100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       fldPrecios

      /*REDEFINE CHECKBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "lMarAju" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lMarAju" ) ) ] ;
         ID       470 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( D():Articulos( nView ))->( FieldPos( "lIvaInc" ) ) ] );
         OF       fldPrecios

      REDEFINE COMBOBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "cMarAju" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cMarAju" ) ) ] ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( D():Articulos( nView ))->( FieldPos( "lIvaInc" ) ) ] .and. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lMarAju" ) ) ] );
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

         aGet[ ( D():Articulos( nView ) )->( fieldpos( "cMarAju" ) ) ]:bChange  := {||   aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva1" ) ) ]:lValid(),;
                                                                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva2" ) ) ]:lValid(),;
                                                                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva3" ) ) ]:lValid(),;
                                                                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva4" ) ) ]:lValid(),;
                                                                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva5" ) ) ]:lValid(),;
                                                                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva6" ) ) ]:lValid() }*/

      /*
      Tercera ventana----------------------------------------------------------
      */

      REDEFINE BUTTON;
         ID       510 ;
         OF       fldDescripciones;
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ( WinAppRec( oBrwLeng, bEdtLeng, dbfTmpLeng, , , aTmp ) )

      REDEFINE BUTTON;
         ID       511 ;
         OF       fldDescripciones;
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ( WinEdtRec( oBrwLeng, bEdtLeng, dbfTmpLeng, , , aTmp ) )

      REDEFINE BUTTON;
         ID       512 ;
         OF       fldDescripciones;
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ( dbDelRec( oBrwLeng, dbfTmpLeng ) )

      oBrwLeng                   := IXBrowse():New( fldDescripciones )

      oBrwLeng:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLeng:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLeng:lHScroll          := .f.
      oBrwLeng:cAlias            := dbfTmpLeng
      oBrwLeng:nMarqueeStyle     := 6
      oBrwLeng:cName             := "Articulos.Lenguajes"

      oBrwLeng:CreateFromResource( 100 )

      with object ( oBrwLeng:AddCol() )
         :cHeader                := "Lenguaje"
         :bEditValue             := {|| AllTrim( ( dbfTmpLeng )->cCodLen ) + " - " + RetFld( ( dbfTmpLeng )->cCodLen, D():Lenguajes( nView ), "cNomLen" ) }
         :nWidth                 := 200
      end with

      with object ( oBrwLeng:AddCol() )
         :cHeader                := "Descripción"
         :bEditValue             := {|| ( dbfTmpLeng )->cDesTik }
         :nWidth                 := 400
      end with

      with object ( oBrwLeng:AddCol() )
         :cHeader                := "Descripción larga"
         :bEditValue             := {|| ( dbfTmpLeng )->cDesArt }
         :nWidth                 := 400
         :lHide                  := .t.
      end with

      if nMode != ZOOM_MODE
         oBrwLeng:bLDblClick  := {|| WinEdtRec( oBrwLeng, bEdtLeng, dbfTmpLeng, , , aTmp ) }
      end if

      REDEFINE BITMAP oBmpDescripciones ;
         ID       500 ;
         RESOURCE "gc_user_message_48" ; 
         TRANSPARENT ;
         OF       fldDescripciones

      REDEFINE GET aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Descrip" ) ) ] MEMO;
			ID 		210 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       fldTactil

      REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "mComent" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "mComent" ) ) ];
         ID       370 ;
			MEMO ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldTactil

      REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lMosCom" ) ) ] ;
         ID       380 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldTactil

      /*
      Fechas-------------------------------------------------------------------
      */

      REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "LastChg" ) ) ] ;
         VAR         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LastChg" ) ) ] ;
         ID          195 ;
         WHEN        ( .f. ) ;
         OF          fldLogistica

      REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "dFecChg" ) ) ] ;
         VAR         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "dFecChg" ) ) ] ;
         ID          196 ;
         WHEN        ( .f. ) ;
         OF          fldLogistica

      REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "dFecLgt" ) ) ] ;
         VAR         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "dFecLgt" ) ) ] ;
         ID          197 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          fldLogistica

      /*
      Precios por propiedades--------------------------------------------------
      */

      REDEFINE BITMAP oBmpPropiedades ;
         ID       510 ;
         RESOURCE "gc_bookmarks_48" ;
         TRANSPARENT ;
         OF       fldPropiedades

      /*
      Propiedades del articulo----------------------------------------------------
      */

      REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ] ;
         VAR         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ] ;
         ID          360 ;
         IDTEXT      361 ;
         PICTURE     "@!" ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         BITMAP      "Lupa" ;
         OF          fldPropiedades

      aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ]:bValid  := {|| cProp( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ], aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ]:oHelpText ) }
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ]:bHelp   := {|| brwProp( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ], aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ]:oHelpText ) }

      /*
      PropiedadesController();
         :Instance();
         :createEditControl(  @aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ],;
                              {  "idGet"  => 360,;
                                 "idText" => 361,;
                                 "dialog" => fldPropiedades,;
                                 "when"   => {|| ( nMode != ZOOM_MODE ) } } )
      */

      TBtnBmp():ReDefine( 362, "gc_document_text_pencil_12",,,,,{|| brwSelectPropiedad( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ], @aTmp[ ( D():Articulos( nView ) )->( fieldpos( "mValPrp1" ) ) ] ) }, fldPropiedades, .f., , .f., "Seleccionar propiedades" )

      REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ] ;
         VAR         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ] ;
         ID          370 ;
         IDTEXT      371 ;
         PICTURE     "@!" ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         BITMAP      "Lupa" ;
         OF          fldPropiedades

      aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ]:bValid  := {|| cProp( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ], aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ]:oHelpText ) }
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ]:bHelp   := {|| brwProp( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ], aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ]:oHelpText ) }

      TBtnBmp():ReDefine( 372, "gc_document_text_pencil_12",,,,,{|| brwSelectPropiedad( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ], @aTmp[ ( D():Articulos( nView ) )->( fieldpos( "mValPrp2" ) ) ] ) }, fldPropiedades, .f., , .f., "Seleccionar propiedades" )

      // Browse de propiedades y precios---------------------------------------

      oBrwDiv                 := IXBrowse():New( fldPropiedades )

      oBrwDiv:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDiv:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDiv:cAlias          := dbfTmpVta
      oBrwDiv:nMarqueeStyle   := 6
      oBrwDiv:cName           := "Articulos.Propiedades"

      with object ( oBrwDiv:AddCol() )
         :cHeader          := "Prop. 1"
         :cSortOrder       := "cValPr1"
         :bEditValue       := {|| ( dbfTmpVta )->cValPr1 }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
      end with

      with object ( oBrwDiv:AddCol() )
         :cHeader          := "Nombre propiedad 1"
         :bEditValue       := {|| nombrePropiedad( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ], ( dbfTmpVta )->cValPr1, nView ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      if retFld( aTmp[ ( D():Articulos( nView ) )->( FieldPos( "cCodPrp1" ) ) ], dbfPro, "lColor" )

         with object ( oBrwDiv:AddCol() )
            :cHeader       := "C. Prp 1"
            :bStrData      := {|| "" }
            :nWidth        := 16
            :bClrStd       := {|| { nRGB( 0, 0, 0), retFld( aTmp[ ( D():Articulos( nView ) )->( FieldPos( "cCodPrp1" ) ) ] + ( dbfTmpVta )->cValPr1, dbfTblPro, "nColor" ) } }
            :bClrSel       := {|| { nRGB( 0, 0, 0), retFld( aTmp[ ( D():Articulos( nView ) )->( FieldPos( "cCodPrp1" ) ) ] + ( dbfTmpVta )->cValPr1, dbfTblPro, "nColor" ) } }
            :bClrSelFocus  := {|| { nRGB( 0, 0, 0), retFld( aTmp[ ( D():Articulos( nView ) )->( FieldPos( "cCodPrp1" ) ) ] + ( dbfTmpVta )->cValPr1, dbfTblPro, "nColor" ) } }
         end with

      end if

      with object ( oBrwDiv:AddCol() )
         :cHeader          := "Prop. 2"
         :cSortOrder       := "cValPr2"
         :bEditValue       := {|| ( dbfTmpVta )->cValPr2 }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
      end with

      with object ( oBrwDiv:AddCol() )
         :cHeader          := "Nombre propiedad 2"
         :bEditValue       := {|| nombrePropiedad( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ], ( dbfTmpVta )->cValPr2, nView ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      if retFld( aTmp[ ( D():Articulos( nView ) )->( FieldPos( "cCodPrp2" ) ) ], dbfPro, "lColor" )

         with object ( oBrwDiv:AddCol() )
            :cHeader       := "C. Prp2"
            :bStrData      := {|| "" }
            :nWidth        := 16
            :bClrStd       := {|| { nRGB( 0, 0, 0), retFld( aTmp[ ( D():Articulos( nView ) )->( FieldPos( "cCodPrp2" ) ) ] + ( dbfTmpVta )->cValPr2, dbfTblPro, "nColor" ) } }
            :bClrSel       := {|| { nRGB( 0, 0, 0), retFld( aTmp[ ( D():Articulos( nView ) )->( FieldPos( "cCodPrp2" ) ) ] + ( dbfTmpVta )->cValPr2, dbfTblPro, "nColor" ) } }
            :bClrSelFocus  := {|| { nRGB( 0, 0, 0), retFld( aTmp[ ( D():Articulos( nView ) )->( FieldPos( "cCodPrp2" ) ) ] + ( dbfTmpVta )->cValPr2, dbfTblPro, "nColor" ) } }
         end with

      end if

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
      WHEN     ( !empty( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ] ) .and. nMode != ZOOM_MODE );
      ACTION   ( WinAppRec( oBrwDiv, bEdtVta, dbfTmpVta, , , aTmp ) )

   REDEFINE BUTTON aBtnDiv[ 2 ];
		ID 		501 ;
      OF       fldPropiedades;
      WHEN     ( nMode != ZOOM_MODE );
      ACTION   ( WinEdtRec( oBrwDiv, bEdtVta, dbfTmpVta, , , aTmp ) )

   REDEFINE BUTTON aBtnDiv[ 3 ];
		ID 		502 ;
      OF       fldPropiedades;
      WHEN     ( nMode != ZOOM_MODE );
      ACTION   ( WinDelRec( oBrwDiv, dbfTmpVta ) )

   /*
   Quinta caja de dialogo______________________________________________________
   */

   REDEFINE BITMAP oBmpLogistica ;
      ID       500 ;
      RESOURCE "gc_small_truck_48" ;
      TRANSPARENT ;
      OF       fldLogistica

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFra" ) ) ] ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodFra" ) ) ] ; 
      ID       420 ;
      IDTEXT   425 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      BITMAP   "LUPA" ;
      OF       fldLogistica

      aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFra" ) ) ]:bValid := {|| ( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFra" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodFra" ) ) ], oFraPub:GetAlias() ) ), .t. ) }
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFra" ) ) ]:bHelp  := {|| oFraPub:Buscar( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFra" ) ) ] ) }

   /*
   Código de la sección-----------------------------------------------------
   */

   REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodSec" ) ) ] ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodSec" ) ) ] ;
      ID       430 ;
      IDTEXT   431 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      BITMAP   "LUPA" ;
      OF       fldLogistica

      aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodSec" ) ) ]:bValid   := {|| oSeccion:Existe( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodSec" ) ) ], aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodSec" ) ) ]:oHelpText, "cDesSec", .t., .t., "0" ) }
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodSec" ) ) ]:bHelp    := {|| oSeccion:Buscar( aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodSec" ) ) ] ) }

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "NCAJENT" ) ) ] ;
      ID       180 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NUNICAJA" ) ) ] ;
      ID       190 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "CUNIDAD" ) ) ] ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CUNIDAD" ) ) ] ;
      ID       110 ;
      IDTEXT   254 ;
      PICTURE  "@!" ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      VALID    ( oUndMedicion:Existe( aGet[ ( D():Articulos( nView ) )->( fieldpos( "CUNIDAD" ) ) ], aGet[ ( D():Articulos( nView ) )->( fieldpos( "CUNIDAD" ) ) ]:oHelpText, "cNombre" ), lValidUndMedicion( aTmp, aGet ) ) ;
      ON HELP  ( oUndMedicion:Buscar( aGet[ ( D():Articulos( nView ) )->( fieldpos( "CUNIDAD" ) ) ] ) ) ;
      BITMAP   "LUPA" ;
      OF       fldLogistica

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "NLNGART" ) ) ] ;
      VAR         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NLNGART" ) ) ] ;
      ID          140 ;
      IDSAY       141 ;
      SPINNER ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      PICTURE     MasUnd() ;
      OF          fldLogistica

   REDEFINE GET   aGet[( D():Articulos( nView ) )->( fieldpos( "NALTART" ) ) ] ;
      VAR      aTmp[( D():Articulos( nView ) )->( fieldpos( "NALTART" ) ) ] ;
      ID       150 ;
      IDSAY    151 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  MasUnd() ;
      OF       fldLogistica

   REDEFINE GET   aGet[( D():Articulos( nView ) )->( fieldpos( "NANCART" ) ) ] ;
      VAR      aTmp[( D():Articulos( nView ) )->( fieldpos( "NANCART" ) ) ] ;
      ID       160 ;
      IDSAY    161 ;
      SPINNER ;
      WHEN    ( nMode != ZOOM_MODE ) ;
      PICTURE  MasUnd() ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "NPESOKG" ) ) ] ;
      ID       100 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  "@E 999,999.999999";
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "CUNDDIM" ) ) ] ;
      ID       170 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "NVOLUMEN" ) ) ] ;
      ID       120 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  "@E 999,999.999999";
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "CVOLUMEN" ) ) ] ;
      ID       130 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldLogistica

   /*
   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "NIMPPES" ) ) ] ;
      ID       290 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPouDiv ;
      COLOR    CLR_GET ;
      OF       fldLogistica */

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "NLNGCAJ" ) ) ] ;
      ID       300 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "CUNDCAJ" ) ) ] ;
      ID       310 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "NALTCAJ" ) ) ] ;
      ID       320 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "NANCCAJ" ) ) ] ;
      ID       330 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "NPESCAJ" ) ) ] ;
      ID       340 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "CCAJPES" ) ) ] ;
      ID       350 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "NVOLCAJ" ) ) ] ;
      ID       360 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "CCAJVOL" ) ) ] ;
      ID       370 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "NCAJPLT" ) ) ] ;
      ID       380 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      COLOR    CLR_GET ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "NBASPLT" ) ) ] ;
      ID       390 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      COLOR    CLR_GET ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "NALTPLT" ) ) ] ;
      ID       400 ;
      SPINNER ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      PICTURE  cPicUnd ;
      COLOR    CLR_GET ;
      OF       fldLogistica

   REDEFINE GET aTmp[( D():Articulos( nView ) )->( fieldpos( "CUNDPLT" ) ) ] ;
      ID       410 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       fldLogistica

   /*
	Tercera Caja de Dialogo del Folder
	---------------------------------------------------------------------------
	*/

   REDEFINE BITMAP oBmpStocks ;
         ID       500 ;
         RESOURCE "gc_package_48" ;
         TRANSPARENT ;
         OF       fldStocks

   REDEFINE RADIO aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NCTLSTOCK" ) ) ] ;
         ID       101, 102, 103 ;
         ON CHANGE( if( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NCTLSTOCK" ) ) ] != 1, oBrwStk:Hide(), oBrwStk:Show() ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldStocks

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "NMINIMO" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NMINIMO" ) ) ] ;
         ID       110 ;
         IDSAY    111 ;
         SPINNER  MIN 0 ;
         WHEN     ( aTmp[( D():Articulos( nView ) )->( fieldpos( "NCTLSTOCK" ) ) ] <= 1 .AND. nMode != ZOOM_MODE ) ;
         VALID    aTmp[( D():Articulos( nView ) )->( fieldpos( "NMINIMO" ) ) ] >= 0 ;
         PICTURE  cPicUnd ;
         OF       fldStocks

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nMaximo" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nMaximo" ) ) ] ;
         ID       115 ;
         IDSAY    116 ;
         SPINNER  MIN 0 ;
         WHEN     ( aTmp[( D():Articulos( nView ) )->( fieldpos( "NCTLSTOCK" ) ) ] <= 1 .AND. nMode != ZOOM_MODE ) ;
         VALID    aTmp[( D():Articulos( nView ) )->( fieldpos( "nMaximo" ) ) ] >= 0 ;
         PICTURE  cPicUnd ;
			COLOR 	CLR_GET ;
         OF       fldStocks

   REDEFINE BUTTON oBtnStockAlmacenes; 
         ID       300 ;
         OF       fldStocks;
         ACTION   ( StockAlmacenes( aTmp, aGet, nMode ) )

   REDEFINE GET aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NCNTACT" ) ) ] ;
         ID       120 ;
			SPINNER 	MIN 1 ;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NCTLSTOCK" ) ) ] == 2 .AND. nMode != ZOOM_MODE ) ;
         VALID    aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NCNTACT" ) ) ] >= 0 ;
         PICTURE  "@E 999,999,999,999" ;
			COLOR 	CLR_GET ;
         OF       fldStocks

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LMSGMOV" ) ) ] ;
         ID       127 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldStocks

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LMSGVTA" ) ) ] ;
         ID       126 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldStocks

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LMSGSER" ) ) ] ;
         ID       128 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldStocks

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LNOTVTA" ) ) ] ;
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
         :bStrData            := {|| if( !empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cCodigoAlmacen, "" ) }
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Almacén"
         :nWidth              := 120
         :bStrData            := {|| if( !empty( oBrwStk:aArrayData ), RetAlmacen( oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cCodigoAlmacen, dbfAlmT ), "" ) }
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Prop. 1"
         :nWidth              := 120
         :bStrData            := {|| if( !empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cValorPropiedad1, "" ) }
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Prop. 2"
         :nWidth              := 120
         :bStrData            := {|| if( !empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cValorPropiedad2, "" ) }
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Lote"
         :nWidth              := 60
         :bStrData            := {|| if( !empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cLote, "" ) }
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Num. serie"
         :nWidth              := 60
         :bStrData            := {|| if( !empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:cNumeroSerie, "" ) }
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Unidades"
         :nWidth              := 80
         :bEditValue          := {|| if( !empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:nUnidades, 0 ) }
         :bFooter             := {|| nStockUnidades( oBrwStk ) }
         :cEditPicture        := MasUnd()
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
      end with

      with object ( oBrwStk:AddCol() )
         :cHeader             := "Pdt. recibir"
         :bEditValue          := {|| if( !empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:nPendientesRecibir, 0 ) }
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
         :bEditValue          := {|| if( !empty( oBrwStk:aArrayData ), oBrwStk:aArrayData[ oBrwStk:nArrayAt ]:nPendientesEntregar, 0 ) }
         :bFooter             := {|| nStockEntregar( oBrwStk ) }
         :nWidth              := 70
         :cEditPicture        := cPicUnd
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
         :lHide               := .t.
      end with

   oBrwStk:CreateFromResource( 130 )

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LCOMBUS" ) ) ] ;
         ID       170 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       fldStocks

   /*
   Caja de dialogo para contabilidad-------------------------------------------
   */

   REDEFINE BITMAP oBmpContabilidad ;
         ID       500 ;
         RESOURCE "gc_folders2_48" ;
         TRANSPARENT ;
         OF       fldContabilidad

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "GRPVENT" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "GRPVENT" ) ) ] ;
         ID       100 ;
         PICTURE  ( Replicate( "9", 9 ) )  ;
         WHEN     ( !empty( cRutCnt() ) .and. nMode != ZOOM_MODE ) ;
         VALID    ( cGrpVenta( aGet[ ( D():Articulos( nView ) )->( fieldpos( "GRPVENT" ) ) ], , oSay[1] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwGrpVenta( aGet[ ( D():Articulos( nView ) )->( fieldpos( "GRPVENT" ) ) ], , oSay[1] ) );
         OF       fldContabilidad

   REDEFINE GET   oSay[1] ;
         VAR      cSay[1] ;
			WHEN 		.F. ;
         ID       101 ;
         OF       fldContabilidad

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCtaVta" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCtaVta" ) ) ] ;
         ID       110 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .and. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( brwChkSubcuenta(   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCtaVta" ) ) ],;
                                       oGetSubCta ) ) ;
         VALID    ( lValidaSubcuenta(  aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCtaVta" ) ) ],;
                                       aGet[ ( D():Articulos( nView ) )->( fieldpos( "Nombre"  ) ) ],;
                                       oGetSubCta,;
                                       oGetSaldo ) );
         OF       fldContabilidad

   REDEFINE GET   oGetSubCta ;
         VAR      cGetSubCta ;
         ID       111 ;
         WHEN     .f. ;
         OF       fldContabilidad

   REDEFINE GET   oGetSaldo ;
         VAR      nGetSaldo ;
         ID       112 ;
         PICTURE  cPorDiv ;
         WHEN     .f. ;
         OF       fldContabilidad

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCtaVtaDev" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCtaVtaDev" ) ) ] ;
         ID       120 ;
         PICTURE  ( replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .and. nMode != ZOOM_MODE ) ;
         ON HELP  ( brwChkSubcuenta(   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCtaVtaDev" ) ) ],;
                                       oGetSubcuentaVentaDevolucion ) ) ;
         VALID    ( lValidaSubcuenta(  aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCtaVtaDev" ) ) ],;
                                       aGet[ ( D():Articulos( nView ) )->( fieldpos( "Nombre" ) )     ],;
                                       oGetSubcuentaVentaDevolucion,;
                                       oGetSaldoSubcuentaVentaDevolucion ) );
         BITMAP   "LUPA" ;
         OF       fldContabilidad

   REDEFINE GET   oGetSubcuentaVentaDevolucion ;
         VAR      cGetSubcuentaVentaDevolucion ;
         ID       121 ;
         WHEN     .f. ;
         OF       fldContabilidad

   REDEFINE GET   oGetSaldoSubcuentaVentaDevolucion ; 
         VAR      nGetSaldoSubcuentaVentaDevolucion ;
         ID       122 ;
         PICTURE  cPorDiv ;
         WHEN     .f. ;
         OF       fldContabilidad

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCtaCom" ) ) ];
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCtaCom" ) ) ] ;
         ID       130 ;
         PICTURE  ( replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .and. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( brwChkSubcuenta(   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCtaCom" ) ) ],;
                                       oGetCtaCom ) ) ;
         VALID    ( lValidaSubcuenta(  aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCtaCom" ) ) ],;
                                       aGet[ ( D():Articulos( nView ) )->( fieldpos( "Nombre"  ) ) ],;
                                       oGetCtaCom,;
                                       oGetSalCom ) );
         OF       fldContabilidad

   REDEFINE GET   oGetCtaCom ;
         VAR      cGetCtaCom ;
         ID       131 ;
         WHEN     .f. ;
         OF       fldContabilidad

   REDEFINE GET   oGetSalCom ;
         VAR      nGetSalCom ;
         ID       132 ;
         PICTURE  cPorDiv ;
         WHEN     .f. ;
         OF       fldContabilidad

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCtaComDev" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCtaComDev" ) ) ] ;
         ID       140 ;
         PICTURE  ( replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .and. nMode != ZOOM_MODE ) ;
         ON HELP  ( brwChkSubcuenta(   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCtaComDev" ) ) ],;
                                       oGetSubcuentaCompraDevolucion ) ) ;
         VALID    ( lValidaSubcuenta(  aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCtaComDev" ) ) ],;
                                       aGet[ ( D():Articulos( nView ) )->( fieldpos( "Nombre" ) )     ],;
                                       oGetSubcuentaCompraDevolucion,;
                                       oGetSaldoSubcuentaCompraDevolucion ) );
         BITMAP   "LUPA" ;
         OF       fldContabilidad

   REDEFINE GET   oGetSubcuentaCompraDevolucion ;
         VAR      cGetSubcuentaCompraDevolucion ;
         ID       141 ;
         WHEN     .f. ;
         OF       fldContabilidad

   REDEFINE GET   oGetSaldoSubcuentaCompraDevolucion ; 
         VAR      nGetSaldoSubcuentaCompraDevolucion ;
         ID       142 ;
         PICTURE  cPorDiv ;
         WHEN     .f. ;
         OF       fldContabilidad

   
   /*
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
   */

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCTATRN" ) ) ];
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCTATRN" ) ) ] ;
         ID       150 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( brwChkSubcuenta(   aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCTATRN" ) ) ], oGetCtaTrn ) ) ;
         VALID    ( lValidaSubcuenta(  aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCTATRN" ) ) ],;
                                       aGet[ ( D():Articulos( nView ) )->( fieldpos( "NOMBRE"  ) ) ],;
                                       oGetCtaTrn,;
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
         RESOURCE "gc_star2_48" ;
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
      :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1 " )
      :bEditValue       := {|| ( dbfTmpOfe )->nPreOfe1 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1 " ) + cImp()
      :bEditValue       := {|| ( dbfTmpOfe )->nPreIva1 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2 " )
      :bEditValue       := {|| ( dbfTmpOfe )->nPreOfe2 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2 " ) + cImp()
      :bEditValue       := {|| ( dbfTmpOfe )->nPreIva2 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3 " )
      :bEditValue       := {|| ( dbfTmpOfe )->nPreOfe3 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3 " ) + cImp()
      :bEditValue       := {|| ( dbfTmpOfe )->nPreIva3 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4 " )
      :bEditValue       := {|| ( dbfTmpOfe )->nPreOfe4 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4 " ) + cImp()
      :bEditValue       := {|| ( dbfTmpOfe )->nPreIva4 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5 " )
      :bEditValue       := {|| ( dbfTmpOfe )->nPreOfe5 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5 " ) + cImp()
      :bEditValue       := {|| ( dbfTmpOfe )->nPreIva5 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6 " )
      :bEditValue       := {|| ( dbfTmpOfe )->nPreOfe6 }
      :nWidth           := 90
      :cEditPicture     := cPouDiv
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwOfe:AddCol() )
      :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6 " ) + cImp()
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
      oBrwOfe:bLDblClick  := {|| EdtOfeArt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ], oBrwOfe, dbfTmpOfe ) }
   end if

   oBrwOfe:bRClicked    := {| nRow, nCol, nFlags | oBrwOfe:RButtonDown( nRow, nCol, nFlags ) }

   oBrwOfe:CreateFromResource( 100 )

   REDEFINE BUTTON aBtn[8] ;
			ID 		500 ;
         OF       fldOfertas;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( AppOfeArt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ], oBrwOfe, dbfTmpOfe ) )

   REDEFINE BUTTON aBtn[9] ;
			ID 		501 ;
         OF       fldOfertas;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EdtOfeArt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ], oBrwOfe, dbfTmpOfe ) )

   REDEFINE BUTTON aBtn[10] ;
			ID 		502 ;
         OF       fldOfertas;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DelOfeArt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ], oBrwOfe, dbfTmpOfe ) )

	/*
	Sexta Caja de Dialogo del Folder
	---------------------------------------------------------------------------
   */

   REDEFINE BITMAP oBmpEscandallos ;
         ID       510 ;
         RESOURCE "gc_pieces_48" ;
         TRANSPARENT ;
         OF       fldEscandallos

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitArt" ) ) ];
			ID 		136 ;
         ON CHANGE( ChgKit( aTmp, aGet, oCosto ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldEscandallos

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitAsc" ) ) ];
         ID       135 ;
         ON CHANGE(  ChgKit( aTmp, aGet, oCosto ),;
                     if( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitAsc" ) ) ],;
                        (  aGet[ ( D():Articulos( nView ) )->( fieldpos( "nKitImp" ) ) ]:Set( 1 ),;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "nKitStk" ) ) ]:Set( 1 ),;
                           aGet[ ( D():Articulos( nView ) )->( fieldpos( "nKitPrc" ) ) ]:Set( 1 ) ), ) ) ;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitArt" ) ) ] .and. nMode != ZOOM_MODE ) ;
         OF       fldEscandallos

   REDEFINE COMBOBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "nKitImp" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nKitImp" ) ) ] ;
         ITEMS    { "Todos", "Compuesto", "Componentes" };
         ID       137 ;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitArt" ) ) ] .and. !aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitAsc" ) ) ] .and. nMode != ZOOM_MODE ) ;
         OF       fldEscandallos

   REDEFINE COMBOBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "nKitStk" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nKitStk" ) ) ] ;
         ITEMS    { "Todos", "Compuesto", "Componentes" };
         ID       138 ;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitArt" ) ) ] .and. !aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitAsc" ) ) ] .and. nMode != ZOOM_MODE ) ;
         OF       fldEscandallos

   REDEFINE COMBOBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "nKitPrc" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nKitPrc" ) ) ] ;
         ITEMS    { "Todos", "Compuesto", "Componentes" };
         ID       139 ;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitArt" ) ) ] .and. !aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitAsc" ) ) ].and. nMode != ZOOM_MODE ) ;
         OF       fldEscandallos

   REDEFINE BUTTON aBtn[11] ;
			ID 		500 ;
         OF       fldEscandallos;
         WHEN     ( nMode != ZOOM_MODE .AND. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LKITART" ) ) ] ) ;
         ACTION   ( WinAppRec( oBrwKit, bEdtKit, dbfTmpKit, , , aTmp ),  Eval( oBrwKit:bValid ) )

   REDEFINE BUTTON aBtn[12] ;
			ID 		501 ;
         OF       fldEscandallos;
         WHEN     ( nMode != ZOOM_MODE .AND. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LKITART" ) ) ] ) ;
         ACTION   ( WinEdtRec( oBrwKit, bEdtKit, dbfTmpKit, , , aTmp ),  Eval( oBrwKit:bValid ) )

   REDEFINE BUTTON aBtn[13] ;
			ID 		502 ;
         OF       fldEscandallos;
         WHEN     ( nMode != ZOOM_MODE .AND. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LKITART" ) ) ] ) ;
         ACTION   ( dbDelRec( oBrwKit, dbfTmpKit ), Eval( oBrwKit:bValid ) )

   REDEFINE BUTTON oBtnMoneda;
         ID       503 ;
         OF       fldEscandallos;
         WHEN     ( nMode != ZOOM_MODE .AND. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LKITART" ) ) ] ) ;
         ACTION   (  if( cDivUse == cDivEmp(), cDivUse := cDivChg(), cDivUse := cDivEmp() ), oBrwKit:Refresh() )

   REDEFINE BUTTON ;
         ID       504 ;
         OF       fldEscandallos;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LKITART" ) ) ] ) ;
         ACTION   ( dbSwapUp( dbfTmpKit, oBrwKit ) )

   REDEFINE BUTTON ;
         ID       505 ;
         OF       fldEscandallos;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LKITART" ) ) ] ) ;
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
      :bEditValue       := {|| nFactorConversion( ( dbfTmpKit )->cRefKit ) }
      :nWidth           := 70
      :cEditPicture     := "@E 999,999.999999"
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwKit:AddCol() )
      :cHeader          := "Costo"
      :bEditValue       := {|| nCosto( ( dbfTmpKit )->cRefKit, D():Articulos( nView ), dbfArtKit, .f., cDivUse, dbfDiv ) }
      :cEditPicture     := cPinDiv( cDivEmp(), dbfDiv )
      :nWidth           := 80
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrwKit:AddCol() )
      :cHeader          := "Total"
      :bEditValue       := {|| nCosto( ( dbfTmpKit )->cRefKit, D():Articulos( nView ), dbfArtKit, .f., cDivUse, dbfDiv ) * ( dbfTmpKit )->nUndKit * nFactorConversion( ( dbfTmpKit )->cRefKit ) } // 
      :bFooter          := {|| nCostoEscandallo( aTmp, dbfTmpKit, D():Articulos( nView ), dbfArtKit, .t., cDivUse, dbfDiv ) }
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
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef1" ) ) ]:lValid(),;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef2" ) ) ]:lValid(),;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef3" ) ) ]:lValid(),;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef4" ) ) ]:lValid(),;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef5" ) ) ]:lValid(),;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef6" ) ) ]:lValid() }

   oBrwKit:bRClicked       := {| nRow, nCol, nFlags | oBrwKit:RButtonDown( nRow, nCol, nFlags ) }

   oBrwKit:CreateFromResource( 180 )

   /*
   Septima caja de dialogo del folder  "Caja web"
   ----------------------------------------------------------------------------
   */

   REDEFINE BITMAP oBmpWeb ;
         ID       500 ;
         RESOURCE "gc_earth_48" ;
         TRANSPARENT ;
         OF       fldWeb

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LPUBINT" ) ) ] ;
         ID       100 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( ChangePublicarTemporal( aTmp ) ) ;
         OF       fldWeb

   /*
   Tarifas---------------------------------------------------------------------
   */

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lSbrInt" ) ) ] ;
      ID       160 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ON CHANGE( ChangeTarifaPrecioWeb( aGet, aTmp ), CalculaDescuentoWeb( aGet, aTmp ) ) ;
      OF       fldWeb

   // Web---------------------------------------------------------------------- 

   REDEFINE COMBOBOX aGet[ ( D():Articulos( nView ) )->( fieldPos( "cWebShop" ) ) ] ;
      VAR         aTmp[ ( D():Articulos( nView ) )->( fieldPos( "cWebShop" ) ) ] ;
      ITEMS       TComercioConfig():getInstance():getWebsNames() ;
      ID          110 ;
      WHEN        ( nMode != ZOOM_MODE .and. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lPubInt" ) ) ] ) ;
      OF          fldWeb

   // Tarifa-------------------------------------------------------------------

   oGetTarWeb     := comboTarifa():Build( { "idCombo" => 150, "uValue" => aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nTarWeb" ) ) ] } )
   oGetTarWeb:Resource( fldWeb )
   oGetTarWeb:setWhen(     {|| nMode != ZOOM_MODE .and. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lSbrInt" ) ) ] } )
   oGetTarWeb:setChange(   {|| ChangeTarifaPrecioWeb( aGet, aTmp ), CalculaDescuentoWeb( aGet, aTmp ) } )

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaWeb" ) ) ] ;
         ID       124 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldWeb

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaWeb" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVtaWeb" ) ) ] ;
         ID       120 ;
         WHEN     ( .f. );
         PICTURE  cPouDiv ;
         OF       fldWeb

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nDtoInt1" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nDtoInt1" ) ) ] ;
         ID       121 ;
         PICTURE  "@E 999.999999" ;
         SPINNER  MIN 0 MAX 100;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lPubInt" ) ) ] .and. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lSbrInt" ) ) ] .and. nMode != ZOOM_MODE ) ;
         ON CHANGE( CalculaDescuentoWeb( aGet, aTmp ) ) ;
         OF       fldWeb

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ] ;
         ID       122 ;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lPubInt" ) ) ] .and. !aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaWeb" ) ) ] .and. nMode != ZOOM_MODE ) ;
         PICTURE  cPwbDiv ;
         ON CHANGE( calculaPorcentajeDescuento( aGet[ ( D():Articulos( nView ) )->( fieldpos( "nDtoInt1" ) ) ],;
                                                aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVtaWeb"  ) ) ],;
                                                aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ] ) );
         VALID    CalBnfPts(  .t.,; 
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaWeb"  ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"   ) ) ],;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ],;
                              ,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva"  ) ) ],;
                              aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpIva1" ) ) ],;
                              nDecDiv,;
                              aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp"  ) ) ]);
         OF       fldWeb

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpIva1" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nImpIva1" ) ) ] ;
         ID       123 ;
         WHEN     ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lPubInt" ) ) ] .and. aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaWeb" ) ) ] .and. nMode != ZOOM_MODE ) ;
         PICTURE  cPwbDiv ;
         VALID    ( CalBnfIva(   .t.,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaWeb"  ) ) ],;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"   ) ) ],;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nImpIva1" ) ) ],; 
                                 ,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva"  ) ) ],;
                                 aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ],;
                                 nDecDiv,;
                                 aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp"  ) ) ] ),;
                     calculaPorcentajeDescuento(   aGet[ ( D():Articulos( nView ) )->( fieldpos( "nDtoInt1" ) ) ],; 
                                                   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVtaWeb"  ) ) ],;
                                                   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ] ) );
         OF       fldWeb

   REDEFINE GET aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodWeb" ) ) ] ;
         ID       210 ;
         WHEN     ( .F. );
         OF       fldWeb

   REDEFINE CHECKBOX aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lPubPor" ) ) ] ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldWeb

   REDEFINE GET   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "MDESTEC" ) ) ] ;
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         MEMO ;
         OF       fldWeb

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cTitSeo" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cTitSeo" ) ) ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       fldWeb     

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cDesSeo" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cDesSeo" ) ) ] ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       fldWeb       

   REDEFINE GET   aGet[ ( D():Articulos( nView ) )->( fieldpos( "cKeySeo" ) ) ] ;
         VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cKeySeo" ) ) ] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       fldWeb      

   /*
   Cuarta Caja de Dialogo del Folder
   ----------------------------------------------------------------------------
   */

   REDEFINE BITMAP oBmpImagenes ;
         ID       510 ;
         RESOURCE "gc_photo_landscape_48" ;
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
         ACTION   ( ImportaImagenes( aTmp, oBrwImg ), lCargaImagenes() )   

   oBrwImg                 := IXBrowse():New( fldImagenes )

   oBrwImg:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwImg:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwImg:cAlias          := dbfTmpImg
   oBrwImg:nMarqueeStyle   := 6
   oBrwImg:cName           := "Artículo.Imagenes"
   oBrwImg:nRowHeight      := 100
   oBrwImg:nDataLines      := 2

   with object ( oBrwImg:AddCol() )
      :cHeader             := "Seleccionada"
      :bStrData            := {|| "" }
      :bEditValue          := {|| ( dbfTmpImg )->lDefImg }
      :nWidth              := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( oBrwImg:AddCol() )
      :cHeader             := "Imagen"
      :bEditValue          := {|| AllTrim( ( dbfTmpImg )->cNbrArt ) + CRLF + AllTrim( ( dbfTmpImg )->cImgArt ) }
      :nWidth              := 400
   end with

   with object ( oBrwImg:AddCol() )
      :cHeader             := "Imagen"
      :nEditType           := TYPE_IMAGE
      :lBmpStretch         := .f.
      :lBmpTransparent     := .t.
      :bStrImage           := {|| cFileBmpName( ( dbfTmpImg )->cImgArt ) }
      :nDataBmpAlign       := AL_CENTER
      :nWidth              := 100
   end with

   with object ( oBrwImg:AddCol() )
      :cHeader             := "id"
      :bEditValue          := {|| transform( ( dbfTmpImg )->id, "9999999999" ) }
      :lHide               := .t.
      :nWidth              := 50
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
         ACTION   ( EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode, oImpComanda1, oImpComanda2, .t. ) )

   REDEFINE BUTTON aBtn[ 1 ] ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode, oImpComanda1, oImpComanda2 ) )

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

      fldEscandallos:AddFastKey( VK_F2, {|| if( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitArt" ) ) ], aBtn[ 11 ]:Click(), ) } )
      fldEscandallos:AddFastKey( VK_F3, {|| if( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitArt" ) ) ], aBtn[ 12 ]:Click(), ) } )
      fldEscandallos:AddFastKey( VK_F4, {|| if( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitArt" ) ) ], aBtn[ 13 ]:Click(), ) } )

      fldImagenes:AddFastKey( VK_F2, {|| WinAppRec( oBrwImg, bEdtImg, dbfTmpImg, aTmp ) } )
      fldImagenes:AddFastKey( VK_F3, {|| WinEdtRec( oBrwImg, bEdtImg, dbfTmpImg, aTmp ) } )
      fldImagenes:AddFastKey( VK_F4, {|| WinDelRec( oBrwImg, dbfTmpImg ) } )

      fldPropiedades:AddFastKey( VK_F2, {|| WinAppRec( oBrwDiv, bEdtVta, dbfTmpVta, , , aTmp ) } )
      fldPropiedades:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDiv, bEdtVta, dbfTmpVta, , , aTmp ) } )
      fldPropiedades:AddFastKey( VK_F4, {|| WinDelRec( oBrwDiv, dbfTmpVta ) } )

      oDlg:AddFastKey( VK_F5, {|| endTrans( aTmp, aGet, oSay, oDlg, aBar, cSay[7], nMode, oImpComanda1, oImpComanda2 ) } )
      oDlg:AddFastKey( VK_F7, {|| if( oFld:nOption > 1, oFld:SetOption( oFld:nOption - 1 ), ) } )
      oDlg:AddFastKey( VK_F8, {|| if( oFld:nOption < Len( oFld:aDialogs ), oFld:SetOption( oFld:nOption + 1 ), ) } )
      oDlg:AddFastKey( VK_F9, {|| oDetCamposExtra:Play( Space(1) ) } )

      if ( TComercioConfig():getInstance():isRealTimeConexion() )
         oDlg:AddFastKey( VK_F6, {|| oBtnAceptarActualizarWeb:Click() } )
      end if

   end if

   oDlg:bStart    := {|| StartDlg( aGet, aTmp, nMode, oSay, oDlg, oCosto, aBtnDiv, oFnt, oBtnMoneda, aBtn, bmpImage, oBrwPrv, oBrwDiv, oBrwStk, oBrwKit, oBrwOfe, oBrwCodeBar, oBrwImg, oBrwLeng ) }

   ACTIVATE DIALOG oDlg ;
      CENTER ;
      ON INIT     (  EdtRecMenu( aTmp, aGet, oSay, oDlg, oFld, aBar, cSay, nMode ) ) ;
      VALID       (  KillTrans( oMenu, oBmpTemporada, oBmpEstado, oBmpGeneral, oBmpPrecios, oBmpDescripciones, oBmpPropiedades, oBmpLogistica, oBmpStocks, oBmpContabilidad, oBmpOfertas, oBmpEscandallos, oBmpWeb, oBmpUbicaciones, oBmpImagenes, oBmpTactil, oBmpAdicionales ) )
/*
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir el dialogo de artículos" )

   END SEQUENCE
   ErrorBlock( oBlock )
*/
Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

static function actualizaTarifaWeb( aGet, aTmp, nMode )

   if !empty( oGetTarWeb )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nTarWeb" ) ) ]  := oGetTarWeb:getTarifa()
   endif

Return ( .t. )

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

      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ]   := nTotImpPrv( dbfTmpPrv, dbfDiv )

      if !empty( aGet[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ] )
         aGet[ ( D():Articulos( nView ) )->( fieldpos( "pCosto"  ) ) ]:Refresh()
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
   local cPrefix        := cDirectorio + AllTrim( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "codigo" ) ) ] )

   /*
   Cogemos las imágenes que hayan en el directorio para este artículo----------
   */

   aImagenes            := directory( cPrefix + "*.*" )
   
   for each aImg in aImagenes
      
      cImage            := alltrim( upper( cDirectorio + aImg[ 1 ] ) )

      /*
      Buscamos para ver si ya está introducida ésta imagen, para que no se repitan
      */

      ( dbfTmpImg )->( __dbLocate( { || alltrim( upper( ( D():ArticuloImagenes( nView ) )->cImgArt ) == cImage ) } ) )
      if !( dbfTmpImg )->( found() )

         ( dbfTmpImg )->( dbAppend() )
         
         ( dbfTmpImg )->cCodArt  := alltrim( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "codigo" ) ) ] )
         ( dbfTmpImg )->cNbrArt  := alltrim( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nombre" ) ) ] )
         ( dbfTmpImg )->cImgArt  := cImage

         ( dbfTmpImg )->( dbUnLock() )

      end if   

   next

   /*
   Comprobamos si hay alguna imagen por defecto, si no es así marcamos la primera
   */

   ( dbfTmpImg )->( dbgotop() )
   while !( dbfTmpImg )->( eof() )

      if ( dbfTmpImg )->lDefImg
         lDefault    := .t.
      end if

      ( dbfTmpImg )->( dbskip() )

   end while

   if !lDefault

      ( dbfTmpImg )->( dbgotop() )         

      if dbLock( dbfTmpImg )
         ( dbfTmpImg )->lDefImg  := .t.
         ( dbfTmpImg )->( dbunlock() )
      end if 

   end if

   ( dbfTmpImg )->( dbgotop() )

   /*
   Refrescamos el browse antes de salir----------------------------------------
   */
   
   if !empty( oBrwImg )
      oBrwImg:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtRec2( aTmp, aGet, cArticulo, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oBtn
   local oSay  := Array( 4 )
   local cSay  := Array( 4 )
   local oValorPunto
   local oValorDto
   local oValorTot

   do case
      case nMode == APPD_MODE
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo"    ) ) ]  := Space( 18 )
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nLabel"    ) ) ]  := 1
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nCtlStock" ) ) ]  := 1
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lLote"     ) ) ]  := .f.
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva"   ) ) ]  := cDefIva()
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf1"     ) ) ]  := .t.
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf2"     ) ) ]  := .t.
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf3"     ) ) ]  := .t.
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf4"     ) ) ]  := .t.
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf5"     ) ) ]  := .t.
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf6"     ) ) ]  := .t.

      case nMode == DUPL_MODE
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo"    ) ) ]  := NextKey( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], D():Articulos( nView ) )

   end case

   cCatOld     := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodCat" ) ) ]
   cPrvOld     := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cPrvHab" ) ) ]

   //Definicion del diálogo

   DEFINE DIALOG oDlg RESOURCE "FASTART" TITLE LblTitle( nMode ) + "artículo : " + Rtrim( aTmp[( D():Articulos( nView ) )->( fieldpos( "NOMBRE" ) ) ] )

   //Definición del código y nombre del nuevo artículo

   REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ];
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ];
      ID       100 ;
      PICTURE  "@!" ;
      WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
      VALID    ( CheckValid( aGet[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], D():Articulos( nView ), 1, nMode ) ) ;
      BITMAP   "Bot" ;
      ON HELP  ( aGet[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ]:cText( NextKey( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], D():Articulos( nView ) ) ) );
      OF       oDlg

   REDEFINE GET   aGet[( D():Articulos( nView ) )->( fieldpos( "Nombre" ) ) ];
      VAR         aTmp[( D():Articulos( nView ) )->( fieldpos( "Nombre" ) ) ];
      ID          110 ;
      ON CHANGE   ( ActTitle( nKey, nFlags, Self, nMode, oDlg ) );
      OF          oDlg

   // Definición de la familia del nuevo artículo------------------------------

   REDEFINE GET aGet[( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ] ;
      VAR      aTmp[( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ] ;
      ID       120 ;
      VALID    ( cFamilia( aGet[( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ], D():Familias( nView ), oSay[1] ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFamilia( aGet[( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ], oSay[1] ) );
      OF       oDlg

   REDEFINE GET oSay[1] VAR cSay[1] ;
      WHEN     ( .F. );
      ID       121 ;
      OF       oDlg

   // Definición del catálogo del artículo-------------------------------------

   REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodCat" ) ) ] ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodCat" ) ) ] ;
      ID       130 ;
      VALID    ( CargaValorCat( aTmp, aGet, oSay, oValorPunto, oValorDto, oValorTot, nMode, .t. ),;
                 oCatalogo:lValid( aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCODCAT" ) ) ], oSay[2] ) );
      ON HELP  ( oCatalogo:Buscar( aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCODCAT" ) ) ], oSay[2], "cCodCata" ) ) ;
      ON CHANGE( CargaValorCat( aTmp, aGet, oSay, oValorPunto, oValorDto, oValorTot, nMode, .t. ) );
      BITMAP   "LUPA" ;
      OF       oDlg

   REDEFINE GET oSay[2] VAR cSay[2] ;
      ID       131 ;
      WHEN     ( .f. ) ;
      OF       oDlg

   //Definición del proveedor del artículo

   REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "CPRVHAB" ) ) ] ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CPRVHAB" ) ) ] ;
      ID       140 ;
      PICTURE  ( RetPicCodPrvEmp() ) ;
      WHEN     ( empty( aTmp[( D():Articulos( nView ) )->( fieldpos( "CCODCAT" ) ) ] ) );
      VALID    ( CargaProveedor( aGet[ ( D():Articulos( nView ) )->( fieldpos( "CPRVHAB" ) ) ], oSay[ 4 ], oValorPunto, dbfProv ) );
      ON HELP  ( BrwProvee( aGet[ ( D():Articulos( nView ) )->( fieldpos( "CPRVHAB" ) ) ] ) ) ;
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

   REDEFINE GET aGet[ ( D():Articulos( nView ) )->( fieldpos( "pCosto" ) ) ] ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pCosto" ) ) ] ;
      ID       160 ;
      VALID    ( oValorTot:Refresh(), .t. );
      PICTURE  cPinDiv ;
      OF       oDlg

   //Carga el valor del punto

   REDEFINE GET oValorPunto VAR aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NPUNTOS" ) ) ] ;
      ID       170 ;
      ON CHANGE( oValorTot:Refresh() );
      PICTURE  cPinDiv ;
      OF       oDlg

   //Carga el descuento del punto

   REDEFINE GET oValorDto ;
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NDTOPNT" ) ) ] ;
      ID       180 ;
      SPINNER ;
      ON CHANGE( oValorTot:Refresh() );
      PICTURE  "@E 999.99" ;
      OF       oDlg

   //Define el total de la divisa el descuento del punto

   REDEFINE SAY oValorTot ;
      PROMPT   nPunt2Euro( aTmp, D():Articulos( nView ) ) ;
      ID       190 ;
      PICTURE  cPinDiv ;
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

   oDlg:bStart := {|| aGet[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ]:SetFocus() }

   ACTIVATE DIALOG oDlg ;
      ON INIT  ( aGet[( D():Articulos( nView ) )->( fieldpos( "FAMILIA" ) ) ]:lValid(), aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCODCAT" ) ) ]:lValid(), aGet[ ( D():Articulos( nView ) )->( fieldpos( "CPRVHAB" ) ) ]:lValid() );
      CENTER

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static function lValidaSubcuenta( getCuenta, getArticulo, getNombreCuenta, getSaldo )

   local valueCuenta    := alltrim( getCuenta:varget() )
   local nombreArticulo := alltrim( getArticulo:varget() )

   mkSubcuenta(   getCuenta,;
                  { valueCuenta, nombreArticulo },;
                  getNombreCuenta,;
                  nil,;
                  nil,;
                  nil,;
                  nil,;
                  getSaldo )

Return .t. 

//---------------------------------------------------------------------------//

Static function lValidaSubcuentaCompras( aGet, aTmp, nGetDebe, nGetHaber, oGetSaldo, oGetSubCom, cSubCtaAntCom, oBrwCom, dbfTmpSubCom )

   if mkSubcuenta( aGet[ ( D():Articulos( nView ) )->( fieldpos( "CCTACOM" ) ) ],;
                { aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCTACOM" ) ) ], aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NOMBRE"  ) ) ] },;
                oGetSubCom,;
                nil,;
                nil,;
                @nGetDebe,;
                @nGetHaber,;
                oGetSaldo )

      if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCTACOM" ) ) ] != cSubCtaAntCom
         // LoadSubcuenta( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCTACOM" ) ) ], cRutCnt(), dbfTmpSubCom )
         oBrwCom:Refresh()
      end if

      Return .t.

   end if

Return .f.

//---------------------------------------------------------------------------//

Static Function StartDlg( aGet, aTmp, nMode, oSay, oDlg, oCosto, aBtnDiv, oFnt, oBtnMoneda, aBtn, bmpImage, oBrwPrv, oBrwDiv, oBrwStk, oBrwKit, oBrwOfe, oBrwCodeBar, oBrwImg, oBrwLeng )

   CursorWait()

   oDlg:Disable()

   evalGet( aGet, nMode )

   ChgKit( aTmp, aGet, oCosto )

   oSay[ 18 ]:SetText( uFieldEmpresa( "cTxtTar1", "Precio 1" ) )

   if uFieldEmpresa( "lShwTar2" )
      oSay[ 19 ]:SetText( uFieldEmpresa( "cTxtTar2", "Precio 2" ) )
   else
      oSay[ 12 ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "lBnf2" ) )    ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef2" ) )   ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta2" ) )  ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva2" ) ) ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar3" )
      oSay[ 20 ]:SetText( uFieldEmpresa( "cTxtTar3", "Precio 3" ) )
   else
      oSay[ 13 ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "lBnf3" ) )    ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef3" ) )   ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta3" ) )  ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva3" ) ) ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar4" )
      oSay[ 21 ]:SetText( uFieldEmpresa( "cTxtTar4", "Precio 4" ) )
   else
      oSay[ 14 ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "lBnf4" ) )    ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef4" ) )   ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta4" ) )  ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva4" ) ) ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar5" )
      oSay[ 22 ]:SetText( uFieldEmpresa( "cTxtTar5", "Precio 5" ) )
   else
      oSay[ 15 ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "lBnf5" ) )    ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef5" ) )   ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta5" ) )  ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva5" ) ) ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar6" )
      oSay[ 23 ]:SetText( uFieldEmpresa( "cTxtTar6", "Precio 6" ) )
   else
      oSay[ 16 ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "lBnf6" ) )    ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef6" ) )   ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVenta6" ) )  ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva6" ) ) ]:Hide()
   end if

   aGet[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ]:SetFocus()

   if uFieldEmpresa( "lStkAlm" )
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "nMinimo" ) ) ]:Hide()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "nMaximo" ) ) ]:Hide()
      oBtnStockAlmacenes:Show()
   end if

   oBtnMoneda:Show()

   IXBrowse():OpenData()

   if !empty( oBrwPrv )
      oBrwPrv:LoadData()
   end if

   if !empty( oBrwDiv )
      oBrwDiv:LoadData()
   end if

   if !empty( oBrwStk )
      oBrwStk:LoadData()
   end if

   if !empty( oBrwKit )
      oBrwKit:LoadData()
   end if

   if !empty( oBrwOfe )
      oBrwOfe:LoadData()
   end if

   if !empty( oBrwImg )
      oBrwImg:LoadData()
   end if

   if !empty( oBrwLeng )
      oBrwLeng:LoadData()
   end if

   IXBrowse():CloseData()

   // Stock de almacen---------------------------------------------------------

   if nMode != APPD_MODE

      if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nCtlStock" ) ) ] <= 1
         oStock:aStockArticulo( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], nil, oBrwStk )
      end if

      if nMode != ZOOM_MODE

         // Comportamiento del dialogo-----------------------------------------------

         if !oUser():lCambiarPrecio()

            aGet[ ( D():Articulos( nView ) )->( FieldPos( "pVenta1" ) ) ]:HardDisable()
            aGet[ ( D():Articulos( nView ) )->( FieldPos( "pVtaIva1") ) ]:HardDisable()
            aGet[ ( D():Articulos( nView ) )->( FieldPos( "pVenta2" ) ) ]:HardDisable()
            aGet[ ( D():Articulos( nView ) )->( FieldPos( "pVtaIva2") ) ]:HardDisable()
            aGet[ ( D():Articulos( nView ) )->( FieldPos( "pVenta3" ) ) ]:HardDisable()
            aGet[ ( D():Articulos( nView ) )->( FieldPos( "pVtaIva3") ) ]:HardDisable()
            aGet[ ( D():Articulos( nView ) )->( FieldPos( "pVenta4" ) ) ]:HardDisable()
            aGet[ ( D():Articulos( nView ) )->( FieldPos( "pVtaIva4") ) ]:HardDisable()
            aGet[ ( D():Articulos( nView ) )->( FieldPos( "pVenta5" ) ) ]:HardDisable()
            aGet[ ( D():Articulos( nView ) )->( FieldPos( "pVtaIva5") ) ]:HardDisable()
            aGet[ ( D():Articulos( nView ) )->( FieldPos( "pVenta6" ) ) ]:HardDisable()
            aGet[ ( D():Articulos( nView ) )->( FieldPos( "pVtaIva6") ) ]:HardDisable()

            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nPntVer1") ) ]:HardDisable()
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nPnvIva1") ) ]:HardDisable()

            aGet[ ( D():Articulos( nView ) )->( fieldpos( "PvpRec"  ) ) ]:HardDisable()

         end if

         if oUser():lNotRentabilidad()

            aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef1"  ) ) ]:Hide()
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef2"  ) ) ]:Hide()
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef3"  ) ) ]:Hide()
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef4"  ) ) ]:Hide()
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef5"  ) ) ]:Hide()
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef6"  ) ) ]:Hide()

            aGet[ ( D():Articulos( nView ) )->( fieldpos( "lBnf1"   ) ) ]:Hide()
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "lBnf2"   ) ) ]:Hide()
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "lBnf3"   ) ) ]:Hide()
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "lBnf4"   ) ) ]:Hide()
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "lBnf5"   ) ) ]:Hide()
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "lBnf6"   ) ) ]:Hide()

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
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pCosto" ) ) ]:Hide()
      oCosto:Hide()
   end if

   if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nCtlStock" ) ) ] != 1
      oBrwStk:Hide()
   else
      oBrwStk:Show()
   end if

   // Tiendas en prestashop----------------------------------------------------

   if TComercioConfig():getInstance():isRealTimeConexion()
      oBtnAceptarActualizarWeb:Show()
   else   
      oBtnAceptarActualizarWeb:Hide()
   end if

   // Liberamos el dialogo-----------------------------------------------------

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
   local oTemporal

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   aItmSubCta        := {}

   cCodArt           := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo"  ) ) ]
   cCodSubCta        := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCtaVta" ) ) ]
   cCodSubCom        := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCtaCom" ) ) ]

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
   filTmpLeng        := cGetNewFileName( cPatTmp() + "ArtLeng" )
   filTmpAlm         := cGetNewFileName( cPatTmp() + "ArtAlm" )
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

      if nMode != APPD_MODE .and. ( D():ProveedorArticulo( nView ) )->( dbSeek( cCodArt ) )
         while ( D():ProveedorArticulo( nView ) )->cCodArt == cCodArt .and. !( D():ProveedorArticulo( nView ) )->( eof() )
            dbPass( D():ProveedorArticulo( nView ), dbfTmpPrv, .t. )
            ( D():ProveedorArticulo( nView ) )->( dbSkip() )
         end while
         ( dbfTmpPrv )->( dbGoTop() )
      end if

   end if

   /*
   Creamos la temporal de lenguajes--------------------------------------------
   */

   dbCreate( filTmpLeng, aSqlStruct( aItmArtLeng() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpLeng, cCheckArea( "ArtLeng", @dbfTmpLeng ), .f. )

   if !NetErr()

      ( dbfTmpPrv )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( dbfTmpPrv )->( OrdCreate( filTmpPrv, "cCodArt", "cCodArt", {|| Field->cCodArt } ) )

      if nMode != APPD_MODE .and. ( D():ArticuloLenguaje( nView ) )->( dbSeek( cCodArt ) )
         while ( D():ArticuloLenguaje( nView ) )->cCodArt == cCodArt .and. !( D():ArticuloLenguaje( nView ) )->( eof() )
            dbPass( D():ArticuloLenguaje( nView ), dbfTmpLeng, .t. )
            ( D():ArticuloLenguaje( nView ) )->( dbSkip() )
         end while
         ( dbfTmpLeng )->( dbGoTop() )
      end if

   end if

   // base de datos stocks por almacenes------------------------------------------

   dbCreate( filTmpAlm, aSqlStruct( aItmStockaAlmacenes() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpAlm, cCheckArea( "ArtAlm", @dbfTmpAlm ), .f. )

   if !NetErr()

      ( dbfTmpAlm )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( dbfTmpAlm )->( OrdCreate( filTmpAlm, "cCodArt + cCodAlm", "cCodArt + cCodAlm", {|| Field->cCodArt + Field->cCodAlm } ) )

      ( dbfTmpAlm )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( dbfTmpAlm )->( OrdCreate( filTmpAlm, "cCodAlm", "cCodAlm", {|| Field->cCodAlm } ) )

      if nMode != APPD_MODE .and. ( D():ArticuloStockAlmacenes( nView ) )->( dbSeek( cCodArt ) )
         while ( D():ArticuloStockAlmacenesId( nView ) ) == cCodArt .and. !( D():ArticuloStockAlmacenes( nView ) )->( eof() )
            dbPass( D():ArticuloStockAlmacenes( nView ), dbfTmpAlm, .t. )
            ( D():ArticuloStockAlmacenes( nView ) )->( dbSkip() )
         end while
         ( dbfTmpAlm )->( dbGoTop() )
      end if

   end if

   // base de datos de ventas--------------------------------------------------

   dbCreate( filTmpVta, aSqlStruct( aItmVta() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpVta, cCheckArea( "VtaArt", @dbfTmpVta ), .f. )

   ( dbfTmpVta )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
   ( dbfTmpVta )->( OrdCreate( filTmpVta, "cCodArt", "cCodArt + cCodPr1 + cCodPr2 + cValpr1 + cValPr2", {|| Field->cCodArt + Field->cCodPr1 + Field->cCodPr2 + Field->cValpr1 + Field->cValPr2 } ) )

   ( dbfTmpVta )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
   ( dbfTmpVta )->( ordCreate( filTmpVta, "cValPr1", "cCodArt + cValPr1", {|| Field->cCodArt + Field->cValPr1 } ) )

   ( dbfTmpVta )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
   ( dbfTmpVta )->( ordCreate( filTmpVta, "cValPr2", "cCodArt + cValPr2", {|| Field->cCodArt + Field->cValPr2 } ) )
   
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

   aImgsArticulo  := {}

   if nMode != APPD_MODE .and. ( D():ArticuloImagenes( nView ) )->( dbSeek( cCodArt ) )
      
      while ( D():ArticuloImagenes( nView ) )->cCodArt == cCodArt .and. !( D():ArticuloImagenes( nView ) )->( eof() )
         
         /*
         Metemos las imágenes en un array para las propiedades-----------------
         */

         oTemporal                     := SImagenes()
         oTemporal:lSelect             := .f.
         oTemporal:Ruta                := ( D():ArticuloImagenes( nView ) )->cImgArt
         oTemporal:ToolTip             := ( D():ArticuloImagenes( nView ) )->cNbrArt

         aAdd( aImgsArticulo, oTemporal )

         dbPass( D():ArticuloImagenes( nView ), dbfTmpImg, .t. )
         
         ( D():ArticuloImagenes( nView ) )->( dbSkip() )

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
   */

   /*
   Guardamos el-los códigos de barras para saber si han habido cambios---------
   */

   aOldCodeBar    := aDbfToArr( dbfTmpCodebar, 2 )

   /*
   Cargamos los temporales de los campos extra---------------------------------
   */

   oDetCamposExtra:SetTemporal( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], "", nMode )

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales " + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lErrors )

//--------------------------------------------------------------------------//

Static Function EndTrans( aTmp, aGet, oSay, oDlg, aTipBar, cTipBar, nMode, oImpComanda1, oImpComanda2, lActualizaWeb )

   local i
   local cImage
   local nIdImagen         := 0
   local cCod
   local cWebShop
   local oError
   local oBlock
   local cCodArt
   local nTipBar
   local aCodeBar          := {}
   local lChange           := .f.
   local nRec
   local lDefault          := .f.
   local cProvHab          := ""
   local lResultBeforeAppendEvent

   DEFAULT lActualizaWeb   := .f.

   if !empty( oGetTarWeb )
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nTarWeb" ) ) ]  := oGetTarWeb:getTarifa()
   end if

   if empty( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ] ) .and. ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      msgStop( "Código no puede estar vacio" )
      return nil
   end if

   if dbSeekInOrd( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], "Codigo", D():Articulos( nView ) ) .and. ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      msgStop( "Código ya existe" )
      return nil
   end if

   disableAcceso()

   // Ejecutamos script del evento before append-------------------------------

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      lResultBeforeAppendEvent   := runEventScript( "Articulos\beforeAppend", aGet, aTmp, nView )
      if IsLogic( lResultBeforeAppendEvent ) .and. !lResultBeforeAppendEvent
         return nil
      end if
   end if

   // Tomamos los valores para porcesos posteriores----------------------------

   cCod                    := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ]
   cWebShop                := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cWebShop" ) ) ]

   // Notificaciones en pantalla-----------------------------------------------

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      beginTransaction()

      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LastChg" ) ) ]     := GetSysDate()
      RelacionesEtiquetasModel():setRelationsOfEtiquetas( "EMP" + cCodEmp() + "Articulo" , aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ] , EtiquetasModel():translateNamesToIds( oTagsEver:getItems() ) )

      /*
      Añadimos la imágen del táctil a la tabla de imágenes---------------------
      */

      cImage               := alltrim( upper( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cImagen" ) ) ] ) )

      if !empty( cImage )

         ( dbfTmpImg )->( __dbLocate( {|| cImage == alltrim( upper( ( dbfTmpImg )->cImgArt ) ) } ) )
         if !( dbfTmpImg )->( found() )

            lDefault       := ( dbfTmpImg )->( lastrec() ) == 0

            ( dbfTmpImg )->( dbappend() )
            ( dbfTmpImg )->cCodArt  := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ]
            ( dbfTmpImg )->cImgArt  := cImage
            ( dbfTmpImg )->lDefImg  := lDefault
            ( dbfTmpImg )->( dbunlock() )            

         end if
             
      end if

      /*
      Añadimos las imágenes de las propiedades---------------------------------
      */

      nRec        := ( dbfTmpVta )->( Recno() )

      ( dbfTmpVta )->( dbGoTop() )
      while !( dbfTmpVta )->( Eof() )

         cImage   := alltrim( upper( ( dbfTmpVta )->cImgWeb ) )

         if !empty( cImage )

            ( dbfTmpImg )->( __dbLocate( {|| cImage == alltrim( upper( ( dbfTmpImg )->cImgArt ) ) } ) )
            if !( dbfTmpImg )->( found() )

               lDefault                 := ( dbfTmpImg )->( lastrec() ) == 0

               ( dbfTmpImg )->( dbappend() )
               ( dbfTmpImg )->cCodArt   := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ]
               ( dbfTmpImg )->cImgArt   := cImage
               ( dbfTmpImg )->lDefImg   := lDefault

               ( dbfTmpImg )->( dbunlock() )            

            end if   

         end if 

         ( dbfTmpVta )->( dbSkip() )
             
      end while

      ( dbfTmpVta )->( dbGoTo( nRec ) )

      /*
      Dejamos almenos una imágen por defecto-----------------------------------
      */

      lDefault       := .f.

      ( dbfTmpImg )->( dbGoTop() )
      while !( dbfTmpImg )->( eof() )

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

         while ( D():ProveedorArticulo( nView ) )->( dbSeek( cCod ) ) .and. !( D():ProveedorArticulo( nView ) )->( eof() )
            if dbLock( D():ProveedorArticulo( nView ) )
               ( D():ProveedorArticulo( nView ) )->( dbDelete() )
               ( D():ProveedorArticulo( nView ) )->( dbUnLock() )
            end if
         end while

         while ( D():ArticuloLenguaje( nView ) )->( dbSeek( cCod ) ) .and. !( D():ArticuloLenguaje( nView ) )->( eof() )
            if dbLock( D():ArticuloLenguaje( nView ) )
               ( D():ArticuloLenguaje( nView ) )->( dbDelete() )
               ( D():ArticuloLenguaje( nView ) )->( dbUnLock() )
            end if
         end while

         while ( D():ArticuloStockAlmacenes( nView ) )->( dbSeek( cCod ) ) .and. !( D():ArticuloStockAlmacenes( nView ) )->( eof() )
            if dbLock( D():ArticuloStockAlmacenes( nView ) )
               ( D():ArticuloStockAlmacenes( nView ) )->( dbDelete() )
               ( D():ArticuloStockAlmacenes( nView ) )->( dbUnLock() )
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

         while ( D():ArticuloImagenes( nView ) )->( dbSeek( cCod ) ) .and. !( D():ArticuloImagenes( nView ) )->( eof() )
            if dbLock( D():ArticuloImagenes( nView ) )
               ( D():ArticuloImagenes( nView ) )->( dbDelete() )
               ( D():ArticuloImagenes( nView ) )->( dbUnLock() )
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
         if ( dbfTmpPrv )->lDefPrv
            cProvHab             := ( dbfTmpPrv )->cCodPrv
         end if
         dbPass( dbfTmpPrv, D():ProveedorArticulo( nView ), .t. )
         ( dbfTmpPrv )->( dbSkip() )
      end while

      ( dbfTmpLeng )->( OrdSetFocus( 0 ) )
      ( dbfTmpLeng )->( dbGoTop() )
      while !( dbfTmpLeng )->( eof() )
         dbPass( dbfTmpLeng, D():ArticuloLenguaje( nView ), .t. )
         ( dbfTmpLeng )->( dbSkip() )
      end while

      ( dbfTmpAlm )->( OrdSetFocus( 0 ) )
      ( dbfTmpAlm )->( dbGoTop() )
      while !( dbfTmpAlm )->( eof() )
         ( dbfTmpAlm )->cCodArt  := cCod
         dbPass( dbfTmpAlm, D():ArticuloStockAlmacenes( nView ), .t. )
         ( dbfTmpAlm )->( dbSkip() )
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

      // pasa las imagenes a definitivo----------------------------------------

      ( dbfTmpImg )->( OrdSetFocus( 0 ) )
      ( dbfTmpImg )->( dbGoTop() )
      while !( dbfTmpImg )->( eof() )
         ( dbfTmpImg )->cCodArt  := cCod
         ( dbfTmpImg )->nId      := ++nIdImagen
         dbPass( dbfTmpImg, D():ArticuloImagenes( nView ), .t. )
         ( dbfTmpImg )->( dbSkip() )
      end while

      ( dbfTmpCodebar )->( OrdSetFocus( 0 ) )
      ( dbfTmpCodebar )->( dbGoTop() )

      while !( dbfTmpCodebar )->( eof() )

         ( dbfTmpCodebar )->cCodArt := cCod

         if ( dbfTmpCodebar )->lDefBar
            cCodArt                                                           := ( dbfTmpCodebar )->cCodBar
            nTipBar                                                           := ( dbfTmpCodebar )->nTipBar
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CodeBar"  ) ) ]    := ( dbfTmpCodebar )->cCodBar
         end if

         if !empty( ( dbfTmpCodebar )->cValPr1 ) .and. At( Alltrim( aTmp[ ( D():Articulos( nView ) )->( FieldPos( "mValPrp1" ) ) ] ), Alltrim( ( dbfTmpCodebar )->cValPr1 ) ) == 0
            aTmp[ ( D():Articulos( nView ) )->( FieldPos( "mValPrp1" ) ) ]    := Alltrim( aTmp[ ( D():Articulos( nView ) )->( FieldPos( "mValPrp1" ) ) ] ) + Alltrim( ( dbfTmpCodebar )->cValPr1 ) + ","
         end if

         if !empty( ( dbfTmpCodebar )->cValPr2 ) .and. At( Alltrim( aTmp[ ( D():Articulos( nView ) )->( FieldPos( "mValPrp2" ) ) ] ), Alltrim( ( dbfTmpCodebar )->cValPr2 ) ) == 0
            aTmp[ ( D():Articulos( nView ) )->( FieldPos( "mValPrp2" ) ) ]    := Alltrim( aTmp[ ( D():Articulos( nView ) )->( FieldPos( "mValPrp2" ) ) ] ) + Alltrim( ( dbfTmpCodebar )->cValPr2 ) + ","
         end if

         dbPass( dbfTmpCodebar, dbfCodebar, .t. )

         ( dbfTmpCodebar )->( dbSkip() )

      end while

      /*
      Tomamos algunos valores-----------------------------------------------------
      */

      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cPrvHab" ) ) ]       := cProvHab
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lLabel"  ) ) ]       := .t.
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lSndDoc" ) ) ]       := .t.
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodUsr" ) ) ]       := cCurUsr()
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "dFecChg" ) ) ]       := GetSysDate()
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cTimChg" ) ) ]       := Time()
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr1") ) ]       := oSay[ 11 ]:nAt
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr2") ) ]       := oSay[ 12 ]:nAt
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr3") ) ]       := oSay[ 13 ]:nAt
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr4") ) ]       := oSay[ 14 ]:nAt
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr5") ) ]       := oSay[ 15 ]:nAt
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr6") ) ]       := oSay[ 16 ]:nAt
      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nPosTpv" ) ) ]       -= 0.5

      if !empty(aTiposImpresoras)

         if !empty( oImpComanda1 )
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cTipImp1" ) ) ] := oImpComanda1:varGet()
            // aTiposImpresoras[ MinMax( oImpComanda1:nAt, 1, len( aTiposImpresoras ) ) ]
         end if

         if !empty( oImpComanda2 )
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cTipImp2" ) ) ] := oImpComanda2:varGet()
         end if

      end if 

      if !empty( oActiveX )
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "mDesTec" ) ) ]     := oActiveX:DocumentHTML
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
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "dChgBar" ) ) ] := GetSysDate()
      end if

      /*
      Cambios para publicar en internet----------------------------------------
      */

      ChangePublicarTemporal( aTmp )

      if ( dbfTmpImg )->( Lastrec() ) == 0
         lChangeImage  := ( cImageOld == aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cImagen" ) ) ] )
      end if 

      /*
      Guardamos los campos extra-----------------------------------------------
      */

      oDetCamposExtra:saveExtraField( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], "" )      

      /*
      Grabamos el registro a disco---------------------------------------------
      */

      WinGather( aTmp, aGet, D():Articulos( nView ), nil, nMode )
  
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
   Actualizamos los datos de la web para tiempo real------------------------
   */

   if lActualizaWeb
      BuildWeb( cCod, cWebShop )
   end if

   // Ejecutamos script del evento after append--------------------------------

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      runEventScript( "Articulos\afterAppend", aTmp, nView )
   end if

   /*
   Cerramos el dialogo---------------------------------------------------------
   */

   oMsgText()

   oDlg:End( IDOK )

   EnableAcceso()

Return ( .t. )

//-----------------------------------------------------------------------//

Static Function KillTrans( oMenu, oBmpCategoria, oBmpTemporada, oBmpEstado, oBmpGeneral, oBmpPrecios, oBmpDescripciones, oBmpPropiedades, oBmpLogistica, oBmpStocks, oBmpContabilidad, oBmpOfertas, oBmpEscandallos, oBmpWeb, oBmpUbicaciones, oBmpImagenes, oBmpTactil, oBmpAdicionales )

   /*
   Quitamos los filtros de stock-----------------------------------------------
   */

   if !empty( dbfTmpPrv ) .and. ( dbfTmpPrv )->( Used() )
      ( dbfTmpPrv )->( dbCloseArea() )
   end if

   if !empty( dbfTmpLeng ) .and. ( dbfTmpLeng )->( Used() )
      ( dbfTmpLeng )->( dbCloseArea() )
   end if

   if !empty( dbfTmpAlm ) .and. ( dbfTmpAlm )->( Used() )
      ( dbfTmpAlm )->( dbCloseArea() )
   end if

   if !empty( dbfTmpVta ) .and. ( dbfTmpVta )->( Used() )
      ( dbfTmpVta )->( dbCloseArea() )
   end if

   if !empty( dbfTmpKit ) .and. ( dbfTmpKit )->( Used() )
      ( dbfTmpKit )->( dbCloseArea() )
   end if

   if !empty( dbfTmpOfe ) .and. ( dbfTmpOfe )->( Used() )
      ( dbfTmpOfe )->( dbCloseArea() )
   end if

   if !empty( dbfTmpImg ) .and. ( dbfTmpImg )->( Used() )
      ( dbfTmpImg )->( dbCloseArea() )
   end if

   if !empty( dbfTmpCodebar ) .and. ( dbfTmpCodebar )->( Used() )
      ( dbfTmpCodebar )->( dbCloseArea() )
   end if

   /*
   if !empty( dbfTmpSubCta ) .and. ( dbfTmpSubCta )->( Used() )
      ( dbfTmpSubCta )->( dbCloseArea() )
   end if

   if !empty( dbfTmpSubCom ) .and. ( dbfTmpSubCom )->( Used() )
      ( dbfTmpSubCom )->( dbCloseArea() )
   end if

   dbfTmpCodebar  := nil
   dbfTmpSubCta   := nil
   */
   dbfTmpSubCom   := nil
   dbfTmpPrv      := nil
   dbfTmpVta      := nil
   dbfTmpKit      := nil
   dbfTmpOfe      := nil
   dbfTmpImg      := nil
   dbfTmpAlm      := nil 
   dbfTmpLeng     := nil

   dbfErase( filTmpPrv     )
   dbfErase( filTmpLeng    )
   dbfErase( filTmpAlm     )
   dbfErase( filTmpVta     )
   dbfErase( filTmpKit     )
   dbfErase( filTmpOfe     )
   dbfErase( filTmpImg     )
   dbfErase( filTmpCodebar )
   dbfErase( filTmpSubCta  )
   dbfErase( filTmpSubCom  )

   if !empty( oMenu )
      oMenu:End()
   end if

   if !empty( oBmpTemporada )
      oBmpTemporada:End()
   end if

   if !empty( oBmpEstado )
      oBmpEstado:End()
   end if

   if !empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

   if !empty( oBmpPrecios )
      oBmpPrecios:End()
   end if

   if !empty( oBmpDescripciones )
      oBmpDescripciones:End()
   end if

   if !empty( oBmpPropiedades )
      oBmpPropiedades:End()
   end if

   if !empty( oBmpLogistica )
      oBmpLogistica:End()
   end if

   if !empty( oBmpStocks )
      oBmpStocks:End()
   end if

   if !empty( oBmpContabilidad )
      oBmpContabilidad:End()
   end if

   if !empty( oBmpOfertas )
      oBmpOfertas:End()
   end if

   if !empty( oBmpEscandallos )
      oBmpEscandallos:End()
   end if

   if !empty( oBmpWeb )
      oBmpWeb:End()
   end if

   if !empty( oBmpUbicaciones )
      oBmpUbicaciones:End()
   end if

   if !empty( oBmpImagenes )
      oBmpImagenes:End()
   end if

   if !empty( oBmpTactil )
      oBmpTactil:End()
   end if

   if !empty(oBmpAdicionales)
      oBmpAdicionales:End()
   end if

Return .t.

//------------------------------------------------------------------------//

static function ChgKit( aTmp, aGet, oCosto )

   if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitArt") ) ] .and. !aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lKitAsc") ) ]
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pCosto" ) ) ]:Hide()
      oCosto:Show()
      oCosto:Disable()
   else
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "pCosto" ) ) ]:Show()
      oCosto:Hide()
   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

STATIC FUNCTION StdCol( lIvaInc, nMode )

//RETURN ( nMode != ZOOM_MODE )

RETURN ( lIvaInc .and. nMode != ZOOM_MODE )

//--------------------------------------------------------------------------//

STATIC FUNCTION ActTitle( nKey, nFlags, aGet, nMode, oDlg )

   oDlg:cTitle( LblTitle( nMode ) + " artículo : " + rtrim( aGet:varget() ) ) // + Chr( nKey ) )

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
   local oFld
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
   local cSay              := Array( 12 )
   local oSay              := Array( 12 )
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
   local oBrwImg 
   local oPrp1
   local cPrp1
   local oPrp2
   local cPrp2 

   /*
   Comprobamos que existan valores en las propiedades--------------------------
   */

   if nMode == APPD_MODE
      aTmp[ ( dbfTmpVta )->( FieldPos( "cCodArt" ) ) ]   := aArt[ ( D():Articulos( nView ) )->( fieldpos( "Codigo") ) ]
      aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ]   := aArt[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1") ) ]
      aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ]   := aArt[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2") ) ]
   end if

   if empty( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] )
      msgstop( "No hay propiedades seleccionadas.")
      Return .f.
   end if   

   /*
   Llenamos los arrays con las posibles propiedades----------------------------
   */

   aValPrp1                := aLlenaPropiedades( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ], aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ], nMode, oBrw, dbfTmpVta )
   aValPrp2                := aLlenaPropiedades( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ], aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr2" ) ) ], nMode, oBrw, dbfTmpVta )

   /*
   Preguntamos si la propiedad es de tipo color o no---------------------------
   */

   lColorPrp1              := retFld( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ], dbfPro, "lColor" )
   lColorPrp2              := retFld( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ], dbfPro, "lColor" )

   /*
   Limpiamos vaores en el caso de ser multiple selección-----------------------
   */

   if Len( oBrw:aSelected ) > 1 .and. nMode != APPD_MODE

      aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ]   := "" 
      aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr2" ) ) ]   := "" 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreCom" ) ) ]   := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "lBnf1" ) ) ]     := .f. 
      aTmp[ ( dbfTmpVta )->( FieldPos( "lBnf2" ) ) ]     := .f. 
      aTmp[ ( dbfTmpVta )->( FieldPos( "lBnf3" ) ) ]     := .f. 
      aTmp[ ( dbfTmpVta )->( FieldPos( "lBnf4" ) ) ]     := .f. 
      aTmp[ ( dbfTmpVta )->( FieldPos( "lBnf5" ) ) ]     := .f. 
      aTmp[ ( dbfTmpVta )->( FieldPos( "lBnf6" ) ) ]     := .f. 
      aTmp[ ( dbfTmpVta )->( FieldPos( "Benef1" ) ) ]    := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "Benef2" ) ) ]    := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "Benef3" ) ) ]    := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "Benef4" ) ) ]    := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "Benef5" ) ) ]    := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "Benef6" ) ) ]    := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nBnfSbr1" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nBnfSbr2" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nBnfSbr3" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nBnfSbr4" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nBnfSbr5" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nBnfSbr6" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreVta1" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreVta2" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreVta3" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreVta4" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreVta5" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreVta6" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreIva1" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreIva2" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreIva3" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreIva4" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreIva5" ) ) ]  := 0 
      aTmp[ ( dbfTmpVta )->( FieldPos( "nPreIva6" ) ) ]  := 0 

   end if

   /*
   Tomamos algunos valores por defecto-----------------------------------------
   */

   cSay[1]                 := aBnfSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr1" ) ) ], 1 ) ]
   cSay[2]                 := aBnfSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr2" ) ) ], 1 ) ]
   cSay[3]                 := aBnfSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr3" ) ) ], 1 ) ]
   cSay[4]                 := aBnfSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr4" ) ) ], 1 ) ]
   cSay[5]                 := aBnfSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr5" ) ) ], 1 ) ]
   cSay[6]                 := aBnfSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr6" ) ) ], 1 ) ]
   cSay[7]                 := uFieldEmpresa( "cTxtTar1", "Precio 1" )
   cSay[8]                 := uFieldEmpresa( "cTxtTar2", "Precio 2" )
   cSay[9]                 := uFieldEmpresa( "cTxtTar3", "Precio 3" )
   cSay[10]                := uFieldEmpresa( "cTxtTar4", "Precio 4" )
   cSay[11]                := uFieldEmpresa( "cTxtTar5", "Precio 5" )
   cSay[12]                := uFieldEmpresa( "cTxtTar6", "Precio 6" )

   /*
   Seleccionamos las Imágenes--------------------------------------------------
   */

   lCargaImagenes()

   if len( oBrw:aSelected ) == 1
      selectImagen( aTmp )
   end if

   DEFINE DIALOG oDlg RESOURCE "PREDIV" TITLE LblTitle( nMode ) + "precios por propiedades"

      /*
      Define de los Folders
      -------------------------------------------------------------------------
      */

      REDEFINE FOLDER oFld ;
         ID       200 ;
         OF       oDlg ;
         PROMPT   "Precios",;
                  "Imágenes";
         DIALOGS  "PREDIV01",;
                  "PREDIV02"     

      /*
      Primer Browse de propiedades--------------------------------------------
      */

      oBrwPrp1                   := IXBrowse():New( oDlg ) 

      oBrwPrp1:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPrp1:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPrp1:nMarqueeStyle     := 5
      oBrwPrp1:lRecordSelector   := .f.
      oBrwPrp1:lHScroll          := .f.
      oBrwPrp1:cName             := "Articulo.Propiedad1"

      oBrwPrp1:setArray( aValPrp1, .t., , .f. )

      oBrwPrp1:bLDblClick        := {|| seleccionPropiedad( aValPrp1, oBrwPrp1, oBrwPrp1:nArrayAt ) }
      oBrwPrp1:bSeek             := {|c,n| cSeekBrwPropiedades( c, oBrwPrp1 ) }

      REDEFINE SAY         oBrwPrp1:oSeek ;
         VAR               oBrwPrp1:cSeek ;
         ID                115 ;
         OF                oDlg

      oBrwPrp1:CreateFromResource( 100 )

      with object ( oBrwPrp1:AddCol() )
         :cHeader          := "S"
         :bStrData         := {|| "" }
         :bEditValue       := {|| if( !empty( aValPrp1 ), aValPrp1[ oBrwPrp1:nArrayAt ]:lSel, .f. ) }
         :nWidth           := 16
         :SetCheck( { "bSel", "Nil16" } )
      end with

      with object ( oBrwPrp1:AddCol() )
         :cHeader          := "Código"
         :bStrData         := {|| if( !empty( aValPrp1 ), aValPrp1[ oBrwPrp1:nArrayAt ]:cValPrp, "" ) }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | cOrdenBrwPropiedades( oCol, oBrwPrp1 ) }
      end with

      with object ( oBrwPrp1:AddCol() )
         :cHeader          := if( !empty( aValPrp1 ), retFld( aValPrp1[ oBrwPrp1:nArrayAt ]:cCodPrp, dbfPro ), "" )
         :bStrData         := {|| if( !empty( aValPrp1 ), aValPrp1[ oBrwPrp1:nArrayAt ]:cDesPrp, "" ) }
         :nWidth           := if( lColorPrp1, 103, 119 )
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | cOrdenBrwPropiedades( oCol, oBrwPrp1, alltrim( retFld( aValPrp1[ oBrwPrp1:nArrayAt ]:cCodPrp, dbfPro ) ) ) }
      end with

      if lColorPrp1

      with object ( oBrwPrp1:AddCol() )
         :cHeader          := "C"
         :bStrData         := {|| "" }
         :nWidth           := 16
         :bClrStd          := {|| { nRGB( 0, 0, 0), if( !empty( aValPrp1 ), aValPrp1[ oBrwPrp1:nArrayAt ]:nColor, 0 ) } }
         :bClrSel          := {|| { nRGB( 0, 0, 0), if( !empty( aValPrp1 ), aValPrp1[ oBrwPrp1:nArrayAt ]:nColor, 0 ) } }
         :bClrSelFocus     := {|| { nRGB( 0, 0, 0), if( !empty( aValPrp1 ), aValPrp1[ oBrwPrp1:nArrayAt ]:nColor, 0 ) } }
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
      Segundo Browse de propiedades--------------------------------------------
      */

      oBrwPrp2                   := IXBrowse():New( oDlg )

      oBrwPrp2:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwPrp2:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwPrp2:SetArray( aValPrp2, .t., , .f. )

      oBrwPrp2:nMarqueeStyle     := 5
      oBrwPrp2:lRecordSelector   := .f.
      oBrwPrp2:lHScroll          := .f.
      oBrwPrp2:cName             := "Articulo.Propiedad2"

      oBrwPrp2:CreateFromResource( 110 )

      oBrwPrp2:bLDblClick        := {|| SeleccionPropiedad( aValPrp2, oBrwPrp2, oBrwPrp2:nArrayAt ) }

      oBrwPrp2:bLDblClick        := {|| seleccionPropiedad( aValPrp2, oBrwPrp2, oBrwPrp2:nArrayAt ) }
      oBrwPrp2:bSeek             := {|c,n| cSeekBrwPropiedades( c, oBrwPrp2 ) }

      REDEFINE SAY         oBrwPrp2:oSeek ;
         VAR               oBrwPrp2:cSeek ;
         ID                116 ;
         OF                oDlg

      with object ( oBrwPrp2:AddCol() )
         :cHeader          := "S"
         :bStrData         := {|| "" }
         :bEditValue       := {|| if( !empty( aValPrp2 ), aValPrp2[ oBrwPrp2:nArrayAt ]:lSel, .f. ) }
         :nWidth           := 16
         :SetCheck( { "bSel", "Nil16" } )
      end with

      with object ( oBrwPrp2:AddCol() )
         :cHeader          := "Código"
         :bStrData         := {|| if( !empty( aValPrp2 ), aValPrp2[ oBrwPrp2:nArrayAt ]:cValPrp, "" ) }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | cOrdenBrwPropiedades( oCol, oBrwPrp2 ) }
      end with

      with object ( oBrwPrp2:AddCol() )
         :cHeader          := if( !empty( aValPrp2 ), retFld( aValPrp2[ oBrwPrp2:nArrayAt ]:cCodPrp, dbfPro ), "" )
         :bStrData         := {|| if( !empty( aValPrp2 ), aValPrp2[ oBrwPrp2:nArrayAt ]:cDesPrp, "" ) }
         :nWidth           := if( lColorPrp2, 103, 119 )
         :cOrder           := "A"
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | cOrdenBrwPropiedades( oCol, oBrwPrp2, AllTrim( retFld( aValPrp2[ oBrwPrp2:nArrayAt ]:cCodPrp, dbfPro ) ) ) }
      end with

      if lColorPrp2

      with object ( oBrwPrp2:AddCol() )
         :cHeader          := "C"
         :bStrData         := {|| "" }
         :nWidth           := 16
         :bClrStd          := {|| { nRGB( 0, 0, 0), if( !empty( aValPrp1 ), aValPrp2[ oBrwPrp2:nArrayAt ]:nColor, 0 ) } }
         :bClrSel          := {|| { nRGB( 0, 0, 0), if( !empty( aValPrp1 ), aValPrp2[ oBrwPrp2:nArrayAt ]:nColor, 0 ) } }
         :bClrSelFocus     := {|| { nRGB( 0, 0, 0), if( !empty( aValPrp1 ), aValPrp2[ oBrwPrp2:nArrayAt ]:nColor, 0 ) } }
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

      // Controles de propiedades para poder modificar-------------------------

      REDEFINE GET oPrp1;
         VAR      aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ];
         ID       210 ;
         BITMAP   "LUPA" ;
         ON HELP  ( brwPropiedadActual( oPrp1, oSayVp1, aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] ) );
         VALID    ( lPrpAct( aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ], oSayVp1, aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ], dbfTblPro ) );
         OF       oDlg 
      
      REDEFINE SAY oSayPr1 ; 
         VAR      cSayPr1 ;
         ID       211 ;
         OF       oDlg

      REDEFINE GET oSayVp1 ; 
         VAR      cSayVp1 ;
         WHEN     .f. ;
         ID       212 ;
         OF       oDlg

      REDEFINE GET oPrp2;
         VAR      aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr2" ) ) ];
         ID       220 ;
         BITMAP   "LUPA" ;
         ON HELP  ( brwPropiedadActual( oPrp2, oSayVp2, aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ] ) );
         VALID    ( lPrpAct( aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr2" ) ) ], oSayVp2, aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ], dbfTblPro ) );
         OF       oDlg

      REDEFINE SAY oSayPr2 ;
         VAR      cSayPr2 ;
         ID       221 ;
         OF       oDlg

      REDEFINE GET oSayVp2 ; 
         VAR      cSayVp2 ;
         WHEN     .f. ;
         ID       222 ;
         OF       oDlg

      /*
      Montamos los controles para precios por propiedades----------------------
      */

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ] ;
         ID       600 ;
         WHEN     ( !aArt[ ( D():Articulos( nView ) )->( fieldPos( "lKitArt") ) ] .and. nMode != ZOOM_MODE ) ;
         VALID    (  aGet[ ( dbfTmpVta )->( fieldpos( "Benef1" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpVta )->( fieldpos( "Benef2" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpVta )->( fieldpos( "Benef3" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpVta )->( fieldpos( "Benef4" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpVta )->( fieldpos( "Benef5" ) ) ]:lValid(),;
                     aGet[ ( dbfTmpVta )->( fieldpos( "Benef6" ) ) ]:lValid(),;
                     .t. );
			PICTURE 	cPinDiv() ;
         SPINNER ;
         OF       oFld:aDialogs[1] ;
         IDSAY    401 ;

      /*
      Tarifa1 ______________________________________________________________________________
      */

      REDEFINE SAY oSay[ 7 ] VAR cSay[ 7 ] ;
         ID       610 ;
         OF       oFld:aDialogs[1] ;

      REDEFINE SAY oSay[ 8 ] VAR cSay[ 8 ] ;
         ID       620 ;
         OF       oFld:aDialogs[1] ;

      REDEFINE SAY oSay[ 9 ] VAR cSay[ 9 ];
         ID       630 ;
         OF       oFld:aDialogs[1] ;

      REDEFINE SAY oSay[ 10 ] VAR cSay[ 10 ] ;
         ID       640 ;
         OF       oFld:aDialogs[1] ;

      REDEFINE SAY oSay[ 11 ] VAR cSay[ 11 ] ;
         ID       650 ;
         OF       oFld:aDialogs[1] ;

      REDEFINE SAY oSay[ 12 ] VAR cSay[ 12 ] ;
         ID       660 ;
         OF       oFld:aDialogs[1] ;

      REDEFINE CHECKBOX aGet[ ( dbfTmpVta )->( fieldpos( "lBnf1" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf1" ) ) ] ;
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "Benef1" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "Benef1" ) ) ] ;
         ID       310 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf1" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    (  lCalPre( oSay[ 1 ]:nAt <= 1,;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf1"   ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "Benef1"  ) ) ],;
                              aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta1") ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva1") ) ],;
                              nDecDiv,;
                              aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX oSay[ 1 ] VAR cSay[ 1 ] ;
         ITEMS    aBnfSobre ;
         ID       320 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf1"  ) ) ],;
                        aGet[ ( dbfTmpVta )->( fieldpos( "Benef1" ) ) ]:lValid(),;
                        aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta1") )]:lValid() ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta1" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta1" ) ) ] ;
         ID       330 ;
         SPINNER ;
         WHEN     ( stdCol( !aArt[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 1 ]:nAt <= 1,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta1") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef1"  ) ) ],;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva1") ) ],;
                                 nDecDiv,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva1" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva1" ) ) ] ;
         ID       340 ;
         SPINNER ;
         WHEN     ( stdCol( aArt[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 1 ]:nAt <= 1,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva1") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef1"  ) ) ],;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta1") ) ],;
                                 nDecDiv,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      /*
      Tarifa2 ______________________________________________________________________________
      */

      REDEFINE CHECKBOX aGet[ ( dbfTmpVta )->( fieldpos( "lBnf2" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf2" ) ) ] ;
         ID       350 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "Benef2" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "Benef2" ) ) ] ;
         ID       360 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf2" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 2 ]:nAt <= 2,;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf2"   ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "Benef2"  ) ) ],;
                              aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta2") ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva2") ) ],;
                              nDecDiv,;
                              aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX oSay[ 2 ] VAR cSay[ 2 ] ;
         ITEMS    aBnfSobre ;
         ID       370 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf2"  ) ) ],;
                        aGet[ ( dbfTmpVta )->( fieldpos( "Benef2" ) ) ]:lValid(),;
                        aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta2")) ]:lValid() ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta2" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta2" ) ) ] ;
         ID       380 ;
         SPINNER ;
         WHEN     ( stdCol( !aArt[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 2 ]:nAt <= 2,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta2") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef2"  ) ) ],;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva2") ) ],;
                                 nDecDiv,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva2" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva2" ) ) ] ;
         ID       390 ;
         SPINNER ;
         WHEN     ( stdCol( aArt[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 2 ]:nAt <= 2,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva2") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef2"  ) ) ],;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta2") ) ],;
                                 nDecDiv,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

   /*
   Tarifa3 ______________________________________________________________________________
   */

      REDEFINE CHECKBOX aGet[ ( dbfTmpVta )->( fieldpos( "lBnf3" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf3" ) ) ] ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "Benef3" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "Benef3" ) ) ] ;
         ID       410 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf3" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(  oSay[ 3 ]:nAt <= 3,;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf3"   ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "Benef3"  ) ) ],;
                              aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta3") ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva3") ) ],;
                              nDecDiv,;
                              aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX oSay[ 3 ] VAR cSay[ 3 ] ;
         ITEMS    aBnfSobre ;
         ID       420 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf3"  ) ) ],;
                        aGet[ ( dbfTmpVta )->( fieldpos( "Benef3" ) ) ]:lValid(),;
                        aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta3")) ]:lValid() ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta3" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta3" ) ) ] ;
         ID       430 ;
         SPINNER ;
         WHEN     ( stdCol( !aArt[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 3 ]:nAt <= 3,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta3") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef3"  ) ) ],;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva3") ) ],;
                                 nDecDiv,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva3" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva3" ) ) ] ;
         ID       440 ;
         SPINNER ;
         WHEN     ( stdCol( aArt[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 3 ]:nAt <= 3,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva3") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef3"  ) ) ],;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta3") ) ],;
                                 nDecDiv,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

   /*
   Tarifa4 ______________________________________________________________________________
   */

      REDEFINE CHECKBOX aGet[ ( dbfTmpVta )->( fieldpos( "lBnf4" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf4" ) ) ] ;
         ID       450 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "Benef4" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "Benef4" ) ) ] ;
         ID       460 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf4" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 4 ]:nAt <= 4,;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf4"   ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "Benef4"  ) ) ],;
                              aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta4") ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva4") ) ],;
                              nDecDiv,;
                              aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX oSay[ 4 ] VAR cSay[ 4 ] ;
         ITEMS    aBnfSobre ;
         ID       470 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf4"  ) ) ],;
                        aGet[ ( dbfTmpVta )->( fieldpos( "Benef4" ) ) ]:lValid(),;
                        aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta4")) ]:lValid() ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta4" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta4" ) ) ] ;
         ID       480 ;
         SPINNER ;
         WHEN     ( stdCol( !aArt[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 4 ]:nAt <= 4,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta4") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef4"  ) ) ],;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva4") ) ],;
                                 nDecDiv,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva4" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva4" ) ) ] ;
         ID       490 ;
         SPINNER ;
         WHEN     ( stdCol( aArt[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 4 ]:nAt <= 4,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva4") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef4"  ) ) ],;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta4") ) ],;
                                 nDecDiv,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

   /*
   Tarifa5 ______________________________________________________________________________
   */

      REDEFINE CHECKBOX aGet[ ( dbfTmpVta )->( fieldpos( "lBnf5" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf5" ) ) ] ;
         ID       500 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "Benef5" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "Benef5" ) ) ] ;
         ID       510 ;
			SPINNER ;
         WHEN     ( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf5" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 5 ]:nAt <= 5,;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf5"   ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "Benef5"  ) ) ],;
                              aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta5") ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva5") ) ],;
                              nDecDiv,;
                              aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX oSay[ 5 ] VAR cSay[ 5 ] ;
         ITEMS    aBnfSobre ;
         ID       520 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf5"  ) ) ],;
                        aGet[ ( dbfTmpVta )->( fieldpos( "Benef5" ) ) ]:lValid(),;
                        aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta5") )]:lValid() ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta5" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta5" ) ) ] ;
         ID       530 ;
         SPINNER ;
         WHEN     ( stdCol( !aArt[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 5 ]:nAt <= 5,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta5") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef5"  ) ) ],;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva5") ) ],;
                                 nDecDiv,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva5" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva5" ) ) ] ;
         ID       540 ;
         SPINNER ;
         WHEN     ( stdCol( aArt[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 5 ]:nAt <= 5,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva5") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef5"  ) ) ],;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta5") ) ],;
                                 nDecDiv,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

   /*
   Tarifa6 ______________________________________________________________________________
   */

      REDEFINE CHECKBOX aGet[ ( dbfTmpVta )->( fieldpos( "lBnf6" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf6" ) ) ] ;
         ID       550 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "Benef6" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "Benef6" ) ) ] ;
         ID       560 ;
         SPINNER ;
         WHEN     ( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf6" ) ) ] .AND. nMode != ZOOM_MODE ) ;
         VALID    ( lCalPre(   oSay[ 6 ]:nAt <= 6,;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf6"   ) ) ],;
                              aTmp[ ( dbfTmpVta )->( fieldpos( "Benef6"  ) ) ],;
                              aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta6") ) ],;
                              aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva6") ) ],;
                              nDecDiv,;
                              aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) ) ;
         PICTURE  "@E 999.99" ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX oSay[ 6 ] VAR cSay[ 6 ] ;
         ITEMS    aBnfSobre ;
         ID       570 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ ( dbfTmpVta )->( fieldpos( "lBnf6"  ) ) ],;
                        aGet[ ( dbfTmpVta )->( fieldpos( "Benef6" ) ) ]:lValid(),;
                        aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta6") )]:lValid() ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta6" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta6" ) ) ] ;
         ID       580 ;
         SPINNER ;
         WHEN     ( stdCol( !aArt[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfPts(   oSay[ 6 ]:nAt <= 6,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreVta6") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef6"  ) ) ],;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva6") ) ],;
                                 nDecDiv,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva6" ) ) ] ;
         VAR      aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva6" ) ) ] ;
         ID       590 ;
         SPINNER ;
         WHEN     ( stdCol( aArt[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ], nMode ) ) ;
         VALID    ( CalBnfIva(   oSay[ 6 ]:nAt <= 6,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "lIvaInc" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreCom" ) ) ],;
                                 aTmp[ ( dbfTmpVta )->( fieldpos( "nPreIva6") ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "Benef6"  ) ) ],;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "TipoIva" ) ) ],;
                                 aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta6") ) ],;
                                 nDecDiv,;
                                 aArt[ (D():Articulos( nView ))->( fieldpos( "cCodImp" ) ) ] ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]


      /*
      Segunda caja de diálogo--------------------------------------------------
      */

      oBrwImg                 := IXBrowse():New( oFld:aDialogs[2] )

      oBrwImg:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwImg:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwImg:SetArray( aImgsArticulo, , , .f. )
      oBrwImg:nMarqueeStyle   := 6
      oBrwImg:cName           := "Artículo.Imagenes.Propiedades"
      oBrwImg:nRowHeight      := 100
      oBrwImg:nDataLines      := 2

      with object ( oBrwImg:AddCol() )
         :cHeader             := "Seleccionada"
         :bStrData            := {|| "" }
         :bEditValue          := {|| aImgsArticulo[ oBrwImg:nArrayAt ]:lselect }
         :nWidth              := 20
         :SetCheck( { "BSEL", "Nil16" } )
      end with

      with object ( oBrwImg:AddCol() )
         :cHeader             := "Imagen"
         :nEditType           := TYPE_IMAGE
         :lBmpStretch         := .f.
         :lBmpTransparent     := .t.
         :bStrImage           := {|| aImgsArticulo[ oBrwImg:nArrayAt ]:ruta }
         :nDataBmpAlign       := AL_CENTER
         :nWidth              := 100
      end with

      with object ( oBrwImg:AddCol() )
         :cHeader             := "Imagen"
         :bEditValue          := {|| AllTrim( aImgsArticulo[ oBrwImg:nArrayAt ]:tooltip ) + CRLF + AllTrim( aImgsArticulo[ oBrwImg:nArrayAt ]:ruta ) }
         :nWidth              := 350
      end with

      if nMode != ZOOM_MODE
         oBrwImg:bLDblClick   := {|| SeleccionaImagen( oBrwImg ) }
      end if

      oBrwImg:CreateFromResource( 110 )

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

      oDlg:bStart := {|| StartEdtVta( aTmp, aGet, nMode, oBrwPrp1, oBrwPrp2, oTodasPrp1, oNingunaPrp1, oTodasPrp2, oNingunaPrp2, oBtnOk, oBtnCancel, oSay, oPrp1, oSayPr1, oSayVp1, oPrp2, oSayPr2, oSayVp2 ) }

      if nMode != APPD_MODE
         oDlg:AddFastKey( VK_F5, {|| EndEdtVta( aValPrp1, aValPrp2, aTmp, aGet, oSay, cSay, oBrw, oDlg, dbfTmpVta, nMode, oBrwPrp1, oBrwPrp2 ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function cOrdenBrwPropiedades( oCol, oBrw, cOrden )

   local oColumn

   if empty( oBrw )
      Return .t.
   end if 

   do case
      case alltrim( oCol:cHeader ) == cOrden

         aSort( oBrw:aArrayData, , , {|x,y| x:cDesPrp < y:cDesPrp } )

         for each oColumn in oBrw:aCols
            oColumn:cOrder := ""
         next

         oCol:cOrder       := cOrden

      case alltrim( oCol:cHeader ) == "Código"

         aSort( oBrw:aArrayData, , , {|x,y| val( x:cValPrp ) < val( y:cValPrp ) } )

         for each oColumn in oBrw:aCols
            oColumn:cOrder := ""
         next

         oCol:cOrder       := "Código"

   end case

   oBrw:Refresh()

return .t.

//---------------------------------------------------------------------------//

static function cSeekBrwPropiedades( cSeek, oBrw )

   local nAt
   local uVal
   local nRow
   local cHeader
   local nColumnOrder

   if empty( cSeek )
      Return .t. 
   end if 

   if empty( oBrw )
      Return .t.
   end if 

   nColumnOrder            := ascan( oBrw:aCols, { |o| !empty( o:cOrder ) } ) 
   if !empty( nColumnOrder )
      cHeader              := oBrw:aCols[ nColumnOrder ]:cHeader
   end if 

   cSeek                   := Upper( cSeek )

   for nRow := 1 to oBrw:nLen

      if cHeader != "Código"
         uVal              := oBrw:aArrayData[ nRow ]:cDesPrp
      else
         uVal              := oBrw:aArrayData[ nRow ]:cValPrp
      end if

      if valtype( uVal ) == "C"
         uVal              := Upper( uVal )

         if ( cSeek $ uVal )
            nAt            := nRow
         end if
         
         if !empty( nAt )
            oBrw:nArrayAt  := nAt
            Return .t.
         end if

      end if 

   next nRow

Return .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtLeng( aTmp, aGet, dbfTmpLeng, oBrw, bWhen, bValid, nMode, aTmpArt )

   local oDlg
   local oBmp

   DEFINE DIALOG oDlg RESOURCE "ARTICULO_LENGUAJE" TITLE LblTitle( nMode ) + "descripciones por lenguaje"

   REDEFINE BITMAP oBmp ;
      ID       600 ;
      RESOURCE "gc_user_message_48" ; 
      TRANSPARENT ;
      OF       oDlg

   REDEFINE GET aGet[ ( dbfTmpLeng )->( fieldpos( "cCodLen" ) ) ] ;
      VAR      aTmp[ ( dbfTmpLeng )->( fieldpos( "cCodLen" ) ) ] ;
      ID       110 ;
      IDTEXT   111;
      COLOR    CLR_GET ;
      VALID    ( oLenguajes:Existe( aGet[ ( dbfTmpLeng )->( fieldpos( "cCodLen" ) ) ], aGet[ ( dbfTmpLeng )->( fieldpos( "cCodLen" ) ) ]:oHelpText, "cNomLen" ) );
      ON HELP  ( oLenguajes:Buscar( aGet[ ( dbfTmpLeng )->( fieldpos( "cCodLen" ) ) ] ) ) ;
      BITMAP   "LUPA" ;
      OF       oDlg

   REDEFINE GET aGet[ ( dbfTmpLeng )->( fieldpos( "cDesTik" ) ) ] ; 
      VAR      aTmp[ ( dbfTmpLeng )->( fieldpos( "cDesTik" ) ) ] ;
      ID       120 ;
      OF       oDlg   

   REDEFINE GET aGet[ ( dbfTmpLeng )->( fieldpos( "cDesArt" ) ) ] ; 
      VAR      aTmp[ ( dbfTmpLeng )->( fieldpos( "cDesArt" ) ) ] ;
      MEMO ;
      ID       130 ;
      OF       oDlg

   REDEFINE BUTTON;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( EndEdtLeng( aGet, aTmp, aTmpArt, dbfTmpLeng, oBrw, nMode, oDlg ) )

   REDEFINE BUTTON;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   if nMode != APPD_MODE
      oDlg:AddFastKey( VK_F5, {|| EndEdtLeng( aGet, aTmp, aTmpArt, dbfTmpLeng, oBrw, nMode, oDlg ) } )
   end if

   oDlg:bStart    := {|| aGet[ ( dbfTmpLeng )->( fieldpos( "cCodLen" ) ) ]:lValid() }

   ACTIVATE DIALOG oDlg CENTER

   if !empty( oBmp )
      oBmp:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function EndEdtLeng( aGet, aTmp, aTmpArt, dbfTmpLeng, oBrw, nMode, oDlg )

   if empty( aTmp[ ( dbfTmpLeng )->( FieldPos( "cCodLen" ) ) ] )
      MsgStop( "Código de lenguaje no puede estar vacío." )
      aGet[ ( dbfTmpLeng )->( FieldPos( "cCodLen" ) ) ]:SetFocus()
      Return .f.
   end if

   if empty( aTmp[ ( dbfTmpLeng )->( FieldPos( "cDesTik" ) ) ] ) .and. empty( aTmp[ ( dbfTmpLeng )->( FieldPos( "cDesArt" ) ) ] )
      MsgStop( "Tiene que introducir al menos una descripción." )
      aGet[ ( dbfTmpLeng )->( FieldPos( "cDesTik" ) ) ]:SetFocus()
      Return .f.
   end if

   /*
   Nos aseguramos de que tomamos el código de artículo-------------------------
   */

   aTmp[ ( dbfTmpLeng )->( FieldPos( "cCodArt" ) ) ]  := aTmpArt[ ( D():Articulos( nView ) )->( FieldPos( "Codigo" ) ) ]

   /*
   Guardamos el fichero temporal-----------------------------------------------
   */

   WinGather( aTmp, aGet, dbfTmpLeng, oBrw, nMode )

   oDlg:End( IDOK )

Return ( .t. )

//---------------------------------------------------------------------------//

static function aLlenaPropiedades( cCodigoPropiedad, nValPrp, nMode, oBrw )

   local a
   local nRec
   local nOrdAnt
   local aValores       := {}
   local oTemporal

   if len( oBrw:aSelected ) >= 1 .and. nMode != APPD_MODE

      nRec              := ( dbfTblPro )->( Recno() )
      nOrdAnt           := ( dbfTblPro )->( OrdSetFocus( "cCodPro" ) )

      for each a in oBrw:aSelected
         
         ( dbfTmpVta )->( dbGoTo( a ) )

         if ( dbfTmpVta )->cCodPr1 == cCodigoPropiedad

            if aScan( aValores, {|a| a:cCodPrp == cCodigoPropiedad .and. a:cValPrp == ( dbfTmpVta )->cValPr1 } ) == 0

               if ( dbfTblPro )->( dbSeek( ( dbfTmpVta )->cCodPr1 + ( dbfTmpVta )->cValPr1 ) ) 

                  oTemporal                     := SValorPropiedades()
                  oTemporal:cCodPrp             := cCodigoPropiedad
                  oTemporal:cValPrp             := ( dbfTmpVta )->cValPr1
                  oTemporal:cDesPrp             := ( dbfTblPro )->cDesTbl
                  oTemporal:nColor              := ( dbfTblPro )->nColor
                  oTemporal:lSel                := .t.

                  aAdd( aValores, oTemporal )

               end if

            end if

         end if

         if ( dbfTmpVta )->cCodPr2 == cCodigoPropiedad

            if aScan( aValores, {|a| a:cCodPrp == cCodigoPropiedad .and. a:cValPrp == ( dbfTmpVta )->cValPr2 } ) == 0

               if ( dbfTblPro )->( dbSeek( ( dbfTmpVta )->cCodPr2 + ( dbfTmpVta )->cValPr2 ) ) 

                  oTemporal                     := SValorPropiedades()
                  oTemporal:cCodPrp             := cCodigoPropiedad
                  oTemporal:cValPrp             := ( dbfTmpVta )->cValPr2
                  oTemporal:cDesPrp             := ( dbfTblPro )->cDesTbl
                  oTemporal:nColor              := ( dbfTblPro )->nColor
                  oTemporal:lSel                := .t.

                  aAdd( aValores, oTemporal )

               end if

            end if

         end if

      next

      ( dbfTblPro )->( OrdSetFocus( nOrdAnt ) )
      ( dbfTblPro )->( dbGoTo( nRec ) )
   
   else

      nRec              := ( dbfTblPro )->( Recno() )
      nOrdAnt           := ( dbfTblPro )->( OrdSetFocus( "cPro" ) )

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

   end if

return aValores

//--------------------------------------------------------------------------//

static function SeleccionPropiedad( aValPrp, oBrwPrp, nPos )

   aValPrp[ nPos ]:lSel   := !aValPrp[ nPos ]:lSel

   if !empty( oBrwPrp )
      oBrwPrp:Refresh()
   end if

Return .t.

//--------------------------------------------------------------------------//

static function lSelAllPrp( aValPrp, oBrwPrp, lVal )

   local n := 0

   for n:= 1 to Len( aValPrp )
      aValPrp[ n ]:lSel    := lVal
   next

   if !empty( oBrwPrp )
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
   local nOrdAnt     := ( dbfTmpVta )->( OrdSetFocus( "cCodArt" ) )

   if nMode == APPD_MODE .or. Len( oBrw:aSelected ) > 1

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

                     if ( dbfTmpVta )->( dbSeek( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodArt" ) ) ] + aVal1:cCodPrp + Space( 40 ) + aVal1:cValPrp + Space( 40 ) ) )

                        aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] := aVal1:cCodPrp
                        aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ] := aVal1:cValPrp
                        aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ]   := mSer2Mem()

                        WinGather( aTmp, , dbfTmpVta, oBrw, EDIT_MODE, , .f. )

                        nContEdt++

                     else

                        aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] := aVal1:cCodPrp
                        aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ] := aVal1:cValPrp
                        aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ] := mSer2Mem()

                        WinGather( aTmp, , dbfTmpVta, oBrw, APPD_MODE, , .f. )

                        nContAdd++

                     end if

                  end if

               next

            else

               if ( dbfTmpVta )->( dbSeek( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodArt" ) ) ] + aValPrp1[ oBrwPrp1:nArrayAt ]:cCodPrp + Space( 20 ) + aValPrp1[oBrwPrp1:nArrayAt]:cValPrp + Space( 20 ) ) )

                  aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp
                  aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cValPrp
                  aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ]   := mSer2Mem()

                  WinGather( aTmp, , dbfTmpVta, oBrw, EDIT_MODE, , .f. )

                  nContEdt++

               else

                  aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp
                  aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cValPrp
                  aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ]   := mSer2Mem()

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

                           if ( dbfTmpVta )->( dbSeek( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodArt" ) ) ] + aVal1:cCodPrp + aVal2:cCodPrp + aVal1:cValPrp + aVal2:cValPrp ) )

                              aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] := aVal1:cCodPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ] := aVal1:cValPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ] := aVal2:cCodPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr2" ) ) ] := aVal2:cValPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ]   := mSer2Mem()

                              WinGather( aTmp, , dbfTmpVta, oBrw, EDIT_MODE, , .f. )

                              nContEdt++

                           else

                              aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] := aVal1:cCodPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ] := aVal1:cValPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ] := aVal2:cCodPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr2" ) ) ] := aVal2:cValPrp
                              aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ]   := mSer2Mem()

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

                        if ( dbfTmpVta )->( dbSeek( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodArt" ) ) ] + aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp + aVal2:cCodPrp + aValPrp1[oBrwPrp1:nArrayAt]:cValPrp + aVal2:cValPrp ) )

                           aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cValPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ] := aVal2:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr2" ) ) ] := aVal2:cValPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ]   := mSer2Mem()

                           WinGather( aTmp, , dbfTmpVta, oBrw, EDIT_MODE, , .f. )

                           nContEdt++

                        else

                           aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cValPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ] := aVal2:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr2" ) ) ] := aVal2:cValPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ]   := mSer2Mem()

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

                        if ( dbfTmpVta )->( dbSeek( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodArt" ) ) ] + aVal1:cCodPrp + aValPrp2[oBrwPrp2:nArrayAt]:cCodPrp + aVal1:cValPrp + aValPrp2[oBrwPrp2:nArrayAt]:cValPrp ) )

                           aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] := aVal1:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ] := aVal1:cValPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cValPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ]   := mSer2Mem()

                           WinGather( aTmp, , dbfTmpVta, oBrw, EDIT_MODE, , .f. )

                           nContEdt++

                        else

                           aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] := aVal1:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ] := aVal1:cValPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cCodPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cValPrp
                           aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ]   := mSer2Mem()

                           WinGather( aTmp, , dbfTmpVta, oBrw, APPD_MODE, , .f. )

                           nContAdd++

                        end if

                     end if

                  next

                  msgWait( "He añadido " + AllTrim( Str( nContAdd ) ) + " registros y he modificado " + AllTrim( Str( nContEdt ) ) + " registros", "Proceso terminado con éxito", 2 )

                  lLimpiarPantalla( aValPrp1, aValPrp2, aTmp, aGet, oBrwPrp1, oBrwPrp2, oSay, cSay, dbfTmpVta )

               case !lSelPr1 .and. !lSelPr2

                  if ( dbfTmpVta )->( dbSeek( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodArt" ) ) ] + aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp + aValPrp2[oBrwPrp2:nArrayAt]:cCodPrp + aValPrp1[oBrwPrp1:nArrayAt]:cValPrp + aValPrp2[oBrwPrp2:nArrayAt]:cValPrp ) )

                     aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cValPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cCodPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cValPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ]   := mSer2Mem()

                     WinGather( aTmp, , dbfTmpVta, oBrw, EDIT_MODE, , .f. )

                     nContEdt++

                  else

                     aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cCodPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr1" ) ) ] := aValPrp1[oBrwPrp1:nArrayAt]:cValPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cCodPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "cValPr2" ) ) ] := aValPrp2[oBrwPrp2:nArrayAt]:cValPrp
                     aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ]   := mSer2Mem()

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
      aTmp[ ( dbfTmpVta )->( FieldPos( "MIMGWEB" ) ) ]   := mSer2Mem()

      WinGather( aTmp, aGet, dbfTmpVta, oBrw, nMode )

   end if

   if nMode != APPD_MODE
      oDlg:End( IDOK )
   end if

   ( dbfTmpVta )->( OrdSetFocus( nOrdAnt ) )

   if !empty( oBrw )
      oBrw:Refresh()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

static function lLimpiarPantalla( aValPrp1, aValPrp2, aTmp, aGet, oBrwPrp1, oBrwPrp2, oSay, cSay, dbfTmpVta )

   local aValPrp
   local cCodArt           := aTmp[ ( dbfTmpVta )->( FieldPos( "cCodArt" ) ) ]
   local cCodPrp1          := aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ]
   local cCodPrp2          := aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ]

   /*
   Desmarcamos todas las opciones en los arrays de propiedades-----------------
   */

   for each aValPrp in aValPrp1
      aValPrp:lSel         := .f.
   next

   if !empty( oBrwPrp1 )
      oBrwPrp1:Refresh()
   end if

   for each aValPrp in aValPrp2
      aValPrp:lSel         := .f.
   next

   if !empty( oBrwPrp2 )
      oBrwPrp2:Refresh()
   end if

   /*
   Vaciamos el array temporal y le damos los valores por defecto---------------
   */

   aCopy( dbBlankRec( dbfTmpVta ), aTmp )

   aTmp[ ( dbfTmpVta )->( FieldPos( "cCodArt" ) ) ]   := cCodArt
   aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ]   := cCodPrp1
   aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ]   := cCodPrp2

   cSay[1]                 := aBenefSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr1" ) ) ], 1 ) ]
   cSay[2]                 := aBenefSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr2" ) ) ], 1 ) ]
   cSay[3]                 := aBenefSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr3" ) ) ], 1 ) ]
   cSay[4]                 := aBenefSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr4" ) ) ], 1 ) ]
   cSay[5]                 := aBenefSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr5" ) ) ], 1 ) ]
   cSay[6]                 := aBenefSobre[ Max( aTmp[ ( dbfTmpVta )->( fieldpos( "nBnfSbr6" ) ) ], 1 ) ]

   if !empty( aGet )
      aEval( aGet, {| o | if( !empty( o ), o:Refresh(), ) } )
   end if

   if !empty( oSay )
      aEval( oSay, {| o | if( !empty( o ), o:Refresh(), ) } )
   end if

return ( .t. )

//---------------------------------------------------------------------------//
/*
Edita las asociaciones con los codigos de barras
*/

STATIC FUNCTION EdtCodebar( aTmp, aGet, dbfTmpCodebar, oBrw, bWhen, bValid, nMode, aArt )

	local oDlg
   local cOldCodebar                                     := aTmp[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ]

   aTmp[ ( dbfTmpCodebar )->( FieldPos( "cCodPr1" ) ) ]  := aArt[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ]
   aTmp[ ( dbfTmpCodebar )->( FieldPos( "cCodPr2" ) ) ]  := aArt[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ]

   DEFINE DIALOG oDlg RESOURCE "ArtCode" TITLE LblTitle( nMode ) + "codigos de barras"

      REDEFINE GET   aGet[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ] ;
            VAR      aTmp[ ( dbfTmpCodebar )->( fieldPos( "cCodBar" ) ) ] ;
            BITMAP   "gc_calculator_16" ;
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
            VALID    ( lPrpAct( aTmp[ ( dbfTmpCodebar )->( FieldPos( "cValPr1" ) ) ], aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr1" ) ) ]:oHelpText, aTmp[ ( dbfTmpCodebar )->( FieldPos( "cCodPr1" ) ) ], dbfTblPro ) ) ;
            ON HELP  ( brwPropiedadActual( aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr1" ) ) ], aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr1" ) ) ]:oHelpText, aTmp[ ( dbfTmpCodebar )->( FieldPos( "cCodPr1" ) ) ] ) ) ;
            OF       oDlg

      REDEFINE GET   aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ] ;
            VAR      aTmp[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ] ;
            ID       130 ;
            IDSAY    132 ;
            IDTEXT   131 ;
            PICTURE  "@!" ;
            BITMAP   "LUPA" ;
            VALID    ( lPrpAct( aTmp[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ], aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ]:oHelpText, aTmp[ ( dbfTmpCodebar )->( FieldPos( "cCodPr2" ) ) ], dbfTblPro ) ) ;
            ON HELP  ( brwPropiedadActual( aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ], aGet[ ( dbfTmpCodebar )->( FieldPos( "cValPr2" ) ) ]:oHelpText, aTmp[ ( dbfTmpCodebar )->( FieldPos( "cCodPr2" ) ) ] ) ) ;
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
                    + AllTrim( ( dbfCodebar )->cCodArt ) + " - " + AllTrim( RetFld( ( dbfCodebar )->cCodArt, D():Articulos( nView ) ) ) ,"¿Desea introducirlo en éste artículo?" )

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

   if empty( cCodBar )
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

Static Function StartEdtVta( aTmp, aGet, nMode, oBrwPrp1, oBrwPrp2, oTodasPrp1, oNingunaPrp1, oTodasPrp2, oNingunaPrp2, oBtnOk, oBtnCancel, oSay, oPrp1, oSayPr1, oSayVp1, oPrp2, oSayPr2, oSayVp2 )

   if nMode == APPD_MODE

      if !empty( oBtnOk )
         SetWindowText( oBtnOk:hWnd, "Añadir [F5]" )
      end if

      if !empty( oBtnCancel )
         SetWindowText( oBtnCancel:hWnd, "Salir" )
      end if

      if !empty( oBrwPrp1 )
         oBrwPrp1:Load()
      end if

      if !empty( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ] )
         
         if !empty( oBrwPrp2 )
            oBrwPrp2:Load()
            oBrwPrp2:Show()
         end if

         if !empty( oTodasPrp2 ) 
            oTodasPrp2:Show()
         end if 
      
         if !empty( oNingunaPrp2 ) 
            oNingunaPrp2:Show()
         end if 

      end if 

   else

      if !empty( oBtnOk )
         SetWindowText( oBtnOk:hWnd, "Aceptar [F5]" )
      end if

      if !empty( oBtnCancel )
         SetWindowText( oBtnCancel:hWnd, "Cancelar" )
      end if

      if !empty( oBrwPrp1 )
         oBrwPrp1:Hide()
      end if

      if !empty( oBrwPrp2 )
         oBrwPrp2:Hide()
      end if

      if !empty( oTodasPrp1 ) 
         oTodasPrp1:Hide()
      end if 

      if !empty( oNingunaPrp1 )
         oNingunaPrp1:Hide()
      end if 

      if !empty( oTodasPrp2 ) 
         oTodasPrp2:Hide()
      end if 
   
      if !empty( oNingunaPrp2 ) 
         oNingunaPrp2:Hide()
      end if 

      // mostramos las propiedades para poder modificar------------------------

      oPrp1:show()
      oPrp1:lValid()

      oSayPr1:show()
      oSayPr1:setText( retProp( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr1" ) ) ], dbfPro ) )
      oSayVp1:show()

      if !empty( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ] )
         oPrp2:show()
         oPrp2:lValid()

         oSayPr2:show()
         oSayPr2:setText( retProp( aTmp[ ( dbfTmpVta )->( FieldPos( "cCodPr2" ) ) ], dbfPro ) )
         oSayVp2:show()      
      end if

   end if

   // Textos de etiquetas------------------------------------------------------

   oSay[ 7 ]:SetText( uFieldEmpresa( "cTxtTar1", "Precio 1" ) )

   if uFieldEmpresa( "lShwTar2" )
      oSay[ 8 ]:SetText( uFieldEmpresa( "cTxtTar2", "Precio 2" ) )
   else
      oSay[ 8 ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "lBnf2" ) ) ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "Benef2" ) ) ]:Hide()
      oSay[ 2 ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta2" ) ) ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva2" ) ) ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar3" )
      oSay[ 9 ]:SetText( uFieldEmpresa( "cTxtTar3", "Precio 3" ) )
   else
      oSay[ 9 ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "lBnf3" ) ) ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "Benef3" ) ) ]:Hide()
      oSay[ 3 ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta3" ) ) ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva3" ) ) ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar4" )
      oSay[ 10 ]:SetText( uFieldEmpresa( "cTxtTar4", "Precio 4" ) )
   else
      oSay[ 10 ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "lBnf4" ) ) ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "Benef4" ) ) ]:Hide()
      oSay[ 4 ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta4" ) ) ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva4" ) ) ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar5" )
      oSay[ 11 ]:SetText( uFieldEmpresa( "cTxtTar5", "Precio 5" ) )
   else
      oSay[ 11 ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "lBnf5" ) ) ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "Benef5" ) ) ]:Hide()
      oSay[ 5 ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta5" ) ) ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva5" ) ) ]:Hide()
   end if

   if uFieldEmpresa( "lShwTar6" )
      oSay[ 12 ]:SetText( uFieldEmpresa( "cTxtTar6", "Precio 6" ) )
   else
      oSay[ 12 ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "lBnf6" ) ) ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "Benef6" ) ) ]:Hide()
      oSay[ 6 ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "nPreVta6" ) ) ]:Hide()
      aGet[ ( dbfTmpVta )->( fieldpos( "nPreIva6" ) ) ]:Hide()
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
      nCos        := nCosto( aTmp[ ( dbfTmpKit )->( fieldpos( "cRefKit" ) ) ], D():Articulos( nView ), dbfArtKit, )
   end if

   DEFINE DIALOG oDlg RESOURCE "ARTKIT" TITLE LblTitle( nMode ) + "escandallos"

      REDEFINE GET aGet[ ( dbfTmpKit )->( fieldpos( "cRefKit" ) ) ] ;
         VAR      aTmp[ ( dbfTmpKit )->( fieldpos( "cRefKit" ) ) ];
			PICTURE	"@!" ;
			WHEN 		( nMode == APPD_MODE ) ;
         VALID    ( ChkCodKit( aGet, oCos, dbfTmpKit ) ) ;
			ID 		100 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwSelArticulo( aGet[ ( dbfTmpKit )->( fieldpos( "cRefKit" ) ) ], nil, .f., .f., .f. );
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
         ACTION   ( lPreSaveKit( aGet, aTmp, dbfTmpKit, D():Articulos( nView ), oBrw, nMode, oDlg, aTmpArt ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )


   oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Function lPreSaveKit( aGet, aTmp, dbfTmpKit, dbfArt, oBrw, nMode, oDlg, aTmpArt, nCos )

   if empty( aTmp[ ( dbfTmpKit )->( fieldpos( "cRefKit" ) ) ] )
      msgstop( "El código no puede estar vacío" )
      aGet[ ( dbfTmpKit )->( fieldpos( "cRefKit" ) ) ]:SetFocus()
      Return .f.
   end if

   if aTmp[ ( dbfTmpKit )->( fieldpos( "cRefKit" ) ) ] == aTmpArt[ ( dbfArt )->( FieldPos( "Codigo" ) ) ]
      MsgStop( "El código es el mismo que el del escandallo", "No se puede introducir" )
      aGet[ ( dbfTmpKit )->( fieldpos( "cRefKit" ) ) ]:SetFocus()
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
	local nRecArt	:= ( D():Articulos( nView ) )->( recno() )

   cRefKit        := cSeekCodebar( cRefKit, dbfCodebar, D():Articulos( nView ) )

   if dbSeekInOrd( cRefKit, "Codigo", D():Articulos( nView ) )

      if dbSeekInOrd( cRefKit, "cRefKit", dbfTmpKit )

         msgStop( "Código duplicado" )

      else

         aGet[ ( dbfTmpKit )->( fieldpos( "cRefKit" ) ) ]:cText( ( D():Articulos( nView ) )->Codigo  )
         aGet[ ( dbfTmpKit )->( fieldpos( "cDesKit" ) ) ]:cText( ( D():Articulos( nView ) )->Nombre  )
         aGet[ ( dbfTmpKit )->( fieldpos( "cUnidad" ) ) ]:cText( ( D():Articulos( nView ) )->cUnidad )

         oCos:cText( ( D():Articulos( nView ) )->pCosto )

         lRet     := .t.

      end if

   else

      msgStop( "Código no existe" )

   end if

	( D():Articulos( nView ) )->( dbGoTo( nRecArt ) )
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
         VALID    ( cTiva( oTipIva, D():TiposIva( nView ), oIvaName ) );
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
         TOTAL    ( D():Articulos( nView ) )->( lastrec() )

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
   local aStaArt  := aGetStatus( D():Articulos( nView ), .t. )
   local aStaPrv  := aGetStatus( D():ProveedorArticulo( nView ) )

   ( D():ProveedorArticulo( nView ) )->( OrdSetFocus( "cRefPrv" ) )

	CursorWait()

   lEnd              := .f.

   if File ( cFileName )

      oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cFileName ) NEW VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "EXTFIL", @dbfExt ) )

      nPctIva        := nIva( D():TiposIva( nView ), cTipIva )
      oPrc:nTotal    := ( dbfExt )->( LastRec() + 1 )

      while !( dbfExt )->( Eof() )

         /*
         Comprobamos si existe la familia--------------------------------------
         */

         cCodFam     := cCodFamPrv( cProvee, ( dbfExt )->CodSubFami, dbfFamPrv )
         cCodArt     := Rtrim( cCodFam ) + "." + ( dbfExt )->Codigo

         if !( D():Articulos( nView ) )->( dbSeek( cCodArt ) )
            ( D():Articulos( nView )  )->( dbAppend() )
            cNomArt  := OemToAnsi( ( dbfExt )->Titulo )
         else
            ( D():Articulos( nView ) )->( dbRLock() )
            cNomArt  := ( D():Articulos( nView ) )->Nombre
         end if

         /*
         Si ya existe el Articulo ten solo modificamos precios y sobreescribimos el proveedor por si acaso
         */

         ( D():Articulos( nView ) )->Codigo  := cCodArt
         ( D():Articulos( nView ) )->Nombre  := cNomArt
         ( D():Articulos( nView ) )->Familia := cCodFam
         ( D():Articulos( nView ) )->pCosto  := ( dbfExt )->Precio

         ( D():Articulos( nView ) )->Benef1  := nPctBnf1
         ( D():Articulos( nView ) )->Benef2  := nPctBnf2
         ( D():Articulos( nView ) )->Benef3  := nPctBnf3
         ( D():Articulos( nView ) )->Benef4  := nPctBnf4
         ( D():Articulos( nView ) )->Benef5  := nPctBnf5
         ( D():Articulos( nView ) )->Benef6  := nPctBnf6

         ( D():Articulos( nView ) )->pVenta1 := ( ( D():Articulos( nView ) )->PCOSTO * nPctBnf1 / 100 ) + ( D():Articulos( nView ) )->PCOSTO
         ( D():Articulos( nView ) )->pVenta2 := ( ( D():Articulos( nView ) )->PCOSTO * nPctBnf2 / 100 ) + ( D():Articulos( nView ) )->PCOSTO
         ( D():Articulos( nView ) )->pVenta3 := ( ( D():Articulos( nView ) )->PCOSTO * nPctBnf3 / 100 ) + ( D():Articulos( nView ) )->PCOSTO
         ( D():Articulos( nView ) )->pVenta4 := ( ( D():Articulos( nView ) )->PCOSTO * nPctBnf4 / 100 ) + ( D():Articulos( nView ) )->PCOSTO
         ( D():Articulos( nView ) )->pVenta5 := ( ( D():Articulos( nView ) )->PCOSTO * nPctBnf5 / 100 ) + ( D():Articulos( nView ) )->PCOSTO
         ( D():Articulos( nView ) )->pVenta6 := ( ( D():Articulos( nView ) )->PCOSTO * nPctBnf6 / 100 ) + ( D():Articulos( nView ) )->PCOSTO

         ( D():Articulos( nView ) )->pVtaIva1:= Round( ( ( D():Articulos( nView ) )->PVENTA1 * nPctIva / 100 ) + ( D():Articulos( nView ) )->PVENTA1, nDecDiv )
         ( D():Articulos( nView ) )->pVtaIva2:= Round( ( ( D():Articulos( nView ) )->PVENTA2 * nPctIva / 100 ) + ( D():Articulos( nView ) )->PVENTA2, nDecDiv )
         ( D():Articulos( nView ) )->pVtaIva3:= Round( ( ( D():Articulos( nView ) )->PVENTA3 * nPctIva / 100 ) + ( D():Articulos( nView ) )->PVENTA3, nDecDiv )
         ( D():Articulos( nView ) )->pVtaIva4:= Round( ( ( D():Articulos( nView ) )->PVENTA4 * nPctIva / 100 ) + ( D():Articulos( nView ) )->PVENTA4, nDecDiv )
         ( D():Articulos( nView ) )->pVtaIva5:= Round( ( ( D():Articulos( nView ) )->PVENTA5 * nPctIva / 100 ) + ( D():Articulos( nView ) )->PVENTA5, nDecDiv )
         ( D():Articulos( nView ) )->pVtaIva6:= Round( ( ( D():Articulos( nView ) )->PVENTA6 * nPctIva / 100 ) + ( D():Articulos( nView ) )->PVENTA6, nDecDiv )

         ( D():Articulos( nView ) )->TipoIva := cTipIva
         ( D():Articulos( nView ) )->lObs    := .f.

         ( D():Articulos( nView ) )->( dbUnLock() )

         oPrc:Set( ( dbfExt )->( RecNo() ) )

         /*
         Referencia de los proveedores--------------------------------------
         */

         if !( D():ProveedorArticulo( nView ) )->( dbSeek( cProvee + ( dbfExt )->Codigo ) )
            ( D():ProveedorArticulo( nView ) )->( dbAppend() )
         else
            ( D():ProveedorArticulo( nView ) )->( dbRLock() )
         end if

         ( D():ProveedorArticulo( nView ) )->cCodArt  := cCodArt
         ( D():ProveedorArticulo( nView ) )->cCodPrv  := cProvee
         ( D():ProveedorArticulo( nView ) )->cRefPrv  := ( dbfExt )->Codigo
         ( D():ProveedorArticulo( nView ) )->cDivPrv  := cDivEmp()

         ( D():ProveedorArticulo( nView ) )->( dbUnLock() )

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

   SetStatus( D():Articulos( nView ), aStaArt )
   SetStatus( D():ProveedorArticulo( nView ),   aStaPrv )

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
         nIvaPct  := nIva( , uTipIva )
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

      if !empty( cCodImp ) .and. !empty( oNewImp )
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

   if !Empty ( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cImagen" ) ) ] )
      cImagenArt  := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cImagen" ) ) ]
   else
      cImagenArt  := cFirstImage( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ], D():ArticuloImagenes( nView ) )
   end if

   if empty( GetPath( cImagenArt ) )
      cImagenArt  := uFieldEmpresa( "cDirImg" ) + "\" + cImagenArt
   end if

return cImagenArt

//---------------------------------------------------------------------------//

/*
Esta funci¢n calcula el beneficio que se esta aplicando a un articulo sin impuestos
*/

Function CalBnfPts( lSobreCoste, lIvaInc, nCosto, nPrePts, oBnf, uTipIva, oGetIvaPts, nDecDiv, cCodImp, oSay, lMargenAjuste, cMargenAjuste )

   local nIvm     := 0
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
		Proteccion contra limites
		*/

      if oBnf != nil

         if nNewBnf > 0 .and. nNewBnf < 999
   			oBnf:cText( nNewBnf )
         else
   			oBnf:cText( 0 )
         end

      end if

   end if

   /*
   Tipos de impuestos
   */

   if ValType( uTipIva ) == "C"
      nIvaPct     := nIva( D():TiposIva( nView ), uTipIva )
   else
      nIvaPct     := uTipIva
   end if

   /*
   Despues si tiene impuesto especial
   */

   /*if !empty( cCodImp ) .and. !empty( oNewImp )
      nIvm        += oNewImp:nValImp( cCodImp, .t., nIvaPct )
   end if*/

	/*
   Calculo del impuestos-------------------------------------------------------
	*/

   /*if uFieldEmpresa( "lIvaImpEsp" )
      nNewIva     += nIvm
   end if */

   nNewIva        += ( nNewIva * nIvaPct / 100 )

   /*if !uFieldEmpresa( "lIvaImpEsp" )
      nNewIva     += nIvm
   end if */

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

   local nIvm     := 0
	local nNewBnf
	local nNewPre
	local nIvaPct
   local nPreIva

   if !lIvaInc
      Return .t.
   end if

   if IsChar( uTipIva )
      nIvaPct     := nIva( D():TiposIva( nView ), uTipIva )
   else
      nIvaPct     := uTipIva
   end if

   if IsObject( uPrecioIva )
      nPreIva     := Round( uPrecioIva:VarGet(), nDecDiv )
   else
      nPreIva     := Round( uPrecioIva, nDecDiv )
   end if

   if ( nPreIva <= 0 )
      Return .t.
   end if 

   // Margen de ajuste

   if IsTrue( lMargenAjuste )
      
      nPreIva     := nAjuste( nPreIva, cMargenAjuste )

      if IsObject( uPrecioIva )
         uPrecioIva:cText( Round( nPreIva, nDecDiv ) )
      end if 

   end if

   // Impuesto especial

   /*if !empty( cCodImp ) .and. !empty( oNewImp )
      nIvm        := oNewImp:nValImp( cCodImp, lIvaInc, nIvaPct )
   end if */
	
   // Primero es quitar el impuestos

   /*if !uFieldEmpresa( "lIvaImpEsp" )
      nPreIva     -= nIvm
   end if */

   nNewPre        := Round( nPreIva / ( 1 + nIvaPct / 100 ), nDecDiv )

   /*if uFieldEmpresa( "lIvaImpEsp" ) 
      nNewPre     -= nIvm
   end if */

	// Actualizamos la base

   oGetBas:cText( nNewPre )

	// Solo procedemos si el % de beneficio es != 0

   if nCosto != 0

      nNewBnf     := nPorcentajeBeneficio( lSobreCoste, nNewPre, nCosto )

      if oBnf != nil

         if nNewBnf > 0 .and. nNewBnf < 999
			   oBnf:cText( nNewBnf )
         else
   			oBnf:cText( 0 )
         end if

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

Static Function CalculaDescuentoWeb( aGet, aTmp )

   local nImpWeb

   if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lSbrInt" ) ) ]

      if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nDtoInt1" ) ) ] != 0

         nImpWeb     := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVtaWeb"  ) ) ] 
         nImpWeb     -= aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVtaWeb"  ) ) ] * aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nDtoInt1" ) ) ] / 100 

         aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ]:cText( nImpWeb )
         aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpIva1" ) ) ]:cText( ( nImpWeb * nIva( D():TiposIva( nView ), aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva"  ) ) ] ) / 100 ) + nImpWeb )

      else
      
         ChangeTarifaPrecioWeb( aGet, aTmp )

      end if   

   end if

return .t.

//----------------------------------------------------------------------------//

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

   ( D():Familias( nView )  )->( OrdSetFocus( "cNomFam" ) )
   ( D():Articulos( nView ) )->( OrdSetFocus( "cFamCod" ) )

   cPouDiv           := cPouDiv( cDivEmp(), dbfDiv )

   DEFINE DIALOG oDlg RESOURCE "HELPARTFAM" TITLE "Artículos"

      REDEFINE GET oGetFamilia VAR cGetFamilia;
         ID       106 ;
         PICTURE  "@!" ;
         ON CHANGE( if( AutoSeek( nKey, nFlags, Self, oBrwFam, D():Familias( nView ), .t. ), SeekFamilia( oCbxOrd, oBrw ), ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxFamilia ;
         VAR      cCbxFamilia ;
         ID       107 ;
         ITEMS    aCbxFamilia ;
         ON CHANGE( ( D():Familias( nView ) )->( ordSetFocus( oCbxFamilia:nAt ) ), ( D():Familias( nView ) )->( dbGoTop() ), oBrwFam:Refresh() );
         OF       oDlg

      oBrwFam                 := IXBrowse():New( oDlg )

      oBrwFam:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwFam:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwFam:cAlias          := D():Familias( nView )
      oBrwFam:nMarqueeStyle   := 5
      oBrwFam:cName           := "Browse.Familias en artículos"

      with object ( oBrwFam:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodFam"
         :bEditValue       := {|| ( D():Familias( nView ) )->cCodFam }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxFamilia:Set( oCol:cHeader ) }
      end with

      with object ( oBrwFam:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomFam"
         :bEditValue       := {|| ( D():Familias( nView ) )->cNomFam }
         :nWidth           := 120
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxFamilia:Set( oCol:cHeader ) }
      end with

      oBrwFam:bChange      := {|| SeekFamilia( oCbxOrd, oBrw ) }

      oBrwFam:CreateFromResource( 103 )

      REDEFINE GET oGetArticulo VAR cGetArticulo;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, D():Articulos( nView ), .t., if( ( D():Articulos( nView ) )->( OrdSetFocus() ) $ "CFAMCOD CFAMNOM", ( D():Familias( nView ) )->cCodFam, ) ) );
         PICTURE  "@!" ;
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( D():Articulos( nView ) )->( ordSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGetArticulo:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := D():Articulos( nView )
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Artículos"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Codigo"
         :bEditValue       := {|| ( D():Articulos( nView ) )->Codigo }
         :nWidth           := 90
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Nombre"
         :bEditValue       := {|| ( D():Articulos( nView ) )->Nombre }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      /*with object ( oBrw:AddCol() )
         :cHeader          := "Stocks"
         :bStrData         := {|| Trans( oStock:nTotStockAct( ( D():Articulos( nView ) )->Codigo, , , , , lEscandallo( D():Articulos( nView ) ), ( D():Articulos( nView ) )->nKitStk, ( D():Articulos( nView ) )->nCtlStock ), cPicUnd ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with*/

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" ) + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 2, nil, .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" ) + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 2, nil, .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 3, nil, .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" ) + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 3, nil, .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 4, nil, .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" ) + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 4, nil, .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 5, nil, .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" ) + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 5, nil, .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 6, nil, .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" ) + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 6, nil, .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      if oUser():lCostos()

      with object ( oBrw:AddCol() )
         :cHeader          := "Costo"
         :bStrData         := {|| nCosto( nil, D():Articulos( nView ), dbfArtKit, .t., if( lEuro, cDivChg(), cDivEmp() ), dbfDiv ) }
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
         ACTION   ( WinAppRec( oBrw, bEdit, D():Articulos( nView ) ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 );
         ACTION   ( WinEdtRec( oBrw, bEdit, D():Articulos( nView ) ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F2,       {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, D():Articulos( nView ) ), ) } )
      oDlg:AddFastKey( VK_F3,       {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, D():Articulos( nView ) ), ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )

      oDlg:bStart := {|| oBrwFam:Load(), oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      if lCodeBar
         oGet:cText( ( D():Articulos( nView ) )->CodeBar )
      else
         oGet:cText( ( D():Articulos( nView ) )->Codigo )
      end if

      if oGet2 != nil
         oGet2:cText( ( D():Articulos( nView ) )->Nombre )
      end if

   end if

   CloseFiles()

   /*
   Guardamos los datos del browse
   */

   oBrw:CloseData()

RETURN oDlg:nResult == IDOK

//---------------------------------------------------------------------------//

Static Function SeekFamilia( oCbxOrd, oBrw )

   ( D():Articulos( nView ) )->( OrdScope( 0, nil ) )
   ( D():Articulos( nView ) )->( OrdScope( 1, nil ) )

   if !empty( ( D():Familias( nView ) )->cCodFam ) .and. ( D():Articulos( nView ) )->( dbSeek( ( D():Familias( nView ) )->cCodFam ) )

      ( D():Articulos( nView ) )->( OrdScope( 0, ( D():Familias( nView ) )->cCodFam ) )
      ( D():Articulos( nView ) )->( OrdScope( 1, ( D():Familias( nView ) )->cCodFam ) )

   end if

   ( D():Articulos( nView ) )->( dbGoTop() )

   oCbxOrd:Set( 'Familia + Código' )

   oBrw:Refresh()

Return .t.

//---------------------------------------------------------------------------//


STATIC FUNCTION CheckValid( aGet, dbf, nTag, nMode )

	Local nOldTag
   Local xClave   := aGet:VarGet()
   Local lReturn  := .t.

	DEFAULT nTag   := 1
   DEFAULT dbf    := Alias()

   if ( nMode == APPD_MODE ) .or. ( nMode == DUPL_MODE )

      if empty( xClave )
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

   local nOrdAnt  := ( D():ProveedorArticulo( nView ) )->( OrdSetFocus( 1 ) )

   InitWait()

   /*
   Referencia artículo proveedor
   */

   if ( D():ProveedorArticulo( nView ) )->( dbSeek( cCodArt ) )

      while ( ( D():ProveedorArticulo( nView ) )->cCodArt == cCodArt )

         if dbLock( D():ProveedorArticulo( nView ) )
            ( D():ProveedorArticulo( nView ) )->( dbDelete() )
            ( D():ProveedorArticulo( nView ) )->( dbUnLock() )
         end if

         ( D():ProveedorArticulo( nView ) )->( dbSkip( 1 ) )

      end while

   end if

   ( D():ProveedorArticulo( nView ) )->( OrdSetFocus( nOrdAnt ) )


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

   while ( D():ArticuloImagenes( nView ) )->( dbSeek( cCodArt ) )
      if dbLock( D():ArticuloImagenes( nView ) )
         ( D():ArticuloImagenes( nView ) )->( dbDelete() )
         ( D():ArticuloImagenes( nView ) )->( dbUnLock() )
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

   if ( D():ArticuloLenguaje( nView ) )->( dbSeek( cCodArt ) )

      while ( D():ArticuloLenguaje( nView ) )->cCodArt == cCodArt .and. !( D():ArticuloLenguaje( nView ) )->( eof() )

         if dbLock( D():ArticuloLenguaje( nView ) )
            ( D():ArticuloLenguaje( nView ) )->( dbDelete() )
            ( D():ArticuloLenguaje( nView ) )->( dbUnLock() )
         end if

         ( D():ArticuloLenguaje( nView ) )->( dbSkip() )

      end while

   end if

   EndWait()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION AppendReferenciaProveedor( cRefPrv, cCodPrv, cCodArt, nDtoPrv, nDtoPrm, cDivPrv, nImpPrv, dbfArtPrv, nMode )

   local nOrdAnt
   local lSetDefault

   if nImpPrv <= 0
      Return nil
   end if

   if empty( cCodPrv )
      Return nil 
   end if    

   if empty( cCodArt )
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

Function nRetPreCosto( cArticulo, cCodArt )

	local nPrecioCosto  := 0
	local nOrdAnt 	     := ( cArticulo )->( ordsetfocus( 1 ) )
	local nRecno        := ( cArticulo )->( recno() )

   if ( cArticulo )->( dbseek( cCodArt ) )
      nPrecioCosto     := ( cArticulo )->pCosto
   end if

	( cArticulo )->( dbgoto( nRecno ) )
	( cArticulo )->( ordsetfocus( nOrdAnt ) )

Return ( nPrecioCosto )

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

STATIC FUNCTION ChgPrc( oWndBrw )

	local oDlg
   local nOrd           := ( D():Articulos( nView ) )->( OrdSetFocus( "Codigo" ) )
   local nRec           := ( D():Articulos( nView ) )->( Recno() )
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

   cArtOrg              := dbFirst( D():Articulos( nView ), 1 )
   cArtDes              := dbLast ( D():Articulos( nView ), 1 )
   cSayArtOrg           := dbFirst( D():Articulos( nView ), 2 )
   cSayArtDes           := dbLast ( D():Articulos( nView ), 2 )

   REDEFINE GET oArtOrg VAR cArtOrg;
      ID       60 ;
      VALID    cArticulo( oArtOrg, D():Articulos( nView ), oSayArtOrg );
      BITMAP   "LUPA" ;
      ON HELP  BrwSelArticulo( oArtOrg, oSayArtOrg, .f., .f., .f. );
      OF       oDlg

   REDEFINE GET oSayArtOrg VAR cSayArtOrg ;
      WHEN     .f.;
      ID       70 ;
      OF       oDlg

   REDEFINE GET oArtDes VAR cArtDes;
      ID       80 ;
      VALID    cArticulo( oArtDes, D():Articulos( nView ), oSayArtDes );
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
      VALID    ( cTiva( oTipIva, D():TiposIva( nView ), oTxtIva ) );
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

   oMtr        := TApoloMeter():ReDefine( 220, { | u | if( pCount() == 0, nMtr, nMtr := u ) }, ( D():Articulos( nView ) )->( lastrec() ), oDlg, .f., , "Procesando", .f., Rgb( 255,255,255 ), , Rgb( 128,255,0 ) )

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

   ( D():Articulos( nView ) )->( OrdSetFocus( nOrd ) )
   ( D():Articulos( nView ) )->( dbGoTo( nRec ) )

   oWndBrw:Refresh()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION mkChgPrc( cFam, cGetTip, cIva, lCosto, lTarifa1, lTarifa2, lTarifa3, lTarifa4, lTarifa5, lTarifa6, lPesVol, nRad, nPctInc, nUndInc, lRnd, nDec, lMargenAjuste, cMargenAjuste, oComBox, cArtOrg, cArtDes, oMtr, oDlg, oWndBrw )

   local nIva
   local cExpFlt
   local nCounter := 0
   local nPrecio  := oComBox:nAt
   local nRecAct  := ( D():Articulos( nView ) )->( RecNo() )

   if !lCosto .and. !lTarifa1 .and. !lTarifa2 .and. !lTarifa3 .and. !lTarifa4 .and. !lTarifa5 .and. !lTarifa6 .and. !lPesVol
      msgStop( "No ha elegido ningúna tarifa a cambiar." )
      Return .f.
   end if

   oDlg:Disable()

   cExpFlt        := '!Deleted() '
   cExpFlt        += '.and. Codigo >= "' + cArtOrg + '"'
   cExpFlt        += '.and. Codigo <= "' + cArtDes + '"'

   if !empty( cFam )
      cExpFlt     += '.and. Familia == "' + cFam + '"'
   end if

   if !empty( cGetTip )
      cExpFlt     += '.and. cCodTip == "' + cGetTip + '"'
   end if

   if !empty( cIva )
      cExpFlt     += '.and. TipoIva == "' + cIva + '"'
   end if

   if CreateFastFilter( cExpFlt, D():Articulos( nView ), .f., oMtr )

      if ApoloMsgNoYes( "Se van a reemplazar los registros.", "¿Desea continuar?" )

         oMtr:SetTotal( ( D():Articulos( nView ) )->( OrdKeyCount() ) )

         ( D():Articulos( nView ) )->( dbGoTop() )
         while !( D():Articulos( nView ) )->( eof() )

            /*
            Valores para los calculos en todo el proceso-----------------------
            */

            nIva                                      := nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva ) / 100

            /*
            Vemos si cumplimos las condiciones de familia y tipo de impuestos--------
            */

            if dbLock( D():Articulos( nView ) )

               if lCosto

                  /*
                  Cambio de precios de costo-----------------------------------
                  */

                  if nRad == 1   //Incremento porcentual

                     ( D():Articulos( nView ) )->pCosto          := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pCosto )
                     ( D():Articulos( nView ) )->pCosto          += ( D():Articulos( nView ) )->pCosto * nPctInc / 100

                  else           //Incremento lineal

                     ( D():Articulos( nView ) )->pCosto          := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pCosto )
                     ( D():Articulos( nView ) )->pCosto          += nUndInc

                  end if

                  /*
                  Redondeamos
                  */

                  if lRnd
                     ( D():Articulos( nView ) )->pCosto          := Round( ( D():Articulos( nView ) )->pCosto, nDec )
                  end if

                  /*
                  Ajustamos
                  */

                  /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                     ( D():Articulos( nView ) )->pCosto          := nAjuste( ( D():Articulos( nView ) )->pCosto, ( D():Articulos( nView ) )->cMarAju )
                  elseif lMargenAjuste
                     ( D():Articulos( nView ) )->pCosto          := nAjuste( ( D():Articulos( nView ) )->pCosto, cMargenAjuste )
                  end if

                  if ( D():Articulos( nView ) )->lBnf1
                     ( D():Articulos( nView ) )->pVenta1         := CalPre( ( D():Articulos( nView ) )->nBnfSbr1 <= 1, ( D():Articulos( nView ) )->pCosto, .t., ( D():Articulos( nView ) )->Benef1, ( D():Articulos( nView ) )->TipoIva, nil, nil, nDecDiv, ( D():Articulos( nView ) )->cCodImp )
                     ( D():Articulos( nView ) )->pVtaIva1        := ( ( D():Articulos( nView ) )->pVenta1 * nIva ) + ( D():Articulos( nView ) )->pVenta1
                  end if

                  if ( D():Articulos( nView ) )->lBnf2
                     ( D():Articulos( nView ) )->pVenta2         := CalPre( ( D():Articulos( nView ) )->nBnfSbr2 <= 1, ( D():Articulos( nView ) )->pCosto, .t., ( D():Articulos( nView ) )->Benef2, ( D():Articulos( nView ) )->TipoIva, nil, nil, nDecDiv, ( D():Articulos( nView ) )->cCodImp )
                     ( D():Articulos( nView ) )->pVtaIva2        := ( ( D():Articulos( nView ) )->pVenta2 * nIva ) + ( D():Articulos( nView ) )->pVenta2
                  end if

                  if ( D():Articulos( nView ) )->lBnf3
                     ( D():Articulos( nView ) )->pVenta3         := CalPre( ( D():Articulos( nView ) )->nBnfSbr3 <= 1, ( D():Articulos( nView ) )->pCosto, .t., ( D():Articulos( nView ) )->Benef3, ( D():Articulos( nView ) )->TipoIva, nil, nil, nDecDiv, ( D():Articulos( nView ) )->cCodImp )
                     ( D():Articulos( nView ) )->pVtaIva3        := ( ( D():Articulos( nView ) )->pVenta3 * nIva ) + ( D():Articulos( nView ) )->pVenta3
                  end if

                  if ( D():Articulos( nView ) )->lBnf4
                     ( D():Articulos( nView ) )->pVenta4         := CalPre( ( D():Articulos( nView ) )->nBnfSbr4 <= 1, ( D():Articulos( nView ) )->pCosto, .t., ( D():Articulos( nView ) )->Benef4, ( D():Articulos( nView ) )->TipoIva, nil, nil, nDecDiv, ( D():Articulos( nView ) )->cCodImp )
                     ( D():Articulos( nView ) )->pVtaIva4        := ( ( D():Articulos( nView ) )->pVenta4 * nIva ) + ( D():Articulos( nView ) )->pVenta4
                  end if

                  if ( D():Articulos( nView ) )->lBnf5
                     ( D():Articulos( nView ) )->pVenta5         := CalPre( ( D():Articulos( nView ) )->nBnfSbr5 <= 1, ( D():Articulos( nView ) )->pCosto, .t., ( D():Articulos( nView ) )->Benef5, ( D():Articulos( nView ) )->TipoIva, nil, nil, nDecDiv, ( D():Articulos( nView ) )->cCodImp )
                     ( D():Articulos( nView ) )->pVtaIva5        := ( ( D():Articulos( nView ) )->pVenta5 * nIva ) + ( D():Articulos( nView ) )->pVenta5
                  end if

                  if ( D():Articulos( nView ) )->lBnf6
                     ( D():Articulos( nView ) )->pVenta6         := CalPre( ( D():Articulos( nView ) )->nBnfSbr6 <= 1, ( D():Articulos( nView ) )->pCosto, .t., ( D():Articulos( nView ) )->Benef6, ( D():Articulos( nView ) )->TipoIva, nil, nil, nDecDiv, ( D():Articulos( nView ) )->cCodImp )
                     ( D():Articulos( nView ) )->pVtaIva6        := ( ( D():Articulos( nView ) )->pVenta6 * nIva ) + ( D():Articulos( nView ) )->pVenta6
                  end if*/

               end if

               /*
               Estudio de precios de Tarifa 1----------------------------------
               */

               if lTarifa1 //.and. !( D():Articulos( nView ) )->lBnf5

                  if nRad == 1

                     /*
                     Los calculos se haran sobre el precio de costo
                     */

                     if nPrecio == 2

                        if !lMargenAjuste
                           ( D():Articulos( nView ) )->lBnf1     := .t.
                           ( D():Articulos( nView ) )->Benef1    := nPctInc
                        end if

                        /*
                        Si el pocentaje de beneficio es sobre el costo
                        */

                        ( D():Articulos( nView ) )->nBnfSbr1     := 1
                        ( D():Articulos( nView ) )->pVenta1      := ( D():Articulos( nView ) )->pCosto + ( ( D():Articulos( nView ) )->pCosto * nPctInc / 100 )
                        ( D():Articulos( nView ) )->pVtaIva1     := ( D():Articulos( nView ) )->pVenta1 + ( ( D():Articulos( nView ) )->pVenta1 * nIva )

                     else

                        /*
                        Los calculos se hacen en funcion de otras tarifas
                        */

                        ( D():Articulos( nView ) )->pVenta1      := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pVenta1 )

                        if !( D():Articulos( nView ) )->lIvaInc

                           /*
                           Si el pocentaje de beneficio es sobre el costo
                           */

                           ( D():Articulos( nView ) )->nBnfSbr1  := 1
                           ( D():Articulos( nView ) )->pVenta1   += ( D():Articulos( nView ) )->pVenta1 * nPctInc / 100

                        else

                           /*
                           Si el pocentaje de beneficio es sobre la venta
                           */

                           ( D():Articulos( nView ) )->nBnfSbr1  := 2
                           ( D():Articulos( nView ) )->pVenta1   += ( D():Articulos( nView ) )->pVenta1 * nPctInc / 100

                        end if

                     end if

                  else

                     ( D():Articulos( nView ) )->lBnf1           := .f.
                     ( D():Articulos( nView ) )->pVenta1         := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pVenta1 ) + nUndInc

                  end if

                  /*
                  Redondeos y precios finales producto sin impuestos incluido--------
                  */

                  if !( D():Articulos( nView ) )->lIvaInc

                     if lRnd
                        ( D():Articulos( nView ) )->pVenta1      := Round( ( D():Articulos( nView ) )->pVenta1, nDec )
                     end if

                     /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                        ( D():Articulos( nView ) )->pVenta1      := nAjuste( ( D():Articulos( nView ) )->pVenta1, ( D():Articulos( nView ) )->cMarAju )
                     elseif lMargenAjuste
                        ( D():Articulos( nView ) )->pVenta1      := nAjuste( ( D():Articulos( nView ) )->pVenta1, cMargenAjuste )
                     end if*/

                     ( D():Articulos( nView ) )->pVtaIva1        := ( ( D():Articulos( nView ) )->pVenta1 * nIva ) + ( D():Articulos( nView ) )->pVenta1

                  end if

                  /*
                  Redondeos y precios finales producto impuestos incluido------------
                  */

                  if ( D():Articulos( nView ) )->lIvaInc

                     ( D():Articulos( nView ) )->pVtaIva1        := ( ( D():Articulos( nView ) )->pVenta1 * nIva ) + ( D():Articulos( nView ) )->pVenta1

                     if lRnd
                        ( D():Articulos( nView ) )->pVtaIva1     := Round( ( D():Articulos( nView ) )->pVtaIva1, nDec )
                     end if

                     /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                        ( D():Articulos( nView ) )->pVtaIva1     := nAjuste( ( D():Articulos( nView ) )->pVtaIva1, ( D():Articulos( nView ) )->cMarAju )
                     elseif lMargenAjuste
                        ( D():Articulos( nView ) )->pVtaIva1     := nAjuste( ( D():Articulos( nView ) )->pVtaIva1, cMargenAjuste )
                     end if*/

                     ( D():Articulos( nView ) )->pVenta1         := Round( ( D():Articulos( nView ) )->pVtaIva1 / ( 1 + nIva ), nDecDiv )

                  end if

                  /*
                  Recalculo de precios para cambios sobre porcentajes----------
                  */

                  if ( D():Articulos( nView ) )->lBnf1 .and. nPctInc == 0

                     if ( D():Articulos( nView ) )->nBnfSbr1 <= 1
                        ( D():Articulos( nView ) )->pVenta1      := Round( ( ( D():Articulos( nView ) )->pCosto * ( D():Articulos( nView ) )->Benef1 / 100 ) + ( D():Articulos( nView ) )->pCosto, nDec )
                     else
                        ( D():Articulos( nView ) )->pVenta1      := Round( ( ( D():Articulos( nView ) )->pCosto / ( 1 - ( ( D():Articulos( nView ) )->Benef1 / 100 ) ) ), nDec )
                     end if

                     ( D():Articulos( nView ) )->pVtaIva1        := ( ( D():Articulos( nView ) )->pVenta1 * nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva ) / 100 ) + ( D():Articulos( nView ) )->pVenta1

                     ( D():Articulos( nView ) )->lBnf1           := .f.

                  end if

               end if

               /*
               Estudio de precios de Tarifa 2----------------------------------
               */

               if lTarifa2 //.and. !( D():Articulos( nView ) )->lBnf2

                  if nRad == 1

                     /*
                     Los calculos se haran sobre el precio de costo
                     */

                     if nPrecio == 2

                        if !lMargenAjuste
                           ( D():Articulos( nView ) )->lBnf2  := .t.
                           ( D():Articulos( nView ) )->Benef2 := nPctInc
                        end if

                        /*
                        Si el pocentaje de beneficio es sobre el costo
                        */

                        ( D():Articulos( nView ) )->nBnfSbr2  := 1
                        ( D():Articulos( nView ) )->pVenta2   := ( D():Articulos( nView ) )->pCosto + ( ( D():Articulos( nView ) )->pCosto * nPctInc / 100 )
                        ( D():Articulos( nView ) )->pVtaIva2  := ( D():Articulos( nView ) )->pVenta2 + ( ( D():Articulos( nView ) )->pVenta2 * nIva )

                     else

                        /*
                        Los calculos se hacen en funcion de otras tarifas
                        */

                        ( D():Articulos( nView ) )->pVenta2      := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pVenta2 )

                        if !( D():Articulos( nView ) )->lIvaInc

                           /*
                           Si el pocentaje de beneficio es sobre el costo
                           */

                           ( D():Articulos( nView ) )->nBnfSbr2  := 1
                           ( D():Articulos( nView ) )->pVenta2   += ( D():Articulos( nView ) )->pVenta2 * nPctInc / 100

                        else

                           /*
                           Si el pocentaje de beneficio es sobre la venta
                           */

                           ( D():Articulos( nView ) )->nBnfSbr2  := 2
                           ( D():Articulos( nView ) )->pVenta2   += ( D():Articulos( nView ) )->pVenta2 * nPctInc / 100

                        end if

                     end if

                  else

                     ( D():Articulos( nView ) )->lBnf2           := .f.
                     ( D():Articulos( nView ) )->pVenta2         := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pVenta2 ) + nUndInc

                  end if

                  /*
                  Redondeos y precios finales producto sin impuestos incluido--------
                  */

                  if !( D():Articulos( nView ) )->lIvaInc

                     if lRnd
                        ( D():Articulos( nView ) )->pVenta2      := Round( ( D():Articulos( nView ) )->pVenta2, nDec )
                     end if

                     /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                        ( D():Articulos( nView ) )->pVenta2      := nAjuste( ( D():Articulos( nView ) )->pVenta2, ( D():Articulos( nView ) )->cMarAju )
                     elseif lMargenAjuste
                        ( D():Articulos( nView ) )->pVenta2      := nAjuste( ( D():Articulos( nView ) )->pVenta2, cMargenAjuste )
                     end if*/

                     ( D():Articulos( nView ) )->pVtaIva2        := ( ( D():Articulos( nView ) )->pVenta2 * nIva ) + ( D():Articulos( nView ) )->pVenta2

                  end if

                  /*
                  Redondeos y precios finales producto impuestos incluido------------
                  */

                  if ( D():Articulos( nView ) )->lIvaInc

                     ( D():Articulos( nView ) )->pVtaIva2        := ( ( D():Articulos( nView ) )->pVenta2 * nIva ) + ( D():Articulos( nView ) )->pVenta2

                     if lRnd
                        ( D():Articulos( nView ) )->pVtaIva2     := Round( ( D():Articulos( nView ) )->pVtaIva2, nDec )
                     end if

                     /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                        ( D():Articulos( nView ) )->pVtaIva2     := nAjuste( ( D():Articulos( nView ) )->pVtaIva2, ( D():Articulos( nView ) )->cMarAju )
                     elseif lMargenAjuste
                        ( D():Articulos( nView ) )->pVtaIva2     := nAjuste( ( D():Articulos( nView ) )->pVtaIva2, cMargenAjuste )
                     end if*/

                     ( D():Articulos( nView ) )->pVenta2         := Round( ( D():Articulos( nView ) )->pVtaIva2 / ( 1 + nIva ), nDecDiv )

                  end if

                  /*
                  Recalculo de precios para cambios sobre porcentajes----------
                  */

                  if ( D():Articulos( nView ) )->lBnf2 .and. nPctInc == 0

                     if ( D():Articulos( nView ) )->nBnfSbr2 <= 1
                        ( D():Articulos( nView ) )->pVenta2      := Round( ( ( D():Articulos( nView ) )->pCosto * ( D():Articulos( nView ) )->Benef2 / 100 ) + ( D():Articulos( nView ) )->pCosto, nDec )
                     else
                        ( D():Articulos( nView ) )->pVenta2      := Round( ( ( D():Articulos( nView ) )->pCosto / ( 1 - ( ( D():Articulos( nView ) )->Benef2 / 100 ) ) ), nDec )
                     end if

                     ( D():Articulos( nView ) )->pVtaIva2        := ( ( D():Articulos( nView ) )->pVenta2 * nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva ) / 100 ) + ( D():Articulos( nView ) )->pVenta2

                     ( D():Articulos( nView ) )->lBnf2           := .f.

                  end if

               end if

               /*
               Estudio de precios de Tarifa 3----------------------------------
               */

               if lTarifa3 //.and. !( D():Articulos( nView ) )->lBnf3

                  if nRad == 1

                     /*
                     Los calculos se haran sobre el precio de costo
                     */

                     if nPrecio == 2

                        if !lMargenAjuste
                           ( D():Articulos( nView ) )->lBnf3  := .t.
                           ( D():Articulos( nView ) )->Benef3 := nPctInc
                        end if

                        /*
                        Si el pocentaje de beneficio es sobre el costo
                        */

                        ( D():Articulos( nView ) )->nBnfSbr3  := 1
                        ( D():Articulos( nView ) )->pVenta3   := ( D():Articulos( nView ) )->pCosto + ( ( D():Articulos( nView ) )->pCosto * nPctInc / 100 )
                        ( D():Articulos( nView ) )->pVtaIva3  := ( D():Articulos( nView ) )->pVenta3 + ( ( D():Articulos( nView ) )->pVenta3 * nIva )

                     else

                        /*
                        Los calculos se hacen en funcion de otras tarifas
                        */

                        ( D():Articulos( nView ) )->pVenta3      := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pVenta3 )

                        if !( D():Articulos( nView ) )->lIvaInc

                           /*
                           Si el pocentaje de beneficio es sobre el costo
                           */

                           ( D():Articulos( nView ) )->nBnfSbr3  := 1
                           ( D():Articulos( nView ) )->pVenta3   += ( D():Articulos( nView ) )->pVenta3 * nPctInc / 100

                        else

                           /*
                           Si el pocentaje de beneficio es sobre la venta
                           */

                           ( D():Articulos( nView ) )->nBnfSbr3  := 2
                           ( D():Articulos( nView ) )->pVenta3   += ( D():Articulos( nView ) )->pVenta3 * nPctInc / 100

                        end if

                     end if

                  else

                     ( D():Articulos( nView ) )->lBnf3           := .f.
                     ( D():Articulos( nView ) )->pVenta3         := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pVenta3 ) + nUndInc

                  end if

                  /*
                  Redondeos y precios finales producto sin impuestos incluido--------
                  */

                  if !( D():Articulos( nView ) )->lIvaInc

                     if lRnd
                        ( D():Articulos( nView ) )->pVenta3      := Round( ( D():Articulos( nView ) )->pVenta3, nDec )
                     end if

                     /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                        ( D():Articulos( nView ) )->pVenta3      := nAjuste( ( D():Articulos( nView ) )->pVenta3, ( D():Articulos( nView ) )->cMarAju )
                     elseif lMargenAjuste
                        ( D():Articulos( nView ) )->pVenta3      := nAjuste( ( D():Articulos( nView ) )->pVenta3, cMargenAjuste )
                     end if*/

                     ( D():Articulos( nView ) )->pVtaIva3        := ( ( D():Articulos( nView ) )->pVenta3 * nIva ) + ( D():Articulos( nView ) )->pVenta3

                  end if

                  /*
                  Redondeos y precios finales producto impuestos incluido------------
                  */

                  if ( D():Articulos( nView ) )->lIvaInc

                     ( D():Articulos( nView ) )->pVtaIva3        := ( ( D():Articulos( nView ) )->pVenta3 * nIva ) + ( D():Articulos( nView ) )->pVenta3

                     if lRnd
                        ( D():Articulos( nView ) )->pVtaIva3     := Round( ( D():Articulos( nView ) )->pVtaIva3, nDec )
                     end if

                     /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                        ( D():Articulos( nView ) )->pVtaIva3     := nAjuste( ( D():Articulos( nView ) )->pVtaIva3, ( D():Articulos( nView ) )->cMarAju )
                     elseif lMargenAjuste
                        ( D():Articulos( nView ) )->pVtaIva3     := nAjuste( ( D():Articulos( nView ) )->pVtaIva3, cMargenAjuste )
                     end if*/

                     ( D():Articulos( nView ) )->pVenta3         := Round( ( D():Articulos( nView ) )->pVtaIva3 / ( 1 + nIva ), nDecDiv )

                  end if

                  /*
                  Recalculo de precios para cambios sobre porcentajes----------
                  */

                  if ( D():Articulos( nView ) )->lBnf3 .and. nPctInc == 0

                     if ( D():Articulos( nView ) )->nBnfSbr3 <= 1
                        ( D():Articulos( nView ) )->pVenta3      := Round( ( ( D():Articulos( nView ) )->pCosto * ( D():Articulos( nView ) )->Benef3 / 100 ) + ( D():Articulos( nView ) )->pCosto, nDec )
                     else
                        ( D():Articulos( nView ) )->pVenta3      := Round( ( ( D():Articulos( nView ) )->pCosto / ( 1 - ( ( D():Articulos( nView ) )->Benef3 / 100 ) ) ), nDec )
                     end if

                     ( D():Articulos( nView ) )->pVtaIva3        := ( ( D():Articulos( nView ) )->pVenta3 * nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva ) / 100 ) + ( D():Articulos( nView ) )->pVenta3

                     ( D():Articulos( nView ) )->lBnf3           := .f.

                  end if

               end if

               if lTarifa4 //.and. !( D():Articulos( nView ) )->lBnf4

                  if nRad == 1

                     /*
                     Los calculos se haran sobre el precio de costo
                     */

                     if nPrecio == 2

                        if !lMargenAjuste
                           ( D():Articulos( nView ) )->lBnf4  := .t.
                           ( D():Articulos( nView ) )->Benef4 := nPctInc
                        end if

                        /*
                        Si el pocentaje de beneficio es sobre el costo
                        */

                        ( D():Articulos( nView ) )->nBnfSbr4  := 1
                        ( D():Articulos( nView ) )->pVenta4   := ( D():Articulos( nView ) )->pCosto + ( ( D():Articulos( nView ) )->pCosto * nPctInc / 100 )
                        ( D():Articulos( nView ) )->pVtaIva4  := ( D():Articulos( nView ) )->pVenta4 + ( ( D():Articulos( nView ) )->pVenta4 * nIva )

                     else

                        /*
                        Los calculos se hacen en funcion de otras tarifas
                        */

                        ( D():Articulos( nView ) )->pVenta4      := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pVenta4 )

                        if !( D():Articulos( nView ) )->lIvaInc

                           /*
                           Si el pocentaje de beneficio es sobre el costo
                           */

                           ( D():Articulos( nView ) )->nBnfSbr4  := 1
                           ( D():Articulos( nView ) )->pVenta4   += ( D():Articulos( nView ) )->pVenta4 * nPctInc / 100

                        else

                           /*
                           Si el pocentaje de beneficio es sobre la venta
                           */

                           ( D():Articulos( nView ) )->nBnfSbr4  := 2
                           ( D():Articulos( nView ) )->pVenta4   += ( D():Articulos( nView ) )->pVenta4 * nPctInc / 100

                        end if

                     end if

                  else

                     ( D():Articulos( nView ) )->lBnf4           := .f.
                     ( D():Articulos( nView ) )->pVenta4         := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pVenta4 ) + nUndInc

                  end if

                  /*
                  Redondeos y precios finales producto sin impuestos incluido--------
                  */

                  if !( D():Articulos( nView ) )->lIvaInc

                     if lRnd
                        ( D():Articulos( nView ) )->pVenta4      := Round( ( D():Articulos( nView ) )->pVenta4, nDec )
                     end if

                     /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                        ( D():Articulos( nView ) )->pVenta4      := nAjuste( ( D():Articulos( nView ) )->pVenta4, ( D():Articulos( nView ) )->cMarAju )
                     elseif lMargenAjuste
                        ( D():Articulos( nView ) )->pVenta4      := nAjuste( ( D():Articulos( nView ) )->pVenta4, cMargenAjuste )
                     end if*/

                     ( D():Articulos( nView ) )->pVtaIva4        := ( ( D():Articulos( nView ) )->pVenta4 * nIva ) + ( D():Articulos( nView ) )->pVenta4

                  end if

                  /*
                  Redondeos y precios finales producto impuestos incluido------------
                  */

                  if ( D():Articulos( nView ) )->lIvaInc

                     ( D():Articulos( nView ) )->pVtaIva4        := ( ( D():Articulos( nView ) )->pVenta4 * nIva ) + ( D():Articulos( nView ) )->pVenta4

                     if lRnd
                        ( D():Articulos( nView ) )->pVtaIva4     := Round( ( D():Articulos( nView ) )->pVtaIva4, nDec )
                     end if

                     /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                        ( D():Articulos( nView ) )->pVtaIva4     := nAjuste( ( D():Articulos( nView ) )->pVtaIva4, ( D():Articulos( nView ) )->cMarAju )
                     elseif lMargenAjuste
                        ( D():Articulos( nView ) )->pVtaIva4     := nAjuste( ( D():Articulos( nView ) )->pVtaIva4, cMargenAjuste )
                     end if*/

                     ( D():Articulos( nView ) )->pVenta4         := Round( ( D():Articulos( nView ) )->pVtaIva4 / ( 1 + nIva ), nDecDiv )

                  end if

                  /*
                  Recalculo de precios para cambios sobre porcentajes----------
                  */

                  if ( D():Articulos( nView ) )->lBnf4 .and. nPctInc == 0

                     if ( D():Articulos( nView ) )->nBnfSbr4 <= 1
                        ( D():Articulos( nView ) )->pVenta4      := Round( ( ( D():Articulos( nView ) )->pCosto * ( D():Articulos( nView ) )->Benef4 / 100 ) + ( D():Articulos( nView ) )->pCosto, nDec )
                     else
                        ( D():Articulos( nView ) )->pVenta4      := Round( ( ( D():Articulos( nView ) )->pCosto / ( 1 - ( ( D():Articulos( nView ) )->Benef4 / 100 ) ) ), nDec )
                     end if

                     ( D():Articulos( nView ) )->pVtaIva4        := ( ( D():Articulos( nView ) )->pVenta4 * nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva ) / 100 ) + ( D():Articulos( nView ) )->pVenta4

                     ( D():Articulos( nView ) )->lBnf4           := .f.

                  end if

               end if

               /*
               Tarifa 5--------------------------------------------------------
               */

               if lTarifa5 //.and. !( D():Articulos( nView ) )->lBnf5

                  if nRad == 1

                     /*
                     Los calculos se haran sobre el precio de costo
                     */

                     if nPrecio == 2

                        if !lMargenAjuste
                           ( D():Articulos( nView ) )->lBnf5  := .t.
                           ( D():Articulos( nView ) )->Benef5 := nPctInc
                        end if

                        /*
                        Si el pocentaje de beneficio es sobre el costo
                        */

                        ( D():Articulos( nView ) )->nBnfSbr5  := 1
                        ( D():Articulos( nView ) )->pVenta5   := ( D():Articulos( nView ) )->pCosto + ( ( D():Articulos( nView ) )->pCosto * nPctInc / 100 )
                        ( D():Articulos( nView ) )->pVtaIva5  := ( D():Articulos( nView ) )->pVenta5 + ( ( D():Articulos( nView ) )->pVenta5 * nIva )

                     else

                        /*
                        Los calculos se hacen en funcion de otras tarifas
                        */

                        ( D():Articulos( nView ) )->pVenta5      := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pVenta5 )

                        if !( D():Articulos( nView ) )->lIvaInc

                           /*
                           Si el pocentaje de beneficio es sobre el costo
                           */

                           ( D():Articulos( nView ) )->nBnfSbr5  := 1
                           ( D():Articulos( nView ) )->pVenta5   += ( D():Articulos( nView ) )->pVenta5 * nPctInc / 100

                        else

                           /*
                           Si el pocentaje de beneficio es sobre la venta
                           */

                           ( D():Articulos( nView ) )->nBnfSbr5  := 2
                           ( D():Articulos( nView ) )->pVenta5   += ( D():Articulos( nView ) )->pVenta5 * nPctInc / 100

                        end if

                     end if

                  else

                     ( D():Articulos( nView ) )->lBnf5           := .f.
                     ( D():Articulos( nView ) )->pVenta5         := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pVenta5 ) + nUndInc

                  end if

                  /*
                  Redondeos y precios finales producto sin impuestos incluido--------
                  */

                  if !( D():Articulos( nView ) )->lIvaInc

                     if lRnd
                        ( D():Articulos( nView ) )->pVenta5      := Round( ( D():Articulos( nView ) )->pVenta5, nDec )
                     end if

                     /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                        ( D():Articulos( nView ) )->pVenta5      := nAjuste( ( D():Articulos( nView ) )->pVenta5, ( D():Articulos( nView ) )->cMarAju )
                     elseif lMargenAjuste
                        ( D():Articulos( nView ) )->pVenta5      := nAjuste( ( D():Articulos( nView ) )->pVenta5, cMargenAjuste )
                     end if*/

                     ( D():Articulos( nView ) )->pVtaIva5        := ( ( D():Articulos( nView ) )->pVenta5 * nIva ) + ( D():Articulos( nView ) )->pVenta5

                  end if

                  /*
                  Redondeos y precios finales producto impuestos incluido------------
                  */

                  if ( D():Articulos( nView ) )->lIvaInc

                     ( D():Articulos( nView ) )->pVtaIva5        := ( ( D():Articulos( nView ) )->pVenta5 * nIva ) + ( D():Articulos( nView ) )->pVenta5

                     if lRnd
                        ( D():Articulos( nView ) )->pVtaIva5     := Round( ( D():Articulos( nView ) )->pVtaIva5, nDec )
                     end if

                     /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                        ( D():Articulos( nView ) )->pVtaIva5     := nAjuste( ( D():Articulos( nView ) )->pVtaIva5, ( D():Articulos( nView ) )->cMarAju )
                     elseif lMargenAjuste
                        ( D():Articulos( nView ) )->pVtaIva5     := nAjuste( ( D():Articulos( nView ) )->pVtaIva5, cMargenAjuste )
                     end if*/

                     ( D():Articulos( nView ) )->pVenta5         := Round( ( D():Articulos( nView ) )->pVtaIva5 / ( 1 + nIva ), nDecDiv )

                  end if

                  /*
                  Recalculo de precios para cambios sobre porcentajes----------
                  */

                  if ( D():Articulos( nView ) )->lBnf5 .and. nPctInc == 0

                     if ( D():Articulos( nView ) )->nBnfSbr5 <= 1
                        ( D():Articulos( nView ) )->pVenta5      := Round( ( ( D():Articulos( nView ) )->pCosto * ( D():Articulos( nView ) )->Benef5 / 100 ) + ( D():Articulos( nView ) )->pCosto, nDec )
                     else
                        ( D():Articulos( nView ) )->pVenta5      := Round( ( ( D():Articulos( nView ) )->pCosto / ( 1 - ( ( D():Articulos( nView ) )->Benef5 / 100 ) ) ), nDec )
                     end if

                     ( D():Articulos( nView ) )->pVtaIva5        := ( ( D():Articulos( nView ) )->pVenta5 * nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva ) / 100 ) + ( D():Articulos( nView ) )->pVenta5

                     ( D():Articulos( nView ) )->lBnf5           := .f.

                  end if

               end if

               /*
               Tarifa 6--------------------------------------------------------
               */

               if lTarifa6 //.and. !( D():Articulos( nView ) )->lBnf6

                  if nRad == 1

                     /*
                     Los calculos se haran sobre el precio de costo
                     */

                     if nPrecio == 2

                        if !lMargenAjuste
                           ( D():Articulos( nView ) )->lBnf6  := .t.
                           ( D():Articulos( nView ) )->Benef6 := nPctInc
                        end if

                        /*
                        Si el pocentaje de beneficio es sobre el costo
                        */

                        ( D():Articulos( nView ) )->nBnfSbr6  := 1
                        ( D():Articulos( nView ) )->pVenta6   := ( D():Articulos( nView ) )->pCosto + ( ( D():Articulos( nView ) )->pCosto * nPctInc / 100 )
                        ( D():Articulos( nView ) )->pVtaIva6  := ( D():Articulos( nView ) )->pVenta6 + ( ( D():Articulos( nView ) )->pVenta6 * nIva )

                     else

                        /*
                        Los calculos se hacen en funcion de otras tarifas
                        */

                        ( D():Articulos( nView ) )->pVenta6      := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pVenta6 )

                        if !( D():Articulos( nView ) )->lIvaInc

                           /*
                           Si el pocentaje de beneficio es sobre el costo
                           */

                           ( D():Articulos( nView ) )->nBnfSbr6  := 1
                           ( D():Articulos( nView ) )->pVenta6   += ( D():Articulos( nView ) )->pVenta6 * nPctInc / 100

                        else

                           /*
                           Si el pocentaje de beneficio es sobre la venta
                           */

                           ( D():Articulos( nView ) )->nBnfSbr6  := 2
                           ( D():Articulos( nView ) )->pVenta6   += ( D():Articulos( nView ) )->pVenta6 * nPctInc / 100

                        end if

                     end if

                  else

                     ( D():Articulos( nView ) )->lBnf6           := .f.
                     ( D():Articulos( nView ) )->pVenta6         := nVal2Change( nPrecio, ( D():Articulos( nView ) )->pVenta6 ) + nUndInc

                  end if

                  /*
                  Redondeos y precios finales producto sin impuestos incluido--------
                  */

                  if !( D():Articulos( nView ) )->lIvaInc

                     if lRnd
                        ( D():Articulos( nView ) )->pVenta6      := Round( ( D():Articulos( nView ) )->pVenta6, nDec )
                     end if

                     /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                        ( D():Articulos( nView ) )->pVenta6      := nAjuste( ( D():Articulos( nView ) )->pVenta6, ( D():Articulos( nView ) )->cMarAju )
                     elseif lMargenAjuste
                        ( D():Articulos( nView ) )->pVenta6      := nAjuste( ( D():Articulos( nView ) )->pVenta6, cMargenAjuste )
                     end if*/

                     ( D():Articulos( nView ) )->pVtaIva6        := ( ( D():Articulos( nView ) )->pVenta6 * nIva ) + ( D():Articulos( nView ) )->pVenta6

                  end if

                  /*
                  Redondeos y precios finales producto impuestos incluido------------
                  */

                  if ( D():Articulos( nView ) )->lIvaInc

                     ( D():Articulos( nView ) )->pVtaIva6        := ( ( D():Articulos( nView ) )->pVenta6 * nIva ) + ( D():Articulos( nView ) )->pVenta6

                     if lRnd
                        ( D():Articulos( nView ) )->pVtaIva6     := Round( ( D():Articulos( nView ) )->pVtaIva6, nDec )
                     end if

                     /*if ( D():Articulos( nView ) )->lMarAju .and. !empty( ( D():Articulos( nView ) )->cMarAju )
                        ( D():Articulos( nView ) )->pVtaIva6     := nAjuste( ( D():Articulos( nView ) )->pVtaIva6, ( D():Articulos( nView ) )->cMarAju )
                     elseif lMargenAjuste
                        ( D():Articulos( nView ) )->pVtaIva6     := nAjuste( ( D():Articulos( nView ) )->pVtaIva6, cMargenAjuste )
                     end if*/

                     ( D():Articulos( nView ) )->pVenta6         := Round( ( D():Articulos( nView ) )->pVtaIva6 / ( 1 + nIva ), nDecDiv )

                  end if

                  /*
                  Recalculo de precios para cambios sobre porcentajes----------
                  */

                  if ( D():Articulos( nView ) )->lBnf6 .and. nPctInc == 0

                     if ( D():Articulos( nView ) )->nBnfSbr6 <= 1
                        ( D():Articulos( nView ) )->pVenta6      := Round( ( ( D():Articulos( nView ) )->pCosto * ( D():Articulos( nView ) )->Benef6 / 100 ) + ( D():Articulos( nView ) )->pCosto, nDec )
                     else
                        ( D():Articulos( nView ) )->pVenta6      := Round( ( ( D():Articulos( nView ) )->pCosto / ( 1 - ( ( D():Articulos( nView ) )->Benef6 / 100 ) ) ), nDec )
                     end if

                     ( D():Articulos( nView ) )->pVtaIva6        := ( ( D():Articulos( nView ) )->pVenta6 * nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva ) / 100 ) + ( D():Articulos( nView ) )->pVenta6

                     ( D():Articulos( nView ) )->lBnf6           := .f.

                  end if

               end if

               /*
               Cambio de peso volumen------------------------------------------
               */

               if lPesVol

                  if nRad == 1
                     ( D():Articulos( nView ) )->nImpPes      += nVal2Change( nPrecio, ( D():Articulos( nView ) )->nImpPes ) * nPctInc / 100
                  else
                     ( D():Articulos( nView ) )->nImpPes      += nVal2Change( nPrecio, ( D():Articulos( nView ) )->nImpPes ) + nUndInc
                  end if

                  if lRnd
                     ( D():Articulos( nView ) )->nImpPes      := Round( ( D():Articulos( nView ) )->nImpPes, nDec )
                  end if

               end if

               ( D():Articulos( nView ) )->lSndDoc            := .t.

               nCounter++

               ( D():Articulos( nView ) )->( dbUnLock() )

            end if

            ( D():Articulos( nView ) )->( dbSkip() )

            oMtr:Set( ( D():Articulos( nView ) )->( OrdKeyNo() ) )

         end do

         oMtr:Set( ( D():Articulos( nView ) )->( LastRec() ) )

      end if

      DestroyFastFilter( D():Articulos( nView ) )

      MsgInfo( "Total de registros cambiados " + Trans( nCounter, "999999999" ) )

   end if

	( D():Articulos( nView ) )->( dbGoto( nRecAct ) )

   if !empty( oWndBrw )
      oWndBrw:Refresh()
   end if

   oDlg:Enable()

Return .t.

//---------------------------------------------------------------------------//

Static Function nVal2Change( nPrecio, nImporte )

   local nVal2Change := 0

   do case
      case nPrecio == 1
         nVal2Change := nImporte
      case nPrecio == 2
         nVal2Change := ( D():Articulos( nView ) )->pCosto
      case nPrecio == 3
         nVal2Change := ( D():Articulos( nView ) )->pVenta1
      case nPrecio == 4
         nVal2Change := ( D():Articulos( nView ) )->pVenta2
      case nPrecio == 5
         nVal2Change := ( D():Articulos( nView ) )->pVenta3
      case nPrecio == 6
         nVal2Change := ( D():Articulos( nView ) )->pVenta4
      case nPrecio == 7
         nVal2Change := ( D():Articulos( nView ) )->pVenta5
      case nPrecio == 8
         nVal2Change := ( D():Articulos( nView ) )->pVenta6
   end case

RETURN nVal2Change

//---------------------------------------------------------------------------//

FUNCTION retCode( cCbaArt, cArticulo )

   local lFound
   local cRet  := ""
   local nOrd  := ( cArticulo )->( ordSetFocus( "Codigo" ) )

   lFound      := ( cArticulo )->( dbSeek( cCbaArt ) )
   if lFound
      cRet     := ( cArticulo )->CODIGO
   end if

   ( cArticulo )->( OrdSetFocus( nOrd ) )

   /*
   Si no encontramos el codigo lo buscamos por codigo de barras
   */

   if !lFound
      nOrd     := ( cArticulo )->( ordSetFocus( "CodeBar" ) )

      if ( cArticulo )->( dbSeek( cCbaArt ) )
         cRet  := ( cArticulo )->CODIGO
      end if

      ( cArticulo )->( OrdSetFocus( nOrd ) )
   end if

RETURN ( cRet )

//--------------------------------------------------------------------------//

STATIC FUNCTION lSelArt( lSel, oBrw )

   DEFAULT lSel         := !( D():Articulos( nView ) )->lSndDoc

   if dbLock( D():Articulos( nView ) )
      ( D():Articulos( nView ) )->lSndDoc  := lSel
      ( D():Articulos( nView ) )->( dbUnlock() )
   end if

   if lSel .and. ( D():Familias( nView ) )->( dbSeek( ( D():Articulos( nView ) )->Familia ) )
      if dbLock( D():Familias( nView ) )
         ( D():Familias( nView ) )->lSelDoc := lSel
         ( D():Articulos( nView ) )->( dbUnlock() )
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

STATIC FUNCTION lSelectAll( oBrw, lSel, lTop )

   local nRecAct  := ( D():Articulos( nView ) )->( Recno() )

   DEFAULT lSel   := .t.
   DEFAULT lTop   := .t.

   createWaitMeter( nil, nil, ( D():Articulos( nView ) )->( OrdKeyCount() ) )

   if lTop
      ( D():Articulos( nView ) )->( dbGoTop() )
   end if

   while !( D():Articulos( nView ) )->( eof() )
      lSelArt( lSel )
      incWaitMeter()
      ( D():Articulos( nView ) )->( dbSkip() )
   end do

   ( D():Articulos( nView ) )->( dbGoTo( nRecAct ) )

   endWaitMeter()

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

function nPdtRecibir( cRef, nUnd, lInc, cArticulo )

   local nOrd     := ( cArticulo )->( ordSetFocus( 1 ) )

   DEFAULT lInc   := .t.

   if ( cArticulo )->( dbSeek( cRef ) ) .and. dbLock( cArticulo )
      ( cArticulo )->nPdtRec   += if( lInc, nUnd, - nUnd )
      ( cArticulo )->( dbUnlock() )
   end if

   ( cArticulo )->( ordSetFocus( nOrd ) )

return nil

//---------------------------------------------------------------------------//
//
// Controla el cambio en tablas de conversion
//

static function lTstFacCnv( aGet, aTmp, oSay )

   if aTmp[( D():Articulos( nView ) )->( fieldpos( "LFACCNV" ) ) ]
      return .t.
   else
      aGet[( D():Articulos( nView ) )->( fieldpos( "CFACCNV" ) ) ]:cText( Space( 2 ) )
      aGet[( D():Articulos( nView ) )->( fieldpos( "CFACCNV" ) ) ]:lValid()
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

   USE ( cPatArt() + "ARTICULO.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbf ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfTIva ) )
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

Function cRetPreArt( cCodArt, nTarifa, cCodDiv, lIvaInc, cArticulo, dbfDiv, dbfArtKit, dbfIva, lBuscaImportes )

   local nPreArt           := 0
   local aDbfSta           := aGetStatus( cArticulo )

   DEFAULT lBuscaImportes  := uFieldEmpresa( "lBusImp" )

   /*
   Primero buscamos por codigos de barra---------------------------------------
   */

   ( cArticulo )->( ordSetFocus( "CodeBar" ) )

   if ( cArticulo )->( dbSeek( cCodArt ) )
      cCodArt              := ( cArticulo )->Codigo
   end if

   ( cArticulo )->( ordSetFocus( "Codigo" ) )

   if ( cArticulo )->( dbSeek( cCodArt ) )
      nPreArt              := nRetPreArt( nTarifa, cCodDiv, lIvaInc, cArticulo, dbfDiv, dbfArtKit, dbfIva, lBuscaImportes )
   end if

   SetStatus( cArticulo, aDbfSta )

Return ( nPreArt )

//---------------------------------------------------------------------------//

FUNCTION nRetPreIva( nTarifa, cCodDiv, cArticulo, dbfDiv )

   local nPre        := 0

   DEFAULT nTarifa   := 1

   while .t.

      do case
         case nTarifa == 1
            nPre  := ( cArticulo )->pVtaIva1
         case nTarifa == 2
            nPre  := ( cArticulo )->pVtaIva2
         case nTarifa == 3
            nPre  := ( cArticulo )->pVtaIva3
         case nTarifa == 4
            nPre  := ( cArticulo )->pVtaIva4
         case nTarifa == 5
            nPre  := ( cArticulo )->pVtaIva5
         case nTarifa == 6
            nPre  := ( cArticulo )->pVtaIva6
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

FUNCTION nPreMedCom( cCodArt, cCodAlm, dbfAlbPrvT, dbfAlbPrvL, dbfFacPrvT, dbfFacPrvL, nDiv, nDecOut, nDerOut, cHisMov )

   local nPreMed  := 0
   local nTotUni  := 0
   local nTotPre  := 0
   local nOrdAlb  := ( dbfAlbPrvL )->( ordSetFocus( "cRef" ) )
   local nOrdFac  := ( dbfFacPrvL )->( ordSetFocus( "cRef" ) )
   local nOrdMov  := ( cHisMov )->( ordSetFocus( "cRefMov" ) )

   if nDiv == 0
      nDiv        := 1
   end if

   if ( dbfAlbPrvL )->( dbSeek( cCodArt ) )

      while ( dbfAlbPrvL )->cRef == cCodArt .and. !( dbfAlbPrvL )->( Eof() )

         if !lFacAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT ) .and. ;
            ( dbfAlbPrvL )->cAlmLin == cCodAlm .or. empty( cCodAlm )

            nTotUni += nTotNAlbPrv( dbfAlbPrvL )
            nTotPre += nImpLAlbPrv( dbfAlbPrvT, dbfAlbPrvL, nDecOut, nDerOut, nDiv )

         end if

         ( dbfAlbPrvL )->( dbSkip() )

      end while

   end if

   if ( dbfFacPrvL )->( dbSeek( cCodArt ) )

      while ( dbfFacPrvL )->cRef == cCodArt .AND. !( dbfFacPrvL )->( Eof() )

         if ( dbfFacPrvL )->cAlmLin == cCodAlm .or. empty( cCodAlm )

            nTotUni += nTotNFacPrv( dbfFacPrvL )
            nTotPre += nImpLFacPrv( dbfFacPrvT, dbfFacPrvL, nDecOut, nDerOut, nDiv )

         end if

         ( dbfFacPrvL )->( dbSkip() )

      end while

   end if

   if ( cHisMov )->( dbSeek( cCodArt ) )

      while ( cHisMov )->cRefMov == cCodArt .AND. !( cHisMov )->( Eof() )

         if ( cHisMov )->cAliMov == cCodAlm .or. empty( cCodAlm )

            nTotUni += nTotNMovAlm( cHisMov )
            nTotPre += ( cHisMov )->nPreDiv

         end if

         ( cHisMov )->( dbSkip() )

      end while

   end if

   if nTotUni != 0
      nPreMed     := Round( Div( Div( nTotPre, nTotUni ), nDiv ), nDecOut )
   end if

   ( dbfAlbPrvL )->( ordSetFocus( nOrdAlb ) )
   ( dbfFacPrvL )->( ordSetFocus( nOrdFac ) )
   ( cHisMov )->( ordSetFocus( nOrdMov ) )

return ( nPreMed )

//---------------------------------------------------------------------------//

Function nCostoEscandallo( aTmp, dbfTmpKit, cArticulo, dbfArtKit, lPic, cDivRet, dbfDiv )

   local nCosto   := 0
   local nOrdArt  := ( cArticulo )->( OrdSetFocus( 1 ) )
   local nRecArt  := ( cArticulo )->( Recno() )
   local nRecKit  := ( dbfTmpKit )->( Recno() )

   DEFAULT lPic   := .f.

   if aTmp[ ( cArticulo )->( fieldpos( "lKitArt" ) ) ]

      ( dbfTmpKit )->( dbGoTop() )
      while !( dbfTmpKit )->( eof() )
         nCosto   += nCosto( ( dbfTmpKit )->cRefKit, cArticulo, dbfArtKit ) * ( dbfTmpKit )->nUndKit * nFactorConversion( ( dbfTmpKit )->cRefKit )
         ( dbfTmpKit )->( dbSkip() )
      end while

   end if

   ( cArticulo )->( OrdSetFocus( nOrdArt ) )
   ( cArticulo )->( dbGoTo( nRecArt ) )
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

Function nCostoLin( cCodArt, cArticulo, dbfArtKit, lPic, cDivRet, dbfDiv )

   local nCosto

   DEFAULT lPic   := .f.

   nCosto         := nCosto( cCodArt, cArticulo, dbfArtKit, .f., cDivRet, dbfDiv, lPic )
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
   local cArticulo
   local dbfTikL
   local dbfDiv

   DEFAULT lMessage  := .t.

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatArt() + "ARTICULO.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @cArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatEmp() + "TIKEL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKEL", @dbfTikL ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKEL.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   if oMeter != nil .and. lMessage
      oMeter:nTotal  := ( dbfTikL )->( LastRec() )
   end if

   nDouDiv           := nDouDiv( cDivEmp(), dbfDiv ) // Decimales de la divisa
   nRouDiv           := nRouDiv( cDivEmp(), dbfDiv ) // Decimales de la divisa redondeada

   ( cArticulo )->( dbGoTop() )
   while !( cArticulo )->( eof() )

      if dbLock( cArticulo )
         ( cArticulo )->nPosTcl   := 0
         ( cArticulo )->( dbUnLock() )
      end if

      ( cArticulo )->( dbSkip() )
   end while

   ( dbfTikL )->( dbGoTop() )
   while !( dbfTikL )->( eof() )

      if ( cArticulo )->( dbSeek( ( dbfTikL )->cCbaTil ) )
         if dbLock( cArticulo )
            ( cArticulo )->nPosTcl   +=  nTotNTpv( dbfTikL )
            ( cArticulo )->( dbUnLock() )
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

   CLOSE ( cArticulo)
   CLOSE ( dbfTikL    )
   CLOSE ( dbfDiv     )

   dbfDiv      := NIL
   dbfTikL     := NIL
   cArticulo := NIL

return nil

//---------------------------------------------------------------------------//

Static Function buscarExtendido()

   local nSea     := 1
	local oDlg
   local nOrd     := ( D():ProveedorArticulo( nView ) )->( OrdSetFocus( "cRefPrv" ) )
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

   ( D():ProveedorArticulo( nView ) )->( OrdSetFocus( nOrd ) )

RETURN NIL

//---------------------------------------------------------------------------//

Static Function PosProveedor( nSea, cGetPrv, cGetArt, cGetBar )

   local nCod
   local nOrd

   if nSea == 1

      if dbSeekInOrd( cGetBar, "cCodBar", dbfCodeBar )
         if dbSeekInOrd( ( dbfCodeBar )->cCodArt, "Codigo", D():Articulos( nView ) )
            oWndBrw:SetFocus()
         else
            msgStop( "Artículo " + Rtrim( ( dbfCodeBar )->cCodArt ) + " no encontrado." )
         end if
      else
         if dbSeekInOrd( cGetBar, "CodeBar", D():Articulos( nView ) )
            oWndBrw:Refresh()
         else
            msgStop( "Código de barras " + Rtrim( cGetBar ) + " no encontrado." )
         end if
      end if

   else

      if ( D():ProveedorArticulo( nView ) )->( dbSeek( cGetPrv + cGetArt ) )
         if dbSeekInOrd( ( D():ProveedorArticulo( nView ) )->cCodArt, "Codigo", D():Articulos( nView ) ) 
            oWndBrw:SetFocus()
         else
            msgStop( "Artículo " + Rtrim( ( D():ProveedorArticulo( nView ) )->cCodArt ) + " no encontrado." )
         end if
      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//

Function buscarTipologias()

   local oDlg
   local oBmp
   local oGetFamilia
   local oGetTipo
   local oGetTemporada
   local oGetFabricante
   local oGetEstado
   local oGetCodigo
   local oGetNombre
   local cGetCodigo := space( 200 )
   local cGetNombre := space( 200 )
   local cGetFamilia := space( 200 )
   local cGetTipo := space( 200 )
   local cGetTemporada := space( 200 )
   local cGetFabricante := space( 200 )
   local cGetEstado := space( 200 )

   local aCountries     := { "Afghanistan", "Islands", "Albania", "Alemania" } 

   DEFINE DIALOG oDlg RESOURCE "Buscar_Combo"

      oGetNombre              := TAutoCombo():ReDefine( 110, { | u | iif( pcount() == 0, cGetNombre, cGetNombre := u ) }, aCountries, oDlg,,,,,,, .f. )
      oGetNombre:lIncSearch   := .t.

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          oDlg ;
         CANCEL ;
         ACTION      ( oDlg:end( IDOK ) ) 

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         CANCEL ;
         ACTION      ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//---------------------------------------------------------------------------//

Static Function cfilter( uDataSource, cData, Self )

   local aList       := {}

   aEval( uDataSource, {|x| iif( lower( cData ) $ lower( x[1] ), aadd( aList, x ), ) } )

RETURN aList

//---------------------------------------------------------------------------//

Static Function aCodigosArticulo()

   local nRec        := ( D():Articulos( nView ) )->( Recno() )
   local aCodigos    := {}

   ( D():Articulos( nView ) )->( dbGoTop() )

   while !( D():Articulos( nView ) )->( Eof() )

      aAdd( aCodigos, { ( D():Articulos( nView ) )->Codigo, ( D():Articulos( nView ) )->Codigo } )

      ( D():Articulos( nView ) )->( dbSkip() )

   end while

   ( D():Articulos( nView ) )->( dbGoTo( nRec ) )

Return aCodigos

//---------------------------------------------------------------------------//

Static Function aNombresArticulo()

   local nRec        := ( D():Articulos( nView ) )->( Recno() )
   local aCodigos    := {}

   ( D():Articulos( nView ) )->( dbGoTop() )

   while !( D():Articulos( nView ) )->( Eof() )

      aAdd( aCodigos, { ( D():Articulos( nView ) )->Nombre, ( D():Articulos( nView ) )->Codigo } )

      ( D():Articulos( nView ) )->( dbSkip() )

   end while

   ( D():Articulos( nView ) )->( dbGoTo( nRec ) )

Return aCodigos

//---------------------------------------------------------------------------//

Static Function aNombresFamilias()

   local nRec        := ( D():Familias( nView ) )->( Recno() )
   local aCodigos    := {}

   ( D():Familias( nView ) )->( dbGoTop() )

   while !( D():Familias( nView ) )->( Eof() )

      aAdd( aCodigos, { ( D():Familias( nView ) )->cNomFam, ( D():Familias( nView ) )->cCodFam } )

      ( D():Familias( nView ) )->( dbSkip() )

   end while

   ( D():Familias( nView ) )->( dbGoTo( nRec ) )

Return aCodigos

//---------------------------------------------------------------------------//

Static Function aNombresTipoArticulo()

   local nRec        := oTipart:oDbf:Recno()
   local aCodigos    := {}

   oTipart:oDbf:GoTop()

   while !oTipart:oDbf:Eof()

      aAdd( aCodigos, { oTipart:oDbf:cNomTip, oTipart:oDbf:cCodTip } )

      oTipart:oDbf:Skip()

   end while

   oTipart:oDbf:GoTo( nRec )

Return aCodigos

//---------------------------------------------------------------------------//

Static Function aNombresTemporada()

   local nRec        := ( dbfTemporada )->( Recno() )
   local aCodigos    := {}

   ( dbfTemporada )->( dbGoTop() )

   while !( dbfTemporada )->( Eof() )

      aAdd( aCodigos, { ( dbfTemporada )->cNombre, ( dbfTemporada )->cCodigo } )

      ( dbfTemporada )->( dbSkip() )

   end while

   ( dbfTemporada )->( dbGoTo( nRec ) )

Return aCodigos

//---------------------------------------------------------------------------//

Static Function aNombresFabricante()

   local nRec        := oFabricante:oDbf:Recno()
   local aCodigos    := {}

   oFabricante:oDbf:GoTop()

   while !oFabricante:oDbf:Eof()

      aAdd( aCodigos, { oFabricante:oDbf:cNomFab, oFabricante:oDbf:cCodFab } )

      oFabricante:oDbf:Skip()

   end while

   oFabricante:oDbf:GoTo( nRec )

Return aCodigos

//---------------------------------------------------------------------------//

Static Function aNombresEstadoArticulo()

   local nRec        := ( D():EstadoArticulo( nView ) )->( Recno() )
   local aCodigos    := {}

   ( D():EstadoArticulo( nView ) )->( dbGoTop() )

   while !( D():EstadoArticulo( nView ) )->( Eof() )

      aAdd( aCodigos, { ( D():EstadoArticulo( nView ) )->cNombre, ( D():EstadoArticulo( nView ) )->cCodigo } )

      ( D():EstadoArticulo( nView ) )->( dbSkip() )

   end while

   ( D():EstadoArticulo( nView ) )->( dbGoTo( nRec ) )

Return aCodigos

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
         if dbSeekInOrd( cCodArt, "Codigo", D():Articulos( nView ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra artículo" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( cCodArt, "Codigo", D():Articulos( nView ) )
            WinEdtRec( oWndBrw, bEdit, D():Articulos( nView ) )
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
            WinAppRec( oWndBrw, bEdit, D():Articulos( nView ) )
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

   if ( D():Articulos( nView ) )->( dbSeek( cCodArt ) )
      BrwVtaComArt( ( D():Articulos( nView ) )->Codigo, ( D():Articulos( nView ) )->Nombre )
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

      if cCatOld != aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODCAT" ) ) ]                       .and.;
         ( dbfCatalogo )->( dbSeek( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODCAT" ) ) ] ) )   .and.;
         !( dbfCatalogo )->lObsCat

         if ApoloMsgNoYes(  "¿ Desea actualizar los datos del artículo con los datos del catálogo ?", "Elija una opción" )

            nOrdAnt     := ( dbfTmpPrv )->( OrdSetFocus( "CREFPRV" ) )

            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NPUNTOS" ) ) ]  := ( dbfCatalogo )->nValPunt
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NDTOPNT" ) ) ]  := ( dbfCatalogo )->nDtoPunt

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

            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CPRVHAB" ) ) ]  := ( dbfCatalogo )->cCodProv

            //-------Tarifa 1---------------------------------------------------//

            if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF1"    ) ) ]
               aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF1"   ) ) ] := ( dbfCatalogo )->Benef1
               aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NBNFSBR1" ) ) ] := ( dbfCatalogo )->nBnfSbr1
               oSay[ 11 ]:Select( Max( ( dbfCatalogo )->nBnfSbr1, 1 ) )
               aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF1" ) ) ]:lValid()
            end if

            //-------Tarifa 2---------------------------------------------------//

            if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF2" ) ) ]
               aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF2" ) ) ]   := ( dbfCatalogo )->Benef2
               aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NBNFSBR2" ) ) ] := ( dbfCatalogo )->nBnfSbr2
               oSay[ 12 ]:Select( Max( ( dbfCatalogo )->nBnfSbr2, 1 ) )
               aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF2" ) ) ]:lValid()
            end if

            //-------Tarifa 3---------------------------------------------------//

            if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF3" ) ) ]
               aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF3" ) ) ]   := ( dbfCatalogo)->Benef3
               aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NBNFSBR3" ) ) ] := ( dbfCatalogo )->nBnfSbr3
               oSay[ 13 ]:Select( Max( ( dbfCatalogo )->nBnfSbr3, 1 ) )
               aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF3" ) ) ]:lValid()
            end if

            //-------Tarifa 4---------------------------------------------------//

            if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF4" ) ) ]
               aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF4" ) ) ]   := ( dbfCatalogo )->Benef4
               aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NBNFSBR4" ) ) ] := ( dbfCatalogo )->nBnfSbr4
               oSay[ 14 ]:Select( Max( ( dbfCatalogo )->nBnfSbr4, 1 ) )
               aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF4" ) ) ]:lValid()
            end if

            //-------Tarifa 5---------------------------------------------------//

            if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF5" ) ) ]
               aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF5" ) ) ]   := ( dbfCatalogo )->Benef5
               aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NBNFSBR5" ) ) ] := ( dbfCatalogo )->nBnfSbr5
               oSay[ 15 ]:Select( Max( ( dbfCatalogo )->nBnfSbr5, 1 ) )
               aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF5" ) ) ]:lValid()
            end if

            //-------Tarifa 6---------------------------------------------------//

            if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF6" ) ) ]
               aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF6" ) ) ]   := ( dbfCatalogo )->Benef6
               aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NBNFSBR6" ) ) ] := ( dbfCatalogo )->nBnfSbr6
               oSay[ 16 ]:Select( Max( ( dbfCatalogo )->nBnfSbr6, 1 ) )
               aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF6" ) ) ]:lValid()
            end if

         end if

      end if

      //--------Refresca los objetos para que muestren los valores--------//

      oValorPunto:Refresh()

      oValorDto:Refresh()

      oValorTot:Refresh()

      aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF1" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF2" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF3" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF4" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF5" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "BENEF6" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA1" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA2" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA3" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA4" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA5" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA6" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA1" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA2" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA3" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA4" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA5" ) ) ]:Refresh()
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA6" ) ) ]:Refresh()

      ( dbfTmpPrv )->( OrdSetFocus( nOrdAnt ) )

   else

      if cCatOld != aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODCAT" ) ) ]                     .and.;
         ( dbfCatalogo )->( dbSeek( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODCAT" ) ) ] ) )

         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NPUNTOS" ) ) ]  := ( dbfCatalogo )->nValPunt
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NDTOPNT" ) ) ]  := ( dbfCatalogo )->nDtoPunt
         aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CPRVHAB" ) ) ]  := ( dbfCatalogo )->cCodProv
         oSay[4]:cText( RetProvee( ( dbfCatalogo )->cCodProv ) )

         //-------Tarifa 1---------------------------------------------------//

         if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF1" ) ) ]
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF1" ) ) ]   := ( dbfCatalogo )->Benef1
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NBNFSBR1" ) ) ] := ( dbfCatalogo )->nBnfSbr1
         end if

         //-------Tarifa 2---------------------------------------------------//

         if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF2" ) ) ]
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF2" ) ) ]   := ( dbfCatalogo )->Benef2
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NBNFSBR2" ) ) ] := ( dbfCatalogo )->nBnfSbr2
         end if

         //-------Tarifa 3---------------------------------------------------//

         if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF3" ) ) ]
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF3" ) ) ]   := ( dbfCatalogo)->Benef3
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NBNFSBR3" ) ) ] := ( dbfCatalogo )->nBnfSbr3
         end if

         //-------Tarifa 4---------------------------------------------------//

         if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF4" ) ) ]
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF4" ) ) ]   := ( dbfCatalogo )->Benef4
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NBNFSBR4" ) ) ] := ( dbfCatalogo )->nBnfSbr4
         end if

         //-------Tarifa 5---------------------------------------------------//

         if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF5" ) ) ]
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF5" ) ) ]   := ( dbfCatalogo )->Benef5
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NBNFSBR5" ) ) ] := ( dbfCatalogo )->nBnfSbr5
         end if

         //-------Tarifa 6---------------------------------------------------//

         if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LBNF6" ) ) ]
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "BENEF6" ) ) ]   := ( dbfCatalogo )->Benef6
            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "NBNFSBR6" ) ) ] := ( dbfCatalogo )->nBnfSbr6
         end if

      end if

      oValorPunto:Refresh()

      oValorDto:Refresh()

      oValorTot:Refresh()

      aGet[ ( D():Articulos( nView ) )->( fieldpos( "CPRVHAB" ) )]:Refresh()

      oSay[4]:Refresh()

   end if

   cCatOld  := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODCAT" ) ) ]

RETURN .t.

//---------------------------------------------------------------------------//

function SynArt( cPath )

   local oBlock
   local oError
   local cCod           := ""
   local nCosto         := 0
   local idImagen
   local nOrdAnt
   local dbfArt
   local dbfImg
   local dbfIva
   local dbfArtPrv
   local dbfFamilia

   DEFAULT cPath        := cPatArt()

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatArt() + "ARTICULO.Dbf" ) NEW VIA ( cDriver() )    EXCLUSIVE ALIAS ( cCheckArea( "ARTICULO", @dbfArt ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTKIT.Dbf" ) NEW VIA ( cDriver() )      EXCLUSIVE ALIAS ( cCheckArea( "ARTTIK", @dbfArtKit ) )
   SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatArt() + "PROVART.Dbf" ) NEW VIA ( cDriver() )     EXCLUSIVE ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
   SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

   USE ( cPatArt() + "FAMILIAS.Dbf" ) NEW VIA ( cDriver() )    EXCLUSIVE ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
   SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

   USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() )  EXCLUSIVE ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
   SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

   USE ( cPatArt() + "ArtImg.Dbf" ) NEW VIA ( cDriver() )      EXCLUSIVE ALIAS ( cCheckArea( "ArtImg", @dbfImg ) )
   SET ADSINDEX TO ( cPatArt() + "ArtImg.Cdx" ) ADDITIVE

   USE ( cPatArt() + "OFERTA.Dbf" ) NEW VIA ( cDriver() )      SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOfe ) )
   SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

   USE ( cPatEmp() + "ALBPROVL.Dbf" ) NEW VIA ( cDriver() )    SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE
   SET TAG TO "cRefFec"

   USE ( cPatEmp() + "FACPRVL.Dbf" ) NEW VIA ( cDriver() )     SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" ) ADDITIVE
   SET TAG TO "cRefFec"

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() )        SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   oNewImp              := TNewImp():Create( cPatEmp() )
   if oNewImp:OpenFiles()

      ( dbfArt )->( dbGoTop() )

      while !( dbfArt )->( eof() )

         if !( dbfArt )->lKitArt
            while ( dbfArtKit )->( dbSeek( ( dbfArt )->Codigo ) )
               ( dbfArtKit )->( dbDelete() )
            end while
         end if

         /*
         Marca para proveedor habitual-----------------------------------------
         */

         nOrdAnt        := ( dbfArtPrv )->( OrdSetFocus( "lDefPrv" ) )

         if !( dbfArtPrv )->( dbSeek( ( dbfArt )->Codigo ) )

            if !empty( ( dbfArt )->cPrvHab )

               if !( dbfArtPrv )->( dbSeek( ( dbfArt )->Codigo + ( dbfArt )->cPrvHab ) )

                  if ( dbfArtPrv )->( dbSeek( ( dbfArt )->Codigo ) )

                     while ( dbfArtPrv )->cCodArt == ( dbfArt )->Codigo .and. !( dbfArtPrv )->( eof() )
                        ( dbfArtPrv )->lDefPrv        := .f.
                        ( dbfArtPrv )->( dbSkip() )
                     end while

                     ( dbfArtPrv )->( dbAppend() )
                     ( dbfArtPrv )->cCodArt           := ( dbfArt )->Codigo
                     ( dbfArtPrv )->cCodPrv           := ( dbfArt )->cPrvHab
                     ( dbfArtPrv )->cDivPrv           := cDivEmp()
                     ( dbfArtPrv )->lDefPrv           := .t.
                     ( dbfArtPrv )->( dbUnLock() )

                  end if

               end if

            end if

         else 
         
            if ( dbfArtPrv )->cCodArt  != ( dbfArt )->cPrvHab
               ( dbfArt )->cPrvHab                    := ( dbfArtPrv )->cCodPrv
            end if

         end if 

         ( dbfArtPrv )->( OrdSetFocus( nOrdAnt ) )

         /*
         Sincronizamos las fechas de LASTCHGcreación y de cambio---------------
         */

         do case
            case empty( ( dbfArt )->LastChg ) .and. empty( ( dbfArt )->dFecChg )

               ( dbfArt )->LastChg := GetSysDate()
               ( dbfArt )->dFecChg := GetSysDate()
               ( dbfArt )->( dbUnLock() )

            case empty( ( dbfArt )->LastChg )

               ( dbfArt )->LastChg := ( dbfArt )->dFecChg

            case empty( ( dbfArt )->dFecChg )

               ( dbfArt )->dFecChg := ( dbfArt )->LastChg

         end case

         /*
         Si tenemos marcada la opción de "Cambiar precios de costo automáticamente"
         ponemos en la ficha del artículo el precio de la última compra.
         */

         if uFieldEmpresa( "lActCos" )

            nCosto                     := nCostoUltimaCompra( ( dbfArt )->Codigo, dbfAlbPrvL, dbfFacPrvL )
            if nCosto != 0
               ( dbfArt )->pCosto := nCosto
            end if

         end if

         /*
         Recalculamos precios de artículos-------------------------------------
         */

         nCosto                        := ( dbfArt )->pCosto

         if ( dbfArt )->lBnf1 .and. nCosto != 0
            ( dbfArt )->pVenta1   := CalPre( if( ( dbfArt )->nBnfSbr1 <= 1, .t., .f. ), nCosto, .t., ( dbfArt )->Benef1, ( dbfArt )->TipoIva, nil, nil, nDouDiv( cDivEmp(), dbfDiv ), ( dbfArt )->cCodImp, nil )
            ( dbfArt )->pVtaIva1  := ( dbfArt )->pVenta1 + Round( ( ( dbfArt )->pVenta1 * nIva( dbfIva, ( dbfArt )->TipoIva ) / 100 ), nDouDiv( cDivEmp(), dbfDiv ) )
         end if

         if ( dbfArt )->lBnf2 .and. nCosto != 0
            ( dbfArt )->pVenta2   := CalPre( if( ( dbfArt )->nBnfSbr2 <= 1, .t., .f. ), nCosto, .t., ( dbfArt )->Benef2, ( dbfArt )->TipoIva, nil, nil, nDouDiv( cDivEmp(), dbfDiv ), ( dbfArt )->cCodImp, nil )
            ( dbfArt )->pVtaIva2  := ( dbfArt )->pVenta2 + Round( ( ( dbfArt )->pVenta2 * nIva( dbfIva, ( dbfArt )->TipoIva ) / 100 ), nDouDiv( cDivEmp(), dbfDiv ) )
         end if

         if ( dbfArt )->lBnf3 .and. nCosto != 0
            ( dbfArt )->pVenta3   := CalPre( if( ( dbfArt )->nBnfSbr3 <= 1, .t., .f. ), nCosto, .t., ( dbfArt )->Benef3, ( dbfArt )->TipoIva, nil, nil, nDouDiv( cDivEmp(), dbfDiv ), ( dbfArt )->cCodImp, nil )
            ( dbfArt )->pVtaIva3  := ( dbfArt )->pVenta3 + Round( ( ( dbfArt )->pVenta3 * nIva( dbfIva, ( dbfArt )->TipoIva ) / 100 ), nDouDiv( cDivEmp(), dbfDiv ) )
         end if

         if ( dbfArt )->lBnf4 .and. nCosto != 0
            ( dbfArt )->pVenta4   := CalPre( if( ( dbfArt )->nBnfSbr4 <= 1, .t., .f. ), nCosto, .t., ( dbfArt )->Benef4, ( dbfArt )->TipoIva, nil, nil, nDouDiv( cDivEmp(), dbfDiv ), ( dbfArt )->cCodImp, nil )
            ( dbfArt )->pVtaIva4  := ( dbfArt )->pVenta4 + Round( ( ( dbfArt )->pVenta4 * nIva( dbfIva, ( dbfArt )->TipoIva ) / 100 ), nDouDiv( cDivEmp(), dbfDiv ) )
         end if

         if ( dbfArt )->lBnf5 .and. nCosto != 0
            ( dbfArt )->pVenta5   := CalPre( if( ( dbfArt )->nBnfSbr5 <= 1, .t., .f. ), nCosto, .t., ( dbfArt )->Benef5, ( dbfArt )->TipoIva, nil, nil, nDouDiv( cDivEmp(), dbfDiv ), ( dbfArt )->cCodImp, nil )
            ( dbfArt )->pVtaIva5  := ( dbfArt )->pVenta5 + Round( ( ( dbfArt )->pVenta5 * nIva( dbfIva, ( dbfArt )->TipoIva ) / 100 ), nDouDiv( cDivEmp(), dbfDiv ) )
         end if

         if ( dbfArt )->lBnf6 .and. nCosto != 0
            ( dbfArt )->pVenta6   := CalPre( if( ( dbfArt )->nBnfSbr6 <= 1, .t., .f. ), nCosto, .t., ( dbfArt )->Benef6, ( dbfArt )->TipoIva, nil, nil, nDouDiv( cDivEmp(), dbfDiv ), ( dbfArt )->cCodImp, nil )
            ( dbfArt )->pVtaIva6  := ( dbfArt )->pVenta6 + Round( ( ( dbfArt )->pVenta6 * nIva( dbfIva, ( dbfArt )->TipoIva ) / 100 ), nDouDiv( cDivEmp(), dbfDiv ) )
         end if

         /*
         Propiedades de los articulos------------------------------------------
         */

         if !( dbfArt )->lCodPrp

            if ( dbfFamilia )->( dbSeek( ( dbfArt )->Familia ) )

               if empty( ( dbfArt )->cCodPrp1 ) .and. !empty( ( dbfFamilia )->cCodPrp1 )
                  ( dbfArt )->cCodPrp1  := ( dbfFamilia )->cCodPrp1
               end if

               if empty( ( dbfArt )->cCodPrp2 ) .and. !empty( ( dbfFamilia )->cCodPrp2 )
                  ( dbfArt )->cCodPrp2  := ( dbfFamilia )->cCodPrp2
               end if

            end if

            ( dbfArt )->lCodPrp         := .t.

         end if

         /*
         Buscamos si exite un codigo de barras por defecto---------------------
         */

         if empty( ( dbfArt )->Codebar )

            nOrdAnt                     := ( dbfCodebar )->( OrdSetFocus( "cCodArt" ) )

            if ( dbfCodebar )->( dbSeek( ( dbfArt )->Codigo ) )
               ( dbfArt )->CodeBar      := ( dbfCodebar )->cCodBar
            end if

             ( dbfCodebar )->( OrdSetFocus( nOrdAnt ) )

         end if

         /*
         Factores de conversión de articulos-----------------------------------
         */

         if ( dbfArt )->nFacCnv == 0
            ( dbfArt )->nFacCnv := 1
         end if

         /*
         Imagenes--------------------------------------------------------------
         */

         if !empty( ( dbfArt )->cImagenWeb )

            ( dbfImg )->( __dbLocate( {|| alltrim( upper( ( dbfArt )->cImagenWeb ) ) == alltrim( upper( ( dbfImg )->cImgArt ) ) } ) )
            if !( dbfImg )->( found() )

               ( dbfImg )->( dbAppend() )
               ( dbfImg )->cCodArt   := ( dbfArt )->Codigo
               ( dbfImg )->cImgArt   := ( dbfArt )->cImagenWeb
               ( dbfImg )->( dbUnLock() )

            end if

         end if

         /*
         Nos aseguramos de que haya una imagen por defecto del artículo--------
         */

         if !dbSeekInOrd( ( dbfArt )->Codigo, "lDefImg", dbfImg )

            if dbSeekInOrd( ( dbfArt )->Codigo, "cCodArt", dbfImg )
               ( dbfImg )->lDefImg     := .t.
            end if

         end if

         /*
         Tarifas de la Web-----------------------------------------------------
         */

         if ( dbfArt )->nTarWeb   < 1
            ( dbfArt )->nTarWeb   := 1
         end if

         // identificadores para las imagenes-----------------------------------

         if ( dbfImg )->( dbSeek( ( dbfArt )->Codigo ) ) .and. empty( ( dbfImg )->nId )

            idImagen             := 0
         
            while ( dbfImg )->cCodArt == ( dbfArt )->Codigo .and. !( dbfImg )->( eof() )

               ( dbfImg )->nId   := ++idImagen
            
               ( dbfImg )->( dbSkip() )
            
            end while

         end if 

         ( dbfArt )->( dbSkip() )

         SysRefresh()

      end while

      /*
      Codigos de barras sin codigos de articulos
      -------------------------------------------------------------------------
      */

      ( dbfCodebar )->( dbGoTop() )
      while !( dbfCodebar )->( eof() )

         if !( dbfArt )->( dbSeek( ( dbfCodebar )->cCodArt ) )
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

         if empty( ( dbfCodebar )->cCodBar )
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

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de articulos." )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Cerramos todas las tablas---------------------------------------------------
   */

   CLOSE ( dbfArt     )
   CLOSE ( dbfArtKit  )
   CLOSE ( dbfArtPrv  )
   CLOSE ( dbfFamilia )
   CLOSE ( dbfCodebar )
   CLOSE ( dbfImg     )
   CLOSE ( dbfOfe     )
   CLOSE ( dbfAlbPrvL )
   CLOSE ( dbfFacPrvL )
   CLOSE ( dbfIva     )

   if !empty( oNewImp )
      oNewImp:End()
   end if

Return nil

//---------------------------------------------------------------------------//

Static Function EndTrans2( aTmp, aGet, oSay, oDlg, nMode )

   local cCod     := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ]

   /*
   Valores que tienen que estar rellenos---------------------------------------
   */

   if empty( cCod )
      MsgStop( "Código no puede estar vacío" )
      return nil
   end if

   if empty( aTmp[( D():Articulos( nView ) )->( fieldpos( "Nombre" ) ) ] )
      MsgStop( "Descripción no puede estar vacío" )
      return nil
   end if

   if empty( oSay[3]:varGet() )
      MsgStop( "Referencia artículo-proveedor no puede estar vacía" )
      return nil
   end if

   if ( D():Articulos( nView ) )->( dbSeek( cCod ) )
      msgStop( "Código ya existe" )
      return nil
   end if

   /*
   Tomamos valores por defecto-------------------------------------------------
   */

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codebar" ) ) ] := cCod
   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lSndDoc" ) ) ] := .t.
   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "dFecChg" ) ) ] := GetSysDate()
   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LastChg" ) ) ] := GetSysDate()
   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ] := cDefIva()
   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lIvaInc" ) ) ] := .f.

   /*
   Calculamos e informamos los 6 precios de venta
   */

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVenta1" ) ) ] := aCalPrePnt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr1" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, D():Articulos( nView ) ),;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf1" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef1" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     D():TiposIva( nView ) )[1]

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva1") ) ] := aCalPrePnt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr1" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, D():Articulos( nView ) ),;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf1" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef1" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     D():TiposIva( nView ) )[2]

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVenta2" ) ) ] := aCalPrePnt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr2" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, D():Articulos( nView ) ),;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf2" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef2" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     D():TiposIva( nView ) )[1]

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva2") ) ] := aCalPrePnt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr2" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, D():Articulos( nView ) ),;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf2" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef2" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     D():TiposIva( nView ) )[2]

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVenta3" ) ) ] := aCalPrePnt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr3" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, D():Articulos( nView ) ),;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf3" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef3" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     D():TiposIva( nView ) )[1]

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva3") ) ] := aCalPrePnt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr3" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, D():Articulos( nView ) ),;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf3" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef3" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     D():TiposIva( nView ) )[2]

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVenta4" ) ) ] := aCalPrePnt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr4" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, D():Articulos( nView ) ),;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf4" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef4" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     D():TiposIva( nView ) )[1]

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva4") ) ] := aCalPrePnt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr4" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, D():Articulos( nView ) ),;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf4" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef4" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     D():TiposIva( nView ) )[2]

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVenta5" ) ) ] := aCalPrePnt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr5" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, D():Articulos( nView ) ),;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf5" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef5" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     D():TiposIva( nView ) )[1]

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva5") ) ] := aCalPrePnt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr5" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, D():Articulos( nView ) ),;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf5" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef5" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     D():TiposIva( nView ) )[2]

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVenta6" ) ) ] := aCalPrePnt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr6" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, D():Articulos( nView ) ),;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf6" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef6" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     D():TiposIva( nView ) )[1]

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "pVtaIva6") ) ] := aCalPrePnt( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nBnfSbr6" ) ) ] <= 1,;
                                                                     nPunt2Euro( aTmp, D():Articulos( nView ) ),;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lBnf6" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Benef6" ) ) ],;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "TipoIva" ) ) ],;
                                                                     nDecDiv,;
                                                                     aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodImp" ) ) ],;
                                                                     oNewImp,;
                                                                     D():TiposIva( nView ) )[2]

   if !empty( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cPrvHab" ) ) ] )

      ( D():ProveedorArticulo( nView ) )->( dbAppend() )
      ( D():ProveedorArticulo( nView ) )->cCodArt        := cCod
      ( D():ProveedorArticulo( nView ) )->cCodPrv        := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cPrvHab" ) ) ]
      ( D():ProveedorArticulo( nView ) )->cRefPrv        := oSay[3]:varGet()
      ( D():ProveedorArticulo( nView ) )->lDefPrv        := .t.
      ( D():ProveedorArticulo( nView ) )->( dbUnlock() )

   end if

   //guarda el artículo

   WinGather( aTmp, aGet, D():Articulos( nView ), nil, nMode )

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

Static Function EndDetalle( aTmp, aGet, dbfTmpPrv, oBrw, nMode, oDlg, lOldPrvDef, aTmpArt, lOldRefPrv )

   if empty( aTmp[ ( dbfTmpPrv )->( fieldPos( "CCODPRV" ) ) ] )
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
   local tmpTipart
   local lSnd        := .f.
   local cFileName   := "Art" + StrZero( ::nGetNumberToSend(), 6 )

   if ::oSender:lServer
      cFileName      += ".All"
   else
      cFileName      += "." + RetSufEmp()
   end if

   if !OpenFiles( .f. )
      return nil
   end if

   ::oSender:SetText( 'Seleccionando artículos' )

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   mkArticulo( cPatSnd() )
   mkOferta( cPatSnd() )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatSnd() + "ARTICULO.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @tmpArticulo ) )
   SET ADSINDEX TO ( cPatSnd() + "ARTICULO.CDX" ) ADDITIVE

   USE ( cPatSnd() + "PROVART.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @tmpArtPrv ) )
   SET ADSINDEX TO ( cPatSnd() + "PROVART.CDX" ) ADDITIVE

   USE ( cPatSnd() + "ARTDIV.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @tmpArtVta ) )
   SET ADSINDEX TO ( cPatSnd() + "ARTDIV.CDX" ) ADDITIVE

   USE ( cPatSnd() + "ARTKIT.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @tmpKit ) )
   SET ADSINDEX TO ( cPatSnd() + "ARTKIT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "ArtImg.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "ArtImg", @tmpImg ) )
   SET ADSINDEX TO ( cPatSnd() + "ArtImg.Cdx" ) ADDITIVE

   USE ( cPatSnd() + "OFERTA.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @tmpOfe ) )
   SET ADSINDEX TO ( cPatSnd() + "OFERTA.CDX" ) ADDITIVE

   USE ( cPatSnd() + "ArtCodebar.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @tmpCodebar ) )
   SET ADSINDEX TO ( cPatSnd() + "ArtCodebar.Cdx" ) ADDITIVE

   if !empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( D():Articulos( nView ) )->( lastrec() )
   end if

   ( D():Articulos( nView ) )->( dbGoTop() )
   while !( D():Articulos( nView ) )->( eof() )

      if ( D():Articulos( nView ) )->lSndDoc

         ::oSender:SetText( AllTrim( ( D():Articulos( nView ) )->Codigo ) + "; " + AllTrim( ( D():Articulos( nView ) )->Nombre ) + "; " + AllTrim( Trans( ( D():Articulos( nView ) )->pVenta1, PicOut() ) ) + "; " + AllTrim( Trans( ( D():Articulos( nView ) )->pVtaIva1, PicOut() ) ) )

         lSnd     := .t.

         dbPass( D():Articulos( nView ), tmpArticulo, .t. )

         /*
         referencias de proveedores
         */

         if ( dbfCodebar )->( dbSeek( ( D():Articulos( nView ) )->Codigo ) )
            while ( dbfCodebar )->cCodArt == ( D():Articulos( nView ) )->Codigo .and. !( dbfCodebar )->( eof() )
               dbPass( dbfCodebar, tmpCodebar, .t. )
               ( dbfCodebar )->( dbSkip( 1 ) )
            end while
         end if

         /*
         referencias de proveedores
         */

         if ( D():ProveedorArticulo( nView ) )->( dbSeek( ( D():Articulos( nView ) )->Codigo ) )
            while ( D():ProveedorArticulo( nView ) )->cCodArt == ( D():Articulos( nView ) )->Codigo .and. !( D():ProveedorArticulo( nView ) )->( eof() )
               dbPass( D():ProveedorArticulo( nView ), tmpArtPrv, .t. )
               ( D():ProveedorArticulo( nView ) )->( dbSkip( 1 ) )
            end while
         end if

         /*
         precios en distintas divisas
         */

         if ( dbfArtVta )->( dbSeek( ( D():Articulos( nView ) )->Codigo ) )
            while ( dbfArtVta )->cCodArt == ( D():Articulos( nView ) )->Codigo .and. !( dbfArtVta )->( eof() )
               dbPass( dbfArtVta, tmpArtVta, .t. )
               ( dbfArtVta )->( dbSkip( 1 ) )
            end while
         end if

         /*
         kits asociados
         */

         if ( dbfArtKit )->( dbSeek( ( D():Articulos( nView ) )->Codigo ) )
            while ( dbfArtKit )->cCodKit == ( D():Articulos( nView ) )->Codigo .and. !( dbfArtKit )->( eof() )
               dbPass( dbfArtKit, tmpKit, .t. )
               ( dbfArtKit )->( dbSkip( 1 ) )
            end while
         end if

         /*
         Ofertas de articulos
         */

         if ( dbfOfe )->( dbSeek( ( D():Articulos( nView ) )->Codigo ) )
            while ( dbfOfe )->cArtOfe == ( D():Articulos( nView ) )->Codigo .and. !( dbfOfe )->( eof() )
               dbPass( dbfOfe, tmpOfe, .t. )
               ( dbfOfe )->( dbSkip( 1 ) )
            end while
         end if

         /*
         Imagenes de articulos
         */

         if ( D():ArticuloImagenes( nView ) )->( dbSeek( ( D():Articulos( nView ) )->Codigo ) )
            while ( D():ArticuloImagenes( nView ) )->cCodArt == ( D():Articulos( nView ) )->Codigo .and. !( D():ArticuloImagenes( nView ) )->( eof() )
               dbPass( D():ArticuloImagenes( nView ), tmpImg, .t. )
               ( D():ArticuloImagenes( nView ) )->( dbSkip( 1 ) )
            end while
         end if

      end if

      ( D():Articulos( nView ) )->( dbSkip() )

      if !empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( D():Articulos( nView ) )->( OrdKeyNo() ) )
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

      ::oSender:SetText( "Comprimiendo artículos : " + cFileName )

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
   local dbfArt

   if ::lSuccesfullSend

      /*
      Sintuacion despues del envio---------------------------------------------
      */

      oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         USE ( cPatArt() + "Articulo.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArt ) )
         SET ADSINDEX TO ( cPatArt() + "Articulo.Cdx" ) ADDITIVE

         while !( dbfArt )->( Eof() )

            if ( dbfArt )->lSndDoc .and. ( dbfArt )->( dbRLock() )
               ( dbfArt )->lSndDoc   := .f.
               ( dbfArt )->( dbRUnlock() )
            end if

            ( dbfArt )->( dbSkip() )

         end while

      RECOVER USING oError

         msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

      CLOSE ( dbfArt )

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

      if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
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
      ::oSender:GetFiles( "Art*." + aExt[ n ], cPatIn() )
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

         if lExistTable( cPatSnd() + "Articulo.Dbf", cLocalDriver() )      .and.;
            lExistTable( cPatSnd() + "ProvArt.Dbf", cLocalDriver() )       .and.;
            lExistTable( cPatSnd() + "ArtDiv.Dbf", cLocalDriver() )        .and.;
            lExistTable( cPatSnd() + "ArtKit.Dbf", cLocalDriver() )        .and.;
            lExistTable( cPatSnd() + "Oferta.Dbf", cLocalDriver() )        .and.;
            lExistTable( cPatSnd() + "ArtCodebar.Dbf", cLocalDriver() )    .and.;
            OpenFiles( .f. )

            USE ( cPatSnd() + "ARTICULO.Dbf" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "ARTICULO", @tmpArticulo ) )
            SET ADSINDEX TO ( cPatSnd() + "ARTICULO.CDX" ) ADDITIVE

            USE ( cPatSnd() + "PROVART.Dbf" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "PROVART", @tmpArtPrv ) )
            SET ADSINDEX TO ( cPatSnd() + "PROVART.CDX" ) ADDITIVE

            USE ( cPatSnd() + "ARTDIV.Dbf" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "ARTDIV", @tmpArtDiv ) )
            SET ADSINDEX TO ( cPatSnd() + "ARTDIV.CDX" ) ADDITIVE

            USE ( cPatSnd() + "ARTKIT.Dbf" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "ARTTIK", @tmpKit ) )
            SET ADSINDEX TO ( cPatSnd() + "ARTKIT.CDX" ) ADDITIVE

            USE ( cPatSnd() + "OFERTA.Dbf" ) NEW VIA ( cLocalDriver() ) READONLY ALIAS ( cCheckArea( "OFERTA", @tmpOfe ) )
            SET ADSINDEX TO ( cPatSnd() + "OFERTA.CDX" ) ADDITIVE

            USE ( cPatSnd() + "ArtCodebar.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @tmpCodebar ) )
            SET ADSINDEX TO ( cPatSnd() + "ArtCodebar.Cdx" ) ADDITIVE

            ::oSender:SetText( "Ficheros de articulos descomprimimos correctamente" )
            ::oSender:SetText( "Total de registros recibidos " + alltrim( str( ( tmpArticulo )->( lastrec() ) ) ) )

            if !empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpArticulo )->( lastrec() )
            end if

            ( tmpArticulo )->( ordsetfocus( 0 ) )
            ( tmpArticulo )->( dbgotop() )

            while !( tmpArticulo )->( eof() )

               if ( D():Articulos( nView ) )->( dbSeek( ( tmpArticulo )->Codigo ) )

                  if !::oSender:lServer

                     ::CleanRelation( ( tmpArticulo )->Codigo )

                     dbPass( tmpArticulo, D():Articulos( nView ) )

                     if dbLock( D():Articulos( nView ) )
                        ( D():Articulos( nView ) )->lSndDoc := .f.
                        ( D():Articulos( nView ) )->( dbUnLock() )
                     end if

                     ::oSender:SetText( "Reemplazado : " + AllTrim( ( D():Articulos( nView ) )->Codigo ) + "; " + AllTrim( ( D():Articulos( nView ) )->Nombre ) + "; " + AllTrim( Trans( ( D():Articulos( nView ) )->pVenta1, PicOut() ) ) + "; " + AllTrim( Trans( ( D():Articulos( nView ) )->pVtaIva1, PicOut() ) ) )

                  else

                     ::oSender:SetText( "Desestimado : " + AllTrim( ( D():Articulos( nView ) )->Codigo ) + "; " + AllTrim( ( D():Articulos( nView ) )->Nombre ) + "; " + AllTrim( Trans( ( D():Articulos( nView ) )->pVenta1, PicOut() ) ) + "; " + AllTrim( Trans( ( D():Articulos( nView ) )->pVtaIva1, PicOut() ) ) )

                  end if

               else

                  ::CleanRelation( ( tmpArticulo )->Codigo )

                  dbPass( tmpArticulo, D():Articulos( nView ), .t. )

                  if dbLock( D():Articulos( nView ) )
                     ( D():Articulos( nView ) )->lSndDoc := .f.
                     ( D():Articulos( nView ) )->( dbUnLock() )
                  end if

                  ::oSender:SetText( "Añadido : " + AllTrim( ( D():Articulos( nView ) )->Codigo ) + "; " + AllTrim( ( D():Articulos( nView ) )->Nombre ) + "; " + AllTrim( Trans( ( D():Articulos( nView ) )->pVenta1, PicOut() ) ) + "; " + AllTrim( Trans( ( D():Articulos( nView ) )->pVtaIva1, PicOut() ) ) )
               
               end if

               ( tmpArticulo )->( dbSkip() )

               if !empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpArticulo )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            if !empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpArtPrv )->( LastRec() )
            end if

            ( tmpArtPrv )->( ordsetfocus( 0 ) )
            ( tmpArtPrv )->( dbgotop() )
            while !( tmpArtPrv )->( eof() )

               if ( D():ProveedorArticulo( nView ) )->( dbSeek( ( tmpArtPrv )->cCodArt ) )
                  if !::oSender:lServer
                     dbPass( tmpArtPrv, D():ProveedorArticulo( nView ) )
                  end if
               else
                  dbPass( tmpArtPrv, D():ProveedorArticulo( nView ), .t. )
               end if

               ( tmpArtPrv )->( dbSkip() )

               if !empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( (tmpArtPrv)->( recno() ) )
               end if

               SysRefresh()

            end while

            if !empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpArtDiv )->( lastrec() )
            end if

            ( tmpArtDiv )->( ordsetfocus( 0 ) )
            ( tmpArtDiv )->( dbgotop() )
            while !( tmpArtDiv )->( eof() )

               if ( dbfArtVta )->( dbSeek( ( tmpArtDiv )->cCodArt + ( tmpArtDiv )->cCodPr1 + ( tmpArtDiv )->cCodPr2 + ( tmpArtDiv )->cVAlpR1 + ( tmpArtDiv )->cValPr2 ) )
                  if !::oSender:lServer
                     dbPass( tmpArtDiv, dbfArtVta )
                  end if
               else
                  dbPass( tmpArtDiv, dbfArtVta, .t. )
               end if

               ( tmpArtDiv )->( dbSkip() )

               if !empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpArtDiv )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            if !empty( ::oSender:oMtr )
               ::oSender:oMtr:Set( ( tmpArtDiv )->( lastrec() ) )
            end if

            /*
            Kits Asociados
            */

            if !empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := (tmpKit)->( lastrec() )
            end if

            ( tmpKit )->( ordsetfocus( 0 ) )
            ( tmpKit )->( dbgotop() )
            while !( tmpKit )->( eof() )

               if ( dbfArtKit )->( dbSeek( ( tmpKit )->CCODKIT ) )
                  if !::oSender:lServer
                     dbPass( tmpKit, dbfArtKit )
                  end if
               else
                  dbPass( tmpKit, dbfArtKit, .t. )
               end if

               ( tmpKit )->( dbSkip() )

               if !empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpKit )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            /*
            ofertas de articulos
            */

            if !empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpOfe )->( lastrec() )
            end if

            ( tmpOfe )->( ordsetfocus( 0 ) )
            ( tmpOfe )->( dbgotop() )
            while !( tmpOfe )->( eof() )

               if ( dbfOfe )->( dbSeek( ( tmpOfe )->cArtOfe ) )
                  if !::oSender:lServer
                     dbPass( tmpOfe, dbfOfe )
                  end if
               else
                  dbPass( tmpOfe, dbfOfe, .t. )
               end if

               ( tmpOfe )->( dbSkip() )

               if !empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpOfe )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            if !empty( ::oSender:oMtr )
               ::oSender:oMtr:Set( ( tmpOfe )->( lastrec() ) )
            end if

            /*
            Codigos de barras-----------------------------------------------
            */

            ( dbfCodebar )->( OrdSetFocus( "cArtBar" ) )

            if !empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpCodebar )->( lastrec() )
            end if

            ( tmpCodebar )->( ordsetfocus( 0 ) )
            ( tmpCodebar )->( dbgotop() )
            while !( tmpCodebar )->( eof() )

               if ( dbfCodebar )->( dbSeek( ( tmpCodebar )->cCodArt + ( tmpCodebar )->cCodBar ) ) .and. !::oSender:lServer
                  dbPass( tmpCodebar, dbfCodebar )
               else
                  dbPass( tmpCodebar, dbfCodebar, .t. )
               end if

               ( tmpCodebar )->( dbSkip() )

               if !empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpCodebar )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            ( dbfCodebar )->( OrdSetFocus( "cCodArt" ) )

            if !empty( ::oSender:oMtr )
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

   while ( D():ProveedorArticulo( nView ) )->( dbSeek( cCodArt ) )
      dbDel( D():ProveedorArticulo( nView ) )
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

            MENUITEM "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra para el artículo" ;
               RESOURCE "GC_FORM_PLUS2_16" ;
               ACTION   ( oDetCamposExtra:Play( Space(1) ) )

            MENUITEM "&2. Informe de artículo en escandallo";
               MESSAGE  "Muestra el informe del artículo en escandallo" ;
               RESOURCE "info16" ;
               ACTION   ( BrwVtaComArt( ( dbfTmpKit )->cRefKit, ( dbfTmpKit )->cDesKit, dbfDiv, D():TiposIva( nView ), dbfAlmT, D():Articulos( nView ) ) )

            MENUITEM "&3. Ver comando";
               MESSAGE  "Muestra el informe del artículo en escandallo" ;
               RESOURCE "info16" ;
               ACTION   ( debugWeb( aTmp ) )

            MENUITEM "&4. Información enlace web";
               MESSAGE  "Muestra el informe del artículo en la web" ;
               RESOURCE "info16" ;
               ACTION   ( infoWeb( aTmp ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

   if !empty( oActiveX )
      oActiveX:DocumentHTML      := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "MDESTEC" ) ) ]
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

   aTmpArt[ ( D():Articulos( nView ) )->( fieldPos( "CPRVHAB" ) ) ]  := aTmp[ ( dbfTmpPrv )->( fieldPos( "CCODPRV" ) ) ]

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

            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cPrvHab" ) ) ]       := ( dbfTmpPrv )->cCodPrv

         else

            aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cPrvHab" ) ) ]       := Space( 12 )

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
      Return ( uTmpArticulo[ ( D():Articulos( nView ) )->( Fieldpos( "lKitArt" ) ) ] .and. !uTmpArticulo[ ( D():Articulos( nView ) )->( Fieldpos( "lKitAsc" ) ) ] )
   end if

Return ( .f. )

//---------------------------------------------------------------------------//

Static Function lValidUndMedicion( aTmp, aGet )

   if oUndMedicion:oDbf:SeekInOrd( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CUNIDAD" ) ) ], "CCODMED" )

      aGet[ ( D():Articulos( nView ) )->( fieldpos( "CUNIDAD" ) ) ]:oHelpText:cText( oUndMedicion:oDbf:cNombre )

      //si nDimension es igual a 1 muestra la primera descrpción

      if oUndMedicion:oDbf:nDimension >= 1

         aGet[ ( D():Articulos( nView ) )->( fieldpos( "NLNGART" ) ) ]:Show()
         aGet[ ( D():Articulos( nView ) )->( fieldpos( "NLNGART" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )

      end if

      //si nDimension es igual a 2 muestra las dos primeras descripciones

      if oUndMedicion:oDbf:nDimension >= 2

         aGet[ ( D():Articulos( nView ) )->( fieldpos( "NALTART" ) ) ]:Show()
         aGet[ ( D():Articulos( nView ) )->( fieldpos( "NALTART" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )

      end if

      //si nDimension es igual a 3 muestra las tres descripciones

      if oUndMedicion:oDbf:nDimension >= 3

         aGet[ ( D():Articulos( nView ) )->( fieldpos( "NANCART" ) ) ]:Show()
         aGet[ ( D():Articulos( nView ) )->( fieldpos( "NANCART" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )

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

Static Function ExpFamilia( cCodFam, oSayFamilia, aGet )

   if empty( cCodFam )
      Return .t.
   end if

   if dbSeekInOrd( cCodFam, "cCodFam", D():Familias( nView ) )

      oSayFamilia:cText( ( D():Familias( nView ) )->cNomFam )

      if cCodFam != cCodigoFamilia

         if ( !empty( ( D():Familias( nView ) )->cCodPrp1 ) .and. aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ]:VarGet() != ( D():Familias( nView ) )->cCodPrp1 ) .or.;
            ( !empty( ( D():Familias( nView ) )->cCodPrp2 ) .and. aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ]:VarGet() != ( D():Familias( nView ) )->cCodPrp2 ) .or.;
            ( !empty( ( D():Familias( nView ) )->cCodFra  ) .and. aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFra"  ) ) ]:VarGet() != ( D():Familias( nView ) )->cCodFra  )

            if ApoloMsgNoYes( "¿ Desea importar las propiedades y frases publicitarias de la familia ?" )

               aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ]:cText( ( D():Familias( nView ) )->cCodPrp1 )
               aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ]:lValid()

               aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ]:cText( ( D():Familias( nView ) )->cCodPrp2 )
               aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ]:lValid()

               aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFra" ) ) ]:cText( ( D():Familias( nView ) )->cCodFra )
               aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodFra" ) ) ]:lValid()

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

   Data oAlmacen
   Data cAlmacen

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

   Data nRecno

   Method New()
   Method Dialog()
      Method StartSelectPropertiesLabels()
   Method End()

   Method BotonAnterior()
   Method BotonSiguiente()

   Method PutLabel()

   Method SelectAllLabels()
      Method SelectAllLabelsDbf()
      Method SelectAllLabelsADS()

   Method SelectPropertiesLabels()

   Method LoadPropertiesLabels()
   Method SavePropertiesLabels()

   Method SelectCriterioLabels()

   Method putStockLabels()
   Method selectLabelSelecction()

   Method cleanPropertiesLabels()

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

Method New() CLASS TArticuloLabelGenerator

   ::cCriterio          := "Ningún criterio"
   ::aCriterio          := { "Ningún criterio", "Todos los registros", "Familia", "Fecha modificación" }

   ::nRecno             := ( D():Articulos( nView ) )->( recno() )
   ::cFamiliaInicio     := ( D():Articulos( nView ) )->Familia
   ::cFamiliaFin        := ( D():Articulos( nView ) )->Familia

   ::dFechaInicio       := Ctod( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ), 4 ) )
   ::dFechaFin          := GetSysDate()

   ::nMtrLabel          := 0

   ::nFilaInicio        := 1
   ::nColumnaInicio     := 1

   ::nCantidadLabels    := 1
   ::nUnidadesLabels    := 1

   ::aSearch            := { "Código", "Nombre" }

   ::cFormatoLabel      := GetPvProfString( "Etiquetas", "Articulo", Space( 3 ), cPatEmp() + "Empresa.Ini" )
   if len( ::cFormatoLabel ) < 3
      ::cFormatoLabel   := Space( 3 )
   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method Dialog() CLASS TArticuloLabelGenerator 

   local oGetOrd
   local cGetOrd     := Space( 100 )
	local oCbxOrd
   local cCbxOrd     := "Código"
   local aCbxOrd     := { "Código", "Nombre" }

   DEFINE DIALOG ::oDlg RESOURCE "SelectLabels_0"

      REDEFINE PAGES ::oFld ;
         ID       10;
         OF       ::oDlg ;
         DIALOGS  "SelectLabels_3",;
                  "SelectLabels_2"

      // Bitmap-------------------------------------------------------------------

      REDEFINE BITMAP ;
         RESOURCE "gc_portable_barcode_scanner_48" ;
         ID       500 ;
         TRANSPARENT ;
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

      ::oFamiliaInicio:bValid    := {|| cFamilia( ::oFamiliaInicio, D():Familias( nView ), ::oFamiliaInicio:oHelpText ), .t. }
      ::oFamiliaInicio:bHelp     := {|| BrwFamilia( ::oFamiliaInicio, ::oFamiliaInicio:oHelpText ) }

      REDEFINE SAY ::oInicio ;
         ID       102 ;
         OF       ::fldGeneral

      REDEFINE GET ::oFamiliaFin VAR ::cFamiliaFin ;
         ID       110 ;
         IDTEXT   111 ;
         BITMAP   "LUPA" ;
         OF       ::fldGeneral

      ::oFamiliaFin:bValid       := {|| cFamilia( ::oFamiliaFin, D():Familias( nView ), ::oFamiliaFin:oHelpText ), .t. }
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

      TBtnBmp():ReDefine( 220, "gc_document_text_pencil_12",,,,,{|| EdtDocumento( ::cFormatoLabel ) }, ::fldGeneral, .f., , .f., "Modificar formato de etiquetas" )

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

      REDEFINE GET ::oAlmacen Var ::cAlmacen ;
         ID       230 ;
         IDTEXT   231 ;
         PICTURE  "@!" ;
         WHEN     ( ::nCantidadLabels == 2 ) ;
         BITMAP   "LUPA" ;
         OF       ::fldGeneral

         ::oAlmacen:bValid    := { || cAlmacen( ::oAlmacen, , ::oAlmacen:oHelpText ) }
         ::oAlmacen:bHelp     := { || BrwAlmacen( ::oAlmacen, ::oAlmacen:oHelpText ) }

      // Segunda caja de dialogo--------------------------------------------------

      REDEFINE GET oGetOrd ;
         VAR      cGetOrd;
         ID       200 ;
         BITMAP   "FIND" ;
         OF       ::fldPrecios

      oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwLabel, D():Articulos( nView ) ) }
      oGetOrd:bValid    := {|| ( D():Articulos( nView ) )->( OrdScope( 0, nil ) ), ( D():Articulos( nView ) )->( OrdScope( 1, nil ) ), ::oBrwLabel:Refresh(), .t. }

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
         ACTION   ( WinEdtRec( ::oBrwLabel, bEdit, D():Articulos( nView ) ) )

      REDEFINE BUTTON ;
         ID       165 ;
         OF       ::fldPrecios ;
         ACTION   ( WinZooRec( ::oBrwLabel, bEdit, D():Articulos( nView ) ) )

      ::oBrwLabel                 := IXBrowse():New( ::fldPrecios )

      ::oBrwLabel:nMarqueeStyle   := 5
      ::oBrwLabel:nColSel         := 2

      ::oBrwLabel:lHScroll        := .f.
      ::oBrwLabel:cAlias          := D():Articulos( nView )

      ::oBrwLabel:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwLabel:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwLabel:bLDblClick      := {|| ::PutLabel() }

      ::oBrwLabel:CreateFromResource( 180 )

      with object ( ::oBrwLabel:AddCol() )
         :cHeader          := "Sl. Seleccionada"
         :bEditValue       := {|| ( D():Articulos( nView ) )->lLabel }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( ::oBrwLabel:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( D():Articulos( nView ) )->Codigo }
         :nWidth           := 80
         :cSortOrder       := "Codigo"
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( ::oBrwLabel:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| ( D():Articulos( nView ) )->Nombre }
         :nWidth           := 280
         :cSortOrder       := "Nombre"
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( ::oBrwLabel:AddCol() )
         :cHeader          := "N. etiquetas"
         :bEditValue       := {|| ( D():Articulos( nView ) )->nLabel }
         :cEditPicture     := "@E 99,999"
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :bOnPostEdit      := {|o,x| if( dbDialogLock( D():Articulos( nView ) ), ( ( D():Articulos( nView ) )->nLabel := x, ( D():Articulos( nView ) )->( dbUnlock() ) ), ) }
      end with

      REDEFINE METER ::oMtrLabel ;
         VAR      ::nMtrLabel ;
         PROMPT   "" ;
         ID       190 ;
         OF       ::fldPrecios ;
         TOTAL    ( D():Articulos( nView ) )->( lastrec() )

      ::oMtrLabel:nClrText   := rgb( 128,255,0 )
      ::oMtrLabel:nClrBar    := rgb( 128,255,0 )
      ::oMtrLabel:nClrBText  := rgb( 128,255,0 )

      /*
      Botones generales--------------------------------------------------------
      */

      REDEFINE BUTTON ::oBtnListado ;          // Boton listado
         ID       40 ;
         OF       ::oDlg ;
         ACTION   ( TInfArtFam():New( "Listado de artículos seleccionados para etiquetas" ):Play( .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ), D():Familias( nView ), oStock, oWndBrw ) )

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

         if empty( ::cFormatoLabel )

            MsgStop( "Debe cumplimentar un formato de etiquetas" )

         else

            ::oFld:GoNext()
            ::oBtnAnterior:Show()

            ::SelectCriterioLabels()

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

   ( D():Articulos( nView ) )->( dbgoto( ::nRecno ) )

Return ( Self )

//--------------------------------------------------------------------------//

Method PutLabel() CLASS TArticuloLabelGenerator

   if dbLock( D():Articulos( nView ) )
      ( D():Articulos( nView ) )->lLabel := !( D():Articulos( nView ) )->lLabel
      ( D():Articulos( nView ) )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectAllLabels( lSelect ) CLASS TArticuloLabelGenerator

	CursorWait()

   ::oDlg:Disable()

   if lAIS()
      ::SelectAllLabelsADS( lSelect )
   else 
      ::SelectAllLabelsDbf( lSelect )
   end if 

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

   ::oDlg:Enable()

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectAllLabelsDbf( lSelect )

   local n        := 0
   local nRecno   := ( D():Articulos( nView ) )->( Recno() )

   ( D():Articulos( nView ) )->( dbGoTop() )
   while !( D():Articulos( nView ) )->( eof() )

      if ( D():Articulos( nView ) )->lLabel != lSelect

         if dbLock( D():Articulos( nView ) )
            ( D():Articulos( nView ) )->lLabel := lSelect
            ( D():Articulos( nView ) )->( dbUnLock() )
         end if

      end if

      ( D():Articulos( nView ) )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ( D():Articulos( nView ) )->( dbGoTo( nRecno ) )

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectAllLabelsADS( lSelect )

   TDataCenter():ExecuteSqlStatement(  "UPDATE " + cPatEmp() + "Articulo " + ;
                                          "SET lLabel = " + if( lSelect, "True", "False" ) )

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectCriterioLabels() CLASS TArticuloLabelGenerator

	local n			:= 0

	CursorWait()

   ::oDlg:Disable()

   ( D():Articulos( nView ) )->( dbGoTop() )
   while !( D():Articulos( nView ) )->( eof() )

      ::cleanPropertiesLabels()

      ::putStockLabels()

      ::selectLabelSelecction()

      ( D():Articulos( nView ) )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

   ( D():Articulos( nView ) )->( dbGoTop() )

   ::oDlg:Enable()

	CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//
/*
Limpiamos las etiquetas por propiedades
*/

Method cleanPropertiesLabels() CLASS TArticuloLabelGenerator

   while ( dbfArtLbl )->( dbSeek( ( D():Articulos( nView ) )->Codigo ) ) .and. !( dbfArtLbl )->( eof() )
      if dbLock( dbfArtLbl )
         ( dbfArtLbl )->( dbDelete() )
         ( dbfArtLbl )->( dbUnLock() )
      end if
   end while

Return ( Self )

//--------------------------------------------------------------------------//

Method PutStockLabels() CLASS TArticuloLabelGenerator

   local o
   local aStock
   local nStock                              := 0

   if ::nCantidadLabels == 1

      if ( ( D():Articulos( nView ) )->nLabel != ::nUnidadesLabels ) .and. ;
         ( D():Articulos( nView ) )->( dbrlock() )
         ( D():Articulos( nView ) )->nLabel  := ::nUnidadesLabels
         ( D():Articulos( nView ) )->( dbunlock() )
      end if 

      Return ( Self )

   end if 

   /*
   Calculo de stock------------------------------------------------------------
   */

   if !empty( ( D():Articulos( nView ) )->cCodPrp1 ) .or. !empty( ( D():Articulos( nView ) )->cCodPrp2 )

      if !empty( ::cAlmacen ) 
         aStock                        := oStock:aStockArticulo( ( D():Articulos( nView ) )->Codigo, ::cAlmacen, , .f., .f. ) 
      else 
         aStock                        := oStock:aStockArticulo( ( D():Articulos( nView ) )->Codigo, , , .f., .f. ) 
      end if

      for each o in aStock

         if dbAppe( dbfArtLbl )
            ( dbfArtLbl )->cCodArt     := o:cCodigo
            ( dbfArtLbl )->cCodPr1     := o:cCodigoPropiedad1
            ( dbfArtLbl )->cCodPr2     := o:cCodigoPropiedad2
            ( dbfArtLbl )->cValPr1     := o:cValorPropiedad1
            ( dbfArtLbl )->cValPr2     := o:cValorPropiedad2
            ( dbfArtLbl )->nUndLbl     := o:nUnidades
            ( dbfArtLbl )->( dbUnLock() )
         end if

         nStock                        += o:nUnidades

      next

   else

      nStock                           := oStock:nStockArticulo( ( D():Articulos( nView ) )->Codigo, , , .f., .f. )

   end if

   nStock                              := max( nStock, 0 )

   if ( D():Articulos( nView ) )->nLabel != nStock .and. ;
      ( D():Articulos( nView ) )->( dbRLock() )
      ( D():Articulos( nView ) )->nLabel  := nStock
      ( D():Articulos( nView ) )->( dbUnLock() )
   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method selectLabelSelecction() CLASS TArticuloLabelGenerator

   local lLabel   := .f.

   do case
      case ::oCriterio:nAt == 1
      
         lLabel   := .f.

      case ::oCriterio:nAt == 2

         lLabel   := .t.
      
      case ::oCriterio:nAt == 3 .and. ( D():Articulos( nView ) )->Familia >= ::cFamiliaInicio .and. ( D():Articulos( nView ) )->Familia <= ::cFamiliaFin

         lLabel   := .t.

      case ::oCriterio:nAt == 4 .and. ( D():Articulos( nView ) )->LastChg >= ::dFechaInicio .and. ( D():Articulos( nView ) )->LastChg <= ::dFechaFin 

         lLabel   := .t.

      otherwise
   end case

   if ( D():Articulos( nView ) )->lLabel != lLabel .and. ;
      ( D():Articulos( nView ) )->( dbRLock() )
      ( D():Articulos( nView ) )->lLabel    := lLabel
      ( D():Articulos( nView ) )->( dbUnLock() )
   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectPropertiesLabels() CLASS TArticuloLabelGenerator

   local n
   local oDlg
   local oGetUnidades
   local nGetUnidades   := 0

   if empty( ( D():Articulos( nView ) )->cCodPrp1 ) .and. empty( ( D():Articulos( nView ) )->cCodPrp2 )
      msgStop( "Este artículo no tiene propiedades." )
      Return .f. 
   end if

   DEFINE DIALOG oDlg RESOURCE "Propiedades"

      BrowseProperties():newInstance( 100, oDlg, nView )

      REDEFINE GET oGetUnidades ;
         VAR      nGetUnidades ;
         ID       110 ;
         WHEN     ( .f. ) ;
         PICTURE  masUnd() ;
         OF       oDlg 

      BrowseProperties():getInstance():setBindingUnidades( oGetUnidades )

      REDEFINE BUTTON;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( BrowseProperties():getInstance():cleanPropertiesUnits() )

      REDEFINE BUTTON;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( ::SavePropertiesLabels( oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:bStart := {|| ::StartSelectPropertiesLabels() }

      oDlg:AddFastKey( VK_F5, {|| ::SavePropertiesLabels( oDlg ) } )

   ACTIVATE DIALOG oDlg CENTER

Return ( Self )

//--------------------------------------------------------------------------//

Method StartSelectPropertiesLabels()

   BrowseProperties():getInstance():buildPropertiesTable( ( D():Articulos( nView ) )->Codigo, ( D():Articulos( nView ) )->cCodPrp1, ( D():Articulos( nView ) )->cCodPrp2 )

   ::LoadPropertiesLabels()   

   BrowseProperties():getInstance():nTotalProperties()

Return ( Self )

//--------------------------------------------------------------------------//

Method SavePropertiesLabels( oDlg ) CLASS TArticuloLabelGenerator

   local o
   local a
   local n  := 0

   while ( dbfArtLbl )->( dbSeek( ( D():Articulos( nView ) )->Codigo ) ) .and. !( dbfArtLbl )->( eof() )
      if dbLock( dbfArtLbl )
         ( dbfArtLbl )->( dbDelete() )
         ( dbfArtLbl )->( dbUnLock() )
      end if
   end while

   for each a in ( BrowseProperties():getInstance():aPropertiesTable )

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

   if dbLock( D():Articulos( nView ) )
      ( D():Articulos( nView ) )->lLabel := .t.
      ( D():Articulos( nView ) )->nLabel := n
      ( D():Articulos( nView ) )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

   oDlg:end( IDOK )

Return ( .t. )

//--------------------------------------------------------------------------//

Method LoadPropertiesLabels() CLASS TArticuloLabelGenerator

   if ( dbfArtLbl )->( dbSeek( ( D():Articulos( nView ) )->Codigo ) )

      while ( dbfArtLbl )->cCodArt == ( D():Articulos( nView ) )->Codigo .and. !( dbfArtLbl )->( eof() )

         BrowseProperties():getInstance():setPropertiesUnits( ( dbfArtLbl )->cCodArt, ( dbfArtLbl )->cCodPr1, ( dbfArtLbl )->cCodPr2, ( dbfArtLbl )->cValPr1, ( dbfArtLbl )->cValPr2, ( dbfArtLbl )->nUndLbl )

         ( dbfArtLbl )->( dbSkip() )

      end while

   end if

Return ( nil )

//--------------------------------------------------------------------------//

Static Function bGenEditText( aTblPrp, oBrwPrp, n )

Return ( {|| aTblPrp[ oBrwPrp:nArrayAt, n ]:cText } )

//--------------------------------------------------------------------------//

Static Function bGenEditValue( aTblPrp, oBrwPrp, n )

Return ( {|| aTblPrp[ oBrwPrp:nArrayAt, n ]:Value } )

//--------------------------------------------------------------------------//

Method AddLabel() CLASS TArticuloLabelGenerator

   if dbLock( D():Articulos( nView ) )
      ( D():Articulos( nView ) )->nLabel++
      ( D():Articulos( nView ) )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method DelLabel() CLASS TArticuloLabelGenerator

   if ( D():Articulos( nView ) )->nLabel > 1
      if dbLock( D():Articulos( nView ) )
         ( D():Articulos( nView ) )->nLabel--
         ( D():Articulos( nView ) )->( dbUnLock() )
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
   local dbfArt

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      tmpArticulo          := "LblArt"
      filArticulo          := cGetNewFileName( cPatTmp() + "LblAlb" )

      dbCreate( filArticulo, aSqlStruct( aItmArt() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), filArticulo, tmpArticulo, .f. )

      ( tmpArticulo )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( tmpArticulo )->( OrdCreate( filArticulo, "Codigo", "Codigo", {|| Field->Codigo } ) )

      if empty( dbfArt )
         USE ( cPatArt() + "ARTICULO.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArt ) )
         SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE
         lCloseArticulo    := .t.
      end if

      if empty( dbfArtLbl )
         USE ( cPatArt() + "ArtLbl.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ArtLbl", @dbfArtLbl ) )
         SET ADSINDEX TO ( cPatArt() + "ArtLbl.Cdx" ) ADDITIVE
         lCloseLabel       := .t.
      end if

      /*
      Proceso de paso a temporales---------------------------------------------
      */

      nRec                 := ( dbfArt )->( Recno() )

      ( dbfArt )->( dbGoTop() )
      while !( dbfArt )->( eof() )

         if ( dbfArt )->lLabel

            if ( dbfArtLbl )->( dbSeek( ( dbfArt )->Codigo ) )

               while ( dbfArtLbl )->cCodArt == ( dbfArt )->Codigo .and. !( dbfArtLbl )->( eof() )

                  for n := 1 to ( ( dbfArtLbl )->nUndLbl )

                     dbPass( dbfArt, tmpArticulo, .t. )

                     ( tmpArticulo )->cCodPrp1  := ( dbfArtLbl )->cCodPr1
                     ( tmpArticulo )->cCodPrp2  := ( dbfArtLbl )->cCodPr2
                     ( tmpArticulo )->cValPrp1  := ( dbfArtLbl )->cValPr1
                     ( tmpArticulo )->cValPrp2  := ( dbfArtLbl )->cValPr2

                  next

                  ( dbfArtLbl )->( dbSkip() )

               end while

            else

               for n := 1 to ( dbfArt )->nLabel
                  dbPass( dbfArt, tmpArticulo, .t. )
               next

            end if

         end if

         ( dbfArt )->( dbSkip() )

      end while

      ( dbfArt )->( dbGoTo( nRec ) )

      ( tmpArticulo )->( dbGoTop() )

      /*
      Cerramos las tablas------------------------------------------------------
      */

      if lCloseArticulo
         ( dbfArt )->( dbCloseArea() )
         dbfArt       := nil
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
   local nColumns       := oFr:GetProperty( "MainPage", "Columns" )
   local nHeight        := oFr:GetProperty( "MasterData", "Height" )
   local nItemsInColumn := 0

   if !empty( nPaperHeight ) .and. !empty( nHeight ) .and. !empty( nColumns )

      nItemsInColumn    := int( nPaperHeight / nHeight )

      nBlancos          := ( ::nColumnaInicio - 1 ) * nItemsInColumn
      nBlancos          += ( ::nFilaInicio - 1 )

      for n := 1 to nBlancos
         dbPass( dbBlankRec( D():Articulos( nView ) ), tmpArticulo, .t. )
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

   // Manejador de eventos-----------------------------------------------------

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos---------------------------------------------------------------
   */

   DataReport( oFr, .t. )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !empty( ( dbfDoc )->mReport )

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

#endif

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

   if !lExistTable( cPath + "ArtLeng.Dbf" )
      dbCreate( cPath + "ArtLeng.Dbf",    aSqlStruct( aItmArtLeng() ), cDriver() )
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
      !lExistIndex( cPath + "ArtLeng.Cdx"    )  .or. ;
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

   if !empty( oMeter )
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
   end if

   if !lExistTable( cPath + "Articulo.Dbf", cLocalDriver() )
      dbCreate( cPath + "Articulo.Dbf", aSqlStruct( aItmArt() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "ArtDiv.Dbf", cLocalDriver() )
      dbCreate( cPath + "ArtDiv.Dbf", aSqlStruct( aItmVta() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "ArtKit.Dbf", cLocalDriver() )
      dbCreate( cPath + "ArtKit.Dbf", aSqlStruct( aItmKit() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "ArtCodebar.Dbf", cLocalDriver() )
      dbCreate( cPath + "ArtCodebar.Dbf", aSqlStruct( aItmBar() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "ProvArt.Dbf", cLocalDriver() )
      dbCreate( cPath + "ProvArt.Dbf", aSqlStruct( aItmArtPrv() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "ArtLeng.Dbf", cLocalDriver() )
      dbCreate( cPath + "ArtLeng.Dbf", aSqlStruct( aItmArtLeng() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "ArtLbl.Dbf", cLocalDriver() )
      dbCreate( cPath + "ArtLbl.Dbf", aSqlStruct( aItmLbl() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "ArtImg.Dbf", cLocalDriver() )
      dbCreate( cPath + "ArtImg.Dbf", aSqlStruct( aItmImg() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "ArtAlm.Dbf", cLocalDriver() )
      dbCreate( cPath + "ArtAlm.Dbf", aSqlStruct( aItmStockaAlmacenes() ), cLocalDriver() )
   end if

   /*
   Regeneramos indices---------------------------------------------------------
   */

   if lAppend .and. lIsDir( cPathOld )

      AppDbf( cPathOld, cPath, "Articulo"    )
      AppDbf( cPathOld, cPath, "ArtDiv"      )
      AppDbf( cPathOld, cPath, "ProvArt"     )
      AppDbf( cPathOld, cPath, "ArtLeng"     )
      AppDbf( cPathOld, cPath, "ArtCodebar"  )
      AppDbf( cPathOld, cPath, "ArtKit"      )
      AppDbf( cPathOld, cPath, "ArtLbl"      )
      AppDbf( cPathOld, cPath, "ArtImg"      )
      AppDbf( cPathOld, cPath, "ArtAlm"      )

      if lMovAlm
         AppDbf( cPathOld, cPath, "MovAlm"   )
      end if

   end if

   rxArticulo( cPath, cLocalDriver() )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxArticulo( cPath, cDriver )

   local oError
   local oBlock
   local dbfArt
   local dbfCodebar

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DEFAULT cPath     := cPatArt()
   DEFAULT cDriver   := cDriver()

   if !lExistTable( cPath + "Articulo.Dbf"   ) .or. ;
      !lExistTable( cPath + "ProvArt.Dbf"    ) .or. ;
      !lExistTable( cPath + "ArtLeng.Dbf"    ) .or. ;
      !lExistTable( cPath + "ArtDiv.Dbf"     ) .or. ;
      !lExistTable( cPath + "ArtKit.Dbf"     ) .or. ;
      !lExistTable( cPath + "ArtCodebar.Dbf" ) .or. ;
      !lExistTable( cPath + "ArtLbl.Dbf"     ) .or. ;
      !lExistTable( cPath + "ArtImg.Dbf"     ) .or. ;
      !lExistTable( cPath + "ArtAlm.Dbf"     )

      mkArticulo( cPath )

   end if

   fErase( cPath + "Articulo.Cdx"   )
   fErase( cPath + "ProvArt.Cdx"    )
   fErase( cPath + "ArtLeng.Cdx"    )
   fErase( cPath + "ArtDiv.Cdx"     )
   fErase( cPath + "ArtKit.Cdx"     )
   fErase( cPath + "ArtCodebar.Cdx" )
   fErase( cPath + "ArtLbl.Cdx"     )
   fErase( cPath + "ArtImg.Cdx"     )
   fErase( cPath + "ArtAlm.Cdx"     )

   dbUseArea( .t., cDriver, cPath + "ARTICULO.Dbf", cCheckArea( "ARTICULO", @dbfArt ), .f. )

   if !( dbfArt )->( neterr() )

      ( dbfArt )->( __dbPack() )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "Articulo.Cdx", "Codigo", "Codigo", {|| Field->Codigo } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "Nombre", "UPPER( NOMBRE )", {|| UPPER( Field->NOMBRE ) } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "CFAMCOD", "FAMILIA + CODIGO", {|| Field->FAMILIA + Field->CODIGO }, ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "cPrvHab", "cPrvHab", {|| Field->cPrvHab }, ) )

      ( dbfArt )->( ordCondSet("!Deleted() .and. !lObs", {|| !Deleted() .and. !Field->lObs }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "CodObs", "Codigo", {|| Field->Codigo } ) )

      ( dbfArt )->( ordCondSet("!Deleted() .and. !lObs", {|| !Deleted() .and. !Field->lObs }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "NomObs", "Upper( Nombre )", {|| Upper( Field->Nombre ) } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "CCODTIP", "CCODTIP", {|| Field->CCODTIP }, ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "CCODCATE", "CCODCATE", {|| Field->CCODCATE }, ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "CCODTEMP", "CCODTEMP", {|| Field->CCODTEMP }, ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "CCODFAB", "CCODFAB", {|| Field->CCODFAB }, ) )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.Cdx", "cCodEst", "Field->cCodEst", {|| Field->cCodEst } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "CFAMNOM", "FAMILIA + NOMBRE", {|| Field->FAMILIA + Field->NOMBRE }, ) )

      ( dbfArt )->( ordCondSet("!Deleted() .and. lIncTcl", {|| !Deleted() .and. Field->lIncTcl }  ) )
      ( dbfArt )->( ordCreate( cPath + "Articulo.Cdx", "nPosTpv", "Field->Familia + Str( Field->nPosTpv )", {|| Field->Familia + Str( Field->nPosTpv ) } ) )

      ( dbfArt )->( ordCondSet("!Deleted() .and. lIncTcl", {|| !Deleted() .and. Field->lIncTcl }  ) )
      ( dbfArt )->( ordCreate( cPath + "Articulo.Cdx", "nNomTpv", "Field->Familia + Field->NOMBRE ", {|| Field->Familia + Field->NOMBRE } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "FAMILIA", "FAMILIA", {|| Field->FAMILIA }, ) )

      ( dbfArt )->( ordCondSet("!Deleted() .and. lIncTcl .and. nPosTpv != 0", {|| !Deleted() .and. Field->lIncTcl .and. Field->nPosTpv != 0 }, , , , , , , , , .t. ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "NPOSTCL", "NPOSTCL", {|| Field->nPosTcl }, ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "NCTLSTOCK", "NCTLSTOCK", {|| Field->NCTLSTOCK }, ) )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTICULO.CDX", "CodeBar", "Field->CodeBar", {|| Field->CodeBar } ) )

      ( dbfArt )->( ordCondSet( "!Deleted() .and. lPubInt", {|| !Deleted() .and. Field->lPubInt }  ) )
      ( dbfArt )->( ordCreate( cPath + "Articulo.Cdx", "lPubInt", "Codigo", {|| Field->Codigo } ) )

      ( dbfArt )->( ordCondSet( "!Deleted() .and. lPubInt", {|| !Deleted() .and. Field->lPubInt }  ) )
      ( dbfArt )->( ordCreate( cPath + "Articulo.Cdx", "lWebShop", "Field->cWebShop + Field->Codigo", {|| Field->cWebShop + Field->Codigo } ) )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "Articulo.Cdx", "cWebShop", "Field->cWebShop + Field->Codigo", {|| Field->cWebShop + Field->Codigo } ) )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "Articulo.Cdx", "cCodEdi", "cCodEdi", {|| Field->cCodEdi } ) )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "Articulo.Cdx", "cRefAux", "cRefAux", {|| Field->cRefAux } ) )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "Articulo.Cdx", "cRefAux2", "cRefAux2", {|| Field->cRefAux2 } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "Articulo.Cdx", "Matriz", "Matriz", {|| Field->Matriz } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "Articulo.Cdx", "cDesUbi", "cDesUbi", {|| Field->cDesUbi } ) )

      ( dbfArt )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )

   end if

   /*
   Articulos proveedores-------------------------------------------------------
   */

   dbUseArea( .t., cDriver, cPath + "PROVART.Dbf", cCheckArea( "PROVART", @dbfArt ), .f. )

   if !( dbfArt )->( neterr() )

      ( dbfArt )->( __dbPack() )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "PROVART.CDX", "cCodArt", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "PROVART.CDX", "cCodPrv", "cCodPrv + cCodArt", {|| Field->CCODPRV + Field->cCodArt } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "PROVART.CDX", "cRefPrv", "cCodPrv + cRefPrv", {|| Field->CCODPRV + Field->CREFPRV } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "PROVART.CDX", "cRefArt", "cCodArt + cCodPrv + cRefPrv", {|| Field->cCodArt + Field->cCodPrv + Field->cRefPrv } ) )

      ( dbfArt )->( ordCondSet("!Deleted() .and. lDefPrv", {|| !Deleted() .and. Field->lDefPrv } ) )
      ( dbfArt )->( ordCreate( cPath + "PROVART.CDX", "lDefPrv", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfArt )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )

   end if

   /*
   Articulos lenguajes---------------------------------------------------------
   */

   dbUseArea( .t., cDriver, cPath + "ARTLENG.Dbf", cCheckArea( "ARTLENG", @dbfArt ), .f. )

   if !( dbfArt )->( neterr() )

      ( dbfArt )->( __dbPack() )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "ARTLENG.CDX", "cCodArt", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "ARTLENG.CDX", "CARTLEN", "cCodArt + CCODLEN", {|| Field->cCodArt + Field->CCODLEN } ) )

      ( dbfArt )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )

   end if

	/*
	Indice de precios en divisas_______________________________________________
	*/

   dbUseArea( .t., cDriver, cPath + "ARTDIV.Dbf", cCheckArea( "ARTDIV", @dbfArt ), .f. )

   if !( dbfArt )->( neterr() )
      ( dbfArt )->( __dbPack() )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "ArtDiv.Cdx", "cCodArt", "cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2", {|| Field->cCodArt + Field->cCodPr1 + Field->cCodPr2 + Field->cValPr1 + Field->cValPr2 } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "ArtDiv.Cdx", "cValPrp", "cCodArt + cValPr1 + cValPr2", {|| Field->cCodArt + Field->cValPr1 + Field->cValPr2 } ) )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "ArtDiv.Cdx", "cCodigo", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfArt )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )
   end if

	/*
   Articulos Kit_______________________________________________________________
   */

   dbUseArea( .t., cDriver, cPath + "ARTKIT.Dbf", cCheckArea( "ARTKIT", @dbfArt ), .f. )
   if !( dbfArt )->( neterr() )
      ( dbfArt )->( __dbPack() )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ARTKIT.CDX", "CCODKIT", "CCODKIT", {|| Field->CCODKIT } ) )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "ARTKIT.CDX", "CCODREF", "CCODKIT + cRefKit", {|| Field->CCODKIT + Field->cRefKit } ) )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "ARTKIT.CDX", "cRefKit", "cRefKit", {|| Field->cRefKit } ) )

      ( dbfArt )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )
   end if

   /*
   Codigos de barras___________________________________________________________
	*/

   dbUseArea( .t., cDriver, cPath + "ArtCodebar.Dbf", cCheckArea( "ARTICULO", @dbfArt ), .f. )

   if !( dbfArt )->( neterr() )

      ( dbfArt )->( __dbPack() )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ArtCodebar.Cdx", "cCodArt", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ArtCodebar.Cdx", "cCodBar", "cCodBar", {|| Field->cCodBar } ) )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ArtCodebar.Cdx", "cArtBar", "cCodArt + cCodBar", {|| Field->cCodArt + Field->cCodBar } ) )

      ( dbfArt )->( ordCondSet( "!Deleted() .and. lDefBar", {|| !Deleted() .and. Field->lDefBar }  ) )
      ( dbfArt )->( ordCreate( cPath + "ArtCodebar.Cdx", "cDefArt", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfArt )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de codigos de barras" )

   end if

   /*
   Indice de unidades para etiquetas___________________________________________
	*/

   dbUseArea( .t., cDriver, cPath + "ArtLbl.Dbf", cCheckArea( "ArtLbl", @dbfArt ), .f. )

   if !( dbfArt )->( neterr() )
      ( dbfArt )->( __dbPack() )

      ( dbfArt )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "ArtLbl.Cdx", "cCodArt", "cCodArt + cCodPr1 + cCodPr2 + cValpr1 + cValPr2", {|| Field->cCodArt + Field->cCodPr1 + Field->cCodPr2 + Field->cValpr1 + Field->cValPr2 } ) )

      ( dbfArt )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )
   end if

   /*
   Indice de unidades para imagenes___________________________________________
	*/

   dbUseArea( .t., cDriver, cPath + "ArtImg.Dbf", cCheckArea( "ArtImg", @dbfArt ), .f. )

   if !( dbfArt )->( neterr() )
      ( dbfArt )->( __dbPack() )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfArt )->( ordCreate( cPath + "ArtImg.Cdx", "cCodArt", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfArt )->( ordCondSet( "!Deleted() .and. lDefImg", {|| !Deleted() .and. Field->lDefImg } ) )
      ( dbfArt )->( ordCreate( cPath + "ArtImg.Cdx", "lDefImg", "cCodArt", {|| Field->cCodArt } ) )

      ( dbfArt )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )
   end if

   /*
   Articulos Kit_______________________________________________________________
   */

   dbUseArea( .t., cDriver, cPath + "ArtAlm.Dbf", cCheckArea( "ArtAlm", @dbfArt ), .f. )
   if !( dbfArt )->( neterr() )
      ( dbfArt )->( __dbPack() )

      ( dbfArt )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfArt )->( ordCreate( cPath + "ArtAlm.Cdx", "cCodArt + cCodAlm", "cCodArt + cCodAlm", {|| Field->cCodArt + Field->cCodAlm } ) )

      ( dbfArt )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de artículos" )
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de artículos" )

      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

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
   aAdd( aBase, { "lBnf2",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 2","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf3",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 3","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf4",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 4","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf5",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 5","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf6",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 6","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Benef1",    "N",  6, 2, "Porcentaje de beneficio precio 1" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Benef2",    "N",  6, 2, "Porcentaje de beneficio precio 2" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Benef3",    "N",  6, 2, "Porcentaje de beneficio precio 3" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Benef4",    "N",  6, 2, "Porcentaje de beneficio precio 4" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Benef5",    "N",  6, 2, "Porcentaje de beneficio precio 5" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Benef6",    "N",  6, 2, "Porcentaje de beneficio precio 6" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nBnfSbr1",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 1","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nBnfSbr2",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 2","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nBnfSbr3",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 3","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nBnfSbr4",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 4","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nBnfSbr5",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 5","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nBnfSbr6",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 6","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pVenta1",   "N", 15, 6, "Precio de venta precio 1" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pVenta2",   "N", 15, 6, "Precio de venta precio 2" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pVenta3",   "N", 15, 6, "Precio de venta precio 3" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pVenta4",   "N", 15, 6, "Precio de venta precio 4" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pVenta5",   "N", 15, 6, "Precio de venta precio 5" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pVenta6",   "N", 15, 6, "Precio de venta precio 6" ,               "PicOut()",           "", "( cDbfArt )", nil } )
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
   aAdd( aBase, { "CCTAVTADEV","C", 12, 0, "Código de la cuenta de ventas en devoluciones" ,    "",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTACOMDEV","C", 12, 0, "Código de la cuenta de compras en devoluciones" ,   "",         "", "( cDbfArt )", nil } )
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
   aAdd( aBase, { "cImagen",   "C",250, 0, "Fichero de imagen" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lSndDoc",   "L",  1, 0, "Lógico para envios" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUsr",   "C",  3, 0, "Código de usuario que realiza el cambio" ,"",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFecChg",   "D",  8, 0, "Fecha de cambio" ,                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTimChg",   "C",  5, 0, "Hora de cambio" ,                         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFecLgt",   "D",  8, 0, "Fecha de logística" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lKitArt",   "L",  1, 0, "Lógico de escandallos" ,                  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lKitAsc",   "L",  1, 0, "Lógico de asociado" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitImp",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitStk",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitPrc",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lAutSer",   "L",  1, 0, "Lógico de autoserializar" ,               "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lObs",      "L",  1, 0, "Lógico de obsoleto" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LNUMSER",   "L",  1, 0, "Lógico solicitar numero de serie" ,       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CPRVHAB",   "C", 12, 0, "Proveedor habitual" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LFACCNV",   "L",  1, 0, "Usar factor de conversión" ,              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CFACCNV",   "C",  2, 0, "Código del factor de conversión" ,        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTNK",   "C",  3, 0, "Código del tanque de combustible" ,       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTIP",   "C",  4, 0, "Código del tipo de artículo" ,            "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LTIPACC",   "L",  1, 0, "Lógico de acceso por unidades o importe", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LCOMBUS",   "L",  1, 0, "Lógico si el artículo es del tipo combustible", "",             "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODIMP",   "C",  3, 0, "Código del impuesto especiales",          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LMSGVTA",   "L",  1, 0, "Lógico para avisar en venta sin stock",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LNOTVTA",   "L",  1, 0, "Lógico para no permitir venta sin stock", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLOTE",     "N",  9, 0, "",                                        "'999999999'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cLote",     "C", 14, 0, "Número de lote",                          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LLOTE",     "L",  1, 0, "Lote (S/N)",                              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBINT",   "L",  1, 0, "Lógico para publicar en internet (S/N)",  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBOFE",   "L",  1, 0, "Lógico para publicar como oferta (S/N)",  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBPOR",   "L",  1, 0, "Lógico para publicar como artículo destacado (S/N)",  "",       "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT1",  "N", 10, 6, "Descuento de oferta para tienda web 1",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT1",  "N", 15, 6, "Precio del producto en oferta 1",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA1",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 1", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT2",  "N", 10, 6, "Descuento de oferta para tienda web 2",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT2",  "N", 15, 6, "Precio del producto en oferta 2",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA2",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 2", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT3",  "N", 10, 6, "Descuento de oferta para tienda web 3",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT3",  "N", 15, 6, "Precio del producto en oferta 3",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA3",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 3", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT4",  "N", 10, 6, "Descuento de oferta para tienda web 4",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT4",  "N", 15, 6, "Precio del producto en oferta 4",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA4",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 4", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT5",  "N", 10, 6, "Descuento de oferta para tienda web 5",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT5",  "N", 15, 6, "Precio del producto en oferta 5",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA5",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 5", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT6",  "N", 10, 6, "Descuento de oferta para tienda web 6",   "",                   "", "( cDbfArt )", nil } )
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
   aAdd( aBase, { "CCODCATE",  "C", 10, 0, "Código de categoría",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTEMP",  "C", 10, 0, "Código de la temporada",                   "",                  "", "( cDbfArt )", nil } )
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
   aAdd( aBase, { "cDesUbi",   "C",200, 0, "Ubicación",                                "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFecVta",   "D",  8, 0, "Fecha de puesta a la venta",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFinVta",   "D",  8, 0, "Fecha de fin de la venta",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMsgSer",   "L",  1, 0, "Avisar en ventas por series sin stock",    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPrp1",  "C", 20, 0, "Valor de la primera propiedad",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPrp2",  "C", 20, 0, "Valor de la segunda propiedad",            "",                  "", "( cDbfArt )", nil } )
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
   aAdd( aBase, { "cCodEst",   "C",  3, 0, "Estado del artículo",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodEdi",   "C", 20, 0, "Código normalizado del artículo",          "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefAux",   "C", 18, 0, "Referencia auxiliar",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefAux2",  "C", 18, 0, "Referencia auxiliar 2",                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Matriz",    "C", 18, 0, "Matriz para código de barras" ,            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nStkCal",   "N", 16, 6, "Stock calculado" ,                         "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc2",  "L",  1, 0, "Iva incluido para el precio 2" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc3",  "L",  1, 0, "Iva incluido para el precio 3" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc4",  "L",  1, 0, "Iva incluido para el precio 4" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc5",  "L",  1, 0, "Iva incluido para el precio 5" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc6",  "L",  1, 0, "Iva incluido para el precio 6" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaPver",  "L",  1, 0, "Iva incluido para el punto verde" ,        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cWebShop",  "C",100, 0, "Tienda web donde se publica el producto",  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaWeb",   "L",  1, 0, "Iva incluido para precio web" ,            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cEtiqueta", "M", 10, 0, "Relación de etiquetas" ,                   "",                  "", "( cDbfArt )", nil } )

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
   aAdd( aBase, { "cUnidad",   "C",  2, 0, "Unidad de medición"                  , "",                  "", "( cDbfArt )", nil } )
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
   aAdd( aBase, { "cValPr1",   "C", 20, 0, "Valor de primera propiedad",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr2",   "C", 20, 0, "Valor de segunda propiedad",               "",                  "", "( cDbfArt )", nil } )
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
   aAdd( aBase, { "mImgWeb",   "M", 10, 0, "Imágenes por propiedad"                  , "",                  "", "( cDbfArt )", 0 } )

Return ( aBase )

//---------------------------------------------------------------------------//

Function aItmArtPrv()

   local aBase := {}

   aAdd( aBase, { "cCodArt",   "C", 18, 0, "Código del artículo referenciado"  , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPrv",   "C", 12, 0, "Código del proveedor"              , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefPrv",   "C", 60, 0, "Referencia del proveedor al artículo" , "",               "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoPrv",   "N",  6, 2, "Descuento del proveedor"           , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoPrm",   "N",  6, 2, "Descuento por promoción"           , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDivPrv",   "C",  3, 0, "Código de la divisa"               , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nImpPrv",   "N", 19, 6, "Importe de compra"                 , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lDefPrv",   "L",  1, 0, "Lógico de proveedor por defecto"   , "",                  "", "( cDbfArt )", nil } )

Return ( aBase )

//---------------------------------------------------------------------------//

Function aItmArtLeng()

   local aBase := {}

   aAdd( aBase, { "cCodArt",   "C", 18, 0, "Código del artículo", "",   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodLen",   "C",  4, 0, "Código del lenguaje", "",   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesTik",   "C",200, 0, "Descripción corta",   "",   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesArt",   "M", 10, 0, "Descripción larga",   "",   "", "( cDbfArt )", nil } )

Return ( aBase )

//---------------------------------------------------------------------------//

Function aItmLbl()

   local aBase := {}

   aAdd( aBase, { "cCodArt",   "C", 18, 0, "Código de artículo",                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPr1",   "C", 20, 0, "Código de primera propiedad",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPr2",   "C", 20, 0, "Código de segunda propiedad",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr1",   "C", 20, 0, "Valor de primera propiedad",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr2",   "C", 20, 0, "Valor de segunda propiedad",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nUndLbl",   "N", 16, 6, "Precio de compras",                        "",                  "", "( cDbfArt )", nil } )

Return ( aBase )

//---------------------------------------------------------------------------//

Function aItmImg()

   local aBase := {}

   aAdd( aBase, { "cCodArt",  "C",  18, 0, "Código del artículo",                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nId",      "N",  10, 0, "Identificador de la imagen",              "",                  "", "( cDbfArt )", 0 } )
   aAdd( aBase, { "cImgArt",  "C", 230, 0, "Imagen del artículo en local",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cNbrArt",  "C", 230, 0, "Nombre de la imagen",                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cHtmArt",  "M",  10, 0, "HTML de la imagen",                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodWeb",  "N",  11, 0, "Código de artículo para la web",          "",                  "", "( cDbfArt )", 0 } )
   aAdd( aBase, { "lDefImg",  "L",   1, 0, "Lógico para imágen por defecto",          "",                  "", "( cDbfArt )", .f. } )
   aAdd( aBase, { "cRmtArt",  "M",  10, 0, "Memo imagen del artículo en remoto",      "",                  "", "( cDbfArt )", nil } )

Return ( aBase )

//---------------------------------------------------------------------------//

Static Function aItmCom()

   local aBase := {}

   aAdd( aBase, { "cCodArt",   "C", 18, 0, "Código de artículo"            , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodDiv",   "C",  3, 0, "Código de divisa"              , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPr1",   "C", 20, 0, "Código de primera propiedad"   , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPr2",   "C", 20, 0, "Código de segunda propiedad"   , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr1",   "C", 20, 0, "Valor de primera propiedad"    , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPr2",   "C", 20, 0, "Valor de segunda propiedad"    , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreCom",   "N", 16, 6, "Precio de compras"             , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nValPnt",   "N", 16, 6, "Valor del punto"               , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoPnt",   "N",  6, 2, "Descuento del punto"           , "",                  "", "( cDbfArt )", nil } )

Return ( aBase )

//---------------------------------------------------------------------------//

Function aItmStockaAlmacenes()

   local aBase := {}

   aAdd( aBase, { "cCodArt",   "C", 18, 0, "Código de artículo"            , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodAlm",   "C", 16, 0, "Código de almacen"             , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nStkMin",   "N", 16, 6, "Stock mínimo por almacen"      , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nStkMax",   "N", 16, 6, "Stock maximo por almacen"      , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cUbica",    "C", 60, 0, "Ubicación de almacén"          , "",                  "", "( cDbfArt )", nil } )

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

Function nRetPreArt( nTarifa, cCodDiv, lIvaInc, dbfArt, dbfDiv, dbfArtKit, dbfIva, lBuscaImportes, oTarifa, oNewImp )

   local nIva
   local oError
   local oBlock
   local nPrecioBase          := 0
   local nPrecioIvaIncluido   := 0
   local nPrecioCosto         := nil

   DEFAULT nTarifa            := 1
   DEFAULT lIvaInc            := .f.
   DEFAULT lBuscaImportes     := lBuscaImportes()

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if nTarifa == 0
      nTarifa                 := 1
   end if

   while .t.

      if ( dbfArt )->lKitArt

         nIva                 := nIva( dbfIva, ( dbfArt )->TipoIva )

         do case
            case nTarifa == 1
               if ( dbfArt )->lBnf1
                  if empty( nPrecioCosto)
                  nPrecioCosto         := nCosto( nil, dbfArt, dbfArtKit )
                  end if
                  nPrecioBase          := ( nPrecioCosto * ( dbfArt )->Benef1 / 100 ) + nPrecioCosto
                  nPrecioIvaIncluido   := ( nPrecioBase * nIva / 100 ) + nPrecioBase
               else
                  nPrecioIvaIncluido   := ( dbfArt )->pVtaIva1
                  nPrecioBase          := ( dbfArt )->pVenta1
               end if

            case nTarifa == 2
               if ( dbfArt )->lBnf2
                  if empty( nPrecioCosto)
                  nPrecioCosto         := nCosto( nil, dbfArt, dbfArtKit )
                  end if
                  nPrecioBase          := ( nPrecioCosto * ( dbfArt )->Benef2 / 100 ) + nPrecioCosto
                  nPrecioIvaIncluido   := ( nPrecioBase * nIva / 100 ) + nPrecioBase
               else
                  nPrecioIvaIncluido   := ( dbfArt )->pVtaIva2
                  nPrecioBase          := ( dbfArt )->Pventa2
               end if

            case nTarifa == 3
               if ( dbfArt )->lBnf3
                  if empty( nPrecioCosto)
                  nPrecioCosto         := nCosto( nil, dbfArt, dbfArtKit )
                  end if
                  nPrecioBase          := ( nPrecioCosto * ( dbfArt )->Benef3 / 100 ) + nPrecioCosto
                  nPrecioIvaIncluido   := ( nPrecioBase * nIva / 100 ) + nPrecioBase
               else
                  nPrecioIvaIncluido   := ( dbfArt )->pVtaIva3
                  nPrecioBase          := ( dbfArt )->Pventa3
               end if

            case nTarifa == 4
               if ( dbfArt )->lBnf4
                  if empty( nPrecioCosto)
                  nPrecioCosto         := nCosto( nil, dbfArt, dbfArtKit )
                  end if
                  nPrecioBase          := ( nPrecioCosto * ( dbfArt )->Benef4 / 100 ) + nPrecioCosto
                  nPrecioIvaIncluido   := ( nPrecioBase * nIva / 100 ) + nPrecioBase
               else
                  nPrecioIvaIncluido   := ( dbfArt )->pVtaIva4
                  nPrecioBase          := ( dbfArt )->Pventa4
               end if

            case nTarifa == 5
               if ( dbfArt )->lBnf5
                  if empty( nPrecioCosto)
                  nPrecioCosto         := nCosto( nil, dbfArt, dbfArtKit )
                  end if
                  nPrecioBase          := ( nPrecioCosto * ( dbfArt )->Benef5 / 100 ) + nPrecioCosto
                  nPrecioIvaIncluido   := ( nPrecioBase * nIva / 100 ) + nPrecioBase
               else
                  nPrecioIvaIncluido   := ( dbfArt )->pVtaIva5
                  nPrecioBase          := ( dbfArt )->Pventa5
               end if

            case nTarifa == 6
               if ( dbfArt )->lBnf6
                  if empty( nPrecioCosto)
                  nPrecioCosto         := nCosto( nil, dbfArt, dbfArtKit )
                  end if
                  nPrecioBase          := ( nPrecioCosto * ( dbfArt )->Benef6 / 100 ) + nPrecioCosto
                  nPrecioIvaIncluido   := ( nPrecioBase * nIva / 100 ) + nPrecioBase
               else
                  nPrecioIvaIncluido   := ( dbfArt )->pVtaIva6
                  nPrecioBase          := ( dbfArt )->Pventa6
               end if

         end do

      else

         do case
            case nTarifa == 1
               nPrecioBase          := ( dbfArt )->pVenta1
               nPrecioIvaIncluido   := ( dbfArt )->pVtaIva1
            case nTarifa == 2
               nPrecioBase          := ( dbfArt )->pVenta2
               nPrecioIvaIncluido   := ( dbfArt )->pVtaIva2
            case nTarifa == 3
               nPrecioBase          := ( dbfArt )->pVenta3
               nPrecioIvaIncluido   := ( dbfArt )->pVtaIva3
            case nTarifa == 4
               nPrecioBase          := ( dbfArt )->pVenta4
               nPrecioIvaIncluido   := ( dbfArt )->pVtaIva4
            case nTarifa == 5
               nPrecioBase          := ( dbfArt )->pVenta5
               nPrecioIvaIncluido   := ( dbfArt )->pVtaIva5
            case nTarifa == 6
               nPrecioBase          := ( dbfArt )->pVenta6
               nPrecioIvaIncluido   := ( dbfArt )->pVtaIva6
         end do

      end if

      if ( nPrecioBase== 0 .or. nPrecioIvaIncluido == 0 ) .and. nTarifa > 1 .and. lBuscaImportes
         nTarifa--
         loop
      else
         exit
      end if

   end while

   // Restar el importe del impuesto especial si nos los piden con iva includio
   // Si nos piden el precio con impuestos incluidos, no le restamos el impuesto especial

   if oTarifa != nil
      oTarifa:cText( nTarifa )
   end if

   nPrecioIvaIncluido   := Round( nPrecioIvaIncluido, nDouDiv() )
   nPrecioBase          := Round( nPrecioBase, nDouDiv() )

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( if( lIvaInc, nPrecioIvaIncluido, nPrecioBase) )

//---------------------------------------------------------------------------//

Function nCosto( uTmp, dbfArt, dbfArtKit, lPic, cDivRet, dbfDiv )

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

   nOrdArt           := ( dbfArt )->( OrdSetFocus( "Codigo" ) )
   nRecArt           := ( dbfArt )->( Recno() )
   nOrdKit           := ( dbfArtKit   )->( OrdSetFocus( "cCodKit" ) )
   nRecKit           := ( dbfArtKit   )->( Recno() )

   do case
      case IsArray( uTmp )
         cCodArt     := uTmp[ ( dbfArt )->( fieldpos( "Codigo"  ) ) ]
         lKitArt     := uTmp[ ( dbfArt )->( fieldpos( "lKitArt" ) ) ] .and. !uTmp[ ( dbfArt )->( fieldpos( "lKitAsc" ) ) ]
      case IsChar( uTmp ) .and. ( dbfArt )->( dbSeek( uTmp ) )
         cCodArt     := ( dbfArt )->Codigo
         lKitArt     := ( dbfArt )->lKitArt .and. !( dbfArt )->lKitAsc
      case empty( uTmp )
         cCodArt     := ( dbfArt )->Codigo
         lKitArt     := ( dbfArt )->lKitArt .and. !( dbfArt )->lKitAsc
   end case

   if lKitArt

      if ( dbfArtKit )->( dbSeek( cCodArt ) )
         while ( dbfArtKit )->cCodKit == cCodArt .and. !( dbfArtKit )->( eof() )
            nCosto   += nCosto( ( dbfArtKit )->cRefKit, dbfArt, dbfArtKit ) * ( dbfArtKit )->nUndKit // * nFactorConversion( ( dbfArtKit )->cRefKit ) 
            ( dbfArtKit )->( dbSkip() )
         end while
      end if

   else

      nCosto         += pCosto( dbfArt )

   end if

   ( dbfArt )->( OrdSetFocus( nOrdArt ) )
   ( dbfArt )->( dbGoTo( nRecArt ) )
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

Function pCosto( dbfArt, lPic, cDivRet, dbfDiv, lFacCnv )

   local nCosto      := 0

   DEFAULT lPic      := .f.
   DEFAULT lFacCnv   := .t.

   nCosto            := ( dbfArt )->pCosto
/*
   if ( dbfArt )->lFacCnv .and. ( dbfArt )->nFacCnv != 0
      nCosto         *= ( dbfArt )->nFacCnv
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

Static Function nFactorConversion( cCodArt )

Return ( NotCero( RetFld( cCodArt, D():Articulos( nView ), "nFacCnv" ) ) )

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

function saveLoteActual( cCodArt, cLote, nView )

   local nOrdSetFocus   := ( D():Articulos( nView ) )->( ordSetFocus( "Codigo" ) )

   /*
   Actualizar NLOTE en el Fichero de artículos
   ----------------------------------------------------------------------------
   */

   if ( D():Articulos( nView ) )->( dbSeek( cCodArt ) )
      if ( D():Articulos( nView ) )->( dbRLock() )
         ( D():Articulos( nView ) )->cLote  := cLote
         ( D():Articulos( nView ) )->( dbRUnLock() )
      end if
   end if

   ( D():Articulos( nView ) )->( ordSetFocus( nOrdSetFocus ) )

RETURN NIL
//---------------------------------------------------------------------------//

function saveContadorActual( cCodArt, nCntAct, nView )

   local nOrdSetFocus   := ( D():Articulos( nView ) )->( ordSetFocus( "Codigo" ) )

   /*
   Actualizar NLOTE en el Fichero de artículos
   ----------------------------------------------------------------------------
   */

   if ( D():Articulos( nView ) )->( dbSeek( cCodArt ) )
      if ( D():Articulos( nView ) )->( dbRLock() )
         ( D():Articulos( nView ) )->nCntAct  := nCntAct
         ( D():Articulos( nView ) )->( dbRUnLock() )
      end if
   end if

   ( D():Articulos( nView ) )->( ordSetFocus( nOrdSetFocus ) )

Return nil

//---------------------------------------------------------------------------//

Function lAccArticulo()

Return ( nAnd( nLevelUsr( "01014" ), 1 ) == 0 )

//---------------------------------------------------------------------------//

Function BrwArticulo( oGetCodigo, oGetNombre, lCodeBar, lAppend, oBtn, oGetLote, oGetCodPrp1, oGetCodPrp2, oGetValPrp1, oGetValPrp2, oGetFecCad, cCodAlm )

   if !IsPda() .and. !IsReport()
      if IsObject( oUser() ) .and. oUser():lSelectorFamilia()
         Return ( BrwFamiliaArticulo( oGetCodigo, oGetNombre, lCodeBar, lAppend ) )
      end if
   end if

Return ( BrwSelArticulo( oGetCodigo, oGetNombre, lCodeBar, lAppend, nil, oBtn, oGetLote, oGetCodPrp1, oGetCodPrp2, oGetValPrp1, oGetValPrp2, oGetFecCad, cCodAlm ) )

//---------------------------------------------------------------------------//

Function BrwSelArticulo( oGetCodigo, oGetNombre, lCodeBar, lAppend, lEdit, oBtnSaveLine, oGetLote, oGetCodPrp1, oGetCodPrp2, oGetValPrp1, oGetValPrp2, oGetFecCad, cCodAlm )

   local oDlg
   local oBmp
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

      nRecAnt           := ( D():Articulos( nView ) )->( Recno() )

   end if

   if !empty( oGetCodigo )
      cTxtOrigen        := oGetCodigo:VarGet()
   end if

   /*
   Origen de busqueda----------------------------------------------------------
   */

   if !empty( cTxtOrigen ) .and. !( D():Articulos( nView ) )->( dbSeek( cTxtOrigen ) )
      ( D():Articulos( nView ) )->( OrdSetFocus( Ordenes[ nOrd ] ) )
      ( D():Articulos( nView ) )->( dbGoTop() )
   else
      ( D():Articulos( nView ) )->( OrdSetFocus( Ordenes[ nOrd ] ) )
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

      REDEFINE BITMAP oBmp ;
         ID       600 ;
         RESOURCE "gc_object_cube_48" ;
         TRANSPARENT ;
         OF       oDlg

   end if

		REDEFINE GET aGet1 VAR cGet1;
			ID 		   104 ;
			PICTURE	   "@!" ;
         ON CHANGE   ( SpecialSeek( nKey, nFlags, aGet1, oBrw, oCbxOrd, dbfCodebar ) );
         VALID       ( OrdClearScope( oBrw, D():Articulos( nView ) ) );
			OF 		   oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		   cCbxOrd ;
			ID 		   102 ;
         ITEMS       aCbxOrd ;
         ON CHANGE   ( ( D():Articulos( nView ))->( OrdSetFocus( Ordenes[ oCbxOrd:nAt ] ) ), ( D():Articulos( nView ) )->( dbGoTop() ), oBrw:refresh(), aGet1:SetFocus(), oCbxOrd:refresh() ) ;
         OF          oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := D():Articulos( nView )
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
         :bEditValue       := {|| if( lCodeBar, ( D():Articulos( nView ) )->CodeBar, ( D():Articulos( nView ) )->Codigo ) }
         :nWidth           := 90
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "NomObs"
         :bEditValue       := {|| ( D():Articulos( nView ) )->Nombre }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| AllTrim( oRetFld( ( D():Articulos( nView ) )->cCodTip, oTipart:oDbf ) ) }
         :nWidth           := 150
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Proveedor"
         :bEditValue       := {|| if( !empty( ( D():Articulos( nView ) )->cPrvHab ), AllTrim( ( D():Articulos( nView ) )->cPrvHab ) + " - " + RetProvee( ( D():Articulos( nView ) )->cPrvHab, dbfProv ), "" ) }
         :nWidth           := 220
         :lHide            := .t.
         :cSortOrder       := "cPrvHab"
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), aGet1:SetFocus() }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" ) + " " + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 1, nil, .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 2, nil, .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" ) + " " + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 2, nil, .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 3, nil, .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" ) + " " + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 3, nil, .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 4, nil, .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" ) + " " + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 4, nil, .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 5, nil, .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" ) + " " + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 5, nil, .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" )
         :bStrData         := {|| TransPrecio( nRetPreArt( 6, nil, .f., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" ) + " " + cImp() + " inc."
         :bStrData         := {|| TransPrecio( nRetPreArt( 6, nil, .t., D():Articulos( nView ), dbfDiv, dbfArtKit, D():TiposIva( nView ) ), lEuro ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      if ( oUser():lCostos() )

      with object ( oBrw:AddCol() )
         :cHeader          := "Costo"
         :bStrData         := {|| nCosto( nil, D():Articulos( nView ), dbfArtKit, .t., if( lEuro, cDivChg(), cDivEmp() ), dbfDiv ) }
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      end if

      oDetCamposExtra:addCamposExtra( oBrw )

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      if !IsReport() .and. !uFieldEmpresa( "lNStkAct" )
         oBrw:bChange      := {|| ChangeBrwArt( oBrwStock, oBmpImage, oBrw, cCodAlm ) }
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
               :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cCodigoAlmacen, "" ) }
               :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | cOrdenColumnaBrw( oCol, oBrwStock ) }
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Almacén"
               :nWidth              := 120
               :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), RetAlmacen( oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cCodigoAlmacen, dbfAlmT ), "" ) }
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Prop. 1"
               :nWidth              := 40
               :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cValorPropiedad1, "" ) }
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Prop. 2"
               :nWidth              := 40
               :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cValorPropiedad2, "" ) }
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Lote"
               :nWidth              := 60
               :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cLote, "" ) }
               :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | cOrdenColumnaBrw( oCol, oBrwStock ) }
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Caducidad"
               :nWidth              := 60
               :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:dFechaCaducidad, "" ) }
               :lHide               := .t.
               :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | cOrdenColumnaBrw( oCol, oBrwStock ) }
            end with

            /*with object ( oBrwStock:AddCol() )
               :cHeader             := "Num. serie"
               :nWidth              := 60
               :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cNumeroSerie, "" ) }
               :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | cOrdenColumnaBrw( oCol, oBrwStock ) }
            end with*/

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Unidades"
               :nWidth              := 80
               :bEditValue          := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nUnidades, 0 ) }
               :bFooter             := {|| nStockUnidades( oBrwStock ) }
               :cEditPicture        := MasUnd()
               :nDataStrAlign       := AL_RIGHT
               :nHeadStrAlign       := AL_RIGHT
               :nFootStrAlign       := AL_RIGHT
               :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | cOrdenColumnaBrw( oCol, oBrwStock ) }
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Pdt. recibir"
               :bEditValue          := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nPendientesRecibir, 0 ) }
               :bFooter             := {|| nStockPendiente( oBrwStock ) }
               :nWidth              := 70
               :cEditPicture        := cPicUnd
               :nDataStrAlign       := AL_RIGHT
               :nHeadStrAlign       := AL_RIGHT
               :nFootStrAlign       := AL_RIGHT
            end with

            with object ( oBrwStock:AddCol() )
               :cHeader             := "Pdt. entregar"
               :bEditValue          := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nPendientesEntregar, 0 ) }
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
         ACTION   ( lPropiedades   := .t., if( lPresaveBrwSelArticulo( oBrwStock, ( D():Articulos( nView ) )->lMsgVta ), oDlg:end( IDOK ), ) )

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
         ACTION   ( WinAppRec( oBrw, bEdit, D():Articulos( nView ) ) )

   if !IsReport()

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. lAppend .and. !IsReport() );
         ACTION   ( WinDupRec( oBrw, bEdit, D():Articulos( nView ) ) )

         if lAppend
            oDlg:AddFastKey( VK_F2, {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, D():Articulos( nView ) ), ) } )
         end if

   end if

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. lEdit .and. !IsReport() );
         ACTION   ( WinEdtRec( oBrw, bEdit, D():Articulos( nView ) ) )

         if lEdit .and. !IsReport()
            oDlg:AddFastKey( VK_F3, {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, D():Articulos( nView ) ), ) } )
         end if

      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F6,       {|| lPropiedades   := .t., if( lPresaveBrwSelArticulo( oBrwStock, ( D():Articulos( nView ) )->lMsgVta ), oDlg:end( IDOK ), ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

      oDlg:bStart       := {|| StartBrwSelArticulo( oGetLote, oBrw, oBrwStock, oBtnAceptarpropiedades, oBmpImage, cCodAlm ) }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      if lCodeBar
         cReturn        := ( D():Articulos( nView ) )->CodeBar
      else
         cReturn        := ( D():Articulos( nView ) )->Codigo
      end if

      if !empty( oGetCodigo )
         oGetCodigo:cText( Padr( cReturn, 200 ) )
      end if

      if !empty( oGetNombre )
         oGetNombre:cText( ( D():Articulos( nView ) )->Nombre )
      end if

      if !empty( oBrwStock )              .and.;
         lPropiedades                     .and.;
         Len(oBrwStock:aArrayData) != 0

         if !empty( oGetLote )
            oGetLote:cText( oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cLote )
            oGetLote:lValid()
            oGetLote:Refresh()
         end if

         if !empty( oGetCodPrp1 )
            oGetCodPrp1 := oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cCodigoPropiedad1
         end if

         if !empty( oGetCodPrp2 )
            oGetCodPrp2 := oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cCodigoPropiedad2
         end if

         if !empty( oGetValPrp1 )
            oGetValPrp1:cText( oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cValorPropiedad1 )
            oGetValPrp1:lValid()
            oGetValPrp1:SetFocus()
         end if

         if !empty( oGetValPrp2 )
            oGetValPrp2:cText( oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cValorPropiedad2 )
            oGetValPrp2:lValid()
            oGetValPrp2:SetFocus()
         end if

         if !empty( oGetFecCad )
            oGetFecCad:cText( oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:dFechaCaducidad )
         end if

      end if

   end if

   DestroyFastFilter( D():Articulos( nView ) )

   SetBrwOpt( "BrwArticulo", if( ( D():Articulos( nView ) )->( OrdSetFocus() ) == "CODOBS", 1, 2 ) )

   if !empty( oBrw )
      oBrw:CloseData()
   end if

   if !empty( oBrwStock )
      oBrwStock:CloseData()
   end if

   if lCloseFiles
      CloseFiles()
   else
      ( D():Articulos( nView ) )->( dbGoTo( nRecAnt ) )
   end if

   if oBmpImage != nil
      oBmpImage:End()
   end if

   if !empty( oGetCodigo )
      oGetCodigo:SetFocus()
   end if

   if !empty( oBmp )
      oBmp:End()
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//

static function lPresaveBrwSelArticulo( oBrwStock, lMsgVta )

   if lMsgVta .and. ( oBrwStock:nArrayAt > 0 ) .and. ( len( oBrwStock:aArrayData ) > oBrwStock:nArrayAt ) .and. oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nUnidades < 0
      msginfo( "No hay stock suficiente para realizar la venta" )
      return .f.
   end if

return .t.

//---------------------------------------------------------------------------//

Static Function StartBrwSelArticulo( oGetLote, oBrw, oBrwStock, oBtnAceptarpropiedades, oBmpImage, cCodAlm )

   if !empty( oBrw )
      oBrw:Load()
   end if

   if !empty( oBrwStock )
      oBrwStock:Load() 
   end if

   if !IsReport()
      LoadBrwArt( oBrwStock, oBmpImage, cCodAlm )
   end if

   if !empty( oBtnAceptarpropiedades )
      if empty( oGetLote )
         oBtnAceptarpropiedades:Hide()
      else
         oBtnAceptarpropiedades:Show()
      end if
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

static function cOrdenColumnaBrw( oCol, oBrwStock )

   local oColumn

   if !empty( oBrwStock )

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
      cReturn     := ( D():Articulos( nView ) )->CodeBar
   else
      cReturn     := ( D():Articulos( nView ) )->Codigo
   end if

   if !empty( oGet )
      oGet:cText( cReturn )
      lOk         := oGet:lOldValid()
   end if

   if lOk .and. !empty( oBtn )
      oBtn:Click()
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//


#ifndef __PDA__

Static Function ChangeBrwArt( oBrwStock, oBmpImage, oBrw, cCodAlm )

   if !empty( oTimerBrw )
      oTimerBrw:End()
      oTimerBrw    := nil
   endif

   oTimerBrw             := TTimer():New( 900, {|| LoadBrwArt( oBrwStock, oBmpImage, cCodAlm ) }, )
   oTimerBrw:hWndOwner   := oBrw:hWnd
   oTimerBrw:Activate()

Return .t.

//---------------------------------------------------------------------------//

Static Function LoadBrwArt( oBrwStock, oBmpImage, cCodAlm )

   local oBlock
   local oError

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !uFieldEmpresa( "lNStkAct" )
         if !empty( oTimerBrw )
            oTimerBrw:End()
            oTimerBrw    := nil
         endif
      end if

      CursorWait()

      /*
      Cargamos la imagen del producto---------------------------------------------
      */

      if oBmpImage != nil
         oBmpImage:LoadBMP( cFileBmpName( ( D():Articulos( nView ) )->cImagen, .t. ) )
         oBmpImage:Refresh()
      end if

      /*
      Calculos de stocks----------------------------------------------------------
      */

      if !uFieldEmpresa( "lNStkAct" ) .and. ( ( D():Articulos( nView ) )->nCtlStock <= 1 )
         oStock:aStockArticulo( ( D():Articulos( nView ) )->Codigo, cCodAlm, oBrwStock )
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

Static Function SpecialSeek( nKey, nFlags, oGet, oBrw, oCbx, dbfCodebar )

   local nRecno
   local xCadena     := ""
   local lResult     := AutoSeek( nKey, nFlags, oGet, oBrw, D():Articulos( nView ), .t. )

   if !lResult

      nRecno         := ( D():Articulos( nView ) )->( Recno() )

#ifndef __HARBOUR__
      xCadena        := Rtrim( SubStr( oGet:varGet(), 0, oGet:nPos - 1 ) + Chr( nKey ) )
#else
      xCadena        := Rtrim( oGet:cText() )
#endif

      if dbSeekInOrd( xCadena, "CodeBar", D():Articulos( nView ) )

         lResult     := .t.

      else

         if dbSeekInOrd( xCadena, "cCodBar", dbfCodeBar )                  .and.;
            dbSeekInOrd( ( dbfCodeBar )->cCodArt, "Codigo", D():Articulos( nView ) )

            lResult  := .t.

         end if

      end if

      if !lResult
         nRecno      := ( D():Articulos( nView ) )->( dbGoTo( nRecno ) )
      end if

   end if

   if lResult
      if !empty( oBrw:bChange )
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
      USE ( cPatArt() + "ARTICULO.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @uArt ) )
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

FUNCTION lStockCompuestos( cCodArt, dbfArt )

   local lTmp     := .f.
   local aSta     := aGetStatus( dbfArt, .t. )

   if ( dbfArt )->( DbSeek( cCodArt ) )
      lTmp        := ( dbfArt )->lKitArt .and. ( dbfArt )->nKitStk <= KIT_COMPUESTO
   end if

   SetStatus( dbfArt, aSta )

RETURN ( lTmp )

//---------------------------------------------------------------------------//

//
// Devuelve si tenemos precios en el compuesto
//

FUNCTION lPreciosCompuestos( cCodArt, dbfArt )

   local lTmp     := .f.
   local aSta     := aGetStatus( dbfArt, .t. )

   if ( dbfArt )->( dbSeek( cCodArt ) )
      lTmp        := ( dbfArt )->lKitArt .and. ( dbfArt )->nKitPrc <= KIT_COMPUESTO
   end if

   SetStatus( dbfArt, aSta )

RETURN ( lTmp )

//---------------------------------------------------------------------------//
//
// Devuelve si se imprime el compuesto
//

FUNCTION lImprimirCompuesto( cCodArt, dbfArt )

   local lTmp     := .f.
   local aSta     := aGetStatus( dbfArt, .t. )

   if ( dbfArt )->( DbSeek( cCodArt ) )
      lTmp        := !( ( dbfArt )->lKitArt .and. ( dbfArt )->nKitImp <= KIT_COMPUESTO )
   end if

   SetStatus( dbfArt, aSta )

RETURN ( lTmp )

//---------------------------------------------------------------------------//
//
// Devuelve el codigo interno pasandole el codigo de barras
//

Function cSeekCodebarView( cCodBar, nView )

Return ( alltrim( cSeekCodebar( cCodBar, D():ArticulosCodigosBarras( nView ), D():Articulos( nView ) ) ) )

//---------------------------------------------------------------------------//

Function cSeekCodebar( cCodBar, dbfCodebar, dbfArt )

   local cSeekCodeBar

   if IsObject( dbfCodebar )
      dbfCodebar              := dbfCodebar:cAlias
   end if

   if IsObject( dbfArt )
      dbfArt                  := dbfArt:cAlias
   end if

   cSeekCodebar               := cSeekInternalCodebar( cCodBar, dbfArt )

   if empty( cSeekCodebar )
      cSeekCodebar            := cSeekExternalCodebar( cCodBar, dbfCodebar, dbfArt )
   end if 

Return ( cSeekCodebar )

//---------------------------------------------------------------------------//

Function cSeekInternalCodebar( cCodigoBarra, dbfArt )

   local cCodigo
   local cPropiedad1
   local cPropiedad2

   cCodigo                    := left( cCodigoBarra, 6 )

   if dbSeekInOrd( cCodigo, "Matriz", dbfArt ) .or. dbSeekInOrd( Upper( cCodigo ), "Matriz", dbfArt )

      cCodigo                 := alltrim( ( dbfArt )->Codigo )
      cPropiedad1             := alltrim( str( val( substr( cCodigoBarra, 7, 3 ) ) ) )
      cPropiedad2             := alltrim( str( val( substr( cCodigoBarra, 10, 3 ) ) ) )

      if !empty(cPropiedad1)
         cCodigo              += "." + cPropiedad1
      end if 

      if !empty(cPropiedad2)
         cCodigo              += "." + cPropiedad2
      end if 

      Return ( cCodigo )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Function cSeekExternalCodebar( cCodBar, dbfCodebar, dbfArt )

   local n
   local cCodigo
   local cPropiedades         := ""
   local nOrdenAnterior

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

   if dbSeekInOrd( cCodigo, "Codigo", dbfArt ) .or. dbSeekInOrd( Upper( cCodigo ), "Codigo", dbfArt )
      Return ( cCodBar )
   end if

   // Ahora buscamos en los codigos de barras----------------------------------

   nOrdenAnterior          := ( dbfCodebar )->( OrdSetFocus( "cCodBar" ) )

   if ( dbfCodebar )->( dbSeek( cCodigo ) ) .or. ( dbfCodebar )->( dbSeek( Upper( cCodigo ) ) )

      cCodigo              := ( dbfCodebar )->cCodArt

      if empty( cPropiedades )

         if !empty( ( dbfCodebar )->cValPr1 )
            cPropiedades   += "." + Rtrim( ( dbfCodebar )->cValPr1 )
         end if

         if !empty( ( dbfCodebar )->cValPr2 )
            cPropiedades   += "." + Rtrim( ( dbfCodebar )->cValPr2 )
         end if

      end if

   end if

   ( dbfCodebar )->( OrdSetFocus( nOrdenAnterior ) )

   if !empty( cPropiedades )
      cCodBar                 := Rtrim( cCodigo ) + cPropiedades
   else
      cCodBar                 := cCodigo
   end if

Return ( cCodBar )

//---------------------------------------------------------------------------//

FUNCTION retArticulo( cCodArt, dbfArt )

   local oBlock
   local oError
   local nRecno
   local lClose   := .f.
	local cTemp		:= Space( 30 )

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if empty( dbfArt ) 
      USE ( cPatArt() + "ARTICULO.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArt ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if IsObject( dbfArt )
      nRecno      := dbfArt:Recno()
      if dbfArt:Seek( cCodArt )
         cTemp    := Rtrim( dbfArt:Nombre )
      end if
      dbfArt:GoTo( nRecno )
   else
      nRecno      := ( dbfArt )->( Recno() )
      if ( dbfArt )->( dbSeek( cCodArt ) )
         cTemp    := Rtrim( ( dbfArt )->Nombre )
      end if 
      ( dbfArt )->( dbGoTo( nRecno ) )
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de articulos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfArt )
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
      oFr:SetWorkArea(  "Artículos", ( D():Articulos( nView ) )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   end if
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Familias", ( D():Familias( nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Familias", cItemsToReport( aItmFam() ) )

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
      oFr:SetMasterDetail( "Artículos",   "Precios por propiedades", {|| ( D():Articulos( nView ) )->Codigo + ( D():Articulos( nView ) )->cCodPrp1 + ( D():Articulos( nView ) )->cCodPrp2 + ( D():Articulos( nView ) )->cValPrp1 + ( D():Articulos( nView ) )->cValPrp2 } )
      oFr:SetMasterDetail( "Artículos",   "Ofertas",                 {|| ( D():Articulos( nView ) )->Codigo + ( D():Articulos( nView ) )->cCodPrp1 + ( D():Articulos( nView ) )->cCodPrp2 + ( D():Articulos( nView ) )->cValPrp1 + ( D():Articulos( nView ) )->cValPrp2 } )
      oFr:SetMasterDetail( "Artículos",   "Familias",                {|| ( D():Articulos( nView ) )->Familia } )
      oFr:SetMasterDetail( "Artículos",   "Categoria",               {|| ( D():Articulos( nView ) )->cCodCate } )
      oFr:SetMasterDetail( "Artículos",   "Temporada",               {|| ( D():Articulos( nView ) )->cCodTemp } )
      oFr:SetMasterDetail( "Artículos",   "Tipo artículo",           {|| ( D():Articulos( nView ) )->cCodTip } )
      oFr:SetMasterDetail( "Artículos",   "Fabricante",              {|| ( D():Articulos( nView ) )->cCodFab } )
      oFr:SetMasterDetail( "Artículos",   "Unidad de medición",      {|| ( D():Articulos( nView ) )->cUnidad } )
      oFr:SetMasterDetail( "Artículos",   "Códigos de barras",       {|| ( D():Articulos( nView ) )->Codigo } )
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

   nOrdAnt        := ( D():Articulos( nView ) )->( OrdSetFocus( "Cod" ) )

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

         if !empty( ( dbfDoc )->mReport )

            oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

         else

            oFr:AddPage(         "MainPage" )

            oFr:AddBand(         "MasterData",  "MainPage",       frxMasterData )
            oFr:SetProperty(     "MasterData",  "Top",            200 )
            oFr:SetProperty(     "MasterData",  "Height",         100 )
            oFr:SetObjProperty(  "MasterData",  "DataSet",        "Artículos" )

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

   if !empty( ( dbfDoc )->mReport )

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
         FILE     cFileBmpName( ( D():Articulos( nView ) )->cImagen, .t. )

      oBmpImage:SetColor( , GetSysColor( 15 ) )

      oBmpImage:bLClicked              := {|| ShowImage( oBmpImage ) }
      oBmpImage:bRClicked              := {|| ShowImage( oBmpImage ) }

      /*
      Arbol con información del producto---------------------------------------
      */

      oTreeInfo                        := TTreeView():Redefine( 120, oDlgToolTip )

      oImageListInfo                   := TImageList():New( 16, 16 )

      oImageListInfo:AddMasked( TBitmap():Define( "gc_object_cube_16" ),   Rgb( 255, 0, 255 ) )
      oImageListInfo:AddMasked( TBitmap():Define( "gc_star2_16" ),      Rgb( 255, 0, 255 ) )
      oImageListInfo:AddMasked( TBitmap():Define( "gc_calendar_16" ),      Rgb( 255, 0, 255 ) )

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
         :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cCodigoAlmacen, "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Almacén"
         :nWidth              := 120
         :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), RetAlmacen( oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cCodigoAlmacen, dbfAlmT ), "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Prop. 1"
         :nWidth              := 40
         :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cValorPropiedad1, "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Prop. 2"
         :nWidth              := 40
         :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cValorPropiedad2, "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Lote"
         :nWidth              := 60
         :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cLote, "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Num. serie"
         :nWidth              := 60
         :bStrData            := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:cNumeroSerie, "" ) }
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Unidades"
         :nWidth              := 80
         :bEditValue          := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nUnidades, 0 ) }
         :bFooter             := {|| nStockUnidades( oBrwStock ) }
         :cEditPicture        := MasUnd()
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Pdt. recibir"
         :bEditValue          := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nPendientesRecibir, 0 ) }
         :bFooter             := {|| nStockPendiente( oBrwStock ) }
         :nWidth              := 70
         :cEditPicture        := cPicUnd
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
      end with

      with object ( oBrwStock:AddCol() )
         :cHeader             := "Pdt. entregar"
         :bEditValue          := {|| if( !empty( oBrwStock:aArrayData ), oBrwStock:aArrayData[ oBrwStock:nArrayAt ]:nPendientesEntregar, 0 ) }
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

   local sStock
   local nStockMinimo
   local nStockUnidades

   CursorWait()

   oTreeInfo:SetImageList( oImageListInfo )

   switch ( nTipoOferta() )
      case 1
         oTreeInfo:Add( "Artículo actualmente en oferta por importes.", 1 )
      case 2
         oTreeInfo:Add( "Artículo actualmente en oferta de tipo X*Y.", 1 )
   end

   oTreeInfo:Add( "Fecha de creación " + Dtoc( ( D():Articulos( nView ) )->LastChg ), 2 )

   if !empty( ( D():Articulos( nView ) )->dFecChg )
      oTreeInfo:Add( "Última modificación " + Dtoc( ( D():Articulos( nView ) )->dFecChg ), 2 )
   end if

   /*
   Calculos de stocks----------------------------------------------------------
   */

   if ( ( D():Articulos( nView ) )->nCtlStock <= 1 )

      oStock:aStockArticulo( cCodArt, , oBrwStock )

      /*
      Aviso de stock bajo minimo--------------------------------------------------
      */

      for each sStock in oStock:aStocks

         nStockMinimo   := nStockMinimo( sStock:cCodigo, sStock:cCodigoAlmacen, nView )

         if nStockMinimo > sStock:nUnidades
            oTreeInfo:Add( "Stock bajo minimos, stock actual " + Alltrim( Trans( sStock:nUnidades, MasUnd() ) ) + "; minimo " + Alltrim( Trans( nStockMinimo, MasUnd() ) ) + "." , 0 )
         end if

      next 

   end if

   if !empty( oBrwStock )
      oBrwStock:Load()
   end if

   CursorWE()

Return nil

//---------------------------------------------------------------------------//

Static Function nTipoOferta()

   local nOferta     := 0

   if ( dbfOfe )->( dbSeek( ( D():Articulos( nView ) )->Codigo ) )

      while ( dbfOfe )->cArtOfe == ( D():Articulos( nView ) )->Codigo .and. !( dbfOfe )->( eof() )

			/*
         Comprobamos si esta entre las fechas----------------------------------
			*/

         if ( GetSysDate() >= ( dbfOfe )->dIniOfe .or. empty( ( dbfOfe )->dIniOfe ) ) .and. ;
            ( GetSysDate() <= ( dbfOfe )->dFinOfe .or. empty( ( dbfOfe )->dFinOfe ) )

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
   local nRec     := ( D():Articulos( nView ) )->( Recno() )
   local nOrd     := ( D():Articulos( nView ) )->( OrdSetFocus( "nPosTpv" ) )
   local cFam     := ( D():Articulos( nView ) )->Familia

   CursorWait()

   do case
      case IsTrue( lInc )

         if ( D():Articulos( nView ) )->( dbRLock() )
            ( D():Articulos( nView ) )->nPosTpv   := ( D():Articulos( nView ) )->nPosTpv + 1.5
         end if
         ( D():Articulos( nView ) )->( dbUnLock() )

      case IsFalse( lInc )

         if ( D():Articulos( nView ) )->( dbRLock() )
            ( D():Articulos( nView ) )->nPosTpv   := ( D():Articulos( nView ) )->nPosTpv - 1.5
         end if
         ( D():Articulos( nView ) )->( dbUnLock() )

   end case

   //--------------------------------------------------------------------------

   ( D():Articulos( nView ) )->( dbGoTop() )
   while !( D():Articulos( nView ) )->( eof() )

      if cFam == ( D():Articulos( nView ) )->Familia .and. ( D():Articulos( nView ) )->lIncTcl
         aAdd( aRec, { ( D():Articulos( nView ) )->( Recno() ), nPos++ } )
      end if

      ( D():Articulos( nView ) )->( dbSkip() )

   end while

   //--------------------------------------------------------------------------

   for each aPos in aRec

      ( D():Articulos( nView ) )->( dbGoTo( aPos[ 1 ] ) )

      if ( D():Articulos( nView ) )->( dbRLock() )
         ( D():Articulos( nView ) )->nPosTpv      := aPos[ 2 ]
         ( D():Articulos( nView ) )->( dbUnLock() )
      end if

   next

   //--------------------------------------------------------------------------

   CursorWE()

   ( D():Articulos( nView ) )->( dbGoTo( nRec ) )
   ( D():Articulos( nView ) )->( OrdSetFocus( nOrd ) )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function changeTactil()

   local nRec

   for each nRec in ( oWndBrw:oBrw:aSelected )

      ( D():Articulos( nView ) )->( dbGoTo( nRec ) )

      if ( D():Articulos( nView ) )->( dbRLock() )
         ( D():Articulos( nView ) )->lIncTcl   := !( D():Articulos( nView ) )->lIncTcl
         ( D():Articulos( nView ) )->( dbCommit() )
         ( D():Articulos( nView ) )->( dbUnLock() )
      end if 

   next 

Return ( nil )

//---------------------------------------------------------------------------//

Function ChangePublicar()

   local nRec

   for each nRec in ( oWndBrw:oBrw:aSelected )

      ( D():Articulos( nView ) )->( dbGoTo( nRec ) )

      if ( D():Articulos( nView ) )->( dbRLock() )
         ( D():Articulos( nView ) )->lPubInt   := !( D():Articulos( nView ) )->lPubInt
         ( D():Articulos( nView ) )->lSndDoc   := ( D():Articulos( nView ) )->lPubInt
         ( D():Articulos( nView ) )->( dbCommit() )
         ( D():Articulos( nView ) )->( dbUnLock() )
      end if

      if ( D():Articulos( nView ) )->lPubInt
         ChangeFamiliaInt(       ( D():Articulos( nView ) )->Familia   )
         ChangePropiedadesInt(   ( D():Articulos( nView ) )->cCodPrp1  )
         ChangePropiedadesInt(   ( D():Articulos( nView ) )->cCodPrp2  )
         ChangeTipArtInt(        ( D():Articulos( nView ) )->cCodTip   )
         // ChangeFabricantesInt(   ( D():Articulos( nView ) )->cCodFab   )
      end if

   next

   oWndBrw:Refresh( .t. )

Return nil

//---------------------------------------------------------------------------//

static function ChangePublicarTemporal( aTmp )

   if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lPubInt" ) ) ]
      ChangeFamiliaInt(       aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Familia"  ) ) ] )
      ChangePropiedadesInt(   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp1" ) ) ] )
      ChangePropiedadesInt(   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodPrp2" ) ) ] )
      ChangeTipArtInt(        aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodTip"  ) ) ] )


      // ChangeFabricantesInt(   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodFab"  ) ) ] )
   end if

   if !empty( oWndBrw )
      oWndBrw:Refresh( .t. )
   end if

Return nil

//---------------------------------------------------------------------------//

static function ChangeFamiliaInt( cCodFam )

   local nRec

   if !empty( cCodFam )

      nRec  := ( D():Familias( nView ) )->( Recno() )

      if dbSeekInOrd( cCodFam, "CCODFAM", D():Familias( nView ) )

         if ( D():Familias( nView ) )->( dbRLock() )
            ( D():Familias( nView ) )->lPubInt   := .t.
            ( D():Familias( nView ) )->lSelDoc   := .t.
            ( D():Familias( nView ) )->( dbCommit() )
            ( D():Familias( nView ) )->( dbUnLock() )
         end if

         if !empty( ( D():Familias( nView ) )->cCodGrp )
            ChangeGrpFamInt( ( D():Familias( nView ) )->cCodGrp )
         end if

      end if

      ( D():Familias( nView ) )->( dbGoto( nRec ) )

   end if

return nil

//---------------------------------------------------------------------------//

static function ChangePropiedadesInt( cCodPro )

   local nRec

   if !empty( cCodPro )

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

   if !empty( cCodFab )

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

   if !empty( cCodTip )

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

   if !empty( cCodGrp )

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

      ( D():Articulos( nView ) )->( dbGoTo( nRec ) )

      if ( D():Articulos( nView ) )->( dbRLock() )
         ( D():Articulos( nView ) )->lSndDoc   := !( D():Articulos( nView ) )->lSndDoc
         ( D():Articulos( nView ) )->( dbCommit() )
         ( D():Articulos( nView ) )->( dbUnLock() )
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

   if !empty( oBrwStock ) .and. !empty( oBrwStock:aArrayData )
      aEval( oBrwStock:aArrayData, {|a| nStock += a[ nPos ] } )
   end if

Return ( nStock )

//---------------------------------------------------------------------------//

Function nStockUnidades( oBrwStock, cCodigoAlmacen )

   local nStock   := 0

   if !empty( oBrwStock ) .and. !empty( oBrwStock:aArrayData )
      if empty( cCodigoAlmacen )
         aEval( oBrwStock:aArrayData, {|a| nStock += a:nUnidades } )
      else
         aEval( oBrwStock:aArrayData, {|a| if( cCodigoAlmacen == oBrwStock:cCodigoAlmacen, nStock += a:nUnidades, ) } )
      end if 
   end if

Return ( nStock )

//---------------------------------------------------------------------------//

Function nStockPendiente( oBrwStock )

   local nStock   := 0

   if !empty( oBrwStock ) .and. !empty( oBrwStock:aArrayData )
      aEval( oBrwStock:aArrayData, {|a| nStock += a:nPendientesRecibir } )
   end if

Return ( nStock )

//---------------------------------------------------------------------------//

Function nStockEntregar( oBrwStock )

   local nStock   := 0

   if !empty( oBrwStock ) .and. !empty( oBrwStock:aArrayData )
      aEval( oBrwStock:aArrayData, {|a| nStock += a:nPendientesEntregar } )
   end if

Return ( nStock )

//---------------------------------------------------------------------------//

FUNCTION cArtBarPrp1( uArt, uTblPro )

   local cBarPrp1    := ""

   DEFAULT uArt      := if( !empty( tmpArticulo ), tmpArticulo, D():Articulos( nView ) )
   DEFAULT uTblPro   := dbfTblPro

   if dbSeekInOrd( ( uArt )->cCodPrp1 + ( uArt )->cValPrp1, "cCodPro", uTblPro )
      cBarPrp1       := ( uTblPro )->nBarTbl
   end if

RETURN ( cBarPrp1 )

//---------------------------------------------------------------------------//

FUNCTION cArtBarPrp2( uArt, uTblPro )

   local cBarPrp2    := ""

   DEFAULT uArt      := if( !empty( tmpArticulo ), tmpArticulo, D():Articulos( nView ) )
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
         ID          100 ;
         OF          oDlg ;
         PROMPT      "&Principal",;
                     "&HTML" ;
         DIALOGS     "Imagenes_1",;
                     "Imagenes_2"

      REDEFINE GET   oImgArt ;
         VAR         aTmp[ ( dbfTmpImg )->( FieldPos( "cImgArt" ) ) ] ;
         ID          100 ;
         BITMAP      "Lupa" ;
         ON HELP     ( GetBmp( oImgArt, oImgBmp ) ) ;
         ON CHANGE   ( ChgBmp( oImgArt, oImgBmp ) ) ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          fldGeneral

      REDEFINE GET   aTmp[ ( dbfTmpImg )->( FieldPos( "cRmtArt" ) ) ] ;
         ID          140 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         MEMO ;
         OF          fldGeneral

      REDEFINE GET   aTmp[ ( dbfTmpImg )->( FieldPos( "cNbrArt" ) ) ] ;
         ID          120 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          fldGeneral

      REDEFINE CHECKBOX aTmp[ ( dbfTmpImg )->( fieldpos( "lDefImg" ) ) ] ;
         ID          130 ;
         WHEN        ( nMode != ZOOM_MODE .and. !aTmp[ ( dbfTmpImg )->( FieldPos( "lDefImg" ) ) ] ) ;
         OF          fldGeneral

      REDEFINE IMAGE oImgBmp ADJUST ;
         ID          110 ;
         OF          fldGeneral ;
         FILE        cFileBmpName( aTmp[ ( dbfTmpImg )->( FieldPos( "cImgArt" ) ) ] )

      oImgBmp:SetColor( , GetSysColor( 15 ) )
      oImgBmp:bLClicked := {|| ShowImage( oImgBmp ) }
      oImgBmp:bRClicked := {|| ShowImage( oImgBmp ) }

      REDEFINE BUTTON ;
         ID          3 ;
         OF          fldGeneral ;
         ACTION      ( ShowImage( oImgBmp ) )

      REDEFINE GET aTmp[ ( dbfTmpImg )->( FieldPos( "cHtmArt" ) ) ] ;
         ID          100 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          fldPrecios

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          oDlg ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         ACTION      ( EndEdtImg( aTmp, dbfTmpImg, oBrw, nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         CANCEL ;
         ACTION      ( oDlg:end() )

      oDlg:bStart    := {|| oImgArt:SetFocus() }

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

   lCargaImagenes()

   if !empty( oBrw )
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

Function ChangeTarifaPrecioWeb( aGet, aTmp )

   if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "LSBRINT" ) ) ]

      if empty( oGetTarWeb )
         Return .f.
      end if

      do case
         case oGetTarWeb:getTarifa() == 1
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaWeb" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA1" ) ) ] )
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA1" ) ) ] )
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpIva1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA1" ) ) ] )

         case oGetTarWeb:getTarifa() == 2
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaWeb" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA2" ) ) ] )
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA2" ) ) ] )
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpIva1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA2" ) ) ] )

         case oGetTarWeb:getTarifa() == 3
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaWeb" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA3" ) ) ] )
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA3" ) ) ] )
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpIva1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA3" ) ) ] )

         case oGetTarWeb:getTarifa() == 4
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaWeb" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA4" ) ) ] )
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA4" ) ) ] )
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpIva1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA4" ) ) ] )

         case oGetTarWeb:getTarifa() == 5
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaWeb" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA5" ) ) ] )
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA5" ) ) ] )
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpIva1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA5" ) ) ] )

         case oGetTarWeb:getTarifa() == 6
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "pVtaWeb" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA6" ) ) ] )
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpInt1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVENTA6" ) ) ] )
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nImpIva1" ) ) ]:cText( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "PVTAIVA6" ) ) ] )

      end case

   end if   

Return ( .t. )

//---------------------------------------------------------------------------//

Function nCostoUltimaCompra( cCodArt, dbfAlbPrvL, dbfFacPrvL )

   local nCosto   := 0

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

   if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "lFacCnv" ) ) ]

      if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nPesoKg" ) ) ] != 0

         aGet[ ( D():Articulos( nView ) )->( fieldpos( "nFacCnv" ) ) ]:cText( 1 / aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nPesoKg" ) ) ] )

      else

         if aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nVolumen" ) ) ] != 0
            aGet[ ( D():Articulos( nView ) )->( fieldpos( "nFacCnv" ) ) ]:cText( 1 / aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nVolumen" ) ) ] )
         end if

      end if

   else

      aGet[ ( D():Articulos( nView ) )->( fieldpos( "nFacCnv" ) ) ]:cText( 1 )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function buildWeb( idProduct, idShop )

   local TComercio   := TComercio():New( nView, oStock )

   if lPublishProductInPrestashop()
      TComercio:setWebToExport( idShop ) 
      TComercio:controllerExportOneProductToPrestashop( idProduct )
   end if 

   if lDeleteProductInPrestashop()
      TComercio:setWebToExport( idShop ) 
      TComercio:controllerDeleteOneProductToPrestashop( idProduct )
   end if 

Return .t.

//---------------------------------------------------------------------------//

Static Function debugWeb( aTmp )

   local idProduct   := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ]
   local idShop      := aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cWebShop" ) ) ]
   local TComercio   := TComercio():New( nView, oStock )

   TComercio:setDebugMode()
   TComercio:resetMegaCommand()

   if lPublishProductInPrestashop()
      TComercio:setWebToExport( idShop ) 
      TComercio:controllerExportOneProductToPrestashop( idProduct )
   end if 

   if lDeleteProductInPrestashop()
      TComercio:setWebToExport( idShop ) 
      TComercio:controllerDeleteOneProductToPrestashop( idProduct )
   end if 

Return .t.

//---------------------------------------------------------------------------//

Static Function lPublishProductInPrestashop()

Return ( ( D():Articulos( nView ) )->lPubInt .and. !empty( ( D():Articulos( nView ) )->cWebShop ) )

//---------------------------------------------------------------------------//

Static Function lDeleteProductInPrestashop()

Return ( !( D():Articulos( nView ) )->lPubInt .and. !empty( ( D():Articulos( nView ) )->cWebShop ) ) 

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

   nPorcentajeIva                := nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )

   nPrecioBase                   := uValue

   /*
   Primero es quitar el IVA----------------------------------------------------
   */

   nPrecioIva                    := nPrecioBase + Round( ( nPrecioBase * nPorcentajeIva / 100 ), nDecDiv )

   /*
   Calculo de porcentajes de beneficio-----------------------------------------
   */

   if ( D():Articulos( nView ) )->pCosto != 0

      lBeneficioSobreCosto       := ( D():Articulos( nView ) )->( fieldget( fieldpos( hFields[ "BeneficioSobre" ] ) ) ) <= 1

      nPorcentajeBeneficio       := nPorcentajeBeneficio( lBeneficioSobreCosto, nPrecioBase, ( D():Articulos( nView ) )->pCosto )

      if !( nPorcentajeBeneficio > 0 .and. nPorcentajeBeneficio < 999 )
         nPorcentajeBeneficio    := 0
      end if

   end if

   /*
   Escribimos el registro------------------------------------------------------
   */

   if dbDialogLock( D():Articulos( nView ) )
      ( D():Articulos( nView ) )->( fieldput( fieldpos( hFields[ "Iva"       ] ), nPrecioIva ) )
      ( D():Articulos( nView ) )->( fieldput( fieldpos( hFields[ "Base"      ] ), nPrecioBase ) )
      ( D():Articulos( nView ) )->( fieldput( fieldpos( hFields[ "Beneficio" ] ), nPorcentajeBeneficio ) )
      ( D():Articulos( nView ) )->( dbUnlock() )
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

   nPorcentajeIva                := nIva( D():TiposIva( nView ), ( D():Articulos( nView ) )->TipoIva )

   /*
   Margen de ajuste------------------------------------------------------------ 
   */

   /*if IsTrue( ( D():Articulos( nView ) )->lMarAju )
      nPrecioIva                 := nAjuste( uValue, ( D():Articulos( nView ) )->cMarAju )
   else */
      nPrecioIva                 := uValue
   //end if

   /*
   Primero es quitar el IVA----------------------------------------------------
   */

   nPrecioBase                   := Round( nPrecioIva / ( 1 + nPorcentajeIva / 100 ), nDecDiv )

   /*
   Calculo de porcentajes de beneficio-----------------------------------------
   */

   if ( D():Articulos( nView ) )->pCosto != 0

      lBeneficioSobreCosto       := ( D():Articulos( nView ) )->( fieldget( fieldpos( hFields[ "BeneficioSobre" ] ) ) ) <= 1

      nPorcentajeBeneficio       := nPorcentajeBeneficio( lBeneficioSobreCosto, nPrecioBase, ( D():Articulos( nView ) )->pCosto )

      if !( nPorcentajeBeneficio > 0 .and. nPorcentajeBeneficio < 999 )
         nPorcentajeBeneficio    := 0
      end if

   end if

   /*
   Escibimos el registro-------------------------------------------------------
   */

   if dbDialogLock( D():Articulos( nView ) )
      ( D():Articulos( nView ) )->( fieldput( fieldpos( hFields[ "Iva"       ] ), nPrecioIva ) )
      ( D():Articulos( nView ) )->( fieldput( fieldpos( hFields[ "Base"      ] ), nPrecioBase ) )
      ( D():Articulos( nView ) )->( fieldput( fieldpos( hFields[ "Beneficio" ] ), nPorcentajeBeneficio ) )
      ( D():Articulos( nView ) )->( dbUnlock() )
   end if 

Return .t.

//---------------------------------------------------------------------------//

Static Function ValidPrecioCosto( aGet, oSayWeb )

   aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef1" ) ) ]:lValid()
   aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef2" ) ) ]:lValid()
   aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef3" ) ) ]:lValid()
   aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef4" ) ) ]:lValid()
   aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef5" ) ) ]:lValid()
   aGet[ ( D():Articulos( nView ) )->( fieldpos( "Benef6" ) ) ]:lValid()

   aeval( oSayWeb, {|o| if( !empty(o), o:refresh(), ) } )

Return ( .t. )

//---------------------------------------------------------------------------//

FUNCTION cNomValPrp1Art( uArticulo, uTblPro )

   local cBarPrp1     := ""

   DEFAULT uArticulo  := if( !empty( tmpArticulo ), tmpArticulo, D():Articulos( nView ) )
   DEFAULT uTblPro    := dbfTblPro

   if dbSeekInOrd( ( uArticulo )->cCodPrp1 + ( uArticulo )->cValPrp1, "cCodPro", uTblPro )
      cBarPrp1        := ( uTblPro )->cDesTbl
   end if

RETURN ( cBarPrp1 )

//---------------------------------------------------------------------------//

FUNCTION cNomValPrp2Art( uArticulo, uTblPro )

   local cBarPrp2     := ""

   DEFAULT uArticulo  := if( !empty( tmpArticulo ), tmpArticulo, D():Articulos( nView ) )
   DEFAULT uTblPro    := dbfTblPro

   if dbSeekInOrd( ( uArticulo )->cCodPrp2 + ( uArticulo )->cValPrp2, "cCodPro", uTblPro )
      cBarPrp2        := ( uTblPro )->cDesTbl
   end if

RETURN ( cBarPrp2 )

//---------------------------------------------------------------------------//

Function ScriptArticulo()

   local aArticulos
   local dbfArt

   aArticulos           := {}

   USE ( cPatArt() + "Articulo.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArt ) )
   SET ADSINDEX TO ( cPatArt() + "Articulo.Cdx" ) ADDITIVE

   ( dbfArt )->( dbGoTop() )
   while !( dbfArt )->( eof() )

      if ( dbfArt )->lSndDoc
         aAdd( aArticulos, hashRecord( dbfArt ) )
      end if

      ( dbfArt )->( dbSkip() )

   end while

   CLOSE ( dbfArt )

   hb_MemoWrit( "c:\ads\art" + dtos( date() ) + strtran( time(), ":", "" ) , hb_serialize( aArticulos ) )   

RETURN ( nil )

//---------------------------------------------------------------------------//

Function lPrecioMinimo( cCodigoArticulo, nPrecioVenta, nMode, dbfArt )

   if !uFieldEmpresa( "lPreMin")
      return .f.
   end if 

   if dbSeekInOrd( cCodigoArticulo, "Codigo", dbfArt ) .and. ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      if !empty( ( dbfArt )->PvpRec ) .and. ( dbfArt )->PvpRec > nPrecioVenta
         return .t.
      end if
   end if 

return .f.

//---------------------------------------------------------------------------//

Static Function StockAlmacenes( aTmp, aGet, nMode )

   local oDlg
   local oBrwAlm

   DEFINE DIALOG oDlg RESOURCE "ART_ALMACEN"

   oBrwAlm                 := IXBrowse():New( oDlg )

   oBrwAlm:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwAlm:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwAlm:cAlias          := dbfTmpAlm

   oBrwAlm:nMarqueeStyle   := 6
   oBrwAlm:cName           := "Stock por almacenes"

      with object ( oBrwAlm:AddCol() )
         :cHeader          := "Código almacén"
         :bEditValue       := {|| ( dbfTmpAlm )->cCodAlm }
         :nWidth           := 100
      end with

      with object ( oBrwAlm:AddCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| RetAlmacen( ( dbfTmpAlm )->cCodAlm, dbfAlmT ) }
         :nWidth           := 150
      end with

      with object ( oBrwAlm:AddCol() )
         :cHeader          := "Stock mínimo"
         :bEditValue       := {|| ( dbfTmpAlm )->nStkMin }
         :nWidth           := 80
         :cEditPicture     := MasUnd()
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAlm:AddCol() )
         :cHeader          := "Stock máximo"
         :bEditValue       := {|| ( dbfTmpAlm )->nStkMax }
         :nWidth           := 80
         :cEditPicture     := MasUnd()
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAlm:AddCol() )
         :cHeader          := "Ubicación"
         :bEditValue       := {|| AllTrim( ( dbfTmpAlm )->cUbica ) }
         :nWidth           := 150
      end with

      if nMode != ZOOM_MODE
         oBrwAlm:bLDblClick:= {|| WinEdtRec( oBrwAlm, bEdtAlm, dbfTmpAlm, aTmp ) }
      end if

      oBrwAlm:CreateFromResource( 100 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwAlm, bEdtAlm, dbfTmpAlm, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwAlm, bEdtAlm, dbfTmpAlm, aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oDlg;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinDelRec( oBrwAlm, dbfTmpAlm ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrwAlm, bEdtAlm, dbfTmpAlm, aTmp ) } )
         oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrwAlm, bEdtAlm, dbfTmpAlm, aTmp ) } )
         oDlg:AddFastKey( VK_F4, {|| WinDelRec( oBrwAlm, dbfTmpAlm ) } )
         oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

Return nil    

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtAlm( aTmp, aGet, dbfTmpAlm, oBrw, bWhen, bValid, nMode )

   local oDlg

   DEFINE DIALOG     oDlg ;
      RESOURCE       "ART_ALMACEN_EDICION" ;
      TITLE          LblTitle( nMode ) + "stock por almacenes"

      REDEFINE GET   aGet[ ( dbfTmpAlm )->( fieldPos( "cCodAlm" ) ) ] ;
         VAR         aTmp[ ( dbfTmpAlm )->( fieldPos( "cCodAlm" ) ) ] ;
         ID          100 ;
         IDTEXT      101 ;
         WHEN        ( nMode == APPD_MODE ) ;
         VALID       ( cAlmacen( aGet[ ( dbfTmpAlm )->( fieldPos( "cCodAlm" ) ) ], nil, aGet[ ( dbfTmpAlm )->( fieldPos( "cCodAlm" ) ) ]:oHelpText ) ) ;
         BITMAP      "Lupa" ;
         ON HELP     ( BrwAlmacen( aGet[ ( dbfTmpAlm )->( fieldPos( "cCodAlm" ) ) ], aGet[ ( dbfTmpAlm )->( fieldPos( "cCodAlm" ) ) ]:oHelpText ) ) ;
         OF          oDlg

      REDEFINE GET   aGet[ ( dbfTmpAlm )->( fieldPos( "nStkMin" ) ) ] ;
         VAR         aTmp[ ( dbfTmpAlm )->( fieldPos( "nStkMin" ) ) ] ;
         ID          110 ;
         PICTURE     ( cPicUnd );
         SPINNER ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oDlg

      REDEFINE GET   aGet[ ( dbfTmpAlm )->( fieldPos( "nStkMax" ) ) ] ;
         VAR         aTmp[ ( dbfTmpAlm )->( fieldPos( "nStkMax" ) ) ] ;
         ID          120 ;
         PICTURE     ( cPicUnd );
         SPINNER ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oDlg

      REDEFINE GET   aGet[ ( dbfTmpAlm )->( fieldPos( "cUbica" ) ) ] ;
         VAR         aTmp[ ( dbfTmpAlm )->( fieldPos( "cUbica" ) ) ] ;
         ID          130 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oDlg

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          oDlg ;
         WHEN        ( nMode != ZOOM_MODE );
         ACTION      ( EndEdtAlm( aTmp, aGet, oBrw, oDlg, nMode ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         CANCEL ;
         ACTION      ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| EndEdtAlm( aTmp, aGet, oBrw, oDlg, nMode ) } )

      oDlg:bStart    := {|| StartEdtAlm( aGet ) }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function StartEdtAlm( aGet )

   EvalGet( aGet )

Return nil

//--------------------------------------------------------------------------//

Static Function EndEdtAlm( aTmp, aGet, oBrw, oDlg, nMode )

   local lExiste  := .f.

   if nMode == APPD_MODE

      if dbSeekInOrd( aTmp[ ( dbfTmpAlm )->( fieldPos( "cCodAlm" ) ) ], "cCodAlm", dbfTmpAlm ) 
         msgStop( "El código de almacén ya existe." )
         return nil
      end if

   end if 

   if aTmp[ ( dbfTmpAlm )->( fieldPos( "nStkMax" ) ) ] != 0 .and. aTmp[ ( dbfTmpAlm )->( fieldPos( "nStkMax" ) ) ] < aTmp[ ( dbfTmpAlm )->( fieldPos( "nStkMin" ) ) ]
      msgStop( "El stock máximo debe ser mayor q el stock mínimo." )
      return nil
   end if

   WinGather( aTmp, aGet, dbfTmpAlm, oBrw, nMode )

   oDlg:End( IDOK )

Return nil

//--------------------------------------------------------------------------//

Function nStockMinimo( cCodigoArticulo, cCodigoAlmacen, nView )

   local nStockMinimo   := 0   

   if uFieldEmpresa( "lStkAlm" )
      if ( D():ArticuloStockAlmacenes( nView ) )->( dbSeek( cCodigoArticulo + cCodigoAlmacen ) )
         nStockMinimo   := ( D():ArticuloStockAlmacenes( nView ) )->nStkMin
      end if 
   else 
      nStockMinimo      := ( D():Articulos( nView ) )->nMinimo
   end if

Return nStockMinimo

//--------------------------------------------------------------------------//

Function nStockMaximo( cCodigoArticulo, cCodigoAlmacen, nView )

   local nStockMaximo   := 0   

   if uFieldEmpresa( "lStkAlm" )
      if ( D():ArticuloStockAlmacenes( nView ) )->( dbSeek( cCodigoArticulo + cCodigoAlmacen ) )
         nStockMaximo   := ( D():ArticuloStockAlmacenes( nView ) )->nStkMax
      end if 
   else 
      nStockMaximo      := ( D():Articulos( nView ) )->nMaximo
   end if 

Return nStockMaximo

//--------------------------------------------------------------------------//

Function cArticulo( aGet, dbfArt, aGet2, lCodeBar )

   local oBlock
   local oError
   local nOrdAnt
   local lClose      := .f.
   local lValid      := .f.
   local cCodArt     := aGet:varGet()

   DEFAULT lCodeBar  := .f.

   if empty( cCodArt ) .or. ( cCodArt == Replicate( "Z", 18 ) )
      Return .T.
   end if

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if empty( dbfArt )
      USE ( cPatArt() + "ARTICULO.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArt ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE
      lClose         := .t.
   end if

   if lCodeBar
      nOrdAnt        := ( dbfArt )->( ordSetFocus( "CODEBAR" ) )
   else
      nOrdAnt        := ( dbfArt )->( ordSetFocus( "CODIGO" ) ) 
   end if

   if ( dbfArt )->( dbSeek( cCodArt ) )

      if lCodeBar
         aGet:cText( (dbfArt)->CODEBAR )
      else
         aGet:cText( (dbfArt)->CODIGO )
      end if

      if aGet2 != nil
         aGet2:cText( (dbfArt)->NOMBRE )
      end if

      lValid         := .t.

   else

      msgStop( "Artículo no encontrado", "Cadena buscada : " + cCodArt )

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE( dbfArt )
   end if

   if lCodeBar
      ( dbfArt )->( ordSetFocus( nOrdAnt ) )
   end if

RETURN lValid

//---------------------------------------------------------------------------//
/*
Metemos las imágenes en un array para las propiedades-----------------
*/

static function lCargaImagenes()

   local oTemporal

   aImgsArticulo              := {}

   ( dbfTmpImg )->( dbGoTop() )

   while !( dbfTmpImg )->( Eof() )

         oTemporal            := SImagenes()
         oTemporal:lSelect    := .f.
         oTemporal:Ruta       := ( dbfTmpImg )->cImgArt
         oTemporal:ToolTip    := ( dbfTmpImg )->cNbrArt

         aAdd( aImgsArticulo, oTemporal )

      ( dbfTmpImg )->( dbSkip() )

   end while   

   ( dbfTmpImg )->( dbGoTop() )

return .t.

//---------------------------------------------------------------------------//

Static function SeleccionaImagen( oBrwImg )

   aImgsArticulo[ oBrwImg:nArrayAt ]:lSelect    := !aImgsArticulo[ oBrwImg:nArrayAt ]:lSelect
   oBrwImg:Refresh()

return .t.

//---------------------------------------------------------------------------//

Static Function mSer2Mem()

   local sImage
   local mNumSer     := ""

   for each sImage in aImgsArticulo
      if sImage:lSelect
         mNumSer        += AllTrim( sImage:ruta ) + ","
      end if   
   next

Return ( mNumSer )

//---------------------------------------------------------------------------//

Static Function SelectImagen( aTmp )

   local cImagen
   local aNumSer
   local nPos

   aNumSer        := hb_aTokens( aTmp[ ( dbfTmpVta )->( fieldpos( "mImgWeb" ) ) ], "," )

   for each cImagen in aNumSer

      nPos        := aScan( aImgsArticulo, {|x| AllTrim( x:ruta ) == AllTrim( cImagen ) }  )

      if nPos != 0
         aImgsArticulo[ nPos ]:lSelect    := .t.
      end if

   next

Return ( nil )

//---------------------------------------------------------------------------

FUNCTION PutLabel( dbfArt, oBrw )

   if dbDialogLock( dbfArt )
      ( dbfArt )->lLabel := !( dbfArt )->lLabel
      ( dbfArt )->( dbUnlock() )
   end if

   oBrw:Refresh()
   oBrw:SetFocus()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION AddLabel( dbfArt, oBrw )

   IF ( dbDialogLock( dbfArt ) )
      ( dbfArt )->nLabel++
      ( dbfArt )->( dbUnlock() )
   END IF

   oBrw:Refresh()
   oBrw:SetFocus()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION DelLabel( dbfArt, oBrw )

   if ( dbDialogLock( dbfArt ) ) .and. ( dbfArt )->nLabel > 1
      ( dbfArt )->nLabel--
      ( dbfArt )->( dbUnlock() )
   end if

   oBrw:Refresh()
   oBrw:SetFocus()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION ResLabel( dbfArt, oBrw, oMtr )

   local n        := 0
   local nRecno   := (dbfArt)->( RecNo() )

   CursorWait()

   ( dbfArt )->( dbGoTop() )

   while !( dbfArt )->( eof() )

      if ( ( dbfArt )->lLabel .or. ( dbfArt )->nLabel != 2 ) .AND. dbDialogLock( dbfArt )
         ( dbfArt )->lLabel := .f.
         ( dbfArt )->nLabel := 1
         ( dbfArt )->( dbUnlock() )
      end if

      ( dbfArt )->( dbSkip() )

      if oMtr != nil
         oMtr:Set( ++n )
      end if

   end do

   ( dbfArt )->( dbGoTo( nRecno ) )

   oBrw:refresh()

   if oMtr != NIL
      oMtr:Set( 0 )
      oMtr:refresh()
   end if

   CursorArrow()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION EdtLabel( dbfArt, oLbx )

   local cPic     := "999"
   local uVar     := ( dbfArt )->nLabel
   local bValid   := { || .T. }

   if oLbx:lEditCol( 4, @uVar, cPic, bValid )

      if dbDialogLock( dbfArt )
         ( dbfArt )->nLabel := uVar
         ( dbfArt )->( dbUnlock() )
      end if

      oLbx:DrawSelect()

   end if

RETURN NIL

//---------------------------------------------------------------------------//

Function nDescuentoArticulo( cCodArt, cCodCli, nView )

   local nDescuento  := 0
   local nNumDto     := retFld( cCodCli, D():Clientes( nView ), "nDtoArt" )

   if empty( nNumDto )
      Return 0
   end if

   if !dbSeekInOrd( cCodArt, "Codigo", D():Articulos( nView ) )
      Return 0
   end if   

   do case
      case nNumDto == 1
         nDescuento  := ( D():Articulos( nView ) )->nDtoArt1
         
      case nNumDto == 2
         nDescuento  := ( D():Articulos( nView ) )->nDtoArt2

      case nNumDto == 3
         nDescuento  := ( D():Articulos( nView ) )->nDtoArt3

      case nNumDto == 4
         nDescuento  := ( D():Articulos( nView ) )->nDtoArt4

      case nNumDto == 5
         nDescuento  := ( D():Articulos( nView ) )->nDtoArt5

      case nNumDto == 6
         nDescuento  := ( D():Articulos( nView ) )->nDtoArt6
   end case

Return nDescuento

//---------------------------------------------------------------------------//

Static Function validMatrizCodigoBarras( codigoMatriz )

   local lValid   := .t.
   local aStatus  

   if empty(codigoMatriz)
      Return ( .t. )
   end if 

   aStatus        := aGetStatus( D():Articulos( nView ), .t. )

   ( D():Articulos( nView ) )->( ordSetFocus( "Matriz" ) )

   if ( D():Articulos( nView ) )->( dbseek( codigoMatriz ) )
      lValid      := .f.
   end if 

   setStatus( D():Articulos( nView ), aStatus )

Return ( lValid )

//---------------------------------------------------------------------------//

Static Function generateMatrizCodigoBarras( getCodigoMatriz ) 

   local nValue
   local aStatus  := aGetStatus( D():Articulos( nView ), .t. )

   ( D():Articulos( nView ) )->( ordsetfocus( "Matriz" ) )
   ( D():Articulos( nView ) )->( dbgobottom() )

   nValue         := val( ( D():Articulos( nView ) )->( ordkeyval() ) ) + 1
   nValue         := strzero( nValue, __lenCodigoMatriz__ )

   getCodigoMatriz:cText( nValue )

   setStatus( D():Articulos( nView ), aStatus )

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function calculaPorcentajeDescuento( oPorcentajeDescuento, nPrecioVenta, nPrecioInternet )

   if nPrecioVenta != 0
      oPorcentajeDescuento:cText( ( 1 - ( nPrecioInternet / nPrecioVenta ) ) * 100 )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

CLASS SImagenes

   DATA lSelect      INIT .f.
   DATA ruta         INIT Space( 250 )
   DATA tooltip      INIT Space( 250 )

END CLASS

//---------------------------------------------------------------------------//

Function getExtraFieldArticulo( cFieldName )

Return ( getExtraField( cFieldName, oDetCamposExtra, ( D():Articulos( nView ) )->Codigo ) )

//---------------------------------------------------------------------------//

Function nombrePrimeraPropiedadArticulo( view )

   DEFAULT view   := nView

Return ( nombrePropiedad( ( tmpArticulo )->cCodPrp1, ( tmpArticulo )->cValPrp1, view ) )

//--------------------------------------------------------------------------//

Function nombreSegundaPropiedadArticulo( view )

   DEFAULT view   := nView

Return ( nombrePropiedad( ( tmpArticulo )->cCodPrp2, ( tmpArticulo )->cValPrp2, view ) )

//--------------------------------------------------------------------------//

Static Function changeImpuestoEspecial( oGetValNewImp, aTmp )

   if !empty( oGetValNewImp )
      oGetValNewImp:cText( oNewImp:nValImp( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "CCODIMP" ) ) ] ) )
      oGetValNewImp:Refresh()
   end if

Return .t.

//--------------------------------------------------------------------------//

Static Function totalArticuloConImpuestoEspecialUno( nView )

Return ( oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp ) + ( D():Articulos( nView ) )->pVtaIva1 )

//--------------------------------------------------------------------------//

Static Function totalArticuloConImpuestoEspecialDos( nView )

Return ( oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp ) + ( D():Articulos( nView ) )->pVtaIva2 )

//--------------------------------------------------------------------------//

Static Function totalArticuloConImpuestoEspecialTres( nView )

Return ( oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp ) + ( D():Articulos( nView ) )->pVtaIva3 )

//--------------------------------------------------------------------------//

Static Function totalArticuloConImpuestoEspecialCuatro( nView )

Return ( oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp ) + ( D():Articulos( nView ) )->pVtaIva4 )

//--------------------------------------------------------------------------//

Static Function totalArticuloConImpuestoEspecialCinco( nView )

Return ( oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp ) + ( D():Articulos( nView ) )->pVtaIva5 )

//--------------------------------------------------------------------------//

Static Function totalArticuloConImpuestoEspecialSeis( nView )

Return ( oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp ) + ( D():Articulos( nView ) )->pVtaIva6 )

//--------------------------------------------------------------------------//

Function getProveedorPorDefectoArticulo( cCodigoArticulo, dbfProveedorArticulo )

   local proveedorPorDefectoArticulo   := ""

   if dbSeekInOrd( cCodigoArticulo, "lDefPrv", dbfProveedorArticulo )
      proveedorPorDefectoArticulo      := ( dbfProveedorArticulo )->cCodPrv
   end if 

Return ( proveedorPorDefectoArticulo )

//--------------------------------------------------------------------------//

Static Function getEtiquetasBrowse( aSelectedItems )

   local aSelected

   aSelected         := EtiquetasController():New():activateBrowse( aSelectedItems )

   if !hb_isarray( aSelected )
      RETURN ( nil )
   endif

   if !empty( aSelected )
      oTagsEver:setItems( aSelected )
   else 
      oTagsEver:hideItems()
   end if 

   oTagsEver:Refresh()

Return ( nil )

//--------------------------------------------------------------------------//

Static Function infoWeb( aTmp )

   local aInfo

   if !( aTmp[ ( D():Articulos( nView ) )->( fieldPos( "lPubInt" ) ) ] )
      msgStop( "Este artículo no esta seleccionado para web" )
      Return nil
   end if 

   if empty( aTmp[ ( D():Articulos( nView ) )->( fieldPos( "cWebShop" ) ) ] )
      msgStop( "Este artículo no tiene seleccionada web" )
      Return nil
   end if 

   aInfo          := TPrestashopId():getProductInformation( aTmp[ ( D():Articulos( nView ) )->( fieldPos( "Codigo" ) ) ], aTmp[ ( D():Articulos( nView ) )->( fieldPos( "cWebShop" ) ) ] )

   if empty( aInfo )
      msgStop( "No hay información de prestashop en este artículo.")
   else
      dialogInfoWeb( aInfo )
   end if 

Return ( nil )

//--------------------------------------------------------------------------//

Static Function dialogInfoWeb( aInfo )

   local oDlg
   local oTree

   DEFINE DIALOG oDlg RESOURCE "ARTICULO_PRESTASHOP_ID"

   oTree          := TTreeView():Redefine( 100, oDlg )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   // evento bstart-----------------------------------------------------------

   oDlg:bStart    := {|| aeval( aInfo, {|hash| oTree:add(   "[" + alltrim( hget( hash, "Web" ) ) + "] : "                  +;
                                                            if( hget( hash, "Documento" ) == "01", "Artículo", "Imagen" )  +;
                                                            " > " + alltrim( str( hget( hash, "Id" ) ) ) ) } ) }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function cUbicacionAlmacen( cArticulo, cAlmacen, nView )

MsgInfo( cArticulo, "Art" )
MsgInfo( cAlmacen, "Almacén" )

Return retFld( cArticulo + cAlmacen, D():ArticuloStockAlmacenes( nView ), "cUbica" )

//---------------------------------------------------------------------------//