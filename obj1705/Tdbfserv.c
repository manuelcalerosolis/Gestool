/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\Tdbfserv.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( DBAT );
HB_FUNC_EXTERN( VALTYPE );
HB_FUNC_EXTERN( UPPER );
HB_FUNC_EXTERN( ASCAN );
HB_FUNC( LDBCLASS );
HB_FUNC( ADBCLASS );
HB_FUNC( NINSDBCLASS );
HB_FUNC( INITDBCLASS );
HB_FUNC( DBFSERVER );
HB_FUNC_EXTERN( ALIAS );
HB_FUNC_EXTERN( GETFILENOEXT );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( __CLSINST );
HB_FUNC_EXTERN( TDBF );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TDBFSERV )
{ "DBAT", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( DBAT )}, NULL },
{ "VALTYPE", {HB_FS_PUBLIC}, {HB_FUNCNAME( VALTYPE )}, NULL },
{ "UPPER", {HB_FS_PUBLIC}, {HB_FUNCNAME( UPPER )}, NULL },
{ "ASCAN", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASCAN )}, NULL },
{ "LDBCLASS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( LDBCLASS )}, NULL },
{ "ADBCLASS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( ADBCLASS )}, NULL },
{ "NINSDBCLASS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( NINSDBCLASS )}, NULL },
{ "INITDBCLASS", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( INITDBCLASS )}, NULL },
{ "DBFSERVER", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( DBFSERVER )}, NULL },
{ "ALIAS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALIAS )}, NULL },
{ "GETFILENOEXT", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETFILENOEXT )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSINST", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSINST )}, NULL },
{ "TDBF", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDBF )}, NULL },
{ "(_INITSTATICS00001)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TDBFSERV, ".\\.\\Prg\\Tdbfserv.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TDBFSERV
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TDBFSERV )
   #include "hbiniseg.h"
#endif

HB_FUNC( DBAT )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,116,17,0,36,26,0,121,80,2,36,28,
		0,176,1,0,95,1,12,1,106,2,67,0,8,28,
		44,36,29,0,176,2,0,95,1,12,1,80,1,36,
		30,0,176,3,0,103,1,0,89,17,0,1,0,1,
		0,1,0,95,1,122,1,95,255,8,6,12,2,80,
		2,36,33,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( LDBCLASS )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,37,0,176,0,0,95,1,12,1,121,
		15,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( ADBCLASS )
{
	static const HB_BYTE pcode[] =
	{
		116,17,0,36,41,0,103,1,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( NINSDBCLASS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,116,17,0,36,47,0,176,0,0,95,1,
		12,1,80,2,36,49,0,95,2,121,15,28,13,103,
		1,0,95,2,1,92,3,1,25,3,121,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( INITDBCLASS )
{
	static const HB_BYTE pcode[] =
	{
		116,17,0,36,55,0,4,0,0,82,1,0,36,57,
		0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( DBFSERVER )
{
	static const HB_BYTE pcode[] =
	{
		13,2,2,36,65,0,121,80,3,36,68,0,176,1,
		0,95,1,12,1,106,2,67,0,69,28,17,176,9,
		0,12,0,106,5,46,68,66,70,0,72,25,4,95,
		1,80,1,36,69,0,176,1,0,95,2,12,1,106,
		2,67,0,69,28,16,106,2,84,0,176,10,0,95,
		1,12,1,72,25,4,95,2,80,2,36,70,0,176,
		2,0,95,2,12,1,80,2,36,75,0,48,11,0,
		176,12,0,12,0,95,2,106,5,84,68,66,70,0,
		112,2,80,4,36,76,0,48,13,0,95,4,112,0,
		73,36,77,0,48,14,0,95,4,112,0,80,3,36,
		79,0,176,15,0,95,3,20,1,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,17,0,1,0,116,17,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

