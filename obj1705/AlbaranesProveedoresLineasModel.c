/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\Models\AlbaranesProveedoresLineasModel.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( ALBARANESPROVEEDORESLINEASMODEL );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TRANSACCIONESCOMERCIALESLINEASMODEL );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_ALBARANESPROVEEDORESLINEASMODEL )
{ "ALBARANESPROVEEDORESLINEASMODEL", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( ALBARANESPROVEEDORESLINEASMODEL )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TRANSACCIONESCOMERCIALESLINEASMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( TRANSACCIONESCOMERCIALESLINEASMODEL )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETEMPRESATABLENAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_ALBARANESPROVEEDORESLINEASMODEL, ".\\Prg\\Models\\AlbaranesProveedoresLineasModel.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_ALBARANESPROVEEDORESLINEASMODEL
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_ALBARANESPROVEEDORESLINEASMODEL )
   #include "hbiniseg.h"
#endif

HB_FUNC( ALBARANESPROVEEDORESLINEASMODEL )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,14,0,36,6,0,103,2,0,100,8,
		29,28,1,176,1,0,104,2,0,12,1,29,17,1,
		166,211,0,0,122,80,1,48,2,0,176,3,0,12,
		0,106,32,65,108,98,97,114,97,110,101,115,80,114,
		111,118,101,101,100,111,114,101,115,76,105,110,101,97,
		115,77,111,100,101,108,0,108,4,4,1,0,108,0,
		112,3,80,2,36,8,0,48,5,0,95,2,106,13,
		103,101,116,84,97,98,108,101,78,97,109,101,0,89,
		26,0,1,0,0,0,48,6,0,95,1,106,9,65,
		108,98,80,114,111,118,76,0,112,1,6,95,1,121,
		72,121,72,121,72,112,3,73,36,10,0,48,5,0,
		95,2,106,14,103,101,116,69,120,116,114,97,87,104,
		101,114,101,0,89,45,0,1,0,0,0,106,35,65,
		78,68,32,110,67,116,108,83,116,107,32,60,32,50,
		32,65,78,68,32,78,79,84,32,108,70,97,99,116,
		117,114,97,100,111,0,6,95,1,121,72,121,72,121,
		72,112,3,73,36,14,0,48,7,0,95,2,112,0,
		73,167,14,0,0,176,8,0,104,2,0,95,2,20,
		2,168,48,9,0,95,2,112,0,80,3,176,10,0,
		95,3,106,10,73,110,105,116,67,108,97,115,115,0,
		12,2,28,12,48,11,0,95,3,164,146,1,0,73,
		95,3,110,7,48,9,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,14,0,2,0,116,14,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}
