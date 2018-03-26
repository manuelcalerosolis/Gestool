#include "FiveWin.Ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "Report.ch"
#include "XBrowse.ch"
#include "FastRepH.ch"

static oThis

//---------------------------------------------------------------------------//

Function StartTCobAge()

   local oTCobAge

   oTCobAge := TCobAge():New( cPatEmp(), cDriver(), oWnd(), "liquidacion_de_agentes" )

   if !Empty( oTCobAge )
      oTCobAge:Activate()
   end if

Return nil

//---------------------------------------------------------------------------//

CLASS TCobAge FROM TMasDet

   DATA  oRecibos

   DATA  oFacCliT
   DATA  oFacCliL
   DATA  oFacRecT
   DATA  oFacRecL
   DATA  oFacCliP
   DATA  oAntCliT
   DATA  oFacPrvT
   DATA  oFacPrvL
   DATA  oFacPrvP

   DATA  oClientes
   DATA  oArticulo
   DATA  oAgentes
   DATA  oAgeRel
   DATA  oBandera
   DATA  oIva
   DATA  oDivisas
   DATA  oEmpresa
   DATA  oCount
   DATA  oProvee
   DATA  oPrvBnc
   DATA  oFPago

   DATA  oDbfDoc

   DATA  cPorDiv

   DATA  oMeter
   DATA  nMeter      AS NUMERIC  INIT 0

   DATA  aMsg        AS ARRAY    INIT {}

   DATA  oCodAge
   DATA  cCodAge

   DATA  oSer                    INIT Array( 26 )
   DATA  aSer                    INIT Afill( Array( 26 ), .t. )

   DATA  oFecIni
   DATA  oFecFin
   
   DATA  lFacLiq
   DATA  lFacturasComisiones
   DATA  lFacturasNoCobradas
   DATA  lFacturasParcialmente
   DATA  lFacturasTotalmente
   DATA  lFacturasIncluidas

   DATA  oBmp
   DATA  bmpConta

   DATA  aAgentesRelacionados    INIT {}

   DATA  oBrwDet

   DATA  oDetCobAge

   DATA  aDbfVir                 INIT { { .f., "", 0, "", Ctod( "" ), "", "", 0, 0, .f., "" } }

   DATA  oMnuRec

   DATA  cOldAge                 INIT ""

   METHOD New( cPath, cDriver, oWndParent, oMenuItem )
   METHOD Create( cPath, cDriver, oWndParent )

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD OpenService( lExclusive, cPath )
   METHOD CloseService()

   METHOD Resource( nMode )
   METHOD Activate()

   METHOD Report()

   METHOD lSave()

   METHOD cValidCobro()

   METHOD DefineFiles()

   METHOD ValidAgente( oSay )

   METHOD ImportaFacturaAgentes( oBrwDet )

   METHOD AsistenteImportarFacturas()

   METHOD EdtLiqAge( nMode )

   METHOD lAgenteRelaciondo()    INLINE ( !Empty( ::aAgentesRelacionados ) )

   METHOD Del()

   METHOD nTotComAge()

   METHOD nTotLiq( lPic )
   METHOD nTotFac( lPic )

   METHOD nTotLiqAge( cNumLiq, lPic )

   METHOD Cancelar()

   METHOD OpenError()

   METHOD LiquidaFacturaCliente( cNumFac, nMark )

   METHOD BrwRecCli( oGet )

   METHOD IntBtnPrv( oPag, oDlg )
   METHOD IntBtnNxt( oPag, oDlg )

   METHOD dFecLiqAge( cNumLiq )

   METHOD nTotImp()
   METHOD nTotCom()

   METHOD GenLiquidacion( nDevice, cCaption, cCodDoc, cPrinter )
   METHOD lGenLiquidacion( oBrw, oBtn, nDevice )
   METHOD bGenLiquidacion( nDevice, cTitle, cCodDoc )
   METHOD nGenLiquidacion( nDevice, cTitle, cCodDoc, cPrinter, nCopy )

   METHOD PrintReport( nDevice, nCopies, cPrinter, dbfDoc )
   METHOD DesignReport()

   METHOD StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden )

   METHOD PrnSerie()
   METHOD DataReport()
   METHOD VariableReport()

   METHOD lFacturaProcesar( lRectificativa, cCodigoAgente, lAgenteRelacionado )

   METHOD EdtRecMenu( oDlg )

   METHOD GeneraFacturaGastos()

   METHOD Contabilizar()
   METHOD ChangeConta( lCnt )    INLINE ( ::oDbf:FieldPutByName( "lConta", lCnt ), ::oWndBrw:Refresh() )

   METHOD lContabilizar( nAsiento )
   
   METHOD lValidFacturaProveedor( oGetFactura, nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem ) CLASS TCobAge

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := GetWndFrame()
   DEFAULT cDriver         := cDriver()

   if oMenuItem != nil
      ::nLevel             := Auth():Level( oMenuItem )
   else
      ::nLevel             := 1
   end if

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   ::cPath                 := cPath
   ::oWndParent            := oWndParent
   ::oDbf                  := nil
   ::cDriver               := cDriver

   ::cCodAge               := Space( 5 )

   ::lFacLiq               := .f.
   ::lFacturasComisiones   := .t.
   ::lFacturasNoCobradas   := .t.
   ::lFacturasParcialmente := .t.
   ::lFacturasTotalmente   := .t.
   ::lFacturasIncluidas    := .f.

   ::lMoveDlgSelect        := .t.

   ::oBmp                  := LoadBitmap( 0, 32760 )
   ::bmpConta              := LoadBitmap( GetResources(), "bConta" )

   ::cNumDocKey            := "nNumCob"
   ::cSufDocKey            := "cSufCob"

   ::bFirstKey             := {|| Str( ::oDbf:nNumCob, 9 ) + ::oDbf:cSufCob }

   ::oDetCobAge            := TDetCobAge():New( cPath, ::cDriver, Self )
   ::AddDetail( ::oDetCobAge )

   oThis                   := Self

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath, cDriver, oWndParent ) CLASS TCobAge

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := GetWndFrame()
   DEFAULT cDriver         := cDriver()

   ::cPath                 := cPath
   ::oWndParent            := oWndParent
   ::cDriver               := cDriver

   ::oDetCobAge            := TDetCobAge():New( cPath, ::cDriver, Self )
   ::AddDetail( ::oDetCobAge )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TCobAge

   local oImp
   local oPrv
   local oPdf

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if !::OpenFiles()
      return nil
   end if

   ::cMru            := "gc_briefcase2_agent_16"

   ::CreateShell( ::nLevel )

   ::oWndBrw:bDup    := nil

   ::oWndBrw:GralButtons( Self )

   DEFINE BTNSHELL oImp RESOURCE "IMP" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::nGenLiquidacion( IS_PRINTER ) ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      ::lGenLiquidacion( ::oWndBrw:oBrw, oImp, IS_PRINTER )

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::PrnSerie() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::GenLiquidacion( IS_SCREEN ) ) ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      ::lGenLiquidacion( ::oWndBrw:oBrw, oPrv, IS_SCREEN )

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::GenLiquidacion( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      ::lGenLiquidacion( ::oWndBrw:oBrw, oPdf, IS_PDF )

   /*DEFINE BTNSHELL RESOURCE "gc_document_text_businessman_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::GeneraFacturaGastos( .t. ) ) ;
      TOOLTIP  "Genera factura" ;
      LEVEL    ACC_EDIT*/

   DEFINE BTNSHELL RESOURCE "BmpConta" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::SelectRec( {|| ::Contabilizar( ::lChkSelect ) }, "Contabilizar liquidaciones de agentes", "Simular" , .f. ) ) ;
      TOOLTIP  "(C)ontabilizar" ;
      HOTKEY   "C";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ChgState" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::SelectRec( {|| ::ChangeConta( ::lChkSelect ) }, "Contabilizar", "Contabilizado" ) );
      TOOLTIP  "Cambiar es(t)ado";
      HOTKEY   "T";
      LEVEL    4

   ::oWndBrw:EndButtons( Self )

   ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() } )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TCobAge

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE oDbf FILE "RemAgeT.DBF" CLASS "RemAgeT" ALIAS "RemAgeT" PATH ( cPath ) VIA ( cDriver ) COMMENT  "Liquidación de agentes"

   FIELD NAME "lConta"     TYPE "L" LEN   1 DEC  0                      COMMENT ""        DEFAULT  .f.                                                                            HIDE OF oDbf
   FIELD CALCULATE NAME "bConta"    LEN  14 DEC  0                      COMMENT { "Contabilizado", "gc_folder2_16", 3 } ;
         VAL {|| ( oDbf:cAlias )->lConta } BITMAPS "Sel16", "Nil16"                                                                                                 COLSIZE  20      OF oDbf
   FIELD CALCULATE NAME "bGen"      LEN  14 DEC  0                      COMMENT { "Factura generada", "gc_document_text_user_16", 3 } ;
         VAL {|| !Empty( ( oDbf:cAlias )->cNumFac ) }  BITMAPS "gc_document_text_user_12", "Nil16"                                                                                     COLSIZE  20      OF oDbf
   FIELD NAME "nNumCob"    TYPE "N" LEN   9 DEC  0 PICTURE "999999999"  COMMENT "Número"                                                                  ALIGN RIGHT COLSIZE  80      OF oDbf
   FIELD NAME "cSufCob"    TYPE "C" LEN   2 DEC  0 PICTURE "@!"         COMMENT "Delegación"                                                                          COLSIZE  40      OF oDbf
   FIELD NAME "dFecCob"    TYPE "D" LEN   8 DEC  0 DEFAULT GetSysDate() COMMENT "Fecha"                                                                               COLSIZE  80      OF oDbf
   FIELD NAME "cCodAge"    TYPE "C" LEN   3 DEC  0                      COMMENT "Código agente"                                                                       COLSIZE  40      OF oDbf
   FIELD CALCULATE NAME "cNomAge"   LEN  50 DEC  0                      COMMENT "Agente"  VAL cNbrAgent( ( oDbf:cAlias )->cCodAge, ::oAgentes:cAlias )              COLSIZE 350      OF oDbf
   FIELD NAME "cCodDiv"    TYPE "C" LEN   3 DEC  0 DEFAULT cDivEmp()    COMMENT ""                                                                                                HIDE OF oDbf
   FIELD NAME "nVdvDiv"    TYPE "N" LEN  10 DEC  6                      COMMENT ""        DEFAULT nChgDiv( cDivEmp(), ::oDivisas )                                                HIDE OF oDbf
   FIELD NAME "nTotCob"    TYPE "N" LEN  16 DEC  6                      COMMENT "Total liquidación" ALIGN RIGHT PICTURE cPorDiv()                                     COLSIZE 100      OF oDbf
   FIELD NAME "cCodPrv"    TYPE "C" LEN  12 DEC  0                      COMMENT "Proveedor"                                                                                       HIDE OF oDbf
   FIELD NAME "cNumFac"    TYPE "C" LEN  12 DEC  0                      COMMENT "Factura de gastos"                                                                               HIDE OF oDbf
   FIELD NAME "dFecIni"    TYPE "D" LEN   8 DEC  0 DEFAULT GetSysDate() COMMENT "Fecha inicio de la liquidacion"                                                      COLSIZE  80      OF oDbf
   FIELD NAME "dFecFin"    TYPE "D" LEN   8 DEC  0 DEFAULT GetSysDate() COMMENT "Fecha fin de la liquidacion"                                                         COLSIZE  80      OF oDbf

   INDEX TO "RemAgeT.Cdx" TAG "nNumCob"  ON "Str( nNumCob ) + cSufCob" COMMENT "Número"   NODELETED OF oDbf
   INDEX TO "RemAgeT.Cdx" TAG "cCoaAge"  ON "cCodAge"                  COMMENT "Agente"   NODELETED OF oDbf
   INDEX TO "RemAgeT.Cdx" TAG "dFecCob"  ON "dFecCob"                  COMMENT "Fecha"    NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      lOpen             := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos de remesas." )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if !Empt( ::oDbf )
      ::oDbf:End()
   endif

   ::oDbf   := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD OpenFiles( cPath ) CLASS TCobAge

   local lOpen    := .t.
   local oBlock

   DEFAULT cPath  := cPatEmp()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView     := D():CreateView()

      /*
      Definicion del master-------------------------------------------------------
      */

      if Empty( ::oDbf )
         ::oDbf   := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., .t. )

      ::oDbf:bOpenError := { || ::OpenError() }

      ::OpenDetails()

      /*
      Tablas auxiliares--------------------------------------------------------
      */

      ::oFacCliT := TDataCenter():oFacCliT()

      DATABASE NEW ::oFacCliL FILE "FACCLIL.DBF"   PATH ( cPath ) VIA ( cDriver() ) SHARED INDEX  "FACCLIL.CDX"

      DATABASE NEW ::oFacRecT FILE "FacRecT.DBF"   PATH ( cPath ) VIA ( cDriver() ) SHARED INDEX  "FacRecT.CDX"

      DATABASE NEW ::oFacRecL FILE "FacRecL.DBF"   PATH ( cPath ) VIA ( cDriver() ) SHARED INDEX  "FacRecL.CDX"

      ::oFacCliP := TDataCenter():oFacCliP()

      DATABASE NEW ::oAntCliT FILE "AntCliT.DBF"   PATH ( cPath ) VIA ( cDriver() ) SHARED INDEX  "AntCliT.CDX"

      DATABASE NEW ::oDivisas FILE "DIVISAS.DBF"   PATH ( cPatDat() ) VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

      DATABASE NEW ::oClientes FILE "CLIENT.DBF"   PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

      DATABASE NEW ::oAgentes FILE "AGENTES.DBF"   PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"

      DATABASE NEW ::oAgeRel  FILE "AgeRel.Dbf"    PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "AgeRel.Cdx"

      DATABASE NEW ::oIva     FILE "TIVA.DBF"      PATH ( cPatDat() ) VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      DATABASE NEW ::oEmpresa FILE "EMPRESA.DBF"  PATH ( cPatDat() ) VIA ( cDriver() ) SHARED INDEX "EMPRESA.CDX"

      DATABASE NEW ::oDbfDoc  FILE "RDOCUMEN.DBF"  PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "RDOCUMEN.CDX"
      ::oDbfDoc:OrdSetFocus( "cTipo" )

      DATABASE NEW ::oCount   FILE "NCOUNT.DBF"      PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "NCOUNT.CDX"

      DATABASE NEW ::oFacPrvT FILE "FacPrvT.DBF"   PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX  "FACPRVT.CDX"

      DATABASE NEW ::oFacPrvL FILE "FacPrvL.DBF"   PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX  "FACPRVL.CDX"

      DATABASE NEW ::oFacPrvP FILE "FacPrvP.DBF"   PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX  "FACPRVP.CDX"

      DATABASE NEW ::oProvee  FILE "PROVEE.DBF"    PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX  "PROVEE.CDX"

      DATABASE NEW ::oPrvBnc  FILE "PRVBNC.DBF"    PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX  "PRVBNC.CDX"

      DATABASE NEW ::oFPago   FILE "FPAGO.DBF"     PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX  "FPAGO.CDX"

      DATABASE NEW ::oArticulo FILE "ARTICULO.DBF" PATH ( cPatEmp() ) VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      ::cPorDiv   := cPorDiv( cDivEmp(), ::oDivisas:cAlias ) // Picture de la divisa redondeada

      ::oBandera  := TBandera():New

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TCobAge

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::CloseDetails()

   if !Empty ( ::oAgentes ) .and. ::oAgentes:Used()
      ::oAgentes:End()
   end if

   if !Empty ( ::oAgeRel ) .and. ::oAgeRel:Used()
      ::oAgeRel:End()
   end if

   if !Empty ( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty ( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty ( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if

   if !Empty ( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if

   if !Empty ( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   if !Empty ( ::oDivisas ) .and. ::oDivisas:Used()
      ::oDivisas:End()
   end if

   if !Empty ( ::oClientes ) .and. ::oClientes:Used()
      ::oClientes:End()
   end if

   if !Empty ( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if

   if !Empty ( ::oDbfDoc ) .and. ::oDbfDoc:Used()
      ::oDbfDoc:End()
   end if

   if !Empty ( ::oEmpresa ) .and. ::oEmpresa:Used()
      ::oEmpresa:End()
   end if

   if !Empty ( ::oCount ) .and. ::oCount:Used()
      ::oCount:End()
   end if

   if !Empty ( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if !Empty ( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty ( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if

   if !Empty ( ::oProvee ) .and. ::oProvee:Used()
      ::oProvee:End()
   end if

   if !Empty ( ::oArticulo ) .and. ::oArticulo:Used()
      ::oArticulo:End()
   end if

   if !Empty ( ::oPrvBnc ) .and. ::oPrvBnc:Used()
      ::oPrvBnc:End()
   end if

   if !Empty ( ::oFPago ) .and. ::oFPago:Used()
      ::oFPago:End()
   end if

   if !Empty( ::oMnuRec )
      ::oMnuRec:End()
   end if

   D():DeleteView( ::nView )

   ::oAgentes     := nil
   ::oFacCliT     := nil
   ::oFacCliL     := nil
   ::oFacCliP     := nil
   ::oFacRecT     := nil
   ::oFacRecL     := nil
   ::oDivisas     := nil
   ::oClientes    := nil
   ::oArticulo    := nil
   ::oDbfDoc      := nil
   ::oEmpresa     := nil
   ::oCount       := nil
   ::oIva         := nil
   ::oDbf         := nil
   ::oMnuRec      := nil
   ::oFacPrvT     := nil
   ::oFacPrvL     := nil
   ::oFacPrvP     := nil
   ::oProvee      := nil
   ::oPrvBnc      := nil
   ::oFPago       := nil

   DeleteObject( ::oBmp )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TCobAge

   local oDlg
   local oSay
   local cSay
   local oBmpDiv
   local oBtnFac
   local oGetCodAge
   local oGetCodDiv
   local oGetValDiv
   local oBmpGeneral
   local oBtnAst

   if ( nMode == APPD_MODE )
      ::oDbf:dFecCob := GetSysDate()
      ::oDbf:dFecIni := Ctod( "01/" + Str( Month( GetSysDate() ), 2 ) + "/" + Str( Year( GetSysDate() ), 4 ) )
      ::oDbf:dFecFin := GetSysDate()
      ::oDbf:cCodDiv := cDivEmp()
      ::oDbf:nVdvDiv := nChgDiv( cDivEmp(), ::oDivisas )
   end if

   ::cOldAge         := ::oDbf:cCodAge
   cSay              := cNbrAgent( ::oDbf:cCodAge, ::oAgentes )

   ::lLoadDivisa( ::oDbf:cCodDiv )

   DEFINE DIALOG oDlg RESOURCE "CobAge" TITLE LblTitle( nMode ) + "liquidación de agentes"

      REDEFINE BITMAP oBmpGeneral ;
         ID       990 ;
         RESOURCE "gc_briefcase2_agent_48" ;
         TRANSPARENT ;
         OF       oDlg

      REDEFINE GET ::oDbf:nNumCob ;
			ID 		100 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "nNumCob" ):cPict ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cSufCob ;
			ID 		110 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "cSufCob" ):cPict ;
         OF       oDlg

      REDEFINE GET ::oDbf:dFecCob ;
         ID       120 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oFecIni VAR ::oDbf:dFecIni ;
         ID       180 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oFecFin VAR ::oDbf:dFecFin ;
         ID       190 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*REDEFINE GET oFactura VAR ::oDbf:cNumFac ;
         ID       180 ;
         PICTURE  "@R X/#########/XX" ;
         BITMAP   "Lupa" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      oFactura:bHelp       := {|| BrwFacPrvLiq( oFactura, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oIva:cAlias, ::oDivisas:cAlias ) }
      oFactura:bValid      := {|| ::lValidFacturaProveedor( oFactura, nMode ) }*/

      /*REDEFINE BTNBMP oBtnFac ;
         ID       190 ;
         OF       oDlg ;
         RESOURCE "gc_document_text_businessman_16" ;
         NOBORDER

      oBtnFac:bAction      := {|| EdtFacPrv( ::oDbf:cNumFac ) }*/

      REDEFINE GET ::oCodAge VAR ::oDbf:cCodAge UPDATE ;
         ID       130 ;
         PICTURE  "@!" ;
         BITMAP   "Lupa" ;
         OF       oDlg

      ::oCodAge:bWhen      := {|| nMode == APPD_MODE }
      ::oCodAge:bValid     := {|| ::ValidAgente( oSay ) }
      ::oCodAge:bHelp      := {|| BrwAgentes( ::oCodAge, oSay ), .t. }

      REDEFINE GET oSay VAR cSay UPDATE ;
         ID       131 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE BUTTON oBtnAst;
         ID       170 ;
         OF       oDlg; 
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ::AsistenteImportarFacturas()    

      REDEFINE GET oGetCodDiv VAR ::oDbf:cCodDiv UPDATE ;
         WHEN     ( nMode == APPD_MODE .and. ::oDbf:LastRec() == 0 ) ;
         PICTURE  "@!";
         ID       140 ;
         BITMAP   "LUPA" ;
         OF       oDlg

         oGetCodDiv:bValid := {|| cDivOut( oGetCodDiv, oBmpDiv, oGetValDiv, nil, nil, nil, nil, nil, nil, nil, ::oDivisas:cAlias, ::oBandera ) }
         oGetCodDiv:bHelp  := {|| BrwDiv( oGetCodDiv, oBmpDiv, oGetValDiv, ::oDivisas:cAlias, ::oBandera ) }

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       141;
         OF       oDlg

      REDEFINE GET oGetValDiv VAR ::oDbf:nVdvDiv ;
         WHEN     ( .f. ) ;
         ID       142 ;
         VALID    ( ::oDbf:nVdvDiv > 0 ) ;
			PICTURE	"@E 999,999.9999" ;
         OF       oDlg

       /*
       Botones de acceso________________________________________________________________
       */

      REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg ;
         WHEN     ( !Empty( ::oDbf:cCodAge ) .and. nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetCobAge:Append( ::oBrwDet ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oDlg ;
         WHEN     ( !Empty( ::oDbf:cCodAge ) .and. nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetCobAge:Append( ::oBrwDet, .t. ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( !Empty( ::oDbf:cCodAge ) .and. nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetCobAge:Edit( ::oBrwDet ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg ;
         WHEN     ( !Empty( ::oDbf:cCodAge ) .and. nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetCobAge:Del( ::oBrwDet ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oDlg ;
         WHEN     ( !Empty( ::oDbf:cCodAge ) .and. nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetCobAge:Zoom() )

      /*
      Browse de materiales-----------------------------------------------------
      */

      ::oBrwDet                  := IXBrowse():New( oDlg )

      ::oBrwDet:lFooter          := .t.
      ::oBrwDet:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwDet:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oDetCobAge:oDbfVir:SetBrowse( ::oBrwDet )

      ::oBrwDet:nMarqueeStyle    := 6
      ::oBrwDet:cName            := "Lineas de liquidación de agentes"

      with object ( ::oBrwDet:AddCol() )
         :cHeader                := "Tipo"
         :bStrData               := {|| if( ::oDetCobAge:oDbfVir:lFacRec, "Rectificativa", "Factura" ) }
         :nWidth                 := 60
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                := "Número factura"
         :cSortOrder             := "nNumCob"
         :bStrData               := {|| ::oDetCobAge:oDbfVir:cSerFac + "/" + Alltrim( Str( ::oDetCobAge:oDbfVir:nNumFac ) ) }
         :nWidth                 := 90
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                := "Fecha"
         :cSortOrder             := "dFecFac"
         :bStrData               := {|| ::oDetCobAge:oDbfVir:dFecFac }
         :nWidth                 := 75
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                := "Delegación"
         :bStrData               := {|| ::oDetCobAge:oDbfVir:cSufFac }
         :nWidth                 := 60
         :lHide                  := .t.
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                := "Cliente"
         :cSortOrder             := "cCodCli"
         :bStrData               := {|| Rtrim( ::oDetCobAge:oDbfVir:cCodCli ) }
         :nWidth                 := 60
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                := "Nombre"
         :cSortOrder             := "cNomCli"
         :bStrData               := {|| Rtrim( ::oDetCobAge:oDbfVir:cNomCli ) }
         :nWidth                 := 160
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                := "Agente"
         :cSortOrder             := "cCodAge"
         :bStrData               := {|| ::oDetCobAge:oDbfVir:cCodAge }
         :nWidth                 := 70
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                := "Base comisionable"
         :bEditValue             := {|| ::oDetCobAge:oDbfVir:nImpCom }
         :bFooter                := {|| ::nTotImp() }
         :cEditPicture           := ::cPorDiv
         :nWidth                 := 110
         :nDataStrAlign          := AL_RIGHT
         :nHeadStrAlign          := AL_RIGHT
         :nFootStrAlign          := AL_RIGHT
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                := "%Com."
         :bEditValue             := {|| ::oDetCobAge:oDbfVir:nComAge }
         :cEditPicture           := "@E 999.99"
         :nWidth                 := 50
         :nDataStrAlign          := AL_RIGHT
         :nHeadStrAlign          := AL_RIGHT
      end with

      with object ( ::oBrwDet:AddCol() )
         :cHeader                := "Total comisión"
         :bEditValue             := {|| ::oDetCobAge:nTotalLineaVirtual() }
         :bFooter                := {|| ::nTotCom() }
         :cEditPicture           := ::cPorDiv
         :nWidth                 := 110
         :nDataStrAlign          := AL_RIGHT
         :nHeadStrAlign          := AL_RIGHT
         :nFootStrAlign          := AL_RIGHT
      end with

      ::oBrwDet:CreateFromResource( 150 )

      if nMode != ZOOM_MODE
         ::oBrwDet:bLDblClick    := {|| ::oDetCobAge:Edit( ::oBrwDet ) }
      else
         ::oBrwDet:bLDblClick    := {|| ::oDetCobAge:Zoom() }
      end if

REDEFINE APOLOMETER ::oMeter VAR ::nMeter ;
         ID       160 ;
         NOPERCENTAGE ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       511 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lSave( nMode ), oDlg:End( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       510 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( ::Cancelar(), oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F2, {|| ::oDetCobAge:Append( ::oBrwDet ) } )
         oDlg:AddFastKey( VK_F3, {|| ::oDetCobAge:Edit( ::oBrwDet ) } )
         oDlg:AddFastKey( VK_F4, {|| ::oDetCobAge:Del( ::oBrwDet ) } )
         oDlg:AddFastKey( VK_F5, {|| if( ::lSave( nMode ), oDlg:End( IDOK ), ) } )
      end if

      oDlg:bStart    := {|| ::EdtRecMenu( oDlg ) }

   ACTIVATE DIALOG oDlg CENTER

   oBmpDiv:End()
   oBmpGeneral:End()

   /*
   Guardamos los datos del browse----------------------------------------------
   */

   ::oBrwDet:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD EdtRecMenu( oDlg )

   MENU ::oMnuRec

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar agente";
               MESSAGE  "Modifica la ficha del agenete" ;
               RESOURCE "gc_businessman2_16";
               ACTION   ( if( !Empty( ::oDbf:cCodAge ), EdtAge( ::oDbf:cCodAge ), MsgStop( "Código de agente vacío" ) ) )

            MENUITEM    "&2. Modificar cliente";
               MESSAGE  "Modifica la ficha del cliente" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !Empty( ::oDetCobAge:oDbfVir:cCodCli ), EdtCli( ::oDetCobAge:oDbfVir:cCodCli ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&3. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !Empty( ::oDetCobAge:oDbfVir:cCodCli ), InfCliente( ::oDetCobAge:oDbfVir:cCodCli ), MsgStop( "Código de cliente vacío" ) ) );

            SEPARATOR

            MENUITEM    "&4. Modifica factura";
               MESSAGE  "Modifica la factura" ;
               RESOURCE "EDIT16" ;
               ACTION   ( if( ::oDetCobAge:oDbfVir:lFacRec, EdtFacRec( ::oDetCobAge:oDbfVir:cSerFac + Str( ::oDetCobAge:oDbfVir:nNumFac ) + ::oDetCobAge:oDbfVir:cSufFac ), EdtFacCli( ::oDetCobAge:oDbfVir:cSerFac + Str( ::oDetCobAge:oDbfVir:nNumFac ) + ::oDetCobAge:oDbfVir:cSufFac ) ) )

            MENUITEM    "&5. Visualiza factura";
               MESSAGE  "Visualiza la factura" ;
               RESOURCE "gc_lock2_16" ;
               ACTION   ( if( ::oDetCobAge:oDbfVir:lFacRec, ZooFacRec( ::oDetCobAge:oDbfVir:cSerFac + Str( ::oDetCobAge:oDbfVir:nNumFac ) + ::oDetCobAge:oDbfVir:cSufFac ), ZooFacCli( ::oDetCobAge:oDbfVir:cSerFac + Str( ::oDetCobAge:oDbfVir:nNumFac ) + ::oDetCobAge:oDbfVir:cSufFac ) ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( ::oMnuRec )

   ::oBrwDet:Load()

Return ( ::oMnuRec )

//---------------------------------------------------------------------------//

METHOD Cancelar() CLASS TCobAge

Return ( Self )

//---------------------------------------------------------------------------//

METHOD lSave( nMode ) CLASS TCobAge

   if Empty( ::oDbf:cCodAge )
      MsgStop( "Código agente no puede estar vacio." )
      ::oCodAge:SetFocus()
      Return .f.
   end if

   ::oDbf:nTotCob    := ::nTotCom()

   if nMode == APPD_MODE
      ::oDbf:nNumCob := ::cValidCobro()
   end if

   /*if Empty( ::oDbf:cNumFac ) .and. ApoloMsgNoYes( "¿Desea generar la factura de gastos?", "Confirme" )
      ::GeneraFacturaGastos( .f. )
   end if*/

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lContabilizar( nAsiento )

	::oDbf:FieldPutByName( "lConta", .t. )

	::oTreeSelect:Select( ::oTreeSelect:Add( "Liquidación de agentes : " + Alltrim( Str( ::oDbf:nNumCob, 9 ) ) + " asiento generado num. " + Alltrim( Str( nAsiento ) ), 1 ) )

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD lValidFacturaProveedor( oGetFactura, nMode )

	local cFactura

	cFactura          := Upper( oGetFactura:VarGet() )
	cFactura          := SubStr( cFactura, 1, 1 ) + Padl( Alltrim( SubStr( cFactura, 2, 9 ) ), 9 )

	if Empty( cFactura )
	 RETURN ( .t. )
	end if

	if ::oFacPrvT:SeekInOrd( cFactura, "nNumFac" )

	 oGetFactura:cText( cFactura )

	 RETURN ( .t. )

	else

	 MsgStop( "La factura de proveedores introducida no existe." )

	end if

RETURN ( .f. )

//------------------------------------------------------------------------//

METHOD GeneraFacturaGastos( lExternal ) CLASS TCobAge

   local oBlock
   local cSerie
   local nNumero
   local cSufijo
   local cCodPrv
   local cCodArt

   DEFAULT lExternal          := .f.

   /*
   Requisitos previos----------------------------------------------------------
   */

   if !Empty( ::oDbf:cNumFac )
      MsgStop( "La liquidación ya contiene una factura generada." )
      Return ( nil )
   end if

   cCodPrv                    := RetFld( ::oDbf:cCodAge, ::oAgentes:cAlias, "cCodPrv" )
   if Empty( cCodPrv )
      MsgStop( "El agente no tiene cuenta de proveedor asociada." )
      Return ( nil )
   end if

   cCodArt                    := RetFld( ::oDbf:cCodAge, ::oAgentes:cAlias, "cCodArt" )
   if Empty( cCodArt )
      MsgStop( "El agente no tiene artículo de facturación asociado." )
      Return ( nil )
   end if

   cSerie                     := cNewSer( "nFacPrv", ::oCount:cAlias )
   nNumero                    := nNewDoc( cSerie, ::oFacPrvT:cAlias, "nFacPrv", , ::oCount:cAlias )
   cSufijo                    := RetSufEmp()

   if Empty( cSerie )
      MsgStop( "No se ha obtenido serie para la facturación." )
      Return ( nil )
   end if

   if Empty( nNumero )
      Return ( nil )
   end if

   CursorWait()

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   /*
   Cabeceras-------------------------------------------------------------------
   */

   ::oFacPrvT:Append()

   ::oFacPrvT:cSerFac         := cSerie
   ::oFacPrvT:nNumFac         := nNumero
   ::oFacPrvT:cSufFac         := cSufijo
   ::oFacPrvT:cTurFac         := cCurSesion()
   ::oFacPrvT:dFecFac         := GetSysDate()
   ::oFacPrvT:cDivFac         := ::oDbf:cCodDiv
   ::oFacPrvT:nVdvFac         := ::oDbf:nVdvDiv
   ::oFacPrvT:cCodAlm         := oUser():cAlmacen()
   ::oFacPrvT:cCodCaj         := Application():CodigoCaja()
   ::oFacPrvT:lSndDoc         := .t.
   ::oFacPrvT:cCodUsr         := Auth():Codigo()
   ::oFacPrvT:cCodDlg         := Application():CodigoDelegacion()
   ::oFacPrvT:dFecEnt         := Ctod( "" )
   ::oFacPrvT:dFecImp         := Ctod( "" )
   ::oFacPrvT:lCloFac         := .f.
   ::oFacPrvT:cCodPrv         := cCodPrv
   ::oFacPrvT:cNomPrv         := RetFld( cCodPrv, ::oProvee:cAlias, "Titulo"    )
   ::oFacPrvT:cDirPrv         := RetFld( cCodPrv, ::oProvee:cAlias, "Domicilio" )
   ::oFacPrvT:cPobPrv         := RetFld( cCodPrv, ::oProvee:cAlias, "Poblacion" )
   ::oFacPrvT:cProvProv       := RetFld( cCodPrv, ::oProvee:cAlias, "Provincia" )
   ::oFacPrvT:cPosPrv         := RetFld( cCodPrv, ::oProvee:cAlias, "CodPostal" )
   ::oFacPrvT:cDniPrv         := RetFld( cCodPrv, ::oProvee:cAlias, "Nif"       )
   ::oFacPrvT:cCodPago        := RetFld( cCodPrv, ::oProvee:cAlias, "FPago"     )
   ::oFacPrvT:dFecChg         := Date()
   ::oFacPrvT:cTimChg         := Time()
   ::oFacPrvT:cCodAge         := ::oDbf:cCodAge
   ::oFacPrvT:nTotNet         := ::oDbf:nTotCob
   ::oFacPrvT:nTotFac         := ::oDbf:nTotCob

   if oRetFld( ::oFacPrvT:cCodPago, ::oFPago, "lUtlBnc" ) .and. dbSeekInOrd( cCodPrv, "cCodDef", ::oPrvBnc:cAlias )
      ::oFacPrvT:cBanco       := ::oPrvBnc:cCodBnc
      ::oFacPrvT:cEntBnc      := ::oPrvBnc:cEntBnc
      ::oFacPrvT:cSucBnc      := ::oPrvBnc:cSucBnc
      ::oFacPrvT:cDigBnc      := ::oPrvBnc:cDigBnc
      ::oFacPrvT:cCtaBnc      := ::oPrvBnc:cCtaBnc
   end if

   ::oFacPrvT:Save()

   /*
   Lineas----------------------------------------------------------------------
   */

   ::oFacPrvL:Append()

   ::oFacPrvL:cSerFac         := cSerie
   ::oFacPrvL:nNumFac         := nNumero
   ::oFacPrvL:cSufFac         := cSufijo

   ::oFacPrvL:cRef            := cCodArt
   ::oFacPrvL:cDetalle        := oRetFld( cCodArt, ::oArticulo, "Nombre" )
   ::oFacPrvL:nCtlStk         := oRetFld( cCodArt, ::oArticulo, "nCtlStock" )
   ::oFacPrvL:nUniCaja        := 1
   ::oFacPrvL:nPreUnit        := ::oDbf:nTotCob
   ::oFacPrvL:cAlmLin         := oUser():cAlmacen()

   ::oFacPrvL:Save()

   /*
   Referencias-----------------------------------------------------------------
   */

   if !lExternal
      ::oDbf:cNumFac          := cSerie + Str( nNumero ) + cSufijo
   else
      ::oDbf:FieldPutByName( "cNumFac", cSerie + Str( nNumero ) + cSufijo )
   end if

   /*
   Generación de pagos---------------------------------------------------------
   */

   GenPgoFacPrv( cSerie + Str( nNumero ) + cSufijo, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oFacPrvP:cAlias, ::oProvee:cAlias, ::oIva:cAlias, ::oFPago:cAlias, ::oDivisas:cAlias )

   CursorWE()

   MsgInfo( "Factura " + cSerie + "/" + Alltrim( Str( nNumero ) ) + "/" + Alltrim( cSufijo ) + " generada satisfactoriamente." )

   RECOVER

   msgStop( "Error al generar factrura de proveedores." )

   END SEQUENCE

   ErrorBlock( oBlock )

Return .t.

//----------------------------------------------------------------------------//

METHOD nTotImp() CLASS TCobAge

   local nTotImp              := 0

   ::oDetCobAge:oDbfVir:GetStatus()

   ::oDetCobAge:oDbfVir:GoTop()

   while !::oDetCobAge:oDbfVir:Eof()

      nTotImp                 += ::oDetCobAge:oDbfVir:nImpCom

      ::oDetCobAge:oDbfVir:Skip()

   end while

   ::oDetCobAge:oDbfVir:SetStatus()

RETURN ( nTotImp )

//---------------------------------------------------------------------------//

METHOD nTotCom() CLASS TCobAge

   local nTotImp     := 0

   ::oDetCobAge:oDbfVir:GetStatus()

   ::oDetCobAge:oDbfVir:GoTop()

   while !::oDetCobAge:oDbfVir:Eof()

      nTotImp        += ::oDetCobAge:oDbfVir:nImpCom * ::oDetCobAge:oDbfVir:nComAge / 100

      ::oDetCobAge:oDbfVir:Skip()

   end while

   ::oDetCobAge:oDbfVir:SetStatus()

RETURN ( nTotImp )

//---------------------------------------------------------------------------//

METHOD Report()

   ::oDbf:GetStatus()
   ::oDetCobAge:oDbf:GetStatus()

   TInfCobAge():New( "Liquidación de agentes", , , , , , { ::oDbf, ::oDetCobAge:oDbf } ):Play()

   ::oDbf:SetStatus()
   ::oDetCobAge:oDbf:SetStatus()

   ::oWndBrw:Refresh()

return .t.

//---------------------------------------------------------------------------//

METHOD nTotComAge( cNumCob, lPicture ) CLASS TCobAge

   local nTotImp     := 0

   DEFAULT lPicture  := .t.

   with object ( ::oDetCobAge:oDbf )

      :GetStatus()
      :OrdSetFocus( "nNumCob" )

      if :Seek( cNumCob )
         while Str( :nNumCob ) + :cSufCob == cNumCob .and. !:Eof()
            nTotImp  += ( :nImpCom * :nComAge / 100 )
            :Skip()
         end while
      end if

      :SetStatus()

   end with

   if lPicture
      nTotImp        := Trans( nTotImp, ::cPorDiv )
   end if

RETURN ( nTotImp )

//---------------------------------------------------------------------------//

METHOD ValidAgente( oSay ) CLASS TCobAge

   local c
   local cCodAge  := ::oCodAge:VarGet()

   if ::cOldAge != cCodAge

      if cAgentes( ::oCodAge, ::oAgentes:cAlias, oSay )

         /*
         Guardamos el proveedor asignado al agente--------------------------------
         */

         ::oDbf:cCodPrv          := RetFld( cCodAge, ::oAgentes:cAlias, "cCodPrv" )

         // ::aAgentesRelacionados  := aAgentesRelacionados( ::oCodAge, ::oAgeRel:cAlias )

         ::AsistenteImportarFacturas()

         ::cOldAge               := cCodAge

         Return .t.

      else

         Return .f.

      end if

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD nTotLiq( lPic ) CLASS TCobAge

   local nTot     := 0
   local nPos     := ::oDbfDet:Recno()

   DEFAULT lPic   := .f.

   ::oDbfDet:GoTop()
   while !::oDbfDet:Eof()
      nTot  += ::oDbfDet:nImpCom
      ::oDbfDet:Skip()
   end while

   ::oDbfDet:GoTo( nPos )

RETURN ( if( lPic, Trans( nTot, ::cPorDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD nTotFac( lPic ) CLASS TCobAge

   local nTot     := 0
   local nPos     := ::oDbfDet:Recno()

   DEFAULT lPic   := .f.

   ::oDbfDet:GoTop()
   WHILE !::oDbfDet:Eof()
         nTot  += ::oDbfDet:nImpFac
         ::oDbfDet:Skip()
   END WHILE

   ::oDbfDet:GoTo( nPos )

RETURN ( if( lPic, Trans( nTot, ::cPorDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD nTotLiqAge( cNumLiq, lPic ) CLASS TCobAge

   local nTot     := 0

   DEFAULT lPic   := .f.

   ::oFacCliT:GetStatus()
   ::oFacCliT:OrdSetFocus( "nNumLiq" )

   ::oFacCliT:Seek( cNumLiq )
   WHILE Str( ::oFacCliT:nNumLiq ) + ::oFacCliT:cSufLiq == cNumLiq .and. !::oFacCliT:Eof()
      nTot        += ::oFacCliT:nImpLiq
      ::oFacCliT:Skip()
   END WHILE

   ::oFacCliT:SetStatus()

RETURN ( if( lPic, Trans( nTot, ::cPorDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD EdtLiqAge( nMode ) CLASS TCobAge

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Del() CLASS TCobAge

   if SQLAjustableModel():getRolNoConfirmacionEliminacion( Auth():rolUuid() ) .or. msgNoYes( "¿ Desea eliminar el registro en curso ?", "Confirme supresión" )

      while ::oDetCobAge:oDbf:SeekInOrd( Str( ::oDbf:nNumCob ) + ::oDbf:cSufCob, "nNumCob" )
         ::oDetCobAge:oDbf:Delete(.f.)
      end while

      ::oDbf:Delete()

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD AsistenteImportarFacturas() CLASS TCobAge

   local oDlg
   local oBmp
   local oBrw
   local oPag
   local oBtnPrv
   local oBtnNxt

   if Empty( ::oDbf:cCodAge ) .or. !( ::oAgentes:SeekInOrd( ::oDbf:cCodAge, "cCodAge" ) )
      msgStop( "Es necesario codificar un agente.", "Importar Facturas" )
      return .f.
   end if

   DEFINE DIALOG oDlg RESOURCE "ASS_LIQAGE"

   REDEFINE PAGES oPag ID 110 OF oDlg DIALOGS "LIQAGE_1", "LIQAGE_2"

   REDEFINE BITMAP oBmp ;
      ID       500 ;
      RESOURCE "gc_briefcase2_agent_48" ;
      TRANSPARENT ;
      OF       oDlg

   REDEFINE GET ::oDbf:dFecIni ;
      ID       150 ;
      SPINNER ;      
      OF       oPag:aDialogs[ 1 ]      

   REDEFINE GET ::oDbf:dFecFin ;
      ID       160 ;
      SPINNER ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE CHECKBOX ::lFacturasComisiones ;
      ID       180 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE CHECKBOX ::lFacturasNoCobradas ;
      ID       190 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE CHECKBOX ::lFacturasParcialmente ;
      ID       200 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE CHECKBOX ::lFacturasTotalmente ;
      ID       210 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE CHECKBOX ::lFacturasIncluidas ;
      ID       220 ;
      OF       oPag:aDialogs[ 1 ]

   TWebBtn():Redefine( 1170,,,,, {|| ( aEval( ::oSer, {|o| Eval( o:bSetGet, .T. ), o:refresh() } ) ) }, oPag:aDialogs[ 1 ],,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ) )

   TWebBtn():Redefine( 1180,,,,, {|| ( aEval( ::oSer, {|o| Eval( o:bSetGet, .F. ), o:refresh() } ) ) }, oPag:aDialogs[ 1 ],,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ) )

   REDEFINE CHECKBOX ::oSer[  1 ] VAR ::aSer[  1 ] ID 1190 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  2 ] VAR ::aSer[  2 ] ID 1200 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  3 ] VAR ::aSer[  3 ] ID 1210 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  4 ] VAR ::aSer[  4 ] ID 1220 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  5 ] VAR ::aSer[  5 ] ID 1230 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  6 ] VAR ::aSer[  6 ] ID 1240 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  7 ] VAR ::aSer[  7 ] ID 1250 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  8 ] VAR ::aSer[  8 ] ID 1260 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[  9 ] VAR ::aSer[  9 ] ID 1270 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 10 ] VAR ::aSer[ 10 ] ID 1280 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 11 ] VAR ::aSer[ 11 ] ID 1290 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 12 ] VAR ::aSer[ 12 ] ID 1300 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 13 ] VAR ::aSer[ 13 ] ID 1310 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 14 ] VAR ::aSer[ 14 ] ID 1320 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 15 ] VAR ::aSer[ 15 ] ID 1330 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 16 ] VAR ::aSer[ 16 ] ID 1340 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 17 ] VAR ::aSer[ 17 ] ID 1350 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 18 ] VAR ::aSer[ 18 ] ID 1360 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 19 ] VAR ::aSer[ 19 ] ID 1370 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 20 ] VAR ::aSer[ 20 ] ID 1380 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 21 ] VAR ::aSer[ 21 ] ID 1390 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 22 ] VAR ::aSer[ 22 ] ID 1400 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 23 ] VAR ::aSer[ 23 ] ID 1410 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 24 ] VAR ::aSer[ 24 ] ID 1420 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 25 ] VAR ::aSer[ 25 ] ID 1430 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX ::oSer[ 26 ] VAR ::aSer[ 26 ] ID 1440 OF oPag:aDialogs[ 1 ]

   /*
   Segunda caja de dialogo-----------------------------------------------------
   */

   oBrw                    := IXBrowse():New( oPag:aDialogs[ 2 ] )

   oBrw:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrw:SetArray( ::aDbfVir, , , .f. )

   oBrw:nMarqueeStyle      := 6
   oBrw:lRecordSelector    := .t.

   oBrw:lHScroll           := .t.
   oBrw:lVScroll           := .t.

      with object ( oBrw:AddCol() )
         :cHeader          := "Seleccionada"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ::aDbfVir[ oBrw:nArrayAt, 1 ] }
         :nWidth           := 14
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Tipo"
         :bStrData         := {|| if( ::aDbfVir[ oBrw:nArrayAt, 10 ], "Rectificativa", "Factura" ) }
         :nWidth           := 60
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :bStrData         := {|| ::aDbfVir[ oBrw:nArrayAt, 2 ] + "/" + Alltrim( Str( ::aDbfVir[ oBrw:nArrayAt, 3 ] ) ) }
         :nWidth           := 60
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :bStrData         := {|| Dtoc( ::aDbfVir[ oBrw:nArrayAt, 5 ] ) }
         :nWidth           := 70
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cliente"
         :bStrData         := {|| Rtrim( ::aDbfVir[ oBrw:nArrayAt, 6 ] ) }
         :nWidth           := 60
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :bStrData         := {|| Rtrim( ::aDbfVir[ oBrw:nArrayAt, 7 ] ) }
         :nWidth           := 140
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Agente"
         :bStrData         := {|| ::aDbfVir[ oBrw:nArrayAt, 11 ] }
         :nWidth           := 40
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bStrData         := {|| Trans( ::aDbfVir[ oBrw:nArrayAt, 8 ], ::cPorDiv ) }
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Comisión"
         :bStrData         := {|| Trans( ::aDbfVir[ oBrw:nArrayAt, 9 ], ::cPorDiv )  }
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

   oBrw:CreateFromResource( 110 )

   /*
   Botones de seleccón---------------------------------------------------------
   */

   REDEFINE BUTTON ;
         ID       501 ;
         OF       oPag:aDialogs[ 2 ] ;
         ACTION   ( ::aDbfVir[ oBrw:nArrayAt, 1 ] := !::aDbfVir[ oBrw:nArrayAt, 1 ], oBrw:Refresh() )

   REDEFINE BUTTON ;
         ID       502 ;
         OF       oPag:aDialogs[ 2 ] ;
         ACTION   ( aEval( ::aDbfVir, { |aItem| aItem[1] := .t. } ), oBrw:refresh() )

   REDEFINE BUTTON ;
         ID       503 ;
         OF       oPag:aDialogs[ 2 ] ;
         ACTION   ( aEval( ::aDbfVir, { |aItem| aItem[1] := .f. } ), oBrw:refresh() )

   /*
   Botones caja de dialogo-----------------------------------------------------
   */

   REDEFINE BUTTON oBtnPrv ;                          // Boton de Anterior
         ID       401 ;
         OF       oDlg ;
         ACTION   ( ::IntBtnPrv( oPag, oBtnPrv, oBtnNxt, oDlg, oBrw ) )

   REDEFINE BUTTON oBtnNxt ;                          // Boton de Siguiente
         ID       402 ;
         OF       oDlg ;
         ACTION   ( ::IntBtnNxt( oPag, oBtnPrv, oBtnNxt, oDlg, oBrw ) )

   REDEFINE BUTTON ;                                  // Boton de salida
         ID       403 ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBtnPrv:Hide() )

   oBmp:End()

   ::oFecIni:Refresh()
   ::oFecFin:Refresh()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD IntBtnPrv( oPag, oBtnPrv, oBtnNxt, oDlg ) CLASS TCobAge

   oPag:GoPrev()

   oBtnPrv:Hide()

   SetWindowText( oBtnNxt:hWnd, "&Siguiente >" )

return nil

//---------------------------------------------------------------------------//

METHOD IntBtnNxt( oPag, oBtnPrv, oBtnNxt, oDlg, oBrw ) CLASS TCobAge

   local n
   local aAgente

   do case
      case oPag:nOption == 1

         CursorWait()

         ::aDbfVir      := {}

         ::ImportaFacturaAgentes( oBrw )

         /*for each aAgente in ::aAgentesRelacionados
            ::ImportaFacturaAgentes( oBrw, aAgente[ 1 ], aAgente[ 2 ], .t. )
         next*/

         /*
         Si no hemos conseguido añadir nada------------------------------------
         */

         if Empty( ::aDbfVir )
            ::aDbfVir   := { { .f., "", 0, "", Ctod( "" ), "", "", 0, 0, .f., "" } }
         end if

         oBrw:SetArray( ::aDbfVir )

         CursorWE()

         /*
         Saltamos a la siguiente página----------------------------------------
         */

         oPag:GoNext()

         oBtnPrv:Show()

         SetWindowText( oBtnNxt:hWnd, "&Importar" )

      case oPag:nOption == 2

         CursorWait()

         for n := 1 to len( ::aDbfVir )

            if ::aDbfVir[ n, 1 ]

               if !::oDetCobAge:oDbfVir:SeekInOrd( ::aDbfVir[ n, 2 ] + Str( ::aDbfVir[ n, 3 ] ) + ::aDbfVir[ n, 4 ], "cNumFac" )

                  ::oDetCobAge:oDbfVir:Append()
                  ::oDetCobAge:oDbfVir:cCodAge  := ::oDbf:cCodAge
                  ::oDetCobAge:oDbfVir:lFacRec  := ::aDbfVir[ n, 10]
                  ::oDetCobAge:oDbfVir:cSerFac  := ::aDbfVir[ n, 2 ]
                  ::oDetCobAge:oDbfVir:nNumFac  := ::aDbfVir[ n, 3 ]
                  ::oDetCobAge:oDbfVir:cSufFac  := ::aDbfVir[ n, 4 ]
                  ::oDetCobAge:oDbfVir:dFecFac  := ::aDbfVir[ n, 5 ]
                  ::oDetCobAge:oDbfVir:cCodCli  := ::aDbfVir[ n, 6 ]
                  ::oDetCobAge:oDbfVir:cNomCli  := ::aDbfVir[ n, 7 ]
                  ::oDetCobAge:oDbfVir:nImpCom  := ::aDbfVir[ n, 8 ]
                  ::oDetCobAge:oDbfVir:nComAge  := ::aDbfVir[ n, 9 ] / ::aDbfVir[ n, 8 ] * 100
                  ::oDetCobAge:oDbfVir:Save()

               else

                  MsgStop( "La factura " + ::aDbfVir[ n, 2 ] + "/" + Alltrim( Str( ::aDbfVir[ n, 3 ] ) ) + "/" + Rtrim( ::aDbfVir[ n, 4 ] ) + " ya está incorporada en la liquidación." )

               end if

            end if

         next

         CursorWE()

         ::oBrwDet:Refresh()

         oDlg:End()

   end case

RETURN nil

//---------------------------------------------------------------------------//

METHOD cValidCobro() CLASS TCobAge

   local nCurCob  := nNewDoc( nil, ::oDbf:nArea, "nCobAge", , ::oCount:cAlias )

   ::oDbf:GetStatus()
   ::oDbf:OrdSetFocus( "nNumCob" )

   while ::oDbf:Seek( nCurCob ) .or. ( nCurCob == 0 )
      ++nCurCob
   end while

   ::oDbf:SetStatus()

RETURN ( nCurCob )

//--------------------------------------------------------------------------//

METHOD BrwRecCli( oGet ) CLASS TCobAge

RETURN ( nil )

//--------------------------------------------------------------------------//

FUNCTION CheckRec( oGet, dbfFacCliT, oLiq, oDlgAnt )

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD OpenError() CLASS TCobAge

   MsgStop( "Proceso en uso por otro usuario", "Abrir fichero" )

   ::lOpenError            := .t.

RETURN .F.

//--------------------------------------------------------------------------//

METHOD LiquidaFacturaCliente( cNumFac, nMark ) CLASS TCobAge

   DEFAULT nMark           := -1

   if ::oFacCliT:SeekInOrd( cNumFac, "nNumFac" )
      ::oFacCliT:FieldPutByName( "nNumLiq", nMark )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ImportaFacturaAgentes( oBrw, cCodigoAgente, nPorcentajeAgente, lRelacionado ) CLASS TCobAge

   local nEstFac
   local aTotFac

   if IsNil( cCodigoAgente )
      cCodigoAgente     := ::oDbf:cCodAge
   end if

   if IsNil( lRelacionado )
      lRelacionado      := .f.
   end if

   /*
   Facturas de clientes--------------------------------------------------------
   */

   ::oFacCliT:GetStatus()

   ::oFacCliT:OrdSetFocus( "cCodAge" )
   if ::oFacCliT:Seek( cCodigoAgente )

      while ( ::oFacCliT:cCodAge == cCodigoAgente ) .and. !::oFacCliT:eof()

         if ::oFacCliT:dFecFac >= ::oDbf:dFecIni                       .and.;
            ::oFacCliT:dFecFac <= ::oDbf:dFecFin                       .and.;
            lChkSer( ::oFacCliT:cSerie, ::aSer )

            if ::lFacturaProcesar( .f., lRelacionado )

               nEstFac  := nChkPagFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias )

               if ( ::lFacturasNoCobradas    .and. nEstFac == 3 )  .or.;
                  ( ::lFacturasParcialmente  .and. nEstFac == 2 )  .or.;
                  ( ::lFacturasTotalmente    .and. nEstFac == 1 )

                  aTotFac  := ::oDetCobAge:nTotalComisionFactura( .f., ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, cCodigoAgente, nPorcentajeAgente )

                  if ( ::lFacturasComisiones .and. aTotFac[ 2 ] != 0 ) .or. !( ::lFacturasComisiones )

                     aAdd( ::aDbfVir, { .t., ::oFacCliT:cSerie, ::oFacCliT:nNumFac, ::oFacCliT:cSufFac, ::oFacCliT:dFecFac, ::oFacCliT:cCodCli, ::oFacCliT:cNomCli, aTotFac[ 1 ], aTotFac[ 2 ], .f., ::oFacCliT:cCodAge } )

                  end if

               end if

            end if

         end if

         ::oFacCliT:Skip()

      end while

   end if

   ::oFacCliT:SetStatus()

   /*
   Facturas rectificativas-----------------------------------------------------
   */

   ::oFacRecT:GetStatus()

   ::oFacRecT:OrdSetFocus( "cCodAge" )
   if ::oFacRecT:Seek( cCodigoAgente )

      while ( ::oFacRecT:cCodAge == cCodigoAgente ) .and. !::oFacRecT:eof()

         if ::oFacRecT:dFecFac >= ::oDbf:dFecIni                       .and.;
            ::oFacRecT:dFecFac <= ::oDbf:dFecFin                       .and.;
            lChkSer( ::oFacRecT:cSerie, ::aSer )

            if ::lFacturaProcesar( .t., lRelacionado )

               nEstFac  := nChkPagFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacCliP:cAlias )

               if ( ::lFacturasNoCobradas    .and. nEstFac == 3 ) .or.;
                  ( ::lFacturasParcialmente  .and. nEstFac == 2 ) .or.;
                  ( ::lFacturasTotalmente    .and. nEstFac == 1 )

                  aTotFac  := ::oDetCobAge:nTotalComisionFactura( .t., ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, cCodigoAgente, nPorcentajeAgente )

                  if ( ::lFacturasComisiones .and. aTotFac[ 2 ] != 0 ) .or. ( !::lFacturasComisiones )

                     aAdd( ::aDbfVir, { .t., ::oFacRecT:cSerie, ::oFacRecT:nNumFac, ::oFacRecT:cSufFac, ::oFacRecT:dFecFac, ::oFacRecT:cCodCli, ::oFacRecT:cNomCli, aTotFac[ 1 ], aTotFac[ 2 ], .t., ::oFacRecT:cCodAge } )

                  end if

               end if

            end if

         end if

         ::oFacRecT:Skip()

      end while

   end if

   ::oFacRecT:SetStatus()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD dFecLiqAge( cNumLiq ) CLASS TCobAge

   local dFecLiq  := Ctod( "" )

   ::oDbf:GetStatus()

   ::oDbf:OrdSetFocus( "nNumCob" )

   if ::oDbf:Seek( cNumLiq )
      dFecLiq  := ::oDbf:dFecLiq
   end if

   ::oDbf:SetStatus()

return ( dFecLiq )

//---------------------------------------------------------------------------//

METHOD GenLiquidacion( nDevice, cCaption, cCodDoc, cPrinter, nCopies ) CLASS TCobAge

   local oInf
   local nOrd
   local oDevice
   local cNumeroLiquidacion

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo liquidación de agentes"
   DEFAULT cCodDoc      := cFormatoDocumento( , "nCobAge", ::oCount:cAlias )
   DEFAULT nCopies      := nCopiasDocumento( , "nCobAge", ::oCount:cAlias )

   if ::oDbf:Lastrec() == 0
      Return nil
   end if

   if Empty( cCodDoc )
      cCodDoc           := cFirstDoc( "LQ", ::oDbfDoc )
   end if

   if !lExisteDocumento( cCodDoc, ::oDbfDoc )
      return nil
   end if

   cNumeroLiquidacion   := Str( ::oDbf:nNumCob ) + ::oDbf:cSufCob

   ::oDbf:GetStatus( .t. )
   ::oDbf:Seek( cNumeroLiquidacion )

   nOrd                 := ::oDetCobAge:oDbf:OrdSetFocus( "xNumCob" )

   if lVisualDocumento( cCodDoc, ::oDbfDoc:cAlias )
      ::PrintReport( nDevice, nCopies, cPrinter, ::oDbfDoc:cAlias )
   end if

   ::oDetCobAge:oDbf:OrdSetFocus( nOrd )

   ::oDbf:SetStatus()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD lGenLiquidacion( oBrw, oBtn, nDevice ) CLASS TCobAge

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if !::oDbfDoc:Seek( "LQ" )

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay documentos predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   else

      while ::oDbfDoc:cTipo == "LQ" .AND. !::oDbfDoc:eof()

         bAction  := ::bGenLiquidacion( nDevice, "Imprimiendo parte de producción", ::oDbfDoc:Codigo )

         ::oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ::oDbfDoc:cDescrip ) , , , , , oBtn )

         ::oDbfDoc:Skip()

      end do

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD bGenLiquidacion( nDevice, cTitle, cCodDoc ) CLASS TCobAge

   local bGen
   local nDev        := by( nDevice )
   local cTit        := by( cTitle    )
   local cCod        := by( cCodDoc   )

   bGen              := {|| ::GenLiquidacion( nDev, cTit, cCod ) }

RETURN ( bGen )

//---------------------------------------------------------------------------//

METHOD nGenLiquidacion( nDevice, cTitle, cCodDoc, cPrinter, nCopy ) CLASS TCobAge

   local nImpYet     := 1

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT nCopy     := nCopiasDocumento( , "nCobAge", ::oCount:cAlias )

   nCopy             := Max( nCopy, 1 )

   while nImpYet <= nCopy
      ::GenLiquidacion( nDevice, cTitle, cCodDoc, cPrinter )
      nImpYet++
   end while

return nil

//---------------------------------------------------------------------------//

METHOD PrnSerie() CLASS TCobAge

	local oDlg
   local oFmtDoc
   local cFmtDoc     := cSelPrimerDoc( "LQ" )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin
   local cSerIni
   local cSerFin
   local nRecno      := ::oDbf:Recno()
   local nOrdAnt     := ::oDbf:OrdSetFocus( "cNumCob" )
   local nDocIni     := ::oDbf:nNumCob
   local nDocFin     := ::oDbf:nNumCob
   local cSufIni     := ::oDbf:cSufCob
   local cSufFin     := ::oDbf:cSufCob
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := nCopiasDocumento( , "nCobAge", ::oCount:cAlias )

   DEFAULT cPrinter  := PrnGetName()

   cSayFmt           := cNombreDoc( cFmtDoc )

   DEFINE DIALOG oDlg RESOURCE "IMPSERDOC" TITLE "Imprimir series de partes de producción"

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       100 ;
      OF       oDlg

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       110 ;
      OF       oDlg

   REDEFINE GET nDocIni;
      ID       120 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET nDocFin;
      ID       130 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      PICTURE  "##" ;
      OF       oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      PICTURE  "##" ;
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
      VALID    ( cDocumento( oFmtDoc, oSayFmt, ::oDbfDoc:cAlias ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "LQ" ) ) ;
      OF       oDlg

   REDEFINE GET oSayFmt VAR cSayFmt ;
      ID       91 ;
      WHEN     ( .f. );
      COLOR    CLR_GET ;
      OF       oDlg

   TBtnBmp():ReDefine( 92, "gc_document_text_pencil_12",,,,,{|| EdtDocumento( cFmtDoc ) }, oDlg, .f., , .f.,  )

   REDEFINE GET oPrinter VAR cPrinter;
      WHEN     ( .f. ) ;
      ID       160 ;
      OF       oDlg

   TBtnBmp():ReDefine( 161, "gc_printer2_check_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( ::StartPrint( SubStr( cFmtDoc, 1, 3 ), Str( nDocIni, 9 ) + cSufIni, Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden ), oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:bStart := { || oSerIni:Hide(), oSerFin:Hide() }

   oDlg:AddFastKey( VK_F5, {|| ::StartPrint( SubStr( cFmtDoc, 1, 3 ), Str( nDocIni, 9 ) + cSufIni, Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden ), oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   ::oDbf:GoTo( nRecNo )
   ::oDbf:OrdSetFocus( nOrdAnt )

RETURN NIL

//--------------------------------------------------------------------------//

METHOD StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden ) CLASS TCobAge

   oDlg:disable()

   if !lInvOrden

      ::oDbf:SeekInOrd( cDocIni, "nNumCob", .t. )

      while Str( ::oDbf:nNumCob ) + ::oDbf:cSufCob >= cDocIni .AND. ;
            Str( ::oDbf:nNumCob ) + ::oDbf:cSufCob <= cDocFin

         if lCopiasPre

            ::nGenLiquidacion( IS_PRINTER, "Imprimiendo documento : " + Str( ::oDbf:nNumCob ) + ::oDbf:cSufCob, cFmtDoc, cPrinter, nCopiasDocumento( , "nCobAge", ::oCount:cAlias ) )

         else

            ::nGenLiquidacion( IS_PRINTER, "Imprimiendo documento : " + Str( ::oDbf:nNumCob ) + ::oDbf:cSufCob, cFmtDoc, cPrinter, nNumCop )

         end if

         ::oDbf:Skip( 1 )

      end do

   else

      ::oDbf:SeekInOrd( cDocFin, "nNumCob", .t. )

      while Str( ::oDbf:nNumCob ) + ::oDbf:cSufCob >= cDocIni .and.;
            Str( ::oDbf:nNumCob ) + ::oDbf:cSufCob <= cDocFin .and.;
            !::oDbf:Bof()

         if lCopiasPre

            ::nGenLiquidacion( IS_PRINTER, "Imprimiendo documento : " + Str( ::oDbf:nNumCob ) + ::oDbf:cSufCob, cFmtDoc, cPrinter, nCopiasDocumento( , "nCobAge", ::oCount:cAlias ) )

         else

            ::nGenLiquidacion( IS_PRINTER, "Imprimiendo documento : " + Str( ::oDbf:nNumCob ) + ::oDbf:cSufCob, cFmtDoc, cPrinter, nNumCop )

         end if

         ::oDbf:Skip( -1 )

      end while

   end if

   oDlg:enable()

RETURN NIL

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD DataReport( oFr ) CLASS TCobAge

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Liquidación", ::oDbf:nArea, .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Liquidación", cObjectsToReport( ::oDbf ) )

   oFr:SetWorkArea(     "Lineas de liquidación", ::oDetCobAge:oDbf:nArea )
   oFr:SetFieldAliases( "Lineas de liquidación", cObjectsToReport( ::oDetCobAge:oDbf ) )

   oFr:SetWorkArea(     "Agentes",  ::oAgentes:nArea )
   oFr:SetFieldAliases( "Agentes",  cItemsToReport( aItmAge() ) )

   oFr:SetWorkArea(     "Factura de clientes",  ::oFacCliT:nArea )
   oFr:SetFieldAliases( "Factura de clientes",  cItemsToReport( aItmFacCli() ) )

   oFr:SetWorkArea(     "Factura rectificativa de clientes",  ::oFacRecT:nArea )
   oFr:SetFieldAliases( "Factura rectificativa de clientes",  cItemsToReport( aItmFacRec() ) )

   oFr:SetWorkArea(     "Empresa", ::oEmpresa:nArea )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes",  ::oClientes:nArea )
   oFr:SetFieldAliases( "Clientes",  cItemsToReport( aItmCli() ) )

   oFr:SetMasterDetail( "Liquidación", "Lineas de liquidación",                        {|| Str( ::oDbf:nNumCob ) + ::oDbf:cSufCob } )
   oFr:SetMasterDetail( "Liquidación", "Agentes",                                      {|| ::oDbf:cCodAge } )
   oFr:SetMasterDetail( "Liquidación", "Empresa",                                      {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Lineas de liquidación", "Factura de clientes",                {|| ::oDetCobAge:oDbf:cSerFac + Str( ::oDetCobAge:oDbf:nNumFac, 9 ) + ::oDetCobAge:oDbf:cSufFac } )
   oFr:SetMasterDetail( "Lineas de liquidación", "Factura rectificativa de clientes",  {|| ::oDetCobAge:oDbf:cSerFac + Str( ::oDetCobAge:oDbf:nNumFac, 9 ) + ::oDetCobAge:oDbf:cSufFac } )
   oFr:SetMasterDetail( "Lineas de liquidación", "Clientes",                           {|| ::oDetCobAge:oDbf:cCodCli } )

   oFr:SetResyncPair(   "Liquidación", "Lineas de liquidación" )
   oFr:SetResyncPair(   "Liquidación", "Agentes" )
   oFr:SetResyncPair(   "Liquidación", "Empresa" )
   oFr:SetResyncPair(   "Lineas de liquidación", "Factura de clientes" )
   oFr:SetResyncPair(   "Lineas de liquidación", "Factura rectificativa de clientes" )
   oFr:SetResyncPair(   "Lineas de liquidación", "Clientes" )

Return nil

//---------------------------------------------------------------------------//

METHOD VariableReport( oFr ) CLASS TCobAge

   /*
   Creación de variables
   ----------------------------------------------------------------------------
   */

   oFr:DeleteCategory(  "Lineas de liquidación" )

   oFr:AddVariable(     "Lineas de liquidación",   "Total línea", "CallHbFunc('nTotalLineaLiquidacion')" )

Return nil

//---------------------------------------------------------------------------//

METHOD DesignReport( oFr, dbfDoc ) CLASS TCobAge

   if ::OpenFiles()

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

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 200 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Liquidación" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de liquidación" )
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

METHOD PrintReport( nDevice, nCopies, cPrinter, dbfDoc ) CLASS TCobAge

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
/*
Estudia si la factura es valida para ser procesada
*/

METHOD lFacturaProcesar( lRectificativa, lRelacionado ) CLASS TCobAge

   local lFacturaProcesar  := .f.
   local cFactura          := ""
   local cAgente           := ""

   if lRectificativa
      cFactura          := ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac
      cAgente           := ::oFacRecT:cCodAge
   else
      cFactura          := ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac
      cAgente           := ::oFacCliT:cCodAge
   end if

   if ( ::lFacturasIncluidas ) .or. ( !::lFacturasIncluidas .and. !::oDetCobAge:lFacturaRemesada( lRectificativa, cFactura, cAgente ) )
      lFacturaProcesar  := .t.
   end if

Return ( lFacturaProcesar )

//---------------------------------------------------------------------------//

METHOD Contabilizar( lSimula ) CLASS TCobAge

   local cCtaAge     := ""
   local cCtaGas     := ""
   local aSimula     := {}
   local cCodPro     := cProCnt()
   local cRuta       := cRutCnt()
   local cCodEmp     := cCodEmpCnt( "A" )
   local nAsiento
   local lErrorFound := .f.
   local cLiquidacion

   cLiquidacion      := "Lqd. agentes N. " + AllTrim( Str( ::oDbf:nNumCob, 9 ) )

   if !ChkRuta( cRutCnt() )
      ::oTreeSelect:Select( ::oTreeSelect:Add( cLiquidacion + " ruta no valida.", 0 ) )
      lErrorFound    := .t.
   end if


   if Empty( cCodEmp )
      ::oTreeSelect:Select( ::oTreeSelect:Add( cLiquidacion + " no se definieron empresas asociadas", 0 ) )
      lErrorFound    := .t.
   end if
   /*
	Chequando antes de pasar a Contaplus
	--------------------------------------------------------------------------
	*/

   if ::oDbf:lConta
      if !msgYesNo( cLiquidacion + " ya contabilizada." + CRLF + "¿ Desea contabilizarla de nuevo ?" )
         return .f.
      end if
   end if

   if !lSimula .and. !ChkRuta( cRutCnt() )
      ::oTreeSelect:Select( ::oTreeSelect:Add( "Ruta de contaplus no valida.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Seleccionamos las empresa dependiendo de la serie de factura
	--------------------------------------------------------------------------
	*/

   if Empty( cCodEmp ) .and. !::lChkSelect
      ::oTreeSelect:Select( ::oTreeSelect:Add( cLiquidacion + " no se definierón empresas asociadas.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Comporbamos fechas
   ----------------------------------------------------------------------------
   */

   if !lSimula .and. !ChkFecha( , , ::oDbf:dFecCob, .f., ::oTreeSelect )
      lErrorFound    := .t.
   end if

   /*
   Estudio de los Articulos de una factura
   --------------------------------------------------------------------------
   */

   cCtaAge           := oRetFld( ::oDbf:cCodAge, ::oAgentes, "CtaAge" )

   if !lSimula .and. !ChkSubcuenta( cRuta, cCodEmp, cCtaAge, , .f., .f. )
      ::oTreeSelect:Select( ::oTreeSelect:Add( "Cuenta de agente : " + Rtrim( ::oAgentes:cNbrAge ) + Space( 1 ) + Rtrim( ::oAgentes:cApeAge ) + " cuenta contable no existe.", 0 ) )
      lErrorFound    := .t.
   end if

   cCtaGas           := oRetFld( ::oDbf:cCodAge, ::oAgentes, "CtaGas" )

   if !lSimula .and. !ChkSubcuenta( cRuta, cCodEmp, cCtaGas, , .f., .f. )
      ::oTreeSelect:Select( ::oTreeSelect:Add( "Cuenta de gasto : " + Rtrim( ::oAgentes:cNbrAge ) + Space( 1 ) + Rtrim( ::oAgentes:cApeAge ) + " cuenta contable no existe.", 0 ) )
      lErrorFound    := .t.
   end if

	/*
   Realización de Asientos
	--------------------------------------------------------------------------
   */

   if OpenDiario( , cCodEmp )
      nAsiento       := contaplusUltimoAsiento()
   else
      ::oTreeSelect:Select( ::oTreeSelect:Add( cLiquidacion + " imposible abrir ficheros de contaplus", 0 ) )
      Return .f.
   end if

   /*
   Agente_______________________________________________________________
   */

   aadd( aSimula, MkAsiento( nAsiento,;
                             ::oDbf:cCodDiv,;
                             ::oDbf:dFecCob,;
                             cCtaAge,;
                             ,;
                             ,;
                             cLiquidacion,;
                             ::oDbf:nTotCob,;
                             Str( ::oDbf:nNumCob, 9 ),;
                             ,;
                             ,;
                             ,;
                             ,;
                             cCodPro,;
                             ,;
                             ,;
                             ,;
                             ,;
                             lSimula ) )

   /*
   Gastos___________________________________________________________________
   */

   aadd( aSimula, MkAsiento( nAsiento,;
                             ::oDbf:cCodDiv,;
                             ::oDbf:dFecCob,;
                             cCtaGas,;
                             ,;
                             ::oDbf:nTotCob,;
                             cLiquidacion,;
                             ,;
                             Str( ::oDbf:nNumCob, 9 ),;
                             ,;
                             ,;
                             ,;
                             ,;
                             cCodPro,;
                             ,;
                             ,;
                             ,;
                             ,;
                             lSimula ) )

   if !lSimula

      if !lErrorFound
         ::lContabilizar( nAsiento )
      end if

   else

      msgTblCon( aSimula, ::oDbf:cCodDiv, ::oDivisas:cAlias, !lErrorFound, cLiquidacion, {|| aWriteAsiento( aSimula, ::oDbf:cCodDiv, .t., ::oTreeSelect, cLiquidacion, nAsiento ), ::lContabilizar( nAsiento ) } )

   end if

   CloseDiario()

   ::oWndBrw:Refresh()

RETURN ( !lErrorFound )

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

CLASS TDetCobAge FROM TDet

   DATA  oNumFac
   DATA  oCodCli
   DATA  oNomCli
   DATA  cNomCli
   DATA  oFecFac
   DATA  oImpCom
   DATA  oPctCom
   DATA  oTotCom
   DATA  oCodAge
   DATA  oNomAge

   DATA  oGetTotalCosto
   DATA  nGetTotalCosto    INIT  0

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode, lLiteral )

   METHOD SaveDetails()

   METHOD lFacturaRemesada( cNumFac )

   METHOD nTotalComisionFactura( cNumFac )

   METHOD nTotCosto( oDbf )
   METHOD lTotCosto( oDbf )

   METHOD lPreSave( oGetTipoHora, oDlg )

   METHOD LoadFacturas( lRectificativa )
   METHOD BrowseFacturas( lRectificativa )   INLINE   ( if( lRectificativa,;
                                                            browseFacturasRectificativas( ::oNumFac, , ::nView ),;
                                                            browseFacturasClientes( ::oNumFac, , ::nView ) ) )

   METHOD lChangeComision()                  INLINE   ( ::oTotCom:cText( ::oImpCom:VarGet() * ::oPctCom:VarGet() / 100 ) )

   METHOD nTotalLineaVirtual()               INLINE   ( ::oDbfVir:nImpCom * ::oDbfVir:nComAge / 100 )
   METHOD nTotalLineaLiquidacion()           INLINE   ( ::oDbf:nImpCom * ::oDbf:nComAge / 100 )

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName ) CLASS TDetCobAge

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cVia         := cDriver()
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "RemAgeL"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Lineas de liquidación de agentes"

      FIELD NAME "nNumCob"    TYPE "N" LEN 09  DEC 0 COMMENT "Número"                              OF oDbf
      FIELD NAME "cSufCob"    TYPE "C" LEN 02  DEC 0 COMMENT "Sufijo"                              OF oDbf
      FIELD NAME "cSerFac"    TYPE "C" LEN 01  DEC 0 COMMENT "Serie factura"                       OF oDbf
      FIELD NAME "nNumFac"    TYPE "N" LEN 09  DEC 0 COMMENT "Número factura"                      OF oDbf
      FIELD NAME "cSufFac"    TYPE "C" LEN 02  DEC 0 COMMENT "Sufijo factura"                      OF oDbf
      FIELD NAME "lFacRec"    TYPE "L" LEN 01  DEC 0 COMMENT "Factura rectificativa"               OF oDbf
      FIELD NAME "dFecFac"    TYPE "D" LEN 08  DEC 0 COMMENT "Fecha factura"                       OF oDbf
      FIELD NAME "cCodCli"    TYPE "C" LEN 12  DEC 0 COMMENT "Código de cliente"                   OF oDbf
      FIELD NAME "cNomCli"    TYPE "C" LEN 80  DEC 0 COMMENT "Nombre de cliente"                   OF oDbf
      FIELD NAME "cCodAge"    TYPE "C" LEN 03  DEC 0 COMMENT "Código de agente"                    OF oDbf
      FIELD NAME "nImpCom"    TYPE "N" LEN 16  DEC 6 COMMENT "Importe comisión"                    OF oDbf
      FIELD NAME "nComAge"    TYPE "N" LEN 06  DEC 2 COMMENT "Comisión del agente"                 OF oDbf

      INDEX TO ( cFileName )  TAG "nNumCob" ON "Str( nNumCob ) + cSufCob"                          NODELETED                  OF oDbf
      INDEX TO ( cFileName )  TAG "cNumDoc" ON "cSerFac + Str( nNumFac, 9 ) + cSufFac + cCodAge"   NODELETED                  OF oDbf
      INDEX TO ( cFileName )  TAG "cNumFac" ON "cSerFac + Str( nNumFac, 9 ) + cSufFac + cCodAge"   NODELETED FOR "!lFacRec"   OF oDbf
      INDEX TO ( cFileName )  TAG "cNumRct" ON "cSerFac + Str( nNumFac, 9 ) + cSufFac + cCodAge"   NODELETED FOR "lFacRec"    OF oDbf
      INDEX TO ( cFileName )  TAG "dFecFac" ON "dFecFac"                                           NODELETED                  OF oDbf
      INDEX TO ( cFileName )  TAG "cCodCli" ON "cCodCli"                                           NODELETED                  OF oDbf
      INDEX TO ( cFileName )  TAG "cNomCli" ON "cNomCli"                                           NODELETED                  OF oDbf
      INDEX TO ( cFileName )  TAG "cCodAge" ON "cCodAge"                                           NODELETED                  OF oDbf
      INDEX TO ( cFileName )  TAG "xNumCob" ON "Str( nNumCob ) + cSufCob + cCodAge + cNomCli + cSerFac + Str( nNumFac, 9 ) + cSufFac" NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TDetCobAge

   local lOpen          := .t.
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive  := .f.

   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::oDbf            := ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !lExclusive )

   ::bOnPreSaveDetail   := {|| ::SaveDetails() }

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos de lineas de liquidaciones" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD Resource( nMode, lRectificativa ) CLASS TDetCobAge

   local oDlg
   local cNumFac
   local cCodAge
   local cNomAge
   //local cNomCli
   local nPctCom           := 0
   local nImpCom           := 0
   local nTotCom           := 0

   DEFAULT lRectificativa  := .f.

   cNumFac                 := ::oDbfVir:cSerFac + Str( ::oDbfVir:nNumFac ) + ::oDbfVir:cSufFac
   cNomAge                 := oRetFld( ::oDbfVir:cCodAge, ::oParent:oAgentes )
   //cNomCli                 := oRetFld( ::oDbfVir:cCodCli, ::oParent:oClientes )

   DEFINE DIALOG oDlg RESOURCE "lCobRec" TITLE lblTitle( nMode ) + if( !lRectificativa, "facturas de clientes", "facturas rectificativas de clientes" )

      REDEFINE GET ::oNumFac VAR cNumFac ;
			ID 		100 ;
         PICTURE  "@R X/#########/XX" ;
			WHEN 		( nMode == APPD_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oNumFac:bValid     := {|| ::LoadFacturas( lRectificativa ) }
      ::oNumFac:bHelp      := {|| ::BrowseFacturas( lRectificativa ) }

      REDEFINE GET ::oCodCli VAR ::oDbfVir:cCodCli ;
         ID       110 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oNomCli VAR ::oDbfVir:cNomCli ;
         ID       111 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oFecFac VAR ::oDbfVir:dFecFac ;
         ID       120 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oCodAge VAR ::oDbfVir:cCodAge ;
         ID       160 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oNomAge VAR cNomAge ;
         ID       161 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET ::oImpCom VAR ::oDbfVir:nImpCom ;
         ID       130 ;
         PICTURE  ::oParent:cPorDiv ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oImpCom:bChange    := {|| ::lChangeComision() }

      REDEFINE GET ::oPctCom VAR ::oDbfVir:nComAge ;
         ID       140 ;
         PICTURE  "@E 999.99" ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      ::oPctCom:bChange := {|| ::lChangeComision() }

      REDEFINE GET ::oTotCom VAR nTotCom ;
         ID       150 ;
         PICTURE  ::oParent:cPorDiv ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:bStart := {|| ::lChangeComision() }

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD lPreSave() CLASS TDetCobAge

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD SaveDetails() CLASS TDetCobAge

   ::oDbfVir:nNumCob    := ::oParent:oDbf:nNumCob
   ::oDbfVir:cSufCob    := ::oParent:oDbf:cSufCob

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotalComisionFactura( lRectificativa, cNumFac, cCodAge, nPorcentajeAgente ) CLASS TDetCobAge

   local nImporte
   local nComision
   local nComisionFactura              := 0
   local nTotalComisionFactura         := 0
   local nPorcentajeComisionFactura    := 0

   DEFAULT lRectificativa              := .f.

   if lRectificativa

      if ::oParent:oFacRecL:Seek( cNumFac )

         while ::oParent:oFacRecL:cSerie + Str( ::oParent:oFacRecL:nNumFac ) + ::oParent:oFacRecL:cSufFac == cNumFac .and. !::oParent:oFacRecL:Eof()

            //if Empty( cCodAge ) .or. Empty( ::oParent:oFacRecL:cCodAge ) .or. ( ::oParent:oFacRecL:cCodAge == cCodAge )

            nImporte                   := nImpLFacRec( ::oParent:oFacRecT:cAlias, ::oParent:oFacRecL:cAlias, ::oParent:nDouDiv, ::oParent:nDorDiv, , .f., .t., .f., .f. )

            if IsNum( nPorcentajeAgente ) .and. ( nPorcentajeAgente != 0)
               nComision               := nImporte * nPorcentajeAgente / 100
            else
               nComision               := nImporte * ::oParent:oFacRecL:nComAge / 100
            end if

            nTotalComisionFactura      += nImporte
            nComisionFactura           += nComision

            //end if

            ::oParent:oFacRecL:Skip()

         end while

      end if

   else

      if ::oParent:oFacCliL:Seek( cNumFac )

         while ::oParent:oFacCliL:cSerie + Str( ::oParent:oFacCliL:nNumFac ) + ::oParent:oFacCliL:cSufFac == cNumFac .and. !::oParent:oFacCliL:Eof()

            //if Empty( cCodAge ) .or. Empty( ::oParent:oFacCliL:cCodAge ) .or. ( ::oParent:oFacCliL:cCodAge == cCodAge )

            nImporte                   := nImpLFacCli( ::oParent:oFacCliT:cAlias, ::oParent:oFacCliL:cAlias, ::oParent:nDouDiv, ::oParent:nDorDiv, , .f., .t., .f., .f. )

            if IsNum( nPorcentajeAgente ) .and. ( nPorcentajeAgente != 0)
               nComision               := nImporte * nPorcentajeAgente / 100
            else
               nComision               := nImporte * ::oParent:oFacCliL:nComAge / 100
            end if

            nTotalComisionFactura      += nImporte
            nComisionFactura           += nComision

            //end if

            ::oParent:oFacCliL:Skip()

         end while

      end if

   end if

   nPorcentajeComisionFactura          := nTotalComisionFactura / nComisionFactura

   /*
   Casos especiales para RD----------------------------------------------------

   if lBancas() .and. nTotalComisionFactura < 0
      nComisionFactura                 := nTotalComisionFactura
      nPorcentajeComisionFactura       := 100
   end if
   */

   /*
   Fin casos especiales para RD------------------------------------------------
   */

   if !Empty( ::oImpCom )
      ::oImpCom:cText( nTotalComisionFactura )
   end if

   if !Empty( ::oTotCom )
      ::oTotCom:cText( nComisionFactura )
   end if

   if !Empty( ::oPctCom )
      ::oPctCom:cText( nPorcentajeComisionFactura )
   end if

RETURN ( { nTotalComisionFactura, nComisionFactura } )

//---------------------------------------------------------------------------//

METHOD lFacturaRemesada( lRectificativa, cNumeroFactura, cCodigoAgente ) CLASS TDetCobAge

   local lFacturaRemesada  := .f.

   DEFAULT lRectificativa  := .f.
   DEFAULT cCodigoAgente   := ""

   ::oDbf:GetStatus()

   if lRectificativa

      if ::oDbf:SeekInOrd( cNumeroFactura + cCodigoAgente, "cNumRct" )
         lFacturaRemesada  := .t.
      end if

   else

      if ::oDbf:SeekInOrd( cNumeroFactura + cCodigoAgente, "cNumFac" )
         lFacturaRemesada  := .t.
      end if

   end if

   ::oDbf:SetStatus()

RETURN ( lFacturaRemesada )

//----------------------------------------------------------------------------//

METHOD nTotCosto( oDbf ) CLASS TDetCobAge

   local nTotalImporte

   DEFAULT oDbf   := ::oDbf

   nTotalImporte  := oDbf:nNumHra * oDbf:nCosHra

RETURN ( nTotalImporte )

//---------------------------------------------------------------------------//

METHOD lTotCosto( oDbf ) CLASS TDetCobAge

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotalCosto:cText( ::nTotCosto( oDbf ) ), .t. )

//---------------------------------------------------------------------------//

METHOD LoadFacturas( lRectificativa ) CLASS TDetCobAge

   local cNumFac
   local lLoaRec           := .t.

   DEFAULT lRectificativa  := .f.

   cNumFac                 := Upper( ::oNumFac:VarGet() )
   cNumFac                 := SubStr( cNumFac, 1, 1 ) + Padl( Alltrim( SubStr( cNumFac, 2, 9 ) ), 9 )

   /*
   Comprobamos q no este en la liquidación-------------------------------------
   */

   ::oDbfVir:GetStatus()

   if lRectificativa

      if ::oDbfVir:SeekInOrd( cNumFac, "cNumRct" )
         MsgStop( "La factura ya esta incluida en esta liquidación." )
         lLoaRec           := .f.
      end if

   else

      if ::oDbfVir:SeekInOrd( cNumFac, "cNumFac" )
         MsgStop( "La factura ya esta incluida en esta liquidación." )
         lLoaRec           := .f.
      end if

   end if

   ::oDbfVir:SetStatus()

   if !lLoaRec
      return .f.
   end if

   /*
   Vamos a comprobar q la factura no este liquidada en otra liquidación anterior
   */

   if ::lFacturaRemesada( lRectificativa, cNumFac )
      if !MsgYesNo( "La factura ya está incluida en otra liquidación." + CRLF + "¿Desea incluirla de todas formas?", "Seleccione" )
         return .f.
      end if
   end if

   /*
   Seguimos para cargarlo en la liquidación------------------------------------
   */

   if lRectificativa

      ::oParent:oFacRecT:GetStatus()
      ::oParent:oFacRecT:SetFocus( "nNumFac" )

      if ::oParent:oFacRecT:Seek( cNumFac )

         if ::oParent:oFacRecT:cCodAge != ::oParent:oDbf:cCodAge

            if !MsgYesNo( "La factura rectificativa " + ::oParent:oFacRecT:cSerie + "/" + Alltrim( Str( ::oParent:oFacRecT:nNumFac ) ) + " pertence a otro agente" + CRLF +;
                          "¿ desea asignarlo al agente " + Rtrim( ::oParent:oDbf:cCodAge ) + " ?", "Seleccione" )

               lLoaRec  := .f.

            end if

         end if

         if lLoaRec

            ::oDbfVir:cSerFac := ::oParent:oFacRecT:cSerie
            ::oDbfVir:nNumFac := ::oParent:oFacRecT:nNumFac
            ::oDbfVir:cSufFac := ::oParent:oFacRecT:cSufFac
            ::oDbfVir:lFacRec := .t.

            ::oNumFac:cText( ::oParent:oFacRecT:cSerie + Str( ::oParent:oFacRecT:nNumFac ) + ::oParent:oFacRecT:cSufFac )

            ::oCodCli:cText( ::oParent:oFacRecT:cCodCli )

            ::oNomCli:cText( ::oParent:oFacRecT:cNomCli )

            ::oFecFac:cText( ::oParent:oFacRecT:dFecFac )

            ::oCodAge:cText( ::oParent:oFacRecT:cCodAge )

            ::oNomAge:cText( oRetFld( ::oParent:oFacRecT:cCodAge, ::oParent:oAgentes ) )

            ::nTotalComisionFactura( .t., ::oParent:oFacRecT:cSerie + Str( ::oParent:oFacRecT:nNumFac ) + ::oParent:oFacRecT:cSufFac )

         end if

         lLoaRec        := .t.

      else

         MsgStop( "Número de factura rectificativa no encontrada." )

         lLoaRec        := .f.

      end if

      ::oParent:oFacRecT:SetStatus()

   else

      ::oParent:oFacCliT:GetStatus()
      ::oParent:oFacCliT:SetFocus( "nNumFac" )

      if ::oParent:oFacCliT:Seek( cNumFac )

         if ::oParent:oFacCliT:cCodAge != ::oParent:oDbf:cCodAge

            if !MsgYesNo( "La factura " + ::oParent:oFacCliT:cSerie + "/" + Alltrim( Str( ::oParent:oFacCliT:nNumFac ) ) + " pertence a otro agente" + CRLF +;
                          "¿ desea asignarlo al agente " + Rtrim( ::oParent:oDbf:cCodAge ) + " ?", "Seleccione" )

               lLoaRec  := .f.

            end if

         end if

         if lLoaRec

            ::oDbfVir:cSerFac := ::oParent:oFacCliT:cSerie
            ::oDbfVir:nNumFac := ::oParent:oFacCliT:nNumFac
            ::oDbfVir:cSufFac := ::oParent:oFacCliT:cSufFac
            ::oDbfVir:lFacRec := .f.

            ::oNumFac:cText( ::oParent:oFacCliT:cSerie + Str( ::oParent:oFacCliT:nNumFac ) + ::oParent:oFacCliT:cSufFac )

            ::oCodCli:cText( ::oParent:oFacCliT:cCodCli )

            ::oNomCli:cText( ::oParent:oFacCliT:cNomCli )

            ::oFecFac:cText( ::oParent:oFacCliT:dFecFac )

            ::oCodAge:cText( ::oParent:oFacCliT:cCodAge )

            ::oNomAge:cText( oRetFld( ::oParent:oFacCliT:cCodAge, ::oParent:oAgentes ) )

            ::nTotalComisionFactura( .f., ::oParent:oFacCliT:cSerie + Str( ::oParent:oFacCliT:nNumFac ) + ::oParent:oFacCliT:cSufFac )

         end if

         lLoaRec        := .t.

      else

         MsgStop( "Número de factura no encontrada." )

         lLoaRec        := .f.

      end if

      ::oParent:oFacCliT:SetStatus()

   end if

RETURN ( lLoaRec )

//--------------------------------------------------------------------------//

FUNCTION nTotalLineaLiquidacion()

   if !Empty( oThis )
      RETURN ( oThis:oDetCobAge:nTotalLineaLiquidacion() )
   end if

RETURN ( 0 )

//--------------------------------------------------------------------------//