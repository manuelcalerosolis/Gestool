/*
 * Harbour 3.2.0dev (r1307082134)
 * Borland C++ 5.8.2 (32-bit)
 * Generated C source from ".\.\Prg\Intitem.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( TSENDERRECIVERITEM );
HB_FUNC_EXTERN( __CLSLOCKDEF );
HB_FUNC_EXTERN( HBCLASS );
HB_FUNC_EXTERN( HBOBJECT );
HB_FUNC_STATIC( TSENDERRECIVERITEM_NEW );
HB_FUNC_STATIC( TSENDERRECIVERITEM_SAVE );
HB_FUNC_STATIC( TSENDERRECIVERITEM_LOAD );
HB_FUNC_STATIC( TSENDERRECIVERITEM_NGETNUMBERTOSEND );
HB_FUNC_EXTERN( WRITEPPROSTRING );
HB_FUNC_EXTERN( CVALTOCHAR );
HB_FUNC_STATIC( TSENDERRECIVERITEM_GETFILENAMETOSEND );
HB_FUNC_EXTERN( __CLSUNLOCKDEF );
HB_FUNC_EXTERN( __OBJHASMSG );
HB_FUNC_EXTERN( CFULLPATHEMPRESA );
HB_FUNC_EXTERN( UPPER );
HB_FUNC_EXTERN( GETPVPROFSTRING );
HB_FUNC_EXTERN( GETPVPROFINT );
HB_FUNC_EXTERN( STRZERO );
HB_FUNC_EXTERN( RETSUFEMP );
HB_FUNC( TCLIENTESENDERRECIVER );
HB_FUNC_STATIC( TCLIENTESENDERRECIVER_CREATEDATA );
HB_FUNC_STATIC( TCLIENTESENDERRECIVER_RESTOREDATA );
HB_FUNC_STATIC( TCLIENTESENDERRECIVER_SENDDATA );
HB_FUNC_STATIC( TCLIENTESENDERRECIVER_RECIVEDATA );
HB_FUNC_STATIC( TCLIENTESENDERRECIVER_PROCESS );
HB_FUNC_STATIC( TCLIENTESENDERRECIVER_CLEANRELATION );
HB_FUNC_EXTERN( ERRORBLOCK );
HB_FUNC_EXTERN( APOLOBREAK );
HB_FUNC_EXTERN( DBUSEAREA );
HB_FUNC_EXTERN( CDRIVER );
HB_FUNC_EXTERN( CPATCLI );
HB_FUNC_EXTERN( CCHECKAREA );
HB_FUNC_EXTERN( LAIS );
HB_FUNC_EXTERN( ORDLISTADD );
HB_FUNC_EXTERN( ORDSETFOCUS );
HB_FUNC_EXTERN( MKCLIENT );
HB_FUNC_EXTERN( CPATSND );
HB_FUNC_EXTERN( CLOCALDRIVER );
HB_FUNC_EXTERN( TATIPICAS );
HB_FUNC_EXTERN( EMPTY );
HB_FUNC_EXTERN( LASTREC );
HB_FUNC_EXTERN( DBGOTOP );
HB_FUNC_EXTERN( EOF );
HB_FUNC_EXTERN( DBPASS );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( DBSEEK );
HB_FUNC_EXTERN( SYSREFRESH );
HB_FUNC_EXTERN( DBSKIP );
HB_FUNC_EXTERN( LOGWRITE );
HB_FUNC_EXTERN( ORDKEYNO );
HB_FUNC_EXTERN( MSGSTOP );
HB_FUNC_EXTERN( ERRORMESSAGE );
HB_FUNC_EXTERN( DBCLOSEAREA );
HB_FUNC_EXTERN( DBLOCK );
HB_FUNC_EXTERN( DBUNLOCK );
HB_FUNC_EXTERN( FILE );
HB_FUNC_EXTERN( CPATOUT );
HB_FUNC_EXTERN( ARETDLGEMP );
HB_FUNC_EXTERN( CPATIN );
HB_FUNC_EXTERN( LEN );
HB_FUNC_EXTERN( DIRECTORY );
HB_FUNC_EXTERN( FSIZE );
HB_FUNC_EXTERN( LEXISTTABLE );
HB_FUNC_EXTERN( RECNO );
HB_FUNC_EXTERN( DBDEL );
HB_FUNC_EXTERN( FW_GT );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_INITSTATICS();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_INTITEM )
{ "TSENDERRECIVERITEM", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDERRECIVERITEM )}, NULL },
{ "__CLSLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSLOCKDEF )}, NULL },
{ "NEW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "HBCLASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBCLASS )}, NULL },
{ "HBOBJECT", {HB_FS_PUBLIC}, {HB_FUNCNAME( HBOBJECT )}, NULL },
{ "ADDMULTIDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ADDMETHOD", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TSENDERRECIVERITEM_NEW", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDERRECIVERITEM_NEW )}, NULL },
{ "ADDVIRTUAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TSENDERRECIVERITEM_SAVE", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDERRECIVERITEM_SAVE )}, NULL },
{ "TSENDERRECIVERITEM_LOAD", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDERRECIVERITEM_LOAD )}, NULL },
{ "TSENDERRECIVERITEM_NGETNUMBERTOSEND", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDERRECIVERITEM_NGETNUMBERTOSEND )}, NULL },
{ "ADDINLINE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "WRITEPPROSTRING", {HB_FS_PUBLIC}, {HB_FUNCNAME( WRITEPPROSTRING )}, NULL },
{ "CTEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CVALTOCHAR", {HB_FS_PUBLIC}, {HB_FUNCNAME( CVALTOCHAR )}, NULL },
{ "NNUMBERSEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CINIFILE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NNUMBERSEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "TSENDERRECIVERITEM_GETFILENAMETOSEND", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TSENDERRECIVERITEM_GETFILENAMETOSEND )}, NULL },
{ "CREATE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__CLSUNLOCKDEF", {HB_FS_PUBLIC}, {HB_FUNCNAME( __CLSUNLOCKDEF )}, NULL },
{ "INSTANCE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "__OBJHASMSG", {HB_FS_PUBLIC}, {HB_FUNCNAME( __OBJHASMSG )}, NULL },
{ "INITCLASS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CTEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_CINIFILE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CFULLPATHEMPRESA", {HB_FS_PUBLIC}, {HB_FUNCNAME( CFULLPATHEMPRESA )}, NULL },
{ "_LSUCCESFULLSEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LSELECTSEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LSELECTRECIVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_LSELECTSEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "UPPER", {HB_FS_PUBLIC}, {HB_FUNCNAME( UPPER )}, NULL },
{ "GETPVPROFSTRING", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETPVPROFSTRING )}, NULL },
{ "_LSELECTRECIVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "GETPVPROFINT", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETPVPROFINT )}, NULL },
{ "STRZERO", {HB_FS_PUBLIC}, {HB_FUNCNAME( STRZERO )}, NULL },
{ "NGETNUMBERTOSEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LSERVER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OSENDER", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RETSUFEMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( RETSUFEMP )}, NULL },
{ "TCLIENTESENDERRECIVER", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCLIENTESENDERRECIVER )}, NULL },
{ "TCLIENTESENDERRECIVER_CREATEDATA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCLIENTESENDERRECIVER_CREATEDATA )}, NULL },
{ "TCLIENTESENDERRECIVER_RESTOREDATA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCLIENTESENDERRECIVER_RESTOREDATA )}, NULL },
{ "TCLIENTESENDERRECIVER_SENDDATA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCLIENTESENDERRECIVER_SENDDATA )}, NULL },
{ "TCLIENTESENDERRECIVER_RECIVEDATA", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCLIENTESENDERRECIVER_RECIVEDATA )}, NULL },
{ "TCLIENTESENDERRECIVER_PROCESS", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCLIENTESENDERRECIVER_PROCESS )}, NULL },
{ "TCLIENTESENDERRECIVER_CLEANRELATION", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( TCLIENTESENDERRECIVER_CLEANRELATION )}, NULL },
{ "SETTEXT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ERRORBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORBLOCK )}, NULL },
{ "APOLOBREAK", {HB_FS_PUBLIC}, {HB_FUNCNAME( APOLOBREAK )}, NULL },
{ "DBUSEAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBUSEAREA )}, NULL },
{ "CDRIVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CDRIVER )}, NULL },
{ "CPATCLI", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPATCLI )}, NULL },
{ "CCHECKAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( CCHECKAREA )}, NULL },
{ "LAIS", {HB_FS_PUBLIC}, {HB_FUNCNAME( LAIS )}, NULL },
{ "ORDLISTADD", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDLISTADD )}, NULL },
{ "ORDSETFOCUS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDSETFOCUS )}, NULL },
{ "MKCLIENT", {HB_FS_PUBLIC}, {HB_FUNCNAME( MKCLIENT )}, NULL },
{ "CPATSND", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPATSND )}, NULL },
{ "CLOCALDRIVER", {HB_FS_PUBLIC}, {HB_FUNCNAME( CLOCALDRIVER )}, NULL },
{ "TATIPICAS", {HB_FS_PUBLIC}, {HB_FUNCNAME( TATIPICAS )}, NULL },
{ "OPENFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CALIAS", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ODBF", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "EMPTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( EMPTY )}, NULL },
{ "OMTR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_NTOTAL", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LASTREC", {HB_FS_PUBLIC}, {HB_FUNCNAME( LASTREC )}, NULL },
{ "DBGOTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBGOTOP )}, NULL },
{ "EOF", {HB_FS_PUBLIC}, {HB_FUNCNAME( EOF )}, NULL },
{ "LSNDINT", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "NTIPCLI", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "DBPASS", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBPASS )}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "COD", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "TITULO", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "DBSEEK", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBSEEK )}, NULL },
{ "CCODCLI", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "SYSREFRESH", {HB_FS_PUBLIC}, {HB_FUNCNAME( SYSREFRESH )}, NULL },
{ "DBSKIP", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBSKIP )}, NULL },
{ "LOGWRITE", {HB_FS_PUBLIC}, {HB_FUNCNAME( LOGWRITE )}, NULL },
{ "ORDKEYNO", {HB_FS_PUBLIC}, {HB_FUNCNAME( ORDKEYNO )}, NULL },
{ "SET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGSTOP", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGSTOP )}, NULL },
{ "ERRORMESSAGE", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORMESSAGE )}, NULL },
{ "CLOSEFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "END", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBCLOSEAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBCLOSEAREA )}, NULL },
{ "LZIPDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LSUCCESFULLSEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBLOCK )}, NULL },
{ "DBUNLOCK", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBUNLOCK )}, NULL },
{ "FILE", {HB_FS_PUBLIC}, {HB_FUNCNAME( FILE )}, NULL },
{ "CPATOUT", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPATOUT )}, NULL },
{ "SENDFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "INCNUMBERTOSEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ARETDLGEMP", {HB_FS_PUBLIC}, {HB_FUNCNAME( ARETDLGEMP )}, NULL },
{ "GETFILES", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "CPATIN", {HB_FS_PUBLIC}, {HB_FUNCNAME( CPATIN )}, NULL },
{ "LEN", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEN )}, NULL },
{ "DIRECTORY", {HB_FS_PUBLIC}, {HB_FUNCNAME( DIRECTORY )}, NULL },
{ "FSIZE", {HB_FS_PUBLIC}, {HB_FUNCNAME( FSIZE )}, NULL },
{ "LUNZIPDATA", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LEXISTTABLE", {HB_FS_PUBLIC}, {HB_FUNCNAME( LEXISTTABLE )}, NULL },
{ "CLEANRELATION", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RECNO", {HB_FS_PUBLIC}, {HB_FUNCNAME( RECNO )}, NULL },
{ "CCODART", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CCODFAM", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CCODOBR", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "APPENDFILERECIVE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBDEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBDEL )}, NULL },
{ "FW_GT", {HB_FS_PUBLIC}, {HB_FUNCNAME( FW_GT )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "(_INITSTATICS00003)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITSTATICS}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_INTITEM, ".\\.\\Prg\\Intitem.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_INTITEM
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_INTITEM )
   #include "hbiniseg.h"
#endif

HB_FUNC( TSENDERRECIVERITEM )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,115,0,36,8,0,103,2,0,100,8,
		29,211,3,176,1,0,104,2,0,12,1,29,200,3,
		166,138,3,0,122,80,1,48,2,0,176,3,0,12,
		0,106,19,84,83,101,110,100,101,114,82,101,99,105,
		118,101,114,73,116,101,109,0,108,4,4,1,0,108,
		0,112,3,80,2,36,10,0,48,5,0,95,2,100,
		100,95,1,121,72,121,72,121,72,106,6,99,84,101,
		120,116,0,4,1,0,9,112,5,73,36,12,0,48,
		5,0,95,2,100,100,95,1,121,72,121,72,121,72,
		106,8,111,83,101,110,100,101,114,0,4,1,0,9,
		112,5,73,36,14,0,48,5,0,95,2,100,100,95,
		1,121,72,121,72,121,72,106,12,108,83,101,108,101,
		99,116,83,101,110,100,0,4,1,0,9,112,5,73,
		36,15,0,48,5,0,95,2,100,100,95,1,121,72,
		121,72,121,72,106,14,108,83,101,108,101,99,116,82,
		101,99,105,118,101,0,4,1,0,9,112,5,73,36,
		17,0,48,5,0,95,2,100,121,95,1,121,72,121,
		72,121,72,106,12,110,78,117,109,98,101,114,83,101,
		110,100,0,4,1,0,9,112,5,73,36,18,0,48,
		5,0,95,2,100,121,95,1,121,72,121,72,121,72,
		106,14,110,78,117,109,98,101,114,82,101,99,105,118,
		101,0,4,1,0,9,112,5,73,36,20,0,48,5,
		0,95,2,100,100,95,1,121,72,121,72,121,72,106,
		9,99,73,110,105,70,105,108,101,0,4,1,0,9,
		112,5,73,36,22,0,48,5,0,95,2,100,100,95,
		1,121,72,121,72,121,72,106,10,99,70,105,108,101,
		78,97,109,101,0,4,1,0,9,112,5,73,36,24,
		0,48,5,0,95,2,100,100,95,1,121,72,121,72,
		121,72,106,16,108,83,117,99,99,101,115,102,117,108,
		108,83,101,110,100,0,4,1,0,9,112,5,73,36,
		26,0,48,5,0,95,2,100,106,1,0,95,1,121,
		72,121,72,121,72,106,16,99,69,114,114,111,114,82,
		101,99,101,112,99,105,111,110,0,4,1,0,9,112,
		5,73,36,28,0,48,6,0,95,2,106,4,78,101,
		119,0,108,7,95,1,121,72,121,72,121,72,112,3,
		73,36,30,0,48,8,0,95,2,106,11,67,114,101,
		97,116,101,68,97,116,97,0,112,1,73,36,32,0,
		48,8,0,95,2,106,12,82,101,115,116,111,114,101,
		68,97,116,97,0,112,1,73,36,34,0,48,8,0,
		95,2,106,9,83,101,110,100,68,97,116,97,0,112,
		1,73,36,36,0,48,8,0,95,2,106,11,82,101,
		99,105,118,101,68,97,116,97,0,112,1,73,36,38,
		0,48,8,0,95,2,106,8,80,114,111,99,101,115,
		115,0,112,1,73,36,40,0,48,6,0,95,2,106,
		5,83,97,118,101,0,108,9,95,1,121,72,121,72,
		121,72,112,3,73,36,42,0,48,6,0,95,2,106,
		5,76,111,97,100,0,108,10,95,1,121,72,121,72,
		121,72,112,3,73,36,44,0,48,6,0,95,2,106,
		17,110,71,101,116,78,117,109,98,101,114,84,111,83,
		101,110,100,0,108,11,95,1,121,72,121,72,121,72,
		112,3,73,36,46,0,48,12,0,95,2,106,16,83,
		101,116,78,117,109,98,101,114,84,111,83,101,110,100,
		0,89,48,0,1,0,0,0,176,13,0,106,7,78,
		117,109,101,114,111,0,48,14,0,95,1,112,0,176,
		15,0,48,16,0,95,1,112,0,12,1,48,17,0,
		95,1,112,0,12,4,6,95,1,121,72,121,72,121,
		72,112,3,73,36,48,0,48,12,0,95,2,106,16,
		73,110,99,78,117,109,98,101,114,84,111,83,101,110,
		100,0,89,57,0,1,0,0,0,176,13,0,106,7,
		78,117,109,101,114,111,0,48,14,0,95,1,112,0,
		176,15,0,48,18,0,95,1,21,48,16,0,163,0,
		112,0,23,112,1,12,1,48,17,0,95,1,112,0,
		12,4,6,95,1,121,72,121,72,121,72,112,3,73,
		36,50,0,48,6,0,95,2,106,18,71,101,116,70,
		105,108,101,78,97,109,101,84,111,83,101,110,100,0,
		108,19,95,1,121,72,121,72,121,72,112,3,73,36,
		52,0,48,20,0,95,2,112,0,73,167,14,0,0,
		176,21,0,104,2,0,95,2,20,2,168,48,22,0,
		95,2,112,0,80,3,176,23,0,95,3,106,10,73,
		110,105,116,67,108,97,115,115,0,12,2,28,12,48,
		24,0,95,3,164,146,1,0,73,95,3,110,7,48,
		22,0,103,2,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDERRECIVERITEM_NEW )
{
	static const HB_BYTE pcode[] =
	{
		13,0,2,36,58,0,48,25,0,102,95,1,112,1,
		73,36,59,0,48,26,0,102,95,2,112,1,73,36,
		61,0,48,27,0,102,176,28,0,12,0,106,12,69,
		109,112,114,101,115,97,46,73,110,105,0,72,112,1,
		73,36,63,0,48,29,0,102,9,112,1,73,36,65,
		0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDERRECIVERITEM_SAVE )
{
	static const HB_BYTE pcode[] =
	{
		36,71,0,176,13,0,106,6,69,110,118,105,111,0,
		48,14,0,102,112,0,176,15,0,48,30,0,102,112,
		0,12,1,48,17,0,102,112,0,20,4,36,72,0,
		176,13,0,106,10,82,101,99,101,112,99,105,111,110,
		0,48,14,0,102,112,0,176,15,0,48,31,0,102,
		112,0,12,1,48,17,0,102,112,0,20,4,36,74,
		0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDERRECIVERITEM_LOAD )
{
	static const HB_BYTE pcode[] =
	{
		36,80,0,48,32,0,102,176,33,0,176,34,0,106,
		6,69,110,118,105,111,0,48,14,0,102,112,0,176,
		15,0,48,30,0,102,112,0,12,1,48,17,0,102,
		112,0,12,4,12,1,106,4,46,84,46,0,8,112,
		1,73,36,81,0,48,35,0,102,176,33,0,176,34,
		0,106,10,82,101,99,101,112,99,105,111,110,0,48,
		14,0,102,112,0,176,15,0,48,31,0,102,112,0,
		12,1,48,17,0,102,112,0,12,4,12,1,106,4,
		46,84,46,0,8,112,1,73,36,83,0,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDERRECIVERITEM_NGETNUMBERTOSEND )
{
	static const HB_BYTE pcode[] =
	{
		36,89,0,48,18,0,102,176,36,0,106,7,78,117,
		109,101,114,111,0,48,14,0,102,112,0,48,16,0,
		102,112,0,48,17,0,102,112,0,12,4,112,1,73,
		36,91,0,48,16,0,102,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TSENDERRECIVERITEM_GETFILENAMETOSEND )
{
	static const HB_BYTE pcode[] =
	{
		13,1,1,36,97,0,95,1,176,37,0,48,38,0,
		102,112,0,92,6,12,2,72,80,2,36,99,0,48,
		39,0,48,40,0,102,112,0,112,0,28,18,36,100,
		0,96,2,0,106,5,46,65,108,108,0,135,25,19,
		36,102,0,96,2,0,106,2,46,0,176,41,0,12,
		0,72,135,36,105,0,95,2,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( TCLIENTESENDERRECIVER )
{
	static const HB_BYTE pcode[] =
	{
		149,3,0,116,115,0,36,109,0,103,3,0,100,8,
		29,81,1,176,1,0,104,3,0,12,1,29,70,1,
		166,8,1,0,122,80,1,48,2,0,176,3,0,12,
		0,106,22,84,67,108,105,101,110,116,101,83,101,110,
		100,101,114,82,101,99,105,118,101,114,0,108,0,4,
		1,0,108,42,112,3,80,2,36,111,0,48,6,0,
		95,2,106,11,67,114,101,97,116,101,68,97,116,97,
		0,108,43,95,1,121,72,121,72,121,72,112,3,73,
		36,113,0,48,6,0,95,2,106,12,82,101,115,116,
		111,114,101,68,97,116,97,0,108,44,95,1,121,72,
		121,72,121,72,112,3,73,36,115,0,48,6,0,95,
		2,106,9,83,101,110,100,68,97,116,97,0,108,45,
		95,1,121,72,121,72,121,72,112,3,73,36,117,0,
		48,6,0,95,2,106,11,82,101,99,105,118,101,68,
		97,116,97,0,108,46,95,1,121,72,121,72,121,72,
		112,3,73,36,119,0,48,6,0,95,2,106,8,80,
		114,111,99,101,115,115,0,108,47,95,1,121,72,121,
		72,121,72,112,3,73,36,121,0,48,6,0,95,2,
		106,14,67,108,101,97,110,82,101,108,97,116,105,111,
		110,0,108,48,95,1,121,72,121,72,121,72,112,3,
		73,36,123,0,48,20,0,95,2,112,0,73,167,14,
		0,0,176,21,0,104,3,0,95,2,20,2,168,48,
		22,0,95,2,112,0,80,3,176,23,0,95,3,106,
		10,73,110,105,116,67,108,97,115,115,0,12,2,28,
		12,48,24,0,95,3,164,146,1,0,73,95,3,110,
		7,48,22,0,103,3,0,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCLIENTESENDERRECIVER_CREATEDATA )
{
	static const HB_BYTE pcode[] =
	{
		13,13,0,36,129,0,9,80,1,36,143,0,48,39,
		0,48,40,0,102,112,0,112,0,28,37,36,144,0,
		106,4,67,108,105,0,176,37,0,48,38,0,102,112,
		0,92,6,12,2,72,106,5,46,65,108,108,0,72,
		80,12,25,38,36,146,0,106,4,67,108,105,0,176,
		37,0,48,38,0,102,112,0,92,6,12,2,72,106,
		2,46,0,72,176,41,0,12,0,72,80,12,36,149,
		0,48,49,0,48,40,0,102,112,0,106,18,69,110,
		118,105,97,110,100,111,32,99,108,105,101,110,116,101,
		115,0,112,1,73,36,151,0,176,50,0,89,15,0,
		1,0,0,0,176,51,0,95,1,12,1,6,12,1,
		80,11,36,152,0,113,211,4,0,36,154,0,176,52,
		0,120,176,53,0,12,0,176,54,0,12,0,106,11,
		67,76,73,69,78,84,46,68,66,70,0,72,176,55,
		0,106,7,67,76,73,69,78,84,0,96,6,0,12,
		2,120,9,20,6,36,155,0,176,56,0,12,0,31,
		28,176,57,0,176,54,0,12,0,106,11,67,76,73,
		69,78,84,46,67,68,88,0,72,20,1,25,8,176,
		58,0,122,20,1,36,156,0,85,95,6,74,176,58,
		0,106,8,108,83,110,100,73,110,116,0,20,1,74,
		36,158,0,176,52,0,120,176,53,0,12,0,176,54,
		0,12,0,106,11,67,108,105,65,116,112,46,68,98,
		102,0,72,176,55,0,106,7,67,76,73,65,84,80,
		0,96,7,0,12,2,120,9,20,6,36,159,0,176,
		56,0,12,0,31,28,176,57,0,176,54,0,12,0,
		106,11,67,108,105,65,116,112,46,67,100,120,0,72,
		20,1,25,8,176,58,0,122,20,1,36,161,0,176,
		52,0,120,176,53,0,12,0,176,54,0,12,0,106,
		11,79,98,114,97,115,84,46,68,98,102,0,72,176,
		55,0,106,7,79,66,82,65,83,84,0,96,8,0,
		12,2,120,9,20,6,36,162,0,176,56,0,12,0,
		31,28,176,57,0,176,54,0,12,0,106,11,79,98,
		114,97,115,84,46,67,100,120,0,72,20,1,25,8,
		176,58,0,122,20,1,36,164,0,176,52,0,120,176,
		53,0,12,0,176,54,0,12,0,106,11,67,108,105,
		67,116,111,46,68,98,102,0,72,176,55,0,106,7,
		67,108,105,67,116,111,0,96,9,0,12,2,120,9,
		20,6,36,165,0,176,56,0,12,0,31,28,176,57,
		0,176,54,0,12,0,106,11,67,108,105,67,116,111,
		46,67,100,120,0,72,20,1,25,8,176,58,0,122,
		20,1,36,171,0,176,59,0,176,60,0,12,0,20,
		1,36,173,0,176,52,0,120,176,61,0,12,0,176,
		60,0,12,0,106,11,67,108,105,101,110,116,46,68,
		98,102,0,72,176,55,0,106,7,67,108,105,101,110,
		116,0,96,2,0,12,2,9,20,5,36,174,0,85,
		95,2,74,176,57,0,176,60,0,12,0,106,11,67,
		108,105,101,110,116,46,67,100,120,0,72,20,1,74,
		36,176,0,176,52,0,120,176,61,0,12,0,176,60,
		0,12,0,106,11,79,98,114,97,115,84,46,68,98,
		102,0,72,176,55,0,106,7,79,98,114,97,115,84,
		0,96,4,0,12,2,9,20,5,36,177,0,85,95,
		4,74,176,57,0,176,60,0,12,0,106,11,79,98,
		114,97,115,84,46,67,100,120,0,72,20,1,74,36,
		179,0,176,52,0,120,176,61,0,12,0,176,60,0,
		12,0,106,11,67,108,105,67,116,111,46,68,98,102,
		0,72,176,55,0,106,7,67,108,105,67,116,111,0,
		96,5,0,12,2,9,20,5,36,180,0,85,95,5,
		74,176,57,0,176,60,0,12,0,106,11,67,108,105,
		67,116,111,46,67,100,120,0,72,20,1,74,36,186,
		0,48,2,0,176,62,0,12,0,176,60,0,12,0,
		176,61,0,12,0,112,2,80,13,36,187,0,48,63,
		0,95,13,9,176,60,0,12,0,112,2,73,36,189,
		0,48,64,0,48,65,0,95,13,112,0,112,0,80,
		3,36,191,0,176,66,0,48,67,0,48,40,0,102,
		112,0,112,0,12,1,31,32,36,192,0,48,68,0,
		48,67,0,48,40,0,102,112,0,112,0,85,95,6,
		74,176,69,0,12,0,119,112,1,73,36,195,0,85,
		95,6,74,176,70,0,20,0,74,36,196,0,85,95,
		6,74,176,71,0,12,0,119,32,171,1,36,202,0,
		95,6,88,72,0,29,84,1,95,6,88,73,0,92,
		2,69,29,73,1,36,204,0,120,80,1,36,206,0,
		176,74,0,95,6,95,2,120,20,3,36,207,0,48,
		49,0,48,40,0,102,112,0,176,75,0,95,6,88,
		76,0,12,1,106,3,59,32,0,72,95,6,88,77,
		0,72,112,1,73,36,209,0,85,95,8,74,176,78,
		0,95,6,88,76,0,12,1,119,28,66,36,210,0,
		95,8,88,79,0,95,6,88,76,0,8,28,50,85,
		95,8,74,176,71,0,12,0,119,31,38,36,211,0,
		176,74,0,95,8,95,4,120,20,3,36,212,0,176,
		80,0,20,0,36,213,0,85,95,8,74,176,81,0,
		20,0,74,25,194,36,217,0,85,95,9,74,176,78,
		0,95,6,88,76,0,12,1,119,28,66,36,218,0,
		95,9,88,79,0,95,6,88,76,0,8,28,50,85,
		95,9,74,176,71,0,12,0,119,31,38,36,219,0,
		176,74,0,95,9,95,5,120,20,3,36,220,0,176,
		80,0,20,0,36,221,0,85,95,9,74,176,81,0,
		20,0,74,25,194,36,225,0,85,95,7,74,176,78,
		0,95,6,88,76,0,12,1,119,28,84,36,226,0,
		95,7,88,79,0,95,6,88,76,0,8,28,68,85,
		95,7,74,176,71,0,12,0,119,31,56,36,227,0,
		176,82,0,85,95,7,74,176,83,0,12,0,119,20,
		1,36,228,0,176,74,0,95,7,95,3,120,20,3,
		36,229,0,176,80,0,20,0,36,230,0,85,95,7,
		74,176,81,0,20,0,74,25,176,36,236,0,176,80,
		0,20,0,36,238,0,85,95,6,74,176,81,0,20,
		0,74,36,240,0,176,66,0,48,67,0,48,40,0,
		102,112,0,112,0,12,1,32,108,254,36,241,0,48,
		84,0,48,67,0,48,40,0,102,112,0,112,0,85,
		95,6,74,176,83,0,12,0,119,112,1,73,26,75,
		254,36,244,0,114,68,0,0,36,246,0,115,80,10,
		36,248,0,176,85,0,176,86,0,95,10,12,1,106,
		41,73,109,112,111,115,105,98,108,101,32,97,98,114,
		105,114,32,116,111,100,97,115,32,108,97,115,32,98,
		97,115,101,115,32,100,101,32,100,97,116,111,115,0,
		20,2,36,251,0,176,50,0,95,11,20,1,36,253,
		0,48,87,0,95,13,112,0,73,36,254,0,48,88,
		0,95,13,112,0,73,36,0,1,85,95,2,74,176,
		89,0,20,0,74,36,1,1,85,95,4,74,176,89,
		0,20,0,74,36,2,1,85,95,5,74,176,89,0,
		20,0,74,36,3,1,85,95,6,74,176,89,0,20,
		0,74,36,4,1,85,95,7,74,176,89,0,20,0,
		74,36,5,1,85,95,8,74,176,89,0,20,0,74,
		36,6,1,85,95,9,74,176,89,0,20,0,74,36,
		10,1,95,1,29,165,0,36,12,1,48,49,0,48,
		40,0,102,112,0,106,25,67,111,109,112,114,105,109,
		105,101,110,100,111,32,99,108,105,101,110,116,101,115,
		32,58,32,0,95,12,72,112,1,73,36,14,1,48,
		90,0,48,40,0,102,112,0,95,12,112,1,28,48,
		36,15,1,48,49,0,48,40,0,102,112,0,106,24,
		70,105,99,104,101,114,111,115,32,99,111,109,112,114,
		105,109,105,100,111,115,32,58,32,0,95,12,72,112,
		1,73,25,100,36,17,1,48,49,0,48,40,0,102,
		112,0,106,34,69,82,82,79,82,32,97,108,32,99,
		114,101,97,114,32,102,105,99,104,101,114,111,32,99,
		111,109,112,114,105,109,105,100,111,0,112,1,73,25,
		47,36,22,1,48,49,0,48,40,0,102,112,0,106,
		28,78,111,32,104,97,121,32,99,108,105,101,110,116,
		101,115,32,112,97,114,97,32,101,110,118,105,97,114,
		0,112,1,73,36,26,1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCLIENTESENDERRECIVER_RESTOREDATA )
{
	static const HB_BYTE pcode[] =
	{
		13,3,0,36,36,1,176,50,0,89,15,0,1,0,
		0,0,176,51,0,95,1,12,1,6,12,1,80,2,
		36,37,1,113,201,0,0,36,39,1,48,91,0,102,
		112,0,29,181,0,36,41,1,176,52,0,120,176,53,
		0,12,0,176,54,0,12,0,106,11,67,76,73,69,
		78,84,46,68,66,70,0,72,176,55,0,106,7,67,
		76,73,69,78,84,0,96,3,0,12,2,120,9,20,
		6,36,42,1,176,56,0,12,0,31,28,176,57,0,
		176,54,0,12,0,106,11,67,76,73,69,78,84,46,
		67,68,88,0,72,20,1,25,8,176,58,0,122,20,
		1,36,44,1,85,95,3,74,176,71,0,12,0,119,
		31,58,36,46,1,95,3,88,72,0,28,33,176,92,
		0,95,3,12,1,28,24,36,47,1,9,95,3,77,
		72,0,36,48,1,85,95,3,74,176,93,0,20,0,
		74,36,51,1,85,95,3,74,176,81,0,20,0,74,
		25,187,36,55,1,85,95,3,74,176,89,0,20,0,
		74,36,57,1,114,68,0,0,36,59,1,115,80,1,
		36,61,1,176,85,0,176,86,0,95,1,12,1,106,
		41,73,109,112,111,115,105,98,108,101,32,97,98,114,
		105,114,32,116,111,100,97,115,32,108,97,115,32,98,
		97,115,101,115,32,100,101,32,100,97,116,111,115,0,
		20,2,36,64,1,176,50,0,95,2,20,1,36,66,
		1,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCLIENTESENDERRECIVER_SENDDATA )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,74,1,48,39,0,48,40,0,102,112,
		0,112,0,28,37,36,75,1,106,4,67,108,105,0,
		176,37,0,48,38,0,102,112,0,92,6,12,2,72,
		106,5,46,65,108,108,0,72,80,1,25,38,36,77,
		1,106,4,67,108,105,0,176,37,0,48,38,0,102,
		112,0,92,6,12,2,72,106,2,46,0,72,176,41,
		0,12,0,72,80,1,36,84,1,176,94,0,176,95,
		0,12,0,95,1,72,12,1,29,157,0,36,86,1,
		48,96,0,48,40,0,102,112,0,176,95,0,12,0,
		95,1,72,95,1,112,2,28,76,36,87,1,48,97,
		0,102,112,0,73,36,88,1,48,29,0,102,120,112,
		1,73,36,89,1,48,49,0,48,40,0,102,112,0,
		106,31,70,105,99,104,101,114,111,115,32,100,101,32,
		99,108,105,101,110,116,101,115,32,101,110,118,105,97,
		100,111,115,32,0,95,1,72,112,1,73,25,56,36,
		91,1,48,49,0,48,40,0,102,112,0,106,37,69,
		82,82,79,82,32,102,105,99,104,101,114,111,32,100,
		101,32,99,108,105,101,110,116,101,115,32,110,111,32,
		101,110,118,105,97,100,111,0,112,1,73,36,96,1,
		102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCLIENTESENDERRECIVER_RECIVEDATA )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,36,109,1,48,39,0,48,40,0,102,112,
		0,112,0,28,14,36,110,1,176,98,0,12,0,80,
		2,25,16,36,112,1,106,4,65,108,108,0,4,1,
		0,80,2,36,115,1,48,49,0,48,40,0,102,112,
		0,106,20,82,101,99,105,98,105,101,110,100,111,32,
		99,108,105,101,110,116,101,115,0,112,1,73,36,117,
		1,122,165,80,1,25,42,36,118,1,48,99,0,48,
		40,0,102,112,0,106,6,67,108,105,42,46,0,95,
		2,95,1,1,72,176,100,0,12,0,112,2,73,36,
		117,1,175,1,0,176,101,0,95,2,12,1,15,28,
		208,36,121,1,48,49,0,48,40,0,102,112,0,106,
		19,67,108,105,101,110,116,101,115,32,114,101,99,105,
		98,105,100,111,115,0,112,1,73,36,123,1,102,110,
		7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCLIENTESENDERRECIVER_PROCESS )
{
	static const HB_BYTE pcode[] =
	{
		13,12,0,36,138,1,176,102,0,176,100,0,12,0,
		106,7,67,108,105,42,46,42,0,72,12,1,80,10,
		36,146,1,122,165,80,1,26,85,11,36,148,1,176,
		50,0,89,15,0,1,0,0,0,176,51,0,95,1,
		12,1,6,12,1,80,11,36,149,1,113,111,10,0,
		36,151,1,48,49,0,48,40,0,102,112,0,106,22,
		80,114,111,99,101,115,97,110,100,111,32,102,105,99,
		104,101,114,111,32,58,32,0,95,10,95,1,1,122,
		1,72,112,1,73,36,153,1,176,103,0,176,100,0,
		12,0,95,10,95,1,1,122,1,72,12,1,121,15,
		29,255,9,36,159,1,48,104,0,48,40,0,102,112,
		0,176,100,0,12,0,95,10,95,1,1,122,1,72,
		112,1,29,176,9,36,164,1,176,105,0,176,60,0,
		12,0,106,11,67,108,105,101,110,116,46,68,98,102,
		0,72,176,61,0,12,0,12,2,29,54,8,176,105,
		0,176,60,0,12,0,106,11,67,108,105,65,116,112,
		46,68,98,102,0,72,176,61,0,12,0,12,2,29,
		22,8,176,105,0,176,60,0,12,0,106,11,79,98,
		114,97,115,84,46,68,98,102,0,72,176,61,0,12,
		0,12,2,29,246,7,176,105,0,176,60,0,12,0,
		106,11,67,108,105,67,116,111,46,68,98,102,0,72,
		176,61,0,12,0,12,2,29,214,7,36,166,1,176,
		52,0,120,176,61,0,12,0,176,60,0,12,0,106,
		11,67,108,105,101,110,116,46,68,98,102,0,72,176,
		55,0,106,7,67,108,105,101,110,116,0,96,2,0,
		12,2,9,20,5,36,168,1,176,52,0,120,176,61,
		0,12,0,176,60,0,12,0,106,11,67,108,105,65,
		116,112,46,68,98,102,0,72,176,55,0,106,7,67,
		108,105,65,116,112,0,96,3,0,12,2,9,20,5,
		36,170,1,176,52,0,120,176,61,0,12,0,176,60,
		0,12,0,106,11,79,98,114,97,115,84,46,68,98,
		102,0,72,176,55,0,106,7,79,98,114,97,115,84,
		0,96,4,0,12,2,9,20,5,36,172,1,176,52,
		0,120,176,61,0,12,0,176,60,0,12,0,106,11,
		67,108,105,67,116,111,46,68,98,102,0,72,176,55,
		0,106,9,67,108,105,67,111,110,116,97,0,96,5,
		0,12,2,9,20,5,36,174,1,176,52,0,120,176,
		53,0,12,0,176,54,0,12,0,106,11,67,76,73,
		69,78,84,46,68,66,70,0,72,176,55,0,106,7,
		67,76,73,69,78,84,0,96,6,0,12,2,120,9,
		20,6,36,175,1,176,56,0,12,0,31,28,176,57,
		0,176,54,0,12,0,106,11,67,76,73,69,78,84,
		46,67,68,88,0,72,20,1,25,8,176,58,0,122,
		20,1,36,177,1,176,52,0,120,176,53,0,12,0,
		176,54,0,12,0,106,11,67,108,105,65,116,112,46,
		68,98,102,0,72,176,55,0,106,7,67,76,73,65,
		84,80,0,96,7,0,12,2,120,9,20,6,36,178,
		1,176,56,0,12,0,31,28,176,57,0,176,54,0,
		12,0,106,11,67,108,105,65,116,112,46,67,100,120,
		0,72,20,1,25,8,176,58,0,122,20,1,36,179,
		1,176,58,0,106,8,99,67,108,105,65,114,116,0,
		20,1,36,181,1,176,52,0,120,176,53,0,12,0,
		176,54,0,12,0,106,11,79,98,114,97,115,84,46,
		68,98,102,0,72,176,55,0,106,7,79,66,82,65,
		83,84,0,96,8,0,12,2,120,9,20,6,36,182,
		1,176,56,0,12,0,31,28,176,57,0,176,54,0,
		12,0,106,11,79,98,114,97,115,84,46,67,100,120,
		0,72,20,1,25,8,176,58,0,122,20,1,36,184,
		1,176,52,0,120,176,53,0,12,0,176,54,0,12,
		0,106,11,67,108,105,67,116,111,46,68,98,102,0,
		72,176,55,0,106,9,67,76,73,67,79,78,84,65,
		0,96,9,0,12,2,120,9,20,6,36,185,1,176,
		56,0,12,0,31,28,176,57,0,176,54,0,12,0,
		106,11,67,108,105,67,116,111,46,67,100,120,0,72,
		20,1,25,8,176,58,0,122,20,1,36,187,1,176,
		66,0,48,67,0,48,40,0,102,112,0,112,0,12,
		1,31,32,36,188,1,48,68,0,48,67,0,48,40,
		0,102,112,0,112,0,85,95,2,74,176,69,0,12,
		0,119,112,1,73,36,191,1,85,95,2,74,176,70,
		0,20,0,74,36,192,1,85,95,2,74,176,71,0,
		12,0,119,32,141,1,36,194,1,85,95,6,74,176,
		78,0,95,2,88,76,0,12,1,119,29,203,0,36,
		196,1,48,39,0,48,40,0,102,112,0,112,0,32,
		129,0,36,198,1,176,74,0,95,2,95,6,9,20,
		3,36,200,1,176,92,0,95,6,12,1,28,24,36,
		201,1,9,95,6,77,72,0,36,202,1,85,95,6,
		74,176,93,0,20,0,74,36,205,1,48,49,0,48,
		40,0,102,112,0,106,15,82,101,101,109,112,108,97,
		122,97,100,111,32,58,32,0,176,75,0,95,2,88,
		76,0,12,1,72,106,3,59,32,0,72,95,2,88,
		77,0,72,112,1,73,36,207,1,48,106,0,102,95,
		2,88,76,0,95,7,95,8,95,9,112,4,73,26,
		158,0,36,211,1,48,49,0,48,40,0,102,112,0,
		106,15,68,101,115,101,115,116,105,109,97,100,111,32,
		58,32,0,176,75,0,95,2,88,76,0,12,1,72,
		106,3,59,32,0,72,95,2,88,77,0,72,112,1,
		73,25,100,36,217,1,176,74,0,95,2,95,6,120,
		20,3,36,218,1,176,92,0,95,6,12,1,28,24,
		36,219,1,9,95,6,77,72,0,36,220,1,85,95,
		6,74,176,93,0,20,0,74,36,222,1,48,49,0,
		48,40,0,102,112,0,106,11,65,241,97,100,105,100,
		111,32,58,32,0,176,75,0,95,2,88,76,0,12,
		1,72,106,3,59,32,0,72,95,2,88,77,0,72,
		112,1,73,36,227,1,85,95,2,74,176,81,0,20,
		0,74,36,229,1,176,66,0,48,67,0,48,40,0,
		102,112,0,112,0,12,1,31,32,36,230,1,48,84,
		0,48,67,0,48,40,0,102,112,0,112,0,85,95,
		2,74,176,107,0,12,0,119,112,1,73,36,233,1,
		176,80,0,20,0,26,105,254,36,237,1,176,66,0,
		48,67,0,48,40,0,102,112,0,112,0,12,1,31,
		32,36,238,1,48,68,0,48,67,0,48,40,0,102,
		112,0,112,0,85,95,3,74,176,69,0,12,0,119,
		112,1,73,36,241,1,85,95,3,74,176,70,0,20,
		0,74,36,242,1,85,95,3,74,176,71,0,12,0,
		119,32,123,1,36,244,1,85,95,7,74,176,78,0,
		95,3,88,79,0,95,3,88,108,0,72,12,1,119,
		29,191,0,36,245,1,48,39,0,48,40,0,102,112,
		0,112,0,31,95,36,246,1,176,74,0,95,3,95,
		7,9,20,3,36,247,1,48,49,0,48,40,0,102,
		112,0,106,15,82,101,101,109,112,108,97,122,97,100,
		111,32,58,32,0,176,75,0,95,3,88,79,0,12,
		1,72,106,3,59,32,0,72,176,75,0,95,3,88,
		108,0,12,1,72,106,3,59,32,0,72,176,75,0,
		95,3,88,109,0,12,1,72,112,1,73,26,168,0,
		36,249,1,48,49,0,48,40,0,102,112,0,106,15,
		68,101,115,101,115,116,105,109,97,100,111,32,58,32,
		0,176,75,0,95,3,88,79,0,12,1,72,106,3,
		59,32,0,72,176,75,0,95,3,88,108,0,12,1,
		72,106,3,59,32,0,72,176,75,0,95,3,88,109,
		0,12,1,72,112,1,73,25,88,36,252,1,176,74,
		0,95,3,95,7,120,20,3,36,253,1,48,49,0,
		48,40,0,102,112,0,106,11,65,241,97,100,105,100,
		111,32,58,32,0,176,75,0,95,3,88,79,0,12,
		1,72,106,3,59,32,0,72,176,75,0,95,3,88,
		108,0,12,1,72,106,3,59,32,0,72,176,75,0,
		95,3,88,109,0,12,1,72,112,1,73,36,0,2,
		85,95,3,74,176,81,0,20,0,74,36,2,2,176,
		66,0,48,67,0,48,40,0,102,112,0,112,0,12,
		1,31,32,36,3,2,48,84,0,48,67,0,48,40,
		0,102,112,0,112,0,85,95,3,74,176,107,0,12,
		0,119,112,1,73,36,6,2,176,80,0,20,0,26,
		123,254,36,10,2,85,95,4,74,176,70,0,20,0,
		74,36,11,2,85,95,4,74,176,71,0,12,0,119,
		32,148,0,36,13,2,85,95,8,74,176,78,0,95,
		4,88,79,0,95,4,88,110,0,72,12,1,119,28,
		33,36,14,2,48,39,0,48,40,0,102,112,0,112,
		0,31,30,36,15,2,176,74,0,95,4,95,8,9,
		20,3,25,15,36,18,2,176,74,0,95,4,95,8,
		120,20,3,36,21,2,85,95,4,74,176,81,0,20,
		0,74,36,23,2,176,66,0,48,67,0,48,40,0,
		102,112,0,112,0,12,1,31,32,36,24,2,48,84,
		0,48,67,0,48,40,0,102,112,0,112,0,85,95,
		4,74,176,107,0,12,0,119,112,1,73,36,27,2,
		176,80,0,20,0,26,98,255,36,31,2,85,95,5,
		74,176,70,0,20,0,74,36,32,2,85,95,5,74,
		176,71,0,12,0,119,32,142,0,36,34,2,85,95,
		8,74,176,78,0,95,5,88,79,0,12,1,119,28,
		33,36,35,2,48,39,0,48,40,0,102,112,0,112,
		0,31,30,36,36,2,176,74,0,95,5,95,9,9,
		20,3,25,15,36,39,2,176,74,0,95,5,95,9,
		120,20,3,36,42,2,85,95,5,74,176,81,0,20,
		0,74,36,44,2,176,66,0,48,67,0,48,40,0,
		102,112,0,112,0,12,1,31,32,36,45,2,48,84,
		0,48,67,0,48,40,0,102,112,0,112,0,85,95,
		5,74,176,107,0,12,0,119,112,1,73,36,48,2,
		176,80,0,20,0,26,104,255,36,52,2,85,95,2,
		74,176,89,0,20,0,74,36,53,2,85,95,3,74,
		176,89,0,20,0,74,36,54,2,85,95,4,74,176,
		89,0,20,0,74,36,55,2,85,95,5,74,176,89,
		0,20,0,74,36,56,2,85,95,6,74,176,89,0,
		20,0,74,36,57,2,85,95,7,74,176,89,0,20,
		0,74,36,58,2,85,95,8,74,176,89,0,20,0,
		74,36,59,2,85,95,9,74,176,89,0,20,0,74,
		36,61,2,48,111,0,48,40,0,102,112,0,95,10,
		95,1,1,122,1,112,1,73,26,170,1,36,65,2,
		48,49,0,48,40,0,102,112,0,106,16,70,97,108,
		116,97,110,32,102,105,99,104,101,114,111,115,0,112,
		1,73,36,67,2,176,105,0,176,60,0,12,0,106,
		11,67,108,105,101,110,116,46,68,98,102,0,72,176,
		61,0,12,0,12,2,31,45,36,68,2,48,49,0,
		48,40,0,102,112,0,106,6,70,97,108,116,97,0,
		176,60,0,12,0,72,106,11,67,108,105,101,110,116,
		46,68,98,102,0,72,112,1,73,36,71,2,176,105,
		0,176,60,0,12,0,106,11,67,108,105,65,116,112,
		46,68,98,102,0,72,176,61,0,12,0,12,2,31,
		45,36,72,2,48,49,0,48,40,0,102,112,0,106,
		6,70,97,108,116,97,0,176,60,0,12,0,72,106,
		11,67,108,105,65,116,112,46,68,98,102,0,72,112,
		1,73,36,75,2,176,105,0,176,60,0,12,0,106,
		11,79,98,114,97,115,84,46,68,98,102,0,72,176,
		61,0,12,0,12,2,31,45,36,76,2,48,49,0,
		48,40,0,102,112,0,106,6,70,97,108,116,97,0,
		176,60,0,12,0,72,106,11,79,98,114,97,115,84,
		46,68,98,102,0,72,112,1,73,36,79,2,176,105,
		0,176,60,0,12,0,106,11,67,108,105,67,116,111,
		46,68,98,102,0,72,176,61,0,12,0,12,2,31,
		45,36,80,2,48,49,0,48,40,0,102,112,0,106,
		6,70,97,108,116,97,0,176,60,0,12,0,72,106,
		11,67,108,105,67,116,111,46,68,98,102,0,72,112,
		1,73,25,82,36,87,2,48,49,0,48,40,0,102,
		112,0,106,30,69,114,114,111,114,32,101,110,32,102,
		105,99,104,101,114,111,115,32,99,111,109,112,114,105,
		109,105,100,111,115,0,112,1,73,25,33,36,93,2,
		48,49,0,48,40,0,102,112,0,106,14,70,105,99,
		104,101,114,111,32,118,97,99,105,111,0,112,1,73,
		36,95,2,114,187,0,0,36,97,2,115,80,12,36,
		99,2,85,95,2,74,176,89,0,20,0,74,36,100,
		2,85,95,3,74,176,89,0,20,0,74,36,101,2,
		85,95,4,74,176,89,0,20,0,74,36,102,2,85,
		95,5,74,176,89,0,20,0,74,36,103,2,85,95,
		6,74,176,89,0,20,0,74,36,104,2,85,95,7,
		74,176,89,0,20,0,74,36,105,2,85,95,8,74,
		176,89,0,20,0,74,36,106,2,85,95,9,74,176,
		89,0,20,0,74,36,108,2,48,49,0,48,40,0,
		102,112,0,106,26,69,114,114,111,114,32,112,114,111,
		99,101,115,97,110,100,111,32,102,105,99,104,101,114,
		111,32,0,95,10,95,1,1,122,1,72,112,1,73,
		36,109,2,48,49,0,48,40,0,102,112,0,176,86,
		0,95,12,12,1,112,1,73,36,112,2,176,50,0,
		95,11,20,1,36,146,1,175,1,0,176,101,0,95,
		10,12,1,15,29,166,244,36,116,2,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( TCLIENTESENDERRECIVER_CLEANRELATION )
{
	static const HB_BYTE pcode[] =
	{
		13,0,4,36,122,2,85,95,2,74,176,78,0,95,
		1,12,1,119,28,14,36,123,2,176,112,0,95,2,
		20,1,25,229,36,126,2,176,80,0,20,0,36,128,
		2,85,95,3,74,176,78,0,95,1,12,1,119,28,
		14,36,129,2,176,112,0,95,3,20,1,25,229,36,
		132,2,176,80,0,20,0,36,134,2,85,95,4,74,
		176,78,0,95,1,12,1,119,28,14,36,135,2,176,
		112,0,95,4,20,1,25,229,36,138,2,176,80,0,
		20,0,36,140,2,102,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITSTATICS()
{
	static const HB_BYTE pcode[] =
	{
		117,115,0,3,0,116,115,0,4,0,0,82,1,0,
		7
	};

	hb_vmExecute( pcode, symbols );
}

