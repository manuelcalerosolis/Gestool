#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Folder.ch"
   #include "Report.ch"
   #include "Print.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif
   #include "Factu.ch" 

#define _MENUITEM_           "01181"

#define CLR_BAR              14197607
#define CLR_KIT              Rgb( 239, 239, 239 )

#define impuestos_DESG       1
#define impuestos_INCL       2 

#define _CSERANT             1
#define _NNUMANT             2
#define _CSUFANT             3
#define _CTURANT             4
#define _DFECANT             5
#define _CCODCLI             6
#define _CCODALM             7
#define _CCODCAJ             8
#define _CNOMCLI             9
#define _CDIRCLI             10
#define _CPOBCLI             11
#define _CPRVCLI             12
#define _NCODPROV            13
#define _CPOSCLI             14
#define _CDNICLI             15
#define _LMODCLI             16
#define _LMAYOR              17
#define _CCODAGE             18
#define _CCODRUT             19
#define _CCODOBR             20
#define _NPCTCOMAGE          21
#define _LLIQUIDADA          22
#define _DLIQUIDADA          23
#define _CTURLIQ             24
#define _CCAJLIQ             25
#define _LCONTAB             26
#define _CSUANT              27
#define _CCONDENT            28
#define _MDESCRIP            29
#define _NIMPART             30
#define _CCODPAGO            31
#define _NPORCIVA            32
#define _LRECARGO            33
#define _CREMITIDO           34
#define _LIVAINC             35
#define _LSNDDOC             36
#define _CDIVANT             37
#define _NVDVANT             38
#define _CRETPOR             39
#define _CRETMAT             40
#define _CNUMDOC             41
#define _NREGIVA             42
#define _CCODPRO             43
#define _CDOCORG             44
#define _NPCTIVA             45
#define _NPCTREQ             46
#define _NPCTRET             47
#define _LCLOANT             48
#define _CCODUSR             49
#define _DFECCRE             50
#define _CTIMCRE             51
#define _LSELDOC             52
#define _CCTAPGO             53
#define _NREQ                54  //  N    16    6
#define _CCODDLG             55
#define _CTLFCLI             56  //  C    20    0
#define _NTOTNET             57
#define _NTOTIVA             58
#define _NTOTREQ             59
#define _NTOTANT             60
#define _CCENTROCOSTE        61

/*
Variables Memvar para todo el .prg logico no!
*/

memvar cDbf
memvar cDbfCli
memvar cDbfDiv
memvar cDbfPgo
memvar cDbfIva
memvar cDbfAge
memvar cDbfObr
memvar cDbfUsr
memvar nTotNet
memvar nTotIva
memvar nTotReq
memvar nTotAnt
memvar nTotImp
memvar nTotRet
memvar nTotAge
memvar cCtaCli
memvar nVdv
memvar nVdvDivAnt
memvar cPicUndAnt
memvar cPouDivAnt
memvar cPorDivAnt
memvar cPpvDivAnt
memvar nDouDivAnt
memvar nRouDivAnt
memvar nDpvDivAnt
memvar cCodPgo
memvar nPagina
memvar lEnd

/*
Variables Staticas para todo el .prg logico no!
*/

static oWndBrw

static nView

static oBrw
static dbfUsr
static dbfTikCliT
static dbfAntCliT
static dbfAntCliI
static dbfAntCliD
static dbfFacCliP
static dbfFacCliT
static dbfAlbCliT
static dbfTmpInc
static dbfTmpDoc
static dbfIva
static dbfCount
static dbfCli
static dbfFPago
static dbfAgent
static dbfDiv
static dbfInci
static dbfObrasT
static dbfDoc
static dbfCajT
static dbfAlmT
static dbfDelega
static dbfAgeCom

static dbfEmp
static oBandera
static cTmpInc
static cTmpDoc
static oGetTotal
static oGetNet
static oGetPctRet
static oGetIva
static oGetReq
static oGetAge
static cPouDiv
static cPorDiv
static cPpvDiv
static cPicUnd
static nVdvDiv
static nDouDiv
static nRouDiv
static nDpvDiv
static nTotOld
static oMenu
static oStock

static cOldCodCli       := ""
static lOpenFiles       := .f.
static lExternal        := .f.
static cFiltroUsuario   := ""

static oDetCamposExtra

static oCentroCoste

static Counter

#ifndef __PDA__

static bEdtRec          := { |aTmp, aGet, dbfAntCliT, oBrw, bWhen, bValid, nMode, cSerAnt| EdtRec( aTmp, aGet, dbfAntCliT, oBrw, bWhen, bValid, nMode, cSerAnt ) }
static bEdtInc          := { |aTmp, aGet, dbfAntCliI, oBrw, bWhen, bValid, nMode, aTmpLin | EdtInc( aTmp, aGet, dbfAntCliI, oBrw, bWhen, bValid, nMode, aTmpLin ) }
static bEdtDoc          := { |aTmp, aGet, dbfAntCliD, oBrw, bWhen, bValid, nMode, aTmpLin | EdtDoc( aTmp, aGet, dbfAntCliD, oBrw, bWhen, bValid, nMode, aTmpLin ) }

#endif

#ifndef __PDA__

//---------------------------------------------------------------------------//
//Funciones del programa
//---------------------------------------------------------------------------//

STATIC FUNCTION GenAntCli( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice
   local cAnticipo

   if ( dbfAntCliT )->( Lastrec() ) == 0
      return nil
   end if

   cAnticipo            := ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt ) + ( dbfAntCliT )->cSufAnt

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo anticipos : " + cAnticipo
   DEFAULT cCodDoc      := cFormatoDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount )
   DEFAULT nCopies      := if( nCopiasDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount ) == 0, Max( Retfld( ( dbfAntCliT )->cCodCli, dbfCli, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount ) )

   if Empty( cCodDoc )
      cCodDoc           := cFirstDoc( "TC", dbfDoc )
   end if

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   /*
   Informacion al Auditor------------------------------------------------------
   */

   if !Empty( oAuditor() )
      if nDevice == IS_PRINTER
         oAuditor():AddEvent( PRINT_FACTURA_ANTICIPO,    cAnticipo, ANT_CLI )
      else
         oAuditor():AddEvent( PREVIEW_FACTURA_ANTICIPO,  cAnticipo, ANT_CLI )
      end if
   end if

   /*
   Si el documento es de tipo visual-------------------------------------------
   */

   if lVisualDocumento( cCodDoc, dbfDoc )

      PrintReportAntCli( nDevice, nCopies, cPrinter, dbfDoc )

   else

      /*
      Recalculamos la Anticipo----------------------------------------------------
      */

      nTotAntCli( dbfAntCliT, dbfIva, dbfDiv, nil, nil, .t. )

      /*
      Pasamos los parametros
      */

      private cDbf         := dbfAntCliT
      private cDbfCli      := dbfCli
      private cDbfDiv      := dbfDiv
      private cDbfPgo      := dbfFPago
      private cDbfIva      := dbfIva
      private cDbfAge      := dbfAgent
      private cDbfObr      := dbfObrasT
      private cDbfUsr      := dbfUsr
      private nVdv         := nVdvDiv
      private nVdvDivAnt   := nVdvDiv
      private cPicUndAnt   := cPicUnd
      private cPouDivAnt   := cPouDiv
      private cPorDivAnt   := cPorDiv
      private cPpvDivAnt   := cPpvDiv
      private nDouDivAnt   := nDouDiv
      private nRouDivAnt   := nRouDiv
      private nDpvDivAnt   := nDpvDiv
      private cCodPgo      := ( dbfAntCliT )->cCodPago

      /*
      Posicionamos en ficheros auxiliares
      */

      ( dbfCli    )->( dbSeek( ( dbfAntCliT )->cCodCli ) )
      ( dbfAgent  )->( dbSeek( ( dbfAntCliT )->cCodAge ) )
      ( dbfFPago  )->( dbSeek( ( dbfAntCliT )->cCodPago) )
      ( dbfDiv    )->( dbSeek( ( dbfAntCliT )->cDivAnt ) )
      ( dbfObrasT )->( dbSeek( ( dbfAntCliT )->cCodCli + ( dbfAntCliT )->cCodObr ) )

      if !Empty( cPrinter )
         oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
         REPORT oInf CAPTION cCaption TO DEVICE oDevice
      else
         REPORT oInf CAPTION cCaption PREVIEW
      end if

      /*
      Cabeceras del listado----------------------------------------------------
      */

      if !Empty( oInf ) .and. oInf:lCreated
         oInf:lAutoland    := .f.
         oInf:lFinish      := .f.
         oInf:lNoCancel    := .t.
         oInf:bSkip        := {|| ( dbfAntCliT )->( dbSkip() ) }

         oInf:oDevice:lPrvModal  := .t.

         do case
            case nDevice == IS_PRINTER

               oInf:oDevice:SetCopies( nCopies )

               oInf:bPreview  := {| oDevice | PrintPreview( oDevice ) }

            case nDevice == IS_PDF

               oInf:bPreview  := {| oDevice | PrintPdf( oDevice ) }

         end if

         SetMargin( cCodDoc, oInf )
         PrintColum( cCodDoc, oInf )

      end if

      END REPORT

      if !Empty( oInf )

         ACTIVATE REPORT oInf ;
            WHILE       ( ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt ) + ( dbfAntCliT )->cSufAnt = cAnticipo ) ;
            ON STARTPAGE( EPage( oInf, cCodDoc ) )

         if nDevice == IS_PRINTER
            oInf:oDevice:end()
         end if

      end if

      oInf                 := nil

   end if

RETURN NIL

//--------------------------------------------------------------------------//

Static Function EPage( oInf, cCodDoc )

   private nPagina      := oInf:nPage
   private lEnd         := oInf:lFinish

	/*
	Reposicionamos en las distintas areas
   */

   PrintItems( cCodDoc, oInf )

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt )

   local oBlock
   local oError

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de facturas de anticipos a clientes' )
      Return ( .f. )
   end if

   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nView                := D():CreateView()

   D():Get( "CliInc", nView )

   D():Get( "LogPorta", nView )

   USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "AntCliI.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliI", @dbfAntCliI ) )
   SET ADSINDEX TO ( cPatEmp() + "AntCliI.CDX" ) ADDITIVE

   USE ( cPatEmp() + "AntCliD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliD", @dbfAntCliD ) )
   SET ADSINDEX TO ( cPatEmp() + "AntCliD.CDX" ) ADDITIVE

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfCli ) )
   SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
   SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
   SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
   SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
   SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

   USE ( cPatCli() + "ObrasT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
   SET ADSINDEX TO ( cPatCli() + "ObrasT.Cdx" ) ADDITIVE

   USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
   SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
   SET TAG TO "CTIPO"

   USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
   SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

   USE ( cPatAlm() + "ALMACEN.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALMACEN", @dbfAlmT ) )
   SET ADSINDEX TO ( cPatAlm() + "ALMACEN.CDX" ) ADDITIVE

   USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
   SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

   USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
   SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

   USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDelega ) )
   SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

   USE ( cPatEmp() + "AGECOM.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGECOM", @dbfAgeCom ) )
   SET ADSINDEX TO ( cPatEmp() + "AGECOM.CDX" ) ADDITIVE

   USE ( cPatDat() + "EMPRESA.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
   SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

   USE ( cPatEmp() + "TIKET.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIKET", @dbfTikCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "TIKET.CDX" ) ADDITIVE

   if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
      lOpenFiles     := .f.
   end if

   if !TDataCenter():OpenFacCliT( @dbfFacCliT )
      lOpenFiles        := .f.
   end if

   if !TDataCenter():OpenFacCliP( @dbfFacCliP )
      lOpenFiles        := .f.
   end if

   oBandera             := TBandera():New()

   oStock               := TStock():Create( cPatEmp() )
   if !oStock:lOpenFiles()
      lOpenFiles        := .f.
   end if

   oCentroCoste         := TCentroCoste():Create( cPatDat() )
   if !oCentroCoste:OpenFiles()
      lOpenFiles        := .f.
   end if

   lOpenFiles           := .t.

   public nTotAnt       := 0
   public nTotNet       := 0
   public nTotIva       := 0
   public nTotAge       := 0
   public nTotReq       := 0
   public nTotRet       := 0
   public nTotImp       := 0

   Counter           := TCounter():New( nView, "nAntCli" )

   /*
   Limitaciones de cajero y cajas--------------------------------------------------------
   */

   if SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() )
      cFiltroUsuario    := "Field->cCodUsr == '" + Auth():Codigo()  + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
   end if

   /*
      Campos extras------------------------------------------------------------------------
   */

   oDetCamposExtra      := TDetCamposExtra():New()
   oDetCamposExtra:OpenFiles()
   oDetCamposExtra:SetTipoDocumento( "Facturas de anticipos a clientes" )
   oDetCamposExtra:setbId( {|| D():AnticiposClientesId( nView ) } )


   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )
      CloseFiles()

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lOpenFiles )

//---------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   DestroyFastFilter( dbfAntCliT, .t., .t. )

   if !Empty( dbfAntCliT )
      ( dbfAntCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfIva )
      ( dbfIva     )->( dbCloseArea() )
   end if

   if !Empty( dbfFPago )
      ( dbfFPago   )->( dbCloseArea() )
   end if

   if !Empty( dbfAgent )
      ( dbfAgent   )->( dbCloseArea() )
   end if

   if !Empty( dbfCli )
      ( dbfCli     )->( dbCloseArea() )
   end if

   if !Empty( dbfAntCliI )
      ( dbfAntCliI )->( dbCloseArea() )
   end if

   if !Empty( dbfAntCliD )
      ( dbfAntCliD )->( dbCloseArea() )
   end if

   if !Empty( dbfDiv )
      ( dbfDiv     )->( dbCloseArea() )
   end if

   if !Empty( dbfObrasT )
      ( dbfObrasT  )->( dbCloseArea() )
   end if

   if !Empty( dbfDoc )
      ( dbfDoc     )->( dbCloseArea() )
   end if

   if !Empty( dbfCajT )
      ( dbfCajT    )->( dbCloseArea() )
   end if

   if !Empty( dbfAlmT )
      ( dbfAlmT    )->( dbCloseArea() )
   end if

   if !Empty( dbfUsr )
      ( dbfUsr )->( dbCloseArea() )
   end if

   if !Empty( dbfCount )
      ( dbfCount   )->( dbCloseArea() )
   end if

   if dbfDelega != nil
      ( dbfDelega )->( dbCloseArea() )
   end if

   if !Empty( dbfAgeCom )
      ( dbfAgeCom )->( dbCloseArea() )
   end if

   if !Empty( dbfEmp )
      ( dbfEmp )->( dbCloseArea() )
   end if

   if !Empty( dbfTikCliT )
      ( dbfTikCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfFacCliP )
      ( dbfFacCliP )->( dbCloseArea() )
   end if

   if !Empty( dbfAlbCliT )
      ( dbfAlbCliT )->( dbCloseArea() )
   end if

   if !Empty( dbfFacCliT )
      ( dbfFacCliT )->( dbCloseArea() )
   end if

   if !Empty( oStock )
      oStock:end()
   end if

   if !Empty( oCentroCoste )
      oCentroCoste:end()
   end if

   if !Empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   D():DeleteView( nView )

   dbfIva      := nil
   dbfFPago    := nil
   dbfAgent    := nil
   dbfCli      := nil
   dbfAntCliT  := nil
   dbfAntCliI  := nil
   dbfAntCliD  := nil
   dbfDiv      := nil
   oBandera    := nil
   dbfObrasT   := nil
   dbfDoc      := nil
   dbfCajT     := nil
   dbfAlmT     := nil
   dbfUsr      := nil
   dbfCount    := nil
   dbfDelega   := nil
   dbfAgeCom   := nil
   dbfEmp      := nil

   oWndBrw     := nil

   lOpenFiles  := .f.

RETURN .T.

//--------------------------------------------------------------------------//

FUNCTION FacAntCli( oMenuItem, oWnd, cCodCli )

   local oRpl
   local oSnd
   local oImp
   local oPrv
   local oDel
   local oPdf
   local oMail
   local oBtnEur
   local lEuro          := .f.
   local nLevel
   local oRotor

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()
   DEFAULT  cCodCli     := nil

   nLevel               := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      Return Nil
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !OpenFiles()
      Return .f.
   end if

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
      XBROWSE ;
      TITLE    "Facturas de anticipos a clientes" ;
      PROMPT   "Número",;
               "Fecha",;
               "Código",;
               "Nombre",;
               "Dirección";
      MRU      "gc_document_text_money2_16";
      BITMAP   clrTopArchivos ;
      ALIAS    ( dbfAntCliT );
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdtRec, dbfAntCliT, cCodCli ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdtRec, dbfAntCliT, cCodCli ) );
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdtRec, dbfAntCliT, cCodCli ) );
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfAntCliT, {|| QuiAntCli() } ) );
      LEVEL    nLevel ;
      OF       oWnd

	  oWndBrw:lFechado     := .t.

	  oWndBrw:bChgIndex    := {|| if( SQLAjustableModel():getRolFiltrarVentas( Auth():rolUuid() ), CreateFastFilter( cFiltroUsuario, dbfAntCliT, .f., , cFiltroUsuario ), CreateFastFilter( "", dbfAntCliT, .f. ) ) }

	  oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAntCliT )->lCloAnt }
         :nWidth           := 20
         :bLDClickData     := {|| oWndBrw:RecEdit() }
         :SetCheck( { "gc_lock2_12", "Nil16" } )
         :AddResource( "gc_lock2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Contabilizado"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAntCliT )->lContab }
         :nWidth           := 20
         :bLDClickData     := {|| oWndBrw:RecEdit() }
         :SetCheck( { "gc_folder2_12", "Nil16" } )
         :AddResource( "gc_folder2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAntCliT )->lSndDoc }
         :nWidth           := 20
         :bLDClickData     := {|| oWndBrw:RecEdit() }
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Liquidada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfAntCliT )->lLiquidada }
         :nWidth           := 20
         :bLDClickData     := {|| oWndBrw:RecEdit() }
         :SetCheck( { "Sel16", "Cnt16" } )
         :AddResource( "gc_money2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Incidencia"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoIncidencia( ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt ) + ( dbfAntCliT )->cSufAnt ) }
         :nWidth           := 20
         :lHide            := .t.
         :bLDClickData     := {|| oWndBrw:RecEdit() }
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
         :AddResource( "gc_document_information_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumAnt"
         :bEditValue       := {|| ( dbfAntCliT )->cSerAnt + "/" + Alltrim( Str( ( dbfAntCliT )->nNumAnt ) ) + "/" + ( dbfAntCliT )->cSufAnt }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( dbfAntCliT )->cCodDlg }
         :nWidth           := 20
         :lHide            := .t.
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ( dbfAntCliT )->cTurAnt, "######" ) }
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "dDesFec"
         :bEditValue       := {|| Dtoc( ( dbfAntCliT )->dFecAnt ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( dbfAntCliT )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( dbfAntCliT )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| AllTrim( ( dbfAntCliT )->cCodCli ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| AllTrim( ( dbfAntCliT )->cNomCli ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Población"
         :bEditValue       := {|| AllTrim( ( dbfAntCliT )->cPobCli ) }
         :nWidth           := 180
         :lHide            := .t.
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :bEditValue       := {|| ( dbfAntCliT )->cCodAge }
         :nWidth           := 50
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Ruta"
         :bEditValue       := {|| ( dbfAntCliT )->cCodRut }
         :nWidth           := 40
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Almacén"
         :bEditValue       := {|| ( dbfAntCliT )->cCodAlm }
         :nWidth           := 60
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Dirección"
         :cSortOrder       := "cCodObr"
         :bEditValue       := {|| ( dbfAntCliT )->cCodObr }
         :nWidth           := 40
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Base"
         :bEditValue       := {|| ( dbfAntCliT )->nTotNet }
         :cEditPicture     := cPorDiv( ( dbfAntCliT )->cDivAnt, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| ( dbfAntCliT )->nTotIva }
         :cEditPicture     := cPorDiv( ( dbfAntCliT )->cDivAnt, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| ( dbfAntCliT )->nTotReq }
         :cEditPicture     := cPorDiv( ( dbfAntCliT )->cDivAnt, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ( dbfAntCliT )->nTotAnt }
         :cEditPicture     := cPorDiv( ( dbfAntCliT )->cDivAnt, dbfDiv )
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div."
         :bEditValue       := {|| cSimDiv( if( lEuro, cDivChg(), ( dbfAntCliT )->cDivAnt ), dbfDiv ) }
         :nWidth           := 30
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Documento"
         :bEditValue       := {|| Trans( ( dbfAntCliT )->cNumDoc, "@R #/#########/##" ) }
         :nWidth           := 60
         :lHide            := .t.
         :bLDClickData     := {|| oWndBrw:RecEdit() }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Centro de coste"
         :bEditValue       := {|| ( dbfAntCliT )->cCtrCoste }
         :nWidth           := 30
         :lHide            := .t.
      end with

   oWndBrw:cHtmlHelp    := "Factura de anticipos a clientes"

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
      HOTKEY   "M" ;
      MRU;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( WinZooRec( oWndBrw:oBrw, bEdtRec, dbfAntCliT ) );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z" ;
      MRU;
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL oDel RESOURCE "DEL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( WinDelRec( oWndBrw:oBrw, dbfAntCliT, {|| QuiAntCli() } ) );
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( DelSerie( oWndBrw ) );
         TOOLTIP  "Series" ;
         FROM     oDel ;
         CLOSED ;
         LEVEL    ACC_DELE

   DEFINE BTNSHELL oImp RESOURCE "IMP" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenAntCli( IS_PRINTER ) ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenAntCli( oWndBrw:oBrw, oImp, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF oWndBrw ;
      NOBORDER ;
      ACTION   PrnSerie();
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenAntCli( IS_SCREEN ), oWndBrw:Refresh() ) ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenAntCli( oWndBrw:oBrw, oPrv, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenAntCli( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenAntCli( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   /*
   DEFINE BTNSHELL oMail RESOURCE "GC_MAIL_EARTH_" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( GenAntCli( IS_MAIL ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

      lGenAntCli( oWndBrw:oBrw, oMail, IS_MAIL ) ;
   */

   DEFINE BTNSHELL RESOURCE "BMPCONTA" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( aGetSelRec( oWndBrw, {|lChk1, lChk2, oTree| ContabilizarAnticipos( lChk1, lChk2, oTree ) }, "Contabilizar anticipos", .f., "Simular resultados", .t., , , {|| oDiario() }, {|| cDiario() } ) ) ;
      TOOLTIP  "(C)ontabilizar" ;
      HOTKEY   "C";
      LEVEL    ACC_EDIT

   if lUsrMaster()

   DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw GROUP;
      NOBORDER ;
      ACTION   ( aGetSelRec( oWndBrw, {| lChk1, lChk2, oTree| CambiarEstado( lChk1, lChk2, oTree ) }, "Cambiar estado", .f., "Contabilizado", .t. ) ) ;
      TOOLTIP  "Cambiar es(t)ado" ;
      HOTKEY   "T";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw GROUP;
      NOBORDER ;
      ACTION   ( aGetSelRec( oWndBrw, {| lChk1, lChk2, oTree| CambiarLiquidado( lChk1, lChk2, oTree ) }, "Cambiar liquidación", .f., "Liquidación", .t. ) ) ;
      TOOLTIP  "Cambiar liquidación" ;
      LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oSnd RESOURCE "LBL" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      TOOLTIP  "En(v)iar" ;
      MESSAGE  "Seleccionar albaranes para ser enviados" ;
      ACTION   lSnd( oWndBrw, dbfAntCliT ) ;
      HOTKEY   "V";
      LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfAntCliT, "lSndDoc", .t., .t., .t. ) );
         TOOLTIP  "Todos" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfAntCliT, "lSndDoc", .f., .t., .t. ) );
         TOOLTIP  "Ninguno" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "LBL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( lSelectAll( oWndBrw, dbfAntCliT, "lSndDoc", .t., .f., .t. ) );
         TOOLTIP  "Abajo" ;
         FROM     oSnd ;
         CLOSED ;
         LEVEL    ACC_EDIT

   DEFINE BTNSHELL oBtnEur RESOURCE "gc_currency_euro_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEuro := !lEuro, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "gc_document_text_pencil_" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( Counter:OpenDialog() ) ;
      TOOLTIP  "Establecer contadores" 

   if oUser():lAdministrador()

      DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ReplaceCreator( oWndBrw, dbfAntCliT, aItmAntCli() ) ) ;
         TOOLTIP  "Cambiar campos" ;
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "GC_USER_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtCli( ( dbfAntCliT )->cCodCli ) );
         TOOLTIP  "Modificar cliente" ;
         FROM     oRotor ;
         CLOSED ;

      DEFINE BTNSHELL RESOURCE "INFO" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( InfCliente( ( dbfAntCliT )->cCodCli ) );
         TOOLTIP  "Informe de cliente" ;
         FROM     oRotor ;
         CLOSED ;

      DEFINE BTNSHELL RESOURCE "GC_CLIPBOARD_EMPTY_USER_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( EdtObras( ( dbfAntCliT )->cCodCli, ( dbfAntCliT )->cCodObr, dbfObrasT ) );
         TOOLTIP  "Modificar dirección" ;
         FROM     oRotor ;
         CLOSED ;

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_USER_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( if( !Empty( ( dbfAntCliT )->cNumDoc ), ZooFacCli( ( dbfAntCliT )->cNumDoc ), MsgStop( "Este documento no esta liquidado" ) ) );
         TOOLTIP  "Visualizar factura" ;
         FROM     oRotor ;
         CLOSED ;

   DEFINE BTNSHELL RESOURCE "END" OF oWndBrw ;
      ALLOW    EXIT ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if SQLAjustableModel():getRolNoFiltrarVentas( Auth():rolUuid() )
      oWndBrw:oActiveFilter:SetFields( aItmAntCli() )
      oWndBrw:oActiveFilter:SetFilterType( ANT_CLI )
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   if !Empty( cCodCli )
      oWndBrw:RecAdd()
      cCodCli        := {}
   end if

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfAntCliT, oBrw, cCodCli, bValid, nMode, cSerAnt )

   local oDlg
	local oFld
   local nOrd
   local oBrwInc
   local oBrwDoc
	local oFont
   local oSay        := Array( 8 )
   local cSay        := Array( 8 )
   local oRieCli
   local oBmpDiv
   local oGetMasDiv
   local cGetMasDiv  := ""
   local oGetSubCta
   local cGetSubCta  := ""
   local nRieCli     := 0
   local oBmpGeneral

   DEFAULT cCodCli   := nil
   DEFAULT cSerAnt   := cNewSer( "NANTCLI", dbfCount )

   do case
   case nMode == APPD_MODE

      if !lCurSesion()
         msgStop( "No hay sesiones activas, imposible añadir documentos" )
         Return .f.
      end if

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _CTURANT  ]    := cCurSesion()
      aTmp[ _CCODALM  ]    := oUser():cAlmacen()
      aTmp[ _CCODCAJ  ]    := oUser():cCaja()
      aTmp[ _CCODUSR  ]    := Auth():Codigo()
      aTmp[ _CCODPAGO ]    := cDefFpg()
      aTmp[ _CDIVANT  ]    := cDivEmp()
      aTmp[ _NVDVANT  ]    := nChgDiv( aTmp[ _CDIVANT ], dbfDiv )
      aTmp[ _CSUFANT  ]    := RetSufEmp()
      aTmp[ _LSNDDOC  ]    := .t.
      aTmp[ _CCODPRO  ]    := cProCnt()
      aTmp[ _LIVAINC  ]    := .t.
      aTmp[ _NPCTIVA  ]    := nIva( dbfIva, cDefIva() )
      aTmp[ _NREQ     ]    := nReq( dbfIva, cDefIva() )
      aTmp[ _CCODDLG  ]    := oUser():cDelegacion()

      if !Empty( cCodCli )
         aTmp[ _CCODCLI ]  := cCodCli
      end if

   case nMode == DUPL_MODE

      if !lCurSesion()
         msgStop( "No hay sesiones activas, imposible añadir documentos" )
         Return .f.
      end if

      if !lCajaOpen( oUser():cCaja() ) .and. !oUser():lAdministrador()
         msgStop( "Esta caja " + oUser():cCaja() + " esta cerrada." )
         Return .f.
      end if

      aTmp[ _DFECANT    ]  := GetSysDate()
      aTmp[ _LCLOANT    ]  := .f.
      aTmp[ _LSNDDOC    ]  := .t.
      aTmp[ _LLIQUIDADA ]  := .f.
      aTmp[ _CNUMDOC    ]  := ""

   case nMode == EDIT_MODE

      if aTmp[ _LLIQUIDADA ] .AND. !oUser():lAdministrador()
         msgStop( "No se pueden modificar las anticipos liquidados." )
         return .f.
      end if

      if aTmp[ _LCLOANT ] .AND. !oUser():lAdministrador()
         msgStop( "Solo puede modificar las anticipos cerradas los administradores." )
         return .f.
      end if

      if aTmp[ _LCONTAB ] .and.;
         !ApoloMsgNoYes( "La modificación de este anticipo puede provocar descuadres contables." + CRLF + "¿ Desea continuar ?", "Anticipo ya contabilizada" )
         return .f.
      end if

   end case

   /*
   Este valor los guaradamos para detectar los posibles cambios
   */

   cOldCodCli              := aTmp[ _CCODCLI ]

   cSay[ 2 ]               := RetFld( aTmp[ _CCODALM ], dbfAlmT )
   cSay[ 3 ]               := RetFld( aTmp[ _CCODAGE ], dbfAgent )
   cSay[ 4 ]               := RetFld( aTmp[ _CCODPAGO], dbfFPago )
   cSay[ 5 ]               := RetFld( aTmp[ _CCODCLI ] + aTmp[ _CCODOBR ], dbfObrasT, "cNomObr" )
   cSay[ 6 ]               := RetFld( aTmp[ _CCODCAJ ], dbfCajT )
   cSay[ 7 ]               := RetFld( cCodEmp() + aTmp[ _CCODDLG ], dbfDelega, "cNomDlg" )

   /*
   Necesitamos el orden el la primera clave
   */

   nOrd                    := ( dbfAntCliT )->( ordSetFocus( 1 ) )

   /*
   Valores por defecto
   */

   if Empty( Rtrim( aTmp[_CSERANT] ) )
      aTmp[ _CSERANT ]     := cSerAnt
   end if

   if Empty( aTmp[ _CDIVANT ] )
      aTmp[ _CDIVANT ]     := cDivEmp()
   end if

   if Empty( aTmp[ _CTLFCLI ] )
      aTmp[ _CTLFCLI ]     := RetFld( aTmp[ _CCODCLI ], dbfCli, "Telefono" )
   end if

   nRieCli                 := oStock:nRiesgo( aTmp[ _CCODCLI ] )

   /*
   Inicialización de variables
   */

   BeginTrans( aTmp, nMode )

   cPicUnd                 := MasUnd()                            // Picture de las unidades
   cPouDiv                 := cPouDiv( aTmp[ _CDIVANT ], dbfDiv ) // Picture de la divisa
   cPorDiv                 := cPorDiv( aTmp[ _CDIVANT ], dbfDiv ) // Picture de la divisa redondeada
   nDouDiv                 := nDouDiv( aTmp[ _CDIVANT ], dbfDiv ) // Decimales de la divisa
   nRouDiv                 := nRouDiv( aTmp[ _CDIVANT ], dbfDiv ) // Decimales de la divisa redondeada

   oFont                   := TFont():New( "Arial", 8, 26, .F., .T. )

   DEFINE DIALOG oDlg RESOURCE "AntCli" TITLE LblTitle( nMode ) + "anticipos a clientes"

		/*
		Define de los Folders
		------------------------------------------------------------------------
		*/

      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&Anticipo",;
                  "&Incidencias",;
                  "D&ocumentos" ;
         DIALOGS  "AntCli_1",;
                  "PedCli_3",;
                  "PedCli_4"

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_document_text_money2_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[1]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_information_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[2]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_address_book_48" ;
        TRANSPARENT ;
        OF       oFld:aDialogs[3]

      REDEFINE GET aGet[ _CSERANT ] VAR aTmp[ _CSERANT ] ;
         ID       100 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _CSERANT ] ) );
         ON DOWN  ( DwSerie( aGet[ _CSERANT ] ) );
         COLOR    CLR_GET ;
         WHEN     ( nMode == APPD_MODE .OR. nMode == DUPL_MODE );
         VALID    ( aTmp[_CSERANT] >= "A" .AND. aTmp[_CSERANT] <= "Z" ) ;
         OF       oFld:aDialogs[1]

         aGet[ _CSERANT ]:bLostFocus := {|| aTmp[ _CCODPRO ] := cProCnt( aTmp[ _CSERANT ] ) }

      REDEFINE GET aGet[_NNUMANT] VAR aTmp[_NNUMANT] ;
			ID 		110 ;
			PICTURE 	"999999999" ;
			WHEN 		.F. ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CSUFANT] VAR aTmp[_CSUFANT] ;
			ID       120 ;
			PICTURE  "@!" ;
			WHEN  	( .F. ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_DFECANT ] VAR aTmp[_DFECANT ] ;
			ID 		130 ;
			SPINNER ;
			COLOR 	CLR_GET ;
         ON HELP  aGet[_DFECANT]:cText( Calendario( aTmp[_DFECANT] ) ) ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      /*
      Cajas para mostrar el usuario
      */

      REDEFINE GET aGet[ _CCODUSR ] VAR aTmp[ _CCODUSR ];
         ID       115 ;
         WHEN     ( .f. ) ;
         VALID    ( SetUsuario( aGet[ _CCODUSR ], oSay[ 8 ], nil, dbfUsr ) );
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 8 ] VAR cSay[ 8 ] ;
         ID       116 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      /*
		Codigo de Divisas______________________________________________________________
		*/

      REDEFINE GET aGet[ _CDIVANT ] VAR aTmp[ _CDIVANT ];
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( cDivOut( aGet[ _CDIVANT ], oBmpDiv, aTmp[ _NVDVANT ], @cPouDiv, @nDouDiv, @cPorDiv, @nRouDiv, nil, nil, oGetMasDiv, dbfDiv, oBandera ) );
         PICTURE  "@!";
         ID       140 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVANT ], oBmpDiv, aTmp[ _NVDVANT ], dbfDiv, oBandera ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       141;
			OF 		oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[_LIVAINC] VAR aTmp[_LIVAINC] ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE );
         ON CHANGE( nRecTot( aTmp ) );
         OF       oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[_LLIQUIDADA] VAR aTmp[_LLIQUIDADA] ;
         ID       151 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _DLIQUIDADA ] VAR aTmp[ _DLIQUIDADA ] ;
         ID       152 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_CCODCLI] VAR aTmp[_CCODCLI] ;
         ID       160 ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( if( !Empty( aTmp[ _CCODCLI ] ), loaCli( aGet, aTmp, nMode, oRieCli ), .t. ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[_CCODCLI], aGet[_CNOMCLI] ), ::lValid() ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oRieCli VAR nRieCli;
         ID       161;
         WHEN     ( nMode != ZOOM_MODE );
         PICTURE  cPorDiv ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[_CNOMCLI] VAR aTmp[_CNOMCLI] ;
         ID       170;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         COLOR    CLR_GET ;
			OF 		oFld:aDialogs[1]

      if uFieldEmpresa( "nCifRut" ) == 1

      REDEFINE GET aGet[ _CDNICLI ] VAR aTmp[ _CDNICLI ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         VALID    ( CheckCif( aGet[ _CDNICLI ] ) );
         OF       oFld:aDialogs[ 1 ]

      else

      REDEFINE GET aGet[ _CDNICLI ] VAR aTmp[ _CDNICLI ] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         PICTURE  "@R 999999999-9" ;
         VALID    ( CheckRut( aGet[ _CDNICLI ] ) );
         OF       oFld:aDialogs[ 1 ]

      end if

      REDEFINE GET aGet[_CDIRCLI] VAR aTmp[_CDIRCLI] ;
         ID       190 ;
         BITMAP   "gc_earth_lupa_16" ;
         ON HELP  GoogleMaps( aTmp[ _CDIRCLI ], Rtrim( aTmp[ _CPOBCLI ] ) + Space( 1 ) + Rtrim( aTmp[ _CPRVCLI ] ) ) ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CPOSCLI] VAR aTmp[_CPOSCLI] ;
         ID       200;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPOBCLI ] VAR aTmp[ _CPOBCLI ] ;
         ID       210 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _CPRVCLI ] VAR aTmp[ _CPRVCLI ] ;
         ID       220 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]


      REDEFINE GET aGet[_CTLFCLI] VAR aTmp[_CTLFCLI] ;
         ID       225 ;
         COLOR    CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE .and. ( !aTmp[ _LMODCLI ] .or. oUser():lAdministrador() ) ) ;
         OF       oFld:aDialogs[1]

		/*
      Codigo de obra__________________________________________________________________
		*/

		REDEFINE GET aGet[_CCODOBR] VAR aTmp[_CCODOBR] ;
         ID       230 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cObras( aGet[_CCODOBR], oSay[ 5 ], aTmp[_CCODCLI] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( brwObras( aGet[_CCODOBR], oSay[ 5 ], aTmp[_CCODCLI], dbfObrasT ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 5 ] VAR cSay[ 5 ] ;
			WHEN 		.F. ;
         ID       231 ;
			OF 		oFld:aDialogs[1]

		/*
      Codigo de almacen________________________________________________________________
		*/

		REDEFINE GET aGet[_CCODALM] VAR aTmp[_CCODALM] ;
         ID       240 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( aGet[_CCODALM], dbfAlmT, oSay[ 2 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[_CCODALM], oSay[ 2 ] ) ) ;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 2 ] VAR cSay[ 2 ] ;
			WHEN 		.F. ;
         ID       241 ;
			OF 		oFld:aDialogs[1]

      /*
      Centro de coste____________________________________________________________________
      */

      REDEFINE GET aGet[ _CCENTROCOSTE ] VAR aTmp[ _CCENTROCOSTE ] ;
            ID       380 ;
            IDTEXT   381 ;
            BITMAP   "LUPA" ;
            VALID    ( oCentroCoste:Existe( aGet[ _CCENTROCOSTE ], aGet[ _CCENTROCOSTE ]:oHelpText, "cNombre" ) );
            ON HELP  ( oCentroCoste:Buscar( aGet[ _CCENTROCOSTE ] ) ) ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            OF       oFld:aDialogs[1]

		/*
      Formas de pago_____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODPAGO ] VAR aTmp[ _CCODPAGO ];
         ID       250 ;
			PICTURE 	"@!" ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE );
         VALID    ( cFPago( aGet[ _CCODPAGO ], dbfFPago, oSay[ 4 ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ _CCODPAGO ], oSay[ 4 ] ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 4 ] VAR cSay[ 4 ];
         ID       251 ;
         WHEN     .f. ;
			OF 		oFld:aDialogs[1]

		/*
      Codigo de Agente___________________________________________________________________
		*/

		REDEFINE GET aGet[_CCODAGE] VAR aTmp[_CCODAGE] ;
         ID       260 ;
			COLOR 	CLR_GET ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAgentes( aGet[_CCODAGE], dbfAgent, oSay[ 3 ], aGet[_NPCTCOMAGE], dbfAgeCom ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[_CCODAGE], oSay[ 3 ] ) );
			OF 		oFld:aDialogs[1]

      REDEFINE GET oSay[ 3 ] VAR cSay[ 3 ] ;
         ID       261 ;
			WHEN 		.F.;
			COLOR 	CLR_GET ;
			OF 		oFld:aDialogs[1]

		REDEFINE GET aGet[_NPCTCOMAGE] VAR aTmp[_NPCTCOMAGE] ;
			WHEN 		( !Empty( aTmp[_CCODAGE] ) .AND. nMode != ZOOM_MODE ) ;
			PICTURE	"@E 99.99" ;
         ID       270 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oGetAge VAR nTotAge ;
         ID       271 ;
         WHEN     ( nMode != ZOOM_MODE );
			OF 		oFld:aDialogs[1]

      /*
		Cajas____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], dbfCajT, oSay[ 6 ] ) ;
         ID       280 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oSay[ 6 ] ) ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 6 ] VAR cSay[ 6 ] ;
         ID       281 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[ _MDESCRIP ] VAR aTmp[ _MDESCRIP ];
         MEMO ;
         ID       290 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aGet[_CCTAPGO] VAR aTmp[_CCTAPGO] ;
         ID       350 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[_CCTAPGO], oGetSubCta ) ) ;
         VALID    ( MkSubcuenta( aGet[_CCTAPGO], nil, oGetSubCta ) );
         OF       oFld:aDialogs[1]

		REDEFINE GET oGetSubCta VAR cGetSubCta ;
         ID       351 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      /*
      Totales de anticipos
		------------------------------------------------------------------------
		*/

      REDEFINE GET aGet[ _NIMPART ] VAR aTmp[ _NIMPART ] ;
         ID       300 ;
         PICTURE  cPorDiv ;
         VALID    ( nRecTot( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _NPCTIVA ] VAR aTmp[ _NPCTIVA ] ;
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 99.99" ;
         VALID    ( lTiva( dbfIva, aTmp[ _NPCTIVA ], @aTmp[ _NPCTREQ ] ) .and. nRecTot( aTmp ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _NPCTIVA ], dbfIva, , .t. ) );
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetIva VAR nTotIva ;
         ID       311 ;
			OF 		oFld:aDialogs[1]

		REDEFINE CHECKBOX aGet[_LRECARGO] VAR aTmp[_LRECARGO] ;
         ID       320 ;
         ON CHANGE( nRecTot( aTmp ) );
         VALID    ( nRecTot( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetReq VAR nTotReq ;
         ID       321 ;
			OF 		oFld:aDialogs[1]

     REDEFINE GET aGet[ _NPCTRET ] VAR aTmp[ _NPCTRET ] ;
         ID       330 ;
         PICTURE  "@E 999.99" ;
         SPINNER;
         VALID    ( nRecTot( aTmp ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY oGetPctRet VAR nTotRet;
         ID       331 ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetMasDiv VAR cGetMasDiv;
         ID       340 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      REDEFINE SAY oGetTotal VAR nTotAnt ;
         ID       341 ;
			FONT 		oFont ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET aGet[ _CCODDLG ] VAR aTmp[ _CCODDLG ] ;
         ID       400 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET oSay[ 7 ] VAR cSay[ 7 ] ;
         ID       401 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      /*
      Incidencias______________________________________________________________
		*/

      oBrwInc                 := IXBrowse():New( oFld:aDialogs[ 2 ] )

      oBrwInc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwInc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwInc:cAlias          := dbfTmpInc

      oBrwInc:nMarqueeStyle   := 6
      oBrwInc:cName           := "Factura de cliente.Incidencia"

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Resuelta"
            :bStrData         := {|| "" }
            :bEditValue       := {|| ( dbfTmpInc )->lListo }
            :nWidth           := 70
            :SetCheck( { "Sel16", "Cnt16" } )
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Fecha"
            :bEditValue       := {|| Dtoc( ( dbfTmpInc )->dFecInc ) }
            :nWidth           := 100
         end with

         with object ( oBrwInc:AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| ( dbfTmpInc )->mDesInc }
            :nWidth           := 500
         end with

         if nMode != ZOOM_MODE
            oBrwInc:bLDblClick   := {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) }
         else
            oBrwInc:bLDblClick   := {|| WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) }
         end if

         oBrwInc:CreateFromResource( 210 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[ 2 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[ 2 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oFld:aDialogs[ 2 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) )

		REDEFINE BUTTON ;
			ID 		503 ;
         OF       oFld:aDialogs[ 2 ] ;
         ACTION   ( WinZooRec( oBrwInc, bEdtInc, dbfTmpInc ) )

      // Tercera caja de diálogo-----------------------------------------------

      oBrwDoc                 := IXBrowse():New( oFld:aDialogs[ 3 ] )

      oBrwDoc:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDoc:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDoc:cAlias          := dbfTmpDoc

      oBrwDoc:nMarqueeStyle   := 6
      oBrwDoc:nRowHeight      := 40
      oBrwDoc:nDataLines      := 2

      with object ( oBrwDoc:AddCol() )
         :cHeader          := "Documento"
         :bEditValue       := {|| Rtrim( ( dbfTmpDoc )->cNombre ) + CRLF + Space( 5 ) + Rtrim( ( dbfTmpDoc )->cRuta ) }
         :nWidth           := 960
      end with

      if nMode != ZOOM_MODE
         oBrwDoc:bLDblClick   := {|| ShellExecute( oDlg:hWnd, "open", Rtrim( ( dbfTmpDoc )->cRuta ) ) }
      end if

      oBrwDoc:CreateFromResource( 210 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oFld:aDialogs[ 3 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oFld:aDialogs[ 3 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oFld:aDialogs[ 3 ] ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .t. ) )

		REDEFINE BUTTON ;
			ID 		503 ;
         OF       oFld:aDialogs[ 3 ] ;
         ACTION   ( WinZooRec( oBrwDoc, bEdtDoc, dbfTmpDoc ) )

      REDEFINE BUTTON ;
         ID       504 ;
         OF       oFld:aDialogs[ 3 ] ;
         ACTION   ( ShellExecute( oDlg:hWnd, "open", rTrim( ( dbfTmpDoc )->cRuta ) ) )

      /*
		Fin de los Folders
		-----------------------------------------------------------------------
		*/

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, oBrw, nMode, nRouDiv, nTotAnt, oDlg ) )

      REDEFINE BUTTON ;
         ID       4 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( EndTrans( aTmp, aGet, oBrw, nMode, nRouDiv, nTotAnt, oDlg ), GenAntCli( IS_PRINTER ), ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   if nMode != ZOOM_MODE

      oFld:aDialogs[2]:AddFastKey( VK_F2, {|| WinAppRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwInc, bEdtInc, dbfTmpInc, nil, nil, aTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F4, {|| DbDelRec( oBrwInc, dbfTmpInc, nil, nil, .t. ) } )

      oFld:aDialogs[3]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDoc, bEdtDoc, dbfTmpDoc, nil, nil, aTmp ) } )
      oFld:aDialogs[3]:AddFastKey( VK_F4, {|| DbDelRec( oBrwDoc, dbfTmpDoc, nil, nil, .t. ) } )

      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, oBrw, nMode, nRouDiv, nTotAnt, oDlg ) } )
      oDlg:AddFastKey( VK_F6, {|| if( EndTrans( aTmp, aGet, oBrw, nMode, nRouDiv, nTotAnt, oDlg ), GenAntCli( IS_PRINTER ), ) } )
      oDlg:AddFastKey( VK_F9, {|| oDetCamposExtra:Play( space(1) ) } )

   end if

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) .and. lRecogerUsuario()
      oDlg:bStart := {|| if( lGetUsuario( aGet[ _CCODUSR ], dbfUsr ), , oDlg:End() ) }
   end if

   oDlg:bStart := {|| StartEdtRec( aGet, nMode ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT     ( EdtRecMenu( aTmp, oDlg ), nRecTot( aTmp, aGet ), oBrwInc:Load() ) ;
      CENTER

   EndEdtRecMenu()

   oFont:end()

   oBmpDiv:end()
   oBmpGeneral:End()

   /*
   Repos-----------------------------------------------------------------------
   */

   ( dbfAntCliT )->( ordSetFocus( nOrd ) )

   /*
   Salida sin grabar-----------------------------------------------------------
   */

   KillTrans()

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

Static Function StartEdtRec( aGet, nMode )

   if nMode != APPD_MODE

      if !empty( aGet[ _CCENTROCOSTE ] )
         aGet[ _CCENTROCOSTE ]:lValid()
      endif     

   endif
   
Return ( .t. )


Static Function EdtInc( aTmp, aGet, dbfAntCliI, oBrw, bWhen, bValid, nMode, aTmpFac )

   local oDlg

   if nMode == APPD_MODE
      aTmp[ _CSERANT  ] := aTmpFac[ _CSERANT ]
      aTmp[ _NNUMANT  ] := aTmpFac[ _NNUMANT ]
      aTmp[ _CSUFANT  ] := aTmpFac[ _CSUFANT ]
      if IsMuebles()
         aTmp[ ( dbfTmpInc )->( FieldPos( "lAviso" ) ) ]  := .t.
      end if
   end if

   DEFINE DIALOG oDlg RESOURCE "INCIDENCIA" TITLE LblTitle( nMode ) + "incidencias de anticipos a clientes"

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

//--------------------------------------------------------------------------//

Static Function EdtDoc( aTmp, aGet, dbfAntCliD, oBrw, bWhen, bValid, nMode, aTmpLin )

   local oDlg
   local oRuta
   local oNombre
   local oObservacion

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTOS" TITLE LblTitle( nMode ) + "documento de anticipos de clientes"

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

//--------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie()

	local oDlg
   local oFmtDoc
   local cFmtDoc     := cFormatoDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin   
   local cSerIni     := (dbfAntCliT)->CSERANT
   local cSerFin     := (dbfAntCliT)->CSERANT
   local nDocIni     := (dbfAntCliT)->NNUMANT
   local nDocFin     := (dbfAntCliT)->NNUMANT
   local cSufIni     := (dbfAntCliT)->CSUFANT
   local cSufFin     := (dbfAntCliT)->CSUFANT
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oRango
   local nRango      := 1
   local dFecDesde   := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dFecHasta   := Date()
   local oNumCop
   local nNumCop     := if( nCopiasDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount ) == 0, Max( Retfld( ( dbfAntCliT )->cCodCli, dbfCli, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount ) )

   if Empty( cFmtDoc )
      cFmtDoc        := cSelPrimerDoc( "TC" )
   end if

   cSayFmt           := cNombreDoc( cFmtDoc )

   DEFINE DIALOG oDlg RESOURCE "IMPSERIES" TITLE "Imprimir series de anticipos"

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
      OF       oDlg

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

   REDEFINE GET oPrinter VAR cPrinter;
         WHEN     ( .f. ) ;
         ID       160 ;
         OF       oDlg

   TBtnBmp():ReDefine( 161, "gc_printer2_check_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

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
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "TC" ) ) ;
      OF       oDlg

   REDEFINE GET oSayFmt VAR cSayFmt ;
      ID       91 ;
      WHEN     ( .f. );
      COLOR    CLR_GET ;
      OF       oDlg

   TBtnBmp():ReDefine( 92, "gc_document_text_pencil_12",,,,,{|| EdtDocumento( cFmtDoc ) }, oDlg, .f., , .f.,  )

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   (  StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, nNumCop, lInvOrden, lCopiasPre, nRango, dFecDesde, dFecHasta ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, nNumCop, lInvOrden, lCopiasPre, nRango, dFecDesde, dFecHasta ), oDlg:end( IDOK ) } )
   oDlg:bStart := { || oSerIni:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

	oWndBrw:oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, nCopPrn, lInvOrden, lCopiasPre, nRango, dFecDesde, dFecHasta )

   local nCopyClient
   local nRecno
   local nOrdAnt

   oDlg:disable()

   if nRango == 1

      nRecno      := ( dbfAntCliT )->( recno() )
      nOrdAnt     := ( dbfAntCliT )->( OrdSetFocus( "NNUMANT" ) )

      if !lInvOrden

         ( dbfAntCliT )->( dbSeek( cDocIni, .t. ) )

         while ( dbfAntCliT )->CSERANT + Str( ( dbfAntCliT )->NNUMANT ) + (dbfAntCliT)->CSUFANT >= cDocIni .AND. ;
               ( dbfAntCliT )->CSERANT + Str( ( dbfAntCliT )->NNUMANT ) + (dbfAntCliT)->CSUFANT <= cDocFin .AND. ;
               !( dbfAntCliT )->( Eof() )

            if lCopiasPre

               nCopyClient := if( nCopiasDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount ) == 0, Max( Retfld( ( dbfAntCliT )->cCodCli, dbfCli, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount ) )

               GenAntCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfAntCliT )->CSERANT + Str( ( dbfAntCliT )->NNUMANT ) + (dbfAntCliT)->CSUFANT, cFmtDoc, cPrinter, nCopyClient )

            else

               GenAntCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfAntCliT )->CSERANT + Str( ( dbfAntCliT )->NNUMANT ) + (dbfAntCliT)->CSUFANT, cFmtDoc, cPrinter, nCopPrn )

            end if

         ( dbfAntCliT )->( dbSkip() )

         end while

      else

         ( dbfAntCliT )->( dbSeek( cDocFin ) )

         while ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt ) + ( dbfAntCliT )->cSufAnt >= cDocIni .and.;
               ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt ) + ( dbfAntCliT )->cSufAnt <= cDocFin .and.;
               !( dbfAntCliT )->( Bof() )

            if lCopiasPre

               nCopyClient := if( nCopiasDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount ) == 0, Max( Retfld( ( dbfAntCliT )->cCodCli, dbfCli, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount ) )

               GenAntCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfAntCliT )->CSERANT + Str( ( dbfAntCliT )->NNUMANT ) + (dbfAntCliT)->CSUFANT, cFmtDoc, cPrinter, nCopyClient )

            else

               GenAntCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfAntCliT )->CSERANT + Str( ( dbfAntCliT )->NNUMANT ) + (dbfAntCliT)->CSUFANT, cFmtDoc, cPrinter, nCopPrn )

            end if

         ( dbfAntCliT )->( dbSkip( -1 ) )

         end while

      end if

   else

      nRecno      := ( dbfAntCliT )->( recno() )
      nOrdAnt     := ( dbfAntCliT )->( OrdSetFocus( "DFECANT" ) )

      if !lInvOrden

         ( dbfAntCliT )->( dbGoTop() )

         while !( dbfAntCliT )->( Eof() )

            if ( dbfAntCliT )->dFecAnt >= dFecDesde .and. ( dbfAntCliT )->dFecAnt <= dFecHasta

               if lCopiasPre

                  nCopyClient := if( nCopiasDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount ) == 0, Max( Retfld( ( dbfAntCliT )->cCodCli, dbfCli, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount ) )

                  GenAntCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfAntCliT )->CSERANT + Str( ( dbfAntCliT )->NNUMANT ) + (dbfAntCliT)->CSUFANT, cFmtDoc, cPrinter, nCopyClient )

               else

                  GenAntCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfAntCliT )->CSERANT + Str( ( dbfAntCliT )->NNUMANT ) + (dbfAntCliT)->CSUFANT, cFmtDoc, cPrinter, nCopPrn )

               end if

            end if   

         ( dbfAntCliT )->( dbSkip() )

         end while

      else

         ( dbfAntCliT )->( dbGoBottom() )

         while !( dbfAntCliT )->( Bof() )

            if ( dbfAntCliT )->dFecAnt >= dFecDesde .and. ( dbfAntCliT )->dFecAnt <= dFecHasta

               if lCopiasPre

                  nCopyClient := if( nCopiasDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount ) == 0, Max( Retfld( ( dbfAntCliT )->cCodCli, dbfCli, "CopiasF" ), 1 ), nCopiasDocumento( ( dbfAntCliT )->cSerAnt, "nAntCli", dbfCount ) )

                  GenAntCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfAntCliT )->CSERANT + Str( ( dbfAntCliT )->NNUMANT ) + (dbfAntCliT)->CSUFANT, cFmtDoc, cPrinter, nCopyClient )

               else

                  GenAntCli( IS_PRINTER, "Imprimiendo documento : " + ( dbfAntCliT )->CSERANT + Str( ( dbfAntCliT )->NNUMANT ) + (dbfAntCliT)->CSUFANT, cFmtDoc, cPrinter, nCopPrn )

               end if

            end if   

         ( dbfAntCliT )->( dbSkip( -1 ) )

         end while

      end if
   
   end if   

   ( dbfAntCliT )->( dbGoTo( nRecNo ) )
   ( dbfAntCliT )->( ordSetFocus( nOrdAnt ) )

   oDlg:enable()

RETURN NIL

//--------------------------------------------------------------------------//

Static Function RecalculaTotal( aTmp )

   nTotAntCli( dbfAntCliT, dbfIva, dbfDiv, aTmp, nil, .t. )

   /*
   Comision del Agente------------------------------------------------------
   */

   if oGetAge != nil
      oGetAge:SetText( Trans( nTotAge, cPorDiv ) )
   end if

   /*
   Base de la Anticipo------------------------------------------------------
   */

   if oGetNet != nil
      oGetNet:SetText( Trans( nTotNet, cPorDiv ) )
   end if

   if oGetIva != nil
      oGetIva:SetText( Trans( nTotIva, cPorDiv ) )
   end if

   if oGetReq != nil
      oGetReq:SetText( Trans( nTotReq, cPorDiv ) )
   end if

   if oGetPctRet != nil
      oGetPctRet:SetText( Trans( nTotRet, cPorDiv ) )
   end if

   if oGetTotal != nil
      oGetTotal:SetText( Trans( nTotAnt, cPorDiv ) )
   end if

Return ( nil )

//---------------------------------------------------------------------------//

/*
Cargaos los datos del cliente
*/

STATIC FUNCTION loaCli( aGet, aTmp, nMode, oRieCli )

   local lValid      := .t.
   local cNewCodCli  := aGet[ _CCODCLI ]:varGet()
   local lChgCodCli  := ( Empty( cOldCodCli ) .or. cOldCodCli != cNewCodCli )

   if Empty( cNewCodCli )
      Return .t.
   elseif At( ".", cNewCodCli ) != 0
      cNewCodCli     := PntReplace( aGet[ _CCODCLI ], "0", RetNumCodCliEmp() )
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   if ( dbfCli )->( dbSeek( cNewCodCli ) )

      if ( dbfCli )->lBlqCli  
         msgStop( "Cliente bloqueado, no se pueden realizar operaciones de venta" + CRLF + ;
                  "Motivo: " + AllTrim( ( dbfCli )->cMotBlq ),;
                  "Imposible archivar" )
         return .f.
      end if

      /*
      Si tenemos parcado en la empresa que mostremos el saldo pendiente del cliente
      */

      if uFieldEmpresa( "lSalPdt" ) .and. ( dbfCli )->Riesgo > 0
         if ( dbfCli )->nImpRie > ( dbfCli )->Riesgo
            msgStop( "El riesgo del cliente supera el límite establecido", "Riesgo: " + Trans( ( dbfCli )->nImpRie, "@E 999999.99" ) )
         end if
      end if

      /*
      Asignamos el codigo siempre
      */

      aGet[_CCODCLI]:cText( ( dbfCli )->Cod )

      /*
      Color de fondo del cliente
      */

      if ( dbfCli )->nColor != 0
         aGet[_CNOMCLI]:SetColor( , ( dbfCli )->nColor )
      end if

      if Empty( aGet[ _CNOMCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CNOMCLI ]:cText( ( dbfCli )->Titulo )
      end if

      if Empty( aGet[ _CTLFCLI ]:varGet() ) .or. lChgCodCli
         aGet[ _CTLFCLI ]:cText( ( dbfCli )->Telefono )
      end if

      if Empty( aGet[_CDIRCLI]:varGet() ) .or. lChgCodCli
         aGet[_CDIRCLI]:cText( ( dbfCli )->Domicilio )
      end if

      if Empty( aGet[_CPOBCLI]:varGet() ) .or. lChgCodCli
         aGet[_CPOBCLI]:cText( ( dbfCli )->Poblacion )
      end if

      if Empty( aGet[_CPRVCLI]:varGet() ) .or. lChgCodCli
         aGet[_CPRVCLI]:cText( ( dbfCli )->Provincia )
      end if

      if Empty( aGet[_CPOSCLI]:varGet() ) .or. lChgCodCli
         aGet[_CPOSCLI]:cText( ( dbfCli )->CodPostal )
      end if

      if Empty( aGet[_CDNICLI]:varGet() ) .or. lChgCodCli
         aGet[_CDNICLI]:cText( ( dbfCli )->Nif )
      end if

      if ( lChgCodCli )
         aTmp[ _LMODCLI ]  := ( dbfCli )->lModDat
      end if

      /*
      Cargamos la obra por defecto---------------------------------------------
      */

      if ( lChgCodCli ) .and. !Empty( aGet[ _CCODOBR ] )

         if dbSeekInOrd( cNewCodCli, "lDefObr", dbfObrasT )
            aGet[ _CCODOBR ]:cText( ( dbfObrasT )->cCodObr )
         else
            aGet[ _CCODOBR ]:cText( Space( 10 ) )
         end if

         aGet[ _CCODOBR ]:lValid()

      end if

      if nMode == APPD_MODE

         aTmp[_NREGIVA ]   := ( dbfCli )->nRegIva

         /*
         Si estamos a¤adiendo cargamos todos los datos del cliente
         */

         if !Empty( (dbfCli)->Serie )
            aGet[_CSERANT ]:cText( ( dbfCli )->Serie )
         end if

         if !Empty( (dbfCli)->cCodAlm )
            aGet[ _CCODALM]:cText( ( dbfCli )->cCodAlm )
            aGet[ _CCODALM]:lValid()
         end if

         if !Empty( ( dbfCli )->CodPago )

            aGet[ _CCODPAGO ]:cText( ( dbfCli )->CodPago )
            aGet[ _CCODPAGO ]:lValid()

            aGet[ _CCTAPGO  ]:cText( RetFld( ( dbfCli )->CodPago, dbfFPago, "cCtaCobro" ) )
            aGet[ _CCTAPGO  ]:lValid()

         end if

         if !Empty( ( dbfCli )->cAgente )
            aGet[ _CCODAGE ]:cText( ( dbfCli )->cAgente )
            aGet[ _CCODAGE ]:lValid()
         end if

         aGet[ _LRECARGO ]:Click( ( dbfCli )->lReq ):Refresh()

      end if

      if ( dbfCli )->lMosCom .and. !Empty( ( dbfCli )->mComent ) .and. lChgCodCli
         MsgStop( Trim( ( dbfCli )->mComent ) )
      end if

      if !Empty( oRieCli ) .and. lChgCodCli
         oStock:SetRiesgo( cNewCodCli, oRieCli, ( dbfCli )->Riesgo )
      end if

      ShowIncidenciaCliente( ( dbfCli )->Cod, nView )

      cOldCodCli  := ( dbfCli )->Cod

      lValid      := .t.

   else

		msgStop( "Cliente no encontrado" )

      lValid      := .f.

   end if

RETURN lValid

//----------------------------------------------------------------------------//

/*
Comienza la edición de la Anticipo
*/

STATIC FUNCTION BeginTrans( aTmp, nMode )

   local cFac     := aTmp[ _CSERANT ] + Str( aTmp[ _NNUMANT ] ) + aTmp[ _CSUFANT ]
   local cDbfInc  := "FCliI"
   local cDbfDoc  := "FCliD"

   cTmpInc        := cGetNewFileName( cPatTmp() + cDbfInc )
   cTmpDoc        := cGetNewFileName( cPatTmp() + cDbfDoc )

   /*
   Actualizacion de riesgo
   */

   do case
   case nMode == APPD_MODE .or. nMode == DUPL_MODE
      nTotOld     := 0

   case nMode == EDIT_MODE
      nTotOld     := nTotAnt

   end case

   /*
   Creamos la tabla temporal
   */

   dbCreate( cTmpInc, aSqlStruct( aIncAntCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpInc, cCheckArea( cDbfInc, @dbfTmpInc ), .f. )
   if !( dbfTmpInc )->( neterr() )
      ( dbfTmpInc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpInc )->( ordCreate( cTmpInc, "Recno", "Recno()", {|| Recno() } ) )
   end if

   dbCreate( cTmpDoc, aSqlStruct( aAntCliDoc() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpDoc, cCheckArea( cDbfDoc, @dbfTmpDoc ), .f. )
   if !( dbfTmpDoc )->( neterr() )
      ( dbfTmpDoc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpDoc )->( ordCreate( cTmpDoc, "Recno", "Recno()", {|| Recno() } ) )
   end if

   /*
   A¤adimos desde el fichero de incidencias
	*/

   if ( nMode != DUPL_MODE ) .and. ( dbfAntCliI )->( dbSeek( cFac ) )
      while ( ( dbfAntCliI )->cSerAnt + Str( ( dbfAntCliI )->nNumAnt ) + ( dbfAntCliI )->cSufAnt == cFac ) .and. ( dbfAntCliI )->( !eof() )
         dbPass( dbfAntCliI, dbfTmpInc, .t. )
         ( dbfAntCliI )->( dbSkip() )
      end while
   end if

   ( dbfTmpInc )->( dbGoTop() )

   /*
   A¤adimos desde el fichero de Documentos
	*/

   if ( nMode != DUPL_MODE ) .and. ( dbfAntCliD )->( dbSeek( cFac ) )
      while ( ( dbfAntCliD )->cSerAnt + Str( ( dbfAntCliD )->nNumAnt ) + ( dbfAntCliD )->cSufAnt == cFac ) .and. ( dbfAntCliD )->( !eof() )
         dbPass( dbfAntCliD, dbfTmpDoc, .t. )
         ( dbfAntCliD )->( dbSkip() )
      end while
   end if

   ( dbfTmpDoc )->( dbGoTop() )

   /*
   Cargamos los temporales de los campos extra---------------------------------
   */

   oDetCamposExtra:SetTemporal( aTmp[ _CSERANT ] + Str( aTmp[ _NNUMANT ] ) + aTmp[ _CSUFANT ], "", nMode )

RETURN NIL

//-----------------------------------------------------------------------//

/*
Finaliza la transacción de datos
*/

STATIC FUNCTION EndTrans( aTmp, aGet, oBrw, nMode, nDec, nTotal, oDlg )

	local aTabla
   local cSerFac
   local nNumAnt
   local cSufAnt

   if Empty( aTmp[ _CSERANT ] )
      aTmp[ _CSERANT ]  := "A"
   end if

   cSerFac              := aTmp[ _CSERANT ]
   nNumAnt              := aTmp[ _NNUMANT ]
   cSufAnt              := aTmp[ _CSUFANT ]

   /*
   Comprobamos la fecha del documento
   */

   if !lValidaOperacion( aTmp[ _DFECANT ] )
      Return .f.
   end if

   if !lValidaSerie( aTmp[ _CSERANT ] )
      Return .f.
   end if

   /*
   Estos campos no pueden estar vacios
   */

   if Empty( aTmp[ _CNOMCLI ] )
      msgStop( "Nombre de cliente no puede estar vacío." )
      aGet[ _CNOMCLI ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CDIRCLI ] )
      msgStop( "Domicilio de cliente no puede estar vacía." )
      aGet[ _CDIRCLI ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CDNICLI ] )
      msgStop( "D.N.I. / C.I.F. de cliente no puede estar vacío." )
      aGet[ _CDNICLI ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODALM ] )
      msgStop( "Almacén no puede estar vacío." )
      aGet[ _CCODALM ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODPAGO ] )
      msgStop( "Forma de pago no puede estar vacía." )
      aGet[ _CCODPAGO ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CDIVANT ] )
      MsgStop( "No puede almacenar documento sin código de divisa." )
      aGet[ _CDIVANT ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ _CCODAGE ] ) .and. lRecogerAgentes()
      msgStop( "Agente no puede estar vacío." )
      aGet[ _CCODAGE ]:SetFocus()
      return .f.
   end if

   /*
   Para q nadie toque mientras grabamos
   */

   oDlg:Disable()

   oMsgText( "Archivando" )

   aTmp[ _DFECCRE ]     := GetSysDate()
   aTmp[ _CTIMCRE ]     := Time()

   /*
   Primero hacer el RollBack---------------------------------------------------
   */

   do case
   case nMode == APPD_MODE .or. nMode == DUPL_MODE

		/*
      Obtenemos el nuevo numero de la Anticipo----------------------------------
		*/

      nNumAnt           := nNewDoc( aTmp[ _CSERANT ], dbfAntCliT, "NANTCLI", , dbfCount )
      aTmp[ _NNUMANT ]  := nNumAnt

   case nMode == EDIT_MODE

      /*
      Rollback de todas las incidencias
      */

      if nNumAnt != 0

         while ( dbfAntCliI )->( dbSeek( cSerFac + str( nNumAnt ) + cSufAnt ) )
            if dbLock( dbfAntCliI )
               ( dbfAntCliI )->( dbDelete() )
               ( dbfAntCliI )->( dbUnLock() )
            end if
         end while

         while ( dbfAntCliD )->( dbSeek( cSerFac + str( nNumAnt ) + cSufAnt ) )
            if dbLock( dbfAntCliD )
               ( dbfAntCliD )->( dbDelete() )
               ( dbfAntCliD )->( dbUnLock() )
            end if
         end while

      end if

   end case

   /*
   Actualizacion de riesgo-----------------------------------------------------
   */

   AddRiesgo( nTotAnt - nTotOld, aTmp[ _CCODCLI ], dbfCli )

   oMsgProgress()
   oMsgProgress():SetRange( 0, ( dbfTmpInc )->( LastRec() ) )

	/*
   Ahora escribimos en el fichero definitivo-----------------------------------
	*/

   ( dbfTmpInc )->( dbGoTop() )

   while ( dbfTmpInc )->( !eof() )

      dbPass( dbfTmpInc, dbfAntCliI, .t., cSerFac, nNumAnt, cSufAnt )

      ( dbfTmpInc )->( dbSkip() )

      oMsgProgress():Deltapos(1)

   end while

   ( dbfTmpDoc )->( dbGoTop() )

   while ( dbfTmpDoc )->( !eof() )

      dbPass( dbfTmpDoc, dbfAntCliD, .t., cSerFac, nNumAnt, cSufAnt )

      ( dbfTmpDoc )->( dbSkip() )

      oMsgProgress():Deltapos(1)

   end while

   aTmp[ _NREQ ]           := nPReq( dbfIva, aTmp[ _NPCTIVA ] )

   /*
   Rellenamos los campos de totales--------------------------------------------
   */

   aTmp[ _NTOTNET ]  := nTotNet
   aTmp[ _NTOTIVA ]  := nTotIva
   aTmp[ _NTOTREQ ]  := nTotReq
   aTmp[ _NTOTANT ]  := nTotAnt

   /*
   Guardamos los campos extra-----------------------------------------------
   */

   oDetCamposExtra:saveExtraField( aTmp[ _CSERANT ] + Str( aTmp[ _NNUMANT ] ) + aTmp[ _CSUFANT ], "" )

   /*
   Grabamos el registro--------------------------------------------------------
   */

   WinGather( aTmp, , dbfAntCliT, , nMode )

	/*
	Borramos los ficheros
	*/

   dbfErase( cTmpInc )

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   oMsgText()
   EndProgress()

   /*
   Apertura de la caja---------------------------------------------------------
   */

   if nMode == APPD_MODE .or. nMode == DUPL_MODE
      oUser():OpenCajonDirect( nView ) // OpnCaj()
   end if

   oDlg:Enable()
   oDlg:End( IDOK )

Return .t.

//------------------------------------------------------------------------//

Static Function KillTrans()

	/*
	Borramos los ficheros
	*/

   if !Empty( dbfTmpInc ) .and. ( dbfTmpInc )->( Used() )
      ( dbfTmpInc )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpDoc ) .and. ( dbfTmpDoc )->( Used() )
      ( dbfTmpDoc )->( dbCloseArea() )
   end if

   dbfTmpInc      := nil
   dbfTmpDoc      := nil

   dbfErase( cTmpInc )
   dbfErase( cTmpDoc )

RETURN NIL

//------------------------------------------------------------------------//

Function AppAntCli( cCodCli, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_APPD ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacAntCli( nil, nil, cCodCli )
         oWndBrw:RecAdd()
      end if

   else

      if OpenFiles( .t. )
         WinAppRec( nil, bEdtRec, dbfAntCliT, cCodCli )
         CloseFiles()
      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Function EdtAntCli( cNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacAntCli()
         if dbSeekInOrd( cNumFac, "nNumAnt", dbfAntCliT )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra anticipo" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumAnt", dbfAntCliT )
            WinEdtRec( nil, bEdtRec, dbfAntCliT )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ZooAntCli( cNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacAntCli()
         if dbSeekInOrd( cNumFac, "nNumAnt", dbfAntCliT )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra anticipo" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( cNumFac, "nNumAnt", dbfAntCliT )
            WinZooRec( nil, bEdtRec, dbfAntCliT )
         end if
         CloseFiles()
      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION DelAntCli( cNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacAntCli()
         if dbSeekInOrd( cNumFac, "nNumAnt", dbfAntCliT )
            WinDelRec( nil, dbfAntCliT, {|| QuiAntCli() } )
         else
            MsgStop( "No se encuentra anticipo" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumAnt", dbfAntCliT )
            WinDelRec( nil, dbfAntCliT, {|| QuiAntCli() } )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PrnAntCli( cNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacAntCli()
         if dbSeekInOrd( cNumFac, "nNumAnt", dbfAntCliT )
            GenAntCli( IS_PRINTER )
         else
            MsgStop( "No se encuentra anticipo" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumAnt", dbfAntCliT )
            GenAntCli( IS_PRINTER )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION VisAntCli( cNumFac, lOpenBrowse )

   local nLevel         := Auth():Level( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if FacAntCli()
         if dbSeekInOrd( cNumFac, "nNumAnt", dbfAntCliT )
            GenAntCli( IS_SCREEN )
         else
            MsgStop( "No se encuentra anticipo" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumAnt", dbfAntCliT )
            GenAntCli( IS_SCREEN )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//--------------------------------------------------------------------------//

static function lGenAntCli( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if !( dbfDoc )->( dbSeek( "TC" ) )

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF oWndBrw ;
            NOBORDER ;
            ACTION   ( msgStop( "No hay anticipos de clientes predefinidas" ) );
            TOOLTIP  "No hay documentos" ;
            HOTKEY   "N";
            FROM     oBtn ;
            CLOSED ;
            LEVEL    ACC_EDIT

   ELSE

      WHILE ( dbfDoc )->CTIPO == "TC" .AND. !( dbfDoc )->( eof() )

         bAction  := bGenAntCli( nDevice, "Imprimiendo anticipos de clientes", ( dbfDoc )->CODIGO )

         oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ( dbfDoc )->cDescrip ) , , , , , oBtn )

         ( dbfDoc )->( dbSkip() )

      END DO

   END IF

   SysRefresh()

return nil

//---------------------------------------------------------------------------//

static function bGenAntCli( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev  := by( nDevice )
   local cTit  := by( cTitle  )
   local cCod  := by( cCodDoc )

   if nDev == IS_PRINTER
      bGen     := {|| GenAntCli( nDev, cTit, cCod ) }
   else
      bGen     := {|| GenAntCli( nDev, cTit, cCod ) }
   end if

return ( bGen )

//---------------------------------------------------------------------------//

/*
Selecciona todos los registros
*/

STATIC FUNCTION lSelAll( oBrw, dbf, lSel )

   local nRecAct  := ( dbf )->( recno() )

   DEFAULT lSel   := .t.

   CursorWait()

   ( dbf )->( dbGoTop() )

   while !( dbf )->( eof() )

      if ( dbf )->( dbRLock() )
         ( dbf )->lSndDoc  := lSel
         ( dbf )->( dbUnlock() )
      end if

      ( dbf )->( dbSkip() )

   end do

   ( dbf )->( dbGoTo( nRecAct ) )

   oBrw:SetFocus()
   oBrw:Refresh()

   CursorWe()

RETURN NIL

//---------------------------------------------------------------------------//

static function QuiAntCli()

   local nOrdAnt
   local cSerDoc     := ( dbfAntCliT )->cSerAnt
   local nNumDoc     := ( dbfAntCliT )->nNumAnt
   local cSufDoc     := ( dbfAntCliT )->cSufAnt

   if ( dbfAntCliT )->lCloAnt .and. !oUser():lAdministrador()
      msgStop( "Solo puede eliminar anticipos cerradas los administradores." )
      return .f.
   end if

   /*
   Elimino las incidencias-----------------------------------------------------
   */

   nOrdAnt     := ( dbfAntCliI )->( OrdSetFocus( "nNumAnt" ) )

   while ( dbfAntCliI )->( dbSeek( cSerDoc + Str( nNumDoc ) + cSufDoc ) ) .and. !( dbfAntCliI )->( eof() )
      if dbDialogLock( dbfAntCliI )
         ( dbfAntCliI )->( dbDelete() )
         ( dbfAntCliI )->( dbUnLock() )
      end if

      ( dbfAntCliI )->( dbSkip() )
   end do

   ( dbfAntCliI )->( OrdSetFocus( nOrdAnt ) )

   /*
   Elimino los documentos------------------------------------------------------
   */

   nOrdAnt     := ( dbfAntCliD )->( OrdSetFocus( "nNumAnt" ) )

   while ( dbfAntCliD )->( dbSeek( cSerDoc + Str( nNumDoc ) + cSufDoc ) ) .and. !( dbfAntCliD )->( eof() )
      if dbDialogLock( dbfAntCliD )
         ( dbfAntCliD )->( dbDelete() )
         ( dbfAntCliD )->( dbUnLock() )
      end if

      ( dbfAntCliD )->( dbSkip() )
   end do

   ( dbfAntCliD )->( OrdSetFocus( nOrdAnt ) )

   /*
   Actualizamos los riesgos de clientes
   */

   DelRiesgo( nTotAnt, ( dbfAntCliT )->cCodCli, dbfCli )

return .t.

//--------------------------------------------------------------------------//

FUNCTION aDocAntCli()

   local aDoc  := {}

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Anticipos",       "TC" } )
   aAdd( aDoc, { "Cliente",         "CL" } )
   aAdd( aDoc, { "Almacen",         "AL" } )
   aAdd( aDoc, { "Obras",           "OB" } )
   aAdd( aDoc, { "Rutas",           "RT" } )
   aAdd( aDoc, { "Agentes",         "AG" } )
   aAdd( aDoc, { "Divisas",         "DV" } )
   aAdd( aDoc, { "Formas de pago",  "PG" } )

RETURN ( aDoc )

//---------------------------------------------------------------------------//

function aCalAntCli()

   local aCalAntCli  := {}

   aAdd( aCalAntCli, { "nTotNet",   "N", 16,  6, "Total neto",                  "cPorDivAnt",  "!Empty( nTotNet ) .and. lEnd" } )
   aAdd( aCalAntCli, { "nTotIva",   "N", 16,  6, "Total " + cImp(),                "cPorDivAnt",  "!Empty( nTotIva ) .and. lEnd" } )
   aAdd( aCalAntCli, { "nTotReq",   "N", 16,  6, "Total R.E.",                  "cPorDivAnt",  "!Empty( nTotReq ) .and. lEnd" } )
   aAdd( aCalAntCli, { "nTotImp",   "N", 16,  6, "Total impuestos",             "cPorDivAnt",  "!Empty( nTotImp ) .and. lEnd" } )
   aAdd( aCalAntCli, { "nTotAnt",   "N", 16,  6, "Total anticipos",             "cPorDivAnt",  "!Empty( nTotAnt ) .and. lEnd" } )
   aAdd( aCalAntCli, { "nPagina",   "N",  2,  0, "Número de página",            "'99'",         "" }                            )
   aAdd( aCalAntCli, { "lEnd",      "L",  1,  0, "Fin del documento",           "",             "" }                            )

return ( aCalAntCli )

//---------------------------------------------------------------------------//

function aColAntCli()

   local aColAntCli  := {}

   aAdd( aColAntCli, { "mDescrip",  "M", 10,  0, "Descripción",                 "" ,           "",                            "( cDbfCol )"} )
   aAdd( aColAntCli, { "nTotNet",   "N", 16,  6, "Total neto",                  "cPorDivAnt",  "!Empty( nTotNet ) .and. lEnd","" } )
   aAdd( aColAntCli, { "nTotIva",   "N", 16,  6, "Total " + cImp(),                "cPorDivAnt",  "!Empty( nTotIva ) .and. lEnd","" } )
   aAdd( aColAntCli, { "nTotReq",   "N", 16,  6, "Total R.E.",                  "cPorDivAnt",  "!Empty( nTotReq ) .and. lEnd","" } )
   aAdd( aColAntCli, { "nTotImp",   "N", 16,  6, "Total impuestos",             "cPorDivAnt",  "!Empty( nTotReq ) .and. lEnd","" } )
   aAdd( aColAntCli, { "nTotAnt",   "N", 16,  6, "Total anticipos",             "cPorDivAnt",  "!Empty( nTotAnt ) .and. lEnd","" } )
   aAdd( aColAntCli, { "nPagina",   "N",  2,  0, "Número de página",            "'99'",        "",                            "" } )
   aAdd( aColAntCli, { "lEnd",      "L",  1,  0, "Fin del documento",           "",            "",                            "" } )

return ( aColAntCli )

//---------------------------------------------------------------------------//

Static Function nRecTot( aTmp, aGet )

   if !Empty( aGet )
      if ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) )
         aGet[ _LRECARGO ]:HardEnable()
      else
         aGet[ _LRECARGO ]:HardDisable()
      end if
   end if

   RecalculaTotal( aTmp )

Return .t.

//--------------------------------------------------------------------------//

Static Function ShowInci( dbfTmpInc, cCodCli, dbfClient )

   while !( dbfTmpInc )->( Eof() )
      if ( dbfTmpInc )->lAviso .and. !( dbfTmpInc )->lListo
         MsgInfo( Trim( ( dbfTmpInc )->mDesInc ), "¡Incidencia!" )
      end if
      ( dbfTmpInc )->( dbSkip() )
   end while

   ( dbfTmpInc )->( dbGoTop() )

Return .t.

//--------------------------------------------------------------------------//

FUNCTION BrwAntCli( cCodCli, dbfAntCliT, dbfIva, dbfDiv, dbfTmpA, oBrwAnt )

	local oDlg
	local oBrw
   local nOrd        := GetBrwOpt( "BrwAntCli" )
   local oGet1
   local cGet1
   local oCbxOrd
   local aStaAnt
   local aCbxOrd     := { "Número", "Fecha", "Código", "Nombre" }
   local aNomOrd     := { "lNumAnt", "lFecAnt", "lCodCli", "lNomCli" }
   local cCbxOrd
   local oBtnSelect
   local oBtnUnSelect

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   aStaAnt           := aGetStatus( dbfAntCliT, .t. )

   /*
   Seleccionamos los q traiga del temporal-------------------------------------
   */

   ( dbfTmpA )->( dbGoTop() )
   while !( dbfTmpA )->( Eof() )
      if ( dbfAntCliT )->( dbSeek( ( dbfTmpA )->cSerAnt + Str( ( dbfTmpA )->nNumAnt ) + ( dbfTmpA )->cSufAnt ) )
         if dbLock( dbfAntCliT )
            ( dbfAntCliT )->lSelDoc := .t.
            ( dbfAntCliT )->( dbUnLock() )
         end if
      end if
      ( dbfTmpA )->( dbSkip() )
   end while

   ( dbfAntCliT )->( OrdSetFocus( aNomOrd[ nOrd ] ) )
   ( dbfAntCliT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE 'Seleccionar anticipos de clientes'

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfAntCliT ) );
         VALID    ( if( empty( cGet1 ), OrdClearScope( oBrw, dbfAntCliT ), ), .t. );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfAntCliT )->( OrdSetFocus( aNomOrd[ oCbxOrd:nAt ] ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }
      oBrw:bLDblClick      := {|| lSelAnt( dbfAntCliT, nil, oBrw ) }

      oBrw:cAlias          := dbfAntCliT
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Anticipos"

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Sl. Seleccionado"
         :bEditValue       := {|| ( dbfAntCliT )->lSelDoc }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :cSortOrder       := "lNumAnt"
         :bEditValue       := {|| ( dbfAntCliT )->cSerAnt + "/" + Alltrim( Str( ( dbfAntCliT )->nNumAnt ) ) + "/" + ( dbfAntCliT )->cSufAnt }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :cSortOrder       := "lFecAnt"
         :bEditValue       := {|| ( dbfAntCliT )->dFecAnt }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "lCodCli"
         :bEditValue       := {|| ( dbfAntCliT )->cCodCli }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "lNomCli"
         :bEditValue       := {|| ( dbfAntCliT )->cNomCli }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotAntCli( dbfAntCliT, dbfIva, dbfDiv, nil, cDivEmp(), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      REDEFINE BUTTON oBtnSelect ;
			ID 		500 ;
			OF 		oDlg ;
         ACTION   ( lSelAnt( dbfAntCliT, .t., oBrw ) )

      REDEFINE BUTTON oBtnUnSelect ;
			ID 		501 ;
			OF 		oDlg ;
         ACTION   ( lSelAnt( dbfAntCliT, .f., oBrw ) )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER ;
         ON INIT  ( SetWindowText( oBtnSelect:hWnd, "&Seleccionar" ), SetWindowText( oBtnUnSelect:hWnd, "&Deseleccionar" ) )

   SetBrwOpt( "BrwAntCli", oCbxOrd:nAt )

   /*
   Guardamos los vales en la tabla temporal------------------------------------
   */

   if oDlg:nResult == IDOK

      ( dbfTmpA )->( __dbZap() )

      ( dbfAntCliT )->( dbGoTop() )
      while !( dbfAntCliT )->( eof() )
         if ( dbfAntCliT )->lSelDoc
            dbPass( dbfAntCliT, dbfTmpA, .t. )
            if dbLock( dbfAntCliT )
               ( dbfAntCliT )->lSelDoc := .f.
               ( dbfAntCliT )->( dbUnLock() )
            end if
         end if
         ( dbfAntCliT )->( dbSkip() )
      end while

      ( dbfTmpA )->( dbGoTop() )

   end if

   if oBrwAnt != nil
      oBrwAnt:Refresh()
   end if

   /*
   Repos-----------------------------------------------------------------------
   */

   SetStatus( dbfAntCliT, aStaAnt )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function lSelAnt( dbfAntCliT, lSel, oBrw )

   DEFAULT lSel   := !( dbfAntCliT )->lSelDoc

   if dbLock( dbfAntCliT )
      ( dbfAntCliT )->lSelDoc := lSel
      ( dbfAntCliT )->( dbUnLock() )
   end if

   oBrw:DrawSelect()

Return nil

//---------------------------------------------------------------------------//

FUNCTION nNetAntFacCli( cFactura, dbfAntCliT, dbfIva, dbfDiv, cDivRet, lPic )

   local nRec
   local nOrd
   local cPorDiv
   local cCodDiv
   local nRouDiv           := 2
   local nTotAnt           := 0

   DEFAULT lPic            := .f.

   do case
      case IsNil( cFactura )

         cCodDiv           := ( dbfAntCliT )->cDivAnt
         cPorDiv           := cPorDiv( cCodDiv, dbfDiv ) // Picture de la divisa redondeada
         nRouDiv           := nRouDiv( cCodDiv, dbfDiv )

         nRec              := ( dbfAntCliT )->( Recno() )

         ( dbfAntCliT )->( dbGoTop() )
         while !( dbfAntCliT )->( eof() )
            nTotAnt        += nNetAntCli( dbfAntCliT, dbfIva, dbfDiv )
            ( dbfAntCliT )->( dbSkip() )
         end while

         ( dbfAntCliT )->( dbGoTo( nRec ) )

      case !Empty( cFactura )

         nRec              := ( dbfAntCliT )->( Recno() )
         nOrd              := ( dbfAntCliT )->( OrdSetFocus( "cNumDoc" ) )

         if ( dbfAntCliT )->( dbSeek( cFactura ) )
            while ( ( dbfAntCliT )->cNumDoc == cFactura .and. !( dbfAntCliT )->( eof() ) )
               nTotAnt     += nNetAntCli( dbfAntCliT, dbfIva, dbfDiv )
               ( dbfAntCliT )->( dbSkip() )
            end while
         end if

         ( dbfAntCliT )->( OrdSetFocus( nOrd ) )
         ( dbfAntCliT )->( dbGoTo( nRec ) )

   end case

   if cDivRet != nil .and. cCodDiv != cDivRet
      nTotAnt              := nCnv2Div( nTotAnt, cCodDiv, cDivRet )
      cPorDiv              := cPorDiv( cDivRet, dbfDiv ) // Picture de la divisa redondeada
      nRouDiv              := nRouDiv( cDivRet, dbfDiv )
   end if

   nTotAnt                 := Round( nTotAnt, nRouDiv )

   if lPic
      nTotAnt              := Trans( nTotAnt, cPorDiv )
   end if

RETURN ( nTotAnt )

//---------------------------------------------------------------------------//

/*
Devuelve el numero de anticipo
*/

Function cNumAnt( cNumFac, dbfAntCliT )

   local cNumAnt  := ""
   local nOrd     := ( dbfAntCliT )->( OrdSetFocus( "cNumDoc" ) )

   if ( dbfAntCliT )->( dbSeek( cNumFac ) )
      cNumAnt     := ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt ) + ( dbfAntCliT )->cSufAnt
   end if

   ( dbfAntCliT )->( OrdSetFocus( nOrd ) )

Return ( cNumAnt )

//---------------------------------------------------------------------------//

STATIC FUNCTION aGetSelRec( oBrw, bAction, cTitle, lHide1, cTitle1, lHide2, cTitle2, bPreAction, bPostAction )

   local oDlg
   local oRad
   local nRad        := 1
   local aRet        := {}
   local oTree
   local oChk1
   local oChk2
   local lChk1       := .t.
   local lChk2       := .t.
   local nRecno      := ( dbfAntCliT )->( Recno() )
   local nOrdAnt     := ( dbfAntCliT )->( OrdSetFocus( 1 ) )
   local oSerIni
   local oSerFin
   local cSerIni     := ( dbfAntCliT )->cSerAnt
   local cSerFin     := ( dbfAntCliT )->cSerAnt
   local oDocIni
   local oDocFin
   local nDocIni     := ( dbfAntCliT )->nNumAnt
   local nDocFin     := ( dbfAntCliT )->nNumAnt
   local oSufIni
   local oSufFin
   local cSufIni     := ( dbfAntCliT )->cSufAnt
   local cSufFin     := ( dbfAntCliT )->cSufAnt
   local oMtrInf
   local nMtrInf
   local lFechas     := .t.
   local dDesde      := CtoD( "01/01/" + Str( Year( Date() ) ) )
   local dHasta      := Date()
   local oImageList
   local oBtnCancel

   DEFAULT cTitle    := ""
   DEFAULT lHide1    := .f.
   DEFAULT cTitle1   := ""
   DEFAULT lHide2    := .f.
   DEFAULT cTitle2   := ""

   oImageList        := TImageList():New( 16, 16 )
   oImageList:AddMasked( TBitmap():Define( "gc_delete_12" ),    Rgb( 255, 0, 255 ) )
   oImageList:AddMasked( TBitmap():Define( "gc_check_12" ),  Rgb( 255, 0, 255 ) )

   DEFINE DIALOG oDlg RESOURCE "SelectRango" TITLE cTitle

   REDEFINE RADIO oRad VAR nRad ;
      ID       80, 81 ;
      OF       oDlg

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       100 ;
      PICTURE  "@!" ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      WHEN     ( oRad:nOption == 2 ) ;
      VALID    ( cSerIni >= "A" .and. cSerIni <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE BTNBMP ;
      ID       101 ;
      OF       oDlg ;
      RESOURCE "Up16" ;
      NOBORDER ;
      ACTION   ( dbFirst( dbfAntCliT, "nNumAnt", oDocIni, cSerIni, "nNumAnt" ) )

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       110 ;
      PICTURE  "@!" ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      WHEN     ( oRad:nOption == 2 ) ;
      VALID    ( cSerFin >= "A" .and. cSerFin <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE BTNBMP ;
      ID       111 ;
      OF       oDlg ;
      RESOURCE "Down16" ;
      NOBORDER ;
      ACTION   ( dbLast( dbfAntCliT, "nNumAnt", oDocFin, cSerFin, "nNumAnt" ) )

   REDEFINE GET oDocIni VAR nDocIni;
      ID       120 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET oDocFin VAR nDocFin;
      ID       130 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET oSufIni VAR cSufIni ;
      ID       140 ;
      PICTURE  "##" ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET oSufFin VAR cSufFin ;
      ID       150 ;
      PICTURE  "##" ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE CHECKBOX oChk1 VAR lChk1 ;
      ID       160 ;
		OF 		oDlg

   REDEFINE CHECKBOX oChk2 VAR lChk2 ;
      ID       180 ;
		OF 		oDlg

   /*
   Rango de fechas-------------------------------------------------------------
   */

   REDEFINE CHECKBOX lFechas ;
      ID       300 ;
		OF 		oDlg

   REDEFINE GET dDesde ;
      ID       310 ;
      WHEN     ( !lFechas ) ;
      SPINNER ;
      OF       oDlg

	REDEFINE GET dHasta ;
      ID       320 ;
      WHEN     ( !lFechas ) ;
      SPINNER ;
      OF       oDlg

   /*
   Resultados del proceso------------------------------------------------------
   */

   oTree             := TTreeView():Redefine( 170, oDlg )
   oTree:bLDblClick  := {|| TreeChanged( oTree ) }

   REDEFINE APOLOMETER oMtrInf;
      VAR      nMtrInf ;
      PROMPT   "Proceso" ;
      ID       200 ;
      OF       oDlg

   oMtrInf:SetTotal( ( dbfAntCliT )->( OrdKeyCount() ) )

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( MakSelRec( bAction, cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, bPreAction, bPostAction, nRad, lChk1, lChk2, lFechas, dDesde, dHasta, oDlg, dbfAntCliT, oTree, oBrw, oMtrInf, oBtnCancel ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:bStart := {|| StartGetSelRec( oBrw, oRad, oChk1, oChk2, oSerIni, oSerFin, oDocIni, oDocFin, oSufIni, oSufFin, lHide1, lHide2, cTitle1, cTitle2 ) }

   ACTIVATE DIALOG oDlg ;
      CENTER ;
      ON INIT  ( oTree:SetImageList( oImageList ) )

   ( dbfAntCliT )->( ordSetFocus( nOrdAnt ) )
   ( dbfAntCliT )->( dbGoTo( nRecNo ) )

   oImageList:End()

   oTree:Destroy()

   oBrw:SetFocus()
   oBrw:Refresh()

RETURN ( aRet )

//---------------------------------------------------------------------------//

Static Function StartGetSelRec( oBrw, oRad, oChk1, oChk2, oSerIni, oSerFin, oDocIni, oDocFin, oSufIni, oSufFin, lHide1, lHide2, cTitle1, cTitle2 )

   if !Empty( oBrw ) .and. ( len( oBrw:oBrw:aSelected ) > 1 )

      oRad:SetOption( 1 )

   else

      oRad:SetOption( 2 )

      oSerIni:Enable()
      oSerFin:Enable()
      oDocIni:Enable()
      oDocFin:Enable()
      oSufIni:Enable()
      oSufFin:Enable()

   end if

   if lHide1
      oChk1:Hide()
   else
      SetWindowText( oChk1:hWnd, cTitle1 )
      oChk1:Refresh()
   end if

   if lHide2
      oChk2:Hide()
   else
      SetWindowText( oChk2:hWnd, cTitle2 )
      oChk2:Refresh()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function TreeChanged( oTree )

   local oItemTree   := oTree:GetItem()

   if !Empty( oItemTree ) .and. !Empty( oItemTree:bAction )
      Eval( oItemTree:bAction )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Static Function MakSelRec( bAction, cDocIni, cDocFin, bPreAction, bPostAction, nRad, lChk1, lChk2, lFechas, dDesde, dHasta, oDlg, dbfAntCliT, oTree, oBrw, oMtrInf, oBtnCancel )

   local n        := 0
   local nPos     := 0
   local nRec     := ( dbfAntCliT )->( Recno() )
   local aPos
   local lRet
   local lPre
   local lWhile   := .t.


   /*
   Preparamos la pantalla para mostrar la simulación---------------------------
   */

   if lChk1
      aPos        := { 0, 0 }
      ClientToScreen( oDlg:hWnd, aPos )
      oDlg:Move( aPos[ 1 ] - 26, aPos[ 2 ] - 510 )
   end if

   /*
   Desabilitamos el dialogo para iniciar el proceso----------------------------
   */

   oDlg:Disable()

   oTree:Enable()
   oTree:DeleteAll()

   oBtnCancel:bAction   := {|| lWhile := .f. }
   oBtnCancel:Enable()

   if !Empty( bPreAction )
      lPre              := Eval( bPreAction )
   end if

   if !IsLogic( lPre ) .or. lPre

      if ( nRad == 1 )

         for each nPos in ( oBrw:oBrw:aSelected )

            ( dbfAntCliT )->( dbGoTo( nPos ) )

            if lFechas .or.( ( dbfAntCliT )->dFecFac >= dDesde .and. ( dbfAntCliT )->dFecFac <= dHasta )

               lRet  := Eval( bAction, lChk1, lChk2, oTree, dbfAntCliT )

               if IsFalse( lRet )
                  exit
               end if

            end if

            oMtrInf:Set( ++n )

            SysRefresh()

            if !lWhile
               exit
            end if

         next

      else

         ( dbfAntCliT )->( dbSeek( cDocIni, .t. ) )

         while ( lWhile )                                                                                         .and. ;
               ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt, 9 ) + ( dbfAntCliT )->cSufAnt >= cDocIni   .and. ;
               ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt, 9 ) + ( dbfAntCliT )->cSufAnt <= cDocFin   .and. ;
               !( dbfAntCliT )->( eof() )

            if lFechas .or.( ( dbfAntCliT )->dFecFac >= dDesde .and. ( dbfAntCliT )->dFecFac <= dHasta )

               lRet  := Eval( bAction, lChk1, lChk2, oTree, dbfAntCliT )

               if IsFalse( lRet )
                  exit
               end if

            end if

            oMtrInf:Set( ++n )

            ( dbfAntCliT )->( dbSkip() )

            SysRefresh()

         end do

      end if

      if !Empty( bPostAction )
         Eval( bPostAction )
      end if

   end if

   oMtrInf:Set( ( dbfAntCliT )->( LastRec() ) )

   ( dbfAntCliT )->( dbGoTo( nRec ) )

   if lChk1
      WndCenter( oDlg:hWnd ) // Move( aPos[ 1 ], aPos[ 2 ] + 200 )
   end if

   oBtnCancel:bAction   := {|| oDlg:End() }

   oDlg:Enable()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

// Realiza asientos en Contaplus, partiendo de la factura

STATIC FUNCTION ContabilizarAnticipos( lSimula, lPago, oTree )

	local nReq
   local cIva
   local cReq
	local dFecha
	local cConcepto
	local cPago
	local cSubCtaIva
	local cSubCtaReq
   local cCodEmp
   local cRuta
   local aSimula        := {}
   local cCodDiv        := ( dbfAntCliT )->cDivAnt
   local cCtaCli        := cCliCta( ( dbfAntCliT )->cCodCli, dbfCli )
   local cCtaAnticipo   := cCtaAnt()
   local cCtaPgo
   local nFactura       := ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt ) + ( dbfAntCliT )->cSufAnt
   local cFactura       := ( dbfAntCliT )->cSerAnt + Alltrim( Str( ( dbfAntCliT )->nNumAnt ) )
   local cCodPro        := ( dbfAntCliT )->cCodPro
   local aTotalAnt      := aTotAntCli( dbfAntCliT, dbfIva, dbfDiv )
   local nTotalNet      := aTotalAnt[ 1 ]
   local nTotalIva      := aTotalAnt[ 2 ]
   local nTotalReq      := aTotalAnt[ 3 ]
   local nTotalAnt      := aTotalAnt[ 5 ]
   local nAsiento       := 0
   local lErrorFound    := .f.
   local nIva
   local cTerNif        := ( dbfAntCliT )->cDniCli
   local cTerNom        := ( dbfAntCliT )->cNomCli
   local lReturn

   DEFAULT lSimula      := .t.
   DEFAULT aSimula      := {}

	/*
	Chequando antes de pasar a Contaplus
	--------------------------------------------------------------------------
	*/

   if ( dbfAntCliT )->lContab
      oTree:Select( oTree:Add( "Factura : " + rtrim( cFactura ) + " contabilizada.", 0 ) )
      lErrorFound       := .t.
   end if

   if !ChkRuta( cRutCnt() )
      oTree:Select( oTree:Add( "Factura : " + rtrim( cFactura ) + " ruta no valida.", 0 ) )
      lErrorFound       := .t.
   end if

   /*
   Seleccionamos las empresa dependiendo de la serie de factura
	--------------------------------------------------------------------------
	*/

   cRuta                := cRutCnt()
   cCodEmp              := cCodEmpCnt( ( dbfAntCliT )->cSerAnt )

   if empty( cCodEmp )
      oTree:Select( oTree:Add("Factura : " + rtrim( cFactura ) + " no se definierón empresas asociadas.", 0 ) )
      lErrorFound       := .t.
   end if

   /*
   Preparamos los apuntes de cliente
   --------------------------------------------------------------------------
   */

   if Empty( cCtaCli )
      cCtaCli  := cCtaSin()
   end if

   if !ChkSubcuenta( cRuta, cCodEmp, cCtaCli, , .f., .f. )
      oTree:Select( oTree:Add("Factura : " + cFactura + " subcuenta de cliente " + cCtaCli + " no encontada.", 0 ) )
      lErrorFound       := .t.
   end if

   if !ChkSubcuenta( cRuta, cCodEmp, cCtaAnticipo, , .f., .f. )
      oTree:Select( oTree:Add("Factura : " + cFactura + " subcuenta de anticipo " + Rtrim( cCtaAnticipo ) + " no encontada.", 0 ) )
      lErrorFound       := .t.
   end if

   /*
	Comprobamos fechas
	--------------------------------------------------------------------------
	*/

   if !ChkFecha( , , ( dbfAntCliT )->dFecAnt, .f., oTree )
      lErrorFound       := .t.
   end if

   /*
   Chequeo de Cuentas de impuestos
	--------------------------------------------------------------------------
	*/

   nIva        := ( dbfAntCliT )->nPctIva
   cIva        := RJust( ( dbfAntCliT )->nPctIva, "0", 2 )

   if ( dbfAntCliT )->lRecargo
      nReq     := ( dbfAntCliT )->nPctReq

      if nReq  < 1
         nReq  := nReq * 10
      end if

      cReq     := RJust( nReq, "0", 2 )
   else
      cReq     := "00"
   end if

   if lIvaReq()
      cSubCtaIva  := cIva + cReq
   else
      cSubCtaIva  := cReq + cIva
   end if

   cSubCtaIva     := RetCtaEsp( 2 ) + RJust( cSubCtaIva, "0", nLenCuentaContaplus( cRuta, cCodEmp ) )

   if !ChkSubcuenta( cRutCnt(), cCodEmp, cSubCtaIva, , .f., .f. )
      oTree:Select( oTree:Add( "Factura : " + rtrim( cFactura ) + " subcuenta de " + cImp() + cSubCtaIva + " no encontada.", 0 ) )
      lErrorFound       := .t.
   end if

	/*
	Chequeo de Cuentas de Recargo de Eqivalencia
	--------------------------------------------------------------------------
	*/

   if ( dbfAntCliT )->lRecargo

      nReq     := ( dbfAntCliT )->nPctReq

      if nReq  < 1
         nReq  := nReq * 10
      end if

      cSubCtaReq        := RetCtaEsp( 3 ) + RJust( nReq, "0", nLenCuentaContaplus( cRuta, cCodEmp ) )

      if !ChkSubcuenta( cRutCnt(), cCodEmp, cSubCtaReq, , .f., .f. )
         oTree:Select( oTree:Add( "Factura : " + cFactura + " subcuenta de recargo " + Rtrim( cSubCtaReq ) + " no encontada.", 0 ) )
         lErrorFound    := .t.
      end if

   end if

   /*
   Cuenta de pago--------------------------------------------------------------
   */

   if !Empty( ( dbfAntCliT )->cCtaPgo )
      cCtaPgo           := ( dbfAntCliT )->cCtaPgo
   else
      cCtaPgo           := cCtaFPago( ( dbfAntCliT )->cCodPago, dbfFPago )
   end if

   if Empty( cCtaPgo )
      cCtaPgo  := cCtaCob()
   end if

   if !ChkSubcuenta( cRutCnt(), cCodEmp, cCtaPgo, , .f., .f. )
      oTree:Select( oTree:Add("Factura : " + Rtrim( cFactura ) + " subcuenta de cobro " + Rtrim( cCtaPgo ) + " no encontada.", 0 ) )
      lErrorFound       := .t.
   end if

	/*
	Datos comunes a todos los Asientos
	--------------------------------------------------------------------------
	*/

   dFecha               := ( dbfAntCliT )->dFecAnt

   cConcepto            := "N/Ant. N." + cFactura
   cPago                := "C/Ant. N." + cFactura

	/*
   Realización de Asientos
	--------------------------------------------------------------------------
   */

   if OpenDiario( , cCodEmp )
      nAsiento          := contaplusUltimoAsiento()
   else
      oTree:Select( oTree:Add( "Factura : " + Rtrim( cFactura ) + " imposible abrir ficheros.", 0 ) )
      Return .f.
   end if

   /*
   Asiento de cliente----------------------------------------------------------
   */

   aadd( aSimula, MkAsiento(  nAsiento,;
                              cCodDiv,;
                              dFecha,;
                              cCtaCli,;
                              ,;
                              nTotalAnt,;
                              cConcepto,;
                              ,;
                              cFactura,;
                              ,;
                              ,;
                              ,;
                              ,;
                              cCodPro,;
                              ,;
                              ,;
                              ,;
                              ,;
                              lSimula,;
                              cTerNif,;
                              cTerNom ) )

	/*
	Asientos de Ventas
	-------------------------------------------------------------------------
	*/

   aadd( aSimula, MkAsiento(  nAsiento,;
                              cCodDiv,;
                              dFecha,;
                              cCtaAnticipo,;
                              ,;
                              ,;
                              cConcepto,;
                              nTotalNet,;
                              cFactura,;
                              ,;
                              ,;
                              ,;
                              ,;
                              cCodPro,;
                              ,;
                              ,;
                              ,;
                              ,;
                              lSimula,;
                              cTerNif,;
                              cTerNom ) )

	/*
   Asientos de impuestos
	--------------------------------------------------------------------------
	*/

   aadd( aSimula, MkAsiento(  nAsiento, ;
                              cCodDiv, ;
                              dFecha, ;
                              cSubCtaIva,;   // Cuenta de impuestos
                              cCtaCli,;      // Contrapartida
                              ,;             // Ptas. Debe
                              cConcepto,;
                              nTotalIva,;    // Ptas. Haber
                              cFactura,;
                              nTotalNet,;    // Base Imponible
                              nIva,;
                              nTotalReq,;
                              ,;
                              cCodPro,;
                              ,;
                              ,;
                              ,;
                              ,;
                              lSimula,;
                              cTerNif,;
                              cTerNom ) )

	/*
	Asientos del Recargo
	-------------------------------------------------------------------------
	*/

   if ( dbfAntCliT )->lRecargo .and. nTotalReq != 0

      aadd( aSimula, MkAsiento(  nAsiento,;
                                 cCodDiv,;
                                 dFecha,;
                                 cSubCtaReq,;
                                 ,;
                                 ,;
                                 cConcepto,;
                                 nTotalReq,;
                                 cFactura,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 cCodPro,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 lSimula,;
                                 cTerNif,;
                                 cTerNom ) )

   end if

   /*
   Asiento de cliente----------------------------------------------------------
   */

   aadd( aSimula, MkAsiento(  nAsiento,;
                              cCodDiv,;
                              dFecha,;
                              cCtaCli,;
                              ,;
                              ,;
                              cConcepto,;
                              nTotalAnt,;
                              cFactura,;
                              ,;
                              ,;
                              ,;
                              ,;
                              cCodPro,;
                              ,;
                              ,;
                              ,;
                              ,;
                              lSimula,;
                              cTerNif,;
                              cTerNom ) )

   /*
   Asiento de pago-------------------------------------------------------------
   */

   aadd( aSimula, MkAsiento(  nAsiento,;
                              cCodDiv,;
                              dFecha,;
                              cCtaPgo,;
                              ,;
                              nTotalAnt,;
                              cConcepto,;
                              ,;
                              cFactura,;
                              ,;
                              ,;
                              ,;
                              ,;
                              cCodPro,;
                              ,;
                              ,;
                              ,;
                              ,;
                              lSimula,;
                              cTerNif,;
                              cTerNom ) )

   /*
	Ponemos la factura como Contabilizada
	--------------------------------------------------------------------------
	*/

   if !lSimula .and. !lErrorFound

      lReturn  := CambiarEstado( .t., nAsiento, cFactura, oTree )

   else

      lReturn  := msgTblCon( aSimula, cCodDiv, dbfDiv, !lErrorFound, cFactura, {|| aWriteAsiento( aSimula, cCodDiv, .t., oTree, cFactura, nAsiento ), CambiarEstado( .t., nAsiento, cFactura, oTree ) } )

   end if

   CloseDiario()

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

RETURN ( lReturn )

//---------------------------------------------------------------------------//

Static Function CambiarEstado( lContab, nAsiento, cFactura, oTree )

   local lReturn  := .t.

   if ( dbfAntCliT )->( dbRLock() )
      ( dbfAntCliT )->lContab := lContab
      ( dbfAntCliT )->( dbUnlock() )

      if !Empty( oTree )
         oTree:Select( oTree:Add( "Factura : " + cFactura + " asiento generado num. " + Alltrim( Str( nAsiento ) ), 1 ) )
      end if

   else

      lReturn     := .f.

   end if

RETURN ( lReturn )

//-------------------------------------------------------------------------//

Static function CambiarLiquidado( lContab )

   if ( dbfAntCliT )->( dbRLock() )
      ( dbfAntCliT )->lLiquidada := lContab
      ( dbfAntCliT )->( dbUnlock() )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Static Function GotoFacturaCliente()

   if !Empty( ( dbfAntCliT )->cNumDoc )
      if oUser():lAdministrador()
         EdtFacCli( ( dbfAntCliT )->cNumDoc )
      else
         ZooFacCli( ( dbfAntCliT )->cNumDoc )
      end if
   else
      msgStop( "Este documento no esta liquidado" )
   end if

Return nil

//---------------------------------------------------------------------------//

Function CreateAntCli( cCodCli )

   local nLevel   := Auth():Level( _MENUITEM_ )

   if nAnd( nLevel, 1 ) == 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if !OpenFiles()
      CloseFiles()
      return nil
   end if

   WinAppRec( nil, bEdtRec, dbfAntCliT, cCodCli )

   if oBrw != NIL
      oBrw:Refresh()
   end if

   CloseFiles()

return nil

//---------------------------------------------------------------------------//
// Devuelve el total de anticipos de un clientes determinado

function nCobAntCli( cCodCli, dbfAntCli, dbfIva, dbfDiv, nYear, dFecIni, dFecFin )

   local nCon        := 0
   local nOrd        := ( dbfAntCli )->( OrdSetFocus( "CCODCLI" ) )
   local nRec        := ( dbfAntCli )->( Recno() )

   /*
   Facturas a Clientes -------------------------------------------------------
   */

   if ( dbfAntCli )->( dbSeek( cCodCli ) )

      while ( dbfAntCli )->cCodCli = cCodCli .and. !( dbfAntCli )->( Eof() )

         if !( dbfAntCli )->lLiquidada .and.;
            ( nYear == nil .or. Year( ( dbfAntCli )->dFecAnt ) == nYear ) .and.;
            ( dFecIni == nil .or. ( dbfAntCli )->dFecAnt >= dFecIni ) .and.;
            ( dFecFin == nil .or. ( dbfAntCli )->dFecAnt <= dFecFin )

            nCon     += nTotAntCli( dbfAntCli, dbfIva, dbfDiv )

         end if

         ( dbfAntCli )->( dbSkip() )

         SysRefresh()

      end while

   end if

   ( dbfAntCli )->( OrdSetFocus( nOrd ) )
   ( dbfAntCli )->( dbGoTo( nRec ) )

return nCon

//---------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         if !lExternal

         MENU

            MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra para la familia" ;
               RESOURCE "gc_form_plus2_16" ;
               ACTION   ( oDetCamposExtra:Play( space(1) ) )

            MENUITEM    "&2. Visualizar factura";
               MESSAGE  "Visualiza la factura que lo liquida" ;
               RESOURCE "gc_document_empty_16" ;
               ACTION   ( if( !Empty( aTmp[ _CNUMDOC ] ), ZooFacCli( aTmp[ _CNUMDOC ] ), MsgStop( "Este documento no esta liquidado" ) ) );

            SEPARATOR

            MENUITEM    "&3. Modificar cliente";
               MESSAGE  "Modifica la ficha del cliente" ;
               RESOURCE "gc_user_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&4. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) );

            MENUITEM    "&5. Modificar dirección";
               MESSAGE  "Modifica ficha de la dirección" ;
               RESOURCE "gc_worker2_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODOBR ] ), EdtObras( aTmp[ _CCODCLI ], aTmp[ _CCODOBR ], dbfObrasT ), MsgStop( "Código de obra vacío" ) ) );


         ENDMENU

         end if

   ENDMENU

   oDlg:SetMenu( oMenu )

RETURN ( oMenu )

//---------------------------------------------------------------------------//

Static Function EndEdtRecMenu()

Return( oMenu:End() )

//---------------------------------------------------------------------------//

STATIC FUNCTION DelSerie( oWndBrw )

	local oDlg
   local oSerIni
   local oSerFin
   local oTxtDel
   local nTxtDel     := 0
   local nRecno      := ( dbfAntCliT )->( Recno() )
   local nOrdAnt     := ( dbfAntCliT )->( OrdSetFocus( 1 ) )
   local oDesde      := TDesdeHasta():Init( ( dbfAntCliT )->cSerAnt, ( dbfAntCliT )->nNumAnt, ( dbfAntCliT )->cSufAnt, GetSysDate() )
   local lCancel     := .f.
   local oBtnAceptar
   local oBtnCancel

   DEFINE DIALOG oDlg ;
      RESOURCE "DELSERDOC" ;
      TITLE    "Eliminar series de anticipos" ;
      OF       oWndBrw

   REDEFINE RADIO oDesde:nRadio ;
      ID       90, 91 ;
      OF       oDlg

   REDEFINE GET oSerIni VAR oDesde:cSerieInicio ;
      ID       100 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      WHEN     ( oDesde:nRadio == 1 );
      VALID    ( oDesde:cSerieInicio >= "A" .and. oDesde:cSerieInicio <= "Z"  );
      OF       oDlg

   REDEFINE GET oSerFin VAR oDesde:cSerieFin ;
      ID       110 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      WHEN     ( oDesde:nRadio == 1 );
      VALID    ( oDesde:cSerieFin >= "A" .and. oDesde:cSerieFin <= "Z"  );
      OF       oDlg

   REDEFINE GET oDesde:nNumeroInicio ;
      ID       120 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      WHEN     ( oDesde:nRadio == 1 );
      OF       oDlg

   REDEFINE GET oDesde:nNumeroFin ;
      ID       130 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      WHEN     ( oDesde:nRadio == 1 );
      OF       oDlg

   REDEFINE GET oDesde:cSufijoInicio ;
      ID       140 ;
      PICTURE  "##" ;
      WHEN     ( oDesde:nRadio == 1 );
      OF       oDlg

   REDEFINE GET oDesde:cSufijoFin ;
      ID       150 ;
      PICTURE  "##" ;
      WHEN     ( oDesde:nRadio == 1 );
      OF       oDlg

   REDEFINE GET oDesde:dFechaInicio ;
      ID       170 ;
      SPINNER ;
      WHEN     ( oDesde:nRadio == 2 );
      OF       oDlg

   REDEFINE GET oDesde:dFechaFin ;
      ID       180 ;
      SPINNER ;
      WHEN     ( oDesde:nRadio == 2 );
      OF       oDlg

   REDEFINE BUTTON oBtnAceptar ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( DelStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDel, @lCancel ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( lCancel := .t., oDlg:end() )

 REDEFINE APOLOMETER oTxtDel VAR nTxtDel ;
      ID       160 ;
      NOPERCENTAGE ;
      TOTAL    ( dbfAntCliT )->( OrdKeyCount() ) ;
      OF       oDlg

   ACTIVATE DIALOG oDlg CENTER VALID ( lCancel )

   ( dbfAntCliT )->( dbGoTo( nRecNo ) )
   ( dbfAntCliT )->( ordSetFocus( nOrdAnt ) )

   oWndBrw:SetFocus()
   oWndBrw:Refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION DelStart( oDesde, oDlg, oBtnAceptar, oBtnCancel, oTxtDel, lCancel )

   local nOrd
   local nDeleted       := 0
   local nProcesed      := 0

   oBtnAceptar:Hide()
   oBtnCancel:bAction   := {|| lCancel := .t. }

   if oDesde:nRadio == 1

      nOrd              := ( dbfAntCliT )->( OrdSetFocus( "nNumAnt" ) )

      ( dbfAntCliT )->( dbSeek( oDesde:cNumeroInicio(), .t. ) )
      while !lCancel .and. ( dbfAntCliT )->( !eof() )

         if ( dbfAntCliT )->cSerAnt >= oDesde:cSerieInicio  .and.;
            ( dbfAntCliT )->cSerAnt <= oDesde:cSerieFin     .and.;
            ( dbfAntCliT )->nNumAnt >= oDesde:nNumeroInicio .and.;
            ( dbfAntCliT )->nNumAnt <= oDesde:nNumeroFin    .and.;
            ( dbfAntCliT )->cSufAnt >= oDesde:cSufijoInicio .and.;
            ( dbfAntCliT )->cSufAnt <= oDesde:cSufijoFin

            ++nDeleted

            oTxtDel:cText  := "Eliminando : " + ( dbfAntCliT )->cSerAnt + "/" + Alltrim( Str( ( dbfAntCliT )->nNumAnt ) ) + "/" + ( dbfAntCliT )->cSufAnt

            WinDelRec( nil, dbfAntCliT, {|| QuiAntCli() } )

         else

            ( dbfAntCliT )->( dbSkip() )

         end if

         ++nProcesed

         oTxtDel:Set( nProcesed )

      end do

      ( dbfAntCliT )->( OrdSetFocus( nOrd ) )

   else

      nOrd              := ( dbfAntCliT )->( OrdSetFocus( "dFecAnt" ) )

      ( dbfAntCliT )->( dbSeek( oDesde:dFechaInicio, .t. ) )
      while !lCancel .and. ( dbfAntCliT )->( !eof() )

         if ( dbfAntCliT )->dFecAnt >= oDesde:dFechaInicio  .and.;
            ( dbfAntCliT )->dFecAnt <= oDesde:dFechaFin

            ++nDeleted

            oTxtDel:cText  := "Eliminando : " + ( dbfAntCliT )->cSerAnt + "/" + Alltrim( Str( ( dbfAntCliT )->nNumAnt ) ) + "/" + ( dbfAntCliT )->cSufAnt

            WinDelRec( nil, dbfAntCliT, {|| QuiAntCli() } )

         else

            ( dbfAntCliT )->( dbSkip() )

         end if

         ++nProcesed

         oTxtDel:Set( nProcesed )

      end do

      ( dbfAntCliT )->( OrdSetFocus( nOrd ) )

   end if

   lCancel              := .t.

   oBtnAceptar:Show()

   if lCancel
      msgStop( "Total de registros borrados : " + Str( nDeleted ), "Proceso cancelado" )
   else
      msgInfo( "Total de registros borrados : " + Str( nDeleted ), "Proceso finalizado" )
   end if

RETURN ( oDlg:End() )

//---------------------------------------------------------------------------//

Static Function nEstadoIncidencia( cNumAnt )

   local nEstado  := 0
   local aBmp     := ""

   if ( dbfAntCliI )->( dbSeek( cNumAnt ) )

      while ( dbfAntCliI )->cSerAnt + Str( ( dbfAntCliI )->nNumAnt ) + ( dbfAntCliI )->cSufAnt == cNumAnt .and. !( dbfAntCliI )->( Eof() )

         if ( dbfAntCliI )->lListo
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

         ( dbfAntCliI )->( dbSkip() )

      end while

   end if

Return ( nEstado )

//---------------------------------------------------------------------------//

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Facturas anticipos", ( dbfAntCliT )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Facturas anticipos", cItemsToReport( aItmAntCli() ) )

   oFr:SetWorkArea(     "Incidencias de facturas anticipos", ( dbfAntCliI )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de facturas anticipos", cItemsToReport( aIncAntCli() ) )

   oFr:SetWorkArea(     "Documentos de facturas anticipos", ( dbfAntCliD )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de facturas anticipos", cItemsToReport( aAntCliDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( dbfCli )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Obras", ( dbfObrasT )->( Select() ) )
   oFr:SetFieldAliases( "Obras",  cItemsToReport( aItmObr() ) )

   oFr:SetWorkArea(     "Almacenes", ( dbfAlmT )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Agentes", ( dbfAgent )->( Select() ) )
   oFr:SetFieldAliases( "Agentes", cItemsToReport( aItmAge() ) )

   oFr:SetWorkArea(     "Formas de pago", ( dbfFpago )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetMasterDetail( "Facturas anticipos", "Incidencias de facturas anticipos", {|| ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt ) + ( dbfAntCliT )->cSufAnt } )
   oFr:SetMasterDetail( "Facturas anticipos", "Documentos de facturas anticipos",  {|| ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt ) + ( dbfAntCliT )->cSufAnt } )
   oFr:SetMasterDetail( "Facturas anticipos", "Empresa",                 {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Facturas anticipos", "Clientes",                {|| ( dbfAntCliT )->cCodCli } )
   oFr:SetMasterDetail( "Facturas anticipos", "Obras",                   {|| ( dbfAntCliT )->cCodCli + ( dbfAntCliT )->cCodObr } )
   oFr:SetMasterDetail( "Facturas anticipos", "Almacenes",               {|| ( dbfAntCliT )->cCodAlm } )
   oFr:SetMasterDetail( "Facturas anticipos", "Agentes",                 {|| ( dbfAntCliT )->cCodAge } )
   oFr:SetMasterDetail( "Facturas anticipos", "Formas de pago",          {|| ( dbfAntCliT )->cCodPago } )

   oFr:SetResyncPair(   "Facturas anticipos", "Incidencias de facturas anticipos" )
   oFr:SetResyncPair(   "Facturas anticipos", "Documentos de facturas anticipos" )
   oFr:SetResyncPair(   "Facturas anticipos", "Empresa" )
   oFr:SetResyncPair(   "Facturas anticipos", "Clientes" )
   oFr:SetResyncPair(   "Facturas anticipos", "Obras" )
   oFr:SetResyncPair(   "Facturas anticipos", "Almacenes" )
   oFr:SetResyncPair(   "Facturas anticipos", "Rutas" )
   oFr:SetResyncPair(   "Facturas anticipos", "Agentes" )
   oFr:SetResyncPair(   "Facturas anticipos", "Formas de pago" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Facturas anticipos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Facturas anticipos",             "Total factura",                      "GetHbVar('nTotAnt')" )
   oFr:AddVariable(     "Facturas anticipos",             "Total neto",                         "GetHbVar('nTotNet')" )
   oFr:AddVariable(     "Facturas anticipos",             "Total " + cImp(),                          "GetHbVar('nTotIva')" )
   oFr:AddVariable(     "Facturas anticipos",             "Total RE",                           "GetHbVar('nTotReq')" )
   oFr:AddVariable(     "Facturas anticipos",             "Total impuestos",                    "GetHbVar('nTotImp')" )
   oFr:AddVariable(     "Facturas anticipos",             "Total retención",                    "GetHbVar('nTotRet')" )
   oFr:AddVariable(     "Facturas anticipos",             "Total agente",                       "GetHbVar('nTotAge')" )
   oFr:AddVariable(     "Facturas anticipos",             "Cuenta por defecto del cliente",     "GetHbVar('cCtaCli')" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportAntCli( oFr, dbfDoc )

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

      oFr:SetFileName(        "Editando facturas de anticipo" )

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      else

         oFr:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )
         oFr:SetProperty(     "Report.ScriptText", "Text",;
                                                   + ;
                                                   "procedure DetalleOnMasterDetail(Sender: TfrxComponent);"   + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "CallHbFunc('nTotAntCli');"                                 + Chr(13) + Chr(10) + ;
                                                   "end;"                                                      + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "end." )

         oFr:AddPage(         "MainPage" )

         oFr:SetProperty(     "MainPage",          "OnBeforePrint", "DetalleOnMasterDetail" )

         oFr:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
         oFr:SetProperty(     "CabeceraDocumento", "Top", 0 )
         oFr:SetProperty(     "CabeceraDocumento", "Height", 200 )

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 200 )
         oFr:SetProperty(     "MasterData",  "Height", 18 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Facturas Anticipos" )

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

Function PrintReportAntCli( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr
   local cFilePdf       := cPatTmp() + "FacturasAnticiposCliente" + StrTran( ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt ) + ( dbfAntCliT )->cSufAnt, " ", "" ) + ".Pdf"

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

            oFr:SetProperty(  "PDFExport", "ShowDialog",       .f. )
            oFr:SetProperty(  "PDFExport", "DefaultPath",      cPatTmp() )
            oFr:SetProperty(  "PDFExport", "FileName",         cFilePdf )
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

                  :SetTypeDocument( "nFacAnt" )
                  :SetAlias(        dbfAntCliT )
                  :SetItems(        aItmAntCli() )
                  :SetAdjunto(      cFilePdf )
                  :SetPara(         RetFld( ( dbfAntCliT )->cCodCli, dbfCli, "cMeiInt" ) )
                  :SetAsunto(       "Envío de  factura de anticipo de cliente número " + ( dbfAntCliT )->cSerAnt + "/" + Alltrim( Str( ( dbfAntCliT )->nNumAnt ) ) )
                  :SetMensaje(      "Adjunto le remito nuestra factura de anticipo de cliente " + ( dbfAntCliT )->cSerAnt + "/" + Alltrim( Str( ( dbfAntCliT )->nNumAnt ) ) + Space( 1 ) )
                  :SetMensaje(      "de fecha " + Dtoc( ( dbfAntCliT )->dFecAnt ) + Space( 1 ) )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      "Reciba un cordial saludo." )

                  :lSend()

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

#endif

//---------------------------------------------------------------------------//
//Funciones comunes del programa y PDA
//---------------------------------------------------------------------------//

Function nNetAntCli( dbfMaster, dbfIva, dbfDiv, aTmp, cDivRet, lPic )

   nTotAntCli( dbfMaster, dbfIva, dbfDiv, aTmp, cDivRet, lPic )

Return ( nTotNet )

//---------------------------------------------------------------------------//

/*
Esta funcion hace los calculos de los totales en la Anticipo
*/

FUNCTION nTotAntCli( cAntCliT, cIva, cDiv, aTmp, cDivRet, lPic )

   local nPctRet
   local nPctReq
   local nPctIva
	local lRecargo
	local cCodDiv
   local lIvaInc

   DEFAULT cAntCliT  := dbfAntCliT
   DEFAULT cIva      := dbfIva
   DEFAULT cDiv      := dbfDiv
   DEFAULT lPic      := .f.

   public nTotAnt    := 0
   public nTotNet    := 0
   public nTotIva    := 0
   public nTotAge    := 0
   public nTotReq    := 0
   public nTotRet    := 0
   public nTotImp    := 0
   public cCtaCli    := cClientCuenta( ( cAntCliT )->cCodCli )

   if aTmp != nil
      lRecargo       := aTmp[ _LRECARGO]
      lIvaInc        := aTmp[ _LIVAINC ]
      cCodDiv        := aTmp[ _CDIVANT ]
      nPctIva        := aTmp[ _NPCTIVA ]
      nPctReq        := aTmp[ _NPCTREQ ]
      nPctRet        := aTmp[ _NPCTRET ]
      nTotNet        := aTmp[ _NIMPART ]
   else
      lRecargo       := ( cAntCliT )->lRecargo
      lIvaInc        := ( cAntCliT )->lIvaInc
      cCodDiv        := ( cAntCliT )->cDivAnt
      nPctIva        := ( cAntCliT )->nPctIva
      nPctReq        := ( cAntCliT )->nPctReq
      nPctRet        := ( cAntCliT )->nPctRet
      nTotNet        := ( cAntCliT )->nImpArt
   end if

   /*
   Cargamos los pictures dependiendo de la moneda------------------------------
	*/

   cPorDiv           := cPorDiv( cCodDiv, dbfDiv ) // Picture de la divisa redondeada
   nRouDiv           := nRouDiv( cCodDiv, dbfDiv ) // Decimales de redondeo

   if lIvaInc

      /*
      Total anticipo-----------------------------------------------------------
      */

      nTotAnt        := Round( nTotNet, nRouDiv )

      do case
         case !lRecargo .and. nPctIva != 0

            nTotImp  := Round( nTotNet / ( 100 / nPctIva + 1 ), nRouDiv )

         case lRecargo .and. nPctReq != 0 .and. nPctIva != 0

            nTotImp  := Round( nTotNet / ( 100 / ( nPctIva + nPctReq ) + 1 ), nRouDiv )
            // nTotReq  := if( !Empty( nPctReq ), Round( nTotNet / ( 100 / nPctReq + 1 ), nRouDiv ), 0 )

      end case

      /*
      Total impuestos----------------------------------------------------------
      */

      // nTotImp        := nTotIva + nTotReq

      /*
      Neto anticipo
      */

      nTotNet        := nTotAnt - nTotImp

      /*
      Total impuestos
      */

      if nPctIva != 0
         nTotIva     := Round( nTotNet * nPctIva / 100, nRouDiv )
      end if

      /*
      Total retenciones--------------------------------------------------------
      */

      if lRecargo .and. nPctReq != 0
         nTotReq     := Round( nTotNet * nPctReq / 100, nRouDiv )
      end if

      /*
      Total impuestos----------------------------------------------------------
      */

      nTotImp        := nTotIva + nTotReq

      /*
      Total anticipo-----------------------------------------------------------
      */

      nTotNet        := Round( nTotAnt - nTotImp, nRouDiv )

      /*
      Total retenciones
      */

      if nPctRet != 0
         nTotRet     := Round( nTotNet * nPctRet / 100, nRouDiv )
      end if

      /*
      Total neto anticipo
      */

      nTotNet        := Round( nTotAnt - nTotImp - nTotRet, nRouDiv )

   else

      nTotIva        := if( !Empty( nPctIva ), Round( nTotNet * nPctIva / 100, nRouDiv ), 0 )

      if lRecargo
         nTotReq     := if( !Empty( nPctReq ), Round( nTotNet * nPctReq / 100, nRouDiv ), 0 )
      end if

      /*
      Total impuestos
      */

      nTotImp        := nTotIva + nTotReq

      /*
      Total retenciones
      */

      if nPctRet != 0
         nTotRet     := Round( nTotNet * nPctRet / 100, nRouDiv )
      end if

      /*
      Total anticipo
      */

      nTotAnt        := Round( nTotNet + nTotImp - nTotRet, nRouDiv )

   end if

   /*
   Solicitan una divisa distinta a la q se hizo originalmente la Anticipo
   */

   if cDivRet != nil .and. cDivRet != cCodDiv
      nTotNet  := nCnv2Div( nTotNet, cCodDiv, cDivRet )
      nTotIva  := nCnv2Div( nTotIva, cCodDiv, cDivRet )
      nTotReq  := nCnv2Div( nTotReq, cCodDiv, cDivRet )
      nTotAnt  := nCnv2Div( nTotAnt, cCodDiv, cDivRet )
      nTotRet  := nCnv2Div( nTotRet, cCodDiv, cDivRet )
      cPorDiv  := cPorDiv( cDivRet, dbfDiv )
   end if

RETURN ( if( lPic, Trans( nTotAnt, cPorDiv ), nTotAnt ) ) //

//--------------------------------------------------------------------------//

function aItmAntCli()

   local aItmAntCli  := {}

   aAdd( aItmAntCli, {"cSerAnt"     ,"C",  1, 0, "Serie del anticipo" ,                                  "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nNumAnt"     ,"N",  9, 0, "Número del anticipo" ,                                 "'999999999'",        "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cSufAnt"     ,"C",  2, 0, "Sufijo del anticipo" ,                                 "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cTurAnt"     ,"C",  6, 0, "Sesión del anticipo" ,                                 "######",             "", "( cDbf )"} )
   aAdd( aItmAntCli, {"dFecAnt"     ,"D",  8, 0, "Fecha del anticipo" ,                                  "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCodCli"     ,"C", 12, 0, "Código del cliente" ,                                  "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCodAlm"     ,"C", 16, 0, "Código de almacén" ,                                   "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCodCaj"     ,"C",  3, 0, "Código de caja" ,                                      "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cNomCli"     ,"C", 80, 0, "Nombre del cliente" ,                                  "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cDirCli"     ,"C",100, 0, "Domicilio del cliente" ,                               "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cPobCli"     ,"C", 25, 0, "Población del cliente" ,                               "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cPrvCli"     ,"C", 20, 0, "Provincia del cliente" ,                               "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nCodProv"    ,"N",  2, 0, "Número de provincia cliente" ,                         "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cPosCli"     ,"C", 15, 0, "Código postal del cliente" ,                           "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cDniCli"     ,"C", 30, 0, "DNI/Cif del cliente" ,                                 "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"lModCli"     ,"L",  1, 0, "Lógico de modificar datos del cliente" ,               "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"lMayor"      ,"L",  1, 0, "Lógico de mayorista" ,                                 "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCodAge"     ,"C",  3, 0, "Código del agente" ,                                   "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCodRut"     ,"C",  4, 0, "Código de la ruta" ,                                   "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCodObr"     ,"C", 10, 0, "Código de la dirección" ,                                   "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nPctComAge"  ,"N",  6, 2, "Porcentaje de comisión del agente" ,                   "'@E 999,99'",        "", "( cDbf )"} )
   aAdd( aItmAntCli, {"lLiquidada"  ,"L",  1, 0, "Lógico de la liquidación" ,                            "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"dLiquidada"  ,"D",  8, 0, "Fecha de la liquidación" ,                             "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cTurLiq"     ,"C",  6, 0, "Sesión de la liquidación" ,                             "######",             "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCajLiq"     ,"C",  3, 0, "Código de la liquidación" ,                            "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAntCli, {"lContab"     ,"L",  1, 0, "Lógico de la contabilización" ,                        "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cSuant"      ,"C", 10, 0, "Su anticipo" ,                                         "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCondent"    ,"C", 20, 0, "Condición de entrada" ,                                "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"mDescrip"    ,"M", 10, 0, "Concepto" ,                                            "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nImpArt"     ,"N", 16, 6, "Importe del anticipo" ,                                "cPorDivAnt",         "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCodPago"    ,"C",  2, 0, "Código del tipo de pago" ,                             "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nPorcIva"    ,"N",  4, 1, "" ,                                                    "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"lRecargo"    ,"L",  1, 0, "Lógico para recargo" ,                                 "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cRemitido"   ,"C", 50, 0, "Campo de remitido" ,                                   "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"lIvaInc"     ,"L",  1, 0, cImp() + " incluido" ,                                        "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"lSndDoc"     ,"L",  1, 0, "Lógico para documento enviado" ,                       "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cDivAnt"     ,"C",  3, 0, "Código de la divisa" ,                                 "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nVdvAnt"     ,"N", 10, 4, "Cambio de la divisa" ,                                 "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cRetPor"     ,"C",100, 0, "Retirado por" ,                                        "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cRetMat"     ,"C", 20, 0, "Matrícula" ,                                           "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cNumDoc"     ,"C", 12, 0, "" ,                                                    "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nRegIva"     ,"N",  1, 0, "Regimen de " + cImp() ,                                   "'@E 999,99'",        "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCodPro"     ,"C",  9, 0, "Código de proyecto en contabilidad" ,                  "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cDocOrg"     ,"C", 10, 0, "Número del documento origen" ,                         "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nPctIva"     ,"N",  6, 2, "Porcentaje de " + cImp() ,                                "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nPctReq"     ,"N",  6, 2, "Porcentaje de recargo de equivalencia",                "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nPctRet"     ,"N",  6, 2, "Porcentaje de retención",                              "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"lCloAnt"     ,"L",  1, 0, "Lógico para anticipo liquidado" ,                      "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCodUsr"     ,"C",  3, 0, "Código de usuario",                                    "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"dFecCre"     ,"D",  8, 0, "Fecha de creación del documento",                      "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cTimCre"     ,"C",  5, 0, "Hora de creación del documento",                       "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"lSelDoc"     ,"L",  1, 0, "Lógico para seleccionar documento" ,                   "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCtaPgo"     ,"C", 12, 0, "Cuenta de pago" ,                                      "'@!'",               "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nReq"        ,"N", 16, 6, "Recargo de equivalencia" ,                             "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCodDlg"     ,"C",  2, 0, "Código delegación" ,                                   "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"CTLFCLI"     ,"C", 20, 0, "Teléfono del cliente" ,                                "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nTotNet"     ,"N", 16, 6, "Total neto" ,                                          "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nTotIva"     ,"N", 16, 6, "Total " + cImp() ,                                           "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nTotReq"     ,"N", 16, 6, "Total recargo" ,                                       "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"nTotAnt"     ,"N", 16, 6, "Total anticipo" ,                                      "",                   "", "( cDbf )"} )
   aAdd( aItmAntCli, {"cCtrCoste"   ,"C",  9, 0, "Cosigo del centro de coste" ,                          "",                   "", "( cDbf )"} )

RETURN ( aItmAntCli )

//---------------------------------------------------------------------------//

/*
Devuelve el importe en aticipos de una factura
*/

FUNCTION nTotAntFacCli( cFactura, dbfAntCliT, dbfIva, dbfDiv, cDivRet, lPic )

   local nRec
   local nOrd
   local cPorDiv
   local cCodDiv
   local nRouDiv           := 2
   local nTotAnt           := 0

   DEFAULT lPic            := .f.

   do case
      case IsNil( cFactura )

         cCodDiv           := ( dbfAntCliT )->cDivAnt
         cPorDiv           := cPorDiv( cCodDiv, dbfDiv ) // Picture de la divisa redondeada
         nRouDiv           := nRouDiv( cCodDiv, dbfDiv )

         nRec              := ( dbfAntCliT )->( Recno() )

         ( dbfAntCliT )->( dbGoTop() )
         while !( dbfAntCliT )->( eof() )
            nTotAnt        += nTotAntCli( dbfAntCliT, dbfIva, dbfDiv )
            ( dbfAntCliT )->( dbSkip() )
         end while

         ( dbfAntCliT )->( dbGoTo( nRec ) )

      case !Empty( cFactura )

         nRec              := ( dbfAntCliT )->( Recno() )
         nOrd              := ( dbfAntCliT )->( OrdSetFocus( "cNumDoc" ) )

         if ( dbfAntCliT )->( dbSeek( cFactura ) )
            while ( ( dbfAntCliT )->cNumDoc == cFactura .and. !( dbfAntCliT )->( eof() ) )
               nTotAnt     += nTotAntCli( dbfAntCliT, dbfIva, dbfDiv )
               ( dbfAntCliT )->( dbSkip() )
            end while
         end if

         ( dbfAntCliT )->( OrdSetFocus( nOrd ) )
         ( dbfAntCliT )->( dbGoTo( nRec ) )

   end case

   if cDivRet != nil .and. cCodDiv != cDivRet
      nTotAnt              := nCnv2Div( nTotAnt, cCodDiv, cDivRet )
      cPorDiv              := cPorDiv( cDivRet, dbfDiv ) // Picture de la divisa redondeada
      nRouDiv              := nRouDiv( cDivRet, dbfDiv )
   end if

   nTotAnt                 := Round( nTotAnt, nRouDiv )

   if lPic
      nTotAnt              := Trans( nTotAnt, cPorDiv )
   end if

RETURN ( nTotAnt )

//---------------------------------------------------------------------------//

FUNCTION IsAntCli( cPath )

Return ( .t. )

//----------------------------------------------------------------------------//

/*
Crea las bases de datos necesarias para la Anticipoción desde fuera
*/

FUNCTION mkAntCli( cPath, lAppend, cPathOld, oMeter )

   local oBlock
   local oError
   local dbfAntCliT
   local dbfAntCliI
   local dbfAntCliD
   local oldAntCliT
   local oldAntCliI
   local oldAntCliD

   DEFAULT lAppend   := .f.

   if oMeter != NIL
		oMeter:cText	:= "Generando Bases"
      SysRefresh()
   end if

   CreateFiles( cPath, .t. )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cDriver(), cPath + "AntCliT.Dbf" , cCheckArea( "AntCliT", @dbfAntCliT ), .f. )
      if !( dbfAntCliT )->( neterr() )
         ( dbfAntCliT )->( OrdListAdd( cPath + "AntCliT.Cdx" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "AntCliI.DBF" , cCheckArea( "AntCliI", @dbfAntCliI ), .f. )
      if !( dbfAntCliI )->( neterr() )
         ( dbfAntCliI )->( OrdListAdd( cPath + "AntCliI.CDX" ) )
      end if

      dbUseArea( .t., cDriver(), cPath + "AntCliD.DBF", cCheckArea( "AntCliD", @dbfAntCliD ), .f. )
      if !( dbfAntCliD )->( neterr() )
         ( dbfAntCliD )->( ordListAdd( cPath + "AntCliD.CDX" ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "AntCliT.DBF" , cCheckArea( "AntCliT", @oldAntCliT ), .f. )
      if !( dbfAntCliT )->( neterr() )
         ( oldAntCliT )->( OrdListAdd( cPathOld + "AntCliT.CDX" ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "AntCliI.DBF" , cCheckArea( "AntCliI", @oldAntCliI ), .f. )
      if !( dbfAntCliI )->( neterr() )
         ( oldAntCliI )->( OrdListAdd( cPathOld + "AntCliI.CDX" ) )
      end if

      dbUseArea( .t., cDriver(), cPathOld + "AntCliD.DBF", cCheckArea( "AntCliD", @oldAntCliD ), .f. )
      if !( dbfAntCliD )->( neterr() )
         ( oldAntCliD )->( ordListAdd( cPathOld + "AntCliD.CDX" ) )
      end if

      ( dbfAntCliT )->( OrdSetFocus( "lLiquidada" ) )
      ( oldAntCliT )->( OrdSetFocus( "lLiquidada" ) )

      ( oldAntCliT )->( dbGoTop() )
      while !( oldAntCliT )->( Eof() )

         if !( oldAntCliT )->lLiquidada

            dbCopy( oldAntCliT, dbfAntCliT, .t. )

            if ( oldAntCliI )->( dbSeek( ( oldAntCliT )->cSerAnt + Str( ( oldAntCliT )->nNumAnt ) + ( oldAntCliT )->cSufAnt ) )
               while ( oldAntCliT )->cSerAnt + Str( ( oldAntCliT )->nNumAnt ) + ( oldAntCliT )->cSufAnt == ( oldAntCliI )->cSerAnt + Str( ( oldAntCliI )->nNumAnt ) + ( oldAntCliI )->cSufAnt .and. !( oldAntCliI )->( eof() )
                  dbCopy( oldAntCliI, dbfAntCliI, .t. )
                  ( oldAntCliI )->( dbSkip() )
               end while
            end if

            if ( oldAntCliD )->( dbSeek( ( oldAntCliT )->cSerAnt + Str( ( oldAntCliT )->nNumAnt ) + ( oldAntCliT )->cSufAnt ) )
               while ( oldAntCliT )->cSerAnt + Str( ( oldAntCliT )->nNumAnt ) + ( oldAntCliT )->cSufAnt == ( oldAntCliD )->cSerAnt + Str( ( oldAntCliD )->nNumAnt ) + ( oldAntCliD )->cSufAnt .and. !( oldAntCliD )->( eof() )
                  dbCopy( oldAntCliD, dbfAntCliD, .t. )
                  ( oldAntCliD )->( dbSkip() )
               end while
            end if

         end if

         ( oldAntCliT )->( dbSkip() )

      end while

      /*
      Reemplaza la antigua sesion----------------------------------------------
      */

      ( dbfAntCliT )->( dbEval( {|| ( dbfAntCliT )->cTurAnt := Space( 6 ) }, , , , , .f. ) )

      /*
      Cerramos las tablas------------------------------------------------------
      */

      CLOSE ( dbfAntCliT )
      CLOSE ( dbfAntCliI )
      CLOSE ( dbfAntCliD )

      CLOSE ( oldAntCliT )
      CLOSE ( oldAntCliI )
      CLOSE ( oldAntCliD )

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

      CLOSE ( dbfAntCliT )
      CLOSE ( dbfAntCliI )
      CLOSE ( dbfAntCliD )

      CLOSE ( oldAntCliT )
      CLOSE ( oldAntCliI )
      CLOSE ( oldAntCliD )

   END SEQUENCE
   ErrorBlock( oBlock )

Return .t.

//---------------------------------------------------------------------------//
/*
Regenera indices
*/

FUNCTION rxAntCli( cPath, cDriver )

   local dbfAntCliT

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cDriver()

   /*
   Crea los ficheros si no existen
   */

   if !lExistTable( cPath + "AntCliT.Dbf", cDriver )   .or.;
      !lExistTable( cPath + "AntCliI.Dbf", cDriver )   .or.;
      !lExistTable( cPath + "AntCliD.Dbf", cDriver )
      CreateFiles( cPath, .f. )
   end if

   fEraseIndex( cPath + "AntCliT.Cdx", cDriver )
   fEraseIndex( cPath + "AntCliI.Cdx", cDriver )
   fEraseIndex( cPath + "AntCliD.Cdx", cDriver )

   dbUseArea( .t., cDriver, cPath + "AntCliT.DBF", cCheckArea( "AntCliT", @dbfAntCliT ), .f. )
   if !( dbfAntCliT )->( neterr() )
      ( dbfAntCliT )->( __dbPack() )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "nNumAnt", "cSerAnt + Str( nNumAnt ) + cSufAnt", {|| Field->cSerAnt + Str( Field->nNumAnt ) + Field->cSufAnt } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "dFecAnt", "dFecAnt", {|| Field->dFecAnt } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "cCodCli", "cCodCli", {|| Field->cCodCli } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "cNomCli", "Upper( cNomCli )", {|| Upper( Field->cNomCli ) } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "cCodObr", "cCodObr", {|| Field->cCodObr } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "cTurAnt", "cTurAnt + cSufAnt + cCodCaj", {|| Field->cTurAnt + Field->cSufAnt + Field->cCodCaj } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "cCodAge", "cCodAge", {|| Field->cCodAge } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "cCodRut", "cCodRut", {|| Field->cCodRut } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "cPobCli", "cPobCli + cNomCli", {|| Field->cPobCli + Field->cNomCli } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "cAgeFec", "cCodAge + DtoS( dFecAnt )", {|| Field->cCodAge + DtoS( Field->dFecAnt ) } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "cNumDoc", "cNumDoc", {|| Field->cNumDoc } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ))
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "lSndDoc", "lSndDoc", {|| Field->lSndDoc } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "cTurLiq", "cTurLiq + cSufAnt + cCajLiq", {|| Field->cTurLiq + Field->cSufAnt + Field->cCajLiq } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.Cdx", "cCodUsr", "cCodUsr + Dtos( dFecCre ) + cTimCre", {|| Field->cCodUsr + Dtos( Field->dFecCre ) + Field->cTimCre } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted() .and. !lLiquidada", {|| !Deleted() .and. !Field->lLiquidada } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "lLiquidada", "cSerAnt + Str( nNumAnt ) + cSufAnt", {|| Field->cSerAnt + Str( Field->nNumAnt ) + Field->cSufAnt } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted() .and. !lLiquidada", {|| !Deleted() .and. !Field->lLiquidada } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "lNumAnt", "cSerAnt + Str( nNumAnt ) + cSufAnt", {|| Field->cSerAnt + Str( Field->nNumAnt ) + Field->cSufAnt } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted() .and. !lLiquidada", {|| !Deleted() .and. !Field->lLiquidada } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "lFecAnt", "dFecAnt", {|| Field->dFecAnt } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted() .and. !lLiquidada", {|| !Deleted() .and. !Field->lLiquidada } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "lCodCli", "cCodCli", {|| Field->cCodCli } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted() .and. !lLiquidada", {|| !Deleted() .and. !Field->lLiquidada } ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "lNomCli", "Upper( cNomCli )", {|| Upper( Field->cNomCli ) } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.Cdx", "cCtrCoste", "cCtrCoste", {|| Field->cCtrCoste } ) )

      ( dbfAntCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , .t. ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliT.CDX", "dDesFec", "dFecAnt", {|| Field->dFecAnt } ) )

      ( dbfAntCliT )->( dbCloseArea() )

   end if

   dbUseArea( .t., cDriver, cPath + "AntCliI.DBF", cCheckArea( "AntCliI", @dbfAntCliT ), .f. )
   if !( dbfAntCliT )->( neterr() )
      ( dbfAntCliT )->( __dbPack() )

      ( dbfAntCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliI.CDX", "nNumAnt", "cSerAnt + Str( nNumAnt ) + cSufAnt", {|| Field->cSerAnt + Str( Field->nNumAnt ) + Field->cSufAnt } ) )

      ( dbfAntCliT )->( dbCloseArea() )
   end if

   dbUseArea( .t., cDriver, cPath + "AntCliD.DBF", cCheckArea( "AntCliD", @dbfAntCliT ), .f. )
   if !( dbfAntCliT )->( neterr() )
      ( dbfAntCliT )->( __dbPack() )

      ( dbfAntCliT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfAntCliT )->( ordCreate( cPath + "AntCliD.CDX", "nNumAnt", "cSerAnt + Str( nNumAnt ) + cSufAnt", {|| Field->cSerAnt + Str( Field->nNumAnt ) + Field->cSufAnt } ) )

      ( dbfAntCliT )->( dbCloseArea() )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

/*
Crea los ficheros de la Anticipoci¢n
*/

STATIC FUNCTION CreateFiles( cPath, lReindex )

   DEFAULT lReindex  := .t.

   if !lExistTable( cPath + "AntCliT.DBF", cLocalDriver() )
      dbCreate( cPath + "AntCliT.DBF", aSqlStruct( aItmAntCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "AntCliI.DBF", cLocalDriver() )
      dbCreate( cPath + "AntCliI.DBF", aSqlStruct( aIncAntCli() ), cLocalDriver() )
   end if

   if !lExistTable( cPath + "AntCliD.DBF", cLocalDriver() )
      dbCreate( cPath + "AntCliD.DBF", aSqlStruct( aAntCliDoc() ), cLocalDriver() )
   end if

   if lReindex
      rxAntCli( cPath, cLocalDriver() )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

function aAntCliDoc()

   local aAntCliDoc  := {}

   aAdd( aAntCliDoc, { "cSerAnt", "C",    1,  0, "Serie de anticipos" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aAntCliDoc, { "nNumAnt", "N",    9,  0, "Número de anticipos" ,             "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aAntCliDoc, { "cSufAnt", "C",    2,  0, "Sufijo de anticipos" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aAntCliDoc, { "cNombre", "C",  250,  0, "Nombre del documento" ,            "",                   "", "( cDbfCol )" } )
   aAdd( aAntCliDoc, { "cRuta",   "C",  250,  0, "Ruta del documento" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aAntCliDoc, { "mObsDoc", "M",   10,  0, "Observaciones del documento" ,     "",                   "", "( cDbfCol )" } )

return ( aAntCliDoc )

//---------------------------------------------------------------------------//

function aIncAntCli()

   local aIncAntCli  := {}

   aAdd( aIncAntCli, { "cSerAnt", "C",    1,  0, "Serie de anticipo" ,              "",                   "", "( cDbfCol )" } )
   aAdd( aIncAntCli, { "nNumAnt", "N",    9,  0, "Número de anticipo" ,             "'999999999'",        "", "( cDbfCol )" } )
   aAdd( aIncAntCli, { "cSufAnt", "C",    2,  0, "Sufijo de anticipo" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aIncAntCli, { "cCodTip", "C",    3,  0, "Tipo de incidencia" ,             "",                   "", "( cDbfCol )" } )
   aAdd( aIncAntCli, { "dFecInc", "D",    8,  0, "Fecha de la incidencia" ,         "",                   "", "( cDbfCol )" } )
   aAdd( aIncAntCli, { "mDesInc", "M",   10,  0, "Descripción de la incidencia" ,   "",                   "", "( cDbfCol )" } )
   aAdd( aIncAntCli, { "lListo",  "L",    1,  0, "Lógico de listo" ,                "",                   "", "( cDbfCol )" } )
   aAdd( aIncAntCli, { "lAviso",  "L",    1,  0, "Lógico de aviso" ,                "",                   "", "( cDbfCol )" } )

return ( aIncAntCli )

//---------------------------------------------------------------------------//

Static Function YearComboBoxChange()

   if ( oWndBrw:oWndBar:cYearComboBox() != __txtAllYearsFilter__ )
      oWndBrw:oWndBar:setYearComboBoxExpression( "Year( Field->dFecAnt ) == " + oWndBrw:oWndBar:cYearComboBox() )
   else
      oWndBrw:oWndBar:setYearComboBoxExpression( "" )
   end if 

   oWndBrw:chgFilter()

Return nil

//---------------------------------------------------------------------------//

#ifndef __PDA__

function SynAntCli( cPath )

   local aTotAnt

   DEFAULT cPath  := cPatEmp()

   if OpenFiles()

      while !( dbfAntCliT )->( eof() )

         /*
         Rellenamos los campos con los totales---------------------------------
         */

         if ( dbfAntCliT )->nTotAnt == 0 .and. dbLock( dbfAntCliT )

            aTotAnt                 := aTotAntCli( dbfAntCliT, dbfIva, dbfDiv, , ( dbfAntClit )->cDivAnt )

            ( dbfAntCliT )->nTotNet := aTotAnt[1]
            ( dbfAntCliT )->nTotIva := aTotAnt[2]
            ( dbfAntCliT )->nTotReq := aTotAnt[3]
            ( dbfAntCliT )->nTotAnt := aTotAnt[5]

            ( dbfAntCliT )->( dbUnLock() )

         end if

         ( dbfAntCliT )->( dbSkip() )

      end while

   CloseFiles()

   end if

return nil

#endif

//------------------------------------------------------------------------//

Function aTotAntCli( dbfMaster, dbfIva, dbfDiv, aTmp, cDivRet, lPic )

   nTotAntCli( dbfMaster, dbfIva, dbfDiv, aTmp, cDivRet, lPic )

Return { nTotNet, nTotIva, nTotReq, nTotRet, nTotAnt }

//---------------------------------------------------------------------------//

Function getExtraFieldFacturaAnticipo( cFieldName )

Return ( getExtraField( cFieldName, oDetCamposExtra, ( dbfAntCliT )->cSerAnt + Str( ( dbfAntCliT )->nNumAnt ) + ( dbfAntCliT )->cSufAnt ) )

//---------------------------------------------------------------------------//
