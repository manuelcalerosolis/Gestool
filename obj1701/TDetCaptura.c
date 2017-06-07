/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\TDetCaptura.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TDETCAPTURA );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TDET );
HB_FUNC_STATIC( TDETCAPTURA_DEFINEFILES );
HB_FUNC_STATIC( TDETCAPTURA_OPENFILES );
HB_FUNC_STATIC( TDETCAPTURA_OPENSERVICE );
HB_FUNC_STATIC( TDETCAPTURA_CHECKDEFAULT );
HB_FUNC_STATIC( TDETCAPTURA_SAVELINES );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( CDRIVER );
HB_FUNC_EXTERN( DBFSERVER );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( SPACE );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TDETCAPTURA )
{ "TDETCAPTURA", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TDETCAPTURA )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TDET", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDET )}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDETCAPTURA_DEFINEFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDETCAPTURA_DEFINEFILES )}, NULL },
{ "TDETCAPTURA_OPENFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDETCAPTURA_OPENFILES )}, NULL },
{ "TDETCAPTURA_OPENSERVICE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDETCAPTURA_OPENSERVICE )}, NULL },
{ "TDETCAPTURA_CHECKDEFAULT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDETCAPTURA_CHECKDEFAULT )}, NULL },
{ "TDETCAPTURA_SAVELINES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDETCAPTURA_SAVELINES )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPATH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDRIVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CDRIVER )}, NULL },
{ "DBFSERVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBFSERVER )}, NULL },
{ "ADDFIELD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDINDEX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHECKDEFAULT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BONPRESAVEDETAIL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SAVELINES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "CLOSESERVICE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "_CCODIGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBFVIR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODIGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OPARENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SEEK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DELETE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NNUMERO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMBRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LEDITABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LVISIBLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NCAPTURA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CTITULO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LALIGN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CPICTURE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SPACE", {HB_FS_PUBLIC}, {HB_FUNCNAME( SPACE )}, NULL },
{ "_NANCHO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LBITMAP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TDETCAPTURA, ".\\.\\Prg\\TDetCaptura.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TDETCAPTURA
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TDETCAPTURA )
   #include "hbiniseg.h"
#endif

HB_FUNC( TDETCAPTURA )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,55,0,36,11,0,103,2,0,100,8,
		29,40,1,176,1,0,104,2,0,12,1,29,29,1,
		166,223,0,0,122,80,1,48,2,0,176,3,0,12,
		0,106,12,84,68,101,116,67,97,112,116,117,114,97,
		0,108,4,4,1,0,108,0,112,3,80,2,36,13,
		0,48,5,0,95,2,106,12,68,101,102,105,110,101,
		70,105,108,101,115,0,108,6,95,1,121,72,121,72,
		121,72,112,3,73,36,15,0,48,5,0,95,2,106,
		10,79,112,101,110,70,105,108,101,115,0,108,7,95,
		1,121,72,121,72,121,72,112,3,73,36,17,0,48,
		5,0,95,2,106,12,79,112,101,110,83,101,114,118,
		105,99,101,0,108,8,95,1,121,72,121,72,121,72,
		112,3,73,36,19,0,48,5,0,95,2,106,13,67,
		104,101,99,107,68,101,102,97,117,108,116,0,108,9,
		95,1,121,72,121,72,121,72,112,3,73,36,21,0,
		48,5,0,95,2,106,10,83,97,118,101,76,105,110,
		101,115,0,108,10,95,1,121,72,121,72,121,72,112,
		3,73,36,23,0,48,11,0,95,2,112,0,73,167,
		14,0,0,176,12,0,104,2,0,95,2,20,2,168,
		48,13,0,95,2,112,0,80,3,176,14,0,95,3,
		106,10,73,110,105,116,67,108,97,115,115,0,12,2,
		28,12,48,15,0,95,3,164,146,1,0,73,95,3,
		110,7,48,13,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDETCAPTURA_DEFINEFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,31,0,95,1,100,8,28,10,48,16,
		0,102,112,0,80,1,36,32,0,95,2,100,8,28,
		9,176,17,0,12,0,80,2,36,34,0,48,2,0,
		176,18,0,106,18,67,97,112,116,117,114,97,67,97,
		109,112,111,115,46,68,98,102,0,106,8,84,67,97,
		112,67,97,109,0,12,2,106,18,67,97,112,116,117,
		114,97,67,97,109,112,111,115,46,68,98,102,0,106,
		7,67,97,112,67,97,109,0,95,2,100,95,1,112,
		5,80,3,36,36,0,48,19,0,95,3,106,8,99,
		67,111,100,105,103,111,0,106,2,67,0,92,3,121,
		100,100,100,100,106,7,67,243,100,105,103,111,0,9,
		100,9,4,0,0,112,13,73,36,37,0,48,19,0,
		95,3,106,8,110,78,117,109,101,114,111,0,106,2,
		78,0,92,2,121,100,100,100,100,106,7,78,250,109,
		101,114,111,0,9,100,9,4,0,0,112,13,73,36,
		38,0,48,19,0,95,3,106,8,99,78,111,109,98,
		114,101,0,106,2,67,0,92,50,121,100,100,100,100,
		106,7,78,111,109,98,114,101,0,9,100,9,4,0,
		0,112,13,73,36,39,0,48,19,0,95,3,106,10,
		108,69,100,105,116,97,98,108,101,0,106,2,76,0,
		122,121,100,100,100,100,106,9,69,100,105,116,97,98,
		108,101,0,9,100,9,4,0,0,112,13,73,36,40,
		0,48,19,0,95,3,106,9,108,86,105,115,105,98,
		108,101,0,106,2,76,0,122,121,100,100,100,100,106,
		7,86,105,115,98,108,101,0,9,100,9,4,0,0,
		112,13,73,36,41,0,48,19,0,95,3,106,9,110,
		67,97,112,116,117,114,97,0,106,2,78,0,122,121,
		100,100,100,100,106,8,67,97,112,116,117,114,97,0,
		9,100,9,4,0,0,112,13,73,36,42,0,48,19,
		0,95,3,106,8,99,84,105,116,117,108,111,0,106,
		2,67,0,92,50,121,100,100,100,100,106,7,84,237,
		116,117,108,111,0,9,100,9,4,0,0,112,13,73,
		36,43,0,48,19,0,95,3,106,7,108,65,108,105,
		103,110,0,106,2,76,0,122,121,100,100,100,100,106,
		6,65,108,105,103,110,0,9,100,9,4,0,0,112,
		13,73,36,44,0,48,19,0,95,3,106,9,99,80,
		105,99,116,117,114,101,0,106,2,67,0,92,50,121,
		100,100,100,100,106,8,80,105,99,116,117,114,101,0,
		9,100,9,4,0,0,112,13,73,36,45,0,48,19,
		0,95,3,106,7,110,65,110,99,104,111,0,106,2,
		78,0,92,3,121,100,100,100,100,106,6,65,110,99,
		104,111,0,9,100,9,4,0,0,112,13,73,36,46,
		0,48,19,0,95,3,106,8,108,66,105,116,109,97,
		112,0,106,2,76,0,122,121,100,100,100,100,106,8,
		82,101,99,117,114,115,111,0,9,100,9,4,0,0,
		112,13,73,36,48,0,48,20,0,95,3,106,8,99,
		67,111,100,105,103,111,0,106,18,67,97,112,116,117,
		114,97,67,97,109,112,111,115,46,67,100,120,0,106,
		8,99,67,111,100,105,103,111,0,100,100,9,9,106,
		7,67,243,100,105,103,111,0,100,100,120,9,112,12,
		73,36,52,0,95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDETCAPTURA_OPENFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,56,0,102,80,3,36,58,0,95,1,
		100,8,28,5,9,80,1,36,59,0,95,2,100,8,
		28,11,48,16,0,95,3,112,0,80,2,36,61,0,
		176,21,0,48,22,0,95,3,112,0,12,1,28,22,
		36,62,0,48,23,0,95,3,48,24,0,95,3,95,
		2,112,1,112,1,73,36,65,0,48,25,0,48,22,
		0,95,3,112,0,9,95,1,68,112,2,73,36,67,
		0,48,26,0,95,3,106,4,48,48,48,0,9,112,
		2,73,36,69,0,48,27,0,95,3,89,17,0,0,
		0,1,0,3,0,48,28,0,95,255,112,0,6,112,
		1,73,36,70,0,48,27,0,95,3,89,17,0,0,
		0,1,0,3,0,48,28,0,95,255,112,0,6,112,
		1,73,36,72,0,95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDETCAPTURA_OPENSERVICE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,2,36,78,0,120,80,3,36,81,0,95,1,
		100,8,28,5,9,80,1,36,82,0,95,2,100,8,
		28,10,48,16,0,102,112,0,80,2,36,84,0,176,
		29,0,89,15,0,1,0,0,0,176,30,0,95,1,
		12,1,6,12,1,80,4,36,85,0,113,61,0,0,
		36,87,0,176,21,0,48,22,0,102,112,0,12,1,
		28,20,36,88,0,48,23,0,102,48,24,0,102,95,
		2,112,1,112,1,73,36,91,0,48,25,0,48,22,
		0,102,112,0,9,95,1,68,112,2,73,114,99,0,
		0,36,93,0,115,73,36,95,0,9,80,3,36,97,
		0,48,31,0,102,112,0,73,36,99,0,176,32,0,
		106,64,73,109,112,111,115,105,98,108,101,32,97,98,
		114,105,114,32,116,111,100,97,115,32,108,97,115,32,
		98,97,115,101,115,32,100,101,32,100,97,116,111,115,
		32,100,101,32,100,101,116,97,108,108,101,32,100,101,
		32,99,97,112,116,117,114,97,115,0,20,1,36,103,
		0,176,29,0,95,4,20,1,36,105,0,95,3,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDETCAPTURA_SAVELINES )
{
	static const HB_BYTE pcode[] =
	{
		36,111,0,48,33,0,48,34,0,102,112,0,48,35,
		0,48,22,0,48,36,0,102,112,0,112,0,112,0,
		112,1,73,36,113,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDETCAPTURA_CHECKDEFAULT )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,119,0,95,1,100,8,28,10,106,4,
		48,48,48,0,80,1,36,120,0,95,2,100,8,28,
		5,9,80,2,36,122,0,95,2,28,51,36,123,0,
		48,37,0,48,22,0,102,112,0,95,1,112,1,28,
		33,48,38,0,48,22,0,102,112,0,112,0,31,20,
		36,124,0,48,39,0,48,22,0,102,112,0,9,112,
		1,73,25,209,36,128,0,176,21,0,95,1,12,1,
		31,18,48,37,0,48,22,0,102,112,0,95,1,112,
		1,32,158,21,36,130,0,48,40,0,48,22,0,102,
		112,0,112,0,73,36,131,0,48,33,0,48,22,0,
		102,112,0,95,1,112,1,73,36,132,0,48,41,0,
		48,22,0,102,112,0,122,112,1,73,36,133,0,48,
		42,0,48,22,0,102,112,0,106,20,67,243,100,105,
		103,111,32,100,101,108,32,97,114,116,237,99,117,108,
		111,0,112,1,73,36,134,0,48,43,0,48,22,0,
		102,112,0,9,112,1,73,36,135,0,48,44,0,48,
		22,0,102,112,0,120,112,1,73,36,136,0,48,45,
		0,48,22,0,102,112,0,92,3,112,1,73,36,137,
		0,48,46,0,48,22,0,102,112,0,106,7,67,243,
		100,105,103,111,0,112,1,73,36,138,0,48,47,0,
		48,22,0,102,112,0,9,112,1,73,36,139,0,48,
		48,0,48,22,0,102,112,0,176,49,0,92,50,12,
		1,112,1,73,36,140,0,48,50,0,48,22,0,102,
		112,0,92,100,112,1,73,36,141,0,48,51,0,48,
		22,0,102,112,0,9,112,1,73,36,142,0,48,52,
		0,48,22,0,102,112,0,112,0,73,36,144,0,48,
		40,0,48,22,0,102,112,0,112,0,73,36,145,0,
		48,33,0,48,22,0,102,112,0,95,1,112,1,73,
		36,146,0,48,41,0,48,22,0,102,112,0,92,2,
		112,1,73,36,147,0,48,42,0,48,22,0,102,112,
		0,106,9,85,110,105,100,97,100,101,115,0,112,1,
		73,36,148,0,48,43,0,48,22,0,102,112,0,9,
		112,1,73,36,149,0,48,44,0,48,22,0,102,112,
		0,120,112,1,73,36,150,0,48,45,0,48,22,0,
		102,112,0,92,3,112,1,73,36,151,0,48,46,0,
		48,22,0,102,112,0,106,5,85,110,100,46,0,112,
		1,73,36,152,0,48,47,0,48,22,0,102,112,0,
		120,112,1,73,36,153,0,48,48,0,48,22,0,102,
		112,0,106,8,99,80,105,99,85,110,100,0,112,1,
		73,36,154,0,48,50,0,48,22,0,102,112,0,92,
		60,112,1,73,36,155,0,48,51,0,48,22,0,102,
		112,0,9,112,1,73,36,156,0,48,52,0,48,22,
		0,102,112,0,112,0,73,36,158,0,48,40,0,48,
		22,0,102,112,0,112,0,73,36,159,0,48,33,0,
		48,22,0,102,112,0,95,1,112,1,73,36,160,0,
		48,41,0,48,22,0,102,112,0,92,3,112,1,73,
		36,161,0,48,42,0,48,22,0,102,112,0,106,11,
		77,101,100,105,99,105,243,110,32,49,0,112,1,73,
		36,162,0,48,43,0,48,22,0,102,112,0,120,112,
		1,73,36,163,0,48,44,0,48,22,0,102,112,0,
		9,112,1,73,36,164,0,48,45,0,48,22,0,102,
		112,0,122,112,1,73,36,165,0,48,46,0,48,22,
		0,102,112,0,106,7,77,101,100,46,32,49,0,112,
		1,73,36,166,0,48,47,0,48,22,0,102,112,0,
		120,112,1,73,36,167,0,48,48,0,48,22,0,102,
		112,0,106,8,99,80,105,99,85,110,100,0,112,1,
		73,36,168,0,48,50,0,48,22,0,102,112,0,92,
		60,112,1,73,36,169,0,48,51,0,48,22,0,102,
		112,0,9,112,1,73,36,170,0,48,52,0,48,22,
		0,102,112,0,112,0,73,36,172,0,48,40,0,48,
		22,0,102,112,0,112,0,73,36,173,0,48,33,0,
		48,22,0,102,112,0,95,1,112,1,73,36,174,0,
		48,41,0,48,22,0,102,112,0,92,4,112,1,73,
		36,175,0,48,42,0,48,22,0,102,112,0,106,11,
		77,101,100,105,99,105,243,110,32,50,0,112,1,73,
		36,176,0,48,43,0,48,22,0,102,112,0,120,112,
		1,73,36,177,0,48,44,0,48,22,0,102,112,0,
		9,112,1,73,36,178,0,48,45,0,48,22,0,102,
		112,0,122,112,1,73,36,179,0,48,46,0,48,22,
		0,102,112,0,106,7,77,101,100,46,32,50,0,112,
		1,73,36,180,0,48,47,0,48,22,0,102,112,0,
		120,112,1,73,36,181,0,48,48,0,48,22,0,102,
		112,0,106,8,99,80,105,99,85,110,100,0,112,1,
		73,36,182,0,48,50,0,48,22,0,102,112,0,92,
		60,112,1,73,36,183,0,48,51,0,48,22,0,102,
		112,0,9,112,1,73,36,184,0,48,52,0,48,22,
		0,102,112,0,112,0,73,36,186,0,48,40,0,48,
		22,0,102,112,0,112,0,73,36,187,0,48,33,0,
		48,22,0,102,112,0,95,1,112,1,73,36,188,0,
		48,41,0,48,22,0,102,112,0,92,5,112,1,73,
		36,189,0,48,42,0,48,22,0,102,112,0,106,11,
		77,101,100,105,99,105,243,110,32,51,0,112,1,73,
		36,190,0,48,43,0,48,22,0,102,112,0,120,112,
		1,73,36,191,0,48,44,0,48,22,0,102,112,0,
		9,112,1,73,36,192,0,48,45,0,48,22,0,102,
		112,0,122,112,1,73,36,193,0,48,46,0,48,22,
		0,102,112,0,106,7,77,101,100,46,32,51,0,112,
		1,73,36,194,0,48,47,0,48,22,0,102,112,0,
		120,112,1,73,36,195,0,48,48,0,48,22,0,102,
		112,0,106,8,99,80,105,99,85,110,100,0,112,1,
		73,36,196,0,48,50,0,48,22,0,102,112,0,92,
		60,112,1,73,36,197,0,48,51,0,48,22,0,102,
		112,0,9,112,1,73,36,198,0,48,52,0,48,22,
		0,102,112,0,112,0,73,36,200,0,48,40,0,48,
		22,0,102,112,0,112,0,73,36,201,0,48,33,0,
		48,22,0,102,112,0,95,1,112,1,73,36,202,0,
		48,41,0,48,22,0,102,112,0,92,6,112,1,73,
		36,203,0,48,42,0,48,22,0,102,112,0,106,12,
		80,114,111,112,105,101,100,97,100,32,49,0,112,1,
		73,36,204,0,48,43,0,48,22,0,102,112,0,120,
		112,1,73,36,205,0,48,44,0,48,22,0,102,112,
		0,9,112,1,73,36,206,0,48,45,0,48,22,0,
		102,112,0,92,2,112,1,73,36,207,0,48,46,0,
		48,22,0,102,112,0,106,8,80,114,111,112,46,32,
		49,0,112,1,73,36,208,0,48,47,0,48,22,0,
		102,112,0,9,112,1,73,36,209,0,48,48,0,48,
		22,0,102,112,0,176,49,0,92,50,12,1,112,1,
		73,36,210,0,48,50,0,48,22,0,102,112,0,92,
		40,112,1,73,36,211,0,48,51,0,48,22,0,102,
		112,0,9,112,1,73,36,212,0,48,52,0,48,22,
		0,102,112,0,112,0,73,36,214,0,48,40,0,48,
		22,0,102,112,0,112,0,73,36,215,0,48,33,0,
		48,22,0,102,112,0,95,1,112,1,73,36,216,0,
		48,41,0,48,22,0,102,112,0,92,7,112,1,73,
		36,217,0,48,42,0,48,22,0,102,112,0,106,12,
		80,114,111,112,105,101,100,97,100,32,50,0,112,1,
		73,36,218,0,48,43,0,48,22,0,102,112,0,120,
		112,1,73,36,219,0,48,44,0,48,22,0,102,112,
		0,9,112,1,73,36,220,0,48,45,0,48,22,0,
		102,112,0,92,2,112,1,73,36,221,0,48,46,0,
		48,22,0,102,112,0,106,8,80,114,111,112,46,32,
		50,0,112,1,73,36,222,0,48,47,0,48,22,0,
		102,112,0,9,112,1,73,36,223,0,48,48,0,48,
		22,0,102,112,0,176,49,0,92,50,12,1,112,1,
		73,36,224,0,48,50,0,48,22,0,102,112,0,92,
		40,112,1,73,36,225,0,48,51,0,48,22,0,102,
		112,0,9,112,1,73,36,226,0,48,52,0,48,22,
		0,102,112,0,112,0,73,36,228,0,48,40,0,48,
		22,0,102,112,0,112,0,73,36,229,0,48,33,0,
		48,22,0,102,112,0,95,1,112,1,73,36,230,0,
		48,41,0,48,22,0,102,112,0,92,8,112,1,73,
		36,231,0,48,42,0,48,22,0,102,112,0,106,19,
		78,111,109,98,114,101,32,112,114,111,112,105,101,100,
		97,100,32,49,0,112,1,73,36,232,0,48,43,0,
		48,22,0,102,112,0,120,112,1,73,36,233,0,48,
		44,0,48,22,0,102,112,0,9,112,1,73,36,234,
		0,48,45,0,48,22,0,102,112,0,92,2,112,1,
		73,36,235,0,48,46,0,48,22,0,102,112,0,106,
		14,78,111,109,98,114,101,32,112,114,112,46,32,49,
		0,112,1,73,36,236,0,48,47,0,48,22,0,102,
		112,0,9,112,1,73,36,237,0,48,48,0,48,22,
		0,102,112,0,176,49,0,92,50,12,1,112,1,73,
		36,238,0,48,50,0,48,22,0,102,112,0,92,40,
		112,1,73,36,239,0,48,51,0,48,22,0,102,112,
		0,9,112,1,73,36,240,0,48,52,0,48,22,0,
		102,112,0,112,0,73,36,242,0,48,40,0,48,22,
		0,102,112,0,112,0,73,36,243,0,48,33,0,48,
		22,0,102,112,0,95,1,112,1,73,36,244,0,48,
		41,0,48,22,0,102,112,0,92,9,112,1,73,36,
		245,0,48,42,0,48,22,0,102,112,0,106,19,78,
		111,109,98,114,101,32,112,114,111,112,105,101,100,97,
		100,32,50,0,112,1,73,36,246,0,48,43,0,48,
		22,0,102,112,0,120,112,1,73,36,247,0,48,44,
		0,48,22,0,102,112,0,9,112,1,73,36,248,0,
		48,45,0,48,22,0,102,112,0,92,2,112,1,73,
		36,249,0,48,46,0,48,22,0,102,112,0,106,14,
		78,111,109,98,114,101,32,112,114,112,46,32,50,0,
		112,1,73,36,250,0,48,47,0,48,22,0,102,112,
		0,9,112,1,73,36,251,0,48,48,0,48,22,0,
		102,112,0,176,49,0,92,50,12,1,112,1,73,36,
		252,0,48,50,0,48,22,0,102,112,0,92,40,112,
		1,73,36,253,0,48,51,0,48,22,0,102,112,0,
		9,112,1,73,36,254,0,48,52,0,48,22,0,102,
		112,0,112,0,73,36,0,1,48,40,0,48,22,0,
		102,112,0,112,0,73,36,1,1,48,33,0,48,22,
		0,102,112,0,95,1,112,1,73,36,2,1,48,41,
		0,48,22,0,102,112,0,92,10,112,1,73,36,3,
		1,48,42,0,48,22,0,102,112,0,106,5,76,111,
		116,101,0,112,1,73,36,4,1,48,43,0,48,22,
		0,102,112,0,120,112,1,73,36,5,1,48,44,0,
		48,22,0,102,112,0,9,112,1,73,36,6,1,48,
		45,0,48,22,0,102,112,0,92,2,112,1,73,36,
		7,1,48,46,0,48,22,0,102,112,0,106,5,76,
		111,116,101,0,112,1,73,36,8,1,48,47,0,48,
		22,0,102,112,0,120,112,1,73,36,9,1,48,48,
		0,48,22,0,102,112,0,106,13,64,90,32,57,57,
		57,57,57,57,57,57,57,0,112,1,73,36,10,1,
		48,50,0,48,22,0,102,112,0,92,60,112,1,73,
		36,11,1,48,51,0,48,22,0,102,112,0,9,112,
		1,73,36,12,1,48,52,0,48,22,0,102,112,0,
		112,0,73,36,14,1,48,40,0,48,22,0,102,112,
		0,112,0,73,36,15,1,48,33,0,48,22,0,102,
		112,0,95,1,112,1,73,36,16,1,48,41,0,48,
		22,0,102,112,0,92,11,112,1,73,36,17,1,48,
		42,0,48,22,0,102,112,0,106,10,67,97,100,117,
		99,105,100,97,100,0,112,1,73,36,18,1,48,43,
		0,48,22,0,102,112,0,120,112,1,73,36,19,1,
		48,44,0,48,22,0,102,112,0,9,112,1,73,36,
		20,1,48,45,0,48,22,0,102,112,0,92,2,112,
		1,73,36,21,1,48,46,0,48,22,0,102,112,0,
		106,10,67,97,100,117,99,105,100,97,100,0,112,1,
		73,36,22,1,48,47,0,48,22,0,102,112,0,120,
		112,1,73,36,23,1,48,48,0,48,22,0,102,112,
		0,106,1,0,112,1,73,36,24,1,48,50,0,48,
		22,0,102,112,0,92,75,112,1,73,36,25,1,48,
		51,0,48,22,0,102,112,0,9,112,1,73,36,26,
		1,48,52,0,48,22,0,102,112,0,112,0,73,36,
		28,1,48,40,0,48,22,0,102,112,0,112,0,73,
		36,29,1,48,33,0,48,22,0,102,112,0,95,1,
		112,1,73,36,30,1,48,41,0,48,22,0,102,112,
		0,92,12,112,1,73,36,31,1,48,42,0,48,22,
		0,102,112,0,106,8,68,101,116,97,108,108,101,0,
		112,1,73,36,32,1,48,43,0,48,22,0,102,112,
		0,120,112,1,73,36,33,1,48,44,0,48,22,0,
		102,112,0,120,112,1,73,36,34,1,48,45,0,48,
		22,0,102,112,0,92,2,112,1,73,36,35,1,48,
		46,0,48,22,0,102,112,0,106,8,68,101,116,97,
		108,108,101,0,112,1,73,36,36,1,48,47,0,48,
		22,0,102,112,0,9,112,1,73,36,37,1,48,48,
		0,48,22,0,102,112,0,176,49,0,92,50,12,1,
		112,1,73,36,38,1,48,50,0,48,22,0,102,112,
		0,93,200,0,112,1,73,36,39,1,48,51,0,48,
		22,0,102,112,0,9,112,1,73,36,40,1,48,52,
		0,48,22,0,102,112,0,112,0,73,36,42,1,48,
		40,0,48,22,0,102,112,0,112,0,73,36,43,1,
		48,33,0,48,22,0,102,112,0,95,1,112,1,73,
		36,44,1,48,41,0,48,22,0,102,112,0,92,13,
		112,1,73,36,45,1,48,42,0,48,22,0,102,112,
		0,106,8,73,109,112,111,114,116,101,0,112,1,73,
		36,46,1,48,43,0,48,22,0,102,112,0,120,112,
		1,73,36,47,1,48,44,0,48,22,0,102,112,0,
		120,112,1,73,36,48,1,48,45,0,48,22,0,102,
		112,0,92,2,112,1,73,36,49,1,48,46,0,48,
		22,0,102,112,0,106,8,73,109,112,111,114,116,101,
		0,112,1,73,36,50,1,48,47,0,48,22,0,102,
		112,0,120,112,1,73,36,51,1,48,48,0,48,22,
		0,102,112,0,106,8,99,80,111,117,68,105,118,0,
		112,1,73,36,52,1,48,50,0,48,22,0,102,112,
		0,92,80,112,1,73,36,53,1,48,51,0,48,22,
		0,102,112,0,9,112,1,73,36,54,1,48,52,0,
		48,22,0,102,112,0,112,0,73,36,56,1,48,40,
		0,48,22,0,102,112,0,112,0,73,36,57,1,48,
		33,0,48,22,0,102,112,0,95,1,112,1,73,36,
		58,1,48,41,0,48,22,0,102,112,0,92,14,112,
		1,73,36,59,1,48,42,0,48,22,0,102,112,0,
		106,17,68,101,115,99,117,101,110,116,111,32,108,105,
		110,101,97,108,0,112,1,73,36,60,1,48,43,0,
		48,22,0,102,112,0,120,112,1,73,36,61,1,48,
		44,0,48,22,0,102,112,0,120,112,1,73,36,62,
		1,48,45,0,48,22,0,102,112,0,92,2,112,1,
		73,36,63,1,48,46,0,48,22,0,102,112,0,106,
		10,68,116,111,46,32,108,105,110,46,0,112,1,73,
		36,64,1,48,47,0,48,22,0,102,112,0,120,112,
		1,73,36,65,1,48,48,0,48,22,0,102,112,0,
		106,8,99,80,111,117,68,105,118,0,112,1,73,36,
		66,1,48,50,0,48,22,0,102,112,0,92,80,112,
		1,73,36,67,1,48,51,0,48,22,0,102,112,0,
		9,112,1,73,36,68,1,48,52,0,48,22,0,102,
		112,0,112,0,73,36,70,1,48,40,0,48,22,0,
		102,112,0,112,0,73,36,71,1,48,33,0,48,22,
		0,102,112,0,95,1,112,1,73,36,72,1,48,41,
		0,48,22,0,102,112,0,92,15,112,1,73,36,73,
		1,48,42,0,48,22,0,102,112,0,106,21,68,101,
		115,99,117,101,110,116,111,32,112,111,114,99,101,110,
		116,117,97,108,0,112,1,73,36,74,1,48,43,0,
		48,22,0,102,112,0,120,112,1,73,36,75,1,48,
		44,0,48,22,0,102,112,0,120,112,1,73,36,76,
		1,48,45,0,48,22,0,102,112,0,92,2,112,1,
		73,36,77,1,48,46,0,48,22,0,102,112,0,106,
		6,37,68,116,111,46,0,112,1,73,36,78,1,48,
		47,0,48,22,0,102,112,0,120,112,1,73,36,79,
		1,48,48,0,48,22,0,102,112,0,106,11,34,64,
		69,32,57,57,46,57,57,34,0,112,1,73,36,80,
		1,48,50,0,48,22,0,102,112,0,92,40,112,1,
		73,36,81,1,48,51,0,48,22,0,102,112,0,9,
		112,1,73,36,82,1,48,52,0,48,22,0,102,112,
		0,112,0,73,36,84,1,48,40,0,48,22,0,102,
		112,0,112,0,73,36,85,1,48,33,0,48,22,0,
		102,112,0,95,1,112,1,73,36,86,1,48,41,0,
		48,22,0,102,112,0,92,16,112,1,73,36,87,1,
		48,42,0,48,22,0,102,112,0,106,6,84,111,116,
		97,108,0,112,1,73,36,88,1,48,43,0,48,22,
		0,102,112,0,9,112,1,73,36,89,1,48,44,0,
		48,22,0,102,112,0,120,112,1,73,36,90,1,48,
		45,0,48,22,0,102,112,0,92,2,112,1,73,36,
		91,1,48,46,0,48,22,0,102,112,0,106,6,84,
		111,116,97,108,0,112,1,73,36,92,1,48,47,0,
		48,22,0,102,112,0,120,112,1,73,36,93,1,48,
		48,0,48,22,0,102,112,0,106,8,99,80,111,114,
		68,105,118,0,112,1,73,36,94,1,48,50,0,48,
		22,0,102,112,0,92,80,112,1,73,36,95,1,48,
		51,0,48,22,0,102,112,0,9,112,1,73,36,96,
		1,48,52,0,48,22,0,102,112,0,112,0,73,36,
		98,1,48,40,0,48,22,0,102,112,0,112,0,73,
		36,99,1,48,33,0,48,22,0,102,112,0,95,1,
		112,1,73,36,100,1,48,41,0,48,22,0,102,112,
		0,92,17,112,1,73,36,101,1,48,42,0,48,22,
		0,102,112,0,106,16,78,250,109,101,114,111,32,100,
		101,32,115,101,114,105,101,0,112,1,73,36,102,1,
		48,43,0,48,22,0,102,112,0,120,112,1,73,36,
		103,1,48,44,0,48,22,0,102,112,0,9,112,1,
		73,36,104,1,48,45,0,48,22,0,102,112,0,92,
		2,112,1,73,36,105,1,48,46,0,48,22,0,102,
		112,0,106,9,78,186,32,83,101,114,105,101,0,112,
		1,73,36,106,1,48,47,0,48,22,0,102,112,0,
		9,112,1,73,36,107,1,48,48,0,48,22,0,102,
		112,0,176,49,0,92,50,12,1,112,1,73,36,108,
		1,48,50,0,48,22,0,102,112,0,92,56,112,1,
		73,36,109,1,48,51,0,48,22,0,102,112,0,9,
		112,1,73,36,110,1,48,52,0,48,22,0,102,112,
		0,112,0,73,36,112,1,48,40,0,48,22,0,102,
		112,0,112,0,73,36,113,1,48,33,0,48,22,0,
		102,112,0,95,1,112,1,73,36,114,1,48,41,0,
		48,22,0,102,112,0,92,18,112,1,73,36,115,1,
		48,42,0,48,22,0,102,112,0,106,16,78,250,109,
		101,114,111,32,100,101,32,108,237,110,101,97,0,112,
		1,73,36,116,1,48,43,0,48,22,0,102,112,0,
		120,112,1,73,36,117,1,48,44,0,48,22,0,102,
		112,0,9,112,1,73,36,118,1,48,45,0,48,22,
		0,102,112,0,92,2,112,1,73,36,119,1,48,46,
		0,48,22,0,102,112,0,106,9,78,186,32,76,237,
		110,101,97,0,112,1,73,36,120,1,48,47,0,48,
		22,0,102,112,0,120,112,1,73,36,121,1,48,48,
		0,48,22,0,102,112,0,106,5,57,57,57,57,0,
		112,1,73,36,122,1,48,50,0,48,22,0,102,112,
		0,92,40,112,1,73,36,123,1,48,51,0,48,22,
		0,102,112,0,9,112,1,73,36,124,1,48,52,0,
		48,22,0,102,112,0,112,0,73,36,126,1,48,40,
		0,48,22,0,102,112,0,112,0,73,36,127,1,48,
		33,0,48,22,0,102,112,0,95,1,112,1,73,36,
		128,1,48,41,0,48,22,0,102,112,0,92,19,112,
		1,73,36,129,1,48,42,0,48,22,0,102,112,0,
		106,17,67,243,100,105,103,111,32,100,101,32,98,97,
		114,114,97,115,0,112,1,73,36,130,1,48,43,0,
		48,22,0,102,112,0,120,112,1,73,36,131,1,48,
		44,0,48,22,0,102,112,0,120,112,1,73,36,132,
		1,48,45,0,48,22,0,102,112,0,92,2,112,1,
		73,36,133,1,48,46,0,48,22,0,102,112,0,106,
		10,67,46,32,98,97,114,114,97,115,0,112,1,73,
		36,134,1,48,47,0,48,22,0,102,112,0,9,112,
		1,73,36,135,1,48,48,0,48,22,0,102,112,0,
		176,49,0,92,50,12,1,112,1,73,36,136,1,48,
		50,0,48,22,0,102,112,0,92,100,112,1,73,36,
		137,1,48,51,0,48,22,0,102,112,0,9,112,1,
		73,36,138,1,48,52,0,48,22,0,102,112,0,112,
		0,73,36,140,1,48,40,0,48,22,0,102,112,0,
		112,0,73,36,141,1,48,33,0,48,22,0,102,112,
		0,95,1,112,1,73,36,142,1,48,41,0,48,22,
		0,102,112,0,92,20,112,1,73,36,143,1,48,42,
		0,48,22,0,102,112,0,106,10,80,114,111,109,111,
		99,105,243,110,0,112,1,73,36,144,1,48,43,0,
		48,22,0,102,112,0,120,112,1,73,36,145,1,48,
		44,0,48,22,0,102,112,0,9,112,1,73,36,146,
		1,48,45,0,48,22,0,102,112,0,92,2,112,1,
		73,36,147,1,48,46,0,48,22,0,102,112,0,106,
		5,80,114,109,46,0,112,1,73,36,148,1,48,47,
		0,48,22,0,102,112,0,9,112,1,73,36,149,1,
		48,48,0,48,22,0,102,112,0,176,49,0,92,50,
		12,1,112,1,73,36,150,1,48,50,0,48,22,0,
		102,112,0,92,20,112,1,73,36,151,1,48,51,0,
		48,22,0,102,112,0,120,112,1,73,36,152,1,48,
		52,0,48,22,0,102,112,0,112,0,73,36,154,1,
		48,40,0,48,22,0,102,112,0,112,0,73,36,155,
		1,48,33,0,48,22,0,102,112,0,95,1,112,1,
		73,36,156,1,48,41,0,48,22,0,102,112,0,92,
		21,112,1,73,36,157,1,48,42,0,48,22,0,102,
		112,0,106,7,79,102,101,114,116,97,0,112,1,73,
		36,158,1,48,43,0,48,22,0,102,112,0,120,112,
		1,73,36,159,1,48,44,0,48,22,0,102,112,0,
		9,112,1,73,36,160,1,48,45,0,48,22,0,102,
		112,0,92,2,112,1,73,36,161,1,48,46,0,48,
		22,0,102,112,0,106,5,79,102,101,46,0,112,1,
		73,36,162,1,48,47,0,48,22,0,102,112,0,9,
		112,1,73,36,163,1,48,48,0,48,22,0,102,112,
		0,176,49,0,92,50,12,1,112,1,73,36,164,1,
		48,50,0,48,22,0,102,112,0,92,20,112,1,73,
		36,165,1,48,51,0,48,22,0,102,112,0,120,112,
		1,73,36,166,1,48,52,0,48,22,0,102,112,0,
		112,0,73,36,168,1,48,40,0,48,22,0,102,112,
		0,112,0,73,36,169,1,48,33,0,48,22,0,102,
		112,0,95,1,112,1,73,36,170,1,48,41,0,48,
		22,0,102,112,0,92,22,112,1,73,36,171,1,48,
		42,0,48,22,0,102,112,0,106,7,70,97,99,116,
		111,114,0,112,1,73,36,172,1,48,43,0,48,22,
		0,102,112,0,120,112,1,73,36,173,1,48,44,0,
		48,22,0,102,112,0,9,112,1,73,36,174,1,48,
		45,0,48,22,0,102,112,0,92,3,112,1,73,36,
		175,1,48,46,0,48,22,0,102,112,0,106,7,70,
		97,99,116,111,114,0,112,1,73,36,176,1,48,47,
		0,48,22,0,102,112,0,120,112,1,73,36,177,1,
		48,48,0,48,22,0,102,112,0,106,18,64,69,32,
		57,57,57,44,57,57,57,46,57,57,57,57,57,57,
		0,112,1,73,36,178,1,48,50,0,48,22,0,102,
		112,0,92,60,112,1,73,36,179,1,48,51,0,48,
		22,0,102,112,0,9,112,1,73,36,180,1,48,52,
		0,48,22,0,102,112,0,112,0,73,36,182,1,48,
		40,0,48,22,0,102,112,0,112,0,73,36,183,1,
		48,33,0,48,22,0,102,112,0,95,1,112,1,73,
		36,184,1,48,41,0,48,22,0,102,112,0,92,23,
		112,1,73,36,185,1,48,42,0,48,22,0,102,112,
		0,106,18,80,111,114,99,101,110,116,97,106,101,32,
		73,46,86,46,65,46,0,112,1,73,36,186,1,48,
		43,0,48,22,0,102,112,0,120,112,1,73,36,187,
		1,48,44,0,48,22,0,102,112,0,120,112,1,73,
		36,188,1,48,45,0,48,22,0,102,112,0,92,2,
		112,1,73,36,189,1,48,46,0,48,22,0,102,112,
		0,106,5,37,73,86,65,0,112,1,73,36,190,1,
		48,47,0,48,22,0,102,112,0,120,112,1,73,36,
		191,1,48,48,0,48,22,0,102,112,0,106,11,34,
		64,69,32,57,57,46,57,57,34,0,112,1,73,36,
		192,1,48,50,0,48,22,0,102,112,0,92,40,112,
		1,73,36,193,1,48,51,0,48,22,0,102,112,0,
		9,112,1,73,36,194,1,48,52,0,48,22,0,102,
		112,0,112,0,73,36,198,1,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,55,0,2,0,116,55,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}
