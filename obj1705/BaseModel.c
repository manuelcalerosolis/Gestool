/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\Models\BaseModel.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( ADSBASEMODEL );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBOBJECT );
HB_FUNC_EXTERN( CPATEMP );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( CPATDAT );
HB_FUNC_STATIC( ADSBASEMODEL_CREATEFILE );
HB_FUNC_STATIC( ADSBASEMODEL_CREATEINDEX );
HB_FUNC_STATIC( ADSBASEMODEL_EXECUTESQLSTATEMENT );
HB_FUNC_EXTERN( SELECT );
HB_FUNC_EXTERN( DBCLOSEAREA );
HB_FUNC_EXTERN( DBSELECTAREA );
HB_FUNC_EXTERN( ORDSETFOCUS );
HB_FUNC_EXTERN( DBGOTOP );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( LAIS );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( ADSCACHEOPENCURSORS );
HB_FUNC_EXTERN( ADSCREATESQLSTATEMENT );
HB_FUNC_EXTERN( ADSEXECUTESQLDIRECT );
HB_FUNC_EXTERN( ADSGETLASTERROR );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( STR );
HB_FUNC_EXTERN( ADSCLRCALLBACK );
HB_FUNC_EXTERN( ERRORMESSAGE );
HB_FUNC_EXTERN( LEXISTTABLE );
HB_FUNC_EXTERN( DBCREATE );
HB_FUNC_EXTERN( CDRIVER );
HB_FUNC_EXTERN( DBUSEAREA );
HB_FUNC_EXTERN( CCHECKAREA );
HB_FUNC_EXTERN( NETERR );
HB_FUNC_EXTERN( __DBPACK );
HB_FUNC_EXTERN( ORDCONDSET );
HB_FUNC_EXTERN( DELETED );
HB_FUNC_EXTERN( ORDCREATE );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_BASEMODEL )
{ "ADSBASEMODEL", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( ADSBASEMODEL )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBOBJECT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPATEMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPATEMP )}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "CTABLENAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPATDAT", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPATDAT )}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADSBASEMODEL_CREATEFILE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ADSBASEMODEL_CREATEFILE )}, NULL },
{ "ADSBASEMODEL_CREATEINDEX", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ADSBASEMODEL_CREATEINDEX )}, NULL },
{ "ADSBASEMODEL_EXECUTESQLSTATEMENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ADSBASEMODEL_EXECUTESQLSTATEMENT )}, NULL },
{ "SELECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( SELECT )}, NULL },
{ "DBCLOSEAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBCLOSEAREA )}, NULL },
{ "DBSELECTAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBSELECTAREA )}, NULL },
{ "ORDSETFOCUS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDSETFOCUS )}, NULL },
{ "DBGOTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBGOTOP )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LAIS", {HB_FS_PUBLIC}, {HB_FUNCNAME( LAIS )}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "CLOSEAREA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADSCACHEOPENCURSORS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADSCACHEOPENCURSORS )}, NULL },
{ "ADSCREATESQLSTATEMENT", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADSCREATESQLSTATEMENT )}, NULL },
{ "ADSEXECUTESQLDIRECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADSEXECUTESQLDIRECT )}, NULL },
{ "ADSGETLASTERROR", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADSGETLASTERROR )}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "STR", {HB_FS_PUBLIC}, {HB_FUNCNAME( STR )}, NULL },
{ "ADSCLRCALLBACK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADSCLRCALLBACK )}, NULL },
{ "GOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORMESSAGE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORMESSAGE )}, NULL },
{ "LEXISTTABLE", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEXISTTABLE )}, NULL },
{ "GETFILENAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBCREATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBCREATE )}, NULL },
{ "GETSTRUCT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDRIVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CDRIVER )}, NULL },
{ "DBUSEAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBUSEAREA )}, NULL },
{ "CCHECKAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( CCHECKAREA )}, NULL },
{ "NETERR", {HB_FS_PUBLIC}, {HB_FUNCNAME( NETERR )}, NULL },
{ "__DBPACK", {HB_FS_PUBLIC}, {HB_FUNCNAME( __DBPACK )}, NULL },
{ "GETINDEXES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ORDCONDSET", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDCONDSET )}, NULL },
{ "DELETED", {HB_FS_PUBLIC}, {HB_FUNCNAME( DELETED )}, NULL },
{ "ORDCREATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDCREATE )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_BASEMODEL, ".\\Prg\\Models\\BaseModel.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_BASEMODEL
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_BASEMODEL )
   #include "hbiniseg.h"
#endif

HB_FUNC( ADSBASEMODEL )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,53,0,36,7,0,103,2,0,100,8,
		29,117,2,176,1,0,104,2,0,12,1,29,106,2,
		166,44,2,0,122,80,1,48,2,0,176,3,0,12,
		0,106,13,65,68,83,66,97,115,101,77,111,100,101,
		108,0,108,4,4,1,0,108,0,112,3,80,2,36,
		9,0,48,5,0,95,2,100,100,95,1,121,72,121,
		72,121,72,106,11,99,84,97,98,108,101,78,97,109,
		101,0,4,1,0,9,112,5,73,36,11,0,48,6,
		0,95,2,106,20,103,101,116,69,109,112,114,101,115,
		97,84,97,98,108,101,78,97,109,101,0,89,34,0,
		2,0,0,0,176,7,0,12,0,176,8,0,95,2,
		12,1,28,11,48,9,0,95,1,112,0,25,4,95,
		2,72,6,95,1,121,72,121,72,121,72,112,3,73,
		36,13,0,48,6,0,95,2,106,18,103,101,116,68,
		97,116,111,115,84,97,98,108,101,78,97,109,101,0,
		89,34,0,2,0,0,0,176,10,0,12,0,176,8,
		0,95,2,12,1,28,11,48,9,0,95,1,112,0,
		25,4,95,2,72,6,95,1,121,72,121,72,121,72,
		112,3,73,36,15,0,48,6,0,95,2,106,12,103,
		101,116,70,105,108,101,78,97,109,101,0,89,36,0,
		3,0,0,0,95,2,106,2,92,0,72,176,8,0,
		95,3,12,1,28,11,48,9,0,95,1,112,0,25,
		4,95,3,72,6,95,1,121,72,121,72,121,72,112,
		3,73,36,17,0,48,11,0,95,2,106,11,99,114,
		101,97,116,101,70,105,108,101,0,108,12,95,1,121,
		72,121,72,121,72,112,3,73,36,19,0,48,11,0,
		95,2,106,12,99,114,101,97,116,101,73,110,100,101,
		120,0,108,13,95,1,121,72,121,72,121,72,112,3,
		73,36,21,0,48,11,0,95,2,106,20,101,120,101,
		99,117,116,101,83,113,108,83,116,97,116,101,109,101,
		110,116,0,108,14,95,1,121,72,121,72,121,72,112,
		3,73,36,23,0,48,6,0,95,2,106,10,99,108,
		111,115,101,65,114,101,97,0,89,36,0,2,0,0,
		0,176,15,0,95,2,12,1,121,15,28,12,85,95,
		2,74,176,16,0,20,0,74,176,17,0,121,20,1,
		120,6,95,1,121,72,121,72,121,72,112,3,73,36,
		25,0,48,6,0,95,2,106,6,103,111,84,111,112,
		0,89,43,0,2,0,0,0,176,15,0,95,2,12,
		1,121,15,28,25,85,95,2,74,176,18,0,121,20,
		1,74,85,95,2,74,176,19,0,12,0,119,25,3,
		100,6,95,1,121,72,121,72,121,72,112,3,73,36,
		27,0,48,20,0,95,2,112,0,73,167,14,0,0,
		176,21,0,104,2,0,95,2,20,2,168,48,22,0,
		95,2,112,0,80,3,176,23,0,95,3,106,10,73,
		110,105,116,67,108,97,115,115,0,12,2,28,12,48,
		24,0,95,3,164,146,1,0,73,95,3,110,7,48,
		22,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ADSBASEMODEL_EXECUTESQLSTATEMENT )
{
	static const HB_BYTE pcode[] =
	{
		13,5,3,36,39,0,95,2,100,8,28,14,106,8,
		65,68,83,65,114,101,97,0,80,2,36,40,0,95,
		3,100,8,28,6,92,2,80,3,36,42,0,176,25,
		0,12,0,31,8,36,43,0,9,110,7,36,46,0,
		176,26,0,89,15,0,1,0,0,0,176,27,0,95,
		1,12,1,6,12,1,80,7,36,47,0,113,116,1,
		0,36,49,0,48,28,0,102,95,2,112,1,73,36,
		51,0,176,29,0,121,20,1,36,53,0,176,17,0,
		121,20,1,36,55,0,176,30,0,95,2,95,3,12,
		2,80,4,36,56,0,95,4,29,145,0,36,58,0,
		176,31,0,95,1,12,1,80,4,36,59,0,95,4,
		32,0,1,36,60,0,176,32,0,96,8,0,12,1,
		80,5,36,63,0,176,33,0,106,9,69,114,114,111,
		114,32,58,32,0,176,34,0,95,5,12,1,72,106,
		2,91,0,72,95,8,72,106,2,93,0,72,106,2,
		13,0,72,106,2,10,0,72,106,2,13,0,72,106,
		2,10,0,72,106,7,83,81,76,32,58,32,0,72,
		95,1,72,106,31,69,82,82,79,82,32,101,110,32,
		65,68,83,67,114,101,97,116,101,83,81,76,83,116,
		97,116,101,109,101,110,116,0,20,2,26,134,0,36,
		68,0,48,28,0,102,95,2,112,1,73,36,70,0,
		176,32,0,96,8,0,12,1,80,5,36,73,0,176,
		33,0,106,9,69,114,114,111,114,32,58,32,0,176,
		34,0,95,5,12,1,72,106,2,91,0,72,95,8,
		72,106,2,93,0,72,106,2,13,0,72,106,2,10,
		0,72,106,2,13,0,72,106,2,10,0,72,106,7,
		83,81,76,32,58,32,0,72,95,1,72,106,31,69,
		82,82,79,82,32,101,110,32,65,68,83,67,114,101,
		97,116,101,83,81,76,83,116,97,116,101,109,101,110,
		116,0,20,2,36,77,0,95,4,28,31,36,79,0,
		176,29,0,121,20,1,36,80,0,176,35,0,20,0,
		36,82,0,48,36,0,102,95,2,112,1,73,36,84,
		0,114,50,0,0,36,86,0,115,80,6,36,87,0,
		176,33,0,176,37,0,95,6,12,1,106,23,69,114,
		114,111,114,32,101,110,32,115,101,110,116,101,110,99,
		105,97,32,83,81,76,0,20,2,36,89,0,176,26,
		0,95,7,20,1,36,91,0,95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ADSBASEMODEL_CREATEFILE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,97,0,176,38,0,48,39,0,102,95,
		1,112,1,12,1,31,29,36,98,0,176,40,0,48,
		39,0,102,95,1,112,1,48,41,0,102,112,0,176,
		42,0,12,0,20,3,36,101,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ADSBASEMODEL_CREATEINDEX )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,110,0,176,43,0,120,176,42,0,12,
		0,48,39,0,102,95,1,112,1,176,44,0,106,6,
		65,108,105,97,115,0,96,2,0,12,2,9,20,5,
		36,112,0,85,95,2,74,176,45,0,12,0,119,28,
		73,36,113,0,176,33,0,106,46,73,109,112,111,115,
		105,98,108,101,32,97,98,114,105,114,32,101,110,32,
		109,111,100,111,32,101,120,99,108,117,115,105,118,111,
		32,108,97,32,116,97,98,108,97,32,58,32,0,48,
		39,0,102,95,1,112,1,72,20,1,36,114,0,102,
		110,7,36,117,0,85,95,2,74,176,46,0,20,0,
		74,36,119,0,48,47,0,102,112,0,96,3,0,129,
		1,1,28,91,36,120,0,85,95,2,74,176,48,0,
		106,11,33,68,101,108,101,116,101,100,40,41,0,90,
		9,176,49,0,12,0,68,6,100,100,100,100,100,100,
		100,100,95,3,92,4,1,20,11,74,36,121,0,85,
		95,2,74,176,50,0,48,39,0,102,95,1,112,1,
		95,3,122,1,95,3,92,2,1,95,3,92,3,1,
		20,4,74,36,122,0,130,31,169,132,36,124,0,85,
		95,2,74,176,16,0,20,0,74,36,126,0,102,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,53,0,2,0,116,53,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

