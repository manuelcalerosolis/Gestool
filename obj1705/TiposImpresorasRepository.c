/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\Repositories\TiposImpresorasRepository.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TIPOSIMPRESORASREPOSITORY );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( SQLBASEREPOSITORY );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( TIPOSIMPRESORASMODEL );
HB_FUNC_STATIC( TIPOSIMPRESORASREPOSITORY_GETNOMBRES );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( HB_AINS );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TIPOSIMPRESORASREPOSITORY )
{ "TIPOSIMPRESORASREPOSITORY", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TIPOSIMPRESORASREPOSITORY )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "SQLBASEREPOSITORY", {HB_FS_PUBLIC}, {HB_FUNCNAME( SQLBASEREPOSITORY )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "GETCONTROLLER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETMODELTABLENAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETTABLENAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TIPOSIMPRESORASMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIPOSIMPRESORASMODEL )}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TIPOSIMPRESORASREPOSITORY_GETNOMBRES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TIPOSIMPRESORASREPOSITORY_GETNOMBRES )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SELECTFETCHARRAYONECOLUMN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETDATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_AINS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_AINS )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TIPOSIMPRESORASREPOSITORY, ".\\Prg\\Repositories\\TiposImpresorasRepository.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TIPOSIMPRESORASREPOSITORY
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TIPOSIMPRESORASREPOSITORY )
   #include "hbiniseg.h"
#endif

HB_FUNC( TIPOSIMPRESORASREPOSITORY )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,23,0,36,7,0,103,2,0,100,8,
		29,247,0,176,1,0,104,2,0,12,1,29,236,0,
		166,174,0,0,122,80,1,48,2,0,176,3,0,12,
		0,106,26,84,105,112,111,115,73,109,112,114,101,115,
		111,114,97,115,82,101,112,111,115,105,116,111,114,121,
		0,108,4,4,1,0,108,0,112,3,80,2,36,9,
		0,48,5,0,95,2,106,13,103,101,116,84,97,98,
		108,101,78,97,109,101,0,89,41,0,1,0,0,0,
		176,6,0,48,7,0,95,1,112,0,12,1,31,11,
		48,8,0,95,1,112,0,25,12,48,9,0,176,10,
		0,12,0,112,0,6,95,1,121,72,121,72,121,72,
		112,3,73,36,11,0,48,11,0,95,2,106,11,103,
		101,116,78,111,109,98,114,101,115,0,108,12,95,1,
		121,72,121,72,121,72,112,3,73,36,13,0,48,13,
		0,95,2,112,0,73,167,14,0,0,176,14,0,104,
		2,0,95,2,20,2,168,48,15,0,95,2,112,0,
		80,3,176,16,0,95,3,106,10,73,110,105,116,67,
		108,97,115,115,0,12,2,28,12,48,17,0,95,3,
		164,146,1,0,73,95,3,110,7,48,15,0,103,2,
		0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TIPOSIMPRESORASREPOSITORY_GETNOMBRES )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,19,0,106,20,83,69,76,69,67,84,
		32,110,111,109,98,114,101,32,70,82,79,77,32,0,
		48,9,0,102,112,0,72,80,1,36,20,0,48,18,
		0,48,19,0,102,112,0,95,1,112,1,80,2,36,
		22,0,176,20,0,95,2,122,106,1,0,120,20,4,
		36,24,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,23,0,2,0,116,23,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

