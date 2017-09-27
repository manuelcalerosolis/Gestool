/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\Views\SQLBrowseView.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( SQLBROWSEVIEW );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBOBJECT );
HB_FUNC_STATIC( SQLBROWSEVIEW_NEW );
HB_FUNC_STATIC( SQLBROWSEVIEW_CREATE );
HB_FUNC_STATIC( SQLBROWSEVIEW_END );
HB_FUNC_STATIC( SQLBROWSEVIEW_ACTIVATEMDI );
HB_FUNC_STATIC( SQLBROWSEVIEW_ACTIVATEDIALOG );
HB_FUNC_STATIC( SQLBROWSEVIEW_SETSIZE );
HB_FUNC_STATIC( SQLBROWSEVIEW_GENERATECOLUMNS );
HB_FUNC_STATIC( SQLBROWSEVIEW_ADDCOLUMN );
HB_FUNC_STATIC( SQLBROWSEVIEW_ONKEYCHAR );
HB_FUNC_STATIC( SQLBROWSEVIEW_ONCLICKHEADER );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( SQLXBROWSE );
HB_FUNC_EXTERN( NOR );
HB_FUNC_EXTERN( HEVAL );
HB_FUNC_EXTERN( ASCAN );
HB_FUNC_EXTERN( MSGALERT );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_SQLBROWSEVIEW )
{ "SQLBROWSEVIEW", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBROWSEVIEW )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBOBJECT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBROWSEVIEW_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBROWSEVIEW_NEW )}, NULL },
{ "SQLBROWSEVIEW_CREATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBROWSEVIEW_CREATE )}, NULL },
{ "SQLBROWSEVIEW_END", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBROWSEVIEW_END )}, NULL },
{ "SQLBROWSEVIEW_ACTIVATEMDI", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBROWSEVIEW_ACTIVATEMDI )}, NULL },
{ "SQLBROWSEVIEW_ACTIVATEDIALOG", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBROWSEVIEW_ACTIVATEDIALOG )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETCONTROLLER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETMODEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETCOLUMNSFORBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETHEADERSFORBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETCOMBOBOXORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETMENUTREEVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBROWSEVIEW_SETSIZE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBROWSEVIEW_SETSIZE )}, NULL },
{ "SQLBROWSEVIEW_GENERATECOLUMNS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBROWSEVIEW_GENERATECOLUMNS )}, NULL },
{ "SQLBROWSEVIEW_ADDCOLUMN", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBROWSEVIEW_ADDCOLUMN )}, NULL },
{ "CREATEFROMCODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEFROMRESOURCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BLDBLCLICK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBROWSEVIEW_ONKEYCHAR", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBROWSEVIEW_ONKEYCHAR )}, NULL },
{ "SQLBROWSEVIEW_ONCLICKHEADER", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBROWSEVIEW_ONCLICKHEADER )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETSIZE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GENERATECOLUMNS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLXBROWSE", {HB_FS_PUBLIC}, {HB_FUNCNAME( SQLXBROWSE )}, NULL },
{ "GETWINDOW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_L2007", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LRECORDSELECTOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LAUTOSORT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LSORTDESCEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NMARQUEESTYLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BCLRSTD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BCLRSEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BCLRSELFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BRCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RBUTTONDOWN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETMODEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BKEYCHAR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ONKEYCHAR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NSTYLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOR", {HB_FS_PUBLIC}, {HB_FUNCNAME( NOR )}, NULL },
{ "_NTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NLEFT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NRIGHT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NBOTTOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETMODELCOLUMNSFORBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HEVAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( HEVAL )}, NULL },
{ "ADDCOLUMN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDCOL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CSORTORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NWIDTH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BLCLICKHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ONCLICKHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BEDITVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETEDITVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ASCAN", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASCAN )}, NULL },
{ "AITEMS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ONCHANGECOMBO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HFASTKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OMENUTREEVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGALERT", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGALERT )}, NULL },
{ "EVAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_SQLBROWSEVIEW, ".\\Prg\\Views\\SQLBrowseView.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_SQLBROWSEVIEW
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_SQLBROWSEVIEW )
   #include "hbiniseg.h"
#endif

HB_FUNC( SQLBROWSEVIEW )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,85,0,36,6,0,103,2,0,100,8,
		29,123,4,176,1,0,104,2,0,12,1,29,112,4,
		166,50,4,0,122,80,1,48,2,0,176,3,0,12,
		0,106,14,83,81,76,66,114,111,119,115,101,86,105,
		101,119,0,108,4,4,1,0,108,0,112,3,80,2,
		36,8,0,48,5,0,95,2,100,100,95,1,121,72,
		121,72,121,72,106,8,111,66,114,111,119,115,101,0,
		4,1,0,9,112,5,73,36,10,0,48,5,0,95,
		2,100,100,95,1,121,72,121,72,121,72,106,8,111,
		83,101,110,100,101,114,0,4,1,0,9,112,5,73,
		36,12,0,48,6,0,95,2,106,4,78,101,119,0,
		108,7,95,1,121,72,121,72,121,72,112,3,73,36,
		14,0,48,6,0,95,2,106,7,67,114,101,97,116,
		101,0,108,8,95,1,121,72,121,72,121,72,112,3,
		73,36,16,0,48,6,0,95,2,106,4,69,110,100,
		0,108,9,95,1,121,72,121,72,121,72,112,3,73,
		36,18,0,48,6,0,95,2,106,12,65,99,116,105,
		118,97,116,101,77,68,73,0,108,10,95,1,121,72,
		121,72,121,72,112,3,73,36,19,0,48,6,0,95,
		2,106,15,65,99,116,105,118,97,116,101,68,105,97,
		108,111,103,0,108,11,95,1,121,72,121,72,121,72,
		112,3,73,36,23,0,48,12,0,95,2,106,10,103,
		101,116,66,114,111,119,115,101,0,89,15,0,1,0,
		0,0,48,13,0,95,1,112,0,6,95,1,121,72,
		121,72,121,72,112,3,73,36,25,0,48,12,0,95,
		2,106,14,103,101,116,67,111,110,116,114,111,108,108,
		101,114,0,89,20,0,1,0,0,0,48,14,0,48,
		15,0,95,1,112,0,112,0,6,95,1,121,72,121,
		72,121,72,112,3,73,36,27,0,48,12,0,95,2,
		106,9,103,101,116,77,111,100,101,108,0,89,20,0,
		1,0,0,0,48,16,0,48,14,0,95,1,112,0,
		112,0,6,95,1,121,72,121,72,121,72,112,3,73,
		36,28,0,48,12,0,95,2,106,25,103,101,116,77,
		111,100,101,108,67,111,108,117,109,110,115,70,111,114,
		66,114,111,119,115,101,0,89,20,0,1,0,0,0,
		48,17,0,48,16,0,95,1,112,0,112,0,6,95,
		1,121,72,121,72,121,72,112,3,73,36,29,0,48,
		12,0,95,2,106,25,103,101,116,77,111,100,101,108,
		72,101,97,100,101,114,115,70,111,114,66,114,111,119,
		115,101,0,89,20,0,1,0,0,0,48,18,0,48,
		16,0,95,1,112,0,112,0,6,95,1,121,72,121,
		72,121,72,112,3,73,36,31,0,48,12,0,95,2,
		106,17,103,101,116,67,111,109,98,111,66,111,120,79,
		114,100,101,114,0,89,20,0,1,0,0,0,48,19,
		0,48,15,0,95,1,112,0,112,0,6,95,1,121,
		72,121,72,121,72,112,3,73,36,32,0,48,12,0,
		95,2,106,16,103,101,116,77,101,110,117,84,114,101,
		101,86,105,101,119,0,89,20,0,1,0,0,0,48,
		20,0,48,15,0,95,1,112,0,112,0,6,95,1,
		121,72,121,72,121,72,112,3,73,36,36,0,48,6,
		0,95,2,106,8,115,101,116,83,105,122,101,0,108,
		21,95,1,121,72,121,72,121,72,112,3,73,36,38,
		0,48,6,0,95,2,106,16,71,101,110,101,114,97,
		116,101,67,111,108,117,109,110,115,0,108,22,95,1,
		121,72,121,72,121,72,112,3,73,36,40,0,48,6,
		0,95,2,106,10,65,100,100,67,111,108,117,109,110,
		0,108,23,95,1,121,72,121,72,121,72,112,3,73,
		36,44,0,48,12,0,95,2,106,15,67,114,101,97,
		116,101,70,114,111,109,67,111,100,101,0,89,20,0,
		1,0,0,0,48,24,0,48,13,0,95,1,112,0,
		112,0,6,95,1,121,72,121,72,121,72,112,3,73,
		36,45,0,48,12,0,95,2,106,19,67,114,101,97,
		116,101,70,114,111,109,82,101,115,111,117,114,99,101,
		0,89,22,0,2,0,0,0,48,25,0,48,13,0,
		95,1,112,0,95,2,112,1,6,95,1,121,72,121,
		72,121,72,112,3,73,36,47,0,48,12,0,95,2,
		106,13,115,101,116,76,68,98,108,67,108,105,99,107,
		0,89,22,0,2,0,0,0,48,26,0,48,13,0,
		95,1,112,0,95,2,112,1,6,95,1,121,72,121,
		72,121,72,112,3,73,36,49,0,48,12,0,95,2,
		106,8,82,101,102,114,101,115,104,0,89,20,0,1,
		0,0,0,48,27,0,48,13,0,95,1,112,0,112,
		0,6,95,1,121,72,121,72,121,72,112,3,73,36,
		53,0,48,6,0,95,2,106,10,111,110,75,101,121,
		67,104,97,114,0,108,28,95,1,121,72,121,72,121,
		72,112,3,73,36,54,0,48,6,0,95,2,106,14,
		111,110,67,108,105,99,107,72,101,97,100,101,114,0,
		108,29,95,1,121,72,121,72,121,72,112,3,73,36,
		56,0,48,30,0,95,2,112,0,73,167,14,0,0,
		176,31,0,104,2,0,95,2,20,2,168,48,32,0,
		95,2,112,0,80,3,176,33,0,95,3,106,10,73,
		110,105,116,67,108,97,115,115,0,12,2,28,12,48,
		34,0,95,3,164,146,1,0,73,95,3,110,7,48,
		32,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBROWSEVIEW_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,62,0,48,35,0,102,95,1,112,1,
		73,36,64,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBROWSEVIEW_ACTIVATEMDI )
{
	static const HB_BYTE pcode[] =
	{
		13,0,4,36,70,0,48,30,0,102,112,0,73,36,
		72,0,48,36,0,102,95,1,95,2,95,3,95,4,
		112,4,73,36,74,0,48,37,0,102,112,0,73,36,
		76,0,48,24,0,102,112,0,73,36,78,0,102,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBROWSEVIEW_ACTIVATEDIALOG )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,84,0,48,30,0,102,112,0,73,36,
		86,0,48,37,0,102,112,0,73,36,88,0,48,25,
		0,102,95,1,112,1,73,36,90,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBROWSEVIEW_END )
{
	static const HB_BYTE pcode[] =
	{
		36,96,0,176,38,0,48,13,0,102,112,0,12,1,
		31,17,36,97,0,48,39,0,48,13,0,102,112,0,
		112,0,73,36,100,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBROWSEVIEW_CREATE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,104,0,102,80,1,36,106,0,48,40,
		0,95,1,48,2,0,176,41,0,12,0,48,42,0,
		48,15,0,95,1,112,0,112,0,112,1,112,1,73,
		36,107,0,48,43,0,48,13,0,95,1,112,0,9,
		112,1,73,36,109,0,48,44,0,48,13,0,95,1,
		112,0,9,112,1,73,36,110,0,48,45,0,48,13,
		0,95,1,112,0,120,112,1,73,36,111,0,48,46,
		0,48,13,0,95,1,112,0,9,112,1,73,36,115,
		0,48,47,0,48,13,0,95,1,112,0,92,6,112,
		1,73,36,117,0,48,48,0,48,13,0,95,1,112,
		0,90,12,121,97,255,255,255,0,4,2,0,6,112,
		1,73,36,118,0,48,49,0,48,13,0,95,1,112,
		0,90,12,121,97,229,229,229,0,4,2,0,6,112,
		1,73,36,119,0,48,50,0,48,13,0,95,1,112,
		0,90,12,121,97,167,205,240,0,4,2,0,6,112,
		1,73,36,121,0,48,51,0,48,13,0,95,1,112,
		0,89,23,0,3,0,1,0,1,0,48,52,0,95,
		255,95,1,95,2,95,3,112,3,6,112,1,73,36,
		123,0,48,53,0,48,13,0,95,1,112,0,48,16,
		0,95,1,112,0,112,1,73,36,125,0,48,54,0,
		48,13,0,95,1,112,0,89,24,0,1,0,1,0,
		1,0,48,55,0,48,14,0,95,255,112,0,95,1,
		112,1,6,112,1,73,36,127,0,48,26,0,48,13,
		0,95,1,112,0,89,30,0,0,0,1,0,1,0,
		48,56,0,48,14,0,95,255,112,0,112,0,73,48,
		27,0,95,255,112,0,6,112,1,73,36,129,0,48,
		13,0,95,1,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBROWSEVIEW_SETSIZE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,4,36,135,0,48,57,0,48,13,0,102,112,
		0,176,58,0,97,0,0,0,64,97,0,0,0,16,
		97,0,0,1,0,12,3,112,1,73,36,137,0,48,
		59,0,48,13,0,102,112,0,95,1,112,1,73,36,
		138,0,48,60,0,48,13,0,102,112,0,95,2,112,
		1,73,36,139,0,48,61,0,48,13,0,102,112,0,
		95,3,112,1,73,36,140,0,48,62,0,48,13,0,
		102,112,0,95,4,112,1,73,36,142,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBROWSEVIEW_GENERATECOLUMNS )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,146,0,102,80,1,36,148,0,48,63,
		0,95,1,112,0,80,2,36,150,0,176,38,0,95,
		2,12,1,28,9,36,151,0,95,1,110,7,36,154,
		0,176,64,0,95,2,89,21,0,2,0,1,0,1,
		0,48,65,0,95,255,95,1,95,2,112,2,6,20,
		2,36,156,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBROWSEVIEW_ADDCOLUMN )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,160,0,102,80,3,36,162,0,48,66,
		0,48,13,0,95,3,112,0,112,0,143,36,163,0,
		144,67,0,95,1,112,1,73,36,164,0,144,68,0,
		95,2,106,7,104,101,97,100,101,114,0,1,112,1,
		73,36,165,0,144,69,0,95,2,106,6,119,105,100,
		116,104,0,1,112,1,73,36,166,0,144,70,0,89,
		19,0,4,0,1,0,3,0,48,71,0,95,255,95,
		4,112,1,6,112,1,73,36,167,0,144,72,0,48,
		73,0,48,16,0,95,3,112,0,95,1,112,1,112,
		1,73,145,36,170,0,95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBROWSEVIEW_ONCLICKHEADER )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,176,0,48,19,0,102,112,0,80,2,
		36,178,0,176,38,0,95,2,12,1,28,8,36,179,
		0,102,110,7,36,182,0,176,38,0,95,1,12,1,
		28,8,36,183,0,102,110,7,36,186,0,176,74,0,
		48,75,0,95,2,112,0,48,76,0,95,1,112,0,
		12,2,121,8,28,8,36,187,0,102,110,7,36,190,
		0,48,77,0,95,2,48,76,0,95,1,112,0,112,
		1,73,36,192,0,48,78,0,48,15,0,102,112,0,
		112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBROWSEVIEW_ONKEYCHAR )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,198,0,176,64,0,48,79,0,48,80,
		0,48,15,0,102,112,0,112,0,112,0,89,41,0,
		2,0,1,0,1,0,176,81,0,95,255,106,5,110,
		75,101,121,0,20,2,95,1,95,255,8,28,11,48,
		82,0,95,2,112,0,25,3,100,6,20,2,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,85,0,2,0,116,85,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}
