/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\Tindex.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TINDEX );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBOBJECT );
HB_FUNC_STATIC( TINDEX_NEW );
HB_FUNC_STATIC( TINDEX_SETSCOPE );
HB_FUNC_STATIC( TINDEX_CLEARSCOPE );
HB_FUNC_EXTERN( ORDNUMBER );
HB_FUNC_EXTERN( ORDKEYVAL );
HB_FUNC_STATIC( TINDEX_SETCOND );
HB_FUNC_STATIC( TINDEX_CREATE );
HB_FUNC_STATIC( TINDEX_IDXEXT );
HB_FUNC_STATIC( TINDEX_SETFOCUS );
HB_FUNC_EXTERN( LAIS );
HB_FUNC_EXTERN( ORDLISTADD );
HB_FUNC_STATIC( TINDEX__DELETE );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( UPPER );
HB_FUNC_EXTERN( VALTYPE );
HB_FUNC_EXTERN( GETFILENOEXT );
HB_FUNC_EXTERN( GETFILENAME );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( SET );
HB_FUNC_EXTERN( C2BLOCK );
HB_FUNC_EXTERN( ORDCONDSET );
HB_FUNC_EXTERN( RECNO );
HB_FUNC_EXTERN( ORDCREATE );
HB_FUNC_EXTERN( AT );
HB_FUNC_EXTERN( ORDBAGEXT );
HB_FUNC_EXTERN( ORDDESTROY );
HB_FUNC_EXTERN( FERASE );
HB_FUNC_EXTERN( BOF );
HB_FUNC_EXTERN( EOF );
HB_FUNC_EXTERN( ORDSETFOCUS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TINDEX )
{ "TINDEX", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TINDEX )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBOBJECT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TINDEX_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINDEX_NEW )}, NULL },
{ "TINDEX_SETSCOPE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINDEX_SETSCOPE )}, NULL },
{ "TINDEX_CLEARSCOPE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINDEX_CLEARSCOPE )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NAREA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ORDNUMBER", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDNUMBER )}, NULL },
{ "CNAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CFILE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ORDKEYVAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDKEYVAL )}, NULL },
{ "TINDEX_SETCOND", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINDEX_SETCOND )}, NULL },
{ "TINDEX_CREATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINDEX_CREATE )}, NULL },
{ "TINDEX_IDXEXT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINDEX_IDXEXT )}, NULL },
{ "TINDEX_SETFOCUS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINDEX_SETFOCUS )}, NULL },
{ "CRDD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LAIS", {HB_FS_PUBLIC}, {HB_FUNCNAME( LAIS )}, NULL },
{ "ORDLISTADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDLISTADD )}, NULL },
{ "TINDEX__DELETE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINDEX__DELETE )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "UPPER", {HB_FS_PUBLIC}, {HB_FUNCNAME( UPPER )}, NULL },
{ "VALTYPE", {HB_FS_PUBLIC}, {HB_FUNCNAME( VALTYPE )}, NULL },
{ "GETFILENOEXT", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETFILENOEXT )}, NULL },
{ "_CFILE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPATH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETFILENAME", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETFILENAME )}, NULL },
{ "_LNODEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LTMP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "_CFOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LNODEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LUNIQ", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SET", {HB_FS_PUBLIC}, {HB_FUNCNAME( SET )}, NULL },
{ "_LDES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BWHILE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BOPTION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCOMMENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "C2BLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( C2BLOCK )}, NULL },
{ "CKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BFOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CFOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BBOTTOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BRANGE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_UTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_UBOTTOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LSCOPE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NSTEP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ORDCONDSET", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDCONDSET )}, NULL },
{ "BFOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BWHILE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BOPTION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NSTEP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECNO", {HB_FS_PUBLIC}, {HB_FUNCNAME( RECNO )}, NULL },
{ "LDES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETCOND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ORDCREATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDCREATE )}, NULL },
{ "BKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LUNIQ", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AT", {HB_FS_PUBLIC}, {HB_FUNCNAME( AT )}, NULL },
{ "ORDBAGEXT", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDBAGEXT )}, NULL },
{ "ORDDESTROY", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDDESTROY )}, NULL },
{ "FERASE", {HB_FS_PUBLIC}, {HB_FUNCNAME( FERASE )}, NULL },
{ "BOF", {HB_FS_PUBLIC}, {HB_FUNCNAME( BOF )}, NULL },
{ "KEYVAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EOF", {HB_FS_PUBLIC}, {HB_FUNCNAME( EOF )}, NULL },
{ "LSCOPE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBERROR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ORDSETFOCUS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDSETFOCUS )}, NULL },
{ "_OINDEX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "(_INITSTATICS00001)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TINDEX, ".\\.\\Prg\\Tindex.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TINDEX
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TINDEX )
   #include "hbiniseg.h"
#endif

HB_FUNC( TINDEX )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,85,0,36,19,0,103,1,0,100,8,
		29,88,4,176,1,0,104,1,0,12,1,29,77,4,
		166,15,4,0,122,80,1,48,2,0,176,3,0,12,
		0,106,7,84,73,110,100,101,120,0,108,4,4,1,
		0,108,0,112,3,80,2,36,21,0,48,5,0,95,
		2,106,7,83,84,82,73,78,71,0,100,95,1,121,
		72,121,72,121,72,106,6,99,70,105,108,101,0,106,
		5,99,75,101,121,0,106,5,99,70,111,114,0,106,
		6,99,78,97,109,101,0,106,9,99,67,111,109,109,
		101,110,116,0,4,5,0,9,112,5,73,36,22,0,
		48,5,0,95,2,106,8,76,79,71,73,67,65,76,
		0,100,95,1,121,72,121,72,121,72,106,7,108,83,
		99,111,112,101,0,106,5,108,68,101,115,0,106,6,
		108,85,110,105,113,0,106,5,108,84,109,112,0,106,
		7,108,78,111,68,101,108,0,4,5,0,9,112,5,
		73,36,23,0,48,5,0,95,2,106,10,67,79,68,
		69,66,76,79,67,75,0,100,95,1,121,72,121,72,
		121,72,106,7,98,82,97,110,103,101,0,106,5,98,
		84,111,112,0,106,8,98,66,111,116,116,111,109,0,
		4,3,0,9,112,5,73,36,24,0,48,5,0,95,
		2,100,100,95,1,121,72,121,72,121,72,106,7,98,
		87,104,105,108,101,0,106,8,98,79,112,116,105,111,
		110,0,4,2,0,9,112,5,73,36,25,0,48,5,
		0,95,2,100,100,95,1,121,72,121,72,121,72,106,
		6,67,97,114,103,111,0,106,5,117,84,111,112,0,
		106,8,117,66,111,116,116,111,109,0,4,3,0,9,
		112,5,73,36,26,0,48,5,0,95,2,106,10,67,
		79,68,69,66,76,79,67,75,0,100,95,1,121,72,
		121,72,121,72,106,5,98,70,111,114,0,106,5,98,
		75,101,121,0,4,2,0,9,112,5,73,36,27,0,
		48,5,0,95,2,106,8,78,85,77,69,82,73,67,
		0,100,95,1,121,72,121,72,121,72,106,6,110,83,
		116,101,112,0,4,1,0,9,112,5,73,36,28,0,
		48,5,0,95,2,100,100,95,1,121,72,121,72,121,
		72,106,5,111,68,98,102,0,4,1,0,9,112,5,
		73,36,30,0,48,5,0,95,2,106,7,83,84,82,
		73,78,71,0,106,7,84,73,78,68,69,88,0,95,
		1,121,72,121,72,121,72,106,8,67,108,115,78,97,
		109,101,0,4,1,0,9,112,5,73,36,33,0,48,
		6,0,95,2,106,4,78,101,119,0,108,7,95,1,
		92,8,72,121,72,121,72,112,3,73,36,34,0,48,
		6,0,95,2,106,9,83,101,116,83,99,111,112,101,
		0,108,8,95,1,121,72,121,72,121,72,112,3,73,
		36,35,0,48,6,0,95,2,106,11,67,108,101,97,
		114,83,99,111,112,101,0,108,9,95,1,121,72,121,
		72,121,72,112,3,73,36,36,0,48,10,0,95,2,
		106,6,79,114,100,101,114,0,89,42,0,1,0,0,
		0,85,48,11,0,48,12,0,95,1,112,0,112,0,
		74,176,13,0,48,14,0,95,1,112,0,48,15,0,
		95,1,112,0,12,2,119,6,95,1,121,72,121,72,
		121,72,112,3,73,36,37,0,48,10,0,95,2,106,
		7,75,101,121,86,97,108,0,89,28,0,1,0,0,
		0,85,48,11,0,48,12,0,95,1,112,0,112,0,
		74,176,16,0,12,0,119,6,95,1,121,72,121,72,
		121,72,112,3,73,36,38,0,48,6,0,95,2,106,
		8,83,101,116,67,111,110,100,0,108,17,95,1,121,
		72,121,72,121,72,112,3,73,36,39,0,48,6,0,
		95,2,106,7,67,114,101,97,116,101,0,108,18,95,
		1,121,72,121,72,121,72,112,3,73,36,40,0,48,
		6,0,95,2,106,7,73,100,120,69,120,116,0,108,
		19,95,1,121,72,121,72,121,72,112,3,73,36,41,
		0,48,6,0,95,2,106,9,83,101,116,70,111,99,
		117,115,0,108,20,95,1,121,72,121,72,121,72,112,
		3,73,36,42,0,48,10,0,95,2,106,4,65,100,
		100,0,89,76,0,1,0,0,0,48,21,0,48,12,
		0,95,1,112,0,112,0,106,7,65,68,83,67,68,
		88,0,69,31,9,176,22,0,12,0,31,38,85,48,
		11,0,48,12,0,95,1,112,0,112,0,74,176,23,
		0,48,15,0,95,1,112,0,48,14,0,95,1,112,
		0,12,2,119,25,3,100,6,95,1,121,72,121,72,
		121,72,112,3,73,36,43,0,48,6,0,95,2,106,
		7,68,101,108,101,116,101,0,108,24,95,1,121,72,
		121,72,121,72,112,3,73,36,45,0,48,10,0,95,
		2,106,8,68,101,115,116,114,111,121,0,89,12,0,
		1,0,0,0,100,80,1,120,6,95,1,121,72,121,
		72,121,72,112,3,73,36,47,0,48,25,0,95,2,
		112,0,73,167,14,0,0,176,26,0,104,1,0,95,
		2,20,2,168,48,27,0,95,2,112,0,80,3,176,
		28,0,95,3,106,10,73,110,105,116,67,108,97,115,
		115,0,12,2,28,12,48,29,0,95,3,164,146,1,
		0,73,95,3,110,7,48,27,0,103,1,0,112,0,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINDEX_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,13,36,54,0,48,30,0,102,95,1,112,1,
		73,36,56,0,95,9,100,8,28,7,106,1,0,25,
		4,95,9,80,9,36,58,0,48,31,0,102,176,32,
		0,176,33,0,95,2,12,1,106,2,67,0,8,28,
		6,95,2,25,9,176,34,0,95,3,12,1,12,1,
		112,1,73,36,59,0,48,35,0,102,48,36,0,48,
		12,0,102,112,0,112,0,176,37,0,176,33,0,95,
		3,12,1,106,2,67,0,8,28,6,95,3,25,4,
		95,2,12,1,72,112,1,73,36,61,0,48,38,0,
		102,95,12,100,8,28,5,120,25,4,95,12,112,1,
		73,36,62,0,48,39,0,102,95,13,100,8,28,5,
		9,25,4,95,13,112,1,73,36,64,0,176,33,0,
		95,5,12,1,106,2,67,0,69,31,11,176,40,0,
		95,5,12,1,28,43,36,65,0,48,41,0,102,48,
		42,0,102,112,0,28,17,106,11,33,68,101,108,101,
		116,101,100,40,41,0,25,8,106,4,46,116,46,0,
		112,1,73,25,52,36,67,0,48,41,0,102,48,42,
		0,102,112,0,28,23,106,17,33,68,101,108,101,116,
		101,100,40,41,32,46,97,110,100,46,0,25,5,106,
		1,0,176,32,0,95,5,12,1,72,112,1,73,36,
		70,0,48,43,0,102,176,32,0,176,33,0,95,4,
		12,1,106,2,67,0,69,28,10,106,4,46,84,46,
		0,25,4,95,4,12,1,112,1,73,36,72,0,48,
		44,0,102,95,7,100,8,28,11,176,45,0,92,10,
		12,1,25,4,95,7,112,1,73,36,73,0,48,46,
		0,102,95,8,100,8,28,5,9,25,4,95,8,112,
		1,73,36,74,0,48,47,0,102,95,6,112,1,73,
		36,75,0,48,48,0,102,95,10,112,1,73,36,77,
		0,48,49,0,102,95,9,112,1,73,36,78,0,48,
		50,0,102,176,51,0,48,52,0,102,112,0,12,1,
		112,1,73,36,79,0,48,53,0,102,176,51,0,48,
		54,0,102,112,0,12,1,112,1,73,36,81,0,48,
		55,0,102,90,4,120,6,112,1,73,36,82,0,48,
		56,0,102,90,4,120,6,112,1,73,36,83,0,48,
		57,0,102,90,4,120,6,112,1,73,36,85,0,48,
		58,0,102,48,59,0,102,100,112,1,112,1,73,36,
		87,0,48,60,0,102,9,112,1,73,36,89,0,176,
		33,0,95,11,12,1,106,2,78,0,69,28,29,36,
		90,0,176,33,0,95,10,12,1,106,2,66,0,69,
		28,9,97,0,225,245,5,25,3,121,80,11,36,93,
		0,48,61,0,102,95,11,112,1,73,36,95,0,102,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINDEX_SETCOND )
{
	static const HB_BYTE pcode[] =
	{
		36,101,0,85,48,11,0,48,12,0,102,112,0,112,
		0,74,176,62,0,48,54,0,102,112,0,48,63,0,
		102,112,0,100,48,64,0,102,112,0,48,65,0,102,
		112,0,48,66,0,102,112,0,176,67,0,12,0,9,
		100,100,48,68,0,102,112,0,12,11,119,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINDEX_CREATE )
{
	static const HB_BYTE pcode[] =
	{
		36,107,0,48,69,0,102,112,0,73,36,109,0,85,
		48,11,0,48,12,0,102,112,0,112,0,74,176,70,
		0,48,15,0,102,112,0,48,14,0,102,112,0,48,
		52,0,102,112,0,48,71,0,102,112,0,48,72,0,
		102,112,0,20,5,74,36,111,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINDEX_IDXEXT )
{
	static const HB_BYTE pcode[] =
	{
		36,118,0,48,35,0,102,176,73,0,106,2,46,0,
		176,37,0,48,15,0,102,112,0,12,1,12,2,121,
		15,28,10,48,15,0,102,112,0,25,28,48,15,0,
		102,112,0,85,48,11,0,48,12,0,102,112,0,112,
		0,74,176,74,0,12,0,119,72,112,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINDEX__DELETE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,122,0,102,80,1,36,124,0,48,21,
		0,48,12,0,95,1,112,0,112,0,106,55,95,68,
		66,70,67,68,88,32,68,66,70,77,68,88,32,68,
		66,70,78,83,88,32,83,73,88,67,68,88,32,83,
		73,88,78,83,88,32,67,79,77,73,88,32,68,66,
		70,67,68,88,65,88,32,65,68,83,0,24,28,41,
		36,125,0,85,48,11,0,48,12,0,95,1,112,0,
		112,0,74,176,75,0,48,14,0,95,1,112,0,48,
		15,0,95,1,112,0,20,2,74,25,17,36,127,0,
		176,76,0,48,15,0,95,1,112,0,20,1,36,130,
		0,100,165,80,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINDEX_SETSCOPE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,135,0,102,80,3,36,137,0,48,68,
		0,95,3,112,0,29,178,0,36,138,0,48,60,0,
		95,3,95,2,95,1,34,112,1,29,76,1,36,140,
		0,48,55,0,95,3,89,42,0,1,0,2,0,3,
		0,1,0,85,48,11,0,95,1,112,0,74,176,77,
		0,12,0,119,68,21,28,13,73,48,78,0,95,255,
		112,0,95,254,34,6,112,1,73,36,142,0,48,56,
		0,95,3,89,42,0,1,0,2,0,3,0,2,0,
		85,48,11,0,95,1,112,0,74,176,79,0,12,0,
		119,68,21,28,13,73,48,78,0,95,255,112,0,95,
		254,16,6,112,1,73,36,144,0,48,57,0,95,3,
		89,37,0,1,0,3,0,3,0,1,0,2,0,48,
		78,0,95,255,112,0,80,1,95,1,95,254,34,21,
		28,8,73,95,1,95,253,16,6,112,1,73,26,175,
		0,36,147,0,48,60,0,95,3,95,1,95,2,34,
		112,1,29,157,0,36,149,0,48,55,0,95,3,89,
		42,0,1,0,2,0,3,0,1,0,85,48,11,0,
		95,1,112,0,74,176,77,0,12,0,119,68,21,28,
		13,73,48,78,0,95,255,112,0,95,254,16,6,112,
		1,73,36,151,0,48,56,0,95,3,89,42,0,1,
		0,2,0,3,0,2,0,85,48,11,0,95,1,112,
		0,74,176,79,0,12,0,119,68,21,28,13,73,48,
		78,0,95,255,112,0,95,254,34,6,112,1,73,36,
		153,0,48,57,0,95,3,89,37,0,1,0,3,0,
		3,0,1,0,2,0,48,78,0,95,255,112,0,80,
		1,95,1,95,254,16,21,28,8,73,95,1,95,253,
		34,6,112,1,73,36,157,0,48,80,0,95,3,112,
		0,28,30,36,158,0,48,58,0,95,3,95,1,112,
		1,73,36,159,0,48,59,0,95,3,95,2,112,1,
		73,25,20,36,161,0,48,81,0,48,12,0,95,3,
		112,0,92,11,112,1,73,36,164,0,48,80,0,95,
		3,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINDEX_CLEARSCOPE )
{
	static const HB_BYTE pcode[] =
	{
		36,170,0,48,58,0,102,48,59,0,102,100,112,1,
		112,1,73,36,172,0,48,55,0,102,90,4,120,6,
		112,1,73,36,173,0,48,56,0,102,90,4,120,6,
		112,1,73,36,174,0,48,57,0,102,90,4,120,6,
		112,1,73,36,176,0,48,60,0,102,9,112,1,73,
		36,178,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINDEX_SETFOCUS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,184,0,121,80,1,36,186,0,48,14,
		0,102,112,0,106,7,95,78,79,78,69,95,0,69,
		28,45,36,187,0,48,82,0,102,112,0,80,1,36,
		188,0,85,48,11,0,48,12,0,102,112,0,112,0,
		74,176,83,0,95,1,48,15,0,102,112,0,20,2,
		74,25,25,36,190,0,85,48,11,0,48,12,0,102,
		112,0,112,0,74,176,83,0,121,20,1,74,36,193,
		0,48,84,0,48,12,0,102,112,0,102,112,1,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,85,0,1,0,7
	};

	hb_vmExecute( pcode, symbols );
}
