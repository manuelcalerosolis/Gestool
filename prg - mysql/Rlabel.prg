#include "FiveWin.Ch"
#include "Folder.ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 
#include "Label.ch"

#define FW_NORMAL                400
#define FW_BOLD                  700

#define _MENUITEM_               "01069"

/*
Bases de datos de las Etiquetas
*/

#define lCTIPLBL                  1      //   C      2     0
#define lCCODLBL                  2      //   C      3     0
#define lCNOMLBL                  3      //   N     50     0
#define lCTBLLBL                  4      //   N     25     0
#define lNWIDLBL                  5      //   N      6     2
#define lNHEGLBL                  6      //   N      6     2
#define lNHORSEPLBL               7      //   N      6     2
#define lNVERSEPLBL               8      //   N      6     2
#define lNONLLBL                  9      //   N      6     2
#define lNMARTOPLBL              10      //   N      6     2
#define lNMARBOTLBL              11      //   N      6     2
#define lNMARLFTLBL              12      //   N      6     2
#define lNMARRGTLBL              13      //   N      6     2
#define lNLENPAG                 14      //   N      6     2
#define lNWIDPAG                 15      //   N      6     2

/*
Bases de datos de los Items
*/

#define iCCODLBL                  1      //  C    3, 0
#define iCCAMLBL                  2      //  C  256, 0
#define iCDBFLBL                  3      //  C   20, 0
#define iCMASLBL                  4      //  C   20, 0
#define iNAJULBL                  5      //  N    1, 0
#define iCCONLBL                  6      //  C  256, 0
#define iLBANNER                  7      //  L    1, 0
#define iLHORZ                    8      //  L    1, 0
#define iNWIDLBL                  9      //  N   16, 6
#define iCFNTLBL                 10      //  C  100, 0
#define iNSIZLBL                 11      //  N    2, 0
#define iLITALBL                 12      //  L    1, 0
#define iLUNDLBL                 13      //  L    1, 0
#define iNCOLLBL                 14      //  N    2, 0
#define iCTITULO                 15      //  C   20, 0

static aBase1	:= {  {"CTIPLBL",		"C",	2, 0, "" },;
							{"CCODLBL", 	"C",	3, 0, "" },;
							{"CNOMLBL",		"C", 50, 0, "" },;
							{"CTBLLBL",		"C", 25, 0, "" },;
							{"NWIDLBL",    "N",  6, 2, "" },;
							{"NHEGLBL",    "N",  6, 2, "" },;
							{"NHORSEPLBL", "N",  6, 2, "" },;
							{"NVERSEPLBL", "N",  6, 2, "" },;
							{"NONLLBL",    "N",  6, 2, "" },;
							{"NMARTOPLBL", "N",  6, 2, "" },;
							{"NMARBOTLBL", "N",  6, 2, "" },;
							{"NMARLFTLBL", "N",  6, 2, "" },;
                     {"NMARRGTLBL", "N",  6, 2, "" },;
                     {"NLENPAG",    "N",  6, 2, "" },;
                     {"NWIDPAG",    "N",  6, 2, "" } }

static aBase2  := {  {"CCODLBL",    "C",  3, 0, "" },;
                     {"CCAMLBL",    "C",250, 0, "" },;
							{"CDBFLBL",    "C", 20, 0, "" },;
                     {"CMASLBL",    "C",250, 0, "" },;
							{"NAJULBL",    "N",  1, 0, "" },;
                     {"CCONLBL",    "C",250, 0, "" },;
							{"LBANNER",    "L",  1, 0, "" },;
							{"LHORZ",      "L",  1, 0, "" },;
                     {"NWIDLBL",    "N", 16, 6, "" },;
                     {"CFNTLBL",    "C",100, 0, "" },;
                     {"NSIZLBL",    "N",  2, 0, "" },;
                     {"LITALBL",    "L",  1, 0, "" },;
                     {"LUNDLBL",    "L",  1, 0, "" },;
                     {"NCOLLBL",    "N", 10, 0, "" },;
                     {"CTITULO",    "C",100, 0, "" } }

static bEdit      := { |aTmp, aoGet, cDbfLblT, oBrw, bWhen, bValid, nMode | EdtLabel( aTmp, aoGet, cDbfLblT, oBrw, bWhen, bValid, nMode ) }
static bEdtDet    := { |aTmp, aoGet, cDbfLblL, oBrw, bWhen, bValid, nMode | EdtDet( aTmp, aoGet, cDbfLblL, oBrw, bWhen, bValid, nMode ) }
static bEdtDet2   := { |aTmp, aoGet, cDbfLblL, oBrw, bWhen, bValid, nMode | EdtDet2( aTmp, aoGet, cDbfLblL, oBrw, bWhen, bValid, nMode ) }
static cDbfLblT
static cDbfLblL
static dbfFldDoc
static dbfColDoc
static dbfTmp
static cNewFile
static oWndBrw

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( cPatEmp )

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT cPatEmp   := cPatEmp()

   BEGIN SEQUENCE

      if !lExistTable( cPatEmp() + "LBLT.DBF" ) .OR. !lExistTable( cPatEmp() + "LBLL.DBF" )
         mkLbl( cPatEmp() )
      end if

      if !lExistIndex( cPatEmp() + "LBLT.CDX" ) .OR. !lExistIndex( cPatEmp() + "LBLL.CDX" )
         rxLbl( cPatEmp() )
      end if

      USE ( cPatEmp() + "LBLT.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "LBLT", @cDbfLblT ) )
      SET ADSINDEX TO ( cPatEmp() + "LBLT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "LBLL.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "LBLL", @cDbfLblL ) )
      SET ADSINDEX TO ( cPatEmp() + "LBLL.CDX" ) ADDITIVE

      USE ( cPatDat() + "WDOCFLD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "WDOCFLD", @dbfFldDoc ) )
      SET ADSINDEX TO ( cPatDat() + "WDOCFLD.CDX" ) ADDITIVE

      USE ( cPatDat() + "WDOCCOL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "WFLDCOL", @dbfColDoc ) )
      SET ADSINDEX TO ( cPatDat() + "WDOCCOL.CDX" ) ADDITIVE

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN lOpen

//----------------------------------------------------------------------------//

FUNCTION RptLabel( oMenuItem, oWnd )

   local nLevel

   if Empty( oWndBrw )

      nLevel   := nLevelUsr( oMenuItem )

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

      if !OpenFiles()
         return nil
      end if

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
         TITLE    "Etiquetas" ;
         FIELDS   (cDbfLblT)->CCODLBL,;
                  (cDbfLblT)->CNOMLBL;
         HEAD     "Código",;
                  "Nombre";
         PROMPT   "Código";
         MRU      "gc_document_text_pencil_16";
         BITMAP   "WebTopGreen" ;
         ALIAS    ( cDbfLblT) ;
         APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, cDbfLblT ) );
         DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, cDbfLblT ) );
         EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, cDbfLblT ) );
         DELETE   ( LblDelRec(  oWndBrw:oBrw, cDbfLblT ) ) ;
         LEVEL    ( nLevel ) ;
         OF       oWnd

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar";
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecAdd() );
			ON DROP	( oWndBrw:RecDup() );
         BEGIN GROUP;
         TOOLTIP  "(A)ñadir";
         HOTKEY   "A";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDup() );
			TOOLTIP 	"(D)uplicar";
         HOTKEY   "D";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
			TOOLTIP 	"(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

		DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit, cDbfLblT ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

		DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "EXPORT" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( ExpDoc( oWndBrw ) );
         TOOLTIP  "E(x)portar";
         HOTKEY   "X" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "IMPORT" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( GetDoc( oWndBrw ) );
         TOOLTIP  "Im(p)ortar";
         HOTKEY   "P" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   else

      oWndBrw:SetFocus()

   end if

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if !Empty( oWndBrw )
      oWndBrw:oBrw:lCloseArea()
   else
      ( cDbfLblT )->( dbCloseArea() )
   end if

   ( cDbfLblL  )->( dbCloseArea() )
   ( dbfFldDoc )->( dbCloseArea() )
   ( dbfColDoc )->( dbCloseArea() )

   cDbfLblT  := nil
   cDbfLblL  := nil
   dbfFldDoc := nil
   dbfColDoc := nil
   oWndBrw   := nil

RETURN .T.

//----------------------------------------------------------------------------//
/*Configura las etiquetas como parametro le pasamos el codigo de las etiquetas*/

STATIC FUNCTION EdtLabel( aTmp, aoGet, dbfLblT, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oFld
   local oGet
	local oTipDoc
   local oBrwLin
   local aAjuste  := { "Izquierda", "Centro", "Derecha" }
   local aTipDoc  := {  "AR - Artículos ",;
								"CL - Clientes",;
                        "PR - Proveedores",;
                        "AP - Albarán de proveedor",;
                        "FP - Factura de proveedor" }

   if nMode == APPD_MODE
      aTmp[ lNHEGLBL ]  := 30
      aTmp[ lNWIDLBL ]  := 70
      aTmp[ lNONLLBL ]  := 3
   end if

   BeginTrans( aTmp )

   DEFINE DIALOG oDlg RESOURCE "LBLCENTER"

      REDEFINE FOLDER oFld ID 100 OF oDlg ;
         PROMPT   "&General",    "Cam&pos";
         DIALOGS  "LBLCENTER_1", "LBLCENTER_2"


      IF nMode == APPD_MODE
         aTmp[ lCTIPLBL ]  := "AR - Artículos"
		ELSE
         aTmp[ lCTIPLBL ]  := aTipDoc[ aScan( aTipDoc, { | cCol | SubStr( cCol, 1, 2 ) == aTmp[ lCTIPLBL ] } ) ]
		END IF

      /*Tipo de etiqueta*/

      REDEFINE COMBOBOX oTipDoc VAR aTmp[ lCTIPLBL ] ;
			ITEMS 	aTipDoc ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         ID       90 ;
         OF       oFld:aDialogs[1]

      /*Código y nombre de la etiqueta*/

      REDEFINE GET oGet VAR aTmp[ lCCODLBL ];
         ID       100 ;
         PICTURE  "@!" ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    ( NotValid( oGet, cDbfLblT, .t., "0" ) );
         OF       oFld:aDialogs[1]

		REDEFINE GET aoGet[ lCNOMLBL ] VAR aTmp[ lCNOMLBL ];
         ID       110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      /*Dimensiones de la etiqueta*/

      REDEFINE GET aoGet[ lNHEGLBL ] VAR aTmp[ lNHEGLBL ];
			ID 		120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			SPINNER ;
			PICTURE 	"@E 999.99" ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aoGet[ lNWIDLBL ] VAR aTmp[ lNWIDLBL ];
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			SPINNER ;
			PICTURE 	"@E 999.99" ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ lNONLLBL ] VAR aTmp[ lNONLLBL ];
			ID 		140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			SPINNER ;
			PICTURE 	"@E 999" ;
         OF       oFld:aDialogs[1]

      /*Dimensiones del papel*/

      REDEFINE GET aoGet[ lNLENPAG ] VAR aTmp[ lNLENPAG ] ;
			SPINNER ;
         ON UP    aoGet[ lNLENPAG ]:cText( aoGet[ lNLENPAG ]:Value + .1 ) ;
         ON DOWN  aoGet[ lNLENPAG ]:cText( aoGet[ lNLENPAG ]:Value - .1 ) ;
         MIN       1 ;
         MAX      28 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			PICTURE	"@E 999.99" ;
         ID       210 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ lNWIDPAG ] VAR aTmp[ lNWIDPAG ] ;
			SPINNER ;
         ON UP    aoGet[ lNWIDPAG ]:cText( aoGet[ lNWIDPAG ]:Value + .1 ) ;
         ON DOWN  aoGet[ lNWIDPAG ]:cText( aoGet[ lNWIDPAG ]:Value - .1 ) ;
         MIN       1 ;
         MAX      30 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			PICTURE	"@E 999.99" ;
         ID       220 ;
         OF       oFld:aDialogs[1]

      /*Márgenes del papel*/

      REDEFINE GET aoGet[ lNMARTOPLBL ] VAR aTmp[ lNMARTOPLBL ];
         ID       150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@E 999.99" ;
			SPINNER ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ lNMARLFTLBL ] VAR aTmp[ lNMARLFTLBL ];
         ID       160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@E 999.99" ;
			SPINNER ;
         OF       oFld:aDialogs[1]

      REDEFINE GET aoGet[ lNMARRGTLBL ] VAR aTmp[ lNMARRGTLBL ];
         ID       170 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@E 999.99" ;
			SPINNER ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aoGet[ lNMARBOTLBL ] VAR aTmp[ lNMARBOTLBL ];
         ID       180 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@E 999.99" ;
			SPINNER ;
         OF       oFld:aDialogs[1]

      /*
      Separación entre etiquetas
      */

      REDEFINE GET aoGet[ lNVERSEPLBL ] VAR aTmp[ lNVERSEPLBL ];
         ID       190 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
			SPINNER ;
         OF       oFld:aDialogs[1]

		REDEFINE GET aoGet[ lNHORSEPLBL ] VAR aTmp[ lNHORSEPLBL ];
         ID       200 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
			SPINNER ;
         OF       oFld:aDialogs[1]

      /*
      Segunda Caja de diálogo
      */

      REDEFINE BUTTON ;
         ID       100 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwLin, bEdtDet2, dbfTmp, aTmp ) )

		REDEFINE BUTTON ;
         ID       110 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwLin, bEdtDet, dbfTmp ) )

      REDEFINE BUTTON ;
         ID       140 ;
         OF       oFld:aDialogs[2] ;
         ACTION   ( WinZooRec( oBrwLin, bEdtDet, dbfTmp ) )

		REDEFINE BUTTON ;
         ID       120 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( dbDelRec( oBrwLin, dbfTmp ) )

      REDEFINE BUTTON ;
         ID       150 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DbSwapUp( dbfTmp, oBrwLin ), oBrwLin:refresh() )


      REDEFINE BUTTON ;
         ID       160 ;
         OF       oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DbSwapDown( dbfTmp, oBrwLin ), oBrwLin:refresh() )

      REDEFINE IBROWSE oBrwLin;
         FIELDS   ( dbfTmp )->cTitulo,;
                  ( dbfTmp )->cCamLbl,;
                  aAjuste[ Max( ( dbfTmp )->nAjuLbl , 1 ) ],;
                  ( dbfTmp )->cMasLbl,;
                  ( dbfTmp )->cFntLbl,;
                  Trans( ( dbfTmp )->nWidLbl, "@E 999" ),;
                  cEstilo( ( dbfTmp )->lItaLbl, ( dbfTmp )->lUndLbl );
         FIELDSIZES ;
                  200,;
                  200,;
                  60,;
                  60,;
                  100,;
                  50,;
                  50;
         HEADER   "Título",;
                  "Expresión",;
                  "Alineación",;
                  "Máscara",;
                  "Fuente",;
                  "Ancho",;
                  "Estilo";
         JUSTIFY  .f., .f., .t., .t., .t., .t., .t. ;
			ALIAS		( dbfTmp ) ;
         ID       130 ;
         OF       oFld:aDialogs[2]

         if nMode != ZOOM_MODE
            oBrwLin:bLDblClick   := {|| WinEdtRec( oBrwLin, bEdtDet, dbfTmp ) }
         end if

         oBrwLin:cWndName        := "Linea de etiqueta detalle"

         oBrwLin:Load()

      /*
      Botones de la caja de diálogo
      */

		REDEFINE BUTTON ;
         ID       500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aoGet, oBrw, nMode, oDlg, oGet ) )

		REDEFINE BUTTON ;
			ID 		510 ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       520 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Etiquetas" ) )

   if nMode != ZOOM_MODE
      oFld:aDialogs[2]:AddFastKey( VK_F2, {|| WinAppRec( oBrwLin, bEdtDet2, dbfTmp, aTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwLin, bEdtDet, dbfTmp ) } )
      oFld:aDialogs[2]:AddFastKey( VK_F4, {|| dbDelRec( oBrwLin, dbfTmp ) } )
      oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aoGet, oBrw, nMode, oDlg, oGet ) } )
   end if

   oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Etiquetas" ) } )

   oDlg:bStart := {|| oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

   KillTrans( oBrwLin )

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

Static function EdtDet( aTmp, aoGet, cDbfLblL, oBrw, bWhen, bValid, nMode )

   local oDlg
   local oFld
   local oBtnNxt
   local oBtnPrv
   local oCbxAjust
   local aResAjust      := { "ALIGN_LEFT", "ALIGN_CENTER", "ALIGN_RIGHT" }
   local aCbxAjust      := { "Izquierda", "Centro", "Derecha" }
   local cCbxAjust      := aCbxAjust[ Max( aTmp[ iNAJULBL ], 1 ) ]
   local aFont          := aGetFont( oWnd() )
   local aSizes         := { " 6", " 7", " 8", " 9", "10", "11", "12", "13", "14", "16", "18", "20", "22", "24", "26", "28", "36", "48", "72" }
   local oEstilo
   local cEstilo        := "Normal"
   local aEstilo        := { "Normal", "Cursiva", "Negrita", "Negrita Cursiva" }
   local cTxtColor
   local oTxtColor
   local nSeaColor
   local aStrColor      := { "Negro", "Rojo oscuro", "Verde oscuro", "Oliva", "Azul marino", "Púrpura", "Verde azulado", "Gris",  "Plateado", "Rojo", "Verde", "Amarillo", "Azul", "Fucsia", "Aguamarina", "Blanco" }
   local aResColor      := { "COL_00", "COL_01", "COL_02", "COL_03", "COL_04", "COL_05", "COL_06", "COL_07", "COL_08", "COL_09", "COL_10", "COL_11", "COL_12", "COL_13", "COL_14", "COL_15" }
   local aRgbColor      := { Rgb( 0, 0, 0 ), Rgb( 128, 0, 0 ), Rgb( 0, 128, 0 ), Rgb( 128, 128, 128 ), Rgb( 0, 0, 128 ), Rgb( 128, 0, 128 ), Rgb( 0, 128, 128 ), Rgb( 128, 128, 128 ), Rgb( 192, 192, 192 ), Rgb( 255, 0, 0 ), Rgb( 0, 255, 0 ), Rgb( 255, 255, 0 ), Rgb( 0, 0, 255 ), Rgb( 255, 0, 255 ), Rgb( 0, 255, 255 ) }

   if Empty( aTmp[ iNSIZLBL ] )
      aTmp[ iNSIZLBL ]  := 10
   end if

   if Empty( aTmp[ iCFNTLBL ] )
      aTmp[ iCFNTLBL ]  := "Arial"
   end if

   cEstilo              := cEstilo( aTmp[ iLITALBL ], aTmp[ iLUNDLBL ] )
   nSeaColor            := aScan( aRgbColor, aTmp[ iNCOLLBL ] )

   if nSeaColor != 0
      cTxtColor         := aStrColor[ nSeaColor ]
   end if

   aTmp[ iNSIZLBL ]     := Str( aTmp[ iNSIZLBL ], 2 )

   DEFINE DIALOG oDlg RESOURCE "WIZLBL" TITLE LblTitle( nMode ) + "línea de etiqueta"

   REDEFINE PAGES oFld ;
      ID       100 ;
      OF       oDlg ;
      DIALOGS  "WIZLBL_2"

   /*Define título, expresión y dbf*/

   REDEFINE GET aoGet[ iCTITULO ] VAR aTmp[ iCTITULO ] ;
      ID       110 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oFld:aDialogs[1]

   REDEFINE GET aoGet[ iCCAMLBL ] VAR aTmp[ iCCAMLBL ] ;
      ID       120 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oFld:aDialogs[1]

   REDEFINE GET aoGet[ iCDBFLBL ] VAR aTmp[ iCDBFLBL ] ;
      ID       125 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oFld:aDialogs[1]

   /*Alineación*/

   REDEFINE COMBOBOX oCbxAjust VAR cCbxAjust ;
      ITEMS    aCbxAjust ;
      BITMAPS  aResAjust ;
      ID       150 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oFld:aDialogs[1]

   /*Ancho*/

   REDEFINE GET aoGet[ iNWIDLBL ] VAR aTmp[ iNWIDLBL ] ;
      SPINNER ;
      PICTURE  "@E 9,999" ;
      ID       160 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oFld:aDialogs[1]

   /*Mascara*/

   REDEFINE GET aoGet[ iCMASLBL ] VAR aTmp[ iCMASLBL ] ;
      ID       190 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oFld:aDialogs[1]

   /*Fuente*/

   REDEFINE COMBOBOX aTmp[ iCFNTLBL ] ;
      ID       200 ;
      ITEMS    aFont ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oFld:aDialogs[1]

   REDEFINE COMBOBOX aTmp[ iNSIZLBL ] ;
      ID       210 ;
      ITEMS    aSizes ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oFld:aDialogs[1]

   REDEFINE COMBOBOX oEstilo VAR cEstilo ;
      ID       220 ;
      ITEMS    aEstilo ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oFld:aDialogs[1]

   REDEFINE COMBOBOX oTxtColor VAR cTxtColor;
      ID       230;
      ITEMS    aStrColor;
      BITMAPS  aResColor;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oFld:aDialogs[1]

   /*Condición*/

   REDEFINE GET aoGet[ iCCONLBL ] VAR aTmp[ iCCONLBL ] ;
      ID       195 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       oFld:aDialogs[1]

   /*Botones de la caja de diálogo*/

   REDEFINE BUTTON oBtnPrv ;
      ID       500 ;
      OF       oDlg ;
      ACTION   ( nil )

   REDEFINE BUTTON oBtnNxt ;
      ID       501 ;
      OF       oDlg ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      ACTION   ( EndDeta( aTmp, aoGet, dbfTmp, oBrw, nMode, oDlg, cEstilo, aRgbColor, oTxtColor, oCbxAjust ) )

   REDEFINE BUTTON ;
      ID       502 ;
      OF       oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| EndDeta( aTmp, aoGet, dbfTmp, oBrw, nMode, oDlg, cEstilo, aRgbColor, oTxtColor, oCbxAjust ) } )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBtnPrv:hide(), SetWindowText( oBtnNxt:hWnd, 'Aceptar [F5]' ) )

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function EndDeta( aTmp, aGet, dbfTmp, oBrw, nMode, oDlg, cEstilo, aRgbColor, oTxtColor, oCbxAjust )

  //Cargamos algunos campos antes de guardar

   aTmp[ iNSIZLBL ] := Val( aTmp[ iNSIZLBL ] )
   aTmp[ iLITALBL ] := "Negrita" $ cEstilo
   aTmp[ iLUNDLBL ] := "Cursiva" $ cEstilo
   aTmp[ iNCOLLBL ] := aRgbColor[ oTxtColor:nAt ]
   aTmp[ iNAJULBL ] := oCbxAjust:nAt

   WinGather( aTmp, aGet, dbfTmp, oBrw, nMode )

   oDlg:end( IDOK )

Return ( .t. )

//---------------------------------------------------------------------------//

Static function EdtDet2( aTmp, aoGet, cDbfLblL, oBrw, aTmpLbl, bValid, nMode )

   local oDlg
   local oFld
   local oBtnPrv
   local oBtnNxt
   local oLbxFld
   local oCbxAjust
   local aCbxAjust      := { "Izquierda", "Centro", "Derecha" }
   local aEstilo        := { "Normal", "Cursiva", "Negrita", "Negrita Cursiva" }
   local aResAjust      := { "ALIGN_LEFT", "ALIGN_CENTER", "ALIGN_RIGHT" }
   local cCbxAjust      := aCbxAjust[ Max( aTmp[ iNAJULBL ], 1 ) ]
   local aFont          := aGetFont( oWnd() )
   local aSizes         := { " 6", " 7", " 8", " 9", "10", "11", "12", "13", "14", "16", "18", "20", "22", "24", "26", "28", "36", "48", "72" }
   local oEstilo
   local cEstilo        := "Normal"
   local cTxtColor
   local oTxtColor
   local nSeaColor
   local aItm
   local oBrwTbl
   local aStrColor      := { "Negro", "Rojo oscuro", "Verde oscuro", "Oliva", "Azul marino", "Púrpura", "Verde azulado", "Gris",  "Plateado", "Rojo", "Verde", "Amarillo", "Azul", "Fucsia", "Aguamarina", "Blanco" }
   local aResColor      := { "COL_00", "COL_01", "COL_02", "COL_03", "COL_04", "COL_05", "COL_06", "COL_07", "COL_08", "COL_09", "COL_10", "COL_11", "COL_12", "COL_13", "COL_14", "COL_15" }
   local aRgbColor      := { Rgb( 0, 0, 0 ), Rgb( 128, 0, 0 ), Rgb( 0, 128, 0 ), Rgb( 128, 128, 128 ), Rgb( 0, 0, 128 ), Rgb( 128, 0, 128 ), Rgb( 0, 128, 128 ), Rgb( 128, 128, 128 ), Rgb( 192, 192, 192 ), Rgb( 255, 0, 0 ), Rgb( 0, 255, 0 ), Rgb( 255, 255, 0 ), Rgb( 0, 0, 255 ), Rgb( 255, 0, 255 ), Rgb( 0, 255, 255 ) }

   do case
      case Left( aTmpLbl[ lCTIPLBL ], 2 ) == "AR"
         aItm           := aEtqArt()
      case Left( aTmpLbl[ lCTIPLBL ], 2 ) == "CL"
         aItm           := aEtqCli()
      case Left( aTmpLbl[ lCTIPLBL ], 2 ) == "PR"
         aItm           := aEtqPrv()
      case Left( aTmpLbl[ lCTIPLBL ], 2 ) == "AP"
         aItm           := aEtqAlbPrv()
      case Left( aTmpLbl[ lCTIPLBL ], 2 ) == "FP"
         aItm           := aEtqFacPrv()
      otherwise
         aItm           := { {"", "" } }
   end case


   aTmp[ iNSIZLBL ]     := 10
   aTmp[ iCFNTLBL ]     := "Arial"
   cEstilo              := cEstilo( aTmp[ iLITALBL ], aTmp[ iLUNDLBL ] )
   nSeaColor            := aScan( aRgbColor, aTmp[ iNCOLLBL ] )

   if nSeaColor != 0
      cTxtColor         := aStrColor[ nSeaColor ]
   end if

   aTmp[ iNSIZLBL ]     := Str( aTmp[ iNSIZLBL ], 2 )

   /*
   Monta las cajas de diálogo
   */

   DEFINE DIALOG oDlg RESOURCE "WIZLBL" TITLE "Añadiendo línea de etiqueta"

      REDEFINE PAGES oFld ;
         ID       100 ;
         OF       oDlg ;
         DIALOGS  "WIZLBL_1", "WIZLBL_2"

      REDEFINE LISTBOX oBrwTbl ;
         FIELDS   aItm[ oBrwTbl:nAt, 1 ] ;
         HEAD     "Tabla";
         SIZES    100;
         ID       110 ;
         OF       oFld:aDialogs[1]

      oBrwTbl:SetArray( aItm )
      oBrwTbl:bChange   := {||   ( dbfFldDoc )->( OrdScope( 0, aItm[ oBrwTbl:nAt, 2 ] ) ),;
                                 ( dbfFldDoc )->( OrdScope( 1, aItm[ oBrwTbl:nAt, 2 ] ) ),;
                                 ( dbfFldDoc )->( dbGoTop() ),;
                                 oLbxFld:Refresh() }

      REDEFINE LISTBOX oLbxFld ;
         FIELDS   ( dbfFldDoc )->cDesDoc;
         SIZES    100;
         HEAD     "Campo";
         ALIAS    ( dbfFldDoc );
         ID       100 ;
         OF       oFld:aDialogs[1]

      oLbxFld:bLDblClick   := {|| NxtBtn( oFld, aoGet, aTmp, oBtnPrv, oBtnNxt, oBrw, oDlg, aTmpLbl, oLbxFld, dbfFldDoc, oTxtColor, aRgbColor, cEstilo, oCbxAjust ) }

      /*
      Segunca caja de diálogo
      */

      REDEFINE GET aoGet[ iCTITULO ] VAR aTmp[ iCTITULO ] ;
         ID       110 ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ iCCAMLBL ] VAR aTmp[ iCCAMLBL ] ;
         ID       120 ;
         OF       oFld:aDialogs[2]

      REDEFINE GET aoGet[ iCDBFLBL ] VAR aTmp[ iCDBFLBL ] ;
         ID       125 ;
         OF       oFld:aDialogs[2]

      /*
      Alineación
      */

      REDEFINE COMBOBOX oCbxAjust VAR cCbxAjust ;
         ITEMS    aCbxAjust ;
         BITMAPS  aResAjust ;
         ID       150 ;
         OF       oFld:aDialogs[2]

      /*
      Ancho
      */

      REDEFINE GET aoGet[ iNWIDLBL ] VAR aTmp[ iNWIDLBL ] ;
			SPINNER ;
         PICTURE  "@E 9,999" ;
         ID       160 ;
         OF       oFld:aDialogs[2]

      /*
      Mascara
      */

      REDEFINE GET aoGet[ iCMASLBL ] VAR aTmp[ iCMASLBL ] ;
         ID       190 ;
         OF       oFld:aDialogs[2]

      /*
      Condición
      */

      REDEFINE GET aoGet[ iCCONLBL ] VAR aTmp[ iCCONLBL ] ;
         ID       195 ;
         OF       oFld:aDialogs[2]

      /*
      Fuente
      */

      REDEFINE COMBOBOX aTmp[ iCFNTLBL ] ;
         ID       200 ;
         ITEMS    aFont ;
         OF       oFld:aDialogs[2]

      REDEFINE COMBOBOX aTmp[ iNSIZLBL ] ;
         ID       210 ;
         ITEMS    aSizes ;
         OF       oFld:aDialogs[2]

      REDEFINE COMBOBOX oEstilo VAR cEstilo ;
         ID       220 ;
         ITEMS    aEstilo ;
         OF       oFld:aDialogs[2]

      REDEFINE COMBOBOX oTxtColor VAR cTxtColor;
         ID       230;
         ITEMS    aStrColor;
         BITMAPS  aResColor;
         OF       oFld:aDialogs[2]

      /*
      Monta los botones comunes de la caja
      */

      REDEFINE BUTTON oBtnPrv ;
         ID       500 ;
			OF 		oDlg ;
         ACTION   ( oFld:GoPrev(), SetWindowText( oBtnNxt:hWnd, 'Siguiente >' ), oBtnPrv:hide() )

      REDEFINE BUTTON oBtnNxt ;
         ID       501 ;
			OF 		oDlg ;
         ACTION   ( NxtBtn( oFld, aoGet, aTmp, oBtnPrv, oBtnNxt, oBrw, oDlg, aTmpLbl, oLbxFld, dbfFldDoc, oTxtColor, aRgbColor, cEstilo, oCbxAjust ) )

      REDEFINE BUTTON ;
         ID       502 ;
			OF 		oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBtnPrv:hide() )

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

static function NxtBtn( oPag, aGet, aTmp, oBtnPrv, oBtnNxt, oBrw, oDlg, aTmpLbl, oLbxFld, dbfFldDoc, oTxtColor, aRgbColor, cEstilo, oCbxAjust )

   do case
   case oPag:nOption == 1

      oBtnPrv:Show()
      SetWindowText( oBtnNxt:hWnd, 'Terminar' )
      oPag:GoNext()

      aGet[ iCTITULO ]:cText( ( dbfFldDoc )->cDesDoc )
      aGet[ iCCAMLBL ]:cText( ( dbfFldDoc )->cFldDoc )
      aGet[ iCDBFLBL ]:cText( ( dbfFldDoc )->cAreDoc )

   case oPag:nOption == 2

      //Cargamos algunos campos antes de guardar

      aTmp[ iCCODLBL ] := aTmpLbl[ lCCODLBL ]
      aTmp[ iNSIZLBL ] := Val( aTmp[ iNSIZLBL ] )
      aTmp[ iLITALBL ] := "Negrita" $ cEstilo
      aTmp[ iLUNDLBL ] := "Cursiva" $ cEstilo
      aTmp[ iNCOLLBL ] := aRgbColor[ oTxtColor:nAt ]
      aTmp[ iNAJULBL ] := oCbxAjust:nAt

      WinGather( aTmp, aGet, dbfTmp, oBrw, APPD_MODE )

      oDlg:end()

   end case

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aBlank )

   local cDbf     := "LblT"
   local lErrors  := .f.
   local cCodLbl  := aBlank[ ( cDbfLblT )->( FieldPos( "cCodLbl" ) ) ]
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   cNewFile       := cGetNewFileName( cPatTmp() + cDbf )

	/*
	Primero Crear la base de datos local
	*/

   dbCreate( cNewFile, aBase2, cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cNewFile, cCheckArea( cDbf, @dbfTmp ), .f. )

   ( dbfTmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
   ( dbfTmp )->( OrdCreate( cNewFile, "Recno", "Str( Recno() )", {|| Str( Recno() ) } ) )

	/*
	A¤adimos desde el fichero de lineas
	*/

   if ( cDbfLblL )->( dbSeek( cCodLbl ) )

      while ( cDbfLblL )->cCodLbl == cCodLbl .and. !( cDbfLblL )->( Eof() )

         dbPass( cDbfLblL, dbfTmp, .t.)

         ( cDbfLblL )->( dbSkip() )

      end while

   end if

	( dbfTmp )->( dbGoTop() )

   RECOVER

      msgStop( "Imposible crear tablas temporales." )
      KillTrans()
      lErrors        := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lErrors )

//-----------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, oBrw, nMode, oDlg, oGet )

   local aTabla
   local oError
   local oBlock
   local cCodLbl  := aTmp[ lCCODLBL ]

   if Empty( cCodLbl )
      MsgStop( "Código de etiqueta no puede estar vacío" )
      oGet:SetFocus()
      Return .f.
   end if

   if Empty( aTmp[ lCNOMLBL ] )
      MsgStop( "Nombre de la etiqueta no puede estar vacío." )
      aGet[ lCNOMLBL ]:SetFocus()
      Return .f.
   end if

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   BeginTransaction()

      /*
      Roll Back-------------------------------------------------------------------
      */

      if ( cDbfLblL )->( dbSeek( cCodLbl ) )

         while ( cDbfLblL )->cCodLbl == cCodLbl .AND. !( cDbfLblL )->( Eof() )

            if dbLock( cDbfLblL )
               ( cDbfLblL )->( DbDelete() )
               ( cDbfLblL )->( DbUnLock() )
            end if

            ( cDbfLblL )->( DbSkip() )

         end while

      end if

      /*
      Ahora escribimos en el fichero definitivo-----------------------------------
      */

      ( dbfTmp )->( dbGoTop() )

      while !( dbfTmp )->( eof() )

         aTabla                                             := dbScatter( dbfTmp )
         aTabla[ ( cDbfLblL )->( FieldPos( "CCODLBL" ) ) ]  := cCodLbl
         ( cDbfLblL )->( dbAppend() )
         dbGather( aTabla, cDbfLblL )
         ( dbfTmp )->( dbSkip() )

      end while

      WinGather( aTmp, aGet, cDbfLblT, oBrw, nMode )

      CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()

      msgStop( "Imposible almacenar documento" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   dbCommitAll()

   oDlg:End( IDOK )

Return .t.

//------------------------------------------------------------------------//

STATIC FUNCTION KillTrans( oBrwLin )

	( dbfTmp )->( dbCloseArea() )

   dbfErase( cNewFile )

   /*
   Guardamos los datos del browse
   */

   oBrwLin:CloseData()

RETURN .T.

//------------------------------------------------------------------------//

FUNCTION mkLbl( cPath, lAppend, cPathOld, oMeter, cVia )

	local cDbf

   DEFAULT lAppend   := .f.
   DEFAULT cVia      := cDriver()

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
		sysrefresh()
	END IF

   dbCreate( cPath + "LBLT.DBF", aBase1, cVia )

   dbCreate( cPath + "LBLL.DBF", aBase2, cVia )

   if lAppend .and. lIsDir( cPathOld )

      dbUseArea( .t., cVia, cPath + "LBLT.DBF", cCheckArea( "LBLT", @cDbf ), .f. )
      ( cDbf )->( __dbApp( cPathOld + "LBLT.DBF" ) )
		( cDbf )->( dbCloseArea() )

      dbUseArea( .t., cVia, cPath + "LBLL.DBF", cCheckArea( "LBLL", @cDbf ), .f. )
      ( cDbf )->( __dbApp( cPathOld + "LBLL.DBF" ) )
		( cDbf )->( dbCloseArea() )

   end if

   rxLbl( cPath, oMeter, cVia )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxLbl( cPath, oMeter, cVia )

	local cDbf

   DEFAULT cPath  := cPatEmp()
   DEFAULT cVia   := cDriver()

   fEraseIndex( cPath + "LBLT.CDX", cVia )
   fEraseIndex( cPath + "LBLL.CDX", cVia )

   if !lExistTable( cPath + "LBLT.DBF", cVia ) .or.;
      !lExistTable( cPath + "LBLL.DBF", cVia )
		mkLbl( cPath )
   end if

   dbUseArea( .t., ( cVia ), cPath + "LBLT.DBF", cCheckArea( "LBLT", @cDbf ), .f. )
   if !( cDbf )->( neterr() )
      ( cDbf )->( __dbPack() )

      ( cDbf )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cDbf )->( ordCreate( cPath + "LBLT.CDX", "CCODLBL", "Field->cCodLbl", {|| Field->cCodLbl } ) )

      ( cDbf )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( cDbf )->( ordCreate( cPath + "LBLT.CDX", "CTIPLBL", "Field->cTipLbl", {|| Field->cTipLbl } ) )

      ( cDbf )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de etiquetas" )
   end if

   dbUseArea( .t., ( cVia ), cPath + "LBLL.DBF", cCheckArea( "LBLL", @cDbf ), .f. )
   if !( cDbf )->( neterr() )
      ( cDbf )->( __dbPack() )

      ( cDbf )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cDbf )->( ordCreate( cPath + "LBLL.CDX", "CCODLBL", "Field->cCodLbl", {|| Field->cCodLbl } ) )

      ( cDbf )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de etiquetas" )
   end if

Return nil

//--------------------------------------------------------------------------//

/*
Esta funci¢n devuelva una tabla con todos los formato de etiquetas definidos
por el usuario
*/

FUNCTION RetLbl( cCodTbl )

	local cDbfLblT
	local aFormato		:= {}

   USE ( cPatEmp() + "LBLT.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "LBLT", @cDbfLblT ) )
   SET ADSINDEX TO ( cPatEmp() + "LBLT.CDX" ) ADDITIVE

		WHILE ( cDbfLblT )->( !Eof() )

			IF ( cDbfLblT )->CTIPLBL = cCodTbl
				aAdd( aFormato, ( cDbfLblT )->CCODLBL + " - " + ( cDbfLblT )->CNOMLBL )
			END IF

			( cDbfLblT )->( dbSkip() )

		END IF

	CLOSE ( cDbfLblT )

RETURN ( aFormato )

//--------------------------------------------------------------------------//

/*
Genera los objetos label y despues lo visializa
*/

FUNCTION PrnLbl( cCodLabel, nDevice, cAlias, bFor, bWhile, bSkip, cCaption )

   local cFmt
   local oFont
   local cMasc
   local cData       := ""
   local bData
   local oError
   local oBlock
   local oLabel
   local cDbfLblT
	local cDbfLblL

	DEFAULT nDevice	:= 1
	DEFAULT cAlias 	:= Alias()
   DEFAULT bFor      := {|| .t. }
	DEFAULT bWhile		:= {|| !( cAlias )->( Eof() ) }
	DEFAULT bSkip		:= {|| ( cAlias )->( dbSkip() ) }
	DEFAULT cCaption	:= "Generando etiquetas"

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatEmp() + "LBLT.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "LBLT", @cDbfLblT ) )
   SET ADSINDEX TO ( cPatEmp() + "LBLT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "LBLL.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "LBLL", @cDbfLblL ) )
   SET ADSINDEX TO ( cPatEmp() + "LBLL.CDX" ) ADDITIVE

	/*
	Posicionamos en la base de datos
	*/

   if ( cDbfLblT )->( dbSeek( cCodLabel ) )

		/*
		Creamos el objeto label
		*/

      LABEL oLabel ;
         SIZE        ( cDbfLblT )->nWidLbl,     ( cDbfLblT )->nHegLbl ;
         SEPARATORS  ( cDbfLblT )->nHorSepLbl,  ( cDbfLblT )->nVerSepLbl ;
         ON LINE     ( cDbfLblT )->nOnlLbl ;
			PREVIEW ;
			CAPTION 		cCaption

		/*
		Posicionamos en el fichero de las etiquetas
		*/

      if ( cDbfLblL )->( dbSeek( cCodLabel ) )

         while ( cDbfLblL )->cCodLbl = cCodLabel .AND. !( cDbfLblL )->( eof() )

				/*
            Creamos el Font----------------------------------------------------
				*/

            if !Empty( ( cDbfLblL )->cFntLbl )
               oFont    := TFont():New( Rtrim( ( cDbfLblL  )->cFntLbl ), 0, ( cDbfLblL )->nSizLbl,, ( cDbfLblL )->lItaLbl,,,, ( cDbfLblL )->lUndLbl,,,,,,, oLabel:oDevice )
            else
               oFont    := TFont():New( "Arial", 0, -10,,.t.,,,,,,,,,,, oLabel:oDevice )
            end if

            do case
               case ( cDbfLblL )->nAjuLbl == 1
                  cFmt  := "LEFT"
               case ( cDbfLblL )->nAjuLbl == 2
                  cFmt  := "CENTER"
               case ( cDbfLblL )->nAjuLbl == 3
                  cFmt  := "RIGHT"
               otherwise
                  cFmt  := "LEFT"
            end case

				/*
            Seleccionamos el area actual---------------------------------------
            */

            if Empty( Rtrim( ( cDbfLblL )->cDbfLbl ) )
               cData    := ""
            else
               cData    := Rtrim( &( ( cDbfLblL )->cDbfLbl ) ) + "->"
            end if

            /*
            Seleccionamos el campo---------------------------------------------
            */

            cData       += Rtrim( ( cDbfLblL )->cCamLbl )

            bData       := bChar2Block( cData, .f., .t., .t. )

            if !Empty( bData )

               if !Empty( Rtrim( ( cDbfLblL )->cMasLbl ) )
                  cMasc := Eval( bChar2Block( Rtrim( ( cDbfLblL )->cMasLbl ) ) )
               end if

               LblAddOItem( 0, { bData }, ( cDbfLblL )->nWidLbl, { cMasc }, oFont, , cFmt, , , .f., .f., .f., ( cDbfLblL )->nColLbl )

            end if

				( cDbfLblL )->( dbSkip() )

         end do

      end if

      END LABEL

      if ( cDbfLblT )->nWidPag != 0 .and. ( cDbfLblT )->nLenPag != 0
         oLabel:oDevice:SetSize( ( cDbfLblT )->nWidPag * 100, ( cDbfLblT )->nLenPag * 100 )
      end if

		/*
      Si el objeto fue creado pasamos a los margenes de etiquetas
		*/

      if oLabel:lCreated
         oLabel:Margin( ( cDbfLblT )->nMarTopLbl, RPT_TOP,     RPT_MMETERS )
         oLabel:Margin( ( cDbfLblT )->nMarLftLbl, RPT_LEFT,    RPT_MMETERS )
         oLabel:Margin( ( cDbfLblT )->nMarBotLbl, RPT_BOTTOM,  RPT_MMETERS )
         oLabel:Margin( ( cDbfLblT )->nMarRgtLbl, RPT_RIGHT,   RPT_MMETERS )
         oLabel:bSkip   := bSkip
      end if

		oLabel:Activate( bFor, bWhile )

   else

      msgStop( "No existe formato de etiquetas : " + cCodLabel )

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error en el formato de etiquetas" )

   END SEQUENCE
   ErrorBlock( oBlock )

	CLOSE ( cDbfLblT )
	CLOSE ( cDbfLblL )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION retFields( cTipDoc, aField, oLbxFld )

	local cDbfWLblFld
	local cCodTipDoc	:= SubStr( cTipDoc, 1, 2 )

	/*
	Inicializaci¢n
	*/

   aField            := {}

   USE ( cPatDat() + "WDOCFLD.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "WDOCFLD", @cDbfWLblFld ) )

   while ( cDbfWLblFld )->( !eof() )

      if ( cDbfWLblFld )->cTipDoc == cCodTipDoc
         aAdd( aField, { if(  !Empty( ( cDbfWLblFld )->cMasDoc ),;
                              '( Transform(' + Rtrim( ( cDbfWLblFld )->cFldDoc ) + ',' + Rtrim( ( cDbfWLblFld )->cMasDoc ) + ') )',;
                              ( cDbfWLblFld )->cFldDoc ),;
                              ( cDbfWLblFld )->cAreDoc,;
                              ( cDbfWLblFld )->cDesDoc } )
      end if

		( cDbfWLblFld )->( dbSkip() )

   end while

	CLOSE ( cDbfWLblFld )

   if oLbxFld != NIL
		oLbxFld:SetArray( aField )
   end if

RETURN ( aField )

//----------------------------------------------------------------------------//

static function LblDelRec( oBrw, dbfLbl )

   local cCodLbl  := ( dbfLbl )->cCodLbl

   if DbDelRec( oBrw, dbfLbl )
      if ( cDbfLblL )->( dbSeek( cCodLbl ) )
         while ( cDbfLblL )->cCodLbl == cCodLbl .and. !( cDbfLblL )->( eof() )
            if dbLock( cDbfLblL )
               ( cDbfLblL )->( dbDelete() )
               ( cDbfLblL )->( dbUnLock() )
            end if
            ( cDbfLblL )->( dbSkip() )
         end while
      end if
   end if

return .t.

//---------------------------------------------------------------------------//

FUNCTION BrwEtiqueta( oGet, oGet2, cTipo )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
   local nOrd
	local oCbxOrd
   local aCbxOrd
   local cCbxOrd

   if !OpenFiles()
      Return ( .t. )
   end if

   aCbxOrd        := { "Código", "Nombre" }
   nOrd           := GetBrwOpt( "BrwLbl" )
   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   ( cDbfLblT )->( dbSetFilter( {|| ( cDbfLblT )->cTipLbl == cTipo }, "( cDbfLblT )->cTipLbl == cTipo" ) )
   ( cDbfLblT )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar etiqueta"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE AutoSeek( nKey, nFlags, Self, oBrw, cDbfLblT ) ;
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( cDbfLblT )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
			OF 		oDlg

		REDEFINE LISTBOX oBrw ;
         FIELDS   ( cDbfLblT )->cCodLbl,;
                  ( cDbfLblT )->cNomLbl;
         HEAD     "Código",;
                  "Nombre";
         FIELDSIZES ;
                  45,;
                  90;
         ID       105 ;
         ALIAS    ( cDbfLblT ) ;
			OF 		oDlg

      oBrw:aActions     := {| nCol | lPressCol( nCol, oBrw, oCbxOrd, aCbxOrd, cDbfLblT ) }
      oBrw:bLDblClick   := {|| oDlg:end( IDOK ) }

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         ACTION   ( WinAppRec( oBrw, bEdit, cDbfLblT ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         ACTION   ( WinEdtRec( oBrw, bEdit, cDbfLblT ) )

   oDlg:AddFastKey( VK_F2,       {|| WinAppRec( oBrw, bEdit, cDbfLblT ) } )
   oDlg:AddFastKey( VK_F3,       {|| WinEdtRec( oBrw, bEdit, cDbfLblT ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( cDbfLblT )->cCodLbl )
		oGet:lValid()

      if ValType( oGet2 ) == "O"
         oGet2:cText( ( cDbfLblT )->cNomLbl )
      end if

   end if

   SetBrwOpt( "BrwLbl", ( cDbfLblT )->( OrdNumber() ) )

   CloseFiles()

   oGet:SetFocus()

RETURN oDlg:nResult == IDOK

//---------------------------------------------------------------------------//

FUNCTION cEtiqueta( oGet, dbfLblT, oGet2, cTipo )

   local nOrdAnt  := ( dbfLblT )->( ordSetFocus( 1 ) )
   local lValid   := .f.
   local xValor   := oGet:VarGet()

   if Empty( xValor )
      if( oGet2 != nil, oGet2:cText( "" ), )
      return .t.
   else
      xValor      := RJustObj( oGet, "0" )
   end if

   if ( dbfLblT )->( dbSeek( xValor ) ) .and. ( dbfLblT )->cTipLbl == cTipo

      oGet:cText( ( dbfLblT )->cCodLbl )

      if oGet2 != nil
         oGet2:cText( ( dbfLblT )->cNomLbl )
      end if

      lValid   := .t.

   else

      msgStop( "Etiqueta no encontrada", "Aviso del sistema" )

   end if

   ( dbfLblT )->( ordSetFocus( nOrdAnt ) )

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION aEtqArt()

   local aDoc  := {}

   aAdd( aDoc, { "Artículo",        "AR" } )

RETURN ( aDoc )

//---------------------------------------------------------------------------//

FUNCTION aEtqCli()

   local aDoc  := {}

   aAdd( aDoc, { "Clientes",        "CL" } )
   aAdd( aDoc, { "Obras",           "OB" } )

RETURN ( aDoc )

//---------------------------------------------------------------------------//

FUNCTION aEtqPrv()

   local aDoc  := {}

   aAdd( aDoc, { "Proveedor",       "PR" } )

RETURN ( aDoc )

//---------------------------------------------------------------------------//

Static Function ExpDoc( oWndBrw )

   local oDlg
   local oGetFile
   local cGetFile    := Padr( "A:\Docs.Zip", 100 )

   DEFINE DIALOG oDlg RESOURCE "EXPDOCS"

      REDEFINE SAY PROMPT ( cDbfLblT )->cNomLbl;
         ID       100 ;
         OF       oDlg

      REDEFINE GET oGetFile VAR cGetFile ;
         ID       110 ;
         BITMAP   "FOLDER" ;
         ON HELP  ( oGetFile:cText( Padr( cGetFile( "*.zip", "Seleccion de Fichero" ), 100 ) ) ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( ExeExpDoc( Rtrim( cGetFile ), oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

    oDlg:AddFastKey( VK_F5, {|| ExeExpDoc( Rtrim( cGetFile ), oDlg ) } )

	ACTIVATE DIALOG oDlg CENTER

Return ( nil )

//---------------------------------------------------------------------------//

Static Function ExeExpDoc( cGetFile, oDlg )

   local aDir
   local nZip
   local tmpLblT
   local tmpLblL
   local nHandle     := 0
   local nOrdAnt     := ( cDbfLblT )->( OrdSetFocus( "cCodLbl" ) )
   local nRecAnt     := ( cDbfLblT )->( Recno() )
   local cCodDoc     := ( cDbfLblT )->cCodLbl

   oDlg:Disable()

   mkLbl( cPatTmp(), , , , cLocalDriver() )

   USE ( cPatTmp() + "LBLT.DBF" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "LBLT", @tmpLblT ) )
   SET ADSINDEX TO ( cPatTmp() + "LBLT.CDX" ) ADDITIVE

   USE ( cPatTmp() + "LBLL.DBF" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "LBLL", @tmpLblL ) )
   SET ADSINDEX TO ( cPatTmp() + "LBLL.CDX" ) ADDITIVE

   if ( cDbfLblT )->( dbSeek( cCodDoc ) )
      while ( cDbfLblT )->cCodLbl == cCodDoc .and. !( cDbfLblT )->( eof() )
         dbPass( cDbfLblT, tmpLblT, .t. )
         ( cDbfLblT )->( dbSkip() )
      end while
   end if

   if ( cDbfLblL )->( dbSeek( cCodDoc ) )
      while ( cDbfLblL )->cCodLbl == cCodDoc .and. !( cDbfLblL )->( eof() )
         dbPass( cDbfLblL, tmpLblL, .t. )
         ( cDbfLblL )->( dbSkip() )
      end while
   end if

   ( tmpLblT )->( dbCloseArea() )
   ( tmpLblL )->( dbCloseArea() )

   ( cDbfLblT )->( OrdSetFocus( nOrdAnt ) )
   ( cDbfLblT )->( dbGoTo( nRecAnt ) )

   /*
   Comprobaciones previas a la creación del zip
   */

   nHandle           := fCreate( cGetFile )
   if nHandle == -1

      MsgStop( "Ruta no válida" )
      oDlg:Enable()
      return ( .f. )

   else

      if fClose( nHandle ) .and. ( fErase( cGetFile ) == 0 )

         /*
         Creamos el zip--------------------------------------------------------
         */

         aDir     := Directory( cPatTmp() + "Lbl*.*" )

         hb_SetDiskZip( {|| nil } )
         aEval( aDir, { | cName, nIndex | hb_ZipFile( cGetFile, cPatTmp( .t., .t. ) + cName[ 1 ], 9 ) } )
         hb_gcAll()

         EraseFilesInDirectory(cPatTmp(), "Lbl*.*" )

         msgInfo( "Documento exportado satisfactoriamente" )

         oDlg:Enable()

      else

         MsgStop( "Error en la unidad" )
         oDlg:Enable()
         return ( .f. )

      end if

   end if

   oDlg:End()

Return nil

//---------------------------------------------------------------------------//

Static Function GetDoc( oWndBrw )

   local oDlg
   local oGetFile
   local cGetFile    := Padr( "A:\Docs.Zip", 100 )
   local oSayProc
   local cSayProc    := ""

   DEFINE DIALOG oDlg RESOURCE "IMPDOCS"

      REDEFINE GET oGetFile VAR cGetFile ;
         ID       100 ;
         BITMAP   "FOLDER" ;
         ON HELP  ( oGetFile:cText( Padr( cGetFile( "*.zip", "Selección de fichero" ), 100 ) ) ) ;
			OF 		oDlg

      REDEFINE SAY oSayProc PROMPT cSayProc ;
         ID       110 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( ExeGetDoc( cGetFile, oSayProc, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "ConfigurarDocumentos" ) )

   oDlg:AddFastKey( VK_F5, {|| ExeGetDoc( cGetFile, oSayProc, oDlg ) } )
   oDlg:AddFastKey( VK_F1, {|| ChmHelp( "ConfigurarDocumentos" ) } )

	ACTIVATE DIALOG oDlg CENTER

   if oWndBrw != nil
      oWndBrw:Refresh()
   end if

Return ( nil  )

//---------------------------------------------------------------------------//

Static Function ExeGetDoc( cGetFile, oSayProc, oDlg )

   local nZip
   local tmpLblT
   local tmpLblL
   #ifdef __HARBOUR__
   local aFiles
   #endif

   cGetFile          := Rtrim( cGetFile )

   if !file( cGetFile )

      MsgStop( "El fichero " + cGetFile + " no existe." )
      return .f.

   end if

#ifdef __HARBOUR__

   aFiles      := Hb_GetFilesInZip( cGetFile )
   if !Hb_UnZipFile( cGetFile, , , , cPatTmp(), aFiles )
      MsgStop( "No se ha descomprimido el fichero " + cGetFile, "Error" )
   end if
   hb_gcAll()

#else

   nZip     := UnZipOpen( cGetFile )
   if nZip  != F_ERROR
      aEval( UnZipDirectory( nZip ), { | cName | UnZipExtractFile( nZip, cName ) } )
      UnZipClose( nZip )
   end if

#endif

   if !file( cPatTmp() + "LBLT.DBF" )  .or.;
      !file( cPatTmp() + "LBLL.DBF" )

      MsgStop( "Faltan ficheros para importar el documento" )
      return .f.

   end if

   oDlg:Disable()

   USE ( cPatTmp() + "LBLT.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "LBLT", @tmpLblT ) )
   SET ADSINDEX TO ( cPatTmp() + "LBLT.CDX" ) ADDITIVE

   USE ( cPatTmp() + "LBLL.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "LBLL", @tmpLblL ) )
   SET ADSINDEX TO ( cPatTmp() + "LBLL.CDX" ) ADDITIVE

   oSayProc:SetText( "Importando documento" )

   while ( cDbfLblT )->( dbSeek( ( tmpLblT )->cCodLbl ) ) .and. !( cDbfLblT )->( eof() )
      if ( cDbfLblT )->( dbRLock() )
         ( cDbfLblT )->( dbDelete() )
      end if
   end while

   while !( tmpLblT )->( eof() )
      dbPass( tmpLblT, cDbfLblT, .t. )
      ( tmpLblT )->( dbSkip() )
   end while

   oSayProc:SetText( "Importando lineas" )

   while ( cDbfLblL )->( dbSeek( ( tmpLblL )->cCodLbl ) ) .and. !( cDbfLblL )->( eof() )
      if ( cDbfLblL )->( dbRLock() )
         ( cDbfLblL )->( dbDelete() )
      end if
   end while

   while !( tmpLblL )->( eof() )
      dbPass( tmpLblL, cDbfLblL, .t. )
      ( tmpLblL )->( dbSkip() )
   end while

   oSayProc:SetText( "Proceso finalizado" )

   ( tmpLblT )->( dbCloseArea() )
   ( tmpLblL )->( dbCloseArea() )

   /*
   Eliminar todos los ficheros-------------------------------------------------
   */

   EraseFilesInDirectory(cPatTmp(), "*.*" )

   msgInfo( "Documento importado satisfactoriamente" )

   oDlg:Enable()
   oDlg:End()

return .t.

//---------------------------------------------------------------------------//

FUNCTION EdtEtiquetas( cCodLbl )

   local nLevel

   if Empty( cCodLbl )
      Return .f.
   end if

   nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles()
      if dbSeekInOrd( cCodLbl, "cCodLbl", cDbfLblT )
         WinEdtRec( nil, bEdit, cDbfLblT )
      else
         MsgStop( "No se encuentra formato de etiqueta" )
      end if
      CloseFiles()
   end if

Return .t.

//----------------------------------------------------------------------------//