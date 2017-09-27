/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\TComentarios.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TCOMENTARIOS );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TMASDET );
HB_FUNC_STATIC( TCOMENTARIOS_OPENFILES );
HB_FUNC_STATIC( TCOMENTARIOS_CLOSEFILES );
HB_FUNC_STATIC( TCOMENTARIOS_DEFINEFILES );
HB_FUNC_STATIC( TCOMENTARIOS_OPENSERVICE );
HB_FUNC_STATIC( TCOMENTARIOS_CLOSESERVICE );
HB_FUNC_STATIC( TCOMENTARIOS_RESOURCE );
HB_FUNC_STATIC( TCOMENTARIOS_LPRESAVE );
HB_FUNC_STATIC( TCOMENTARIOS_DELRECCOMENTARIO );
HB_FUNC_STATIC( TCOMENTARIOS_REINDEXA );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( TDETCOMENTARIOS );
HB_FUNC_EXTERN( CDRIVER );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( ERRORMESSAGE );
HB_FUNC_EXTERN( DBFSERVER );
HB_FUNC_EXTERN( TDIALOG );
HB_FUNC_EXTERN( TGETHLP );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( RJUSTOBJ );
HB_FUNC_EXTERN( TBUTTON );
HB_FUNC_EXTERN( IXBROWSE );
HB_FUNC_EXTERN( RTRIM );
HB_FUNC_EXTERN( OUSER );
HB_FUNC_EXTERN( APOLOMSGNOYES );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TCOMENTARIOS )
{ "TCOMENTARIOS", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TCOMENTARIOS )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TMASDET", {HB_FS_PUBLIC}, {HB_FUNCNAME( TMASDET )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TCOMENTARIOS_OPENFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCOMENTARIOS_OPENFILES )}, NULL },
{ "TCOMENTARIOS_CLOSEFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCOMENTARIOS_CLOSEFILES )}, NULL },
{ "TCOMENTARIOS_DEFINEFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCOMENTARIOS_DEFINEFILES )}, NULL },
{ "TCOMENTARIOS_OPENSERVICE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCOMENTARIOS_OPENSERVICE )}, NULL },
{ "TCOMENTARIOS_CLOSESERVICE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCOMENTARIOS_CLOSESERVICE )}, NULL },
{ "TCOMENTARIOS_RESOURCE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCOMENTARIOS_RESOURCE )}, NULL },
{ "TCOMENTARIOS_LPRESAVE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCOMENTARIOS_LPRESAVE )}, NULL },
{ "TCOMENTARIOS_DELRECCOMENTARIO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCOMENTARIOS_DELRECCOMENTARIO )}, NULL },
{ "TCOMENTARIOS_REINDEXA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCOMENTARIOS_REINDEXA )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPATH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODETCOMENTARIOS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDETCOMENTARIOS", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDETCOMENTARIOS )}, NULL },
{ "CDRIVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CDRIVER )}, NULL },
{ "ADDDETAIL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODETCOMENTARIOS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OPENDETAILS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BFIRSTKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODIGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CLOSEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "ERRORMESSAGE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORMESSAGE )}, NULL },
{ "CLOSEDETAILS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBFSERVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBFSERVER )}, NULL },
{ "ADDFIELD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDINDEX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDIALOG", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDIALOG )}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGETHLP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGETHLP )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "_CCODIGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RJUSTOBJ", {HB_FS_PUBLIC}, {HB_FUNCNAME( RJUSTOBJ )}, NULL },
{ "CDESCRI", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CDESCRI", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBUTTON )}, NULL },
{ "APPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ZOOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DELRECCOMENTARIO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "IXBROWSE", {HB_FS_PUBLIC}, {HB_FUNCNAME( IXBROWSE )}, NULL },
{ "_BCLRSEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BCLRSELFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NMARQUEESTYLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BLDBLCLICK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETBROWSE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBFVIR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDCOL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BEDITVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEFROMRESOURCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LPRESAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDFASTKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BSTART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BLCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BMOVED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BPAINTED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BRCLICKED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NRESULT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LVALID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SEEKINORD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( RTRIM )}, NULL },
{ "RECNO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LNOTCONFIRMDELETE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OUSER", {HB_FS_PUBLIC}, {HB_FUNCNAME( OUSER )}, NULL },
{ "APOLOMSGNOYES", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOMSGNOYES )}, NULL },
{ "DELETE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "IDXFDEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OPENFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PACK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TCOMENTARIOS, ".\\.\\Prg\\TComentarios.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TCOMENTARIOS
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TCOMENTARIOS )
   #include "hbiniseg.h"
#endif

HB_FUNC( TCOMENTARIOS )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,93,0,36,7,0,103,2,0,100,8,
		29,85,2,176,1,0,104,2,0,12,1,29,74,2,
		166,12,2,0,122,80,1,48,2,0,176,3,0,12,
		0,106,13,84,67,111,109,101,110,116,97,114,105,111,
		115,0,108,4,4,1,0,108,0,112,3,80,2,36,
		9,0,48,5,0,95,2,100,106,14,103,99,95,109,
		101,115,115,97,103,101,95,49,54,0,95,1,121,72,
		121,72,121,72,106,5,99,77,114,117,0,4,1,0,
		9,112,5,73,36,11,0,48,5,0,95,2,100,97,
		104,0,63,0,95,1,121,72,121,72,121,72,106,8,
		99,66,105,116,109,97,112,0,4,1,0,9,112,5,
		73,36,13,0,48,5,0,95,2,100,100,95,1,121,
		72,121,72,121,72,106,16,111,68,101,116,67,111,109,
		101,110,116,97,114,105,111,115,0,4,1,0,9,112,
		5,73,36,15,0,48,5,0,95,2,100,100,95,1,
		121,72,121,72,121,72,106,7,67,111,100,105,103,111,
		0,4,1,0,9,112,5,73,36,17,0,48,6,0,
		95,2,106,10,79,112,101,110,70,105,108,101,115,0,
		108,7,95,1,121,72,121,72,121,72,112,3,73,36,
		18,0,48,6,0,95,2,106,11,67,108,111,115,101,
		70,105,108,101,115,0,108,8,95,1,121,72,121,72,
		121,72,112,3,73,36,20,0,48,6,0,95,2,106,
		12,68,101,102,105,110,101,70,105,108,101,115,0,108,
		9,95,1,121,72,121,72,121,72,112,3,73,36,22,
		0,48,6,0,95,2,106,12,79,112,101,110,83,101,
		114,118,105,99,101,0,108,10,95,1,121,72,121,72,
		121,72,112,3,73,36,23,0,48,6,0,95,2,106,
		13,67,108,111,115,101,83,101,114,118,105,99,101,0,
		108,11,95,1,121,72,121,72,121,72,112,3,73,36,
		25,0,48,6,0,95,2,106,9,82,101,115,111,117,
		114,99,101,0,108,12,95,1,121,72,121,72,121,72,
		112,3,73,36,27,0,48,6,0,95,2,106,9,108,
		80,114,101,83,97,118,101,0,108,13,95,1,121,72,
		121,72,121,72,112,3,73,36,29,0,48,6,0,95,
		2,106,17,68,101,108,82,101,99,67,111,109,101,110,
		116,97,114,105,111,0,108,14,95,1,121,72,121,72,
		121,72,112,3,73,36,31,0,48,6,0,95,2,106,
		9,82,101,105,110,100,101,120,97,0,108,15,95,1,
		121,72,121,72,121,72,112,3,73,36,33,0,48,16,
		0,95,2,112,0,73,167,14,0,0,176,17,0,104,
		2,0,95,2,20,2,168,48,18,0,95,2,112,0,
		80,3,176,19,0,95,3,106,10,73,110,105,116,67,
		108,97,115,115,0,12,2,28,12,48,20,0,95,3,
		164,146,1,0,73,95,3,110,7,48,18,0,103,2,
		0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCOMENTARIOS_OPENFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,4,2,36,37,0,102,80,3,36,39,0,120,80,
		4,36,43,0,95,2,100,8,28,11,48,21,0,95,
		3,112,0,80,2,36,44,0,95,1,100,8,28,5,
		9,80,1,36,46,0,176,22,0,89,15,0,1,0,
		0,0,176,23,0,95,1,12,1,6,12,1,80,6,
		36,47,0,113,155,0,0,36,49,0,176,24,0,48,
		25,0,95,3,112,0,12,1,28,15,36,50,0,48,
		26,0,95,3,95,2,112,1,73,36,53,0,48,27,
		0,48,25,0,95,3,112,0,9,95,1,68,112,2,
		73,36,55,0,48,28,0,95,3,48,2,0,176,29,
		0,12,0,48,21,0,95,3,112,0,176,30,0,12,
		0,95,3,112,3,112,1,73,36,56,0,48,31,0,
		95,3,48,32,0,95,3,112,0,112,1,73,36,58,
		0,48,33,0,95,3,112,0,73,36,60,0,48,34,
		0,95,3,89,22,0,0,0,1,0,3,0,48,35,
		0,48,25,0,95,255,112,0,112,0,6,112,1,73,
		114,94,0,0,36,62,0,115,80,5,36,64,0,9,
		80,4,36,66,0,48,36,0,95,3,112,0,73,36,
		68,0,176,37,0,176,38,0,95,5,12,1,106,50,
		73,109,112,111,115,105,98,108,101,32,97,98,114,105,
		114,32,108,97,115,32,98,97,115,101,115,32,100,101,
		32,100,97,116,111,115,32,100,101,32,99,111,109,101,
		110,116,97,114,105,111,115,0,20,2,36,72,0,176,
		22,0,95,6,20,1,36,74,0,95,4,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCOMENTARIOS_CLOSEFILES )
{
	static const HB_BYTE pcode[] =
	{
		36,80,0,48,39,0,102,112,0,73,36,82,0,176,
		24,0,48,25,0,102,112,0,12,1,31,17,36,83,
		0,48,40,0,48,25,0,102,112,0,112,0,73,36,
		86,0,48,41,0,102,100,112,1,73,36,88,0,120,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCOMENTARIOS_OPENSERVICE )
{
	static const HB_BYTE pcode[] =
	{
		13,3,2,36,94,0,120,80,3,36,98,0,95,2,
		100,8,28,10,48,21,0,102,112,0,80,2,36,99,
		0,95,1,100,8,28,5,9,80,1,36,101,0,176,
		22,0,89,15,0,1,0,0,0,176,23,0,95,1,
		12,1,6,12,1,80,5,36,102,0,113,55,0,0,
		36,104,0,176,24,0,48,25,0,102,112,0,12,1,
		28,14,36,105,0,48,26,0,102,95,2,112,1,73,
		36,108,0,48,27,0,48,25,0,102,112,0,9,95,
		1,68,112,2,73,114,93,0,0,36,110,0,115,80,
		4,36,112,0,9,80,3,36,114,0,48,36,0,102,
		112,0,73,36,116,0,176,37,0,176,38,0,95,4,
		12,1,106,50,73,109,112,111,115,105,98,108,101,32,
		97,98,114,105,114,32,108,97,115,32,98,97,115,101,
		115,32,100,101,32,100,97,116,111,115,32,100,101,32,
		99,111,109,101,110,116,97,114,105,111,115,0,20,2,
		36,120,0,176,22,0,95,5,20,1,36,122,0,95,
		3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCOMENTARIOS_CLOSESERVICE )
{
	static const HB_BYTE pcode[] =
	{
		36,128,0,176,24,0,48,25,0,102,112,0,12,1,
		31,17,36,129,0,48,40,0,48,25,0,102,112,0,
		112,0,73,36,132,0,48,41,0,102,100,112,1,73,
		36,134,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCOMENTARIOS_DEFINEFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,140,0,95,1,100,8,28,10,48,21,
		0,102,112,0,80,1,36,141,0,95,2,100,8,28,
		9,176,30,0,12,0,80,2,36,143,0,48,41,0,
		102,48,2,0,176,42,0,106,17,67,111,109,101,110,
		116,97,114,105,111,115,84,46,68,98,102,0,106,11,
		67,111,109,101,110,116,97,114,105,111,0,12,2,106,
		17,67,111,109,101,110,116,97,114,105,111,115,84,46,
		68,98,102,0,106,7,67,111,109,101,110,116,0,95,
		2,106,12,67,111,109,101,110,116,97,114,105,111,115,
		0,95,1,112,5,112,1,73,36,145,0,48,43,0,
		48,25,0,102,112,0,106,8,99,67,111,100,105,103,
		111,0,106,2,67,0,92,3,121,100,100,100,100,106,
		7,67,243,100,105,103,111,0,9,92,60,9,4,0,
		0,112,13,73,36,146,0,48,43,0,48,25,0,102,
		112,0,106,8,99,68,101,115,99,114,105,0,106,2,
		67,0,93,200,0,121,100,100,100,100,106,12,68,101,
		115,99,114,105,112,99,105,243,110,0,9,93,44,1,
		9,4,0,0,112,13,73,36,148,0,48,44,0,48,
		25,0,102,112,0,106,8,99,67,111,100,105,103,111,
		0,106,17,67,111,109,101,110,116,97,114,105,111,115,
		84,46,67,100,120,0,106,8,99,67,111,100,105,103,
		111,0,100,100,9,9,106,7,67,243,100,105,103,111,
		0,100,100,120,9,112,12,73,36,149,0,48,44,0,
		48,25,0,102,112,0,106,8,99,68,101,115,99,114,
		105,0,106,17,67,111,109,101,110,116,97,114,105,111,
		115,84,46,67,100,120,0,106,8,99,68,101,115,99,
		114,105,0,100,100,9,9,106,12,68,101,115,99,114,
		105,112,99,105,243,110,0,100,100,120,9,112,12,73,
		36,153,0,48,25,0,102,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCOMENTARIOS_RESOURCE )
{
	static const HB_BYTE pcode[] =
	{
		13,5,1,36,157,0,102,80,2,36,164,0,48,2,
		0,176,45,0,12,0,100,100,100,100,100,106,12,67,
		111,109,101,110,116,97,114,105,111,115,0,100,9,100,
		100,100,100,100,9,100,100,100,100,100,9,100,106,5,
		111,68,108,103,0,100,100,112,24,80,3,36,171,0,
		48,46,0,176,47,0,12,0,92,100,89,47,0,1,
		0,1,0,2,0,176,48,0,12,0,121,8,28,16,
		48,35,0,48,25,0,95,255,112,0,112,0,25,16,
		48,49,0,48,25,0,95,255,112,0,95,1,112,1,
		6,95,3,100,106,3,64,33,0,89,22,0,0,0,
		1,0,4,0,176,50,0,95,255,106,2,48,0,20,
		2,120,6,100,100,100,100,100,9,89,14,0,0,0,
		1,0,1,0,95,255,122,8,6,100,9,9,100,100,
		100,100,100,100,100,100,100,112,25,80,4,36,176,0,
		48,46,0,176,47,0,12,0,92,110,89,47,0,1,
		0,1,0,2,0,176,48,0,12,0,121,8,28,16,
		48,51,0,48,25,0,95,255,112,0,112,0,25,16,
		48,52,0,48,25,0,95,255,112,0,95,1,112,1,
		6,95,3,100,100,100,100,100,100,100,100,9,89,15,
		0,0,0,1,0,1,0,95,255,92,3,69,6,100,
		9,9,100,100,100,100,100,100,100,100,100,112,25,80,
		5,36,186,0,48,46,0,176,53,0,12,0,93,244,
		1,89,26,0,0,0,2,0,2,0,6,0,48,54,
		0,48,32,0,95,255,112,0,95,254,112,1,6,95,
		3,100,100,9,89,15,0,0,0,1,0,1,0,95,
		255,92,3,69,6,100,100,9,112,10,73,36,192,0,
		48,46,0,176,53,0,12,0,93,245,1,89,26,0,
		0,0,2,0,2,0,6,0,48,55,0,48,32,0,
		95,255,112,0,95,254,112,1,6,95,3,100,100,9,
		89,15,0,0,0,1,0,1,0,95,255,92,3,69,
		6,100,100,9,112,10,73,36,197,0,48,46,0,176,
		53,0,12,0,93,246,1,89,22,0,0,0,1,0,
		2,0,48,56,0,48,32,0,95,255,112,0,112,0,
		6,95,3,100,100,9,100,100,100,9,112,10,73,36,
		203,0,48,46,0,176,53,0,12,0,93,247,1,89,
		21,0,0,0,2,0,2,0,6,0,48,57,0,95,
		255,95,254,112,1,6,95,3,100,100,9,89,15,0,
		0,0,1,0,1,0,95,255,92,3,69,6,100,100,
		9,112,10,73,36,205,0,48,2,0,176,58,0,12,
		0,95,3,112,1,80,6,36,207,0,48,59,0,95,
		6,90,12,121,97,229,229,229,0,4,2,0,6,112,
		1,73,36,208,0,48,60,0,95,6,90,12,121,97,
		167,205,240,0,4,2,0,6,112,1,73,36,210,0,
		48,61,0,95,6,92,5,112,1,73,36,212,0,48,
		62,0,95,6,89,26,0,0,0,2,0,2,0,6,
		0,48,55,0,48,32,0,95,255,112,0,95,254,112,
		1,6,112,1,73,36,214,0,48,63,0,48,64,0,
		48,32,0,95,2,112,0,112,0,95,6,112,1,73,
		36,216,0,48,65,0,95,6,112,0,143,36,217,0,
		144,66,0,106,12,68,101,115,99,114,105,112,99,105,
		243,110,0,112,1,73,36,218,0,144,67,0,89,27,
		0,0,0,1,0,2,0,48,51,0,48,64,0,48,
		32,0,95,255,112,0,112,0,112,0,6,112,1,73,
		145,36,221,0,48,68,0,95,6,93,144,1,112,1,
		73,36,227,0,48,46,0,176,53,0,12,0,122,89,
		33,0,0,0,5,0,2,0,4,0,5,0,3,0,
		1,0,48,69,0,95,255,95,254,95,253,95,252,95,
		251,112,4,6,95,3,100,100,9,89,15,0,0,0,
		1,0,1,0,95,255,92,3,69,6,100,100,9,112,
		10,73,36,233,0,48,46,0,176,53,0,12,0,92,
		2,89,17,0,0,0,1,0,3,0,48,40,0,95,
		255,112,0,6,95,3,100,100,9,100,100,100,120,112,
		10,73,36,235,0,95,1,92,3,69,29,166,0,36,
		236,0,48,70,0,95,3,92,113,89,26,0,0,0,
		2,0,2,0,6,0,48,54,0,48,32,0,95,255,
		112,0,95,254,112,1,6,112,2,73,36,237,0,48,
		70,0,95,3,92,114,89,26,0,0,0,2,0,2,
		0,6,0,48,55,0,48,32,0,95,255,112,0,95,
		254,112,1,6,112,2,73,36,238,0,48,70,0,95,
		3,92,115,89,26,0,0,0,2,0,2,0,6,0,
		48,71,0,48,32,0,95,255,112,0,95,254,112,1,
		6,112,2,73,36,239,0,48,70,0,95,3,92,116,
		89,33,0,0,0,5,0,2,0,4,0,5,0,3,
		0,1,0,48,69,0,95,255,95,254,95,253,95,252,
		95,251,112,4,6,112,2,73,36,242,0,48,72,0,
		95,3,89,17,0,0,0,1,0,4,0,48,73,0,
		95,255,112,0,6,112,1,73,36,244,0,48,27,0,
		95,3,48,74,0,95,3,112,0,48,75,0,95,3,
		112,0,48,76,0,95,3,112,0,120,100,100,100,48,
		77,0,95,3,112,0,100,100,100,112,11,73,36,246,
		0,48,78,0,95,3,112,0,122,8,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCOMENTARIOS_LPRESAVE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,4,36,252,0,95,4,122,8,31,10,95,4,
		92,4,8,29,197,0,36,254,0,48,79,0,95,1,
		112,0,73,36,0,1,48,80,0,48,25,0,102,112,
		0,48,35,0,48,25,0,102,112,0,112,0,106,8,
		99,67,111,100,105,103,111,0,112,2,28,53,36,1,
		1,176,37,0,106,18,67,243,100,105,103,111,32,121,
		97,32,101,120,105,115,116,101,32,0,176,81,0,48,
		35,0,48,25,0,102,112,0,112,0,12,1,72,20,
		1,36,2,1,9,110,7,36,5,1,176,24,0,48,
		35,0,48,25,0,102,112,0,112,0,12,1,28,76,
		36,6,1,176,37,0,106,47,69,108,32,99,243,100,
		105,103,111,32,100,101,108,32,99,111,109,101,110,116,
		97,114,105,111,32,110,111,32,112,117,101,100,101,32,
		101,115,116,97,114,32,118,97,99,237,111,46,0,20,
		1,36,7,1,48,73,0,95,1,112,0,73,36,8,
		1,9,110,7,36,13,1,176,24,0,48,51,0,48,
		25,0,102,112,0,112,0,12,1,28,81,36,14,1,
		176,37,0,106,52,76,97,32,100,101,115,99,114,105,
		112,99,105,243,110,32,100,101,108,32,99,111,109,101,
		110,116,97,114,105,111,32,110,111,32,112,117,101,100,
		101,32,101,115,116,97,114,32,118,97,99,237,97,46,
		0,20,1,36,15,1,48,73,0,95,2,112,0,73,
		36,16,1,9,110,7,36,19,1,48,40,0,95,3,
		122,112,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCOMENTARIOS_DELRECCOMENTARIO )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,25,1,9,80,2,36,27,1,48,82,
		0,48,64,0,48,32,0,102,112,0,112,0,112,0,
		121,8,28,8,36,28,1,102,110,7,36,31,1,48,
		83,0,176,84,0,12,0,112,0,31,81,176,85,0,
		106,49,191,32,68,101,115,101,97,32,101,108,105,109,
		105,110,97,114,32,100,101,102,105,110,105,116,105,118,
		97,109,101,110,116,101,32,101,115,116,101,32,114,101,
		103,105,115,116,114,111,32,63,0,106,19,67,111,110,
		102,105,114,109,101,32,115,117,112,101,114,115,105,243,
		110,0,12,2,28,22,36,32,1,48,86,0,48,64,
		0,48,32,0,102,112,0,112,0,112,0,73,36,35,
		1,48,87,0,95,1,112,0,73,36,37,1,102,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCOMENTARIOS_REINDEXA )
{
	static const HB_BYTE pcode[] =
	{
		36,47,1,176,24,0,48,25,0,102,112,0,12,1,
		28,18,36,48,1,48,41,0,102,48,26,0,102,112,
		0,112,1,73,36,51,1,48,88,0,48,25,0,102,
		112,0,112,0,73,36,53,1,48,89,0,102,120,112,
		1,28,17,36,54,1,48,90,0,48,25,0,102,112,
		0,112,0,73,36,57,1,48,36,0,102,112,0,73,
		36,59,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,93,0,2,0,116,93,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

