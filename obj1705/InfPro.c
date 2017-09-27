/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\InfPro.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( INFPRO );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( TINFGEN );
HB_FUNC_STATIC( INFPRO_CREATE );
HB_FUNC_STATIC( INFPRO_OPENFILES );
HB_FUNC_STATIC( INFPRO_CLOSEFILES );
HB_FUNC_STATIC( INFPRO_LRESOURCE );
HB_FUNC_STATIC( INFPRO_LGENERATE );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( DBFSERVER );
HB_FUNC_EXTERN( CDRIVER );
HB_FUNC_EXTERN( CPATART );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( DBFIRST );
HB_FUNC_EXTERN( DBLAST );
HB_FUNC_EXTERN( TCHECKBOX );
HB_FUNC_EXTERN( PCOUNT );
HB_FUNC_EXTERN( TGETHLP );
HB_FUNC_EXTERN( CPROMO );
HB_FUNC_EXTERN( BRWPROMO );
HB_FUNC_EXTERN( AITMPRM );
HB_FUNC_EXTERN( DTOC );
HB_FUNC_EXTERN( DATE );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( RETARTICULO );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_INFPRO )
{ "INFPRO", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( INFPRO )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "TINFGEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( TINFGEN )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INFPRO_CREATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( INFPRO_CREATE )}, NULL },
{ "INFPRO_OPENFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( INFPRO_OPENFILES )}, NULL },
{ "INFPRO_CLOSEFILES", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( INFPRO_CLOSEFILES )}, NULL },
{ "INFPRO_LRESOURCE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( INFPRO_LRESOURCE )}, NULL },
{ "INFPRO_LGENERATE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( INFPRO_LGENERATE )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDFIELD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDTMPINDEX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LDEFFECINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LDEFSERINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LDEFDIVINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "_ODBFPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NEWOPEN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBFSERVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBFSERVER )}, NULL },
{ "CDRIVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CDRIVER )}, NULL },
{ "CPATART", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPATART )}, NULL },
{ "ADDBAG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBFPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AUTOINDEX", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "CLOSEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "USED", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "STDRESOURCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CPROORG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBFIRST", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBFIRST )}, NULL },
{ "_CPRODES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBLAST", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBLAST )}, NULL },
{ "REDEFINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TCHECKBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( TCHECKBOX )}, NULL },
{ "PCOUNT", {HB_FS_PUBLIC}, {HB_FUNCNAME( PCOUNT )}, NULL },
{ "LALLPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LALLPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADIALOGS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OFLD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TGETHLP", {HB_FS_PUBLIC}, {HB_FUNCNAME( TGETHLP )}, NULL },
{ "CPROORG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BVALID", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPROMO", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPROMO )}, NULL },
{ "CALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_BHELP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "BRWPROMO", {HB_FS_PUBLIC}, {HB_FUNCNAME( BRWPROMO )}, NULL },
{ "CPRODES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETTOTAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OMTRINF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LASTREC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CREATEFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AITMPRM", {HB_FS_PUBLIC}, {HB_FUNCNAME( AITMPRM )}, NULL },
{ "DISABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODLG", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ENABLE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OBTNCANCEL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ZAP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_AHEADER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DTOC", {HB_FS_PUBLIC}, {HB_FUNCNAME( DTOC )}, NULL },
{ "DATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( DATE )}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "ORDSETFOCUS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GOTOP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LBREAK", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EOF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EVALFILTER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "APPEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCODPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CNOMPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCODART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CNOMART", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RETARTICULO", {HB_FS_PUBLIC}, {HB_FUNCNAME( RETARTICULO )}, NULL },
{ "_DINIPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DINIPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_DFINPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DFINPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NDTOPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "NDTOPRO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CCODTAR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CCODTAR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SAVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SKIP", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "AUTOINC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ORDKEYNO", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00002)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_INFPRO, ".\\.\\Prg\\InfPro.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_INFPRO
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_INFPRO )
   #include "hbiniseg.h"
#endif

HB_FUNC( INFPRO )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,100,0,36,8,0,103,2,0,100,8,
		29,203,1,176,1,0,104,2,0,12,1,29,192,1,
		166,130,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,7,73,110,102,80,114,111,0,108,4,4,1,
		0,108,0,112,3,80,2,36,10,0,48,5,0,95,
		2,106,7,79,66,74,69,67,84,0,100,95,1,121,
		72,121,72,121,72,106,8,111,68,98,102,80,114,111,
		0,4,1,0,9,112,5,73,36,11,0,48,5,0,
		95,2,106,10,67,72,65,82,65,67,84,69,82,0,
		100,95,1,121,72,121,72,121,72,106,8,99,80,114,
		111,79,114,103,0,4,1,0,9,112,5,73,36,12,
		0,48,5,0,95,2,106,10,67,72,65,82,65,67,
		84,69,82,0,100,95,1,121,72,121,72,121,72,106,
		8,99,80,114,111,68,101,115,0,4,1,0,9,112,
		5,73,36,13,0,48,5,0,95,2,106,6,76,79,
		71,73,67,0,120,95,1,121,72,121,72,121,72,106,
		8,108,65,108,108,80,114,111,0,4,1,0,9,112,
		5,73,36,15,0,48,6,0,95,2,106,7,67,114,
		101,97,116,101,0,108,7,95,1,121,72,121,72,121,
		72,112,3,73,36,17,0,48,6,0,95,2,106,10,
		79,112,101,110,70,105,108,101,115,0,108,8,95,1,
		121,72,121,72,121,72,112,3,73,36,19,0,48,6,
		0,95,2,106,11,67,108,111,115,101,70,105,108,101,
		115,0,108,9,95,1,121,72,121,72,121,72,112,3,
		73,36,21,0,48,6,0,95,2,106,10,108,82,101,
		115,111,117,114,99,101,0,108,10,95,1,121,72,121,
		72,121,72,112,3,73,36,23,0,48,6,0,95,2,
		106,10,108,71,101,110,101,114,97,116,101,0,108,11,
		95,1,121,72,121,72,121,72,112,3,73,36,25,0,
		48,12,0,95,2,112,0,73,167,14,0,0,176,13,
		0,104,2,0,95,2,20,2,168,48,14,0,95,2,
		112,0,80,3,176,15,0,95,3,106,10,73,110,105,
		116,67,108,97,115,115,0,12,2,28,12,48,16,0,
		95,3,164,146,1,0,73,95,3,110,7,48,14,0,
		103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( INFPRO_CREATE )
{
	static const HB_BYTE pcode[] =
	{
		36,31,0,48,17,0,102,106,8,99,67,111,100,80,
		114,111,0,106,2,67,0,92,5,121,90,6,106,1,
		0,6,106,10,67,243,100,46,32,112,114,109,46,0,
		120,106,23,67,243,100,105,103,111,32,100,101,32,108,
		97,32,112,114,111,109,111,99,105,243,110,0,92,5,
		9,112,10,73,36,32,0,48,17,0,102,106,8,99,
		78,111,109,80,114,111,0,106,2,67,0,92,25,121,
		90,6,106,1,0,6,106,7,78,111,109,98,114,101,
		0,9,106,23,78,111,109,98,114,101,32,100,101,32,
		108,97,32,112,114,111,109,111,99,105,243,110,0,92,
		20,9,112,10,73,36,33,0,48,17,0,102,106,8,
		99,67,111,100,65,114,116,0,106,2,67,0,92,18,
		121,90,6,106,1,0,6,106,16,67,243,100,105,103,
		111,32,97,114,116,237,99,117,108,111,0,120,106,20,
		67,243,100,105,103,111,32,100,101,108,32,97,114,116,
		237,99,117,108,111,0,92,15,9,112,10,73,36,34,
		0,48,17,0,102,106,8,99,78,111,109,65,114,116,
		0,106,2,67,0,92,100,121,90,6,106,1,0,6,
		106,9,65,114,116,237,99,117,108,111,0,120,106,20,
		78,111,109,98,114,101,32,100,101,108,32,97,114,116,
		237,99,117,108,111,0,92,50,9,112,10,73,36,35,
		0,48,17,0,102,106,8,100,73,110,105,80,114,111,
		0,106,2,68,0,92,8,121,90,6,106,1,0,6,
		106,7,73,110,105,99,105,111,0,120,106,23,70,101,
		99,104,97,32,105,110,105,99,105,111,32,112,114,111,
		109,111,99,105,243,110,0,92,10,9,112,10,73,36,
		36,0,48,17,0,102,106,8,100,70,105,110,80,114,
		111,0,106,2,68,0,92,8,121,90,6,106,1,0,
		6,106,4,70,105,110,0,120,106,20,70,101,99,104,
		97,32,102,105,110,32,112,114,111,109,111,99,105,243,
		110,0,92,10,9,112,10,73,36,37,0,48,17,0,
		102,106,8,110,68,116,111,80,114,111,0,106,2,78,
		0,92,5,92,2,90,14,106,9,64,69,32,57,57,
		46,57,57,0,6,106,7,37,32,68,116,111,46,0,
		120,106,24,80,111,114,99,101,110,116,97,106,101,32,
		100,101,32,100,101,115,99,117,101,110,116,111,0,92,
		5,9,112,10,73,36,38,0,48,17,0,102,106,8,
		99,67,111,100,84,97,114,0,106,2,67,0,92,5,
		121,90,6,106,1,0,6,106,5,84,97,114,46,0,
		9,106,20,67,243,100,105,103,111,32,100,101,32,108,
		97,32,116,97,114,105,102,97,0,92,5,9,112,10,
		73,36,40,0,48,18,0,102,106,8,99,67,111,100,
		80,114,111,0,106,8,99,67,111,100,80,114,111,0,
		112,2,73,36,42,0,48,19,0,102,9,112,1,73,
		36,43,0,48,20,0,102,9,112,1,73,36,44,0,
		48,21,0,102,9,112,1,73,36,46,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( INFPRO_OPENFILES )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,52,0,120,80,1,36,53,0,176,22,
		0,89,15,0,1,0,0,0,176,23,0,95,1,12,
		1,6,12,1,80,2,36,55,0,113,120,0,0,36,
		57,0,48,24,0,102,48,25,0,176,26,0,106,11,
		80,82,79,77,79,84,46,68,66,70,0,100,12,2,
		106,11,80,82,79,77,79,84,46,68,66,70,0,100,
		176,27,0,12,0,100,176,28,0,12,0,9,120,9,
		9,112,9,112,1,73,48,29,0,48,30,0,102,112,
		0,106,11,80,82,79,77,79,84,46,67,68,88,0,
		112,1,73,48,29,0,48,30,0,102,112,0,112,0,
		73,48,31,0,48,30,0,102,112,0,112,0,73,114,
		76,0,0,36,59,0,115,73,36,61,0,176,32,0,
		106,41,73,109,112,111,115,105,98,108,101,32,97,98,
		114,105,114,32,116,111,100,97,115,32,108,97,115,32,
		98,97,115,101,115,32,100,101,32,100,97,116,111,115,
		0,20,1,36,62,0,48,33,0,102,112,0,73,36,
		63,0,9,80,1,36,67,0,176,22,0,95,2,20,
		1,36,69,0,95,1,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( INFPRO_CLOSEFILES )
{
	static const HB_BYTE pcode[] =
	{
		36,75,0,176,34,0,48,30,0,102,112,0,12,1,
		31,30,48,35,0,48,30,0,102,112,0,112,0,28,
		17,36,76,0,48,36,0,48,30,0,102,112,0,112,
		0,73,36,79,0,48,24,0,102,100,112,1,73,36,
		81,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( INFPRO_LRESOURCE )
{
	static const HB_BYTE pcode[] =
	{
		13,7,1,36,85,0,102,80,2,36,94,0,48,37,
		0,95,2,106,10,73,78,70,95,80,82,79,48,49,
		0,112,1,31,8,36,95,0,9,110,7,36,102,0,
		48,38,0,95,2,176,39,0,48,30,0,95,2,112,
		0,122,12,2,112,1,73,36,103,0,48,40,0,95,
		2,176,41,0,48,30,0,95,2,112,0,122,12,2,
		112,1,73,36,104,0,176,39,0,48,30,0,95,2,
		112,0,92,2,12,2,80,3,36,105,0,176,41,0,
		48,30,0,95,2,112,0,92,2,12,2,80,4,36,
		109,0,48,42,0,176,43,0,12,0,92,60,89,37,
		0,1,0,1,0,2,0,176,44,0,12,0,121,8,
		28,11,48,45,0,95,255,112,0,25,11,48,46,0,
		95,255,95,1,112,1,6,48,47,0,48,48,0,95,
		2,112,0,112,0,122,1,100,100,100,100,100,100,9,
		100,9,112,12,73,36,116,0,48,42,0,176,49,0,
		12,0,92,70,89,37,0,1,0,1,0,2,0,176,
		44,0,12,0,121,8,28,11,48,50,0,95,255,112,
		0,25,11,48,38,0,95,255,95,1,112,1,6,48,
		47,0,48,48,0,95,2,112,0,112,0,122,1,100,
		100,100,106,5,78,47,87,42,0,100,100,100,100,9,
		89,18,0,0,0,1,0,2,0,48,45,0,95,255,
		112,0,68,6,100,9,9,100,100,100,100,100,100,106,
		5,76,85,80,65,0,100,100,112,25,80,7,36,118,
		0,48,51,0,95,7,89,35,0,0,0,3,0,7,
		0,2,0,5,0,176,52,0,95,255,48,53,0,48,
		30,0,95,254,112,0,112,0,95,253,12,3,6,112,
		1,73,36,119,0,48,54,0,95,7,89,35,0,0,
		0,3,0,7,0,2,0,5,0,176,55,0,95,255,
		48,53,0,48,30,0,95,254,112,0,112,0,95,253,
		12,3,6,112,1,73,36,125,0,48,42,0,176,49,
		0,12,0,92,80,89,28,0,1,0,1,0,3,0,
		176,44,0,12,0,121,8,28,6,95,255,25,7,95,
		1,165,80,255,6,48,47,0,48,48,0,95,2,112,
		0,112,0,122,1,100,100,100,106,5,78,47,87,42,
		0,100,100,100,100,9,90,4,9,6,100,9,9,100,
		100,100,100,100,100,100,100,100,112,25,80,5,36,132,
		0,48,42,0,176,49,0,12,0,92,90,89,37,0,
		1,0,1,0,2,0,176,44,0,12,0,121,8,28,
		11,48,56,0,95,255,112,0,25,11,48,40,0,95,
		255,95,1,112,1,6,48,47,0,48,48,0,95,2,
		112,0,112,0,122,1,100,100,100,106,5,78,47,87,
		42,0,100,100,100,100,9,89,18,0,0,0,1,0,
		2,0,48,45,0,95,255,112,0,68,6,100,9,9,
		100,100,100,100,100,100,106,5,76,85,80,65,0,100,
		100,112,25,80,8,36,134,0,48,51,0,95,8,89,
		35,0,0,0,3,0,8,0,2,0,6,0,176,52,
		0,95,255,48,53,0,48,30,0,95,254,112,0,112,
		0,95,253,12,3,6,112,1,73,36,135,0,48,54,
		0,95,8,89,35,0,0,0,3,0,8,0,2,0,
		6,0,176,55,0,95,255,48,53,0,48,30,0,95,
		254,112,0,112,0,95,253,12,3,6,112,1,73,36,
		140,0,48,42,0,176,49,0,12,0,92,100,89,28,
		0,1,0,1,0,4,0,176,44,0,12,0,121,8,
		28,6,95,255,25,7,95,1,165,80,255,6,48,47,
		0,48,48,0,95,2,112,0,112,0,122,1,100,100,
		100,100,100,100,100,100,9,90,4,9,6,100,9,9,
		100,100,100,100,100,100,100,100,100,112,25,80,6,36,
		146,0,48,57,0,48,58,0,95,2,112,0,48,59,
		0,48,30,0,95,2,112,0,112,0,112,1,73,36,
		148,0,48,60,0,95,2,176,61,0,12,0,48,30,
		0,95,2,112,0,112,2,73,36,150,0,120,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( INFPRO_LGENERATE )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,157,0,102,80,1,36,159,0,48,62,
		0,48,63,0,95,1,112,0,112,0,73,36,160,0,
		48,64,0,48,65,0,95,1,112,0,112,0,73,36,
		161,0,48,66,0,48,67,0,95,1,112,0,112,0,
		73,36,164,0,48,68,0,95,1,90,31,106,15,70,
		101,99,104,97,32,32,32,32,32,32,32,58,32,0,
		176,69,0,176,70,0,12,0,12,1,72,6,89,79,
		0,0,0,1,0,1,0,106,15,80,114,111,109,111,
		99,105,111,110,101,115,32,58,32,0,48,45,0,95,
		255,112,0,28,12,106,6,84,111,100,111,115,0,25,
		34,176,71,0,48,50,0,95,255,112,0,12,1,106,
		4,32,62,32,0,72,176,71,0,48,56,0,95,255,
		112,0,12,1,72,72,6,4,2,0,112,1,73,36,
		166,0,48,72,0,48,30,0,95,1,112,0,106,8,
		67,67,79,68,80,82,79,0,112,1,73,36,168,0,
		48,73,0,48,30,0,95,1,112,0,112,0,73,36,
		170,0,48,74,0,95,1,112,0,32,138,1,48,75,
		0,48,30,0,95,1,112,0,112,0,32,123,1,36,
		173,0,48,45,0,95,1,112,0,31,48,48,76,0,
		48,30,0,95,1,112,0,112,0,48,50,0,95,1,
		112,0,16,29,41,1,48,76,0,48,30,0,95,1,
		112,0,112,0,48,56,0,95,1,112,0,34,29,18,
		1,48,77,0,95,1,112,0,29,8,1,36,175,0,
		48,78,0,48,67,0,95,1,112,0,112,0,73,36,
		177,0,48,79,0,48,67,0,95,1,112,0,48,76,
		0,48,30,0,95,1,112,0,112,0,112,1,73,36,
		178,0,48,80,0,48,67,0,95,1,112,0,48,81,
		0,48,30,0,95,1,112,0,112,0,112,1,73,36,
		179,0,48,82,0,48,67,0,95,1,112,0,48,83,
		0,48,30,0,95,1,112,0,112,0,112,1,73,36,
		180,0,48,84,0,48,67,0,95,1,112,0,176,85,
		0,48,83,0,48,67,0,95,1,112,0,112,0,12,
		1,112,1,73,36,181,0,48,86,0,48,67,0,95,
		1,112,0,48,87,0,48,30,0,95,1,112,0,112,
		0,112,1,73,36,182,0,48,88,0,48,67,0,95,
		1,112,0,48,89,0,48,30,0,95,1,112,0,112,
		0,112,1,73,36,183,0,48,90,0,48,67,0,95,
		1,112,0,48,91,0,48,30,0,95,1,112,0,112,
		0,112,1,73,36,184,0,48,92,0,48,67,0,95,
		1,112,0,48,93,0,48,30,0,95,1,112,0,112,
		0,112,1,73,36,186,0,48,94,0,48,67,0,95,
		1,112,0,112,0,73,36,190,0,48,95,0,48,30,
		0,95,1,112,0,112,0,73,36,192,0,48,96,0,
		48,58,0,95,1,112,0,48,97,0,48,30,0,95,
		1,112,0,112,0,112,1,73,26,111,254,36,196,0,
		48,96,0,48,58,0,95,1,112,0,48,59,0,48,
		30,0,95,1,112,0,112,0,112,1,73,36,198,0,
		48,64,0,48,63,0,95,1,112,0,112,0,73,36,
		200,0,48,59,0,48,67,0,95,1,112,0,112,0,
		121,15,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,100,0,2,0,116,100,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

