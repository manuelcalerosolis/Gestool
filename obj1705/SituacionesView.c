/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\Views\SituacionesView.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( SITUACIONESVIEW );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( SQLBASEVIEW );
HB_FUNC_STATIC( SITUACIONESVIEW_NEW );
HB_FUNC_STATIC( SITUACIONESVIEW_DIALOG );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( TDIALOG );
HB_FUNC_EXTERN( TGETHLP );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( TBUTTON );
HB_FUNC_EXTERN( VALIDATEDIALOG );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_SITUACIONESVIEW )
{ "SITUACIONESVIEW", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( SITUACIONESVIEW )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "SQLBASEVIEW", {HB_FS_PUBLIC}, {HB_FUNCNAME( SQLBASEVIEW )}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SITUACIONESVIEW_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SITUACIONESVIEW_NEW )}, NULL },
{ "SITUACIONESVIEW_DIALOG", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SITUACIONESVIEW_DIALOG )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OCONTROLLER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDIALOG", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDIALOG )}, NULL },
{ "LBLTITLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGETHLP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGETHLP )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "HBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OMODEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OCONTROLLER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VALIDATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ISZOOMMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBUTTON )}, NULL },
{ "VALIDATEDIALOG", {HB_FS_PUBLIC}, {HB_FUNCNAME( VALIDATEDIALOG )}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDFASTKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CLICK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BLCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BMOVED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BPAINTED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BRCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NRESULT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_SITUACIONESVIEW, ".\\Prg\\Views\\SituacionesView.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_SITUACIONESVIEW
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_SITUACIONESVIEW )
   #include "hbiniseg.h"
#endif

HB_FUNC( SITUACIONESVIEW )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,37,0,36,6,0,103,2,0,100,8,
		29,185,0,176,1,0,104,2,0,12,1,29,174,0,
		166,112,0,0,122,80,1,48,2,0,176,3,0,12,
		0,106,16,83,105,116,117,97,99,105,111,110,101,115,
		86,105,101,119,0,108,4,4,1,0,108,0,112,3,
		80,2,36,8,0,48,5,0,95,2,106,4,78,101,
		119,0,108,6,95,1,121,72,121,72,121,72,112,3,
		73,36,10,0,48,5,0,95,2,106,7,68,105,97,
		108,111,103,0,108,7,95,1,121,72,121,72,121,72,
		112,3,73,36,12,0,48,8,0,95,2,112,0,73,
		167,14,0,0,176,9,0,104,2,0,95,2,20,2,
		168,48,10,0,95,2,112,0,80,3,176,11,0,95,
		3,106,10,73,110,105,116,67,108,97,115,115,0,12,
		2,28,12,48,12,0,95,3,164,146,1,0,73,95,
		3,110,7,48,10,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SITUACIONESVIEW_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,18,0,48,13,0,102,95,1,112,1,
		73,36,20,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SITUACIONESVIEW_DIALOG )
{
	static const HB_BYTE pcode[] =
	{
		13,4,0,36,24,0,102,80,1,36,30,0,48,2,
		0,176,14,0,12,0,100,100,100,100,48,15,0,95,
		1,112,0,106,10,115,105,116,117,97,99,105,243,110,
		0,72,106,10,83,73,84,85,65,67,73,79,78,0,
		100,9,100,100,100,100,100,9,100,100,100,100,100,9,
		100,106,5,111,68,108,103,0,100,100,112,24,80,2,
		36,37,0,48,16,0,176,17,0,12,0,92,100,89,
		78,0,1,0,1,0,1,0,176,18,0,12,0,121,
		8,28,31,48,19,0,48,20,0,48,21,0,95,255,
		112,0,112,0,112,0,106,7,110,111,109,98,114,101,
		0,1,25,32,95,1,165,48,19,0,48,20,0,48,
		21,0,95,255,112,0,112,0,112,0,106,7,110,111,
		109,98,114,101,0,2,6,95,2,100,100,89,31,0,
		0,0,1,0,1,0,48,22,0,48,21,0,95,255,
		112,0,106,7,110,111,109,98,114,101,0,112,1,6,
		100,100,100,100,100,9,89,23,0,0,0,1,0,1,
		0,48,23,0,48,21,0,95,255,112,0,112,0,68,
		6,100,9,9,100,100,100,100,100,100,100,100,100,112,
		25,80,4,36,43,0,48,16,0,176,24,0,12,0,
		122,89,30,0,0,0,1,0,2,0,176,25,0,95,
		255,12,1,28,12,48,26,0,95,255,122,112,1,25,
		3,100,6,95,2,100,100,9,89,23,0,0,0,1,
		0,1,0,48,23,0,48,21,0,95,255,112,0,112,
		0,68,6,100,100,9,112,10,80,3,36,49,0,48,
		16,0,176,24,0,12,0,92,2,89,17,0,0,0,
		1,0,2,0,48,26,0,95,255,112,0,6,95,2,
		100,100,9,100,100,100,120,112,10,73,36,53,0,48,
		27,0,95,2,92,116,89,17,0,0,0,1,0,3,
		0,48,28,0,95,255,112,0,6,112,2,73,36,55,
		0,48,29,0,95,2,48,30,0,95,2,112,0,48,
		31,0,95,2,112,0,48,32,0,95,2,112,0,120,
		100,100,100,48,33,0,95,2,112,0,100,100,100,112,
		11,73,36,57,0,48,34,0,95,2,112,0,122,8,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,37,0,2,0,116,37,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

