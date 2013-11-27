#include "FiveWin.Ch"
#include "Folder.ch"
#include "Factu.ch"
#include "Report.ch"
#include "Menu.ch"
#include "Xbrowse.ch"

#define _MENUITEM_                "01046"

/*
Definici¢n de la base de datos de pedidos a proveedores
*/

#define _CSERPED                   1      //   C      1     0
#define _NNUMPED                   2      //   C      9     0
#define _CSUFPED                   3      //   C      2     0
#define _CTURPED                   4      //   C      6     0
#define _DFECPED                   5      //   D      8     0
#define _CCODPRV                   6      //   C      7     0
#define _CCODALM                   7      //   C      4     0
#define _CCODCAJ                   8      //   C      4     0
#define _CNOMPRV                   9      //   C     35     0
#define _CDIRPRV                  10      //   C     35     0
#define _CPOBPRV                  11      //   C     25     0
#define _CPROPRV                  12      //   C     20     0
#define _CPOSPRV                  13      //   C      5     0
#define _CDNIPRV                  14      //   C     15     0
#define _DFECENT                  15      //   D      8     0
#define _NESTADO                  16      //   N      1     0
#define _CSUPED                   17      //   C     10     0
#define _CCODPGO                  18      //   C      2     0
#define _NBULTOS                  19      //   N      3     0
#define _NPORTES                  20      //   N      6     0
#define _CDTOESP                  21      //   N      4     1
#define _NDTOESP                  22      //   N      4     1
#define _CDPP                     23      //   N      4     1
#define _NDPP                     24      //   N      4     1
#define _LRECARGO                 25      //   L      1     0
#define _CCONDENT                 26      //   C     20     0
#define _CEXPED                   27      //   C     20     0
#define _COBSERV                  28      //   M     10     0
#define _CDIVPED                  29      //   C      3     0
#define _NVDVPED                  30      //   C     10     4
#define _LSNDDOC                  31      //   L      1     0
#define _CDTOUNO                  32      //   N      4     1
#define _NDTOUNO                  33      //   N      4     1
#define _CDTODOS                  34      //   N      4     1
#define _NDTODOS                  35      //   N      4     1
#define _LCLOPED                  36      //   L      1     0
#define _CCODUSR                  37      //   C      3     0
#define _CNUMPEDCLI               38      //   C     12     0
#define _LIMPRIMIDO               39      //   L      1     0
#define _DFECIMP                  40      //   D      8     0
#define _CHORIMP                  41      //   C      5     0
#define _DFECCHG                  42
#define _CTIMCHG                  43
#define _CCODDLG                  44
#define _CSITUAC                  45
#define _NREGIVA                  46
#define _NTOTNET                  47
#define _NTOTIVA                  48
#define _NTOTREQ                  49
#define _NTOTPED                  50
#define _CNUMALB                  51

/* Definici¢n de la base de datos de lineas de detalle */

#define _CREF                      4      //   C     18     0
#define _CREFPRV                   5      //   C     20     0
#define _CDETALLE                  6      //   C     50     0
#define _NIVA                      7      //   N      6     2
#define _NCANPED                   8      //   N     13     3
#define _NUNICAJA                  9      //   N     13     3
#define _NPREDIV                  10      //   N     13     3
#define _NCANENT                  11      //   N     13     3
#define _NUNIENT                  12      //   N     13     3
#define _CUNIDAD                  13      //   C      2     0
#define _MLNGDES                  14      //   M     10     0
#define _NDTOLIN                  15      //   N      5     2
#define _NDTOPRM                  16
#define _NDTORAP                  17
#define _CCODPR1                  18      //   C      5     0
#define _CCODPR2                  19      //   C      5     0
#define _CVALPR1                  20      //   C      5     0
#define _CVALPR2                  21      //   C      5     0
#define _NFACCNV                  22      //   N     13     4
#define _NCTLSTK                  23
#define _CALMLIN                  24      //   C     3      0
#define _LLOTE                    25      //   N     4      0
#define _NLOTE                    26      //   N     4      0
#define _CLOTE                    27      //   N     4      0
#define _NNUMLIN                  28
#define _NUNDKIT                  29
#define _LKITART                  30
#define _LKITCHL                  31
#define _LKITPRC                  32      //   L     4      0
#define _LIMPLIN                  33      //   L     4      0
#define _LCONTROL                 34
#define _MNUMSER                  35
#define _LANULADO                 36
#define _DANULADO                 37
#define _MANULADO                 38
#define _CCODFAM                  39      //   C     8      0
#define _CGRPFAM                  40      //   C     3      0
#define _NREQ                     41      //   C    16      6
#define _MOBSLIN                  42      //   M    10      0
#define _CPEDCLI                  43      //   C    12      0
#define _NPVPREC                  44
#define _NNUMMED                  45
#define _NMEDUNO                  46
#define _NMEDDOS                  47
#define _NMEDTRE                  48

/*
Definici¢n de Array para impuestos
*/

#define _NBRTIVA1                aTotIva[ 1, 1 ]
#define _NBASIVA1                aTotIva[ 1, 2 ]
#define _NPCTIVA1                aTotIva[ 1, 3 ]
#define _NPCTREQ1                aTotIva[ 1, 4 ]
#define _NIMPIVA1                aTotIva[ 1, 5 ]
#define _NIMPREQ1                aTotIva[ 1, 6 ]
#define _NBRTIVA2                aTotIva[ 2, 1 ]
#define _NBASIVA2                aTotIva[ 2, 2 ]
#define _NPCTIVA2                aTotIva[ 2, 3 ]
#define _NPCTREQ2                aTotIva[ 2, 4 ]
#define _NIMPIVA2                aTotIva[ 2, 5 ]
#define _NIMPREQ2                aTotIva[ 2, 6 ]
#define _NBRTIVA3                aTotIva[ 3, 1 ]
#define _NBASIVA3                aTotIva[ 3, 2 ]
#define _NPCTIVA3                aTotIva[ 3, 3 ]
#define _NPCTREQ3                aTotIva[ 3, 4 ]
#define _NIMPIVA3                aTotIva[ 3, 5 ]
#define _NIMPREQ3                aTotIva[ 3, 6 ]

memvar cDbf
memvar cDbfCol
memvar cDbfPrv
memvar cDbfPgo
memvar cDbfIva
memvar cDbfAlm
memvar cDbfDiv
memvar cDbfArt
memvar cDbfKit
memvar cDbfPro
memvar cDbfUsr
memvar cDbfTblPro
memvar aTotIva
memvar aIvaUno
memvar aIvaDos
memvar aIvaTre
memvar nTotBrt
memvar nTotDto
memvar nTotDpp
memvar nTotNet
memvar nTotIva
memvar nTotReq
memvar nTotPed
memvar nTotImp
memvar nTotUno
memvar nTotDos


memvar cPicUndPed
memvar cPinDivPed
memvar cPirDivPed
memvar nDinDivPed
memvar nDirDivPed
memvar nVdvDivPed
memvar nPagina
memvar lEnd

static oWndBrw
static oBrwIva
static dbfPedPrvT
static dbfPedPrvL
static dbfPedPrvI
static dbfPedPrvD
static dbfPedPrvS
static dbfAlbPrvT
static dbfAlbPrvL
static dbfPedCliT
static dbfPedCliL
static dbfPedCliR
static dbfInci
static dbfPrv
static dbfIva
static dbfTmp
static dbfFPago
static dbfDiv
static dbfCajT
static oBandera
static dbfArticulo
static dbfCodebar
static dbfTmpInc
static dbfTmpDoc
static dbfTmpArt
static dbfTmpLin
static dbfTmpSer
static cTmpArt
static cTmpSer
static cTmpPed
static cTmpInc
static cTmpDoc
static dbfFamilia
static dbfDelega
static dbfArtPrv
static dbfArtCom
static dbfAlm
static dbfPro
static dbfTblPro
static dbfTblCnv
static dbfDoc
static dbfKit
static dbfUsr

static dbfCount
static dbfEmp
static dbfFacPrvL
static dbfRctPrvL
static dbfAlbCliL
static dbfFacCliL
static dbfFacRecL
static dbfTikCliL
static dbfProLin
static dbfProMat
static dbfHisMov
static dbfSitua
static dbfClient
static oStock
static oGetNet
static oGetIva
static oGetReq
static oGetTotal
static oUsr
static cUsr
static cPirDiv
static cPinDiv
static cPicUnd
static nDinDiv
static nDirDiv
static cNewFile
static nGetNeto         := 0
static nGetIva          := 0
static nGetReq          := 0
static nVdvDiv          := 1
static oFont
static oMenu
static cOldCodCli       := ""
static cOldCodArt       := ""
static cOldPrpArt       := ""
static cOldUndMed       := ""
static lOpenFiles       := .f.
static lExternal        := .f.
static cFiltroUsuario   := ""
static bEdtRec          := { |aTmp, aGet, dbfPedPrvT, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfPedPrvT, oBrw, bWhen, bValid, nMode ) }
static bEdtDet          := { |aTmp, aGet, dbfPedPrvL, oBrw, bWhen, bValid, nMode, aPedPrv | EdtDet( aTmp, aGet, dbfPedPrvL, oBrw, bWhen, bValid, nMode, aPedPrv ) }
static bEdtInc          := { |aTmp, aGet, dbfPedPrvI, oBrw, bWhen, bValid, nMode, aTmpLin | EdtInc( aTmp, aGet, dbfPedPrvI, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc          := { |aTmp, aGet, dbfPedPrvD, oBrw, bWhen, bValid, nMode, aTmpLin | EdtDoc( aTmp, aGet, dbfPedPrvD, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static oUndMedicion

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt )

   local oBlock
   local oError

   if lOpenFiles
      MsgStop( 'Ficheros de pedidos a proveedores abiertos previamente' )
      Return ( .f. )
   end if

   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      lOpenFiles        := .t.

      USE ( cPatEmp() + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @dbfPedPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDPRVI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPRVI", @dbfPedPrvI ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPRVI.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDPRVD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPRVD", @dbfPedPrvD ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPRVD.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBPROVL.CDX" ) ADDITIVE

      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVEE", @dbfPrv ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE
      SET TAG TO "cCodPrv"

      USE ( cPatArt() + "ArtDiv.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTCOM", @dbfArtCom ) )
      SET ADSINDEX TO ( cPatArt() + "ArtDiv.Cdx" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlm ) )
      SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

      USE ( cPatDat() + "TBLCNV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLCNV", @dbfTblCnv ) )
      SET ADSINDEX TO ( cPatDat() + "TBLCNV.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      SET TAG TO "cTipo"

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "TIPINCI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIPINCI", @dbfInci ) )
      SET ADSINDEX TO ( cPatEmp() + "TIPINCI.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIL", @dbfPedCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "PEDCLIR.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDCLIR", @dbfPedCliR ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDCLIR.CDX" ) ADDITIVE

      USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfTblPro ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

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

      USE ( cPatDat() + "SITUA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SITUA", @dbfSitua ) )
      SET ADSINDEX TO ( cPatDat() + "SITUA.CDX" ) ADDITIVE

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

      if !TDataCenter():OpenPedCliT( @dbfPedCliT )
         lOpenFiles     := .f.
      end if

      // Unidades de medicion

      oUndMedicion      := UniMedicion():Create( cPatGrp() )
      if !oUndMedicion:OpenFiles()
         lOpenFiles     := .f.
      end if

      oStock            := TStock():Create( cPatGrp() )

      if !oStock:lOpenFiles()
         lOpenFiles     := .f.
      end if

      oBandera          := TBandera():New()

      /*
      Recursos y fuente--------------------------------------------------------
      */

      oFont             := TFont():New( "Arial", 8, 26, .F., .T. )

      /*
      Definimos las públicas---------------------------------------------------
      */

      public nTotPed    := 0
      public nTotBrt    := 0
      public nTotDto    := 0
      public nTotDPP    := 0
      public nTotNet    := 0
      public nTotIva    := 0
      public nTotReq    := 0
      public nTotImp    := 0
      public aTotIva    := { { 0,0,nil,0,0,0 }, { 0,0,nil,0,0,0 }, { 0,0,nil,0,0,0 } }
      public aIvaUno    := aTotIva[ 1 ]
      public aIvaDos    := aTotIva[ 2 ]
      public aIvaTre    := aTotIva[ 3 ]

   RECOVER USING oError

      lOpenFiles        := .f.

      MsgStop( ErrorMessage( oError ), "Imposible abrir ficheros de pedidos a proveedores" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

   EnableAcceso()

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   DisableAcceso()

   DestroyFastFilter( dbfPedPrvT, .t., .t. )

   if !Empty( dbfPedPrvT )
      ( dbfPedPrvT )->( dbCloseArea() )
   end if

   if !Empty( oFont )
      oFont:end()
   end if

   if dbfPedPrvL != nil
      ( dbfPedPrvL )->( dbCloseArea() )
   end if

   if !Empty( dbfPedPrvI )
      ( dbfPedPrvI )->( dbCloseArea() )
   end if

   if !Empty( dbfPedPrvD )
      ( dbfPedPrvD )->( dbCloseArea() )
   end if

   if !Empty( dbfPedCliR )
      ( dbfPedCliR )->( dbCloseArea() )
   end if

   if dbfAlbPrvT != nil
      ( dbfAlbPrvT )->( dbCloseArea() )
   end if

   if dbfAlbPrvL != nil
      ( dbfAlbPrvL )->( dbCloseArea() )
   end if

   if dbfPrv != nil
      ( dbfPrv )->( dbCloseArea() )
   end if

   if dbfIva != nil
      ( dbfIva )->( dbCloseArea() )
   end if

   if dbfFPago != nil
      ( dbfFPago )->( dbCloseArea() )
   end if

   if dbfDiv != nil
      ( dbfDiv )->( dbCloseArea() )
   end if

   if dbfArtPrv != nil
      ( dbfArtPrv )->( dbCloseArea() )
   end if

   if dbfArtCom != nil
      ( dbfArtCom )->( dbCloseArea() )
   end if

   if dbfArticulo != nil
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if dbfCodebar != nil
      ( dbfCodebar )->( dbCloseArea() )
   end if

   if dbfFamilia != nil
      ( dbfFamilia )->( dbCloseArea() )
   end if

   if dbfAlm != nil
      ( dbfAlm )->( dbCloseArea() )
   end if

   if dbfKit != nil
      ( dbfKit )->( dbCloseArea() )
   end if

   if dbfTblCnv != nil
      ( dbfTblCnv )->( dbCloseArea() )
   end if

   if dbfDoc != nil
      ( dbfDoc )->( dbCloseArea() )
   end if

   if dbfPro != nil
      ( dbfPro   )->( dbCloseArea() )
   end if

   if dbfTblPro != nil
      ( dbfTblPro)->( dbCloseArea() )
   end if

   if dbfCajT != nil
      ( dbfCajT )->( dbCloseArea() )
   end if

   if dbfUsr != nil
      ( dbfUsr )->( dbCloseArea() )
   end if

   if dbfInci != nil
      ( dbfInci )->( dbCloseArea() )
   end if

   if dbfDelega != nil
      ( dbfDelega )->( dbCloseArea() )
   end if

   if dbfPedCliT != nil
      ( dbfPedCliT )->( dbCloseArea() )
   end if

   if dbfPedCliL != nil
      ( dbfPedCliL )->( dbCloseArea() )
   end if

   if dbfCount != nil
      ( dbfCount )->( dbCloseArea() )
   end if

   if dbfEmp != nil
      ( dbfEmp )->( dbCloseArea() )
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

   if dbfSitua != nil
      ( dbfSitua )->( dbCloseArea() )
   end if

   if dbfClient != nil
      ( dbfClient )->( dbCloseArea() )
   end if

   if oStock != nil
      oStock:end()
   end if

   if !Empty( oUndMedicion )
      oUndMedicion:end()
   end if

   dbfPedPrvT  := nil
   dbfPedPrvL  := nil
   dbfPedPrvI  := nil
   dbfPrv      := nil
   dbfIva      := nil
   dbfFPago    := nil
   dbfDiv      := nil
   dbfKit      := nil
   dbfArticulo := nil
   dbfCodebar  := nil
   dbfFamilia  := nil
   dbfAlm      := nil
   dbfUsr      := Nil
   dbfCajT     := nil
   oStock      := nil
   oBandera    := nil
   dbfInci     := nil
   dbfPedCliR  := nil
   dbfDelega   := nil
   dbfPedCliT  := nil
   dbfPedCliL  := nil
   dbfCount    := nil
   dbfEmp      := nil
   dbfFacPrvL  := nil
   dbfRctPrvL  := nil
   dbfAlbCliL  := nil
   dbfFacCliL  := nil
   dbfFacRecL  := nil
   dbfTikCliL  := nil
   dbfProLin   := nil
   dbfProMat   := nil
   dbfHisMov   := nil
   dbfSitua    := nil
   dbfClient   := nil

   lOpenFiles  := .f.

   oWndBrw     := nil

   EnableAcceso()

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION PedPrv( oMenuItem, oWnd, cCodPrv, cCodArt )

   local oPrv
   local oImp
   local oSnd
   local oDel
   local oRpl
   local oPdf
   local oMail
   local oRotor
   local oBtnEur
   local nLevel
   local lEuro          := .f.

   DEFAULT oMenuItem    := _MENUITEM_
   DEFAULT oWnd         := oWnd()
   DEFAULT cCodPrv      := ""
   DEFAULT cCodArt      := ""

   /*
   Obtenemos el nivel de acceso------------------------------------------------
   */

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return .f.
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !OpenFiles()
      return .f.
   end if

   DisableAcceso()

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "Pedidos a proveedores" ;
      PROMPT   "Número",;
               "Fecha",;
               "Entrada",;
               "Código",;
               "Nombre proveedor";
      MRU      "Clipboard_empty_businessman_16";
      BITMAP   Rgb( 0, 114, 198 ) ;
      ALIAS    ( dbfPedPrvT );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, dbfPedPrvT, cCodPrv, cCodArt ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, dbfPedPrvT, cCodPrv, cCodArt ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, dbfPedPrvT, cCodPrv, cCodArt ) );
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdtRec, dbfPedPrvT ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfPedPrvT, {|| QuiPedPrv() } ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

	oWndBrw:lFechado     := .t.
      oWndBrw:bChgIndex    := {|| if( oUser():lFiltroVentas(), CreateFastFilter( cFiltroUsuario, dbfPedPrvT, .f., , cFiltroUsuario ), CreateFastFilter( "", dbfPedPrvT, .f. ) ) }
	oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfPedPrvT )->lCloPed }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Zoom16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfPedPrvT )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Lbl16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Estado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| Max( ( dbfPedPrvT )->nEstado, 1 ) }
         :nWidth           := 20
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "trafficlight_on_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed ) }
         :nWidth           := 20
         :lHide            := .t.
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
         :AddResource( "Informacion_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Impreso"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfPedPrvT )->lImprimido }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "IMP16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumPed"
         :bEditValue       := {|| ( dbfPedPrvT )->cSerPed + "/" + Alltrim( Str( ( dbfPedPrvT )->nNumPed ) ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( dbfPedPrvT )->cSufPed }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( dbfPedPrvT )->cTurPed, "######" ) }
         :nWidth           := 60
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecPed"
         :bEditValue       := {|| Dtoc( ( dbfPedPrvT )->dFecPed ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( dbfPedPrvT )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( dbfPedPrvT )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Entrada"
         :cSortOrder       := "dFecEnt"
         :bEditValue       := {|| Dtoc( ( dbfPedPrvT )->dFecEnt ) }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Situación"
         :cSortOrder       := "cSituac"
         :bEditValue       := {|| ( dbfPedPrvT )->cSituac }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPrv"
         :bEditValue       := {|| ( dbfPedPrvT )->cCodPrv }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre proveedor"
         :cSortOrder       := "cNomPrv"
         :bEditValue       := {|| ( dbfPedPrvT )->cNomPrv }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( dbfPedPrvT )->nTotNet }
         :cEditPicture     := cPirDiv( ( dbfPedPrvT )->cDivPed, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( dbfPedPrvT )->nTotIva }
         :cEditPicture     := cPirDiv( ( dbfPedPrvT )->cDivPed, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( dbfPedPrvT )->nTotReq }
         :cEditPicture     := cPirDiv( ( dbfPedPrvT )->cDivPed, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( dbfPedPrvT )->nTotPed }
         :cEditPicture     := cPirDiv( ( dbfPedPrvT )->cDivPed, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( dbfPedPrvT )->cDivPed ), dbfDiv ) }
         :nWidth           := 30
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cliente"
         :bEditValue       := {|| if( !Empty( ( dbfPedPrvT )->cNumPedCli ), AllTrim( GetCodCli( ( dbfPedPrvT )->cNumPedCli ) ) + " - " + AllTrim( GetNomCli( ( dbfPedPrvT )->cNumPedCli ) ), "" ) }
         :nWidth           := 280
         :lHide            := .t.
      end with

      oWndBrw:cHtmlHelp    := "Pedido a proveedor"

      oWndBrw:CreateXFromCode()

   DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar";
      HOTKEY   "B"

   oWndBrw:AddSeaBar()

   DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecAdd() );
      ON DROP  ( oWndBrw:RecDup() );
      TOOLTIP  "(A)ñadir";
      BEGIN GROUP;
      HOTKEY   "A";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDup() );
      TOOLTIP  "(D)uplicar";
      HOTKEY   "D";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecEdit() );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecZoom() );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL oDel RESOURCE "DEL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDel() );
      MENU     This:Toggle() ;
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL oPrv RESOURCE "IMP" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( GenPedPrv( IS_PRINTER ) ) ;
      MENU     This:Toggle() ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenPed( oWndBrw:oBrw, oPrv, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "SERIE1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( PrnSerie( oWndBrw:oBrw), oWndBrw:Refresh() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oImp RESOURCE "PREV1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( GenPedPrv( IS_SCREEN ), oWndBrw:Refresh() ) ;
      MENU     This:Toggle() ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenPed( oWndBrw:oBrw, oImp, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenPedPrv( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenPed( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "Mail" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenPedPrv( IS_MAIL ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

      lGenPed( oWndBrw:oBrw, oMail, IS_MAIL ) ;

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "ChgState" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ChgState( oWndBrw:oBrw ) ) ;
         TOOLTIP  "Cambiar Es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oSnd RESOURCE "Lbl" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      TOOLTIP  "En(v)iar" ;
      MESSAGE  "Seleccionar pedidos para ser enviados" ;
      ACTION   lSnd( oWndBrw, dbfPedPrvT ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O";

   if oUser():lAdministrador()

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         ACTION   ( ReplaceCreator( oWndBrw, dbfPedPrvT, aItmPedPrv() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( ReplaceCreator( oWndBrw, dbfPedPrvL, aColPedPrv() ) ) ;
            TOOLTIP  "Lineas" ;
            FROM     oRpl ;
            CLOSED ;
            LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL RESOURCE "SHOPPINGCART" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( Generador( oWndBrw:oBrw ) ) ;
      TOOLTIP  "(G)enerar" ;
      HOTKEY   "G";

   DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TTrazaDocumento():Activate( PED_PRV, ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed ) ) ;
      TOOLTIP  "I(n)forme documento" ;
      HOTKEY   "N" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "BUSINESSMAN_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( EdtPrv( ( dbfPedPrvT )->cCodPrv ) );
         TOOLTIP  "Modificar proveedor" ;
         FROM     oRotor ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( InfProveedor( ( dbfPedPrvT )->cCodPrv ) );
         TOOLTIP  "Informe proveedor" ;
         FROM     oRotor ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "DOCUMENT_PLAIN_BUSINESSMAN_" OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( if( ( dbfPedPrvT )->nEstado == 3, MsgStop( "Pedido recibido" ), AlbPrv( nil, oWnd, nil, nil, ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed ) ) );
         TOOLTIP  "Generar albarán" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "DOCUMENT_PLAIN_BUSINESSMAN_" OF oWndBrw ;
         ACTION   ( Ped2Alb( ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed ) );
         TOOLTIP  "Modificar albarán" ;
         FROM     oRotor ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if !oUser():lFiltroVentas()
      oWndBrw:oActiveFilter:SetFields( aItmPedPrv() )
      oWndBrw:oActiveFilter:SetFilterType( PED_PRV )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   EnableAcceso()

   if !Empty( cCodPrv ) .or. !Empty( cCodArt )

      if !Empty( oWndBrw )
         oWndBrw:RecAdd()
      end if

      cCodPrv  := nil
      cCodArt  := nil

   end if

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfPedPrvT, oBrw, cCodPrv, cCodArt, nMode )

   local oDlg
   local oFld
   local oBrwLin
   local oBrwInc
   local oBrwDoc
   local oSay                 := Array( 5 )
   local cSay                 := Array( 5 )
   local oSayLabels           := Array( 7 )
   local oBmpDiv
   local oBmpEmp
   local cEstPed
   local oGetMasDiv
   local cGetMasDiv           := ""
   local cTlfPrv
   local oTlfPrv
   local oPedCli
   local oCodCli
   local oNomCli
   local cCodCli              := GetCodCli( aTmp[ _CNUMPEDCLI ] )
   local cNomCli              := GetNomCli( aTmp[ _CNUMPEDCLI ] )
   local oBmpGeneral

   /*
   Este valor los guaradamos para detectar los posibles cambios
   */

   cOldCodCli                 := aTmp[ _CCODPRV ]
   cPicUnd                    := MasUnd()                               // Picture de las unidades

   do case
   case nMode  == APPD_MODE

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CSERPED ]        := cNewSer( "nPedPrv" )
      aTmp[ _CTURPED ]        := cCurSesion()
      aTmp[ _CCODCAJ ]        := oUser():cCaja()
      aTmp[ _CCODALM ]        := oUser():cAlmacen()
      aTmp[ _CDIVPED ]        := cDivEmp()
      aTmp[ _NVDVPED ]        := nChgDiv( aTmp[ _CDIVPED ], dbfDiv )
      aTmp[ _CSUFPED ]        := RetSufEmp()
      aTmp[ _LSNDDOC ]        := .t.
      aTmp[ _NESTADO ]        := 1
      aTmp[ _CCODUSR ]        := cCurUsr()
      aTmp[ _CCODDLG ]        := oUser():cDelegacion()
      if !Empty( cCodPrv )
         aTmp[ _CCODPRV ]     := cCodPrv
      end if

   case nMode == DUPL_MODE
      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CTURPED ]        := cCurSesion()
      aTmp[ _CCODCAJ ]        := oUser():cCaja()
      aTmp[ _LSNDDOC ]        := .t.
      aTmp[ _LCLOPED ]        := .f.
      aTmp[ _NESTADO ]        := 1

   case nMode == EDIT_MODE

      if aTmp[ _NESTADO ] == 3
         msgStop( "El pedido ya fue recibido." )
         Return .f.
      end if

      if aTmp[ _LCLOPED ] .AND. !oUser():lAdministrador()
         msgStop( "Solo puede modificar los pedidos cerrados los administradores." )
         Return .f.
      end if

   end case

   /*
   Comineza la transaccion-----------------------------------------------------
   */

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   if aTmp[ _NESTADO ] == 0
      aTmp[ _NESTADO ]  := 1
   end if

   do case
   case  aTmp[ _NESTADO ] == 1
      cEstPed           := "Pendiente"
   case  aTmp[ _NESTADO ] == 2
      cEstPed           := "Parcial"
   case  aTmp[ _NESTADO ] == 3
      cEstPed           := "Recibido"
   end case

   if Empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]  := Padr( "General", 50 )
   end if

   if Empty( aTmp[ _CDPP ] ) 
      aTmp[ _CDPP ]     := Padr( "Pronto pago", 50 )
   end if

   /*
   Etiquetas-------------------------------------------------------------------
   */

   cSay[ 1 ]            := RetFld( aTmp[ _CCODALM ], dbfAlm )
   cSay[ 2 ]            := RetFld( aTmp[ _CCODPGO ], dbfFPago )
   cSay[ 3 ]            := RetFld( aTmp[ _CCODCAJ ], dbfCajT )
   cSay[ 4 ]            := RetFld( aTmp[ _CCODPRV ], dbfPrv )
   cTlfPrv              := RetFld( aTmp[ _CCODPRV ], dbfPrv, "Telefono" )
   cUsr                 := RetFld( aTmp[ _CCODUSR ], dbfUsr, "cNbrUse" )
   cSay[ 5 ]            := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )

   DEFINE DIALOG oDlg RESOURCE "PEDPRV" TITLE LblTitle( nMode ) + "pedidos a proveedores"

	REDEFINE FOLDER oFld ID 400 OF oDlg ;
         PROMPT   "&Pedido",  "Da&tos",   "&Incidencias",   "D&ocumentos" ;
         DIALOGS  "PEDPRV_1", "PEDPRV_2", "PEDCLI_3",       "PEDCLI_4"

      // cuadro del usuario

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID       215 ;
         WHEN     ( .f. ) ;
         VALID    ( SetUsuario( aGet[ _CCODUSR ], oUsr, nil, dbfUsr ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET oUsr VAR cUsr ;
         ID       216 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      // Datos del proveedor_________________________________________________

      REDEFINE BITMAP oBmpGeneral ;
            ID          990 ;
            RESOURCE    "Pedidos_proveedores_48_alpha" ;
            TRANSPARENT ;
            OF          oFld:aDialogs[1]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "folder2_red_alpha_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[2]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "information_48_alpha" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[3]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "address_book2_alpha_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[4]

      REDEFINE GET aGet[_CCODPRV] VAR aTmp[_CCODPRV] ;
			ID 		140 ;
			COLOR 	CLR_GET ;
			PICTURE	( RetPicCodPrvEmp() ) ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( LoaPrv( aGet, aTmp, dbfPrv, nMode, oSay[ 4 ], oTlfPrv ) ) ;
         ON HELP  ( BrwProvee( aGet[_CCODPRV], oSay[ 4 ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMPRV] VAR aTmp[ _CNOMPRV ];
			ID 		141 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CDNIPRV] VAR aTmp[_CDNIPRV] ;
         ID       145 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oTlfPrv VAR cTlfPrv ;
         ID       146 ;
         WHEN     ( .f. );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDIRPRV ] VAR aTmp[ _CDIRPRV ] ;
         ID       142 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         BITMAP   "Environnment_View_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRPRV ], Rtrim( aTmp[ _CPOBPRV ] ) + Space( 1 ) + Rtrim( aTmp[ _CPROPRV ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOSPRV ] VAR aTmp[ _CPOSPRV ] ;
         ID       143 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOBPRV ] VAR aTmp[ _CPOBPRV ] ;
         ID       144 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPROPRV ] VAR aTmp[ _CPROPRV ] ;
         ID       147 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_CCODALM] VAR aTmp[_CCODALM]	;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[_CCODALM], dbfAlm, oSay[ 1 ] ) ) ;
         ON HELP  ( BrwAlmacen( aGet[_CCODALM], oSay[ 1 ] ) ) ;
         BITMAP   "LUPA" ;
         COLOR    CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 1 ] VAR cSay[ 1 ] ;
         WHEN     .f. ;
			ID 		151 ;
			OF 		oFld:aDialogs[1] ;

      REDEFINE GET aGet[_CCODPGO] VAR aTmp[_CCODPGO];
			ID 		160 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cFPago( aGet[_CCODPGO], dbfFPago, oSay[ 2 ] ) ;
         ON HELP  BrwFPago( aGet[_CCODPGO ], oSay[ 2 ]) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ];
			ID 		161 ;
         WHEN     .f. ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      /*
		Cajas____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], dbfCajT, oSay[ 3 ] ) ;
         ID       165 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oSay[ 3 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ] ;
         ID       166 ;
         WHEN     .f. ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

		/*
		Moneda__________________________________________________________________
		*/

		REDEFINE GET aGet[ _CDIVPED ] VAR aTmp[ _CDIVPED ];
         WHEN     ( nMode == APPD_MODE .AND. ( dbfTmpLin )->( LastRec() ) == 0 ) ;
         VALID    ( cDivIn( aGet[ _CDIVPED ], oBmpDiv, aGet[ _NVDVPED ], @cPinDiv, @nDinDiv, @cPirDiv, @nDirDiv, oGetMasDiv, dbfDiv, oBandera ) );
			PICTURE	"@!";
			ID 		170 ;
			COLOR 	CLR_GET ;
         ON HELP  BrwDiv( aGet[ _CDIVPED ], oBmpDiv, aGet[ _NVDVPED ], dbfDiv, oBandera ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
			ID 		171;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NVDVPED ] VAR aTmp[ _NVDVPED ];
			WHEN 		( .F. ) ;
			ID 		180 ;
			PICTURE	"@E 999,999.9999" ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		/*
		Bitmap________________________________________________________________
		*/

      REDEFINE BITMAP oBmpEmp ;
         FILE     "Bmp\ImgPedPrv.bmp" ;
         ID       500 ;
         OF       oDlg ;

		/*
		Detalle________________________________________________________________
		*/

      /*
      Precios de compra por propiedades----------------------------------------
      */

      oBrwLin                 := IXBrowse():New( oFld:aDialogs[1] )

      oBrwLin:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLin:cAlias          := dbfTmpLin

      oBrwLin:nMarqueeStyle   := 6
      oBrwLin:cName           := "Lineas de pedidos a proveedor"

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Número"
            :bEditValue       := {|| if( ( dbfTmpLin )->lKitChl, "", Trans( ( dbfTmpLin )->nNumLin, "9999" ) ) }
            :nWidth           := 65
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Es. Estado"
            :bStrData         := {|| "" }
            :bBmpData         := {|| nTotRecibido( dbfTmpLin, dbfAlbPrvL ) }
            :nWidth           := 20
            :AddResource( "Bullet_Square_Red_16" )
            :AddResource( "Bullet_Square_Yellow_16" )
            :AddResource( "Bullet_Square_Green_16" )
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Código"
            :bEditValue       := {|| ( dbfTmpLin )->cRef }
            :nWidth           := 80
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "C. Barras"
            :bEditValue       := {|| cCodigoBarrasDefecto( ( dbfTmpLin )->cRef, dbfCodeBar ) }
            :nWidth           := 100
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Código proveedor"
            :bEditValue       := {|| ( dbfTmpLin )->cRefPrv }
            :nWidth           := 80
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| if( Empty( ( dbfTmpLin )->cRef ), ( dbfTmpLin )->mLngDes, ( dbfTmpLin )->cDetalle ) }
            :nWidth           := 280
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Prop. 1"
            :bEditValue       := {|| ( dbfTmpLin )->cValPr1 }
            :nWidth           := 60
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Prop. 2"
            :bEditValue       := {|| ( dbfTmpLin )->cValPr2 }
            :nWidth           := 60
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Lote"
            :bEditValue       := {|| ( dbfTmpLin )->cLote }
            :nWidth           := 80
            :lHide            := .t.
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := cNombreUnidades()
            :bEditValue       := {|| nTotNPedPrv( dbfTmpLin ) }
            :cEditPicture     := cPicUnd
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "UM. Unidad de medición"
            :bEditValue       := {|| ( dbfTmpLin )->cUnidad }
            :nWidth           := 25
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Almacen"
            :bEditValue       := {|| ( dbfTmpLin )->cAlmLin }
            :nWidth           := 60
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Importe"
            :bEditValue       := {|| nTotUPedPrv( dbfTmpLin, nDinDiv ) }
            :cEditPicture     := cPinDiv
            :nWidth           := 90
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "% Dto."
            :bEditValue       := {|| ( dbfTmpLin )->nDtoLin }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 50
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "% Prm."
            :bEditValue       := {|| ( dbfTmpLin )->nDtoPrm }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 40
            :lHide            := .t.
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "% " + cImp()
            :bEditValue       := {|| ( dbfTmpLin )->nIva }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 50
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( oBrwLin:AddCol() )
            :cHeader          := "Total"
            :bEditValue       := {|| nTotLPedPrv( dbfTmpLin, nDinDiv, nDirDiv ) }
            :cEditPicture     := cPirDiv
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         if nMode != ZOOM_MODE
            oBrwLin:bLDblClick   := {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) }
         end if

         oBrwLin:CreateFromResource( 190 )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( AppDeta( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EdtDeta( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinDelRec( oBrwLin, dbfTmpLin, {|| delDeta() }, {|| RecalculaTotal( aTmp ) } ) )

		REDEFINE BUTTON ;
			ID 		503 ;
			OF 		oFld:aDialogs[1] ;
         ACTION   ( EdtZoom( oBrwLin, bEdtDet, aTmp ) )

		REDEFINE BUTTON ;
			ID 		524 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( DbSwapUp( dbfTmpLin, oBrwLin ) )

		REDEFINE BUTTON ;
			ID 		525 ;
			OF 		oFld:aDialogs[1] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( DbSwapDown( dbfTmpLin, oBrwLin ) )

      /*
		Descuentos______________________________________________________________
		*/

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         ID       199 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
			ID 		200 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
			COLOR 	CLR_GET ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         ID       209 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[ _NDPP ] VAR aTmp[ _NDPP ];
			ID 		210 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
			COLOR 	CLR_GET ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
			ID 		240 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTOUNO ] VAR aTmp[ _NDTOUNO ];
			ID 		250 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
			COLOR 	CLR_GET ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         ID       260 ;
			PICTURE 	"@!" ;
         COLOR    CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NDTODOS ] VAR aTmp[ _NDTODOS ];
         ID       270 ;
			PICTURE 	"@E 99.99" ;
         SPINNER ;
         COLOR    CLR_GET ;
         ON CHANGE( RecalculaTotal( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      /*
      Desglose del impuestos---------------------------------------------------------
      */

      oBrwIva                        := TXBrowse():New( oFld:aDialogs[ 1 ] )

      oBrwIva:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwIva:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwIva:SetArray( aTotIva )

      oBrwIva:lHScroll               := .f.
      oBrwIva:lVScroll               := .f.
      oBrwIva:nMarqueeStyle          := 5
      oBrwIva:lRecordSelector        := .f.

      oBrwIva:CreateFromResource( 490 )

      with object ( oBrwIva:aCols[ 1 ] )
         :cHeader       := "Bruto"
         :bStrData      := {|| if( !Empty( aTotIva[ oBrwIva:nArrayAt, 1 ] ), Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPirDiv ), "" ) }
         :nWidth        := 106
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 2 ] )
         :cHeader       := "Base"
         :bStrData      := {|| if( !Empty( aTotIva[ oBrwIva:nArrayAt, 2 ] ), Trans( aTotIva[ oBrwIva:nArrayAt, 2 ], cPirDiv ), "" ) }
         :nWidth        := 106
         :cEditPicture  := cPirDiv
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 3 ] )
         :cHeader       := "%" + cImp()
         :bStrData      := {|| if( !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ), aTotIva[ oBrwIva:nArrayAt, 3 ], "" ) }
         :bEditValue    := {|| aTotIva[ oBrwIva:nArrayAt, 3 ] }
         :nWidth        := 55
         :cEditPicture  := "@E 999.99"
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
         :nEditType     := 1
         :bEditWhen     := {|| !IsNil( aTotIva[ oBrwIva:nArrayAt, 3 ] ) }
         :bOnPostEdit   := {|o,x| EdtIva( o, x, aTotIva[ oBrwIva:nArrayAt, 3 ], dbfTmp, dbfIva, oBrwLin ), RecalculaTotal( aTmp ) }
      end with

      with object ( oBrwIva:aCols[ 4 ] )
         :cHeader       := "%R.E."
         :bStrData      := {|| if( !Empty( aTotIva[ oBrwIva:nArrayAt, 4 ] ) .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 4 ], "@E 99.9" ), "" ) }
         :nWidth        := 55
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 5 ] )
         :cHeader       := cImp()
         :bStrData      := {|| if( !Empty( aTotIva[ oBrwIva:nArrayAt, 5 ] ), Trans( aTotIva[ oBrwIva:nArrayAt, 5 ], cPirDiv ), "" ) }
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

      with object ( oBrwIva:aCols[ 6 ] )
         :cHeader       := "R.E."
         :bStrData      := {|| if( !Empty( aTotIva[ oBrwIva:nArrayAt, 6 ] ) .and. aTmp[ _LRECARGO ], Trans( aTotIva[ oBrwIva:nArrayAt, 6 ], cPirDiv ), "" ) }
         :nWidth        := 80
         :cEditPicture  := cPirDiv
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

		/*
		Cajas de Totales
		------------------------------------------------------------------------
		*/

		REDEFINE SAY oGetNet VAR nGetNeto ;
			ID 		370 ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY oGetIva VAR nGetIva ;
			ID 		380 ;
			OF 		oFld:aDialogs[1]

		REDEFINE SAY oGetReq VAR nGetReq ;
			ID 		390 ;
			OF 		oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _LRECARGO ] VAR aTmp[ _LRECARGO ] ;
			ID 		400 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ON CHANGE( RecalculaTotal( aTmp ) );
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetTotal VAR nTotPed ;
			ID 		410 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetMasDiv VAR cGetMasDiv;
         ID       420 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CSERPED ] VAR aTmp[ _CSERPED ] ;
         ID       690 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[_CSERPED] ) );
         ON DOWN  ( DwSerie( aGet[_CSERPED] ) );
         COLOR    CLR_GET ;
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[_CSERPED] >= "A" .AND. aTmp[_CSERPED] <= "Z"  );
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_NNUMPED] VAR aTmp[_NNUMPED];
			ID 		100 ;
			PICTURE 	"999999999" ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CSUFPED] VAR aTmp[_CSUFPED];
			ID 		105 ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_DFECPED] VAR aTmp[_DFECPED];
			ID 		110 ;
			SPINNER;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_NESTADO] VAR cEstPed;
         WHEN     .f. ;
         ID       120 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_DFECENT] VAR aTmp[_DFECENT] ;
         ID       125 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         SPINNER ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE COMBOBOX aGet[ _CSITUAC ] VAR aTmp[ _CSITUAC ] ;
         ID       218 ;
         WHEN     ( nMode != ZOOM_MODE );
         ITEMS    ( aSituacion( dbfSitua ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE RADIO aGet[ _NREGIVA ] VAR aTmp[ _NREGIVA ] ;
         ID       270, 271, 272, 273 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_NBULTOS] VAR aTmp[_NBULTOS] ;
         ID       130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         SPINNER ;
         PICTURE  "@E 999,999" ;
			COLOR 	CLR_GET ;
         OF       oFld:aDialogs[2]

      //Segunda caja de dialogo

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         ID       300 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oSay[ 5 ] VAR cSay[ 5 ] ;
         ID       301 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[_CSUPED] VAR aTmp[_CSUPED] ;
         ID       235 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[2]

      REDEFINE GROUP oSayLabels[ 1 ] ID 700 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   oSayLabels[ 2 ] ID 701 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 3 ] ID 702 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 4 ] ID 703 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 5 ] ID 704 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 6 ] ID 705 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 7 ] ID 706 OF oFld:aDialogs[ 1 ]

      /*
      Datos del envio----------------------------------------------------------
      */

      REDEFINE GET aGet[_CEXPED] VAR aTmp[_CEXPED];
         ID       180 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

      /*
      Observaciones------------------------------------------------------------
      */

      REDEFINE GET aGet[_COBSERV] VAR aTmp[_COBSERV];
			ID 		200 ;
         MEMO ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[2]

      REDEFINE GET oPedCli VAR aTmp[_CNUMPEDCLI] ;
         ID       230 ;
         WHEN     ( .f. ) ;
         PICTURE  "@R #/#########/##" ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oCodCli VAR cCodCli ;
         ID       210 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oNomCli VAR cNomCli ;
         ID       220 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[2]

      /*Impresión ( informa de si está impreimido o no y de cuando se imprimió )*/

      REDEFINE CHECKBOX aGet[ _LIMPRIMIDO ] VAR aTmp[ _LIMPRIMIDO ] ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _DFECIMP ] VAR aTmp[ _DFECIMP ] ;
         ID       121 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CHORIMP ] VAR aTmp[ _CHORIMP ] ;
         ID       122 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      /*
      Caja de diálogos de incidencias------------------------------------------
      */

      oBrwInc                 := IXBrowse():New( oFld:aDialogs[ 3 ] )

      oBrwInc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwInc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwInc:cAlias          := dbfTmpInc

      oBrwInc:nMarqueeStyle   := 5
      oBrwInc:cName           := "Incidencias de pedidos a proveedor"

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Resuelta"
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( dbfTmpInc )->lListo }
            :nWidth           := 65
            :SetCheck( { "Sel16", "Cnt16" } )
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Código"
            :bEditValue       := {|| ( dbfTmpInc )->cCodTip }
            :nWidth           := 80
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Incidencia"
            :bEditValue       := {|| cNomInci( ( dbfTmpInc )->cCodTip, dbfInci ) }
            :nWidth           := 250
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpInc )->dFecInc ) }
            :nWidth           := 90
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| ( dbfTmpInc )->mDesInc }
            :nWidth           := 390
         end with

         if nMode != ZOOM_MODE
            oBrwInc:bLDblClick   := {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) }
         end if

         oBrwInc:CreateFromResource( 210 )

      /*
      REDEFINE IBROWSE oBrwInc ;
			FIELDS ;
                  If( !(dbfTmpInc)->lListo, aDbfBmp[ 7 ], aDbfBmp[ 6 ] ),;
                  ( dbfTmpInc )->cCodTip ,;
                  cNomInci( ( dbfTmpInc )->cCodTip, dbfInci ) ,;
                  Dtoc( ( dbfTmpInc )->dFecInc ),;
                  ( dbfTmpInc )->mDesInc ;
			FIELDSIZES ;
                  20,;
                  55,;
                  100,;
                  80,;
                  400;
         HEAD ;
                  "R",;
                  "Cod. tipo" ,;
                  "Tipo de incidencia" ,;
                  "Fecha" ,;
                  "Incidencia";
         JUSTIFY  .t., .t., .t., .t., .t. ;
         ALIAS    ( dbfTmpInc );
			ID 		210 ;
         OF       oFld:aDialogs[ 3 ]

        if nMode != ZOOM_MODE
            oBrwInc:bDel         := {|| DelDeta( oBrwInc, aTmp ) }
         end if

         oBrwInc:cWndName        := "Pedido a proveedor.Incidencia"

         oBrwInc:LoadData()
      */

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[ 3 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[ 3 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oFld:aDialogs[ 3 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) )

		REDEFINE BUTTON ;
			ID 		503 ;
         OF       oFld:aDialogs[ 3 ] ;
         ACTION   ( WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) )

      oBrwDoc                 := TXBrowse():New( oFld:aDialogs[ 4 ] )

      oBrwDoc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDoc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDoc:cAlias          := dbfTmpDoc

      oBrwDoc:nMarqueeStyle   := 5
      oBrwDoc:nRowHeight      := 40
      oBrwDoc:nDataLines      := 2

         with object ( oBrwDoc:AddCol() )
            :cHeader          := "Documento"
            :bEditValue       := {|| Rtrim( ( dbfTmpDoc )->cNombre ) + CRLF + Space( 5 ) + Rtrim( ( dbfTmpDoc )->cRuta ) }
            :nWidth           := 885
         end with

         if nMode != ZOOM_MODE
            oBrwDoc:bLDblClick   := {|| ShellExecute( oDlg:hWnd, "open", Rtrim( ( dbfTmpDoc )->cRuta ) ) }
         end if

         oBrwDoc:CreateFromResource( 210 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[ 4 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[ 4 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oFld:aDialogs[ 4 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .f. ) )

		REDEFINE BUTTON ;
			ID 		503 ;
         OF       oFld:aDialogs[ 4 ] ;
         ACTION   ( WinZooRec( oBrwDoc, bEdtDoc, dbfTmpDoc ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oFld:aDialogs[ 4 ] ;
         ACTION   ( ShellExecute( oDlg:hWnd, "open", Rtrim( ( dbfTmpDoc )->cRuta ) ) )

		/*
      Botones comunes a la caja de dialogo_____________________________________
		*/

     REDEFINE BUTTON ;
         ID       4 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( RecalculaPedidoProveedores( aTmp, oDlg ), ( oBrwLin:Refresh() ), RecalculaTotal( aTmp ) )

     REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aGet, aTmp, oBrw, nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID       3 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aGet, aTmp, oBrw, nMode, oDlg ), GenPedPrv( IS_PRINTER ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( If( ExitNoSave( nMode, dbfTmpLin ), ( oDlg:end() ), ) )

      if nMode != ZOOM_MODE
         oFld:aDialogs[1]:AddFastKey( VK_F2, {|| AppDeta( oBrwLin, bEdtDet, aTmp ) } )
         oFld:aDialogs[1]:AddFastKey( VK_F3, {|| EdtDeta( oBrwLin, bEdtDet, aTmp ) } )
         oFld:aDialogs[1]:AddFastKey( VK_F4, {|| WinDelRec( oBrwLin, dbfTmpLin, {|| DelDeta() }, {|| RecalculaTotal( aTmp ) } ) } )

         oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
         oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
         oFld:aDialogs[3]:AddFastKey( VK_F4, {|| DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) } )

         oFld:aDialogs[4]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
         oFld:aDialogs[4]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
         oFld:aDialogs[4]:AddFastKey( VK_F4, {|| DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .f. ) } )

         oDlg:AddFastKey( VK_F5, {|| EndTrans( aGet, aTmp, oBrw, nMode, oDlg ) } )
         oDlg:AddFastKey( VK_F6, {|| if( EndTrans( aGet, aTmp, oBrw, nMode, oDlg ), GenPedPrv( IS_PRINTER ), ) } )
         oDlg:AddFastKey( VK_F7, {|| ImportarExcel( aTmp, dbfTmpLin, dbfArticulo, dbfDiv, oBrwLin ) } )
         oDlg:AddFastKey( 65,    {|| if( GetKeyState( VK_CONTROL ), CreateInfoArticulo(), ) } )
      end if

      oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

   do case
      case nMode == APPD_MODE .and. lRecogerUsuario() .and. Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), , oDlg:end() ) }

      case nMode == APPD_MODE .and. lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt ), oDlg:end() ) }

      case nMode == APPD_MODE .and. !lRecogerUsuario() .and. !Empty( cCodArt )
         oDlg:bStart := {|| AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt ) }

   end case

	ACTIVATE DIALOG oDlg	;
         ON INIT  (  EdtRecMenu( aGet, aTmp, oBrw, oBrwLin, nMode, oDlg ),;
                     ShowKitCom( dbfPedPrvT, dbfTmpLin, oBrwLin, cCodPrv, dbfTmpInc, aGet ),;
                     oBrwLin:Load(),;
                     oBrwInc:Load() ) ;
         ON PAINT (  RecalculaTotal( aTmp ) );
			CENTER

   KillTrans( oBrwLin )

   EndEdtRecMenu()

   oBmpDiv:end()
   oBmpEmp:end()
   oBmpGeneral:End()

   /*
   Guardamos los datos del browse----------------------------------------------
   */

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EdtRecMenu( aGet, aTmp, oBrw, oBrwLin, nMode, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            if !lExternal

            MENUITEM    "&1. Modificar proveedor";
               MESSAGE  "Modificar la ficha del proveedor" ;
               RESOURCE "Businessman_16";
               ACTION   ( EdtPrv( aTmp[ _CCODPRV ] ) )

            MENUITEM    "&2. Informe de proveedor";
               MESSAGE  "Abrir el informe del proveedor" ;
               RESOURCE "Info16";
               ACTION   ( InfProveedor( aTmp[ _CCODPRV ] ) );

            SEPARATOR

            end if

            MENUITEM    "&3. Informe del documento";
               MESSAGE  "Abrir el informe del documento" ;
               RESOURCE "Info16";
               ACTION   ( TTrazaDocumento():Activate( PED_PRV, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//----------------------------------------------------------------------------//

Static Function EndEdtRecMenu()

Return ( if( oMenu != nil, oMenu:End(), ) )

//---------------------------------------------------------------------------//

Static Function RecalculaPedidoProveedores( aTmp, oDlg )

   local nRecNum
   local nPreCom

   if !ApoloMsgNoYes( "¡Atención!,"                                      + CRLF + ;
                  "todos los precios se recalcularán en función de"  + CRLF + ;
                  "los valores en las bases de datos.",;
                  "¿ Desea proceder ?" )
      return nil
   end if

   oDlg:Disable()

   ( dbfArticulo )->( ordSetFocus( "Codigo" ) )

   nRecNum                          := ( dbfTmpLin )->( RecNo() )

   ( dbfTmpLin )->( dbGotop() )
   while !( dbfTmpLin )->( eof() )

      /*
      Ahora buscamos por el codigo interno
      */

      nPreCom                       := nComPro( ( dbfTmpLin )->cRef, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr2, dbfArtCom )

      if nPrecom  != 0

         ( dbfTmpLin )->nPreDiv     := nPreCom

      else

         if uFieldEmpresa( "lCosPrv", .f. )
            nPreCom                 := nPreArtPrv( aTmp[ _CCODPRV ], ( dbfTmpLin )->cRef, dbfArtPrv )
         end if

         if nPreCom != 0
            ( dbfTmpLin )->nPreDiv  := nPreCom
         else
            ( dbfTmpLin )->nPreDiv  := nCosto( ( dbfTmpLin )->cRef, dbfArticulo, dbfKit, .f., aTmp[ _CDIVPED ], dbfDiv )
         end if

         /*
         Descuento de articulo----------------------------------------------
         */

         if uFieldEmpresa( "lCosPrv", .f. )

            nPreCom                    := nDtoArtPrv( aTmp[ _CCODPRV ], ( dbfTmpLin )->cRef, dbfArtPrv )

            if nPreCom != 0
               ( dbfTmpLin )->nDtoLin  := nPreCom
            end if

         /*
         Descuento de promocional----------------------------------------------
         */

            nPreCom                    := nPrmArtPrv( aTmp[ _CCODPRV ], ( dbfTmpLin )->cRef, dbfArtPrv )

            if nPreCom != 0
               ( dbfTmpLin )->nDtoPrm  := nPreCom
            end if

         end if

      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRecNum ) )

   oDlg:Enable()

Return nil

//---------------------------------------------------------------------------//

Static Function EdtDoc( aTmp, aGet, dbfPedPrvD, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oRuta
   local oNombre
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de pedido a proveedor"

      REDEFINE GET oNombre VAR aTmp[ ( dbfTmpDoc )->( FieldPos( "cNombre" ) ) ] ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oRuta VAR aTmp[ ( dbfTmpDoc )->( FieldPos( "cRuta" ) ) ] ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "FOLDER" ;
         ON HELP  ( oRuta:cText( cGetFile( 'Doc ( *.* ) | ' + '*.*', 'Seleccione el nombre del fichero' ) ) ) ;
         OF       oDlg

      REDEFINE GET oObservacion VAR aTmp[ ( dbfTmpDoc )->( FieldPos( "mObsDoc" ) ) ] ;
         MEMO ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, nil, dbfTmpDoc, oBrw, nMode ), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| WinGather( aTmp, nil, dbfTmpDoc, oBrw, nMode ), oDlg:end( IDOK ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbfPedPrvI, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oNomInci
   local cNomInci

   if !Empty( aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ] )
      cNomInci          := cNomInci( aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], dbfInci )
   end if

   if nMode == APPD_MODE
      aTmp[ _CSERPED  ] := aTmpLin[ _CSERPED ]
      aTmp[ _NNUMPED  ] := aTmpLin[ _NNUMPED ]
      aTmp[ _CSUFPED  ] := aTmpLin[ _CSUFPED ]
      if IsMuebles()
         aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ]  := .t.
      end if
   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de pedido a proveedor"

      REDEFINE GET aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ];
         VAR      aTmp[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE );
         VALID    ( cTipInci( aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], dbfInci, oNomInci ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIncidencia( dbfInci, aGet[ ( dbfTmpInc )->( FieldPos( "cCodTip" ) ) ], oNomInci ) ) ;
         OF       oDlg

      REDEFINE GET oNomInci VAR cNomInci;
         WHEN     .f. ;
         ID       130 ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfTmpInc )->( FieldPos( "dFecInc" ) ) ] ;
         ID       100 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfTmpInc )->( FieldPos( "mDesInc" ) ) ] ;
         MEMO ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfTmpInc )->( FieldPos( "lListo" ) ) ] ;
         ID       140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ] ;
         ID       150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, nil, dbfTmpInc, oBrw, nMode ), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| WinGather( aTmp, nil, dbfTmpInc, oBrw, nMode ), oDlg:end( IDOK ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function ImportarExcel( aTmpPed, dbfTmpLin, dbfArticulo, dbfDiv, oBrw )

   local n
   local m
   local nUnidad
   local nCajas
   local cCodigo
   local cProp1
   local cProp2
   local oOleExcel
   local cFileExcel
   local nCompro

   cFileExcel        := cGetFile( "Excel ( *.Xls ) | " + "*.Xls", "Seleccione la hoja de calculo" )

   if File( cFileExcel )

      oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      oOleExcel:oExcel:Visible         := .t.
      oOleExcel:oExcel:DisplayAlerts   := .f.
      oOleExcel:oExcel:WorkBooks:Open( cFileExcel )

      for m := 1 to 3

         oOleExcel:oExcel:WorkSheets( m ):Activate()

         for n := 9 to 33

            nUnidad  := oOleExcel:oExcel:ActiveSheet:Range( "C" + lTrim( Str( n ) ) ):Value
            nCajas   := oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value
            cCodigo  := oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value

            if !Empty( nUnidad ) .and. !Empty( nCajas ) .and. !Empty( cCodigo )
               cProp1   := Str( nCajas, 3 )
               cProp2   := StrTran( cCodigo, "V", "T" )
               cCodigo  := "2044" + StrTran( Str( nCajas, 3 ), Space( 1 ), "0" )

               /*
               Buscamos el articulo en la tabla--------------------------------
               */

               if ( dbfArticulo )->( dbSeek( cCodigo ) )

                  ( dbfTmpLin )->( dbAppend() )
                  ( dbfTmpLin )->nNumLin     := nLastNum( dbfTmpLin )
                  ( dbfTmpLin )->cRef        := ( dbfArticulo )->Codigo
                  ( dbfTmpLin )->cDetalle    := ( dbfArticulo )->Nombre
                  ( dbfTmpLin )->cCodPr1     := "1"
                  ( dbfTmpLin )->cValPr1     := cProp1
                  ( dbfTmpLin )->cCodPr2     := "2"
                  ( dbfTmpLin )->cValPr2     := cProp2
                  ( dbfTmpLin )->nIva        := nIva( dbfIva, ( dbfArticulo )->TipoIva )
                  ( dbfTmpLin )->cAlmLin     := aTmpPed[ _CCODALM ]
                  ( dbfTmpLin )->nCanPed     := nCajas / 100
                  ( dbfTmpLin )->nUniCaja    := nUnidad

                  /*
                  Tratamos de obtener el precio por propiedades
                  */

                  nComPro                    := nComPro( ( dbfTmpLin )->cRef, ( dbfTmpLin )->cCodPr1, ( dbfTmpLin )->cValPr1, ( dbfTmpLin )->cCodPr2, ( dbfTmpLin )->cValPr2, dbfArtCom )
                  if nComPro != 0
                     ( dbfTmpLin )->nPreDiv  := nCnv2Div( nComPro, cDivEmp(), aTmpPed[ _CDIVPED ], dbfDiv )
                  else
                     ( dbfTmpLin )->nPreDiv  := nCnv2Div( ( dbfArticulo )->pCosto, cDivEmp(), aTmpPed[ _CDIVPED ], dbfDiv )
                  end if

                  ( dbfTmpLin )->( dbUnLock() )

               end if

            end if

         next

      next

      oOleExcel:oExcel:Quit()

      oOleExcel:oExcel:DisplayAlerts := .t.

      oOleExcel:End()

      ( dbfTmpLin )->( dbGoTop() )

      oBrw:Refresh()

   end if

Return nil

//---------------------------------------------------------------------------//
/*
Funcion Auxiliar para A¤adir lineas de detalle a un pedido
*/

STATIC FUNCTION AppDeta( oBrwLin, bEdtDet, aTmp, cCodArt )

   WinAppRec( oBrwLin, bEdtDet, dbfTmpLin, aTmp, cCodArt )

Return ( RecalculaTotal( aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Edici¢n de Lineas de Detalle en un pedido
*/
STATIC FUNCTION EdtDeta( oBrwLin, bEdtDet, aTmp )

   WinEdtRec( oBrwLin, bEdtDet, dbfTmpLin, aTmp )

Return ( RecalculaTotal( aTmp ) )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para borrar las Lineas de Detalle en un pedido
*/

STATIC FUNCTION DelDeta()

   if ( dbfTmpLin )->lKitArt
      dbDelKit( , dbfTmpLin, ( dbfTmpLin )->nNumLin )
   end if

Return ( .t. )

//--------------------------------------------------------------------------//

/*
Funcion Auxiliar para la Visualizaci¢n de Lineas de Detalle en una Abono
*/

STATIC FUNCTION EdtZoom( oBrwLin, bEdtDet, aTmp )

   WinZooRec( oBrwLin, bEdtDet, dbfTmpLin, aTmp )

RETURN NIL

//--------------------------------------------------------------------------//

/*
Edita las lineas de Detalle
*/

STATIC FUNCTION EdtDet( aTmp, aGet, dbfPedPrvL, oBrw, aTmpPed, cCodArt, nMode )

   local oDlg
   local oFld
   local oBmp
   local oBtn
   local oSay2
   local cSay2
   local oSayPr1
   local oSayPr2
   local cSayPr1        := ""
   local cSayPr2        := ""
   local oSayVp1
   local oSayVp2
   local cSayVp1        := ""
   local cSayVp2        := ""
   local oTotal
   local nTotal         := 0
   local oGet1
   local oGetStk
   local nGetStk        := 0
   local oGetIra
   local cGetIra        := Space( 50 )
   local oSayLote
   local nTotRes
   local oTotUni
   local oTotEnt
   local oTotPdt
   local oBrwAlb
   local nOrdAnt
   local oBrwPrp
   local cNumPed        := aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ]

   cOldCodArt           := aTmp[ _CREF ]
   cOldUndMed           := aTmp[ _CUNIDAD ]

   if nMode == APPD_MODE

      aTmp[_NUNICAJA]   := 1
      aTmp[_CALMLIN ]   := aTmpPed[ _CCODALM ]

      if !Empty( cCodArt )
         aTmp[ _CREF ]  := cCodArt
      end if

   else

      nGetStk           := oStock:nPutStockActual( aTmp[ _CREFPRV ], aTmp[ _CALMLIN ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ] )

   end if

   nTotRes              := nUnidadesRecibidasPedPrv( aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ], aTmp[ _CREF ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CREFPRV ], aTmp[ _CDETALLE ], dbfAlbPrvL )

   if nTotRes > nTotNPedPrv( aTmp )
      nTotRes           := nTotNPedPrv( aTmp )
   end if

   nOrdAnt              := ( dbfAlbPrvL )->( OrdSetFocus( "cPedPrvRef" ) )

   ( dbfAlbPrvL )->( OrdScope( 0, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] + aTmp[ _CREF ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ] + aTmp[ _CLOTE ] ) )
   ( dbfAlbPrvL )->( OrdScope( 1, aTmp[ _CSERPED ] + Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ] + aTmp[ _CREF ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ] + aTmp[ _CLOTE ] ) )
   ( dbfAlbPrvL )->( dbGoTop() )

   DEFINE DIALOG  oDlg ;
      RESOURCE    "LPEDPRV" ;
      TITLE       LblTitle( nMode ) + "líneas a pedidos de proveedores"

	REDEFINE FOLDER oFld ID 400 OF oDlg ;
         PROMPT   "&General"  , "Da&tos",    "&Anular",     "&Observaciones" ;
         DIALOGS  "LFACPRV_1" , "LPEDPRV_2", "LFACPRV_4",   "LFACPRV_6"

      REDEFINE GET aGet[ _CREF ] VAR aTmp[ _CREF ];
	   ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( LoaArt( aGet, aTmp, nMode, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oGetIra, oDlg, oBmp, oGetStk ) );
         ON HELP  ( BrwArticulo( aGet[ _CREF ], aGet[ _CDETALLE ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      /*
      Lotes
      ------------------------------------------------------
      */

      REDEFINE SAY oSayLote;
         ID       111 ;
	   OF 	oFld:aDialogs[1]

      REDEFINE GET aGet[ _CLOTE ] VAR aTmp[ _CLOTE ];
         ID       112 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
	   OF 	oFld:aDialogs[1]

      REDEFINE GET aGet[_CDETALLE] VAR aTmp[_CDETALLE] ;
	     ID 		120 ;
         WHEN     ( ( lModDes() .or. Empty( aTmp[ _CDETALLE ] ) ) .AND. nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_MLNGDES] VAR aTmp[_MLNGDES] ;
			MEMO ;
			ID 		121 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      /*
      Propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CVALPR1 ] VAR aTmp[ _CVALPR1 ];
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR1 ], oSayVp1, aTmp[ _CCODPR1 ], dbfTblPro ),;
                        LoaArt( aGet, aTmp, nMode, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oGetIra, oDlg, oBmp, oGetStk ),;
                        .f. ) ) ;
         ON HELP  ( brwPrpAct( aGet[ _CVALPR1 ], oSayVp1, aTmp[_CCODPR1 ] ) ) ;
	   OF 		oFld:aDialogs[1]

         aGet[ _CVALPR1 ]:bChange   := {|| aGet[ _CVALPR1 ]:Assign(), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk ) }

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       221 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       222 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CVALPR2 ] VAR aTmp[ _CVALPR2 ];
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         VALID    ( if( lPrpAct( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ], dbfTblPro ),;
                        LoaArt( aGet, aTmp, nMode, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oGetIra, oDlg, oBmp, oGetStk ),;
                        .f. ) ) ;
         ON HELP  ( brwPrpAct( aGet[ _CVALPR2 ], oSayVp2, aTmp[ _CCODPR2 ] ) ) ;
			OF 		oFld:aDialogs[1]

         aGet[ _CVALPR2 ]:bChange   := {|| aGet[ _CVALPR2 ]:Assign(), oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk ) }

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       231 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       232 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CALMLIN ] VAR aTmp[ _CALMLIN ]  ;
         ID       240 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[_CALMLIN], dbfAlm, oSay2 ), oStock:lPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CVALPR1 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ], aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( Self, oSay2 ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET oSay2 VAR cSay2 ;
			WHEN 		.F. ;
         ID       241 ;
			OF 		oFld:aDialogs[1]

      REDEFINE LISTBOX oBrwPrp ;
         FIELDS   "" ;
         HEAD     "" ;
         ID       100 ;
         OF       oFld:aDialogs[1]

      /*
      oBrwPrp                       := TXBrowse():New( oFld:aDialogs[1] )

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

      oBrwPrp:SetArray( {}, , , .f. )

      oBrwPrp:MakeTotals()

      oBrwPrp:CreateFromResource( 100 )
      */
      /*
      fin de propiedades
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ _NIVA ] VAR aTmp[ _NIVA ] ;
			ID 		130 ;
         WHEN     ( lModIva() .AND. nMode != ZOOM_MODE ) ;
			PICTURE 	"@E 99.99" ;
         ON CHANGE( lCalcDeta( aTmp, oTotal ) );
         VALID    ( lTiva( dbfIva, aTmp[ _NIVA ], @aTmp[ _NREQ ] ) );
         ON HELP  ( BrwIva( aGet[ _NIVA ], dbfIva, , .t. ) ) ;
         BITMAP   "LUPA" ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NCANPED ] VAR aTmp[ _NCANPED ];
			ID 		140 ;
			SPINNER ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE ) ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    141

      // Campos de las descripciones de la unidad de medición------------------

      REDEFINE GET aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ] ;
         VAR      aTmp[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ] ;
         ID       300 ;
         IDSAY    301 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ] ;
         VAR      aTmp[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ] ;
         ID       310 ;
         IDSAY    311 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetColor( CLR_BLUE )

      REDEFINE GET aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ] ;
         VAR      aTmp[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ] ;
         ID       320 ;
         IDSAY    321 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lCalcDeta( aTmp, oTotal ) );
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetColor( CLR_BLUE )

		REDEFINE GET aGet[_NUNICAJA] VAR aTmp[_NUNICAJA];
			ID 		150 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			COLOR 	CLR_GET ;
			PICTURE 	cPicUnd ;
         OF       oFld:aDialogs[1] ;
         IDSAY    151

      REDEFINE GET aGet[ _NPREDIV ] VAR aTmp[ _NPREDIV ] ;
			ID 		160 ;
			SPINNER ;
			PICTURE	cPinDiv ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CUNIDAD] VAR aTmp[_CUNIDAD] ;
         ID       170 ;
         IDTEXT   171 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oUndMedicion:Existe( aGet[ _CUNIDAD ], aGet[ _CUNIDAD ]:oHelpText, "cNombre" ), ValidaMedicion( aTmp, aGet) );
         ON HELP  ( oUndMedicion:Buscar( aGet[ _CUNIDAD ] ), ValidaMedicion( aTmp, aGet ) ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aGet[_NDTOLIN] VAR aTmp[_NDTOLIN] ;
			ID 		180 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			SPINNER ;
         PICTURE  "@E 999.99" ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTOPRM] VAR aTmp[_NDTOPRM] ;
         ID       250 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ON CHANGE( lCalcDeta( aTmp, oTotal ) );
			SPINNER ;
			PICTURE	"@E 99.99" ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_NDTORAP] VAR aTmp[_NDTORAP] ;
         ID       260 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			SPINNER ;
			PICTURE	"@E 99.99" ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oGetStk VAR nGetStk ;
         ID       190 ;
         WHEN     .f. ;
			PICTURE 	cPicUnd ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CREFPRV ] VAR aTmp[ _CREFPRV ];
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetIra VAR cGetIra;
         ID       410 ;
         IDSAY    411 ;
         BITMAP   "Lupa" ;
         ON HELP  ( SearchProperty( oGetIra, oBrwPrp ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

		REDEFINE GET oTotal VAR nTotal ;
			ID 		210 ;
         PICTURE  cPirDiv ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

      REDEFINE BITMAP oBmp ;
         ID       100 ;
         OF       oDlg

      oBmp:SetColor( , GetSysColor( 15 ) )

      /*
      Segunda Caja de diálogo--------------------------------------------------
      */

      REDEFINE SAY oTotUni PROMPT nTotNPedPrv( aTmp ) ;
         ID       150 ;
         COLOR    "B/W*" ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oTotEnt PROMPT nTotRes ;
         ID       160 ;
         COLOR    "G/W*" ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[2]

      REDEFINE SAY oTotPdt PROMPT nTotNPedPrv( aTmp ) - nTotRes ;
         ID       170 ;
         COLOR    "R/W*" ;
         PICTURE  cPicUnd ;
         OF       oFld:aDialogs[2]

      /*
      Browse de albaranes------------------------------------------------------
      */

      oBrwAlb                 := TXBrowse():New( oFld:aDialogs[ 2 ] )

      oBrwAlb:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwAlb:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwAlb:cAlias          := dbfAlbPrvL

      oBrwAlb:lFooter         := .f.
      oBrwAlb:nMarqueeStyle   := 5

      oBrwAlb:CreateFromResource( 180 )

         with object ( oBrwAlb:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( dFecAlbPrv( ( dbfAlbPrvL )->cSerAlb + Str( ( dbfAlbPrvL )->nNumAlb ) + ( dbfAlbPrvL )->cSufAlb, dbfAlbPrvT ) ) }
            :nWidth           := 80
         end with

         with object ( oBrwAlb:AddCol() )
            :cHeader          := "Albarán"
            :bEditValue       := {|| AllTrim( ( dbfAlbPrvL )->cSerAlb ) + "/" + AllTrim( Str( ( dbfAlbPrvL )->nNumAlb ) ) + "/" + AllTrim( ( dbfAlbPrvL )->cSufAlb ) }
            :nWidth           := 80
         end with

         with object ( oBrwAlb:AddCol() )
            :cHeader          := "Proveedor"
            :bEditValue       := {|| AllTrim( aTmpPed[ _CCODPRV ] ) + " - " + AllTrim( aTmpPed[ _CNOMPRV ] ) }
            :nWidth           := 240
         end with

         with object ( oBrwAlb:AddCol() )
            :cHeader          := "Total unidades"
            :bEditValue       := {|| nTotNAlbPrv( dbfAlbPrvL ) }
            :bFooter          := {|| nTotRes }
            :cEditPicture     := cPicUnd
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

      REDEFINE BUTTON oBtn;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveDeta( aTmp, aGet, oBrwPrp, oGetIra, oFld, oDlg, oBrw, nMode, oTotal, oGet1, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGetStk, oSayLote, oBtn ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( GoHelp() )

      REDEFINE CHECKBOX aGet[_LANULADO] VAR aTmp[_LANULADO] ;
			ID 		400 ;
         ON CHANGE( CambiaAnulado( aGet, aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET aGet[_DANULADO] VAR aTmp[_DANULADO] ;
         ID       410 ;
         SPINNER ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET aGet[ _MANULADO ] VAR aTmp[_MANULADO] ;
			MEMO ;
         ID       420 ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[3]

      REDEFINE GET aGet[_MOBSLIN] VAR aTmp[_MOBSLIN] ;
         MEMO ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[4]

   if nMode != ZOOM_MODE
      oDlg:AddFastKey(  VK_F5, {|| SaveDeta( aTmp, aGet, oBrwPrp, oGetIra, oFld, oDlg, oBrw, nMode, oTotal, oGet1, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGetStk, oSayLote, oBtn ) } )
   end if

   oDlg:AddFastKey(     VK_F1, {|| GoHelp() } )

   oDlg:bStart    := {||   SetDlgMode( aGet, aTmp, aTmpPed, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oGetIra, oFld, oDlg, oTotal, oGetStk ),;
                           if( !Empty( cCodArt ), aGet[ _CREF ]:lValid(), ),;
                           lCalcDeta( aTmp, oTotal ),;
                           aGet[ _CUNIDAD ]:lValid(),;
                           oBrwAlb:GoTop(), oBrwAlb:Refresh() }

   ACTIVATE DIALOG oDlg ;
         ON INIT  ( EdtDetMenu( aGet[ _CREF ], oDlg ) );
         CENTER

   EndDetMenu()

   ( dbfAlbPrvL )->( OrdScope( 0, nil ) )
   ( dbfAlbPrvL )->( OrdScope( 1, nil ) )
   ( dbfAlbPrvL )->( OrdSetFocus( nOrdAnt ) )

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

STATIC FUNCTION SetDlgMode( aGet, aTmp, aTmpPed, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oGetIra, oFld, oDlg, oTotal )

   local cCodArt        := aGet[ _CREF ]:VarGet()

   if !lUseCaj()
      aGet[ _NCANPED ]:Hide()
   else
      aGet[ _NCANPED ]:SetText( cNombreCajas() )
   end if

   aGet[ _NUNICAJA ]:SetText( cNombreUnidades() )

   if Empty( aTmp[_CALMLIN ] )
      aTmp[ _CALMLIN ]  := aTmpPed[ _CCODALM ]
   end if

   oBrwPrp:Hide()

   oGetIra:Hide()

   oSayPr1:SetText( "" )
   oSayVp1:SetText( "" )

   oSayPr2:SetText( "" )
   oSayVp2:SetText( "" )

   do case
   case nMode == APPD_MODE

      aGet[ _CREF    ]:show()
      aGet[ _CDETALLE]:show()
      aGet[ _MLNGDES ]:hide()
      aGet[ _CLOTE   ]:hide()
      aGet[ _NUNICAJA]:cText( 1 )
      aGet[ _NCANPED ]:cText( 1 )
      aGet[ _CALMLIN ]:cText( aTmpPed[ _CCODALM ] )
      aGet[ _DANULADO]:cText( Ctod( "" ) )
      aGet[ _LANULADO]:Click( .f. )
      aGet[ _NIVA    ]:cText( nIva( dbfIva, cDefIva() ) )

      aTmp[ _NREQ    ]  := nReq( dbfIva, cDefIva() )

      aTmp[ _NNUMLIN ]  := nLastNum( dbfTmpLin )

      oSayLote:hide()

   case nMode != APPD_MODE .AND. empty( cCodArt )

      aGet[_CREF    ]:hide()
		aGet[_CDETALLE]:hide()
		aGet[_MLNGDES ]:show()
      aGet[_CLOTE   ]:hide()

      oSayLote:hide()

   case nMode != APPD_MODE .AND. !empty( cCodArt )

      aGet[_CREF    ]:show()
		aGet[_CDETALLE]:show()
		aGet[_MLNGDES ]:hide()

      if aTmp[_LLOTE]
         aGet[_CLOTE   ]:Show()
         oSayLote:Show()
      else
         aGet[_CLOTE   ]:Hide()
         oSayLote:Hide()
      end if

   end case

   if !Empty( aTmp[ _CCODPR1 ] )
      aGet[ _CVALPR1 ]:Show()
      aGet[ _CVALPR1 ]:lValid()
      oSayPr1:SetText( retProp( aTmp[ _CCODPR1 ], dbfPro ) )
      oSayPr1:Show()
      oSayVp1:Show()
   else
      aGet[ _CVALPR1 ]:Hide()
      oSayPr1:Hide()
      oSayVp1:Hide()
   end if

   if !Empty( aTmp[ _CCODPR2 ] )
      aGet[ _CVALPR2 ]:Show()
      aGet[ _CVALPR2 ]:lValid()
      oSayPr2:SetText( retProp( aTmp[ _CCODPR2 ], dbfPro ) )
      oSayPr2:Show()
      oSayVp2:Show()
   else
      aGet[ _CVALPR2 ]:hide()
      oSayPr2:Hide()
      oSayVp2:Hide()
   end if

   //Ocultamos las tres unidades de medicion

   aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]:Hide()
   aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]:Hide()
   aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]:Hide()

   if oUndMedicion:oDbf:Seek(  aTmp[ _CUNIDAD ] )

      if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
         aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]:Show()
      end if

      if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
         aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]:Show()
      end if

      if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
         aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]:Show()
      end if

   end if

   // Prepramos la caja

   oFld:SetOption( 1 )

   aGet[ _CALMLIN ]:lValid()
   aGet[ _CREF    ]:SetFocus()

   oTotal:cText( 0 )

RETURN .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION LoaArt( aGet, aTmp, nMode, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oGetIra, oDlg, oBmp, oGetStk )

   local nOrdAnt
   local cCodFam
   local cCodPrv
   local cPrpArt
   local cCodArt
   local nUnidad
   local nPreCom
   local lChgCodArt
   local lSeek       := .f.

   nPreCom           := 0
   cCodPrv           := aTmpPed[ _CCODPRV ]
   cCodArt           := aGet[ _CREF ]:varGet()
   cPrpArt           := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]
   lChgCodArt        := ( Rtrim( cOldCodArt ) != Rtrim( cCodArt ) .or. Rtrim( cOldPrpArt ) != Rtrim( cPrpArt ) )

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir lineas sin codificar" )
         return .f.
      end if

      aGet[ _NIVA     ]:bWhen := {|| .t. }
      aGet[ _CDETALLE ]:Hide()
      aGet[ _CLOTE    ]:Hide()

      oSayLote:Hide()

      aGet[ _MLNGDES  ]:Show()
      aGet[ _MLNGDES  ]:SetFocus()

      if !Empty( oBrwPrp )
         oBrwPrp:Hide()
      end if

   else

      if lModIva()
         aGet[ _NIVA  ]:bWhen := {|| .t. }
      else
         aGet[ _NIVA  ]:bWhen := {|| .f. }
      end if

      aGet[ _CREF     ]:Show()
      aGet[ _CDETALLE ]:Show()
      aGet[ _MLNGDES  ]:Hide()

      if lIntelliArtciculoSearch( cCodArt, cCodPrv, dbfArticulo, dbfArtPrv, dbfCodebar )

         if ( lChgCodArt )

            if ( dbfArticulo )->lObs
               MsgStop( "Artículo catalogado como obsoleto" )
               return .f.
            end if

            aGet[ _CREF     ]:cText( ( dbfArticulo )->Codigo )
            aGet[ _CDETALLE ]:cText( ( dbfArticulo )->Nombre )

            if ( dbfArticulo )->lMosCom .and. !Empty( ( dbfArticulo )->mComent )
               MsgStop( Trim( ( dbfArticulo )->mComent ) )
            end if

            /*
            Preguntamos si el regimen de " + cImp() + " es distinto de Exento-------------
            */

            aGet[ _NIVA ]:cText( nIva( dbfIva, ( dbfArticulo )->TipoIva ) )

            aTmp[ _NREQ ]     := nReq( dbfIva, ( dbfArticulo )->TipoIva )

            if ( dbfArticulo )->nCajEnt != 0
               aGet[ _NCANPED ]:cText( ( dbfArticulo )->nCajEnt )
            end if

            if ( dbfArticulo )->nUniCaja != 0
               aGet[ _NUNICAJA ]:cText( ( dbfArticulo )->nUniCaja )
            end if

            /*
            Lotes
            ---------------------------------------------------------------------
            */

            aTmp[ _LLOTE ]    := ( dbfArticulo )->lLote

            if ( dbfArticulo )->lLote
               oSayLote:Show()
               aGet[ _CLOTE ]:Show()
               aGet[ _CLOTE ]:cText( ( dbfArticulo )->cLote )
            else
               oSayLote:Hide()
               aGet[ _CLOTE ]:Hide()
            end if

            /*
            Referencia de proveedor-----------------------------------------------
            */

            nOrdAnt                 := ( dbfArtPrv )->( OrdSetFocus( "cCodPrv" ) )

            if ( dbfArtPrv )->( dbSeek( cCodPrv + cCodArt ) )

               if !Empty( aGet[ _CREFPRV ] )
                  aGet[ _CREFPRV ]:cText( ( dbfArtPrv )->cRefPrv )
               end if

            else

               if !Empty( aGet[ _CREFPRV ] )
                  aGet[ _CREFPRV ]:cText( Space( 20 ) )
               end if

            end if

            ( dbfArtPrv )->( ordSetFocus( nOrdAnt ) )

            /*
            Tratamientos kits-----------------------------------------------------
            */

            if ( dbfArticulo )->lKitArt
               aTmp[ _LKITART ]     := ( dbfArticulo )->lKitArt                        // Marcamos como padre del kit
               aTmp[ _LIMPLIN ]     := lImprimirCompuesto( ( dbfArticulo )->Codigo, dbfArticulo ) // 1 Todos, 2 Compuesto
               aTmp[ _LKITPRC ]     := lPreciosCompuestos( ( dbfArticulo )->Codigo, dbfArticulo ) // 1 Todos, 2 Compuesto
               if lStockCompuestos( ( dbfArticulo )->Codigo, dbfArticulo )
                  aTmp[ _NCTLSTK ]  := ( dbfArticulo )->nCtlStock
               else
                  aTmp[ _NCTLSTK ]  := STOCK_NO_CONTROLAR // No controlar Stock
               end if
            else
               aTmp[ _LIMPLIN ]     := .f.
               aTmp[ _NCTLSTK ]     := ( dbfArticulo )->nCtlStock
            end if

            /*
            Buscamos la familia del articulo y anotamos las propiedades--------
            */

            aTmp[_CCODPR1 ]         := ( dbfArticulo )->cCodPrp1
            aTmp[_CCODPR2 ]         := ( dbfArticulo )->cCodPrp2

            if ( !Empty( aTmp[ _CCODPR1 ] ) .or. !Empty( aTmp[ _CCODPR2 ] ) ) .and. ;
               ( uFieldEmpresa( "lUseTbl" ) .and. ( nMode == APPD_MODE ) )

               nPreCom              := nCosto( nil, dbfArticulo, dbfKit, .f., aTmpPed[ _CDIVPED ], dbfDiv )

               LoadPropertiesTable( cCodArt, nPreCom, aTmp[ _CCODPR1 ], aTmp[ _CCODPR2 ], dbfPro, dbfTblPro, dbfArtCom, oBrwPrp, aGet[ _NUNICAJA ], aGet[ _NPREDIV ] )

               oGetIra:Show()

            else

               oBrwPrp:Hide()

               oGetIra:Hide()

               if !Empty( aTmp[ _CCODPR1 ] ) // .and. !uFieldEmpresa( "lUseTbl" ) .or. ( nMode == APPD_MODE )

                  if aGet[ _CVALPR1 ] != nil
                     aGet[ _CVALPR1 ]:Show()
                     aGet[ _CVALPR1 ]:SetFocus()
                  end if

                  if oSayPr1 != nil
                     oSayPr1:SetText( retProp( ( dbfArticulo )->cCodPrp1, dbfPro ) )
                     oSayPr1:Show()
                  end if

                  if oSayVp1 != nil
                     oSayVp1:Show()
                  end if

               else

                  if aGet[ _CVALPR1 ] !=  nil
                     aGet[ _CVALPR1 ]:Hide()
                  end if

                  if oSayPr1 != nil
                     oSayPr1:Hide()
                  end if

                  if oSayVp1 != nil
                     oSayVp1:Hide()
                  end if

               end if

               if !Empty( aTmp[_CCODPR2 ] ) // .and. !uFieldEmpresa( "lUseTbl" )

                  if aGet[ _CVALPR2 ] != nil
                     aGet[ _CVALPR2 ]:show()
                  end if

                  if oSayPr2 != nil
                     oSayPr2:SetText( retProp( ( dbfArticulo )->cCodPrp2, dbfPro ) )
                     oSayPr2:Show()
                  end if

                  if oSayVp2 != nil
                     oSayVp2:Show()
                  end if

               else

                  if aGet[ _CVALPR2 ] != nil
                     aGet[ _CVALPR2 ]:Hide()
                  end if

                  if oSayPr2 != nil
                     oSayPr2:Hide()
                  end if

                  if oSayVp2 != nil
                     oSayVp2:Hide()
                  end if

               end if

               /*
               Precios de compra--------------------------------------------------
               */

               nPreCom           := nComPro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], dbfArtCom )
               if nPrecom  != 0

                  aGet[ _NPREDIV ]:cText( nPreCom )

               else

                  if uFieldEmpresa( "lCosPrv", .f. )
                     nPreCom     := nPreArtPrv( cCodPrv, cCodArt, dbfArtPrv )
                  end if

                  if nPreCom != 0
                     aGet[ _NPREDIV ]:cText( nPreCom )
                  else
                     aGet[ _NPREDIV ]:cText( nCosto( nil, dbfArticulo, dbfKit, .f., aTmpPed[ _CDIVPED ], dbfDiv ) )
                  end if

                  /*
                  Descuento de articulo----------------------------------------------
                  */

                  if uFieldEmpresa( "lCosPrv", .f. )

                     nPreCom     := nDtoArtPrv( cCodPrv, cCodArt, dbfArtPrv )
                     if nPreCom != 0
                        aGet[ _NDTOLIN ]:cText( nPreCom )
                     end if

                  /*
                  Descuento de promocional----------------------------------------------
                  */

                     nPreCom     := nPrmArtPrv( cCodPrv, cCodArt, dbfArtPrv )
                     if nPreCom != 0
                        aGet[ _NDTOPRM ]:cText( nPreCom )
                     end if

                  end if

               end if

            end if

            /*
            Recogemos las familias y los grupos de familias--------------------
            */

            cCodFam              := ( dbfArticulo )->Familia
            if !Empty( cCodFam )
               aTmp[ _CCODFAM ]  := cCodFam
               aTmp[ _CGRPFAM ]  := cGruFam( cCodFam, dbfFamilia )
            end if

            /*
            Ponemos el precio de venta recomendado-----------------------------
            */

            aTmp[ _NPVPREC  ]    := ( dbfArticulo )->PvpRec

            /*
            Ponemos el stock---------------------------------------------------
            */

            if oGetStk != nil .and. aTmp[ _NCTLSTK ] <= 1
               oStock:nPutStockActual( cCodArt, aTmp[ _CALMLIN ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oGetStk )
            end if

            if !Empty( aGet[ _CUNIDAD ] )
                aGet[ _CUNIDAD ]:cText( ( dbfArticulo )->cUnidad )
                aGet[ _CUNIDAD ]:lValid()
            else
                aTmp[ _CUNIDAD ]    := ( dbfArticulo )->cUnidad
            end if

            ValidaMedicion( aTmp, aGet )

         end if

      else

         msgStop( "Artículo no encontrado" )

         Return .f.

      end if

   end if

   cOldCodArt        := cCodArt
   cOldPrpArt        := cPrpArt

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION GetArtPrv( cRefPrv, cCodPrv, aGet )

	local nOrdAnt

   if Empty( cRefPrv )

      Return .t.

   else

      nOrdAnt  := ( dbfArtPrv )->( ordSetFocus( "cRefPrv" ) )

      if ( dbfArtPrv )->( dbSeek( cCodPrv + cRefPrv ) )

         aGet[ _CREF ]:cText( ( dbfArtPrv )->cCodArt )
			aGet[ _CREF ]:lValid()

      else

         msgStop( "Referencia de proveedor no encontrada" )

      end if

		( dbfArtPrv )->( ordSetFocus( nOrdAnt ) )

   end if

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION SaveDeta( aTmp, aGet, oBrwPrp, oGetIra, oFld, oDlg, oBrw, nMode, oTotal, oGet, aTmpPed, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGetStk, oSayLote, oBtn )

   local n, i

   if !lMoreIva( aTmp[_NIVA] )
      Return nil
   end if

   if Empty( aTmp[ _CALMLIN ] ) .and. !Empty( aTmp[ _CREF ] )
      msgStop( "Código de almacén no puede estar vacío", "Atención" )
      Return nil
   end if

   if !cAlmacen( aGet[ _CALMLIN ], dbfAlm )
      Return nil
   end if

   /*
   Escribir en fichero definitivo----------------------------------------------
   */

   if nMode == APPD_MODE

      if aTmp[ _LLOTE ]
         GraLotArt( aTmp[ _CREF ], dbfArticulo, aTmp[ _CLOTE ] )
      end if

      if !Empty( oBrwPrp:Cargo )

         for n := 1 to len( oBrwPrp:Cargo )

            for i := 1 to len( oBrwPrp:Cargo[ n ] )

               if oBrwPrp:Cargo[ n, i ]:Value != nil .and. oBrwPrp:Cargo[ n, i ]:Value != 0

                  aTmp[ _NUNICAJA]  := oBrwPrp:Cargo[ n, i ]:Value
                  aTmp[ _CCODPR1 ]  := oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad1
                  aTmp[ _CVALPR1 ]  := oBrwPrp:Cargo[ n, i ]:cValorPropiedad1
                  aTmp[ _CCODPR2 ]  := oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad2
                  aTmp[ _CVALPR2 ]  := oBrwPrp:Cargo[ n, i ]:cValorPropiedad2
                  aTmp[ _NPREDIV ]  := oBrwPrp:Cargo[ n, i ]:nPrecioCompra

                  WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode, nil, .f. )

               end if

            next

         next

         aCopy( dbBlankRec( dbfTmpLin ), aTmp )

         aEval( aGet, {| o, i | if( "GET" $ o:ClassName(), o:cText( aTmp[ i ] ), ) } )

      else

         WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

      end if

      if lEntCon()

         SetDlgMode( aGet, aTmp, aTmpPed, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oSayLote, oBrwPrp, oGetIra, oFld, oDlg, oTotal, oGetStk )

         nTotPedPrv( nil, dbfPedPrvT, dbfTmpLin, dbfIva, dbfDiv, aTmpPed )

      else

         oDlg:end( IDOK )

      end if

   else

      WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

      oDlg:end( IDOK )

   end if

   aTmp[ _MNUMSER ]                 := ""
   cOldCodArt                       := ""
   cOldUndMed                       := ""

   if !Empty( aGet[ _CUNIDAD ] )
      aGet[ _CUNIDAD ]:lValid()
   end if

   if !Empty( oBrwPrp )
      oBrwPrp:Cargo                 := nil
   end if

   if oGet != nil
      oGet:cText( Space( 14 ) )
      oGet:SetFocus()
   end if

   if oGetStk != nil
      oGetStk:cText( 0 )
   end if

Return nil

//--------------------------------------------------------------------------//

STATIC FUNCTION lMoreIva( nCodIva )

	/*
	Si no esta dentro de los porcentajes anteriores
	*/

	IF _NPCTIVA1 == NIL .OR. _NPCTIVA2 == NIL .OR. _NPCTIVA3 == NIL
		RETURN .T.
	END IF

	IF _NPCTIVA1 == nCodIva .OR. _NPCTIVA2 == nCodIva .OR. _NPCTIVA3 == nCodIva
		RETURN .T.
	END IF

   MsgStop( "Pedido con mas de 3 tipos de " + cImp(), "Imposible añadir" )

Return .f.

//---------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie( oBrw )

   local oDlg
   local oFmtDoc
   local cFmtDoc     := cFormatoDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin   
   local cSerIni     := ( dbfPedPrvT )->cSerPed
   local cSerFin     := ( dbfPedPrvT )->cSerPed
   local nDocIni     := ( dbfPedPrvT )->nNumPed
   local nDocFin     := ( dbfPedPrvT )->nNumPed
   local cSufIni     := ( dbfPedPrvT )->cSufPed
   local cSufFin     := ( dbfPedPrvT )->cSufPed
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount ) == 0, Max( Retfld( ( dbfPedPrvT )->cCodPrv, dbfPrv, "nCopiasF" ), 1 ), nCopiasDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount ) )
   local oRango
   local nRango      := 1
   local dFecDesde   := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dFecHasta   := Date()

   if Empty( cFmtDoc )
      cFmtDoc        := cSelPrimerDoc( "PP" )
   end if

   cSayFmt           := cNombreDoc( cFmtDoc )

   DEFINE DIALOG oDlg RESOURCE "IMPSERIES" TITLE "Imprimir series de pedidos"

   REDEFINE RADIO oRango VAR nRango ;
      ID       201, 202 ;
      OF       oDlg

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       100 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      VALID    ( cSerIni >= "A" .AND. cSerIni <= "Z"  );
      WHEN     ( nRango == 1 ); 
      OF       oDlg

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       110 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      VALID    ( cSerFin >= "A" .AND. cSerFin <= "Z"  );
      WHEN     ( nRango == 1 ); 
      OF       oDlg

   REDEFINE GET nDocIni;
      ID       120 ;
	PICTURE 	"999999999" ;
      SPINNER ;
      WHEN     ( nRango == 1 ); 
	OF 		oDlg

   REDEFINE GET nDocFin;
      ID       130 ;
	PICTURE 	"999999999" ;
      SPINNER ;
      WHEN     ( nRango == 1 ); 
	OF 		oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      PICTURE  "##" ;
      WHEN     ( nRango == 1 ); 
	OF 		oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      PICTURE  "##" ;
      WHEN     ( nRango == 1 ); 
	OF 		oDlg

   REDEFINE GET dFecDesde ;
      ID       210 ;
      WHEN     ( nRango == 2 ) ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET dFecHasta ;
      ID       220 ;
      WHEN     ( nRango == 2 ) ;
      SPINNER ;
      OF       oDlg   

   REDEFINE CHECKBOX lInvOrden ;
      ID       500 ;
      OF       oDlg

   REDEFINE CHECKBOX lCopiasPre ;
      ID       170 ;
      OF       oDlg

   REDEFINE GET oNumCop VAR nNumCop;
      ID       180 ;
      WHEN     !lCopiasPre ;
      VALID    nNumCop > 0 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      MIN      1 ;
      MAX      99999 ;
      OF       oDlg

   REDEFINE GET oFmtDoc VAR cFmtDoc ;
      ID       90 ;
      COLOR    CLR_GET ;
      VALID    ( cDocumento( oFmtDoc, oSayFmt, dbfDoc ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "PP" ) ) ;
      OF       oDlg

   REDEFINE GET oSayFmt VAR cSayFmt ;
      ID       91 ;
      WHEN     ( .f. );
      COLOR    CLR_GET ;
      OF       oDlg

   TBtnBmp():ReDefine( 92, "Printer_pencil_16",,,,,{|| EdtDocumento( cFmtDoc ) }, oDlg, .f., , .f.,  )

   REDEFINE GET oPrinter VAR cPrinter;
         WHEN     ( .f. ) ;
         ID       160 ;
         OF       oDlg

   TBtnBmp():ReDefine( 161, "Printer_preferences_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   (  StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta ), oDlg:end( IDOK ) } )

   oDlg:bStart := { || oSerIni:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

   oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden, nRango, dFecDesde, dFecHasta )

   local nCopyProvee
   local nRecno
   local nOrdAnt

   oDlg:disable()

   if nRango == 1

      nRecno            := ( dbfPedPrvT )->( Recno() )
      nOrdAnt           := ( dbfPedPrvT )->( OrdSetFocus( "NNUMPED" ) )

      if !lInvOrden

            ( dbfPedPrvT )->( dbSeek( cDocIni, .t. ) )

            while ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + (dbfPedPrvT)->cSufPed >= cDocIni .AND. ;
                  ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + (dbfPedPrvT)->cSufPed <= cDocFin

                  lChgImpDoc( dbfPedPrvT )

            if lCopiasPre

                  nCopyProvee := if( nCopiasDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount ) == 0, Max( Retfld( ( dbfPedPrvT )->cCodPrv, dbfPrv, "nCopiasF" ), 1 ), nCopiasDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount ) )

                  GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + (dbfPedPrvT)->cSufPed, cFmtDoc, cPrinter, nCopyProvee )

            else

                  GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + (dbfPedPrvT)->cSufPed, cFmtDoc, cPrinter, nNumCop )

            end if

            ( dbfPedPrvT )->( dbSkip() )

            end while

      else

      ( dbfPedPrvT )->( dbSeek( cDocFin ) )

         while ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed >= cDocIni .and.;
               ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed <= cDocFin .and.;
               !( dbfPedPrvT )->( Bof() )

               lChgImpDoc( dbfPedPrvT )

         if lCopiasPre

               nCopyProvee := if( nCopiasDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount ) == 0, Max( Retfld( ( dbfPedPrvT )->cCodPrv, dbfPrv, "nCopiasF" ), 1 ), nCopiasDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount ) )

               GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + (dbfPedPrvT)->cSufPed, cFmtDoc, cPrinter, nCopyProvee )

         else

               GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + (dbfPedPrvT)->cSufPed, cFmtDoc, cPrinter, nNumCop )

         end if

         ( dbfPedPrvT )->( dbSkip( -1 ) )

         end while

      end if

   else

      nRecno            := ( dbfPedPrvT )->( Recno() )
      nOrdAnt           := ( dbfPedPrvT )->( OrdSetFocus( "DFECPED" ) )

      if !lInvOrden

            ( dbfPedPrvT )->( dbGoTop() )

            while !( dbfPedPrvT )->( Eof() )

               if ( dbfPedPrvT )->dFecPed >= dFecDesde .and. ( dbfPedPrvT )->dFecPed <= dFecHasta

                  lChgImpDoc( dbfPedPrvT )

                  if lCopiasPre

                        nCopyProvee := if( nCopiasDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount ) == 0, Max( Retfld( ( dbfPedPrvT )->cCodPrv, dbfPrv, "nCopiasF" ), 1 ), nCopiasDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount ) )

                        GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + (dbfPedPrvT)->cSufPed, cFmtDoc, cPrinter, nCopyProvee )

                  else

                        GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + (dbfPedPrvT)->cSufPed, cFmtDoc, cPrinter, nNumCop )

                  end if

               end if   

            ( dbfPedPrvT )->( dbSkip() )

            end while

      else

         ( dbfPedPrvT )->( dbGoBottom() )

         while !( dbfPedPrvT )->( Bof() )

            if ( dbfPedPrvT )->dFecPed >= dFecDesde .and. ( dbfPedPrvT )->dFecPed <= dFecHasta

               lChgImpDoc( dbfPedPrvT )

               if lCopiasPre

                  nCopyProvee := if( nCopiasDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount ) == 0, Max( Retfld( ( dbfPedPrvT )->cCodPrv, dbfPrv, "nCopiasF" ), 1 ), nCopiasDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount ) )

                  GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + (dbfPedPrvT)->cSufPed, cFmtDoc, cPrinter, nCopyProvee )

               else

                  GenPedPrv( IS_PRINTER, "Imprimiendo documento : " + ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + (dbfPedPrvT)->cSufPed, cFmtDoc, cPrinter, nNumCop )

               end if

            end if   

         ( dbfPedPrvT )->( dbSkip( -1 ) )

         end while

      end if
   
   end if   

   ( dbfPedPrvT )->( ordSetFocus( nOrdAnt ) )
   ( dbfPedPrvT )->( dbGoTo( nRecNo ) )

   oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION GenPedPrv( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice
   local nPedido

   if ( dbfPedPrvT )->( Lastrec() ) == 0
      return nil
   end if

   nPedido              := ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo pedido"
   DEFAULT cCodDoc      := cFormatoDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount )
   DEFAULT nCopies      := if( nCopiasDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount ) == 0, Max( Retfld( ( dbfPedPrvT )->cCodPrv, dbfPrv, "nCopiasF" ), 1 ), nCopiasDocumento( ( dbfPedPrvT )->cSerPed, "nPedPrv", dbfCount ) )

   if Empty( cCodDoc )
      cCodDoc           := cFirstDoc( "PP", dbfDoc )
   end if

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, dbfDoc )

      PrintReportPedPrv( nDevice, nCopies, cPrinter, dbfDoc )

   else

      /*
      Posicionamos en las areas
      */

      ( dbfPedPrvL)->( dbSeek( nPedido ) )
      ( dbfPrv    )->( dbSeek( ( dbfPedPrvT )->cCodPrv ) )
      ( dbfDiv    )->( dbSeek( ( dbfPedPrvT )->cDivPed ) )
      ( dbfFPago  )->( dbSeek( ( dbfPedPrvT )->cCodPgo ) )
      ( dbfAlm    )->( dbSeek( ( dbfPedPrvT )->cCodAlm ) )
      ( dbfUsr    )->( dbSeek( ( dbfPedPrvT )->cCodUsr ) )

      private cDbf         := dbfPedPrvT
      private cDbfCol      := dbfPedPrvL
      private cDbfPrv      := dbfPrv
      private cDbfPgo      := dbfFPago
      private cDbfIva      := dbfIva
      private cDbfAlm      := dbfAlm
      private cDbfDiv      := dbfDiv
      private cDbfArt      := dbfArticulo
      private cDbfKit      := dbfKit
      private cDbfUsr      := dbfUsr
      private cDbfPro      := dbfPro
      private cDbfTblPro   := dbfTblPro
      private cPicUndPed   := cPicUnd
      private cPinDivPed   := cPinDiv
      private cPirDivPed   := cPirDiv
      private nDinDivPed   := nDinDiv
      private nDirDivPed   := nDirDiv
      private nVdvDivPed   := ( dbfPedPrvT )->nVdvPed

      /*
      Creamos el informe con la impresora seleccionada para ese informe-----------
      */

      if !Empty( cPrinter )
         oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
         REPORT oInf CAPTION cCaption TO DEVICE oDevice
      else
         REPORT oInf CAPTION cCaption PREVIEW
      end if

      if !Empty( oInf ) .and. oInf:lCreated
         oInf:lAutoland    := .f.
         oInf:lFinish      := .f.
         oInf:lNoCancel    := .t.
         oInf:bSkip        := {|| ( dbfPedPrvL )->( dbSkip() ) }

         oInf:oDevice:lPrvModal  := .t.

         do case
            case nDevice == IS_PRINTER
               oInf:bPreview  := {| oDevice | PrintPreview( oDevice ) }

            case nDevice == IS_PDF
               oInf:bPreview  := {| oDevice | PrintPdf( oDevice ) }

         end case

         SetMargin(  cCodDoc, oInf )
         PrintColum( cCodDoc, oInf )
      end if

      END REPORT

      if !Empty( oInf )

         ACTIVATE REPORT oInf ;
            WHILE       ( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed == nPedido .and. !( dbfPedPrvL )->( eof() ) );
            FOR         ( !( dbfPedPrvL )->lImpLin ) ;
            ON ENDPAGE  ePage( oInf, cCodDoc )

         if nDevice == IS_PRINTER
            oInf:oDevice:end()
         end if

      end if

      oInf                 := nil

      /*
      Marca de documento impreso-----------------------------------------------
      */

   end if

   lChgImpDoc( dbfPedPrvT )

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION EPage( oInf, cCodDoc )

   private nPagina      := oInf:nPage
	private lEnd			:= oInf:lFinish

   PrintItems( cCodDoc, oInf )

RETURN NIL

//--------------------------------------------------------------------------//

/*
Calcula el Total del pedido
*/

FUNCTION nTotPedPrv( cPedido, cPedPrvT, cPedPrvL, cIva, cDiv, aTmp, cDivRet, lPic )

   local nRec
   local nTotArt
	local dFecFac
	local lRecargo
	local nDtoEsp
	local nDtoPP
   local nDtoUno
	local nDtoDos
	local nPorte
	local cCodDiv
   local nRegIva
   local aTotDto     := { 0, 0, 0 }
   local aTotDPP     := { 0, 0, 0 }
   local aTotUno     := { 0, 0, 0 }
   local aTotDos     := { 0, 0, 0 }
   local bCondition

   DEFAULT cPedPrvT  := dbfPedPrvT
   DEFAULT cPedPrvL  := dbfPedPrvL
   DEFAULT cIva      := dbfIva
   DEFAULT cDiv      := dbfDiv
   DEFAULT lPic      := .f.
   DEFAULT cPedido   := ( cPedPrvT )->cSerPed + Str( ( cPedPrvT )->nNumPed ) + ( cPedPrvT )->cSufPed

   public nTotPed    := 0
   public nTotBrt    := 0
   public nTotDto    := 0
   public nTotDPP    := 0
   public nTotNet    := 0
   public nTotIva    := 0
   public nTotReq    := 0
   public nTotImp    := 0
   public aTotIva    := { { 0,0,nil,0,0,0 }, { 0,0,nil,0,0,0 }, { 0,0,nil,0,0,0 } }
   public aIvaUno    := aTotIva[ 1 ]
   public aIvaDos    := aTotIva[ 2 ]
   public aIvaTre    := aTotIva[ 3 ]
   public nTotUno    := 0
   public nTotDos    := 0
    

   nRec              := ( cPedPrvL )->( Recno() )

   if aTmp != nil
		dFecFac			:= aTmp[ _DFECPED ]
		lRecargo			:= aTmp[ _LRECARGO]
		nDtoEsp			:= aTmp[ _NDTOESP ]
		nDtoPP			:= aTmp[ _NDPP    ]
      nDtoUno        := aTmp[ _NDTOUNO ]
      nDtoDos        := aTmp[ _NDTODOS ]
		nPorte			:= aTmp[ _NPORTES ]
		cCodDiv			:= aTmp[ _CDIVPED ]
      nVdvDiv        := aTmp[ _NVDVPED ]
      nRegIva        := aTmp[ _NREGIVA ]
      bCondition     := {|| ( cPedPrvL )->( !eof() ) }
      ( cPedPrvL )->( dbGoTop() )
   else
      dFecFac        := ( cPedPrvT )->dFecPed
      lRecargo       := ( cPedPrvT )->lRecargo
      nDtoEsp        := ( cPedPrvT )->nDtoEsp
      nDtoPP         := ( cPedPrvT )->nDpp
      nDtoUno        := ( cPedPrvT )->nDtoUno
      nDtoDos        := ( cPedPrvT )->nDtoDos
      nPorte         := ( cPedPrvT )->nPortes
      cCodDiv        := ( cPedPrvT )->cDivPed
      nVdvDiv        := ( cPedPrvT )->nVdvPed
      nRegIva        := ( cPedPrvT )->nRegIva
      bCondition     := {|| ( cPedPrvL )->cSerPed + Str( ( cPedPrvL )->nNumPed ) + ( cPedPrvL )->cSufPed == cPedido .and. ( cPedPrvL )->( !eof() ) }
      ( cPedPrvL )->( dbSeek( cPedido ) )
   end if

   cPinDiv           := cPinDiv( cCodDiv, cDiv )
   cPirDiv           := cPirDiv( cCodDiv, cDiv )
   nDinDiv           := nDinDiv( cCodDiv, cDiv )
   nDirDiv           := nRinDiv( cCodDiv, cDiv )

   while Eval( bCondition )

      if lValLine( cPedPrvL )

         /*
         Importes de lineas
         */

         nTotArt           := nTotLPedPrv( cPedPrvL, nDinDiv, nDirDiv )
         if nTotArt != 0

            /*
            Estudio de impuestos
            */

            do case
            case _NPCTIVA1 == NIL .OR. _NPCTIVA1 == ( cPedPrvL )->nIva
               _NPCTIVA1   := (cPedPrvL)->NIVA
               _NPCTREQ1   := (cPedPrvL)->NREQ
               _NBRTIVA1   += nTotArt

            case _NPCTIVA2 == NIL .OR. _NPCTIVA2 == ( cPedPrvL )->nIva
               _NPCTIVA2   := (cPedPrvL)->NIVA
               _NPCTREQ2   := (cPedPrvL)->NREQ
               _NBRTIVA2   += nTotArt

            case _NPCTIVA3 == NIL .OR. _NPCTIVA3 == ( cPedPrvL )->nIva
               _NPCTIVA3   := (cPedPrvL)->NIVA
               _NPCTREQ3   := (cPedPrvL)->NREQ
               _NBRTIVA3   += nTotArt
            end case

         end if

      end if

      ( cPedPrvL )->( dbSkip() )

   end while

   ( cPedPrvL )->( dbGoTo( nRec ) )

	/*
   Obtenemos el total bruto----------------------------------------------------
	*/

   nTotBrt           := _NBRTIVA1 + _NBRTIVA2 + _NBRTIVA3

	/*
   Portes de la Factura--------------------------------------------------------
	*/

   nTotBrt           += nPorte

   _NBASIVA1         := _NBRTIVA1
   _NBASIVA2         := _NBRTIVA2
   _NBASIVA3         := _NBRTIVA3

	/*
	Descuentos de la Facturas
	*/

	IF nDtoEsp != 0

      aTotDto[1]     := Round( _NBASIVA1 * nDtoEsp / 100, nDirDiv )
      aTotDto[2]     := Round( _NBASIVA2 * nDtoEsp / 100, nDirDiv )
      aTotDto[3]     := Round( _NBASIVA3 * nDtoEsp / 100, nDirDiv )

      nTotDto        := aTotDto[1] + aTotDto[2] + aTotDto[3]

      _NBASIVA1      -= aTotDto[1]
      _NBASIVA2      -= aTotDto[2]
      _NBASIVA3      -= aTotDto[3]

   END IF

	IF nDtoPP != 0

      aTotDPP[1]     := Round( _NBASIVA1 * nDtoPP / 100, nDirDiv )
      aTotDPP[2]     := Round( _NBASIVA2 * nDtoPP / 100, nDirDiv )
      aTotDPP[3]     := Round( _NBASIVA3 * nDtoPP / 100, nDirDiv )

      nTotDPP        := aTotDPP[1] + aTotDPP[2] + aTotDPP[3]

      _NBASIVA1      -= aTotDPP[1]
      _NBASIVA2      -= aTotDPP[2]
      _NBASIVA3      -= aTotDPP[3]

   END IF

   IF nDtoUno != 0

      aTotUno[1]     := Round( _NBASIVA1 * nDtoUno / 100, nDirDiv )
      aTotUno[2]     := Round( _NBASIVA2 * nDtoUno / 100, nDirDiv )
      aTotUno[3]     := Round( _NBASIVA3 * nDtoUno / 100, nDirDiv )

      nTotUno        := aTotDPP[1] + aTotDPP[2] + aTotDPP[3]

      _NBASIVA1      -= aTotUno[1]
      _NBASIVA2      -= aTotUno[2]
      _NBASIVA3      -= aTotUno[3]

	END IF

	IF nDtoDos != 0

      aTotDos[1]     := Round( _NBASIVA1 * nDtoDos / 100, nDirDiv )
      aTotDos[2]     := Round( _NBASIVA2 * nDtoDos / 100, nDirDiv )
      aTotDos[3]     := Round( _NBASIVA3 * nDtoDos / 100, nDirDiv )

      nTotDos        := aTotDPP[1] + aTotDPP[2] + aTotDPP[3]

      _NBASIVA1      -= aTotDos[1]
      _NBASIVA2      -= aTotDos[2]
      _NBASIVA3      -= aTotDos[3]

	END IF

   nTotNet           := Round( _NBASIVA1 + _NBASIVA2 + _NBASIVA3, nDirDiv )

	/*
   Calculos de impuestos
	*/

   if nRegIva <= 1

      _NIMPIVA1      := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTIVA1 / 100, nDirDiv ), 0 )
      _NIMPIVA2      := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTIVA2 / 100, nDirDiv ), 0 )
      _NIMPIVA3      := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTIVA3 / 100, nDirDiv ), 0 )

      /*
      Calculo de recargo
      */

      if lRecargo
         _NIMPREQ1   := if( _NPCTIVA1 != NIL, Round( _NBASIVA1 * _NPCTREQ1 / 100, nDirDiv ), 0 )
         _NIMPREQ2   := if( _NPCTIVA2 != NIL, Round( _NBASIVA2 * _NPCTREQ2 / 100, nDirDiv ), 0 )
         _NIMPREQ3   := if( _NPCTIVA3 != NIL, Round( _NBASIVA3 * _NPCTREQ3 / 100, nDirDiv ), 0 )
      end if

   end if

   /*
   Total impuestos
   */

   nTotIva           := Round( _NIMPIVA1 + _NIMPIVA2 + _NIMPIVA3, nDirDiv )

	/*
   Total de R.E.
	*/

   nTotReq           := Round( _NIMPREQ1 + _NIMPREQ2 + _NIMPREQ3, nDirDiv )

   /*
	Total de impuestos
	*/

   nTotImp           := Round( nTotIva + nTotReq, nDirDiv )

	/*
	Total facturas
	*/

   nTotPed           := nTotNet + nTotImp

	/*
	Refrescos en Pantalla______________________________________________________
	*/

   aTotIva           := aSort( aTotIva,,, {|x,y| abs( x[1] ) > abs( y[1] ) } )

   /*
   Solicitan una divisa distinta a la q se hizo originalmente la factura
   */

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet        := nCnv2Div( nTotNet, cCodDiv, cDivRet, cDiv )
      nTotIva        := nCnv2Div( nTotIva, cCodDiv, cDivRet, cDiv )
      nTotReq        := nCnv2Div( nTotReq, cCodDiv, cDivRet, cDiv )
      nTotPed        := nCnv2Div( nTotPed, cCodDiv, cDivRet, cDiv )
      cPirDiv        := cPirDiv( cDivRet, cDiv )
   end if

RETURN ( if( lPic, Trans( nTotPed, cPirDiv ), nTotPed ) ) //

//--------------------------------------------------------------------------//

Static Function RecalculaTotal( aTmp )

   nTotPedPrv( nil, dbfPedPrvT, dbfTmpLin, dbfIva, dbfDiv, aTmp )

   oBrwIva:Refresh()

   oGetNet:SetText( Trans( nTotNet, cPirDiv ) )

   oGetIva:SetText( Trans( nTotIva, cPirDiv ) )

   oGetReq:SetText( Trans( nTotReq, cPirDiv ) )

   oGetTotal:SetText( Trans( nTotPed, cPirDiv ) )

Return .t.

//--------------------------------------------------------------------------//

FUNCTION aTotPedPrv( cFactura, dbfPedPrvT, dbfLine, dbfIva, dbfDiv, cDivRet )

   nTotPedPrv( cFactura, dbfPedPrvT, dbfLine, dbfIva, dbfDiv, nil, cDivRet, .f. )

RETURN ( { nTotNet, nTotIva, nTotReq, nTotPed, aTotIva } )

//---------------------------------------------------------------------------//

Function sTotPedPrv( cPedido, dbfMaster, dbfLine, dbfIva, dbfDiv, cDivRet )

   local sTotal

   nTotPedPrv( cPedido, dbfMaster, dbfLine, dbfIva, dbfDiv, nil, cDivRet, .f. )

   sTotal                                 := sTotal()
   sTotal:nTotalBruto                     := nTotBrt
   sTotal:nTotalNeto                      := nTotNet
   sTotal:nTotalIva                       := nTotIva
   sTotal:aTotalIva                       := aTotIva
   sTotal:nTotalRecargoEquivalencia       := nTotReq
   sTotal:nTotalDocumento                 := nTotPed
   sTotal:nTotalDescuentoGeneral          := nTotDto
   sTotal:nTotalDescuentoProntoPago       := nTotDpp
   sTotal:nTotalDescuentoUno              := nTotUno
   sTotal:nTotalDescuentoDos              := nTotDos

Return ( sTotal )

//--------------------------------------------------------------------------//


/*
Carga los datos del proveedor
*/

STATIC FUNCTION LoaPrv( aGet, aTmp, dbfPrv, nMode, oSay, oTlfPrv )

   local lValid      := .f.
   local cNewCodCli  := aGet[ _CCODPRV ]:VarGet()
   local lChgCodCli  := ( Empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if Empty( cNewCodCli )
      Return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[ _CCODPRV ], "0", RetNumCodPrvEmp() )
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodPrvEmp() )
   end if

   if ( dbfPrv )->( dbSeek( cNewCodCli ) )

      if ( dbfPrv )->lBlqPrv
         msgStop( "Proveedor bloqueado, no se pueden realizar operaciones de compra" )
         return .f.
      end if

      aGet[ _CCODPRV ]:cText( ( dbfPrv )->Cod )

      if Empty( aGet[ _CNOMPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CNOMPRV ]:cText( ( dbfPrv )->Titulo )
      end if

      if oTlfPrv != nil
         oTlfPrv:SetText( ( dbfPrv )->Telefono )
      end if

      if Empty( aGet[ _CDIRPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CDIRPRV ]:cText( ( dbfPrv )->Domicilio )
      endif

      if Empty( aGet[ _CPOBPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOBPRV ]:cText( ( dbfPrv )->Poblacion )
      endif

      if Empty( aGet[ _CPROPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CPROPRV ]:cText( ( dbfPrv )->Provincia )
      endif

      if Empty( aGet[ _CPOSPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CPOSPRV ]:cText( ( dbfPrv )->CodPostal )
      endif

      if Empty( aGet[ _CDNIPRV ]:varGet() ) .or. lChgCodCli
         aGet[ _CDNIPRV ]:cText( ( dbfPrv )->Nif )
      endif

      /*
      Descuentos
      */

      if lChgCodCli
         aGet[ _CDTOESP ]:cText( ( dbfPrv )->cDtoEsp )
         aGet[ _NDTOESP ]:cText( ( dbfPrv )->nDtoEsp )
         aGet[ _CDPP    ]:cText( ( dbfPrv )->cDtoPp  )
         aGet[ _NDPP    ]:cText( ( dbfPrv )->DtoPp   )
      end if

      if Empty( aGet[_CCODPGO]:VarGet() )
         aGet[ _CCODPGO ]:cText( ( dbfPrv )->fPago )
         aGet[ _CCODPGO ]:lValid()
      end if

      /*
      Fecha de entrada
      */

      if lChgCodCli
         if ( dbfPrv )->nPlzEnt != 0
            aGet[ _DFECENT ]:cText( GetSysDate() + ( dbfPrv )->nPlzEnt )
         else
            aGet[ _DFECENT ]:cText( Ctod( "" ) )
         end if
      end if

      if nMode == APPD_MODE

         aGet[ _NREGIVA ]:nOption( Max( ( dbfPrv )->nRegIva, 1 ) )
         aGet[ _NREGIVA ]:Refresh()

         if Empty( aTmp[ _CSERPED ] )

            if !Empty( ( dbfPrv )->Serie )
               aGet[ _CSERPED ]:cText( ( dbfPrv )->Serie )
            end if

         else

            if !Empty( ( dbfPrv )->Serie ) .and. aTmp[ _CSERPED ] != ( dbfPrv )->Serie .and. ApoloMsgNoYes( "La serie del proveedor seleccionado es distinta a la anterior.", "¿Desea cambiar la serie?" )
               aGet[ _CSERPED ]:cText( ( dbfPrv )->Serie )
            end if

         end if

      end if

      if lChgCodCli
         aTmp[ _LRECARGO ] := ( dbfPrv )->lReq
         aGet[ _LRECARGO ]:Refresh()
      end if

      if ( dbfPrv )->lMosCom .and. !Empty( ( dbfPrv )->mComent ) .and. lChgCodCli
         MsgStop( AllTrim( ( dbfPrv )->mComent ) )
      end if

      cOldCodCli     := ( dbfPrv )->Cod

      lValid         := .t.

   else

		msgStop( "Proveedor no encontrado" )

   end if

RETURN lValid

//--------------------------------------------------------------------------//

FUNCTION BrwPedPrv( oGetNum, dbfPedPrvT, dbfPedPrvL, dbfIva, dbfDiv, dbfFPago )

	local oDlg
	local oBrw
   local oGet1
   local cGet1
   local nOrd     := GetBrwOpt( "BrwPedPrv" )
	local oCbxOrd
   local aCbxOrd  := { "Número", "Fecha", "Código", "Nombre" }
   local cCbxOrd
   local aDbfBmp  := {  LoadBitmap( GetResources(), "BRED"   ),;
                        LoadBitmap( GetResources(), "BYELOW" ),;
                        LoadBitmap( GetResources(), "BGREEN" ) }

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   ( dbfPedPrvT )->( dbSetFilter( {|| Field->NESTADO != 3 }, "NESTADO != 3" ) )

   nOrd              := ( dbfPedPrvT )->( OrdSetFocus( nOrd ) )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Pedido a proveedores"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfPedPrvT, .t., nil, .f. ) );
         VALID    ( OrdClearScope( oBrw, dbfPedPrvT ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
         VAR       cCbxOrd ;
         ID        102 ;
         ITEMS     aCbxOrd ;
         ON CHANGE ( ( dbfPedPrvT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF        oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfPedPrvT
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Pedido a proveedor.Browse"

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Es. Estado"
         :bStrData         := {|| "" }
         :bBmpData         := {|| ( dbfPedPrvT )->nEstado }
         :nWidth           := 20
         :AddResource( "Bullet_Square_Red_16" )
         :AddResource( "Bullet_Square_Yellow_16" )
         :AddResource( "Bullet_Square_Green_16" )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Número" 
         :cSortOrder       := "nNumPed"
         :bEditValue       := {|| ( dbfPedPrvT )->cSerPed + "/" + Str( ( dbfPedPrvT )->nNumPed ) + "/" + ( dbfPedPrvT )->cSufPed }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dFecPed"
         :bEditValue       := {|| dToc( ( dbfPedPrvT )->dFecPed ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPrv"
         :bEditValue       := {|| Rtrim( ( dbfPedPrvT )->cCodPrv ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomPrv"
         :bEditValue       := {|| Rtrim( ( dbfPedPrvT )->cNomPrv ) }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotPedPrv( ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed, dbfPedPrvT, dbfPedPrvL, dbfIva, dbfDiv, nil, cDivEmp(), .t. ) }
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		.F.

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		.F.

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN, {|| oDlg:end( IDOK ) } )

   oDlg:bStart    := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   IF oDlg:nResult == IDOK
      oGetNum:cText( ( dbfPedPrvT )->CSERPED + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed )
      oGetNum:disable()
   END IF

   DestroyFastFilter( dbfPedPrvT )

   SetBrwOpt( "BrwPedPrv", ( dbfPedPrvT )->( OrdNumber() ) )

   ( dbfPedPrvT )->( dbSetFilter() )
   ( dbfPedPrvT )->( OrdSetFocus( nOrd ) )

   AEval( aDbfBmp, { | hBmp | DeleteObject( hBmp ) } )

   /*
    Guardamos los datos del browse
   */
   oBrw:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION ChgPedPrv( nPedido, nMode, dbfPedPrvT )

   local oBlock
   local oError
   local lExito   := .t.
   local lClose   := .f.

   if nMode != APPD_MODE .OR. Empty( nPedido )
      return nil
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfPedPrvT )
      USE ( cPatEmp() + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVT.CDX" ) ADDITIVE
		lClose := .T.
   end if

   if (dbfPedPrvT)->(DbSeek( nPedido ) )
      if dbDialogLock( dbfPedPrvT )
         ( dbfPedPrvT )->nEstado    := 1
      end if
   else
      lExito      := .f.
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
		CLOSE (dbfPedPrvT)
   end if

RETURN lExito

//-------------------------------------------------------------------------//

/*
Calcula totales en las lineas de Detalle
*/

STATIC FUNCTION lCalcDeta( aTmp, oTotal )

   local nCalculo := nTotUPedPrv( aTmp, nDinDiv )

   IF lCalCaj()
      nCalculo    *= If( aTmp[ _NCANPED ] != 0, aTmp[ _NCANPED ], 1 )
	END IF

	IF aTmp[ _NDTOLIN ] != 0
      nCalculo    -= nCalculo * aTmp[ _NDTOLIN ] / 100
	END IF

   IF aTmp[ _NDTOPRM ] != 0
		nCalculo 	-= nCalculo * aTmp[ _NDTOPRM ] / 100
	END IF

   nCalculo       *= nTotNPedPrv( aTmp )

   nCalculo       := Round( nCalculo, nDinDiv )

	oTotal:cText( nCalculo )

RETURN .T.

//---------------------------------------------------------------------------//

FUNCTION nTotEPedPrv( uTmp )

   local nCalculo := 0

   do case
   case ValType( uTmp ) == "C"
      nCalculo    := NotCaja( (uTmp)->nCanEnt ) * (uTmp)->nUniEnt
   case ValType( uTmp ) == "O"
      nCalculo    := NotCaja( uTmp:nCanEnt ) * uTmp:nUniEnt
   case ValType( uTmp ) == "A"
      nCalculo    := NotCaja( uTmp[ _NCANENT ] * uTmp[ _NUNIENT ] )
   end case

RETURN ( nCalculo )

//---------------------------------------------------------------------------//

FUNCTION nTotNPedPrv( uTmp )

   local nCalculo := 0

   DEFAULT uTmp   := dbfPedPrvL

   do case
   case ValType( uTmp ) == "C"
      nCalculo    := ( uTmp )->nUniCaja
      nCalculo    *= NotCaja( ( uTmp )->nCanPed )
      nCalculo    *= NotCero( ( uTmp )->nUndKit )
      nCalculo    *= NotCero( ( uTmp )->nMedUno )
      nCalculo    *= NotCero( ( uTmp )->nMedDos )
      nCalculo    *= NotCero( ( uTmp )->nMedTre )

   case ValType( uTmp ) == "O"
      nCalculo    := uTmp:nUniCaja
      nCalculo    *= NotCaja( uTmp:nCanPed )
      nCalculo    *= NotCero( uTmp:nUndKit )
      nCalculo    *= NotCero( uTmp:nMedUno )
      nCalculo    *= NotCero( uTmp:nMedDos )
      nCalculo    *= NotCero( uTmp:nMedTre )

   case ValType( uTmp ) == "A"
      nCalculo    := uTmp[ _NUNICAJA ]
      nCalculo    *= NotCaja( uTmp[ _NCANPED ] )
      nCalculo    *= NotCero( uTmp[ _NUNDKIT ] )
      nCalculo    *= NotCero( uTmp[ _NMEDUNO ] )
      nCalculo    *= NotCero( uTmp[ _NMEDDOS ] )
      nCalculo    *= NotCero( uTmp[ _NMEDTRE ] )

   end case

RETURN ( nCalculo )

//---------------------------------------------------------------------------//
//Total de una linea con impuestos incluidos

FUNCTION nTotFPedPrv( cPedPrvL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn, cPorDiv )

   local nCalculo := 0

   nCalculo       += nTotLPedPrv( cPedPrvL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )
   nCalculo       += nIvaLPedPrv( cPedPrvL, nDec, nRou, nVdv, lDto, lPntVer, lImpTrn )

return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nTotUPedPrv( uTmp, nDec, nVdv )

   local nCalculo := 0

   DEFAULT uTmp   := dbfPedPrvL
   DEFAULT nDec   := nDinDiv()
   DEFAULT nVdv   := 1

   do case
      case ValType( uTmp ) == "C"
         nCalculo := ( uTmp )->nPreDiv

      case ValType( uTmp ) == "O"
         nCalculo := uTmp:nPreDiv

      case ValType( uTmp ) == "A"
         nCalculo := uTmp[ _NPREDIV ]

   end case

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nImpUPedPrv( uPedPrvT, uPedPrvL, nDec, nVdv, cPorDiv )

   local nCalculo       := 0

   DEFAULT uPedPrvT     := dbfPedPrvt
   DEFAULT uPedPrvL     := dbfPedPrvL
   DEFAULT nDec         := nDinDiv()
   DEFAULT nVdv         := 1

   nCalculo             := nTotUPedPrv( uPedPrvL, nDec, nVdv ) 

   if IsArray( uPedPrvT )

      nCalculo          -= Round( nCalculo * uPedPrvT[ _NDTOESP ]  / 100, nDec )
      nCalculo          -= Round( nCalculo * uPedPrvT[ _NDPP    ]  / 100, nDec )
      nCalculo          -= Round( nCalculo * uPedPrvT[ _NDTOUNO ]  / 100, nDec )
      nCalculo          -= Round( nCalculo * uPedPrvT[ _NDTODOS ]  / 100, nDec )
   
   else
   
      nCalculo          -= Round( nCalculo * ( uPedPrvT )->nDtoEsp / 100, nDec )
      nCalculo          -= Round( nCalculo * ( uPedPrvT )->nDpp    / 100, nDec )
      nCalculo          -= Round( nCalculo * ( uPedPrvT )->nDtoUno / 100, nDec )
      nCalculo          -= Round( nCalculo * ( uPedPrvT )->nDtoDos / 100, nDec )
   
   end if

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nIvaUPedPrv( uTmp, nDec, nVdv )

   local nCalculo

   DEFAULT uTmp   := dbfPedPrvL
   DEFAULT nDec   := nDinDiv()
   DEFAULT nVdv   := 1

   nCalculo       := nTotUPedPrv( uTmp, nDec, nVdv )
   nCalculo       := nCalculo * ( uTmp )->nIva / 100

   if nVdv != 0
      nCalculo    := nCalculo / nVdv
   end if

RETURN ( Round( nCalculo, nDec ) )

//---------------------------------------------------------------------------//

FUNCTION nTotLPedPrv( uTmp, nDec, nRec, nVdv, cPouDiv )

   local nCalculo

   DEFAULT uTmp   := dbfPedPrvL
   DEFAULT nDec   := nDinDiv()
   DEFAULT nRec   := nRinDiv()
   DEFAULT nVdv   := 1

   // Precio ------------------------------------------------------------------

   nCalculo       := nTotUPedPrv( uTmp, nDec, nVdv )

   do case
      case ValType( uTmp ) == "C"

         if ( uTmp )->nDtoLin != 0
            nCalculo    -= nCalculo * ( uTmp )->nDtoLin / 100
         end if

         if ( uTmp )->nDtoPrm != 0
            nCalculo    -= nCalculo * ( uTmp )->nDtoPrm / 100
         end if

      case ValType( uTmp ) == "O"

         if uTmp:nDtoLin != 0
            nCalculo    -= nCalculo * uTmp:nDtoLin / 100
         end if

         if uTmp:nDtoPrm != 0
            nCalculo    -= nCalculo * uTmp:nDtoPrm / 100
         end if

   end case

   // Unidades

   nCalculo       *= nTotNPedPrv( uTmp )

   if nRec != nil
      nCalculo    := Round( nCalculo, nRec )
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//
/*
Devuelve el importe de descuento porcentual por cada linea---------------------
*/

FUNCTION nDtoLPedPrv( cPedPrvL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cPedPrvL     := dbfPedPrvL
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cPedPrvL )->nDtoLin != 0 

      nCalculo          := nTotUPedPrv( cPedPrvL, nDec ) * nTotNPedPrv( cPedPrvL )

      /*
      Descuentos---------------------------------------------------------------
      */

      nCalculo          := nCalculo * ( cPedPrvL )->nDtoLin / 100


      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//
/*
Devuelve el importe de descuento porcentual en promociones por cada linea------
*/

FUNCTION nPrmLPedPrv( cPedPrvL, nDec, nRou, nVdv )

   local nCalculo       := 0

   DEFAULT cPedPrvL     := dbfPedPrvL
   DEFAULT nDec         := nDouDiv()
   DEFAULT nRou         := nRouDiv()
   DEFAULT nVdv         := 1

   if ( cPedPrvL )->nDtoPrm != 0 

      nCalculo          := nTotUPedPrv( cPedPrvL, nDec ) * nTotNPedPrv( cPedPrvL )

      /*
      Descuentos---------------------------------------------------------------
      */

      if ( cPedPrvL )->nDtoLin != 0 
         nCalculo       -= nCalculo * ( cPedPrvL )->nDtoLin / 100
      end if

      nCalculo          := nCalculo * ( cPedPrvL )->nDtoPrm / 100

      if nVdv != 0
         nCalculo       := nCalculo / nVdv
      end if

      if nRou != nil
         nCalculo       := Round( nCalculo, nRou )
      end if

   end if

RETURN ( nCalculo ) 

//---------------------------------------------------------------------------//

FUNCTION nIvaLPedPrv( uPedPrvL, nDec, nRec, nVdv, cPouDiv )

   local nCalculo

   DEFAULT uPedPrvL  := dbfPedPrvL
   DEFAULT nDec      := nDinDiv()
   DEFAULT nRec      := nRinDiv()
   DEFAULT nVdv      := 1

   nCalculo          := nTotLPedPrv( uPedPrvL, nDec, nRec, nVdv, cPouDiv )

   nCalculo          := Round( nCalculo * ( uPedPrvL )->nIva / 100, nRec )

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION nImpLPedPrv( uPedPrvT, uPedPrvL, nDec, nRec, nVdv, lIva, cPouDiv )

   local nCalculo

   DEFAULT uPedPrvT  := dbfPedPrvT
   DEFAULT uPedPrvL  := dbfPedPrvL
   DEFAULT nDec      := nDinDiv()
   DEFAULT nRec      := nRinDiv()
   DEFAULT nVdv      := 1
   DEFAULT lIva      := .f.

   nCalculo          := nTotLPedPrv( uPedPrvL, nDec, nRec, nVdv )

   if ValType( uPedPrvT ) == "A"
      nCalculo    -= Round( nCalculo * uPedPrvT[ _NDTOESP ]  / 100, nRec )
      nCalculo    -= Round( nCalculo * uPedPrvT[ _NDPP    ]  / 100, nRec )
      nCalculo    -= Round( nCalculo * uPedPrvT[ _NDTOUNO ]  / 100, nRec )
      nCalculo    -= Round( nCalculo * uPedPrvT[ _NDTODOS ]  / 100, nRec )
   else
      nCalculo    -= Round( nCalculo * ( uPedPrvT )->nDtoEsp / 100, nRec )
      nCalculo    -= Round( nCalculo * ( uPedPrvT )->nDpp    / 100, nRec )
      nCalculo    -= Round( nCalculo * ( uPedPrvT )->nDtoUno / 100, nRec )
      nCalculo    -= Round( nCalculo * ( uPedPrvT )->nDtoDos / 100, nRec )
   end if

   if lIva .and. ( dbfPedPrvL )->nIva != 0
      nCalculo    += nCalculo * ( uPedPrvL )->nIva / 100
   end if

RETURN ( if( cPouDiv != NIL, Trans( nCalculo, cPouDiv ), nCalculo ) )

//----------------------------------------------------------------------------//

FUNCTION nBrtLPedPrv( uTmpLin, nDec, nRec, nVdv, cPorDiv )

   local nCalculo    := 0

   DEFAULT nDec      := 2
   DEFAULT nVdv      := 1

   nCalculo          := nTotUPedPrv( uTmpLin, nDec, nVdv, cPorDiv )
   nCalculo          *= nTotNPedPrv( uTmpLin )

   nCalculo          := Round( nCalculo / nVdv, nRec )

Return ( if( cPorDiv != nil, Trans( nCalculo, cPorDiv ), nCalculo ) )

//---------------------------------------------------------------------------//

FUNCTION mkPedPrv( cPath, lAppend, cPathOld, oMeter, bFor )

   local oldPedPrvT
   local oldPedPrvL
   local oldPedPrvI
   local oldPedPrvD

   DEFAULT lAppend   := .f.
   DEFAULT bFor      := {|| .t. }

   if oMeter != NIL
      oMeter:cText   := "Generando bases"
      SysRefresh()
   end if

   CreateFiles( cPath )

   rxPedPrv( cPath, oMeter )

   IF lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "PedPROVT.DBF", cCheckArea( "PedPROVT", @dbfPedPrvT ), .f. )
      if !( dbfPedPrvT )->( neterr() )
            ordListAdd( cPath + "PedPROVT.CDX"  )
      end if

      dbUseArea( .t., cDriver(), cPath + "PedPROVL.DBF", cCheckArea( "PedPROVL", @dbfPedPrvL ), .f. )
      if !( dbfPedPrvL )->( neterr() )
            ordListAdd( cPath + "PedPROVL.CDX"  )
      end if

      dbUseArea( .t., cDriver(), cPath + "PedPrvI.Dbf", cCheckArea( "PedPrvI", @dbfPedPrvI ), .f. )
      if !( dbfPedPrvI )->( neterr() )
            ( dbfPedPrvI )->( ordListAdd( cPath + "PedPrvI.Cdx" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "PedPrvD.Dbf", cCheckArea( "PedPrvD", @dbfPedPrvD ), .f. )
      if !( dbfPedPrvD)->( neterr() )
            ( dbfPedPrvD )->( ordListAdd( cPath + "PedPrvD.Cdx" ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "PEDPROVT.DBF", cCheckArea( "PEDPROVT", @oldPedPrvT ), .f. )
      if !( oldPedPrvT )->( neterr() )
            ordListAdd( cPathOld + "PEDPROVT.CDX"  )
      end if

       dbUseArea( .t., cDriver(), cPathOld + "PEDPROVL.DBF", cCheckArea( "PEDPROVL", @oldPedPrvL ), .f. )
      if !( oldPedPrvL )->( neterr() )
            ordListAdd( cPathOld + "PEDPROVL.CDX"  )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "PEDPRVI.DBF", cCheckArea( "PEDPRVI", @oldPedPrvI ), .f. )
      if !( oldPedPrvI )->( neterr() )
            ( oldPedPrvI )->( ordListAdd( cPathOld + "PEDPRVI.CDX" ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "PEDPRVD.DBF", cCheckArea( "PEDPRVD", @oldPedPrvD ), .f. )
      if !( dbfPedPrvD)->( neterr() )
            ( oldPedPrvD )->( ordListAdd( cPathOld + "PEDPRVD.CDX" ) )
      end if

      while !( oldPedPrvT )->( eof() )

         if eval( bFor, oldPedPrvT )
            dbCopy( oldPedPrvT, dbfPedPrvT, .t. )

            if ( dbfPedPrvT )->( dbRLock() )
               ( dbfPedPrvT )->cTurPed    := Padl( "1", 6 )
               ( dbfPedPrvT )->( dbRUnlock() )
            end if

            if ( oldPedPrvL )->( dbSeek( (oldPedPrvT)->CSERPED + Str( (oldPedPrvT)->nNumPed ) + (oldPedPrvT)->cSufPed ) )
               while (oldPedPrvT)->CSERPED + Str( (oldPedPrvL)->nNumPed ) + (oldPedPrvL)->cSufPed == (oldPedPrvT)->CSERPED + Str( (dbfPedPrvT)->nNumPed ) + (dbfPedPrvT)->cSufPed .and. !(oldPedPrvL)->( eof() )
                  dbCopy( oldPedPrvL, dbfPedPrvL, .t. )
                  ( oldPedPrvL )->( dbSkip() )
               end while
            end if

            if ( oldPedPrvI )->( dbSeek( ( oldPedPrvT )->cSerPed + Str( ( oldPedPrvT )->nNumPed ) + ( oldPedPrvT )->cSufPed ) )
               while ( oldPedPrvI )->cSerPed + Str( ( oldPedPrvI )->nNumPed ) + ( oldPedPrvI )->cSufPed == ( oldPedPrvT )->cSerPed + Str( ( oldPedPrvT )->nNumPed ) + ( oldPedPrvT )->cSufPed .and. !( oldPedPrvI )->( eof() )
                  dbCopy( oldPedPrvI, dbfPedPrvI, .t. )
                  ( oldPedPrvI )->( dbSkip() )
               end while
            end if

            if ( oldPedPrvD )->( dbSeek( ( oldPedPrvT )->cSerPed + Str( ( oldPedPrvT )->nNumPed ) + ( oldPedPrvT )->cSufPed ) )
               while ( oldPedPrvD )->cSerPed + Str( ( oldPedPrvD )->nNumPed ) + ( oldPedPrvD )->cSufPed == ( oldPedPrvT )->cSerPed + Str( ( oldPedPrvT )->nNumPed ) + ( oldPedPrvT )->cSufPed .and. !( oldPedPrvD )->( eof() )
                  dbCopy( oldPedPrvD, dbfPedPrvD, .t. )
                  ( oldPedPrvD )->( dbSkip() )
               end while
            end if

         end if

         ( oldPedPrvT )->( dbSkip() )

      end while

      ( dbfPedPrvT )->( dbCloseArea() )
      ( dbfPedPrvL )->( dbCloseArea() )
      ( dbfPedPrvI )->( dbCloseArea() )
      ( dbfPedPrvD )->( dbCloseArea() )

      ( oldPedPrvT )->( dbCloseArea() )
      ( oldPedPrvL )->( dbCloseArea() )
      ( oldPedPrvI )->( dbCloseArea() )
      ( oldPedPrvD )->( dbCloseArea() )

   end if

Return nil

//--------------------------------------------------------------------------//

FUNCTION rxPedPrv( cPath, oMeter )

	local dbfPedPrvT

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "PEDPROVT.DBF" ) .or. ;
      !lExistTable( cPath + "PEDPROVL.DBF" ) .or. ;
      !lExistTable( cPath + "PEDPRVI.DBF" )  .or. ;
      !lExistTable( cPath + "PEDPRVD.DBF" )
      CreateFiles( cPath )
   end if

	/*
	Eliminamos los indices
	*/

   fEraseIndex( cPath + "PEDPROVT.CDX" )
   fEraseIndex( cPath + "PEDPROVL.CDX" )
   fEraseIndex( cPath + "PEDPRVI.CDX" )
   fEraseIndex( cPath + "PEDPRVD.CDX" )

   dbUseArea( .t., cDriver(), cPath + "PEDPROVT.DBF", cCheckArea( "PEDPROVT", @dbfPedPrvT ), .f. )
   if !( dbfPedPrvT )->( neterr() )
      ( dbfPedPrvT)->( __dbPack() )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVT.CDX", "NNUMPED", "CSERPED + STR( NNUMPED ) + CSUFPED", {|| Field->CSERPED + STR( Field->nNumPed ) + Field->cSufPed } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVT.CDX", "DFECPED", "DFECPED", {|| Field->DFECPED } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVT.CDX", "DFECENT", "DFECENT", {|| Field->DFECENT } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVT.CDX", "CCODPRV", "CCODPRV", {|| Field->CCODPRV } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVT.CDX", "CNOMPRV", "Upper( CNOMPRV )", {|| Upper( Field->CNOMPRV ) } ) )


      /*
      Ordenes fechados---------------------------------------------------------
      */

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVT.CDX", "nNumPedYea", "Str( Year( dFecPed ) ) + CSERPED + STR( NNUMPED ) + CSUFPED", {|| Str( Year( Field->dFecPed ) ) + Field->CSERPED + STR( Field->nNumPed ) + Field->cSufPed } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVT.CDX", "dFecPedYea", "Str( Year( dFecPed ) ) + Dtoc( DFECPED )", {|| Str( Year( Field->dFecPed ) ) + Dtoc( Field->DFECPED ) } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVT.CDX", "dFecEntYea", "Str( Year( dFecPed ) ) + Dtoc( DFECENT )", {|| Str( Year( Field->dFecPed ) ) + Dtoc( Field->DFECENT ) } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVT.CDX", "cCodPrvYea", "Str( Year( dFecPed ) ) + CCODPRV", {|| Str( Year( Field->dFecPed ) ) + Field->CCODPRV } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVT.CDX", "cNomPrvYea", "Str( Year( dFecPed ) ) + Upper( CNOMPRV )", {|| Str( Year( Field->dFecPed ) ) + Upper( Field->CNOMPRV ) } ) )

      /*
      Otros ordenes------------------------------------------------------------
      */

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVT.CDX", "NESTADO", "NESTADO", {|| Field->NESTADO } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PedProvT.CDX", "cTurPed", "cTurPed + cSufPed + cCodCaj", {|| Field->cTurPed + Field->cSufPed + Field->cCodCaj } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PedProvT.Cdx", "cPedCli", "cNumPedCli", {|| Field->cNumPedCli } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PedProvT.Cdx", "cCodUsr", "cCodUsr + Dtos( dFecChg ) + cTimChg", {|| Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PedProvT.Cdx", "cNumAlb", "cNumAlb", {|| Field->cNumAlb } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVT.CDX", "iNumPed", "'01' + CSERPED + STR( NNUMPED ) + CSUFPED", {|| '01' + Field->CSERPED + STR( Field->nNumPed ) + Field->cSufPed } ) )

      ( dbfPedPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de proveedores" )
   end if

   dbUseArea( .t., cDriver(), cPath + "PEDPROVL.DBF", cCheckArea( "PEDPROVL", @dbfPedPrvT ), .f. )
   if !( dbfPedPrvT )->( neterr() )
      ( dbfPedPrvT)->( __dbPack() )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVL.CDX", "nNumPed", "cSerPed + Str( nNumPed ) + cSufPed", {|| Field->cSerPed + Str( Field->nNumPed ) + Field->cSufPed } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVL.CDX", "cRef", "cRef", {|| Field->cRef }, ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVL.CDX", "Lote", "cLote", {|| Field->cLote }, ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVL.CDX", "cRefLote", "cRef + cLote", {|| Field->cRef + Field->cLote } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVL.CDX", "cPedCliRef", "cPedCli + cRef + cValPr1 + cValPr2", {|| Field->cPedCli + Field->cRef + Field->cValPr1 + Field->cValPr2 } ) )

      ( dbfPedPrvT)->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT)->( ordCreate( cPath + "PEDPROVL.CDX", "cPedCliDet", "cPedCli + cRef + cValPr1 + cValPr2 + cRefPrv ", {|| Field->cPedCli + Field->cRef + Field->cValPr1 + Field->cValPr2 + Field->cRefPrv } ) ) // + cDetalle

      ( dbfPedPrvT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfPedPrvT )->( ordCreate( cPath + "PedProvL.Cdx", "iNumPed", "'01' + cSerPed + Str( nNumPed ) + cSufPed", {|| '01' + Field->cSerPed + Str( Field->nNumPed ) + Field->cSufPed } ) )

      ( dbfPedPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de proveedores" )
   end if

   dbUseArea( .t., cDriver(), cPath + "PedPrvI.DBF", cCheckArea( "PedPrvI", @dbfPedPrvT ), .f. )
   if !( dbfPedPrvT )->( neterr() )
      ( dbfPedPrvT )->( __dbPack() )

      ( dbfPedPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT )->( ordCreate( cPath + "PedPrvI.CDX", "NNUMPED", "CSERPED + STR( NNUMPED ) + CSUFPED", {|| Field->CSERPED + STR( Field->nNumPed ) + Field->cSufPed } ) )

      ( dbfPedPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de proveedores" )
   end if

   dbUseArea( .t., cDriver(), cPath + "PedPrvD.DBF", cCheckArea( "PedPrvD", @dbfPedPrvT ), .f. )
   if !( dbfPedPrvT )->( neterr() )
      ( dbfPedPrvT )->( __dbPack() )

      ( dbfPedPrvT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfPedPrvT )->( ordCreate( cPath + "PedPrvD.CDX", "NNUMPED", "CSERPED + STR( NNUMPED ) + CSUFPED", {|| Field->CSERPED + STR( Field->nNumPed ) + Field->cSufPed } ) )

      ( dbfPedPrvT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de pedidos de proveedores" )
   end if

Return nil

//--------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local lErrors     := .f.
   local cDbf        := "PProL"
   local cDbfInc     := "PProI"
   local cDbfDoc     := "PProD"
   local nPedido     := aTmp[ _CSERPED ] +  Str( aTmp[ _NNUMPED ] ) + aTmp[ _CSUFPED ]
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      cNewFile       := cGetNewFileName( cPatTmp() + cDbf )
      cTmpInc        := cGetNewFileName( cPatTmp() + cDbfInc )
      cTmpDoc        := cGetNewFileName( cPatTmp() + cDbfDoc )

      /*
      Primero Crear la base de datos local----------------------------------------
      */

      dbCreate( cNewFile, aSqlStruct( aColPedPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cNewFile, cCheckArea( cDbf, @dbfTmpLin ), .f. )

      if !( dbfTmpLin )->( neterr() )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cNewFile, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin, 4 ) } ) )

         ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpLin )->( OrdCreate( cNewFile, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

      end if

      /*
      Creamos el fichero de incidencias-------------------------------------------
      */

      dbCreate( cTmpInc, aSqlStruct( aIncPedPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpInc, cCheckArea( cDbfInc, @dbfTmpInc ), .f. )

      if !( dbfTmpInc )->( neterr() )
         ( dbfTmpInc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpInc )->( ordCreate( cTmpInc, "Recno", "Recno()", {|| Recno() } ) )
      end if

      /*
      Creamos el fichero de Documentos--------------------------------------------
      */

      dbCreate( cTmpDoc, aSqlStruct( aPedPrvDoc() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )
      if !( dbfTmpDoc )->( neterr() )
         ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
         ( dbfTmpDoc )->( ordCreate( cTmpDoc, "Recno", "Recno()", {|| Recno() } ) )
      end if

      /*
      A¤adimos desde el fichero de lineas-----------------------------------------
      */

      if ( dbfPedPrvL )->( dbSeek( nPedido ) )

         do while ( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed == nPedido )

            dbPass( dbfPedPrvL, dbfTmpLin, .t. )

            ( dbfPedPrvL )->( dbSkip() )

         end while

      end if

      ( dbfTmpLin )->( dbGoTop() )

      /*
      A¤adimos desde el fichero de incidencias------------------------------------
      */

      if ( dbfPedPrvI )->( dbSeek( nPedido ) )

         while ( ( dbfPedPrvI )->cSerPed + Str( ( dbfPedPrvI )->nNumPed ) + ( dbfPedPrvI )->cSufPed == nPedido ) .AND. ( dbfPedPrvI )->( !eof() )

            dbPass( dbfPedPrvI, dbfTmpInc, .t. )
            ( dbfPedPrvI )->( dbSkip() )

         end while

      end if

      ( dbfTmpInc )->( dbGoTop() )

      /*
      A¤adimos desde el fichero de Documentos-------------------------------------
      */

      if ( dbfPedPrvD )->( dbSeek( nPedido ) )

         while ( ( dbfPedPrvD )->cSerPed + Str( ( dbfPedPrvD )->nNumPed ) + ( dbfPedPrvD )->cSufPed == nPedido ) .AND. ( dbfPedPrvD )->( !eof() )

            dbPass( dbfPedPrvD, dbfTmpDoc, .t. )
            ( dbfPedPrvD )->( dbSkip() )

         end while

      end if

      ( dbfTmpDoc )->( dbGoTop() )


   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales." + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lErrors )

//---------------------------------------------------------------------------//

function aIncPedPrv()

   local aIncPedPrv  := {}

   aAdd( aIncPedPrv, { "cSerPed", "C",    1,  0, "Serie de pedido" ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "nNumPed", "N",    9,  0, "Número de pedido" ,                "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "cSufPed", "C",    2,  0, "Sufijo de pedido" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,          "",                   "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,    "",                   "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "lListo",  "L",    1,  0, "Lógico de listo" ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aIncPedPrv, { "lAviso",  "L",    1,  0, "Lógico de Aviso" ,                 "",                   "", "( cDbfCol )" } )

return ( aIncPedPrv )

//---------------------------------------------------------------------------//

function aPedPrvDoc()

   local aPedPrvDoc  := {}

   aAdd( aPedPrvDoc, { "cSerPed", "C",    1,  0, "Serie de pedido" ,                 "",                   "", "( cDbfCol )" } )
   aAdd( aPedPrvDoc, { "nNumPed", "N",    9,  0, "Número de pedido" ,                "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aPedPrvDoc, { "cSufPed", "C",    2,  0, "Sufijo de pedido" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aPedPrvDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aPedPrvDoc, { "cRuta",   "M",   10,  0, "Ruta del documento" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aPedPrvDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,     "",                   "", "( cDbfCol )" } )

return ( aPedPrvDoc )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aGet, aTmp, oBrw, nMode, oDlg )

   local oError
   local oBlock
   local aTabla
   local cSerie
   local nPedido
   local cSufPed
   local nNumLin
   local cNumPedCli

   if Empty( aTmp[ _CSERPED ] )
      aTmp[ _CSERPED ]  := "A"
   end if

   nNumLin              := 1
   cSerie               := aTmp[ _CSERPED ]
   nPedido              := aTmp[ _NNUMPED ]
   cSufPed              := aTmp[ _CSUFPED ]
   cNumPedCli           := aTmp[ _CNUMPEDCLI ]

   /*
   Comprobamos la fecha del documento
   */

   if !lValidaOperacion( aTmp[ _DFECPED ] )
      Return .f.
   end if

   /*
   Estos campos no pueden estar vacios
   */

   if Empty( aTmp[ _CCODPRV ] )
      msgStop( "Proveedor no puede estar vacío." )
      aGet[ _CCODPRV ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODALM ] )
      msgStop( "Almacen no puede estar vacío." )
      aGet[ _CCODALM ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODCAJ ] )
      msgStop( "Caja no puede estar vacía." )
      aGet[ _CCODCAJ ]:SetFocus()
      return .f.
   end if

   if ( dbfTmpLin )->( eof() )
      MsgStop( "No puede almacenar un documento sin líneas." )
      return .f.
   end if

   oDlg:Disable()

   oMsgText( "Archivando" )

   aTmp[ _DFECCHG ]     := GetSysDate()
   aTmp[ _CTIMCHG ]     := Time()

   do case
   case nMode == APPD_MODE .or. nMode == DUPL_MODE

      nPedido           := nNewDoc( cSerie, dbfPedPrvT, "NPEDPRV", , dbfCount )
      aTmp[ _NNUMPED ]  := nPedido

   case nMode == EDIT_MODE

      if nPedido != 0

         while ( dbfPedPrvL )->( dbSeek( cSerie + str( nPedido ) + cSufPed ) )
            if dbLock( dbfPedPrvL )
               ( dbfPedPrvL )->( dbDelete() )
               ( dbfPedPrvL )->( dbUnLock() )
            end if
         end while

         while ( dbfPedPrvI )->( dbSeek( cSerie + str( nPedido ) + cSufPed ) )
            if dbLock( dbfPedPrvI )
               ( dbfPedPrvI )->( dbDelete() )
               ( dbfPedPrvI )->( dbUnLock() )
            end if
         end while

         while ( dbfPedPrvD )->( dbSeek( cSerie + str( nPedido ) + cSufPed ) )
            if dbLock( dbfPedPrvD )
               ( dbfPedPrvD )->( dbDelete() )
               ( dbfPedPrvD )->( dbUnLock() )
            end if
         end while

      end if

   end case

   /*
   Guardamos los totales-------------------------------------------------------
   */

   aTmp[ _NTOTNET ]     := nTotNet
   aTmp[ _NTOTIVA ]     := nTotIva
   aTmp[ _NTOTREQ ]     := nTotReq
   aTmp[ _NTOTPED ]     := nTotPed
/*
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
*/
   BeginTransaction()

   /*
   Quitamos los filtros--------------------------------------------------------
   */

   ( dbfTmpLin )->( dbClearFilter() )

   oMsgProgress()
   oMsgProgress():SetRange( 0, ( dbfTmpLin )->( LastRec() ) )

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
	*/

   ( dbfTmpLin )->( dbGoTop() )
   while !( dbfTmpLin )->( eof() )
      dbPass( dbfTmpLin, dbfPedPrvL, .t., cSerie, nPedido, cSufPed )
      ( dbfTmpLin )->( dbSkip() )
      oMsgProgress():Deltapos(1)
   end while

   /*
   Ahora escribimos en el fichero definitivo de incidencias
	*/

   ( dbfTmpInc )->( dbGoTop() )
   while ( dbfTmpInc )->( !eof() )
      dbPass( dbfTmpInc, dbfPedPrvI, .t., cSerie, nPedido, cSufPed )
      ( dbfTmpInc )->( dbSkip() )
   end while

   /*
   Ahora escribimos en el fichero definitivo de documentos
	*/

   ( dbfTmpDoc )->( dbGoTop() )
   while ( dbfTmpDoc )->( !eof() )
      dbPass( dbfTmpDoc, dbfPedPrvD, .t., cSerie, nPedido, cSufPed )
      ( dbfTmpDoc )->( dbSkip() )
   end while

   /*
   Salvamos el registro del pedido
   */

   WinGather( aTmp, , dbfPedPrvT, oBrw, nMode )

   /*
   Ponemos el pedido en su estado
   */

   oStock:SetPedPrv( cSerie + str( nPedido ) + cSufPed )

   dbCommitAll()

   CommitTransaction()
/*
   RECOVER USING oError

      RollBackTransaction()
      msgStop( "Imposible almacenar pedido" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )
*/
   oMsgText()
   EndProgress()

   oDlg:Enable()
   oDlg:End( IDOK )

Return .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION KillTrans( oBrwLin )

	/*
   Borramos los ficheros-------------------------------------------------------
	*/

   if !Empty( dbfTmpLin ) .and. ( dbfTmpLin )->( Used() )
      ( dbfTmpLin )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() )
      ( dbfTmpInc )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpDoc ) .and. ( dbfTmpDoc )->( Used() )
      ( dbfTmpDoc )->( dbCloseArea() )
   end if


   dbfErase( cNewFile )
   dbfErase( cTmpInc )
   dbfErase( cTmpDoc )

   /*
   Guardamos los posibles cambios en el browse---------------------------------
   */

   if oBrwLin != nil
      oBrwLin:CloseData()
   end if


RETURN .T.

//---------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "PedProvT.DBF" )
      dbCreate( cPath + "PedProvT.DBF", aSqlStruct( aItmPedPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedProvL.DBF" )
      dbCreate( cPath + "PedProvL.DBF", aSqlStruct( aColPedPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedPrvI.Dbf" )
      dbCreate( cPath + "PedPrvI.Dbf", aSqlStruct( aIncPedPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedPrvD.Dbf" )
      dbCreate( cPath + "PedPrvD.Dbf", aSqlStruct( aPedPrvDoc() ), cDriver() )
   end if

RETURN NIL

//--------------------------------------------------------------------------//
/*
Cambia el estado de un pedido
*/

STATIC FUNCTION ChgState( oBrw )

   local nRec
   local nRecAlb
   local nOrdAlb
   local cNumPed
   local lQuit

   CursorWait()
   SysRefresh()

   if ApoloMsgNoYes( "Al cambiar el estado perderá la referencia a cualquier documento que esté asociado.", "¿Desea cambiarlo?" )

      /*
      Cambia el estado del pedido----------------------------------------------
      */

      /*if dbLock( dbfPedPrvT )

         if ( dbfPedPrvT )->nEstado == 1
            ( dbfPedPrvT )->nEstado := 3
         else
            ( dbfPedPrvT )->nEstado := 1
         end if

         ( dbfPedPrvT )->( dbUnlock() )

      end if*/

      for each nRec in ( oBrw:aSelected )

         ( dbfPedPrvT )->( dbGoTo( nRec ) )

         lQuit                         := .f.

         cNumPed                       := ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT  )->cSufPed

         /*
         Cambiamos el estado---------------------------------------------------
         */

         if dbLock( dbfPedPrvT )

            if ( dbfPedPrvT )->nEstado == 1
               ( dbfPedPrvT )->nEstado := 3
            else
               lQuit                   := .t.
               ( dbfPedPrvT )->nEstado := 1
               ( dbfPedPrvT )->cNumAlb := ""
            end if

            ( dbfPedPrvT )->( dbRUnlock() )

         end if

         if lQuit

            /*
            Borramos la referencia a cualquier cabecera de albarán asociado-------
            */

            nRecAlb  := ( dbfAlbPrvT )->( RecNo() )
            nOrdAlb  := ( dbfAlbPrvT )->( OrdSetFocus( "CNUMPED" ) )


            if ( dbfAlbPrvT )->( dbSeek( cNumPed ) )

               while ( dbfAlbPrvT )->cNumPed == cNumPed  .and. !( dbfAlbPrvT )->( Eof() )

                  if dbLock( dbfAlbPrvT )
                     ( dbfAlbPrvT )->cNumPed    := ""
                     ( dbfAlbPrvT )->( dbUnLock() )
                  end if

                  ( dbfAlbPrvT )->( dbSkip() )

               end if

            end if

            ( dbfAlbPrvT )->( OrdSetFocus( nOrdAlb ) )
            ( dbfAlbPrvT )->( dbGoTo( nRecAlb ) )

            /*
            Borramos la referencia a cualquier linea de albarán asociado-------
            */

            nRecAlb  := ( dbfAlbPrvL )->( RecNo() )
            nOrdAlb  := ( dbfAlbPrvL )->( OrdSetFocus( "cCodPed" ) )

            if ( dbfAlbPrvL )->( dbSeek( cNumPed ) )

               while ( dbfAlbPrvL )->cCodPed == cNumPed  .and. !( dbfAlbPrvL )->( Eof() )

                  if dbLock( dbfAlbPrvL )
                     ( dbfAlbPrvL )->cCodPed    := ""
                     ( dbfAlbPrvL )->( dbUnLock() )
                  end if

                  ( dbfAlbPrvL )->( dbSkip() )

               end if

            end if

            ( dbfAlbPrvL )->( OrdSetFocus( nOrdAlb ) )
            ( dbfAlbPrvL )->( dbGoTo( nRecAlb ) )

         end if

      next

    end if

    oBrw:Refresh()
    oBrw:SetFocus()

   CursorArrow()
   SysRefresh()

RETURN NIL

//-------------------------------------------------------------------------//

FUNCTION lSnd( oWndBrw, dbf )

   local nRecAct
   local nRecOld           := ( dbf )->( Recno() )

   for each nRecAct in ( oWndBrw:oBrw:aSelected )

      ( dbf )->( dbGoTo( nRecAct ) )

      if dbDialogLock( dbf )

         ( dbf )->lSndDoc  := !( dbf )->lSndDoc

         ( dbf )->( dbUnlock() )

      end if

   next

   ( dbf )->( dbGoTo( nRecOld ) )

    oWndBrw:Refresh()

    oWndBrw:SetFocus()

Return nil

//---------------------------------------------------------------------------//

Static Function lNotOpen()

   if NetErr()
      msgStop( "Imposible abrir ficheros." )
      CloseFiles()
      return .t.
   end if

return .f.

//---------------------------------------------------------------------------//

Function AppPedPrv( cCodPrv, cCodArt, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedPrv( nil, nil, cCodPrv, cCodArt )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         WinAppRec( nil, bEdtRec, dbfPedPrvT, cCodPrv, cCodArt )
         CloseFiles()
      end if

   end if

RETURN .t.

//----------------------------------------------------------------------------//

FUNCTION EdtPedPrv( nNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedPrv()
         if dbSeekInOrd( nNumPed, "nNumPed", dbfPedPrvT )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumPed, "nNumPed", dbfPedPrvT )
            WinEdtRec( nil, bEdtRec, dbfPedPrvT )
         else
            MsgStop( "No se encuentra pedido" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION ZooPedPrv( nNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedPrv()
         if dbSeekInOrd( nNumPed, "nNumPed", dbfPedPrvT )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumPed, "nNumPed", dbfPedPrvT )
            WinZooRec( nil, bEdtRec, dbfPedPrvT )
         else
            MsgStop( "No se encuentra pedido" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION DelPedPrv( nNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedPrv()
         if dbSeekInOrd( nNumPed, "nNumPed", dbfPedPrvT )
            WinDelRec( nil, dbfPedPrvT, {|| QuiPedPrv() } )
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumPed, "nNumPed", dbfPedPrvT )
            WinDelRec( nil, dbfPedPrvT, {|| QuiPedPrv() } )
         else
            MsgStop( "No se encuentra pedido" )
         end if
         CloseFiles()
      end if

   end if

Return nil

//----------------------------------------------------------------------------//

FUNCTION PrnPedPrv( nNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedPrv()
         if dbSeekInOrd( nNumPed, "nNumPed", dbfPedPrvT )
            GenPedPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumPed, "nNumPed", dbfPedPrvT )
            GenPedPrv( IS_PRINTER )
         else
            MsgStop( "No se encuentra pedido" )
         end if
         CloseFiles()
      end if

   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION VisPedPrv( nNumPed, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if PedPrv()
         if dbSeekInOrd( nNumPed, "nNumPed", dbfPedPrvT )
            GenPedPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra pedido" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( nNumPed, "nNumPed", dbfPedPrvT )
            GenPedPrv( IS_SCREEN )
         else
            MsgStop( "No se encuentra pedido" )
         end if
         CloseFiles()
      end if

   end if

Return nil

//---------------------------------------------------------------------------//

function nVtaPedPrv( cCodPrv, dDesde, dHasta, dbfPedPrvT, dbfPedPrvL, dbfIva, dbfDiv )

   local nCon     := 0
   local nRec     := ( dbfPedPrvT )->( Recno() )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( dbfPedPrvT )->( dbSeek( cCodPrv ) )

      while ( dbfPedPrvT )->cCodPrv == cCodPrv .and. !( dbfPedPrvT )->( Eof() )

         if ( dDesde == nil .or. ( dbfPedPrvT )->dFecPed >= dDesde )    .and.;
            ( dHasta == nil .or. ( dbfPedPrvT )->dFecPed <= dHasta )

            nCon  += nTotPedPrv( ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed, dbfPedPrvT, dbfPedPrvL, dbfIva, dbfDiv, nil, cDivEmp(), .f. )

         end if

         ( dbfPedPrvT )->( dbSkip() )

      end while

   end if

   ( dbfPedPrvT )->( dbGoTo( nRec ) )

return nCon

//----------------------------------------------------------------------------//

static function lGenPed( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if Empty( oBtn )
      return nil
   end if

   if !( dbfDoc )->( dbSeek( "PP" ) )

      DEFINE BTNSHELL RESOURCE "DOCUMENT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay pedidos de proveedores predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   else

      while ( dbfDoc )->cTipo == "PP" .and. !( dbfDoc )->( eof() )

         bAction  := bGenPed( nDevice, "Imprimiendo pedidos de proveedores", ( dbfDoc )->CODIGO )

         oWndBrw:NewAt( "Document", , , bAction, Rtrim( ( dbfDoc )->cDescrip ) , , , , , oBtn )

         ( dbfDoc )->( dbSkip() )

      end do

   end if

   SysRefresh()

return nil

//---------------------------------------------------------------------------//

static function bGenPed( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev  := by( nDevice )
   local cTit  := by( cTitle    )
   local cCod  := by( cCodDoc   )

   if nDev == IS_PRINTER
      bGen     := {|| GenPedPrv( nDevice, cTit, cCod ) }
   else
      bGen     := {|| GenPedPrv( nDevice, cTit, cCod ) }
   end if

return bGen

//---------------------------------------------------------------------------//

FUNCTION aDocPedPrv( dbfDocFld, dbfDocCol )

   local aDoc  := {}

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Pedido",          "PP" } )
   aAdd( aDoc, { "Proveedor",       "PR" } )
   aAdd( aDoc, { "Almacen",         "AL" } )
   aAdd( aDoc, { "Divisas",         "DV" } )
   aAdd( aDoc, { "Formas de pago",  "PG" } )

RETURN ( aDoc )

//---------------------------------------------------------------------------//

FUNCTION dFecPedPrv( cPedPrv, dbfPedPrvT )

   local dFecPed  := CtoD("")

   IF ( dbfPedPrvT )->( dbSeek( cPedPrv ) )
      dFecPed  := ( dbfPedPrvT )->dFecPed
   END IF

RETURN ( dFecPed )

//---------------------------------------------------------------------------//

FUNCTION nEstPedPrv( cPedPrv, dbfPedPrvT )

   local nEstPed  := 1

   IF ( dbfPedPrvT )->( dbSeek( cPedPrv ) )
      nEstPed     := ( dbfPedPrvT )->nEstado
   END IF

RETURN ( nEstPed )

//---------------------------------------------------------------------------//

FUNCTION cNbrPedPrv( cPedPrv, dbfPedPrvT )

   local cNomPrv  := ""

   IF ( dbfPedPrvT )->( dbSeek( cPedPrv ) )
      cNomPrv  := ( dbfPedPrvT )->cNomPrv
	END IF

RETURN ( cNomPrv )

//---------------------------------------------------------------------------//

function nTotDPedPrv( cCodArt, dbfPedPrvL, dbfPedPrvT, cCodAlm )

   local nTotVta  := 0
   local nRecno   := ( dbfPedPrvL )->( Recno() )

   if ( dbfPedPrvL )->( dbSeek( cCodArt ) )

      while ( dbfPedPrvL )->cRef == cCodArt .and. !( dbfPedPrvL )->( eof() )

        if cCodAlm != nil
           if cCodAlm == ( dbfPedPrvL )->cAlmLin
              nTotVta  += nTotNPedPrv( dbfPedPrvL )
           end if
        else
           nTotVta     += nTotNPedPrv( dbfPedPrvL )
        end if

        ( dbfPedPrvL )->( dbSkip() )

      end while

   end if

   ( dbfPedPrvL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

function nTotVPedPrv( cCodArt, dbfPedPrvL, nDec, nDor )

   local nTotVta  := 0
   local nRecno   := ( dbfPedPrvL )->( Recno() )

   if ( dbfPedPrvL )->( dbSeek( cCodArt ) )

      while ( dbfPedPrvL )->CREF == cCodArt .and. !( dbfPedPrvL )->( eof() )

         nTotVta += nTotLPedPrv( dbfPedPrvL, nDec, nDor )

         ( dbfPedPrvL )->( dbSkip() )

      end while

   end if

   ( dbfPedPrvL )->( dbGoTo( nRecno ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

STATIC FUNCTION QuiPedPrv( lDetail )

   local cPedido

   DEFAULT lDetail   := .t.

   if ( dbfPedPrvT )->lCloPed .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar los pedidos cerrados los administradores." )
      Return .f.
   end if

   CursorWait()

   cPedido           := ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed

   if lDetail
      DelDetalle( cPedido )
   end if

   /*
   Actualizamos el estado del campo generado-----------------------------------
   */

   if !Empty( ( dbfPedPrvT )->cNumPedCli )
      oStock:SetGeneradoPedCli( ( dbfPedPrvT )->cNumPedCli )
   end if

   CursorWe()

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function DelDetalle( cPedido )

   local nOrdAnt

   DEFAULT cPedido  := ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed

   CursorWait()

   nOrdAnt           := ( dbfPedPrvL )->( OrdSetFocus( "nNumPed" ) )

   while ( dbfPedPrvL )->( dbSeek( cPedido ) ) .and. !( dbfPedPrvL )->( eof() )
      if dbDialogLock( dbfPedPrvL )
         ( dbfPedPrvL )->( dbDelete() )
         ( dbfPedPrvL )->( dbUnLock() )
      end if
   end do

   ( dbfPedPrvL )->( OrdSetFocus( nOrdAnt ) )

   while ( dbfPedPrvI )->( dbSeek( cPedido ) .and. !( dbfPedPrvI )->( eof() ) )
      if dbLock( dbfPedPrvI )
         ( dbfPedPrvI )->( dbDelete() )
         ( dbfPedPrvI )->( dbUnLock() )
      end if
   end while

   while ( dbfPedPrvD )->( dbSeek( cPedido ) .and. !( dbfPedPrvD )->( eof() ) )
      if dbLock( dbfPedPrvD )
         ( dbfPedPrvD )->( dbDelete() )
         ( dbfPedPrvD )->( dbUnLock() )
      end if
   end while

   CursorWe()

RETURN NIL

//---------------------------------------------------------------------------//

function aItmPedPrv()

   local aBase := {  { "cSerPed",   "C",  1,   0, "Serie del pedido",            "",                   "", "( cDbf )"},;
                     { "nNumPed",   "N",  9,   0, "Número del pedido",           "'999999999'",        "", "( cDbf )"},;
                     { "cSufPed",   "C",  2,   0, "Sufijo del pedido",           "",                   "", "( cDbf )"},;
                     { "cTurPed",   "C",  6,   0, "Sesión del pedido",           "",                   "", "( cDbf )"},;
                     { "dFecPed",   "D",  8,   0, "Fecha del pedido",            "",                   "", "( cDbf )"},;
                     { "cCodPrv",   "C", 12,   0, "Codigo del proveedor",        "",                   "", "( cDbf )"},;
                     { "cCodAlm",   "C",  3,   0, "Código de almacen",           "",                   "", "( cDbf )"},;
                     { "cCodCaj",   "C",  3,   0, "Código de caja",              "",                   "", "( cDbf )"},;
                     { "cNomPrv",   "C", 35,   0, "Nombre del proveedor",        "'@!'",               "", "( cDbf )"},;
                     { "cDirPrv",   "C", 35,   0, "Domicilio del proveedor",     "'@!'",               "", "( cDbf )"},;
                     { "cPobPrv",   "C", 25,   0, "Población del proveedor",     "'@!'",               "", "( cDbf )"},;
                     { "cProPrv",   "C", 20,   0, "Provincia del proveedor",     "'@!'",               "", "( cDbf )"},;
                     { "cPosPrv",   "C",  5,   0, "Código postal del proveedor", "",                   "", "( cDbf )"},;
                     { "cDniPrv",   "C", 30,   0, "D.N.I. del proveedor",        "",                   "", "( cDbf )"},;
                     { "dFecEnt",   "D",  8,   0, "Fecha de entrada",            "",                   "", "( cDbf )"},;
                     { "nEstado",   "N",  1,   0, "Estado del pedido",           "",                   "", "( cDbf )"},;
                     { "cSuped",    "C", 10,   0, "Comentario su pedido",        "",                   "", "( cDbf )"},;
                     { "cCodPgo",   "C",  2,   0, "Codigo de la forma de pago",  "",                   "", "( cDbf )"},;
                     { "nBulTos",   "N",  3,   0, "Número de bultos",            "'999'",              "", "( cDbf )"},;
                     { "nPorTes",   "N",  6,   0, "Precio de los portes",        "cPirDivPed",         "", "( cDbf )"},;
                     { "cDtoEsp",   "C", 50,   0, "Descripción descuento especial","",                 "", "( cDbf )"},;
                     { "nDtoEsp",   "N",  5,   2, "Descuento factura",           "'@EZ 99.99'",        "", "( cDbf )"},;
                     { "cDpp",      "C", 50,   0, "Descripción descuento pronto pago","",              "", "( cDbf )"},;
                     { "nDpp",      "N",  5,   2, "Descuento pronto pago",       "'@EZ 99.99'",        "", "( cDbf )"},;
                     { "lRecargo",  "L",  1,   0, "Recargo de equivalencia",     "",                   "", "( cDbf )"},;
                     { "cCondEnt",  "C", 20,   0, "Comentarios del pedido",      "",                   "", "( cDbf )"},;
                     { "cExped",    "C", 20,   0, "Expedición",                  "",                   "", "( cDbf )"},;
                     { "cObserv",   "M", 10,   0, "Observaciones",               "",                   "", "( cDbf )"},;
                     { "cDivPed",   "C",  3,   0, "Codigo de divisa",            "",                   "", "( cDbf )"},;
                     { "nVdvPed",   "N", 10,   4, "Valor de la divisa",          "'@EZ 999,999.9999'", "", "( cDbf )"},;
                     { "lSndDoc",   "L",  1,   0, "Enviar documento",            "",                   "", "( cDbf )"},;
                     { "cDtoUno",   "C", 25,   0, "Descripción de primer descuento personalizado", "", "", "( cDbf )"},;          //   26
                     { "nDtoUno",   "N",  5,   2, "Porcentaje de primer descuento personalizado", "",  "", "( cDbf )"},;           //   27
                     { "cDtoDos",   "C", 25,   0, "Descripción de segundo descuento personalizado","", "", "( cDbf )"},;          //   28
                     { "nDtoDos",   "N",  5,   2, "Porcentaje de segundo descuento personalizado", "", "", "( cDbf )"},;
                     { "lCloPed",   "L",  1,   0, "",                                              "", "", "( cDbf )"},;
                     { "cCodUsr",   "C",  3,   0, "Código de usuario",                             "", "", "( cDbf )"},;
                     { "cNumPedCli","C", 12,   0, "Número del pedido del cliente del que viene",   "", "", "( cDbf )"},;
                     { "lImprimido","L",  1,   0, "Lógico de imprimido del documento",             "", "", "( cDbf )"},;
                     { "dFecImp",   "D",  8,   0, "Última fecha de impresión del documento",       "", "", "( cDbf )"},;
                     { "cHorImp",   "C",  5,   0, "Hora de la última impresión del documento",     "", "", "( cDbf )"},;
                     { "dFecChg",   "D",  8,   0, "Fecha de modificación del documento",           "", "", "( cDbf )"},;
                     { "cTimChg",   "C",  5,   0, "Hora de modificación del documento",            "", "", "( cDbf )"},;
                     { "cCodDlg",   "C",  2,   0, "Código delegación",                             "", "", "( cDbf )"},;
                     { "cSituac",   "C", 20,   0, "Situación del documento",                       "", "", "( cDbf )"},;
                     { "nRegIva",   "N",  1,   0, "Regimen de " + cImp(),                             "", "", "( cDbf )"},;
                     { "nTotNet",   "N", 16,   6, "Total neto",                                    "", "", "( cDbf )"},;
                     { "nTotIva",   "N", 16,   6, "Total " + cImp(),                                     "", "", "( cDbf )"},;
                     { "nTotReq",   "N", 16,   6, "Total recargo equivalencia",                    "", "", "( cDbf )"},;
                     { "nTotPed",   "N", 16,   6, "Total pedido",                                  "", "", "( cDbf )"},;
                     { "cNumAlb",   "C", 12,   0, "Númeo del albarán en el se ha agrupado",        "", "", "( cDbf )"} }

return ( aBase )

//---------------------------------------------------------------------------//

function aCalPedPrv()

   local aCalPedPrv  := {  { "aTotIva[1,1]",                                              "N", 16,  6, "Bruto primer tipo de " + cImp(),    "cPirDivPed",  "!Empty( aTotIva[1,1] ) .and. lEnd" },;
                           { "aTotIva[2,1]",                                              "N", 16,  6, "Bruto segundo tipo de " + cImp(),   "cPirDivPed",  "!Empty( aTotIva[2,1] ) .and. lEnd" },;
                           { "aTotIva[3,1]",                                              "N", 16,  6, "Bruto tercer tipo de " + cImp(),    "cPirDivPed",  "!Empty( aTotIva[3,1] ) .and. lEnd" },;
                           { "aTotIva[1,2]",                                              "N", 16,  6, "Base primer tipo de " + cImp(),     "cPirDivPed",  "!Empty( aTotIva[1,2] ) .and. lEnd" },;
                           { "aTotIva[2,2]",                                              "N", 16,  6, "Base segundo tipo de " + cImp(),    "cPirDivPed",  "!Empty( aTotIva[2,2] ) .and. lEnd" },;
                           { "aTotIva[3,2]",                                              "N", 16,  6, "Base tercer tipo de " + cImp(),     "cPirDivPed",  "!Empty( aTotIva[3,2] ) .and. lEnd" },;
                           { "aTotIva[1,3]",                                              "N",  5,  2, "Porcentaje primer tipo " + cImp(),  "'@R 99.99%'", "!Empty( aTotIva[1,3] ) .and. lEnd" },;
                           { "aTotIva[2,3]",                                              "N",  5,  2, "Porcentaje segundo tipo " + cImp(), "'@R 99.99%'", "!Empty( aTotIva[2,3] ) .and. lEnd" },;
                           { "aTotIva[3,3]",                                              "N",  5,  2, "Porcentaje tercer tipo " + cImp(),  "'@R 99.99%'", "!Empty( aTotIva[3,3] ) .and. lEnd" },;
                           { "aTotIva[1,4]",                                              "N",  5,  2, "Porcentaje primer tipo RE",   "'@R 99.99%'", "!Empty( aTotIva[1,4] ) .and. lEnd" },;
                           { "aTotIva[2,4]",                                              "N",  5,  2, "Porcentaje segundo tipo RE",  "'@R 99.99%'", "!Empty( aTotIva[2,4] ) .and. lEnd" },;
                           { "aTotIva[3,4]",                                              "N",  5,  2, "Porcentaje tercer tipo RE",   "'@R 99.99%'", "!Empty( aTotIva[3,4] ) .and. lEnd" },;
                           { "round( aTotIva[1,2] * aTotIva[1,3] / 100, nDinDivPed )",    "N", 16,  6, "Importe primer tipo " + cImp(),     "cPinDivPed",  "!Empty( aTotIva[1,2] ) .and. lEnd" },;
                           { "round( aTotIva[2,2] * aTotIva[2,3] / 100, nDinDivPed )",    "N", 16,  6, "Importe segundo tipo " + cImp(),    "cPinDivPed",  "!Empty( aTotIva[2,2] ) .and. lEnd" },;
                           { "round( aTotIva[3,2] * aTotIva[3,3] / 100, nDinDivPed )",    "N", 16,  6, "Importe tercer tipo " + cImp(),     "cPinDivPed",  "!Empty( aTotIva[3,2] ) .and. lEnd" },;
                           { "round( aTotIva[1,2] * aTotIva[1,4] / 100, nDinDivPed )",    "N", 16,  6, "Importe primer RE",           "cPinDivPed",  "!Empty( aTotIva[1,2] ) .and. lEnd" },;
                           { "round( aTotIva[2,2] * aTotIva[2,4] / 100, nDinDivPed )",    "N", 16,  6, "Importe segundo RE",          "cPinDivPed",  "!Empty( aTotIva[2,2] ) .and. lEnd" },;
                           { "round( aTotIva[3,2] * aTotIva[3,4] / 100, nDinDivPed )",    "N", 16,  6, "Importe tercer RE",           "cPinDivPed",  "!Empty( aTotIva[3,2] ) .and. lEnd" },;
                           { "nTotBrt",                                                   "N", 16,  6, "Total bruto",                 "cPirDivPed",  "lEnd" },;
                           { "nTotDto",                                                   "N", 16,  6, "Total descuento",             "cPirDivPed",  "lEnd" },;
                           { "nTotDpp",                                                   "N", 16,  6, "Total descuento pronto pago", "cPirDivPed",  "lEnd" },;
                           { "nTotNet",                                                   "N", 16,  6, "Total neto",                  "cPirDivPed",  "lEnd" },;
                           { "nTotIva",                                                   "N", 16,  6, "Total " + cImp(),                   "cPirDivPed",  "lEnd" },;
                           { "nTotReq",                                                   "N", 16,  6, "Total RE",                    "cPirDivPed",  "lEnd" },;
                           { "nTotPed",                                                   "N", 16,  6, "Total pedido",                "cPirDivPed",  "lEnd" },;
                           { "nImpEuros( nTotPed, (cDbf)->CDIVPED, cDbfDiv )",            "N", 16,  6, "Total pedido (Euros)",        "",            "lEnd" },;
                           { "nImpPesetas( nTotPed, (cDbf)->CDIVPED, cDbfDiv )",          "N", 16,  6, "Total pedido (Pesetas)",      "",            "lEnd" },;
                           { "nPagina",                                                   "N",  2,  0, "Número de página",            "'99'",        "" },;
                           { "lEnd",                                                      "L",  1,  0, "Fin del documento",           "",            "" } }

return ( aCalPedPrv )

//---------------------------------------------------------------------------//

function aColPedPrv()

   local aColPedPrv  := {}

   aAdd( aColPedPrv,  { "CSERPED", "C",  1,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NNUMPED", "N",  9,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CSUFPED", "C",  2,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CREF",    "C", 18,   0, "Referencia del artículo",          "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CREFPRV", "C", 18,   0, "Referencia del proveedor",         "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CDETALLE","C",250,   0, "Nombre del artículo",              "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NIVA",    "N",  6,   2, "Porcentaje de " + cImp(),                "'@E 99.9'",         "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NCANPED", "N", 16,   6, "Cantidad pedida",                  "MasUnd()",          "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NUNICAJA","N", 16,   6, "Unidades por caja",                "MasUnd()",          "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NPREDIV", "N", 16,   6, "Precio",                           "cPirDivPed",        "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NCANENT", "N", 16,   6, "Cajas recibidas",                  "MasUnd()",          "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NUNIENT", "N", 16,   6, "Unidades recibidas",               "MasUnd()",          "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CUNIDAD", "C",  2,   0, cNombreUnidades(),                  "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "MLNGDES", "M", 10,   0, "Descripción larga",                "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NDTOLIN", "N",  6,   2, "Descuento en lineas",              "'@E 999.99'",       "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NDTOPRM", "N",  6,   2, "Descuento pormociones",            "'@E 999.99'",       "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NDTORAP", "N",  6,   2, "Descuento por rappels",            "'@E 999.99'",       "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CCODPR1", "C", 20,   0, "Código de la primera propiedad",   "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CCODPR2", "C", 20,   0, "Código de la segunda propiedad",   "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CVALPR1", "C", 20,   0, "Valor de la primera propiedad",    "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CVALPR2", "C", 20,   0, "Valor de la segunda propiedad",    "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NFACCNV", "N", 13,   4, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NCTLSTK", "N",  1,   0, "Control de stock (1,2,3)",         "'9'",               "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CALMLIN" ,"C",  3,   0, "Código de almacén" ,               "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "LLOTE",   "L",  1,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NLOTE",   "N",  9,   0, "",                                 "'999999999'",       "", "(cDbfCol)" } ) 
   aAdd( aColPedPrv,  { "CLOTE",   "C", 12,   0, "Número de lote",                   "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NNUMLIN", "N",  4,   0, "Número de la línea",               "'9999'",            "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NUNDKIT", "N", 16,   6, "Unidades del producto kit",        "MasUnd()",          "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "LKITART", "L",  1,   0, "Línea con escandallo",             "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "LKITCHL", "L",  1,   0, "Línea pertenciente a escandallo",  "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "LKITPRC", "L",  1,   0, "",                                 "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "LIMPLIN", "L",  1,   0, "Imprimir linea",                   "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "LCONTROL","L",  1,   0, "" ,                                "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "MNUMSER", "M", 10,   0, "" ,                                "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "LANULADO","L",  1,   0, "Anular linea",                     "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "DANULADO","D",  8,   0, "Fecha de anulacion",               "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "MANULADO","M",100,   0, "Motivo anulacion",                 "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CCODFAM", "C", 16,   0, "Código de familia",                "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CGRPFAM", "C",  3,   0, "Código del grupo de familia",      "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "NREQ",    "N", 16,   6, "Recargo de equivalencia",          "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "MOBSLIN", "M", 10,   6, "Observaciones de la linea",        "",                  "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "CPEDCLI", "C", 12,   0, "Número del pedido del cliente del que viene",  "",      "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "nPvpRec", "N", 16,   6, "Precio de venta recomendado",      "cPirDivPed",        "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "nNumMed", "N",  1,   0, "Número de mediciones",             "MasUnd()",          "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "nMedUno", "N", 16,   6, "Primera unidad de medición",       "MasUnd()",          "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "nMedDos", "N", 16,   6, "Segunda unidad de medición",       "MasUnd()",          "", "(cDbfCol)" } )
   aAdd( aColPedPrv,  { "nMedTre", "N", 16,   6, "Tercera unidad de medición",       "MasUnd()",          "", "(cDbfCol)" } )

return ( aColPedPrv )

//---------------------------------------------------------------------------//

function aCocPedPrv()

   local aCocPedPrv  := {  { "Descrip( cDbfCol )",                                           "C", 50, 0, "Detalle del artículo",       "",            "Descripción", "" },;
                           { "nTotNPedPrv( cDbfCol )",                                       "N", 16, 6, "Total unidades",             "cPicUndPed",  cNombreUnidades(),    "" },;
                           { "nTotUPedPrv( cDbfCol, nDinDivPed, nVdvDivPed )",               "N", 16, 6, "Precio unitario de pedido",  "cPinDivPed",  "Precio",      "" },;
                           { "nTotLPedPrv( cDbfCol, nDinDivPed, nDirDivPed, nVdvDivPed )",   "N", 16, 6, "Total linea de pedido",      "cPirDivPed",  "Total",       "" } }

return ( aCocPedPrv )

//---------------------------------------------------------------------------//

Static Function nClrText( dbfTmpLin )

Return ( if ( ( dbfTmpLin )->lKitChl, CLR_GRAY, CLR_BLACK ) )

//----------------------------------------------------------------------------//

Function EdtNumSer( mNumSer, nTotUnd, nMode )

   local oDlg
   local oBrwSer
   local oProSer
   local nProSer
   local aNumSer
   local cPreFix  := Space( 18 )
   local oSerIni
   local nSerIni  := 0
   local oSerFin
   local nSerFin  := 0
   local oNumGen
   local nNumGen  := 0

   if nTotUnd == 0
      MsgStop( "No hay unidades para asignar números de serie." )
      Return ( mNumSer )
   end if

   DEFAULT nMode  := APPD_MODE

   nTotUnd        := abs( nTotUnd )
   aNumSer        := Afill( Array( nTotUnd ), Space( 30 ) )

   if nMode != APPD_MODE
      aMem2Ser( mNumSer, nTotUnd )
   end if

   DEFINE DIALOG oDlg RESOURCE "VtaNumSer"

      REDEFINE GET nTotUnd ;
			ID 		100 ;
         PICTURE  MasUnd() ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET cPreFix ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oSerIni VAR nSerIni ;
         ID       120 ;
         PICTURE  "99999999999999999999" ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oSerFin:cText( nSerIni + nTotUnd ), .t. ) ;
         OF       oDlg

      REDEFINE GET oSerFin VAR nSerFin ;
         ID       130 ;
         PICTURE  "99999999999999999999" ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET oNumGen VAR nNumGen ;
         ID       140 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "99999999999999999999" ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( GenNumSer( cPreFix, aNumSer, nSerIni, nNumGen, oBrwSer ) )

      oBrwSer                 := TXBrowse():New( oDlg )

      oBrwSer:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwSer:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwSer:lHScroll        := .f.
      oBrwSer:lRecordSelector := .t.
      oBrwSer:lFastEdit       := .t.

      oBrwSer:nMarqueeStyle   := MARQSTYLE_HIGHLCELL

      oBrwSer:SetArray( aNumSer, , , .f. )

      oBrwSer:nColSel         := 2

      with object ( oBrwSer:addCol() )
         :cHeader       := "N."
         :bStrData      := {|| Trans( oBrwSer:nArrayAt, "999999999" ) }
         :nWidth        := 60
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      with object ( oBrwSer:addCol() )
         :cHeader       := "Serie"
         :bEditValue    := {|| aNumSer[ oBrwSer:nArrayAt ] }
         :nWidth        := 240
         :nEditType     := 1
         :bOnPostEdit   := {|o,x| aNumSer[ oBrwSer:nArrayAt ] := x }
      end with

      oBrwSer:CreateFromResource( 150 )

      oProSer     := TMeter():ReDefine( 240, { | u | if( pCount() == 0, nProSer, nProSer := u ) }, 10, oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( mNumSer   := mSer2Mem( aNumSer, nTotUnd ), oDlg:End() )

      REDEFINE BUTTON ;
         ID       520 ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      oDlg:AddFastKey( VK_F5, {|| mNumSer := mSer2Mem( aNumSer, nTotUnd ), oDlg:End() } )

   ACTIVATE DIALOG oDlg CENTER

Return ( mNumSer )

//----------------------------------------------------------------------------//

Function GenNumSer( cPreFix, aNumSer, nSerIni, nNumGen, oBrwSer )

   local n
   local nChg  := 1

   CursorWait()

   if Empty( nNumGen )
      aEval( aNumSer, {| a, n | aNumSer[ n ] := Padr( Rtrim( cPreFix ) + Ltrim( Str( nSerIni + n - 1 ) ), 30 ) } )
   else
      for n := 1 to len( aNumSer )
         if Empty( aNumSer[ n ] )
            aNumSer[ n ]                     := Padr( Rtrim( cPreFix ) + Ltrim( Str( nSerIni + nChg - 1 ) ), 30 )
            nChg++
         end if
         if nChg == nNumGen
            exit
         end if
      next
   end if

   CursorWE()

   if !Empty( oBrwSer )
      oBrwSer:Refresh()
   end if

Return nil

//---------------------------------------------------------------------------//

Function aMem2Ser( mNumSer, nTotUnd )

   local n
   local nPosSer
   local aMemSer

   CursorWait()

   aMemSer           := Afill( Array( nTotUnd ), Space( 40 ) )

   for n := 1 to nTotUnd

      nPosSer        := At( ",", mNumSer )
      if nPosSer != 0
         aMemSer[ n ]:= Padr( SubStr( mNumSer, 1, nPosSer - 1 ), 40 )
         mNumSer     := SubStr( mNumSer, nPosSer + 1 )
      end if
   next

   CursorWE()

Return ( aMemSer )

//----------------------------------------------------------------------------//

Static Function mSer2Mem( aNumSer, nTotUnd )

   local n
   local mNumSer     := ""

   for n := 1 to nTotUnd
      mNumSer        += AllTrim( aNumSer[ n ] ) + ","
   next

Return ( mNumSer )

//---------------------------------------------------------------------------//

Function SynPedPrv( cPath )

   local oError
   local oBlock      
   local aTotPed

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., cDriver(), cPath + "PedPROVT.DBF", cCheckArea( "PedPROVT", @dbfPedPrvT ), .f. )
   if !lAIS(); ordListAdd( cPath + "PedPROVT.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "PedPROVL.DBF", cCheckArea( "PedPROVL", @dbfPedPrvL ), .f. )
   if !lAIS(); ordListAdd( cPath + "PedPROVL.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPath + "PedPRVI.DBF", cCheckArea( "PedPRVI", @dbfPedPrvI ), .f. )
   if !lAIS(); ordListAdd( cPath + "PedPRVI.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatArt() + "FAMILIAS.DBF", cCheckArea( "FAMILIAS", @dbfFamilia ), .f. )
   if !lAIS(); ordListAdd( cPatArt() + "FAMILIAS.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatArt() + "ARTICULO.DBF", cCheckArea( "ARTICULO", @dbfArticulo ), .f. )
   if !lAIS(); ordListAdd( cPatArt() + "ARTICULO.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatArt() + "PROVART.DBF", cCheckArea( "PROVART", @dbfArtPrv ), .f. )
   if !lAIS(); ordListAdd( cPatArt() + "PROVART.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatDat() + "TIVA.DBF", cCheckArea( "TIVA", @dbfIva ), .t. )
   if !lAIS(); ordListAdd( cPatDat() + "TIVA.CDX" ); else ; ordSetFocus( 1 ) ; end

   dbUseArea( .t., cDriver(), cPatDat() + "DIVISAS.DBF", cCheckArea( "DIVISAS", @dbfDiv ), .t. )
   if !lAIS(); ordListAdd( cPatDat() + "DIVISAS.CDX" ); else ; ordSetFocus( 1 ) ; end

   ( dbfPedPrvT )->( OrdSetFocus( 0 ) )
   ( dbfPedPrvT )->( dbGoTop() )

   while !( dbfPedPrvT )->( eof() )

      if Empty( ( dbfPedPrvT )->cSufPed )
         ( dbfPedPrvT )->cSufPed    := "00"
      end if

      if Empty( ( dbfPedPrvT )->cCodCaj )
         ( dbfPedPrvT )->cCodCaj    := "000"
      end if

      if !Empty( ( dbfPedPrvT )->cNumPedCli ) .and. Len( AllTrim( ( dbfPedPrvT )->cNumPedCli ) ) != 12
         ( dbfPedPrvT )->cNumPedCli := AllTrim( ( dbfPedPrvT )->cNumPedCli ) + "00"
      end if

      if !Empty( ( dbfPedPrvT )->cNumAlb ) .and. Len( AllTrim( ( dbfPedPrvT )->cNumAlb ) ) != 12
         ( dbfPedPrvT )->cNumAlb    := AllTrim( ( dbfPedPrvT )->cNumAlb ) + "00"
      end if

      /*
      Rellenamos los campos de totales-----------------------------------------
      */

      if ( dbfPedPrvT )->nTotPed == 0

         aTotPed                    := aTotPedPrv( ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed, dbfPedPrvT, dbfPedPrvL, dbfIva, dbfDiv, ( dbfPedPrvT )->cDivPed )

         ( dbfPedPrvT )->nTotNet    := aTotPed[1]
         ( dbfPedPrvT )->nTotIva    := aTotPed[2]
         ( dbfPedPrvT )->nTotReq    := aTotPed[3]
         ( dbfPedPrvT )->nTotPed    := aTotPed[4]

      end if

      ( dbfPedPrvT )->( dbSkip() )

   end while

   ( dbfPedPrvT )->( OrdSetFocus( 1 ) )

   // Lineas ------------------------------------------------------------------

   ( dbfPedPrvL )->( OrdSetFocus( 0 ) )
   ( dbfPedPrvL )->( dbGoTop() )

   while !( dbfPedPrvL )->( eof() )

      if Empty( ( dbfPedPrvL )->cSufPed )
         ( dbfPedPrvL )->cSufPed := "00"
      end if

      if !Empty( ( dbfPedPrvL )->cPedCli ) .and. Len( AllTrim( ( dbfPedPrvL )->cPedCli ) ) != 12
         ( dbfPedPrvL )->cPedCli := AllTrim( ( dbfPedPrvL )->cPedCli ) + "00"
      end if

      if Empty( ( dbfPedPrvL )->cLote ) .and. !Empty( ( dbfPedPrvL )->nLote )
         ( dbfPedPrvL )->cLote   := AllTrim( Str( ( dbfPedPrvL )->nLote ) )
      end if

      if !Empty( ( dbfPedPrvL )->cRef ) .and. Empty( ( dbfPedPrvL )->cCodFam )
         ( dbfPedPrvL )->cCodFam := RetFamArt( ( dbfPedPrvL )->cRef, dbfArticulo )
      end if

      if !Empty( ( dbfPedPrvL )->cRef ) .and. !Empty( ( dbfPedPrvL )->cGrpFam )
         ( dbfPedPrvL )->cGrpFam := cGruFam( ( dbfPedPrvL )->cCodFam, dbfFamilia )
      end if

      if Empty( ( dbfPedPrvL )->nReq )
         ( dbfPedPrvL )->nReq    := nPReq( dbfIva, ( dbfPedPrvL )->nIva )
      end if

      if Empty( ( dbfPedPrvL )->cAlmLin )
         ( dbfPedPrvL )->cAlmLin := RetFld( ( dbfPedPrvL )->cSerPed + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed, dbfPedPrvT, "cCodAlm" )
      end if

      ( dbfPedPrvL )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfPedPrvL )->( OrdSetFocus( 1 ) )

   // Incidencias -------------------------------------------------------------

   ( dbfPedPrvI )->( OrdSetFocus( 0 ) )
   ( dbfPedPrvI )->( dbGoTop() )

   while !( dbfPedPrvI )->( eof() )

      if Empty( ( dbfPedPrvI )->cSufPed )
         ( dbfPedPrvI )->cSufPed := "00"
      end if

      ( dbfPedPrvI )->( dbSkip() )

      SysRefresh()

   end while

   ( dbfPedPrvI )->( OrdSetFocus( 1 ) )

   RECOVER USING oError

      msgStop( "Imposible sincronizar pedidos de proveedores" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( dbfPedPrvT ) .and. ( dbfPedPrvT )->( Used() )
      ( dbfPedPrvT )->( dbCloseArea() )
   end if

   if !Empty( dbfPedPrvL ) .and. ( dbfPedPrvL )->( Used() )
      ( dbfPedPrvL )->( dbCloseArea() )
   end if

   if !Empty( dbfPedPrvI ) .and. ( dbfPedPrvI )->( Used() )
      ( dbfPedPrvI )->( dbCloseArea() )
   end if

   if !Empty( dbfArticulo ) .and. ( dbfArticulo )->( Used() )
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if !Empty( dbfFamilia ) .and. ( dbfFamilia )->( Used() )
      ( dbfFamilia )->( dbCloseArea() )
   end if

   if !Empty( dbfArtPrv ) .and. ( dbfArtPrv )->( Used() )
      ( dbfArtPrv )->( dbCloseArea() )
   end if

   if !Empty( dbfIva ) .and. ( dbfIva )->( Used() )
      ( dbfIva )->( dbCloseArea() )
   end if

   if !Empty( dbfDiv ) .and. ( dbfDiv )->( Used() )
      ( dbfDiv )->( dbCloseArea() )
   end if

return nil

//------------------------------------------------------------------------//

CLASS TPedidosProveedorSenderReciver FROM TSenderReciverItem

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData()

   local oBlock
   local oError
   local lSnd        := .f.
   local dbfPedPrvT
   local dbfPedPrvL
   local tmpPedPrvT
   local tmpPedPrvL
   local cFileName   := "PedPrv" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

   ::oSender:SetText( "Enviando pedidos a proveedores" )

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDPROVT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @dbfPedPrvL ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   CreateFiles( cPatSnd() )

   rxPedPrv( cPatSnd() )

   USE ( cPatSnd() + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @tmpPedPrvT ) )
   SET ADSINDEX TO ( cPatSnd() + "PEDPROVT.CDX" ) ADDITIVE

   USE ( cPatSnd() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @tmpPedPrvL ) )
   SET ADSINDEX TO ( cPatSnd() + "PEDPROVL.CDX" ) ADDITIVE

   if !Empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfPedPrvT )->( lastrec() )
   end if

   while !( dbfPedPrvT )->( eof() )

      if ( dbfPedPrvT )->lSndDoc

         lSnd  := .t.

         dbPass( dbfPedPrvT, tmpPedPrvT, .t. )

         ::oSender:SetText( ( dbfPedPrvT )->cSerPed + "/" + AllTrim( Str( ( dbfPedPrvT )->nNumPed ) ) + "/" + Alltrim( ( dbfPedPrvT )->cSufPed ) + "; " + Dtoc( ( dbfPedPrvT )->dFecPed ) + "; " + AllTrim( ( dbfPedPrvT )->cCodPrv ) + "; " + ( dbfPedPrvT )->cNomPrv )

         if ( dbfPedPrvL )->( dbSeek( ( dbfPedPrvT )->CSERPED + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed ) )

            while ( ( dbfPedPrvL )->CSERPED + Str( ( dbfPedPrvL )->nNumPed ) + ( dbfPedPrvL )->cSufPed ) == ( ( dbfPedPrvT )->CSERPED + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed ) .AND. !( dbfPedPrvL )->( eof() )

               dbPass( dbfPedPrvL, tmpPedPrvL, .t. )
               ( dbfPedPrvL )->( dbSkip() )

            end do

         end if

      end if

      ( dbfPedPrvT )->( dbSkip() )

      if !Empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( dbfPedPrvT )->( OrdKeyNo() ) )
      end if

   END DO

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfPedPrvT )
   CLOSE ( dbfPedPrvL )
   CLOSE ( tmpPedPrvT )
   CLOSE ( tmpPedPrvL )

   /*
   Comprimir los archivos------------------------------------------------------
   */

   if lSnd

      ::oSender:SetText( "Comprimiendo pedidos de proveedores" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay pedidos de proveedores para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData()

   local oBlock
   local oError
   local dbfPedPrvT

   if ::lSuccesfullSend

      /*
      Retorna el valor anterior
      */

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cPatEmp() + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "PEDPROVT.CDX" ) ADDITIVE

         lSelectAll( nil, dbfPedPrvT, "lSndDoc", .f., .t., .f. )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

      CLOSE ( dbfPedPrvT )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData()

   local cFileName         := "PedPrv" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()

   if File( cPatOut() + cFileName )

      if ftpSndFile( cPatOut() + cFileName, cFileName, 2000, ::oSender )
         ::lSuccesfullSend := .t.
         ::IncNumberToSend()
         ::oSender:SetText( "Fichero enviado " + cFileName )
      else
         ::oSender:SetText( "ERROR al enviar fichero" )
      end if

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method ReciveData()

   local n
   local aExt        := aRetDlgEmp()

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo pedidos de proveedores" )

   for n := 1 to len( aExt )
      ftpGetFiles( "PedPrv*." + aExt[ n ], cPatIn(), 2000, ::oSender )
   next

   ::oSender:SetText( "Pedidos de proveedores recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process()

   local m
   local oBlock
   local oError
   local dbfPedPrvT
   local dbfPedPrvL
   local tmpPedPrvT
   local tmpPedPrvL
   local aFiles      := Directory( cPatIn() + "PedPrv*.*" )

   /*
   Procesamos los ficheros recibidos
   */

   for m := 1 to len( aFiles )

      ::oSender:SetText( "Procesando fichero : " + aFiles[ m, 1 ] )

      oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

      BEGIN SEQUENCE

      /*
      descomprimimos el fichero
      */

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         dbUseArea(.t., cDriver(), cPatSnd() + "PEDPROVT.DBF", cCheckArea( "PEDPROVT", @tmpPedPrvT ), .f., .t. )
         if !( dbfPedPrvT )->( neterr() )
               ( tmpPedPrvT )->( ordListAdd( cPatSnd() + "PEDPROVT.CDX" ) )
         end if

         dbUseArea(.t., cDriver(), cPatSnd() + "PEDPROVL.DBF", cCheckArea( "PEDPROVL", @tmpPedPrvL ), .f., .t. )
         if !( dbfPedPrvL )->( neterr() )
               ( tmpPedPrvL )->( ordListAdd( cPatSnd() + "PEDPROVL.CDX" ) )
         end if

         USE ( cPatEmp() + "PEDPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVT", @dbfPedPrvT ) )
         SET ADSINDEX TO ( cPatEmp() + "PEDPROVT.CDX" ) ADDITIVE

         USE ( cPatEmp() + "PEDPROVL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PEDPROVL", @dbfPedPrvL ) )
         SET ADSINDEX TO ( cPatEmp() + "PEDPROVL.CDX" ) ADDITIVE

         WHILE ( tmpPedPrvT )->( !eof() )

            /*
            Comprobamos que no exista el pedido en la base de datos
            */

            if lValidaOperacion( ( tmpPedPrvT )->dFecPed, .f. ) .and. ;
               !( dbfPedPrvT )->( dbSeek( ( tmpPedPrvT )->cSerPed + Str( ( tmpPedPrvT )->nNumPed ) + ( tmpPedPrvT )->cSufPed ) )

               dbPass( tmpPedPrvT, dbfPedPrvT, .t. )
               ::oSender:SetText( "Añadido     : " + ( tmpPedPrvT )->cSerPed + "/" + AllTrim( Str( ( tmpPedPrvT )->nNumPed ) ) + "/" + AllTrim( ( tmpPedPrvT )->cSufPed ) + "; " + Dtoc( ( tmpPedPrvT )->dFecPed ) + "; " + AllTrim( ( tmpPedPrvT )->cCodPrv ) + "; " + ( tmpPedPrvT )->cNomPrv )

               if ( tmpPedPrvL )->( dbSeek( ( tmpPedPrvT )->CSERPED + Str( ( tmpPedPrvT )->nNumPed ) + ( tmpPedPrvT )->cSufPed ) )

                  while ( ( tmpPedPrvL )->CSERPED + Str( ( tmpPedPrvL )->nNumPed ) + ( tmpPedPrvL )->cSufPed ) == ( ( tmpPedPrvT )->CSERPED + Str( ( tmpPedPrvT )->nNumPed ) + ( tmpPedPrvT )->cSufPed ) .AND. !( tmpPedPrvL )->( eof() )

                     dbPass( tmpPedPrvL, dbfPedPrvL, .t. )
                     ( tmpPedPrvL )->( dbSkip() )

                  end do

               end if

            else

               ::oSender:SetText( "Desestimado : " + ( tmpPedPrvT )->cSerPed + "/" + AllTrim( Str( ( tmpPedPrvT )->nNumPed ) ) + "/" + AllTrim( ( tmpPedPrvT )->cSufPed ) + "; " + Dtoc( ( tmpPedPrvT )->dFecPed ) + "; " + AllTrim( ( tmpPedPrvT )->cCodPrv ) + "; " + ( tmpPedPrvT )->cNomPrv )

            end if

            ( tmpPedPrvT )->( dbSkip() )

         END DO

         CLOSE ( dbfPedPrvT )
         CLOSE ( dbfPedPrvL )
         CLOSE ( tmpPedPrvT )
         CLOSE ( tmpPedPrvL )

         ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

      end if

      RECOVER USING oError

         CLOSE ( dbfPedPrvT )
         CLOSE ( dbfPedPrvL )
         CLOSE ( tmpPedPrvT )
         CLOSE ( tmpPedPrvL )

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return Self

//----------------------------------------------------------------------------//

static function CambiaAnulado( aGet, aTmp )

   if aTmp[_LANULADO]

      aGet[_DANULADO]:cText( GetSysDate() )
      aTmp[_MANULADO]   := ""

   else

      aGet[_DANULADO]:cText( Ctod( "" ) )
      aTmp[_MANULADO]   := ""

   end if

return .t.

//---------------------------------------------------------------------------//

/*
Selecciona todos los registros
*/

FUNCTION lSelAll( oBrw, dbf, lSel, lTop, lMeter )

   local nRecAct  := ( dbf )->( recno() )

   DEFAULT lSel   := .t.
   DEFAULT lTop   := .t.
   DEFAULT lMeter := .f.

   if lMeter
      CreateWaitMeter( nil, nil, ( dbf )->( OrdKeyCount() ) )
   else
      CursorWait()
   end if

   if lTop
      ( dbf )->( dbGoTop() )
   end if

   while !( dbf )->( eof() )

      if dbLock( dbf )
         ( dbf )->lSndDoc := lSel
         ( dbf )->( dbUnlock() )
      end if

      ( dbf )->( dbSkip() )

      if lMeter
         RefreshWaitMeter( ( dbf )->( OrdKeyNo() ) )
      else
         SysRefresh()
      end if

   end do

   ( dbf )->( dbGoTo( nRecAct ) )

   if lMeter
      EndWaitMeter()
   else
      CursorWE()
   end if

   if !Empty( oBrw )
      oBrw:Refresh()
      oBrw:SetFocus()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Static Function TrazaPedidoProveedor( cNumDoc )

   local oDlg
   local oTree

   DEFINE DIALOG oDlg RESOURCE "TrazaDocumentos"

      oTree          := TTreeView():Redefine( 100, oDlg  )

      REDEFINE BUTTON ;
         ID       560 ;
			OF 		oDlg ;
         ACTION   ( oDlg:end() )

		REDEFINE BUTTON ;
         ID       561 ;
			OF 		oDlg ;
			ACTION	( oDlg:end() )

   ACTIVATE DIALOG oDlg ;
         ON INIT  ( InitTrazaPedidoProveedor( cNumDoc, oTree ) );
         CENTER

Return nil

Static Function InitTrazaPedidoProveedor( cNumDoc, oTree )

   local n
   local aDocumentsPedidoProveedor  := aDocumentsPedidoProveedor( cNumDoc )

   for n := 1 to len( aDocumentsPedidoProveedor )
      oTree:Add(  aDocumentsPedidoProveedor[ n, 1 ] + " / " + ;
                  aDocumentsPedidoProveedor[ n, 2 ] + " / " + ;
                  aDocumentsPedidoProveedor[ n, 3 ] + " / " + ;
                  aDocumentsPedidoProveedor[ n, 4 ] + " / " + ;
                  aDocumentsPedidoProveedor[ n, 5 ] )
   next

Return ( aDocumentsPedidoProveedor )

FUNCTION aDocumentsPedidoProveedor( cNumPed )

   local oBlock
   local oError
   local dbfAlbPrvT
   local aDocuments  := {}

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "ALBPROVT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBPROVT", @dbfAlbPrvT ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBPROVT.CDX" ) ADDITIVE
   ( dbfAlbPrvT )->( OrdSetFocus( "cNumPed" ) )

   if ( dbfAlbPrvT )->( dbSeek( cNumPed ) )
      while ( dbfAlbPrvT )->cNumPed == cNumPed .and. !( dbfAlbPrvT )->( eof() )
         aAdd( aDocuments, {  ( dbfAlbPrvT )->cSerAlb + Str( ( dbfAlbPrvT )->nNumAlb ) + ( dbfAlbPrvT )->cSufAlb,;
                              Dtoc( ( dbfAlbPrvT )->dFecAlb ),;
                              ( dbfAlbPrvT )->cCodPrv,;
                              Rtrim( ( dbfAlbPrvT )->cNomPrv ),;
                              ( dbfAlbPrvT )->cCodAlm } )
         ( dbfAlbPrvT )->( dbSkip() )
      end while
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE( dbfAlbPrvT )

Return ( aDocuments )

//---------------------------------------------------------------------------//

Function GetCodCli( cNumPed )

   local oBlock
   local oError
   local dbfPedCliT
   local cCodCli  := ""

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @dbfPedCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIT.CDX" ) ADDITIVE

   ( dbfPedCliT )->( OrdSetFocus( "NNUMPED" ) )

   if ( dbfPedCliT )->( dbSeek( cNumPed ) )
      cCodCli     := ( dbfPedCliT )->cCodCli
   end if 

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE( dbfPedCliT )

Return cCodCli

//---------------------------------------------------------------------------//

Function GetNomCli( cNumPed )

   local oBlock
   local oError
   local dbfPedCliT
   local cNomCli  := ""

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @dbfPedCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "PEDCLIT.CDX" ) ADDITIVE

   ( dbfPedCliT )->( OrdSetFocus( "NNUMPED" ) )

   if ( dbfPedCliT )->( dbSeek( cNumPed ) )
      cNomCli     := ( dbfPedCliT )->cNomCli
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE( dbfPedCliT )

Return cNomCli

//---------------------------------------------------------------------------//

Static Function nEstadoIncidencia( cNumPed )

   local nEstado  := 0

   if ( dbfPedPrvI )->( dbSeek( cNumPed ) )

      while ( dbfPedPrvI )->cSerPed + Str( ( dbfPedPrvI )->nNumPed ) + ( dbfPedPrvI )->cSufPed == cNumPed .and. !( dbfPedPrvI )->( Eof() )

         if ( dbfPedPrvI )->lListo
            do case
               case nEstado == 0 .or. nEstado == 3
                    nEstado := 3
               case nEstado == 1
                    nEstado := 2
            end case
         else
            do case
               case nEstado == 0
                    nEstado := 1
               case nEstado == 3
                    nEstado := 2
            end case
         end if

         ( dbfPedPrvI )->( dbSkip() )

      end while

   end if

Return ( nEstado )

//---------------------------------------------------------------------------//

function lChgImpDoc( dbfT )

   if dbLock( dbfT )
      ( dbfT )->lImprimido := .t.
      ( dbfT )->dFecImp    := GetSysDate()
      ( dbfT )->cHorImp    := SubStr( Time(), 1, 5 )
      ( dbfT )->( dbUnLock() )
   end if

Return .t.

//---------------------------------------------------------------------------//
/*
Función que monta los diálogos para la generación de pedidos a proveedor
*/

Function Generador( oBrwPed )

   local oDlg
   local oPag
   local oBmp
   local oMtr
   local nMtr
   local oBrw
   local oCol
   local oBtnAnt
   local oBtnNxt
   local oProvee
   local cProvee
   local oSayPrv
   local cSayPrv
   local oArtOrg
   local oArtDes
   local oSayArtOrg
   local oSayArtDes
   local cArtOrg        := dbFirst ( dbfArticulo, 1 )
   local cArtDes        := dbLast  ( dbfArticulo, 1 )
   local cSayArtOrg     := dbFirst ( dbfArticulo, 2 )
   local cSayArtDes     := dbLast  ( dbfArticulo, 2 )
   local oCodAlm
   local oNomAlm
   local cCodAlm        := cDefAlm()
   local cNomAlm        := retAlmacen( cCodAlm, dbfAlm )
   local nStockDis      := 4
   local nStockFin      := 1

   CreaTemporal()

   DEFINE DIALOG oDlg RESOURCE "ASS_PEDCLI" TITLE "Generar pedido a proveedor"

   REDEFINE BITMAP oBmp ;
      RESOURCE "GENERARPEDPRV" ;
      ID       500 ;
      OF       oDlg

   REDEFINE PAGES oPag ID 110 OF oDlg ;
      DIALOGS "ASS_PEDPRV1", "ASS_PEDCLI2"

   REDEFINE GET oProvee VAR cProvee;
      ID       110;
      VALID    cProvee( oProvee, dbfPrv, oSayPrv ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwProvee( oProvee, oSayPrv ) ;
		COLOR 	CLR_GET ;
      OF       oPag:aDialogs[1]

   REDEFINE GET oSayPrv VAR cSayPrv ;
      ID       120;
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       oPag:aDialogs[1]

   REDEFINE GET oArtOrg VAR cArtOrg;
      ID       150 ;
      VALID    cArticulo( oArtOrg, dbfArticulo, oSayArtOrg );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArtOrg, oSayArtOrg );
      OF       oPag:aDialogs[1]

   REDEFINE GET oSayArtOrg VAR cSayArtOrg ;
		WHEN 		.F.;
      ID       160 ;
      OF       oPag:aDialogs[1]

   REDEFINE GET oArtDes VAR cArtDes;
      ID       170 ;
      VALID    cArticulo( oArtDes, dbfArticulo, oSayArtDes );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArtDes, oSayArtDes );
      OF       oPag:aDialogs[1]

   REDEFINE GET oSayArtDes VAR cSayArtDes ;
		WHEN 		.F.;
      ID       180 ;
      OF       oPag:aDialogs[1]

   REDEFINE GET oCodAlm VAR cCodAlm ;
      ID       190 ;
      VALID    ( cAlmacen( oCodAlm, dbfAlm, oNomAlm ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwAlmacen( oCodAlm, oNomAlm ) ) ;
      COLOR    CLR_GET ;
      OF       oPag:aDialogs[1]

   REDEFINE GET oNomAlm VAR cNomAlm ;
      WHEN     .F. ;
      ID       200 ;
      OF       oPag:aDialogs[1]

   REDEFINE RADIO nStockDis ;
      ID       201, 202, 203, 204 ;
      OF       oPag:aDialogs[1]

   REDEFINE RADIO nStockFin ;
      ID       212, 213 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE METER oMtr ;
      VAR      nMtr ;
		PROMPT	"Procesando" ;
      ID       220 ;
      TOTAL    ( ( dbfArticulo )->( LastRec() ) ) ;
      OF       oPag:aDialogs[ 1 ]

   oBrw                 := IXBrowse():New( oPag:aDialogs[ 2 ] )

   oBrw:lHScroll        := .f.

   oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrw:cAlias          := dbfTmpArt
   oBrw:nMarqueeStyle   := 5
   oBrw:cName           := "Pedido a proveedores.Asistente"
   oBrw:lFastEdit       := .t.
   oBrw:nMarqueeStyle   := MARQSTYLE_HIGHLCELL

      with object ( oBrw:AddCol() )
         :cHeader       := "Se. Seleccionado"
         :bStrData      := {|| "" }
         :bEditValue    := {|| ( dbfTmpArt )->lSelArt }
         :nEditType     := 0
         :nWidth        := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader       := "Código"
         :bEditValue    := {|| ( dbfTmpArt )->cRef }
         :nEditType     := 0
         :nWidth        := 60
      end with

      with object ( oBrw:AddCol() )
         :cHeader       := "Detalle"
         :bEditValue    := {|| ( dbfTmpArt )->cDetalle }
         :nEditType     := 0
         :nWidth        := 200
      end with

      with object ( oBrw:AddCol() )
         :cHeader       := "Objetivo"
         :bEditValue    := {|| ( dbfTmpArt )->nObjUni }
         :cEditPicture  := MasUnd()
         :nEditType     := 0
         :nWidth        := 65
         :nDataStrAlign := AL_RIGHT
         :nHeadStrAlign := AL_RIGHT
      end with

      with object ( oCol := oBrw:AddCol() )
         :cHeader       := "A pedir"
         :bEditValue    := {|| ( dbfTmpArt )->nNumUni }
         :cEditPicture  := MasUnd()
         :nEditType     := 1
         :nWidth        := 65
         :bOnPostEdit   := {|o,x| if( x > 0, ( dbfTmpArt )->nNumUni := x, ), .t. }
         :nDataStrAlign := AL_RIGHT
         :nHeadStrAlign := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader       := "Stock actual"
         :bEditValue    := {|| ( dbfTmpArt )->nStkFis }
         :cEditPicture  := MasUnd()
         :nEditType     := 0
         :nWidth        := 65
         :nDataStrAlign := AL_RIGHT
         :nHeadStrAlign := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader       := "Stock disponible"
         :bEditValue    := {|| ( dbfTmpArt )->nStkDis }
         :cEditPicture  := MasUnd()
         :nEditType     := 0
         :nWidth        := 65
         :nDataStrAlign := AL_RIGHT
         :nHeadStrAlign := AL_RIGHT
      end with

   oBrw:CreateFromResource( 100 )

   oBrw:bLDblClick      := {|| oCol:Edit() }

   REDEFINE BUTTON ;
      ID       110;
      OF       oPag:aDialogs[2] ;
      ACTION   ( oCol:Edit() )

   REDEFINE BUTTON ;
      ID       120;
      OF       oPag:aDialogs[2] ;
      ACTION   ( SelArt( dbfTmpArt, oBrw ) )

   REDEFINE BUTTON ;
      ID       130;
      OF       oPag:aDialogs[2] ;
      ACTION   ( SelAllArt( dbfTmpArt, oBrw, .t. ) )

   REDEFINE BUTTON ;
      ID       140;
      OF       oPag:aDialogs[2] ;
      ACTION   ( SelAllArt( dbfTmpArt, oBrw, .f. ) )

   REDEFINE BUTTON oBtnAnt ;
      ID       401 ;
      OF       oDlg;
      ACTION   ( BtnAnt( oPag, oBtnNxt, oBtnAnt ) )

   REDEFINE BUTTON oBtnNxt ;
      ID       402 ;
      OF       oDlg;
      ACTION   ( BtnNxt( oPag, oBtnNxt, oBtnAnt, oDlg, oProvee, cProvee, cArtOrg, cArtDes, nStockDis, nStockFin, oMtr, oBrw, cCodAlm ) )

   REDEFINE BUTTON ;
      ID       403 ;
      OF       oDlg ;
      ACTION   ( KillTemporal(), oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON INIT( oBtnAnt:Hide(), oBrw:Load() )

   oBmp:End()

   oBrwPed:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//
/*
Botón anterior
*/

Static Function BtnAnt( oPag, oBtnNxt, oBtnAnt )

   if oPag:nOption == 2

      /*
      Vacia la temporal para añadirle nuevos registros-------------------------
      */

      ( dbfTmpArt )->( __dbZap() )
      oPag:GoPrev()
      SetWindowText( oBtnNxt:hWnd, "Siguien&te >" )

      oBtnAnt:Hide()

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
/*
Botón siguiente
*/

static function BtnNxt( oPag, oBtnNxt, oBtnAnt, oDlg, oProvee, cProvee, cArtOrg, cArtDes, nStockDis, nStockFin, oMtr, oBrw, cCodAlm )

   do case
      case oPag:nOption == 1

         /*
         Comprueba que eliga un proveedor
         */

         if Empty( cProvee )
            MsgStop( "Tiene que seleccionar un proveedor para generar el pedido" )
            oProvee:SetFocus()
            Return .f.
         end if

         /*
         Llena la temporal con los artículos que cumplen las condiciones deseadas
         */

         LlenaTemporal( cProvee, cArtOrg, cArtDes, nStockDis, nStockFin, oMtr )

         oBrw:Refresh()

         oPag:GoNext()

         oBtnAnt:Show()

         SetWindowText( oBtnNxt:hWnd, "&Terminar" )

      case oPag:nOption == 2

         /*
         Crea el pedido a proveedor
         */

         CreaPedido( cProvee, cCodAlm )

         /*
         Elimina las temporales
         */

         KillTemporal()

         oDlg:end( IDOK )

   end case

RETURN ( .t. )

//---------------------------------------------------------------------------//
/*
Crea las bases de datos temporales que usaremos
*/

Static Function CreaTemporal()

   local cDbfArt  := "PArt"
   local cDbfPed := "PPed"

   cTmpArt        := cGetNewFileName( cPatTmp() + cDbfArt )
   cTmpPed        := cGetNewFileName( cPatTmp() + cDbfPed )

   dbCreate( cTmpArt, aSqlStruct( aColTmpArt() ), cDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpArt, cCheckArea( cDbfArt, @dbfTmpArt ), .f. )
   if !( dbfTmpArt )->( neterr() )
      ( dbfTmpArt )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTmpArt )->( ordCreate( cTmpArt, "cRef", "cRef", {|| Field->CREF } ) )
   end if

   dbCreate( cTmpPed, aSqlStruct( aColPedPrv() ), cDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpPed, cCheckArea( cDbfPed, @dbfTmpLin ), .f. )
   if !( dbfTmpLin )->( neterr() )
      ( dbfTmpLin )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTmpLin )->( ordCreate( cTmpPed, "cRef", "cRef", {|| Field->CREF } ) )
   end if

Return nil

//---------------------------------------------------------------------------//
/*
Llena la temporal con los artículos que cumplen las condiciones deseadas
*/

Static Function LlenaTemporal( cProvee, cArtOrg, cArtDes, nStockDis, nStockFin, oMtr )

   local nStkFisico
   local nStkDisponible

   ( dbfArticulo )->( dbGoTop() )

   while !( dbfArticulo )->( Eof() )

         nStkFisico                    := oStock:nTotStockAct( ( dbfArticulo )->Codigo, , , , , ( dbfArticulo )->lKitArt, ( dbfArticulo )->nKitStk )
         nStkDisponible                := oStock:nTotStockAct( ( dbfArticulo )->Codigo, , , , , ( dbfArticulo )->lKitArt, ( dbfArticulo )->nKitStk ) - nReservado( ( dbfArticulo )->Codigo )

      if ( dbfArticulo )->cPrvHab == cProvee .and.;
         ( dbfArticulo )->Codigo >= cArtOrg  .and.;
         ( dbfArticulo )->Codigo <= cArtDes

         do case
            case nStockDis == 1 .and. nStkDisponible < 0
               AppTemporal( nStockFin, nStkFisico, nStkDisponible )
            case nStockDis == 2 .and. nStkDisponible <= 0
               AppTemporal( nStockFin, nStkFisico, nStkDisponible )
            case nStockDis == 3 .and. nStkDisponible < ( dbfArticulo )->nMinimo
               AppTemporal( nStockFin, nStkFisico, nStkDisponible )
            otherwise
               AppTemporal( nStockFin, nStkFisico, nStkDisponible )
         end case

      end if

      ( dbfArticulo )->( dbSkip() )

      oMtr:Set( ( dbfArticulo )->( OrdKeyNo() ) )

   end while

   oMtr:Set( 0 )

   ( dbfTmpArt )->( dbGoTop() )

Return nil

//---------------------------------------------------------------------------//
/*
Hace el append a la temporal
*/

static function AppTemporal( nStockFin, nStkFisico, nStkDisponible )

   ( dbfTmpArt )->( dbAppend() )

   ( dbfTmpArt )->cRef        := ( dbfArticulo )->Codigo
   ( dbfTmpArt )->cDetalle    := ( dbfArticulo )->Nombre
   ( dbfTmpArt )->nStkFis     := nStkFisico
   ( dbfTmpArt )->nStkDis     := nStkDisponible

   do case
      case nStockFin == 1
         if ( dbfArticulo )->nMinimo   != 0
            ( dbfTmpArt )->nObjUni     := ( dbfArticulo )->nMinimo
            ( dbfTmpArt )->nNumUni     := nCalculaUnidades( ( dbfArticulo )->nMinimo )
            if nCalculaUnidades( ( dbfArticulo )->nMinimo ) == 0
               ( dbfTmpArt )->lSelArt  := .f.
            else
               ( dbfTmpArt )->lSelArt  := .t.
            end if
         else
            ( dbfTmpArt )->nObjUni     := 1
            ( dbfTmpArt )->nNumUni     := nCalculaUnidades( 1 )
            if nCalculaUnidades( 1 ) == 0
               ( dbfTmpArt )->lSelArt  := .f.
            else
               ( dbfTmpArt )->lSelArt  := .t.
            end if
         end if
      case nStockFin == 2
         if ( dbfArticulo )->nMaximo   != 0
            ( dbfTmpArt )->nObjUni     := ( dbfArticulo )->nMaximo
            ( dbfTmpArt )->nNumUni     := nCalculaUnidades( ( dbfArticulo )->nMaximo )
            if nCalculaUnidades( ( dbfArticulo )->nMaximo ) == 0
               ( dbfTmpArt )->lSelArt  := .f.
            else
               ( dbfTmpArt )->lSelArt  := .t.
            end if
         else
            ( dbfTmpArt )->nObjUni     := 1
            ( dbfTmpArt )->nNumUni     := nCalculaUnidades( 1 )
            if nCalculaUnidades( 1 ) == 0
               ( dbfTmpArt )->lSelArt  := .f.
            else
               ( dbfTmpArt )->lSelArt  := .t.
            end if
         end if
   end case

return ( nil )

//---------------------------------------------------------------------------//
/*
Destruye las bases de datos temporales
*/

Static Function KillTemporal()

   if !Empty( dbfTmpArt ) .and. ( dbfTmpArt )->( Used() )
      ( dbfTmpArt )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpLin ) .and. ( dbfTmpLin )->( Used() )
      ( dbfTmpLin )->( dbCloseArea() )
   end if

   dbfErase( cTmpArt )
   dbfErase( cTmpPed )

Return nil

//---------------------------------------------------------------------------//
/*Campos que tiene que tener la temporal de artículos*/

Static Function aColTmpArt()

   local aColTmpArt  := {}

      aAdd( aColTmpArt, { "CREF",    "C",   18,  0, "Referencia del artículo",         "",  "", "( cDbfCol )" } )
      aAdd( aColTmpArt, { "CDETALLE","C",  250,  0, "Nombre del artículo",             "",  "", "( cDbfCol )" } )
      aAdd( aColTmpArt, { "LSELART", "L",    1,  0, "Lógico de selección de artículo", "",  "", "( cDbfCol )" } )
      aAdd( aColTmpArt, { "NNUMUNI", "N",   16,  6, "Unidades pedidas",                "",  "", "( cDbfCol )" } )
      aAdd( aColTmpArt, { "NOBJUNI", "N",   16,  6, "Objetivo a llegar",               "",  "", "( cDbfCol )" } )
      aAdd( aColTmpArt, { "NSTKFIS", "N",   16,  6, "Stock fisico",                    "",  "", "( cDbfCol )" } )
      aAdd( aColTmpArt, { "NSTKDIS", "N",   16,  6, "Stock disponible",                "",  "", "( cDbfCol )" } )

return ( aColTmpArt )

//---------------------------------------------------------------------------//
/*
Selecciona o deselecciona el artículo que tengamos marcado en el browse
*/

Static Function SelArt( dbfTmpArt, oBrw )

   ( dbfTmpArt )->lSelArt := !( dbfTmpArt )->lSelArt

   oBrw:Refresh()

return nil

//---------------------------------------------------------------------------//
/*Selecciona o deselecciona todos los artículos de browse*/

static function SelAllArt( dbfTmpArt, oBrw, lSel )

   local nRec  := ( dbfTmpArt )->( Recno() )

   ( dbfTmpArt )->( dbGoTop() )
   while !( dbfTmpArt )->( eof() )

      ( dbfTmpArt )->lSelArt := lSel

      ( dbfTmpArt )->( dbSkip() )

   end while

   ( dbfTmpArt )->( dbGoTo( nRec ) )

   oBrw:Refresh()

return nil

//---------------------------------------------------------------------------//
/*Devuelve el total de unidades reservadas del artículo*/

Static Function nReservado( cCodArt )

   local nTotal := 0

   ( dbfPedCliR )->( dbGoTop() )

   ( dbfPedCliR )->( OrdSetFocus( "cRef" ) )

   if ( dbfPedCliR )->( dbSeek( cCodArt ) )

      while ( dbfPedCliR )->cRef == cCodArt .and. !( dbfPedCliR )->( Eof() )

         nTotal += nTotRPedCli( ( dbfPedCliR )->cSerPed + Str( ( dbfPedCliR )->nNumPed ) + ( dbfPedCliR )->cSufPed, ( dbfPedCliR )->cRef, ( dbfPedCliR )->cValPr1, ( dbfPedCliR )->cValPr2, dbfPedCliR )

      ( dbfPedCliR )->( dbSkip() )

      end while

   end if

return ( nTotal )

//---------------------------------------------------------------------------//
/*Creamos el pedido*/

Static Function CreaPedido( cCodPrv, cCodAlm )

   local cSeriePedido
   local nNumeroPedido
   local cSufijoPedido

   /*Metemos las lineas en una temporal
     para controlar que no cree un pedido
     sin líneas o con unidades 0 */

   AppTemPedL( cCodAlm )

   if !( dbfTmpLin )->( Eof() )

      //--creo la cabecera del pedido--//

      ( dbfPrv )->( dbSeek( cCodPrv ) )

      //--recogo la serie, número, y sufijo del documento--//

      cSeriePedido               := cNewSer( "NPEDPRV" )
      nNumeroPedido              := nNewDoc( cSeriePedido, dbfPedPrvT, "NPEDPRV" )
      cSufijoPedido              := RetSufEmp()

      ( dbfPedPrvT )->( dbAppend())
      ( dbfPedPrvT )->cSerPed    := cSeriePedido
      ( dbfPedPrvT )->nNumPed    := nNumeroPedido
      ( dbfPedPrvT )->cSufPed    := cSufijoPedido
      ( dbfPedPrvT )->cTurPed    := cCurSesion()
      ( dbfPedPrvT )->dFecPed    := GetSysDate()
      ( dbfPedPrvT )->cCodPrv    := cCodPrv
      if !Empty( cCodAlm )
         ( dbfPedPrvT )->cCodAlm := cCodAlm
      else
         ( dbfPedPrvT )->cCodAlm := cDefAlm()
      end if
      ( dbfPedPrvT )->cCodCaj    := oUser():cCaja()
      ( dbfPedPrvT )->cNomPrv    := ( dbfPrv )->Titulo
      ( dbfPedPrvT )->cDirPrv    := ( dbfPrv )->Domicilio
      ( dbfPedPrvT )->cPobPrv    := ( dbfPrv )->Poblacion
      ( dbfPedPrvT )->cProPrv    := ( dbfPrv )->Provincia
      ( dbfPedPrvT )->cPosPrv    := ( dbfPrv )->CodPostal
      ( dbfPedPrvT )->cDniPrv    := ( dbfPrv )->Nif
      ( dbfPedPrvT )->dFecEnt    := GetSysDate() + ( dbfPrv )->nPlzEnt
      ( dbfPedPrvT )->nEstado    := 1
      ( dbfPedPrvT )->cDivPed    := cDivEmp()
      ( dbfPedPrvT )->nVdvPed    := nChgDiv( cDivEmp(), dbfDiv )
      ( dbfPedPrvT )->lSndDoc    := .t.
      ( dbfPedPrvT )->cCodUsr    := cCurUsr()
      ( dbfPedPrvT )->( dbRUnLock() )

      /*
      Añado las lineas del pedido----------------------------------------------
      */

      while !( dbfTmpLin )->( Eof() )

         ( dbfPedPrvL )->( dbAppend() )

         ( dbfPedPrvL )->cSerPed          := cSeriePedido
         ( dbfPedPrvL )->nNumPed          := nNumeroPedido
         ( dbfPedPrvL )->cSufPed          := cSufijoPedido
         ( dbfPedPrvL )->cRef             := ( dbfTmpLin )->cRef
         ( dbfPedPrvL )->cDetalle         := ( dbfTmpLin )->cDetalle
         ( dbfPedPrvL )->nIva             := ( dbfTmpLin )->nIva
         ( dbfPedPrvL )->nReq             := ( dbfTmpLin )->nReq
         ( dbfPedPrvL )->nCanPed          := ( dbfTmpLin )->nCanPed
         ( dbfPedPrvL )->nUniCaja         := ( dbfTmpLin )->nUniCaja
         ( dbfPedPrvL )->cUniDad          := ( dbfTmpLin )->cUniDad
         ( dbfPedPrvL )->nPreDiv          := ( dbfTmpLin )->nPreDiv
         ( dbfPedPrvL )->lLote            := ( dbfTmpLin )->lLote
         ( dbfPedPrvL )->nLote            := ( dbfTmpLin )->nLote
         ( dbfPedPrvL )->cLote            := ( dbfTmpLin )->cLote
         ( dbfPedPrvL )->cAlmLin          := ( dbfTmpLin )->cAlmLin

         ( dbfPedPrvL )->( dbRUnLock() )

      ( dbfTmpLin )->( dbSkip() )

      end while

      MsgInfo( "El pedido a proveedores " + AllTrim( cSeriePedido ) + "/" + AllTrim( Str( nNumeroPedido ) ) + "/" + AllTrim( cSufijoPedido ) + " se ha creado satisfactoriamente", "Información" )

   else

      MsgInfo( "No hay líneas para crear su pedido", "Información" )

   end if

return nil

//---------------------------------------------------------------------------//
/*Calcula las unidades a pedir*/

Static function nCalculaUnidades( nObjetivo )

   local nUnidades := 0

   do case
      case ( dbfTmpArt )->nStkFis <= 0
         nUnidades   := Abs( ( dbfTmpArt )->nStkFis ) + nObjetivo
      case ( dbfTmpArt )->nStkFis > 0 .and. ( dbfTmpArt )->nStkFis < nObjetivo
         nUnidades   := nObjetivo - ( dbfTmpArt )->nStkFis
      case ( dbfTmpArt )->nStkFis > 0 .and. ( dbfTmpArt )->nStkFis > nObjetivo
         nUnidades   := 0
   end case

Return ( nUnidades )

//---------------------------------------------------------------------------//
/*Añade en la temporal de lineas de pedidos*/

Static Function AppTemPedL( cCodAlm )

   ( dbfTmpArt )->( dbGoTop() )

   while !( dbfTmpArt )->( Eof() )

      ( dbfArticulo )->( dbGotop() )
      ( dbfArticulo )->( dbSeek( ( dbfTmpArt )->cRef ) )
      ( dbfIva )->( dbSeek( ( dbfArticulo )->TipoIva ) )

      if ( dbfTmpArt )->lSelArt .and. ( dbfTmpArt )->nNumUni != 0

         ( dbfTmpLin )->( dbAppend() )
         ( dbfTmpLin )->cRef             := ( dbfTmpArt )->cRef
         ( dbfTmpLin )->cDetalle         := ( dbfTmpArt )->cDetalle
         ( dbfTmpLin )->nIva             := ( dbfIva )->TPIva
         ( dbfTmpLin )->nReq             := ( dbfIva )->nRecEq
         ( dbfTmpLin )->nCanPed          := 1
         ( dbfTmpLin )->nUniCaja         := ( dbfTmpArt )->nNumUni
         ( dbfTmpLin )->cUniDad          := ( dbfArticulo )->cUniDad
         ( dbfTmpLin )->nPreDiv          := ( dbfArticulo )->pCosto
         ( dbfTmpLin )->lLote            := ( dbfArticulo )->lLote
         ( dbfTmpLin )->nLote            := ( dbfArticulo )->nLote
         ( dbfTmpLin )->cLote            := ( dbfArticulo )->cLote

         if !Empty( cCodAlm )
            ( dbfTmpLin )->cAlmLin       := cCodAlm
         else
            ( dbfTmpLin )->cAlmLin       := cDefAlm()
         end if

         ( dbfTmpLin )->( dbRUnLock() )

      end if

   ( dbfTmpArt )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTop() )

Return ( .t. )

//---------------------------------------------------------------------------//

function ShowKitCom( dbfMaster, dbfTmpLin, oBrw, cCodPrv, dbfTmpInc, aGet )

   if !Empty( aGet )

      if lUsrMaster() .or. oUser():lCambiarPrecio()
         aGet[ ( dbfMaster )->( FieldPos( "lRecargo" ) ) ]:HardEnable()
      else
         aGet[ ( dbfMaster )->( FieldPos( "lRecargo" ) ) ]:HardDisable()
      end if

      if !Empty( cCodPrv )
         aGet[ ( dbfMaster )->( FieldPos( "cCodPrv" ) ) ]:cText( cCodPrv )
         aGet[ ( dbfMaster )->( FieldPos( "cCodPrv" ) ) ]:lValid()
      end if

      aGet[ ( dbfMaster )->( FieldPos( "cCodPrv" ) ) ]:SetFocus()

   end if

   /*
   Hace que salte la incidencia al entrar en el documento----------------------
   */

   if !Empty( dbfTmpInc )

      while !( dbfTmpInc )->( Eof() )
         if ( dbfTmpInc )->lAviso .and. !( dbfTmpInc )->lListo
            MsgInfo( Trim( ( dbfTmpInc )->mDesInc ), "¡Incidencia!" )
         end if
         ( dbfTmpInc )->( dbSkip() )
      end while

      ( dbfTmpInc )->( dbGoTop() )

   end if

   oBrw:Refresh()

return nil

//----------------------------------------------------------------------------//

STATIC FUNCTION ValidaMedicion( aTmp, aGet )

   local cNewUndMed  := aGet[ _CUNIDAD ]:VarGet

   /*
   Cargamos el codigo de las unidades---------------------------------
   */

   if ( Empty( cOldUndMed ) .or. cOldUndMed != cNewUndMed )

      if oUndMedicion:oDbf:Seek( aTmp[ _CUNIDAD ] )

         if oUndMedicion:oDbf:nDimension >= 1 .and. !Empty( oUndMedicion:oDbf:cTextoDim1 )
            if !Empty( aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim1 )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]:cText( ( dbfArticulo )->nLngArt )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]:Show()
            else
               aTmp[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]  := ( dbfArticulo )->nLngArt
            end if
         else
            if !Empty( aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ] )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            else
               aTmp[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 2 .and. !Empty( oUndMedicion:oDbf:cTextoDim2 )
            if !Empty( aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim2 )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]:cText( ( dbfArticulo )->nAltArt )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]:Show()
            else
               aTmp[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]  := ( dbfArticulo )->nAltArt
            end if

         else
            if !Empty( aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ] )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            else
                 aTmp[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]  := 0
            end if
         end if

         if oUndMedicion:oDbf:nDimension >= 3 .and. !Empty( oUndMedicion:oDbf:cTextoDim3 )
            if !Empty( aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]:oSay:SetText( oUndMedicion:oDbf:cTextoDim3 )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]:cText( ( dbfArticulo ) ->nAncArt )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]:Show()
            else
               aTmp[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]  := ( dbfArticulo )->nAncArt
            end if
         else
            if !Empty( aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ] )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
               aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            else
               aTmp[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]  := 0
            end if
         end if

      else

         if !Empty( aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ] )
            aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]:Hide()
            aGet[ ( dbfPedPrvL )->( fieldpos( "nMedUno" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ] )
            aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]:Hide()
            aGet[ ( dbfPedPrvL )->( fieldpos( "nMedDos" ) ) ]:cText( 0 )
         end if

         if !Empty( aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ] )
            aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]:Hide()
            aGet[ ( dbfPedPrvL )->( fieldpos( "nMedTre" ) ) ]:cText( 0 )
         end if

      end if

      cOldUndMed := cNewUndMed

   end if

RETURN .t.
//---------------------------------------------------------------------------//

Static Function nTotRecibido( dbfLin, dbfAlbPrvL )

   local nTotRec
   local nTotUni
   local nEstado     := 1

   nTotRec           := nUnidadesRecibidasPedPrv( ( dbfLin )->cSerPed + Str( ( dbfLin )->nNumPed ) + ( dbfLin )->cSufPed, ( dbfLin )->cRef, ( dbfLin )->cValPr1, ( dbfLin )->cValPr2, ( dbfLin )->cRefPrv, ( dbfLin )->cDetalle, dbfAlbPrvL )
   nTotUni           := nTotNPedPrv( dbfLin )

   do case
      case nTotRec == 0
         nEstado     := 1
      case nTotRec < nTotUni
         nEstado     := 2
      case nTotRec >= nTotUni
         nEstado     := 3
   end case

RETURN ( nEstado )

//---------------------------------------------------------------------------//

Function IsPedPrv( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "PedProvT.DBF" )
      dbCreate( cPath + "PedProvT.DBF", aSqlStruct( aItmPedPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedProvL.DBF" )
      dbCreate( cPath + "PedProvL.DBF", aSqlStruct( aColPedPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedPrvI.Dbf" )
      dbCreate( cPath + "PedPrvI.Dbf", aSqlStruct( aIncPedPrv() ), cDriver() )
   end if

   if !lExistTable( cPath + "PedPrvD.Dbf" )
      dbCreate( cPath + "PedPrvD.Dbf", aSqlStruct( aPedPrvDoc() ), cDriver() )
   end if

   if !lExistIndex( cPath + "PedProvT.Cdx" ) .or. ;
      !lExistIndex( cPath + "PedProvL.Cdx" ) .or. ;
      !lExistIndex( cPath + "PedPrvI.Cdx" )  .or. ;
      !lExistIndex( cPath + "PedPrvD.Cdx" )
      rxPedPrv( cPath )
   end if

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION cDesPedPrv( cPedPrvL )

   DEFAULT cPedPrvL  := dbfPedPrvL

RETURN ( Descrip( cPedPrvL ) )

//---------------------------------------------------------------------------//

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Pedidos", ( dbfPedPrvT )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Pedidos", cItemsToReport( aItmPedPrv() ) )

   oFr:SetWorkArea(     "Lineas de pedidos", ( dbfPedPrvL )->( Select() ) )
   oFr:SetFieldAliases( "Lineas de pedidos", cItemsToReport( aColPedPrv() ) )

   oFr:SetWorkArea(     "Incidencias de pedidos", ( dbfPedPrvI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de pedidos", cItemsToReport( aIncPedPrv() ) )

   oFr:SetWorkArea(     "Documentos de pedidos", ( dbfPedPrvD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de pedidos", cItemsToReport( aPedPrvDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedor", ( dbfPrv )->( Select() ) )
   oFr:SetFieldAliases( "Proveedor", cItemsToReport( aItmPrv() ) )

   oFr:SetWorkArea(     "Almacenes", ( dbfAlm )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( dbfFpago )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Usuarios", ( dbfUsr )->( Select() ) )
   oFr:SetFieldAliases( "Usuarios", cItemsToReport( aItmUsuario() ) )

   oFr:SetWorkArea(     "Artículos", ( dbfArticulo )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( dbfArtPrv )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  oUndMedicion:Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( oUndMedicion:oDbf ) )

   oFr:SetWorkArea(     "Clientes", ( dbfClient )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetMasterDetail( "Pedidos", "Lineas de pedidos",        {|| ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed } )
   oFr:SetMasterDetail( "Pedidos", "Incidencias de pedidos",   {|| ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed } )
   oFr:SetMasterDetail( "Pedidos", "Documentos de pedidos",    {|| ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed } )
   oFr:SetMasterDetail( "Pedidos", "Proveedor",                {|| ( dbfPedPrvT )->cCodPrv } )
   oFr:SetMasterDetail( "Pedidos", "Almacenes",                {|| ( dbfPedPrvT )->cCodAlm } )
   oFr:SetMasterDetail( "Pedidos", "Formas de pago",           {|| ( dbfPedPrvT )->cCodPgo } )
   oFr:SetMasterDetail( "Pedidos", "Usuarios",                 {|| ( dbfPedPrvT )->cCodUsr } )
   oFr:SetMasterDetail( "Pedidos", "Empresa",                  {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Pedidos", "Clientes",                 {|| GetCodCli( ( dbfPedPrvT )->cNumPedCli ) } )

   oFr:SetMasterDetail( "Lineas de pedidos", "Artículos",               {|| ( dbfPedPrvL )->cRef } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Código de proveedores",   {|| ( dbfPedPrvT )->cCodPrv + ( dbfPedPrvL )->cRef } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Unidades de medición",    {|| ( dbfPedPrvL )->cUnidad } )

   oFr:SetResyncPair(   "Pedidos", "Lineas de pedidos" )
   oFr:SetResyncPair(   "Pedidos", "Incidencias de pedidos" )
   oFr:SetResyncPair(   "Pedidos", "Documentos de pedidos" )
   oFr:SetResyncPair(   "Pedidos", "Empresa" )
   oFr:SetResyncPair(   "Pedidos", "Proveedor" )
   oFr:SetResyncPair(   "Pedidos", "Almacenes" )
   oFr:SetResyncPair(   "Pedidos", "Formas de pago" )
   oFr:SetResyncPair(   "Pedidos", "Usuarios" )
   oFr:SetResyncPair(   "Pedidos", "Clientes" )

   oFr:SetResyncPair(   "Lineas de pedidos", "Artículos" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Código de proveedores" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Unidades de medición" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Pedidos" )
   oFr:DeleteCategory(  "Lineas de pedidos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Pedidos",             "Total pedido",                        "GetHbVar('nTotPed')" )
   oFr:AddVariable(     "Pedidos",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Pedidos",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Pedidos",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Pedidos",             "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "Pedidos",             "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "Pedidos",             "Total " + cImp(),                     "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Pedidos",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Pedidos",             "Total retención",                     "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Pedidos",             "Bruto primer tipo de " + cImp(),      "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Pedidos",             "Bruto segundo tipo de " + cImp(),     "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Pedidos",             "Bruto tercer tipo de " + cImp(),      "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Pedidos",             "Base primer tipo de " + cImp(),       "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Pedidos",             "Base segundo tipo de " + cImp(),      "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Pedidos",             "Base tercer tipo de " + cImp(),       "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje primer tipo " + cImp(),    "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje segundo tipo " + cImp(),   "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje tercer tipo " + cImp(),    "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "Pedidos",             "Importe primer tipo " + cImp(),       "GetHbArrayVar('aIvaUno',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe segundo tipo " + cImp(),      "GetHbArrayVar('aIvaDos',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe tercer tipo " + cImp(),       "GetHbArrayVar('aIvaTre',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe primer RE",                   "GetHbArrayVar('aIvaUno',6)" )
   oFr:AddVariable(     "Pedidos",             "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',6)" )
   oFr:AddVariable(     "Pedidos",             "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',6)" )

   oFr:AddVariable(     "Lineas de pedidos",   "Detalle del artículo",                "CallHbFunc('cDesPedPrv')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Total unidades artículo",             "CallHbFunc('nTotNPedPrv')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Precio unitario del artículo",        "CallHbFunc('nTotUPedPrv')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Total línea de pedido",               "CallHbFunc('nTotLPedPrv')" )

Return nil

//---------------------------------------------------------------------------//

Static Function MailingReport( oFr )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Pedidos",             "Total pedido",                        "GetHbVar('nTotPed')" )
   oFr:AddVariable(     "Pedidos",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Pedidos",             "Total bruto",                         "GetHbVar('nTotBrt')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento",                     "GetHbVar('nTotDto')" )
   oFr:AddVariable(     "Pedidos",             "Total descuento pronto pago",         "GetHbVar('nTotDpp')" )
   oFr:AddVariable(     "Pedidos",             "Total neto",                          "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Pedidos",             "Total primer descuento definible",    "GetHbVar('nTotUno')" )
   oFr:AddVariable(     "Pedidos",             "Total segundo descuento definible",   "GetHbVar('nTotDos')" )
   oFr:AddVariable(     "Pedidos",             "Total " + cImp(),                           "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Pedidos",             "Total RE",                            "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Pedidos",             "Total retención",                     "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Pedidos",             "Bruto primer tipo de " + cImp(),            "GetHbArrayVar('aIvaUno',1)" )
   oFr:AddVariable(     "Pedidos",             "Bruto segundo tipo de " + cImp(),           "GetHbArrayVar('aIvaDos',1)" )
   oFr:AddVariable(     "Pedidos",             "Bruto tercer tipo de " + cImp(),            "GetHbArrayVar('aIvaTre',1)" )
   oFr:AddVariable(     "Pedidos",             "Base primer tipo de " + cImp(),             "GetHbArrayVar('aIvaUno',2)" )
   oFr:AddVariable(     "Pedidos",             "Base segundo tipo de " + cImp(),            "GetHbArrayVar('aIvaDos',2)" )
   oFr:AddVariable(     "Pedidos",             "Base tercer tipo de " + cImp(),             "GetHbArrayVar('aIvaTre',2)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje primer tipo " + cImp(),          "GetHbArrayVar('aIvaUno',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje segundo tipo " + cImp(),         "GetHbArrayVar('aIvaDos',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje tercer tipo " + cImp(),          "GetHbArrayVar('aIvaTre',3)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje primer tipo RE",           "GetHbArrayVar('aIvaUno',4)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje segundo tipo RE",          "GetHbArrayVar('aIvaDos',4)" )
   oFr:AddVariable(     "Pedidos",             "Porcentaje tercer tipo RE",           "GetHbArrayVar('aIvaTre',4)" )
   oFr:AddVariable(     "Pedidos",             "Importe primer tipo " + cImp(),             "GetHbArrayVar('aIvaUno',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe segundo tipo " + cImp(),            "GetHbArrayVar('aIvaDos',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe tercer tipo " + cImp(),             "GetHbArrayVar('aIvaTre',5)" )
   oFr:AddVariable(     "Pedidos",             "Importe primer RE",                   "GetHbArrayVar('aIvaUno',6)" )
   oFr:AddVariable(     "Pedidos",             "Importe segundo RE",                  "GetHbArrayVar('aIvaDos',6)" )
   oFr:AddVariable(     "Pedidos",             "Importe tercer RE",                   "GetHbArrayVar('aIvaTre',6)" )

   oFr:AddVariable(     "Lineas de pedidos",   "Detalle del artículo",                "CallHbFunc('cDesPedPrv')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Total unidades artículo",             "CallHbFunc('nTotNPedPrv')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Precio unitario del artículo",        "CallHbFunc('nTotUPedPrv')" )
   oFr:AddVariable(     "Lineas de pedidos",   "Total línea de pedido",               "CallHbFunc('nTotLPedPrv')" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportPedPrv( oFr, dbfDoc )

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

   if lFlag

      /*
      Zona de datos------------------------------------------------------------
      */

      DataReport( oFr )

      /*
      Paginas y bandas---------------------------------------------------------
      */

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      else

         oFr:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )
         oFr:SetProperty(     "Report.ScriptText", "Text",;
                                                   + ;
                                                   "procedure DetalleOnMasterDetail(Sender: TfrxComponent);"   + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "CallHbFunc('nTotPedPrv');"                                 + Chr(13) + Chr(10) + ;
                                                   "end;"                                                      + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "end." )

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
         oFr:SetProperty(     "CabeceraDocumento", "Top", 0 )
         oFr:SetProperty(     "CabeceraDocumento", "Height", 200 )

         oFr:AddBand(         "CabeceraColumnas",  "MainPage", frxMasterData )
         oFr:SetProperty(     "CabeceraColumnas",  "Top", 200 )
         oFr:SetProperty(     "CabeceraColumnas",  "Height", 0 )
         oFr:SetProperty(     "CabeceraColumnas",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet", "Pedidos" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de pedidos" )
         oFr:SetProperty(     "DetalleColumnas",   "OnMasterDetail", "DetalleOnMasterDetail" )

         oFr:AddBand(         "PieDocumento",      "MainPage", frxPageFooter )
         oFr:SetProperty(     "PieDocumento",      "Top", 930 )
         oFr:SetProperty(     "PieDocumento",      "Height", 110 )

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

      if lOpen
         CloseFiles()
      end if

   else

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

Function PrintReportPedPrv( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr
   local cFilePdf       := cPatTmp() + "PedidoProveedor" + StrTran( ( dbfPedPrvT )->cSerPed + Str( ( dbfPedPrvT )->nNumPed ) + ( dbfPedPrvT )->cSufPed, " ", "" ) + ".Pdf"

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

   DataReport( oFr )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Zona de variables--------------------------------------------------------
      */

      VariableReport( oFr )

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

            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:SetProperty(  "PDFExport", "DefaultPath",      cPatTmp() )
            oFr:SetProperty(  "PDFExport", "FileName",         cFilePdf )
            oFr:SetProperty(  "PDFExport", "ShowDialog",       .f. )
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:SetProperty(  "PDFExport", "OpenAfterExport",  .t. )
            oFr:DoExport(     "PDFExport" )

         case nDevice == IS_MAIL

            oFr:SetProperty(  "PDFExport", "ShowDialog",       .f. )
            oFr:SetProperty(  "PDFExport", "DefaultPath",      cPatTmp() )
            oFr:SetProperty(  "PDFExport", "FileName",         cFilePdf )
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:SetProperty(  "PDFExport", "OpenAfterExport",  .f. )
            oFr:DoExport(     "PDFExport" )

            if file( cFilePdf )

               with object ( TGenMailing():New() )

                  :SetTypeDocument( "nPedPrv" )
                  :SetDe(           uFieldEmpresa( "cNombre" ) )
                  :SetCopia(        uFieldEmpresa( "cCcpMai" ) )
                  :SetAdjunto(      cFilePdf )
                  :SetPara(         RetFld( ( dbfPedPrvT )->cCodPrv, dbfPrv, "cMeiInt" ) )
                  :SetAsunto(       "Envio de pedido de proveedor número " + ( dbfPedPrvT )->cSerPed + "/" + Alltrim( Str( ( dbfPedPrvT )->nNumPed ) ) )
                  :SetMensaje(      "Adjunto le remito nuestro pedido de proveedor " + ( dbfPedPrvT )->cSerPed + "/" + Alltrim( Str( ( dbfPedPrvT )->nNumPed ) ) + Space( 1 ) )
                  :SetMensaje(      "de fecha " + Dtoc( ( dbfPedPrvT )->dfecPed ) + Space( 1 ) )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      "Reciba un cordial saludo." )

                  :GeneralResource( dbfPedPrvT, aItmFacRec() )

               end with

            end if

      end case

   end if

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

Return .t.

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

	 if oWndBrw:oWndBar:lAllYearComboBox()
		DestroyFastFilter( dbfPedPrvT )
      CreateUserFilter( "", dbfPedPrvT, .f., , , "all" )
	 else
		DestroyFastFilter( dbfPedPrvT )
      CreateUserFilter( "Year( Field->dFecPed ) == " + oWndBrw:oWndBar:cYearComboBox(), dbfPedPrvT, .f., , , "Year( Field->dFecPed ) == " + oWndBrw:oWndBar:cYearComboBox() )
	 end if

	 ( dbfPedPrvT )->( dbGoTop() )

	 oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//