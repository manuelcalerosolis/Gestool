/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\SQLXbrowse.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( SQLXBROWSE );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TXBROWSE );
HB_FUNC_STATIC( SQLXBROWSE_NEW );
HB_FUNC_STATIC( SQLXBROWSE_SETMODEL );
HB_FUNC_STATIC( SQLXBROWSE_GETCOLUMNHEADERS );
HB_FUNC_STATIC( SQLXBROWSE_SELECTCOLUMNORDER );
HB_FUNC_STATIC( SQLXBROWSE_GETCOLUMNHEADER );
HB_FUNC_STATIC( SQLXBROWSE_GETCOLUMNORDER );
HB_FUNC_STATIC( SQLXBROWSE_RBUTTONDOWN );
HB_FUNC_STATIC( SQLXBROWSE_EXPORTTOEXCEL );
HB_FUNC_STATIC( SQLXBROWSE_MAKETOTALS );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( MENUBEGIN );
HB_FUNC_EXTERN( MENUADDITEM );
HB_FUNC_EXTERN( LEN );
HB_FUNC_STATIC( GENMENUBLOCK );
HB_FUNC_EXTERN( MENUEND );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( CURSORWAIT );
HB_FUNC_EXTERN( CURSORWE );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( ERRORMESSAGE );
HB_FUNC_EXTERN( VALTYPE );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( AADD );
HB_FUNC_EXTERN( ADEL );
HB_FUNC_EXTERN( ASIZE );
HB_FUNC_EXTERN( RECNO );
HB_FUNC_EXTERN( IFNIL );
HB_FUNC_EXTERN( MIN );
HB_FUNC_EXTERN( MAX );
HB_FUNC_EXTERN( LAND );
HB_FUNC_EXTERN( DBGOTO );
HB_FUNC_EXTERN( AEVAL );
HB_FUNC_EXTERN( ASCAN );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_SQLXBROWSE )
{ "SQLXBROWSE", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( SQLXBROWSE )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TXBROWSE", {HB_FS_PUBLIC}, {HB_FUNCNAME( TXBROWSE )}, NULL },
{ "ADDMULTICLSDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BBOOKMARK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLXBROWSE_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLXBROWSE_NEW )}, NULL },
{ "SQLXBROWSE_SETMODEL", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLXBROWSE_SETMODEL )}, NULL },
{ "RESTORESTATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CORIGINAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CORIGINAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SAVESTATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SELECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLXBROWSE_GETCOLUMNHEADERS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLXBROWSE_GETCOLUMNHEADERS )}, NULL },
{ "SQLXBROWSE_SELECTCOLUMNORDER", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLXBROWSE_SELECTCOLUMNORDER )}, NULL },
{ "SQLXBROWSE_GETCOLUMNHEADER", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLXBROWSE_GETCOLUMNHEADER )}, NULL },
{ "SQLXBROWSE_GETCOLUMNORDER", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLXBROWSE_GETCOLUMNORDER )}, NULL },
{ "SQLXBROWSE_RBUTTONDOWN", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLXBROWSE_RBUTTONDOWN )}, NULL },
{ "SQLXBROWSE_EXPORTTOEXCEL", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLXBROWSE_EXPORTTOEXCEL )}, NULL },
{ "SQLXBROWSE_MAKETOTALS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLXBROWSE_MAKETOTALS )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SUPER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LAUTOSORT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_L2007", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BCLRSEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BCLRSELFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LSORTDESCEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MENUBEGIN", {HB_FS_PUBLIC}, {HB_FUNCNAME( MENUBEGIN )}, NULL },
{ "BMENUSELECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BMENUSELECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MENUADDITEM", {HB_FS_PUBLIC}, {HB_FUNCNAME( MENUADDITEM )}, NULL },
{ "ACOLS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LHIDE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "ADISPLAY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NPOS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GENMENUBLOCK", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( GENMENUBLOCK )}, NULL },
{ "MENUEND", {HB_FS_PUBLIC}, {HB_FUNCNAME( MENUEND )}, NULL },
{ "SELECTALL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SELECTNONE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EXPORTTOEXCEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SHOW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HIDE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NDATATYPE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BGOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OROWSET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BGOBOTTOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOBOTTOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BBOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BEOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BSKIP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SKIPPER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BKEYNO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECNO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BBOOKMARK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BKEYCOUNT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECCOUNT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OVSCROLL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETRANGE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LFASTEDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "CURSORWAIT", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURSORWAIT )}, NULL },
{ "TOEXCEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CURSORWE", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURSORWE )}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "ERRORMESSAGE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORMESSAGE )}, NULL },
{ "VALTYPE", {HB_FS_PUBLIC}, {HB_FUNCNAME( VALTYPE )}, NULL },
{ "NTOTAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "NFOOTERTYPE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( AADD )}, NULL },
{ "ADEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADEL )}, NULL },
{ "ASIZE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASIZE )}, NULL },
{ "_NFOOTERTYPE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NTOTAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NTOTALSQ", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NCOUNT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECNO", {HB_FS_PUBLIC}, {HB_FUNCNAME( RECNO )}, NULL },
{ "BGOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "IFNIL", {HB_FS_PUBLIC}, {HB_FUNCNAME( IFNIL )}, NULL },
{ "BSUMCONDITION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NCOUNT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MIN", {HB_FS_PUBLIC}, {HB_FUNCNAME( MIN )}, NULL },
{ "MAX", {HB_FS_PUBLIC}, {HB_FUNCNAME( MAX )}, NULL },
{ "LAND", {HB_FS_PUBLIC}, {HB_FUNCNAME( LAND )}, NULL },
{ "NTOTALSQ", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SKIP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBGOTO", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBGOTO )}, NULL },
{ "_AHEADERS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AEVAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( AEVAL )}, NULL },
{ "AHEADERS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CSORTORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ASCAN", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASCAN )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_SQLXBROWSE, ".\\.\\Prg\\SQLXbrowse.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_SQLXBROWSE
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_SQLXBROWSE )
   #include "hbiniseg.h"
#endif

HB_FUNC( SQLXBROWSE )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,118,0,36,14,0,103,2,0,100,8,
		29,236,3,176,1,0,104,2,0,12,1,29,225,3,
		166,163,3,0,122,80,1,48,2,0,176,3,0,12,
		0,106,11,83,81,76,88,66,114,111,119,115,101,0,
		108,4,4,1,0,108,0,112,3,80,2,36,16,0,
		48,5,0,95,2,106,8,76,79,71,73,67,65,76,
		0,100,95,1,121,72,92,32,72,121,72,121,72,106,
		12,108,82,101,103,105,115,116,101,114,101,100,0,4,
		1,0,9,112,5,73,36,18,0,48,6,0,95,2,
		106,10,67,72,65,82,65,67,84,69,82,0,106,1,
		0,95,1,121,72,121,72,121,72,106,10,99,79,114,
		105,103,105,110,97,108,0,4,1,0,9,112,5,73,
		36,19,0,48,6,0,95,2,106,10,67,72,65,82,
		65,67,84,69,82,0,106,1,0,95,1,121,72,121,
		72,121,72,106,6,99,78,97,109,101,0,4,1,0,
		9,112,5,73,36,21,0,48,6,0,95,2,106,6,
		65,82,82,65,89,0,4,0,0,95,1,121,72,121,
		72,121,72,106,9,97,72,101,97,100,101,114,115,0,
		4,1,0,9,112,5,73,36,23,0,48,6,0,95,
		2,106,6,76,79,71,73,67,0,9,95,1,121,72,
		121,72,121,72,106,11,108,79,110,80,114,111,99,101,
		115,115,0,4,1,0,9,112,5,73,36,25,0,48,
		6,0,95,2,100,100,95,1,121,72,121,72,121,72,
		106,12,110,86,83,99,114,111,108,108,80,111,115,0,
		4,1,0,9,112,5,73,36,27,0,48,7,0,95,
		2,106,9,66,111,111,107,77,97,114,107,0,89,20,
		0,1,0,0,0,48,8,0,48,9,0,95,1,112,
		0,112,0,6,95,1,121,72,121,72,121,72,112,3,
		73,36,28,0,48,7,0,95,2,106,10,95,66,111,
		111,107,77,97,114,107,0,89,22,0,2,0,0,0,
		48,8,0,48,9,0,95,1,112,0,95,2,112,1,
		6,95,1,121,72,121,72,121,72,112,3,73,36,30,
		0,48,10,0,95,2,106,4,78,101,119,0,108,11,
		95,1,121,72,121,72,121,72,112,3,73,36,32,0,
		48,10,0,95,2,106,9,115,101,116,77,111,100,101,
		108,0,108,12,95,1,121,72,121,72,121,72,112,3,
		73,36,34,0,48,7,0,95,2,106,12,115,101,116,
		79,114,105,103,105,110,97,108,0,89,22,0,1,0,
		0,0,48,13,0,95,1,48,14,0,95,1,112,0,
		112,1,6,95,1,121,72,121,72,121,72,112,3,73,
		36,35,0,48,7,0,95,2,106,12,103,101,116,79,
		114,105,103,105,110,97,108,0,89,22,0,1,0,0,
		0,48,15,0,95,1,48,16,0,95,1,112,0,112,
		1,6,95,1,121,72,121,72,121,72,112,3,73,36,
		37,0,48,7,0,95,2,106,15,114,101,102,114,101,
		115,104,67,117,114,114,101,110,116,0,89,33,0,1,
		0,0,0,48,17,0,95,1,112,0,73,48,18,0,
		95,1,121,112,1,73,48,18,0,95,1,122,112,1,
		6,95,1,121,72,121,72,121,72,112,3,73,36,39,
		0,48,10,0,95,2,106,17,103,101,116,67,111,108,
		117,109,110,72,101,97,100,101,114,115,0,108,19,95,
		1,121,72,121,72,121,72,112,3,73,36,40,0,48,
		10,0,95,2,106,18,115,101,108,101,99,116,67,111,
		108,117,109,110,79,114,100,101,114,0,108,20,95,1,
		121,72,121,72,121,72,112,3,73,36,42,0,48,10,
		0,95,2,106,16,103,101,116,67,111,108,117,109,110,
		72,101,97,100,101,114,0,108,21,95,1,121,72,121,
		72,121,72,112,3,73,36,43,0,48,10,0,95,2,
		106,15,103,101,116,67,111,108,117,109,110,79,114,100,
		101,114,0,108,22,95,1,121,72,121,72,121,72,112,
		3,73,36,45,0,48,10,0,95,2,106,12,82,66,
		117,116,116,111,110,68,111,119,110,0,108,23,95,1,
		121,72,121,72,121,72,112,3,73,36,47,0,48,10,
		0,95,2,106,14,69,120,112,111,114,116,84,111,69,
		120,99,101,108,0,108,24,95,1,121,72,121,72,121,
		72,112,3,73,36,49,0,48,10,0,95,2,106,11,
		77,97,107,101,84,111,116,97,108,115,0,108,25,95,
		1,121,72,121,72,121,72,112,3,73,36,51,0,48,
		26,0,95,2,112,0,73,167,14,0,0,176,27,0,
		104,2,0,95,2,20,2,168,48,28,0,95,2,112,
		0,80,3,176,29,0,95,3,106,10,73,110,105,116,
		67,108,97,115,115,0,12,2,28,12,48,30,0,95,
		3,164,146,1,0,73,95,3,110,7,48,28,0,103,
		2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLXBROWSE_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,57,0,48,2,0,48,31,0,102,112,
		0,95,1,112,1,73,36,59,0,48,32,0,102,120,
		112,1,73,36,60,0,48,33,0,102,9,112,1,73,
		36,61,0,48,34,0,102,90,12,121,97,229,229,229,
		0,4,2,0,6,112,1,73,36,62,0,48,35,0,
		102,90,12,121,97,167,205,240,0,4,2,0,6,112,
		1,73,36,63,0,48,36,0,102,9,112,1,73,36,
		65,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLXBROWSE_RBUTTONDOWN )
{
	static const HB_BYTE pcode[] =
	{
		13,4,3,36,72,0,102,80,4,36,78,0,176,37,
		0,120,12,1,80,6,36,79,0,48,38,0,95,4,
		112,0,80,7,36,81,0,48,39,0,95,4,100,112,
		1,73,36,83,0,176,40,0,106,9,67,111,108,117,
		109,110,97,115,0,106,32,67,111,108,117,109,110,97,
		115,32,100,101,32,108,97,32,114,101,106,105,108,108,
		97,32,100,101,32,100,97,116,111,115,0,9,120,100,
		100,106,29,103,99,95,116,97,98,108,101,95,115,101,
		108,101,99,116,105,111,110,95,99,111,108,117,109,110,
		95,49,54,0,95,6,20,8,36,85,0,176,37,0,
		9,100,100,9,9,100,100,100,100,100,100,100,100,100,
		100,100,9,120,9,120,20,20,36,87,0,48,41,0,
		95,4,112,0,96,5,0,129,1,1,28,66,36,88,
		0,176,40,0,48,42,0,95,5,112,0,100,48,43,
		0,95,5,112,0,68,176,44,0,48,45,0,95,4,
		112,0,12,1,122,69,21,31,12,73,48,46,0,95,
		5,112,0,122,69,176,47,0,95,5,12,1,20,5,
		36,89,0,130,31,194,132,36,91,0,176,48,0,20,
		0,36,93,0,176,40,0,106,18,83,101,108,101,99,
		99,105,111,110,97,114,32,38,116,111,100,111,0,47,
		106,41,83,101,108,101,99,99,105,111,110,97,32,116,
		111,100,97,115,32,108,97,115,32,102,105,108,97,115,
		32,100,101,32,108,97,32,114,101,106,105,108,108,97,
		0,9,120,89,17,0,0,0,1,0,4,0,48,49,
		0,95,255,112,0,6,100,106,26,103,99,95,116,97,
		98,108,101,95,115,101,108,101,99,116,105,111,110,95,
		97,108,108,95,49,54,0,95,6,20,8,36,95,0,
		176,40,0,106,18,38,81,117,105,116,97,114,32,115,
		101,108,101,99,99,105,243,110,0,47,106,52,81,117,
		105,116,97,32,108,97,32,115,101,108,101,99,99,105,
		243,110,32,100,101,32,116,111,100,97,115,32,108,97,
		115,32,102,105,108,97,115,32,100,101,32,108,97,32,
		114,101,106,105,108,108,97,0,9,120,89,17,0,0,
		0,1,0,4,0,48,50,0,95,255,112,0,6,100,
		106,12,103,99,95,116,97,98,108,101,95,49,54,0,
		95,6,20,8,36,97,0,176,40,0,20,0,36,99,
		0,176,40,0,106,18,69,120,112,111,114,116,97,114,
		32,97,32,69,38,120,99,101,108,0,47,106,34,69,
		120,112,111,114,116,97,114,32,114,101,106,105,108,108,
		97,32,100,101,32,100,97,116,111,115,32,97,32,69,
		120,99,101,108,0,9,120,89,17,0,0,0,1,0,
		4,0,48,51,0,95,255,112,0,6,100,106,22,103,
		99,95,115,112,114,101,97,100,115,104,101,101,116,95,
		115,117,109,95,49,54,0,95,6,20,8,36,101,0,
		176,48,0,20,0,36,103,0,48,52,0,95,6,95,
		1,95,2,95,4,112,3,73,36,105,0,48,39,0,
		95,4,95,7,112,1,73,36,107,0,48,53,0,95,
		6,112,0,73,36,109,0,48,54,0,95,4,112,0,
		73,36,111,0,95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( GENMENUBLOCK )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,117,0,89,35,0,0,0,1,0,1,
		0,48,43,0,95,255,112,0,28,11,48,55,0,95,
		255,112,0,25,9,48,56,0,95,255,112,0,6,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLXBROWSE_SETMODEL )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,123,0,48,32,0,102,9,112,1,73,
		36,124,0,48,57,0,102,93,0,16,112,1,73,36,
		125,0,48,58,0,102,89,22,0,0,0,1,0,1,
		0,48,59,0,48,60,0,95,255,112,0,112,0,6,
		112,1,73,36,126,0,48,61,0,102,89,22,0,0,
		0,1,0,1,0,48,62,0,48,60,0,95,255,112,
		0,112,0,6,112,1,73,36,127,0,48,63,0,102,
		89,22,0,0,0,1,0,1,0,48,64,0,48,60,
		0,95,255,112,0,112,0,6,112,1,73,36,128,0,
		48,65,0,102,89,22,0,0,0,1,0,1,0,48,
		66,0,48,60,0,95,255,112,0,112,0,6,112,1,
		73,36,129,0,48,67,0,102,89,33,0,1,0,1,
		0,1,0,95,1,100,8,28,5,122,80,1,48,68,
		0,48,60,0,95,255,112,0,95,1,112,1,6,112,
		1,73,36,130,0,48,69,0,102,89,22,0,1,0,
		1,0,1,0,48,70,0,48,60,0,95,255,112,0,
		112,0,6,112,1,73,36,131,0,48,71,0,102,89,
		44,0,1,0,1,0,1,0,95,1,100,8,28,16,
		48,70,0,48,60,0,95,255,112,0,112,0,25,16,
		48,72,0,48,60,0,95,255,112,0,95,1,112,1,
		6,112,1,73,36,132,0,48,69,0,102,89,44,0,
		1,0,1,0,1,0,95,1,100,8,28,16,48,70,
		0,48,60,0,95,255,112,0,112,0,25,16,48,72,
		0,48,60,0,95,255,112,0,95,1,112,1,6,112,
		1,73,36,133,0,48,73,0,102,89,22,0,0,0,
		1,0,1,0,48,74,0,48,60,0,95,255,112,0,
		112,0,6,112,1,73,36,135,0,48,75,0,102,112,
		0,100,69,28,30,36,136,0,48,76,0,48,75,0,
		102,112,0,122,48,74,0,48,60,0,95,1,112,0,
		112,0,112,2,73,36,139,0,48,77,0,102,120,112,
		1,73,36,141,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLXBROWSE_EXPORTTOEXCEL )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,150,0,176,78,0,89,15,0,1,0,
		0,0,176,79,0,95,1,12,1,6,12,1,80,2,
		36,151,0,113,34,0,0,36,153,0,176,80,0,20,
		0,36,155,0,48,81,0,102,112,0,73,36,157,0,
		176,82,0,20,0,114,56,0,0,36,159,0,115,80,
		1,36,161,0,176,83,0,106,28,69,114,114,111,114,
		32,101,120,112,111,114,116,97,110,100,111,32,97,32,
		101,120,99,101,108,46,13,10,0,176,84,0,95,1,
		12,1,72,20,1,36,165,0,176,78,0,95,2,20,
		1,36,167,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLXBROWSE_MAKETOTALS )
{
	static const HB_BYTE pcode[] =
	{
		13,6,1,36,174,0,89,12,0,2,0,0,0,95,
		1,100,69,6,80,7,36,176,0,95,1,100,8,28,
		90,36,177,0,4,0,0,80,1,36,178,0,48,41,
		0,102,112,0,96,5,0,129,1,1,28,62,36,179,
		0,95,5,143,36,180,0,176,85,0,144,86,0,112,
		0,12,1,106,2,78,0,8,31,14,176,87,0,144,
		88,0,112,0,12,1,31,14,36,181,0,176,89,0,
		95,1,95,5,20,2,36,182,0,145,36,184,0,130,
		31,198,132,25,105,36,186,0,176,85,0,95,1,12,
		1,106,2,79,0,8,28,12,36,187,0,95,1,4,
		1,0,80,1,36,189,0,122,165,80,3,25,59,36,
		190,0,176,87,0,48,88,0,95,1,95,3,1,112,
		0,12,1,28,33,36,191,0,176,90,0,95,1,95,
		3,20,2,36,192,0,176,91,0,95,1,176,44,0,
		95,1,12,1,122,49,20,2,36,189,0,175,3,0,
		176,44,0,95,1,12,1,15,28,191,36,197,0,176,
		87,0,95,1,12,1,32,2,2,36,199,0,95,1,
		96,5,0,129,1,1,28,105,36,200,0,95,5,143,
		36,201,0,144,88,0,112,0,100,8,28,9,144,92,
		0,122,112,1,73,36,202,0,144,93,0,144,94,0,
		101,0,0,0,0,0,0,0,0,10,1,112,1,112,
		1,73,36,203,0,144,95,0,121,112,1,73,36,204,
		0,144,88,0,112,0,92,2,8,31,12,144,88,0,
		112,0,92,4,8,28,12,36,205,0,144,93,0,100,
		112,1,73,36,206,0,145,36,208,0,130,31,155,132,
		36,210,0,176,44,0,95,1,12,1,80,4,36,212,
		0,85,48,96,0,102,112,0,74,176,97,0,12,0,
		119,80,2,36,214,0,48,8,0,48,98,0,102,112,
		0,112,0,73,36,216,0,95,1,96,5,0,129,1,
		1,29,30,1,36,217,0,95,5,143,36,218,0,144,
		99,0,112,0,80,6,36,219,0,48,8,0,176,100,
		0,144,101,0,112,0,95,7,12,2,95,6,95,5,
		112,2,29,232,0,36,220,0,144,88,0,112,0,92,
		8,8,28,23,36,221,0,144,95,0,21,48,102,0,
		163,0,112,0,23,112,1,73,26,198,0,36,222,0,
		176,85,0,95,6,12,1,106,2,78,0,8,29,180,
		0,36,223,0,144,88,0,112,0,92,2,8,28,39,
		36,224,0,144,93,0,144,86,0,112,0,100,8,28,
		6,95,6,25,14,176,103,0,95,6,144,86,0,112,
		0,12,2,112,1,73,26,130,0,36,225,0,144,88,
		0,112,0,92,4,8,28,38,36,226,0,144,93,0,
		144,86,0,112,0,100,8,28,6,95,6,25,14,176,
		104,0,95,6,144,86,0,112,0,12,2,112,1,73,
		25,80,36,228,0,144,93,0,21,48,86,0,163,0,
		112,0,95,6,72,112,1,73,36,229,0,144,95,0,
		21,48,102,0,163,0,112,0,23,112,1,73,36,230,
		0,176,105,0,144,88,0,112,0,92,25,12,2,28,
		25,36,231,0,144,94,0,21,48,106,0,163,0,112,
		0,95,6,95,6,65,72,112,1,73,36,235,0,145,
		36,237,0,130,32,232,254,132,36,238,0,48,107,0,
		102,122,112,1,122,35,29,202,254,36,240,0,176,87,
		0,48,96,0,102,112,0,12,1,31,21,36,241,0,
		85,48,96,0,102,112,0,74,176,108,0,95,2,20,
		1,74,36,246,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLXBROWSE_GETCOLUMNHEADERS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,250,0,102,80,1,36,252,0,48,109,
		0,95,1,4,0,0,112,1,73,36,254,0,176,110,
		0,48,41,0,95,1,112,0,89,46,0,1,0,1,
		0,1,0,176,87,0,48,42,0,95,1,112,0,12,
		1,31,23,176,89,0,48,111,0,95,255,112,0,48,
		42,0,95,1,112,0,12,2,25,3,100,6,20,2,
		36,0,1,48,111,0,95,1,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLXBROWSE_SELECTCOLUMNORDER )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,6,1,176,87,0,95,1,12,1,28,
		8,36,7,1,102,110,7,36,10,1,176,110,0,48,
		41,0,102,112,0,89,40,0,1,0,1,0,1,0,
		48,112,0,95,1,112,0,48,112,0,95,255,112,0,
		69,28,14,48,113,0,95,1,106,1,0,112,1,25,
		3,100,6,20,2,36,12,1,176,87,0,95,2,12,
		1,28,67,36,13,1,48,114,0,95,1,112,0,106,
		2,68,0,8,31,16,176,87,0,48,114,0,95,1,
		112,0,12,1,28,19,36,14,1,48,113,0,95,1,
		106,2,65,0,112,1,73,25,32,36,16,1,48,113,
		0,95,1,106,2,68,0,112,1,73,25,15,36,19,
		1,48,113,0,95,1,95,2,112,1,73,36,22,1,
		102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLXBROWSE_GETCOLUMNHEADER )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,28,1,176,115,0,48,41,0,102,112,
		0,89,20,0,1,0,1,0,1,0,48,42,0,95,
		1,112,0,95,255,8,6,12,2,80,2,36,30,1,
		95,2,121,69,28,16,36,31,1,48,41,0,102,112,
		0,95,2,1,110,7,36,34,1,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLXBROWSE_GETCOLUMNORDER )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,40,1,176,115,0,48,41,0,102,112,
		0,89,20,0,1,0,1,0,1,0,48,112,0,95,
		1,112,0,95,255,8,6,12,2,80,2,36,42,1,
		95,2,121,69,28,16,36,43,1,48,41,0,102,112,
		0,95,2,1,110,7,36,46,1,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,118,0,2,0,116,118,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

