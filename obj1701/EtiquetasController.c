/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\Controllers\EtiquetasController.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( ETIQUETASCONTROLLER );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( SQLBASECONTROLLER );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_NEW );
HB_FUNC_EXTERN( ETIQUETASMODEL );
HB_FUNC_EXTERN( ETIQUETAS );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_VALIDDIALOG );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_LOADCHILDBUFFER );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_APPENDCHILD );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_CHECKVALIDPARENT );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_STARTDIALOG );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_LOADTREE );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_SETTREE );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_CHANGETREE );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_CHANGEFINDTREE );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_CHECKSELECTEDNODE );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_VALIDBROWSE );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_SETTREESELECTEDITEMS );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_SETTREESELECTEDITEM );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_APPENDONBROWSE );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_EDITONBROWSE );
HB_FUNC_STATIC( ETIQUETASCONTROLLER_FILLALLSELECTEDNODE );
HB_FUNC_EXTERN( HB_ISARRAY );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( HB_HKEYS );
HB_FUNC_EXTERN( AEVAL );
HB_FUNC_EXTERN( HSET );
HB_FUNC_EXTERN( CVALTOSTR );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( SYSREFRESH );
HB_FUNC_EXTERN( LEN );
HB_FUNC_EXTERN( VAL );
HB_FUNC_EXTERN( AADD );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_ETIQUETASCONTROLLER )
{ "ETIQUETASCONTROLLER", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "SQLBASECONTROLLER", {HB_FS_PUBLIC}, {HB_FUNCNAME( SQLBASECONTROLLER )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ETIQUETASCONTROLLER_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_NEW )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ETIQUETASMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( ETIQUETASMODEL )}, NULL },
{ "ETIQUETAS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ETIQUETAS )}, NULL },
{ "ALLSELECTEDNODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ETIQUETASCONTROLLER_VALIDDIALOG", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_VALIDDIALOG )}, NULL },
{ "ETIQUETASCONTROLLER_LOADCHILDBUFFER", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_LOADCHILDBUFFER )}, NULL },
{ "ETIQUETASCONTROLLER_APPENDCHILD", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_APPENDCHILD )}, NULL },
{ "ETIQUETASCONTROLLER_CHECKVALIDPARENT", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_CHECKVALIDPARENT )}, NULL },
{ "ETIQUETASCONTROLLER_STARTDIALOG", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_STARTDIALOG )}, NULL },
{ "ETIQUETASCONTROLLER_LOADTREE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_LOADTREE )}, NULL },
{ "ETIQUETASCONTROLLER_SETTREE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_SETTREE )}, NULL },
{ "ETIQUETASCONTROLLER_CHANGETREE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_CHANGETREE )}, NULL },
{ "ETIQUETASCONTROLLER_CHANGEFINDTREE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_CHANGEFINDTREE )}, NULL },
{ "ETIQUETASCONTROLLER_CHECKSELECTEDNODE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_CHECKSELECTEDNODE )}, NULL },
{ "NSELECTEDNODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NSELECTEDNODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ETIQUETASCONTROLLER_VALIDBROWSE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_VALIDBROWSE )}, NULL },
{ "DELETEALL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ETIQUETASCONTROLLER_SETTREESELECTEDITEMS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_SETTREESELECTEDITEMS )}, NULL },
{ "ETIQUETASCONTROLLER_SETTREESELECTEDITEM", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_SETTREESELECTEDITEM )}, NULL },
{ "ETIQUETASCONTROLLER_APPENDONBROWSE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_APPENDONBROWSE )}, NULL },
{ "ETIQUETASCONTROLLER_EDITONBROWSE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_EDITONBROWSE )}, NULL },
{ "ETIQUETASCONTROLLER_FILLALLSELECTEDNODE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ETIQUETASCONTROLLER_FILLALLSELECTEDNODE )}, NULL },
{ "HB_ISARRAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ISARRAY )}, NULL },
{ "_ALLSELECTEDNODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_IDUSERMAP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETTITLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SUPER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETSELECTEDNODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "HBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OMODEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "SETFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHECKSFORVALID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ISDUPLICATEMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHECKSELECTEDNODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ISEDITMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETSELECTEDNODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHECKVALIDPARENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_HKEYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_HKEYS )}, NULL },
{ "HCOLUMNS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OROWSET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_HBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AEVAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( AEVAL )}, NULL },
{ "HSET", {HB_FS_PUBLIC}, {HB_FUNCNAME( HSET )}, NULL },
{ "FIELDGET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOTUSERAPPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETIDFORRECNO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETIDFROMROWSET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LOADCHILDBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DIALOG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INSERTCHILDBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESHCURRENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LOADTREE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETTREE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CVALTOSTR", {HB_FS_PUBLIC}, {HB_FUNCNAME( CVALTOSTR )}, NULL },
{ "RECNO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETROWSET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FIND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CARGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CARGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FINDNEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EXPAND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AITEMS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "SELECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETCHECK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SYSREFRESH", {HB_FS_PUBLIC}, {HB_FUNCNAME( SYSREFRESH )}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "GETCHECK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( VAL )}, NULL },
{ "CHANGETREE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CTEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SCAN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPROMPT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETALLSELECTEDNODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FILLALLSELECTEDNODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( AADD )}, NULL },
{ "SETTREESELECTEDITEM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INITTREE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETTREESELECTEDITEMS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETSELECTED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_ETIQUETASCONTROLLER, ".\\Prg\\Controllers\\EtiquetasController.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_ETIQUETASCONTROLLER
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_ETIQUETASCONTROLLER )
   #include "hbiniseg.h"
#endif

HB_FUNC( ETIQUETASCONTROLLER )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,107,0,36,9,0,103,2,0,100,8,
		29,16,5,176,1,0,104,2,0,12,1,29,5,5,
		166,199,4,0,122,80,1,48,2,0,176,3,0,12,
		0,106,20,69,116,105,113,117,101,116,97,115,67,111,
		110,116,114,111,108,108,101,114,0,108,4,4,1,0,
		108,0,112,3,80,2,36,11,0,48,5,0,95,2,
		100,100,95,1,121,72,121,72,121,72,106,14,110,83,
		101,108,101,99,116,101,100,78,111,100,101,0,4,1,
		0,9,112,5,73,36,13,0,48,5,0,95,2,100,
		100,95,1,121,72,121,72,121,72,106,16,97,108,108,
		83,101,108,101,99,116,101,100,78,111,100,101,0,4,
		1,0,9,112,5,73,36,15,0,48,6,0,95,2,
		106,4,78,101,119,0,108,7,95,1,121,72,121,72,
		121,72,112,3,73,36,17,0,48,8,0,95,2,106,
		14,98,117,105,108,100,83,81,76,77,111,100,101,108,
		0,89,20,0,2,0,0,0,48,2,0,176,9,0,
		12,0,95,2,112,1,6,95,1,121,72,121,72,121,
		72,112,3,73,36,19,0,48,8,0,95,2,106,13,
		98,117,105,108,100,83,81,76,86,105,101,119,0,89,
		20,0,2,0,0,0,48,2,0,176,10,0,12,0,
		95,2,112,1,6,95,1,121,72,121,72,121,72,112,
		3,73,36,21,0,48,8,0,95,2,106,19,103,101,
		116,70,105,101,108,100,70,114,111,109,66,114,111,119,
		115,101,0,89,15,0,1,0,0,0,48,11,0,95,
		1,112,0,6,95,1,121,72,121,72,121,72,112,3,
		73,36,23,0,48,6,0,95,2,106,12,118,97,108,
		105,100,68,105,97,108,111,103,0,108,12,95,1,121,
		72,121,72,121,72,112,3,73,36,25,0,48,6,0,
		95,2,106,16,108,111,97,100,67,104,105,108,100,66,
		117,102,102,101,114,0,108,13,95,1,121,72,121,72,
		121,72,112,3,73,36,27,0,48,6,0,95,2,106,
		12,65,112,112,101,110,100,67,104,105,108,100,0,108,
		14,95,1,121,72,121,72,121,72,112,3,73,36,29,
		0,48,6,0,95,2,106,17,99,104,101,99,107,86,
		97,108,105,100,80,97,114,101,110,116,0,108,15,95,
		1,121,72,121,72,121,72,112,3,73,36,31,0,48,
		6,0,95,2,106,12,115,116,97,114,116,68,105,97,
		108,111,103,0,108,16,95,1,121,72,121,72,121,72,
		112,3,73,36,33,0,48,6,0,95,2,106,9,108,
		111,97,100,84,114,101,101,0,108,17,95,1,121,72,
		121,72,121,72,112,3,73,36,34,0,48,6,0,95,
		2,106,8,115,101,116,84,114,101,101,0,108,18,95,
		1,121,72,121,72,121,72,112,3,73,36,35,0,48,
		6,0,95,2,106,11,99,104,97,110,103,101,84,114,
		101,101,0,108,19,95,1,121,72,121,72,121,72,112,
		3,73,36,36,0,48,6,0,95,2,106,15,99,104,
		97,110,103,101,70,105,110,100,84,114,101,101,0,108,
		20,95,1,121,72,121,72,121,72,112,3,73,36,38,
		0,48,6,0,95,2,106,18,99,104,101,99,107,83,
		101,108,101,99,116,101,100,78,111,100,101,0,108,21,
		95,1,121,72,121,72,121,72,112,3,73,36,39,0,
		48,8,0,95,2,106,16,103,101,116,83,101,108,101,
		99,116,101,100,78,111,100,101,0,89,15,0,1,0,
		0,0,48,22,0,95,1,112,0,6,95,1,121,72,
		121,72,121,72,112,3,73,36,40,0,48,8,0,95,
		2,106,16,115,101,116,83,101,108,101,99,116,101,100,
		78,111,100,101,0,89,17,0,2,0,0,0,48,23,
		0,95,1,95,2,112,1,6,95,1,121,72,121,72,
		121,72,112,3,73,36,42,0,48,6,0,95,2,106,
		12,118,97,108,105,100,66,114,111,119,115,101,0,108,
		24,95,1,121,72,121,72,121,72,112,3,73,36,45,
		0,48,8,0,95,2,106,9,105,110,105,116,84,114,
		101,101,0,89,23,0,2,0,0,0,48,25,0,95,
		2,112,0,73,48,26,0,95,2,112,0,6,95,1,
		121,72,121,72,121,72,112,3,73,36,47,0,48,6,
		0,95,2,106,21,115,101,116,84,114,101,101,83,101,
		108,101,99,116,101,100,73,116,101,109,115,0,108,27,
		95,1,121,72,121,72,121,72,112,3,73,36,48,0,
		48,6,0,95,2,106,20,115,101,116,84,114,101,101,
		83,101,108,101,99,116,101,100,73,116,101,109,0,108,
		28,95,1,121,72,121,72,121,72,112,3,73,36,50,
		0,48,6,0,95,2,106,15,97,112,112,101,110,100,
		79,110,66,114,111,119,115,101,0,108,29,95,1,121,
		72,121,72,121,72,112,3,73,36,51,0,48,6,0,
		95,2,106,13,101,100,105,116,79,110,66,114,111,119,
		115,101,0,108,30,95,1,121,72,121,72,121,72,112,
		3,73,36,53,0,48,6,0,95,2,106,20,102,105,
		108,108,65,108,108,83,101,108,101,99,116,101,100,78,
		111,100,101,0,108,31,95,1,121,72,121,72,121,72,
		112,3,73,36,56,0,48,8,0,95,2,106,19,115,
		101,116,65,108,108,83,101,108,101,99,116,101,100,78,
		111,100,101,0,89,38,0,2,0,0,0,176,32,0,
		95,2,12,1,28,13,48,33,0,95,1,95,2,112,
		1,25,12,48,33,0,95,1,4,0,0,112,1,6,
		95,1,121,72,121,72,121,72,112,3,73,36,58,0,
		48,8,0,95,2,106,14,105,115,83,112,101,99,105,
		97,108,77,111,100,101,0,89,18,0,1,0,0,0,
		48,34,0,95,1,112,0,92,9,8,6,95,1,121,
		72,121,72,121,72,112,3,73,36,61,0,48,35,0,
		95,2,112,0,73,167,14,0,0,176,36,0,104,2,
		0,95,2,20,2,168,48,37,0,95,2,112,0,80,
		3,176,38,0,95,3,106,10,73,110,105,116,67,108,
		97,115,115,0,12,2,28,12,48,39,0,95,3,164,
		146,1,0,73,95,3,110,7,48,37,0,103,2,0,
		112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_NEW )
{
	static const HB_BYTE pcode[] =
	{
		36,67,0,48,40,0,102,106,6,48,49,49,48,49,
		0,112,1,73,36,69,0,48,41,0,102,106,10,69,
		116,105,113,117,101,116,97,115,0,112,1,73,36,71,
		0,48,23,0,102,100,112,1,73,36,73,0,48,2,
		0,48,42,0,102,112,0,112,0,73,36,75,0,102,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_VALIDDIALOG )
{
	static const HB_BYTE pcode[] =
	{
		13,1,3,36,83,0,48,43,0,102,100,112,1,73,
		36,85,0,176,44,0,48,45,0,48,46,0,102,112,
		0,112,0,106,7,110,111,109,98,114,101,0,1,12,
		1,28,73,36,86,0,176,47,0,106,44,78,111,109,
		98,114,101,32,100,101,32,108,97,32,101,116,105,113,
		117,101,116,97,32,110,111,32,112,117,101,100,101,32,
		101,115,116,97,114,32,118,97,99,237,111,46,0,20,
		1,36,87,0,48,48,0,95,3,112,0,73,36,88,
		0,9,110,7,36,91,0,48,49,0,48,46,0,102,
		112,0,106,7,110,111,109,98,114,101,0,112,1,80,
		4,36,93,0,176,44,0,95,4,12,1,32,193,0,
		36,94,0,95,4,48,45,0,48,46,0,102,112,0,
		112,0,106,3,105,100,0,1,69,28,72,48,50,0,
		102,112,0,31,64,36,95,0,176,47,0,106,35,69,
		108,32,110,111,109,98,114,101,32,100,101,32,108,97,
		32,101,116,105,113,117,101,116,97,32,121,97,32,101,
		120,105,115,116,101,0,20,1,36,96,0,48,48,0,
		95,3,112,0,73,36,97,0,9,110,7,36,99,0,
		95,4,48,45,0,48,46,0,102,112,0,112,0,106,
		3,105,100,0,1,8,28,72,48,50,0,102,112,0,
		28,64,36,100,0,176,47,0,106,35,69,108,32,110,
		111,109,98,114,101,32,100,101,32,108,97,32,101,116,
		105,113,117,101,116,97,32,121,97,32,101,120,105,115,
		116,101,0,20,1,36,101,0,48,48,0,95,3,112,
		0,73,36,102,0,9,110,7,36,106,0,48,51,0,
		102,95,2,112,1,73,36,108,0,48,52,0,102,112,
		0,29,212,0,36,110,0,48,45,0,48,46,0,102,
		112,0,112,0,106,3,105,100,0,1,48,53,0,102,
		112,0,8,28,86,36,111,0,176,47,0,106,68,82,
		101,102,101,114,101,110,99,105,97,32,97,32,115,105,
		32,109,105,115,109,111,46,32,85,110,97,32,101,116,
		105,113,117,101,116,97,32,110,111,32,112,117,101,100,
		101,32,115,101,114,32,112,97,100,114,101,32,100,101,
		32,115,105,32,109,105,115,109,97,46,0,20,1,36,
		112,0,9,110,7,36,115,0,48,54,0,102,112,0,
		31,87,36,116,0,176,47,0,106,69,82,101,102,101,
		114,101,110,99,105,97,32,99,237,99,108,105,99,97,
		46,32,85,110,97,32,101,116,105,113,117,101,116,97,
		32,104,105,106,111,32,110,111,32,112,117,101,100,101,
		32,115,101,114,32,112,97,100,114,101,32,100,101,32,
		115,117,32,112,97,100,114,101,0,20,1,36,117,0,
		9,110,7,36,122,0,48,53,0,102,95,2,112,1,
		48,45,0,48,46,0,102,112,0,112,0,106,9,105,
		100,95,112,97,100,114,101,0,2,36,124,0,48,55,
		0,95,1,122,112,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_LOADCHILDBUFFER )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,128,0,102,80,1,36,130,0,176,56,
		0,48,57,0,48,46,0,95,1,112,0,112,0,12,
		1,80,2,36,132,0,176,44,0,48,58,0,48,46,
		0,95,1,112,0,112,0,12,1,28,8,36,133,0,
		9,110,7,36,136,0,48,59,0,48,46,0,95,1,
		112,0,177,0,0,112,1,73,36,138,0,176,60,0,
		95,2,89,83,0,1,0,1,0,1,0,176,61,0,
		48,45,0,48,46,0,95,255,112,0,112,0,95,1,
		95,1,106,9,105,100,95,112,97,100,114,101,0,8,
		28,26,48,62,0,48,58,0,48,46,0,95,255,112,
		0,112,0,106,3,105,100,0,112,1,25,16,95,1,
		106,3,105,100,0,8,28,5,121,25,3,100,12,3,
		6,20,2,36,140,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_APPENDCHILD )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,146,0,48,63,0,102,112,0,28,39,
		36,147,0,176,47,0,106,21,65,99,99,101,115,111,
		32,110,111,32,112,101,114,109,105,116,105,100,111,46,
		0,20,1,36,148,0,102,110,7,36,151,0,48,64,
		0,102,92,9,112,1,73,36,153,0,48,65,0,48,
		46,0,102,112,0,48,66,0,102,112,0,112,1,73,
		36,155,0,48,67,0,102,112,0,73,36,157,0,48,
		68,0,48,69,0,102,112,0,112,0,28,17,36,158,
		0,48,70,0,48,46,0,102,112,0,112,0,73,36,
		161,0,176,44,0,95,1,12,1,31,24,36,162,0,
		48,71,0,95,1,112,0,73,36,163,0,48,48,0,
		95,1,112,0,73,36,166,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_STARTDIALOG )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,172,0,48,72,0,102,95,1,112,1,
		73,36,174,0,48,73,0,102,48,45,0,48,46,0,
		102,112,0,112,0,106,9,105,100,95,112,97,100,114,
		101,0,1,95,1,112,2,73,36,176,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_LOADTREE )
{
	static const HB_BYTE pcode[] =
	{
		13,3,2,36,186,0,95,2,100,8,28,7,106,1,
		0,80,2,36,188,0,176,74,0,95,2,12,1,80,
		2,36,190,0,48,75,0,48,76,0,102,112,0,112,
		0,80,4,36,192,0,48,77,0,48,76,0,102,112,
		0,95,2,106,9,105,100,95,112,97,100,114,101,0,
		112,2,80,5,36,194,0,95,5,121,8,28,30,36,
		195,0,48,77,0,48,76,0,102,112,0,121,106,9,
		105,100,95,112,97,100,114,101,0,112,2,80,5,36,
		198,0,95,5,121,69,29,130,0,36,200,0,48,78,
		0,95,1,48,62,0,48,76,0,102,112,0,106,7,
		110,111,109,98,114,101,0,112,1,112,1,80,3,36,
		201,0,48,79,0,95,3,48,62,0,48,76,0,102,
		112,0,106,3,105,100,0,112,1,112,1,73,36,203,
		0,48,72,0,102,95,3,48,80,0,95,3,112,0,
		112,2,73,36,205,0,48,81,0,48,76,0,102,112,
		0,95,5,112,1,73,36,207,0,48,82,0,48,76,
		0,102,112,0,95,2,106,9,105,100,95,112,97,100,
		114,101,0,112,2,80,5,26,122,255,36,211,0,48,
		81,0,48,76,0,102,112,0,95,4,112,1,73,36,
		213,0,48,83,0,95,1,112,0,73,36,215,0,102,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_SETTREE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,3,36,223,0,176,44,0,95,3,12,1,28,
		14,36,224,0,48,84,0,95,2,112,0,80,3,36,
		227,0,95,3,96,4,0,129,1,1,28,118,36,229,
		0,176,85,0,176,74,0,95,1,12,1,12,1,176,
		85,0,176,74,0,48,80,0,95,4,112,0,12,1,
		12,1,8,28,37,36,231,0,48,86,0,95,2,95,
		4,112,1,73,36,232,0,48,87,0,95,2,95,4,
		120,112,2,73,36,234,0,176,88,0,20,0,36,238,
		0,176,89,0,48,84,0,95,4,112,0,12,1,121,
		15,28,23,36,239,0,48,73,0,102,95,1,95,2,
		48,84,0,95,4,112,0,112,3,73,36,242,0,130,
		31,142,132,36,244,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_CHECKSELECTEDNODE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,252,0,176,44,0,95,2,12,1,28,
		14,36,253,0,48,84,0,95,1,112,0,80,2,36,
		0,1,95,2,96,3,0,129,1,1,28,77,36,2,
		1,48,90,0,95,1,95,3,112,1,28,19,36,3,
		1,48,43,0,102,48,80,0,95,3,112,0,112,1,
		73,36,6,1,176,89,0,48,84,0,95,3,112,0,
		12,1,121,15,28,21,36,7,1,48,51,0,102,95,
		1,48,84,0,95,3,112,0,112,2,73,36,10,1,
		130,31,183,132,36,12,1,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_CHECKVALIDPARENT )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,18,1,48,53,0,102,112,0,80,3,
		36,20,1,176,44,0,95,3,12,1,28,8,36,21,
		1,120,110,7,36,24,1,95,3,121,69,28,110,36,
		26,1,48,77,0,48,76,0,102,112,0,95,3,106,
		3,105,100,0,112,2,121,69,28,34,36,28,1,176,
		91,0,48,62,0,48,76,0,102,112,0,106,9,105,
		100,95,112,97,100,114,101,0,112,1,12,1,80,3,
		36,32,1,176,85,0,176,74,0,95,3,12,1,12,
		1,176,85,0,176,74,0,48,45,0,48,46,0,102,
		112,0,112,0,106,3,105,100,0,1,12,1,12,1,
		8,28,147,36,34,1,9,110,7,36,40,1,120,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_CHANGETREE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,48,1,176,44,0,95,2,12,1,28,
		14,36,49,1,48,84,0,95,1,112,0,80,2,36,
		52,1,95,2,96,3,0,129,1,1,28,68,36,54,
		1,176,88,0,20,0,36,56,1,48,87,0,95,1,
		95,3,9,112,2,73,36,58,1,176,89,0,48,84,
		0,95,3,112,0,12,1,121,15,28,21,36,59,1,
		48,92,0,102,95,1,48,84,0,95,3,112,0,112,
		2,73,36,62,1,130,31,192,132,36,64,1,120,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_CHANGEFINDTREE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,2,36,71,1,176,85,0,48,93,0,95,1,
		112,0,12,1,80,4,36,73,1,176,44,0,95,4,
		12,1,31,34,36,74,1,48,94,0,95,2,89,20,
		0,1,0,1,0,4,0,95,255,48,95,0,95,1,
		112,0,24,6,112,1,80,3,36,77,1,176,44,0,
		95,3,12,1,31,15,36,78,1,48,86,0,95,2,
		95,3,112,1,73,36,81,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_VALIDBROWSE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,87,1,48,96,0,102,112,0,73,36,
		89,1,48,97,0,102,95,2,112,1,73,36,91,1,
		48,55,0,95,1,122,112,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_FILLALLSELECTEDNODE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,99,1,176,44,0,95,2,12,1,28,
		14,36,100,1,48,84,0,95,1,112,0,80,2,36,
		103,1,95,2,96,3,0,129,1,1,28,81,36,105,
		1,48,90,0,95,1,95,3,112,1,28,23,36,106,
		1,176,98,0,48,11,0,102,112,0,48,95,0,95,
		3,112,0,20,2,36,109,1,176,89,0,48,84,0,
		95,3,112,0,12,1,121,15,28,21,36,110,1,48,
		97,0,102,95,1,48,84,0,95,3,112,0,112,2,
		73,36,113,1,130,31,179,132,36,115,1,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_SETTREESELECTEDITEMS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,119,1,102,80,2,36,121,1,176,60,
		0,48,11,0,95,2,112,0,89,23,0,1,0,2,
		0,2,0,1,0,48,99,0,95,255,95,1,95,254,
		112,2,6,20,2,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_SETTREESELECTEDITEM )
{
	static const HB_BYTE pcode[] =
	{
		13,1,3,36,129,1,176,44,0,95,3,12,1,28,
		14,36,130,1,48,84,0,95,2,112,0,80,3,36,
		133,1,95,3,96,4,0,129,1,1,28,118,36,135,
		1,176,85,0,176,74,0,95,1,12,1,12,1,176,
		85,0,176,74,0,48,95,0,95,4,112,0,12,1,
		12,1,8,28,37,36,137,1,48,86,0,95,2,95,
		4,112,1,73,36,138,1,48,87,0,95,2,95,4,
		120,112,2,73,36,140,1,176,88,0,20,0,36,144,
		1,176,89,0,48,84,0,95,4,112,0,12,1,121,
		15,28,23,36,145,1,48,99,0,102,95,1,95,2,
		48,84,0,95,4,112,0,112,3,73,36,148,1,130,
		31,142,132,36,150,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_APPENDONBROWSE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,156,1,48,97,0,102,95,1,112,1,
		73,36,158,1,48,100,0,102,112,0,28,38,36,159,
		1,48,101,0,102,95,1,112,1,73,36,160,1,48,
		72,0,102,95,1,112,1,73,36,161,1,48,102,0,
		102,95,1,112,1,73,36,164,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ETIQUETASCONTROLLER_EDITONBROWSE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,170,1,48,77,0,48,76,0,102,112,
		0,48,80,0,48,103,0,95,1,112,0,112,0,106,
		3,105,100,0,112,2,73,36,172,1,48,97,0,102,
		95,1,112,1,73,36,174,1,48,104,0,102,112,0,
		28,38,36,175,1,48,101,0,102,95,1,112,1,73,
		36,176,1,48,72,0,102,95,1,112,1,73,36,177,
		1,48,102,0,102,95,1,112,1,73,36,180,1,102,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,107,0,2,0,116,107,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}
