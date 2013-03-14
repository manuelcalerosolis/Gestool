#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Font.ch"
   #include "Folder.ch"
   #include "Print.ch"
   #include "Report.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif
   #include "Factu.ch"

#define _MENUITEM_               "01059"

/*
Defines para las lineas de Pago
*/

#define _CSERIE                   1      //   C      1     0
#define _NNUMFAC                  2      //   N      9     0
#define _CSUFFAC                  3      //   C      2     0
#define _NNUMREC                  4      //   N      2     0
#define _CTIPREC                  5      //   N      2     0
#define _CCODPGO                  6      //   C      2     0
#define _CCODCAJ                  7      //   C      6     0
#define _CTURREC                  8      //   C     12     0
#define _CCODCLI                  9      //   D      8     0
#define _CNOMCLI                 10      //   D      8     0
#define _DENTRADA                11      //   N     10     0
#define _NIMPORTE                12      //   C    100     0
#define _CDESCRIP                13      //   C      8     0
#define _DPRECOB                 14      //   D     50     0
#define _CPGDOPOR                15      //   D     50     0
#define _CDOCPGO                 16      //   L      1     0
#define _LCOBRADO                17      //   C      3     0
#define _CDIVPGO                 18      //
#define _NVDVPGO                 19      //   L      1     0
#define _LCONPGO                 20      //   C     12     0
#define _CCTAREC                 21      //   N     16     6
#define _NIMPEUR                 22      //   L      1     0
#define _LIMPEUR                 23      //   N      9     0 Numero de la remesas
#define _NNUMREM                 24      //   C      2     0 Sufijo de remesas
#define _CSUFREM                 25      //   C      3     0 Cuenta de remesa
#define _CCTAREM                 26      //   L      1     0 Marca para impreso
#define _LRECIMP                 27      //   L      1     0 Recibo descontado
#define _LRECDTO                 28      //   D      8     0 Fecha del descuento
#define _DFECDTO                 29      //   D      8     0 Fecha de vencimiento
#define _DFECVTO                 30      //   C      3     0 Codigo del agente
#define _CCODAGE                 31      //   C      3     0 Numero de cobro
#define _NNUMCOB                 32      //   C      2     0 Sufijo de cobro
#define _CSUFCOB                 33      //   N     16     6 Importe de cobro
#define _NIMPCOB                 34      //   N     16     6 Importe de gastos
#define _NIMPGAS                 35      //   C     12     0 Subcuenta de gastos
#define _CCTAGAS                 36
#define _LESPERADOC              37
#define _LCLOPGO                 38
#define _DFECIMP                 39      //   D      8     0
#define _CHORIMP                 40      //   C      5     0
#define _LNOTARQUEO              41
#define _CCODBNC                 42
#define _DFECCRE                 43      //   D      8     0
#define _CHORCRE                 44      //   C      5     0
#define _CCODUSR                 45      //   C      3     0
#define _LDEVUELTO               46      //   L      1     0
#define _DFECDEV                 47      //   D      8     0
#define _CMOTDEV                 48      //   C    250     0
#define _CRECDEV                 49      //   C     14     0
#define _LSNDDOC                 50      //   L      1     0
#define _CBNCEMP                 51
#define _CBNCCLI                 52
#define _CENTEMP                 53
#define _CSUCEMP                 54
#define _CDIGEMP                 55
#define _CCTAEMP                 56
#define _CENTCLI                 57
#define _CSUCCLI                 58
#define _CDIGCLI                 59
#define _CCTACLI                 60
#define _LREMESA                 61

memvar cDbfRec
memvar cDbf
memvar cDbfCol
memvar cCliente
memvar cDbfCli
memvar cFPago
memvar cDbfPgo
memvar cDbfDiv
memvar cDbfAge
memvar cPorDivRec
memvar nPagina
memvar lEnd
memvar nTotFac

static oWndBrw
static dbfDiv
static oBandera
static dbfClient
static dbfCount

static dbfFacCliT
static dbfFacCliL
static dbfFacCliP

static dbfFacRecT
static dbfFacRecL

static dbfAntCliT

static dbfFPago
static dbfIva
static dbfDoc
static dbfFlt
static dbfAgent
static dbfCajT
static oCtaRem
static lPgdOld
static nImpOld
static dbfEmp
static dbfBncCli
static dbfBncEmp
static dbfTurno

static aDbfBmp

static oMenu

static lExternal        := .f.
static lOpenFiles       := .f.
static cFiltroUsuario   := ""

static lOldDevuelto     := .f.

#ifndef __PDA__
   static bEdit         := { |aTmp, aGet, dbfFacCliP, oBrw, lRectificativa, bValid, nMode, aTmpFac| EdtCob( aTmp, aGet, dbfFacCliP, oBrw, lRectificativa, bValid, nMode, aTmpFac ) }
#else
   static bpdaEdit      := { |aTmp, aGet, dbfFacCliP, oBrw, bWhen, bValid, nMode, aTmpFac| pdaEdtCob( aTmp, aGet, dbfFacCliP, oBrw, bWhen, bValid, nMode, aTmpFac ) }
#endif

#ifndef __PDA__

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lExt )

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Los ficheros de recibos de clientes ya estan abiertos.' )
      Return ( .f. )
   end if

   DEFAULT lExt         := .f.

   lExternal            := lExt

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles        := .t.

      USE ( cPatEmp() + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbfFacCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIP.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacRecT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecT", @dbfFacRecT ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FacRecL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecL", @dbfFacRecL ) )
      SET ADSINDEX TO ( cPatEmp() + "FacRecL.CDX" ) ADDITIVE

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE

      USE ( cPatCli() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgent ) )
      SET ADSINDEX TO ( cPatCli() + "AGENTES.CDX" ) ADDITIVE

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

      USE ( cPatDat() + "CNFFLT.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "CNFFLT", @dbfFlt ) )
      SET ADSINDEX TO ( cPatDat() + "CNFFLT.CDX" ) ADDITIVE

      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

      USE ( cPatCli() + "CliBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIBNC", @dbfBncCli ) )
      SET ADSINDEX TO ( cPatCli() + "CliBnc.Cdx" ) ADDITIVE
      SET TAG TO "cBncDef"

      USE ( cPatGrp() + "EmpBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPBNC", @dbfBncEmp ) )
      SET ADSINDEX TO ( cPatGrp() + "EmpBnc.Cdx" ) ADDITIVE
      SET TAG TO "cCtaBnc"

      USE ( cPatEmp() + "Turno.DBF" ) NEW VIA ( cDriver() ) SHARED   ALIAS ( cCheckArea( "Turno", @dbfTurno ) )
      SET ADSINDEX TO ( cPatEmp() + "Turno.CDX" ) ADDITIVE

      oBandera             := TBandera():New

      oCtaRem              := TCtaRem():Create( cPatCli() )
      oCtaRem:OpenFiles()

      /*
      Limitaciones de cajero y cajas--------------------------------------------------------
      */

      if oUser():lFiltroVentas()
         cFiltroUsuario    := "Field->cCodUsr == '" + oUser():cCodigo() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
      end if


   RECOVER

      msgStop( "Imposible abrir todas las bases de datos de recibos de clientes" + CRLF + ErrorMessage( oError ) )

      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpenFiles )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   DestroyFastFilter( dbfFacCliP, .t., .t. )

   if dbfFacCliP != nil
      ( dbfFacCliP )->( dbCloseArea() )
   end if
   if dbfDiv != nil
      ( dbfDiv )->( dbCloseArea() )
   end if
   if dbfClient != nil
      ( dbfClient )->( dbCloseArea() )
   end if
   if dbfFacCliT != nil
      ( dbfFacCliT )->( dbCloseArea() )
    end if
   if dbfFacCliL != nil
      ( dbfFacCliL )->( dbCloseArea() )
   end if
   if dbfFacRecT != nil
      ( dbfFacRecT )->( dbCloseArea() )
    end if
   if dbfFacRecL != nil
      ( dbfFacRecL )->( dbCloseArea() )
   end if
   if dbfAntCliT != nil
      ( dbfAntCliT )->( dbCloseArea() )
   end if
   if dbfFPago != nil
      ( dbfFPago )->( dbCloseArea() )
   end if
   if dbfAgent != nil
      ( dbfAgent )->( dbCloseArea() )
   end if
   if dbfIva != nil
      ( dbfIva )->( dbCloseArea() )
   end if
   if dbfDoc != nil
      ( dbfDoc )->( dbCloseArea() )
   end if
   if dbfCajT != nil
      ( dbfCajT )->( dbCloseArea() )
   end if
   if dbfFlt != nil
      ( dbfFlt )->( dbCloseArea() )
   end if
   if dbfEmp != nil
      ( dbfEmp )->( dbCloseArea() )
   end if
   if dbfCount != nil
      ( dbfCount )->( dbCloseArea() )
   end if

   if dbfBncCli != nil
      ( dbfBncCli )->( dbCloseArea() )
   end if

   if dbfBncEmp != nil
      ( dbfBncEmp )->( dbCloseArea() )
   end if

   if dbfTurno != nil
      ( dbfTurno )->( dbCloseArea() )
   end if

   if oCtaRem != nil
      oCtaRem:CloseFiles()
      oCtaRem:End()
   end if

   dbfFacCliP  := nil
   dbfFacCliT  := nil
   dbfFacCliL  := nil
   dbfAntCliT  := nil
   dbfClient   := nil
   oBandera    := nil
   dbfFPago    := nil
   dbfAgent    := nil
   dbfCount    := nil
   dbfEmp      := nil
   dbfDiv      := nil
   dbfDoc      := nil
   dbfFlt      := nil
   dbfBncCli   := nil
   dbfBncEmp   := nil
   dbfTurno    := nil

   oWndBrw     := nil

   lOpenFiles  := .f.

Return .t.

//--------------------------------------------------------------------------//

FUNCTION RecCli( oMenuItem, oWnd, aNumRec )

   local oImp
   local oPrv
   local oFlt
   local nLevel
   local oBtnEur
   local lEur           := .f.
   local oPdf
   local oMail
   local oRotor
   local nOrdAnt
   local lFound

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()
   DEFAULT  aNumRec     := Array( 1 )

   nLevel            := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !OpenFiles()
      Return .f.
   end if

   /*
   Anotamos el movimiento para el navegador------------------------------------
   */

   AddMnuNext( "Recibos de facturas de clientes", ProcName() )

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      XBROWSE ;
      TITLE    "Recibos de facturas de clientes" ;
      MRU      "Briefcase_user1_16" ;
      BITMAP   clrTopArchivos ;
      ALIAS    ( dbfFacCliP );
      PROMPTS  "Número",;
               "Código",;
               "Nombre",;
               "Expedición",;
               "Vencimiento",;
               "Cobro",;
               "Importe" ;
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfFacCliP, , , aNumRec ) ) ;
      ZOOM     ( WinZooRec( oWndBrw:oBrw, bEdit, dbfFacCliP ) ) ;
      DELETE   ( DelCobCli( oWndBrw:oBrw, dbfFacCliP ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

	  oWndBrw:lFechado     := .t.

	  oWndBrw:bChgIndex    := {|| if( oUser():lFiltroVentas(), CreateFastFilter( cFiltroUsuario, dbfFacCliP, .f., , cFiltroUsuario ), CreateFastFilter( "", dbfFacCliP, .f. ) ) }

	  oWndBrw:SetYearComboBoxChange( {|| YearComboBoxChange() } )

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bEditValue       := {|| ( dbfFacCliP )->lCloPgo }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "Zoom16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cobrado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| "" }
         :bBmpData         := {|| nEstadoRecibo( dbfFacCliP ) }
         :nWidth           := 20
         :AddResource( "Cnt16" )
         :AddResource( "Sel16" )
         :AddResource( "Document_out_16" )
         :AddResource( "ChgPre16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Contabilizado"
         :nHeadBmpNo       := 3
         :bEditValue       := {|| ( dbfFacCliP )->lConPgo }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "BmpConta16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Impreso"
         :nHeadBmpNo       := 3
         :bEditValue       := {|| ( dbfFacCliP )->lRecImp }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "IMP16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Espera de documentación"
         :nHeadBmpNo       := 3
         :bEditValue       := {|| ( dbfFacCliP )->lEsperaDoc }
         :nWidth           := 20
         :lHide            := .t.
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "document_time_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo"
         :bEditValue       := {|| if( !Empty( ( dbfFacCliP )->cTipRec ), "Rectificativa", "" ) }
         :nWidth           := 60
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "nNumFac"
         :bEditValue       := {|| ( dbfFacCliP )->cSerie + "/" + AllTrim( Str( ( dbfFacCliP )->nNumFac ) ) + "-" + Str( ( dbfFacCliP )->nNumRec ) }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Delegación"
         :bEditValue       := {|| ( dbfFacCliP )->cSufFac  }
         :nWidth           := 20
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| ( dbfFacCliP )->cTurRec }
         :nWidth           := 40
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ( dbfFacCliP )->cCodCaj }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ( dbfFacCliP )->cCodUsr }
         :nWidth           := 40
         :lHide            := .t.
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCli"
         :bEditValue       := {|| ( dbfFacCliP )->cCodCli }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCli"
         :bEditValue       := {|| ( dbfFacCliP )->cNomCli }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Expedición"
         :cSortOrder       := "dPreCob"
         :bEditValue       := {|| Dtoc( ( dbfFacCliP )->dPreCob ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Vencimiento"
         :cSortOrder       := "dFecVto"
         :bEditValue       := {|| Dtoc( ( dbfFacCliP )->dFecVto ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cobro"
         :cSortOrder       := "dEntrada"
         :bEditValue       := {|| Dtoc( ( dbfFacCliP )->dEntrada ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Descripción"
         :bEditValue       := {|| ( dbfFacCliP )->cDescrip }
         :nWidth           := 180
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Importe"
         :cSortOrder       := "nImporte"
         :bEditValue       := {|| nTotRecCli( dbfFacCliP, dbfDiv, if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Cobrado"
         :bEditValue       := {|| nTotCobCli( dbfFacCliP, dbfDiv, if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Gasto"
         :bEditValue       := {|| nTotGasCli( dbfFacCliP, dbfDiv, if( lEur, cDivChg(), cDivEmp() ), .t. ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Div"
         :bEditValue       := {|| cSimDiv( ( dbfFacCliP )->cDivPgo, dbfDiv ) }
         :nWidth           := 30
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Agente"
         :bEditValue       := {|| ( dbfFacCliP )->cCodAge }
         :lHide            := .t.
         :nWidth           := 40
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Remesa"
         :cSortOrder       := "nNumRem"
         :bEditValue       := {|| Alltrim( Str( ( dbfFacCliP )->nNumRem ) ) + "/" + ( dbfFacCliP )->cSufRem }
         :lHide            := .t.
         :nWidth           := 80
      end with

      oWndBrw:CreateXFromCode()

   DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
      HOTKEY   "B"

   oWndBrw:AddSeaBar()

   DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecEdit() );
      TOOLTIP  "(M)odificar";
      BEGIN GROUP;
      HOTKEY   "M";
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecZoom() );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z";
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:RecDel() );
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL oImp RESOURCE "IMP" GROUP OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( ImpPago( nil, IS_PRINTER ) ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      lGenRecCli( oWndBrw:oBrw, oImp, IS_PRINTER ) ;

   DEFINE BTNSHELL RESOURCE "SERIE1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( PrnSerie() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( ImpPago( nil, IS_SCREEN ) ) ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      lGenRecCli( oWndBrw:oBrw, oPrv, IS_SCREEN ) ;

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( ImpPago( nil, IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      lGenRecCli( oWndBrw:oBrw, oPdf, IS_PDF ) ;

   DEFINE BTNSHELL oMail RESOURCE "Mail" OF oWndBrw ;
      NOBORDER ;
      MENU     This:Toggle() ;
      ACTION   ( ImpPago( nil, IS_MAIL ) ) ;
      TOOLTIP  "Correo electrónico";
      LEVEL    ACC_IMPR

      lGenRecCli( oWndBrw:oBrw, oMail, IS_MAIL )

   DEFINE BTNSHELL RESOURCE "Money2_" OF oWndBrw GROUP ;
      NOBORDER ;
      ACTION   ( lLiquida( oWndBrw:oBrw ) ) ;
      TOOLTIP  "Cobrar" ;
      LEVEL    ACC_EDIT

#ifndef __TACTIL__

   DEFINE BTNSHELL RESOURCE "PREV1" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( InfPreCli():New( "Previsión de cobros" ):Play() ) ;
      TOOLTIP  "Pre(v)isión";
      HOTKEY   "V";
      LEVEL    ACC_IMPR

#endif

   DEFINE BTNSHELL RESOURCE "BMPCONTA" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( dlgContabilizaReciboCliente( oWndBrw:oBrw ) ) ;
      TOOLTIP  "(C)ontabilizar" ;
      HOTKEY   "C";
      LEVEL    ACC_EDIT

   if oUser():lAdministrador()

      DEFINE BTNSHELL RESOURCE "CHGSTATE" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( dlgContabilizaReciboCliente( oWndBrw:oBrw, "Cambiar estado de recibos", "Contabilizado", .t. ) ) ;
         TOOLTIP  "Cambiar es(t)ado" ;
         HOTKEY   "T";
         LEVEL    ACC_EDIT

   end if

   DEFINE BTNSHELL oBtnEur RESOURCE "BAL_EURO" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( lEur := !lEur, oWndBrw:Refresh() ) ;
      TOOLTIP  "M(o)neda";
      HOTKEY   "O";

   DEFINE BTNSHELL RESOURCE "Sel" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( FilterRecibos( .t. ) );
      TOOLTIP  "Solo cob(r)ados" ;
      HOTKEY   "R";

   DEFINE BTNSHELL RESOURCE "Cnt" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( FilterRecibos( .f. ) );
      TOOLTIP  "Solo (p)endientes" ;
      HOTKEY   "P";

   DEFINE BTNSHELL RESOURCE "Document_out_" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( FilterRecibos() );
      TOOLTIP  "Solo de(v)ueltos" ;
      HOTKEY   "V";

#ifndef __PDA__

if oUser():lAdministrador()

   DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
      NOBORDER ;
      ACTION   ( TDlgFlt():New( aItmRecCli(), dbfFacCliP ):ChgFields(), oWndBrw:Refresh() ) ;
      TOOLTIP  "Cambiar campos" ;
      LEVEL    ACC_APPD

end if

#endif

   DEFINE BTNSHELL oRotor RESOURCE "ROTOR" GROUP OF oWndBrw ;
      ACTION   ( oRotor:Expand() ) ;
      TOOLTIP  "Rotor" ;

      DEFINE BTNSHELL RESOURCE "User1_" OF oWndBrw ;
         ACTION   ( EdtCli( ( dbfFacCliP )->cCodCli ) );
         TOOLTIP  "Modificar cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "Info" OF oWndBrw ;
         ACTION   ( InfCliente( ( dbfFacCliP )->cCodCli ) );
         TOOLTIP  "Informe de cliente" ;
         FROM     oRotor ;

      DEFINE BTNSHELL RESOURCE "Document_User1_" OF oWndBrw ;
         ACTION   ( EdtFacCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac ) );
         TOOLTIP  "Modificar factura" ;
         FROM     oRotor ;

   DEFINE BTNSHELL RESOURCE "End" GROUP OF oWndBrw ;
      NOBORDER ;
      ACTION   ( oWndBrw:End() ) ;
      TOOLTIP  "(S)alir";
      HOTKEY   "S"

   if !oUser():lFiltroVentas()
      oWndBrw:oActiveFilter:aTField       := aItmrecCli()
      oWndBrw:oActiveFilter:cDbfFilter    := dbfFlt
      oWndBrw:oActiveFilter:cTipFilter    := REC_CLI
   end if

   ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   if ValType( aNumRec ) == "A" .and. !Empty( aNumRec[ 1 ] )

      nOrdAnt  := (dbfFacCliP)->( OrdSetFocus( "nNumFac" ) )
      lFound   := ( dbfFacCliP )->( dbSeek( aNumRec[ 1 ] ) )

      ( dbfFacCliP )->( OrdSetFocus( nOrdAnt ) )

      if lFound
         oWndBrw:Refresh()
         oWndBrw:RecEdit()
      end if

      aNumRec  := Array( 1 )

   end if

Return .t.

//--------------------------------------------------------------------------//

FUNCTION EdtCob( aTmp, aGet, dbfFacCliP, oBrw, lRectificativa, bValid, nMode, aNumRec )

	local oDlg
   local oFld
   local oBmpDiv
   local oGetAge
   local cGetAge           := cNbrAgent( ( dbfFacCliP )->cCodAge, dbfAgent )
   local oGetCaj
   local cGetCaj           := RetFld( ( dbfFacCliP )->cCodCaj, dbfCajT, "cNomCaj" )
   local oGetPgo
   local cGetPgo           := RetFld( ( dbfFacCliP )->cCodPgo, dbfFPago, "cDesPago" )
   local oGetSubCta
   local cGetSubCta
   local oGetCtaRem
   local cGetCtaRem
   local oGetSubGas
   local cGetSubGas
   local cPorDiv           := cPorDiv( ( dbfFacCliP )->cDivPgo, dbfDiv )
   local oBmpGeneral
   local oBmpContabilidad
   local oBmpDevolucion
   local oBmpBancos

   if !IsLogic( lRectificativa )
      lRectificativa       := .f.
   end if

   do case
   case nMode == APPD_MODE

      if lRectificativa
         aTmp[ _CTIPREC ]  := "R"
      end if

   case nMode == EDIT_MODE

      if aTmp[ _LCONPGO ] .and. !ApoloMsgNoYes( 'La modificación de este recibo puede provocar descuadres contables.' + CRLF + '¿Desea continuar?', 'Recibo ya contabilizado' )
         return .f.
      end if

      if aTmp[ _LCLOPGO ] .and. !oUser():lAdministrador()
         msgStop( "Solo pueden modificar los recibos cerrados los administradores." )
         return .f.
      end if

   end case

   if Empty( aTmp[ _CCODCAJ ] )
      aTmp[ _CCODCAJ ]     := oUser():cCaja()
   end if

   lOldDevuelto            := aTmp[ _LDEVUELTO ]

   lPgdOld                 := ( dbfFacCliP )->lCobrado .or. ( dbfFacCliP )->lRecDto
   nImpOld                 := ( dbfFacCliP )->nImporte

   DEFINE DIALOG  oDlg ;
         RESOURCE "Recibos" ;
         TITLE    LblTitle( nMode ) + "recibos de clientes"

      REDEFINE FOLDER oFld ;
         ID       500;
         OF       oDlg ;
         PROMPT   "&General",;
                  "Bancos",;
                  "Devolución",;
                  "Contablidad" ;
         DIALOGS  "Recibos_1",;
                  "Recibos_6",;
                  "Recibos_2",;
                  "Recibos_3"

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "Money_Alpha_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _DPRECOB ] VAR aTmp[ _DPRECOB ] ;
         ID       100 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ _DPRECOB ]:cText( Calendario( aTmp[ _DPRECOB ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _DFECVTO ] VAR aTmp[ _DFECVTO ] ;
         ID       110 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ _DFECVTO ]:cText( Calendario( aTmp[ _DFECVTO ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE CHECKBOX aGet[ _LNOTARQUEO ] VAR aTmp[ _LNOTARQUEO ];
         ID       200 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CTURREC ] VAR aTmp[ _CTURREC ] ;
         ID       335 ;
         PICTURE  "999999" ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CCODCLI ] VAR aTmp[ _CCODCLI ] ;
         ID       120 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CNOMCLI ] VAR aTmp[ _CNOMCLI ];
         ID       121 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CCODAGE ] VAR aTmp[ _CCODAGE ] ;
         ID       130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( cAgentes( aGet[ _CCODAGE ], dbfAgent, oGetAge ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAgentes( aGet[ _CCODAGE ], oGetAge ) );
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oGetAge VAR cGetAge ;
         ID       131 ;
         WHEN     .f.;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CCODPGO ] VAR aTmp[ _CCODPGO ] ;
         ID       290 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE  "@!" ;
         VALID    ( cFPago( aGet[ _CCODPGO ], dbfFPago, oGetPgo ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ _CCODPGO ], oGetPgo ) ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET oGetPgo VAR cGetPgo ;
         ID       291 ;
         WHEN     .f.;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[_CDESCRIP] VAR aTmp[_CDESCRIP] ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

		REDEFINE GET aGet[_CPGDOPOR] VAR aTmp[_CPGDOPOR] ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[_CDOCPGO] VAR aTmp[_CDOCPGO] ;
         ID       155 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _CDIVPGO ] VAR aTmp[ _CDIVPGO ];
         WHEN     ( .f. ) ;
         VALID    ( cDivOut( aGet[ _CDIVPGO ], oBmpDiv, aTmp[ _NVDVPGO ], nil, nil, @cPorDiv, nil, nil, nil, nil, dbfDiv, oBandera ) );
         PICTURE  "@!";
         ID       170 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVPGO ], oBmpDiv, aTmp[ _NVDVPGO ], dbfDiv, oBandera ) ;
         OF       oFld:aDialogs[ 1 ]

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       171;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[_NIMPORTE] VAR aTmp[_NIMPORTE] ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( aGet[ _NIMPCOB ]:cText( aTmp[ _NIMPORTE ] ), .t. ) ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[_NIMPCOB] VAR aTmp[_NIMPCOB] ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( ValCobro( aGet, aTmp ) ) ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[_NIMPGAS] VAR aTmp[_NIMPGAS] ;
         ID       260 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         PICTURE  ( cPorDiv ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE CHECKBOX aGet[ _LCOBRADO ] VAR aTmp[ _LCOBRADO ];
         ID       220 ;
         ON CHANGE( ValCheck( aGet, aTmp ) ) ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

      REDEFINE GET aGet[ _DENTRADA ] VAR aTmp[ _DENTRADA ] ;
         ID       230 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON HELP  aGet[ _DENTRADA ]:cText( Calendario( aTmp[ _DENTRADA ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[ 1 ]

      /*
      Segunda caja de diálogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpDevolucion ;
         ID       500 ;
         RESOURCE "money2_delete_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE CHECKBOX aGet[ _LDEVUELTO ] VAR aTmp[ _LDEVUELTO ];
         ID       100 ;
         WHEN     ( aTmp[ _LCOBRADO] .and. nMode != ZOOM_MODE ) ;
         ON CHANGE( lValDevolucion( aGet, aTmp, .f. ) ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE GET aGet[ _DFECDEV ] VAR aTmp[ _DFECDEV ] ;
         ID       110 ;
         SPINNER ;
         WHEN     ( aTmp[ _LCOBRADO] .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE GET aGet[ _CMOTDEV ] VAR aTmp[ _CMOTDEV ] ;
         ID       120 ;
         WHEN     ( aTmp[ _LCOBRADO ] .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 3 ]

      REDEFINE GET aGet[ _CRECDEV ] VAR aTmp[ _CRECDEV ] ;
         ID       130 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[ 3 ]

      /*
      Cuentas contables--------------------------------------------------------
      */

      REDEFINE BITMAP oBmpContabilidad ;
         ID       500 ;
         RESOURCE "Folder2_red_Alpha_48" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE CHECKBOX aGet[ _LCONPGO ] VAR aTmp[ _LCONPGO ];
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _CCTAREC ] VAR aTmp[ _CCTAREC ] ;
         ID       240 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubCta( aGet[ _CCTAREC ], oGetSubCta ) ) ;
         VALID    ( MkSubCta( aGet[ _CCTAREC ], nil, oGetSubCta ) ) ;
         OF       oFld:aDialogs[ 4 ]

		REDEFINE GET oGetSubCta VAR cGetSubCta ;
         ID       241 ;
			WHEN 		.F. ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _CCTAGAS ] VAR aTmp[ _CCTAGAS ] ;
         ID       270 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubCta( aGet[ _CCTAGAS ], oGetSubGas ) ) ;
         VALID    ( MkSubCta( aGet[ _CCTAGAS ], nil, oGetSubGas ) );
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET oGetSubGas VAR cGetSubGas ;
         ID       271 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[ 4 ]

      /*
      Remesa___________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCTAREM ] VAR aTmp[ _CCTAREM ] ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( oGetCtaRem:cText( oRetFld( aTmp[ _CCTAREM ], oCtaRem:oDbf ) ), .t. );
         ON HELP  ( oCtaRem:Buscar( aGet[ _CCTAREM ] ) ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET oGetCtaRem VAR cGetCtaRem ;
         ID       251 ;
			COLOR 	CLR_GET ;
			WHEN 		.F. ;
         OF       oFld:aDialogs[ 4 ]

      /*
		Cajas____________________________________________________________________
		*/

      REDEFINE GET aGet[ _CCODCAJ ] VAR aTmp[ _CCODCAJ ];
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    cCajas( aGet[ _CCODCAJ ], dbfCajT, oGetCaj ) ;
         ID       280 ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CCODCAJ ], oGetCaj ) ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET oGetCaj VAR cGetCaj ;
         ID       281 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE CHECKBOX aGet[_LRECIMP] VAR aTmp[_LRECIMP];
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _DFECIMP ] VAR aTmp[ _DFECIMP ] ;
         ID       161 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE GET aGet[ _CHORIMP ] VAR aTmp[ _CHORIMP ] ;
         ID       162 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[ 4 ]

      REDEFINE CHECKBOX aGet[ _LESPERADOC ] VAR aTmp[ _LESPERADOC ];
         ID       165 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 4 ]

      /*
      Diálogo de bancos--------------------------------------------------------
      */

      REDEFINE BITMAP oBmpBancos ;
         ID       500 ;
         RESOURCE "office_building_48_alpha" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ _CBNCEMP ] VAR aTmp[ _CBNCEMP ];
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncEmp( aGet[ _CBNCEMP ], aGet[ _CENTEMP ], aGet[ _CSUCEMP ], aGet[ _CDIGEMP ], aGet[ _CCTAEMP ] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CENTEMP ] VAR aTmp[ _CENTEMP ];
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CDIGEMP ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CSUCEMP ] VAR aTmp[ _CSUCEMP ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP], aGet[ _CDIGEMP ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CDIGEMP ] VAR aTmp[ _CDIGEMP ];
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CDIGEMP ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTAEMP ] VAR aTmp[ _CCTAEMP ];
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ _CENTEMP ], aTmp[ _CSUCEMP ], aTmp[ _CDIGEMP ], aTmp[ _CCTAEMP ], aGet[ _CDIGEMP ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CBNCCLI ] VAR aTmp[ _CBNCCLI ];
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncCli( aGet[ _CBNCCLI ], aGet[ _CENTCLI ], aGet[ _CSUCCLI ], aGet[ _CDIGCLI ], aGet[ _CCTACLI ], aTmp[ _CCODCLI ] ) );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CENTCLI ] VAR aTmp[ _CENTCLI ];
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ _CENTCLI ], aTmp[ _CSUCCLI ], aTmp[ _CDIGCLI ], aTmp[ _CCTACLI ], aGet[ _CDIGCLI ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CSUCCLI ] VAR aTmp[ _CSUCCLI ];
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ _CENTCLI ], aTmp[ _CSUCCLI ], aTmp[ _CDIGCLI ], aTmp[ _CCTACLI], aGet[ _CDIGCLI ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CDIGCLI ] VAR aTmp[ _CDIGCLI ];
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ _CENTCLI ], aTmp[ _CSUCCLI ], aTmp[ _CDIGCLI ], aTmp[ _CCTACLI ], aGet[ _CDIGCLI ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CCTACLI ] VAR aTmp[ _CCTACLI ];
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( aTmp[ _CENTCLI ], aTmp[ _CSUCCLI ], aTmp[ _CDIGCLI ], aTmp[ _CCTACLI ], aGet[ _CDIGCLI ] ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aGet[ _LREMESA ] VAR aTmp[ _LREMESA ] ;
         ID       300 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _NNUMREM ] VAR aTmp[ _NNUMREM ];
         ID       310 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ _CSUFREM ] VAR aTmp[ _CSUFREM ];
         ID       320 ;
         WHEN     ( nMode != ZOOM_MODE .and. lUsrMaster() ) ;
         OF       oFld:aDialogs[2]

      /*
      Botones__________________________________________________________________
		*/

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, dbfFacCliP, oBrw, oDlg, nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( KillTrans( dbfFacCliP, oDlg ) )

      REDEFINE BUTTON ;
         ID       998 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp ("Recibos") )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, dbfFacCliP, oBrw, oDlg, nMode ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp ("Recibos") } )

   oDlg:bStart := {|| lValDevolucion( aGet, aTmp, .t. ) }

   ACTIVATE DIALOG oDlg CENTER ;
         ON INIT  (  aGet[ _CDIVPGO ]:lValid(),;
                     aGet[ _CCTAREC ]:lValid(),;
                     aGet[ _CCTAGAS ]:lValid(),;
                     aGet[ _CCTAREM ]:lValid(),;
                     aGet[ _DPRECOB ]:SetFocus(),;
                     EdtRecMenu( aTmp, oDlg ) )

   EndEdtRecMenu()

   if !Empty( oBmpDiv )
      oBmpDiv:End()
   end if

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

   if !Empty( oBmpDevolucion )
      oBmpDevolucion:End()
   end if

   if !Empty( oBmpContabilidad )
      oBmpContabilidad:End()
   end if

   if !Empty( oBmpBancos )
      oBmpBancos:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function KillTrans( dbfFacCliP, oDlg )

   oDlg:End()

Return .t.

//---------------------------------------------------------------------------//
/*
Cambia el estado de un recibo
*/

STATIC FUNCTION ChgState( lState )

   DEFAULT lState := !( dbfFacCliP )->lConPgo

   if ( dbfFacCliP )->lConPgo != lState .and. dbLock( dbfFacCliP )
      ( dbfFacCliP )->lConPgo := lState
      ( dbfFacCliP )->( dbUnLock() )
   end if

RETURN NIL

//-------------------------------------------------------------------------//

/*
Contabiliza los recibos
*/

Static Function dlgContabilizaReciboCliente( oBrw, cTitle, cOption, lChgState )

	local oDlg
   local oBrwCon
   local cSerIni
   local cSerFin
   local oDocIni
   local oDocFin
   local nDocIni
   local nDocFin
   local cSufIni
   local cSufFin
   local nNumIni
   local nNumFin
   local oMtrInf
   local nMtrInf
   local oSerIni
   local oSerFin
   local oBtnCancel
   local nRad        := 2
   local oSimula
   local lSimula     := .t.
   local nRecFac     := ( dbfFacCliT )->( Recno() )
   local nOrdFac     := ( dbfFacCliT )->( OrdSetFocus( 1 ) )
   local nRecRec     := ( dbfFacCliP )->( Recno() )
   local nOrdRec     := ( dbfFacCliP )->( OrdSetFocus( 1 ) )
   local cTipo       := "Todas"
   local oTree
   local oImageList

   DEFAULT cTitle    := "Contabilizar recibos"
   DEFAULT cOption   := "Simular resultados"
   DEFAULT lChgState := .f.

   oImageList        := TImageList():New( 16, 16 )
   oImageList:AddMasked( TBitmap():Define( "bRed" ),     Rgb( 255, 0, 255 ) )
   oImageList:AddMasked( TBitmap():Define( "bGreen" ),   Rgb( 255, 0, 255 ) )

   cSerIni           := ( dbfFacCliP )->cSerie
   cSerFin           := ( dbfFacCliP )->cSerie
   nDocIni           := ( dbfFacCliP )->nNumFac
   nDocFin           := ( dbfFacCliP )->nNumFac
   cSufIni           := ( dbfFacCliP )->cSufFac
   cSufFin           := ( dbfFacCliP )->cSufFac
   nNumIni           := ( dbfFacCliP )->nNumRec
   nNumFin           := ( dbfFacCliP )->nNumRec

   DEFINE DIALOG oDlg RESOURCE "ConSerRec" TITLE ( cTitle )

   REDEFINE RADIO nRad ;
      ID       90, 91 ;
      OF       oDlg

   REDEFINE COMBOBOX cTipo ;
      ITEMS    { "Todas", "Facturas", "Rectificativas" } ;
      ID       80 ;
      OF       oDlg

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       100 ;
      PICTURE  "@!" ;
      WHEN     ( nRad == 2 );
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      VALID    ( cSerIni >= "A" .and. cSerIni <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE BTNBMP ;
      ID       101 ;
      OF       oDlg ;
      RESOURCE "Up16" ;
      NOBORDER ;
      ACTION   ( dbFirst( dbfFacCliP, "nNumFac", oDocIni, cSerIni, "nNumFac" ) )

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       110 ;
      PICTURE  "@!" ;
      WHEN     ( nRad == 2 );
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      VALID    ( cSerFin >= "A" .and. cSerFin <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE BTNBMP ;
      ID       111 ;
      OF       oDlg ;
      RESOURCE "Down16" ;
      NOBORDER ;
      ACTION   ( dbLast( dbfFacCliP, "nNumFac", oDocFin, cSerFin, "nNumFac" ) )

   REDEFINE GET oDocIni VAR nDocIni;
      ID       120 ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  "999999999" ;
      SPINNER ;
		OF 		oDlg

   REDEFINE GET oDocFin VAR nDocFin;
      ID       130 ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  "999999999" ;
      SPINNER ;
		OF 		oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  "##" ;
		OF 		oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  "##" ;
		OF 		oDlg

   REDEFINE GET nNumIni ;
      ID       160 ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  "99" ;
		OF 		oDlg

   REDEFINE GET nNumFin ;
      ID       170 ;
      WHEN     ( nRad == 2 ) ;
      PICTURE  "99" ;
		OF 		oDlg

   REDEFINE CHECKBOX oSimula VAR lSimula;
      ID       190 ;
		OF 		oDlg

   oTree             := TTreeView():Redefine( 180, oDlg )
   oTree:bLDblClick  := {|| TreeChanged( oTree ) }

   REDEFINE METER oMtrInf ;
      VAR      nMtrInf ;
      NOPERCENTAGE ;
      ID       200;
      OF       oDlg

   oMtrInf:SetTotal( ( dbfFacCliP )->( OrdKeyCount() ) )

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( PasRec( cSerIni + Str( nDocIni, 9 ) + cSufIni + Str( nNumIni ), cSerFin + Str( nDocFin, 9 ) + cSufFin + Str( nNumFin ), nRad, cTipo, lSimula, lChgState, oBrw, oBtnCancel, oDlg, oTree, oMtrInf ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| PasRec( cSerIni + Str( nDocIni, 9 ) + cSufIni + Str( nNumIni ), cSerFin + Str( nDocFin, 9 ) + cSufFin + Str( nNumFin ), nRad, cTipo, lSimula, lChgState, oBrw, oBtnCancel, oDlg, oTree, oMtrInf ) } )

   oDlg:bStart := {|| oSerIni:SetFocus(), SetWindowText( oSimula:hWnd, cOption ), oSimula:Refresh() }

   ACTIVATE DIALOG oDlg ;
      CENTER ;
      ON INIT  ( oTree:SetImageList( oImageList ) )

   ( dbfFacCliT )->( dbGoTo( nRecFac ) )
   ( dbfFacCliT )->( OrdSetFocus( nOrdFac ) )
   ( dbfFacCliP )->( dbGoTo( nRecRec ) )
   ( dbfFacCliP )->( OrdSetFocus( nOrdRec ) )

   oImageList:End()

   oTree:Destroy()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN NIL

//------------------------------------------------------------------------//

Static Function TreeChanged( oTree )

   local oItemTree   := oTree:GetItem()

   if !Empty( oItemTree ) .and. !Empty( oItemTree:bAction )
      Eval( oItemTree:bAction )
   end if

RETURN NIL

//------------------------------------------------------------------------//

STATIC FUNCTION PasRec( cDocIni, cDocFin, nRad, cTipo, lSimula, lChgState, oBrw, oBtnCancel, oDlg, oTree, oMtrInf )

   local aPos
   local bWhile
   local lWhile         := .t.
   local aSimula        := {}
   local nRecno         := ( dbfFacCliP )->( Recno() )
   local nOrden         := ( dbfFacCliP )->( OrdSetFocus( "nNumFac" ) )
   local lErrorFound    := .f.
   local lReturn

   /*
   Preparamos la pantalla para mostrar la simulación---------------------------
   */

   if lSimula
      aPos              := { 0, 0 }
      ClientToScreen( oDlg:hWnd, aPos )
      oDlg:Move( aPos[ 1 ] - 22, aPos[ 2 ] - 510 )
   end if

   /*
   Desabilitamos el dialogo para iniciar el proceso----------------------------
   */

   oDlg:Disable()

   oBtnCancel:bAction   := {|| lWhile := .f. }
   oBtnCancel:Enable()

   oTree:Enable()
   oTree:DeleteAll()

   if ( nRad == 1 )

      ( dbfFacCliP )->( dbGoTop() )

      bWhile            := {|| !( dbfFacCliP )->( eof() ) }

   else

      ( dbfFacCliP )->( dbSeek( cDocIni, .t. ) )

      bWhile            := {||   ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ) >= cDocIni .and. ;
                                 ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ) <= cDocFin .and. ;
                                 !( dbfFacCliP )->( eof() ) }

   end if

   oMtrInf:Set( ( dbfFacCliP )->( OrdKeyNo() ) )

   while ( lWhile .and. Eval( bWhile ) )

      /*
      Si nos piden facturas de clientes o facturas rectificativas esta linea es importante
      */

      do case
         case ( cTipo == "Facturas" .or. cTipo == "Todas" )       .and. Empty( ( dbfFacCliP )->cTipRec )

            if lChgState
               lReturn  := ChgState( lSimula )
            else
               lReturn  := ContabilizaReciboCliente( nil, oTree, lSimula, aSimula, dbfFacCliT, dbfFacCliP, dbfDiv )
            end if

         case ( cTipo == "Rectificativas" .or. cTipo == "Todas" ) .and. !Empty( ( dbfFacCliP )->cTipRec )

            if lChgState
               lReturn  := ChgState( lSimula )
            else
               lReturn  := ContabilizaReciboCliente( nil, oTree, lSimula, aSimula, dbfFacRecT, dbfFacCliP, dbfDiv )
            end if

      end case

      if IsFalse( lReturn )
         exit
      end if

      ( dbfFacCliP )->( dbSkip() )

      oMtrInf:Set( ( dbfFacCliP )->( OrdKeyNo() ) )

      sysrefresh()

   end do

   oMtrInf:Set( ( dbfFacCliP )->( OrdKeyCount() ) )

   /*
   Vamos a mostrar el resultado------------------------------------------------
   */

   ( dbfFacCliP )->( OrdSetFocus( nOrden ) )
   ( dbfFacCliP )->( dbGoTo( nRecno ) )

   oBtnCancel:bAction   := {|| oDlg:End() }

   if lSimula
      WndCenter( oDlg:hWnd ) // Move( aPos[ 1 ], aPos[ 2 ] + 200 )
   end if

   oDlg:Enable()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION ContabilizaReciboCliente( oBrw, oTree, lSimula, aSimula, dbfFacCliT, dbfFacCliP, dbfDiv, lFromFactura, nAsiento )

   local cCodEmp
   local cRuta
   local dFecha
   local cConcepto
   local cCtaGas
   local cCtaPgo
   local cCtaCli
   local nDpvDiv
   local lEfePgo
   local nEjeCon        := 0 
   local nRecCliT       := ( dbfFacCliT )->( Recno() )
   local nRecCliP       := ( dbfFacCliP )->( Recno() )
   local cCodDiv        := if( ( dbfFacCliP )->lImpEur, "EUR", ( dbfFacCliP )->cDivPgo )
   local nImpRec        := nTotRecCli( dbfFacCliP, dbfDiv )
   local nImpCob        := nTotCobCli( dbfFacCliP, dbfDiv )
   local nImpGas        := nTotGasCli( dbfFacCliP, dbfDiv )
   local lConFac        := lConFacCli( ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC, dbfFacCliT )
   local cCodCli        := cCliFacCli( ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC, dbfFacCliT )
   local cCodPgo        := cPgoFacCli( ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC, dbfFacCliT )
   local cCodPro        := cProFacCli( ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC, dbfFacCliT )
   local nRecibo        := ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC + Str( ( dbfFacCliP )->NNUMREC )
   local cRecibo        := ( dbfFacCliP )->cSerie + "/" + Ltrim( Str( ( dbfFacCliP )->NNUMFAC, 9 ) ) + "/" + ( dbfFacCliP )->CSUFFAC + "-" + Str( ( dbfFacCliP )->NNUMREC )
   local cTerNif        := RetFld( ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC, dbfFacCliT, "CDNICLI" )
   local cTerNom        := ( dbfFacCliP )->cNomCli
   local lErrorFound    := .f.
   local lRectif        := !Empty( ( dbfFacCliP )->cTipRec )
   local cProyecto      := Left( cCodPro, 3 )
   local cClave         := Right( cCodPro, 6 )
   local lReturn        := .t.

   nDpvDiv              := nDpvDiv( cCodDiv, dbfDiv )

   DEFAULT lSimula      := .f.
   DEFAULT lFromFactura := .f.
   DEFAULT nAsiento     := 0

   cRuta                := cRutCnt()
   cCodEmp              := cCodEmpCnt( ( dbfFacCliP )->cSerie )

   if !lFromFactura

      if OpenDiario( , cCodEmp )
         nAsiento          := RetLastAsi()
      else
         oTree:Select( oTree:Add( "Recibo : " + Rtrim( cRecibo ) + " imposible abrir ficheros de contaplus.", 0 ) )
         Return .f.
      end if

   end if

   /*
	Chequando antes de pasar a Contaplus
	--------------------------------------------------------------------------
	*/

   if ( dbfFacCliP )->lConPgo
      oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " ya contabilizado.", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
      lErrorFound       := .t.
   end if

   if !( ( dbfFacCliP )->lCobrado .or. ( dbfFacCliP )->lDevuelto )
      oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " no cobrado o no devuelto.", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
      lErrorFound       := .t.
   end if

   if ( dbfFacCliP )->lCobrado .and. !ChkFecha( , , ( dbfFacCliP )->dEntrada, .f. )
      oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " de " + dtoc( ( dbfFacCliP )->dEntrada ) + " asiento fuera de fechas", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
      lErrorFound       := .t.
   end if

   if !Empty( ( dbfFacCliP )->nNumRem ) .and. !( dbfFacCliP )->lDevuelto
      oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " pertenece a remesa.", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
      lErrorFound       := .t.
   end if

   if !lConFac .and. !lFromFactura
      oTree:Select( oTree:Add( "Factura de recibo : " + rtrim( cRecibo ) + " no contabilizada.", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
      lErrorFound       := .t.
   end if

   if !ChkRuta( cRutCnt() )
      oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " ruta no valida.", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
      lErrorFound       := .t.
   end if

   /*
   Seleccionamos las empresa dependiendo de la serie de factura
	--------------------------------------------------------------------------
	*/

   if Empty( cCodEmp )
      oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " no se definieron empresas asociadas.", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
      lErrorFound       := .t.
   end if

	/*
	Chequeamos todos los valores
	--------------------------------------------------------------------------
	*/

   if Empty( cCodCli )
      cCodCli           := cCliFacCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac, dbfFacCliT )
   end if

   cCtaCli              := cCliCta( cCodCli, dbfClient )

   if Empty( cCtaCli )
      cCtaCli           := cCtaSin()
   end if

   if !ChkSubCta( cRuta, cCodEmp, cCtaCli, , .f., .f. )
      oTree:Select( oTree:Add( "Recibo : " + Rtrim( cRecibo ) + " subcuenta de cliente " + cCtaCli + " no encontada.", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
      lErrorFound       := .t.
   end if

   /*
   Comprobamos formas de pago
   ----------------------------------------------------------------------------
   */

   if ( dbfFacCliP )->( dbSeek( nRecibo ) )

      /*
      Si el recibo no trae forma especifica de pago entonces lo buscamos
      */

      cCtaPgo           := ( dbfFacCliP )->cCtaRec

      if Empty( cCtaPgo )
         cCtaPgo        := cCtaFPago( cCodPgo, dbfFPago )
      end if

      if Empty( cCtaPgo )
         cCtaPgo        := cCtaCob()
      end if

      if Empty( cCtaPgo )
         oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " no existe cuenta de pago.", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
         lErrorFound    := .t.
      end if

      if !ChkSubCta( cRuta, cCodEmp, cCtaPgo, , .f., .f. )
         oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " subcuenta " + rtrim( cCtaPgo ) + " no encontada.", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
         lErrorFound    := .t.
      end if

      /*
      Pago es en efectivo------------------------------------------------------
      */

      if ( nTipoPago( cCodPgo, dbfFPago ) == 1 )

         nEjeCon        := nEjercicioContaplus( cRuta, cCodEmp, .f. )

         if Empty( nEjeCon )
            oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " ejercicio no encontado.", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
            lErrorFound := .t.
         end if

      end if 

      /*
      Obtenemos las cuentas de gastos------------------------------------------
      */

      if nImpGas != 0

         if Empty( ( dbfFacCliP )->cCtaGas )
            cCtaGas  := cCtaFGas( cCodPgo, dbfFPago )
         else
            cCtaGas  := ( dbfFacCliP )->cCtaGas
         end if

         if Empty( cCtaGas )
            oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " no existe cuenta de gastos.", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
            lErrorFound := .t.
         end if

         if !ChkSubCta( cRuta, cCodEmp, cCtaGas, , .f., .f. )
            oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " subcuenta " + rtrim( cCtaGas ) + " no encontada.", 0, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
            lErrorFound := .t.
         end if

      end if

   else

      msginfo( "No encuentro el recibo " + nRecibo )

   end if

	/*
	Comprobamos fechas
	--------------------------------------------------------------------------
	*/

   if ( !lErrorFound )

      if Empty( ( dbfFacCliP )->dPreCob )

         if dbDialogLock( dbfFacCliP )
            ( dbfFacCliP )->dPreCob := date()
            ( dbfFacCliP )->( dbUnLock() )
         end if

      end if

   end if

   /*
	Datos comunes a todos los Asientos
	--------------------------------------------------------------------------
	*/

   if ( lSimula .or. !lErrorFound )

      if ( dbfFacCliP )->lDevuelto
         cConcepto      := "Dev./Recibo. " + cRecibo
         dFecha         := ( dbfFacCliP )->dFecDev
      else
         cConcepto      := "C/Recibo. " + cRecibo
         dFecha         := ( dbfFacCliP )->dEntrada
      end if

   end if

	/*
	Contabilizaci¢n de Pagos
	--------------------------------------------------------------------------
	*/

   if ( lSimula .or. !lErrorFound )

      /*
      Cliente por el total_____________________________________________________
      */

      if nImpRec != 0

          aadd( aSimula, MkAsiento( nAsiento,;
                                    cCodDiv,;
                                    dFecha, ;
                                    cCtaCli,;
                                    ,;
                                    if( ( dbfFacCliP )->lDevuelto, nImpRec, 0 ),;
                                    cConcepto,;
                                    if( ( dbfFacCliP )->lDevuelto, 0, nImpRec ),;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      end if

      /*
      Cobro____________________________________________________________________
      */

      if nImpCob != 0

         aadd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha, ;
                                    cCtaPgo,;
                                    ,;
                                    if( ( dbfFacCliP )->lDevuelto, 0, nImpCob ),;
                                    cConcepto,;
                                    if( ( dbfFacCliP )->lDevuelto, nImpCob, 0 ),;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom,;
                                    nEjeCon,;
                                    cCtaCli ) )

      end if

      /*
      Gastos___________________________________________________________________
      */

      if nImpGas != 0

         aadd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha, ;
                                    cCtaGas,;
                                    ,;
                                    if( ( dbfFacCliP )->lDevuelto, 0, nImpGas ),;
                                    cConcepto,;
                                    if( ( dbfFacCliP )->lDevuelto, nImpGas, 0 ),;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      end if

      if ( !lSimula .and. !lErrorFound )
         lReturn     := lContabilizaReciboCliente( cRecibo, nAsiento, lFromFactura, oTree, dbfFacCliP )
      end if

      if ( lSimula .and. !lFromFactura )
         lReturn     := msgTblCon( aSimula, cCodDiv, dbfDiv, !lErrorFound, cRecibo, {|| aWriteAsiento( aSimula, cCodDiv, .t., oTree, cRecibo, nAsiento ), lContabilizaReciboCliente( cRecibo, nAsiento, lFromFactura, oTree, dbfFacCliP ) } )
      end if

   end if

   if !lFromFactura
      CloseDiario()
   end if

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

   ( dbfFacCliP )->( dbGoTo( nRecCliP ) )
   ( dbfFacCliT )->( dbGoTo( nRecCliT ) )

RETURN ( lReturn )

//------------------------------------------------------------------------//

Function lContabilizaReciboCliente( cRecibo, nAsiento, lFromFactura, oTree, dbfFacCliP )

   if dbLock( dbfFacCliP )
      ( dbfFacCliP )->lConPgo  := .t.
      ( dbfFacCliP )->( dbUnLock() )
   end if

   if !lFromFactura
      oTree:Select( oTree:Add( "Recibo : " + Rtrim( cRecibo ) + " asiento generado num. " + Alltrim( Str( nAsiento ) ), 1, bGenEdtRecCli( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ), lFromFactura ) ) )
   end if

RETURN ( .t. )

//------------------------------------------------------------------------//

Function nTotRecCli( uFacCliP, cDbfDiv, cDivRet, lPic )

   local cDivPgo
   local nRouDiv
   local cPorDiv
   local nTotRec

   DEFAULT uFacCliP  := dbfFacCliP
   DEFAULT cDbfDiv   := dbfDiv
   DEFAULT cDivRet   := cDivEmp()
   DEFAULT lPic      := .f.

   if ValType( uFacCliP ) == "O"
      cDivPgo        := uFacCliP:cDivPgo
      nTotRec        := uFacCliP:nImporte
   else
      cDivPgo        := ( uFacCliP )->cDivPgo
      nTotRec        := ( uFacCliP )->nImporte
   end if

   nRouDiv           := nRouDiv( cDivPgo, cDbfDiv )
   cPorDiv           := cPorDiv( cDivPgo, cDbfDiv )

   nTotRec           := Round( nTotRec, nRouDiv )

   if cDivRet != cDivPgo
      nRouDiv        := nRouDiv( cDivRet, cDbfDiv )
      cPorDiv        := cPorDiv( cDivRet, cDbfDiv )
      nTotRec        := nCnv2Div( nTotRec, cDivPgo, cDivRet, cDbfDiv )
   end if

RETURN if( lPic, Trans( nTotRec, cPorDiv ), nTotRec )

//------------------------------------------------------------------------//

function nTotCobCli( uFacCliP, uDiv, cDivRet, lPic )

   local cDivPgo
   local nRouDiv
   local cPorDiv
   local nTotRec
   local nTotCob
   local lRecCob
   local cDbfDiv

   DEFAULT cDivRet   := cDivEmp()
   DEFAULT lPic      := .f.

   if ValType( uFacCliP ) == "O"
      cDivPgo        := uFacCliP:cDivPgo
      nTotRec        := uFacCliP:nImporte
      nTotCob        := uFacCliP:nImpCob
      lRecCob        := uFacCliP:lCobrado
   else
      cDivPgo        := ( uFacCliP )->cDivPgo
      nTotRec        := ( uFacCliP )->nImporte
      nTotCob        := ( uFacCliP )->nImpCob
      lRecCob        := ( uFacCliP )->lCobrado
   end if

   if ValType( uDiv ) == "O"
      cDbfDiv        := uDiv:cAlias
   else
      cDbfDiv        := uDiv
   end id

   nRouDiv           := nRouDiv( cDivPgo, cDbfDiv )
   cPorDiv           := cPorDiv( cDivPgo, cDbfDiv )

   if lRecCob

      if nTotCob == 0
         nTotCob     := Round( nTotRec, nRouDiv )
      else
         nTotCob     := Round( nTotCob, nRouDiv )
      end if

   else

      nTotCob        := 0

   end if

   if cDivRet != cDivPgo
      nRouDiv        := nRouDiv( cDivRet, cDbfDiv )
      cPorDiv        := cPorDiv( cDivRet, cDbfDiv )
      nTotCob        := nCnv2Div( nTotRec, cDivPgo, cDivRet, cDbfDiv )
   end if

RETURN if( lPic, Trans( nTotCob, cPorDiv ), nTotCob )

//------------------------------------------------------------------------//

function nTotGasCli( uFacCliP, uDiv, cDivRet, lPic )

   local cDivPgo
   local nRouDiv
   local cPorDiv
   local nTotRec
   local nTotCob
   local lRecCob
   local cDbfDiv

   DEFAULT cDivRet   := cDivEmp()
   DEFAULT lPic      := .f.

   if ValType( uFacCliP ) == "O"
      cDivPgo        := uFacCliP:cDivPgo
      nTotRec        := uFacCliP:nImporte
      nTotCob        := uFacCliP:nImpCob
      lRecCob        := uFacCliP:lCobrado
   else
      cDivPgo        := ( uFacCliP )->cDivPgo
      nTotRec        := ( uFacCliP )->nImporte
      nTotCob        := ( uFacCliP )->nImpCob
      lRecCob        := ( uFacCliP )->lCobrado
   end if

   if ValType( uDiv ) == "O"
      cDbfDiv        := uDiv:cAlias
   else
      cDbfDiv        := uDiv
   end if

   nRouDiv           := nRouDiv( cDivPgo, cDbfDiv )
   cPorDiv           := cPorDiv( cDivPgo, cDbfDiv )

   if lRecCob

      if nTotCob != 0
         nTotRec     -= nTotCob
         nTotRec     := Round( nTotRec, nRouDiv )
      else
         nTotRec     := 0
      end if

   else

      nTotRec        := 0

   end if

   if cDivRet != cDivPgo
      nRouDiv        := nRouDiv( cDivRet, cDbfDiv )
      cPorDiv        := cPorDiv( cDivRet, cDbfDiv )
      nTotRec        := nCnv2Div( nTotRec, cDivPgo, cDivRet, cDbfDiv )
   end if

RETURN if( lPic, Trans( nTotRec, cPorDiv ), nTotRec )

//------------------------------------------------------------------------//

function nImpRecCli( cFacCliP, cDbfDiv )

   local cImp

   DEFAULT cFacCliP     := dbfFacCliP
   DEFAULT cDbfDiv      := dbfDiv

   if ( cFacCliP )->lImpEur
      cImp           := nTotRecCli( cFacCliP, cDbfDiv, "EUR", .t. )
   else
      cImp           := nTotRecCli( cFacCliP, cDbfDiv, cDivEmp(), .t. )
   end if

RETURN ( cImp )

//------------------------------------------------------------------------//

function cTxtRecCli( cFacCliP, cDbfDiv )

   local cImp
   local lMas        := .t.

   DEFAULT cFacCliP  := dbfFacCliP
   DEFAULT cDbfDiv   := dbfDiv

   if ( cFacCliP )->lImpEur
      lMas           := lMasDiv( "EUR", dbfDiv )
      cImp           := Num2Text( nTotRecCli( cFacCliP, cDbfDiv, "EUR", .f. ), lMas )
   else
      lMas           := lMasDiv( ( cFacCliP )->cDivPgo, cDbfDiv )
      cImp           := Num2Text( nTotRecCli( cFacCliP, cDbfDiv, ( cFacCliP )->cDivPgo, .f. ), lMas )
   end if

RETURN ( cImp )

//------------------------------------------------------------------------//

Function cCtaRecCli( cFacCliP, cBncCli )

   DEFAULT cFacCliP     := dbfFacCliP
   DEFAULT cBncCli      := dbfBncCli

Return ( cClientCuenta( ( cFacCliP )->cCodCli, cBncCli ) )

//------------------------------------------------------------------------//
//
// Sincroniza los recibos con las facturas de clientes
//

function SynRecCli( cPath )

   local oBlock
   local oError
   local nTotFac
   local nTotRec
   local dbfFacCliT
   local dbfFacCliP
   local dbfFacCliL
   local dbfAntCliT
   local dbfFacRecT
   local dbfFacRecL
   local dbfDiv
   local dbfIva
   local dbfClient
   local dbfFPago

   DEFAULT cPath     := cPatEmp()

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPath + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliT", @dbfFacCliT ) )
   if !lAIS() ; ( dbfFacCliT )->( ordListAdd( ( cPath + "FACCLIT.CDX" ) ) ); else ; ordSetFocus( 1 ) ; end 

   USE ( cPath + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliL", @dbfFacCliL ) )
   if !lAIS() ; ( dbfFacCliL )->( ordListAdd( ( cPath + "FACCLIL.CDX" ) ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPath + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliP", @dbfFacCliP ) )
   if !lAIS() ; ( dbfFacCliP )->( ordListAdd( ( cPath + "FACCLIP.CDX" ) ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPath + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
   if !lAIS() ; ( dbfAntCliT )->( ordListAdd( ( cPath + "AntCliT.CDX" ) ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPath + "FACRECT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecT", @dbfFacRecT ) )
   if !lAIS() ; ( dbfFacRecT )->( ordListAdd( ( cPath + "FacRecT.CDX" ) ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPath + "FACRECL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacRecL", @dbfFacRecL ) )
   if !lAIS() ; ( dbfFacRecL )->( ordListAdd( ( cPath + "FacRecL.CDX" ) ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Client", @dbfClient ) )
   if !lAIS() ; ( dbfClient )->( ordListAdd( ( cPatCli() + "CLIENT.CDX" ) ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPagO", @dbfFPago ) )
   if !lAIS() ; ( dbfFPago )->( ordListAdd( ( cPatGrp() + "FPAGO.CDX" ) ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Divisas", @dbfDiv ) )
   if !lAIS() ; ( dbfDiv )->( ordListAdd( ( cPatDat() + "DIVISAS.CDX" ) ) ); else ; ordSetFocus( 1 ) ; end

   USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIva", @dbfIva ) )
   if !lAIS() ; ( dbfIva )->( ordListAdd( ( cPatDat() + "TIVA.CDX" ) ) ); else ; ordSetFocus( 1 ) ; end

   ( dbfFacCliP )->( dbGoTop() )
   while !( dbfFacCliP )->( eof() )

      // Casos raros ----------------------------------------------------------

      if ( dbfFacCliP )->nImpCob == 0 .and. ( dbfFacCliP )->lCobrado
         if dbLock( dbfFacCliP )
            ( dbfFacCliP )->nImpCob := ( dbfFacCliP )->nImporte
            ( dbfFacCliP )->( dbUnLock() )
         end if
      end if

      if Empty( ( dbfFacCliP )->cTurRec )
         if dbLock( dbfFacCliP )
            ( dbfFacCliP )->cTurRec := RetFld( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac, dbfFacCliT, "cTurFac" )
            ( dbfFacCliP )->( dbUnLock() )
         end if
      end if

      if !( ( dbfFacCliP )->cSerie >= "A" .and. ( dbfFacCliP )->cSerie <= "Z" )
         if dbLock( dbfFacCliP )
            ( dbfFacCliP )->( dbDelete() )
            ( dbfFacCliP )->( dbUnLock() )
         end if
      end if

      if Empty( ( dbfFacCliP )->cNomCli )
         if dbLock( dbfFacCliP )
            ( dbfFacCliP )->cNomCli := retClient( ( dbfFacCliP )->cCodCli, dbfClient )
            ( dbfFacCliP )->( dbUnLock() )
         end if
      end if

      if Empty( ( dbfFacCliP )->cCodCaj )

         if dbLock( dbfFacCliP )

            if ( dbfFacCliP )->cTipRec == "R"
               ( dbfFacCliP )->cCodCaj := RetFld( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac, dbfFacRecT, "CCODCAJ" )
            else
               ( dbfFacCliP )->cCodCaj := RetFld( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac, dbfFacCliT, "CCODCAJ" )
            end if

            ( dbfFacCliP )->( dbUnLock() )

         end if

      end if

      if Empty( ( dbfFacCliP )->cCodUsr )

         if dbLock( dbfFacCliP )

            if ( dbfFacCliP )->cTipRec == "R"
               ( dbfFacCliP )->cCodUsr := RetFld( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac, dbfFacRecT, "CCODUSR" )
            else
               ( dbfFacCliP )->cCodUsr := RetFld( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac, dbfFacCliT, "CCODUSR" )
            end if

            ( dbfFacCliP )->( dbUnLock() )

         end if

      end if

      ( dbfFacCliP )->( dbSkip() )

   end while

   ( dbfFacCliT )->( dbGoTop() )
   while !( dbfFacCliT )->( eof() )

      // Calculo de totales----------------------------------------------------

      nTotFac  := nTotFacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, nil, nil, .f. )
      nTotRec  := nPagFacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, dbfFacCliT, dbfFacCliP, dbfIva, dbfDiv, nil, .f. )

      // Si el importe de la factura es mayor q el de registros----------------

      if abs( nTotFac ) > abs( nTotRec )
         GenPgoFacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfClient, dbfFPago, dbfDiv, dbfIva, APPD_MODE, .f. )
      end if

      ChkLqdFacCli( nil, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv )

      ( dbfFacCliT )->( dbSkip() )

      SysRefresh()

   end while

   /*
   Facturas Rectificativas-----------------------------------------------------
   */

   ( dbfFacRecT )->( dbGoTop() )

   while !( dbfFacRecT )->( eof() )

      // Calculo de totales----------------------------------------------------

      nTotFac  := nTotFacRec( ( dbfFacRecT )->cSerie + Str( ( dbfFacRecT )->nNumFac ) + ( dbfFacRecT )->cSufFac, dbfFacRecT, dbfFacRecL, dbfIva, dbfDiv )
      nTotRec  := nPagFacRec( ( dbfFacRecT )->cSerie + Str( ( dbfFacRecT )->nNumFac ) + ( dbfFacRecT )->cSufFac, dbfFacRecT, dbfFacRecL, dbfFacCliP, dbfIva, dbfDiv )

      // Si el importe de la factura es mayor q el de registros----------------

      if abs( nTotFac ) > abs( nTotRec )
         GenPgoFacRec( ( dbfFacRecT )->cSerie + Str( ( dbfFacRecT )->nNumFac ) + ( dbfFacRecT )->cSufFac, dbfFacRecT, dbfFacRecL, dbfFacCliP, dbfClient, dbfFPago, dbfDiv, dbfIva, APPD_MODE, .f. )
      end if

      ChkLqdFacRec( nil, dbfFacRecT, dbfFacRecL, dbfFacCliP, dbfIva, dbfDiv )

      ( dbfFacRecT )->( dbSkip() )

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfFacCliT )
   CLOSE ( dbfFacCliL )
   CLOSE ( dbfFacCliP )
   CLOSE ( dbfAntCliT )
   CLOSE ( dbfFacRecT )
   CLOSE ( dbfFacRecL )
   CLOSE ( dbfDiv     )
   CLOSE ( dbfIva     )
   CLOSE ( dbfClient  )
   CLOSE ( dbfFPago   )

return nil

//------------------------------------------------------------------------//

/*
Exporta el recibos pendientes a EDM
*/

/*
N§ LC  LV  J  Descripci¢n       Observaciones
1  8   No  D  CODIGO            c¢digo de cliente. Empieza con '+'
2  10  No  I  FECHA             DD/MM/AAAA
3  10  No  I  N§ NOTA           AAA/NNNNNN
4  8   No  D  IMPORTE           Importe que queda pendiente de cobrar
5  1   No  I  TIPO DE NOTA      (1)

(1) Tipos de nota: 1- Factura Contado     2- Factura Credito
                  3- Albaran Contado     4- Albaran Credito
                  5- Adicional Contado   6- Adicional Credito
                  7- Indirecto Contado   8- Indirecto Credito

Ej: "+0000120@01/04/1996@003/123009@   90800@2"
*/

FUNCTION EdmRecCli( cCodRut, cPathTo, oStru )

   local oBlock
   local oError
   local n           := 0
   local cChr
   local cCod
   local fTar
   local cFilEdm
   local cFilOdb
   local nWrote
   local nRead
   local dbfFacCliP
   local dbfFacCliT

   DEFAULT cCodRut   := "001"
   DEFAULT cPathTo   := "C:\INTERS~1\"

   cCodRut           := SubStr( cCodRut, -3 )

   cFilEdm           := cPathTo + "EPEND" + cCodRut + ".TXT"
   cFilOdb           := cPathTo + "EPEND" + cCodRut + ".ODB"

   /*
   Creamos el fichero destino
   */

   if file( cFilEdm )
      fErase( cFilEdm )
   end if

   fTar              := fCreate( cFilEdm )

   /*
   Abrimos las bases de datos
   */

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbfFacCliP ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIP.CDX" ) ADDITIVE

   USE ( cPatEmp() + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" ) ADDITIVE

   oStru:oMetUno:cText   := "Pendientes de cobro"
   oStru:oMetUno:SetTotal( ( dbfFacCliP )->( LastRec() ) )

   WHILE !(dbfFacCliP)->( eof() )

      if !( dbfFacCliP )->lCobrado .and. (dbfFacCliP)->nImporte != 0

         cChr  := "+"
         cCod  := cCliFacCli( (dbfFacCliP)->CSERIE + Str( (dbfFacCliP)->NNUMFAC ) + (dbfFacCliP)->CSUFFAC, dbfFacCliT )
         cChr  += EdmRjust( cCod, "0", 7 )                                                            // Codigo de cliente
         cChr  += EdmSubStr( (dbfFacCliP)->DPRECOB, 1, 10 )                                           // Fecha de recibo
         cCod  := cAgeFacCli( (dbfFacCliP)->CSERIE + Str( (dbfFacCliP)->NNUMFAC ) + (dbfFacCliP)->CSUFFAC, dbfFacCliT )
         cChr  += EdmRjust( Right( cCod, 3 ) + "/" + AllTrim( Str( (dbfFacCliP)->nNumFac ) ), 1, 10 ) // Numero del recibo
         cChr  += EdmSubStr( Trans( (dbfFacCliP)->nImporte / (dbfFacCliP)->nVdvPgo, "99999999" ) )    // Importe
         cChr  += "1"                                                                                 // Tipo de nota de momento 1 factura de contado
         cChr  += CRLF

      end if

      nWrote:= fwrite( fTar, cChr, nRead )

      oStru:oMetUno:Set( ++n )

      /*
      IF fError() != 0
         msginfo( "Hay errores" )
      END IF
      */

      (dbfFacCliP)->( dbSkip() )

   END DO

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfFacCliP )
   CLOSE ( dbfFacCliT )
   fClose( fTar )

   if file( FullCurDir() + "CONVER.EXE" )
      WinExec( FullCurDir() + "CONVER.EXE " + cFilEdm + " " + cFilOdb + " 44 -x", 6 ) // Minimized
   end if

RETURN NIL

//---------------------------------------------------------------------------//
/*
NOMBRE FICHERO      : COBROxxx.PSI   (xxx = Agente)
DESCRIPCION         : COBROS
TIPO DE FICHERO     : SECUENCIAL SIN SEPARADOR DE CAMPOS
NUM. DE CAMPOS      : 7
LONG. DEL REGISTRO  : 51

N§ PO  LC  Descripci¢n       Observaciones
1  1   7   CODIGO CLIENTE
2  8   10  NUM. NOTA         aaa/nnnnnn    (agente/numeronota)
3  18  1   TIPO DE NOTA      (1)
4  19  10  NUM. RECIBO       aaa/nnnnnn    (agente/numerorecibo)
5  29  10  IMPORTE COBRADO
6  39  10  FECHA             DD/MM/AAAA
7  49  1   FORMA PAGO        (T)alon o (M)etalico
8  50  2   FINAL REGISTRO    CR LF


  (1) Tipos de nota: 1- Factura Contado     2- Factura Credito
                     3- Albaran Contado     4- Albaran Credito
                     5- Adicional Contado   6- Adicional Credito
                     7- Indirecto Contado   8- Indirecto Credito

       0        1         2         3         4         5
       12345678901234567890123456789012345678901234567890
  Ej: "0000131004/0003294003/000005     2340012/04/1996T"
      (recibo 5, del albar n de cr‚dito 329 emitido por el vendedor 4, cobrado
      por el vendedor 3 con fecha 12 de Abril de 1996, por importe de 23400.
      Se pag¢ mediante tal¢n)
*/

FUNCTION EdmCobCli( cCodRut, cPathTo, oStru, aSucces )

   local oBlock
   local oError
   local cLine
   local cFilEdm
   local oFilEdm
   local dFecDoc
   local cCodCli
   local nImpDoc
   local cNumDoc
   local nNumDoc
   local nNewCon
   local cNumFac
   local cTipDoc
   local cCodPgo     := ""
   local cCtaRec     := ""
   local dbfAlbCliT

   DEFAULT cCodRut   := "001"
   DEFAULT cPathTo   := "C:\INTERS~1\"

   cCodRut           := SubStr( cCodRut, -3 )

   cFilEdm           := cPathTo + "COBRO" + cCodRut + ".PSI"

   if !file( cFilEdm )
      msgWait( "No existe el fichero " + Rtrim( cFilEdm ), "Atención", 1 )
      return nil
   end if

   oFilEdm           := TTxtFile():New( cFilEdm )

   OpenFiles()

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIT", @dbfAlbCliT ) )
   SET ADSINDEX TO ( cPatEmp() + "ALBCLIT.CDX" ) ADDITIVE

   oStru:oMetDos:cText   := "Gestión de cobros"
   oStru:oMetDos:SetTotal( oFilEdm:nTLines )

   cLine             := oFilEdm:cLine

   while ! oFilEdm:lEoF()

      cCodCli        := SubStr( cLine,  1,  7 )
      cNumDoc        := SubStr( cLine,  8, 10 )
      nNumDoc        := Val( StrTran( cNumDoc, "/", "" ) )
      nImpDoc        := Val( SubStr( cLine, 29, 10 ) )
      dFecDoc        := Ctod( SubStr( cLine, 39, 10 ) )
      cTipDoc        := SubStr( cLine, 49,  1 )

      /*
      Localizamos el numero de la factura--------------------------------------
      */

      if ( dbfClient )->( dbSeek( cCodCli  ) )

         cNumFac     := RetFld( ( dbfClient )->Serie + Str( nNumDoc, 9 ) + RetSufEmp(), dbfAlbCliT, "cNumFac" )
         if !Empty( cNumFac )

            if cTipDoc $ "TM"

               if nChkPagFacCli( cNumFac, dbfFacCliT, dbfFacCliP ) != 1

                  if ( dbfFacCliT )->( dbSeek( cNumFac ) )

                     cCodPgo     := RetFld( ( dbfFacCliT )->cCodCli, dbfClient, "CODPAGO" )
                     if !Empty( cCodPgo )
                        cCtaRec  := RetFld( cCodPgo, dbfFPago, "CCTACOBRO" )
                     end if

                     nNewCon                    := nNewReciboCliente( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, Space( 1 ), dbfFacCliP )

                     ( dbfFacCliP )->( dbAppend() )
                     ( dbfFacCliP )->cSerie     := ( dbfFacCliT )->cSerie
                     ( dbfFacCliP )->nNumFac    := ( dbfFacCliT )->nNumFac
                     ( dbfFacCliP )->cSufFac    := ( dbfFacCliT )->cSufFac
                     ( dbfFacCliP )->nNumRec    := nNewCon
                     ( dbfFacCliP )->cCodCli    := ( dbfFacCliT )->cCodCli
                     ( dbfFacCliP )->cNomCli    := ( dbfFacCliT )->cNomCli
                     ( dbfFacCliP )->dEntrada   := dFecDoc
                     ( dbfFacCliP )->nImporte   := nImpDoc
                     ( dbfFacCliP )->cDescrip   := "Recibo nº" + Str( nNewCon, 2 ) + " de factura  " + ( dbfFacCliP )->cSerie + '/' + Alltrim( Str( ( dbfFacCliP )->nNumFac ) ) + '/' + ( dbfFacCliP )->cSufFac + '-' + Str( ( dbfFacCliP )->nNumRec )
                     ( dbfFacCliP )->dPreCob    := dFecDoc
                     ( dbfFacCliP )->lCobrado   := .t.
                     ( dbfFacCliP )->cTurRec    := cCurSesion()
                     ( dbfFacCliP )->cDivPgo    := cDivEmp()
                     ( dbfFacCliP )->nVdvPgo    := 1
                     ( dbfFacCliP )->cCtaRec    := cCtaRec
                     ( dbfFacCliP )->cCtaRem    := RetFld( ( dbfFacCliT )->cCodCli, dbfClient, "cCodRem" )
                     ( dbfFacCliP )->lRecImp    := .f.
                     ( dbfFacCliP )->dFecCre     := GetSysDate()
                     ( dbfFacCliP )->cHorCre     := SubStr( Time(), 1, 5 )

                     ChkLqdFacCli( nil, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv, .f. )

                     aAdd( aSucces, { .f., "Nuevo recibo de clientes " + ( dbfFacCliP )->cSerie + '/' + Str( ( dbfFacCliP )->nNumFac ) + '/' + ( dbfFacCliP )->cSufFac + '/' + Str( ( dbfFacCliP )->nNumRec ) } )

                  else

                     aAdd( aSucces, { .f., "Factura de clientes no existe " + ( dbfClient )->Serie + '/' + Str( nNumDoc, 9 ) + '/' + RetSufEmp() + " en recibo " + cNumDoc } )

                  end if

               else

                  aAdd( aSucces, { .f., "Factura ya liquidada " + ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac + " en recibo " + cNumDoc } )

               end if

            end if

         else

            aAdd( aSucces, { .f., "Albarán " + ( dbfClient )->Serie + Str( nNumDoc, 9 ) + RetSufEmp() + "no facturado" } )

         end if

      else

         aAdd( aSucces, { .f., "No existe cliente " + cCodCli + " en recibo " + cNumDoc } )

      end if

      oFilEdm:Skip()

      oStru:oMetDos:SetTotal( oFilEdm:nLine )

      cLine    := oFilEdm:cLine

   end do

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CloseFiles()
   ( dbfAlbCliT )->( dbCloseArea() )

   oFilEdm:Close()

RETURN ( aSucces )

//---------------------------------------------------------------------------//

static function lGenRecCli( oBrw, oBtn, nDevice )

   local bAction
   local nOrdAnt     := ( dbfDoc )->( OrdSetFocus( "cTipo" ) )

   DEFAULT nDevice   := IS_PRINTER

   IF !( dbfDoc )->( dbSeek( "RF" ) )

      DEFINE BTNSHELL RESOURCE "DOCUMENT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay recibos de clientes predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   ELSE

      WHILE ( dbfDoc )->CTIPO == "RF" .AND. !( dbfDoc )->( eof() )

         bAction  := bGenRecCli( nDevice, ( dbfDoc )->CODIGO, "Imprimiendo recibos de clientes" )

         oWndBrw:NewAt( "Document", , , bAction, Rtrim( ( dbfDoc )->cDescrip ) , , , , , oBtn )

         ( dbfDoc )->( dbSkip() )

      END DO

   END IF

   ( dbfDoc )->( OrdSetFocus( nOrdAnt ) )

return nil

//---------------------------------------------------------------------------//

static function bGenRecCli( nDevice, cCodDoc, cTitle )

   local nDev  := by( nDevice )
   local cCod  := by( cCodDoc   )
   local cTit  := by( cTitle    )

return {|| ImpPago( nil, nDev, cCod, cTit ) }

//---------------------------------------------------------------------------//

FUNCTION BrwRecCli( uGet, dbfFacCliP, dbfClient, dbfDiv, oBandera )

	local oDlg
	local oBrw
	local aGet1
	local cGet1
   local nOrd        := GetBrwOpt( "BrwRecCli" )
	local nOrdAnt
	local oCbxOrd
   local cCbxOrd
   local aCbxOrd     := {  "Número",;
                           "Código cliente",;
                           "Nombre cliente",;
                           "Fecha expedición",;
                           "Fecha vencimiento",;
                           "Fecha cobro",;
                           "Importe" }

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   nOrdAnt           := ( dbfFacCliP )->( OrdSetFocus( nOrd ) )

   ( dbfFacCliP )->( dbSetFilter( {|| !Field->lCobrado }, "!lCobrado" ) )
   ( dbfFacCliP )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Recibos de clientes"

		REDEFINE GET aGet1 VAR cGet1;
			ID 		104 ;
			PICTURE	"@!" ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfFacCliP, .f. ) );
         VALID    ( OrdClearScope( oBrw, dbfFacCliP ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfFacCliP )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), aGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                    := IXBrowse():New( oDlg )

      oBrw:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias             := dbfFacCliP
      oBrw:cName              := "Browse de recibos de cliente"
      oBrw:bLDblClick         := {|| oDlg:end( IDOK ) }

      oBrw:nMarqueeStyle      := 5

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader             := "Cn. Contabilizado"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfFacCliP )->lConPgo }
         :nWidth              := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Co. Cobrado"
         :bStrData            := {|| "" }
         :bEditValue          := {|| ( dbfFacCliP )->lCobrado }
         :nWidth              := 20
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Número"
         :bEditValue          := {|| ( dbfFacCliP )->cSerie + "/" + AllTrim( Str( ( dbfFacCliP )->nNumFac ) ) + "/" + ( dbfFacCliP )->cSufFac + "-" + Str( ( dbfFacCliP )->nNumRec ) }
         :nWidth              := 95
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Código cliente"
         :bEditValue          := {|| ( dbfFacCliP )->cCodCli }
         :nWidth              := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Nombre cliente"
         :bEditValue          := {|| ( dbfFacCliP )->cNomCli }
         :nWidth              := 170
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Importe " + cDivEmp()
         :bEditValue          := {|| nTotRecCli( dbfFacCliP, dbfDiv, cDivEmp(), .t. ) }
         :nWidth              := 85
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Div."
         :bEditValue          := {|| cSimDiv( ( dbfFacCliP )->cDivPgo, dbfDiv ) }
         :nWidth              := 30
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| ( dbfFacCliP )->cDescrip }
         :nWidth              := 150
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha expedición"
         :bEditValue          := {|| Dtoc( ( dbfFacCliP )->dPreCob ) }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha vencimiento"
         :bEditValue          := {|| Dtoc( ( dbfFacCliP )->dFecVto ) }
         :nWidth              := 80
         :lHide               := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader             := "Fecha cobro"
         :bEditValue          := {|| Dtoc( ( dbfFacCliP )->dEntrada ) }
         :nWidth              := 80
         :lHide               := .t.
      end with

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
         WHEN     ( .f. );

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( .f. );

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER ON INIT oBrw:Load()

   SetBrwOpt( "BrwRecCli", ( dbfFacCliP )->( OrdNumber() ) )

   if oDlg:nResult == IDOK

      if ValType( uGet ) == "O"
         uGet:cText( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ) )
         uGet:lValid()
         uGet:SetFocus()
      elseif ValType( uGet ) == "C"
         uGet     := ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec )
      end if

   end if

   /*
   Limpiamos la tabla antes de marcharnos--------------------------------------
   */

   OrdClearScope( nil, dbfFacCliP )

   ( dbfFacCliP )->( dbClearFilter() )

   ( dbfFacCliP )->( OrdSetFocus( nOrdAnt ) )

   /*
   Guardamos los datos del browse----------------------------------------------
   */

   oBrw:CloseData()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

FUNCTION aCalRecCli()

   local aCalRecCli  := {}

   aAdd( aCalRecCli, {"nImpRecCli( cDbfRec, cDbfDiv )", "N", 16, 6, "Importe del recibo", "cPorDivRec",  "", "" } )
   aAdd( aCalRecCli, {"cTxtRecCli( cDbfRec, cDbfDiv )", "C",100, 0, "Importe en letras",  "",            "", "" } )
   aAdd( aCalRecCli, {"nTotFac",                        "N", 16, 6, "Total factura",      "cPorDivRec",  "", "" } )

return ( aCalRecCli )

//---------------------------------------------------------------------------//

FUNCTION aDocRecCli()

   local aDoc  := {}

   /*
   Itmes-----------------------------------------------------------------------
   */

   aAdd( aDoc, { "Empresa",         "EM" } )
   aAdd( aDoc, { "Recibo",          "RF" } )
   aAdd( aDoc, { "Factura",         "FC" } )
   aAdd( aDoc, { "Cliente",         "CL" } )
   aAdd( aDoc, { "Formas de pago",  "PG" } )

RETURN ( aDoc )

//----------------------------------------------------------------------------//

static function lLiquida( oBrw )

   if !( dbfFacCliP )->lCobrado
      if ( dbfFacCliP )->( dbRLock() )
         ( dbfFacCliP )->lCobrado   := .t.
         ( dbfFacCliP )->dEntrada   := GetSysDate()
         ( dbfFacCliP )->cTurRec    := cCurSesion()
         ( dbfFacCliP )->( dbUnLock() )
      end if
   else
      msgStop( "Recibo ya pagado" )
   end if

   if oBrw != nil
      oBrw:Refresh()
   end if

return nil

//---------------------------------------------------------------------------//

/*
Genera los recibos de una factura
*/

FUNCTION GenPgoFacRec( cNumFac, dbfFacRecT, dbfFacRecL, dbfFacCliP, dbfCli, dbfFPago, dbfDiv, dbfIva, nMode, lMessage )

   local cCodPgo
   local cSerFac
   local nNumFac
   local cSufFac
   local cDivFac
   local nVdvFac
   local dFecFac
   local cCodCli
   local cNomCli
   local cCodAge
   local cCodCaj
   local cCodUsr
   local cCtaRem     := ""
   local nCobro      := 0
   local nTotal      := 0
   local nTotCob     := 0
   local nDec        := 0
   local nInc        := 0
   local nTotAcu     := 0
   local n           := 0
   local nPlazos     := 0
   local nRecCli
   local cBanco
   local cEntidad
   local cSucursal
   local cControl
   local cCuenta

   DEFAULT nMode     := APPD_MODE
   DEFAULT lMessage  := .t.

   cSerFac           := ( dbfFacRecT )->cSerie
   nNumFac           := ( dbfFacRecT )->nNumFac
   cSufFac           := ( dbfFacRecT )->cSufFac
   cDivFac           := ( dbfFacRecT )->cDivFac
   nVdvFac           := ( dbfFacRecT )->nVdvFac
   dFecFac           := ( dbfFacRecT )->dFecFac
   cCodPgo           := ( dbfFacRecT )->cCodPago
   cCodCli           := ( dbfFacRecT )->cCodCli
   cNomCli           := ( dbfFacRecT )->cNomCli
   cCodAge           := ( dbfFacRecT )->cCodAge
   cCodCaj           := ( dbfFacRecT )->cCodCaj
   cCodUsr           := ( dbfFacRecT )->cCodUsr
   cBanco            := ( dbfFacRecT )->cBanco
   cEntidad          := ( dbfFacRecT )->cEntBnc
   cSucursal         := ( dbfFacRecT )->cSucBnc
   cControl          := ( dbfFacRecT )->cDigBnc
   cCuenta           := ( dbfFacRecT )->cCtaBnc

   /*
   Cuenta de remesas-----------------------------------------------------------
   */

   nRecCli           := ( dbfCli )->( Recno() )

   if ( dbfCli )->( dbSeek( cCodCli ) )
      cCtaRem        := ( dbfCli )->cCodRem
   end if

   /*
   Decimales para el redondeo--------------------------------------------------
   */

   nDec              := nRouDiv( cDivFac, dbfDiv ) // Decimales de la divisa redondeada

   /*
   Comprobar q el total de factura  no es igual al de pagos--------------------
   */

   nTotal            := nTotFacRec( cNumFac, dbfFacRecT, dbfFacRecL, dbfIva, dbfDiv, nil, nil, .f. )
   nTotCob           := nPagFacRec( cNumFac, dbfFacRecT, dbfFacRecL, dbfFacCliP, dbfIva, dbfDiv, nil, .f. )

   if nTotal != nTotCob

      /*
      Si no hay recibos pagados eliminamos los recibos y se vuelven a generar--
      */

      if ( dbfFacCliP )->( dbSeek( cSerFac + Str( nNumFac ) + cSufFac ) )

         while cSerFac + Str( nNumFac ) + cSufFac == ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac .and. !( dbfFacCliP )->( eof() )

            if !Empty( ( dbfFacCliP )->cTipRec )

               if !( dbfFacCliP )->lCobrado .and. dbLock( dbfFacCliP )
                  ( dbfFacCliP )->( dbDelete() )
                  ( dbfFacCliP )->( dbUnLock() )
               else
                  nInc  := ( dbfFacCliP )->nNumRec
               end if

            end if

            ( dbfFacCliP )->( dbSkip() )

         end while

      end if

      /*
      Vamos a relizar pagos por la diferencia entre el total y lo cobrado
      */

      nTotal         -= nPagFacRec( cSerFac + Str( nNumFac ) + cSufFac, dbfFacRecT, dbfFacRecL, dbfFacCliP, dbfIva, dbfDiv, nil, .t. )

      /*
      Genera pagos----------------------------------------------------------
      */

      if ( dbfFPago )->( dbSeek( cCodPgo ) )

         nTotAcu        := nTotal
         nPlazos        := Max( ( dbfFPago )->nPlazos, 1 )

         for n := 1 to nPlazos

            if n != nPlazos
               nTotAcu  -= Round( nTotal / nPlazos, nDec )
            end if

            ( dbfFacCliP )->( dbAppend() )

            ( dbfFacCliP )->cSerie        := cSerFac
            ( dbfFacCliP )->nNumFac       := nNumFac
            ( dbfFacCliP )->cSufFac       := cSufFac
            ( dbfFacCliP )->nNumRec       := ++nInc
            ( dbfFacCliP )->cTipRec       := "R"
            ( dbfFacCliP )->cCodCaj       := cCodCaj
            ( dbfFacCliP )->cCodUsr       := cCodUsr
            ( dbfFacCliP )->cTurRec       := cCurSesion()
            ( dbfFacCliP )->cCodCli       := cCodCli
            ( dbfFacCliP )->cNomCli       := cNomCli

            if ( dbfFPago )->lUtlBnc
               ( dbfFacCliP )->cBncEmp    := ( dbfFPago )->cBanco
               ( dbfFacCliP )->cEntEmp    := ( dbfFPago )->cEntBnc
               ( dbfFacCliP )->cSucEmp    := ( dbfFPago )->cSucBnc
               ( dbfFacCliP )->cDigEmp    := ( dbfFPago )->cDigBnc
               ( dbfFacCliP )->cCtaEmp    := ( dbfFPago )->cCtaBnc
            end if

            ( dbfFacCliP )->cBncCli       := cBanco
            ( dbfFacCliP )->cEntCli       := cEntidad
            ( dbfFacCliP )->cSucCli       := cSucursal
            ( dbfFacCliP )->cDigCli       := cControl
            ( dbfFacCliP )->cCtaCli       := cCuenta

            ( dbfFacCliP )->nImporte      := if( n != nPlazos, Round( nTotal / nPlazos, nDec ), Round( nTotAcu, nDec ) )
            ( dbfFacCliP )->nImpCob       := if( n != nPlazos, Round( nTotal / nPlazos, nDec ), Round( nTotAcu, nDec ) )
            ( dbfFacCliP )->cDescrip      := "Recibo nº" + AllTrim( Str( nInc ) ) + " de factura rectificativa " + cSerFac  + '/' + allTrim( Str( nNumFac )  ) + '/' + cSufFac
            ( dbfFacCliP )->cDivPgo       := cDivFac
            ( dbfFacCliP )->nVdvPgo       := nVdvFac
            ( dbfFacCliP )->dPreCob       := dFecFac
            ( dbfFacCliP )->dFecVto       := dNexDay( dFecFac + ( dbfFPago )->nPlaUno + ( ( dbfFPago )->nDiaPla * ( n - 1 ) ), dbfCli )
            ( dbfFacCliP )->cCtaRec       := ( dbfFPago )->cCtaCobro
            ( dbfFacCliP )->cCtaGas       := ( dbfFPago )->cCtaGas
            ( dbfFacCliP )->cCtaRem       := cCtaRem
            ( dbfFacCliP )->cCodAge       := cCodAge
            ( dbfFacCliP )->lEsperaDoc    := ( dbfFPago )->lEsperaDoc

            if ( dbfFPago )->nCobRec == 1 .and. nMode == APPD_MODE
               ( dbfFacCliP )->lCobrado   := .t.
               ( dbfFacCliP )->cTurRec    := cCurSesion()
               ( dbfFacCliP )->dEntrada   := dNexDay( dFecFac + ( dbfFPago )->nPlaUno + ( ( dbfFPago )->nDiaPla * ( n - 1 ) ), dbfCli )
            end if

            ( dbfFacCliP )->dFecCre       := GetSysDate()
            ( dbfFacCliP )->cHorCre       := SubStr( Time(), 1, 5 )

            ( dbfFacCliP )->( dbUnLock() )

            /*
            Actualizamos el riesgo---------------------------------------------
            */

            if ( dbfFacCliP )->lCobrado
               DelRiesgo( ( dbfFacCliP )->nImporte, ( dbfFacCliP )->cCodCli, dbfCli )
            end if

         next

      else

         if lMessage
            MsgStop( "Forma de pago no encontrada" )
         end if

      end if

   end if

   ( dbfCli )->( dbGoTo( nRecCli ) )

RETURN NIL

//---------------------------------------------------------------------------//

Static Function EdtRecMenu( aTmp, oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar factura";
               MESSAGE  "Modificar la factura que creó el recibo" ;
               RESOURCE "Document_user1_16" ;
               ACTION   ( EdtFacCli( aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ] ) )

            SEPARATOR

            MENUITEM    "&2. Modificar cliente";
               MESSAGE  "Modifica la ficha del cliente" ;
               RESOURCE "User1_16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), EdtCli( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) )

            MENUITEM    "&3. Informe de cliente";
               MESSAGE  "Informe de cliente" ;
               RESOURCE "Info16" ;
               ACTION   ( if( !Empty( aTmp[ _CCODCLI ] ), InfCliente( aTmp[ _CCODCLI ] ), MsgStop( "Código de cliente vacío" ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

RETURN ( oMenu )

//---------------------------------------------------------------------------//

Static Function EndEdtRecMenu()

Return( oMenu:End() )

//---------------------------------------------------------------------------//

Function EdtRecCli( cNumFac, lOpenBrowse, lRectificativa )

   local nLevel            := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse     := .f.
   DEFAULT lRectificativa  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RecCli()
         if dbSeekInOrd( cNumFac, "nNumFac", dbfFacCliP )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", dbfFacCliP )
            WinEdtRec( nil, bEdit, dbfFacCliP, lRectificativa )
         else
            MsgStop( "No se encuentra recibo" + str( len( cNumFac ) ) )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ZooRecCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RecCli()
         if dbSeekInOrd( cNumFac, "nNumFac", dbfFacCliP )
            oWndBrw:RecZoom()
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( .t. )
         if dbSeekInOrd( cNumFac, "nNumFac", dbfFacCliP )
            WinZooRec( nil, bEdit, dbfFacCliP )
         end if
         CloseFiles()
      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION DelRecCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RecCli()
         if dbSeekInOrd( cNumFac, "nNumFac", dbfFacCliP )
            oWndBrw:RecDel()
         else
            MsgStop( "No se encuentra factura" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", dbfFacCliP )
            DelCobCli( nil, dbfFacCliP )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION PrnRecCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RecCli()
         if dbSeekInOrd( cNumFac, "nNumFac", dbfFacCliP )
            ImpPago( nil, IS_PRINTER )
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", dbfFacCliP )
            ImpPago( nil, IS_PRINTER )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION VisRecCli( cNumFac, lOpenBrowse )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_IMPR ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if RecCli()
         if dbSeekInOrd( cNumFac, "nNumFac", dbfFacCliP )
            ImpPago( nil, IS_SCREEN )
         else
            MsgStop( "No se encuentra recibo" )
         end if
      end if

   else

      if OpenFiles( .t. )

         if dbSeekInOrd( cNumFac, "nNumFac", dbfFacCliP )
            ImpPago( nil, IS_SCREEN )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

FUNCTION IntEdtRecCli( cNumFac )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_ZOOM ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if dbSeekInOrd( cNumFac, "nNumFac", dbfFacCliP )
      WinEdtRec( nil, bEdit, dbfFacCliP )
   else
      MsgStop( "No se encuentra recibo" )
   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ExtEdtRecCli( cFacCliP, cFacCliT, cFacCliL, cAntCliT, cPgo, cAge, cCaj, cIva, cDiv, oCta, oBcn, lRectificativa )

   local nLevel            := nLevelUsr( _MENUITEM_ )

   DEFAULT lRectificativa  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   dbfFacCliP              := cFacCliP
   dbfFacCliT              := cFacCliT
   dbfFacCliL              := cFacCliL
   dbfAntCliT              := cAntCliT
   dbfFPago                := cPgo
   dbfAgent                := cAge
   dbfCajT                 := cCaj
   dbfIva                  := cIva
   dbfDiv                  := cDiv

   oCtaRem                 := oCta

   WinEdtRec( nil, bEdit, cFacCliP, lRectificativa )

Return .t.

//----------------------------------------------------------------------------//

FUNCTION ExtDelRecCli( cFacCliP )

   local nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_DELE ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   DelCobCli( nil, cFacCliP )

Return .t.

//----------------------------------------------------------------------------//

STATIC FUNCTION PrnSerie()

	local oDlg
   local oRad
   local nRad        := 1
   local nCopPrn     := 1
   local oSerIni
   local oSerFin
   local oFmtRec
   local cFmtRec     := cSelPrimerDoc( "RF" )
   local oSayRec
   local cSayRec
   local lNotRem     := .f.
   local lNotImp     := .f.
   local lNotCob     := .f.
   local oCodPgo
   local cCodPgo     := Space( 3 )
   local oTxtPgo
   local cTxtPgo     := ""
   local nRecno      := ( dbfFacCliP )->( recno() )
   local nOrdAnt     := ( dbfFacCliP )->( OrdSetFocus( 1 ) )
   local dFecIni     := CtoD( "01/" + Str( Month( GetSysDate() ), 2 ) + "/" + Str( Year( Date() ) ) )
   local dFecFin     := GetSysDate()
   local cSerIni     := ( dbfFacCliP )->CSERIE
   local cSerFin     := ( dbfFacCliP )->CSERIE
   local nDocIni     := ( dbfFacCliP )->NNUMFAC
   local nDocFin     := ( dbfFacCliP )->NNUMFAC
   local cSufIni     := ( dbfFacCliP )->CSUFFAC
   local cSufFin     := ( dbfFacCliP )->CSUFFAC
   local nNumIni     := ( dbfFacCliP )->NNUMREC
   local nNumFin     := ( dbfFacCliP )->NNUMREC
   local oPrinter
   local cPrinter    := PrnGetName()

   cSayRec           := cNombreDoc( cFmtRec )

   DEFINE DIALOG oDlg RESOURCE "IMPSERREC"

   REDEFINE RADIO oRad VAR nRad ;
      ID       90, 91 ;
      OF       oDlg

   REDEFINE GET oFmtRec VAR cFmtRec ;
      ID       100 ;
      VALID    ( cDocumento( oFmtRec, oSayRec, dbfDoc ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtRec, oSayRec, "RF" ) ) ;
      OF       oDlg

   REDEFINE GET oSayRec VAR cSayRec ;
      ID       101 ;
      WHEN     ( .f. );
      OF       oDlg

   TBtnBmp():ReDefine( 92, "Printer_pencil_16",,,,,{|| EdtDocumento( cFmtRec ) }, oDlg, .f., , .f.,  )

   REDEFINE GET dFecIni ;
      ID       110 ;
      SPINNER ;
      WHEN     ( nRad == 1 ) ;
      OF       oDlg

   REDEFINE GET dFecFin ;
      ID       120 ;
      SPINNER ;
      WHEN     ( nRad == 1 ) ;
      OF       oDlg

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       130 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      WHEN     ( nRad == 2 ) ;
      VALID    ( cSerIni >= "A" .AND. cSerIni <= "Z"  );
      OF       oDlg

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       170 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      WHEN     ( nRad == 2 ) ;
      VALID    ( cSerFin >= "A" .AND. cSerFin <= "Z"  );
      OF       oDlg

   REDEFINE GET nDocIni;
      ID       140 ;
      PICTURE  "999999999" ;
      SPINNER ;
      WHEN     ( nRad == 2 ) ;
		OF 		oDlg

   REDEFINE GET nDocFin;
      ID       180 ;
      PICTURE  "999999999" ;
      SPINNER ;
      WHEN     ( nRad == 2 ) ;
		OF 		oDlg

   REDEFINE GET cSufIni ;
      ID       150 ;
      PICTURE  "##" ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET cSufFin ;
      ID       190 ;
      PICTURE  "##" ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET nNumIni ;
      ID       160 ;
      PICTURE  "99" ;
      WHEN     ( nRad == 2 ) ;
		OF 		oDlg

   REDEFINE GET nNumFin ;
      ID       200 ;
      PICTURE  "99" ;
      WHEN     ( nRad == 2 ) ;
		OF 		oDlg

   REDEFINE GET oPrinter VAR cPrinter;
      WHEN     ( .f. ) ;
      ID       320 ;
      OF       oDlg

   TBtnBmp():ReDefine( 321, "Printer_preferences_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

   // Formas de pago_____________________________________________________________________

   REDEFINE GET oCodPgo VAR cCodPgo;
      ID       210 ;
      PICTURE  "@!" ;
      VALID    ( cFPago( oCodPgo, dbfFPago, oTxtPgo ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwFPago( oCodPgo, oTxtPgo ) );
      OF       oDlg

   REDEFINE GET oTxtPgo VAR cTxtPgo;
      ID       220 ;
      WHEN     .f. ;
      OF       oDlg

   REDEFINE CHECKBOX lNotRem;
      ID       230 ;
		OF 		oDlg

   REDEFINE CHECKBOX lNotImp;
      ID       240 ;
		OF 		oDlg

   REDEFINE CHECKBOX lNotCob;
      ID       250 ;
		OF 		oDlg

   REDEFINE GET nCopPrn;
      ID       260 ;
      VALID    nCopPrn > 0 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      MIN      1 ;
      MAX      99999 ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   (  StartPrint( SubStr( cFmtRec, 1, 3 ), nRad, dFecIni, dFecFin, cSerIni + Str( nDocIni, 9 ) + cSufIni + Str( nNumIni, 2 ), cSerFin + Str( nDocFin, 9 ) + cSufFin + Str( nNumFin, 2 ), cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, cPrinter, oDlg ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| StartPrint( SubStr( cFmtRec, 1, 3 ), nRad, dFecIni, dFecFin, cSerIni + Str( nDocIni, 9 ) + cSufIni + Str( nNumIni, 2 ), cSerFin + Str( nDocFin, 9 ) + cSufFin + Str( nNumFin, 2 ), cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, cPrinter, oDlg ), oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   ( dbfFacCliP )->( dbGoTo( nRecNo ) )
   ( dbfFacCliP )->( ordSetFocus( nOrdAnt ) )

	oWndBrw:oBrw:refresh()

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION StartPrint( cCodDoc, nRad, dFecIni, dFecFin, cDocIni, cDocFin, cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, cPrinter, oDlg )

   local oInf
   local nOrd
   local oDevice
   local cCaption       := 'Imprimiendo recibos'

   if Empty( cCodDoc )
      return nil
   end if

   private cDbfRec      := dbfFacCliP
   private cDbf         := dbfFacCliT
   private cCliente     := dbfClient
   private cDbfCli      := dbfClient
   private cFPago       := dbfFPago
   private cDbfPgo      := dbfFPago
   private cDbfAge      := dbfAgent
   private cDbfDiv      := dbfDiv
   private cPorDivRec   := cPorDiv( ( dbfFacCliP )->cDivPgo, dbfDiv )

   oDlg:Disable()

   if lVisualDocumento( cCodDoc, dbfDoc )

      if nRad == 1
         nOrd           := ( dbfFacCliP )->( OrdSetFocus( "dPreCob" ) )
         ( dbfFacCliP )->( dbSeek( dFecIni, .t. ) )
      else
         nOrd           := ( dbfFacCliP )->( OrdSetFocus( "nNumFac" ) )
         ( dbfFacCliP )->( dbSeek( cDocIni, .t. ) )
      end if

      while !( dbfFacCliP )->( eof() )

         if (  if( nRad == 1, ( ( dbfFacCliP )->dPreCob >= dFecIni .and. ( dbfFacCliP )->dPreCob <= dFecFin ), .t. )                 .and. ;
               if( nRad == 2, ( ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC ) + ( dbfFacCliP )->CSUFFAC + Str( ( dbfFacCliP )->nNumRec ) >= cDocIni .and. ;
                                ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC ) + ( dbfFacCliP )->CSUFFAC + Str( ( dbfFacCliP )->nNumRec ) <= cDocFin ), .t. )  .and. ;
               if( !Empty( cCodPgo ), cCodPgo == cPgoFacCli( ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC, dbfFacCliT ), .t. ) .and.;
               if( lNotRem, ( dbfFacCliP )->nNumRem == 0 .and. Empty( ( dbfFacCliP )->cSufRem ), .t. )                                 .and. ;
               if( lNotImp, !( dbfFacCliP )->lRecImp, .t. )                                                                            .and. ;
               if( lNotCob, !( dbfFacCliP )->lCobrado, .t. ) )

            // Posicionamos en ficheros auxiliares

            if dbLock( dbfFacCliP )
               ( dbfFacCliP )->lRecImp    := .t.
               ( dbfFacCliP )->dFecImp    := GetSysDate()
               ( dbfFacCliP )->cHorImp    := SubStr( Time(), 1, 5 )
               ( dbfFacCliP )->( dbUnLock() )
            end if

            ( dbfFacCliT)->( dbSeek( ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC ) + ( dbfFacCliP )->CSUFFAC ) )
            ( dbfClient )->( dbSeek( ( dbfFacCliT )->CCODCLI ) )
            ( dbfFPago  )->( dbSeek( ( dbfFacCliT )->CCODPAGO ) )

            // Imprimir el documento

            PrintReportRecCli( IS_PRINTER, nCopPrn, nil, dbfDoc )

         end if

         ( dbfFacCliP )->( dbSkip() )

      end while

   else

      if !Empty( cPrinter )
         oDevice           := TPrinter():New( cCaption, .f., .t., cPrinter )
         REPORT oInf CAPTION cCaption TO DEVICE oDevice
      else
         REPORT oInf CAPTION cCaption PREVIEW
      end if

      // Cabeceras del listado

      if !Empty( oInf ) .and. oInf:lCreated
         oInf:lFinish      := .f.
         oInf:lAutoland    := .t.
         oInf:lNoCancel    := .t.
         oInf:bSkip        := {|| Skipping( nRad, dFecIni, dFecFin, cDocIni, cDocFin, cCodDoc, cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, oInf ) }

         oInf:oDevice:lPrvModal  := .t.

         oInf:bPreview     := {| oDevice | PrintPreview( oDevice ) }

      end if

      SetMargin(  cCodDoc, oInf )
      PrintColum( cCodDoc, oInf )

      END REPORT

      if !Empty( oInf )

         ACTIVATE REPORT oInf WHILE ( !( dbfFacCliP )->( eof() ) ) // ON STARTPAGE ( eItems( cCodDoc, oInf ) )

         oInf:oDevice:end()

      end if

      oInf                          := nil

   end if

   oDlg:Enable()

RETURN NIL

//--------------------------------------------------------------------------//

Static Function Skipping( nRad, dFecIni, dFecFin, cDocIni, cDocFin, cCodDoc, cCodPgo, lNotRem, lNotImp, lNotCob, nCopPrn, oInf )

   local nOrd
   local nCopYet  := 0
   local nImpYet  := 0
   local nDocPag  := 0
   local nLenPag  := 0
   local nLenDoc  := 0
   local nOffset  := 0

   if ( dbfDoc )->( dbSeek( cCodDoc ) )
      nLenPag     := ( dbfDoc )->nLenPag
      nLenDoc     := ( dbfDoc )->nLenDoc
      if nLenPag != 0 .and. nLenDoc != 0
         nDocPag  := Int( nLenPag / nLenDoc )
      end if
   end if

   if nRad == 1
      nOrd        := ( dbfFacCliP )->( OrdSetFocus( "dPreCob" ) )
      ( dbfFacCliP )->( dbSeek( dFecIni, .t. ) )
   else
      nOrd        := ( dbfFacCliP )->( OrdSetFocus( "nNumFac" ) )
      ( dbfFacCliP )->( dbSeek( cDocIni, .t. ) )
   end if

   while !( dbfFacCliP )->( eof() )

      if (  if( nRad == 1, ( ( dbfFacCliP )->dPreCob >= dFecIni .and. ( dbfFacCliP )->dPreCob <= dFecFin ), .t. )                 .and. ;
            if( nRad == 2, ( ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC ) + ( dbfFacCliP )->CSUFFAC + Str( ( dbfFacCliP )->nNumRec ) >= cDocIni .and. ;
                             ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC ) + ( dbfFacCliP )->CSUFFAC + Str( ( dbfFacCliP )->nNumRec ) <= cDocFin ), .t. )  .and. ;
            if( !Empty( cCodPgo ), cCodPgo == cPgoFacCli( ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC, dbfFacCliT ), .t. ) .and.;
            if( lNotRem, ( dbfFacCliP )->nNumRem == 0 .and. Empty( ( dbfFacCliP )->cSufRem ), .t. )                                 .and. ;
            if( lNotImp, !( dbfFacCliP )->lRecImp, .t. )                                                                            .and. ;
            if( lNotCob, !( dbfFacCliP )->lCobrado, .t. ) )

         // Posicionamos en ficheros auxiliares

         if dbLock( dbfFacCliP )
            ( dbfFacCliP )->lRecImp    := .t.
            ( dbfFacCliP )->dFecImp    := GetSysDate()
            ( dbfFacCliP )->cHorImp    := SubStr( Time(), 1, 5 )
            ( dbfFacCliP )->( dbUnLock() )
         end if

         ( dbfFacCliT)->( dbSeek( ( dbfFacCliP )->CSERIE + Str( ( dbfFacCliP )->NNUMFAC ) + ( dbfFacCliP )->CSUFFAC ) )
         ( dbfClient )->( dbSeek( ( dbfFacCliT )->CCODCLI ) )
         ( dbfFPago  )->( dbSeek( ( dbfFacCliT )->CCODPAGO ) )

         nImpYet++
         if nImpYet > nDocPag
            oInf:EndPage()
            nImpYet  := 1
         end if

         nOffSet     := ( nImpYet - 1 ) * nLenDoc

         PrintItems( cCodDoc, oInf, nil, nOffSet )

      end if

      nCopYet++

      if nCopYet >= nCopPrn
         ( dbfFacCliP )->( dbSkip() )
         nCopYet     := 0
      end if

   end while

RETURN NIL

//--------------------------------------------------------------------------//


STATIC FUNCTION ImpPago( cNumRec, nDevice, cCodDoc, cCaption, nCopies )

   local oInf
   local cPrinter

   DEFAULT cNumRec      := ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac
   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo recibos"
   DEFAULT nCopies      := 1
   DEFAULT cCodDoc      := cFormatoDocumento( ( dbfFacCliP )->cSerie, "nRecCli", dbfCount )

   if Empty( cCodDoc )
      cCodDoc           := cFirstDoc( "RF", dbfDoc )
   end if

   if !lExisteDocumento( cCodDoc, dbfDoc )
      return nil
   end if

   /*
   Continuamos con la impresion------------------------------------------------
   */

   if lVisualDocumento( cCodDoc, dbfDoc )

      PrintReportRecCli( nDevice, nCopies, cPrinter, dbfDoc )

   else

      private cDbfRec      := dbfFacCliP
      private cDbf         := dbfFacCliT
      private cCliente     := dbfClient
      private cDbfCli      := dbfClient
      private cFPago       := dbfFPago
      private cDbfPgo      := dbfFPago
      private cDbfDiv      := dbfDiv
      private cDbfAge      := dbfAgent
      private cPorDivRec   := cPorDiv( ( dbfFacCliP )->cDivPgo, dbfDiv )
      private nTotFac      := nTotFacCli( cNumRec, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, , , .f. )

      // Posicionamos en ficheros auxiliares

      if Empty( ( dbfFacCliP )->cTipRec )
         ( dbfFacCliT)->( dbSeek( cNumRec ) )
         ( dbfClient )->( dbSeek( ( dbfFacCliP )->cCodCli ) )
         ( dbfFPago  )->( dbSeek( ( dbfFacCliT )->cCodPago ) )
      else
         ( dbfFacRecT)->( dbSeek( cNumRec ) )
         ( dbfClient )->( dbSeek( ( dbfFacCliP )->cCodCli ) )
         ( dbfFPago  )->( dbSeek( ( dbfFacRecT )->cCodPago ) )
      end if

      if Empty( cPrinter )
         REPORT oInf CAPTION cCaption PREVIEW
      else
         REPORT oInf CAPTION cCaption NAME cPrinter PREVIEW
      end if

      // Cabeceras del listado

      if oInf:lCreated
         oInf:lFinish      := .f.
         oInf:lAutoland    := .t.
         oInf:bSkip        := {|| ( dbfFacCliP )->( dbSkip() ) }

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

      ACTIVATE REPORT oInf WHILE ( .f. ) ON ENDPAGE ( eItems( cCodDoc, oInf ) )

      // oInf:End()

      if nDevice == IS_PRINTER
         oInf:oDevice:end()
      end if

      oInf                 := nil

   end if

   // Marcamos para impreso

   if dbLock( dbfFacCliP )
      ( dbfFacCliP )->lRecImp    := .t.
      ( dbfFacCliP )->dFecImp    := GetSysDate()
      ( dbfFacCliP )->cHorImp    := SubStr( Time(), 1, 5 )
      ( dbfFacCliP )->( dbUnLock() )
   end if

   /*
   Refrescamos la pantalla principal-------------------------------------------
   */

   if !Empty( oWndBrw )
      oWndBrw:Refresh()
   end if

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION eItems( cCodDoc, oInf )

   private nPagina      := oInf:nPage
	private lEnd			:= oInf:lFinish

   // Reposicionamos en las distintas areas

   PrintItems( cCodDoc, oInf )

RETURN NIL

//-------------------------------------------------------------------------//

Static Function bGenEdtRecCli( cDocumento, lFromFactura )

   local bGen
   local cDoc           := by( cDocumento )

   DEFAULT lFromFactura := .f.

   if lFromFactura
      bGen              := {|| EdtRecCli( cDoc, .f. ) }
   else
      bGen              := {|| IntEdtRecCli( cDoc ) }
   end if

return ( bGen )

//-------------------------------------------------------------------------//

#include "FastRepH.ch"

Static Function DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Recibos", ( dbfFacCliP )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Recibos", cItemsToReport( aItmRecCli() ) )

   oFr:SetWorkArea(     "Facturas", ( dbfFacCliT )->( Select() ) )
   oFr:SetFieldAliases( "Facturas", cItemsToReport( aItmFacCli() ) )

   oFr:SetWorkArea(     "Facturas rectificativas", ( dbfFacRecT )->( Select() ) )
   oFr:SetFieldAliases( "Facturas rectificativas", cItemsToReport( aItmFacRec() ) )

   oFr:SetWorkArea(     "Empresa", ( dbfEmp )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( dbfClient )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Formas de pago", ( dbfFpago )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Agentes", ( dbfAgent )->( Select() ) )
   oFr:SetFieldAliases( "Agentes", cItemsToReport( aItmAge() ) )

   oFr:SetWorkArea(     "Bancos", ( dbfBncCli )->( Select() ) )
   oFr:SetFieldAliases( "Bancos", cItemsToReport( aCliBnc() ) )

   oFr:SetMasterDetail( "Recibos", "Facturas",                 {|| ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac } )
   oFr:SetMasterDetail( "Recibos", "Facturas rectificativas",  {|| ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac } )
   oFr:SetMasterDetail( "Recibos", "Empresa",                  {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Recibos", "Clientes",                 {|| ( dbfFacCliP )->cCodCli } )
   oFr:SetMasterDetail( "Recibos", "Formas de pago",           {|| ( dbfFacCliP )->cCodPgo } )
   oFr:SetMasterDetail( "Recibos", "Agentes",                  {|| ( dbfFacCliP )->cCodAge } )
   oFr:SetMasterDetail( "Recibos", "Bancos",                   {|| ( dbfFacCliP )->cCodCli } )

   oFr:SetResyncPair(   "Recibos", "Facturas" )
   oFr:SetResyncPair(   "Recibos", "Facturas rectificativas" )
   oFr:SetResyncPair(   "Recibos", "Empresa" )
   oFr:SetResyncPair(   "Recibos", "Clientes" )
   oFr:SetResyncPair(   "Recibos", "Formas de pago" )
   oFr:SetResyncPair(   "Recibos", "Agentes" )
   oFr:SetResyncPair(   "Recibos", "Bancos" )

Return nil

//---------------------------------------------------------------------------//

Static Function VariableReport( oFr )

   oFr:DeleteCategory(  "Recibos" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Recibos", "Importe del recibo",       "CallHbFunc('nImpRecCli')" )
   oFr:AddVariable(     "Recibos", "Importe formato texto",    "CallHbFunc('cTxtRecCli')" )
   oFr:AddVariable(     "Recibos", "Total factura",            "CallHbFunc('nTotFactura')" )
   oFr:AddVariable(     "Recibos", "Total rectificativa",      "CallHbFunc('nTotRectificativa')" )
   oFr:AddVariable(     "Recibos", "Cuenta bancaria cliente",  "CallHbFunc('cCtaRecCli')" )

Return nil

//---------------------------------------------------------------------------//

Function DesignReportRecCli( oFr, dbfDoc )

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
                                                   "CallHbFunc('nTotRecCli');"                                 + Chr(13) + Chr(10) + ;
                                                   "end;"                                                      + Chr(13) + Chr(10) + ;
                                                   "begin"                                                     + Chr(13) + Chr(10) + ;
                                                   "end." )

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "CuerpoDocumento",   "MainPage", frxPageHeader )
         oFr:SetProperty(     "CuerpoDocumento",   "Top", 0 )
         oFr:SetProperty(     "CuerpoDocumento",   "Height", 300 )

         oFr:AddBand(         "CabeceraColumnas",  "MainPage", frxMasterData )
         oFr:SetProperty(     "CabeceraColumnas",  "Top", 300 )
         oFr:SetProperty(     "CabeceraColumnas",  "Height", 0 )
         oFr:SetProperty(     "CabeceraColumnas",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "CabeceraColumnas",  "DataSet", "Recibos" )

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

Function PrintReportRecCli( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr
   local cFilePdf       := cPatTmp() + "RecibosCliente" + StrTran( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac, " ", "" ) + ".Pdf"

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

                  :SetTypeDocument( "nRecCli" )
                  :SetDe(           uFieldEmpresa( "cNombre" ) )
                  :SetCopia(        uFieldEmpresa( "cCcpMai" ) )
                  :SetAdjunto(      cFilePdf )
                  :SetPara(         RetFld( ( dbfFacCliP )->cCodCli, dbfClient, "cMeiInt" ) )
                  :SetAsunto(       "Envio de recibo de cliente número " + StrTran( ( dbfFacCliP )->cSerie + "/" + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac + "-" + Str( ( dbfFacCliP )->nNumRec ), " ", "" ) )
                  :SetMensaje(      "Adjunto le remito nuestra factura de anticipo de cliente " + StrTran( ( dbfFacCliP )->cSerie + "/" + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac + "-" + Str( ( dbfFacCliP )->nNumRec ), " ", "" ) + Space( 1 ) )
                  :SetMensaje(      "de fecha " + Dtoc( ( dbfFacCliP )->dPreCob ) + Space( 1 ) )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      CRLF )
                  :SetMensaje(      "Reciba un cordial saludo." )

                  :GeneralResource( dbfFacCliP, aItmRecCli() )

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

function nTotFactura( cNumRec, cFacCliT, cFacCliL, cDbfIva, cDbfDiv, cFacCliP, cAntCliT )

   DEFAULT cNumRec   := ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac
   DEFAULT cFacCliT  := dbfFacCliT
   DEFAULT cFacCliL  := dbfFacCliL
   DEFAULT cDbfIva   := dbfIva
   DEFAULT cDbfDiv   := dbfDiv
   DEFAULT cFacCliP  := dbfFacCliP
   DEFAULT cAntCliT  := dbfAntCliT

Return ( nTotFacCli( cNumRec, cFacCliT, cFacCliL, cDbfIva, cDbfDiv, cFacCliP, cAntCliT, , , .f. ) )

//---------------------------------------------------------------------------//

function nTotRectificativa( cNumRec, cFacRecT, cFacRecL, cDbfIva, cDbfDiv )

   DEFAULT cNumRec   := ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac
   DEFAULT cFacRecT  := dbfFacRecT
   DEFAULT cFacRecL  := dbfFacRecL
   DEFAULT cDbfIva   := dbfIva
   DEFAULT cDbfDiv   := dbfDiv

Return ( nTotFacRec( cNumRec, cFacRecT, cFacRecL, cDbfIva, cDbfDiv, nil, nil, .f. ) )

//---------------------------------------------------------------------------//

#else

//----------------------------------------------------------------------------//
//Funciones de PDA
//----------------------------------------------------------------------------//

STATIC FUNCTION pdaOpenFiles( lExt )

   local lOpen    := .t.
   local oBlock   := ErrorBlock( { | oError | ApoloBreak( oError ) } )

   DEFAULT lExt   := .f.

   lExternal      := lExt

   BEGIN SEQUENCE

      USE ( cPatEmp() + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbfFacCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIP.CDX" ) ADDITIVE
      ( dbfFacCliP )->( OrdSetFocus( "fNumFac" ) )

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      pdaCloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION pdaCloseFiles()

   if dbfFacCliP != nil
      ( dbfFacCliP )->( dbCloseArea() )
   end if
   if dbfDiv != nil
      ( dbfDiv )->( dbCloseArea() )
   end if
   if dbfFacCliT != nil
      ( dbfFacCliT )->( dbCloseArea() )
   end if
   if dbfFacCliL != nil
      ( dbfFacCliL )->( dbCloseArea() )
   end if
   if dbfClient != nil
      ( dbfClient )->( dbCloseArea() )
   end if
   if dbfIva != nil
      ( dbfIva )->( dbCloseArea() )
   end if
   if dbfAntCliT != nil
      ( dbfAntCliT )->( dbCloseArea() )
   end if

   dbfFacCliP  := nil
   dbfDiv      := nil
   dbfFacCliT  := nil
   dbfFacCliL  := nil
   dbfClient   := nil
   dbfIva      := nil
   dbfAntCliT  := nil

RETURN .T.

//--------------------------------------------------------------------------//

FUNCTION IsRecCli( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "FacCliP.Dbf" )
      dbCreate( cPath + "FacCliP.Dbf", aSqlStruct( aItmRecCli() ), cDriver() )
   end if

   if !lExistTable( cPath + "FacCliP.Cdx" )

      rxRecCli( cPath )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Function pdaCobrosPendientes( CodCli )

   local oDlg
   local oBtn
   local oFont
   local oSayTit
   local oBrwPgo

   if Empty( CodCli )
      msgStop( "No se ha seleccionado ningún cliente." )
      return .f.
   end if

   if !pdaOpenFiles()
      return .f.
   end if

   ( dbfFacCliP )->( dbSetFilter( {|| Field->cCodCli == CodCli .and. !Field->lCobrado }, "Field->cCodCli == CodCli .and. !Field->lCobrado" ) )

   DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

   DEFINE DIALOG oDlg RESOURCE "PDA_COBROS_PENDIENTES"

   aDbfBmp              := {  LoadBitmap( GetResources(), "Sel16" ),;
                              LoadBitmap( GetResources(), "Cnt16"   ) }

      REDEFINE SAY oSayTit ;
         VAR      "Cobros pendientes" ;
         ID       110 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       100 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "cobros_pendientes_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

      oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE IBROWSE oBrwPgo ;
         FIELDS ;
                  If( ( dbfFacCliP )->lCobrado,  aDbfBmp[1], aDbfBmp[2] ) ,;
                  DtoC( ( dbfFacCliP )->dPreCob ) + CRLF + DtoC( ( dbfFacCliP )->dFecVto ),;
                  ( dbfFacCliP )->cSerie + "/" + AllTrim( Str( ( dbfFacCliP )->nNumFac ) ) + "/" + ( dbfFacCliP )->cSufFac + "-" + AllTrim( Str( ( dbfFacCliP )->nNumRec ) ),;
                  Trans( ( dbfFacCliP )->nImporte, "999999.99" );
         FIELDSIZES ;
                  17,;
                  70,;
                  70,;
                  70;
         HEAD ;
                  "Co. Cobrado",;
                  "Expedido" + CRLF + "Vencimiento",;
                  "Factura",;
                  "Importe";
         JUSTIFY  ;
                  .f.,;
                  .f.,;
                  .f.,;
                  .t. ;
         ALIAS    ( dbfFacCliP );
         ID       200 ;
         OF       oDlg

      ACTIVATE DIALOG oDlg ;
         ON INIT ( pdaMenuEditarCobro( oDlg, oBrwPgo, dbfFacCliP ) )

   pdaCloseFiles()

   oFont:End()

   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

return ( nil )

//---------------------------------------------------------------------------//

static function pdaMenuEditarCobro( oDlg, oBrwPgo, dbfFacCliP )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 240 ;
      BITMAPS  90 ; // bitmaps resoruces ID
      IMAGES   5     // number of images in the bitmap

      REDEFINE MENUITEM ID 250 OF oMenu ACTION ( pdaCobroRapido( oDlg, oBrwPgo, dbfFacCliP ), oBrwPgo:Refresh() )

      REDEFINE MENUITEM ID 260 OF oMenu ACTION ( WinEdtRec( oBrwPgo, bPdaEdit, dbfFacCliP, dbfDiv ), oBrwPgo:Refresh() )

      REDEFINE MENUITEM ID 270 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )

Return oMenu

//----------------------------------------------------------------------------//

FUNCTION pdaCobroRapido( oDlg, oBrwPgo, dbfFacCliP )

   if dbLock( dbfFacCliP )
      ( dbfFacCliP )->lCobrado   := .t.
      ( dbfFacCliP )->dEntrada   := GetSysDate()
      ( dbfFacCliP )->( dbUnLock() )
   end if

   if ( dbfFacCliT )->( dbSeek( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac ) )
      ChkLqdFacCli( nil, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv )
   end if

Return ( nil )

//----------------------------------------------------------------------------//

Static Function pdaEdtCob( aTmp, aGet, dbfTmpPgo, oBrw, dbfDiv, bValid, nMode )

	local oDlg
   local oBmpDiv
   local oGetAge
   local cGetAge     := cNbrAgent( ( dbfFacCliP )->cCodAge, dbfAgent )
   local oGetCaj
   local cGetCaj     := RetFld( ( dbfFacCliP )->cCodCaj, dbfCajT, "cNomCaj" )
   local oGetPgo
   local cGetPgo     := RetFld( ( dbfFacCliP )->cCodPgo, dbfFPago, "cDesPago" )
   local oGetSubCta
   local cGetSubCta
   local oGetCtaRem
   local cGetCtaRem
   local oGetSubGas
   local cGetSubGas
   local cPorDiv     := cPorDiv( aTmp[ _CDIVPGO ], dbfDiv )
   local oPago
   local cPago       := "Modificando recibo de factura"

   if nMode == EDIT_MODE
      if aTmp[ _LCLOPGO ] .and. !oUser():lAdministrador()
         msgStop( "Solo pueden modificar los recibos cerrados los administradores." )
         return .f.
      end if
   end if

   lPgdOld              := ( dbfFacCliP )->lCobrado .or. ( dbfFacCliP )->lRecDto
   nImpOld              := ( dbfFacCliP )->nImporte

   DEFINE DIALOG oDlg RESOURCE "PAGOS_PDA"

      REDEFINE GET aGet[ _CSERIE ] VAR aTmp[ _CSERIE ] ;
         ID       101 ;
         PICTURE  "@!" ;
         WHEN     ( .f. );
         OF       oDlg

      REDEFINE GET aGet[ _NNUMFAC ] VAR aTmp[ _NNUMFAC ];
         ID       102 ;
         PICTURE  "999999999" ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CSUFFAC ] VAR aTmp[ _CSUFFAC ];
         ID       103 ;
         WHEN     ( .F. ) ;
         OF       oDlg

      REDEFINE GET aGet[ _NNUMREC ] VAR aTmp[ _NNUMREC ];
         ID       104 ;
         PICTURE  "99" ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET aGet[ _DPRECOB ] VAR aTmp[ _DPRECOB ] ;
         ID       100 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _DFECVTO ] VAR aTmp[ _DFECVTO ] ;
         ID       110 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET aGet[ _CCODCLI ] VAR aTmp[ _CCODCLI ] ;
         ID       120 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CNOMCLI ] VAR aTmp[ _CNOMCLI ];
         ID       121 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET aGet[_CCODAGE] VAR aTmp[_CCODAGE] ;
         ID       130 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET oGetAge VAR cGetAge ;
         ID       131 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CCODPGO ] VAR aTmp[ _CCODPGO ] ;
         ID       140 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE GET oGetPgo VAR cGetPgo ;
         ID       141 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      REDEFINE CHECKBOX aGet[ _LCOBRADO ] VAR aTmp[ _LCOBRADO ];
         ID       150 ;
         ON CHANGE( ValCheck( aGet, aTmp ) ) ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _DENTRADA ] VAR aTmp[ _DENTRADA ] ;
         ID       151 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[_NIMPORTE] VAR aTmp[_NIMPORTE] ;
         ID       160 ;
         WHEN     ( .f. ) ;
         PICTURE  ( cPorDiv ) ;
			OF 		oDlg

      REDEFINE GET aGet[_NIMPCOB] VAR aTmp[_NIMPCOB] ;
         ID       170 ;
         WHEN     ( .f. ) ;
         PICTURE  ( cPorDiv ) ;
			OF 		oDlg

      REDEFINE GET aGet[_NIMPGAS] VAR aTmp[_NIMPGAS] ;
         ID       180 ;
         WHEN     ( .f. ) ;
         PICTURE  ( cPorDiv ) ;
			OF 		oDlg

      REDEFINE SAY oPago VAR cPago;
         ID       190 ;
         OF       oDlg

         oPago:SetColor( 0, nRGB( 255, 255, 255 )  )

   oDlg:Cargo  := {|| EndTrans( aTmp, aGet, dbfFacCliP, oBrw, oDlg, nMode ), oDlg:end( IDOK ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT ( pdaMenuEdtCob( oDlg ) )

   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

static function pdaMenuEdtCob( oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( Eval( oDlg:Cargo ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )

Return oMenu

//---------------------------------------------------------------------------//

#endif

//----------------------------------------------------------------------------//
//Funciones comunes del programa y PDA
//----------------------------------------------------------------------------//

/*
Regenera indices
*/

Function rxRecCli( cPath, oMeter )

   local dbfFacCliT

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "FACCLIP.DBF" )
      mkRecCli( cPath, oMeter, .f. )
   end if

   fEraseIndex( cPath + "FACCLIP.CDX" )

   dbUseArea( .t., cDriver(), cPath + "FACCLIP.DBF", cCheckArea( "FACCLIP", @dbfFacCliT ), .f. )

   if !( dbfFacCliT )->( neterr() )

      ( dbfFacCliT )->( __dbPack() )

      // "Número"

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "nNumFac", "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec", {|| Field->CSERIE + Str( Field->NNUMFAC ) + Field->CSUFFAC + Str( Field->NNUMREC ) + Field->cTipRec } ) )

      // "Código"

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cCodCli", "cCodCli", {|| Field->CCODCLI } ) )

      // "Nombre",;

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cNomCli", "cNomCli", {|| Field->cNomCli } ) )

      // Codog de clientes no cobrados

      ( dbfFacCliT )->( ordCondSet("!Deleted() .and. !Field->lCobrado", {|| !Deleted() .and. !Field->lCobrado } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "lCodCli", "cCodCli", {|| Field->cCodCli } ) )

      // "Expedición",;

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "dPreCob", "dPreCob", {|| Field->dPreCob } ) )

      // "Vencimiento",;

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "dFecVto", "dFecVto", {|| Field->dFecVto } ) )

      // "Cobro",;

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "dEntrada", "dEntrada", {|| Field->dEntrada } ) )

      // "Importe",;

      ( dbfFacCliT )->( ordCondSet( "!Deleted()", {|| !Deleted() }, , , , , , , , , , , .t. ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "nImporte", "nImporte", {|| Field->nImporte }, ) )

      // "Número + no cobrados",;

      ( dbfFacCliT )->( ordCondSet("!Deleted() .and. !lCobrado", {|| !Deleted() .and. !Field->lCobrado } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "pNumFac", "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec", {|| Field->CSERIE + Str( Field->NNUMFAC ) + Field->CSUFFAC + Str( Field->NNUMREC ) + Field->cTipRec } ) )

      // "Número + cobrados" ;

      ( dbfFacCliT )->( ordCondSet("!Deleted() .and. lCobrado", {|| !Deleted() .and. Field->lCobrado } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "tNumFac", "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec ) + cTipRec", {|| Field->CSERIE + Str( Field->NNUMFAC ) + Field->CSUFFAC + Str( Field->NNUMREC ) + Field->cTipRec } ) )

      // Numero de remesas

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "nNumRem", "Str( nNumRem ) + cSufRem", {|| Str( Field->nNumRem ) + Field->cSufRem } ) )

      // Numero de remesas

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "nNumCli", "Str( nNumRem ) + cSufRem + cCodCli", {|| Str( Field->nNumRem ) + Field->cSufRem + Field->cCodCli } ) )

      // Cuentas de remesas

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cCtaRem", "cCtaRem", {|| Field->CCTAREM }, ) )

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cCodAge", "cCodAge", {|| Field->CCODAGE } ) )

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "nNumCob", "Str( nNumCob ) + cSufCob", {|| Str( Field->NNUMCOB ) + Field->CSUFCOB } ) )

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cTurRec", "cTurRec + cSufFac + cCodCaj", {|| Field->CTURREC + Field->CSUFFAC + Field->cCodCaj } ) )

      ( dbfFacCliT )->( ordCondSet("!Deleted() .and. Empty( cTipRec )", {|| !Deleted() .and.  Empty( Field->cTipRec ) } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "fNumFac", "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec )", {|| Field->CSERIE + Str( Field->NNUMFAC ) + Field->CSUFFAC + Str( Field->NNUMREC ) } ) )

      ( dbfFacCliT )->( ordCondSet("!Deleted() .and. !Empty( cTipRec )", {|| !Deleted() .and.  !Empty( Field->cTipRec ) } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "rNumFac", "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec )", {|| Field->CSERIE + Str( Field->NNUMFAC ) + Field->CSUFFAC + Str( Field->NNUMREC ) } ) )

      ( dbfFacCliT )->( ordCondSet("!Deleted()", {|| !Deleted() } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "cRecDev", "cRecDev", {|| Field->CRECDEV } ) )

      ( dbfFacCliT )->( ordCondSet("!Deleted() .and. Field->lCobrado", {|| !Deleted() .and. Field->lCobrado } ) )
      ( dbfFacCliT )->( ordCreate( cPath + "FACCLIP.CDX", "lCtaBnc", "Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp", {|| Field->cEntEmp + Field->cSucEmp + Field->cDigEmp + Field->cCtaEmp } ) )

      ( dbfFacCliT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de recibos de clientes" )

   end if

RETURN NIL

//--------------------------------------------------------------------------//
/*
Crea los ficheros de la facturaci¢n
*/

FUNCTION mkRecCli( cPath, oMeter, lReindex )

   DEFAULT lReindex  := .t.

   if oMeter != NIL
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
   end if

   dbCreate( cPath + "FACCLIP.DBF", aSqlStruct( aItmRecCli() ), cDriver() )

   if lReindex
      rxRecCli( cPath )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION aItmRecCli()

   local aBasRecCli  := {}

   aAdd( aBasRecCli, {"cSerie"      ,"C",  1, 0, "Serie de factura",            "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nNumFac"     ,"N",  9, 0, "Número de factura",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cSufFac"     ,"C",  2, 0, "Sufijo de factura",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nNumRec"     ,"N",  2, 0, "Número del recibo",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cTipRec"     ,"C",  1, 0, "Tipo de recibo",              "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCodPgo"     ,"C",  2, 0, "Código de forma de pago",     "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCodCaj"     ,"C",  3, 0, "Código de caja",              "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cTurRec"     ,"C",  6, 0, "Sesión del recibo",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCodCli"     ,"C", 12, 0, "Código de cliente",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cNomCli"     ,"C", 80, 0, "Nombre de cliente",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dEntrada"    ,"D",  8, 0, "Fecha de cobro",              "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nImporte"    ,"N", 16, 6, "Importe",                     "cPorDivRec",         "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cDesCriP"    ,"C",100, 0, "Concepto del pago",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dPreCob"     ,"D",  8, 0, "Fecha de previsión de cobro", "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cPgdoPor"    ,"C", 50, 0, "Pagado por",                  "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cDocPgo"     ,"C", 50, 0, "Documento de pago",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lCobrado"    ,"L",  1, 0, "Lógico de cobrado",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cDivPgo"     ,"C",  3, 0, "Código de la divisa",         "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nVdvPgo"     ,"N", 10, 6, "Cambio de la divisa",         "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lConPgo"     ,"L",  1, 0, "Lógico de contabilizado",     "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCtaRec"     ,"C", 12, 0, "Cuenta de contabilidad",      "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nImpEur"     ,"N", 16, 6, "Importe del pago en Euros",   "cPorDivRec",         "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lImpEur"     ,"L",  1, 0, "Lógico cobrar en Euros",      "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nNumRem"     ,"N",  9, 0, "Número de la remesas",        "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cSufRem"     ,"C",  2, 0, "Sufijo de remesas",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCtaRem"     ,"C",  3, 0, "Cuenta de remesa",            "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lRecImp"     ,"L",  1, 0, "Lógico ya impreso",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lRecDto"     ,"L",  1, 0, "Lógico descontado",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dFecDto"     ,"D",  8, 0, "Fecha del descuento",         "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dFecVto"     ,"D",  8, 0, "Fecha de vencimiento",        "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCodAge"     ,"C",  3, 0, "Código del agente",           "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nNumCob"     ,"N",  9, 0, "Número de cobro",             "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cSufCob"     ,"C",  2, 0, "Sufijo del cobro",            "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nImpCob"     ,"N", 16, 6, "Importe del cobro",           "cPorDivRec",         "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"nImpGas"     ,"N", 16, 6, "Importe de gastos",           "cPorDivRec",         "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCtaGas"     ,"C", 12, 0, "Subcuenta de gastos",         "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lEsperaDoc"  ,"L",  1, 0, "Lógico a la espera de documentación","",            "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lCloPgo"     ,"L",  1, 0, "Lógico de turno cerrado",     "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dFecImp"     ,"D",  8, 0, "Última fecha de impresión" ,  "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cHorImp"     ,"C",  5, 0, "Hora de la última impresión" ,"",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lNotArqueo"  ,"L",  1, 0, "Lógico de no incluir en arqueo","",                 "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCodBnc"     ,"C",  4, 0, "Código del banco",            "",                   "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dFecCre"     ,"D",  8, 0, "Fecha de creación del registro" ,  "",              "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cHorCre"     ,"C",  5, 0, "Hora de creación del registro" ,"",                 "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCodUsr"     ,"C",  3, 0, "Código del usuario" ,"",                            "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lDevuelto"   ,"L",  1, 0, "Lógico recibo devuelto" ,"",                        "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"dFecDev"     ,"D",  8, 0, "Fecha devolución" ,"",                              "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cMotDev"     ,"C",250, 0, "Motivo devolución" ,"",                             "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cRecDev"     ,"C", 14, 0, "Recibo de procedencia" ,"",                         "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lSndDoc"     ,"L",  1, 0, "Lógico para envio" ,"",                             "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cBncEmp"     ,"C", 50, 0, "Banco de la empresa para el recibo" ,"",            "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cBncCli"     ,"C", 50, 0, "Banco del cliente para el recibo" ,"",              "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cEntEmp"     ,"C",  4, 0, "Entidad de la cuenta de la empresa",  "",           "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cSucEmp"     ,"C",  4, 0, "Sucursal de la cuenta de la empresa",  "",          "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cDigEmp"     ,"C",  2, 0, "Dígito de control de la cuenta de la empresa", "",  "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCtaEmp"     ,"C", 10, 0, "Cuenta bancaria de la empresa",  "",                "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cEntCli"     ,"C",  4, 0, "Entidad de la cuenta del cliente",  "",             "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cSucCli"     ,"C",  4, 0, "Sucursal de la cuenta del cliente",  "",            "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cDigCli"     ,"C",  2, 0, "Dígito de control de la cuenta del cliente", "",    "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"cCtaCli"     ,"C", 10, 0, "Cuenta bancaria del cliente",  "",                  "", "( cDbfRec )" } )
   aAdd( aBasRecCli, {"lRemesa"     ,"L",  1, 0, "Lógico de incluido en una remesa",  "",             "", "( cDbfRec )" } )

return ( aBasRecCli )

//---------------------------------------------------------------------------//

/*
Genera los recibos de una factura
*/
FUNCTION GenPgoFacCli( cNumFac, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfCli, dbfFPago, dbfDiv, dbfIva, nMode, lMessage )

   local cCodPgo
   local cSerFac
   local nNumFac
   local cSufFac
   local cDivFac
   local nVdvFac
   local dFecFac
   local cCodCli
   local cNomCli
   local cCodAge
   local cCodCaj
   local cCodUsr
   local cCtaRem     := ""
   local nCobro      := 0
   local nTotal      := 0
   local nTotCob     := 0
   local nDec        := 0
   local nInc        := 0
   local n           := 0
   local nTotAcu     := 0
   local nPlazos     := 1
   local nRecCli
   local cEntidad
   local cSucursal
   local cControl
   local cCuenta
   local cBanco
   local lAlert

   DEFAULT nMode     := APPD_MODE
   DEFAULT lMessage  := .t.

   lAlert            := ( nMode == APPD_MODE )

   cSerFac           := ( dbfFacCliT )->cSerie
   nNumFac           := ( dbfFacCliT )->nNumFac
   cSufFac           := ( dbfFacCliT )->cSufFac
   cDivFac           := ( dbfFacCliT )->cDivFac
   nVdvFac           := ( dbfFacCliT )->nVdvFac
   dFecFac           := ( dbfFacCliT )->dFecFac
   cCodPgo           := ( dbfFacCliT )->cCodPago
   cCodCli           := ( dbfFacCliT )->cCodCli
   cNomCli           := ( dbfFacCliT )->cNomCli
   cCodAge           := ( dbfFacCliT )->cCodAge
   cCodCaj           := ( dbfFacCliT )->cCodCaj
   cCodUsr           := ( dbfFacCliT )->cCodUsr
   cBanco            := ( dbfFacCliT )->cBanco
   cEntidad          := ( dbfFacCliT )->cEntBnc
   cSucursal         := ( dbfFacCliT )->cSucBnc
   cControl          := ( dbfFacCliT )->cDigBnc
   cCuenta           := ( dbfFacCliT )->cCtaBnc

   /*
   Cuenta de remesas-----------------------------------------------------------
   */

   nRecCli           := ( dbfCli )->( Recno() )

   if ( dbfCli )->( dbSeek( cCodCli ) )
      cCtaRem        := ( dbfCli )->cCodRem
   end if

   /*
   Decimales para el redondeo--------------------------------------------------
   */

   nDec              := nRouDiv( cDivFac, dbfDiv ) // Decimales de la divisa redondeada

   /*
   Comprobar q el total de factura  no es igual al de pagos--------------------
   */

   nTotal            := nTotFacCli( cNumFac, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, nil, nil, .f. )

   nTotCob           := nPagFacCli( cNumFac, dbfFacCliT, dbfFacCliP, dbfIva, dbfDiv, nil, .f. )

   /*
   Ya nos viene sin los anticipos
   */

   if lDiferencia( nTotal, nTotCob, 0.1 )

      /*
      Si no hay recibos pagados eliminamos los recibos y se vuelven a generar
      */

      if ( dbfFacCliP )->( dbSeek( cSerFac + Str( nNumFac ) + cSufFac ) )

         while cSerFac + Str( nNumFac ) + cSufFac == ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac

            if !( dbfFacCliP )->lCobrado .and. dbLock( dbfFacCliP )
               ( dbfFacCliP )->( dbDelete() )
               ( dbfFacCliP )->( dbUnLock() )
            else
               nInc  := ( dbfFacCliP )->nNumRec
            end if

            ( dbfFacCliP )->( dbSkip() )

         end while

      end if

      /*
      Vamos a relizar pagos por la diferencia entre el total y lo cobrado------
      */

      nTotal         -= nPagFacCli( cSerFac + Str( nNumFac ) + cSufFac, dbfFacCliT, dbfFacCliP, dbfIva, dbfDiv, nil, .t. )

      /*
      Genera pagos-------------------------------------------------------------
      */

      if ( dbfFPago )->( dbSeek( cCodPgo ) )

         nTotAcu        := nTotal
         nPlazos        := Max( ( dbfFPago )->nPlazos, 1 )

         for n := 1 to nPlazos

            if n != nPlazos
               nTotAcu  -= Round( nTotal / nPlazos, nDec )
            end if

            ( dbfFacCliP )->( dbAppend() )

            ( dbfFacCliP )->cTurRec       := cCurSesion()
            ( dbfFacCliP )->cSerie        := cSerFac
            ( dbfFacCliP )->nNumFac       := nNumFac
            ( dbfFacCliP )->cSufFac       := cSufFac
            ( dbfFacCliP )->nNumRec       := ++nInc
            ( dbfFacCliP )->cCodCaj       := cCodCaj
            ( dbfFacCliP )->cCodUsr       := cCodUsr
            ( dbfFacCliP )->cCodPgo       := cCodPgo
            ( dbfFacCliP )->cCodCli       := cCodCli
            ( dbfFacCliP )->cNomCli       := cNomCli

            if ( dbfFPago )->lUtlBnc
               ( dbfFacCliP )->cBncEmp    := ( dbfFPago )->cBanco
               ( dbfFacCliP )->cEntEmp    := ( dbfFPago )->cEntBnc
               ( dbfFacCliP )->cSucEmp    := ( dbfFPago )->cSucBnc
               ( dbfFacCliP )->cDigEmp    := ( dbfFPago )->cDigBnc
               ( dbfFacCliP )->cCtaEmp    := ( dbfFPago )->cCtaBnc
            end if

            ( dbfFacCliP )->cBncCli       := cBanco
            ( dbfFacCliP )->cEntCli       := cEntidad
            ( dbfFacCliP )->cSucCli       := cSucursal
            ( dbfFacCliP )->cDigCli       := cControl
            ( dbfFacCliP )->cCtaCli       := cCuenta

            ( dbfFacCliP )->nImporte      := if( n != nPlazos, Round( nTotal / nPlazos, nDec ), Round( nTotAcu, nDec ) )
            ( dbfFacCliP )->nImpCob       := if( n != nPlazos, Round( nTotal / nPlazos, nDec ), Round( nTotAcu, nDec ) )
            ( dbfFacCliP )->cDescrip      := "Recibo nº" + AllTrim( Str( nInc ) ) + " de factura " + cSerFac  + '/' + allTrim( Str( nNumFac ) ) + '/' + cSufFac

            ( dbfFacCliP )->cDivPgo       := cDivFac
            ( dbfFacCliP )->nVdvPgo       := nVdvFac
            ( dbfFacCliP )->dPreCob       := dFecFac
            ( dbfFacCliP )->dFecVto       := dNexDay( dFecFac + ( dbfFPago )->nPlaUno + ( ( dbfFPago )->nDiaPla * ( n - 1 ) ), dbfCli )

            ( dbfFacCliP )->cCtaRec       := ( dbfFPago )->cCtaCobro
            ( dbfFacCliP )->cCtaGas       := ( dbfFPago )->cCtaGas

            ( dbfFacCliP )->cCtaRem       := cCtaRem
            ( dbfFacCliP )->cCodAge       := cCodAge
            ( dbfFacCliP )->lEsperaDoc    := ( dbfFPago )->lEsperaDoc

            if ( dbfFPago )->nCobRec == 1 .and. nMode == APPD_MODE
               ( dbfFacCliP )->cTurRec    := cCurSesion()
               ( dbfFacCliP )->lCobrado   := .t.
               ( dbfFacCliP )->dEntrada   := dNexDay( dFecFac + ( dbfFPago )->nPlaUno + ( ( dbfFPago )->nDiaPla * ( n - 1 ) ), dbfCli )
            end if

            ( dbfFacCliP )->dFecCre       := GetSysDate()
            ( dbfFacCliP )->cHorCre       := SubStr( Time(), 1, 5 )

            lAlert                        := .f.

            ( dbfFacCliP )->( dbUnLock() )

         next

      else

         if lMessage
            MsgStop( "Forma de pago " + cCodPgo + " no encontrada, generando recibos" )
         end if

      end if

   end if

   ( dbfCli )->( dbGoTo( nRecCli ) )

   if ( lAlert .and. lMessage )
      msgWait( "Factura " + cSerFac  + '/' + allTrim( Str( nNumFac ) ) + '/' + cSufFac + " no se generaron recibos.", "Atención", 1 )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION dNexDay( dFecPgo, dbfCli )

   local nDay
   local nMon
   local nYea

   if Empty( dbfCli )
      Return ( dFecPgo )
   end if

   nDay        := Day( dFecPgo )
   nYea        := Year( dFecPgo )
   nMon        := Month( dFecPgo )

   if ( dbfCli )->DiaPago != 0

      /*
      Si el dia de vencimiento es mayor que el dia de pago summos un mes
      */

      if nDay > ( dbfCli )->DiaPago

         if nDay > ( dbfCli )->DiaPago2

            if nMon == 12
               nMon := 1
               nYea++
            else
               nMon++
            end if

            nDay := ( dbfCli )->DiaPago

         else

            nDay := ( dbfCli )->DiaPago2

         end if

      else

         nDay := ( dbfCli )->DiaPago

      end if

   end if

   /*
   Comporbar q el recibo no va en el mes de vacaciones
   */

   if ( ( dbfCli )->nMesVac - 1 ) == nMon

      if nMon == 12
         nMon := 1
         nYea++
      else
         nMon++
      end if

   end if

RETURN ( Ctod( Str( nDay, 2 ) + "/" + Str( nMon, 2 ) + "/" + Str( nYea, 4 ) ) )

//----------------------------------------------------------------------------//

Function ValCobro( aGet, aTmp )

   if aTmp[ _NIMPCOB ] <= aTmp[ _NIMPORTE ]

      if ( aTmp[ _NIMPCOB ] != 0 ) .and. ( aTmp[ _NIMPORTE ] != aTmp[ _NIMPCOB ] )
         aGet[ _NIMPGAS ]:cText( aTmp[ _NIMPORTE ] - aTmp[ _NIMPCOB ] )
      end if

      Return .t.

   else

      msgAlert( "El importe del cobro excede al importe del recibo" )

   end if

Return .f.

//---------------------------------------------------------------------------//

Function ValCheck( aGet, aTmp )

   if aTmp[ _LCOBRADO ]

      aGet[ _DENTRADA ]:cText( GetSysDate() )
      aGet[ _CTURREC  ]:cText( cCurSesion( nil, .f. ) )

      if aTmp[ _NIMPCOB ] == 0
         aGet[ _NIMPCOB ]:cText( aTmp[ _NIMPORTE ] )
      end if

   else

      aGet[ _DENTRADA ]:cText( Ctod( "" ) )

   end if

Return .t.

//---------------------------------------------------------------------------//

Function lValDevolucion( aGet, aTmp, lIntro )

   DEFAULT lIntro := .f.

   if aTmp[ _LDEVUELTO ]

      if !lIntro
         aGet[ _DFECDEV ]:cText( GetSysDate() )
      end if

      aGet[ _DPRECOB    ]:HardDisable()
      aGet[ _DFECVTO    ]:HardDisable()
      aGet[ _NIMPORTE   ]:HardDisable()
      aGet[ _NIMPCOB    ]:HardDisable()
      aGet[ _LCOBRADO   ]:HardDisable()
      aGet[ _DENTRADA   ]:HardDisable()
      aGet[ _CCODAGE    ]:HardDisable()
      aGet[ _CCODPGO    ]:HardDisable()
      aGet[ _CDESCRIP   ]:HardDisable()
      aGet[ _CPGDOPOR   ]:HardDisable()
      aGet[ _CDOCPGO    ]:HardDisable()
      aGet[ _NIMPGAS    ]:HardDisable()
      aGet[ _CCTAREC    ]:HardDisable()
      aGet[ _CCTAREM    ]:HardDisable()
      aGet[ _CCODCAJ    ]:HardDisable()
      aGet[ _LNOTARQUEO ]:HardDisable()
      aGet[ _LRECIMP    ]:HardDisable()
      aGet[ _DFECIMP    ]:HardDisable()
      aGet[ _CHORIMP    ]:HardDisable()
      aGet[ _LESPERADOC ]:HardDisable()
      aGet[ _CTURREC    ]:HardDisable()
      aGet[ _CBNCEMP    ]:HardDisable()
      aGet[ _CBNCCLI    ]:HardDisable()
      aGet[ _CENTEMP    ]:HardDisable()
      aGet[ _CSUCEMP    ]:HardDisable()
      aGet[ _CDIGEMP    ]:HardDisable()
      aGet[ _CCTAEMP    ]:HardDisable()
      aGet[ _CENTCLI    ]:HardDisable()
      aGet[ _CSUCCLI    ]:HardDisable()
      aGet[ _CDIGCLI    ]:HardDisable()
      aGet[ _CCTACLI    ]:HardDisable()

   else

      if !lIntro
         aGet[ _DFECDEV ]:cText( Ctod( "" ) )
         aGet[ _CMOTDEV ]:cText( Space( 250 ) )
      end if

      aGet[ _DPRECOB    ]:HardEnable()
      aGet[ _DFECVTO    ]:HardEnable()
      aGet[ _NIMPORTE   ]:HardEnable()
      aGet[ _NIMPCOB    ]:HardEnable()
      aGet[ _LCOBRADO   ]:HardEnable()
      aGet[ _DENTRADA   ]:HardEnable()
      aGet[ _CCODAGE    ]:HardEnable()
      aGet[ _CCODPGO    ]:HardEnable()
      aGet[ _CDESCRIP   ]:HardEnable()
      aGet[ _CPGDOPOR   ]:HardEnable()
      aGet[ _CDOCPGO    ]:HardEnable()
      aGet[ _NIMPGAS    ]:HardEnable()
      aGet[ _CCTAREC    ]:HardEnable()
      aGet[ _CCTAREM    ]:HardEnable()
      aGet[ _CCODCAJ    ]:HardEnable()
      aGet[ _LNOTARQUEO ]:HardEnable()
      aGet[ _LRECIMP    ]:HardEnable()
      aGet[ _DFECIMP    ]:HardEnable()
      aGet[ _CHORIMP    ]:HardEnable()
      aGet[ _LESPERADOC ]:HardEnable()
      aGet[ _CTURREC    ]:HardEnable()
      aGet[ _CBNCEMP    ]:HardEnable()
      aGet[ _CBNCCLI    ]:HardEnable()
      aGet[ _CENTEMP    ]:HardEnable()
      aGet[ _CSUCEMP    ]:HardEnable()
      aGet[ _CDIGEMP    ]:HardEnable()
      aGet[ _CCTAEMP    ]:HardEnable()
      aGet[ _CENTCLI    ]:HardEnable()
      aGet[ _CSUCCLI    ]:HardEnable()
      aGet[ _CDIGCLI    ]:HardEnable()
      aGet[ _CCTACLI    ]:HardEnable()

   end if

   if Empty( aTmp[ _CRECDEV ] )
      aGet[ _CRECDEV ]:Disable()
   else
      aGet[ _CRECDEV ]:Enable()
   end if

return .t.

//---------------------------------------------------------------------------//

Function DelCobCli( oBrw, dbfFacCliP )

   if ( dbfFacCliP )->lCloPgo .and. !oUser():lAdministrador()
      MsgStop( "Solo pueden eliminar los recibos cerrados los administradores." )
      return .f.
   end if

   if !Empty( ( dbfFacCliP )->nNumRem ) .and. !oUser():lAdministrador()
      msgStop( "Este tiket pertenece a una remesa de clientes.", "Imposible eliminar" )
      return .f.
   end if

   if !Empty( ( dbfFacCliP )->nNumCob ) .and. !oUser():lAdministrador()
      msgStop( "Este tiket pertenece a una remesa de cobros.", "Imposible eliminar" )
      return .f.
   end if

   if ( dbfFacCliP )->lCobrado .and. !oUser():lAdministrador()
      msgStop( "Este tiket esta cobrado.", "Imposible eliminar" )
      return .f.
   end if

   if ( dbfFacCliP )->lRecDto .and. !oUser():lAdministrador()
      msgStop( "Este tiket esta descontado.", "Imposible eliminar" )
      return .f.
   end if

   WinDelRec( oBrw, dbfFacCliP )

return .t.

//---------------------------------------------------------------------------//

function nNewReciboCliente( cNumFac, cTipRec, dbfFacCliP )

   local nCon
   local nRec
   local nOrd

   DEFAULT cTipRec   := Space( 1 )

   nCon              := 1
   nRec              := ( dbfFacCliP )->( Recno() )
   nOrd              := ( dbfFacCliP )->( OrdSetFocus( "nNumFac" ) )

   if ( dbfFacCliP )->( dbSeek( cNumFac ) )

      while ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == cNumFac .and. !( dbfFacCliP )->( eof() )

         if ( dbfFacCliP )->cTipRec == cTipRec
            ++nCon
         end if

         ( dbfFacCliP )->( dbSkip() )

      end do

   end if

   ( dbfFacCliP )->( OrdSetFocus( nOrd ) )
   ( dbfFacCliP )->( dbGoTo( nRec ) )

return ( nCon )

//------------------------------------------------------------------------//

Function SetHeadEuro()

Return nil

//------------------------------------------------------------------------//

Static Function YearComboBoxChange()

   if oWndBrw:oWndBar:lAllYearComboBox()
      DestroyFastFilter( dbfFacCliP )
      CreateUserFilter( "", dbfFacCliP, .f., , , "all" )
   else
      DestroyFastFilter( dbfFacCliP )
      CreateUserFilter( "Year( Field->dPreCob ) == " + oWndBrw:oWndBar:cYearComboBox(), dbfFacCliP, .f., , , "Year( Field->dPreCob ) == " + oWndBrw:oWndBar:cYearComboBox() )
   end if

   ( dbfFacCliP )->( dbGoTop() )

   oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

Static Function EndTrans( aTmp, aGet, dbfFacCliP, oBrw, oDlg, nMode )

   local nImp
   local nCon
   local nRec        := ( dbfFacCliP )->( Recno() )
   local lImpNeg     := ( dbfFacCliP )->nImporte < 0
   local nImpFld     := abs( ( dbfFacCliP )->nImporte )
   local nImpTmp     := abs( aTmp[ _NIMPORTE ] )
   local cNumFac     := aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ]
   local cNumRec     := aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ] + Str( aTmp[ _NNUMREC ] )
   local lDevuelto   := aTmp[ _LDEVUELTO ]
   local aTabla
   local nOrdAnt

   if !aGet[ _NIMPCOB ]:lValid()
      return .f.
   end if

   /*
   El importe no puede ser mayor q el importe anterior-------------------------
   */

   if nImpTmp > nImpFld
      msgStop( "El importe no puede ser superior al actual." )
      return nil
   end if

   if !lExisteTurno( aGet[ _CTURREC ]:VarGet(), dbfTurno )

      msgStop( "La sesión introducida no existe." )

      aGet[ _CTURREC ]:SetFocus()

      return nil

   end if

   oDlg:Disable()

   /*
   Suma el riesgo en situacion anterior----------------------------------------
   */

   if !Empty( dbfClient )

      if lPgdOld
         AddRiesgo( nImpOld, aTmp[ _CCODCLI ], dbfClient )
      end if

      if ( aTmp[ _LCOBRADO ] .or. aTmp[ _LRECDTO ] )
         DelRiesgo( aTmp[ _NIMPORTE ], aTmp[ _CCODCLI ], dbfClient )
      end if

   end if

   /*
   Comprobamos q los importes sean distintos-----------------------------------
   */

   if nImpFld != nImpTmp

      /*
      El importe ha cambiado por tanto debemos de hacer un nuevo recibo por la diferencia
      */

      nImp                       := ( nImpFld - nImpTmp ) * if( lImpNeg, - 1 , 1 )

      /*
      Obtnenemos el nuevo numero del contador
      */

      nCon                       := nNewReciboCliente( aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ], aTmp[ _CTIPREC ], dbfFacCliP )

      /*
      Añadimos el nuevo recibo-------------------------------------------------
      */

      ( dbfFacCliP )->( dbAppend() )

#ifndef __PDA__
      ( dbfFacCliP )->cTurRec    := cCurSesion()
#endif
      ( dbfFacCliP )->cSerie     := aTmp[ _CSERIE  ]
      ( dbfFacCliP )->nNumFac    := aTmp[ _NNUMFAC ]
      ( dbfFacCliP )->cSufFac    := aTmp[ _CSUFFAC ]
      ( dbfFacCliP )->cCodCaj    := aTmp[ _CCODCAJ ]
      ( dbfFacCliP )->cCodCli    := aTmp[ _CCODCLI ]
      ( dbfFacCliP )->cNomCli    := aTmp[ _CNOMCLI ]
      ( dbfFacCliP )->dEntrada   := Ctod( "" )
      ( dbfFacCliP )->nImporte   := nImp
      ( dbfFacCliP )->nImpCob    := nImp
      ( dbfFacCliP )->cDescrip   := "Recibo nº" + AllTrim( Str( nCon ) ) + " de factura " + if( !Empty( aTmp[ _CTIPREC ] ), "rectificativa ", "" ) + aTmp[ _CSERIE ] + '/' + AllTrim( Str( aTmp[ _NNUMFAC ] ) ) + '/' + aTmp[ _CSUFFAC ]
      ( dbfFacCliP )->dPreCob    := dFecFacCli( aTmp[ _CSERIE ] + Str( aTmp[ _NNUMFAC ] ) + aTmp[ _CSUFFAC ], dbfFacCliT )
      ( dbfFacCliP )->cPgdoPor   := ""
      ( dbfFacCliP )->lCobrado   := .f.
      ( dbfFacCliP )->nNumRec    := nCon
      ( dbfFacCliP )->cDivPgo    := aTmp[ _CDIVPGO ]
      ( dbfFacCliP )->nVdvPgo    := aTmp[ _NVDVPGO ]
      ( dbfFacCliP )->lConPgo    := .f.
      ( dbfFacCliP )->dFecCre    := GetSysDate()
      ( dbfFacCliP )->cHorCre    := SubStr( Time(), 1, 5 )

      ( dbfFacCliP )->( dbUnLock() )

   end if

   ( dbfFacCliP )->( dbGoTo( nRec ) )

   /*
   Estado de la contabilizacion------------------------------------------------
   */

   if ( lOldDevuelto != lDevuelto )
      aTmp[ _LCONPGO ]              := .f.
   end if

   /*
   Grabamos el recibo----------------------------------------------------------
   */

   WinGather( aTmp, aGet, dbfFacCliP, oBrw, nMode )

   /*
   Si es Devuelto creamos el tiket nuevo---------------------------------------
   */

   nRec     := ( dbfFacCliP )->( Recno() )

   if lOldDevuelto != lDevuelto

      if lDevuelto

         nOrdAnt                       := ( dbfFacCliP )->( OrdSetFocus( "nNumFac" ) )

         if ( dbfFacCliP )->( dbSeek( cNumRec ) )
            aTabla                     := dbScatter( dbfFacCliP )
         end if

         nCon                          := nNewReciboCliente( aTabla[ _CSERIE ] + Str( aTabla[ _NNUMFAC ] ) + aTabla[ _CSUFFAC ], aTabla[ _CTIPREC ], dbfFacCliP )

         if aTabla != nil

            ( dbfFacCliP )->( dbAppend() )
            ( dbfFacCliP )->cSerie     := aTabla[ _CSERIE  ]
            ( dbfFacCliP )->nNumFac    := aTabla[ _NNUMFAC ]
            ( dbfFacCliP )->cSufFac    := aTabla[ _CSUFFAC ]
            ( dbfFacCliP )->nNumRec    := nCon
            ( dbfFacCliP )->cTipRec    := aTabla[ _CTIPREC ]
            ( dbfFacCliP )->cCodPgo    := aTabla[ _CCODPGO ]
            ( dbfFacCliP )->cCodCaj    := aTabla[ _CCODCAJ ]
            ( dbfFacCliP )->cTurRec    := cCurSesion()
            ( dbfFacCliP )->cCodCli    := aTabla[ _CCODCLI ]
            ( dbfFacCliP )->cNomCli    := aTabla[ _CNOMCLI ]
            ( dbfFacCliP )->dEntrada   := Ctod( "" )
            ( dbfFacCliP )->nImporte   := aTabla[ _NIMPORTE ]
            ( dbfFacCliP )->cDesCriP   := "Recibo Nº" + AllTrim( Str( nCon ) ) + " generado de la devolución del recibo " + aTabla[ _CSERIE ] + "/" + AllTrim( Str( aTabla[ _NNUMFAC ] ) ) + "/" + aTabla[ _CSUFFAC ] + " - " + AllTrim( Str( aTabla[ _NNUMREC ] ) )
            ( dbfFacCliP )->dPreCob    := GetSysDate()
            ( dbfFacCliP )->lCobrado   := .f.
            ( dbfFacCliP )->cDivPgo    := aTabla[ _CDIVPGO ]
            ( dbfFacCliP )->nVdvPgo    := aTabla[ _NVDVPGO ]
            ( dbfFacCliP )->lConPgo    := .f.
            ( dbfFacCliP )->dFecVto    := GetSysDate()
            ( dbfFacCliP )->cCodAge    := aTabla[ _CCODAGE ]
            ( dbfFacCliP )->nImpGas    := aTabla[ _NIMPGAS ]
            ( dbfFacCliP )->dFecCre    := GetSysDate()
            ( dbfFacCliP )->cHorCre    := Time()
            ( dbfFacCliP )->cCodUsr    := oUser():cCodigo()
            ( dbfFacCliP )->cRecDev    := cNumRec
            ( dbfFacCliP )->( dbUnLock() )

         end if

         ( dbfFacCliP )->( OrdSetFocus( nOrdAnt ) )

      else

         nOrdAnt                       := ( dbfFacCliP )->( OrdSetFocus( "cRecDev" ) )

         if ( dbfFacCliP )->( dbSeek( cNumRec ) ) .and. dbDialogLock( dbfFacCliP )
            ( dbfFacCliP )->( dbDelete() )
            ( dbfFacCliP )->( dbUnLock() )
         end if

         ( dbfFacCliP )->( OrdSetFocus( nOrdAnt ) )

      end if

   end if

   ( dbfFacCliP )->( dbGoTo( nRec ) )

   /*
   Comprobamos el estado de la factura-----------------------------------------
   */

   if dbfFacCliT != nil          .and.;
      dbfFacCliL != nil          .and.;
      dbfIva     != nil          .and.;
      dbfDiv     != nil          .and.;
      dbfClient  != nil

      if ( dbfFacCliT )->( dbSeek( cNumFac ) )
         ChkLqdFacCli( nil, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv, .f. )
      end if

   end if

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   oDlg:Enable()

   oDlg:End( IDOK )

return .t.

//--------------------------------------------------------------------------//

CLASS pdaRecCliSenderReciver

   Method CreateDataPcToPda( oPgrActual, oSayStatus )

   Method CreateDataPdaToPc( oPgrActual, oSayStatus )

END CLASS

//----------------------------------------------------------------------------//

Method CreateDataPdaToPc( oPgrActual, oSayStatus, cPatPreVenta ) CLASS pdaRecCliSenderReciver

   local pdaFacCliT
   local pdaFacCliP
   local dbfFacCliP
   local cPatPc      := if( Empty( cPatPreVenta ), cPatPc(), cPatPreVenta )

   dbUseArea( .t., cDriver(), cPatEmp() + "FacCliT.Dbf", cCheckArea( "FacCliT", @pdaFacCliT ), .t. )
   ( pdaFacCliT )->( ordListAdd( cPatEmp() + "FacCliT.Cdx" ) )

   dbUseArea( .t., cDriver(), cPatEmp() + "FacCliP.Dbf", cCheckArea( "FacCliP", @pdaFacCliP ), .t. )
   ( pdaFacCliP )->( ordListAdd( cPatEmp() + "FacCliP.Cdx" ) )

   USE ( cPatPc + "FacCliP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliP", @dbfFacCliP ) )
   SET ADSINDEX TO ( cPatPc + "FacCliP.CDX" ) ADDITIVE

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( pdaFacCliP )->( OrdKeyCount() ) )
   end if

   ( pdaFacCliP )->( dbGoTop() )

   while !( pdaFacCliP )->( eof() )

      if !( dbfFacCliP )->( dbSeek( ( pdaFacCliP )->cSerie + Str( ( pdaFacCliP )->nNumFac ) + ( pdaFacCliP )->cSufFac + Str( ( pdaFacCliP )->nNumRec ) ) )

         dbPass( pdaFacCliP, dbfFacCliP, .t. )

      else

         do case
            case !( pdaFacCliP )->lCobrado .and. ( dbfFacCliP )->lCobrado
               dbPass( dbfFacCliP, pdaFacCliP, .f. )

            case ( pdaFacCliP )->lCobrado .and. !( dbfFacCliP )->lCobrado
               dbPass( pdaFacCliP, dbfFacCliP, .f. )

         end case

      end if

      ( pdaFacCliP )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando Recibos " + Alltrim( Str( ( pdaFacCliP )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( pdaFacCliP )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( pdaFacCliP )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   /*
   Eliminamos los recibos liquidados que no tienen relación con las facturas emitidas aqui.
   */

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( pdaFacCliP )->( OrdKeyCount() ) )
   end if

   if !Empty( oSayStatus )
      oSayStatus:SetText( "Sincronizando recibos" )
   end if

   SysRefresh()

   ( pdaFacCliP )->( dbGoTop() )

   while !( pdaFacCliP )->( eof() )

      if ( pdaFacCliP )->lCobrado                                                                                         .and.;
         !( pdaFacCliT )->( dbSeek( ( pdaFacCliP )->cSerie + Str( ( pdaFacCliP )->nNumFac ) + ( pdaFacCliP )->cSufFac ) ) .and.;
         dbDialogLock( pdaFacCliP )

         ( pdaFacCliP )->( dbDelete() )
         ( pdaFacCliP )->( dbUnLock() )

      end if

      ( pdaFacCliP )->( dbSkip() )

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( pdaFacCliP )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE( pdaFacCliT )
   CLOSE( pdaFacCliP )
   CLOSE( dbfFacCliP )

Return ( Self )

//----------------------------------------------------------------------------//

Method CreateDataPcToPda( oPgrActual, oSayStatus, cPatPreVenta )

   local pdaFacCliP
   local dbfFacCliP
   local cPatPc      := if( Empty( cPatPreVenta ), cPatPc(), cPatPreVenta )

   dbUseArea( .t., cDriver(), cPatEmp() + "FacCliP.Dbf", cCheckArea( "FacCliP", @pdaFacCliP ), .t. )
   ( pdaFacCliP )->( ordListAdd( cPatEmp() + "FacCliP.Cdx" ) )

   USE ( cPatPc + "FacCliP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliP", @dbfFacCliP ) )
   SET ADSINDEX TO ( cPatPc + "FacCliP.CDX" ) ADDITIVE

   ( dbfFacCliP )->( dbGoTop() )

   while !( dbfFacCliP )->( Eof() )

      if !( pdaFacCliP )->( dbSeek( ( dbfFacCliP )->cSerie + Str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac + Str( ( dbfFacCliP )->nNumRec ) ) ) .and.;
         !( dbfFacCliP )->lCobrado

         dbPass( dbfFacCliP, pdaFacCliP, .t. )

      end if

      ( dbfFacCliP )->( dbSkip() )

      if !Empty( oSayStatus )
         oSayStatus:SetText( "Sincronizando Recibos " + Alltrim( Str( ( dbfFacCliP )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( dbfFacCliP )->( OrdKeyCount() ) ) ) )
      end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( dbfFacCliP )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE( pdaFacCliP )
   CLOSE( dbfFacCliP )

Return ( Self )

//---------------------------------------------------------------------------//

function nEstadoRecibo( dbfFacCliP )

   local nEstado  := 1

   if !Empty( dbfFacCliP )

      if !( dbfFacCliP )->lCobrado
         nEstado     := 1
      else
         if !( dbfFacCliP )->lDevuelto
            nEstado  := 2
         else
            nEstado  := 3
         end if
      end if

   end if

return ( nEstado )

//---------------------------------------------------------------------------//

Static Function FilterRecibos( lCobrado )

   with object ( TDlgFlt():Init( oWndBrw ) )

      do case
         case IsTrue( lCobrado )
            :cExpFilter    := "lCobrado .and. !lDevuelto"
         case IsFalse( lCobrado )
            :cExpFilter    := "!lCobrado .and. !lDevuelto"
         case IsNil( lCobrado )
            :cExpFilter    := "lDevuelto"
      end case

      :AplyFilter()

   end with

return ( nil )

//---------------------------------------------------------------------------//

Function cCuentaEmpresaRecibo( uFacCliP )

   local cCuentaEmpresaRecibo := ""

   do case
   case IsObject( uFacCliP )
      cCuentaEmpresaRecibo    += uFacCliP:cEntEmp
      cCuentaEmpresaRecibo    += uFacCliP:cSucEmp
      cCuentaEmpresaRecibo    += uFacCliP:cDigEmp
      cCuentaEmpresaRecibo    += uFacCliP:cCtaEmp

   case IsChar( uFacCliP )
      cCuentaEmpresaRecibo    += ( uFacCliP )->cEntEmp
      cCuentaEmpresaRecibo    += ( uFacCliP )->cSucEmp
      cCuentaEmpresaRecibo    += ( uFacCliP )->cDigEmp
      cCuentaEmpresaRecibo    += ( uFacCliP )->cCtaEmp

   end case

return ( cCuentaEmpresaRecibo )

//---------------------------------------------------------------------------//