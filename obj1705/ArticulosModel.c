/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\Models\ArticulosModel.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( ARTICULOSMODEL );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( ADSBASEMODEL );
HB_FUNC_STATIC( ARTICULOSMODEL_EXIST );
HB_FUNC_STATIC( ARTICULOSMODEL_GET );
HB_FUNC_STATIC( ARTICULOSMODEL_GETVALORESPROPIEDADES );
HB_FUNC_STATIC( ARTICULOSMODEL_GETPRIMERVALORPROPIEDAD );
HB_FUNC_STATIC( ARTICULOSMODEL_GETARTICULOSTOPRESTASHOPINFAMILIA );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( QUOTED );
HB_FUNC_EXTERN( LASTREC );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_ARTICULOSMODEL )
{ "ARTICULOSMODEL", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( ARTICULOSMODEL )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "ADSBASEMODEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( ADSBASEMODEL )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETEMPRESATABLENAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ARTICULOSMODEL_EXIST", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ARTICULOSMODEL_EXIST )}, NULL },
{ "ARTICULOSMODEL_GET", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ARTICULOSMODEL_GET )}, NULL },
{ "ARTICULOSMODEL_GETVALORESPROPIEDADES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ARTICULOSMODEL_GETVALORESPROPIEDADES )}, NULL },
{ "ARTICULOSMODEL_GETPRIMERVALORPROPIEDAD", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ARTICULOSMODEL_GETPRIMERVALORPROPIEDAD )}, NULL },
{ "ARTICULOSMODEL_GETARTICULOSTOPRESTASHOPINFAMILIA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( ARTICULOSMODEL_GETARTICULOSTOPRESTASHOPINFAMILIA )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETTABLENAME", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "QUOTED", {HB_FS_PUBLIC}, {HB_FUNCNAME( QUOTED )}, NULL },
{ "EXECUTESQLSTATEMENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LASTREC", {HB_FS_PUBLIC}, {HB_FUNCNAME( LASTREC )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_ARTICULOSMODEL, ".\\Prg\\Models\\ArticulosModel.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_ARTICULOSMODEL
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_ARTICULOSMODEL )
   #include "hbiniseg.h"
#endif

HB_FUNC( ARTICULOSMODEL )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,24,0,36,6,0,103,2,0,100,8,
		29,136,1,176,1,0,104,2,0,12,1,29,125,1,
		166,63,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,15,65,114,116,105,99,117,108,111,115,77,111,
		100,101,108,0,108,4,4,1,0,108,0,112,3,80,
		2,36,8,0,48,5,0,95,2,106,13,103,101,116,
		84,97,98,108,101,78,97,109,101,0,89,26,0,1,
		0,0,0,48,6,0,95,1,106,9,65,114,116,105,
		99,117,108,111,0,112,1,6,95,1,121,72,121,72,
		121,72,112,3,73,36,10,0,48,7,0,95,2,106,
		6,101,120,105,115,116,0,108,8,95,1,121,72,121,
		72,121,72,112,3,73,36,12,0,48,7,0,95,2,
		106,4,103,101,116,0,108,9,95,1,121,72,121,72,
		121,72,112,3,73,36,14,0,48,7,0,95,2,106,
		22,103,101,116,86,97,108,111,114,101,115,80,114,111,
		112,105,101,100,97,100,101,115,0,108,10,95,1,121,
		72,121,72,121,72,112,3,73,36,16,0,48,7,0,
		95,2,106,24,103,101,116,80,114,105,109,101,114,86,
		97,108,111,114,80,114,111,112,105,101,100,97,100,0,
		108,11,95,1,121,72,121,72,121,72,112,3,73,36,
		18,0,48,7,0,95,2,106,34,103,101,116,65,114,
		116,105,99,117,108,111,115,84,111,80,114,101,115,116,
		97,83,104,111,112,73,110,70,97,109,105,108,105,97,
		0,108,12,95,1,121,72,121,72,121,72,112,3,73,
		36,20,0,48,13,0,95,2,112,0,73,167,14,0,
		0,176,14,0,104,2,0,95,2,20,2,168,48,15,
		0,95,2,112,0,80,3,176,16,0,95,3,106,10,
		73,110,105,116,67,108,97,115,115,0,12,2,28,12,
		48,17,0,95,3,164,146,1,0,73,95,3,110,7,
		48,15,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ARTICULOSMODEL_EXIST )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,29,0,106,20,83,69,76,69,67,84,
		32,78,111,109,98,114,101,32,70,82,79,77,32,0,
		48,18,0,102,112,0,72,106,2,32,0,72,106,16,
		87,72,69,82,69,32,67,111,100,105,103,111,32,61,
		32,0,72,176,19,0,95,1,12,1,72,80,3,36,
		31,0,48,20,0,102,95,3,96,2,0,112,2,28,
		19,36,32,0,85,95,2,74,176,21,0,12,0,119,
		121,15,110,7,36,35,0,9,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ARTICULOSMODEL_GET )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,44,0,106,15,83,69,76,69,67,84,
		32,42,32,70,82,79,77,32,0,48,18,0,102,112,
		0,72,106,2,32,0,72,106,16,87,72,69,82,69,
		32,67,111,100,105,103,111,32,61,32,0,72,176,19,
		0,95,1,12,1,72,80,3,36,46,0,48,20,0,
		102,95,3,96,2,0,112,2,28,9,36,47,0,95,
		2,110,7,36,50,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ARTICULOSMODEL_GETVALORESPROPIEDADES )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,57,0,106,15,83,69,76,69,67,84,
		32,42,32,70,82,79,77,32,0,48,6,0,102,106,
		7,84,98,108,80,114,111,0,112,1,72,106,18,32,
		87,72,69,82,69,32,99,67,111,100,80,114,111,32,
		61,32,0,72,176,19,0,95,1,12,1,72,80,3,
		36,59,0,48,20,0,102,95,3,96,2,0,112,2,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ARTICULOSMODEL_GETPRIMERVALORPROPIEDAD )
{
	static const HB_BYTE pcode[] =
	{
		13,1,2,36,66,0,106,21,83,69,76,69,67,84,
		32,84,79,80,32,49,32,42,32,70,82,79,77,32,
		0,48,6,0,102,106,7,84,98,108,80,114,111,0,
		112,1,72,106,18,32,87,72,69,82,69,32,99,67,
		111,100,80,114,111,32,61,32,0,72,176,19,0,95,
		1,12,1,72,106,1,0,72,80,3,36,68,0,48,
		20,0,102,95,3,96,2,0,112,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( ARTICULOSMODEL_GETARTICULOSTOPRESTASHOPINFAMILIA )
{
	static const HB_BYTE pcode[] =
	{
		13,1,3,36,77,0,106,30,83,69,76,69,67,84,
		32,67,111,100,105,103,111,44,32,99,87,101,98,83,
		104,111,112,32,70,82,79,77,32,0,48,18,0,102,
		112,0,72,106,18,32,87,72,69,82,69,32,70,97,
		109,105,108,105,97,32,61,32,0,72,176,19,0,95,
		1,12,1,72,106,6,32,65,78,68,32,0,72,106,
		12,99,87,101,98,83,104,111,112,32,61,32,0,72,
		176,19,0,95,2,12,1,72,106,6,32,65,78,68,
		32,0,72,106,8,108,80,117,98,73,110,116,0,72,
		80,4,36,79,0,48,20,0,102,95,4,96,3,0,
		112,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,24,0,2,0,116,24,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

