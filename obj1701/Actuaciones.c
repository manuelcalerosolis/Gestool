/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\Actuaciones.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TACTUACIONES );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TMANT );
HB_FUNC_STATIC( TACTUACIONES_OPENFILES );
HB_FUNC_STATIC( TACTUACIONES_DEFINEFILES );
HB_FUNC_STATIC( TACTUACIONES_RESOURCE );
HB_FUNC_STATIC( TACTUACIONES_LPRESAVE );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( ERRORMESSAGE );
HB_FUNC_EXTERN( DBFSERVER );
HB_FUNC_EXTERN( CDRIVER );
HB_FUNC_EXTERN( TDIALOG );
HB_FUNC_EXTERN( LBLTITLE );
HB_FUNC_EXTERN( TGETHLP );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( NOTVALID );
HB_FUNC_EXTERN( TBUTTON );
HB_FUNC_EXTERN( MSGINFO );
HB_FUNC_EXTERN( RTRIM );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_ACTUACIONES )
{ "TACTUACIONES", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TACTUACIONES )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TMANT", {HB_FS_PUBLIC}, {HB_FUNCNAME( TMANT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TACTUACIONES_OPENFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TACTUACIONES_OPENFILES )}, NULL },
{ "TACTUACIONES_DEFINEFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TACTUACIONES_DEFINEFILES )}, NULL },
{ "TACTUACIONES_RESOURCE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TACTUACIONES_RESOURCE )}, NULL },
{ "TACTUACIONES_LPRESAVE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TACTUACIONES_LPRESAVE )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "ERRORMESSAGE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORMESSAGE )}, NULL },
{ "CLOSEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPATH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBFSERVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBFSERVER )}, NULL },
{ "CDRIVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CDRIVER )}, NULL },
{ "ADDFIELD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDINDEX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDIALOG", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDIALOG )}, NULL },
{ "LBLTITLE", {HB_FS_PUBLIC}, {HB_FUNCNAME( LBLTITLE )}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGETHLP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGETHLP )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "CCODACT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCODACT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOTVALID", {HB_FS_PUBLIC}, {HB_FUNCNAME( NOTVALID )}, NULL },
{ "CALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDESACT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CDESACT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBUTTON )}, NULL },
{ "LPRESAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGINFO", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGINFO )}, NULL },
{ "ADDFASTKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BSTART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BLCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BMOVED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BPAINTED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BRCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NRESULT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SEEKINORD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( RTRIM )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_ACTUACIONES, ".\\.\\Prg\\Actuaciones.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_ACTUACIONES
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_ACTUACIONES )
   #include "hbiniseg.h"
#endif

HB_FUNC( TACTUACIONES )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,58,0,36,7,0,103,2,0,100,8,
		29,92,1,176,1,0,104,2,0,12,1,29,81,1,
		166,19,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,13,84,65,99,116,117,97,99,105,111,110,101,
		115,0,108,4,4,1,0,108,0,112,3,80,2,36,
		9,0,48,5,0,95,2,100,106,19,103,99,95,112,
		111,119,101,114,95,100,114,105,108,108,50,95,49,54,
		0,95,1,121,72,121,72,121,72,106,5,99,77,114,
		117,0,4,1,0,9,112,5,73,36,10,0,48,5,
		0,95,2,100,97,197,227,9,0,95,1,121,72,121,
		72,121,72,106,8,99,66,105,116,109,97,112,0,4,
		1,0,9,112,5,73,36,12,0,48,6,0,95,2,
		106,10,79,112,101,110,70,105,108,101,115,0,108,7,
		95,1,121,72,121,72,121,72,112,3,73,36,14,0,
		48,6,0,95,2,106,12,68,101,102,105,110,101,70,
		105,108,101,115,0,108,8,95,1,121,72,121,72,121,
		72,112,3,73,36,16,0,48,6,0,95,2,106,9,
		82,101,115,111,117,114,99,101,0,108,9,95,1,121,
		72,121,72,121,72,112,3,73,36,18,0,48,6,0,
		95,2,106,9,108,80,114,101,83,97,118,101,0,108,
		10,95,1,121,72,121,72,121,72,112,3,73,36,20,
		0,48,11,0,95,2,112,0,73,167,14,0,0,176,
		12,0,104,2,0,95,2,20,2,168,48,13,0,95,
		2,112,0,80,3,176,14,0,95,3,106,10,73,110,
		105,116,67,108,97,115,115,0,12,2,28,12,48,15,
		0,95,3,164,146,1,0,73,95,3,110,7,48,13,
		0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TACTUACIONES_OPENFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,26,0,120,80,2,36,28,0,176,16,
		0,89,15,0,1,0,0,0,176,17,0,95,1,12,
		1,6,12,1,80,4,36,30,0,95,1,100,8,28,
		5,9,80,1,36,32,0,113,59,0,0,36,34,0,
		176,18,0,48,19,0,102,112,0,12,1,28,18,36,
		35,0,48,20,0,102,48,21,0,102,112,0,112,1,
		73,36,38,0,48,22,0,48,19,0,102,112,0,9,
		95,1,68,112,2,73,114,87,0,0,36,40,0,115,
		80,3,36,42,0,176,23,0,106,43,73,109,112,111,
		115,105,98,108,101,32,97,98,114,105,114,32,116,111,
		100,97,115,32,108,97,115,32,98,97,115,101,115,32,
		100,101,32,100,97,116,111,115,13,10,0,176,24,0,
		95,3,12,1,72,20,1,36,43,0,48,25,0,102,
		112,0,73,36,44,0,9,80,2,36,48,0,176,16,
		0,95,4,20,1,36,50,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TACTUACIONES_DEFINEFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,58,0,95,1,100,8,28,10,48,26,
		0,102,112,0,80,1,36,60,0,48,2,0,176,27,
		0,106,16,65,99,116,117,97,99,105,111,110,101,115,
		46,68,98,102,0,106,12,65,99,116,117,97,99,105,
		111,110,101,115,0,12,2,106,16,65,99,116,117,97,
		99,105,111,110,101,115,46,68,98,102,0,106,7,65,
		99,116,117,97,99,0,176,28,0,12,0,106,12,65,
		99,116,117,97,99,105,111,110,101,115,0,95,1,112,
		5,80,3,36,62,0,48,29,0,95,3,106,8,99,
		67,111,100,65,99,116,0,106,2,67,0,92,3,121,
		100,100,100,100,106,7,67,243,100,105,103,111,0,9,
		92,100,9,4,0,0,112,13,73,36,63,0,48,29,
		0,95,3,106,8,99,68,101,115,65,99,116,0,106,
		2,67,0,92,35,121,100,100,100,100,106,7,78,111,
		109,98,114,101,0,9,93,144,1,9,4,0,0,112,
		13,73,36,65,0,48,30,0,95,3,106,8,99,67,
		111,100,65,99,116,0,106,16,65,99,116,117,97,99,
		105,111,110,101,115,46,67,100,120,0,106,8,99,67,
		111,100,65,99,116,0,100,100,9,9,106,7,67,243,
		100,105,103,111,0,100,100,120,9,112,12,73,36,66,
		0,48,30,0,95,3,106,8,99,68,101,115,65,99,
		116,0,106,16,65,99,116,117,97,99,105,111,110,101,
		115,46,67,100,120,0,106,8,99,68,101,115,65,99,
		116,0,100,100,9,9,106,7,78,111,109,98,114,101,
		0,100,100,120,9,112,12,73,36,70,0,95,3,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TACTUACIONES_RESOURCE )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,74,0,102,80,2,36,79,0,48,2,
		0,176,31,0,12,0,100,100,100,100,176,32,0,95,
		1,12,1,106,12,97,99,116,117,97,99,105,111,110,
		101,115,0,72,106,6,72,111,114,97,115,0,100,9,
		100,100,100,100,100,9,100,100,100,100,100,9,100,106,
		5,111,68,108,103,0,100,100,112,24,80,3,36,86,
		0,48,33,0,176,34,0,12,0,92,110,89,47,0,
		1,0,1,0,2,0,176,35,0,12,0,121,8,28,
		16,48,36,0,48,19,0,95,255,112,0,112,0,25,
		16,48,37,0,48,19,0,95,255,112,0,95,1,112,
		1,6,95,3,100,106,3,64,33,0,89,36,0,0,
		0,2,0,4,0,2,0,176,38,0,95,255,48,39,
		0,48,19,0,95,254,112,0,112,0,120,106,2,48,
		0,12,4,6,100,100,100,100,100,9,89,14,0,0,
		0,1,0,1,0,95,255,122,8,6,100,9,9,100,
		100,100,100,100,100,100,100,100,112,25,80,4,36,91,
		0,48,33,0,176,34,0,12,0,92,120,89,47,0,
		1,0,1,0,2,0,176,35,0,12,0,121,8,28,
		16,48,40,0,48,19,0,95,255,112,0,112,0,25,
		16,48,41,0,48,19,0,95,255,112,0,95,1,112,
		1,6,95,3,100,100,100,100,100,100,100,100,9,89,
		15,0,0,0,1,0,1,0,95,255,92,3,69,6,
		100,9,9,100,100,100,100,100,100,100,100,100,112,25,
		73,36,97,0,48,33,0,176,42,0,12,0,122,89,
		36,0,0,0,3,0,2,0,1,0,3,0,48,43,
		0,95,255,95,254,112,1,28,12,48,44,0,95,253,
		122,112,1,25,3,100,6,95,3,100,100,9,89,15,
		0,0,0,1,0,1,0,95,255,92,3,69,6,100,
		100,9,112,10,73,36,103,0,48,33,0,176,42,0,
		12,0,92,2,89,17,0,0,0,1,0,3,0,48,
		44,0,95,255,112,0,6,95,3,100,100,9,100,100,
		100,120,112,10,73,36,109,0,48,33,0,176,42,0,
		12,0,93,47,2,90,28,176,45,0,106,18,65,121,
		117,100,97,32,110,111,32,100,101,102,105,110,105,100,
		97,0,12,1,6,95,3,100,100,9,100,100,100,120,
		112,10,73,36,111,0,95,1,92,3,69,28,51,36,
		112,0,48,46,0,95,3,92,116,89,36,0,0,0,
		3,0,2,0,1,0,3,0,48,43,0,95,255,95,
		254,112,1,28,12,48,44,0,95,253,122,112,1,25,
		3,100,6,112,2,73,36,115,0,48,47,0,95,3,
		89,17,0,0,0,1,0,4,0,48,48,0,95,255,
		112,0,6,112,1,73,36,117,0,48,22,0,95,3,
		48,49,0,95,3,112,0,48,50,0,95,3,112,0,
		48,51,0,95,3,112,0,120,100,100,100,48,52,0,
		95,3,112,0,100,100,100,112,11,73,36,119,0,48,
		53,0,95,3,112,0,122,8,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TACTUACIONES_LPRESAVE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,125,0,95,1,122,8,31,9,95,1,
		92,4,8,28,90,36,127,0,48,54,0,48,19,0,
		102,112,0,48,36,0,48,19,0,102,112,0,112,0,
		106,8,99,67,111,100,65,99,116,0,112,2,28,53,
		36,128,0,176,23,0,106,18,67,243,100,105,103,111,
		32,121,97,32,101,120,105,115,116,101,32,0,176,55,
		0,48,36,0,48,19,0,102,112,0,112,0,12,1,
		72,20,1,36,129,0,9,110,7,36,134,0,176,18,
		0,48,40,0,48,19,0,102,112,0,112,0,12,1,
		28,71,36,135,0,176,23,0,106,53,76,97,32,100,
		101,115,99,114,105,112,99,105,243,110,32,100,101,32,
		108,97,32,97,99,116,117,97,99,105,243,110,32,110,
		111,32,112,117,101,100,101,32,101,115,116,97,114,32,
		118,97,99,237,97,46,0,20,1,36,136,0,9,110,
		7,36,139,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,58,0,2,0,116,58,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}
