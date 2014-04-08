#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 

static lOpen         := .f.

static oWndBrw
static dbfCajT
static dbfCajL
static dbfImpTik
static dbfVisor
static dbfCajPorta
static dbfDoc
static dbfTmpLin
static cTmpLin
static oCaptura
static nNumTur
static bEdit         := { |aTmp, aGet, dbfCajT, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfCajT, oBrw, bWhen, bValid, nMode ) }
static bEdtDet       := { |aTmp, aGet, dbfCajL, oBrw, bWhen, bValid, nMode, aTmpCaj | EdtDet( aTmp, aGet, dbfCajL, oBrw, bWhen, bValid, nMode, aTmpCaj ) }

//----------------------------------------------------------------------------//

#ifndef __PDA__

STATIC FUNCTION lOpenFiles()

   local oError
   local oBlock

   if lOpen
      MsgStop( 'Imposible abrir ficheros de cajas' )
      Return ( .f. )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      IF !lExistTable( cPatDat() + "Cajas.Dbf" ) .or.;
         !lExistTable( cPatDat() + "CajasL.Dbf" )
         mkCajas()
      END IF

      IF !lExistIndex( cPatDat() + "Cajas.Cdx" ) .or.;
         !lExistIndex( cPatDat() + "CajasL.Cdx" )
         rxCajas()
      END IF

      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

      USE ( cPatDat() + "CajasL.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJASL", @dbfCajL ) )
      SET ADSINDEX TO ( cPatDat() + "CajasL.Cdx" ) ADDITIVE

      USE ( cPatDat() + "ImpTik.Dbf" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "ImpTik", @dbfImpTik ) )
      SET ADSINDEX TO ( cPatDat() + "ImpTik.Cdx" ) ADDITIVE

      USE ( cPatDat() + "Visor.Dbf" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "Visor", @dbfVisor ) )
      SET ADSINDEX TO ( cPatDat() + "Visor.CDX" ) ADDITIVE

      USE ( cPatDat() + "CajPorta.Dbf" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "CajPorta", @dbfCajPorta ) )
      SET ADSINDEX TO ( cPatDat() + "CajPorta.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RDocumen.Dbf" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "RDocumen", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDocumen.Cdx" ) ADDITIVE

      oCaptura          := TCaptura():New( cPatDat() )
      oCaptura:OpenFiles()

      lOpen             := .t.

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de cajas" )

      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   CLOSE ( dbfCajT     )
   CLOSE ( dbfCajL     )
   CLOSE ( dbfDoc      )
   CLOSE ( dbfImpTik   )
   CLOSE ( dbfVisor    )
   CLOSE ( dbfCajPorta )

   dbfCajT     := nil
   dbfCajL     := nil
   dbfDoc      := nil
   dbfImpTik   := nil
   dbfVisor    := nil
   dbfCajPorta := nil

   if !Empty( oCaptura )
      oCaptura:End()
   end if

   oCaptura    := nil

   oWndBrw     := nil

   lOpen       := .f.

RETURN .T.

//----------------------------------------------------------------------------//

FUNCTION Cajas( oMenuItem, oWnd )

   local nLevel

   DEFAULT  oMenuItem   := "01040"
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == nil

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

      /*
      Apertura de ficheros
      */

      if !lOpenFiles()
         return .f.
      end if

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
         XBROWSE ;
			TITLE 	"Cajas" ;
         PROMPT   "Código",;
						"Nombre" ;
         MRU      "Cashier_16";
			ALIAS		( dbfCajT ) ;
         BITMAP   clrTopArchivos ;
         APPEND   WinAppRec( oWndBrw:oBrw, bEdit, dbfCajT ) ;
			EDIT	   WinEdtRec( oWndBrw:oBrw, bEdit, dbfCajT ) ;
         DELETE   WinDelRec( oWndBrw:oBrw, dbfCajT ) ;
         DUPLICAT WinDupRec( oWndBrw:oBrw, bEdit, dbfCajT ) ;
         LEVEL    nLevel ;
			OF 		oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Seleccionada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfCajT )->cCodCaj == oUser():cCaja() }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "cashier_Selet_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCaj"
         :bEditValue       := {|| ( dbfCajT )->cCodCaj }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCaj"
         :bEditValue       := {|| ( dbfCajT )->cNomCaj }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:cHtmlHelp    := "Cajas"

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar" ;
         MRUSEARCH ;
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "SEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( lChgCaja( ( dbfCajT )->cCodCaj, , oWndBrw ) ) ;
         TOOLTIP  "Sele(c)cionar";
         HOTKEY   "C"

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
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
         MRU ;
         HOTKEY   "D";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         MRU ;
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfCajT ) );
         TOOLTIP  "(Z)oom";
         MRU ;
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         MRU ;
         HOTKEY   "E";
         LEVEL    ACC_DELE

#ifndef __TACTIL__

      DEFINE BTNSHELL RESOURCE "IMP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( InfCaj():New( "Listado de cajas" ):Play() ) ;
         TOOLTIP  "(L)istado";
         HOTKEY   "L";
         LEVEL    ACC_IMPR

#endif

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir";
         HOTKEY   "S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfCajT, oBrw, bWhen, bValid, nMode )

   local oDlg
   local oFld
   local oBrwLin
   local oBmpGeneral
   local oBmpFormatos

   if !lUsrMaster()
      msgStop( "Solo el usuario administrador puede modificar las cajas.")
      Return .f.
   end if 

   if nMode == APPD_MODE
      aTmp[ ( dbfCajT )->( FieldPos( "cPrnWin" ) ) ]     := PrnGetName()
      aTmp[ ( dbfCajT )->( FieldPos( "cWinTik" ) ) ]     := PrnGetName()
      aTmp[ ( dbfCajT )->( FieldPos( "cPrnNota" ) ) ]    := PrnGetName()

      aTmp[ ( dbfCajT )->( FieldPos( "nCopTik" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopCom" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopVal" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopDev" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopEnt" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopAlb" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopFac" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopPgo" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopArq" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopPar" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopReg" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopApt" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopEna" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "nCopCie" ) ) ]     := 1
      aTmp[ ( dbfCajT )->( FieldPos( "cNumTur" ) ) ]     := str( 1, 6 )
   end if

   if BeginTrans( aTmp )
      Return .f.
   end if

   DEFINE DIALOG oDlg RESOURCE "CAJAS" TITLE LblTitle( nMode ) + "cajas"

   REDEFINE FOLDER oFld ;
      ID       100 ;
      OF       oDlg ;
      PROMPT   "&General",;
               "&Formatos" ;
      DIALOGS  "CAJAS_01",;
               "CAJAS_02"

      /*
      Primera caja de diálogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpGeneral ;
         ID       800 ;
         RESOURCE "cashier_48_alpha" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[1]

      /*
      Código y nombre de la caja
      -------------------------------------------------------------------------
      */

      REDEFINE GET   aGet[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ] ;
         VAR         aTmp[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ];
			ID          110 ;
         PICTURE     "@!" ;
         WHEN        ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID       ( NotValid( aGet[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ], dbfCajT, .t., "0" ) ) ;
         OF          oFld:aDialogs[1]

      REDEFINE GET   aGet[ ( dbfCajT )->( FieldPos( "cNomCaj" ) ) ] ;
         VAR         aTmp[ ( dbfCajT )->( FieldPos( "cNomCaj" ) ) ] ;
			ID          120 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oFld:aDialogs[1]

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lNoArq" ) ) ] ;
         VAR         aTmp[ ( dbfCajT )->( FieldPos( "lNoArq" ) ) ] ;
         ID          170 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oFld:aDialogs[1]

      // Caja padre------------------------------------------------------------

      REDEFINE GET   aGet[ ( dbfCajT )->( FieldPos( "cCajPrt" ) ) ] ;
         VAR         aTmp[ ( dbfCajT )->( FieldPos( "cCajPrt" ) ) ];
         ID          200 ;
         IDTEXT      201 ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         VALID       ( ValidCajaPadre( aGet, aTmp ) );
         OF          oFld:aDialogs[ 1 ]

      // Proximo turno------------------------------------------------------------

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cNumTur" ) ) ] ;
         VAR      nNumTur ;
         ID       190 ;
         SPINNER ;
         MIN      0 ;
         MAX      999999 ;
         PICTURE  "999999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      /*
      Captura por defecto
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "CCAPCAJ" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "CCAPCAJ" ) ) ];
         ID       130 ;
         IDTEXT   131 ;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oCaptura:Existe( aGet[ ( dbfCajT )->( FieldPos( "CCAPCAJ" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "CCAPCAJ" ) ) ]:oHelpText, "cNombre" ) ) ;
         ON HELP  ( oCaptura:Buscar( aGet[ ( dbfCajT )->( FieldPos( "CCAPCAJ" ) ) ] ) ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      /*
      Impresoras normal
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnWin" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnWin" ) ) ] ;
         ID       140 ;
         OF       oFld:aDialogs[1]

      TBtnBmp():ReDefine( 141, "Printer_preferences_16",,,,,{|| PrinterPreferences( aGet[ ( dbfCajT )->( FieldPos( "cPrnWin" ) ) ] ) }, oFld:aDialogs[1], .f., , .f.,  )

      /*
      Impresora de tickets
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cWinTik" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cWinTik" ) ) ] ;
         ID       150 ;
         OF       oFld:aDialogs[1]

      TBtnBmp():ReDefine( 151, "Printer_preferences_16",,,,,{|| PrinterPreferences( aGet[ ( dbfCajT )->( FieldPos( "cWinTik" ) ) ] ) }, oFld:aDialogs[1], .f., , .f.,  )

      /*
      Impresora de entrega de nota
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnNota" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnNota" ) ) ] ;
         ID       180 ;
         OF       oFld:aDialogs[1]

      TBtnBmp():ReDefine( 181, "Printer_preferences_16",,,,,{|| PrinterPreferences( aGet[ ( dbfCajT )->( FieldPos( "cPrnNota" ) ) ] ) }, oFld:aDialogs[1], .f., , .f.,  )

      REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwLin, bEdtDet, dbfTmpLin, , , aTmp ) )

      REDEFINE BUTTON ;
         ID       501 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwLin, bEdtDet, dbfTmpLin, , , aTmp ) )

      REDEFINE BUTTON ;
         ID       502 ;
			OF 		oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DbDelRec( oBrwLin, dbfTmpLin ) )

      /*
      Browse de lineas---------------------------------------------------------
      */

      oBrwLin                    := IXBrowse():New( oFld:aDialogs[1] )

      oBrwLin:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLin:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLin:cAlias             := dbfTmpLin
      oBrwLin:cName              := "Cajas.Detalle"

      oBrwLin:nMarqueeStyle      := 5
      oBrwLin:lHScroll           := .f.
      oBrwLin:lRecordSelector    := .f.

      oBrwLin:CreateFromResource( 160 )

      if nMode != ZOOM_MODE
         oBrwLin:bLDblClick      := {|| WinEdtRec( oBrwLin, bEdtDet, dbfTmpLin, , , aTmp ) }
      end if

      with object ( oBrwLin:AddCol() )
         :cHeader                := "Tipo"
         :bEditValue             := {|| ( dbfTmpLin )->cTipImp }
         :nWidth                 := 145
      end with

      with object ( oBrwLin:AddCol() )
         :cHeader                := "Impresora"
         :bEditValue             := {|| ( dbfTmpLin )->cNomPrn }
         :nWidth                 := 335
      end with

      /*
      Segunda caja de diálogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpFormatos ;
         ID       800 ;
         RESOURCE "document_edit_48_alpha" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[2]

      /*
      Formato de tickets
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnTik" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnTik" ) ) ] ;
         ID       163 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnTik" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnTik" ) ) ] ;
         ID       160 ;
         IDTEXT   161 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnTik" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnTik" ) ) ]:oHelpText, dbfDoc ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnTik" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnTik" ) ) ]:oHelpText, "TK" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 162, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnTik" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopTik" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopTik" ) ) ] ;
         ID       164 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato para comandas
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnCom" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnCom" ) ) ] ;
         ID       240 ;
         IDTEXT   241 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnCom" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnCom" ) ) ]:oHelpText, dbfDoc ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnCom" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnCom" ) ) ]:oHelpText, "TK" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 242, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnCom" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopCom" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopCom" ) ) ] ;
         ID       244 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato para anulacion
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnAnu" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnAnu" ) ) ] ;
         ID       290 ;
         IDTEXT   291 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnAnu" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnAnu" ) ) ]:oHelpText, dbfDoc ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnAnu" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnAnu" ) ) ]:oHelpText, "TK" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 292, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnAnu" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopAnu" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopAnu" ) ) ] ;
         ID       294 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de vales
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnVal" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnVal" ) ) ] ;
         ID       173 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnVal" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnVal" ) ) ] ;
         ID       170 ;
         IDTEXT   171 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnVal" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnVal" ) ) ]:oHelpText, dbfDoc ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnVal" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnVal" ) ) ]:oHelpText, "TK" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 172, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnVal" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopVal" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopVal" ) ) ] ;
         ID       174 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de devoluciones
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnDev" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnDev" ) ) ] ;
         ID       183 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnDev" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnDev" ) ) ] ;
         ID       180 ;
         IDTEXT   181 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnDev" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnDev" ) ) ]:oHelpText, dbfDoc ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnDev" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnDev" ) ) ]:oHelpText, "TK" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 182, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnDev" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopDev" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopDev" ) ) ] ;
         ID       184 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de apartados
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnApt" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnApt" ) ) ] ;
         ID       273 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnApt" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnApt" ) ) ] ;
         ID       270 ;
         IDTEXT   271 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnApt" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnApt" ) ) ]:oHelpText, dbfDoc ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnApt" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnApt" ) ) ]:oHelpText, "TK" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 272, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnApt" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopApt" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopApt" ) ) ] ;
         ID       274 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de entregas
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnEnt" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnEnt" ) ) ] ;
         ID       193 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnEnt" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnEnt" ) ) ] ;
         ID       190 ;
         IDTEXT   191 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnEnt" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnEnt" ) ) ]:oHelpText, dbfDoc ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnEnt" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnEnt" ) ) ]:oHelpText, "TK" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 192, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnEnt" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopEnt" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopEnt" ) ) ] ;
         ID       194 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de albaranes
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnAlb" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnAlb" ) ) ] ;
         ID       203 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         ON CHANGE( aGet[ ( dbfCajT )->( FieldPos( "nCopAlb" ) ) ]:Refresh() );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnAlb" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnAlb" ) ) ] ;
         ID       200 ;
         IDTEXT   201 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnAlb" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnAlb" ) ) ]:oHelpText, dbfDoc ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnAlb" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnAlb" ) ) ]:oHelpText ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 202, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnAlb" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopAlb" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopAlb" ) ) ] ;
         ID       204 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE .and. !aTmp[ ( dbfCajT )->( FieldPos( "lPrnAlb" ) ) ] ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de facturas
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnFac" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnFac" ) ) ] ;
         ID       213 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         ON CHANGE( aGet[ ( dbfCajT )->( FieldPos( "nCopFac" ) ) ]:Refresh() );
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnFac" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnFac" ) ) ] ;
         ID       210 ;
         IDTEXT   211 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnFac" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnFac" ) ) ]:oHelpText, dbfDoc ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnFac" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnFac" ) ) ]:oHelpText ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 212, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnFac" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopFac" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopFac" ) ) ] ;
         ID       214 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE .and. !aTmp[ ( dbfCajT )->( FieldPos( "lPrnFac" ) ) ] ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de pagos en táctil
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnPgo" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnPgo" ) ) ] ;
         ID       223 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnPgo" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnPgo" ) ) ] ;
         ID       220 ;
         IDTEXT   221 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnPgo" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnPgo" ) ) ]:oHelpText, dbfDoc ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnPgo" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnPgo" ) ) ]:oHelpText, "MP" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 222, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnPgo" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopPgo" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopPgo" ) ) ] ;
         ID       224 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de arqueo de cajas
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnArq" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnArq" ) ) ] ;
         ID       233 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnArq" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnArq" ) ) ] ;
         ID       230 ;
         IDTEXT   231 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnArq" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnArq" ) ) ]:oHelpText, dbfDoc ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnArq" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnArq" ) ) ]:oHelpText, "AQ" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 232, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnArq" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopArq" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopArq" ) ) ] ;
         ID       234 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de arqueos parciales de cajas
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnPar" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnPar" ) ) ] ;
         ID       253 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnPar" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnPar" ) ) ] ;
         ID       250 ;
         IDTEXT   251 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnPar" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnPar" ) ) ]:oHelpText, dbfDoc ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnPar" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnPar" ) ) ]:oHelpText, "AQ" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 252, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnPar" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopPar" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopPar" ) ) ] ;
         ID       254 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de arqueos parciales de cajas
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnCie" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnCie" ) ) ] ;
         ID       343 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnCie" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnCie" ) ) ] ;
         ID       340 ;
         IDTEXT   341 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnCie" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnCie" ) ) ]:oHelpText, dbfDoc ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnCie" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnCie" ) ) ]:oHelpText, "AQ" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 342, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnCie" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopCie" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopCie" ) ) ] ;
         ID       344 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de arqueos tickets regalo
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnReg" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnReg" ) ) ] ;
         ID       263 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnReg" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnReg" ) ) ] ;
         ID       260 ;
         IDTEXT   261 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnReg" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnReg" ) ) ]:oHelpText, dbfDoc ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnReg" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnReg" ) ) ]:oHelpText, "TK" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 262, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnReg" ) ) ] ) }, oFld:aDialogs[2], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopReg" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopReg" ) ) ] ;
         ID       264 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de arqueos cheques regalo
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnChk" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnChk" ) ) ] ;
         ID       283 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnChk" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnChk" ) ) ] ;
         ID       280 ;
         IDTEXT   281 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnChk" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnChk" ) ) ]:oHelpText, dbfDoc ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnChk" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnChk" ) ) ]:oHelpText, "TK" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 282, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnChk" ) ) ] ) }, oFld:aDialogs[ 2 ], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopChk" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopChk" ) ) ] ;
         ID       284 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Formato de entregas a cuenta
      -------------------------------------------------------------------------
      */

      REDEFINE CHECKBOX aGet[ ( dbfCajT )->( FieldPos( "lPrnEna" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "lPrnEna" ) ) ] ;
         ID       353 ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 2 ]

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cPrnEna" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cPrnEna" ) ) ] ;
         ID       350 ;
         IDTEXT   351 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnEna" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnEna" ) ) ]:oHelpText, dbfDoc ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfCajT )->( FieldPos( "cPrnEna" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cPrnEna" ) ) ]:oHelpText, "EA" ) );
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 352, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfCajT )->( FieldPos( "cPrnEna" ) ) ] ) }, oFld:aDialogs[ 2 ], .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "nCopEna" ) ) ] ;
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "nCopEna" ) ) ] ;
         ID       354 ;
         SPINNER ;
         MIN      0 ;
         MAX      99 ;
         PICTURE  "99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      /*
      Visor
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "CCODVIS" ) ) ];
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "CCODVIS" ) ) ];
         ID       300 ;
         IDTEXT   301 ;
         PICTURE  "@!" ;
         VALID    ( cVisor( aGet[ ( dbfCajT )->( FieldPos( "CCODVIS" ) ) ], dbfVisor, aGet[ ( dbfCajT )->( FieldPos( "CCODVIS" ) ) ]:oHelpText ) );
         ON HELP  ( BrwSelVisor( aGet[ ( dbfCajT )->( FieldPos( "CCODVIS" ) ) ], dbfVisor, aGet[ ( dbfCajT )->( FieldPos( "CCODVIS" ) ) ]:oHelpText ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[2]

      /*
      Cajón portamonedas
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "CCAJON" ) ) ];
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "CCAJON" ) ) ];
         ID       310 ;
         IDTEXT   311 ;
         PICTURE  "@!" ;
         VALID    ( cCajPorta( aGet[ ( dbfCajT )->( FieldPos( "CCAJON" ) ) ], dbfCajPorta, aGet[ ( dbfCajT )->( FieldPos( "CCAJON" ) ) ]:oHelpText ) );
         ON HELP  ( BrwSelCajPorta( aGet[ ( dbfCajT )->( FieldPos( "CCAJON" ) ) ], dbfCajPorta, aGet[ ( dbfCajT )->( FieldPos( "CCAJON" ) ) ]:oHelpText ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[2]

      /*
      Balanza en caja
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cCodBal" ) ) ];
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cCodBal" ) ) ];
         ID       320 ;
         IDTEXT   321 ;
         PICTURE  "@!" ;
         VALID    ( cBalanza( aGet[ ( dbfCajT )->( FieldPos( "cCodBal" ) ) ], dbfImpTik, aGet[ ( dbfCajT )->( FieldPos( "cCodBal" ) ) ]:oHelpText ) );
         ON HELP  ( BrwBalanza( aGet[ ( dbfCajT )->( FieldPos( "cCodBal" ) ) ], aGet[ ( dbfCajT )->( FieldPos( "cCodBal" ) ) ]:oHelpText ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[2]

      /*
      Código de corte
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfCajT )->( FieldPos( "cCodCut" ) ) ];
         VAR      aTmp[ ( dbfCajT )->( FieldPos( "cCodCut" ) ) ];
         ID       330 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[2]

      TBtnBmp():ReDefine( 331, "Cut_16",,,,,{|| PrintEscCode( aTmp[ ( dbfCajT )->( FieldPos( "cCodCut" ) ) ], aTmp[ ( dbfCajT )->( FieldPos( "cWinTik" ) ) ] ) }, oFld:aDialogs[2], .f., , .f., "Test de código" )

      /*
      Botones de la caja de diálogo
      -------------------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       500 ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( nMode == DUPL_MODE, if( aGet[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ]:lValid(), SavRec( aTmp, aGet, dbfCajT, oBrw, oDlg, nMode ), ), SavRec( aTmp, aGet, dbfCajT, oBrw, oDlg, nMode ) ) )

		REDEFINE BUTTON ;
         ID       550 ;
         OF       oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( nMode == DUPL_MODE, if( aGet[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ]:lValid(), SavRec( aTmp, aGet, dbfCajT, oBrw, oDlg, nMode ), ), SavRec( aTmp, aGet, dbfCajT, oBrw, oDlg, nMode ) ) } )
   end if

   oDlg:bStart    := {|| StartRec( aGet, aTmp ) }

   ACTIVATE DIALOG oDlg CENTER

   KillTrans()

   oBmpGeneral:End()
   oBmpFormatos:End()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function StartRec( aGet, aTmp )

   aGet[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ]:SetFocus()

   aGet[ ( dbfCajT )->( FieldPos( "cCapCaj" ) ) ]:oHelpText:cText( oRetFld(aTmp[ ( dbfCajT )->( FieldPos( "cCapCaj" ) ) ], oCaptura:oDbf ) )
   aGet[ ( dbfCajT )->( FieldPos( "cCodVis" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cCodVis" ) ) ], dbfVisor ) )
   aGet[ ( dbfCajT )->( FieldPos( "cCajon"  ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cCajon"  ) ) ], dbfCajPorta, "cNomCaj", "cCodCaj" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cCodBal" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cCodBal" ) ) ], dbfImpTik ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnTik" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnTik" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnCom" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnCom" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnVal" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnVal" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnDev" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnDev" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnEnt" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnEnt" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnAlb" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnAlb" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnFac" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnFac" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnPgo" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnPgo" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnArq" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnArq" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnPar" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnPar" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnReg" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnReg" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnApt" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnApt" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cPrnEna" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cPrnEna" ) ) ], dbfDoc, "cDescrip" ) )
   aGet[ ( dbfCajT )->( FieldPos( "cCajPrt" ) ) ]:oHelpText:cText( RetFld( aTmp[ ( dbfCajT )->( FieldPos( "cCajPrt" ) ) ], dbfCajT ) )

Return .t.

//--------------------------------------------------------------------------//

Static Function SavRec( aTmp, aGet, dbfCajT, oBrw, oDlg, nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if dbSeekInOrd( aTmp[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ], "CCODCAJ", dbfCajT )
         MsgStop( "Código ya existe " + Rtrim( aTmp[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ] ) )
         return nil
      end if

   end if

   if Empty( aTmp[ ( dbfCajT )->( FieldPos( "cNomCaj" ) ) ] )
      MsgStop( "Nombre de caja no puede estar vacío" )
      aGet[ ( dbfCajT )->( FieldPos( "cNomCaj" ) ) ]:SetFocus()
      Return nil
   end if

   //Eliminamos lo que tiene las lineas----------------------------------------

   while ( dbfCajL )->( dbSeek( aTmp[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ] ) )
      if dbLock( dbfCajL )
         ( dbfCajL )->( dbDelete() )
         ( dbfCajL )->( dbUnLock() )
      end if
   end while

   //Le ponemos el nuevo código en el caso de duplicar-------------------------

   if nMode == DUPL_MODE

      ( dbfTmpLin )->( dbGoTop() )
      while ( dbfTmpLin )->( !eof() )
         ( dbfTmpLin )->cCodCaj   := aTmp[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ]
         ( dbfTmpLin )->( dbSkip() )
      end while

   end if

   // Guardamos los temporales-------------------------------------------------

   ( dbfTmpLin )->( dbGoTop() )
   while ( dbfTmpLin )->( !eof() )
      dbPass( dbfTmpLin, dbfCajL, .t. )
      ( dbfTmpLin )->( dbSkip() )
   end while

   // Asignación a la variable de texto----------------------------------------

   aTmp[ ( dbfCajT )->( FieldPos( "cNumTur" ) ) ]  := Str( nNumTur, 6 )

   // Guardamos el registro definitivo-----------------------------------------

   WinGather( aTmp, aGet, dbfCajT, oBrw, nMode )

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtDet( aTmp, aGet, dbfTmpLin, oBrw, bWhen, bValid, nMode, aTmpCaj )

	local oDlg

   DEFINE DIALOG oDlg RESOURCE "lCajas" TITLE LblTitle( nMode ) + "impresoras de comandas"

      REDEFINE GET aGet[ ( dbfTmpLin )->( FieldPos( "cTipImp" ) ) ] ;
         VAR      aTmp[ ( dbfTmpLin )->( FieldPos( "cTipImp" ) ) ] ;
         ID       100 ;
         VALID    ( cTipoImpresora( aGet[ ( dbfTmpLin )->( FieldPos( "cTipImp" ) ) ] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTipoImpresora( aGet[ ( dbfTmpLin )->( FieldPos( "cTipImp" ) ) ] ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpLin )->( FieldPos( "cNomPrn" ) ) ] ;
         VAR      aTmp[ ( dbfTmpLin )->( FieldPos( "cNomPrn" ) ) ] ;
         ID       110 ;
         OF       oDlg

      TBtnBmp():ReDefine( 111, "Printer_preferences_16",,,,,{|| PrinterPreferences( aGet[ ( dbfTmpLin )->( FieldPos( "cNomPrn" ) ) ] ) }, oDlg, .f., , .f.,  )

      REDEFINE GET aGet[ ( dbfTmpLin )->( FieldPos( "cWavFil" ) ) ] ;
         VAR      aTmp[ ( dbfTmpLin )->( FieldPos( "cWavFil" ) ) ] ;
         ID       120 ;
         BITMAP   "FOLDER" ;
         ON HELP  ( aGet[ ( dbfTmpLin )->( FieldPos( "cWavFil" ) ) ]:cText( cGetFile( 'Doc ( *.* ) | *.*', 'Seleccione el nombre del fichero' ) ) ) ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfTmpLin )->( FieldPos( "cCodCut" ) ) ];
         VAR      aTmp[ ( dbfTmpLin )->( FieldPos( "cCodCut" ) ) ];
         ID       130 ;
         OF       oDlg

      TBtnBmp():ReDefine( 131, "Cut_16",,,,,{|| PrintEscCode( aTmp[ ( dbfTmpLin )->( FieldPos( "cCodCut" ) ) ], aTmp[ ( dbfTmpLin )->( FieldPos( "cNomPrn" ) ) ] ) }, oDlg, .f., , .f., "Test de código" )

      /*
      Formato para comandas
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfTmpLin )->( FieldPos( "cPrnCom" ) ) ] ;
         VAR      aTmp[ ( dbfTmpLin )->( FieldPos( "cPrnCom" ) ) ] ;
         ID       140 ;
         IDTEXT   141 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfTmpLin )->( FieldPos( "cPrnCom" ) ) ], aGet[ ( dbfTmpLin )->( FieldPos( "cPrnCom" ) ) ]:oHelpText, dbfDoc ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfTmpLin )->( FieldPos( "cPrnCom" ) ) ], aGet[ ( dbfTmpLin )->( FieldPos( "cPrnCom" ) ) ]:oHelpText, "TK" ) );
         OF       oDlg

      TBtnBmp():ReDefine( 142, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfTmpLin )->( FieldPos( "cPrnCom" ) ) ] ) }, oDlg, .f., , .f.,  )

      /*
      Formato para anulacion
      -------------------------------------------------------------------------
      */

      REDEFINE GET aGet[ ( dbfTmpLin )->( FieldPos( "cPrnAnu" ) ) ] ;
         VAR      aTmp[ ( dbfTmpLin )->( FieldPos( "cPrnAnu" ) ) ] ;
         ID       150 ;
         IDTEXT   151 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDocumento( aGet[ ( dbfTmpLin )->( FieldPos( "cPrnAnu" ) ) ], aGet[ ( dbfTmpLin )->( FieldPos( "cPrnAnu" ) ) ]:oHelpText, dbfDoc ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDocumento( aGet[ ( dbfTmpLin )->( FieldPos( "cPrnAnu" ) ) ], aGet[ ( dbfTmpLin )->( FieldPos( "cPrnAnu" ) ) ]:oHelpText, "TK" ) );
         OF       oDlg

      TBtnBmp():ReDefine( 152, "Printer_pencil_16",,,,,{|| EdtDocumento( aTmp[ ( dbfTmpLin )->( FieldPos( "cPrnAnu" ) ) ] ) }, oDlg, .f., , .f.,  )

      REDEFINE BUTTON ;
         ID       500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndDetalle( aTmp, aGet, dbfTmpLin, oBrw, oDlg, nMode, aTmpCaj ) )

		REDEFINE BUTTON ;
         ID       550 ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      oDlg:bStart := {|| aGet[ ( dbfTmpLin )->( FieldPos( "cPrnCom" ) ) ]:lValid(), aGet[ ( dbfTmpLin )->( FieldPos( "cPrnAnu" ) ) ]:lValid() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndDetalle( aTmp, aGet, dbfTmpLin, oBrw, oDlg, nMode, aTmpCaj )

   //Comprobaciones antes de guardar-------------------------------------------

   if Empty( aTmp[ ( dbfTmpLin )->( FieldPos( "cTipImp" ) ) ] )
      msginfo( "El tipo de impresora no puede estar vacío" )
      aGet[ ( dbfTmpLin )->( FieldPos( "cTipImp" ) ) ]:SetFocus()
      return .f.
   end if

   if Empty( aTmp[ ( dbfTmpLin )->( FieldPos( "cNomPrn" ) ) ] )
      msginfo( "El nombre de la impresora no puede estar vacío" )
      aGet[ ( dbfTmpLin )->( FieldPos( "cNomPrn" ) ) ]:SetFocus()
      return .f.
   end if

   if nMode == APPD_MODE

      if dbSeekInOrd( Upper( Padr( aTmp[ ( dbfTmpLin )->( FieldPos( "cTipImp" ) ) ], 50 ) ), "cTipImp", dbfTmpLin )
         msginfo( "El tipo de impresora ya ha sido introducido" )
         aGet[ ( dbfTmpLin )->( FieldPos( "cTipImp" ) ) ]:SetFocus()
         return .f.
      end if

   end if

   /*
   Rellenamos el campo con el código de la caja
   */

   aTmp[ ( dbfTmpLin )->( FieldPos( "cCodCaj" ) ) ]   := aTmpCaj[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ]

   /*
   Guardamos el registro-------------------------------------------------------
   */

   WinGather( aTmp, aGet, dbfTmpLin, oBrw, nMode )

   /*
   Cerramos el diálogo---------------------------------------------------------
   */

   oDlg:end( IDOK )

return( .t. )

//---------------------------------------------------------------------------//

FUNCTION cCajas( oGet, dbfCajT, oGet2 )

   local oBlock
   local oError
   local lClose   := .f.
   local lValid   := .f.
	local xValor 	:= oGet:varGet()

   if Empty( xValor )
      if !Empty( oGet2 )
			oGet2:cText( "" )
      end if
      return .t.
   else
      xValor      := RJustObj( oGet, "0" )
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfCajT )
      USE ( cPatDat() + "CAJAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "CAJAS.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if ( dbfCajT )->( dbSeek( xValor ) )

      oGet:cText( ( dbfCajT )->cCodCaj )

      if !Empty( oGet2 )
         oGet2:cText( ( dbfCajT )->cNomCaj )
      end if

      lValid      := .t.

   else

      msgStop( "Código de caja no encontrada" )

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	IF lClose
		CLOSE( dbfCajT )
	END IF

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION BrwCajas( oGet, oGet2, lBigStyle )

	local oDlg
	local oGet1
	local cGet1
	local oBrw
   local nOrd        := GetBrwOpt( "BrwCajas" )
	local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local cCbxOrd
   local nLevel      := nLevelUsr( "01040" )

   DEFAULT lBigStyle := .f.

   if !lOpenFiles()
      return .f.
   end if

   if lBigStyle
      nOrd           := ( dbfCajT )->( OrdSetFocus( "cNomCaj" ) )
      ( dbfCajT )->( dbGoTop() )
   else
      nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
      cCbxOrd        := aCbxOrd[ nOrd ]
   end if

   if lBigStyle
      DEFINE DIALOG oDlg RESOURCE "HELPENTRYTACTIL"   TITLE "Seleccionar cajas ordenado por: nombre"
   else
      DEFINE DIALOG oDlg RESOURCE "HELPENTRY"         TITLE "Seleccionar cajas"
   end if

   if lBigStyle

      REDEFINE BUTTONBMP ;
         ID       100 ;
         OF       oDlg ;
         BITMAP   "LUPA_32";
         ACTION   ( BuscarBrwTactil( dbfCajT, oBrw ) )

      REDEFINE BUTTON ;
         ID       110 ;
         OF       oDlg ;
         ACTION   ( ( dbfCajT )->( OrdSetFocus( "cCodCaj" ) ), oBrw:Refresh(), oDlg:cTitle( "Seleccionar cajas ordenado por: código" ) )

      REDEFINE BUTTON ;
         ID       120 ;
         OF       oDlg ;
         ACTION   ( ( dbfCajT )->( OrdSetFocus( "cNomCaj" ) ), oBrw:Refresh(), oDlg:cTitle( "Seleccionar cajas ordenado por: nombre" ) )

   else

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
			ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfCajT ) );
         VALID    ( OrdClearScope( oBrw, dbfCajT ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfCajT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

   end if

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfCajT

      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Cajas"

      if lBigStyle
         oBrw:nRowHeight   := 36
      end if

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCaj"
         :bEditValue       := {|| ( dbfCajT )->cCodCaj }
         :nWidth           := 80
         if !lBigStyle
            :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end if
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCaj"
         :bEditValue       := {|| ( dbfCajT )->cNomCaj }
         :nWidth           := 200
         if !lBigStyle
            :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end if
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      if lBigStyle

      oBrw:nHeaderHeight   := 30
      oBrw:nRowHeight      := 40

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

      end if

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if !lBigStyle

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinAppRec( oBrw, bEdit, dbfCajT ) );

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport() ) ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfCajT ) )

      if nAnd( nLevel, ACC_APPD ) != 0 .and. !IsReport()
         oDlg:AddFastKey( VK_F2,    {|| WinAppRec( oBrw, bEdit, dbfCajT ) } )
      end if

      if nAnd( nLevel, ACC_EDIT ) != 0 .and. !IsReport()
         oDlg:AddFastKey( VK_F3,    {|| WinEdtRec( oBrw, bEdit, dbfCajT ) } )
      end if

      end if

      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfCajT )->cCodCaj )
		oGet:lValid()

      if ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfCajT )->cNomCaj )
      end if

   end if

	oGet:setFocus()

   DestroyFastFilter( dbfCajT )

   SetBrwOpt( "BrwCajas", ( dbfCajT )->( OrdNumber() ) )

   CloseFiles()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function BrwCajaTactil( oGet, dbfCaja, oGet2, lReturnCaja, lParaLlevar )

   local oDlg
   local oBrw
   local nRec
   local nOrdAnt
   local cCajas            := ""
   local lClose            := .f.
   local oGetUnidades
   local cGetUnidades      := Space( 100 )
   local oBmpGeneral
   local oSayGeneral
   local oBotonOculto
   local oBotonAnadir
   local oBotonEditar
   local cResource         := "HelpEntryTactilCli"

   DEFAULT lReturnCaja     := .f.
   DEFAULT lParaLlevar     := .f.

   if Empty( dbfCaja )

      if !OpenFiles( .t. )
         Return nil
      end if

      dbfCaja              := dbfCajT
      lClose               := .t.

   end if

   nRec                    := ( dbfCaja )->( Recno() )
   nOrdAnt                 := ( dbfCaja )->( OrdSetFocus( "cCodCaj" ) )

   ( dbfCaja )->( dbGoTop() )

   if GetSysMetrics( 1 ) == 560

      DEFINE DIALOG oDlg RESOURCE "HelpEntryTactilCli_1024x576" TITLE "Seleccionar cliente ordenado por: Teléfono"

   else

      DEFINE DIALOG oDlg RESOURCE cResource TITLE "Seleccionar cliente ordenado por: Teléfono"

   end if

      REDEFINE BUTTONBMP ;
         ID       100 ;
         OF       oDlg ;
         BITMAP   "Keyboard2_32";
         ACTION   ( VirtualKey( .f., oGetUnidades ), if( lBigSeek( nil, cGetUnidades, dbfCaja ), oBrw:Refresh(), ) )

      REDEFINE BUTTON oBotonOculto ;
         ID       110 ;
         OF       oDlg ;

      REDEFINE BUTTON ;
         ID       120 ;
         OF       oDlg ;
         ACTION   ( ( dbfCaja )->( OrdSetFocus( "cCodCaj" ) ), oBrw:Refresh(), oDlg:cTitle( "Seleccionar caja ordenada por: código" ) )

      REDEFINE BUTTON ;
         ID       130 ;
         OF       oDlg ;
         ACTION   ( ( dbfCaja )->( OrdSetFocus( "cNomCaj" ) ), oBrw:Refresh(), oDlg:cTitle( "Seleccionar caja ordenada por: nombre" ) )

      REDEFINE SAY oSayGeneral ;
         PROMPT   if ( lParaLlevar, "Selecione un cliente para llevar", "Selecione una caja" );
         ID       200 ;
         OF       oDlg

      REDEFINE BITMAP oBmpGeneral ;
        ID       500 ;
        RESOURCE   if ( lParaLlevar, "wheel_48_alpha", "cashier_48_alpha" ) ;
        TRANSPARENT ;
        OF       oDlg

      REDEFINE GET oGetUnidades VAR cGetUnidades;
         ID       600 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfCaja ) );
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfCaja
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse caja tactil"
      oBrw:nRowHeight      := 60
      oBrw:nDataLines      := 2
      oBrw:lHScroll        := .f.

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| AllTrim( ( dbfCaja )->cCodCaj ) }
         :nWidth           := 200
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| AllTrim( ( dbfCaja )->cNomCaj ) }
         :nWidth           := 500
      end with

      REDEFINE BUTTONBMP oBotonAnadir ;
         ID       160 ;
         OF       oDlg ;
         BITMAP   "User1_Add_32" ;

      REDEFINE BUTTONBMP oBotonEditar ;
         ID       170 ;
         OF       oDlg ;
         BITMAP   "User1_Edit_32" ;

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

      oDlg:bStart := {|| oBrw:Load(), oBotonOculto:Hide(), oBotonAnadir:Hide(), oBotonEditar:Hide() }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      cCajas      := ( dbfCaja )->cCodCaj

      if !Empty( oGet )
         oGet:cText( cCajas )
      end if

      if !Empty( oGet2 )
         oGet2:cText( Rtrim( ( dbfCaja )->cNomCaj ) )
      end if

   end if

   if lClose

      CloseFiles()

   else

      ( dbfCaja )->( OrdSetFocus( nOrdAnt ) )
      ( dbfCaja )->( dbGoTo( nRec ) )

   end if

Return if( !lReturnCaja, oDlg:nResult == IDOK, cCajas )

//---------------------------------------------------------------------------//

FUNCTION BrwCaj( oGet, dbfCajT, oGet2 )

	local oDlg
	local oGet1
	local cGet1
	local oBrw
   local nOrd        := GetBrwOpt( "BrwCajas" )
	local oCbxOrd
   local aCbxOrd     := { "Código", "Nombre" }
   local cCbxOrd
   local nRec

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   nRec              := ( dbfCajT )->( RecNo() )

   ( dbfCajT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar cajas"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
			ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfCajT ) );
         VALID    ( OrdClearScope( oBrw, dbfCajT ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfCajT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfCajT

      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Cajas reducido"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCaj"
         :bEditValue       := {|| ( dbfCajT )->cCodCaj }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCaj"
         :bEditValue       := {|| ( dbfCajT )->cNomCaj }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil );

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil )

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   IF oDlg:nResult == IDOK

		oGet:cText( (dbfCajT)->CCODCAJ )
		oGet:lValid()

		IF ValType( oGet2 ) == "O"
			oGet2:cText( (dbfCajT)->CNOMCAJ )
		END IF

	END IF

	oGet:setFocus()

   DestroyFastFilter( dbfCajT )

   SetBrwOpt( "BrwCajas", ( dbfCajT )->( OrdNumber() ) )

   ( dbfCajT )->( dbGoTo( nRec ) )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp )

   local nOrd
   local lErrors  := .f.
   local cDbfLin  := "CCAJASL"
   local cCodCaj
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   cCodCaj        := aTmp[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ]
   nNumTur        := Max( Val( aTmp[ ( dbfCajT )->( FieldPos( "cNumTur" ) ) ] ), 1 )

   /*
   Actualizacion de riesgo-----------------------------------------------------
   */

   cTmpLin        := cGetNewFileName( cPatTmp() + cDbfLin )

	/*
   Primero crear la base de datos local----------------------------------------
	*/

   dbCreate( cTmpLin, aSqlStruct( aItmCajaL() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpLin, cCheckArea( cDbfLin, @dbfTmpLin ), .f. )

   if !NetErr()

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

      ( dbfTmpLin )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpLin )->( OrdCreate( cTmpLin, "cTipImp", "Upper( cTipImp )", {|| Upper( Field->cTipImp ) } ) )

      if ( dbfCajL )->( dbSeek( cCodCaj ) )
         while ( dbfCajL )->cCodCaj == cCodCaj .and. !( dbfCajL )->( eof() )
            dbPass( dbfCajL, dbfTmpLin, .t. )
            ( dbfCajL )->( DbSkip() )
         end while
      endif

      ( dbfTmpLin )->( dbGoTop() )

   else

      lErrors     := .t.

   end if


   RECOVER USING oError

      msgStop( "Imposible crear tablas temporales." + CRLF + ErrorMessage( oError ) )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lErrors )

//-----------------------------------------------------------------------//

Static Function KillTrans()

	/*
   Borramos los ficheros-------------------------------------------------------
	*/

   if !Empty( dbfTmpLin ) .and. ( dbfTmpLin )->( Used() )
      ( dbfTmpLin )->( dbCloseArea() )
   end if

   dbfTmpLin      := nil

   dbfErase( cTmpLin )

RETURN NIL

//---------------------------------------------------------------------------//

Static Function ValidCajaPadre( aGet, aTmp )

   local lValid   := .t.

   if empty( aTmp[ ( dbfCajT )->( FieldPos( "cCajPrt" ) ) ] )
      Return ( lValid )
   end if 

   hGetStatus( dbfCajT )

   if ( dbfCajT )->( dbSeekInOrd( aTmp[ ( dbfCajT )->( FieldPos( "cCajPrt" ) ) ], "cCodCaj", dbfCajT ) )  

      aGet[ ( dbfCajT )->( FieldPos( "cCajPrt" ) ) ]:oHelpText:cText( ( dbfCajT )->cNomCaj )

      if aTmp[ ( dbfCajT )->( FieldPos( "cCajPrt" ) ) ] == aTmp[ ( dbfCajT )->( FieldPos( "cCodCaj" ) ) ]
      
         msgStop( "Código de caja padre no puede ser la misma." )

         lValid   := .f.

      end if

   else 
      
      msgStop( "Código de caja no existe." )
      
      lValid      := .f.

   end if 

   hSetStatus()

Return ( lValid )

//---------------------------------------------------------------------------//

FUNCTION mkCajas( cPath, oMeter )

   DEFAULT cPath     := cPatDat()

   if !lExistTable( cPath + "Cajas.Dbf" )
      dbCreate( cPath + "Cajas.Dbf", aSqlStruct( aItmCaja() ), cDriver() )
   end if

   if !lExistTable( cPath + "CajasL.Dbf" )
      dbCreate( cPath + "CajasL.Dbf", aSqlStruct( aItmCajaL() ), cDriver() )
   end if

   rxCajas( cPath, oMeter )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxCajas( cPath, oMeter )

	local dbfCajT

   DEFAULT cPath  := cPatDat()

   if !lExistTable( cPath + "CAJAS.DBF" )
      dbCreate( cPath + "CAJAS.DBF", aSqlStruct( aItmCaja() ), cDriver() )
   end if

   if !lExistTable( cPath + "CAJASL.DBF" )
      dbCreate( cPath + "CAJASL.DBF", aSqlStruct( aItmCajaL() ), cDriver() )
   end if

   dbUseArea( .t., cDriver(), cPath + "CAJAS.DBF", cCheckArea( "CAJAS", @dbfCajT ), .f. )

   if !( dbfCajT )->( neterr() )

      ( dbfCajT )->( __dbPack() )

      ( dbfCajT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCajT )->( ordCreate( cPath + "CAJAS.CDX", "cCodCaj", "Upper( cCodCaj )", {|| Upper( Field->cCodCaj ) }, ) )

      ( dbfCajT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCajT )->( ordCreate( cPath + "CAJAS.CDX", "cNomCaj", "Upper( cNomCaj )", {|| Upper( Field->cNomCaj ) } ) )

      ( dbfCajT )->( ordCondSet("!Deleted() .and. !Field->lNoArq", {|| !Deleted() .and. !Field->lNoArq }  ) )
      ( dbfCajT )->( ordCreate( cPath + "CAJAS.CDX", "lNoArq", "Upper( cCodCaj )", {|| Upper( Field->cCodCaj ) }, ) )

      ( dbfCajT )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCajT )->( ordCreate( cPath + "CAJAS.CDX", "cCajPrt", "Upper( cCajPrt )", {|| Upper( Field->cCajPrt ) }, ) )

      ( dbfCajT )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de cajas" + 1 )

   end if

   dbUseArea( .t., cDriver(), cPath + "CAJASL.DBF", cCheckArea( "CAJASL", @dbfCajL ), .f. )

   if !( dbfCajL )->( neterr() )

      ( dbfCajL )->( __dbPack() )

      ( dbfCajL )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfCajL )->( ordCreate( cPath + "CAJASL.CDX", "CCODCAJ", "Upper( CCODCAJ ) + Upper( cTipImp )", {|| Upper( Field->CCODCAJ ) + Upper( Field->cTipImp ) }, ) )

      ( dbfCajL )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de cajas" + 1 )

   end if

RETURN NIL

//--------------------------------------------------------------------------//

Function IsCaja()

   local oBlock
   local oError
   local dbfCaja

   if !lExistTable( cPatDat() + "Cajas.Dbf" ) .or.;
      !lExistTable( cPatDat() + "CajasL.Dbf" )
      mkCajas()
   end if

   if !lExistIndex( cPatDat() + "Cajas.Cdx" ) .or.;
      !lExistIndex( cPatDat() + "CajasL.Cdx" )
      rxCajas()
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCaja ) )
   // SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE

   ( dbfCaja )->( __dbLocate( { || ( dbfCaja )->cCodCaj == "000" } ) )
   if!( dbfCaja )->( Found() )
      ( dbfCaja )->( dbAppend() )
      ( dbfCaja )->cCodCaj := "000"
      ( dbfCaja )->cNomCaj := "Caja principal"
      ( dbfCaja )->cCapCaj := "000"
      ( dbfCaja )->cPrnTik := "TKA"
      ( dbfCaja )->cPrnAlb := "TKB"
      ( dbfCaja )->cPrnFac := "TKC"
      ( dbfCaja )->cPrnVal := "TKD"
      ( dbfCaja )->cPrnDev := "TKE"
      ( dbfCaja )->cPrnArq := "ARA"
      ( dbfCaja )->nCopTik := 1
      ( dbfCaja )->nCopVal := 1
      ( dbfCaja )->nCopDev := 1
      ( dbfCaja )->nCopEnt := 1
      ( dbfCaja )->nCopAlb := 1
      ( dbfCaja )->nCopFac := 1
      ( dbfCaja )->nCopPgo := 1
      ( dbfCaja )->nCopArq := 1
      ( dbfCaja )->nCopReg := 1
      ( dbfCaja )->nCopPar := 1
      ( dbfCaja )->nCopCom := 1
      ( dbfCaja )->cNumTur := str( 1, 6 )
      ( dbfCaja )->( dbUnLock() )
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfCaja )

Return ( .t. )

//--------------------------------------------------------------------------//
/*
Trata de liberar una caja
*/

FUNCTION lFreeCaja( cCajUsr, cCodUsr )

   local lFree       := .f.
   local nHandle

   DEFAULT cCajUsr   := oUser():cCaja()
   DEFAULT cCodUsr   := cCurUsr()

   if !file( FullCurDir() + cCajUsr + cCodUsr + ".Caj" )
      if ( nHandle := fCreate( FullCurDir() + cCajUsr + cCodUsr + ".Caj", 0 ) ) != -1
         fClose( nHandle )
      end if
   end if

   if ( nHandle   := fOpen( FullCurDir() + cCajUsr + cCodUsr + ".Caj", 16 ) ) != -1
      fClose( nHandle )
      lFree       := .t.
   end if

RETURN ( lFree )

//---------------------------------------------------------------------------//
/*
Cuantos usuarios hay en una caja
*/

FUNCTION nUserCaja( cCajUsr )

   local n
   local nHandle
   local aDirCaj
   local nUsrCaj     := 0

   DEFAULT cCajUsr   := oUser():cCaja()

   aDirCaj           := Directory( FullCurDir() + cCajUsr + "*.Caj" )

   for n := 1 to len( aDirCaj )

      if ( nHandle := fOpen( aDirCaj[ n, 1 ], 16 ) ) != -1
         fClose( nHandle )
      else
         nUsrCaj++
      end if

   next

RETURN ( nUsrCaj )

//---------------------------------------------------------------------------//
/*
Selecciona una caja
*/

Function lSetCaja( cCajUsr, cCodUsr, oWndBrw )

   local nHndCaj
   local cFilCaj

   DEFAULT cCajUsr   := oUser():cCaja()
   DEFAULT cCodUsr   := oUser():cCodigo()

   cFilCaj           := cCajUsr + cCodUsr

   // Creo un fichero y lo pongo en uso asi se siempre cuando el usuario esta en la aplicacion

   if !file( FullCurDir() + cFilCaj + ".Caj" )
      if ( nHndCaj   := fCreate( FullCurDir() + cFilCaj + ".Caj", 0 ) ) != -1
         fClose( nHndCaj )
      end if
   end if

   nHndCaj           := fOpen( FullCurDir() + cFilCaj + ".Caj", 16 )

   if nHndCaj != -1
      nHndCaj( nHndCaj )
      oUser():cCaja( cCajUsr )
   end if

   if !Empty( oWndBrw )
      oWndBrw:End( .t. )
      oWndBrw        := nil
   end if

   ChkTurno()

Return ( .t. )

//---------------------------------------------------------------------------//
/*
Quita la caja
*/

Function lQuitCaja()

   local lQuit := .t.

   if nHndCaj() != nil
      lQuit    := fClose( nHndCaj() )
   end if

Return ( lQuit )

//---------------------------------------------------------------------------//
/*
Cambia el usuario actual por el q nos pasen
*/

FUNCTION lChgCaja( cCajUsr, cCodUsr, oWndBrw )

   if lQuitCaja()
      lSetCaja( cCajUsr, cCodUsr, oWndBrw )
   end if

RETURN nil

//---------------------------------------------------------------------------//

Function aItmCaja()

   local aBase := {}

   aAdd( aBase, { "cCodCaj",   "C",  3,   0, "Código de la caja" } )
   aAdd( aBase, { "cNomCaj",   "C", 30,   0, "Nombre de la caja" } )
   aAdd( aBase, { "cAlmCaj",   "C",  3,   0, "Almacén de la caja" } )
   aAdd( aBase, { "cLocCaj",   "C", 50,   0, "" } )
   aAdd( aBase, { "nUsrCaj",   "N",  3,   0, "" } )
   aAdd( aBase, { "lPrnTik",   "L",  1,   0, "Lógico impresora normal tickets" } )
   aAdd( aBase, { "cPrnTik",   "C",  3,   0, "Formato tickets" } )
   aAdd( aBase, { "lPrnAlb",   "L",  1,   0, "Lógico impresora normal albaranes" } )
   aAdd( aBase, { "cPrnAlb",   "C",  3,   0, "Formato albaranes" } )
   aAdd( aBase, { "lPrnFac",   "L",  1,   0, "Lógico impresora normal facturas" } )
   aAdd( aBase, { "cPrnFac",   "C",  3,   0, "Formatos facturas" } )
   aAdd( aBase, { "cCapCaj",   "C",  3,   0, "Código captura" } )
   aAdd( aBase, { "lPrnVal",   "L",  1,   0, "Lógico impresora normal vales" } )
   aAdd( aBase, { "cPrnVal",   "C",  3,   0, "Formato vales" } )
   aAdd( aBase, { "lPrnDev",   "L",  1,   0, "Lógico impresora normal devoluciones" } )
   aAdd( aBase, { "cPrnDev",   "C",  3,   0, "Formato devoluciones" } )
   aAdd( aBase, { "nPrnTik",   "N",  1,   0, "Tipo impresora" } )
   aAdd( aBase, { "cPrnWin",   "C",  250, 0, "Impresora de windows" } )
   aAdd( aBase, { "cCodPrn",   "C",  3,   0, "Código impresora de tickets" } )
   aAdd( aBase, { "cCodVis",   "C",  3,   0, "Código visor" } )
   aAdd( aBase, { "cCajon",    "C",  3,   0, "Código cajón portamonedas" } )
   aAdd( aBase, { "lPrnArq",   "L",  1,   0, "Lógico impresora normal arqueos" } )
   aAdd( aBase, { "nPrnArq",   "N",  1,   0, "Tipo impresora arqueos" } )
   aAdd( aBase, { "cWinArq",   "C",  250, 0, "Impresora de arqueos" } )
   aAdd( aBase, { "cPrnArq",   "C",  3,   0, "Formato arqueos" } )
   aAdd( aBase, { "cPrnPgo",   "C",  3,   0, "Formato metapagos" } )
   aAdd( aBase, { "lPrnEnt",   "L",  1,   0, "Lógico impresora normal entrega" } )
   aAdd( aBase, { "cPrnEnt",   "C",  3,   0, "formato de entrega" } )
   aAdd( aBase, { "cWinTik",   "C",  250, 0, "Impresora de tickets" } )
   aAdd( aBase, { "lPrnPgo",   "L",  1,   0, "Lógico impresora normal metapagos" } )
   aAdd( aBase, { "nCopTik",   "N",  2,   0, "Copias tickets" } )
   aAdd( aBase, { "nCopVal",   "N",  2,   0, "Copias vales" } )
   aAdd( aBase, { "nCopDev",   "N",  2,   0, "Copias devoluciones" } )
   aAdd( aBase, { "nCopEnt",   "N",  2,   0, "Copias entregas" } )
   aAdd( aBase, { "nCopAlb",   "N",  2,   0, "Copias albaranes" } )
   aAdd( aBase, { "nCopFac",   "N",  2,   0, "Copias facturas" } )
   aAdd( aBase, { "nCopPgo",   "N",  2,   0, "Copias metapagos" } )
   aAdd( aBase, { "nCopArq",   "N",  2,   0, "Copias arqueos" } )
   aAdd( aBase, { "cCodBal",   "C",  3,   0, "Código de la balanza" } )
   aAdd( aBase, { "cCodCut",   "C",  120, 0, "Código de corte de papel" } )
   aAdd( aBase, { "cPrnCom",   "C",  3,   0, "Formato comandas" } )
   aAdd( aBase, { "nCopCom",   "N",  2,   0, "Copias comandas" } )
   aAdd( aBase, { "cWinCom1",  "C",  250, 0, "Primera impresora de comandas" } )
   aAdd( aBase, { "cWinCom2",  "C",  250, 0, "Segunda impresora de comandas" } )
   aAdd( aBase, { "cWinCom3",  "C",  250, 0, "Tercera impresora de comandas" } )
   aAdd( aBase, { "lPrnPar",   "L",  1,   0, "Lógico impresora normal arqueo parcial" } )
   aAdd( aBase, { "cPrnPar",   "C",  3,   0, "Formato arqueo parcial" } )
   aAdd( aBase, { "nCopPar",   "N",  2,   0, "Copias arqueo parcial" } )
   aAdd( aBase, { "lPrnReg",   "L",  1,   0, "Lógico impresora normal ticket regalo" } )
   aAdd( aBase, { "cPrnReg",   "C",  3,   0, "Formato ticket regalo" } )
   aAdd( aBase, { "nCopReg",   "N",  2,   0, "Copias ticket regalo" } )
   aAdd( aBase, { "lPrnApt",   "L",  1,   0, "Lógico impresora normal apartados" } )
   aAdd( aBase, { "cPrnApt",   "C",  3,   0, "Formato apartados" } )
   aAdd( aBase, { "nCopApt",   "N",  2,   0, "Copias apartados" } )
   aAdd( aBase, { "lPrnChk",   "L",  1,   0, "Lógico impresora normal cheques regalo" } )
   aAdd( aBase, { "cPrnChk",   "C",  3,   0, "Formato cheques regalo" } )
   aAdd( aBase, { "nCopChk",   "N",  2,   0, "Copias cheques regalo" } )
   aAdd( aBase, { "cPrnAnu",   "C",  3,   0, "Formato anulaciones" } )
   aAdd( aBase, { "nCopAnu",   "N",  2,   0, "Copias anulaciones" } )
   aAdd( aBase, { "lPrnEna",   "L",  1,   0, "Lógico impresora normal entregas a cuenta de albaranes" } )
   aAdd( aBase, { "cPrnEna",   "C",  3,   0, "Formato entregas a cuenta de albaranes" } )
   aAdd( aBase, { "nCopEna",   "N",  2,   0, "Copias entregas a cuenta de albaranes" } )
   aAdd( aBase, { "lNoArq",    "L",  1,   0, "Lógico para no incluir en arqueo" } )
   aAdd( aBase, { "lPrnCie",   "L",  1,   0, "Lógico impresora normal arqueos ciegos" } )
   aAdd( aBase, { "cPrnCie",   "C",  3,   0, "Formato para arqueos ciegos" } )
   aAdd( aBase, { "nCopCie",   "N",  2,   0, "Copias para arqueos ciegos" } )
   aAdd( aBase, { "cPrnNota",  "C",  250, 0, "Impresora de entregas de notas" } )
   aAdd( aBase, { "cNumTur",   "C",  6,   0, "Número del turno" } )
   aAdd( aBase, { "cCajPrt",   "C",  3,   0, "Caja padre" } )

Return ( aBase )

//---------------------------------------------------------------------------//

Function aItmCajaL()

   local aBase := {}

   aAdd( aBase, { "cCodCaj",   "C",     3,   0, "Código de la caja" } )
   aAdd( aBase, { "cTipImp",   "C",    50,   0, "Tipo de impresora" } )
   aAdd( aBase, { "cNomPrn",   "C",   250,   0, "Nombre de la impresora" } )
   aAdd( aBase, { "cWavFil",   "C",   250,   0, "Fichero a reproducir" } )
   aAdd( aBase, { "cCodCut",   "C",   120,   0, "Código de corte de papel" } )
   aAdd( aBase, { "cPrnCom",   "C",     3,   0, "Formato comandas" } )
   aAdd( aBase, { "cPrnAnu",   "C",     3,   0, "Formato anulaciones" } )

Return ( aBase )

//---------------------------------------------------------------------------//

Function RecursiveSeekEnCaja( cCodCaj, dbfCajT, cField, uValue )

   DEFAULT cField    := "cPrnTik"

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      uValue         := ( dbfCajT )->( fieldGet( fieldPos( cField ) ) )

      if empty( uValue ) .and. !empty( ( dbfCajT )->cCajPrt )

         if dbSeekInOrd( ( dbfCajT )->cCajPrt, "cCodCaj", dbfCajT )
            
            uValue   := ( dbfCajT )->( fieldGet( fieldPos( cField ) ) )

         end if

      end if

   end if

Return ( uValue )

//---------------------------------------------------------------------------//

Function cFormatoTicketEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnTik", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoPagoEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnPgo", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoEntregaEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnEnt", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoAlbaranEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnAlb", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoFacturaEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnFac", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoValeEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnVal", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoDevolucionEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnDev", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoArqueoEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnArq", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoArqueoParcialEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnPar", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoArqueoCiegoEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnCie", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoTicketRegaloEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnReg", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoChequeRegaloEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnChk", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoEntregasCuentaEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnEna", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function cFormatoComandaEnCaja( cCodCaj, cTipImp, dbfCajT, dbfCajL )

   local cFmt     := Space( 3 )

   cTipImp        := Padr( Upper( cTipImp ), 50 )

   if dbSeekInOrd( cCodCaj + cTipImp, "cCodCaj", dbfCajL )
      cFmt        := ( dbfCajL )->cPrnCom
   end if

   if empty( cFmt )
      Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnCom", Space( 3 ) ) )
   end if

Return ( cFmt )

//---------------------------------------------------------------------------//

Function cFormatoAnulacionEnCaja( cCodCaj, cTipImp, dbfCajT, dbfCajL )

   local cFmt     := Space( 3 )

   cTipImp        := Padr( Upper( cTipImp ), 50 )

   if dbSeekInOrd( cCodCaj + cTipImp, "cCodCaj", dbfCajL )
      cFmt        := ( dbfCajL )->cPrnAnu
   end if

   if empty( cFmt )
      Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnAnu", Space( 3 ) ) )
   end if

Return ( cFmt )

//---------------------------------------------------------------------------//

Function cFormatoApartadosEnCaja( cCodCaj, dbfCajT )

Return ( RecursiveSeekEnCaja( cCodCaj, dbfCajT, "cPrnApt", Space( 3 ) ) )

//---------------------------------------------------------------------------//

Function lImpTicketsEnImpresora( cCodCaj, dbfCajT )

   local lImp  := .f.

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      lImp     := ( dbfCajT )->lPrnTik
   end if

Return ( lImp )

//---------------------------------------------------------------------------//

Function lImpValesEnImpresora( cCodCaj, dbfCajT )

   local lImp  := .f.

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      lImp     := ( dbfCajT )->lPrnVal
   end if

Return ( lImp )

//---------------------------------------------------------------------------//

Function lImpDevolucionesEnImpresora( cCodCaj, dbfCajT )

   local lImp  := .f.

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      lImp     := ( dbfCajT )->lPrnDev
   end if

Return ( lImp )

//---------------------------------------------------------------------------//

Function lImpEntregasEnImpresora( cCodCaj, dbfCajT )

   local lImp  := .f.

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      lImp     := ( dbfCajT )->lPrnEnt
   end if

Return ( lImp )

//---------------------------------------------------------------------------//

Function lImpAlbaranesEnImpresora( cCodCaj, dbfCajT )

   local lImp  := .f.

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      lImp     := ( dbfCajT )->lPrnAlb
   end if

Return ( lImp )

//---------------------------------------------------------------------------//

Function lImpFacturasEnImpresora( cCodCaj, dbfCajT )

   local lImp  := .f.

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      lImp     := ( dbfCajT )->lPrnFac
   end if

Return ( lImp )

//---------------------------------------------------------------------------//

Function cCapturaCaja( cCodCaj, dbfCajT )

   local cCap  := "000"

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT ) .and. !Empty( ( dbfCajT )->cCapCaj )
      cCap     := ( dbfCajT )->cCapCaj
   end if

Return ( cCap )

//---------------------------------------------------------------------------//

Function cBalanzaEnCaja( cCodCaj, dbfCajT )

   local cFmt  := Space( 3 )

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      cFmt     := ( dbfCajT )->cCodBal
   end if

Return ( cFmt )

//---------------------------------------------------------------------------//
/*
Devuelve el código de la impresora de tickets que usa esta caja
*/

Function cImpresoraTicketEnCaja( cCodCaj, dbfCajT )

   local oBlock
   local oError
   local lClo  := .f.
   local cFmt  := Space( 3 )

   if !lExistTable( cPatDat() + "Cajas.Dbf" ) .or. !lExistIndex( cPatDat() + "Cajas.Cdx" )
      msgInfo( "No existen ficheros de cajas." )
      Return ( cFmt )
   end if

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfCajT )
      USE ( cPatDat() + "Cajas.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajT ) )
      SET ADSINDEX TO ( cPatDat() + "Cajas.Cdx" ) ADDITIVE
      lClo     := .t.
   end if

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      cFmt     := ( dbfCajT )->cCodPrn
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClo
      CLOSE ( dbfCajT )
   end if

Return ( cFmt )

//---------------------------------------------------------------------------//

Function cVisorEnCaja( cCodCaj, dbfCajT )

   local cFmt  := Space( 3 )

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      cFmt     := ( dbfCajT )->cCodVis
   end if

Return ( cFmt )

//---------------------------------------------------------------------------//

Function cCodigoCorteEnCaja( cCodCaj, dbfCajT )

   local cCodigo  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT ) .and. !Empty( ( dbfCajT )->cCodCut )
      cCodigo     := ( dbfCajT )->cCodCut
   end if

Return ( cCodigo )

//---------------------------------------------------------------------------//

Function cCortePapelEnCaja( cCodCaj, dbfCajT, dbfCajL, lComanda, cTipImpCom, lAnulacion )

   DEFAULT lComanda       := .f.
   DEFAULT lAnulacion     := .f.
   DEFAULT cTipImpCom     := ""

   if !lComanda .and. !lAnulacion

      if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )               .and.;
         !Empty( ( dbfCajT )->cCodCut )                           .and.;
         !Empty( ( dbfCajT )->cWinTik )

         PrintEscCode( ( dbfCajT )->cCodCut, ( dbfCajT )->cWinTik )

      end if

   else

      if dbSeekInOrd( cCodCaj + cTipImpCom, "cCodCaj", dbfCajL )  .and.;
         !Empty( ( dbfCajL )->cCodCut )                           .and.;
         !Empty( ( dbfCajL )->cNomPrn )

         PrintEscCode( ( dbfCajL )->cCodCut, ( dbfCajL )->cNomPrn )

      end if

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Function SelCajTactil( oWnd, lInicio )

   local oBlock
   local oError
   local oDlg
   local dbfCaj
   local oImgCaj
   local oLstCaj
   local cPath          := cPatDat()

   DEFAULT lInicio      := .f.

   /*
   Si el usuario ya tiene elegida una caja y estamos al inicio de la app pasamos
   */

   if lInicio .and. !Empty( oUser():cCaja() )
      Return ( nil )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPath + "CAJAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCaj ) )
      SET ADSINDEX TO ( cPath + "CAJAS.CDX" ) ADDITIVE

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )
      Return nil

   END SEQUENCE

   ErrorBlock( oBlock )

   if ( dbfCaj )->( LastRec() ) <= 0
      ( dbfCaj )->( dbCloseArea() )
      Return nil
   end if

   DEFINE DIALOG oDlg ;
      RESOURCE    "SelUsuarios" ;
      TITLE       "Seleccione caja"

      oImgCaj     := TImageList():New( 48, 48 )

      oLstCaj     := TListView():Redefine( 100, oDlg, {| nOpt | SelBrwBigCaj( nOpt, oLstCaj, oDlg, dbfCaj ) }, 1 )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end(), if( lInicio, oWnd:End(), ) )

   ACTIVATE DIALOG oDlg;
      ON INIT     ( InitBrwBigCaj( oDlg, oImgCaj, oLstCaj, dbfCaj ) ) ;
      CENTER

   ( dbfCaj )->( dbCloseArea() )

RETURN ( nil )

//---------------------------------------------------------------------------//
//
// Inicializa el tree
//

Static Function InitBrwBigCaj( oDlg, oImgCaj, oLstCaj, dbfCaj )

   ( dbfCaj )->( dbGoTop() )
   while !( dbfCaj )->( eof() )

      oImgCaj:Add( TBitmap():Define( "CASHIER_48", , oDlg ) )

      oLstCaj:InsertItem( ( dbfCaj )->( OrdKeyNo() ) - 1, Capitalize( ( dbfCaj )->cNomCaj ) )

      ( dbfCaj )->( dbSkip() )

   end while

   oLstCaj:SetImageList( oImgCaj )

RETURN ( nil )

//---------------------------------------------------------------------------//
// Función que chequea la caja y nos deja pasar

Static Function SelBrwBigCaj( nOpt, oLstCaj, oDlg, dbfCaj )

   // Chequeamos que seleccione almenos una caja-------------------------------

   if nOpt == 0
      MsgStop( "Seleccione caja" )
      Return nil
   end if

   if ( dbfCaj )->( OrdKeyGoTo( nOpt ) )
      //Cambia la caja del usuario
      lChgCaja( ( dbfCaj )->cCodCaj, oUser():cCodigo() )
      oDlg:end( IDOK )
   else
      MsgStop( "La caja no existe" )
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Function lWindowsPrinterEnCaja( cCodCaj, dbfCajT )

   local lWin  := .f.

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      lWin     := ( ( dbfCajT )->nPrnTik == 2 )
   end if

Return ( lWin )

//---------------------------------------------------------------------------//

Function cWindowsPrinterEnCaja( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      cPrn     := Rtrim( ( dbfCajT )->cPrnWin )
   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterTiket( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnTik
         cPrn     := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn     := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//
/*
Devolvemos la impresora de comanda---------------------------------------------
*/

Function cPrinterComanda( cCodCaj, dbfCajT, nNumImp )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

         do case
            case nNumImp == 1
               cPrn     := Rtrim( ( dbfCajT )->cWinCom1 )

            case nNumImp == 2
               cPrn     := Rtrim( ( dbfCajT )->cWinCom2 )

            case nNumImp == 3
               cPrn     := Rtrim( ( dbfCajT )->cWinCom3 )

         end case

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterVale( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnVal
         cPrn     := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn     := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterDevolucion( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnDev
         cPrn     := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn     := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterEntrega( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnEnt

         cPrn     := Rtrim( ( dbfCajT )->cPrnWin )

      else
         
         if !Empty( ( dbfCajT )->cPrnNota )
            cPrn  := Rtrim( ( dbfCajT )->cPrnNota )
         else
            cPrn  := Rtrim( ( dbfCajT )->cWinTik )
         end if

      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterApartados( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnApt
         cPrn     := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn     := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterRegalo( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnReg
         cPrn  := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn  := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterChequeRegalo( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnChk
         cPrn  := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn  := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterAlbaran( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnAlb
         cPrn     := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn     := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterFactura( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnFac
         cPrn     := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn     := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterMetaPago( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnPgo
         cPrn     := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn     := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterEntregasCuenta( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnEna
         cPrn     := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn     := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterArqueo( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnArq
         cPrn     := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn     := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterArqueoParcial( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnPar
         cPrn     := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn     := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cPrinterArqueoCiego( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )

      if ( dbfCajT )->lPrnCie
         cPrn     := Rtrim( ( dbfCajT )->cPrnWin )
      else
         cPrn     := Rtrim( ( dbfCajT )->cWinTik )
      endif

   end if

Return ( cPrn )

//---------------------------------------------------------------------------//


Function lImpArqueoEnImpresora( cCodCaj, dbfCajT )

   local lImp  := .f.

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      lImp     := ( dbfCajT )->lPrnArq
   end if

Return ( lImp )

//---------------------------------------------------------------------------//

Function cCajonEnCaja( cCodCaj, dbfCajT )

   local nRec     
   local cCaj     := "000"

   nRec           := ( dbfCajT )->( Recno() )

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      cCaj        := ( dbfCajT )->cCajon
   end if

   ( dbfCajT )->( dbGoTo( nRec ) )

Return ( cCaj )

//---------------------------------------------------------------------------//

Function lWindowsPrinterEnArqueo( cCodCaj, dbfCajT )

   local lWin  := .f.

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      lWin     := ( ( dbfCajT )->nPrnArq == 2 )
   end if

Return ( lWin )

//---------------------------------------------------------------------------//

Function cWindowsPrinterEnArqueo( cCodCaj, dbfCajT )

   local cPrn  := ""

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      cPrn     := Rtrim( ( dbfCajT )->cWinArq )
   end if

Return ( cPrn )

//---------------------------------------------------------------------------//

Function cImpresoraTicketEnArqueo( cCodCaj, dbfCajT )

   local cFmt  := Space( 3 )

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      cFmt     := ( dbfCajT )->cPrnArq
   end if

Return ( cFmt )

//---------------------------------------------------------------------------//

Function nCopiasTicketsEnCaja( cCodCaj, dbfCajT )

   local nCop  := 1

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      nCop        := ( dbfCajT )->nCopTik
   end if

Return ( nCop )

//---------------------------------------------------------------------------//

Function nCopiasValesEnCaja( cCodCaj, dbfCajT )

   local nCop  := 1

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      nCop        := ( dbfCajT )->nCopVal
   end if

Return ( NotCero( nCop ) )

//---------------------------------------------------------------------------//

Function nCopiasDevolucionesEnCaja( cCodCaj, dbfCajT )

   local nCop  := 1

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      nCop        := ( dbfCajT )->nCopDev
   end if

Return ( NotCero( nCop ) )

//---------------------------------------------------------------------------//

Function nCopiasEntregasEnCaja( cCodCaj, dbfCajT )

   local nCop  := 1

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      nCop        := ( dbfCajT )->nCopEnt
   end if

Return ( NotCero( nCop ) )

//---------------------------------------------------------------------------//

Function nCopiasTicketsRegaloEnCaja( cCodCaj, dbfCajT )

   local nCop  := 1

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      nCop        := ( dbfCajT )->nCopReg
   end if

Return ( NotCero( nCop ) )

//---------------------------------------------------------------------------//

Function nCopiasAlbaranesEnCaja( cCodCaj, dbfCajT )

   local nCop  := 1

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      nCop        := ( dbfCajT )->nCopAlb
   end if

Return ( NotCero( nCop ) )

//---------------------------------------------------------------------------//

Function nCopiasFacturasEnCaja( cCodCaj, dbfCajT )

   local nCop  := 1

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      nCop        := ( dbfCajT )->nCopFac
   end if

Return ( NotCero( nCop ) )

//---------------------------------------------------------------------------//

Function nCopiasMetaPagosEnCaja( cCodCaj, dbfCajT )

   local nCop  := 1

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      nCop        := ( dbfCajT )->nCopPgo
   end if

Return ( NotCero( nCop ) )

//---------------------------------------------------------------------------//

Function nCopiasArqueosEnCaja( cCodCaj, dbfCajT )

   local nCop  := 1

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      nCop        := ( dbfCajT )->nCopArq
   end if

Return ( NotCero( nCop ) )

//---------------------------------------------------------------------------//

Function nCopiasComandasEnCaja( cCodCaj, dbfCajT )

   local nCop  := 1

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      nCop        := ( dbfCajT )->nCopCom
   end if

Return ( NotCero( nCop ) )

//---------------------------------------------------------------------------//

Function nCopiasAnulacionEnCaja( cCodCaj, dbfCajT )

   local nCop  := 1

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      nCop        := ( dbfCajT )->nCopAnu
   end if

Return ( NotCero( nCop ) )

//---------------------------------------------------------------------------//

Function nCopiasEntregasCuentaEnCaja( cCodCaj, dbfCajT )

   local nCop  := 1

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCajT )
      nCop        := ( dbfCajT )->nCopEna
   end if

Return ( NotCero( nCop ) )

//---------------------------------------------------------------------------//

Function SelectCajas()

   local oDlg
   local oBrw
   local oBmp
   local oGetBuscar
   local cGetBuscar     := Space( 100 )
   local oCbxOrden
   local cCbxOrden      := "Código"

   if !lOpenFiles()
      return .f.
   end if

   DEFINE DIALOG oDlg ;
      RESOURCE    "SelectItem" ;
      TITLE       "Seleccionar caja"

      REDEFINE BITMAP oBmp ;
         RESOURCE "Cashier_48_alpha" ;
         ID       300;
         OF       oDlg

      REDEFINE GET oGetBuscar ;
         VAR      cGetBuscar;
         ID       100 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfCajT, nil, nil, .f. ) ); //, msgStop( ( dbfCajT )->( OrdSetFocus() ) ) );
         BITMAP   "Find" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrden ;
         VAR      cCbxOrden ;
         ID       110 ;
         ITEMS    { "Código", "Nombre" } ;
         ON CHANGE( ( dbfCajT )->( OrdSetFocus( oCbxOrden:nAt ) ), oBrw:Refresh(), oGetBuscar:SetFocus() ) ;
			OF 		oDlg

      oBrw                 := TXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfCajT

      oBrw:nMarqueeStyle   := 5

      oBrw:CreateFromResource( 200 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodCaj"
         :bEditValue       := {|| ( dbfCajT )->cCodCaj }
         :nWidth           := 40
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomCaj"
         :bEditValue       := {|| ( dbfCajT )->cNomCaj }
         :nWidth           := 200
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oUser():cCaja( ( dbfCajT )->cCodCaj )

      if !Empty( cCajonEnCaja( ( dbfCajT )->cCodCaj, dbfCajT ) )
         oUser():oCajon    := TCajon():Create( cCajonEnCaja( ( dbfCajT )->cCodCaj, dbfCajT ) )
      end if

      ChkTurno()

      SetKey( VK_F12, {|| oUser():OpenCajonTest() } )

   else

      MsgInfo( "No selecciono ninguna caja, se establecerá la caja por defecto." + CRLF + ;
               "Caja actual, " + oUser():cCaja() )
   end if

   CloseFiles()

   if !Empty( oBmp )
      oBmp:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function SelectCajon()

   if !lOpenFiles()
      Return .f.
   end if

   if !Empty( cCajonEnCaja( oUser():cCaja(), dbfCajT ) )
      oUser():oCajon      := TCajon():Create( cCajonEnCaja( oUser():cCaja(), dbfCajT ) )
   end if

   SetKey( VK_F12, {|| oUser():OpenCajonTest() } )

   CloseFiles()

RETURN ( .t. )

#endif

//---------------------------------------------------------------------------//

Function cNombreImpresoraComanda( cCodCaj, cTipImp, dbfCajL )

   local cNombre  := ""

   cTipImp        := Padr( Upper( cTipImp ), 50 )

   if dbSeekInOrd( cCodCaj + cTipImp, "cCodCaj", dbfCajL )
      cNombre     := ( dbfCajL )->cNomPrn
   end if

Return ( cNombre )

//---------------------------------------------------------------------------//

Function cWavImpresoraComanda( cCodCaj, cTipImp, dbfCajL )

   local cWav     := ""

   cTipImp        := Padr( Upper( cTipImp ), 50 )

   if dbSeekInOrd( cCodCaj + cTipImp, "CCODCAJ", dbfCajL )
      cWav        := ( dbfCajL )->cWavFil
   end if

Return ( cWav )

//---------------------------------------------------------------------------//

FUNCTION TstCajas( cPatDat )

   local n
   local dbfDiv

   local oError
   local oBlock

   if !lExistTable( cPatDat() + "Cajas.Dbf" )
      dbCreate( cPatDat() + "Cajas.Dbf", aSqlStruct( aItmDiv() ), cDriver() )
   end if

   if !lExistIndex( cPatDat() + "Cajas.Cdx" )
      rxDiv( cPatDat() )
   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Cuantos campos tiene--------------------------------------------------------
   */

   dbUseArea( .t., cDriver(), cPatDat() + "Cajas.Dbf", cCheckArea( "Cajas", @dbfDiv ), .f. )

   if !( dbfDiv )->( netErr() )

      n           := ( dbfDiv )->( fCount() )

      ( dbfDiv )->( dbCloseArea() )

      if n != len( aItmCaja() )

         dbCreate( cPatEmpTmp() + "Cajas.Dbf", aSqlStruct( aItmCaja() ), cDriver() )
         appDbf( cPatDat(), cPatEmpTmp(), "Cajas", aItmCaja() )

         fEraseTable( cPatDat() + "Cajas.Dbf" )
         fRenameTable( cPatEmpTmp() + "Cajas.Dbf", cPatDat() + "Cajas.Dbf" )

         rxCajas( cPatDat() )

      end if

   end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( .t. )

//---------------------------------------------------------------------------//

Function nCajasArqueo( oCajas )

   local nCajas   := 0

   oCajas:GetStatus()
   oCajas:OrdSetFocus( "lNoArq" )

   nCajas         := oCajas:OrdKeyCount()

   oCajas:SetStatus()

Return ( nCajas )

//---------------------------------------------------------------------------//

Function EdtCajas( cCodigoCaja, lOpenBrowse )

   local nLevel         := nLevelUsr( "01040" )

   DEFAULT cCodigoCaja  := oUser():cCaja()
   DEFAULT lOpenBrowse  := .f.

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if lOpenBrowse

      if Cajas()
         if dbSeekInOrd( cCodigoCaja, "cCodCaj", dbfCajT )
            oWndBrw:RecEdit()
         else
            MsgStop( "No se encuentra caja" )
         end if
      end if

   else

      if lOpenFiles( nil, .t. )

         if dbSeekInOrd( cCodigoCaja, "cCodCaj", dbfCajT )
            WinEdtRec( nil, bEdit, dbfCajT )
         end if

         CloseFiles()

      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

Function cNumeroSesionCaja( cCodCaj, dbfCaja, dbfTurno )

   local cNumeroSesion  := space( 6 )

   if dbSeekInOrd( cCodCaj, "cCodCaj", dbfCaja )

      while .t.

         cNumeroSesion  := ( dbfCaja )->cNumTur

         if dbSeekInOrd( cNumeroSesion + RetSufEmp() + cCodCaj, "cNumTur", dbfTurno )

            if dbLock( dbfCaja )
               ( dbfCaja )->cNumTur := str( val( ( dbfCaja )->cNumTur ) + 1, 6 )
               ( dbfCaja )->( dbUnLock() )
            end if

         else 

            Return ( cNumeroSesion ) 

         end if 
      
      end while

   else 

      msgStop( "Código de caja " + cCodCaj + " no encontrada." )

   end if

Return ( cNumeroSesion )

//---------------------------------------------------------------------------//

Function SetNumeroSesionCaja( cNumeroSesion, cCodigoCaja, dbfCaja )

   if dbSeekInOrd( cCodigoCaja, "cCodCaj", dbfCaja )

      if dbLock( dbfCaja )
         ( dbfCaja )->cNumTur := cNumeroSesion
         ( dbfCaja )->( dbUnLock() )
      end if

   end if

Return ( cNumeroSesion )

//---------------------------------------------------------------------------//



