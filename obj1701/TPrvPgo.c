/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\TPrvPgo.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TPRVPGO );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TINFGEN );
HB_FUNC_STATIC( TPRVPGO_CREATEFIELDS );
HB_FUNC_STATIC( TPRVPGO_ANUPGOFIELDS );
HB_FUNC_STATIC( TPRVPGO_ACUCREATE );
HB_FUNC_STATIC( TPRVPGO_ADDPED );
HB_FUNC_STATIC( TPRVPGO_ADDALB );
HB_FUNC_STATIC( TPRVPGO_ADDFAC );
HB_FUNC_STATIC( TPRVPGO_INCLUYECERO );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( MASUND );
HB_FUNC_EXTERN( CNOMBRECAJAS );
HB_FUNC_EXTERN( CNOMBREUNIDADES );
HB_FUNC_EXTERN( CIMP );
HB_FUNC_EXTERN( CNBRFPAGO );
HB_FUNC_EXTERN( NTOTNPEDPRV );
HB_FUNC_EXTERN( NTOTUPEDPRV );
HB_FUNC_EXTERN( NIMPLPEDPRV );
HB_FUNC_EXTERN( NIVALPEDPRV );
HB_FUNC_EXTERN( RETPROP );
HB_FUNC_EXTERN( RETVALPROP );
HB_FUNC_EXTERN( LTRIM );
HB_FUNC_EXTERN( STR );
HB_FUNC_EXTERN( NTOTNALBPRV );
HB_FUNC_EXTERN( NTOTUALBPRV );
HB_FUNC_EXTERN( NIMPLALBPRV );
HB_FUNC_EXTERN( NIVALALBPRV );
HB_FUNC_EXTERN( NTOTNFACPRV );
HB_FUNC_EXTERN( NTOTUFACPRV );
HB_FUNC_EXTERN( NIMPLFACPRV );
HB_FUNC_EXTERN( NIVALFACPRV );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TPRVPGO )
{ "TPRVPGO", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TPRVPGO )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TINFGEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( TINFGEN )}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TPRVPGO_CREATEFIELDS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TPRVPGO_CREATEFIELDS )}, NULL },
{ "TPRVPGO_ANUPGOFIELDS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TPRVPGO_ANUPGOFIELDS )}, NULL },
{ "TPRVPGO_ACUCREATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TPRVPGO_ACUCREATE )}, NULL },
{ "TPRVPGO_ADDPED", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TPRVPGO_ADDPED )}, NULL },
{ "TPRVPGO_ADDALB", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TPRVPGO_ADDALB )}, NULL },
{ "TPRVPGO_ADDFAC", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TPRVPGO_ADDFAC )}, NULL },
{ "TPRVPGO_INCLUYECERO", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TPRVPGO_INCLUYECERO )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDFIELD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FLDPROPIEDADES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FLDPROVEEDOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MASUND", {HB_FS_PUBLIC}, {HB_FUNCNAME( MASUND )}, NULL },
{ "CNOMBRECAJAS", {HB_FS_PUBLIC}, {HB_FUNCNAME( CNOMBRECAJAS )}, NULL },
{ "CNOMBREUNIDADES", {HB_FS_PUBLIC}, {HB_FUNCNAME( CNOMBREUNIDADES )}, NULL },
{ "CPICIMP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPICOUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CIMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( CIMP )}, NULL },
{ "SEEK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODPGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OPEDPRVT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCODPGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMPGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CNBRFPAGO", {HB_FS_PUBLIC}, {HB_FUNCNAME( CNBRFPAGO )}, NULL },
{ "ODBFFPG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NNUMUNI", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NTOTNPEDPRV", {HB_FS_PUBLIC}, {HB_FUNCNAME( NTOTNPEDPRV )}, NULL },
{ "OPEDPRVL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NIMPART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NTOTUPEDPRV", {HB_FS_PUBLIC}, {HB_FUNCNAME( NTOTUPEDPRV )}, NULL },
{ "CALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NDECOUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NVALDIV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NIMPTOT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NIMPLPEDPRV", {HB_FS_PUBLIC}, {HB_FUNCNAME( NIMPLPEDPRV )}, NULL },
{ "NDEROUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NIVATOT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NIVALPEDPRV", {HB_FS_PUBLIC}, {HB_FUNCNAME( NIVALPEDPRV )}, NULL },
{ "_NTOTFIN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NIMPTOT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NIVATOT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ACUPESVOL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDPROVEEDOR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODPRV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCODART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDETALLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCODPR1", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODPR1", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMPR1", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RETPROP", {HB_FS_PUBLIC}, {HB_FUNCNAME( RETPROP )}, NULL },
{ "_CCODPR2", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODPR2", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMPR2", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CVALPR1", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CVALPR1", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMVL1", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RETVALPROP", {HB_FS_PUBLIC}, {HB_FUNCNAME( RETVALPROP )}, NULL },
{ "_CVALPR2", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CVALPR2", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMVL2", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NNUMCAJ", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NCANPED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NUNIDAD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NUNICAJA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CDOCMOV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( LTRIM )}, NULL },
{ "CSERPED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "STR", {HB_FS_PUBLIC}, {HB_FUNCNAME( STR )}, NULL },
{ "NNUMPED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CSUFPED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_DFECMOV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DFECPED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LOAD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NNUMUNI", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NIMPART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NPREMED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NTOTFIN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OALBPRVT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NTOTNALBPRV", {HB_FS_PUBLIC}, {HB_FUNCNAME( NTOTNALBPRV )}, NULL },
{ "OALBPRVL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NTOTUALBPRV", {HB_FS_PUBLIC}, {HB_FUNCNAME( NTOTUALBPRV )}, NULL },
{ "NIMPLALBPRV", {HB_FS_PUBLIC}, {HB_FUNCNAME( NIMPLALBPRV )}, NULL },
{ "NIVALALBPRV", {HB_FS_PUBLIC}, {HB_FUNCNAME( NIVALALBPRV )}, NULL },
{ "NCANENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CSERALB", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NNUMALB", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CSUFALB", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DFECALB", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODPAGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OFACPRVT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NTOTNFACPRV", {HB_FS_PUBLIC}, {HB_FUNCNAME( NTOTNFACPRV )}, NULL },
{ "OFACPRVL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NTOTUFACPRV", {HB_FS_PUBLIC}, {HB_FUNCNAME( NTOTUFACPRV )}, NULL },
{ "NIMPLFACPRV", {HB_FS_PUBLIC}, {HB_FUNCNAME( NIMPLFACPRV )}, NULL },
{ "NIVALFACPRV", {HB_FS_PUBLIC}, {HB_FUNCNAME( NIVALFACPRV )}, NULL },
{ "CSERFAC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NNUMFAC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CSUFFAC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DFECFAC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LALLFPG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CFPGDES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CFPGHAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BLANK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDESPAGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SKIP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TPRVPGO, ".\\.\\Prg\\TPrvPgo.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TPRVPGO
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TPRVPGO )
   #include "hbiniseg.h"
#endif

HB_FUNC( TPRVPGO )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,123,0,36,8,0,103,2,0,100,8,
		29,94,1,176,1,0,104,2,0,12,1,29,83,1,
		166,21,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,8,84,80,114,118,80,103,111,0,108,4,4,
		1,0,108,0,112,3,80,2,36,10,0,48,5,0,
		95,2,106,13,67,114,101,97,116,101,70,105,101,108,
		100,115,0,108,6,95,1,121,72,121,72,121,72,112,
		3,73,36,12,0,48,5,0,95,2,106,13,65,110,
		117,80,103,111,70,105,101,108,100,115,0,108,7,95,
		1,121,72,121,72,121,72,112,3,73,36,14,0,48,
		5,0,95,2,106,10,65,99,117,67,114,101,97,116,
		101,0,108,8,95,1,121,72,121,72,121,72,112,3,
		73,36,16,0,48,5,0,95,2,106,7,65,100,100,
		80,101,100,0,108,9,95,1,121,72,121,72,121,72,
		112,3,73,36,18,0,48,5,0,95,2,106,7,65,
		100,100,65,108,98,0,108,10,95,1,121,72,121,72,
		121,72,112,3,73,36,20,0,48,5,0,95,2,106,
		7,65,100,100,70,97,99,0,108,11,95,1,121,72,
		121,72,121,72,112,3,73,36,22,0,48,5,0,95,
		2,106,12,73,110,99,108,117,121,101,67,101,114,111,
		0,108,12,95,1,121,72,121,72,121,72,112,3,73,
		36,24,0,48,13,0,95,2,112,0,73,167,14,0,
		0,176,14,0,104,2,0,95,2,20,2,168,48,15,
		0,95,2,112,0,80,3,176,16,0,95,3,106,10,
		73,110,105,116,67,108,97,115,115,0,12,2,28,12,
		48,17,0,95,3,164,146,1,0,73,95,3,110,7,
		48,15,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TPRVPGO_CREATEFIELDS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,28,0,102,80,1,36,31,0,48,18,
		0,95,1,106,8,99,67,111,100,80,103,111,0,106,
		2,67,0,92,2,121,90,6,106,1,0,6,106,5,
		80,103,111,46,0,9,106,5,80,103,111,46,0,92,
		3,9,112,10,73,36,32,0,48,18,0,95,1,106,
		8,99,78,111,109,80,103,111,0,106,2,67,0,92,
		40,121,90,8,106,3,64,33,0,6,106,14,70,111,
		114,109,97,32,100,101,32,112,97,103,111,0,9,106,
		15,70,111,114,109,97,115,32,100,101,32,112,97,103,
		111,0,92,40,9,112,10,73,36,33,0,48,18,0,
		95,1,106,8,99,67,111,100,65,114,116,0,106,2,
		67,0,92,18,121,90,8,106,3,64,33,0,6,106,
		5,65,114,116,46,0,9,106,14,67,111,100,46,32,
		97,114,116,237,99,117,108,111,0,92,14,9,112,10,
		73,36,34,0,48,18,0,95,1,106,8,99,78,111,
		109,65,114,116,0,106,2,67,0,92,100,121,90,8,
		106,3,64,33,0,6,106,9,65,114,116,237,99,117,
		108,111,0,9,106,9,65,114,116,237,99,117,108,111,
		0,92,40,9,112,10,73,36,35,0,48,19,0,95,
		1,112,0,73,36,36,0,48,20,0,95,1,112,0,
		73,36,37,0,48,18,0,95,1,106,8,110,78,117,
		109,67,97,106,0,106,2,78,0,92,16,92,6,90,
		8,176,21,0,12,0,6,176,22,0,12,0,9,176,
		22,0,12,0,92,12,120,112,10,73,36,38,0,48,
		18,0,95,1,106,8,110,85,110,105,68,97,100,0,
		106,2,78,0,92,16,92,6,90,8,176,21,0,12,
		0,6,176,23,0,12,0,9,176,23,0,12,0,92,
		12,120,112,10,73,36,39,0,48,18,0,95,1,106,
		8,110,78,117,109,85,110,105,0,106,2,78,0,92,
		16,92,6,90,8,176,21,0,12,0,6,106,6,84,
		111,116,46,32,0,176,23,0,12,0,72,120,106,7,
		84,111,116,97,108,32,0,176,23,0,12,0,72,92,
		12,120,112,10,73,36,40,0,48,18,0,95,1,106,
		8,110,73,109,112,65,114,116,0,106,2,78,0,92,
		16,92,6,89,17,0,0,0,1,0,1,0,48,24,
		0,95,255,112,0,6,106,7,80,114,101,99,105,111,
		0,120,106,7,80,114,101,99,105,111,0,92,12,9,
		112,10,73,36,41,0,48,18,0,95,1,106,8,110,
		73,109,112,84,111,116,0,106,2,78,0,92,16,92,
		6,89,17,0,0,0,1,0,1,0,48,25,0,95,
		255,112,0,6,106,5,66,97,115,101,0,120,106,5,
		66,97,115,101,0,92,12,120,112,10,73,36,42,0,
		48,18,0,95,1,106,8,110,84,111,116,80,101,115,
		0,106,2,78,0,92,16,92,6,90,8,176,21,0,
		12,0,6,106,10,84,111,116,46,32,112,101,115,111,
		0,9,106,11,84,111,116,97,108,32,112,101,115,111,
		0,92,12,120,112,10,73,36,43,0,48,18,0,95,
		1,106,8,110,80,114,101,75,103,114,0,106,2,78,
		0,92,16,92,6,89,17,0,0,0,1,0,1,0,
		48,24,0,95,255,112,0,6,106,9,80,114,101,46,
		32,75,103,46,0,9,106,12,80,114,101,99,105,111,
		32,107,105,108,111,0,92,12,9,112,10,73,36,44,
		0,48,18,0,95,1,106,8,110,84,111,116,86,111,
		108,0,106,2,78,0,92,16,92,6,90,8,176,21,
		0,12,0,6,106,13,84,111,116,46,32,118,111,108,
		117,109,101,110,0,9,106,14,84,111,116,97,108,32,
		118,111,108,117,109,101,110,0,92,12,120,112,10,73,
		36,45,0,48,18,0,95,1,106,8,110,80,114,101,
		86,111,108,0,106,2,78,0,92,16,92,6,89,17,
		0,0,0,1,0,1,0,48,24,0,95,255,112,0,
		6,106,10,80,114,101,46,32,118,111,108,46,0,9,
		106,15,80,114,101,99,105,111,32,118,111,108,117,109,
		101,110,0,92,12,9,112,10,73,36,46,0,48,18,
		0,95,1,106,8,110,73,118,97,84,111,116,0,106,
		2,78,0,92,16,92,6,89,17,0,0,0,1,0,
		1,0,48,25,0,95,255,112,0,6,176,26,0,12,
		0,120,176,26,0,12,0,92,12,120,112,10,73,36,
		47,0,48,18,0,95,1,106,8,110,84,111,116,70,
		105,110,0,106,2,78,0,92,16,92,6,89,17,0,
		0,0,1,0,1,0,48,25,0,95,255,112,0,6,
		106,6,84,111,116,97,108,0,120,106,6,84,111,116,
		97,108,0,92,12,120,112,10,73,36,48,0,48,18,
		0,95,1,106,8,99,68,111,99,77,111,118,0,106,
		2,67,0,92,14,121,90,8,106,3,64,33,0,6,
		106,5,68,111,99,46,0,120,106,10,68,111,99,117,
		109,101,110,116,111,0,92,8,9,112,10,73,36,49,
		0,48,18,0,95,1,106,8,99,84,105,112,68,111,
		99,0,106,2,67,0,92,20,121,90,8,106,3,64,
		33,0,6,106,5,84,105,112,111,0,9,106,18,84,
		105,112,111,32,100,101,32,100,111,99,117,109,101,110,
		116,111,0,92,10,9,112,10,73,36,50,0,48,18,
		0,95,1,106,8,100,70,101,99,77,111,118,0,106,
		2,68,0,92,8,121,90,8,106,3,64,33,0,6,
		106,6,70,101,99,104,97,0,120,106,6,70,101,99,
		104,97,0,92,10,9,112,10,73,36,52,0,95,1,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TPRVPGO_ANUPGOFIELDS )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,56,0,102,80,1,36,59,0,48,18,
		0,95,1,106,8,99,67,111,100,80,103,111,0,106,
		2,67,0,92,2,121,90,6,106,1,0,6,106,5,
		80,103,111,46,0,120,106,5,80,103,111,46,0,92,
		3,112,9,73,36,60,0,48,18,0,95,1,106,8,
		99,78,111,109,80,103,111,0,106,2,67,0,92,40,
		121,90,8,106,3,64,33,0,6,106,14,70,111,114,
		109,97,32,100,101,32,112,97,103,111,0,120,106,15,
		70,111,114,109,97,115,32,100,101,32,112,97,103,111,
		0,92,40,112,9,73,36,61,0,48,18,0,95,1,
		106,8,110,73,109,112,69,110,101,0,106,2,78,0,
		92,16,92,6,89,17,0,0,0,1,0,1,0,48,
		25,0,95,255,112,0,6,106,4,69,110,101,0,120,
		106,6,69,110,101,114,111,0,92,12,112,9,73,36,
		62,0,48,18,0,95,1,106,8,110,73,109,112,70,
		101,98,0,106,2,78,0,92,16,92,6,89,17,0,
		0,0,1,0,1,0,48,25,0,95,255,112,0,6,
		106,4,70,101,98,0,120,106,8,70,101,98,114,101,
		114,111,0,92,12,112,9,73,36,63,0,48,18,0,
		95,1,106,8,110,73,109,112,77,97,114,0,106,2,
		78,0,92,16,92,6,89,17,0,0,0,1,0,1,
		0,48,25,0,95,255,112,0,6,106,4,77,97,114,
		0,120,106,6,77,97,114,122,111,0,92,12,112,9,
		73,36,64,0,48,18,0,95,1,106,8,110,73,109,
		112,65,98,114,0,106,2,78,0,92,16,92,6,89,
		17,0,0,0,1,0,1,0,48,25,0,95,255,112,
		0,6,106,4,65,98,114,0,120,106,6,65,98,114,
		105,108,0,92,12,112,9,73,36,65,0,48,18,0,
		95,1,106,8,110,73,109,112,77,97,121,0,106,2,
		78,0,92,16,92,6,89,17,0,0,0,1,0,1,
		0,48,25,0,95,255,112,0,6,106,4,77,97,121,
		0,120,106,5,77,97,121,111,0,92,12,112,9,73,
		36,66,0,48,18,0,95,1,106,8,110,73,109,112,
		74,117,110,0,106,2,78,0,92,16,92,6,89,17,
		0,0,0,1,0,1,0,48,25,0,95,255,112,0,
		6,106,4,74,117,110,0,120,106,6,74,117,110,105,
		111,0,92,12,112,9,73,36,67,0,48,18,0,95,
		1,106,8,110,73,109,112,74,117,108,0,106,2,78,
		0,92,16,92,6,89,17,0,0,0,1,0,1,0,
		48,25,0,95,255,112,0,6,106,4,74,117,108,0,
		120,106,6,74,117,108,105,111,0,92,12,112,9,73,
		36,68,0,48,18,0,95,1,106,8,110,73,109,112,
		65,103,111,0,106,2,78,0,92,16,92,6,89,17,
		0,0,0,1,0,1,0,48,25,0,95,255,112,0,
		6,106,4,65,103,111,0,120,106,7,65,103,111,115,
		116,111,0,92,12,112,9,73,36,69,0,48,18,0,
		95,1,106,8,110,73,109,112,83,101,112,0,106,2,
		78,0,92,16,92,6,89,17,0,0,0,1,0,1,
		0,48,25,0,95,255,112,0,6,106,4,83,101,112,
		0,120,106,11,83,101,112,116,105,101,109,98,114,101,
		0,92,12,112,9,73,36,70,0,48,18,0,95,1,
		106,8,110,73,109,112,79,99,116,0,106,2,78,0,
		92,16,92,6,89,17,0,0,0,1,0,1,0,48,
		25,0,95,255,112,0,6,106,4,79,99,116,0,120,
		106,8,79,99,116,117,98,114,101,0,92,12,112,9,
		73,36,71,0,48,18,0,95,1,106,8,110,73,109,
		112,78,111,118,0,106,2,78,0,92,16,92,6,89,
		17,0,0,0,1,0,1,0,48,25,0,95,255,112,
		0,6,106,4,78,111,118,0,120,106,10,78,111,118,
		105,101,109,98,114,101,0,92,12,112,9,73,36,72,
		0,48,18,0,95,1,106,8,110,73,109,112,68,105,
		99,0,106,2,78,0,92,16,92,6,89,17,0,0,
		0,1,0,1,0,48,25,0,95,255,112,0,6,106,
		4,68,105,99,0,120,106,10,68,105,99,105,101,109,
		98,114,101,0,92,12,112,9,73,36,73,0,48,18,
		0,95,1,106,8,110,73,109,112,84,111,116,0,106,
		2,78,0,92,16,92,6,89,17,0,0,0,1,0,
		1,0,48,25,0,95,255,112,0,6,106,4,84,111,
		116,0,120,106,6,84,111,116,97,108,0,92,12,112,
		9,73,36,75,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TPRVPGO_ACUCREATE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,79,0,102,80,1,36,81,0,48,18,
		0,95,1,106,8,99,67,111,100,80,103,111,0,106,
		2,67,0,92,2,121,90,6,106,1,0,6,106,5,
		80,103,111,46,0,120,106,5,80,103,111,46,0,92,
		3,9,112,10,73,36,82,0,48,18,0,95,1,106,
		8,99,78,111,109,80,103,111,0,106,2,67,0,92,
		40,121,90,8,106,3,64,33,0,6,106,14,70,111,
		114,109,97,32,100,101,32,112,97,103,111,0,120,106,
		15,70,111,114,109,97,115,32,100,101,32,112,97,103,
		111,0,92,40,9,112,10,73,36,83,0,48,18,0,
		95,1,106,8,110,78,117,109,85,110,105,0,106,2,
		78,0,92,16,92,6,90,8,176,21,0,12,0,6,
		176,23,0,12,0,120,176,23,0,12,0,92,12,120,
		112,10,73,36,84,0,48,18,0,95,1,106,8,110,
		73,109,112,65,114,116,0,106,2,78,0,92,16,92,
		6,89,17,0,0,0,1,0,1,0,48,24,0,95,
		255,112,0,6,106,7,80,114,101,99,105,111,0,9,
		106,7,80,114,101,99,105,111,0,92,12,9,112,10,
		73,36,85,0,48,18,0,95,1,106,8,110,73,109,
		112,84,111,116,0,106,2,78,0,92,16,92,6,89,
		17,0,0,0,1,0,1,0,48,25,0,95,255,112,
		0,6,106,5,66,97,115,101,0,120,106,5,66,97,
		115,101,0,92,12,120,112,10,73,36,86,0,48,18,
		0,95,1,106,8,110,84,111,116,80,101,115,0,106,
		2,78,0,92,16,92,6,90,8,176,21,0,12,0,
		6,106,10,84,111,116,46,32,112,101,115,111,0,9,
		106,11,84,111,116,97,108,32,112,101,115,111,0,92,
		12,120,112,10,73,36,87,0,48,18,0,95,1,106,
		8,110,80,114,101,75,103,114,0,106,2,78,0,92,
		16,92,6,89,17,0,0,0,1,0,1,0,48,24,
		0,95,255,112,0,6,106,9,80,114,101,46,32,75,
		103,46,0,9,106,12,80,114,101,99,105,111,32,107,
		105,108,111,0,92,12,9,112,10,73,36,88,0,48,
		18,0,95,1,106,8,110,84,111,116,86,111,108,0,
		106,2,78,0,92,16,92,6,90,8,176,21,0,12,
		0,6,106,13,84,111,116,46,32,118,111,108,117,109,
		101,110,0,9,106,14,84,111,116,97,108,32,118,111,
		108,117,109,101,110,0,92,12,120,112,10,73,36,89,
		0,48,18,0,95,1,106,8,110,80,114,101,86,111,
		108,0,106,2,78,0,92,16,92,6,89,17,0,0,
		0,1,0,1,0,48,24,0,95,255,112,0,6,106,
		10,80,114,101,46,32,118,111,108,46,0,9,106,15,
		80,114,101,99,105,111,32,118,111,108,117,109,101,110,
		0,92,12,9,112,10,73,36,90,0,48,18,0,95,
		1,106,8,110,80,114,101,77,101,100,0,106,2,78,
		0,92,16,92,6,89,17,0,0,0,1,0,1,0,
		48,24,0,95,255,112,0,6,106,10,80,114,101,46,
		32,77,101,100,46,0,120,106,13,80,114,101,99,105,
		111,32,109,101,100,105,111,0,92,12,9,112,10,73,
		36,91,0,48,18,0,95,1,106,8,110,73,118,97,
		84,111,116,0,106,2,78,0,92,16,92,6,89,17,
		0,0,0,1,0,1,0,48,25,0,95,255,112,0,
		6,106,6,84,111,116,46,32,0,176,26,0,12,0,
		72,120,106,7,84,111,116,97,108,32,0,176,26,0,
		12,0,72,92,12,120,112,10,73,36,92,0,48,18,
		0,95,1,106,8,110,84,111,116,70,105,110,0,106,
		2,78,0,92,16,92,6,89,17,0,0,0,1,0,
		1,0,48,25,0,95,255,112,0,6,106,6,84,111,
		116,97,108,0,120,106,6,84,111,116,97,108,0,92,
		12,120,112,10,73,36,94,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TPRVPGO_ADDPED )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,100,0,95,1,100,8,28,5,9,80,
		1,36,102,0,95,1,28,27,48,27,0,48,28,0,
		102,112,0,48,29,0,48,30,0,102,112,0,112,0,
		112,1,32,67,3,36,104,0,48,31,0,48,28,0,
		102,112,0,112,0,73,36,106,0,48,32,0,48,28,
		0,102,112,0,48,29,0,48,30,0,102,112,0,112,
		0,112,1,73,36,107,0,48,33,0,48,28,0,102,
		112,0,176,34,0,48,29,0,48,30,0,102,112,0,
		112,0,48,35,0,102,112,0,12,2,112,1,73,36,
		108,0,48,36,0,48,28,0,102,112,0,176,37,0,
		48,38,0,102,112,0,12,1,112,1,73,36,109,0,
		48,39,0,48,28,0,102,112,0,176,40,0,48,41,
		0,48,38,0,102,112,0,112,0,48,42,0,102,112,
		0,48,43,0,102,112,0,12,3,112,1,73,36,110,
		0,48,44,0,48,28,0,102,112,0,176,45,0,48,
		41,0,48,30,0,102,112,0,112,0,48,41,0,48,
		38,0,102,112,0,112,0,48,42,0,102,112,0,48,
		46,0,102,112,0,48,43,0,102,112,0,12,5,112,
		1,73,36,111,0,48,47,0,48,28,0,102,112,0,
		176,48,0,48,41,0,48,38,0,102,112,0,112,0,
		48,42,0,102,112,0,48,46,0,102,112,0,48,43,
		0,102,112,0,12,4,112,1,73,36,112,0,48,49,
		0,48,28,0,102,112,0,48,50,0,48,28,0,102,
		112,0,112,0,48,51,0,48,28,0,102,112,0,112,
		0,72,112,1,73,36,114,0,48,52,0,102,48,53,
		0,48,38,0,102,112,0,112,0,176,37,0,48,38,
		0,102,112,0,12,1,48,50,0,48,28,0,102,112,
		0,112,0,9,112,4,73,36,116,0,95,1,32,174,
		3,36,118,0,48,54,0,102,48,55,0,48,30,0,
		102,112,0,112,0,112,1,73,36,119,0,48,56,0,
		48,28,0,102,112,0,48,53,0,48,38,0,102,112,
		0,112,0,112,1,73,36,120,0,48,57,0,48,28,
		0,102,112,0,48,58,0,48,38,0,102,112,0,112,
		0,112,1,73,36,121,0,48,59,0,48,28,0,102,
		112,0,48,60,0,48,38,0,102,112,0,112,0,112,
		1,73,36,122,0,48,61,0,48,28,0,102,112,0,
		176,62,0,48,60,0,48,38,0,102,112,0,112,0,
		12,1,112,1,73,36,123,0,48,63,0,48,28,0,
		102,112,0,48,64,0,48,38,0,102,112,0,112,0,
		112,1,73,36,124,0,48,65,0,48,28,0,102,112,
		0,176,62,0,48,64,0,48,38,0,102,112,0,112,
		0,12,1,112,1,73,36,125,0,48,66,0,48,28,
		0,102,112,0,48,67,0,48,38,0,102,112,0,112,
		0,112,1,73,36,126,0,48,68,0,48,28,0,102,
		112,0,176,69,0,48,60,0,48,38,0,102,112,0,
		112,0,48,67,0,48,38,0,102,112,0,112,0,72,
		12,1,112,1,73,36,127,0,48,70,0,48,28,0,
		102,112,0,48,71,0,48,38,0,102,112,0,112,0,
		112,1,73,36,128,0,48,72,0,48,28,0,102,112,
		0,176,69,0,48,64,0,48,38,0,102,112,0,112,
		0,48,71,0,48,38,0,102,112,0,112,0,72,12,
		1,112,1,73,36,129,0,48,73,0,48,28,0,102,
		112,0,48,74,0,48,38,0,102,112,0,112,0,112,
		1,73,36,130,0,48,75,0,48,28,0,102,112,0,
		48,76,0,48,38,0,102,112,0,112,0,112,1,73,
		36,131,0,48,77,0,48,28,0,102,112,0,176,78,
		0,48,79,0,48,38,0,102,112,0,112,0,12,1,
		106,2,47,0,72,176,78,0,176,80,0,48,81,0,
		48,38,0,102,112,0,112,0,12,1,12,1,72,106,
		2,47,0,72,176,78,0,48,82,0,48,38,0,102,
		112,0,112,0,12,1,72,112,1,73,36,132,0,48,
		83,0,48,28,0,102,112,0,48,84,0,48,30,0,
		102,112,0,112,0,112,1,73,26,200,1,36,138,0,
		48,85,0,48,28,0,102,112,0,112,0,73,36,139,
		0,48,36,0,48,28,0,102,112,0,21,48,86,0,
		163,0,112,0,176,37,0,48,38,0,102,112,0,12,
		1,72,112,1,73,36,140,0,48,39,0,48,28,0,
		102,112,0,21,48,87,0,163,0,112,0,176,40,0,
		48,41,0,48,38,0,102,112,0,112,0,48,42,0,
		102,112,0,48,43,0,102,112,0,12,3,72,112,1,
		73,36,141,0,48,44,0,48,28,0,102,112,0,21,
		48,50,0,163,0,112,0,176,45,0,48,41,0,48,
		30,0,102,112,0,112,0,48,41,0,48,38,0,102,
		112,0,112,0,48,42,0,102,112,0,48,46,0,102,
		112,0,48,43,0,102,112,0,12,5,72,112,1,73,
		36,142,0,48,88,0,48,28,0,102,112,0,48,50,
		0,48,28,0,102,112,0,112,0,48,86,0,48,28,
		0,102,112,0,112,0,18,112,1,73,36,143,0,48,
		47,0,48,28,0,102,112,0,21,48,51,0,163,0,
		112,0,176,48,0,48,41,0,48,38,0,102,112,0,
		112,0,48,42,0,102,112,0,48,46,0,102,112,0,
		48,43,0,102,112,0,12,4,72,112,1,73,36,144,
		0,48,49,0,48,28,0,102,112,0,21,48,89,0,
		163,0,112,0,176,45,0,48,41,0,48,30,0,102,
		112,0,112,0,48,41,0,48,38,0,102,112,0,112,
		0,48,42,0,102,112,0,48,46,0,102,112,0,48,
		43,0,102,112,0,12,5,72,112,1,73,36,145,0,
		48,49,0,48,28,0,102,112,0,21,48,89,0,163,
		0,112,0,176,48,0,48,41,0,48,38,0,102,112,
		0,112,0,48,42,0,102,112,0,48,46,0,102,112,
		0,48,43,0,102,112,0,12,4,72,112,1,73,36,
		147,0,48,52,0,102,48,53,0,48,38,0,102,112,
		0,112,0,176,37,0,48,38,0,102,112,0,12,1,
		48,50,0,48,28,0,102,112,0,112,0,120,112,4,
		73,36,149,0,48,90,0,48,28,0,102,112,0,112,
		0,73,36,153,0,48,90,0,48,28,0,102,112,0,
		112,0,73,36,155,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TPRVPGO_ADDALB )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,161,0,95,1,100,8,28,5,9,80,
		1,36,163,0,95,1,28,27,48,27,0,48,28,0,
		102,112,0,48,29,0,48,91,0,102,112,0,112,0,
		112,1,32,62,3,36,165,0,48,31,0,48,28,0,
		102,112,0,112,0,73,36,167,0,48,32,0,48,28,
		0,102,112,0,48,29,0,48,91,0,102,112,0,112,
		0,112,1,73,36,168,0,48,33,0,48,28,0,102,
		112,0,176,34,0,48,29,0,48,91,0,102,112,0,
		112,0,48,35,0,102,112,0,12,2,112,1,73,36,
		169,0,48,36,0,48,28,0,102,112,0,176,92,0,
		48,93,0,102,112,0,12,1,112,1,73,36,170,0,
		48,39,0,48,28,0,102,112,0,176,94,0,48,41,
		0,48,93,0,102,112,0,112,0,48,42,0,102,112,
		0,48,43,0,102,112,0,12,3,112,1,73,36,171,
		0,48,44,0,48,28,0,102,112,0,176,95,0,48,
		41,0,48,91,0,102,112,0,112,0,48,41,0,48,
		93,0,102,112,0,112,0,48,42,0,102,112,0,48,
		46,0,102,112,0,48,43,0,102,112,0,12,5,112,
		1,73,36,172,0,48,47,0,48,28,0,102,112,0,
		176,96,0,48,41,0,48,93,0,102,112,0,112,0,
		48,42,0,102,112,0,48,46,0,102,112,0,48,43,
		0,102,112,0,12,4,112,1,73,36,173,0,48,49,
		0,48,28,0,102,112,0,48,50,0,48,28,0,102,
		112,0,112,0,48,51,0,48,28,0,102,112,0,112,
		0,72,112,1,73,36,175,0,48,52,0,102,48,53,
		0,48,93,0,102,112,0,112,0,176,92,0,48,93,
		0,102,112,0,12,1,48,50,0,48,28,0,102,112,
		0,112,0,9,112,4,73,36,177,0,95,1,32,169,
		3,36,179,0,48,54,0,102,48,55,0,48,91,0,
		102,112,0,112,0,112,1,73,36,180,0,48,56,0,
		48,28,0,102,112,0,48,53,0,48,93,0,102,112,
		0,112,0,112,1,73,36,181,0,48,57,0,48,28,
		0,102,112,0,48,58,0,48,93,0,102,112,0,112,
		0,112,1,73,36,182,0,48,59,0,48,28,0,102,
		112,0,48,60,0,48,93,0,102,112,0,112,0,112,
		1,73,36,183,0,48,61,0,48,28,0,102,112,0,
		176,62,0,48,60,0,48,93,0,102,112,0,112,0,
		12,1,112,1,73,36,184,0,48,63,0,48,28,0,
		102,112,0,48,64,0,48,93,0,102,112,0,112,0,
		112,1,73,36,185,0,48,65,0,48,28,0,102,112,
		0,176,62,0,48,64,0,48,93,0,102,112,0,112,
		0,12,1,112,1,73,36,186,0,48,66,0,48,28,
		0,102,112,0,48,67,0,48,93,0,102,112,0,112,
		0,112,1,73,36,187,0,48,68,0,48,28,0,102,
		112,0,176,69,0,48,60,0,48,93,0,102,112,0,
		112,0,48,67,0,48,93,0,102,112,0,112,0,72,
		12,1,112,1,73,36,188,0,48,70,0,48,28,0,
		102,112,0,48,71,0,48,93,0,102,112,0,112,0,
		112,1,73,36,189,0,48,72,0,48,28,0,102,112,
		0,176,69,0,48,64,0,48,93,0,102,112,0,112,
		0,48,71,0,48,93,0,102,112,0,112,0,72,12,
		1,112,1,73,36,190,0,48,73,0,48,28,0,102,
		112,0,48,97,0,48,93,0,102,112,0,112,0,112,
		1,73,36,191,0,48,75,0,48,28,0,102,112,0,
		48,76,0,48,93,0,102,112,0,112,0,112,1,73,
		36,192,0,48,77,0,48,28,0,102,112,0,48,98,
		0,48,93,0,102,112,0,112,0,106,2,47,0,72,
		176,78,0,176,80,0,48,99,0,48,93,0,102,112,
		0,112,0,12,1,12,1,72,106,2,47,0,72,176,
		78,0,48,100,0,48,93,0,102,112,0,112,0,12,
		1,72,112,1,73,36,193,0,48,83,0,48,28,0,
		102,112,0,48,101,0,48,91,0,102,112,0,112,0,
		112,1,73,26,200,1,36,199,0,48,85,0,48,28,
		0,102,112,0,112,0,73,36,200,0,48,36,0,48,
		28,0,102,112,0,21,48,86,0,163,0,112,0,176,
		92,0,48,93,0,102,112,0,12,1,72,112,1,73,
		36,201,0,48,39,0,48,28,0,102,112,0,21,48,
		87,0,163,0,112,0,176,94,0,48,41,0,48,93,
		0,102,112,0,112,0,48,42,0,102,112,0,48,43,
		0,102,112,0,12,3,72,112,1,73,36,202,0,48,
		44,0,48,28,0,102,112,0,21,48,50,0,163,0,
		112,0,176,95,0,48,41,0,48,91,0,102,112,0,
		112,0,48,41,0,48,93,0,102,112,0,112,0,48,
		42,0,102,112,0,48,46,0,102,112,0,48,43,0,
		102,112,0,12,5,72,112,1,73,36,203,0,48,88,
		0,48,28,0,102,112,0,48,50,0,48,28,0,102,
		112,0,112,0,48,86,0,48,28,0,102,112,0,112,
		0,18,112,1,73,36,204,0,48,47,0,48,28,0,
		102,112,0,21,48,51,0,163,0,112,0,176,96,0,
		48,41,0,48,93,0,102,112,0,112,0,48,42,0,
		102,112,0,48,46,0,102,112,0,48,43,0,102,112,
		0,12,4,72,112,1,73,36,205,0,48,49,0,48,
		28,0,102,112,0,21,48,89,0,163,0,112,0,176,
		95,0,48,41,0,48,91,0,102,112,0,112,0,48,
		41,0,48,93,0,102,112,0,112,0,48,42,0,102,
		112,0,48,46,0,102,112,0,48,43,0,102,112,0,
		12,5,72,112,1,73,36,206,0,48,49,0,48,28,
		0,102,112,0,21,48,89,0,163,0,112,0,176,96,
		0,48,41,0,48,93,0,102,112,0,112,0,48,42,
		0,102,112,0,48,46,0,102,112,0,48,43,0,102,
		112,0,12,4,72,112,1,73,36,208,0,48,52,0,
		102,48,53,0,48,93,0,102,112,0,112,0,176,92,
		0,48,93,0,102,112,0,12,1,48,50,0,48,28,
		0,102,112,0,112,0,120,112,4,73,36,210,0,48,
		90,0,48,28,0,102,112,0,112,0,73,36,214,0,
		48,90,0,48,28,0,102,112,0,112,0,73,36,216,
		0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TPRVPGO_ADDFAC )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,222,0,95,1,100,8,28,5,9,80,
		1,36,224,0,95,1,28,27,48,27,0,48,28,0,
		102,112,0,48,102,0,48,103,0,102,112,0,112,0,
		112,1,32,62,3,36,226,0,48,31,0,48,28,0,
		102,112,0,112,0,73,36,228,0,48,32,0,48,28,
		0,102,112,0,48,102,0,48,103,0,102,112,0,112,
		0,112,1,73,36,229,0,48,33,0,48,28,0,102,
		112,0,176,34,0,48,102,0,48,103,0,102,112,0,
		112,0,48,35,0,102,112,0,12,2,112,1,73,36,
		230,0,48,36,0,48,28,0,102,112,0,176,104,0,
		48,105,0,102,112,0,12,1,112,1,73,36,231,0,
		48,39,0,48,28,0,102,112,0,176,106,0,48,41,
		0,48,105,0,102,112,0,112,0,48,42,0,102,112,
		0,48,43,0,102,112,0,12,3,112,1,73,36,232,
		0,48,44,0,48,28,0,102,112,0,176,107,0,48,
		41,0,48,103,0,102,112,0,112,0,48,41,0,48,
		105,0,102,112,0,112,0,48,42,0,102,112,0,48,
		46,0,102,112,0,48,43,0,102,112,0,12,5,112,
		1,73,36,233,0,48,47,0,48,28,0,102,112,0,
		176,108,0,48,41,0,48,105,0,102,112,0,112,0,
		48,42,0,102,112,0,48,46,0,102,112,0,48,43,
		0,102,112,0,12,4,112,1,73,36,234,0,48,49,
		0,48,28,0,102,112,0,48,50,0,48,28,0,102,
		112,0,112,0,48,51,0,48,28,0,102,112,0,112,
		0,72,112,1,73,36,236,0,48,52,0,102,48,53,
		0,48,105,0,102,112,0,112,0,176,104,0,48,105,
		0,102,112,0,12,1,48,50,0,48,28,0,102,112,
		0,112,0,9,112,4,73,36,238,0,95,1,32,169,
		3,36,240,0,48,54,0,102,48,55,0,48,103,0,
		102,112,0,112,0,112,1,73,36,241,0,48,56,0,
		48,28,0,102,112,0,48,53,0,48,105,0,102,112,
		0,112,0,112,1,73,36,242,0,48,57,0,48,28,
		0,102,112,0,48,58,0,48,105,0,102,112,0,112,
		0,112,1,73,36,243,0,48,59,0,48,28,0,102,
		112,0,48,60,0,48,105,0,102,112,0,112,0,112,
		1,73,36,244,0,48,61,0,48,28,0,102,112,0,
		176,62,0,48,60,0,48,105,0,102,112,0,112,0,
		12,1,112,1,73,36,245,0,48,63,0,48,28,0,
		102,112,0,48,64,0,48,105,0,102,112,0,112,0,
		112,1,73,36,246,0,48,65,0,48,28,0,102,112,
		0,176,62,0,48,64,0,48,105,0,102,112,0,112,
		0,12,1,112,1,73,36,247,0,48,66,0,48,28,
		0,102,112,0,48,67,0,48,105,0,102,112,0,112,
		0,112,1,73,36,248,0,48,68,0,48,28,0,102,
		112,0,176,69,0,48,60,0,48,105,0,102,112,0,
		112,0,48,67,0,48,105,0,102,112,0,112,0,72,
		12,1,112,1,73,36,249,0,48,70,0,48,28,0,
		102,112,0,48,71,0,48,105,0,102,112,0,112,0,
		112,1,73,36,250,0,48,72,0,48,28,0,102,112,
		0,176,69,0,48,64,0,48,105,0,102,112,0,112,
		0,48,71,0,48,105,0,102,112,0,112,0,72,12,
		1,112,1,73,36,251,0,48,73,0,48,28,0,102,
		112,0,48,97,0,48,105,0,102,112,0,112,0,112,
		1,73,36,252,0,48,75,0,48,28,0,102,112,0,
		48,76,0,48,105,0,102,112,0,112,0,112,1,73,
		36,253,0,48,77,0,48,28,0,102,112,0,48,109,
		0,48,105,0,102,112,0,112,0,106,2,47,0,72,
		176,78,0,176,80,0,48,110,0,48,105,0,102,112,
		0,112,0,12,1,12,1,72,106,2,47,0,72,176,
		78,0,48,111,0,48,105,0,102,112,0,112,0,12,
		1,72,112,1,73,36,254,0,48,83,0,48,28,0,
		102,112,0,48,112,0,48,103,0,102,112,0,112,0,
		112,1,73,26,200,1,36,4,1,48,85,0,48,28,
		0,102,112,0,112,0,73,36,5,1,48,36,0,48,
		28,0,102,112,0,21,48,86,0,163,0,112,0,176,
		104,0,48,105,0,102,112,0,12,1,72,112,1,73,
		36,6,1,48,39,0,48,28,0,102,112,0,21,48,
		87,0,163,0,112,0,176,106,0,48,41,0,48,105,
		0,102,112,0,112,0,48,42,0,102,112,0,48,43,
		0,102,112,0,12,3,72,112,1,73,36,7,1,48,
		44,0,48,28,0,102,112,0,21,48,50,0,163,0,
		112,0,176,107,0,48,41,0,48,103,0,102,112,0,
		112,0,48,41,0,48,105,0,102,112,0,112,0,48,
		42,0,102,112,0,48,46,0,102,112,0,48,43,0,
		102,112,0,12,5,72,112,1,73,36,8,1,48,88,
		0,48,28,0,102,112,0,48,50,0,48,28,0,102,
		112,0,112,0,48,86,0,48,28,0,102,112,0,112,
		0,18,112,1,73,36,9,1,48,47,0,48,28,0,
		102,112,0,21,48,51,0,163,0,112,0,176,108,0,
		48,41,0,48,105,0,102,112,0,112,0,48,42,0,
		102,112,0,48,46,0,102,112,0,48,43,0,102,112,
		0,12,4,72,112,1,73,36,10,1,48,49,0,48,
		28,0,102,112,0,21,48,89,0,163,0,112,0,176,
		107,0,48,41,0,48,103,0,102,112,0,112,0,48,
		41,0,48,105,0,102,112,0,112,0,48,42,0,102,
		112,0,48,46,0,102,112,0,48,43,0,102,112,0,
		12,5,72,112,1,73,36,11,1,48,49,0,48,28,
		0,102,112,0,21,48,89,0,163,0,112,0,176,108,
		0,48,41,0,48,105,0,102,112,0,112,0,48,42,
		0,102,112,0,48,46,0,102,112,0,48,43,0,102,
		112,0,12,4,72,112,1,73,36,13,1,48,52,0,
		102,48,53,0,48,105,0,102,112,0,112,0,176,104,
		0,48,105,0,102,112,0,12,1,48,50,0,48,28,
		0,102,112,0,112,0,120,112,4,73,36,15,1,48,
		90,0,48,28,0,102,112,0,112,0,73,36,19,1,
		48,90,0,48,28,0,102,112,0,112,0,73,36,21,
		1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TPRVPGO_INCLUYECERO )
{
	static const HB_BYTE pcode[] =
	{
		36,31,1,48,113,0,48,35,0,102,112,0,112,0,
		73,36,32,1,48,114,0,48,35,0,102,112,0,112,
		0,32,194,0,36,35,1,48,115,0,102,112,0,31,
		43,48,102,0,48,35,0,102,112,0,112,0,48,116,
		0,102,112,0,16,29,144,0,48,102,0,48,35,0,
		102,112,0,112,0,48,117,0,102,112,0,34,28,123,
		48,27,0,48,28,0,102,112,0,48,102,0,48,35,
		0,102,112,0,112,0,112,1,31,99,36,37,1,48,
		31,0,48,28,0,102,112,0,112,0,73,36,38,1,
		48,118,0,48,28,0,102,112,0,112,0,73,36,39,
		1,48,32,0,48,28,0,102,112,0,48,102,0,48,
		35,0,102,112,0,112,0,112,1,73,36,40,1,48,
		33,0,48,28,0,102,112,0,48,119,0,48,35,0,
		102,112,0,112,0,112,1,73,36,41,1,48,90,0,
		48,28,0,102,112,0,112,0,73,36,45,1,48,120,
		0,48,35,0,102,112,0,112,0,73,26,51,255,36,
		49,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,123,0,2,0,116,123,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}
