/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\tablet\view\documentos\ventas\ReceiptDocumentSalesViewSearchNavigator.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( VIEWSEARCHNAVIGATOR );
HB_FUNC_STATIC( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_SETCOLUMNS );
HB_FUNC_EXTERN( D );
HB_FUNC_STATIC( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_BOTONESACCIONES );
HB_FUNC_STATIC( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_CHANGEFILTER );
HB_FUNC_STATIC( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_DEFINESALIR );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( GETSYSCOLOR );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( STR );
HB_FUNC_EXTERN( DTOC );
HB_FUNC_EXTERN( CPORDIV );
HB_FUNC_EXTERN( TGRIDIMAGE );
HB_FUNC_EXTERN( GRIDWIDTH );
HB_FUNC_EXTERN( TGRIDCOMBOBOX );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR )
{ "RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "VIEWSEARCHNAVIGATOR", {HB_FS_PUBLIC}, {HB_FUNCNAME( VIEWSEARCHNAVIGATOR )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETDATATABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_HASHITEMSSEARCH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_SETCOLUMNS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_SETCOLUMNS )}, NULL },
{ "GETFIELDDICTIONARY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "D", {HB_FS_PUBLIC}, {HB_FUNCNAME( D )}, NULL },
{ "GETVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_BOTONESACCIONES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_BOTONESACCIONES )}, NULL },
{ "RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_CHANGEFILTER", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_CHANGEFILTER )}, NULL },
{ "RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_DEFINESALIR", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_DEFINESALIR )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETBROWSECONFIGURATIONNAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BCLRSEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETFIELD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BCLRSELFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BCLRSTD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETSYSCOLOR", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETSYSCOLOR )}, NULL },
{ "ADDCOLUMN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BEDITVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "STR", {HB_FS_PUBLIC}, {HB_FUNCNAME( STR )}, NULL },
{ "_NWIDTH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DTOC", {HB_FS_PUBLIC}, {HB_FUNCNAME( DTOC )}, NULL },
{ "_CEDITPICTURE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPORDIV", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPORDIV )}, NULL },
{ "_NDATASTRALIGN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NHEADSTRALIGN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LALOWEDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BUILD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDIMAGE", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDIMAGE )}, NULL },
{ "GRIDWIDTH", {HB_FS_PUBLIC}, {HB_FUNCNAME( GRIDWIDTH )}, NULL },
{ "ODLG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LSHOWFILTERCOBRADO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_COMBOBOXFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDCOMBOBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDCOMBOBOX )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "CCOMBOBOXFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCOMBOBOXFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACOMBOBOXFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHANGEFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BSTART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FILTERTABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BUTTONPRINT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PRINTRECEIPT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BUTTONEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR, ".\\Prg\\tablet\\view\\documentos\\ventas\\ReceiptDocumentSalesViewSearchNavigator.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR )
   #include "hbiniseg.h"
#endif

HB_FUNC( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,64,0,36,4,0,103,2,0,100,8,
		29,127,3,176,1,0,104,2,0,12,1,29,116,3,
		166,54,3,0,122,80,1,48,2,0,176,3,0,12,
		0,106,40,82,101,99,101,105,112,116,68,111,99,117,
		109,101,110,116,83,97,108,101,115,86,105,101,119,83,
		101,97,114,99,104,78,97,118,105,103,97,116,111,114,
		0,108,4,4,1,0,108,0,112,3,80,2,36,6,
		0,48,5,0,95,2,100,100,95,1,121,72,121,72,
		121,72,106,12,98,117,116,116,111,110,80,114,105,110,
		116,0,4,1,0,9,112,5,73,36,8,0,48,5,
		0,95,2,100,100,95,1,121,72,121,72,121,72,106,
		15,99,111,109,98,111,98,111,120,70,105,108,116,101,
		114,0,4,1,0,9,112,5,73,36,9,0,48,5,
		0,95,2,100,106,22,80,101,110,100,105,101,110,116,
		101,115,32,100,101,108,101,103,97,99,105,243,110,0,
		95,1,121,72,121,72,121,72,106,16,99,67,111,109,
		98,111,98,111,120,70,105,108,116,101,114,0,4,1,
		0,9,112,5,73,36,10,0,48,5,0,95,2,100,
		106,17,84,111,100,111,115,32,100,101,108,101,103,97,
		99,105,243,110,0,106,22,80,101,110,100,105,101,110,
		116,101,115,32,100,101,108,101,103,97,99,105,243,110,
		0,106,20,67,111,98,114,97,100,111,115,32,100,101,
		108,101,103,97,99,105,243,110,0,106,6,84,111,100,
		111,115,0,106,11,80,101,110,100,105,101,110,116,101,
		115,0,106,9,67,111,98,114,97,100,111,115,0,4,
		6,0,95,1,121,72,121,72,121,72,106,16,97,67,
		111,109,98,111,98,111,120,70,105,108,116,101,114,0,
		4,1,0,9,112,5,73,36,12,0,48,6,0,95,
		2,106,13,103,101,116,68,97,116,97,84,97,98,108,
		101,0,89,20,0,1,0,0,0,48,7,0,48,8,
		0,95,1,112,0,112,0,6,95,1,121,72,121,72,
		121,72,112,3,73,36,14,0,48,6,0,95,2,106,
		8,103,101,116,86,105,101,119,0,89,20,0,1,0,
		0,0,48,9,0,48,8,0,95,1,112,0,112,0,
		6,95,1,121,72,121,72,121,72,112,3,73,36,16,
		0,48,6,0,95,2,106,17,115,101,116,73,116,101,
		109,115,66,117,115,113,117,101,100,97,0,89,105,0,
		1,0,0,0,48,10,0,95,1,106,6,70,101,99,
		104,97,0,106,8,100,70,101,99,68,101,115,0,106,
		7,78,250,109,101,114,111,0,122,106,7,67,243,100,
		105,103,111,0,106,8,99,67,111,100,67,108,105,0,
		106,7,78,111,109,98,114,101,0,106,8,99,78,111,
		109,67,108,105,0,106,8,73,109,112,111,114,116,101,
		0,106,9,110,73,109,112,111,114,116,101,0,177,5,
		0,112,1,6,95,1,121,72,121,72,121,72,112,3,
		73,36,18,0,48,11,0,95,2,106,11,115,101,116,
		67,111,108,117,109,110,115,0,108,12,95,1,121,72,
		121,72,121,72,112,3,73,36,20,0,48,6,0,95,
		2,106,9,103,101,116,70,105,101,108,100,0,89,34,
		0,2,0,0,0,48,13,0,176,14,0,12,0,95,
		2,48,7,0,95,1,112,0,48,15,0,95,1,112,
		0,112,3,6,95,1,121,72,121,72,121,72,112,3,
		73,36,22,0,48,11,0,95,2,106,16,66,111,116,
		111,110,101,115,65,99,99,105,111,110,101,115,0,108,
		16,95,1,121,72,121,72,121,72,112,3,73,36,24,
		0,48,11,0,95,2,106,13,67,104,97,110,103,101,
		70,105,108,116,101,114,0,108,17,95,1,121,72,121,
		72,121,72,112,3,73,36,26,0,48,11,0,95,2,
		106,12,100,101,102,105,110,101,83,97,108,105,114,0,
		108,18,95,1,121,72,121,72,121,72,112,3,73,36,
		28,0,48,19,0,95,2,112,0,73,167,14,0,0,
		176,20,0,104,2,0,95,2,20,2,168,48,21,0,
		95,2,112,0,80,3,176,22,0,95,3,106,10,73,
		110,105,116,67,108,97,115,115,0,12,2,28,12,48,
		23,0,95,3,164,146,1,0,73,95,3,110,7,48,
		21,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_SETCOLUMNS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,32,0,102,80,1,36,34,0,48,24,
		0,95,1,106,13,103,114,105,100,95,114,101,99,105,
		98,111,115,0,112,1,73,36,36,0,48,25,0,48,
		26,0,95,1,112,0,89,49,0,0,0,1,0,1,
		0,48,27,0,95,255,106,14,76,111,103,105,99,111,
		67,111,98,114,97,100,111,0,112,1,31,7,93,255,
		0,25,3,121,97,229,229,229,0,4,2,0,6,112,
		1,73,36,37,0,48,28,0,48,26,0,95,1,112,
		0,89,49,0,0,0,1,0,1,0,48,27,0,95,
		255,106,14,76,111,103,105,99,111,67,111,98,114,97,
		100,111,0,112,1,31,7,93,255,0,25,3,121,97,
		167,205,240,0,4,2,0,6,112,1,73,36,38,0,
		48,29,0,48,26,0,95,1,112,0,89,51,0,0,
		0,1,0,1,0,48,27,0,95,255,106,14,76,111,
		103,105,99,111,67,111,98,114,97,100,111,0,112,1,
		31,7,93,255,0,25,3,121,176,30,0,92,5,12,
		1,4,2,0,6,112,1,73,36,40,0,48,31,0,
		95,1,112,0,143,36,41,0,144,32,0,106,3,73,
		100,0,112,1,73,36,42,0,144,33,0,89,95,0,
		0,0,1,0,1,0,48,27,0,95,255,106,6,83,
		101,114,105,101,0,112,1,106,2,47,0,72,176,34,
		0,176,35,0,48,27,0,95,255,106,7,78,117,109,
		101,114,111,0,112,1,12,1,12,1,72,106,2,45,
		0,72,176,34,0,176,35,0,48,27,0,95,255,106,
		13,78,117,109,101,114,111,82,101,99,105,98,111,0,
		112,1,12,1,12,1,72,6,112,1,73,36,43,0,
		144,36,0,93,150,0,112,1,73,145,36,46,0,48,
		31,0,95,1,112,0,143,36,47,0,144,32,0,106,
		10,69,120,112,46,47,86,116,111,46,0,112,1,73,
		36,48,0,144,33,0,89,82,0,0,0,1,0,1,
		0,176,37,0,48,27,0,95,255,106,16,70,101,99,
		104,97,69,120,112,101,100,105,99,105,111,110,0,112,
		1,12,1,106,2,13,0,72,106,2,10,0,72,176,
		37,0,48,27,0,95,255,106,17,70,101,99,104,97,
		86,101,110,99,105,109,105,101,110,116,111,0,112,1,
		12,1,72,6,112,1,73,36,49,0,144,36,0,93,
		160,0,112,1,73,145,36,52,0,48,31,0,95,1,
		112,0,143,36,53,0,144,32,0,106,8,67,108,105,
		101,110,116,101,0,112,1,73,36,54,0,144,33,0,
		89,71,0,0,0,1,0,1,0,176,34,0,48,27,
		0,95,255,106,8,67,108,105,101,110,116,101,0,112,
		1,12,1,106,2,13,0,72,106,2,10,0,72,176,
		34,0,48,27,0,95,255,106,14,78,111,109,98,114,
		101,67,108,105,101,110,116,101,0,112,1,12,1,72,
		6,112,1,73,36,55,0,144,36,0,93,200,0,112,
		1,73,145,36,58,0,48,31,0,95,1,112,0,143,
		36,59,0,144,32,0,106,8,73,109,112,111,114,116,
		101,0,112,1,73,36,60,0,144,33,0,89,34,0,
		0,0,1,0,1,0,48,27,0,95,255,106,15,84,
		111,116,97,108,68,111,99,117,109,101,110,116,111,0,
		112,1,6,112,1,73,36,61,0,144,38,0,176,39,
		0,12,0,112,1,73,36,62,0,144,36,0,93,155,
		0,112,1,73,36,63,0,144,40,0,122,112,1,73,
		36,64,0,144,41,0,122,112,1,73,145,36,67,0,
		95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_BOTONESACCIONES )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,71,0,102,80,1,36,73,0,48,42,
		0,48,8,0,95,1,112,0,112,0,29,160,1,36,
		81,0,48,43,0,176,44,0,12,0,106,5,110,84,
		111,112,0,92,75,106,6,110,76,101,102,116,0,89,
		33,0,0,0,1,0,1,0,176,45,0,101,0,0,
		0,0,0,0,224,63,10,1,48,46,0,95,255,112,
		0,12,2,6,106,7,110,87,105,100,116,104,0,92,
		64,106,8,110,72,101,105,103,104,116,0,92,64,106,
		9,99,82,101,115,78,97,109,101,0,106,13,103,99,
		95,112,101,110,99,105,108,95,54,52,0,106,10,98,
		76,67,108,105,99,107,101,100,0,89,22,0,0,0,
		1,0,1,0,48,47,0,48,8,0,95,255,112,0,
		112,0,6,106,5,111,87,110,100,0,48,46,0,95,
		1,112,0,177,7,0,112,1,73,36,84,0,48,48,
		0,48,8,0,95,1,112,0,112,0,29,234,0,36,
		93,0,48,49,0,95,1,48,43,0,176,50,0,12,
		0,106,5,110,82,111,119,0,92,75,106,5,110,67,
		111,108,0,89,33,0,0,0,1,0,1,0,176,45,
		0,101,0,0,0,0,0,0,248,63,10,1,48,46,
		0,95,255,112,0,12,2,6,106,8,98,83,101,116,
		71,101,116,0,89,37,0,1,0,1,0,1,0,176,
		51,0,12,0,121,8,28,11,48,52,0,95,255,112,
		0,25,11,48,53,0,95,255,95,1,112,1,6,106,
		5,111,87,110,100,0,48,46,0,95,1,112,0,106,
		7,110,87,105,100,116,104,0,89,33,0,0,0,1,
		0,1,0,176,45,0,101,0,0,0,0,0,0,18,
		64,10,1,48,46,0,95,255,112,0,12,2,6,106,
		8,110,72,101,105,103,104,116,0,92,25,106,7,97,
		73,116,101,109,115,0,48,54,0,95,1,112,0,106,
		8,98,67,104,97,110,103,101,0,89,17,0,0,0,
		1,0,1,0,48,55,0,95,255,112,0,6,177,8,
		0,112,1,112,1,73,36,99,0,48,56,0,48,46,
		0,95,1,112,0,89,17,0,0,0,1,0,1,0,
		48,55,0,95,255,112,0,6,112,1,73,36,101,0,
		95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_CHANGEFILTER )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,107,0,106,1,0,80,1,36,109,0,
		48,48,0,48,8,0,102,112,0,112,0,28,23,36,
		111,0,48,57,0,48,8,0,102,112,0,48,52,0,
		102,112,0,112,1,73,36,116,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( RECEIPTDOCUMENTSALESVIEWSEARCHNAVIGATOR_DEFINESALIR )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,120,0,102,80,1,36,128,0,48,58,
		0,95,1,48,43,0,176,44,0,12,0,106,5,110,
		84,111,112,0,92,5,106,6,110,76,101,102,116,0,
		89,24,0,0,0,1,0,1,0,176,45,0,92,9,
		48,46,0,95,255,112,0,12,2,6,106,7,110,87,
		105,100,116,104,0,92,64,106,8,110,72,101,105,103,
		104,116,0,92,64,106,9,99,82,101,115,78,97,109,
		101,0,106,14,103,99,95,112,114,105,110,116,101,114,
		95,54,52,0,106,10,98,76,67,108,105,99,107,101,
		100,0,89,22,0,0,0,1,0,1,0,48,59,0,
		48,8,0,95,255,112,0,112,0,6,106,5,111,87,
		110,100,0,48,46,0,95,1,112,0,177,7,0,112,
		1,112,1,73,36,136,0,48,60,0,95,1,48,43,
		0,176,44,0,12,0,106,5,110,84,111,112,0,92,
		5,106,6,110,76,101,102,116,0,89,33,0,0,0,
		1,0,1,0,176,45,0,101,0,0,0,0,0,0,
		37,64,10,1,48,46,0,95,255,112,0,12,2,6,
		106,7,110,87,105,100,116,104,0,92,64,106,8,110,
		72,101,105,103,104,116,0,92,64,106,9,99,82,101,
		115,78,97,109,101,0,106,16,103,99,95,100,111,111,
		114,95,111,112,101,110,95,54,52,0,106,10,98,76,
		67,108,105,99,107,101,100,0,89,22,0,0,0,1,
		0,1,0,48,61,0,48,46,0,95,255,112,0,112,
		0,6,106,5,111,87,110,100,0,48,46,0,95,1,
		112,0,177,7,0,112,1,112,1,73,36,138,0,95,
		1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,64,0,2,0,116,64,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}
