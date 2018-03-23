#ifndef __PDA__
#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "Report.ch"

static oWndBrw
static nView

static aBigResource
static aPressResource
static aTexto

static bEdit         := { |aTmp, aGet, dbfFormasPago, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfFormasPago, oBrw, bWhen, bValid, nMode ) }

#ifndef __PDA__

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( cPatEmp )

   local lOpen          := .t.
   local oBlock

   DEFAULT cPatEmp      := cPatEmp()

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      nView             := D():CreateView()

      D():FormasPago( nView )

      /*
      Inicializacion de variables-------------------------------------------------
      */

      aBigResource      := aLittleResourceFormaPago()
      aTexto            := aTextoResourceFormaPago()

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )

      CloseFiles()
      
      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN lOpen

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if oWndBrw != nil
      oWndBrw  := nil
   end if

   D():DeleteView( nView )

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

      nLevel            := Auth():Level( oMenuItem )
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
         MRU      "gc_credit_cards_16";
         BITMAP   clrTopArchivos ;
         ALIAS    ( D():FormasPago( nView ) ) ;
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, D():FormasPago( nView ) ) );
         DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, D():FormasPago( nView ) ) );
         EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, D():FormasPago( nView ) ) ) ;
         DELETE   ( WinDelRec(  oWndBrw:oBrw, D():FormasPago( nView ) ) );
         LEVEL    nLevel ;
         OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPago"
         :bEditValue       := {|| ( D():FormasPago( nView ) )->cCodPago }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesPago"
         :bEditValue       := {|| ( D():FormasPago( nView ) )->cDesPago }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Táctil"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( D():FormasPago( nView ) )->lShwTpv }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "TACTIL16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Posición"
         :cSortOrder       := "nPosTpv"
         :bEditValue       := {|| if( ( D():FormasPago( nView ) )->lShwTpv, Trans( ( D():FormasPago( nView ) )->nPosTpv, "99" ), "" ) }
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
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, D():FormasPago( nView ) ) );
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

   /*
   Valores por defecto---------------------------------------------------------
   */

   if nMode == APPD_MODE
      aTmp[ ( dbfFormasPago )->( fieldPos( "nPlazos" ) ) ]  := 1
      aTmp[ ( dbfFormasPago )->( fieldPos( "nPlaUno" ) ) ]  := 0
   end if

   if aTmp[ ( dbfFormasPago )->( fieldPos( "nTipPgo" ) ) ] == 0
      aTmp[ ( dbfFormasPago )->( fieldPos( "nTipPgo" ) ) ]  := 1
   end if

   if aTmp[ ( dbfFormasPago )->( fieldPos( "nCobRec" ) ) ] == 0
      aTmp[ ( dbfFormasPago )->( fieldPos( "nCobRec" ) ) ]  := 1
   end if

   if Empty( aTmp[ ( dbfFormasPago )->( fieldPos( "nImgTpv" ) ) ] )
      aTmp[ ( dbfFormasPago )->( fieldPos( "nImgTpv" ) ) ]  := 1
   end if

   if Empty( aTmp[ ( dbfFormasPago )->( fieldPos( "nPosTpv" ) ) ] )
      aTmp[ ( dbfFormasPago )->( fieldPos( "nPosTpv" ) ) ]  := getMaxPosition()
   end if

   if aTmp[ ( dbfFormasPago )->( fieldPos( "cCodPago" ) ) ] == "00"
      aTmp[ ( dbfFormasPago )->( fieldPos( "lShwTpv" ) ) ]  := .t.
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

   cCmbImagen           := aTexto[ Min( Max( aTmp[ ( dbfFormasPago )->( fieldPos( "nImgTpv" ) ) ], 1 ), len( aTexto ) ) ]

   /*
   Dialogo---------------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "FORMAS_PAGO" TITLE LblTitle( nMode ) + "formas de pagos"

      REDEFINE GET oGet VAR aTmp[ ( dbfFormasPago )->( fieldPos( "cCodPago" ) ) ];
         ID       100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( oGet, dbfFormasPago ) ) ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET oGet2 VAR aTmp[ ( dbfFormasPago )->( fieldPos( "cDesPago" ) ) ]  ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE RADIO aTmp[ ( dbfFormasPago )->( fieldPos( "nTipPgo" ) ) ] ;
         ID       111, 112, 113 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aTmp[ ( dbfFormasPago )->( fieldPos( "nPctCom" ) ) ];
         ID       120 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. aTmp[ ( dbfFormasPago )->( fieldPos( "nTipPgo" ) ) ] == 3 ) ;
         PICTURE  "@E 99.99" ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfFormasPago )->( fieldPos( "lDomBan" ) ) ];
         ID       125;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE RADIO aTmp[ ( dbfFormasPago )->( fieldPos( "nCobRec" ) ) ] ;
         ID       140, 141 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "nPlazos" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "nPlazos" ) ) ];
         ID       320 ;
         PICTURE  "999" ;
         VALID    ( aTmp[ ( dbfFormasPago )->( fieldPos( "nPlazos" ) ) ] > 0 ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         MIN      1 ;
         MAX      999 ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "nPlaUno" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "nPlaUno" ) ) ];
         ID       330 ;
         PICTURE  "999";
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         MIN      0 ;
         MAX      999 ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "nDiaPla" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "nDiaPla" ) ) ];
         ID       340 ;
         PICTURE  "999";
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( dbfFormasPago )->( fieldPos( "nPlazos" ) ) ] > 1 ) ;
         SPINNER ;
         MIN      0 ;
         MAX      999 ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "nPlaUlt" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "nPlaUlt" ) ) ];
         ID       350 ;
         PICTURE  "999";
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( dbfFormasPago )->( fieldPos( "nPlazos" ) ) ] > 1 ) ;
         SPINNER ;
         MIN      0 ;
         MAX      999 ;
         OF       oDlg

      //Datos del banco de la empresa--------------------------------------------

      REDEFINE CHECKBOX aTmp[ ( dbfFormasPago )->( fieldPos( "lUtlBnc" ) ) ];
         ID       126;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "cBanco" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "cBanco" ) ) ];
         ID       210 ;
         WHEN     ( aTmp[ ( dbfFormasPago )->( fieldPos( "lUtlBnc" ) ) ] .and. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwBncEmp( aGet[ ( dbfFormasPago )->( fieldPos( "cBanco" ) ) ], aGet[ ( dbfFormasPago )->( fieldPos( "cPaisIBAN" ) ) ],;
                               aGet[ ( dbfFormasPago )->( fieldPos( "cCtrlIBAN" ) ) ], aGet[ ( dbfFormasPago )->( fieldPos( "cEntBnc" ) ) ], ;
                               aGet[ ( dbfFormasPago )->( fieldPos( "cSucBnc" ) ) ], aGet[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ],;
                               aGet[ ( dbfFormasPago )->( fieldPos( "cCtaBnc" ) ) ] ) );
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "cPaisIBAN" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "cPaisIBAN" ) ) ] ;
         PICTURE  "@!" ;
         ID       370 ;
         WHEN     ( aTmp[ ( dbfFormasPago )->( fieldPos( "lUtlBnc" ) ) ] .and. nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit(  aTmp[ ( dbfFormasPago )->( fieldPos( "cPaisIBAN" ) ) ],;
                                 aTmp[ ( dbfFormasPago )->( fieldPos( "cEntBnc" ) ) ],;
                                 aTmp[ ( dbfFormasPago )->( fieldPos( "cSucBnc" ) ) ],;
                                 aTmp[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ],;
                                 aTmp[ ( dbfFormasPago )->( fieldPos( "cCtaBnc" ) ) ],;
                                 aGet[ ( dbfFormasPago )->( fieldPos( "cCtrlIBAN" ) ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "cCtrlIBAN" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "cCtrlIBAN" ) ) ] ;
         ID       380 ;
         WHEN     ( aTmp[ ( dbfFormasPago )->( fieldPos( "lUtlBnc" ) ) ] .and. nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit(  aTmp[ ( dbfFormasPago )->( fieldPos( "cPaisIBAN" ) ) ],;
                                 aTmp[ ( dbfFormasPago )->( fieldPos( "cEntBnc" ) ) ],;
                                 aTmp[ ( dbfFormasPago )->( fieldPos( "cSucBnc" ) ) ],;
                                 aTmp[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ],;
                                 aTmp[ ( dbfFormasPago )->( fieldPos( "cCtaBnc" ) ) ],;
                                 aGet[ ( dbfFormasPago )->( fieldPos( "cCtrlIBAN" ) ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "cEntBnc" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "cEntBnc" ) ) ];
         ID       220 ;
         WHEN     ( aTmp[ ( dbfFormasPago )->( fieldPos( "lUtlBnc" ) ) ] .and. nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfFormasPago )->( fieldPos( "cEntBnc" ) ) ], ;
                              aTmp[ ( dbfFormasPago )->( fieldPos( "cSucBnc" ) ) ], ;
                              aTmp[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ], ;
                              aTmp[ ( dbfFormasPago )->( fieldPos( "cCtaBnc" ) ) ], ;
                              aGet[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ] ),;
                     aGet[ ( dbfFormasPago )->( fieldPos( "cPaisIBAN" ) ) ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "cSucBnc" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "cSucBnc" ) ) ];
         ID       230 ;
         WHEN     ( aTmp[ ( dbfFormasPago )->( fieldPos( "lUtlBnc" ) ) ] .and. nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfFormasPago )->( fieldPos( "cEntBnc" ) ) ],;
                              aTmp[ ( dbfFormasPago )->( fieldPos( "cSucBnc" ) ) ],;
                              aTmp[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ],;
                              aTmp[ ( dbfFormasPago )->( fieldPos( "cCtaBnc" ) ) ],;
                              aGet[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ] ),;
                     aGet[ ( dbfFormasPago )->( fieldPos( "cPaisIBAN" ) ) ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ];
         ID       240 ;
         WHEN     ( aTmp[ ( dbfFormasPago )->( fieldPos( "lUtlBnc" ) ) ] .and. nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfFormasPago )->( fieldPos( "cEntBnc" ) ) ],; 
                              aTmp[ ( dbfFormasPago )->( fieldPos( "cSucBnc" ) ) ],; 
                              aTmp[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ],; 
                              aTmp[ ( dbfFormasPago )->( fieldPos( "cCtaBnc" ) ) ],; 
                              aGet[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ] ),;
                     aGet[ ( dbfFormasPago )->( fieldPos( "cPaisIBAN" ) ) ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "cCtaBnc" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "cCtaBnc" ) ) ];
         ID       250 ;
         PICTURE  "9999999999" ;
         WHEN     ( aTmp[ ( dbfFormasPago )->( fieldPos( "lUtlBnc" ) ) ] .and. nMode != ZOOM_MODE ) ;
         VALID    (  lCalcDC( aTmp[ ( dbfFormasPago )->( fieldPos( "cEntBnc" ) ) ],; 
                              aTmp[ ( dbfFormasPago )->( fieldPos( "cSucBnc" ) ) ],; 
                              aTmp[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ],; 
                              aTmp[ ( dbfFormasPago )->( fieldPos( "cCtaBnc" ) ) ], ;
                              aGet[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ] ),;
                     aGet[ ( dbfFormasPago )->( fieldPos( "cPaisIBAN" ) ) ]:lValid() ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "cCtaCobro" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "cCtaCobro" ) ) ] ;
         ID       280 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( !Empty( cRutCnt() ) .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ ( dbfFormasPago )->( fieldPos( "cCtaCobro" ) ) ], oGetCob ) ) ;
         VALID    ( MkSubcuenta( aGet[ ( dbfFormasPago )->( fieldPos( "cCtaCobro" ) ) ], ;
                                 {  aTmp[ ( dbfFormasPago )->( fieldPos( "cCtaCobro" ) ) ], ;
                                    aTmp[ ( dbfFormasPago )->( fieldPos( "cDesPago" ) ) ] }, oGetCob ) );
         OF oDlg

      REDEFINE GET oGetCob VAR cGetCob ;
         ID       290 ;
         WHEN     ( .F. );
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "cCtaGas" ) ) ] VAR aTmp[ ( dbfFormasPago )->( fieldPos( "cCtaGas" ) ) ] ;
         ID       300 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( !Empty( cRutCnt() ) .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ ( dbfFormasPago )->( fieldPos( "cCtaGas" ) ) ], oGetGas ) ) ;
         VALID    ( MkSubcuenta( aGet[ ( dbfFormasPago )->( fieldPos( "cCtaGas" ) ) ], ;
                                 {  aTmp[ ( dbfFormasPago )->( fieldPos( "cCtaGas" ) ) ], ;
                                    aTmp[ ( dbfFormasPago )->( fieldPos( "cDesPago" ) ) ] }, oGetGas ) );
         OF       oDlg

      REDEFINE GET oGetGas VAR cGetGas ;
         ID       301 ;
         COLOR    CLR_GET ;
         WHEN     ( .F. );
         OF       oDlg

      //Controles para incluir en tpv-----------------------------------------

      REDEFINE CHECKBOX aTmp[ ( dbfFormasPago )->( fieldPos( "lShwTpv" ) ) ] ;
         ID       400 ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmp[ ( dbfFormasPago )->( fieldPos( "cCodPago" ) ) ] != "00" ) ;
         OF       oDlg

      REDEFINE COMBOBOX oCmbImagen ;
         VAR      cCmbImagen ;
         ID       410 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ( aTexto ) ;
         BITMAPS  ( aBigResource )

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "nPosTpv" ) ) ] ;
         VAR      aTmp[ ( dbfFormasPago )->( fieldPos( "nPosTpv" ) ) ] ;
         ID       420 ;
         PICTURE  "99";
         WHEN     ( nMode != ZOOM_MODE );
         VALID    ( aTmp[ ( dbfFormasPago )->( fieldPos( "nPosTpv" ) ) ] >= 1 .and. aTmp[ ( dbfFormasPago )->( fieldPos( "nPosTpv" ) ) ] <= 99 ) ;
         SPINNER ;
         MIN      ( 1 ) ;
         MAX      ( 99 ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfFormasPago )->( fieldPos( "cCodWeb" ) ) ] ;
         VAR      aTmp[ ( dbfFormasPago )->( fieldPos( "cCodWeb" ) ) ] ;
         ID       430 ;
         WHEN     ( nMode != ZOOM_MODE ); 
         OF       oDlg   

      REDEFINE RADIO aTmp[ ( dbfFormasPago )->( fieldPos( "nGenDoc" ) ) ] ;
         ID       440, 441 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
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

      REDEFINE GET   aGet[ ( dbfFormasPago )->( FieldPos( "cCodEdi" ) ) ];
         VAR         aTmp[ ( dbfFormasPago )->( FieldPos( "cCodEdi" ) ) ];
         ID          360 ;
         OF          oDlg

      // Botones --------------------------------------------------------------

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE );
         ACTION   ( lPreSave( aTmp, aGet, oBrw, nMode, oDlg, oGet, oGet2, oCmbImagen ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| lPreSave( aTmp, aGet, oBrw, nMode, oDlg, oGet, oGet2, oCmbImagen ) } )
      end if

      oDlg:AddFastKey ( VK_F1, {|| GoHelp() } )

      oDlg:bStart := {|| oGet:SetFocus(), aGet[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ]:lValid(), aGet[ ( dbfFormasPago )->( fieldPos( "cDigBnc" ) ) ]:lValid() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION lPreSave( aTmp, aGet, oBrw, nMode, oDlg, oGet, oGet2, oCmbImagen )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( aTmp[ ( D():FormasPago( nView ) )->( fieldPos( "cCodPago" ) ) ] )
         MsgStop( "El código de la forma de pago no puede estar vacío." )
         oGet:SetFocus()
         Return nil
      end if

      D():getStatusFormasPago( nView ) 
      if D():gotoFormasPago( aTmp[ ( D():FormasPago( nView ) )->( fieldPos( "cCodPago" ) ) ], nView )
         msgStop( "Código ya existe " + alltrim( aTmp[ ( D():FormasPago( nView ) )->( fieldPos( "cCodPago" ) ) ] ) )
         Return nil
      end if
      D():setStatusFormasPago( nView ) 

   end if

   if Empty( aTmp[ ( D():FormasPago( nView ) )->( fieldPos( "cDesPago" ) ) ] )
      MsgStop( "El nombre de la forma de pago no puede estar vacío." )
      oGet2:SetFocus()
      Return nil
   end if

   if aTmp[ ( D():FormasPago( nView ) )->( fieldPos( "nPlazos" ) ) ] < 1
      msgStop( "El número de plazos tiene que ser mayor que cero." )
      aGet[ ( D():FormasPago( nView ) )->( fieldPos( "nPlazos" ) ) ]:SetFocus()
      Return nil
   end if

   // Numero de la imagen------------------------------------------------------

   aTmp[ ( D():FormasPago( nView ) )->( fieldPos( "nImgTpv" ) ) ]  := oCmbImagen:nAt

   // Grabamos el registro-----------------------------------------------------

   WinGather( aTmp, aGet, D():FormasPago( nView ), oBrw, nMode )

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

FUNCTION cNbrFPago( cCodPago, dbfFormasPago )

	local cText			:= ""
   local lClose      := .f.

   if dbfFormasPago == NIL
      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFormasPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE
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
      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFormasPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE
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
      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFormasPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE
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

FUNCTION lFormaPagoCobrado( cCodPago, dbfFormasPago )

   local lCobrado    := .f.
   local lClose      := .f.

   if dbfFormasPago == NIL
      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFormasPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE
      lClose         := .t.
   end if

   if ( dbfFormasPago )->( dbSeek( cCodPago ) )
      lCobrado       := ( dbfFormasPago )->nCobRec < 2
   end if

   if lClose
      CLOSE ( dbfFormasPago )
   end if

RETURN lCobrado

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

         if dbSeekInOrd( cCodPgo, "cCodPago", dbfFormasPago )
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

function IsFPago( cPatEmp )

   local nFields

   local oBlock
   local oError

   local IsFPago     := .f.
   local dbfFormasPago

   DEFAULT cPatEmp   := cPatEmp()

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
         ( dbfFormasPago )->nPlaUlt      := 0
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

   DEFAULT cPath     := cPatEmp()

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
      ( dbfFormasPago )->( ordCreate( cPath + "FPAGO.CDX", "cCodWeb", "upper( Field->cCodWeb )", {|| upper( Field->cCodWeb ) }, ) )

      ( dbfFormasPago )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de formas de pago", "Reindexando formas de pago" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION mkFPago( cPath, lAppend, cPathOld )

   local dbfFormasPago

   DEFAULT cPath     := cPatEmp()
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
   aAdd( aBase, { "nPlaUlt",   "N",   3,   0, "Numero de días hasta el último pago"                    ,  "",   "", "( cDbfPgo )" } )
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
   aAdd( aBase, { "cCodWeb",   "C", 200,   0, "Modulo web para la forma de pago"                       ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "lDomBan",   "L",   1,   0, "Domiciliacion bancaria"                                 ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "cCodEdi",   "C",  10,   0, "Código para pasar a plataforma EDI"                     ,  "",   "", "( cDbfPgo )" } )
   aAdd( aBase, { "nGenDoc",   "N",   1,   0, "Generar documento como presupuesto o pedido"            ,  "",   "", "( cDbfPgo )" } )
   
return ( aBase )

//---------------------------------------------------------------------------//

function aLittleResourceFormaPago()

   local aResources := {}

   aAdd( aResources, "gc_money2_16" )
   aAdd( aResources, "gc_credit_cards_16" )
   aAdd( aResources, "gc_moneybag_euro_16" )
   aAdd( aResources, "gc_symbol_percent_16" )
   aAdd( aResources, "gc_shopping_basket_16" )

return ( aResources )

//---------------------------------------------------------------------------//

function aMiddleResourceFormaPago()

   local aResources := {}

   aAdd( aResources, "gc_money2_24" )
   aAdd( aResources, "gc_credit_cards_24" )
   aAdd( aResources, "gc_moneybag_euro_24" )
   aAdd( aResources, "gc_symbol_percent_24" )
   aAdd( aResources, "gc_shopping_basket_24" )

return ( aResources )

//---------------------------------------------------------------------------//

function aBigResourceFormaPago()

   local aResources := {}

   aAdd( aResources, "gc_money2_32" )
   aAdd( aResources, "gc_credit_cards_32" )
   aAdd( aResources, "gc_moneybag_euro_32" )
   aAdd( aResources, "gc_symbol_percent_32" )
   aAdd( aResources, "gc_shopping_basket_32" )

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
   local nLevel      := Auth():Level( "01039" )
   local oSayText
   local cSayText    := "Formas de pago"
   local cReturn     := Space( 2 )

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   DEFAULT lBigStyle := .f.

   if !OpenFiles()
      Return .f.
   end if

   nOrd              := ( D():FormasPago( nView ) )->( OrdSetFocus( nOrd ) )
   ( D():FormasPago( nView ) )->( dbGoTop() )

   DEFINE DIALOG  oDlg ;
      RESOURCE    ( if( lBigStyle, "BIGHELPENTRY", "HELPENTRY" ) );
      TITLE       "Seleccionar formas de pago"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, D():FormasPago( nView ) ) );
         VALID    ( OrdClearScope( oBrw, D():FormasPago( nView ) ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( D():FormasPago( nView ) )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus(), oCbxOrd:refresh() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := D():FormasPago( nView )
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Formas de pago"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPago"
         :bEditValue       := {|| ( D():FormasPago( nView ) )->cCodPago }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesPago"
         :bEditValue       := {|| ( D():FormasPago( nView ) )->cDesPago }
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

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinAppRec( oBrw, bEdit, D():FormasPago( nView ) ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinEdtRec( oBrw, bEdit, D():FormasPago( nView ) ) )

      if nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport()
         oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw, bEdit, D():FormasPago( nView ) ) } )
      end if

      if nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport()
         oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw, bEdit, D():FormasPago( nView ) ) } )
      end if

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER


   if oDlg:nResult == IDOK

      cReturn     := ( D():FormasPago( nView ) )->cCodPago

      if IsObject( oGet )
         oGet:cText( ( D():FormasPago( nView ) )->cCodPago )
      end if

      if IsObject( oGet2 )
         oGet2:cText( ( D():FormasPago( nView ) )->cDesPago )
      end if

   end if

   OrdClearScope( oBrw, D():FormasPago( nView ) )

   SetBrwOpt( "BrwFPago", ( D():FormasPago( nView ) )->( OrdNumber() ) )

   CloseFiles()

   if IsObject( oGet )
      oGet:SetFocus()
   end if

RETURN ( cReturn )

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

   if ( alltrim( xValor ) == Replicate( "Z", len( alltrim( xValor ) ) ) )
      return .t.
   end if

   if Empty( dbfFormasPago )

      USE ( cPatEmp() + "FPago.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFormasPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPago.Cdx" ) ADDITIVE

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
   local nRec     := ( D():FormasPago( nView ) )->( Recno() )
   local nOrd     := ( D():FormasPago( nView ) )->( OrdSetFocus( "nPosTpv" ) )

   CursorWait()

   do case
      case IsTrue( lInc )

         if ( D():FormasPago( nView ) )->( dbRLock() )
            ( D():FormasPago( nView ) )->nPosTpv   := ( D():FormasPago( nView ) )->nPosTpv + 1.5
         end if
         ( D():FormasPago( nView ) )->( dbUnLock() )

      case IsFalse( lInc )

         if ( D():FormasPago( nView ) )->( dbRLock() )
            ( D():FormasPago( nView ) )->nPosTpv   := ( D():FormasPago( nView ) )->nPosTpv - 1.5
         end if
         ( D():FormasPago( nView ) )->( dbUnLock() )

   end case

   //--------------------------------------------------------------------------

   ( D():FormasPago( nView ) )->( dbGoTop() )
   while !( D():FormasPago( nView ) )->( eof() )

      if ( D():FormasPago( nView ) )->lShwTpv
         aAdd( aRec, { ( D():FormasPago( nView ) )->( Recno() ), nPos++ } )
      end if

      ( D():FormasPago( nView ) )->( dbSkip() )

   end while

   //--------------------------------------------------------------------------

   for each aPos in aRec

      ( D():FormasPago( nView ) )->( dbGoTo( aPos[ 1 ] ) )

      if ( D():FormasPago( nView ) )->( dbRLock() )
         ( D():FormasPago( nView ) )->nPosTpv      := aPos[ 2 ]
         ( D():FormasPago( nView ) )->( dbUnLock() )
      end if

   next

   //--------------------------------------------------------------------------

   CursorWE()

   ( D():FormasPago( nView ) )->( dbGoTo( nRec ) )
   ( D():FormasPago( nView ) )->( OrdSetFocus( nOrd ) )

Return ( nil )

//---------------------------------------------------------------------------//

function cFPagoWeb( cCodWeb, dbfFormasPago )

   local cCodigoFormaPago  := ""
   local nRec              := ( dbfFormasPago )->( Recno() )
   local nOrdAnt           := ( dbfFormasPago )->( OrdSetFocus( "cCodWeb" ) )

   if !Empty( cCodWeb ) 
      
      if ( dbfFormasPago )->( dbSeek( cCodWeb ) )

         cCodigoFormaPago     := ( dbfFormasPago )->cCodPago

      else

         cCodigoFormaPago     := cDefFpg()

      end if

   end if

   ( dbfFormasPago )->( dbGoTo( nRec ) )
   ( dbfFormasPago )->( OrdSetFocus( nOrdAnt ) )

return cCodigoFormaPago

//---------------------------------------------------------------------------//

Function dNextDayPago( dFechaPartida, nPlazoActual, nPlazosTotales, dbfFormasPago, dbfClientes )

   if Empty( dbfClientes )
      Return ( dFechaPartida )
   end if

   dFechaPartida        += ( dbfFormasPago )->nPlaUno
   dFechaPartida        += ( dbfFormasPago )->nDiaPla * ( nPlazoActual - 1 )

   if ( !empty( ( dbfFormasPago )->nPlaUlt ) ) .and. ( nPlazoActual == nPlazosTotales )
      dFechaPartida     -= ( dbfFormasPago )->nDiaPla
      dFechaPartida     += ( dbfFormasPago )->nPlaUlt
   end if 

Return ( dNexDay( dFechaPartida, dbfClientes ) )

//---------------------------------------------------------------------------//

Static Function getMaxPosition()

   local nRec           := ( D():FormasPago( nView ) )->( recno() )
   local nOrd           := ( D():FormasPago( nView ) )->( ordsetfocus( "nPosTpv" ) )
   local nMaxPosition   := ( D():FormasPago( nView ) )->( ordkeycount() )

   ( D():FormasPago( nView ) )->( ordsetfocus( nOrd ) )
   ( D():FormasPago( nView ) )->( dbgoto( nRec ) )

Return ( nMaxPosition++ )

//---------------------------------------------------------------------------//
