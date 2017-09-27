/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\Operarios.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TOPERARIOS );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TMASDET );
HB_FUNC_STATIC( TOPERARIOS_OPENFILES );
HB_FUNC_STATIC( TOPERARIOS_CLOSEFILES );
HB_FUNC_STATIC( TOPERARIOS_OPENSERVICE );
HB_FUNC_STATIC( TOPERARIOS_CLOSESERVICE );
HB_FUNC_STATIC( TOPERARIOS_DEFINEFILES );
HB_FUNC_STATIC( TOPERARIOS_RESOURCE );
HB_FUNC_STATIC( TOPERARIOS_LPRESAVE );
HB_FUNC_STATIC( TOPERARIOS_NCOSTEOPERARIO );
HB_FUNC_STATIC( TOPERARIOS_LPOSTSAVE );
HB_FUNC_STATIC( TOPERARIOS_DELRECHORA );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( TSECCION );
HB_FUNC_EXTERN( THORAS );
HB_FUNC_EXTERN( TDETHORAS );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( DBFSERVER );
HB_FUNC_EXTERN( RETFLD );
HB_FUNC_EXTERN( CDIVEMP );
HB_FUNC_EXTERN( TDIALOG );
HB_FUNC_EXTERN( LBLTITLE );
HB_FUNC_EXTERN( TBITMAP );
HB_FUNC_EXTERN( TGETHLP );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( RJUSTOBJ );
HB_FUNC_EXTERN( TSAY );
HB_FUNC_EXTERN( TBUTTON );
HB_FUNC_EXTERN( IXBROWSE );
HB_FUNC_EXTERN( TRANSFORM );
HB_FUNC_EXTERN( MSGINFO );
HB_FUNC_EXTERN( RTRIM );
HB_FUNC_EXTERN( OUSER );
HB_FUNC_EXTERN( APOLOMSGNOYES );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_OPERARIOS )
{ "TOPERARIOS", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TOPERARIOS )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TMASDET", {HB_FS_PUBLIC}, {HB_FUNCNAME( TMASDET )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TOPERARIOS_OPENFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TOPERARIOS_OPENFILES )}, NULL },
{ "TOPERARIOS_CLOSEFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TOPERARIOS_CLOSEFILES )}, NULL },
{ "TOPERARIOS_OPENSERVICE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TOPERARIOS_OPENSERVICE )}, NULL },
{ "TOPERARIOS_CLOSESERVICE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TOPERARIOS_CLOSESERVICE )}, NULL },
{ "TOPERARIOS_DEFINEFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TOPERARIOS_DEFINEFILES )}, NULL },
{ "TOPERARIOS_RESOURCE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TOPERARIOS_RESOURCE )}, NULL },
{ "TOPERARIOS_LPRESAVE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TOPERARIOS_LPRESAVE )}, NULL },
{ "TOPERARIOS_NCOSTEOPERARIO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TOPERARIOS_NCOSTEOPERARIO )}, NULL },
{ "TOPERARIOS_LPOSTSAVE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TOPERARIOS_LPOSTSAVE )}, NULL },
{ "TOPERARIOS_DELRECHORA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TOPERARIOS_DELRECHORA )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACTIVATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OSECCION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TSECCION", {HB_FS_PUBLIC}, {HB_FUNCNAME( TSECCION )}, NULL },
{ "CPATH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDRIVER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OPENFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OSECCION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OHORAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "THORAS", {HB_FS_PUBLIC}, {HB_FUNCNAME( THORAS )}, NULL },
{ "OHORAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODETHORAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDETHORAS", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDETHORAS )}, NULL },
{ "ADDDETAIL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODETHORAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OPENDETAILS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BFIRSTKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CLOSEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "CLOSEDETAILS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CLOSESERVICE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "USED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBFSERVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBFSERVER )}, NULL },
{ "ADDFIELD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDINDEX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RETFLD", {HB_FS_PUBLIC}, {HB_FUNCNAME( RETFLD )}, NULL },
{ "CCODSEC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDIVTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CDIVTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDIVEMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( CDIVEMP )}, NULL },
{ "LLOADDIVISA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDIALOG", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDIALOG )}, NULL },
{ "LBLTITLE", {HB_FS_PUBLIC}, {HB_FUNCNAME( LBLTITLE )}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBITMAP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBITMAP )}, NULL },
{ "TGETHLP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGETHLP )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "_CCODTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RJUSTOBJ", {HB_FS_PUBLIC}, {HB_FUNCNAME( RJUSTOBJ )}, NULL },
{ "CNOMTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCODSEC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BVALID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EXISTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BHELP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BUSCAR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDIRTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CDIRTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCDPTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCDPTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPOBTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CPOBTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPRVTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CPRVTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CTLFTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CTLFTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CMOVTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CMOVTRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CMEITRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CMEITRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NCOSNOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NCOSNOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPOUDIV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NCOSSSSS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NCOSSSSS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NDIAPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NDIAPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NPAGAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NPAGAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NHORDIA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NHORDIA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TSAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( TSAY )}, NULL },
{ "NCOSTEOPERARIO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( TBUTTON )}, NULL },
{ "APPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LPOSTSAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EDIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ZOOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DELRECHORA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
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
{ "LDEFHOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NWIDTH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETCHECK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODHRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TRANSFORM", {HB_FS_PUBLIC}, {HB_FUNCNAME( TRANSFORM )}, NULL },
{ "NCOSHRA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NDATASTRALIGN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NHEADSTRALIGN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEFROMRESOURCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LPRESAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGINFO", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGINFO )}, NULL },
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
{ "LULTDEF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CULTHORA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LOAD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LDEFHOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SKIP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECNO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LNOTCONFIRMDELETE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OUSER", {HB_FS_PUBLIC}, {HB_FUNCNAME( OUSER )}, NULL },
{ "APOLOMSGNOYES", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOMSGNOYES )}, NULL },
{ "DELETE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_OPERARIOS, ".\\.\\Prg\\Operarios.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_OPERARIOS
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_OPERARIOS )
   #include "hbiniseg.h"
#endif

HB_FUNC( TOPERARIOS )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,159,0,36,7,0,103,2,0,100,8,
		29,252,2,176,1,0,104,2,0,12,1,29,241,2,
		166,179,2,0,122,80,1,48,2,0,176,3,0,12,
		0,106,11,84,79,112,101,114,97,114,105,111,115,0,
		108,4,4,1,0,108,0,112,3,80,2,36,9,0,
		48,5,0,95,2,100,106,14,103,99,95,119,111,114,
		107,101,114,50,95,49,54,0,95,1,121,72,121,72,
		121,72,106,5,99,77,114,117,0,4,1,0,9,112,
		5,73,36,10,0,48,5,0,95,2,100,97,250,161,
		52,0,95,1,121,72,121,72,121,72,106,8,99,66,
		105,116,109,97,112,0,4,1,0,9,112,5,73,36,
		11,0,48,5,0,95,2,100,100,95,1,121,72,121,
		72,121,72,106,9,111,83,101,99,99,105,111,110,0,
		4,1,0,9,112,5,73,36,12,0,48,5,0,95,
		2,100,100,95,1,121,72,121,72,121,72,106,7,111,
		72,111,114,97,115,0,4,1,0,9,112,5,73,36,
		13,0,48,5,0,95,2,100,100,95,1,121,72,121,
		72,121,72,106,10,111,68,101,116,72,111,114,97,115,
		0,4,1,0,9,112,5,73,36,14,0,48,5,0,
		95,2,100,100,95,1,121,72,121,72,121,72,106,8,
		111,66,109,112,83,101,108,0,4,1,0,9,112,5,
		73,36,15,0,48,5,0,95,2,100,100,95,1,121,
		72,121,72,121,72,106,9,99,85,108,116,72,111,114,
		97,0,4,1,0,9,112,5,73,36,16,0,48,5,
		0,95,2,100,9,95,1,121,72,121,72,121,72,106,
		8,108,85,108,116,68,101,102,0,4,1,0,9,112,
		5,73,36,18,0,48,6,0,95,2,106,10,79,112,
		101,110,70,105,108,101,115,0,108,7,95,1,121,72,
		121,72,121,72,112,3,73,36,19,0,48,6,0,95,
		2,106,11,67,108,111,115,101,70,105,108,101,115,0,
		108,8,95,1,121,72,121,72,121,72,112,3,73,36,
		21,0,48,6,0,95,2,106,12,79,112,101,110,83,
		101,114,118,105,99,101,0,108,9,95,1,121,72,121,
		72,121,72,112,3,73,36,22,0,48,6,0,95,2,
		106,13,67,108,111,115,101,83,101,114,118,105,99,101,
		0,108,10,95,1,121,72,121,72,121,72,112,3,73,
		36,24,0,48,6,0,95,2,106,12,68,101,102,105,
		110,101,70,105,108,101,115,0,108,11,95,1,121,72,
		121,72,121,72,112,3,73,36,26,0,48,6,0,95,
		2,106,9,82,101,115,111,117,114,99,101,0,108,12,
		95,1,121,72,121,72,121,72,112,3,73,36,28,0,
		48,6,0,95,2,106,9,108,80,114,101,83,97,118,
		101,0,108,13,95,1,121,72,121,72,121,72,112,3,
		73,36,30,0,48,6,0,95,2,106,15,110,67,111,
		115,116,101,79,112,101,114,97,114,105,111,0,108,14,
		95,1,121,72,121,72,121,72,112,3,73,36,32,0,
		48,6,0,95,2,106,10,108,80,111,115,116,83,97,
		118,101,0,108,15,95,1,121,72,121,72,121,72,112,
		3,73,36,34,0,48,6,0,95,2,106,11,68,101,
		108,82,101,99,72,111,114,97,0,108,16,95,1,121,
		72,121,72,121,72,112,3,73,36,36,0,48,17,0,
		95,2,112,0,73,167,14,0,0,176,18,0,104,2,
		0,95,2,20,2,168,48,19,0,95,2,112,0,80,
		3,176,20,0,95,3,106,10,73,110,105,116,67,108,
		97,115,115,0,12,2,28,12,48,21,0,95,3,164,
		146,1,0,73,95,3,110,7,48,19,0,103,2,0,
		112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TOPERARIOS_OPENFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,40,0,102,80,2,36,42,0,120,80,
		3,36,45,0,95,1,100,8,28,5,9,80,1,36,
		47,0,176,22,0,89,15,0,1,0,0,0,176,23,
		0,95,1,12,1,6,12,1,80,4,36,48,0,113,
		8,1,0,36,50,0,176,24,0,48,25,0,95,2,
		112,0,12,1,28,20,36,51,0,48,26,0,95,2,
		48,27,0,95,2,112,0,112,1,73,36,54,0,48,
		28,0,48,25,0,95,2,112,0,9,95,1,68,112,
		2,73,36,56,0,48,29,0,95,2,48,17,0,176,
		30,0,12,0,48,31,0,95,2,112,0,48,32,0,
		95,2,112,0,112,2,112,1,73,36,57,0,48,33,
		0,48,34,0,95,2,112,0,112,0,73,36,59,0,
		48,35,0,95,2,48,17,0,176,36,0,12,0,48,
		31,0,95,2,112,0,48,32,0,95,2,112,0,112,
		2,112,1,73,36,60,0,48,33,0,48,37,0,95,
		2,112,0,112,0,73,36,62,0,48,38,0,95,2,
		48,2,0,176,39,0,12,0,48,31,0,95,2,112,
		0,48,32,0,95,2,112,0,95,2,112,3,112,1,
		73,36,63,0,48,40,0,95,2,48,41,0,95,2,
		112,0,112,1,73,36,65,0,48,42,0,95,2,112,
		0,73,36,67,0,48,43,0,95,2,89,22,0,0,
		0,1,0,2,0,48,44,0,48,25,0,95,255,112,
		0,112,0,6,112,1,73,114,77,0,0,36,69,0,
		115,73,36,71,0,9,80,3,36,73,0,48,45,0,
		95,2,112,0,73,36,75,0,176,46,0,106,41,73,
		109,112,111,115,105,98,108,101,32,97,98,114,105,114,
		32,116,111,100,97,115,32,108,97,115,32,98,97,115,
		101,115,32,100,101,32,100,97,116,111,115,0,20,1,
		36,79,0,176,22,0,95,4,20,1,36,81,0,95,
		3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TOPERARIOS_CLOSEFILES )
{
	static const HB_BYTE pcode[] =
	{
		36,87,0,48,47,0,102,112,0,73,36,89,0,48,
		34,0,102,112,0,100,69,28,28,36,90,0,48,48,
		0,48,34,0,102,112,0,112,0,73,36,91,0,48,
		29,0,102,100,112,1,73,36,94,0,48,37,0,102,
		112,0,100,69,28,28,36,95,0,48,48,0,48,37,
		0,102,112,0,112,0,73,36,96,0,48,35,0,102,
		100,112,1,73,36,99,0,176,24,0,48,25,0,102,
		112,0,12,1,31,17,36,100,0,48,48,0,48,25,
		0,102,112,0,112,0,73,36,103,0,48,26,0,102,
		100,112,1,73,36,105,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TOPERARIOS_OPENSERVICE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,2,36,111,0,120,80,3,36,114,0,95,1,
		100,8,28,5,9,80,1,36,115,0,95,2,100,8,
		28,10,48,31,0,102,112,0,80,2,36,117,0,176,
		22,0,89,15,0,1,0,0,0,176,23,0,95,1,
		12,1,6,12,1,80,4,36,118,0,113,61,0,0,
		36,120,0,176,24,0,48,25,0,102,112,0,12,1,
		28,20,36,121,0,48,26,0,102,48,27,0,102,95,
		2,112,1,112,1,73,36,124,0,48,28,0,48,25,
		0,102,112,0,9,95,1,68,112,2,73,114,100,0,
		0,36,126,0,115,73,36,128,0,9,80,3,36,130,
		0,48,49,0,102,112,0,73,36,132,0,176,46,0,
		106,65,73,109,112,111,115,105,98,108,101,32,97,98,
		114,105,114,32,116,111,100,97,115,32,108,97,115,32,
		98,97,115,101,115,32,100,101,32,100,97,116,111,115,
		32,100,101,32,100,101,116,97,108,108,101,32,100,101,
		32,111,112,101,114,97,114,105,111,115,0,20,1,36,
		136,0,176,22,0,95,4,20,1,36,138,0,95,3,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TOPERARIOS_CLOSESERVICE )
{
	static const HB_BYTE pcode[] =
	{
		36,144,0,48,25,0,102,112,0,100,69,28,30,48,
		50,0,48,25,0,102,112,0,112,0,28,17,36,145,
		0,48,48,0,48,25,0,102,112,0,112,0,73,36,
		148,0,48,26,0,102,100,112,1,73,36,150,0,120,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TOPERARIOS_DEFINEFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,158,0,95,1,100,8,28,10,48,31,
		0,102,112,0,80,1,36,159,0,95,2,100,8,28,
		10,48,32,0,102,112,0,80,2,36,161,0,48,2,
		0,176,51,0,106,9,79,112,101,84,46,68,98,102,
		0,106,9,79,112,101,114,97,114,105,111,0,12,2,
		106,9,79,112,101,84,46,68,98,102,0,106,9,79,
		112,101,114,97,114,105,111,0,95,2,106,10,79,112,
		101,114,97,114,105,111,115,0,95,1,112,5,80,3,
		36,163,0,48,52,0,95,3,106,8,99,67,111,100,
		84,114,97,0,106,2,67,0,92,5,121,100,100,100,
		100,106,7,67,243,100,105,103,111,0,9,92,60,9,
		4,0,0,112,13,73,36,164,0,48,52,0,95,3,
		106,8,99,78,111,109,84,114,97,0,106,2,67,0,
		92,35,121,100,100,100,100,106,7,78,111,109,98,114,
		101,0,9,93,44,1,9,4,0,0,112,13,73,36,
		165,0,48,52,0,95,3,106,8,99,67,111,100,83,
		101,99,0,106,2,67,0,92,3,121,100,100,100,100,
		106,8,83,101,99,99,105,243,110,0,9,92,60,9,
		4,0,0,112,13,73,36,166,0,48,52,0,95,3,
		106,8,99,68,105,118,84,114,97,0,106,2,67,0,
		92,3,121,100,100,100,100,106,7,68,105,118,105,115,
		97,0,9,100,120,4,0,0,112,13,73,36,167,0,
		48,52,0,95,3,106,8,99,68,105,114,84,114,97,
		0,106,2,67,0,92,50,121,100,100,100,100,106,10,
		68,111,109,105,99,105,108,105,111,0,9,100,120,4,
		0,0,112,13,73,36,168,0,48,52,0,95,3,106,
		8,99,67,100,112,84,114,97,0,106,2,67,0,92,
		7,121,100,100,100,100,106,14,67,243,100,105,103,111,
		32,112,111,115,116,97,108,0,9,100,120,4,0,0,
		112,13,73,36,169,0,48,52,0,95,3,106,8,99,
		80,111,98,84,114,97,0,106,2,67,0,92,25,121,
		100,100,100,100,106,10,80,111,98,108,97,99,105,243,
		110,0,9,100,120,4,0,0,112,13,73,36,170,0,
		48,52,0,95,3,106,8,99,80,114,118,84,114,97,
		0,106,2,67,0,92,20,121,100,100,100,100,106,10,
		80,114,111,118,105,110,99,105,97,0,9,100,120,4,
		0,0,112,13,73,36,171,0,48,52,0,95,3,106,
		8,99,84,108,102,84,114,97,0,106,2,67,0,92,
		12,121,100,100,100,100,106,9,84,101,108,233,102,111,
		110,111,0,9,100,120,4,0,0,112,13,73,36,172,
		0,48,52,0,95,3,106,8,99,77,111,118,84,114,
		97,0,106,2,67,0,92,12,121,100,100,100,100,106,
		6,77,243,118,105,108,0,9,100,120,4,0,0,112,
		13,73,36,173,0,48,52,0,95,3,106,8,110,67,
		111,115,78,111,109,0,106,2,78,0,92,16,92,6,
		100,100,100,100,106,11,78,243,109,105,110,97,32,77,
		101,115,0,9,100,120,4,0,0,112,13,73,36,174,
		0,48,52,0,95,3,106,9,110,67,111,115,83,83,
		83,83,0,106,2,78,0,92,16,92,6,100,100,100,
		100,106,16,83,101,103,46,32,83,111,99,105,97,108,
		32,77,101,115,0,9,100,120,4,0,0,112,13,73,
		36,175,0,48,52,0,95,3,106,7,110,80,97,103,
		97,115,0,106,2,78,0,92,3,121,100,100,100,100,
		106,10,80,97,103,97,115,32,65,241,111,0,9,100,
		120,4,0,0,112,13,73,36,176,0,48,52,0,95,
		3,106,8,110,68,105,97,80,114,111,0,106,2,78,
		0,92,5,121,100,100,100,100,106,18,68,105,97,115,
		32,112,114,111,100,117,99,99,116,105,118,111,115,0,
		9,100,120,4,0,0,112,13,73,36,177,0,48,52,
		0,95,3,106,8,110,72,111,114,68,105,97,0,106,
		2,78,0,92,16,92,6,100,100,100,100,106,14,72,
		111,114,97,115,32,112,111,114,32,100,237,97,0,9,
		100,120,4,0,0,112,13,73,36,178,0,48,52,0,
		95,3,106,8,99,77,101,105,84,114,97,0,106,2,
		67,0,92,65,121,100,100,100,100,106,6,69,109,97,
		105,108,0,9,100,120,4,0,0,112,13,73,36,180,
		0,48,53,0,95,3,106,8,99,67,111,100,84,114,
		97,0,106,9,79,112,101,84,46,67,100,120,0,106,
		8,99,67,111,100,84,114,97,0,100,100,9,9,106,
		7,67,243,100,105,103,111,0,100,100,120,9,112,12,
		73,36,181,0,48,53,0,95,3,106,8,99,78,111,
		109,84,114,97,0,106,9,79,112,101,84,46,67,100,
		120,0,106,8,99,78,111,109,84,114,97,0,100,100,
		9,9,106,7,78,111,109,98,114,101,0,100,100,120,
		9,112,12,73,36,182,0,48,53,0,95,3,106,8,
		99,67,111,100,83,101,99,0,106,9,79,112,101,84,
		46,67,100,120,0,106,8,99,67,111,100,83,101,99,
		0,100,100,9,9,106,8,83,101,99,99,105,243,110,
		0,100,100,120,9,112,12,73,36,186,0,95,3,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TOPERARIOS_RESOURCE )
{
	static const HB_BYTE pcode[] =
	{
		13,10,1,36,190,0,102,80,2,36,198,0,176,54,
		0,48,55,0,48,25,0,95,2,112,0,112,0,48,
		56,0,48,34,0,95,2,112,0,112,0,12,2,80,
		9,36,202,0,95,1,122,8,31,21,176,24,0,48,
		57,0,48,25,0,95,2,112,0,112,0,12,1,28,
		23,36,203,0,48,58,0,48,25,0,95,2,112,0,
		176,59,0,12,0,112,1,73,36,206,0,48,60,0,
		95,2,48,57,0,48,25,0,95,2,112,0,112,0,
		112,1,73,36,208,0,48,2,0,176,61,0,12,0,
		100,100,100,100,176,62,0,95,1,12,1,106,9,111,
		112,101,114,97,114,105,111,0,72,106,11,84,114,97,
		98,97,106,97,100,111,114,0,100,9,100,100,100,100,
		100,9,100,100,100,100,100,9,100,106,5,111,68,108,
		103,0,100,100,112,24,80,3,36,214,0,48,63,0,
		176,64,0,12,0,93,222,3,106,14,103,99,95,119,
		111,114,107,101,114,50,95,52,56,0,100,95,3,100,
		100,9,9,100,100,9,100,100,120,112,14,80,11,36,
		221,0,48,63,0,176,65,0,12,0,92,100,89,47,
		0,1,0,1,0,2,0,176,66,0,12,0,121,8,
		28,16,48,44,0,48,25,0,95,255,112,0,112,0,
		25,16,48,67,0,48,25,0,95,255,112,0,95,1,
		112,1,6,95,3,100,106,3,64,33,0,89,22,0,
		0,0,1,0,4,0,176,68,0,95,255,106,2,48,
		0,20,2,120,6,100,100,100,100,100,9,89,14,0,
		0,0,1,0,1,0,95,255,122,8,6,100,9,9,
		100,100,100,100,100,100,100,100,100,112,25,80,4,36,
		226,0,48,63,0,176,65,0,12,0,92,110,89,47,
		0,1,0,1,0,2,0,176,66,0,12,0,121,8,
		28,16,48,69,0,48,25,0,95,255,112,0,112,0,
		25,16,48,70,0,48,25,0,95,255,112,0,95,1,
		112,1,6,95,3,100,100,100,100,100,100,100,100,9,
		89,15,0,0,0,1,0,1,0,95,255,92,3,69,
		6,100,9,9,100,100,100,100,100,100,100,100,100,112,
		25,80,7,36,232,0,48,63,0,176,65,0,12,0,
		92,120,89,47,0,1,0,1,0,2,0,176,66,0,
		12,0,121,8,28,16,48,55,0,48,25,0,95,255,
		112,0,112,0,25,16,48,71,0,48,25,0,95,255,
		112,0,95,1,112,1,6,95,3,100,100,100,100,100,
		100,100,100,9,89,15,0,0,0,1,0,1,0,95,
		255,92,3,69,6,100,9,9,100,100,100,100,100,100,
		106,5,76,85,80,65,0,100,100,112,25,80,5,36,
		233,0,48,72,0,95,5,89,46,0,0,0,3,0,
		2,0,5,0,6,0,48,73,0,48,34,0,95,255,
		112,0,95,254,95,253,106,8,99,68,101,115,83,101,
		99,0,120,120,106,2,48,0,112,6,6,112,1,73,
		36,234,0,48,74,0,95,5,89,26,0,0,0,2,
		0,2,0,5,0,48,75,0,48,34,0,95,255,112,
		0,95,254,112,1,6,112,1,73,36,239,0,48,63,
		0,176,65,0,12,0,92,121,89,28,0,1,0,1,
		0,9,0,176,66,0,12,0,121,8,28,6,95,255,
		25,7,95,1,165,80,255,6,95,3,100,100,100,100,
		100,100,100,100,9,90,4,9,6,100,9,9,100,100,
		100,100,100,100,100,100,100,112,25,80,6,36,244,0,
		48,63,0,176,65,0,12,0,93,140,0,89,47,0,
		1,0,1,0,2,0,176,66,0,12,0,121,8,28,
		16,48,76,0,48,25,0,95,255,112,0,112,0,25,
		16,48,77,0,48,25,0,95,255,112,0,95,1,112,
		1,6,95,3,100,100,100,100,100,100,100,100,9,89,
		15,0,0,0,1,0,1,0,95,255,92,3,69,6,
		100,9,9,100,100,100,100,100,100,100,100,100,112,25,
		73,36,249,0,48,63,0,176,65,0,12,0,93,150,
		0,89,47,0,1,0,1,0,2,0,176,66,0,12,
		0,121,8,28,16,48,78,0,48,25,0,95,255,112,
		0,112,0,25,16,48,79,0,48,25,0,95,255,112,
		0,95,1,112,1,6,95,3,100,100,100,100,100,100,
		100,100,9,89,15,0,0,0,1,0,1,0,95,255,
		92,3,69,6,100,9,9,100,100,100,100,100,100,100,
		100,100,112,25,73,36,254,0,48,63,0,176,65,0,
		12,0,93,160,0,89,47,0,1,0,1,0,2,0,
		176,66,0,12,0,121,8,28,16,48,80,0,48,25,
		0,95,255,112,0,112,0,25,16,48,81,0,48,25,
		0,95,255,112,0,95,1,112,1,6,95,3,100,100,
		100,100,100,100,100,100,9,89,15,0,0,0,1,0,
		1,0,95,255,92,3,69,6,100,9,9,100,100,100,
		100,100,100,100,100,100,112,25,73,36,3,1,48,63,
		0,176,65,0,12,0,93,170,0,89,47,0,1,0,
		1,0,2,0,176,66,0,12,0,121,8,28,16,48,
		82,0,48,25,0,95,255,112,0,112,0,25,16,48,
		83,0,48,25,0,95,255,112,0,95,1,112,1,6,
		95,3,100,100,100,100,100,100,100,100,9,89,15,0,
		0,0,1,0,1,0,95,255,92,3,69,6,100,9,
		9,100,100,100,100,100,100,100,100,100,112,25,73,36,
		8,1,48,63,0,176,65,0,12,0,93,180,0,89,
		47,0,1,0,1,0,2,0,176,66,0,12,0,121,
		8,28,16,48,84,0,48,25,0,95,255,112,0,112,
		0,25,16,48,85,0,48,25,0,95,255,112,0,95,
		1,112,1,6,95,3,100,100,100,100,100,100,100,100,
		9,89,15,0,0,0,1,0,1,0,95,255,92,3,
		69,6,100,9,9,100,100,100,100,100,100,100,100,100,
		112,25,73,36,13,1,48,63,0,176,65,0,12,0,
		93,190,0,89,47,0,1,0,1,0,2,0,176,66,
		0,12,0,121,8,28,16,48,86,0,48,25,0,95,
		255,112,0,112,0,25,16,48,87,0,48,25,0,95,
		255,112,0,95,1,112,1,6,95,3,100,100,100,100,
		100,100,100,100,9,89,15,0,0,0,1,0,1,0,
		95,255,92,3,69,6,100,9,9,100,100,100,100,100,
		100,100,100,100,112,25,73,36,18,1,48,63,0,176,
		65,0,12,0,93,4,1,89,47,0,1,0,1,0,
		2,0,176,66,0,12,0,121,8,28,16,48,88,0,
		48,25,0,95,255,112,0,112,0,25,16,48,89,0,
		48,25,0,95,255,112,0,95,1,112,1,6,95,3,
		100,100,100,100,100,100,100,100,9,89,15,0,0,0,
		1,0,1,0,95,255,92,3,69,6,100,9,9,100,
		100,100,100,100,100,100,100,100,112,25,73,36,29,1,
		48,63,0,176,65,0,12,0,93,200,0,89,47,0,
		1,0,1,0,2,0,176,66,0,12,0,121,8,28,
		16,48,90,0,48,25,0,95,255,112,0,112,0,25,
		16,48,91,0,48,25,0,95,255,112,0,95,1,112,
		1,6,95,3,100,48,92,0,95,2,112,0,89,19,
		0,0,0,1,0,10,0,48,93,0,95,255,112,0,
		73,120,6,100,100,100,100,100,9,89,15,0,0,0,
		1,0,1,0,95,255,92,3,69,6,100,9,9,100,
		100,100,100,100,100,100,100,100,112,25,73,36,36,1,
		48,63,0,176,65,0,12,0,93,210,0,89,47,0,
		1,0,1,0,2,0,176,66,0,12,0,121,8,28,
		16,48,94,0,48,25,0,95,255,112,0,112,0,25,
		16,48,95,0,48,25,0,95,255,112,0,95,1,112,
		1,6,95,3,100,48,92,0,95,2,112,0,89,19,
		0,0,0,1,0,10,0,48,93,0,95,255,112,0,
		73,120,6,100,100,100,100,100,9,89,15,0,0,0,
		1,0,1,0,95,255,92,3,69,6,100,9,9,100,
		100,100,100,100,100,100,100,100,112,25,73,36,46,1,
		48,63,0,176,65,0,12,0,93,220,0,89,47,0,
		1,0,1,0,2,0,176,66,0,12,0,121,8,28,
		16,48,96,0,48,25,0,95,255,112,0,112,0,25,
		16,48,97,0,48,25,0,95,255,112,0,95,1,112,
		1,6,95,3,100,106,4,57,57,57,0,89,19,0,
		0,0,1,0,10,0,48,93,0,95,255,112,0,73,
		120,6,100,100,100,100,100,9,89,15,0,0,0,1,
		0,1,0,95,255,92,3,69,6,100,9,120,100,100,
		90,4,121,6,90,6,93,109,1,6,100,100,100,100,
		100,112,25,73,36,56,1,48,63,0,176,65,0,12,
		0,93,230,0,89,47,0,1,0,1,0,2,0,176,
		66,0,12,0,121,8,28,16,48,98,0,48,25,0,
		95,255,112,0,112,0,25,16,48,99,0,48,25,0,
		95,255,112,0,95,1,112,1,6,95,3,100,106,3,
		57,57,0,89,19,0,0,0,1,0,10,0,48,93,
		0,95,255,112,0,73,120,6,100,100,100,100,100,9,
		89,15,0,0,0,1,0,1,0,95,255,92,3,69,
		6,100,9,120,100,100,90,4,121,6,90,5,92,99,
		6,100,100,100,100,100,112,25,73,36,66,1,48,63,
		0,176,65,0,12,0,93,240,0,89,47,0,1,0,
		1,0,2,0,176,66,0,12,0,121,8,28,16,48,
		100,0,48,25,0,95,255,112,0,112,0,25,16,48,
		101,0,48,25,0,95,255,112,0,95,1,112,1,6,
		95,3,100,106,3,57,57,0,89,19,0,0,0,1,
		0,10,0,48,93,0,95,255,112,0,73,120,6,100,
		100,100,100,100,9,89,15,0,0,0,1,0,1,0,
		95,255,92,3,69,6,100,9,120,100,100,90,4,121,
		6,90,5,92,24,6,100,100,100,100,100,112,25,73,
		36,72,1,48,63,0,176,102,0,12,0,93,250,0,
		89,17,0,0,0,1,0,2,0,48,103,0,95,255,
		112,0,6,95,3,48,92,0,95,2,112,0,106,5,
		78,47,87,42,0,100,9,100,9,9,100,112,11,80,
		10,36,82,1,48,63,0,176,104,0,12,0,93,244,
		1,89,36,0,0,0,2,0,2,0,8,0,48,105,
		0,48,41,0,95,255,112,0,95,254,112,1,73,48,
		106,0,95,255,95,254,112,1,6,95,3,100,100,9,
		89,15,0,0,0,1,0,1,0,95,255,92,3,69,
		6,100,100,9,112,10,73,36,88,1,48,63,0,176,
		104,0,12,0,93,245,1,89,36,0,0,0,2,0,
		2,0,8,0,48,107,0,48,41,0,95,255,112,0,
		95,254,112,1,73,48,106,0,95,255,95,254,112,1,
		6,95,3,100,100,9,89,15,0,0,0,1,0,1,
		0,95,255,92,3,69,6,100,100,9,112,10,73,36,
		93,1,48,63,0,176,104,0,12,0,93,246,1,89,
		22,0,0,0,1,0,2,0,48,108,0,48,41,0,
		95,255,112,0,112,0,6,95,3,100,100,9,100,100,
		100,9,112,10,73,36,99,1,48,63,0,176,104,0,
		12,0,93,247,1,89,21,0,0,0,2,0,2,0,
		8,0,48,109,0,95,255,95,254,112,1,6,95,3,
		100,100,9,89,15,0,0,0,1,0,1,0,95,255,
		92,3,69,6,100,100,9,112,10,73,36,101,1,48,
		2,0,176,110,0,12,0,95,3,112,1,80,8,36,
		103,1,48,111,0,95,8,90,12,121,97,229,229,229,
		0,4,2,0,6,112,1,73,36,104,1,48,112,0,
		95,8,90,12,121,97,167,205,240,0,4,2,0,6,
		112,1,73,36,106,1,48,113,0,95,8,92,5,112,
		1,73,36,108,1,48,114,0,95,8,89,36,0,0,
		0,2,0,2,0,8,0,48,107,0,48,41,0,95,
		255,112,0,95,254,112,1,73,48,106,0,95,255,95,
		254,112,1,6,112,1,73,36,110,1,48,115,0,48,
		116,0,48,41,0,95,2,112,0,112,0,95,8,112,
		1,73,36,112,1,48,117,0,95,8,112,0,143,36,
		113,1,144,118,0,106,8,68,101,102,101,99,116,111,
		0,112,1,73,36,114,1,144,119,0,89,27,0,0,
		0,1,0,2,0,48,120,0,48,116,0,48,41,0,
		95,255,112,0,112,0,112,0,6,112,1,73,36,115,
		1,144,121,0,92,65,112,1,73,36,116,1,144,122,
		0,106,6,83,101,108,49,54,0,106,6,78,105,108,
		49,54,0,4,2,0,112,1,73,145,36,119,1,48,
		117,0,95,8,112,0,143,36,120,1,144,118,0,106,
		7,67,243,100,105,103,111,0,112,1,73,36,121,1,
		144,119,0,89,27,0,0,0,1,0,2,0,48,123,
		0,48,116,0,48,41,0,95,255,112,0,112,0,112,
		0,6,112,1,73,36,122,1,144,121,0,92,65,112,
		1,73,145,36,125,1,48,117,0,95,8,112,0,143,
		36,126,1,144,118,0,106,13,84,105,112,111,32,100,
		101,32,104,111,114,97,0,112,1,73,36,127,1,144,
		119,0,89,59,0,0,0,1,0,2,0,176,54,0,
		48,123,0,48,116,0,48,41,0,95,255,112,0,112,
		0,112,0,48,124,0,48,25,0,48,37,0,95,255,
		112,0,112,0,112,0,106,8,99,68,101,115,72,114,
		97,0,12,3,6,112,1,73,36,128,1,144,121,0,
		93,229,1,112,1,73,145,36,131,1,48,117,0,95,
		8,112,0,143,36,132,1,144,118,0,106,7,80,114,
		101,99,105,111,0,112,1,73,36,133,1,144,119,0,
		89,39,0,0,0,1,0,2,0,176,125,0,48,126,
		0,48,116,0,48,41,0,95,255,112,0,112,0,112,
		0,48,92,0,95,255,112,0,12,2,6,112,1,73,
		36,134,1,144,121,0,92,90,112,1,73,36,135,1,
		144,127,0,122,112,1,73,36,136,1,144,128,0,122,
		112,1,73,145,36,139,1,48,129,0,95,8,93,144,
		1,112,1,73,36,145,1,48,63,0,176,104,0,12,
		0,122,89,37,0,0,0,6,0,2,0,4,0,7,
		0,5,0,3,0,1,0,48,130,0,95,255,95,254,
		95,253,95,252,95,251,95,250,112,5,6,95,3,100,
		100,9,89,15,0,0,0,1,0,1,0,95,255,92,
		3,69,6,100,100,9,112,10,73,36,151,1,48,63,
		0,176,104,0,12,0,92,2,89,17,0,0,0,1,
		0,3,0,48,48,0,95,255,112,0,6,95,3,100,
		100,9,100,100,100,120,112,10,73,36,157,1,48,63,
		0,176,104,0,12,0,93,47,2,90,28,176,131,0,
		106,18,65,121,117,100,97,32,110,111,32,100,101,102,
		105,110,105,100,97,0,12,1,6,95,3,100,100,9,
		100,100,100,120,112,10,73,36,159,1,95,1,92,3,
		69,29,170,0,36,160,1,48,132,0,95,3,92,113,
		89,26,0,0,0,2,0,2,0,8,0,48,105,0,
		48,41,0,95,255,112,0,95,254,112,1,6,112,2,
		73,36,161,1,48,132,0,95,3,92,114,89,26,0,
		0,0,2,0,2,0,8,0,48,107,0,48,41,0,
		95,255,112,0,95,254,112,1,6,112,2,73,36,162,
		1,48,132,0,95,3,92,115,89,26,0,0,0,2,
		0,2,0,8,0,48,133,0,48,41,0,95,255,112,
		0,95,254,112,1,6,112,2,73,36,163,1,48,132,
		0,95,3,92,116,89,37,0,0,0,6,0,2,0,
		4,0,7,0,5,0,3,0,1,0,48,130,0,95,
		255,95,254,95,253,95,252,95,251,95,250,112,5,6,
		112,2,73,36,166,1,48,134,0,95,3,89,17,0,
		0,0,1,0,4,0,48,135,0,95,255,112,0,6,
		112,1,73,36,168,1,48,28,0,95,3,48,136,0,
		95,3,112,0,48,137,0,95,3,112,0,48,138,0,
		95,3,112,0,120,100,100,100,48,139,0,95,3,112,
		0,100,100,100,112,11,73,36,170,1,48,48,0,95,
		11,112,0,73,36,172,1,48,140,0,95,3,112,0,
		122,8,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TOPERARIOS_LPRESAVE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,5,36,178,1,95,5,122,8,31,10,95,5,
		92,4,8,29,195,0,36,180,1,48,141,0,95,1,
		112,0,73,36,182,1,48,142,0,48,25,0,102,112,
		0,48,44,0,48,25,0,102,112,0,112,0,106,8,
		67,67,79,68,84,82,65,0,112,2,28,53,36,183,
		1,176,46,0,106,18,67,243,100,105,103,111,32,121,
		97,32,101,120,105,115,116,101,32,0,176,143,0,48,
		44,0,48,25,0,102,112,0,112,0,12,1,72,20,
		1,36,184,1,9,110,7,36,187,1,176,24,0,48,
		44,0,48,25,0,102,112,0,112,0,12,1,28,74,
		36,188,1,176,46,0,106,45,69,108,32,99,243,100,
		105,103,111,32,100,101,108,32,111,112,101,114,97,114,
		105,111,32,110,111,32,112,117,101,100,101,32,101,115,
		116,97,114,32,118,97,99,237,111,46,0,20,1,36,
		189,1,48,135,0,95,1,112,0,73,36,190,1,9,
		110,7,36,195,1,176,24,0,48,69,0,48,25,0,
		102,112,0,112,0,12,1,28,79,36,196,1,176,46,
		0,106,50,76,97,32,100,101,115,99,114,105,112,99,
		105,243,110,32,100,101,108,32,111,112,101,114,97,114,
		105,111,32,110,111,32,112,117,101,100,101,32,101,115,
		116,97,114,32,118,97,99,237,111,46,0,20,1,36,
		197,1,48,135,0,95,2,112,0,73,36,198,1,9,
		110,7,36,201,1,48,48,0,95,4,122,112,1,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TOPERARIOS_NCOSTEOPERARIO )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,207,1,121,80,1,36,209,1,48,90,
		0,48,25,0,102,112,0,112,0,48,94,0,48,25,
		0,102,112,0,112,0,72,48,98,0,48,25,0,102,
		112,0,112,0,65,80,1,36,211,1,96,1,0,48,
		96,0,48,25,0,102,112,0,112,0,138,36,213,1,
		96,1,0,48,100,0,48,25,0,102,112,0,112,0,
		138,36,215,1,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TOPERARIOS_LPOSTSAVE )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,221,1,48,144,0,102,112,0,29,156,
		0,36,223,1,48,145,0,48,116,0,48,41,0,102,
		112,0,112,0,112,0,73,36,225,1,48,146,0,48,
		116,0,48,41,0,102,112,0,112,0,112,0,31,114,
		36,227,1,48,123,0,48,116,0,48,41,0,102,112,
		0,112,0,112,0,48,147,0,102,112,0,69,28,63,
		36,229,1,48,148,0,48,116,0,48,41,0,102,112,
		0,112,0,112,0,73,36,230,1,48,149,0,48,116,
		0,48,41,0,102,112,0,112,0,9,112,1,73,36,
		231,1,48,150,0,48,116,0,48,41,0,102,112,0,
		112,0,112,0,73,36,235,1,48,151,0,48,116,0,
		48,41,0,102,112,0,112,0,112,0,73,26,126,255,
		36,241,1,48,145,0,48,116,0,48,41,0,102,112,
		0,112,0,112,0,73,36,243,1,48,93,0,95,1,
		112,0,73,36,245,1,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TOPERARIOS_DELRECHORA )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,251,1,9,80,2,36,253,1,48,152,
		0,48,116,0,48,41,0,102,112,0,112,0,112,0,
		121,8,28,8,36,254,1,102,110,7,36,1,2,48,
		153,0,176,154,0,12,0,112,0,31,81,176,155,0,
		106,49,191,32,68,101,115,101,97,32,101,108,105,109,
		105,110,97,114,32,100,101,102,105,110,105,116,105,118,
		97,109,101,110,116,101,32,101,115,116,101,32,114,101,
		103,105,115,116,114,111,32,63,0,106,19,67,111,110,
		102,105,114,109,101,32,115,117,112,101,114,115,105,243,
		110,0,12,2,28,49,36,3,2,48,120,0,48,116,
		0,48,41,0,102,112,0,112,0,112,0,28,8,36,
		4,2,120,80,2,36,7,2,48,156,0,48,116,0,
		48,41,0,102,112,0,112,0,112,0,73,36,11,2,
		95,2,28,104,36,13,2,48,145,0,48,116,0,48,
		41,0,102,112,0,112,0,112,0,73,36,15,2,48,
		146,0,48,116,0,48,41,0,102,112,0,112,0,112,
		0,31,63,36,16,2,48,148,0,48,116,0,48,41,
		0,102,112,0,112,0,112,0,73,36,17,2,48,149,
		0,48,116,0,48,41,0,102,112,0,112,0,120,112,
		1,73,36,18,2,48,150,0,48,116,0,48,41,0,
		102,112,0,112,0,112,0,73,36,23,2,48,93,0,
		95,1,112,0,73,36,25,2,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,159,0,2,0,116,159,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

