/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\Controllers\TiposNotasController.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TIPOSNOTASCONTROLLER );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( SQLBASECONTROLLER );
HB_FUNC_STATIC( TIPOSNOTASCONTROLLER_NEW );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( NLEVELUSR );
HB_FUNC_EXTERN( TIPOSNOTASMODEL );
HB_FUNC_EXTERN( TIPOSNOTASREPOSITORY );
HB_FUNC_EXTERN( TIPOSNOTASVIEW );
HB_FUNC_EXTERN( TIPOSNOTASVALIDATOR );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TIPOSNOTASCONTROLLER )
{ "TIPOSNOTASCONTROLLER", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TIPOSNOTASCONTROLLER )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "SQLBASECONTROLLER", {HB_FS_PUBLIC}, {HB_FUNCNAME( SQLBASECONTROLLER )}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TIPOSNOTASCONTROLLER_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TIPOSNOTASCONTROLLER_NEW )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CTITLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CIMAGE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NLEVEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NLEVELUSR", {HB_FS_PUBLIC}, {HB_FUNCNAME( NLEVELUSR )}, NULL },
{ "_OMODEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TIPOSNOTASMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIPOSNOTASMODEL )}, NULL },
{ "_OREPOSITORY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TIPOSNOTASREPOSITORY", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIPOSNOTASREPOSITORY )}, NULL },
{ "_ODIALOGVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TIPOSNOTASVIEW", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIPOSNOTASVIEW )}, NULL },
{ "_OVALIDATOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TIPOSNOTASVALIDATOR", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIPOSNOTASVALIDATOR )}, NULL },
{ "SUPER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TIPOSNOTASCONTROLLER, ".\\Prg\\Controllers\\TiposNotasController.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TIPOSNOTASCONTROLLER
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TIPOSNOTASCONTROLLER )
   #include "hbiniseg.h"
#endif

HB_FUNC( TIPOSNOTASCONTROLLER )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,27,0,36,6,0,103,2,0,100,8,
		29,160,0,176,1,0,104,2,0,12,1,29,149,0,
		166,87,0,0,122,80,1,48,2,0,176,3,0,12,
		0,106,21,84,105,112,111,115,78,111,116,97,115,67,
		111,110,116,114,111,108,108,101,114,0,108,4,4,1,
		0,108,0,112,3,80,2,36,8,0,48,5,0,95,
		2,106,4,78,101,119,0,108,6,95,1,121,72,121,
		72,121,72,112,3,73,36,10,0,48,7,0,95,2,
		112,0,73,167,14,0,0,176,8,0,104,2,0,95,
		2,20,2,168,48,9,0,95,2,112,0,80,3,176,
		10,0,95,3,106,10,73,110,105,116,67,108,97,115,
		115,0,12,2,28,12,48,11,0,95,3,164,146,1,
		0,73,95,3,110,7,48,9,0,103,2,0,112,0,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TIPOSNOTASCONTROLLER_NEW )
{
	static const HB_BYTE pcode[] =
	{
		36,16,0,48,12,0,102,106,15,84,105,112,111,115,
		32,100,101,32,110,111,116,97,115,0,112,1,73,36,
		18,0,48,13,0,102,106,14,103,99,95,102,111,108,
		100,101,114,50,95,49,54,0,112,1,73,36,20,0,
		48,14,0,102,176,15,0,106,6,48,49,49,48,49,
		0,12,1,112,1,73,36,22,0,48,16,0,102,48,
		2,0,176,17,0,12,0,102,112,1,112,1,73,36,
		24,0,48,18,0,102,48,2,0,176,19,0,12,0,
		102,112,1,112,1,73,36,26,0,48,20,0,102,48,
		2,0,176,21,0,12,0,102,112,1,112,1,73,36,
		28,0,48,22,0,102,48,2,0,176,23,0,12,0,
		102,112,1,112,1,73,36,30,0,48,2,0,48,24,
		0,102,112,0,112,0,73,36,32,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,27,0,2,0,116,27,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

