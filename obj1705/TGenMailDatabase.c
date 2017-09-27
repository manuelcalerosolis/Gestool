/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\mail\TGenMailDatabase.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TGENMAILINGDATABASE );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TGENMAILING );
HB_FUNC_STATIC( TGENMAILINGDATABASE_NEW );
HB_FUNC_STATIC( TGENMAILINGDATABASE_DATABASEDIALOG );
HB_FUNC_STATIC( TGENMAILINGDATABASE_BUILDPAGEDATABASE );
HB_FUNC_STATIC( TGENMAILINGDATABASE_COLUMNPAGEDATABASE );
HB_FUNC_STATIC( TGENMAILINGDATABASE_SELECTCOLUMN );
HB_FUNC_STATIC( TGENMAILINGDATABASE_FREERESOURCES );
HB_FUNC_STATIC( TGENMAILINGDATABASE_SELMAILING );
HB_FUNC_STATIC( TGENMAILINGDATABASE_SELALLMAILING );
HB_FUNC_STATIC( TGENMAILINGDATABASE_GETDATABASELIST );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_STATIC( TGENMAILINGDATABASE_DIALOGFILTER );
HB_FUNC_STATIC( TGENMAILINGDATABASE_BUILDFILTER );
HB_FUNC_STATIC( TGENMAILINGDATABASE_QUITFILTER );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( TFILTERCREATOR );
HB_FUNC_EXTERN( SPACE );
HB_FUNC_EXTERN( TBITMAP );
HB_FUNC_EXTERN( TGETHLP );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( AUTOSEEK );
HB_FUNC_EXTERN( TCOMBOBOX );
HB_FUNC_EXTERN( TBUTTON );
HB_FUNC_EXTERN( TBTNBMP );
HB_FUNC_EXTERN( IXBROWSE );
HB_FUNC_EXTERN( EQUAL );
HB_FUNC_EXTERN( CURSORWAIT );
HB_FUNC_EXTERN( RECNO );
HB_FUNC_EXTERN( DBEVAL );
HB_FUNC_EXTERN( DBGOTO );
HB_FUNC_EXTERN( CURSORARROW );
HB_FUNC_EXTERN( CREATEFASTFILTER );
HB_FUNC_EXTERN( DESTROYFASTFILTER );
HB_FUNC_EXTERN( DBDIALOGLOCK );
HB_FUNC_EXTERN( DBUNLOCK );
HB_FUNC_EXTERN( HGETSTATUS );
HB_FUNC_EXTERN( HSETSTATUS );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TGENMAILDATABASE )
{ "TGENMAILINGDATABASE", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TGENMAILING", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGENMAILING )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGENMAILINGDATABASE_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE_NEW )}, NULL },
{ "TGENMAILINGDATABASE_DATABASEDIALOG", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE_DATABASEDIALOG )}, NULL },
{ "TGENMAILINGDATABASE_BUILDPAGEDATABASE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE_BUILDPAGEDATABASE )}, NULL },
{ "TGENMAILINGDATABASE_COLUMNPAGEDATABASE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE_COLUMNPAGEDATABASE )}, NULL },
{ "TGENMAILINGDATABASE_SELECTCOLUMN", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE_SELECTCOLUMN )}, NULL },
{ "TGENMAILINGDATABASE_FREERESOURCES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE_FREERESOURCES )}, NULL },
{ "TGENMAILINGDATABASE_SELMAILING", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE_SELMAILING )}, NULL },
{ "TGENMAILINGDATABASE_SELALLMAILING", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE_SELALLMAILING )}, NULL },
{ "TGENMAILINGDATABASE_GETDATABASELIST", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE_GETDATABASELIST )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETWORKAREA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LMAIL", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "ADDSELECTEDLIST", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETITEMS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SUPER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "OFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETFIELDS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGENMAILINGDATABASE_DIALOGFILTER", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE_DIALOGFILTER )}, NULL },
{ "TGENMAILINGDATABASE_BUILDFILTER", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE_BUILDFILTER )}, NULL },
{ "TGENMAILINGDATABASE_QUITFILTER", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TGENMAILINGDATABASE_QUITFILTER )}, NULL },
{ "_AORDERDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TFILTERCREATOR", {HB_FS_PUBLIC}, {HB_FUNCNAME( TFILTERCREATOR )}, NULL },
{ "_LPAGEDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETMULTISELECT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_APAGES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HIDERECIPIENTS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RESOURCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SPACE", {HB_FS_PUBLIC}, {HB_FUNCNAME( SPACE )}, NULL },
{ "ADIALOGS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OFLD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CORDERDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AORDERDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OBMPDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBITMAP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBITMAP )}, NULL },
{ "CBMPDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGETHLP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGETHLP )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "_BCHANGE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AUTOSEEK", {HB_FS_PUBLIC}, {HB_FUNCNAME( AUTOSEEK )}, NULL },
{ "OBRWDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OORDERDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TCOMBOBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TCOMBOBOX )}, NULL },
{ "CORDERDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OORDERDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SELECTCOLUMN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBUTTON )}, NULL },
{ "SELMAILING", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SELALLMAILING", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OBNTCREATEFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DIALOGFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OBNTQUITFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBTNBMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBTNBMP )}, NULL },
{ "QUITFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OBRWDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "IXBROWSE", {HB_FS_PUBLIC}, {HB_FUNCNAME( IXBROWSE )}, NULL },
{ "_BCLRSEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BCLRSELFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NMARQUEESTYLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEFROMRESOURCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BLDBLCLICK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "COLUMNPAGEDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDCOL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BSTRDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BEDITVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NWIDTH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETCHECK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CSORTORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "COD", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "_BLCLICKHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TITULO", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CMEIINT", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "VARGET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACOLS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EQUAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( EQUAL )}, NULL },
{ "SETORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CURSORWAIT", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURSORWAIT )}, NULL },
{ "_AMAILINGLIST", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECNO", {HB_FS_PUBLIC}, {HB_FUNCNAME( RECNO )}, NULL },
{ "DBEVAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBEVAL )}, NULL },
{ "ADDDATABASELIST", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBGOTO", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBGOTO )}, NULL },
{ "CURSORARROW", {HB_FS_PUBLIC}, {HB_FUNCNAME( CURSORARROW )}, NULL },
{ "AMAILINGLIST", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FREERESOURCES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OBMPDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DIALOG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CEXPRESIONFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BUILDFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEFASTFILTER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CREATEFASTFILTER )}, NULL },
{ "SETTEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OBNTCREATEFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SHOW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OBNTQUITFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DESTROYFASTFILTER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DESTROYFASTFILTER )}, NULL },
{ "HIDE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBDIALOGLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBDIALOGLOCK )}, NULL },
{ "DBUNLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBUNLOCK )}, NULL },
{ "HGETSTATUS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HGETSTATUS )}, NULL },
{ "HSETSTATUS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HSETSTATUS )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TGENMAILDATABASE, ".\\Prg\\mail\\TGenMailDatabase.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TGENMAILDATABASE
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TGENMAILDATABASE )
   #include "hbiniseg.h"
#endif

HB_FUNC( TGENMAILINGDATABASE )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,124,0,36,6,0,103,2,0,100,8,
		29,78,4,176,1,0,104,2,0,12,1,29,67,4,
		166,5,4,0,122,80,1,48,2,0,176,3,0,12,
		0,106,20,84,71,101,110,77,97,105,108,105,110,103,
		68,97,116,97,98,97,115,101,0,108,4,4,1,0,
		108,0,112,3,80,2,36,8,0,48,5,0,95,2,
		100,100,95,1,121,72,121,72,121,72,106,8,111,70,
		105,108,116,101,114,0,4,1,0,9,112,5,73,36,
		10,0,48,5,0,95,2,100,100,95,1,121,72,121,
		72,121,72,106,13,111,66,114,119,68,97,116,97,98,
		97,115,101,0,4,1,0,9,112,5,73,36,12,0,
		48,5,0,95,2,100,100,95,1,121,72,121,72,121,
		72,106,17,111,66,110,116,67,114,101,97,116,101,70,
		105,108,116,101,114,0,4,1,0,9,112,5,73,36,
		13,0,48,5,0,95,2,100,100,95,1,121,72,121,
		72,121,72,106,15,111,66,110,116,81,117,105,116,70,
		105,108,116,101,114,0,4,1,0,9,112,5,73,36,
		15,0,48,6,0,95,2,106,4,78,101,119,0,108,
		7,95,1,121,72,121,72,121,72,112,3,73,36,17,
		0,48,6,0,95,2,106,15,100,97,116,97,98,97,
		115,101,68,105,97,108,111,103,0,108,8,95,1,121,
		72,121,72,121,72,112,3,73,36,19,0,48,5,0,
		95,2,100,100,95,1,121,72,121,72,121,72,106,15,
		111,79,114,100,101,114,68,97,116,97,98,97,115,101,
		0,4,1,0,9,112,5,73,36,20,0,48,5,0,
		95,2,100,100,95,1,121,72,121,72,121,72,106,15,
		99,79,114,100,101,114,68,97,116,97,98,97,115,101,
		0,4,1,0,9,112,5,73,36,21,0,48,5,0,
		95,2,100,106,7,67,243,100,105,103,111,0,106,7,
		78,111,109,98,114,101,0,106,19,67,111,114,114,101,
		111,32,101,108,101,99,116,114,243,110,105,99,111,0,
		4,3,0,95,1,121,72,121,72,121,72,106,15,97,
		79,114,100,101,114,68,97,116,97,98,97,115,101,0,
		4,1,0,9,112,5,73,36,23,0,48,6,0,95,
		2,106,18,98,117,105,108,100,80,97,103,101,68,97,
		116,97,98,97,115,101,0,108,9,95,1,121,72,121,
		72,121,72,112,3,73,36,24,0,48,6,0,95,2,
		106,19,99,111,108,117,109,110,80,97,103,101,68,97,
		116,97,98,97,115,101,0,108,10,95,1,121,72,121,
		72,121,72,112,3,73,36,25,0,48,6,0,95,2,
		106,13,115,101,108,101,99,116,67,111,108,117,109,110,
		0,108,11,95,1,121,72,121,72,121,72,112,3,73,
		36,26,0,48,6,0,95,2,106,14,102,114,101,101,
		82,101,115,111,117,114,99,101,115,0,108,12,95,1,
		121,72,121,72,121,72,112,3,73,36,28,0,48,6,
		0,95,2,106,11,83,101,108,77,97,105,108,105,110,
		103,0,108,13,95,1,121,72,121,72,121,72,112,3,
		73,36,29,0,48,6,0,95,2,106,14,83,101,108,
		65,108,108,77,97,105,108,105,110,103,0,108,14,95,
		1,121,72,121,72,121,72,112,3,73,36,31,0,48,
		6,0,95,2,106,16,103,101,116,68,97,116,97,98,
		97,115,101,76,105,115,116,0,108,15,95,1,121,72,
		121,72,121,72,112,3,73,36,32,0,48,16,0,95,
		2,106,16,97,100,100,68,97,116,97,98,97,115,101,
		76,105,115,116,0,89,30,0,1,0,0,0,48,17,
		0,95,1,112,0,88,18,0,28,11,48,19,0,95,
		1,112,0,25,3,100,6,95,1,121,72,121,72,121,
		72,112,3,73,36,35,0,48,16,0,95,2,106,9,
		115,101,116,73,116,101,109,115,0,89,54,0,2,0,
		0,0,48,20,0,48,21,0,95,1,112,0,95,2,
		112,1,73,176,22,0,48,23,0,95,1,112,0,12,
		1,31,18,48,24,0,48,23,0,95,1,112,0,95,
		2,112,1,25,3,100,6,95,1,121,72,121,72,121,
		72,112,3,73,36,37,0,48,6,0,95,2,106,13,
		100,105,97,108,111,103,70,105,108,116,101,114,0,108,
		25,95,1,121,72,121,72,121,72,112,3,73,36,38,
		0,48,6,0,95,2,106,12,98,117,105,108,100,70,
		105,108,116,101,114,0,108,26,95,1,121,72,121,72,
		121,72,112,3,73,36,39,0,48,6,0,95,2,106,
		11,113,117,105,116,70,105,108,116,101,114,0,108,27,
		95,1,121,72,121,72,121,72,112,3,73,36,42,0,
		48,16,0,95,2,106,17,115,101,116,79,114,100,101,
		114,68,97,116,97,98,97,115,101,0,89,17,0,2,
		0,0,0,48,28,0,95,1,95,2,112,1,6,95,
		1,121,72,121,72,121,72,112,3,73,36,44,0,48,
		29,0,95,2,112,0,73,167,14,0,0,176,30,0,
		104,2,0,95,2,20,2,168,48,31,0,95,2,112,
		0,80,3,176,32,0,95,3,106,10,73,110,105,116,
		67,108,97,115,115,0,12,2,28,12,48,33,0,95,
		3,164,146,1,0,73,95,3,110,7,48,31,0,103,
		2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TGENMAILINGDATABASE_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,50,0,48,2,0,48,21,0,102,112,
		0,95,1,112,1,73,36,52,0,48,34,0,102,48,
		35,0,176,36,0,12,0,102,112,1,112,1,73,36,
		54,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TGENMAILINGDATABASE_DATABASEDIALOG )
{
	static const HB_BYTE pcode[] =
	{
		36,60,0,48,37,0,102,120,112,1,73,36,62,0,
		48,38,0,102,120,112,1,73,36,64,0,48,39,0,
		102,106,21,83,101,108,101,99,116,95,77,97,105,108,
		95,82,101,100,97,99,116,97,114,0,106,22,83,101,
		108,101,99,116,95,77,97,105,108,95,82,101,103,105,
		115,116,114,111,115,0,106,20,83,101,108,101,99,116,
		95,77,97,105,108,95,80,114,111,99,101,115,111,0,
		4,3,0,112,1,73,36,66,0,48,40,0,102,112,
		0,73,36,68,0,48,41,0,102,112,0,73,36,70,
		0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TGENMAILINGDATABASE_BUILDPAGEDATABASE )
{
	static const HB_BYTE pcode[] =
	{
		13,4,0,36,74,0,102,80,1,36,78,0,176,42,
		0,92,100,12,1,80,4,36,82,0,48,43,0,48,
		44,0,95,1,112,0,112,0,92,2,1,80,2,36,
		84,0,48,45,0,95,1,48,46,0,95,1,112,0,
		122,1,112,1,73,36,90,0,48,47,0,95,1,48,
		48,0,176,49,0,12,0,93,244,1,48,50,0,95,
		1,112,0,100,95,2,100,100,9,9,100,100,9,100,
		100,120,112,14,112,1,73,36,96,0,48,48,0,176,
		51,0,12,0,92,100,89,28,0,1,0,1,0,4,
		0,176,52,0,12,0,121,8,28,6,95,255,25,7,
		95,1,165,80,255,6,95,2,100,100,100,100,100,100,
		100,100,9,100,100,9,9,100,100,100,100,100,100,106,
		5,70,73,78,68,0,100,100,112,25,80,3,36,98,
		0,48,53,0,95,3,89,35,0,3,0,1,0,1,
		0,176,54,0,95,1,95,2,95,3,48,55,0,95,
		255,112,0,48,17,0,95,255,112,0,12,5,6,112,
		1,73,36,104,0,48,56,0,95,1,48,48,0,176,
		57,0,12,0,92,110,89,37,0,1,0,1,0,1,
		0,176,52,0,12,0,121,8,28,11,48,58,0,95,
		255,112,0,25,11,48,45,0,95,255,95,1,112,1,
		6,48,46,0,95,1,112,0,95,2,100,100,100,100,
		100,100,9,100,100,100,100,100,100,112,17,112,1,73,
		36,106,0,48,53,0,48,59,0,95,1,112,0,89,
		17,0,0,0,1,0,1,0,48,60,0,95,255,112,
		0,6,112,1,73,36,111,0,48,48,0,176,61,0,
		12,0,93,130,0,89,17,0,0,0,1,0,1,0,
		48,62,0,95,255,112,0,6,95,2,100,100,9,100,
		100,100,9,112,10,73,36,116,0,48,48,0,176,61,
		0,12,0,93,140,0,89,18,0,0,0,1,0,1,
		0,48,63,0,95,255,120,112,1,6,95,2,100,100,
		9,100,100,100,9,112,10,73,36,121,0,48,48,0,
		176,61,0,12,0,93,150,0,89,18,0,0,0,1,
		0,1,0,48,63,0,95,255,9,112,1,6,95,2,
		100,100,9,100,100,100,9,112,10,73,36,126,0,48,
		64,0,95,1,48,48,0,176,61,0,12,0,93,170,
		0,89,17,0,0,0,1,0,1,0,48,65,0,95,
		255,112,0,6,95,2,100,100,9,100,100,100,9,112,
		10,112,1,73,36,128,0,48,66,0,95,1,48,48,
		0,176,67,0,12,0,93,180,0,106,6,68,101,108,
		49,54,0,100,100,100,100,89,17,0,0,0,1,0,
		1,0,48,68,0,95,255,112,0,6,95,2,9,100,
		9,106,14,81,117,105,116,97,114,32,102,105,108,116,
		114,111,0,112,12,112,1,73,36,132,0,48,69,0,
		95,1,48,2,0,176,70,0,12,0,95,2,112,1,
		112,1,73,36,134,0,48,71,0,48,55,0,95,1,
		112,0,90,12,121,97,229,229,229,0,4,2,0,6,
		112,1,73,36,135,0,48,72,0,48,55,0,95,1,
		112,0,90,12,121,97,167,205,240,0,4,2,0,6,
		112,1,73,36,137,0,48,73,0,48,55,0,95,1,
		112,0,48,17,0,95,1,112,0,112,1,73,36,139,
		0,48,74,0,48,55,0,95,1,112,0,92,5,112,
		1,73,36,141,0,48,75,0,48,55,0,95,1,112,
		0,93,160,0,112,1,73,36,143,0,48,76,0,48,
		55,0,95,1,112,0,89,17,0,0,0,1,0,1,
		0,48,62,0,95,255,112,0,6,112,1,73,36,147,
		0,48,77,0,95,1,95,2,112,1,73,36,149,0,
		95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TGENMAILINGDATABASE_COLUMNPAGEDATABASE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,153,0,102,80,2,36,155,0,48,78,
		0,48,55,0,95,2,112,0,112,0,143,36,156,0,
		144,79,0,106,17,83,101,46,32,115,101,108,101,99,
		99,105,111,110,97,100,111,0,112,1,73,36,157,0,
		144,80,0,90,6,106,1,0,6,112,1,73,36,158,
		0,144,81,0,89,20,0,0,0,1,0,2,0,48,
		17,0,95,255,112,0,88,18,0,6,112,1,73,36,
		159,0,144,82,0,92,20,112,1,73,36,160,0,144,
		83,0,106,6,83,101,108,49,54,0,106,6,78,105,
		108,49,54,0,4,2,0,112,1,73,145,36,163,0,
		48,78,0,48,55,0,95,2,112,0,112,0,143,36,
		164,0,144,79,0,106,7,67,243,100,105,103,111,0,
		112,1,73,36,165,0,144,84,0,106,4,67,111,100,
		0,112,1,73,36,166,0,144,81,0,89,20,0,0,
		0,1,0,2,0,48,17,0,95,255,112,0,88,85,
		0,6,112,1,73,36,167,0,144,82,0,92,70,112,
		1,73,36,168,0,144,86,0,89,29,0,4,0,1,
		0,2,0,48,87,0,48,59,0,95,255,112,0,48,
		88,0,95,4,112,0,112,1,6,112,1,73,145,36,
		171,0,48,78,0,48,55,0,95,2,112,0,112,0,
		143,36,172,0,144,79,0,106,7,78,111,109,98,114,
		101,0,112,1,73,36,173,0,144,84,0,106,7,84,
		105,116,117,108,111,0,112,1,73,36,174,0,144,81,
		0,89,20,0,0,0,1,0,2,0,48,17,0,95,
		255,112,0,88,89,0,6,112,1,73,36,175,0,144,
		82,0,93,44,1,112,1,73,36,176,0,144,86,0,
		89,29,0,4,0,1,0,2,0,48,87,0,48,59,
		0,95,255,112,0,48,88,0,95,4,112,0,112,1,
		6,112,1,73,145,36,179,0,48,78,0,48,55,0,
		95,2,112,0,112,0,143,36,180,0,144,79,0,106,
		19,67,111,114,114,101,111,32,101,108,101,99,116,114,
		243,110,105,99,111,0,112,1,73,36,181,0,144,84,
		0,106,8,99,77,101,105,73,110,116,0,112,1,73,
		36,182,0,144,81,0,89,20,0,0,0,1,0,2,
		0,48,17,0,95,255,112,0,88,90,0,6,112,1,
		73,36,183,0,144,82,0,93,4,1,112,1,73,36,
		184,0,144,86,0,89,29,0,4,0,1,0,2,0,
		48,87,0,48,59,0,95,255,112,0,48,88,0,95,
		4,112,0,112,1,6,112,1,73,145,36,187,0,95,
		2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TGENMAILINGDATABASE_SELECTCOLUMN )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,196,0,176,22,0,48,55,0,102,112,
		0,12,1,28,8,36,197,0,102,110,7,36,200,0,
		48,91,0,48,59,0,102,112,0,112,0,80,2,36,
		202,0,48,55,0,102,112,0,143,36,204,0,144,92,
		0,112,0,96,1,0,129,1,1,28,55,36,205,0,
		176,93,0,95,2,48,88,0,95,1,112,0,12,2,
		28,15,36,206,0,48,94,0,95,1,112,0,73,25,
		17,36,208,0,48,95,0,95,1,106,2,32,0,112,
		1,73,36,210,0,130,31,205,132,145,36,214,0,48,
		96,0,48,55,0,102,112,0,112,0,73,36,216,0,
		102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TGENMAILINGDATABASE_GETDATABASELIST )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,220,0,102,80,1,36,224,0,176,97,
		0,20,0,36,226,0,48,98,0,95,1,4,0,0,
		112,1,73,36,228,0,85,48,17,0,95,1,112,0,
		74,176,99,0,12,0,119,80,2,36,229,0,85,48,
		17,0,95,1,112,0,74,176,100,0,89,17,0,0,
		0,1,0,1,0,48,101,0,95,255,112,0,6,20,
		1,74,36,230,0,85,48,17,0,95,1,112,0,74,
		176,102,0,95,2,20,1,74,36,232,0,176,103,0,
		20,0,36,234,0,48,104,0,95,1,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TGENMAILINGDATABASE_FREERESOURCES )
{
	static const HB_BYTE pcode[] =
	{
		36,240,0,48,105,0,48,21,0,102,112,0,112,0,
		73,36,242,0,176,22,0,48,106,0,102,112,0,12,
		1,31,17,36,243,0,48,107,0,48,106,0,102,112,
		0,112,0,73,36,246,0,176,22,0,48,23,0,102,
		112,0,12,1,31,17,36,247,0,48,107,0,48,23,
		0,102,112,0,112,0,73,36,250,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TGENMAILINGDATABASE_DIALOGFILTER )
{
	static const HB_BYTE pcode[] =
	{
		36,0,1,48,108,0,48,23,0,102,112,0,112,0,
		73,36,2,1,176,22,0,48,109,0,48,23,0,102,
		112,0,112,0,12,1,31,14,36,3,1,48,110,0,
		102,112,0,73,25,12,36,5,1,48,68,0,102,112,
		0,73,36,8,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TGENMAILINGDATABASE_BUILDFILTER )
{
	static const HB_BYTE pcode[] =
	{
		36,14,1,176,111,0,48,109,0,48,23,0,102,112,
		0,112,0,48,17,0,102,112,0,9,20,3,36,16,
		1,48,112,0,48,113,0,102,112,0,106,15,38,70,
		105,108,116,114,111,32,97,99,116,105,118,111,0,47,
		112,1,73,36,18,1,48,114,0,48,115,0,102,112,
		0,112,0,73,36,20,1,48,96,0,48,55,0,102,
		112,0,112,0,73,36,22,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TGENMAILINGDATABASE_QUITFILTER )
{
	static const HB_BYTE pcode[] =
	{
		36,28,1,176,116,0,48,17,0,102,112,0,20,1,
		36,30,1,48,112,0,48,113,0,102,112,0,106,8,
		38,70,105,108,116,114,111,0,47,112,1,73,36,32,
		1,48,117,0,48,115,0,102,112,0,112,0,73,36,
		34,1,48,96,0,48,55,0,102,112,0,112,0,73,
		36,36,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TGENMAILINGDATABASE_SELMAILING )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,42,1,95,1,100,8,28,14,48,17,
		0,102,112,0,88,18,0,68,80,1,36,44,1,176,
		118,0,48,17,0,102,112,0,12,1,28,33,36,45,
		1,95,1,48,17,0,102,112,0,77,18,0,36,46,
		1,85,48,17,0,102,112,0,74,176,119,0,20,0,
		74,36,49,1,48,96,0,48,55,0,102,112,0,112,
		0,73,36,51,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TGENMAILINGDATABASE_SELALLMAILING )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,55,1,102,80,2,36,59,1,95,1,
		100,8,28,5,120,80,1,36,61,1,176,97,0,20,
		0,36,63,1,176,120,0,48,17,0,95,2,112,0,
		121,12,2,80,3,36,64,1,85,48,17,0,95,2,
		112,0,74,176,100,0,89,21,0,0,0,2,0,2,
		0,1,0,48,62,0,95,255,95,254,112,1,6,20,
		1,74,36,65,1,176,121,0,95,3,20,1,36,67,
		1,176,103,0,20,0,36,69,1,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,124,0,2,0,116,124,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

