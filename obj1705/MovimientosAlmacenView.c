/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\Views\MovimientosAlmacenView.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( MOVIMIENTOSALMACENVIEW );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( SQLBASEVIEW );
HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_NEW );
HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_DIALOG );
HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_INITDIALOG );
HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_STARTDIALOG );
HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_STAMPALMACENNOMBRE );
HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_STAMPGRUPOMOVIMIENTONOMBRE );
HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_CHANGETIPOMOVIMIENTO );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( TDIALOG );
HB_FUNC_EXTERN( TBITMAP );
HB_FUNC_EXTERN( TGETHLP );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( TRADMENU );
HB_FUNC_EXTERN( BRWALMACEN );
HB_FUNC_EXTERN( BROWSEGRUPOSMOVIMIENTOS );
HB_FUNC_EXTERN( TBUTTON );
HB_FUNC_EXTERN( MSGALERT );
HB_FUNC_EXTERN( SQLBROWSEVIEW );
HB_FUNC_EXTERN( ALMACENESMODEL );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( GRUPOSMOVIMIENTOSMODEL );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_MOVIMIENTOSALMACENVIEW )
{ "MOVIMIENTOSALMACENVIEW", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( MOVIMIENTOSALMACENVIEW )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "SQLBASEVIEW", {HB_FS_PUBLIC}, {HB_FUNCNAME( SQLBASEVIEW )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MOVIMIENTOSALMACENVIEW_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( MOVIMIENTOSALMACENVIEW_NEW )}, NULL },
{ "MOVIMIENTOSALMACENVIEW_DIALOG", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( MOVIMIENTOSALMACENVIEW_DIALOG )}, NULL },
{ "MOVIMIENTOSALMACENVIEW_INITDIALOG", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( MOVIMIENTOSALMACENVIEW_INITDIALOG )}, NULL },
{ "MOVIMIENTOSALMACENVIEW_STARTDIALOG", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( MOVIMIENTOSALMACENVIEW_STARTDIALOG )}, NULL },
{ "MOVIMIENTOSALMACENVIEW_STAMPALMACENNOMBRE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( MOVIMIENTOSALMACENVIEW_STAMPALMACENNOMBRE )}, NULL },
{ "MOVIMIENTOSALMACENVIEW_STAMPGRUPOMOVIMIENTONOMBRE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( MOVIMIENTOSALMACENVIEW_STAMPGRUPOMOVIMIENTONOMBRE )}, NULL },
{ "MOVIMIENTOSALMACENVIEW_CHANGETIPOMOVIMIENTO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( MOVIMIENTOSALMACENVIEW_CHANGETIPOMOVIMIENTO )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OCONTROLLER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CIMAGENAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDIALOG", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDIALOG )}, NULL },
{ "LBLTITLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBITMAP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBITMAP )}, NULL },
{ "TGETHLP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGETHLP )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "HBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OMODEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OCONTROLLER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ISNOTZOOMMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TRADMENU", {HB_FS_PUBLIC}, {HB_FUNCNAME( TRADMENU )}, NULL },
{ "CHANGETIPOMOVIMIENTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BVALID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VALIDATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "STAMPALMACENNOMBRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BHELP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BRWALMACEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( BRWALMACEN )}, NULL },
{ "OHELPTEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "STAMPGRUPOMOVIMIENTONOMBRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BROWSEGRUPOSMOVIMIENTOS", {HB_FS_PUBLIC}, {HB_FUNCNAME( BROWSEGRUPOSMOVIMIENTOS )}, NULL },
{ "TBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBUTTON )}, NULL },
{ "APPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OLINEASCONTROLLER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGALERT", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGALERT )}, NULL },
{ "_OSQLBROWSEVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBROWSEVIEW", {HB_FS_PUBLIC}, {HB_FUNCNAME( SQLBROWSEVIEW )}, NULL },
{ "SETCONTROLLER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OSQLBROWSEVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATEDIALOG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BSTART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "STARTDIALOG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INITDIALOG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NRESULT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BUILDROWSET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VARGET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETNOMBRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ALMACENESMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALMACENESMODEL )}, NULL },
{ "CTEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "GRUPOSMOVIMIENTOSMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( GRUPOSMOVIMIENTOSMODEL )}, NULL },
{ "NOPTION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SHOW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HIDE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_MOVIMIENTOSALMACENVIEW, ".\\Prg\\Views\\MovimientosAlmacenView.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_MOVIMIENTOSALMACENVIEW
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_MOVIMIENTOSALMACENVIEW )
   #include "hbiniseg.h"
#endif

HB_FUNC( MOVIMIENTOSALMACENVIEW )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,68,0,36,7,0,103,2,0,100,8,
		29,183,1,176,1,0,104,2,0,12,1,29,172,1,
		166,110,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,23,77,111,118,105,109,105,101,110,116,111,115,
		65,108,109,97,99,101,110,86,105,101,119,0,108,4,
		4,1,0,108,0,112,3,80,2,36,9,0,48,5,
		0,95,2,100,100,95,1,121,72,121,72,121,72,106,
		15,111,83,81,76,66,114,111,119,115,101,86,105,101,
		119,0,4,1,0,9,112,5,73,36,11,0,48,6,
		0,95,2,106,4,78,101,119,0,108,7,95,1,121,
		72,121,72,121,72,112,3,73,36,13,0,48,6,0,
		95,2,106,7,68,105,97,108,111,103,0,108,8,95,
		1,121,72,121,72,121,72,112,3,73,36,14,0,48,
		6,0,95,2,106,11,105,110,105,116,68,105,97,108,
		111,103,0,108,9,95,1,121,72,121,72,121,72,112,
		3,73,36,15,0,48,6,0,95,2,106,12,115,116,
		97,114,116,68,105,97,108,111,103,0,108,10,95,1,
		121,72,121,72,121,72,112,3,73,36,17,0,48,6,
		0,95,2,106,19,115,116,97,109,112,65,108,109,97,
		99,101,110,78,111,109,98,114,101,0,108,11,95,1,
		121,72,121,72,121,72,112,3,73,36,19,0,48,6,
		0,95,2,106,27,115,116,97,109,112,71,114,117,112,
		111,77,111,118,105,109,105,101,110,116,111,78,111,109,
		98,114,101,0,108,12,95,1,121,72,121,72,121,72,
		112,3,73,36,21,0,48,6,0,95,2,106,21,99,
		104,97,110,103,101,84,105,112,111,77,111,118,105,109,
		105,101,110,116,111,0,108,13,95,1,121,72,121,72,
		121,72,112,3,73,36,23,0,48,14,0,95,2,112,
		0,73,167,14,0,0,176,15,0,104,2,0,95,2,
		20,2,168,48,16,0,95,2,112,0,80,3,176,17,
		0,95,3,106,10,73,110,105,116,67,108,97,115,115,
		0,12,2,28,12,48,18,0,95,3,164,146,1,0,
		73,95,3,110,7,48,16,0,103,2,0,112,0,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,29,0,48,19,0,102,95,1,112,1,
		73,36,31,0,48,20,0,102,106,16,103,99,95,98,
		111,111,107,109,97,114,107,115,95,49,54,0,112,1,
		73,36,33,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_DIALOG )
{
	static const HB_BYTE pcode[] =
	{
		13,7,0,36,37,0,102,80,1,36,46,0,48,2,
		0,176,21,0,12,0,100,100,100,100,48,22,0,95,
		1,112,0,106,23,109,111,118,105,109,105,101,110,116,
		111,115,32,100,101,32,97,108,109,97,99,233,110,0,
		72,106,7,82,101,109,77,111,118,0,100,9,100,100,
		100,100,100,9,100,100,100,100,100,9,100,106,5,111,
		68,108,103,0,100,100,112,24,80,2,36,52,0,48,
		23,0,176,24,0,12,0,93,222,3,106,21,103,99,
		95,112,97,99,107,97,103,101,95,112,101,110,99,105,
		108,95,52,56,0,100,95,2,100,100,9,9,100,100,
		9,100,100,120,112,14,80,3,36,57,0,48,23,0,
		176,25,0,12,0,92,100,89,78,0,1,0,1,0,
		1,0,176,26,0,12,0,121,8,28,31,48,27,0,
		48,28,0,48,29,0,95,255,112,0,112,0,112,0,
		106,7,110,117,109,101,114,111,0,1,25,32,95,1,
		165,48,27,0,48,28,0,48,29,0,95,255,112,0,
		112,0,112,0,106,7,110,117,109,101,114,111,0,2,
		6,95,2,100,100,100,100,100,100,100,100,9,90,4,
		9,6,100,9,9,100,100,100,100,100,100,100,100,100,
		112,25,73,36,62,0,48,23,0,176,25,0,12,0,
		92,110,89,86,0,1,0,1,0,1,0,176,26,0,
		12,0,121,8,28,35,48,27,0,48,28,0,48,29,
		0,95,255,112,0,112,0,112,0,106,11,100,101,108,
		101,103,97,99,105,111,110,0,1,25,36,95,1,165,
		48,27,0,48,28,0,48,29,0,95,255,112,0,112,
		0,112,0,106,11,100,101,108,101,103,97,99,105,111,
		110,0,2,6,95,2,100,100,100,100,100,100,100,100,
		9,90,4,9,6,100,9,9,100,100,100,100,100,100,
		100,100,100,112,25,73,36,68,0,48,23,0,176,25,
		0,12,0,92,120,89,86,0,1,0,1,0,1,0,
		176,26,0,12,0,121,8,28,35,48,27,0,48,28,
		0,48,29,0,95,255,112,0,112,0,112,0,106,11,
		102,101,99,104,97,95,104,111,114,97,0,1,25,36,
		95,1,165,48,27,0,48,28,0,48,29,0,95,255,
		112,0,112,0,112,0,106,11,102,101,99,104,97,95,
		104,111,114,97,0,2,6,95,2,100,106,4,64,68,
		84,0,100,100,100,100,100,100,9,89,22,0,0,0,
		1,0,1,0,48,30,0,48,29,0,95,255,112,0,
		112,0,6,100,9,9,100,100,100,100,100,100,100,100,
		100,112,25,73,36,74,0,48,23,0,176,25,0,12,
		0,93,220,0,89,80,0,1,0,1,0,1,0,176,
		26,0,12,0,121,8,28,32,48,27,0,48,28,0,
		48,29,0,95,255,112,0,112,0,112,0,106,8,117,
		115,117,97,114,105,111,0,1,25,33,95,1,165,48,
		27,0,48,28,0,48,29,0,95,255,112,0,112,0,
		112,0,106,8,117,115,117,97,114,105,111,0,2,6,
		95,2,100,106,4,88,88,88,0,100,100,100,100,100,
		100,9,90,4,9,6,100,9,9,100,100,100,100,100,
		100,100,100,100,112,25,73,36,81,0,48,23,0,176,
		31,0,12,0,89,96,0,1,0,1,0,1,0,176,
		26,0,12,0,121,8,28,40,48,27,0,48,28,0,
		48,29,0,95,255,112,0,112,0,112,0,106,16,116,
		105,112,111,95,109,111,118,105,109,105,101,110,116,111,
		0,1,25,41,95,1,165,48,27,0,48,28,0,48,
		29,0,95,255,112,0,112,0,112,0,106,16,116,105,
		112,111,95,109,111,118,105,109,105,101,110,116,111,0,
		2,6,95,2,100,93,130,0,93,131,0,93,132,0,
		93,133,0,4,4,0,89,25,0,0,0,3,0,1,
		0,7,0,4,0,48,32,0,95,255,95,254,95,253,
		112,2,6,100,100,100,9,89,22,0,0,0,1,0,
		1,0,48,30,0,48,29,0,95,255,112,0,112,0,
		6,100,112,11,80,7,36,91,0,48,23,0,176,25,
		0,12,0,93,150,0,89,94,0,1,0,1,0,1,
		0,176,26,0,12,0,121,8,28,39,48,27,0,48,
		28,0,48,29,0,95,255,112,0,112,0,112,0,106,
		15,97,108,109,97,99,101,110,95,111,114,105,103,101,
		110,0,1,25,40,95,1,165,48,27,0,48,28,0,
		48,29,0,95,255,112,0,112,0,112,0,106,15,97,
		108,109,97,99,101,110,95,111,114,105,103,101,110,0,
		2,6,95,2,100,106,3,64,33,0,100,100,100,100,
		100,100,9,89,22,0,0,0,1,0,1,0,48,30,
		0,48,29,0,95,255,112,0,112,0,6,100,9,9,
		100,100,100,100,100,100,106,5,76,117,112,97,0,93,
		152,0,93,151,0,112,25,80,4,36,93,0,48,33,
		0,95,4,89,55,0,0,0,2,0,1,0,4,0,
		48,34,0,48,29,0,95,255,112,0,106,15,97,108,
		109,97,99,101,110,95,111,114,105,103,101,110,0,112,
		1,28,13,48,35,0,95,255,95,254,112,1,25,3,
		9,6,112,1,73,36,94,0,48,36,0,95,4,89,
		24,0,0,0,1,0,4,0,176,37,0,95,255,48,
		38,0,95,255,112,0,12,2,6,112,1,73,36,104,
		0,48,23,0,176,25,0,12,0,93,160,0,89,96,
		0,1,0,1,0,1,0,176,26,0,12,0,121,8,
		28,40,48,27,0,48,28,0,48,29,0,95,255,112,
		0,112,0,112,0,106,16,97,108,109,97,99,101,110,
		95,100,101,115,116,105,110,111,0,1,25,41,95,1,
		165,48,27,0,48,28,0,48,29,0,95,255,112,0,
		112,0,112,0,106,16,97,108,109,97,99,101,110,95,
		100,101,115,116,105,110,111,0,2,6,95,2,100,106,
		3,64,33,0,100,100,100,100,100,100,9,89,22,0,
		0,0,1,0,1,0,48,30,0,48,29,0,95,255,
		112,0,112,0,6,100,9,9,100,100,100,100,100,100,
		106,5,76,117,112,97,0,93,162,0,93,161,0,112,
		25,80,5,36,106,0,48,33,0,95,5,89,56,0,
		0,0,2,0,1,0,5,0,48,34,0,48,29,0,
		95,255,112,0,106,16,97,108,109,97,99,101,110,95,
		100,101,115,116,105,110,111,0,112,1,28,13,48,35,
		0,95,255,95,254,112,1,25,3,9,6,112,1,73,
		36,107,0,48,36,0,95,5,89,24,0,0,0,1,
		0,5,0,176,37,0,95,255,48,38,0,95,255,112,
		0,12,2,6,112,1,73,36,116,0,48,23,0,176,
		25,0,12,0,93,140,0,89,98,0,1,0,1,0,
		1,0,176,26,0,12,0,121,8,28,41,48,27,0,
		48,28,0,48,29,0,95,255,112,0,112,0,112,0,
		106,17,103,114,117,112,111,95,109,111,118,105,109,105,
		101,110,116,111,0,1,25,42,95,1,165,48,27,0,
		48,28,0,48,29,0,95,255,112,0,112,0,112,0,
		106,17,103,114,117,112,111,95,109,111,118,105,109,105,
		101,110,116,111,0,2,6,95,2,100,106,3,64,33,
		0,100,100,100,100,100,100,9,89,22,0,0,0,1,
		0,1,0,48,30,0,48,29,0,95,255,112,0,112,
		0,6,100,9,9,100,100,100,100,100,100,106,5,76,
		117,112,97,0,100,93,141,0,112,25,80,6,36,118,
		0,48,33,0,95,6,89,21,0,0,0,2,0,1,
		0,6,0,48,39,0,95,255,95,254,112,1,6,112,
		1,73,36,119,0,48,36,0,95,6,89,24,0,0,
		0,1,0,6,0,176,40,0,95,255,48,38,0,95,
		255,112,0,12,2,6,112,1,73,36,127,0,48,23,
		0,176,41,0,12,0,93,244,1,89,27,0,0,0,
		1,0,1,0,48,42,0,48,43,0,48,29,0,95,
		255,112,0,112,0,112,0,6,95,2,100,100,9,89,
		22,0,0,0,1,0,1,0,48,30,0,48,29,0,
		95,255,112,0,112,0,6,100,100,9,112,10,73,36,
		131,0,176,44,0,48,27,0,48,28,0,48,29,0,
		95,1,112,0,112,0,112,0,106,5,117,117,105,100,
		0,1,106,5,117,117,105,100,0,20,2,36,133,0,
		48,45,0,95,1,48,2,0,176,46,0,12,0,95,
		1,112,1,112,1,73,36,135,0,48,47,0,48,48,
		0,95,1,112,0,48,43,0,48,29,0,95,1,112,
		0,112,0,112,1,73,36,137,0,48,49,0,48,48,
		0,95,1,112,0,93,180,0,95,2,112,2,73,36,
		145,0,48,23,0,176,41,0,12,0,122,89,18,0,
		0,0,1,0,2,0,48,50,0,95,255,122,112,1,
		6,95,2,100,100,9,89,22,0,0,0,1,0,1,
		0,48,30,0,48,29,0,95,255,112,0,112,0,6,
		100,100,9,112,10,73,36,151,0,48,23,0,176,41,
		0,12,0,92,2,89,17,0,0,0,1,0,2,0,
		48,50,0,95,255,112,0,6,95,2,100,100,9,100,
		100,100,120,112,10,73,36,156,0,48,23,0,176,41,
		0,12,0,92,3,90,26,176,44,0,106,16,82,101,
		99,97,108,99,117,108,97,80,114,101,99,105,111,0,
		12,1,6,95,2,100,100,9,100,100,100,9,112,10,
		73,36,158,0,48,51,0,95,2,89,25,0,0,0,
		3,0,1,0,7,0,4,0,48,52,0,95,255,95,
		254,95,253,112,2,6,112,1,73,36,160,0,48,53,
		0,95,2,100,100,100,120,100,100,89,17,0,0,0,
		1,0,1,0,48,54,0,95,255,112,0,6,112,7,
		73,36,162,0,48,50,0,95,3,112,0,73,36,164,
		0,48,55,0,95,2,112,0,122,8,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_INITDIALOG )
{
	static const HB_BYTE pcode[] =
	{
		36,170,0,48,56,0,48,28,0,48,43,0,48,29,
		0,102,112,0,112,0,112,0,112,0,73,36,172,0,
		102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_STARTDIALOG )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,178,0,48,32,0,102,95,1,95,2,
		112,2,73,36,180,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_STAMPALMACENNOMBRE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,186,0,48,57,0,95,1,112,0,80,
		2,36,187,0,48,58,0,176,59,0,12,0,95,2,
		112,1,80,3,36,189,0,48,60,0,48,38,0,95,
		1,112,0,95,3,112,1,73,36,191,0,176,61,0,
		95,3,12,1,68,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_STAMPGRUPOMOVIMIENTONOMBRE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,197,0,48,57,0,95,1,112,0,80,
		2,36,198,0,48,58,0,176,62,0,12,0,95,2,
		112,1,80,3,36,200,0,48,60,0,48,38,0,95,
		1,112,0,95,3,112,1,73,36,202,0,176,61,0,
		95,3,12,1,68,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( MOVIMIENTOSALMACENVIEW_CHANGETIPOMOVIMIENTO )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,208,0,48,63,0,95,1,112,0,122,
		8,28,15,36,209,0,48,64,0,95,2,112,0,73,
		25,13,36,211,0,48,65,0,95,2,112,0,73,36,
		214,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,68,0,2,0,116,68,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

