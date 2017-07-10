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
memvar lEnd
memvar oThis
memvar cDbfCol
memvar oDbfCol
memvar cDbfPro
memvar cDbfFam
memvar cDbfMov
memvar cDbfArt
memvar cDbfAge
memvar nPagina
memvar nTotMov
memvar cPouDivRem
memvar cPorDivRem

static oRemesas
static oMenu

static cTmpLin
static dbfTmpLin

static dbfRemMov
static dbfHisMov
static dbfTMov
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
   DATA  cMru              INIT  "gc_pencil_package_16"
   DATA  cBitmap           INIT  Rgb( 128, 57, 123 )
   DATA  oAlmacenOrigen
   DATA  oAlmacenDestino
   DATA  oFam
   DATA  oTipArt
   DATA  oPro
   DATA  oTblPro
   DATA  oArtCom
   DATA  oTMov

   DATA  TComercio
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
   DATA  oTimRem
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

   DATA  lEndCalculate                                   INIT .f.

   DATA  lReclculado                                     INIT .f.

   DATA  nNumberSend                                     INIT  0
   DATA  nNumberRecive                                   INIT  0

   DATA  oDlgImport
   DATA  lFamilia                                        INIT  .t.
   DATA  oFamiliaInicio
   DATA  cFamiliaInicio
   DATA  oFamiliaFin
   DATA  cFamiliaFin

   DATA  lArticulo                                       INIT  .t.
   DATA  oArticuloInicio
   DATA  cArticuloInicio
   DATA  oArticuloFin
   DATA  cArticuloFin

   DATA  lTipoArticulo                                   INIT  .t.
   DATA  oTipoArticuloInicio
   DATA  cTipoArticuloInicio
   DATA  oTipoArticuloFin
   DATA  cTipoArticuloFin

   DATA  oMtrStock
   DATA  nMtrStock

   DATA  oMeter
   DATA  nMeter

   DATA  oRadTipoMovimiento

   DATA  lOpenFiles                                      INIT  .f.

   DATA  oBtnKit
   DATA  oBtnImportarInventario

   DATA  oDetMovimientos
   DATA  oDetSeriesMovimientos

   DATA  memoInventario
   DATA  aInventarioErrors                               INIT  {}

   DATA  buttonSaveResourceWithCalculate

   METHOD New( cPath, cDriver, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Initiate( cText, oSender )                     CONSTRUCTOR

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD OpenService( lExclusive )
   METHOD CloseService()
   METHOD CloseIndex()

   METHOD Reindexa( oMeter )

   METHOD GetNewCount()

   METHOD DefineFiles()
   METHOD DefineCalculate()

   METHOD Resource( nMode )
   METHOD Activate()

   METHOD EditDetalleMovimientos( oDlg )
   METHOD DeleteDet( oDlg )

   METHOD lSave()
   METHOD RecalcularPrecios()                            INLINE   ( ::oDetMovimientos:RecalcularPrecios(), ::oBrwDet:goTop(), ::oBrwDet:Refresh() )

   METHOD ShwAlm( oSay, oBtnImp )

   METHOD nTotRemMov( lPic )

   METHOD Search()

   METHOD lSelAll( lSel )

   METHOD lSelAllMov( lSel )                             VIRTUAL
   METHOD lSelMov()

   METHOD lSelAllDoc( lSel )
   METHOD lSelDoc()

   METHOD cTextoMovimiento()                             INLINE   { "Entre almacenes", "Regularización", "Objetivos", "Consolidación" }[ Min( Max( ( ::oDbf:nArea )->nTipMov, 1 ), 4 ) ]

   METHOD LoadAlmacen( nMode )
   METHOD ImportAlmacen( nMode, oDlg )
   
   METHOD nClrText()

   METHOD ShowKit( lSet )

   METHOD DataReport( oFr )
   METHOD VariableReport( oFr )
   METHOD DesignReportRemMov( oFr, dbfDoc )
   METHOD PrintReportRemMov( nDevice, nCopies, cPrinter, dbfDoc )

   METHOD GenRemMov( lPrinter, cCaption, cCodDoc, cPrinter )
   METHOD bGenRemMov( lImprimir, cTitle, cCodDoc )
   METHOD lGenRemMov( oBrw, oBtn, lImp )
   METHOD EPage( oInf, cCodDoc )

   METHOD Save()
   METHOD Load()

   METHOD nGetNumberToSend()
   METHOD SetNumberToSend()                              INLINE   WritePProString( "Numero", ::cText, cValToChar( ::nNumberSend ), ::cIniFile )
   METHOD IncNumberToSend()                              INLINE   WritePProString( "Numero", ::cText, cValToChar( ++::nNumberSend ), ::cIniFile )

   METHOD CreateData()
   METHOD RestoreData()
   METHOD SendData()
   METHOD ReciveData()
   METHOD Process()

   METHOD cMostrarSerie() 

   METHOD Report()                                       INLINE TInfRemMov():New( "Remesas de movimientos", , , , , , { ::oDbf, ::oDetMovimientos:oDbf, ::oArt } ):Play()

   METHOD GenerarEtiquetas()

   METHOD importarInventario()
      METHOD porcesarInventario()
      METHOD showInventarioErrors()
      METHOD procesarArticuloInventario( cInventario )

   METHOD alreadyInclude( sStkAlm )

   METHOD insertaArticuloRemesaMovimiento( cCodigo, nUnidades )

   METHOD saveResourceWithCalculate( nMode, oDlg )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem ) CLASS TRemMovAlm

   DEFAULT cPath           := cPatEmp()
   DEFAULT cDriver         := cDriver()
   DEFAULT oWndParent      := oWnd()
   DEFAULT oMenuItem       := "01050"

   ::nLevel                := nLevelUsr( oMenuItem )

   ::cPath                 := cPath
   ::cDriver               := cDriver
   ::oWndParent            := oWndParent
   ::oDbf                  := nil

   ::lAutoActions          := .f.

   ::cNumDocKey            := "nNumRem"
   ::cSufDocKey            := "cSufRem"

   ::cPicUnd               := MasUnd()

   ::bFirstKey             := {|| Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem }
   ::bWhile                := {|| Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDetMovimientos:oDbf:nNumRem, 9 ) + ::oDetMovimientos:oDbf:cSufRem .and. !::oDetMovimientos:oDbf:Eof() }

   ::oDetMovimientos       := TDetMovimientos():New( cPath, cDriver, Self )
   ::addDetail( ::oDetMovimientos )

   ::oDetSeriesMovimientos := TDetSeriesMovimientos():New( cPath, cDriver, Self )
   ::AddDetail( ::oDetSeriesMovimientos )

   ::oDetSeriesMovimientos:bOnPreSaveDetail  := {|| ::oDetSeriesMovimientos:SaveDetails() }

   ::bOnPreDelete          := {|| ::TComercio:resetProductsToUpdateStocks() }
   ::bOnPostDelete         := {|| ::TComercio:updateWebProductStocks() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Initiate( cText, oSender ) CLASS TRemMovAlm

   ::cText              := cText
   ::oSender            := oSender
   ::cIniFile           := cPatEmp() + "Empresa.Ini"
   ::lSuccesfullSend    := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD GetNewCount() CLASS TRemMovAlm

   ::oDbf:nNumRem       := nNewDoc( nil, ::oDbf:nArea, "nMovAlm", nil, ::oDbfCnt:nArea )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TRemMovAlm

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver

   DEFINE DATABASE ::oDbf FILE "REMMOVT.DBF" CLASS "TRemMovT" ALIAS "RemMovT" PATH ( cPath ) VIA ( cDriver ) COMMENT "Movimientos de almacén"

      FIELD NAME "lSelDoc"             TYPE "L" LEN  1  DEC 0                                                                                   COMMENT ""                                HIDE        OF ::oDbf
      FIELD CALCULATE NAME "Send16"             LEN  1  DEC 0                         VAL {|| ::oDbf:lSelDoc }   BITMAPS "gc_mail2_12", "Nil16"   COMMENT { "Enviar", "gc_mail2_16", 3 }          COLSIZE 20  OF ::oDbf
      FIELD CALCULATE NAME "Wait16"             LEN  1  DEC 0                         VAL {|| ::oDbf:lWait }     BITMAPS "gc_sign_stop_12", "Nil16"   COMMENT { "En proceso", "gc_sign_stop_16", 3 }    COLSIZE 20  OF ::oDbf
      FIELD NAME "nNumRem"             TYPE "N" LEN  9  DEC 0 PICTURE "999999999"         DEFAULT  0                                            COMMENT "Número"           COLSIZE 80                 OF ::oDbf
      FIELD NAME "cSufRem"             TYPE "C" LEN  2  DEC 0 PICTURE "@!"                DEFAULT  RetSufEmp()                                  COMMENT "Delegación"       COLSIZE 40                 OF ::oDbf
      FIELD NAME "nTipMov"             TYPE "N" LEN  1  DEC 0                                                                                   COMMENT "Tipo del movimiento"             HIDE        OF ::oDbf
      FIELD CALCULATE NAME "cTipMov"            LEN 12  DEC 0                             VAL ( ::cTextoMovimiento() )                          COMMENT "Tipo"             COLSIZE 90                 OF ::oDbf
      FIELD NAME "cCodUsr"             TYPE "C" LEN  3  DEC 0                             DEFAULT  cCurUsr()                                    COMMENT "Código usuario"                  HIDE        OF ::oDbf
      FIELD NAME "cCodDlg"             TYPE "C" LEN  2  DEC 0                                                                                   COMMENT ""                                HIDE        OF ::oDbf
      FIELD NAME "cCodAge"             TYPE "C" LEN  3  DEC 0                                                                                   COMMENT "Código agente"                   HIDE        OF ::oDbf
      FIELD NAME "cCodMov"             TYPE "C" LEN  2  DEC 0                                                                                   COMMENT "Tipo de movimiento"              HIDE        OF ::oDbf
      FIELD NAME "dFecRem"             TYPE "D" LEN  8  DEC 0                             DEFAULT  Date()                                       COMMENT "Fecha"            COLSIZE 80                 OF ::oDbf
      FIELD NAME "cTimRem"             TYPE "C" LEN  6  DEC 0 PICTURE "@R 99:99:99"       DEFAULT  getSysTime()                                 COMMENT "Hora"             COLSIZE 60                 OF ::oDbf
      FIELD NAME "cAlmOrg"             TYPE "C" LEN 16  DEC 0 PICTURE "@!"                                                                      COMMENT "Alm. org."        COLSIZE 60                 OF ::oDbf
      FIELD CALCULATE NAME "cNomAlmOrg"         LEN 20  DEC 0 PICTURE "@!"                VAL ( oRetFld( ( ::oDbf:nArea )->cAlmOrg, ::oAlmacenOrigen, "cNomAlm" ) )                       HIDE        OF ::oDbf
      FIELD NAME "cAlmDes"             TYPE "C" LEN 16  DEC 0 PICTURE "@!"                                                                      COMMENT "Alm. des."        COLSIZE 60                 OF ::oDbf
      FIELD CALCULATE NAME "cNomAlmDes"         LEN 20  DEC 0 PICTURE "@!"                VAL ( oRetFld( ( ::oDbf:nArea )->cAlmDes, ::oAlmacenDestino, "cNomAlm" ) )                      HIDE        OF ::oDbf
      FIELD NAME "cCodDiv"             TYPE "C" LEN  3  DEC 0 PICTURE "@!"                HIDE                                                  COMMENT "Div."                                        OF ::oDbf
      FIELD NAME "nVdvDiv"             TYPE "N" LEN 13  DEC 6 PICTURE "@E 999,999.999999" HIDE                                                  COMMENT "Cambio de la divisa"                         OF ::oDbf
      FIELD NAME "cComMov"             TYPE "C" LEN 100 DEC 0 PICTURE "@!"                                                                      COMMENT "Comentario"       COLSIZE 240                OF ::oDbf
      FIELD NAME "nTotRem"             TYPE "N" LEN 16  DEC 6 PICTURE "@E 999,999,999,999.99"   ALIGN RIGHT                                     COMMENT "Importe"          COLSIZE 100                OF ::oDbf
      FIELD NAME "lWait"               TYPE "L" LEN  1  DEC 0                                                                                   COMMENT ""                                HIDE        OF ::oDbf

      INDEX TO "RemMovT.Cdx" TAG "cNumRem"   ON "Str( nNumRem ) + cSufRem"   COMMENT "Número"   NODELETED OF ::oDbf
      INDEX TO "RemMovT.Cdx" TAG "dFecRem"   ON "Dtos( dFecRem ) + cTimRem"  COMMENT "Fecha"    NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//
//
// Campos calculados
//

METHOD DefineCalculate() CLASS TRemMovAlm 

   ::aCal  := {}

   aAdd( ::aCal, { "( RetFld( ( cDbfCol )->cRefMov, cDbfArt, 'Nombre' ) )",   "C",100, 0, "Nombre artículo",  "",             "" } )
   aAdd( ::aCal, { "nTotNMovAlm( oDbfCol )",                                  "N", 16, 6, "Total unidades",   "cPorDivRem",   "" } )
   aAdd( ::aCal, { "nTotLMovAlm( oDbfCol )",                                  "N", 16, 6, "Total importe",    "cPorDivRem",   "" } )

RETURN ( ::aCal )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TRemMovAlm 

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
         TOOLTIP  "(I)mprimir";
         HOTKEY   "I";
         LEVEL    ACC_IMPR

      ::lGenRemMov( ::oWndBrw:oBrw, oImp, .t. )

      DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF ::oWndBrw ;
         ACTION   ( ::GenRemMov( .f. ) ) ;
         TOOLTIP  "(P)revisualizar";
         HOTKEY   "P";
         LEVEL    ACC_IMPR

      ::lGenRemMov( ::oWndBrw:oBrw, oPrv, .f. )

      DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF ::oWndBrw ;
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

      msgstop( "Acceso no permitido." )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TRemMovAlm 

   local oError
   local oBlock               

   DEFAULT lExclusive         := .f.

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !::lOpenFiles

      if empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::OpenDetails()

      DATABASE NEW ::oDelega           FILE "Delega.Dbf"    PATH ( cPatDat() )      VIA ( cDriver() ) SHARED INDEX "Delega.Cdx"

      DATABASE NEW ::oUsr              FILE "Users.Dbf"     PATH ( cPatDat() )       VIA ( cDriver() ) SHARED INDEX "Users.Cdx"

      DATABASE NEW ::oTMov             FILE "TMOV.DBF"      PATH ( cPatDat() )        VIA ( cDriver() ) SHARED INDEX "TMov.Cdx"

      DATABASE NEW ::oAlmacenOrigen    FILE "ALMACEN.DBF"   ALIAS "ALMACEN"   PATH ( cPatAlm() )   VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

      DATABASE NEW ::oAlmacenDestino   FILE "ALMACEN.DBF"   ALIAS "ALMACEN"   PATH ( cPatAlm() )   VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

      DATABASE NEW ::oArtCom           FILE "ARTDIV.DBF"    ALIAS "ARTDIV"    PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "ARTDIV.CDX"

      DATABASE NEW ::oPro              FILE "PRO.DBF"       ALIAS "PRO"       PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "PRO.CDX"

      DATABASE NEW ::oTblPro           FILE "TBLPRO.DBF"    ALIAS "TBLPRO"    PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "TBLPRO.CDX"

      DATABASE NEW ::oFam              FILE "FAMILIAS.DBF"  ALIAS "FAMILIAS"  PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

      DATABASE NEW ::oArt              FILE "ARTICULO.DBF"  ALIAS "ARTICULO"  PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      DATABASE NEW ::oArtKit           FILE "ARTKIT.DBF"    ALIAS "ARTKIT"    PATH ( cPatArt() ) VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

      DATABASE NEW ::oDbfAge           FILE "AGENTES.DBF"  PATH ( cPatCli() )   VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"

      DATABASE NEW ::oPedPrvT          FILE "PEDPROVT.DBF" PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "PEDPROVT.CDX"

      DATABASE NEW ::oPedPrvL          FILE "PEDPROVL.DBF" PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"
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

      ::oStock             := TStock():Create( cPatEmp() )
      if !::oStock:lOpenFiles()
         ::lOpenFiles      := .f.
      end if

      ::lLoadDivisa()

      ::nView              := D():CreateView() 

      D():ArticuloPrecioPropiedades( ::nView )

      D():PropiedadesLineas( ::nView )

      D():Propiedades( ::nView )

      D():Documentos( ::nView ) 

      ::TComercio          := TComercio():new( ::nView, ::oStock )

      ::lOpenFiles         := .t.

   end if

   RECOVER USING oError

      ::lOpenFiles         := .f.

      msgstop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !::lOpenFiles
      ::CloseFiles()
   end if

RETURN ( ::lOpenFiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRemMovAlm 

   ::CloseDetails()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if ::oAlmacenOrigen != nil .and. ::oAlmacenOrigen:Used()
      ::oAlmacenOrigen:End()
   end if

   if ::oAlmacenDestino != nil .and. ::oAlmacenDestino:Used()
      ::oAlmacenDestino:End()
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

   if !empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if

   if !empty( ::oPedCliR ) .and. ::oPedCliR:Used()
      ::oPedCliR:End()
   end if

   if !empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !empty( ::oAlbCliS ) .and. ::oAlbCliS:Used()
      ::oAlbCliS:End()
   end if

   if !empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !empty( ::oFacCliS ) .and. ::oFacCliS:Used()
      ::oFacCliS:End()
   end if

   if !empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if

   if !empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   if !empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if

   if !empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if !empty( ::oTikCliS ) .and. ::oTikCliS:Used()
      ::oTikCliS:End()
   end if

   if !empty( ::oHisMov ) .and. ::oHisMov:Used()
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

   if !empty( ::oTipArt )
      ::oTipArt:end()
   end if

   if !isNil( ::nView )
      D():DeleteView( ::nView )
   end if 

   if !Empty( ::TComercio )
      ::TComercio:end()
   end if

   ::oDbf               := nil
   ::oAlmacenOrigen     := nil
   ::oAlmacenDestino    := nil
   ::oArt               := nil
   ::oArtKit            := nil
   ::oFam               := nil
   ::oPro               := nil
   ::oTblPro            := nil
   ::oArtCom            := nil
   ::oTMov              := nil
   ::oStock             := nil
   ::oAlbPrvT           := nil
   ::oAlbPrvL           := nil
   ::oAlbPrvS           := nil
   ::oFacPrvT           := nil
   ::oRctPrvT           := nil
   ::oRctPrvL           := nil
   ::oPedCliT           := nil
   ::oPedCliL           := nil
   ::oPedCliR           := nil
   ::oAlbCliT           := nil
   ::oAlbCliL           := nil
   ::oFacCliT           := nil
   ::oFacCliL           := nil
   ::oTikCliT           := nil
   ::oTikCliL           := nil
   ::oHisMov            := nil
   ::oDbfDiv            := nil
   ::oDbfAge            := nil
   ::oDbfBar            := nil
   ::oDbfDoc            := nil
   ::oTipArt            := nil
   ::oDbfEmp            := nil
   ::oDbfProLin         := nil
   ::oDbfProMat         := nil

   ::oBandera           := nil

   ::TComercio          := nil

   ::lOpenFiles         := .f.

   ::nView              := nil 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath ) CLASS TRemMovAlm 

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::OpenDetails()

   RECOVER USING oError

      lOpen             := .f.

      msgstop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de remesas de movimientos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService() CLASS TRemMovAlm

   if !empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::CloseDetails()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseIndex() CLASS TRemMovAlm  

   if !empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:OrdListClear()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TRemMovAlm

   local oDlg
   local oSay        := Array( 7 )
   local cSay        := Array( 7 )
   local oBtnImp
   local oBmpGeneral

   // Ordeno oDbfVir por el numero de linea------------------------------------

   ::oDetMovimientos:oDbfVir:OrdSetFocus( "nNumLin" )

   if nMode == APPD_MODE
      ::oDbf:lSelDoc := .t.
      ::oDbf:cCodUsr := cCurUsr()
      ::oDbf:cCodDlg := oRetFld( cCurUsr(), ::oUsr, "cCodDlg" )
   end if

   cSay[ 1 ]         := oRetFld( ::oDbf:cAlmOrg, ::oAlmacenOrigen )
   cSay[ 2 ]         := oRetFld( ::oDbf:cAlmDes, ::oAlmacenDestino )
   cSay[ 3 ]         := oRetFld( ::oDbf:cCodMov, ::oTMov )
   cSay[ 5 ]         := oRetFld( cCodEmp() + ::oDbf:cCodDlg, ::oDelega, "cNomDlg" )
   cSay[ 6 ]         := Rtrim( oRetFld( ::oDbf:cCodAge, ::oDbfAge, 2 ) ) + ", " + Rtrim( oRetFld( ::oDbf:cCodAge, ::oDbfAge, 3 ) )
   cSay[ 7 ]         := oRetFld( ::oDbf:cCodUsr, ::oUsr )

   DEFINE DIALOG oDlg RESOURCE "RemMov" TITLE LblTitle( nMode ) + "movimientos de almacén"

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_package_pencil_48" ;
        TRANSPARENT ;
        OF       oDlg

      REDEFINE GET ::oNumRem VAR ::oDbf:nNumRem ;
         ID       100 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "nNumRem" ):cPict ;
         OF       oDlg

      REDEFINE GET ::oSufRem VAR ::oDbf:cSufRem ;
         ID       110 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "cSufRem" ):cPict ;
         OF       oDlg

      REDEFINE GET ::oFecRem VAR ::oDbf:dFecRem ;
         ID       120 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oTimRem VAR ::oDbf:cTimRem ;
         ID       121 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ( ::oDbf:FieldByName( "cTimRem" ):cPict );
         VALID    ( iif(   !validTime( ::oDbf:cTimRem  ),;
                           ( msgstop( "El formato de la hora no es correcto" ), .f. ),;
                           .t. ) );
         OF       oDlg

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
         WHEN     ( nMode != ZOOM_MODE ) ; // WHEN     ( nMode == APPD_MODE ) ; // .and. empty( ::oDetMovimientos:oDbfVir:OrdKeyCount()
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
         OF       oDlg

      REDEFINE SAY oSay[ 4 ] PROMPT "Almacén origen" ;
         ID       152 ;
         OF       oDlg

      REDEFINE GET ::oAlmOrg VAR ::oDbf:cAlmOrg UPDATE ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oDbf:FieldByName( "cAlmOrg" ):cPict ;
         BITMAP   "LUPA" ;
         OF       oDlg
      ::oAlmOrg:bValid     := {|| cAlmacen( ::oAlmOrg, ::oAlmacenOrigen:cAlias, oSay[1] ) }
      ::oAlmOrg:bHelp      := {|| BrwAlmacen( ::oAlmOrg, oSay[1] ) }

      REDEFINE GET oSay[ 1 ] VAR cSay[ 1 ] ;
         UPDATE ;
         ID       151 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oAlmDes VAR ::oDbf:cAlmDes UPDATE ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oDbf:FieldByName( "cAlmDes" ):cPict ;
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oAlmDes:bValid     := {|| cAlmacen( ::oAlmDes, ::oAlmacenDestino:cAlias, oSay[2] ) }
      ::oAlmDes:bHelp      := {|| BrwAlmacen( ::oAlmDes, oSay[2] ) }

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] UPDATE ;
         ID       161 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      ::oDefDiv( 190, 191, 192, oDlg, nMode )

      REDEFINE GET ::oDbf:cComMov ;
         ID       170 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

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
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !empty( ::oDbf:cAlmDes ) ) ;
         ACTION   ( ::oDetMovimientos:AppendDetail() )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !empty( ::oDbf:cAlmDes ) ) ;
         ACTION   ( ::EditDetalleMovimientos( oDlg ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !empty( ::oDbf:cAlmDes ) ) ;
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

      REDEFINE BUTTON ::oBtnImportarInventario ;
         ID       509 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !empty( ::oDbf:cAlmDes ) ) ;
         ACTION   ( ::importarInventario() )

      REDEFINE BUTTON oBtnImp ;
         ID       506 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE .and. !empty( ::oDbf:cAlmDes ) ) ;
         ACTION   ( ::ImportAlmacen( nMode, oDlg ) )

      ::oBrwDet               := IXBrowse():New( oDlg )

      ::oBrwDet:bClrSel       := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwDet:bClrSelFocus  := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwDet:nMarqueeStyle := 6
      ::oBrwDet:lHScroll      := .f.
      ::oBrwDet:lFooter       := .t.
      if nMode != ZOOM_MODE
         ::oBrwDet:bLDblClick := {|| ::EditDetalleMovimientos( oDlg ) }
      end if

      ::oBrwDet:cName         := "Detalle movimientos de almacén"

      ::oDetMovimientos:oDbfVir:SetBrowse( ::oBrwDet )

      ::oBrwDet:CreateFromResource( 180 )

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Se.  Seleccionado"
         :bStrData      := {|| "" }
         :bEditValue    := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "lSelDoc" ) }
         :nWidth        := 24
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
         :cSortOrder    := "cRefAlm"
         :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Nombre"
         :bStrData      := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "cNomMov" ) }
         :nWidth        := 300
         :cSortOrder    := "cNomMov"
         :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
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

      with object ( ::oBrwDet:AddCol() )
         :cHeader       := "Nombre propiedad 1"
         :bEditValue    := {|| nombrePropiedad( ::oDetMovimientos:oDbfVir:FieldGetByName( "cCodPr1" ), ::oDetMovimientos:oDbfVir:FieldGetByName( "cValPr1" ), ::nView ) }
         :nWidth        := 60
         :lHide         := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader       := "Nombre propiedad 2"
         :bEditValue    := {|| nombrePropiedad( ::oDetMovimientos:oDbfVir:FieldGetByName( "cCodPr2" ), ::oDetMovimientos:oDbfVir:FieldGetByName( "cValPr2" ), ::nView ) }
         :nWidth        := 60
         :lHide         := .t.
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

      with object ( ::oBrwDet:AddCol() )
         :cHeader       := "Bultos"
         :bEditValue    := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "nBultos" ) }
         :cEditPicture  := MasUnd()
         :nWidth        := 60
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :lHide         := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader       := cNombreCajas()
         :bEditValue    := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "nCajMov" ) }
         :cEditPicture  := MasUnd()
         :nWidth        := 60
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :lHide         := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader       := cNombreUnidades()
         :bEditValue    := {|| ::oDetMovimientos:oDbfVir:FieldGetByName( "nUndMov" ) }
         :cEditPicture  := MasUnd()
         :nWidth        := 60
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
         :lHide         := .t.
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Total " + cNombreUnidades()
         :bEditValue    := {|| nTotNMovAlm( ::oDetMovimientos:oDbfVir ) }
         :bFooter       := {|| ::oDetMovimientos:nTotUnidadesVir( .t. ) }
         :cEditPicture  := ::cPicUnd
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Und. anteriores"
         :bEditValue    := {|| nTotNMovOld( ::oDetMovimientos:oDbfVir ) }
         :cEditPicture  := ::cPicUnd
         :lHide         := .t.
         :nWidth        := 80
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      with object ( ::oBrwDet:addCol() )
         :cHeader       := "Und. diferencia"
         :bEditValue    := {|| abs( nTotNMovAlm( ::oDetMovimientos:oDbfVir ) - nTotNMovOld( ::oDetMovimientos:oDbfVir ) ) }
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
      ::oMeter          := TApoloMeter():ReDefine( 400, { | u | if( pCount() == 0, ::nMeter, ::nMeter := u ) }, 10, oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      REDEFINE BUTTON ::buttonSaveResourceWithCalculate;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::saveResourceWithCalculate( nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:End() )

      REDEFINE BUTTON ;
         ID       3 ;
         OF       oDlg ;
         ACTION   ( ::RecalcularPrecios() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F2, {|| ::oDetMovimientos:AppendDetail() } )
         oDlg:AddFastKey( VK_F3, {|| ::EditDetalleMovimientos( oDlg ) } )
         oDlg:AddFastKey( VK_F4, {|| ::DeleteDet() } )
         oDlg:AddFastKey( VK_F5, {|| ::saveResourceWithCalculate( nMode, oDlg ) } )
      end if

      oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Movimientosalmacen" ) } )

      oDlg:bStart := {|| ::ShwAlm( oSay, oBtnImp ), ::ShowKit( .f. ), ::oBrwDet:Load() }

   ACTIVATE DIALOG oDlg CENTER

   oBmpGeneral:End()

   if oDlg:nResult != IDOK
      ::endResource( .f., nMode )
   end if

   // Guardamos los datos del browse----------------------------------------------

   ::oBrwDet:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD Search() CLASS TRemMovAlm

   local oDlg
   local oIndice
   local cIndice  := "Código"
   local aIndice  := { "Código", "Nombre" }
   local oCadena
   local xCadena  := space( 100 )
   local nOrdAnt  := ::oDetMovimientos:oDbfVir:OrdSetFocus( "cRefMov" )

   DEFINE DIALOG oDlg RESOURCE "sSearch"

   REDEFINE GET oCadena VAR xCadena ;
      ID          100 ;
      OF          oDlg
      
      oCadena:bChange   := {|| oCadena:Assign(), ::oDetMovimientos:oDbfVir:Seek( UPPER( Rtrim( xCadena ) ), .t. ), ::oBrwDet:Refresh() }

   REDEFINE COMBOBOX oIndice ;
      VAR         cIndice ;
      ITEMS       aIndice ;
      ID          101 ;
      OF          oDlg

   oIndice:bChange      := {||   ::oDetMovimientos:oDbfVir:OrdSetFocus( if( oIndice:nAt == 1, "cRefMov", "cNomMov" ) ),;
                                 ::oBrwDet:Refresh(),;
                                 oCadena:SetFocus(),;
                                 oCadena:SelectAll() }

   REDEFINE BUTTON ;
      ID          510 ;
      OF          oDlg ;
      ACTION      ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

   ::oDetMovimientos:oDbfVir:OrdSetFocus( nOrdAnt )

RETURN NIL

//---------------------------------------------------------------------------//

METHOD lSave( nMode ) CLASS TRemMovAlm

   if empty( ::oDbf:cCodAge ) .and. lRecogerAgentes()
      msgstop( "Código de agente no puede estar vacío." )
      ::oCodAge:SetFocus()
      Return .f.
   end if

   if ::oDbf:nTipMov == 1

      if empty( ::oDbf:cAlmOrg )
         msgstop( "Almacén origen no puede estar vacío." )
         ::oAlmOrg:SetFocus()
         Return .f.
      end if

      if ::oDbf:cAlmDes == ::oDbf:cAlmOrg
         msgstop( "Almacén origen y destino no pueden ser iguales." )
         ::oAlmOrg:SetFocus()
         Return .f.
      end if

   else

      if empty( ::oDbf:cAlmDes )
         msgstop( "Almacén destino no puede estar vacío." )
         ::oAlmDes:SetFocus()
         Return .f.
      end if

   end if

   if !::oDetMovimientos:oDbfVir:LastRec() > 0
      msgstop( "No puede hacer un movimiento de almacén sin líneas." )
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

METHOD GenRemMov( lPrinter, cCaption, cCodDoc, cPrinter, nCopies ) CLASS TRemMovAlm

   local oInf
   local oDevice
   local nNumRem

   DEFAULT lPrinter     := .f.
   DEFAULT cCaption     := "Imprimiendo remesas de movimientos"
   DEFAULT cCodDoc      := cFormatoDocumento(   nil, "nMovAlm", ::oDbfCnt:cAlias )
   DEFAULT nCopies      := nCopiasDocumento(    nil, "nMovAlm", ::oDbfCnt:cAlias )

   if ::oDbf:Lastrec() == 0
      return nil
   end if

   if empty( cCodDoc )
      cCodDoc           := "RM1"
   end if

   if !lExisteDocumento( cCodDoc, D():Documentos( ::nView ) )
      return nil
   end if

   if !lVisualDocumento( cCodDoc, D():Documentos( ::nView ) )
      msgstop( "El documento " + cCodDoc + " no es un formato valido.", "Formato obsoleto" )
      return nil
   end if

   nNumRem              := Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem

   private oThis        := Self

   ::oDbf:getStatus( .t. )
   ::oDbf:seek( nNumRem )

   ::oDetMovimientos:oDbf:getStatus()
   ::oDetMovimientos:oDbf:ordsetfocus( "nNumRef" )
   ::oDetMovimientos:oDbf:Seek( nNumRem )

   ::oDetSeriesMovimientos:oDbf:Seek( nNumRem )

   ::oDbfAge:Seek( ::oDbf:cCodAge )

   public nTotMov       := ::nTotRemMov( .t. )

   ::PrintReportRemMov( if( lPrinter, IS_PRINTER, IS_SCREEN ), nCopies, cPrinter, D():Documentos( ::nView ) )

   ::oDbf:setStatus()
   ::oDetMovimientos:oDbf:setStatus()

Return Nil

//----------------------------------------------------------------------------//

METHOD EPage( oInf, cCodDoc ) CLASS TRemMovAlm 

   private nPagina      := oInf:nPage
   private lEnd         := oInf:lFinish

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

METHOD lSelAll( lSel ) CLASS TRemMovAlm 

   local nOrdAnt        := ::oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

   DEFAULT lSel         := .t.

   ::oDbf:GetStatus()
   ::oDetMovimientos:oDbf:GetStatus()

   ::oDbf:GoTop()
   while !::oDbf:Eof()

      /*
      Marcamos la cabecera-----------------------------------------------------
      */

      ::oDbf:fieldPutByName( "lSelDoc", lSel )

      /*
      Marcamos las lineas------------------------------------------------------
      */

      ::oDetMovimientos:oDbf:GoTop()

      if ::oDetMovimientos:oDbf:Seek( Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem )

         while Str( ::oDetMovimientos:oDbf:nNumRem ) + ::oDetMovimientos:oDbf:cSufRem == Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem .and. !::oDetMovimientos:oDbf:Eof()

            ::oDetMovimientos:oDbf:fieldPutByName( "lSndDoc", ::oDbf:lSelDoc )

            ::oDetMovimientos:oDbf:Skip()

         end while

      end if

      ::oDbf:Skip()

   end while

   ::oDbf:SetStatus()

   ::oDetMovimientos:oDbf:SetStatus()

   ::oDetMovimientos:oDbf:OrdSetFocus( nOrdAnt )

   if !empty( ::oWndBrw )
      ::oWndBrw:Refresh()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

METHOD lSelMov() CLASS TRemMovAlm 

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

METHOD CreateData() CLASS TRemMovAlm 

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

   oRemMov           := TRemMovAlm():New( cPatEmp(), cDriver() )
   oRemMov:OpenService()

   oRemMov:oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

   // Creamos todas las bases de datos relacionadas con Articulos

   oRemMovTmp        := TRemMovAlm():New( cPatSnd(), cLocalDriver() )
   oRemMovTmp:OpenService()

   oRemMovTmp:oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

   // Creamos todas las bases de datos relacionadas con Articulos

   while !oRemMov:oDbf:eof()

      if oRemMov:oDbf:lSelDoc

         lSnd  := .t.

         dbPass( oRemMov:oDbf:nArea, oRemMovTmp:oDbf:nArea, .t. )

         ::oSender:SetText( alltrim( str( oRemMov:oDbf:nNumRem, 9 ) ) + "/" + oRemMov:oDbf:cSufRem )

         if oRemMov:oDetMovimientos:oDbf:Seek( str( oRemMov:oDbf:nNumRem, 9 ) + oRemMov:oDbf:cSufRem )

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

METHOD RestoreData() CLASS TRemMovAlm 

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

METHOD SendData() CLASS TRemMovAlm 

   local cFileName

   if ::oSender:lServer
      cFileName      := "MovAlm" + StrZero( ::nGetNumberToSend(), 6 ) + ".All"
   else
      cFileName      := "MovAlm" + StrZero( ::nGetNumberToSend(), 6 ) + "." + RetSufEmp()
   end if

   if file( cPatOut() + cFileName )

      if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
         ::lSuccesfullSend := .t.
         ::IncNumberToSend()
         ::oSender:SetText( "Fichero enviado " + cFileName )
      else
         ::oSender:SetText( "ERROR fichero no enviado" )
      end if

   end if

Return ( Self )

//----------------------------------------------------------------------------//

METHOD ReciveData() CLASS TRemMovAlm 

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
      ::oSender:GetFiles( "MovAlm*." + aExt[ n ], cPatIn() )
   next

   ::oSender:SetText( "Movimientos de almacén recibidos" )

Return Self

//----------------------------------------------------------------------------//

METHOD Process() CLASS TRemMovAlm

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

            oRemMovTmp        := TRemMovAlm():New( cPatSnd(), cLocalDriver() )
            oRemMovTmp:OpenService( .f. )

            oRemMovTmp:oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

            oRemMov           := TRemMovAlm():New( cPatEmp(), cDriver() )
            oRemMov:OpenService()

            oRemMov:oDetMovimientos:oDbf:OrdSetFocus( "nNumRem" )

            dbfRemMovTmp      := oRemMovTmp:oDbf:cAlias
            dbfRemMovFix      := oRemMov:oDbf:cAlias

            /*
            Ponemos los valores de las delegaciones----------------------------
            */

            oRemMovTmp:oDbf:GoTop()
            while !oRemMovTmp:oDbf:Eof()

               if empty( oRemMovTmp:oDbf:cSufRem )
                  oRemMovTmp:oDbf:FieldPutByName( "cSufRem", "00" )
               end if 

               oRemMovTmp:oDbf:Skip()

            end while 

            oRemMovTmp:oDetMovimientos:oDbf:GoTop()
            while !oRemMovTmp:oDetMovimientos:oDbf:Eof()

               if empty( oRemMovTmp:oDetMovimientos:oDbf:cSufRem )
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

   if !empty( oAlm ) .and. oAlm:Used()
      oAlm:End()
   end if

Return Self

//----------------------------------------------------------------------------//

METHOD nGetNumberToSend() CLASS TRemMovAlm

   ::nNumberSend     := GetPvProfInt( "Numero", ::cText, ::nNumberSend, ::cIniFile )

Return ( ::nNumberSend )

//----------------------------------------------------------------------------//

METHOD Save() CLASS TRemMovAlm

   WritePProString( "Envio",     ::cText, cValToChar( ::lSelectSend ), ::cIniFile )
   WritePProString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Load() CLASS TRemMovAlm

   ::lSelectSend     := ( Upper( GetPvProfString( "Envio",     ::cText, cValToChar( ::lSelectSend ),   ::cIniFile ) ) == ".T." )
   ::lSelectRecive   := ( Upper( GetPvProfString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile ) ) == ".T." )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD lGenRemMov( oBrw, oBtn, lImp ) CLASS TRemMovAlm

   local bAction

   DEFAULT lImp   := .f.

   if !( D():Documentos( ::nView ) )->( dbSeek( "RM" ) )

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( msgstop( "No hay documentos predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   else

      while ( D():Documentos( ::nView ) )->cTipo == "RM" .AND. !( D():Documentos( ::nView ) )->( eof() )

         bAction  := ::bGenRemMov( lImp, "Imprimiendo movimientoo de almacén", ( D():Documentos( ::nView ) )->Codigo )

         ::oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ( D():Documentos( ::nView ) )->cDescrip ) , , , , , oBtn )

         ( D():Documentos( ::nView ) )->( dbskip() )

      end do

   end if

RETURN nil

//---------------------------------------------------------------------------//

METHOD bGenRemMov( lImprimir, cTitle, cCodDoc ) CLASS TRemMovAlm

   local bGen
   local lImp  := by( lImprimir )
   local cTit  := by( cTitle    )
   local cCod  := by( cCodDoc   )

   bGen        := {|| ::GenRemMov( lImp, cTit, cCod ) }

RETURN ( bGen )

//---------------------------------------------------------------------------//

METHOD Reindexa() CLASS TRemMovAlm

   if empty( ::oDbf )
      ::oDbf   := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   ::oDbf:Activate( .f., .t., .f. )

   ::oDbf:Pack()

   ::oDbf:End()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD EditDetalleMovimientos( oDlg ) CLASS TRemMovAlm 

   if ::oDetMovimientos:oDbfVir:OrdKeyCount() == 0
      Return ( Self )
   end if

   ::oDetMovimientos:oDbfVir:Load()

   if ::oDetMovimientos:Resource( EDIT_MODE ) == IDOK
      ::oDetMovimientos:oDbfVir:Save()
   else 
      ::oDetMovimientos:oDbfVir:Cancel()
   end if

   if !empty( ::oBrwDet )
      ::oBrwDet:Refresh()
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DeleteDet() CLASS TRemMovAlm 

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
      cTxtDel        := "¿ Desea eliminar el registro en curso ?"
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
            if !empty( nNumLin ) .and. ( ::oDetMovimientos:oDbfVir:nNumLin == nNumLin )
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

METHOD ImportAlmacen( nMode, oDlg ) CLASS TRemMovAlm 

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

      ::oArticuloInicio:bValid         := {|| cArticulo( ::oArticuloInicio, ::oArt:cAlias, ::oArticuloInicio:oHelpText ) }
      ::oArticuloInicio:bHelp          := {|| brwArticulo( ::oArticuloInicio, ::oArticuloInicio:oHelpText ) }

      REDEFINE GET ::oArticuloFin VAR ::cArticuloFin ;
         ID       330 ;
         IDTEXT   340 ;
         BITMAP   "LUPA" ;
         WHEN     ( !::lArticulo ) ;
         OF       ::oDlgImport ;

      ::oArticuloFin:bValid            := {|| cArticulo( ::oArticuloFin, ::oArt:cAlias, ::oArticuloFin:oHelpText ) }
      ::oArticuloFin:bHelp             := {|| brwArticulo( ::oArticuloFin, ::oArticuloFin:oHelpText ) }

      REDEFINE APOLOMETER ::oMtrStock ;
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

METHOD loadAlmacen( nMode ) CLASS TRemMovAlm 

   local nPreMed
   local cCodFam
   local cCodAlm
   local cCodTip
   local sStkAlm
   local aStkAlm
   local nNumLin
   local cCodAlmOrg

   CursorWait()

   ::oDlgImport:Disable()

   cCodAlm                 := ::oDbf:cAlmDes
   cCodAlmOrg              := ::oDbf:cAlmOrg

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

            if !( ::alreadyInclude( sStkAlm ) ) 

               if  ::oDetMovimientos:oDbfVir:Append()
   
                  ::oDetMovimientos:oDbfVir:Blank()
      
                  ::oDetMovimientos:oDbfVir:lSelDoc   := .t.
      
                  ::oDetMovimientos:oDbfVir:cRefMov   := sStkAlm:cCodigo
                  ::oDetMovimientos:oDbfVir:cNomMov   := retArticulo( sStkAlm:cCodigo, ::oArt:cAlias )
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

                  if !empty( sStkAlm:cNumeroSerie )

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
      
                  ::oDetMovimientos:oDbfVir:nPreDiv   := nPreMed
      
                  ::oDetMovimientos:oDbfVir:Save()
      
               end if
            
            end if

         next
      
      end if
   
      ::oArt:Skip()
   
      ::oMtrStock:Set( ::oArt:OrdKeyNo() ) 
   
      end while

   end if

   if ( nMode == APPD_MODE ) .and. ( ::oDbf:nTipMov == 1 )

      ::oMtrStock:cText    := "Importando artículos "
      ::oMtrStock:nTotal   := ::oArt:OrdKeyCount() 
      
      ::oMtrStock:Refresh()

      ::oArt:GoTop()
      while !::oArt:eof()

      if ( ::lFamilia      .or. ( ::oArt:Familia >= ::cFamiliaInicio        .and. ::oArt:Familia <= ::cFamiliaFin ) )      .and.;
         ( ::lTipoArticulo .or. ( ::oArt:cCodTip >= ::cTipoArticuloInicio   .and. ::oArt:cCodTip <= ::cTipoArticuloFin ) ) .and.;
         ( ::lArticulo     .or. ( ::oArt:Codigo >= ::cArticuloInicio        .and. ::oArt:Codigo <= ::cArticuloFin ) )

         aStkAlm           := ::oStock:aStockArticulo( ::oArt:Codigo, cCodAlmOrg )

         for each sStkAlm in aStkAlm

            if sStkAlm:nUnidades != 0

               if  ::oDetMovimientos:oDbfVir:Append()
   
                  ::oDetMovimientos:oDbfVir:Blank()
      
                  ::oDetMovimientos:oDbfVir:lSelDoc   := .t.
      
                  ::oDetMovimientos:oDbfVir:cRefMov   := sStkAlm:cCodigo
                  ::oDetMovimientos:oDbfVir:cNomMov   := RetArticulo( sStkAlm:cCodigo, ::oArt:cAlias )
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
                  ::oDetMovimientos:oDbfVir:cAloMov   := ::oDbf:cAlmOrg

                  if !empty( sStkAlm:cNumeroSerie )

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

                  ::oDetMovimientos:oDbfVir:nUndMov   := sStkAlm:nUnidades
      
                  if !uFieldEmpresa( "lCosAct" )
      
                     nPreMed                          := ::oStock:nPrecioMedioCompra( sStkAlm:cCodigo, cCodAlm, nil, GetSysDate() )
      
                     if nPreMed == 0
                        nPreMed                       := nCosto( sStkAlm:cCodigo, ::oArt:cAlias, ::oArtKit:cAlias )
                     end if
      
                  else
      
                     nPreMed                          := nCosto( sStkAlm:cCodigo, ::oArt:cAlias, ::oArtKit:cAlias )
   
                  end if
      
                  ::oDetMovimientos:oDbfVir:nPreDiv   := nPreMed
      
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

METHOD alreadyInclude( sStkAlm ) CLASS TRemMovAlm

   local alreadyInclude := .f.
   local aStatus        := ::oDetMovimientos:oDbfVir:getStatus()

   ::oDetMovimientos:oDbfVir:gotop()

   while ( !::oDetMovimientos:oDbfVir:eof() )

      if ::oDetMovimientos:oDbfVir:cRefMov  == sStkAlm:cCodigo             .and.;
         ::oDetMovimientos:oDbfVir:cCodPr1  == sStkAlm:cCodigoPropiedad1   .and.;
         ::oDetMovimientos:oDbfVir:cCodPr2  == sStkAlm:cCodigoPropiedad2   .and.;
         ::oDetMovimientos:oDbfVir:cValPr1  == sStkAlm:cValorPropiedad1    .and.;
         ::oDetMovimientos:oDbfVir:cValPr2  == sStkAlm:cValorPropiedad2    .and.;
         ::oDetMovimientos:oDbfVir:cLote    == sStkAlm:cLote

         alreadyInclude := .t.

         exit

      end if 

      ::oDetMovimientos:oDbfVir:skip()

   end while

   ::oDetMovimientos:oDbfVir:setStatus( aStatus )

RETURN ( alreadyInclude )

//---------------------------------------------------------------------------//

METHOD nClrText() CLASS TRemMovAlm 

   local cClr  := CLR_BLACK

   if ::oDbfVir:lKitEsc
      cClr     := CLR_GRAY
   end if

RETURN cClr

//---------------------------------------------------------------------------//

METHOD ShowKit( lSet ) CLASS TRemMovAlm 

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

METHOD ShwAlm( oSay, oBtnImp ) CLASS TRemMovAlm 

   if ::oDbf:nTipMov >= 2
      oSay[ 1 ]:Hide()
      oSay[ 4 ]:Hide()
      ::oAlmOrg:Hide()
      oSay[ 1 ]:cText( Space(16) )
      ::oAlmOrg:cText( Space(16) )
   else
      oSay[ 1 ]:Show()
      oSay[ 4 ]:Show()
      ::oAlmOrg:Show()
   end if

RETURN .t.

//---------------------------------------------------------------------------//
/*
Total de la remesa
*/

METHOD nTotRemMov( lPic ) CLASS TRemMovAlm 

   local nTot     := 0

   if !empty( ::oDbf ) .and. ::oDbf:Used() .and. !empty( ::oDetMovimientos ) .and. ::oDetMovimientos:oDbf:Used()

      if ::oDetMovimientos:oDbf:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
         while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDetMovimientos:oDbf:nNumRem, 9 ) + ::oDetMovimientos:oDbf:cSufRem .and. !::oDetMovimientos:oDbf:Eof()
            nTot  +=  nTotLMovAlm( ::oDetMovimientos:oDbf )
            ::oDetMovimientos:oDbf:Skip()
         end while
      end if

   end if

RETURN ( if( IsTrue( lPic ), Trans( nTot, ::cPirDiv ), nTot ) )

//--------------------------------------------------------------------------//

Function RemMovAlm( oMenuItem, oWnd ) 

   DEFAULT  oMenuItem   := "01050"
   DEFAULT  oWnd        := oWnd()

   if empty( oRemesas )

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

      oRemesas          := TRemMovAlm():New( cPatEmp(), cDriver(), oWnd, oMenuItem )
      if !empty( oRemesas )
         oRemesas:Play()
      end if

      oRemesas          := nil

   end if

RETURN NIL

//--------------------------------------------------------------------------//

METHOD lSelAllDoc( lSel ) CLASS TRemMovAlm 

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

METHOD lSelDoc() CLASS TRemMovAlm 

   ::oDbfVir:Load()
   ::oDbfVir:lSelDoc := !::oDbfVir:lSelDoc
   ::oDbfVir:Save()

   ::oBrwDet:Refresh()

RETURN nil

//--------------------------------------------------------------------------//
//  [ trim( CallHbFunc( 'oTInfGen', ['nombrePrimeraPropiedad()'] ) ) ]

METHOD DataReport( oFr ) CLASS TRemMovAlm 

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Movimiento", ::oDbf:nArea, .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Movimiento", cObjectsToReport( ::oDbf ) )

   if !empty( ::oDetMovimientos )
      oFr:SetWorkArea(     "Lineas de movimientos", ::oDetMovimientos:oDbf:nArea )
      oFr:SetFieldAliases( "Lineas de movimientos", cObjectsToReport( ::oDetMovimientos:oDbf ) )
   end if

   oFr:SetWorkArea(     "Empresa", ::oDbfEmp:nArea )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Almacén origen", ::oAlmacenOrigen:nArea )
   oFr:SetFieldAliases( "Almacén origen", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Almacén destino", ::oAlmacenDestino:nArea )
   oFr:SetFieldAliases( "Almacén destino", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Agentes", ::oDbfAge:nArea )
   oFr:SetFieldAliases( "Agentes", cItemsToReport( aItmAge() ) )
   
   if !empty( ::oDetMovimientos )
      oFr:SetWorkArea(     "Artículos", ::oArt:nArea )
      oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

      oFr:SetMasterDetail( "Movimiento",              "Lineas de movimientos",   {|| Str( ::oDbf:nNumRem ) + ::oDbf:cSufRem } )
      oFr:SetMasterDetail( "Lineas de movimientos",   "Artículos",               {|| ::oDetMovimientos:oDbf:cRefMov } )
   end if

   oFr:SetMasterDetail( "Movimiento",                 "Empresa",               {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Movimiento",                 "Almacén origen",        {|| ::oDbf:cAlmOrg } )
   oFr:SetMasterDetail( "Movimiento",                 "Almacén destino",       {|| ::oDbf:cAlmDes } )
   oFr:SetMasterDetail( "Movimiento",                 "Agentes",               {|| ::oDbf:cCodAge } )

   oFr:SetResyncPair(   "Movimiento",                 "Empresa" )
   oFr:SetResyncPair(   "Movimiento",                 "Almacén origen" )
   oFr:SetResyncPair(   "Movimiento",                 "Almacén destino" )
   oFr:SetResyncPair(   "Movimiento",                 "Agentes" )

   if !empty( ::oDetMovimientos )
      oFr:SetResyncPair(   "Movimiento",              "Lineas de movimientos" )
      oFr:SetResyncPair(   "Lineas de movimientos",   "Artículos" )
   end if

Return nil

//---------------------------------------------------------------------------//

METHOD VariableReport( oFr ) CLASS TRemMovAlm 

   oFr:DeleteCategory(  "Movimiento" )
   oFr:DeleteCategory(  "Lineas de movimientos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Movimiento",              "Total movimiento",                 "GetHbVar('nTotMov')" )
   oFr:AddVariable(     "Movimiento",              "Tipo de movimiento formato texto", "CallHbFunc('cTipoMovimiento')" )
   oFr:AddVariable(     "Movimiento",              "Almacén origen",                   "CallHbFunc('cTipoMovimiento')" )
   oFr:AddVariable(     "Movimiento",              "Almacén destino",                  "CallHbFunc('cTipoMovimiento')" )

   oFr:AddVariable(     "Lineas de movimientos",   "Detalle del artículo",             "CallHbFunc('cNombreArticuloMovimiento')" )

   oFr:AddVariable(     "Lineas de movimientos",   "Nombre primera propiedad",         "CallHbFunc('nombrePrimeraPropiedadMovimientosAlmacen')" )
   oFr:AddVariable(     "Lineas de movimientos",   "Nombre segunda propiedad",         "CallHbFunc('nombreSegundaPropiedadMovimientosAlmacen')" )

   oFr:AddVariable(     "Lineas de movimientos",   "Total unidades",                   "CallHbFunc('nUnidadesLineaMovimiento')" )
   oFr:AddVariable(     "Lineas de movimientos",   "Total linea movimiento",           "CallHbFunc('nImporteLineaMovimiento')" )

Return nil

//---------------------------------------------------------------------------//

METHOD DesignReportRemMov( oFr, dbfDoc ) CLASS TRemMovAlm 

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

      if !empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      else

         oFr:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
         oFr:SetProperty(     "CabeceraDocumento", "Top", 0 )
         oFr:SetProperty(     "CabeceraDocumento", "Height", 200 )

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 200 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Movimiento" )

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

METHOD PrintReportRemMov( nDevice, nCopies, cPrinter, dbfDoc ) CLASS TRemMovAlm 

   local oFr
   local oWaitMeter
   local nOrdAnt

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

   nOrdAnt              := ::oDetMovimientos:oDbf:OrdSetFocus( "nNumLin" )

   ::DataReport( oFr )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !empty( ( dbfDoc )->mReport )

      oWaitMeter         := TWaitMeter():New( "Generando documento", "Espere por favor..." )
      oWaitMeter:Run()

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Zona de variables--------------------------------------------------------
      */

      ::VariableReport( oFr )

      /*
      Preparar el report-------------------------------------------------------
      */

      oFr:PrepareReport()

      oWaitMeter:End()

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

   ::oDetMovimientos:oDbf:OrdSetFocus( nOrdAnt )

Return .t.

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

   oLabelGenetator      := TLabelGeneratorMovimientosAlmacen():New( Self )
   oLabelGenetator:Dialog()

   /*
   Dejamos la tabla como estaba------------------------------------------------
   */

   ::oDbf:SetStatus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD importarInventario() CLASS TRemMovAlm

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "IMPORTAR_INVENTARIO" 

      REDEFINE GET ::memoInventario ;
         MEMO ;
         ID       110 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( ::porcesarInventario(), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ::porcesarInventario(), oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

Return ( Self )

//---------------------------------------------------------------------------//

METHOD porcesarInventario() CLASS TRemMovAlm

   local cInventario
   local aInventario    := hb_atokens( ::memoInventario, CRLF )

   ::aInventarioErrors  := {}

   for each cInventario in aInventario
      ::procesarArticuloInventario( cInventario )
   next 

   ::showInventarioErrors()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD showInventarioErrors() CLASS TRemMovAlm

   local cErrorMessage  := ""

   if !empty( ::aInventarioErrors )
      aeval(::aInventarioErrors, {|cError| cErrorMessage += cError + CRLF } )   
      msgstop( cErrorMessage, "Errores en la importación" )
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD procesarArticuloInventario( cInventario ) CLASS TRemMovAlm

   local cCodigo
   local nUnidades
   local cCodigoPrimeraPropiedad
   local cCodigoSegundaPropiedad
   local cValorPrimeraPropiedad
   local cValorSegundaPropiedad
   local aInventario             := hb_atokens( cInventario, "," )

   if hb_isarray( aInventario ) 

      if len( aInventario ) >= 2
         cCodigo                 := alltrim( aInventario[ 1 ] )
         nUnidades               := val( strtran( aInventario[ 2 ], ".", "," ) )
      end if 

      if len( aInventario ) >= 6
         cCodigoPrimeraPropiedad := alltrim( aInventario[ 3 ] )
         cValorPrimeraPropiedad  := alltrim( aInventario[ 4 ] )
         cCodigoSegundaPropiedad := alltrim( aInventario[ 5 ] )
         cValorSegundaPropiedad  := alltrim( aInventario[ 6 ] )
      end if 

      if !hb_isstring( cCodigo ) 
         aadd( ::aInventarioErrors, "El código del artículo no es un valor valido." )
         Return ( Self )   
      end if 

      if !hb_isnumeric( nUnidades )
         aadd( ::aInventarioErrors, "Las unidades del artículo no contienen un valor valido." )
         Return ( Self )   
      end if 

      ::insertaArticuloRemesaMovimiento( cCodigo, nUnidades, cCodigoPrimeraPropiedad, cValorPrimeraPropiedad, cCodigoSegundaPropiedad, cValorSegundaPropiedad )

   end if 

   if !empty( ::oBrwDet )
      ::oBrwDet:Refresh()
   end if 

Return ( Self )

//---------------------------------------------------------------------------//
// Trata de insertar el articulo en la remesa de moviemitnos-------------------

METHOD insertaArticuloRemesaMovimiento( cCodigo, nUnidades, cCodigoPrimeraPropiedad, cValorPrimeraPropiedad, cCodigoSegundaPropiedad, cValorSegundaPropiedad ) CLASS TRemMovAlm

   ::oDetMovimientos:oDbfVir:Blank()

   ::oDetMovimientos:oDbfVir:cRefMov      := cCodigo
   ::oDetMovimientos:oDbfVir:nUndMov      := nUnidades
   ::oDetMovimientos:oDbfVir:nNumLin      := nLastNum( ::oDetMovimientos:oDbfVir:cAlias )

   if hb_isstring( cCodigoPrimeraPropiedad )   
      ::oDetMovimientos:oDbfVir:cCodPr1   := cCodigoPrimeraPropiedad
   end if 

   if hb_isstring( cValorPrimeraPropiedad )   
      ::oDetMovimientos:oDbfVir:cValPr1   := cValorPrimeraPropiedad
   end if 

   if hb_isstring( cCodigoSegundaPropiedad )   
      ::oDetMovimientos:oDbfVir:cCodPr2   := cCodigoSegundaPropiedad
   end if 

   if hb_isstring( cValorSegundaPropiedad )   
      ::oDetMovimientos:oDbfVir:cValPr2   := cValorSegundaPropiedad
   end if 

   if !( ::oDetMovimientos:loadArticulo( APPD_MODE, .t. ) )
      aadd( ::aInventarioErrors, "El código de artículo " + cCodigo + " no es un valor valido." )
   end if 

   if ::oDetMovimientos:isNumeroSerieNecesario( APPD_MODE, .f. )
      aadd( ::aInventarioErrors, "El código de artículo " + cCodigo + " necesita proporcinarle el numero de serie." )
      ::oDetMovimientos:oDbfVir:Cancel()
   end if 

   if ::oDetMovimientos:accumulatesStoreMovement()
      
      ::oDetMovimientos:oDbfVir:Cancel()
   
   else
      
      ::oDetMovimientos:oDbfVir:Insert()

      ::oDetMovimientos:appendKit()

   end if 
   
Return ( Self )

//---------------------------------------------------------------------------//

METHOD saveResourceWithCalculate( nMode, oDlg ) CLASS TRemMovAlm

   ::TComercio:resetProductsToUpdateStocks()

   if ::lSave( nMode )

      ::oDbf:lWait         := .f.
      ::oDbf:lSelDoc       := .t.

      ::endResource( .t., nMode, oDlg )

      ::TComercio:updateWebProductStocks()

      oDlg:End( IDOK )

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

Function oStockMovimientoFechaPrevia( idArticulo, idAlmacen, valorPropiedad1, valorPropiedad2, fechaFin )

   fechaFin    -= 1 

Return ( oThis:oStock:nStockAlmacen( idArticulo, idAlmacen, valorPropiedad1, valorPropiedad2, nil, nil, fechaFin, nil, nil ) )

//---------------------------------------------------------------------------//

Function oStockMovimientoPrevio( idArticulo, idAlmacen, valorPropiedad1, valorPropiedad2, fechaFin, horaFin )

   if empty( horaFin )
      horaFin  := "000000"
   end if 

   if horaFin == "000000"
      fechaFin := fechaFin - 1 
      horaFin  := "235959"
   else 
      horaFin  := priorSecond( horaFin )
   end if 

Return ( oThis:oStock:nStockAlmacen( idArticulo, idAlmacen, valorPropiedad1, valorPropiedad2, nil, nil, fechaFin, nil, horaFin ) )

//---------------------------------------------------------------------------//

Function cNombreArticuloMovimiento()

Return ( RetFld( oThis:oDetMovimientos:oDbf:cRefMov, oThis:oArt:cAlias, "Nombre" ) )

//---------------------------------------------------------------------------//

Function nUnidadesLineaMovimiento()

Return nTotNMovAlm( oThis:oDetMovimientos:oDbf )

//---------------------------------------------------------------------------//

Function nImporteLineaMovimiento()

Return nTotLMovAlm( oThis:oDetMovimientos:oDbf )

//---------------------------------------------------------------------------//

Function cTipoMovimiento()

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

Function cAlmacenOrigen()

Return ( oRetFld( oThis:oParent:oDbf:cAlmOrg, oThis:oParent:oAlm ) )

//---------------------------------------------------------------------------//

Function cAlmacenDestino()

Return ( oRetFld( oThis:oParent:oDbf:cAlmDes, oThis:oParent:oAlm ) )

//---------------------------------------------------------------------------//

Function rxRemMov( cPath, oMeter )

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
      msgstop( "Imposible abrir en modo exclusivo la tabla de albaranes de clientes" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

STATIC Function CreateFiles( cPath )

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
   aAdd( aBase, { "cTimRem",   "C",   6,  0, "Hora"                 } )
   aAdd( aBase, { "cAlmOrg",   "C",  16,  0, "Alm. org."            } )
   aAdd( aBase, { "cAlmDes",   "C",  16,  0, "Alm. des."            } )
   aAdd( aBase, { "cCodDiv",   "C",   3,  0, "Div."                 } )
   aAdd( aBase, { "nVdvDiv",   "N",  13,  6, "Cambio de la divisa"  } )
   aAdd( aBase, { "cComMov",   "C", 100,  0, "Comentario"           } )

Return ( aBase )

//---------------------------------------------------------------------------//
/*
Function IsRemMov( cPath )

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
*/
//---------------------------------------------------------------------------//

Function nTotNRemMov( uDbf )

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
   local dbfArticulo
   local nTotRem  := 0
   local nOrdAnt

   DEFAULT cPath  := cPatEmp()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPath + "REMMOVT.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "REMMOV", @dbfRemMov ) )
   SET ADSINDEX TO ( cPath + "REMMOVT.CDX" ) ADDITIVE

   USE ( cPath + "HISMOV.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "HISMOV", @dbfHisMov ) )
   SET ADSINDEX TO ( cPath + "HISMOV.CDX" ) ADDITIVE

   USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
   SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   /*
   Cabeceras-------------------------------------------------------------------
   */

   ( dbfRemMov )->( ordSetFocus( 0 ) )

   ( dbfRemMov )->( dbGoTop() )
   while !( dbfRemMov )->( eof() )

      if empty( ( dbfRemMov )->cSufRem )
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

      if empty( ( dbfHisMov )->cSufRem )
         ( dbfHisMov )->cSufRem        := "00"
      end if

      if empty( ( dbfHisMov )->cNomMov )
         ( dbfHisMov )->cNomMov        := RetArticulo( ( dbfHisMov )->cRefMov, dbfArticulo )
      end if 

      if empty( ( dbfHisMov )->dFecMov )

         dFecMov                       := RetFld( Str( ( dbfHisMov )->nNumRem ) + ( dbfHisMov )->cSufRem, dbfRemMov, "dFecRem", "cNumRem" )

         if empty( dFecMov )
            dFecMov                    := CtoD( "01/01/" + Str( Year( Date() ) ) )
         end if

         ( dbfHisMov )->dFecMov        := dFecMov

      end if

      if empty( ( dbfHisMov )->cTimMov )
         ( dbfHisMov )->cTimMov        := RetFld( Str( ( dbfHisMov )->nNumRem ) + ( dbfHisMov )->cSufRem, dbfRemMov, "cTimRem", "cNumRem" )
      end if

      if empty( ( dbfHisMov )->cRefMov )

         nOrdAnt                       := ( dbfArticulo )->( OrdSetFocus( "Nombre" ) )

         if ( dbfArticulo )->( dbSeek( Padr( ( dbfHisMov )->cNomMov, 100 ) ) )
            ( dbfHisMov )->cRefMov     := ( dbfArticulo )->Codigo
         end if

         ( dbfArticulo )->( OrdSetFocus( nOrdAnt ) )

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

      msgstop( "Imposible abrir todas las bases de datos de movimientos de almacén" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfRemMov )
   CLOSE ( dbfHisMov )
   CLOSE ( dbfArticulo )

return nil

//---------------------------------------------------------------------------//

Function AppMovimientosAlmacen()

   local oRemMovAlm     := TRemMovAlm():New()

   if oRemMovAlm:OpenFiles()
      oRemMovAlm:Append()
      oRemMovAlm:CloseFiles()
   end if

   if !empty( oRemMovAlm )
      oRemMovAlm:End()
   end if

return .t.

//---------------------------------------------------------------------------//

Function EditMovimientosAlmacen( cNumParte, oBrw )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New()

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

Function ZoomMovimientosAlmacen( cNumParte, oBrw )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New()

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

Function DelMovimientosAlmacen( cNumParte, oBrw )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New()

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

Function PrnMovimientosAlmacen( cNumParte )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New()

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

Function VisMovimientosAlmacen( cNumParte )

   local oRemMovAlm

   oRemMovAlm           := TRemMovAlm():New()

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

Function nTotNMovOld( uDbf )

   local nTotUnd  := 0

   do case
   case ValType( uDbf ) == "C"
      nTotUnd     := NotCaja( ( uDbf )->nCajAnt ) * ( uDbf )->nUndAnt
   case ValType( uDbf ) == "O"
      nTotUnd     := NotCaja( uDbf:nCajAnt ) * uDbf:nUndAnt
   end case

RETURN ( nTotUnd )

//-------------------------------------------------------------------------//

Function nTotLMovAlm( uDbf )

   local nTotUnd  := nTotNMovAlm( uDbf )

   do case
   case ValType( uDbf ) == "C"
      nTotUnd     := NotCaja( ( uDbf )->nCajMov ) * ( uDbf )->nUndMov * ( uDbf )->nPreDiv
   case ValType( uDbf ) == "O"
      //nTotUnd     := NotCaja( uDbf:nCajMov ) * uDbf:nUndMov * uDbf:nPreDiv
      nTotUnd     := NotCaja( uDbf:FieldGetByName( "nCajMov" ) ) * uDbf:FieldGetByName( "nUndMov" ) * uDbf:FieldGetByName( "nPreDiv" )
   end case

RETURN ( nTotUnd )

//---------------------------------------------------------------------------//

Function nTotNMovAlm( uDbf )

   local nTotUnd  := 0

   do case
   case ValType( uDbf ) == "C"
      nTotUnd     := NotCaja( ( uDbf )->nCajMov ) * ( uDbf )->nUndMov
   case ValType( uDbf ) == "O"
      //nTotUnd     := NotCaja( uDbf:nCajMov ) * uDbf:nUndMov
      nTotUnd     := NotCaja( uDbf:FieldGetByName( "nCajMov" ) ) * uDbf:FieldGetByName( "nUndMov" )
   end case

RETURN ( nTotUnd )

//-------------------------------------------------------------------------//

Function nTotVMovAlm( cCodArt, dbfMovAlm, cCodAlm )

   local nTotVta  := 0
   local nOrd     := ( dbfMovAlm )->( OrdSetFocus( "cRefMov" ) )
   local nRec     := ( dbfMovAlm )->( Recno() )

   if ( dbfMovAlm )->( dbSeek( cCodArt ) )

      while ( dbfMovAlm )->cRefMov == cCodArt .and. !( dbfMovAlm )->( eof() )

         if !( dbfMovAlm )->lNoStk

            if cCodAlm != nil

               if cCodAlm == ( dbfMovAlm )->cAliMov
                  nTotVta  += nTotNMovAlm( dbfMovAlm )
               end if

               if cCodAlm == ( dbfMovAlm )->cAloMov
                  nTotVta  -= nTotNMovAlm( dbfMovAlm )
               end if

            else

               if !empty( ( dbfMovAlm )->cAliMov )
                  nTotVta  += nTotNMovAlm( dbfMovAlm )
               end if

               if !empty( ( dbfMovAlm )->cAloMov )
                  nTotVta  -= nTotNMovAlm( dbfMovAlm )
               end if

            end if

         end if

         ( dbfMovAlm )->( dbSkip() )

      end while

   end if

   ( dbfMovAlm )->( dbGoTo( nRec ) )
   ( dbfMovAlm )->( OrdSetFocus( nOrd ) )

return ( nTotVta )

//---------------------------------------------------------------------------//

Function cTextoMovimiento( dbfHisMov )

Return ( { "Entre almacenes", "Regularización", "Objetivos", "Consolidación" }[ Min( Max( ( dbfHisMov )->nTipMov, 1 ), 4 ) ] )

//---------------------------------------------------------------------------//

Function ZooMovAlm( nNumRec, oBrw )

RETURN NIL

//----------------------------------------------------------------------------//

Function nombrePrimeraPropiedadMovimientosAlmacen()

Return ( nombrePropiedad( oThis:oDetMovimientos:oDbf:FieldGetByName( "cCodPr1" ), oThis:oDetMovimientos:oDbf:FieldGetByName( "cValPr1" ), oThis:nView ) )

//---------------------------------------------------------------------------//

Function nombreSegundaPropiedadMovimientosAlmacen()

Return ( nombrePropiedad( oThis:oDetMovimientos:oDbf:FieldGetByName( "cCodPr2" ), oThis:oDetMovimientos:oDbf:FieldGetByName( "cValPr2" ), oThis:nView ) )

//---------------------------------------------------------------------------//

Function DesignLabelRemesasMovimientosAlmacen( oFr, cDoc )

   local oLabel
   local oRemesasMovimientos

   oRemesasMovimientos  := TRemMovAlm():New( cPatEmp(), cDriver() )
   if !oRemesasMovimientos:Openfiles()
      Return ( nil )
   end if 

   oLabel               := TLabelGeneratorMovimientosAlmacen():New( oRemesasMovimientos )

   // Zona de datos---------------------------------------------------------
   
   oLabel:createTempLabelReport()
   oLabel:loadTempLabelReport()      
   oLabel:dataLabel( oFr )

   // Paginas y bandas------------------------------------------------------

   if !empty( ( cDoc )->mReport )
      oFr:LoadFromBlob( ( cDoc )->( Select() ), "mReport")
   else
      oFr:AddPage(         "MainPage" )
      oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
      oFr:SetProperty(     "MasterData",  "Top",      200 )
      oFr:SetProperty(     "MasterData",  "Height",   100 )
      oFr:SetObjProperty(  "MasterData",  "DataSet",  "Lineas de movimientos de almacén" )
   end if

   oFr:DesignReport()
   oFr:DestroyFr()

   oLabel:DestroyTempReport()
   oLabel:End()

   oRemesasMovimientos:CloseFiles()

Return ( nil )

//---------------------------------------------------------------------------//