/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\Tdbarray.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TDBVIRTUAL );
HB_FUNC_EXTERN( UPPER );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( ALIAS );
HB_FUNC_EXTERN( XAREA );
HB_FUNC_EXTERN( ASCAN );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( AADD );
HB_FUNC_EXTERN( __CLSINST );
HB_FUNC_STATIC( GENDATA );
HB_FUNC_EXTERN( __CLSADDMSG );
HB_FUNC( TDBARRAY );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBOBJECT );
HB_FUNC_STATIC( TDBARRAY_NEW );
HB_FUNC_STATIC( TDBARRAY_DEFNEW );
HB_FUNC_STATIC( TDBARRAY_ADDFIELD );
HB_FUNC_STATIC( TDBARRAY_ACTIVATE );
HB_FUNC_STATIC( TDBARRAY_APPEND );
HB_FUNC_STATIC( TDBARRAY_UPDATE );
HB_FUNC_STATIC( TDBARRAY__DELETE );
HB_FUNC_STATIC( TDBARRAY__ZAP );
HB_FUNC_STATIC( TDBARRAY_GOTO );
HB_FUNC_STATIC( TDBARRAY_SKIP );
HB_FUNC_STATIC( TDBARRAY_SKIPPER );
HB_FUNC_EXTERN( LEN );
HB_FUNC_EXTERN( AEVAL );
HB_FUNC_STATIC( TDBARRAY_SETBROWSE );
HB_FUNC_STATIC( TDBARRAY_LOAD );
HB_FUNC_STATIC( TDBARRAY_RECLOAD );
HB_FUNC_STATIC( TDBARRAY_SAVE );
HB_FUNC_STATIC( TDBARRAY_RECSAVE );
HB_FUNC_STATIC( TDBARRAY_FIELDPOS );
HB_FUNC_STATIC( TDBARRAY_DBCORE );
HB_FUNC_STATIC( TDBARRAY_DESTROY );
HB_FUNC_STATIC( TDBARRAY_LOADARRAY );
HB_FUNC_STATIC( TDBARRAY_SEEK );
HB_FUNC_STATIC( TDBARRAY_GETSTATUS );
HB_FUNC_STATIC( TDBARRAY_SETSTATUS );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( VALTYPE );
HB_FUNC_EXTERN( OCLONE );
HB_FUNC_EXTERN( ARRAY );
HB_FUNC_EXTERN( SPACE );
HB_FUNC_EXTERN( REPLICATE );
HB_FUNC_EXTERN( STUFF );
HB_FUNC_EXTERN( VAL );
HB_FUNC_EXTERN( ATYPE );
HB_FUNC_EXTERN( ADEL );
HB_FUNC_EXTERN( ASIZE );
HB_FUNC_EXTERN( ACLONE );
HB_FUNC_EXTERN( MIN );
HB_FUNC_EXTERN( MAX );
HB_FUNC_EXTERN( DBAPPEND );
HB_FUNC_EXTERN( FIELDPUT );
HB_FUNC_EXTERN( DBSKIP );
HB_FUNC_EXTERN( EOF );
HB_FUNC_EXTERN( DBCREATE );
HB_FUNC_EXTERN( DBUSEAREA );
HB_FUNC_EXTERN( SELECT );
HB_FUNC_EXTERN( SUBSTR );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TDBARRAY )
{ "TDBVIRTUAL", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TDBVIRTUAL )}, NULL },
{ "UPPER", {HB_FS_PUBLIC}, {HB_FUNCNAME( UPPER )}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "ALIAS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALIAS )}, NULL },
{ "XAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( XAREA )}, NULL },
{ "ASCAN", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASCAN )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( AADD )}, NULL },
{ "__CLSINST", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSINST )}, NULL },
{ "GENDATA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( GENDATA )}, NULL },
{ "CLASSH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSADDMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSADDMSG )}, NULL },
{ "ARECORDS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECNO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDBARRAY", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "HBOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBOBJECT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDBARRAY_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_NEW )}, NULL },
{ "TDBARRAY_DEFNEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_DEFNEW )}, NULL },
{ "TDBARRAY_ADDFIELD", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_ADDFIELD )}, NULL },
{ "TDBARRAY_ACTIVATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_ACTIVATE )}, NULL },
{ "TDBARRAY_APPEND", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_APPEND )}, NULL },
{ "TDBARRAY_UPDATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_UPDATE )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "UPDATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDBARRAY__DELETE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY__DELETE )}, NULL },
{ "TDBARRAY__ZAP", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY__ZAP )}, NULL },
{ "TDBARRAY_GOTO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_GOTO )}, NULL },
{ "GOTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LASTREC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDBARRAY_SKIP", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_SKIP )}, NULL },
{ "TDBARRAY_SKIPPER", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_SKIPPER )}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "AEVAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( AEVAL )}, NULL },
{ "TDBARRAY_SETBROWSE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_SETBROWSE )}, NULL },
{ "TDBARRAY_LOAD", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_LOAD )}, NULL },
{ "TDBARRAY_RECLOAD", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_RECLOAD )}, NULL },
{ "TDBARRAY_SAVE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_SAVE )}, NULL },
{ "TDBARRAY_RECSAVE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_RECSAVE )}, NULL },
{ "_ARECORDS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NRECINI", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ABLANK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDBARRAY_FIELDPOS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_FIELDPOS )}, NULL },
{ "AFIELDS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDBARRAY_DBCORE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_DBCORE )}, NULL },
{ "ADDVIRTUAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDBARRAY_DESTROY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_DESTROY )}, NULL },
{ "TDBARRAY_LOADARRAY", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_LOADARRAY )}, NULL },
{ "TDBARRAY_SEEK", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_SEEK )}, NULL },
{ "TDBARRAY_GETSTATUS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_GETSTATUS )}, NULL },
{ "TDBARRAY_SETSTATUS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TDBARRAY_SETSTATUS )}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VALTYPE", {HB_FS_PUBLIC}, {HB_FUNCNAME( VALTYPE )}, NULL },
{ "OCLONE", {HB_FS_PUBLIC}, {HB_FUNCNAME( OCLONE )}, NULL },
{ "_EOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_RECNO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NRECINI", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCOMMENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ABLANK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_AFIELDS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "USED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ATFIELD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ARRAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( ARRAY )}, NULL },
{ "GETVAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CNAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CTYPE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_FCOUNT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LASTREC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_USED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FIELDTYPE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SPACE", {HB_FS_PUBLIC}, {HB_FUNCNAME( SPACE )}, NULL },
{ "FIELDLEN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REPLICATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( REPLICATE )}, NULL },
{ "FIELDDEC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "STUFF", {HB_FS_PUBLIC}, {HB_FUNCNAME( STUFF )}, NULL },
{ "VAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( VAL )}, NULL },
{ "FIELDNAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ATYPE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ATYPE )}, NULL },
{ "ADEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADEL )}, NULL },
{ "ASIZE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASIZE )}, NULL },
{ "GOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DELETE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SKIP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACLONE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ACLONE )}, NULL },
{ "GOBOTTOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MIN", {HB_FS_PUBLIC}, {HB_FUNCNAME( MIN )}, NULL },
{ "MAX", {HB_FS_PUBLIC}, {HB_FUNCNAME( MAX )}, NULL },
{ "CLASSNAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_GOTOPBLOCK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_GOBOTTOMBLOCK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_SKIPBLOCK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SKIPPER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BGOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BGOBOTTOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BSKIP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BLOGICLEN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REFRESH", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FCOUNT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SYNCRONIZE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECCOUNT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NAREA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBAPPEND", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBAPPEND )}, NULL },
{ "FIELDPUT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FIELDPUT )}, NULL },
{ "FIELDGET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBSKIP", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBSKIP )}, NULL },
{ "EOF", {HB_FS_PUBLIC}, {HB_FUNCNAME( EOF )}, NULL },
{ "LOAD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LCALCULATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FLDPUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBCREATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBCREATE )}, NULL },
{ "DBUSEAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBUSEAREA )}, NULL },
{ "_NAREA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SELECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( SELECT )}, NULL },
{ "SUBSTR", {HB_FS_PUBLIC}, {HB_FUNCNAME( SUBSTR )}, NULL },
{ "_ASTATUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ASTATUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00003)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TDBARRAY, ".\\.\\Prg\\Tdbarray.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TDBARRAY
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TDBARRAY )
   #include "hbiniseg.h"
#endif

HB_FUNC( TDBVIRTUAL )
{
	static const HB_BYTE pcode[] =
	{
		13,4,2,116,135,0,36,31,0,121,80,3,36,32,
		0,121,80,4,36,36,0,106,2,84,0,176,1,0,
		176,2,0,95,2,12,1,28,16,176,3,0,176,4,
		0,95,1,12,1,12,1,25,4,95,2,12,1,72,
		80,6,36,38,0,176,5,0,103,2,0,89,17,0,
		1,0,1,0,6,0,95,1,122,1,95,255,8,6,
		12,2,165,80,3,121,8,28,77,36,40,0,48,6,
		0,176,7,0,12,0,95,6,106,9,84,68,66,65,
		82,82,65,89,0,4,1,0,112,2,80,5,36,41,
		0,48,8,0,95,5,112,0,73,36,42,0,48,9,
		0,95,5,112,0,80,4,36,43,0,176,10,0,103,
		2,0,95,6,95,4,122,4,3,0,20,2,25,29,
		36,45,0,103,2,0,95,3,1,92,3,148,170,36,
		46,0,103,2,0,95,3,1,92,2,1,80,4,36,
		48,0,176,11,0,95,4,20,1,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( GENDATA )
{
	static const HB_BYTE pcode[] =
	{
		13,1,4,36,56,0,48,13,0,95,1,112,0,80,
		5,36,59,0,176,14,0,95,5,95,2,89,28,0,
		1,0,1,0,3,0,48,15,0,95,1,112,0,48,
		16,0,95,1,112,0,1,95,255,1,6,92,3,20,
		4,36,61,0,176,14,0,95,5,106,2,95,0,95,
		2,72,89,31,0,2,0,1,0,3,0,95,2,165,
		48,15,0,95,1,112,0,48,16,0,95,1,112,0,
		1,95,255,2,6,92,3,20,4,36,63,0,95,1,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( TDBARRAY )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,135,0,36,99,0,103,3,0,100,8,
		29,149,7,176,18,0,104,3,0,12,1,29,138,7,
		166,76,7,0,122,80,1,48,6,0,176,7,0,12,
		0,106,9,84,68,98,65,114,114,97,121,0,108,19,
		4,1,0,108,17,112,3,80,2,36,101,0,48,20,
		0,95,2,100,100,95,1,121,72,121,72,121,72,106,
		5,111,68,98,102,0,4,1,0,9,112,5,73,36,
		103,0,48,20,0,95,2,100,100,95,1,121,72,121,
		72,121,72,106,8,98,70,105,108,116,101,114,0,4,
		1,0,9,112,5,73,36,108,0,48,20,0,95,2,
		106,6,65,82,82,65,89,0,100,95,1,121,72,121,
		72,121,72,106,8,97,70,105,101,108,100,115,0,106,
		9,97,82,101,99,111,114,100,115,0,106,7,97,66,
		108,97,110,107,0,106,8,97,83,116,97,116,117,115,
		0,4,4,0,9,112,5,73,36,112,0,48,20,0,
		95,2,106,8,76,79,71,73,67,65,76,0,100,95,
		1,121,72,121,72,121,72,106,4,69,111,102,0,106,
		4,66,111,102,0,106,5,85,115,101,100,0,4,3,
		0,9,112,5,73,36,115,0,48,20,0,95,2,100,
		100,95,1,121,72,121,72,121,72,106,7,99,65,108,
		105,97,115,0,106,9,99,67,111,109,109,101,110,116,
		0,4,2,0,9,112,5,73,36,120,0,48,20,0,
		95,2,106,8,78,85,77,69,82,73,67,0,100,95,
		1,121,72,121,72,121,72,106,8,110,82,101,99,73,
		110,105,0,106,6,82,101,99,78,111,0,106,8,76,
		97,115,116,82,101,99,0,106,7,70,67,111,117,110,
		116,0,4,4,0,9,112,5,73,36,122,0,48,21,
		0,95,2,106,4,78,101,119,0,108,22,95,1,92,
		8,72,121,72,121,72,112,3,73,36,124,0,48,21,
		0,95,2,106,7,68,101,102,78,101,119,0,108,23,
		95,1,92,8,72,121,72,121,72,112,3,73,36,125,
		0,48,21,0,95,2,106,9,65,100,100,70,105,101,
		108,100,0,108,24,95,1,121,72,121,72,121,72,112,
		3,73,36,126,0,48,21,0,95,2,106,9,65,99,
		116,105,118,97,116,101,0,108,25,95,1,121,72,121,
		72,121,72,112,3,73,36,128,0,48,21,0,95,2,
		106,7,65,112,112,101,110,100,0,108,26,95,1,121,
		72,121,72,121,72,112,3,73,36,129,0,48,21,0,
		95,2,106,7,85,112,100,97,116,101,0,108,27,95,
		1,121,72,121,72,121,72,112,3,73,36,130,0,48,
		28,0,95,2,106,7,73,110,115,101,114,116,0,89,
		22,0,2,0,0,0,48,29,0,48,30,0,95,1,
		112,0,95,2,112,1,6,95,1,121,72,121,72,121,
		72,112,3,73,36,132,0,48,21,0,95,2,106,7,
		68,101,108,101,116,101,0,108,31,95,1,121,72,121,
		72,121,72,112,3,73,36,133,0,48,21,0,95,2,
		106,4,90,97,112,0,108,32,95,1,121,72,121,72,
		121,72,112,3,73,36,135,0,48,21,0,95,2,106,
		5,71,111,84,111,0,108,33,95,1,121,72,121,72,
		121,72,112,3,73,36,136,0,48,28,0,95,2,106,
		6,71,111,84,111,112,0,89,19,0,1,0,0,0,
		48,34,0,95,1,122,112,1,73,95,1,6,95,1,
		121,72,121,72,121,72,112,3,73,36,137,0,48,28,
		0,95,2,106,9,71,111,66,111,116,116,111,109,0,
		89,25,0,1,0,0,0,48,34,0,95,1,48,35,
		0,95,1,112,0,112,1,73,95,1,6,95,1,121,
		72,121,72,121,72,112,3,73,36,139,0,48,21,0,
		95,2,106,5,83,107,105,112,0,108,36,95,1,121,
		72,121,72,121,72,112,3,73,36,140,0,48,21,0,
		95,2,106,8,83,107,105,112,112,101,114,0,108,37,
		95,1,121,72,121,72,121,72,112,3,73,36,142,0,
		48,28,0,95,2,106,7,82,101,99,111,114,100,0,
		89,23,0,1,0,0,0,48,15,0,95,1,112,0,
		48,16,0,95,1,112,0,1,6,95,1,121,72,121,
		72,121,72,112,3,73,36,143,0,48,28,0,95,2,
		106,9,82,101,99,67,111,117,110,116,0,89,20,0,
		1,0,0,0,176,38,0,48,15,0,95,1,112,0,
		12,1,6,95,1,121,72,121,72,121,72,112,3,73,
		36,145,0,48,28,0,95,2,106,5,69,118,97,108,
		0,89,22,0,2,0,0,0,176,39,0,48,15,0,
		95,1,112,0,95,2,12,2,6,95,1,121,72,121,
		72,121,72,112,3,73,36,146,0,48,21,0,95,2,
		106,10,83,101,116,66,114,111,119,115,101,0,108,40,
		95,1,121,72,121,72,121,72,112,3,73,36,148,0,
		48,21,0,95,2,106,5,76,111,97,100,0,108,41,
		95,1,121,72,121,72,121,72,112,3,73,36,149,0,
		48,21,0,95,2,106,8,82,101,99,76,111,97,100,
		0,108,42,95,1,121,72,121,72,121,72,112,3,73,
		36,151,0,48,21,0,95,2,106,5,83,97,118,101,
		0,108,43,95,1,121,72,121,72,121,72,112,3,73,
		36,152,0,48,21,0,95,2,106,8,82,101,99,83,
		97,118,101,0,108,44,95,1,121,72,121,72,121,72,
		112,3,73,36,154,0,48,28,0,95,2,106,6,67,
		108,101,97,110,0,89,18,0,1,0,0,0,48,45,
		0,95,1,4,0,0,112,1,6,95,1,121,72,121,
		72,121,72,112,3,73,36,156,0,48,28,0,95,2,
		106,11,83,121,110,99,114,111,110,105,122,101,0,89,
		30,0,1,0,0,0,48,34,0,48,46,0,95,1,
		112,0,48,47,0,95,1,112,0,112,1,73,95,1,
		6,95,1,121,72,121,72,121,72,112,3,73,36,158,
		0,48,28,0,95,2,106,9,70,105,101,108,100,71,
		101,116,0,89,49,0,2,0,0,0,48,16,0,95,
		1,112,0,121,8,28,14,48,48,0,95,1,112,0,
		95,2,1,25,20,48,15,0,95,1,112,0,48,16,
		0,95,1,112,0,1,95,2,1,6,95,1,121,72,
		121,72,121,72,112,3,73,36,159,0,48,28,0,95,
		2,106,9,70,105,101,108,100,80,117,116,0,89,29,
		0,3,0,0,0,95,3,165,48,15,0,95,1,112,
		0,48,16,0,95,1,112,0,1,95,2,2,6,95,
		1,121,72,121,72,121,72,112,3,73,36,160,0,48,
		21,0,95,2,106,9,70,105,101,108,100,80,111,115,
		0,108,49,95,1,121,72,121,72,121,72,112,3,73,
		36,162,0,48,28,0,95,2,106,10,70,105,101,108,
		100,78,97,109,101,0,89,20,0,2,0,0,0,48,
		50,0,95,1,112,0,95,2,1,122,1,6,95,1,
		121,72,121,72,121,72,112,3,73,36,163,0,48,28,
		0,95,2,106,10,70,105,101,108,100,84,121,112,101,
		0,89,21,0,2,0,0,0,48,50,0,95,1,112,
		0,95,2,1,92,2,1,6,95,1,121,72,121,72,
		121,72,112,3,73,36,164,0,48,28,0,95,2,106,
		9,70,105,101,108,100,76,101,110,0,89,21,0,2,
		0,0,0,48,50,0,95,1,112,0,95,2,1,92,
		3,1,6,95,1,121,72,121,72,121,72,112,3,73,
		36,165,0,48,28,0,95,2,106,9,70,105,101,108,
		100,68,101,99,0,89,21,0,2,0,0,0,48,50,
		0,95,1,112,0,95,2,1,92,4,1,6,95,1,
		121,72,121,72,121,72,112,3,73,36,167,0,48,21,
		0,95,2,106,7,68,98,67,111,114,101,0,108,51,
		95,1,121,72,121,72,121,72,112,3,73,36,169,0,
		48,52,0,95,2,106,6,67,108,111,110,101,0,112,
		1,73,36,171,0,48,21,0,95,2,106,8,68,101,
		115,116,114,111,121,0,108,53,95,1,121,72,121,72,
		121,72,112,3,73,36,177,0,48,28,0,95,2,106,
		9,79,114,100,75,101,121,78,111,0,89,15,0,1,
		0,0,0,48,16,0,95,1,112,0,6,95,1,121,
		72,121,72,121,72,112,3,73,36,178,0,48,21,0,
		95,2,106,10,76,111,97,100,65,114,114,97,121,0,
		108,54,95,1,121,72,121,72,121,72,112,3,73,36,
		179,0,48,21,0,95,2,106,5,83,101,101,107,0,
		108,55,95,1,121,72,121,72,121,72,112,3,73,36,
		180,0,48,21,0,95,2,106,10,71,101,116,83,116,
		97,116,117,115,0,108,56,95,1,121,72,121,72,121,
		72,112,3,73,36,181,0,48,21,0,95,2,106,10,
		83,101,116,83,116,97,116,117,115,0,108,57,95,1,
		121,72,121,72,121,72,112,3,73,36,183,0,48,8,
		0,95,2,112,0,73,167,14,0,0,176,58,0,104,
		3,0,95,2,20,2,168,48,59,0,95,2,112,0,
		80,3,176,60,0,95,3,106,10,73,110,105,116,67,
		108,97,115,115,0,12,2,28,12,48,61,0,95,3,
		164,146,1,0,73,95,3,110,7,48,59,0,103,3,
		0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,3,4,36,189,0,121,80,5,36,190,0,121,80,
		6,36,191,0,121,80,7,36,193,0,95,3,100,8,
		28,5,9,25,4,95,3,80,3,36,197,0,48,62,
		0,102,95,1,112,1,73,36,198,0,48,63,0,102,
		106,6,65,82,82,65,89,0,112,1,73,36,199,0,
		48,45,0,102,176,64,0,95,2,12,1,106,2,65,
		0,8,28,11,176,65,0,95,2,12,1,25,5,4,
		0,0,112,1,73,36,200,0,48,66,0,102,9,112,
		1,73,36,201,0,48,67,0,102,9,112,1,73,36,
		202,0,48,68,0,102,121,112,1,73,36,203,0,48,
		69,0,102,122,112,1,73,36,204,0,48,70,0,102,
		176,64,0,95,4,12,1,106,2,67,0,8,28,6,
		95,4,25,5,106,1,0,112,1,73,36,205,0,48,
		71,0,102,4,0,0,112,1,73,36,206,0,48,72,
		0,102,4,0,0,112,1,73,36,208,0,48,73,0,
		48,46,0,102,112,0,112,0,29,220,0,36,211,0,
		48,16,0,48,46,0,102,112,0,112,0,80,7,36,
		212,0,176,38,0,48,74,0,48,46,0,102,112,0,
		112,0,12,1,80,6,36,214,0,48,72,0,102,176,
		75,0,95,6,12,1,112,1,73,36,216,0,48,34,
		0,48,46,0,102,112,0,121,112,1,73,36,217,0,
		122,165,80,5,25,97,36,218,0,176,10,0,48,48,
		0,102,112,0,48,76,0,48,74,0,48,46,0,102,
		112,0,112,0,95,5,1,112,0,20,2,36,219,0,
		95,3,28,51,36,220,0,176,12,0,102,48,77,0,
		48,74,0,48,46,0,102,112,0,112,0,95,5,1,
		112,0,95,5,48,78,0,48,74,0,48,46,0,102,
		112,0,112,0,95,5,1,112,0,20,4,36,217,0,
		175,5,0,95,6,15,28,158,36,224,0,48,79,0,
		102,176,38,0,48,48,0,102,112,0,12,1,112,1,
		73,36,225,0,48,34,0,48,46,0,102,112,0,95,
		7,112,1,73,36,229,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_DEFNEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,235,0,48,63,0,102,106,6,65,82,
		82,65,89,0,112,1,73,36,236,0,48,68,0,102,
		121,112,1,73,36,237,0,48,69,0,102,122,112,1,
		73,36,238,0,48,80,0,102,121,112,1,73,36,239,
		0,48,79,0,102,121,112,1,73,36,240,0,48,72,
		0,102,4,0,0,112,1,73,36,241,0,48,45,0,
		102,4,0,0,112,1,73,36,242,0,48,71,0,102,
		4,0,0,112,1,73,36,243,0,48,66,0,102,9,
		112,1,73,36,244,0,48,67,0,102,9,112,1,73,
		36,245,0,48,81,0,102,9,112,1,73,36,246,0,
		48,70,0,102,176,64,0,95,1,12,1,106,2,67,
		0,8,28,6,95,1,25,8,48,82,0,102,112,0,
		112,1,73,36,248,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_ADDFIELD )
{
	static const HB_BYTE pcode[] =
	{
		13,1,4,36,254,0,4,0,0,80,5,36,0,1,
		176,1,0,95,1,12,1,80,1,36,1,1,176,1,
		0,95,2,12,1,80,2,36,3,1,176,10,0,95,
		5,95,1,20,2,36,4,1,176,10,0,95,5,95,
		2,20,2,36,5,1,176,10,0,95,5,95,3,20,
		2,36,6,1,176,10,0,95,5,95,4,20,2,36,
		8,1,176,10,0,48,50,0,102,112,0,95,5,20,
		2,36,10,1,95,5,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_ACTIVATE )
{
	static const HB_BYTE pcode[] =
	{
		13,4,0,36,17,1,121,80,2,36,18,1,106,2,
		67,0,80,3,36,19,1,48,79,0,102,176,38,0,
		48,50,0,102,112,0,12,1,112,1,80,4,36,21,
		1,122,165,80,2,26,198,1,36,23,1,48,83,0,
		102,95,2,112,1,80,3,36,25,1,48,50,0,102,
		112,0,95,2,1,92,3,1,100,8,28,6,92,10,
		25,14,48,50,0,102,112,0,95,2,1,92,3,1,
		48,50,0,102,112,0,95,2,1,92,3,2,36,26,
		1,48,50,0,102,112,0,95,2,1,92,4,1,100,
		8,28,5,121,25,14,48,50,0,102,112,0,95,2,
		1,92,4,1,48,50,0,102,112,0,95,2,1,92,
		4,2,36,30,1,95,3,106,2,67,0,8,28,23,
		36,31,1,176,84,0,48,85,0,102,95,2,112,1,
		12,1,80,1,26,11,1,36,33,1,95,3,106,2,
		78,0,8,28,88,36,34,1,176,86,0,106,2,48,
		0,48,85,0,102,95,2,112,1,12,2,80,1,36,
		35,1,48,87,0,102,95,2,112,1,121,15,28,36,
		36,37,1,176,88,0,95,1,48,85,0,102,95,2,
		112,1,48,87,0,102,95,2,112,1,49,122,106,2,
		46,0,12,4,80,1,36,39,1,176,89,0,95,1,
		12,1,80,1,26,169,0,36,41,1,95,3,106,2,
		76,0,8,28,42,36,42,1,9,80,1,36,43,1,
		122,48,50,0,102,112,0,95,2,1,92,3,2,36,
		44,1,121,48,50,0,102,112,0,95,2,1,92,4,
		2,25,116,36,46,1,95,3,106,2,68,0,8,28,
		47,36,47,1,134,0,0,0,0,80,1,36,48,1,
		92,8,48,50,0,102,112,0,95,2,1,92,3,2,
		36,49,1,121,48,50,0,102,112,0,95,2,1,92,
		4,2,25,59,36,51,1,95,3,106,2,77,0,8,
		28,47,36,52,1,176,84,0,92,10,12,1,80,1,
		36,53,1,92,10,48,50,0,102,112,0,95,2,1,
		92,3,2,36,54,1,121,48,50,0,102,112,0,95,
		2,1,92,4,2,36,58,1,176,10,0,48,48,0,
		102,112,0,95,1,20,2,36,59,1,176,12,0,102,
		48,90,0,102,95,2,112,1,95,2,176,91,0,95,
		3,12,1,20,4,36,21,1,175,2,0,95,4,15,
		29,58,254,36,62,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_GOTO )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,68,1,48,16,0,102,112,0,80,2,
		36,70,1,176,64,0,95,1,12,1,106,2,78,0,
		8,28,85,95,1,121,15,28,79,36,71,1,48,66,
		0,102,9,112,1,73,36,72,1,48,67,0,102,9,
		112,1,73,36,73,1,95,1,48,35,0,102,112,0,
		15,28,31,36,74,1,48,68,0,102,48,35,0,102,
		112,0,112,1,73,36,75,1,48,66,0,102,120,112,
		1,73,25,14,36,77,1,48,68,0,102,95,1,112,
		1,73,36,81,1,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY__DELETE )
{
	static const HB_BYTE pcode[] =
	{
		36,87,1,176,92,0,48,15,0,102,112,0,48,16,
		0,102,112,0,20,2,36,88,1,176,93,0,48,15,
		0,102,112,0,48,80,0,102,21,48,35,0,163,0,
		112,0,17,112,1,20,2,36,90,1,48,34,0,102,
		48,16,0,102,112,0,112,1,73,36,92,1,102,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY__ZAP )
{
	static const HB_BYTE pcode[] =
	{
		36,98,1,48,94,0,102,112,0,73,36,99,1,48,
		95,0,102,112,0,31,24,36,100,1,48,96,0,102,
		112,0,73,36,101,1,48,97,0,102,112,0,73,25,
		225,36,104,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_UPDATE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,110,1,9,80,2,36,112,1,176,64,
		0,95,1,12,1,106,2,65,0,8,28,57,36,113,
		1,176,93,0,95,1,20,1,36,114,1,176,39,0,
		48,15,0,102,112,0,48,16,0,102,112,0,1,89,
		18,0,2,0,1,0,1,0,95,255,95,2,1,165,
		80,1,6,20,2,36,115,1,120,80,2,36,118,1,
		95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_APPEND )
{
	static const HB_BYTE pcode[] =
	{
		36,124,1,176,10,0,48,15,0,102,112,0,176,98,
		0,48,48,0,102,112,0,12,1,20,2,36,125,1,
		48,68,0,102,48,80,0,102,21,48,35,0,163,0,
		112,0,23,112,1,112,1,73,36,126,1,48,66,0,
		102,48,67,0,102,9,112,1,112,1,73,36,128,1,
		102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_SKIP )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,134,1,121,80,2,36,136,1,95,1,
		100,8,28,5,122,25,4,95,1,80,1,36,138,1,
		48,66,0,102,9,112,1,73,36,139,1,48,67,0,
		102,9,112,1,73,36,141,1,48,16,0,102,112,0,
		95,1,72,80,2,36,142,1,95,2,48,35,0,102,
		112,0,15,28,25,36,143,1,48,99,0,102,112,0,
		73,36,144,1,48,66,0,102,120,112,1,73,25,46,
		36,145,1,95,2,122,35,28,25,36,146,1,48,94,
		0,102,112,0,73,36,147,1,48,67,0,102,120,112,
		1,73,25,14,36,149,1,48,68,0,102,95,2,112,
		1,73,36,152,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_SKIPPER )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,158,1,121,80,2,36,160,1,176,100,
		0,176,101,0,95,1,122,48,16,0,102,112,0,49,
		12,2,48,35,0,102,112,0,48,16,0,102,112,0,
		49,12,2,80,2,36,162,1,48,68,0,102,21,48,
		16,0,163,0,112,0,95,2,72,112,1,73,36,164,
		1,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_SETBROWSE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,168,1,102,80,2,36,170,1,176,1,
		0,48,102,0,95,1,112,0,12,1,106,15,84,66,
		82,79,87,83,69,32,84,68,66,66,82,87,0,24,
		28,91,36,171,1,48,103,0,95,1,89,17,0,0,
		0,1,0,2,0,48,94,0,95,255,112,0,6,112,
		1,73,36,172,1,48,104,0,95,1,89,17,0,0,
		0,1,0,2,0,48,99,0,95,255,112,0,6,112,
		1,73,36,173,1,48,105,0,95,1,89,19,0,1,
		0,1,0,2,0,48,106,0,95,255,95,1,112,1,
		6,112,1,73,26,173,0,36,174,1,176,1,0,48,
		102,0,95,1,112,0,12,1,106,24,84,87,66,82,
		79,87,83,69,32,84,67,66,82,79,87,83,69,32,
		84,71,82,73,68,0,24,29,128,0,36,175,1,48,
		107,0,95,1,89,17,0,0,0,1,0,2,0,48,
		94,0,95,255,112,0,6,112,1,73,36,176,1,48,
		108,0,95,1,89,17,0,0,0,1,0,2,0,48,
		99,0,95,255,112,0,6,112,1,73,36,177,1,48,
		109,0,95,1,89,19,0,1,0,1,0,2,0,48,
		106,0,95,255,95,1,112,1,6,112,1,73,36,178,
		1,48,110,0,95,1,89,17,0,0,0,1,0,2,
		0,48,35,0,95,255,112,0,6,112,1,73,36,179,
		1,48,111,0,95,1,112,0,73,36,182,1,95,1,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_LOAD )
{
	static const HB_BYTE pcode[] =
	{
		13,5,4,36,186,1,102,80,5,36,188,1,121,80,
		6,36,189,1,4,0,0,80,7,36,190,1,48,112,
		0,95,5,112,0,80,8,36,193,1,48,69,0,95,
		5,48,16,0,48,46,0,95,5,112,0,112,0,112,
		1,73,36,195,1,176,64,0,95,1,12,1,106,2,
		66,0,69,28,8,90,4,120,6,25,4,95,1,80,
		1,36,196,1,176,64,0,95,2,12,1,106,2,66,
		0,69,28,27,89,23,0,0,0,1,0,5,0,48,
		95,0,48,46,0,95,255,112,0,112,0,68,6,25,
		4,95,2,80,2,36,198,1,48,113,0,95,2,95,
		5,112,1,29,225,0,36,200,1,48,113,0,95,1,
		95,5,112,1,29,190,0,36,202,1,95,3,100,69,
		28,43,36,203,1,48,113,0,95,3,95,5,112,1,
		80,9,36,204,1,176,64,0,95,9,12,1,106,2,
		76,0,8,28,12,95,9,31,8,36,205,1,9,110,
		7,36,209,1,4,0,0,80,7,36,210,1,122,165,
		80,6,25,38,36,211,1,176,10,0,95,7,48,76,
		0,48,74,0,48,46,0,95,5,112,0,112,0,95,
		6,1,112,0,20,2,36,210,1,175,6,0,95,8,
		15,28,217,36,213,1,176,10,0,48,15,0,95,5,
		112,0,95,7,20,2,36,215,1,48,68,0,95,5,
		122,112,1,73,36,217,1,95,4,100,69,28,43,36,
		218,1,48,113,0,95,4,95,5,112,1,80,9,36,
		219,1,176,64,0,95,9,12,1,106,2,76,0,8,
		28,12,95,9,31,8,36,220,1,9,110,7,36,226,
		1,48,97,0,48,46,0,95,5,112,0,122,112,1,
		73,26,22,255,36,230,1,48,114,0,95,5,112,0,
		73,36,232,1,48,66,0,95,5,48,67,0,95,5,
		48,80,0,95,5,48,115,0,95,5,112,0,112,1,
		121,8,112,1,112,1,73,36,234,1,95,5,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_FIELDPOS )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,239,1,176,5,0,48,50,0,102,112,
		0,89,22,0,1,0,1,0,1,0,95,1,122,1,
		176,1,0,95,255,12,1,8,6,20,2,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_RECLOAD )
{
	static const HB_BYTE pcode[] =
	{
		13,4,4,36,245,1,121,80,5,36,246,1,4,0,
		0,80,6,36,247,1,48,112,0,102,112,0,80,7,
		36,250,1,95,1,100,8,28,15,48,16,0,48,46,
		0,102,112,0,112,0,25,4,95,1,80,1,36,251,
		1,95,2,100,8,28,5,9,25,4,95,2,80,2,
		36,253,1,48,34,0,48,46,0,102,112,0,95,1,
		112,1,73,36,255,1,95,3,100,69,28,42,36,0,
		2,48,113,0,95,3,102,112,1,80,8,36,1,2,
		176,64,0,95,8,12,1,106,2,76,0,8,28,12,
		95,8,31,8,36,2,2,9,110,7,36,6,2,122,
		165,80,5,25,37,36,7,2,176,10,0,95,6,48,
		76,0,48,74,0,48,46,0,102,112,0,112,0,95,
		5,1,112,0,20,2,36,6,2,175,5,0,95,7,
		15,28,218,36,10,2,95,2,28,45,36,11,2,176,
		10,0,48,15,0,102,112,0,95,6,20,2,36,12,
		2,48,68,0,102,48,80,0,102,21,48,35,0,163,
		0,112,0,23,112,1,112,1,73,25,14,36,14,2,
		48,29,0,102,95,6,112,1,73,36,17,2,95,4,
		100,69,28,15,36,18,2,48,113,0,95,4,102,112,
		1,110,7,36,21,2,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_SAVE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,2,36,27,2,121,80,3,36,28,2,48,112,
		0,102,112,0,80,4,36,30,2,176,64,0,95,2,
		12,1,106,2,66,0,69,28,8,90,4,120,6,25,
		4,95,2,80,2,36,31,2,176,64,0,95,1,12,
		1,106,2,76,0,69,28,5,120,25,4,95,1,80,
		1,36,33,2,95,1,28,103,36,34,2,48,95,0,
		102,112,0,32,228,0,36,35,2,48,113,0,95,2,
		112,0,28,66,36,36,2,85,48,116,0,102,112,0,
		74,176,117,0,20,0,74,36,37,2,122,165,80,3,
		25,35,36,38,2,85,48,116,0,102,112,0,74,176,
		118,0,95,3,48,119,0,102,95,3,112,1,20,2,
		74,36,37,2,175,3,0,95,4,15,28,220,36,41,
		2,48,97,0,102,122,112,1,73,25,157,36,44,2,
		48,114,0,102,112,0,73,36,45,2,48,95,0,102,
		112,0,31,117,36,46,2,48,113,0,95,2,112,0,
		28,91,36,47,2,85,48,116,0,102,112,0,74,176,
		120,0,122,20,1,74,36,48,2,85,48,116,0,102,
		112,0,74,176,121,0,12,0,28,7,176,117,0,20,
		0,74,36,49,2,122,165,80,3,25,35,36,50,2,
		85,48,116,0,102,112,0,74,176,118,0,95,3,48,
		119,0,102,95,3,112,1,20,2,74,36,49,2,175,
		3,0,95,4,15,28,220,36,53,2,48,97,0,102,
		122,112,1,73,26,133,255,36,57,2,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_RECSAVE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,63,2,121,80,2,36,64,2,48,112,
		0,102,112,0,80,3,36,66,2,176,64,0,95,1,
		12,1,106,2,76,0,69,28,5,120,25,4,95,1,
		80,1,36,68,2,95,1,28,19,36,69,2,48,30,
		0,48,46,0,102,112,0,112,0,73,25,17,36,71,
		2,48,122,0,48,46,0,102,112,0,112,0,73,36,
		74,2,122,165,80,2,25,57,36,75,2,48,123,0,
		48,74,0,48,46,0,102,112,0,112,0,95,2,1,
		112,0,31,27,36,76,2,48,124,0,48,46,0,102,
		112,0,95,2,48,119,0,102,95,2,112,1,112,2,
		73,36,74,2,175,2,0,95,3,15,28,198,36,80,
		2,48,125,0,48,46,0,102,112,0,112,0,73,36,
		82,2,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_DBCORE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,88,2,9,80,2,36,90,2,176,64,
		0,95,1,12,1,106,2,67,0,8,28,72,36,91,
		2,176,126,0,95,1,48,50,0,102,112,0,20,2,
		36,92,2,176,127,0,120,100,95,1,20,3,36,93,
		2,48,128,0,102,176,129,0,12,0,112,1,73,36,
		94,2,48,94,0,102,112,0,73,36,95,2,48,125,
		0,102,120,112,1,73,36,96,2,120,80,2,36,99,
		2,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_DESTROY )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,103,2,102,80,1,36,105,2,48,45,
		0,95,1,4,0,0,112,1,73,36,106,2,48,71,
		0,95,1,4,0,0,112,1,73,36,107,2,48,72,
		0,95,1,4,0,0,112,1,73,36,109,2,100,80,
		1,36,111,2,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_LOADARRAY )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,117,2,48,45,0,102,95,1,112,1,
		73,36,118,2,48,68,0,102,122,112,1,73,36,119,
		2,48,80,0,102,48,115,0,102,112,0,112,1,73,
		36,121,2,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_SEEK )
{
	static const HB_BYTE pcode[] =
	{
		13,2,2,36,127,2,121,80,3,36,128,2,176,38,
		0,95,1,12,1,80,4,36,130,2,95,2,100,8,
		28,5,122,25,4,95,2,80,2,36,132,2,176,5,
		0,48,15,0,102,112,0,89,30,0,1,0,3,0,
		2,0,4,0,1,0,176,130,0,95,1,95,255,1,
		122,95,254,12,3,95,253,8,6,12,2,80,3,36,
		133,2,95,3,121,69,28,14,36,134,2,48,34,0,
		102,95,3,112,1,73,36,137,2,95,3,121,69,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_GETSTATUS )
{
	static const HB_BYTE pcode[] =
	{
		36,143,2,48,131,0,102,4,0,0,112,1,73,36,
		145,2,176,10,0,48,132,0,102,112,0,48,16,0,
		102,112,0,20,2,36,147,2,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TDBARRAY_SETSTATUS )
{
	static const HB_BYTE pcode[] =
	{
		36,153,2,48,34,0,102,48,132,0,102,112,0,122,
		1,112,1,73,36,155,2,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,135,0,3,0,116,135,0,4,0,0,82,1,0,
		4,0,0,82,2,0,7
	};

	hb_vmExecute( pcode, symbols );
}
