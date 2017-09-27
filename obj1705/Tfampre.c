/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\Tfampre.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TINFFAMPRE );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TINFFAM );
HB_FUNC_STATIC( TINFFAMPRE_CREATE );
HB_FUNC_STATIC( TINFFAMPRE_OPENFILES );
HB_FUNC_STATIC( TINFFAMPRE_CLOSEFILES );
HB_FUNC_STATIC( TINFFAMPRE_RESOURCE );
HB_FUNC_STATIC( TINFFAMPRE_LGENERATE );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( RTRIM );
HB_FUNC_EXTERN( ORETFLD );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( TDATACENTER );
HB_FUNC_EXTERN( DBFSERVER );
HB_FUNC_EXTERN( CDRIVER );
HB_FUNC_EXTERN( CPATEMP );
HB_FUNC_EXTERN( CPATART );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( TCHECKBOX );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( TCOMBOBOX );
HB_FUNC_EXTERN( DTOC );
HB_FUNC_EXTERN( DATE );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( CCODFAM );
HB_FUNC_EXTERN( STR );
HB_FUNC_EXTERN( LCHKSER );
HB_FUNC_EXTERN( NIMPLPRECLI );
HB_FUNC_EXTERN( NTOTNPRECLI );
HB_FUNC_EXTERN( NTOTUPRECLI );
HB_FUNC_EXTERN( NTRNUPRECLI );
HB_FUNC_EXTERN( NPNTUPRECLI );
HB_FUNC_EXTERN( ROUND );
HB_FUNC_EXTERN( LTRIM );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_TFAMPRE )
{ "TINFFAMPRE", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TINFFAMPRE )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TINFFAM", {HB_FS_PUBLIC}, {HB_FUNCNAME( TINFFAM )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TINFFAMPRE_CREATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINFFAMPRE_CREATE )}, NULL },
{ "TINFFAMPRE_OPENFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINFFAMPRE_OPENFILES )}, NULL },
{ "TINFFAMPRE_CLOSEFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINFFAMPRE_CLOSEFILES )}, NULL },
{ "TINFFAMPRE_RESOURCE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINFFAMPRE_RESOURCE )}, NULL },
{ "TINFFAMPRE_LGENERATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TINFFAMPRE_LGENERATE )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DETCREATEFIELDS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDTMPINDEX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDGROUP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODFAM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( RTRIM )}, NULL },
{ "ORETFLD", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORETFLD )}, NULL },
{ "ODBFFAM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LSALTO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBFART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "_OPRECLIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OPRECLIT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TDATACENTER", {HB_FS_PUBLIC}, {HB_FUNCNAME( TDATACENTER )}, NULL },
{ "_OPRECLIL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NEWOPEN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBFSERVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBFSERVER )}, NULL },
{ "CDRIVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CDRIVER )}, NULL },
{ "CPATEMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPATEMP )}, NULL },
{ "ADDBAG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OPRECLIL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AUTOINDEX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETORDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ODBFART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPATART", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPATART )}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "CLOSEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "USED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "STDRESOURCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LDEFFAMINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LDEFARTINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETTOTAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OMTRINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LASTREC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODEFEXCINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODEFSALINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODEFRESINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TCHECKBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TCHECKBOX )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "LEXCMOV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LEXCMOV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADIALOGS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OFLD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OESTADO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TCOMBOBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TCOMBOBOX )}, NULL },
{ "AESTADO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DISABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODLG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ZAP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NAT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OESTADO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LESTADO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_AHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DTOC", {HB_FS_PUBLIC}, {HB_FUNCNAME( DTOC )}, NULL },
{ "DATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( DATE )}, NULL },
{ "DINIINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DFININF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "CFAMORG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CFAMDES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODFAM", {HB_FS_PUBLIC}, {HB_FUNCNAME( CCODFAM )}, NULL },
{ "CREF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SEEK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CSERPRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "STR", {HB_FS_PUBLIC}, {HB_FUNCNAME( STR )}, NULL },
{ "NNUMPRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CSUFPRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DFECPRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CARTORG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CARTDES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LCHKSER", {HB_FS_PUBLIC}, {HB_FUNCNAME( LCHKSER )}, NULL },
{ "ASER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LEXCCERO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NUNICAJA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NIMPLPRECLI", {HB_FS_PUBLIC}, {HB_FUNCNAME( NIMPLPRECLI )}, NULL },
{ "CALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NDECOUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NDEROUT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NVALDIV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDCLIENTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODCLI", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCODART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CODIGO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NOMBRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCODFAM", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FAMILIA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NNUMCAJ", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NCANPRE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NUNIDAD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NNUMUNI", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NTOTNPRECLI", {HB_FS_PUBLIC}, {HB_FUNCNAME( NTOTNPRECLI )}, NULL },
{ "_NIMPART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NTOTUPRECLI", {HB_FS_PUBLIC}, {HB_FUNCNAME( NTOTUPRECLI )}, NULL },
{ "_NIMPTRN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NTRNUPRECLI", {HB_FS_PUBLIC}, {HB_FUNCNAME( NTRNUPRECLI )}, NULL },
{ "_NPNTVER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NPNTUPRECLI", {HB_FS_PUBLIC}, {HB_FUNCNAME( NPNTUPRECLI )}, NULL },
{ "_NIMPTOT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NIVAART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ROUND", {HB_FS_PUBLIC}, {HB_FUNCNAME( ROUND )}, NULL },
{ "NIMPART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NIVA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CDOCMOV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( LTRIM )}, NULL },
{ "_DFECMOV", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SKIP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AUTOINC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ENABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_TFAMPRE, ".\\.\\Prg\\Tfampre.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_TFAMPRE
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_TFAMPRE )
   #include "hbiniseg.h"
#endif

HB_FUNC( TINFFAMPRE )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,138,0,36,8,0,103,2,0,100,8,
		29,21,2,176,1,0,104,2,0,12,1,29,10,2,
		166,204,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,11,84,73,110,102,70,97,109,80,114,101,0,
		108,4,4,1,0,108,0,112,3,80,2,36,10,0,
		48,5,0,95,2,106,6,76,79,71,73,67,0,9,
		95,1,121,72,121,72,121,72,106,8,108,69,120,99,
		77,111,118,0,4,1,0,9,112,5,73,36,11,0,
		48,5,0,95,2,106,7,79,66,74,69,67,84,0,
		100,95,1,121,72,121,72,121,72,106,8,111,69,115,
		116,97,100,111,0,4,1,0,9,112,5,73,36,12,
		0,48,5,0,95,2,106,7,79,66,74,69,67,84,
		0,100,95,1,121,72,121,72,121,72,106,9,111,80,
		114,101,67,108,105,84,0,4,1,0,9,112,5,73,
		36,13,0,48,5,0,95,2,106,7,79,66,74,69,
		67,84,0,100,95,1,121,72,121,72,121,72,106,9,
		111,80,114,101,67,108,105,76,0,4,1,0,9,112,
		5,73,36,14,0,48,5,0,95,2,106,6,65,82,
		82,65,89,0,106,10,80,101,110,100,105,101,110,116,
		101,0,106,9,65,99,101,112,116,97,100,111,0,106,
		6,84,111,100,111,115,0,4,3,0,95,1,121,72,
		121,72,121,72,106,8,97,69,115,116,97,100,111,0,
		4,1,0,9,112,5,73,36,16,0,48,6,0,95,
		2,106,7,67,114,101,97,116,101,0,108,7,95,1,
		121,72,121,72,121,72,112,3,73,36,18,0,48,6,
		0,95,2,106,10,79,112,101,110,70,105,108,101,115,
		0,108,8,95,1,121,72,121,72,121,72,112,3,73,
		36,20,0,48,6,0,95,2,106,11,67,108,111,115,
		101,70,105,108,101,115,0,108,9,95,1,121,72,121,
		72,121,72,112,3,73,36,22,0,48,6,0,95,2,
		106,9,82,101,115,111,117,114,99,101,0,108,10,95,
		1,121,72,121,72,121,72,112,3,73,36,24,0,48,
		6,0,95,2,106,10,108,71,101,110,101,114,97,116,
		101,0,108,11,95,1,121,72,121,72,121,72,112,3,
		73,36,26,0,48,12,0,95,2,112,0,73,167,14,
		0,0,176,13,0,104,2,0,95,2,20,2,168,48,
		14,0,95,2,112,0,80,3,176,15,0,95,3,106,
		10,73,110,105,116,67,108,97,115,115,0,12,2,28,
		12,48,16,0,95,3,164,146,1,0,73,95,3,110,
		7,48,14,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINFFAMPRE_CREATE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,30,0,102,80,1,36,32,0,48,17,
		0,95,1,112,0,73,36,34,0,48,18,0,95,1,
		106,8,67,67,79,68,70,65,77,0,106,18,99,67,
		111,100,70,97,109,32,43,32,67,67,79,68,65,82,
		84,0,112,2,73,36,35,0,48,19,0,95,1,89,
		22,0,0,0,1,0,1,0,48,20,0,48,21,0,
		95,255,112,0,112,0,6,89,72,0,0,0,1,0,
		1,0,106,12,70,97,109,105,108,105,97,32,32,58,
		32,0,176,22,0,48,20,0,48,21,0,95,255,112,
		0,112,0,12,1,72,106,2,45,0,72,176,23,0,
		48,20,0,48,21,0,95,255,112,0,112,0,48,24,
		0,95,255,112,0,12,2,72,6,90,22,106,17,84,
		111,116,97,108,32,102,97,109,105,108,105,97,46,46,
		46,0,6,100,48,25,0,95,1,112,0,112,5,73,
		36,36,0,48,19,0,95,1,89,35,0,0,0,1,
		0,1,0,48,20,0,48,21,0,95,255,112,0,112,
		0,48,26,0,48,21,0,95,255,112,0,112,0,72,
		6,89,77,0,0,0,1,0,1,0,106,12,65,114,
		116,237,99,117,108,111,32,58,32,0,176,22,0,48,
		26,0,48,21,0,95,255,112,0,112,0,12,1,72,
		106,2,45,0,72,176,22,0,176,23,0,48,26,0,
		48,21,0,95,255,112,0,112,0,48,27,0,95,255,
		112,0,12,2,12,1,72,6,90,6,106,1,0,6,
		112,3,73,36,38,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINFFAMPRE_OPENFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,3,0,36,45,0,120,80,3,36,51,0,176,28,
		0,89,15,0,1,0,0,0,176,29,0,95,1,12,
		1,6,12,1,80,1,36,52,0,113,27,1,0,36,
		54,0,48,30,0,102,48,31,0,176,32,0,12,0,
		112,0,112,1,73,36,56,0,48,33,0,102,48,34,
		0,176,35,0,106,12,80,82,69,67,76,73,76,46,
		68,66,70,0,100,12,2,106,12,80,82,69,67,76,
		73,76,46,68,66,70,0,100,176,36,0,12,0,100,
		176,37,0,12,0,9,120,9,9,112,9,112,1,73,
		48,38,0,48,39,0,102,112,0,106,12,80,82,69,
		67,76,73,76,46,67,68,88,0,112,1,73,48,38,
		0,48,39,0,102,112,0,112,0,73,48,40,0,48,
		39,0,102,112,0,112,0,73,36,57,0,48,41,0,
		48,39,0,102,112,0,106,5,67,82,69,70,0,112,
		1,73,36,59,0,48,42,0,102,48,34,0,176,35,
		0,106,13,65,82,84,73,67,85,76,79,46,68,66,
		70,0,100,12,2,106,13,65,82,84,73,67,85,76,
		79,46,68,66,70,0,100,176,36,0,12,0,100,176,
		43,0,12,0,9,120,9,9,112,9,112,1,73,48,
		38,0,48,27,0,102,112,0,106,13,65,82,84,73,
		67,85,76,79,46,67,68,88,0,112,1,73,48,38,
		0,48,27,0,102,112,0,112,0,73,48,40,0,48,
		27,0,102,112,0,112,0,73,114,77,0,0,36,61,
		0,115,80,2,36,63,0,9,80,3,36,65,0,176,
		44,0,106,41,73,109,112,111,115,105,98,108,101,32,
		97,98,114,105,114,32,116,111,100,97,115,32,108,97,
		115,32,98,97,115,101,115,32,100,101,32,100,97,116,
		111,115,0,20,1,36,66,0,48,45,0,102,112,0,
		73,36,70,0,176,28,0,95,1,20,1,36,72,0,
		95,3,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINFFAMPRE_CLOSEFILES )
{
	static const HB_BYTE pcode[] =
	{
		36,78,0,176,46,0,48,31,0,102,112,0,12,1,
		31,30,48,47,0,48,31,0,102,112,0,112,0,28,
		17,36,79,0,48,48,0,48,31,0,102,112,0,112,
		0,73,36,82,0,176,46,0,48,39,0,102,112,0,
		12,1,31,30,48,47,0,48,39,0,102,112,0,112,
		0,28,17,36,83,0,48,48,0,48,39,0,102,112,
		0,112,0,73,36,86,0,176,46,0,48,27,0,102,
		112,0,12,1,31,30,48,47,0,48,27,0,102,112,
		0,112,0,28,17,36,87,0,48,48,0,48,27,0,
		102,112,0,112,0,73,36,90,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINFFAMPRE_RESOURCE )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,94,0,102,80,2,36,96,0,106,6,
		84,111,100,111,115,0,80,3,36,98,0,48,49,0,
		95,2,106,10,73,78,70,95,71,69,78,49,49,0,
		112,1,31,8,36,99,0,9,110,7,36,104,0,48,
		50,0,95,2,92,110,92,120,93,130,0,93,140,0,
		112,4,73,36,110,0,48,51,0,95,2,92,70,92,
		80,92,90,92,100,112,4,73,36,114,0,48,52,0,
		48,53,0,95,2,112,0,48,54,0,48,27,0,95,
		2,112,0,112,0,112,1,73,36,116,0,48,55,0,
		95,2,93,204,0,112,1,73,36,118,0,48,56,0,
		95,2,93,201,0,112,1,73,36,120,0,48,57,0,
		95,2,112,0,73,36,124,0,48,58,0,176,59,0,
		12,0,93,203,0,89,37,0,1,0,1,0,2,0,
		176,60,0,12,0,121,8,28,11,48,61,0,95,255,
		112,0,25,11,48,62,0,95,255,95,1,112,1,6,
		48,63,0,48,64,0,95,2,112,0,112,0,122,1,
		100,100,100,100,100,100,9,100,9,112,12,73,36,130,
		0,48,65,0,95,2,48,58,0,176,66,0,12,0,
		93,218,0,89,28,0,1,0,1,0,3,0,176,60,
		0,12,0,121,8,28,6,95,255,25,7,95,1,165,
		80,255,6,48,67,0,95,2,112,0,48,63,0,48,
		64,0,95,2,112,0,112,0,122,1,100,100,100,100,
		100,100,9,100,100,100,100,100,100,112,17,112,1,73,
		36,132,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TINFFAMPRE_LGENERATE )
{
	static const HB_BYTE pcode[] =
	{
		13,3,0,36,139,0,102,80,1,36,141,0,90,4,
		120,6,80,2,36,144,0,48,68,0,48,69,0,95,
		1,112,0,112,0,73,36,146,0,48,70,0,48,21,
		0,95,1,112,0,112,0,73,36,149,0,48,71,0,
		48,72,0,95,1,112,0,112,0,122,8,28,32,36,
		150,0,89,23,0,0,0,1,0,1,0,48,73,0,
		48,31,0,95,255,112,0,112,0,68,6,80,2,25,
		80,36,151,0,48,71,0,48,72,0,95,1,112,0,
		112,0,92,2,8,28,31,36,152,0,89,22,0,0,
		0,1,0,1,0,48,73,0,48,31,0,95,255,112,
		0,112,0,6,80,2,25,31,36,153,0,48,71,0,
		48,72,0,95,1,112,0,112,0,92,3,8,28,11,
		36,154,0,90,4,120,6,80,2,36,160,0,48,74,
		0,95,1,90,26,106,10,70,101,99,104,97,32,32,
		58,32,0,176,75,0,176,76,0,12,0,12,1,72,
		6,89,55,0,0,0,1,0,1,0,106,10,80,101,
		114,105,111,100,111,58,32,0,176,75,0,48,77,0,
		95,255,112,0,12,1,72,106,4,32,62,32,0,72,
		176,75,0,48,78,0,95,255,112,0,12,1,72,6,
		89,55,0,0,0,1,0,1,0,106,10,70,97,109,
		105,108,105,97,58,32,0,176,79,0,48,80,0,95,
		255,112,0,12,1,72,106,4,32,62,32,0,72,176,
		79,0,48,81,0,95,255,112,0,12,1,72,6,89,
		43,0,0,0,1,0,1,0,106,10,69,115,116,97,
		100,111,32,58,32,0,48,67,0,95,255,112,0,48,
		71,0,48,72,0,95,255,112,0,112,0,1,72,6,
		4,4,0,112,1,73,36,163,0,48,82,0,48,39,
		0,95,1,112,0,112,0,73,36,165,0,48,83,0,
		48,39,0,95,1,112,0,112,0,32,217,3,36,167,
		0,176,84,0,48,85,0,48,39,0,95,1,112,0,
		112,0,48,27,0,95,1,112,0,12,2,80,3,36,
		170,0,95,3,48,80,0,95,1,112,0,16,29,137,
		3,95,3,48,81,0,95,1,112,0,34,29,124,3,
		36,172,0,48,86,0,48,31,0,95,1,112,0,48,
		87,0,48,39,0,95,1,112,0,112,0,176,88,0,
		48,89,0,48,39,0,95,1,112,0,112,0,12,1,
		72,48,90,0,48,39,0,95,1,112,0,112,0,72,
		112,1,29,63,3,36,181,0,48,91,0,95,2,112,
		0,29,50,3,48,92,0,48,31,0,95,1,112,0,
		112,0,48,77,0,95,1,112,0,16,29,27,3,48,
		92,0,48,31,0,95,1,112,0,112,0,48,78,0,
		95,1,112,0,34,29,4,3,48,85,0,48,39,0,
		95,1,112,0,112,0,48,93,0,95,1,112,0,16,
		29,237,2,48,85,0,48,39,0,95,1,112,0,112,
		0,48,94,0,95,1,112,0,34,29,214,2,176,95,
		0,48,87,0,48,31,0,95,1,112,0,112,0,48,
		96,0,95,1,112,0,12,2,29,187,2,48,97,0,
		95,1,112,0,28,19,48,98,0,48,39,0,95,1,
		112,0,112,0,121,8,32,161,2,48,61,0,95,1,
		112,0,28,57,176,99,0,48,100,0,48,31,0,95,
		1,112,0,112,0,48,100,0,48,39,0,95,1,112,
		0,112,0,48,101,0,95,1,112,0,48,102,0,95,
		1,112,0,48,103,0,95,1,112,0,12,5,121,8,
		32,97,2,36,187,0,48,104,0,48,21,0,95,1,
		112,0,112,0,73,36,189,0,48,105,0,95,1,48,
		106,0,48,31,0,95,1,112,0,112,0,48,31,0,
		95,1,112,0,9,112,3,73,36,191,0,48,107,0,
		48,21,0,95,1,112,0,48,108,0,48,27,0,95,
		1,112,0,112,0,112,1,73,36,192,0,48,109,0,
		48,21,0,95,1,112,0,48,110,0,48,27,0,95,
		1,112,0,112,0,112,1,73,36,193,0,48,111,0,
		48,21,0,95,1,112,0,48,112,0,48,27,0,95,
		1,112,0,112,0,112,1,73,36,194,0,48,113,0,
		48,21,0,95,1,112,0,48,114,0,48,39,0,95,
		1,112,0,112,0,112,1,73,36,195,0,48,115,0,
		48,21,0,95,1,112,0,48,98,0,48,39,0,95,
		1,112,0,112,0,112,1,73,36,196,0,48,116,0,
		48,21,0,95,1,112,0,176,117,0,48,39,0,95,
		1,112,0,12,1,112,1,73,36,197,0,48,118,0,
		48,21,0,95,1,112,0,176,119,0,48,100,0,48,
		39,0,95,1,112,0,112,0,48,101,0,95,1,112,
		0,48,103,0,95,1,112,0,12,3,112,1,73,36,
		198,0,48,120,0,48,21,0,95,1,112,0,176,121,
		0,48,100,0,48,39,0,95,1,112,0,112,0,48,
		101,0,95,1,112,0,48,103,0,95,1,112,0,12,
		3,112,1,73,36,199,0,48,122,0,48,21,0,95,
		1,112,0,176,123,0,48,100,0,48,39,0,95,1,
		112,0,112,0,48,101,0,95,1,112,0,48,103,0,
		95,1,112,0,12,3,112,1,73,36,200,0,48,124,
		0,48,21,0,95,1,112,0,176,99,0,48,100,0,
		48,31,0,95,1,112,0,112,0,48,100,0,48,39,
		0,95,1,112,0,112,0,48,101,0,95,1,112,0,
		48,102,0,95,1,112,0,48,103,0,95,1,112,0,
		12,5,112,1,73,36,202,0,48,125,0,48,21,0,
		95,1,112,0,176,126,0,48,127,0,48,21,0,95,
		1,112,0,112,0,48,128,0,48,39,0,95,1,112,
		0,112,0,65,92,100,18,48,102,0,95,1,112,0,
		12,2,112,1,73,36,204,0,48,129,0,48,21,0,
		95,1,112,0,176,130,0,48,87,0,48,39,0,95,
		1,112,0,112,0,12,1,106,2,47,0,72,176,130,
		0,176,88,0,48,89,0,48,39,0,95,1,112,0,
		112,0,12,1,12,1,72,106,2,47,0,72,176,130,
		0,48,90,0,48,39,0,95,1,112,0,112,0,12,
		1,72,112,1,73,36,205,0,48,131,0,48,21,0,
		95,1,112,0,48,92,0,48,31,0,95,1,112,0,
		112,0,112,1,73,36,207,0,48,132,0,48,21,0,
		95,1,112,0,112,0,73,36,215,0,48,133,0,48,
		39,0,95,1,112,0,112,0,73,36,217,0,48,134,
		0,48,53,0,95,1,112,0,112,0,73,26,27,252,
		36,221,0,48,134,0,48,53,0,95,1,112,0,48,
		54,0,48,39,0,95,1,112,0,112,0,112,1,73,
		36,223,0,48,135,0,48,69,0,95,1,112,0,112,
		0,73,36,225,0,48,54,0,48,21,0,95,1,112,
		0,112,0,121,15,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,138,0,2,0,116,138,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}
