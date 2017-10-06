/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\Validators\SQLBaseValidator.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( SQLBASEVALIDATOR );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBOBJECT );
HB_FUNC_STATIC( SQLBASEVALIDATOR_NEW );
HB_FUNC_STATIC( SQLBASEVALIDATOR_END );
HB_FUNC_STATIC( SQLBASEVALIDATOR_PROCESSALL );
HB_FUNC_STATIC( SQLBASEVALIDATOR_PROCESS );
HB_FUNC_STATIC( SQLBASEVALIDATOR_REQUIRED );
HB_FUNC_STATIC( SQLBASEVALIDATOR_UNIQUE );
HB_FUNC_STATIC( SQLBASEVALIDATOR_EXIST );
HB_FUNC_STATIC( SQLBASEVALIDATOR_EMPTYOREXIST );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( GETSQLDATABASE );
HB_FUNC_EXTERN( MSGALERT );
HB_FUNC_EXTERN( HB_VALTOEXP );
HB_FUNC_EXTERN( HHASKEY );
HB_FUNC_EXTERN( HGET );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( BREAK );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( MSGINFO );
HB_FUNC_EXTERN( SPACE );
HB_FUNC_EXTERN( TOSQLSTRING );
HB_FUNC_EXTERN( HB_ISNUMERIC );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_SQLBASEVALIDATOR )
{ "SQLBASEVALIDATOR", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASEVALIDATOR )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBOBJECT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBASEVALIDATOR_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASEVALIDATOR_NEW )}, NULL },
{ "SQLBASEVALIDATOR_END", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASEVALIDATOR_END )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PROCESSALL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HVALIDATORS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HASSERTS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SQLBASEVALIDATOR_PROCESSALL", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASEVALIDATOR_PROCESSALL )}, NULL },
{ "SQLBASEVALIDATOR_PROCESS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASEVALIDATOR_PROCESS )}, NULL },
{ "SQLBASEVALIDATOR_REQUIRED", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASEVALIDATOR_REQUIRED )}, NULL },
{ "SQLBASEVALIDATOR_UNIQUE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASEVALIDATOR_UNIQUE )}, NULL },
{ "SQLBASEVALIDATOR_EXIST", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASEVALIDATOR_EXIST )}, NULL },
{ "SQLBASEVALIDATOR_EMPTYOREXIST", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SQLBASEVALIDATOR_EMPTYOREXIST )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETSQLDATABASE", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETSQLDATABASE )}, NULL },
{ "_OCONTROLLER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGALERT", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGALERT )}, NULL },
{ "HB_VALTOEXP", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_VALTOEXP )}, NULL },
{ "HHASKEY", {HB_FS_PUBLIC}, {HB_FUNCNAME( HHASKEY )}, NULL },
{ "HGET", {HB_FS_PUBLIC}, {HB_FUNCNAME( HGET )}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "GETMODELBUFFER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OCONTROLLER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCOLUMNTOPROCED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_UCOLUMNVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCURRENTMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__ENUMKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCURRENTMESSAGE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__ENUMVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "PROCESS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( BREAK )}, NULL },
{ "CCURRENTMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "CCURRENTMESSAGE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "UCOLUMNVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LDEBUGMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGINFO", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGINFO )}, NULL },
{ "GETMODELTABLENAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SPACE", {HB_FS_PUBLIC}, {HB_FUNCNAME( SPACE )}, NULL },
{ "CCOLUMNTOPROCED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TOSQLSTRING", {HB_FS_PUBLIC}, {HB_FUNCNAME( TOSQLSTRING )}, NULL },
{ "GETMODELBUFFERCOLUMNKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETMODELCOLUMNKEY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SELECTVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODATABASE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HB_ISNUMERIC", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_ISNUMERIC )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_SQLBASEVALIDATOR, ".\\Prg\\Validators\\SQLBaseValidator.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_SQLBASEVALIDATOR
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_SQLBASEVALIDATOR )
   #include "hbiniseg.h"
#endif

HB_FUNC( SQLBASEVALIDATOR )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,61,0,36,7,0,103,2,0,100,8,
		29,72,3,176,1,0,104,2,0,12,1,29,61,3,
		166,255,2,0,122,80,1,48,2,0,176,3,0,12,
		0,106,17,83,81,76,66,97,115,101,86,97,108,105,
		100,97,116,111,114,0,108,4,4,1,0,108,0,112,
		3,80,2,36,9,0,48,5,0,95,2,100,100,95,
		1,121,72,121,72,121,72,106,10,111,68,97,116,97,
		98,97,115,101,0,4,1,0,9,112,5,73,36,11,
		0,48,5,0,95,2,100,100,95,1,121,72,121,72,
		121,72,106,12,111,67,111,110,116,114,111,108,108,101,
		114,0,4,1,0,9,112,5,73,36,13,0,48,5,
		0,95,2,100,100,95,1,121,72,121,72,121,72,106,
		12,104,86,97,108,105,100,97,116,111,114,115,0,4,
		1,0,9,112,5,73,36,14,0,48,5,0,95,2,
		100,100,95,1,121,72,121,72,121,72,106,9,104,65,
		115,115,101,114,116,115,0,4,1,0,9,112,5,73,
		36,16,0,48,5,0,95,2,100,100,95,1,121,72,
		121,72,121,72,106,13,117,67,111,108,117,109,110,86,
		97,108,117,101,0,4,1,0,9,112,5,73,36,17,
		0,48,5,0,95,2,100,100,95,1,121,72,121,72,
		121,72,106,16,99,67,111,108,117,109,110,84,111,80,
		114,111,99,101,100,0,4,1,0,9,112,5,73,36,
		19,0,48,5,0,95,2,100,100,95,1,121,72,121,
		72,121,72,106,15,99,67,117,114,114,101,110,116,77,
		101,116,104,111,100,0,4,1,0,9,112,5,73,36,
		20,0,48,5,0,95,2,100,100,95,1,121,72,121,
		72,121,72,106,16,99,67,117,114,114,101,110,116,77,
		101,115,115,97,103,101,0,4,1,0,9,112,5,73,
		36,22,0,48,5,0,95,2,100,120,95,1,121,72,
		121,72,121,72,106,11,108,68,101,98,117,103,77,111,
		100,101,0,4,1,0,9,112,5,73,36,24,0,48,
		6,0,95,2,106,4,78,101,119,0,108,7,95,1,
		121,72,121,72,121,72,112,3,73,36,25,0,48,6,
		0,95,2,106,4,69,110,100,0,108,8,95,1,121,
		72,121,72,121,72,112,3,73,36,27,0,48,9,0,
		95,2,106,9,86,97,108,105,100,97,116,101,0,89,
		24,0,2,0,0,0,48,10,0,95,1,95,2,48,
		11,0,95,1,112,0,112,2,6,95,1,121,72,121,
		72,121,72,112,3,73,36,28,0,48,9,0,95,2,
		106,7,65,115,115,101,114,116,0,89,26,0,3,0,
		0,0,48,10,0,95,1,95,2,48,12,0,95,1,
		112,0,95,3,112,3,6,95,1,121,72,121,72,121,
		72,112,3,73,36,30,0,48,6,0,95,2,106,11,
		80,114,111,99,101,115,115,65,108,108,0,108,13,95,
		1,121,72,121,72,121,72,112,3,73,36,31,0,48,
		6,0,95,2,106,8,80,114,111,99,101,115,115,0,
		108,14,95,1,121,72,121,72,121,72,112,3,73,36,
		33,0,48,6,0,95,2,106,9,82,101,113,117,105,
		114,101,100,0,108,15,95,1,121,72,121,72,121,72,
		112,3,73,36,34,0,48,6,0,95,2,106,7,85,
		110,105,113,117,101,0,108,16,95,1,121,72,121,72,
		121,72,112,3,73,36,35,0,48,6,0,95,2,106,
		6,69,120,105,115,116,0,108,17,95,1,121,72,121,
		72,121,72,112,3,73,36,36,0,48,6,0,95,2,
		106,13,69,109,112,116,121,79,114,69,120,105,115,116,
		0,108,18,95,1,121,72,121,72,121,72,112,3,73,
		36,38,0,48,19,0,95,2,112,0,73,167,14,0,
		0,176,20,0,104,2,0,95,2,20,2,168,48,21,
		0,95,2,112,0,80,3,176,22,0,95,3,106,10,
		73,110,105,116,67,108,97,115,115,0,12,2,28,12,
		48,23,0,95,3,164,146,1,0,73,95,3,110,7,
		48,21,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASEVALIDATOR_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,44,0,48,24,0,102,176,25,0,12,
		0,112,1,73,36,46,0,48,26,0,102,95,1,112,
		1,73,36,48,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASEVALIDATOR_END )
{
	static const HB_BYTE pcode[] =
	{
		36,54,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASEVALIDATOR_PROCESSALL )
{
	static const HB_BYTE pcode[] =
	{
		13,2,3,36,63,0,176,27,0,95,1,106,22,99,
		67,111,108,117,109,110,32,101,110,32,80,114,111,99,
		101,115,115,65,108,108,0,20,2,36,64,0,176,27,
		0,176,28,0,95,2,12,1,106,23,104,80,114,111,
		99,101,115,115,32,101,110,32,80,114,111,99,101,115,
		115,65,108,108,0,20,2,36,65,0,176,27,0,95,
		3,106,21,117,86,97,108,117,101,32,101,110,32,80,
		114,111,99,101,115,115,65,108,108,0,20,2,36,67,
		0,176,29,0,95,2,95,1,12,2,31,8,36,68,
		0,120,110,7,36,71,0,176,30,0,95,2,95,1,
		12,2,80,5,36,72,0,176,31,0,95,5,12,1,
		28,8,36,73,0,120,110,7,36,76,0,95,3,100,
		8,28,17,48,32,0,48,33,0,102,112,0,95,1,
		112,1,80,3,36,78,0,48,34,0,102,95,1,112,
		1,73,36,79,0,48,35,0,102,95,3,112,1,73,
		36,81,0,95,5,96,4,0,129,1,1,28,63,36,
		83,0,48,36,0,102,48,37,0,96,4,0,112,0,
		112,1,73,36,84,0,48,38,0,102,48,39,0,96,
		4,0,112,0,112,1,73,36,86,0,48,40,0,102,
		95,3,112,1,31,8,36,87,0,9,110,7,36,90,
		0,130,31,197,132,36,92,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASEVALIDATOR_PROCESS )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,99,0,9,80,3,36,103,0,113,74,
		0,0,89,15,0,1,0,0,0,176,41,0,95,1,
		12,1,6,178,36,105,0,48,42,0,102,112,0,46,
		102,95,1,112,1,80,3,36,107,0,95,3,31,24,
		36,108,0,176,43,0,48,44,0,102,112,0,106,6,
		69,114,114,111,114,0,20,2,36,109,0,73,114,26,
		0,0,36,111,0,115,80,2,36,113,0,48,45,0,
		176,46,0,12,0,95,2,112,1,73,36,117,0,95,
		3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASEVALIDATOR_REQUIRED )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,123,0,95,1,100,8,28,10,48,47,
		0,102,112,0,80,1,36,125,0,48,48,0,102,112,
		0,28,39,36,126,0,176,49,0,176,31,0,95,1,
		12,1,68,106,19,82,101,113,117,105,114,101,100,32,
		118,97,108,105,100,97,116,111,114,0,20,2,36,129,
		0,176,31,0,48,47,0,102,112,0,12,1,68,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASEVALIDATOR_UNIQUE )
{
	static const HB_BYTE pcode[] =
	{
		13,3,1,36,139,0,95,1,100,8,28,10,48,47,
		0,102,112,0,80,1,36,141,0,106,22,83,69,76,
		69,67,84,32,67,79,85,78,84,40,42,41,32,70,
		82,79,77,32,0,48,50,0,48,33,0,102,112,0,
		112,0,72,176,51,0,122,12,1,72,80,4,36,142,
		0,96,4,0,106,7,87,72,69,82,69,32,0,48,
		52,0,102,112,0,72,106,4,32,61,32,0,72,176,
		53,0,95,1,12,1,72,176,51,0,122,12,1,72,
		135,36,144,0,48,54,0,48,33,0,102,112,0,112,
		0,80,2,36,145,0,176,31,0,95,2,12,1,31,
		44,36,146,0,96,4,0,106,5,65,78,68,32,0,
		48,55,0,48,33,0,102,112,0,112,0,72,106,5,
		32,60,62,32,0,72,176,53,0,95,2,12,1,72,
		135,36,149,0,48,48,0,102,112,0,28,31,36,150,
		0,176,49,0,95,4,106,17,85,110,105,113,117,101,
		32,118,97,108,105,100,97,116,111,114,0,20,2,36,
		153,0,48,56,0,48,57,0,102,112,0,95,4,112,
		1,80,3,36,155,0,176,58,0,95,3,12,1,21,
		28,7,73,95,3,121,8,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASEVALIDATOR_EXIST )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,164,0,95,1,100,8,28,10,48,47,
		0,102,112,0,80,1,36,166,0,106,22,83,69,76,
		69,67,84,32,67,79,85,78,84,40,42,41,32,70,
		82,79,77,32,0,48,50,0,48,33,0,102,112,0,
		112,0,72,176,51,0,122,12,1,72,80,3,36,167,
		0,96,3,0,106,7,87,72,69,82,69,32,0,48,
		52,0,102,112,0,72,106,4,32,61,32,0,72,176,
		53,0,95,1,12,1,72,135,36,169,0,48,48,0,
		102,112,0,28,30,36,170,0,176,49,0,95,3,106,
		16,69,120,105,115,116,32,118,97,108,105,100,97,116,
		111,114,0,20,2,36,173,0,48,56,0,48,57,0,
		102,112,0,95,3,112,1,80,2,36,175,0,176,58,
		0,95,2,12,1,21,28,7,73,95,2,121,69,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SQLBASEVALIDATOR_EMPTYOREXIST )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,184,0,95,1,100,8,28,10,48,47,
		0,102,112,0,80,1,36,186,0,176,31,0,95,1,
		12,1,28,8,36,187,0,120,110,7,36,190,0,106,
		22,83,69,76,69,67,84,32,67,79,85,78,84,40,
		42,41,32,70,82,79,77,32,0,48,50,0,48,33,
		0,102,112,0,112,0,72,176,51,0,122,12,1,72,
		80,3,36,191,0,96,3,0,106,7,87,72,69,82,
		69,32,0,48,52,0,102,112,0,72,106,4,32,61,
		32,0,72,176,53,0,95,1,12,1,72,135,36,193,
		0,48,48,0,102,112,0,28,37,36,194,0,176,49,
		0,95,3,106,23,69,109,112,116,121,79,114,69,120,
		105,115,116,32,118,97,108,105,100,97,116,111,114,0,
		20,2,36,197,0,48,56,0,48,57,0,102,112,0,
		95,3,112,1,80,2,36,199,0,176,58,0,95,2,
		12,1,21,28,7,73,95,2,121,69,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,61,0,2,0,116,61,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

