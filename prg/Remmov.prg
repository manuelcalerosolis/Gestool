#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "FastRepH.ch"

#define IDFOUND            3
#define _MENUITEM_         "01050"

memvar oDbf
memvar cDbf
memvar cDbfCol
memvar oDbfCol
memvar cDbfAlm
memvar cDbfPro
memvar cDbfFam
memvar cDbfMov
memvar cDbfArt
memvar cDbfAge
memvar oThis
memvar cPouDivRem
memvar cPorDivRem
memvar nPagina
memvar lEnd
memvar nTotMov

static oRemesas
static oMenu

static cTmpLin
static dbfTmpLin

static dbfRemMov
static dbfHisMov
static dbfTMov
static dbfAlm
static dbfAge
static dbfArticulo
static dbfCount
static dbfPro
static dbfTblPro
static dbfAlbCliT
static dbfAlbCliL
static dbfFacCliT
static dbfFacCliL

//---------------------------------------------------------------------------//

CLASS TRemMovAlm FROM TMasDet

   DATA  oArt
   DATA  oArtKit
   DATA  oUsr
   DATA  oDbfDoc
   DATA  oDbfCnt
   DATA  oDelega
   DATA  aCal
   DATA  cMru              INIT  "Pencil_Package_16"
   DATA  cBitmap           INIT  Rgb( 128, 57, 123 )
   DATA  oAlm
   DATA  oFam
   DATA  oTipArt
   DATA  oPro
   DATA  oTblPro
   DATA  oArtCom
   DATA  oTMov
   DATA  oStock

   DATA  oPedPrvT
   DATA  oPedPrvL
   DATA  oAlbPrvT
   DATA  oAlbPrvL
   DATA  oAlbPrvS
   DATA  oFacPrvT
   DATA  oFacPrvL
   DATA  oFacPrvS
   DATA  oRctPrvT
   DATA  oRctPrvL
   DATA  oRctPrvS
   DATA  oPedCliT
   DATA  oPedCliL
   DATA  oPedCliR
   DATA  oAlbCliT
   DATA  oAlbCliL
   DATA  oAlbCliS
   DATA  oFacCliT
   DATA  oFacCliL
   DATA  oFacCliS
   DATA  oFacRecT
   DATA  oFacRecL
   DATA  oFacRecS
   DATA  oTikCliT
   DATA  oTikCliL
   DATA  oTikCliS
   DATA  oHisMov
   DATA  oHisMovS
   DATA  oDbfAge
   DATA  oDbfBar
   DATA  oDbfEmp

   DATA  oAlmOrg
   DATA  oAlmDes
   DATA  oCodMov
   DATA  oFecRem
   DATA  oSufRem
   DATA  oNumRem

   DATA  oCodAge

   DATA  oDbfProLin
   DATA  oDbfProMat
   DATA  oDbfProSer
   DATA  oDbfMatSer

   DATA  cText
   DATA  oSender
   DATA  lSelectSend
   DATA  lSelectRecive
   DATA  cIniFile
   DATA  lSuccesfullSend

   DATA  lReclculado          INIT .f.

   DATA  nNumberSend          INIT  0
   DATA  nNumberRecive        INIT  0

   DATA  oDlgImport
   DATA  lFamilia             INIT  .t.
   DATA  oFamiliaInicio
   DATA  cFamiliaInicio
   DATA  oFamiliaFin
   DATA  cFamiliaFin

   DATA  lArticulo            INIT  .t.
   DATA  oArticuloInicio
   DATA  cArticuloInicio
   DATA  oArticuloFin
   DATA  cArticuloFin

   DATA  lTipoArticulo        INIT  .t.
   DATA  oTipoArticuloInicio
   DATA  cTipoArticuloInicio
   DATA  oTipoArticuloFin
   DATA  cTipoArticuloFin

   DATA  oMtrStock
   DATA  nMtrStock

   DATA  oMeter
   DATA  nMeter

   DATA  oRadTipoMovimiento

   DATA  lOpenFiles         INIT  .f.

   DATA  oBtnKit

   DATA  oDetMovimientos
   DATA  oDetSeriesMovimientos

   Method New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR

   Method Initiate( cText, oSender )            CONSTRUCTOR

   Method OpenFiles( lExclusive )
   Method CloseFiles()

   Method OpenService( lExclusive )
   Method CloseService()
   Method CloseIndex()

   Method Reindexa( oMeter )

   Method GetNewCount()

   Method DefineFiles()
   Method DefineCalculate()

   Method Resource( nMode )
   Method Activate()

   Method AppendDet( oDlg )
   Method EditDet( oDlg )
   Method DeleteDet( oDlg )

   Method lSave()

   Method ShwAlm( oSay, oBtnImp )

   Method nTotRemMov( lPic )

   Method Search()

   Method lSelAll( lSel )

   Method lSelAllMov( lSel )  VIRTUAL
   Method lSelMov()

   METHOD lSelAllDoc( lSel )
   Method lSelDoc()

   Method cTextoMovimiento()  INLINE   { "Entre almacenes", "Regularización", "Objetivos", "Consolidación" }[ Min( Max( ( ::oDbf:nArea )->nTipMov, 1 ), 4 ) ]

   Method CheckFiles()

   Method LoadAlmacen( nMode )
   Method ImportAlmacen( nMode, oDlg )

   Method nClrText()

   Method ShowKit( lSet )

   Method DataReport( oFr )
   Method VariableReport( oFr )
   Method DesignReportRemMov( oFr, dbfDoc )
   Method PrintReportRemMov( nDevice, nCopies, cPrinter, dbfDoc )

   Method GenRemMov( lPrinter, cCaption, cCodDoc, cPrinter )
   METHOD bGenRemMov( lImprimir, cTitle, cCodDoc )
   METHOD lGenRemMov( oBrw, oBtn, lImp )
   Method EPage( oInf, cCodDoc )

   Method Save()
   Method Load()

   Method nGetNumberToSend()
   Method SetNumberToSend()   INLINE   WritePProString( "Numero", ::cText, cValToChar( ::nNumberSend ), ::cIniFile )
   Method IncNumberToSend()   INLINE   WritePProString( "Numero", ::cText, cValToChar( ++::nNumberSend ), ::cIniFile )

   Method CreateData()
   Method RestoreData()
   Method SendData()
   Method ReciveData()
   Method Process()

   Method cMostrarSerie() 

   Method Report()            INLINE   TInfRemMov():New( "Remesas de movimientos", , , , , , { ::oDbf, ::oDetMovimientos:oDbf, ::oArt } ):Play()

   Method ActualizaStockWeb( cNumDoc )

   METHOD GenerarEtiquetas()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := oWnd()
   DEFAULT oMenuItem       := "01050"

   ::nLevel                := nLevelUsr( oMenuItem )

   ::cPath                 := cPath
   ::oWndParent            := oWndParent
   ::oDbf                  := nil

   ::lAutoActions          := .f.

   ::cNumDocKey            := "nNumRem"
   ::cSufDocKey            := "cSufRem"

   ::cPicUnd               := MasUnd()

   ::bFirstKey             := {|| Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem }
   ::bWhile                := {|| Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDetMovimientos:oDbf:nNumRem, 9 ) + ::oDetMovimientos:oDbf:cSufRem .and. !::oDetMovimientos:oDbf:Eof() }

   ::oDetMovimientos       := TDetMovimientos():New( cPath, Self )
   ::AddDetail( ::oDetMovimientos )

   ::oDetSeriesMovimientos := TDetSeriesMovimientos():New( cPath, Self )
   ::AddDetail( ::oDetSeriesMovimientos )

   ::oDetSeriesMovimientos:bOnPreSaveDetail  := {|| ::oDetSeriesMovimientos:SaveDetails() }

   ::bOnPostAppend         := {|| ::ActualizaStockWeb( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem ) }
   ::bOnPostEdit           := {|| ::ActualizaStockWeb( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem ) }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Initiate( cText, oSender )

   ::cText              := cText
   ::oSender            := oSender
   ::cIniFile           := cPatEmp() + "Empresa.Ini"
   ::lSuccesfullSend    := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD GetNewCount()

   ::oDbf:nNumRem    := nNewDoc( nil, ::oDbf:nArea, "nMovAlm", nil, ::oDbfCnt:nArea )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "REMMOVT.DBF" CLASS "TRemMovT" ALIAS "RemMovT" PATH ( cPath ) VIA ( cDriver ) COMMENT "Movimientos de almacén"

      FIELD NAME "lSelDoc"             TYPE "L" LEN  1  DEC 0                                                                                COMMENT ""                                HIDE  OF ::oDbf
      FIELD CALCULATE NAME "Send16"             LEN  1  DEC 0                             VAL {|| ::oDbf:lSelDoc } BITMAPS "Sel16", "Nil16"  COMMENT { "Enviar", "Lbl16" , 3 } COLSIZE 20    OF ::oDbf
      FIELD NAME "nNumRem"             TYPE "N" LEN  9  DEC 0 PICTURE "999999999"         DEFAULT  0                                         COMMENT "Número"           COLSIZE 80           OF ::oDbf
      FIELD NAME "cSufRem"             TYPE "C" LEN  2  DEC 0 PICTURE "@!"                DEFAULT  RetSufEmp()                               COMMENT "Delegación"       COLSIZE 40           OF ::oDbf
      FIELD NAME "nTipMov"             TYPE "N" LEN  1  DEC 0                                                                                COMMENT "Tipo del movimiento"             HIDE  OF ::oDbf
      FIELD CALCULATE NAME "cTipMov"            LEN 12  DEC 0                             VAL ( ::cTextoMovimiento() )                       COMMENT "Tipo"             COLSIZE 90           OF ::oDbf
      FIELD NAME "cCodUsr"             TYPE "C" LEN  3  DEC 0                             DEFAULT  cCurUsr()                                 COMMENT "Código usuario"                  HIDE  OF ::oDbf
      FIELD NAME "cCodDlg"             TYPE "C" LEN  2  DEC 0                                                                                COMMENT ""                                HIDE  OF ::oDbf
      FIELD NAME "cCodAge"             TYPE "C" LEN  3  DEC 0                                                                                COMMENT "Código agente"                   HIDE  OF ::oDbf
      FIELD NAME "cCodMov"             TYPE "C" LEN  2  DEC 0                                                                                COMMENT "Tipo de movimiento"              HIDE  OF ::oDbf
      FIELD NAME "dFecRem"             TYPE "D" LEN  8  DEC 0                             DEFAULT  Date()                                    COMMENT "Fecha"            COLSIZE 80           OF ::oDbf
      FIELD NAME "cTimRem"             TYPE "C" LEN  5  DEC 0                             DEFAULT  Time()                                    COMMENT "Hora"                            HIDE  OF ::oDbf
      FIELD NAME "cAlmOrg"             TYPE "C" LEN 16  DEC 0 PICTURE "@!"                                                                   COMMENT "Alm. org."        COLSIZE 60           OF ::oDbf
      FIELD CALCULATE NAME "cNomAlmOrg"         LEN 20  DEC 0 PICTURE "@!"                VAL ( oRetFld( ( ::oDbf:nArea )->cAlmOrg, ::oAlm, "cNomAlm" ) )                              HIDE  OF ::oDbf
      FIELD NAME "cAlmDes"             TYPE "C" LEN 16  DEC 0 PICTURE "@!"                                                                   COMMENT "Alm. des."        COLSIZE 60           OF ::oDbf
      FIELD CALCULATE NAME "cNomAlmDes"         LEN 20  DEC 0 PICTURE "@!"                VAL ( oRetFld( ( ::oDbf:nArea )->cAlmDes, ::oAlm, "cNomAlm" ) )                              HIDE  OF ::oDbf
      FIELD NAME "cCodDiv"             TYPE "C" LEN  3  DEC 0 PICTURE "@!"                HIDE                                               COMMENT "Div."                                  OF ::oDbf
      FIELD NAME "nVdvDiv"             TYPE "N" LEN 13  DEC 6 PICTURE "@E 999,999.999999" HIDE                                               COMMENT "Cambio de la divisa"                   OF ::oDbf
      FIELD NAME "cComMov"             TYPE "C" LEN 100 DEC 0 PICTURE "@!"                                                                   COMMENT "Comentario"       COLSIZE 240          OF ::oDbf
      FIELD NAME "nTotRem"             TYPE "N" LEN 16  DEC 6 PICTURE "@E 999,999,999,999.99"   ALIGN RIGHT                                  COMMENT "Importe"          COLSIZE 100          OF ::oDbf

      INDEX TO "RemMovT.Cdx" TAG "cNumRem" ON "Str( nNumRem ) + cSufRem"   COMMENT "Número"  NODELETED OF ::oDbf
      INDEX TO "RemMovT.Cdx" TAG "dFecRem" ON "Dtos( dFecRem ) + cTimRem"  COMMENT "Fecha"   NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//
// Campos calculados
//

Method DefineCalculate()

   ::aCal  := {}

   aAdd( ::aCal, { "( RetFld( ( cDbfCol )->cRefMov, cDbfArt, 'Nombre' ) )",   "C",100, 0, "Nombre artículo",  "",             "" } )
   aAdd( ::aCal, { "nTotNMovAlm( oDbfCol )",                                  "N", 16, 6, "Total unidades",   "cPorDivRem",   "" } )
   aAdd( ::aCal, { "nTotLMovAlm( oDbfCol )",                                  "N", 16, 6, "Total importe",    "cPorDivRem",   "" } )

RETURN ( ::aCal )

//---------------------------------------------------------------------------//

METHOD Activate()

   local oSnd
   local oDel
   local oImp
   local oPrv

   if nAnd( ::nLevel, 1 ) == 0

      /*
      Cerramos todas las ventanas----------------------------------------------
      */

      if ::oWndParent != nil
         ::oWndParent:CloseAll()
      end if

      ::CreateShell( ::nLevel )

      // ::oWndBrw:oBrw:bDup  := nil

      DEFINE BTNSHELL RESOURCE "BUS" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B";

         ::oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecAdd() );
         ON DROP  ( ::oWndBrw:RecAdd() );
         TOOLTIP  "(A)ñadir";
         BEGIN GROUP ;
         HOTKEY   "A" ;
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "DUP" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecDup() );
         TOOLTIP  "(D)uplicar";
         HOTKEY   "D" ;
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "EDIT" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecZoom() );
         TOOLTIP  "(Z)oom";
         HOTKEY   "Z" ;
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL oDel RESOURCE "DEL" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

         DEFINE BTNSHELL RESOURCE "DEL" OF ::oWndBrw ;
            NOBORDER ;
            ACTION   ( ::Del( .t., .f. ), ::oWndBrw:Refresh() );
            TOOLTIP  "Solo cabecera" ;
            FROM     oDel ;
            CLOSED ;
            LEVEL    ACC_DELE

         DEFINE BTNSHELL RESOURCE "DEL" OF ::oWndBrw ;
            NOBORDER ;
            ACTION   ( ::Del( .f., .t. ), ::oWndBrw:Refresh() );
            TOOLTIP  "Solo detalle" ;
            FROM     oDel ;
            CLOSED ;
            LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "IMP" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::Report() ) ;
         TOOLTIP  "(L)istado" ;
         HOTKEY   "L" ;
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL oImp RESOURCE "IMP" OF ::oWndBrw ;
         ACTION   ( ::GenRemMov( .t. ) ) ;
			TOOLTIP 	"(I)mprimir";
         HOTKEY   "I";
         LEVEL    ACC_IMPR

      ::lGenRemMov( ::oWndBrw:oBrw, oImp, .t. )

      DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF ::oWndBrw ;
         ACTION   ( ::GenRemMov( .f. ) ) ;
         TOOLTIP  "(P)revisualizar";
         HOTKEY   "P";
         LEVEL    ACC_IMPR

      ::lGenRemMov( ::oWndBrw:oBrw, oPrv, .f. )

      DEFINE BTNSHELL RESOURCE "RemoteControl_" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::GenerarEtiquetas() ) ;
         TOOLTIP  "Eti(q)uetas" ;
         HOTKEY   "Q";
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL oSnd RESOURCE "LBL" OF ::oWndBrw ;
         ACTION   ( ::lSelMov(), ::oWndBrw:Refresh() );
         MENU     This:Toggle() ;
         TOOLTIP  "En(v)iar" ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "LBL" OF ::oWndBrw ;
            NOBORDER ;
            ACTION   ( ::lSelAll( .t. ) );
            TOOLTIP  "Todos" ;
            FROM     oSnd ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "LBL" OF ::oWndBrw ;
            NOBORDER ;
            ACTION   ( ::lSelAll( .f. ) );
            TOOLTIP  "Ninguno" ;
            FROM     oSnd ;
            LEVEL    ACC_EDIT

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

   else

      msgStop( "Acceso no permitido." )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local oError
   local oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive         := .f.

   BEGIN SEQUENCE

   if !::lOpenFiles

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::OpenDetails()

      DATABASE NEW ::oDelega     PATH ( cPatDat() ) FILE "Delega.Dbf"      VIA ( cDriver() ) SHARED INDEX "Delega.Cdx"

      DATABASE NEW ::oUsr        PATH ( cPatDat() ) FILE "Users.Dbf"       VIA ( cDriver() ) SHARED INDEX "Users.Cdx"

      DATABASE NEW ::oTMov       PATH ( cPatDat() ) FILE "TMOV.DBF"        VIA ( cDriver() ) SHARED INDEX "TMov.Cdx"

      DATABASE NEW ::oAlm        FILE "ALMACEN.DBF"   ALIAS "ALMACEN"   PATH ( cPatAlm() )   VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

      DATABASE NEW ::oArtCom     FILE "ARTDIV.DBF"    ALIAS "ARTDIV"    PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "ARTDIV.CDX"

      DATABASE NEW ::oPro        FILE "PRO.DBF"       ALIAS "PRO"       PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "PRO.CDX"

      DATABASE NEW ::oTblPro     FILE "TBLPRO.DBF"    ALIAS "TBLPRO"    PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "TBLPRO.CDX"

      DATABASE NEW ::oFam        FILE "FAMILIAS.DBF"  ALIAS "FAMILIAS"  PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

      DATABASE NEW ::oArt        FILE "ARTICULO.DBF"  ALIAS "ARTICULO"  PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      DATABASE NEW ::oArtKit     FILE "ARTKIT.DBF"    ALIAS "ARTKIT"    PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

      DATABASE NEW ::oDbfAge     FILE "AGENTES.DBF"  PATH ( cPatCli() )   VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"

      DATABASE NEW ::oPedPrvT    FILE "PEDPROVT.DBF" PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "PEDPROVT.CDX"

      DATABASE NEW ::oPedPrvL    FILE "PEDPROVL.DBF" PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"
      ::oPedPrvL:SetOrder( "cRef" )

      DATABASE NEW ::oAlbPrvT    FILE "ALBPROVT.DBF" PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

      DATABASE NEW ::oAlbPrvL    FILE "ALBPROVL.DBF" PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"
      ::oAlbPrvL:SetOrder( "cRef" )

      DATABASE NEW ::oAlbPrvS    FILE "AlbPrvS.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "AlbPrvS.CDX"

      DATABASE NEW ::oFacPrvT    FILE "FACPRVT.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

      DATABASE NEW ::oFacPrvL    FILE "FACPRVL.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"
      ::oFacPrvL:SetOrder( "cRef" )

      DATABASE NEW ::oFacPrvS    FILE "FACPRVS.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "FACPRVS.CDX"

      DATABASE NEW ::oRctPrvT    FILE "RctPrvT.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "RctPrvT.CDX"

      DATABASE NEW ::oRctPrvL    FILE "RctPrvL.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "RctPrvL.CDX"
      ::oRctPrvL:SetOrder( "cRef" )

      DATABASE NEW ::oRctPrvS    FILE "RctPrvS.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "RctPrvS.CDX"

      ::oPedCliT := TDataCenter():oPedCliT()

      DATABASE NEW ::oPedCliL    PATH ( cPatEmp() ) FILE "PedCliL.DBF" VIA ( cDriver() ) SHARED INDEX "PedCliL.CDX"
      ::oPedCliL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oPedCliR    PATH ( cPatEmp() ) FILE "PedCliR.DBF" VIA ( cDriver() ) SHARED INDEX "PedCliR.CDX"

      ::oAlbCliT := TDataCenter():oAlbCliT()

      DATABASE NEW ::oAlbCliL    PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
      ::oAlbCliL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oAlbCliS    PATH ( cPatEmp() ) FILE "ALBCLIS.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIS.CDX"

      ::oFacCliT := TDataCenter():oFacCliT()

      DATABASE NEW ::oFacCliL    PATH ( cPatEmp() ) FILE "FacCliL.DBF" VIA ( cDriver() ) SHARED INDEX "FacCliL.CDX"
      ::oFacCliL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oFacCliS    PATH ( cPatEmp() ) FILE "FacCliS.DBF" VIA ( cDriver() ) SHARED INDEX "FacCliS.CDX"

      DATABASE NEW ::oFacRecT    PATH ( cPatEmp() ) FILE "FacRecT.DBF" VIA ( cDriver() ) SHARED INDEX "FacRecT.CDX"

      DATABASE NEW ::oFacRecL    PATH ( cPatEmp() ) FILE "FacRecL.DBF" VIA ( cDriver() ) SHARED INDEX "FacRecL.CDX"
      ::oFacRecL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oFacRecS    PATH ( cPatEmp() ) FILE "FacRecS.DBF" VIA ( cDriver() ) SHARED INDEX "FacRecS.CDX"

      DATABASE NEW ::oTikCliT    PATH ( cPatEmp() ) FILE "TikeT.DBF" VIA ( cDriver() ) SHARED INDEX "TikeT.CDX"

      DATABASE NEW ::oTikCliL    PATH ( cPatEmp() ) FILE "TikeL.DBF" VIA ( cDriver() ) SHARED INDEX "TikeL.CDX"
      ::oTikCliL:OrdSetFocus( "cCbaTil" )

      DATABASE NEW ::oTikCliS    PATH ( cPatEmp() ) FILE "TikeS.DBF"       VIA ( cDriver() ) SHARED INDEX "TikeS.CDX"

      DATABASE NEW ::oHisMov     PATH ( cPatEmp() ) FILE "HisMov.DBF"      VIA ( cDriver() ) SHARED INDEX "HisMov.CDX"
      ::oHisMov:OrdSetFocus( "cRefMov" )

      DATABASE NEW ::oHisMovS    PATH ( cPatEmp() ) FILE "MovSer.Dbf"      VIA ( cDriver() ) SHARED INDEX "MovSer.Cdx"

      DATABASE NEW ::oDbfBar     PATH ( cPatArt() ) FILE "ArtCodebar.Dbf"  VIA ( cDriver() ) SHARED INDEX "ArtCodebar.Cdx"

      DATABASE NEW ::oDbfDoc     PATH ( cPatEmp() ) FILE "RDocumen.Dbf"    VIA ( cDriver() ) SHARED INDEX "RDocumen.Cdx"
      ::oDbfDoc:OrdSetFocus( "cTipo" )

      DATABASE NEW ::oDbfCnt     PATH ( cPatEmp() ) FILE "nCount.Dbf"      VIA ( cDriver() ) SHARED INDEX "nCount.Cdx"

      DATABASE NEW ::oDbfEmp     PATH ( cPatDat() ) FILE "EMPRESA.DBF"     VIA ( cDriver() ) SHARED INDEX "EMPRESA.CDX"

      DATABASE NEW ::oDbfProLin  PATH ( cPatEmp() ) FILE "PROLIN.DBF"      VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"

      DATABASE NEW ::oDbfProMat  PATH ( cPatEmp() ) FILE "PROMAT.DBF"      VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"

      DATABASE NEW ::oDbfProSer  PATH ( cPatEmp() ) FILE "ProSer.Dbf"      VIA ( cDriver() ) SHARED INDEX "ProSer.Cdx"

      DATABASE NEW ::oDbfMatSer  PATH ( cPatEmp() ) FILE "MatSer.Dbf"      VIA ( cDriver() ) SHARED INDEX "MatSer.Cdx"

      ::oTipArt           := TTipArt():Create( cPatArt() )
      ::oTipArt:OpenFiles()

      ::oStock             := TStock():Create( cPatGrp() )
      if !::oStock:lOpenFiles()
         ::lOpenFiles      := .f.
      end if

      ::lLoadDivisa()

      ::lOpenFiles         := .t.

   end if

   RECOVER USING oError

      ::lOpenFiles         := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !::lOpenFiles
      ::CloseFiles()
   end if

RETURN ( ::lOpenFiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::CloseDetails()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if ::oAlm != nil .and. ::oAlm:Used()
      ::oAlm:End()
   end if

   if ::oArt != nil .and. ::oArt:Used()
      ::oArt:End()
   end if

   if ::oArtKit != nil .and. ::oArtKit:Used()
      ::oArtKit:End()
   end if

   if ::oFam != nil .and. ::oFam:Used()
      ::oFam:End()
   end if

   if ::oPro != nil .and. ::oPro:Used()
      ::oPro:End()
   end if

   if ::oTblPro != nil .and. ::oTblPro:Used()
      ::oTblPro:End()
   end if

   if ::oArtCom != nil .and. ::oArtCom:Used()
      ::oArtCom:End()
   end if

   if ::oTMov != nil .and. ::oTMov:Used()
      ::oTMov:End()
   end if

   if ::oPedPrvT != nil .and. ::oPedPrvT:Used()
      ::oPedPrvT:End()
   end if

   if ::oPedPrvL != nil .and. ::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if

   if ::oAlbPrvT != nil .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if

   if ::oAlbPrvL != nil .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if ::oAlbPrvS != nil .and. ::oAlbPrvS:Used()
      ::oAlbPrvS:End()
   end if

   if ::oFacPrvT != nil .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if ::oFacPrvL != nil .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if ::oFacPrvS != nil .and. ::oFacPrvS:Used()
      ::oFacPrvS:End()
   end if

   if ::oRctPrvT != nil .and. ::oRctPrvT:Used()
      ::oRctPrvT:End()
   end if

   if ::oRctPrvL != nil .and. ::oRctPrvL:Used()
      ::oRctPrvL:End()
   end if

   if ::oRctPrvS != nil .and. ::oRctPrvS:Used()
      ::oRctPrvS:End()
   end if

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if

   if !Empty( ::oPedCliR ) .and. ::oPedCliR:Used()
      ::oPedCliR:End()
   end if

   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oAlbCliS ) .and. ::oAlbCliS:Used()
      ::oAlbCliS:End()
   end if

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oFacCliS ) .and. ::oFacCliS:Used()
      ::oFacCliS:End()
   end if

   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if

   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if

   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if !Empty( ::oTikCliS ) .and. ::oTikCliS:Used()
      ::oTikCliS:End()
   end if

   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

   if ::oStock != nil
      ::oStock:End()
   end if

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   if ::oDbfAge != nil .and. ::oDbfAge:Used()
      ::oDbfAge:End()
   end if

   if ::oDbfBar != nil .and. ::oDbfBar:Used()
      ::oDbfBar:End()
   end if

   if ::oDelega != nil .and. ::oDelega:Used()
      ::oDelega:End()
   end if

   if ::oUsr != nil .and. ::oUsr:Used()
      ::oUsr:End()
   end if

   if ::oDbfDoc != nil .and. ::oDbfDoc:Used()
      ::oDbfDoc:End()
   end if

   if ::oDbfCnt != nil .and. ::oDbfCnt:Used()
      ::oDbfCnt:End()
   end if

   if ::oDbfEmp != nil .and. ::oDbfEmp:Used()
      ::oDbfEmp:End()
   end if

   if ::oDbfProLin != nil .and. ::oDbfProLin:Used()
      ::oDbfProLin:End()
   end if

   if ::oDbfProMat != nil .and. ::oDbfProMat:Used()
      ::oDbfProMat:End()
   end if

   if ::oDbfProSer != nil .and. ::oDbfProSer:Used()
      ::oDbfProSer:End()
   end if

   if ::oDbfMatSer != nil .and. ::oDbfMatSer:Used()
      ::oDbfMatSer:End()
   end if

   if ::oBandera != nil
      ::oBandera:End()
   end if

   if !Empty( ::oTipArt )
      ::oTipArt:end()
   end if

   ::oDbf         := nil
   ::oAlm         := nil
   ::oArt         := nil
   ::oArtKit      := nil
   ::oFam         := nil
   ::oPro         := nil
   ::oTblPro      := nil
   ::oArtCom      := nil
   ::oTMov        := nil
   ::oStock       := nil
   ::oAlbPrvT     := nil
   ::oAlbPrvL     := nil
   ::oAlbPrvS     := nil
   ::oFacPrvT     := nil
   ::oRctPrvT     := nil
   ::oRctPrvL     := nil
   ::oPedCliT     := nil
   ::oPedCliL     := nil
   ::oPedCliR     := nil
   ::oAlbCliT     := nil
   ::oAlbCliL     := nil
   ::oFacCliT     := nil
   ::oFacCliL     := nil
   ::oTikCliT     := nil
   ::oTikCliL     := nil
   ::oHisMov      := nil
   ::oDbfDiv      := nil
   ::oDbfAge      := nil
   ::oDbfBar      := nil
   ::oDbfDoc      := nil
   ::oTipArt      := nil
   ::oDbfEmp      := nil
   ::oDbfProLin   := nil
   ::oDbfProMat   := nil

   ::oBandera     := nil

   ::lOpenFiles   := .f.

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath


   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::OpenDetails()

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de remesas de movimientos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::CloseDetails()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseIndex()

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:OrdListClear()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oSay        := Array( 7 )
   local cSay        := Array( 7 )
   local oBtnImp
   local oBmpGeneral

   /*
   Ordeno oDbfVir por el numero de linea---------------------------------------
   */

   ::oDetMovimientos:oDbfVir:OrdSetFocus( "nNumLin" )

   if nMode == APPD_MODE
      ::oDbf:lSelDoc := .t.
      ::oDbf:cCodUsr := cCurUsr()
      ::oDbf:cCodDlg := oRetFld( cCurUsr(), ::oUsr, "cCodDlg" )
   end if

   cSay[ 1 ]         := oRetFld( ::oDbf:cAlmOrg, ::oAlm )
   cSay[ 2 ]         := oRetFld( ::oDbf:cAlmDes, ::oAlm )
   cSay[ 3 ]         := oRetFld( ::oDbf:cCodMov, ::oTMov )
   cSay[ 5 ]         := oRetFld( cCodEmp() + ::oDbf:cCodDlg, ::oDelega, "cNomDlg" )
   cSay[ 6 ]         := Rtrim( oRetFld( ::oDbf:cCodAge, ::oDbfAge, 2 ) ) + ", " + Rtrim( oRetFld( ::oDbf:cCodAge, ::oDbfAge, 3 ) )
   cSay[ 7 ]         := oRetFld( ::oDbf:cCodUsr, ::oUsr )

   DEFINE DIALOG oDlg RESOURCE "RemMov" TITLE LblTitle( nMode ) + "movimientos entre almacenes"

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "movimiento_almacen_48_alpha" ;
        TRANSPARENT ;
        OF       oDlg

      REDEFINE GET ::oNumRem VAR ::oDbf:nNumRem ;
			ID 		100 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "nNumRem" ):cPict ;
			OF 		oDlg

      REDEFINE GET ::oSufRem VAR ::oDbf:cSufRem ;
			ID 		110 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "cSufRem" ):cPict ;
         OF       oDlg

      REDEFINE GET ::oFecRem VAR ::oDbf:dFecRem ;
         ID       120 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cCodUsr ;
         ID       220 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET oSay[ 7 ] VAR cSay[ 7 ] ;
         ID       230 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET ::oDbf:cCodDlg ;
         ID       240 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET oSay[ 5 ] VAR cSay[ 5 ] ;
         ID       250 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE RADIO ::oRadTipoMovimiento ;
         VAR      ::oDbf:nTipMov ;
         ID       130, 131, 132, 133 ;
         WHEN     ( nMode == APPD_MODE .and. Empty( ::oDetMovimientos:oDbfVir:OrdKeyCount() ) ) ;
         ON CHANGE( ::ShwAlm( oSay, oBtnImp ) ) ;
         OF       oDlg

      REDEFINE GET ::oCodMov VAR ::oDbf:cCodMov ;
         ID       140 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oCodMov:bValid     := {|| cTMov( ::oCodMov, ::oTMov:cAlias, oSay[ 3 ] ) }
      ::oCodMov:bHelp      := {|| BrwTMov( ::oCodMov, ::oTMov:cAlias, oSay[ 3 ] ) }

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ] UPDATE ;
         ID       141 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE SAY oSay[ 4 ] PROMPT "Almacén origen" ;
         ID       152 ;
         OF       oDlg

      REDEFINE GET ::oAlmOrg VAR ::oDbf:cAlmOrg UPDATE ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oDbf:FieldByName( "cAlmOrg" ):cPict ;
         BITMAP   "LUPA" ;
			OF 		oDlg
      ::oAlmOrg:bValid     := {|| cAlmacen( ::oAlmOrg, ::oAlm:cAlias, oSay[1] ) }
      ::oAlmOrg:bHelp      := {|| BrwAlmacen( ::oAlmOrg, oSay[1] ) }

      REDEFINE GET oSay[ 1 ] VAR cSay[ 1 ] ;
         UPDATE ;
         ID       151 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET ::oAlmDes VAR ::oDbf:cAlmDes UPDATE ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oDbf:FieldByName( "cAlmDes" ):cPict ;
         BITMAP   "LUPA" ;
			OF 		oDlg

      ::oAlmDes:bValid     := {|| cAlmacen( ::oAlmDes, ::oAlm:cAlias, oSay[2] ) }
      ::oAlmDes:bHelp      := {|| BrwAlmacen( ::oAlmDes, oSay[2] ) }

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] UPDATE ;
         ID       161 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      ::oDefDiv( 190, 191, 192, oDlg, nMode )

      REDEFINE GET ::oDbf:cComMov ;
         ID       170 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oCodAge VAR ::oDbf:cCodAge;
         ID       210;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

         ::oCodAge:bValid  := {|| cAgentes( ::oCodAge, ::oDbfAge:cAlias, oSay[ 6 ] ) }
         ::oCodAge:bHelp   := {|| BrwAgentes( ::oCodAge, oSay[ 6 ] ) }

      REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
         ID       211;
         WHEN     .f.;
         OF       oDlg

       /*
       Botones de acceso________________________________________________________________
       */

		REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !Empty( ::oDbf:cAlmDes ) ) ;
         ACTION   ( ::AppendDet( oDlg ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !Empty( ::oDbf:cAlmDes ) ) ;
         ACTION   ( ::EditDet() )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !Empty( ::oDbf:cAlmDes ) ) ;
         ACTION   ( ::DeleteDet() )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::Search() )

      REDEFINE BUTTON ;
         ID       507 ;
         OF       oDlg ;
         WHEN     ( nMode == APPD_MODE ) ;
         ACTION   ( ::lSelDoc() )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oDlg ;
         WHEN     ( nMode == APPD_MODE ) ;
         ACTION   ( ::lSelAll( .t. ) )

      REDEFINE BUTTON ;
         ID       505 ;
         OF       oDlg ;
         WHEN     ( nMode == APPD_MODE ) ;
         ACTION   ( ::lSelAll( .f. ) )

      REDEFINE BUTTON ::oBtnKit ;
         ID       508 ;
         OF       oDlg ;
         ACTION   ( ::ShowKit( .t. ) )

      REDEFINE BUTTON oBtnImp ;
         ID       506 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !Empty( ::oDbf:cAlmDes ) ) ;
         ACTION   ( ::ImportAlmacen( nMode, oDlg ) )

      ::oBrwDet               := IXBrowse():New( oDlg )

      ::oBrwDet:bClrSel       := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwDet:bClrSelFocus  := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwDet:nMarqueeStyle := 6
      ::oBrwDet:lHScroll      := .f.
      ::oBrwDet:lFooter       := .t.
      if nMode != ZOOM_MODE
         ::oBrwDet:bLDblClick := {|| ::EditDet() }
      end if

      ::oBrwDet:cName         := "Detalle movimientos de almacén"

      ::oDetMovimientos:oDbfVir:SetBrowse( ::oBrwDet )

      ::oBrwDet:CreateFromResource( 180 )

      with object ( ::oBrwDet:addCol() )
         :cHeader          := "Se.  Seleccionado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "lSelDoc" ) }
         :nWidth           := 24
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Número"
         :bStrData      := {|| if( ::oDetMovimientos:oDbfVir:FieldGetByName( "lKitEsc" ), "", Trans( ::oDetMovimientos:oDbfVir:FieldGetByName( "nNumLin" ), "@EZ 9999" ) ) }
         :nWidth        := 60
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Código"
         :bStrData      := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "cRefMov" ) }
         :nWidth        := 100
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Nombre"
         :bStrData      := {|| RetArticulo( ::oDetMovimientos:oDbfVir:FieldGetByName( "cRefMov" ), ::oArt:cAlias ) }
         :nWidth        := 300
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Prop. 1"
         :bStrData      := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "cValPr1" ) }
         :nWidth        := 40
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Prop. 2"
         :bStrData      := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "cValPr2" ) }
         :nWidth        := 40
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Lote"
         :bStrData      := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "cLote" ) }
         :nWidth        := 80
         :lHide         := .t.
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Serie"
         :bStrData      := {|| ::cMostrarSerie() }
         :nWidth        := 80
         :lHide         := .t.
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Unidades"
         :bEditValue    := {|| nTotNMovAlm( ::oDetMovimientos:oDbfVir ) }
         :bFooter       := {|| ::oDetMovimientos:nTotUnidadesVir( .t. ) }
         :cEditPicture  := ::cPicUnd
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Unidades ant."
         :bEditValue    := {|| nTotNMovOld( ::oDetMovimientos:oDbfVir ) }
         :cEditPicture  := ::cPicUnd
         :lHide         := .t.
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      
if !oUser():lNotCostos()

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Importe"
         :bEditValue    := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "nPreDiv" ) }
         :cEditPicture  := ::cPinDiv
         :nWidth        := 100
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Total"
         :bEditValue    := {|| nTotLMovAlm( ::oDetMovimientos:oDbfVir ) }
         :bFooter       := {|| ::oDetMovimientos:nTotRemVir( .t. ) }
         :cEditPicture  := ::cPirDiv
         :nWidth        := 100
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
      end with

end if      

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Total peso"
         :bEditValue    := {|| ( nTotNMovAlm( ::oDetMovimientos:oDbfVir ) * ::oDetMovimientos:oDbfVir:nPesoKg ) }
         :bFooter       := {|| ::oDetMovimientos:nTotPesoVir() }
         :cEditPicture  := MasUnd()
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
         :lHide         := .t.
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Total volumen"
         :bEditValue    := {|| ( nTotNMovAlm( ::oDetMovimientos:oDbfVir ) * ::oDetMovimientos:oDbfVir:nVolumen ) }
         :bFooter       := {|| ::oDetMovimientos:nTotVolumenVir() }
         :cEditPicture  := MasUnd()
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :nFootStrAlign := 1
         :lHide         := .t.
      end with

      ::nMeter          := 0
      ::oMeter          := TMeter():ReDefine( 400, { | u | if( pCount() == 0, ::nMeter, ::nMeter := u ) }, 10, oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      REDEFINE BUTTON ;
         ID       511 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lSave( nMode ), ( ::EndResource( .t., nMode, oDlg ), oDlg:End( IDOK ) ), ) )

		REDEFINE BUTTON ;
         ID       510 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:End() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Movimientosalmacen" ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F2, {|| ::AppendDet( oDlg ) } )
         oDlg:AddFastKey( VK_F3, {|| ::EditDet() } )
         oDlg:AddFastKey( VK_F4, {|| ::DeleteDet() } )
         oDlg:AddFastKey( VK_F5, {|| if( ::lSave( nMode ), ( ::EndResource( .t., nMode, oDlg ), oDlg:End( IDOK ) ), ) } )
      end if

      oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Movimientosalmacen" ) } )

      oDlg:bStart := {|| ::ShwAlm( oSay, oBtnImp ), ::ShowKit( .f. ), ::oBrwDet:Load() }

   ACTIVATE DIALOG oDlg CENTER

   oBmpGeneral:End()

   if oDlg:nResult != IDOK
      ::EndResource( .f., nMode )
   end if

   /*
   Guardamos los datos del browse----------------------------------------------
   */

   ::oBrwDet:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD Search()

	local oDlg
	local oIndice
   local cIndice  := "Código"
   local aIndice  := { "Código" }
	local oCadena
   local xCadena  := Space( 100 )
   local nOrdAnt  := ::oDetMovimientos:oDbfVir:OrdSetFocus( "cRefMov" )

   DEFINE DIALOG oDlg RESOURCE "sSearch"

	REDEFINE GET oCadena VAR xCadena ;
      ID       100 ;
      OF       oDlg
      oCadena:bChange   := {| nKey | oCadena:Assign(), ::oDetMovimientos:oDbfVir:Seek( Rtrim( xCadena ) + Chr( nKey ), .t. ), ::oBrwDet:Refresh() }

	REDEFINE COMBOBOX oIndice VAR cIndice ;
      ITEMS    aIndice ;
      ID       101 ;
      ON CHANGE( oCadena:SetFocus(), oCadena:SelectAll() ) ;
		OF 		oDlg

	REDEFINE BUTTON ;
		ID 		510 ;
		OF 		oDlg ;
      ACTION   ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

   ::oDetMovimientos:oDbfVir:OrdSetFocus( nOrdAnt )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD lSave( nMode )

   if Empty( ::oDbf:cCodAge ) .and. lRecogerAgentes()
      MsgStop( "Código de agente no puede estar vacío." )
      ::oCodAge:SetFocus()
      Return .f.
   end if

   if ::oDbf:nTipMov == 1

      if Empty( ::oDbf:cAlmOrg )
         MsgStop( "Almacén origen no puede estar vacío." )
         ::oAlmOrg:SetFocus()
         Return .f.
      end if

      if ::oDbf:cAlmDes == ::oDbf:cAlmOrg
         MsgStop( "Almacén origen y destino no pueden ser iguales." )
         ::oAlmOrg:SetFocus()
         Return .f.
      end if

   else

      if Empty( ::oDbf:cAlmDes )
         MsgStop( "Almacén destino no puede estar vacío." )
         ::oAlmDes:SetFocus()
         Return .f.
      end if

   end if

   if !::oDetMovimientos:oDbfVir:LastRec() > 0
      MsgStop( "No puede hacer un movimiento de almacén sin líneas" )
      Return .f.
   end if

   /*
   Guardamos el valor del total------------------------------------------------
   */

   ::oDbf:nTotRem    := ::oDetMovimientos:nTotRemVir()

   /*
   Colocamos los valores del meter---------------------------------------------
   */

   ::oMeter:nTotal   := ::nRegisterToProcess()

Return .t.

//---------------------------------------------------------------------------//

Method GenRemMov( lPrinter, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice
   local nNumRem

   DEFAULT lPrinter     := .f.
   DEFAULT cCaption     := "Imprimiendo remesas de movimientos"
   DEFAULT cCodDoc      := cFormatoDocumento(   nil, "nMovAlm", ::oDbfCnt:cAlias )
   DEFAULT nCopies      := nCopiasDocumento(    nil, "nMovAlm", ::oDbfCnt:cAlias )

   if ::oDbf:Lastrec() == 0
      Return nil
   end if

   if Empty( cCodDoc )
      cCodDoc           := "RM1"
   end if

   if !lExisteDocumento( cCodDoc, ::oDbfDoc:cAlias )
      return nil
   end if

   nNumRem              := Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem

   private oThis        := Self

   ::oDbf:GetStatus( .t. )

   ::oDbf:Seek( nNumRem )
   ::oDetMovimientos:oDbf:Seek( nNumRem )
   ::oDetSeriesMovimientos:oDbf:Seek( nNumRem )
   ::oDbfAge:Seek( ::oDbf:cCodAge )

   if lVisualDocumento( cCodDoc, ::oDbfDoc:cAlias )

      public nTotMov       := ::nTotRemMov( .t. )

      ::PrintReportRemMov( if( lPrinter, IS_PRINTER, IS_SCREEN ), nCopies, cPrinter, ::oDbfDoc:cAlias )

   else

      private oDbf         := ::oDbf
      private cDbf         := ::oDbf:cAlias
      private oDbfCol      := ::oDetMovimientos:oDbf
      private cDbfCol      := ::oDetMovimientos:oDbf:cAlias
      private cDbfAlm      := ::oAlm:cAlias
      private cDbfPro      := ::oTblPro:cAlias
      private cDbfFam      := ::oFam:cAlias
      private cDbfMov      := ::oTMov:cAlias
      private cDbfArt      := ::oArt:cAlias
      private cDbfAge      := ::oDbfAge:cAlias

      private cPouDivRem   := ::cPinDiv
      private cPorDivRem   := ::cPirDiv

      ::nTotRemMov( .t. )

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

         oInf:lAutoland          := .f.
         oInf:lFinish            := .f.
         oInf:lNoCancel          := .t.
         oInf:bSkip              := {|| ::::oDetMovimientos:oDbf:Skip() }

         oInf:oDevice:lPrvModal  := .t.

         if lPrinter
            oInf:bPreview        := {| oDevice | PrintPreview( oDevice ) }
         end if

         SetMargin(  cCodDoc, oInf )
         PrintColum( cCodDoc, oInf )

      end if

      END REPORT

      if !Empty( oInf )

      ACTIVATE REPORT oInf ;
         WHILE       ( Str( ::oDetMovimientos:oDbf:nNumRem ) + ::oDetMovimientos:oDbf:cSufRem == nNumRem .and. !::oDetMovimientos:oDbf:Eof() );
         FOR         ( !::::oDetMovimientos:oDbf:lImpLin ) ;
         ON ENDPAGE  ::EPage( oInf, cCodDoc )

         if lPrinter
            oInf:oDevice:end()
         end if

      end if

      oInf  := nil

   end if

   ::oDbf:SetStatus()

Return Nil

//----------------------------------------------------------------------------//

Method EPage( oInf, cCodDoc )

	private nPagina		:= oInf:nPage
	private lEnd			:= oInf:lFinish

   PrintItems( cCodDoc, oInf )

Return ( Self )

//----------------------------------------------------------------------------//

Function aDocRemMov()

   local aDoc  := {}

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Almacén",               "AL" } )
   aAdd( aDoc, { "Divisas",               "DV" } )
   aAdd( aDoc, { "Remesas movimientos",   "RM" } )

RETURN ( aDoc )

//---------------------------------------------------------------------------//

METHOD lSelAll( lSel )

   local nOrdAnt        := ::oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

   DEFAULT lSel         := .t.

   ::oDbf:GetStatus()
   ::oDetMovimientos:oDbf:GetStatus()

   ::oDbf:GoTop()
   while !::oDbf:Eof()

      /*
      Marcamos la cabecera-----------------------------------------------------
      */

      ::oDbf:Load()
      ::oDbf:lSelDoc := lSel
      ::oDbf:Save()

      /*
      Marcamos las lineas------------------------------------------------------
      */

      ::oDetMovimientos:oDbf:GoTop()

      if ::oDetMovimientos:oDbf:Seek( Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem )

         while Str( ::oDetMovimientos:oDbf:nNumRem ) + ::oDetMovimientos:oDbf:cSufRem == Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem .and. !::oDetMovimientos:oDbf:Eof()

            ::oDetMovimientos:oDbf:Load()
            ::oDetMovimientos:oDbf:lSndDoc    := ::oDbf:lSelDoc
            ::oDetMovimientos:oDbf:Save()

            ::oDetMovimientos:oDbf:Skip()

         end while

      end if

      ::oDbf:Skip()

   end while

   ::oDbf:SetStatus()

   ::oDetMovimientos:oDbf:SetStatus()

   ::oDetMovimientos:oDbf:OrdSetFocus( nOrdAnt )

   if !Empty( ::oWndBrw )
      ::oWndBrw:Refresh()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Method lSelMov()

   local nOrdAnt  := ::oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

   ::oDbf:Load()
   ::oDbf:lSelDoc := !::oDbf:lSelDoc
   ::oDbf:Save()

   ::oDetMovimientos:oDbf:GetStatus()

   ::oDetMovimientos:oDbf:GoTop()

   if ::oDetMovimientos:oDbf:Seek( Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem )

      while Str( ::oDetMovimientos:oDbf:nNumRem ) + ::oDetMovimientos:oDbf:cSufRem == Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem .and. !::oDetMovimientos:oDbf:Eof()

         ::oDetMovimientos:oDbf:Load()
         ::oDetMovimientos:oDbf:lSndDoc    := ::oDbf:lSelDoc
         ::oDetMovimientos:oDbf:Save()

         ::oDetMovimientos:oDbf:Skip()

      end while

   end if

   ::oDetMovimientos:oDbf:SetStatus()

   ::oDetMovimientos:oDbf:OrdSetFocus( nOrdAnt )

Return( .t. )

//---------------------------------------------------------------------------//

Method CreateData()

   local lSnd        := .t.
   local oRemMov
   local oRemMovTmp
   local cFileName

   if ::oSender:lServer
      cFileName      := "MovAlm" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "MovAlm" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   ::oSender:SetText( "Enviando movimientos de almacén" )

   oRemMov           := TRemMovAlm():New( cPatEmp() )
   oRemMov:OpenService()

   oRemMov:oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   oRemMovTmp        := TRemMovAlm():New( cPatSnd() )
   oRemMovTmp:OpenService()

   oRemMovTmp:oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   while !oRemMov:oDbf:eof()

      if oRemMov:oDbf:lSelDoc

         lSnd  := .t.

         dbPass( oRemMov:oDbf:nArea, oRemMovTmp:oDbf:nArea, .t. )

         ::oSender:SetText( Str( oRemMov:oDbf:nNumRem, 9 ) + "/" + oRemMov:oDbf:cSufRem )

         if oRemMov:oDetMovimientos:oDbf:Seek( Str( oRemMov:oDbf:nNumRem, 9 ) + oRemMov:oDbf:cSufRem )

            while Str( oRemMov:oDbf:nNumRem, 9 ) + oRemMov:oDbf:cSufRem == Str( oRemMov:oDetMovimientos:oDbf:nNumRem, 9 ) + oRemMov:oDetMovimientos:oDbf:cSufRem .and. !oRemMov:oDetMovimientos:oDbf:Eof()
               dbPass( oRemMov:oDetMovimientos:oDbf:nArea, oRemMovTmp:oDetMovimientos:oDbf:nArea, .t. )
               oRemMov:oDetMovimientos:oDbf:Skip()
            end while

         end if

      end if

      oRemMov:oDbf:Skip()

   end while

   /*
   Cerrar ficheros temporales--------------------------------------------------
   */

   oRemMov:CloseService()
   oRemMov:End()

   oRemMovTmp:CloseService()
   oRemMovTmp:End()

   if lSnd

      /*
      Comprimir los archivos
      */

      ::oSender:SetText( "Comprimiendo movimientos de almacén" )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos en " + Rtrim( cFileName ) )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay movimientos de almacén para enviar" )

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method RestoreData()

   local oRemMov

   if ::lSuccesfullSend

      oRemMov  := TRemMovAlm():Create( cPatEmp() )
      oRemMov:OpenService()

      oRemMov:oDbf:GoTop()

      while !oRemMov:oDbf:Eof()

         if oRemMov:oDbf:lSelDoc
            oRemMov:oDbf:Load()
            oRemMov:oDbf:lSelDoc := .f.
            oRemMov:oDbf:Save()
         end if

         oRemMov:oDbf:Skip()

      end while

      oRemMov:CloseService()

      oRemMov:End()

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method SendData()

   local cFileName

   if ::oSender:lServer
      cFileName      := "MovAlm" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "MovAlm" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   if file( cPatOut() + cFileName )

      if ftpSndFile( cPatOut() + cFileName, cFileName, 2000, ::oSender )
         ::lSuccesfullSend := .t.
         ::IncNumberToSend()
         ::oSender:SetText( "Fichero enviado " + cFileName )
      else
         ::oSender:SetText( "ERROR fichero no enviado" )
      end if

   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method ReciveData()

   local n
   local aExt

   if ::oSender:lServer
      aExt        := aRetDlgEmp()
   else
      aExt        := { "All" }
   end if

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Recibiendo movimientos de almacén" )

   for n := 1 to len( aExt )
      ftpGetFiles( "MovAlm*." + aExt[ n ], cPatIn(), 2000, ::oSender )
   next

   ::oSender:SetText( "Movimientos de almacén recibidos" )

Return Self

//----------------------------------------------------------------------------//

Method Process()

   local m
   local oAlm
   local oBlock
   local oError
   local oRemMov
   local oRemMovTmp
   local dbfRemMovTmp
   local dbfRemMovFix
   local aFiles               := Directory( cPatIn() )

   DATABASE NEW oAlm PATH ( cPatAlm() ) FILE "ALMACEN.DBF" VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

   /*
   Recibirlo de internet
   */

   ::oSender:SetText( "Importando movimientos de almacén" )

   for m := 1 to len( aFiles )

      oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      /*
      descomprimimos el fichero
      */

      if ::oSender:lUnZipData( cPatIn() + aFiles[ m, 1 ] )

         /*
         Ficheros temporales---------------------------------------------------
         */

         ::oSender:SetText( "Procesando fichero " + cPatIn() + aFiles[ m, 1 ] )

         if file( cPatSnd() + "RemMovT.Dbf" )

            oRemMovTmp        := TRemMovAlm():New( cPatSnd() )
            oRemMovTmp:OpenService( .f. )

            oRemMovTmp:oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

            oRemMov           := TRemMovAlm():New( cPatEmp() )
            oRemMov:OpenService()

            oRemMov:oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

            dbfRemMovTmp      := oRemMovTmp:oDbf:cAlias
            dbfRemMovFix      := oRemMov:oDbf:cAlias

            /*
            Ponemos los valores de las delegaciones----------------------------
            */

            oRemMovTmp:oDbf:GoTop()
            while !oRemMovTmp:oDbf:Eof()

               if Empty( oRemMovTmp:oDbf:cSufRem )
                  oRemMovTmp:oDbf:FieldPutByName( "cSufRem", "00" )
               end if 

               oRemMovTmp:oDbf:Skip()

            end while 

            oRemMovTmp:oDetMovimientos:oDbf:GoTop()
            while !oRemMovTmp:oDetMovimientos:oDbf:Eof()

               if Empty( oRemMovTmp:oDetMovimientos:oDbf:cSufRem )
                  oRemMovTmp:oDetMovimientos:oDbf:FieldPutByName( "cSufRem", "00" )
               end if 

               oRemMovTmp:oDetMovimientos:oDbf:Skip()

            end while 

            /*
            Trasbase de turnos-------------------------------------------------------
            */

            oRemMovTmp:oDbf:GoTop()
            while !oRemMovTmp:oDbf:eof()

               do case
               case oAlm:Seek( oRemMovTmp:oDbf:cAlmOrg ) .and. oAlm:Seek( oRemMovTmp:oDbf:cAlmDes )

                  if oRemMov:oDbf:Seek( Str( oRemMovTmp:oDbf:nNumRem, 9 ) + oRemMovTmp:oDbf:cSufRem )
                     dbPass( oRemMovTmp:oDbf:cAlias, oRemMov:oDbf:cAlias, .f. )
                     ::oSender:SetText( "Reemplazado : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  else
                     dbPass( oRemMovTmp:oDbf:cAlias, oRemMov:oDbf:cAlias, .t. )
                     ::oSender:SetText( "Añadido     : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  end if

               case oAlm:Seek( oRemMovTmp:oDbf:cAlmOrg ) .and. !oAlm:Seek( oRemMovTmp:oDbf:cAlmDes )

                  if oRemMov:oDbf:Seek( Str( oRemMovTmp:oDbf:nNumRem, 9 ) + oRemMovTmp:oDbf:cSufRem )
                     dbPass( oRemMovTmp:oDbf:cAlias, oRemMov:oDbf:cAlias, .f. )
                     ::oSender:SetText( "Reemplazado : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  else
                     dbPass( oRemMovTmp:oDbf:cAlias, oRemMov:oDbf:cAlias, .t. )
                     ::oSender:SetText( "Añadido     : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  end if

                  ::oSender:SetText( "No existe almacen destino : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  oRemMov:oDbf:FieldPutByName( "cAlmDes", Space( 16 ) )

               case !oAlm:Seek( oRemMovTmp:oDbf:cAlmOrg ) .and. oAlm:Seek( oRemMovTmp:oDbf:cAlmDes ) //

                  if oRemMov:oDbf:Seek( Str( oRemMovTmp:oDbf:nNumRem, 9 ) + oRemMovTmp:oDbf:cSufRem )
                     dbPass( oRemMovTmp:oDbf:cAlias, oRemMov:oDbf:cAlias, .f. )
                     ::oSender:SetText( "Reemplazado : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  else
                     dbPass( oRemMovTmp:oDbf:cAlias, oRemMov:oDbf:cAlias, .t. )
                     ::oSender:SetText( "Añadido     : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  end if

                  ::oSender:SetText( "No existe almacen origen : " + AllTrim( Str( oRemMovTmp:oDbf:nNumRem, 9 ) ) + "/" + AllTrim( oRemMovTmp:oDbf:cSufRem ) + "; " + Dtoc( oRemMovTmp:oDbf:dFecRem ) )
                  oRemMov:oDbf:FieldPutByName( "cAlmOrg", Space( 16 ) )

               end case

               /*
               Vaciamos las lineas---------------------------------------------
               */

               if oRemMovTmp:oDbf:nNumRem != 0
                  while oRemMov:oDetMovimientos:oDbf:Seek( Str( oRemMovTmp:oDbf:nNumRem, 9 ) + oRemMovTmp:oDbf:cSufRem ) .and. !oRemMov:oDetMovimientos:oDbf:eof()
                     oRemMov:oDetMovimientos:oDbf:Delete(.f.)
                  end while
               end if

               /*
               Trasbase de lineas de turnos------------------------------------
               */

               if oRemMovTmp:oDetMovimientos:oDbf:Seek( Str( oRemMovTmp:oDbf:nNumRem, 9 ) + oRemMovTmp:oDbf:cSufRem )

                  while Str( oRemMovTmp:oDetMovimientos:oDbf:nNumRem, 9 ) + oRemMovTmp:oDetMovimientos:oDbf:cSufRem == Str( oRemMovTmp:oDbf:nNumRem, 9 ) + oRemMovTmp:oDbf:cSufRem .and. !oRemMovTmp:oDetMovimientos:oDbf:eof()

                     do case
                     case oAlm:Seek( oRemMovTmp:oDetMovimientos:oDbf:cAliMov ) .and. oAlm:Seek( oRemMovTmp:oDetMovimientos:oDbf:cAloMov )

                        dbPass( oRemMovTmp:oDetMovimientos:oDbf:cAlias, oRemMov:oDetMovimientos:oDbf:cAlias, .t. )

                     case !oAlm:Seek( oRemMovTmp:oDetMovimientos:oDbf:cAliMov ) .and. oAlm:Seek( oRemMovTmp:oDetMovimientos:oDbf:cAloMov )

                        dbPass( oRemMovTmp:oDetMovimientos:oDbf:cAlias, oRemMov:oDetMovimientos:oDbf:cAlias, .t. )
                        oRemMov:oDetMovimientos:oDbf:FieldPutByName( "cAliMov", Space( 16 ) )

                     case oAlm:Seek( oRemMovTmp:oDetMovimientos:oDbf:cAliMov ) .and. !oAlm:Seek( oRemMovTmp:oDetMovimientos:oDbf:cAloMov )

                        dbPass( oRemMovTmp:oDetMovimientos:oDbf:cAlias, oRemMov:oDetMovimientos:oDbf:cAlias, .t. )
                        oRemMov:oDetMovimientos:oDbf:FieldPutByName( "cAloMov", Space( 16 ) )

                     end case

                     oRemMovTmp:oDetMovimientos:oDbf:Skip()

                  end while

               end if

               oRemMovTmp:oDbf:Skip()

            end while

            /*
            Finalizando--------------------------------------------------------
            */

            oRemMov:CloseService()
            oRemMov:End()

            oRemMovTmp:CloseService()
            oRemMovTmp:End()

            ::oSender:AppendFileRecive( aFiles[ m, 1 ] )

         else

            ::oSender:SetText( "Faltan ficheros" )

            if !File( cPatSnd() + "RemMovT.Dbf" )
               ::oSender:SetText( "Falta " + cPatSnd() + "RemMovT.Dbf" )
            end if

         end if

      end if

       RECOVER USING oError

         ::oSender:SetText( "Error procesando fichero " + aFiles[ m, 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

   if !Empty( oAlm ) .and. oAlm:Used()
      oAlm:End()
   end if

Return Self

//----------------------------------------------------------------------------//

Method nGetNumberToSend()

   ::nNumberSend     := GetPvProfInt( "Numero", ::cText, ::nNumberSend, ::cIniFile )

Return ( ::nNumberSend )

//----------------------------------------------------------------------------//

METHOD Save()

   WritePProString( "Envio",     ::cText, cValToChar( ::lSelectSend ), ::cIniFile )
   WritePProString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Load()

   ::lSelectSend     := ( Upper( GetPvProfString( "Envio",     ::cText, cValToChar( ::lSelectSend ),   ::cIniFile ) ) == ".T." )
   ::lSelectRecive   := ( Upper( GetPvProfString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile ) ) == ".T." )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD lGenRemMov( oBrw, oBtn, lImp )

   local bAction

   DEFAULT lImp   := .f.

   if !::oDbfDoc:Seek( "RM" )

      DEFINE BTNSHELL RESOURCE "DOCUMENT" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay documentos predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   else

      while ::oDbfDoc:cTipo == "RM" .AND. !::oDbfDoc:eof()

         bAction  := ::bGenRemMov( lImp, "Imprimiendo movimientoo de almacén", ::oDbfDoc:Codigo )

         ::oWndBrw:NewAt( "Document", , , bAction, Rtrim( ::oDbfDoc:cDescrip ) , , , , , oBtn )

         ::oDbfDoc:Skip()

      end do

   end if

RETURN nil

//---------------------------------------------------------------------------//

METHOD bGenRemMov( lImprimir, cTitle, cCodDoc )

   local bGen
   local lImp  := by( lImprimir )
   local cTit  := by( cTitle    )
   local cCod  := by( cCodDoc   )

   bGen        := {|| ::GenRemMov( lImp, cTit, cCod ) }

RETURN ( bGen )

//---------------------------------------------------------------------------//

METHOD Reindexa()

   if Empty( ::oDbf )
      ::oDbf      := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   ::oDbf:Activate( .f., .t., .f. )

   ::oDbf:Pack()

   ::oDbf:End()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD CheckFiles()

   if ::OpenService()
      ::CloseFiles()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AppendDet( oDlg )

   local nDetalle

   // oDlg:Disable()

   while .t.

      ::oDetMovimientos:oDbfVir:Blank()

      nDetalle    := ::oDetMovimientos:Resource( 1 )

      do case
      case nDetalle == IDOK

         ::oDetMovimientos:oDbfVir:Insert()

         if( ::oBrwDet != nil, ::oBrwDet:Refresh(), )

         ::oDetMovimientos:AppendKit()

         if lEntCon()
            loop
         else
            exit
         end if

      case nDetalle == IDFOUND

         ::oDetMovimientos:oDbfVir:Cancel()

         if( ::oBrwDet != nil, ::oBrwDet:Refresh(), )

         if lEntCon()
            loop
         else
            exit
         end if

      otherwise

         ::oDetMovimientos:oDbfVir:Cancel()

         if( ::oBrwDet != nil, ::oBrwDet:Refresh(), )

         exit

      end if

   end while

   // oDlg:Enable()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD EditDet()

   if ::oDetMovimientos:oDbfVir:OrdKeyCount() == 0
      Return ( Self )
   end if

   ::oDetMovimientos:oDbfVir:Load()

   if ::oDetMovimientos:Resource( 2 ) == IDOK
      ::oDetMovimientos:oDbfVir:Save()
   else
      ::oDetMovimientos:oDbfVir:Cancel()
   end if

   if( ::oBrwDet != nil, ::oBrwDet:Refresh(), )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DeleteDet()

   local nNum
   local nNumLin
   local nNumRec
   local nMarked
   local cTxtDel

   if ::oDetMovimientos:oDbfVir:OrdKeyCount() == 0
      Return ( Self )
   end if

   nMarked           := len( ::oBrwDet:aSelected )
   if nMarked > 1
      cTxtDel        := "¿ Desea eliminar definitivamente " + AllTrim( Str( nMarked, 3 ) ) + " registros ?"
   else
      cTxtDel        := "¿Desea eliminar el registro en curso?"
   end if

   if oUser():lNotConfirmDelete() .or.  ApoloMsgNoYes(cTxtDel, "Confirme supersión" )

      for each nNum in ( ::oBrwDet:aSelected )

         ::oDetMovimientos:oDbfVir:GoTo( nNum )

         nNumLin        := ::oDetMovimientos:oDbfVir:nNumLin
         nNumRec        := ::oDetMovimientos:oDbfVir:Recno()

         /*
         Ahora voy a borrar los registros de los escandallos-------------------
         */

         ::oDetMovimientos:oDbfVir:GoTop()

         while !::oDetMovimientos:oDbfVir:Eof()
            if !Empty( nNumLin ) .and. ( ::oDetMovimientos:oDbfVir:nNumLin == nNumLin )
               ::oDetMovimientos:oDbfVir:Delete(.f.)
            end if
            ::oDetMovimientos:oDbfVir:Skip()
         end while

         ::oDetMovimientos:oDbfVir:GoTo( nNumRec )

         /*
         Ahora el registro padre-----------------------------------------------
         */

         ::oDetMovimientos:oDbfVir:Delete()

         ::oBrwDet:Refresh()

      next

   end if

   if ::oDetMovimientos:oDbfVir:OrdKeyCount() == 0
      ::oRadTipoMovimiento:Enable()
   end if

   ::oBrwDet:Select()

Return ( Self )

//---------------------------------------------------------------------------//

Method ImportAlmacen( nMode, oDlg )

   // oDlg:Disable()

   ::cFamiliaInicio        := dbFirst( ::oFam, 1 )
   ::cFamiliaFin           := dbLast ( ::oFam, 1 )
   ::cArticuloInicio       := dbFirst( ::oArt, 1 )
   ::cArticuloFin          := dbLast ( ::oArt, 1 )
   ::cTipoArticuloInicio   := dbFirst( ::oTipArt:oDbf, 1 )
   ::cTipoArticuloFin      := dbLast ( ::oTipArt:oDbf, 1 )

   DEFINE DIALOG ::oDlgImport RESOURCE "ImportAlmacen"

      REDEFINE CHECKBOX ::lFamilia ;
         ID       200 ;
         OF       ::oDlgImport ;

      REDEFINE GET ::oFamiliaInicio VAR ::cFamiliaInicio ;
         ID       210 ;
         IDTEXT   220 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lFamilia ) ;
         OF       ::oDlgImport ;

      ::oFamiliaInicio:bValid    := {|| cFamilia( ::oFamiliaInicio, ::oFam:cAlias, ::oFamiliaInicio:oHelpText ) }
      ::oFamiliaInicio:bHelp     := {|| brwFamilia( ::oFamiliaInicio, ::oFamiliaInicio:oHelpText ) }

      REDEFINE GET ::oFamiliaFin VAR ::cFamiliaFin ;
         ID       230 ;
         IDTEXT   240 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lFamilia ) ;
         OF       ::oDlgImport ;

      ::oFamiliaFin:bValid       := {|| cFamilia( ::oFamiliaFin, ::oFam:cAlias, ::oFamiliaFin:oHelpText ) }
      ::oFamiliaFin:bHelp        := {|| brwFamilia( ::oFamiliaFin, ::oFamiliaFin:oHelpText ) }

      REDEFINE CHECKBOX ::lTipoArticulo ;
         ID       370 ;
         OF       ::oDlgImport ;

      REDEFINE GET ::oTipoArticuloInicio VAR ::cTipoArticuloInicio ;
         ID       350 ;
         IDTEXT   351 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lTipoArticulo ) ;
         OF       ::oDlgImport ;

      ::oTipoArticuloInicio:bValid    := {|| ::oTipArt:lValid( ::oTipoArticuloInicio, ::oTipoArticuloInicio:oHelpText ) }
      ::oTipoArticuloInicio:bHelp     := {|| ::oTipArt:Buscar( ::oTipoArticuloInicio ) }

      REDEFINE GET ::oTipoArticuloFin VAR ::cTipoArticuloFin ;
         ID       360 ;
         IDTEXT   361 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lTipoArticulo ) ;
         OF       ::oDlgImport ;

      ::oTipoArticuloFin:bValid       := {|| ::oTipArt:lValid( ::oTipoArticuloFin, ::oTipoArticuloFin:oHelpText ) }
      ::oTipoArticuloFin:bHelp        := {|| ::oTipArt:Buscar( ::oTipoArticuloFin ) }

      REDEFINE CHECKBOX ::lArticulo ;
         ID       300 ;
         OF       ::oDlgImport ;

      REDEFINE GET ::oArticuloInicio VAR ::cArticuloInicio ;
         ID       310 ;
         IDTEXT   320 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lArticulo ) ;
         OF       ::oDlgImport ;

      ::oArticuloInicio:bValid    := {|| cArticulo( ::oArticuloInicio, ::oArt:cAlias, ::oArticuloInicio:oHelpText ) }
      ::oArticuloInicio:bHelp     := {|| brwArticulo( ::oArticuloInicio, ::oArticuloInicio:oHelpText ) }

      REDEFINE GET ::oArticuloFin VAR ::cArticuloFin ;
         ID       330 ;
         IDTEXT   340 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lArticulo ) ;
         OF       ::oDlgImport ;

      ::oArticuloFin:bValid       := {|| cArticulo( ::oArticuloFin, ::oArt:cAlias, ::oArticuloFin:oHelpText ) }
      ::oArticuloFin:bHelp        := {|| brwArticulo( ::oArticuloFin, ::oArticuloFin:oHelpText ) }

      REDEFINE METER ::oMtrStock ;
         VAR      ::nMtrStock ;
         PROMPT   "" ;
         ID       400 ;
         OF       ::oDlgImport

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlgImport ;
         ACTION   ( ::loadAlmacen( nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlgImport ;
         ACTION   ( ::oDlgImport:End() )

   ::oDlgImport:bStart  := {|| ::oFamiliaInicio:lValid(), ::oFamiliaFin:lValid(), ::oArticuloInicio:lValid(), ::oArticuloFin:lValid(), ::oTipoArticuloInicio:lValid(), ::oTipoArticuloFin:lValid() }

   ::oDlgImport:AddFastKey( VK_F5, {|| ::loadAlmacen( nMode ) } )

   ACTIVATE DIALOG ::oDlgImport CENTER

   // oDlg:Enable()

Return nil

//---------------------------------------------------------------------------//

METHOD loadAlmacen( nMode )

   local nPreMed
   local cCodFam
   local cCodAlm
   local cCodTip
   local sStkAlm
   local aStkAlm
   local nNumLin

   CursorWait()

   ::oDlgImport:Disable()

   cCodAlm              := ::oDbf:cAlmDes

   if ( nMode == APPD_MODE ) .and. ( ::oDbf:nTipMov >= 2 )

      ::oMtrStock:cText    := "Importando artículos "
      ::oMtrStock:nTotal   := ::oArt:OrdKeyCount() 
      
      ::oMtrStock:Refresh()

      ::oArt:GoTop()
      while !::oArt:eof()

      if ( ::lFamilia      .or. ( ::oArt:Familia >= ::cFamiliaInicio        .and. ::oArt:Familia <= ::cFamiliaFin ) )      .and.;
         ( ::lTipoArticulo .or. ( ::oArt:cCodTip >= ::cTipoArticuloInicio   .and. ::oArt:cCodTip <= ::cTipoArticuloFin ) ) .and.;
         ( ::lArticulo     .or. ( ::oArt:Codigo >= ::cArticuloInicio        .and. ::oArt:Codigo <= ::cArticuloFin ) )

         aStkAlm           := ::oStock:aStockArticulo( ::oArt:Codigo, cCodAlm )

         for each sStkAlm in aStkAlm

            if sStkAlm:nUnidades != 0

               if  ::oDetMovimientos:oDbfVir:Append()
   
                  ::oDetMovimientos:oDbfVir:Blank()
      
                  ::oDetMovimientos:oDbfVir:lSelDoc   := .t.
      
                  ::oDetMovimientos:oDbfVir:cRefMov   := sStkAlm:cCodigo
      
                  ::oDetMovimientos:oDbfVir:cCodPr1   := sStkAlm:cCodigoPropiedad1
                  ::oDetMovimientos:oDbfVir:cCodPr2   := sStkAlm:cCodigoPropiedad2
                  ::oDetMovimientos:oDbfVir:cValPr1   := sStkAlm:cValorPropiedad1
                  ::oDetMovimientos:oDbfVir:cValPr2   := sStkAlm:cValorPropiedad2
                  ::oDetMovimientos:oDbfVir:cLote     := sStkAlm:cLote
                  ::oDetMovimientos:oDbfVir:nUndAnt   := sStkAlm:nUnidades
      
                  ::oDetMovimientos:oDbfVir:nNumRem   := ::oDbf:nNumRem
                  ::oDetMovimientos:oDbfVir:cSufRem   := ::oDbf:cSufRem
                  
                  nNumLin                             := nLastNum( ::oDetMovimientos:oDbfVir:cAlias )
                  ::oDetMovimientos:oDbfVir:nNumLin   := nNumLin
      
                  ::oDetMovimientos:oDbfVir:dFecMov   := ::oDbf:dFecRem
                  ::oDetMovimientos:oDbfVir:cTimMov   := ::oDbf:cTimRem
   
                  ::oDetMovimientos:oDbfVir:nTipMov   := ::oDbf:nTipMov
                  ::oDetMovimientos:oDbfVir:cCodMov   := ::oDbf:cCodMov
                  ::oDetMovimientos:oDbfVir:cAliMov   := ::oDbf:cAlmDes
                  ::oDetMovimientos:oDbfVir:cAloMov   := Space( 16 )

                  if !Empty( sStkAlm:cNumeroSerie )

                     ::oDetSeriesMovimientos:oDbfVir:Append()

                     ::oDetSeriesMovimientos:oDbfVir:Blank()

                     ::oDetSeriesMovimientos:oDbfVir:nNumRem   := ::oDbf:nNumRem
                     ::oDetSeriesMovimientos:oDbfVir:cSufRem   := ::oDbf:cSufRem
                     ::oDetSeriesMovimientos:oDbfVir:dFecRem   := ::oDbf:dFecRem
                     ::oDetSeriesMovimientos:oDbfVir:nNumLin   := nNumLin
                     ::oDetSeriesMovimientos:oDbfVir:cCodArt   := sStkAlm:cCodigo
                     ::oDetSeriesMovimientos:oDbfVir:cAlmOrd   := ::oDbf:cAlmDes
                     ::oDetSeriesMovimientos:oDbfVir:cNumSer   := sStkAlm:cNumeroSerie

                     ::oDetSeriesMovimientos:oDbfVir:Save()

                  end if

                  ::oDetMovimientos:oDbfVir:nUndMov   := 0
      
                  if !uFieldEmpresa( "lCosAct" )
      
                     nPreMed                          := ::oStock:nPrecioMedioCompra( sStkAlm:cCodigo, cCodAlm, nil, GetSysDate() )
      
                     if nPreMed == 0
                        nPreMed                       := nCosto( sStkAlm:cCodigo, ::oArt:cAlias, ::oArtKit:cAlias )
                     end if
      
                  else
      
                     nPreMed                          := nCosto( sStkAlm:cCodigo, ::oArt:cAlias, ::oArtKit:cAlias )
   
                  end if
      
                  ::oDetMovimientos:oDbfVir:nPreDiv    := nPreMed
      
                  ::oDetMovimientos:oDbfVir:Save()
      
               end if
            
            end if

         next
      
      end if
   
      ::oArt:Skip()
   
      ::oMtrStock:Set( ::oArt:OrdKeyNo() ) 
   
      end while

   end if

   ::oDetMovimientos:oDbfVir:GoTop()
   
   ::oBrwDet:Refresh()
   
   ::oMtrStock:Set( ::oArt:OrdKeyCount() )

   ::oDlgImport:Enable()
   ::oDlgImport:End()

   CursorWE()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD nClrText()

   local cClr

   if ::oDbfVir:lKitEsc
      cClr     := CLR_GRAY
   else
      cClr     := CLR_BLACK
   end if

RETURN cClr

//---------------------------------------------------------------------------//

METHOD ShowKit( lSet )

   local lShwKit     := lShwKit()

   if lSet
      lShwKit        := !lShwKit
   end if

   if lShwKit
      SetWindowText( ::oBtnKit:hWnd, "Mostrar Esc&ll." )
      ::oDetMovimientos:oDbfVir:SetFilter( "!lKitEsc" )
   else
      SetWindowText( ::oBtnKit:hWnd, "Ocultar Esc&ll." )
      ::oDetMovimientos:oDbfVir:KillFilter()
   end if

   if lSet
      lShwKit( lShwKit )
   end if

   ::oBrwDet:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ShwAlm( oSay, oBtnImp )

   if ::oDbf:nTipMov >= 2
      oSay[ 1 ]:Hide()
      oSay[ 4 ]:Hide()
      ::oAlmOrg:Hide()
      oSay[ 1 ]:cText( Space(16) )
      ::oAlmOrg:cText( Space(16) )
      if !Empty( oBtnImp )
         oBtnImp:Show()
      end if
   else
      oSay[ 1 ]:Show()
      oSay[ 4 ]:Show()
      ::oAlmOrg:Show()
      if !Empty( oBtnImp )
         oBtnImp:Hide()
      end if
   end if

return .t.

//---------------------------------------------------------------------------//
/*
Total de la remesa
*/

METHOD nTotRemMov( lPic )

   local nTot     := 0

   if !Empty( ::oDbf ) .and. ::oDbf:Used() .and. !Empty( ::oDetMovimientos ) .and. ::oDetMovimientos:oDbf:Used()

      if ::oDetMovimientos:oDbf:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
         while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDetMovimientos:oDbf:nNumRem, 9 ) + ::oDetMovimientos:oDbf:cSufRem .and. !::oDetMovimientos:oDbf:Eof()
            nTot  +=  nTotLMovAlm( ::oDetMovimientos:oDbf )
            ::oDetMovimientos:oDbf:Skip()
         end while
      end if

   end if

RETURN ( if( IsTrue( lPic ), Trans( nTot, ::cPirDiv ), nTot ) )

//--------------------------------------------------------------------------//

FUNCTION RemMovAlm( oMenuItem, oWnd )

   DEFAULT  oMenuItem   := "01050"
   DEFAULT  oWnd        := oWnd()

   if Empty( oRemesas )

      /*
      Cerramos todas las ventanas
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Movimientos de almacén", ProcName() )

      oRemesas          := TRemMovAlm():New( cPatEmp(), oWnd, oMenuItem )
      if !Empty( oRemesas )
         oRemesas:Play()
      end if

      oRemesas          := nil

   end if

RETURN NIL

//--------------------------------------------------------------------------//

METHOD lSelAllDoc( lSel )

   DEFAULT lSel         := .t.

   ::oDbfVir:GetStatus()

   ::oDbfVir:GoTop()
   while !::oDbfVir:Eof()
      ::oDbfVir:lSelDoc := lSel
      ::oDbfVir:Skip()
   end while

   ::oDbfVir:SetStatus()

   ::oBrwDet:Refresh()

RETURN NIL

//--------------------------------------------------------------------------//

METHOD lSelDoc()

   ::oDbfVir:Load()
   ::oDbfVir:lSelDoc := !::oDbfVir:lSelDoc
   ::oDbfVir:Save()

   ::oBrwDet:Refresh()

RETURN nil


//--------------------------------------------------------------------------//

METHOD DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Movimiento", ::oDbf:nArea, .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Movimiento", cObjectsToReport( ::oDbf ) )

   if !Empty( ::oDetMovimientos )
      oFr:SetWorkArea(     "Lineas de movimientos", ::oDetMovimientos:oDbf:nArea )
      oFr:SetFieldAliases( "Lineas de movimientos", cObjectsToReport( ::oDetMovimientos:oDbf ) )
   end if

   oFr:SetWorkArea(     "Empresa", ::oDbfEmp:nArea )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Almacén origen", ::oAlm:nArea )
   oFr:SetFieldAliases( "Almacén origen", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Almacén destino", ::oAlm:nArea )
   oFr:SetFieldAliases( "Almacén destino", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Agentes", ::oDbfAge:nArea )
   oFr:SetFieldAliases( "Agentes", cItemsToReport( aItmAge() ) )

   if !Empty( ::oDetMovimientos )
      oFr:SetMasterDetail( "Movimiento", "Lineas de movimientos", {|| Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem } )
   end if

   oFr:SetMasterDetail( "Movimiento", "Empresa",               {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Movimiento", "Almacén origen",        {|| ::oDbf:cAlmOrg } )
   oFr:SetMasterDetail( "Movimiento", "Almacén destino",       {|| ::oDbf:cAlmDes } )
   oFr:SetMasterDetail( "Movimiento", "Agentes",               {|| ::oDbf:cCodAge } )

   if !Empty( ::oDetMovimientos )
      oFr:SetResyncPair(   "Movimiento", "Lineas de movimientos" )
   end if

   oFr:SetResyncPair(   "Movimiento", "Empresa" )
   oFr:SetResyncPair(   "Movimiento", "Almacén origen" )
   oFr:SetResyncPair(   "Movimiento", "Almacén destino" )
   oFr:SetResyncPair(   "Movimiento", "Agentes" )

Return nil

//---------------------------------------------------------------------------//

METHOD VariableReport( oFr )

   oFr:DeleteCategory(  "Movimiento" )
   oFr:DeleteCategory(  "Lineas de movimientos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Movimiento",              "Total movimiento",                  "GetHbVar('nTotMov')" )
   oFr:AddVariable(     "Movimiento",              "Tipo de movimiento formato texto",  "CallHbFunc('cTipoMovimiento')" )

   oFr:AddVariable(     "Lineas de movimientos",   "Detalle del artículo",              "CallHbFunc('cNombreArticuloMovimiento')" )
   oFr:AddVariable(     "Lineas de movimientos",   "Total unidades",                    "CallHbFunc('nUnidadesLineaMovimiento')" )
   oFr:AddVariable(     "Lineas de movimientos",   "Total linea movimiento",            "CallHbFunc('nImporteLineaMovimiento')" )

Return nil

//---------------------------------------------------------------------------//

METHOD DesignReportRemMov( oFr, dbfDoc )

   if ::OpenFiles()

      private oThis        := Self
      public nTotMov       := ::nTotRemMov()

      /*
      Zona de datos------------------------------------------------------------
      */

      ::DataReport( oFr )

      /*
      Paginas y bandas---------------------------------------------------------
      */

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      else

         oFr:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
         oFr:SetProperty(     "CabeceraDocumento", "Top", 0 )
         oFr:SetProperty(     "CabeceraDocumento", "Height", 200 )

         oFr:AddBand(         "CabeceraColumnas",  "MainPage", frxMasterData )
         oFr:SetProperty(     "CabeceraColumnas",  "Top", 200 )
         oFr:SetProperty(     "CabeceraColumnas",  "Height", 0 )
         oFr:SetProperty(     "CabeceraColumnas",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet", "Movimiento" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de movimientos" )
         oFr:SetProperty(     "DetalleColumnas",   "OnMasterDetail", "DetalleOnMasterDetail" )

         oFr:AddBand(         "PieDocumento",      "MainPage", frxPageFooter )
         oFr:SetProperty(     "PieDocumento",      "Top", 930 )
         oFr:SetProperty(     "PieDocumento",      "Height", 110 )

      end if

      /*
      Zona de variables--------------------------------------------------------
      */

      ::VariableReport( oFr )

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

      ::CloseFiles()

   else

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD PrintReportRemMov( nDevice, nCopies, cPrinter, dbfDoc )

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
   Zona de datos---------------------------------------------------------------
   */

   ::DataReport( oFr )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Zona de variables--------------------------------------------------------
      */

      ::VariableReport( oFr )

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

Method ActualizaStockWeb( cNumDoc ) CLASS TRemMovAlm

   local nRec
   local nOrdAnt

   if uFieldEmpresa( "lRealWeb" )

      /*
      Materiales producidos----------------------------------------------------
      */

      nRec     := ::oDetMovimientos:oDbf:Recno()
      nOrdAnt  := ::oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

      with object ( TComercio():GetInstance() )

         if ::oDetMovimientos:oDbf:Seek( cNumDoc )

            while Str( ::oDetMovimientos:oDbf:nNumRem ) + ::oDetMovimientos:oDbf:cSufRem == cNumDoc .and. !::oDetMovimientos:oDbf:Eof()

               if oRetfld( ::oDetMovimientos:oDbf:cRefMov, ::oArt, "lPubInt", "Codigo" )

                  :ActualizaStockProductsPrestashop( ::oDetMovimientos:oDbf:cRefMov, ::oDetMovimientos:oDbf:cCodPr1, ::oDetMovimientos:oDbf:cCodPr2, ::oDetMovimientos:oDbf:cValPr1, ::oDetMovimientos:oDbf:cValPr2 )

               end if                  

               ::oDetMovimientos:oDbf:Skip()

            end while

        end if
        
      end with

      ::oDetMovimientos:oDbf:OrdSetFocus( nOrdAnt )
      ::oDetMovimientos:oDbf:GoTo( nRec )
   
   end if 

Return .f.   

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//

function cNombreArticuloMovimiento()

   local cNombre     := RetFld( oThis:oDetMovimientos:oDbf:cRefMov, oThis:oArt:cAlias, "Nombre" )

Return cNombre

//---------------------------------------------------------------------------//

function nUnidadesLineaMovimiento()

Return nTotNMovAlm( oThis:oDetMovimientos:oDbf )

//---------------------------------------------------------------------------//

function nImporteLineaMovimiento()

Return nTotLMovAlm( oThis:oDetMovimientos:oDbf )

//---------------------------------------------------------------------------//

function cTipoMovimiento()

   local cTipo    := ""

   do case
      case oThis:oDbf:nTipMov <= 1
         cTipo    := "Entre almacenes"
      case oThis:oDbf:nTipMov == 2
         cTipo    := "Regularización"
      case oThis:oDbf:nTipMov == 3
         cTipo    := "Regularización por objetivos"
      case oThis:oDbf:nTipMov == 4
         cTipo    := "Consolidación"
   end if

Return cTipo


//---------------------------------------------------------------------------//

FUNCTION rxRemMov( cPath, oMeter )

   local dbfRemMovT

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "REMMOVT.DBF" )

      CreateFiles( cPath )

   end if

   fEraseIndex( cPath + "REMMOVT.CDX" )

   dbUseArea( .t., cDriver(), cPath + "REMMOVT.DBF", cCheckArea( "REMMOVT", @dbfRemMovT ), .f. )

   if !( dbfRemMovT )->( neterr() )
      ( dbfRemMovT )->( __dbPack() )

      ( dbfRemMovT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfRemMovT )->( ordCreate( cPath + "REMMOVT.CDX", "CNUMREM", "Str( NNUMREM ) + CSUFREM", {|| Str( Field->NNUMREM ) + Field->CSUFREM } ) )

      ( dbfRemMovT )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( dbfRemMovT )->( ordCreate( cPath + "REMMOVT.CDX", "DFECREM", "Dtos( DFECREM ) + CTIMREM", {|| Dtos( Field->DFECREM ) + Field->CTIMREM } ) )

      ( dbfRemMovT )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION CreateFiles( cPath )

   if !lExistTable( cPath + "RemMovT.Dbf" )
      dbCreate( cPath + "RemMovT.Dbf", aSqlStruct( aItmRemMov() ), cDriver() )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Function aItmRemMov()

   local aBase := {}

   aAdd( aBase, { "lSelDoc",   "L",   1,  0, "Lógico Seleccionado"  } )
   aAdd( aBase, { "nNumRem",   "N",   9,  0, "Número"               } )
   aAdd( aBase, { "cSufRem",   "C",   2,  0, "Sufijo"               } )
   aAdd( aBase, { "nTipMov",   "N",   1,  0, "Tipo del movimiento"  } )
   aAdd( aBase, { "cCodUsr",   "C",   3,  0, "Código usuario"       } )
   aAdd( aBase, { "cCodDlg",   "C",   2,  0, "Delegación"           } )
   aAdd( aBase, { "cCodAge",   "C",   3,  0, "Código agente"        } )
   aAdd( aBase, { "cCodMov",   "C",   2,  0, "Tipo de movimiento"   } )
   aAdd( aBase, { "dFecRem",   "D",   8,  0, "Fecha"                } )
   aAdd( aBase, { "cTimRem",   "C",   5,  0, "Hora"                 } )
   aAdd( aBase, { "cAlmOrg",   "C",  16,  0, "Alm. org."            } )
   aAdd( aBase, { "cAlmDes",   "C",  16,  0, "Alm. des."            } )
   aAdd( aBase, { "cCodDiv",   "C",   3,  0, "Div."                 } )
   aAdd( aBase, { "nVdvDiv",   "N",  13,  6, "Cambio de la divisa"  } )
   aAdd( aBase, { "cComMov",   "C", 100,  0, "Comentario"           } )

Return ( aBase )

//---------------------------------------------------------------------------//

FUNCTION IsRemMov( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "RemMovT.Dbf" )
      dbCreate( cPath + "RemMovT.Dbf", aSqlStruct( aItmRemMov() ), cDriver() )
   end if

   if !lExistTable( cPath + "HisMov.Dbf" )
      dbCreate( cPath + "HisMov.Dbf", aSqlStruct( aItmMov() ), cDriver() )
   end if

   if !lExistIndex( cPath + "RemMovT.Cdx" )
      rxRemMov( cPath )
   end if

   if !lExistIndex( cPath + "HisMov.Cdx" )
      rxHisMov( cPath )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

function nTotNRemMov( uDbf )

   local nTotUnd

   DEFAULT uDbf   := dbfAlbCliL

   do case
      case IsChar( uDbf )

         nTotUnd  := NotCaja( ( uDbf )->nCajMov )
         nTotUnd  *= ( uDbf )->nUndMov

      case IsObject( uDbf )

         nTotUnd  := NotCaja( uDbf:nCajMov )
         nTotUnd  *= uDbf:nUndMov

   end case

RETURN ( nTotUnd )

//---------------------------------------------------------------------------//
/*
STATIC FUNCTION LoaArt( cCodArt, aTmp, aGet, oSay )

   local lChgCodArt  := ( Empty( cOldCodArt ) .or. Rtrim( cOldCodArt ) != Rtrim( cCodArt ) )

   if Empty( cCodArt )
      MsgStop( "No se pueden añadir líneas sin codificar" )
      return .f.
   end if

   if aSeekProp( @aTmp[ ( dbfTmpLin )->( FieldPos( "cRefMov" ) ) ], @aTmp[ ( dbfTmpLin )->( FieldPos( "cValPr1" ) ) ], @aTmp[ ( dbfTmpLin )->( FieldPos( "cValPr2" ) ) ], dbfArticulo, dbfTblPro )

      if ( dbfArticulo )->lObs
         MsgStop( "Artículo catalogado como obsoleto" )
         return .f.
      end if


      if ( lChgCodArt )

         aGet[ ( dbfTmpLin )->( FieldPos( "cRefMov" ) ) ]:cText( ( dbfArticulo )->Codigo )

         oSay[ 1 ]:cText( ( dbfArticulo )->Nombre )

         aTmp[ ( dbfTmpLin )->( FieldPos( "LLOTE" ) ) ]     := ( dbfArticulo )->lLote

         if ( dbfArticulo )->lLote
            oSay[2]:Show()
            aGet[ ( dbfTmpLin )->( FieldPos( "CLOTE" ) ) ]:Show()
            aGet[ ( dbfTmpLin )->( FieldPos( "CLOTE" ) ) ]:cText( ( dbfArticulo )->cLote )
         else
            if !Empty( oSay[2] ) .and. !Empty( aGet[ ( dbfTmpLin )->( FieldPos( "CLOTE" ) ) ] )
               oSay[2]:Hide()
               aGet[ ( dbfTmpLin )->( FieldPos( "CLOTE" ) ) ]:Hide()
            end if
         end if

         aTmp[ ( dbfTmpLin )->( FieldPos( "CCODPR1" ) ) ]   := ( dbfArticulo )->cCodPrp1
         aTmp[ ( dbfTmpLin )->( FieldPos( "CCODPR2" ) ) ]   := ( dbfArticulo )->cCodPrp2

         if !Empty( aTmp[ ( dbfTmpLin )->( FieldPos( "CCODPR1" ) ) ] )

            if aGet[ ( dbfTmpLin )->( FieldPos( "CVALPR1" ) ) ] != nil
               aGet[ ( dbfTmpLin )->( FieldPos( "CVALPR1" ) ) ]:Show()
               aGet[ ( dbfTmpLin )->( FieldPos( "CVALPR1" ) ) ]:SetFocus()
            end if

            if oSay[3] != nil
               oSay[3]:SetText( retProp( ( dbfArticulo )->cCodPrp1, dbfPro ) )
               oSay[3]:show()
            end if

            if oSay[4] != nil
               oSay[4]:SetText( "" )
               oSay[4]:Show()
            end if

         else

            if !Empty( aGet[ ( dbfTmpLin )->( FieldPos( "CVALPR1" ) ) ] )
               aGet[ ( dbfTmpLin )->( FieldPos( "CVALPR1" ) ) ]:Hide()
            end if

            if !Empty( oSay[3] )
               oSay[3]:Hide()
            end if

            if !Empty( oSay[4] )
               oSay[4]:Hide()
            end if

         end if

         if !Empty( aTmp[ ( dbfTmpLin )->( FieldPos( "CCODPR2" ) ) ] )

            if aGet[ ( dbfTmpLin )->( FieldPos( "CVALPR2" ) ) ] != nil
               aGet[ ( dbfTmpLin )->( FieldPos( "CVALPR2" ) ) ]:show()
            end if

            if oSay[5] != nil
               oSay[5]:SetText( retProp( ( dbfArticulo )->cCodPrp2, dbfPro ) )
               oSay[5]:show()
            end if

            if oSay[6] != nil
               oSay[6]:SetText( "" )
               oSay[6]:Show()
            end if

         else

            if !Empty( aGet[ ( dbfTmpLin )->( FieldPos( "CVALPR2" ) ) ] )
               aGet[ ( dbfTmpLin )->( FieldPos( "CVALPR2" ) ) ]:Hide()
            end if

            if !Empty( oSay[5] )
               oSay[5]:Hide()
            end if

            if !Empty( oSay[6] )
               oSay[6]:Hide()
            end if

         end if

      end if

      cOldCodArt     := cCodArt

   else

      MsgStop( "Artículo no encontrado" )
      Return ( .f. )

   end if

RETURN ( .t. )
*/

//---------------------------------------------------------------------------//

Static Function QuiHisMov()

   local nOrdAnt  := ( dbfHisMov )->( OrdSetFocus( "nNumRem" ) )

   /*
   Detalle---------------------------------------------------------------------
   */

   while ( ( dbfHisMov )->( dbSeek( Str( ( dbfRemMov )->nNumRem ) + ( dbfRemMov  )->cSufRem ) ) .and. !( dbfHisMov )->( eof() ) )

      if dbLock( dbfHisMov )
         ( dbfHisMov )->( dbDelete() )
         ( dbfHisMov )->( dbUnLock() )
      end if

   end while

   ( dbfHisMov )->( OrdSetFocus( nOrdAnt ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SImportaAlmacen

   DATA cCodigo         AS CHARACTER   INIT ""
   DATA cDescripcion    AS CHARACTER   INIT ""
   DATA nEntrada        AS NUMERIC     INIT 0
   DATA nSalida         AS NUMERIC     INIT 0

   METHOD SumaEntrada( n ) INLINE         ( ::nEntrada   += n )
   METHOD SumaSalida( n )  INLINE         ( ::nSalida    += n )
   METHOD Saldo()          INLINE         ( ::nEntrada - ::nSalida )

END CLASS

//---------------------------------------------------------------------------//

Function SynRemMov( cPath )

   local oBlock
   local oError
   local dFecMov
   local dbfRemMov
   local dbfHisMov
   local nTotRem  := 0

   DEFAULT cPath  := cPatEmp()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPath + "REMMOVT.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "REMMOV", @dbfRemMov ) )
   SET ADSINDEX TO ( cPath + "REMMOVT.CDX" ) ADDITIVE

   USE ( cPath + "HISMOV.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
   SET ADSINDEX TO ( cPath + "HISMOV.CDX" ) ADDITIVE

   /*
   Cabeceras-------------------------------------------------------------------
   */

   ( dbfRemMov )->( ordSetFocus( 0 ) )

   ( dbfRemMov )->( dbGoTop() )
   while !( dbfRemMov )->( eof() )

      if Empty( ( dbfRemMov )->cSufRem )
         ( dbfRemMov )->cSufRem        := "00"
      end if

      ( dbfRemMov )->( dbSkip() )

   end while
   ( dbfRemMov )->( ordSetFocus( 1 ) )

   /*
   Lineas----------------------------------------------------------------------
   */

   ( dbfHisMov )->( ordSetFocus( 0 ) )

   ( dbfHisMov )->( dbGoTop() )
   while !( dbfHisMov )->( eof() )

      if Empty( ( dbfHisMov )->cSufRem )
         ( dbfHisMov )->cSufRem        := "00"
      end if

      if Empty( ( dbfHisMov )->dFecMov )

         dFecMov                       := RetFld( Str( ( dbfHisMov )->nNumRem ) + ( dbfHisMov )->cSufRem, dbfRemMov, "dFecRem", "cNumRem" )

         if Empty( dFecMov )
            dFecMov                    := CtoD( "01/01/" + Str( Year( Date() ) ) )
         end if

         ( dbfHisMov )->dFecMov        := dFecMov

      end if

      ( dbfHisMov )->( dbSkip() )

   end while

   ( dbfHisMov )->( ordSetFocus( 1 ) )

   /*
   Rellenamos los campos de totales--------------------------------------------
   */

   ( dbfRemMov )->( dbGoTop() )
   while !( dbfRemMov )->( eof() )

      if ( dbfRemMov )->nTotRem == 0

         if dbSeekInOrd( Str( ( dbfRemMov )->nNumRem ) + ( dbfRemMov )->cSufRem, "nNumRem", dbfHisMov )

            while Str( ( dbfRemMov )->nNumRem ) + ( dbfRemMov )->cSufRem == Str( ( dbfHisMov )->nNumRem ) + ( dbfHisMov )->cSufRem .and. !( dbfHisMov )->( Eof() )

               nTotRem                 += nTotLMovAlm( dbfHisMov )

               ( dbfHisMov )->( dbSkip() )

            end while

         end if

         ( dbfRemMov )->nTotRem        := nTotRem

      end if

      nTotRem                          := 0

      ( dbfRemMov )->( dbSkip() )

   end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de movimientos de almacén" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfRemMov )
   CLOSE ( dbfHisMov )

return nil

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDetMovimientos FROM TDet

   DATA  cOldCodArt        INIT  ""
   DATA  cOldLote          INIT  ""
   DATA  cOldValPr1        INIT  ""
   DATA  cOldValPr2        INIT  ""

   DATA  nStockActual      INIT  0
   DATA  aStockActual

   DATA  oRefMov
   DATA  oValPr1
   DATA  oValPr2
   DATA  oSayVp1
   DATA  cSayVp1           INIT  ""
   DATA  oSayVp2
   DATA  cSayVp2           INIT  ""
   DATA  oSayPr1
   DATA  cSayPr1           INIT  ""
   DATA  oSayPr2
   DATA  cSayPr2           INIT  ""
   DATA  oSayCaj
   DATA  cSayCaj           INIT  ""
   DATA  oSayUnd
   DATA  cSayUnd           INIT  ""
   DATA  oSayLote
   DATA  oGetLote
   DATA  oGetDetalle
   DATA  cGetDetalle       INIT  ""

   DATA  oCajMov
   DATA  oUndMov

   DATA  oGetStockOrigen
   DATA  oGetStockDestino

   DATA  oGetAlmacenOrigen
   DATA  oGetAlmacenDestino

   DATA  oTxtAlmacenOrigen
   DATA  oTxtAlmacenDestino

   DATA  cTxtAlmacenOrigen
   DATA  cTxtAlmacenDestino


   DATA  oPreDiv

   DATA  oBrwPrp
   DATA  oBrwStock

   DATA  oBtnSerie

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode, lLiteral )
   METHOD ValidResource( nMode, oDlg, oBtn )

   METHOD RollBack()

   METHOD LoaArt( oDlg, lValidDetalle, nMode )

   METHOD Save()
   METHOD Asigna()

   METHOD AppendKit()
   METHOD ActualizaKit( nMode )

   METHOD nStockActualAlmacen( cCodAlm )

   METHOD SetDlgMode( nMode )

   METHOD aStkArticulo()

   METHOD nTotRemVir( lPic )
   METHOD nTotUnidadesVir( lPic )
   METHOD nTotVolumenVir( lPic )
   METHOD nTotPesoVir( lPic )

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName ) CLASS TDetMovimientos

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "HisMov"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPatTmp() )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS "HisMov" ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia )

      FIELD NAME "dFecMov"             TYPE "D" LEN   8 DEC 0 COMMENT "Fecha movimiento"                    OF oDbf
      FIELD NAME "cTimMov"             TYPE "C" LEN   5 DEC 0 COMMENT "Hora movimiento"                     OF oDbf
      FIELD NAME "nTipMov"             TYPE "N" LEN   1 DEC 0 COMMENT "Tipo movimiento"                     OF oDbf
      FIELD NAME "cAliMov"             TYPE "C" LEN  16 DEC 0 COMMENT "Alm. ent."                           OF oDbf
      FIELD NAME "cAloMov"             TYPE "C" LEN  16 DEC 0 COMMENT "Alm. sal."                           OF oDbf
      FIELD NAME "cRefMov"             TYPE "C" LEN  18 DEC 0 COMMENT "Código"                              OF oDbf
      FIELD NAME "cCodMov"             TYPE "C" LEN   2 DEC 0 COMMENT "TM"                                  OF oDbf
      FIELD NAME "cCodPr1"             TYPE "C" LEN  20 DEC 0 COMMENT "Cod. propiedad 1"                    OF oDbf
      FIELD NAME "cCodPr2"             TYPE "C" LEN  20 DEC 0 COMMENT "Cod. propiedad 2"                    OF oDbf
      FIELD NAME "cValPr1"             TYPE "C" LEN  20 DEC 0 COMMENT "Prp.1"                               OF oDbf
      FIELD NAME "cValPr2"             TYPE "C" LEN  20 DEC 0 COMMENT "Prp.2"                               OF oDbf
      FIELD NAME "cCodUsr"             TYPE "C" LEN   3 DEC 0 COMMENT "Código usuario"                      OF oDbf
      FIELD NAME "cCodDlg"             TYPE "C" LEN   2 DEC 0 COMMENT "Código delegación"                   OF oDbf
      FIELD NAME "lLote"               TYPE "L" LEN   1 DEC 0 COMMENT "Lógico lote"                         OF oDbf
      FIELD NAME "nLote"               TYPE "N" LEN   9 DEC 0 COMMENT "Número de lote"                      OF oDbf
      FIELD NAME "cLote"               TYPE "C" LEN  12 DEC 0 COMMENT "Lote"                                OF oDbf
      FIELD NAME "nCajMov"             TYPE "N" LEN  19 DEC 6 PICTURE {|| MasUnd() } COMMENT "Caj."         OF oDbf
      FIELD NAME "nUndMov"             TYPE "N" LEN  19 DEC 6 PICTURE {|| MasUnd() } COMMENT "Und."         OF oDbf
      FIELD NAME "nCajAnt"             TYPE "N" LEN  19 DEC 6 COMMENT "Caj. ant."                           OF oDbf
      FIELD NAME "nUndAnt"             TYPE "N" LEN  19 DEC 6 COMMENT "Und. ant."                           OF oDbf
      FIELD NAME "nPreDiv"             TYPE "N" LEN  19 DEC 6 PICTURE {|| PicOut() } COMMENT "Precio"       OF oDbf
      FIELD NAME "lSndDoc"             TYPE "L" LEN   1 DEC 0 COMMENT "Lógico enviar"                       OF oDbf
      FIELD NAME "nNumRem"             TYPE "N" LEN   9 DEC 0 COMMENT "Número remesa"                       OF oDbf
      FIELD NAME "cSufRem"             TYPE "C" LEN   2 DEC 0 COMMENT "Sufijo remesa"                       OF oDbf
      FIELD NAME "lSelDoc"             TYPE "L" LEN   1 DEC 0 COMMENT "Lógico selecionar"                   OF oDbf
      FIELD NAME "lNoStk"              TYPE "L" LEN   1 DEC 0 COMMENT "Lógico no stock"                     OF oDbf
      FIELD NAME "lKitArt"             TYPE "L" LEN   1 DEC 0 COMMENT "Línea con escandallo"                OF oDbf
      FIELD NAME "lKitEsc"             TYPE "L" LEN   1 DEC 0 COMMENT "Línea perteneciente a escandallo"    OF oDbf
      FIELD NAME "lImpLin"             TYPE "L" LEN   1 DEC 0 COMMENT "Lógico imprimir linea"               OF oDbf
      FIELD NAME "lKitPrc"             TYPE "L" LEN   1 DEC 0 COMMENT "Lógico precio escandallo"            OF oDbf
      FIELD NAME "nNumLin"             TYPE "N" LEN   4 DEC 0 COMMENT "Número de linea"                     OF oDbf
      FIELD NAME "mNumSer"             TYPE "M" LEN  10 DEC 0 COMMENT "Numeros de serie"                    OF oDbf
      FIELD NAME "nVolumen"            TYPE "N" LEN  16 DEC 6 COMMENT "Volumen del producto"                OF oDbf
      FIELD NAME "cVolumen"            TYPE "C" LEN   2 DEC 0 COMMENT "Unidad del volumen"                  OF oDbf
      FIELD NAME "nPesoKg"             TYPE "N" LEN  16 DEC 6 COMMENT "Peso del producto"                   OF oDbf
      FIELD NAME "cPesoKg"             TYPE "C" LEN   2 DEC 0 COMMENT "Unidad de peso del producto"         OF oDbf

      INDEX TO ( cFileName ) TAG "nNumRem" ON "Str( nNumRem ) + cSufRem"               NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "dFecMov" ON "Dtoc( dFecMov ) + cTimMov"              NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cRefMov" ON "cRefMov + cValPr1 + cValPr2 + cLote"    NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cAloMov" ON "cAloMov"                                NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cAliMov" ON "cAliMov"                                NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cRefAlm" ON "cRefMov + cValPr1 + cValPr2 + cAliMov"  NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "cLote"   ON "cLote"                                  NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "nNumLin" ON "Str( nNumLin )"                         NODELETED                     OF oDbf
      INDEX TO ( cFileName ) TAG "lSndDoc" ON "lSndDoc"                                NODELETED                              FOR "lSndDoc"        OF oDbf
      INDEX TO ( cFileName ) TAG "nTipMov" ON "cRefMov + Dtos( dFecMov )"              NODELETED                              FOR "nTipMov == 4"   OF oDbf
      INDEX TO ( cFileName ) TAG "cStock"  ON "cRefMov + cAliMov + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 + cLote"  NODELETED  FOR "nTipMov == 4"   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TDetMovimientos

   local lOpen             := .t.
   local oBlock

   DEFAULT  lExclusive     := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      lOpen                := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetMovimientos

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf         := nil
   end if

RETURN .t.

//---------------------------------------------------------------------------//
/*
Edita las lineas de Detalle
*/

METHOD Resource( nMode ) CLASS TDetMovimientos

   local oDlg
   local oBtn
   local oSayPre
   local nStockOrigen      := 0
   local nStockDestino     := 0
   local oTotUnd
   local cSayLote          := 'Lote'
   local oBtnSer
   local oSayTotal

   if nMode == APPD_MODE
      ::oDbfVir:nUndMov    := 1
      ::oDbfVir:nNumLin    := nLastNum( ::oDbfVir:cAlias )
   end if

   ::cOldCodArt            := ::oDbfVir:cRefMov
   ::cOldValPr1            := ::oDbfVir:cValPr1
   ::cOldValPr2            := ::oDbfVir:cValPr2
   ::cOldLote              := ::oDbfVir:cLote

   ::cGetDetalle           := oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "Nombre" )

   ::aStockActual          := { { "", "", "", "", "", 0, 0, 0 } }

   ::cTxtAlmacenOrigen     := oRetFld( ::oParent:oDbf:cAlmOrg, ::oParent:oAlm )
   ::cTxtAlmacenDestino    := oRetFld( ::oParent:oDbf:cAlmDes, ::oParent:oAlm )

   DEFINE DIALOG oDlg RESOURCE "LMovAlm" TITLE lblTitle( nMode ) + "lineas de movimientos de almacén"

      REDEFINE GET ::oRefMov VAR ::oDbfVir:cRefMov ;
			ID 		100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oRefMov:bValid     := {|| if( !Empty( ::oDbfVir:cRefMov ), ::LoaArt( oDlg, .f., nMode ), .t. ) }
      ::oRefMov:bHelp      := {|| BrwArticulo( ::oRefMov, ::oGetDetalle , , , , ::oGetLote, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oValPr1, ::oValPr2  ) }

      REDEFINE GET ::oGetDetalle VAR ::cGetDetalle ;
			ID 		110 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE LISTBOX ::oBrwPrp ;
         FIELDS   "" ;
         HEAD     "" ;
         ID       600 ;
         OF       oDlg

      REDEFINE SAY ::oSayLote VAR cSayLote ;
         ID       154;
         OF       oDlg

      REDEFINE GET ::oGetLote VAR ::oDbfVir:cLote ;
         ID       155 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oGetLote:bValid    := {|| if( !Empty( ::oDbfVir:cLote ), ::LoaArt( oDlg, .f., nMode ), .t. ) }

      REDEFINE GET ::oValPr1 VAR ::oDbfVir:cValPr1;
         ID       120 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oValPr1:bValid     := {|| if( lPrpAct( ::oValPr1, ::oSayVp1, ::oDbfVir:cCodPr1, ::oParent:oTblPro:cAlias ), ::LoaArt( oDlg, .f., nMode ), .f. ) }
      ::oValPr1:bHelp      := {|| brwPrpAct( ::oValPr1, ::oSayVp1, ::oDbfVir:cCodPr1 ) }

      REDEFINE GET ::oSayVp1 VAR ::cSayVp1;
         ID       121 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE SAY ::oSayPr1 PROMPT "Propiedad 1";
         ID       122 ;
         OF       oDlg

      REDEFINE GET ::oValPr2 VAR ::oDbfVir:cValPr2;
         ID       130 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oValPr2:bValid     := {|| if( lPrpAct( ::oValPr2, ::oSayVp2, ::oDbfVir:cCodPr2, ::oParent:oTblPro:cAlias ), ::LoaArt( oDlg, .f., nMode ), .f. ) }
      ::oValPr2:bHelp      := {|| brwPrpAct( ::oValPr2, ::oSayVp2, ::oDbfVir:cCodPr2 ) }

      REDEFINE GET ::oSayVp2 VAR ::cSayVp2 ;
         ID       131 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE SAY ::oSayPr2 PROMPT "Propiedad 2";
         ID       132 ;
         OF       oDlg

      REDEFINE GET ::oCajMov VAR ::oDbfVir:nCajMov;
         ID       140;
			SPINNER ;
         WHEN     ( lUseCaj() .AND. nMode != ZOOM_MODE ) ;
         ON CHANGE( oTotUnd:Refresh(), oSayPre:Refresh() );
         VALID    ( oTotUnd:Refresh(), oSayPre:Refresh(), .t. );
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      REDEFINE SAY ::oSayCaj PROMPT cNombreCajas(); 
         ID       142 ;
         OF       oDlg

      REDEFINE GET ::oUndMov VAR ::oDbfVir:nUndMov ;
         ID       150;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( oTotUnd:Refresh(), oSayPre:Refresh() );
         VALID    ( oTotUnd:Refresh(), oSayPre:Refresh(), .t. );
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      REDEFINE SAY ::oSayUnd PROMPT cNombreUnidades() ;
         ID       152 ;
         OF       oDlg

      REDEFINE SAY oTotUnd PROMPT nTotNMovAlm( ::oDbfVir ) ;
         ID       160;
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      REDEFINE GET ::oPreDiv VAR ::oDbfVir:nPreDiv ;
         ID       180 ;
         IDSAY    181 ;
			SPINNER ;
         ON CHANGE( oSayPre:Refresh() ) ;
         VALID    ( oSayPre:Refresh(), .t. ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPinDiv ;
			OF 		oDlg

      REDEFINE SAY oSayTotal ;
         ID       191 ;
         OF       oDlg

      REDEFINE SAY oSayPre PROMPT nTotLMovAlm( ::oDbfVir ) ;
         ID       190 ;
         PICTURE  ::oParent:cPirDiv ;
			OF 		oDlg

     
      /*
      Almacen origen-----------------------------------------------------------
      */

      REDEFINE GET ::oGetAlmacenOrigen VAR ::oParent:oDbf:cAlmOrg ;
         ID       400 ;
         IDSAY    403 ;
         WHEN     ( .f. ) ;
         BITMAP   "Lupa" ;
         OF       oDlg

      REDEFINE GET ::oTxtAlmacenOrigen VAR ::cTxtAlmacenOrigen ;
         ID       401 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oGetStockOrigen VAR nStockOrigen ;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPicUnd ;
         ID       402 ;
         IDSAY    404 ;
         OF       oDlg

      /*
      Almacen destino-----------------------------------------------------------
      */

      REDEFINE GET ::oGetAlmacenDestino VAR ::oParent:oDbf:cAlmDes ;
         ID       410 ;
         WHEN     ( .f. ) ;
         BITMAP   "Lupa" ;
         OF       oDlg

      REDEFINE GET ::oTxtAlmacenDestino VAR ::cTxtAlmacenDestino ;
         ID       411 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oGetStockDestino VAR nStockDestino ;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPicUnd ;
         ID       412 ;
         OF       oDlg

      /*
      Peso y volumen-----------------------------------------------------------
      */

      REDEFINE GET ::oDbfVir:nPesoKg ;
         ID       200 ;
         WHEN     ( .f. ) ;
         PICTURE  "@E 999.99";
         OF       oDlg

      REDEFINE GET ::oDbfVir:cPesoKg ;
         ID       210 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oDbfVir:nVolumen ;
         ID       220 ;
         WHEN     ( .f. ) ;
         PICTURE  "@E 999.99";
         OF       oDlg

      REDEFINE GET ::oDbfVir:cVolumen ;
         ID       230 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE BUTTON ::oBtnSerie ;
         ID       500 ;
			OF 		oDlg ;
         ACTION   ( nil )

      ::oBtnSerie:bAction     := {|| ::oParent:oDetSeriesMovimientos:Resource( nMode ) }

      REDEFINE BUTTON oBtn;
         ID       510 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   (  ::ValidResource( nMode, oDlg, oBtn ) )

		REDEFINE BUTTON ;
         ID       520 ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE

         if uFieldEmpresa( "lGetLot")
            oDlg:AddFastKey( VK_RETURN,   {|| oBtn:SetFocus(), oBtn:Click() } )
         end if 

         oDlg:AddFastKey( VK_F5, {|| oBtn:Click() } )

         oDlg:AddFastKey( VK_F6, {|| ::oBtnSerie:Click() } )
         
      end if

      oDlg:bStart             := {|| ::SetDlgMode( nMode, oSayTotal, oSayPre ) }

   oDlg:Activate( , , , .t., , , {|| EdtDetMenu( Self, oDlg ) } )

   /*
   Salida del dialogo----------------------------------------------------------
   */

   if ( oDlg:nResult == IDOK )
      ::oDbfVir:lSelDoc       := .t.
   end if

   EndEdtDetMenu()

RETURN ( oDlg:nResult )

//--------------------------------------------------------------------------//

Static Function EdtDetMenu( oThis, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar de artículo";
               MESSAGE  "Modificar la ficha del artículo" ;
               RESOURCE "Cube_Yellow_16";
               ACTION   ( EdtArticulo( oThis:oRefMov:VarGet() ) );

            MENUITEM    "&2. Informe de artículo";
               MESSAGE  "Abrir el informe del artículo" ;
               RESOURCE "Info16";
               ACTION   ( InfArticulo( oThis:oRefMov:VarGet() ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//---------------------------------------------------------------------------//

Static Function EndEdtDetMenu()

Return( oMenu:End() )

//---------------------------------------------------------------------------//

METHOD ValidResource( nMode, oDlg, oBtn ) CLASS TDetMovimientos

   local n
   local i
   local cLote
   local lProp       := .f.
   local lFound
   local cRefMov
   local nCajMov
   local nUndMov
   local cCodPr1
   local cCodPr2
   local cValPr1
   local cValPr2
   local nStkAct     := 0
   local nTotUnd     := 0
   local dFecMov
   local cTimMov
   local nTipMov
   local cAliMov
   local cAloMov
   local cCodMov
   local lNowSer
   local lNumSer

   oBtn:SetFocus()

   if nMode == APPD_MODE .and. !::LoaArt( nil, .t., nMode )
      ::oRefMov:SetFocus()
      Return .f.
   end if

   if Empty( ::oDbfVir:cRefMov )
      MsgStop( "Código de artículo vacío." )
      ::oRefMov:SetFocus()
      Return .f.
   end if

   /*
   Control para numeros de serie-----------------------------------------------
   */

   lNumSer           := RetFld( ::oDbfVir:cRefMov, ::oParent:oArt:cAlias, "lNumSer" )
   lNowSer           := ::oParent:oDetSeriesMovimientos:oDbfVir:SeekInOrd( Str( ::oDbfVir:nNumLin, 4 ) + ::oDbfVir:cRefMov, "nNumLin" )

   if ( nMode == APPD_MODE )                                            .and.;
      ( lNumSer )                                                       .and.;
      (!lNowSer )                                                       .and.;
      ( ::oParent:oDbf:nTipMov != 3 )

      MsgStop( "Tiene que introducir números de serie para este artículo." )

      ::oBtnSerie:Click()

      Return .f.

   end if

   CursorWait()

   lFound            := .f.

   do case
   case ( nMode == APPD_MODE .and. !lNumSer )

      cRefMov        := ::oDbfVir:cRefMov
      nCajMov        := ::oDbfVir:nCajMov
      nUndMov        := ::oDbfVir:nUndMov
      cLote          := ::oDbfVir:cLote
      cCodPr1        := ::oDbfVir:cCodPr1
      cCodPr2        := ::oDbfVir:cCodPr2
      cValPr1        := ::oDbfVir:cValPr1
      cValPr2        := ::oDbfVir:cValPr2

      ::oDbfVir:GetStatus()

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         if !( lNowSer )                                    .and. ; // sin numeros de serie
            ::oDbfVir:FieldGetName( "cRefMov" ) == cRefMov  .and. ;
            ::oDbfVir:FieldGetName( "cLote"   ) == cLote    .and. ;
            ::oDbfVir:FieldGetName( "cCodPr1" ) == cCodPr1  .and. ;
            ::oDbfVir:FieldGetName( "cCodPr2" ) == cCodPr2  .and. ;
            ::oDbfVir:FieldGetName( "cValPr1" ) == cValPr1  .and. ;
            ::oDbfVir:FieldGetName( "cValPr2" ) == cValPr2  .and. ;
            ::oDbfVir:FieldGetName( "nCajMov" ) == nCajMov

            nCajMov  += ::oDbfVir:FieldGetName( "nCajMov" )
            nUndMov  += ::oDbfVir:FieldGetName( "nUndMov" )

            ::oDbfVir:FieldPutByName( "nCajMov", nCajMov )
            ::oDbfVir:FieldPutByName( "nUndMov", nUndMov )

            if ::oDbfVir:FieldGetName( "lKitArt" )
               ::ActualizaKit( nMode )
            end if

            lFound   := .t.

            exit

         end if

         ::oDbfVir:Skip()

      end while

      ::oDbfVir:SetStatus()

   case nMode == EDIT_MODE

      ::ActualizaKit( nMode )

   end case

   /*
   Control de stock solo para movimeintos entre almacenes----------------------
   Avisamos en movimientos con stock bajo minimo-------------------------------
   */

   if ( ::oDbf:nTipMov == 1 )

      nTotUnd        := nTotNRemMov( ::oDbfVir )
      nStkAct        := ::nStockActualAlmacen( ::oParent:oDbf:cAlmOrg )

      if nTotUnd != 0 .and. oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "lMsgMov" )

         if ( nStkAct - nTotUnd ) < oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "nMinimo" )

            if !ApoloMsgNoYes( "El stock está por debajo del minimo.", "¿Desea continuar?" )
               return nil
            end if

         end if

      end if

   end if

   /*
   Añadimos las lineas creadas por la rejilla de datos-------------------------
   */

   if !Empty( ::oBrwPrp:Cargo )

      /*
      Tomamos algunos datos----------------------------------------------------
      */

      dFecMov  := ::oDbfVir:dFecMov
      cTimMov  := ::oDbfVir:cTimMov
      nTipMov  := ::oDbfVir:nTipMov
      cAliMov  := ::oDbfVir:cAliMov
      cAloMov  := ::oDbfVir:cAloMov
      cCodMov  := ::oDbfVir:cCodMov
      cRefMov  := ::oDbfVir:cRefMov

      /*
      Metemos las lineas por propiedades---------------------------------------
      */

      for n := 1 to len( ::oBrwPrp:Cargo )

         for i := 1 to len( ::oBrwPrp:Cargo[ n ] )

            if IsNum( ::oBrwPrp:Cargo[ n, i ]:Value ) .and. ::oBrwPrp:Cargo[ n, i ]:Value != 0

               ::oDbfVir:Append()

               ::oDbfVir:dFecMov    := dFecMov
               ::oDbfVir:cTimMov    := cTimMov
               ::oDbfVir:nTipMov    := nTipMov
               ::oDbfVir:cAliMov    := cAliMov
               ::oDbfVir:cAloMov    := cAloMov
               ::oDbfVir:cCodMov    := cCodMov
               ::oDbfVir:cRefMov    := cRefMov
               ::oDbfVir:cCodPr1    := ::oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad1
               ::oDbfVir:cCodPr2    := ::oBrwPrp:Cargo[ n, i ]:cCodigoPropiedad2
               ::oDbfVir:cValPr1    := ::oBrwPrp:Cargo[ n, i ]:cValorPropiedad1
               ::oDbfVir:cValPr2    := ::oBrwPrp:Cargo[ n, i ]:cValorPropiedad2
               ::oDbfVir:cCodUsr    := cCurUsr()
               ::oDbfVir:cCodDlg    := oRetFld( cCurUsr(), ::oParent:oUsr, "cCodDlg" )
               ::oDbfVir:nCajMov    := 1
               ::oDbfVir:nUndMov    := ::oBrwPrp:Cargo[ n, i ]:Value
               ::oDbfVir:nPreDiv    := ::oBrwPrp:Cargo[ n, i ]:nPrecioCompra
               ::oDbfVir:lSndDoc    := .t.
               ::oDbfVir:nNumLin    := nLastNum( ::oDbfVir:cAlias )
               ::oDbfVir:nVolumen   := oRetFld( cRefMov, ::oParent:oArt, "" )
               ::oDbfVir:cVolumen   := oRetFld( cRefMov, ::oParent:oArt, "" )
               ::oDbfVir:nPesoKg    := oRetFld( cRefMov, ::oParent:oArt, "" )
               ::oDbfVir:cPesoKg    := oRetFld( cRefMov, ::oParent:oArt, "" )

               ::oDbfVir:Save()

            end if

         next

      next

      lProp       := .t.

   end if

   ::cOldCodArt   := ""
   ::cOldValPr1   := ""
   ::cOldValPr2   := ""
   ::cOldLote     := ""

   CursorWE()

   if lProp
      oDlg:end( IDCANCEL )
   else
      if lFound
         oDlg:end( IDFOUND )
      else
         oDlg:end( IDOK )
      end if
   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD RollBack() CLASS TDetMovimientos

   ::oParent:GetFirstKey()

   if ::oParent:cFirstKey != nil

      while ::oDbf:Seek( ::oParent:cFirstKey )

         ::oDbf:Delete()

         if !Empty( ::oParent ) .and. !Empty( ::oParent:oMeter )
            ::oParent:oMeter:AutoInc()
         end if

      end while

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD LoaArt( oDlg, lValidDetalle, nMode ) CLASS TDetMovimientos

   local a
   local nPos
   local nPreMed
   local cValPr1           := ""
   local cValPr2           := ""
   local cCodArt           := ""
   local lChgCodArt        := .f.

   DEFAULT lValidDetalle   := .f.

   if Empty( ::oDbfVir:cRefMov )
      if !Empty( ::oBrwPrp )
         ::oBrwPrp:Hide()
      end if
      Return .t.
   end if

   // Detectamos si hay cambios en los codigos y propiedades-------------------

   lChgCodArt              := ( Rtrim( ::cOldCodArt ) != Rtrim( ::oDbfVir:cRefMov ) .or. ::cOldLote != ::oDbfVir:cLote .or. ::cOldValPr1 != ::oDbfVir:cValPr1 .or. ::cOldValPr2 != ::oDbfVir:cValPr2 )

   // Conversión a codigo interno-------------------------------------------------

   cCodArt                 := cSeekCodebar( ::oDbfVir:cRefMov, ::oParent:oDbfBar:cAlias, ::oParent:oArt:cAlias )

   // Articulos con numeros de serie no podemos pasarlo en regularizacion por objetivos

   if ( ::oParent:oDbf:nTipMov == 3 ) .and. ( RetFld( cCodArt, ::oParent:oArt:cAlias, "lNumSer" ) )

      MsgStop( "Artículos con números de serie no pueden incluirse regularizaciones por objetivo." )

      Return .f.

   end if

   // Ahora buscamos por el codigo interno----------------------------------------

   if aSeekProp( @cCodArt, @cValPr1, @cValPr2, ::oParent:oArt:cAlias, ::oParent:oTblPro:cAlias )// ::oArt:Seek( xVal ) .OR. ::oArt:Seek( Upper( xVal ) )

      if !lValidDetalle

         CursorWait()

         if ( lChgCodArt )

            ::oRefMov:cText( ::oParent:oArt:Codigo )

            // Nombre-------------------------------------------------------------

            ::oGetDetalle:cText( ::oParent:oArt:Nombre )

            // Propiedades--------------------------------------------------------

            if !Empty( cValPr1 )
               ::oValPr1:cText( cValPr1 )
            end if

            if !Empty( cValPr2 )
               ::oValPr2:cText( cValPr2 )
            end if

            // Dejamos pasar a los productos de tipo kit-----------------------

            if ::oParent:oArt:lKitArt
               ::oDbfVir:lNoStk     := !lStockCompuestos( ::oParent:oArt:Codigo, ::oParent:oArt:cAlias )
               ::oDbfVir:lKitArt    := .t.
               ::oDbfVir:lKitEsc    := .f.
               ::oDbfVir:lImpLin    := lImprimirCompuesto( ::oParent:oArt:Codigo, ::oParent:oArt:cAlias )
               ::oDbfVir:lKitPrc    := !lPreciosCompuestos( ::oParent:oArt:Codigo, ::oParent:oArt:cAlias )
            else
               ::oDbfVir:lNoStk     := ( ::oParent:oArt:nCtlStock > 1 )
               ::oDbfVir:lKitArt    := .f.
               ::oDbfVir:lKitEsc    := .f.
               ::oDbfVir:lImpLin    := .f.
               ::oDbfVir:lKitPrc    := .f.
            end if

            if ::oParent:oArt:nCajEnt != 0 .and. ::oDbfVir:nCajMov == 0
               ::oCajMov:cText( ::oParent:oArt:nCajEnt )
            end if

            if ::oParent:oArt:nUniCaja != 0 .and. ::oDbfVir:nUndMov == 0
               ::oUndMov:cText( ::oParent:oArt:nUniCaja )
            end if

            /*
            Peso y Volumen--------------------------------------------------------
            */

            ::oDbfVir:nVolumen      := ::oParent:oArt:nVolumen
            ::oDbfVir:cVolumen      := ::oParent:oArt:cVolumen
            ::oDbfVir:nPesoKg       := ::oParent:oArt:nPesoKg
            ::oDbfVir:cPesoKg       := ::oParent:oArt:cUndDim

            /*
            Lotes-----------------------------------------------------------------
            */

            ::oDbfVir:lLote         := ::oParent:oArt:lLote

            if ::oParent:oArt:lLote
               ::oSayLote:Show()
               ::oGetLote:Show()
            else
               ::oSayLote:Hide()
               ::oGetLote:Hide()
            end if

            /*
            Propiedades--------------------------------------------------------------
            */

            ::oDbfVir:cCodPr1       := ::oParent:oArt:cCodPrp1
            ::oDbfVir:cCodPr2       := ::oParent:oArt:cCodPrp2

            if ( !Empty( ::oDbfVir:cCodPr1 ) .or. !Empty( ::oDbfVir:cCodPr2 ) )     .and.;
               (  !lEmptyProp( ::oDbfVir:cCodPr1, ::oParent:oTblPro:cAlias ) .or.;
                  !lEmptyProp( ::oDbfVir:cCodPr2, ::oParent:oTblPro:cAlias ) )      .and.;
               ( Empty( ::oDbfVir:cValPr1 ) .or. Empty( ::oDbfVir:cValPr2 ) )       .and.;
               ( uFieldEmpresa( "lUseTbl" )                                         .and.;
               ( nMode == APPD_MODE ) )

               ::oBrwPrp:Show()

               ::oValPr1:Hide()
               ::oSayPr1:Hide()
               ::oSayVp1:Hide()
               ::oValPr2:Hide()
               ::oSayPr2:Hide()
               ::oSayVp2:Hide()
               
               ::oSayLote:Hide()
               ::oGetLote:Hide()

               LoadPropertiesTable( ::oParent:oArt:Codigo, 0, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oParent:oPro:cAlias, ::oParent:oTblPro:cAlias, ::oParent:oArtCom:cAlias, ::oBrwPrp, ::oUndMov, ::oPreDiv )

            else

               if !Empty( ::oDbfVir:cCodPr1 )
                  ::oValPr1:show()
                  ::oSayPr1:show()
                  ::oSayPr1:setText( retProp( ::oDbfVir:cCodPr1 ) )
                  ::oSayVp1:show()
               else
                  ::oValPr1:Hide()
                  ::oSayPr1:Hide()
                  ::oSayVp1:Hide()
               end if

               if !Empty( ::oDbfVir:cCodPr2 )
                  ::oValPr2:show()
                  ::oSayPr2:show()
                  ::oSayPr2:setText( retProp( ::oDbfVir:cCodPr2 ) )
                  ::oSayVp2:show()
               else
                  ::oValPr2:Hide()
                  ::oSayPr2:Hide()
                  ::oSayVp2:Hide()
               end if

               /*
               Posicionar el foco----------------------------------------------------
               */

               do case
                  case !Empty( ::oDbfVir:cCodPr1 ) .and. Empty( ::oDbfVir:cValPr1 )
                     ::oValPr1:SetFocus()

                  case !Empty( ::oDbfVir:cCodPr2 ) .and. Empty( ::oDbfVir:cValPr2 )
                     ::oValPr2:SetFocus()

                  otherwise
                     ::oUndMov:SetFocus()

               end case

            end if

            /*
            Precios medios--------------------------------------------------------
            */

            if !uFieldEmpresa( "lCosAct" )
               
               nPreMed     := ::oParent:oStock:nCostoMedio( ::oParent:oArt:Codigo, ::oParent:oDbf:cAlmDes, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote )

               if nPreMed == 0
                  nPreMed  := nCosto( ::oParent:oArt:Codigo, ::oParent:oArt:cAlias, ::oParent:oArtKit:cAlias )
               end if

            else

               nPreMed     := nCosto( ::oParent:oArt:Codigo, ::oParent:oArt:cAlias, ::oParent:oArtKit:cAlias )

            end if

            ::oPreDiv:cText( nPreMed )

            /*
            Stock actual-------------------------------------------------------
            */

            // ::aStkArticulo()

            ::oParent:oStock:lPutStockActual( ::oDbfVir:cRefMov, ::oParent:oDbf:cAlmOrg, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote, .f., ::oParent:oArt:nCtlStock, ::oGetStockOrigen )

            /*
            Guardamos el stock anterior----------------------------------------
            */

            SysRefresh()

            nPos                 := aScan( ::oParent:oStock:aStocks, {|o| o:cCodigo == ::oParent:oArt:Codigo .and. o:cCodigoAlmacen == ::oParent:oDbf:cAlmDes .and. o:cValorPropiedad1 == ::oDbfVir:cValPr1 .and. o:cValorPropiedad2 == ::oDbfVir:cValPr2 .and. o:cLote == ::oDbfVir:cLote .and. o:cNumeroSerie == ::oDbfVir:mNumSer } )
            if ( nPos != 0 ) .and. IsNum( ::oParent:oStock:aStocks[ nPos ]:nUnidades )
               ::oDbfVir:nUndAnt := ::oParent:oStock:aStocks[ nPos ]:nUnidades
            end if

         end if

         // Variables para no volver a ejecutar--------------------------------

         ::cOldCodArt            := ::oDbfVir:cRefMov
         ::cOldLote              := ::oDbfVir:cLote
         ::cOldValPr1            := ::oDbfVir:cValPr1
         ::cOldValPr2            := ::oDbfVir:cValPr2

         CursorWE()

      end if

   else

      if !lValidDetalle
         MsgStop( "Artículo no encontrado." )
      end if

      Return .f.

   end if

Return .t.

//--------------------------------------------------------------------------//

METHOD nStockActualAlmacen( cCodAlm ) CLASS TDetMovimientos

   local aStock      := {}
   local nTotStock   := 0

   for each aStock in ::aStockActual

      if aStock[1] == cCodAlm
         nTotStock   += aStock[6]
      end if

   next

RETURN nTotStock

//---------------------------------------------------------------------------//

METHOD SetDlgMode( nMode, oSayTotal, oSayPre ) CLASS TDetMovimientos

   ::oBrwPrp:Hide()

   if ( ::oParent:oDbf:nTipMov == 3 )
      ::oBtnSerie:Hide()
   end if

   if nMode == APPD_MODE

      ::oSayLote:Hide()
      ::oGetLote:Hide()

      ::oValPr1:Hide()
      ::oSayPr1:Hide()
      ::oSayVp1:Hide()

      ::oValPr2:Hide()
      ::oSayPr2:Hide()
      ::oSayVp2:Hide()

      if !lUseCaj()
         ::oCajMov:Hide()
         ::oSayCaj:Hide()
      end if

   else

      if ::oDbfVir:lLote
         ::oGetLote:Show()
         ::oSayLote:Show()
      else
         ::oGetLote:Hide()
         ::oSayLote:Hide()
      end if

      if !Empty( ::oDbfVir:cValPr1 )
         ::oSayPr1:Show()
         ::oSayVp1:Show()
         ::oValPr1:Show()
         ::oSayPr1:SetText( retProp( ::oDbfVir:cCodPr1 ) )
         lPrpAct( ::oDbfVir:cValPr1, ::oSayVp1, ::oDbfVir:cCodPr1, ::oParent:oTblPro:cAlias )
      else
         ::oValPr1:Hide()
         ::oSayPr1:Hide()
         ::oSayVp1:Hide()
      end if

      if !Empty( ::oDbfVir:cValPr2 )
         ::oSayPr2:Show()
         ::oSayVp2:Show()
         ::oValPr2:Show()
         ::oSayPr2:SetText( retProp( ::oDbfVir:cCodPr2 ) )
         lPrpAct( ::oDbfVir:cValPr2, ::oSayVp2, ::oDbfVir:cCodPr2, ::oParent:oTblPro:cAlias )
      else
         ::oValPr2:Hide()
         ::oSayPr2:Hide()
         ::oSayVp2:Hide()
      end if

      if !lUseCaj()
         ::oCajMov:Hide()
         ::oSayCaj:Hide()
         ::oSayUnd:SetText( "Unidades" )
      end if

   end if

   /*
   Ocultamos el costo si el usuario no tiene permisos para verlo---------------
   */

   if !Empty( ::oPreDiv ) .and. oUser():lNotCostos()
      ::oPreDiv:Hide()
   end if

   if !Empty( oSayTotal ) .and. oUser():lNotCostos()
      oSayTotal:Hide()
   end if

   if !Empty( oSayPre ) .and. oUser():lNotCostos()
      oSayPre:Hide()
   end if

   /*
   Cargamos la configuracion de columnas---------------------------------------
   */

   if Empty( ::oParent:oDbf:cAlmOrg )
      ::oGetAlmacenOrigen:Hide()
      ::oTxtAlmacenOrigen:Hide()
      ::oGetStockOrigen:Hide()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AppendKit() CLASS TDetMovimientos

   local nRec     := ::oDbfVir:Recno()
   local nNumLin  := ::oDbfVir:nNumLin
   local cCodArt  := ::oDbfVir:cRefMov
   local nTipMov  := ::oDbfVir:nTipMov
   local cAliMov  := ::oParent:oDbf:cAlmDes
   local cAloMov  := ::oParent:oDbf:cAlmOrg
   local cCodMov  := ::oDbfVir:cCodMov
   local nCajMov  := ::oDbfVir:nCajMov
   local nUndMov  := ::oDbfVir:nUndMov
   local nNumRem  := ::oDbfVir:nNumRem
   local cSufRem  := ::oDbfVir:cSufRem
   local cCodUsr  := ::oDbfVir:cCodUsr
   local cCodDlg  := ::oDbfVir:cCodDlg
   local nTotUnd  := 0
   local nStkAct  := 0
   local nMinimo  := 0

   if ::oParent:oArtKit:SeekInOrd( cCodArt, "cCodKit" )

      while ( ::oParent:oArtKit:cCodKit == cCodArt ) .and. !( ::oParent:oArtKit:Eof() )

         if ::oParent:oArt:SeekInOrd( ::oParent:oArtKit:cRefKit, "Codigo" ) .and. lStockComponentes( cCodArt, ::oParent:oArt:cAlias )

            nStkAct              := ::oParent:oStock:nStockAlmacen( ::oParent:oArtKit:cRefKit, cAloMov )

            ::oDbfVir:Append()

            ::oDbfVir:dFecMov    := GetSysDate()
            ::oDbfVir:cTimMov    := Time()
            ::oDbfVir:nTipMov    := nTipMov
            ::oDbfVir:cAliMov    := cAliMov
            ::oDbfVir:cAloMov    := cAloMov
            ::oDbfVir:cRefMov    := ::oParent:oArtKit:cRefKit
            ::oDbfVir:cCodMov    := cCodMov
            ::oDbfVir:cCodPr1    := Space( 20 )
            ::oDbfVir:cCodPr2    := Space( 20 )
            ::oDbfVir:cValPr1    := Space( 40 )
            ::oDbfVir:cValPr2    := Space( 40 )
            ::oDbfVir:cCodUsr    := cCodUsr
            ::oDbfVir:cCodDlg    := cCodDlg
            ::oDbfVir:lLote      := ::oParent:oArt:lLote
            ::oDbfVir:nLote      := ::oParent:oArt:nLote
            ::oDbfVir:cLote      := ::oParent:oArt:cLote
            ::oDbfVir:nCajMov    := nCajMov
            ::oDbfVir:nUndMov    := ::oParent:oArtKit:nUndKit * nUndMov

            if nTipMov == 3
               ::oDbfVir:nCajAnt := 0
               ::oDbfVir:nUndAnt := nStkAct
            end if

            ::oDbfVir:nPreDiv    := ::oParent:oArt:pCosto
            ::oDbfVir:lSndDoc    := .t.
            ::oDbfVir:nNumRem    := nNumRem
            ::oDbfVir:cSufRem    := cSufRem
            ::oDbfVir:lSelDoc    := .t.

            ::oDbfVir:lKitArt    := .f.
            ::oDbfVir:lNoStk     := .f.
            ::oDbfVir:lImpLin    := lImprimirComponente( cCodArt, ::oParent:oArt:cAlias )
            ::oDbfVir:lKitPrc    := !lPreciosComponentes( cCodArt, ::oParent:oArt:cAlias )

            if lKitAsociado( cCodArt, ::oParent:oArt:cAlias )
               ::oDbfVir:nNumLin := nLastNum( ::oDbfVir:cAlias )
               ::oDbfVir:lKitEsc := .f.
            else
               ::oDbfVir:nNumLin := nNumLin
               ::oDbfVir:lKitEsc := .t.
            end if

            /*
            Avisamos en movimientos con stock bajo minimo-------------------------------
            */

            nTotUnd              := NotCaja( ::oDbfVir:nCajMov ) * ::oDbfVir:nUndMov
            nMinimo              := oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "nMinimo" )

            if nTotUnd != 0 .and. oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "lMsgMov" )

               if ( ( nStkAct - nTotUnd ) < nMinimo )

                  MsgStop( "El stock del componente " + AllTrim( ::oDbfVir:cRefMov ) + " - " + AllTrim( oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "Nombre" ) ) + CRLF + ;
                           "está bajo minimo." + CRLF + ;
                           "Unidades a vender : " + AllTrim( Trans( nTotUnd, MasUnd() ) ) + CRLF + ;
                           "Stock actual : " + AllTrim( Trans( nStkAct, MasUnd() ) )      + CRLF + ;
                           "Stock minimo : " + AllTrim( Trans( nMinimo, MasUnd() ) ),;
                           "¡Atención!" )

               end if

            end if

            ::oDbfVir:Save()

         end if

         ::oParent:oArtKit:Skip()

      end while

   end if

   /*
   Volvemos al registro en el que estabamos y refrescamos el browse------------
   */

   ::oDbfVir:GoTo( nRec )

   ::oParent:oBrwDet:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD aStkArticulo() CLASS TDetMovimientos

   ::nStockActual       := 0

   if !Empty( ::oDbfVir:cRefMov ) .and. oRetFld( ::oDbfVir:cRefMov, ::oParent:oArt, "nCtlStock" ) <= 1

      ::oParent:oStock:aStockArticulo( ::oDbfVir:cRefMov, , ::oBrwStock )

      aEval( ::oBrwStock:aArrayData, {|o| ::nStockActual += o:nUnidades } )

      ::oBrwStock:Show()

   else

      ::oBrwStock:Hide()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActualizaKit( nMode ) CLASS TDetMovimientos

   local nRec     := ::oDbfVir:Recno()
   local nOrdAnt  := ::oDbfVir:OrdSetFocus( "nNumLin" )
   local cRefMov  := ::oDbfVir:cRefMov
   local nNumLin  := ::oDbfVir:FieldGetName( "nNumLin" )
   local nCajMov
   local nUndMov

   do case
      case nMode == APPD_MODE
         nCajMov  := ::oDbfVir:FieldGetName( "nCajMov" )
         nUndMov  := ::oDbfVir:FieldGetName( "nUndMov" )

      case nMode == EDIT_MODE
         nCajMov  := ::oDbfVir:nCajMov
         nUndMov  := ::oDbfVir:nUndMov

   end if

   ::oDbfVir:GoTop()

   while !::oDbfVir:Eof()

      if ::oDbfVir:FieldGetName( "nNumLin" ) == nNumLin        .and.;
         ::oDbfVir:FieldGetName( "lKitEsc" )                   .and.;
         ::oParent:oArtKit:SeekInOrd( cRefMov + ::oDbfVir:FieldGetName( "cRefMov" ), "cCodRef" )

         ::oDbfVir:FieldPutByName( "nCajMov", nCajMov )
         ::oDbfVir:FieldPutByName( "nUndMov", ( nUndMov * ::oParent:oArtKit:nUndKit ) )

      end if

      ::oDbfVir:Skip()

   end while

   ::oDbfVir:OrdSetFocus( nOrdAnt )

   ::oDbfVir:GoTo( nRec )

RETURN ( Self )

//---------------------------------------------------------------------------//

Method Save() CLASS TDetMovimientos

   local nSec

   /*
   Guardamos todo de manera definitiva-----------------------------------------
   */

   CursorWait()

   ::oDbfVir:KillFilter()

   ::oDbfVir:GetStatus()
   ::oDbfVir:OrdSetFocus( 0 )

   do case
   case ::oParent:oDbf:nTipMov == 1

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         ::oDbfVir:Load()
         ::Asigna()
         ::oDbfVir:Save()

         ::oDbf:AppendFromObject( ::oDbfVir )

         ::oDbfVir:Skip()

         ::oParent:oMeter:AutoInc()

      end while

   case ::oParent:oDbf:nTipMov == 2

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         ::oDbfVir:Load()
         ::Asigna()
         ::oDbfVir:Save()

         ::oDbf:AppendFromObject( ::oDbfVir )

         ::oDbfVir:Skip()

         ::oParent:oMeter:AutoInc()

      end while

   case ::oParent:oDbf:nTipMov == 3

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         if ::oDbfVir:lSelDoc

            ::oDbfVir:Load()
            ::Asigna()

            ::oDbfVir:lSelDoc := .f.
            ::oDbfVir:nUndMov := ( nTotNMovAlm( ::oDbfVir ) - nTotNMovOld( ::oDbfVir ) ) / NotCero( ::oDbfVir:nCajMov )
            ::oDbfVir:nUndAnt := 0
            ::oDbfVir:nCajAnt := 0

            ::oDbfVir:Save()

            ::oDbf:AppendFromObject( ::oDbfVir )

         else

            ::oDbfVir:Load()
            ::Asigna()
            ::oDbfVir:Save()

            ::oDbf:AppendFromObject( ::oDbfVir )

         end if

         ::oDbfVir:Skip()

         ::oParent:oMeter:AutoInc()

      end while

   case ::oParent:oDbf:nTipMov == 4

      ::oDbfVir:GoTop()
      while !::oDbfVir:Eof()

         ::Asigna()

         ::oDbf:AppendFromObject( ::oDbfVir )

         ::oDbfVir:Skip()

         ::oParent:oMeter:AutoInc()

      end while

   end case

   ::oDbfVir:SetStatus()

   CursorWE()

Return .t.

//---------------------------------------------------------------------------//

METHOD Asigna() CLASS TDetMovimientos

   ::oDbfVir:nNumRem    := ::oParent:oDbf:nNumRem
   ::oDbfVir:cSufRem    := ::oParent:oDbf:cSufRem
   ::oDbfVir:dFecMov    := ::oParent:oDbf:dFecRem
   ::oDbfVir:nTipMov    := ::oParent:oDbf:nTipMov
   ::oDbfVir:cCodMov    := ::oParent:oDbf:cCodMov
   ::oDbfVir:cAliMov    := ::oParent:oDbf:cAlmDes
   ::oDbfVir:cAloMov    := ::oParent:oDbf:cAlmOrg
   ::oDbfVir:cCodUsr    := ::oParent:oDbf:cCodUsr
   ::oDbfVir:cCodDlg    := ::oParent:oDbf:cCodDlg
   ::oDbfVir:lSndDoc    := .t.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotRemVir( lPic ) CLASS TDetMovimientos

   local nTot     := 0

   DEFAULT lPic   := .f.

   if ::oDbfVir != nil .and. ::oDbfVir:Used()

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

      while !::oDbfVir:eof()
         nTot     += nTotLMovAlm( ::oDbfVir )
         ::oDbfVir:Skip()
      end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nTot, ::oParent:cPirDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD nTotUnidadesVir( lPic ) CLASS TDetMovimientos

   local nTot     := 0

   DEFAULT lPic   := .f.

   if ::oDbfVir != nil .and. ::oDbfVir:Used()

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

      while !::oDbfVir:eof()
         nTot     += nTotNMovAlm( ::oDbfVir )
         ::oDbfVir:Skip()
      end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nTot, ::oParent:cPicUnd ), nTot ) )

//---------------------------------------------------------------------------//

METHOD nTotPesoVir( lPic ) CLASS TDetMovimientos

   local nPeso    := 0

   DEFAULT lPic   := .f.

   if ::oDbfVir != nil .and. ::oDbfVir:Used()

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

      while !::oDbfVir:Eof()
         nPeso    += ( NotCaja( ::oDbfVir:nCajMov ) * ::oDbfVir:nUndMov ) * ::oDbfVir:nPesoKg
         ::oDbfVir:Skip()
      end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nPeso, MasUnd() ), nPeso ) )

//---------------------------------------------------------------------------//

METHOD nTotVolumenVir( lPic ) CLASS TDetMovimientos

   local nVolumen    := 0

   DEFAULT lPic      := .f.

   if ::oDbfVir != nil .and. ::oDbfVir:Used()

      ::oDbfVir:GetStatus()
      ::oDbfVir:GoTop()

      while !::oDbfVir:Eof()
         nVolumen    += ( NotCaja( ::oDbfVir:nCajMov ) * ::oDbfVir:nUndMov ) * ::oDbfVir:nVolumen
         ::oDbfVir:Skip()
      end while

      ::oDbfVir:SetStatus()

   end if

RETURN ( if( lPic, Trans( nVolumen, MasUnd() ), nVolumen ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDetSeriesMovimientos FROM TDet

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD Save()

   METHOD RollBack()

   METHOD Resource( nMode, lLiteral )

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName ) CLASS TDetSeriesMovimientos

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "MovSer"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Números de serie de movimientos de almacen"

      FIELD NAME "nNumRem"    TYPE "N" LEN  9  DEC 0 PICTURE "999999999"                        HIDE        OF oDbf
      FIELD NAME "cSufRem"    TYPE "C" LEN  2  DEC 0 PICTURE "@!"                               HIDE        OF oDbf
      FIELD NAME "dFecRem"    TYPE "D" LEN  8  DEC 0                                            HIDE        OF oDbf
      FIELD NAME "nNumLin"    TYPE "N" LEN 04  DEC 0 COMMENT "Número de línea"                  COLSIZE  60 OF oDbf
      FIELD NAME "cCodArt"    TYPE "C" LEN 18  DEC 0 COMMENT "Artículo"                         COLSIZE  60 OF oDbf
      FIELD NAME "cAlmOrd"    TYPE "C" LEN 16  DEC 0 COMMENT "Almacén"                          COLSIZE  50 OF oDbf
      FIELD NAME "lUndNeg"    TYPE "L" LEN 01  DEC 0 COMMENT "Lógico de unidades en negativo"   HIDE        OF oDbf
      FIELD NAME "cNumSer"    TYPE "C" LEN 30  DEC 0 COMMENT "Número de serie"                  HIDE        OF oDbf

      INDEX TO ( cFileName ) TAG "cNumOrd" ON "Str( nNumRem ) + cSufRem + Str( nNumLin )"       NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodArt" ON "cCodArt + cAlmOrd + cNumSer"                     NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cNumSer" ON "cNumSer"                                         NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "nNumLin" ON "Str( nNumLin ) + cCodArt"                        NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TDetSeriesMovimientos

   local lOpen             := .t.
   local oBlock

   DEFAULT  lExclusive     := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      lOpen                := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetSeriesMovimientos

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf         := nil
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Save() CLASS TDetSeriesMovimientos

   local nNumRem  := ::oParent:oDbf:nNumRem
   local cSufRem  := ::oParent:oDbf:cSufRem
   local dFecRem  := ::oParent:oDbf:dFecRem
   local cAlmDes  := ::oParent:oDbf:cAlmDes

   ::oDbfVir:OrdSetFocus( 0 )

   ( ::oDbfVir:nArea )->( dbGoTop() )
   while !( ::oDbfVir:nArea )->( eof() )

      ( ::oDbf:nArea )->( dbAppend() )

      if !( ::oDbf:nArea )->( NetErr() )

         ( ::oDbf:nArea )->nNumRem  := nNumRem
         ( ::oDbf:nArea )->cSufRem  := cSufRem
         ( ::oDbf:nArea )->dFecRem  := dFecRem
         ( ::oDbf:nArea )->cAlmOrd  := cAlmDes
         ( ::oDbf:nArea )->nNumLin  := ( ::oDbfVir:nArea )->nNumLin
         ( ::oDbf:nArea )->cCodArt  := ( ::oDbfVir:nArea )->cCodArt
         ( ::oDbf:nArea )->lUndNeg  := ( ::oDbfVir:nArea )->lUndNeg
         ( ::oDbf:nArea )->cNumSer  := ( ::oDbfVir:nArea )->cNumSer

         ( ::oDbf:nArea )->( dbUnLock() )

      end if

      ( ::oDbfVir:nArea )->( dbSkip() )

      if !Empty( ::oParent ) .and. !Empty( ::oParent:oMeter )
         ::oParent:oMeter:AutoInc()
      end if

   end while

   ::Cancel()

   if !Empty( ::oParent ) .and. !Empty( ::oParent:oMeter )
      ::oParent:oMeter:Refresh()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD RollBack() CLASS TDetSeriesMovimientos

   local cKey  := ::oParent:cFirstKey
   local nArea := ::oDbf:nArea

   if cKey != nil

      while ( nArea )->( dbSeek( cKey ) ) // ::oDbf:Seek( cKey )

         if ( nArea )->( dbRlock() )
            ( nArea )->( dbDelete() )     // ::oDbf:Delete( .f. )
         end if

         if !Empty( ::oParent ) .and. !Empty( ::oParent:oMeter )
            ::oParent:oMeter:AutoInc()
         end if

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TDetSeriesMovimientos

   ::oDbfVir:GetStatus()
   ::oDbfVir:OrdSetFocus( "nNumLin" )

   with object ( TNumerosSerie() )

      :nMode            := nMode

      :lCompras         := ( ::oParent:oDbf:nTipMov != 1 )

      :cCodArt          := ::oParent:oDetMovimientos:oDbfVir:cRefMov
      :nNumLin          := ::oParent:oDetMovimientos:oDbfVir:nNumLin
      :cCodAlm          := ::oParent:oDbf:cAlmOrg

      :nTotalUnidades   := nTotNMovAlm( ::oParent:oDetMovimientos:oDbfVir )

      :oStock           := ::oParent:oStock

      :uTmpSer          := ::oDbfVir

      :Resource()

   end with

   ::oDbfVir:SetStatus()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD cMostrarSerie() CLASS TRemMovAlm

   local nNumRec     := ::oDetSeriesMovimientos:oDbfVir:Recno()
   local nOrdAnt     := ::oDetSeriesMovimientos:oDbfVir:OrdSetFocus( "cNumOrd" )
   local cResultado  := ""
   local i           := 0

   if ::oDetSeriesMovimientos:oDbfVir:Seek( str(::oDetMovimientos:oDbfVir:nNumRem) + ::oDetMovimientos:oDbfVir:cSufRem + str( ::oDetMovimientos:oDbfVir:nNumLin ) )

      while (str(::oDetSeriesMovimientos:oDbfVir:nNumRem) + ::oDetSeriesMovimientos:oDbfVir:cSufRem + str( ::oDetSeriesMovimientos:oDbfVir:nNumLin ) ) == (str( ::oDetMovimientos:oDbfVir:nNumRem ) + ::oDetMovimientos:oDbfVir:cSufRem + str (::oDetMovimientos:oDbfVir:nNumLin ) ) .and. !::oDetSeriesMovimientos:oDbfVir:Eof() .and. i <= 1

         if i == 0
            cResultado  = "[" + AllTrim( ::oDetSeriesMovimientos:oDbfVir:cNumSer ) + "] "
         else
            cResultado  = "[...]"

         end if

         i  += 1

         ::oDetSeriesMovimientos:oDbfVir:Skip()

      end while

   end if

   ::oDetSeriesMovimientos:oDbfVir:OrdSetFocus( nOrdAnt )
   ::oDetSeriesMovimientos:oDbfVir:Goto( nNumRec )

RETURN ( cResultado )

//---------------------------------------------------------------------------//

METHOD GenerarEtiquetas CLASS TRemMovAlm

   local oLabelGenetator

   /*
   Tomamos el estado de la tabla-----------------------------------------------
   */

   ::oDbf:GetStatus()

   /*
   Instanciamos la clase-------------------------------------------------------
   */

   oLabelGenetator      := TLabelGenerator():Create( Self )

   /*
   Le damos valores por defecto------------------------------------------------
   */

   oLabelGenetator:DocumentoInicio( ::oDbf:nNumRem )
   oLabelGenetator:DocumentoFin( ::oDbf:nNumRem )      
   oLabelGenetator:SufijoInicio( ::oDbf:cSufRem )      
   oLabelGenetator:SufijoFin( ::oDbf:cSufRem )            
   oLabelGenetator:TipoFormato( "FC" )
   oLabelGenetator:lMovimientoAlmacen := .t.

   /*
   Bases de datos--------------------------------------------------------------
   */

   oLabelGenetator:cDbfCabecera( ::oDbf:cAlias )
   oLabelGenetator:cDbfLinea( ::oDetMovimientos:oDbf:cAlias )
   oLabelGenetator:cDbfDocumento( ::oDbfDoc:cAlias )
   oLabelGenetator:cDbfArticulo( ::oArt:cAlias )

   /*
   Lanzamos el recurso---------------------------------------------------------
   */
   
   if oLabelGenetator:lCreateAuxiliarArticulo()

      //?"llego"

      /*
      Llenamos la tabla auxiliar-----------------------------------------------
      */

      //oLabelGenetator:LoadAuxiliarMovimientoAlmacen()

      //?"Paso"

      oLabelGenetator:Resource( .t. )

   end if   

   /*
   Dejamos la tabla como estaba------------------------------------------------
   */

   ::oDbf:SetStatus()

Return ( Self )

//---------------------------------------------------------------------------//

Function AppMovimientosAlmacen()

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New( cPatEmp() )

   if oRemMovAlm:OpenFiles()

      oRemMovAlm:Append()

      oRemMovAlm:CloseFiles()

   end if

   if oRemMovAlm != nil
      oRemMovAlm:End()
   end if

return .t.

//---------------------------------------------------------------------------//

Function EditMovimientosAlmacen( cNumParte, oBrw )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New( cPatEmp() )

   if oRemMovAlm:OpenFiles()

      if oRemMovAlm:oDbf:SeekInOrd( cNumParte, "cNumRem" )

         oRemMovAlm:Edit( oBrw )

      end if

      oRemMovAlm:CloseFiles()

   end if

   if oRemMovAlm != nil
      oRemMovAlm:End()
   end if

return .t.

//---------------------------------------------------------------------------//
/*funcion para hacer zoom un parte desde fuera de la clase*/

function ZoomMovimientosAlmacen( cNumParte, oBrw )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New( cPatEmp() )

   if oRemMovAlm:OpenFiles()

      if oRemMovAlm:oDbf:SeekInOrd( cNumParte, "cNumRem" )

         oRemMovAlm:Zoom( oBrw )

      end if

      oRemMovAlm:CloseFiles()

   end if

   if oRemMovAlm != nil
      oRemMovAlm:End()
   end if

return .t.

//---------------------------------------------------------------------------//
/*funcion para eliminar un parte desde fuera de la clase*/

function DelMovimientosAlmacen( cNumParte, oBrw )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New( cPatEmp() )

   if oRemMovAlm:OpenFiles()

      if oRemMovAlm:oDbf:SeekInOrd( cNumParte, "cNumRem" )

         oRemMovAlm:Del( oBrw )

      end if

      oRemMovAlm:CloseFiles()

   end if

   if oRemMovAlm != nil
      oRemMovAlm:End()
   end if

return .t.

//---------------------------------------------------------------------------//
/*
funcion para imprimir un parte desde fuera de la clase
*/

function PrnMovimientosAlmacen( cNumParte )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New( cPatEmp() )

   if oRemMovAlm:OpenFiles()

      if oRemMovAlm:oDbf:SeekInOrd( cNumParte, "cNumRem" )

         oRemMovAlm:GenRemMov( IS_PRINTER )

      end if

      oRemMovAlm:CloseFiles()

   end if

   if oRemMovAlm != nil
      oRemMovAlm:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
/*
funcion para visualizar un parte desde fuera de la clase
*/

function VisMovimientosAlmacen( cNumParte )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New( cPatEmp() )

   if oRemMovAlm:OpenFiles()

      if oRemMovAlm:oDbf:SeekInOrd( cNumParte, "cNumRem" )

         oRemMovAlm:GenRemMov( IS_SCREEN )

      end if

      oRemMovAlm:CloseFiles()

   end if

   if oRemMovAlm != nil
      oRemMovAlm:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//