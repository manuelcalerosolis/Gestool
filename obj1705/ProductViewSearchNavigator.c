/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\tablet\view\terceros\ProductViewSearchNavigator.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( PRODUCTVIEWSEARCHNAVIGATOR );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( VIEWSEARCHNAVIGATOR );
HB_FUNC_STATIC( PRODUCTVIEWSEARCHNAVIGATOR_SETCOLUMNS );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( D );
HB_FUNC_EXTERN( TRANSFORM );
HB_FUNC_EXTERN( CPOUDIV );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_PRODUCTVIEWSEARCHNAVIGATOR )
{ "PRODUCTVIEWSEARCHNAVIGATOR", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( PRODUCTVIEWSEARCHNAVIGATOR )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "VIEWSEARCHNAVIGATOR", {HB_FS_PUBLIC}, {HB_FUNCNAME( VIEWSEARCHNAVIGATOR )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_HASHITEMSSEARCH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PRODUCTVIEWSEARCHNAVIGATOR_SETCOLUMNS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( PRODUCTVIEWSEARCHNAVIGATOR_SETCOLUMNS )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETBROWSECONFIGURATIONNAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDCOLUMN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BEDITVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ARTICULOS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "D", {HB_FS_PUBLIC}, {HB_FUNCNAME( D )}, NULL },
{ "GETVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CODIGO", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "NOMBRE", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "_NWIDTH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TRANSFORM", {HB_FS_PUBLIC}, {HB_FUNCNAME( TRANSFORM )}, NULL },
{ "PVENTA1", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CPOUDIV", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPOUDIV )}, NULL },
{ "PVTAIVA1", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "_NDATASTRALIGN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NHEADSTRALIGN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PVENTA2", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "PVTAIVA2", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "_LHIDE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PVENTA3", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "PVTAIVA3", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "PVENTA4", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "PVTAIVA4", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "PVENTA5", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "PVTAIVA5", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "PVENTA6", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "PVTAIVA6", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_PRODUCTVIEWSEARCHNAVIGATOR, ".\\Prg\\tablet\\view\\terceros\\ProductViewSearchNavigator.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_PRODUCTVIEWSEARCHNAVIGATOR
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_PRODUCTVIEWSEARCHNAVIGATOR )
   #include "hbiniseg.h"
#endif

HB_FUNC( PRODUCTVIEWSEARCHNAVIGATOR )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,43,0,36,4,0,103,2,0,100,8,
		29,56,1,176,1,0,104,2,0,12,1,29,45,1,
		166,239,0,0,122,80,1,48,2,0,176,3,0,12,
		0,106,27,80,114,111,100,117,99,116,86,105,101,119,
		83,101,97,114,99,104,78,97,118,105,103,97,116,111,
		114,0,108,4,4,1,0,108,0,112,3,80,2,36,
		6,0,48,5,0,95,2,106,17,115,101,116,73,116,
		101,109,115,66,117,115,113,117,101,100,97,0,89,54,
		0,1,0,0,0,48,6,0,95,1,106,7,78,111,
		109,98,114,101,0,106,7,78,111,109,98,114,101,0,
		106,7,67,243,100,105,103,111,0,106,7,67,111,100,
		105,103,111,0,177,2,0,112,1,6,95,1,121,72,
		121,72,121,72,112,3,73,36,8,0,48,7,0,95,
		2,106,11,115,101,116,67,111,108,117,109,110,115,0,
		108,8,95,1,121,72,121,72,121,72,112,3,73,36,
		10,0,48,5,0,95,2,106,16,98,111,116,111,110,
		101,115,65,99,99,105,111,110,101,115,0,89,10,0,
		1,0,0,0,95,1,6,95,1,121,72,121,72,121,
		72,112,3,73,36,12,0,48,9,0,95,2,112,0,
		73,167,14,0,0,176,10,0,104,2,0,95,2,20,
		2,168,48,11,0,95,2,112,0,80,3,176,12,0,
		95,3,106,10,73,110,105,116,67,108,97,115,115,0,
		12,2,28,12,48,13,0,95,3,164,146,1,0,73,
		95,3,110,7,48,11,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( PRODUCTVIEWSEARCHNAVIGATOR_SETCOLUMNS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,16,0,102,80,1,36,18,0,48,14,
		0,95,1,106,14,103,114,105,100,95,97,114,116,105,
		99,117,108,111,0,112,1,73,36,20,0,48,15,0,
		95,1,112,0,143,36,21,0,144,16,0,106,9,65,
		114,116,237,99,117,108,111,0,112,1,73,36,22,0,
		144,17,0,89,61,0,0,0,1,0,1,0,48,18,
		0,176,19,0,12,0,48,20,0,95,255,112,0,112,
		1,88,21,0,106,2,13,0,72,106,2,10,0,72,
		48,18,0,176,19,0,12,0,48,20,0,95,255,112,
		0,112,1,88,22,0,72,6,112,1,73,36,23,0,
		144,23,0,93,164,1,112,1,73,145,36,26,0,48,
		15,0,95,1,112,0,143,36,27,0,144,16,0,106,
		27,80,114,101,99,105,111,32,49,32,47,32,80,114,
		101,99,105,111,32,49,32,73,46,86,46,65,46,0,
		112,1,73,36,28,0,144,17,0,89,81,0,0,0,
		1,0,1,0,176,24,0,48,18,0,176,19,0,12,
		0,48,20,0,95,255,112,0,112,1,88,25,0,176,
		26,0,12,0,12,2,106,2,13,0,72,106,2,10,
		0,72,176,24,0,48,18,0,176,19,0,12,0,48,
		20,0,95,255,112,0,112,1,88,27,0,176,26,0,
		12,0,12,2,72,6,112,1,73,36,29,0,144,23,
		0,93,164,1,112,1,73,36,30,0,144,28,0,122,
		112,1,73,36,31,0,144,29,0,122,112,1,73,145,
		36,34,0,48,15,0,95,1,112,0,143,36,35,0,
		144,16,0,106,27,80,114,101,99,105,111,32,50,32,
		47,32,80,114,101,99,105,111,32,50,32,73,46,86,
		46,65,46,0,112,1,73,36,36,0,144,17,0,89,
		81,0,0,0,1,0,1,0,176,24,0,48,18,0,
		176,19,0,12,0,48,20,0,95,255,112,0,112,1,
		88,30,0,176,26,0,12,0,12,2,106,2,13,0,
		72,106,2,10,0,72,176,24,0,48,18,0,176,19,
		0,12,0,48,20,0,95,255,112,0,112,1,88,31,
		0,176,26,0,12,0,12,2,72,6,112,1,73,36,
		37,0,144,23,0,93,164,1,112,1,73,36,38,0,
		144,28,0,122,112,1,73,36,39,0,144,29,0,122,
		112,1,73,36,40,0,144,32,0,120,112,1,73,145,
		36,43,0,48,15,0,95,1,112,0,143,36,44,0,
		144,16,0,106,29,80,114,101,99,105,111,32,51,32,
		32,47,32,80,114,101,99,105,111,32,51,32,32,73,
		46,86,46,65,46,0,112,1,73,36,45,0,144,17,
		0,89,81,0,0,0,1,0,1,0,176,24,0,48,
		18,0,176,19,0,12,0,48,20,0,95,255,112,0,
		112,1,88,33,0,176,26,0,12,0,12,2,106,2,
		13,0,72,106,2,10,0,72,176,24,0,48,18,0,
		176,19,0,12,0,48,20,0,95,255,112,0,112,1,
		88,34,0,176,26,0,12,0,12,2,72,6,112,1,
		73,36,46,0,144,23,0,93,164,1,112,1,73,36,
		47,0,144,28,0,122,112,1,73,36,48,0,144,29,
		0,122,112,1,73,36,49,0,144,32,0,120,112,1,
		73,145,36,52,0,48,15,0,95,1,112,0,143,36,
		53,0,144,16,0,106,29,80,114,101,99,105,111,32,
		52,32,32,47,32,80,114,101,99,105,111,32,52,32,
		32,73,46,86,46,65,46,0,112,1,73,36,54,0,
		144,17,0,89,81,0,0,0,1,0,1,0,176,24,
		0,48,18,0,176,19,0,12,0,48,20,0,95,255,
		112,0,112,1,88,35,0,176,26,0,12,0,12,2,
		106,2,13,0,72,106,2,10,0,72,176,24,0,48,
		18,0,176,19,0,12,0,48,20,0,95,255,112,0,
		112,1,88,36,0,176,26,0,12,0,12,2,72,6,
		112,1,73,36,55,0,144,23,0,93,164,1,112,1,
		73,36,56,0,144,28,0,122,112,1,73,36,57,0,
		144,29,0,122,112,1,73,36,58,0,144,32,0,120,
		112,1,73,145,36,61,0,48,15,0,95,1,112,0,
		143,36,62,0,144,16,0,106,29,80,114,101,99,105,
		111,32,53,32,32,47,32,80,114,101,99,105,111,32,
		53,32,32,73,46,86,46,65,46,0,112,1,73,36,
		63,0,144,17,0,89,81,0,0,0,1,0,1,0,
		176,24,0,48,18,0,176,19,0,12,0,48,20,0,
		95,255,112,0,112,1,88,37,0,176,26,0,12,0,
		12,2,106,2,13,0,72,106,2,10,0,72,176,24,
		0,48,18,0,176,19,0,12,0,48,20,0,95,255,
		112,0,112,1,88,38,0,176,26,0,12,0,12,2,
		72,6,112,1,73,36,64,0,144,23,0,93,164,1,
		112,1,73,36,65,0,144,28,0,122,112,1,73,36,
		66,0,144,29,0,122,112,1,73,36,67,0,144,32,
		0,120,112,1,73,145,36,70,0,48,15,0,95,1,
		112,0,143,36,71,0,144,16,0,106,29,80,114,101,
		99,105,111,32,54,32,32,47,32,80,114,101,99,105,
		111,32,54,32,32,73,46,86,46,65,46,0,112,1,
		73,36,72,0,144,17,0,89,81,0,0,0,1,0,
		1,0,176,24,0,48,18,0,176,19,0,12,0,48,
		20,0,95,255,112,0,112,1,88,39,0,176,26,0,
		12,0,12,2,106,2,13,0,72,106,2,10,0,72,
		176,24,0,48,18,0,176,19,0,12,0,48,20,0,
		95,255,112,0,112,1,88,40,0,176,26,0,12,0,
		12,2,72,6,112,1,73,36,73,0,144,23,0,93,
		164,1,112,1,73,36,74,0,144,28,0,122,112,1,
		73,36,75,0,144,29,0,122,112,1,73,36,76,0,
		144,32,0,120,112,1,73,145,36,79,0,95,1,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,43,0,2,0,116,43,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

