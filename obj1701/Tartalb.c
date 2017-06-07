/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\Tartalb.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TINFARTALB );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TINFGEN );
HB_FUNC_STATIC( TINFARTALB_CREATE );
HB_FUNC_STATIC( TINFARTALB_OPENFILES );
HB_FUNC_STATIC( TINFARTALB_CLOSEFILES );
HB_FUNC_STATIC( TINFARTALB_LRESOURCE );
HB_FUNC_STATIC( TINFARTALB_LGENERATE );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( MASUND );
HB_FUNC_EXTERN( RTRIM );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( TDATACENTER );
HB_FUNC_EXTERN( DBFSERVER );
HB_FUNC_EXTERN( CDRIVER );
HB_FUNC_EXTERN( CPATEMP );
HB_FUNC_EXTERN( CPATDAT );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( TCOMBOBOX );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( AITMART );
HB_FUNC_EXTERN( LFACTURADO );
HB_FUNC_EXTERN( DTOC );
HB_FUNC_EXTERN( DATE );
HB_FUNC_EXTERN( STR );
HB_FUNC_EXTERN( LCHKSER );
HB_FUNC_EXTERN( NTOTNALBCLI );
HB_FUNC_EXTERN( NIMPLALBCLI );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TARTALB )
{ "TINFARTALB", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TINFARTALB )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TINFGEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( TINFGEN )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TINFARTALB_CREATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINFARTALB_CREATE )}, NULL },
{ "TINFARTALB_OPENFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINFARTALB_OPENFILES )}, NULL },
{ "TINFARTALB_CLOSEFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINFARTALB_CLOSEFILES )}, NULL },
{ "TINFARTALB_LRESOURCE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINFARTALB_LRESOURCE )}, NULL },
{ "TINFARTALB_LGENERATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINFARTALB_LGENERATE )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDFIELD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MASUND", {HB_FS_PUBLIC}, {HB_FUNCNAME( MASUND )}, NULL },
{ "CPICOUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDTMPINDEX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDGROUP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( RTRIM )}, NULL },
{ "CNOMART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "_OALBCLIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OALBCLIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDATACENTER", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDATACENTER )}, NULL },
{ "_OALBCLIL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NEWOPEN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBFSERVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBFSERVER )}, NULL },
{ "CDRIVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CDRIVER )}, NULL },
{ "CPATEMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPATEMP )}, NULL },
{ "ADDBAG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OALBCLIL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AUTOINDEX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODBFTVTA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPATDAT", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPATDAT )}, NULL },
{ "ODBFTVTA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "CLOSEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "USED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "STDRESOURCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LDEFARTINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETTOTAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OMTRINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LASTREC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBFART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODEFEXCINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODEFEXCIMP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OESTADO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TCOMBOBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TCOMBOBOX )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "AESTADO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADIALOGS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OFLD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AITMART", {HB_FS_PUBLIC}, {HB_FUNCNAME( AITMART )}, NULL },
{ "DISABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODLG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ZAP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NAT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OESTADO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LFACTURADO", {HB_FS_PUBLIC}, {HB_FUNCNAME( LFACTURADO )}, NULL },
{ "_AHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DTOC", {HB_FS_PUBLIC}, {HB_FUNCNAME( DTOC )}, NULL },
{ "DATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( DATE )}, NULL },
{ "DINIINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DFININF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CARTORG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CARTDES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CODIGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SEEK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CSERALB", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "STR", {HB_FS_PUBLIC}, {HB_FUNCNAME( STR )}, NULL },
{ "NNUMALB", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CSUFALB", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DFECALB", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LCHKSER", {HB_FS_PUBLIC}, {HB_FUNCNAME( LCHKSER )}, NULL },
{ "ASER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LEXCCERO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NPREDIV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCODART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOMBRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NNUMCAJ", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NCANENT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NUNIDAD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NUNICAJA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NNUMUNI", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NTOTNALBCLI", {HB_FS_PUBLIC}, {HB_FUNCNAME( NTOTNALBCLI )}, NULL },
{ "_NIMPART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NIMPLALBCLI", {HB_FS_PUBLIC}, {HB_FUNCNAME( NIMPLALBCLI )}, NULL },
{ "CALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NDECOUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NDEROUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NVALDIV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CDOCMOV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "_DFECMOV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CTIPMOV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CTIPVEN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CDESMOV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SKIP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AUTOINC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ORDKEYNO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ENABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TARTALB, ".\\.\\Prg\\Tartalb.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TARTALB
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TARTALB )
   #include "hbiniseg.h"
#endif

HB_FUNC( TINFARTALB )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,122,0,36,8,0,103,2,0,100,8,
		29,70,2,176,1,0,104,2,0,12,1,29,59,2,
		166,253,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,11,84,73,110,102,65,114,116,65,108,98,0,
		108,4,4,1,0,108,0,112,3,80,2,36,10,0,
		48,5,0,95,2,106,6,76,79,71,73,67,0,9,
		95,1,121,72,121,72,121,72,106,8,108,69,120,99,
		77,111,118,0,4,1,0,9,112,5,73,36,11,0,
		48,5,0,95,2,106,7,79,66,74,69,67,84,0,
		100,95,1,121,72,121,72,121,72,106,8,111,69,115,
		116,97,100,111,0,4,1,0,9,112,5,73,36,12,
		0,48,5,0,95,2,106,7,79,66,74,69,67,84,
		0,100,95,1,121,72,121,72,121,72,106,9,111,65,
		108,98,67,108,105,84,0,4,1,0,9,112,5,73,
		36,13,0,48,5,0,95,2,106,7,79,66,74,69,
		67,84,0,100,95,1,121,72,121,72,121,72,106,9,
		111,65,108,98,67,108,105,76,0,4,1,0,9,112,
		5,73,36,14,0,48,5,0,95,2,106,7,79,66,
		74,69,67,84,0,100,95,1,121,72,121,72,121,72,
		106,9,111,68,98,102,84,118,116,97,0,4,1,0,
		9,112,5,73,36,15,0,48,5,0,95,2,106,6,
		65,82,82,65,89,0,106,13,78,111,32,102,97,99,
		116,117,114,97,100,111,0,106,10,70,97,99,116,117,
		114,97,100,111,0,106,6,84,111,100,111,115,0,4,
		3,0,95,1,121,72,121,72,121,72,106,8,97,69,
		115,116,97,100,111,0,4,1,0,9,112,5,73,36,
		17,0,48,6,0,95,2,106,7,67,114,101,97,116,
		101,0,108,7,95,1,121,72,121,72,121,72,112,3,
		73,36,19,0,48,6,0,95,2,106,10,79,112,101,
		110,70,105,108,101,115,0,108,8,95,1,121,72,121,
		72,121,72,112,3,73,36,21,0,48,6,0,95,2,
		106,11,67,108,111,115,101,70,105,108,101,115,0,108,
		9,95,1,121,72,121,72,121,72,112,3,73,36,23,
		0,48,6,0,95,2,106,10,108,82,101,115,111,117,
		114,99,101,0,108,10,95,1,121,72,121,72,121,72,
		112,3,73,36,25,0,48,6,0,95,2,106,10,108,
		71,101,110,101,114,97,116,101,0,108,11,95,1,121,
		72,121,72,121,72,112,3,73,36,27,0,48,12,0,
		95,2,112,0,73,167,14,0,0,176,13,0,104,2,
		0,95,2,20,2,168,48,14,0,95,2,112,0,80,
		3,176,15,0,95,3,106,10,73,110,105,116,67,108,
		97,115,115,0,12,2,28,12,48,16,0,95,3,164,
		146,1,0,73,95,3,110,7,48,14,0,103,2,0,
		112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINFARTALB_CREATE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,31,0,102,80,1,36,33,0,48,17,
		0,95,1,106,8,67,67,79,68,65,82,84,0,106,
		2,67,0,92,18,121,90,8,106,3,64,33,0,6,
		106,16,67,243,100,105,103,111,32,97,114,116,237,99,
		117,108,111,0,9,106,16,67,243,100,105,103,111,32,
		97,114,116,237,99,117,108,111,0,92,14,112,9,73,
		36,34,0,48,17,0,95,1,106,8,67,78,79,77,
		65,82,84,0,106,2,67,0,92,100,121,90,8,106,
		3,64,33,0,6,106,10,78,111,109,46,32,65,114,
		116,46,0,9,106,16,78,111,109,98,114,101,32,97,
		114,116,237,99,117,108,111,0,92,35,112,9,73,36,
		35,0,48,17,0,95,1,106,8,67,68,79,67,77,
		79,86,0,106,2,67,0,92,18,121,90,8,106,3,
		64,33,0,6,106,8,65,108,98,97,114,97,110,0,
		120,106,8,65,108,98,97,114,97,110,0,92,10,112,
		9,73,36,36,0,48,17,0,95,1,106,8,68,70,
		69,67,77,79,86,0,106,2,68,0,92,8,121,90,
		8,106,3,64,33,0,6,106,6,70,101,99,104,97,
		0,120,106,6,70,101,99,104,97,0,92,8,112,9,
		73,36,37,0,48,17,0,95,1,106,8,78,78,85,
		77,67,65,74,0,106,2,78,0,92,13,92,6,90,
		8,176,18,0,12,0,6,106,5,67,97,106,46,0,
		120,106,6,67,97,106,97,115,0,92,12,112,9,73,
		36,38,0,48,17,0,95,1,106,8,78,85,78,73,
		68,65,68,0,106,2,78,0,92,16,92,6,90,8,
		176,18,0,12,0,6,106,5,85,110,100,46,0,120,
		106,9,85,110,105,100,97,100,101,115,0,92,12,112,
		9,73,36,39,0,48,17,0,95,1,106,8,78,78,
		85,77,85,78,73,0,106,2,78,0,92,13,92,6,
		90,8,176,18,0,12,0,6,106,10,84,111,116,46,
		32,85,110,100,46,0,120,106,15,84,111,116,97,108,
		32,117,110,105,100,97,100,101,115,0,92,12,112,9,
		73,36,40,0,48,17,0,95,1,106,8,78,73,77,
		80,65,82,84,0,106,2,78,0,92,13,92,6,89,
		17,0,0,0,1,0,1,0,48,19,0,95,255,112,
		0,6,106,8,73,109,112,111,114,116,101,0,120,106,
		8,73,109,112,111,114,116,101,0,92,12,112,9,73,
		36,41,0,48,17,0,95,1,106,8,67,84,73,80,
		86,69,78,0,106,2,67,0,92,20,121,90,8,106,
		3,64,33,0,6,106,6,86,101,110,116,97,0,120,
		106,14,84,105,112,111,32,100,101,32,118,101,110,116,
		97,0,92,10,112,9,73,36,43,0,48,20,0,95,
		1,106,8,99,67,111,100,65,114,116,0,106,8,99,
		67,111,100,65,114,116,0,112,2,73,36,45,0,48,
		21,0,95,1,89,22,0,0,0,1,0,1,0,48,
		22,0,48,23,0,95,255,112,0,112,0,6,89,65,
		0,0,0,1,0,1,0,106,12,65,114,116,237,99,
		117,108,111,32,58,32,0,176,24,0,48,22,0,48,
		23,0,95,255,112,0,112,0,12,1,72,106,2,45,
		0,72,176,24,0,48,25,0,48,23,0,95,255,112,
		0,112,0,12,1,72,6,90,6,106,1,0,6,112,
		3,73,36,47,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINFARTALB_OPENFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,3,0,36,55,0,120,80,3,36,61,0,176,26,
		0,89,15,0,1,0,0,0,176,27,0,95,1,12,
		1,6,12,1,80,1,36,62,0,113,15,1,0,36,
		64,0,48,28,0,102,48,29,0,176,30,0,12,0,
		112,0,112,1,73,36,66,0,48,31,0,102,48,32,
		0,176,33,0,106,12,65,76,66,67,76,73,76,46,
		68,66,70,0,100,12,2,106,12,65,76,66,67,76,
		73,76,46,68,66,70,0,100,176,34,0,12,0,100,
		176,35,0,12,0,9,120,9,9,112,9,112,1,73,
		48,36,0,48,37,0,102,112,0,106,12,65,76,66,
		67,76,73,76,46,67,68,88,0,112,1,73,48,36,
		0,48,37,0,102,112,0,112,0,73,48,38,0,48,
		37,0,102,112,0,112,0,73,36,67,0,48,39,0,
		48,37,0,102,112,0,106,5,67,82,69,70,0,112,
		1,73,36,69,0,48,40,0,102,48,32,0,176,33,
		0,106,9,84,86,84,65,46,68,66,70,0,100,12,
		2,106,9,84,86,84,65,46,68,66,70,0,100,176,
		34,0,12,0,100,176,41,0,12,0,9,120,9,9,
		112,9,112,1,73,48,36,0,48,42,0,102,112,0,
		106,9,84,86,84,65,46,67,68,88,0,112,1,73,
		48,36,0,48,42,0,102,112,0,112,0,73,48,38,
		0,48,42,0,102,112,0,112,0,73,114,77,0,0,
		36,71,0,115,80,2,36,73,0,9,80,3,36,75,
		0,176,43,0,106,41,73,109,112,111,115,105,98,108,
		101,32,97,98,114,105,114,32,116,111,100,97,115,32,
		108,97,115,32,98,97,115,101,115,32,100,101,32,100,
		97,116,111,115,0,20,1,36,76,0,48,44,0,102,
		112,0,73,36,80,0,176,26,0,95,1,20,1,36,
		82,0,95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINFARTALB_CLOSEFILES )
{
	static const HB_BYTE pcode[] =
	{
		36,88,0,176,45,0,48,29,0,102,112,0,12,1,
		31,30,48,46,0,48,29,0,102,112,0,112,0,28,
		17,36,89,0,48,47,0,48,29,0,102,112,0,112,
		0,73,36,92,0,176,45,0,48,37,0,102,112,0,
		12,1,31,30,48,46,0,48,37,0,102,112,0,112,
		0,28,17,36,93,0,48,47,0,48,37,0,102,112,
		0,112,0,73,36,96,0,176,45,0,48,42,0,102,
		112,0,12,1,31,30,48,46,0,48,42,0,102,112,
		0,112,0,28,17,36,97,0,48,47,0,48,42,0,
		102,112,0,112,0,73,36,100,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINFARTALB_LRESOURCE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,106,0,106,6,84,111,100,111,115,0,
		80,2,36,108,0,48,48,0,102,106,11,73,78,70,
		95,71,69,78,49,48,65,0,112,1,31,8,36,109,
		0,9,110,7,36,116,0,48,49,0,102,92,110,92,
		120,93,130,0,93,140,0,112,4,73,36,122,0,48,
		50,0,48,51,0,102,112,0,48,52,0,48,53,0,
		102,112,0,112,0,112,1,73,36,124,0,48,54,0,
		102,93,204,0,112,1,73,36,126,0,48,55,0,102,
		93,205,0,112,1,73,36,132,0,48,56,0,102,48,
		57,0,176,58,0,12,0,93,218,0,89,28,0,1,
		0,1,0,2,0,176,59,0,12,0,121,8,28,6,
		95,255,25,7,95,1,165,80,255,6,48,60,0,102,
		112,0,48,61,0,48,62,0,102,112,0,112,0,122,
		1,100,100,100,100,100,100,9,100,100,100,100,100,100,
		112,17,112,1,73,36,134,0,48,63,0,102,176,64,
		0,12,0,48,53,0,102,112,0,112,2,73,36,136,
		0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINFARTALB_LGENERATE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,143,0,102,80,1,36,145,0,90,4,
		120,6,80,2,36,147,0,48,65,0,48,66,0,95,
		1,112,0,112,0,73,36,149,0,48,67,0,48,23,
		0,95,1,112,0,112,0,73,36,151,0,48,68,0,
		48,53,0,95,1,112,0,112,0,73,36,154,0,48,
		69,0,48,70,0,95,1,112,0,112,0,122,8,28,
		32,36,155,0,89,23,0,0,0,1,0,1,0,176,
		71,0,48,29,0,95,255,112,0,12,1,68,6,80,
		2,25,49,36,156,0,48,69,0,48,70,0,95,1,
		112,0,112,0,92,2,8,28,29,36,157,0,89,22,
		0,0,0,1,0,1,0,176,71,0,48,29,0,95,
		255,112,0,12,1,6,80,2,36,163,0,48,72,0,
		95,1,90,27,106,11,70,101,99,104,97,32,32,32,
		58,32,0,176,73,0,176,74,0,12,0,12,1,72,
		6,89,56,0,0,0,1,0,1,0,106,11,80,101,
		114,105,111,100,111,32,58,32,0,176,73,0,48,75,
		0,95,255,112,0,12,1,72,106,4,32,62,32,0,
		72,176,73,0,48,76,0,95,255,112,0,12,1,72,
		6,89,46,0,0,0,1,0,1,0,106,11,65,114,
		116,237,99,117,108,111,58,32,0,48,77,0,95,255,
		112,0,72,106,4,32,62,32,0,72,48,78,0,95,
		255,112,0,72,6,89,44,0,0,0,1,0,1,0,
		106,11,69,115,116,97,100,111,32,32,58,32,0,48,
		60,0,95,255,112,0,48,69,0,48,70,0,95,255,
		112,0,112,0,1,72,6,4,4,0,112,1,73,36,
		165,0,48,79,0,48,53,0,95,1,112,0,112,0,
		32,42,3,36,167,0,48,80,0,48,53,0,95,1,
		112,0,112,0,48,77,0,95,1,112,0,16,29,225,
		2,48,80,0,48,53,0,95,1,112,0,112,0,48,
		78,0,95,1,112,0,34,29,202,2,36,169,0,48,
		81,0,48,37,0,95,1,112,0,48,80,0,48,53,
		0,95,1,112,0,112,0,112,1,29,172,2,36,171,
		0,48,82,0,48,37,0,95,1,112,0,112,0,48,
		80,0,48,53,0,95,1,112,0,112,0,8,29,141,
		2,48,79,0,48,37,0,95,1,112,0,112,0,32,
		126,2,36,173,0,48,81,0,48,29,0,95,1,112,
		0,48,83,0,48,37,0,95,1,112,0,112,0,176,
		84,0,48,85,0,48,37,0,95,1,112,0,112,0,
		12,1,72,48,86,0,48,37,0,95,1,112,0,112,
		0,72,112,1,29,46,2,36,181,0,48,87,0,95,
		2,112,0,29,33,2,48,88,0,48,29,0,95,1,
		112,0,112,0,48,75,0,95,1,112,0,16,29,10,
		2,48,88,0,48,29,0,95,1,112,0,112,0,48,
		76,0,95,1,112,0,34,29,243,1,48,80,0,48,
		53,0,95,1,112,0,112,0,48,77,0,95,1,112,
		0,16,29,220,1,48,80,0,48,53,0,95,1,112,
		0,112,0,48,78,0,95,1,112,0,34,29,197,1,
		176,89,0,48,83,0,48,29,0,95,1,112,0,112,
		0,48,90,0,95,1,112,0,12,2,29,170,1,48,
		91,0,95,1,112,0,28,19,48,92,0,48,37,0,
		95,1,112,0,112,0,121,8,32,144,1,36,187,0,
		48,93,0,48,23,0,95,1,112,0,112,0,73,36,
		189,0,48,94,0,48,23,0,95,1,112,0,48,80,
		0,48,53,0,95,1,112,0,112,0,112,1,73,36,
		190,0,48,95,0,48,23,0,95,1,112,0,48,96,
		0,48,53,0,95,1,112,0,112,0,112,1,73,36,
		191,0,48,97,0,48,23,0,95,1,112,0,48,98,
		0,48,37,0,95,1,112,0,112,0,112,1,73,36,
		192,0,48,99,0,48,23,0,95,1,112,0,48,100,
		0,48,37,0,95,1,112,0,112,0,112,1,73,36,
		193,0,48,101,0,48,23,0,95,1,112,0,176,102,
		0,48,37,0,95,1,112,0,12,1,112,1,73,36,
		194,0,48,103,0,48,23,0,95,1,112,0,176,104,
		0,48,105,0,48,29,0,95,1,112,0,112,0,48,
		105,0,48,37,0,95,1,112,0,112,0,48,106,0,
		95,1,112,0,48,107,0,95,1,112,0,48,108,0,
		95,1,112,0,12,5,112,1,73,36,195,0,48,109,
		0,48,23,0,95,1,112,0,176,110,0,48,83,0,
		48,37,0,95,1,112,0,112,0,106,2,47,0,72,
		176,84,0,48,85,0,48,37,0,95,1,112,0,112,
		0,12,1,72,106,2,47,0,72,48,86,0,48,37,
		0,95,1,112,0,112,0,72,12,1,112,1,73,36,
		196,0,48,111,0,48,23,0,95,1,112,0,48,88,
		0,48,29,0,95,1,112,0,112,0,112,1,73,36,
		198,0,48,81,0,48,42,0,95,1,112,0,48,112,
		0,48,37,0,95,1,112,0,112,0,112,1,28,30,
		36,199,0,48,113,0,48,23,0,95,1,112,0,48,
		114,0,48,42,0,95,1,112,0,112,0,112,1,73,
		36,202,0,48,115,0,48,23,0,95,1,112,0,112,
		0,73,36,208,0,48,116,0,48,37,0,95,1,112,
		0,112,0,73,26,90,253,36,216,0,48,116,0,48,
		53,0,95,1,112,0,112,0,73,36,217,0,48,117,
		0,48,51,0,95,1,112,0,48,118,0,48,53,0,
		95,1,112,0,112,0,112,1,73,26,202,252,36,221,
		0,48,117,0,48,51,0,95,1,112,0,48,118,0,
		48,53,0,95,1,112,0,112,0,112,1,73,36,222,
		0,48,119,0,48,66,0,95,1,112,0,112,0,73,
		36,224,0,48,52,0,48,23,0,95,1,112,0,112,
		0,121,15,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,122,0,2,0,116,122,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}
