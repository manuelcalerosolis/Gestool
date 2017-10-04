/*                 LLJOBOPEN

#Include "winuser.ch"
#INCLUDE "WinGdi.ch"
#Include "commdlg.ch"
#Include "commctrl.ch"

#include "hbclass.ch"
#Include "debug.ch"
#Include "what32.ch"
#include "wintypes.ch"
#Include "cstruct.ch"
*/

# include "FiveWin.ch"



*#DEFINE LL_ERR_BAD_JOBHANDLE            -1
*#DEFINE LL_ERR_TASK_ACTIVE              -2
*#DEFINE LL_ERR_BAD_OBJECTTYPE           -3
*#DEFINE LL_ERR_BAD_PROJECTTYPE          -3
*#DEFINE LL_ERR_PRINTING_JOB             -4
*#DEFINE LL_ERR_NO_BOX                   -5
*#DEFINE LL_ERR_ALREADY_PRINTING         -6
*#DEFINE LL_ERR_NO_PROJECT               -10
*#DEFINE LL_ERR_NO_PRINTER               -11
*#DEFINE LL_ERR_PRINTING                 -12
*#DEFINE LL_ERR_ONLY_ONE_JOB             -13
*#DEFINE LL_ERR_NEEDS_VB                 -14
*#DEFINE LL_ERR_BAD_PRINTER              -15
*#DEFINE LL_ERR_NO_PREVIEWMODE           -16
*#DEFINE LL_ERR_NO_PREVIEWFILES          -17
*#DEFINE LL_ERR_PARAMETER                -18
*#DEFINE LL_ERR_BAD_EXPRESSION           -19
*#DEFINE LL_ERR_BAD_EXPRMODE             -20
*#DEFINE LL_ERR_NO_TABLE                 -21
*#DEFINE LL_ERR_CFGNOTFOUND              -22
*#DEFINE LL_ERR_EXPRESSION               -23
*#DEFINE LL_ERR_CFGBADFILE               -24
*#DEFINE LL_ERR_BADOBJNAME               -25
*#DEFINE LL_ERR_NOOBJECT                 -26
*#DEFINE LL_ERR_UNKNOWNOBJECT            -27
*#DEFINE LL_ERR_NO_TABLEOBJECT           -28
*#DEFINE LL_ERR_NO_OBJECT                -29
*#DEFINE LL_ERR_NO_TEXTOBJECT            -30
*#DEFINE LL_ERR_UNKNOWN                  -31
*#DEFINE LL_ERR_BAD_MODE                 -32
*#DEFINE LL_ERR_CFGBADMODE               -33
*#DEFINE LL_ERR_ONLYWITHONETABLE         -34
*#DEFINE LL_ERR_UNKNOWNVARIABLE          -35
*#DEFINE LL_ERR_UNKNOWNFIELD             -36
*#DEFINE LL_ERR_UNKNOWNSORTORDER         -37
*#DEFINE LL_ERR_USER_ABORTED             -99
*#DEFINE LL_ERR_BAD_DLLS                 -100
*#DEFINE LL_ERR_NO_LANG_DLL              -101
*#DEFINE LL_ERR_NO_MEMORY                -102
*#DEFINE LL_WRN_REPEAT_DATA              -998
*#DEFINE LL_CMND_DRAW_USEROBJ            0
*#DEFINE LL_CMND_EDIT_USEROBJ            1
*#DEFINE LL_CMND_TABLELINE               10
*#DEFINE LL_TABLE_LINE_HEADER            0
*#DEFINE LL_TABLE_LINE_BODY              1
*#DEFINE LL_TABLE_LINE_FOOTER            2
*#DEFINE LL_TABLE_LINE_FILL              3
*#DEFINE LL_CMND_TABLEFIELD              11
*#DEFINE LL_TABLE_FIELD_HEADER           0
*#DEFINE LL_TABLE_FIELD_BODY             1
*#DEFINE LL_TABLE_FIELD_FOOTER           2
*#DEFINE LL_TABLE_FIELD_FILL             3
*#DEFINE LL_CMND_EVALUATE                12
*#DEFINE LL_CMND_OBJECT                  20
*#DEFINE LL_CMND_PAGE                    21
*#DEFINE LL_CMND_PROJECT                 22
*#DEFINE LL_CMND_DRAW_GROUP_BEGIN        23
*#DEFINE LL_CMND_DRAW_GROUP_END          24
*#DEFINE LL_CMND_DRAW_GROUPLINE          25
*#DEFINE LL_RSP_GROUP_IMT                0
*#DEFINE LL_RSP_GROUP_NEXTPAGE           1
*#DEFINE LL_RSP_GROUP_OK                 2
*#DEFINE LL_RSP_GROUP_DRAWFOOTER         3
*#DEFINE LL_CMND_CREATE_PRINTERDC        26
*#DEFINE LL_CMND_DELETE_PRINTERDC        27
*#DEFINE LL_CMND_GET_PRINTERINFO         28
*#DEFINE LL_CMND_HELP                    30
*#DEFINE LL_NTFY_FAILSFILTER             1000
*#DEFINE OBJECT_LABEL                    1
*#DEFINE OBJECT_LIST                     2
*#DEFINE OBJECT_CARD                     3
#DEFINE LL_PROJECT_LABEL                1
*#DEFINE LL_PROJECT_LIST                 2
*#DEFINE LL_PROJECT_CARD                 3
*#DEFINE LL_OBJ_MARKER                   0
*#DEFINE LL_OBJ_TEXT                     1
*#DEFINE LL_OBJ_RECT                     2
*#DEFINE LL_OBJ_LINE                     3
*#DEFINE LL_OBJ_BARCODE                  4
*#DEFINE LL_OBJ_DRAWING                  5
*#DEFINE LL_OBJ_TABLE                    6
*#DEFINE LL_OBJ_TEMPLATE                 7
*#DEFINE LL_DEBUG_CMBTLL                 1
*#DEFINE LL_DEBUG_CMBTDWG                2
#DEFINE LL_OPTION_NEWEXPRESSIONS        0
*#DEFINE LL_OPTION_ONLYONETABLE          1
*#DEFINE LL_OPTION_TABLE_COLORING        2
*#DEFINE LL_COLORING_LL                  0
*#DEFINE LL_COLORING_PROGRAM             1
*#DEFINE LL_COLORING_DONTCARE            2
*#DEFINE LL_OPTION_SUPERVISOR            3
*#DEFINE LL_OPTION_TABSTOPS              5
*#DEFINE LL_TABS_DELETE                  0
*#DEFINE LL_TABS_EXPAND                  1
*#DEFINE LL_OPTION_CALLBACKMASK          6
*#DEFINE LL_CB_PAGE                      1073741824
*#DEFINE LL_CB_PROJECT                   536870912
*#DEFINE LL_CB_OBJECT                    268435456
*#DEFINE LL_CB_HELP                      134217728
*#DEFINE LL_OPTION_CALLBACKPARAMETER     7
*#DEFINE LL_OPTION_HELPAVAILABLE         8
*#DEFINE LL_OPTION_SORTVARIABLES         9
*#DEFINE LL_OPTION_SUPPORTPAGEBREAK      10
*#DEFINE LL_OPTION_SHOWPREDEFVARS        11
*#DEFINE LL_OPTION_EXTENDEDTYPES         12
*#DEFINE LL_OPTION_USEHOSTPRINTER        13
*#DEFINE LL_OPTION_EXTENDEDEVALUATION    14
*#DEFINE LL_OPTION_TABREPRESENTATIONCODE 15
*#DEFINE LL_OPTION_COUNTERSINTABLE       16
*#DEFINE LL_OPTION_NOPREDATASEPERATOR    17
*#DEFINE LL_SYSCOMMAND_MINIMIZE          -1
*#DEFINE LL_SYSCOMMAND_MAXIMIZE          -2
*#DEFINE LL_VERSION_NUMBER               0
*#DEFINE LL_VERSION_MAJOR                1
*#DEFINE LL_VERSION_MINOR                2
*#DEFINE LL_VERSION_SERNO_LO             3
*#DEFINE LL_VERSION_SERNO_HI             4
*#DEFINE LL_VERSION_OEMNO                5
*#DEFINE LL_VERSION_RESNUMBER            10
*#DEFINE LL_VERSION_RESMAJOR             11
*#DEFINE LL_VERSION_RESMINOR             12
*#DEFINE LL_VERSION_RESLANGUAGE          14
*#DEFINE LL_FIXEDNAME                    32768
*#DEFINE LL_NOSAVEAS                     16384
*#DEFINE LL_EXPRCONVERTQUIET             4096
*#DEFINE LL_NONAMEINTITLE                2048
*#DEFINE LL_FILE_ALSONEW                 32768
*#DEFINE LL_TABLE_FOOTERFIELD            8388608
*#DEFINE LL_TABLE_GROUPFIELD             4194304
*#DEFINE LL_TABLE_FIELDTYPEMASK          12582912
#DEFINE LL_BARCODE                      1073741824
#DEFINE LL_BARCODE_EAN13                1073741824
#DEFINE LL_BARCODE_EAN8                 1073741825
#DEFINE LL_BARCODE_UPCA                 1073741826
#DEFINE LL_BARCODE_UPCE                 1073741827
#DEFINE LL_BARCODE_3OF9                 1073741828
#DEFINE LL_BARCODE_25INDUSTRIAL         1073741829
#DEFINE LL_BARCODE_25INTERLEAVED        1073741830
#DEFINE LL_BARCODE_25DATALOGIC          1073741831
#DEFINE LL_BARCODE_25MATRIX             1073741832
#DEFINE LL_BARCODE_POSTNET              1073741833
#DEFINE LL_BARCODE_FIM                  1073741834
#DEFINE LL_BARCODE_CODABAR              1073741835
#DEFINE LL_BARCODE_EAN128               1073741836
#DEFINE LL_BARCODE_CODE128              1073741837
#DEFINE LL_BARCODE_METHODMASK           255
#DEFINE LL_BARCODE_WITHTEXT             256
#DEFINE LL_BARCODE_WITHOUTTEXT          512
#DEFINE LL_BARCODE_TEXTDONTCARE         0
*#DEFINE LL_DRAWING                      536870912
*#DEFINE LL_DRAWING_HMETA                536870913
*#DEFINE LL_DRAWING_USEROBJ              536870914
*#DEFINE LL_DRAWING_USEROBJ_DLG          536870915
*#DEFINE LL_DRAWING_HBITMAP              536870916
*#DEFINE LL_DRAWING_HICON                536870917
*#DEFINE LL_DRAWING_HEMETA               536870918
*#DEFINE LL_DRAWING_METHODMASK           255
*#DEFINE LL_META_MAXX                    10000
*#DEFINE LL_META_MAXY                    10000
#DEFINE LL_TEXT                         268435456
*#DEFINE LL_TEXT_ALLOW_WORDWRAP          268435456
*#DEFINE LL_TEXT_DENY_WORDWRAP           268435457
*#DEFINE LL_TEXT_FORCE_WORDWRAP          268435458
#DEFINE LL_NUMERIC                      134217728
#DEFINE LL_DATE                         67108864
#DEFINE LL_BOOLEAN                      33554432
*#DEFINE LL_IMT_LEFTALIGN                0
*#DEFINE LL_IMT_CENTERALIGN              16777216
*#DEFINE LL_IMT_RIGHTALIGN               33554432
*#DEFINE LL_IMT_ALIGNMASK                50331648
*#DEFINE LL_IMT_HEADERFONT               67108864
*#DEFINE LL_IMT_BODYFONT                 134217728
*#DEFINE LL_IMT_FOOTERFONT               268435456
*#DEFINE LL_IMT_FONTMASK                 469762048
*#DEFINE LL_IMT_WRAP                     1073741824
*#DEFINE LL_IMT_ALWAYSFOOTER             8388608
*#DEFINE LL_IMT_FRAME                    4194304
*#DEFINE LL_IMT_EXPRESSION               2097152
*#DEFINE LL_IMT_NOSEPARATOR              1048576
#DEFINE LL_OPTION_COPIES                0
#DEFINE LL_COPIES_HIDE                  -32768
*#DEFINE LL_OPTION_STARTPAGE             1
*#DEFINE LL_OPTION_PAGE                  1
*#DEFINE LL_PAGE_HIDE                    -32768
*#DEFINE LL_OPTION_OFFSET                2
*#DEFINE LL_OPTION_COPIES_SUPPORTED      3
*#DEFINE LL_OPTION_UNITS                 4
*#DEFINE LL_UNITS_MM_DIV_10              0
*#DEFINE LL_UNITS_INCH_DIV_100           1
*#DEFINE LL_OPTION_FIRSTPAGE             5
*#DEFINE LL_OPTION_LASTPAGE              6
*#DEFINE LL_OPTION_JOBPAGES              7
#DEFINE LL_BOXTYPE_NORMALMETER          0
#DEFINE LL_BOXTYPE_BRIDGEMETER          1
#DEFINE LL_BOXTYPE_NORMALWAIT           2
#DEFINE LL_BOXTYPE_BRIDGEWAIT           3
*#DEFINE LL_PRINT_V1POINTX               0
#DEFINE LL_PRINT_NORMAL                 256
#DEFINE LL_PRINT_PREVIEW                512
*#DEFINE LL_PRINT_MODEMASK               3840
*#DEFINE LL_PRINT_MULTIPLE_JOBS          4096
*#DEFINE LL_DLGBOXMODE_3DBUTTONS         32768
*#DEFINE LL_DLGBOXMODE_3DFRAME2          16384
*#DEFINE LL_DLGBOXMODE_3DFRAME           4096
*#DEFINE LL_DLGBOXMODE_NOBITMAPS         8192
*#DEFINE LL_DLGBOXMODE_DONTCARE          0
*#DEFINE LL_DLGBOXMODE_SAA               1
*#DEFINE LL_DLGBOXMODE_ALT1              2
*#DEFINE LL_DLGBOXMODE_ALT2              3
*#DEFINE LL_DLGBOXMODE_ALT3              4
*#DEFINE LL_DLGBOXMODE_ALT4              5
*#DEFINE LL_DLGBOXMODE_ALT5              6
*#DEFINE LL_DLGBOXMODE_ALT6              7
*#DEFINE LL_DLGBOXMODE_ALT7              8
*#DEFINE LL_DLGBOXMODE_ALT8              9
*#DEFINE LL_EXPRTYPE_DOUBLE              1
*#DEFINE LL_EXPRTYPE_DATE                2
*#DEFINE LL_EXPRTYPE_LPSTR              3
*#DEFINE LL_EXPRTYPE_BOOL                4
*#DEFINE LL_EXPRTYPE_DRAWING             5
*#DEFINE LL_EXPRTYPE_BARCODE             6
*#DEFINE LL_CHAR_PHANTOMSPACE            183
*#DEFINE LL_CHAR_NEWLINE                 182
*#DEFINE LL_CHAR_LOCK                    172
*#DEFINE LL_CHAR_EAN128NUL               255
*#DEFINE LL_CHAR_EAN128FNC1              254
*#DEFINE LL_CHAR_EAN128FNC2              253
*#DEFINE LL_CHAR_EAN128FNC3              252
*#DEFINE LL_CHAR_EAN128FNC4              251
*#DEFINE LL_CTL_ADDTOSYSMENU             4
*#DEFINE LL_CTL_ALSOCHILDREN             16
*#DEFINE LL_CTL_CONVERTCONTROLS          65536
*
*#DEFINE CMBTLANG_DEFAULT    -1
*#DEFINE CMBTLANG_GERMAN      0
*#DEFINE CMBTLANG_ENGLISH     1
*#DEFINE CMBTLANG_ARABIC      2
*#DEFINE CMBTLANG_AFRIKAANS   3
*#DEFINE CMBTLANG_ALBANIAN    4
*#DEFINE CMBTLANG_BASQUE      5
*#DEFINE CMBTLANG_BULGARIAN   6
*#DEFINE CMBTLANG_BYELORUSSIA 7
*#DEFINE CMBTLANG_CATALAN     8
*#DEFINE CMBTLANG_CHINESE     9
*#DEFINE CMBTLANG_CROATIAN   10
*#DEFINE CMBTLANG_CZECH      11
*#DEFINE CMBTLANG_DANISH     12
*#DEFINE CMBTLANG_DUTCH      13
*#DEFINE CMBTLANG_ESTONIAN   14
*#DEFINE CMBTLANG_FAEROESE   15
*#DEFINE CMBTLANG_FARSI      16
*#DEFINE CMBTLANG_FINNISH    17
*#DEFINE CMBTLANG_FRENCH     18
*#DEFINE CMBTLANG_GREEK      19
*#DEFINE CMBTLANG_HEBREW     20
*#DEFINE CMBTLANG_HUNGARIAN  21
*#DEFINE CMBTLANG_ICELANDIC  22
*#DEFINE CMBTLANG_INDONESIAN 23
*#DEFINE CMBTLANG_ITALIAN    24
*#DEFINE CMBTLANG_JAPANESE   25
*#DEFINE CMBTLANG_KOREAN     26
*#DEFINE CMBTLANG_LATVIAN    27
*#DEFINE CMBTLANG_LITHUANIAN 28
*#DEFINE CMBTLANG_NORWEGIAN  29
*#DEFINE CMBTLANG_POLISH     30
*#DEFINE CMBTLANG_PORTUGUESE 31
*#DEFINE CMBTLANG_ROMANIAN   32
*#DEFINE CMBTLANG_RUSSIAN    33
*#DEFINE CMBTLANG_SLOVAK     34
*#DEFINE CMBTLANG_SLOVENIAN  35
*#DEFINE CMBTLANG_SERBIAN    36
*#DEFINE CMBTLANG_SPANISH    37
*#DEFINE CMBTLANG_SWEDISH    38
*#DEFINE CMBTLANG_THAI       39
*#DEFINE CMBTLANG_TURKISH    40
*#DEFINE CMBTLANG_UKRAINIAN  41





*     #xcommand DLL [<static:STATIC>] FUNCTION <FuncName>( [ <uParam1> AS <type1> ] ;
*                                                     [, <uParamN> AS <typeN> ] ) ;
*             AS <return> LIB <DllName> ALIAS <alias> [FLAGS <flags>];
*       => ;
*          [<static>] function <FuncName>( [<uParam1>] [,<uParamN>] ) ;;
*             local uResult ;;
*             Local hInstDLL  :=LoadLibrary(<(DllName)>);;
*             Local nProcAddr :=GetProcAddress(hInstDLL,<(alias)>);;
*             uResult = CallDLL(hInstDLL, nProcAddr, [<flags>], <return> [, <type1>, <uParam1> ] [, <typeN>, <uParamN> ] ) ;;
*             FreeLibrary(hInstDLL);;
*             return uResult

Static hDll
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
CLASS ListLabel

   Var   nWin
   Var   nHandle
   Var   lError
   Var   lScreen
   Var   cFile
   Var   cTempPath
   Var   cTitle
   Var   lPrev
   Var   nCicli
   Var   nParz
   VAR   nAddEnd

   Method New CONSTRUCTOR
   Method Close
   Method OpenReport
   Method DelPreview
   Method InsVariable
   Method IniField
   Method ModiLabel
   Method AddRecord
   Method EndAppend
   Method Preview

ENDCLASS

//-----------------------------------------------------------------------------
Method New(nLanguage)

 Local nErr := 0
 ::lError    := .F.
 ::nHandle   := 0
 ::cFile     := 'TEST'
 ::cTempPath := 'c:\mastro20'
 ::cTitle    := 'Stampa Etichette '
 ::lPrev     := .f.
 ::nCicli    := 1
 ::nParz     := 0
 ::nAddEnd   := 0
* ::nWin      := oWin:hWnd

 *hDll := LoadLibrary( "CMLL10.DLL" )
 hDll := _LoadLibrary("cm32lx.dll" )

 if hDll == 0
    MsgInfo( "Non trovo cm32lx.dll" )
    ::lError := .T.
 else
    ::nHandle :=  LlJobOpen(nLanguage)
	 // Abilita il new expression mode
	 // ATTENZIONE SI DEVE MODIFICARE ANCHE LL_ART
    *  nErr := LlSetOption(::nHandle, LL_OPTION_NEWEXPRESSIONS, 1 )
 endif


Return Self

*//-----------------------------------------------------------------------------
Method Close()
 if hDll <> 0
    LlJobClose( ::nHandle )
    _FreeLibrary( hdll )
 endif
Return Self
*//-----------------------------------------------------------------------------
Method OpenReport()
Local nerrore
Local nError
Local cDesc
Local cBarre

if  ::lPrev
   nError := LlPrintWithBoxStart(::nHandle, ;
             LL_PROJECT_LABEL, ;
             ::cFile ,;
             LL_PRINT_PREVIEW , ;
             LL_BOXTYPE_BRIDGEMETER ,;
             ::cTitle )

   nError := LlPreviewSetTempPath(::nHandle, ::cTempPath)
else
   nError := LlPrintWithBoxStart(::nHandle, ;
             LL_PROJECT_LABEL, ;
             ::cFile ,;
             LL_PRINT_NORMAL , ;
             LL_BOXTYPE_BRIDGEMETER ,;
             ::cTitle )
endif





   nError := LlPrintSetOption(::nHandle, LL_OPTION_COPIES,  LL_COPIES_HIDE)
   nError := LlPrintOptionsDialog(::nHandle,  ::cTitle)

   IF nError == - 99
      ::Close()
   ENDIF
Return Self

//-----------------------------------------------------------------------------
Method AddRecord()

  LlPrint(::nHandle)

  LlPrintSetBoxText(::nHandle,"File:"+::cFile+ " ",(100* ::nParz /::nCicli) )
  ::nPArz++

Return Self

//-----------------------------------------------------------------------------
Method EndAppend()
 Local nError :=  LlPrintEnd(::nHandle,::nAddEnd)
Return Self

//-----------------------------------------------------------------------------
Method Preview()
Local   nerror := LlPreviewDisplay (::nHandle, ::cFile , ::cTempPath )
  ::DelPreview()
Return Self
//-----------------------------------------------------------------------------
Method ModiLabel()
 Local nError := LlDefineLayout(::nHandle  , ::cTitle , LL_PROJECT_LABEL, ::cFile )
Return Self
//-----------------------------------------------------------------------------
Method InsVariable(cName,cValue,cType)
Local nError
do case
   case cType == 'TEXT'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_TEXT, '')
   case cType == 'BOOL'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_BOOLEAN, '')
   case cType == 'NUME'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_NUMERIC, '')
   case cType == 'EAN8'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_BARCODE_EAN8, '')
   case cType == 'EAN13'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_BARCODE_EAN13, '')
   case cType == 'UPCA'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_BARCODE_UPCA, '')
   case cType == 'UPCE'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_BARCODE_UPCE, '')
   case cType == '3OF9'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_BARCODE_3OF9, '')
   case cType == 'EAN128'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_BARCODE_EAN128, '')
   case cType == 'CODE128'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_BARCODE_CODE128, '')
   case cType == '25IND'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_BARCODE_25INDUSTRIAL , '')
   case cType == '25ITF'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_BARCODE_25INTERLEAVED , '')
   case cType == '25MAT'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_BARCODE_25MATRIX , '')
   case cType == '25DAT'
      nerror := LlDefineVariableExt(::nHandle , cName , cValue , LL_BARCODE_25DATALOGIC , '')
 endcase


Return Self
//-----------------------------------------------------------------------------
Method IniField(cAlias)
Local  aDati := (cAlias)->(ARRAY(FCOUNT()))
Local  aTipo := (cAlias)->(ARRAY(FCOUNT()))
Local  nX
Local  nError := 0
AFIELDS(aDATI,aTIPO)
for nX := 1 to len(aDati)
    do case
       case aTipo[nX] == 'C'
          nerror := ::InsVariable( alias()+ '.'+aDati[nX] , &(aDati[nX])  , 'TEXT')
       case aTipo[nX] == 'N'
          nerror := ::InsVariable( alias()+ '.'+aDati[nX] , str(&(aDati[nX]))  , 'NUME')
       case aTipo[nX] == 'L'
          nerror := ::InsVariable( alias()+ '.'+aDati[nX] , &(aDati[nX])  , 'BOOL')
       case aTipo[nX] == 'D'
          nerror := ::InsVariable( alias()+ '.'+aDati[nX] , dtoc(&(aDati[nX]))  , 'BOOL')
    endcase
next

Return Self
//-----------------------------------------------------------------------------
Method DelPreview()
*Local aFileDelete := directory(::cTempPath + ::cFile + '.0*')
Local aFileDelete := directory(::cFile + '.0*')
Local  nError,nX
for nX := 1 to len(aFileDelete)
   nError := fErase(::cTempPath  + aFileDelete[nX,1])
next
*aeval(aFileDelete,{|x|ferase(x[1])})
aFileDelete := nil
aFileDelete := directory(::cFile + '.1*')
for nX := 1 to len(aFileDelete)
   nError := fErase(::cTempPath  + aFileDelete[nX,1])
next





Return Self

























































//---------------------------------------------------------------------------------------------
Function LlJobOpen(nLanguage)
 Local  cFarProc := _GetProcAddress( hDLL,"LlJobOpen")
 Local  nH := _CallDLL(hDll,cFarProc , ,4,4,nLanguage )
Return nH
//---------------------------------------------------------------------------------------------
Function LlDefineVariableStart(nH)
 Local cFarProc := _GetProcAddress( hDLL,"LlDefineVariableStart")
 Local nErr := _CallDLL(hDll,cFarProc , ,4,4,nH   )
Return nErr

//---------------------------------------------------------------------------------------------
Function LlSetOption(nH,nMode,nValue)
Local cFarProc := _GetProcAddress( hDLL,"LlSetOption")
Local nErr := _CallDLL(hDll,cFarProc , ,4,4,nH , _INT ,0 ,LONG ,1  )
*LLDLL    FUNCTION LlSetOption Lib "cmbtLL.dll" (hJob As _INT, nMode As _INT, nValue As Long) As _INT

Return nErr
//---------------------------------------------------------------------------------------------
Function LlDefineVariable(nH,cName , cValue)
Local cFarProc := _GetProcAddress( hDLL,"LlDefineVariable")
Local nErr := _CallDLL(hDll,cFarProc , ,4,4,nH ,10,cName,10,cValue  )
Return nErr
//---------------------------------------------------------------------------------------------
Function LlDefineVariableExt(nH,cName , cValue,nType,cVar)
 Local cFarProc := _GetProcAddress( hDLL,"LlDefineVariableExt")
 Local nErr := _CallDLL(hDll,cFarProc , ,4,4,nH ,10,cName,10,cValue,4,nType,10,cVar  )
Return nErr
//---------------------------------------------------------------------------------------------
Function LlDefineLayout(nH,cTitolo,nTipo,cFile)
 Local nHWin := 0
 Local cFarProc := _GetProcAddress( hDLL,"LlDefineLayout")
 Local nErr := _CallDLL(hDll,cFarProc , ,4 ,4,nH ,4 ,nHWin ,10,cTitolo ,4,nTipo,10,cFile )
Return nErr
//---------------------------------------------------------------------------------------------
Function LlJobClose(nH)
Local cFarProc := _GetProcAddress( hDLL,"LlJobClose")
Local nErr := _CallDLL(hDll,cFarProc , ,4,4,nH   )
Return nErr
//---------------------------------------------------------------------------------------------
Function LlPrint(nH)
Local cFarProc := _GetProcAddress( hDLL,"LlPrint")
Local nErr := _CallDLL(hDll,cFarProc , ,4,4,nH   )
Return nErr

//---------------------------------------------------------------------------------------------
Function LlPrintEnd(nH,nPages)
Local cFarProc := _GetProcAddress( hDLL,"LlPrintEnd")
Local nErr := _CallDLL(hDll,cFarProc , ,4,4,nH  , 4,nPages  )
Return nErr

//---------------------------------------------------------------------------------------------
Function LlPrintSetOption(nH,nIndex,nValue)
Local cFarProc := _GetProcAddress( hDLL,"LlPrintSetOption")
Local nErr := nErr := _CallDLL(hDll,cFarProc , ,4,4,nH  , 4,nIndex,  4,nValue  )

Return nErr

//---------------------------------------------------------------------------------------------
Function LlPrintOptionsDialog(nH,pszText )
Local nHWin := 0
Local cFarProc := _GetProcAddress( hDLL,"LlPrintOptionsDialog")
Local nErr := 0
nErr:= _CallDLL(hDll,cFarProc , ,4, 4,nH  , 4,nHWin,  10, pszText  )
Return nErr
*FUNCTION LlPrintOptionsDialog(hJob As _INT, hWnd As _INT, pszText As LPSTR) As _INT  PASCAL
//---------------------------------------------------------------------------------------------
Function LlPreviewDisplay(nH,pszObjName,pszPath )
Local nHWin := 0
Local cFarProc := _GetProcAddress( hDLL,"LlPreviewDisplay")
Local nErr := _CallDLL(hDll,cFarProc , ,4, 4,nH  , 10,pszObjName,  10, pszPath  ,4 ,nHWin )
Return nErr
*FUNCTION LlPreviewDisplay(hJob As _INT, pszObjName As LPSTR, pszPath As LPSTR, Wnd As _INT) As _INT PASCAL



//---------------------------------------------------------------------------------------------
*   nErrorValue = LlPrintSetBoxText(hJob, szBoxText, (100 * nRecno / nRecCount));
Function  LlPrintSetBoxText(nH,cTest,nPerc )
Local nHWin := 0
Local cFarProc := _GetProcAddress( hDLL,"LlPrintSetBoxText")
Local nErr := _CallDLL(hDll,cFarProc , ,4, 4,nH  , 10,cTest , 4 ,nPerc )
Return nErr

//---------------------------------------------------------------------------------------------
Function LlPrintWithBoxStart(nH,nObjType,pszObjName,nPrintOptions,nBoxType,pszTitle)
Local nHWin := 0

Local cFarProc := _GetProcAddress( hDLL,"LlPrintWithBoxStart")
Local nError := _CallDLL(hDll,cFarProc , ,4, 4,nH  ,4,nObjType,  10,pszObjName,  4,nPrintOptions   ,4,nBoxType,  4,nHWin ,  10,pszTitle)

*   nError := LlPrintWithBoxStart(::nHandle, ;
*      LL_PROJECT_LABEL, ;
*      ::cFile ,;
*      LL_PRINT_PREVIEW , ;
*      LL_BOXTYPE_NORMALMETER ,;
*      ::cTitle )

Return nError
* FUNCTION LlPrintWithBoxStart(nHandle As _INT, nObjType As _INT, pszObjName As LPSTR, nPrintOptions As _INT, nBoxType As _INT, hWnd As _INT, pszTitle As LPSTR) As _INT PASCAL
//---------------------------------------------------------------------------------------------
Function LlPreviewSetTempPath(nH,pszPath)
Local cFarProc := _GetProcAddress( hDLL,"LlPreviewSetTempPath")
Local nErr := _CallDLL(hDll,cFarProc , ,4, 4,nH , 10,pszPath  )

Return nErr
* FUNCTION LlPreviewSetTempPath(hJob As _INT, pszPath As LPSTR) As _INT PASCAL


//---------------------------------------------------------------------------------------------
Function Prova()
   local cFarProc
   local uResult
   Local nH
   Local nErr


   hDll := _LoadLibrary( "CMLL10.DLL" )
   *hDll := LoadLibrary("cm32lx.dll" )
  * alert(hDll)

  * cFarProc := _GetProcAddress( hDLL,"LlJobOpen")
  * nH := _CallDLL(hDll,cFarProc , ,4,4,1   )
    nH := LlJobOpen(1)



   *cFarProc := _GetProcAddress( hDLL,"LlDefineVariableStart")
   *nErr := _CallDLL(hDll,cFarProc , ,4,4,nH   )
   LlDefineVariableStart(nH)


  * Alert("Start")
  * alert(nErr)

   LlDefineVariable(nH,"Nome 1","Mmmmmmmmmmmm")
   *cFarProc := _GetProcAddress( hDLL,"LlDefineVariable")
   *nErr := _CallDLL(hDll,cFarProc , ,4,4,nH ,10,"Nome",10,"Maurizio"  )
  * Alert("Variabile")
  * alert(nErr)

   LlDefineVariableExt(nH,"Nome 2","Mmmmmmmmmmmm",LL_TEXT,"")
   *cFarProc := _GetProcAddress( hDLL,"LlDefineVariableExt")
   *nErr := _CallDLL(hDll,cFarProc , ,4,4,nH ,10,"Prova",10,"Maurizio" ,4,LL_TEXT,10,""   )

    *cFarProc := _GetProcAddress( hDLL,"LlDefineLayout")
    *nErr := _CallDLL(hDll,cFarProc , ,4 ,4,nH ,4 ,0 ,10,"Prova" ,4,1,10,"C:\1\PROVA" )

    LlDefineLayout(nH  , "cTitle", LL_PROJECT_LABEL,"C:\1\PROVA" )

    LlJobClose(nH)

   *cFarProc := _GetProcAddress( hDLL,"LlJobClose")
   *nErr := _CallDLL(hDll,cFarProc , ,4,4,nH   )

  _FreeLibrary(hDLL)
  quit

Return .T.