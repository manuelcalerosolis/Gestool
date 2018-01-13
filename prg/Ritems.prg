#include "FiveWin.Ch"
#include "Folder.ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "Print.ch"

#define FW_NORMAL          400
#define FW_BOLD            700

#define _MENUITEM_         "01068"

#xtranslate MinMax( <xValue>, <nMin>, <nMax> ) => ;
   Min( Max( <xValue>, <nMin> ), <nMax> )

/*
Bases de datos de los documentos-----------------------------------------------
*/

#define dCTIPO                    1      //   C      2     0
#define dCODIGO                   2      //   C      3     0
#define dNLENPAG                  3      //   N      6     2
#define dNWIDPAG                  4      //   N      6     2
#define dNLENDOC                  5      //   N      6     2
#define dNWIDDOC                  6
#define dNINICIO                  7      //   N      6     2
#define dNFIN                     8      //   N      6     2
#define dNLEFT                    9      //   N      6     2
#define dNRIGHT                  10      //   N      6     2
#define dNTYPELINE               11      //   N      1     0
#define dCDESCRIP                12      //   C     80     1
#define dNAJUSTE                 13      //   N      7     2
#define dLVISUAL                 14      //
#define dMREPORT                 15      //

/*
Bases de datos de los Items
*/

#define iCODIGO                    1     //   C      3     0
#define iCLITERAL                  2     //   C     25     0
#define iNLINEA                    3     //   N      5     1
#define iNCOLUMNA                  4     //   N      5     1
#define iCFICHERO                  5     //   C     10     0
#define iCCAMPO                    6     //   C    100     0
#define iCMASCARA                  7     //   C     20     0
#define iLLITERAL                  8     //   L      1     0
#define iNAJUSTE                   9     //   N      1     0
#define iLCONDICION               10     //   C     60     0
#define iNSIZE                    11     //   N      6     2
#define iFHEIGHT                  12     //   N     10     0
#define iFWIDTH                   13     //   N     10     0
#define iFESCAPE                  14     //   N     10     0
#define iFORIENT                  15     //   N     10     0
#define iFWEIGHT                  16     //   N     10     0
#define iFITALIC                  17     //   L      1     0
#define iFUNDERLINE               18     //   L      1     0
#define iFSTRIKEOUT               19     //   L      1     0
#define iFCHARSET                 20     //   N     10     0
#define iFOUTPRECIS               21     //   N     10     0
#define iFCLIPRECIS               22     //   N     10     0
#define iFQUALITY                 23     //   N     10     0
#define iFPITCHAND                24     //   N     10     0
#define iFFACENAME                25     //   C     20     0
#define iFCOLOR                   26     //   N     10     0
#define iLNOTCAJA                 27     //   L      1     0
#define iLSEL                     28     //   L      1     0

#define cCODIGO                   1      //   C      3     0
#define cNORDEN                   2      //   N      3     0
#define cCLITERAL                 3      //   C     25     0
#define cNCOLUMNA                 4      //   N      5     1
#define cCFICHERO                 5      //   C     15     0
#define cCCAMPO                   6      //   C    100     0
#define cCMASCARA                 7      //   C     20     0
#define cNAJUSTE                  8      //   C     10     0
#define cLCONDICION               9      //   C     60     0
#define cCTITULO                 10      //   C     20     0
#define cNSIZE                   11      //   N      3     0
#define cLGIRD                   12      //   L      1     0
#define cLSHADOW                 13      //   L      1     0
#define cLNEWLINE                14      //   L      1     0
#define cCNEWLINE                15      //   L      1     0
#define cFHEIGHT                 16      //   N     10     0
#define cFWIDTH                  17      //   N     10     0
#define cFESCAPE                 18      //   N     10     0
#define cFORIENT                 19      //   N     10     0
#define cFWEIGHT                 20      //   N     10     0
#define cFITALIC                 21      //   L      1     0
#define cFUNDERLINE              22      //   L      1     0
#define cFSTRIKEOUT              23      //   L      1     0
#define cFCHARSET                24      //   N     10     0
#define cFOUTPRECIS              25      //   N     10     0
#define cFCLIPRECIS              26      //   N     10     0
#define cFQUALITY                27      //   N     10     0
#define cFPITCHAND               28      //   N     10     0
#define cFFACENAME               29      //   C     20     0
#define cFCOLOR                  30      //   N     10     0
#define cLAUTPOS                 31      //   L      1     0
#define cLNOTCAJA                32      //   L      1     0
#define cNHEIGHT                 33      //   N      3     0

#define bCODIGO                   1      //   C      3     0
#define bNORDEN                   2      //   N      3     0
#define bCFICHERO                 3      //   C     15     0
#define bNROWTOP                  4      //   N      6     2
#define bNCOLTOP                  5      //   N      6     2
#define bNROWBOTTOM               6      //   N      6     2
#define bNCOLBOTTOM               7      //   N      6     2
#define bLCONDICION               8      //   C     60     0

#define xCODIGO                   1      //   C      3     0
#define xNROWTOP                  2      //   N      6     2
#define xNCOLTOP                  3      //   N      6     2
#define xNROWBOTTOM               4      //   N      6     2
#define xNCOLBOTTOM               5      //   N      6     2
#define xNTYPELINE                6      //   N      3     0
#define xLCONDICION               7      //   C     60     0

static aItmDoc    := {  {"cTipo",     "C",     2,   0, "Tipo del documento" },;
                        {"Codigo",    "C",     3,   0, "Código del documento" },;
                        {"nLenPag",   "N",     6,   2, "Alto del papel" },;
                        {"nWidPag",   "N",     6,   2, "Ancho del papel" },;
                        {"nLenDoc",   "N",     6,   2, "Alto del documento" },;
                        {"nWidDoc",   "N",     6,   2, "Ancho del documento" },;
                        {"nInicio",   "N",     6,   2, "" },;
                        {"nFin",      "N",     6,   2, "" },;
                        {"nLeft",     "N",     6,   2, "Margen derecho del documento" },;
                        {"nRight",    "N",     6,   2, "Margen izquierdo del documento" },;
                        {"nTypeLine", "N",     1,   0, "Tipo de línea del documento" },;
                        {"cDescrip",  "C",   100,   0, "Nombre del documento" },;
                        {"nAjuste",   "N",     1,   0, "Ajuste del documento" },;
                        {"lVisual",   "L",     1,   0, "Lógico documento de estilo visual" },;
                        {"mReport",   "M",     1,   0, "Contenido del documento de estilo visual" } }

static aItmItm    := {  {"Codigo",    "C",     3,   0, "Código del documento" },;
                        {"cLiteral",  "C",    50,   0, "Descripción del campo" },;
                        {"nLinea",    "N",     5,   1, "Fila" },;
                        {"nColumna",  "N",     5,   1, "Columna" },;
                        {"cFichero",  "C",    50,   0, "Tabla" },;
                        {"cCampo",    "C",   200,   0, "Nombre del campo" },;
                        {"cMascara",  "C",   100,   0, "Mascara" },;
                        {"lLiteral",  "L",     1,   0, "" },;
                        {"nAjuste",   "N",     1,   0, "Alineación ( 1- Izquierda, 2- Centro, 3- Derecha )"},;
                        {"lCondicion","C",    60,   0, "Expresión con la codición para que sea impreso" },;
                        {"nSize",     "N",     6,   2, "Ancho del texto" },;
                        {"fHeight",   "N",    10,   0, "" },;
                        {"fWidth",    "N",    10,   0, "Tamaño de la fuente" },;
                        {"fEscape",   "N",    10,   0, "" },;
                        {"fOrient",   "N",    10,   0, "" },;
                        {"fWeight",   "N",    10,   0, "" },;
                        {"fItalic",   "L",     1,   0, "Lógico para cursiva" },;
                        {"fUnderline","L",     1,   0, "" },;
                        {"fStrikeout","L",     1,   0, "Lógico para negrita" },;
                        {"fCharset",  "N",    10,   0, "" },;
                        {"fOutprecis","N",    10,   0, "" },;
                        {"fCliprecis","N",    10,   0, "" },;
                        {"fQuality",  "N",    10,   0, "" },;
                        {"fPitchand", "N",    10,   0, "" },;
                        {"fFacename", "C",    20,   0, "Nombre de la fuente" },;
                        {"fColor",    "N",    10,   0, "Número del color de la fuente" },;
                        {"lNotCaja",  "L",     1,   0, "" },;
                        {"lSel",      "L",     1,   0, "" } }

static aItmCol    := {  { "Codigo",    "C",    3,   0, "Código del documento" },;
                        { "nOrden",    "N",    3,   0, "" },;
                        { "cLiteral",  "C",   50,   0, "Descripción de la columna" },;
                        { "nColumna",  "N",    5,   1, "Posición de la columna" },;
                        { "cFichero",  "C",   50,   0, "Tabla" },;
                        { "cCampo",    "C",  200,   0, "Nombre del campo" },;
                        { "cMascara",  "C",  100,   0, "Mascara" },;
                        { "nAjuste",   "N",    1,   0, "Alineación ( 1- Izquierda, 2- Centro, 3- Derecha )" },;
                        { "lCondicion","C",   60,   0, "Expresión con la codición para que sea impreso" },;
                        { "cTitulo",   "C",   20,   0, "Título de la columna" },;
                        { "nSize",     "N",    6,   2, "Ancho de la columna" },;
                        { "lGird",     "L",    1,   0, "Lógico columna con línea de separación" },;
                        { "lShadow",   "L",    1,   0, "Lógico columna sombreada" },;
                        { "lNewLine",  "L",    1,   0, "Lógico columna con salto al final" },;
                        { "cNewLine",  "C",  200,   0, "Expresión con la condición de salto al final" },;
                        { "fHeight",   "N",   10,   0, "" },;
                        { "fWidth",    "N",   10,   0, "Tamaño de la fuente" },;
                        { "fEscape",   "N",   10,   0, "" },;
                        { "fOrient",   "N",   10,   0, "" },;
                        { "fWeight",   "N",   10,   0, "" },;
                        { "fItalic",   "L",    1,   0, "Lógico para cursiva" },;
                        { "fUnderline","L",    1,   0, "" },;
                        { "fStrikeout","L",    1,   0, "Lógico para negrita" },;
                        { "fCharset",  "N",   10,   0, "" },;
                        { "fOutprecis","N",   10,   0, "" },;
                        { "fCliprecis","N",   10,   0, "" },;
                        { "fQuality",  "N",   10,   0, "" },;
                        { "fPitchand", "N",   10,   0, "" },;
                        { "fFacename", "C",   20,   0, "Nombre de la fuente" },;
                        { "fColor",    "N",   10,   0, "Número del color de la fuente" },;
                        { "lAutpos",   "L",    1,   0, "Lógico de posición automática" },;
                        { "lNotcaja",  "L",    1,   0, "" },;
                        { "nHeight",   "N",    6,   2, "" } }

static aItmBmp    := {  { "Codigo",    "C",    3,   0 },;
                        { "NORDEN",    "N",    3,   0 },;
                        { "CFICHERO",  "C",  200,   0 },;
                        { "NROWTOP",   "N",    6,   2 },;
                        { "NCOLTOP",   "N",    6,   2 },;
                        { "NROWBOTTOM","N",    6,   2 },;
                        { "NCOLBOTTOM","N",    6,   2 },;
                        { "LCONDICION","C",   60,   0 } }

static aItmBox    := {  { "Codigo",    "C",    3,   0 },;
                        { "NROWTOP",   "N",    6,   2 },;
                        { "NCOLTOP",   "N",    6,   2 },;
                        { "NROWBOTTOM","N",    6,   2 },;
                        { "NCOLBOTTOM","N",    6,   2 },;
                        { "NTYPELINE", "N",    3,   0 },;
                        { "LCONDICION","C",   60,   0 },;
                        { "RED",       "N",    3,   0 },;
                        { "GREEN",     "N",    3,   0 },;
                        { "BLUE",      "N",    3,   0 },;
                        { "LSELBOX",   "L",    1,   0 } }

static aTipDoc     := {  "Artículos [Etiquetas]",;
                         "Clientes [Etiquetas]",;
                         "Proveedores [Etiquetas]",;
                         "Albarán proveedores [Etiquetas]",;
                         "Factura proveedores [Etiquetas]",;
                         "Factura rectificativas de proveedores [Etiquetas]",;
                         "Movimientos de almacén [Etiquetas]",;
                         "Ofertas de artículos [Etiquetas]",;
                         "Producción [Etiquetas]",;
                         "Pedido de proveedores [Etiquetas]",;
                         "Albaran de clientes [Etiquetas]",;
                         "Pedido de clientes [Etiquetas]",;
                         "Presupuesto de clientes [Etiquetas]",;
                         "Factura de clientes [Etiquetas]",;
                         "Factura rectificativa de cliente [Etiquetas]",;
                         "S.A.T. clientes [Etiquetas]",;
                         "Pedido proveedores",;
                         "Albarán proveedores",;
                         "Factura proveedores",;
                         "Factura rectificativas proveedores",;
                         "Recibos facturas proveedor",;
                         "S.A.T. clientes",;
                         "Presupuesto clientes",;
                         "Pedido clientes",;
                         "Albarán clientes",;
                         "Factura clientes",;
                         "Factura de anticipos",;
                         "Factura rectificativa",;
                         "Recibos facturas clientes",;
                         "Tickets clientes",;
                         "Depositos almacén",;
                         "Existencias almacén",;
                         "Movimientos de almacén",;
                         "Entregas a cuenta en pedidos de clientes",;
                         "Entregas a cuenta en albaranes de clientes",;
                         "Parte de producción",;
                         "Expedientes",;
                         "Arqueo de sesiones",;
                         "Pagos de clientes",;
                         "Liquidación de agentes" }

static aCodDoc     := {  "AR",;
                         "CL",;
                         "PL",;
                         "AL",;
                         "FL",;
                         "RL",;
                         "MV",;
                         "OF",;
                         "LP",;
                         "PE",;
                         "AB",;
                         "PB",;
                         "PR",;
                         "FB",;
                         "FI",;
                         "SA",;
                         "PP",;
                         "AP",;
                         "FP",;
                         "TP",;
                         "RP",;
                         "SC",;
                         "RC",;
                         "PC",;
                         "AC",;
                         "FC",;
                         "TC",;
                         "FR",;
                         "RF",;
                         "TK",;
                         "DA",;
                         "EX",;
                         "RM",;
                         "EP",;
                         "EA",;
                         "PO",;
                         "ED",;
                         "AQ",;
                         "MP",;
                         "LQ" }
 
static oWndBrw
static dbfItm
static dbfCol
static dbfDoc
static dbfBmp
static dbfBox
static nAjuste
static bEdit0 	:= { |aTmp, aGet, cDbfas, oBrw, bWhen, bValid, nMode | EdtDocs( aTmp, aGet, cDbfas, oBrw, bWhen, bValid, nMode ) }
static bEdit1     := { |aTmp, aGet, cDbfas, oBrw, bWhen, bValid, nMode | RenameItems( aTmp, aGet, cDbfas, oBrw, bWhen, bValid, nMode ) }

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local oError
   local oBlock
   local lOpenFiles  := .t.

   if !lExistTable( cPatEmp() + "RDOCUMEN.DBF" )   .OR. ;
      !lExistTable( cPatEmp() + "RITEMS.DBF"   )   .OR. ;
      !lExistTable( cPatEmp() + "RCOLUM.DBF"   )   .OR. ;
      !lExistTable( cPatEmp() + "RBITMAP.DBF"  )   .OR. ;
      !lExistTable( cPatEmp() + "RBOX.DBF"     )

      mkDocs( cPatEmp() )

   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RITEMS.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RITEMS", @dbfItm ) )
      SET ADSINDEX TO ( cPatEmp() + "RITEMS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RCOLUM.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RCOLUM", @dbfCol ) )
      SET ADSINDEX TO ( cPatEmp() + "RCOLUM.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RBITMAP.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RBITMAP", @dbfBmp ) )
      SET ADSINDEX TO ( cPatEmp() + "RBITMAP.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RBOX.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RBOX", @dbfBox ) )
      SET ADSINDEX TO ( cPatEmp() + "RBOX.CDX" ) ADDITIVE

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )
      CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//----------------------------------------------------------------------------//

FUNCTION CfgDocs( oMenuItem, oWnd )

   local oRpl
   local oFlt
   local nLevel

	IF oWndBrw == NIL

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

   if !OpenFiles()
      return nil
   end if

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70;
      XBROWSE ;
	TITLE      "Documentos" ;
      PROMPT      "Código" ,;
                  "Documento" ;
      MRU         "gc_document_text_screw_16" ;
      BITMAP      clrTopHerramientas ;
	ALIAS		( dbfDoc ) ;
	APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit0, dbfDoc, , {|oGet| NotValid( oGet, dbfDoc ) } ) );
      EDIT     ( VisualEdtDocs( dbfDoc ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfDoc, {|| DocDelRec() } ) );
      LEVEL    nLevel ;
	OF 		oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Codigo"
         :bEditValue       := {|| ( dbfDoc )->Codigo }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Documento"
         :cSortOrder       := "cDescrip"
         :bEditValue       := {|| ( dbfDoc )->cDescrip }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Tipo de documento"
         :bEditValue       := {|| cTipDoc( ( dbfDoc )->cTipo ) }
         :nWidth           := 280
      end with

      oWndBrw:cHtmlHelp    := "Documentos"

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
			TOOLTIP 	"(B)uscar";
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecAdd() );
			TOOLTIP 	"(A)ñadir";
         BEGIN GROUP;
         HOTKEY   "A";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( if( ( dbfDoc )->lVisual, WinDupRec( oWndBrw:oBrw, bEdit0, dbfDoc ), msgInfo( "No se puede modificar el formato." + CRLF + "Tiene que crear un nuevo formato de forma visual.", "Formato obsoleto" ) ) );
			TOOLTIP 	"(D)uplicar";
         HOTKEY   "D";
         LEVEL    ACC_APPD

		DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( oWndBrw:RecEdit() );
			TOOLTIP 	"(M)odificar";
         HOTKEY   "M";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "GC_TEXT_FIELD_" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinEdtRec( oWndBrw:oBrw, bEdit1, dbfDoc ) );
         TOOLTIP  "(R)enombrar";
         HOTKEY   "R" ;
         LEVEL    ACC_EDIT

	DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
			ACTION  	( WinZooRec( oWndBrw:oBrw, bEdit0, dbfDoc ) );
			TOOLTIP 	"(Z)oom";
         HOTKEY   "Z" ;
         LEVEL    4

	DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
			ACTION 	( oWndBrw:RecDel() );
			TOOLTIP 	"(E)liminar";
         HOTKEY   "E" ;
         LEVEL    ACC_DELE

      if oUser():lAdministrador()

         DEFINE BTNSHELL oRpl RESOURCE "BMPCHG" GROUP OF oWndBrw ;
            NOBORDER ;
            MENU     This:Toggle() ;
            ACTION   ( ReplaceCreator( oWndBrw, dbfDoc, aItmDoc ) ) ;
            TOOLTIP  "Cambiar campos" ;
            LEVEL    ACC_EDIT

            DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
               ACTION   ( ReplaceCreator( oWndBrw, dbfItm, aItmItm ) ) ;
               TOOLTIP  "Campos" ;
               FROM     oRpl ;
               CLOSED ;
               LEVEL    ACC_EDIT

            DEFINE BTNSHELL RESOURCE "BMPCHG" OF oWndBrw ;
               ACTION   ( ReplaceCreator( oWndBrw, dbfCol, aItmCol ) ) ;
               TOOLTIP  "Columnas" ;
               FROM     oRpl ;
               CLOSED ;
               LEVEL    ACC_EDIT

      end if

      DEFINE BTNSHELL oFlt RESOURCE "BFILTER" GROUP OF oWndBrw;
         NOBORDER ;
         MENU     ( This:Toggle() ) ;
         ACTION   ( ( dbfDoc )->( dbClearFilter() ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
         TOOLTIP  "Filtrar" ;
         LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_OBJECT_CUBE_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'AR' }, "Field->cTipo == 'AR'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Atículos[etiquetas]" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_USER_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'CL' }, "Field->cTipo == 'CL'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Clientes[etiquetas]" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "gc_businessman_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'PL' }, "Field->cTipo == 'PL'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Proveedores[etiquetas]" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "gc_document_empty_businessman_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'FL' }, "Field->cTipo == 'FL'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Albarán proveedor[etiquetas]" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "gc_document_text_businessman_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'FL' }, "Field->cTipo == 'FL'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Factura proveedor[etiquetas]" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "gc_clipboard_empty_businessman_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'PP' }, "Field->cTipo == 'PP'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Pedidos a proveedores" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "gc_document_empty_businessman_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'AP' }, "Field->cTipo == 'AP'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Albaran de proveedores" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "gc_document_text_businessman_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'FP' }, "Field->cTipo == 'FP'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Factura de proveedores" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "gc_document_text_businessman_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'TP' }, "Field->cTipo == 'TP'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Factura rectificativa de proveedores" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_BRIEFCASE2_BUSINESSMAN_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'RP' }, "Field->cTipo == 'RP'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Recibos facturas proveedor" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_NOTEBOOK_USER_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'RC' }, "Field->cTipo == 'RC'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Presupuesto clientes" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_CLIPBOARD_EMPTY_USER_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'PC' }, "Field->cTipo == 'PC'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Pedido clientes" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_EMPTY_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'AC' }, "Field->cTipo == 'AC'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Albarán clientes" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_USER_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'FC' }, "Field->cTipo == 'FC'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Factura clientes" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_MONEY2_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'TC' }, "Field->cTipo == 'TC'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Factura de anticipos" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_USER_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'FR' }, "Field->cTipo == 'FR'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Factura rectificativa" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_CASH_REGISTER_USER_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'TK' }, "Field->cTipo == 'TK'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Tikets de clientes" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_BRIEFCASE2_USER_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'RF' }, "Field->cTipo == 'RF'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Recibos facturas clientes" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_PENCIL_PACKAGE_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'RM' }, "Field->cTipo == 'RM'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Movimientos de almacén" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_PACKAGE_PLUS_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'DA' }, "Field->cTipo == 'DA'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Depositos almacén" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_PACKAGE_CHECK_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'EX' }, "Field->cTipo == 'EX'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Existencias almacén" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_CLIPBOARD_EMPTY_USER_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'EP' }, "Field->cTipo == 'EP'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Entregas a cuenta en pedidos de clientes" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_EMPTY_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'EA' }, "Field->cTipo == 'EA'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Entregas a cuenta en albaranes de clientes" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_WORKER_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'PO' }, "Field->cTipo == 'PO'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Parte de producción" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "gc_folder_document_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'ED' }, "Field->cTipo == 'ED'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Expedientes" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

         DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_TEXT_WORKER_" OF oWndBrw ;
            ACTION   ( ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == 'EP' }, "Field->cTipo == 'EP'" ) ), ( dbfDoc )->( dbGoTop() ), oWndBrw:Refresh() ) ;
            TOOLTIP  "Etiquetas producción" ;
            FROM     oFlt ;
            CLOSED ;
            LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_export2_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ControllerExportDocument( oWndBrw, ".fr3" ) );
         TOOLTIP  "Exportar fr3";
         HOTKEY   "3" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_export2_" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ControllerExportDocument( oWndBrw, ".zip" ) );
         TOOLTIP  "E(x)portar zip";
         HOTKEY   "X" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "gc_import_" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( DlgImportDocument( oWndBrw ) );
         TOOLTIP  "Im(p)ortar zip";
         HOTKEY   "P" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir" ;
			HOTKEY 	"S"

		ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

	ELSE

		oWndBrw:SetFocus()

	END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   ( dbfDoc    )->( dbCloseArea() )
   ( dbfItm    )->( dbCloseArea() )
   ( dbfCol    )->( dbCloseArea() )
   ( dbfBmp    )->( dbCloseArea() )
   ( dbfBox    )->( dbCloseArea() )

   dbfDoc            := nil
   dbfItm            := nil
   dbfCol            := nil
   dbfBmp            := nil
   dbfBox            := nil

   oWndBrw           := nil

RETURN .T.

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtDocs( aTmp, aGet, dbfDoc, oBrw, cTipoDoc, bValid, nMode )

   local oDlg
   local nPos
   local oTipDoc
   local cTipDoc     := aTipDoc[ 1 ]
   local cCodDoc     := aCodDoc[ 1 ]
   local oBtnAceptar

   if nMode == APPD_MODE
      nPos              := aScan( aTipDoc, {| aTipDoc | substr( aTipDoc, 1, 2 ) == cTipoDoc } )
      cTipDoc           := aTipDoc[ if( nPos != 0, nPos, 1 )  ]
      aTmp[ dLVISUAL ]  := .t.
   else
      nPos        := aScan( aCodDoc, {| aCodDoc | SubStr( aCodDoc, 1, 2 ) == aTmp[ dCTIPO ] } )
      cTipDoc     := aTipDoc[ if( nPos != 0, nPos, 1 )  ]
      cCodDoc     := aTmp[ dCTIPO ]
   end if

   /*
   Creamos la primera caja de Dialogo
   -------------------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTS" TITLE LblTitle( nMode ) + "documento : " + rtrim( aTmp[ dCDESCRIP ] )


      REDEFINE COMBOBOX oTipDoc ;
         VAR      cTipDoc ;
         WHEN     ( nMode == APPD_MODE ) ;
         ITEMS    aTipDoc ;
         ON CHANGE( cCodDoc := aCodDoc[ Max( 1, oTipDoc:nAt ) ] ) ;
         VALID    ( cCodDoc := aCodDoc[ Max( 1, oTipDoc:nAt ) ], .t. ) ;
         ID       100 ;
         OF       oDlg

	REDEFINE GET aGet[ dCODIGO ] VAR aTmp[ dCODIGO ] ;
         VALID    ( notValid( aGet[ dCODIGO ], dbfDoc ) );
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         PICTURE  "@!" ;
			ID 		110 ;
         OF       oDlg

	REDEFINE GET aGet[ dCDESCRIP ] VAR aTmp[ dCDESCRIP ] ;
	     WHEN 		( nMode != ZOOM_MODE ) ;
	     ON CHANGE ( ActTitle( nKey, nFlags, Self, nMode, oDlg ) );
	     ID 		120 ;
           OF       oDlg

   REDEFINE BUTTON oBtnAceptar ;
		ID 		511 ;
		OF 		oDlg ;
      WHEN     (  nMode != ZOOM_MODE ) ;
      ACTION   (  SaveEdtDocs( aTmp, aGet, oDlg, oBrw, oBtnAceptar, cCodDoc, nMode ) )

	REDEFINE BUTTON ;
		ID 		510 ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   (  oDlg:end( IDOK ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| SaveEdtDocs( aTmp, aGet, oDlg, oBrw, oBtnAceptar, cCodDoc, nMode ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER ;
      ON PAINT ( lPaintDoc( oDlg, { aTmp[ dNLENPAG ], aTmp[ dNWIDPAG ] }, { aTmp[ dNLEFT ], aTmp[ dNINICIO ], aTmp[ dNRIGHT], aTmp[ dNFIN ]} ) )

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

FUNCTION PrnDoc( cTipo, oReport, cDiv, nVdv )

	SetMargin( cTipo, oReport )
	PrintItems( cTipo, oReport, cDiv, nVdv )

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION SetMargin( cTipo, oReport )

   local nTipoLinea
   local oError
   local oBlock
   local dbfDocment
   local lOpenFiles  := .f.

	/*
	Tomamos las Dimensiones del listado
	*/

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "RDOCUMEN", @dbfDocment ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      
      lOpenFiles     := .t.

   RECOVER USING oError

      CLOSE ( dbfDocment )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      msgStop( "Imposible abrir todas las bases de datos de documentos." + CRLF + ErrorMessage( oError ) )
      Return ( lOpenFiles )
   end if

   /*
   Establecemos los margenes---------------------------------------------------
   */

   if ( dbfDocment )->( dbSeek( cTipo ) )

      if ( dbfDocment )->nWidPag != 0 .and. ( dbfDocment )->nLenPag != 0

         oReport:oDevice:SetSize( ( dbfDocment )->nWidPag * 100, ( dbfDocment )->nLenPag * 100 )

         oReport:nWidth  := oReport:oDevice:nHorzRes()
         oReport:nHeight := oReport:oDevice:nVertRes()

      end if

      /*
      Margenes del documento
      */

      oReport:Margin( ( dbfDocment )->nInicio, RPT_TOP,    RPT_CMETERS )
      oReport:Margin( ( dbfDocment )->nFin,    RPT_BOTTOM, RPT_CMETERS )
      oReport:Margin( ( dbfDocment )->nLeft,   RPT_LEFT,   RPT_CMETERS )
      oReport:Margin( ( dbfDocment )->nRight,  RPT_RIGHT,  RPT_CMETERS )

      nTipoLinea           := ( dbfDocment )->nTypeLine - 1
		oReport:nTitleUpLine := nTipoLinea
		oReport:nTitleDnLine := nTipoLinea

   else

      MsgTime( "Imposible establecer margenes documento " + cTipo, "Atención" )

   end if

   CLOSE ( dbfDocment )

Return ( lOpenFiles )

//--------------------------------------------------------------------------//

FUNCTION PrintItems( cTipo, oInf, lPreview, nOffSet )

   local cText
   local cLine
   local nFor
   local nRow
   local nCol
   local nSizTxt
   local aCoors
   local nLines
   local nHeight
   local nSize
   local oFont
   local dbfBox
   local dbfBmp
   local dbfItems
   local bCondition
   local aStart
   local aEnd
   local oPen
   local fColor
   local nWidth
   local cMasc
   local oError
   local oBlock
   local lOpenFiles  := .f.

   DEFAULT lPreview  := .f.
   DEFAULT nOffSet   := 0

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "RBITMAP.DBF" )   NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "RBITMAP", @dbfBmp ) )
      SET ADSINDEX TO ( cPatEmp() + "RBITMAP.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RBOX.DBF" )      NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "RBOX", @dbfBox ) )
      SET ADSINDEX TO ( cPatEmp() + "RBOX.CDX" ) ADDITIVE

      USE ( cPatEmp() + "RITEMS.DBF" )    NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "RITEMS", @dbfItems ) )
      SET ADSINDEX TO ( cPatEmp() + "RITEMS.CDX" ) ADDITIVE

      lOpenFiles     := .t.

   RECOVER USING oError

      CLOSE ( dbfBmp   )
      CLOSE ( dbfBox   )
      CLOSE ( dbfItems )

   END SEQUENCE
   ErrorBlock( oBlock )

   if !lOpenFiles
      msgStop( "Imposible abrir todas las bases de datos de documentos." + CRLF + ErrorMessage( oError ) )
      Return ( lOpenFiles )
   end if

   nAjuste           := 0

   /*
   Primero los Bitmaps
	------------------------------------------------------------------------
   */

   if ( dbfBmp )->( dbSeek( cTipo ) )

      while ( dbfBmp )->Codigo == cTipo .AND. !( dbfBmp )->( Eof() )

         if File( ( dbfBmp )->cFichero )

            aStart := oInf:oDevice:Cmtr2Pix( ( dbfBmp )->nRowTop + nOffSet, ( dbfBmp )->nColTop )
            aEnd   := oInf:oDevice:Cmtr2Pix( ( dbfBmp )->nRowBottom + nOffSet, ( dbfBmp )->nColBottom )

            oInf:oDevice:SayBitmap( aStart[1], aStart[2], ( dbfBmp )->cFichero, aEnd[1], aEnd[2] )

         end if

         ( dbfBmp )->( dbSkip() )

      end while

   end if

	/*
	Ahora las Cajas
	------------------------------------------------------------------------
   */

   if ( dbfBox )->( dbSeek( cTipo ) )

      while ( dbfBox )->Codigo == cTipo .AND. !( dbfBox )->( Eof() )

         if !Empty( ( dbfBox )->lCondicion ) .and. !lPreview
            bCondition  := bChar2Block( ( dbfBox )->lCondicion, .t. )
         else
            bCondition  := {|| .t. }
         end if

         if Eval( bCondition )

            aStart := oInf:oDevice:Cmtr2Pix( ( dbfBox )->nRowTop + nOffSet, ( dbfBox )->nColTop )
            aEnd   := oInf:oDevice:Cmtr2Pix( ( dbfBox )->nRowBottom + nOffSet, ( dbfBox )->nColBottom )

            DEFINE PEN oPen WIDTH ( dbfBox )->nTypeLine COLOR Rgb( ( dbfBox )->Red, ( dbfBox )->Green, ( dbfBox )->Blue )

            if ( aStart[1] == aEnd[1] .or. aStart[2] == aEnd[2] )
               oInf:oDevice:Line( aStart[1], aStart[2], aEnd[1], aEnd[2], oPen )
            else
               oInf:oDevice:Box( aStart[1], aStart[2], aEnd[1], aEnd[2], oPen )
            end if
            oPen:end()

         end if

         ( dbfBox )->( dbSkip() )

      end while

   end if

	/*
   Los items
	------------------------------------------------------------------------
   */

   if ( dbfItems )->( dbSeek( cTipo ) )

      while ( dbfItems )->Codigo == cTipo .AND. !( dbfItems )->( Eof() )

         nRow  := ( dbfItems )->nLinea + ( ( oInf:nPage - 1 ) * nAjuste ) + nOffSet
         nCol  := ( dbfItems )->nColumna
         nSize := ( dbfItems )->nSize

         if nRow != 0 .OR. nCol != 0

            if !Empty( ( dbfItems )->lCondicion ) .and. !lPreview

               if !Empty( Rtrim( ( dbfItems )->cFichero ) )
                  Select( &( ( dbfItems )->cFichero ) )
               end if

               bCondition  := bChar2Block( ( dbfItems )->lCondicion, .t. )

            else

               bCondition  := {|| .T. }

            end if

            if Eval( bCondition )

               if ( dbfItems )->lLiteral

                  cText       := ( dbfItems )->cCampo
                  cText       := if( SubStr( cText, 1, 1 ) != '"', '"' + Rtrim( cText ) + '"', cText )
                  cText       := Eval( bChar2Block( cText ) )

               else

                  if lPreview

                     if ( dbfItems )->lLiteral
                        cText := ( dbfItems )->cCampo
                     else
                        cText := ( dbfItems )->cLiteral
                     end if

                  else

                     if !Empty( RTrim( ( dbfItems )->cFichero ) )
                        if At( Type( ( ( dbfItems )->cFichero ) ), "UE" ) == 0
                           Select( &( ( dbfItems )->cFichero ) )
                        end if
                     end if

                     cText    := Eval( bChar2Block( ( dbfItems )->cCampo ) )

                  end if

               end if

               // Creación de nuevo font------------------------------------------

               if !Empty( ( dbfItems )->fFaceName )
                  oFont := TFont():New(   Rtrim( ( dbfItems )->fFaceName ),;                         //cFaceName,;
                                          0,;                                                        //nWidth,;
                                          ( dbfItems )->fWidth,;                                     //nHeight,;
                                          ,;                                                         //lFromUser,;
                                          ( dbfItems )->fItalic,;                                    //lBold,;
                                          ,;                                                         //nEscapement,;
                                          ,;                                                         //nOrientation,;
                                          ,;                                                         //nWeight,;
                                          ( dbfItems )->fStrikeOut,;                                 //lItalic,;
                                          ,;                                                         //lUnderline,;
                                          ,;                                                         //lStrikeOut,;
                                          ,;                                                         //nCharSet,;
                                          ,;                                                         //nOutPrecision,;
                                          ,;                                                         //nClipPrecision,;
                                          ,;                                                         //nQuality,;
                                          oInf:oDevice )                                             //oDevice,;
               else
                  oFont := TFont():New( "Arial", 0, -10,,.t.,,,,,,,,,,, oInf:oDevice )
               end if

               IF Empty( Rtrim( ( dbfItems )->cMascara ) ) .or. lPreview
                  cText    := cValToChar( cText )
					ELSE
                  cMasc    := Eval( bChar2Block( Rtrim( ( dbfItems )->cMascara ) ) )
                  if ValType( cMasc ) == "C"
                     cText := Trans( cText, cMasc )
                  else
                     cText := cValToChar( cText )
                  end if
					END IF

					IF ValType( cText ) == "N" .AND. cText == 0
                  cText    := ""
					END IF

               if lPreview
                  nLines   := 1
               else
                  nLines   := MlCount( cText, If( nSize == 0, 50, nSize ) )
               end if

               nHeight     := oInf:oDevice:GetTextHeight( "B", oFont )
               nSizTxt     := oInf:oDevice:GetTextWidth( Replicate( "B", nSize ), oFont )

               for nFor := 1 to nLines

                  if ( dbfItems )->nAjuste == 3     // Ajuste a la derecha
                     cLine := Alltrim( MemoLine( Ltrim( cText ), If( nSize == 0, 50, nSize ), nFor ) )
                  else
                     cLine := AllTrim( MemoLine( cText, If( nSize == 0, 50, nSize ), nFor ) )
                  end if

                  // Pasamos a pixels las posiciones a imprimir

                  aCoors   := oInf:oDevice:Cmtr2Pix( nRow, nCol )

                  if nSize != 0

                     nWidth   := oInf:oDevice:GetTextWidth( cLine, oFont )

                     do case
                        case ( dbfItems )->nAjuste == 3     // Ajuste a la derecha
                           aCoors[2] += ( nSizTxt - nWidth )

                        case ( dbfItems )->nAjuste == 2     // Ajuste centrado
                           aCoors[2] += ( ( nSizTxt / 2 ) - ( nWidth / 2 )  )

                     endcase

                  end if

                  // Colores distintos si estamos en preview

                  if lPreview
                     if ( dbfItems )->lLiteral
                        fColor   := 0
                     else
                        fColor   := 255
                     end if
                  else
                     fColor      := ( dbfItems )->fColor
                  end if

                  // Nos piden no imprimir cuando sea cero

                  oInf:oDevice:Say( aCoors[ 1 ] + ( ( nFor - 1 ) * nHeight ), aCoors[ 2 ], cLine, oFont , nil, fColor )

               next

               if oFont != nil
                  oFont:end()
               end if

            end if

         end if

         ( dbfItems )->( dbSkip() )

      end while

   end if

   CLOSE ( dbfBmp   )
   CLOSE ( dbfBox   )
   CLOSE ( dbfItems )

Return ( lOpenFiles )

//--------------------------------------------------------------------------//

FUNCTION PrintColum( cTipo, oInf, lPreview )

   local bTitle
   local bData
   local dbfDoc
	local	nSize
	local	cPicture
	local	nColFmt
	local nColor
	local	oFont
	local lShadow
	local lGird
   local nCol
   local nHeight
   local oError
   local oBlock
   local lOpenFiles  := .f.
   local lNewLine

   DEFAULT lPreview  := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "RCOLUM.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "RCOLUM", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RCOLUM.CDX" ) ADDITIVE

      lOpenFiles     := .t.

   RECOVER USING oError

      CLOSE ( dbfDoc )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles

      msgStop( "Imposible abrir todas las bases de datos de columnas." + CRLF + ErrorMessage( oError ) )

      Return ( lOpenFiles )

   end if

	/*
   Columnas desde el fichero externo-------------------------------------------
	*/

   if ( dbfDoc )->( dbSeek( cTipo ) )

      while ( dbfDoc )->Codigo == cTipo .and. !( dbfDoc )->( eof() )

         if !Empty( ( dbfDoc )->cTitulo )
            bTitle      := { bRetTitle( dbfDoc ) }
         else
            bTitle      := nil
         end if

         /*
         Evaluamos el datos si no es modo preview------------------------------
         */

         if lPreview

            bData       := ""
            cPicture    := ""

         else

            if !Empty( ( dbfDoc )->cFichero )
               bData    := Rtrim( &( ( dbfDoc )->cFichero ) ) + "->"
            else
               bData    := ""
            end if

            bData       += Rtrim( ( dbfDoc )->cCampo )
            bData       := { bChar2Block( bData ) }

            cPicture    := { bChar2Block( Rtrim( ( dbfDoc )->cMascara ) ) }

         end if

         if !( dbfDoc )->lAutPos
            nCol        := ( ( dbfDoc )->nColumna * 10 * oInf:oDevice:nHorzRes() / oInf:oDevice:nHorzSize() )
            nCol        -= oInf:oDevice:nYoffset
         else
            nCol        := 0
         end if

         if !Empty( ( dbfDoc )->nHeight )
            nHeight     := ( dbfDoc )->nHeight / 2.54 * oInf:nLogPixY
            nSize       := ( dbfDoc )->nSize   / 2.54 * oInf:nLogPixX
         else
            nSize       := ( dbfDoc )->nSize
         end if

         nColor         := ( dbfDoc )->fColor
         lShadow        := ( dbfDoc )->lShadow
         lGird          := ( dbfDoc )->lGird
         lNewLine       := ( dbfDoc )->lNewLine

         /*
         Diferencias con clase column------------------------------------------
         */

         do case
         case ( dbfDoc )->nAjuste == 1
            nColFmt     := 1
         case ( dbfDoc )->nAjuste == 2
            nColFmt     := 3
         case ( dbfDoc )->nAjuste == 3
            nColFmt     := 2
         end case

         /*
         Tipos de letra
         */

         if !empty( ( dbfDoc )->fFaceName )
            oFont       := TFont():New( Rtrim( ( dbfDoc )->fFaceName ), 0, ( dbfDoc )->fWidth,, ( dbfDoc )->fItalic,,,, ( dbfDoc )->fStrikeOut,,,,,,, oInf:oDevice )
         else
            oFont       := TFont():New( "Arial", 0, -10,,.T.,,,,,,,,,,, oInf:oDevice )
         end if

         RptAddOColumn( bTitle, nCol, bData, nSize, cPicture, oFont, oFont, oFont, .f., , nColFmt, lShadow, lGird, lNewLine, , nColor, nHeight )

         ( dbfDoc )->( dbSkip() )

      end while

   else

      RptAddOColumn()

   end if

   CLOSE ( dbfDoc )

Return ( lOpenFiles )

//-----------------------------------------------------------------------//

FUNCTION mkDocs( cPath, lAppend, cPathOld, oMeter, lReindex, cVia )

   local oBlock
   local oError
   local dbfDocs
   local lMakeFiles  := .t.

   DEFAULT lAppend   := .f.
   DEFAULT lReindex  := .t.
   DEFAULT cVia      := cDriver()

   if oMeter != nil
		oMeter:cText	:= "Generando Bases"
      SysRefresh()
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !lExistTable( cPath + "RDocumen.Dbf", cVia )
      dbCreate( cPath + "RDocumen.Dbf", aSqlStruct( aItmDoc ), ( cVia ) )
   end if

   if !lExistTable( cPath + "RItems.Dbf", cVia )
      dbCreate( cPath + "RItems.Dbf", aSqlStruct( aItmItm ), ( cVia ) )
   end if

   if !lExistTable( cPath + "RColum.Dbf", cVia )
      dbCreate( cPath + "RColum.Dbf", aSqlStruct( aItmCol ), ( cVia ) )
   end if

   if !lExistTable( cPath + "RBitmap.Dbf", cVia )
      dbCreate( cPath + "RBitmap.Dbf", aSqlStruct( aItmBmp ), ( cVia ) )
   end if

   if !lExistTable( cPath + "RBox.Dbf", cVia )
      dbCreate( cPath + "RBox.Dbf", aSqlStruct( aItmBox ), ( cVia ) )
   end if

   if lAppend

      if lIsDir( cPathOld )

         if lExistTable( cPathOld + "RDOCUMEN.DBF" )
            dbUseArea( .t., ( cVia ), cPath + "RDOCUMEN.DBF", cCheckArea( "RDOCUMEN", @dbfDocs ), .f. )
            ( dbfDocs )->( __dbApp( cPathOld + "RDOCUMEN.DBF" ) )
            ( dbfDocs )->( dbCloseArea() )
         end if

         if lExistTable( cPathOld + "RITEMS.DBF" )
            dbUseArea( .t., ( cVia ), cPath + "RITEMS.DBF", cCheckArea( "RITEMS", @dbfDocs ), .f. )
            ( dbfDocs )->( __dbApp( cPathOld + "RITEMS.DBF" ) )
            ( dbfDocs )->( dbCloseArea() )
         end if

         if lExistTable( cPathOld + "RCOLUM.DBF" )
            dbUseArea( .t., ( cVia ), cPath + "RCOLUM.DBF", cCheckArea( "RCOLUM", @dbfDocs ), .f. )
            ( dbfDocs )->( __dbApp( cPathOld + "RCOLUM.DBF" ) )
            ( dbfDocs )->( dbCloseArea() )
         end if

         if lExistTable( cPathOld + "RBITMAP.DBF" )
            dbUseArea( .t., ( cVia ), cPath + "RBITMAP.DBF", cCheckArea( "RBITMAP", @dbfDocs ), .f. )
            ( dbfDocs )->( __dbApp( cPathOld + "RBITMAP.DBF" ) )
            ( dbfDocs )->( dbCloseArea() )
         end if

         if lExistTable( cPathOld + "RBOX.DBF" )
            dbUseArea( .t., ( cVia ), cPath + "RBOX.DBF", cCheckArea( "RBOX", @dbfDocs ), .f. )
            ( dbfDocs )->( __dbApp( cPathOld + "RBOX.DBF" ) )
            ( dbfDocs )->( dbCloseArea() )
         end if

      else

         if lExistTable( cPatDat() + "RDOCUMEN.DBF" )
            dbUseArea( .t., ( cVia ), cPath + "RDOCUMEN.DBF", cCheckArea( "RDOCUMEN", @dbfDocs ), .f. )
            ( dbfDocs )->( __dbApp( cPatDat() + "RDOCUMEN.DBF" ) )
            ( dbfDocs )->( dbCloseArea() )
         end if

         if lExistTable( cPatDat() + "RITEMS.DBF" )
            dbUseArea( .t., ( cVia ), cPath + "RITEMS.DBF", cCheckArea( "RITEMS", @dbfDocs ), .f. )
            ( dbfDocs )->( __dbApp( cPatDat() + "RITEMS.DBF" ) )
            ( dbfDocs )->( dbCloseArea() )
         end if

         if lExistTable( cPatDat() + "RCOLUM.DBF" )
            dbUseArea( .t., ( cVia ), cPath + "RCOLUM.DBF", cCheckArea( "RCOLUM", @dbfDocs ), .f. )
            ( dbfDocs )->( __dbApp( cPatDat() + "RCOLUM.DBF" ) )
            ( dbfDocs )->( dbCloseArea() )
         end if

         if lExistTable( cPatDat() + "RBITMAP.DBF" )
            dbUseArea( .t., ( cVia ), cPath + "RBITMAP.DBF", cCheckArea( "RBITMAP", @dbfDocs ), .f. )
            ( dbfDocs )->( __dbApp( cPatDat() + "RBITMAP.DBF" ) )
            ( dbfDocs )->( dbCloseArea() )
         end if

         if lExistTable( cPatDat() + "RBOX.DBF" )
            dbUseArea( .t., ( cVia ), cPath + "RBOX.DBF", cCheckArea( "RBOX", @dbfDocs ), .f. )
            ( dbfDocs )->( __dbApp( cPatDat() + "RBOX.DBF" ) )
            ( dbfDocs )->( dbCloseArea() )
         end if

      end if

   end if

   RECOVER USING oError

      lMakeFiles     := .f.

      msgStop( "Imposible crear todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lMakeFiles
      lMakeFiles     := rxDocs( cPath, oMeter, cVia )
   end if

RETURN ( lMakeFiles )

//--------------------------------------------------------------------------//

FUNCTION rxDocs( cPath, oMeter, cVia )

   local cDbf
   local oBlock
   local oError
   local lReindexFiles  := .t.

   DEFAULT cPath        := cPatEmp()
   DEFAULT cVia         := cDriver()

   fEraseIndex( cPath + "RDOCUMEN.CDX" )
   fEraseIndex( cPath + "RITEMS.CDX" )
   fEraseIndex( cPath + "RCOLUM.CDX" )
   fEraseIndex( cPath + "RBITMAP.CDX" )
   fEraseIndex( cPath + "RBOX.CDX" )

   if !lExistTable( cPath + "RDOCUMEN.DBF" )
      dbCreate( cPath + "RDOCUMEN.DBF", aSqlStruct( aItmDoc ), ( cVia ) )
   end if

   if !lExistTable( cPath + "RITEMS.DBF" )
      dbCreate( cPath + "RITEMS.DBF", aSqlStruct( aItmItm ), ( cVia ) )
   end if

   if !lExistTable( cPath + "RCOLUM.DBF" )
      dbCreate( cPath + "RCOLUM.DBF", aSqlStruct( aItmCol ), ( cVia ) )
   end if

   if !lExistTable( cPath + "RBITMAP.DBF" )
      dbCreate( cPath + "RBITMAP.DBF", aSqlStruct( aItmBmp ), ( cVia ) )
   end if

   if !lExistTable( cPath + "RBOX.DBF" )
      dbCreate( cPath + "RBOX.DBF", aSqlStruct( aItmBox ), ( cVia ) )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., ( cVia ), cPath + "RDOCUMEN.DBF", cCheckArea( "RDOCUMEN", @cDbf ), .f. )
   if !( cDbf )->( neterr() )
      ( cDbf )->( __dbPack() )

      ( cDbf )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cDbf )->( ordCreate( cPath + "RDOCUMEN.CDX", "Codigo", "Codigo", {|| Field->Codigo }, ) )

      ( cDbf )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cDbf )->( ordCreate( cPath + "RDOCUMEN.CDX", "cTipo", "cTipo + Codigo", {|| Field->cTipo + Field->Codigo }, ) )

      ( cDbf )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cDbf )->( ordCreate( cPath + "RDOCUMEN.CDX", "cDescrip", "cDescrip", {|| Field->cDescrip }, ) )

      ( cDbf )->( dbCloseArea() )
   end if

   dbUseArea( .t., ( cVia ), cPath + "RITEMS.DBF", cCheckArea( "RITEMS", @cDbf ), .f. )
   if !( cDbf )->( neterr() )
      ( cDbf )->( __dbPack() )

      ( cDbf )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cDbf )->( ordCreate( cPath + "RITEMS.CDX", "Codigo", "Codigo + STR( NLINEA ) + STR( NCOLUMNA )", {|| Field->CODIGO + STR( Field->NLINEA ) + STR( Field->NCOLUMNA ) }, ) )

      ( cDbf )->( dbCloseArea() )
   end if

   dbUseArea( .t., ( cVia ), cPath + "RCOLUM.DBF", cCheckArea( "RCOLUM", @cDbf ), .f. )
   if !( cDbf )->( neterr() )
      ( cDbf )->( __dbPack() )

      ( cDbf )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cDbf )->( ordCreate( cPath + "RCOLUM.CDX", "Codigo", "Codigo", {|| Field->CODIGO }, ) )

      ( cDbf )->( dbCloseArea() )
   end if

   dbUseArea( .t., ( cVia ), cPath + "RBITMAP.DBF", cCheckArea( "RBITMAP", @cDbf ), .f. )
   if !( cDbf )->( neterr() )
      ( cDbf )->( __dbPack() )

      ( cDbf )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cDbf )->( ordCreate( cPath + "RBITMAP.CDX", "Codigo", "Codigo", {|| Field->CODIGO }, ) )

      ( cDbf )->( dbCloseArea() )
   end if

   dbUseArea( .t., ( cVia ), cPath + "RBOX.DBF", cCheckArea( "RBOX", @cDbf ), .f. )
   if !( cDbf )->( neterr() )
      ( cDbf )->( __dbPack() )

      ( cDbf )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( cDbf )->( ordCreate( cPath + "RBOX.CDX", "CODIGO", "CODIGO + STR( NROWTOP ) + STR( NCOLTOP )", {|| Field->CODIGO + STR( Field->NROWTOP ) + STR( Field->NCOLTOP ) } ) )

      ( cDbf )->( dbCloseArea() )
   end if

   RECOVER USING oError

      lReindexFiles     := .f.

      msgStop( "Imposible reindexar todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lReindexFiles )

//--------------------------------------------------------------------------//

STATIC FUNCTION ActTitle( nKey, nFlags, oGet, nMode, oDlg )

	oGet:assign()
	oDlg:cTitle( "Documento : " + rtrim( oGet:varGet() ) + Chr( nKey ) )

RETURN NIL

//--------------------------------------------------------------------------//

function lPaintDoc( oDlg, aCoors, aCols )

return .t.

//--------------------------------------------------------------------------//

function lPntDoc( oDlg, aCoors, aCols )

   local hSombra
   local hFondo
   local hHoja
   local hPen
   local hPen1
   local ny
   local nyy
   local ny1
   local ny2
   local nx
   local nxx
   local nx1
   local nx2
   local aVars
   local nEscala  := .1
   local nAltFon  := 280
   local nAncFon  := 306

   if aCoors   != NIL

      aVars    := aClone( aCoors )

      aVars[ 1 ] = aVars[ 1 ] / nEscala
      aVars[ 2 ] = aVars[ 2 ] / nEscala

      oDlg:GetDc()

      hSombra = CreateSolidBrush( GetSysColor( 16 ) )
      hFondo  = CreateSolidBrush( GetSysColor( 15 ) )
      hHoja   = CreateSolidBrush( CLR_WHITE )

      hPen    = CreatePen( PS_DOT  , 2, CLR_BLUE )
      hPen1   = CreatePen( PS_SOLID, 1, CLR_BLUE )

      ny      = ( nAltFon / 2 ) - ( aVars[ 1 ] / 2 ) + 8 // Altura
      nx      = ( nAncFon / 2 ) - ( aVars[ 2 ] / 2 ) + 8 // Anchura
      nxx     = nx + aVars[ 2 ]
      nyy     = ny + aVars[ 1 ]

      FillRect( oDlg:hDC, { 7, 7, 18 + nAltFon , 18 + nAncFon }, hFondo )
      FillRect( oDlg:hDC, { ny, nx, ny + aVars[ 1 ], nx + aVars[ 2 ] }, hHoja )
      FillRect( oDlg:hDC, { ny + aVars[ 1 ], nx + 10, ny + aVars[ 1 ] + 10, nx + aVars[ 2 ] + 10 }, hSombra ) // Horizontal
      FillRect( oDlg:hDC, { ny + 10, nx + aVars[ 2 ], ny + aVars[ 1 ] + 10, nx + aVars[ 2 ] + 10 }, hSombra ) // Vertical

      /*
      Cuadro interior
      */

      nx1     = nx + ( aCols[ 1 ] / nEscala )
      ny1     = ny + ( aCols[ 2 ] / nEscala )
      nx2     = nx + aVars[ 2 ] - ( aCols[ 3 ] / nEscala )
      ny2     = ny + aVars[ 1 ] - ( aCols[ 4 ] / nEscala )

      Rectangle( oDlg:hDC, ny1, nx1, ny2, nx2, hPen )

      DeleteObject( hSombra )
      DeleteObject( hFondo )
      DeleteObject( hHoja )
      DeleteObject( hPen )
      DeleteObject( hPen1 )

      /*
      Fin del dibujo
      */

      oDlg:ReleaseDc()

   endif

return .t.

//--------------------------------------------------------------------------//

/*STATIC FUNCTION TreeFldDoc( aGet, oCbxAjust, dbfFldDoc, cTipDoc )

	local oDlg
	local oBrw
	local aGet1
	local cGet1
	local oCbxOrd
   local cCbxOrd     := "Código"
   local oTree       := aItmPedPrv()

	( dbfFldDoc )->( dbGoTop() )

	DEFINE DIALOG oDlg RESOURCE "HELPENTRY"

		REDEFINE GET aGet1 VAR cGet1;
			ID 		104 ;
         COLOR    CLR_GET ;
			OF 		oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    { "Codigo" } ;
			OF oDlg

      REDEFINE LISTBOX oBrw ;
         FIELDS ;
         HEADERS "", "", "Campos";
         ID       105 ;
         OF       oDlg

         oBrw:bKeyChar := { | nKey, nFlags | iif( nKey == 13, ( oBrw:Cargo:Toggle(), oBrw:Refresh() ), ) }

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBrw:SetTree( oTree ), oBrw:refresh() )

   oTree := nil

RETURN ( oDlg:nResult == IDOK )*/

//---------------------------------------------------------------------------//

/*FUNCTION AppDoc( cEmpDat, cPatEmp, oMet )

   local oBlock
   local oError
   local cDbfFld
   local cDbfCol

   if Empty( cEmpDat ) .or. ;
      Empty( cPatEmp )
      Return nil
   end if

   feraseTable( cEmpDat + "WDOCFLD.DBF" )
   feraseIndex( cEmpDat + "WDOCFLD.CDX" )
   feraseTable( cEmpDat + "WDOCCOL.DBF" )
   feraseIndex( cEmpDat + "WDOCCOL.CDX" )

   /*
   Creamos una nueva base de datos---------------------------------------------
   */

/*   dbCreate( cEmpDat + "wDocFld.Dbf", aSqlStruct( aItmFld() ), cDriver() )

   dbCreate( cEmpDat + "wDocCol.Dbf", aSqlStruct( aItmCol() ), cDriver() )

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cEmpDat + "WDOCFLD.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "WFLDDOC", @cDbfFld ) )

      USE ( cEmpDat + "WDOCCOL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "WFLDCOL", @cDbfCol ) )

      /*
      Empezamos la carga de datos
      ----------------------------------------------------------------------------
      */

/*      AppDocItm( cDbfFld, "EM", { { "cCodEmp()", "C",  2, 0, "Código de la empresa", "", "", "" } } )
      AppDocItm( cDbfFld, "EM", { { "cNbrEmp()", "C", 45, 0, "Nombre de la empresa", "", "", "" } } )
      AppDocItm( cDbfFld, "EM", { { "cNifEmp()", "C", 15, 0, "Nif de la empresa",    "", "", "" } } )
      AppDocItm( cDbfFld, "EM", { { "cAdmEmp()", "C", 35, 0, "Administrador",        "", "", "" } } )
      AppDocItm( cDbfFld, "EM", { { "cDomEmp()", "C", 35, 0, "Domicilio",            "", "", "" } } )
      AppDocItm( cDbfFld, "EM", { { "cPobEmp()", "C", 35, 0, "Población",            "", "", "" } } )
      AppDocItm( cDbfFld, "EM", { { "cPrvEmp()", "C", 30, 0, "Provincia",            "", "", "" } } )
      AppDocItm( cDbfFld, "EM", { { "cCdpEmp()", "C",  5, 0, "Código postal",        "", "", "" } } )
      AppDocItm( cDbfFld, "EM", { { "cTlfEmp()", "C", 15, 0, "Teléfono",             "", "", "" } } )
      AppDocItm( cDbfFld, "EM", { { "cFaxEmp()", "C", 15, 0, "Fax",                  "", "", "" } } )
      AppDocItm( cDbfFld, "EM", { { "cEmaEmp()", "C", 60, 0, "E-mail",               "", "", "" } } )
      AppDocItm( cDbfFld, "EM", { { "cWebEmp()", "C",180, 0, "Web",                  "", "", "" } } )

      AppDocItm( cDbfFld, "PR", aItmPrv()    )     // Proveedores
      AppDocItm( cDbfFld, "CL", aItmCli()    )     // Clientes
      AppDocItm( cDbfFld, "AR", aItmArt()    )     // Clientes

      AppDocItm( cDbfFld, "AL", aItmAlm()    )     // Almacen
      AppDocItm( cDbfFld, "PG", aItmFPago()  )     // Formas de pago
      AppDocItm( cDbfFld, "DV", aItmDiv()    )     // Divisas
      AppDocItm( cDbfFld, "AG", aItmAge()    )     // Clientes
      AppDocItm( cDbfFld, "OB", aItmObr()    )     // Obras
      AppDocItm( cDbfFld, "OB", aCalObrCli() )     // Campos por defecto de obras
      AppDocItm( cDbfFld, "RT", aItmRut()    )     // Rutas

      AppDocItm( cDbfFld, "PP", aItmPedPrv() )     // Pedido a proveedores
      AppDocItm( cDbfFld, "PP", aCalPedPrv() )     // Pedido a proveedores

      AppDocItm( cDbfFld, "AP", aItmAlbPrv() )     // Albaranes a proveedores cabeceras
      AppDocItm( cDbfFld, "AP", aCalAlbPrv() )     // Albaranes a proveedores cabeceras

      AppDocItm( cDbfFld, "AX", aColAlbPrv() )     // Albaranes a proveedores lineas
      AppDocItm( cDbfFld, "AX", aCocAlbPrv() )     // Albaranes a proveedores lineas

      AppDocItm( cDbfFld, "FP", aItmFacPrv() )     // Facturas a proveedores
      AppDocItm( cDbfFld, "FP", aCalFacPrv() )     // Facturas a proveedores

      AppDocItm( cDbfFld, "FX", aColFacPrv() )     // Facturas a proveedores
      AppDocItm( cDbfFld, "FX", aCocFacPrv() )     // Facturas a proveedores

      AppDocItm( cDbfFld, "RP", aItmRecPrv() )     // Recibo a proveedores

      AppDocItm( cDbfFld, "RC", aItmPreCli() )     // Presupuestos a clientes
      AppDocItm( cDbfFld, "RC", aCalPreCli() )     // Presupuestos a clientes

      AppDocItm( cDbfFld, "PC", aItmPedCli() )     // Pedidos a clientes
      AppDocItm( cDbfFld, "PC", aCalPedCli() )     // Pedidos a clientes

      AppDocItm( cDbfFld, "AC", aItmAlbCli() )     // Albaranes a clientes
      AppDocItm( cDbfFld, "AC", aCalAlbCli() )     // Albaranes a clientes

      AppDocItm( cDbfFld, "FC", aItmFacCli() )     // Facturas a clientes
      AppDocItm( cDbfFld, "FC", aCalFacCli() )     // Facturas a clientes

      AppDocItm( cDbfFld, "FR", aItmFacRec() )     // Facturas rectificativas
      AppDocItm( cDbfFld, "FR", aCalFacRec() )     // Facturas rectificativas

      AppDocItm( cDbfFld, "TC", aItmAntCli() )     // Anticipos a clientes
      AppDocItm( cDbfFld, "TC", aCalAntCli() )     // Anticipos a clientes

      AppDocItm( cDbfFld, "RF", aItmRecCli() )     // Recibos de clientes
      AppDocItm( cDbfFld, "RF", aCalRecCli() )     // Recibos de clientes

      AppDocItm( cDbfFld, "EP", aPedCliPgo() )     // Entregas a cuenta en pedidos

      AppDocItm( cDbfFld, "EA", aItmAlbPgo() )     // Entregas a cuenta en albaranes

      AppDocItm( cDbfFld, "DA", aItmDepAge() )     // Depósitos de almacén
      AppDocItm( cDbfFld, "DA", aCalDepAge() )     // Depósitos de almacén

      AppDocItm( cDbfFld, "EX", aItmExtAge() )     // Existecias de almacén
      AppDocItm( cDbfFld, "EX", aCalExtAge() )     // Existecias de almacén

      /*
      Columnas--------------------------------------------------------------------
      */

/*      AppDocItm( cDbfCol, "PP", aColPedPrv() )     // Pedido a proveedores
      AppDocItm( cDbfCol, "PP", aCocPedPrv() )     // Pedido a proveedores

      AppDocItm( cDbfCol, "AP", aColAlbPrv() )     // Pedido a proveedores
      AppDocItm( cDbfCol, "AP", aCocAlbPrv() )     // Pedido a proveedores

      AppDocItm( cDbfCol, "FP", aColFacPrv() )     // Facturas a proveedores
      AppDocItm( cDbfCol, "FP", aCocFacPrv() )     // Facturas a proveedores

      AppDocItm( cDbfCol, "RC", aColPreCli() )     // Presupuestos a clientes
      AppDocItm( cDbfCol, "RC", aCocPreCli() )     // Presupuestos a clientes

      AppDocItm( cDbfCol, "PC", aColPedCli() )     // Pedidos a clientes
      AppDocItm( cDbfCol, "PC", aCocPedCli() )     // Pedidos a clientes

      AppDocItm( cDbfCol, "AC", aColAlbCli() )     // Albaranes a clientes
      AppDocItm( cDbfCol, "AC", aCocAlbCli() )     // Albaranes a clientes

      AppDocItm( cDbfCol, "FC", aColFacCli() )     // Facturas a clientes
      AppDocItm( cDbfCol, "FC", aCocFacCli() )     // Facturas a clientes

      AppDocItm( cDbfCol, "FR", aColFacRec() )     // Facturas rectificativas
      AppDocItm( cDbfCol, "FR", aCocFacRec() )     // Facturas rectificativas

      AppDocItm( cDbfCol, "TC", aColAntCli() )     // Anticipos a clientes

      AppDocItm( cDbfCol, "DA", aColDepAge() )     // Depósitos de almacén
      AppDocItm( cDbfCol, "DA", aCocDepAge() )     // Depósitos de almacén

      AppDocItm( cDbfCol, "EX", aColExtAge() )     // Existecias de almacén
      AppDocItm( cDbfCol, "EX", aCocExtAge() )     // Existecias de almacén

      /*
      Objetos---------------------------------------------------------------------
      */

/*      with object ( TTrans():Create( cPatEmp() ) )
         :DefineFiles()
         AppObjItm( cDbfFld, "TR", :oDbf, "( cDbfTrn )"  )                // Transportes
         :End()
      end with

      with object ( TRemMovAlm():Create( cPatEmp ) )
         ?"1"
         AppObjItm( cDbfFld, "RM", :DefineFiles(),      "( cDbf )"     )  // Remesas de movimientos
         ?"2"
         AppObjItm( cDbfCol, "RM", :DefineDetails(),    "( cDbfCol )"  )  // Remesas de movimientos
         AppDocItm( cDbfCol, "RM", :DefineCalculate() )  // Remesas de movimientos
         :End()
      end with

      with object ( TProduccion():Create( cPatEmp ) )
         AppObjItm( cDbfFld, "PO", :DefineFiles(),      "( cDbf )"     )  // Partes de producción
         AppObjItm( cDbfCol, "PO", :DefineTemporal(),   "( cDbfCol )"  )  // líneas de partes de producción
         AppDocItm( cDbfFld, "PO", :DefineCalculate(), .t. )              // Campos calculados
         :End()
      end with

   /*RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de documentos' )

   END SEQUENCE

   ErrorBlock( oBlock )*/

/*   CLOSE ( cDbfFld )
   CLOSE ( cDbfCol )

Return nil*/

//--------------------------------------------------------------------------//

/*FUNCTION AppDocItm( dbfDocFld, cCodDoc, aBase1 )

   local n
   local nLen

   if Empty( cCodDoc )
      return .f.
   end if

   if Empty( aBase1 )
      return .f.
   end if

   for n := 1 to len( aBase1 )

      nLen  := len( aBase1[ n ] )

      if nLen >= 5 .and. !Empty( aBase1[ n, 5 ] )

         ( dbfDocFld )->( dbAppend() )

         ( dbfDocFld )->cTipDoc     := cCodDoc
         ( dbfDocFld )->cFldDoc     := aBase1[ n, 1 ]
         ( dbfDocFld )->nAliDoc     := if( aBase1[ n, 2 ] == "N", 3, 1 )    // Nuevos
         ( dbfDocFld )->nSizDoc     := aBase1[ n, 3 ] + aBase1[ n, 4 ]      // Nuevos
         ( dbfDocFld )->cDesDoc     := aBase1[ n, 5 ]

         if nLen >= 7
            ( dbfDocFld )->cMasDoc  := aBase1[ n, 6 ]
            ( dbfDocFld )->cConDoc  := aBase1[ n, 7 ]
         end if

         if nLen >= 8
            ( dbfDocFld )->cAreDoc  := aBase1[ n, 8 ]
         end if

         if nLen >= 9
            ( dbfDocFld )->lBitmap  := aBase1[ n, 9 ]
         end if

      end if

   next

RETURN NIL*/

//---------------------------------------------------------------------------//

FUNCTION AppDocCal( dbfDocFld, cCodDoc, aBase1 )

   local n

   if cCodDoc == nil
      return .f.
   end if

   if aBase1 == nil
      return .f.
   end if

   FOR n := 1 TO len( aBase1 )

      ( dbfDocFld )->( dbAppend() )
      ( dbfDocFld )->CTIPDOC := cCodDoc
      ( dbfDocFld )->CFLDDOC := aBase1[ n, 1 ]
      ( dbfDocFld )->CDESDOC := aBase1[ n, 5 ]
      ( dbfDocFld )->CMASDOC := aBase1[ n, 6 ]
      ( dbfDocFld )->CCONDOC := aBase1[ n, 7 ]
      ( dbfDocFld )->NALIDOC := if( aBase1[ n, 2 ] == "N", 3, 1 )    // Nuevos
      ( dbfDocFld )->NSIZDOC := aBase1[ n, 3 ] + aBase1[ n, 4 ]      // Nuevos

   NEXT

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION AppObjItm( dbfDocFld, cCodDoc, oDbf, cArea )

   local n

   if cCodDoc == nil
      return .f.
   end if

   for n := 1 to len( oDbf:aTField )

      if !Empty( oDbf:aTField[ n ]:cComment ) .and. !oDbf:aTField[ n ]:lHide

         ( dbfDocFld )->( dbAppend() )

         ( dbfDocFld )->cTipDoc     := cCodDoc

         if oDbf:aTField[ n ]:lCalculate .and. Valtype( oDbf:aTField[ n ]:bSetGet ) == "C"
            ( dbfDocFld )->cFldDoc  := oDbf:aTField[ n ]:bSetGet
         else
            ( dbfDocFld )->cFldDoc  := oDbf:aTField[ n ]:cName
         end if

         ( dbfDocFld )->cDesDoc     := oDbf:aTField[ n ]:cComment
         ( dbfDocFld )->nAliDoc     := if( oDbf:aTField[ n ]:cType == "N", 3, 1 )         // Nuevos
         ( dbfDocFld )->nSizDoc     := oDbf:aTField[ n ]:nLen + oDbf:aTField[ n ]:nDec    // Nuevos
         ( dbfDocFld )->cMasDoc     := if( ValType( oDbf:aTField[ n ]:cPict ) == "B", Eval( oDbf:aTField[ n ]:cPict ), oDbf:aTField[ n ]:cPict )
         ( dbfDocFld )->cConDoc     := ""

         if cArea != nil
            ( dbfDocFld )->cAreDoc  := cArea
         end if

      end if

   next

RETURN NIL

//---------------------------------------------------------------------------//

/*STATIC FUNCTION WizItem( aTmp, aGet, dbfItm, oBrw, cTipDoc, bValid, nMode, lLiteral )

	local oDlg
   local oBrwFld
   local oBrwTbl
   local oBtnPrv
   local oBtnNxt
   local oPages
   local aItm
   local oCbxAjust
	local cCbxAjust
   local aFont       := aGetFont( oWnd() )
   local aSizes      := { " 6", " 7", " 8", " 9", "10", "11", "12", "13", "14", "16", "18", "20", "22", "24", "26", "28", "36", "48", "72" }
   local oEstilo
   local cEstilo     := "Normal"
   local aEstilo     := { "Normal", "Cursiva", "Negrita", "Negrita Cursiva" }

   aTmp[ iCODIGO   ] := ( dbfDoc )->CODIGO
   aTmp[ iLLITERAL ] := .f.
   aTmp[ iFFACENAME] := "Arial"
   aTmp[ iFWIDTH   ] := " 8"

   do case
      case cTipDoc == "PP"
         aItm        := aDocPedPrv()
      case cTipDoc == "AP"
         aItm        := aDocAlbPrv()
      case cTipDoc == "FP"
         aItm        := aDocFacPrv()
      case cTipDoc == "RP"
         aItm        := aDocRecPrv()
      case cTipDoc == "RC"
         aItm        := aDocPreCli()
      case cTipDoc == "PC"
         aItm        := aDocPedCli()
      case cTipDoc == "AC"
         aItm        := aDocAlbCli()
      case cTipDoc == "FC"
         aItm        := aDocFacCli()
      case cTipDoc == "FR"
         aItm        := aDocFacRec()
      case cTipDoc == "RF"
         aItm        := aDocRecCli()
      case cTipDoc == "RM"
         aItm        := aDocRemMov()
      case cTipDoc == "TC"
         aItm        := aDocAntCli()
      case cTipDoc == "EP"
         aItm        := aDocPedCli( .t. )
      case cTipDoc == "EA"
         aItm        := aDocAlbCli( .t. )
      case cTipDoc == "DA"
         aItm        := aDocDepAge()
      case cTipDoc == "EX"
         aItm        := aDocExtAge()
      case cTipDoc == "PO"
         aItm        := aDocPro()
      otherwise
         aItm        := { {"", "" } }
   end case

   DEFINE DIALOG oDlg RESOURCE "WIZ_ITEMS" TITLE "Asistente para añadir campos"

      REDEFINE PAGES oPages ;
         ID       100 ;
         OF       oDlg ;
         DIALOGS  "WIZ_ITEMS1", "WIZ_ITEMS2"

      /*
      Primera caja de dialogo--------------------------------------------------

      REDEFINE LISTBOX oBrwTbl ;
         FIELDS   aItm[ oBrwTbl:nAt, 1 ] ;
         HEAD     "Tabla";
         SIZES    100;
         ID       90 ;
         OF       oPages:aDialogs[ 1 ]

      oBrwTbl:SetArray( aItm )
      oBrwTbl:bChange   := {||   ( dbfFldDoc )->( OrdScope( 0, aItm[ oBrwTbl:nAt, 2 ] ) ),;
                                 ( dbfFldDoc )->( OrdScope( 1, aItm[ oBrwTbl:nAt, 2 ] ) ),;
                                 ( dbfFldDoc )->( dbGoTop() ),;
                                 oBrwFld:Refresh() }

      REDEFINE LISTBOX oBrwFld ;
         FIELDS   ( dbfFldDoc )->cDesDoc;
         SIZES    300;
         HEAD     "Campo";
         ALIAS    ( dbfFldDoc );
         ID       100 ;
         OF       oPages:aDialogs[ 1 ]

      /*
      Segunda caja de dialogo--------------------------------------------------

      REDEFINE GET aGet[ iCLITERAL ] VAR aTmp[ iCLITERAL ];
         UPDATE ;
         ID       70 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE GET aGet[ cCCAMPO ] VAR aTmp[ cCCAMPO ] ;
         UPDATE ;
         ID       80 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE GET aGet[ cCFICHERO ] VAR aTmp[ cCFICHERO ] ;
         UPDATE ;
         ID       90 ;
         OF       oPages:aDialogs[ 2 ]

		REDEFINE GET aGet[ iNLINEA ] VAR aTmp[ iNLINEA ];
			SPINNER ;
			ON UP		aGet[ iNLINEA ]:cText( aGet[ iNLINEA ]:Value + .1 ) ;
			ON DOWN	aGet[ iNLINEA ]:cText( aGet[ iNLINEA ]:Value - .1 ) ;
         PICTURE  "@E 9,999.99" ;
         ID       100 ;
         OF       oPages:aDialogs[ 2 ]

		REDEFINE GET aGet[ iNCOLUMNA ] VAR aTmp[ iNCOLUMNA ] ;
			SPINNER ;
			ON UP		aGet[ iNCOLUMNA ]:cText( aGet[ iNCOLUMNA ]:Value + .1 ) ;
			ON DOWN	aGet[ iNCOLUMNA ]:cText( aGet[ iNCOLUMNA ]:Value - .1 ) ;
         PICTURE  "@E 9,999.99" ;
         ID       110 ;
         OF       oPages:aDialogs[ 2 ]

		REDEFINE COMBOBOX oCbxAjust VAR cCbxAjust ;
         ITEMS    { "Izquierda", "Centro", "Derecha" } ;
         BITMAPS  { "ALIGN_LEFT", "ALIGN_CENTER", "ALIGN_RIGHT" } ;
         ID       120 ;
         OF       oPages:aDialogs[ 2 ]

		REDEFINE GET aGet[ iNSIZE ] VAR aTmp[ iNSIZE ] ;
			SPINNER ;
			PICTURE "@E 9,999" ;
         ID       130 ;
         OF       oPages:aDialogs[ 2 ]

		REDEFINE GET aGet[ iCMASCARA ] VAR aTmp[ iCMASCARA ] ;
         ID       140 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE COMBOBOX aGet[ iFFACENAME] VAR aTmp[ iFFACENAME] ;
         ID       150 ;
         ITEMS    aFont ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE COMBOBOX aGet[ iFWIDTH ] VAR aTmp[ iFWIDTH ] ;
         ID       160 ;
         ITEMS    aSizes ;
         OF       oPages:aDialogs[2]

      REDEFINE COMBOBOX oEstilo VAR cEstilo ;
         ID       170 ;
         ITEMS    aEstilo ;
         OF       oPages:aDialogs[2]

      REDEFINE GET aGet[iLCONDICION] VAR aTmp[iLCONDICION] ;
         ID       180 ;
         OF       oPages:aDialogs[ 2 ]

      /*
      Botones de dialogos------------------------------------------------------

      REDEFINE BUTTON oBtnPrv ;
         ID       500 ;
			OF 		oDlg ;
         ACTION   ( oPages:GoPrev(), SetWindowText( oBtnNxt:hWnd, 'Siguiente >' ), oBtnPrv:hide() )

      REDEFINE BUTTON oBtnNxt ;
         ID       501 ;
			OF 		oDlg ;
         ACTION   ( BtnNxt( oPages, aGet, aTmp, oBtnPrv, oBtnNxt, dbfFldDoc, oCbxAjust, cEstilo, oBrw, oDlg ) )

      REDEFINE BUTTON ;
         ID       502 ;
			OF 		oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg ON INIT ( oBtnPrv:hide() ) CENTER

   oBrw:refresh()

RETURN ( oDlg:nResult == IDOK )*/

//----------------------------------------------------------------------------//

/*static function BtnNxt( oPag, aGet, aTmp, oBtnPrv, oBtnNxt, dbfFldDoc, oCbxAjust, cEstilo, oBrw, oDlg )

   do case
   case oPag:nOption == 1

      aGet[ iCLITERAL   ]:cText( ( dbfFldDoc )->cDesDoc )
      aGet[ iCCAMPO     ]:cText( ( dbfFldDoc )->cFldDoc )
      aGet[ iCFICHERO   ]:cText( ( dbfFldDoc )->cAreDoc )
      aGet[ iCMASCARA   ]:cText( ( dbfFldDoc )->cMasDoc )
      aGet[ iLCONDICION ]:cText( ( dbfFldDoc )->cConDoc )
      aGet[ iNSIZE      ]:cText( ( dbfFldDoc )->nSizDoc )

      oCbxAjust:Set( ( dbfFldDoc )->nAliDoc )

      oBtnPrv:Show()
      SetWindowText( oBtnNxt:hWnd, 'Terminar' )
      oPag:GoNext()

   case oPag:nOption == 2

      aTmp[ iNAJUSTE    ]  := oCbxAjust:nAt
      aTmp[ iFITALIC    ]  := "Negrita" $ cEstilo
      aTmp[ iFSTRIKEOUT ]  := "Cursiva" $ cEstilo
      aTmp[ iFWIDTH     ]  := Val( aTmp[ iFWIDTH ] )

      WinGather( aTmp, aGet, dbfTmpItm, oBrw, APPD_MODE, nil, .f. )

      oDlg:end()

   end case

RETURN NIL*/

//----------------------------------------------------------------------------//

/*static function loaColDoc( aGet, aTmp )

   aGet[ cCTITULO  ]:cText( ( dbfColDoc )->CDESDOC )
   aGet[ cCCAMPO   ]:cText( ( dbfColDoc )->CFLDDOC )
   aGet[ cNSIZE    ]:cText( ( dbfColDoc )->NSIZDOC )
   aTmp[ cNCOLUMNA ] := -1

return .t.*/

//----------------------------------------------------------------------------//

/*STATIC FUNCTION WizColu( aTmp, aGet, dbfItm, oBrw, bWhen, bValid, nMode, lLiteral )

	local oDlg
   local oBtnPrv
   local oBtnNxt
   local oPages
   local oCbxAjust
	local cCbxAjust
   local cTipDoc     := ( dbfDoc )->cTipo
   local aFont       := aGetFont( oWnd() )
   local aSizes      := { " 6", " 7", " 8", " 9", "10", "11", "12", "13", "14", "16", "18", "20", "22", "24", "26", "28", "36", "48", "72" }
   local oEstilo
   local cEstilo     := "Normal"
   local aEstilo     := { "Normal", "Cursiva", "Negrita", "Negrita Cursiva" }

   aTmp[ cCODIGO   ] := ( dbfDoc )->Codigo
   aTmp[ cFFACENAME] := "Arial"

   if nMode == APPD_MODE
      aTmp[ cFWIDTH ]:= " 8"
   else
      aTmp[ cFWIDTH ]:= str( aTmp[ cFWIDTH ], 2 )
   end if

   ( dbfColDoc )->( OrdScope( 0, cTipDoc ) )
   ( dbfColDoc )->( OrdScope( 1, cTipDoc ) )
   ( dbfColDoc )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "WIZ_ITEMS" TITLE "Asistente para añadir columnas"

      REDEFINE PAGES oPages ;
         ID       100 ;
         OF       oDlg ;
         DIALOGS  "WIZ_COLU1", "WIZ_COLU2"

      /*
      Primera caja de dialogo--------------------------------------------------

      REDEFINE LISTBOX oBrw ;
         FIELDS   ;
                  ( dbfColDoc )->cDesDoc;
         HEAD     ;
                  "Campo";
         FIELDSIZES;
                  200;
         ALIAS    ( dbfColDoc );
         ID       100 ;
         OF       oPages:aDialogs[ 1 ]

         oBrw:bLDblClick   := {|| NxtBtn( oPages, aGet, aTmp, oBtnPrv, oBtnNxt, oCbxAjust, cEstilo, oBrw, oDlg ) }

      /*
      Segunda caja de dialogo--------------------------------------------------

      REDEFINE GET aGet[ cCTITULO ] VAR aTmp[ cCTITULO ];
         UPDATE ;
			ID 		110 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE GET aGet[ cCCAMPO ] VAR aTmp[ cCCAMPO ] ;
         UPDATE ;
         ID       120 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE GET aGet[ cCFICHERO ] VAR aTmp[ cCFICHERO ] ;
         UPDATE ;
         ID       125 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE CHECKBOX aGet[ cLAUTPOS ] VAR aTmp[ cLAUTPOS ] ;
         UPDATE ;
         ID       130 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE GET aGet[ cNCOLUMNA ] VAR aTmp[ cNCOLUMNA ] ;
         UPDATE ;
         SPINNER ;
         ON UP    aGet[ cNCOLUMNA ]:cText( aGet[ cNCOLUMNA ]:Value + .1 ) ;
         ON DOWN  aGet[ cNCOLUMNA ]:cText( aGet[ cNCOLUMNA ]:Value - .1 ) ;
         WHEN     !aTmp[ cLAUTPOS ] ;
         PICTURE  "@E 999.99" ;
         ID       140 ;
         OF       oPages:aDialogs[ 2 ]

		REDEFINE COMBOBOX oCbxAjust VAR cCbxAjust ;
         ITEMS    { "Izquierda", "Centro", "Derecha" } ;
         BITMAPS  { "ALIGN_LEFT", "ALIGN_CENTER", "ALIGN_RIGHT" } ;
         ID       150 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE GET aGet[ cNHEIGHT ] VAR aTmp[ cNHEIGHT ] ;
         UPDATE ;
         SPINNER ;
         ID       165 ;
         PICTURE  "@E 999.99" ;
         OF       oPages:aDialogs[ 2 ]

		REDEFINE GET aGet[ cNSIZE ] VAR aTmp[ cNSIZE ] ;
         UPDATE ;
         SPINNER ;
         ID       160 ;
         PICTURE  "@E 999.99" ;
         OF       oPages:aDialogs[ 2 ]

		REDEFINE CHECKBOX aTmp[ cLSHADOW ] ;
         UPDATE ;
         ID       170 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE CHECKBOX aTmp[ cLGIRD ] ;
         UPDATE ;
         ID       180 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE CHECKBOX aTmp[ cLNEWLINE ] ;
         UPDATE ;
         ID       175 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE GET aGet[ cCMASCARA   ] VAR aTmp[ cCMASCARA ] ;
         UPDATE ;
         ID       190 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE GET aGet[ cLCONDICION ] VAR aTmp[ cLCONDICION ] ;
         UPDATE ;
         ID       195 ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE COMBOBOX aGet[ cFFACENAME] VAR aTmp[ cFFACENAME] ;
         ID       200 ;
         ITEMS    aFont ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE COMBOBOX aGet[ cFWIDTH ] VAR aTmp[ cFWIDTH ] ;
         ID       210 ;
         ITEMS    aSizes ;
         OF       oPages:aDialogs[ 2 ]

      REDEFINE COMBOBOX oEstilo VAR cEstilo ;
         ID       220 ;
         ITEMS    aEstilo ;
         OF       oPages:aDialogs[ 2 ]

      /*
      Botones de dialogos------------------------------------------------------

      REDEFINE BUTTON oBtnPrv ;
         ID       500 ;
			OF 		oDlg ;
         ACTION   ( oPages:GoPrev(), SetWindowText( oBtnNxt:hWnd, 'Siguiente >' ), oBtnPrv:hide() )

      REDEFINE BUTTON oBtnNxt ;
         ID       501 ;
			OF 		oDlg ;
         ACTION   ( NxtBtn( oPages, aGet, aTmp, oBtnPrv, oBtnNxt, oCbxAjust, cEstilo, oBrw, oDlg ) )

      REDEFINE BUTTON ;
         ID       502 ;
			OF 		oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBtnPrv:hide() )

   ( dbfColDoc )->( OrdScope( 0, nil ) )
   ( dbfColDoc )->( OrdScope( 1, nil ) )

   oBrw:Refresh()

RETURN ( oDlg:nResult == IDOK )
*/
//----------------------------------------------------------------------------//

/*static function NxtBtn( oPag, aGet, aTmp, oBtnPrv, oBtnNxt, oCbxAjust, cEstilo, oBrw, oDlg )

   do case
   case oPag:nOption == 1

      aGeT[ cCFICHERO   ]:cText( ( dbfColDoc )->CAREDOC )
      aGet[ cCCAMPO     ]:cText( ( dbfColDoc )->CFLDDOC )
      aGet[ cLCONDICION ]:cText( ( dbfColDoc )->CCONDOC )

      aTmp[ cCLITERAL   ]  := ( dbfColDoc )->CDESDOC

      aTmp[ cLAUTPOS    ]  := .t.
      aGet[ cLAUTPOS    ]:Refresh()

      aGet[ cCTITULO    ]:cText( SubStr( ( dbfColDoc )->CDESDOC, 1, At( " ", ( dbfColDoc )->CDESDOC ) ) )
      aGet[ cNSIZE      ]:cText( ( dbfColDoc )->NSIZDOC )

      oCbxAjust:Set( ( dbfColDoc )->nAliDoc )

      if !( dbfColDoc )->lBitmap
         aGet[ cCMASCARA   ]:cText( ( dbfColDoc )->cMasDoc )
         aGet[ cNHEIGHT    ]:Hide()
      else
         aGet[ cNHEIGHT    ]:cText( ( dbfColDoc )->nSizDoc )
         aGet[ cNHEIGHT    ]:Show()
      end if

      oBtnPrv:Show()
      SetWindowText( oBtnNxt:hWnd, 'Terminar' )
      oPag:GoNext()

   case oPag:nOption == 2

      aTmp[ cNAJUSTE    ] := oCbxAjust:nAt
      aTmp[ cFITALIC    ] := "Negrita" $ cEstilo
      aTmp[ cFSTRIKEOUT ] := "Cursiva" $ cEstilo
      aTmp[ cFWIDTH     ] := Val( aTmp[ cFWIDTH ] )

      WinGather( aTmp, aGet, dbfTmpCol, oBrw, APPD_MODE, nil, .f. )
      oDlg:end()

   end case

RETURN NIL*/

//----------------------------------------------------------------------------//

static function bRetTitle( cDocu )

   local cTit  := Rtrim( ( cDocu )->cTitulo )

return {|| cTit }

//----------------------------------------------------------------------------//

/*static function bRetLiteral( cDocu, nSize )

   local cTit  := Left( ( cDocu )->cLiteral, nSize )

return {|| cTit }*/

//----------------------------------------------------------------------------//


static function DocDelRec()

   local cCodDoc  := ( dbfDoc )->Codigo

   while ( dbfItm )->( dbSeek( cCodDoc ) ) .and. !( dbfItm )->( eof() )
      if ( dbfItm )->( dbRLock() )
         ( dbfItm )->( dbDelete() )
         ( dbfItm )->( dbUnLock() )
      end if
   end while

   while ( dbfCol )->( dbSeek( cCodDoc ) ) .and. !( dbfCol )->( eof() )
      if ( dbfCol )->( dbRLock() )
         ( dbfCol )->( dbDelete() )
      end if
   end while

   while ( dbfBmp )->( dbSeek( cCodDoc ) ) .and. !( dbfBmp )->( eof() )
      if ( dbfBmp )->( dbRLock() )
         ( dbfBmp )->( dbDelete() )
      end if
   end while

   while ( dbfBox )->( dbSeek( cCodDoc ) ) .and. !( dbfBox )->( eof() )
      if ( dbfBox )->( dbRLock() )
         ( dbfBox )->( dbDelete() )
      end if
   end while

return .t.

//----------------------------------------------------------------------------//

/*Static Function Preview( aTmp, oDlg )

   local oInf
   local nLines         := 0
   local cCaption       := "Vista previa"

   REPORT oInf CAPTION cCaption PREVIEW

   TmpMargin( aTmp, oInf )
   TmpPrintColum( oInf )

   if !Empty( oInf )
      oInf:lAutoland    := .f.
   end if

   END REPORT

   if !Empty( oInf )
      oInf:bSkip        := {|| ++nLines }
      ACTIVATE REPORT oInf  WHILE {|| nLines < 1 } ON ENDPAGE ( TmpPrintItems( oInf ) )
   end if

   oInf                 := nil

Return nil*/

//----------------------------------------------------------------------------//

function aDocs( cCodDoc, dbfDoc, lIncNoImp )

   local aDocs := {}
   local nOrd  := ( dbfDoc )->( OrdSetFocus( "cTipo" ) )

   DEFAULT lIncNoImp    := .f.

   if !( dbfDoc )->( dbSeek( cCodDoc ) )

      aAdd( aDocs, "    - No hay documentos" )

   else

      if lIncNoImp 
            aAdd( aDocs, "No imprimir" )
      end if

      while ( dbfDoc )->cTipo == cCodDoc .and. !( dbfDoc )->( eof() )

         aAdd( aDocs, ( dbfDoc )->Codigo + " - " + Rtrim( ( dbfDoc )->cDescrip ) )

         ( dbfDoc )->( dbSkip() )

      end do

   end if

   ( dbfDoc )->( OrdSetFocus( nOrd ) )

return ( aDocs )

//----------------------------------------------------------------------------//

function cEstilo( lNegrita, lCursiva )

   local cEstilo

   do case
      case lNegrita .and. !lCursiva
         cEstilo  := "Negrita"
      case !lNegrita .and. lCursiva
         cEstilo  := "Cursiva"
      case lNegrita .and. lCursiva
         cEstilo  := "Negrita Cursiva"
      otherwise
         cEstilo  := "Normal"
   end case

RETURN ( cEstilo )

//---------------------------------------------------------------------------//

/*Static function RigthButtonDown( nRow, nCol, nFlags, oBrw )

   local aStatus

   if nRow > oBrw:nGetChrHeight() + 1

      oBrw:LButtonDown( nRow, nCol, nFlags )

      if GetKeyState( VK_SHIFT )

         aStatus  := aGetStatus( dbfTmpItm )

         do

            if ( dbfTmpItm )->( dbRLock() )
               ( dbfTmpItm )->lSel  := !( dbfTmpItm )->lSel
               ( dbfTmpItm )->( dbUnLock() )
            end if
            ( dbfTmpItm )->( dbSkip( -1 ) )

         until ( dbfTmpItm )->lSel .or. ( dbfTmpItm )->( bof() )

         SetStatus( dbfTmpItm, aStatus )

         oBrw:Refresh()

      else

         if ( dbfTmpItm )->( dbRLock() )
            ( dbfTmpItm )->lSel  := !( dbfTmpItm )->lSel
            ( dbfTmpItm )->( dbUnLock() )
         end if

         oBrw:DrawSelect()

      end if

   end if

RETURN ( nil )*/

//---------------------------------------------------------------------------//

/*Static function RigthButtonBox( nRow, nCol, nFlags, oBrw )

   local aStatus

   if nRow > oBrw:nGetChrHeight() + 1

      oBrw:LButtonDown( nRow, nCol, nFlags )

      if GetKeyState( VK_SHIFT )

         aStatus  := aGetStatus( dbfTmpBox )

         do

            if ( dbfTmpBox )->( dbRLock() )
               ( dbfTmpBox )->lSelBox  := !( dbfTmpBox )->lSelBox
               ( dbfTmpBox )->( dbUnLock() )
            end if
            ( dbfTmpBox )->( dbSkip( -1 ) )

         until ( dbfTmpBox )->lSelBox .or. ( dbfTmpBox )->( bof() )

         SetStatus( dbfTmpBox, aStatus )

         oBrw:Refresh()

      else

         if ( dbfTmpBox )->( dbRLock() )
            ( dbfTmpBox )->lSelBox  := !( dbfTmpBox )->lSelBox
            ( dbfTmpBox )->( dbUnLock() )
         end if

         oBrw:DrawSelect()

      end if

   end if

RETURN ( nil )*/

//---------------------------------------------------------------------------//

STATIC Function ControllerExportDocument( oWndBrw, cExtension )

   local cFileToExport  := DlgExportDocument( oWndBrw, cExtension )

   if empty( cFileToExport )
      RETURN ( nil )
   end if 

   if cExtension == ".zip"
      ZipExportDocument( cFileToExport )
   else 
      Fr3ExportDocument( cFileToExport )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function DlgExportDocument( oWndBrw, cExtension )

   local oDlg
   local oGetFile
   local cGetFile    

   DEFAULT cExtension   := ".zip"

   cGetFile             := padr( cPatDocuments() + alltrim( ( dbfDoc )->cDescrip ) + cExtension, 300 )

   DEFINE DIALOG oDlg RESOURCE "EXPDOCS"

      REDEFINE SAY PROMPT ( dbfDoc )->cDescrip ;
         ID       100 ;
         OF       oDlg

      REDEFINE GET oGetFile VAR cGetFile ;
         ID       110 ;
         BITMAP   "FOLDER" ;
         ON HELP  ( oGetFile:cText( Padr( cGetFile( "*" + cExtension, "Seleccion de fichero" ), 100 ) ) ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:End( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if ( oDlg:nResult == IDOK )
      RETURN ( alltrim( cGetFile ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION fr3ExportDocument( cGetFile )

   if file( cGetFile ) .and. !msgYesNo( "El fichero " + ( cGetFile ) + " ya existe.", "¿ Desea sobrescribir el fichero?" )
      RETURN ( nil )
   end if 

   if memowrit( cGetFile, ( dbfDoc )->mReport )
      msgInfo( "Fichero " + ( cGetFile ) + " exportado con éxito." )
   else
      msgStop( "El fichero " + ( cGetFile ) + " no ha sido exportado con éxito." )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function zipExportDocument( cGetFile )

   local aDir
   local nZip
   local tmpDoc
   local tmpItm
   local tmpCol
   local tmpBmp
   local tmpBox
   local oBlock
   local oError
   local lExport     := .t.
   local nHandle     := 0
   local cCodDoc     := ( dbfDoc )->Codigo
   local nRecAnt     := ( dbfDoc )->( Recno() )

   cGetFile          := Rtrim( cGetFile )

   EraseFilesInDirectory( cPatIn(), "*.*" )

   if !mkDocs( cPatIn(), , , , .f., cLocalDriver() )
      Return .f.
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatIn() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "RDOCUMEN", @tmpDoc ) )
      SET ADSINDEX TO ( cPatIn() + "RDOCUMEN.CDX" ) ADDITIVE

      USE ( cPatIn() + "RITEMS.DBF" ) NEW SHARED VIA ( cLocalDriver() )  ALIAS ( cCheckArea( "RITEMS", @tmpItm ) )
      SET ADSINDEX TO ( cPatIn() + "RITEMS.CDX" ) ADDITIVE

      USE ( cPatIn() + "RCOLUM.DBF" ) NEW SHARED VIA ( cLocalDriver() )  ALIAS ( cCheckArea( "RCOLUM", @tmpCol ) )
      SET ADSINDEX TO ( cPatIn() + "RCOLUM.CDX" ) ADDITIVE

      USE ( cPatIn() + "RBITMAP.DBF" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "RBITMAP", @tmpBmp ) )
      SET ADSINDEX TO ( cPatIn() + "RBITMAP.CDX" ) ADDITIVE

      USE ( cPatIn() + "RBOX.DBF" ) NEW SHARED VIA ( cLocalDriver() )    ALIAS ( cCheckArea( "RBOX", @tmpBox ) )
      SET ADSINDEX TO ( cPatIn() + "RBOX.CDX" ) ADDITIVE

      if ( dbfDoc )->( dbSeek( cCodDoc ) )
         while ( dbfDoc )->Codigo == cCodDoc .and. !( dbfDoc )->( eof() )
            dbPass( dbfDoc, tmpDoc, .t. )
            ( dbfDoc )->( dbSkip() )
         end while
      end if

      if ( dbfItm )->( dbSeek( cCodDoc ) )
         while ( dbfItm )->Codigo == cCodDoc .and. !( dbfItm )->( eof() )
            dbPass( dbfItm, tmpItm, .t. )
            ( dbfItm )->( dbSkip() )
         end while
      end if

      if ( dbfCol )->( dbSeek( cCodDoc ) )
         while ( dbfCol )->Codigo == cCodDoc .and. !( dbfCol )->( eof() )
            dbPass( dbfCol, tmpCol, .t. )
            ( dbfCol )->( dbSkip() )
         end while
      end if

      if ( dbfBmp )->( dbSeek( cCodDoc ) )
         while ( dbfBmp )->Codigo == cCodDoc .and. !( dbfBmp )->( eof() )
            dbPass( dbfBmp, tmpBmp, .t. )
            ( dbfBmp )->( dbSkip() )
         end while
      end if

      if ( dbfBox )->( dbSeek( cCodDoc ) )
         while ( dbfBox )->Codigo == cCodDoc .and. !( dbfBox )->( eof() )
            dbPass( dbfBox, tmpBox, .t. )
            ( dbfBox )->( dbSkip() )
         end while
      end if

   RECOVER USING oError

      lExport         := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( tmpDoc )
      ( tmpDoc )->( dbCloseArea() )
   end if

   if !Empty( tmpItm )
      ( tmpItm )->( dbCloseArea() )
   end if

   if !Empty( tmpCol )
      ( tmpCol )->( dbCloseArea() )
   end if

   if !Empty( tmpBmp )
      ( tmpBmp )->( dbCloseArea() )
   end if

   if !Empty( tmpBox )
      ( tmpBox )->( dbCloseArea() )
   end if

   ( dbfDoc )->( dbGoTo( nRecAnt ) )

   /*
   Si no hay errores creamos el zip
   ----------------------------------------------------------------------------
   */

   if lExport

      /*
      Creamos el zip
      -------------------------------------------------------------------------
      */

      nHandle := fCreate( cGetFile )
      if nHandle != -1

         if fClose( nHandle ) .and. ( fErase( cGetFile ) == 0 )

            aDir     := Directory( cPatIn() + "*.*" )

            hb_SetDiskZip( {|| nil } )
            aEval( aDir, { | cName, nIndex | hb_ZipFile( cGetFile, cPatIn() + cName[ 1 ], 9 ) } )
            hb_gcAll()

            EraseFilesInDirectory( cPatIn(), "*.*" )

            msgInfo( "Documento exportado satisfactoriamente" )

         else

            MsgStop( "Error en la unidad" )

            Return ( .f. )

         end if

      else

         MsgStop( "Ruta no válida" )

         Return ( .f. )

      end if

   end if

Return ( lExport )

//---------------------------------------------------------------------------//

Static Function DlgImportDocument( oWndBrw )

   local oDlg
   local oGetFile
   local cGetFile    := Padr( FullCurDir() + "Docs.Zip", 100 )
   local oSayProc
   local cSayProc    := ""

   DEFINE DIALOG oDlg RESOURCE "IMPDOCS"

      REDEFINE GET oGetFile VAR cGetFile ;
         ID       100 ;
         BITMAP   "Folder" ;
         ON HELP  ( oGetFile:cText( Padr( cGetFile( "*.Zip", "Selección de fichero" ), 100 ) ) ) ;
			OF 		oDlg

      REDEFINE SAY oSayProc PROMPT cSayProc ;
         ID       110 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:Disable(), ImportDocument( cGetFile, oSayProc ), oDlg:Enable() )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:Disable(), ImportDocument( cGetFile, oSayProc ), oDlg:Enable() } )

	ACTIVATE DIALOG oDlg CENTER

   if oWndBrw != nil
      oWndBrw:Refresh()
   end if

Return ( nil  )

//---------------------------------------------------------------------------//

Static Function ImportDocument( cGetFile, oSayProc )

   local nZip
   local tmpDoc
   local tmpItm
   local tmpCol
   local tmpBmp
   local tmpBox
   local oError
   local oBlock
   local aFiles
   local lImport     := .t.

   cGetFile          := Rtrim( cGetFile )

   if !file( cGetFile )
      MsgStop( "El fichero " + cGetFile + " no existe." )
      Return .f.
   end if

   aFiles            := Hb_GetFilesInZip( cGetFile )
   if !Hb_UnZipFile( cGetFile, , , , cPatIn(), aFiles )
      MsgStop( "No se ha descomprimido el fichero " + cGetFile, "Error" )
      Return .f.
   end if
   hb_gcAll()

   if !File( cPatIn() + "RDOCUMEN.DBF" )   .or.;
      !File( cPatIn() + "RITEMS.DBF"   )   .or.;
      !File( cPatIn() + "RCOLUM.DBF"   )   .or.;
      !File( cPatIn() + "RBITMAP.DBF"  )   .or.;
      !File( cPatIn() + "RBOX.DBF"     )

      MsgStop( "Faltan ficheros para importar el documento" )
      return .f.

   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatIn() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cLocalDriver() )  ALIAS ( cCheckArea( "RDOCUMEN",   @tmpDoc ) )

   USE ( cPatIn() + "RITEMS.DBF" ) NEW SHARED VIA ( cLocalDriver() )    ALIAS ( cCheckArea( "RITEMS",     @tmpItm ) )

   USE ( cPatIn() + "RCOLUM.DBF" ) NEW SHARED VIA ( cLocalDriver() )    ALIAS ( cCheckArea( "RCOLUM",     @tmpCol ) )

   USE ( cPatIn() + "RBITMAP.DBF" ) NEW SHARED VIA ( cLocalDriver() )   ALIAS ( cCheckArea( "RBITMAP",    @tmpBmp ) )

   USE ( cPatIn() + "RBOX.DBF" ) NEW SHARED VIA ( cLocalDriver() )      ALIAS ( cCheckArea( "RBOX",       @tmpBox ) )

   oSayProc:SetText( "Importando documento" )

   while !( tmpDoc )->( eof() )
      while dbSeekInOrd( ( tmpDoc )->Codigo, "Codigo", dbfDoc )
         if ( dbfDoc )->( dbRLock() )
            ( dbfDoc )->( dbDelete() )
         end if
      end while
      ( tmpDoc )->( dbSkip() )
   end while

   ( tmpDoc )->( dbGoTop() )
   while !( tmpDoc )->( eof() )
      dbPass( tmpDoc, dbfDoc, .t. )
      ( tmpDoc )->( dbSkip() )
   end while

   oSayProc:SetText( "Importando items" )

   while !( tmpItm )->( eof() )
      while dbSeekInOrd( ( tmpItm )->Codigo, "Codigo", dbfItm )
         if ( dbfItm )->( dbRLock() )
            ( dbfItm )->( dbDelete() )
         end if
      end while
      ( tmpItm )->( dbSkip() )
   end while

   ( tmpItm )->( dbGoTop() )
   while !( tmpItm )->( eof() )
      dbPass( tmpItm, dbfItm, .t. )
      ( tmpItm )->( dbSkip() )
   end while

   oSayProc:SetText( "Importando columnas" )

   while !( tmpCol )->( eof() )
      while dbSeekInOrd( ( tmpCol )->Codigo, "Codigo", dbfCol )
         if ( dbfCol )->( dbRLock() )
            ( dbfCol )->( dbDelete() )
         end if
      end while
      ( tmpCol )->( dbSkip() )
   end while

   ( tmpCol )->( dbGoTop() )
   while !( tmpCol )->( eof() )
      dbPass( tmpCol, dbfCol, .t. )
      ( tmpCol )->( dbSkip() )
   end while

   oSayProc:SetText( "Importando bitmaps" )

   while !( tmpBmp )->( eof() )
      while dbSeekInOrd( ( tmpBmp )->Codigo, "Codigo", dbfBmp )
         if ( dbfBmp )->( dbRLock() )
            ( dbfBmp )->( dbDelete() )
         end if
      end while
      ( tmpBmp )->( dbSkip() )
   end while

  ( tmpBmp )->( dbGoTop() )
   while !( tmpBmp )->( eof() )
      dbPass( tmpBmp, dbfBmp, .t. )
      ( tmpBmp )->( dbSkip() )
   end while

   oSayProc:SetText( "Importando cajas" )

   while !( tmpBox )->( eof() )
      while dbSeekInOrd( ( tmpBox )->Codigo, "Codigo", dbfBox )
         if ( dbfBox )->( dbRLock() )
            ( dbfBox )->( dbDelete() )
         end if
      end while
      ( tmpBox )->( dbSkip() )
   end while

  ( tmpBox )->( dbGoTop() )
   while !( tmpBox )->( eof() )
      dbPass( tmpBox, dbfBox, .t. )
      ( tmpBox )->( dbSkip() )
   end while

   oSayProc:SetText( "Proceso finalizado" )

   msgInfo( "Documento importado satisfactoriamente" )

   RECOVER USING oError

      lImport        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( tmpDoc )
      ( tmpDoc )->( dbCloseArea() )
   end if

   if !Empty( tmpItm )
      ( tmpItm )->( dbCloseArea() )
   end if

   if !Empty( tmpCol )
      ( tmpCol )->( dbCloseArea() )
   end if

   if !Empty( tmpBmp )
      ( tmpBmp )->( dbCloseArea() )
   end if

   if !Empty( tmpBox )
      ( tmpBox )->( dbCloseArea() )
   end if

   /*
   Eliminar todos los ficheros
   ----------------------------------------------------------------------------
   */

   dbfErase( cPatIn() + "RDocumen" )
   dbfErase( cPatIn() + "RItems"   )
   dbfErase( cPatIn() + "RColum"   )
   dbfErase( cPatIn() + "RBitmap"  )
   dbfErase( cPatIn() + "RBox"     )

Return ( lImport )

//---------------------------------------------------------------------------//

/*Static Function SetScope( lScope )

   if lScope

      ( dbfItm )->( ordScope( 0, ( dbfDoc )->Codigo ) )
      ( dbfItm )->( ordScope( 1, ( dbfDoc )->Codigo ) )
      ( dbfItm )->( dbGoTop() )

      ( dbfCol )->( ordScope( 0, ( dbfDoc )->Codigo ) )
      ( dbfCol )->( ordScope( 1, ( dbfDoc )->Codigo ) )
      ( dbfCol )->( dbGoTop() )

      ( dbfBox )->( ordScope( 0, ( dbfDoc )->Codigo ) )
      ( dbfBox )->( ordScope( 1, ( dbfDoc )->Codigo ) )
      ( dbfBox )->( dbGoTop() )

      ( dbfBmp )->( ordScope( 0, ( dbfDoc )->Codigo ) )
      ( dbfBmp )->( ordScope( 1, ( dbfDoc )->Codigo ) )
      ( dbfBmp )->( dbGoTop() )

   else

      ( dbfItm )->( ordScope( 0, nil ) )
      ( dbfItm )->( ordScope( 1, nil ) )

      ( dbfCol )->( ordScope( 0, nil ) )
      ( dbfCol )->( ordScope( 1, nil ) )

      ( dbfBox )->( ordScope( 0, nil ) )
      ( dbfBox )->( ordScope( 1, nil ) )

      ( dbfBmp )->( ordScope( 0, nil ) )
      ( dbfBmp )->( ordScope( 1, nil ) )

   end if

return nil*/

//---------------------------------------------------------------------------//

Function lExisteDocumento( cCodigoDocumento, dbfDoc )

   local nOrd
   local lExisteDocumento        := .t.

   if Empty( cCodigoDocumento )
      MsgStop( "Código de documento está vacío." )
      Return ( .f. )
   end if

   do case
      case Valtype( dbfDoc ) == "C"

         nOrd                    := ( dbfDoc )->( OrdSetFocus( "Codigo" ) )

         if !( dbfDoc )->( dbSeek( cCodigoDocumento ) )
            MsgStop( "Código de documento " + cCodigoDocumento + " no encontrado." )
            lExisteDocumento     := .f.
         end if

         ( dbfDoc )->( OrdSetFocus( nOrd ) )

      case Valtype( dbfDoc ) == "O"

         nOrd                    := dbfDoc:OrdSetFocus( "Codigo" )

         if !( dbfDoc:Seek( cCodigoDocumento ) )
            MsgStop( "Código de documento " + cCodigoDocumento + " no encontrado." )
            lExisteDocumento     := .f.
         end if

         dbfDoc:OrdSetFocus( nOrd )

   end case

Return ( lExisteDocumento )

//---------------------------------------------------------------------------//

Function lVisualDocumento( cCodigoDocumento, dbfDoc )

   local lVisualDocumento  := .t.
   local nOrd              := ( dbfDoc )->( OrdSetFocus( "Codigo" ) )

   if ( dbfDoc )->( dbSeek( cCodigoDocumento ) )
      lVisualDocumento     := ( dbfDoc )->lVisual
   else
      MsgStop( "Código de documento " + cCodigoDocumento + " no existe." )
   end if

   ( dbfDoc )->( OrdSetFocus( nOrd ) )

Return ( lVisualDocumento )

//---------------------------------------------------------------------------//

Function lMemoDocumento( cCodigoDocumento, dbfDoc )

   local lMemoDocumento    := .t.
   local nOrd              := ( dbfDoc )->( OrdSetFocus( "Codigo" ) )

   if ( dbfDoc )->( dbSeek( cCodigoDocumento ) )
      lMemoDocumento       := !empty( ( dbfDoc )->mReport )
   else
      MsgStop( "Código de documento " + cCodigoDocumento + " no encontrado." )
   end if

   ( dbfDoc )->( OrdSetFocus( nOrd ) )

Return ( lMemoDocumento )

//---------------------------------------------------------------------------//

/*Static Function BeginTrans( aTmp, nMode )

   local cCodDoc     := aTmp[ dCODIGO ]

   /*filTmpItm         := cGetNewFileName( cPatTmp() + "DbfTmpItm" )
   filTmpCol         := cGetNewFileName( cPatTmp() + "DbfTmpCol" )
   filTmpBmp         := cGetNewFileName( cPatTmp() + "DbfTmpBmp" )
   filTmpBox         := cGetNewFileName( cPatTmp() + "DbfTmpBox" )*/

   // Temporal de la base de datos RITEMS.DBF

   /*dbCreate( filTmpItm, aSqlStruct( aItmItm ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpItm, cCheckArea( "DbfTmpItm", @dbfTmpItm ), .f. )
   if !( dbfTmpItm )->( neterr() )
      ( dbfTmpItm )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpItm )->( OrdCreate( filTmpItm, "Codigo", "Codigo + Str( nLinea ) + Str( nColumna )", {|| Field->Codigo + Str( Field->nLinea ) + Str( Field->nColumna ) } ) )
   end if*/

   // Temporal de la base de datos RCOLUM.DBF

   /*dbCreate( filTmpCol, aSqlStruct( aItmCol ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpCol, cCheckArea( "DbfTmpCol", @dbfTmpCol ), .f. )
   if !( dbfTmpCol )->( neterr() )
      ( dbfTmpCol )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpCol )->( OrdCreate( filTmpCol, "Codigo", "Codigo", {|| Field->Codigo } ) )
   end if*/

   // Temporal de la base de datos RBITMAP.DBF

   /*dbCreate( filTmpBmp, aSqlStruct( aItmBmp ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpBmp, cCheckArea( "DbfTmpCol", @dbfTmpBmp ), .f. )
   if !( dbfTmpBmp )->( neterr() )
      ( dbfTmpBmp )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpBmp )->( OrdCreate( filTmpBmp, "Codigo", "Codigo", {|| Field->Codigo } ) )
   end if*/

   // Temporal de la base de datos RBOX.DBF

   /*dbCreate( filTmpBox, aSqlStruct( aItmBox ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), filTmpBox, cCheckArea( "DbfTmpBox", @dbfTmpBox ), .f. )
   if !( dbfTmpBox )->( neterr() )
      ( dbfTmpBox )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpBox )->( OrdCreate( filTmpBox, "Codigo", "Codigo + STR( nRowTop ) + STR( nColTop )", {|| Field->Codigo + STR( Field->nRowTop ) + STR( Field->nColTop ) } ) )
   end if*/

   // Pasamos los datos a la temporal dbfTmpItm

   /*if ( dbfItm )->( dbSeek( cCodDoc ) )
      while ( dbfItm )->Codigo == cCodDoc .and. !( dbfItm )->( eof() )
         dbPass( dbfItm, dbfTmpItm, .t. )
         ( dbfItm )->( dbSkip() )
      end while
      ( dbfTmpItm )->( dbGoTop() )
   end if*/

   // Pasamos los datos a la temporal dbfTmpCol

   /*if ( dbfCol )->( dbSeek( cCodDoc ) )
      while ( dbfCol )->Codigo == cCodDoc .and. !( dbfCol )->( eof() )
         dbPass( dbfCol, dbfTmpCol, .t. )
         ( dbfCol )->( dbSkip() )
      end while
      ( dbfTmpCol )->( dbGoTop() )
   end if*/

   // Pasamos los datos a la temporal dbfTmpBmp

   /*if ( dbfBmp )->( dbSeek( cCodDoc ) )
      while ( dbfBmp )->Codigo == cCodDoc .and. !( dbfBmp )->( eof() )
         dbPass( dbfBmp, dbfTmpBmp, .t. )
         ( dbfBmp )->( dbSkip() )
      end while
      ( dbfTmpBmp )->( dbGoTop() )
   end if*/

   // Pasamos los datos a la temporal dbfTmpBox

   /*if ( dbfBox )->( dbSeek( cCodDoc ) )
      while ( dbfBox )->Codigo == cCodDoc .and. !( dbfBox )->( eof() )
         dbPass( dbfBox, dbfTmpBox, .t. )
         ( dbfBox )->( dbSkip() )
      end while
      ( dbfTmpBox )->( dbGoTop() )
   end if*/

//Return Nil

//---------------------------------------------------------------------------//

Static Function SaveEdtDocs( aTmp, aGet, oDlg, oBrw, oBtnAceptar, cTipDoc, nMode )

   local oError
   local oBlock
   local cCod           := aTmp[ dCODIGO ]

   aTmp[ dCTIPO   ]     := SubStr( cTipDoc, 1, 2 )

   /*
   Condiciones para que no se meta un documento sin código
   ----------------------------------------------------------------------------
   */

   if Empty( cCod )
      MsgStop( "Código no puede estar vacío" )
      aGet[ dCODIGO ]:SetFocus()
      return nil
   end if

   if Empty( aTmp[ dCDESCRIP ] )
      MsgStop( "Descripción no puede estar vacía" )
      aGet[ dCDESCRIP ]:SetFocus()
      return nil
   end if

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      /*
      Comprueba si el codigo introducido existe
      -------------------------------------------------------------------------
      */

      if ( dbfDoc )->( dbSeek( cCod ) )
         msgStop( "Código ya existente" )
         aGet[ dCODIGO ]:SetFocus()
         return nil
      end if

   end if

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      BeginTransaction()

      if nMode == EDIT_MODE

         // Borramos los datos antiguos para luego pasarles los temporales

         while ( dbfItm )->( dbSeek( cCod ) ) .and. !( dbfItm )->( eof() )
            if dbLock( dbfItm )
               ( dbfItm )->( dbDelete() )
               ( dbfItm )->( dbUnLock() )
            end if
         end while

         while ( dbfCol )->( dbSeek( cCod ) ) .and. !( dbfCol )->( eof() )
            if dbLock( dbfCol )
               ( dbfCol )->( dbDelete() )
               ( dbfCol )->( dbUnLock() )
            end if
         end while

         while ( dbfBmp )->( dbSeek( cCod ) ) .and. !( dbfBmp )->( eof() )
            if dbLock( dbfBmp )
               ( dbfBmp )->( dbDelete() )
               ( dbfBmp )->( dbUnLock() )
            end if
         end while

         while ( dbfBox )->( dbSeek( cCod ) ) .and. !( dbfBox )->( eof() )
            if dbLock( dbfBox )
               ( dbfBox )->( dbDelete() )
               ( dbfBox )->( dbUnLock() )
            end if
         end while

      end if

      /*
      Pasamos los temporales a los ficheros definitivos---------------------------
      */

      /*( dbfTmpItm )->( OrdSetFocus( 0 ) )
      ( dbfTmpItm )->( dbGoTop() )
      while !( dbfTmpItm )->( eof() )
          dbPass( dbfTmpItm, dbfItm, .t., cCod )
         ( dbfTmpItm )->( dbSkip() )
      end while*/

      /*( dbfTmpCol )->( OrdSetFocus( 0 ) )
      ( dbfTmpCol )->( dbGoTop() )
      while !( dbfTmpCol )->( eof() )
          dbPass( dbfTmpCol, dbfCol, .t., cCod )
         ( dbfTmpCol )->( dbSkip() )
      end while*/

      /*( dbfTmpBmp )->( OrdSetFocus( 0 ) )
      ( dbfTmpBmp )->( dbGoTop() )
      while !( dbfTmpBmp )->( eof() )
          dbPass( dbfTmpBmp, dbfBmp, .t., cCod )
         ( dbfTmpBmp )->( dbSkip() )
      end while*/

      /*( dbfTmpBox )->( OrdSetFocus( 0 ) )
      ( dbfTmpBox )->( dbGoTop() )
      while !( dbfTmpBox )->( eof() )
         dbPass( dbfTmpBox, dbfBox, .t., cCod )
         ( dbfTmpBox )->( dbSkip() )
      end while*/

      WinGather( aTmp, nil, dbfDoc, oBrw, nMode, nil, .f. )

      CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()
      msgStop( "Imposible almacenar documento" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   /*
   Llamada al editor visual que esta fuera de la ventana
   ----------------------------------------------------------------------------
   */

   VisualEdtDocs( dbfDoc )

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

//Static Function KillTrans()

   // Cerramos las bases de datos si no están en uso

   /*if !Empty( dbfTmpItm ) .and. ( dbfTmpItm )->( Used() )
      ( dbfTmpItm )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpCol ) .and. ( dbfTmpCol )->( Used() )
      ( dbfTmpCol )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpBmp ) .and. ( dbfTmpBmp )->( Used() )
      ( dbfTmpBmp )->( dbCloseArea() )
   end if

   if !Empty( dbfTmpBox ) .and. ( dbfTmpBox )->( Used() )
      ( dbfTmpBox )->( dbCloseArea() )
   end if*/

   // Inicializamos las variables

   //dbfTmpItm   := nil
   //dbfTmpCol   := nil
   //dbfTmpBmp   := nil
   //dbfTmpBox   := nil

   // Eliminamos las bases de datos temporales que se han creado

   //dbfErase( filTmpItm )
   //dbfErase( filTmpCol )
   //dbfErase( filTmpBmp )
   //dbfErase( filTmpBox )

//Return Nil

//---------------------------------------------------------------------------//

/*STATIC FUNCTION TmpMargin( aTmp, oReport )

   local nTipoLinea

   nAjuste        := 0

	/*
   Tomamos las Dimensiones del listado y establecemos los márgenes

   if aTmp[ dNWIDPAG ] != 0 .and. aTmp[ dNLENPAG ] != 0

      oReport:oDevice:SetSize( aTmp[ dNWIDPAG ] * 100, aTmp[ dNLENPAG ] * 100 )

      oReport:nWidth    := oReport:oDevice:nHorzRes()
      oReport:nHeight   := oReport:oDevice:nVertRes()

   end if

   /*
   Margenes del documento

   oReport:Margin( aTmp[ dNINICIO ], RPT_TOP,    RPT_CMETERS )
   oReport:Margin( aTmp[ dNFIN    ], RPT_BOTTOM, RPT_CMETERS )
   oReport:Margin( aTmp[ dNLEFT   ], RPT_LEFT,   RPT_CMETERS )
   oReport:Margin( aTmp[ dNRIGHT  ], RPT_RIGHT,  RPT_CMETERS )

   nTipoLinea           := aTmp[ dNTYPELINE ] - 1
   oReport:nTitleUpLine := nTipoLinea
   oReport:nTitleDnLine := nTipoLinea

RETURN NIL*/

//---------------------------------------------------------------------------//

/*STATIC FUNCTION TmpPrintItems( oInf )

	local cText
	local cLine
   local nFor
	local nRow
	local nCol
   local nSizTxt
   local aCoors
   local nLines
	local nHeight
	local nSize
   local oFont
   local aStart
   local aEnd
   local fColor
   local nWidth
   local oPen
   local nRecBmp  := ( dbfTmpBmp )->( RecNo() )
   local nRecBox  := ( dbfTmpBox )->( RecNo() )
   local nRecItm  := ( dbfTmpItm )->( RecNo() )

   /*
   Primero los Bitmaps
	------------------------------------------------------------------------

   ( dbfTmpBmp )->( dbGoTop() )
   while !( dbfTmpBmp )->( Eof() )

      if File( ( dbfTmpBmp )->cFichero )

         aStart := oInf:oDevice:Cmtr2Pix( ( dbfTmpBmp )->nRowTop, ( dbfTmpBmp )->nColTop )
         aEnd   := oInf:oDevice:Cmtr2Pix( ( dbfTmpBmp )->nRowBottom, ( dbfTmpBmp )->nColBottom )

         oInf:oDevice:SayBitmap( aStart[1], aStart[2], ( dbfTmpBmp )->cFichero, aEnd[1], aEnd[2] )

      end if

      ( dbfTmpBmp )->( DbSkip(1) )

   end while

	/*
	Ahora las Cajas
	------------------------------------------------------------------------

   ( dbfTmpBox )->( dbGoTop() )
   while !( dbfTmpBox )->( Eof() )

      aStart := oInf:oDevice:Cmtr2Pix( ( dbfTmpBox )->nRowTop, ( dbfTmpBox )->nColTop )
      aEnd   := oInf:oDevice:Cmtr2Pix( ( dbfTmpBox )->nRowBottom, ( dbfTmpBox )->nColBottom )

      DEFINE PEN oPen WIDTH ( dbfTmpBox )->nTypeLine COLOR Rgb( ( dbfTmpBox )->Red, ( dbfTmpBox )->Green, ( dbfTmpBox )->Blue )

      if ( aStart[1] == aEnd[1] .or. aStart[2] == aEnd[2] )
         oInf:oDevice:Line( aStart[1], aStart[2], aEnd[1], aEnd[2], oPen )
      else
         oInf:oDevice:Box( aStart[1], aStart[2], aEnd[1], aEnd[2], oPen )
      end if
      oPen:end()

      ( dbfTmpBox )->( dbSkip() )

   end while

	/*
   Los items
	------------------------------------------------------------------------

   ( dbfTmpItm )->( dbGoTop() )
   while !( dbfTmpItm )->( Eof() )

      nRow  := ( dbfTmpItm )->nLinea + ( ( oInf:nPage - 1 ) * nAjuste )
      nCol  := ( dbfTmpItm )->nColumna
      nSize := ( dbfTmpItm )->nSize

      if nRow != 0 .OR. nCol != 0

         if ( dbfTmpItm )->lLiteral

            cText       := ( dbfTmpItm )->cCampo
            cText       := if( SubStr( cText, 1, 1 ) != '"', '"' + Rtrim( cText ) + '"', cText )
            cText       := Eval( bChar2Block( cText ) )

         else

            if ( dbfTmpItm )->lLiteral
               cText := ( dbfTmpItm )->cCampo
            else
               cText := ( dbfTmpItm )->cLiteral
            end if

         end if

         // Creación de nuevo font------------------------------------------

         if !Empty( ( dbfTmpItm )->fFaceName )
            oFont := TFont():New(   Rtrim( ( dbfTmpItm )->fFaceName ), 0, ( dbfTmpItm )->fWidth, , ( dbfTmpItm )->fItalic, , , , ( dbfTmpItm )->fStrikeOut, , , , , , , oInf:oDevice )
         else
            oFont := TFont():New( "Arial", 0, -10,,.t.,,,,,,,,,,, oInf:oDevice )
         end if

         cText    := cValToChar( cText )

         IF ValType( cText ) == "N" .AND. cText == 0
            cText    := ""
         END IF

         nLines      := 1
         nHeight     := oInf:oDevice:GetTextHeight( "B", oFont )
         nSizTxt     := oInf:oDevice:GetTextWidth( Replicate( "B", nSize ), oFont )

         for nFor := 1 TO nLines

            if ( dbfTmpItm )->nAjuste == 3     // Ajuste a la derecha
               cLine := MemoLine( Ltrim( cText ), If( nSize == 0, 50, nSize ), nFor )
               cLine := Alltrim( cLine )
            else
               cLine := AllTrim( MemoLine( cText, If( nSize == 0, 50, nSize ), nFor ) )
            end if

            // Pasamos a pixels las posiciones a imprimir

            aCoors   := oInf:oDevice:Cmtr2Pix( nRow, nCol )

            if nSize != 0

               nWidth   := oInf:oDevice:GetTextWidth( cLine, oFont )

               do case
                  case ( dbfTmpItm )->NAJUSTE == 3     // Ajuste a la derecha
                     aCoors[2] += ( nSizTxt - nWidth )

                  case ( dbfTmpItm )->NAJUSTE == 2     // Ajuste centrado
                     aCoors[2] += ( ( nSizTxt / 2 ) - ( nWidth / 2 )  )

               endcase

            end if

            // Colores distintos si estamos en preview

            if ( dbfTmpItm )->lLiteral
               fColor   := 0
            else
               fColor   := 255
            end if

            // Nos piden no imprimir cuando sea cero

            oInf:oDevice:Say( aCoors[1] + ( ( nFor - 1 ) * nHeight ), aCoors[2], cLine, oFont , nil, fColor )

         next

         if oFont != nil
            oFont:end()
         end if

      end if

      ( dbfTmpItm )->( dbSkip() )

   end while

   ( dbfTmpBmp )->( dbGoTo( nRecBmp ) )
   ( dbfTmpBox )->( dbGoTo( nRecBox ) )
   ( dbfTmpItm )->( dbGoTo( nRecItm ) )

RETURN NIL*/

//---------------------------------------------------------------------------//

/*STATIC FUNCTION TmpPrintColum( oInf )

   local bTitle
   local cTexto
	local	nSize
	local	nColFmt
	local nColor
	local	oFont
	local lShadow
	local lGird
   local lNewLine
   local nCol
   local nRecCol

   if ( dbfTmpCol )->( LastRec() ) == 0
      RptAddOColumn( { {|| "" } }, 0, "", 0, "", nil, nil, nil, .f., , 1, .f., .f., .f., , 0 )
      Return nil
   end if

   nRecCol        := ( dbfTmpCol )->( RecNo() )

	/*
	Columnas desde el fichero externo

   ( dbfTmpCol )->( dbGoTop() )
   while !( dbfTmpCol )->( eof() )

      nSize       := ( dbfTmpCol )->nSize
      nColor      := ( dbfTmpCol )->fColor
      lShadow     := ( dbfTmpCol )->lShadow
      lGird       := ( dbfTmpCol )->lGird
      lNewLine    := ( dbfTmpCol )->lNewLine

      if !Empty( ( dbfTmpCol )->cTitulo )
         bTitle   := { bRetTitle( dbfTmpCol ) }
      else
         bTitle   := nil
      end if

      if !Empty( ( dbfTmpCol )->cLiteral )
         cTexto   := { bRetLiteral( dbfTmpCol, nSize ) }
      else
         cTexto   := ""
      end if

      if !( dbfTmpCol )->lAutPos .and. ( dbfTmpCol )->nColumna != 0
         nCol     := Max( 0, ( ( dbfTmpCol )->nColumna * 10 * oInf:oDevice:nHorzRes() / oInf:oDevice:nHorzSize() ) - oInf:oDevice:nYoffset )
      else
         nCol     := 0
      end if

      /*
      Diferencias con clase column

      do case
      case ( dbfTmpCol )->nAjuste == 1
         nColFmt  := 1
      case ( dbfTmpCol )->nAjuste == 2
         nColFmt  := 3
      case ( dbfTmpCol )->nAjuste == 3
         nColFmt  := 2
      end case

      /*
      Tipos de letra

      if !Empty( ( dbfTmpCol )->fFaceName )
         oFont    := TFont():New( Rtrim( ( dbfTmpCol )->fFaceName ), 0, ( dbfTmpCol )->fWidth,, ( dbfTmpCol )->fItalic,,,, ( dbfTmpCol )->fStrikeOut,,,,,,, oInf:oDevice )
      else
         oFont    := TFont():New( "Arial", 0, -10,,.t.,,,,,,,,,,, oInf:oDevice )
      end if

      RptAddOColumn( bTitle, nCol, cTexto, nSize, nil, oFont, oFont, oFont, .f., , nColFmt, lShadow, lGird, lNewLine, , 255 )

      ( dbfTmpCol )->( dbSkip() )

   end while

  ( dbfTmpCol )->( dbGoTo( nRecCol ) )

Return nil*/

//---------------------------------------------------------------------------//

 FUNCTION BrwDocumento( oGet, oGet2, cTipDoc )

   local oDlg
   local oBrw
   local oGet1
   local cGet1
   local nOrd     := GetBrwOpt( "BrwDocumentos" )
   local oCbxOrd
   local aCbxOrd  := { "Código" }
   local cCbxOrd

   if !OpenFiles( .t. )
      Return nil
   end if

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   

   if !Empty( cTipDoc )
      ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == cTipDoc }, "cTipo == '" + cTipDoc + "'" ) )
      ( dbfDoc )->( dbGoTop() )
   end if

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccione un documento"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfDoc, .t., nil, .f. ) );
         VALID    ( OrdClearScope( oBrw, dbfDoc ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfDoc )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:cAlias          := dbfDoc

      oBrw:nMarqueeStyle   := 5

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :bStrData         := {|| ( dbfDoc )->Codigo }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :bStrData         := {|| ( dbfDoc )->cDescrip }
         :nWidth           := 280
      end with

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( addRecDocument( dbfDoc, oBrw, bEdit0, cTipDoc ) )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         ACTION   ( VisualEdtDocs( dbfDoc ) ) 

      oDlg:AddFastKey( VK_F2,       {|| addRecDocument( dbfDoc, oBrw, bEdit0, cTipDoc ) } )
      oDlg:AddFastKey( VK_F3,       {|| VisualEdtDocs( dbfDoc ) } )

      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   DestroyFastFilter( dbfDoc )

   SetBrwOpt( "BrwDocumentos", ( dbfDoc )->( OrdNumber() ) )

   if oDlg:nResult == IDOK

      if ValType( oGet ) == "O"
         oGet:cText( ( dbfDoc )->Codigo )
      else
         oGet     := ( dbfDoc )->Codigo
      end if

      if ValType( oGet2 ) == "O"
         oGet2:cText( AllTrim( ( dbfDoc )->cDescrip ) )
      else
         oGet2    := AllTrim( ( dbfDoc )->cDescrip )
      end if

   end if

   if !Empty( cTipDoc )
      ( dbfDoc )->( dbClearFilter() )
   end if

   CloseFiles()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function addRecDocument( dbfDoc, oBrw, bEdit0, cTipDoc )

      DestroyFastFilter( dbfDoc )
      
      WinAppRec( oBrw, bEdit0, dbfDoc, cTipDoc )

      ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == cTipDoc }, "cTipo == '" + cTipDoc + "'" ) )
      ( dbfDoc )->( dbGoTop() )

Return( .t. )

//---------------------------------------------------------------------------//

FUNCTION cDocumento( oGet, oGet2, dbfDoc, cTipDoc )

   local lValid      := .f.
   local xValor      := oGet:varGet()
   local lOpen       := .f.
   local nOrdAnt

   if Empty( xValor )

      if !Empty( oGet2 )
         oGet2:cText( "" )
      end if

      return .t.

   end if

   if Empty( dbfDoc )
      USE ( cPatEmp() + "RDOCUMEN.DBF" ) NEW SHARED VIA ( cDriver() )ALIAS ( cCheckArea( "RDOCUMEN", @dbfDoc ) )
      SET ADSINDEX TO ( cPatEmp() + "RDOCUMEN.CDX" ) ADDITIVE
      lOpen          := .t.
   end if

   if !Empty( cTipDoc )
      ( dbfDoc )->( dbSetFilter( {|| Field->cTipo == cTipDoc }, "Field->cTipo == '" + cTipDoc + "'" ) )
   end if

   nOrdAnt           := ( dbfDoc )->( ordsetfocus( "Codigo" ) )

   if ( dbfDoc )->( dbSeek( xValor ) ) .or. ( dbfDoc )->( dbSeek( Upper( xValor ) ) )

      if ValType( oGet ) == "O"
         oGet:cText( ( dbfDoc )->Codigo )
      else
         oGet        := ( dbfDoc )->Codigo
      end if

      if !Empty( oGet2 )
         if ValType( oGet2 ) == "O"
            oGet2:cText( ( dbfDoc )->cDescrip )
         else
            oGet2    := ( dbfDoc )->cDescrip
         end if
      end if

      lValid         := .t.

   else

      msgStop( "Documento no encontrado", "Aviso del sistema" )

   end if

   if !Empty( cTipDoc )
      ( dbfDoc )->( dbSetFilter() )
   end if

   ( dbfDoc )->( ordsetfocus( nOrdAnt ) )

   if lOpen
      CLOSE( dbfDoc )
   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION cNombreDoc( cCodigo )

   local cNombre  := Space( 100 )

   if !OpenFiles( .t. )
      Return nil
   end if

   if ( dbfDoc )->( dbSeek( cCodigo ) )
      cNombre     := ( dbfDoc )->cDescrip
   end if

   CloseFiles()

RETURN ( cNombre )

//---------------------------------------------------------------------------//

Static Function aItmFld()

   local aItm  := {}

   aAdd( aItm, { "CTIPDOC", "C",  2, 0 } )
   aAdd( aItm, { "CFLDDOC", "C",100, 0 } )
   aAdd( aItm, { "CAREDOC", "C", 50, 0 } )
   aAdd( aItm, { "CDESDOC", "C",200, 0 } )
   aAdd( aItm, { "CMASDOC", "C", 50, 0 } )
   aAdd( aItm, { "CCONDOC", "C",100, 0 } )
   aAdd( aItm, { "NALIDOC", "N",  1, 0 } )
   aAdd( aItm, { "NSIZDOC", "N",  3, 0 } )

Return ( aItm )

//---------------------------------------------------------------------------//

Static Function aItmCol()

   local aItm  := {}

   aAdd( aItm, { "CTIPDOC", "C",  2, 0 } )
   aAdd( aItm, { "CFLDDOC", "C",100, 0 } )
   aAdd( aItm, { "CAREDOC", "C", 50, 0 } )
   aAdd( aItm, { "CDESDOC", "C",200, 0 } )
   aAdd( aItm, { "CMASDOC", "C", 50, 0 } )
   aAdd( aItm, { "CCONDOC", "C",100, 0 } )
   aAdd( aItm, { "NALIDOC", "N",  1, 0 } )
   aAdd( aItm, { "LBitmap", "L",  1, 0 } )
   aAdd( aItm, { "NSIZDOC", "N",  3, 0 } )
   aAdd( aItm, { "NWIDDOC", "N",  3, 0 } )

Return ( aItm )

//---------------------------------------------------------------------------//

Static Function VisualEdtDocs( dbfDoc )

   local oFr
   local cTipo          

   if !( dbfDoc )->lVisual
      msgInfo( "No se puede modificar el formato, tiene que crear un nuevo formato de forma visual.", "Formato obsoleto" )
      Return .f.
   end if

   cTipo                := ( dbfDoc )->cTipo

   // Objeto fastreport--------------------------------------------------------

   oFr                  := frReportManager():New()
   oFr:ClearDataSets()
   oFr:LoadLangRes(     "Spanish.Xml" )
   oFr:SetProperty(     "Designer.DefaultFont", "Name", "Verdana")
   oFr:SetProperty(     "Designer.DefaultFont", "Size", 10)
   oFr:SetIcon( 1 )
   oFr:SetTitle(        "Diseñador de documentos" )
   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   do case
      case cTipo == "AR"
         DesignReportArticulo( oFr, dbfDoc )

      case cTipo == "OF"
         DesignReportOferta( oFr, dbfDoc )

      case cTipo == "CL"
         DesignReportClient( oFr, dbfDoc )

      case cTipo == "PL"
         DesignReportProvee( oFr, dbfDoc )

      case cTipo == "AL"
         DesignLabelAlbaranProveedor( oFr, dbfDoc )
 
      case cTipo == "FL"
         DesignLabelFacturaProveedor( oFr, dbfDoc )

      case cTipo == "RL"
         DesignLabelFacturaRectificativaProveedor( oFr, dbfDoc )

      case cTipo == "PE"
         DesignLabelPedidoProveedores( oFr, dbfDoc )

      case cTipo == "AB"
         DesignLabelAlbaranClientes( oFr, dbfDoc )

      case cTipo == "PB"
         DesignLabelPedidoClientes( oFr, dbfDoc )

      case cTipo == "PR"
         DesignLabelPresupuestoClientes( oFr, dbfDoc )

      case cTipo == "FB"
         DesignLabelFacturaClientes( oFr, dbfDoc )

      case cTipo == "FI"
         DesignLabelFacturaRectificativaClientes( oFr, dbfDoc )

      case cTipo == "MV"

         with object ( MovimientosAlmacenLabelReport():New() )
            :setFastReport( oFr )
            :setReport( ( dbfDoc )->mReport )
            :Design()
            :end()
         end object

         // DesignLabelRemesasMovimientosAlmacen( oFr, dbfDoc )

      case cTipo == "SA"
         DesignLabelSATClientes( oFr, dbfDoc )

      case cTipo == "PP"
         DesignReportPedPrv( oFr, dbfDoc )

      case cTipo == "AP"
         DesignReportAlbPrv( oFr, dbfDoc )

      case cTipo == "FP"
         DesignReportFacPrv( oFr, dbfDoc )

      case cTipo == "TP"
         DesignReportRctPrv( oFr, dbfDoc )

      case cTipo == "SC"
         DesignReportSatCli( oFr, dbfDoc )

      case cTipo == "RC"
         DesignReportPreCli( oFr, dbfDoc )

      case cTipo == "PC"
         DesignReportPedCli( oFr, dbfDoc )

      case cTipo == "AC"
         DesignReportAlbCli( oFr, dbfDoc )

      case cTipo == "FC"
         DesignReportFacCli( oFr, dbfDoc )

      case cTipo == "FR"
         DesignReportFacRec( oFr, dbfDoc )

      case cTipo == "TC"
         DesignReportAntCli( oFr, dbfDoc )

      case cTipo == "TK"
         DesignReportTikCli( oFr, dbfDoc )

      case cTipo == "RF"
         DesignReportRecCli( oFr, dbfDoc )

      case cTipo == "RP"
         DesignReportRecPrv( oFr, dbfDoc )

      case cTipo == "EP"
         DesignReportEntPedCli( oFr, dbfDoc )

      case cTipo == "EA"
         DesignReportEntAlbCli( oFr, dbfDoc )

      case cTipo == "PO"

         with object ( TProduccion():Create( cPatEmp() ) )
            :DesignReportProducc( oFr, dbfDoc )
            :end()
         end object

      case cTipo == "AQ"

         with object ( TTurno():Create( cPatEmp() ) )
            :DesignReport( oFr, dbfDoc )
            :end()
         end object

      case cTipo == "RM"

         with object ( MovimientosAlmacenReport():New() )
            :setFastReport( oFr )
            :setReport( ( dbfDoc )->mReport )
            :Design()
            :end()
         end object

      case cTipo == "MP"

         DesignReportPgoCli( oFr, dbfDoc )

      case cTipo == "LQ"

         with object ( TCobAge():Create( cPatEmp() ) )
            :DesignReport( oFr, dbfDoc )
            :end()
         end object

      case cTipo == "ED"

         with object ( TExpediente():Create( cPatEmp() ) )
            :DesignReport( oFr, dbfDoc )
            :end()
         end object

      case cTipo == "LP"

         with object ( TProduccion():Create( cPatEmp() ) )
            :OpenFiles()
            :DesignLabelProducc( oFr, dbfDoc )
            :CloseFiles()
            :end()
         end object   

      otherwise
         msgStop( "Diseñador visual aún no habilitado" )

   end case

   if !Empty( oFr )
      oFr:destroyFr()
      oFr               := nil
   end if

Return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION RenameItems( aTmp, aGet, dbfDoc, oBrw, bWhen, bValid, nMode )

   local oDlg
   local nPos
   local oTipDoc
   local cTipDoc  := aTipDoc[ 1 ]
   local cCodDoc  := aCodDoc[ 1 ]

   if !( dbfDoc )->lVisual
      msgInfo( "No se puede modificar el formato." + CRLF + "Tiene que crear un nuevo formato de forma visual.", "Formato obsoleto" )
      Return .f.
   end if

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTS" TITLE "Renombrando documento : " + rtrim( aTmp[ dCDESCRIP ] )

      nPos        := aScan( aCodDoc, {| aCodDoc | SubStr( aCodDoc, 1, 2 ) == aTmp[ dCTIPO ] } )
      cTipDoc     := aTipDoc[ if( nPos != 0, nPos, 1 )  ]
      cCodDoc     := aTmp[ dCTIPO ]

      REDEFINE COMBOBOX oTipDoc ;
         VAR      cTipDoc ;
         WHEN     ( .f. ) ;
         ITEMS    aTipDoc ;
         ID       100 ;
         OF       oDlg

		REDEFINE GET aGet[ dCODIGO ] VAR aTmp[ dCODIGO ] ;
         WHEN     ( .f. ) ;
         PICTURE  "@!" ;
			ID 		110 ;
         OF       oDlg

		REDEFINE GET aGet[ dCDESCRIP ] VAR aTmp[ dCDESCRIP ] ;
			ON CHANGE( ActTitle( nKey, nFlags, Self, nMode, oDlg ) );
			ID 		120 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       511 ;
         OF       oDlg ;
         ACTION   ( SaveRenameItems( aTmp, aGet, oDlg, oBrw, nMode ) )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end( IDOK ) )

   oDlg:AddFastKey( VK_F5, {|| SaveRenameItems( aTmp, aGet, oDlg, oBrw, nMode ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function SaveRenameItems( aTmp, aGet, oDlg, oBrw, nMode )

   if Empty( aTmp[ dCDESCRIP ] )
      MsgStop( "Descripción no puede estar vacía" )
      aGet[ dCDESCRIP ]:SetFocus()
      return nil
   end if

   WinGather( aTmp, aGet, dbfDoc, oBrw, nMode, nil, .f. )

Return( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

FUNCTION EdtDocumento( cCodDoc )

   local nLevel

   if Empty( cCodDoc )
      Return .f.
   end if

   nLevel         := nLevelUsr( _MENUITEM_ )

   if nAnd( nLevel, 1 ) != 0 .or. nAnd( nLevel, ACC_EDIT ) == 0
      msgStop( 'Acceso no permitido.' )
      return .t.
   end if

   if OpenFiles()

      if dbSeekInOrd( cCodDoc, "Codigo", dbfDoc )
         VisualEdtDocs( dbfDoc )
      else
         MsgStop( "No se encuentra formato de etiqueta" )
      end if

      CloseFiles()
   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function cTipDoc( cTipo )

   local nPos     := aScan( aCodDoc, cTipo )
   local cTipDoc  := aTipDoc[ MinMax( nPos, 1, len( aTipDoc ) ) ]

Return ( cTipDoc )

//---------------------------------------------------------------------------//

Function cFirstDoc( cTipo, dbfDoc )

   local cFirstDoc      := ""

   do case
      case Valtype( dbfDoc ) == "C"

         if dbSeekInOrd( cTipo, "cTipo", dbfDoc )
            cFirstDoc   := ( dbfDoc )->Codigo
         end if

      case Valtype( dbfDoc ) == "O"

         if dbfDoc:SeekInOrd( cTipo, "cTipo" )
            cFirstDoc   := dbfDoc:Codigo
         end if

   end case

Return ( cFirstDoc )

//---------------------------------------------------------------------------//

FUNCTION cSelPrimerDoc( cTipDoc )

   local cCodigo  := Space( 3 )

   if !OpenFiles( .t. )
      Return nil
   end if

   ( dbfDoc )->( OrdSetFocus( "cTipo" ) )

   if ( dbfDoc )->( dbSeek( cTipDoc ) )
      cCodigo     := ( dbfDoc )->Codigo
   end if

   CloseFiles()

RETURN ( cCodigo )

//---------------------------------------------------------------------------//
