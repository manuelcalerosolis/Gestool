/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\Tarray.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( __STRUCTNEW );
HB_FUNC( TARRAY );
HB_FUNC_EXTERN( ATAIL );
HB_FUNC_EXTERN( LEN );
HB_FUNC_EXTERN( AADD );
HB_FUNC( __STRUCTFIELD );
HB_FUNC_EXTERN( PADR );
HB_FUNC( __STRUCTEND );
HB_FUNC_EXTERN( ASIZE );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBOBJECT );
HB_FUNC_STATIC( TARRAY_NEW );
HB_FUNC_STATIC( TARRAY_ADDFIELD );
HB_FUNC_STATIC( TARRAY_ARRAYERRORHAND );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( UPPER );
HB_FUNC_EXTERN( SET );
HB_FUNC_EXTERN( SUBSTR );
HB_FUNC_EXTERN( AEVAL );
HB_FUNC_EXTERN( ASCAN );
HB_FUNC_EXTERN( GETPARAM );
HB_FUNC_EXTERN( _CLSSETERROR );
HB_FUNC_EXTERN( _GENERROR );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TARRAY )
{ "__STRUCTNEW", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( __STRUCTNEW )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TARRAY", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( TARRAY )}, NULL },
{ "_ADATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ATAIL", {HB_FS_PUBLIC}, {HB_FUNCNAME( ATAIL )}, NULL },
{ "ABUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "AADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( AADD )}, NULL },
{ "AFIELDSOBJ", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__STRUCTFIELD", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( __STRUCTFIELD )}, NULL },
{ "ADDFIELD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PADR", {HB_FS_PUBLIC}, {HB_FUNCNAME( PADR )}, NULL },
{ "__STRUCTEND", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( __STRUCTEND )}, NULL },
{ "ASIZE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASIZE )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBOBJECT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TARRAY_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TARRAY_NEW )}, NULL },
{ "TARRAY_ADDFIELD", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TARRAY_ADDFIELD )}, NULL },
{ "SETONERROR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TARRAY_ARRAYERRORHAND", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TARRAY_ARRAYERRORHAND )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_AFIELDS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ABUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_AFIELDSOBJ", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AFIELDS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "UPPER", {HB_FS_PUBLIC}, {HB_FUNCNAME( UPPER )}, NULL },
{ "SET", {HB_FS_PUBLIC}, {HB_FUNCNAME( SET )}, NULL },
{ "SUBSTR", {HB_FS_PUBLIC}, {HB_FUNCNAME( SUBSTR )}, NULL },
{ "LCHECKUPPER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AEVAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( AEVAL )}, NULL },
{ "_LCHECKUPPER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ASCAN", {HB_FS_PUBLIC}, {HB_FUNCNAME( ASCAN )}, NULL },
{ "GETPARAM", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETPARAM )}, NULL },
{ "_CLSSETERROR", {HB_FS_PUBLIC}, {HB_FUNCNAME( _CLSSETERROR )}, NULL },
{ "_GENERROR", {HB_FS_PUBLIC}, {HB_FUNCNAME( _GENERROR )}, NULL },
{ "CLASSNAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TARRAY, ".\\.\\Prg\\Tarray.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TARRAY
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TARRAY )
   #include "hbiniseg.h"
#endif

HB_FUNC( __STRUCTNEW )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,116,43,0,36,21,0,48,1,0,176,2,
		0,12,0,112,0,80,2,36,22,0,95,1,100,69,
		28,15,36,23,0,48,3,0,95,2,95,1,112,1,
		73,36,26,0,103,1,0,100,8,28,15,36,27,0,
		95,2,4,1,0,82,1,0,25,70,36,29,0,176,
		4,0,103,1,0,12,1,80,3,36,30,0,95,2,
		48,5,0,95,3,112,0,176,6,0,48,5,0,95,
		3,112,0,12,1,2,36,31,0,176,7,0,48,8,
		0,95,3,112,0,95,2,20,2,36,32,0,176,7,
		0,103,1,0,95,2,20,2,36,35,0,95,2,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( __STRUCTFIELD )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,116,43,0,36,41,0,176,4,0,103,1,
		0,12,1,80,3,36,42,0,48,10,0,95,3,176,
		11,0,95,1,92,8,12,2,95,2,112,2,73,36,
		44,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( __STRUCTEND )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,116,43,0,36,50,0,176,6,0,103,1,
		0,12,1,80,1,36,51,0,95,1,122,8,28,11,
		36,52,0,100,82,1,0,25,17,36,54,0,176,13,
		0,103,1,0,95,1,122,49,20,2,36,56,0,120,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( TARRAY )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,43,0,36,59,0,103,2,0,100,8,
		29,116,1,176,14,0,104,2,0,12,1,29,105,1,
		166,43,1,0,122,80,1,48,1,0,176,15,0,12,
		0,106,7,84,65,114,114,97,121,0,108,16,4,1,
		0,108,2,112,3,80,2,36,61,0,48,17,0,95,
		2,100,100,95,1,121,72,121,72,121,72,106,6,97,
		68,97,116,97,0,4,1,0,9,112,5,73,36,62,
		0,48,17,0,95,2,100,100,95,1,121,72,121,72,
		121,72,106,8,97,70,105,101,108,100,115,0,4,1,
		0,9,112,5,73,36,63,0,48,17,0,95,2,100,
		100,95,1,121,72,121,72,121,72,106,8,97,66,117,
		102,102,101,114,0,4,1,0,9,112,5,73,36,64,
		0,48,17,0,95,2,100,120,95,1,121,72,121,72,
		121,72,106,12,108,67,104,101,99,107,85,112,112,101,
		114,0,4,1,0,9,112,5,73,36,65,0,48,17,
		0,95,2,100,100,95,1,121,72,121,72,121,72,106,
		11,97,70,105,101,108,100,115,79,98,106,0,4,1,
		0,9,112,5,73,36,67,0,48,18,0,95,2,106,
		4,78,101,119,0,108,19,95,1,92,8,72,121,72,
		121,72,112,3,73,36,69,0,48,18,0,95,2,106,
		9,65,100,100,70,105,101,108,100,0,108,20,95,1,
		121,72,121,72,121,72,112,3,73,36,71,0,48,21,
		0,95,2,108,22,112,1,73,36,73,0,48,23,0,
		95,2,112,0,73,167,14,0,0,176,24,0,104,2,
		0,95,2,20,2,168,48,25,0,95,2,112,0,80,
		3,176,26,0,95,3,106,10,73,110,105,116,67,108,
		97,115,115,0,12,2,28,12,48,27,0,95,3,164,
		146,1,0,73,95,3,110,7,48,25,0,103,2,0,
		112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TARRAY_NEW )
{
	static const HB_BYTE pcode[] =
	{
		36,80,0,48,3,0,102,4,0,0,112,1,73,36,
		81,0,48,28,0,102,4,0,0,112,1,73,36,82,
		0,48,29,0,102,4,0,0,112,1,73,36,83,0,
		48,30,0,102,4,0,0,112,1,73,36,85,0,102,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TARRAY_ADDFIELD )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,90,0,176,7,0,48,31,0,102,112,
		0,176,32,0,95,1,12,1,20,2,36,91,0,176,
		7,0,48,5,0,102,112,0,95,2,20,2,36,92,
		0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TARRAY_ARRAYERRORHAND )
{
	static const HB_BYTE pcode[] =
	{
		13,5,2,36,96,0,102,80,3,36,98,0,9,80,
		4,36,100,0,176,33,0,122,120,12,2,80,6,36,
		103,0,176,34,0,95,1,122,122,12,3,106,2,95,
		0,8,28,22,36,104,0,120,80,4,36,105,0,176,
		34,0,95,1,92,2,12,2,80,1,36,108,0,48,
		35,0,95,3,112,0,28,57,36,109,0,176,36,0,
		48,31,0,95,3,112,0,89,28,0,2,0,1,0,
		3,0,176,32,0,95,1,12,1,165,48,31,0,95,
		255,112,0,95,2,2,6,20,2,36,110,0,48,37,
		0,95,3,9,112,1,73,36,113,0,176,38,0,48,
		31,0,95,3,112,0,95,1,12,2,165,80,5,121,
		15,28,55,36,114,0,95,4,28,31,36,115,0,176,
		39,0,122,122,12,2,80,7,36,116,0,95,7,48,
		5,0,95,3,112,0,95,5,2,25,45,36,118,0,
		48,5,0,95,3,112,0,95,5,1,80,7,25,28,
		36,121,0,176,40,0,176,41,0,95,2,48,42,0,
		95,3,112,0,95,1,12,3,12,1,80,7,36,124,
		0,176,33,0,122,95,6,20,2,36,126,0,95,7,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,43,0,2,0,7
	};

	hb_vmExecute( pcode, symbols );
}

