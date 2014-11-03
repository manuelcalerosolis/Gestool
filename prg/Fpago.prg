#ifndef __PDA__
#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "Report.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

#ifndef __PDA__

#define _CCODPAGO                   1      //   C      2     0
#define _CDESPAGO                   2      //   C     30     0
#define _NTIPPGO                    3      //   N      1     0
#define _NPCTCOM                    4      //   N      5     1
#define _LEMTREC                    5      //   L      1     0
#define _NCOBREC                    6      //   N      1     0
#define _CCTACOBRO                  7      //   C     12     0
#define _CCTAGAS                    8      //   C     12     0
#define _LESPERADOC                 9      //   C     12     0
#define _NPLAZOS                   10      //   N      3     0
#define _NPLAUNO                   11      //   N      3     0
#define _NDIAPLA                   12      //   N      3     0
#define _LSHWTPV                   13      //
#define _NIMGTPV                   14      //
#define _NPOSTPV                   15      //
#define _NTIPOAPL                  16      //   N      1     0
#define _NIMPAPL                   17      //   N     10     0
#define _NPORC1                    18      //   N      3     0
#define _NAPL1                     19      //   L      1     0
#define _NPORC2                    20      //   N      1     0
#define _NAPL2                     21      //   N      3     0
#define _NPORC3                    22      //   N      3     0
#define _NAPL3                     23      //   N      3     0
#define _NPORC4                    24      //   N      3     0
#define _NAPL4                     25      //   N      3     0
#define _NPORC5                    26      //   N      3     0
#define _NAPL5                     27      //   N      3     0
#define _CCODXML                   28      //
#define _NENTINI                   29      //
#define _NPCTDTO                   30      //
#define _LUTLBNC                   31      //
#define _CBANCO                    32      //
#define _CPAISIBAN                 33      //
#define _CCTRLIBAN                 34      //
#define _CENTBNC                   35      //
#define _CSUCBNC                   36      //
#define _CDIGBNC                   37      //
#define _CCTABNC                   38      //
#define _CCODWEB                   39  

static oWndBrw
static aBigResource
static aPressResource
static aTexto
static bEdit         := { |aTmp, aGet, dbfFormasPago, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfFormasPago, oBrw, bWhen, bValid, nMode ) }

#endif

static dbfFormasPago

#ifndef __PDA__

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( cPatEmp )

   local lOpen       := .t.
   local oBlock

   DEFAULT cPatEmp   := cPatGrp()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFormasPago ) )
   SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

   /*
   Inicializacion de variables-------------------------------------------------
   */

   aBigResource      := aLittleResourceFormaPago()
   aTexto            := aTextoResourceFormaPago()

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN lOpen

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if oWndBrw != nil
      oWndBrw  := nil
   end if

   CLOSE ( dbfFormasPago )

   dbfFormasPago    := nil

RETURN ( .t. )

//----------------------------------------------------------------------------//

FUNCTION FPago( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01014"
   DEFAULT  oWnd        := oWnd()

	IF oWndBrw == NIL

      /*
      Obtenemos el nivel de acceso
      */

      nLevel            := nLevelUsr( oMenuItem )
      if nAnd( nLevel, 1 ) != 0
         msgStop( "Acceso no permitido." )
         return nil
      end if

      /*
      Cerramos todas las ventanas
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
      end if

      if !OpenFiles()
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Formas de pago", ProcName() )

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
         XBROWSE ;
         TITLE    "Formas de pago" ;
         PROMPT   "Código",;
                  "Nombre",;
                  "Posición" ;
         MRU      "Creditcards_16";
         BITMAP   clrTopArchivos ;
         ALIAS    ( dbfFormasPago ) ;
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfFormasPago ) );
         DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfFormasPago ) );
         EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfFormasPago ) ) ;
         DELETE   ( WinDelRec(  oWndBrw:oBrw, dbfFormasPago ) );
         LEVEL    nLevel ;
         OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPago"
         :bEditValue       := {|| ( dbfFormasPago )->cCodPago }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesPago"
         :bEditValue       := {|| ( dbfFormasPago )->cDesPago }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Táctil"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfFormasPago )->lShwTpv }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "TACTIL16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Posición"
         :cSortOrder       := "nPosTpv"
         :bEditValue       := {|| if( ( dbfFormasPago )->lShwTpv, Trans( ( dbfFormasPago )->nPosTpv, "99" ), "" ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      oWndBrw:lAutoPos     := .f.
      oWndBrw:cHtmlHelp    := "Formas de pago"

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar" ;
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
         NOBORDER ;
			ACTION 	( oWndBrw:RecAdd() );
			ON DROP	( oWndBrw:RecDup() );
			TOOLTIP 	"(A)ñadir";
         BEGIN GROUP;
         HOTKEY   "A";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
         MRU ;
         HOTKEY   "D";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         MRU ;
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfFormasPago ) );
			TOOLTIP 	"(Z)oom";
         MRU ;
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
         MRU ;
         HOTKEY   "E";
         LEVEL    ACC_DELE

#ifndef __TACTIL__

		DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( InfFpg():New( "Listado de formas de pago" ):Play() ) ;
         TOOLTIP  "(L)istado" ;
         HOTKEY   "L";
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL RESOURCE "Up" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( ChangePosition( .f. ), oWndBrw:Refresh() ) ;
         TOOLTIP  "S(u)bir posición" ;
         HOTKEY   "U";
         LEVEL    ACC_IMPR

      DEFINE BTNSHELL RESOURCE "Down" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( ChangePosition( .t. ), oWndBrw:Refresh() ) ;
         TOOLTIP  "Ba(j)ar posición" ;
         HOTKEY   "J";
         LEVEL    ACC_IMPR

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw ;
         VALID ( CloseFiles() )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfFormasPago, oBrw, bWhen, bValid, nMode )

   local oDlg
	local oGet
   local nOrd
   local oGet2
   local oGetCob
   local cGetCob
   local oGetGas
   local cGetGas
   local oCmbImagen
   local cCmbImagen
   local nMaxPosition

   /*
   Obtenemos la posicion del ultimo botón--------------------------------------
   */

   nOrd                 := ( dbfFormasPago )->( OrdSetFocus( "nPosTpv" ) )
   nMaxPosition         := ( dbfFormasPago )->( OrdKeyCount() )
   ( dbfFormasPago )->( OrdSetFocus( nOrd ) )

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      nMaxPosition++
   end if

   /*
   Valores por defecto---------------------------------------------------------
   */

   if nMode == APPD_MODE
      aTmp[ _NPLAZOS ]  := 1
      aTmp[ _NPLAUNO ]  := 0
   end if

   if aTmp[ _NTIPPGO ] == 0
      aTmp[ _NTIPPGO ]  := 1
   end if

   if aTmp[ _NCOBREC ] == 0
      aTmp[ _NCOBREC ]  := 1
   end if

   if Empty( aTmp[ _NIMGTPV ] )
      aTmp[ _NIMGTPV ]  := 1
   end if

   if Empty( aTmp[ _NPOSTPV ] )
      aTmp[ _NPOSTPV ]  := nMaxPosition
   end if

   if aTmp[ _CCODPAGO ] == "00"
      aTmp[ _LSHWTPV ]  := .t.
   end if

   /*
   Inicializacion de variables-------------------------------------------------
   */

   if Empty( aBigResource )
      aBigResource      := aLittleResourceFormaPago()
   end if

   if Empty( aTexto )
      aTexto            := aTextoResourceFormaPago()
   end if

   cCmbImagen           := aTexto[ Min( Max( aTmp[ _NIMGTPV ], 1 ), len( aTexto ) ) ]

   /*
   Dialogo---------------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "FormPago" TITLE LblTitle( nMode ) + "formas de pagos"

		/*
		Redefinici¢n de la primera caja de Dialogo
		*/

      REDEFINE GET oGet VAR aTmp[ _CCODPAGO ];
         ID       100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( oGet, dbfFormasPago ) ) ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET oGet2 VAR aTmp[ _CDESPAGO]  ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE RADIO aTmp[ _NTIPPGO ] ;
         ID       111, 112, 113 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aTmp[ _NPCTCOM ];
         ID       120 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. aTmp[ _NTIPPGO ] == 3 ) ;
         PICTURE  "@E 99.99" ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ _LESPERADOC ];
         ID       125;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE RADIO aTmp[ _NCOBREC ] ;
         ID       140, 141 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _NPLAZOS ] VAR aTmp[ _NPLAZOS ];
         ID       320 ;
         PICTURE  "999" ;
         VALID    ( aTmp[ _NPLAZOS ] > 0 ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         MIN      1 ;
         MAX      999 ;
         OF       oDlg

      REDEFINE GET aGet[ _NPLAUNO ] VAR aTmp[ _NPLAUNO ];
         ID       330 ;
         PICTURE  "999";
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         MIN      0 ;
         MAX      999 ;
         OF       oDlg

      REDEFINE GET aGet[ _NDIAPLA ] VAR aTmp[ _NDIAPLA ];
         ID       340 ;
         PICTURE  "999";
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _NPLAZOS ] > 1 ) ;
         SPINNER ;
         MIN      0 ;
         MAX      999 ;
         OF       oDlg

      /*
      Datos del banco de la empresa--------------------------------------------
      */

      REDEFINE CHECKBOX aTmp[ _LUTLBNC ];
         ID       126;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CBANCO ] VAR aTmp[ _CBANCO ];
         ID       210 ;
         WHEN     ( aTmp[ _LUTLBNC ] .and. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncEmp( aGet[ _CBANCO ], aGet[ _CPAISIBAN ], aGet[ _CCTRLIBAN ], aGet[ _CENTBNC ], aGet[ _CSUCBNC ], aGet[ _CDIGBNC ], aGet[ _CCTABNC ] ) );
         OF       oDlg

      REDEFINE GET aGet[ _CPAISIBAN ] VAR aTmp[ _CPAISIBAN ] ;
         PICTURE  "@!" ;
         ID       370 ;
         WHEN     ( aTmp[ _LUTLBNC ] .and. nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CCTRLIBAN ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CCTRLIBAN ] VAR aTmp[ _CCTRLIBAN ] ;
         ID       380 ;
         WHEN     ( aTmp[ _LUTLBNC ] .and. nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( aTmp[ _CPAISIBAN ], aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CCTRLIBAN ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CENTBNC ] VAR aTmp[ _CENTBNC ];
         ID       220 ;
         WHEN     ( aTmp[ _LUTLBNC ] .and. nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CSUCBNC ] VAR aTmp[ _CSUCBNC ];
         ID       230 ;
         WHEN     ( aTmp[ _LUTLBNC ] .and. nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CDIGBNC ] VAR aTmp[ _CDIGBNC ];
         ID       240 ;
         WHEN     ( aTmp[ _LUTLBNC ] .and. nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CCTABNC ] VAR aTmp[ _CCTABNC ];
         ID       250 ;
         PICTURE  "9999999999" ;
         WHEN     ( aTmp[ _LUTLBNC ] .and. nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ _CENTBNC ], aTmp[ _CSUCBNC ], aTmp[ _CDIGBNC ], aTmp[ _CCTABNC ], aGet[ _CDIGBNC ] ),;
                     aGet[ _CPAISIBAN ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CCTACOBRO ] VAR aTmp[ _CCTACOBRO ] ;
         ID       280 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( !Empty( cRutCnt() ) .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTACOBRO ], oGetCob ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTACOBRO ], { aTmp[ _CCTACOBRO ], aTmp[ _CDESPAGO ] }, oGetCob ) );
			OF oDlg

		REDEFINE GET oGetCob VAR cGetCob ;
         ID       290 ;
			WHEN 		( .F. );
			OF 		oDlg

      REDEFINE GET aGet[ _CCTAGAS ] VAR aTmp[ _CCTAGAS ] ;
         ID       300 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( !Empty( cRutCnt() ) .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTAGAS ], oGetGas ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTAGAS ], { aTmp[ _CCTAGAS ], aTmp[ _CDESPAGO ] }, oGetGas ) );
         OF       oDlg

      REDEFINE GET oGetGas VAR cGetGas ;
         ID       301 ;
			COLOR 	CLR_GET ;
			WHEN 		( .F. );
			OF 		oDlg

      //Controles para incluir en tpv-----------------------------------------

      REDEFINE CHECKBOX aTmp[ _LSHWTPV ] ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ _CCODPAGO ] != "00" ) ;
         OF       oDlg

      REDEFINE COMBOBOX oCmbImagen ;
         VAR      cCmbImagen ;
         ID       410 ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ( aTexto ) ;
         BITMAPS  ( aBigResource )

      REDEFINE GET aGet[ _NPOSTPV ] ;
         VAR      aTmp[ _NPOSTPV ] ;
         ID       420 ;
         PICTURE  "99";
         WHEN     ( nMode != ZOOM_MODE );
         VALID    ( aTmp[ _NPOSTPV ] >= 1 .and. aTmp[ _NPOSTPV ] <= 99 ) ;
         SPINNER ;
         MIN      ( 1 ) ;
         MAX      ( 99 ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CCODWEB ] ;
         VAR      aTmp[ _CCODWEB ] ;
         ID       430 ;
         WHEN     ( nMode != ZOOM_MODE ); 
         OF       oDlg   

      // Código de facturae ---------------------------------------------------

      REDEFINE COMBOBOX aGet[ ( dbfFormasPago )->( FieldPos( "cCodXml" ) ) ] ;
         VAR      aTmp[ ( dbfFormasPago )->( FieldPos( "cCodXml" ) ) ] ;
         ITEMS    FORMASDEPAGO_ITEMS ;
         ID       425 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfFormasPago )->( FieldPos( "nEntIni" ) ) ];
         ID       500 ;
			SPINNER ;
         PICTURE  "@E 99.99" ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfFormasPago )->( FieldPos( "nPctDto" ) ) ];
         ID       510 ;
			SPINNER ;
         PICTURE  "@E 99.99" ;
         OF       oDlg

      // Botones --------------------------------------------------------------

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE );
         ACTION   ( lPreSave( aTmp, aGet, dbfFormasPago, oBrw, nMode, oDlg, oGet, oGet2, oCmbImagen ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
         OF       oDlg ;
         ACTION   ( GoHelp() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| lPreSave( aTmp, aGet, dbfFormasPago, oBrw, nMode, oDlg, oGet, oGet2, oCmbImagen ) } )
      end if

      oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

      oDlg:bStart := {|| oGet:SetFocus(), aGet[ _CCTACOBRO ]:lValid(), aGet[ _CCTAGAS ]:lValid() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION lPreSave( aTmp, aGet, dbfFormasPago, oBrw, nMode, oDlg, oGet, oGet2, oCmbImagen )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( aTmp[ _CCODPAGO ] )
         MsgStop( "El código de la forma de pago no puede estar vacío." )
         oGet:SetFocus()
         Return nil
      end if

      if dbSeekInOrd( aTmp[ _CCODPAGO ], "CCODPAGO", dbfFormasPago )
         MsgStop( "Código ya existe " + Rtrim( aTmp[ _CCODPAGO ] ) )
         Return nil
      end if

   end if

   if Empty( aTmp[ _CDESPAGO ] )
      MsgStop( "El nombre de la forma de pago no puede estar vacío." )
      oGet2:SetFocus()
      Return nil
   end if

   if aTmp[ _NPLAZOS ] < 1
      MsgStop( "El número de plazos tiene que ser mayor que cero." )
      aGet[ _NPLAZOS ]:SetFocus()
      Return nil
   end if

   // Numero de la imagen------------------------------------------------------

   aTmp[ _NIMGTPV ]  := oCmbImagen:nAt

   // Grabamos el registro-----------------------------------------------------

   WinGather( aTmp, aGet, dbfFormasPago, oBrw, nMode )

   // Reordenación de posiciones-----------------------------------------------

   ChangePosition()

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

FUNCTION cNbrFPago( cCodPago, dbfFormasPago )

	local cText			:= ""
   local lClose      := .f.

   if dbfFormasPago == NIL
      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFormasPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE
      lClose         := .t.
   end if

   if ValType( dbfFormasPago ) == "O"
      if dbfFormasPago:Seek( cCodPago )
         cText       := RTrim( dbfFormasPago:cDesPago )
      end if
   else
      if ( dbfFormasPago )->( dbSeek( cCodPago ) )
         cText       := RTrim( ( dbfFormasPago )->cDesPago )
      end if
   end if

   if lClose
      CLOSE ( dbfFormasPago )
   end if

RETURN cText

//---------------------------------------------------------------------------//

FUNCTION cCtaFPago( cCodFPgo, dbfFormasPago )

	local cText		:= ""
   local lClose   := .f.

   if Empty( dbfFormasPago )
      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFormasPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if dbSeekInOrd( cCodFPgo, "cCodPago", dbfFormasPago )
      cText       := ( dbfFormasPago )->cCtaCobro
   end if

   if lClose
      CLOSE ( dbfFormasPago )
   end if

RETURN cText

//---------------------------------------------------------------------------//

FUNCTION cCtaFGas( cCodFPgo, dbfFormasPago )

	local cText		:= ""
   local lClose   := .f.

   if Empty( dbfFormasPago )
      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFormasPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if ( dbfFormasPago )->( dbSeekInOrd( cCodFPgo, "cCodPago" ) )
      cText       := ( dbfFormasPago )->cCtaGas
   end if

   if lClose
      CLOSE ( dbfFormasPago )
   end if

RETURN cText

//---------------------------------------------------------------------------//

/*
Devuelve si la forma de pago es en efectivo
*/

FUNCTION nTipoPago( cCodFPgo, dbfFormasPago )

   local nEfe        := 1

   do case
      case ValType( dbfFormasPago ) == "O"

         if dbfFormasPago:SeekInOrd( cCodFPgo, "cCodPago" )
            nEfe     := dbfFormasPago:nTipPgo
         end if

      case ValType( dbfFormasPago ) == "C"

         if ( dbfFormasPago )->( dbSeekInOrd( cCodFPgo, "cCodPago" ) )
            nEfe     := ( dbfFormasPago )->nTipPgo
         end if

   end case

RETURN nEfe

//---------------------------------------------------------------------------//

FUNCTION cCodigoXmlPago( cCodPgo, dbfFormasPago )

   local cCod        := ""

   do case
      case ValType( dbfFormasPago ) == "O"

         if dbfFormasPago:SeekInOrd( cCodPgo, "cCodPago" )
            cCod     := Rtrim( Left( dbfFormasPago:cCodXml, 2 ) )
         end if

      case ValType( dbfFormasPago ) == "C"

         if ( dbfFormasPago )->( dbSeekInOrd( cCodPgo, "cCodPago" ) )
            cCod     := Rtrim( Left( ( dbfFormasPago )->cCodXml, 2 ) )
         end if

   end case

RETURN ( cCod )

//---------------------------------------------------------------------------//

Function BrwPgoTactil( oGet, dbfFormasPago, oGet2 )

   local oDlg
   local oBrw
   local nRec        := ( dbfFormasPago )->( RecNo() )
   local nOrdAnt     := ( dbfFormasPago )->( OrdSetFocus( "CDESPGOBIG" ) )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRYTACTIL"   TITLE "Seleccionar forma de pago ordenada por: nombre"

      REDEFINE BUTTONBMP ;
         ID       100 ;
         OF       oDlg ;
         BITMAP   "LUPA_32" ;
         ACTION   ( BuscarBrwTactil( dbfFormasPago, oBrw ) )

      REDEFINE BUTTON ;
         ID       110 ;
         OF       oDlg ;
         ACTION   ( ( dbfFormasPago )->( OrdSetFocus( "CCODPGOBIG" ) ), oBrw:Refresh(), oDlg:cTitle( "Seleccionar forma de pago ordenada por: código" ) )

      REDEFINE BUTTON ;
         ID       120 ;
         OF       oDlg ;
         ACTION   ( ( dbfFormasPago )->( OrdSetFocus( "CDESPGOBIG" ) ), oBrw:Refresh(), oDlg:cTitle( "Seleccionar forma de pago ordenada por: nombre" ) )

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfFormasPago
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Formas de pago"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPago"
         :bEditValue       := {|| ( dbfFormasPago )->cCodPago }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesPago"
         :bEditValue       := {|| ( dbfFormasPago )->cDesPago }
         :nWidth           := 200
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

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

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:End( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      oGet:cText( ( dbfFormasPago )->cCodPago )
      oGet2:cText( Rtrim( ( dbfFormasPago )->cDesPago ) )
   end if

   ( dbfFormasPago )->( OrdSetFocus( nOrdAnt ) )
   ( dbfFormasPago )->( dbGoTo( nRec ) )

Return oDlg:nResult == IDOK

//---------------------------------------------------------------------------//

Function BuscarBrwTactil( Dbf, oBrw )

   local nRec        := ( dbf )->( RecNo() )
   local cBuscado    := VirtualKey( .f. )

   if !Empty( cBuscado )
      if ( dbf )->( dbSeek( cBuscado ) )
         oBrw:Refresh()
      else
         msgStop( "Elemento no encontrado" )
         ( dbf )->( dbGoto( nRec ) )
         oBrw:Refresh()
      end if
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

CLASS pdaFPagoSenderReciver

   Method CreateData()

END CLASS

//----------------------------------------------------------------------------//

Method CreateData( oPgrActual, oSayStatus, cPatPreVenta ) CLASS pdaFPagoSenderReciver

   local dbfFormasPago
   local tmpFPago
   local lExist      := .f.
   local cFileName
   local cPatPc      := if( Empty( cPatPreVenta ), cPatPc(), cPatPreVenta )

   USE ( cPatGrp() + "FPago.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPago", @dbfFormasPago ) )
   SET ADSINDEX TO ( cPatGrp() + "FPago.Cdx" ) ADDITIVE

   dbUseArea( .t., cDriver(), cPatPc + "FPago.Dbf", cCheckArea( "FPago", @tmpFPago ), .t. )
   ( tmpFPago )->( ordListAdd( cPatPc + "FPago.Cdx" ) )

   if !Empty( oPgrActual )
      oPgrActual:SetRange( 0, ( tmpFPago )->( OrdKeyCount() ) )
   end if

   ( tmpFPago )->( dbGoTop() )
   while !( tmpFPago )->( eof() )

         if ( dbfFormasPago )->( dbSeek( ( tmpFPago )->cCodPago ) )
            dbPass( tmpFPago, dbfFormasPago, .f. )
         else
            dbPass( tmpFPago, dbfFormasPago, .t. )
         end if

         ( tmpFPago )->( dbSkip() )

         if !Empty( oSayStatus )
            oSayStatus:SetText( "Sincronizando Formas de pago " + Alltrim( Str( ( tmpFPago )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ( tmpFPago )->( OrdKeyCount() ) ) ) )
         end if

      SysRefresh()

      if !Empty( oPgrActual )
         oPgrActual:SetPos( ( tmpFPago )->( OrdKeyNo() ) )
      end if

      SysRefresh()

   end while

   CLOSE ( tmpFPago )
   CLOSE ( dbfFormasPago )

Return ( Self )

//-------------------------------------------------------------------------//

function IsFPago( cPatEmp )

   local nFields

   local oBlock
   local oError

   local IsFPago     := .f.
   local dbfFormasPago

   DEFAULT cPatEmp   := cPatGrp()

   if !lExistTable( cPatEmp + "Fpago.Dbf" )
      mkFpago()
   end if

   if !lExistIndex( cPatEmp + "Fpago.Cdx" )
      rxFpago()
   end if

   /*
   Cambios en la tabla---------------------------------------------------------
   */

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      dbUseArea( .t., cDriver(), cPatEmp + "FPago.Dbf", cCheckArea( "FPAGO", @dbfFormasPago ), .f. )

      if !( dbfFormasPago )->( netErr() )

         nFields        := ( dbfFormasPago )->( fCount() )

         ( dbfFormasPago )->( dbCloseArea() )

         if nFields != len( aItmFpago() )

            dbCreate( cPatEmpTmp() + "FPago.Dbf", aSqlStruct( aItmFpago() ), cDriver() )
            appDbf( cPatEmp, cPatEmpTmp(), "Fpago" )

            fEraseTable( cPatEmp + "FPago.Dbf" )
            fRenameTable( cPatEmpTmp() + "FPago.Dbf", cPatEmp + "FPago.Dbf" )

            rxFpago()

         end if

      end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Cambios en la tabla---------------------------------------------------------
   */

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFormasPago ) )
      SET ADSINDEX TO ( cPatEmp + "FPAGO.CDX" ) ADDITIVE

      ( dbfFormasPago )->( __dbLocate( { || ( dbfFormasPago )->cCodPago == "00" } ) )

      if !( dbfFormasPago )->( Found() )

         ( dbfFormasPago )->( dbAppend() )
         ( dbfFormasPago )->cCodPago     := "00"
         ( dbfFormasPago )->cDesPago     := "Contado"
         ( dbfFormasPago )->nTipPgo      := 1
         ( dbfFormasPago )->lEmtRec      := .t.
         ( dbfFormasPago )->nCobRec      := 1
         ( dbfFormasPago )->nPlazos      := 1
         ( dbfFormasPago )->nPlaUno      := 0
         ( dbfFormasPago )->nDiaPla      := 0
         ( dbfFormasPago )->lShwTpv      := .t.
         ( dbfFormasPago )->nImgTpv      := 1
         ( dbfFormasPago )->nPosTpv      := 1
         ( dbfFormasPago )->( dbUnLock() )

      else

         if !( dbfFormasPago )->lShwTpv .and. ( dbfFormasPago )->( dbRLock() )

            ( dbfFormasPago )->lShwTpv   := .t.
            ( dbfFormasPago )->nImgTpv   := 1
            ( dbfFormasPago )->nPosTpv   := 1

            ( dbfFormasPago )->( dbUnLock() )

         end if

      end if

      IsFPago                             := .t.

      CLOSE ( dbfFormasPago )

   RECOVER USING oError

      msgStop( "Imposible abrir base de datos de formas de pago." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

return ( IsFPago )

//--------------------------------------------------------------------------//

FUNCTION rxFPago( cPath, oMeter )

   local dbfFormasPago

   DEFAULT cPath     := cPatGrp()

   if !lExistTable( cPath + "FPago.Dbf" )
      mkFPago( cPath )
   end if

   fEraseIndex( cPath + "FPago.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "FPAGO.DBF", cCheckArea( "FPAGO", @dbfFormasPago ), .f. )
   if !( dbfFormasPago )->( neterr() )
      ( dbfFormasPago )->( __dbPack() )

      ( dbfFormasPago )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFormasPago )->( ordCreate( cPath + "FPAGO.CDX", "cCodPago", "Field->cCodPago", {|| Field->cCodPago }, ) )

      ( dbfFormasPago )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFormasPago )->( ordCreate( cPath + "FPAGO.CDX", "CDESPAGO", "Field->CDESPAGO", {|| Field->CDESPAGO } ) )

      ( dbfFormasPago )->( ordCondSet("!Deleted() .and. Field->lShwTpv", {||!Deleted() .and. Field->lShwTpv} ) )
      ( dbfFormasPago )->( ordCreate( cPath + "FPAGO.CDX", "nPosTpv", "Str( Field->nPosTpv )", {|| Str( Field->nPosTpv ) } ) )

      ( dbfFormasPago )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFormasPago )->( ordCreate( cPath + "FPAGO.CDX", "CCODPGOBIG", "UPPER( Field->CCODPAGO )", {|| UPPER( Field->CCODPAGO ) }, ) )

      ( dbfFormasPago )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFormasPago )->( ordCreate( cPath + "FPAGO.CDX", "CDESPGOBIG", "UPPER( Field->CDESPAGO )", {|| UPPER( Field->CDESPAGO ) } ) )

      ( dbfFormasPago )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFormasPago )->( ordCreate( cPath + "FPAGO.CDX", "cCodWeb", "Field->cCodWeb", {|| Field->cCodWeb }, ) )

      ( dbfFormasPago )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de formas de pago", "Reindexando formas de pago" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION mkFPago( cPath, lAppend, cPathOld )

   local dbfFormasPago

   DEFAULT cPath     := cPatGrp()
   DEFAULT lAppend   := .f.

   dbCreate( cPath + "Fpago.Dbf", aSqlStruct( aItmFPago() ), cDriver() )

   if lAppend .and. !Empty( cPathOld ) .and. lExistTable( cPathOld + "Fpago.Dbf" )
      dbUseArea( .t., cDriver(), cPath + "Fpago.Dbf", cCheckArea( "Fpago", @dbfFormasPago ), .f. )
      ( dbfFormasPago )->( __dbApp( cPathOld + "Fpago.Dbf" ) )
      ( dbfFormasPago )->( dbCloseArea() )
   end if

   rxFPago( cPath )

RETURN .T.

//--------------------------------------------------------------------------//

function aItmFPago()

   local aBase := {}

   aAdd( aBase, { "CCODPAGO",  "C",   2,   0, "Código de la forma de pago"                             ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "CDESPAGO",  "C", 150,   0, "Descripción de forma de pago"                           ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NTIPPGO",   "N",   1,   0, "Tipo de la forma de pago"                               ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NPCTCOM",   "N",   6,   2, "Porcentaje de comisión de la forma de pago"             ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "LEMTREC",   "L",   1,   0, "Emitir recibos de la forma de pago"                     ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NCOBREC",   "N",   1,   0, "Recibos como cobrado de la forma de pago"               ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "CCTACOBRO", "C",  12,   0, "Cuenta contabilidad de forma de pago"                   ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "CCTAGAS",   "C",  12,   0, "Cuenta contabilidad de gastos"                          ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "LESPERADOC","L",   1,   0, "No imprimir fecha de vencimiento"                       ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NPLAZOS",   "N",   3,   0, "Número plazos de aplazamiento"                          ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NPLAUNO",   "N",   3,   0, "Numero de días hasta el primer pago"                    ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NDIAPLA",   "N",   3,   0, "Número de dias entre plazos"                            ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "lShwTpv",   "L",   1,   0, "Lógico mostrar en TPV"                                  ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "nImgTpv",   "N",   1,   0, "Número de la imagen a mostrar en TPV"                   ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "nPosTpv",   "N",   4,   1, "Posición para mostrar en TPV"                           ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NTIPOAPL",  "N",   1,   0, "Tipo de aplazamiento de la forma de pago"               ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NIMPAPL",   "N",  16,   6, "Importe de aplzamiento de la forma de pago"             ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NPORC1",    "N",   6,   2, "Porcentaje del primer aplazamiento de la forma de pago" ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NAPL1",     "N",   3,   0, "Dias del primer aplazamiento de la forma de pago"       ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NPORC2",    "N",   6,   2, "Porcentaje del segundo aplazamiento de forma de pago"   ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NAPL2",     "N",   3,   0, "Dias del segundo aplazamiento de la forma de pago"      ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NPORC3",    "N",   6,   2, "Porcentaje del tercer aplazamiento de forma de pago"    ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NAPL3",     "N",   3,   0, "Dias del tercer aplazamiento de la forma de pago"       ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NPORC4",    "N",   6,   2, "Porcentaje del cuarto aplazamiento de forma de pago"    ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NAPL4",     "N",   3,   0, "Dias del cuarto aplazamiento de la forma de pago"       ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NPORC5",    "N",   6,   2, "Porcentaje del quinto aplazamiento de forma de pago"    ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "NAPL5",     "N",   3,   0, "Dias del quinto aplazamiento de la forma de pago"       ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "cCodXml",   "C", 100,   0, "Código de pago para facturae"                           ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "nEntIni",   "N",   6,   2, "Porcentaje de entrega inicial de la forma de pago"      ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "nPctDto",   "N",   6,   2, "Porcentaje de descuento de la forma de pago"            ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "lUtlBnc",   "L",   1,   0, "Utilizar entidad bancaria"                              ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "cBanco",    "C",   50,  0, "Entidad bancaria"                                       ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "cPaisIBAN", "C",   2,   0, "País IBAN de la cuenta bancaria"                        ,  "",   "", "( cDbfPgo )", nil } )
   aAdd( aBase, { "cCtrlIBAN", "C",   2,   0, "Dígito de control IBAN de la cuenta bancaria"           ,  "",   "", "( cDbfPgo )", nil } )
   aAdd( aBase, { "cEntBnc",   "C",   4,   0, "Entidad de la cuenta"                                   ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "cSucBnc",   "C",   4,   0, "Sucursal de la cuenta"                                  ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "cDigBnc",   "C",   2,   0, "Dígito de control de la cuenta"                         ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "cCtaBnc",   "C",  10,   0, "Cuenta bancaria"                                        ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "cCodWeb",   "C", 100,   0, "Código web para la forma de pago"                       ,  "",   "", "( cDbfPgo )" } )

return ( aBase )

//---------------------------------------------------------------------------//

function aLittleResourceFormaPago()

   local aResources := {}

   aAdd( aResources, "Money2_16" )
   aAdd( aResources, "Creditcards_16" )
   aAdd( aResources, "MoneyBag_16" )
   aAdd( aResources, "Percent_16" )
   aAdd( aResources, "ShoppingBasket_16" )

return ( aResources )

//---------------------------------------------------------------------------//

function aMiddleResourceFormaPago()

   local aResources := {}

   aAdd( aResources, "Money2_24" )
   aAdd( aResources, "Creditcards_24" )
   aAdd( aResources, "MoneyBag_24" )
   aAdd( aResources, "Percent_24" )
   aAdd( aResources, "ShoppingBasket_24" )

return ( aResources )

//---------------------------------------------------------------------------//

function aBigResourceFormaPago()

   local aResources := {}

   aAdd( aResources, "Money2_32" )
   aAdd( aResources, "Creditcards_32" )
   aAdd( aResources, "MoneyBag_32" )
   aAdd( aResources, "Percent_32" )
   aAdd( aResources, "ShoppingBasket_32" )

return ( aResources )

//---------------------------------------------------------------------------//

function aPressResourceFormaPago()

   local aResources := {}

   aAdd( aResources, "Money2_32_Pressed" )
   aAdd( aResources, "Creditcards_32_Pressed" )
   aAdd( aResources, "MoneyBag_32_Pressed" )
   aAdd( aResources, "Percent_32_Pressed" )
   aAdd( aResources, "ShoppingBasket_32_Pressed" )

return ( aResources )

//---------------------------------------------------------------------------//

function aTextoResourceFormaPago()

   local aResources  := {}

   aAdd( aResources, "Dinero" )
   aAdd( aResources, "Tarjeta de credito" )
   aAdd( aResources, "Bolsa de dinero" )
   aAdd( aResources, "Porcentaje" )
   aAdd( aResources, "Cesta de compra" )

return ( aResources )

//---------------------------------------------------------------------------//

function aCreateButtons( dbfFormasPago )

   local n           := 1
   local nOrd
   local oButton
   local aButtons    := {}

   aBigResource      := aBigResourceFormaPago()
   aPressResource    := aPressResourceFormaPago()

   nOrd              := ( dbfFormasPago )->( OrdSetFocus( "nPosTpv" ) )

   ( dbfFormasPago )->( dbGoTop() )
   while len( aButtons ) < 5 .and. !( dbfFormasPago )->( eof() )

      oButton                 := TButtonPago()
      oButton:cBigResource    := aBigResource[ Min( Max( ( dbfFormasPago )->nImgTpv, 1 ), len( aBigResource ) ) ]
      oButton:cPressResource  := aPressResource[ Min( Max( ( dbfFormasPago )->nImgTpv, 1 ), len( aPressResource ) ) ]
      oButton:cText           := Rtrim( ( dbfFormasPago )->cDesPago )
      oButton:cCode           := Rtrim( ( dbfFormasPago )->cCodPago )

      aAdd( aButtons, oButton )

      ( dbfFormasPago )->( dbSkip() )

   end while

   ( dbfFormasPago )->( OrdSetFocus( nOrd ) )

Return ( aButtons )

//---------------------------------------------------------------------------//

Class TButtonPago

   Data  oButton
   Data  oSay

   Data  cBigResource   Init ""
   Data  cPressResource Init ""
   Data  cText          Init ""
   Data  cCode          Init ""

End Class

//---------------------------------------------------------------------------//

#ifndef __PDA__

FUNCTION BrwFPago( oGet, oGet2, lBigStyle )

	local oDlg
   local oSayTit
   local oBtn
	local oGet1
	local cGet1
	local oBrw
   local nOrd        := GetBrwOpt( "BrwFPago" )
	local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local cCbxOrd     := "Código"
   local nLevel      := nLevelUsr( "01039" )
   local oSayText
   local cSayText    := "Formas de pago"
   local cReturn     := Space( 2 )

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   DEFAULT lBigStyle := .f.

   if !OpenFiles()
      Return .f.
   end if

   nOrd              := ( dbfFormasPago )->( OrdSetFocus( nOrd ) )
   ( dbfFormasPago )->( dbGoTop() )

   if lBigStyle
      DEFINE DIALOG oDlg RESOURCE "BIGHELPENTRY"   TITLE "Seleccionar formas de pago"
   else
      DEFINE DIALOG oDlg RESOURCE "HELPENTRY"      TITLE "Seleccionar formas de pago"
   end if

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfFormasPago ) );
         VALID    ( OrdClearScope( oBrw, dbfFormasPago ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfFormasPago )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus(), oCbxOrd:refresh() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfFormasPago
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Formas de pago"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPago"
         :bEditValue       := {|| ( dbfFormasPago )->cCodPago }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesPago"
         :bEditValue       := {|| ( dbfFormasPago )->cDesPago }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      if lBigStyle
         oBrw:nHeaderHeight   := 36
         oBrw:nFooterHeight   := 36
         oBrw:nLineHeight     := 36
      end if

   if ( "PDA" $ cParamsMain() )

      REDEFINE SAY oSayText VAR cSayText ;
         ID       100 ;
         OF       oDlg

   end if

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      if !( "PDA" $ cParamsMain() )

         REDEFINE BUTTON ;
            ID       500 ;
            OF       oDlg ;
            WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport() ) ;
            ACTION   ( WinAppRec( oBrw, bEdit, dbfFormasPago ) )

         REDEFINE BUTTON ;
            ID       501 ;
            OF       oDlg ;
            WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() ) ;
            ACTION   ( WinEdtRec( oBrw, bEdit, dbfFormasPago ) )

         if nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport()
            oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw, bEdit, dbfFormasPago ) } )
         end if

         if nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport()
            oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw, bEdit, dbfFormasPago ) } )
         end if

      end if

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER


   if oDlg:nResult == IDOK

      cReturn     := ( dbfFormasPago )->cCodPago

      if IsObject( oGet )
         oGet:cText( ( dbfFormasPago )->cCodPago )
      end if

      if IsObject( oGet2 )
         oGet2:cText( ( dbfFormasPago )->cDesPago )
      end if

   end if

   OrdClearScope( oBrw, dbfFormasPago )

   SetBrwOpt( "BrwFPago", ( dbfFormasPago )->( OrdNumber() ) )

   CloseFiles()

   if IsObject( oGet )
      oGet:SetFocus()
   end if

RETURN ( cReturn )

#endif

//-------------------------------------------------------------------------//

FUNCTION cFpago( oGet, dbfFormasPago, oGetNombre, oGetPorcentajeEntrega, oGetPorcentajeDescuento )

   local nOrd
   local lClose   := .f.
   local lValid   := .f.
   local xValor   := Upper( oGet:varGet() )

   if Empty( xValor )
      if IsObject( oGetNombre )
         oGetNombre:cText( "" )
      end if
      return .t.
   end if

   if ( Alltrim( xValor ) == Replicate( "Z", len( Alltrim( xValor ) ) ) )
      return .t.
   end if

   if Empty( dbfFormasPago )

      USE ( cPatGrp() + "FPago.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFormasPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPago.Cdx" ) ADDITIVE

      lClose      := .t.

   else

      nOrd        := ( dbfFormasPago )->( ordSetFocus( "cCodPago" ) )

   end if

   if ( dbfFormasPago )->( dbSeek( xValor ) )

      oGet:cText( ( dbfFormasPago )->cCodPago )

      if IsObject( oGetNombre )
         oGetNombre:cText( ( dbfFormasPago )->cDesPago )
      end if

      if IsObject( oGetPorcentajeEntrega )
         oGetPorcentajeEntrega:cText( ( dbfFormasPago )->nEntIni )
      end if

      if IsObject( oGetPorcentajeDescuento )
         oGetPorcentajeDescuento:cText( ( dbfFormasPago )->nPctDto )
      end if

      lValid      := .t.

   else

      MsgStop( "Forma de pago " + xValor + " no encontrada" )

   end if

   if lClose
      ( dbfFormasPago )->( dbCloseArea() )
   else
      ( dbfFormasPago )->( ordSetFocus( nOrd ) )
   end if

Return ( lValid )

//---------------------------------------------------------------------------//

Static Function ChangePosition( lInc )

   local aPos
   local nPos     := 1
   local aRec     := {}
   local nRec     := ( dbfFormasPago )->( Recno() )
   local nOrd     := ( dbfFormasPago )->( OrdSetFocus( "nPosTpv" ) )

   CursorWait()

   do case
      case IsTrue( lInc )

         if ( dbfFormasPago )->( dbRLock() )
            ( dbfFormasPago )->nPosTpv   := ( dbfFormasPago )->nPosTpv + 1.5
         end if
         ( dbfFormasPago )->( dbUnLock() )

      case IsFalse( lInc )

         if ( dbfFormasPago )->( dbRLock() )
            ( dbfFormasPago )->nPosTpv   := ( dbfFormasPago )->nPosTpv - 1.5
         end if
         ( dbfFormasPago )->( dbUnLock() )

   end case

   //--------------------------------------------------------------------------

   ( dbfFormasPago )->( dbGoTop() )
   while !( dbfFormasPago )->( eof() )

      if ( dbfFormasPago )->lShwTpv
         aAdd( aRec, { ( dbfFormasPago )->( Recno() ), nPos++ } )
      end if

      ( dbfFormasPago )->( dbSkip() )

   end while

   //--------------------------------------------------------------------------

   for each aPos in aRec

      ( dbfFormasPago )->( dbGoTo( aPos[ 1 ] ) )

      if ( dbfFormasPago )->( dbRLock() )
         ( dbfFormasPago )->nPosTpv      := aPos[ 2 ]
         ( dbfFormasPago )->( dbUnLock() )
      end if

   next

   //--------------------------------------------------------------------------

   CursorWE()

   ( dbfFormasPago )->( dbGoTo( nRec ) )
   ( dbfFormasPago )->( OrdSetFocus( nOrd ) )

Return ( nil )

//---------------------------------------------------------------------------//

function cFPagoWeb( cCodWeb, cFPago )

   local cCodigoFormaPago  := ""
   local nRec              := ( cFPago )->( Recno() )
   local nOrdAnt           := ( cFPago )->( OrdSetFocus( "cCodWeb" ) )

   if !Empty( cCodWeb ) 
      
      if ( cFPago )->( dbSeek( cCodWeb ) )

         cCodigoFormaPago     := ( cFPago )->cCodPago

      else

         cCodigoFormaPago     := cDefFpg()

      end if

   end if

   ( cFPago )->( dbGoTo( nRec ) )
   ( cFPago )->( OrdSetFocus( nOrdAnt ) )

return cCodigoFormaPago

//---------------------------------------------------------------------------//

FUNCTION GridBrwfPago( oGet, oGet2 )

   local oDlg
   local oSayTit
   local oBtn
   local oGet1
   local cGet1       := Space( 100 )
   local oBrw
   local nOrd        := GetBrwOpt( "BrwFPago" )
   local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local cCbxOrd     := "Código"
   local nLevel      := nLevelUsr( "01039" )
   local oSayText
   local cSayText    := "Formas de pago"
   local cReturn     := Space( 2 )
   local oSayGeneral
   local oBtnAceptar
   local oBtnCancelar
   local oBtnAdd
   local oBtnEdt
   local oBtnUp
   local oBtnDown
   local oBtnUpPage
   local oBtnDownPage

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if !OpenFiles()
      Return .f.
   end if

   nOrd              := ( dbfFormasPago )->( OrdSetFocus( nOrd ) )
   ( dbfFormasPago )->( dbGoTop() )

   oDlg           := TDialog():New( 1, 5, 40, 100, "Buscar forma de pago",,, .f., nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ),, rgb(255,255,255),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )

   oSayGeneral    := TGridSay():Build(    {  "nRow"      => 0,;
                                             "nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                                             "bText"     => {|| "Buscar forma de pago" },;
                                             "oWnd"      => oDlg,;
                                             "oFont"     => oGridFontBold(),;
                                             "lPixels"   => .t.,;
                                             "nClrText"  => Rgb( 0, 0, 0 ),;
                                             "nClrBack"  => Rgb( 255, 255, 255 ),;
                                             "nWidth"    => {|| GridWidth( 8, oDlg ) },;
                                             "nHeight"   => 32,;
                                             "lDesign"   => .f. } )

   oBtnAceptar    := TGridImage():Build(  {  "nTop"      => 5,;
                                             "nLeft"     => {|| GridWidth( 10.5, oDlg ) },;
                                             "nWidth"    => 32,;
                                             "nHeight"   => 32,;
                                             "cResName"  => "flat_check_64",;
                                             "bLClicked" => {|| oDlg:End( IDOK ) },;
                                             "oWnd"      => oDlg } )

   oBtnCancelar   := TGridImage():Build(  {  "nTop"      => 5,;
                                             "nLeft"     => {|| GridWidth( 9.5, oDlg ) },;
                                             "nWidth"    => 32,;
                                             "nHeight"   => 32,;
                                             "cResName"  => "flat_del_64",;
                                             "bLClicked" => {|| oDlg:End() },;
                                             "oWnd"      => oDlg } )

   // Texto de busqueda--------------------------------------------------------

   oGet1       := TGridGet():Build(    {     "nRow"      => 38,;
                                             "nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, cGet1, cGet1 := u ) },;
                                             "oWnd"      => oDlg,;
                                             "nWidth"    => {|| GridWidth( 9, oDlg ) },;
                                             "nHeight"   => 25,;
                                             "bValid"    => {|| OrdClearScope( oBrw, dbfFormasPago ) },;
                                             "bChanged"  => {| nKey, nFlags, Self | AutoSeek( nKey, nFlags, Self, oBrw, dbfFormasPago, .t. ) } } )

   oCbxOrd     := TGridComboBox():Build(  {  "nRow"      => 38,;
                                             "nCol"      => {|| GridWidth( 9.5, oDlg ) },;
                                             "bSetGet"   => {|u| if( PCount() == 0, cCbxOrd, cCbxOrd := u ) },;
                                             "oWnd"      => oDlg,;
                                             "nWidth"    => {|| GridWidth( 2, oDlg ) },;
                                             "nHeight"   => 25,;
                                             "aItems"    => aCbxOrd,;
                                             "bChange"   => {|| ( dbfFormasPago )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus(), oCbxOrd:refresh() } } )

   oBtnAdd           := TGridImage():Build(  {  "nTop"      => 70,;
                                                   "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_add_64",;
                                                   "bLClicked" => {|| nil },;
                                                   "bWhen"     => {|| .f. },;
                                                   "oWnd"      => oDlg } )

      oBtnEdt           := TGridImage():Build(  {  "nTop"      => 70,;
                                                   "nLeft"     => {|| GridWidth( 1.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_edit_64",;
                                                   "bLClicked" => {|| nil },;
                                                   "bWhen"     => {|| .f. },;
                                                   "oWnd"      => oDlg } )

      oBtnUpPage        := TGridImage():Build(  {  "nTop"      => 70,;
                                                   "nLeft"     => {|| GridWidth( 7.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_page_up_64",;
                                                   "bLClicked" => {|| oBrw:PageUp(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh()  },;
                                                   "oWnd"      => oDlg } )

      oBtnUp         := TGridImage():Build(  {     "nTop"      => 70,;
                                                   "nLeft"     => {|| GridWidth( 8.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_up_64",;
                                                   "bLClicked" => {|| oBrw:GoUp(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh()  },;
                                                   "oWnd"      => oDlg } )

      oBtnDown          := TGridImage():Build(  {  "nTop"      => 70,;
                                                   "nLeft"     => {|| GridWidth( 9.0, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_down_64",;
                                                   "bLClicked" => {|| oBrw:GoDown(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh() },;
                                                   "oWnd"      => oDlg } )

      oBtnDownPage      := TGridImage():Build(  {  "nTop"      => 70,;
                                                   "nLeft"     => {|| GridWidth( 10.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "flat_page_down_64",;
                                                   "bLClicked" => {|| oBrw:PageDown(), oBrw:Select( 0 ), oBrw:Select( 1 ), oBrw:Refresh() },;
                                                   "oWnd"      => oDlg } )

   /*
   Rejilla de datos------------------------------------------------------------
   */

   oBrw                 := TGridIXBrowse():New( oDlg )

   oBrw:nTop            := oBrw:EvalRow( 110 )
   oBrw:nLeft           := oBrw:EvalCol( {|| GridWidth( 0.5, oDlg ) } )
   oBrw:nWidth          := oBrw:EvalWidth( {|| GridWidth( 11, oDlg ) } )
   oBrw:nHeight         := oBrw:EvalHeight( {|| GridHeigth( oDlg ) - oBrw:nTop - 10 } )

   oBrw:cAlias          := dbfFormasPago
   oBrw:nMarqueeStyle   := 5
   oBrw:cName           := "BrwGridFormaPago"

   with object ( oBrw:AddCol() )
      :cHeader          := "Código"
      :cSortOrder       := "cCodPago"
      :bEditValue       := {|| ( dbfFormasPago )->cCodPago }
      :nWidth           := 120
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( oBrw:AddCol() )
      :cHeader          := "Nombre"
      :cSortOrder       := "cDesPago"
      :bEditValue       := {|| ( dbfFormasPago )->cDesPago }
      :nWidth           := 300
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

   oBrw:nHeaderHeight   := 40
   oBrw:nFooterHeight   := 40
   oBrw:nRowHeight      := 40

   oBrw:CreateFromCode( 105 )

   // Dialogo------------------------------------------------------------------

   oDlg:bResized        := {|| GridResize( oDlg ) }
   oDlg:bStart          := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER ON INIT ( GridMaximize( oDlg ) )

   if oDlg:nResult == IDOK

      cReturn     := ( dbfFormasPago )->cCodPago

      if IsObject( oGet )
         oGet:cText( ( dbfFormasPago )->cCodPago )
      end if

      if IsObject( oGet2 )
         oGet2:cText( ( dbfFormasPago )->cDesPago )
      end if

   end if

   OrdClearScope( oBrw, dbfFormasPago )

   SetBrwOpt( "BrwFPago", ( dbfFormasPago )->( OrdNumber() ) )

   CloseFiles()

   if IsObject( oGet )
      oGet:SetFocus()
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//