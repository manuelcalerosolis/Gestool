#include "FiveWin.Ch"
#include "Report.ch"
#include "Folder.ch"
#include "Label.ch"
#include "RichEdit.ch" 
#include "Xbrowse.ch"
#include "FastRepH.ch"
#include "Factu.ch" 
#include "Ini.ch"

#define _COD                       1      //   C      7     0
#define _TITULO                    2      //   C     50     0
#define _NIF                       3      //   C     15     0
#define _DOMICILIO                 4      //   C     35     0
#define _POBLACION                 5      //   C     25     0
#define _PROVINCIA                 6      //   C     20     0
#define _CODPOSTAL                 7      //   C     15     0
#define _TELEFONO                  8      //   C     12     0
#define _FAX                       9      //   C     12     0
#define _MOVIL                    10      //   C     12     0
#define _NBREST                   11      //   C     35     0
#define _DIREST                   12      //   C     35     0
#define _DIAPAGO                  13      //   N      2     0
#define _DIAPAGO2                 14      //   N      2     0
#define _BANCO                    15      //   C     35     0
#define _DIRBANCO                 16      //   C     35     0
#define _POBBANCO                 17      //   C     25     0
#define _CPROBANCO                18      //   C     20     0
#define _CUENTA                   19      //   C     20     0
#define _NTIPCLI                  20
#define _CODPAGO                  21      //   C      2     0
#define _CDTOESP                  22      //   C     50     2
#define _NDTOESP                  23      //   N      5     2
#define _CDPP                     24      //   C     50     2
#define _NDPP                     25      //   N      5     2
#define _NDTOCNT                  26      //   N      5     2
#define _NDTORAP                  27      //   N      5     2
#define _CDTOUNO                  28      //   C     50     2
#define _CDTODOS                  29      //   C     50     2
#define _NDTOPTF                  30      //   N      5     2
#define _RIESGO                   31      //   N     10     0
#define _COPIASF                  32      //   N      1     0
#define _SERIE                    33      //   C      1     0
#define _NREGIVA                  34      //   L      1     0
#define _LREQ                     35      //   L      1     0
#define _SUBCTA                   36      //   C     12     0
#define _CTAVENTA                 37      //   C      3     0
#define _CAGENTE                  38      //   C      3     0
#define _LMAYORISTA               39      //   L      1     0
#define _NTARIFA                  40      //   N      1     0
#define _LLABEL                   41      //   L      1     0
#define _NLABEL                   42      //   N      5     0
#define _CCODTAR                  43      //   C      4     0
#define _MCOMENT                  44      //   M     10     0
#define _CCODRUT                  45      //   C      4     0
#define _CCODRUT2                 46      //   C      4     0
#define _CCODPAI                  47      //   C      4     0
#define _CCODGRP                  48      //   C      4     0
#define _CCODREM                  49      //   C      4     0
#define _CMEIINT                  50      //   C     65     0
#define _CWEBINT                  51      //   C     65     0
#define _LCHGPRE                  52      //   L      1     0
#define _LCRESOL                  53      //   L      1     0
#define _LPNTVER                  54      //   L      1     0
#define _CUSRDEF01                55      //   C     100    0
#define _CUSRDEF02                56      //   C     100    0
#define _CUSRDEF03                57      //   C     100    0
#define _CUSRDEF04                58      //   C     100    0
#define _CUSRDEF05                59      //   C     100    0
#define _CUSRDEF06                60      //   C     100    0
#define _CUSRDEF07                61      //   C     100    0
#define _CUSRDEF08                62      //   C     100    0
#define _CUSRDEF09                63      //   C     100    0
#define _CUSRDEF10                64      //   C     100    0
#define _LVISLUN                  65      //   L      1     0
#define _LVISMAR                  66      //   L      1     0
#define _LVISMIE                  67      //   L      1     0
#define _LVISJUE                  68      //   L      1     0
#define _LVISVIE                  69      //   L      1     0
#define _LVISSAB                  70      //   L      1     0
#define _LVISDOM                  71      //   L      1     0
#define _NVISLUN                  72      //   N      3     0
#define _NVISMAR                  73      //   N      3     0
#define _NVISMIE                  74      //   N      3     0
#define _NVISJUE                  75      //   N      3     0
#define _NVISVIE                  76      //   N      3     0
#define _NVISSAB                  77      //   N      3     0
#define _NVISDOM                  78      //   N      3     0
#define _CAGELUN                  79      //   N      3     0
#define _CAGEMAR                  80      //   N      3     0
#define _CAGEMIE                  81      //   N      3     0
#define _CAGEJUE                  82      //   N      3     0
#define _CAGEVIE                  83      //   N      3     0
#define _CAGESAB                  84      //   N      3     0
#define _CAGEDOM                  85      //   N      3     0
#define _LSNDINT                  86      //   L      1     0
#define _CPERCTO                  87      //   L      1     0
#define _CCODALM                  88      //   C      3     0
#define _NMESVAC                  89      //   N      2     0
#define _NIMPRIE                  90      //   N     16     6
#define _NCOLOR                   91      //   N     16     6
#define _SUBCTADTO                92      //   C     12     0
#define _LBLQCLI                  93      //   L      1     0
#define _LMOSCOM                  94      //   L      1     0
#define _LTOTALB                  95      //   L      1     0
#define _CDTOATP                  96      //   C     50     0
#define _NDTOATP                  97      //   N      6     2
#define _NSBRATP                  98      //   N      1     0
#define _CCODUSR                  99      //
#define _DFECCHG                 100      //
#define _CTIMCHG                 101      //
#define _NTIPRET                 102      //
#define _NPCTRET                 103      //
#define _DFECBLQ                 104      //   D      8     0
#define _CMOTBLQ                 105      //   C     50     0
#define _LMODDAT                 106      //   l      1     0
#define _LMAIL                   107      //   L      1     0
#define _CCODTRN                 108      //   L      1     0
#define _MOBSERV                 109      //   M     10     0
#define _LPUBINT                 110      //   L     1      0
#define _CCLAVE                  111      //   C     40     0
#define _CCODWEB                 112      //   N     11     0
#define _CCODEDI                 113      //   N     11     0
#define _CFACAUT                 114      //   C      3     0
#define _LWEB                    115      //   L      1     0
#define _NDTOART                 116      //   N      1     0
#define _LEXCFID                 117      //   L      1     0
#define _MFACAUT                 118      //   M     10     0
#define _DFECNACI                119      //   D      8     0
#define _NSEXO                   120      //   N      7     0 
#define _NTARCMB                 121      //   N      1     0
#define _DLLACLI                 122
#define _CTIMCLI                 123
#define _CTIPINCI                124

#define _aCCODCLI                  1      //   C     12     0
#define _aCCODGRP                  2      //   C     12     0
#define _aCCODART                  3     //   C     14     0
#define _aCCODFAM                  4     //   C      8     0
#define _aNTIPATP                  5     //   N      1     0
#define _aCCODPR1                  6     //   C      5     0
#define _aCVALPR1                  7     //   C      5     0
#define _aCCODPR2                  8     //   C      5     0
#define _aCVALPR2                  9     //   C      5     0
#define _aDFECINI                 10     //   D      8     0
#define _aDFECFIN                 11     //   D      8     0
#define _aLPRCCOM                 12     //   L      1     0
#define _aNPRCCOM                 13     //   N     16     6
#define _aNPRCART                 14     //   N     16     6
#define _aNPRCART2                15     //   N     16     6
#define _aNPRCART3                16     //   N     16     6
#define _aNPRCART4                17     //   N     16     6
#define _aNPRCART5                18     //   N     16     6
#define _aNPRCART6                19     //   N     16     6
#define _aNPREIVA1                20     //   N     16     6
#define _aNPREIVA2                21     //   N     16     6
#define _aNPREIVA3                22     //   N     16     6
#define _aNPREIVA4                23     //   N     16     6
#define _aNPREIVA5                24     //   N     16     6
#define _aNPREIVA6                25     //   N     16     6
#define _aNDTOART                 26     //   N      6     2
#define _aNDPRART                 27     //   N      6     2
#define _aLCOMAGE                 28     //   L      1     0
#define _aNCOMAGE                 29     //   N      6     2
#define _aNDTODIV                 30     //   N     16     6
#define _aLAPLPRE                 31     //   L      1     0
#define _aLAPLPED                 32     //   L      1     0
#define _aLAPLALB                 33     //   L      1     0
#define _aLAPLFAC                 34     //   L      1     0
#define _aLAPLSAT                 35     //   L      1     0
#define _aNUNVOFE                 36     //   N      3     0
#define _aNUNCOFE                 37     //   N      3     0
#define _aNTIPXBY                 38     //   N      1     0
#define _aNDTO1                   39     //   N     16     6
#define _aNDTO2                   40     //   N     16     6
#define _aNDTO3                   41     //   N     16     6
#define _aNDTO4                   42     //   N     16     6
#define _aNDTO5                   43     //   N     16     6
#define _aNDTO6                   44      //   N     16     6

#define fldGeneral                oFld:aDialogs[1]
#define fldComercial              oFld:aDialogs[2]
#define fldAutomaticas            oFld:aDialogs[3]
#define fldDirecciones            oFld:aDialogs[4]
#define fldBancos                 oFld:aDialogs[5]
#define fldContabilidad           oFld:aDialogs[6]
#define fldDefinidos              oFld:aDialogs[7]
#define fldTarifa                 oFld:aDialogs[8]
#define fldDocumentos             oFld:aDialogs[9]
#define fldIncidencias            oFld:aDialogs[10]
#define fldObservaciones          oFld:aDialogs[11]
#define fldContactos              oFld:aDialogs[12]
#define fldFacturae               oFld:aDialogs[13]
#define fldRecibos                oFld:aDialogs[14]

#define FW_BOLD                   700

memvar dbfCli
memvar cDbfCli
memvar dbfObr
memvar cDbfObr
memvar dbfCon
memvar cDbfCon

static oWndBrw
static dbfConfig

static nView

static filClient
static tmpClient

static dbfClientD
static dbfPro
static dbfProL
static dbfArtKit
static dbfFPago
static dbfDoc
static cFpago
static dbfFamilia
static oBandera
static dbfObrasT
static dbfContactos
static dbfBanco
static dbfAlmT
static dbfRuta
static dbfTmpDoc
static dbfTmpFacturae
static dbfTmpObr
static dbfTmpBnc
static dbfTmpAtp
static dbfTmpInc
static dbfTmpCon
static dbfTmpSubCta
static dbfArtDiv
static dbfOfe
static oTrans
static cTmpDoc
static cTmpFacturae
static cTmpObr
static cTmpBnc
static cTmpAtp
static cTmpCta
static cTmpInc
static cTmpCon
static oFacAut
static oGrpCli
static oPais
static oCtaRem
static cAgente
static oNewImp

static cPinDiv
static cPouDiv
static cPorDiv

static aRgbColor

static oMenu

static oStock
static oBanco
static aFacAut          := {}

static oFecIniCli
static oFecFinCli
static dFecIniCli
static dFecFinCli

static oEstadoCli
static aEstadoCli    := { "Pendientes", "Pagados", "Todos" }
static cEstadoCli

static oPeriodoCli
static aPeriodoCli   := {}
static cPeriodoCli

static aDescuentosAtipicos

static oBrwRecCli

static oRTF
static cRTF
static lBold
static lItalic
static lUnderline
static lBullet

static aRentabilidad    := { { "", "", 0, .t., .f. } }
static aStrClients      := { "Clientes", "Potenciales", "Web" }

static lExpandida       := .f.

static lExternal        := .f.
static lOpenFiles       := .f.

static nLabels          := 1

static aIniCli         

static bEdtRec          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }
static bEdtBig          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode | EdtBig( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }
static bEdtAtp          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode | EdtAtp( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }
static bEdtDoc          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodCli | EdtDoc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodCli ) }
static bEdtBnc          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodCli | EdtBnc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodCli ) }
static bEdtInc          := { | aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode | EdtInc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }

static oReporting

//-----------------------------------------------------------------------------

STATIC FUNCTION OpenFiles( lExt )

   local oBlock
   local oError

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de clientes' )
      Return ( .f. )
   end if

   DEFAULT  lExt        := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DisableAcceso()

      nView             := D():CreateView()

      lOpenFiles        := .t.

      D():Clientes( nView )

      D():Get( "TIva", nView )

      D():Get( "Divisas", nView )

      D():Get( "ClientD", nView )

      D():Get( "CliAtp", nView )

      D():Get( "Articulo", nView )

      D():Get( "AlbCliT", nView )

      D():Get( "FacCliT", nView )

      D():Get( "FacCliP", nView )
      ( D():Get( "FacCliP", nView ) )->( OrdSetFocus( "cCodCli" ) )

      D():Get( "TipInci", nView )

      D():Get( "CliInc", nView )

      D():ClientesFacturae( nView )

      /*
      Apertura de fichero de Obras------------------------------------------------
      */

      USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
      SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE

      /*
      Apertura de fichero de Contactos--------------------------------------------
      */

      USE ( cPatCli() + "CliContactos.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CliConta", @dbfContactos ) )
      SET ADSINDEX TO ( cPatCli() + "CliContactos.Cdx" ) ADDITIVE

      /*
      Apertura de fichero de Bancos------------------------------------------------
      */

      USE ( cPatCli() + "CliBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIBNC", @dbfBanco ) )
      SET ADSINDEX TO ( cPatCli() + "CliBnc.Cdx" ) ADDITIVE

      /*
      Articulos-------------------------------------------------------------------
      */

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfArtKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @cAgente ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

      /*
      Otros Ficheros--------------------------------------------------------------
      */

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatArt() + "FAMILIAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "FAMILIAS.CDX" ) ADDITIVE

      USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
      SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

      USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfProL ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE


      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      SET TAG TO "CTIPO"

      USE ( cPatArt() + "OFERTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OFERTA", @dbfOfe ) )
      SET ADSINDEX TO ( cPatArt() + "OFERTA.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTDIV.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTDIV", @dbfArtDiv ) )
      SET ADSINDEX TO ( cPatArt() + "ARTDIV.CDX" ) ADDITIVE

      USE ( cPatCli() + "RUTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "RUTA", @dbfRuta ) )
      SET ADSINDEX TO ( cPatCli() + "RUTA.CDX" ) ADDITIVE

      oBandera             := TBandera():New()

      oStock               := TStock():Create( cPatGrp() )
      if !oStock:lOpenFiles()
         lOpenFiles        := .f.
      end if

      oPais                := TPais():Create( cPatDat() )
      if !oPais:OpenFiles()
         lOpenFiles        := .f.
      end if

      oCtaRem              := TCtaRem():Create( cPatCli() )
      if !oCtaRem:OpenFiles()
         lOpenFiles        := .f.
      end if

      oNewImp              := TNewImp():Create( cPatEmp() )
      if !oNewImp:OpenFiles()
         lOpenFiles        := .f.
      end if

      oTrans               := TTrans():Create( cPatCli() )
      if !oTrans:OpenFiles()
         lOpenFiles        := .f.
      end if
      
      oFacAut              := TFacAutomatica():Create( cPatEmp() )
      if !oFacAut:Openfiles()
         lOpenfiles        := .f.
      end if

      oBanco               := TBancos():Create()
      oBanco:OpenFiles()

      oGrpCli              := TGrpCli():Create( cPatCli() )
      if !oGrpCli:OpenFiles()
         lOpenFiles        := .f.
      end if

      cPinDiv              := cPinDiv( cDivEmp() ) // Picture de la divisa de compra
      cPouDiv              := cPouDiv( cDivEmp() ) // Picture de la divisa
      cPorDiv              := cPorDiv( cDivEmp() ) // Picture de la divisa redondeada

      LoaIniCli( cPatEmp() )

      EnableAcceso()

   RECOVER USING oError

      lOpenFiles           := .f.

      EnableAcceso()

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

RETURN ( lOpenFiles )

//--------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles( lDestroy )

   DEFAULT lDestroy  := .f.

   DisableAcceso()

   if oGrpCli != nil
      oGrpCli:End()
   end if

   CLOSE ( dbfArtKit    )
   CLOSE ( cFPago       )
   CLOSE ( cAgente      )
   CLOSE ( dbfObrasT    )
   CLOSE ( dbfContactos )
   CLOSE ( dbfFPago     )
   CLOSE ( dbfAlmT      )
   CLOSE ( dbfFamilia   )
   CLOSE ( dbfPro       )
   CLOSE ( dbfProL      )
   CLOSE ( dbfDoc       )
   CLOSE ( dbfBanco     )
   CLOSE ( dbfOfe       )
   CLOSE ( dbfArtDiv    )
   CLOSE ( dbfRuta      )

   if !Empty( oStock )
      oStock:end()
   end if

   if oPais != nil
      oPais:end()
   end if

   if oCtaRem != nil
      oCtaRem:end()
   end if

   if oNewImp != nil
      oNewImp:end()
   end if

   if !Empty( oTrans )
      oTrans:End()
   end if

   if !Empty( oFacAut )
      oFacAut:End()
   end if

   if !Empty( oBanco )
      oBanco:End()
   end if

   D():DeleteView( nView )

   dbfArtKit      := nil
   cFPago         := nil
   cAgente        := nil
   dbfObrasT      := nil
   dbfContactos   := nil
   dbfFPago       := nil
   dbfAlmT        := nil
   dbfFamilia     := nil
   dbfPro         := nil
   dbfProL        := nil
   dbfDoc         := nil
   dbfBanco       := nil
   dbfOfe         := nil
   dbfArtDiv      := nil
   dbfRuta        := nil

   if lDestroy
      oWndBrw     := nil
   end if

   lOpenFiles     := .f.

   EnableAcceso()

Return .t.

//--------------------------------------------------------------------------//
//Funciones del programa
//--------------------------------------------------------------------------//

FUNCTION Client( oMenuItem, oWnd, cCodCli )

   local oSnd
   local oRpl
   local oDel
   local nLevel
   local oRotor

   DEFAULT  oMenuItem   := "01032"
   DEFAULT  oWnd        := oWnd()

   if Empty( oWndBrw )

      /*
      Obtenemos el nivel de acceso---------------------------------------------
      */

      nLevel            := nLevelUsr( oMenuItem )

      if nAnd( nLevel, 1 ) != 0
         msgStop( "Acceso no permitido." )
         return nil
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
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador---------------------------------
      */

      DisableAcceso()

      DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
         XBROWSE ;
         TITLE    "Clientes" ;
         PROMPT   "Código cliente",;
                  "Nombre",;
                  if( uFieldEmpresa( "nCifRut" ) == 1, "NIF/CIF", "RUT" ),;
                  "Población",;
                  "Provincia",;
                  "Código postal",;
                  "Teléfono",;
                  "Establecimiento",;
                  "Correo electrónico",;
                  "Cliente web" ,;
                  "Ruta" ,;
                  if( Empty( AllTrim( aIniCli[1] ) ), "Campo definido 1", AllTrim( aIniCli[1] ) ) ,;
                  if( Empty( AllTrim( aIniCli[2] ) ), "Campo definido 2", AllTrim( aIniCli[2] ) ) ,;
                  if( Empty( AllTrim( aIniCli[3] ) ), "Campo definido 3", AllTrim( aIniCli[3] ) ) ;
         ALIAS    ( D():Get( "Client", nView ) );
         MRU      "User1_16";
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, D():Get( "Client", nView ) ) );
         DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, D():Get( "Client", nView ) ) );
         EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, D():Get( "Client", nView ) ) ) ;
         DELETE   ( WinDelRec( oWndBrw:oBrw, D():Get( "Client", nView ) ) ) ;
         LEVEL    nLevel ;
         OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Bloqueado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->lBlqCli }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "stop_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :cSortOrder       := "lSndInt"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->lSndInt }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "LBl16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Internet"
         :cSortOrder       := "lPubInt"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->lPubInt }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "SNDINT16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tarifas atipicas"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Get( "CliAtp", nView ) )->( dbSeek( ( D():Get( "Client", nView ) )->Cod ) ) }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "PERCENT_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Potencial"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->nTipCli == 2 }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "CLIPOT" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código cliente"
         :cSortOrder       := "Cod"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Cod }
         :nWidth           := 110
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Titulo"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Titulo }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with


      with object ( oWndBrw:AddXCol() )
         if uFieldEmpresa( "nCifRut" ) == 1
         :cHeader          := "NIF/CIF"
         else
         :cHeader          := "RUT"
         :cEditPicture     := "@R 999999999-9"
         end if
         :cSortOrder       := "Nif"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Nif }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Teléfono"
         :cSortOrder       := "Telefono"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Telefono }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fax"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Fax }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Domicilio"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Domicilio }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Población"
         :cSortOrder       := "Poblacion"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Poblacion }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código postal"
         :cSortOrder       := "CodPostal"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->CodPostal }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Provincia"
         :cSortOrder       := "Provincia"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Provincia }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Establecimiento"
         :cSortOrder       := "NbrEst"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->NbrEst }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Correo electrónico"
         :cSortOrder       := "cMeiInt"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->cMeiInt }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Riesgo"
         :bEditValue       := {|| Trans( ( D():Get( "Client", nView ) )->Riesgo, PicOut() ) }
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Contacto"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->cPerCto }
         :nWidth           := 200
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Observaciones"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->mComent }
         :nWidth           := 200
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cliente web"
         :cSortOrder       := "cCliWeb"
         :bEditValue       := {|| aStrClients[ Min( Max( ( D():Get( "Client", nView ) )->nTipCli, 1 ), len( aStrClients ) ) ] }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Ruta"
         :cSortOrder       := "cCodRut"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->cCodRut  + if( !Empty( ( D():Get( "Client", nView ) )->cCodRut ), " - ", "" ) + RetFld( ( D():Get( "Client", nView ) )->cCodRut, dbfRuta ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Última venta"
         :bEditValue       := {|| dtoc( dUltimaVentaCliente( ( D():Get( "Client", nView ) )->Cod, D():Get( "AlbCliT", nView ), D():Get( "FacCliT", nView ) ) ) } 
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() ) 
         :cHeader          := "Última llamada"
         :bEditValue       := {|| dtoc( ( D():Get( "Client", nView ) )->dLlaCli ) + space( 1 ) + ( D():Get( "Client", nView ) )->cTimCli } 
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := if( Empty( AllTrim( aIniCli[1] ) ), "Campo definido 1", AllTrim( aIniCli[1] ) )
         :cSortOrder       := "cUsrDef01"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->cUsrDef01 }
         :nWidth           := 120
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := if( Empty( AllTrim( aIniCli[2] ) ), "Campo definido 2", AllTrim( aIniCli[2] ) )
         :cSortOrder       := "cUsrDef02"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->cUsrDef02 }
         :nWidth           := 120
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := if( Empty( AllTrim( aIniCli[3] ) ), "Campo definido 3", AllTrim( aIniCli[3] ) )
         :cSortOrder       := "cUsrDef03"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->cUsrDef03 }
         :nWidth           := 120 
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :bEditValue       := {|| if( !Empty( ( D():Get( "Client", nView ) )->cAgente ), ( D():Get( "Client", nView ) )->cAgente + " - " + RetNbrAge( ( D():Get( "Client", nView ) )->cAgente, cAgente ), "" ) }
         :nWidth           := 200
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cod. Web"
          :bEditValue       := {|| AllTrim( Str( ( D():Get( "Client", nView ) )->cCodWeb ) ) }
         :nWidth           := 200
         :lHide            := .t.
      end with

      oWndBrw:cHtmlHelp    := "Clientes"

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecAdd() );
         ON DROP  ( oWndBrw:RecDup() );
         TOOLTIP  "(A)ñadir";
         BEGIN GROUP;
         HOTKEY   "A" ;
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecDup() );
         TOOLTIP  "(D)uplicar";
         HOTKEY   "D" ;
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdtRec, ( D():Get( "Client", nView ) ) ) );
         TOOLTIP  "(Z)oom";
         HOTKEY   "Z"

      DEFINE BTNSHELL oDel RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         HOTKEY   "E" ;
         LEVEL    ACC_DELE

         DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( TDelTarifasClientes():New() );
            TOOLTIP  "Eliminar tarifas" ;
            FROM     oDel ;
            CLOSED ;
            LEVEL    ACC_DELE

      #ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "Telephone_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( LlamadaAhora(), oWndBrw:Refresh() );
         TOOLTIP  "(L)lamada ahora";
         HOTKEY   "L" ;
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "INFO" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( BrwVtaCli( ( D():Get( "Client", nView ) )->Cod, ( D():Get( "Client", nView ) )->Titulo ) );
         TOOLTIP  "(I)nforme cliente" ;
         HOTKEY   "I" ;
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TInfCliGrp():New( "Listado de clientes" ):Play() ) ;
         TOOLTIP  "Lis(t)ado";
         HOTKEY   "T"

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TarCli():New( "Tarifas personalizadas por clientes" ):Play() ) ;
         TOOLTIP  "Listad(o) de tarifas";
         HOTKEY   "O"

      DEFINE BTNSHELL RESOURCE "Document_Chart_" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ReportingClient() ) ;
         TOOLTIP  "Rep(o)rting";
         HOTKEY   "O" ;
         LEVEL    ACC_IMPR

      #endif

      DEFINE BTNSHELL RESOURCE "RemoteControl_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TClienteLabelGenerator():Create() ) ;
         TOOLTIP  "Eti(q)uetas" ;
         HOTKEY   "Q"

      DEFINE BTNSHELL RESOURCE "Mail" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( TGenMailingClientes():New( nView ):Resource() ) ;
         TOOLTIP  "Enviar correos" ;
         HOTKEY   "V" ;
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL oSnd RESOURCE "Lbl" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         TOOLTIP  "En(v)iar" ;
         MESSAGE  "Seleccionar clientes para ser enviados" ;
         ACTION   lSndCli( oWndBrw ) ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Lbl" OF oWndBrw ;
            NOBORDER ;
            ACTION   lSndCli( oWndBrw, .t. ) ;
            TOOLTIP  "Seleccionar para envio" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Lbl" OF oWndBrw ;
            NOBORDER ;
            ACTION   lSndCli( oWndBrw, .f. ) ;
            TOOLTIP  "Deseleccionar para envio" ;
            FROM     oSnd ;
            CLOSED ;
            LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "BMPCONTA" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ChkAllSubCta() ) ;
         TOOLTIP  "Com(p)robar subcuentas" ;
         HOTKEY   "P";
         LEVEL    ACC_EDIT

      if oUser():lAdministrador()

         DEFINE BTNSHELL RESOURCE "CHGPRE" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( ChgPrc( oWndBrw ) ) ;
            TOOLTIP  "Cambiar precios" ;
            LEVEL    ACC_APPD

         DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
            NOBORDER ;
            MENU     This:Toggle() ;
            ACTION   ( ReplaceCreator( oWndBrw, ( D():Get( "Client", nView ) ), aItmCli(), CLI_TBL ) ) ;
            TOOLTIP  "Cambiar campos" ;
            LEVEL    ACC_APPD

            DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
               NOBORDER ;
               ACTION   ( ReplaceCreator( oWndBrw, ( D():Get( "CliAtp", nView ) ), aItmAtp() ) ) ;
               TOOLTIP  "Tarifa" ;
               FROM     oRpl ;
               CLOSED ;
               LEVEL    ACC_EDIT

      end if

      DEFINE BTNSHELL RESOURCE "CNFCLI" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( CnfCli( D():Get( "Client", nView ) ) ) ;
         TOOLTIP  "Confi(g)urar" ;
         HOTKEY   "G";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oRotor:Expand() ) ;
         TOOLTIP  "Rotor" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Notebook_user1_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( PreCli( nil, oWnd, ( D():Get( "Client", nView ) )->Cod, nil ) );
            TOOLTIP  "Añadir presupuesto de cliente" ;
            FROM     oRotor ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Clipboard_empty_user1_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( PedCli( nil, oWnd, ( D():Get( "Client", nView ) )->Cod, nil ) );
            TOOLTIP  "Añadir pedido de cliente" ;
            FROM     oRotor ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Document_plain_user1_" OF oWndBrw ;
            ACTION   ( appAlbCli( { "Cliente" => ( D():Get( "Client", nView ) )->Cod } ) );
            TOOLTIP  "Añadir albarán de cliente" ;
            FROM     oRotor ;
            LEVEL    ACC_EDIT

/*
         DEFINE BTNSHELL RESOURCE "Document_plain_user1_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( AlbCli( nil, oWnd, { "Cliente" => ( D():Get( "Client", nView ) )->Cod } ) );
            TOOLTIP  "Ir a albarán de cliente" ;
            FROM     oRotor ;
            LEVEL    ACC_EDIT*/

         DEFINE BTNSHELL RESOURCE "Document_user1_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( FactCli( nil, oWnd, { "Cliente" => ( D():Get( "Client", nView ) )->Cod } ) );
            TOOLTIP  "Añadir factura de cliente" ;
            FROM     oRotor ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "Cashier_user1_" OF oWndBrw ;
            ALLOW    EXIT ;
            ACTION   ( FrontTpv( nil, oWnd, ( D():Get( "Client", nView ) )->Cod, nil ) );
            TOOLTIP  "Añadir tiket de cliente" ;
            FROM     oRotor ;
            LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
         ALLOW    EXIT ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
         HOTKEY   "S"

      /*
      Datos para el filtro-----------------------------------------------------
      */

      oWndBrw:oActiveFilter:SetFields( aItmCli() )
      oWndBrw:oActiveFilter:SetFilterType( CLI_TBL )

      /*
      Abrimos la ventana-------------------------------------------------------
      */

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles( .t. ) )

      EnableAcceso()

   else

      oWndBrw:SetFocus()

   end if

Return ( .t. )

//----------------------------------------------------------------------------//

/*
Edita el cliente en el tactil
*/

STATIC FUNCTION EdtBig( aTmp, aGet, dbfCli, oBrw, bWhen, bValid, nMode )

   local oDlg
   local oBmpGeneral
   local cResource      := "BigEdtCliente"

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      aTmp[ _COD     ]  := NextKey( aTmp[ _COD ], ( D():Get( "Client", nView ) ), "0", RetNumCodCliEmp() )
      aTmp[ _LSNDINT ]  := .t.
      aTmp[ _LMODDAT ]  := .t.
      aTmp[ _LCHGPRE ]  := .t.
      aTmp[ _COPIASF ]  := 0
      aTmp[ _NLABEL  ]  := 1
      aTmp[ _NTARIFA ]  := 1
      aTmp[ _NTARCMB ]  := 1
   end case

   if GetSysMetrics( 1 ) == 560

      DEFINE DIALOG oDlg RESOURCE "BigEdtCliente_1024x576" TITLE ( LblTitle( nMode ) + "cliente" )

   else

      DEFINE DIALOG oDlg RESOURCE cResource TITLE ( LblTitle( nMode ) + "cliente" )

   end if

      REDEFINE BITMAP oBmpGeneral ;
        ID       500 ;
        RESOURCE "Businessman2_Alpha_48" ;
        TRANSPARENT ;
        OF       oDlg

      REDEFINE GET aGet[ _COD ] VAR aTmp[ _COD ] ;
         ID       100 ;
         PICTURE  ( Replicate( "X", RetNumCodCliEmp() ) );
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( aGet[ _COD ], ( D():Get( "Client", nView ) ), .t., "0", 1, RetNumCodCliEmp() ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ _TITULO ] VAR aTmp[ _TITULO ];
         ID       110 ;
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         ON CHANGE( ActTitle( nKey, nFlags, Self, nMode, oDlg ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( if( nMode == APPD_MODE, lValidNombre( aGet[_TITULO] ), .t. ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ _DOMICILIO ] VAR aTmp[ _DOMICILIO ];
         ID       120 ;
         ON HELP  GoogleMaps( aTmp[ _DOMICILIO ], Rtrim( aTmp[ _POBLACION ] ) + Space( 1 ) + Rtrim( aTmp[ _PROVINCIA ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _POBLACION ] VAR aTmp[ _POBLACION ];
         ID       130 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CODPOSTAL ] VAR aTmp[ _CODPOSTAL ] ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _TELEFONO ] VAR aTmp[ _TELEFONO ] ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( if( nMode == APPD_MODE, lValidTlf( aGet[_TELEFONO] ), .t. ) ) ;
         OF       oDlg

      if uFieldEmpresa( "nCifRut" ) <= 1

      REDEFINE GET aGet[ _NIF ] VAR aTmp[ _NIF ] ;
         ID       160 ;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( CheckCif( aGet[ _NIF ] ), if( nMode == APPD_MODE, lValidCif( aGet[ _NIF ] ), .t. ) );
         OF       oDlg

      else

      REDEFINE GET aGet[ _NIF ] VAR aTmp[ _NIF ] ;
         ID       160 ;
         PICTURE  "@R 999999999-9" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( CheckRut( aGet[ _NIF ] ), if( nMode == APPD_MODE, lValidCif( aGet[ _NIF ] ), .t. ) );
         OF       oDlg

      end if

      REDEFINE GET aGet[ _CMEIINT ] VAR aTmp[ _CMEIINT ] ;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         ON HELP  ( ShellExecute( oDlg:hWnd, "open", "mailto:" + Rtrim( aGet[ _CMEIINT ]:cText() ) ) ) ;
         UPDATE ;
         OF       oDlg

      REDEFINE GET aGet[ _MCOMENT ] VAR aTmp[ _MCOMENT ];
         ID       180 ;
         MEMO ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Botones de la Caja de Dialogo__________________________________________
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( SavClient( aTmp, aGet, oDlg, oBrw, nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| SavClient( aTmp, aGet, oDlg, oBrw, nMode ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

   oBmpGeneral:End()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
/*
Edita el cliente
*/

STATIC FUNCTION EdtRec( aTmp, aGet, dbf, oBrw, nTab, bValid, nMode )

   local oDlg
   local oFld
   local oGetSubCta
   local oGetSubDto
   local oBrwCta
   local oBrwObr
   local oBrwAtp
   local oBrwDoc
   local oBrwBnc
   local oBrwInc
   local oBrwCon
   local oBrwFacturae
   local oBrwFacAut
   local oBmpDiv
   local oGet
   local cColor
   local nImpRie        := 0
   local cTipCli
   local cTipRetencion
   local nSeaColor
   local oGetSalDto
   local nGetSalDto     := 0
   local oSay           := Array( 9 )
   local cSay           := Array( 9 )
   local oGetCta
   local cGetSubCta     := Space( 30 )
   local cGetSubDto     := Space( 30 )
   local cGetCta        := Space( 30 )
   local nGetDebe       := 0
   local nGetHaber      := 0
   local oGetSaldo
   local nGetSaldo      := 0
   local aStrColor      := { "Ninguno", "Verde", "Naranja", "Rojo" }
   local aResColor      := { "COLOR_00", "COLOR_01", "COLOR_02", "COLOR_03" }
   local aStrRetencion  := { "Ret. S/Base", "Ret. S/Total" }
   local aSexos         := { "", "Entidad", "Hombre", "Mujer" }
   local cSexo
   local aResClients    := { "Cli", "CliPot", "CliPot" }
   local aMes           := { "Ninguno", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre" }
   local oFiltroAtp
   local cFiltroAtp     := aIniCli[ 11 ]
   local aFiltroAtp     := { "Todas", "Activas" }
   local oZoom
   local cZoom          := "100%"
   local aZoom          := { "500%", "200%", "150%", "100%", "75%", "50%", "25%", "10%" }
   local oFuente
   local cFuente        := "Arial"
   local aFuente        := aGetFont( oWnd() )
   local oSize
   local cSize          := "10"
   local aSize          := { " 6", " 7", " 8", " 9", "10", "11", "12", "13", "14", "16", "18", "20", "22", "24", "26", "28", "36", "48", "72" }
   local oClp
   local oBtn           := Array( 17 )
   local aRatio         := { { 5, 1 }, { 2, 1 }, { 3, 2 }, { 1, 1 }, { 3, 4 }, { 1, 2 }, { 1, 4 }, { 1, 10 } }
   local oBmpGeneral
   local oBmpComercial
   local oBmpDirecciones
   local oBmpContactos
   local oBmpBancos
   local oBmpContabilidad
   local oBmpComentario
   local oBmpTarifa
   local oBmpDocumentos
   local oBmpIncidencias
   local oBmpObservaciones
   local oBmpAutomaticas
   local oBmpRecibos

   aFacAut              := hb_aTokens( aTmp[ _MFACAUT ], "," )

   aRgbColor            := { Rgb( 255, 255, 255 ), Rgb( 102, 204,  51 ), Rgb( 255, 204, 102 ), Rgb( 255,  51,   0 ) }

   nSeaColor            := aScan( aRgbColor, aTmp[ _NCOLOR ] )
   if nSeaColor != 0
      cColor            := aStrColor[ nSeaColor ]
   end if

   aDescuentosAtipicos  := {  "Base",;
                              if( !Empty( aTmp[ _CDTOESP ] ), aTmp[ _CDTOESP ], "General" ),;
                              if( !Empty( aTmp[ _CDPP    ] ), aTmp[ _CDPP    ], "Pronto pago" ),;
                              if( !Empty( aTmp[ _CDTOUNO ] ), aTmp[ _CDTOUNO ], "Definido 1" ),;
                              if( !Empty( aTmp[ _CDTODOS ] ), aTmp[ _CDTODOS ], "Definido 2" ) }

   /*
   Abrimos las bases de datos temporales si no estan abiertas------------------
   */

   if BeginTrans( aTmp, nMode )
      Return .f.
   end if

   do case
      case nMode == APPD_MODE
         aTmp[ _LSNDINT ]  := .t.
         aTmp[ _LMODDAT ]  := .t.
         aTmp[ _LCHGPRE ]  := .t.
         aTmp[ _COPIASF ]  := 0
         aTmp[ _NLABEL  ]  := 1
         aTmp[ _NTARIFA ]  := 1
         aTmp[ _NTARCMB ]  := 1
         aTmp[ _DLLACLI ]  := ctod( "" )

      case nMode == DUPL_MODE
         aTmp[ _COD ]      := NextKey( aTmp[ _COD ], ( D():Get( "Client", nView ) ), "0", RetNumCodCliEmp() )
         aTmp[ _DLLACLI ]  := ctod( "" )

      otherwise
         nImpRie           := oStock:nRiesgo( aTmp[ _COD ] )

   end case

   cPeriodoCli             := "Todos"
   cEstadoCli              := "Pendientes"
   aPeriodoCli             := aCreaArrayPeriodos()

   aTmp[ _NMESVAC ]        := aMes[ Min( Max( aTmp[ _NMESVAC ], 1 ), len( aMes ) ) ]

   cTipCli                 := aStrClients[ Min( Max( aTmp[ _NTIPCLI ], 1 ), len( aStrClients ) ) ]

   cTipRetencion           := aStrRetencion[ Min( Max( aTmp[ _NTIPRET ], 1 ), len( aStrRetencion ) ) ]

   cSexo                   := aSexos[ Min( Max( aTmp[ _NSEXO ], 1 ), len( aSexos ) ) ]

   if Empty( aTmp[ _CDTOESP ] )
      aTmp[ _CDTOESP ]     := Padr( "General", 50 )
   end if

   if Empty( aTmp[ _CDPP ] )
      aTmp[ _CDPP ]        := Padr( "Pronto pago", 50 )
   end if

   if Empty( aTmp[ _CDTOATP ] )
      aTmp[ _CDTOATP ]     := Padr( "Atipico", 50 )
   end if

   aTmp[ _CTIPINCI ]       := oUser():cTipoIncidencia()

   // Colocamos los filtros----------------------------------------------------

   ( D():Get( "FacCliP", nView ) )->( OrdScope( 0, aTmp[ _COD ] ) )
   ( D():Get( "FacCliP", nView ) )->( OrdScope( 1, aTmp[ _COD ] ) )

   // Dialogo------------------------------------------------------------------

   DEFINE DIALOG  oDlg ;
         RESOURCE "CLIENT" ;
         TITLE    LblTitle( nMode ) + "Cliente : " + Rtrim( aTmp[ _TITULO ] )

      REDEFINE FOLDER oFld ;
         ID       500 ;
         OF       oDlg ;
         PROMPT   "&General",;
                  "C&omercial",;
                  "Au&tomáticas",;
                  "&Direcciones",;
                  "&Bancos",;
                  "Co&ntabilidad",;
                  "Definidos",;
                  "&Tarifa",;
                  "Doc&umentos",;
                  "&Incidencias",;
                  "Ob&servaciones",;
                  "C&ontactos",;
                  "Facturae",;
                  "&Recibos" ;
         DIALOGS  "CLIENT_0"  ,;
                  "CLIENT_1"  ,;
                  "CLIENT_17" ,;
                  "CLIENT_15" ,;
                  "CLIENT_2"  ,;
                  "CLIENT_3"  ,;
                  "CLIENT_4"  ,;
                  "CLIENT_5"  ,;
                  "CLIENT_10" ,;
                  "CLIENT_12" ,;
                  "CLIENT_14" ,;
                  "CLIENT_16" ,;
                  "CLIENT_FACTURAE" ,;
                  "CLIENT_18"
      /*
      Primera pestaña----------------------------------------------------------
      */

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "Businessman2_Alpha_48" ;
         TRANSPARENT ;
         OF       fldGeneral

      REDEFINE GET oGet ;
         VAR      aTmp[ _COD ] ;
         ID       110 ;
         PICTURE  ( Replicate( "X", RetNumCodCliEmp() ) );
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         ON HELP  ( oGet:cText( NextKey( aTmp[ _COD ], ( D():Get( "Client", nView ) ), "0", RetNumCodCliEmp() ) ) ) ;
         BITMAP   "BOT" ;
         VALID    ( NotValid( oGet, ( D():Get( "Client", nView ) ), .t., "0", 1, RetNumCodCliEmp() ) ) ;
         OF       fldGeneral

      REDEFINE COMBOBOX aGet[ _NTIPCLI ] VAR cTipCli ;
         ID       105 ;
         ITEMS    aStrClients;
         BITMAPS  aResClients;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[_TITULO] VAR aTmp[_TITULO];
         ID       120 ;
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         ON CHANGE( ActTitle( nKey, nFlags, Self, nMode, oDlg ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( if( nMode == APPD_MODE, lValidNombre( aGet[_TITULO] ), .t. ) ) ;
         OF       fldGeneral

      if uFieldEmpresa( "nCifRut" ) <= 1

      REDEFINE GET aGet[ _NIF ] VAR aTmp[ _NIF ] ;
         ID       130 ;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( CheckCif( aGet[ _NIF ] ), if( nMode == APPD_MODE, lValidCif( aGet[ _NIF ] ), .t. ) );
         OF       fldGeneral

      else

      REDEFINE GET aGet[ _NIF ] VAR aTmp[ _NIF ] ;
         ID       130 ;
         PICTURE  "@R 999999999-9" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( CheckRut( aGet[ _NIF ] ), if( nMode == APPD_MODE, lValidCif( aGet[ _NIF ] ), .t. ) );
         OF       fldGeneral

      end if

      REDEFINE GET aGet[ _DOMICILIO ] VAR aTmp[ _DOMICILIO ];
         ID       140 ;
         BITMAP   "Environnment_View_16" ;
         ON HELP  GoogleMaps( aTmp[ _DOMICILIO ], Rtrim( aTmp[ _POBLACION ] ) + Space( 1 ) + Rtrim( aTmp[ _PROVINCIA ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CCODEDI ] VAR aTmp[ _CCODEDI ] ;
         ID       145 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _POBLACION ] VAR aTmp[ _POBLACION ];
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CODPOSTAL ] VAR aTmp[ _CODPOSTAL ] ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _PROVINCIA ] VAR aTmp[ _PROVINCIA ] ;
         ID       170 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CCODPAI ] VAR aTmp[ _CCODPAI ] ;
         ID       300 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oPais:GetPais( aTmp[ _CCODPAI ], oSay[ 6 ], oBmpDiv ) ) ;
         ON HELP  ( oPais:Buscar( aGet[ _CCODPAI ] ) ) ;
         BITMAP   "LUPA" ;
         OF       fldGeneral

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       301;
         OF       fldGeneral

      REDEFINE GET oSay[6] VAR cSay[6] ;
         ID       302 ;
         SPINNER ;
         WHEN     ( .f. ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CPERCTO ] ;
         VAR aTmp[ _CPERCTO ];
         ID       90 ;
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE COMBOBOX aGet[ _NCOLOR ] VAR cColor;
         ID       95;
         ITEMS    aStrColor;
         BITMAPS  aResColor;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[_TELEFONO] VAR aTmp[_TELEFONO] ;
         ID       180 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( if( nMode == APPD_MODE, lValidTlf( aGet[_TELEFONO] ), .t. ) ) ;
         OF       fldGeneral

      REDEFINE GET aGet[_FAX] VAR aTmp[_FAX] ;
         ID       190 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[_MOVIL] VAR aTmp[_MOVIL] ;
         ID       195 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _NTARIFA ] VAR aTmp[ _NTARIFA ] ;
         ID       100 ;
         PICTURE  "9" ;
         SPINNER ;
         MIN      1 ;
         MAX      6 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( lUsrMaster() .or. oUser():lCambiarPrecio() ) );
         VALID    ( aTmp[ _NTARIFA ] >= 1 .and. aTmp[ _NTARIFA ] <= 6 );
         OF       fldGeneral

      REDEFINE GET aGet[ _NTARCMB ] VAR aTmp[ _NTARCMB ] ;
         ID       102 ;
         PICTURE  "9" ;
         SPINNER ;
         MIN      1 ;
         MAX      6 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( lUsrMaster() .or. oUser():lCambiarPrecio() ) );
         VALID    ( aTmp[ _NTARCMB ] >= 1 .and. aTmp[ _NTARCMB ] <= 6 );
         OF       fldGeneral   

      REDEFINE GET aGet[ _NDTOART ] VAR aTmp[ _NDTOART ] ;
         ID       101 ;
         PICTURE  "9" ;
         SPINNER ;
         MIN      0 ;
         MAX      6 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( lUsrMaster() .or. oUser():lCambiarPrecio() ) );
         VALID    ( aTmp[ _NDTOART ] >= 0 .and. aTmp[ _NDTOART ] <= 6 );
         OF       fldGeneral

      REDEFINE GET aGet[_CCODTAR] VAR aTmp[_CCODTAR] ;
         ID       200 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE .and. oUser():lAdministrador() ) ;
         VALID    ( cTarifa( aGet[_CCODTAR], oSay[3] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTarifa( aGet[_CCODTAR], oSay[3] ) ) ;
         OF       fldGeneral

      REDEFINE GET oSay[3] VAR cSay[3] ;
         ID       201;
         COLOR    CLR_GET ;
         WHEN     ( .F. ) ;
         OF       fldGeneral

      REDEFINE GET aGet[_CODPAGO] VAR aTmp[_CODPAGO];
         ID       210 ;
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cFPago( aGet[_CODPAGO], dbfFPago, oSay[1] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[_CODPAGO ], oSay[1] ) );
         OF       fldGeneral

      REDEFINE GET oSay[1] VAR cSay[1];
         ID       211 ;
         WHEN     .F. ;
         OF       fldGeneral

      REDEFINE GET aGet[_DIAPAGO] VAR aTmp[_DIAPAGO] ;
         ID       232;
         PICTURE  "99" ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[_DIAPAGO2] VAR aTmp[_DIAPAGO2] ;
         ID       233;
         PICTURE  "99" ;
         SPINNER ;
         VALID    ( if( ( aTmp[_DIAPAGO2] != 0 .and. aTmp[_DIAPAGO2] <= aTmp[_DIAPAGO] ),;
                      ( msgStop( "Segundo día de pago debe ser mayor que el primero" ), .f. ),;
                      .t. ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CMEIINT ] VAR aTmp[ _CMEIINT ] ;
         ID       280 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  ( ShellExecute( oDlg:hWnd, "open", "mailto:" + Rtrim( aGet[ _CMEIINT ]:cText() ) ) ) ;
         BITMAP   "MAIL16" ;
         UPDATE ;
         OF       fldGeneral

      /*
      Codigo de Cuenta de Remesas______________________________________________
      */

      REDEFINE GET aGet[_CCODREM] VAR aTmp[_CCODREM] ;
         ID       320 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oCtaRem:lGetCtaRem( aGet[_CCODREM], oSay[8] ) ) ;
         ON HELP  ( oCtaRem:Buscar( aGet[_CCODREM] ) ) ;
         BITMAP   "LUPA" ;
         OF       fldGeneral

      REDEFINE GET oSay[8] VAR cSay[8] ;
         WHEN     .F. ;
         ID       321 ;
         OF       fldGeneral

      REDEFINE GET aGet[_CCODRUT] VAR aTmp[_CCODRUT] ;
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cRuta( aGet[_CCODRUT], nil, oSay[4] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwRuta( aGet[_CCODRUT], nil, oSay[4] ) ) ;
         COLOR    CLR_GET ;
         OF       fldGeneral

      REDEFINE GET oSay[4] VAR cSay[4] ;
         ID       221 ;
         WHEN     ( .f. ) ;
         COLOR    CLR_GET ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CAGENTE ] VAR aTmp[ _CAGENTE ] ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cAgentes( aGet[ _CAGENTE ], , oSay[2] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CAGENTE ], oSay[2] ) ) ;
         OF       fldGeneral

      REDEFINE GET oSay[2] VAR cSay[2] ;
         ID       231 ;
         COLOR    CLR_GET ;
         WHEN     ( .F. ) ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CCODGRP ] VAR aTmp[ _CCODGRP ] ;
         ID       240 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oGrpCli:Existe( aGet[ _CCODGRP ], oSay[ 5 ], "cNomGrp", .t., .t., "0" ) );
         ON HELP  ( oGrpCli:Buscar( aGet[ _CCODGRP ] ) ) ;
         BITMAP   "LUPA" ;
         OF       fldGeneral

      REDEFINE GET oSay[5] VAR cSay[5] ;
         ID       241 ;
         SPINNER ;
         WHEN     ( .f. ) ;
         COLOR    CLR_GET ;
         OF       fldGeneral

      /*
      Codigo de Almacen______________________________________________________________
      */

      REDEFINE GET aGet[ _CCODALM ] VAR aTmp[ _CCODALM ] ;
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[ _CCODALM ], dbfAlmT, oSay[7] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CCODALM ], oSay[7] ) ) ;
         COLOR    CLR_GET ;
         OF       fldGeneral

      REDEFINE GET oSay[ 7 ] VAR cSay[ 7 ] ;
         WHEN     .F. ;
         ID       311 ;
         OF       fldGeneral

      /*
      Propiedades--------------------------------------------------------------
      */

      REDEFINE GET aGet[ _SERIE ] VAR aTmp[ _SERIE ] ;
         ID       260 ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _SERIE ] ) );
         ON DOWN  ( DwSerie( aGet[ _SERIE ] ) );
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE );
         VALID    ( Empty( aTmp[ _SERIE ] ) .or. ( aTmp[ _SERIE ] >= "A" .and. aTmp[ _SERIE ] <= "Z" ) );
         OF       fldGeneral

      REDEFINE GET aTmp[ _COPIASF ] ;
         ID       270 ;
         SPINNER ;
         MIN      0;
         MAX      9;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "9" ;
         OF       fldGeneral

      REDEFINE CHECKBOX aTmp[ _LPNTVER ] ;
         ID       157 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE CHECKBOX aTmp[ _LTOTALB ] ;
         ID       156 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE CHECKBOX aTmp[ _LMODDAT ] ;
         ID       158 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      REDEFINE CHECKBOX aTmp[ _LMAIL ] ;
         ID       159 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldGeneral

      /*
      Transportistas-----------------------------------------------------------
      */

      REDEFINE GET aGet[ _CCODTRN ] VAR aTmp[ _CCODTRN ] ;
         ID       315 ;
         IDTEXT   316 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "Lupa" ;
         OF       fldGeneral

      aGet[ _CCODTRN ]:bValid := {|| oTrans:Existe( aGet[ _CCODTRN ], aGet[ _CCODTRN ]:oHelpText ) }
      aGet[ _CCODTRN ]:bHelp  := {|| oTrans:Buscar( aGet[ _CCODTRN ] ) }

      /*
      Segunda Caja de Dialogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpComercial ;
         ID       500 ;
         RESOURCE "Address_book2_Alpha_48" ;
         TRANSPARENT ;
         OF       fldComercial

      // oBmpGeneral:nAlphaLevel := 0

      REDEFINE GET aGet[_NBREST] VAR aTmp[_NBREST];
         ID       100 ;
         PICTURE  "@!" ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE GET aGet[_DIREST] VAR aTmp[_DIREST] ;
         ID       110 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      /*
      INTERNET_________________________________________________________________
      */

      REDEFINE GET aGet[ _CWEBINT ] VAR aTmp[ _CWEBINT ] ;
         ID       290 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       fldComercial

      REDEFINE CHECKBOX aTmp[ _LPUBINT ] ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( lPubInt( nMode, aTmp ) ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _CCLAVE ] VAR aTmp[ _CCLAVE ] ;
         ID       410 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      /*
      impuestos----------------------------------------------------------------------
      */

      REDEFINE RADIO aGet[ _NREGIVA ] ;
         VAR      aTmp[ _NREGIVA ] ;
         ID       240,;
                  241,;
                  242,;
                  243 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE CHECKBOX aTmp[_LREQ] ;
         ID       130 ;
         WHEN     ( aTmp[_NREGIVA] == 1 .AND. nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE CHECKBOX aTmp[ _LCHGPRE ] ;
         ID       140 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE .and. !aTmp[ _LBLQCLI ] ) ;
         OF       fldComercial

      REDEFINE CHECKBOX aTmp[ _LCRESOL ] ;
         ID       145 ;
         WHEN     ( oUser():lAdministrador() .and. aTmp[ _LCHGPRE ] .and. nMode != ZOOM_MODE .and. !aTmp[ _LBLQCLI ] ) ;
         OF       fldComercial

      REDEFINE GET aTmp[ _RIESGO ] ;
         ID       250 ;
         PICTURE  cPorDiv ;
         WHEN     ( oUser():lAdministrador() .and. aTmp[ _LCHGPRE ] .and. nMode != ZOOM_MODE .and. !aTmp[ _LBLQCLI ] ) ;
         OF       fldComercial

      REDEFINE GET nImpRie ;
         ID       251 ;
         PICTURE  cPorDiv ;
         OF       fldComercial

      /*
      Descuentos---------------------------------------------------------------
      */

      REDEFINE GET aGet[ _CDTOESP ] VAR aTmp[ _CDTOESP ] ;
         SPINNER ;
         ID       159;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lRecargaArray( aGet, aTmp ) ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _NDTOESP ] VAR aTmp[ _NDTOESP ] ;
         SPINNER ;
         ID       160;
         PICTURE  "@E 999.99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _CDPP ] VAR aTmp[ _CDPP ] ;
         SPINNER ;
         ID       169;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lRecargaArray( aGet, aTmp ) ) ;
         OF       fldComercial

      REDEFINE GET aGet[_NDPP] VAR aTmp[_NDPP] ;
         SPINNER ;
         ID       170;
         COLOR    CLR_GET ;
         PICTURE  "@E 999.99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _CDTOUNO ] VAR aTmp[ _CDTOUNO ] ;
         SPINNER ;
         ID       175;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lRecargaArray( aGet, aTmp ) ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _NDTOCNT ] VAR aTmp[ _NDTOCNT ];
         SPINNER ;
         ID       180 ;
         PICTURE  "@E 999.99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _CDTODOS ] VAR aTmp[ _CDTODOS ] ;
         SPINNER ;
         ID       185;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lRecargaArray( aGet, aTmp ) ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _CDTOATP ] VAR aTmp[ _CDTOATP ] ;
         SPINNER ;
         ID       205;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _NDTORAP ] VAR aTmp[ _NDTORAP ];
         SPINNER ;
         ID       190 ;
         PICTURE  "@E 999.99" ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _NDTOATP ] VAR aTmp[ _NDTOATP ];
         SPINNER ;
         ID       200 ;
         PICTURE  "@E 999.99" ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE COMBOBOX aGet[ _NSBRATP ] ;
         VAR      aTmp[ _NSBRATP ] ;
         ITEMS    aDescuentosAtipicos ;
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE CHECKBOX aGet[ _LBLQCLI ] VAR aTmp[ _LBLQCLI ] ;
         ID       155 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ _LBLQCLI ], aGet[ _DFECBLQ ]:cText( GetSysDate() ), ( aGet[ _DFECBLQ ]:cText( Ctod("") ), aGet[ _CMOTBLQ ]:cText( Space(50) ) ) ) );
         OF       fldComercial

      REDEFINE GET aGet[ _DFECBLQ ] VAR aTmp[ _DFECBLQ ];
         ID       156 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE .and. aTmp[ _LBLQCLI ] );
         SPINNER;
         OF       fldComercial

      REDEFINE GET aGet[ _CMOTBLQ ] VAR aTmp[ _CMOTBLQ ];
         ID       157 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE .and. aTmp[ _LBLQCLI ] );
         OF       fldComercial

      REDEFINE CHECKBOX aTmp[_LVISLUN] ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE CHECKBOX aTmp[_LVISMAR] ;
         ID       231 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE CHECKBOX aTmp[_LVISMIE] ;
         ID       232 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE CHECKBOX aTmp[_LVISJUE] ;
         ID       233 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE CHECKBOX aTmp[_LVISVIE] ;
         ID       234 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE CHECKBOX aTmp[_LVISSAB] ;
         ID       235 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE CHECKBOX aTmp[_LVISDOM] ;
         ID       236 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _NVISLUN ] ;
         VAR      aTmp[ _NVISLUN ] ;
         ID       330 ;
         SPINNER ;
         MIN      1 ;
         MAX      999 ;
         PICTURE  "999" ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISLUN ] );
         OF       fldComercial

      REDEFINE GET aGet[ _NVISMAR ] ;
         VAR      aTmp[ _NVISMAR ] ;
         ID       331 ;
         SPINNER ;
         MIN      1 ;
         MAX      999 ;
         PICTURE  "999" ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISMAR ] );
         OF       fldComercial

      REDEFINE GET aGet[ _NVISMIE ] ;
         VAR      aTmp[ _NVISMIE ] ;
         ID       332 ;
         SPINNER ;
         MIN      1 ;
         MAX      999 ;
         PICTURE  "999" ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISMIE ] );
         OF       fldComercial

      REDEFINE GET aGet[ _NVISJUE ] ;
         VAR      aTmp[ _NVISJUE ] ;
         ID       333 ;
         SPINNER ;
         MIN      1 ;
         MAX      999 ;
         PICTURE  "999" ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISJUE ] );
         OF       fldComercial

      REDEFINE GET aGet[ _NVISVIE ] ;
         VAR      aTmp[ _NVISVIE ] ;
         ID       334 ;
         SPINNER ;
         MIN      1 ;
         MAX      999 ;
         PICTURE  "999" ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISVIE ] );
         OF       fldComercial

      REDEFINE GET aGet[ _NVISSAB ] ;
         VAR      aTmp[ _NVISSAB ] ;
         ID       335 ;
         SPINNER ;
         MIN      1 ;
         MAX      999 ;
         PICTURE  "999" ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISSAB ] );
         OF       fldComercial

      REDEFINE GET aGet[ _NVISDOM ] ;
         VAR      aTmp[ _NVISDOM ] ;
         ID       336 ;
         SPINNER ;
         MIN      1 ;
         MAX      999 ;
         PICTURE  "999" ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISDOM ] );
         OF       fldComercial

      REDEFINE GET aGet[ _CAGELUN ] VAR aTmp[ _CAGELUN ] ;
         ID       430 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISLUN ] );
         VALID    ( cAgentes( aGet[ _CAGELUN ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CAGELUN ] ) ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _CAGEMAR ] VAR aTmp[ _CAGEMAR ] ;
         ID       431 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISMAR ] );
         VALID    ( cAgentes( aGet[ _CAGEMAR ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CAGEMAR ] ) ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _CAGEMIE ] VAR aTmp[ _CAGEMIE ] ;
         ID       432 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISMIE ] );
         VALID    ( cAgentes( aGet[ _CAGEMIE ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CAGEMIE ] ) ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _CAGEJUE ] VAR aTmp[ _CAGEJUE ] ;
         ID       433 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISJUE ] );
         VALID    ( cAgentes( aGet[ _CAGEJUE ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CAGEJUE ] ) ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _CAGEVIE ] VAR aTmp[ _CAGEVIE ] ;
         ID       434 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISVIE ] );
         VALID    ( cAgentes( aGet[ _CAGEVIE ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CAGEVIE ] ) ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _CAGESAB ] VAR aTmp[ _CAGESAB ] ;
         ID       435 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISSAB ] );
         VALID    ( cAgentes( aGet[ _CAGESAB ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CAGESAB ] ) ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _CAGEDOM ] VAR aTmp[ _CAGEDOM ] ;
         ID       436 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _LVISDOM ] );
         VALID    ( cAgentes( aGet[ _CAGEDOM ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CAGEDOM ] ) ) ;
         OF       fldComercial

      REDEFINE COMBOBOX aGet[ _NMESVAC ] ;
         VAR      aTmp[ _NMESVAC ];
         ITEMS    aMes ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE COMBOBOX aGet[ _NTIPRET ] ;
         VAR      cTipRetencion ;
         ITEMS    aStrRetencion ;
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _NPCTRET ] ;
         VAR      aTmp[ _NPCTRET ] ;
         ID       320 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       fldComercial

      REDEFINE CHECKBOX aTmp[ _LEXCFID ] ;
         ID       158 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      // Ultima llamada--------------------------------------------------------

      REDEFINE GET aGet[ _DLLACLI ] ; 
         VAR      aTmp[ _DLLACLI ] ;
         ID       600 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      REDEFINE GET aGet[ _CTIMCLI ] ; 
         VAR      aTmp[ _CTIMCLI ] ;
         ID       601 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldComercial

      TBtnBmp():ReDefine( 602, "Recycle_16",,,,,{|| LlamadaAhora( aGet ) }, fldComercial, .f., , .f.,  )               

      /*
      Tercera pestaña----------------------------------------------------------
      */

      REDEFINE BITMAP oBmpAutomaticas ;
         ID       500 ;
         RESOURCE "Document_Gear_48_alpha" ;
         TRANSPARENT ;
         OF       fldAutomaticas

      REDEFINE BUTTON  ;
         ID       501 ;
         OF       fldAutomaticas ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( AddFacAut( oBrwFacAut ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldAutomaticas ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( oFacAut:ExternalEdit( if( Len( aFacAut ) > 0, aFacAut[ oBrwFacAut:nArrayAt ], "" ) ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldAutomaticas ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DelFacAut( oBrwFacAut ) )

      oBrwFacAut                        := IXBrowse():New( fldAutomaticas )

      oBrwFacAut:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwFacAut:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwFacAut:SetArray( aFacAut, , , .f. )

      oBrwFacAut:nMarqueeStyle          := 5

      oBrwFacAut:CreateFromResource( 400 )

      with object ( oBrwFacAut:AddCol() )
         :cHeader          := "Código"
         :bStrData         := {|| if( Len( aFacAut ) > 0, aFacAut[ oBrwFacAut:nArrayAt ], "" ) }
         :nWidth           := 75
      end with

      with object ( oBrwFacAut:AddCol() )
         :cHeader          := "Nombre"
         :bStrData         := {|| if( Len( aFacAut ) > 0, RetFld( aFacAut[ oBrwFacAut:nArrayAt ], oFacAut:oDbf:cAlias, "cNomFac" ), "" ) }
         :nWidth           := 565
      end with

      /*
      Cuarta pestaña-----------------------------------------------------------
      */

      REDEFINE BITMAP oBmpDirecciones ;
         ID       600 ;
         RESOURCE "Signpost_Alpha_48" ;
         TRANSPARENT ;
         OF       fldDirecciones

      REDEFINE BUTTON  ;
         ID       500 ;
         OF       fldDirecciones ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( AppObras( aTmp[ _COD ], dbfTmpObr, oBrwObr ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       fldDirecciones ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EdtObras( aTmp[ _COD ], nil, dbfTmpObr, oBrwObr, .t. ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldDirecciones ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DelObras( dbfTmpObr, oBrwObr ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldDirecciones ;
         ACTION   ( ZoomObras( dbfTmpObr, oBrwObr ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       fldDirecciones ;
         ACTION   ( PredObras( dbfTmpObr, oBrwObr ) )

      oBrwObr                 := IXBrowse():New( fldDirecciones )

      oBrwObr:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwObr:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwObr:cAlias          := dbfTmpObr
      oBrwObr:nMarqueeStyle   := 5
      oBrwObr:cName           := "Clientes.Obras"

       with object ( oBrwObr:AddCol() )
         :cHeader          := "Defecto"
         :bEditValue       := {|| ( dbfTmpObr )->lDefObr }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwObr:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( dbfTmpObr )->cCodObr }
         :nWidth           := 60
      end with

      with object ( oBrwObr:AddCol() )
         :cHeader          := "Nombre domicilio"
         :bEditValue       := {|| ( dbfTmpObr )->cNomObr }
         :nWidth           := 120
      end with

      with object ( oBrwObr:AddCol() )
         :cHeader          := "Domicilio"
         :bEditValue       := {|| ( dbfTmpObr )->cDirObr }
         :nWidth           := 120
      end with

      with object ( oBrwObr:AddCol() )
         :cHeader          := "Población"
         :bEditValue       := {|| ( dbfTmpObr )->cPobObr }
         :nWidth           := 100
      end with

      with object ( oBrwObr:AddCol() )
         :cHeader          := "Código postal"
         :bEditValue       := {|| ( dbfTmpObr )->cPosObr }
         :nWidth           := 60
      end with

      with object ( oBrwObr:AddCol() )
         :cHeader          := "Provincia"
         :bEditValue       := {|| ( dbfTmpObr )->cPrvObr }
         :nWidth           := 80
      end with

      with object ( oBrwObr:AddCol() )
         :cHeader          := "Teléfono"
         :bEditValue       := {|| ( dbfTmpObr )->cTelObr }
         :nWidth           := 80
      end with

      with object ( oBrwObr:AddCol() )
         :cHeader          := "Fax"
         :bEditValue       := {|| ( dbfTmpObr )->cFaxObr }
         :nWidth           := 80
      end with

      oBrwObr:bRClicked       := {| nRow, nCol, nFlags | oBrwObr:RButtonDown( nRow, nCol, nFlags ) }
      if nMode != ZOOM_MODE
         oBrwObr:bLDblClick   := {|| EdtObras( aTmp[ _COD ], nil, dbfTmpObr, oBrwObr, .t. ) }
      end if

      oBrwObr:CreateFromResource( 400 )

      /*
      Pestaña de contactos-----------------------------------------------------
      */
      
      REDEFINE BITMAP oBmpContactos ;
         ID       600 ;
         RESOURCE "User_mobilephone_Alpha_48" ;
         TRANSPARENT ;
         OF       fldContactos

      REDEFINE BUTTON  ;
         ID       500 ;
         OF       fldContactos ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( AppContactos( aTmp[ _COD ], dbfTmpCon, oBrwCon ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       fldContactos ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EdtContactos( dbfTmpCon, oBrwCon ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldContactos ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DelContactos( dbfTmpCon, oBrwCon ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldContactos ;
         ACTION   ( ZoomContactos( dbfTmpCon, oBrwCon ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       fldContactos ;
         ACTION   ( LlamadaContactos( dbfTmpCon, oBrwCon ) )

      oBrwCon                 := IXBrowse():New( fldContactos )

      oBrwCon:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwCon:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwCon:cAlias          := dbfTmpCon
      oBrwCon:nMarqueeStyle   := 5
      oBrwCon:cName           := "Clientes.Contactos"

      with object ( oBrwCon:AddCol() )
         :cHeader             := "Nombre"
         :cSortOrder          := "cNomCon"
         :bEditValue          := {|| ( dbfTmpCon )->cNomCon }
         :nWidth              := 120
      end with

      with object ( oBrwCon:AddCol() )
         :cHeader             := "Domicilio"
         :bEditValue          := {|| ( dbfTmpCon )->cDirCon }
         :nWidth              := 120
      end with

      with object ( oBrwCon:AddCol() )
         :cHeader             := "Población"
         :bEditValue          := {|| ( dbfTmpCon )->cPobCon }
         :nWidth              := 100
      end with

      with object ( oBrwCon:AddCol() )
         :cHeader             := "Código postal"
         :bEditValue          := {|| ( dbfTmpCon )->cPosCon }
         :nWidth              := 60
      end with

      with object ( oBrwCon:AddCol() )
         :cHeader             := "Provincia"
         :bEditValue          := {|| ( dbfTmpCon )->cPrvCon }
         :nWidth              := 100
      end with

      with object ( oBrwCon:AddCol() )
         :cHeader             := "Teléfono"
         :bEditValue          := {|| ( dbfTmpCon )->cTelCon }
         :nWidth              := 80
      end with

      with object ( oBrwCon:AddCol() )
         :cHeader             := "Movil"
         :bEditValue          := {|| ( dbfTmpCon )->cMovCon }
         :nWidth              := 80
      end with

      with object ( oBrwCon:AddCol() )
         :cHeader             := "Fax"
         :lHide               := .t.
         :bEditValue          := {|| ( dbfTmpCon )->cFaxCon }
         :nWidth              := 80
      end with

      with object ( oBrwCon:AddCol() )
         :cHeader             := "Email"
         :bEditValue          := {|| ( dbfTmpCon )->cMaiCon }
         :nWidth              := 120
      end with

      with object ( oBrwCon:AddCol() )
         :cHeader             := "Última llamada"
         :bEditValue          := {|| dtoc( ( dbfTmpCon )->dLlaCon ) + space( 1 ) + ( dbfTmpCon )->cTimCon }
         :nWidth              := 100
      end with

      oBrwCon:bRClicked       := {| nRow, nCol, nFlags | oBrwCon:RButtonDown( nRow, nCol, nFlags ) }

      if nMode != ZOOM_MODE
         oBrwCon:bLDblClick   := {|| EdtContactos( dbfTmpCon, oBrwCon ) }
      end if

      oBrwCon:CreateFromResource( 400 )

      /*
      Pestaña de facturae-----------------------------------------------------
      */
      
      REDEFINE BITMAP oBmpContactos ;
         ID       600 ;
         RESOURCE "User_mobilephone_Alpha_48" ;
         TRANSPARENT ;
         OF       fldFacturae

      REDEFINE BUTTON  ;
         ID       500 ;
         OF       fldFacturae ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( msgAlert( "dploy") )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       fldFacturae ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( msgAlert( "dploy") )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldFacturae ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( msgAlert( "dploy") )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldFacturae ;
         ACTION   ( msgAlert( "dploy") )

      oBrwFacturae                  := IXBrowse():New( fldFacturae )

      oBrwFacturae:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwFacturae:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwFacturae:cAlias           := dbfTmpFacturae
      oBrwFacturae:nMarqueeStyle    := 5
      oBrwFacturae:cName            := "Clientes.Facturae"

      with object ( oBrwFacturae:AddCol() )
         :cHeader                   := "Oficina contable"
         :bEditValue                := {|| ( dbfTmpFacturae )->cOfiCnt }
         :nWidth                    := 120
      end with

      oBrwFacturae:bRClicked        := {| nRow, nCol, nFlags | oBrwFacturae:RButtonDown( nRow, nCol, nFlags ) }

      if nMode != ZOOM_MODE
         oBrwFacturae:bLDblClick    := {|| EdtContactos( dbfTmpCon, oBrwFacturae ) }
      end if

      oBrwFacturae:CreateFromResource( 400 )

      /*
      Tercera pestaña----------------------------------------------------------
      */

      REDEFINE BITMAP oBmpBancos ;
         ID       500 ;
         RESOURCE "Money_Alpha_48" ;
         TRANSPARENT ;
         OF       fldBancos

      REDEFINE BUTTON ;
         ID       101 ;
         OF       fldBancos ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwBnc, bEdtBnc, dbfTmpBnc, aTmp, , aTmp[ _COD ] ) )

      REDEFINE BUTTON ;
         ID       102 ;
         OF       fldBancos ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwBnc, bEdtBnc, dbfTmpBnc, aTmp, , aTmp[ _COD ] ) )

      REDEFINE BUTTON ;
         ID       103 ;
         OF       fldBancos ;
         ACTION   ( WinZooRec( oBrwBnc, bEdtBnc, dbfTmpBnc ) )

      REDEFINE BUTTON ;
         ID       104 ;
         OF       fldBancos ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DelBnc( aTmp, oBrwBnc, dbfTmpBnc ) )

      oBrwBnc                 := IXBrowse():New( fldBancos )

      oBrwBnc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwBnc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwBnc:cAlias          := dbfTmpBnc
      oBrwBnc:nMarqueeStyle   := 5
      oBrwBnc:cName           := "Clientes.Bancos"

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "D. Banco por defecto"
         :bEditValue       := {|| ( dbfTmpBnc )->lBncDef }
         :nWidth           := 16
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Nombre banco"
         :bEditValue       := {|| ( dbfTmpBnc )->cCodBnc }
         :nWidth           := 180
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Cuenta"
         :bEditValue       := {|| PictureCuentaIBAN( dbfTmpBnc ) }
         :nWidth           := 180
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Domicilio"
         :bEditValue       := {|| ( dbfTmpBnc )->cDirBnc }
         :nWidth           := 120
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Población"
         :bEditValue       := {|| ( dbfTmpBnc )->cPobBnc }
         :nWidth           := 100
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Código postal"
         :bEditValue       := {|| ( dbfTmpBnc )->cCPBnc }
         :nWidth           := 40
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Provincia"
         :bEditValue       := {|| ( dbfTmpBnc )->cProBnc }
         :nWidth           := 80
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Teléfono"
         :bEditValue       := {|| ( dbfTmpBnc )->cTlfBnc }
         :nWidth           := 80
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Fax"
         :bEditValue       := {|| ( dbfTmpBnc )->cFaxBnc }
         :nWidth           := 80
      end with

      with object ( oBrwBnc:AddCol() )
         :cHeader          := "Contacto"
         :bEditValue       := {|| ( dbfTmpBnc )->cPContBnc }
         :nWidth           := 140
      end with

      oBrwBnc:bRClicked       := {| nRow, nCol, nFlags | oBrwBnc:RButtonDown( nRow, nCol, nFlags ) }
      if nMode != ZOOM_MODE
         oBrwBnc:bLDblClick   := {|| WinEdtRec( oBrwBnc, bEdtBnc, dbfTmpBnc, aTmp, , aTmp[_COD] ) }
      end if

      oBrwBnc:CreateFromResource( 100 )

      /*
      Quinta caja de dialogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpContabilidad ;
         ID       500 ;
         RESOURCE "Folder2_red_Alpha_48" ;
         TRANSPARENT ;
         OF       fldContabilidad

      REDEFINE GET aGet[ _SUBCTA ] VAR aTmp[ _SUBCTA ] ;
         ID       350 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "Lupa" ;
         ON HELP  ( BrwChkSubcuenta( aGet[_SUBCTA], oGetSubCta ) ) ;
         VALID    ( MkSubcuenta(  aGet[ _SUBCTA ],;
                               {  aTmp[ _SUBCTA    ],;
                                  aTmp[ _TITULO    ],;
                                  aTmp[ _NIF       ],;
                                  aTmp[ _DOMICILIO ],;
                                  aTmp[ _POBLACION ],;
                                  aTmp[ _PROVINCIA ],;
                                  aTmp[ _CODPOSTAL ],;
                                  aTmp[ _TELEFONO  ],;
                                  aTmp[ _FAX       ],;
                                  aTmp[ _CMEIINT   ] },;
                               oGetSubCta,;
                               nil,;
                               nil,;
                               @nGetDebe,;
                               @nGetHaber,;
                               oGetSaldo ) );
         OF       fldContabilidad

      REDEFINE GET oGetSubCta VAR cGetSubCta ;
         ID       351 ;
         WHEN     .f. ;
         OF       fldContabilidad

      REDEFINE GET oGetSaldo VAR nGetSaldo ;
         ID       352 ;
         PICTURE  cPorDiv ;
         WHEN     .f. ;
         OF       fldContabilidad

      REDEFINE GET aGet[_CTAVENTA] VAR aTmp[_CTAVENTA] ;
         ID       360 ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkCta( aGet[_CTAVENTA], oGetCta ) ) ;
         VALID    ( ChkCta( aTmp[_CTAVENTA], oGetCta ) ) ;
         OF       fldContabilidad

      REDEFINE GET oGetCta VAR cGetCta ;
         ID       361 ;
         WHEN     .f. ;
         OF       fldContabilidad

      /*
      Subcuenta dto -----------------------------------------------------------
      */

      REDEFINE GET aGet[_SUBCTADTO] VAR aTmp[_SUBCTADTO] ;
         ID       370 ;
         COLOR    CLR_GET ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[_SUBCTADTO], oGetSubDto ) ) ;
         VALID    ( MkSubcuenta( aGet[ _SUBCTADTO ],;
                              {  aTmp[ _SUBCTADTO ],;
                                 aTmp[ _TITULO    ],;
                                 aTmp[ _NIF       ],;
                                 aTmp[ _DOMICILIO ],;
                                 aTmp[ _POBLACION ],;
                                 aTmp[ _PROVINCIA ],;
                                 aTmp[ _CODPOSTAL ],;
                                 aTmp[ _TELEFONO  ],;
                                 aTmp[ _FAX       ],;
                                 aTmp[ _CMEIINT   ] },;
                              oGetSubDto,;
                              nil,;
                              nil,;
                              nil,;
                              nil,;
                              oGetSalDto ) );
         OF       fldContabilidad

      REDEFINE GET oGetSubDto VAR cGetSubDto ;
         ID       371 ;
         WHEN     .F. ;
         OF       fldContabilidad

      REDEFINE GET oGetSalDto VAR nGetSalDto ;
         ID       372 ;
         PICTURE  cPorDiv ;
         WHEN     .F. ;
         OF       fldContabilidad

      /*
      Diario de la subcuenta---------------------------------------------------
      */

      oBrwCta                 := IXBrowse():New( fldContabilidad )

      oBrwCta:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwCta:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwCta:cAlias          := dbfTmpSubCta
      oBrwCta:nMarqueeStyle   := 5
      oBrwCta:cName           := "Clientes.Contabilidad"
      oBrwCta:lFooter         := .t.

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Asiento"
         :bEditValue       := {|| Trans( ( dbfTmpSubCta )->nAsiento, "9999999" ) }
         :nWidth           := 80
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| Dtoc( ( dbfTmpSubCta )->dFecha ) }
         :nWidth           := 80
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Concepto"
         :bEditValue       := {|| ( dbfTmpSubCta )->cConcepto }
         :nWidth           := 180
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Debe"
         :bEditValue       := {|| ( dbfTmpSubCta )->nDebe }
         :bFooter          := {|| nGetDebe }
         :cEditPicture     := cPorDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Haber"
         :bEditValue       := {|| ( dbfTmpSubCta )->nHaber }
         :bFooter          := {|| nGetHaber }
         :cEditPicture     := cPorDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Departamento"
         :bEditValue       := {|| ( dbfTmpSubCta )->cDeparta }
         :nWidth           := 80
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Factura"
         :bEditValue       := {|| Trans( ( dbfTmpSubCta )->nFactura, "99999999" ) }
         :nWidth           := 80
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( dbfTmpSubCta )->nBase }
         :cEditPicture     := cPorDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwCta:AddCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( dbfTmpSubCta )->nIva }
         :cEditPicture     := cPorDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      oBrwCta:bRClicked    := {| nRow, nCol, nFlags | oBrwCta:RButtonDown( nRow, nCol, nFlags ) }

      oBrwCta:CreateFromResource( 400 )

      /*
      Tercera caja de dialogo_______________________________________________
      */

      REDEFINE BITMAP oBmpComentario ;
         ID       500 ;
         RESOURCE "Message_Alpha_48" ;
         TRANSPARENT ;
         OF       fldDefinidos

      REDEFINE GET aGet[ _DFECNACI ] VAR aTmp[ _DFECNACI ];
         ID       450 ;
         WHEN     ( nMode != ZOOM_MODE );  
         SPINNER;
         OF       fldDefinidos   

      REDEFINE COMBOBOX aGet[ _NSEXO ] ;
         VAR      cSexo ;
         ITEMS    aSexos ;
         ID       460 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldDefinidos   

      REDEFINE GET aGet[ _MCOMENT ] VAR aTmp[ _MCOMENT ];
         ID       370 ;
         MEMO ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldDefinidos

      REDEFINE CHECKBOX aTmp[ _LMOSCOM ] ;
         ID       380 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       fldDefinidos

      REDEFINE SAY PROMPT aIniCli[1] ;
         ID       105 ;
         OF       fldDefinidos

      REDEFINE GET aGet[ _CUSRDEF01 ] VAR aTmp[ _CUSRDEF01 ] ;
         ID       110 ;
         OF       fldDefinidos

      REDEFINE SAY PROMPT aIniCli[2] ;
         ID       115 ;
         OF       fldDefinidos

      REDEFINE GET aGet[ _CUSRDEF02 ] VAR aTmp[ _CUSRDEF02 ] ;
         ID       120 ;
         OF       fldDefinidos

      REDEFINE SAY PROMPT aIniCli[3] ;
         ID       125 ;
         OF       fldDefinidos

      REDEFINE GET aGet[ _CUSRDEF03 ] VAR aTmp[ _CUSRDEF03 ] ;
         ID       130 ;
         OF       fldDefinidos

      REDEFINE SAY PROMPT aIniCli[4] ;
         ID       135 ;
         OF       fldDefinidos

      REDEFINE GET aGet[ _CUSRDEF04 ] VAR aTmp[ _CUSRDEF04 ] ;
         ID       140 ;
         OF       fldDefinidos

      REDEFINE SAY PROMPT aIniCli[5] ;
         ID       145 ;
         OF       fldDefinidos

      REDEFINE GET aGet[ _CUSRDEF05 ] VAR aTmp[ _CUSRDEF05 ] ;
         ID       150 ;
         OF       fldDefinidos

      REDEFINE SAY PROMPT aIniCli[6] ;
         ID       155 ;
         OF       fldDefinidos

      REDEFINE GET aGet[ _CUSRDEF06 ] VAR aTmp[ _CUSRDEF06 ] ;
         ID       160 ;
         OF       fldDefinidos

      REDEFINE SAY PROMPT aIniCli[7] ;
         ID       165 ;
         OF       fldDefinidos

      REDEFINE GET aGet[ _CUSRDEF07 ] VAR aTmp[ _CUSRDEF07 ] ;
         ID       170 ;
         OF       fldDefinidos

      REDEFINE SAY PROMPT aIniCli[8] ;
         ID       175 ;
         OF       fldDefinidos

      REDEFINE GET aGet[ _CUSRDEF08 ] VAR aTmp[ _CUSRDEF08 ] ;
         ID       180 ;
         OF       fldDefinidos

      REDEFINE SAY PROMPT aIniCli[9] ;
         ID       185 ;
         OF       fldDefinidos

      REDEFINE GET aGet[ _CUSRDEF09 ] VAR aTmp[ _CUSRDEF09 ] ;
         ID       190 ;
         OF       fldDefinidos

      REDEFINE SAY PROMPT aIniCli[10] ;
         ID       195 ;
         OF       fldDefinidos

      REDEFINE GET aGet[ _CUSRDEF10 ] VAR aTmp[ _CUSRDEF10 ] ;
         ID       200 ;
         OF       fldDefinidos

      /*
      Quinta caja de dialogo__________________________________________________
      */

      REDEFINE BITMAP oBmpTarifa ;
         ID       600 ;
         RESOURCE "Symbol_euro_Alpha_48" ;
         TRANSPARENT ;
         OF       fldTarifa

      REDEFINE BUTTON  ;
         ID       500 ;
         OF       fldTarifa ;
         WHEN     ( oUser():lCambiarPrecio() .and. nMode != ZOOM_MODE );
         ACTION   ( WinAppRec( oBrwAtp, bEdtAtp, dbfTmpAtp, aTmp, aGet ) )

      REDEFINE BUTTON  ;
         ID       501 ;
         OF       fldTarifa ;
         WHEN     ( oUser():lCambiarPrecio() .and. nMode != ZOOM_MODE );
         ACTION   ( WinEdtRec( oBrwAtp, bEdtAtp, dbfTmpAtp, aTmp, aGet ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldTarifa ;
         WHEN     ( oUser():lCambiarPrecio() .and. nMode != ZOOM_MODE );
         ACTION   ( WinZooRec( oBrwAtp, bEdtAtp, dbfTmpAtp, aTmp, aGet ) )

      REDEFINE BUTTON  ;
         ID       502 ;
         OF       fldTarifa ;
         WHEN     ( oUser():lCambiarPrecio() .and. nMode != ZOOM_MODE );
         ACTION   ( WinDelRec( oBrwAtp, dbfTmpAtp ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       fldTarifa ;
         WHEN     ( oUser():lCambiarPrecio() .and. nMode != ZOOM_MODE );
         ACTION   ( AddFamilia( oBrwAtp, dbfTmpAtp, aTmp[_COD] ) )

      REDEFINE BUTTON ;
         ID       505 ;
         OF       fldTarifa ;
         ACTION   ( Searching( dbfTmpAtp, { "Artículo", "Familia" }, oBrwAtp ) )

      #ifndef __TACTIL__

      REDEFINE BUTTON ;
         ID       506 ;
         OF       fldTarifa ;
         ACTION   ( TInfAtp():New( "Plantilla de condiciones especificas", , , , , , { dbfTmpAtp, aGet, aTmp } ):Play() )

      #endif

      REDEFINE COMBOBOX oFiltroAtp VAR cFiltroAtp ;
         ID       507 ;
         ITEMS    aFiltroAtp ;
         ON CHANGE( FiltroAtipica( oFiltroAtp, dbfTmpAtp, oBrwAtp ) );
         OF       fldTarifa

      /*
      Diario de la subcuenta---------------------------------------------------
      */

      oBrwAtp                 := IXBrowse():New( fldTarifa )

      oBrwAtp:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwAtp:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwAtp:cAlias          := dbfTmpAtp
      oBrwAtp:nMarqueeStyle   := 6
      oBrwAtp:cName           := "Clientes.Atipicas"

      with object ( oBrwAtp:AddCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| if( ( dbfTmpAtp )->nTipAtp <= 1, "Artículo", "Familia" ) }
         :nWidth           := 60
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := "Of. Artículo en oferta"
         :bEditValue       := {|| ( dbfTmpAtp )->nTipAtp <= 1 .and. lArticuloEnOferta( ( dbfTmpAtp )->cCodArt, ( D():Get( "Client", nView ) )->Cod, ( D():Get( "Client", nView ) )->cCodGrp ) }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| if( ( dbfTmpAtp )->nTipAtp <= 1, ( dbfTmpAtp )->cCodArt, ( dbfTmpAtp )->cCodFam ) }
         :nWidth           := 80
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| if( ( dbfTmpAtp )->nTipAtp <= 1, RetArticulo( ( dbfTmpAtp )->cCodArt, D():Get( "Articulo", nView ) ), RetFamilia( ( dbfTmpAtp )->cCodFam, dbfFamilia ) ) }
         :nWidth           := 160
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := "Prop.1"
         :bEditValue       := {|| ( dbfTmpAtp )->cValPr1 }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := "Prop.2"
         :bEditValue       := {|| ( dbfTmpAtp )->cValPr2 }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar1", "Precio 1" )
         :bEditValue       := {|| ( dbfTmpAtp )->nPrcArt }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar2", "Precio 2" )
         :bEditValue       := {|| ( dbfTmpAtp )->nPrcArt2 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar3", "Precio 3" )
         :bEditValue       := {|| ( dbfTmpAtp )->nPrcArt3 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar4", "Precio 4" )
         :bEditValue       := {|| ( dbfTmpAtp )->nPrcArt4 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar5", "Precio 5" )
         :bEditValue       := {|| ( dbfTmpAtp )->nPrcArt5 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := uFieldEmpresa( "cTxtTar6", "Precio 6" )
         :bEditValue       := {|| ( dbfTmpAtp )->nPrcArt6 }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := "% Descuento"
         :bEditValue       := {|| ( dbfTmpAtp )->nDtoArt }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := "Descuento lineal"
         :bEditValue       := {|| ( dbfTmpAtp )->nDtoDiv }
         :cEditPicture     := cPouDiv
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := "% Agente"
         :bEditValue       := {|| ( dbfTmpAtp )->nComAge }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := "Inicio"
         :bEditValue       := {|| ( dbfTmpAtp )->dFecIni }
         :nWidth           := 80
      end with

      with object ( oBrwAtp:AddCol() )
         :cHeader          := "Fin"
         :bEditValue       := {|| ( dbfTmpAtp )->dFecFin }
         :nWidth           := 80
      end with

      if oUser():lCambiarPrecio() .and. nMode != ZOOM_MODE
         oBrwAtp:bLDblClick   := {|| WinEdtRec( oBrwAtp, bEdtAtp, dbfTmpAtp, aTmp, aGet ) }
      end if
      oBrwAtp:bRClicked       := {| nRow, nCol, nFlags | oBrwAtp:RButtonDown( nRow, nCol, nFlags ) }

      oBrwAtp:CreateFromResource( 400 )

      /*
      Octava pestaña-----------------------------------------------------------
      */

      REDEFINE BITMAP oBmpDocumentos ;
         ID       600 ;
         RESOURCE "Books_blue_Alpha_48" ;
         TRANSPARENT ;
         OF       fldDocumentos

      oBrwDoc                 := IXBrowse():New( fldDocumentos )

      oBrwDoc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDoc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDoc:cAlias          := dbfTmpDoc
      oBrwDoc:nMarqueeStyle   := 5
      oBrwDoc:cName           := "Clientes.Documentos"
      oBrwDoc:nRowHeight      := 38
      oBrwDoc:nDataLines      := 2

      with object ( oBrwDoc:AddCol() )
         :cHeader          := "Documento"
         :bEditValue       := {|| Rtrim( ( dbfTmpDoc )->cNombre ) + CRLF + Space( 5 ) + lTrim( ( dbfTmpDoc )->cRuta ) }
         :nWidth           := 480
      end with

      if ( nMode != ZOOM_MODE )
         oBrwDoc:bLDblClick   := {|| ShellExecute( oDlg:hWnd, "open", rTrim( ( dbfTmpDoc )->cRuta ) ) }
      end if
      oBrwDoc:bRClicked       := {| nRow, nCol, nFlags | oBrwDoc:RButtonDown( nRow, nCol, nFlags ) }

      oBrwDoc:CreateFromResource( 400 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       fldDocumentos ;
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ( WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       fldDocumentos ;
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ( WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldDocumentos ;
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ( DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .t. ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldDocumentos ;
         ACTION   ( WinZooRec( oBrwDoc, bEdtDoc, dbfTmpDoc ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       fldDocumentos ;
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ( ShellExecute( oDlg:hWnd, "open", rTrim( ( dbfTmpDoc )->cRuta ) ) )

      /*
      Detalle________________________________________________________________
      */

      REDEFINE BITMAP oBmpIncidencias ;
         ID       600 ;
         RESOURCE "Sign_warning_Alpha_48" ;
         TRANSPARENT ;
         OF       fldIncidencias

      oBrwInc                 := IXBrowse():New( fldIncidencias )

      oBrwInc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwInc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwInc:cAlias          := dbfTmpInc
      oBrwInc:nMarqueeStyle   := 5
      oBrwInc:cName           := "Clientes.Incidencias"

      with object ( oBrwInc:AddCol() )
         :cHeader          := "Rs. Resuelta"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfTmpInc )->lListo }
         :nWidth           := 18
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwInc:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| Dtoc( ( dbfTmpInc )->dFecInc ) }
         :nWidth           := 80
      end with

      with object ( oBrwInc:AddCol() )
         :cHeader          := "Descripción"
         :bEditValue       := {|| ( dbfTmpInc )->mDesInc }
         :nWidth           := 350
      end with

      with object ( oBrwInc:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodTip"
         :bEditValue       := {|| ( dbfTmpInc )->cCodTip }
         :nWidth           := 40
      end with

      with object ( oBrwInc:AddCol() )
         :cHeader          := "Tipo incidencia"
         :bEditValue       := {|| cNomInci( ( dbfTmpInc )->cCodTip, D():Get( "TipInci", nView ) ) }
         :nWidth           := 180
      end with

      if nMode != ZOOM_MODE
         oBrwInc:bLDblClick   := {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) }
      end if
      oBrwInc:bRClicked       := {| nRow, nCol, nFlags | oBrwInc:RButtonDown( nRow, nCol, nFlags ) }

      oBrwInc:CreateFromResource( 400 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       fldIncidencias ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       fldIncidencias ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       fldIncidencias ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       fldIncidencias ;
         ACTION   ( WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) )

      REDEFINE GET aGet[ _CTIPINCI ] VAR aTmp[ _CTIPINCI ];
         ID       450 ;
         IDTEXT   451 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cTipInci( aGet[ _CTIPINCI ], D():Get( "TipInci", nView ), aGet[ _CTIPINCI ]:oHelpText ), FiltraIncidencias( aTmp, oBrwInc ) ) ;
         BITMAP   "LUPA" ;
         ON CHANGE( FiltraIncidencias( aTmp, oBrwInc ) );
         ON HELP  ( BrwIncidencia( D():Get( "TipInci", nView ), aGet[ _CTIPINCI ], aGet[ _CTIPINCI ]:oHelpText ) ) ;
         OF       fldIncidencias   

      /*
      Observaciones de clientes------------------------------------------------
      */

      REDEFINE BITMAP oBmpObservaciones ;
         ID       600 ;
         RESOURCE "Information2_Alpha_48" ;
         TRANSPARENT ;
         OF       fldObservaciones

      DEFINE CLIPBOARD oClp OF fldObservaciones FORMAT TEXT

      REDEFINE BTNBMP oBtn[ 1 ] ;
         ID       100 ;
         WHEN     ( .t. ) ;
         OF       fldObservaciones ;
         RESOURCE "IMP16" ;
         NOBORDER ;
         TOOLTIP  "Imprimir" ;
         ACTION   ( oRTF:Print(), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 2 ] ;
         ID       110 ;
         WHEN     ( .t. ) ;
         OF       fldObservaciones ;
         RESOURCE "PREV116" ;
         NOBORDER ;
         TOOLTIP  "Previsualizar" ;
         ACTION   ( oRTF:Preview( "Class TRichEdit" ) )

      REDEFINE BTNBMP oBtn[ 3 ] ;
         ID       120 ;
         WHEN     ( .t. ) ;
         OF       fldObservaciones ;
         RESOURCE "Bus16" ;
         NOBORDER ;
         TOOLTIP  "Buscar" ;
         ACTION   ( FindRich( oRTF ) )

      REDEFINE BTNBMP oBtn[ 4 ] ;
         ID       130 ;
         WHEN     ( ! Empty( oRTF:GetSel() ) .and. ! oRTF:lReadOnly ) ;
         OF       fldObservaciones ;
         RESOURCE "Cut_16" ;
         NOBORDER ;
         TOOLTIP  "Cortar" ;
         ACTION   ( oRTF:Cut(), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 5 ] ;
         ID       140 ;
         WHEN     ( ! Empty( oRTF:GetSel() ) ) ;
         OF       fldObservaciones ;
         RESOURCE "Copy16" ;
         NOBORDER ;
         TOOLTIP  "Copiar" ;
         ACTION   ( oRTF:Copy(), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 6 ] ;
         ID       150 ;
         WHEN     ( ! Empty( oClp:GetText() ) .and. ! oRTF:lReadOnly ) ;
         OF       fldObservaciones ;
         RESOURCE "Paste_16" ;
         NOBORDER ;
         TOOLTIP  "Pegar" ;
         ACTION   ( oRTF:Paste(), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 7 ] ;
         ID       160 ;
         WHEN     ( oRTF:SendMsg( EM_CANUNDO ) != 0 ) ;
         OF       fldObservaciones ;
         RESOURCE "Undo1_16" ;
         NOBORDER ;
         TOOLTIP  "Deshacer" ;
         ACTION   ( oRTF:Undo(), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 8 ] ;
         ID       170 ;
         WHEN     ( oRTF:SendMsg( EM_CANREDO ) != 0 ) ;
         OF       fldObservaciones ;
         RESOURCE "Redo_16" ;
         NOBORDER ;
         TOOLTIP  "Rehacer" ;
         ACTION   ( oRTF:Redo(), oRTF:SetFocus() )

      REDEFINE COMBOBOX oZoom VAR cZoom ;
         ITEMS    aZoom ;
         ID       180 ;
         OF       fldObservaciones

      oZoom:bChange     := {|| oRTF:SetZoom( aRatio[ oZoom:nAt, 1 ], aRatio[ oZoom:nAt, 2 ] ), oRTF:SetFocus()  }

      REDEFINE COMBOBOX oFuente VAR cFuente ;
         ITEMS    aFuente ;
         ID       190 ;
         OF       fldObservaciones

      oFuente:bChange   := {|| oRTF:SetFontName( oFuente:VarGet() ), oRTF:SetFocus() }

      REDEFINE COMBOBOX oSize VAR cSize ;
         ITEMS    aSize ;
         ID       200 ;
         OF       fldObservaciones

      oSize:bChange     := {|| oRTF:SetFontSize( Val( oSize:VarGet() ) ), oRTF:SetFocus() }

      REDEFINE BTNBMP oBtn[10] ;
         ID       210 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       fldObservaciones ;
         RESOURCE "Text_Bold" ;
         NOBORDER ;
         TOOLTIP  "Negrita" ;
         ACTION   ( lBold  := !lBold, oRTF:SetBold( lBold ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 10 ] ;
         ID       220 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       fldObservaciones ;
         RESOURCE "Text_Italics_16" ;
         NOBORDER ;
         TOOLTIP  "Cursiva" ;
         ACTION   ( lItalic := !lItalic, oRTF:SetItalic( lItalic ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 11 ] ;
         ID       230 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       fldObservaciones ;
         RESOURCE "Text_Underlined_16" ;
         NOBORDER ;
         TOOLTIP  "Subrayado" ;
         ACTION   ( lUnderline := !lUnderline, oRTF:SetUnderline( lUnderline ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 12 ] ;
         ID       240 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       fldObservaciones ;
         RESOURCE "Text_Align_Left_16" ;
         NOBORDER ;
         TOOLTIP  "Izquierda" ;
         ACTION   ( oRTF:SetAlign( PFA_LEFT ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 13 ]  ;
         ID       250 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       fldObservaciones ;
         RESOURCE "Text_Center" ;
         NOBORDER ;
         TOOLTIP  "Centro" ;
         ACTION   ( oRTF:SetAlign( PFA_CENTER ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 14 ]  ;
         ID       260 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       fldObservaciones ;
         RESOURCE "Text_Align_Right_16" ;
         NOBORDER ;
         TOOLTIP  "Derecha" ;
         ACTION   ( oRTF:SetAlign( PFA_RIGHT ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 15 ] ;
         ID       270 ;
         WHEN     ( ! oRTF:lReadOnly ) ;
         OF       fldObservaciones ;
         RESOURCE "Text_Justified_16" ;
         NOBORDER ;
         TOOLTIP  "Justificado" ;
         ACTION   ( oRTF:SetAlign( PFA_JUSTIFY ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 16 ] ;
         ID       280 ;
         WHEN     ( ! oRTF:lReadOnly .AND. !oRTF:GetNumbering() ) ;
         OF       fldObservaciones ;
         RESOURCE "Pin_Blue_16" ;
         NOBORDER ;
         TOOLTIP  "Viñetas" ;
         ACTION   ( lBullet := !lBullet, oRTF:SetBullet( lBullet ), oRTF:SetFocus() )

      REDEFINE BTNBMP oBtn[ 17 ] ;
         ID       290 ;
         WHEN     ( .t. ) ;
         OF       fldObservaciones ;
         RESOURCE "Calendar_16" ;
         NOBORDER ;
         TOOLTIP  "Fecha/Hora" ;
         ACTION   ( DateTimeRich( oRTF ) )

      REDEFINE RICHEDIT oRTF VAR cRTF ;
         ID       300 ;
         OF       fldObservaciones

      oRTF:bChange:= { || RTFRefreshButtons( oRtf, oBtn ) }

      /*
      Pestaña de gestión de cobros de clientes_________________________________
      */

      REDEFINE BITMAP oBmpRecibos ;
         ID          500 ;
         RESOURCE    "SAFE_INTO_ALPHA_48" ;
         TRANSPARENT ;
         OF          fldRecibos

      REDEFINE COMBOBOX oPeriodoCli ;
         VAR         cPeriodoCli ;
         ID          100 ;
         ITEMS       aPeriodoCli ;
         ON CHANGE   ( lRecargaFecha( oFecIniCli, oFecFinCli, cPeriodoCli ), LoadPageClient( aTmp[ _COD ] ) ) ;
         OF          fldRecibos

      REDEFINE GET oFecIniCli VAR dFecIniCli;
         ID          110 ;
         SPINNER ;
         VALID       ( LoadPageClient( aTmp[ _COD ] ) );
         OF          fldRecibos

      REDEFINE GET oFecFinCli VAR dFecFinCli;
         ID          120 ;
         SPINNER ;
         VALID       ( LoadPageClient( aTmp[ _COD ] ) );
         OF          fldRecibos

      REDEFINE COMBOBOX oEstadoCli VAR cEstadoCli ;
         ID          130 ;
         ITEMS       aEstadoCli ;
         ON CHANGE   ( LoadPageClient( aTmp[ _COD ] ) );
         OF          fldRecibos

      oBrwRecCli                 := IXBrowse():New( fldRecibos )

      oBrwRecCli:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwRecCli:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwRecCli:cAlias          := ( D():Get( "FacCliP", nView ) )

      oBrwRecCli:nMarqueeStyle   := 6
      oBrwRecCli:lRecordSelector := .f.
      oBrwRecCli:cName           := "Recibos de Clientes.Inicio" 
      oBrwRecCli:lFooter         := .t. 

      oBrwRecCli:bLDblClick      := {|| if ( !Empty( ( D():FacturasClientesCobros( nView ) )->cSerie ), EdtRecCli( D():FacturasClientesCobrosId( nView ), .f., !Empty( ( D():FacturasClientesCobros( nView ) )->cTipRec ) ), ), LoadPageClient( aTmp[ _COD ] ) }

      oBrwRecCli:CreateFromResource( 170 )

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "E. Estado"
         :bStrData               := {|| "" }
         :bEditValue             := {|| ( D():Get( "FacCliP", nView ) )->lCobrado }
         :nWidth                 := 18
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "T. Tipo"
         :bEditValue             := {|| if( Empty( ( D():Get( "FacCliP", nView ) )->cTipRec ), "Factura", "Rectificativa" ) }
         :nWidth                 := 18
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Número"
         :bEditValue             := {|| AllTrim( ( D():Get( "FacCliP", nView ) )->cSerie ) + "/" + AllTrim( Str( ( D():Get( "FacCliP", nView ) )->nNumFac ) ) + "/" +  AllTrim( ( D():Get( "FacCliP", nView ) )->cSufFac ) + "-" + AllTrim( Str( ( D():Get( "FacCliP", nView ) )->nNumRec ) ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Cliente"
         :bEditValue             := {|| AllTrim( ( D():Get( "FacCliP", nView ) )->cCodCli ) }
         :nWidth                 := 60
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Nombre"
         :bEditValue             := {|| AllTrim( ( D():Get( "FacCliP", nView ) )->cNomCli ) }
         :nWidth                 := 200
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Fecha"
         :bEditValue             := {|| Dtoc( ( D():Get( "FacCliP", nView ) )->dPreCob ) }
         :nWidth                 := 80
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Vencimiento"
         :bEditValue             := {|| Dtoc( ( D():Get( "FacCliP", nView ) )->dFecVto ) }
         :bClrStd                := {|| { if( ( D():Get( "FacCliP", nView ) )->dFecVto < GetSysDate(), CLR_HRED, CLR_BLACK ), GetSysColor( COLOR_WINDOW )} }
         :nWidth                 := 80
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Importe"
         :bEditValue             := {|| ( D():Get( "FacCliP", nView ) )->nImporte }
         :cEditPicture           := cPorDiv()
         :nFooterType            := AGGR_SUM
         :nWidth                 := 70
         :nDataStrAlign          := 1
         :nHeadStrAlign          := 1
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader             := "Modificar"
         :bStrData            := {|| "" }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| if ( !Empty( ( D():FacturasClientesCobros( nView ) )->cSerie ), EdtRecCli( D():FacturasClientesCobrosId( nView ), .f., !Empty( ( D():FacturasClientesCobros( nView ) )->cTipRec ) ), ), LoadPageClient( aTmp[ _COD ] ) }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "EDIT16" )
     end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Pago"
         :bEditValue             := {|| cNbrFPago( ( D():FacturasClientesCobros( nView ) )->cCodPgo, dbfFPago ) }
         :nWidth                 := 200
         :lHide                  := .t.
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Pagado por"
         :bEditValue             := {|| ( D():FacturasClientesCobros( nView ) )->cPgdoPor }
         :nWidth                 := 100
         :lHide                  := .t.
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := "Documento"
         :bEditValue             := {|| ( D():FacturasClientesCobros( nView ) )->cDocPgo }
         :nWidth                 := 100
         :lHide                  := .t.
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := if( Empty( AllTrim( aIniCli[1] ) ), "Campo definido 1", AllTrim( aIniCli[1] ) )
         :bEditValue             := {|| aTmp[ _CUSRDEF01 ] }
         :nWidth                 := 100
         :lHide                  := .t.
         :nEditType              := 1
         :bOnPostEdit            := {|oCol, uNewValue, nKey| ChangeCampoDef( oCol, uNewValue, nKey, aTmp, _CUSRDEF01, oBrwRecCli ) }
      end with

      with object ( oBrwRecCli:AddCol() )
         :cHeader                := if( Empty( AllTrim( aIniCli[2] ) ), "Campo definido 2", AllTrim( aIniCli[2] ) )
         :bEditValue             := {|| aTmp[ _CUSRDEF02 ] }
         :nWidth                 := 100
         :lHide                  := .t.
         :nEditType              := 1
         :bOnPostEdit            := {|oCol, uNewValue, nKey| ChangeCampoDef( oCol, uNewValue, nKey, aTmp, _CUSRDEF02, oBrwRecCli ) }
      end with

      /*
      Botones de la Caja de Dialogo__________________________________________
      */

      REDEFINE BUTTON ;
         ID       3 ;
         OF       oDlg ;
         ACTION   ( if( oFld:nOption > 1, oFld:SetOption( oFld:nOption - 1 ), ) )

      REDEFINE BUTTON ;
         ID       4 ;
         OF       oDlg ;
         ACTION   ( if( oFld:nOption < Len( oFld:aDialogs ), oFld:SetOption( oFld:nOption + 1 ), ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( SavClient( aTmp, aGet, oDlg, oBrw, nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE

         fldDirecciones:AddFastKey( VK_F2, {|| AppObras( aTmp[ _COD ], dbfTmpObr, oBrwObr ) } )
         fldDirecciones:AddFastKey( VK_F3, {|| EdtObras( aTmp[ _COD ], nil, dbfTmpObr, oBrwObr, .t. ) } )
         fldDirecciones:AddFastKey( VK_F4, {|| DelObras( dbfTmpObr, oBrwObr ) } )

         fldContactos:AddFastKey( VK_F2, {|| AppContactos( aTmp[ _COD ], dbfTmpCon, oBrwCon ) } )
         fldContactos:AddFastKey( VK_F3, {|| EdtContactos( dbfTmpCon, oBrwCon ) } )
         fldContactos:AddFastKey( VK_F4, {|| DelContactos( dbfTmpCon, oBrwCon ) } )

         fldBancos:AddFastKey( VK_F2, {|| WinAppRec( oBrwBnc, bEdtBnc, dbfTmpBnc, aTmp, , aTmp[ _COD ] ) } )
         fldBancos:AddFastKey( VK_F3, {|| WinEdtRec( oBrwBnc, bEdtBnc, dbfTmpBnc, aTmp, , aTmp[ _COD ] ) } )
         fldBancos:AddFastKey( VK_F4, {|| DelBnc( aTmp, oBrwBnc, dbfTmpBnc ) } )

         fldTarifa:AddFastKey( VK_F2, {|| WinAppRec( oBrwAtp, bEdtAtp, dbfTmpAtp, aTmp, aGet ) } )
         fldTarifa:AddFastKey( VK_F3, {|| WinEdtRec( oBrwAtp, bEdtAtp, dbfTmpAtp, aTmp, aGet ) } )
         fldTarifa:AddFastKey( VK_F4, {|| WinDelRec( oBrwAtp, dbfTmpAtp ) } )

         fldDocumentos:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
         fldDocumentos:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
         fldDocumentos:AddFastKey( VK_F4, {|| DbDelRec(  oBrwDoc, dbfTmpDoc, nil, nil, .t. ) } )

         fldIncidencias:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
         fldIncidencias:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
         fldIncidencias:AddFastKey( VK_F4, {|| DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) } )

         oDlg:AddFastKey( VK_F7, {|| if( oFld:nOption > 1, oFld:SetOption( oFld:nOption - 1 ), ) } )
         oDlg:AddFastKey( VK_F8, {|| if( oFld:nOption < Len( oFld:aDialogs ), oFld:SetOption( oFld:nOption + 1 ), ) } )

         oDlg:AddFastKey( VK_F5, {|| SavClient( aTmp, aGet, oDlg, oBrw, nMode ) } )

      end if

      oDlg:bStart := {||   ShowComentario( aTmp ),;
                           ShowIncidenciaCliente( aTmp[ _COD ], nView ),;
                           ShowFld( aTmp, aGet ),;
                           FiltroAtipica( oFiltroAtp, dbfTmpAtp, oBrwAtp ),;
                           oGet:SetFocus(),;
                           oBrwBnc:Load(),;
                           oBrwObr:Load(),;
                           oBrwCta:Load(),;
                           oBrwAtp:Load(),;
                           oBrwCon:Load(),;
                           oBrwRecCli:Load(),;
                           aGet[ _CTIPINCI ]:lValid(),;
                           if( !empty( nTab ), oFld:setOption( nTab ), ),;
                           lRecargaFecha( oFecIniCli, oFecFinCli, cPeriodoCli ),;
                           LoadPageClient( aTmp[ _COD ] ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT  ( EdtRotorMenu( aTmp, aGet, oDlg, oBrw, nMode ) ) ;
      VALID    ( KillTrans( oBmpDiv, oBrwBnc, oBrwObr, oBrwCta, oBrwAtp, oBrwInc, oBrwCon ) ) ;
      CENTER

   // Quitamos los filtros-----------------------------------------------------

   EndEdtRotorMenu()

   oBmpGeneral:End()
   oBmpComercial:End()
   oBmpDirecciones:End()
   oBmpContactos:End()
   oBmpBancos:End()
   oBmpContabilidad:End()
   oBmpComentario:End()
   oBmpTarifa:End()
   oBmpDocumentos:End()
   oBmpIncidencias:End()
   oBmpObservaciones:End()
   oBmpAutomaticas:End()
   oBmpRecibos:End()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function FiltraIncidencias( aTmp, oBrwInc )

   if Empty( aTmp[ _CTIPINCI ] )
      ( dbfTmpInc )->( OrdScope( 0, nil ) )
      ( dbfTmpInc )->( OrdScope( 1, nil ) )
   else
      ( dbfTmpInc )->( OrdScope( 0, nil ) )
      ( dbfTmpInc )->( OrdScope( 1, nil ) )
      ( dbfTmpInc )->( OrdScope( 0, aTmp[ _CTIPINCI ] ) )
      ( dbfTmpInc )->( OrdScope( 1, aTmp[ _CTIPINCI ] ) )
   end if

   ( dbfTmpInc )->( dbGoTop() )

   if !Empty( oBrwInc )
      oBrwInc:Refresh()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

function AddFacAut( oBrwFacAut )

   local cResultado  := ""

   cResultado := oFacAut:Buscar()

   if !Empty( cResultado )

      if aScan( aFacAut, cResultado ) == 0
         aAdd( aFacAut, cResultado )
      else
         MsgStop( "La plantilla automática ya se encuentra introducida." )
      end if

   end if

   if !Empty( oBrwFacAut )
      oBrwFacAut:Refresh()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

function DelFacAut( oBrwFacAut )

   if ApoloMsgNoYes()
      aDel( aFacAut, oBrwFacAut:nArrayAt, .t. )
   end if

   if !Empty( oBrwFacAut )
      oBrwFacAut:Refresh()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

function ShowIncidenciaCliente( cCodigoCliente, nView )

   D():GetStatus( "CliInc", nView )

   if D():SeekInOrd( "CliInc", nView, cCodigoCliente, "cCodCli" )

      while ( D():Get( "CliInc", nView ) )->cCodCli == cCodigoCliente .and. !D():Eof( "CliInc", nView ) 

         if ( D():Get( "CliInc", nView ) )->lAviso .and. !( D():Get( "CliInc", nView ) )->lListo

            MsgInfo( AllTrim( ( D():Get( "CliInc", nView ) )->mDesInc ), "Incidencia de cliente" )

         end if

         ( D():Get( "CliInc", nView ) )->( dbSkip() )

      end while

   end if

   D():SetStatus( "CliInc", nView )

Return ( .t. )

//--------------------------------------------------------------------------//

Static Function ShowComentario( aTmp, nMode )

   if nMode != APPD_MODE .and. aTmp[ _LMOSCOM ] .and. !Empty( aTmp[ _MCOMENT ] )
      MsgInfo( AllTrim( aTmp[ _MCOMENT ] ), "Comentario" )
   end if

Return ( .t. )

//--------------------------------------------------------------------------//

Static Function lRecargaArray( aGet, aTmp )
/*
   local aSbrAtp  := {}
   local nPosAtp  := aGet[ _NSBRATP ]:nAt

   aAdd( aSbrAtp, "Base" )
   aAdd( aSbrAtp, if( !Empty( aTmp[ _CDTOESP ] ), aTmp[ _CDTOESP ], "General" )      )
   aAdd( aSbrAtp, if( !Empty( aTmp[ _CDPP    ] ), aTmp[ _CDPP    ], "Pronto pago" )  )
   aAdd( aSbrAtp, if( !Empty( aTmp[ _CDTOUNO ] ), aTmp[ _CDTOUNO ], "Definido 1" )   )
   aAdd( aSbrAtp, if( !Empty( aTmp[ _CDTODOS ] ), aTmp[ _CDTODOS ], "Definido 2" )   )

   aGet[ _NSBRATP ]:SetItems( aSbrAtp, .t. )
   aGet[ _NSBRATP ]:Set( aSbrAtp[ Min( Max( nPosAtp, 1 ), len( aSbrAtp ) ) ] )
*/
Return ( .t. )

//--------------------------------------------------------------------------//

Static Function EdtDoc( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oRuta
   local oNombre
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de pedidos de clientes"

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
      oDlg:AddFastKey( VK_F5,       {|| WinGather( aTmp, nil, dbfTmpDoc, oBrw, nMode ), oDlg:end( IDOK ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function ShowFld( aTmp, aGet )

   local n

   for n := 1 TO 10
      if Empty( Rtrim( aIniCli[ n ] ) )
         aGet[ ( D():Get( "Client", nView ) )->( fieldpos( "cUsrDef" + Rjust( str( n ), "0", 2 ) ) ) ]:hide()
      end if
   next

   lRecargaArray( aGet, aTmp )

   /*
   Pasamos del campo memo de las observaciones al objeto richedit--------------
   */

   oRTF:LoadAsRTF( aTmp[ _MOBSERV ] )

   /*
   Validez para todos los controles--------------------------------------------
   */

   EvalGet( aGet )

Return nil

//--------------------------------------------------------------------------//

STATIC FUNCTION EdtAtp( aTmp, aGet, dbfTmpAtp, oBrw, aTmpCli, aGetCli, nMode )

   local oDlg
   local oFld
   local oGetArticulo
   local cGetArticulo
   local oGetFamilia
   local cGetFamilia
   local oSayPr1
   local oSayPr2
   local oSayVp1
   local oSayVp2
   local cSayPr1
   local cSayPr2
   local cSayVp1
   local cSayVp2
   local oCosto
   local cCosto
   local oSobre
   local cSobre         := "Precio 1"
   local aSobre         := { "Precio 1", "Precio 2", "Precio 3", "Precio 4", "Precio 5", "Precio 6" }
   local cNaturaleza    := "Artículo"
   local aNaturaleza    := { "Artículo", "Familia" }
   local oBrwRen
   local cPouEmp        := cPouDiv( cDivEmp() )
   local cPouChg        := cPouDiv( cDivChg() )
   local oBtnRen
   local oSayLabels     := Array( 16 )

   if nMode == APPD_MODE

      cCosto            := 0
      aTmp[ _aCCODCLI ] := aTmpCli[ _COD ]
      aTmp[ _aDFECINI ] := Ctod( "" )
      aTmp[ _aDFECFIN ] := Ctod( "" )
      aTmp[ _aLAPLPRE ] := .t.
      aTmp[ _aLAPLPED ] := .t.
      aTmp[ _aLAPLALB ] := .t.
      aTmp[ _aLAPLFAC ] := .t.
      aTmp[ _aLAPLSAT ] := .t.
      aTmp[ _aNTIPXBY ] := 2
      aTmp[ _aNUNVOFE ] := 1
      aTmp[ _aNUNCOFE ] := 1

      if !Empty( aTmpCli[ _CAGENTE ] )
         if ( cAgente )->( dbSeek( aTmpCli[ _CAGENTE ] ) )
            aTmp[ _aNCOMAGE ]    := ( cAgente )->nCom1
            if ( cAgente )->nCom1 != 0
               aTmp[ _aLCOMAGE ] := .t.
            end if
         end if
      end if

   else

      cNaturaleza       := Max( Min( aTmp[ _aNTIPATP ], len( aNaturaleza ) ), 1 )

      cGetArticulo      := RetArticulo( aTmp[ _aCCODART ] )

      if !Empty( aTmp[ _aCCODPR1 ] )
         cSayPr1        := retProp( aTmp[ _aCCODPR1 ], dbfPro )
         cSayVp1        := retValProp( aTmp[ _aCCODPR1 ] + aTmp[ _aCVALPR1 ], dbfProL )
      end if

      if !Empty( aTmp[ _aCCODPR2 ] )
         cSayPr2        := retProp( aTmp[ _aCCODPR2 ], dbfPro )
         cSayVp2        := retValProp( aTmp[ _aCCODPR2 ] + aTmp[ _aCVALPR2 ], dbfProL )
      end if

      cGetFamilia       := retFld( aTmp[ _aCCODFAM ], dbfFamilia )

   end if

   DEFINE DIALOG oDlg RESOURCE "CLIATP" TITLE LblTitle( nMode ) + "tarifas de clientes"

      REDEFINE FOLDER oFld ;
         ID       100 ;
         OF       oDlg ;
         PROMPT   "&General"  ,;
                  "A&mbito"   ;
         DIALOGS  "CLIATP_0"  ,;
                  "CLIATP_1"  ;

      REDEFINE COMBOBOX aGet[ _aNTIPATP ] VAR cNaturaleza ;
         ITEMS    aNaturaleza ;
         ID       90 ;
         ON CHANGE( ChangeNaturaleza( aGet, aTmp, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGetArticulo, oGetFamilia, oCosto, nMode, oSayLabels ) ) ;
         WHEN     ( nMode == APPD_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aCCODART ] VAR aTmp[ _aCCODART ];
         ID       100 ;
         WHEN     ( nMode == APPD_MODE );
         ON HELP  ( BrwArticulo( aGet[ _aCCODART ], oGetArticulo ) );
         BITMAP   "LUPA" ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         VALID    ( IsCliAtp( aGet, aTmp, oGetArticulo, ( D():Get( "CliAtp", nView ) ), nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oCosto ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetArticulo VAR cGetArticulo ;
         ID       110 ;
         WHEN     ( .F. );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aCCODFAM ] VAR aTmp[ _aCCODFAM ];
         ID       105 ;
         WHEN     ( nMode == APPD_MODE );
         VALID    cFamilia( aGet[ _aCCODFAM ], dbfFamilia, oGetFamilia ) ;
         BITMAP   "LUPA" ;
         ON HELP  BrwFamilia( aGet[ _aCCODFAM ], oGetFamilia ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oGetFamilia VAR cGetFamilia ;
         ID       106 ;
         WHEN     ( .f. );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayPr1 VAR cSayPr1;
         ID       888 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aCVALPR1 ] VAR aTmp[ _aCVALPR1 ];
         ID       250 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode == APPD_MODE ) ;
         ON HELP  ( brwPropiedadActual( aGet[ _aCVALPR1 ], oSayVp1, aTmp[ _aCCODPR1 ] ) ) ;
         VALID    ( if( lPrpAct( aGet[ _aCVALPR1 ], oSayVp1, aTmp[ _aCCODPR1 ], dbfProL ),;
                    IsCliAtp( aGet, aTmp, oGetArticulo, ( D():Get( "CliAtp", nView ) ), nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oCosto ),;
                    .f. ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp1 VAR cSayVp1;
         ID       251 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oSayPr2 VAR cSayPr2;
         ID       999 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aCVALPR2 ] VAR aTmp[ _aCVALPR2 ];
         ID       260 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode == APPD_MODE ) ;
         ON HELP  ( brwPropiedadActual( aGet[ _aCVALPR2 ], oSayVp2, aTmp[ _aCCODPR2 ] ) ) ;
         VALID    ( if( lPrpAct( aGet[ _aCVALPR2 ], oSayVp2, aTmp[ _aCCODPR2 ], dbfProL ),;
                    IsCliAtp( aGet, aTmp, oGetArticulo, ( D():Get( "CliAtp", nView ) ), nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oCosto ),;
                    .f. ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSayVp2 VAR cSayVp2;
         ID       261 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPRCCOM ] VAR aTmp[ _aNPRCCOM ];
         ID       120 ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         VALID    ( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         SPINNER  ;
         PICTURE  cPinDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ _aLPRCCOM ] VAR aTmp[ _aLPRCCOM ] ;
         ID       122 ;
         ON CHANGE( lChangeCostoParticular( aGet, aTmp, oCosto, nMode ) );
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oCosto VAR cCosto;
         ID       123 ;
         WHEN     ( .f. );
         SPINNER  ;
         PICTURE  cPinDiv ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _aNPRCART ] VAR aTmp[ _aNPRCART ];
         ID       121 ;
         SPINNER  ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE .and. !( D():Get( "Articulo", nView ) )->lIvaInc );
         VALID    ( CalIva( aTmp[ _aNPRCART ], ( D():Get( "Articulo", nView ) )->lIvaInc, ( D():Get( "Articulo", nView ) )->TipoIva, ( D():Get( "Articulo", nView ) )->cCodImp, aGet[ _aNPREIVA1 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPRCART2 ] VAR aTmp[ _aNPRCART2 ];
         ID       124 ;
         SPINNER  ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE .and. !( D():Get( "Articulo", nView ) )->lIvaInc );
         VALID    ( CalIva( aTmp[ _aNPRCART2 ], ( D():Get( "Articulo", nView ) )->lIvaInc, ( D():Get( "Articulo", nView ) )->TipoIva, ( D():Get( "Articulo", nView ) )->cCodImp, aGet[ _aNPREIVA2 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPRCART3 ] VAR aTmp[ _aNPRCART3 ];
         ID       125 ;
         SPINNER  ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE .and. !( D():Get( "Articulo", nView ) )->lIvaInc );
         VALID    ( CalIva( aTmp[ _aNPRCART3 ], ( D():Get( "Articulo", nView ) )->lIvaInc, ( D():Get( "Articulo", nView ) )->TipoIva, ( D():Get( "Articulo", nView ) )->cCodImp, aGet[ _aNPREIVA3 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPRCART4 ] VAR aTmp[ _aNPRCART4 ];
         ID       126 ;
         SPINNER  ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE .and. !( D():Get( "Articulo", nView ) )->lIvaInc );
         VALID    ( CalIva( aTmp[ _aNPRCART4 ], ( D():Get( "Articulo", nView ) )->lIvaInc, ( D():Get( "Articulo", nView ) )->TipoIva, ( D():Get( "Articulo", nView ) )->cCodImp, aGet[ _aNPREIVA4 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPRCART5 ] VAR aTmp[ _aNPRCART5 ];
         ID       127 ;
         SPINNER  ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE .and. !( D():Get( "Articulo", nView ) )->lIvaInc );
         VALID    ( CalIva( aTmp[ _aNPRCART5 ], ( D():Get( "Articulo", nView ) )->lIvaInc, ( D():Get( "Articulo", nView ) )->TipoIva, ( D():Get( "Articulo", nView ) )->cCodImp, aGet[ _aNPREIVA5 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPRCART6 ] VAR aTmp[ _aNPRCART6 ];
         ID       128 ;
         SPINNER  ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE .and. !( D():Get( "Articulo", nView ) )->lIvaInc );
         VALID    ( CalIva( aTmp[ _aNPRCART6 ], ( D():Get( "Articulo", nView ) )->lIvaInc, ( D():Get( "Articulo", nView ) )->TipoIva, ( D():Get( "Articulo", nView ) )->cCodImp, aGet[ _aNPREIVA6 ] ),lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[1]

      /*
      Precios con impuestos----------------------------------------------------
      */

      REDEFINE GET aGet[ _aNPREIVA1 ] VAR aTmp[ _aNPREIVA1 ] ;
         ID       300 ;
         SPINNER ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .AND. nMode != ZOOM_MODE .and. ( D():Get( "Articulo", nView ) )->lIvaInc ) ;
         VALID    ( CalBas( aTmp[ _aNPREIVA1 ], ( D():Get( "Articulo", nView ) )->lIvaInc, ( D():Get( "Articulo", nView ) )->TipoIva, ( D():Get( "Articulo", nView ) )->cCodImp, aGet[ _aNPRCART ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPREIVA2 ] VAR aTmp[ _aNPREIVA2 ] ;
         ID       310 ;
         PICTURE  cPouDiv ;
         SPINNER ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .AND. nMode != ZOOM_MODE .and. ( D():Get( "Articulo", nView ) )->lIvaInc ) ;
         VALID    ( CalBas( aTmp[ _aNPREIVA2 ], ( D():Get( "Articulo", nView ) )->lIvaInc, ( D():Get( "Articulo", nView ) )->TipoIva, ( D():Get( "Articulo", nView ) )->cCodImp, aGet[ _aNPRCART2 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPREIVA3 ] VAR aTmp[ _aNPREIVA3 ] ;
         ID       320 ;
         SPINNER ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .AND. nMode != ZOOM_MODE .and. ( D():Get( "Articulo", nView ) )->lIvaInc ) ;
         VALID    ( CalBas( aTmp[ _aNPREIVA3 ], ( D():Get( "Articulo", nView ) )->lIvaInc, ( D():Get( "Articulo", nView ) )->TipoIva, ( D():Get( "Articulo", nView ) )->cCodImp, aGet[ _aNPRCART3 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPREIVA4 ] VAR aTmp[ _aNPREIVA4 ] ;
         ID       330 ;
         SPINNER ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .AND. nMode != ZOOM_MODE .and. ( D():Get( "Articulo", nView ) )->lIvaInc ) ;
         VALID    ( CalBas( aTmp[ _aNPREIVA4 ], ( D():Get( "Articulo", nView ) )->lIvaInc, ( D():Get( "Articulo", nView ) )->TipoIva, ( D():Get( "Articulo", nView ) )->cCodImp, aGet[ _aNPRCART4 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPREIVA5 ] VAR aTmp[ _aNPREIVA5 ] ;
         ID       340 ;
         SPINNER ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .AND. nMode != ZOOM_MODE .and. ( D():Get( "Articulo", nView ) )->lIvaInc ) ;
         VALID    ( CalBas( aTmp[ _aNPREIVA5 ], ( D():Get( "Articulo", nView ) )->lIvaInc, ( D():Get( "Articulo", nView ) )->TipoIva, ( D():Get( "Articulo", nView ) )->cCodImp, aGet[ _aNPRCART5 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNPREIVA6 ] VAR aTmp[ _aNPREIVA6 ] ;
         ID       350 ;
         SPINNER ;
         PICTURE  cPouDiv ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .AND. nMode != ZOOM_MODE .and. ( D():Get( "Articulo", nView ) )->lIvaInc ) ;
         VALID    ( CalBas( aTmp[ _aNPREIVA6 ], ( D():Get( "Articulo", nView ) )->lIvaInc, ( D():Get( "Articulo", nView ) )->TipoIva, ( D():Get( "Articulo", nView ) )->cCodImp, aGet[ _aNPRCART6 ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTOART ] VAR aTmp[ _aNDTOART ];
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ( aTmp[_aNDTOART] >= 0 .AND. aTmp[_aNDTOART] <= 100 ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ))  ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         PICTURE  "@E 999.99";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTODIV ] VAR aTmp[ _aNDTODIV ];
         ID       135 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         VALID    ( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         PICTURE  cPouDiv ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_aNDPRART] VAR aTmp[_aNDPRART];
         ID       601 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ( aTmp[_aNDPRART] >= 0 .AND. aTmp[_aNDPRART] <= 100 ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) ) ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         PICTURE  "@E 999.99";
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aTmp[ _aLCOMAGE ] ;
         ID       151 ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNCOMAGE ] VAR aTmp[ _aNCOMAGE ];
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ( aTmp[_aNCOMAGE] >= 0 .AND. aTmp[_aNCOMAGE] <= 100 ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) ) ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         PICTURE  "@E 999.99";
         OF       oFld:aDialogs[1]

      REDEFINE GROUP oSayLabels[ 1 ]   ID 700 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE GROUP oSayLabels[ 2 ]   ID 701 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE GROUP oSayLabels[ 3 ]   ID 702 OF oFld:aDialogs[ 1 ] TRANSPARENT
      REDEFINE SAY   oSayLabels[ 4 ]   ID 703 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 5 ]   ID 704 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 6 ]   ID 705 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 7 ]   ID 706 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 8 ]   ID 707 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 9 ]   ID 708 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 10]   ID 709 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 11]   ID 710 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 12]   ID 711 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 13]   ID 712 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 14]   ID 713 OF oFld:aDialogs[ 1 ]
      REDEFINE SAY   oSayLabels[ 15]   ID 714 OF oFld:aDialogs[ 1 ]
      REDEFINE GROUP oSayLabels[ 16]   ID 715 OF oFld:aDialogs[ 1 ] TRANSPARENT

      REDEFINE GET aGet[ _aNDTO1 ] VAR aTmp[ _aNDTO1 ];
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ( aTmp[ _aNDTO1 ] >= 0 .AND. aTmp[ _aNDTO1 ] <= 100 ) ) ;
         PICTURE  "@E 999.99";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTO2 ] VAR aTmp[ _aNDTO2 ];
         ID       410 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ( aTmp[ _aNDTO2 ] >= 0 .AND. aTmp[ _aNDTO2 ] <= 100 ) ) ;
         PICTURE  "@E 999.99";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTO3 ] VAR aTmp[ _aNDTO3 ];
         ID       420 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ( aTmp[ _aNDTO3 ] >= 0 .AND. aTmp[ _aNDTO3 ] <= 100 ) ) ;
         PICTURE  "@E 999.99";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTO4 ] VAR aTmp[ _aNDTO4 ];
         ID       430 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ( aTmp[ _aNDTO4 ] >= 0 .AND. aTmp[ _aNDTO4 ] <= 100 ) ) ;
         PICTURE  "@E 999.99";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTO5 ] VAR aTmp[ _aNDTO5 ];
         ID       440 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ( aTmp[ _aNDTO5 ] >= 0 .AND. aTmp[ _aNDTO5 ] <= 100 ) ) ;
         PICTURE  "@E 999.99";
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _aNDTO6 ] VAR aTmp[ _aNDTO6 ];
         ID       450 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         VALID    ( ( aTmp[ _aNDTO6 ] >= 0 .AND. aTmp[ _aNDTO6 ] <= 100 ) ) ;
         PICTURE  "@E 999.99";
         OF       oFld:aDialogs[1]

      /*
      Segunda caja de dialogo--------------------------------------------------
      */

      REDEFINE GET aGet[ _aDFECINI ] VAR aTmp[ _aDFECINI ];
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _aDFECFIN ] VAR aTmp[ _aDFECFIN ];
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE );
         SPINNER ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aTmp[ _aLAPLPRE ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aTmp[ _aLAPLPED ] ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aTmp[ _aLAPLALB ] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aTmp[ _aLAPLFAC ] ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aTmp[ _aLAPLSAT ] ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]   

      /*
      Ofertas de X*Y
      */

      REDEFINE RADIO aGet[ _aNTIPXBY ] VAR aTmp[ _aNTIPXBY ] ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE ) ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         ID       220, 221 ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _aNUNVOFE ] VAR aTmp[ _aNUNVOFE ] ;
         ID       230 ;
         PICTURE  "@E 999" ;
         SPINNER ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and. nMode != ZOOM_MODE ) ;
         VALID    ( isBig( aTmp[ _aNUNVOFE ], aTmp[ _aNUNCOFE ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) ) ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _aNUNCOFE ] VAR aTmp[ _aNUNCOFE ] ;
         ID       240 ;
         PICTURE  "@E 999" ;
         SPINNER ;
         WHEN     ( aTmp[ _aNTIPATP ] <= 1 .and.  nMode != ZOOM_MODE ) ;
         VALID    ( isBig( aTmp[ _aNUNVOFE ], aTmp[ _aNUNCOFE ] ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) ) ;
         ON CHANGE( lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) );
         OF       oFld:aDialogs[2]

      /*
      Estudio rentabilidad - segunda pestaña-----------------------------------
      */

      REDEFINE COMBOBOX oSobre VAR cSobre ;
         ITEMS    aSobre ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      oSobre:bChange := {|| lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) }

      REDEFINE LISTBOX oBrwRen ;
         FIELDS ;
                  if( aRentabilidad[ oBrwRen:nAt, 5 ], LoadBitmap( GetResources(), "BALERT" ), "" ) ,;
                  aRentabilidad[ oBrwRen:nAt, 1 ],;
                  aRentabilidad[ oBrwRen:nAt, 2 ],;
                  if( !aRentabilidad[ oBrwRen:nAt, 4 ], Trans( aRentabilidad[ oBrwRen:nAt, 3 ], cPouEmp ), Trans( aRentabilidad[ oBrwRen:nAt, 3 ], "999.99" ) + " %" ),;
                  if( !aRentabilidad[ oBrwRen:nAt, 4 ], Trans( nCnv2Div( aRentabilidad[ oBrwRen:nAt, 3 ], cDivEmp(), cDivChg() ), cPouChg ), "" ),;
                  "";
         HEAD ;
                  "",;
                  "Naturaleza",;
                  "Tipo",;
                  "Importe " + cDivEmp(),;
                  "Importe " + cDivChg(),;
                  "";
         FIELDSIZES;
                  16,;
                  97,;
                  48,;
                  70,;
                  70,;
                  10;
         ID       450 ;
         OF       oDlg

         oBrwRen:SetArray( aRentabilidad )
         oBrwRen:nClrText       := { || if( aRentabilidad[ oBrwRen:nAt, 3 ] < 0 , CLR_HRED, CLR_BLACK ) }
         oBrwRen:aJustify       := { .f., .f., .t., .t., .t., .f. }

      /*
      Botones comunes de la caja de diálogo
      */

      REDEFINE BUTTON oBtnRen ;
         ID       600 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( lExpandir( oDlg, oBtnRen ), lArrayRen( oSobre:nAt, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto ) )

      REDEFINE BUTTON ;
         ID       IDOK;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveEdtAtp( aGet, aTmp, dbfTmpAtp, oBrw, oDlg, nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| SaveEdtAtp( aGet, aTmp, dbfTmpAtp, oBrw, oDlg, nMode ) } )
      end if

      oDlg:bStart := {|| StartEdtAtp( aTmp, aGet, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGetArticulo, oGetFamilia, oSayLabels, oCosto, oBtnRen ) }

   ACTIVATE DIALOG oDlg CENTER ;
         ON INIT  ( lExpandir( oDlg, oBtnRen, .f. ), if( nMode != APPD_MODE, aGet[ _aCCODART ]:lValid(), ), EdtDetMenu( aGet[ _aCCODART ], oDlg, lArticuloEnOferta( aTmp[ _aCCODART ], aTmpCli[ _COD ], aTmpCli[ _CCODGRP ] ) ) )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function StartEdtAtp( aTmp, aGet, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGetArticulo, oGetFamilia, oSayLabels, oCosto, oBtnRen )

   cValoresProp( aTmp, aGet, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2 )

   if !lUsrMaster()
      oBtnRen:Hide()
   else
      oBtnRen:Show()
   end if

   lChangeCostoParticular( aGet, aTmp, oCosto, nMode )

   if aGet[ _aNTIPATP ]:nAt == 1
      aGet[ _aCCODART ]:SetFocus()
   else
      aGet[ _aCCODFAM ]:SetFocus()
   end if

   ChangeNaturaleza( aGet, aTmp, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGetArticulo, oGetFamilia, oCosto, nMode, oSayLabels, .t. )

Return nil

//---------------------------------------------------------------------------//

Static Function lExpandir( oDlg, oBtn, lSet )

   local oRect    := oDlg:GetRect()

   if lSet != nil
      lExpandida  := lSet
   end if

   if lExpandida
      SetWindowText( oBtn:hWnd, "Retabilidad <" )
      oDlg:Move( oRect:nTop, oRect:nLeft, 800, 522, .t. )
   else
      SetWindowText( oBtn:hWnd, "Retabilidad >" )
      oDlg:Move( oRect:nTop, oRect:nLeft, 463, 522, .t. )
   end if

   lExpandida  := !lExpandida

return .t.

//---------------------------------------------------------------------------//

Static Function cValoresProp( aTmp, aGet, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2 )

   if nMode == APPD_MODE

      oSayPr1:Hide()
      oSayPr2:Hide()
      oSayVp1:Hide()
      oSayVp2:Hide()
      aGet[ _aCVALPR1 ]:Hide()
      aGet[ _aCVALPR2 ]:Hide()

   else

      if aTmp[ _aNTIPATP ] == 2

         oSayPr1:Hide()
         oSayVp1:Hide()
         aGet[ _aCVALPR1 ]:Hide()
         oSayPr2:Hide()
         oSayVp2:Hide()
         aGet[ _aCVALPR2 ]:Hide()

      else

         if Empty( aTmp[ _aCCODPR1 ] )
            oSayPr1:Hide()
            oSayVp1:Hide()
            aGet[ _aCVALPR1 ]:Hide()
         else
            oSayPr1:Show()
            oSayVp1:Show()
            aGet[ _aCVALPR1 ]:Show()
            oSayPr1:Disable()
         end if

         if Empty( aTmp[ _aCCODPR2 ] )
            oSayPr2:Hide()
            oSayVp2:Hide()
            aGet[ _aCVALPR2 ]:Hide()
         else
            oSayPr2:Disable()
            oSayPr2:Show()
            oSayVp2:Show()
            aGet[ _aCVALPR2 ]:Show()
         end if

      end if

   end if

Return nil

//--------------------------------------------------------------------------//
/*
Chequea las cuentas de contaplus
*/

STATIC FUNCTION ChkAllSubCta()

   local oDlg
   local cArea
   local nRecno      
   local cTag        
   local oChkCreate
   local lChkCreate  
   local oChkCuenta
   local lChkCuenta  
   local aMsg        
   local oTree
   local cCliOrg
   local cCliDes
   local oCliOrg
   local oCliDes
   local oSayCliOrg
   local oSayCliDes
   local cSayCliOrg
   local cSayCliDes
   local oImageList
   local cRuta       
   local cCodEmp     

   // Comprobaciones de contaplus----------------------------------------------

   if lAplicacionContaplus()

      cRuta             := cRutCnt()
      cCodEmp           := cEmpCnt( "A" )

      if Empty( cRuta ) .or. Empty( cCodEmp )
         msgStop( "No existe enlace a contaplus ®" )
         return .f.
      end if

      if !OpenSubCuenta( cRuta, cCodEmp, @cArea, .f. )
         msgStop( "Imposible acceder a ficheros de contaplus ®" )
         return .t.
      end if

   end if 

   /*
   Obtenemos los valores del primer y ultimo codigo----------------------------
   */

   nRecno            := ( D():Get( "Client", nView ) )->( RecNo() )
   cTag              := ( D():Get( "Client", nView ) )->( OrdSetFocus( 1 ) )
   lChkCreate        := .f.
   lChkCuenta        := .f.
   aMsg              := {}

   cCliOrg           := dbFirst( ( D():Get( "Client", nView ) ), 1 )
   cCliDes           := dbLast(  ( D():Get( "Client", nView ) ), 1 )
   cSayCliOrg        := dbFirst( ( D():Get( "Client", nView ) ), 2 )
   cSayCliDes        := dbLast(  ( D():Get( "Client", nView ) ), 2 )

   oImageList        := TImageList():New( 16, 16 )
   oImageList:AddMasked( TBitmap():Define( "bRed" ),     Rgb( 255, 0, 255 ) )
   oImageList:AddMasked( TBitmap():Define( "bGreen" ),   Rgb( 255, 0, 255 ) )

   /*
   Llamada a la funcion que activa la caja de dialogo--------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "ChkAllSubCta"

   /*
   Monta los clientes----------------------------------------------------------
   */

   REDEFINE GET oCliOrg VAR cCliOrg;
      ID       80 ;
      VALID    cClient( oCliOrg, ( D():Get( "Client", nView ) ), oSayCliOrg );
      BITMAP   "LUPA" ;
      ON HELP  BrwCli( oCliOrg, oSayCliOrg, ( D():Get( "Client", nView ) ) );
      OF       oDlg

   REDEFINE GET oSayCliOrg VAR cSayCliOrg ;
      WHEN     .f.;
      ID       81 ;
      OF       oDlg

   REDEFINE GET oCliDes VAR cCliDes;
      ID       90 ;
      VALID    cClient( oCliDes, ( D():Get( "Client", nView ) ), oSayCliDes );
      BITMAP   "LUPA" ;
      ON HELP  BrwCli( oCliDes, oSayCliDes, ( D():Get( "Client", nView ) ) );
      OF       oDlg

   REDEFINE GET oSayCliDes VAR cSayCliDes ;
      WHEN     .f.;
      ID       91 ;
      OF       oDlg

   REDEFINE CHECKBOX oChkCuenta VAR lChkCuenta ;
      ID       110 ;
      OF       oDlg

   REDEFINE CHECKBOX oChkCreate VAR lChkCreate ;
      ID       100 ;
      WHEN     lAplicacionContaplus() ;
      OF       oDlg

   oTree       := TTreeView():Redefine( 170, oDlg )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( MakAllSubCta( cCliOrg, cCliDes, lChkCuenta, lChkCreate, cArea, aMsg, oTree, oDlg ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg ;
      CENTER ;
      ON INIT  ( oTree:SetImageList( oImageList ) )

   ( D():Get( "Client", nView ) )->( dbGoTo( nRecno ) )
   ( D():Get( "Client", nView ) )->( OrdSetFocus( cTag ) )

   if lAplicacionContaplus()
      CLOSE ( cArea )
   end if 

   oImageList:End()

   oTree:Destroy()

   oWndBrw:oBrw:SetFocus()
   oWndBrw:oBrw:Refresh()

return .t.

//-------------------------------------------------------------------------//

Static Function MakAllSubCta( cCliOrg, cCliDes, lChkCuenta, lChkCreate, cArea, aMsg, oTree, oDlg )

   local nLen
   local oItem

   oDlg:Disable()

   oTree:DeleteAll()

   nLen              := nLenCuentaContaplus()

   if ( D():Get( "Client", nView ) )->( dbSeek( cCliOrg ) )

      while ( D():Get( "Client", nView ) )->Cod <= cCliDes .and. !( D():Get( "Client", nView ) )->( Eof() )

         if Empty( AllTrim( ( D():Get( "Client", nView ) )->SubCta ) ) .and. lChkCuenta
            if dbLock( D():Get( "Client", nView ) )
               ( D():Get( "Client", nView ) )->SubCta      := "430" + strzero( val( alltrim( ( D():Get( "Client", nView ) )->Cod ) ), nLen )
               ( D():Get( "Client", nView ) )->( dbUnLock() )
            end if
         end if

         // Creamos la subcuenta en contaplus----------------------------------

         if lAplicacionContaplus()

            if !Empty( AllTrim( ( D():Get( "Client", nView ) )->SubCta ) )

               if !( cArea )->( dbSeek( ( D():Get( "Client", nView ) )->SubCta, .t. ) )

                  if lChkCreate .or. ApoloMsgNoYes(   "Subcuenta : " + Rtrim( ( D():Get( "Client", nView ) )->SubCta ) + " no existe" + CRLF + ;
                                                      "¿ Desea crearla ?",;
                                                      "Enlace con contaplus ®" )

                     ( cArea )->( dbAppend() )
                     ( cArea )->Cod         := ( D():Get( "Client", nView ) )->Subcta
                     ( cArea )->Titulo      := ( D():Get( "Client", nView ) )->Titulo
                     ( cArea )->Nif         := ( D():Get( "Client", nView ) )->Nif
                     ( cArea )->Domicilio   := ( D():Get( "Client", nView ) )->Domicilio
                     ( cArea )->Poblacion   := ( D():Get( "Client", nView ) )->Poblacion
                     ( cArea )->Provincia   := ( D():Get( "Client", nView ) )->Provincia
                     ( cArea )->CodPostal   := ( D():Get( "Client", nView ) )->CodPostal
                     ( cArea )->( dbCommit() )

                     oItem := oTree:Add( "Cuenta " + Rtrim( ( D():Get( "Client", nView ) )->Subcta ) + " del cliente " + Rtrim( ( D():Get( "Client", nView ) )->Cod ) + ", " + Rtrim( ( D():Get( "Client", nView ) )->Titulo ) + " creada", 1 )

                  else

                     oItem := oTree:Add( "Cuenta " + Rtrim( ( D():Get( "Client", nView ) )->Subcta ) + " del cliente " + Rtrim( ( D():Get( "Client", nView ) )->Cod ) + ", " + Rtrim( ( D():Get( "Client", nView ) )->Titulo ) + " creación cancelada", 1 )

                  end if

               else

                  oItem    := oTree:Add( "Cuenta " + Rtrim( ( D():Get( "Client", nView ) )->Subcta ) + " del cliente " + Rtrim( ( D():Get( "Client", nView ) )->Cod ) + ", " + Rtrim( ( D():Get( "Client", nView ) )->Titulo ) + " ya existe", 0 )

               end if

            else

               oItem       := oTree:Add( "El Cliente : " + Rtrim( ( D():Get( "Client", nView ) )->Cod ) + ", " + Rtrim( ( D():Get( "Client", nView ) )->Titulo ) + " no tiene codificada cuenta en Contaplus", 0 )

            end if

            oTree:Select( oItem )

         end if 

         SysRefresh()

         ( D():Get( "Client", nView ) )->( dbSkip() )

      end do

   end if

   MsgInfo( "Proceso finalizado" )

   oDlg:Enable()

Return nil

//---------------------------------------------------------------------------//

/*
Devuelve la estructura de la base de datos en funcion del codigo de cliente
*/

STATIC FUNCTION CnfCli()

   local oDlg
   local cIniCli  := cPatEmp() + "Client.Ini"

   DEFINE DIALOG oDlg RESOURCE "CNF_DEF_CLI" TITLE "Configurar clientes"

      REDEFINE GET aIniCli[ 1 ] ID 110 OF oDlg

      REDEFINE GET aIniCli[ 2 ] ID 120 OF oDlg

      REDEFINE GET aIniCli[ 3 ] ID 130 OF oDlg

      REDEFINE GET aIniCli[ 4 ] ID 140 OF oDlg

      REDEFINE GET aIniCli[ 5 ] ID 150 OF oDlg

      REDEFINE GET aIniCli[ 6 ] ID 160 OF oDlg

      REDEFINE GET aIniCli[ 7 ] ID 170 OF oDlg

      REDEFINE GET aIniCli[ 8 ] ID 180 OF oDlg

      REDEFINE GET aIniCli[ 9 ] ID 190 OF oDlg

      REDEFINE GET aIniCli[ 10 ] ID 200 OF oDlg

      REDEFINE COMBOBOX aIniCli[ 11 ] ID 210 UPDATE ITEMS { "Todas", "Activas" } OF oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( WrtIniCli( cIniCli, ), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| WrtIniCli( cIniCli, ), oDlg:end( IDOK ) } )

   // oDlg:bStart := {|| aIniCli[ 1 ] }

   ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION WrtIniCli( cIniCli )

   WritePProString( "campos", "1", aIniCli[ 1 ], cIniCli )
   WritePProString( "campos", "2", aIniCli[ 2 ], cIniCli )
   WritePProString( "campos", "3", aIniCli[ 3 ], cIniCli )
   WritePProString( "campos", "4", aIniCli[ 4 ], cIniCli )
   WritePProString( "campos", "5", aIniCli[ 5 ], cIniCli )
   WritePProString( "campos", "6", aIniCli[ 6 ], cIniCli )
   WritePProString( "campos", "7", aIniCli[ 7 ], cIniCli )
   WritePProString( "campos", "8", aIniCli[ 8 ], cIniCli )
   WritePProString( "campos", "9", aIniCli[ 9 ], cIniCli )
   WritePProString( "campos", "10",aIniCli[ 10], cIniCli )
   WritePProString( "filtro", "ft",aIniCli[ 11], cIniCli )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION lSndCli( oWndBrw, lVal )

   local nRecAct
   local nRecOld           := ( D():Get( "Client", nView ) )->( Recno() )

   for each nRecAct in ( oWndBrw:oBrw:aSelected )
      ( D():Get( "Client", nView ) )->( dbGoTo( nRecAct ) )

      if dbDialogLock( D():Get( "Client", nView ) )

         if Empty( lVal )
            ( D():Get( "Client", nView ) )->lSndInt  := !( D():Get( "Client", nView ) )->lSndInt
         else
            ( D():Get( "Client", nView ) )->lSndInt  := lVal
         end if

         ( D():Get( "Client", nView ) )->( dbUnlock() )

      end if

   next

   ( D():Get( "Client", nView ) )->( dbGoTo( nRecOld ) )

   oWndBrw:Refresh()

   oWndBrw:oBrw:Select()

Return nil

//---------------------------------------------------------------------------//

/*
Devuelve el codigo del Grupo de Cliente de un cliente determinado
*/

FUNCTION RetGrpCli( cCodCli, dbfCli )

   local cGrpCli  := ""

   if dbSeekInOrd( cCodCli, "Cod", dbfCli )
      cGrpCli     := ( dbfCli )->cCodGrp
   end if

RETURN ( cGrpCli )

//----------------------------------------------------------------------------//

function CalRiesgo()

return ( 0 )

//---------------------------------------------------------------------------//

function SetRiesgo()

return ( 0 )

//---------------------------------------------------------------------------//

static function AddFamilia( oBrwAtp, dbfTmpAtp, cCodCli )

   local oDlg
   local nPre        := aFill( Array( 6 ), 0 )
   local aPre        := aFill( Array( 6 ), .f. )
   local nDto        := aFill( Array( 6 ), 0 )
   local nDtoArt     := 0
   local nDtoDiv     := 0
   local nDprArt     := 0
   local nComAge     := 0
   local dFecIni     := Ctod( "" )
   local dFecFin     := Ctod( "" )
   local lAplPre     := .t.
   local lAplPed     := .t.
   local lAplAlb     := .t.
   local lAplFac     := .t.
   local lAplSat     := .t.
   local oFamIni
   local cFamIni     := dbFirst( dbfFamilia, 1 )
   local oFamIniTxt
   local cFamIniTxt  := ""
   local oFamFin
   local cFamFin     := dbLast( dbfFamilia, 1 )
   local oFamFinTxt
   local cFamFinTxt  := ""
   local oBtnOk

   DEFINE DIALOG oDlg RESOURCE "AddFamilia"

   REDEFINE GET oFamIni VAR cFamIni;
      ID       100 ;
      VALID    cFamilia( oFamIni, dbfFamilia, oFamIniTxt ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwFamilia( oFamIni, oFamIniTxt ) ;
      OF       oDlg

   REDEFINE GET oFamIniTxt VAR cFamIniTxt ;
      ID       110 ;
      WHEN     .f.;
      OF       oDlg

   REDEFINE GET oFamFin VAR cFamFin;
      ID       120 ;
      VALID    cFamilia( oFamFin, dbfFamilia, oFamFinTxt ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwFamilia( oFamFin, oFamFinTxt ) ;
      OF       oDlg

   REDEFINE GET oFamFinTxt VAR cFamFinTxt ;
      ID       130 ;
      WHEN     .f.;
      OF       oDlg

   REDEFINE CHECKBOX aPre[ 1 ] ;
      ID       140 ;
      OF       oDlg

   REDEFINE CHECKBOX aPre[ 2 ] ;
      ID       141 ;
      OF       oDlg

   REDEFINE CHECKBOX aPre[ 3 ] ;
      ID       142 ;
      OF       oDlg

   REDEFINE CHECKBOX aPre[ 4 ] ;
      ID       143 ;
      OF       oDlg

   REDEFINE CHECKBOX aPre[ 5 ] ;
      ID       144 ;
      OF       oDlg

   REDEFINE CHECKBOX aPre[ 6 ] ;
      ID       145 ;
      OF       oDlg

   REDEFINE GET nPre[ 1 ];
      ID       250 ;
      SPINNER ;
      WHEN     ( !aPre[ 1 ] );
      PICTURE  cPouDiv ;
      OF       oDlg

   REDEFINE GET nPre[ 2 ];
      ID       251 ;
      SPINNER ;
      WHEN     ( !aPre[ 2 ] );
      PICTURE  cPouDiv ;
      OF       oDlg

   REDEFINE GET nPre[ 3 ];
      ID       252 ;
      SPINNER ;
      WHEN     ( !aPre[ 3 ] );
      PICTURE  cPouDiv ;
      OF       oDlg

   REDEFINE GET nPre[ 4 ];
      ID       253 ;
      SPINNER ;
      WHEN     ( !aPre[ 4 ] );
      PICTURE  cPouDiv ;
      OF       oDlg

   REDEFINE GET nPre[ 5 ];
      ID       254 ;
      SPINNER ;
      WHEN     ( !aPre[ 5 ] );
      PICTURE  cPouDiv ;
      OF       oDlg

   REDEFINE GET nPre[ 6 ];
      ID       255 ;
      SPINNER ;
      WHEN     ( !aPre[ 6 ] );
      PICTURE  cPouDiv ;
      OF       oDlg

   REDEFINE GET nDto[ 1 ];
      ID       400 ;
      SPINNER ;
      VALID    nDto[ 1 ] >= 0 .and. nDto[ 1 ] <= 100 ;
      PICTURE  "@E 999.99" ;
      OF       oDlg

   REDEFINE GET nDto[ 2 ];
      ID       410 ;
      SPINNER ;
      VALID    nDto[ 2 ] >= 0 .and. nDto[ 2 ] <= 100 ;
      PICTURE  "@E 999.99" ;
      OF       oDlg

   REDEFINE GET nDto[ 3 ];
      ID       420 ;
      SPINNER ;
      VALID    nDto[ 3 ] >= 0 .and. nDto[ 3 ] <= 100 ;
      PICTURE  "@E 999.99" ;
      OF       oDlg

   REDEFINE GET nDto[ 4 ];
      ID       430 ;
      SPINNER ;
      VALID    nDto[ 4 ] >= 0 .and. nDto[ 4 ] <= 100 ;
      PICTURE  "@E 999.99" ;
      OF       oDlg

   REDEFINE GET nDto[ 5 ];
      ID       440 ;
      SPINNER ;
      VALID    nDto[ 5 ] >= 0 .and. nDto[ 5 ] <= 100 ;
      PICTURE  "@E 999.99" ;
      OF       oDlg

   REDEFINE GET nDto[ 6 ];
      ID       450 ;
      SPINNER ;
      VALID    nDto[ 6 ] >= 0 .and. nDto[ 6 ] <= 100 ;
      PICTURE  "@E 999.99" ;
      OF       oDlg

   REDEFINE GET nDtoArt;
      ID       150 ;
      SPINNER ;
      VALID    nDtoArt >= 0 .AND. nDtoArt <= 100 ;
      PICTURE  "@E 999.99";
      OF       oDlg

   REDEFINE GET nDtoDiv;
      ID       160 ;
      SPINNER ;
      PICTURE  cPouDiv ;
      OF       oDlg

   REDEFINE GET nDprArt;
      ID       170 ;
      SPINNER ;
      VALID    nDprArt >= 0 .AND. nDprArt <= 100 ;
      PICTURE  "@E 999.99";
      OF       oDlg

   REDEFINE GET nComAge ;
      ID       180 ;
      SPINNER ;
      VALID    nComAge >= 0 .AND. nComAge <= 100 ;
      PICTURE  "@E 999.99";
      OF       oDlg

   REDEFINE GET dFecIni;
      ID       190 ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET dFecFin ;
      ID       200 ;
      SPINNER ;
      OF       oDlg

   REDEFINE CHECKBOX lAplPre ;
      ID       210 ;
      OF       oDlg

   REDEFINE CHECKBOX lAplPed ;
      ID       220 ;
      OF       oDlg

   REDEFINE CHECKBOX lAplAlb ;
      ID       230 ;
      OF       oDlg

   REDEFINE CHECKBOX lAplFac ;
      ID       240 ;
      OF       oDlg

   REDEFINE CHECKBOX lAplSat ;
      ID       260 ;
      OF       oDlg   

   /*
   Botones de la Caja de Dialogo__________________________________________
   */

   REDEFINE BUTTON oBtnOk ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   (  AddArtFam( cCodCli, cFamIni, cFamFin, aPre, nPre, nDto, nDtoArt, nDtoDiv, nDprArt, nComAge, dFecIni, dFecFin, lAplPre, lAplPed, lAplAlb, lAplFac, lAplSat, oDlg ),;
                  oBrwAtp:Refresh() )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )

   ACTIVATE DIALOG oDlg ON INIT ( oFamIni:lValid(), oFamFin:lValid() ) CENTER

return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION AddArtFam( cCodCli, cFamIni, cFamFin, aPre, nPre, nDto, nDtoArt, nDtoDiv, nDprArt, nComAge, dFecIni, dFecFin, lAplPre, lAplPed, lAplAlb, lAplFac, lAplSat, oDlg )

   local nIvaPct  := 0
   local nOrdArt  := ( D():Get( "Articulo", nView ) )->( OrdSetFocus( "cFamCod" ) )
   local nRecAtp  := ( dbfTmpAtp )->( RecNo() )
   local nOrdAnt  := ( dbfTmpAtp )->( OrdSetFocus( "cCliArt" ) )

   oDlg:Disable()

   if ( dbfFamilia )->( dbSeek( cFamIni ) )

      while ( dbfFamilia )->cCodFam <= cFamFin .and. !( dbfFamilia )->( eof() )

         if ( D():Get( "Articulo", nView ) )->( dbSeek( ( dbfFamilia )->cCodFam ) )

            while ( D():Get( "Articulo", nView ) )->Familia == ( dbfFamilia )->cCodFam .and. !( D():Get( "Articulo", nView ) )->( eof() )

               /*
               Vamos a ver si el articulo ya existe
               */

               if !( dbfTmpAtp )->( dbSeek( ( D():Get( "Articulo", nView ) )->Codigo ) )

                  nIvaPct                    := nIva( D():Get( "TIva", nView ), ( D():Get( "Articulo", nView ) )->TipoIva )

                  ( dbfTmpAtp )->( dbAppend() )

                  ( dbfTmpAtp )->cCodCli     := cCodCli
                  ( dbfTmpAtp )->cCodArt     := ( D():Get( "Articulo", nView ) )->Codigo

                  if aPre[ 1 ]
                     ( dbfTmpAtp )->nPrcArt  := ( D():Get( "Articulo", nView ) )->pVenta1
                  else
                     ( dbfTmpAtp )->nPrcArt  := nPre[ 1 ]
                  end if

                  if aPre[ 2 ]
                     ( dbfTmpAtp )->nPrcArt2 := ( D():Get( "Articulo", nView ) )->pVenta2
                  else
                     ( dbfTmpAtp )->nPrcArt2 := nPre[ 2 ]
                  end if

                  if aPre[ 3 ]
                     ( dbfTmpAtp )->nPrcArt3 := ( D():Get( "Articulo", nView ) )->pVenta3
                  else
                     ( dbfTmpAtp )->nPrcArt3 := nPre[ 3 ]
                  end if

                  if aPre[ 4 ]
                     ( dbfTmpAtp )->nPrcArt4 := ( D():Get( "Articulo", nView ) )->pVenta4
                  else
                     ( dbfTmpAtp )->nPrcArt4 := nPre[ 4 ]
                  end if

                  if aPre[ 5 ]
                     ( dbfTmpAtp )->nPrcArt5 := ( D():Get( "Articulo", nView ) )->pVenta5
                  else
                     ( dbfTmpAtp )->nPrcArt5 := nPre[ 5 ]
                  end if

                  if aPre[ 6 ]
                     ( dbfTmpAtp )->nPrcArt6 := ( D():Get( "Articulo", nView ) )->pVenta6
                  else
                     ( dbfTmpAtp )->nPrcArt6 := nPre[ 6 ]
                  end if

                  ( dbfTmpAtp )->nPreIva1    := ( dbfTmpAtp )->nPrcArt  + ( ( dbfTmpAtp )->nPrcArt  * nIvaPct / 100 )
                  ( dbfTmpAtp )->nPreIva2    := ( dbfTmpAtp )->nPrcArt2 + ( ( dbfTmpAtp )->nPrcArt2 * nIvaPct / 100 )
                  ( dbfTmpAtp )->nPreIva3    := ( dbfTmpAtp )->nPrcArt3 + ( ( dbfTmpAtp )->nPrcArt3 * nIvaPct / 100 )
                  ( dbfTmpAtp )->nPreIva4    := ( dbfTmpAtp )->nPrcArt4 + ( ( dbfTmpAtp )->nPrcArt4 * nIvaPct / 100 )
                  ( dbfTmpAtp )->nPreIva5    := ( dbfTmpAtp )->nPrcArt5 + ( ( dbfTmpAtp )->nPrcArt5 * nIvaPct / 100 )
                  ( dbfTmpAtp )->nPreIva6    := ( dbfTmpAtp )->nPrcArt6 + ( ( dbfTmpAtp )->nPrcArt6 * nIvaPct / 100 )

                  ( dbfTmpAtp )->nDtoArt     := nDtoArt
                  ( dbfTmpAtp )->nDtoDiv     := nDtoDiv
                  ( dbfTmpAtp )->nComAge     := nComAge
                  ( dbfTmpAtp )->dFecIni     := dFecIni
                  ( dbfTmpAtp )->dFecFin     := dFecFin
                  ( dbfTmpAtp )->lAplPre     := lAplPre
                  ( dbfTmpAtp )->lAplPed     := lAplPed
                  ( dbfTmpAtp )->lAplAlb     := lAplAlb
                  ( dbfTmpAtp )->lAplFac     := lAplFac
                  ( dbfTmpAtp )->lAplSat     := lAplSat

                  ( dbfTmpAtp )->nDto1       := nDto[ 1 ]
                  ( dbfTmpAtp )->nDto2       := nDto[ 2 ]
                  ( dbfTmpAtp )->nDto3       := nDto[ 3 ]
                  ( dbfTmpAtp )->nDto4       := nDto[ 4 ]
                  ( dbfTmpAtp )->nDto5       := nDto[ 5 ]
                  ( dbfTmpAtp )->nDto6       := nDto[ 6 ]

               end if

               ( D():Get( "Articulo", nView ) )->( dbSkip() )

            end while

         end if

         ( dbfFamilia )->( dbSkip() )

      end while

   end if

   oDlg:Enable()
   oDlg:End()

   ( D():Get( "Articulo", nView ) )->( OrdSetFocus( nOrdArt ) )
   ( dbfTmpAtp   )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTmpAtp   )->( dbGoTo( nRecAtp ) )

return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION ChgPrc( oWndBrw )

   local oDlg
   local cFam              := Space( 5 )
   local oFam
   local cTxtFam           := "Todas"
   local oTxtFam
   local cTipIva           := Space( 1 )
   local oTipIva
   local cTxtIva           := "Todos"
   local oTxtIva
   local lTarifa1          := .f.
   local lTarifa2          := .f.
   local lTarifa3          := .f.
   local lTarifa4          := .f.
   local lTarifa5          := .f.
   local lTarifa6          := .f.
   local cCliOrg
   local cCliDes
   local oCliOrg
   local oCliDes
   local oSayCliOrg
   local oSayCliDes
   local cSayCliOrg
   local cSayCliDes
   local oRad
   local nRad              := 1
   local nPctInc           := 0
   local nUndInc           := 0
   local aComBox           :=  { "Precio actual", "Precio 1", "Precio 2", "Precio 3", "Precio 4", "Precio 5", "Precio 6" }
   local oComBox
   local cComBox           := "Precio actual"
   local oMtr
   local nMtr              := 0
   local lRnd              := .f.
   local lGenerateTarifa   := .f.
   local lAppTarifaFecha   := .f.
   local nDec              := nRouDiv( cDivEmp() )
   local cArtOrg
   local cArtDes
   local oArtOrg
   local oArtDes
   local oSayArtOrg
   local oSayArtDes
   local cSayArtOrg
   local cSayArtDes
   local dIniPrc           := Date()
   local dFinPrc           := Ctod( "31/12/" + Str( Year( Date() ), 4 ) )
   local aStaCli           := aGetStatus( D():Get( "Client", nView ), .t. )

   // Obtenemos los valores del primer y ultimo codigo-------------------------

   cCliOrg                 := dbFirst( D():Get( "Client", nView ), 1 )
   cCliDes                 := dbLast ( D():Get( "Client", nView ), 1 )
   cSayCliOrg              := dbFirst( D():Get( "Client", nView ), 2 )
   cSayCliDes              := dbLast ( D():Get( "Client", nView ), 2 )

   cArtOrg                 := dbFirst( D():Get( "Articulo", nView ), 1 )
   cArtDes                 := dbLast ( D():Get( "Articulo", nView ), 1 )
   cSayArtOrg              := dbFirst( D():Get( "Articulo", nView ), 2 )
   cSayArtDes              := dbLast ( D():Get( "Articulo", nView ), 2 )

   // Llamada a la funcion que activa la caja de dialogo-----------------------

   DEFINE DIALOG oDlg RESOURCE "CHGPRECLI"

   /*
   Monta los clientes
   */

   REDEFINE GET oCliOrg VAR cCliOrg;
      ID       80 ;
      VALID    cClient( oCliOrg, ( D():Get( "Client", nView ) ), oSayCliOrg );
      BITMAP   "LUPA" ;
      ON HELP  BrwCli( oCliOrg, oSayCliOrg, D():Get( "Client", nView ) );
      OF       oDlg

   REDEFINE GET oSayCliOrg VAR cSayCliOrg ;
      WHEN     .f.;
      ID       81 ;
      OF       oDlg

   REDEFINE GET oCliDes VAR cCliDes;
      ID       90 ;
      VALID    cClient( oCliDes, D():Get( "Client", nView ), oSayCliDes );
      BITMAP   "LUPA" ;
      ON HELP  BrwCli( oCliDes, oSayCliDes, D():Get( "Client", nView ) );
      OF       oDlg

   REDEFINE GET oSayCliDes VAR cSayCliDes ;
      WHEN     .f.;
      ID       91 ;
      OF       oDlg

   /*
   Monta los artículos
   */

   REDEFINE GET oArtOrg VAR cArtOrg;
      ID       200 ;
      VALID    cArticulo( oArtOrg, D():Get( "Articulo", nView ), oSayArtOrg );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArtOrg, oSayArtOrg );
      OF       oDlg

   REDEFINE GET oSayArtOrg VAR cSayArtOrg ;
      WHEN     .F.;
      ID       201 ;
      OF       oDlg

   REDEFINE GET oArtDes VAR cArtDes;
      ID       210 ;
      VALID    cArticulo( oArtDes, D():Get( "Articulo", nView ), oSayArtDes );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArtDes, oSayArtDes );
      OF       oDlg

   REDEFINE GET oSayArtDes VAR cSayArtDes ;
      WHEN     .F.;
      ID       211 ;
      OF       oDlg

   /*
   Monta las familias
   */

   REDEFINE GET oFam VAR cFam ;
      ID       100 ;
      VALID    ( cFamilia( oFam, , oTxtFam ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFamilia( oFam, oTxtFam ) );
      COLOR    CLR_GET ;
      OF       oDlg

   REDEFINE GET oTxtFam VAR cTxtFam ;
      ID       110 ;
      WHEN     .F. ;
      COLOR    CLR_GET ;
      OF       oDlg

   /*
   Monta los tipos de impuestos
   */

   REDEFINE GET oTipIva VAR cTipIva ;
      ID       120 ;
      PICTURE  "@!" ;
      VALID    ( cTiva( oTipIva, D():Get( "TIva", nView ), oTxtIva ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwIva( oTipIva, nil, oTxtIva ) );
      COLOR    CLR_GET ;
      OF       oDlg

   REDEFINE GET oTxtIva VAR cTxtIva ;
      ID       130 ;
      WHEN     .F. ;
      COLOR    CLR_GET ;
      OF       oDlg

   /*
   Elige si quiere redondeo y la cantidad
   */

   REDEFINE CHECKBOX lGenerateTarifa ;
      ID       300 ;
      OF       oDlg

   REDEFINE GET dIniPrc;
      ID       230 ;
      SPINNER;
      WHEN     lGenerateTarifa;
      OF       oDlg

   REDEFINE GET dFinPrc;
      ID       240 ;
      SPINNER;
      WHEN     lGenerateTarifa;
      OF       oDlg

   REDEFINE CHECKBOX lAppTarifaFecha ;
      ID       310 ;
      OF       oDlg

   /*
   Montamos los check para elegir que precio o precios cambiar
   */

   REDEFINE CHECKBOX lTarifa1 ;
      ID       161 ;
      OF       oDlg

   REDEFINE CHECKBOX lTarifa2 ;
      ID       162 ;
      OF       oDlg

   REDEFINE CHECKBOX lTarifa3 ;
      ID       163 ;
      OF       oDlg

   REDEFINE CHECKBOX lTarifa4 ;
      ID       164 ;
      OF       oDlg

   REDEFINE CHECKBOX lTarifa5 ;
      ID       165 ;
      OF       oDlg

   REDEFINE CHECKBOX lTarifa6 ;
      ID       166 ;
      OF       oDlg

   /*
   Monta el combo para saber cual es la base sobre la que se hace en nuevo precio
   */

   REDEFINE COMBOBOX oComBox ;
      VAR      cComBox ;
      ID       218 ;
      ITEMS    aComBox ;
      OF       oDlg

   /*
   Monta el radio para elejir el tipo de descuente
   */

   REDEFINE RADIO oRad VAR nRad ;
      ID       170, 172 ;
      OF       oDlg

   /*
   Porcentual
   */

   REDEFINE GET nPctInc ;
      WHEN     ( nRad == 1 ) ;
      PICTURE  "@E 999.99" ;
      SPINNER ;
      ID       171 ;
      OF       oDlg

   /*
   Lineal
   */

   REDEFINE GET nUndInc ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  cPouDiv ;
      ID       173 ;
      OF       oDlg

   /*
   Elige si quiere redondeo y la cantidad
   */

   REDEFINE CHECKBOX lRnd ;
      ID       180 ;
      OF       oDlg

   REDEFINE GET nDec ;
      PICTURE  "@E 9" ;
      SPINNER ;
      ID       190 ;
      OF       oDlg

	REDEFINE APOLOMETER oMtr;
      VAR      nMtr ;
      PROMPT   "Procesando" ;
      ID       220 ;
      OF       oDlg ;
      TOTAL    ( D():Get( "CliAtp", nView ) )->( lastrec() )

   REDEFINE BUTTON ;
      ID       IDOK;
      OF       oDlg ;
      ACTION   ( mkChgPrc( cFam, cTipIva, cCliOrg, cCliDes, lTarifa1, lTarifa2, lTarifa3, lTarifa4, lTarifa5, lTarifa6, nRad, nPctInc, nUndInc, lRnd, nDec, oComBox, oMtr, oDlg, oWndBrw, cArtOrg, cArtDes, lGenerateTarifa, dIniPrc, dFinPrc, lAppTarifaFecha ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| mkChgPrc( cFam, cTipIva, cCliOrg, cCliDes, lTarifa1, lTarifa2, lTarifa3, lTarifa4, lTarifa5, lTarifa6, nRad, nPctInc, nUndInc, lRnd, nDec, oComBox, oMtr, oDlg, oWndBrw, cArtOrg, cArtDes, lGenerateTarifa, dIniPrc, dFinPrc, lAppTarifaFecha ) } )

   oDlg:bStart := {|| oCliOrg:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

   SetStatus( ( D():Get( "Client", nView ) ), aStaCli )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION mkChgPrc( cFam, cIva, cCliOrg, cCliDes, lTarifa1, lTarifa2, lTarifa3, lTarifa4, lTarifa5, lTarifa6, nRad, nPctInc, nUndInc, lRnd, nDec, oComBox, oMtr, oDlg, oWndBrw, cArtOrg, cArtDes, lGenerateTarifa, dIniPre, dFinPre, lAppTarifaFecha )

   local nOrdAct
   local nRecAct
   local nPrecio        := oComBox:nAt
   local aTmpAtp        := {}
   local aTmpGenerate   := {}
   local x              := 0

   if ApoloMsgNoYes( "¿Desea actualizar los datos de las tarifas de clientes?", "ATENCION" )

      if !lTarifa1 .and. !lTarifa2 .and. !lTarifa3 .and. !lTarifa4 .and. !lTarifa5 .and. !lTarifa6
         msgStop( "No ha elegido ningúna tarifa a cambiar." )
         Return .f.
      end if

      if lGenerateTarifa

         if Empty( dIniPre )
            msgStop( "Al generar una nueva tarifa la fecha de inicio debe de estar rellena." )
            Return .f.
         end if

         if Empty( dFinPre )
            msgStop( "Al generar una nueva tarifa la fecha de fin debe de estar rellena." )
            Return .f.
         end if

         if dIniPre > dFinPre
            msgStop( "Fecha de inicio debe ser anterior a la fecha de finalización." )
            Return .f.
         end if

      end if

      oDlg:Disable()

      nRecAct           := ( D():Get( "CliAtp", nView ) )->( RecNo() )
      nOrdAct           := ( D():Get( "CliAtp", nView ) )->( OrdSetFocus( "cCodCli" ) )

      if ( D():Get( "CliAtp", nView ) )->( dbSeek( cCliOrg ) )

      while ( D():Get( "CliAtp", nView ) )->cCodCli <= cCliDes .and. !( D():Get( "CliAtp", nView ) )->( eof() )

         if ( ( D():Get( "CliAtp", nView ) )->cCodArt >= cArtOrg .and. ( D():Get( "CliAtp", nView ) )->cCodArt <= cArtDes )             .and.;
            ( empty( cFam ) .or. RetFld( ( D():Get( "CliAtp", nView ) )->cCodArt, D():Get( "Articulo", nView ), "Familia" ) == cFam )   .and.;
            ( empty( cIva ) .or. RetFld( ( D():Get( "CliAtp", nView ) )->cCodArt, D():Get( "Articulo", nView ), "TipoIva" ) == cIva )   .and.;
            ( !lAppTarifaFecha  .or. ( D():Get( "CliAtp", nView ) )->dFecFin >= GetSysDate() )

            aTmpAtp  := dbScatter( D():Get( "CliAtp", nView ) )

            /*
            Cambio la fecha de fin a la tarifa anterior y pongo la fecha en la nueva tarifa
            */

            if lGenerateTarifa

               aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "dFecIni" ) ) ]   := dIniPre
               aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "dFecFin" ) ) ]   := dFinPre

               if Empty( ( D():Get( "CliAtp", nView ) )->dFecFin ) .or. ( D():Get( "CliAtp", nView ) )->dFecFin >= dIniPre

                  if( D():Get( "CliAtp", nView ) )->( dbRLock() )
                     if Empty( ( D():Get( "CliAtp", nView ) )->dFecIni )
                        ( D():Get( "CliAtp", nView ) )->dFecIni                       := CtoD( "01/01/" + Str( Year( Date() ) ) )
                     end if
                     ( D():Get( "CliAtp", nView ) )->dFecFin                          := dIniPre - 1
                     ( D():Get( "CliAtp", nView ) )->( dbUnLock() )
                  end if

               end if

            end if

            /*
            Estudio de precios
            */

            if lTarifa1

               aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt" ) ) ]     := nVal2Change( nPrecio, ( D():Get( "CliAtp", nView ) )->nPrcArt )

               if nRad == 1
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt" ) ) ]  += nVal2Change( nPrecio, aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt" ) ) ] ) * nPctInc / 100
               else
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt" ) ) ]  += nUndInc
               end if

               if lRnd
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt" ) ) ]  := Round( aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt" ) ) ], nDec )
               end if

            end if

            if lTarifa2

               aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt2" ) ) ]     := nVal2Change( nPrecio, ( D():Get( "CliAtp", nView ) )->nPrcArt2 )

               if nRad == 1
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt2" ) ) ]  += nVal2Change( nPrecio, aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt2" ) ) ] ) * nPctInc / 100
               else
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt2" ) ) ]  += nUndInc
               end if

               if lRnd
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt2" ) ) ]  := Round( aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt2" ) ) ], nDec )
               end if

            end if

            if lTarifa3

               aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt3" ) ) ]     := nVal2Change( nPrecio, ( D():Get( "CliAtp", nView ) )->nPrcArt3 )

               if nRad == 1
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt3" ) ) ]  += nVal2Change( nPrecio, aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt3" ) ) ] ) * nPctInc / 100
               else
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt3" ) ) ]  += nUndInc
               end if

               if lRnd
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt3" ) ) ]  := Round( aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt3" ) ) ], nDec )
               end if

            end if

            if lTarifa4

               aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt4" ) ) ]     := nVal2Change( nPrecio, ( D():Get( "CliAtp", nView ) )->nPrcArt4 )

               if nRad == 1
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt4" ) ) ]  += nVal2Change( nPrecio, aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt4" ) ) ] ) * nPctInc / 100
               else
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt4" ) ) ]  += nUndInc
               end if

               if lRnd
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt4" ) ) ]  := Round( aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt4" ) ) ], nDec )
               end if

            end if

            if lTarifa5

               aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt5" ) ) ]     := nVal2Change( nPrecio, ( D():Get( "CliAtp", nView ) )->nPrcArt5 )

               if nRad == 1
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt5" ) ) ]  += nVal2Change( nPrecio, aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt5" ) ) ] ) * nPctInc / 100
               else
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt5" ) ) ]  += nUndInc
               end if

               if lRnd
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt5" ) ) ]  := Round( aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt5" ) ) ], nDec )
               end if

            end if

            if lTarifa6

               aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt6" ) ) ]     := nVal2Change( nPrecio, ( D():Get( "CliAtp", nView ) )->nPrcArt6 )

               if nRad == 1
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt6" ) ) ]  += nVal2Change( nPrecio, aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt6" ) ) ] ) * nPctInc / 100
               else
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt6" ) ) ]  += nUndInc
               end if

               if lRnd
                  aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt6" ) ) ]  := Round( aTmpAtp[ ( D():Get( "CliAtp", nView ) )->( Fieldpos( "nPrcArt6" ) ) ], nDec )
               end if

            end if

            if lGenerateTarifa
               aAdd( aTmpGenerate, aTmpAtp )
            else
               dbGather( aTmpAtp, D():Get( "CliAtp", nView ) )
            end if

         end if

         ( D():Get( "CliAtp", nView ) )->( dbSkip() )

         oMtr:Set( ( D():Get( "CliAtp", nView ) )->( OrdKeyNo() ) )

      end do

      end if

      if lGenerateTarifa

         for x := 1 to Len( aTmpGenerate )
            DBGather( aTmpGenerate[ x ], D():Get( "CliAtp", nView ), .t. )
         next

      end if

      oMtr:Set( ( D():Get( "CliAtp", nView ) )->( LastRec() ) )

      ( D():Get( "CliAtp", nView ) )->( OrdSetFocus( nOrdAct ) )
      ( D():Get( "CliAtp", nView ) )->( dbGoto( nRecAct ) )

      oDlg:Enable()

   end if

   oDlg:End()

   oWndBrw:Refresh()

RETURN NIL

//---------------------------------------------------------------------------//

Static Function nVal2Change( nPrecio, nImporte )

   local nVal2Change := 0

   do case
      case nPrecio == 1
         nVal2Change := nImporte
      case nPrecio == 2
         nVal2Change := ( D():Get( "CliAtp", nView ) )->nPrcArt
      case nPrecio == 3
         nVal2Change := ( D():Get( "CliAtp", nView ) )->nPrcArt2
      case nPrecio == 4
         nVal2Change := ( D():Get( "CliAtp", nView ) )->nPrcArt3
      case nPrecio == 5
         nVal2Change := ( D():Get( "CliAtp", nView ) )->nPrcArt4
      case nPrecio == 6
         nVal2Change := ( D():Get( "CliAtp", nView ) )->nPrcArt5
      case nPrecio == 7
         nVal2Change := ( D():Get( "CliAtp", nView ) )->nPrcArt6
   end case

RETURN nVal2Change

//---------------------------------------------------------------------------//

FUNCTION AppCli( lOpenBrowse )

   local nLevel         := nLevelUsr( "01032" )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if Client()
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )

         WinAppRec( nil, bEdtRec, ( D():Get( "Client", nView ) ) )
         
         CloseFiles()

      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION EdtCli( cCodCli, lOpenBrowse, nTabInicio )

   local nLevel         := nLevelUsr( "01032" )

   DEFAULT lOpenBrowse  := .f.
   DEFAULT nTabInicio   := 1

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if Client()
         if dbSeekInOrd( cCodCli, "Cod", ( D():Get( "Client", nView ) ) )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra cliente" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cCodCli, "Cod", ( D():Get( "Client", nView ) ) )
            WinEdtRec( nil, bEdtRec, ( D():Get( "Client", nView ) ), nTabInicio )
         end if

         CloseFiles()

      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Function InfCliente( cCodCli, oBrw, lSatCli )

   local nLevel      := nLevelUsr( "01032" )
   local cArticulo   := ""

   DEFAULT lSatCli   := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if !OpenFiles( .t. )
      CloseFiles()
      return nil
   end if

   #ifndef __TACTIL__

   if ( D():Get( "Client", nView ) )->( dbSeek( cCodCli ) )
      cArticulo   := BrwVtaCli( cCodCli, ( D():Get( "Client", nView ) )->Titulo, lSatCli )
   else
      MsgStop( "No se encuentra cliente" )
   end if

   #endif

   if oBrw != nil
      oBrw:Refresh()
   end if

   CloseFiles()

RETURN ( iif( lSatCli, cArticulo, .t. ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtRotorMenu( aTmp, aGet, oDlg, oBrw, nMode )

   MENU oMenu

      MENUITEM    "&1. Rotor"

      MENU

         #ifndef __TACTIL__

         MENUITEM "&1. Informe del cliente";
         MESSAGE  "Muestra el informe del Cliente" ;
         RESOURCE "info16" ;
         ACTION   ( BrwVtaCli( ( D():Get( "Client", nView ) )->Cod, ( D():Get( "Client", nView ) )->Titulo ) )

         #endif

         if !lExternal

            SEPARATOR

            MENUITEM "&1. Añadir presupuesto de cliente";
            MESSAGE  "Añade un presupuesto de cliente" ;
            RESOURCE "Notebook_user1_16";
            ACTION   ( SavClient( aTmp, aGet, oDlg, oBrw, nMode ), PreCli( nil, nil, ( D():Get( "Client", nView ) )->Cod, nil ) )

            MENUITEM "&2. Añadir pedido de cliente";
            MESSAGE  "Añade un pedido de cliente" ;
            RESOURCE "Clipboard_empty_user1_16";
            ACTION   ( SavClient( aTmp, aGet, oDlg, oBrw, nMode ), PedCli( nil, nil, ( D():Get( "Client", nView ) )->Cod, nil ) )

            MENUITEM "&3. Añadir albarán de cliente";
            MESSAGE  "Añade un albarán de cliente" ;
            RESOURCE "Document_plain_user1_16";
            ACTION   ( SavClient( aTmp, aGet, oDlg, oBrw, nMode ), AlbCli( nil, nil,  { "Cliente" => ( D():Get( "Client", nView ) )->Cod } ) )

            MENUITEM "&4. Añadir factura de cliente";
            MESSAGE  "Añade una factura de cliente" ;
            RESOURCE "Document_user1_16";
            ACTION   ( SavClient( aTmp, aGet, oDlg, oBrw, nMode ), FactCli( nil, nil, { "Cliente" => ( D():Get( "Client", nView ) )->Cod } ) )

            MENUITEM "&5. Añadir tiket de cliente";
            MESSAGE  "Añade un tiket de cliente" ;
            RESOURCE "Cashier_user1_16";
            ACTION   ( SavClient( aTmp, aGet, oDlg, oBrw, nMode ), FrontTpv( nil, nil, ( D():Get( "Client", nView ) )->Cod, nil ) )

         end if

      ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndEdtRotorMenu()

Return ( oMenu:End() )

//---------------------------------------------------------------------------//
/*
Esta función carga el valor del precio de compra segun el campo LPRCCOM
*/

STATIC FUNCTION lChangeCostoParticular( aGet, aTmp, oCosto, nMode )

   if aTmp[ _aLPRCCOM ]
      oCosto:Hide()
      aGet[ _aNPRCCOM ]:Show()
   else
      oCosto:Show()
      aGet[ _aNPRCCOM ]:Hide()
      if nMode != APPD_MODE
         oCosto:cText( nCosto( nil, D():Get( "Articulo", nView ), dbfArtKit ) )
      end if
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

/*
Función que edita la caja de diálogo de bancos
*/

Static Function EdtBnc( aTmp, aGet, dbfTmpBnc, oBrw, aTmpCli, bValid, nMode, cCodCli )

   local oDlg
   local oBmpDiv
   local oSayPai
   local cSayPai
   local lDis        := .f.
   local cOldCtaBnc  := aCuentaIBAN( aTmp, dbfTmpBnc )

   /*
   Control para que el primer banco que metamos se ponga por defecto
   */

   if nMode == APPD_MODE
      ( dbfTmpBnc )->( dbGoTop() )
      if ( dbfTmpBnc )->( Eof() )
         aTmp[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ]   := .t.
         lDis        := .t.
      end if
   end if

   if Empty( aTmp[ ( dbfTmpBnc )->( Fieldpos( "cPaisIBAN" ) ) ] )
      aTmp[ ( dbfTmpBnc )->( Fieldpos( "cPaisIBAN" ) ) ]    := "ES"
   end if 

   DEFINE DIALOG oDlg RESOURCE "Banco" TITLE LblTitle( nMode ) + "banco de cliente"

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cCodBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cCodBnc" ) ) ] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  ( lCargaBanco( aGet, aTmp, nMode ) ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cDirBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cDirBnc" ) ) ] ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cPobBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cPobBnc" ) ) ] ;
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cCPBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cCPBnc" ) ) ] ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cProBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cProBnc" ) ) ] ;
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cPaiBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cPaiBnc" ) ) ] ;
         ID       300 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oPais:GetPais( aTmp[ ( dbfTmpBnc )->( FieldPos( "cPaiBnc" ) ) ], oSayPai, oBmpDiv ) ) ;
         ON HELP  ( oPais:Buscar( aGet[ ( dbfTmpBnc )->( FieldPos( "cPaiBnc" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       301;
         OF       oDlg

      REDEFINE GET oSayPai VAR cSayPai ;
         ID       302 ;
         SPINNER ;
         WHEN     ( .f. ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cTlfBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cTlfBnc" ) ) ] ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cFaxBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cFaxBnc" ) ) ] ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cPContBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cPContBnc" ) ) ] ;
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( Fieldpos( "cPaisIBAN" ) ) ] ; 
         VAR      aTmp[ ( dbfTmpBnc )->( Fieldpos( "cPaisIBAN" ) ) ] ;
         PICTURE  "@!" ;
         ID       370 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit(  aTmp[ ( dbfTmpBnc )->( Fieldpos( "cPaisIBAN" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ],;
                                 aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ] ;
         ID       380 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit(  aTmp[ ( dbfTmpBnc )->( Fieldpos( "cPaisIBAN" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ],;
                                 aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ],;
                                 aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ];
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ],;
                              aGet[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ] ),;
                     aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ];
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ];
         ID       320 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ],;
                              aGet[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ] ),;
                     aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ];
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) )  ];
         ID       330 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ],;
                              aGet[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ] ),;
                     aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ];
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ];
         ID       340 ;
         PICTURE  "9999999999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ],;
                              aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ],;
                              aGet[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ] ),;
                     aGet[ ( dbfTmpBnc )->( Fieldpos( "cCtrlIBAN" ) ) ]:lValid() ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ] ;
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ] ;
         ID       290 ;
         WHEN     ( nMode != ZOOM_MODE .and. !lDis ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpBnc )->( FieldPos( "nSalIni" ) ) ];
         VAR      aTmp[ ( dbfTmpBnc )->( FieldPos( "nSalIni" ) ) ];
         ID       350 ;
         PICTURE  cPorDiv( cDivEmp() ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

   /*
   Botones de la caja----------------------------------------------------------
   */

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndEdtBnc( aTmp, aGet, dbfTmpBnc, oBrw, nMode, oDlg, cCodCli, aTmpCli, cOldCtaBnc ) )

      REDEFINE BUTTON ;
         ID       550 ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:End() )

   /*
   Tecla rápida para boton aceptar---------------------------------------------
   */

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndEdtBnc( aTmp, aGet, dbfTmpBnc, oBrw, nMode, oDlg, cCodCli, aTmpCli, cOldCtaBnc ) } )
   end if

   oDlg:bStart := {|| if( aTmp[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ], aGet[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ]:Disable(), aGet[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ]:Enable() ) }

   ACTIVATE DIALOG oDlg CENTER

   if !Empty( oBmpDiv )
      oBmpDiv:end()
   end if

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
/*
Funcion que termina el diálogo y comprueba que no falte ningún campo
*/

Static Function EndEdtBnc( aTmp, aGet, dbfTmpBnc, oBrw, nMode, oDlg, cCodCli, aTmpCli, cOldCtaBnc )

   local nRec

   aTmp[ ( dbfTmpBnc )->( FieldPos( "cCodCli" ) ) ]   := cCodCli

   if cOldCtaBnc != aCuentaIBAN( aTmp, dbfTmpBnc )

      nRec     := ( dbfTmpBnc )->( Recno() )

      if ( dbfTmpBnc )->( dbSeek( cCodCli + aCuentaIBAN( aTmp, dbfTmpBnc ) ) )

         msgStop( "La cuenta bancaria ya existe" )

         aGet[ ( dbfTmpBnc )->( FieldPos( "cPaisIBAN" ) ) ]:SetFocus()

         ( dbfTmpBnc )->( dbGoTo( nRec ) )

         return .f.

      end if

      ( dbfTmpBnc )->( dbGoTo( nRec ) )

   end if

   /*
   Grabamos el registro--------------------------------------------------------
   */

   WinGather( aTmp, aGet, dbfTmpBnc, oBrw, nMode, , .f. )

   /*
   Cambiamos el banco por defecto para controlar cuando cancela
   */

   if aTmp[ ( dbfTmpBnc )->( FieldPos( "lBncDef" ) ) ]
      lSelDefBnc( aTmp, dbfTmpBnc )
   end if

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//
/*
Cambia el banco por defecto y mete los datos en la tabla de cliente
*/

Static Function lSelDefBnc( aTmp, dbfTmpBnc, oBrw )

   local nRec  := ( dbfTmpBnc )->( RecNo() )

   ( dbfTmpBnc )->( dbGoTop() )
   while !( dbfTmpBnc )->( Eof() )

      if ( dbfTmpBnc )->cEntBnc + ( dbfTmpBnc )->cSucBnc + ( dbfTmpBnc )->cDigBnc + ( dbfTmpBnc )->cCtaBnc != aTmp[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ] + aTmp[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ] + aTmp[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ] + aTmp[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ]
         ( dbfTmpBnc )->lBncDef := .f.
      else
         ( dbfTmpBnc )->lBncDef := .t.
      end if

      ( dbfTmpBnc )->( dbSkip() )

   end while

   ( dbfTmpBnc )->( dbGoto( nRec ) )

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//
/*
Carga Todos los Valores del Banco
*/

Static Function lCargaBanco( aGet, aTmp, nMode )

   local cBanco   := ""

   oBanco:Buscar( aGet[ ( dbfTmpBnc )->( FieldPos( "cCodBnc" ) ) ], "cCodBnc" )

   cBanco         := aTmp[ ( dbfTmpBnc )->( FieldPos( "cCodBnc" ) ) ]

   aGet[ ( dbfTmpBnc )->( FieldPos( "cCodBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cNomBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cDirBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cDirBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cPobBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cPobBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cProBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cProBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cCPBnc"  ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cPosBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cTlfBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cTlfBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cFaxBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cFaxBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cPContBnc")) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cPcoBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cEntBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cEntBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cSucBnc" ) ) ]:cText( oRetFld( cBanco, oBanco:oDbf, "cOfiBnc" ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cDigBnc" ) ) ]:cText( Space( 2 ) )
   aGet[ ( dbfTmpBnc )->( FieldPos( "cCtaBnc" ) ) ]:cText( Space( 10 ) )

Return .t.

//---------------------------------------------------------------------------//
/*
Funcion de borrado del banco
*/

Static Function DelBnc( aTmp, oBrwBnc, dbfTmpBnc )

   /*
   Si no es el de por defecto lo borramos sin mas------------------------------
   */

   if !( dbfTmpBnc )->lBncDef

      dbDelRec( oBrwBnc, dbfTmpBnc )

   else

      if dbDelRec( oBrwBnc, dbfTmpBnc )

         /*
         Si mandamos borrar el de por defecto, pondremos el primero de la lista en defecto y cambiamos la tabla de clientes
         */

         ( dbfTmpBnc )->( dbGoTop() )

         if !( dbfTmpBnc )->( Eof() )
            ( dbfTmpBnc )->lBncDef  := .t.
         end if

      end if

   end if

   oBrwBnc:Refresh()

Return ( .t. )

//---------------------------------------------------------------------------//

Function lBancoDefecto( cCodigoCliente, dbfBanco )

   local lBanco      := .f.

   if ( dbfBanco )->( dbSeekInOrd( cCodigoCliente, "cCodDef", dbfBanco ) )
      lBanco         := .t.
   end if

Return ( lBanco )

//--------------------------------------------------------------------------//

Function SynClient( cPath )

   DEFAULT cPath     := cPatCli()

   /*
   Abrimos los ficheros--------------------------------------------------------
   */

   if OpenFiles( .f. )

      while !( dbfBanco )->( eof() )
/*
         if Empty( ( dbfBanco )->cDigBnc )

            if dbLock( dbfBanco )
               ( dbfBanco )->cDigBnc   := cDgtControl( ( dbfBanco )->cEntBnc, ( dbfBanco )->cSucBnc, ( dbfBanco )->cDigBnc, ( dbfBanco )->cCtaBnc )
               ( dbfBanco )->( dbUnLock() )
            end if

         end if
*/
         if Empty( ( dbfBanco )->cPaisIBAN )

            if dbLock( dbfBanco )
               ( dbfBanco )->cPaisIBAN := "ES"
               ( dbfBanco )->cCtrlIBAN := IbanDigit( ( dbfBanco )->cPaisIBAN, ( dbfBanco )->cEntBnc, ( dbfBanco )->cSucBnc, ( dbfBanco )->cDigBnc, ( dbfBanco )->cCtaBnc )
               ( dbfBanco )->( dbUnLock() )
            end if

         end if

         ( dbfBanco )->( dbSkip() )

      end while

      /*
      Pasamos y limpiamos el campo antiguo de facturas automáticas-------------
      */

      ( D():Get( "Client", nView ) )->( dbGoTop() )
      while !( D():Get( "Client", nView ) )->( Eof() )

         if Empty( ( D():Get( "Client", nView ) )->mFacAut ) .and. !Empty( ( D():Get( "Client", nView ) )->cFacAut )

            if D():Lock( "Client", nView )
               ( D():Get( "Client", nView ) )->mFacAut  := AllTrim( ( D():Get( "Client", nView ) )->cFacAut ) + ","
               ( D():Get( "Client", nView ) )->cFacAut  := ""
               D():UnLock( "Client", nView ) 
            end if

         end if

         ( D():Get( "Client", nView ) )->( dbSkip() )

      end while

      CloseFiles()

   end if

Return ( nil )
//---------------------------------------------------------------------------//

Function BrwCliTactil( oGet, dbfCli, oGet2, lReturnCliente, cText, cBitmap )

   local oDlg
   local oBrw
   local nRec
   local nOrdAnt
   local cCliente          := ""
   local lClose            := .f.
   local oGetUnidades
   local cGetUnidades      := Space( 100 )
   local oBmpGeneral
   local oSayGeneral
   local cResource         := "HelpEntryTactilCli"
   local oFntBrw

   DEFAULT lReturnCliente  := .f.
   DEFAULT cText           := "Selecione un cliente"
   DEFAULT cBitmap         := "Businessman2_Alpha_48"

   if Empty( dbfCli )

      if !OpenFiles( .t. )
         Return nil
      end if

      dbfCli               := ( D():Get( "Client", nView ) )
      lClose               := .t.

   end if

   oFntBrw                 := TFont():New( "Segoe UI",  0, 20, .f., .t. ) 

   nRec                    := ( dbfCli )->( Recno() )
   nOrdAnt                 := ( dbfCli )->( OrdSetFocus( "Telefono" ) ) 

   ( dbfCli )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE cResource TITLE "Seleccionar cliente ordenado por: Teléfono"

      REDEFINE BUTTONBMP ;
         ID       100 ;
         OF       oDlg ;
         BITMAP   "Keyboard2_32";
         ACTION   ( VirtualKey( .f., oGetUnidades ), if( lBigSeek( nil, cGetUnidades, dbfCli ), oBrw:Refresh(), ) )

      REDEFINE SAY oSayGeneral ;
         PROMPT   cText;
         ID       200 ;
         FONT     oFntBrw ;
         OF       oDlg

      REDEFINE BITMAP oBmpGeneral ;
        ID       500 ;
        RESOURCE   cBitmap ;
        TRANSPARENT ;
        OF       oDlg

      REDEFINE GET oGetUnidades VAR cGetUnidades;
         ID       600 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfCli ) );
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfCli
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse cliente tactil"
      oBrw:nHeaderHeight   := 40
      oBrw:nRowHeight      := 60
      oBrw:nDataLines      := 2
      oBrw:lHScroll        := .f.
      oBrw:oFont           := oFntBrw

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "CodBig"
         :bEditValue       := {|| AllTrim( ( dbfCli )->Cod ) }
         :nWidth           := 110
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre y domicilio"
         :cSortOrder       := "Titulo"
         :bEditValue       := {|| AllTrim( ( dbfCli )->Titulo ) + CRLF + AllTrim( ( dbfCli )->Domicilio ) }
         :nWidth           := 440
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Teléfono"
         :cSortOrder       := "Telefono"
         :bEditValue       := {|| AllTrim( ( dbfCli )->Telefono ) }
         :nWidth           := 140
      end with

      REDEFINE BUTTONBMP ;
         ID       160 ;
         OF       oDlg ;
         BITMAP   "User1_Add_32" ;
         ACTION   ( WinAppRec( oBrw, bEdtBig, dbfCli ) )

      REDEFINE BUTTONBMP ;
         ID       170 ;
         OF       oDlg ;
         BITMAP   "User1_Edit_32" ;
         ACTION   ( WinEdtRec( oBrw, bEdtBig, dbfCli ) )

      REDEFINE BUTTONBMP ;
         ID       140 ;
         OF       oDlg ;
         BITMAP   "UP32" ;
         ACTION   ( oBrw:GoUp() )

      REDEFINE BUTTONBMP ;
         ID       150 ;
         OF       oDlg ;
         BITMAP   "DOWN32" ;
         ACTION   ( oBrw:GoDown() )

      REDEFINE BUTTONBMP ;
         BITMAP   "Check_32" ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:End( IDOK ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

      oDlg:bStart := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      cCliente    := ( dbfCli )->Cod

      if !Empty( oGet )
         oGet:cText( cCliente )
      end if

      if !Empty( oGet2 )
         oGet2:cText( Rtrim( ( dbfCli )->Titulo ) )
      end if

   end if

   if lClose

      CloseFiles()

   else

      ( dbfCli )->( OrdSetFocus( nOrdAnt ) )
      ( dbfCli )->( dbGoTo( nRec ) )

   end if

   if !Empty( oFntBrw )
      oFntBrw:End()
   end if

Return ( if( !lReturnCliente, oDlg:nResult == IDOK, cCliente ) )

//---------------------------------------------------------------------------//

Static Function EdtInc( aTmp, aGet, dbfFacCliI, oBrw, cCodCli, bValid, nMode )

   local oDlg
   local oNomInci
   local cNomInci

   if nMode == APPD_MODE

      if !empty( cCodCli )
         aTmp[ ( dbfFacCliI )->( FieldPos( "cCodCli" ) ) ]  := cCodCli
      end if
      
      if !Empty( oUser():cTipoIncidencia() )
         aTmp[ ( dbfFacCliI )->( FieldPos( "cCodTip" ) ) ]  := oUser():cTipoIncidencia()
      end if

   end if

   if !Empty( aTmp[ ( dbfFacCliI )->( FieldPos( "cCodTip" ) ) ] )
      cNomInci    := cNomInci( aTmp[ ( dbfFacCliI )->( FieldPos( "cCodTip" ) ) ], D():Get( "TipInci", nView ) )
   end if

   DEFINE DIALOG oDlg RESOURCE "Incidencia" TITLE LblTitle( nMode ) + "incidencias de clientes"

      REDEFINE GET aGet[ ( dbfFacCliI )->( FieldPos( "cCodTip" ) ) ];
         VAR      aTmp[ ( dbfFacCliI )->( FieldPos( "cCodTip" ) ) ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cTipInci( aGet[ ( dbfFacCliI )->( FieldPos( "cCodTip" ) ) ], D():Get( "TipInci", nView ), oNomInci ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIncidencia( D():Get( "TipInci", nView ), aGet[ ( dbfFacCliI )->( FieldPos( "cCodTip" ) ) ], oNomInci ) ) ;
         OF       oDlg

      REDEFINE GET oNomInci VAR cNomInci;
         WHEN     .f. ; 
         ID       130 ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfFacCliI )->( FieldPos( "dFecInc" ) ) ] ;
         ID       100 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfFacCliI )->( FieldPos( "mDesInc" ) ) ] ;
         MEMO ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfFacCliI )->( FieldPos( "lListo" ) ) ] ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfFacCliI )->( FieldPos( "lAviso" ) ) ] ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinGather( aTmp, nil, dbfFacCliI, oBrw, nMode ), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| WinGather( aTmp, nil, dbfFacCliI, oBrw, nMode ), oDlg:end( IDOK ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TClienteLabelGenerator

   Data oDlg
   Data oFld

   Data oCriterio
   Data cCriterio
   Data aCriterio

   Data oGrupoInicio
   Data cGrupoInicio

   Data oGrupoFin
   Data cGrupoFin

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

   Data hBmp

   Data oBtnListado

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

   Method SelectCriterioLabels()

   Method AddLabel()

   Method DelLabel()

   Method EditLabel()

   Method ChangeCriterio()

   Method lPrintLabels()

   Method InitLabel( oLabel )

   Method lCreateTemporal()

   Method PrepareTemporal( oFr )

   Method DestroyTemporal()

   Method SelectColumn( oCombo )

END CLASS

//----------------------------------------------------------------------------//

Method lDefault() CLASS TClienteLabelGenerator

   local oError
   local oBlock
   local lError            := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::cCriterio          := "Ningún criterio"
      ::aCriterio          := { "Ningún criterio", "Grupo clientes", "Fecha modificación" }

      ::cGrupoInicio       := ( D():Get( "Client", nView ) )->cCodGrp
      ::cGrupoFin          := ( D():Get( "Client", nView ) )->cCodGrp

      ::dFechaInicio       := Ctod( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ), 4 ) )
      ::dFechaFin          := GetSysDate()

      ::cFormatoLabel      := GetPvProfString( "Etiquetas", "Cliente", Space( 3 ), cPatEmp() + "Empresa.Ini" )
      if len( ::cFormatoLabel ) < 3
         ::cFormatoLabel   := Space( 3 )
      end if

      ::nMtrLabel          := 0

      ::nFilaInicio        := 1
      ::nColumnaInicio     := 1

      ::nCantidadLabels    := 1
      ::nUnidadesLabels    := 1

      ::aSearch            := { "Código", "Nombre", "NIF/CIF", "Población", "Provincia", "Código postal", "Teléfono" }

   RECOVER USING oError

      lError               := .t.

      msgStop( "Error en la creación de generador de etiquetas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

Return ( !lError )

//--------------------------------------------------------------------------//

Method Create() CLASS TClienteLabelGenerator

   local oBtnPrp
   local oGetOrd
   local oCbxOrd
   local cGetOrd     := Space( 100 )
   local cCbxOrd     := "Código"
   local aCbxOrd     := { "Código", "Nombre" }

   if ::lDefault()

      DEFINE DIALOG ::oDlg RESOURCE "SelectLabels_0"

         REDEFINE PAGES ::oFld ;
            ID       10;
            OF       ::oDlg ;
            DIALOGS  "SelectLabels_4",;
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
            OF       ::oFld:aDialogs[ 1 ]

         ::oCriterio:bChange        := {|| ::ChangeCriterio() }

         REDEFINE GET ::oGrupoInicio VAR ::cGrupoInicio ;
            ID       100 ;
            IDTEXT   101 ;
            BITMAP   "LUPA" ;
            OF       ::oFld:aDialogs[ 1 ]

         ::oGrupoInicio:bValid    := {|| oGrpCli:Existe( ::cGrupoInicio, ::oGrupoInicio:oHelpText, "cNomGrp", .t., .t., "0" ) }
         ::oGrupoInicio:bHelp     := {|| oGrpCli:Buscar( ::oGrupoInicio ) }

         REDEFINE SAY ::oInicio ;
            ID       102 ;
            OF       ::oFld:aDialogs[1]

         REDEFINE GET ::oGrupoFin VAR ::cGrupoFin ;
            ID       110 ;
            IDTEXT   111 ;
            BITMAP   "LUPA" ;
            OF       ::oFld:aDialogs[ 1 ]

         ::oGrupoFin:bValid       := {|| oGrpCli:Existe( ::cGrupoFin, ::oGrupoFin:oHelpText, "cNomGrp", .t., .t., "0" ) }
         ::oGrupoFin:bHelp        := {|| oGrpCli:Buscar( ::oGrupoFin ) }

         REDEFINE SAY ::oFin ;
            ID       112 ;
            OF       ::oFld:aDialogs[1]

         REDEFINE GET ::oFechaInicio VAR ::dFechaInicio ;
            SPINNER ;
            ID       120 ;
            OF       ::oFld:aDialogs[1]

         REDEFINE GET ::oFechaFin VAR ::dFechaFin ;
            SPINNER ;
            ID       130 ;
            OF       ::oFld:aDialogs[1]

         REDEFINE GET ::oFormatoLabel VAR ::cFormatoLabel ;
            ID       160 ;
            IDTEXT   161 ;
            BITMAP   "LUPA" ;
            OF       ::oFld:aDialogs[ 1 ]

            ::oFormatoLabel:bValid  := {|| cDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, dbfDoc, "CL" ) }
            ::oFormatoLabel:bHelp   := {|| BrwDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, "CL" ) }

         TBtnBmp():ReDefine( 220, "Printer_pencil_16",,,,,{|| EdtDocumento( ::cFormatoLabel ) }, ::oFld:aDialogs[ 1 ], .f., , .f., "Modificar formato de etiquetas" )

         REDEFINE GET ::nFilaInicio ;
            ID       180 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nColumnaInicio ;
            ID       190 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nUnidadesLabels ;
            ID       210 ;
            PICTURE  "99999" ;
            SPINNER ;
            MIN      1 ;
            MAX      99999 ;
            OF       ::oFld:aDialogs[ 1 ]

         /*
         Segunda caja de dialogo--------------------------------------------------
         */

         REDEFINE GET oGetOrd ;
            VAR      cGetOrd;
            ID       200 ;
            BITMAP   "FIND" ;
            OF       ::oFld:aDialogs[ 2 ]

         oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwLabel, ( D():Get( "Client", nView ) ) ) }
         oGetOrd:bValid    := {|| ( D():Get( "Client", nView ) )->( OrdScope( 0, nil ) ), ( D():Get( "Client", nView ) )->( OrdScope( 1, nil ) ), ::oBrwLabel:Refresh(), .t. }

         REDEFINE COMBOBOX oCbxOrd ;
            VAR      cCbxOrd ;
            ID       210 ;
            ITEMS    aCbxOrd ;
            OF       ::oFld:aDialogs[ 2 ]

         oCbxOrd:bChange   := {|| ::SelectColumn( oCbxOrd ) }

         REDEFINE BUTTON ;
            ID       100 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::PutLabel() )

         REDEFINE BUTTON ;
            ID       110 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::SelectAllLabels( .t. ) )

         REDEFINE BUTTON ;
            ID       120 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::SelectAllLabels( .f. ) )

         REDEFINE BUTTON ;
            ID       130 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::AddLabel() )

         REDEFINE BUTTON ;
            ID       140 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::DelLabel() )

         REDEFINE BUTTON ;
            ID       150 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::EditLabel() )

         REDEFINE BUTTON ;
            ID       160 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( WinEdtRec( ::oBrwLabel, bEdtRec, ( D():Get( "Client", nView ) ) ) )

         REDEFINE BUTTON ;
            ID       165 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( WinZooRec( ::oBrwLabel, bEdtRec, ( D():Get( "Client", nView ) ) ) )

         REDEFINE BUTTON oBtnPrp ;
            ID       220 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( nil )

         ::oBrwLabel                 := IXBrowse():New( ::oFld:aDialogs[ 2 ] )

         ::oBrwLabel:nMarqueeStyle   := 5
         ::oBrwLabel:nColSel         := 2

         ::oBrwLabel:lHScroll        := .f.
         ::oBrwLabel:cAlias          := ( D():Get( "Client", nView ) )

         ::oBrwLabel:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         ::oBrwLabel:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
         ::oBrwLabel:bLDblClick      := {|| ::PutLabel() }

         ::oBrwLabel:CreateFromResource( 180 )

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Sl. Seleccionado"
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->lLabel }
            :nWidth           := 20
            :SetCheck( { "Sel16", "Nil16" } ) 
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Código"
            :cSortOrder       := "Cod"
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->Cod }
            :nWidth           := 80
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Nombre"
            :cSortOrder       := "Titulo"
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->Titulo }
            :nWidth           := 280
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "N. etiquetas"
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->nLabel }
            :cEditPicture     := "@E 99,999"
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nEditType        := 1
            :bOnPostEdit      := {|o,x| if( dbDialogLock( D():Get( "Client", nView ) ), ( ( D():Get( "Client", nView ) )->nLabel := x, ( D():Get( "Client", nView ) )->( dbUnlock() ) ), ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "NIF/CIF"
            :cSortOrder       := "Nif"
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->Nif }
            :nWidth           := 80
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Teléfono"
            :cSortOrder       := "Telefono"
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->Telefono }
            :nWidth           := 80
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Fax"
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->Fax }
            :nWidth           := 80
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Domicilio"
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->Domicilio }
            :nWidth           := 300
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Población"
            :cSortOrder       := "Poblacion"
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->Poblacion }
            :nWidth           := 200
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Código postal"
            :cSortOrder       := "CodPostal"
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->CodPostal }
            :nWidth           := 60
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Provincia"
            :cSortOrder       := "Provincia"
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->Provincia }
            :nWidth           := 100
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Establecimiento"
            :cSortOrder       := "NbrEst"
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->NbrEst }
            :nWidth           := 100
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Correo electrónico"
            :cSortOrder       := "cMeiInt"
            :bEditValue       := {|| ( D():Get( "Client", nView ) )->cMeiInt }
            :nWidth           := 100
         end with

   REDEFINE APOLOMETER ::oMtrLabel ;
            VAR      ::nMtrLabel ;
            PROMPT   "" ;
            ID       190 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            TOTAL    ( D():Get( "Client", nView ) )->( lastrec() )

         ::oMtrLabel:nClrText   := rgb( 128,255,0 )
         ::oMtrLabel:nClrBar    := rgb( 128,255,0 )
         ::oMtrLabel:nClrBText  := rgb( 128,255,0 )

         /*
         Botones generales--------------------------------------------------------
         */

         REDEFINE BUTTON ::oBtnListado ;          // Boton listado
            ID       40 ;
            OF       ::oDlg ;
            ACTION   ( TInfCliGrp():New( "Listado de clientes seleccionados para etiquetas" ):Play( .t. ) )

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

      ::oDlg:bStart  := {|| ::oBtnAnterior:Hide(), ::ChangeCriterio(), ::oFormatoLabel:lValid(), oBtnPrp:Hide() }

      ACTIVATE DIALOG ::oDlg CENTER

      ::End()

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonAnterior() CLASS TClienteLabelGenerator

   ::oFld:GoPrev()

   ::oBtnAnterior:Hide()

   SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonSiguiente() CLASS TClienteLabelGenerator

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

         ::oBrwLabel:Refresh()

   end case

Return ( Self )

//--------------------------------------------------------------------------//

Method End() CLASS TClienteLabelGenerator

   WritePProString( "Etiquetas", "Cliente", ::cFormatoLabel, cPatEmp() + "Empresa.Ini" )

Return ( Self )

//--------------------------------------------------------------------------//

Method PutLabel() CLASS TClienteLabelGenerator

   if dbLock( D():Get( "Client", nView ) )
      ( D():Get( "Client", nView ) )->lLabel      := !( D():Get( "Client", nView ) )->lLabel
      if ( D():Get( "Client", nView ) )->lLabel .and. Empty( ( D():Get( "Client", nView ) )->nLabel )
         ( D():Get( "Client", nView ) )->nLabel   := 1
      end if
      ( D():Get( "Client", nView ) )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectAllLabels( lSelect ) CLASS TClienteLabelGenerator

   local n        := 0
   local nRecno   := ( D():Get( "Client", nView ) )->( Recno() )

   CursorWait()

   ( D():Get( "Client", nView ) )->( dbGoTop() )
   while !( D():Get( "Client", nView ) )->( eof() )

      if dbLock( D():Get( "Client", nView ) )
         ( D():Get( "Client", nView ) )->lLabel := lSelect
         ( D():Get( "Client", nView ) )->( dbUnLock() )
      end if

      ( D():Get( "Client", nView ) )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ( D():Get( "Client", nView ) )->( dbGoTo( nRecno ) )

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectCriterioLabels() CLASS TClienteLabelGenerator

   local n        := 0
   local nRecno   := ( D():Get( "Client", nView ) )->( Recno() )

   CursorWait()

   ( D():Get( "Client", nView ) )->( dbGoTop() )
   while !( D():Get( "Client", nView ) )->( eof() )

      if dbLock( D():Get( "Client", nView ) )

         do case
            case ::oCriterio:nAt == 2 .and. ( D():Get( "Client", nView ) )->cCodGrp >= ::cGrupoInicio .and. ( D():Get( "Client", nView ) )->cCodGrp <= ::cGrupoFin
               ( D():Get( "Client", nView ) )->lLabel := .t.
               ( D():Get( "Client", nView ) )->nLabel := ::nUnidadesLabels

            case ::oCriterio:nAt == 3 .and. ( D():Get( "Client", nView ) )->dFecChg >= ::dFechaInicio .and. ( D():Get( "Client", nView ) )->dFecChg <= ::dFechaFin
               ( D():Get( "Client", nView ) )->lLabel := .t.
               ( D():Get( "Client", nView ) )->nLabel := ::nUnidadesLabels

            otherwise
               ( D():Get( "Client", nView ) )->lLabel := .f.
               ( D():Get( "Client", nView ) )->nLabel := 1

         end case

         ( D():Get( "Client", nView ) )->( dbUnLock() )

      end if

      ( D():Get( "Client", nView ) )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ( D():Get( "Client", nView ) )->( dbGoTo( nRecno ) )

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

Method AddLabel() CLASS TClienteLabelGenerator

   if dbLock( D():Get( "Client", nView ) )
      ( D():Get( "Client", nView ) )->nLabel++
      ( D():Get( "Client", nView ) )->( dbUnLock() )
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method DelLabel() CLASS TClienteLabelGenerator

   if ( D():Get( "Client", nView ) )->nLabel > 1
      if dbLock( D():Get( "Client", nView ) )
         ( D():Get( "Client", nView ) )->nLabel--
         ( D():Get( "Client", nView ) )->( dbUnLock() )
      end if
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

Method EditLabel() CLASS TClienteLabelGenerator

   ::oBrwLabel:aCols[ 4 ]:Edit()

Return ( Self )

//---------------------------------------------------------------------------//

Method ChangeCriterio() CLASS TClienteLabelGenerator

   ::oGrupoInicio:Hide()
   ::oGrupoFin:Hide()

   ::oInicio:Hide()
   ::oFin:Hide()

   ::oFechaInicio:Hide()
   ::oFechaFin:Hide()

   do case
      case ::oCriterio:nAt == 2

         ::oGrupoInicio:Show()
         ::oGrupoFin:Show()
         ::oInicio:Show()
         ::oFin:Show()

      case ::oCriterio:nAt == 3

         ::oFechaInicio:Show()
         ::oFechaFin:Show()
         ::oInicio:Show()
         ::oFin:Show()

   end case

Return ( Self )

//---------------------------------------------------------------------------//

Method lPrintLabels() CLASS TClienteLabelGenerator

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
   Zona de datos------------------------------------------------------------
   */

   DataReport( oFr, .t. )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Zona de variables--------------------------------------------------------
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

Return ( .t. )

//---------------------------------------------------------------------------//

Method InitLabel( oLabel ) CLASS TClienteLabelGenerator

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

Method lCreateTemporal() CLASS TClienteLabelGenerator

   local n
   local nRec
   local oBlock
   local oError
   local nBlancos
   local lCreateTemporal   := .t.
   local lClose            := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      tmpClient            := "LblCli"
      filClient            := cGetNewFileName( cPatTmp() + "LblCli" )

      dbCreate( filClient, aSqlStruct( aItmCli() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), filClient, tmpClient, .f. )

      ( tmpClient )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( tmpClient )->( OrdCreate( filClient, "Cod", "Cod", {|| Field->Cod } ) )

      /*
      Cargamos a la temporal---------------------------------------------------
      */

      nRec                 := ( D():Get( "Client", nView ) )->( Recno() )

      ( D():Get( "Client", nView ) )->( dbGoTop() )
      while !( D():Get( "Client", nView ) )->( eof() )

         if ( D():Get( "Client", nView ) )->lLabel
            for n := 1 to ( D():Get( "Client", nView ) )->nLabel
               dbPass( ( D():Get( "Client", nView ) ), tmpClient, .t. )
            next
         end if

         ( D():Get( "Client", nView ) )->( dbSkip() )

      end while
      ( tmpClient )->( dbGoTop() )

      ( D():Get( "Client", nView ) )->( dbGoTo( nRec ) )

   RECOVER USING oError

      lCreateTemporal      := .f.

      MsgStop( 'Imposible crear tablas temporales' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateTemporal )

//---------------------------------------------------------------------------//

Method PrepareTemporal( oFr ) CLASS TClienteLabelGenerator

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
         dbPass( dbBlankRec( D():Get( "Client", nView ) ), tmpClient, .t. )
      next

   end if 

   ( tmpClient )->( dbGoTop() )

Return ( .t. )

//---------------------------------------------------------------------------//

Method DestroyTemporal() CLASS TClienteLabelGenerator

   if ( tmpClient )->( Used() )
      ( tmpClient )->( dbCloseArea() )
   end if

   dbfErase( filClient )

Return ( .t. )

//---------------------------------------------------------------------------//

Method SelectColumn( oCombo ) CLASS TClienteLabelGenerator

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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

Function RtfRefreshButtons( oRtf, oBtn )

   local aChar := REGetCharFormat( oRTF:hWnd )

   lBold       := aChar[ 5 ] == FW_BOLD
   lItalic     := aChar[ 6 ]
   lUnderline  := aChar[ 7 ]
   lBullet     := REGetBullet( oRTF:hWnd )

   if oBtn[ 4 ]:lWhen()
      oBtn[ 4 ]:Enable()
      oBtn[ 4 ]:Refresh()
   else
      oBtn[ 4 ]:Disable()
      oBtn[ 4 ]:Refresh()
   end if

   if oBtn[ 5 ]:lWhen()
      oBtn[ 5 ]:Enable()
      oBtn[ 5 ]:Refresh()
   else
      oBtn[ 5 ]:Disable()
      oBtn[ 5 ]:Refresh()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

/*
Browse de clientes
*/

FUNCTION BrwClient( uGet, uGetName, lBigStyle )

   local oDlg
   local hBmp
   local oBrw
   local uGet1
   local cGet1
   local cTxtOrigen  := uGet:VarGet()
   local nOrdAnt     := GetBrwOpt( "BrwClient" )
   local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre", "NIF/CIF", "Población", "Provincia", "Código postal", "Teléfono", "Establecimiento", "Correo electrónico" }
   local cCbxOrd
   local nLevel      := nLevelUsr( "01032" )
   local oSayText
   local cSayText    := "Listado de clientes"

   nOrdAnt           := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrdAnt ]

   DEFAULT lBigStyle := .f.

   if !OpenFiles( .t. )
      Return nil
   end if

   /*
   Origen de busqueda----------------------------------------------------------
   */

   if !Empty( cTxtOrigen ) .and. !( D():Get( "Client", nView ) )->( dbSeek( cTxtOrigen ) )
      ( D():Get( "Client", nView ) )->( OrdSetFocus( nOrdAnt ) )
      ( D():Get( "Client", nView ) )->( dbGoTop() )
   else
      ( D():Get( "Client", nView ) )->( OrdSetFocus( nOrdAnt ) )
   end if

   /*
   Distintas cajas de dialogo--------------------------------------------------
   */

   do case
   case lBigStyle
      DEFINE DIALOG oDlg RESOURCE "BIGHELPENTRY"   TITLE "Seleccionar clientes"
   otherwise
      DEFINE DIALOG oDlg RESOURCE "HELPENTRY"      TITLE "Seleccionar clientes"
   end case

      REDEFINE GET uGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, ( D():Get( "Client", nView ) ), .t. ) );
         VALID    ( OrdClearScope( oBrw, ( D():Get( "Client", nView ) ) ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( D():Get( "Client", nView ) )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), uGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := ( D():Get( "Client", nView ) )
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Clientes"

      with object ( oBrw:AddCol() )
         :cHeader          := "Bl. Bloqueado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->lBlqCli }
         :nWidth           := 20
         :SetCheck( { "Cnt16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Cod"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Cod }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Titulo"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Titulo }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "NIF/CIF"
         :cSortOrder       := "Nif"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Nif }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Teléfono"
         :cSortOrder       := "Telefono"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Telefono }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fax"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Fax }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Domicilio"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Domicilio }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Población"
         :cSortOrder       := "Poblacion"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Poblacion }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código postal"
         :cSortOrder       := "CodPostal"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->CodPostal }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Provincia"
         :cSortOrder       := "Provincia"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->Provincia }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Establecimiento"
         :cSortOrder       := "NbrEst"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->NbrEst }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Correo electrónico"
         :cSortOrder       := "cMeiInt"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->cMeiInt }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Riesgo"
         :bEditValue       := {|| Trans( ( D():Get( "Client", nView ) )->nImpRie, PicOut() ) }
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Contacto"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->cPerCto }
         :nWidth           := 100
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Observaciones"
         :bEditValue       := {|| ( D():Get( "Client", nView ) )->mComent }
         :nWidth           := 200
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      if lBigStyle
         oBrw:nHeaderHeight   := 36
         oBrw:nFooterHeight   := 36
         oBrw:nLineHeight     := 36
      end if

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end(IDOK) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     nAnd( nLevel, ACC_APPD ) != 0 ;
         ACTION   ( WinAppRec( oBrw, bEdtRec, ( D():Get( "Client", nView ) ) ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     nAnd( nLevel, ACC_EDIT ) != 0;
         ACTION   ( WinEdtRec( oBrw, bEdtRec, ( D():Get( "Client", nView ) ) ) )

      oDlg:AddFastKey( VK_F2,    {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdtRec, ( D():Get( "Client", nView ) ) ), ) } )
      oDlg:AddFastKey( VK_F3,    {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdtRec, ( D():Get( "Client", nView ) ) ), ) } )

   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )

   oDlg:bStart                := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      if ValType( uGet ) == "O"
         uGet:cText( ( D():Get( "Client", nView ) )->Cod )
         uGet:lValid()
      else
         uGet  := ( D():Get( "Client", nView ) )->Cod
      end if

      if ValType( uGetName ) == "O"
         uGetName:cText( ( D():Get( "Client", nView ) )->Titulo )
      end if

   end if

   DestroyFastFilter( D():Get( "Client", nView ) )

   SetBrwOpt( "BrwClient", ( D():Get( "Client", nView ) )->( OrdNumber() ) )

   CloseFiles()

   if Valtype( uGet ) == "O"
      uGet:setFocus()
   end if

   DeleteObject( hBmp )

RETURN oDlg:nResult == IDOK

//---------------------------------------------------------------------------//

FUNCTION LoaIniCli( cPath, cIniCli )

   local n
   local oIniCli

   DEFAULT cPath     := cPatEmp()
   DEFAULT cIniCli   := cPath + "Client.Ini"

   aIniCli 			 := Array( 11 )

   /*
   Fichero Ini de la Aplicaci¢n
   ---------------------------------------------------------------------------
   */

   INI oIniCli FILE cIniCli

      GET aIniCli[ 1 ] SECTION "campos" ENTRY "1" OF oIniCli DEFAULT Space( 50 )

      GET aIniCli[ 2 ] SECTION "campos" ENTRY "2" OF oIniCli DEFAULT Space( 50 )

      GET aIniCli[ 3 ] SECTION "campos" ENTRY "3" OF oIniCli DEFAULT Space( 50 )

      GET aIniCli[ 4 ] SECTION "campos" ENTRY "4" OF oIniCli DEFAULT Space( 50 )

      GET aIniCli[ 5 ] SECTION "campos" ENTRY "5" OF oIniCli DEFAULT Space( 50 )

      GET aIniCli[ 6 ] SECTION "campos" ENTRY "6" OF oIniCli DEFAULT Space( 50 )

      GET aIniCli[ 7 ] SECTION "campos" ENTRY "7" OF oIniCli DEFAULT Space( 50 )

      GET aIniCli[ 8 ] SECTION "campos" ENTRY "8" OF oIniCli DEFAULT Space( 50 )

      GET aIniCli[ 9 ] SECTION "campos" ENTRY "9" OF oIniCli DEFAULT Space( 50 )

      GET aIniCli[ 10 ] SECTION "campos" ENTRY "10" OF oIniCli DEFAULT Space( 50 )

      GET aIniCli[ 11 ] SECTION "filtro" ENTRY "ft" OF oIniCli DEFAULT "Activas"

   ENDINI

   for n := 1 TO 10
      aIniCli[ n ]   := padr( aIniCli[ n ], 50 )
   next

   aIniCli[ 11 ]     := Rtrim( aIniCli[ 11 ] )

//RETURN ( nil )
RETURN ( aIniCli )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//---------------------------------------------------------------------------//

Function IsClient( cPath )

   DEFAULT cPath  := cPatCli()

   if !lExistTable( cPath + "Client.Dbf" )
      dbCreate( cPath + "Client.Dbf", aSqlStruct( aItmCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "CliAtp.Dbf" )
      dbCreate( cPath + "CliAtp.Dbf", aSqlStruct( aItmAtp() ), cDriver() )
   end if

   if !lExistTable( cPath + "ObrasT.Dbf" )
      dbCreate( cPath + "ObrasT.Dbf", aSqlStruct( aItmObr() ), cDriver() )
   end if

   if !lExistTable( cPath + "ClientD.Dbf" )
      dbCreate( cPath + "ClientD.Dbf", aSqlStruct( aCliDoc() ), cDriver() )
   end if

   if !lExistTable( cPath + "CliBnc.Dbf" )
      dbCreate( cPath + "CliBnc.Dbf", aSqlStruct( aCliBnc() ), cDriver() )
   end if

   if !lExistTable( cPath + "CliInc.Dbf" )
      dbCreate( cPath + "CliInc.Dbf", aSqlStruct( aCliInc() ), cDriver() )
   end if

   if !lExistIndex( cPath + "Client.Cdx"  ) .or. ;
      !lExistIndex( cPath + "CliAtp.Cdx"  ) .or. ;
      !lExistIndex( cPath + "ObrasT.Cdx"  ) .or. ;
      !lExistTable( cPath + "ClientD.Dbf" ) .or. ;
      !lExistTable( cPath + "CliBnc.Cdx"  ) .or. ;
      !lExistTable( cPath + "CliInc.Cdx"  )

      rxClient( cPath )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

/*
Crea las BD clientes
*/

FUNCTION AssertClient( cPath )

   IF !lExistTable( cPath + "CLIENT.DBF" )
      dbCreate( cPath + "CLIENT.DBF", aSqlStruct( aItmCli() ), cDriver() )
   END IF

   IF !lExistTable( cPath + "OBRAST.DBF" )
      dbCreate( cPath + "OBRAST.DBF", aSqlStruct( aItmObr() ), cDriver() )
   END IF

   IF !lExistTable( cPath + "CLIENTD.DBF" )
      dbCreate( cPath + "CLIENTD.DBF", aSqlStruct( aCliDoc() ), cDriver() )
   END IF

   IF !lExistTable( cPath + "CLIBNC.DBF" )
      dbCreate( cPath + "CLIBNC.DBF", aSqlStruct( aCliBnc() ), cDriver() )
   END IF

   if !lExistTable( cPath + "CLIINC.DBF" )
      dbCreate( cPath + "CLIINC.DBF", aSqlStruct( aCliInc() ), cDriver() )
   end if

   if !lExistTable( cPath + "CLICONTACTOS.Dbf" )
      dbCreate( cPath + "CLICONTACTOS.Dbf", aSqlStruct( aItmContacto() ), cDriver() )
   end if

   if !lExistTable( cPath + "CliFacturae.Dbf" )
      dbCreate( cPath + "CliFacturae.Dbf", aSqlStruct( aCliFacturae() ), cDriver() )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION mkClient( cPath, lAppend, cPathOld, oMeter )

   DEFAULT cPath        := cPatCli()
   DEFAULT lAppend      := .f.

   AssertClient( cPath )

   if oMeter != NIL
      oMeter:cText      := "Generando Bases"
      sysRefresh()
   end if

   rxClient( cPath, oMeter )

   if lAppend .and. lIsDir( cPathOld )
      AppDbf( cPathOld, cPath, "Client"         )
      AppDbf( cPathOld, cPath, "ObrasT"         )
      AppDbf( cPathOld, cPath, "CliBnc"         )
      AppDbf( cPathOld, cPath, "CliInc"         )
      AppDbf( cPathOld, cPath, "CliContactos"   )
      AppDbf( cPathOld, cPath, "ClientD"        )
      AppDbf( cPathOld, cPath, "CliFacturae"    )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxClient( cPath, oMeter )

   local dbfCli

   DEFAULT cPath  := cPatCli()

   AssertClient( cPath )

   fEraseIndex( cPath + "CLIENT.CDX" )

   dbUseArea( .t., cDriver(), cPath + "CLIENT.DBF", cCheckArea( "CLIENT", @dbfCli ), .f. )
   if !( dbfCli )->( neterr() )
      ( dbfCli )->( __dbPack() )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "COD", "Field->COD", {|| Field->COD } ) )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "TITULO", "UPPER( Field->TITULO )", {|| UPPER( Field->TITULO ) }, ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "NIF", "Field->NIF", {|| Field->NIF }, ) )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "POBLACION", "UPPER( Field->POBLACION )", {|| UPPER( Field->POBLACION ) } ) )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "PROVINCIA", "UPPER( Field->PROVINCIA )", {|| UPPER( Field->PROVINCIA ) } ) )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "CodPostal", "Field->CodPostal", {|| Field->CodPostal } ) )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "Telefono", "Field->Telefono", {|| Field->Telefono } ) )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "NbrEst", "Field->NbrEst", {|| Field->NbrEst } ) )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "cMeiInt", "Upper( Field->cMeiInt )", {|| Upper( Field->cMeiInt ) } ) )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "CCODRUT", "UPPER( Field->CCODRUT )", {|| UPPER( Field->CCODRUT ) } ) )

      ( dbfCli )->( ordCondSet("!Deleted() .and. nTipCli == 3", {||!Deleted() .and. Field->nTipCli == 3 } ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "cCliWeb", "COD", {|| Field->COD } ) )      

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "lSndInt", "Field->lSndInt", {|| Field->lSndInt } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfCli )->( ordCreate( cPath + "Client.Cdx", "cCodUsr", "Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg", {|| Field->cCodUsr + Dtos( Field->dFecChg ) + Field->cTimChg } ) )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "CODBIG", "UPPER( Field->COD )", {|| UPPER( Field->COD ) } ) )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "cCodWeb", "Str( Field->cCodWeb, 11 )", {|| Str( Field->cCodWeb, 11 ) } ) )

      ( dbfCli )->( ordCondSet("!Deleted() .and. Field->lSndInt" , {||!Deleted() .and. Field->lSndInt }  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "lSndEnviar", "Field->Cod", {|| Field->Cod } ) )

      ( dbfCli )->( ordCondSet("!Deleted() .and. Field->lSndInt .and. Field->lPubInt" , {||!Deleted() .and. Field->lSndInt .and. Field->lPubInt }  ) )
      ( dbfCli )->( ordCreate( cPath + "Client.CDX", "lPubInt", "Field->Cod", {|| Field->Cod } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "cUsrDef01", "UPPER( Field->cUsrDef01 )", {|| UPPER( Field->cUsrDef01 ) } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "cUsrDef02", "UPPER( Field->cUsrDef02 )", {|| UPPER( Field->cUsrDef02 ) } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "cUsrDef03", "UPPER( Field->cUsrDef03 )", {|| UPPER( Field->cUsrDef03 ) } ) )

      ( dbfCli )->( ordCondSet( "!Deleted() .and. !Field->lBlqCli", {|| !Deleted() .and. !Field->lBlqCli }  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "lBlqCli", "Field->Cod", {|| Field->Cod } ) )

      ( dbfCli )->( ordCondSet( "!Deleted() .and. Field->lVisLun", {|| !Deleted() .and. Field->lVisLun }  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "lVisLun", "Str( Field->nVisLun )", {|| Str( Field->nVisLun ) } ) )

      ( dbfCli )->( ordCondSet( "!Deleted() .and. Field->lVisMar", {|| !Deleted() .and. Field->lVisMar }  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "lVisMar", "Str( Field->nVisMar )", {|| Str( Field->nVisMar ) } ) )

      ( dbfCli )->( ordCondSet( "!Deleted() .and. Field->lVisMie", {|| !Deleted() .and. Field->lVisMie }  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "lVisMie", "Str( Field->nVisMie )", {|| Str( Field->nVisMie ) } ) )

      ( dbfCli )->( ordCondSet( "!Deleted() .and. Field->lVisJue", {|| !Deleted() .and. Field->lVisJue }  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "lVisJue", "Str( Field->nVisJue )", {|| Str( Field->nVisJue ) } ) )

      ( dbfCli )->( ordCondSet( "!Deleted() .and. Field->lVisVie", {|| !Deleted() .and. Field->lVisVie }  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "lVisVie", "Str( Field->nVisVie )", {|| Str( Field->nVisVie ) } ) )

      ( dbfCli )->( ordCondSet( "!Deleted() .and. Field->lVisSab", {|| !Deleted() .and. Field->lVisSab }  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "lVisSab", "Str( Field->nVisSab )", {|| Str( Field->nVisSab ) } ) )

      ( dbfCli )->( ordCondSet( "!Deleted() .and. Field->lVisDom", {|| !Deleted() .and. Field->lVisDom }  ) )
      ( dbfCli )->( ordCreate( cPath + "CLIENT.CDX", "lVisDom", "Str( Field->nVisDom )", {|| Str( Field->nVisDom ) } ) )

      ( dbfCli )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de clientes" )

   end if

   fEraseIndex( cPath + "ObrasT.CDX" )

   dbUseArea( .t., cDriver(), cPath + "OBRAST.DBF", cCheckArea( "OBRAST", @dbfCli ), .f. )
   if !( dbfCli )->( neterr() )
      ( dbfCli )->( __dbPack() )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "ObrasT.CDX", "CCODCLI", "cCodCli + cCodObr", {|| Field->cCodCli + Field->cCodObr } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "ObrasT.Cdx", "CNOMOBR", "cCodCli + cNomObr", {|| Field->cCodCli + Field->cNomObr } ) )

      ( dbfCli )->( ordCondSet("lDefObr .and. !Deleted()", {|| Field->lDefObr .and. !Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "OBRAST.CDX", "lDefObr", "cCodCli", {|| Field->cCodCli } ) )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "OBRAST.CDX", "CCODIGO", "cCodObr", {|| Field->cCodObr } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "ObrasT.Cdx", "CNOMBRE", "cNomObr", {|| Field->cNomObr } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "ObrasT.Cdx", "CCODWEB", "Str( cCodWeb, 11 )", {|| Str( Field->cCodWeb, 11 ) } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "ObrasT.Cdx", "CDIROBR", "Upper( cDirObr )", {|| Upper( Field->cDirObr ) } ) )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "OBRAST.CDX", "cCodPos", "cCodPos", {|| Field->cCodPos } ) )

      ( dbfCli )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de obras" )
   end if

   fEraseIndex( cPath + "CliBnc.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "CliBnc.DBF", cCheckArea( "CliBnc", @dbfCli ), .f. )
   if !( dbfCli )->( neterr() )
      ( dbfCli )->( __dbPack() )

      ( dbfCli )->( ordCondSet( "!Deleted()", {|| !Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CliBnc.CDX", "cCodCli", "cCodCli", {|| Field->cCodCli } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfCli )->( ordCreate( cPath + "CliBnc.CDX", "cCtaBnc", "cCodCli + cEntBnc + cSucBnc + cDigBnc + cCtaBnc", {|| Field->cCodCli + Field->cEntBnc + Field->cSucBnc + Field->cDigBnc + Field->cCtaBnc } ) )

      ( dbfCli )->( ordCondSet("!Deleted() .and. lBncDef", {|| !Deleted() .and. Field->lBncDef } ) )
      ( dbfCli )->( ordCreate( cPath + "CliBnc.CDX", "cBncDef", "cCodCli", {|| Field->cCodCli } ) )

      ( dbfCli )->( ordCondSet("!Deleted() .and. lBncDef", {|| !Deleted() .and. Field->lBncDef } ) )
      ( dbfCli )->( ordCreate( cPath + "CliBnc.CDX", "cCodDef", "cCodCli + cEntBnc + cSucBnc + cDigBnc + cCtaBnc", {|| Field->cCodCli + Field->cEntBnc + Field->cSucBnc + Field->cDigBnc + Field->cCtaBnc } ) )

      ( dbfCli )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de bancos de clientes" )

   end if

   fEraseIndex( cPath + "ClientD.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "ClientD.DBF", cCheckArea( "ClientD", @dbfCli ), .f. )
   if !( dbfCli )->( neterr() )
      ( dbfCli )->( __dbPack() )

      ( dbfCli )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "ClientD.CDX", "cCodCli", "cCodCli", {|| Field->cCodCli } ) )

      ( dbfCli )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de documentos" )
   end if

   fEraseIndex( cPath + "CliInc.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "CliInc.Dbf", cCheckArea( "CliInc", @dbfCli ), .f. )
   if !( dbfCli )->( neterr() )
      ( dbfCli )->( __dbPack() )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CliInc.Cdx", "CCODCLI", "CCODCLI", {|| Field->CCODCLI } ) )

      ( dbfCli )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de incidencias" )
   end if

   // Tabla de contactos-------------------------------------------------------

   fEraseIndex( cPath + "CliContactos.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "CliContactos.Dbf", cCheckArea( "CLICONTA", @dbfCli ), .f. )

   if !( dbfCli )->( neterr() )
      ( dbfCli )->( __dbPack() )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CliContactos.Cdx", "cCodCli", "cCodCli", {|| Field->cCodCli } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CliContactos.Cdx", "cNomCon", "cNomCon", {|| Field->cNomCon } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CliContactos.Cdx", "cPosCon", "cPosCon", {|| Field->cPosCon } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CliContactos.Cdx", "cTelCon", "cTelCon", {|| Field->cTelCon } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CliContactos.Cdx", "cMovCon", "cMovCon", {|| Field->cMovCon } ) )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CliContactos.Cdx", "cMaiCon", "cMaiCon", {|| Field->cMaiCon } ) )

      ( dbfCli )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de contactos de clientes." )
   end if

   // Tabla de contactos-------------------------------------------------------

   fEraseIndex( cPath + "CliFacturae.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "CliFacturae.Dbf", cCheckArea( "CliFacturae", @dbfCli ), .f. )

   if !( dbfCli )->( neterr() )
      ( dbfCli )->( __dbPack() )

      ( dbfCli )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfCli )->( ordCreate( cPath + "CliFacturae.Cdx", "cCodCli", "cCodCli", {|| Field->cCodCli } ) )

      ( dbfCli )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de facturae de clientes." )
   end if


RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   IF !lExistTable( cPath + "CLIENT.DBF" )
      dbCreate( cPath + "CLIENT.DBF", aSqlStruct( aItmCli() ), cDriver() )
   END IF

   IF !lExistTable( cPath + "CLIATP.DBF" )
      dbCreate( cPath + "CLIATP.DBF", aSqlStruct( aItmAtp() ), cDriver() )
   END IF

   IF !lExistTable( cPath + "OBRAST.DBF" )
      dbCreate( cPath + "OBRAST.DBF", aSqlStruct( aItmObr() ), cDriver() )
   END IF

   IF !lExistTable( cPath + "CLIENTD.DBF" )
      dbCreate( cPath + "CLIENTD.DBF", aSqlStruct( aCliDoc() ), cDriver() )
   END IF

   IF !lExistTable( cPath + "CLIBNC.DBF" )
      dbCreate( cPath + "CLIBNC.DBF", aSqlStruct( aCliBnc() ), cDriver() )
   END IF

   if !lExistTable( cPath + "CLIINC.DBF" )
      dbCreate( cPath + "CLIINC.DBF", aSqlStruct( aCliInc() ), cDriver() )
   end if

   if !lExistTable( cPath + "CLICONTACTOS.Dbf" )
      dbCreate( cPath + "CLICONTACTOS.Dbf", aSqlStruct( aItmContacto() ), cDriver() )
   end if

   if !lExistTable( cPath + "CliFacturae.Dbf" )
      dbCreate( cPath + "CliFacturae.Dbf", aSqlStruct( aCliFacturae() ), cDriver() )
   end if


RETURN NIL

//---------------------------------------------------------------------------//

function aCliInc()

   local aBase := {}

   aAdd( aBase, { "cCodCli",     "C", 12, 0, "Código del cliente",               "Código",            "", "( cDbfInc )" } )
   aAdd( aBase, { "cCodTip",     "C",  3, 0, "Tipo de incidencia" ,              "",                  "", "( cDbfInc )" } )
   aAdd( aBase, { "dFecInc",     "D",  8, 0, "Fecha de la incidencia" ,          "Fecha",             "", "( cDbfInc )" } )
   aAdd( aBase, { "mDesInc",     "M", 10, 0, "Descripción de la incidencia" ,    "Nombre",            "", "( cDbfInc )" } )
   aAdd( aBase, { "lListo",      "L",  1, 0, "Lógico de listo" ,                 "",                  "", "( cDbfInc )" } )
   aAdd( aBase, { "lAviso",      "L",  1, 0, "Lógico de aviso" ,                 "",                  "", "( cDbfInc )" } )

return ( aBase )

//---------------------------------------------------------------------------//

FUNCTION aCliBnc()

   local aBase := {}

   aAdd( aBase, { "cCodCli",     "C", 12, 0, "Código del cliente",                        "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "lBncDef",     "L",  1, 0, "Lógico banco por defecto",                  "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cCodBnc",     "C", 50, 0, "Nombre del banco",                          "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cDirBnc",     "C", 35, 0, "Domicilio del banco",                       "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cPobBnc",     "C", 25, 0, "Población del banco",                       "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cProBnc",     "C", 20, 0, "Provincia del banco",                       "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cCPBnc",      "C", 15, 0, "Código postal",                             "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cTlfBnc",     "C", 20, 0, "Teléfono",                                  "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cFaxBnc",     "C", 20, 0, "Fax",                                       "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cPContBnc",   "C", 35, 0, "Persona de contacto",                       "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cPaiBnc",     "C",  4, 0, "Pais",                                      "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cPaisIBAN",   "C",  2, 0, "País IBAN",                                 "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cCtrlIBAN",   "C",  2, 0, "Dígito de control IBAN",                    "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cEntBnc",     "C",  4, 0, "Entidad de la cuenta bancaria",             "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cSucBnc",     "C",  4, 0, "Sucursal de la cuenta bancaria",            "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cDigBnc",     "C",  2, 0, "Dígito de control de la cuenta bancaria",   "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cCtaBnc",     "C", 20, 0, "Cuenta bancaria",                           "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "nSalIni",     "N", 16, 6, "Saldo inicial",                             "",                   "", "( cDbfBnc )" } )

RETURN ( aBase )

//----------------------------------------------------------------------------//

function aCliDoc()

   local aCliDoc  := {}

   aAdd( aCliDoc, { "cCodCli", "C",   12,  0, "Código del cliente" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aCliDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,           "",                   "", "( cDbfCol )" } )
   aAdd( aCliDoc, { "cRuta",   "C",  250,  0, "Ruta del documento" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aCliDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,    "",                   "", "( cDbfCol )" } )

return ( aCliDoc )

//--------------------------------------------------------------------------//

function aCliFacturae()

   local aCliFacturae  := {}

   aAdd( aCliFacturae, { "cCodCli", "C",   12,  0, "Código del cliente" ,        "",                   "", "( cDbfCol )" } )
   aAdd( aCliFacturae, { "cOfiCnt", "C",   14,  0, "Oficina contable" ,          "",                   "", "( cDbfCol )" } )
   aAdd( aCliFacturae, { "cOrgGes", "C",   14,  0, "Organo gestor" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aCliFacturae, { "cUniTrm", "C",   14,  0, "Unidad tramitadora" ,        "",                   "", "( cDbfCol )" } )

return ( aCliFacturae )

//--------------------------------------------------------------------------//

FUNCTION aItmAtp()

   local aBase := {}

   aAdd( aBase,  { "cCodCli",   "C", 12, 0, "Código del cliente" }                     )
   aAdd( aBase,  { "cCodGrp",   "C",  4, 0, "Código de grupo de cliente" }             )
   aAdd( aBase,  { "cCodArt",   "C", 18, 0, "Código de artículo en atipicas" }         )
   aAdd( aBase,  { "cCodFam",   "C", 16, 0, "Código de familias en atipicas" }         )
   aAdd( aBase,  { "nTipAtp",   "N",  1, 0, "Tipo de atípicas" }                       )
   aAdd( aBase,  { "cCodPr1",   "C", 20, 0, "Código propiedad 1" }                     )
   aAdd( aBase,  { "cValPr1",   "C", 40, 0, "Valor propiedad 1" }                      )
   aAdd( aBase,  { "cCodPr2",   "C", 20, 0, "Código propiedad 2" }                     )
   aAdd( aBase,  { "cValPr2",   "C", 40, 0, "Valor propiedad 2" }                      )
   aAdd( aBase,  { "dFecIni",   "D",  8, 0, "Fecha inicio de la situación atipica" }   )
   aAdd( aBase,  { "dFecFin",   "D",  8, 0, "Fecha fin de la situación atipica" }      )
   aAdd( aBase,  { "lPrcCom",   "L",  1, 0, "Lógico para precio de compras personal" } )
   aAdd( aBase,  { "nPrcCom",   "N", 16, 6, "Precio de coste" }                        )
   aAdd( aBase,  { "nPrcArt",   "N", 16, 6, "Precio de venta 1 del artículo" }         )
   aAdd( aBase,  { "nPrcArt2",  "N", 16, 6, "Precio de venta 2 del artículo" }         )
   aAdd( aBase,  { "nPrcArt3",  "N", 16, 6, "Precio de venta 3 del artículo" }         )
   aAdd( aBase,  { "nPrcArt4",  "N", 16, 6, "Precio de venta 4 del artículo" }         )
   aAdd( aBase,  { "nPrcArt5",  "N", 16, 6, "Precio de venta 5 del artículo" }         )
   aAdd( aBase,  { "nPrcArt6",  "N", 16, 6, "Precio de venta 6 del artículo" }         )
   aAdd( aBase,  { "nPreIva1",  "N", 16, 6, "Precio de venta 1 con " + cImp() }        )
   aAdd( aBase,  { "nPreIva2",  "N", 16, 6, "Precio de venta 2 con " + cImp() }        )
   aAdd( aBase,  { "nPreIva3",  "N", 16, 6, "Precio de venta 3 con " + cImp() }        )
   aAdd( aBase,  { "nPreIva4",  "N", 16, 6, "Precio de venta 4 con " + cImp() }        )
   aAdd( aBase,  { "nPreIva5",  "N", 16, 6, "Precio de venta 5 con " + cImp() }        )
   aAdd( aBase,  { "nPreIva6",  "N", 16, 6, "Precio de venta 6 con " + cImp() }        )
   aAdd( aBase,  { "nDtoArt",   "N",  6, 2, "Descuento del articulo" }                 )
   aAdd( aBase,  { "nDprArt",   "N",  6, 2, "Descuento promocional del articulo" }     )
   aAdd( aBase,  { "lComAge",   "L",  1, 0, "Lógico para tener en cuenta el porcentaje o no" } )
   aAdd( aBase,  { "nComAge",   "N",  6, 2, "Comisión del agente" }                    )
   aAdd( aBase,  { "nDtoDiv",   "N", 16, 6, "Descuento lineal" }                       )
   aAdd( aBase,  { "lAplPre",   "L",  1, 0, "Aplicar en presupuestos" }                )
   aAdd( aBase,  { "lAplPed",   "L",  1, 0, "Aplicar en pedidos" }                     )
   aAdd( aBase,  { "lAplAlb",   "L",  1, 0, "Aplicar en albaranes" }                   )
   aAdd( aBase,  { "lAplFac",   "L",  1, 0, "Aplicar en facturas" }                    )
   aAdd( aBase,  { "lAplSat",   "L",  1, 0, "Aplicar en S.A.T." }                      )
   aAdd( aBase,  { "nUnvOfe",   "N",  3, 0, "Unidades a vender en la oferta" }         )
   aAdd( aBase,  { "nUncOfe",   "N",  3, 0, "Unidades a cobrar en la oferta" }         )
   aAdd( aBase,  { "nTipXby",   "N",  1, 0, "Tipo de oferta" }                         )
   aAdd( aBase,  { "nDto1",     "N",  6, 2, "Descuento de tarifa de venta 1" }         )
   aAdd( aBase,  { "nDto2",     "N",  6, 2, "Descuento de tarifa de venta 2" }         )
   aAdd( aBase,  { "nDto3",     "N",  6, 2, "Descuento de tarifa de venta 3" }         )
   aAdd( aBase,  { "nDto4",     "N",  6, 2, "Descuento de tarifa de venta 4" }         )
   aAdd( aBase,  { "nDto5",     "N",  6, 2, "Descuento de tarifa de venta 5" }         )
   aAdd( aBase,  { "nDto6",     "N",  6, 2, "Descuento de tarifa de venta 6" }         ) 

RETURN ( aBase )

//---------------------------------------------------------------------------//
/*
Estructura de clientes
*/

FUNCTION aItmCli()

   local aBase := {}

   aAdd( aBase, { "Cod",       "C", 12, 0, "Código",                                        "Codigo",             "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Titulo",    "C", 80, 0, "Nombre",                                        "Nombre",             "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Nif",       "C", 15, 0, "NIF",                                           "NIF",                "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Domicilio", "C",200, 0, "Domicilio",                                     "Domicilio",          "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Poblacion", "C",200, 0, "Población",                                     "Poblacion",          "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Provincia", "C",100, 0, "Provincia",                                     "Provincia",          "", "( cDbfCli )", nil } )
   aAdd( aBase, { "CodPostal", "C", 15, 0, "Código postal",                                 "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Telefono",  "C", 20, 0, "Teléfono",                                      "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Fax",       "C", 20, 0, "Fax",                                           "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Movil",     "C", 20, 0, "Móvil",                                         "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "NbrEst",    "C", 35, 0, "Nombre del establecimiento" ,                   "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Direst",    "C", 35, 0, "Domicilio del servicio" ,                       "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "DiaPago",   "N",  2, 0, "Primer día de pago",                            "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "DiaPago2",  "N",  2, 0, "Segundo día de pago",                           "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Banco",     "C", 50, 0, "Nombre del banco",                              "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "DirBanco",  "C", 35, 0, "Domicilio del banco",                           "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "PobBanco",  "C", 25, 0, "Población del banco",                           "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cProBanco", "C", 20, 0, "Provincia del banco",                           "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Cuenta",    "C", 20, 0, "",                                              "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nTipCli",   "N",  1, 0, "Tipo",                                          "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "CodPago",   "C",  2, 0, "Código del tipo de pago",                       "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cDtoEsp",   "C", 50, 0, "Descripción del descuento por factura" ,        "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDtoEsp",   "N",  6, 2, "Porcentaje de descuento por factura" ,          "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cDpp",      "C", 50, 0, "Descripción del descuento por pronto pago" ,    "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDpp",      "N",  6, 2, "Porcentaje de descuento por pronto pago" ,      "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDtoCnt",   "N",  6, 2, "Porcentaje del primer dto personalizado" ,      "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDtoRap",   "N",  6, 2, "Porcentaje del segundo dto personalizado" ,     "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cDtoUno",   "C", 50, 0, "Descripción del primer dto personalizado" ,     "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cDtoDos",   "C", 50, 0, "Descripción del segundo dto personalizado" ,    "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDtoPtf",   "N",  6, 2, "Importe de descuento plataforma" ,              "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Riesgo",    "N", 16, 6, "Importe maximo autorizado para operaciones",    "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "CopiasF",   "N",  1, 0, "Número de facturas a imprimir",                 "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Serie",     "C",  1, 0, "Código de la serie de facturas",                "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nRegIva",   "N",  1, 0, "Regimen de " + cImp(),                          "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lReq",      "L",  1, 0, "Lógico para recargo de equivalencia (S/N)",     "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "Subcta",    "C", 12, 0, "Subcuenta cliente enlace contaplus",            "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "CtaVenta",  "C",  3, 0, "Cuenta venta cliente contaplus",                "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgente",   "C",  3, 0, "Código agente comercial",                       "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lMayorista","L",  1, 0, "Utilizar precio de mayorista (S/N)" ,           "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nTarifa",   "N",  1, 0, "Tarifa a aplicar" ,                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lLabel",    "L",  1, 0, "Lógico para etiquetado (S/N)" ,                 "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nLabel",    "N",  5, 0, "Número de etiquetas a imprimir" ,               "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodTar",   "C",  5, 0, "Código de tarifa" ,                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "mComent",   "M", 10, 0, "Memo para comentarios" ,                        "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodRut",   "C",  4, 0, "Código de ruta" ,                               "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodRut2",  "C",  4, 0, "Código de ruta alternativa" ,                   "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodPai",   "C",  4, 0, "Código de país" ,                               "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodGrp",   "C",  4, 0, "Código de grupo de cliente" ,                   "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodRem",   "C",  3, 0, "Código de remesa" ,                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cMeiInt",   "C", 65, 0, "Correo electrónico" ,                           "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cWebInt",   "C", 65, 0, "Página web" ,                                   "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lChgPre",   "L",  1, 0, "Lógico para autorización de venta de crédito" , "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lCreSol",   "L",  1, 0, "Lógico para bloquear con riesgo alcanzado" ,    "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lPntVer",   "L",  1, 0, "Lógico para operar con punto verde" ,           "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef01", "C",100, 0, "Campo definido 1" ,                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef02", "C",100, 0, "Campo definido 2" ,                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef03", "C",100, 0, "Campo definido 3" ,                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef04", "C",100, 0, "Campo definido 4" ,                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef05", "C",100, 0, "Campo definido 5" ,                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef06", "C",100, 0, "Campo definido 6" ,                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef07", "C",100, 0, "Campo definido 7" ,                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef08", "C",100, 0, "Campo definido 8" ,                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef09", "C",100, 0, "Campo definido 9" ,                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cUsrDef10", "C",100, 0, "Campo definido 10" ,                            "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisLun",   "L",  1, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisMar",   "L",  1, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisMie",   "L",  1, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisJue",   "L",  1, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisVie",   "L",  1, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisSab",   "L",  1, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lVisDom",   "L",  1, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisLun",   "N",  4, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisMar",   "N",  4, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisMie",   "N",  4, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisJue",   "N",  4, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisVie",   "N",  4, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisSab",   "N",  4, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nVisDom",   "N",  4, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeLun",   "C",  3, 0, "Código agente para visita lunes",               "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeMar",   "C",  3, 0, "Código agente para visita martes",              "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeMie",   "C",  3, 0, "Código agente para visita miercoles",           "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeJue",   "C",  3, 0, "Código agente para visita jueves",              "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeVie",   "C",  3, 0, "Código agente para visita viernes",             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeSab",   "C",  3, 0, "Código agente para visita sabado",              "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cAgeDom",   "C",  3, 0, "Código agente para visita domingo",             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lSndInt",   "L",  1, 0, "Lógico para envio por internet" ,               "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cPerCto",   "C",200, 0, "Persona de contacto" ,                          "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodAlm",   "C", 16, 0, "Código de almacén",                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nMesVac",   "N",  2, 0, "Mes de vacaciones",                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nImpRie",   "N", 16, 6, "Riesgo alcanzado",                              "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nColor",    "N", 10, 0, "",                                              "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "SubCtaDto", "C", 12, 0, "Código subcuenta descuento",                    "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lBlqCli",   "L",  1, 0, "Cliente bloqueado" ,                            "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lMosCom",   "L",  1, 0, "Mostrar comentario" ,                           "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lTotAlb",   "L",  1, 0, "Totalizar albaranes" ,                          "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cDtoAtp",   "C", 50, 0, "Descripción del descuento atipico" ,            "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDtoAtp",   "N",  6, 2, "Porcentaje de descuento atípico" ,              "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nSbrAtp",   "N",  1, 0, "" ,                                             "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodUsr",   "C",  3, 0, "Código de usuario que realiza el cambio" ,      "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "dFecChg",   "D",  8, 0, "Fecha de cambio" ,                              "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cTimChg",   "C",  5, 0, "Hora de cambio" ,                               "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nTipRet",   "N",  1, 0, "Tipo de retención ( 1-Base / 2-Base+IVA )",     "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nPctRet",   "N",  6, 2, "Porcentaje de retención",                       "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "dFecBlq",   "D",  8, 0, "Fecha de bloqueo del cliente",                  "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cMotBlq",   "C",250, 0, "Motivo del bloqueo del cliente",                "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lModDat",   "L",  1, 0, "Lógico para no modificar datos en la venta" ,   "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lMail",     "L",  1, 0, "Lógico para enviar mail" ,                      "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodTrn",   "C",  9, 0, "Código del transportista" ,                     "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "mObserv",   "M", 10, 0, "Observaciones",                                 "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lPubInt",   "L",  4, 0, "Lógico para publicar en internet (S/N)",        "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cClave",    "C", 40, 0, "Contraseña cliente para Web",                   "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodWeb",   "N", 11, 0, "Código del cliente en la web",                  "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cCodEdi",   "C", 17, 0, "Código del cliente en EDI (EAN)",               "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cFacAut",   "C",  3, 0, "Código de factura automática",                  "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lWeb",      "L",  4, 0, "Lógico para creado desde internet (S/N)",       "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nDtoArt",   "N",  1, 0, "Descuento de artículo",                         "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "lExcFid",   "L",  1, 0, "Lógico para creado desde internet (S/N)",       "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "mFacAut",   "M", 10, 0, "Plantillas de facturas automáticas",            "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "dFecNaci",  "D",  8, 0, "Fecha de nacimiento",                           "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nSexo",     "N",  1, 0, "Sexo del cliente",                              "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "nTarCmb",   "N",  1, 0, "Tarifa a aplicar para combinar en táctil" ,     "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "dLlaCli",   "D",  8, 0, "Última llamada del cliente" ,                   "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cTimCli",   "C",  5, 0, "Hora última llamada del cliente" ,              "",                   "", "( cDbfCli )", nil } )
   aAdd( aBase, { "cTipInci",  "C",  5, 0, "Tipo de incidencia" ,                           "",                   "", "( cDbfCli )", nil } )

RETURN ( aBase )

//----------------------------------------------------------------------------//
/*
Devuelve si el cliente tiene autorización para ventas de credito
*/

FUNCTION lCliBlq( cCodCli, dbfCli )

   local lRet     := .f.

   if dbSeekInOrd( cCodCli, "Cod", dbfCli )
      lRet        := ( dbfCli )->lBlqCli
   end if

RETURN lRet

//---------------------------------------------------------------------------//

FUNCTION GetRiesgo( cCodCli, dbfCli, oRieCli )

   local nImpRiesgo := 0
   local aCliStatus

   if Empty( cCodCli )
      oRieCli:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
      oRieCli:cText( nImpRiesgo )
      Return ( nImpRiesgo )
   end if

   aCliStatus  := aGetStatus( dbfCli, .t. )

   if ( dbfCli )->( dbSeek( cCodCli ) )

      nImpRiesgo     := ( dbfCli )->nImpRie

      if oRieCli != nil

         if nImpRiesgo != 0 .and. nImpRiesgo >= ( dbfCli )->Riesgo
            oRieCli:SetColor( Rgb( 255, 0, 0 ), Rgb( 255, 255, 255 ) )
         else
            oRieCli:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
         end if

         oRieCli:cText( nImpRiesgo )

      end if

   end if

   SetStatus( dbfCli, aCliStatus )

return ( nImpRiesgo )

//---------------------------------------------------------------------------//

Function nXbYAtipica( cCodArt, cCodCli, nCajVen, nUndVen, dFecOfe, dbfAtpCli )

   local a
   local nModOfe     := 0
   local nTipXbY     := 0
   local nUndGrt     := 0
   local aXbYRet     := { 0, 0 }
   local nOrd        := ( dbfAtpCli )->( OrdSetFocus( "cCliArt" ) )

   /*
   Primero buscar si existe el articulo en la oferta
   */

   if ( dbfAtpCli )->( dbSeek( cCodCli + cCodArt ) )

      while ( dbfAtpCli )->cCodCli + ( dbfAtpCli )->cCodArt == cCodCli + cCodArt .and. !( dbfAtpCli )->( eof() )

         a           := aXbY( nCajVen, nUndVen, dFecOfe, dbfAtpCli )

         if IsArray( a )
            aXbYRet  := a
            exit 
         end if 

         ( dbfAtpCli )->( dbSkip() )

      end do

   end if

   ( dbfAtpCli )->( OrdSetFocus( nOrd ) )

Return ( aXbYRet )

//---------------------------------------------------------------------------//

Function aXbYGrupo( cCodArt, cCodGrp, nCajVen, nUndVen, dFecOfe, dbfAtpCli )

   local a
   local aXbYRet     := { 0, 0 }
   local nOrd        := ( dbfAtpCli )->( OrdSetFocus( "cGrpArt" ) )

   /*
   Primero buscar si existe el articulo en la oferta
   */

   if ( dbfAtpCli )->( dbSeek( cCodGrp + cCodArt ) )

      while ( dbfAtpCli )->cCodGrp + ( dbfAtpCli )->cCodArt == cCodGrp + cCodArt .and. !( dbfAtpCli )->( eof() )

         a           := aXbY( nCajVen, nUndVen, dFecOfe, dbfAtpCli )

         if IsArray( a )
            aXbYRet  := a
            exit 
         end if 

         ( dbfAtpCli )->( dbSkip() )

      end do

   end if

   ( dbfAtpCli )->( OrdSetFocus( nOrd ) )

Return ( aXbYRet )

//---------------------------------------------------------------------------//

Function aXbYAtipica( cCodArt, cCodCli, cCodGrp, nCajVen, nUndVen, dFecOfe, dbfAtpCli )

   local aXbY  := nXbYAtipica( cCodArt, cCodCli, nCajVen, nUndVen, dFecOfe, dbfAtpCli ) 

   if Empty( aXbY )
      aXbY     := aXbYGrupo( cCodArt, cCodGrp, nCajVen, nUndVen, dFecOfe, dbfAtpCli )
   end if

Return ( aXbY )

//---------------------------------------------------------------------------//

Static Function aXbY( nCajVen, nUndVen, dFecOfe, dbfAtpCli )

   local aXbYRet  
   local nModOfe  := 0
   local nTipXbY  := 0
   local nUndGrt  := 0

   /*
   Comprobamos si esta entre las fechas----------------------------------
   */

   if ( dFecOfe >= ( dbfAtpCli )->dFecIni .or. Empty( ( dbfAtpCli )->dFecIni ) ) .and. ;
      ( dFecOfe <= ( dbfAtpCli )->dFecFin .or. Empty( ( dbfAtpCli )->dFecFin ) ) .and. ;
      ( dbfAtpCli )->nUnvOfe != 0                                                .and. ;
      ( dbfAtpCli )->nUncOfe != 0

      /*
      Vamos a comprobar si la oferta es de unidades o de cajas-----------
      */

      nTipXbY     := ( dbfAtpCli )->nTipXbY

      if nTipXbY == 1   // Cajas

         if mod( nCajVen, ( dbfAtpCli )->nUnvOfe ) == 0

            /*
            Multiplos de la oferta---------------------------------------
            */

            nModOfe     := Int( Div( nCajVen, ( dbfAtpCli )->nUnvOfe ) )
            nUndGrt     := ( ( dbfAtpCli )->nUnvOfe - ( dbfAtpCli )->nUncOfe ) * nModOfe
            aXbYRet     := { nTipXbY, nUndGrt }

         end if

      else

         /*
         Comprobamos el numero de unidades a vender es igual a de la oferta
         o si al dividirlo devuelve un numero de resto 0 tendremos un
         multiplo de la oferta
         */

         if mod( nCajVen * nUndVen, ( dbfAtpCli )->nUnvOfe ) == 0

            /*
            Multiplos de la oferta
            */
            
            nModOfe     := Int( Div( ( nCajVen * nUndVen ), ( dbfAtpCli )->nUnvOfe ) )
            nUndGrt     := ( ( dbfAtpCli )->nUnvOfe - ( dbfAtpCli )->nUncOfe ) * nModOfe
            aXbYRet     := { nTipXbY, nUndGrt }

         end if

      end if

   end if 

Return ( aXbyRet )

//---------------------------------------------------------------------------//

function lSeekAtpFam( cCadSea, dFecDoc, dbfCliAtp )

   local lSea     := .f.
   local nOrd     := ( dbfCliAtp )->( OrdSetFocus( "cCodFam" ) )

   if ( dbfCliAtp )->( dbSeek( cCadSea ) )

      while ( dbfCliAtp )->cCodCli + ( dbfCliAtp )->cCodFam == cCadSea .and.;
            !( dbfCliAtp )->( eof() )

         if ( ( dbfCliAtp )->dFecIni <= dFecDoc .or. Empty( ( dbfCliAtp )->dFecIni ) ) .and. ;
            ( ( dbfCliAtp )->dFecFin >= dFecDoc .or. Empty( ( dbfCliAtp )->dFecFin ) ) .and. ;
            ( dbfCliAtp )->nTipAtp == 2

            lSea  := .t.
            
            exit

         else

            ( dbfCliAtp )->( dbSkip() )

         end if

      end while

   end if

   ( dbfCliAtp )->( OrdSetFocus( nOrd ) )

return ( lSea )

//---------------------------------------------------------------------------//

function nDtoAtp( nTarifa, dbfCliAtp, oDto, oTarifa )

   local nDto        := 0

   DEFAULT nTarifa   := 1

   if nTarifa == 0
      nTarifa        := 1
   end if

   while .t.

      do case
         case nTarifa == 1
            nDto     := ( dbfCliAtp)->nDto1
         case nTarifa == 2
            nDto     := ( dbfCliAtp)->nDto2
         case nTarifa == 3
            nDto     := ( dbfCliAtp)->nDto3
         case nTarifa == 4
            nDto     := ( dbfCliAtp)->nDto4
         case nTarifa == 5
            nDto     := ( dbfCliAtp)->nDto5
         case nTarifa == 6
            nDto     := ( dbfCliAtp)->nDto6
      end do

      if nDto == 0 .and. nTarifa > 1 .and. lBuscaImportes()
         nTarifa--
         loop
      else
         exit
      end if

   end while

   /*
   Si no encontramos ningun descuento ponemos el general-----------------------
   */

   if nDto == 0
      nDto           := ( dbfCliAtp)->nDtoArt
   end if

   /*
   Ponemos el valor en el control----------------------------------------------
   */

   if nDto != 0 .and. oDto != nil
      oDto:cText( nDto )
   end if

   /*
   Ponemos la tarifa utilizada en el control-----------------------------------
   */

   if oTarifa != nil
      oTarifa:cText( nTarifa )
   end if

return ( nDto )

//---------------------------------------------------------------------------//

Function nImpAtp( nTarifa, dbfCliAtp, uPreUnt, nIva, oTarifa )

   local nPre        := 0

   DEFAULT nTarifa   := 1
   DEFAULT nIva      := 0

   if nTarifa == 0
      nTarifa        := 1
   end if

   while .t.

      do case
         case nTarifa == 1
            nPre     := ( dbfCliAtp )->nPrcArt
         case nTarifa == 2
            nPre     := ( dbfCliAtp )->nPrcArt2
         case nTarifa == 3
            nPre     := ( dbfCliAtp )->nPrcArt3
         case nTarifa == 4
            nPre     := ( dbfCliAtp )->nPrcArt4
         case nTarifa == 5
            nPre     := ( dbfCliAtp )->nPrcArt5
         case nTarifa == 6
            nPre     := ( dbfCliAtp )->nPrcArt6
      end do

      if nPre == 0 .and. nTarifa > 1 .and. lBuscaImportes()
         nTarifa--
         loop
      else
         exit
      end if

   end while

   if nIva != 0
      nPre           += nPre * nIva / 100
   end if

   if nPre != 0 .and. uPreUnt != nil
      uPreUnt:cText( nPre )
   end if

   if oTarifa != nil
      oTarifa:cText( nTarifa )
   end if

return ( nPre )
 
//---------------------------------------------------------------------------//

function lSeekAtpArt( cCadSea, cCodPrp, cValPrp, dFecDoc, dbfCliAtp )

   local lSea        := .f.
   local nOrd        := ( dbfCliAtp )->( OrdSetFocus( "cCliArt" ) )

   DEFAULT cCodPrp   := Space( 20 )
   DEFAULT cValPrp   := Space( 40 )

   if ( dbfCliAtp )->( dbSeek( cCadSea + cCodPrp + cValPrp ) )

      while ( ( dbfCliAtp )->cCodCli + ( dbfCliAtp )->cCodArt + ( dbfCliAtp )->cCodPr1 + ( dbfCliAtp )->cCodPr2 + ( dbfCliAtp )->cValPr1 + ( dbfCliAtp )->cValPr2 == cCadSea + cCodPrp + cValPrp ) .and.;
            (!( dbfCliAtp )->( eof() ) )

         if ( dbfCliAtp )->dFecIni <= dFecDoc .and. ( dbfCliAtp )->dFecFin >= dFecDoc .and. ( dbfCliAtp )->nTipAtp <= 1

            lSea     := .t.
            exit

         else

            ( dbfCliAtp )->( dbSkip() )

         end if

      end while

   end if

   if !lSea .and. ( dbfCliAtp )->( dbSeek( cCadSea + Space( 20 ) ) )

      while ( ( dbfCliAtp )->cCodCli + ( dbfCliAtp )->cCodArt == cCadSea ) .and.;
            (!( dbfCliAtp )->( eof() ) )

         if ( dbfCliAtp )->dFecIni <= dFecDoc .and. ( dbfCliAtp )->dFecFin >= dFecDoc .and. ( dbfCliAtp )->nTipAtp <= 1

            lSea     := .t.
            exit

         else

            ( dbfCliAtp )->( dbSkip() )

         end if

      end while

   end if

   /*
   Ahora vamos a ver si hay con fechas vacias----------------------------------
   */

   if !lSea .and. ( dbfCliAtp )->( dbSeek( cCadSea + cCodPrp + cValPrp ) )

      while ( ( dbfCliAtp )->cCodCli + ( dbfCliAtp )->cCodArt + ( dbfCliAtp )->cCodPr1 + ( dbfCliAtp )->cCodPr2 + ( dbfCliAtp )->cValPr1 + ( dbfCliAtp )->cValPr2 == cCadSea + cCodPrp + cValPrp ) .and.;
            (!( dbfCliAtp )->( eof() ) )

         if Empty( ( dbfCliAtp )->dFecIni ) .and. Empty( ( dbfCliAtp )->dFecFin ) .and. ( dbfCliAtp )->nTipAtp <= 1

            lSea     := .t.
            exit

         else

            ( dbfCliAtp )->( dbSkip() )

         end if

      end while

   end if

   if !lSea .and. ( dbfCliAtp )->( dbSeek( cCadSea + Space( 20 ) ) )

      while ( ( dbfCliAtp )->cCodCli + ( dbfCliAtp )->cCodArt == cCadSea ) .and.;
            (!( dbfCliAtp )->( eof() ) )

         if Empty( ( dbfCliAtp )->dFecIni ) .and. Empty( ( dbfCliAtp )->dFecFin )

            lSea     := .t.
            exit

         else

            ( dbfCliAtp )->( dbSkip() )

         end if

      end while

   end if

   ( dbfCliAtp )->( OrdSetFocus( nOrd ) )

return ( lSea )

//---------------------------------------------------------------------------//

/*
Devuelve si el cliente tiene autorización para ventas de credito
*/

FUNCTION lCliChg( cCodCli, dbfClient )

   local lRet     := .f.

   if dbSeekInOrd( cCodCli, "Cod", dbfClient )
      lRet        := ( dbfClient )->lChgPre
   end if

RETURN lRet

//---------------------------------------------------------------------------//

FUNCTION AddRiesgo( nImpRie, cCodCli, dbfClient )

   local aCliStatus  := aGetStatus( dbfClient, .t. )

   if ( dbfClient )->( dbSeek( cCodCli ) ) .and. dbDialogLock( dbfClient )
      ( dbfClient )->nImpRie  += nImpRie
      ( dbfClient )->nTipCli  := 1
      ( dbfClient )->( dbUnlock() )
   end if

   SetStatus( dbfClient, aCliStatus )

return ( nil )

//---------------------------------------------------------------------------//

FUNCTION DelRiesgo( nImpRie, cCodCli, dbfClient )

   local aCliStatus  := aGetStatus( dbfClient, .t. )

   if ( dbfClient )->( dbSeek( cCodCli ) )
      if dbDialogLock( dbfClient )
         ( dbfClient )->nImpRie  -= nImpRie
         ( dbfClient )->nTipCli  := 1
         ( dbfClient )->( dbCommit() )
         ( dbfClient )->( dbUnlock() )
      end if
   end if

   SetStatus( dbfClient, aCliStatus )

return ( nil )

//---------------------------------------------------------------------------//

FUNCTION RetClient( cCodCli, dbfClient )

   local oBlock
   local oError
   local lClose   := .f.
   local cText    := Space( 30 )

   cCodCli        := RJust( cCodCli, "0", RetNumCodCliEmp() )

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfClient )
      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if ValType( dbfClient ) == "O"
      if dbfClient:Seek( cCodCli )
         cText    := dbfClient:Titulo
      end if
   else
      if ( dbfClient )->( dbSeek( cCodCli ) )
         cText    := ( dbfClient )->Titulo
      end if
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de clientes" )

   END SEQUENCE
   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfClient )
   end if

RETURN cText

//---------------------------------------------------------------------------//

FUNCTION cClient( oGet, dbfCli, oGet2 )

   local oBlock
   local oError
   local lClose   := .f.
   local lValid   := .f.
   local xValor   := oGet:varGet()

   if Empty( xValor )
      if IsObject( oGet2 )
         oGet2:cText( "" )
         oGet2:SetColor( 0, CLR_WHITE )
      end if
      return .t.
   elseif at( ".", xValor ) != 0
      xValor      := PntReplace( oGet, "0", RetNumCodCliEmp() )
   else
      xValor      := RJustObj( oGet, "0", RetNumCodCliEmp() )
   end if

   if ( Alltrim( xValor ) == Replicate( "Z", len( Alltrim( xValor ) ) ) )
      return .t.
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfCli )
      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfCli ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if dbSeekInOrd( xValor, "Cod", dbfCli )

      if IsObject( oGet )
         oGet:cText( ( dbfCli )->Cod )
      end if

      if IsObject( oGet2 )
         oGet2:cText( ( dbfCli )->Titulo )
         if ( dbfCli )->nColor != 0
            oGet2:SetColor( , ( dbfCli )->nColor )
         end if
      end if

      lValid      := .t.

   else

      msgStop( "Cliente no encontrado", "Código buscado : " + xValor )

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfCli )
   end if

RETURN lValid

//---------------------------------------------------------------------------//

STATIC FUNCTION ActTitle( nKey, nFlags, oGet, nMode, oDlg )

   oGet:Assign()
   oDlg:cTitle( LblTitle( nMode ) + " Cliente : " + Rtrim( oGet:varGet() ) ) // + Chr( nKey )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION lValidNombre( oGet )

   local cNombre  := oGet:VarGet()
   local nRec     := ( D():Get( "Client", nView ) )->( Recno() )
   local nOrd     := ( D():Get( "Client", nView ) )->( OrdSetFocus( "Titulo" ) )

   if !Empty( cNombre ) .and. ( D():Get( "Client", nView ) )->( dbSeek( cNombre ) )
      msgStop( 'El nombre introducido ya existe en la base de datos' )
   end if

   ( D():Get( "Client", nView ) )->( dbGoTo( nRec ) )
   ( D():Get( "Client", nView ) )->( OrdSetFocus( nOrd ) )

RETURN .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION lValidCif( oGet )

   local cCif     := oGet:VarGet()
   local nRec     := ( D():Get( "Client", nView ) )->( Recno() )
   local nOrd     := ( D():Get( "Client", nView ) )->( OrdSetFocus( "Nif" ) )

   if !Empty( cCif ) .and. ( D():Get( "Client", nView ) )->( dbSeek( cCif ) )
      msgStop( 'C.I.F / N.I.F. ya existe' )
   end if

   ( D():Get( "Client", nView ) )->( dbGoTo( nRec ) )
   ( D():Get( "Client", nView ) )->( OrdSetFocus( nOrd ) )

RETURN .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION lValidTlf( oGet )

   local cTlf     := oGet:VarGet()
   local nRec     := ( D():Get( "Client", nView ) )->( Recno() )
   local nOrd     := ( D():Get( "Client", nView ) )->( OrdSetFocus( "Telefono" ) )

   if !Empty( cTlf ) .and. ( D():Get( "Client", nView ) )->( dbSeek( cTlf ) )
      msgStop( 'El télefono introducido ya existe en la base de datos' )
   end if

   ( D():Get( "Client", nView ) )->( dbGoTo( nRec ) )
   ( D():Get( "Client", nView ) )->( OrdSetFocus( nOrd ) )

RETURN .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local oError
   local oBlock
   local lErrors     := .f.
   local cCodCli     := aTmp[ ( D():Get( "Client", nView ) )->( fieldpos( "Cod" ) ) ]
   local cCodSubCta  := aTmp[ ( D():Get( "Client", nView ) )->( fieldpos( "SubCta" ) ) ]

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   cTmpObr           := cGetNewFileName( cPatTmp() + "TmpObr" )
   cTmpBnc           := cGetNewFileName( cPatTmp() + "TmpBnc" )
   cTmpDoc           := cGetNewFileName( cPatTmp() + "TmpDoc" )
   cTmpAtp           := cGetNewFileName( cPatTmp() + "TmpAtp" )
   cTmpCta           := cGetNewFileName( cPatTmp() + "TmpCta" )
   cTmpInc           := cGetNewFileName( cPatTmp() + "TmpInc" )
   cTmpCon           := cGetNewFileName( cPatTmp() + "TmpCon" )
   cTmpFacturae      := cGetNewFileName( cPatTmp() + "TmpFacturae" )

   dbCreate( cTmpCta, aSqlStruct( aItmSubcuenta() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpCta, cCheckArea( "TmpCta", @dbfTmpSubCta ), .f. )

   ( dbfTmpSubCta )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpSubCta )->( OrdCreate( cTmpCta, "dFecha", "dFecha", {|| Field->dFecha } ) )

   if nMode != APPD_MODE
      LoadSubcuenta( cCodSubCta, cRutCnt(), dbfTmpSubCta )
   end if

   dbCreate( cTmpDoc, aSqlStruct( aCliDoc() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( "TmpDoc", @dbfTmpDoc ), .f. )

   ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpDoc )->( ordCreate( cTmpDoc, "Recno", "Recno()", {|| Recno() } ) )

   dbCreate( cTmpFacturae, aSqlStruct( aCliFacturae() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpFacturae, cCheckArea( "TmpFacturae", @dbfTmpFacturae ), .f. )

   ( dbfTmpFacturae )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpFacturae )->( ordCreate( cTmpFacturae, "Recno", "Recno()", {|| Recno() } ) )

   dbCreate( cTmpObr, aSqlStruct( aItmObr() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpObr, cCheckArea( "TmpObr", @dbfTmpObr ), .f. )

   ( dbfTmpObr )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpObr )->( ordCreate( cTmpObr, "Recno", "Recno()", {|| Recno() } ) )

   dbCreate( cTmpBnc, aSqlStruct( aCliBnc() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpBnc, cCheckArea( "TmpBnc", @dbfTmpBnc ), .f. )

   ( dbfTmpBnc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpBnc )->( OrdCreate( cTmpBnc, "CCODCLI", "CCODCLI + CENTBNC + CSUCBNC + CDIGBNC + CCTABNC", {|| Field->CCODCLI + Field->CENTBNC + Field->CSUCBNC + Field->CDIGBNC +  Field->CCTABNC } ) )

   dbCreate( cTmpAtp, aSqlStruct( aItmAtp() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpAtp, cCheckArea( "TmpAtp", @dbfTmpAtp ), .f. )

   ( dbfTmpAtp )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
   ( dbfTmpAtp )->( OrdCreate( cTmpAtp, "cCliArt", "CCODART + CCODPR1 + CCODPR2 + CVALPR1 + CVALPR2", {|| Field->CCODART + Field->CCODPR1 + Field->CCODPR2 + Field->CVALPR1 + Field->CVALPR2 } ) )

   ( dbfTmpAtp )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpAtp )->( OrdCreate( cTmpAtp, "cCodFam", "cCodFam", {|| Field->cCodFam } ) )

   ( dbfTmpAtp )->( OrdSetFocus( "cCliArt" ) )

   dbCreate( cTmpInc, aSqlStruct( aCliInc() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpInc, cCheckArea( "TmpInc", @dbfTmpInc ), .f. )

   ( dbfTmpInc )->( ordCondSet( "!Deleted()", {||!Deleted() }, , , , , , , , , .t. ) )
   ( dbfTmpInc )->( OrdCreate( cTmpInc, "cCodCli", "cCodTip + Dtos( dFecInc )", {|| Field->cCodTip + Dtos( Field->dFecInc ) } ) )

   ( dbfTmpInc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpInc )->( OrdCreate( cTmpInc, "cCodTip", "cCodTip", {|| Field->cCodTip } ) )

   ( dbfTmpInc )->( OrdSetFocus( "cCodCli" ) )

   /*
   Tabla de contactos----------------------------------------------------------
   */

   dbCreate( cTmpCon, aSqlStruct( aItmContacto() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpCon, cCheckArea( "TmpCon", @dbfTmpCon ), .f. )

   ( dbfTmpCon )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpCon )->( OrdCreate( cTmpCon, "cCodCli", "cCodCli", {|| Field->cCodCli } ) )

   ( dbfTmpCon )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpCon )->( OrdCreate( cTmpCon, "cNomCon", "cNomCon", {|| Field->cNomCon } ) )

   ( dbfTmpCon )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpCon )->( OrdCreate( cTmpCon, "cPosCon", "cPosCon", {|| Field->cPosCon } ) )

   ( dbfTmpCon )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpCon )->( OrdCreate( cTmpCon, "cTelCon", "cTelCon", {|| Field->cTelCon } ) )

   ( dbfTmpCon )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpCon )->( OrdCreate( cTmpCon, "cMovCon", "cMovCon", {|| Field->cMovCon } ) )

   ( dbfTmpCon )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmpCon )->( OrdCreate( cTmpCon, "cMaiCon", "cMaiCon", {|| Field->cMaiCon } ) )

   ( dbfTmpCon )->( ordSetFocus( "cCodCli" ) )

   /*
   Añadimos desde el fichero de atipicas---------------------------------------
   */

   if nMode != APPD_MODE

      ( D():Get( "CliAtp", nView ) )->( dbGoTop() )

      if ( D():Get( "CliAtp", nView ) )->( dbSeek( cCodCli ) )
         while ( ( D():Get( "CliAtp", nView ) )->cCodCli == cCodCli ) .and. ( D():Get( "CliAtp", nView ) )->( !eof() )
            dbPass( ( D():Get( "CliAtp", nView ) ), dbfTmpAtp, .t. )
            ( D():Get( "CliAtp", nView ) )->( dbSkip() )
         end while
      end if

      ( dbfTmpAtp )->( dbGoTop() )

      /*
      Añadimos desde el fichero de documentos----------------------------------
      */

      if ( D():Get( "ClientD", nView ) )->( dbSeek( cCodCli ) )
         while ( ( D():Get( "ClientD", nView ) )->cCodCli == cCodCli ) .and. ( D():Get( "ClientD", nView ) )->( !eof() )
            dbPass( ( D():Get( "ClientD", nView ) ), dbfTmpDoc, .t. )
            ( D():Get( "ClientD", nView ) )->( dbSkip() )
         end while
      end if

      ( dbfTmpDoc )->( dbGoTop() )


      /*
      Añadimos desde el fichero de documentos----------------------------------
      */

      if D():gotoIdClientesFacturae( cCodCli, nView ) 
         while ( D():ClientesFacturaeId( nView ) == cCodCli .and. ( D():ClientesFacturae( nView ) )->( !eof() ) )
            dbPass( ( D():ClientesFacturae( nView ) ), dbfTmpFacturae, .t. )
            ( D():ClientesFacturae( nView ) )->( dbSkip() )
         end while
      end if

      ( dbfTmpFacturae )->( dbGoTop() )

      /*
      A¤adimos desde el fichero de Obras
      */

      if ( dbfObrasT )->( dbSeek( cCodCli ) )
         while ( ( dbfObrasT )->cCodCli == cCodCli ) .AND. ( dbfObrasT )->( !eof() )
            dbPass( dbfObrasT, dbfTmpObr, .t. )
            ( dbfObrasT )->( dbSkip() )
         end while
      end if

      ( dbfTmpObr )->( dbGoTop() )

      /*
      A¤adimos desde el fichero de contactos
      */

      if ( dbfContactos )->( dbSeek( cCodCli ) )
         while ( ( dbfContactos )->cCodCli == cCodCli ) .and. ( dbfContactos )->( !eof() )
            dbPass( dbfContactos, dbfTmpCon, .t. )
            ( dbfContactos )->( dbSkip() )
         end while
      end if

      ( dbfTmpCon )->( dbGoTop() )

      /*
      A¤adimos desde el fichero de Bancos
      */

      if ( dbfBanco )->( dbSeek( cCodCli ) )
         while ( ( dbfBanco )->cCodCli == cCodCli ) .AND. ( dbfBanco )->( !eof() )
            dbPass( dbfBanco, dbfTmpBnc, .t. )
            ( dbfBanco )->( dbSkip() )
         end while
      end if

      ( dbfTmpBnc )->( dbGoTop() )

      /*
      A¤adimos desde el fichero de incidencias
      */

      if ( D():Get( "CliInc", nView ) )->( dbSeek( cCodCli ) )
         while ( ( D():Get( "CliInc", nView ) )->cCodCli == cCodCli ) .and. !( D():Eof( "CliInc", nView ) )
            dbPass( D():Get( "CliInc", nView ), dbfTmpInc, .t. )
            ( D():Get( "CliInc", nView ) )->( dbSkip() )
         end while
      end if

      ( dbfTmpInc )->( dbGoTop() )

   end if

   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales." + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors        := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

return ( lErrors )

//--------------------------------------------------------------------------//

Static Function KillTrans( oBmpDiv, oBrwBnc, oBrwObr, oBrwCta, oBrwAtp, oBrwInc, oBrwCon )

   if !Empty( oBmpDiv )
      oBmpDiv:end()
   end if

   if !Empty( dbfTmpSubCta ) .and. ( dbfTmpSubCta )->( Used() )
      ( dbfTmpSubCta )->( dbCloseArea() )
   end if
   if !Empty( dbfTmpDoc ) .and. ( dbfTmpDoc )->( Used() )
      ( dbfTmpDoc )->( dbCloseArea() )
   end if
   if !Empty( dbfTmpFacturae ) .and. ( dbfTmpFacturae )->( Used() )
      ( dbfTmpFacturae )->( dbCloseArea() )
   end if
   if !Empty( dbfTmpObr ) .and. ( dbfTmpObr )->( Used() )
      ( dbfTmpObr )->( dbCloseArea() )
   end if
   if !Empty( dbfTmpBnc ) .and. ( dbfTmpBnc )->( Used() )
      ( dbfTmpBnc )->( dbCloseArea() )
   end if
   if !Empty( dbfTmpCon ) .and. ( dbfTmpCon )->( Used() )
      ( dbfTmpCon )->( dbCloseArea() )
   end if
   if !Empty( dbfTmpAtp ) .and. ( dbfTmpAtp )->( Used() )
      ( dbfTmpAtp )->( dbCloseArea() )
   end if
   if !Empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() )
      ( dbfTmpInc )->( dbCloseArea() )
   end if

   dbfTmpSubCta   := nil
   dbfTmpDoc      := nil
   dbfTmpFacturae := nil
   dbfTmpObr      := nil
   dbfTmpBnc      := nil
   dbfTmpAtp      := nil
   dbfTmpInc      := nil
   dbfTmpCon      := nil

   dbfErase( cTmpCta )
   dbfErase( cTmpDoc )
   dbfErase( cTmpObr )
   dbfErase( cTmpBnc )
   dbfErase( cTmpAtp )
   dbfErase( cTmpInc )
   dbfErase( cTmpCon )
   dbfErase( cTmpFacturae )

   if oBrwBnc != nil
      oBrwBnc:CloseData()
   end if

   if oBrwObr != nil
      oBrwObr:CloseData()
   end if

   if oBrwCta != nil
      oBrwCta:CloseData()
   end if

   if oBrwAtp != nil
      oBrwAtp:CloseData()
   end if

   if oBrwInc != nil
      oBrwInc:CloseData()
   end if

   if oBrwCon != nil
      oBrwCon:CloseData()
   end if

   ( D():Get( "FacCliP", nView ) )->( OrdScope( 0, nil ) )
   ( D():Get( "FacCliP", nView ) )->( OrdScope( 1, nil ) )

Return .t.

//--------------------------------------------------------------------------//

STATIC FUNCTION aItmSubcuenta()

   local aBase := {}

   aAdd( aBase, { "nAsiento",  "N",  6, 0, "Asiento"    } )
   aAdd( aBase, { "dFecha",    "D",  8, 0, "Fecha"      } )
   aAdd( aBase, { "cConcepto", "C", 25, 0, "Concepto"   } )
   aAdd( aBase, { "nDebe",     "N", 16, 2, "Debe"       } )
   aAdd( aBase, { "nHaber",    "N", 16, 2, "Haber"      } )
   aAdd( aBase, { "cDeparta",  "C",  6, 0, "Departa"    } )
   aAdd( aBase, { "nFactura",  "N",  8, 0, "Factura"    } )
   aAdd( aBase, { "nBase",     "N", 16, 2, "Base"       } )
   aAdd( aBase, { "nIva",      "N",  5, 2, "I.V.A"      } )

Return ( aBase )

//--------------------------------------------------------------------------//

STATIC FUNCTION SavClient( aTmp, aGet, oDlg, oBrw, nMode )

   local cText       := ""
   local cFacAut
   local nVisLun     := ( D():Get( "Client", nView ) )->nVisLun
   local nVisMar     := ( D():Get( "Client", nView ) )->nVisMar
   local nVisMie     := ( D():Get( "Client", nView ) )->nVisMie
   local nVisJue     := ( D():Get( "Client", nView ) )->nVisJue
   local nVisVie     := ( D():Get( "Client", nView ) )->nVisVie
   local nVisSab     := ( D():Get( "Client", nView ) )->nVisSab
   local nVisDom     := ( D():Get( "Client", nView ) )->nVisDom

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      if Empty( aTmp[ _COD ] )
         MsgStop( "Código no puede estar vacio" )
         return nil
      end if

      if Existe( aTmp[ _COD ], D():Get( "Client", nView ), "Cod" )
         MsgStop( "Código ya existe " + Rtrim( aTmp[ _COD ] ) )
         return nil
      end if

   end if

   if aTmp[ _LPUBINT ]

      if Empty( aTmp[ _CMEIINT ] )
         MsgStop( "Email no pueden estar vacios" )
         aGet[ _CMEIINT ]:SetFocus()
         return nil
      end if

      if Empty( aTmp[ _CCLAVE ] ) .or. Len( AllTrim( aTmp[ _CCLAVE ] ) ) < 5
         MsgStop( "La contraseña debe tener al menos 5 caracteres" )
         aGet[ _CCLAVE ]:SetFocus()
         return nil
      end if

   end if

   if !Empty( aTmp[ _CCODREM ] ) .and. ( dbfTmpBnc )->( LastRec() ) == 0
      MsgStop( "Necesita una cuenta bancaria para su cuenta de remesa" )
      return nil
   end if

   /*
   Comprobamos que la tarifa esté entre 1 y 6---------------------------------
   */

   if aTmp[ _NTARIFA ] < 1
      aTmp[ _NTARIFA ]  := 1
   end if

   if aTmp[ _NTARIFA ] < 1 .or. aTmp[ _NTARIFA ] > 6

      MsgStop( "La tarifa a seleccionar debe de estar entre 1 y 6" )

      if !Empty( aGet[ _NTARIFA ] )
         aGet[ _NTARIFA ]:SetFocus()
      end if

      return nil

   end if

   /*
   Comprobamos que la tarifa para combinar esté entre 1 y 6---------------------------------
   */

   if aTmp[ _NTARCMB ] < 1
      aTmp[ _NTARCMB ]  := 1
   end if

   if aTmp[ _NTARCMB ] < 1 .or. aTmp[ _NTARCMB ] > 6

      MsgStop( "La tarifa para combinar debe de estar entre 1 y 6" )

      if !Empty( aGet[ _NTARCMB ] )
         aGet[ _NTARCMB ]:SetFocus()
      end if

      return nil

   end if

   /*
   Comprobamos que el descuento de artículo esté entre 1 y 6-------------------
   */

   if aTmp[ _NDTOART ] < 0 .or. aTmp[ _NDTOART ] > 6

      MsgStop( "El descuento de artículo a seleccionar debe de estar entre 0 y 6" )

      if !Empty( aGet[ _NDTOART ] )
         aGet[ _NDTOART ]:SetFocus()
      end if

      return nil

   end if

   if Empty( aTmp[ _TITULO ] )
      cText    := Space( 6 ) + "* Nombre" + CRLF
   end if

   // Campos necesarios para RISI----------------------------------------------

   if ( "RISI" $ cParamsMain() )   

      if Empty( aTmp[ _CCODGRP ] )
         cText := Space( 6 ) + "* Código de grupo" + CRLF
      end if

      if Empty( aTmp[ _CCODRUT ] )
         cText := Space( 6 ) + "* Código de ruta" + CRLF
      end if

   end if 

   // Mostramos el mensaje-----------------------------------------------------

   if !Empty( cText )
      msginfo( "Los siguientes campo(s) son obligatorios: " + CRLF + cText )
      return nil
   end if

   if Empty( aTmp[ _DOMICILIO ] )
      cText += Space( 6 ) + "* Domicilio" + CRLF
   end if

   if Empty( aTmp[ _POBLACION ] )
      cText += Space( 6 ) + "* Población" + CRLF
   end if

   if Empty( aTmp[ _CODPOSTAL ] )
      cText += Space( 6 ) + "* Codigo Postal" + CRLF
   end if

   if Empty( aTmp[ _CMEIINT ] )
      cText += Space( 6 ) + "* Email" + CRLF
   end if

   if Empty( aTmp[ _NIF ] )
      cText += Space( 6 ) + "* N.I.F" + CRLF
   end if

   if Empty( aTmp[ _TELEFONO ] )
      cText += Space( 6 ) + "* Teléfono" + CRLF
   end if

   if !Empty( cText )
      if !ApoloMsgNoYes( "Son recomendables introducir los siguientes campo(s): " + CRLF + cText + CRLF + " ¿Desea continuar sin introducirlos?", "Seleccione una opción" )
         return nil
      end if
   end if

   /*
   Deshabilitamos la ventana---------------------------------------------------
   */

   CursorWait()

   oDlg:Disable()

   oMsgText( "Archivando" )

   oMsgProgress()

   /*
   Guardamos el array con las facturas automáticas-----------------------------
   */

   aTmp[ _MFACAUT ]     := ""

   for each cFacAut in aFacAut
      aTmp[ _MFACAUT ]  += AllTrim( cFacAut ) + ","
   next

   /*
   Valores por defecto---------------------------------------------------------
   */

   aTmp[ _LSNDINT ]     := .t.

   if !Empty( cUsrTik() )
      aTmp[ _CCODUSR ]  := cUsrTik()
   else
      aTmp[ _CCODUSR ]  := cCurUsr()
   end if

   aTmp[ _DFECCHG ]     := GetSysDate()
   aTmp[ _CTIMCHG ]     := Time()

   if !Empty( aGet[ _NCOLOR ] )
      aTmp[ _NCOLOR  ]  := aRgbColor[ Min( Max( aGet[ _NCOLOR ]:nAt, 1 ), len( aRgbColor ) ) ]
   end if

   if !Empty( aGet[ _NMESVAC ] )
      aTmp[ _NMESVAC ]  := aGet[ _NMESVAC ]:nAt
   end if

   if !Empty( aGet[ _NTIPCLI ] )
      aTmp[ _NTIPCLI ]  := aGet[ _NTIPCLI ]:nAt
   end if

   if !Empty( aGet[ _NSBRATP ] )
      aTmp[ _NSBRATP ]  := aGet[ _NSBRATP ]:nAt
   end if

   if !Empty( aGet[ _NTIPRET ] )
      aTmp[ _NTIPRET ]  := aGet[ _NTIPRET ]:nAt
   end if

   if !Empty( aGet[ _NSEXO ] )
      aTmp[ _NSEXO ]  := aGet[ _NSEXO ]:nAt
   end if

   if !Empty( oRTF )
      aTmp[ _MOBSERV ]  := oRTF:SaveAsRTF()
   end if

   /*
   Borramos los posibles filtros de la tabla temporal de atipicas--------------
   */

   if !Empty( dbfTmpAtp )
      ( dbfTmpAtp )->( dbClearFilter() )
   end if

   /*
   Limpiamos la tabla de atipicas----------------------------------------------
   */

if !Empty( dbfTmpAtp )

   oMsgText( "Eliminando tarifas anteriores cliente" )
   oMsgProgress():SetRange( 0, ( dbfTmpAtp )->( LastRec() ) )

   while ( D():Get( "CliAtp", nView ) )->( dbSeek( aTmp[ _COD ] ) ) .and. !( D():Get( "CliAtp", nView ) )->( eof() )
      dbDel( D():Get( "CliAtp", nView ) )
   end while

   oMsgText( "Archivando tarifas cliente" )
   oMsgProgress():SetRange( 0, ( dbfTmpAtp )->( LastRec() ) )

   ( dbfTmpAtp )->( dbGoTop() )
   while ( dbfTmpAtp )->( !eof() )
      dbPass( dbfTmpAtp, ( D():Get( "CliAtp", nView ) ), .t., aTmp[ _COD ] )
      ( dbfTmpAtp )->( dbSkip() )
      oMsgProgress():DeltaPos( 1 )
   end while

end if

   /*
   Limpiamos la tabla de documentos--------------------------------------------
   */

if !Empty( dbfTmpDoc )

   oMsgText( "Eliminando documentos anteriores cliente" )
   oMsgProgress():SetRange( 0, ( dbfTmpDoc )->( LastRec() ) )

   while ( D():Get( "ClientD", nView ) )->( dbSeek( aTmp[ _COD ] ) )
      dbDel( D():Get( "ClientD", nView ) )
      oMsgProgress():DeltaPos( 1 )
   end while

   oMsgText( "Archivando documentos cliente" )
   oMsgProgress():SetRange( 0, ( dbfTmpDoc )->( LastRec() ) )

   ( dbfTmpDoc )->( dbGoTop() )
   while ( dbfTmpDoc )->( !eof() )
      dbPass( dbfTmpDoc, ( D():Get( "ClientD", nView ) ), .t., aTmp[ _COD ] )
      ( dbfTmpDoc )->( dbSkip() )
      oMsgProgress():DeltaPos( 1 )
   end while

end if

   /*
   Limpiamos la tabla de documentos--------------------------------------------
   */

   if !Empty( dbfTmpFacturae )

      oMsgText( "Eliminando documentos anteriores cliente" )
      oMsgProgress():SetRange( 0, ( dbfTmpFacturae )->( LastRec() ) )

      while ( D():gotoIdClientesFacturae( aTmp[ _COD ], nView ) )
         dbDel( D():ClientesFacturae( nView ) )
         oMsgProgress():DeltaPos( 1 )
      end while

      oMsgText( "Archivando documentos cliente" )
      oMsgProgress():SetRange( 0, ( dbfTmpFacturae )->( LastRec() ) )

      ( dbfTmpFacturae )->( dbGoTop() )
      while ( dbfTmpFacturae )->( !eof() )
         dbPass( dbfTmpFacturae, ( D():ClientesFacturae( nView ) ), .t., aTmp[ _COD ] )
         ( dbfTmpFacturae )->( dbSkip() )
         oMsgProgress():DeltaPos( 1 )
      end while

   end if

   /*
   Limpiamos la tabla de obras-------------------------------------------------
   */

if !Empty( dbfTmpObr )

   oMsgText( "Eliminando direcciones anteriores cliente" )
   oMsgProgress():SetRange( 0, ( dbfTmpObr )->( LastRec() ) )

   while ( dbfObrasT )->( dbSeek( aTmp[ _COD ] ) )
      dbDel( dbfObrasT )
      oMsgProgress():DeltaPos( 1 )
   end while

   oMsgText( "Archivando direcciones cliente" )
   oMsgProgress():SetRange( 0, ( dbfTmpObr )->( LastRec() ) )

   ( dbfTmpObr )->( dbGoTop() )
   while ( dbfTmpObr )->( !eof() )
      dbPass( dbfTmpObr, dbfObrasT, .t., aTmp[ _COD ] )
      ( dbfTmpObr )->( dbSkip() )
      oMsgProgress():DeltaPos( 1 )
   end while

end if

   /*
   Limpiamos la tabla de contactos---------------------------------------------
   */

if !Empty( dbfTmpCon )

   oMsgText( "Eliminando contactos anteriores cliente" )
   oMsgProgress():SetRange( 0, ( dbfTmpCon )->( LastRec() ) )

   while ( dbfContactos )->( dbSeek( aTmp[ _COD ] ) )
      dbDel( dbfContactos )
      oMsgProgress():DeltaPos( 1 )
   end while

   oMsgText( "Archivando contactos cliente" )
   oMsgProgress():SetRange( 0, ( dbfTmpCon )->( LastRec() ) )

   ( dbfTmpCon )->( dbGoTop() )
   while ( dbfTmpCon )->( !eof() )
      dbPass( dbfTmpCon, dbfContactos, .t., aTmp[ _COD ] )
      ( dbfTmpCon )->( dbSkip() )
      oMsgProgress():DeltaPos( 1 )
   end while

end if

   /*
   Limpiamos la tabla de bancos------------------------------------------------
   */

if !Empty( dbfTmpBnc )

   oMsgText( "Eliminanado bancos anteriores cliente" )
   oMsgProgress():SetRange( 0, ( dbfTmpBnc )->( LastRec() ) )

   while ( dbfBanco )->( dbSeek( aTmp[ _COD ] ) ) .and. !( dbfBanco )->( eof() )
      dbDel( dbfBanco )
      oMsgProgress():DeltaPos( 1 )
   end while

   oMsgText( "Archivando bancos cliente" )
   oMsgProgress():SetRange( 0, ( dbfTmpBnc )->( LastRec() ) )

   ( dbfTmpBnc )->( dbGoTop() )
   while !( dbfTmpBnc )->( eof() )
      dbPass( dbfTmpBnc, dbfBanco, .t., aTmp[ _COD ] )
      ( dbfTmpBnc )->( dbSkip() )
      oMsgProgress():DeltaPos( 1 )
   end while

end if

   /*
   Limpiamos la tabla de incidencias-------------------------------------------
   */

if !Empty( dbfTmpInc )

   oMsgText( "Eliminando incidencias cliente" )
   oMsgProgress():SetRange( 0, ( dbfTmpInc )->( LastRec() ) )

   while ( D():Get( "CliInc", nView ) )->( dbSeek( aTmp[ _COD ] ) )
      dbDel( D():Get( "CliInc", nView ) )
      oMsgProgress():DeltaPos( 1 )
   end while

   ( dbfTmpInc )->( OrdScope( 0, nil ) )
   ( dbfTmpInc )->( OrdScope( 1, nil ) )

   oMsgText( "Archivando incidencias cliente" )
   oMsgProgress():SetRange( 0, ( dbfTmpInc )->( LastRec() ) )

   ( dbfTmpInc )->( dbGoTop() )
   while !( dbfTmpInc )->( eof() )
      dbPass( dbfTmpInc, D():Get( "CliInc", nView ), .t., aTmp[ _COD ] )
      ( dbfTmpInc )->( dbSkip() )
      oMsgProgress():DeltaPos( 1 )
   end while

end if

   //-----------------------------------------------------------------------------

   WinGather( aTmp, aGet, D():Get( "Client", nView ), oBrw, nMode )

   if oWndBrw != nil
      oWndBrw:KillProcess()
   end if

   oMsgText()

   EndProgress()

   /*
   Habilitamos la ventana------------------------------------------------------
   */

   oDlg:Enable()
   oDlg:End( IDOK )

   CursorWE()

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function FiltroAtipica( oFiltroAtp, dbfTmpAtp, oBrwAtp )

   if Select( dbfTmpAtp ) != 0

      if oFiltroAtp:nAt <= 1
         ( dbfTmpAtp )->( dbClearFilter() )
      else
         ( dbfTmpAtp )->( dbSetFilter( {|| ( Empty( Field->dFecIni ) .and. Empty( Field->dFecFin ) ) .or. ( Field->dFecIni <= GetSysDate() .and. Field->dFecFin >= GetSysDate() ) }, "( Empty( dFecIni ) .and. Empty( dFecFin ) ) .or. ( dFecIni <= GetSysDate() .and. dFecFin >= GetSysDate() )" ) )

      end if

      ( dbfTmpAtp )->( dbGoTop() )

      oBrwAtp:Refresh()

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function IsCliAtp( aGet, aTmp, oGet, dbfCliAtp, nMode, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oCosto )

	local lReturn	:= .t.
   local cCodArt  := Padr( aGet[ _aCCODART ]:VarGet(), 18 )
   local nPreCom  := 0
   local nPreVta  := 0

   if Empty( cCodArt )
      oGet:cText( "" )
      Return ( .t. )
   end if

   if nMode == APPD_MODE

      if dbSeekInOrd( cCodArt, "Codigo", D():Get( "Articulo", nView ) )
      //if ( D():Get( "Articulo", nView ) )->( dbSeek( cCodArt ) )

         if !Empty( oGet )
            oGet:cText( ( D():Get( "Articulo", nView ) )->Nombre )
         end if

         aTmp[ _aCCODPR1 ] := ( D():Get( "Articulo", nView ) )->cCodPrp1
         aTmp[ _aCCODPR2 ] := ( D():Get( "Articulo", nView ) )->cCodPrp2

         if !Empty( aTmp[ _aCCODPR1 ] )
            if !Empty( oSayPr1 )
               oSayPr1:SetText( retProp( ( D():Get( "Articulo", nView ) )->cCodPrp1, dbfPro ) )
            end if
            if !Empty( oSayPr1 )
               oSayPr1:Show()
            end if
            if !Empty( aGet[ _aCVALPR1 ] )
               aGet[ _aCVALPR1 ]:Show()
            end if
            if !Empty( oSayVp1 )
               oSayVp1:Show()
            end if
         else
            if !Empty( oSayPr1 )
               oSayPr1:Hide()
            end if
            if !Empty( aGet[ _aCVALPR1 ] )
               aGet[ _aCVALPR1 ]:Hide()
            end if
            if !Empty( oSayVp1 )
               oSayVp1:Hide()
            end if
         end if

         if !Empty( aTmp[ _aCCODPR2 ] )
            if !Empty( oSayPr2 )
               oSayPr2:SetText( retProp( ( D():Get( "Articulo", nView ) )->cCodPrp2, dbfPro ) )
            end if
            if !Empty( oSayPr2 )
               oSayPr2:Show()
            end if
            if !Empty( aGet[ _aCVALPR2 ] )
               aGet[ _aCVALPR2 ]:show()
            end if
            if !Empty( oSayVp2 )
               oSayVp2:show()
            end if
         else
            if !Empty( oSayPr2 )
               oSayPr2:hide()
            end if
            if !Empty( aGet[ _aCVALPR2 ] )
               aGet[ _aCVALPR2 ]:hide()
            end if
            if !Empty( oSayVp2 )
               oSayVp2:hide()
            end if
         end if

         /*
         Precio de costo
         */

         nPreCom           := nComPro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], dbfArtDiv )

         if nPreCom == 0
            nPreCom        := nCosto( nil, D():Get( "Articulo", nView ), dbfArtKit )
         end if

         if !Empty( oCosto )
            oCosto:cText( nPreCom )
         end if

         /*
         Primer precio de venta
         */

         nPreVta           := nPrePro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], 1, .f., dbfArtDiv )

         if nPreVta == 0
            nPreVta        := ( D():Get( "Articulo", nView ) )->pVenta1
         end if

         if !Empty( aGet[_aNPRCART ] )
            aGet[_aNPRCART ]:cText( nPreVta )
         end if

         /*
         Segundo precio de venta
         */

         nPreVta           := nPrePro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], 2, .f., dbfArtDiv )

         if nPreVta == 0
            nPreVta        := ( D():Get( "Articulo", nView ) )->pVenta2
         end if

         if !Empty( aGet[_aNPRCART2] )
            aGet[_aNPRCART2]:cText( nPreVta )
         end if

         /*
         Tercer precio de venta
         */

         nPreVta           := nPrePro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], 3, .f., dbfArtDiv )

         if nPreVta == 0
            nPreVta        := ( D():Get( "Articulo", nView ) )->pVenta3
         end if

         if !Empty( aGet[_aNPRCART3] )
            aGet[_aNPRCART3]:cText( nPreVta )
         end if

         /*
         Cuarto precio de venta
         */

         nPreVta           := nPrePro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], 4, .f., dbfArtDiv )

         if nPreVta == 0
            nPreVta        := ( D():Get( "Articulo", nView ) )->pVenta4
         end if

         if !Empty( aGet[_aNPRCART4] )
            aGet[_aNPRCART4]:cText( nPreVta )
         end if

         /*
         Quinto precio de venta
         */

         nPreVta           := nPrePro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], 5, .f., dbfArtDiv )

         if nPreVta == 0
            nPreVta        := ( D():Get( "Articulo", nView ) )->pVenta5
         end if

         if !Empty( aGet[_aNPRCART5] )
            aGet[_aNPRCART5]:cText( nPreVta )
         end if

         /*
         Sexto precio de venta
         */

         nPreVta           := nPrePro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], 6, .f., dbfArtDiv )

         if nPreVta == 0
            nPreVta        := ( D():Get( "Articulo", nView ) )->pVenta6
         end if

         if !Empty( aGet[_aNPRCART6] )
            aGet[_aNPRCART6]:cText( nPreVta )
         end if

         /*
         Primer precio de venta impuestos incluido
         */

         nPreVta           := nPrePro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], 1, .t., dbfArtDiv )

         if nPreVta == 0
            nPreVta        := ( D():Get( "Articulo", nView ) )->pVtaIva1
         end if

         if !Empty( aGet[_aNPREIVA1] )
            aGet[_aNPREIVA1]:cText( nPreVta )
         end if

         /*
         Segundo precio de venta impuestos incluido
         */

         nPreVta           := nPrePro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], 2, .t., dbfArtDiv )

         if nPreVta == 0
            nPreVta        := ( D():Get( "Articulo", nView ) )->pVtaIva2
         end if

         if !Empty( aGet[_aNPREIVA2] )
            aGet[_aNPREIVA2]:cText( nPreVta )
         end if

         /*
         Tercer precio de venta impuestos incluido
         */

         nPreVta           := nPrePro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], 3, .t., dbfArtDiv )

         if nPreVta == 0
            nPreVta        := ( D():Get( "Articulo", nView ) )->pVtaIva3
         end if

         if !Empty( aGet[_aNPREIVA3] )
            aGet[_aNPREIVA3]:cText( nPreVta )
         end if

         /*
         Cuarto precio de venta impuestos incluido
         */

         nPreVta           := nPrePro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], 4, .t., dbfArtDiv )

         if nPreVta == 0
            nPreVta        := ( D():Get( "Articulo", nView ) )->pVtaIva4
         end if

         if !Empty( aGet[_aNPREIVA4] )
            aGet[_aNPREIVA4]:cText( nPreVta )
         end if

         /*
         Quinto precio de venta impuestos incluido
         */

         nPreVta           := nPrePro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], 5, .t., dbfArtDiv )

         if nPreVta == 0
            nPreVta        := ( D():Get( "Articulo", nView ) )->pVtaIva5
         end if

         if !Empty( aGet[_aNPREIVA5] )
            aGet[_aNPREIVA5]:cText( nPreVta )
         end if

         /*
         Sexto precio de venta impuestos incluido
         */

         nPreVta           := nPrePro( cCodArt, aTmp[ _aCCODPR1 ], aTmp[ _aCVALPR1 ], aTmp[ _aCCODPR2 ], aTmp[ _aCVALPR2 ], 6, .t., dbfArtDiv )

         if nPreVta == 0
            nPreVta        := ( D():Get( "Articulo", nView ) )->pVtaIva6
         end if

         if !Empty( aGet[_aNPREIVA6] )
            aGet[_aNPREIVA6]:cText( nPreVta )
         end if

      else
         MsgStop( "Código de artículo no encontrado" )
         return .f.
      end if

   else

      if ( D():Get( "Articulo", nView ) )->( dbSeek( cCodArt ) )

         if !Empty( aTmp[ _aCCODPR1 ] )
            aTmp[ _aCCODPR1 ] := ( D():Get( "Articulo", nView ) )->cCodPrp1
         end if
         if !Empty( aTmp[ _aCCODPR2 ] )
            aTmp[ _aCCODPR2 ] := ( D():Get( "Articulo", nView ) )->cCodPrp2
         end if

         if !empty( aTmp[ _aCCODPR1 ] )
            if !Empty( oSayPr1 )
               oSayPr1:SetText( retProp( ( D():Get( "Articulo", nView ) )->cCodPrp1, dbfPro ) )
            end if
            if !Empty( oSayPr1 )
               oSayPr1:show()
            end if
            if !Empty( aGet[ _aCVALPR1 ] )
               aGet[ _aCVALPR1 ]:show()
            end if
            if !Empty( oSayVp1 )
               oSayVp1:show()
            end if
         else
            if !Empty( oSayPr1 )
               oSayPr1:hide()
            end if
            if !Empty( aGet[ _aCVALPR1 ] )
               aGet[ _aCVALPR1 ]:hide()
            end if
            if !Empty( oSayVp1 )
               oSayVp1:hide()
            end if
         end if

         if !empty( aTmp[ _aCCODPR2 ] )
            if !Empty( oSayPr2 )
               oSayPr2:SetText( retProp( ( D():Get( "Articulo", nView ) )->cCodPrp2, dbfPro ) )
            end if
            if !Empty( oSayPr2 )
               oSayPr2:show()
            end if
            if !Empty( aGet[ _aCVALPR2 ] )
               aGet[ _aCVALPR2 ]:show()
            end if
            if !Empty( oSayVp2 )
               oSayVp2:show()
            end if
         else
            if !Empty( oSayPr2 )
               oSayPr2:hide()
            end if
            if !Empty( aGet[ _aCVALPR2 ] )
               aGet[ _aCVALPR2 ]:hide()
            end if
            if !Empty( oSayVp2 )
               oSayVp2:hide()
            end if
         end if

      end if

   end if

RETURN lReturn

//--------------------------------------------------------------------------//

Static Function lArrayRen( nTipPre, oBrwRen, aTmp, aTmpCli, aGetCli, cCosto )

   local nNetoBase
   local nResultado
   local nCosto
   local nDtoAtpico
   local nSbrAtipico := aGetCli[ _NSBRATP ]:nAt

   aRentabilidad     := {}

   /*
   Seleccionamos el precio que nos elijan--------------------------------------
   */

   do case
      case nTipPre == 1
         nNetoBase   := aTmp[ _aNPRCART ]
      case nTipPre == 2
         nNetoBase   := aTmp[ _aNPRCART2 ]
      case nTipPre == 3
         nNetoBase   := aTmp[ _aNPRCART3 ]
      case nTipPre == 4
         nNetoBase   := aTmp[ _aNPRCART4 ]
      case nTipPre == 5
         nNetoBase   := aTmp[ _aNPRCART5 ]
      case nTipPre == 6
         nNetoBase   := aTmp[ _aNPRCART6 ]
   end case

   /*
   Seleccionamos el precio de costo--------------------------------------------
   */

   if aTmp[ _aLPRCCOM ]
      nCosto         := aTmp[ _aNPRCCOM ]
   else
      nCosto         := cCosto
   end if

   /*
   Costo-----------------------------------------------------------------------
   */

   aAdd( aRentabilidad, { "Costo", "", nCosto, .f., .f. } )

   /*Neto Base*/

   aAdd( aRentabilidad, { "Neto base", "", nNetoBase, .f., .f. } )

   /*Dto X*Y*/

   if aTmp[ _aNUNCOFE ] != 0 .and. aTmp[ _aNUNVOFE ] != 0

      if ( aTmp[ _aNUNCOFE ] != 1 .or. aTmp[ _aNUNVOFE ] != 1 )

         nResultado := nNetoBase - ( Div( ( nNetoBase * aTmp[ _aNUNCOFE ] ), aTmp[ _aNUNVOFE ] ) )

         aAdd( aRentabilidad, { Space(3) + "Dto. X*Y", AllTrim( Str( aTmp[ _aNUNVOFE ] ) ) + " * " + AllTrim( Str( aTmp[ _aNUNCOFE ] ) ), - ( nResultado ), .f., .f. } )

         nNetoBase -= nResultado

      end if

   end if

   /*Dto Art*/

   if aTmp[ _aNDTOART ] != 0

      nResultado := ( ( nNetoBase * aTmp[ _aNDTOART ] ) / 100 )

      aAdd( aRentabilidad, { Space(3) + "Dto. art.", AllTrim( Str( aTmp[ _aNDTOART ] ) ) + " %", - ( nResultado ), .f., .f. } )

      nNetoBase -= nResultado

   end if

   /*Dto Lin*/

   if aTmp[ _aNDTODIV ] != 0

      aAdd( aRentabilidad, { Space(3) + "Dto. lineal", Trans( aTmp[ _aNDTODIV ], cPouDiv( cDivEmp() ) ), - ( aTmp[ _aNDTODIV ] ), .f., .f. } )

      nNetoBase -= aTmp[ _aNDTODIV ]

   end if

   /*Dto Promo*/

   if aTmp[ _aNDPRART ] != 0

      nResultado := ( ( nNetoBase * aTmp[ _aNDPRART ] ) / 100 )

      aAdd( aRentabilidad, { Space(3) + "Dto. promo.", AllTrim( Str( aTmp[ _aNDPRART ] ) ) + " %", - ( nResultado ), .f., .f. } )

      nNetoBase -= nResultado

   end if

   /*Comisión agente*/

   if aTmp[ _aNCOMAGE ] != 0

      nResultado := ( ( nNetoBase * aTmp[ _aNCOMAGE ] ) / 100 )

      if aTmp[ _aLCOMAGE ]
         aAdd( aRentabilidad, { Space(3) + "Com. agente", AllTrim( Str( aTmp[ _aNCOMAGE ] ) ) + " %", - ( nResultado ), .f., .f. } )
         nNetoBase -= nResultado
      else
         aAdd( aRentabilidad, { Space(3) + "Com. agente", AllTrim( Str( aTmp[ _aNCOMAGE ] ) ) + " %", nResultado, .f., .f. } )
      end if

   end if

   /*Atipico con la opcion 1*/

   if nSbrAtipico == 1 .and. aTmpCli[ _NDTOATP ] != 0

      nDtoAtpico := ( ( nNetoBase * aTmpCli[ _NDTOATP ] ) / 100 )

   end if

   /*Dto General*/

   if aTmpCli[ _NDTOESP ] != 0

      nResultado := ( ( nNetoBase * aTmpCli[ _NDTOESP ] ) / 100 )

      aAdd( aRentabilidad, { Space(3) + AllTrim( aTmpCli[ _CDTOESP ] ), AllTrim( Str( aTmpCli[ _NDTOESP ] ) ) + " %", - ( nResultado ), .f., .f. } )

      nNetoBase -= nResultado

   end if

   /*Atipico con la opcion 2*/

   if nSbrAtipico == 2 .and. aTmpCli[ _NDTOATP ] != 0

      nDtoAtpico := ( ( nNetoBase * aTmpCli[ _NDTOATP ] ) / 100 )

   end if

   /*Pronto pago*/

   if aTmpCli[ _NDPP ] != 0

      nResultado := ( ( nNetoBase * aTmpCli[ _NDPP ] ) / 100 )

      aAdd( aRentabilidad, { Space(3) + AllTRim( aTmpCli[ _CDPP ] ), AllTrim( Str( aTmpCli[ _NDPP ] ) ) + " %", - ( nResultado ), .f., .f. } )

      nNetoBase -= nResultado

   end if

   /*Atipico con la opcion 3*/

   if nSbrAtipico == 3 .and. aTmpCli[ _NDTOATP ] != 0

      nDtoAtpico := ( ( nNetoBase * aTmpCli[ _NDTOATP ] ) / 100 )

   end if

   /*Definido 1*/

   if !Empty( aTmpCli[ _CDTOUNO ] ) .or. aTmpCli[ _NDTOCNT ] != 0

      nResultado := ( ( nNetoBase * aTmpCli[ _NDTOCNT ] ) / 100 )

      aAdd( aRentabilidad, { Space(3) + aTmpCli[ _CDTOUNO ], AllTrim( Str( aTmpCli[ _NDTOCNT ] ) ) + " %", - ( nResultado ), .f., .f. } )

      nNetoBase -= nResultado

   end if

   /*Atipico con la opcion 4*/

   if nSbrAtipico == 4 .and. aTmpCli[ _NDTOATP ] != 0

      nDtoAtpico := ( ( nNetoBase * aTmpCli[ _NDTOATP ] ) / 100 )

   end if

   /*Definido 2*/

   if !Empty( aTmpCli[ _CDTODOS ] ) .or. aTmpCli[ _NDTORAP ] != 0

      nResultado := ( ( nNetoBase * aTmpCli[ _NDTORAP ] ) / 100 )

      aAdd( aRentabilidad, { Space(3) + aTmpCli[ _CDTODOS ], AllTrim( Str( aTmpCli[ _NDTORAP ] ) ) + " %", - ( nResultado ), .f., .f. } )

      nNetoBase -= nResultado

   end if

   /*Atipico con la opcion 5*/

   if nSbrAtipico == 5 .and. aTmpCli[ _NDTOATP ] != 0

      nDtoAtpico := ( ( nNetoBase * aTmpCli[ _NDTOATP ] ) / 100 )

   end if

   if aTmpCli[ _NDTOATP ] != 0

      /*Neto antes de atipico*/

      aAdd( aRentabilidad, { "Neto sin " + aTmpCli[ _CDTOATP ] , "", nNetoBase, .f., .f. } )

      /*Resultado descuento atipico*/

      aAdd( aRentabilidad, { Space(3) + aTmpCli[ _CDTOATP ], AllTrim( Str( aTmpCli[ _NDTOATP ] ) ) + " %", - ( nDtoAtpico ), .f., .f. } )

      nNetoBase   -= nDtoAtpico

   end if

   /*Neto total*/

   aAdd( aRentabilidad, { "Tarifa neta", "", nNetoBase, .f., .f. } )

   /*Margen und*/

   nResultado := nNetoBase - nCosto

   aAdd( aRentabilidad, { "Margen unidades", "", nResultado, .f., .f. } )

   /*Margen cajas*/

   nResultado := ( nNetoBase - nCosto ) * ( D():Get( "Articulo", nView ) )->nUniCaja

   aAdd( aRentabilidad, { "Margen cajas", Trans( ( D():Get( "Articulo", nView ) )->nUniCaja, MasUnd() ), nResultado, .f., .f. } )

   /*Rentabilidad costo*/

   nResultado :=  ( Div( nNetoBase, nCosto ) - 1 ) * 100

   aAdd( aRentabilidad, { "Rent. costo", "", nResultado, .t., .f. } )

   /*Rentabilidad mínima del artículo*/

   aAdd( aRentabilidad, { "Rent. mínima", "", ( D():Get( "Articulo", nView ) )->nRenMin, .t., if( ( D():Get( "Articulo", nView ) )->nRenMin > nResultado, .t., .f. ) } )

   /*Ratio capacidad de maniobra*/

   aAdd( aRentabilidad, { "Ratio maniobra", "", nResultado - ( D():Get( "Articulo", nView ) )->nRenMin, .t., .f. } )

   /*Porcentaje margen de venta*/

   nResultado :=  Div( ( nNetoBase - nCosto ), nNetoBase ) * 100

   aAdd( aRentabilidad, { "% Margen venta", "", nResultado, .t., .f. } )

   /*
   Refrescamos el brwose-------------------------------------------------------
   */

   oBrwRen:nAt       := 1
   oBrwRen:SetArray( aRentabilidad )
   oBrwRen:Refresh()

Return .t.

//---------------------------------------------------------------------------//

Static Function ChangeNaturaleza( aGet, aTmp, oSayPr1, oSayPr2, oSayVp1, oSayVp2, oGetArticulo, oGetFamilia, oCosto, nMode, oSayLabels, lInit )

   DEFAULT lInit  := .f.

   if nMode == APPD_MODE

      if !Empty( oGetArticulo )
         oGetArticulo:cText( "" )
      end if
      if !Empty( oGetFamilia )
         oGetFamilia:cText( "" )
      end if

      if !Empty( oCosto )
         oCosto:cText( 0 )
      end if

      if !Empty( aGet[ _aCCODART  ] )
         aGet[ _aCCODART  ]:cText( Space( 18 ) )
      end if
      if !Empty( aGet[ _aCCODFAM  ] )
         aGet[ _aCCODFAM  ]:cText( Space( 5 ) )
      end if
      if !Empty( aGet[ _aNPRCCOM  ] )
         aGet[ _aNPRCCOM  ]:cText( 0 )
      end if
      if !Empty( aGet[ _aNPRCART  ] )
            aGet[ _aNPRCART  ]:cText( 0 )
      end if
      if !Empty( aGet[ _aNPRCART2 ] )
            aGet[ _aNPRCART2 ]:cText( 0 )
      end if
      if !Empty( aGet[ _aNPRCART3 ] )
            aGet[ _aNPRCART3 ]:cText( 0 )
      end if
      if !Empty( aGet[ _aNPRCART4 ] )
            aGet[ _aNPRCART4 ]:cText( 0 )
      end if
      if !Empty( aGet[ _aNPRCART5 ] )
            aGet[ _aNPRCART5 ]:cText( 0 )
      end if
      if !Empty( aGet[ _aNPRCART6 ] )
            aGet[ _aNPRCART6 ]:cText( 0 )
      end if
      if !Empty( aGet[ _aNPREIVA1 ] )
            aGet[ _aNPREIVA1 ]:cText( 0 )
      end if
      if !Empty( aGet[ _aNPREIVA2 ] )
            aGet[ _aNPREIVA2 ]:cText( 0 )
      end if
      if !Empty( aGet[ _aNPREIVA3 ] )
            aGet[ _aNPREIVA3 ]:cText( 0 )
      end if
      if !Empty( aGet[ _aNPREIVA4 ] )
            aGet[ _aNPREIVA4 ]:cText( 0 )
      end if
      if !Empty( aGet[ _aNPREIVA5 ] )
            aGet[ _aNPREIVA5 ]:cText( 0 )
      end if
      if !Empty( aGet[ _aNPREIVA6 ] )
            aGet[ _aNPREIVA6 ]:cText( 0 )
      end if

   end if

   if aGet[ _aNTIPATP ]:nAt == 1

      if !Empty( aGet[ _aCCODART ] )
         aGet[ _aCCODART ]:Show()
      end if
      if !Empty( oGetArticulo )
         oGetArticulo:Show()
      end if

      if !Empty( aGet[ _aCCODFAM ] )
         aGet[ _aCCODFAM ]:Hide()
      end if
      if !Empty( oGetFamilia )
         oGetFamilia:Hide()
      end if

      if !lInit

         if !Empty( oSayPr1 )
            oSayPr1:Hide()
         end if

         if !Empty( oSayPr2 )
            oSayPr2:Hide()
         end if

         if !Empty( oSayVp1 )
            oSayVp1:SetText( Space(10) )
         end if

         if !Empty( oSayVp2 )
            oSayVp2:SetText( Space(10) )
         end if

         if !Empty( oSayVp1 )
            oSayVp1:Hide()
         end if

         if !Empty( oSayVp2 )
            oSayVp2:Hide()
         end if

         if !Empty( aGet[ _aCVALPR1 ] )
            aGet[ _aCVALPR1 ]:cText( Space(10) )
         end if

         if !Empty( aGet[ _aCVALPR2 ] )
            aGet[ _aCVALPR2 ]:cText( Space(10) )
         end if

         if !Empty( aGet[ _aCVALPR1 ] )
            aGet[ _aCVALPR1 ]:Hide()
         end if

         if !Empty( aGet[ _aCVALPR2 ] )
            aGet[ _aCVALPR2 ]:Hide()
         end if

      end if

      if !Empty( oCosto )
         oCosto:Show()
      end if

      if !Empty( aGet[ _aLPRCCOM  ] )
         aGet[ _aLPRCCOM  ]:Show()
      end if

      if !Empty( aGet[ _aNPRCCOM  ] )
         aGet[ _aNPRCCOM  ]:Show()
      end if

      if !Empty( aGet[ _aNPRCART  ] )
          aGet[ _aNPRCART  ]:Show()
      end if

      if !Empty( aGet[ _aNPRCART2 ] )
         aGet[ _aNPRCART2 ]:Show()
      end if

      if !Empty( aGet[ _aNPRCART3 ] )
         aGet[ _aNPRCART3 ]:Show()
      end if

      if !Empty( aGet[ _aNPRCART4 ] )
         aGet[ _aNPRCART4 ]:Show()
      end if

      if !Empty( aGet[ _aNPRCART5 ] )
         aGet[ _aNPRCART5 ]:Show()
      end if

      if !Empty( aGet[ _aNPRCART6 ] )
         aGet[ _aNPRCART6 ]:Show()
      end if

      if !Empty( aGet[ _aNPREIVA1 ] )
         aGet[ _aNPREIVA1 ]:Show()
      end if

      if !Empty( aGet[ _aNPREIVA2 ] )
         aGet[ _aNPREIVA2 ]:Show()
      end if

      if !Empty( aGet[ _aNPREIVA3 ] )
         aGet[ _aNPREIVA3 ]:Show()
      end if

      if !Empty( aGet[ _aNPREIVA4 ] )
         aGet[ _aNPREIVA4 ]:Show()
      end if

      if !Empty( aGet[ _aNPREIVA5 ] )
         aGet[ _aNPREIVA5 ]:Show()
      end if

      if !Empty( aGet[ _aNPREIVA6 ] )
         aGet[ _aNPREIVA6 ]:Show()
      end if

      if !Empty( aGet[ _aNDTO1    ] )
         aGet[ _aNDTO1    ]:Show()
      end if

      if !Empty( aGet[ _aNDTO2    ] )
         aGet[ _aNDTO2    ]:Show()
      end if

      if !Empty( aGet[ _aNDTO3    ] )
         aGet[ _aNDTO3    ]:Show()
      end if

      if !Empty( aGet[ _aNDTO4    ] )
         aGet[ _aNDTO4    ]:Show()
      end if

      if !Empty( aGet[ _aNDTO5    ] )
         aGet[ _aNDTO5    ]:Show()
      end if

      if !Empty( aGet[ _aNDTO6    ] )
         aGet[ _aNDTO6    ]:Show()
      end if

      if !Empty( oSayLabels )
         aEval( oSayLabels, {|o| o:Show() } )
      end if

   else

      if !Empty( aGet[ _aCCODART ] )
         aGet[ _aCCODART ]:Hide()
      end if
      if !Empty( oGetArticulo )
         oGetArticulo:Hide()
      end if

      if !Empty( aGet[ _aCCODFAM ] )
         aGet[ _aCCODFAM ]:Show()
      end if
      if !Empty( oGetFamilia )
         oGetFamilia:Show()
      end if

      if !Empty( oSayPr1 )
         oSayPr1:Hide()
      end if
      if !Empty( oSayPr2 )
         oSayPr2:Hide()
      end if

      if !Empty( oSayVp1 )
         oSayVp1:SetText( Space(10) )
      end if
      if !Empty( oSayVp2 )
         oSayVp2:SetText( Space(10) )
      end if

      if !Empty( oSayVp1 )
         oSayVp1:Hide()
      end if
      if !Empty( oSayVp2 )
         oSayVp2:Hide()
      end if

      if !Empty( aGet[ _aCVALPR1 ] )
         aGet[ _aCVALPR1 ]:cText( Space(10) )
      end if
      if !Empty( aGet[ _aCVALPR2 ] )
         aGet[ _aCVALPR2 ]:cText( Space(10) )
      end if

      if !Empty( aGet[ _aCVALPR1 ] )
         aGet[ _aCVALPR1 ]:Hide()
      end if
      if !Empty( aGet[ _aCVALPR2 ] )
         aGet[ _aCVALPR2 ]:Hide()
      end if

      if !Empty( oCosto )
         oCosto:Hide()
      end if

      if !Empty( aGet[ _aLPRCCOM  ] )
         aGet[ _aLPRCCOM  ]:Hide()
      end if

      if !Empty( aGet[ _aNPRCCOM  ] )
         aGet[ _aNPRCCOM  ]:Hide()
      end if
      if !Empty( aGet[ _aNPRCART  ] )
         aGet[ _aNPRCART  ]:Hide()
      end if
      if !Empty( aGet[ _aNPRCART2 ] )
         aGet[ _aNPRCART2 ]:Hide()
      end if
      if !Empty( aGet[ _aNPRCART3 ] )
         aGet[ _aNPRCART3 ]:Hide()
      end if
      if !Empty( aGet[ _aNPRCART4 ] )
         aGet[ _aNPRCART4 ]:Hide()
      end if
      if !Empty( aGet[ _aNPRCART5 ] )
         aGet[ _aNPRCART5 ]:Hide()
      end if
      if !Empty( aGet[ _aNPRCART6 ] )
         aGet[ _aNPRCART6 ]:Hide()
      end if

      if !Empty( aGet[ _aNPREIVA1 ] )
         aGet[ _aNPREIVA1 ]:Hide()
      end if
      if !Empty( aGet[ _aNPREIVA2 ] )
         aGet[ _aNPREIVA2 ]:Hide()
      end if
      if !Empty( aGet[ _aNPREIVA3 ] )
         aGet[ _aNPREIVA3 ]:Hide()
      end if
      if !Empty( aGet[ _aNPREIVA4 ] )
         aGet[ _aNPREIVA4 ]:Hide()
      end if
      if !Empty( aGet[ _aNPREIVA5 ] )
         aGet[ _aNPREIVA5 ]:Hide()
      end if
      if !Empty( aGet[ _aNPREIVA6 ] )
         aGet[ _aNPREIVA6 ]:Hide()
      end if

      if !Empty( aGet[ _aNDTO1    ] )
         aGet[ _aNDTO1    ]:Hide()
      end if
      if !Empty( aGet[ _aNDTO2    ] )
         aGet[ _aNDTO2    ]:Hide()
      end if
      if !Empty( aGet[ _aNDTO3    ] )
         aGet[ _aNDTO3    ]:Hide()
      end if
      if !Empty( aGet[ _aNDTO4    ] )
         aGet[ _aNDTO4    ]:Hide()
      end if
      if !Empty( aGet[ _aNDTO5    ] )
         aGet[ _aNDTO5    ]:Hide()
      end if
      if !Empty( aGet[ _aNDTO6    ] )
         aGet[ _aNDTO6    ]:Hide()
      end if

      if !Empty( oSayLabels )
         aEval( oSayLabels, {|o| o:Hide() } )
      end if

   end if

Return nil

//---------------------------------------------------------------------------//

static function SaveEdtAtp( aGet, aTmp, dbfTmpAtp, oBrw, oDlg, nMode )

   if aTmp[ _aDFECINI ] > aTmp[ _aDFECFIN ]
      MsgStop( "Fechas no validas" )
      return .f.
   end if

   if nMode == APPD_MODE

      if Empty( aTmp[ _aCCODART ] ) .and. aGet[ _aNTIPATP ]:nAt <= 1
         MsgStop( "Código de artículo no puede estar vacío" )
         aGet[ _aCCODART ]:SetFocus()
         return .f.
      end if

      if dbSeekAtp( aTmp, dbfTmpAtp, .f. ) .and. aGet[ _aNTIPATP ]:nAt <= 1
         msgStop( "Código de artículo ya en tarifa para el rango de fechas" )
         return nil
      end if

      if Empty( aTmp[ _aCCODFAM ] ) .and. aGet[ _aNTIPATP ]:nAt == 2
         MsgStop( "Código de família no puede estar vacío" )
         aGet[ _aCCODFAM ]:SetFocus()
         return .f.
      end if

      if dbSeekAtp( aTmp, dbfTmpAtp, .t. ) .and. aGet[ _aNTIPATP ]:nAt == 2
         msgStop( "Código de familia ya en tarifa para el rango de fechas" )
         return .f.
      end if

   end if

   /*
   Guardamos los datos en la tabla temporal-----------------------------------
   */

   CursorWait()

   oDlg:Disable()

   aTmp[ _aNTIPATP ]    := aGet[ _aNTIPATP ]:nAt

   WinGather( aTmp, aGet, dbfTmpAtp, oBrw, nMode )

   oDlg:Enable()

   CursorWE()

RETURN ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

Static Function dbSeekAtp( aTmp, dbfTmpAtp, lFam )

   local lSeek := .f.
   local nOrdAnt

   if lFam
      nOrdAnt  := ( dbfTmpAtp )->( OrdSetFocus( "cCodFam" ) )
      if ( dbfTmpAtp )->( dbSeek( aTmp[ _aCCODFAM ] ) )
         if ( dbfTmpAtp )->dFecFin >= aTmp[ _aDFECINI ] .and. !Empty( aTmp[ _aDFECINI ] )
            lSeek := .t.
         end if
      end if
      ( dbfTmpAtp )->( OrdSetFocus( nOrdAnt ) )
   else
      nOrdAnt  := ( dbfTmpAtp )->( OrdSetFocus( "cCliArt" ) )
      if ( dbfTmpAtp )->( dbSeek( aTmp[ _aCCODART ] + aTmp[ _aCCODPR1 ] + aTmp[ _aCCODPR2 ] + aTmp[ _aCVALPR1 ] + aTmp[ _aCVALPR2 ] ) )
         if ( dbfTmpAtp )->dFecFin >= aTmp[ _aDFECINI ] .and. !Empty( aTmp[ _aDFECINI ] )
            lSeek := .t.
         end if
      end if
      ( dbfTmpAtp )->( OrdSetFocus( nOrdAnt ) )
   end if

Return ( lSeek )

//--------------------------------------------------------------------------//

Static Function CalIva( nPrecio, lIvaInc, cTipIva, cCodImp, oGetIva )

   local nIvaPct  := nIva( D():Get( "TIva", nView ), cTipIva )

   /*
   Despues si tiene impuesto especial qitarlo----------------------------------
   */

   if !Empty( cCodImp ) .and. !Empty( oNewImp )
      nPrecio     += oNewImp:nValImp( cCodImp, .t., nIvaPct )
   end if

   /*
   Calculo del impuestos-------------------------------------------------------
   */

   nPrecio        += ( nPrecio * nIvaPct / 100 )

   if oGetIva != NIL
      oGetIva:cText( nPrecio )
   end if

Return .t.

//----------------------------------------------------------------------------//

Static Function CalBas( nPrecio, lIvaInc, cTipIva, cCodImp, oGetBas )

   local nNewPre
   local nIvaPct  := nIva( D():Get( "TIva", nView ), cTipIva )

   /*
   Primero es quitar el impuestos
   */

   nNewPre        := Div( nPrecio, ( 1 + nIvaPct / 100 ) )

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

Return .t.

//--------------------------------------------------------------------------//

Function nCalIva( nPrecio, lIvaInc, cTipIva, cCodImp )

   local nIvaPct  := nIva( D():Get( "TIva", nView ), cTipIva )

   /*
   Despues si tiene impuesto especial qitarlo
   */

   if !Empty( cCodImp ) .and. !Empty( oNewImp )
      nPrecio     += oNewImp:nValImp( cCodImp, .t., nIvaPct )
   end if

   /*
   Calculo del impuestos
   */

   nPrecio        += ( nPrecio * nIvaPct / 100 )

Return nPrecio

//----------------------------------------------------------------------------//

Function nCalBas( nPrecio, lIvaInc, cTipIva, cCodImp )

   local nNewPre
   local nIvaPct  := nIva( D():Get( "TIva", nView ), cTipIva )

   /*
   Primero es quitar el impuestos
   */

   nNewPre        := Div( nPrecio, ( 1 + nIvaPct / 100 ) )

   /*
   Despues si tiene impuesto especial qitarlo
   */

   if !Empty( cCodImp ) .and. !Empty( oNewImp )
      nNewPre     -= oNewImp:nValImp( cCodImp, lIvaInc , nIvaPct )
   end if

Return nNewPre

//--------------------------------------------------------------------------//

Static Function DataReport( oFr, lTemporal )

   /*
   Zona de datos---------------------------------------------------------------
   */

   oFr:ClearDataSets()

   if lTemporal
      oFr:SetWorkArea(  "Clientes",          ( tmpClient )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   else
      oFr:SetWorkArea(  "Clientes",          ( D():Get( "Client", nView ) )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   end if
   oFr:SetFieldAliases( "Clientes",          cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Documetos",         ( D():Get( "ClientD", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documetos",         cItemsToReport( aCliDoc() ) )

   oFr:SetWorkArea(     "Tarifas clientes",  ( D():Get( "CliAtp", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Tarifas clientes",  cItemsToReport( aItmAtp() ) )

   oFr:SetWorkArea(     "Direcciones",       ( dbfObrasT )->( Select() ) )
   oFr:SetFieldAliases( "Direcciones",       cItemsToReport( aItmObr() ) )

   oFr:SetWorkArea(     "Contactos",         ( dbfContactos )->( Select() ) )
   oFr:SetFieldAliases( "Contactos",         cItemsToReport( aItmContacto() ) )

   oFr:SetWorkArea(     "Bancos",            ( dbfBanco )->( Select() ) )
   oFr:SetFieldAliases( "Bancos",            cItemsToReport( aCliBnc() ) )

   oFr:SetWorkArea(     "Incidencias",       ( D():Get( "CliInc", nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias",       cItemsToReport( aCliInc() ) )

   if lTemporal
      oFr:SetMasterDetail( "Clientes",       "Documentos",        {|| ( tmpClient )->Cod } )
      oFr:SetMasterDetail( "Clientes",       "Tarifas clientes",  {|| ( tmpClient )->Cod } )
      oFr:SetMasterDetail( "Clientes",       "Direcciones",       {|| ( tmpClient )->Cod } )
      oFr:SetMasterDetail( "Clientes",       "Contactos",         {|| ( tmpClient )->Cod } )
      oFr:SetMasterDetail( "Clientes",       "Bancos",            {|| ( tmpClient )->Cod } )
      oFr:SetMasterDetail( "Clientes",       "Incidencias",       {|| ( tmpClient )->Cod } )
   else
      oFr:SetMasterDetail( "Clientes",       "Documentos",        {|| ( D():Get( "Client", nView ) )->Cod } )
      oFr:SetMasterDetail( "Clientes",       "Tarifas clientes",  {|| ( D():Get( "Client", nView ) )->Cod } )
      oFr:SetMasterDetail( "Clientes",       "Direcciones",       {|| ( D():Get( "Client", nView ) )->Cod } )
      oFr:SetMasterDetail( "Clientes",       "Contactos",         {|| ( D():Get( "Client", nView ) )->Cod } )
      oFr:SetMasterDetail( "Clientes",       "Bancos",            {|| ( D():Get( "Client", nView ) )->Cod } )
      oFr:SetMasterDetail( "Clientes",       "Incidencias",       {|| ( D():Get( "Client", nView ) )->Cod } )
   end if

   oFr:SetResyncPair(      "Clientes",       "Documentos" )
   oFr:SetResyncPair(      "Clientes",       "Tarifas clientes" )
   oFr:SetResyncPair(      "Clientes",       "Direcciones" )
   oFr:SetResyncPair(      "Clientes",       "Contactos" )
   oFr:SetResyncPair(      "Clientes",       "Bancos" )
   oFr:SetResyncPair(      "Clientes",       "Incidencias" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportClient( oFr, dbfDoc )

   local oLabel
   local nRec
   local nOrd
   local lOpen    := .f.
   local lFlag    := .f.

   /*
   Tratamiento para no hacer dos veces el openfiles al editar el documento en imprimir series
   */

   if lOpenFiles
      lFlag       := .t.
      nRec        := ( D():Get( "Client", nView ) )->( Recno() )
      nOrd        := ( D():Get( "Client", nView ) )->( OrdSetFocus( "Cod" ) )
   else
      if Openfiles()
         lFlag    := .t.
         lOpen    := .t.
      else
         lFlag    := .f.
      end if
   end if

   if lFlag

      oLabel      := TClienteLabelGenerator()

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
            oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet",        "Clientes" )

         end if

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

         Return .f.

      end if

   end if

   if !Empty( nRec )
      ( D():Get( "Client", nView ) )->( dbGoTo( nRec ) )
   end if

   if !Empty( nOrd )
      ( D():Get( "Client", nView ) )->( OrdSetFocus( nOrd ) )
   end if

   if lOpen
      CloseFiles()
   end if

Return .t.

//---------------------------------------------------------------------------//

Function PrintReportCliente( nDevice, nCopies, cPrinter, dbfDoc )

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

Static Function lPubInt( nMode, aTmp )

   if nMode != APPD_MODE
      aTmp[ _CCODWEB ]  := 0
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function lArticuloEnOferta( cCodigoArticulo, cCodigoCliente, cCodigoGrupo )

   local lOferta     := .f.

   if ( dbfOfe )->( dbSeek( cCodigoArticulo ) )

      while ( dbfOfe )->cArtOfe == cCodigoArticulo .and. !( dbfOfe )->( eof() )

         /*
         Comprobamos si esta entre las fechas----------------------------------
         */

         if ( GetSysDate() >= ( dbfOfe )->dIniOfe .or. Empty( ( dbfOfe )->dIniOfe ) ) .and. ;
            ( GetSysDate() <= ( dbfOfe )->dFinOfe .or. Empty( ( dbfOfe )->dFinOfe ) ) .and. ;
            ( ( dbfOfe )->nCliOfe == 1 .or. ( ( dbfOfe )->nCliOfe == 2 .and. cCodigoCliente == ( dbfOfe )->cCliOfe ) .or. ( ( dbfOfe )->nCliOfe == 3 .and. cCodigoGrupo == ( dbfOfe )->cGrpOfe ) )

            lOferta  := .t.

            exit

         end if

         ( dbfOfe )->( dbSkip() )

      end do

   end if

Return ( lOferta )

//---------------------------------------------------------------------------//

Static Function ReportingClient()

   oReporting        := TFastVentasClientes():New()
   oReporting:Play()

Return ( oReporting )

//---------------------------------------------------------------------------//

FUNCTION BrwCli( oGet, oGet2, dbfCli )

   local oDlg
   local oBrw
   local hBmp
   local oGet1
   local cGet1
   local nOrd     := GetBrwOpt( "BrwCli" )
   local oCbxOrd
   local aCbxOrd  := { "Código", "Nombre", "NIF/CIF", "Población", "Provincia", "Código postal", "Teléfono", "Establecimiento", "Correo electrónico" }
   local cCbxOrd
   local cReturn  := Space( 12 )

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   nOrd           := ( dbfCli )->( OrdSetFocus( nOrd ) )

   ( dbfCli )->( dbGoTop() )

   DEFINE DIALOG           oDlg ;
      RESOURCE             "HelpEntry" ;
      TITLE                "Seleccionar clientes"

      REDEFINE GET         oGet1 ;
         VAR               cGet1 ;
         ID                104 ;
         ON CHANGE         AutoSeek( nKey, nFlags, Self, oBrw, dbfCli ) ;
         BITMAP            "FIND" ;
         OF                oDlg

      REDEFINE COMBOBOX    oCbxOrd ;
         VAR               cCbxOrd ;
         ID                102 ;
         ITEMS             aCbxOrd ;
         ON CHANGE         ( ( dbfCli )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
         OF                oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfCli
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Clientes.Report"

      with object ( oBrw:AddCol() )
         :cHeader          := "Bl. Bloqueado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfCli )->lBlqCli }
         :nWidth           := 20
         :SetCheck( { "Cnt16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Cod"
         :bEditValue       := {|| ( dbfCli )->Cod }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Titulo"
         :bEditValue       := {|| ( dbfCli )->Titulo }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "NIF/CIF"
         :cSortOrder       := "Nif"
         :bEditValue       := {|| ( dbfCli )->Nif }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Teléfono"
         :cSortOrder       := "Telefono"
         :bEditValue       := {|| ( dbfCli )->Telefono }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fax"
         :bEditValue       := {|| ( dbfCli )->Fax }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Domicilio"
         :bEditValue       := {|| ( dbfCli )->Domicilio }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Población"
         :cSortOrder       := "Poblacion"
         :bEditValue       := {|| ( dbfCli )->Poblacion }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código postal"
         :cSortOrder       := "CodPostal"
         :bEditValue       := {|| ( dbfCli )->CodPostal }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Provincia"
         :cSortOrder       := "Provincia"
         :bEditValue       := {|| ( dbfCli )->Provincia }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Establecimiento"
         :cSortOrder       := "NbrEst"
         :bEditValue       := {|| ( dbfCli )->NbrEst }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Correo electrónico"
         :cSortOrder       := "cMeiInt"
         :bEditValue       := {|| ( dbfCli )->cMeiInt }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Riesgo"
         :bEditValue       := {|| Trans( ( dbfCli )->Riesgo, PicOut() ) }
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Contacto"
         :bEditValue       := {|| ( dbfCli )->cPerCto }
         :nWidth           := 100
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Observaciones"
         :bEditValue       := {|| ( dbfCli )->mComent }
         :nWidth           := 200
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      REDEFINE BUTTON ;
         ID                IDOK ;
         OF                oDlg ;
         ACTION            ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID                IDCANCEL ;
         OF                oDlg ;
         ACTION            ( oDlg:end() )

      REDEFINE BUTTON ;
         ID                500 ;
         OF                oDlg ;
         WHEN              .f. ;
         ACTION            ( nil )

      REDEFINE BUTTON ;
         ID                501 ;
         OF                oDlg ;
         WHEN              .f. ;
         ACTION            ( nil )

   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )

   oDlg:bStart             :=    {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   CursorWait()

   if oDlg:nResult == IDOK

      cReturn  := ( dbfCli )->Cod

      if !Empty( oGet )
         oGet:cText( ( dbfCli )->Cod )
         oGet:lValid()
      end if

      if ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfCli)->Titulo )
         if ( dbfCli )->nColor != 0
            oGet2:SetColor( , ( dbfCli )->nColor )
         end if
      end if

   end if

   SetBrwOpt( "BrwCli", ( dbfCli )->( OrdNumber() ) )

   ( dbfCli )->( OrdSetFocus( nOrd ) )

   if !Empty( oBrw )
      oBrw:end()
   end if

   CursorWE()

   if !Empty( oGet )
      oGet:SetFocus()
   end if

RETURN cReturn

//---------------------------------------------------------------------------//
/*
Devuelve la cuenta del banco cliente
*/

FUNCTION cCtaBanCli( cCodCli, dbfBanco )

   local nRec
   local oBlock
   local oError
   local nOrdAnt
   local cText    := ""
   local lClose   := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfBanco )
      USE ( cPatCli() + "CliBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIBNC", @dbfBanco ) )
      SET ADSINDEX TO ( cPatCli() + "CliBnc.Cdx" ) ADDITIVE
      SET TAG TO CCODDEF
      lClose      := .t.
   else
      nRec        := ( dbfBanco )->( Recno() )
      nOrdAnt     := ( dbfBanco )->( OrdSetFocus( "cCodDef" ) )
   end if

   if ( dbfBanco )->( dbSeek( cCodCli ) )
      cText       := ( dbfBanco )->cCtaBnc
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de bancos" )

   END SEQUENCE
   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfBanco )
   else
      ( dbfBanco )->( OrdSetFocus( nOrdAnt ) )
      ( dbfBanco )->( dbGoTo( nRec ) )
   end if

Return ( cText )

//---------------------------------------------------------------------------//
/*
Devuelve la cuenta contable de un cliente
*/

FUNCTION cCliCta( cCodCli, dbfCli )

   local oBlock
   local oError
   local cText    := ""
   local lClose   := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfCli )
      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfCli ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if dbSeekInOrd( cCodCli, "Cod", dbfCli )
      cText       := Rtrim( ( dbfCli )->SubCta )
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de clientes" )

   END SEQUENCE
   ErrorBlock( oBlock )

   IF lClose
      CLOSE ( dbfCli )
   END IF

RETURN cText

//---------------------------------------------------------------------------//

/*
Devuelve la cuenta de Venta de un cliente
*/

FUNCTION cCliCtaVta( cCodCli, dbfCli )

   local oBlock
   local oError
   local lClose      := .f.
   local cCliCtaVta  := ""

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfCli )
      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfCli ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE
      lClose         := .t.
   end if

   if dbSeekInOrd( cCodCli, "Cod", dbfCli )
      cCliCtaVta     := ( dbfCli )->CtaVenta
   end if

   if Empty( cCliCtaVta )
      cCliCtaVta     := cCtaCli()
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de clientes" )

   END SEQUENCE
   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfCli )
   end if

RETURN ( cCliCtaVta )

//---------------------------------------------------------------------------//

FUNCTION cBanco( cCodCli, dbfCli )

   local oBlock
   local oError
   local cText    := ""
   local lClose   := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfCli )
      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfCli ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   IF ( dbfCli )->( dbSeek( Rjust( cCodCli, "0" ) ) )
      cText       := ( dbfCli )->Banco
   END IF

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de clientes" )

   END SEQUENCE
   ErrorBlock( oBlock )

   IF lClose
      CLOSE ( dbfCli )
   END IF

RETURN cText

//---------------------------------------------------------------------------//

FUNCTION lClienteBloquearRiesgo( cCodCli, dbfCli )

   local lRet     := .f.

   if dbSeekInOrd( cCodCli, "Cod", dbfCli )
      lRet        := ( dbfCli )->lCreSol
   end if

RETURN lRet

//---------------------------------------------------------------------------//

Function lClienteEvaluarRiesgo( cCodCli, oStock, dbfClient )

   if lClienteBloquearRiesgo( cCodCli, dbfClient )

      if oStock:nRiesgo( cCodCli ) >= ( dbfClient )->Riesgo

         Return .t.

      end if 

   end if   

Return .f. 

//---------------------------------------------------------------------------//

FUNCTION BrwBncCli( oGet, oPaisIBAN, oControlIBAN, oEntBnc, oSucBnc, oDigBnc, oCtaBnc, cCodCli, dbfBancos )

   local oDlg
   local oBrw
   local oFont
   local oBtn
   local oGet1
   local cGet1
   local nOrd        := GetBrwOpt( "BrwBancos" )
   local oCbxOrd
   local aCbxOrd     := { "Nombre", "Cuenta" }
   local cCbxOrd     := "Nombre"
   local nLevel      := nLevelUsr( "01032" )
   local lClose      := .f.

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if Empty( cCodCli )
      MsgStop( "Es necesario codificar un cliente" )
      return .t.
   end if

   if !lExistTable( cPatCli() + "CliBnc.Dbf" )
      MsgStop( 'No existe el fichero de bancos' )
      Return .f.
   end if

   if Empty( dbfBancos )
      USE ( cPatCli() + "CliBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIBNC", @dbfBancos ) )
      SET ADSINDEX TO ( cPatCli() + "CliBnc.Cdx" ) ADDITIVE
      lClose         := .t.
   end if

   ( dbfBancos )->( ordSetFocus( nOrd ) )

   ( dbfBancos )->( OrdScope( 0, cCodCli ) )
   ( dbfBancos )->( OrdScope( 1, cCodCli ) )
   ( dbfBancos )->( dbGoTop() )

   DEFINE DIALOG  oDlg ;
      RESOURCE    "HELPENTRY";
      TITLE       "Seleccionar banco"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfBancos, nil, cCodCli ) );
         BITMAP   "Find" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE(  ( dbfBancos )->( OrdSetFocus( oCbxOrd:nAt ) ),;
                     ( dbfBancos )->( OrdScope( 0, cCodCli ) ),;
                     ( dbfBancos )->( OrdScope( 1, cCodCli ) ),;
                     oBrw:Refresh(),;
                     oGet1:SetFocus() );
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfBancos
      oBrw:nMarqueeStyle   := 5

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| ( dbfBancos )->cCodBnc }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cuenta"
         :cSortOrder       := "cCtaBnc"
         :bEditValue       := {|| PictureCuentaIBAN( dbfBancos ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Domicilio"
         :bEditValue       := {|| ( dbfBancos )->cDirBnc }
         :nWidth           := 120
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Población"
         :bEditValue       := {|| ( dbfBancos )->cPobBnc }
         :nWidth           := 100
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código postal"
         :bEditValue       := {|| ( dbfBancos )->cCPBnc }
         :nWidth           := 40
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Provincia"
         :bEditValue       := {|| ( dbfBancos )->cProBnc }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Teléfono"
         :bEditValue       := {|| ( dbfBancos )->cTlfBnc }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fax"
         :bEditValue       := {|| ( dbfBancos )->cFaxBnc }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Contacto"
         :bEditValue       := {|| ( dbfBancos )->cPContBnc }
         :nWidth           := 140
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( .f. );
         ACTION   ( nil )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( .f. );
         ACTION   ( nil )

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      oGet:cText( ( dbfBancos )->cCodBnc )
      oPaisIBAN:cText( ( dbfBancos )->cPaisIBAN )
      oControlIBAN:cText( ( dbfBancos )->cCtrlIBAN )
      oEntBnc:cText( ( dbfBancos )->cEntBnc )
      oSucBnc:cText( ( dbfBancos )->cSucBnc )
      oDigBnc:cText( ( dbfBancos )->cDigBnc )
      oCtaBnc:cText( ( dbfBancos )->cCtaBnc )
   end if

   DestroyFastFilter( dbfBancos )

   SetBrwOpt( "BrwBancos", ( dbfBancos )->( OrdNumber() ) )

   if lClose
      ( dbfBancos )->( dbCloseArea() )
   else
      ( dbfBancos )->( OrdSetFocus( nOrd ) )
      ( dbfBancos )->( OrdScope( 0, nil ) )
      ( dbfBancos )->( OrdScope( 1, nil ) )
   end if

   oGet:setFocus()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function cClientCuenta( cCliente, dbfBncCli, lIBAN )

   local lCloseBnc   := .f.
   local cCuenta     := ""

   DEFAULT lIBAN     := .t.

   if Empty( dbfBncCli )
      USE ( cPatCli() + "CliBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIBNC", @dbfBncCli ) )
      SET ADSINDEX TO ( cPatCli() + "CliBnc.Cdx" ) ADDITIVE
      lCloseBnc      := .t.
   end if

   if dbSeekInOrd( cCliente, "cBncDef", dbfBncCli )
      if lIBAN
         cCuenta     := ( dbfBncCli )->cPaisIBAN + ( dbfBncCli )->cCtrlIBAN 
      end if 
      cCuenta        +=  ( dbfBncCli )->cEntBnc + ( dbfBncCli )->cSucBnc + ( dbfBncCli )->cDigBnc + ( dbfBncCli )->cCtaBnc
   end if

   if Empty( cCuenta )
      if dbSeekInOrd( cCliente, "cCodCli", dbfBncCli )
         if lIBAN
            cCuenta  := ( dbfBncCli )->cPaisIBAN + ( dbfBncCli )->cCtrlIBAN 
         end if 
         cCuenta     +=  ( dbfBncCli )->cEntBnc + ( dbfBncCli )->cSucBnc + ( dbfBncCli )->cDigBnc + ( dbfBncCli )->cCtaBnc
      end if
   end if

   cCuenta           := Alltrim( cCuenta )

   if lCloseBnc
      CLOSE ( dbfBncCli )
   end if

Return cCuenta

//---------------------------------------------------------------------------//

Function cClientEntidad( cCliente, dbfBncCli )

   local cCuenta     := ""

   if dbSeekInOrd( cCliente, "cBncDef", dbfBncCli )
      cCuenta        := ( dbfBncCli )->cEntBnc
   end if

   if Empty( cCuenta )
      if dbSeekInOrd( cCliente, "cCodCli", dbfBncCli )
         cCuenta     := ( dbfBncCli )->cEntBnc
      end if
   end if

   cCuenta           := Alltrim( cCuenta )

Return cCuenta

//---------------------------------------------------------------------------//
/*
Nos informa si tenemos atipicas para este cliente------------------------------
*/

function lAtipicaCliente( cCodCli, dbfAtpCli )

return ( dbfAtpCli )->( dbSeek( cCodCli ) )

//---------------------------------------------------------------------------//

Function lConditionAtipica( dFecha, dbfClientAtp )

   if !Empty( ( dbfClientAtp )->cCodArt )    .and.;
      ( dbfClientAtp )->nTipAtp <= 1         .and.;
      ( empty( dFecha ) .or. empty( ( dbfClientAtp )->dFecIni ) .or. ( dbfClientAtp )->dFecIni <= dFecha  ) .and. ;
      ( empty( dFecha ) .or. empty( ( dbfClientAtp )->dFecFin ) .or. ( dbfClientAtp )->dFecFin >= dFecha  )

      Return .t.

   end if   

Return .f.

//---------------------------------------------------------------------------//

Function hAtipica( hValue )

   local nRec
   local hAtipica                         := {=>}
   local nModOferta

   if !hhaskey( hValue, "cCodigoArticulo" )     .or.;
      !hhaskey( hValue, "cCodigoPropiedad1" )   .or.;
      !hhaskey( hValue, "cCodigoPropiedad2" )   .or.;
      !hhaskey( hValue, "cValorPropiedad1" )    .or.;
      !hhaskey( hValue, "cValorPropiedad2" )    .or.;
      !hhaskey( hValue, "cCodigoFamilia" )      .or.;
      !hhaskey( hValue, "cCodigoCliente" )      .or.;
      !hhaskey( hValue, "cCodigoGrupo" )        .or.;
      !hhaskey( hValue, "nTarifaPrecio" )       .or.;
      !hhaskey( hValue, "lIvaIncluido" )        .or.;
      !hhaskey( hValue, "dFecha" )              .or.;
      !hhaskey( hValue, "nTipoDocumento" )      .or.;
      !hhaskey( hValue, "nCajas" )              .or.;
      !hhaskey( hValue, "nUnidades" )           .or.;
      !hhaskey( hValue, "nView" )               

      msgStop( "Faltan parametros función hAtipica" )

      return ( hAtipica )

   endif 

   /*
   Guardamos la posición inicial-----------------------------------------------
   */

   nRec              		:= ( D():Atipicas( hValue[ "nView" ] ) )->( Recno() )

   /*
   Buscamos por articulo-------------------------------------------------------
   */
   
   if !Empty( hValue[ "cCodigoCliente" ] )

      if dbSeekInOrd( hValue[ "cCodigoCliente" ] + hValue[ "cCodigoArticulo" ] + hValue[ "cCodigoPropiedad1" ] + hValue[ "cCodigoPropiedad2" ] + hValue[ "cValorPropiedad1" ] + hValue[ "cValorPropiedad2" ], "cCliArt", D():Atipicas( hValue[ "nView" ] ) )
         
         if lFechasAtipicas( hValue[ "nView" ], hValue[ "dFecha" ] ) .and.;
            lAplicaDocumento( hValue[ "nView" ], hValue[ "nTipoDocumento" ] )

            hAtipica       := hValoresAtipica( hValue, hAtipica )

         end if

      end if 

   end if   

   if Empty( hAtipica ) .or. ( !Empty( hAtipica ) .and. hhaskey( hAtipica, "nImporte" ) .and. empty( hAtipica[ "nImporte" ] ) )

      if !Empty( hValue[ "cCodigoGrupo" ] )

         if dbSeekInOrd( hValue[ "cCodigoGrupo" ] + hValue[ "cCodigoArticulo" ] + hValue[ "cCodigoPropiedad1" ] + hValue[ "cCodigoPropiedad2" ] + hValue[ "cValorPropiedad1" ] + hValue[ "cValorPropiedad2" ], "cGrpArt", D():Atipicas( hValue[ "nView" ] ) )

            if lFechasAtipicas( hValue[ "nView" ], hValue[ "dFecha" ] ) .and.;
               lAplicaDocumento( hValue[ "nView" ], hValue[ "nTipoDocumento" ] )

               hAtipica    := hValoresAtipica( hValue, hAtipica )

            end if   
         
         end if

      end if 
   
   end if 

   /*
   Buscamos por familia--------------------------------------------------------
   */

   if !Empty( hValue[ "cCodigoCliente" ] )

      if !Empty( hValue[ "cCodigoFamilia" ] )         .and.;
         dbSeekInOrd( hValue[ "cCodigoCliente" ] + hValue[ "cCodigoFamilia" ], "cCodFam", D():Atipicas( hValue[ "nView" ] ) )
         
         if lFechasAtipicas( hValue[ "nView" ], hValue[ "dFecha" ] ) .and.;
            lAplicaDocumento( hValue[ "nView" ], hValue[ "nTipoDocumento" ] )

            hAtipica       := hValoresAtipica( hValue, hAtipica )

         end if

      end if 

   end if   

   if !Empty( hValue[ "cCodigoGrupo" ] )

      if Empty( hAtipica ) .or. ( !Empty( hAtipica ) .and. empty( hAtipica[ "nDescuentoPorcentual" ] ) )

         if !Empty( hValue[ "cCodigoFamilia" ] )         .and.;
            dbSeekInOrd( hValue[ "cCodigoGrupo" ] + hValue[ "cCodigoFamilia" ], "cGrpFam", D():Atipicas( hValue[ "nView" ] ) )

            if lFechasAtipicas( hValue[ "nView" ], hValue[ "dFecha" ] ) .and.;
               lAplicaDocumento( hValue[ "nView" ], hValue[ "nTipoDocumento" ] )

               hAtipica    := hValoresAtipica( hValue, hAtipica )

            end if  
         
         end if 
      
      end if

   end if   

   /*
   Informamos de las unidades de Regalo de las Unidades XY---------------------
   */

   if !Empty( hAtipica )

      if hhaskey( hAtipica, "nTipoXY" )           .and.;
         hhaskey( hAtipica, "nUnidadesVender" )   .and.;
         hhaskey( hAtipica, "nUnidadesCobrar" )

         do case
            case hAtipica[ "nTipoXY" ] == 1     //Cajas

               nModOferta                       := Int( Div( hValue[ "nCajas" ], hAtipica[ "nUnidadesVender" ] ) )
               hAtipica[ "nUnidadesGratis" ]    := ( hAtipica[ "nUnidadesVender" ] - hAtipica[ "nUnidadesCobrar" ] ) * nModOferta

            case hAtipica[ "nTipoXY" ] == 2     //Unidades

               if mod( hValue[ "nCajas" ] * hValue[ "nUnidades" ], hAtipica["nUnidadesVender"] ) == 0

                  nModOferta                       := Int( Div( hValue[ "nUnidades" ], hAtipica[ "nUnidadesVender" ] ) )
                  hAtipica[ "nUnidadesGratis" ]    := ( hAtipica[ "nUnidadesVender" ] - hAtipica[ "nUnidadesCobrar" ] ) * nModOferta

               end if

         end case

      end if  

   end if 

   /*
   Devolvemos a su posición inicial--------------------------------------------
   */
   
   ( D():Atipicas( hValue[ "nView" ] ) )->( dbGoTo( nRec ) )

Return ( hAtipica )
      
//---------------------------------------------------------------------------//

Function hValoresAtipica( hValue, hAtipica )

   local nTarifa
   local nDescuentoTarifa              := 1

   if hhaskey( hValue, "nTarifaPrecio" )
      nTarifa                          := hValue[ "nTarifaPrecio" ]
   end if

   if hhaskey( hValue, "nDescuentoTarifa" )
      nDescuentoTarifa                 := hValue[ "nDescuentoTarifa" ]
   end if 

   /*
   Carga de valores------------------------------------------------------------
   */
   
   /*if hhaskey( hAtipica, "nDescuentoPorcentual" )
      if hAtipica[ "nDescuentoPorcentual" ] == 0
         hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDtoArt
      end if
   else
      hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDtoArt
   end if*/

   if hhaskey( hAtipica, "nDescuentoLineal" )
      if hAtipica[ "nDescuentoLineal" ] == 0
         hAtipica[ "nDescuentoLineal" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDtoDiv
      end if
   else
      hAtipica[ "nDescuentoLineal" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDtoDiv
   end if

   if hhaskey( hAtipica, "nDescuentoPromocional" )
      if hAtipica[ "nDescuentoPromocional" ] == 0
         hAtipica[ "nDescuentoPromocional" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDprArt
      end if
   else
      hAtipica[ "nDescuentoPromocional" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDprArt
   end if

   if ( D():Atipicas( hValue[ "nView" ] ) )->lComAge
      hAtipica[ "nComisionAgente" ]       := ( D():Atipicas( hValue[ "nView" ] ) )->nComAge
   end if
      
   hAtipica[ "nTipoXY" ]                  := ( D():Atipicas( hValue[ "nView" ] ) )->nTipXby
   hAtipica[ "nUnidadesVender" ]          := ( D():Atipicas( hValue[ "nView" ] ) )->nUnvOfe
   hAtipica[ "nUnidadesCobrar" ]          := ( D():Atipicas( hValue[ "nView" ] ) )->nUncOfe

   if ( D():Atipicas( hValue[ "nView" ] ) )->lPrcCom
      hAtipica[ "nCostoParticular" ]      := ( D():Atipicas( hValue[ "nView" ] ) )->nPrcCom
   end if

   /*
   Buscamos en las tarifas anteriores si lo tiene marcado en la empresa--------
   */

   if empty( nTarifa )
      nTarifa        := 1
   end if

   while .t.

      do case
         case nTarifa <= 1

            if hhaskey( hAtipica, "nImporte" )
               if hAtipica[ "nImporte" ] == 0.00000
                  hAtipica[ "nImporte" ]              := if( hValue[ "lIvaIncluido" ], ( D():Atipicas( hValue[ "nView" ] ) )->nPreIva1, ( D():Atipicas( hValue[ "nView" ] ) )->nPrcArt )
               end if
            else
               hAtipica[ "nImporte" ]                 := if( hValue[ "lIvaIncluido" ], ( D():Atipicas( hValue[ "nView" ] ) )->nPreIva1, ( D():Atipicas( hValue[ "nView" ] ) )->nPrcArt )
            end if

            if hhaskey( hAtipica, "nDescuentoPorcentual" )
               if hAtipica[ "nDescuentoPorcentual" ] == 0
                  hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDto1
               end if
            else
               hAtipica[ "nDescuentoPorcentual" ]     := ( D():Atipicas( hValue[ "nView" ] ) )->nDto1
            end if

         case nTarifa == 2

            if hhaskey( hAtipica, "nImporte" )
               if hAtipica[ "nImporte" ] == 0
                  hAtipica[ "nImporte" ]              := if( hValue[ "lIvaIncluido" ], ( D():Atipicas( hValue[ "nView" ] ) )->nPreIva2, ( D():Atipicas( hValue[ "nView" ] ) )->nPrcArt2 )
               end if
            else
               hAtipica[ "nImporte" ]                 := if( hValue[ "lIvaIncluido" ], ( D():Atipicas( hValue[ "nView" ] ) )->nPreIva2, ( D():Atipicas( hValue[ "nView" ] ) )->nPrcArt2 )
            end if

            if hhaskey( hAtipica, "nDescuentoPorcentual" )
               if hAtipica[ "nDescuentoPorcentual" ] == 0
                  hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDto2
               end if
            else
               hAtipica[ "nDescuentoPorcentual" ]     := ( D():Atipicas( hValue[ "nView" ] ) )->nDto2
            end if

         case nTarifa == 3

            if hhaskey( hAtipica, "nImporte" )
               if hAtipica[ "nImporte" ] == 0
                  hAtipica[ "nImporte" ]              := if( hValue[ "lIvaIncluido" ], ( D():Atipicas( hValue[ "nView" ] ) )->nPreIva3, ( D():Atipicas( hValue[ "nView" ] ) )->nPrcArt3 )
               end if
            else
               hAtipica[ "nImporte" ]                 := if( hValue[ "lIvaIncluido" ], ( D():Atipicas( hValue[ "nView" ] ) )->nPreIva3, ( D():Atipicas( hValue[ "nView" ] ) )->nPrcArt3 )
            end if

            if hhaskey( hAtipica, "nDescuentoPorcentual" )
               if hAtipica[ "nDescuentoPorcentual" ] == 0
                  hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDto3
               end if
            else
               hAtipica[ "nDescuentoPorcentual" ]     := ( D():Atipicas( hValue[ "nView" ] ) )->nDto3
            end if

         case nTarifa == 4

            if hhaskey( hAtipica, "nImporte" )
               if hAtipica[ "nImporte" ] == 0
                  hAtipica[ "nImporte" ]              := if( hValue[ "lIvaIncluido" ], ( D():Atipicas( hValue[ "nView" ] ) )->nPreIva4, ( D():Atipicas( hValue[ "nView" ] ) )->nPrcArt4 )
               end if
            else
               hAtipica[ "nImporte" ]                 := if( hValue[ "lIvaIncluido" ], ( D():Atipicas( hValue[ "nView" ] ) )->nPreIva4, ( D():Atipicas( hValue[ "nView" ] ) )->nPrcArt4 )
            end if

            if hhaskey( hAtipica, "nDescuentoPorcentual" )
               if hAtipica[ "nDescuentoPorcentual" ] == 0
                  hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDto4
               end if
            else
               hAtipica[ "nDescuentoPorcentual" ]     := ( D():Atipicas( hValue[ "nView" ] ) )->nDto4
            end if

         case nTarifa == 5

            if hhaskey( hAtipica, "nImporte" )
               if hAtipica[ "nImporte" ] == 0
                  hAtipica[ "nImporte" ]              := if( hValue[ "lIvaIncluido" ], ( D():Atipicas( hValue[ "nView" ] ) )->nPreIva5, ( D():Atipicas( hValue[ "nView" ] ) )->nPrcArt5 )
               end if
            else
               hAtipica[ "nImporte" ]                 := if( hValue[ "lIvaIncluido" ], ( D():Atipicas( hValue[ "nView" ] ) )->nPreIva5, ( D():Atipicas( hValue[ "nView" ] ) )->nPrcArt5 )
            end if

            if hhaskey( hAtipica, "nDescuentoPorcentual" )
               if hAtipica[ "nDescuentoPorcentual" ] == 0
                  hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDto5
               end if
            else
               hAtipica[ "nDescuentoPorcentual" ]     := ( D():Atipicas( hValue[ "nView" ] ) )->nDto5
            end if

         case nTarifa == 6

            if hhaskey( hAtipica, "nImporte" )
               if hAtipica[ "nImporte" ] == 0
                  hAtipica[ "nImporte" ]              := if( hValue[ "lIvaIncluido" ], ( D():Atipicas( hValue[ "nView" ] ) )->nPreIva6, ( D():Atipicas( hValue[ "nView" ] ) )->nPrcArt6 )
               end if
            else
               hAtipica[ "nImporte" ]                 := if( hValue[ "lIvaIncluido" ], ( D():Atipicas( hValue[ "nView" ] ) )->nPreIva6, ( D():Atipicas( hValue[ "nView" ] ) )->nPrcArt6 )
            end if

            if hhaskey( hAtipica, "nDescuentoPorcentual" )
               if hAtipica[ "nDescuentoPorcentual" ] == 0
                  hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDto6
               end if
            else
               hAtipica[ "nDescuentoPorcentual" ]     := ( D():Atipicas( hValue[ "nView" ] ) )->nDto6
            end if

      end case

      if hhaskey( hAtipica, "nImporte" ) .and. hAtipica[ "nImporte" ] == 0 .and. nTarifa > 1 .and. lBuscaImportes()
         nTarifa--
         loop
      else
         exit
      end if

   end while

   /*
   Aplicamos el descuento segun el descuento de tarifa que tenemos en la ficha del cliente
   */

   do case
      case nDescuentoTarifa == 1

         if hhaskey( hAtipica, "nDescuentoPorcentual" )
            if hAtipica[ "nDescuentoPorcentual" ] == 0
               hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDto1
            end if
         else
            hAtipica[ "nDescuentoPorcentual" ]     := ( D():Atipicas( hValue[ "nView" ] ) )->nDto1
         end if

      case nDescuentoTarifa == 2

         if hhaskey( hAtipica, "nDescuentoPorcentual" )
            if hAtipica[ "nDescuentoPorcentual" ] == 0
               hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDto2
            end if
         else
            hAtipica[ "nDescuentoPorcentual" ]     := ( D():Atipicas( hValue[ "nView" ] ) )->nDto2
         end if

      case nDescuentoTarifa == 3

         if hhaskey( hAtipica, "nDescuentoPorcentual" )
            if hAtipica[ "nDescuentoPorcentual" ] == 0
               hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDto3
            end if
         else
            hAtipica[ "nDescuentoPorcentual" ]     := ( D():Atipicas( hValue[ "nView" ] ) )->nDto3
         end if

      case nDescuentoTarifa == 4

         if hhaskey( hAtipica, "nDescuentoPorcentual" )
            if hAtipica[ "nDescuentoPorcentual" ] == 0
               hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDto4
            end if
         else
            hAtipica[ "nDescuentoPorcentual" ]     := ( D():Atipicas( hValue[ "nView" ] ) )->nDto4
         end if

      case nDescuentoTarifa == 5

         if hhaskey( hAtipica, "nDescuentoPorcentual" )
            if hAtipica[ "nDescuentoPorcentual" ] == 0
               hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDto5
            end if
         else
            hAtipica[ "nDescuentoPorcentual" ]     := ( D():Atipicas( hValue[ "nView" ] ) )->nDto5
         end if

      case nDescuentoTarifa == 6
          if hhaskey( hAtipica, "nDescuentoPorcentual" )
            if hAtipica[ "nDescuentoPorcentual" ] == 0
               hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDto6
            end if
         else
            hAtipica[ "nDescuentoPorcentual" ]     := ( D():Atipicas( hValue[ "nView" ] ) )->nDto6
         end if

   end case

   /*
   Cogemos ahora el descuento por si ya lo tenemos cogio-----------------------
   */

   if hhaskey( hAtipica, "nDescuentoPorcentual" )
      if hAtipica[ "nDescuentoPorcentual" ] == 0
         hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDtoArt
      end if
   else
      hAtipica[ "nDescuentoPorcentual" ]  := ( D():Atipicas( hValue[ "nView" ] ) )->nDtoArt
   end if

Return ( hAtipica )

//---------------------------------------------------------------------------//

function lFechasAtipicas( nView, dFecha )

Return ( ( empty( ( D():Atipicas( nView ) )->dFecIni ) .or. ( D():Atipicas( nView ) )->dFecIni <= dFecha ) .and. ;
       ( empty( ( D():Atipicas( nView ) )->dFecFin ) .or. ( D():Atipicas( nView ) )->dFecFin >= dFecha ) )

//---------------------------------------------------------------------------//

function lAplicaDocumento( nView, nDocumento )

   local lReturn  := .f.

   do case
      case nDocumento == PRE_CLI
         lReturn  := ( D():Atipicas( nView ) )->lAplPre

      case nDocumento == PED_CLI
         lReturn  := ( D():Atipicas( nView ) )->lAplPed

      case nDocumento == ALB_CLI
         lReturn  := ( D():Atipicas( nView ) )->lAplAlb

      case nDocumento == FAC_CLI .or. nDocumento == FAC_REC .or. nDocumento == TIK_CLI
         lReturn  := ( D():Atipicas( nView ) )->lAplFac

      case nDocumento == SAT_CLI
         lReturn  := ( D():Atipicas( nView ) )->lAplSat

   end case   

Return lReturn

//---------------------------------------------------------------------------//

Function nImporteAtipica( cCodigoArticulo, cCodigoCliente, cCodigoGrupo, nTarifa, lIvaIncluido, dbfCliAtp )

   local nOrd              := ( dbfCliAtp )->( ordSetFocus() ) 
   local nRec              := ( dbfCliAtp )->( Recno() )
   local nImporteAtipica   := 0

   if dbSeekInOrd( cCodigoCliente + cCodigoArticulo, "cCliArt", dbfCliAtp )
      nImporteAtipica      := nPrecioAtipica( nTarifa, lIvaIncluido, dbfCliAtp )
   end if 

   if empty( nImporteAtipica )
      if dbSeekInOrd( cCodigoGrupo + cCodigoArticulo, "cGrpArt", dbfCliAtp )
         nImporteAtipica   := nPrecioAtipica( nTarifa, lIvaIncluido, dbfCliAtp )
      end if 
   end if 

   ( dbfCliAtp )->( ordSetFocus( nOrd ) ) 
   ( dbfCliAtp )->( dbGoTo( nRec ) )

Return ( nImporteAtipica )

//---------------------------------------------------------------------------//

function nPrecioAtipica( nTarifa, lIvaInc, dbfClientAtp )

   local nPrecio  := 0

   do case
      case nTarifa == 1
         nPrecio     := if( lIvaInc, ( dbfClientAtp )->nPreIva1, ( dbfClientAtp )->nPrcArt )
      case nTarifa == 2
         nPrecio     := if( lIvaInc, ( dbfClientAtp )->nPreIva2, ( dbfClientAtp )->nPrcArt2 )
      case nTarifa == 3
         nPrecio     := if( lIvaInc, ( dbfClientAtp )->nPreIva3, ( dbfClientAtp )->nPrcArt3 )
      case nTarifa == 4
         nPrecio     := if( lIvaInc, ( dbfClientAtp )->nPreIva4, ( dbfClientAtp )->nPrcArt4 )
      case nTarifa == 5
         nPrecio     := if( lIvaInc, ( dbfClientAtp )->nPreIva5, ( dbfClientAtp )->nPrcArt5 )
      case nTarifa == 6
         nPrecio     := if( lIvaInc, ( dbfClientAtp )->nPreIva6, ( dbfClientAtp )->nPrcArt6 )
   end case

Return nPrecio

//---------------------------------------------------------------------------//

FUNCTION RefBrwCta( oBrwCta, cSubCta, dbfDiario )

   if dbfDiario != nil

      if !Empty( cSubCta )
         ( dbfDiario )->( OrdScope( 0, cSubCta ) )
         ( dbfDiario )->( OrdScope( 1, cSubCta ) )
      else
         ( dbfDiario )->( OrdScope( 0, Replicate( "9", 12 ) ) )
         ( dbfDiario )->( OrdScope( 1, Replicate( "9", 12 ) ) )
      end if

      ( dbfDiario )->( dbGoTop() )

      if oBrwCta != nil
         oBrwCta:Refresh()
      end if

   end if

return .t.

//---------------------------------------------------------------------------//

Function lBuscarAtipicaArticulo( cCodCli, cCodGrp, dFecDoc, cCodArt, cCodPr1, cCodPr2, cValPr1, cValPr2, dbfCliAtp )

   local nOrd        
   local lSea        := .f.

   DEFAULT cCodPr1   := Space( 20 )
   DEFAULT cCodPr2   := Space( 20 )
   DEFAULT cValPr1   := Space( 40 )
   DEFAULT cValPr1   := Space( 40 )

   nOrd              := ( dbfCliAtp )->( OrdSetFocus( "cCliArt" ) )

   if ( dbfCliAtp )->( dbSeek( cCodCli + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 ) )

      while ( ( dbfCliAtp )->cCodCli + ( dbfCliAtp )->cCodArt + ( dbfCliAtp )->cCodPr1 + ( dbfCliAtp )->cCodPr2 + ( dbfCliAtp )->cValPr1 + ( dbfCliAtp )->cValPr2 == cCodCli + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 ) .and. !( dbfCliAtp )->( eof() ) 

         if lCheckAtipicaArticulo( dFecDoc, dbfCliAtp )

            lSea     := .t.

            exit

         else

            ( dbfCliAtp )->( dbSkip() )

         end if

      end while

   end if

   /*
   Me voy para que el registro se quede bienposicionado------------------------
   */

   if lSea
      ( dbfCliAtp )->( OrdSetFocus( nOrd ) )
      Return lSea
   end if

   if !lSea .and. ( dbfCliAtp )->( dbSeek( cCodCli + cCodArt ) )

      while ( ( dbfCliAtp )->cCodCli + ( dbfCliAtp )->cCodArt == cCodCli + cCodArt ) .and. !( dbfCliAtp )->( eof() ) 

         if lCheckAtipicaArticulo( dFecDoc, dbfCliAtp )

            lSea     := .t.
            exit

         else

            ( dbfCliAtp )->( dbSkip() )

         end if

      end while

   end if

   /*
   Me voy para que el registro se quede bienposicionado------------------------
   */

   if lSea
      ( dbfCliAtp )->( OrdSetFocus( nOrd ) )
      Return lSea
   end if

   // Buscamos por gupos de clientes-------------------------------------------

   if !Empty( cCodGrp )

      nOrd              := ( dbfCliAtp )->( OrdSetFocus( "cGrpArt" ) )

      if ( dbfCliAtp )->( dbSeek( cCodGrp + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 ) )

         while ( ( dbfCliAtp )->cCodGrp + ( dbfCliAtp )->cCodArt + ( dbfCliAtp )->cCodPr1 + ( dbfCliAtp )->cCodPr2 + ( dbfCliAtp )->cValPr1 + ( dbfCliAtp )->cValPr2 == cCodGrp + cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 ) .and. !( dbfCliAtp )->( eof() ) 

            if lCheckAtipicaArticulo( dFecDoc, dbfCliAtp ) .and. !lVaciaAtipicaArticulo( dbfCliAtp )

               lSea     := .t.

               exit

            else

               ( dbfCliAtp )->( dbSkip() )

            end if

         end while

      end if

      /*
      Me voy para que el registro se quede bienposicionado------------------------
      */

      if lSea
         ( dbfCliAtp )->( OrdSetFocus( nOrd ) )
         Return lSea
      end if

      if !lSea .and. ( dbfCliAtp )->( dbSeek( cCodGrp + cCodArt ) )

         while ( ( dbfCliAtp )->cCodGrp + ( dbfCliAtp )->cCodArt == cCodGrp + cCodArt ) .and. !( dbfCliAtp )->( eof() ) 

            if lCheckAtipicaArticulo( dFecDoc, dbfCliAtp ) .and. !lVaciaAtipicaArticulo( dbfCliAtp )

               lSea     := .t.

               exit

            else

               ( dbfCliAtp )->( dbSkip() )

            end if

         end while

      end if

      ( dbfCliAtp )->( OrdSetFocus( nOrd ) )

      /*
      Me voy para que el registro se quede bienposicionado------------------------
      */

      if lSea
         ( dbfCliAtp )->( OrdSetFocus( nOrd ) )
         Return lSea
      end if

   end if 

Return ( lSea )

//---------------------------------------------------------------------------//

Function lBuscarAtipicaFamilia( cCodCli, cCodGrp, dFecDoc, cCodFam, dbfCliAtp )

   local lSea     := .f.
   local nOrd     := ( dbfCliAtp )->( OrdSetFocus( "cCodFam" ) )

   if ( dbfCliAtp )->( dbSeek( cCodCli + cCodFam ) )

      while ( dbfCliAtp )->cCodCli + ( dbfCliAtp )->cCodFam == cCodCli + cCodFam  .and. !( dbfCliAtp )->( eof() )

         if lCheckAtipicaFamilia( dFecDoc, dbfCliAtp ) .and. !lVaciaAtipicaArticulo( dbfCliAtp )

            lSea  := .t.

            exit

         else

            ( dbfCliAtp )->( dbSkip() )

         end if

      end while

   end if

   ( dbfCliAtp )->( OrdSetFocus( nOrd ) )

   // Buscamos por grupo de cliente--------------------------------------------

   if !Empty( cCodGrp )

      nOrd     := ( dbfCliAtp )->( OrdSetFocus( "cGrpFam" ) )

      if !lSea .and. ( dbfCliAtp )->( dbSeek( cCodGrp + cCodFam ) )

         while ( dbfCliAtp )->cCodGrp + ( dbfCliAtp )->cCodFam == cCodGrp + cCodFam  .and. !( dbfCliAtp )->( eof() )

            if lCheckAtipicaFamilia( dFecDoc, dbfCliAtp ) .and. !lVaciaAtipicaArticulo( dbfCliAtp )

               lSea  := .t.
               
               exit

            else

               ( dbfCliAtp )->( dbSkip() )

            end if

         end while

      end if

      ( dbfCliAtp )->( OrdSetFocus( nOrd ) )

   end if   

Return ( lSea )

//---------------------------------------------------------------------------//

Static Function lCheckFechaAtipica( dFecDoc, dbfCliAtp )

Return ( ( empty( ( dbfCliAtp )->dFecIni ) .or. ( dbfCliAtp )->dFecIni <= dFecDoc ) .and. ;
         ( empty( ( dbfCliAtp )->dFecFin ) .or. ( dbfCliAtp )->dFecFin >= dFecDoc ) )

//---------------------------------------------------------------------------//

Static Function lCheckAtipicaArticulo( dFecDoc, dbfCliAtp )

Return ( lCheckFechaAtipica( dFecDoc, dbfCliAtp ) .and. ( dbfCliAtp )->nTipAtp <= 1 )

//---------------------------------------------------------------------------//

Static Function lCheckAtipicaFamilia( dFecDoc, dbfCliAtp )

Return ( lCheckFechaAtipica( dFecDoc, dbfCliAtp ) .and. ( dbfCliAtp )->nTipAtp == 2 )

//---------------------------------------------------------------------------//

Static Function lVaciaAtipicaArticulo( dbfCliAtp )

Return ( empty( ( dbfCliAtp )->nPrcArt  ) .and. ;
         empty( ( dbfCliAtp )->nPrcArt2 ) .and. ;
         empty( ( dbfCliAtp )->nPrcArt3 ) .and. ;
         empty( ( dbfCliAtp )->nPrcArt4 ) .and. ;
         empty( ( dbfCliAtp )->nPrcArt5 ) .and. ;
         empty( ( dbfCliAtp )->nPrcArt6 ) .and. ;
         empty( ( dbfCliAtp )->nDto1 )    .and. ;
         empty( ( dbfCliAtp )->nDto2 )    .and. ;
         empty( ( dbfCliAtp )->nDto3 )    .and. ;
         empty( ( dbfCliAtp )->nDto4 )    .and. ;
         empty( ( dbfCliAtp )->nDto5 )    .and. ;
         empty( ( dbfCliAtp )->nDto6 ) )

//---------------------------------------------------------------------------//

Static Function LlamadaAhora( aGet )

   if empty( aGet )
      if D():Lock( "Client", nView )
         ( D():Get( "Client", nView ) )->dLlaCli := date()
         ( D():Get( "Client", nView ) )->cTimCli := left( time(), 5 )
         D():UnLock( "Client", nView ) 
      end if 
   else 
      aGet[ _DLLACLI ]:cText( date() )
      aGet[ _CTIMCLI ]:cText( left( time(), 5 ) )
   end if

Return ( .t. )

//--------------------------------------------------------------------------//

FUNCTION AddIncidenciaCliente( nView, oBrw )

   WinAppRec( oBrw, bEdtInc, ( D():Get( "CliInc", nView ) ), ( D():Get( "Client", nView ) )->Cod ) 

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION EdtIncidenciaCliente( nView, oBrw )

   WinEdtRec( oBrw, bEdtInc, D():Get( "CliInc", nView ) )

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION ZooIncidenciaCliente( nView, oBrw )

   WinZooRec( oBrw, bEdtInc, D():Get( "CliInc", nView ) )

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION DelIncidenciaCliente( nView, oBrw )

   WinDelRec( oBrw, D():Get( "CliInc", nView ) )

RETURN .t.

//---------------------------------------------------------------------------//

static function aCreaArrayPeriodos()

   local aPeriodo := {}

   aAdd( aPeriodo, "Hoy" )

   aAdd( aPeriodo, "Ayer" )

   aAdd( aPeriodo, "Mes en curso" )

   aAdd( aPeriodo, "Mes anterior" )

   do case
      case Month( GetSysDate() ) <= 3
         aAdd( aPeriodo, "Primer trimestre" )

      case Month( GetSysDate() ) > 3 .and. Month( GetSysDate() ) <= 6
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )

      case Month( GetSysDate() ) > 6 .and. Month( GetSysDate() ) <= 9
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )
         aAdd( aPeriodo, "Tercer trimestre" )

      case Month( GetSysDate() ) > 9 .and. Month( GetSysDate() ) <= 12
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )
         aAdd( aPeriodo, "Tercer trimestre" )
         aAdd( aPeriodo, "Cuatro trimestre" )

   end case

   aAdd( aPeriodo, "Doce últimos meses" )

   aAdd( aPeriodo, "Año en curso" )

   aAdd( aPeriodo, "Año anterior" )

   aAdd( aPeriodo, "Todos" )

Return ( aPeriodo )

//---------------------------------------------------------------------------//

Static Function lRecargaFecha( oFechaInicio, oFechaFin, cPeriodo )

   do case
      case cPeriodo == "Hoy"

         oFechaInicio:cText( GetSysDate() )
         oFechaFin:cText( GetSysDate() )

      case cPeriodo == "Ayer"

         oFechaInicio:cText( GetSysDate() -1 )
         oFechaFin:cText( GetSysDate() -1 )

      case cPeriodo == "Mes en curso"

         oFechaInicio:cText( CtoD( "01/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( GetSysDate() )

      case cPeriodo == "Mes anterior"

         oFechaInicio:cText( BoM( AddMonth( GetSysDate(), -1 ) ) )
         oFechaFin:cText( EoM( AddMonth( GetSysDate(), -1 ) ) )

      case cPeriodo == "Primer trimestre"
         
         oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "31/03/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Segundo trimestre"

         oFechaInicio:cText( CtoD( "01/04/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "30/06/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Tercer trimestre"

         oFechaInicio:cText( CtoD( "01/07/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "30/09/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Cuatro trimestre"

         oFechaInicio:cText( CtoD( "01/10/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Doce últimos meses"

         oFechaInicio:cText( CtoD( Str( Day( GetSysDate() ) ) + "/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) -1 ) ) )
         oFechaFin:cText( GetSysDate() )

      case cPeriodo == "Año en curso"

         oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Año anterior"

         oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) - 1 ) ) )
         oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) - 1 ) ) )
      
      case cPeriodo == "Todos"

         oFechaInicio:cText( CtoD( "01/01/2000" ) ) 
         oFechaFin:cText( CtoD( "31/12/3000" ) )

   end case

   oFechaInicio:Refresh()
   oFechaFin:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

Static Function LoadPageClient( cCodigoCliente )

   local cExpHead    := ""

   do case
      case oEstadoCli:nAt == 1

         ( D():Get( "FacCliP", nView ) )->( dbSetFilter( {|| !Field->lCobrado .and. Field->dFecVto >= dFecIniCli .and. Field->dFecVto <= dFecFinCli },;
                                             '!lCobrado .and. dFecVto >= Ctod( "' + Dtoc( dFecIniCli ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinCli ) + '" )' ) )

      case oEstadoCli:nAt == 2

         ( D():Get( "FacCliP", nView ) )->( dbSetFilter( {|| Field->lCobrado .and. Field->dFecVto >= dFecIniCli .and. Field->dFecVto <= dFecFinCli },;
                                             'lCobrado .and. dFecVto >= Ctod( "' + Dtoc( dFecIniCli ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinCli ) + '" )' ) )

      case oEstadoCli:nAt == 3
         ( D():Get( "FacCliP", nView ) )->( dbSetFilter( {|| Field->dFecVto >= dFecIniCli .and. Field->dFecVto <= dFecFinCli },;
                                             'dFecVto >= Ctod( "' + Dtoc( dFecIniCli ) + '" ) .and. dFecVto <= Ctod( "' + Dtoc( dFecFinCli ) + '" )' ) )
   end case

   ( D():Get( "FacCliP", nView ) )->( dbGoTop() )

   // Refrescamos los browse------------------------------------------------------

   if !Empty( oBrwRecCli )
      oBrwRecCli:Refresh()
   end if

return .t.

//---------------------------------------------------------------------------//

/*
Cambiamos el valor del Campo definido
*/

Static Function ChangeCampoDef( oCol, uNewValue, nKey, aTmp, nValue, oBrw )

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )
      aTmp[ nValue ]    := uNewValue
   end if

   if !Empty( oBrw )
      oBrw:Refresh()
   end if   

Return .t.

//---------------------------------------------------------------------------//

FUNCTION GridBrwClient( uGet, uGetName, lBigStyle )

   local oDlg
   local oBrw
   local oSayGeneral
   local oBtnAceptar
   local oBtnCancelar
   local oGetSearch
   local cGetSearch  := Space( 100 )
   local cTxtOrigen  := if( !empty( uGet ), uGet:VarGet(), )
   local nOrdAnt     := GetBrwOpt( "BrwGridClient" )
   local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre", "NIF/CIF", "Población", "Provincia", "Código postal", "Teléfono", "Establecimiento", "Correo electrónico" }
   local cCbxOrd
   local nLevel      := nLevelUsr( "01032" )
   local oBtnAdd
   local oBtnEdt
   local oBtnUp
   local oBtnDown
   local oBtnUpPage
   local oBtnDownPage

   nOrdAnt           := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrdAnt ]

   DEFAULT lBigStyle := .f.

   if !OpenFiles( .t. )
      Return nil
   end if

   /*
   Origen de busqueda----------------------------------------------------------
   */

   if !Empty( cTxtOrigen ) .and. !( D():Get( "Client", nView ) )->( dbSeek( cTxtOrigen ) )
      ( D():Get( "Client", nView ) )->( OrdSetFocus( nOrdAnt ) )
      ( D():Get( "Client", nView ) )->( dbGoTop() )
   else
      ( D():Get( "Client", nView ) )->( OrdSetFocus( nOrdAnt ) )
   end if

   /*
   Distintas cajas de dialogo--------------------------------------------------
   */

   oDlg           := TDialog():New( 1, 5, 40, 100, "Buscar clientes",,, .f., nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ),, rgb(255,255,255),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   oSayGeneral    := TGridSay():Build(    {     "nRow"      => 0,;
                                                "nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                                                "bText"     => {|| "Buscar clientes" },;
                                                "oWnd"      => oDlg,;
                                                "oFont"     => oGridFontBold(),;
                                                "lPixels"   => .t.,;
                                                "nClrText"  => Rgb( 0, 0, 0 ),;
                                                "nClrBack"  => Rgb( 255, 255, 255 ),;
                                                "nWidth"    => {|| GridWidth( 7, oDlg ) },;
                                                "nHeight"   => 32,;
                                                "lDesign"   => .f. } )

   oBtnAceptar    := TGridImage():Build(  {     "nTop"      => 5,;
                                                "nLeft"     => {|| GridWidth( 10.5, oDlg ) },;
                                                "nWidth"    => 32,;
                                                "nHeight"   => 32,;
                                                "cResName"  => "flat_check_64",;
                                                "bLClicked" => {|| oDlg:End( IDOK ) },;
                                                "oWnd"      => oDlg } )

   oBtnCancelar   := TGridImage():Build(  {     "nTop"      => 5,;
                                                "nLeft"     => {|| GridWidth( 9.0, oDlg ) },;
                                                "nWidth"    => 32,;
                                                "nHeight"   => 32,;
                                                "cResName"  => "flat_del_64",;
                                                "bLClicked" => {|| oDlg:End() },;
                                                "oWnd"      => oDlg } )

   // Texto de busqueda--------------------------------------------------------

   oGetSearch     := TGridGet():Build(    {     "nRow"      => 45,;
                                                "nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                                                "bSetGet"   => {|u| if( PCount() == 0, cGetSearch, cGetSearch := u ) },;
                                                "oWnd"      => oDlg,;
                                                "nWidth"    => {|| GridWidth( 9, oDlg ) },;
                                                "nHeight"   => 25,;
                                                "bValid"    => {|| OrdClearScope( oBrw, ( D():Get( "Client", nView ) ) ) },;
                                                "bChanged"  => {| nKey, nFlags, Self | AutoSeek( nKey, nFlags, Self, oBrw, ( D():Get( "Client", nView ) ), .t. ) } } )

   oCbxOrd        := TGridComboBox():Build(  {  "nRow"      => 45,;
                                                "nCol"      => {|| GridWidth( 9.5, oDlg ) },;
                                                "bSetGet"   => {|u| if( PCount() == 0, cCbxOrd, cCbxOrd := u ) },;
                                                "oWnd"      => oDlg,;
                                                "nWidth"    => {|| GridWidth( 2, oDlg ) },;
                                                "nHeight"   => 25,;
                                                "aItems"    => aCbxOrd,;
                                                "bChange"   => {|| ( D():Get( "Client", nView ) )->( OrdSetFocus( oCbxOrd:nAt ) ), oGetSearch:SetFocus(), oBrw:Refresh() } } )

   oBtnAdd        := TGridImage():Build(  {     "nTop"      => 75,;
                                                "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                                                "nWidth"    => 64,;
                                                "nHeight"   => 64,;
                                                "cResName"  => "flat_add_64",;
                                                "bLClicked" => {|| nil },;
                                                "bWhen"     => {|| .f. },;
                                                "oWnd"      => oDlg } )

   oBtnEdt           := TGridImage():Build(  {  "nTop"      => 75,;
                                                "nLeft"     => {|| GridWidth( 2, oDlg ) },;
                                                "nWidth"    => 64,;
                                                "nHeight"   => 64,;
                                                "cResName"  => "flat_edit_64",;
                                                "bLClicked" => {|| nil },;
                                                "bWhen"     => {|| .f. },;
                                                "oWnd"      => oDlg } )

   oBtnUpPage        := TGridImage():Build(  {  "nTop"      => 75,;
                                                "nLeft"     => {|| GridWidth( 7.5, oDlg ) },;
                                                "nWidth"    => 64,;
                                                "nHeight"   => 64,;
                                                "cResName"  => "flat_page_up_64",;
                                                "bLClicked" => {|| oBrw:PageUp(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh()  },;
                                                "oWnd"      => oDlg } )

   oBtnUp            := TGridImage():Build(  {  "nTop"      => 75,;
                                                "nLeft"     => {|| GridWidth( 8.5, oDlg ) },;
                                                "nWidth"    => 64,;
                                                "nHeight"   => 64,;
                                                "cResName"  => "flat_up_64",;
                                                "bLClicked" => {|| oBrw:GoUp(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh()  },;
                                                "oWnd"      => oDlg } )

   oBtnDown          := TGridImage():Build(  {  "nTop"      => 75,;
                                                "nLeft"     => {|| GridWidth( 9.5, oDlg ) },;
                                                "nWidth"    => 64,;
                                                "nHeight"   => 64,;
                                                "cResName"  => "flat_down_64",;
                                                "bLClicked" => {|| oBrw:GoDown(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh() },;
                                                "oWnd"      => oDlg } )

   oBtnDownPage      := TGridImage():Build(  {  "nTop"      => 75,;
                                                "nLeft"     => {|| GridWidth( 10.5, oDlg ) },;
                                                "nWidth"    => 64,;
                                                "nHeight"   => 64,;
                                                "cResName"  => "flat_page_down_64",;
                                                "bLClicked" => {|| oBrw:PageDown(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh() },;
                                                "oWnd"      => oDlg } )

   // Browse de clientes ------------------------------------------------------

   oBrw                 := TGridIXBrowse():New( oDlg )

   oBrw:nTop            := oBrw:EvalRow( 115 )
   oBrw:nLeft           := oBrw:EvalCol( {|| GridWidth( 0.5, oDlg ) } )
   oBrw:nWidth          := oBrw:EvalWidth( {|| GridWidth( 11, oDlg ) } )
   oBrw:nHeight         := oBrw:EvalHeight( {|| GridHeigth( oDlg ) - oBrw:nTop - 10 } )

   oBrw:cAlias          := ( D():Get( "Client", nView ) )
   oBrw:nMarqueeStyle   := 5
   oBrw:cName           := "BrwGridClient"

   with object ( oBrw:AddCol() )
      :cHeader          := "Código"
      :cSortOrder       := "Cod"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->Cod }
      :nWidth           := 120
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Nombre"
      :cSortOrder       := "Titulo"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->Titulo }
      :nWidth           := 420
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "NIF/CIF"
      :cSortOrder       := "Nif"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->Nif }
      :nWidth           := 180
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Teléfono"
      :cSortOrder       := "Telefono"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->Telefono }
      :nWidth           := 180
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Fax"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->Fax }
      :nWidth           := 180
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Domicilio"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->Domicilio }
      :nWidth           := 400
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Población"
      :cSortOrder       := "Poblacion"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->Poblacion }
      :nWidth           := 300
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Código postal"
      :cSortOrder       := "CodPostal"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->CodPostal }
      :nWidth           := 140
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Provincia"
      :cSortOrder       := "Provincia"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->Provincia }
      :nWidth           := 200
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Establecimiento"
      :cSortOrder       := "NbrEst"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->NbrEst }
      :nWidth           := 280
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Correo electrónico"
      :cSortOrder       := "cMeiInt"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->cMeiInt }
      :nWidth           := 180
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Riesgo"
      :bEditValue       := {|| Trans( ( D():Get( "Client", nView ) )->nImpRie, PicOut() ) }
      :nWidth           := 180
      :nDataStrAlign    := AL_RIGHT
      :nHeadStrAlign    := AL_RIGHT
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Contacto"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->cPerCto }
      :nWidth           := 300
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Observaciones"
      :bEditValue       := {|| ( D():Get( "Client", nView ) )->mComent }
      :nWidth           := 400
   end with

   oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
   oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }
   
   oBrw:nHeaderHeight   := 40
   oBrw:nFooterHeight   := 40
   oBrw:nRowHeight      := 40

   oBrw:CreateFromCode( 105 )

   // Dialogo------------------------------------------------------------------

   oDlg:bResized        := {|| GridResize( oDlg ) }
   oDlg:bStart          := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER ON INIT ( GridMaximize( oDlg ) ) 

   if oDlg:nResult == IDOK

      if IsObject( uGet )
         uGet:cText( ( D():Get( "Client", nView ) )->Cod )
         uGet:lValid()
      else
         uGet  := ( D():Get( "Client", nView ) )->Cod
      end if

      if IsObject( uGetName ) 
         uGetName:cText( ( D():Get( "Client", nView ) )->Titulo )
      end if

   end if

   DestroyFastFilter( D():Get( "Client", nView ) )

   SetBrwOpt( "BrwGridClient", ( D():Get( "Client", nView ) )->( OrdNumber() ) )

   CloseFiles()

   if IsObject( uGet ) 
      uGet:setFocus()
   end if

   oBtnAceptar:end()
   oBtnCancelar:end()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
