/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\Prg\tablet\view\terceros\CustomerView.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( CUSTOMERVIEW );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( VIEWBASE );
HB_FUNC_STATIC( CUSTOMERVIEW_NEW );
HB_FUNC_EXTERN( LBLTITLE );
HB_FUNC_STATIC( CUSTOMERVIEW_INSERTCONTROLS );
HB_FUNC_STATIC( CUSTOMERVIEW_DEFINECODIGO );
HB_FUNC_STATIC( CUSTOMERVIEW_DEFINENOMBRE );
HB_FUNC_STATIC( CUSTOMERVIEW_DEFINENIF );
HB_FUNC_STATIC( CUSTOMERVIEW_DEFINEDOMICILIO );
HB_FUNC_STATIC( CUSTOMERVIEW_DEFINEPOBLACION );
HB_FUNC_STATIC( CUSTOMERVIEW_DEFINECODIGOPOSTAL );
HB_FUNC_STATIC( CUSTOMERVIEW_DEFINEPROVINCIA );
HB_FUNC_STATIC( CUSTOMERVIEW_DEFINEESTABLECIMIENTO );
HB_FUNC_STATIC( CUSTOMERVIEW_DEFINETIPOCLIENTE );
HB_FUNC_STATIC( CUSTOMERVIEW_DEFINETELEFONO );
HB_FUNC_STATIC( CUSTOMERVIEW_DEFINEEMAIL );
HB_FUNC_STATIC( CUSTOMERVIEW_DEFINERUTA );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( TGRIDSAY );
HB_FUNC_EXTERN( GRIDWIDTH );
HB_FUNC_EXTERN( OGRIDFONT );
HB_FUNC_EXTERN( TGRIDGET );
HB_FUNC_EXTERN( VALIDKEY );
HB_FUNC_EXTERN( D );
HB_FUNC_EXTERN( RETNUMCODCLIEMP );
HB_FUNC_EXTERN( REPLICATE );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( HGET );
HB_FUNC_EXTERN( TGRIDCOMBOBOX );
HB_FUNC_EXTERN( HGETVALUES );
HB_FUNC_EXTERN( TGRIDCHECKBOX );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_CUSTOMERVIEW )
{ "CUSTOMERVIEW", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "VIEWBASE", {HB_FS_PUBLIC}, {HB_FUNCNAME( VIEWBASE )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CUSTOMERVIEW_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_NEW )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LBLTITLE", {HB_FS_PUBLIC}, {HB_FUNCNAME( LBLTITLE )}, NULL },
{ "GETMODE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CUSTOMERVIEW_INSERTCONTROLS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_INSERTCONTROLS )}, NULL },
{ "CUSTOMERVIEW_DEFINECODIGO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_DEFINECODIGO )}, NULL },
{ "CUSTOMERVIEW_DEFINENOMBRE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_DEFINENOMBRE )}, NULL },
{ "CUSTOMERVIEW_DEFINENIF", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_DEFINENIF )}, NULL },
{ "CUSTOMERVIEW_DEFINEDOMICILIO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_DEFINEDOMICILIO )}, NULL },
{ "CUSTOMERVIEW_DEFINEPOBLACION", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_DEFINEPOBLACION )}, NULL },
{ "CUSTOMERVIEW_DEFINECODIGOPOSTAL", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_DEFINECODIGOPOSTAL )}, NULL },
{ "CUSTOMERVIEW_DEFINEPROVINCIA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_DEFINEPROVINCIA )}, NULL },
{ "CUSTOMERVIEW_DEFINEESTABLECIMIENTO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_DEFINEESTABLECIMIENTO )}, NULL },
{ "CUSTOMERVIEW_DEFINETIPOCLIENTE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_DEFINETIPOCLIENTE )}, NULL },
{ "CUSTOMERVIEW_DEFINETELEFONO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_DEFINETELEFONO )}, NULL },
{ "CUSTOMERVIEW_DEFINEEMAIL", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_DEFINEEMAIL )}, NULL },
{ "CUSTOMERVIEW_DEFINERUTA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( CUSTOMERVIEW_DEFINERUTA )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINECODIGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINETIPOCLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINENOMBRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINENIF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEDOMICILIO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEPOBLACION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINECODIGOPOSTAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEPROVINCIA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINETELEFONO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEEMAIL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINEESTABLECIMIENTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DEFINERUTA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BUILD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDSAY", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDSAY )}, NULL },
{ "GRIDWIDTH", {HB_FS_PUBLIC}, {HB_FUNCNAME( GRIDWIDTH )}, NULL },
{ "COLUMNLABEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODLG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OGRIDFONT", {HB_FS_PUBLIC}, {HB_FUNCNAME( OGRIDFONT )}, NULL },
{ "WIDTHLABEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDGET", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDGET )}, NULL },
{ "SETGETVALUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VALIDKEY", {HB_FS_PUBLIC}, {HB_FUNCNAME( VALIDKEY )}, NULL },
{ "CLIENTES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "D", {HB_FS_PUBLIC}, {HB_FUNCNAME( D )}, NULL },
{ "GETVIEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RETNUMCODCLIEMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( RETNUMCODCLIEMP )}, NULL },
{ "SETERRORVALIDATOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REPLICATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( REPLICATE )}, NULL },
{ "WHENCONTROL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "HGET", {HB_FS_PUBLIC}, {HB_FUNCNAME( HGET )}, NULL },
{ "HDICTIONARYMASTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDCOMBOBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDCOMBOBOX )}, NULL },
{ "CTIPOCLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CTIPOCLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HGETVALUES", {HB_FS_PUBLIC}, {HB_FUNCNAME( HGETVALUES )}, NULL },
{ "HTIPOCLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OCHECKVISLUN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGRIDCHECKBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGRIDCHECKBOX )}, NULL },
{ "_OCHECKVISMAR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OCHECKVISMIE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OCHECKVISJUE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OCHECKVISVIE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OCHECKVISSAB", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OCHECKVISDOM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_CUSTOMERVIEW, ".\\Prg\\tablet\\view\\terceros\\CustomerView.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_CUSTOMERVIEW
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_CUSTOMERVIEW )
   #include "hbiniseg.h"
#endif

HB_FUNC( CUSTOMERVIEW )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,78,0,36,5,0,103,2,0,100,8,
		29,28,4,176,1,0,104,2,0,12,1,29,17,4,
		166,211,3,0,122,80,1,48,2,0,176,3,0,12,
		0,106,13,67,117,115,116,111,109,101,114,86,105,101,
		119,0,108,4,4,1,0,108,0,112,3,80,2,36,
		7,0,48,5,0,95,2,100,100,95,1,121,72,121,
		72,121,72,106,13,111,67,104,101,99,107,86,105,115,
		76,117,110,0,4,1,0,9,112,5,73,36,8,0,
		48,5,0,95,2,100,100,95,1,121,72,121,72,121,
		72,106,13,111,67,104,101,99,107,86,105,115,77,97,
		114,0,4,1,0,9,112,5,73,36,9,0,48,5,
		0,95,2,100,100,95,1,121,72,121,72,121,72,106,
		13,111,67,104,101,99,107,86,105,115,77,105,101,0,
		4,1,0,9,112,5,73,36,10,0,48,5,0,95,
		2,100,100,95,1,121,72,121,72,121,72,106,13,111,
		67,104,101,99,107,86,105,115,74,117,101,0,4,1,
		0,9,112,5,73,36,11,0,48,5,0,95,2,100,
		100,95,1,121,72,121,72,121,72,106,13,111,67,104,
		101,99,107,86,105,115,86,105,101,0,4,1,0,9,
		112,5,73,36,12,0,48,5,0,95,2,100,100,95,
		1,121,72,121,72,121,72,106,13,111,67,104,101,99,
		107,86,105,115,83,97,98,0,4,1,0,9,112,5,
		73,36,13,0,48,5,0,95,2,100,100,95,1,121,
		72,121,72,121,72,106,13,111,67,104,101,99,107,86,
		105,115,68,111,109,0,4,1,0,9,112,5,73,36,
		15,0,48,6,0,95,2,106,4,78,101,119,0,108,
		7,95,1,121,72,121,72,121,72,112,3,73,36,17,
		0,48,8,0,95,2,106,22,103,101,116,84,101,120,
		116,111,84,105,112,111,68,111,99,117,109,101,110,116,
		111,0,89,31,0,1,0,0,0,176,9,0,48,10,
		0,95,1,112,0,12,1,106,8,99,108,105,101,110,
		116,101,0,72,6,95,1,121,72,121,72,121,72,112,
		3,73,36,19,0,48,6,0,95,2,106,15,105,110,
		115,101,114,116,67,111,110,116,114,111,108,115,0,108,
		11,95,1,121,72,121,72,121,72,112,3,73,36,21,
		0,48,6,0,95,2,106,13,100,101,102,105,110,101,
		67,111,100,105,103,111,0,108,12,95,1,121,72,121,
		72,121,72,112,3,73,36,23,0,48,6,0,95,2,
		106,13,100,101,102,105,110,101,78,111,109,98,114,101,
		0,108,13,95,1,121,72,121,72,121,72,112,3,73,
		36,25,0,48,6,0,95,2,106,10,100,101,102,105,
		110,101,78,73,70,0,108,14,95,1,121,72,121,72,
		121,72,112,3,73,36,27,0,48,6,0,95,2,106,
		16,100,101,102,105,110,101,68,111,109,105,99,105,108,
		105,111,0,108,15,95,1,121,72,121,72,121,72,112,
		3,73,36,29,0,48,6,0,95,2,106,16,100,101,
		102,105,110,101,80,111,98,108,97,99,105,111,110,0,
		108,16,95,1,121,72,121,72,121,72,112,3,73,36,
		31,0,48,6,0,95,2,106,19,100,101,102,105,110,
		101,67,111,100,105,103,111,80,111,115,116,97,108,0,
		108,17,95,1,121,72,121,72,121,72,112,3,73,36,
		33,0,48,6,0,95,2,106,16,100,101,102,105,110,
		101,80,114,111,118,105,110,99,105,97,0,108,18,95,
		1,121,72,121,72,121,72,112,3,73,36,35,0,48,
		6,0,95,2,106,22,100,101,102,105,110,101,69,115,
		116,97,98,108,101,99,105,109,105,101,110,116,111,0,
		108,19,95,1,121,72,121,72,121,72,112,3,73,36,
		37,0,48,6,0,95,2,106,18,100,101,102,105,110,
		101,84,105,112,111,67,108,105,101,110,116,101,0,108,
		20,95,1,121,72,121,72,121,72,112,3,73,36,39,
		0,48,6,0,95,2,106,15,100,101,102,105,110,101,
		84,101,108,101,102,111,110,111,0,108,21,95,1,121,
		72,121,72,121,72,112,3,73,36,41,0,48,6,0,
		95,2,106,12,100,101,102,105,110,101,69,109,97,105,
		108,0,108,22,95,1,121,72,121,72,121,72,112,3,
		73,36,43,0,48,6,0,95,2,106,11,100,101,102,
		105,110,101,82,117,116,97,0,108,23,95,1,121,72,
		121,72,121,72,112,3,73,36,45,0,48,8,0,95,
		2,106,12,119,104,101,110,67,111,110,116,114,111,108,
		0,89,18,0,1,0,0,0,48,10,0,95,1,112,
		0,92,3,69,6,95,1,121,72,121,72,121,72,112,
		3,73,36,49,0,48,24,0,95,2,112,0,73,167,
		14,0,0,176,25,0,104,2,0,95,2,20,2,168,
		48,26,0,95,2,112,0,80,3,176,27,0,95,3,
		106,10,73,110,105,116,67,108,97,115,115,0,12,2,
		28,12,48,28,0,95,3,164,146,1,0,73,95,3,
		110,7,48,26,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,55,0,48,29,0,102,95,1,112,1,
		73,36,57,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_INSERTCONTROLS )
{
	static const HB_BYTE pcode[] =
	{
		36,63,0,48,30,0,102,92,40,112,1,73,36,65,
		0,48,31,0,102,92,70,112,1,73,36,67,0,48,
		32,0,102,92,100,112,1,73,36,69,0,48,33,0,
		102,93,130,0,112,1,73,36,71,0,48,34,0,102,
		93,160,0,112,1,73,36,73,0,48,35,0,102,93,
		190,0,112,1,73,36,75,0,48,36,0,102,93,220,
		0,112,1,73,36,77,0,48,37,0,102,93,250,0,
		112,1,73,36,79,0,48,38,0,102,93,24,1,112,
		1,73,36,81,0,48,39,0,102,93,54,1,112,1,
		73,36,83,0,48,40,0,102,93,84,1,112,1,73,
		36,85,0,48,41,0,102,93,114,1,112,1,73,36,
		87,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_DEFINECODIGO )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,91,0,102,80,2,36,104,0,48,42,
		0,176,43,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,45,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,6,98,84,101,
		120,116,0,90,14,106,9,67,243,100,105,103,111,32,
		42,0,6,106,5,111,87,110,100,0,48,46,0,95,
		2,112,0,106,6,111,70,111,110,116,0,176,47,0,
		12,0,106,8,108,80,105,120,101,108,115,0,120,106,
		9,110,67,108,114,84,101,120,116,0,121,106,9,110,
		67,108,114,66,97,99,107,0,97,255,255,255,0,106,
		7,110,87,105,100,116,104,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,48,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,8,110,72,101,
		105,103,104,116,0,92,23,177,10,0,112,1,73,36,
		117,0,48,42,0,176,49,0,12,0,106,5,110,82,
		111,119,0,95,1,106,5,110,67,111,108,0,89,33,
		0,0,0,1,0,2,0,176,44,0,101,0,0,0,
		0,0,0,4,64,10,1,48,46,0,95,255,112,0,
		12,2,6,106,8,98,83,101,116,71,101,116,0,89,
		28,0,1,0,1,0,2,0,48,50,0,95,255,95,
		1,106,7,67,111,100,105,103,111,0,112,2,6,106,
		5,111,87,110,100,0,48,46,0,95,2,112,0,106,
		7,110,87,105,100,116,104,0,89,24,0,0,0,1,
		0,2,0,176,44,0,92,2,48,46,0,95,255,112,
		0,12,2,6,106,6,98,87,104,101,110,0,89,19,
		0,0,0,1,0,2,0,48,10,0,95,255,112,0,
		122,8,6,106,7,98,86,97,108,105,100,0,89,81,
		0,0,0,2,0,3,0,2,0,176,51,0,95,255,
		48,52,0,176,53,0,12,0,48,54,0,95,254,112,
		0,112,1,120,106,2,48,0,122,176,55,0,12,0,
		12,6,31,33,48,56,0,95,254,106,20,69,108,32,
		99,243,100,105,103,111,32,121,97,32,101,120,105,115,
		116,101,0,112,1,25,3,120,6,106,8,110,72,101,
		105,103,104,116,0,92,23,106,6,99,80,105,99,116,
		0,176,57,0,106,2,88,0,176,55,0,12,0,12,
		2,106,8,108,80,105,120,101,108,115,0,120,177,10,
		0,112,1,80,3,36,119,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_DEFINENIF )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,123,0,102,80,2,36,135,0,48,42,
		0,176,43,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,45,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,6,98,84,101,
		120,116,0,90,11,106,6,78,73,70,32,42,0,6,
		106,5,111,87,110,100,0,48,46,0,95,2,112,0,
		106,6,111,70,111,110,116,0,176,47,0,12,0,106,
		8,108,80,105,120,101,108,115,0,120,106,9,110,67,
		108,114,84,101,120,116,0,121,106,9,110,67,108,114,
		66,97,99,107,0,97,255,255,255,0,106,7,110,87,
		105,100,116,104,0,89,29,0,0,0,1,0,2,0,
		176,44,0,48,48,0,95,255,112,0,48,46,0,95,
		255,112,0,12,2,6,106,8,110,72,101,105,103,104,
		116,0,92,23,106,8,108,68,101,115,105,103,110,0,
		9,177,11,0,112,1,73,36,148,0,48,42,0,176,
		49,0,12,0,106,5,110,82,111,119,0,95,1,106,
		5,110,67,111,108,0,89,33,0,0,0,1,0,2,
		0,176,44,0,101,0,0,0,0,0,0,4,64,10,
		1,48,46,0,95,255,112,0,12,2,6,106,8,98,
		83,101,116,71,101,116,0,89,25,0,1,0,1,0,
		2,0,48,50,0,95,255,95,1,106,4,78,73,70,
		0,112,2,6,106,5,111,87,110,100,0,48,46,0,
		95,2,112,0,106,7,110,87,105,100,116,104,0,89,
		33,0,0,0,1,0,2,0,176,44,0,101,0,0,
		0,0,0,0,34,64,10,1,48,46,0,95,255,112,
		0,12,2,6,106,6,98,87,104,101,110,0,89,17,
		0,0,0,1,0,2,0,48,58,0,95,255,112,0,
		6,106,8,110,72,101,105,103,104,116,0,92,23,106,
		6,99,80,105,99,116,0,106,3,64,33,0,106,7,
		98,86,97,108,105,100,0,89,88,0,0,0,1,0,
		2,0,176,59,0,176,60,0,48,61,0,48,62,0,
		95,255,112,0,112,0,106,4,78,73,70,0,12,2,
		12,1,28,49,48,56,0,95,255,106,36,69,108,32,
		99,97,109,112,111,32,78,73,70,32,101,115,32,117,
		110,32,100,97,116,111,32,111,98,108,105,103,97,116,
		111,114,105,111,0,112,1,25,3,120,6,106,8,108,
		80,105,120,101,108,115,0,120,177,10,0,112,1,73,
		36,150,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_DEFINENOMBRE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,154,0,102,80,2,36,166,0,48,42,
		0,176,43,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,45,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,6,98,84,101,
		120,116,0,90,14,106,9,78,111,109,98,114,101,32,
		42,0,6,106,5,111,87,110,100,0,48,46,0,95,
		2,112,0,106,6,111,70,111,110,116,0,176,47,0,
		12,0,106,8,108,80,105,120,101,108,115,0,120,106,
		9,110,67,108,114,84,101,120,116,0,121,106,9,110,
		67,108,114,66,97,99,107,0,97,255,255,255,0,106,
		7,110,87,105,100,116,104,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,48,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,8,110,72,101,
		105,103,104,116,0,92,23,106,8,108,68,101,115,105,
		103,110,0,9,177,11,0,112,1,73,36,179,0,48,
		42,0,176,49,0,12,0,106,5,110,82,111,119,0,
		95,1,106,5,110,67,111,108,0,89,33,0,0,0,
		1,0,2,0,176,44,0,101,0,0,0,0,0,0,
		4,64,10,1,48,46,0,95,255,112,0,12,2,6,
		106,8,98,83,101,116,71,101,116,0,89,28,0,1,
		0,1,0,2,0,48,50,0,95,255,95,1,106,7,
		78,111,109,98,114,101,0,112,2,6,106,5,111,87,
		110,100,0,48,46,0,95,2,112,0,106,7,110,87,
		105,100,116,104,0,89,33,0,0,0,1,0,2,0,
		176,44,0,101,0,0,0,0,0,0,34,64,10,1,
		48,46,0,95,255,112,0,12,2,6,106,6,98,87,
		104,101,110,0,89,17,0,0,0,1,0,2,0,48,
		58,0,95,255,112,0,6,106,7,98,86,97,108,105,
		100,0,89,88,0,0,0,1,0,2,0,176,59,0,
		176,60,0,48,61,0,48,62,0,95,255,112,0,112,
		0,106,7,78,111,109,98,114,101,0,12,2,12,1,
		28,46,48,56,0,95,255,106,33,69,108,32,110,111,
		109,98,114,101,32,101,115,32,117,110,32,100,97,116,
		111,32,111,98,108,105,103,97,116,111,114,105,111,0,
		112,1,25,3,120,6,106,8,110,72,101,105,103,104,
		116,0,92,23,106,6,99,80,105,99,116,0,106,3,
		64,33,0,106,8,108,80,105,120,101,108,115,0,120,
		177,10,0,112,1,73,36,181,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_DEFINEDOMICILIO )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,185,0,102,80,2,36,197,0,48,42,
		0,176,43,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,45,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,6,98,84,101,
		120,116,0,90,15,106,10,68,111,109,105,99,105,108,
		105,111,0,6,106,5,111,87,110,100,0,48,46,0,
		95,2,112,0,106,6,111,70,111,110,116,0,176,47,
		0,12,0,106,8,108,80,105,120,101,108,115,0,120,
		106,9,110,67,108,114,84,101,120,116,0,121,106,9,
		110,67,108,114,66,97,99,107,0,97,255,255,255,0,
		106,7,110,87,105,100,116,104,0,89,29,0,0,0,
		1,0,2,0,176,44,0,48,48,0,95,255,112,0,
		48,46,0,95,255,112,0,12,2,6,106,8,110,72,
		101,105,103,104,116,0,92,23,106,8,108,68,101,115,
		105,103,110,0,9,177,11,0,112,1,73,36,207,0,
		48,42,0,176,49,0,12,0,106,5,110,82,111,119,
		0,95,1,106,5,110,67,111,108,0,89,33,0,0,
		0,1,0,2,0,176,44,0,101,0,0,0,0,0,
		0,4,64,10,1,48,46,0,95,255,112,0,12,2,
		6,106,8,98,83,101,116,71,101,116,0,89,31,0,
		1,0,1,0,2,0,48,50,0,95,255,95,1,106,
		10,68,111,109,105,99,105,108,105,111,0,112,2,6,
		106,5,111,87,110,100,0,48,46,0,95,2,112,0,
		106,7,110,87,105,100,116,104,0,89,24,0,0,0,
		1,0,2,0,176,44,0,92,9,48,46,0,95,255,
		112,0,12,2,6,106,8,110,72,101,105,103,104,116,
		0,92,23,106,6,98,87,104,101,110,0,89,17,0,
		0,0,1,0,2,0,48,58,0,95,255,112,0,6,
		106,6,99,80,105,99,116,0,106,3,64,33,0,106,
		8,108,80,105,120,101,108,115,0,120,177,9,0,112,
		1,73,36,209,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_DEFINECODIGOPOSTAL )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,213,0,102,80,2,36,225,0,48,42,
		0,176,43,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,45,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,6,98,84,101,
		120,116,0,90,16,106,11,67,111,100,32,112,111,115,
		116,97,108,0,6,106,5,111,87,110,100,0,48,46,
		0,95,2,112,0,106,6,111,70,111,110,116,0,176,
		47,0,12,0,106,8,108,80,105,120,101,108,115,0,
		120,106,9,110,67,108,114,84,101,120,116,0,121,106,
		9,110,67,108,114,66,97,99,107,0,97,255,255,255,
		0,106,7,110,87,105,100,116,104,0,89,29,0,0,
		0,1,0,2,0,176,44,0,48,48,0,95,255,112,
		0,48,46,0,95,255,112,0,12,2,6,106,8,110,
		72,101,105,103,104,116,0,92,23,106,8,108,68,101,
		115,105,103,110,0,9,177,11,0,112,1,73,36,235,
		0,48,42,0,176,49,0,12,0,106,5,110,82,111,
		119,0,95,1,106,5,110,67,111,108,0,89,33,0,
		0,0,1,0,2,0,176,44,0,101,0,0,0,0,
		0,0,4,64,10,1,48,46,0,95,255,112,0,12,
		2,6,106,8,98,83,101,116,71,101,116,0,89,34,
		0,1,0,1,0,2,0,48,50,0,95,255,95,1,
		106,13,67,111,100,105,103,111,80,111,115,116,97,108,
		0,112,2,6,106,5,111,87,110,100,0,48,46,0,
		95,2,112,0,106,7,110,87,105,100,116,104,0,89,
		24,0,0,0,1,0,2,0,176,44,0,92,9,48,
		46,0,95,255,112,0,12,2,6,106,8,110,72,101,
		105,103,104,116,0,92,23,106,6,98,87,104,101,110,
		0,89,17,0,0,0,1,0,2,0,48,58,0,95,
		255,112,0,6,106,6,99,80,105,99,116,0,106,3,
		64,33,0,106,8,108,80,105,120,101,108,115,0,120,
		177,9,0,112,1,73,36,237,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_DEFINEPOBLACION )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,241,0,102,80,2,36,253,0,48,42,
		0,176,43,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,45,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,6,98,84,101,
		120,116,0,90,15,106,10,80,111,98,108,97,99,105,
		243,110,0,6,106,5,111,87,110,100,0,48,46,0,
		95,2,112,0,106,6,111,70,111,110,116,0,176,47,
		0,12,0,106,8,108,80,105,120,101,108,115,0,120,
		106,9,110,67,108,114,84,101,120,116,0,121,106,9,
		110,67,108,114,66,97,99,107,0,97,255,255,255,0,
		106,7,110,87,105,100,116,104,0,89,29,0,0,0,
		1,0,2,0,176,44,0,48,48,0,95,255,112,0,
		48,46,0,95,255,112,0,12,2,6,106,8,110,72,
		101,105,103,104,116,0,92,23,106,8,108,68,101,115,
		105,103,110,0,9,177,11,0,112,1,73,36,7,1,
		48,42,0,176,49,0,12,0,106,5,110,82,111,119,
		0,95,1,106,5,110,67,111,108,0,89,33,0,0,
		0,1,0,2,0,176,44,0,101,0,0,0,0,0,
		0,4,64,10,1,48,46,0,95,255,112,0,12,2,
		6,106,8,98,83,101,116,71,101,116,0,89,31,0,
		1,0,1,0,2,0,48,50,0,95,255,95,1,106,
		10,80,111,98,108,97,99,105,111,110,0,112,2,6,
		106,5,111,87,110,100,0,48,46,0,95,2,112,0,
		106,7,110,87,105,100,116,104,0,89,24,0,0,0,
		1,0,2,0,176,44,0,92,9,48,46,0,95,255,
		112,0,12,2,6,106,8,110,72,101,105,103,104,116,
		0,92,23,106,6,98,87,104,101,110,0,89,17,0,
		0,0,1,0,2,0,48,58,0,95,255,112,0,6,
		106,6,99,80,105,99,116,0,106,3,64,33,0,106,
		8,108,80,105,120,101,108,115,0,120,177,9,0,112,
		1,73,36,9,1,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_DEFINEPROVINCIA )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,13,1,102,80,2,36,25,1,48,42,
		0,176,43,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,45,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,6,98,84,101,
		120,116,0,90,15,106,10,80,114,111,118,105,110,99,
		105,97,0,6,106,5,111,87,110,100,0,48,46,0,
		95,2,112,0,106,6,111,70,111,110,116,0,176,47,
		0,12,0,106,8,108,80,105,120,101,108,115,0,120,
		106,9,110,67,108,114,84,101,120,116,0,121,106,9,
		110,67,108,114,66,97,99,107,0,97,255,255,255,0,
		106,7,110,87,105,100,116,104,0,89,29,0,0,0,
		1,0,2,0,176,44,0,48,48,0,95,255,112,0,
		48,46,0,95,255,112,0,12,2,6,106,8,110,72,
		101,105,103,104,116,0,92,23,106,8,108,68,101,115,
		105,103,110,0,9,177,11,0,112,1,73,36,35,1,
		48,42,0,176,49,0,12,0,106,5,110,82,111,119,
		0,95,1,106,5,110,67,111,108,0,89,33,0,0,
		0,1,0,2,0,176,44,0,101,0,0,0,0,0,
		0,4,64,10,1,48,46,0,95,255,112,0,12,2,
		6,106,8,98,83,101,116,71,101,116,0,89,31,0,
		1,0,1,0,2,0,48,50,0,95,255,95,1,106,
		10,80,114,111,118,105,110,99,105,97,0,112,2,6,
		106,5,111,87,110,100,0,48,46,0,95,2,112,0,
		106,7,110,87,105,100,116,104,0,89,24,0,0,0,
		1,0,2,0,176,44,0,92,9,48,46,0,95,255,
		112,0,12,2,6,106,8,110,72,101,105,103,104,116,
		0,92,23,106,6,98,87,104,101,110,0,89,17,0,
		0,0,1,0,2,0,48,58,0,95,255,112,0,6,
		106,6,99,80,105,99,116,0,106,3,64,33,0,106,
		8,108,80,105,120,101,108,115,0,120,177,9,0,112,
		1,73,36,37,1,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_DEFINEESTABLECIMIENTO )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,41,1,102,80,2,36,54,1,48,42,
		0,176,43,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,45,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,6,98,84,101,
		120,116,0,90,15,106,10,69,115,116,97,98,108,101,
		99,46,0,6,106,5,111,87,110,100,0,48,46,0,
		95,2,112,0,106,6,111,70,111,110,116,0,176,47,
		0,12,0,106,8,108,80,105,120,101,108,115,0,120,
		106,9,110,67,108,114,84,101,120,116,0,121,106,9,
		110,67,108,114,66,97,99,107,0,97,255,255,255,0,
		106,7,110,87,105,100,116,104,0,89,29,0,0,0,
		1,0,2,0,176,44,0,48,48,0,95,255,112,0,
		48,46,0,95,255,112,0,12,2,6,106,8,110,72,
		101,105,103,104,116,0,92,23,106,6,98,87,104,101,
		110,0,89,17,0,0,0,1,0,2,0,48,58,0,
		95,255,112,0,6,106,8,108,68,101,115,105,103,110,
		0,9,177,12,0,112,1,73,36,64,1,48,42,0,
		176,49,0,12,0,106,5,110,82,111,119,0,95,1,
		106,5,110,67,111,108,0,89,33,0,0,0,1,0,
		2,0,176,44,0,101,0,0,0,0,0,0,4,64,
		10,1,48,46,0,95,255,112,0,12,2,6,106,8,
		98,83,101,116,71,101,116,0,89,43,0,1,0,1,
		0,2,0,48,50,0,95,255,95,1,106,22,78,111,
		109,98,114,101,69,115,116,97,98,108,101,99,105,109,
		105,101,110,116,111,0,112,2,6,106,5,111,87,110,
		100,0,48,46,0,95,2,112,0,106,7,110,87,105,
		100,116,104,0,89,24,0,0,0,1,0,2,0,176,
		44,0,92,9,48,46,0,95,255,112,0,12,2,6,
		106,8,110,72,101,105,103,104,116,0,92,23,106,6,
		98,87,104,101,110,0,89,17,0,0,0,1,0,2,
		0,48,58,0,95,255,112,0,6,106,6,99,80,105,
		99,116,0,106,3,64,33,0,106,8,108,80,105,120,
		101,108,115,0,120,177,9,0,112,1,73,36,66,1,
		95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_DEFINETIPOCLIENTE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,70,1,102,80,2,36,82,1,48,42,
		0,176,43,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,45,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,6,98,84,101,
		120,116,0,90,10,106,5,84,105,112,111,0,6,106,
		5,111,87,110,100,0,48,46,0,95,2,112,0,106,
		6,111,70,111,110,116,0,176,47,0,12,0,106,8,
		108,80,105,120,101,108,115,0,120,106,9,110,67,108,
		114,84,101,120,116,0,121,106,9,110,67,108,114,66,
		97,99,107,0,97,255,255,255,0,106,7,110,87,105,
		100,116,104,0,89,29,0,0,0,1,0,2,0,176,
		44,0,48,48,0,95,255,112,0,48,46,0,95,255,
		112,0,12,2,6,106,8,110,72,101,105,103,104,116,
		0,92,23,106,8,108,68,101,115,105,103,110,0,9,
		177,11,0,112,1,73,36,92,1,48,42,0,176,63,
		0,12,0,106,5,110,82,111,119,0,95,1,106,5,
		110,67,111,108,0,89,33,0,0,0,1,0,2,0,
		176,44,0,101,0,0,0,0,0,0,4,64,10,1,
		48,46,0,95,255,112,0,12,2,6,106,8,98,83,
		101,116,71,101,116,0,89,47,0,1,0,1,0,2,
		0,176,59,0,95,1,12,1,28,16,48,64,0,48,
		62,0,95,255,112,0,112,0,25,16,48,65,0,48,
		62,0,95,255,112,0,95,1,112,1,6,106,5,111,
		87,110,100,0,48,46,0,95,2,112,0,106,7,110,
		87,105,100,116,104,0,89,24,0,0,0,1,0,2,
		0,176,44,0,92,9,48,46,0,95,255,112,0,12,
		2,6,106,8,110,72,101,105,103,104,116,0,92,25,
		106,6,98,87,104,101,110,0,89,17,0,0,0,1,
		0,2,0,48,58,0,95,255,112,0,6,106,7,97,
		73,116,101,109,115,0,176,66,0,48,67,0,48,62,
		0,95,2,112,0,112,0,12,1,177,8,0,112,1,
		73,36,94,1,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_DEFINETELEFONO )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,98,1,102,80,2,36,111,1,48,42,
		0,176,43,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,45,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,6,98,84,101,
		120,116,0,90,14,106,9,84,101,108,233,102,111,110,
		111,0,6,106,5,111,87,110,100,0,48,46,0,95,
		2,112,0,106,6,111,70,111,110,116,0,176,47,0,
		12,0,106,8,108,80,105,120,101,108,115,0,120,106,
		9,110,67,108,114,84,101,120,116,0,121,106,9,110,
		67,108,114,66,97,99,107,0,97,255,255,255,0,106,
		7,110,87,105,100,116,104,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,48,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,8,110,72,101,
		105,103,104,116,0,92,23,106,6,98,87,104,101,110,
		0,89,17,0,0,0,1,0,2,0,48,58,0,95,
		255,112,0,6,106,8,108,68,101,115,105,103,110,0,
		9,177,12,0,112,1,73,36,121,1,48,42,0,176,
		49,0,12,0,106,5,110,82,111,119,0,95,1,106,
		5,110,67,111,108,0,89,33,0,0,0,1,0,2,
		0,176,44,0,101,0,0,0,0,0,0,4,64,10,
		1,48,46,0,95,255,112,0,12,2,6,106,8,98,
		83,101,116,71,101,116,0,89,30,0,1,0,1,0,
		2,0,48,50,0,95,255,95,1,106,9,84,101,108,
		101,102,111,110,111,0,112,2,6,106,5,111,87,110,
		100,0,48,46,0,95,2,112,0,106,7,110,87,105,
		100,116,104,0,89,24,0,0,0,1,0,2,0,176,
		44,0,92,9,48,46,0,95,255,112,0,12,2,6,
		106,8,110,72,101,105,103,104,116,0,92,23,106,6,
		98,87,104,101,110,0,89,17,0,0,0,1,0,2,
		0,48,58,0,95,255,112,0,6,106,6,99,80,105,
		99,116,0,106,3,64,33,0,106,8,108,80,105,120,
		101,108,115,0,120,177,9,0,112,1,73,36,123,1,
		95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_DEFINEEMAIL )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,127,1,102,80,2,36,139,1,48,42,
		0,176,43,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,45,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,6,98,84,101,
		120,116,0,90,12,106,7,69,45,109,97,105,108,0,
		6,106,5,111,87,110,100,0,48,46,0,95,2,112,
		0,106,6,111,70,111,110,116,0,176,47,0,12,0,
		106,8,108,80,105,120,101,108,115,0,120,106,9,110,
		67,108,114,84,101,120,116,0,121,106,9,110,67,108,
		114,66,97,99,107,0,97,255,255,255,0,106,7,110,
		87,105,100,116,104,0,89,29,0,0,0,1,0,2,
		0,176,44,0,48,48,0,95,255,112,0,48,46,0,
		95,255,112,0,12,2,6,106,8,110,72,101,105,103,
		104,116,0,92,23,106,8,108,68,101,115,105,103,110,
		0,9,177,11,0,112,1,73,36,148,1,48,42,0,
		176,49,0,12,0,106,5,110,82,111,119,0,95,1,
		106,5,110,67,111,108,0,89,33,0,0,0,1,0,
		2,0,176,44,0,101,0,0,0,0,0,0,4,64,
		10,1,48,46,0,95,255,112,0,12,2,6,106,8,
		98,83,101,116,71,101,116,0,89,27,0,1,0,1,
		0,2,0,48,50,0,95,255,95,1,106,6,69,109,
		97,105,108,0,112,2,6,106,5,111,87,110,100,0,
		48,46,0,95,2,112,0,106,7,110,87,105,100,116,
		104,0,89,24,0,0,0,1,0,2,0,176,44,0,
		92,9,48,46,0,95,255,112,0,12,2,6,106,8,
		110,72,101,105,103,104,116,0,92,23,106,6,98,87,
		104,101,110,0,89,17,0,0,0,1,0,2,0,48,
		58,0,95,255,112,0,6,106,8,108,80,105,120,101,
		108,115,0,120,177,8,0,112,1,73,36,150,1,95,
		2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( CUSTOMERVIEW_DEFINERUTA )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,154,1,102,80,2,36,166,1,48,42,
		0,176,43,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,29,0,0,0,1,
		0,2,0,176,44,0,48,45,0,95,255,112,0,48,
		46,0,95,255,112,0,12,2,6,106,6,98,84,101,
		120,116,0,90,11,106,6,82,117,116,97,32,0,6,
		106,5,111,87,110,100,0,48,46,0,95,2,112,0,
		106,6,111,70,111,110,116,0,176,47,0,12,0,106,
		8,108,80,105,120,101,108,115,0,120,106,9,110,67,
		108,114,84,101,120,116,0,121,106,9,110,67,108,114,
		66,97,99,107,0,97,255,255,255,0,106,7,110,87,
		105,100,116,104,0,89,29,0,0,0,1,0,2,0,
		176,44,0,48,48,0,95,255,112,0,48,46,0,95,
		255,112,0,12,2,6,106,8,110,72,101,105,103,104,
		116,0,92,23,106,8,108,68,101,115,105,103,110,0,
		9,177,11,0,112,1,73,36,178,1,48,68,0,95,
		2,48,42,0,176,69,0,12,0,106,5,110,82,111,
		119,0,95,1,106,5,110,67,111,108,0,89,33,0,
		0,0,1,0,2,0,176,44,0,101,0,0,0,0,
		0,0,4,64,10,1,48,46,0,95,255,112,0,12,
		2,6,106,9,99,67,97,112,116,105,111,110,0,106,
		3,32,76,0,106,8,98,83,101,116,71,101,116,0,
		89,29,0,1,0,1,0,2,0,48,50,0,95,255,
		95,1,106,8,108,86,105,115,76,117,110,0,112,2,
		6,106,5,111,87,110,100,0,48,46,0,95,2,112,
		0,106,7,110,87,105,100,116,104,0,89,23,0,0,
		0,1,0,2,0,176,44,0,122,48,46,0,95,255,
		112,0,12,2,6,106,8,110,72,101,105,103,104,116,
		0,92,23,106,6,98,87,104,101,110,0,89,17,0,
		0,0,1,0,2,0,48,58,0,95,255,112,0,6,
		106,6,111,70,111,110,116,0,176,47,0,12,0,106,
		8,108,80,105,120,101,108,115,0,120,177,10,0,112,
		1,112,1,73,36,189,1,48,70,0,95,2,48,42,
		0,176,69,0,12,0,106,5,110,82,111,119,0,95,
		1,106,5,110,67,111,108,0,89,33,0,0,0,1,
		0,2,0,176,44,0,101,0,0,0,0,0,0,12,
		64,10,1,48,46,0,95,255,112,0,12,2,6,106,
		9,99,67,97,112,116,105,111,110,0,106,3,32,77,
		0,106,8,98,83,101,116,71,101,116,0,89,29,0,
		1,0,1,0,2,0,48,50,0,95,255,95,1,106,
		8,108,86,105,115,77,97,114,0,112,2,6,106,5,
		111,87,110,100,0,48,46,0,95,2,112,0,106,7,
		110,87,105,100,116,104,0,89,23,0,0,0,1,0,
		2,0,176,44,0,122,48,46,0,95,255,112,0,12,
		2,6,106,8,110,72,101,105,103,104,116,0,92,23,
		106,6,98,87,104,101,110,0,89,17,0,0,0,1,
		0,2,0,48,58,0,95,255,112,0,6,106,6,111,
		70,111,110,116,0,176,47,0,12,0,106,8,108,80,
		105,120,101,108,115,0,120,177,10,0,112,1,112,1,
		73,36,200,1,48,71,0,95,2,48,42,0,176,69,
		0,12,0,106,5,110,82,111,119,0,95,1,106,5,
		110,67,111,108,0,89,33,0,0,0,1,0,2,0,
		176,44,0,101,0,0,0,0,0,0,18,64,10,1,
		48,46,0,95,255,112,0,12,2,6,106,9,99,67,
		97,112,116,105,111,110,0,106,3,32,88,0,106,8,
		98,83,101,116,71,101,116,0,89,29,0,1,0,1,
		0,2,0,48,50,0,95,255,95,1,106,8,108,86,
		105,115,77,105,101,0,112,2,6,106,5,111,87,110,
		100,0,48,46,0,95,2,112,0,106,7,110,87,105,
		100,116,104,0,89,23,0,0,0,1,0,2,0,176,
		44,0,122,48,46,0,95,255,112,0,12,2,6,106,
		8,110,72,101,105,103,104,116,0,92,23,106,6,98,
		87,104,101,110,0,89,17,0,0,0,1,0,2,0,
		48,58,0,95,255,112,0,6,106,6,111,70,111,110,
		116,0,176,47,0,12,0,106,8,108,80,105,120,101,
		108,115,0,120,177,10,0,112,1,112,1,73,36,211,
		1,48,72,0,95,2,48,42,0,176,69,0,12,0,
		106,5,110,82,111,119,0,95,1,106,5,110,67,111,
		108,0,89,33,0,0,0,1,0,2,0,176,44,0,
		101,0,0,0,0,0,0,22,64,10,1,48,46,0,
		95,255,112,0,12,2,6,106,9,99,67,97,112,116,
		105,111,110,0,106,3,32,74,0,106,8,98,83,101,
		116,71,101,116,0,89,29,0,1,0,1,0,2,0,
		48,50,0,95,255,95,1,106,8,108,86,105,115,74,
		117,101,0,112,2,6,106,5,111,87,110,100,0,48,
		46,0,95,2,112,0,106,7,110,87,105,100,116,104,
		0,89,23,0,0,0,1,0,2,0,176,44,0,122,
		48,46,0,95,255,112,0,12,2,6,106,8,110,72,
		101,105,103,104,116,0,92,23,106,6,98,87,104,101,
		110,0,89,17,0,0,0,1,0,2,0,48,58,0,
		95,255,112,0,6,106,6,111,70,111,110,116,0,176,
		47,0,12,0,106,8,108,80,105,120,101,108,115,0,
		120,177,10,0,112,1,112,1,73,36,222,1,48,73,
		0,95,2,48,42,0,176,69,0,12,0,106,5,110,
		82,111,119,0,95,1,106,5,110,67,111,108,0,89,
		33,0,0,0,1,0,2,0,176,44,0,101,0,0,
		0,0,0,0,26,64,10,1,48,46,0,95,255,112,
		0,12,2,6,106,9,99,67,97,112,116,105,111,110,
		0,106,3,32,86,0,106,8,98,83,101,116,71,101,
		116,0,89,29,0,1,0,1,0,2,0,48,50,0,
		95,255,95,1,106,8,108,86,105,115,86,105,101,0,
		112,2,6,106,5,111,87,110,100,0,48,46,0,95,
		2,112,0,106,7,110,87,105,100,116,104,0,89,23,
		0,0,0,1,0,2,0,176,44,0,122,48,46,0,
		95,255,112,0,12,2,6,106,8,110,72,101,105,103,
		104,116,0,92,23,106,6,98,87,104,101,110,0,89,
		17,0,0,0,1,0,2,0,48,58,0,95,255,112,
		0,6,106,6,111,70,111,110,116,0,176,47,0,12,
		0,106,8,108,80,105,120,101,108,115,0,120,177,10,
		0,112,1,112,1,73,36,233,1,48,74,0,95,2,
		48,42,0,176,69,0,12,0,106,5,110,82,111,119,
		0,95,1,106,5,110,67,111,108,0,89,33,0,0,
		0,1,0,2,0,176,44,0,101,0,0,0,0,0,
		0,30,64,10,1,48,46,0,95,255,112,0,12,2,
		6,106,9,99,67,97,112,116,105,111,110,0,106,3,
		32,83,0,106,8,98,83,101,116,71,101,116,0,89,
		29,0,1,0,1,0,2,0,48,50,0,95,255,95,
		1,106,8,108,86,105,115,83,97,98,0,112,2,6,
		106,5,111,87,110,100,0,48,46,0,95,2,112,0,
		106,7,110,87,105,100,116,104,0,89,23,0,0,0,
		1,0,2,0,176,44,0,122,48,46,0,95,255,112,
		0,12,2,6,106,8,110,72,101,105,103,104,116,0,
		92,23,106,6,98,87,104,101,110,0,89,17,0,0,
		0,1,0,2,0,48,58,0,95,255,112,0,6,106,
		6,111,70,111,110,116,0,176,47,0,12,0,106,8,
		108,80,105,120,101,108,115,0,120,177,10,0,112,1,
		112,1,73,36,244,1,48,75,0,95,2,48,42,0,
		176,69,0,12,0,106,5,110,82,111,119,0,95,1,
		106,5,110,67,111,108,0,89,33,0,0,0,1,0,
		2,0,176,44,0,101,0,0,0,0,0,0,33,64,
		10,1,48,46,0,95,255,112,0,12,2,6,106,9,
		99,67,97,112,116,105,111,110,0,106,3,32,68,0,
		106,8,98,83,101,116,71,101,116,0,89,29,0,1,
		0,1,0,2,0,48,50,0,95,255,95,1,106,8,
		108,86,105,115,68,111,109,0,112,2,6,106,5,111,
		87,110,100,0,48,46,0,95,2,112,0,106,7,110,
		87,105,100,116,104,0,89,23,0,0,0,1,0,2,
		0,176,44,0,122,48,46,0,95,255,112,0,12,2,
		6,106,8,110,72,101,105,103,104,116,0,92,23,106,
		6,98,87,104,101,110,0,89,17,0,0,0,1,0,
		2,0,48,58,0,95,255,112,0,6,106,6,111,70,
		111,110,116,0,176,47,0,12,0,106,8,108,80,105,
		120,101,108,115,0,120,177,10,0,112,1,112,1,73,
		36,246,1,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,78,0,2,0,116,78,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

