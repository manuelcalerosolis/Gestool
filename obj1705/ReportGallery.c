/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\ReportGallery.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( REPORTGALLERY );
HB_FUNC_EXTERN( TDIALOG );
HB_FUNC_EXTERN( SPACE );
HB_FUNC_EXTERN( TIMAGELIST );
HB_FUNC_EXTERN( TLISTVIEW );
HB_FUNC_EXTERN( MSGINFO );
HB_FUNC_EXTERN( TTREEVIEW );
HB_FUNC_STATIC( EXECUTEREPORTGALERY );
HB_FUNC_EXTERN( TBUTTON );
HB_FUNC_EXTERN( CHMHELP );
HB_FUNC_STATIC( ONINITREPORTGALERY );
HB_FUNC_STATIC( CREATEPRODUCCIONREPORTGALERY );
HB_FUNC_STATIC( SELECTREPORTGALERY );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( PINFMATERIALES );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_REPORTGALLERY )
{ "REPORTGALLERY", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( REPORTGALLERY )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDIALOG", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDIALOG )}, NULL },
{ "SPACE", {HB_FS_PUBLIC}, {HB_FUNCNAME( SPACE )}, NULL },
{ "TIMAGELIST", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIMAGELIST )}, NULL },
{ "ADDICON", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TLISTVIEW", {HB_FS_PUBLIC}, {HB_FUNCNAME( TLISTVIEW )}, NULL },
{ "MSGINFO", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGINFO )}, NULL },
{ "TTREEVIEW", {HB_FS_PUBLIC}, {HB_FUNCNAME( TTREEVIEW )}, NULL },
{ "_BLDBLCLICK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EXECUTEREPORTGALERY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( EXECUTEREPORTGALERY )}, NULL },
{ "TBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBUTTON )}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHMHELP", {HB_FS_PUBLIC}, {HB_FUNCNAME( CHMHELP )}, NULL },
{ "ADDFASTKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BLCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BMOVED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BPAINTED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ONINITREPORTGALERY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ONINITREPORTGALERY )}, NULL },
{ "BRCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETIMAGELIST", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INSERTITEM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NOPTION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEPRODUCCIONREPORTGALERY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CREATEPRODUCCIONREPORTGALERY )}, NULL },
{ "SELECTREPORTGALERY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SELECTREPORTGALERY )}, NULL },
{ "DELETEALL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETITEM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "BACTION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PLAY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PINFMATERIALES", {HB_FS_PUBLIC}, {HB_FUNCNAME( PINFMATERIALES )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00001)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_REPORTGALLERY, ".\\.\\Prg\\ReportGallery.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_REPORTGALLERY
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_REPORTGALLERY )
   #include "hbiniseg.h"
#endif

HB_FUNC( REPORTGALLERY )
{
	static const HB_BYTE pcode[] =
	{
		13,5,0,36,16,0,48,1,0,176,2,0,12,0,
		100,100,100,100,106,8,71,101,115,116,111,111,108,0,
		176,3,0,122,12,1,72,106,5,50,48,49,55,0,
		72,106,26,32,45,32,71,97,108,101,114,105,97,32,
		100,101,32,105,110,102,111,114,109,101,115,32,58,32,
		0,72,106,13,82,101,112,111,114,116,71,97,108,101,
		114,121,0,100,9,100,100,100,100,100,9,100,100,100,
		100,100,9,100,106,5,111,68,108,103,0,100,100,112,
		24,80,1,36,18,0,48,1,0,176,4,0,12,0,
		92,32,92,32,112,2,80,3,36,20,0,48,5,0,
		95,3,106,13,103,99,95,109,111,110,101,121,50,95,
		51,50,0,112,1,73,36,21,0,48,5,0,95,3,
		106,18,103,99,95,115,109,97,108,108,95,116,114,117,
		99,107,95,51,50,0,112,1,73,36,22,0,48,5,
		0,95,3,106,14,103,99,95,112,97,99,107,97,103,
		101,95,51,50,0,112,1,73,36,23,0,48,5,0,
		95,3,106,14,103,99,95,119,111,114,107,101,114,50,
		95,51,50,0,112,1,73,36,25,0,48,6,0,176,
		7,0,12,0,92,100,95,1,90,8,176,8,0,12,
		0,6,112,3,80,2,36,27,0,48,1,0,176,4,
		0,12,0,112,0,80,4,36,29,0,48,6,0,176,
		9,0,12,0,92,110,95,1,112,2,80,5,36,30,
		0,48,10,0,95,5,89,17,0,0,0,1,0,5,
		0,176,11,0,95,255,12,1,6,112,1,73,36,35,
		0,48,6,0,176,12,0,12,0,122,89,17,0,0,
		0,1,0,5,0,176,11,0,95,255,12,1,6,95,
		1,100,100,9,100,100,100,9,112,10,73,36,40,0,
		48,6,0,176,12,0,12,0,92,2,89,17,0,0,
		0,1,0,1,0,48,13,0,95,255,112,0,6,95,
		1,100,100,9,100,100,100,9,112,10,73,36,45,0,
		48,6,0,176,12,0,12,0,93,230,3,90,28,176,
		14,0,106,18,71,97,108,101,114,105,97,100,101,73,
		110,102,111,114,109,101,115,0,12,1,6,95,1,100,
		100,9,100,100,100,9,112,10,73,36,47,0,48,15,
		0,95,1,92,112,90,28,176,14,0,106,18,71,97,
		108,101,114,105,97,100,101,73,110,102,111,114,109,101,
		115,0,12,1,6,112,2,73,36,48,0,48,15,0,
		95,1,92,116,89,17,0,0,0,1,0,5,0,176,
		11,0,95,255,12,1,6,112,2,73,36,51,0,48,
		16,0,95,1,48,17,0,95,1,112,0,48,18,0,
		95,1,112,0,48,19,0,95,1,112,0,120,100,100,
		89,29,0,1,0,4,0,2,0,3,0,4,0,5,
		0,176,20,0,95,255,95,254,95,253,95,252,12,4,
		6,48,21,0,95,1,112,0,100,100,100,112,11,73,
		36,53,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ONINITREPORTGALERY )
{
	static const HB_BYTE pcode[] =
	{
		13,0,4,36,59,0,48,22,0,95,1,95,2,112,
		1,73,36,61,0,48,23,0,95,1,121,106,7,86,
		101,110,116,97,115,0,112,2,73,36,62,0,48,23,
		0,95,1,122,106,8,67,111,109,112,114,97,115,0,
		112,2,73,36,63,0,48,23,0,95,1,92,2,106,
		12,69,120,105,115,116,101,110,99,105,97,115,0,112,
		2,73,36,64,0,48,23,0,95,1,92,3,106,11,
		80,114,111,100,117,99,99,105,243,110,0,112,2,73,
		36,66,0,48,24,0,95,1,122,112,1,73,36,68,
		0,176,25,0,95,4,20,1,36,70,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SELECTREPORTGALERY )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,76,0,48,27,0,95,2,112,0,73,
		36,79,0,95,1,122,8,28,14,36,80,0,176,25,
		0,95,2,20,1,25,66,36,82,0,95,1,92,2,
		8,28,14,36,83,0,176,25,0,95,2,20,1,25,
		44,36,85,0,95,1,92,3,8,28,14,36,86,0,
		176,25,0,95,2,20,1,25,22,36,88,0,95,1,
		92,4,8,28,12,36,89,0,176,25,0,95,2,20,
		1,36,93,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( EXECUTEREPORTGALERY )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,99,0,48,28,0,95,1,112,0,80,
		2,36,101,0,176,29,0,95,2,12,1,31,32,176,
		29,0,48,30,0,95,2,112,0,12,1,31,18,36,
		102,0,48,31,0,48,30,0,95,2,112,0,112,0,
		73,36,105,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CREATEPRODUCCIONREPORTGALERY )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,114,0,48,32,0,95,1,106,8,68,
		105,97,114,105,111,115,0,112,1,80,2,36,116,0,
		48,32,0,95,2,106,11,80,114,111,100,117,99,99,
		105,243,110,0,112,1,80,3,36,118,0,48,32,0,
		95,3,106,21,68,105,97,114,105,111,32,100,101,32,
		112,114,111,100,117,99,99,105,243,110,0,121,90,53,
		48,33,0,48,1,0,176,34,0,12,0,106,33,73,
		110,102,111,114,109,101,32,100,101,32,109,97,116,101,
		114,105,97,108,101,115,32,112,114,111,100,117,99,105,
		100,111,115,0,112,1,112,0,6,112,3,73,36,120,
		0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,37,0,1,0,116,37,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

