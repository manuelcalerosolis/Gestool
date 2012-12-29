// Alaska dBase++ header constants and function definitions for LL12.DLL
//  (c) 1991,..,1999,2000,..,06,... combit GmbH, Konstanz, Germany 
//  [build of 2007-06-18 14:06:34]

// HEADER file to be included in all modules using LL12

#ifndef _LL12_CH // include header only once
#define _LL12_CH

#ifndef CMBTLANG_DEFAULT
 #define CMBTLANG_DEFAULT    -1
 #define CMBTLANG_GERMAN      0
 #define CMBTLANG_ENGLISH     1
 #define CMBTLANG_ARABIC      2
 #define CMBTLANG_AFRIKAANS   3
 #define CMBTLANG_ALBANIAN    4
 #define CMBTLANG_BASQUE      5
 #define CMBTLANG_BULGARIAN   6
 #define CMBTLANG_BYELORUSSIAN 7
 #define CMBTLANG_CATALAN     8
 #define CMBTLANG_CHINESE     9
 #define CMBTLANG_CROATIAN    10
 #define CMBTLANG_CZECH       11
 #define CMBTLANG_DANISH      12
 #define CMBTLANG_DUTCH       13
 #define CMBTLANG_ESTONIAN    14
 #define CMBTLANG_FAEROESE    15
 #define CMBTLANG_FARSI       16
 #define CMBTLANG_FINNISH     17
 #define CMBTLANG_FRENCH      18
 #define CMBTLANG_GREEK       19
 #define CMBTLANG_HEBREW      20
 #define CMBTLANG_HUNGARIAN   21
 #define CMBTLANG_ICELANDIC   22
 #define CMBTLANG_INDONESIAN  23
 #define CMBTLANG_ITALIAN     24
 #define CMBTLANG_JAPANESE    25
 #define CMBTLANG_KOREAN      26
 #define CMBTLANG_LATVIAN     27
 #define CMBTLANG_LITHUANIAN  28
 #define CMBTLANG_NORWEGIAN   29
 #define CMBTLANG_POLISH      30
 #define CMBTLANG_PORTUGUESE  31
 #define CMBTLANG_ROMANIAN    32
 #define CMBTLANG_RUSSIAN     33
 #define CMBTLANG_SLOVAK      34
 #define CMBTLANG_SLOVENIAN   35
 #define CMBTLANG_SERBIAN     36
 #define CMBTLANG_SPANISH     37
 #define CMBTLANG_SWEDISH     38
 #define CMBTLANG_THAI        39
 #define CMBTLANG_TURKISH     40
 #define CMBTLANG_UKRAINIAN   41
#endif

/*--- constant declarations ---*/

#define LL_JOBOPENFLAG_NOLLXPRELOAD    (0x00001000)        
#define LL_JOBOPENFLAG_ONLYEXACTLANGUAGE (0x00002000)         /* do not look for '@@' LNG file */
#define LL_DEBUG_CMBTLL                (0x0001)             /* debug CMBTLLnn.DLL */
#define LL_DEBUG_CMBTDWG               (0x0002)             /* debug CMBTDWnn.DLL */
#define LL_DEBUG_CMBTLS                (0x0080)             /* debug CMBTLSnn.DLL */
#define LL_DEBUG_CMBTLL_NOCALLBACKS    (0x0004)            
#define LL_DEBUG_CMBTLL_NOSTORAGE      (0x0008)            
#define LL_DEBUG_CMBTLL_NOWAITDLG      (0x0010)            
#define LL_DEBUG_CMBTLL_NOSYSINFO      (0x0020)            
#define LL_DEBUG_CMBTLL_LOGTOFILE      (0x0040)            
#define LL_VERSION_MAJOR               (1)                  /* direct return of major version (f.ex. 1) */
#define LL_VERSION_MINOR               (2)                  /* direct return of minor version (f.ex. 13) */
#define LL_VERSION_SERNO_LO            (3)                  /* LOWORD(serial number) */
#define LL_VERSION_SERNO_HI            (4)                  /* HIWORD(serial number) */
#define LL_VERSION_OEMNO               (5)                  /* OEM number */
#define LL_VERSION_RESMAJOR            (11)                 /* internal, for LlRCGetVersion: resource version */
#define LL_VERSION_RESMINOR            (12)                 /* internal, for LlRCGetVersion: resource version */
#define LL_VERSION_RESLANGUAGE         (14)                 /* internal, for LlRCGetVersion: resource language */
#define LL_CMND_DRAW_USEROBJ           (0)                  /* callback for LL_DRAWING_USEROBJ */
#define LL_CMND_EDIT_USEROBJ           (1)                  /* callback for LL_DRAWING_USEROBJ_DLG */
#define LL_CMND_TABLELINE              (10)                 /* callback for LL_CB_TABLELINE */
#define LL_TABLE_LINE_HEADER           (0)                 
#define LL_TABLE_LINE_BODY             (1)                 
#define LL_TABLE_LINE_FOOTER           (2)                 
#define LL_TABLE_LINE_FILL             (3)                 
#define LL_TABLE_LINE_GROUP            (4)                 
#define LL_TABLE_LINE_GROUPFOOTER      (5)                 
#define LL_CMND_TABLEFIELD             (11)                 /* callback for LL_CB_TABLEFIELD */
#define LL_TABLE_FIELD_HEADER          (0)                 
#define LL_TABLE_FIELD_BODY            (1)                 
#define LL_TABLE_FIELD_FOOTER          (2)                 
#define LL_TABLE_FIELD_FILL            (3)                 
#define LL_TABLE_FIELD_GROUP           (4)                 
#define LL_TABLE_FIELD_GROUPFOOTER     (5)                 
#define LL_CMND_EVALUATE               (12)                 /* callback for "External$" function */
#define LL_CMND_OBJECT                 (20)                 /* callback of LL_CB_OBJECT */
#define LL_CMND_PAGE                   (21)                 /* callback of LL_CB_PAGE */
#define LL_CMND_PROJECT                (22)                 /* callback of LL_CB_PROJECT */
#define LL_CMND_DRAW_GROUP_BEGIN       (23)                 /* callback for LlPrintBeginGroup */
#define LL_CMND_DRAW_GROUP_END         (24)                 /* callback for LlPrintEndGroup */
#define LL_CMND_DRAW_GROUPLINE         (25)                 /* callback for LlPrintGroupLine */
#define LL_RSP_GROUP_IMT               (0)                 
#define LL_RSP_GROUP_NEXTPAGE          (1)                 
#define LL_RSP_GROUP_OK                (2)                 
#define LL_RSP_GROUP_DRAWFOOTER        (3)                 
#define LL_CMND_HELP                   (30)                 /* lParam: HIWORD=HELP_xxx, LOWORD=Context # */
#define LL_CMND_ENABLEMENU             (31)                 /* undoc: lParam/LOWORD(lParam) = HMENU */
#define LL_CMND_MODIFYMENU             (32)                 /* undoc: lParam/LOWORD(lParam) = HMENU */
#define LL_CMND_SELECTMENU             (33)                 /* undoc: lParam=ID (return TRUE if processed) */
#define LL_CMND_GETVIEWERBUTTONSTATE   (34)                 /* HIWORD(lParam)=ID, LOWORD(lParam)=state */
#define LL_CMND_VARHELPTEXT            (35)                 /* lParam=LPSTR(Name), returns LPSTR(Helptext) */
#define LL_INFO_METER                  (37)                 /* lParam = addr(scLlMeterInfo) */
#define LL_METERJOB_LOAD               (1)                 
#define LL_METERJOB_SAVE               (2)                 
#define LL_METERJOB_CONSISTENCYCHECK   (3)                 
#define LL_METERJOB_PASS2              (4)                 
#define LL_NTFY_FAILSFILTER            (1000)               /* data set fails filter expression */
#define LL_NTFY_VIEWERBTNCLICKED       (38)                 /* user presses a preview button (action will be done). lParam=ID. result: 0=allowed, 1=not allowed */
#define LL_CMND_DLGEXPR_VARBTN         (39)                 /* lParam: @scLlDlgExprVarExt, return: IDOK for ok */
#define LL_CMND_HOSTPRINTER            (40)                 /* lParam: scLlPrinter */
#define LL_PRN_CREATE_DC               (1)                  /* scLlPrinter._nCmd values */
#define LL_PRN_DELETE_DC               (2)                 
#define LL_PRN_SET_ORIENTATION         (3)                 
#define LL_PRN_GET_ORIENTATION         (4)                 
#define LL_PRN_EDIT                    (5)                  /* unused */
#define LL_PRN_GET_DEVICENAME          (6)                 
#define LL_PRN_GET_DRIVERNAME          (7)                 
#define LL_PRN_GET_PORTNAME            (8)                 
#define LL_PRN_RESET_DC                (9)                 
#define LL_PRN_COMPARE_PRINTER         (10)                
#define LL_PRN_GET_PHYSPAGE            (11)                
#define LL_PRN_SET_PHYSPAGE            (12)                
#define LL_PRN_GET_PAPERFORMAT         (13)                 /* fill _nPaperFormat */
#define LL_PRN_SET_PAPERFORMAT         (14)                 /* _nPaperFormat, _xPaperSize, _yPaperSize */
#define LL_OEM_TOOLBAR_START           (41)                
#define LL_OEM_TOOLBAR_END             (50)                
#define LL_NTFY_EXPRERROR              (51)                 /* lParam = LPCSTR(error text) */
#define LL_CMND_CHANGE_DCPROPERTIES_CREATE (52)                 /* lParam = addr(scLlPrinter), _hDC is valid */
#define LL_CMND_CHANGE_DCPROPERTIES_DOC (53)                 /* lParam = addr(scLlPrinter), _hDC is valid */
#define LL_CMND_CHANGE_DCPROPERTIES_PAGE (54)                 /* lParam = addr(scLlPrinter), _hDC is valid */
#define LL_CMND_CHANGE_DCPROPERTIES_PREPAGE (56)                 /* lParam = addr(scLlPrinter), _hDC and _pszBuffer( DEVMODE* ) are valid */
#define LL_CMND_MODIFY_METAFILE        (57)                 /* lParam = handle of metafile (32 bit: enh. metafile) */
#define LL_INFO_PRINTJOBSUPERVISION    (58)                 /* lParam = addr(scLlPrintJobInfo) */
#define LL_CMND_DELAYEDVALUE           (59)                 /* lParam = addr(scLlDelayedValue) */
#define LL_CMND_SUPPLY_USERDATA        (60)                 /* lParam = addr(scLlProjectUserData) */
#define LL_CMND_SAVEFILENAME           (61)                 /* lParam = LPCTSTR(Filename) */
#define LL_QUERY_IS_VARIABLE_OR_FIELD  (62)                 /* lParam = addr(scLlDelayDefineFieldOrVariable), must be enabled by CB mask. If returns TRUE, the var must be defined in the callback... */
#define LL_INTERNAL_MAXEVENTNUMBER     (62)                 /* internal: max. event number */
#define OBJECT_LABEL                   (1)                  /* old - please do not use any more */
#define OBJECT_LIST                    (2)                 
#define OBJECT_CARD                    (3)                 
#define LL_PROJECT_LABEL               (1)                  /* new names... */
#define LL_PROJECT_LIST                (2)                 
#define LL_PROJECT_CARD                (3)                 
#define LL_OBJ_MARKER                  (0)                  /* internal use only */
#define LL_OBJ_TEXT                    (1)                  /* the following are used in the object callback */
#define LL_OBJ_RECT                    (2)                 
#define LL_OBJ_LINE                    (3)                 
#define LL_OBJ_BARCODE                 (4)                 
#define LL_OBJ_DRAWING                 (5)                 
#define LL_OBJ_TABLE                   (6)                 
#define LL_OBJ_TEMPLATE                (7)                 
#define LL_OBJ_ELLIPSE                 (8)                 
#define LL_OBJ_GROUP                   (9)                  /* internal use only */
#define LL_OBJ_RTF                     (10)                
#define LL_OBJ_LLX                     (11)                
#define LL_OBJ_INPUT                   (12)                
#define LL_OBJ_LAST                    (12)                 /* last object type (for loops as upper bound) */
#define LL_OBJ_PAGE                    (255)                /* for exporter */
#define LL_DELAYEDVALUE                (0x80000000)        
#define LL_TYPEMASK                    (0x7ff00000)        
#define LL_TABLE_FOOTERFIELD           (0x00008000)         /* 'or'ed for footline-only fields // reserved also for Variables (see "$$xx$$")!!!! */
#define LL_TABLE_GROUPFIELD            (0x00004000)         /* 'or'ed for groupline-only fields */
#define LL_TABLE_HEADERFIELD           (0x00002000)         /* 'or'ed for headline-only fields */
#define LL_TABLE_BODYFIELD             (0x00001000)         /* 'or'ed for headline-only fields */
#define LL_TABLE_GROUPFOOTERFIELD      (0x00000800)         /* 'or'ed for group-footer-line-only fields */
#define LL_TABLE_FIELDTYPEMASK         (0x0000f800)         /* internal use */
#define LL_BARCODE                     (0x40000000)        
#define LL_BARCODE_EAN13               (0x40000000)        
#define LL_BARCODE_EAN8                (0x40000001)        
#define LL_BARCODE_UPCA                (0x40000002)        
#define LL_BARCODE_UPCE                (0x40000003)        
#define LL_BARCODE_3OF9                (0x40000004)        
#define LL_BARCODE_25INDUSTRIAL        (0x40000005)        
#define LL_BARCODE_25INTERLEAVED       (0x40000006)        
#define LL_BARCODE_25DATALOGIC         (0x40000007)        
#define LL_BARCODE_25MATRIX            (0x40000008)        
#define LL_BARCODE_POSTNET             (0x40000009)        
#define LL_BARCODE_FIM                 (0x4000000A)        
#define LL_BARCODE_CODABAR             (0x4000000B)        
#define LL_BARCODE_EAN128              (0x4000000C)        
#define LL_BARCODE_CODE128             (0x4000000D)        
#define LL_BARCODE_DP_LEITCODE         (0x4000000E)        
#define LL_BARCODE_DP_IDENTCODE        (0x4000000F)        
#define LL_BARCODE_GERMAN_PARCEL       (0x40000010)        
#define LL_BARCODE_CODE93              (0x40000011)        
#define LL_BARCODE_MSI                 (0x40000012)        
#define LL_BARCODE_CODE11              (0x40000013)        
#define LL_BARCODE_MSI_10_CD           (0x40000014)        
#define LL_BARCODE_MSI_10_10           (0x40000015)        
#define LL_BARCODE_MSI_11_10           (0x40000016)        
#define LL_BARCODE_MSI_PLAIN           (0x40000017)        
#define LL_BARCODE_EAN14               (0x40000018)        
#define LL_BARCODE_UCC14               (0x40000019)        
#define LL_BARCODE_CODE39              (0x4000001A)        
#define LL_BARCODE_CODE39_CRC43        (0x4000001B)        
#define LL_BARCODE_PZN                 (0x4000001C)        
#define LL_BARCODE_CODE39_EXT          (0x4000001D)        
#define LL_BARCODE_JAPANESE_POSTAL     (0x4000001E)        
#define LL_BARCODE_RM4SCC              (0x4000001F)        
#define LL_BARCODE_RM4SCC_CRC          (0x40000020)        
#define LL_BARCODE_SSCC                (0x40000021)        
#define LL_BARCODE_LLXSTART            (0x40000040)        
#define LL_BARCODE_PDF417              (0x40000040)        
#define LL_BARCODE_MAXICODE            (0x40000041)        
#define LL_BARCODE_MAXICODE_UPS        (0x40000042)        
#define LL_BARCODE_DATAMATRIX          (0x40000044)        
#define LL_BARCODE_AZTEC               (0x40000045)        
#define LL_BARCODE_METHODMASK          (0x000000ff)        
#define LL_BARCODE_WITHTEXT            (0x00000100)        
#define LL_BARCODE_WITHOUTTEXT         (0x00000200)        
#define LL_BARCODE_TEXTDONTCARE        (0x00000000)        
#define LL_DRAWING                     (0x20000000)        
#define LL_DRAWING_HMETA               (0x20000001)        
#define LL_DRAWING_USEROBJ             (0x20000002)        
#define LL_DRAWING_USEROBJ_DLG         (0x20000003)        
#define LL_DRAWING_HBITMAP             (0x20000004)        
#define LL_DRAWING_HICON               (0x20000005)        
#define LL_DRAWING_HEMETA              (0x20000006)        
#define LL_DRAWING_HDIB                (0x20000007)         /* global handle to BITMAPINFO and bits */
#define LL_DRAWING_METHODMASK          (0x000000ff)        
#define LL_META_MAXX                   (10000)             
#define LL_META_MAXY                   (10000)             
#define LL_TEXT                        (0x10000000)        
#define LL_TEXT_ALLOW_WORDWRAP         (0x10000000)        
#define LL_TEXT_DENY_WORDWRAP          (0x10000001)        
#define LL_TEXT_FORCE_WORDWRAP         (0x10000002)        
#define LL_NUMERIC                     (0x08000000)        
#define LL_NUMERIC_LOCALIZED           (0x08000001)        
#define LL_DATE                        (0x04000000)         /* LL's own julian */
#define LL_DATE_DELPHI_1               (0x04000001)        
#define LL_DATE_DELPHI                 (0x04000002)         /* DELPHI 2, 3, 4: OLE DATE */
#define LL_DATE_MS                     (0x04000002)         /* MS C/Basic: OLE DATE */
#define LL_DATE_OLE                    (0x04000002)         /* generic: OLE DATE */
#define LL_DATE_VFOXPRO                (0x04000003)         /* nearly LL's own julian, has an offset of 1! */
#define LL_DATE_DMY                    (0x04000004)         /* <d><sep><m><sep><yyyy>. Year MUST be 4 digits! */
#define LL_DATE_MDY                    (0x04000005)         /* <m><sep><d><sep><yyyy>. Year MUST be 4 digits! */
#define LL_DATE_YMD                    (0x04000006)         /* <yyyy><sep><m><sep><d>. Year MUST be 4 digits! */
#define LL_DATE_YYYYMMDD               (0x04000007)         /* <yyyymmdd> */
#define LL_DATE_LOCALIZED              (0x04000008)         /* localized (automatic VariantConversion) */
#define LL_DATE_METHODMASK             (0x000000ff)        
#define LL_BOOLEAN                     (0x02000000)        
#define LL_RTF                         (0x01000000)        
#define LL_HTML                        (0x00800000)        
#define LL_LLXOBJECT                   (0x00100000)         /* internal use only */
#define LL_FIXEDNAME                   (0x8000)            
#define LL_NOSAVEAS                    (0x4000)            
#define LL_EXPRCONVERTQUIET            (0x1000)             /* convert to new expressions without warning box */
#define LL_NONAMEINTITLE               (0x0800)             /* no file name appended to title */
#define LL_PRVOPT_PRN_USEDEFAULT       (0x00000000)        
#define LL_PRVOPT_PRN_ASKPRINTERIFNEEDED (0x00000001)        
#define LL_PRVOPT_PRN_ASKPRINTERALWAYS (0x00000002)        
#define LL_PRVOPT_PRN_ALWAYSUSEDEFAULT (0x00000003)        
#define LL_PRVOPT_PRN_ASSIGNMASK       (0x00000003)         /* used by L&L */
#define LL_OPTION_COPIES               (0)                  /* compatibility only, please use LL_PRNOPT_... */
#define LL_OPTION_STARTPAGE            (1)                  /* compatibility only, please use LL_PRNOPT_PAGE */
#define LL_OPTION_PAGE                 (1)                  /* compatibility only, please use LL_PRNOPT_... */
#define LL_OPTION_OFFSET               (2)                  /* compatibility only, please use LL_PRNOPT_... */
#define LL_OPTION_COPIES_SUPPORTED     (3)                  /* compatibility only, please use LL_PRNOPT_... */
#define LL_OPTION_FIRSTPAGE            (5)                  /* compatibility only, please use LL_PRNOPT_... */
#define LL_OPTION_LASTPAGE             (6)                  /* compatibility only, please use LL_PRNOPT_... */
#define LL_OPTION_JOBPAGES             (7)                  /* compatibility only, please use LL_PRNOPT_... */
#define LL_OPTION_PRINTORDER           (8)                  /* compatibility only, please use LL_PRNOPT_... */
#define LL_PRNOPT_COPIES               (0)                 
#define LL_COPIES_HIDE                 (-32768)             /* anything negative... */
#define LL_PRNOPT_STARTPAGE            (1)                 
#define LL_PRNOPT_PAGE                 (1)                  /* alias; please do not use STARTPAGE any more... */
#define LL_PAGE_HIDE                   (-32768)             /* must be exactly this value! */
#define LL_PRNOPT_OFFSET               (2)                 
#define LL_PRNOPT_COPIES_SUPPORTED     (3)                 
#define LL_PRNOPT_UNITS                (4)                  /* only GetOption() */
#define LL_UNITS_MM_DIV_10             (0)                  /* for LL_OPTION_UNITS and LL_OPTION_UNITS_DEFAULT */
#define LL_UNITS_INCH_DIV_100          (1)                 
#define LL_UNITS_INCH_DIV_1000         (2)                 
#define LL_UNITS_SYSDEFAULT_LORES      (3)                  /* for LL_OPTION_UNITS_DEFAULT only */
#define LL_UNITS_SYSDEFAULT            (4)                  /* for LL_OPTION_UNITS_DEFAULT only */
#define LL_UNITS_MM_DIV_100            (5)                 
#define LL_UNITS_MM_DIV_1000           (6)                 
#define LL_PRNOPT_FIRSTPAGE            (5)                 
#define LL_PRNOPT_LASTPAGE             (6)                 
#define LL_PRNOPT_JOBPAGES             (7)                 
#define LL_PRNOPT_PRINTORDER           (8)                 
#define LL_PRINTORDER_HORZ_LTRB        (0)                 
#define LL_PRINTORDER_VERT_LTRB        (1)                 
#define LL_PRINTORDER_HORZ_RBLT        (2)                 
#define LL_PRINTORDER_VERT_RBLT        (3)                 
#define LL_PRNOPT_PRINTORDER_P1        (9)                  /* for future support */
#define LL_PRNOPT_PRINTORDER_P2        (10)                 /* for future support */
#define LL_PRNOPT_DEFPRINTERINSTALLED  (11)                 /* returns 0 for no default printer, 1 for default printer present */
#define LL_PRNOPT_PRINTDLG_DESTMASK    (12)                 /* any combination of the ones below... Default: all. Outdated, please use LL_OPTIONSTR_EXPORTS_ALLOWED */
#define LL_DESTINATION_PRN             (1)                 
#define LL_DESTINATION_PRV             (2)                 
#define LL_DESTINATION_FILE            (4)                 
#define LL_DESTINATION_EXTERN          (8)                 
#define LL_DESTINATION_MSFAX           (16)                 /* reserved */
#define LL_DESTINATION_XPS             (32)                
#define LL_PRNOPT_PRINTDLG_DEST        (13)                 /* default destination; outdated, please use LL_PRNOPTSTR_EXPORT */
#define LL_PRNOPT_PRINTDLG_ONLYPRINTERCOPIES (14)                 /* show copies option in dialog only if they are supported by the printer. default: FALSE */
#define LL_PRNOPT_JOBID                (17)                
#define LL_PRNOPT_PAGEINDEX            (18)                
#define LL_PRNOPT_USES2PASS            (19)                 /* r/o */
#define LL_PRNOPT_PAGERANGE_USES_ABSOLUTENUMBER (20)                 /* default: FALSE */
#define LL_PRNOPTSTR_PRINTDST_FILENAME (0)                  /* print to file: default filename (LlGet/SetPrintOptionString) */
#define LL_PRNOPTSTR_EXPORTDESCR       (1)                  /* r/o, returns the description of the export chosen */
#define LL_PRNOPTSTR_EXPORT            (2)                  /* sets default exporter to use / returns the name of the export chosen */
#define LL_PRNOPTSTR_PRINTJOBNAME      (3)                  /* set name to be given to StartDoc() (lpszMessage of LlPrintWithBoxStart() */
#define LL_PRNOPTSTR_PRESTARTDOCESCSTRING (4)                  /* sent before StartDoc() */
#define LL_PRNOPTSTR_POSTENDDOCESCSTRING (5)                  /* sent after EndDoc() */
#define LL_PRNOPTSTR_PRESTARTPAGEESCSTRING (6)                  /* sent before StartPage() */
#define LL_PRNOPTSTR_POSTENDPAGEESCSTRING (7)                  /* sent after EndPage() */
#define LL_PRNOPTSTR_PRESTARTPROJECTESCSTRING (8)                  /* sent before first StartPage() of project */
#define LL_PRNOPTSTR_POSTENDPROJECTESCSTRING (9)                  /* sent after last EndPage() of project */
#define LL_PRINT_V1POINTX              (0x0000)            
#define LL_PRINT_NORMAL                (0x0100)            
#define LL_PRINT_PREVIEW               (0x0200)            
#define LL_PRINT_STORAGE               (0x0200)             /* same as LL_PRINT_PREVIEW */
#define LL_PRINT_FILE                  (0x0400)            
#define LL_PRINT_USERSELECT            (0x0800)            
#define LL_PRINT_EXPORT                (0x0800)             /* same as LL_PRINT_USERSELECT */
#define LL_PRINT_MODEMASK              (0x0f00)            
#define LL_PRINT_MULTIPLE_JOBS         (0x1000)            
#define LL_PRINT_KEEPJOB               (0x2000)            
#define LL_PRINT_OPEN_PRJ_READWRITE    (0x4000)             /* internal use only... */
#define LL_PRINT_IGNOREERRORS          (0x8000)             /* internal use only... */
#define LL_PRINT_FILENAME_IS_HGLOBAL   (0x4000)             /* reserved, not yet used */
#define LL_BOXTYPE_NONE                (-1)                
#define LL_BOXTYPE_NORMALMETER         (0)                 
#define LL_BOXTYPE_BRIDGEMETER         (1)                 
#define LL_BOXTYPE_NORMALWAIT          (2)                 
#define LL_BOXTYPE_BRIDGEWAIT          (3)                 
#define LL_BOXTYPE_EMPTYWAIT           (4)                 
#define LL_BOXTYPE_EMPTYABORT          (5)                 
#define LL_BOXTYPE_STDWAIT             (6)                 
#define LL_BOXTYPE_STDABORT            (7)                 
#define LL_BOXTYPE_MAX                 (7)                 
#define LL_FILE_ALSONEW                (0x8000)            
#define LL_FCTPARATYPE_DOUBLE          (0x01)              
#define LL_FCTPARATYPE_DATE            (0x02)              
#define LL_FCTPARATYPE_STRING          (0x04)              
#define LL_FCTPARATYPE_BOOL            (0x08)              
#define LL_FCTPARATYPE_DRAWING         (0x10)              
#define LL_FCTPARATYPE_BARCODE         (0x20)              
#define LL_FCTPARATYPE_ALL             (0x3f)              
#define LL_FCTPARATYPE_PARA1           (0x8001)            
#define LL_FCTPARATYPE_PARA2           (0x8002)            
#define LL_FCTPARATYPE_PARA3           (0x8003)            
#define LL_FCTPARATYPE_PARA4           (0x8004)            
#define LL_FCTPARATYPE_SAME            (0x803f)            
#define LL_EXPRTYPE_DOUBLE             (1)                 
#define LL_EXPRTYPE_DATE               (2)                 
#define LL_EXPRTYPE_STRING             (3)                 
#define LL_EXPRTYPE_BOOL               (4)                 
#define LL_EXPRTYPE_DRAWING            (5)                 
#define LL_EXPRTYPE_BARCODE            (6)                 
#define LL_OPTION_NEWEXPRESSIONS       (0)                  /* default: TRUE */
#define LL_OPTION_ONLYONETABLE         (1)                  /* default: FALSE */
#define LL_OPTION_TABLE_COLORING       (2)                  /* default: LL_COLORING_LL */
#define LL_COLORING_LL                 (0)                 
#define LL_COLORING_PROGRAM            (1)                 
#define LL_COLORING_DONTCARE           (2)                 
#define LL_OPTION_SUPERVISOR           (3)                  /* default: FALSE */
#define LL_OPTION_UNITS                (4)                  /* default: see LL_OPTION_METRIC */
#define LL_OPTION_TABSTOPS             (5)                  /* default: LL_TABS_DELETE */
#define LL_TABS_DELETE                 (0)                 
#define LL_TABS_EXPAND                 (1)                 
#define LL_OPTION_CALLBACKMASK         (6)                  /* default: 0x00000000 */
#define LL_CB_PAGE                     (0x40000000)         /* callback for each page */
#define LL_CB_PROJECT                  (0x20000000)         /* callback for each label */
#define LL_CB_OBJECT                   (0x10000000)         /* callback for each object */
#define LL_CB_HELP                     (0x08000000)         /* callback for HELP (F1/Button) */
#define LL_CB_TABLELINE                (0x04000000)         /* callback for table line */
#define LL_CB_TABLEFIELD               (0x02000000)         /* callback for table field */
#define LL_CB_QUERY_IS_VARIABLE_OR_FIELD (0x01000000)         /* callback for delayload (LL_QUERY_IS_VARIABLE_OR_FIELD) */
#define LL_OPTION_CALLBACKPARAMETER    (7)                  /* default: 0 */
#define LL_OPTION_HELPAVAILABLE        (8)                  /* default: TRUE */
#define LL_OPTION_SORTVARIABLES        (9)                  /* default: TRUE */
#define LL_OPTION_SUPPORTPAGEBREAK     (10)                 /* default: TRUE */
#define LL_OPTION_SHOWPREDEFVARS       (11)                 /* default: TRUE */
#define LL_OPTION_USEHOSTPRINTER       (13)                 /* default: FALSE // use host printer via callback */
#define LL_OPTION_EXTENDEDEVALUATION   (14)                 /* allows expressions in chevrons (amwin mode) */
#define LL_OPTION_TABREPRESENTATIONCODE (15)                 /* default: 247 (0xf7) */
#define LL_OPTION_METRIC               (18)                 /* default: depends on Windows defaults */
#define LL_OPTION_ADDVARSTOFIELDS      (19)                 /* default: FALSE */
#define LL_OPTION_MULTIPLETABLELINES   (20)                 /* default: TRUE */
#define LL_OPTION_CONVERTCRLF          (21)                 /* default: FALSE */
#define LL_OPTION_WIZ_FILENEW          (22)                 /* default: FALSE */
#define LL_OPTION_RETREPRESENTATIONCODE (23)                 /* default: LL_CHAR_NEWLINE (182) */
#define LL_OPTION_PRVZOOM_PERC         (25)                 /* initial preview zoom */
#define LL_OPTION_PRVRECT_LEFT         (26)                 /* initial preview position */
#define LL_OPTION_PRVRECT_TOP          (27)                
#define LL_OPTION_PRVRECT_WIDTH        (28)                
#define LL_OPTION_PRVRECT_HEIGHT       (29)                
#define LL_OPTION_STORAGESYSTEM        (30)                 /* 0=LX4-compatible, 1=STORAGE */
#define LL_STG_COMPAT4                 (0)                 
#define LL_STG_STORAGE                 (1)                 
#define LL_OPTION_COMPRESSSTORAGE      (31)                 /* 32 bit, STORAGE only [TRUE/FALSE] */
#define LL_OPTION_NOPARAMETERCHECK     (32)                 /* you need a bit more speed? */
#define LL_OPTION_NONOTABLECHECK       (33)                 /* don't check on "NO_TABLEOBJECT" error */
#define LL_OPTION_DRAWFOOTERLINEONPRINT (34)                 /* delay footerline printing to LlPrint(). Default FALSE */
#define LL_OPTION_PRVZOOM_LEFT         (35)                 /* initial preview position in percent of screen */
#define LL_OPTION_PRVZOOM_TOP          (36)                
#define LL_OPTION_PRVZOOM_WIDTH        (37)                
#define LL_OPTION_PRVZOOM_HEIGHT       (38)                
#define LL_OPTION_SPACEOPTIMIZATION    (40)                 /* default: TRUE */
#define LL_OPTION_REALTIME             (41)                 /* default: FALSE */
#define LL_OPTION_AUTOMULTIPAGE        (42)                 /* default: TRUE */
#define LL_OPTION_USEBARCODESIZES      (43)                 /* default: FALSE */
#define LL_OPTION_MAXRTFVERSION        (44)                 /* default: 0x100 (1.0) */
#define LL_OPTION_VARSCASESENSITIVE    (46)                 /* default: FALSE */
#define LL_OPTION_DELAYTABLEHEADER     (47)                 /* default: FALSE */
#define LL_OPTION_OFNDIALOG_EXPLORER   (48)                 /* default: Win16: FALSE, WIN32: NewShell present */
#define LL_OPTION_OFN_NOPLACESBAR      (0x40000000)        
#define LL_OPTION_EMFRESOLUTION        (49)                 /* default: 100 for 1/100 mm */
#define LL_OPTION_SETCREATIONINFO      (50)                 /* default: TRUE */
#define LL_OPTION_XLATVARNAMES         (51)                 /* default: TRUE */
#define LL_OPTION_LANGUAGE             (52)                 /* returns current language (r/o) */
#define LL_OPTION_PHANTOMSPACEREPRESENTATIONCODE (54)                 /* default: LL_CHAR_PHANTOMSPACE */
#define LL_OPTION_LOCKNEXTCHARREPRESENTATIONCODE (55)                 /* default: LL_CHAR_LOCK */
#define LL_OPTION_EXPRSEPREPRESENTATIONCODE (56)                 /* default: LL_CHAR_EXPRSEP */
#define LL_OPTION_DEFPRINTERINSTALLED  (57)                 /* r/o */
#define LL_OPTION_CALCSUMVARSONINVISIBLELINES (58)                 /* default: FALSE - only default value if no preferences in project */
#define LL_OPTION_NOFOOTERPAGEWRAP     (59)                 /* default: FALSE - only default value if no preferences in project */
#define LL_OPTION_IMMEDIATELASTPAGE    (64)                 /* default: FALSE */
#define LL_OPTION_LCID                 (65)                 /* default: LOCALE_USER_DEFAULT */
#define LL_OPTION_TEXTQUOTEREPRESENTATIONCODE (66)                 /* default: 1 */
#define LL_OPTION_SCALABLEFONTSONLY    (67)                 /* default: TRUE */
#define LL_OPTION_NOTIFICATIONMESSAGEHWND (68)                 /* default: NULL (parent window handle) */
#define LL_OPTION_DEFDEFFONT           (69)                 /* default: GetStockObject(ANSI_VAR_FONT) */
#define LL_OPTION_CODEPAGE             (70)                 /* default: CP_ACP; set codepage to use for conversions. */
#define LL_OPTION_FORCEFONTCHARSET     (71)                 /* default: FALSE; set font's charset to the codepage according to LL_OPTION_LCID. Default: FALSE */
#define LL_OPTION_COMPRESSRTF          (72)                 /* default: TRUE; compress RTF text > 1024 bytes in project file */
#define LL_OPTION_ALLOW_LLX_EXPORTERS  (74)                 /* default: TRUE; allow ILlXExport extensions */
#define LL_OPTION_SUPPORTS_PRNOPTSTR_EXPORT (75)                 /* default: FALSE: hides "set to default" button in "export option" tab in designer */
#define LL_OPTION_DEBUGFLAG            (76)                
#define LL_OPTION_SKIPRETURNATENDOFRTF (77)                 /* default: FALSE */
#define LL_OPTION_INTERCHARSPACING     (78)                 /* default: FALSE: allows character interspacing in case of block justify */
#define LL_OPTION_INCLUDEFONTDESCENT   (79)                 /* default: FALSE (compatibility) */
#define LL_OPTION_RESOLUTIONCOMPATIBLETO9X (80)                 /* default: FALSE (on NT/2K, else TRUE) */
#define LL_OPTION_USECHARTFIELDS       (81)                 /* default: FALSE */
#define LL_OPTION_OFNDIALOG_NOPLACESBAR (82)                 /* default: FALSE; do not use "Places" bar in NT2K? */
#define LL_OPTION_SKETCH_COLORDEPTH    (83)                 /* default: 1 */
#define LL_OPTION_FINAL_TRUE_ON_LASTPAGE (84)                 /* default: FALSE: internal use */
#define LL_OPTION_LLXAUTOSORTAXIS      (85)                 /* default: FALSE */
#define LL_OPTION_INTERCHARSPACING_FORCED (86)                 /* default: FALSE: forces character interspacing calculation in TEXT objects (possibly dangerous and slow) */
#define LL_OPTION_RTFAUTOINCREMENT     (87)                 /* default: FALSE, to increment RTF char pointer if nothing can be printed */
#define LL_OPTION_UNITS_DEFAULT        (88)                 /* default: LL_OPTION_UNITS_SYSDEFAULT. Use for contols that query the units, where we need to return "sysdefault" also */
#define LL_OPTION_NO_MAPI              (89)                 /* default: FALSE. Inhibit MAPI load for preview */
#define LL_OPTION_TOOLBARSTYLE         (90)                 /* default: LL_OPTION_TOOLBARSTYLE_STANDARD|LL_OPTION_TOOLBARSTYLEFLAG_DOCKABLE */
#define LL_OPTION_TOOLBARSTYLE_STANDARD (0)                  /* OFFICE97 alike style */
#define LL_OPTION_TOOLBARSTYLE_OFFICEXP (1)                  /* DOTNET/OFFICE_XP alike style */
#define LL_OPTION_TOOLBARSTYLE_OFFICE2003 (2)                 
#define LL_OPTION_TOOLBARSTYLEMASK     (0x0f)              
#define LL_OPTION_TOOLBARSTYLEFLAG_GRADIENT (0x80)               /* starting with XP, use gradient style */
#define LL_OPTION_TOOLBARSTYLEFLAG_DOCKABLE (0x40)               /* dockable toolbars? */
#define LL_OPTION_TOOLBARSTYLEFLAG_CANCLOSE (0x20)               /* internal use only */
#define LL_OPTION_MENUSTYLE            (91)                 /* default: LL_OPTION_MENUSTYLE_STANDARD */
#define LL_OPTION_MENUSTYLE_STANDARD_WITHOUT_BITMAPS (0)                  /* values: see CTL */
#define LL_OPTION_MENUSTYLE_STANDARD   (1)                 
#define LL_OPTION_MENUSTYLE_OFFICEXP   (2)                 
#define LL_OPTION_MENUSTYLE_OFFICE2003 (3)                 
#define LL_OPTION_RULERSTYLE           (92)                 /* default: LL_OPTION_RULERSTYLE_FLAT */
#define LL_OPTION_RULERSTYLE_FLAT      (0x10)              
#define LL_OPTION_RULERSTYLE_GRADIENT  (0x80)              
#define LL_OPTION_STATUSBARSTYLE       (93)                
#define LL_OPTION_STATUSBARSTYLE_STANDARD (0)                 
#define LL_OPTION_STATUSBARSTYLE_OFFICEXP (1)                 
#define LL_OPTION_STATUSBARSTYLE_OFFICE2003 (2)                 
#define LL_OPTION_TABBARSTYLE          (94)                
#define LL_OPTION_TABBARSTYLE_STANDARD (0)                 
#define LL_OPTION_TABBARSTYLE_OFFICEXP (1)                 
#define LL_OPTION_TABBARSTYLE_OFFICE2003 (2)                 
#define LL_OPTION_DROPWINDOWSTYLE      (95)                
#define LL_OPTION_DROPWINDOWSTYLE_STANDARD (0)                 
#define LL_OPTION_DROPWINDOWSTYLE_OFFICEXP (1)                 
#define LL_OPTION_DROPWINDOWSTYLE_OFFICE2003 (2)                 
#define LL_OPTION_DROPWINDOWSTYLEMASK  (0x0f)              
#define LL_OPTION_DROPWINDOWSTYLEFLAG_CANCLOSE (0x20)              
#define LL_OPTION_INTERFACEWRAPPER     (96)                 /* returns IL<n>* */
#define LL_OPTION_FONTQUALITY          (97)                 /* LOGFONT.lfQuality, default: DEFAULT_QUALITY */
#define LL_OPTION_FONTPRECISION        (98)                 /* LOGFONT.lfOutPrecision, default: OUT_STRING_PRECIS */
#define LL_OPTION_UISTYLE              (99)                 /* UI collection, w/o */
#define LL_OPTION_UISTYLE_STANDARD     (0)                  /* 90=0x40, 91=1, 92=0x10, 93=0, 94=0, 95=0x20 */
#define LL_OPTION_UISTYLE_OFFICEXP     (1)                  /* 90=0x41, 91=2, 92=0x10, 93=1, 94=1, 95=0x21 */
#define LL_OPTION_UISTYLE_OFFICE2003   (2)                  /* 90=0x42, 91=3, 92=0x10, 93=2, 94=2, 95=0x22 */
#define LL_OPTION_NOFILEVERSIONUPGRADEWARNING (100)                /* default: FALSE */
#define LL_OPTION_UPDATE_FOOTER_ON_DATALINEBREAK_AT_FIRST_LINE (101)                /* default: FALSE */
#define LL_OPTION_ESC_CLOSES_PREVIEW   (102)                /* shall ESC close the preview window (default: FALSE) */
#define LL_OPTION_VIEWER_ASSUMES_TEMPFILE (103)                /* shall the viewer assume that the file is a temporary file (and not store values in it)? default TRUE */
#define LL_OPTION_CALC_USED_VARS       (104)                /* default: TRUE */
#define LL_OPTION_BOTTOMALIGNMENT_WIN9X_UNLIKE_NT (105)                /* default: TRUE */
#define LL_OPTION_NOPRINTJOBSUPERVISION (106)                /* default: TRUE */
#define LL_OPTION_CALC_SUMVARS_ON_PARTIAL_LINES (107)                /* default: FALSE */
#define LL_OPTION_BLACKNESS_SCM        (108)                /* default: 0 */
#define LL_OPTION_PROHIBIT_USERINTERACTION (109)                /* default: FALSE */
#define LL_OPTION_PERFMON_INSTALL      (110)                /* w/o, TRUE to install, FALSE to uninstall */
#define LL_OPTION_VARLISTBUCKETCOUNT   (112)                /* applied to future jobs only, default 1000 */
#define LL_OPTION_MSFAXALLOWED         (113)                /* global flag - set at start of LL! Will allow/prohibit fax detection. Default: TRUE */
#define LL_OPTION_AUTOPROFILINGTICKS   (114)                /* global flag - set at start of LL! Activates LL's thread profiling */
#define LL_OPTION_PROJECTBACKUP        (115)                /* default: TRUE */
#define LL_OPTION_ERR_ON_FILENOTFOUND  (116)                /* default: FALSE */
#define LL_OPTION_NOFAXVARS            (117)                /* default: FALSE */
#define LL_OPTION_NOMAILVARS           (118)                /* default: FALSE */
#define LL_OPTION_PATTERNRESCOMPATIBILITY (119)                /* default: FALSE */
#define LL_OPTION_NODELAYEDVALUECACHING (120)                /* default: FALSE */
#define LL_OPTION_FEATURE              (1000)              
#define LL_OPTION_FEATURE_CLEARALL     (0)                 
#define LL_OPTION_FEATURE_SUPPRESS_JPEG_DISPLAY (1)                 
#define LL_OPTION_FEATURE_SUPPRESS_JPEG_CREATION (2)                 
#define LL_OPTION_VARLISTDISPLAY       (121)                /* default: LL_OPTION_VARLISTDISPLAY_VARSORT_DECLARATIONORDER | LL_OPTION_VARLISTDISPLAY_FOLDERPOS_DECLARATIONORDER, see also LL_OPTION_SORTVARIABLES */
#define LL_OPTION_VARLISTDISPLAY_VARSORT_DECLARATIONORDER (0x0000)            
#define LL_OPTION_VARLISTDISPLAY_VARSORT_ALPHA (0x0001)            
#define LL_OPTION_VARLISTDISPLAY_VARSORT_MASK (0x000f)            
#define LL_OPTION_VARLISTDISPLAY_FOLDERPOS_DECLARATIONORDER (0x0000)            
#define LL_OPTION_VARLISTDISPLAY_FOLDERPOS_ALPHA (0x0010)             /* only if LL_OPTION_VARLISTDISPLAY_VARSORT_ALPHA is set */
#define LL_OPTION_VARLISTDISPLAY_FOLDERPOS_TOP (0x0020)            
#define LL_OPTION_VARLISTDISPLAY_FOLDERPOS_BOTTOM (0x0030)            
#define LL_OPTION_VARLISTDISPLAY_FOLDERPOS_MASK (0x00f0)            
#define LL_OPTION_WORKAROUND_RTFBUG_EMPTYFIRSTPAGE (122)               
#define LL_OPTION_FORMULASTRINGCOMPARISONS_CASESENSITIVE (123)                /* default: TRUE */
#define LL_OPTION_FIELDS_IN_PROJECTPARAMETERS (124)                /* default: FALSE */
#define LL_OPTION_CHECKWINDOWTHREADEDNESS (125)                /* default: FALSE */
#define LL_OPTION_ISUSED_WILDCARD_AT_START (126)                /* default: FALSE */
#define LL_OPTION_ROOT_MUST_BE_MASTERTABLE (127)                /* default: FALSE */
#define LL_OPTION_DLLTYPE              (128)                /* r/o */
#define LL_OPTION_DLLTYPE_32BIT        (0x0001)            
#define LL_OPTION_DLLTYPE_64BIT        (0x0002)            
#define LL_OPTION_DLLTYPE_BITMASK      (0x000f)            
#define LL_OPTION_DLLTYPE_SDBCS        (0x0010)            
#define LL_OPTION_DLLTYPE_UNICODE      (0x0020)            
#define LL_OPTION_DLLTYPE_CHARSET      (0x00f0)            
#define LL_OPTION_HLIBRARY             (129)                /* r/o */
#define LL_OPTION_INVERTED_PAGEORIENTATION (130)                /* default: FALSE */
#define LL_OPTION_ENABLE_STANDALONE_DATACOLLECTING_OBJECTS (131)                /* default: FALSE */
#define LL_OPTION_USERVARS_ARE_CODESNIPPETS (132)                /* default: FALSE */
#define LL_OPTION_STORAGE_ADD_SUMMARYINFORMATION (133)                /* default: FALSE */
#define LL_OPTION_RELAX_AT_SHUTDOWN    (134)                /* default: FALSE */
#define LL_OPTION_NOPRINTERPATHCHECK   (135)                /* default: FALSE */
#define LL_OPTION_INTERNAL136          (136)                /* default: FALSE */
#define LL_OPTIONSTR_LABEL_PRJEXT      (0)                  /* internal... (compatibility to L6) */
#define LL_OPTIONSTR_LABEL_PRVEXT      (1)                  /* internal... (compatibility to L6) */
#define LL_OPTIONSTR_LABEL_PRNEXT      (2)                  /* internal... (compatibility to L6) */
#define LL_OPTIONSTR_CARD_PRJEXT       (3)                  /* internal... (compatibility to L6) */
#define LL_OPTIONSTR_CARD_PRVEXT       (4)                  /* internal... (compatibility to L6) */
#define LL_OPTIONSTR_CARD_PRNEXT       (5)                  /* internal... (compatibility to L6) */
#define LL_OPTIONSTR_LIST_PRJEXT       (6)                  /* internal... (compatibility to L6) */
#define LL_OPTIONSTR_LIST_PRVEXT       (7)                  /* internal... (compatibility to L6) */
#define LL_OPTIONSTR_LIST_PRNEXT       (8)                  /* internal... (compatibility to L6) */
#define LL_OPTIONSTR_LLXPATHLIST       (12)                
#define LL_OPTIONSTR_SHORTDATEFORMAT   (13)                
#define LL_OPTIONSTR_DECIMAL           (14)                 /* decimal point, default: system */
#define LL_OPTIONSTR_THOUSAND          (15)                 /* thousands separator, default: system */
#define LL_OPTIONSTR_CURRENCY          (16)                 /* currency symbol, default: system */
#define LL_OPTIONSTR_EXPORTS_AVAILABLE (17)                 /* r/o */
#define LL_OPTIONSTR_EXPORTS_ALLOWED   (18)                
#define LL_OPTIONSTR_DEFDEFFONT        (19)                 /* in "{(r,g,b),size,<logfont>}" */
#define LL_OPTIONSTR_EXPORTFILELIST    (20)                
#define LL_OPTIONSTR_VARALIAS          (21)                 /* "<local>=<global>" */
#define LL_OPTIONSTR_MAILTO            (24)                 /* default TO: address for mailing from viewer */
#define LL_OPTIONSTR_MAILTO_CC         (25)                 /* default CC: address for mailing from viewer */
#define LL_OPTIONSTR_MAILTO_BCC        (26)                 /* default BCC: address for mailing from viewer */
#define LL_OPTIONSTR_MAILTO_SUBJECT    (27)                 /* default subject for mailing from viewer */
#define LL_OPTIONSTR_SAVEAS_PATH       (28)                 /* default filename for saving the LL file from viewer */
#define LL_OPTIONSTR_LABEL_PRJDESCR    (29)                 /* "Etikett" ... */
#define LL_OPTIONSTR_CARD_PRJDESCR     (30)                
#define LL_OPTIONSTR_LIST_PRJDESCR     (31)                
#define LL_OPTIONSTR_LLFILEDESCR       (32)                 /* "Vorschau-Datei" */
#define LL_OPTIONSTR_PROJECTPASSWORD   (33)                 /* w/o, of course :) */
#define LL_OPTIONSTR_FAX_RECIPNAME     (34)                
#define LL_OPTIONSTR_FAX_RECIPNUMBER   (35)                
#define LL_OPTIONSTR_FAX_QUEUENAME     (36)                
#define LL_OPTIONSTR_FAX_SENDERNAME    (37)                
#define LL_OPTIONSTR_FAX_SENDERCOMPANY (38)                
#define LL_OPTIONSTR_FAX_SENDERDEPT    (39)                
#define LL_OPTIONSTR_FAX_SENDERBILLINGCODE (40)                
#define LL_OPTIONSTR_FAX_AVAILABLEQUEUES (42)                 /* r/o (Tab-separated) [job can be -1 or a valid job] */
#define LL_OPTIONSTR_LOGFILEPATH       (43)                
#define LL_OPTIONSTR_LICENSINGINFO     (44)                 /* w/o, SERNO to define licensing state */
#define LL_OPTIONSTR_PRINTERALIASLIST  (45)                 /* multiple "PrnOld=PrnNew1[;PrnNew2[;...]]", erase with NULL or "" */
#define LL_OPTIONSTR_PREVIEWFILENAME   (46)                 /* path of preview file (directory will be overridden by LlSetPrinterDefaultsDir(), if given) */
#define LL_OPTIONSTR_EXPORTS_ALLOWED_IN_PREVIEW (47)                 /* set in preview file */
#define LL_OPTIONSTR_HELPFILENAME      (48)                
#define LL_OPTIONSTR_NULLVALUE         (49)                 /* string which represents the NULL value */
#define LL_OPTIONSTR_DEFAULT_EXPORT    (50)                 /* default export medium for new projects */
#define LL_SYSCOMMAND_MINIMIZE         (-1)                
#define LL_SYSCOMMAND_MAXIMIZE         (-2)                
#define LL_DLGBOXMODE_3DBUTTONS        (0x8000)             /* 'or'ed */
#define LL_DLGBOXMODE_3DFRAME2         (0x4000)             /* 'OR'ed */
#define LL_DLGBOXMODE_3DFRAME          (0x1000)             /* 'OR'ed */
#define LL_DLGBOXMODE_NOBITMAPS        (0x2000)             /* 'or'ed */
#define LL_DLGBOXMODE_DONTCARE         (0x0000)             /* load from INI */
#define LL_DLGBOXMODE_SAA              (0x0001)            
#define LL_DLGBOXMODE_ALT1             (0x0002)            
#define LL_DLGBOXMODE_ALT2             (0x0003)            
#define LL_DLGBOXMODE_ALT3             (0x0004)            
#define LL_DLGBOXMODE_ALT4             (0x0005)            
#define LL_DLGBOXMODE_ALT5             (0x0006)            
#define LL_DLGBOXMODE_ALT6             (0x0007)            
#define LL_DLGBOXMODE_ALT7             (0x0008)            
#define LL_DLGBOXMODE_ALT8             (0x0009)             /* Win95 */
#define LL_DLGBOXMODE_ALT9             (0x000A)             /* Win98 */
#define LL_DLGBOXMODE_ALT10            (0x000B)             /* Win98 with gray/color button bitmaps like IE4 */
#define LL_DLGBOXMODE_TOOLTIPS98       (0x0800)             /* 'OR'ed - sliding tooltips */
#define LL_CTL_ADDTOSYSMENU            (0x00000004)         /* from CTL */
#define LL_CTL_ALSOCHILDREN            (0x00000010)        
#define LL_CTL_CONVERTCONTROLS         (0x00010000)        
#define LL_GROUP_ALWAYSFOOTER          (0x40000000)        
#define LL_PRINTERCONFIG_SAVE          (1)                 
#define LL_PRINTERCONFIG_RESTORE       (2)                 
#define LL_RTFTEXTMODE_RTF             (0x0000)            
#define LL_RTFTEXTMODE_PLAIN           (0x0001)            
#define LL_RTFTEXTMODE_EVALUATED       (0x0000)            
#define LL_RTFTEXTMODE_RAW             (0x0002)            
#define LL_ERR_BAD_JOBHANDLE           (-1)                 /* bad jobhandle */
#define LL_ERR_TASK_ACTIVE             (-2)                 /* LlDefineLayout() only once in a job */
#define LL_ERR_BAD_OBJECTTYPE          (-3)                 /* nObjType must be one of the allowed values (obsolete constant) */
#define LL_ERR_BAD_PROJECTTYPE         (-3)                 /* nObjType must be one of the allowed values */
#define LL_ERR_PRINTING_JOB            (-4)                 /* print job not opened, no print object */
#define LL_ERR_NO_BOX                  (-5)                 /* LlPrintSetBoxText(...) called when no abort box exists! */
#define LL_ERR_ALREADY_PRINTING        (-6)                 /* LlPrintWithBoxStart(...): another print job is being done, please wait or try LlPrintStart(...) */
#define LL_ERR_NOT_YET_PRINTING        (-7)                 /* LlPrintGetOptionString... */
#define LL_ERR_NO_PROJECT              (-10)                /* object with requested name does not exist (former ERR_NO_OBJECT) */
#define LL_ERR_NO_PRINTER              (-11)                /* printer couldn't be opened */
#define LL_ERR_PRINTING                (-12)                /* error while printing */
#define LL_ERR_EXPORTING               (-13)                /* error while exporting */
#define LL_ERR_NEEDS_VB                (-14)                /* '11...' needs VB.EXE */
#define LL_ERR_BAD_PRINTER             (-15)                /* PrintOptionsDialog(): no printer available */
#define LL_ERR_NO_PREVIEWMODE          (-16)                /* Preview functions: not in preview mode */
#define LL_ERR_NO_PREVIEWFILES         (-17)                /* PreviewDisplay(): no file found */
#define LL_ERR_PARAMETER               (-18)                /* bad parameter (usually NULL pointer) */
#define LL_ERR_BAD_EXPRESSION          (-19)                /* bad expression in LlExprEvaluate() and LlExprType() */
#define LL_ERR_BAD_EXPRMODE            (-20)                /* bad expression mode (LlSetExpressionMode()) */
#define LL_ERR_NO_TABLE                (-21)                /* not used */
#define LL_ERR_CFGNOTFOUND             (-22)                /* on LlPrintStart(), LlPrintWithBoxStart() [not found] */
#define LL_ERR_EXPRESSION              (-23)                /* on LlPrintStart(), LlPrintWithBoxStart() */
#define LL_ERR_CFGBADFILE              (-24)                /* on LlPrintStart(), LlPrintWithBoxStart() [read error, bad format] */
#define LL_ERR_BADOBJNAME              (-25)                /* on LlPrintEnableObject() - not a ':' at the beginning */
#define LL_ERR_NOOBJECT                (-26)                /* on LlPrintEnableObject() - "*" and no object in project */
#define LL_ERR_UNKNOWNOBJECT           (-27)                /* on LlPrintEnableObject() - object with that name not existing */
#define LL_ERR_NO_TABLEOBJECT          (-28)                /* LlPrint...Start() and no list in Project, or: */
#define LL_ERR_NO_OBJECT               (-29)                /* LlPrint...Start() and no object in project */
#define LL_ERR_NO_TEXTOBJECT           (-30)                /* LlPrintGetTextCharsPrinted() and no printable text in Project! */
#define LL_ERR_UNKNOWN                 (-31)                /* LlPrintIsVariableUsed(), LlPrintIsFieldUsed() */
#define LL_ERR_BAD_MODE                (-32)                /* LlPrintFields(), LlPrintIsFieldUsed() called on non-OBJECT_LIST */
#define LL_ERR_CFGBADMODE              (-33)                /* on LlDefineLayout(), LlPrint...Start(): file is in wrong expression mode */
#define LL_ERR_ONLYWITHONETABLE        (-34)                /* on LlDefinePageSeparation(), LlDefineGrouping() */
#define LL_ERR_UNKNOWNVARIABLE         (-35)                /* on LlGetVariableContents() */
#define LL_ERR_UNKNOWNFIELD            (-36)                /* on LlGetFieldContents() */
#define LL_ERR_UNKNOWNSORTORDER        (-37)                /* on LlGetFieldContents() */
#define LL_ERR_NOPRINTERCFG            (-38)                /* on LlPrintCopyPrinterConfiguration() - no or bad file */
#define LL_ERR_SAVEPRINTERCFG          (-39)                /* on LlPrintCopyPrinterConfiguration() - file could not be saved */
#define LL_ERR_RESERVED                (-40)                /* function not yet implemeted */
#define LL_ERR_NOVALIDPAGES            (-41)                /* could also be that 16 bit Viewer tries to open 32bit-only storage */
#define LL_ERR_NOTINHOSTPRINTERMODE    (-42)                /* cannot be done in Host Printer Mode (LlSetPrinterInPrinterFile()) */
#define LL_ERR_NOTFINISHED             (-43)                /* appears when a project reset() is done, but the table not finished */
#define LL_ERR_BUFFERTOOSMALL          (-44)                /* LlXXGetOptionStr() */
#define LL_ERR_BADCODEPAGE             (-45)                /* LL_OPTION_CODEPAGE */
#define LL_ERR_CANNOTCREATETEMPFILE    (-46)                /* cannot create temporary file */
#define LL_ERR_NODESTINATION           (-47)                /* no valid export destination */
#define LL_ERR_NOCHART                 (-48)                /* no chart control present */
#define LL_ERR_TOO_MANY_CONCURRENT_PRINTJOBS (-49)                /* WebServer: not enough print process licenses */
#define LL_ERR_BAD_WEBSERVER_LICENSE   (-50)                /* WebServer: bad license file */
#define LL_ERR_NO_WEBSERVER_LICENSE    (-51)                /* WebServer: no license file */
#define LL_ERR_INVALIDDATE             (-52)                /* LlSystemTimeFromLocaleString(): date not valid! */
#define LL_ERR_DRAWINGNOTFOUND         (-53)                /* only if LL_OPTION_ERR_ON_FILENOTFOUND set */
#define LL_ERR_NOUSERINTERACTION       (-54)                /* a call is used which would show a dialog, but LL is in Webserver mode */
#define LL_ERR_BADDATABASESTRUCTURE    (-55)                /* the project that is loading has a table that is not supported by the database */
#define LL_ERR_UNKNOWNPROPERTY         (-56)               
#define LL_ERR_INVALIDOPERATION        (-57)               
#define LL_ERR_USER_ABORTED            (-99)                /* user aborted printing */
#define LL_ERR_BAD_DLLS                (-100)               /* DLLs not up to date (CTL, DWG, UTIL) */
#define LL_ERR_NO_LANG_DLL             (-101)               /* no or out-of-date language resource DLL */
#define LL_ERR_NO_MEMORY               (-102)               /* out of memory */
#define LL_ERR_EXCEPTION               (-104)               /* there was a GPF during the API execution. Any action that follows might cause problems! */
#define LL_ERR_LICENSEVIOLATION        (-105)               /* your license does not allow this call (see LL_OPTIONSTR_LICENSINGINFO) */
#define LL_ERR_NOT_SUPPORTED_IN_THIS_OS (-106)               /* the OS does not support this function */
#define LL_WRN_ISNULL                  (-995)               /* LlExprEvaluate[Var]() */
#define LL_WRN_TABLECHANGE             (-996)              
#define LL_WRN_PRINTFINISHED           (-997)               /* LlRTFDisplay() */
#define LL_WRN_REPEAT_DATA             (-998)               /* notification: page is full, prepare for next page */
#define LL_CHAR_TEXTQUOTE              (1)                 
#define LL_CHAR_PHANTOMSPACE           (2)                 
#define LL_CHAR_LOCK                   (3)                 
#define LL_CHAR_NEWLINE                (182)                /* "¶" */
#define LL_CHAR_EXPRSEP                (164)                /* "¤" */
#define LL_CHAR_TAB                    (247)                /* "÷" */
#define LL_CHAR_EAN128NUL              (255)               
#define LL_CHAR_EAN128FNC1             (254)               
#define LL_CHAR_EAN128FNC2             (253)               
#define LL_CHAR_EAN128FNC3             (252)               
#define LL_CHAR_EAN128FNC4             (251)               
#define LL_CHAR_CODE93NUL              (255)               
#define LL_CHAR_CODE93EXDOLLAR         (254)               
#define LL_CHAR_CODE93EXPERC           (253)               
#define LL_CHAR_CODE93EXSLASH          (252)               
#define LL_CHAR_CODE93EXPLUS           (251)               
#define LL_CHAR_CODE39NUL              (255)               
#define LL_DLGEXPR_VAREXTBTN_ENABLE    (0x00000001)         /* callback for simple Wizard extension */
#define LL_DLGEXPR_VAREXTBTN_DOMODAL   (0x00000002)        
#define LL_LLX_EXTENSIONTYPE_EXPORT    (1)                 
#define LL_LLX_EXTENSIONTYPE_BARCODE   (2)                 
#define LL_LLX_EXTENSIONTYPE_OBJECT    (3)                  /* nyi */
#define LL_LLX_EXTENSIONTYPE_WIZARD    (4)                  /* nyi */
#define LL_DECLARECHARTROW_FOR_OBJECTS (0x00000001)        
#define LL_DECLARECHARTROW_FOR_TABLECOLUMNS (0x00000002)         /* body only */
#define LL_DECLARECHARTROW_FOR_TABLECOLUMNS_FOOTERS (0x00000004)        
#define LL_GETCHARTOBJECTCOUNT_CHARTOBJECTS (1)                 
#define LL_GETCHARTOBJECTCOUNT_CHARTOBJECTS_BEFORE_TABLE (2)                 
#define LL_GETCHARTOBJECTCOUNT_CHARTCOLUMNS (3)                  /* body only */
#define LL_GETCHARTOBJECTCOUNT_CHARTCOLUMNS_FOOTERS (4)                 
#define LL_GRIPT_DIM_SCM               (1)                 
#define LL_GRIPT_DIM_PERC              (2)                 
#define LL_PARAMETERFLAG_PUBLIC        (0x00000000)        
#define LL_PARAMETERFLAG_PRIVATE       (0x40000000)        
#define LL_PARAMETERFLAG_FORMULA       (0x00000000)        
#define LL_PARAMETERFLAG_VALUE         (0x20000000)        
#define LL_PARAMETERFLAG_GLOBAL        (0x00000000)        
#define LL_PARAMETERFLAG_LOCAL         (0x10000000)        
#define LL_PARAMETERFLAG_MASK          (0xffff0000)        
#define LL_PARAMETERTYPE_USER          (0)                 
#define LL_PARAMETERTYPE_FAX           (1)                 
#define LL_PARAMETERTYPE_MAIL          (2)                 
#define LL_PARAMETERTYPE_LLINTERNAL    (4)                 
#define LL_PARAMETERTYPE_MASK          (0x0000000f)        

#endif  /* #ifndef _LL12_CH */

