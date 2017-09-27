/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\TDetFideliza.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TDETFIDELIZA );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TDET );
HB_FUNC_STATIC( TDETFIDELIZA_OPENFILES );
HB_FUNC_STATIC( TDETFIDELIZA_CLOSEFILES );
HB_FUNC_STATIC( TDETFIDELIZA_DEFINEFILES );
HB_FUNC_STATIC( TDETFIDELIZA_RESOURCE );
HB_FUNC_STATIC( TDETFIDELIZA_LPRESAVE );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( CDRIVER );
HB_FUNC_EXTERN( CGETNEWFILENAME );
HB_FUNC_EXTERN( DBFSERVER );
HB_FUNC_EXTERN( TDIALOG );
HB_FUNC_EXTERN( LBLTITLE );
HB_FUNC_EXTERN( TRADMENU );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( TGETHLP );
HB_FUNC_EXTERN( CPOUDIV );
HB_FUNC_EXTERN( MASUND );
HB_FUNC_EXTERN( TBUTTON );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TDETFIDELIZA )
{ "TDETFIDELIZA", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TDETFIDELIZA )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TDET", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDET )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDETFIDELIZA_OPENFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDETFIDELIZA_OPENFILES )}, NULL },
{ "TDETFIDELIZA_CLOSEFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDETFIDELIZA_CLOSEFILES )}, NULL },
{ "TDETFIDELIZA_DEFINEFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDETFIDELIZA_DEFINEFILES )}, NULL },
{ "TDETFIDELIZA_RESOURCE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDETFIDELIZA_RESOURCE )}, NULL },
{ "TDETFIDELIZA_LPRESAVE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDETFIDELIZA_LPRESAVE )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPATH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "CLOSEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDRIVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CDRIVER )}, NULL },
{ "CGETNEWFILENAME", {HB_FS_PUBLIC}, {HB_FUNCNAME( CGETNEWFILENAME )}, NULL },
{ "DBFSERVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBFSERVER )}, NULL },
{ "ADDFIELD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDINDEX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NIMPUNI", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBFVIR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NPCTLIN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDIALOG", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDIALOG )}, NULL },
{ "LBLTITLE", {HB_FS_PUBLIC}, {HB_FUNCNAME( LBLTITLE )}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TRADMENU", {HB_FS_PUBLIC}, {HB_FUNCNAME( TRADMENU )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "NIMPUNI", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGETHLP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGETHLP )}, NULL },
{ "NIMPORTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NIMPORTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPOUDIV", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPOUDIV )}, NULL },
{ "NUNIDADES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NUNIDADES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MASUND", {HB_FS_PUBLIC}, {HB_FUNCNAME( MASUND )}, NULL },
{ "NPORCEN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NPORCEN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBUTTON )}, NULL },
{ "LPRESAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDFASTKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BLCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BMOVED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BPAINTED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BRCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NRESULT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NLINEAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCODIGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODIGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OPARENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TDETFIDELIZA, ".\\.\\Prg\\TDetFideliza.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TDETFIDELIZA
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TDETFIDELIZA )
   #include "hbiniseg.h"
#endif

HB_FUNC( TDETFIDELIZA )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,65,0,36,7,0,103,2,0,100,8,
		29,136,1,176,1,0,104,2,0,12,1,29,125,1,
		166,63,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,13,84,68,101,116,70,105,100,101,108,105,122,
		97,0,108,4,4,1,0,108,0,112,3,80,2,36,
		9,0,48,5,0,95,2,100,106,29,103,99,95,105,
		110,100,117,115,116,114,105,97,108,95,114,111,98,111,
		116,95,109,111,110,101,121,95,49,54,0,95,1,121,
		72,121,72,121,72,106,5,99,77,114,117,0,4,1,
		0,9,112,5,73,36,10,0,48,5,0,95,2,100,
		97,197,227,9,0,95,1,121,72,121,72,121,72,106,
		8,99,66,105,116,109,97,112,0,4,1,0,9,112,
		5,73,36,12,0,48,6,0,95,2,106,10,79,112,
		101,110,70,105,108,101,115,0,108,7,95,1,121,72,
		121,72,121,72,112,3,73,36,13,0,48,6,0,95,
		2,106,11,67,108,111,115,101,70,105,108,101,115,0,
		108,8,95,1,121,72,121,72,121,72,112,3,73,36,
		15,0,48,6,0,95,2,106,12,68,101,102,105,110,
		101,70,105,108,101,115,0,108,9,95,1,121,72,121,
		72,121,72,112,3,73,36,17,0,48,6,0,95,2,
		106,9,82,101,115,111,117,114,99,101,0,108,10,95,
		1,121,72,121,72,121,72,112,3,73,36,19,0,48,
		6,0,95,2,106,9,108,80,114,101,83,97,118,101,
		0,108,11,95,1,121,72,121,72,121,72,112,3,73,
		36,21,0,48,12,0,95,2,112,0,73,167,14,0,
		0,176,13,0,104,2,0,95,2,20,2,168,48,14,
		0,95,2,112,0,80,3,176,15,0,95,3,106,10,
		73,110,105,116,67,108,97,115,115,0,12,2,28,12,
		48,16,0,95,3,164,146,1,0,73,95,3,110,7,
		48,14,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDETFIDELIZA_OPENFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,2,2,36,27,0,120,80,3,36,30,0,95,1,
		100,8,28,5,9,80,1,36,31,0,95,2,100,8,
		28,10,48,17,0,102,112,0,80,2,36,33,0,176,
		18,0,89,15,0,1,0,0,0,176,19,0,95,1,
		12,1,6,12,1,80,4,36,34,0,113,61,0,0,
		36,36,0,176,20,0,48,21,0,102,112,0,12,1,
		28,20,36,37,0,48,22,0,102,48,23,0,102,95,
		2,112,1,112,1,73,36,40,0,48,24,0,48,21,
		0,102,112,0,9,95,1,68,112,2,73,114,95,0,
		0,36,42,0,115,73,36,44,0,176,25,0,106,60,
		73,109,112,111,115,105,98,108,101,32,97,98,114,105,
		114,32,108,97,115,32,98,97,115,101,115,32,100,101,
		32,100,97,116,111,115,32,100,101,116,97,108,108,101,
		32,100,101,32,102,105,100,101,108,105,122,97,99,105,
		243,110,46,0,20,1,36,46,0,48,26,0,102,112,
		0,73,36,48,0,9,80,3,36,52,0,176,18,0,
		95,4,20,1,36,54,0,95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDETFIDELIZA_CLOSEFILES )
{
	static const HB_BYTE pcode[] =
	{
		36,60,0,176,20,0,48,21,0,102,112,0,12,1,
		31,17,36,61,0,48,27,0,48,21,0,102,112,0,
		112,0,73,36,64,0,48,22,0,102,100,112,1,73,
		36,66,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDETFIDELIZA_DEFINEFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,1,4,36,74,0,95,1,100,8,28,10,48,17,
		0,102,112,0,80,1,36,75,0,95,3,100,8,28,
		5,9,80,3,36,76,0,95,4,100,8,28,18,106,
		12,68,101,116,70,105,100,101,108,105,122,97,0,80,
		4,36,77,0,95,2,100,8,28,9,176,28,0,12,
		0,80,2,36,79,0,95,3,28,18,36,80,0,176,
		29,0,95,4,100,100,95,1,12,4,80,4,36,83,
		0,48,2,0,176,30,0,95,4,95,4,12,2,95,
		4,106,9,68,101,116,70,105,100,101,108,0,95,2,
		106,35,108,105,110,101,97,115,32,100,101,32,112,114,
		111,103,114,97,109,97,32,100,101,32,102,105,100,101,
		108,105,122,97,99,105,243,110,0,95,1,112,5,80,
		5,36,85,0,48,31,0,95,5,106,8,99,67,111,
		100,105,103,111,0,106,2,67,0,92,3,121,100,100,
		100,100,106,7,67,243,100,105,103,111,0,9,100,120,
		4,0,0,112,13,73,36,86,0,48,31,0,95,5,
		106,7,110,76,105,110,101,97,0,106,2,78,0,122,
		121,100,100,100,100,106,6,76,237,110,101,97,0,9,
		100,120,4,0,0,112,13,73,36,87,0,48,31,0,
		95,5,106,8,110,73,109,112,85,110,105,0,106,2,
		78,0,122,121,100,100,100,100,106,19,73,109,112,111,
		114,116,101,32,111,32,117,110,105,100,97,100,101,115,
		0,9,100,120,4,0,0,112,13,73,36,88,0,48,
		31,0,95,5,106,9,110,73,109,112,111,114,116,101,
		0,106,2,78,0,92,16,92,6,100,100,100,100,106,
		8,73,109,112,111,114,116,101,0,9,100,9,4,0,
		0,112,13,73,36,89,0,48,31,0,95,5,106,10,
		110,85,110,105,100,97,100,101,115,0,106,2,78,0,
		92,16,92,6,100,100,100,100,106,9,85,110,105,100,
		97,100,101,115,0,9,100,9,4,0,0,112,13,73,
		36,90,0,48,31,0,95,5,106,8,110,80,99,116,
		76,105,110,0,106,2,78,0,122,121,100,100,100,100,
		106,20,80,111,114,99,101,110,116,117,97,108,32,111,
		32,108,105,110,101,97,108,0,9,100,9,4,0,0,
		112,13,73,36,91,0,48,31,0,95,5,106,8,110,
		80,111,114,99,101,110,0,106,2,78,0,92,6,92,
		2,100,100,100,100,106,11,80,111,114,99,101,110,116,
		97,106,101,0,9,100,9,4,0,0,112,13,73,36,
		92,0,48,31,0,95,5,106,8,110,76,105,110,101,
		97,108,0,106,2,78,0,92,16,92,6,100,100,100,
		100,106,7,76,105,110,101,97,108,0,9,100,9,4,
		0,0,112,13,73,36,93,0,48,31,0,95,5,106,
		9,109,70,97,109,105,108,105,97,0,106,2,77,0,
		92,10,121,100,100,100,100,106,9,70,97,109,105,108,
		105,97,115,0,9,100,9,4,0,0,112,13,73,36,
		95,0,48,32,0,95,5,106,8,99,67,111,100,105,
		103,111,0,95,4,106,8,99,67,111,100,105,103,111,
		0,100,100,9,9,100,100,100,120,9,112,12,73,36,
		96,0,48,32,0,95,5,106,7,110,76,105,110,101,
		97,0,95,4,106,24,99,67,111,100,105,103,111,32,
		43,32,83,116,114,40,32,110,76,105,110,101,97,32,
		41,0,100,100,9,9,100,100,100,120,9,112,12,73,
		36,100,0,95,5,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDETFIDELIZA_RESOURCE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,104,0,102,80,2,36,108,0,95,1,
		122,8,28,36,36,109,0,48,33,0,48,34,0,95,
		2,112,0,122,112,1,73,36,110,0,48,35,0,48,
		34,0,95,2,112,0,122,112,1,73,36,113,0,48,
		2,0,176,36,0,12,0,100,100,100,100,176,37,0,
		95,1,12,1,106,23,108,105,110,101,97,115,32,100,
		101,32,102,105,100,101,108,105,122,97,99,105,243,110,
		0,72,106,16,68,101,116,70,105,100,101,108,105,122,
		97,99,105,111,110,0,100,9,100,100,100,100,100,9,
		100,100,100,100,100,9,100,106,5,111,68,108,103,0,
		100,100,112,24,80,3,36,117,0,48,38,0,176,39,
		0,12,0,89,47,0,1,0,1,0,2,0,176,40,
		0,12,0,121,8,28,16,48,41,0,48,34,0,95,
		255,112,0,112,0,25,16,48,33,0,48,34,0,95,
		255,112,0,95,1,112,1,6,95,3,100,92,100,92,
		101,4,2,0,100,100,100,100,9,100,100,112,11,73,
		36,124,0,48,38,0,176,42,0,12,0,92,110,89,
		47,0,1,0,1,0,2,0,176,40,0,12,0,121,
		8,28,16,48,43,0,48,34,0,95,255,112,0,112,
		0,25,16,48,44,0,48,34,0,95,255,112,0,95,
		1,112,1,6,95,3,100,176,45,0,12,0,100,100,
		100,100,100,100,9,89,24,0,0,0,1,0,2,0,
		48,41,0,48,34,0,95,255,112,0,112,0,122,8,
		6,100,9,120,100,100,100,100,100,100,100,100,100,112,
		25,73,36,131,0,48,38,0,176,42,0,12,0,92,
		120,89,47,0,1,0,1,0,2,0,176,40,0,12,
		0,121,8,28,16,48,46,0,48,34,0,95,255,112,
		0,112,0,25,16,48,47,0,48,34,0,95,255,112,
		0,95,1,112,1,6,95,3,100,176,48,0,12,0,
		100,100,100,100,100,100,9,89,25,0,0,0,1,0,
		2,0,48,41,0,48,34,0,95,255,112,0,112,0,
		92,2,8,6,100,9,120,100,100,100,100,100,100,100,
		100,100,112,25,73,36,137,0,48,38,0,176,42,0,
		12,0,93,140,0,89,47,0,1,0,1,0,2,0,
		176,40,0,12,0,121,8,28,16,48,49,0,48,34,
		0,95,255,112,0,112,0,25,16,48,50,0,48,34,
		0,95,255,112,0,95,1,112,1,6,95,3,100,106,
		10,64,69,32,57,57,57,46,57,57,0,100,100,100,
		100,100,100,9,100,100,9,120,100,100,100,100,100,100,
		100,100,100,112,25,73,36,143,0,48,38,0,176,51,
		0,12,0,122,89,36,0,0,0,3,0,2,0,1,
		0,3,0,48,52,0,95,255,95,254,112,1,28,12,
		48,27,0,95,253,122,112,1,25,3,100,6,95,3,
		100,100,9,89,15,0,0,0,1,0,1,0,95,255,
		92,3,69,6,100,100,9,112,10,73,36,149,0,48,
		38,0,176,51,0,12,0,92,2,89,17,0,0,0,
		1,0,3,0,48,27,0,95,255,112,0,6,95,3,
		100,100,9,100,100,100,120,112,10,73,36,151,0,95,
		1,92,3,69,28,51,36,152,0,48,53,0,95,3,
		92,116,89,36,0,0,0,3,0,2,0,1,0,3,
		0,48,52,0,95,255,95,254,112,1,28,12,48,27,
		0,95,253,122,112,1,25,3,100,6,112,2,73,36,
		155,0,48,24,0,95,3,48,54,0,95,3,112,0,
		48,55,0,95,3,112,0,48,56,0,95,3,112,0,
		120,100,100,100,48,57,0,95,3,112,0,100,100,100,
		112,11,73,36,157,0,48,58,0,95,3,112,0,122,
		8,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDETFIDELIZA_LPRESAVE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,163,0,48,41,0,48,34,0,102,112,
		0,112,0,122,8,28,83,48,59,0,48,21,0,102,
		112,0,112,0,121,35,28,68,36,164,0,176,25,0,
		106,50,73,109,112,111,114,116,101,32,100,101,32,108,
		97,32,111,102,101,114,116,97,32,110,111,32,112,117,
		101,100,101,32,115,101,114,32,109,101,110,111,114,32,
		113,117,101,32,99,101,114,111,46,0,20,1,36,165,
		0,9,110,7,36,168,0,48,41,0,48,34,0,102,
		112,0,112,0,92,2,8,28,84,48,46,0,48,21,
		0,102,112,0,112,0,121,35,28,69,36,169,0,176,
		25,0,106,51,85,110,105,100,97,100,101,115,32,100,
		101,32,108,97,32,111,102,101,114,116,97,32,110,111,
		32,112,117,101,100,101,32,115,101,114,32,109,101,110,
		111,114,32,113,117,101,32,99,101,114,111,46,0,20,
		1,36,170,0,9,110,7,36,173,0,48,60,0,48,
		34,0,102,112,0,48,61,0,48,21,0,48,62,0,
		102,112,0,112,0,112,0,112,1,73,36,175,0,120,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,65,0,2,0,116,65,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

